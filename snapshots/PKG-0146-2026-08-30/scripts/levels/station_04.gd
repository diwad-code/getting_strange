class_name Station04
extends Node2D

## Station 04 — S02, powtórka pod kontrolą.
## Czytnik i zegar wagonu są niezależnymi źródłami; próba powtarza odczyt bez
## zmiany trasy. To zwykła infrastruktura tramwaju, nie wyzwanie timingowe.

## PRZESZKODA — dlaczego to tu jest: Wagon nocny kursuje według własnego zegara, a czytnik odtwarza zapis z bufora niezależnie od trasy.
## PRZESZKODA — czego wymaga od Leny: porównania powtórki czytnika z ruchem wagonu przed schowaniem urządzenia.
## PRZESZKODA — koszt porażki: schowanie czytnika przed porównaniem tworzy wyłącznie informację o brakującym źródle.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_S01_TRACE := &"p7.sample_and_promise.trace"
const FACT_READER := &"p7.return_under_control.reader_repeat_observed"
const FACT_CLOCK := &"p7.return_under_control.wagon_clock_observed"
const FACT_RESULT := &"p7.return_under_control.repeat_result"
const FACT_FEEDBACK := &"p7.return_under_control.safe_trial_feedback"

signal clue_inspected(id: String, prop_type: int)
signal reader_trial_completed()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var turnstile_barrier: StaticBody2D = $TurnstileBarrier
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_reader_repeat_observed := false
var is_wagon_clock_observed := false
var is_repeat_trial_completed := false
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
	_register_beat(&"s04_reader_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s04_reader_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Luka wróciła. Wagon nie zmienił trasy.", "The gap returned. The carriage did not change route.", &"", "")
	_register_beat(&"s04_cache_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Może cache. Zegar wagonu tego nie zapisał.", "Maybe cache. The carriage clock did not write it.", &"reader_cache", "repeat_reader_without_route_change")
	_register_beat(&"s04_compare_wagon_clock", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Porównam czytnik z zegarem wagonu i powtórzę odczyt bez zmiany trasy.", "Compare reader and carriage clock, then repeat without changing route.", &"", "")
	_register_beat(&"s04_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Sprawdź czytnik, szybę-zegar, potem odłóż czytnik do próby.", "HINT: Check the reader, the window clock, then stow the reader for the trial.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_04"
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
		"reader_buffer":
			observe_reader_repeat()
		"window_reflection":
			observe_wagon_clock()
		"bag_stash":
			repeat_reader_without_route_change()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func observe_reader_repeat() -> bool:
	if is_reader_repeat_observed or not _has(FACT_S01_TRACE):
		_record_feedback(&"sample_trace_required")
		return false
	is_reader_repeat_observed = true
	_record(FACT_READER, true)
	_report_progress(&"s04_reader_repeat_observed")
	if guidance_service:
		guidance_service.trigger_beat(&"s04_cache_hypothesis")
	queue_redraw()
	return true


func observe_wagon_clock() -> bool:
	if is_wagon_clock_observed or not is_reader_repeat_observed:
		_record_feedback(&"reader_required")
		return false
	is_wagon_clock_observed = true
	_record(FACT_CLOCK, true)
	_report_progress(&"s04_wagon_clock_observed")
	queue_redraw()
	return true


func repeat_reader_without_route_change() -> bool:
	if is_repeat_trial_completed:
		return false
	if not (is_reader_repeat_observed and is_wagon_clock_observed):
		_record_feedback(&"reader_or_clock_missing")
		return false
	is_repeat_trial_completed = true
	_record(FACT_RESULT, "repeat_persists_without_route_change")
	reader_trial_completed.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"reader_cache")
	_report_progress(&"s04_repeat_trial_completed")
	_unlock_exit()
	queue_redraw()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s04_" + value)


func unlock_turnstile() -> void:
	_unlock_exit()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	if turnstile_barrier:
		for child in turnstile_barrier.get_children():
			if child is CollisionShape2D:
				(child as CollisionShape2D).set_deferred("disabled", true)
		turnstile_barrier.position.y -= 80.0
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
		"reader_buffer": return is_reader_repeat_observed
		"window_reflection": return is_wagon_clock_observed
		"bag_stash": return is_repeat_trial_completed
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var reader_color := VectorStageStyle.CORRECTION_OXIDE if is_reader_repeat_observed else VectorStageStyle.HUMAN_AMBER
	var clock_color := VectorStageStyle.LIGHT_PLANE if is_wagon_clock_observed else VectorStageStyle.HUMAN_AMBER
	var trial_color := VectorStageStyle.ANCHOR_CYAN if is_repeat_trial_completed else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(Vector2(170.0, 242.0), Vector2(24.0, 16.0)), reader_color, false, 2.0)
	draw_line(Vector2(300.0, 246.0), Vector2(330.0, 246.0), clock_color, 3.0)
	draw_rect(Rect2(Vector2(420.0, 244.0), Vector2(24.0, 14.0)), trial_color, false, 2.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(500.0, 186.0), Vector2(500.0, 250.0), exit_color, 3.0)
