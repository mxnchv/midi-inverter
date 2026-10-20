// inverter_ui.js
// Visualización de midi-inverter en [jsui] con mgraphics. Solo dibuja: lee el
// estado que el motor publica en un Global y repinta con "draw <nombreGlobal>"
// o con un bang (un [qmetro] la mantiene viva mientras se apagan las notas).
// Ninguna nota depende de este archivo. ES5.
//
// Arriba, el teclado de entrada; abajo, el de salida. Cada nota es una línea de
// la tecla que tocas a la que suena: como todo se refleja en el eje, las líneas
// se cruzan en el centro.
//
// Estética de mxnchv.xyz: negro puro, blanco con transparencia, líneas de 1 px
// y scanlines.

mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;

inlets = 1;
outlets = 0;

var FONT = "Ableton Sans Medium";   // la de Live, como el resto del dispositivo
var SPAN = 48;           // semitonos a la vista (24 a cada lado del eje)
var IN_Y = 36;           // fila de los puntos de entrada
var OUT_Y = 133;         // fila de los puntos de salida
var KEY_TOP = 18;        // teclado de entrada: de aquí…
var KEY_BOTTOM = 151;    // …y el de salida hasta aquí
var LINK_LIFE = 600;     // igual que en el motor
var POP = 160;           // ms del destello de cada nota al sonar
var BLACK_KEYS = [0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0];

var SCALES = [
    [0, 2, 4, 5, 7, 9, 11],
    [0, 2, 3, 5, 7, 8, 10],
    [0, 2, 3, 5, 7, 9, 10],
    [0, 1, 3, 5, 7, 8, 10],
    [0, 2, 4, 6, 7, 9, 11],
    [0, 2, 4, 5, 7, 9, 10],
    [0, 2, 3, 5, 7, 8, 11],
    [0, 2, 4, 7, 9],
    [0, 3, 5, 7, 10],
    [0, 3, 5, 6, 7, 10]
];

var gname = null;
var G = null;

function draw(name) {
    name = String(name);
    if (name !== gname) {
        gname = name;
        G = new Global(name);
    }
    mgraphics.redraw();
}

function bang() {
    mgraphics.redraw();
}

// ---------------------------------------------------------------------------

function size() {
    var sz = mgraphics.size;
    if (sz && sz.length >= 2) return [sz[0], sz[1]];
    return [box.rect[2] - box.rect[0], box.rect[3] - box.rect[1]];
}

function inScale(S, p) {
    var steps, pc, i;
    if (S.mode !== 1) return true;
    steps = SCALES[S.scale] || SCALES[0];
    pc = ((p - S.tonic) % 12 + 12) % 12;
    for (i = 0; i < steps.length; i++) {
        if (steps[i] === pc) return true;
    }
    return false;
}

function paint() {
    var sz = size();
    var W = sz[0];
    var H = sz[1];
    var t = Date.now();
    var S = G ? G.state : null;
    var view;

    mgraphics.set_source_rgba(0, 0, 0, 1);
    mgraphics.rectangle(0, 0, W, H);
    mgraphics.fill();

    if (!S) S = { center: 60, mode: 0, tonic: 0, scale: 0, low: 0, high: 127, links: [], axisLabel: "C3" };

    view = {
        W: W,
        k: (W - 16) / SPAN,
        c: S.center
    };
    view.x = function (p) {
        return W / 2 + (p - view.c) * view.k;
    };

    drawKeys(S, view, KEY_TOP, 1);
    drawKeys(S, view, KEY_BOTTOM, -1);
    drawAxis(S, view, H);
    drawLinks(S, view, t);
    drawLabels();

    // scanlines
    mgraphics.set_source_rgba(0, 0, 0, 0.14);
    for (var y = 3; y < H; y += 4) mgraphics.rectangle(0, y, W, 1);
    mgraphics.fill();
}

// Teclado como marcas finas: más largas las teclas blancas, más cortas las
// negras. Arriba se apagan las notas fuera de Low–High (pasan sin reflejar) y,
// en modo Scale, en los dos lados las que no están en la escala.
function drawKeys(S, view, y0, dir) {
    var lo = Math.floor(view.c - SPAN / 2) - 1;
    var hi = Math.ceil(view.c + SPAN / 2) + 1;
    var p, x, len, a;
    mgraphics.set_line_width(1);
    for (p = lo; p <= hi; p++) {
        if (p < 0 || p > 127) continue;
        x = Math.round(view.x(p)) + 0.5;
        if (x < 2 || x > view.W - 2) continue;
        len = BLACK_KEYS[p % 12] ? 5 : 9;
        a = BLACK_KEYS[p % 12] ? 0.22 : 0.4;
        if (p % 12 === 0) {
            len = 12;
            a = 0.55;
        }
        if (!inScale(S, p)) a *= 0.3;
        if (dir > 0 && (p < S.low || p > S.high)) a *= 0.35;
        mgraphics.set_source_rgba(1, 1, 1, a);
        mgraphics.move_to(x, y0);
        mgraphics.line_to(x, y0 + dir * len);
        mgraphics.stroke();
    }
}

// el eje: línea vertical discontinua, con su nota debajo del teclado de salida
function drawAxis(S, view, H) {
    var x = Math.round(view.x(S.center)) + 0.5;
    var y, label, tw;
    mgraphics.set_line_width(1);
    mgraphics.set_source_rgba(1, 1, 1, 0.2);
    for (y = KEY_TOP + 14; y < KEY_BOTTOM - 14; y += 4) {
        mgraphics.move_to(x, y);
        mgraphics.line_to(x, y + 2);
    }
    mgraphics.stroke();

    label = S.axisLabel || "";
    mgraphics.select_font_face(FONT);
    mgraphics.set_font_size(8);
    tw = mgraphics.text_measure(label)[0];
    mgraphics.set_source_rgba(1, 1, 1, 0.5);
    mgraphics.move_to(Math.max(30, Math.min(view.W - 4 - tw, x - tw / 2)), H - 3);
    mgraphics.show_text(label);
}

function edgeX(view, p) {
    var x = view.x(p);
    return x < 4 ? 4 : (x > view.W - 4 ? view.W - 4 : x);
}

function drawLinks(S, view, t) {
    var links = S.links || [];
    var i, L, a, x1, x2, age, r, pass;
    mgraphics.set_line_cap("round");
    for (i = 0; i < links.length; i++) {
        L = links[i];
        if (!L) continue;
        a = L.on ? 1 : 1 - (t - L.off) / LINK_LIFE;
        if (a <= 0) continue;
        a *= 0.45 + 0.55 * L.v / 127;
        pass = L.i === L.o;             // fuera del rango, o la original en modo Both
        x1 = edgeX(view, L.i);
        x2 = edgeX(view, L.o);

        mgraphics.set_line_width(1);
        mgraphics.set_source_rgba(1, 1, 1, a * (pass ? 0.25 : 0.55));
        mgraphics.move_to(x1, IN_Y);
        mgraphics.line_to(x2, OUT_Y);
        mgraphics.stroke();

        age = t - L.t;
        r = 2.2 + (age < POP ? 3 * (1 - age / POP) : 0);
        mgraphics.set_source_rgba(1, 1, 1, a * 0.9);
        mgraphics.ellipse(x1 - 2.2, IN_Y - 2.2, 4.4, 4.4);
        mgraphics.fill();
        mgraphics.set_source_rgba(1, 1, 1, a * (pass ? 0.5 : 1));
        mgraphics.ellipse(x2 - r, OUT_Y - r, 2 * r, 2 * r);
        mgraphics.fill();
    }
}

function drawLabels() {
    mgraphics.select_font_face(FONT);
    mgraphics.set_font_size(8);
    mgraphics.set_source_rgba(1, 1, 1, 0.35);
    mgraphics.move_to(6, 9);
    mgraphics.show_text("in");
    mgraphics.move_to(6, 166);
    mgraphics.show_text("out");
}
