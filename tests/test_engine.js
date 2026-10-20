// Pruebas del motor en Node con stubs de la API de Max (outlet, Global, jsarguments).
// Uso: node tests/test_engine.js

"use strict";

var fs = require("fs");
var path = require("path");
var vm = require("vm");
var assert = require("assert");

var SRC = fs.readFileSync(path.join(__dirname, "..", "inverter_engine.js"), "utf8");

// carga una instancia nueva del motor con reloj controlado
function load() {
    var globals = {};
    var out = [];
    var clock = { t: 1000000 };
    function FakeDate() {}
    FakeDate.now = function () { return clock.t; };

    var ctx = {
        jsarguments: ["inverter_engine.js", "1234mi"],
        outlet: function () { out.push(Array.prototype.slice.call(arguments)); },
        Global: function (name) {
            if (!globals[name]) globals[name] = {};
            return globals[name];
        },
        post: function () {},
        Date: FakeDate,
        Math: Math
    };
    vm.createContext(ctx);
    vm.runInContext(SRC, ctx, { filename: "inverter_engine.js" });
    return {
        ctx: ctx,
        out: out,
        clock: clock,
        state: function () { return globals["midiinverter_1234mi"].state; },
        advance: function (ms) { clock.t += ms; },
        clear: function () { out.length = 0; }
    };
}

// mensajes de un outlet concreto, sin el índice
function outOf(out, n) {
    return out.filter(function (m) { return m[0] === n; }).map(function (m) { return m.slice(1); });
}
function notesOf(out) { return outOf(out, 0); }

// toca una nota y devuelve las notas de salida que se encienden
function play(e, p, v) {
    e.clear();
    e.ctx.note(p, v === undefined ? 100 : v);
    return notesOf(e.out).filter(function (m) { return m[1] > 0; }).map(function (m) { return m[0]; });
}

// lo que suena ahora mismo: note-ons menos note-offs de todo lo que ha salido
function sounding(all) {
    var on = {};
    notesOf(all).forEach(function (m) {
        if (m[1] > 0) on[m[0]] = (on[m[0]] || 0) + 1;
        else delete on[m[0]];
    });
    return Object.keys(on).map(Number).sort(function (a, b) { return a - b; });
}

var tests = [];
function test(name, fn) { tests.push({ name: name, fn: fn }); }

// ---------------------------------------------------------------------------

test("por defecto, eje en C3: C4 -> C2, E3 -> G#2, C3 se queda", function () {
    var e = load();
    assert.deepStrictEqual(play(e, 72), [48]);
    assert.deepStrictEqual(play(e, 64), [56]);
    assert.deepStrictEqual(play(e, 60), [60]);
    assert.strictEqual(e.state().axisLabel, "C3");
});

test("un acorde mayor sale menor (C E G -> C G# F = Fa menor)", function () {
    var e = load();
    var out = [60, 64, 67].map(function (p) { return play(e, p)[0]; });
    assert.deepStrictEqual(out.sort(), [53, 56, 60]);
});

test("note-off apaga la nota que se disparó aunque el eje se haya movido", function () {
    var e = load();
    var all = [];
    e.ctx.note(72, 100);
    all = all.concat(e.out.slice());
    e.clear();
    e.ctx.axis(62);
    e.ctx.note(72, 0);
    all = all.concat(e.out.slice());
    assert.deepStrictEqual(notesOf(e.out), [[48, 0]], "apaga la C2 que sonaba, no la nueva");
    assert.deepStrictEqual(sounding(all), []);
    assert.deepStrictEqual(play(e, 72), [52], "las siguientes ya usan el eje nuevo");
});

test("dos entradas que caen en la misma salida: solo se apaga al soltar las dos", function () {
    var e = load();
    e.ctx.output(1);                 // Both: 72 da 48 y 72; 48 da 72 y 48
    e.ctx.note(72, 100);
    e.ctx.note(48, 100);
    e.clear();
    e.ctx.note(72, 0);
    assert.deepStrictEqual(notesOf(e.out), [], "48 y 72 siguen pulsadas por la otra nota");
    e.ctx.note(48, 0);
    assert.deepStrictEqual(notesOf(e.out).map(function (m) { return m[0]; }).sort(), [48, 72]);
    assert.ok(notesOf(e.out).every(function (m) { return m[1] === 0; }));
});

test("note-on repetido sin note-off no deja notas colgadas", function () {
    var e = load();
    var all = [];
    e.ctx.note(72, 100); all = all.concat(e.out.slice()); e.clear();
    e.ctx.note(72, 90); all = all.concat(e.out.slice()); e.clear();
    e.ctx.note(72, 0); all = all.concat(e.out.slice());
    assert.deepStrictEqual(sounding(all), []);
});

test("Between: el eje queda entre C3 y C#3", function () {
    var e = load();
    e.ctx.half(1);
    assert.deepStrictEqual(play(e, 60), [61]);
    assert.deepStrictEqual(play(e, 61), [60]);
    assert.deepStrictEqual(play(e, 72), [49]);
    assert.strictEqual(e.state().axisLabel, "C3–C#3");
    assert.strictEqual(e.state().center, 60.5);
});

test("fuera de 0..127 se mueve de octava y conserva el nombre de la nota", function () {
    var e = load();
    e.ctx.axis(10);
    var o = play(e, 100)[0];         // 2*10 - 100 = -80 -> 4 (E-2)
    assert.strictEqual(o, 4);
    assert.strictEqual(((o - -80) % 12), 0);
    e.ctx.axis(120);
    o = play(e, 10)[0];              // 230 -> 122
    assert.strictEqual(o, 122);
    for (var a = 0; a <= 127; a += 7) {
        e.ctx.axis(a);
        for (var p = 0; p <= 127; p += 5) {
            var m = play(e, p)[0];
            assert.ok(m >= 0 && m <= 127, a + "/" + p + " -> " + m);
            e.ctx.note(p, 0);
        }
    }
});

test("Low/High: lo de fuera pasa sin tocar", function () {
    var e = load();
    e.ctx.low(48); e.ctx.high(72);
    assert.deepStrictEqual(play(e, 40), [40]);
    assert.deepStrictEqual(play(e, 80), [80]);
    assert.deepStrictEqual(play(e, 72), [48]);
    e.ctx.low(72); e.ctx.high(48);   // al revés también vale
    assert.deepStrictEqual(play(e, 40), [40]);
    assert.deepStrictEqual(play(e, 71), [49]);
});

test("Both: suena la original y la reflejada; en el eje, una sola", function () {
    var e = load();
    e.ctx.output(1);
    assert.deepStrictEqual(play(e, 72).sort(), [48, 72]);
    assert.deepStrictEqual(play(e, 60), [60]);
});

test("Velocity Flip: solo en las reflejadas", function () {
    var e = load();
    e.ctx.flipvel(1);
    e.ctx.output(1);
    e.clear();
    e.ctx.note(72, 100);
    var n = notesOf(e.out);
    assert.deepStrictEqual(n.filter(function (m) { return m[0] === 48; })[0], [48, 28]);
    assert.deepStrictEqual(n.filter(function (m) { return m[0] === 72; })[0], [72, 100]);
    e.clear();
    e.ctx.note(50, 127);
    assert.deepStrictEqual(notesOf(e.out)[0], [70, 1]);
    e.clear();
    e.ctx.note(51, 1);
    assert.deepStrictEqual(notesOf(e.out)[0], [69, 127]);
});

test("Scale: Do mayor con eje en C3 refleja por grados y no sale de la escala", function () {
    var e = load();
    e.ctx.mode(1); e.ctx.tonic(0); e.ctx.scale(0);
    assert.deepStrictEqual(play(e, 62), [59]);    // D3 (+1 grado) -> B2 (-1 grado)
    assert.deepStrictEqual(play(e, 64), [57]);    // E3 (+2) -> A2 (-2)
    assert.deepStrictEqual(play(e, 65), [55]);    // F3 (+3) -> G2 (-3)
    assert.deepStrictEqual(play(e, 72), [48]);    // C4 (+7, una octava) -> C2
    var major = [0, 2, 4, 5, 7, 9, 11];
    for (var p = 0; p <= 127; p++) {
        var m = play(e, p)[0];
        e.ctx.note(p, 0);
        assert.ok(major.indexOf(m % 12) >= 0, p + " -> " + m);
    }
});

test("Scale: una nota fuera de la escala se ajusta al grado más cercano (empate: abajo)", function () {
    var e = load();
    e.ctx.mode(1); e.ctx.scale(0);
    assert.deepStrictEqual(play(e, 61), [60]);    // C#3 -> C3 -> C3
    assert.deepStrictEqual(play(e, 63), [59]);    // D#3 -> D3 -> B2
    e.ctx.scale(7);                               // pentatónica mayor: 0 2 4 7 9
    assert.deepStrictEqual(play(e, 71), [48]);    // B3 -> C4 (a 1) -> C2
});

test("Scale: el eje se ajusta a la escala y Between va entre dos grados", function () {
    var e = load();
    e.ctx.mode(1); e.ctx.scale(0); e.ctx.tonic(0);
    e.ctx.axis(61);                                // C#3 -> C3
    assert.strictEqual(e.state().axisLabel, "C3");
    e.ctx.axis(64); e.ctx.half(1);                 // entre E3 y F3
    assert.strictEqual(e.state().axisLabel, "E3–F3");
    assert.strictEqual(e.state().center, 64.5);
    assert.deepStrictEqual(play(e, 64), [65]);
    assert.deepStrictEqual(play(e, 67), [62]);     // G3 (+2 grados desde F) -> D3
});

test("Scale con otra tónica: La menor, eje A2", function () {
    var e = load();
    e.ctx.mode(1); e.ctx.tonic(9); e.ctx.scale(1); e.ctx.axis(57);
    assert.deepStrictEqual(play(e, 60), [53]);     // C3 (+2 grados) -> F2 (-2)
    assert.deepStrictEqual(play(e, 69), [45]);     // A3 -> A1
});

test("presión polifónica sigue a las notas reflejadas", function () {
    var e = load();
    e.ctx.output(1);
    e.ctx.note(72, 100);
    e.clear();
    e.ctx.pressure(72, 50);
    assert.deepStrictEqual(outOf(e.out, 3).sort(), [[48, 50], [72, 50]]);
    e.clear();
    e.ctx.pressure(30, 50);
    assert.deepStrictEqual(outOf(e.out, 3), [], "sin nota pulsada no hay nada que seguir");
});

test("panic apaga todo", function () {
    var e = load();
    var all = [];
    e.ctx.output(1);
    [60, 64, 67, 72].forEach(function (p) { e.ctx.note(p, 100); });
    all = all.concat(e.out.slice()); e.clear();
    e.ctx.panic();
    all = all.concat(e.out.slice());
    assert.deepStrictEqual(sounding(all), []);
    e.clear();
    e.ctx.note(72, 0);
    assert.deepStrictEqual(notesOf(e.out), [], "después del panic, el note-off no manda nada");
});

test("estado para la UI: enlaces de entrada a salida que se apagan al soltar", function () {
    var e = load();
    e.ctx.note(72, 100);
    var L = e.state().links;
    assert.strictEqual(L.length, 1);
    assert.strictEqual(L[0].i, 72);
    assert.strictEqual(L[0].o, 48);
    assert.ok(L[0].on);
    e.advance(100);
    e.ctx.note(72, 0);
    assert.ok(!e.state().links[0].on);
    e.advance(1000);
    e.ctx.note(60, 100);
    assert.strictEqual(e.state().links.length, 1, "los enlaces viejos se limpian");
    assert.ok(outOf(e.out, 1).length > 0, "pide repintar");
});

test("texto del knob Axis", function () {
    var e = load();
    e.clear();
    e.ctx.axis(73);
    assert.deepStrictEqual(outOf(e.out, 2), [["axis", "C#4"]]);
    e.ctx.axis(127); e.ctx.half(1);
    assert.strictEqual(e.state().axisLabel, "G8", "no hay nota por encima de 127");
});

// ---------------------------------------------------------------------------

var failed = 0;
tests.forEach(function (t) {
    try {
        t.fn();
        console.log("ok   " + t.name);
    } catch (err) {
        failed++;
        console.log("FAIL " + t.name);
        console.log("     " + (err && err.message));
    }
});
console.log("\n" + (tests.length - failed) + "/" + tests.length + " pruebas correctas");
process.exit(failed ? 1 : 0);
