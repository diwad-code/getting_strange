class_name Station20
extends Node2D

## Station 20 (Przestrzeń 20: Sala Szymona / Pokój Szymona Bery) for Getting Strange Vertical Slice.
## Features the clinical adaptive isolation room of Szymon Bera in Compliance Point 6.
## Implements dialogue D-08 ("Szymon — sprawdź studnię" — 12 dialogue lines).
## Features Szymon Bera, the crayon drawing of the well with erased signature,
## official UCP hydrology report without person records, inspection magnifier,
## and mechanical lateral door shift upon speaking Iga's name.
## Offers the critical narrative choice: anchor drawing / submit / leave as is.
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 20), DIALOGUE_SCRIPT.md (D-08).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("121a1c")
const COLOR_WALL_PLASTER := Color("222e2a")
const COLOR_WALL_LIGHT := Color("2b3a34")
const COLOR_INFRASTRUCTURE := Color("a8b2ac")
const COLOR_DARK_STEEL := Color("202c30")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.18)
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")

enum DrawingChoice {
	NONE = 0,
	ANCHOR_DRAWING = 1,
	SUBMIT_TO_UCP = 2,
	LEAVE_AS_IS = 3
}

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal szymon_approached()
signal drawing_inspected()
signal report_inspected()
signal magnifier_inspected()
signal door_shifted()
signal drawing_disposition_chosen(choice: int)
signal exit_unlocked()
signal dialogue_started()
signal dialogue_advanced(line_idx: int)
signal dialogue_completed()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone

var is_szymon_approached: bool = false
var is_drawing_inspected: bool = false
var is_report_inspected: bool = false
var is_magnifier_inspected: bool = false
var is_door_shifted: bool = false
var drawing_choice: int = DrawingChoice.NONE
var is_exit_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _door_shift_offset: float = 0.0
var _exit_open_progress: float = 0.0

var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "SZYMON",
		"text": "Narysowała ją za wysoko. Studnia jest niżej od szkoły. Zawsze jej to mówiłem.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Nie widzę podpisu.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "SZYMON",
		"text": "Wytarli. Papier jest cieńszy.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Jak miała na imię?",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "SZYMON",
		"text": "Iga. Nie zapisuj od razu. Najpierw powiedz.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Iga.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "SZYMON",
		"text": "Jeszcze raz.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Iga.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Drzwi sali przesuwają się o kilka centymetrów.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "SZYMON",
		"text": "Widzisz? Nie lubią, kiedy są dwie osoby.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Mogę sprawdzić skażenie.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "SZYMON",
		"text": "Sprawdź. Ale ona nie musi zatruć całego miasta, żeby być moją córką.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	}
]


func _ready() -> void:
	_setup_station()
	_connect_signals()
	station_entered.emit()


func _process(delta: float) -> void:
	_pulse_time += delta
	if is_door_shifted and _door_shift_offset < 14.0:
		_door_shift_offset = minf(14.0, _door_shift_offset + delta * 28.0)
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 1.5)
	queue_redraw()


func _setup_station() -> void:
	if camera:
		camera.setup_chambers([Rect2(Vector2.ZERO, VIEW_SIZE)])
		camera.set_chamber(0, false)
	if player:
		player.reset_to(Vector2(50.0, 240.0))


func _connect_signals() -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint:
				child.resonance_triggered.connect(_on_resonance_triggered)
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_entered)


func _on_resonance_triggered(id: String, type_idx: int) -> void:
	clue_inspected.emit(id, type_idx)
	match type_idx:
		MemoryResonancePoint.PropType.SZYMON_BERA:
			is_szymon_approached = true
			szymon_approached.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.WELL_DRAWING:
			is_drawing_inspected = true
			drawing_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.HYDROLOGY_REPORT:
			is_report_inspected = true
			report_inspected.emit()
		MemoryResonancePoint.PropType.ERASED_SIGNATURE_MAGNIFIER:
			is_magnifier_inspected = true
			magnifier_inspected.emit()
		MemoryResonancePoint.PropType.SZYMON_ROOM_EXIT:
			if is_exit_unlocked:
				_on_airlock_entered(player)


func start_dialogue() -> void:
	if dialogue_active:
		return
	dialogue_active = true
	dialogue_index = 0
	dialogue_started.emit()
	dialogue_advanced.emit(0)


func advance_dialogue() -> int:
	if not dialogue_active:
		return -1
	
	dialogue_index += 1
	if dialogue_index >= dialogue_lines.size():
		dialogue_active = false
		is_dialogue_completed = true
		dialogue_completed.emit()
		_unlock_exit()
		return -1
	
	if dialogue_index == 8:
		# Line 8: Stage direction / door shifts
		is_door_shifted = true
		door_shifted.emit()
	
	dialogue_advanced.emit(dialogue_index)
	return dialogue_index


func choose_drawing_disposition(choice: int) -> void:
	drawing_choice = choice
	drawing_disposition_chosen.emit(choice)
	_unlock_exit()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	if props:
		var exit_prop := props.get_node_or_null("SzymonRoomExit") as MemoryResonancePoint
		if exit_prop:
			exit_prop.is_activated = true


func _on_airlock_entered(body: Node2D) -> void:
	if not is_exit_unlocked:
		return
	if is_level_completed:
		return
	if body is PrototypePlayer or body == player:
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	# 1. Base room background & wall structure (Sala 20: 640x360)
	var bg_rect := Rect2(0.0, 0.0, VIEW_SIZE.x, VIEW_SIZE.y)
	draw_rect(bg_rect, COLOR_BACKGROUND)
	
	# Wall gradient / clinical plaster
	var wall_rect := Rect2(0.0, 40.0, VIEW_SIZE.x, 240.0)
	draw_rect(wall_rect, COLOR_WALL_PLASTER)
	
	# Subtle ceiling light strip
	draw_line(Vector2(60.0, 42.0), Vector2(580.0, 42.0), Color("dcebe4", 0.35), 2.0)
	draw_line(Vector2(120.0, 42.0), Vector2(280.0, 42.0), Color("ffffff", 0.5), 1.0)
	draw_line(Vector2(360.0, 42.0), Vector2(520.0, 42.0), Color("ffffff", 0.5), 1.0)
	
	# Floor line & linoleum tiles
	var floor_rect := Rect2(0.0, 280.0, VIEW_SIZE.x, 80.0)
	draw_rect(floor_rect, Color("1a2422"))
	draw_line(Vector2(0.0, 280.0), Vector2(VIEW_SIZE.x, 280.0), COLOR_INFRASTRUCTURE * 0.7, 2.0)
	
	for i in range(16):
		var tx := float(i) * 40.0
		draw_line(Vector2(tx, 280.0), Vector2(tx, 360.0), Color("141e1c"), 1.0)
		draw_line(Vector2(0.0, 280.0 + float(i) * 20.0), Vector2(VIEW_SIZE.x, 280.0 + float(i) * 20.0), Color("141e1c"), 1.0)
	
	# Wall panel seam lines
	for p in range(6):
		var px := 80.0 + float(p) * 95.0
		draw_line(Vector2(px, 40.0), Vector2(px, 280.0), Color("1e2a26"), 1.0)
	
	# Institutional wall placard above bed: "SALA ADAPTACYJNA 20 / SZYMON BERA"
	draw_rect(Rect2(160.0, 80.0, 140.0, 18.0), Color("182420"))
	draw_rect(Rect2(160.0, 80.0, 140.0, 18.0), COLOR_INFRASTRUCTURE * 0.4, false, 0.8)
	draw_line(Vector2(166.0, 89.0), Vector2(294.0, 89.0), Color("a0b4ac"), 0.8)
	
	# Window / observation mirror on left wall
	draw_rect(Rect2(30.0, 90.0, 50.0, 80.0), Color("16201e"))
	draw_rect(Rect2(30.0, 90.0, 50.0, 80.0), Color("2e3e38"), false, 1.0)
	draw_line(Vector2(30.0, 90.0), Vector2(80.0, 170.0), Color(1.0, 1.0, 1.0, 0.08), 1.0)
	
	# Mechanical shift displacement mark on door wall (x=590)
	if is_door_shifted:
		var shift_x := 590.0 + _door_shift_offset
		draw_line(Vector2(shift_x - 14.0, 60.0), Vector2(shift_x - 14.0, 280.0), COLOR_CORRECTION * 0.6, 1.5)
		draw_line(Vector2(shift_x, 60.0), Vector2(shift_x, 280.0), COLOR_CYAN * 0.5, 1.0)
	
	# 2. Dialogue & subtitle display
	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_hud(dialogue_lines[dialogue_index])


func _draw_dialogue_hud(line: Dictionary) -> void:
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_witness: bool = line.get("is_witness", false)
	var is_lena: bool = line.get("is_lena", false)
	
	var box_rect := Rect2(60.0, 285.0, 520.0, 60.0)
	draw_rect(box_rect, Color(0.08, 0.12, 0.11, 0.88))
	
	var border_color := COLOR_AMBER if is_lena else (COLOR_CORRECTION if is_witness else COLOR_CYAN)
	draw_rect(box_rect, border_color * 0.7, false, 1.0)
	
	# Speaker header bar
	var bar_color := COLOR_AMBER if is_lena else (COLOR_CORRECTION if is_witness else COLOR_CYAN)
	draw_rect(Rect2(64.0, 288.0, 140.0, 3.0), bar_color)
