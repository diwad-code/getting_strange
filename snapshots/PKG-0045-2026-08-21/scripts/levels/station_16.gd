class_name Station16
extends Node2D

## Station 16 (Przestrzeń 16: Rozmowa przy stole / Mieszkanie 14 nocą, pęknięta filiżanka Marty, katalogowanie dowodów i wybór z obrączką) for Getting Strange Vertical Slice.
## Represents the intimate nocturnal return to Apartment 14.
## Features the kitchen table under a warm amber pendant lamp, Marta gluing her cracked ceramic teacup (kintsugi repair),
## the correlation dossier cataloging clues R-01..R-06, a wall clock ticking with asynchronous hesitation,
## the porcelain dish with the golden wedding ring (interactive narrative choice),
## and the glass balcony door leading to Space 17 (Ucieczka po gzymsie).
## Conforms to VISUAL_DESIGN.md (Sections 6.3, 7.1, 7.4), FULL_STORY.md (Scene 16), DIALOGUE_SCRIPT.md (Scene D-05), and CONTINUITY_TRACKER.md (ring_disposition & R-01..R-06).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("12181e") # Deep nocturnal graphite
const COLOR_WALL := Color("1a232b") # Apartment wall tone
const COLOR_CONCRETE := Color("212d36")
const COLOR_INFRASTRUCTURE := Color("a8b2ac") # Grey sage
const COLOR_AMBER := Color("d39a62") # Warm amber (Domestic illumination & Lena)
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.18)
const COLOR_CYAN := Color("75c7c3") # Cool cyan (Anchor Resonance & Choice revelation)
const COLOR_CORRECTION := Color("c65d58") # Oxide cinnabar
const COLOR_DARK_WOOD := Color("2a2019")
const COLOR_TABLE_WOOD := Color("3a2b22")
const COLOR_CERATA := Color("483930")

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal cup_inspected()
signal dossier_reviewed()
signal clock_inspected()
signal ring_choice_made(choice: String)
signal balcony_unlocked()
signal dialogue_started()
signal dialogue_advanced(line_idx: int)
signal dialogue_completed()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone

var is_cup_inspected: bool = false
var is_dossier_reviewed: bool = false
var is_clock_inspected: bool = false
var is_ring_chosen: bool = false
var ring_disposition: String = "" # "wear", "leave", or "sample"
var is_balcony_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _clock_tick_timer: float = 0.0
var _balcony_open_progress: float = 0.0

# Dialogue & Narrative Readouts for Space 16 (Scene 16 per FULL_STORY.md, Scene D-05 per DIALOGUE_SCRIPT.md)
var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "LENA",
		"text": "Powrót do mieszkania czternaście... Marta siedzi przy kuchennym stole pod bursztynową lampą. Skleja pękniętą filiżankę.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Marta skleja filiżankę technicznym klejem. Lena rozkłada na ceracie fotografie i poszlaki R-01..R-06 według dat.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "MARTA",
		"text": "Jeśli ustawisz je równo, nic się na nich nie poprawi.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Daty są w złej kolejności.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "MARTA",
		"text": "Daty są nasze. Kolejność też była.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "W moim świecie się nie znałyśmy.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Marta przestaje dociskać pęknięcie. Kropla kleju wypływa na blat stołu obok fotografii Jakuba.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "MARTA",
		"text": "Pytałam?",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Chciałaś.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "MARTA",
		"text": "Chciałam, żebyś nie odpowiadała tak szybko.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Złota obrączka zebrana w autobusie leży na talerzyku... Czas zdecydować o jej przeznaczeniu.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Wybór obrączki ustala relację z Martą i stosunek do nowej rzeczywistości.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Drzwi balkonowe są uchylone. Za oknem nocne Osiedle Tarasowe... Czas ruszać gzymsem ku Podstrukturze.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	}
]


func _ready() -> void:
	station_entered.emit()
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_zone_entered)
	_connect_props()


func _connect_props() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			child.resonance_triggered.connect(_on_prop_resonance_triggered)


func _process(delta: float) -> void:
	_pulse_time += delta
	_clock_tick_timer += delta
	if is_balcony_unlocked and _balcony_open_progress < 1.0:
		_balcony_open_progress = minf(1.0, _balcony_open_progress + delta * 2.0)
	queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type_val: int) -> void:
	clue_inspected.emit(id, prop_type_val)
	
	if prop_type_val == MemoryResonancePoint.PropType.CRACKED_TEA_CUP:
		if not is_cup_inspected:
			is_cup_inspected = true
			cup_inspected.emit()
			if not dialogue_active and not is_dialogue_completed:
				start_dialogue(0)
	
	elif prop_type_val == MemoryResonancePoint.PropType.CORRELATION_DOSSIER:
		if not is_dossier_reviewed:
			is_dossier_reviewed = true
			dossier_reviewed.emit()
			if not dialogue_active and not is_dialogue_completed:
				start_dialogue(0)
	
	elif prop_type_val == MemoryResonancePoint.PropType.KITCHEN_CLOCK:
		if not is_clock_inspected:
			is_clock_inspected = true
			clock_inspected.emit()
	
	elif prop_type_val == MemoryResonancePoint.PropType.WEDDING_RING_STAND:
		if not is_ring_chosen:
			# Default interactive disposition if triggered directly
			make_ring_choice("leave")
		if not dialogue_active and not is_dialogue_completed:
			start_dialogue(10)
	
	elif prop_type_val == MemoryResonancePoint.PropType.BALCONY_EXIT_DOOR:
		if is_balcony_unlocked:
			# Complete level if interacting with unlocked balcony door
			complete_level()


func make_ring_choice(choice: String) -> void:
	ring_disposition = choice
	is_ring_chosen = true
	ring_choice_made.emit(choice)
	
	# Update Line 11 according to decision per DIALOGUE_SCRIPT.md
	if choice == "wear":
		dialogue_lines[11] = {
			"speaker": "ŚWIADECTWO PAMIĘCI",
			"text": "Wsuwasz złotą obrączkę na palec. Chłód metalu stabilizuje relację — przyjmujesz status żony w nowym świecie.",
			"is_witness": true,
			"is_lena": false,
			"is_stage_direction": true
		}
	elif choice == "leave":
		dialogue_lines[11] = {
			"speaker": "MARTA",
			"text": "LENA: »To jest twoje.« — MARTA: »Nie. Ja swojej nie zgubiłam.« Kładzie obie obok siebie, nie wkłada żadnej.",
			"is_witness": false,
			"is_lena": false,
			"is_stage_direction": false
		}
	elif choice == "sample":
		dialogue_lines[11] = {
			"speaker": "LENA",
			"text": "Chowasz obrączkę do kieszeni fartucha. Próbka laboratoryjna zero — neutralny ślad przejścia.",
			"is_witness": false,
			"is_lena": true,
			"is_stage_direction": false
		}
	
	# Unlocking the balcony door once choice is made
	unlock_balcony_exit()


func unlock_balcony_exit() -> void:
	if not is_balcony_unlocked:
		is_balcony_unlocked = true
		balcony_unlocked.emit()
		var balcony_prop := props.get_node_or_null("BalconyExitDoor") as MemoryResonancePoint
		if balcony_prop:
			balcony_prop.is_activated = true


func start_dialogue(start_idx: int = 0) -> void:
	dialogue_active = true
	dialogue_index = start_idx
	dialogue_started.emit()
	dialogue_advanced.emit(dialogue_index)


func advance_dialogue() -> int:
	if not dialogue_active:
		return -1
	
	dialogue_index += 1
	if dialogue_index >= dialogue_lines.size():
		dialogue_active = false
		is_dialogue_completed = true
		dialogue_completed.emit()
		unlock_balcony_exit()
		return -1
	
	dialogue_advanced.emit(dialogue_index)
	return dialogue_index


func complete_level() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _on_airlock_zone_entered(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		complete_level()


func _draw() -> void:
	# 1. Background wall and nocturnal atmosphere
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), COLOR_BACKGROUND)
	draw_rect(Rect2(0.0, 30.0, 640.0, 250.0), COLOR_WALL)
	
	# 2. Large window behind kitchen table looking out to nighttime Osiedle Tarasowe
	var window_rect := Rect2(200.0, 45.0, 240.0, 130.0)
	draw_rect(window_rect, Color("0a1014"))
	draw_rect(window_rect, Color("222e37"), false, 1.4)
	# Window panes dividing mullions
	draw_line(Vector2(320.0, 45.0), Vector2(320.0, 175.0), Color("1e2932"), 1.2)
	draw_line(Vector2(200.0, 110.0), Vector2(440.0, 110.0), Color("1e2932"), 1.2)
	
	# Distant nighttime apartment block silhouettes and warm window dots
	draw_rect(Rect2(215.0, 80.0, 50.0, 95.0), Color("131c23"))
	draw_rect(Rect2(280.0, 60.0, 70.0, 115.0), Color("0f171d"))
	draw_rect(Rect2(365.0, 75.0, 60.0, 100.0), Color("131c23"))
	# Glowing window dots
	draw_rect(Rect2(225.0, 95.0, 3.0, 3.0), Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.45))
	draw_rect(Rect2(245.0, 120.0, 3.0, 3.0), Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.35))
	draw_rect(Rect2(295.0, 75.0, 3.0, 3.0), Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.55))
	draw_rect(Rect2(325.0, 105.0, 3.0, 3.0), Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.40))
	draw_rect(Rect2(380.0, 90.0, 3.0, 3.0), Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.50))
	draw_rect(Rect2(405.0, 130.0, 3.0, 3.0), Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.30))
	
	# 3. Kitchen cabinets on left side (x=20..180)
	draw_rect(Rect2(20.0, 50.0, 150.0, 85.0), Color("1f2932"))
	draw_rect(Rect2(20.0, 50.0, 150.0, 85.0), COLOR_INFRASTRUCTURE * 0.5, false, 1.0)
	# Cabinet door vertical divisions & brass handles
	draw_line(Vector2(70.0, 50.0), Vector2(70.0, 135.0), Color("2b3844"), 1.0)
	draw_line(Vector2(120.0, 50.0), Vector2(120.0, 135.0), Color("2b3844"), 1.0)
	draw_rect(Rect2(64.0, 90.0, 2.0, 8.0), Color("7e683b"))
	draw_rect(Rect2(74.0, 90.0, 2.0, 8.0), Color("7e683b"))
	draw_rect(Rect2(114.0, 90.0, 2.0, 8.0), Color("7e683b"))
	draw_rect(Rect2(124.0, 90.0, 2.0, 8.0), Color("7e683b"))
	
	# 4. Hanging pendant lamp above the kitchen table (x=310, y=30..130)
	# Cord
	draw_line(Vector2(310.0, 30.0), Vector2(310.0, 130.0), Color("242220"), 1.2)
	# Amber shade
	var shade_points := PackedVector2Array([
		Vector2(304.0, 130.0),
		Vector2(316.0, 130.0),
		Vector2(324.0, 142.0),
		Vector2(296.0, 142.0)
	])
	draw_colored_polygon(shade_points, Color("3d2c20"))
	draw_polyline(shade_points, COLOR_AMBER, 1.0)
	# Glowing filament bulb
	draw_circle(Vector2(310.0, 143.0), 3.0, Color("ffebaa"))
	
	# Warm amber conical lighting cone over the table (VISUAL_DESIGN.md section 7.4)
	var light_cone := PackedVector2Array([
		Vector2(310.0, 143.0),
		Vector2(460.0, 280.0),
		Vector2(160.0, 280.0)
	])
	draw_colored_polygon(light_cone, COLOR_AMBER_GLOW)
	
	# 5. Kitchen Table and chairs
	# Left Chair (Marta's seat)
	draw_rect(Rect2(205.0, 220.0, 4.0, 60.0), Color("221a14"))
	draw_rect(Rect2(205.0, 252.0, 24.0, 4.0), Color("2e221a"))
	draw_rect(Rect2(225.0, 256.0, 4.0, 24.0), Color("221a14"))
	
	# Marta's seated silhouette at table
	# Torso & arms resting on table
	draw_rect(Rect2(212.0, 224.0, 16.0, 32.0), Color("2d3a35")) # Marta's sage green wool sweater
	draw_circle(Vector2(220.0, 216.0), 6.5, Color("35453f")) # Head
	draw_circle(Vector2(220.0, 215.0), 6.8, Color("1e2623"), false, 0.8) # Dark hair contour
	# Hands reaching toward cup at table
	draw_line(Vector2(224.0, 238.0), Vector2(245.0, 242.0), Color("2d3a35"), 3.0)
	draw_circle(Vector2(246.0, 242.0), 2.2, Color("a88970")) # Hand holding glue tube
	
	# Kitchen Table (x=220..440, y=248..280)
	var table_top := Rect2(220.0, 248.0, 220.0, 8.0)
	draw_rect(table_top, COLOR_TABLE_WOOD)
	draw_rect(Rect2(224.0, 249.0, 212.0, 4.0), COLOR_CERATA) # Vinyl table cloth (cerata)
	# Table legs
	draw_rect(Rect2(235.0, 256.0, 6.0, 24.0), COLOR_DARK_WOOD)
	draw_rect(Rect2(420.0, 256.0, 6.0, 24.0), COLOR_DARK_WOOD)
	
	# Right Chair (Empty chair for Lena)
	draw_rect(Rect2(435.0, 220.0, 4.0, 60.0), Color("221a14"))
	draw_rect(Rect2(415.0, 252.0, 24.0, 4.0), Color("2e221a"))
	draw_rect(Rect2(415.0, 256.0, 4.0, 24.0), Color("221a14"))
	
	# 6. Main Floor (y=280..360)
	draw_rect(Rect2(0.0, 280.0, 640.0, 80.0), COLOR_CONCRETE)
	draw_line(Vector2(0.0, 280.0), Vector2(640.0, 280.0), COLOR_INFRASTRUCTURE * 0.8, 1.2)
	# Wooden baseboard
	draw_rect(Rect2(0.0, 274.0, 640.0, 6.0), Color("241d18"))
	
	# Floor plank seams (subtle parquet floor texture)
	for px in range(20, 640, 40):
		draw_line(Vector2(float(px), 280.0), Vector2(float(px), 360.0), Color("1a242b"), 0.8)
	
	# 7. Balcony threshold & exit frame on right side (x=560..610)
	draw_rect(Rect2(560.0, 278.0, 50.0, 4.0), COLOR_INFRASTRUCTURE)
	if is_balcony_unlocked:
		# Luminous cyan floor trail towards balcony
		var pulse := sin(_pulse_time * 2.5) * 0.5 + 0.5
		draw_line(Vector2(565.0, 279.0), Vector2(610.0, 279.0), COLOR_CYAN, 1.6 + pulse * 0.6)
	
	# 8. Dialogue Subtitles Box (if dialogue active)
	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_hud()


func _draw_dialogue_hud() -> void:
	var line_data: Dictionary = dialogue_lines[dialogue_index]
	var speaker: String = line_data.get("speaker", "")
	var text: String = line_data.get("text", "")
	var is_witness: bool = line_data.get("is_witness", false)
	var is_lena: bool = line_data.get("is_lena", false)
	
	var box_rect := Rect2(30.0, 290.0, 580.0, 60.0)
	draw_rect(box_rect, Color(0.08, 0.11, 0.14, 0.92))
	var border_col := COLOR_AMBER if is_lena else (COLOR_CYAN if is_witness else COLOR_INFRASTRUCTURE)
	draw_rect(box_rect, border_col, false, 1.2)
	
	# Speaker badge indicator
	var badge_col := COLOR_AMBER if is_lena else (COLOR_CYAN if is_witness else Color("a0b8a6"))
	draw_rect(Rect2(40.0, 294.0, 6.0, 12.0), badge_col)
