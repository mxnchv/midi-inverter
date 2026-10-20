#!/usr/bin/env python3
"""Genera midi-inverter.maxpat, midi-inverter.amxd y midi-inverter_clipboard.json.

    python3 tools/build_device.py

El patcher se construye como datos (cajas + cables) y se valida antes de escribir:
ids únicos, cables entre outlets/inlets que existen y nombres de parámetro únicos.
"""

import json
import os
import struct
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
NAME = "midi-inverter"

DEVICE_W = 540
DEVICE_H = 169
VIEW_W = 300

FONT = "Ableton Sans Medium"   # la de Live; si no está, Max usa la suya por defecto

# paleta de mxnchv.xyz: negro, blanco con alfa y el gris #1c1c1c de los separadores
BLACK = [0.0, 0.0, 0.0, 1.0]
WHITE = [1.0, 1.0, 1.0, 1.0]
SEP = [0.11, 0.11, 0.11, 1.0]


def white(a):
    return [1.0, 1.0, 1.0, a]


AMXD_MIDI = 0x6D6D6D6D                   # 'mmmm'

boxes = []
lines = []
_ids = {}


def box(key, maxclass, rect, inlets, outlets, outlettype=None, text=None, pres=None, **attrs):
    oid = "obj-%d" % (len(boxes) + 1)
    b = {
        "id": oid,
        "maxclass": maxclass,
        "numinlets": inlets,
        "numoutlets": outlets,
        "patching_rect": [float(v) for v in rect],
    }
    if outlets:
        b["outlettype"] = outlettype if outlettype is not None else [""] * outlets
    if text is not None:
        b["text"] = text
    if pres is not None:
        b["presentation"] = 1
        b["presentation_rect"] = [float(v) for v in pres]
    b.update(attrs)
    boxes.append({"box": b})
    _ids[key] = b
    return key


def obj(key, text, rect, inlets, outlets, outlettype=None, **attrs):
    return box(key, "newobj", rect, inlets, outlets, outlettype, text=text, **attrs)


def msg(key, text, rect):
    return box(key, "message", rect, 2, 1, [""], text=text)


def comment(key, text, rect, pres=None, size=9.0, alpha=0.5, **attrs):
    a = {"fontname": FONT, "fontsize": size}
    if pres is not None:
        a["textcolor"] = white(alpha)
    a.update(attrs)
    return box(key, "comment", rect, 1, 0, text=text, pres=pres, **a)


def wire(src, dst, outlet=0, inlet=0):
    lines.append({"patchline": {
        "source": [_ids[src]["id"], outlet],
        "destination": [_ids[dst]["id"], inlet],
    }})


# textos de la Info View de Live (al pasar el ratón por cada control)
SCALE_ONLY = " Scale mode only."
INFO = {
    "Axis": "The mirror. Every note is flipped around it: with the axis on C3, C4 plays C2. "
            "Notes that would fall outside the keyboard move by octaves until they fit.",
    "Between": "Puts the axis halfway between Axis and the next note (the next scale degree "
               "in Scale mode). C3 and C#3 swap places, and so on.",
    "Mode": "Chromatic flips semitone by semitone. Scale flips by scale degrees, so the "
            "output never leaves the scale; notes outside it snap to the nearest degree first.",
    "Root": "Root note of the scale." + SCALE_ONLY,
    "Scale": "Scale used to flip by degrees." + SCALE_ONLY,
    "Low": "Lowest note that gets flipped. Notes outside Low to High pass through untouched.",
    "High": "Highest note that gets flipped. Notes outside Low to High pass through untouched.",
    "Output": "Mirror plays only the flipped note. Both plays the note you played and its mirror.",
    "Velocity": "Flip also flips the velocity of the mirrored notes: soft becomes loud and "
                "loud becomes soft.",
}
VIEW_INFO = ("Top: the notes you play. Bottom: the notes that sound. "
             "Every line crosses the dashed axis.")


def param(longname, shortname, ptype, **v):
    """saved_attribute_attributes de un objeto live.*
    ptype: 0 float, 1 int, 2 enum.  unitstyle: 0 int, 1 float, 2 ms, 5 %, 8 MIDI."""
    valueof = {
        "parameter_longname": longname,
        "parameter_shortname": shortname,
        "parameter_type": ptype,
        "parameter_info": INFO[longname],
    }
    for k, val in v.items():
        valueof["parameter_" + k] = val
    if "initial" in v:
        valueof["parameter_initial_enable"] = 1
    return {"valueof": valueof}


# knob nativo de Live con nuestros colores: arco y aguja blancos, aro gris
DIAL_COLORS = {
    "activedialcolor": WHITE,
    "dialcolor": white(0.28),
    "activeneedlecolor": WHITE,
    "needlecolor": WHITE,
    "textcolor": white(0.85),
    "panelcolor": BLACK,
    "focusbordercolor": white(0.6),
}
TAB_COLORS = {
    "bgcolor": BLACK,
    "activebgcolor": BLACK,
    "bgoncolor": white(0.85),
    "activebgoncolor": WHITE,
    "textcolor": white(0.6),
    "textoncolor": BLACK,
    "bordercolor": white(0.35),
    "focusbordercolor": white(0.6),
}
MENU_COLORS = {
    "bgcolor": BLACK,
    "activebgcolor": BLACK,
    "textcolor": white(0.85),
    "tricolor": white(0.5),
    "bordercolor": white(0.35),
    "focusbordercolor": white(0.6),
}
NUMBOX_COLORS = {
    "activebgcolor": BLACK,
    "textcolor": white(0.85),
    "activeslidercolor": white(0.5),
    "tricolor": white(0.5),
    "bordercolor": white(0.35),
    "focusbordercolor": white(0.6),
}
# botón de encendido: negro con texto gris apagado, blanco con texto negro encendido
TOGGLE_COLORS = {
    "bgcolor": BLACK,
    "activebgcolor": BLACK,
    "bgoncolor": white(0.85),
    "activebgoncolor": WHITE,
    "textcolor": white(0.6),
    "activetextcolor": white(0.6),
    "textoncolor": BLACK,
    "activetextoncolor": BLACK,
    "bordercolor": white(0.35),
    "focusbordercolor": white(0.6),
}


# Knob: el live.dial nativo solo pinta el aro; el nombre y el valor son textos
# aparte para poder dejar aire entre ellos y el aro (el dial no deja ajustarlo).
# El valor lo escribe el motor ("C3", "C3–C#3").
#
# Medidas de midirain, tomadas en Live 12: en una caja de 40 px, el aro empieza
# arriba del todo y mide ~26 px; de su borde superior a las puntas de abajo del
# arco hay ~24 px.
DIAL_BOX = 40              # caja del live.dial
DIAL_Y = 13                # caja del dial, desde la parte de arriba del nombre
VALUE_Y = 39               # texto del valor, desde la parte de arriba del nombre
LABEL_ALPHA = 0.55         # un solo estilo de etiqueta: nombres en gris…
VALUE_ALPHA = 0.92         # …y valores en blanco
DIM = 0.3                  # atenuado de lo que no aplica en modo Chromatic
_knobs = []


def dial(key, varname, longname, cx, top, mmin, mmax, initial, unitstyle, value, ptype=1):
    """Knob centrado en cx, con el nombre arriba (top) y el valor debajo."""
    v = dict(mmin=float(mmin), mmax=float(mmax), initial=[float(initial)], unitstyle=unitstyle)
    i = len(_knobs)
    comment("n_" + key, longname, [20 + i * 64, 10, 60, 18], pres=[cx - 30, top - 3, 60, 14],
            size=9.0, alpha=LABEL_ALPHA, textjustification=1, ignoreclick=1)
    box(key, "live.dial", [20 + i * 64, 30, DIAL_BOX, DIAL_BOX], 1, 2, ["", "float"],
        pres=[cx - DIAL_BOX / 2, top + DIAL_Y, DIAL_BOX, DIAL_BOX],
        parameter_enable=1, varname=varname, showname=0, shownumber=0,
        saved_attribute_attributes=param(longname, longname, ptype, **v), **DIAL_COLORS)
    comment("v_" + key, value, [20 + i * 64, 74, 60, 18], pres=[cx - 30, top + VALUE_Y, 60, 14],
            size=9.0, alpha=VALUE_ALPHA, textjustification=1, ignoreclick=1)
    _knobs.append(key)
    return key


def menu(key, varname, longname, items, initial, rect, pres):
    v = dict(enum=items, mmax=float(len(items) - 1), initial=[float(initial)])
    return box(key, "live.menu", rect, 1, 3, ["", "", "float"], pres=pres,
               parameter_enable=1, varname=varname,
               saved_attribute_attributes=param(longname, longname, 2, **v), **MENU_COLORS)


def tab(key, varname, longname, items, initial, rect, pres):
    v = dict(enum=items, mmax=float(len(items) - 1), initial=[float(initial)])
    return box(key, "live.tab", rect, 1, 3, ["", "", "float"], pres=pres,
               parameter_enable=1, varname=varname, num_lines_patching=1, num_lines_presentation=1,
               saved_attribute_attributes=param(longname, longname, 2, **v), **TAB_COLORS)


def numbox(key, varname, longname, initial, rect, pres, mmin=0, mmax=127, unitstyle=8, ptype=1):
    """Casilla numérica; por defecto, una nota MIDI (C3 = 60)."""
    v = dict(mmin=float(mmin), mmax=float(mmax), initial=[float(initial)], unitstyle=unitstyle)
    return box(key, "live.numbox", rect, 1, 2, ["", "float"], pres=pres,
               parameter_enable=1, varname=varname,
               saved_attribute_attributes=param(longname, longname, ptype, **v), **NUMBOX_COLORS)


def toggle(key, varname, longname, text, rect, pres):
    """live.text en modo toggle: el mismo texto apagado y encendido."""
    v = dict(enum=["off", "on"], mmax=1.0, initial=[0.0])
    return box(key, "live.text", rect, 1, 2, ["", ""], pres=pres,
               parameter_enable=1, varname=varname, mode=1, text=text, texton=text,
               fontname=FONT, fontsize=9.0,
               saved_attribute_attributes=param(longname, longname, 2, **v), **TOGGLE_COLORS)


# ---------------------------------------------------------------------------
# presentación: la vista a la izquierda, los controles a la derecha

box("bg", "panel", [700, 10, 60, 30], 1, 0, pres=[0, 0, DEVICE_W, DEVICE_H],
    background=1, bgcolor=BLACK, border=0, rounded=0, ignoreclick=1)
box("sep", "panel", [770, 10, 10, 30], 1, 0, pres=[VIEW_W + 2, 0, 1, DEVICE_H],
    background=1, bgcolor=SEP, border=0, rounded=0, ignoreclick=1)

box("ui", "jsui", [460, 520, VIEW_W, DEVICE_H], 1, 0, pres=[0, 0, VIEW_W, DEVICE_H],
    filename="inverter_ui.js", parameter_enable=0,
    annotation=VIEW_INFO, annotation_name="midi-inverter")

# ---------------------------------------------------------------------------
# controles en dos grupos, separados por una línea:
#   eje: el knob Axis y debajo Between
#   notas: una rejilla de recuadros; Mode arriba, Root y Scale (solo en modo
#          Scale, se atenúan en Chromatic), el rango y por último la salida

CONTROLS = []              # (clave del control, selector del motor)
AX = 341                   # centro de la columna del eje
NX = 390                   # x del grupo de notas
NROWS = [11, 47, 83, 119]  # filas (parte de arriba del nombre; la caja va 14 px más abajo)
SCALE_KEYS = ["tonic", "scale"]


def label(key, text, x, y):
    """Nombre encima de un recuadro; y es la parte de arriba del texto."""
    comment(key, text, [700.0 + 70 * (len(CONTROLS) % 4), 120.0 + 24 * (len(CONTROLS) // 4), 60, 18],
            pres=[x - 4, y - 3, 60, 14], size=9.0, alpha=LABEL_ALPHA, ignoreclick=1)


# eje
dial("axis", "axis", "Axis", AX, 16, 0, 127, 60, 8, "C3")
CONTROLS.append(("axis", "axis"))

label("l_half", "Between", AX - 22, NROWS[2])
toggle("half", "half", "Between", "½", [420, 70, 44, 15], [AX - 22, NROWS[2] + 14, 44, 15])
CONTROLS.append(("half", "half"))

box("groupsep", "panel", [790, 10, 10, 30], 1, 0, pres=[378, 14, 1, 136],
    background=1, bgcolor=white(0.12), border=0, rounded=0, ignoreclick=1)

# notas
y = NROWS[0]
label("l_mode", "Mode", NX, y)
tab("mode", "mode", "Mode", ["Chromatic", "Scale"], 0, [260, 30, 134, 15], [NX, y + 14, 134, 15])
CONTROLS.append(("mode", "mode"))

y = NROWS[1]
label("l_tonic", "Root", NX, y)
menu("tonic", "tonic", "Root",
     ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"], 0,
     [420, 30, 40, 15], [NX, y + 14, 40, 15])
CONTROLS.append(("tonic", "tonic"))

label("l_scale", "Scale", NX + 46, y)
menu("scale", "scale", "Scale",
     ["Major", "Minor", "Dorian", "Phrygian", "Lydian", "Mixolydian", "Harmonic Minor",
      "Major Pentatonic", "Minor Pentatonic", "Blues"], 0,
     [480, 30, 88, 15], [NX + 46, y + 14, 88, 15])
CONTROLS.append(("scale", "scale"))

y = NROWS[2]
label("l_low", "Low", NX, y)
numbox("low", "low", "Low", 0, [620, 30, 64, 15], [NX, y + 14, 64, 15])
CONTROLS.append(("low", "low"))

label("l_high", "High", NX + 70, y)
numbox("high", "high", "High", 127, [680, 30, 64, 15], [NX + 70, y + 14, 64, 15])
CONTROLS.append(("high", "high"))

y = NROWS[3]
label("l_output", "Output", NX, y)
tab("output", "output", "Output", ["Mirror", "Both"], 0, [620, 60, 64, 15], [NX, y + 14, 64, 15])
CONTROLS.append(("output", "output"))

label("l_flipvel", "Velocity", NX + 70, y)
toggle("flipvel", "flipvel", "Velocity", "Flip", [680, 60, 64, 15], [NX + 70, y + 14, 64, 15])
CONTROLS.append(("flipvel", "flipvel"))

# firma, abajo a la derecha
comment("credit", "mxnchv", [760, 100, 60, 18], pres=[DEVICE_W - 16 - 48, 152, 48, 14],
        size=8.0, alpha=0.3, textjustification=2, ignoreclick=1)

# ---------------------------------------------------------------------------
# lógica

comment("c_params", "parámetros -> motor", [20, 100, 160, 18])
for i, (ctl, selector) in enumerate(CONTROLS):
    key = "p_" + ctl
    obj(key, "prepend " + selector, [20 + (i % 5) * 92, 130 + (i // 5) * 26, 88, 22], 1, 1)
    wire(ctl, key)

comment("c_init", "al cargar: refresca parámetros y arranca el repintado", [20, 200, 300, 18])
obj("thisdevice", "live.thisdevice", [20, 220, 100, 22], 1, 3, ["bang", "int", "int"])
obj("init", "t 1 b", [20, 250, 50, 22], 1, 2, ["int", "bang"])
wire("thisdevice", "init")
for ctl, _ in CONTROLS:
    wire("init", ctl, outlet=1)

# la vista se repinta sola mientras se apagan las notas soltadas
obj("frames", "qmetro 33", [460, 480, 70, 22], 2, 1, ["bang"])
wire("init", "frames", outlet=0)
wire("frames", "ui")

# modo Chromatic: Root y Scale no hacen nada, así que se atenúan (y sus nombres)
comment("c_dim", "Mode: atenúa Root y Scale en Chromatic", [820, 230, 260, 18])
obj("sel_mode", "sel 0 1", [820, 250, 60, 22], 3, 3, ["bang", "bang", ""])
msg("ctl_on", "active 1, textcolor 1. 1. 1. 0.85", [820, 280, 200, 22])
msg("ctl_dim", "active 0, textcolor 1. 1. 1. %.2f" % (0.85 * DIM), [820, 310, 200, 22])
msg("lbl_on", "textcolor 1. 1. 1. %.2f" % LABEL_ALPHA, [1030, 280, 140, 22])
msg("lbl_dim", "textcolor 1. 1. 1. %.2f" % (LABEL_ALPHA * DIM), [1030, 310, 140, 22])
wire("mode", "sel_mode")
wire("sel_mode", "ctl_dim", outlet=0)
wire("sel_mode", "lbl_dim", outlet=0)
wire("sel_mode", "ctl_on", outlet=1)
wire("sel_mode", "lbl_on", outlet=1)
for k in SCALE_KEYS:
    wire("ctl_on", k)
    wire("ctl_dim", k)
for k in ["l_tonic", "l_scale"]:
    wire("lbl_on", k)
    wire("lbl_dim", k)

# entrada: las notas y la presión polifónica van al motor; lo demás (CC, program
# change, aftertouch, pitch bend y canal) pasa directo a la salida
comment("c_in", "entrada MIDI", [500, 200, 280, 18])
obj("midiin", "midiin", [500, 220, 50, 22], 1, 1, ["int"])
obj("midiparse", "midiparse", [500, 250, 100, 22], 1, 8, ["", "", "", "int", "int", "", "int", ""])
obj("p_note", "prepend note", [500, 290, 80, 22], 1, 1)
obj("p_pressure", "prepend pressure", [590, 290, 100, 22], 1, 1)
wire("midiin", "midiparse")
wire("midiparse", "p_note", outlet=0)
wire("midiparse", "p_pressure", outlet=1)

obj("engine", "js inverter_engine.js ---mi", [20, 420, 420, 22], 1, 4)
wire("p_note", "engine")
wire("p_pressure", "engine")
for ctl, _ in CONTROLS:
    wire("p_" + ctl, "engine")
wire("engine", "ui", outlet=1)

# valor del knob, ya formateado por el motor, al texto que hay debajo del aro
obj("route_vals", "route " + " ".join(_knobs), [460, 450, 200, 22], 1, len(_knobs) + 1)
for i, k in enumerate(_knobs):
    obj("set_" + k, "prepend set", [460 + i * 80, 480, 76, 22], 1, 1)
    wire("route_vals", "set_" + k, outlet=i)
    wire("set_" + k, "v_" + k)
wire("engine", "route_vals", outlet=2)

comment("c_out", "salida", [20, 470, 280, 18])
obj("midiformat", "midiformat", [20, 500, 280, 22], 7, 1, ["int"])
obj("midiout", "midiout", [20, 540, 60, 22], 1, 0)
wire("engine", "midiformat", 0, 0)
wire("engine", "midiformat", 3, 1)
for n in range(2, 7):
    wire("midiparse", "midiformat", n, n)
wire("midiformat", "midiout")

# dispositivo desactivado: note-off inmediato de todo lo que suena
obj("off", "sel 0", [200, 220, 50, 22], 2, 2, ["bang", ""])
msg("panic", "panic", [200, 250, 44, 22])
wire("thisdevice", "off", outlet=1)
wire("off", "panic")
wire("panic", "engine")

# ---------------------------------------------------------------------------


def validate():
    seen = set()
    for b in boxes:
        oid = b["box"]["id"]
        assert oid not in seen, oid
        seen.add(oid)
    by_id = {b["box"]["id"]: b["box"] for b in boxes}
    for ln in lines:
        (s, o), (d, i) = ln["patchline"]["source"], ln["patchline"]["destination"]
        assert s in by_id and d in by_id, ln
        assert 0 <= o < by_id[s]["numoutlets"], ("outlet", by_id[s].get("text", by_id[s]["maxclass"]), o)
        assert 0 <= i < by_id[d]["numinlets"], ("inlet", by_id[d].get("text", by_id[d]["maxclass"]), i)
    names = [b["box"]["saved_attribute_attributes"]["valueof"]["parameter_longname"]
             for b in boxes if b["box"].get("parameter_enable")]
    assert len(names) == len(set(names)), names
    assert sorted(names) == sorted(INFO), (names, sorted(INFO))
    for b in boxes:
        pr = b["box"].get("presentation_rect")
        if pr:
            assert pr[0] + pr[2] <= DEVICE_W and pr[1] + pr[3] <= DEVICE_H, (b["box"]["id"], pr)


APPVERSION = {"major": 8, "minor": 6, "revision": 5, "architecture": "x64", "modernui": 1}


def patcher():
    return {"patcher": {
        "fileversion": 1,
        "appversion": APPVERSION,
        "classnamespace": "box",
        "rect": [80.0, 100.0, 840.0, 660.0],
        "bglocked": 0,
        "openinpresentation": 1,
        "default_fontsize": 10.0,
        "default_fontface": 0,
        "default_fontname": "Arial Bold",
        "gridonopen": 1,
        "gridsize": [8.0, 8.0],
        "gridsnaponopen": 1,
        "objectsnaponopen": 1,
        "statusbarvisible": 2,
        "toolbarvisible": 1,
        "lefttoolbarpinned": 0,
        "toptoolbarpinned": 0,
        "righttoolbarpinned": 0,
        "bottomtoolbarpinned": 0,
        "toolbars_unpinned_last_save": 0,
        "tallnewobj": 0,
        "boxanimatetime": 500,
        "enablehscroll": 1,
        "enablevscroll": 1,
        "devicewidth": float(DEVICE_W),
        "description": "da la vuelta a las notas MIDI alrededor de un eje",
        "digest": "",
        "tags": "",
        "style": "",
        "subpatcher_template": "",
        "assistshowspatchername": 0,
        "amxdtype": AMXD_MIDI,
        "boxes": boxes,
        "lines": lines,
        "dependency_cache": [
            {"name": "inverter_engine.js", "bootpath": ".", "patcherrelativepath": ".", "type": "TEXT", "implicit": 1},
            {"name": "inverter_ui.js", "bootpath": ".", "patcherrelativepath": ".", "type": "TEXT", "implicit": 1},
        ],
        "latency": 0,
        "is_mpe": 0,
        "minimum_live_version": "",
        "minimum_max_version": "",
        "platform_compatibility": 0,
        "autosave": 0,
    }}


def amxd(json_bytes):
    """Contenedor .amxd: 'ampf' + tipo + bloque 'meta' + bloque 'ptch' con el JSON.
    Longitudes en little-endian. Formato no documentado oficialmente."""
    data = json_bytes + b"\n\x00"
    out = b"ampf" + struct.pack("<I", 4) + b"mmmm"
    out += b"meta" + struct.pack("<I", 4) + b"\x00\x00\x00\x00"
    out += b"ptch" + struct.pack("<I", len(data)) + data
    return out


def main():
    validate()
    p = patcher()
    text = json.dumps(p, indent="\t", ensure_ascii=False)
    with open(os.path.join(ROOT, NAME + ".maxpat"), "w", encoding="utf-8") as f:
        f.write(text + "\n")
    with open(os.path.join(ROOT, NAME + ".amxd"), "wb") as f:
        f.write(amxd(text.encode("utf-8")))
    clip = {"boxes": boxes, "lines": lines, "appversion": APPVERSION, "classnamespace": "box"}
    with open(os.path.join(ROOT, NAME + "_clipboard.json"), "w", encoding="utf-8") as f:
        f.write(json.dumps(clip, indent="\t", ensure_ascii=False) + "\n")
    print("%d cajas, %d cables -> %s.maxpat, %s.amxd, %s_clipboard.json"
          % (len(boxes), len(lines), NAME, NAME, NAME))


if __name__ == "__main__":
    sys.exit(main())
