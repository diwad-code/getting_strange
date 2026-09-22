class_name Station14
extends Node2D

## Station 14 — S05, próg Marty.
## Marta aktywnie odkłada czajnik i nie wymusza bliskości; Lena podaje
## godzinę, sprzęt i położenie klucza, po czym prosi o niezależny opis dnia.

## PRZESZKODA — dlaczego to tu jest: Próg mieszkania dzieli dwie osoby o różnych historiach, a czajnik w ręku Marty pokazuje granicę gestu powitania.
## PRZESZKODA — czego wymaga od Leny: odłożenia torby, podania godziny, sprzętu i położenia klucza oraz prośby o niezależny opis dnia.
## PRZESZKODA — koszt porażki: prośba o opis bez trzech szczegółów zostawia informację o niekompletnych danych.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_RECALL := &"p7.marta_threshold.recall_requested"
const FACT_TIME := &"p7.marta_threshold.arrival_time_disclosed"
const FACT_EQUIPMENT := &"p7.marta_threshold.field_equipment_compared"
const FACT_KEY := &"p7.marta_threshold.key_position_verified"
const FACT_RESULT := &"p7.marta_threshold.independent_day_result"
const FACT_TRACE := &"p7.marta_threshold.trace"
const FACT_FEEDBACK := &"p7.marta_threshold.safe_trial_feedback"

signal clue_inspected(id: String, prop_type: int)
signal independent_day_compared()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_bag_placed := false
var is_arrival_time_disclosed := false
var is_field_equipment_compared := false
var is_key_position_verified := false
var is_independent_day_compared := false
var is_marta_threshold_respected := false
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
	_register_beat(&"s14_threshold_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s14_threshold_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Marta czeka na partnerkę. Nie udaję tej roli.", "Marta expects a partner. I will not play the role.", &"", "")
	_register_beat(&"s14_memory_gap_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Może brakuje mi pamięci. Porównamy szczegóły dnia.", "Maybe my memory is missing. We compare the day's details.", &"memory_gap", "ask_independent_day_description")
	_register_beat(&"s14_independent_day", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Podam godzinę, sprzęt i klucz, potem poproszę o jej opis dnia.", "Give time, gear, and key position, then ask for her description of today.", &"", "")
	_register_beat(&"s14_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Torba, czajnik, potem trzy szczegóły i pytanie o opis dnia.", "HINT: Bag, kettle, then three details and the day-description question.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_14"
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
		"field_bag", "door_threshold":
			place_bag_at_door()
		"tea_kettle", "mug_cabinet":
			disclose_arrival_time()
		"marta_interaction":
			ask_independent_day_description()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func place_bag_at_door() -> bool:
	if is_bag_placed or not _has(FACT_RECALL):
		_record_feedback(&"recall_required")
		return false
	is_bag_placed = true
	_record(&"p7.marta_threshold.bag_placed", true)
	_report_progress(&"s14_bag_placed")
	queue_redraw()
	return true


func disclose_arrival_time() -> bool:
	if is_arrival_time_disclosed:
		return false
	if not is_bag_placed:
		_record_feedback(&"bag_required")
		return false
	is_arrival_time_disclosed = true
	_record(FACT_TIME, "22:20_actual")
	_record(&"p7.marta_threshold.kettle_observed", true)
	_report_progress(&"s14_arrival_time_disclosed")
	queue_redraw()
	return true


func compare_field_equipment() -> bool:
	if is_field_equipment_compared or not is_arrival_time_disclosed:
		_record_feedback(&"time_required")
		return false
	is_field_equipment_compared = true
	_record(FACT_EQUIPMENT, true)
	_report_progress(&"s14_field_equipment_compared")
	queue_redraw()
	return true


func verify_key_position() -> bool:
	if is_key_position_verified or not is_field_equipment_compared:
		_record_feedback(&"equipment_required")
		return false
	is_key_position_verified = true
	_record(FACT_KEY, true)
	_report_progress(&"s14_key_position_verified")
	queue_redraw()
	return true


func ask_independent_day_description() -> bool:
	if is_independent_day_compared:
		return false
	if not (is_arrival_time_disclosed and is_field_equipment_compared and is_key_position_verified):
		_record_feedback(&"details_incomplete")
		return false
	is_independent_day_compared = true
	_record(FACT_RESULT, "independent_detail_conflicts")
	_respect_marta_threshold()
	independent_day_compared.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"memory_gap")
	_report_progress(&"s14_independent_day_compared")
	queue_redraw()
	return true


func _respect_marta_threshold() -> void:
	if is_marta_threshold_respected:
		return
	is_marta_threshold_respected = true
	_record(&"marta_relationship_disclosed", true)
	_record(&"p7.marta_threshold.marta_threshold", "relationship_difference_explicit")
	_record(FACT_TRACE, "relationship_difference_explicit")
	_report_progress(&"s14_marta_threshold_respected")
	_unlock_exit()


func respect_marta_threshold() -> bool:
	if not is_independent_day_compared:
		return false
	_respect_marta_threshold()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s14_" + value)


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
	return state != null and bool(state.decisions.get(key, false))


func _record(key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(key, value)


func _is_resolved(id: String) -> bool:
	match id:
		"field_bag", "door_threshold": return is_bag_placed
		"tea_kettle", "mug_cabinet": return is_arrival_time_disclosed
		"marta_interaction": return is_independent_day_compared
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var bag_color := VectorStageStyle.ANCHOR_CYAN if is_bag_placed else VectorStageStyle.HUMAN_AMBER
	var time_color := VectorStageStyle.LIGHT_PLANE if is_arrival_time_disclosed else VectorStageStyle.HUMAN_AMBER
	var equipment_color := VectorStageStyle.CORRECTION_OXIDE if is_field_equipment_compared else VectorStageStyle.HUMAN_AMBER
	var key_color := VectorStageStyle.ANCHOR_CYAN if is_key_position_verified else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(Vector2(110.0, 274.0), Vector2(24.0, 22.0)), bag_color, false, 1.0)
	draw_circle(Vector2(320.0, 260.0), 6.0, time_color, false, 2.0)
	draw_line(Vector2(206.0, 258.0), Vector2(248.0, 258.0), equipment_color, 3.0)
	draw_circle(Vector2(420.0, 250.0), 5.0, key_color, false, 2.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_color, 2.0)
