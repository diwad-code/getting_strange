class_name Station15
extends Node2D

## Station 15 — S06, ta sama wyprawa i dwa skutki.
## Lena czyta własne notatki terenowe, porównuje dwa konkrety wyprawy, widzi
## jak Marta zabezpiecza telefon, i zamiast przekonywać ją słowem prosi o
## własny zapis pracy w biurze pomiarowym.

## PRZESZKODA — dlaczego to tu jest: Kuchenny blat i wąskie przejście między stołem a szafką zajmuje otwarty laptop oraz apteczka przygotowana przez Martę.
## PRZESZKODA — czego wymaga od Leny: odczytania notatek terenowych, porównania dwóch konkretów wyprawy i spokojnego ominięcia stołu bez odbierania zabezpieczanego telefonu.
## PRZESZKODA — koszt porażki: prośba o zapis pracy bez dwóch porównanych konkretów zostawia informację o niekompletnym materiale i nie otwiera drogi do biura.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const REQUIRED_DETAIL_COUNT := 2

const FACT_S05_TRACE := &"p7.marta_threshold.trace"
const FACT_NOTES := &"p7.work_history_and_record.expedition_notes_observed"
const FACT_DETAIL := &"p7.work_history_and_record.expedition_detail_compared"
const FACT_PHONE := &"p7.work_history_and_record.phone_secured_by_marta"
const FACT_REQUEST := &"p7.work_history_and_record.own_record_requested"
const FACT_FEEDBACK := &"p7.work_history_and_record.safe_trial_feedback"

signal clue_inspected(id: String, prop_type: int)
signal expedition_detail_compared()
signal own_record_requested()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_notes_observed := false
var is_rain_detail_compared := false
var is_fence_detail_compared := false
var are_details_compared := false
var is_phone_secured_by_marta := false
var is_own_record_requested := false
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
	_register_beat(&"s15_trip_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s15_trip_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Jedna wyprawa. Dwa różne skutki po deszczu.", "One expedition. Two different outcomes after the rain.", &"", "")
	_register_beat(&"s15_memory_manipulation_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Ktoś mógł przestawić moją pamięć. Długi zapis pracy to sprawdzi.", "Someone could have shifted my memory. A long work record tests that.", &"memory_manipulation", "request_own_work_record")
	_register_beat(&"s15_own_work_record", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Porównam dwa konkrety wyprawy, potem poproszę o własny zapis pracy.", "Compare two details of the trip, then ask for my own work record.", &"", "request_own_work_record")
	_register_beat(&"s15_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Notatki, dwa konkrety wyprawy, apteczka.", "HINT: The notes, two trip details, the first-aid kit.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_15"
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
		"expedition_notes":
			observe_expedition_notes()
		"kitchen_table":
			compare_rain_detail()
		"counter_cloth":
			compare_fence_detail()
		"marta_dialogue":
			observe_secured_phone()
		"first_aid_kit":
			request_own_work_record()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func observe_expedition_notes() -> bool:
	if is_notes_observed:
		return false
	if not _has(FACT_S05_TRACE):
		_record_feedback(&"relationship_difference_required")
		return false
	is_notes_observed = true
	_record(FACT_NOTES, true)
	if guidance_service:
		guidance_service.trigger_beat(&"s15_trip_contact")
	_report_progress(&"s15_notes_observed")
	queue_redraw()
	return true


func compare_rain_detail() -> bool:
	if is_rain_detail_compared:
		return false
	if not is_notes_observed:
		_record_feedback(&"notes_required")
		return false
	is_rain_detail_compared = true
	_record(&"p7.work_history_and_record.rain_detail_compared", "returned_versus_parted")
	_report_progress(&"s15_rain_detail_compared")
	queue_redraw()
	return true


func compare_fence_detail() -> bool:
	if is_fence_detail_compared:
		return false
	if not is_notes_observed:
		_record_feedback(&"notes_required")
		return false
	is_fence_detail_compared = true
	_record(&"p7.work_history_and_record.fence_detail_compared", "damaged_versus_intact")
	_report_progress(&"s15_fence_detail_compared")
	queue_redraw()
	return true


func observe_secured_phone() -> bool:
	if is_phone_secured_by_marta:
		return false
	if not is_notes_observed:
		_record_feedback(&"notes_required")
		return false
	is_phone_secured_by_marta = true
	_record(FACT_PHONE, true)
	if guidance_service:
		guidance_service.trigger_beat(&"s15_memory_manipulation_hypothesis")
	_report_progress(&"s15_phone_secured_observed")
	queue_redraw()
	return true


func request_own_work_record() -> bool:
	if is_own_record_requested:
		return false
	if _compared_detail_count() < REQUIRED_DETAIL_COUNT:
		_record_feedback(&"expedition_details_incomplete")
		return false
	are_details_compared = true
	is_own_record_requested = true
	_record(FACT_DETAIL, "same_trip_two_outcomes")
	_record(FACT_REQUEST, true)
	_record(&"marta_memories_conflict", true)
	expedition_detail_compared.emit()
	own_record_requested.emit()
	if guidance_service:
		guidance_service.trigger_beat(&"s15_own_work_record")
	_report_progress(&"s15_own_record_requested")
	_unlock_exit()
	queue_redraw()
	return true


func _compared_detail_count() -> int:
	var count := 0
	if is_rain_detail_compared:
		count += 1
	if is_fence_detail_compared:
		count += 1
	return count


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s15_" + value)


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
		"expedition_notes": return is_notes_observed
		"kitchen_table": return is_rain_detail_compared
		"counter_cloth": return is_fence_detail_compared
		"marta_dialogue": return is_phone_secured_by_marta
		"first_aid_kit": return is_own_record_requested
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var notes_color := VectorStageStyle.ANCHOR_CYAN if is_notes_observed else VectorStageStyle.HUMAN_AMBER
	var rain_color := VectorStageStyle.LIGHT_PLANE if is_rain_detail_compared else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.6)
	var fence_color := VectorStageStyle.CORRECTION_OXIDE if is_fence_detail_compared else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.5)
	var phone_color := VectorStageStyle.SEAM_RED if is_phone_secured_by_marta else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(Vector2(138.0, 246.0), Vector2(26.0, 14.0)), notes_color, false, 1.0)
	draw_line(Vector2(276.0, 258.0), Vector2(306.0, 258.0), rain_color, 3.0)
	draw_line(Vector2(336.0, 258.0), Vector2(366.0, 258.0), fence_color, 3.0)
	draw_circle(Vector2(490.0, 250.0), 5.0, phone_color, false, 2.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_color, 2.0)
