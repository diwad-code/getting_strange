class_name Station21
extends Node2D

## Station 21 (Przestrzeń 21: Cena ulgi / Pokój zabiegowo-adaptacyjny Szymona Bery) for Getting Strange Vertical Slice.
## Features the clinical sedation and neuro-adaptive treatment room in Compliance Point 6.
## Implements dialogue sequence for Scene 21 per FULL_STORY.md and DIALOGUE_SCRIPT.md (lines 307-316).
## Features Szymon Bera post-correction in recliner chair, UCP anesthesia vital console,
## filtered official dossier archive cassette, drawing disposition pedestal,
## and automated pressurized airlock to Space 22 (Uległość).
## First conscious player realization of separating public fact from private relationship.
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 21), DIALOGUE_SCRIPT.md (Scene 21).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("10181a")
const COLOR_WALL_PLASTER := Color("1e2a26")
const COLOR_WALL_LIGHT := Color("263630")
const COLOR_INFRASTRUCTURE := Color("a8b2ac")
const COLOR_DARK_STEEL := Color("1a2628")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.18)
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal szymon_approached()
signal terminal_inspected()
signal dossier_inspected()
signal pedestal_inspected()
signal erased_name_attempted()
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
var is_terminal_inspected: bool = false
var is_dossier_inspected: bool = false
var is_pedestal_inspected: bool = false
var is_erased_name_attempted: bool = false
var is_exit_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _exit_open_progress: float = 0.0
var _sedation_wave_phase: float = 0.0

var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "SZYMON",
		"text": "Kto to narysował?",
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
		"text": "Szymon próbuje powtórzyć. Aparat sedacji emituje szum, a imię nie przechodzi przez krtań.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "SZYMON",
		"text": "Nie zabieraj kartki. To miejsce po kimś.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Pamiętasz skażenie wody?",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "SZYMON",
		"text": "Woda w studni była zła. Naprawili przed świtem. Wszyscy pili ze spokojem.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Fakt publiczny został nienaruszony. Wymazano wyłącznie osobę, która go przyniosła.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Kto zgłosił studnię?",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "SZYMON",
		"text": "Nikt. Zgłoszenie było od zawsze.",
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
	_sedation_wave_phase += delta * 2.0
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
		MemoryResonancePoint.PropType.SZYMON_POST_CORRECTION:
			is_szymon_approached = true
			szymon_approached.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.ANESTHESIA_TERMINAL:
			is_terminal_inspected = true
			terminal_inspected.emit()
		MemoryResonancePoint.PropType.FILTERED_DOSSIER_SLOT:
			is_dossier_inspected = true
			dossier_inspected.emit()
		MemoryResonancePoint.PropType.DRAWING_DISPOSITION_PEDESTAL:
			is_pedestal_inspected = true
			pedestal_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.STATION_21_EXIT:
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
	
	if dialogue_index == 2:
		# Line 2: Witness stage direction / Szymon attempts to speak erased name
		is_erased_name_attempted = true
		erased_name_attempted.emit()
	
	dialogue_advanced.emit(dialogue_index)
	return dialogue_index


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	if props:
		var exit_prop := props.get_node_or_null("Station21Exit") as MemoryResonancePoint
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
	# 1. Base room background & wall structure (Sala Zabiegowa 21: 640x360)
	var bg_rect := Rect2(0.0, 0.0, VIEW_SIZE.x, VIEW_SIZE.y)
	draw_rect(bg_rect, COLOR_BACKGROUND)
	
	# Wall gradient / clinical plaster
	var wall_rect := Rect2(0.0, 40.0, VIEW_SIZE.x, 240.0)
	draw_rect(wall_rect, COLOR_WALL_PLASTER)
	
	# Subtle ceiling light strip
	draw_line(Vector2(60.0, 42.0), Vector2(580.0, 42.0), Color("dcebe4", 0.35), 2.0)
	draw_line(Vector2(100.0, 42.0), Vector2(260.0, 42.0), Color("ffffff", 0.55), 1.0)
	draw_line(Vector2(380.0, 42.0), Vector2(540.0, 42.0), Color("ffffff", 0.55), 1.0)
	
	# Neuro-sedation wave conduit along upper wall
	var wave_pulse := sin(_sedation_wave_phase) * 0.5 + 0.5
	draw_line(Vector2(120.0, 58.0), Vector2(520.0, 58.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.25 + wave_pulse * 0.25), 1.5)
	
	# Floor line & linoleum tiles
	var floor_rect := Rect2(0.0, 280.0, VIEW_SIZE.x, 80.0)
	draw_rect(floor_rect, Color("16201e"))
	draw_line(Vector2(0.0, 280.0), Vector2(VIEW_SIZE.x, 280.0), COLOR_INFRASTRUCTURE * 0.7, 2.0)
	
	for i in range(16):
		var tx := float(i) * 40.0
		draw_line(Vector2(tx, 280.0), Vector2(tx, 360.0), Color("121a18"), 1.0)
		draw_line(Vector2(0.0, 280.0 + float(i) * 20.0), Vector2(VIEW_SIZE.x, 280.0 + float(i) * 20.0), Color("121a18"), 1.0)
	
	# Wall panel seam lines
	for p in range(6):
		var px := 80.0 + float(p) * 95.0
		draw_line(Vector2(px, 40.0), Vector2(px, 280.0), Color("182420"), 1.0)
	
	# Institutional wall placard: "PUNKT ZGODNOŚCI 6 / ZABIEGOWY 21 — SEDACJA ADAPTACYJNA"
	draw_rect(Rect2(180.0, 75.0, 260.0, 18.0), Color("141e1c"))
	draw_rect(Rect2(180.0, 75.0, 260.0, 18.0), COLOR_INFRASTRUCTURE * 0.4, false, 0.8)
	draw_line(Vector2(188.0, 84.0), Vector2(432.0, 84.0), Color("9eb6ac"), 0.8)
	
	# Overhead treatment lamp focusing soft cone of light on Szymon's recliner (x=270)
	draw_line(Vector2(270.0, 42.0), Vector2(270.0, 70.0), Color("344844"), 2.0)
	draw_circle(Vector2(270.0, 72.0), 7.0, Color("486058"))
	draw_circle(Vector2(270.0, 72.0), 5.0, Color("dcf4ea", 0.85))
	
	# 2. Dialogue & subtitle display
	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_hud(dialogue_lines[dialogue_index])


func _draw_dialogue_hud(line: Dictionary) -> void:
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_witness: bool = line.get("is_witness", false)
	var is_lena: bool = line.get("is_lena", false)
	
	var box_rect := Rect2(60.0, 285.0, 520.0, 60.0)
	draw_rect(box_rect, Color(0.06, 0.10, 0.09, 0.90))
	
	var border_color := COLOR_AMBER if is_lena else (COLOR_CORRECTION if is_witness else COLOR_CYAN)
	draw_rect(box_rect, border_color * 0.7, false, 1.0)
	
	# Speaker header bar
	var bar_color := COLOR_AMBER if is_lena else (COLOR_CORRECTION if is_witness else COLOR_CYAN)
	draw_rect(Rect2(64.0, 288.0, 140.0, 3.0), bar_color)
	
	var font := ThemeDB.fallback_font
	if font:
		draw_string(font, Vector2(70.0, 304.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, bar_color)
		draw_string(font, Vector2(70.0, 324.0), text, HORIZONTAL_ALIGNMENT_LEFT, 500, 10, Color("dcebe4"))

