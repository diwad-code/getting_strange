class_name Station30
extends Node2D
## PRZESZKODA — dlaczego to tu jest: Stół prognoz rozdziela trzy operacyjne trasy i pokazuje, które pola zależą od dokładnego zakresu zgody Jakuba.
## PRZESZKODA — czego wymaga od Leny: Zbudowania trzech prognoz i osobnego porównania ich zależności oraz jawnych braków danych.
## PRZESZKODA — koszt porażki: Niekompletna mapa pozostawia nazwany brak bez wyboru finału i bez utraty wykonanych prognoz.

## Station 30 — S10, jawne mapowanie trzech prognoz względem zapisanej zgody.
## Zbudowanie trzeciej prognozy nie wykonuje porównania automatycznie. Odmowa
## Jakuba jest pełnoprawnym wejściem: może wykluczyć drogi, lecz nie blokuje śladu.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_ENTRY := &"p7.interrupted_trial_and_small_cost.trace"
const FACT_CONSENT := &"p7.jakub_boundary_and_forecasts.jakub_consent_state"
const FACT_CANONICAL_CONSENT := &"jakub_consent_state"
const FACT_FORCE_HOME := &"p7.jakub_boundary_and_forecasts.force_home_forecast"
const FACT_CLOSE_EQUAL_RECOVER := &"p7.jakub_boundary_and_forecasts.close_equal_recover_local_forecast"
const FACT_MUTUAL_PASSAGE := &"p7.jakub_boundary_and_forecasts.mutual_passage_forecast"
const FACT_MAPPED := &"p7.jakub_boundary_and_forecasts.route_hypotheses_mapped"
const FACT_TRACE := &"p7.jakub_boundary_and_forecasts.trace"
const FACT_FEEDBACK := &"p7.jakub_boundary_and_forecasts.safe_trial_feedback"
const TRACE_VALUE := "three_routes_mapped_against_jakub_consent"
const VALID_CONSENT_STATES: Array[String] = ["granted", "limited", "refused"]

signal clue_inspected(id: String, prop_type: int)
signal force_home_forecast_built()
signal close_equal_recover_local_forecast_built()
signal mutual_passage_forecast_built()
signal forecast_consent_dependencies_compared()
signal exit_unlocked()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_force_home_forecast_built := false
var is_close_equal_recover_local_forecast_built := false
var is_mutual_passage_forecast_built := false
var are_forecast_consent_dependencies_compared := false
var force_home_forecast: Dictionary = {}
var close_equal_recover_local_forecast: Dictionary = {}
var mutual_passage_forecast: Dictionary = {}
var jakub_consent_state := ""
var is_exit_unlocked := false
var is_level_completed := false


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_props()
	jakub_consent_state = _read_string(FACT_CONSENT)
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	queue_redraw()


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s30_forecast_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s30_forecast_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Trzy drogi. Każda ma inną zależność od zgody Jakuba i losu miejscowej Leny.", "Three routes. Each depends differently on Jakub's consent and local Lena's fate.", &"", "")
	_register_beat(&"s30_consent_dependency_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Najkrótsza droga może nie być dostępna przy zapisanej odpowiedzi. Prognozy pokażą różnicę.", "The shortest route may not be available under the recorded answer. The forecasts will expose the difference.", &"single_route_sufficient", "compare_three_forecast_consent_dependencies")
	_register_beat(&"s30_compare_forecasts", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zbuduję trzy prognozy osobno, potem porównam ich zależności z zapisaną zgodą.", "Build all three forecasts separately, then compare their dependencies with the recorded consent.", &"", "compare_forecast_consent_dependencies")
	_register_beat(&"s30_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Tablica, transformatory i schemat budują prognozy. Bezpiecznik wykonuje porównanie.", "HINT: Board, transformers, and schematic build forecasts. The breaker performs the comparison.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_30"
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
		"prop_main_distribution_board":
			build_force_home_forecast()
		"prop_transformer_bank":
			build_close_equal_recover_local_forecast()
		"prop_grid_schematic":
			build_mutual_passage_forecast()
		"prop_section_breaker":
			compare_forecast_consent_dependencies()
		"prop_station_30_exit":
			if is_exit_unlocked:
				_trigger_level_completion()
			else:
				_record_feedback(&"forecast_comparison_required")
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func build_force_home_forecast() -> bool:
	if is_force_home_forecast_built:
		return false
	if not _forecast_entry_ready():
		return false
	force_home_forecast = {
		"route_id": "force_home",
		"consent_states": ["granted"],
		"local_lena_priority": "deferred",
		"jakub_boundary": "conditional"
	}
	is_force_home_forecast_built = true
	_record(FACT_FORCE_HOME, force_home_forecast)
	force_home_forecast_built.emit()
	if guidance_service:
		guidance_service.trigger_beat(&"s30_forecast_contact")
	_report_progress(&"s30_force_home_forecast")
	queue_redraw()
	return true


func build_close_equal_recover_local_forecast() -> bool:
	if is_close_equal_recover_local_forecast_built:
		return false
	if not _forecast_entry_ready():
		return false
	close_equal_recover_local_forecast = {
		"route_id": "close_equal_recover_local",
		"consent_states": ["granted", "limited"],
		"local_lena_priority": "recover_first",
		"jakub_boundary": "preserved"
	}
	is_close_equal_recover_local_forecast_built = true
	_record(FACT_CLOSE_EQUAL_RECOVER, close_equal_recover_local_forecast)
	close_equal_recover_local_forecast_built.emit()
	if guidance_service:
		guidance_service.trigger_beat(&"s30_consent_dependency_hypothesis")
	_report_progress(&"s30_close_equal_recover_forecast")
	queue_redraw()
	return true


func build_mutual_passage_forecast() -> bool:
	if is_mutual_passage_forecast_built:
		return false
	if not _forecast_entry_ready():
		return false
	mutual_passage_forecast = {
		"route_id": "mutual_passage",
		"consent_states": ["granted"],
		"local_lena_priority": "coordinated",
		"jakub_boundary": "preserved"
	}
	is_mutual_passage_forecast_built = true
	_record(FACT_MUTUAL_PASSAGE, mutual_passage_forecast)
	mutual_passage_forecast_built.emit()
	_report_progress(&"s30_mutual_passage_forecast")
	queue_redraw()
	return true


func compare_forecast_consent_dependencies() -> bool:
	if are_forecast_consent_dependencies_compared:
		return false
	if not _forecast_entry_ready():
		return false
	if not is_force_home_forecast_built:
		_record_feedback(&"force_home_forecast_required")
		return false
	if not is_close_equal_recover_local_forecast_built:
		_record_feedback(&"close_equal_recover_local_forecast_required")
		return false
	if not is_mutual_passage_forecast_built:
		_record_feedback(&"mutual_passage_forecast_required")
		return false
	are_forecast_consent_dependencies_compared = true
	_record(FACT_MAPPED, true)
	_record(&"route_hypotheses_mapped", true)
	_record(FACT_TRACE, TRACE_VALUE)
	forecast_consent_dependencies_compared.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"single_route_sufficient")
		guidance_service.trigger_beat(&"s30_compare_forecasts")
	_report_progress(&"s30_forecast_dependencies_compared")
	unlock_exit()
	queue_redraw()
	return true


func _forecast_entry_ready() -> bool:
	if not _has(FACT_ENTRY):
		_record_feedback(&"entry_trace_required")
		return false
	jakub_consent_state = _read_string(FACT_CONSENT)
	if jakub_consent_state.is_empty():
		jakub_consent_state = _read_string(FACT_CANONICAL_CONSENT)
	if not VALID_CONSENT_STATES.has(jakub_consent_state):
		_record_feedback(&"jakub_consent_required")
		return false
	return true


func unlock_exit() -> bool:
	if is_exit_unlocked or not are_forecast_consent_dependencies_compared:
		return false
	is_exit_unlocked = true
	var exit_prop := props.get_node_or_null("Station30Exit") as MemoryResonancePoint
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
		guidance_service.report_failed_attempt(&"s30_" + value)


func _has(key: StringName) -> bool:
	var value: Variant = _read(key)
	if value == null:
		return false
	if value is String or value is StringName:
		return not String(value).is_empty()
	return bool(value)


func _read_string(key: StringName) -> String:
	var value: Variant = _read(key)
	return String(value) if value != null else ""


func _read(key: StringName) -> Variant:
	var state := get_node_or_null("/root/GameStateManager")
	if state == null:
		return null
	return state.decisions.get(key, null)


func _record(key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(key, value)


func _is_resolved(id: String) -> bool:
	match id:
		"prop_main_distribution_board": return is_force_home_forecast_built
		"prop_transformer_bank": return is_close_equal_recover_local_forecast_built
		"prop_grid_schematic": return is_mutual_passage_forecast_built
		"prop_section_breaker": return are_forecast_consent_dependencies_compared
		"prop_station_30_exit": return is_exit_unlocked
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var force_color := VectorStageStyle.ANCHOR_CYAN if is_force_home_forecast_built else VectorStageStyle.HUMAN_AMBER
	var close_color := VectorStageStyle.ANCHOR_CYAN if is_close_equal_recover_local_forecast_built else VectorStageStyle.HUMAN_AMBER
	var mutual_color := VectorStageStyle.ANCHOR_CYAN if is_mutual_passage_forecast_built else VectorStageStyle.HUMAN_AMBER
	var compare_color := VectorStageStyle.LIGHT_PLANE if are_forecast_consent_dependencies_compared else VectorStageStyle.SEAM_RED
	draw_rect(Rect2(Vector2(112.0, 226.0), Vector2(36.0, 28.0)), force_color, false, 1.0)
	draw_rect(Rect2(Vector2(222.0, 222.0), Vector2(36.0, 32.0)), close_color, false, 1.0)
	draw_circle(Vector2(470.0, 236.0), 10.0, mutual_color, false, 2.0)
	draw_line(Vector2(346.0, 226.0), Vector2(374.0, 254.0), compare_color, 2.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_color, 2.0)
