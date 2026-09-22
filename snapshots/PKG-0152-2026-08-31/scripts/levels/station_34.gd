class_name Station34
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Główna maszynownia Podstruktury zarządza poborem mocy i stabilizacją korytarza transportowego dla par pasażerów.
## PRZESZKODA — czego wymaga od Leny: Zbadania rdzenia reaktora, pulpitu alokacji mocy, wskaźnika przeciążenia termicznego, sondy diagnostycznej i odblokowania rejestru par UCP.
## PRZESZKODA — koszt porażki: Próba przejścia bez zbadania alokacji mocy i odblokowania rejestru par blokuje grodzie izolacyjne korytarza.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_ENTRY := &"p7.archive_countermodel.trace"
const FACT_REACTOR := &"p7.pair_cost_and_echo.reactor_core_inspected"
const FACT_DESK := &"p7.pair_cost_and_echo.allocation_desk_inspected"
const FACT_THERMAL := &"p7.pair_cost_and_echo.thermal_overload_inspected"
const FACT_PROBE := &"p7.pair_cost_and_echo.diagnostic_probe_inspected"
const FACT_REGISTRY := &"p7.pair_cost_and_echo.pair_registry_inspected"
const FACT_FEEDBACK := &"p7.pair_cost_and_echo.safe_trial_feedback"

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0
const CHECKPOINT_POSITION := Vector2(65.0, 248.0)

const COLOR_BACKGROUND := Color("090c10")
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
signal reactor_core_inspected
signal allocation_desk_inspected
signal thermal_overload_inspected
signal diagnostic_probe_inspected
signal pair_registry_unlocked
signal exit_unlocked

const LEVEL_ID := "station_34"
const LEVEL_NAME := "Przestrzeń 34: Maszynownia Główna"
const SCENE_SUBTITLE := "Alokacja mocy / Rejestr par pasażerskich"

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = false
@export var dialogue_index: int = 0

var is_reactor_core_inspected: bool = false
var is_allocation_desk_inspected: bool = false
var is_thermal_overload_inspected: bool = false
var is_diagnostic_probe_inspected: bool = false
var is_pair_registry_unlocked: bool = false

var is_reactor_inspected: bool:
	get: return is_reactor_core_inspected
var is_desk_inspected: bool:
	get: return is_allocation_desk_inspected
var is_thermal_inspected: bool:
	get: return is_thermal_overload_inspected
var is_probe_inspected: bool:
	get: return is_diagnostic_probe_inspected

func inspect_reactor() -> bool:
	return inspect_correlation_reactor()

func inspect_desk() -> bool:
	return inspect_allocation_desk()

func inspect_thermal() -> bool:
	return inspect_thermal_indicators()

func inspect_probe() -> bool:
	return inspect_diagnostic_probe()

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
	_register_beat(&"s34_reactor_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s34_reactor_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Maszynownia główna. Rdzeń korelacyjny i rejestr par.", "Main engine room. Correlation core and pair registry.", &"", "")
	_register_beat(&"s34_pair_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Pary nie były błędem aparatury — były z góry założoną architekturą UCP.", "Pairs were not an equipment glitch — they were UCP's deliberate architecture.", &"single_body_swap", "unlock_pair_registry")
	_register_beat(&"s34_unlock_registry", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zbadam rdzeń reaktora, pulpit alokacji, wskaźnik przeciążenia, sondę i odblokuję rejestr par.", "Inspect reactor core, allocation desk, overload gauge, probe, and unlock pair registry.", &"", "unlock_pair_registry")
	_register_beat(&"s34_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Rdzeń reaktora, pulpit alokacji, przeciążenie termiczne, sonda diagnostyczna, rejestr par.", "HINT: Reactor core, allocation desk, thermal overload, diagnostic probe, pair registry.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_34"
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


func inspect_reactor_core() -> bool:
	if is_reactor_core_inspected:
		return false
	if not _has(FACT_ENTRY):
		_record_feedback(&"entry_trace_required")
		return false
	is_reactor_core_inspected = true
	_record(FACT_REACTOR, true)
	reactor_core_inspected.emit()
	interaction_triggered.emit("prop_reactor_core")
	_activate_prop_by_id("prop_reactor_core")
	_activate_prop_by_id("ReactorCoreColumn")
	if guidance_service:
		guidance_service.trigger_beat(&"s34_reactor_contact")
	_report_progress(&"s34_reactor_inspected")
	queue_redraw()
	return true


func inspect_correlation_reactor() -> bool:
	return inspect_reactor_core()


func inspect_allocation_desk() -> bool:
	if is_allocation_desk_inspected:
		return false
	if not is_reactor_core_inspected:
		_record_feedback(&"reactor_core_required")
		return false
	is_allocation_desk_inspected = true
	_record(FACT_DESK, true)
	allocation_desk_inspected.emit()
	interaction_triggered.emit("prop_allocation_desk")
	_activate_prop_by_id("prop_allocation_desk")
	_activate_prop_by_id("AllocationDeskTerminal")
	if guidance_service:
		guidance_service.trigger_beat(&"s34_pair_hypothesis")
	_report_progress(&"s34_desk_inspected")
	queue_redraw()
	return true


func inspect_thermal_overload() -> bool:
	if is_thermal_overload_inspected:
		return false
	if not is_allocation_desk_inspected:
		_record_feedback(&"allocation_desk_required")
		return false
	is_thermal_overload_inspected = true
	_record(FACT_THERMAL, true)
	thermal_overload_inspected.emit()
	interaction_triggered.emit("prop_thermal_overload")
	_activate_prop_by_id("prop_thermal_overload")
	_activate_prop_by_id("ThermalOverloadRelay")
	_report_progress(&"s34_thermal_inspected")
	queue_redraw()
	return true


func inspect_thermal_indicators() -> bool:
	return inspect_thermal_overload()


func inspect_diagnostic_probe() -> bool:
	if is_diagnostic_probe_inspected:
		return false
	if not is_thermal_overload_inspected:
		_record_feedback(&"thermal_overload_required")
		return false
	is_diagnostic_probe_inspected = true
	_record(FACT_PROBE, true)
	diagnostic_probe_inspected.emit()
	interaction_triggered.emit("prop_diagnostic_probe")
	_activate_prop_by_id("prop_diagnostic_probe")
	_activate_prop_by_id("DiagnosticProbeRack")
	_report_progress(&"s34_probe_inspected")
	queue_redraw()
	return true


func unlock_pair_registry() -> bool:
	if is_pair_registry_unlocked:
		return false
	if not is_diagnostic_probe_inspected:
		_record_feedback(&"diagnostic_probe_required")
		return false
	is_pair_registry_unlocked = true
	_record(FACT_REGISTRY, true)
	pair_registry_unlocked.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"single_body_swap")
	_report_progress(&"s34_registry_unlocked")
	_unlock_exit()
	queue_redraw()
	return true


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_activate_prop_by_id("prop_station_34_exit")
	_activate_prop_by_id("Station34Exit")
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
		"prop_reactor_core", "ReactorCoreColumn":
			inspect_reactor_core()
		"prop_allocation_desk", "AllocationDeskTerminal":
			inspect_allocation_desk()
		"prop_thermal_overload", "ThermalOverloadRelay":
			inspect_thermal_overload()
		"prop_diagnostic_probe", "DiagnosticProbeRack":
			inspect_diagnostic_probe()
		"prop_station_34_exit", "Station34Exit":
			if is_exit_unlocked:
				_trigger_level_completion()
			else:
				_record_feedback(&"pair_registry_unlock_required")
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

	# Reactor Core Column
	var core_col := COLOR_CYAN if is_reactor_core_inspected else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(110.0, 140.0), Vector2(40.0, 120.0)), COLOR_PANEL_CORE, true)
	draw_line(Vector2(130.0, 140.0), Vector2(130.0, 260.0), core_col, 3.0)

	# Allocation Desk Terminal
	var desk_col := COLOR_AMBER if is_allocation_desk_inspected else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(220.0, 210.0), Vector2(35.0, 50.0)), COLOR_PANEL_BASE, true)
	draw_line(Vector2(225.0, 220.0), Vector2(250.0, 220.0), desk_col, 1.5)

	# Thermal Overload Relay
	var relay_col := COLOR_CORRECTION if is_thermal_overload_inspected else COLOR_INFRASTRUCTURE
	draw_circle(Vector2(345.0, 235.0), 12.0, COLOR_PANEL_BASE)
	draw_circle(Vector2(345.0, 235.0), 12.0, relay_col)

	# Diagnostic Probe Rack
	var probe_col := COLOR_AMBER_WARM if is_diagnostic_probe_inspected else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(440.0, 200.0), Vector2(30.0, 60.0)), COLOR_PANEL_CORE, true)
	draw_line(Vector2(445.0, 210.0), Vector2(465.0, 210.0), probe_col, 2.0)

	# Exit hatch frame
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
