class_name Station13
extends Node2D

## Station 13 (Przestrzeń 13: Adres ciągłości / Schemat mieszkania i fotografia Jakuba) for Getting Strange Vertical Slice.
## Represents the archive backroom / spatial analysis cabinet behind the underpass.
## Features architectural blueprint drafting tables, topography index cabinets, a resonance circuit node,
## an optical frame accepting Lena's photograph of Jakub, and the technical airlock leading to Space 14.
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 13), and CONTINUITY_TRACKER.md (Clue R-05, Prop photograph).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("182126") # Sea graphite
const COLOR_ARCHIVE_WALL := Color("1b252b")
const COLOR_INFRASTRUCTURE := Color("a8b2ac") # Grey sage
const COLOR_AMBER := Color("d39a62") # Muted amber (Lena / Warmth)
const COLOR_CYAN := Color("75c7c3") # Cool cyan (Resonance / Consensus)
const COLOR_CORRECTION := Color("c65d58") # Oxide cinnabar (Discontinuity / Shadow emergence)
const COLOR_DARK_STEEL := Color("263943")
const COLOR_BLUEPRINT_PAPER := Color("162832")
const COLOR_BLUEPRINT_LINE := Color("2c4d5e")
const COLOR_CONCRETE := Color("27343d")

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal drafting_table_analyzed()
signal cabinet_indexed()
signal circuit_connected()
signal photo_inserted()
signal shadow_emergence_started()
signal shadow_emergence_completed()
signal circuit_aligned()
signal airlock_unlocked()
signal dialogue_started()
signal dialogue_advanced(line_idx: int)
signal dialogue_completed()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone

var drafting_table_inspected: bool = false
var cabinet_inspected: bool = false
var circuit_inspected: bool = false
var photo_frame_inspected: bool = false
var is_photo_inserted: bool = false
var is_shadow_developed: bool = false
var is_circuit_aligned: bool = false
var is_airlock_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _shadow_progress: float = 0.0
var _circuit_energy_progress: float = 0.0
var _airlock_open_progress: float = 0.0
var _pulse_time: float = 0.0

# Dialogue & Narrative Readouts for Space 13 (per FULL_STORY.md Scene 13 and NEXT_SESSION_PROMPT.md)
var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "LENA",
		"text": "Notatki lokalnej Leny... Rzut mieszkania numer 14 nie jest inwentaryzacją. To schemat obwodu.",
		"is_witness": false,
		"is_lena": true,
		"is_terminal": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Pozycje mebli i sprzętów wyznaczają współrzędne węzła w Podstrukturze. Brakuje jednego punktu odniesienia.",
		"is_witness": true,
		"is_lena": false,
		"is_terminal": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Kartoteka adresów zgodności. Każdy lokal ma przypisany wektor oporu. Mieszkanie 14 jest węzłem zerowym.",
		"is_witness": false,
		"is_lena": true,
		"is_terminal": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Układ jest martwy bez stałej personalnej. Szuka zakotwiczenia, którego ten świat nie potrafi wygenerować.",
		"is_witness": false,
		"is_lena": true,
		"is_terminal": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Puste gniazdo w ramie montażowej. Dokładnie ten format... Moje zdjęcie Jakuba.",
		"is_witness": false,
		"is_lena": true,
		"is_terminal": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Wsuwasz fotografię w gniazdo obwodu. Przekaźniki zatrzaskują się z metalicznym rezonansem.",
		"is_witness": true,
		"is_lena": false,
		"is_terminal": false,
		"is_stage_direction": true
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Na gładkiej emulsji obok młodego Jakuba zaczyna powoli narastać dorosły, ciemny cień.",
		"is_witness": true,
		"is_lena": false,
		"is_terminal": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Zrobiłam to. Otworzyłam przejście, ale fotografia... zdjęcie zaczyna go zmieniać. Pamięć jest kluczem i jednocześnie ceną.",
		"is_witness": false,
		"is_lena": true,
		"is_terminal": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Śluza techniczna zostaje odryglowana. Droga do Podstruktury stoi otworem.",
		"is_witness": true,
		"is_lena": false,
		"is_terminal": false,
		"is_stage_direction": true
	}
]


func _ready() -> void:
	if camera:
		camera.chamber_bounds = [Rect2(Vector2.ZERO, VIEW_SIZE)]
		camera.set_chamber(0, true)
	
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_zone_body_entered)
	
	_connect_prop_signals()
	station_entered.emit()
	queue_redraw()


func _connect_prop_signals() -> void:
	if not props:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			child.resonance_triggered.connect(_on_prop_resonance_triggered)


func _process(delta: float) -> void:
	_pulse_time += delta
	
	# Photo shadow development progression
	if is_photo_inserted and _shadow_progress < 1.0:
		_shadow_progress = minf(1.0, _shadow_progress + delta * 0.9)
		var photo_prop := props.get_node_or_null("JakubPhotographFrame") as MemoryResonancePoint
		if photo_prop:
			photo_prop.shadow_progress = _shadow_progress
		if _shadow_progress >= 1.0 and not is_shadow_developed:
			is_shadow_developed = true
			shadow_emergence_completed.emit()
	
	# Circuit energy propagation animation
	if is_circuit_aligned and _circuit_energy_progress < 1.0:
		_circuit_energy_progress = minf(1.0, _circuit_energy_progress + delta * 1.5)
	
	# Airlock unlock progress
	if is_airlock_unlocked and _airlock_open_progress < 1.0:
		_airlock_open_progress = minf(1.0, _airlock_open_progress + delta * 1.2)
	
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"interact"):
		if dialogue_active:
			advance_dialogue()
		else:
			_check_player_interactions()


func _check_player_interactions() -> void:
	if not props:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint and child.is_player_in_range:
			child.trigger_interaction()
			break


func _on_prop_resonance_triggered(id: String, type_idx: int) -> void:
	clue_inspected.emit(id, type_idx)
	
	if id == "prop_drafting_table":
		drafting_table_inspected = true
		drafting_table_analyzed.emit()
		if not dialogue_active and dialogue_index < 0:
			start_dialogue(0)
	elif id == "prop_cabinet":
		cabinet_inspected = true
		cabinet_indexed.emit()
		if not dialogue_active and dialogue_index < 2:
			start_dialogue(2)
	elif id == "prop_circuit_node":
		circuit_inspected = true
		circuit_connected.emit()
		if not dialogue_active and dialogue_index < 3:
			start_dialogue(3)
	elif id == "prop_photo_frame":
		photo_frame_inspected = true
		if not is_photo_inserted:
			insert_photograph()
	elif id == "prop_exit_airlock":
		if is_airlock_unlocked:
			complete_level()


func insert_photograph() -> void:
	if is_photo_inserted:
		return
	is_photo_inserted = true
	photo_inserted.emit()
	shadow_emergence_started.emit()
	
	var photo_prop := props.get_node_or_null("JakubPhotographFrame") as MemoryResonancePoint
	if photo_prop:
		photo_prop.is_activated = true
		photo_prop.shadow_progress = 0.05
	
	# Trigger circuit alignment and airlock unlock
	is_circuit_aligned = true
	circuit_aligned.emit()
	
	var node_prop := props.get_node_or_null("ResonanceCircuitNode") as MemoryResonancePoint
	if node_prop:
		node_prop.is_activated = true
	
	var airlock_prop := props.get_node_or_null("TechPassageAirlock") as MemoryResonancePoint
	if airlock_prop:
		airlock_prop.is_activated = true
	
	is_airlock_unlocked = true
	airlock_unlocked.emit()
	
	if camera:
		camera.add_trauma(0.3)
	
	start_dialogue(4)


func start_dialogue(start_idx: int = 0) -> void:
	dialogue_active = true
	dialogue_index = start_idx
	dialogue_started.emit()
	queue_redraw()


func advance_dialogue() -> int:
	if not dialogue_active:
		return -1
	
	dialogue_index += 1
	
	# Check specific narrative beats during dialogue progression
	if dialogue_index == 5:
		if not is_photo_inserted:
			insert_photograph()
	elif dialogue_index == 6:
		# Shadow emerges on photographic paper
		if _shadow_progress < 0.5:
			_shadow_progress = 0.6
	elif dialogue_index == 8:
		# Final clearance and airlock unlock confirmed
		is_airlock_unlocked = true
		var airlock_prop := props.get_node_or_null("TechPassageAirlock") as MemoryResonancePoint
		if airlock_prop:
			airlock_prop.is_activated = true
	
	if dialogue_index >= dialogue_lines.size():
		dialogue_active = false
		is_dialogue_completed = true
		dialogue_completed.emit()
		queue_redraw()
		return -1
	
	dialogue_advanced.emit(dialogue_index)
	queue_redraw()
	return dialogue_index


func complete_level() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _on_airlock_zone_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_airlock_unlocked:
		complete_level()


func _draw() -> void:
	_draw_archive_background()
	_draw_architectural_blueprints()
	_draw_conduit_cables()
	
	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_box()


func _draw_archive_background() -> void:
	# Archive back wall with acoustic damping panels and technical datums
	var bg_rect := Rect2(Vector2.ZERO, VIEW_SIZE)
	draw_rect(bg_rect, COLOR_BACKGROUND)
	
	# Wall panel division grid (horizontal datums every 40px)
	for y in range(40, 320, 40):
		draw_line(Vector2(0.0, float(y)), Vector2(LEVEL_WIDTH, float(y)), Color("1d272e"), 1.0)
	for x in range(80, 640, 80):
		draw_line(Vector2(float(x), 30.0), Vector2(float(x), 300.0), Color("1a2329"), 1.0)
	
	# Concrete floor base (y=290..360)
	var floor_rect := Rect2(0.0, 290.0, LEVEL_WIDTH, 70.0)
	draw_rect(floor_rect, COLOR_CONCRETE)
	draw_line(Vector2(0.0, 290.0), Vector2(LEVEL_WIDTH, 290.0), COLOR_INFRASTRUCTURE * 0.9, 1.5)
	
	# Baseboard conduit rail
	draw_rect(Rect2(0.0, 284.0, LEVEL_WIDTH, 6.0), Color("1d2830"))
	draw_line(Vector2(0.0, 284.0), Vector2(LEVEL_WIDTH, 284.0), Color("32434e"), 1.0)
	
	# Ceiling cable tray and structural concrete beam (y=0..35)
	draw_rect(Rect2(0.0, 0.0, LEVEL_WIDTH, 35.0), Color("131a1e"))
	draw_line(Vector2(0.0, 35.0), Vector2(LEVEL_WIDTH, 35.0), Color("223038"), 1.5)
	for tx in range(20, 620, 40):
		draw_line(Vector2(float(tx), 0.0), Vector2(float(tx), 35.0), Color("1a242a"), 1.0)


func _draw_architectural_blueprints() -> void:
	# Large blueprint pinboard behind the drafting table (x=80..220, y=55..190)
	var pinboard_rect := Rect2(80.0, 55.0, 140.0, 135.0)
	draw_rect(pinboard_rect, COLOR_BLUEPRINT_PAPER)
	draw_rect(pinboard_rect, COLOR_INFRASTRUCTURE * 0.7, false, 1.2)
	
	# Blueprint fine grid
	for by in range(65, 185, 15):
		draw_line(Vector2(85.0, float(by)), Vector2(215.0, float(by)), COLOR_BLUEPRINT_LINE * 0.7, 0.8)
	for bx in range(95, 215, 15):
		draw_line(Vector2(float(bx), 60.0), Vector2(float(bx), 185.0), COLOR_BLUEPRINT_LINE * 0.7, 0.8)
	
	# Architectural Floorplan: Flat 14 (Mieszkanie 14 / Węzeł Zerowy)
	# Outer perimeter
	draw_rect(Rect2(95.0, 75.0, 110.0, 95.0), COLOR_CYAN * 0.85, false, 1.5)
	# Room partitions
	draw_line(Vector2(95.0, 125.0), Vector2(165.0, 125.0), COLOR_CYAN * 0.75, 1.2)
	draw_line(Vector2(165.0, 75.0), Vector2(165.0, 170.0), COLOR_CYAN * 0.75, 1.2)
	draw_line(Vector2(130.0, 125.0), Vector2(130.0, 170.0), COLOR_CYAN * 0.75, 1.2)
	
	# Furniture vectors (Desk, Bed, Mirror, Kitchen Table) as circuit components
	# Desk node (x=110, y=95)
	draw_rect(Rect2(105.0, 90.0, 15.0, 10.0), COLOR_AMBER * 0.85, false, 1.0)
	draw_circle(Vector2(112.5, 95.0), 1.5, COLOR_AMBER)
	# Mirror node (x=145, y=145)
	draw_line(Vector2(140.0, 145.0), Vector2(150.0, 145.0), COLOR_CYAN, 1.5)
	draw_circle(Vector2(145.0, 145.0), 1.5, COLOR_CYAN)
	# Telephone / Cabinet node (x=185, y=100)
	draw_rect(Rect2(178.0, 95.0, 14.0, 12.0), COLOR_AMBER * 0.85, false, 1.0)
	draw_circle(Vector2(185.0, 101.0), 1.5, COLOR_AMBER)
	
	# Coordinate linking bus lines connecting furniture to Substructure vector
	draw_line(Vector2(112.5, 95.0), Vector2(185.0, 101.0), COLOR_AMBER * 0.7, 1.0)
	draw_line(Vector2(185.0, 101.0), Vector2(145.0, 145.0), COLOR_AMBER * 0.7, 1.0)
	
	# Blueprint title block
	draw_rect(Rect2(135.0, 160.0, 65.0, 8.0), Color("0f1920"))
	draw_line(Vector2(137.0, 164.0), Vector2(195.0, 164.0), COLOR_CYAN * 0.9, 1.0)
	
	# Secondary blueprint sheet: Substructure Node Matrix (x=240..340, y=70..170)
	var sheet2_rect := Rect2(240.0, 70.0, 100.0, 100.0)
	draw_rect(sheet2_rect, COLOR_BLUEPRINT_PAPER)
	draw_rect(sheet2_rect, Color("2d404d"), false, 1.0)
	# Radial topology grid lines
	for r in range(12, 45, 10):
		draw_arc(Vector2(290.0, 120.0), float(r), 0.0, TAU, 16, COLOR_BLUEPRINT_LINE, 0.8)
	draw_line(Vector2(250.0, 120.0), Vector2(330.0, 120.0), COLOR_CYAN * 0.7, 0.8)
	draw_line(Vector2(290.0, 80.0), Vector2(290.0, 160.0), COLOR_CYAN * 0.7, 0.8)
	draw_circle(Vector2(290.0, 120.0), 2.5, COLOR_CORRECTION if not is_photo_inserted else COLOR_CYAN)


func _draw_conduit_cables() -> void:
	# Heavy industrial cables linking drafting table -> cabinet -> circuit node -> photo frame -> airlock
	var cable_col := Color("121a20")
	var energy_col := COLOR_CYAN if is_circuit_aligned else Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.4)
	
	# Cable 1: Drafting table (x=140, y=260) to Cabinet (x=250, y=250)
	draw_line(Vector2(140.0, 275.0), Vector2(250.0, 275.0), cable_col, 3.0)
	draw_line(Vector2(140.0, 275.0), Vector2(250.0, 275.0), Color("2b3c46"), 1.2)
	
	# Cable 2: Cabinet (x=250, y=250) to Circuit Node (x=370, y=230)
	draw_line(Vector2(250.0, 275.0), Vector2(370.0, 275.0), cable_col, 3.0)
	draw_line(Vector2(370.0, 275.0), Vector2(370.0, 252.0), cable_col, 3.0)
	
	# Cable 3: Circuit Node (x=370, y=230) to Photo Frame (x=470, y=240)
	draw_line(Vector2(387.0, 230.0), Vector2(454.0, 240.0), cable_col, 2.5)
	if is_circuit_aligned:
		var pulse_glow := sin(_pulse_time * 4.0) * 0.3 + 0.7
		draw_line(Vector2(387.0, 230.0), Vector2(454.0, 240.0), Color(energy_col.r, energy_col.g, energy_col.b, pulse_glow), 1.2)
	
	# Cable 4: Photo Frame (x=470, y=240) to Airlock (x=590, y=245)
	draw_line(Vector2(486.0, 240.0), Vector2(572.0, 245.0), cable_col, 3.0)
	if is_airlock_unlocked:
		var pulse_glow2 := sin(_pulse_time * 5.0) * 0.25 + 0.75
		draw_line(Vector2(486.0, 240.0), Vector2(572.0, 245.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, pulse_glow2), 1.5)


func _draw_dialogue_box() -> void:
	var line: Dictionary = dialogue_lines[dialogue_index]
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_witness: bool = line.get("is_witness", false)
	var is_lena: bool = line.get("is_lena", false)
	var is_stage_direction: bool = line.get("is_stage_direction", false)
	
	var box_rect := Rect2(60.0, 280.0, 520.0, 68.0)
	draw_rect(box_rect, Color(0.08, 0.12, 0.15, 0.94))
	
	# Border color
	var border_color := COLOR_INFRASTRUCTURE
	if is_witness:
		border_color = COLOR_CORRECTION
	elif is_lena:
		border_color = COLOR_AMBER
	
	draw_rect(box_rect, border_color, false, 1.2)
	
	# Header bar with speaker name
	var header_rect := Rect2(60.0, 280.0, 520.0, 18.0)
	draw_rect(header_rect, Color(0.12, 0.18, 0.22, 0.95))
	draw_line(Vector2(60.0, 298.0), Vector2(580.0, 298.0), border_color * 0.7, 1.0)
	
	# Speaker tag
	var default_font := ThemeDB.fallback_font
	if default_font:
		var speaker_col := COLOR_AMBER if is_lena else (COLOR_CORRECTION if is_witness else COLOR_CYAN)
		draw_string(default_font, Vector2(72.0, 294.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 11, speaker_col)
		
		# Text content
		var text_col := Color("e6ece8") if not is_stage_direction else Color("a0b2aa")
		draw_string(default_font, Vector2(72.0, 314.0), text, HORIZONTAL_ALIGNMENT_LEFT, 496, 11, text_col)
		
		# Next prompt indicator
		var pulse := sin(_pulse_time * 4.0) * 0.5 + 0.5
		var prompt_str := "[E] Dalej..." if dialogue_index < dialogue_lines.size() - 1 else "[E] Zamknij"
		draw_string(default_font, Vector2(510.0, 340.0), prompt_str, HORIZONTAL_ALIGNMENT_RIGHT, -1, 9, Color(border_color.r, border_color.g, border_color.b, 0.5 + pulse * 0.5))
