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
const P9_HOME_TASK := &"p9.mystery.marta.home_task_complete"
const P9_DAY := &"p9.mystery.marta.independent_day_heard"
const P9_BOUNDARY := &"p9.mystery.marta.boundary_accepted"
const P9_TRACE := &"p9.mystery.marta.trace"

## PKG-0191 — canonical CAMPAIGN_MAP facts, written alongside the P9 detail
## keys above at the same semantic action. `marta_relationship_disclosed` is
## intentionally NOT written here: the audited current writer is
## `station_08.gd` (`speak_with_neighbour()`), verified against source before
## this package, and is not duplicated to keep one writer per fact.
const CANON_MEMORIES_CONFLICT := &"marta_memories_conflict"
const CANON_BOUNDARY_ACCEPTED := &"marta_boundary_accepted"

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
		"home_task":
			perform_home_task()
		"marta_day":
			hear_marta_day()
		"marta_boundary":
			accept_marta_boundary()
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
	pass  # PKG-0174: ThresholdZone requires interact


func _complete_if_player_already_in_airlock() -> void:
	if airlock_zone != null and player != null and airlock_zone.overlaps_body(player):
		_trigger_level_completion()


func _on_airlock_body_entered(_body: Node2D) -> void:
	# PKG-0174: AirlockZone is a closure zone, not a trigger.
	pass


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
		"home_task": return _decision_bool(P9_HOME_TASK)
		"marta_day": return _decision_bool(P9_DAY)
		"marta_boundary": return _decision_bool(P9_BOUNDARY)
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	# PKG-0187 visual-family repair: a low, inhabited room, not an empty beige
	# stage. The existing three interaction points and all collision stay put.
	VectorStageStyle.draw_stage_apron(self, Vector2(640.0, 360.0))
	VectorStageStyle.draw_play_plane(self, geometry)
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), Color("241f25"))
	# Low ceiling: the room closes above Lena instead of reading as an office.
	draw_rect(Rect2(0.0, 0.0, 640.0, 158.0), Color("332b32"))
	draw_rect(Rect2(0.0, 150.0, 640.0, 10.0), Color("5a4850"))
	draw_line(Vector2(0.0, 158.0), Vector2(640.0, 158.0), Color("9d7c70"), 1.0)
	draw_rect(Rect2(0.0, 160.0, 640.0, 144.0), Color("735c59"))
	# Window, curtain and sill: the outside remains one cold, quiet plane.
	draw_rect(Rect2(70.0, 178.0, 130.0, 84.0), Color("332f35"))
	draw_rect(Rect2(76.0, 184.0, 118.0, 66.0), Color("70838a"))
	draw_line(Vector2(135.0, 184.0), Vector2(135.0, 250.0), Color("b5c4c0"), 1.0)
	draw_line(Vector2(76.0, 216.0), Vector2(194.0, 216.0), Color("b5c4c0"), 1.0)
	draw_rect(Rect2(64.0, 174.0, 12.0, 92.0), Color("6b4857"))
	draw_rect(Rect2(194.0, 174.0, 12.0, 92.0), Color("6b4857"))
	draw_rect(Rect2(64.0, 258.0, 148.0, 8.0), Color("493a3a"))
	# Two-person domestic evidence: sofa, shared table, a lamp and a field bag.
	draw_rect(Rect2(84.0, 250.0, 126.0, 26.0), Color("514149"))
	draw_rect(Rect2(94.0, 236.0, 102.0, 20.0), Color("65525a"))
	draw_line(Vector2(94.0, 256.0), Vector2(196.0, 256.0), Color("b99476"), 1.0)
	draw_rect(Rect2(242.0, 258.0, 112.0, 12.0), Color("493936"))
	draw_line(Vector2(260.0, 270.0), Vector2(252.0, 304.0), Color("493936"), 3.0)
	draw_line(Vector2(336.0, 270.0), Vector2(344.0, 304.0), Color("493936"), 3.0)
	draw_rect(Rect2(272.0, 246.0, 16.0, 12.0), Color("d3d0c5"))
	draw_rect(Rect2(308.0, 246.0, 16.0, 12.0), Color("b7d1d0"))
	draw_line(Vector2(230.0, 186.0), Vector2(230.0, 250.0), Color("cda06f"), 2.0)
	draw_circle(Vector2(230.0, 180.0), 13.0, Color("e4bd82"))
	draw_colored_polygon(PackedVector2Array([
		Vector2(210.0, 194.0), Vector2(250.0, 194.0), Vector2(270.0, 246.0), Vector2(190.0, 246.0),
	]), Color(Color("e4bd82"), 0.12))
	# Marta's place is materially distinct from Lena's work kit, while her rig
	# remains the only human body drawn in the room.
	draw_rect(Rect2(374.0, 210.0, 114.0, 64.0), Color("4f4140"))
	draw_rect(Rect2(382.0, 218.0, 98.0, 50.0), Color("292932"))
	for book_x in [392.0, 408.0, 442.0, 458.0]:
		draw_rect(Rect2(book_x, 236.0, 10.0, 26.0), Color("b48d6b"))
	draw_rect(Rect2(510.0, 236.0, 42.0, 50.0), Color("44383b"))
	draw_rect(Rect2(516.0, 242.0, 30.0, 38.0), Color("d3d0c5"))
	draw_rect(Rect2(0.0, 304.0, 640.0, 56.0), Color("3e3337"))
	draw_line(Vector2(0.0, 304.0), Vector2(640.0, 304.0), Color("aa8f83"), 2.0)


func perform_home_task() -> bool:
	if _decision_bool(P9_HOME_TASK) or not _has(&"p9.mystery.home.trace"):
		return false
	_record(P9_HOME_TASK, true)
	queue_redraw()
	return true

func hear_marta_day() -> bool:
	if _decision_bool(P9_DAY) or not _decision_bool(P9_HOME_TASK):
		return false
	_record(P9_DAY, true)
	# PKG-0191: hearing Marta's independent version of the shared outing is the
	# material action that surfaces an unguessable, conflicting detail.
	_record(CANON_MEMORIES_CONFLICT, true)
	queue_redraw()
	return true

func accept_marta_boundary() -> bool:
	if _decision_bool(P9_BOUNDARY) or not _decision_bool(P9_DAY):
		return false
	_record(P9_BOUNDARY, true)
	_record(P9_TRACE, "independent_day_with_boundary")
	# PKG-0191: canonical CAMPAIGN_MAP fact for accepting Marta's boundary.
	_record(CANON_BOUNDARY_ACCEPTED, true)
	_unlock_exit()
	queue_redraw()
	return true

func _decision_bool(key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	return state != null and state.decisions.get(key, false) == true
