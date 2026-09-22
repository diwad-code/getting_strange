class_name Station23
extends Node2D

## Station 23 (Przestrzeń 23: Pokój projektantki / Model Podstruktury i uciekający kursor) for Getting Strange Vertical Slice.
## Features local Lena's private design studio within Podstruktura / Compliance Point 6.
## Implements Dialogue D-16 per DIALOGUE_SCRIPT.md & FULL_STORY.md (Scene 23):
## Lena discovers the physical Substructure model with handwritten note: "JEŚLI TO CZYTASZ, ZGODZIŁAM SIĘ NA TWOJE RYZYKO",
## investigates the burdened persons registry and interacts with the terminal command where the Shadow displaces the cursor.
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 23), DIALOGUE_SCRIPT.md (D-16).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("111718")
const COLOR_WALL_GRAPHITE := Color("1c2725")
const COLOR_WALL_DARK := Color("16201e")
const COLOR_INFRASTRUCTURE := Color("a8b2ac")
const COLOR_DARK_STEEL := Color("182426")
const COLOR_AMBER := Color("d9a05b")
const COLOR_AMBER_WARM := Color("e8c07a")
const COLOR_AMBER_GLOW := Color(0.851, 0.627, 0.357, 0.22)
const COLOR_CRT_GREEN := Color("68b8a5")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")
const COLOR_COPPER := Color("a67238")

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal designer_terminal_inspected()
signal model_inspected()
signal ledger_inspected()
signal cursor_shifted()
signal burden_list_scrolled()
signal purpose_revealed()
signal archive_confirmed()
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

var is_terminal_inspected: bool = false
var is_model_inspected: bool = false
var is_ledger_inspected: bool = false
var is_cursor_shifted: bool = false
var is_burden_list_scrolled: bool = false
var is_purpose_revealed: bool = false
var is_archive_confirmed: bool = false
var is_exit_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _exit_open_progress: float = 0.0
var _shadow_cursor_offset: float = 0.0

var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Na marginesie modelu Podstruktury widnieje odręczne pismo lokalnej Leny: JEŚLI TO CZYTASZ, ZGODZIŁAM SIĘ NA TWOJE RYZYKO.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Na moje.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Lena otwiera polecenie nadpisania wzorca. Kursor sam odsuwa się o jedno pole. Lena przesuwa go z powrotem. Kursor odsuwa się znowu.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Nie chcesz, żebym to zrobiła, czy nie chcesz, żebym zrobiła to teraz?",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Na monitorze zapala się jedno pole listy: OSOBY OBCIĄŻONE. Nie to, które wskazywała.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Odpowiadasz nie na to pytanie.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Lista przewija się sama. Zatrzymuje się na wierszu bez nazwiska.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Wiem, że tu jestem przez ciebie. Chcę wiedzieć po co.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Kursor wraca na polecenie nadpisania i zostaje. Ślad go nie zabiera.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Nie. Ty najpierw.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Zatwierdzałaś pierwsze korekty. Podpis jest twój.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Ekran gaśnie na jedną klatkę i wraca z tym samym widokiem.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Dobrze. To zostaw włączone.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	}
]


func _ready() -> void:
	_setup_station()
	_connect_signals()
	station_entered.emit()


func _process(delta: float) -> void:
	_pulse_time += delta
	if is_cursor_shifted:
		_shadow_cursor_offset = lerpf(_shadow_cursor_offset, 1.0, delta * 4.0)
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
		MemoryResonancePoint.PropType.DESIGNER_TERMINAL:
			is_terminal_inspected = true
			designer_terminal_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.SUBSTRUCTURE_ARCHITECTURAL_MODEL:
			is_model_inspected = true
			model_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.BURDENED_PERSONS_LEDGER:
			is_ledger_inspected = true
			ledger_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.SHADOW_INTERACTIVE_CONSOLE:
			is_cursor_shifted = true
			cursor_shifted.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.STATION_23_EXIT:
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
		_finish_scene()
		return -1
	
	if dialogue_index == 2:
		# Line 2: Cursor shift
		is_cursor_shifted = true
		cursor_shifted.emit()
	elif dialogue_index == 4 or dialogue_index == 6:
		# Lines 4-6: Burden ledger scroll
		is_burden_list_scrolled = true
		burden_list_scrolled.emit()
	elif dialogue_index == 7 or dialogue_index == 8:
		# Lines 7-8: Purpose revealed
		is_purpose_revealed = true
		purpose_revealed.emit()
	elif dialogue_index == 10 or dialogue_index == 12:
		# Lines 10-12: Archive confirmed
		is_archive_confirmed = true
		archive_confirmed.emit()
	
	dialogue_advanced.emit(dialogue_index)
	return dialogue_index


func _finish_scene() -> void:
	is_terminal_inspected = true
	is_model_inspected = true
	is_ledger_inspected = true
	is_cursor_shifted = true
	is_burden_list_scrolled = true
	is_purpose_revealed = true
	is_archive_confirmed = true
	_unlock_exit()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	if props:
		var exit_prop := props.get_node_or_null("Station23Exit") as MemoryResonancePoint
		if exit_prop:
			exit_prop.is_activated = true
		var terminal_prop := props.get_node_or_null("DesignerTerminal") as MemoryResonancePoint
		if terminal_prop:
			terminal_prop.is_activated = true
		var console_prop := props.get_node_or_null("ShadowInteractiveConsole") as MemoryResonancePoint
		if console_prop:
			console_prop.is_activated = true


func _on_airlock_entered(body: Node2D) -> void:
	if not is_exit_unlocked:
		return
	if is_level_completed:
		return
	if body is PrototypePlayer or body == player:
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	# 1. Base room background & wall structure (Pokój projektantki: 640x360)
	var bg_rect := Rect2(0.0, 0.0, VIEW_SIZE.x, VIEW_SIZE.y)
	draw_rect(bg_rect, COLOR_BACKGROUND)
	
	# Graphite plaster and copper conduit wall panel
	var wall_rect := Rect2(0.0, 40.0, VIEW_SIZE.x, 240.0)
	draw_rect(wall_rect, COLOR_WALL_GRAPHITE)
	
	# Subtle ceiling light strip
	draw_line(Vector2(60.0, 42.0), Vector2(580.0, 42.0), Color("cce4dc", 0.35), 2.0)
	draw_line(Vector2(120.0, 42.0), Vector2(280.0, 42.0), Color("ffffff", 0.55), 1.0)
	draw_line(Vector2(340.0, 42.0), Vector2(520.0, 42.0), Color("ffffff", 0.55), 1.0)
	
	# Copper busbars and cable raceways running along upper wall
	var pulse := sin(_pulse_time * 2.2) * 0.5 + 0.5
	var copper_alpha := 0.55 + pulse * 0.25
	draw_line(Vector2(40.0, 56.0), Vector2(600.0, 56.0), Color(COLOR_COPPER.r, COLOR_COPPER.g, COLOR_COPPER.b, copper_alpha), 2.0)
	draw_line(Vector2(40.0, 62.0), Vector2(600.0, 62.0), Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, copper_alpha * 0.7), 1.0)
	
	# Vertical drop cables to workstations
	draw_line(Vector2(140.0, 56.0), Vector2(140.0, 160.0), Color(COLOR_COPPER.r, COLOR_COPPER.g, COLOR_COPPER.b, 0.75), 1.2)
	draw_line(Vector2(260.0, 56.0), Vector2(260.0, 170.0), Color(COLOR_COPPER.r, COLOR_COPPER.g, COLOR_COPPER.b, 0.75), 1.2)
	draw_line(Vector2(380.0, 56.0), Vector2(380.0, 160.0), Color(COLOR_COPPER.r, COLOR_COPPER.g, COLOR_COPPER.b, 0.75), 1.2)
	draw_line(Vector2(490.0, 56.0), Vector2(490.0, 160.0), Color(COLOR_COPPER.r, COLOR_COPPER.g, COLOR_COPPER.b, 0.75), 1.2)
	
	# Floor line & dark industrial slate tile grid
	var floor_rect := Rect2(0.0, 280.0, VIEW_SIZE.x, 80.0)
	draw_rect(floor_rect, COLOR_WALL_DARK)
	draw_line(Vector2(0.0, 280.0), Vector2(VIEW_SIZE.x, 280.0), COLOR_INFRASTRUCTURE * 0.65, 2.0)
	
	for i in range(16):
		var tx := float(i) * 40.0
		draw_line(Vector2(tx, 280.0), Vector2(tx, 360.0), Color("0d1416"), 1.0)
		draw_line(Vector2(0.0, 280.0 + float(i) * 20.0), Vector2(VIEW_SIZE.x, 280.0 + float(i) * 20.0), Color("0d1416"), 1.0)
	
	# Wall panel seam lines
	for p in range(6):
		var px := 65.0 + float(p) * 102.0
		draw_line(Vector2(px, 40.0), Vector2(px, 280.0), Color("141e20"), 1.0)
	
	# Architectural drafting pinboard behind model: Blueprints and correlation curves
	var board_rect := Rect2(210.0, 80.0, 100.0, 65.0)
	draw_rect(board_rect, Color("142224"))
	draw_rect(board_rect, Color("2d464a", 0.8), false, 0.8)
	# Wireframe blueprint sketch on board
	draw_line(Vector2(220.0, 100.0), Vector2(290.0, 100.0), Color("68b8a5", 0.5), 0.8)
	draw_line(Vector2(220.0, 120.0), Vector2(290.0, 120.0), Color("68b8a5", 0.5), 0.8)
	draw_line(Vector2(235.0, 90.0), Vector2(275.0, 135.0), Color("d9a05b", 0.6), 0.8)
	
	# Institutional wall placard: "PODSTRUKTURA / GABINET PROJEKTOWY — WOLSKA, LENA"
	draw_rect(Rect2(160.0, 72.0, 310.0, 16.0), Color("131c1e"))
	draw_rect(Rect2(160.0, 72.0, 310.0, 16.0), COLOR_INFRASTRUCTURE * 0.35, false, 0.8)
	draw_line(Vector2(168.0, 80.0), Vector2(462.0, 80.0), Color("d9a05b", 0.75), 0.8)
	
	# Spotlights on drafting model (x=260) and Shadow console (x=490)
	draw_circle(Vector2(260.0, 42.0), 3.5, Color("e8c07a", 0.75))
	draw_circle(Vector2(490.0, 42.0), 3.5, Color("75c7c3", 0.75))
	
	# 2. Dialogue & subtitle display
	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_hud(dialogue_lines[dialogue_index])


func _draw_dialogue_hud(line: Dictionary) -> void:
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_witness: bool = line.get("is_witness", false)
	var is_lena: bool = line.get("is_lena", false)
	
	var box_rect := Rect2(60.0, 285.0, 520.0, 60.0)
	draw_rect(box_rect, Color(0.06, 0.09, 0.10, 0.92))
	
	var border_color := COLOR_AMBER if is_lena else (COLOR_CORRECTION if is_witness else COLOR_CYAN)
	draw_rect(box_rect, border_color * 0.75, false, 1.0)
	
	# Speaker header bar
	var bar_color := COLOR_AMBER if is_lena else (COLOR_CORRECTION if is_witness else COLOR_CYAN)
	draw_rect(Rect2(64.0, 288.0, 140.0, 3.0), bar_color)
	
	var font := ThemeDB.fallback_font
	if font:
		draw_string(font, Vector2(70.0, 304.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, bar_color)
		draw_string(font, Vector2(70.0, 324.0), text, HORIZONTAL_ALIGNMENT_LEFT, 500, 10, Color("dcebe4"))
