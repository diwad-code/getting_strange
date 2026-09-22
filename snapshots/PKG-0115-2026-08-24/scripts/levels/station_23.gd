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
	# Vector-Stage state pass. The frame itself belongs to VectorStageEnvironment
	# (station_number = 23); this pass only moves the plane relations that carry state.
	_draw_state_layer()

	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_hud(dialogue_lines[dialogue_index])


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	# Practical source: the studio busbar above the drafting plane.
	var pulse := sin(_pulse_time * 2.2) * 0.5 + 0.5
	draw_line(
		Vector2(64.0, 88.0),
		Vector2(596.0, 74.0),
		Color(VectorStageStyle.HUMAN_AMBER, 0.24 + pulse * 0.22),
		1.5
	)
	# The Trace displaces the cursor: one plane slides sideways. No glitch, no split.
	if is_cursor_shifted:
		var slide := clampf(_shadow_cursor_offset, -24.0, 24.0)
		VectorStageStyle.draw_facet_polygon(
			self,
			PackedVector2Array([
				Vector2(456.0 + slide, 200.0),
				Vector2(504.0 + slide, 194.0),
				Vector2(510.0 + slide, 254.0),
				Vector2(460.0 + slide, 258.0),
			]),
			VectorStageStyle.light(VectorStageStyle.ANCHOR_CYAN, 0.18),
			1.0
		)
	# The handwritten note keeps its own edge: an anchored parameter, not a reward.
	if is_purpose_revealed or is_model_inspected:
		VectorStageStyle.draw_facet_polygon(
			self,
			PackedVector2Array([Vector2(262.0, 196.0), Vector2(306.0, 190.0), Vector2(310.0, 216.0), Vector2(266.0, 222.0)]),
			VectorStageStyle.light(VectorStageStyle.HUMAN_AMBER, 0.16),
			1.0
		)
	# Burdened register consulted: the ledger plane darkens by one step, nothing else.
	if is_burden_list_scrolled or is_ledger_inspected:
		VectorStageStyle.draw_facet_polygon(
			self,
			PackedVector2Array([Vector2(96.0, 238.0), Vector2(232.0, 216.0), Vector2(240.0, 258.0), Vector2(104.0, 272.0)]),
			VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.42),
			1.0
		)
	if _exit_open_progress > 0.0:
		var opening := 4.0 + _exit_open_progress * 22.0
		VectorStageStyle.draw_facet_polygon(
			self,
			PackedVector2Array([
				Vector2(596.0 - opening, 178.0),
				Vector2(596.0 + opening, 178.0),
				Vector2(596.0 + opening, 268.0),
				Vector2(596.0 - opening, 268.0),
			]),
			VectorStageStyle.LIGHT_PLANE,
			1.0
		)


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
