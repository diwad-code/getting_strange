class_name Station06
extends Node2D

## Station 06 — S03, papier i zapis offline.
## Dwa aktualne źródła nie zgadzają się; nadjeżdżający pojazd jest testem
## rozstrzygającym, a nie nagrodą za listę inspekcji.

## PRZESZKODA — dlaczego to tu jest: Przystanek końcowy przyjmuje pasażerów według numeru kursu z rozkładu, a aplikacja i papier opisują ten sam dzień.
## PRZESZKODA — czego wymaga od Leny: odczytania obu nośników i sprawdzenia kierunku nadjeżdżającego pojazdu.
## PRZESZKODA — koszt porażki: wejście do pojazdu po jednym źródle zostawia komunikaty o brakującym porównaniu.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_S02_TRACE := &"p7.return_under_control.trace"
const FACT_PAPER := &"p7.address_and_record.paper_route_observed"
const FACT_OFFLINE := &"p7.address_and_record.offline_route_observed"
const FACT_RESULT := &"p7.address_and_record.public_route_result"
const FACT_FEEDBACK := &"p7.address_and_record.safe_trial_feedback"

signal clue_inspected(id: String, prop_type: int)
signal public_route_compared()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var replacement_bus_exit_door: AnimatableBody2D = $Geometry/ReplacementBusExitDoor
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_paper_route_observed := false
var is_offline_route_observed := false
var is_public_route_compared := false
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
	_register_beat(&"s06_route_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s06_route_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Ta sama data. Dwa numery linii.", "Same date. Two line numbers.", &"", "")
	_register_beat(&"s06_cache_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Cache w telefonie. Najprostsze — sprawdzę autobus.", "Phone cache. Simplest answer — I will check the bus.", &"offline_cache", "compare_paper_to_vehicle")
	_register_beat(&"s06_compare_public_route", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Porównam papier, zapis offline i kierunek pojazdu.", "I will compare paper, offline record, and the vehicle direction.", &"", "")
	_register_beat(&"s06_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Odczytaj oba rozkłady, potem sprawdź podjazd autobusu.", "HINT: Read both schedules, then check the arriving bus.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_06"
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
		"paper_timetable":
			observe_paper_timetable()
		"phone_app_schedule":
			observe_offline_route()
		"bus_arrival_stop":
			compare_public_route()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func observe_paper_timetable() -> bool:
	if is_paper_route_observed or not _has(FACT_S02_TRACE):
		_record_feedback(&"reader_trace_required")
		return false
	is_paper_route_observed = true
	_record(FACT_PAPER, true)
	_report_progress(&"s06_paper_route_observed")
	queue_redraw()
	return true


func observe_offline_route() -> bool:
	if is_offline_route_observed or not is_paper_route_observed:
		_record_feedback(&"paper_route_required")
		return false
	is_offline_route_observed = true
	_record(FACT_OFFLINE, true)
	_report_progress(&"s06_offline_route_observed")
	if guidance_service:
		guidance_service.trigger_beat(&"s06_cache_hypothesis")
	queue_redraw()
	return true


func compare_public_route() -> bool:
	if is_public_route_compared:
		return false
	if not (is_paper_route_observed and is_offline_route_observed):
		_record_feedback(&"paper_or_offline_missing")
		return false
	is_public_route_compared = true
	_record(FACT_RESULT, "paper_matches_vehicle")
	_record(&"unease_pattern_started", true)
	public_route_compared.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"offline_cache")
	_report_progress(&"s06_public_route_compared")
	_unlock_exit()
	queue_redraw()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s06_" + value)


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	if replacement_bus_exit_door:
		ExitClearance.open_body_tweened(self, replacement_bus_exit_door, 126.0, 0.8)
	call_deferred("_complete_if_player_already_in_airlock")


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


func _has(key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	return state != null and not String(state.decisions.get(key, "")).is_empty()


func _record(key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(key, value)


func _is_resolved(id: String) -> bool:
	match id:
		"paper_timetable": return is_paper_route_observed
		"phone_app_schedule": return is_offline_route_observed
		"bus_arrival_stop": return is_public_route_compared
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var paper_color := VectorStageStyle.LIGHT_PLANE if is_paper_route_observed else VectorStageStyle.HUMAN_AMBER
	var offline_color := VectorStageStyle.CORRECTION_OXIDE if is_offline_route_observed else VectorStageStyle.HUMAN_AMBER
	var vehicle_color := VectorStageStyle.ANCHOR_CYAN if is_public_route_compared else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(Vector2(160.0, 238.0), Vector2(26.0, 16.0)), paper_color, false, 2.0)
	draw_rect(Rect2(Vector2(310.0, 238.0), Vector2(26.0, 16.0)), offline_color, false, 2.0)
	draw_line(Vector2(448.0, 254.0), Vector2(486.0, 254.0), vehicle_color, 3.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(560.0, 60.0), Vector2(560.0, 312.0), exit_color, 2.0)
	draw_line(Vector2(610.0, 60.0), Vector2(610.0, 312.0), exit_color, 2.0)
