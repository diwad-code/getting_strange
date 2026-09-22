class_name Station36
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Kanał drenażu trakcyjnego odprowadza skażenie dielektryczne z magistrali zasilającej i łączy węzły katastrof Linii 4.
## PRZESZKODA — czego wymaga od Leny: Zbadania przelewu drenażowego, prądu błądzącego, drabiny rewizyjnej, kurka skażenia i ujawnienia rejestru kosztu UCP.
## PRZESZKODA — koszt porażki: Próba przejścia bez zbadania skażenia i ujawnienia rejestru kosztu transferu blokuje zaporę spiętrzającą.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_ENTRY := &"p7.pair_cost_and_echo.home_echo_verified"
const FACT_WEIR := &"p7.pair_cost_and_echo.drain_weir_inspected"
const FACT_CURRENT := &"p7.pair_cost_and_echo.drain_current_measured"
const FACT_LADDER := &"p7.pair_cost_and_echo.service_ladder_inspected"
const FACT_TAP := &"p7.pair_cost_and_echo.contamination_tap_sampled"
const FACT_LINE4 := &"p7.pair_cost_and_echo.line4_pair_disaster_ledger_revealed"
const FACT_COST_LEDGER := &"p7.pair_cost_and_echo.ucp_cost_ledger_found"
const FACT_COMMITMENT := &"p7.pair_cost_and_echo.commitment"
const FACT_TRACE := &"p7.pair_cost_and_echo.trace"
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
signal drain_weir_inspected
signal drain_current_measured
signal service_ladder_inspected
signal contamination_tap_sampled
signal ucp_cost_ledger_found
signal line4_ledger_revealed
signal exit_unlocked

const LEVEL_ID := "station_36"
const LEVEL_NAME := "Przestrzeń 36: Drenaż trakcyjny"
const SCENE_SUBTITLE := "Para katastrof / Rejestr kosztu i skażenia UCP"

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = false
@export var dialogue_index: int = 0

var is_drain_weir_inspected: bool = false
var is_drain_current_measured: bool = false
var is_service_ladder_inspected: bool = false
var is_contamination_tap_sampled: bool = false
var is_tap_inspected: bool = false
var is_line4_ledger_revealed: bool = false
var is_ucp_cost_ledger_found: bool = false

var is_weir_inspected: bool:
	get: return is_drain_weir_inspected
var is_current_inspected: bool:
	get: return is_drain_current_measured
var is_ladder_inspected: bool:
	get: return is_service_ladder_inspected

func inspect_weir() -> bool:
	return inspect_drain_weir()

func inspect_current() -> bool:
	return measure_drain_current()

func inspect_ladder() -> bool:
	return inspect_service_ladder()

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
	_register_beat(&"s36_drain_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s36_drain_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Drenaż trakcyjny. Para katastrof i rejestr kosztu.", "Traction drainage. Pair disaster and cost ledger.", &"", "")
	_register_beat(&"s36_cost_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Koszt przejścia nie rozkładał się symetrycznie — zawsze jedna strona ponosiła ubytek.", "Transfer cost was not symmetrical — one side always bore the deficit.", &"conscious_cost_export", "reveal_ucp_cost_ledger")
	_register_beat(&"s36_reveal_ledger", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zbadam przelew drenażowy, prąd błądzący, drabinę, kurek skażenia i ujawnię rejestr kosztu UCP.", "Inspect drain weir, leakage current, ladder, contamination tap, and reveal UCP cost ledger.", &"", "reveal_ucp_cost_ledger")
	_register_beat(&"s36_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Przelew drenażowy, prąd błądzący, drabina rewizyjna, kurek skażenia, rejestr kosztu.", "HINT: Drain weir, stray current, service ladder, contamination tap, cost ledger.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_36"
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


func inspect_drain_weir() -> bool:
	if is_drain_weir_inspected:
		return false
	if not _has(FACT_ENTRY):
		_record_feedback(&"entry_trace_required")
		return false
	is_drain_weir_inspected = true
	_record(FACT_WEIR, true)
	drain_weir_inspected.emit()
	interaction_triggered.emit("prop_drain_weir")
	_activate_prop_by_id("prop_drain_weir")
	_activate_prop_by_id("TractionDrainWeir")
	if guidance_service:
		guidance_service.trigger_beat(&"s36_drain_contact")
	_report_progress(&"s36_weir_inspected")
	queue_redraw()
	return true


func measure_drain_current() -> bool:
	if is_drain_current_measured:
		return false
	if not is_drain_weir_inspected:
		_record_feedback(&"drain_weir_required")
		return false
	is_drain_current_measured = true
	_record(FACT_CURRENT, true)
	drain_current_measured.emit()
	interaction_triggered.emit("prop_drain_current")
	_activate_prop_by_id("prop_drain_current")
	_activate_prop_by_id("StrayCurrentElectrode")
	if guidance_service:
		guidance_service.trigger_beat(&"s36_cost_hypothesis")
	_report_progress(&"s36_current_measured")
	queue_redraw()
	return true


func inspect_service_ladder() -> bool:
	if is_service_ladder_inspected:
		return false
	if not is_drain_current_measured:
		_record_feedback(&"drain_current_required")
		return false
	is_service_ladder_inspected = true
	_record(FACT_LADDER, true)
	service_ladder_inspected.emit()
	interaction_triggered.emit("prop_service_ladder")
	_activate_prop_by_id("prop_service_ladder")
	_activate_prop_by_id("TractionServiceLadder")
	_report_progress(&"s36_ladder_inspected")
	queue_redraw()
	return true


func sample_contamination_tap() -> bool:
	if is_contamination_tap_sampled:
		return false
	if not is_service_ladder_inspected:
		_record_feedback(&"service_ladder_required")
		return false
	is_contamination_tap_sampled = true
	is_tap_inspected = true
	_record(FACT_TAP, true)
	contamination_tap_sampled.emit()
	interaction_triggered.emit("prop_contamination_tap")
	_activate_prop_by_id("prop_contamination_tap")
	_activate_prop_by_id("ContaminationSampleTap")
	_report_progress(&"s36_tap_sampled")
	queue_redraw()
	return true


func inspect_tap() -> bool:
	return sample_contamination_tap()


func reveal_ucp_cost_ledger() -> bool:
	if is_ucp_cost_ledger_found:
		return false
	if not is_contamination_tap_sampled:
		_record_feedback(&"contamination_sample_required")
		return false
	is_ucp_cost_ledger_found = true
	is_line4_ledger_revealed = true
	_record(FACT_LINE4, true)
	_record(FACT_COST_LEDGER, true)
	_record(&"ucp_cost_ledger_found", true)
	_record(FACT_COMMITMENT, &"disclose_pair_cost_to_persons")
	_record(FACT_TRACE, "ucp_cost_ledger_found")
	ucp_cost_ledger_found.emit()
	line4_ledger_revealed.emit()
	interaction_triggered.emit("prop_line4_ledger")
	_activate_prop_by_id("prop_line4_ledger")
	_activate_prop_by_id("Line4DisasterLedger")
	if guidance_service:
		guidance_service.close_hypothesis(&"conscious_cost_export")
	_report_progress(&"s36_cost_ledger_found")
	_unlock_exit()
	queue_redraw()
	return true


func inspect_line4_ledger() -> bool:
	return reveal_ucp_cost_ledger()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_activate_prop_by_id("prop_station_36_exit")
	_activate_prop_by_id("Station36Exit")
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
		"prop_drain_weir", "TractionDrainWeir":
			inspect_drain_weir()
		"prop_drain_current", "StrayCurrentElectrode":
			measure_drain_current()
		"prop_service_ladder", "TractionServiceLadder":
			inspect_service_ladder()
		"prop_contamination_tap", "ContaminationSampleTap":
			sample_contamination_tap()
		"prop_line4_ledger", "Line4DisasterLedger":
			reveal_ucp_cost_ledger()
		"prop_station_36_exit", "Station36Exit":
			if is_exit_unlocked:
				_trigger_level_completion()
			else:
				_record_feedback(&"cost_ledger_revelation_required")
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

	# Traction Drain Weir
	var weir_col := COLOR_CYAN if is_drain_weir_inspected else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(90.0, 210.0), Vector2(40.0, 50.0)), COLOR_PANEL_BASE, true)
	draw_line(Vector2(95.0, 220.0), Vector2(125.0, 220.0), weir_col, 2.0)

	# Stray Current Electrode
	var elec_col := COLOR_AMBER if is_drain_current_measured else COLOR_INFRASTRUCTURE
	draw_circle(Vector2(215.0, 235.0), 10.0, COLOR_PANEL_CORE)
	draw_circle(Vector2(215.0, 235.0), 10.0, elec_col)

	# Traction Service Ladder
	draw_line(Vector2(320.0, 80.0), Vector2(320.0, 260.0), COLOR_INFRASTRUCTURE, 2.0)
	draw_line(Vector2(340.0, 80.0), Vector2(340.0, 260.0), COLOR_INFRASTRUCTURE, 2.0)

	# Contamination Sample Tap
	var tap_col := COLOR_AMBER_WARM if is_contamination_tap_sampled else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(430.0, 210.0), Vector2(20.0, 40.0)), COLOR_PANEL_BASE, true)
	draw_line(Vector2(435.0, 225.0), Vector2(445.0, 225.0), tap_col, 2.0)

	# Line 4 Disaster Ledger
	var led_col := COLOR_CYAN if is_ucp_cost_ledger_found else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(490.0, 200.0), Vector2(30.0, 50.0)), COLOR_PANEL_CORE, true)
	draw_line(Vector2(495.0, 210.0), Vector2(515.0, 210.0), led_col, 1.5)

	# Exit hatch frame
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
