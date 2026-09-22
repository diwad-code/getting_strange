class_name Station11
extends Node2D

## Station 11 — S04, prywatny materiał i obcy adres.
## Komoda jest ciężarem R4; po odsunięciu Lena porównuje fotografię, zużycie
## sprzętu i ustawienie czytnika jako niezależne konteksty tego samego ciała.

## PRZESZKODA — dlaczego to tu jest: Komoda blokuje przedpokój, a zdjęcie, buty robocze i stacja czytnika opisują codzienność kogoś o podobnym ciele.
## PRZESZKODA — czego wymaga od Leny: odsunięcia komody i porównania trzech prywatnych śladów bez przywłaszczania rzeczy.
## PRZESZKODA — koszt porażki: porównanie bez odsunięcia mebla zostawia komunikat o zablokowanym przejściu.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const SIDEBOARD_CLEAR_X := 446.0
const FACT_KEY := &"p7.foreign_daily_life.key_trial_result"
const FACT_PHOTO := &"p7.foreign_daily_life.private_photograph_observed"
const FACT_WEAR := &"p7.foreign_daily_life.equipment_wear_observed"
const FACT_READER := &"p7.foreign_daily_life.reader_arrangement_observed"
const FACT_RESULT := &"p7.foreign_daily_life.private_material_result"
const FACT_RESPECT := &"p7.foreign_daily_life.private_material_respected"
const FACT_TRACE := &"p7.foreign_daily_life.trace"
const FACT_FEEDBACK := &"p7.foreign_daily_life.safe_trial_feedback"
const P9_CARD := &"p9.mystery.institution.card_presented"
const P9_RECORD := &"p9.mystery.institution.record_186_days_read"
const P9_REPORT := &"p9.mystery.institution.minimal_report_requested"
const P9_TRACE := &"p9.mystery.institution.trace"

signal clue_inspected(id: String, prop_type: int)
signal private_material_compared()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var hallway_sideboard: MovableAnchorableProp = $Geometry/HallwaySideboard
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_private_photograph_inspected := false
var is_equipment_wear_inspected := false
var is_reader_arrangement_inspected := false
var is_private_material_compared := false
var is_private_material_respected := false
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
	_register_beat(&"s11_photo_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s11_photo_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Fotografia zna Martę. Zużycie sprzętu zna ciało.", "The photograph knows Marta. The gear wear knows the body.", &"", "")
	_register_beat(&"s11_lost_relationship_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Mogę mieć lukę pamięci. Fotografia i czytnik to sprawdzą.", "I may have a memory gap. Photo and reader can test it.", &"lost_relationship", "compare_private_material_without_claiming")
	_register_beat(&"s11_private_material", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Porównam zdjęcie, zużycie i ustawienie czytnika jako niezależne źródła.", "Compare photo, wear, and reader arrangement as independent sources.", &"", "")
	_register_beat(&"s11_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Odsuń komodę, potem obejrzyj zdjęcie, buty i stację czytnika.", "HINT: Move the sideboard, then inspect photo, boots, and the reader dock.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_11"
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
	if is_instance_valid(player) and is_instance_valid(hallway_sideboard) and not hallway_sideboard.is_anchored:
		var diff := hallway_sideboard.global_position - player.global_position
		if absf(diff.x) < 46.0 and absf(diff.y) < hallway_sideboard.crate_size.y * 0.5 + 40.0:
			var push_direction := signf(player.velocity.x)
			if push_direction > 0.0 and signf(diff.x) == push_direction:
				hallway_sideboard.receive_push(push_direction)
	if not is_passage_clear and is_instance_valid(hallway_sideboard) and hallway_sideboard.position.x >= SIDEBOARD_CLEAR_X:
		is_passage_clear = true
		_report_progress(&"s11_passage_cleared")
		queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	match id:
		"identity_card":
			present_identity_card()
		"record_186_days":
			read_186_day_record()
		"minimal_report":
			request_minimal_report()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func inspect_private_photograph() -> bool:
	if is_private_photograph_inspected or not _has(FACT_KEY):
		_record_feedback(&"key_trial_required")
		return false
	if not is_passage_clear:
		_record_feedback(&"passage_required")
		return false
	is_private_photograph_inspected = true
	_record(FACT_PHOTO, true)
	_report_progress(&"s11_private_photograph_inspected")
	if guidance_service:
		guidance_service.trigger_beat(&"s11_lost_relationship_hypothesis")
	queue_redraw()
	return true


func inspect_equipment_wear() -> bool:
	if is_equipment_wear_inspected or not is_private_photograph_inspected:
		_record_feedback(&"photograph_required")
		return false
	is_equipment_wear_inspected = true
	_record(FACT_WEAR, true)
	_report_progress(&"s11_equipment_wear_inspected")
	queue_redraw()
	return true


func inspect_reader_arrangement() -> bool:
	if is_reader_arrangement_inspected or not is_equipment_wear_inspected:
		_record_feedback(&"equipment_wear_required")
		return false
	is_reader_arrangement_inspected = true
	_record(FACT_READER, true)
	_report_progress(&"s11_reader_arrangement_inspected")
	queue_redraw()
	return true


func compare_private_material() -> bool:
	if is_private_material_compared:
		return false
	if not (is_private_photograph_inspected and is_equipment_wear_inspected and is_reader_arrangement_inspected):
		_record_feedback(&"private_sources_missing")
		return false
	is_private_material_compared = true
	_record(FACT_RESULT, "life_matches_body_not_memory")
	record_private_material_result()
	private_material_compared.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"intruder")
		guidance_service.close_hypothesis(&"lost_relationship")
	_report_progress(&"s11_private_material_compared")
	queue_redraw()
	return true


func record_private_material_result() -> void:
	if is_private_material_respected:
		return
	is_private_material_respected = true
	_record(FACT_RESPECT, true)
	_record(FACT_TRACE, "foreign_address_and_photograph")
	if guidance_service:
		guidance_service.trigger_beat(&"s11_system_hint")
	_report_progress(&"s11_private_material_respected")
	_unlock_exit()


func respect_private_material() -> bool:
	if not is_private_material_compared:
		return false
	record_private_material_result()
	return true


func push_sideboard(direction: float) -> void:
	if hallway_sideboard != null:
		hallway_sideboard.receive_push(direction)


func apply_sideboard_setback() -> void:
	if is_passage_clear:
		return
	_record_feedback(&"sideboard_returned")
	if hallway_sideboard != null:
		hallway_sideboard.reset_to_spawn()
	if player != null:
		player.reset_to(Vector2(70.0, 296.0))
	queue_redraw()


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s11_" + value)


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
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
		"identity_card": return _decision_bool(P9_CARD)
		"record_186_days": return _decision_bool(P9_RECORD)
		"minimal_report": return _decision_bool(P9_REPORT)
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	draw_rect(Rect2(0, 0, 640, 360), Color("182028"))
	draw_rect(Rect2(0, 0, 640, 74), Color("ced5d4"))
	draw_rect(Rect2(0, 74, 640, 230), Color("9aa6a9"))
	draw_rect(Rect2(0, 304, 640, 24), Color("4f5b62"))
	for x in range(32, 610, 64):
		draw_rect(Rect2(x, 100, 30, 128), Color("5c6b72"))
		draw_rect(Rect2(x + 4, 106, 22, 34), Color("c9d5d4"))
	draw_rect(Rect2(232, 206, 176, 24), Color("314149"))
	draw_rect(Rect2(280, 230, 80, 74), Color("43555d"))
	draw_rect(Rect2(302, 250, 36, 14), Color("e0e9e6"))
	draw_line(Vector2(0, 294), Vector2(640, 294), Color("dce3df"), 2.0)
	draw_line(Vector2(0, 118), Vector2(640, 118), Color("dce3df"), 2.0)


func present_identity_card() -> bool:
	if _decision_bool(P9_CARD) or not _has(&"p9.mystery.marta.trace"):
		return false
	_record(P9_CARD, true)
	queue_redraw()
	return true

func read_186_day_record() -> bool:
	if _decision_bool(P9_RECORD) or not _decision_bool(P9_CARD):
		return false
	_record(P9_RECORD, true)
	queue_redraw()
	return true

func request_minimal_report() -> bool:
	if _decision_bool(P9_REPORT) or not _decision_bool(P9_RECORD):
		return false
	_record(P9_REPORT, true)
	_record(P9_TRACE, "biometric_history_186_days")
	_unlock_exit()
	queue_redraw()
	return true

func _decision_bool(key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	return state != null and state.decisions.get(key, false) == true
