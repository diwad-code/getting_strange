class_name Station28
extends Node2D
## PRZESZKODA — dlaczego to tu jest: Przekaźnik transferowy nie może zachować pełnej ostrości śladu domu i sygnału miejscowej Leny jednocześnie.
## PRZESZKODA — czego wymaga od Leny: Odczytania obu śladów, ujawnienia ceny i wykonania jednego jawnego Anchor albo Yield.
## PRZESZKODA — koszt porażki: Brak wymaganego źródła daje informacyjny feedback; wykonany wybór zapisuje konkretną stratę pamięci albo czasu.

## Station 28 — commitment after the discriminating trial.
## Both evidence traces and the transfer price must be visible before Lena can
## Anchor the home trace or Yield to shared drift. The local reality-shift relay
## makes the commitment observable and enforces a single active anchor.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_RECONSTRUCTED := &"p7.interrupted_trial_and_small_cost.ucp_intervention_reconstructed"
const FACT_LOCAL_SIGNAL := &"p7.interrupted_trial_and_small_cost.local_lena_signal_confirmed"
const FACT_COMMITMENT := &"p7.interrupted_trial_and_small_cost.commitment"
const FACT_SMALL_COST := &"p7.interrupted_trial_and_small_cost.small_cost_manifested"
const FACT_TRACE := &"p7.interrupted_trial_and_small_cost.trace"
const FACT_SAFE_FEEDBACK := &"p7.interrupted_trial_and_small_cost.safe_trial_feedback"
const FACT_MECHANIC_COST := &"mechanic_cost_observed"

const COMMITMENT_HOME_ANCHOR := &"home_trace_anchor"
const COMMITMENT_SHARED_DRIFT := &"shared_drift_yield"
const COST_HOME_ANCHOR := &"marta_first_meeting_detail_blurred"
const COST_SHARED_DRIFT := &"sample_exact_second_lost"

const COLOR_BACKGROUND := Color("0d1215")
const COLOR_CARRIAGE_BODY := Color("1e2a31")
const COLOR_CARRIAGE_INTERIOR := Color("182228")
const COLOR_INFRASTRUCTURE := Color("4a6875")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")
const COLOR_AMBER := Color("d39a62")

signal clue_inspected(id: String, prop_type: int)
signal transfer_price_disclosed()
signal commitment_applied(commitment: StringName, cost: StringName)
signal safe_trial_feedback_observed(feedback: StringName)
signal exit_unlocked()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var anchor_controller: AnchorExclusivityController = $AnchorExclusivityController
@onready var transfer_relay: AnchorableObject = $TransferRelay

var is_transfer_constraint_observed := false
var is_home_sample_trace_inspected := false
var is_local_lena_signal_trace_inspected := false
var is_transfer_price_disclosed := false
var is_commitment_applied := false
var active_commitment: StringName = &""
var visible_cost_id: StringName = &""
var is_exit_unlocked := false
var is_level_completed := false
var _pending_commitment: StringName = &""
var _pulse_time := 0.0
var _exit_open_progress := 0.0


func _ready() -> void:
	if player:
		player.position = Vector2(50.0, 240.0)
	_setup_camera()
	_setup_props()
	_setup_guidance()
	if anchor_controller and transfer_relay:
		anchor_controller.register_anchor(transfer_relay)
	if transfer_relay and not transfer_relay.reality_shift_processed.is_connected(_on_transfer_relay_shift):
		transfer_relay.reality_shift_processed.connect(_on_transfer_relay_shift)
	if airlock_zone and not airlock_zone.body_entered.is_connected(_on_airlock_zone_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_zone_body_entered)
	queue_redraw()


func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)


func _setup_props() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var point := child as MemoryResonancePoint
			if not point.resonance_triggered.is_connected(_on_prop_inspected.bind(point)):
				point.resonance_triggered.connect(_on_prop_inspected.bind(point))


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s28_transfer_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", "")
	_register_beat(&"s28_transfer_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Transfer utrzyma jeden ślad; drugi zapłaci małym, nazwanym kosztem.", "The transfer will retain one trace; the other pays a small, named cost.", "")
	_register_beat(&"s28_cost_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Być może wspólny dryf zachowa relację lepiej niż dokładną sekundę próbki.", "Shared drift may preserve the relation better than the sample's exact second.", "live_signal")
	_register_beat(&"s28_commitment", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Odczytaj oba ślady, ujawnij cenę, potem wybierz Anchor śladu domu albo Yield wspólnego dryfu.", "Read both traces, disclose the price, then choose Anchor for the home trace or Yield for shared drift.", "transfer_cost_trial")
	_register_beat(&"s28_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: cena musi być widoczna przed Anchor/Yield. Pomoc nie wybiera zobowiązania.", "HINT: the price must be visible before Anchor/Yield. Help does not choose the commitment.", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_28"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	if hypothesis_id == &"live_signal":
		beat.predicted_check = "home_trace_anchor_or_shared_drift_yield"
	elif hypothesis_id == &"transfer_cost_trial":
		beat.predicted_check = "named_memory_or_timestamp_cost_after_shift"
	guidance_service.register_beat(beat)


func _process(delta: float) -> void:
	_pulse_time += delta
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 2.0)
	queue_redraw()


func _on_prop_inspected(id: String, prop_type: int, _point: MemoryResonancePoint) -> void:
	match id:
		"prop_driver_console", "prop_cab_control_console":
			observe_transfer_constraint()
		"prop_transit_window", "prop_tunnel_view_window":
			inspect_home_sample_trace()
		"prop_paradox_viewport", "prop_signal_loss_paradox":
			inspect_local_lena_signal_trace()
		"prop_closing_intercom", "prop_passenger_intercom":
			disclose_transfer_price()
		"prop_station_28_exit":
			if is_exit_unlocked:
				_trigger_level_completion()
			else:
				_record_feedback(&"commitment_required")
	clue_inspected.emit(id, prop_type)


func observe_transfer_constraint() -> bool:
	if is_transfer_constraint_observed:
		return false
	if not (_has_true(FACT_RECONSTRUCTED) and _has_true(FACT_LOCAL_SIGNAL)):
		_record_feedback(&"reconstructed_signal_required")
		return false
	is_transfer_constraint_observed = true
	_mark_prop("DriverConsole")
	_report_progress(&"s28_transfer_constraint")
	return true


func inspect_home_sample_trace() -> bool:
	if is_home_sample_trace_inspected:
		return false
	if not is_transfer_constraint_observed:
		_record_feedback(&"transfer_constraint_required")
		return false
	is_home_sample_trace_inspected = true
	_mark_prop("TransitWindow")
	_report_progress(&"s28_home_sample_trace")
	return true


func inspect_local_lena_signal_trace() -> bool:
	if is_local_lena_signal_trace_inspected:
		return false
	if not is_home_sample_trace_inspected:
		_record_feedback(&"home_sample_trace_required")
		return false
	is_local_lena_signal_trace_inspected = true
	_mark_prop("ParadoxViewport")
	_report_progress(&"s28_local_lena_signal_trace")
	return true


func disclose_transfer_price() -> bool:
	if is_transfer_price_disclosed:
		return false
	if not is_local_lena_signal_trace_inspected:
		_record_feedback(&"local_lena_signal_trace_required")
		return false
	is_transfer_price_disclosed = true
	_mark_prop("ClosingIntercom")
	transfer_price_disclosed.emit()
	if guidance_service:
		guidance_service.trigger_beat(&"s28_commitment")
	_report_progress(&"s28_transfer_price_disclosed")
	return true


func perform_home_trace_anchor() -> bool:
	if not _can_apply_commitment():
		return false
	_pending_commitment = COMMITMENT_HOME_ANCHOR
	if anchor_controller:
		anchor_controller.set_active_anchor(transfer_relay)
	else:
		transfer_relay.set_anchored(true)
	transfer_relay.apply_reality_shift(AnchorableObject.RealityState.STATE_B)
	return is_commitment_applied and active_commitment == COMMITMENT_HOME_ANCHOR


func perform_shared_drift_yield() -> bool:
	if not _can_apply_commitment():
		return false
	_pending_commitment = COMMITMENT_SHARED_DRIFT
	if anchor_controller:
		anchor_controller.clear_active_anchor()
	else:
		transfer_relay.set_anchored(false)
	transfer_relay.apply_reality_shift(AnchorableObject.RealityState.STATE_B)
	return is_commitment_applied and active_commitment == COMMITMENT_SHARED_DRIFT


func _can_apply_commitment() -> bool:
	if is_commitment_applied:
		_record_feedback(&"commitment_already_applied")
		return false
	if not is_transfer_price_disclosed:
		_record_feedback(&"transfer_price_required")
		return false
	if transfer_relay == null:
		_record_feedback(&"transfer_relay_unavailable")
		return false
	return true


func _on_transfer_relay_shift(_target_state: AnchorableObject.RealityState, resisted: bool) -> void:
	if _pending_commitment.is_empty() or is_commitment_applied:
		return
	var commitment := _pending_commitment
	_pending_commitment = &""
	if commitment == COMMITMENT_HOME_ANCHOR and resisted:
		_commit(commitment, COST_HOME_ANCHOR)
	elif commitment == COMMITMENT_SHARED_DRIFT and not resisted:
		_commit(commitment, COST_SHARED_DRIFT)
	else:
		_record_feedback(&"reality_shift_result_mismatch")


func _commit(commitment: StringName, cost: StringName) -> void:
	is_commitment_applied = true
	active_commitment = commitment
	visible_cost_id = cost
	_record(FACT_COMMITMENT, String(commitment))
	_record(FACT_SMALL_COST, String(cost))
	_record(&"small_cost_manifested", String(cost))
	_record(FACT_TRACE, String(commitment))
	_record(FACT_MECHANIC_COST, true)
	commitment_applied.emit(commitment, cost)
	if guidance_service:
		guidance_service.close_hypothesis(&"live_signal")
		guidance_service.report_progress(StringName("s28_" + String(commitment)))
	_unlock_exit()
	queue_redraw()


func unlock_exit_door() -> bool:
	if is_exit_unlocked:
		return false
	_unlock_exit()
	return true


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_mark_prop("Station28Exit")
	call_deferred("_complete_if_player_already_in_airlock")
	queue_redraw()


func _complete_if_player_already_in_airlock() -> void:
	if airlock_zone and player and airlock_zone.overlaps_body(player):
		_trigger_level_completion()


func _on_airlock_zone_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_exit_unlocked:
		_trigger_level_completion()


func _trigger_level_completion() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _mark_prop(node_name: StringName) -> void:
	if props == null:
		return
	var point := props.get_node_or_null(NodePath(String(node_name))) as MemoryResonancePoint
	if point:
		point.is_activated = true


func _has_true(decision_id: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	return state != null and state.decisions.get(decision_id, false) == true


func _record_feedback(value: StringName) -> void:
	_record(FACT_SAFE_FEEDBACK, String(value))
	safe_trial_feedback_observed.emit(value)
	if guidance_service:
		guidance_service.report_failed_attempt(StringName("s28_" + String(value)))


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)
	queue_redraw()


func _record(decision_id: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(decision_id, value)


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	draw_rect(Rect2(Vector2(40.0, 180.0), Vector2(480.0, 90.0)), COLOR_CARRIAGE_BODY, true)
	draw_rect(Rect2(Vector2(60.0, 195.0), Vector2(100.0, 45.0)), COLOR_CARRIAGE_INTERIOR, true)
	draw_rect(Rect2(Vector2(180.0, 195.0), Vector2(100.0, 45.0)), COLOR_CARRIAGE_INTERIOR, true)
	draw_rect(Rect2(Vector2(300.0, 195.0), Vector2(100.0, 45.0)), COLOR_CARRIAGE_INTERIOR, true)
	draw_rect(Rect2(Vector2(420.0, 195.0), Vector2(90.0, 45.0)), COLOR_INFRASTRUCTURE, true)
	var trace_color := COLOR_CYAN if is_home_sample_trace_inspected else COLOR_AMBER
	draw_line(Vector2(188.0, 250.0), Vector2(270.0, 250.0), trace_color, 2.0)
	var signal_color := COLOR_CYAN if is_local_lena_signal_trace_inspected else COLOR_AMBER
	draw_line(Vector2(308.0, 250.0), Vector2(390.0, 250.0), signal_color, 2.0)
	if visible_cost_id == COST_HOME_ANCHOR:
		draw_line(Vector2(424.0, 248.0), Vector2(484.0, 248.0), Color(COLOR_CYAN, 0.35), 3.0)
	elif visible_cost_id == COST_SHARED_DRIFT:
		draw_line(Vector2(424.0, 248.0), Vector2(484.0, 248.0), COLOR_CORRECTION, 3.0)
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
