# midi-inverter

Dispositivo Max for Live (MIDI Effect) para Ableton Live 12. Da la vuelta a lo que tocas: cada nota se refleja alrededor de un eje, en tiempo real. Con el eje en C3, si tocas C4 suena C2. Si subes, la melodía baja, y los acordes mayores salen menores.

Estética de [mxnchv.xyz](https://mxnchv.xyz): negro puro, blanco con transparencia y scanlines.

A la izquierda está la vista (300 px): arriba, el teclado de entrada; abajo, el de salida. Cada nota es una línea que va de la tecla que tocas a la que suena. Como todo se refleja en el eje, las líneas se cruzan en la línea discontinua. A la derecha, los controles, en dos grupos:

- **Eje:** el knob Axis y, debajo, Between.
- **Notas:** Mode, Root y Scale (estos dos solo en modo Scale; se atenúan en Chromatic), el rango Low–High y la salida (Output y Velocity).

Cada control tiene su descripción en inglés para la **Info View** de Live (`parameter_info`), y la vista también (`annotation`). Están en la tabla `INFO` de `tools/build_device.py`.

## Instalación

1. Copia en **la misma carpeta** `midi-inverter.amxd`, `inverter_engine.js` e `inverter_ui.js` (por ejemplo `User Library/Presets/MIDI Effects/Max MIDI Effect/midi-inverter/`).
2. Arrastra `midi-inverter.amxd` a una pista MIDI, delante de un instrumento.
3. Para usarlo en otro ordenador o compartirlo, abre el dispositivo en Max, pulsa **Freeze** y guárdalo. Así los `.js` quedan dentro del `.amxd`.

### Si Live no abre el .amxd

El `.amxd` se genera escribiendo a mano su contenedor binario, y ese formato no está documentado. Si Live no lo carga:

1. En Live, crea un **Max MIDI Effect** vacío y pulsa el botón de editar.
2. En Max, selecciona todo (Cmd/Ctrl+A) y bórralo.
3. Abre `midi-inverter_clipboard.json`, copia todo el texto y pégalo en el patcher (Cmd/Ctrl+V).
4. En el inspector del patcher (Patcher Inspector), activa **Open in Presentation** y pon **Device Width** a 540.
5. Guárdalo como `midi-inverter.amxd` en la misma carpeta que los `.js`.

## Controles

| control | rango | qué hace |
|---|---|---|
| Axis | nota MIDI (C3 por defecto) | el espejo. Cada nota sale a la misma distancia del eje, pero al otro lado: `salida = 2 × eje − entrada` |
| Between | on / off | pone el eje entre Axis y la nota siguiente (en modo Scale, el grado siguiente). Con el eje en C3–C#3, C3 y C#3 se intercambian |
| Mode | Chromatic / Scale | **Chromatic**: refleja semitono a semitono. **Scale**: refleja por grados de la escala, así que la salida nunca se sale de la escala. Una nota que no está en la escala se ajusta primero al grado más cercano (si está justo en medio, al de abajo), y el eje también |
| Root, Scale | | Major, Minor, Dorian, Phrygian, Lydian, Mixolydian, Harmonic Minor, Major/Minor Pentatonic, Blues |
| Low / High | nota MIDI (0–127 por defecto) | rango que se refleja. Lo que queda fuera pasa sin tocar |
| Output | Mirror / Both | **Mirror**: solo suena la nota reflejada. **Both**: suenan la que tocas y su reflejo (acordes espejo) |
| Velocity | Flip | invierte también la velocity de las notas reflejadas (`128 − v`): lo suave sale fuerte y al revés. La original, en modo Both, conserva la suya |

Ejemplos con el eje en C3:

- Chromatic: C4 → C2, E3 → G#2, G3 → F2. C–E–G (Do mayor) → C–G#–F (Fa menor).
- Scale, Do mayor: D3 → B2, E3 → A2, F3 → G2. C–E–G → C–A–F (Fa mayor).

**Fuera del teclado:** si el reflejo cae por debajo de 0 o por encima de 127, se mueve de octava en octava hasta que cabe. Conserva el nombre de la nota (y, en modo Scale, sigue en la escala).

**Note-offs:** cada nota que tocas recuerda las notas que disparó, y al soltarla apaga esas. Puedes mover el eje, cambiar de modo o de escala con notas pulsadas y no se queda ninguna colgada. Si dos notas acaban en la misma nota de salida (pasa en modo Both), esta solo se apaga cuando sueltas las dos. Al desactivar el dispositivo, se apaga todo lo que suena.

**Lo demás:** la presión polifónica sigue a las notas reflejadas. CC, program change, aftertouch de canal y pitch bend pasan sin tocar.

## Arquitectura

- `inverter_engine.js` corre en `[js inverter_engine.js ---mi]`. Hace el reflejo, lleva la cuenta de qué nota de entrada mantiene cada nota de salida y publica el estado para la vista. `note` y `pressure` llevan `.immediate = 1`.
- `inverter_ui.js` corre en `[jsui]` y solo dibuja. Lee el estado de un `Global` cuyo nombre es único por instancia (`---` se sustituye por un ID) y repinta al recibir `draw <nombreGlobal>` (cada vez que entra o sale una nota) o un bang de `[qmetro 33]`, que lo mantiene vivo mientras se apagan las líneas de las notas soltadas. Las notas no dependen nunca del repintado.
- Valor del knob Axis: motor (outlet 2, `axis C3`) → `[route axis]` → `[prepend set]` → el texto bajo el aro.
- Modo Chromatic: `live.tab` Mode → `[sel 0 1]` → `active 0|1` y `textcolor` a Root y Scale y a sus nombres, para atenuarlos.
- Entrada: `[midiin]` → `[midiparse]`. Las notas (`prepend note`) y la presión polifónica (`prepend pressure`) van al motor. CC, program change, aftertouch, pitch bend y canal van directos a `[midiformat]`.
- Salida: motor → `[midiformat]` (notas al inlet 0, presión polifónica al 1) → `[midiout]`. Sin `makenote`: el motor manda cada note-off cuando sueltas la nota.
- Dispositivo desactivado: `[live.thisdevice]` → `[sel 0]` → `panic`.

## Desarrollo

```sh
python3 tools/build_device.py     # regenera midi-inverter.maxpat, midi-inverter.amxd y midi-inverter_clipboard.json
node tests/test_engine.js         # pruebas del motor con stubs de la API de Max
python3 -m http.server            # y abre http://localhost:8000/tools/preview.html
```

`tools/preview.html` ejecuta los dos `.js` tal cual en el navegador, con un canvas que imita mgraphics. Se toca con el teclado del ordenador (A W S E D F T G Y H U J K desde C3; Z y X cambian de octava) o haciendo clic en la vista. Sirve para ver el reflejo sin abrir Live. No tiene audio.

El `.amxd` está hecho con el mismo generador que midirain, pero todavía no se ha probado en Live.
