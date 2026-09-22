class_name Station09
extends Node2D

## Station 09 — S04, źródło numeracji i nieprowadzące pytanie.
## Donica jest ciężarem R4 w rzeczywistej klatce schodowej; po odsunięciu Lena
## pyta sąsiadkę o numer 12 bez podawania własnej teorii.

## PRZESZKODA — dlaczego to tu jest: Klatka zachowuje własną tabliczkę piętra, a donica wróciła z remontu i zablokowała zwykłe przejście.
## PRZESZKODA — czego wymaga od Leny: przesunięcia ciężkiej donicy i zapytania sąsiadki o numer 12 bez podawania własnej teorii.
## PRZESZKODA — koszt porażki: pytanie przed oczyszczeniem przejścia i odczytem tabliczki zostawia informację o brakującym źródle.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const PLANTER_CLEAR_X := 300.0
const FACT_S03_TRACE := &"p7.address_and_record.trace"
const FACT_FLOOR := &"p7.foreign_daily_life.floor_record_observed"
const FACT_NEIGHBOUR := &"p7.foreign_daily_life.neighbour_account"
const FACT_FEEDBACK := &"p7.foreign_daily_life.safe_trial_feedback"

signal clue_inspected(id: String, prop_type: int)
signal neighbour_answered()
signal passage_cleared()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var stairwell_planter: MovableAnchorableProp = $Geometry/StairwellPlanter
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_floor_record_observed := false
var is_neighbour_answered := false
var is_passage_clear := false
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
	_register_beat(&"s09_floor_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s09_floor_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Tabliczka i sąsiadka są po drugiej stronie donicy.", "The plate and neighbour are beyond the planter.", &"", "")
	_register_beat(&"s09_renumbering_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Może zmienili numery. Zapytam tylko o dwunastkę.", "Maybe the numbers changed. I will ask only about twelve.", &"renumbering", "ask_neighbour_without_leading")
	_register_beat(&"s09_neighbour_question", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Odsunę donicę, przeczytam piętro i zapytam o numer bez sugestii.", "Move the planter, read the floor, then ask the number without suggesting it.", &"", "")
	_register_beat(&"s09_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Przesuń donicę pieszo, przeczytaj tabliczkę i zapytaj sąsiadkę o 12.", "HINT: Push the planter on foot, read the plate, and ask the neighbour about 12.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_09"
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


func _physics_process(_delta: float) -> void:
	if is_instance_valid(player) and is_instance_valid(stairwell_planter) and not stairwell_planter.is_anchored:
		var diff := stairwell_planter.global_position - player.global_position
		if absf(diff.x) < 42.0 and absf(diff.y) < stairwell_planter.crate_size.y * 0.5 + 40.0:
			var push_direction := signf(player.velocity.x)
			if push_direction > 0.0 and signf(diff.x) == push_direction:
				stairwell_planter.receive_push(push_direction)
	if not is_passage_clear and is_instance_valid(stairwell_planter) and stairwell_planter.position.x >= PLANTER_CLEAR_X:
		is_passage_clear = true
		passage_cleared.emit()
		_report_progress(&"s09_passage_cleared")
		queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	match id:
		"floor_plate":
			observe_floor_record()
		"neighbour_dialogue":
			ask_neighbour_without_leading()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func observe_floor_record() -> bool:
	if is_floor_record_observed or not _has(FACT_S03_TRACE):
		_record_feedback(&"identifier_trace_required")
		return false
	is_floor_record_observed = true
	_record(FACT_FLOOR, true)
	_report_progress(&"s09_floor_record_observed")
	queue_redraw()
	return true


func ask_neighbour_without_leading() -> bool:
	if is_neighbour_answered:
		return false
	if not is_floor_record_observed:
		_record_feedback(&"floor_record_required")
		return false
	if not is_passage_clear:
		_record_feedback(&"passage_required")
		return false
	is_neighbour_answered = true
	_record(FACT_NEIGHBOUR, "twelve_lower_fourteen_home")
	neighbour_answered.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"renumbering")
	_report_progress(&"s09_neighbour_answered")
	_unlock_exit()
	queue_redraw()
	return true


func push_planter(direction: float) -> void:
	if stairwell_planter != null:
		stairwell_planter.receive_push(direction)


func apply_planter_setback() -> void:
	if is_passage_clear:
		return
	_record_feedback(&"planter_returned_to_step")
	if stairwell_planter != null:
		stairwell_planter.reset_to_spawn()
	if player != null:
		player.reset_to(Vector2(70.0, 296.0))
	queue_redraw()


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s09_" + value)


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
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
		"floor_plate": return is_floor_record_observed
		"neighbour_dialogue": return is_neighbour_answered
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var floor_color := VectorStageStyle.LIGHT_PLANE if is_floor_record_observed else VectorStageStyle.HUMAN_AMBER
	var neighbour_color := VectorStageStyle.ANCHOR_CYAN if is_neighbour_answered else VectorStageStyle.HUMAN_AMBER
	var planter_color := VectorStageStyle.CORRECTION_OXIDE if not is_passage_clear else VectorStageStyle.LIGHT_PLANE
	draw_rect(Rect2(Vector2(196.0, 196.0), Vector2(30.0, 16.0)), floor_color, false, 1.0)
	draw_circle(Vector2(330.0, 255.0), 10.0, neighbour_color, false, 2.0)
	draw_line(Vector2(238.0, 294.0), Vector2(286.0, 294.0), planter_color, 3.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(566.0, 180.0), Vector2(566.0, 296.0), exit_color, 2.0)
