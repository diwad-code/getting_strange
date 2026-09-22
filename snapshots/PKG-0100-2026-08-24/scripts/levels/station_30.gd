class_name Station30
extends Node2D

## Station 30: Sektor Zasilania / Główna Rozdzielnia (Vertical Slice - Scene 30)
## Location: Deep electrical switchyard and power routing facility of Podstruktura.
## Narrative: Lena and Jakub manipulate the high-voltage knife switch and memory grid
## schematic, cutting power to UCP automated surveillance and stabilizing citizen testimonies.

signal level_completed

const LEVEL_ID := "station_30"
const LEVEL_NAME := "Przestrzeń 30: Sektor Zasilania"
const SCENE_SUBTITLE := "Maszyna Świadków / Główna Rozdzielnia Podstruktury"

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone

var is_board_inspected: bool = false
var is_transformer_inspected: bool = false
var is_breaker_thrown: bool = false
var is_schematic_inspected: bool = false
var is_exit_unlocked: bool = false
var is_dialogue_completed: bool = false
var is_level_completed: bool = false

var dialogue_index: int = 0
var dialogue_active: bool = true
var _exit_open_progress: float = 0.0

# 11 dialogue lines for Scene 30 from FULL_STORY.md & DIALOGUE_SCRIPT.md
var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Pomieszczenie wypełnia niski pomruk transformatorów olejowych. Przed bohaterami wznosi się Maszyna Świadków — centralny węzeł zasilania pamięci Podstruktury."
	},
	{
		"speaker": "JAKUB",
		"text": "To stąd UCP zasila siatkę konsensusu. Każdy obwód podtrzymuje pamięć o konkretnej ulicy, budynku albo człowieku."
	},
	{
		"speaker": "LENA",
		"text": "Spójrz na wskaźniki obciążenia. Niektóre sekcje pobierają dziesięć razy więcej prądu niż inne."
	},
	{
		"speaker": "JAKUB",
		"text": "Bo im więcej ludzi pamięta inaczej niż w oficjalnej wersji, tym więcej energii potrzeba, by ich uciszyć."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Na podświetlanym schemacie pulsują punkty odniesienia: Marta Kurek, Jakub Wolski, Szymon Bera i zapomniane rejestry Linii 4."
	},
	{
		"speaker": "LENA",
		"text": "Marta nadal świeci na schemacie jako niezgodny węzeł. Pamięta mnie z innego poranka."
	},
	{
		"speaker": "JAKUB",
		"text": "Jeśli przestawimy ten trójfazowy bezpiecznik nożowy, odetniemy zasilanie automatycznych kamer i rejestratorów UCP w Sektorze 4."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Potężna dźwignia bezpiecznika nożowego lśni zimną miedzią. Wokół ceramicznych izolatorów strzelają błękitne iskry wyładowań koronowych."
	},
	{
		"speaker": "LENA",
		"text": "Przestaw go, Jakub. Pozwólmy, by świadectwa mieszkańców nie były dłużej tłumione przez aparaturę."
	},
	{
		"speaker": "JAKUB",
		"text": "Zrobione. Obwody nadzoru zgasły. Droga do Magazynu Dowodów stoi otworem."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Rygiel magnetyczny ciężkiej bramy ekranowanej dejonizuje się z głuchym tąpnięciem. Brama do Przestrzeni 31 uchyla się powoli."
	}
]


func _ready() -> void:
	if player:
		player.position = Vector2(50.0, 240.0)
	if camera:
		camera.position = Vector2(320.0, 180.0)
	
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_zone_body_entered)
	
	_connect_prop_signals()


func _process(delta: float) -> void:
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 1.5)
		queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		if dialogue_active:
			advance_dialogue()


func advance_dialogue() -> int:
	if dialogue_index < dialogue_lines.size() - 1:
		dialogue_index += 1
		_apply_dialogue_state(dialogue_index)
		queue_redraw()
		return dialogue_index
	else:
		dialogue_active = false
		is_dialogue_completed = true
		_unlock_exit()
		queue_redraw()
		return -1


func _apply_dialogue_state(idx: int) -> void:
	match idx:
		2:
			is_board_inspected = true
			_activate_prop_by_id("prop_main_distribution_board")
		4:
			is_transformer_inspected = true
			_activate_prop_by_id("prop_transformer_bank")
		6:
			is_schematic_inspected = true
			_activate_prop_by_id("prop_grid_schematic")
		8:
			is_breaker_thrown = true
			_activate_prop_by_id("prop_section_breaker")
		9:
			_unlock_exit()


func _unlock_exit() -> void:
	is_exit_unlocked = true
	_activate_prop_by_id("prop_station_30_exit")


func _activate_prop_by_id(id: String) -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint and child.resonance_id == id:
				child.is_activated = true
				child.queue_redraw()


func _connect_prop_signals() -> void:
	if not props:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			child.resonance_triggered.connect(_on_resonance_triggered)


func _on_resonance_triggered(id: String, _pt: int) -> void:
	match id:
		"prop_main_distribution_board":
			is_board_inspected = true
		"prop_transformer_bank":
			is_transformer_inspected = true
		"prop_section_breaker":
			is_breaker_thrown = true
			if dialogue_index >= 8:
				_unlock_exit()
		"prop_grid_schematic":
			is_schematic_inspected = true
		"prop_station_30_exit":
			if is_exit_unlocked:
				_on_airlock_zone_body_entered(player)


func _on_airlock_zone_body_entered(body: Node2D) -> void:
	if is_level_completed:
		return
	if body == player or (body and body.name == "Player"):
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	_draw_background_environment()
	_draw_dialogue_hud()


func _draw_background_environment() -> void:
	# Deep electrical substation chamber: 640x360
	# Industrial steel arch ribs, overhead busway channels, conduit clusters, concrete floor
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), Color("0a0e12"))
	
	# Overhead heavy steel girders & busway cable channels
	for g in range(9):
		var gx := float(g) * 80.0
		draw_line(Vector2(gx, 0.0), Vector2(gx, 280.0), Color("12181d"), 12.0)
		draw_line(Vector2(gx + 2.0, 0.0), Vector2(gx + 2.0, 280.0), Color("1e2830"), 1.5)
	
	# Horizontal cable trays and conduit bundles
	draw_line(Vector2(0.0, 55.0), Vector2(640.0, 55.0), Color("162026"), 6.0)
	draw_line(Vector2(0.0, 75.0), Vector2(640.0, 75.0), Color("1a242c"), 4.0)
	draw_line(Vector2(0.0, 56.0), Vector2(640.0, 56.0), Color("b87333", 0.6), 1.2)
	draw_line(Vector2(0.0, 76.0), Vector2(640.0, 76.0), Color("5da398", 0.4), 1.0)
	
	# High voltage safety hazard stripes above floor level
	for h in range(16):
		var hx := float(h) * 40.0
		draw_line(Vector2(hx, 275.0), Vector2(hx + 20.0, 280.0), Color("e2b060", 0.35), 2.0)
	
	# Concrete substation floor
	draw_rect(Rect2(0.0, 280.0, 640.0, 80.0), Color("0f1418"))
	draw_line(Vector2(0.0, 280.0), Vector2(640.0, 280.0), Color("28353e"), 2.0)
	
	# Wall electrical conduit junction boxes
	for j in range(4):
		var jx := 80.0 + float(j) * 140.0
		draw_rect(Rect2(jx, 120.0, 16.0, 18.0), Color("182229"))
		draw_rect(Rect2(jx, 120.0, 16.0, 18.0), Color("344652"), false, 1.0)
		draw_line(Vector2(jx + 8.0, 75.0), Vector2(jx + 8.0, 120.0), Color("24313a"), 1.5)


func _draw_dialogue_hud() -> void:
	if not dialogue_active or dialogue_index >= dialogue_lines.size():
		return
	
	var cur_line: Dictionary = dialogue_lines[dialogue_index]
	var speaker: String = cur_line.get("speaker", "")
	var text: String = cur_line.get("text", "")
	
	# Dialogue box container (bottom 75 px)
	var box_rect := Rect2(60.0, 285.0, 520.0, 65.0)
	draw_rect(box_rect, Color(0.04, 0.07, 0.09, 0.92))
	draw_rect(box_rect, Color("d39a62", 0.85), false, 1.0)
	
	# Speaker color distinction
	var speaker_col := Color("d39a62")
	if speaker == "JAKUB":
		speaker_col = Color("5da398")
	elif speaker == "LENA":
		speaker_col = Color("e2b060")
	elif speaker == "ŚWIADECTWO":
		speaker_col = Color("a8b2ac")
	
	draw_line(Vector2(70.0, 290.0), Vector2(170.0, 290.0), speaker_col, 2.0)
	
	# Speaker badge & dialogue text
	var font := ThemeDB.fallback_font
	if font:
		draw_string(font, Vector2(70.0, 304.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 11, speaker_col)
		draw_string(font, Vector2(70.0, 322.0), text, HORIZONTAL_ALIGNMENT_LEFT, 500, 10, Color(0.9, 0.93, 0.95))
