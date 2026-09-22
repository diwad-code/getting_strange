class_name Station23
extends Node2D

## Station 23 — reversible A/B trial on a dead circuit.
## Goal: test the two observed signal hypotheses without using a person or a
## consequential record as a parameter.
## Obstacle: one relay can retain a relation, while a yielded relay admits the
## neighbouring state; both effects expose a different local cost.
## Action: choose Anchor or Yield through the existing AnchorableObject API.
## Result: the trial records an observable cost and keeps every evidence source.
##
## PRZESZKODA — dlaczego to tu jest: Odłączony obwód testowy utrzymuje dwa
## przekaźniki kalibracyjne, aby serwis mógł izolować koszt korekty od sieci Linii 4.
## PRZESZKODA — czego wymaga od Leny: porównania obu stanów na bezpiecznej aparaturze
## i wybrania, który parametr ma zostać chwilowo utrzymany.
## PRZESZKODA — koszt porażki: niepełna próba zapala tylko komunikat o brakującym
## porównaniu; nie niszczy śladów, nie resetuje sceny i nie blokuje poprawnej próby.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const FACT_WORLD_RECOGNIZED := &"world_recognized"
const FACT_SIGNAL_ECHO := &"p7.mutual_test.signal_echo_observed"
const FACT_ADJACENT_RESPONSE := &"p7.mutual_test.adjacent_state_observed"
const FACT_TRIAL_OUTCOME := &"p7.mutual_test.dead_circuit_outcome"
const FACT_TRIAL_COST := &"p7.mutual_test.dead_circuit_cost"
const FACT_SAFE_FEEDBACK := &"p7.mutual_test.safe_trial_feedback"
const FACT_MECHANIC_COST := &"mechanic_cost_observed"

signal clue_inspected(id: String, prop_type: int)
signal trial_result_observed(outcome: StringName, cost: StringName)
signal safe_trial_feedback_observed(feedback: StringName)
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var anchor_controller: AnchorExclusivityController = $AnchorExclusivityController
@onready var retention_relay: AnchorableObject = $RetentionRelay
@onready var adjacent_relay: AnchorableObject = $AdjacentRelay

var is_anchor_trial_observed := false
var is_yield_trial_observed := false
var is_cost_understood := false
var is_level_completed := false
var visible_cost_id: StringName = &""
var _pending_trial: StringName = &""
var _restoring_apparatus := false
var _pulse_time := 0.0


func _ready() -> void:
	_setup_camera()
	_setup_guidance()
	_connect_props()
	if anchor_controller:
		anchor_controller.register_anchor(retention_relay)
		anchor_controller.register_anchor(adjacent_relay)
	if retention_relay and not retention_relay.reality_shift_processed.is_connected(_on_retention_relay_shift):
		retention_relay.reality_shift_processed.connect(_on_retention_relay_shift)
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	queue_redraw()


func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s23_dead_circuit_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", "")
	_register_beat(&"s23_dead_circuit_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Martwy obwód przyjmuje tylko bezpieczną próbę.", "The dead circuit accepts only a safe trial.", "")
	_register_beat(&"s23_trial_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Jeśli to echo, utrzymanie relacji nie da odpowiedzi obok.", "If this is an echo, holding the relation will not produce a response beside it.", "signal_echo")
	_register_beat(&"s23_discriminating_trial", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Porównaj utrzymanie przekaźnika z uległością znacznika adresu.", "Compare holding the relay with yielding the address marker.", "")
	_register_beat(&"s23_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: wykonaj próbę Anchor albo Yield. Pomoc nie wybiera jej za ciebie.", "HINT: perform an Anchor or Yield trial. Help does not choose it for you.", "")


func _register_beat(
	beat_id: StringName,
	tier: GuidanceBeat.Tier,
	thought_kind: StringName,
	truth_scope: StringName,
	text_pl: String,
	text_en: String,
	hypothesis_id: StringName
) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_23"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	if hypothesis_id == &"signal_echo":
		beat.predicted_check = "dead_circuit_anchor_or_yield"
	guidance_service.register_beat(beat)


func _connect_props() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var prop := child as MemoryResonancePoint
			if not prop.resonance_triggered.is_connected(_on_prop_resonance_triggered.bind(prop)):
				prop.resonance_triggered.connect(_on_prop_resonance_triggered.bind(prop))


func _process(delta: float) -> void:
	_pulse_time += delta * 2.0
	queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int, _prop: MemoryResonancePoint) -> void:
	match id:
		"dead_circuit_port", "substation_junction":
			observe_dead_circuit()
		"shunt_fuse_switch":
			perform_anchor_trial()
		"thermal_overload_gauge":
			perform_yield_trial()
		"transformer_core":
			reset_trial_apparatus()
	clue_inspected.emit(id, prop_type)


func observe_dead_circuit() -> bool:
	if not _has_trial_prerequisites():
		_record_safe_feedback()
		return false
	if guidance_service:
		guidance_service.report_progress(&"s23_dead_circuit_observed")
	return true


func perform_anchor_trial() -> bool:
	if not _has_trial_prerequisites() or retention_relay == null:
		_record_safe_feedback()
		return false
	_pending_trial = &"anchor"
	if anchor_controller:
		anchor_controller.set_active_anchor(retention_relay)
	else:
		retention_relay.set_anchored(true)
	retention_relay.apply_reality_shift(AnchorableObject.RealityState.STATE_B)
	return is_anchor_trial_observed


func perform_yield_trial() -> bool:
	if not _has_trial_prerequisites() or retention_relay == null:
		_record_safe_feedback()
		return false
	_pending_trial = &"yield"
	if anchor_controller:
		anchor_controller.clear_active_anchor()
	else:
		retention_relay.set_anchored(false)
	retention_relay.apply_reality_shift(AnchorableObject.RealityState.STATE_B)
	return is_yield_trial_observed


func reset_trial_apparatus() -> bool:
	if retention_relay == null:
		return false
	_restoring_apparatus = true
	_pending_trial = &""
	if anchor_controller:
		anchor_controller.clear_active_anchor()
	retention_relay.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)
	_restoring_apparatus = false
	visible_cost_id = &""
	queue_redraw()
	return true


func _on_retention_relay_shift(_target_state: AnchorableObject.RealityState, resisted: bool) -> void:
	if _restoring_apparatus or _pending_trial.is_empty():
		return
	var outcome := _pending_trial
	_pending_trial = &""
	if outcome == &"anchor" and resisted:
		is_anchor_trial_observed = true
		_record_trial_outcome(&"anchor", &"adjacent_relay_heat")
	elif outcome == &"yield" and not resisted:
		is_yield_trial_observed = true
		_record_trial_outcome(&"yield", &"address_marker_blurred")


func _record_trial_outcome(outcome: StringName, cost: StringName) -> void:
	visible_cost_id = cost
	is_cost_understood = true
	_record(FACT_TRIAL_OUTCOME, String(outcome))
	_record(FACT_TRIAL_COST, String(cost))
	_record(FACT_MECHANIC_COST, true)
	trial_result_observed.emit(outcome, cost)
	if guidance_service:
		guidance_service.report_progress(&"s23_" + outcome)
		guidance_service.trigger_beat(&"s23_discriminating_trial")
	queue_redraw()


func _record_safe_feedback() -> void:
	_record(FACT_SAFE_FEEDBACK, "comparison_incomplete")
	safe_trial_feedback_observed.emit(&"comparison_incomplete")
	if guidance_service:
		guidance_service.report_failed_attempt(&"s23_comparison_incomplete")
	queue_redraw()


func _has_trial_prerequisites() -> bool:
	return _has_decision(FACT_WORLD_RECOGNIZED) and _has_decision(FACT_SIGNAL_ECHO) and _has_decision(FACT_ADJACENT_RESPONSE)


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_cost_understood and not is_level_completed:
		is_level_completed = true
		level_completed.emit()


func _record(decision_id: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(decision_id, value)


func _has_decision(decision_id: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	return state != null and state.decisions.get(decision_id, false) == true


func _draw() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var anchor_color := VectorStageStyle.ANCHOR_CYAN if is_anchor_trial_observed else VectorStageStyle.HUMAN_AMBER
	var yield_color := VectorStageStyle.CORRECTION_OXIDE if is_yield_trial_observed else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(Vector2(270.0, 238.0), Vector2(28.0, 18.0)), anchor_color, false, 2.0)
	draw_rect(Rect2(Vector2(406.0, 238.0), Vector2(28.0, 18.0)), yield_color, false, 2.0)
	if visible_cost_id == &"adjacent_relay_heat":
		draw_line(Vector2(438.0, 246.0), Vector2(470.0, 246.0), VectorStageStyle.CORRECTION_OXIDE, 3.0)
	elif visible_cost_id == &"address_marker_blurred":
		draw_line(Vector2(438.0, 246.0), Vector2(470.0, 246.0), Color(VectorStageStyle.HUMAN_AMBER, 0.32), 3.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_cost_understood else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_color, 2.0)
