class_name Station35
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Sektor filtracji chłodzi podzespoły wymiany sygnałowej i gromadzi osad sedacyjny z procedur przejścia par.
## PRZESZKODA — czego wymaga od Leny: Zbadania basenu chłodzącego, zaworu spustowego, próbnika chemicznego i przetworzenia echa powrotnego z korytarza.
## PRZESZKODA — koszt porażki: Próba przejścia bez zbadania składu chemicznego i weryfikacji echa powrotnego blokuje pompę odwadniającą śluzy.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_ENTRY := &"p7.pair_cost_and_echo.pair_registry_inspected"
const FACT_POOL := &"p7.pair_cost_and_echo.cooling_pool_inspected"
const FACT_VALVE := &"p7.pair_cost_and_echo.drain_valve_inspected"
const FACT_CHEMICAL := &"p7.pair_cost_and_echo.chemical_sampler_inspected"
const FACT_ECHO := &"p7.pair_cost_and_echo.home_echo_verified"
const FACT_FEEDBACK := &"p7.pair_cost_and_echo.safe_trial_feedback"

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0
const CHECKPOINT_POSITION := Vector2(65.0, 248.0)

const COLOR_BACKGROUND := Color("070a0e")
const COLOR_PANEL_BASE := Color("141c22")
const COLOR_PANEL_CORE := Color("1c2630")
const COLOR_INFRASTRUCTURE := Color("3d5866")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")

signal level_completed
signal previous_level_requested
signal interaction_triggered(id: String)
signal clue_inspected(id: String, prop_type: int)
signal station_entered
signal cooling_pool_inspected
signal drain_valve_inspected
signal chemical_sampler_inspected
signal monitor_inspected
signal home_echo_verified
signal exit_unlocked

const LEVEL_ID := "station_35"
const LEVEL_NAME := "Przestrzeń 35: Sektor Filtracji"
const SCENE_SUBTITLE := "Baseny sedacyjne / Weryfikacja echa powrotnego"

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = false
@export var dialogue_index: int = 0

var is_cooling_pool_inspected: bool = false
var is_drain_valve_inspected: bool = false
var is_chemical_sampler_inspected: bool = false
var is_chemical_inspected: bool = false
var is_monitor_inspected: bool = false
var is_home_echo_verified: bool = false

var is_pool_inspected: bool:
	get: return is_cooling_pool_inspected
var is_valve_inspected: bool:
	get: return is_drain_valve_inspected

func inspect_pool() -> bool:
	return inspect_cooling_pool()

func inspect_valve() -> bool:
	return inspect_drain_valve()

var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

var dialogue_lines: Array[Dictionary] = []

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = get_node_or_null("Geometry")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")
@onready var guidance_service: NarrativeGuidanceService = get_node_or_null("NarrativeGuidanceService")


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_setup_props()
	if airlock_zone and not airlock_zone.body_entered.is_connected(_on_airlock_zone_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_zone_body_entered)
	station_entered.emit()
	queue_redraw()


func _setup_props() -> void:
	if not props:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var pt := child as MemoryResonancePoint
			if not pt.resonance_triggered.is_connected(_on_resonance_triggered):
				pt.resonance_triggered.connect(_on_resonance_triggered)


func _setup_guidance() -> void:
	if not guidance_service:
		return
	_register_beat(&"s35_pool_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s35_pool_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Sektor filtracji. Baseny sedacyjne i echo powrotne.", "Filtration sector. Sedation pools and return echo.", &"", "")
	_register_beat(&"s35_echo_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Echo powrotne Jakuba nie jest artefaktem aparatury — jest śladem rzeczywistej obecności w sieci.", "Jakub's return echo is not equipment artifact — it proves actual presence in network.", &"single_body_swap", "process_home_echo")
	_register_beat(&"s35_process_echo", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zbadam basen chłodzący, zawór spustowy, próbnik chemiczny i zweryfikuję echo powrotne.", "Inspect cooling pool, drain valve, chemical sampler, and verify return echo.", &"", "process_home_echo")
	_register_beat(&"s35_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Basen chłodzący, zawór spustowy, próbnik chemiczny, monitor sedacji, weryfikacja echa.", "HINT: Cooling pool, drain valve, chemical sampler, sedation monitor, verify echo.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_35"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	beat.predicted_check = predicted_check
	guidance_service.register_beat(beat)


func _process(delta: float) -> void:
	_pulse_phase += delta
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 2.0)
		queue_redraw()


func inspect_cooling_pool() -> bool:
	if is_cooling_pool_inspected:
		return false
	if not _has(FACT_ENTRY):
		_record_feedback(&"entry_trace_required")
		return false
	is_cooling_pool_inspected = true
	_record(FACT_POOL, true)
	cooling_pool_inspected.emit()
	interaction_triggered.emit("prop_cooling_pool")
	_activate_prop_by_id("prop_cooling_pool")
	_activate_prop_by_id("SedationCoolingPool")
	if guidance_service:
		guidance_service.trigger_beat(&"s35_pool_contact")
	_report_progress(&"s35_pool_inspected")
	queue_redraw()
	return true


func inspect_drain_valve() -> bool:
	if is_drain_valve_inspected:
		return false
	if not is_cooling_pool_inspected:
		_record_feedback(&"cooling_pool_required")
		return false
	is_drain_valve_inspected = true
	_record(FACT_VALVE, true)
	drain_valve_inspected.emit()
	interaction_triggered.emit("prop_drain_valve")
	_activate_prop_by_id("prop_drain_valve")
	_activate_prop_by_id("ResidueDrainValve")
	if guidance_service:
		guidance_service.trigger_beat(&"s35_echo_hypothesis")
	_report_progress(&"s35_valve_inspected")
	queue_redraw()
	return true


func inspect_chemical_sampler() -> bool:
	if is_chemical_sampler_inspected:
		return false
	if not is_drain_valve_inspected:
		_record_feedback(&"drain_valve_required")
		return false
	is_chemical_sampler_inspected = true
	is_chemical_inspected = true
	_record(FACT_CHEMICAL, true)
	chemical_sampler_inspected.emit()
	interaction_triggered.emit("prop_chemical_sampler")
	_activate_prop_by_id("prop_chemical_sampler")
	_activate_prop_by_id("ChemicalSedimentSampler")
	_report_progress(&"s35_chemical_inspected")
	queue_redraw()
	return true


func inspect_chemical() -> bool:
	return inspect_chemical_sampler()


func process_home_echo() -> bool:
	if is_home_echo_verified:
		return false
	if not is_chemical_sampler_inspected:
		_record_feedback(&"chemical_sampler_required")
		return false
	is_home_echo_verified = true
	is_monitor_inspected = true
	_record(FACT_ECHO, true)
	_record(&"home_echo_verified", true)
	monitor_inspected.emit()
	home_echo_verified.emit()
	interaction_triggered.emit("prop_monitor")
	_activate_prop_by_id("prop_monitor")
	_activate_prop_by_id("JakubSedationMonitor")
	if guidance_service:
		guidance_service.close_hypothesis(&"single_body_swap")
	_report_progress(&"s35_home_echo_verified")
	_unlock_exit()
	queue_redraw()
	return true


func inspect_monitor() -> bool:
	return process_home_echo()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_activate_prop_by_id("prop_station_35_exit")
	_activate_prop_by_id("Station35Exit")
	call_deferred(&"_complete_if_player_already_in_airlock")
	queue_redraw()


func _complete_if_player_already_in_airlock() -> void:
	if not is_exit_unlocked or is_level_completed or airlock_zone == null or player == null:
		return
	for body in airlock_zone.get_overlapping_bodies():
		if body == player or (body != null and body.name == "Player"):
			_trigger_level_completion()
			return


func _activate_prop_by_id(id: String) -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint and (child.resonance_id == id or child.name == id):
				child.is_activated = true
				child.queue_redraw()


func _on_resonance_triggered(id: String, prop_type: int) -> void:
	match id:
		"prop_cooling_pool", "SedationCoolingPool":
			inspect_cooling_pool()
		"prop_drain_valve", "ResidueDrainValve":
			inspect_drain_valve()
		"prop_chemical_sampler", "ChemicalSedimentSampler":
			inspect_chemical_sampler()
		"prop_monitor", "JakubSedationMonitor":
			process_home_echo()
		"prop_station_35_exit", "Station35Exit":
			if is_exit_unlocked:
				_trigger_level_completion()
			else:
				_record_feedback(&"home_echo_verification_required")
	clue_inspected.emit(id, prop_type)


func _on_airlock_zone_body_entered(body: Node2D) -> void:
	if is_level_completed:
		return
	if body == player or (body and body.name == "Player"):
		_trigger_level_completion()


func _trigger_level_completion() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _has(fact_key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	if state == null:
		return true
	if state.decisions.has(fact_key):
		return true
	return state.decisions.has(String(fact_key))


func _record(fact_key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null and state.has_method("record_decision"):
		state.record_decision(fact_key, value)


func _record_feedback(feedback_id: StringName) -> void:
	_record(FACT_FEEDBACK, String(feedback_id))


func _report_progress(action_id: StringName) -> void:
	if guidance_service != null and guidance_service.has_method("report_progress"):
		guidance_service.report_progress(action_id)


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	# Sedation Cooling Pool
	var pool_col := COLOR_CYAN if is_cooling_pool_inspected else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(100.0, 220.0), Vector2(60.0, 40.0)), COLOR_PANEL_BASE, true)
	draw_line(Vector2(105.0, 230.0), Vector2(155.0, 230.0), pool_col, 2.0)

	# Residue Drain Valve
	var valve_col := COLOR_AMBER if is_drain_valve_inspected else COLOR_INFRASTRUCTURE
	draw_circle(Vector2(235.0, 240.0), 12.0, COLOR_PANEL_CORE)
	draw_circle(Vector2(235.0, 240.0), 12.0, valve_col)

	# Chemical Sediment Sampler
	var chem_col := COLOR_AMBER_WARM if is_chemical_sampler_inspected else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(335.0, 200.0), Vector2(25.0, 60.0)), COLOR_PANEL_BASE, true)
	draw_line(Vector2(347.0, 210.0), Vector2(347.0, 250.0), chem_col, 2.0)

	# Jakub Sedation Monitor
	var mon_col := COLOR_CYAN if is_home_echo_verified else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(440.0, 190.0), Vector2(35.0, 50.0)), COLOR_PANEL_CORE, true)
	draw_rect(Rect2(Vector2(445.0, 195.0), Vector2(25.0, 30.0)), mon_col.lerp(COLOR_BACKGROUND, 0.4), true)

	# Exit hatch frame
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
