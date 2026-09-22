class_name Station30
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Główny węzeł rozdzielczy Sektora 4 zamyka magistralę zasilania archiwum trzech modeli rzeczywistości.
## PRZESZKODA — czego wymaga od Leny: Zakotwiczenia baterii przekaźników świadka w konfiguracji bazowej przed przejściem fali korekcyjnej.
## PRZESZKODA — koszt porażki: Przełączenie przekaźnika w stan alternatywny, zatarcie detalu świadectwa i konieczność ponownego podejścia.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("0a0f12")
const COLOR_PANEL_BASE := Color("141c22")
const COLOR_PANEL_CORE := Color("1e2830")
const COLOR_INFRASTRUCTURE := Color("3d5866")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.22)
const COLOR_BEIGE_ASH := Color("c8a370")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CYAN_TECH := Color("5da398")
const COLOR_CORRECTION := Color("c65d58")

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal board_inspected()
signal transformer_inspected()
signal breaker_thrown()
signal schematic_inspected()
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
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")
@onready var guidance_service: NarrativeGuidanceService = get_node_or_null("NarrativeGuidanceService")

var is_board_inspected: bool = false
var is_transformer_inspected: bool = false
var is_breaker_thrown: bool = false
var is_schematic_inspected: bool = false
var is_exit_unlocked: bool = false
var is_level_completed: bool = false

var witness_relay_correction_count: int = 0
var witness_relay_detail_faded: bool = false
var last_witness_relay_correction_target = AnchorableObject.RealityState.STATE_A

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _exit_open_progress: float = 0.0

var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Trzy modele. Żaden nie jest darmowy. Centralna tablica rozdzielcza Sektora 4 zamyka magistralę zasilania archiwum.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "JAKUB",
		"text": "To stąd UCP zasila siatkę konsensusu. Za tą bramą zaczyna się Magazyn Dowodów i rejestr jedenastu świadków.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Spójrz na wskaźniki obciążenia. Każdy świadek pobiera prąd proporcjonalnie do rozbieżności z oficjalną wersją.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Bo im więcej ludzi pamięta inaczej, tym więcej energii potrzeba, by utrzymać iluzję.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Na podświetlanym schemacie pulsują punkty węzłowe. Bateria transformatorów drży od przeciążenia.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Marta nadal świeci na schemacie. I Szymon. I ty.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Jeśli przestawimy ten trójfazowy bezpiecznik, zdejmiemy blokadę z całego węzła.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Potężna dźwignia bezpiecznika nożowego lśni w mroku. Stalowe styki czekają na ruch.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Przestaw go, Jakub. Zdejmijmy ten konsensus.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Zrobione. Obwody nadzoru zgasły. Droga do Aktu IV stoi otworem.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Rygiel magnetyczny ciężkiej bramy ekranowanej zwalnia z potężnym echem. Brama do Przestrzeni 31 zostaje otwarta.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	}
]


func _ready() -> void:
	if player:
		player.position = Vector2(50.0, 240.0)
	if camera:
		camera.position = Vector2(320.0, 180.0)
	if airlock_zone and not airlock_zone.body_entered.is_connected(_on_airlock_zone_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_zone_body_entered)
	_setup_props()
	_setup_guidance()
	station_entered.emit()


func _setup_props() -> void:
	if not props:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var pt := child as MemoryResonancePoint
			if not pt.resonance_triggered.is_connected(_on_prop_inspected):
				pt.resonance_triggered.connect(_on_prop_inspected.bind(pt))


func _setup_guidance() -> void:
	if not guidance_service:
		return
	var beat_start := GuidanceBeat.new()
	beat_start.beat_id = &"s30_three_models"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Trzy modele zasilania. Żaden nie jest darmowy."
	beat_start.text_en = "Three power models. None is free."
	guidance_service.register_beat(beat_start)


func _process(delta: float) -> void:
	_pulse_time += delta
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 2.0)
		queue_redraw()


func run_witness_relay_correction_pass() -> void:
	var relay := geometry.get_node_or_null("WitnessRelayBank") as AnchorableObject
	if relay:
		if relay.is_anchored:
			return
		relay.current_reality = AnchorableObject.RealityState.STATE_B
		last_witness_relay_correction_target = AnchorableObject.RealityState.STATE_B
		witness_relay_correction_count += 1
		witness_relay_detail_faded = true
		if player:
			player.global_position = Vector2(50.0, 240.0)
		var state := get_node_or_null("/root/GameStateManager")
		if state:
			state.record_decision(&"station_30_witness_relay_corrected", witness_relay_correction_count)


func _on_prop_inspected(id: String, prop_type: int, pt: MemoryResonancePoint = null) -> void:
	var prop_name: String = String(pt.name) if pt else id
	match prop_name:
		"MainDistributionBoard", "prop_main_distribution_board":
			inspect_board()
		"TransformerBank", "prop_transformer_bank":
			inspect_transformer()
		"SectionBreakerLever", "prop_section_breaker":
			throw_breaker()
		"GridSchematicDisplay", "prop_grid_schematic":
			inspect_schematic()
		"Station30Exit", "prop_station_30_exit":
			if is_exit_unlocked:
				_trigger_level_completion()
	clue_inspected.emit(id, prop_type)


func inspect_board() -> void:
	if is_board_inspected:
		return
	is_board_inspected = true
	var p := props.get_node_or_null("MainDistributionBoard") as MemoryResonancePoint
	if p:
		p.is_activated = true
	board_inspected.emit()
	_check_unlock()


func inspect_transformer() -> void:
	if is_transformer_inspected:
		return
	is_transformer_inspected = true
	var p := props.get_node_or_null("TransformerBank") as MemoryResonancePoint
	if p:
		p.is_activated = true
	transformer_inspected.emit()
	_check_unlock()


func throw_breaker() -> void:
	if is_breaker_thrown:
		return
	is_breaker_thrown = true
	var p := props.get_node_or_null("SectionBreakerLever") as MemoryResonancePoint
	if p:
		p.is_activated = true
	breaker_thrown.emit()
	start_dialogue()
	_check_unlock()


func inspect_schematic() -> void:
	if is_schematic_inspected:
		return
	is_schematic_inspected = true
	var p := props.get_node_or_null("GridSchematicDisplay") as MemoryResonancePoint
	if p:
		p.is_activated = true
	schematic_inspected.emit()
	_check_unlock()


func start_dialogue() -> void:
	if is_dialogue_completed or dialogue_active:
		return
	dialogue_active = true
	dialogue_index = 0
	dialogue_started.emit()
	_show_dialogue_line(0)


func advance_dialogue() -> int:
	if not dialogue_active:
		return -1
	dialogue_index += 1
	if dialogue_index < dialogue_lines.size():
		if dialogue_index == 2:
			inspect_board()
		elif dialogue_index == 4:
			inspect_transformer()
		elif dialogue_index == 6:
			inspect_schematic()
		elif dialogue_index == 8:
			throw_breaker()
		elif dialogue_index == 9:
			_unlock_exit()
		dialogue_advanced.emit(dialogue_index)
		_show_dialogue_line(dialogue_index)
		return dialogue_index
	else:
		dialogue_active = false
		is_dialogue_completed = true
		_unlock_exit()
		if dialogue_box and dialogue_box.has_method("hide_box"):
			dialogue_box.hide_box()
		var state := get_node_or_null("/root/GameStateManager")
		if state:
			state.record_decision(&"s30_three_models_resolved", true)
		dialogue_completed.emit()
		return -1


func _show_dialogue_line(idx: int) -> void:
	if idx < 0 or idx >= dialogue_lines.size():
		return
	var line: Dictionary = dialogue_lines[idx]
	if dialogue_box and dialogue_box.has_method("show_line"):
		dialogue_box.show_line(line.get("speaker", "JAKUB"), line.get("text", ""))


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	var p := props.get_node_or_null("Station30Exit") as MemoryResonancePoint
	if p:
		p.is_activated = true
	queue_redraw()


func _check_unlock() -> void:
	if is_board_inspected and is_transformer_inspected and is_breaker_thrown and is_schematic_inspected and not is_exit_unlocked:
		_unlock_exit()


func _on_airlock_zone_body_entered(body: Node2D) -> void:
	if body == player and is_exit_unlocked and not is_level_completed:
		_trigger_level_completion()


func _trigger_level_completion() -> void:
	is_level_completed = true
	level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	
	# Main panel base and transformer blocks
	draw_rect(Rect2(Vector2(60.0, 160.0), Vector2(160.0, 120.0)), COLOR_PANEL_BASE, true)
	draw_rect(Rect2(Vector2(80.0, 180.0), Vector2(120.0, 80.0)), COLOR_PANEL_CORE, true)
	draw_rect(Rect2(Vector2(240.0, 160.0), Vector2(240.0, 120.0)), COLOR_INFRASTRUCTURE, true)
	
	# Exit door frame
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
