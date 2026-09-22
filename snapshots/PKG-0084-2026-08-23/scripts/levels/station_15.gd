class_name Station15
extends Node2D

## Station 15 (Przestrzeń 15: Korytarz serwisowy / Pismo lokalnej Leny, instrukcje higieny ciągłości i odwrócona strzałka w odbiciu kałuży) for Getting Strange Vertical Slice.
## Represents the narrow technical transmission corridor within the UCP infrastructure.
## Features industrial catwalk grating, overhead correlation pipeline conduits, wall-mounted continuity hygiene rules,
## handwritten formulas scribbled on conduit casing in local Lena's handwriting (Clue R-06),
## an asynchronous reflective puddle revealing the true directional vector, a manual pressure relief valve,
## and the electromagnetic transit service gate leading to Space 16 (Rozmowa przy stole).
## Conforms to VISUAL_DESIGN.md (Section 6.3 Odbicia i asynchronia / Paleta UCP), FULL_STORY.md (Scene 15), and CONTINUITY_TRACKER.md (Clue R-06).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("141c21") # Dark sea graphite
const COLOR_CONCRETE := Color("1d272d")
const COLOR_INFRASTRUCTURE := Color("a8b2ac") # Grey sage
const COLOR_AMBER := Color("d39a62") # Muted amber (Lena / Warmth)
const COLOR_CYAN := Color("75c7c3") # Cool cyan (Anchor Resonance / Vector Revelation)
const COLOR_CORRECTION := Color("c65d58") # Oxide cinnabar (False consensus / Pressure danger)
const COLOR_DARK_STEEL := Color("24333b")
const COLOR_CATWALK_GRID := Color("2a3c47")
const COLOR_PIPE_CASING := Color("1f2d36")

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal hygiene_board_inspected()
signal correlation_formula_discovered()
signal reflection_vector_revealed()
signal pressure_valve_released()
signal transit_gate_unlocked()
signal dialogue_started()
signal dialogue_advanced(line_idx: int)
signal dialogue_completed()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone

var is_hygiene_inspected: bool = false
var is_formula_discovered: bool = false
var is_reflection_revealed: bool = false
var is_pressure_released: bool = false
var is_gate_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _drip_timer: float = 0.0
var _drip_y: float = 80.0
var _pressure_vent_progress: float = 0.0
var _gate_open_progress: float = 0.0

# Dialogue & Narrative Readouts for Space 15 (per FULL_STORY.md Scene 15, CONTINUITY_TRACKER.md R-06, VISUAL_DESIGN.md 6.3)
var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "LENA",
		"text": "Korytarz serwisowy infrastruktury UCP... Kładka stalowa drży pod stopami. Rury magistrali korelacyjnej biegną wzdłuż sufitu.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Ścienna gablota zawiera urzędową tablicę higieny ciągłości: »Zasady postępowania w strefach rozbieżności«. W rogu widnieją odręczne adnotacje ołówkiem.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "»W razie wystąpienia sprzeczności nie szukać źródła pierwotnego. Podtrzymać wersję o najwyższej gęstości świadków«.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Równania korelacyjne na obudowie rury... Znam ten charakter pisma. Ciasne litery, otwarta cyfra cztery. To pismo lokalnej Leny.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Formuła synchronizacji węzła: Psi_sync = oint A dl + dtau. Lokalna Lena nie tylko uciekała przed systemem — ona współtworzyła jego architekturę.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Ona zaprojektowała węzły pamięciowe UCP... System, który teraz wymazuje ludzi, powstał na bazie jej własnych obliczeń.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Na ścianie namalowano strzałkę prowadzącą w lewo, w ślepy zaułek... Ale spójrz na tę kałużę wody technicznej pod rurociągiem.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "W bezpośrednim świetle znak wskazuje fałszywy kierunek konsensusu. Dopiero w odbiciu kałuży ujawnia się właściwy wektor — strzałka skręca w prawo, ku zaworowi magistrali.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Ślad odwrócił strzałkę w odbiciu. Prawdziwe przejście wymaga dekompresji magistrali korelacyjnej.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Otwierasz zawór upustowy. Gorąca para uchodzi z sykiem, zrzucając ciśnienie w komorze. Rygiel elektromagnetyczny bramy serwisowej zwalnia docisk.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Magistrala ustabilizowana. Brama do przejścia tranzytowego staje otworem. Czas wrócić do mieszkania i skonfrontować dowody z Martą.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Przejście serwisowe odryglowane. Droga prowadzi ku Przestrzeni 16: Rozmowa przy stole.",
		"is_witness": true,
		"is_lena": false,
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
	
	# Condensation droplet animation (drips from overhead pipe into puddle)
	_drip_timer += delta * 1.6
	if _drip_timer > 1.0:
		_drip_timer = 0.0
	_drip_y = lerpf(80.0, 305.0, _drip_timer * _drip_timer)
	
	# Pressure relief vent steam expansion
	if is_pressure_released and _pressure_vent_progress < 1.0:
		_pressure_vent_progress = minf(1.0, _pressure_vent_progress + delta * 1.5)
	
	# Transit gate sliding opening transition
	if is_gate_unlocked and _gate_open_progress < 1.0:
		_gate_open_progress = minf(1.0, _gate_open_progress + delta * 1.2)
	
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
	
	if id == "prop_hygiene_board":
		inspect_hygiene_board()
	elif id == "prop_correlation_formula":
		discover_correlation_formula()
	elif id == "prop_reflective_puddle":
		reveal_reflection_vector()
	elif id == "prop_pressure_valve":
		release_pressure_valve()
	elif id == "prop_service_gate":
		if is_gate_unlocked:
			complete_level()


func inspect_hygiene_board() -> void:
	is_hygiene_inspected = true
	hygiene_board_inspected.emit()
	
	var board_prop := props.get_node_or_null("HygieneInstructionBoard") as MemoryResonancePoint
	if board_prop:
		board_prop.is_activated = true
	
	if not dialogue_active and dialogue_index < 0:
		start_dialogue(0)


func discover_correlation_formula() -> void:
	is_formula_discovered = true
	correlation_formula_discovered.emit()
	
	var formula_prop := props.get_node_or_null("HandwrittenCorrelationFormula") as MemoryResonancePoint
	if formula_prop:
		formula_prop.is_activated = true
	
	if not dialogue_active or dialogue_index < 3:
		start_dialogue(3)


func reveal_reflection_vector() -> void:
	is_reflection_revealed = true
	reflection_vector_revealed.emit()
	
	var puddle_prop := props.get_node_or_null("ReflectivePuddle") as MemoryResonancePoint
	if puddle_prop:
		puddle_prop.is_activated = true
	
	if not dialogue_active or dialogue_index < 6:
		start_dialogue(6)


func release_pressure_valve() -> void:
	is_pressure_released = true
	pressure_valve_released.emit()
	
	var valve_prop := props.get_node_or_null("PressureReliefValve") as MemoryResonancePoint
	if valve_prop:
		valve_prop.is_activated = true
	
	if camera:
		camera.add_trauma(0.30)
	
	# Unlock the transit gate once pressure is dumped and reflection was observed
	unlock_transit_gate()
	
	if not dialogue_active or dialogue_index < 9:
		start_dialogue(9)


func unlock_transit_gate() -> void:
	if is_gate_unlocked:
		return
	is_gate_unlocked = true
	transit_gate_unlocked.emit()
	
	var gate_prop := props.get_node_or_null("TransitServiceGate") as MemoryResonancePoint
	if gate_prop:
		gate_prop.is_activated = true


func start_dialogue(start_idx: int = 0) -> void:
	dialogue_active = true
	dialogue_index = start_idx
	dialogue_started.emit()
	dialogue_advanced.emit(dialogue_index)
	queue_redraw()


func advance_dialogue() -> void:
	if not dialogue_active:
		return
	
	# Dialogue checkpoint blocks
	if dialogue_index == 2 and not is_formula_discovered:
		dialogue_active = false
		queue_redraw()
		return
	elif dialogue_index == 5 and not is_reflection_revealed:
		dialogue_active = false
		queue_redraw()
		return
	elif dialogue_index == 8 and not is_pressure_released:
		dialogue_active = false
		queue_redraw()
		return
	
	dialogue_index += 1
	if dialogue_index < dialogue_lines.size():
		dialogue_advanced.emit(dialogue_index)
	else:
		dialogue_active = false
		is_dialogue_completed = true
		dialogue_completed.emit()
	queue_redraw()


func _on_airlock_zone_body_entered(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		if is_gate_unlocked:
			complete_level()


func complete_level() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _draw() -> void:
	_draw_background_corridor()
	_draw_conduit_piping()
	_draw_catwalk_grating()
	_draw_condensation_drips()
	_draw_steam_exhaust()
	
	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_overlay()


func _draw_background_corridor() -> void:
	# Main service conduit wall background
	draw_rect(Rect2(Vector2.ZERO, VIEW_SIZE), COLOR_BACKGROUND)
	
	# Raw reinforced concrete wall bays with expansion seams
	for bay in range(6):
		var bx := float(bay) * 110.0
		var bay_rect := Rect2(bx, 40.0, 105.0, 240.0)
		var bay_col := COLOR_CONCRETE if bay % 2 == 0 else Color("192329")
		draw_rect(bay_rect, bay_col)
		# Seam shadow
		draw_line(Vector2(bx + 105.0, 40.0), Vector2(bx + 105.0, 280.0), Color("10161a"), 2.0)
		# Vertical rebar alignment markings
		for r in [25.0, 55.0, 85.0]:
			draw_line(Vector2(bx + r, 50.0), Vector2(bx + r, 270.0), Color("151c22"), 1.0)
	
	# Horizontal ceiling cable tray & wire harness
	draw_rect(Rect2(0.0, 36.0, 640.0, 12.0), Color("1b262d"))
	draw_line(Vector2(0.0, 42.0), Vector2(640.0, 42.0), Color("2f424e"), 1.5)
	for cx in range(15, 640, 35):
		draw_line(Vector2(float(cx), 36.0), Vector2(float(cx), 48.0), COLOR_INFRASTRUCTURE * 0.7, 1.0)
	
	# Industrial caged fluorescent light fixtures along ceiling
	for fx in [100.0, 240.0, 380.0, 520.0]:
		var cage_rect := Rect2(fx - 18.0, 48.0, 36.0, 8.0)
		draw_rect(cage_rect, Color("253641"))
		draw_rect(cage_rect, COLOR_INFRASTRUCTURE * 0.8, false, 1.0)
		# Tube filament
		draw_line(Vector2(fx - 14.0, 52.0), Vector2(fx + 14.0, 52.0), Color("bfe3e0"), 1.5)
		# Cage wire bars
		for cb in [-10.0, -3.0, 3.0, 10.0]:
			draw_line(Vector2(fx + cb, 48.0), Vector2(fx + cb, 56.0), Color("172127"), 1.0)
		# Downward illumination cone
		var cone_pts := PackedVector2Array([
			Vector2(fx - 16.0, 56.0),
			Vector2(fx + 16.0, 56.0),
			Vector2(fx + 42.0, 280.0),
			Vector2(fx - 42.0, 280.0)
		])
		draw_colored_polygon(cone_pts, Color(0.46, 0.78, 0.76, 0.04))


func _draw_conduit_piping() -> void:
	# Main overhead high-pressure correlation pipeline (horizontal at y=72, diam=18px)
	var pipe_rect := Rect2(0.0, 64.0, 640.0, 18.0)
	draw_rect(pipe_rect, COLOR_PIPE_CASING)
	draw_line(Vector2(0.0, 68.0), Vector2(640.0, 68.0), Color("344855"), 2.0)
	draw_line(Vector2(0.0, 78.0), Vector2(640.0, 78.0), Color("11181e"), 2.0)
	draw_rect(pipe_rect, Color("293b46"), false, 1.0)
	
	# Pipe connecting flanges and support hangers
	for px in range(40, 640, 75):
		draw_rect(Rect2(float(px) - 3.0, 60.0, 6.0, 26.0), Color("2b3c47"))
		draw_rect(Rect2(float(px) - 3.0, 60.0, 6.0, 26.0), COLOR_INFRASTRUCTURE * 0.75, false, 0.8)
		# Ceiling hanger rod
		draw_line(Vector2(float(px), 36.0), Vector2(float(px), 60.0), COLOR_DARK_STEEL, 2.0)
	
	# Secondary vertical feed pipe descending at x=480 down to the pressure relief valve
	draw_rect(Rect2(476.0, 82.0, 8.0, 135.0), Color("1e2a32"))
	draw_line(Vector2(478.0, 82.0), Vector2(478.0, 217.0), Color("364b58"), 1.2)
	draw_rect(Rect2(476.0, 82.0, 8.0, 135.0), Color("293a45"), false, 0.8)
	
	# Droplet leak junction collar at x=370, y=82
	draw_rect(Rect2(366.0, 80.0, 8.0, 6.0), Color("2d404c"))
	draw_rect(Rect2(366.0, 80.0, 8.0, 6.0), COLOR_CYAN * 0.7, false, 0.8)


func _draw_catwalk_grating() -> void:
	# Steel open-mesh grating floor structure: y=280..320
	var catwalk_rect := Rect2(0.0, 280.0, 640.0, 40.0)
	draw_rect(catwalk_rect, Color("162026"))
	
	# Top walking surface grid bar
	draw_line(Vector2(0.0, 280.0), Vector2(640.0, 280.0), COLOR_INFRASTRUCTURE, 2.0)
	
	# Diamond / cross-hatch grating pattern
	for gx in range(0, 640, 8):
		draw_line(Vector2(float(gx), 280.0), Vector2(float(gx) + 6.0, 296.0), COLOR_CATWALK_GRID, 1.0)
		draw_line(Vector2(float(gx) + 6.0, 280.0), Vector2(float(gx), 296.0), COLOR_CATWALK_GRID, 1.0)
	
	# Catwalk structural longitudinal I-beam at y=296
	draw_rect(Rect2(0.0, 296.0, 640.0, 14.0), Color("202c34"))
	draw_line(Vector2(0.0, 296.0), Vector2(640.0, 296.0), Color("344855"), 1.5)
	draw_line(Vector2(0.0, 310.0), Vector2(640.0, 310.0), Color("12181d"), 1.5)
	
	# Truss support brackets under the catwalk down to pit
	for tx in range(30, 640, 90):
		draw_line(Vector2(float(tx), 310.0), Vector2(float(tx) - 15.0, 340.0), Color("273742"), 2.5)
		draw_line(Vector2(float(tx), 310.0), Vector2(float(tx) + 15.0, 340.0), Color("273742"), 2.5)
		draw_circle(Vector2(float(tx), 310.0), 2.5, COLOR_INFRASTRUCTURE * 0.8)
	
	# Catwalk safety kickplate toe board
	draw_rect(Rect2(0.0, 276.0, 640.0, 4.0), Color("2b3c46"))


func _draw_condensation_drips() -> void:
	# Animated falling condensation droplet from overhead pipe (x=370)
	if _drip_y < 302.0:
		draw_circle(Vector2(370.0, _drip_y), 1.5, COLOR_CYAN * 0.85)
		draw_line(Vector2(370.0, _drip_y - 2.5), Vector2(370.0, _drip_y), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.4), 1.0)


func _draw_steam_exhaust() -> void:
	if not is_pressure_released:
		return
	
	# Decompression steam plumes issuing from vent nozzle at x=488, y=214
	var vent_origin := Vector2(488.0, 214.0)
	var steam_pts: int = 6
	for s in range(steam_pts):
		var prog := fmod(_pulse_time * 2.5 + float(s) * 0.18, 1.0)
		var sp_x := vent_origin.x + prog * 35.0 + sin(prog * PI * 2.0) * 6.0
		var sp_y := vent_origin.y - prog * 45.0 - cos(prog * PI) * 4.0
		var radius := 3.0 + prog * 10.0
		var alpha := (1.0 - prog) * 0.35 * _pressure_vent_progress
		draw_circle(Vector2(sp_x, sp_y), radius, Color(0.75, 0.85, 0.88, alpha))


func _draw_dialogue_overlay() -> void:
	var line_data: Dictionary = dialogue_lines[dialogue_index]
	var speaker: String = line_data.get("speaker", "")
	var text: String = line_data.get("text", "")
	var is_witness: bool = line_data.get("is_witness", false)
	var is_lena: bool = line_data.get("is_lena", false)
	var is_stage_direction: bool = line_data.get("is_stage_direction", false)
	
	# Letterbox cinematic dialogue banner at bottom (y=292..354)
	var box_rect := Rect2(20.0, 292.0, 600.0, 62.0)
	draw_rect(box_rect, Color(0.08, 0.11, 0.13, 0.94))
	
	# Accent boundary line
	var border_color := COLOR_AMBER if is_lena else (COLOR_CYAN if is_witness else COLOR_INFRASTRUCTURE)
	draw_rect(box_rect, border_color * 0.85, false, 1.2)
	
	# Speaker header tab
	var speaker_rect := Rect2(30.0, 282.0, 190.0, 16.0)
	draw_rect(speaker_rect, Color(0.09, 0.13, 0.16, 0.98))
	draw_rect(speaker_rect, border_color, false, 1.0)
	
	# Header indicator dot
	draw_circle(Vector2(38.0, 290.0), 3.0, border_color)
	
	# Minimal line icon indicating speaker
	if is_lena:
		draw_circle(Vector2(48.0, 290.0), 2.2, COLOR_AMBER)
	elif is_witness:
		draw_line(Vector2(44.0, 290.0), Vector2(52.0, 290.0), COLOR_CYAN, 1.5)
	
	# Interaction advance prompt indicator in bottom right
	var pulse := sin(_pulse_time * 4.0) * 0.5 + 0.5
	var prompt_col := Color(border_color.r, border_color.g, border_color.b, 0.5 + pulse * 0.5)
	draw_line(Vector2(598.0, 342.0), Vector2(606.0, 342.0), prompt_col, 1.5)
	draw_line(Vector2(602.0, 338.0), Vector2(606.0, 342.0), prompt_col, 1.5)
	draw_line(Vector2(602.0, 346.0), Vector2(606.0, 342.0), prompt_col, 1.5)
