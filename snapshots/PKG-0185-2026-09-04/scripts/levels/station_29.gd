class_name Station29
extends Node2D
## PRZESZKODA — dlaczego to tu jest: Nadajnik Jakuba daje silny sygnał, ale infrastruktura nie może użyć jego życia bez jawnie określonej zgody.
## PRZESZKODA — czego wymaga od Leny: Ujawnienia propozycji, zakresu, ryzyka i kosztu, wyłączenia nadajnika oraz zapisania odpowiedzi Jakuba.
## PRZESZKODA — koszt porażki: Brak ujawnienia blokuje zapis zgody, lecz nie karze Jakuba ani nie zamyka późniejszej drogi bez jego sygnału.

## Station 29 — S10, granica Jakuba przed prognozowaniem dróg.
## Zgoda jest zapisywana wyłącznie przez jawny czasownik po ujawnieniu ryzyka
## i wyłączeniu nadajnika. Każdy z trzech stanów zgody pozwala kontynuować.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_ENTRY := &"p7.interrupted_trial_and_small_cost.trace"
const FACT_CONTRAST := &"p7.jakub_boundary_and_forecasts.ucp_jakub_contrast_proposal_inspected"
const FACT_ORDINARY_SCOPE := &"p7.jakub_boundary_and_forecasts.jakub_ordinary_life_scope_observed"
const FACT_SIGNAL_RISK := &"p7.jakub_boundary_and_forecasts.jakub_signal_risk_disclosed"
const FACT_TRANSMITTER := &"p7.jakub_boundary_and_forecasts.jakub_transmitter_disabled"
const FACT_CONSENT := &"p7.jakub_boundary_and_forecasts.jakub_consent_state"
const FACT_FEEDBACK := &"p7.jakub_boundary_and_forecasts.safe_trial_feedback"
const VALID_CONSENT_STATES: Array[StringName] = [&"granted", &"limited", &"refused"]

signal clue_inspected(id: String, prop_type: int)
signal ucp_jakub_contrast_proposal_inspected()
signal jakub_ordinary_life_scope_observed()
signal jakub_signal_risk_disclosed()
signal jakub_transmitter_disabled()
signal jakub_consent_recorded(consent: StringName)
signal exit_unlocked()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_ucp_jakub_contrast_inspected := false
var is_jakub_ordinary_life_scope_observed := false
var is_jakub_signal_risk_disclosed := false
var is_jakub_transmitter_disabled := false
var is_jakub_consent_recorded := false
var jakub_consent_state: StringName = &""
var is_exit_unlocked := false
var is_level_completed := false


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_props()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	queue_redraw()


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s29_contrast_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s29_contrast_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "UCP proponuje jedną drogę. Zwykłe życie Jakuba wyznacza granicę.", "UCP proposes one route. Jakub's ordinary life sets the boundary.", &"", "")
	_register_beat(&"s29_boundary_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Nadajnik może wymuszać odpowiedź. Najpierw ujawnię ryzyko i go wyłączę.", "The transmitter may compel an answer. I will disclose the risk and disable it first.", &"compelled_consent", "disable_transmitter_before_recording_consent")
	_register_beat(&"s29_record_consent", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Porównam propozycję z jego zwykłym życiem, ujawnię ryzyko, wyłączę nadajnik i zapiszę odpowiedź bez poprawiania jej.", "Compare the proposal with his ordinary life, disclose the risk, disable the transmitter, and record his answer without correcting it.", &"", "record_jakub_consent")
	_register_beat(&"s29_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Propozycja UCP, zakres zwykłego życia, ryzyko sygnału, nadajnik, potem jawna zgoda.", "HINT: UCP proposal, ordinary-life scope, signal risk, transmitter, then explicit consent.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_29"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	beat.predicted_check = predicted_check
	guidance_service.register_beat(beat)


func _connect_props() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var prop := child as MemoryResonancePoint
			if not prop.resonance_triggered.is_connected(_on_prop_resonance_triggered.bind(prop)):
				prop.resonance_triggered.connect(_on_prop_resonance_triggered.bind(prop))


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	match id:
		"prop_abandoned_tracks":
			inspect_ucp_jakub_contrast_proposal()
		"prop_flickering_neon":
			observe_jakub_ordinary_life_scope()
		"prop_substructure_well":
			disclose_jakub_signal_risk()
		"prop_jakub_beacon":
			disable_jakub_transmitter()
		"prop_station_29_exit":
			if is_exit_unlocked:
				_trigger_level_completion()
			else:
				_record_feedback(&"jakub_consent_required")
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func inspect_ucp_jakub_contrast_proposal() -> bool:
	if is_ucp_jakub_contrast_inspected:
		return false
	if not _has(FACT_ENTRY):
		_record_feedback(&"entry_trace_required")
		return false
	is_ucp_jakub_contrast_inspected = true
	_record(FACT_CONTRAST, true)
	ucp_jakub_contrast_proposal_inspected.emit()
	if guidance_service:
		guidance_service.trigger_beat(&"s29_contrast_contact")
	_report_progress(&"s29_contrast_inspected")
	queue_redraw()
	return true


func observe_jakub_ordinary_life_scope() -> bool:
	if is_jakub_ordinary_life_scope_observed:
		return false
	if not is_ucp_jakub_contrast_inspected:
		_record_feedback(&"contrast_proposal_required")
		return false
	is_jakub_ordinary_life_scope_observed = true
	_record(FACT_ORDINARY_SCOPE, true)
	jakub_ordinary_life_scope_observed.emit()
	if guidance_service:
		guidance_service.trigger_beat(&"s29_boundary_hypothesis")
	_report_progress(&"s29_ordinary_scope_observed")
	queue_redraw()
	return true


func disclose_jakub_signal_risk() -> bool:
	if is_jakub_signal_risk_disclosed:
		return false
	if not is_jakub_ordinary_life_scope_observed:
		_record_feedback(&"ordinary_life_scope_required")
		return false
	is_jakub_signal_risk_disclosed = true
	_record(FACT_SIGNAL_RISK, true)
	jakub_signal_risk_disclosed.emit()
	_report_progress(&"s29_signal_risk_disclosed")
	queue_redraw()
	return true


func disable_jakub_transmitter() -> bool:
	if is_jakub_transmitter_disabled:
		return false
	if not is_jakub_signal_risk_disclosed:
		_record_feedback(&"signal_risk_disclosure_required")
		return false
	is_jakub_transmitter_disabled = true
	_record(FACT_TRANSMITTER, true)
	jakub_transmitter_disabled.emit()
	_report_progress(&"s29_transmitter_disabled")
	queue_redraw()
	return true


func record_jakub_consent(consent: StringName) -> bool:
	if is_jakub_consent_recorded:
		return false
	if not is_ucp_jakub_contrast_inspected:
		_record_feedback(&"contrast_proposal_required")
		return false
	if not is_jakub_ordinary_life_scope_observed:
		_record_feedback(&"ordinary_life_scope_required")
		return false
	if not is_jakub_signal_risk_disclosed:
		_record_feedback(&"signal_risk_disclosure_required")
		return false
	if not is_jakub_transmitter_disabled:
		_record_feedback(&"transmitter_disable_required")
		return false
	if not VALID_CONSENT_STATES.has(consent):
		_record_feedback(&"invalid_jakub_consent")
		return false
	is_jakub_consent_recorded = true
	jakub_consent_state = consent
	_record(FACT_CONSENT, String(consent))
	_record(&"jakub_consent_state", String(consent))
	jakub_consent_recorded.emit(consent)
	if guidance_service:
		guidance_service.close_hypothesis(&"compelled_consent")
		guidance_service.trigger_beat(&"s29_record_consent")
	_report_progress(&"s29_consent_" + consent)
	unlock_exit()
	queue_redraw()
	return true


func unlock_exit() -> bool:
	if is_exit_unlocked or not is_jakub_consent_recorded:
		return false
	is_exit_unlocked = true
	var exit_prop := props.get_node_or_null("Station29Exit") as MemoryResonancePoint
	if exit_prop != null:
		exit_prop.is_activated = true
	exit_unlocked.emit()
	call_deferred("_complete_if_player_already_in_airlock")
	queue_redraw()
	return true


func _complete_if_player_already_in_airlock() -> void:
	if airlock_zone != null and player != null and airlock_zone.overlaps_body(player):
		_trigger_level_completion()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_exit_unlocked:
		_trigger_level_completion()


func _trigger_level_completion() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s29_" + value)


func _has(key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	if state == null:
		return false
	var value: Variant = state.decisions.get(key, null)
	if value == null:
		return false
	if value is String or value is StringName:
		return not String(value).is_empty()
	return bool(value)


func _record(key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(key, value)


func _is_resolved(id: String) -> bool:
	match id:
		"prop_abandoned_tracks": return is_ucp_jakub_contrast_inspected
		"prop_flickering_neon": return is_jakub_ordinary_life_scope_observed
		"prop_substructure_well": return is_jakub_signal_risk_disclosed
		"prop_jakub_beacon": return is_jakub_transmitter_disabled
		"prop_station_29_exit": return is_exit_unlocked
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var contrast_color := VectorStageStyle.ANCHOR_CYAN if is_ucp_jakub_contrast_inspected else VectorStageStyle.HUMAN_AMBER
	var scope_color := VectorStageStyle.ANCHOR_CYAN if is_jakub_ordinary_life_scope_observed else VectorStageStyle.HUMAN_AMBER
	var risk_color := VectorStageStyle.CORRECTION_OXIDE if is_jakub_signal_risk_disclosed else VectorStageStyle.HUMAN_AMBER
	var transmitter_color := VectorStageStyle.LIGHT_PLANE if is_jakub_transmitter_disabled else VectorStageStyle.SEAM_RED
	draw_line(Vector2(96.0, 252.0), Vector2(164.0, 252.0), contrast_color, 2.0)
	draw_rect(Rect2(Vector2(226.0, 232.0), Vector2(28.0, 38.0)), scope_color, false, 1.0)
	draw_circle(Vector2(360.0, 248.0), 8.0, risk_color, false, 2.0)
	draw_line(Vector2(458.0, 224.0), Vector2(482.0, 256.0), transmitter_color, 2.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_color, 2.0)
