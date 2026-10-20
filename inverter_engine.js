// inverter_engine.js
// Motor de midi-inverter: refleja cada nota alrededor de un eje, en tiempo real.
// Corre en [js inverter_engine.js ---mi]. ES5 para el motor [js] clásico de Max.
//
// Entrada (inlet 0):
//   note p v          nota de la entrada MIDI (v = 0 es note-off)
//   pressure p v      presión polifónica: sigue a la nota reflejada
//   panic             note-off de todo lo que suena (dispositivo desactivado)
//   axis / half / mode / tonic / scale / low / high / output / flipvel <valor>
// Salida:
//   outlet 0          pitch velocity          ->  [midiformat] (inlet 0)
//   outlet 1          draw <nombreGlobal>     ->  [jsui inverter_ui.js]
//   outlet 2          texto del valor del knob Axis ("axis C3", "axis C3–C#3")
//   outlet 3          pitch presión           ->  [midiformat] (inlet 1)
//
// Cada nota de entrada recuerda las notas que disparó, y su note-off apaga esas:
// se puede mover el eje o cambiar de modo con notas pulsadas sin dejar ninguna
// colgada. Si dos notas de entrada acaban en la misma nota de salida, esta solo
// se apaga cuando se sueltan las dos.

autowatch = 0;
inlets = 1;
outlets = 4;

var NOTE_NAMES = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];

var SCALES = [
    [0, 2, 4, 5, 7, 9, 11],         // Mayor
    [0, 2, 3, 5, 7, 8, 10],         // Menor
    [0, 2, 3, 5, 7, 9, 10],         // Dórica
    [0, 1, 3, 5, 7, 8, 10],         // Frigia
    [0, 2, 4, 6, 7, 9, 11],         // Lidia
    [0, 2, 4, 5, 7, 9, 10],         // Mixolidia
    [0, 2, 3, 5, 7, 8, 11],         // Menor armónica
    [0, 2, 4, 7, 9],                // Pentatónica mayor
    [0, 3, 5, 7, 10],               // Pentatónica menor
    [0, 3, 5, 6, 7, 10]             // Blues
];

var LINK_LIFE = 600;        // ms que tarda en apagarse en la UI una nota soltada
var MAX_LINKS = 64;

// ---------------------------------------------------------------------------
// Global compartido con la UI. M4L sustituye "---" por un ID único por instancia;
// fuera de Live no se sustituye, así que añadimos un sufijo aleatorio.

var instanceId = (typeof jsarguments !== "undefined" && jsarguments.length > 1) ? String(jsarguments[1]) : "mi";
if (instanceId.indexOf("---") === 0) {
    instanceId = instanceId.substring(3) + "_" + Math.floor(Math.random() * 1e9);
}
var GNAME = "midiinverter_" + instanceId;
var shared = new Global(GNAME);

// parámetros
var P = {
    axis: 60,       // C3 en Live: C4 -> C2
    half: 0,        // 1: el eje queda entre Axis y la nota (o el grado) siguiente
    mode: 0,        // 0 Chromatic, 1 Scale
    tonic: 0,
    scale: 0,       // Mayor
    low: 0,
    high: 127,
    output: 0,      // 0 Mirror, 1 Both (la original y la reflejada)
    flipvel: 0      // 1: velocity reflejada (fuerte <-> suave) en las notas reflejadas
};

// estado que lee la UI (las listas se sustituyen enteras, nunca a medias)
var S = {
    center: 60,     // eje en notas (puede acabar en .5)
    mode: 0,
    tonic: 0,
    scale: 0,
    low: 0,
    high: 127,
    links: [],      // {i, o, v, on, t, off}: nota de entrada -> nota de salida
    axisLabel: "C3"
};
shared.state = S;

var active = {};    // nota de entrada -> [notas de salida que disparó]
var count = {};     // nota de salida -> cuántas notas de entrada la mantienen

function now() {
    return Date.now();
}

function clamp(v, lo, hi) {
    return v < lo ? lo : (v > hi ? hi : v);
}

function noteName(n) {
    return NOTE_NAMES[n % 12] + (Math.floor(n / 12) - 2);   // convención de Live: C3 = 60
}

// ---------------------------------------------------------------------------
// reflejo

// Grado de escala más cercano a p, contado desde el C-1 de la tónica
// (grado 0 = tónica en la octava -1). Si p está a la misma distancia de dos
// grados, gana el de abajo.
function toDegree(p, steps) {
    var rel = p - P.tonic;
    var oct = Math.floor(rel / 12);
    var pc = rel - oct * 12;
    var best = 0;
    var bestD = 99;
    var i, d;
    for (i = 0; i <= steps.length; i++) {
        // steps.length = la tónica de la octava siguiente
        d = Math.abs((i < steps.length ? steps[i] : 12) - pc);
        if (d < bestD) {
            bestD = d;
            best = i;
        }
    }
    return oct * steps.length + best;
}

function fromDegree(d, steps) {
    var n = steps.length;
    var oct = Math.floor(d / n);
    return P.tonic + oct * 12 + steps[d - oct * n];
}

// Lo que se sale de 0..127 se mueve de octava hasta que cabe: conserva el
// nombre de la nota (y, en modo Scale, sigue dentro de la escala).
function fold(p) {
    while (p < 0) p += 12;
    while (p > 127) p -= 12;
    return p;
}

function inRange(p) {
    var lo = Math.min(P.low, P.high);
    var hi = Math.max(P.low, P.high);
    return p >= lo && p <= hi;
}

// nota reflejada de p (sin mirar el rango)
function mirror(p) {
    var steps;
    if (P.mode === 1) {
        steps = SCALES[P.scale];
        return fold(fromDegree(2 * toDegree(P.axis, steps) + P.half - toDegree(p, steps), steps));
    }
    return fold(2 * P.axis + P.half - p);
}

// eje en notas, para la UI: en modo Scale, el grado al que se ajusta Axis
function axisCenter() {
    var steps, d;
    if (P.mode === 1) {
        steps = SCALES[P.scale];
        d = toDegree(P.axis, steps);
        return P.half ? (fromDegree(d, steps) + fromDegree(d + 1, steps)) / 2 : fromDegree(d, steps);
    }
    return P.axis + P.half / 2;
}

function axisLabel() {
    var steps, d, a, b;
    if (P.mode === 1) {
        steps = SCALES[P.scale];
        d = toDegree(P.axis, steps);
        a = fromDegree(d, steps);
        b = fromDegree(d + 1, steps);
    } else {
        a = P.axis;
        b = P.axis + 1;
    }
    if (P.half && b <= 127) return noteName(a) + "–" + noteName(b);
    return noteName(clamp(a, 0, 127));
}

function velocity(v) {
    return P.flipvel ? clamp(128 - v, 1, 127) : v;
}

// ---------------------------------------------------------------------------
// notas

function sound(o, v) {
    count[o] = (count[o] || 0) + 1;
    outlet(0, o, v);
}

function release(o) {
    if (!count[o]) return;
    count[o] -= 1;
    if (count[o] <= 0) {
        delete count[o];
        outlet(0, o, 0);
    }
}

function addLink(i, o, v, t) {
    var links = [];
    var k, L;
    for (k = 0; k < S.links.length; k++) {
        L = S.links[k];
        if (L.on || t - L.off < LINK_LIFE) links.push(L);
    }
    if (links.length >= MAX_LINKS) links.shift();
    links.push({ i: i, o: o, v: v, on: true, t: t, off: 0 });
    S.links = links;
}

function noteOn(p, v) {
    var t = now();
    var outs = [];
    var m;
    if (active[p]) noteOff(p);      // un segundo note-on sin note-off: suelta el primero
    if (!inRange(p)) {
        outs.push(p);               // fuera del rango: pasa sin tocar
        sound(p, v);
        addLink(p, p, v, t);
    } else {
        m = mirror(p);
        outs.push(m);
        sound(m, velocity(v));
        addLink(p, m, velocity(v), t);
        if (P.output === 1 && m !== p) {
            outs.push(p);
            sound(p, v);
            addLink(p, p, v, t);
        }
    }
    active[p] = outs;
    redraw();
}

function noteOff(p) {
    var outs = active[p];
    var t = now();
    var k, L;
    if (!outs) return;
    delete active[p];
    for (k = 0; k < outs.length; k++) release(outs[k]);
    for (k = 0; k < S.links.length; k++) {
        L = S.links[k];
        if (L.on && L.i === p) {
            L.on = false;
            L.off = t;
        }
    }
    redraw();
}

function redraw() {
    outlet(1, "draw", GNAME);
}

// todo lo que afecta al eje: estado de la UI y texto del knob
function update() {
    S.center = axisCenter();
    S.mode = P.mode;
    S.tonic = P.tonic;
    S.scale = P.scale;
    S.low = Math.min(P.low, P.high);
    S.high = Math.max(P.low, P.high);
    S.axisLabel = axisLabel();
    outlet(2, "axis", S.axisLabel);
    redraw();
}

// ---------------------------------------------------------------------------
// mensajes

function note(p, v) {
    p = Math.floor(p);
    v = Math.floor(v);
    if (p < 0 || p > 127) return;
    if (v > 0) {
        noteOn(p, clamp(v, 1, 127));
    } else {
        noteOff(p);
    }
}
note.immediate = 1;

function pressure(p, v) {
    var outs = active[Math.floor(p)];
    var k;
    if (!outs) return;
    for (k = 0; k < outs.length; k++) outlet(3, outs[k], v);
}
pressure.immediate = 1;

function panic() {
    var k;
    for (k in count) {
        if (count.hasOwnProperty(k)) outlet(0, Number(k), 0);
    }
    count = {};
    active = {};
    for (k = 0; k < S.links.length; k++) {
        if (S.links[k].on) {
            S.links[k].on = false;
            S.links[k].off = now();
        }
    }
    redraw();
}

function axis(v) {
    P.axis = clamp(Math.floor(v), 0, 127);
    update();
}

function half(v) {
    P.half = Number(v) ? 1 : 0;
    update();
}

function mode(v) {
    P.mode = Number(v) ? 1 : 0;
    update();
}

function tonic(v) {
    P.tonic = clamp(Math.floor(v), 0, 11);
    update();
}

function scale(v) {
    P.scale = clamp(Math.floor(v), 0, SCALES.length - 1);
    update();
}

function low(v) {
    P.low = clamp(Math.floor(v), 0, 127);
    update();
}

function high(v) {
    P.high = clamp(Math.floor(v), 0, 127);
    update();
}

function output(v) {
    P.output = Number(v) ? 1 : 0;
}

function flipvel(v) {
    P.flipvel = Number(v) ? 1 : 0;
}

function notifydeleted() {
    shared.state = null;
}

update();
