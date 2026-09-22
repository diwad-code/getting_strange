class_name Station10
extends Node2D

## Station 10 — S04, zużycie klucza jako test materiału.
## Zamek rozpoznaje klucz bez oporu; Lena sprawdza zużycie i odstawia torbę,
## zanim przejdzie próg — nie przywłaszcza sobie biografii ani mieszkania.

## PRZESZKODA — dlaczego to tu jest: Zamek mieszkania nr 14 pasuje do klucza fizycznie, a tabliczka poniżej potwierdza numer, nie biografię.
## PRZESZKODA — czego wymaga od Leny: sprawdzenia zużycia klucza i obejrzenia tabliczki przed przekroczeniem progu.
## PRZESZKODA — koszt porażki: przekroczenie progu bez sprawdzenia zużycia tworzy informację o braku porównania materiału.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_NEIGHBOUR := &"p7.foreign_daily_life.neighbour_account"
const FACT_KEY_WEAR := &"p7.foreign_daily_life.key_wear_observed"
const FACT_KEY_TEST := &"p7.foreign_daily_life.key_trial_result"
const FACT_ENTRY := &"p7.foreign_daily_life.cautious_entry_committed"
const FACT_FEEDBACK := &"p7.foreign_daily_life.safe_trial_feedback"

signal clue_inspected(id: String, prop_type: int)
signal key_trial_completed()
signal cautious_entry_committed()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var apartment_door: AnimatableBody2D = $Geometry/ApartmentDoor14
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_key_wear_inspected := false
var is_key_trial_completed := false
var is_cautious_entry_committed := false
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
	_register_beat(&"s10_key_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s10_key_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Klucz pasuje. Zużycie powie więcej.", "The key fits. The wear will say more.", &"", "")
	_register_beat(&"s10_intruder_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Mogę być intruzem. Klucz i zużycie tego nie zmienią bez dalszych źródeł.", "I could be an intruder. Key and wear alone will not change that.", &"intruder", "test_key_wear_then_private_material")
	_register_beat(&"s10_key_wear", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Sprawdzę zużycie klucza i tabliczkę, zanim przejdę próg.", "Check key wear and the plate before crossing the threshold.", &"", "")
	_register_beat(&"s10_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Obejrzyj zużycie klucza, potem odstaw torbę przy drzwiach.", "HINT: Inspect key wear, then set the bag by the door.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_10"
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
		"lock_cylinder":
			inspect_key_wear()
		"door_number_plate":
			test_key_without_claiming_home()
		"field_bag":
			commit_cautious_entry()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func inspect_key_wear() -> bool:
	if is_key_wear_inspected or not _has(FACT_NEIGHBOUR):
		_record_feedback(&"neighbour_context_required")
		return false
	is_key_wear_inspected = true
	_record(FACT_KEY_WEAR, true)
	_report_progress(&"s10_key_wear_inspected")
	if guidance_service:
		guidance_service.trigger_beat(&"s10_intruder_hypothesis")
	queue_redraw()
	return true


func test_key_without_claiming_home() -> bool:
	if is_key_trial_completed or not is_key_wear_inspected:
		_record_feedback(&"key_wear_required")
		return false
	is_key_trial_completed = true
	_record(FACT_KEY_TEST, "key_matches_foreign_history")
	_record(&"local_address_confirmed", true)
	key_trial_completed.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"renumbering")
	_report_progress(&"s10_key_trial_completed")
	queue_redraw()
	return true


func commit_cautious_entry() -> bool:
	if is_cautious_entry_committed:
		return false
	if not is_key_trial_completed:
		_record_feedback(&"key_trial_required")
		return false
	is_cautious_entry_committed = true
	_record(FACT_ENTRY, true)
	cautious_entry_committed.emit()
	_report_progress(&"s10_cautious_entry_committed")
	_unlock_exit()
	queue_redraw()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s10_" + value)


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	if apartment_door:
		ExitClearance._disable_shapes(apartment_door)
		apartment_door.position.y = 170.0
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
		"lock_cylinder": return is_key_wear_inspected
		"door_number_plate": return is_key_trial_completed
		"field_bag": return is_cautious_entry_committed
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var wear_color := VectorStageStyle.CORRECTION_OXIDE if is_key_wear_inspected else VectorStageStyle.HUMAN_AMBER
	var key_color := VectorStageStyle.ANCHOR_CYAN if is_key_trial_completed else VectorStageStyle.HUMAN_AMBER
	var entry_color := VectorStageStyle.LIGHT_PLANE if is_cautious_entry_committed else VectorStageStyle.HUMAN_AMBER
	draw_circle(Vector2(444.0, 240.0), 6.0, wear_color, false, 2.0)
	draw_rect(Rect2(Vector2(424.0, 186.0), Vector2(28.0, 18.0)), key_color, false, 1.0)
	draw_rect(Rect2(Vector2(352.0, 286.0), Vector2(26.0, 16.0)), entry_color, false, 1.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(476.0, 170.0), Vector2(476.0, 300.0), exit_color, 2.0)
