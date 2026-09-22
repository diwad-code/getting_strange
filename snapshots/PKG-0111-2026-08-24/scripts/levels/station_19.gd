class_name Station19
extends Node2D

## Station 19 (Przestrzeń 19: Model bez oryginału / Sala Modeli) for Getting Strange Vertical Slice.
## Features the neutral, clinical Sala Modeli: szarobeżowy gips, cold white table, matte aluminum.
## Displays two equivalent scale models and wall blueprints of the Line 4 incident
## (Left: staircase leads to street / 140 people egress; Right: staircase ends on load-bearing wall / 17 witnesses).
## Neither is marked as false; reveals the absence of a confirmed first version.
## Features the eleven persons ledger and unlocks the transition door toward Space 20 (Sala Szymona).
## Implements D-07 ("Wierzbicka pokazuje schody" — 8 dialogue lines).
## Conforms to VISUAL_DESIGN.md (Sections 6.3, 7.1, 7.4), FULL_STORY.md (Scene 19), DIALOGUE_SCRIPT.md (D-07).

## PRZESZKODA — dlaczego to tu jest: stół modeli przechowuje dwie równoprawne
## wersje zdarzenia Linii 4, których rozmiar zmienia się przy uzgadnianiu urzędu.
## PRZESZKODA — czego wymaga od Leny: utrzymania jednego modelu przy sobie
## przed przejściem dalej albo świadomego oddania miejsca drugiej wersji.
## PRZESZKODA — koszt porażki: korekta odsyła Lenę do wejścia, a krawędź rejestru
## jedenastu osób traci ślad używania, ponieważ sala wybiera wygodniejszy układ.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("101a1c")
const COLOR_WALL_PLASTER := Color("25302b")
const COLOR_WALL_LIGHT := Color("2e3b35")
const COLOR_INFRASTRUCTURE := Color("a8b2ac")
const COLOR_DARK_STEEL := Color("24343a")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.18)
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal table_approached()
signal map_left_inspected()
signal map_right_inspected()
signal ledger_inspected()
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
@onready var line4_model_table: AnchorableObject = get_node_or_null("Geometry/Line4ModelTable") as AnchorableObject

var is_table_approached: bool = false
var is_map_left_inspected: bool = false
var is_map_right_inspected: bool = false
var is_ledger_inspected: bool = false
var is_exit_unlocked: bool = false
var is_level_completed: bool = false
var is_model_anchored: bool = false
var model_correction_count: int = 0
var model_detail_faded: bool = false
var last_model_correction_target: AnchorableObject.RealityState = AnchorableObject.RealityState.STATE_A

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _exit_open_progress: float = 0.0

var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "WIERZBICKA",
		"text": "Lewa klatka kończy się na ulicy. Prawa, według siedemnastu osób, na ścianie nośnej.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Która jest prawdziwa?",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Ta, po której za dwie minuty zejdzie sto czterdzieści osób.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "To nie odpowiedź.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "WIERZBICKA",
		"text": "To odpowiedzialność z terminem.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Nikt nie zginął. Proszę tego nie pomniejszać tylko dlatego, że chce pani mieć prostego przeciwnika.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "A kogo przesunęliście?",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Tego właśnie jeszcze nie wiemy.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	}
]


func _ready() -> void:
	_setup_station()
	_connect_signals()
	_setup_model_table()
	station_entered.emit()


func _process(delta: float) -> void:
	_pulse_time += delta
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 1.5)
	queue_redraw()


func _physics_process(_delta: float) -> void:
	if line4_model_table and player:
		line4_model_table.update_player_distance(player.global_position)


func _setup_model_table() -> void:
	if line4_model_table == null:
		return
	line4_model_table.anchor_state_changed.connect(_on_model_anchor_changed)
	line4_model_table.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"trigger_correction") and not event.is_echo():
		run_model_correction_pass()
		get_viewport().set_input_as_handled()
		return
	if not event.is_action_pressed(&"interact") or event.is_echo():
		return
	if dialogue_active:
		advance_dialogue()
		get_viewport().set_input_as_handled()
		return
	if is_dialogue_completed and line4_model_table and line4_model_table.is_player_in_range:
		line4_model_table.toggle_anchor()
		get_viewport().set_input_as_handled()


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
		MemoryResonancePoint.PropType.MODEL_DISPLAY_TABLE:
			is_table_approached = true
			table_approached.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.STAIRCASE_MAP_LEFT:
			is_map_left_inspected = true
			map_left_inspected.emit()
		MemoryResonancePoint.PropType.STAIRCASE_MAP_RIGHT:
			is_map_right_inspected = true
			map_right_inspected.emit()
		MemoryResonancePoint.PropType.ELEVEN_PERSONS_LEDGER:
			is_ledger_inspected = true
			ledger_inspected.emit()
		MemoryResonancePoint.PropType.MODEL_ROOM_EXIT:
			if not is_exit_unlocked and is_dialogue_completed:
				is_exit_unlocked = true
				exit_unlocked.emit()


func start_dialogue() -> void:
	dialogue_active = true
	dialogue_index = 0
	dialogue_started.emit()
	dialogue_advanced.emit(dialogue_index)
	queue_redraw()


func advance_dialogue() -> int:
	if not dialogue_active:
		if not is_dialogue_completed:
			start_dialogue()
			return dialogue_index
		return -1
	dialogue_index += 1
	if dialogue_index >= dialogue_lines.size():
		dialogue_active = false
		is_dialogue_completed = true
		is_exit_unlocked = true
		exit_unlocked.emit()
		dialogue_completed.emit()
		var exit_prop := props.get_node_or_null("ModelRoomExit") as MemoryResonancePoint
		if exit_prop:
			exit_prop.is_activated = true
		var table_prop := props.get_node_or_null("ModelDisplayTable") as MemoryResonancePoint
		if table_prop:
			table_prop.is_activated = true
		var left_map := props.get_node_or_null("StaircaseMapLeft") as MemoryResonancePoint
		if left_map:
			left_map.is_activated = true
		var right_map := props.get_node_or_null("StaircaseMapRight") as MemoryResonancePoint
		if right_map:
			right_map.is_activated = true
		var ledger_prop := props.get_node_or_null("ElevenPersonsLedger") as MemoryResonancePoint
		if ledger_prop:
			ledger_prop.is_activated = true
		queue_redraw()
		return -1
	dialogue_advanced.emit(dialogue_index)
	queue_redraw()
	return dialogue_index


func _on_model_anchor_changed(anchored: bool) -> void:
	is_model_anchored = anchored
	if anchored:
		var state := get_node_or_null("/root/GameStateManager")
		if state and state.has_method("record_decision"):
			state.record_decision(&"station_19_anchored_model_table", true)
	queue_redraw()


func run_model_correction_pass() -> void:
	if line4_model_table == null:
		return
	last_model_correction_target = (
		AnchorableObject.RealityState.STATE_B
		if line4_model_table.current_reality == AnchorableObject.RealityState.STATE_A
		else AnchorableObject.RealityState.STATE_A
	)
	line4_model_table.apply_reality_shift(last_model_correction_target, false)
	if not line4_model_table.is_anchored:
		_apply_model_correction()
	queue_redraw()


func _apply_model_correction() -> void:
	model_correction_count += 1
	model_detail_faded = true
	var state := get_node_or_null("/root/GameStateManager")
	if state and state.has_method("record_decision"):
		state.record_decision(&"station_19_model_table_corrected", model_correction_count)
	var ledger := props.get_node_or_null("ElevenPersonsLedger") as MemoryResonancePoint
	if ledger:
		ledger.prop_subtitle = "Lista osób nieobecnych — krawędź wyblakła"
	if line4_model_table:
		line4_model_table.set_anchored(false)
		line4_model_table.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)
	if player:
		player.reset_to(Vector2(50.0, 240.0))
	queue_redraw()


func _on_airlock_entered(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	_draw_state_layer()

	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_hud(dialogue_lines[dialogue_index])


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	if model_detail_faded:
		draw_line(Vector2(212.0, 226.0), Vector2(224.0, 226.0), VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.42), 2.0)
	if is_model_anchored:
		draw_line(Vector2(280.0, 210.0), Vector2(360.0, 210.0), VectorStageStyle.ANCHOR_CYAN, 1.0)
	if is_exit_unlocked:
		draw_line(Vector2(550.0, 270.0), Vector2(610.0, 270.0), VectorStageStyle.ANCHOR_CYAN, 2.0)


func _draw_dialogue_hud(line: Dictionary) -> void:
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_lena: bool = line.get("is_lena", false)
	var box_rect := Rect2(60.0, 286.0, LEVEL_WIDTH - 120.0, 48.0)
	draw_rect(box_rect, Color(0.06, 0.11, 0.09, 0.95))
	var border_color := VectorStageStyle.HUMAN_AMBER if is_lena else VectorStageStyle.ANCHOR_CYAN
	draw_rect(box_rect, border_color, false, 1.2)
	var font := ThemeDB.fallback_font
	if font:
		draw_string(font, Vector2(72.0, 300.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, border_color)
		draw_string(font, Vector2(72.0, 321.0), text, HORIZONTAL_ALIGNMENT_LEFT, 500, 10, Color("dcebe4"))


func _draw_legacy_environment() -> void:
	# Base room fill
	draw_rect(Rect2(Vector2.ZERO, VIEW_SIZE), COLOR_BACKGROUND)
	
	# Plaster wall upper section (y=40..160)
	draw_rect(Rect2(0.0, 40.0, LEVEL_WIDTH, 120.0), COLOR_WALL_PLASTER)
	
	# Plaster wall lower section (y=160..280)
	draw_rect(Rect2(0.0, 160.0, LEVEL_WIDTH, 120.0), COLOR_WALL_LIGHT)
	
	# Horizontal dado rail divider line
	draw_line(Vector2(0.0, 160.0), Vector2(LEVEL_WIDTH, 160.0), Color("3d5248", 0.65), 1.2)
	
	# Architecture grid lines (subtle institutional rhythm)
	for gx in range(0, int(LEVEL_WIDTH) + 1, 40):
		draw_line(Vector2(float(gx), 40.0), Vector2(float(gx), 280.0), Color("162420", 0.25), 0.7)
	for gy in range(40, 281, 20):
		draw_line(Vector2(0.0, float(gy)), Vector2(LEVEL_WIDTH, float(gy)), Color("162420", 0.25), 0.7)
	
	# Overhead lighting conduit & tube fixture
	draw_rect(Rect2(25.0, 36.0, LEVEL_WIDTH - 50.0, 5.0), Color("d2ded8"))
	draw_rect(Rect2(25.0, 36.0, LEVEL_WIDTH - 50.0, 5.0), COLOR_CYAN * 0.35, false, 0.8)
	
	# Floor base (y=280..360) in dark institutional terrazzo tile
	draw_rect(Rect2(0.0, 280.0, LEVEL_WIDTH, 80.0), Color("16201d"))
	draw_rect(Rect2(0.0, 276.0, LEVEL_WIDTH, 4.0), Color("0e1614"))
	for fx in range(20, int(LEVEL_WIDTH), 45):
		draw_circle(Vector2(float(fx), 298.0), 0.9, Color("2a3c34", 0.45))
		draw_circle(Vector2(float(fx + 22), 316.0), 0.7, Color("32463c", 0.35))
	
	# Architectural niches for the two schematic boards
	# Left niche (x=95..165, y=70..190)
	var left_niche := Rect2(95.0, 70.0, 70.0, 120.0)
	draw_rect(left_niche, Color("1c2824"))
	draw_rect(left_niche, Color("34483e", 0.6), false, 1.0)
	
	# Right niche (x=455..525, y=70..190)
	var right_niche := Rect2(455.0, 70.0, 70.0, 120.0)
	draw_rect(right_niche, Color("1c2824"))
	draw_rect(right_niche, Color("34483e", 0.6), false, 1.0)
	
	# Central display plinth (x=240..380, y=265..280)
	draw_rect(Rect2(240.0, 265.0, 140.0, 15.0), Color("22302a"))
	draw_rect(Rect2(240.0, 265.0, 140.0, 15.0), Color("40564c", 0.7), false, 1.0)
	draw_line(Vector2(245.0, 267.0), Vector2(375.0, 267.0), Color("c8d8d0", 0.4), 0.8)
	
	# Institutional header sign at top center: "SALA MODELI UCP"
	var sign_rect := Rect2(190.0, 50.0, 260.0, 18.0)
	draw_rect(sign_rect, Color("182420"))
	draw_rect(sign_rect, COLOR_INFRASTRUCTURE * 0.65, false, 1.0)
	draw_line(Vector2(200.0, 59.0), Vector2(440.0, 59.0), Color("dce6e0"), 1.2)
	draw_line(Vector2(200.0, 62.5), Vector2(350.0, 62.5), COLOR_CYAN * 0.75, 0.8)
	
	# Vertical architectural pillars
	draw_rect(Rect2(175.0, 40.0, 10.0, 240.0), Color("18231f"))
	draw_rect(Rect2(175.0, 40.0, 10.0, 240.0), COLOR_INFRASTRUCTURE * 0.45, false, 0.8)
	draw_rect(Rect2(445.0, 40.0, 10.0, 240.0), Color("18231f"))
	draw_rect(Rect2(445.0, 40.0, 10.0, 240.0), COLOR_INFRASTRUCTURE * 0.45, false, 0.8)
	
	# Ambient model table cone light (cold white + subtle cyan/amber balance)
	var amb := sin(_pulse_time * 1.5) * 0.03 + 0.12
	draw_circle(Vector2(310.0, 230.0), 65.0, Color(0.85, 0.94, 0.90, amb))
	
	# Exit threshold indicator when unlocked
	if is_exit_unlocked:
		var pulse := sin(_pulse_time * 3.5) * 0.5 + 0.5
		var exit_indicator := Rect2(550.0, 274.0, 70.0, 4.0)
		draw_rect(exit_indicator, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.5 + pulse * 0.5))
	
	# Dialogue overlay banner
	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		var line_data: Dictionary = dialogue_lines[dialogue_index]
		var is_lena: bool = line_data.get("is_lena", false)
		var banner_rect := Rect2(60.0, 286.0, LEVEL_WIDTH - 120.0, 48.0)
		draw_rect(banner_rect, Color(0.06, 0.11, 0.09, 0.95))
		var border_color := COLOR_AMBER if is_lena else COLOR_CYAN
		draw_rect(banner_rect, border_color * 0.85, false, 1.2)
		draw_rect(Rect2(72.0, 292.0, 140.0, 12.0), Color("0e1812"))
		draw_rect(Rect2(72.0, 292.0, 140.0, 12.0), border_color * 0.5, false, 0.8)
		draw_line(Vector2(76.0, 298.0), Vector2(206.0, 298.0), border_color, 1.0)
		draw_line(Vector2(76.0, 312.0), Vector2(550.0, 312.0), Color("d8deda"), 1.2)
		draw_line(Vector2(76.0, 322.0), Vector2(460.0, 322.0), Color("98a49e"), 1.0)
