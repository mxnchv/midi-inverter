{
	"patcher": {
		"fileversion": 1,
		"appversion": {
			"major": 8,
			"minor": 6,
			"revision": 5,
			"architecture": "x64",
			"modernui": 1
		},
		"classnamespace": "box",
		"rect": [
			80.0,
			100.0,
			840.0,
			660.0
		],
		"bglocked": 0,
		"openinpresentation": 1,
		"default_fontsize": 10.0,
		"default_fontface": 0,
		"default_fontname": "Arial Bold",
		"gridonopen": 1,
		"gridsize": [
			8.0,
			8.0
		],
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
		"devicewidth": 540.0,
		"description": "da la vuelta a las notas MIDI alrededor de un eje",
		"digest": "",
		"tags": "",
		"style": "",
		"subpatcher_template": "",
		"assistshowspatchername": 0,
		"amxdtype": 1835887981,
		"boxes": [
			{
				"box": {
					"id": "obj-1",
					"maxclass": "panel",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						700.0,
						10.0,
						60.0,
						30.0
					],
					"presentation": 1,
					"presentation_rect": [
						0.0,
						0.0,
						540.0,
						169.0
					],
					"background": 1,
					"bgcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"border": 0,
					"rounded": 0,
					"ignoreclick": 1
				}
			},
			{
				"box": {
					"id": "obj-2",
					"maxclass": "panel",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						770.0,
						10.0,
						10.0,
						30.0
					],
					"presentation": 1,
					"presentation_rect": [
						302.0,
						0.0,
						1.0,
						169.0
					],
					"background": 1,
					"bgcolor": [
						0.11,
						0.11,
						0.11,
						1.0
					],
					"border": 0,
					"rounded": 0,
					"ignoreclick": 1
				}
			},
			{
				"box": {
					"id": "obj-3",
					"maxclass": "jsui",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						460.0,
						520.0,
						300.0,
						169.0
					],
					"presentation": 1,
					"presentation_rect": [
						0.0,
						0.0,
						300.0,
						169.0
					],
					"filename": "inverter_ui.js",
					"parameter_enable": 0,
					"annotation": "Top: the notes you play. Bottom: the notes that sound. Every line crosses the dashed axis.",
					"annotation_name": "midi-inverter"
				}
			},
			{
				"box": {
					"id": "obj-4",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						10.0,
						60.0,
						18.0
					],
					"text": "Axis",
					"presentation": 1,
					"presentation_rect": [
						311.0,
						13.0,
						60.0,
						14.0
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.55
					],
					"textjustification": 1,
					"ignoreclick": 1
				}
			},
			{
				"box": {
					"id": "obj-5",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						20.0,
						30.0,
						40.0,
						40.0
					],
					"outlettype": [
						"",
						"float"
					],
					"presentation": 1,
					"presentation_rect": [
						321.0,
						29.0,
						40.0,
						40.0
					],
					"parameter_enable": 1,
					"varname": "axis",
					"showname": 0,
					"shownumber": 0,
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Axis",
							"parameter_shortname": "Axis",
							"parameter_type": 1,
							"parameter_info": "The mirror. Every note is flipped around it: with the axis on C3, C4 plays C2. Notes that would fall outside the keyboard move by octaves until they fit.",
							"parameter_mmin": 0.0,
							"parameter_mmax": 127.0,
							"parameter_initial": [
								60.0
							],
							"parameter_unitstyle": 8,
							"parameter_initial_enable": 1
						}
					},
					"activedialcolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"dialcolor": [
						1.0,
						1.0,
						1.0,
						0.28
					],
					"activeneedlecolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"needlecolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.85
					],
					"panelcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"focusbordercolor": [
						1.0,
						1.0,
						1.0,
						0.6
					]
				}
			},
			{
				"box": {
					"id": "obj-6",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						74.0,
						60.0,
						18.0
					],
					"text": "C3",
					"presentation": 1,
					"presentation_rect": [
						311.0,
						55.0,
						60.0,
						14.0
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.92
					],
					"textjustification": 1,
					"ignoreclick": 1
				}
			},
			{
				"box": {
					"id": "obj-7",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						770.0,
						120.0,
						60.0,
						18.0
					],
					"text": "Between",
					"presentation": 1,
					"presentation_rect": [
						315.0,
						80.0,
						60.0,
						14.0
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.55
					],
					"ignoreclick": 1
				}
			},
			{
				"box": {
					"id": "obj-8",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						420.0,
						70.0,
						44.0,
						15.0
					],
					"outlettype": [
						"",
						""
					],
					"text": "½",
					"presentation": 1,
					"presentation_rect": [
						319.0,
						97.0,
						44.0,
						15.0
					],
					"parameter_enable": 1,
					"varname": "half",
					"mode": 1,
					"texton": "½",
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Between",
							"parameter_shortname": "Between",
							"parameter_type": 2,
							"parameter_info": "Puts the axis halfway between Axis and the next note (the next scale degree in Scale mode). C3 and C#3 swap places, and so on.",
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_mmax": 1.0,
							"parameter_initial": [
								0.0
							],
							"parameter_initial_enable": 1
						}
					},
					"bgcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"activebgcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"bgoncolor": [
						1.0,
						1.0,
						1.0,
						0.85
					],
					"activebgoncolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.6
					],
					"activetextcolor": [
						1.0,
						1.0,
						1.0,
						0.6
					],
					"textoncolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"activetextoncolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"bordercolor": [
						1.0,
						1.0,
						1.0,
						0.35
					],
					"focusbordercolor": [
						1.0,
						1.0,
						1.0,
						0.6
					]
				}
			},
			{
				"box": {
					"id": "obj-9",
					"maxclass": "panel",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						790.0,
						10.0,
						10.0,
						30.0
					],
					"presentation": 1,
					"presentation_rect": [
						378.0,
						14.0,
						1.0,
						136.0
					],
					"background": 1,
					"bgcolor": [
						1.0,
						1.0,
						1.0,
						0.12
					],
					"border": 0,
					"rounded": 0,
					"ignoreclick": 1
				}
			},
			{
				"box": {
					"id": "obj-10",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						840.0,
						120.0,
						60.0,
						18.0
					],
					"text": "Mode",
					"presentation": 1,
					"presentation_rect": [
						386.0,
						8.0,
						60.0,
						14.0
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.55
					],
					"ignoreclick": 1
				}
			},
			{
				"box": {
					"id": "obj-11",
					"maxclass": "live.tab",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						260.0,
						30.0,
						134.0,
						15.0
					],
					"outlettype": [
						"",
						"",
						"float"
					],
					"presentation": 1,
					"presentation_rect": [
						390.0,
						25.0,
						134.0,
						15.0
					],
					"parameter_enable": 1,
					"varname": "mode",
					"num_lines_patching": 1,
					"num_lines_presentation": 1,
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Mode",
							"parameter_shortname": "Mode",
							"parameter_type": 2,
							"parameter_info": "Chromatic flips semitone by semitone. Scale flips by scale degrees, so the output never leaves the scale; notes outside it snap to the nearest degree first.",
							"parameter_enum": [
								"Chromatic",
								"Scale"
							],
							"parameter_mmax": 1.0,
							"parameter_initial": [
								0.0
							],
							"parameter_initial_enable": 1
						}
					},
					"bgcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"activebgcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"bgoncolor": [
						1.0,
						1.0,
						1.0,
						0.85
					],
					"activebgoncolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.6
					],
					"textoncolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"bordercolor": [
						1.0,
						1.0,
						1.0,
						0.35
					],
					"focusbordercolor": [
						1.0,
						1.0,
						1.0,
						0.6
					]
				}
			},
			{
				"box": {
					"id": "obj-12",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						910.0,
						120.0,
						60.0,
						18.0
					],
					"text": "Root",
					"presentation": 1,
					"presentation_rect": [
						386.0,
						44.0,
						60.0,
						14.0
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.55
					],
					"ignoreclick": 1
				}
			},
			{
				"box": {
					"id": "obj-13",
					"maxclass": "live.menu",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						420.0,
						30.0,
						40.0,
						15.0
					],
					"outlettype": [
						"",
						"",
						"float"
					],
					"presentation": 1,
					"presentation_rect": [
						390.0,
						61.0,
						40.0,
						15.0
					],
					"parameter_enable": 1,
					"varname": "tonic",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Root",
							"parameter_shortname": "Root",
							"parameter_type": 2,
							"parameter_info": "Root note of the scale. Scale mode only.",
							"parameter_enum": [
								"C",
								"C#",
								"D",
								"D#",
								"E",
								"F",
								"F#",
								"G",
								"G#",
								"A",
								"A#",
								"B"
							],
							"parameter_mmax": 11.0,
							"parameter_initial": [
								0.0
							],
							"parameter_initial_enable": 1
						}
					},
					"bgcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"activebgcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.85
					],
					"tricolor": [
						1.0,
						1.0,
						1.0,
						0.5
					],
					"bordercolor": [
						1.0,
						1.0,
						1.0,
						0.35
					],
					"focusbordercolor": [
						1.0,
						1.0,
						1.0,
						0.6
					]
				}
			},
			{
				"box": {
					"id": "obj-14",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						700.0,
						144.0,
						60.0,
						18.0
					],
					"text": "Scale",
					"presentation": 1,
					"presentation_rect": [
						432.0,
						44.0,
						60.0,
						14.0
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.55
					],
					"ignoreclick": 1
				}
			},
			{
				"box": {
					"id": "obj-15",
					"maxclass": "live.menu",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						480.0,
						30.0,
						88.0,
						15.0
					],
					"outlettype": [
						"",
						"",
						"float"
					],
					"presentation": 1,
					"presentation_rect": [
						436.0,
						61.0,
						88.0,
						15.0
					],
					"parameter_enable": 1,
					"varname": "scale",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Scale",
							"parameter_shortname": "Scale",
							"parameter_type": 2,
							"parameter_info": "Scale used to flip by degrees. Scale mode only.",
							"parameter_enum": [
								"Major",
								"Minor",
								"Dorian",
								"Phrygian",
								"Lydian",
								"Mixolydian",
								"Harmonic Minor",
								"Major Pentatonic",
								"Minor Pentatonic",
								"Blues"
							],
							"parameter_mmax": 9.0,
							"parameter_initial": [
								0.0
							],
							"parameter_initial_enable": 1
						}
					},
					"bgcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"activebgcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.85
					],
					"tricolor": [
						1.0,
						1.0,
						1.0,
						0.5
					],
					"bordercolor": [
						1.0,
						1.0,
						1.0,
						0.35
					],
					"focusbordercolor": [
						1.0,
						1.0,
						1.0,
						0.6
					]
				}
			},
			{
				"box": {
					"id": "obj-16",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						770.0,
						144.0,
						60.0,
						18.0
					],
					"text": "Low",
					"presentation": 1,
					"presentation_rect": [
						386.0,
						80.0,
						60.0,
						14.0
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.55
					],
					"ignoreclick": 1
				}
			},
			{
				"box": {
					"id": "obj-17",
					"maxclass": "live.numbox",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						620.0,
						30.0,
						64.0,
						15.0
					],
					"outlettype": [
						"",
						"float"
					],
					"presentation": 1,
					"presentation_rect": [
						390.0,
						97.0,
						64.0,
						15.0
					],
					"parameter_enable": 1,
					"varname": "low",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Low",
							"parameter_shortname": "Low",
							"parameter_type": 1,
							"parameter_info": "Lowest note that gets flipped. Notes outside Low to High pass through untouched.",
							"parameter_mmin": 0.0,
							"parameter_mmax": 127.0,
							"parameter_initial": [
								0.0
							],
							"parameter_unitstyle": 8,
							"parameter_initial_enable": 1
						}
					},
					"activebgcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.85
					],
					"activeslidercolor": [
						1.0,
						1.0,
						1.0,
						0.5
					],
					"tricolor": [
						1.0,
						1.0,
						1.0,
						0.5
					],
					"bordercolor": [
						1.0,
						1.0,
						1.0,
						0.35
					],
					"focusbordercolor": [
						1.0,
						1.0,
						1.0,
						0.6
					]
				}
			},
			{
				"box": {
					"id": "obj-18",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						840.0,
						144.0,
						60.0,
						18.0
					],
					"text": "High",
					"presentation": 1,
					"presentation_rect": [
						456.0,
						80.0,
						60.0,
						14.0
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.55
					],
					"ignoreclick": 1
				}
			},
			{
				"box": {
					"id": "obj-19",
					"maxclass": "live.numbox",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						680.0,
						30.0,
						64.0,
						15.0
					],
					"outlettype": [
						"",
						"float"
					],
					"presentation": 1,
					"presentation_rect": [
						460.0,
						97.0,
						64.0,
						15.0
					],
					"parameter_enable": 1,
					"varname": "high",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "High",
							"parameter_shortname": "High",
							"parameter_type": 1,
							"parameter_info": "Highest note that gets flipped. Notes outside Low to High pass through untouched.",
							"parameter_mmin": 0.0,
							"parameter_mmax": 127.0,
							"parameter_initial": [
								127.0
							],
							"parameter_unitstyle": 8,
							"parameter_initial_enable": 1
						}
					},
					"activebgcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.85
					],
					"activeslidercolor": [
						1.0,
						1.0,
						1.0,
						0.5
					],
					"tricolor": [
						1.0,
						1.0,
						1.0,
						0.5
					],
					"bordercolor": [
						1.0,
						1.0,
						1.0,
						0.35
					],
					"focusbordercolor": [
						1.0,
						1.0,
						1.0,
						0.6
					]
				}
			},
			{
				"box": {
					"id": "obj-20",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						910.0,
						144.0,
						60.0,
						18.0
					],
					"text": "Output",
					"presentation": 1,
					"presentation_rect": [
						386.0,
						116.0,
						60.0,
						14.0
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.55
					],
					"ignoreclick": 1
				}
			},
			{
				"box": {
					"id": "obj-21",
					"maxclass": "live.tab",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						620.0,
						60.0,
						64.0,
						15.0
					],
					"outlettype": [
						"",
						"",
						"float"
					],
					"presentation": 1,
					"presentation_rect": [
						390.0,
						133.0,
						64.0,
						15.0
					],
					"parameter_enable": 1,
					"varname": "output",
					"num_lines_patching": 1,
					"num_lines_presentation": 1,
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Output",
							"parameter_shortname": "Output",
							"parameter_type": 2,
							"parameter_info": "Mirror plays only the flipped note. Both plays the note you played and its mirror.",
							"parameter_enum": [
								"Mirror",
								"Both"
							],
							"parameter_mmax": 1.0,
							"parameter_initial": [
								0.0
							],
							"parameter_initial_enable": 1
						}
					},
					"bgcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"activebgcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"bgoncolor": [
						1.0,
						1.0,
						1.0,
						0.85
					],
					"activebgoncolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.6
					],
					"textoncolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"bordercolor": [
						1.0,
						1.0,
						1.0,
						0.35
					],
					"focusbordercolor": [
						1.0,
						1.0,
						1.0,
						0.6
					]
				}
			},
			{
				"box": {
					"id": "obj-22",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						700.0,
						168.0,
						60.0,
						18.0
					],
					"text": "Velocity",
					"presentation": 1,
					"presentation_rect": [
						456.0,
						116.0,
						60.0,
						14.0
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.55
					],
					"ignoreclick": 1
				}
			},
			{
				"box": {
					"id": "obj-23",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						680.0,
						60.0,
						64.0,
						15.0
					],
					"outlettype": [
						"",
						""
					],
					"text": "Flip",
					"presentation": 1,
					"presentation_rect": [
						460.0,
						133.0,
						64.0,
						15.0
					],
					"parameter_enable": 1,
					"varname": "flipvel",
					"mode": 1,
					"texton": "Flip",
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Velocity",
							"parameter_shortname": "Velocity",
							"parameter_type": 2,
							"parameter_info": "Flip also flips the velocity of the mirrored notes: soft becomes loud and loud becomes soft.",
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_mmax": 1.0,
							"parameter_initial": [
								0.0
							],
							"parameter_initial_enable": 1
						}
					},
					"bgcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"activebgcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"bgoncolor": [
						1.0,
						1.0,
						1.0,
						0.85
					],
					"activebgoncolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.6
					],
					"activetextcolor": [
						1.0,
						1.0,
						1.0,
						0.6
					],
					"textoncolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"activetextoncolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"bordercolor": [
						1.0,
						1.0,
						1.0,
						0.35
					],
					"focusbordercolor": [
						1.0,
						1.0,
						1.0,
						0.6
					]
				}
			},
			{
				"box": {
					"id": "obj-24",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						760.0,
						100.0,
						60.0,
						18.0
					],
					"text": "mxnchv",
					"presentation": 1,
					"presentation_rect": [
						476.0,
						152.0,
						48.0,
						14.0
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 8.0,
					"textcolor": [
						1.0,
						1.0,
						1.0,
						0.3
					],
					"textjustification": 2,
					"ignoreclick": 1
				}
			},
			{
				"box": {
					"id": "obj-25",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						100.0,
						160.0,
						18.0
					],
					"text": "parámetros -> motor",
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0
				}
			},
			{
				"box": {
					"id": "obj-26",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						20.0,
						130.0,
						88.0,
						22.0
					],
					"outlettype": [
						""
					],
					"text": "prepend axis"
				}
			},
			{
				"box": {
					"id": "obj-27",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						112.0,
						130.0,
						88.0,
						22.0
					],
					"outlettype": [
						""
					],
					"text": "prepend half"
				}
			},
			{
				"box": {
					"id": "obj-28",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						204.0,
						130.0,
						88.0,
						22.0
					],
					"outlettype": [
						""
					],
					"text": "prepend mode"
				}
			},
			{
				"box": {
					"id": "obj-29",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						296.0,
						130.0,
						88.0,
						22.0
					],
					"outlettype": [
						""
					],
					"text": "prepend tonic"
				}
			},
			{
				"box": {
					"id": "obj-30",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						388.0,
						130.0,
						88.0,
						22.0
					],
					"outlettype": [
						""
					],
					"text": "prepend scale"
				}
			},
			{
				"box": {
					"id": "obj-31",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						20.0,
						156.0,
						88.0,
						22.0
					],
					"outlettype": [
						""
					],
					"text": "prepend low"
				}
			},
			{
				"box": {
					"id": "obj-32",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						112.0,
						156.0,
						88.0,
						22.0
					],
					"outlettype": [
						""
					],
					"text": "prepend high"
				}
			},
			{
				"box": {
					"id": "obj-33",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						204.0,
						156.0,
						88.0,
						22.0
					],
					"outlettype": [
						""
					],
					"text": "prepend output"
				}
			},
			{
				"box": {
					"id": "obj-34",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						296.0,
						156.0,
						88.0,
						22.0
					],
					"outlettype": [
						""
					],
					"text": "prepend flipvel"
				}
			},
			{
				"box": {
					"id": "obj-35",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						200.0,
						300.0,
						18.0
					],
					"text": "al cargar: refresca parámetros y arranca el repintado",
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0
				}
			},
			{
				"box": {
					"id": "obj-36",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						20.0,
						220.0,
						100.0,
						22.0
					],
					"outlettype": [
						"bang",
						"int",
						"int"
					],
					"text": "live.thisdevice"
				}
			},
			{
				"box": {
					"id": "obj-37",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						20.0,
						250.0,
						50.0,
						22.0
					],
					"outlettype": [
						"int",
						"bang"
					],
					"text": "t 1 b"
				}
			},
			{
				"box": {
					"id": "obj-38",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						460.0,
						480.0,
						70.0,
						22.0
					],
					"outlettype": [
						"bang"
					],
					"text": "qmetro 33"
				}
			},
			{
				"box": {
					"id": "obj-39",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						820.0,
						230.0,
						260.0,
						18.0
					],
					"text": "Mode: atenúa Root y Scale en Chromatic",
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0
				}
			},
			{
				"box": {
					"id": "obj-40",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 3,
					"patching_rect": [
						820.0,
						250.0,
						60.0,
						22.0
					],
					"outlettype": [
						"bang",
						"bang",
						""
					],
					"text": "sel 0 1"
				}
			},
			{
				"box": {
					"id": "obj-41",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						820.0,
						280.0,
						200.0,
						22.0
					],
					"outlettype": [
						""
					],
					"text": "active 1, textcolor 1. 1. 1. 0.85"
				}
			},
			{
				"box": {
					"id": "obj-42",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						820.0,
						310.0,
						200.0,
						22.0
					],
					"outlettype": [
						""
					],
					"text": "active 0, textcolor 1. 1. 1. 0.26"
				}
			},
			{
				"box": {
					"id": "obj-43",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1030.0,
						280.0,
						140.0,
						22.0
					],
					"outlettype": [
						""
					],
					"text": "textcolor 1. 1. 1. 0.55"
				}
			},
			{
				"box": {
					"id": "obj-44",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1030.0,
						310.0,
						140.0,
						22.0
					],
					"outlettype": [
						""
					],
					"text": "textcolor 1. 1. 1. 0.17"
				}
			},
			{
				"box": {
					"id": "obj-45",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						500.0,
						200.0,
						280.0,
						18.0
					],
					"text": "entrada MIDI",
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0
				}
			},
			{
				"box": {
					"id": "obj-46",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						500.0,
						220.0,
						50.0,
						22.0
					],
					"outlettype": [
						"int"
					],
					"text": "midiin"
				}
			},
			{
				"box": {
					"id": "obj-47",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 8,
					"patching_rect": [
						500.0,
						250.0,
						100.0,
						22.0
					],
					"outlettype": [
						"",
						"",
						"",
						"int",
						"int",
						"",
						"int",
						""
					],
					"text": "midiparse"
				}
			},
			{
				"box": {
					"id": "obj-48",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						500.0,
						290.0,
						80.0,
						22.0
					],
					"outlettype": [
						""
					],
					"text": "prepend note"
				}
			},
			{
				"box": {
					"id": "obj-49",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						590.0,
						290.0,
						100.0,
						22.0
					],
					"outlettype": [
						""
					],
					"text": "prepend pressure"
				}
			},
			{
				"box": {
					"id": "obj-50",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 4,
					"patching_rect": [
						20.0,
						420.0,
						420.0,
						22.0
					],
					"outlettype": [
						"",
						"",
						"",
						""
					],
					"text": "js inverter_engine.js ---mi"
				}
			},
			{
				"box": {
					"id": "obj-51",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						460.0,
						450.0,
						200.0,
						22.0
					],
					"outlettype": [
						"",
						""
					],
					"text": "route axis"
				}
			},
			{
				"box": {
					"id": "obj-52",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						460.0,
						480.0,
						76.0,
						22.0
					],
					"outlettype": [
						""
					],
					"text": "prepend set"
				}
			},
			{
				"box": {
					"id": "obj-53",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						470.0,
						280.0,
						18.0
					],
					"text": "salida",
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0
				}
			},
			{
				"box": {
					"id": "obj-54",
					"maxclass": "newobj",
					"numinlets": 7,
					"numoutlets": 1,
					"patching_rect": [
						20.0,
						500.0,
						280.0,
						22.0
					],
					"outlettype": [
						"int"
					],
					"text": "midiformat"
				}
			},
			{
				"box": {
					"id": "obj-55",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						540.0,
						60.0,
						22.0
					],
					"text": "midiout"
				}
			},
			{
				"box": {
					"id": "obj-56",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						200.0,
						220.0,
						50.0,
						22.0
					],
					"outlettype": [
						"bang",
						""
					],
					"text": "sel 0"
				}
			},
			{
				"box": {
					"id": "obj-57",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						200.0,
						250.0,
						44.0,
						22.0
					],
					"outlettype": [
						""
					],
					"text": "panic"
				}
			}
		],
		"lines": [
			{
				"patchline": {
					"source": [
						"obj-5",
						0
					],
					"destination": [
						"obj-26",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-8",
						0
					],
					"destination": [
						"obj-27",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-11",
						0
					],
					"destination": [
						"obj-28",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-13",
						0
					],
					"destination": [
						"obj-29",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-15",
						0
					],
					"destination": [
						"obj-30",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-17",
						0
					],
					"destination": [
						"obj-31",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-19",
						0
					],
					"destination": [
						"obj-32",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-21",
						0
					],
					"destination": [
						"obj-33",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-23",
						0
					],
					"destination": [
						"obj-34",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-36",
						0
					],
					"destination": [
						"obj-37",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-37",
						1
					],
					"destination": [
						"obj-5",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-37",
						1
					],
					"destination": [
						"obj-8",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-37",
						1
					],
					"destination": [
						"obj-11",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-37",
						1
					],
					"destination": [
						"obj-13",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-37",
						1
					],
					"destination": [
						"obj-15",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-37",
						1
					],
					"destination": [
						"obj-17",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-37",
						1
					],
					"destination": [
						"obj-19",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-37",
						1
					],
					"destination": [
						"obj-21",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-37",
						1
					],
					"destination": [
						"obj-23",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-37",
						0
					],
					"destination": [
						"obj-38",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-38",
						0
					],
					"destination": [
						"obj-3",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-11",
						0
					],
					"destination": [
						"obj-40",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-40",
						0
					],
					"destination": [
						"obj-42",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-40",
						0
					],
					"destination": [
						"obj-44",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-40",
						1
					],
					"destination": [
						"obj-41",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-40",
						1
					],
					"destination": [
						"obj-43",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-41",
						0
					],
					"destination": [
						"obj-13",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-42",
						0
					],
					"destination": [
						"obj-13",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-41",
						0
					],
					"destination": [
						"obj-15",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-42",
						0
					],
					"destination": [
						"obj-15",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-43",
						0
					],
					"destination": [
						"obj-12",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-44",
						0
					],
					"destination": [
						"obj-12",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-43",
						0
					],
					"destination": [
						"obj-14",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-44",
						0
					],
					"destination": [
						"obj-14",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-46",
						0
					],
					"destination": [
						"obj-47",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-47",
						0
					],
					"destination": [
						"obj-48",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-47",
						1
					],
					"destination": [
						"obj-49",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-48",
						0
					],
					"destination": [
						"obj-50",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-49",
						0
					],
					"destination": [
						"obj-50",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-26",
						0
					],
					"destination": [
						"obj-50",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-27",
						0
					],
					"destination": [
						"obj-50",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-28",
						0
					],
					"destination": [
						"obj-50",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-29",
						0
					],
					"destination": [
						"obj-50",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-30",
						0
					],
					"destination": [
						"obj-50",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-31",
						0
					],
					"destination": [
						"obj-50",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-32",
						0
					],
					"destination": [
						"obj-50",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-33",
						0
					],
					"destination": [
						"obj-50",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-34",
						0
					],
					"destination": [
						"obj-50",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-50",
						1
					],
					"destination": [
						"obj-3",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-51",
						0
					],
					"destination": [
						"obj-52",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-52",
						0
					],
					"destination": [
						"obj-6",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-50",
						2
					],
					"destination": [
						"obj-51",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-50",
						0
					],
					"destination": [
						"obj-54",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-50",
						3
					],
					"destination": [
						"obj-54",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-47",
						2
					],
					"destination": [
						"obj-54",
						2
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-47",
						3
					],
					"destination": [
						"obj-54",
						3
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-47",
						4
					],
					"destination": [
						"obj-54",
						4
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-47",
						5
					],
					"destination": [
						"obj-54",
						5
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-47",
						6
					],
					"destination": [
						"obj-54",
						6
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-54",
						0
					],
					"destination": [
						"obj-55",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-36",
						1
					],
					"destination": [
						"obj-56",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-56",
						0
					],
					"destination": [
						"obj-57",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"obj-57",
						0
					],
					"destination": [
						"obj-50",
						0
					]
				}
			}
		],
		"dependency_cache": [
			{
				"name": "inverter_engine.js",
				"bootpath": ".",
				"patcherrelativepath": ".",
				"type": "TEXT",
				"implicit": 1
			},
			{
				"name": "inverter_ui.js",
				"bootpath": ".",
				"patcherrelativepath": ".",
				"type": "TEXT",
				"implicit": 1
			}
		],
		"latency": 0,
		"is_mpe": 0,
		"minimum_live_version": "",
		"minimum_max_version": "",
		"platform_compatibility": 0,
		"autosave": 0
	}
}
