class_name Station07
extends Node2D

## Station 07 — S03, pytanie o ostatnią wizytę.
## Kiosk działa jak kiosk. Lena pyta bez podawania teorii i sprawdza odpowiedź
## księgą sprzedaży; schody i sklep pozostają zwykłą infrastrukturą.

## PRZESZKODA — dlaczego to tu jest: Kiosk prowadzi księgę sprzedaży, w której widać, czy imię pochodzi z karty, czy z prawdziwej wizyty.
## PRZESZKODA — czego wymaga od Leny: zadania pytania o poprzednią wizytę i porównania odpowiedzi z wpisem w księdze.
## PRZESZKODA — koszt porażki: zakup bez pytania i porównania zostawia informację o brakującym źródle osoby.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_ROUTE := &"p7.address_and_record.public_route_result"
const FACT_QUESTION := &"p7.address_and_record.shopkeeper_question_asked"
const FACT_ANSWER := &"p7.address_and_record.shopkeeper_answer"
const FACT_COMMITMENT := &"p7.address_and_record.ordinary_explanation_retained"
const FACT_FEEDBACK := &"p7.address_and_record.safe_trial_feedback"

signal clue_inspected(id: String, prop_type: int)
signal shopkeeper_answered()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_shopkeeper_question_asked := false
var is_sale_ledger_inspected := false
var is_ordinary_explanation_retained := false
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
	_register_beat(&"s07_shop_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s07_shop_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Sprzedawca zna imię. Zapytam o poprzednią wizytę.", "The shopkeeper knows my name. I will ask about the prior visit.", &"", "")
	_register_beat(&"s07_card_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Może zobaczył imię na karcie. Wpis sprzedaży to sprawdzi.", "Maybe he saw the name on a card. The sales entry can test it.", &"record_assigned_elsewhere", "ask_then_compare_sales_entry")
	_register_beat(&"s07_shopkeeper_question", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zapytam, kiedy widział Lenę, i porównam odpowiedź z wpisem.", "I will ask when he saw Lena and compare the answer with the entry.", &"", "")
	_register_beat(&"s07_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Zapytaj sprzedawcę, obejrzyj księgę, potem odłóż czytnikową teorię na później.", "HINT: Ask the shopkeeper, inspect the ledger, then defer the reader theory.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_07"
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
		"shop_counter":
			ask_shopkeeper_recent_visit()
		"sales_ledger":
			inspect_sale_ledger()
		"water_bottle":
			commit_ordinary_explanation()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func ask_shopkeeper_recent_visit() -> bool:
	if is_shopkeeper_question_asked or not _has(FACT_ROUTE):
		_record_feedback(&"public_route_required")
		return false
	is_shopkeeper_question_asked = true
	_record(FACT_QUESTION, true)
	_report_progress(&"s07_shopkeeper_question_asked")
	if guidance_service:
		guidance_service.trigger_beat(&"s07_card_hypothesis")
	queue_redraw()
	return true


func inspect_sale_ledger() -> bool:
	if is_sale_ledger_inspected or not is_shopkeeper_question_asked:
		_record_feedback(&"question_required")
		return false
	is_sale_ledger_inspected = true
	_record(FACT_ANSWER, "yesterday_purchase")
	shopkeeper_answered.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"record_assigned_elsewhere")
	_report_progress(&"s07_sale_ledger_inspected")
	queue_redraw()
	return true


func commit_ordinary_explanation() -> bool:
	if is_ordinary_explanation_retained:
		return false
	if not is_sale_ledger_inspected:
		_record_feedback(&"ledger_required")
		return false
	is_ordinary_explanation_retained = true
	_record(FACT_COMMITMENT, true)
	_report_progress(&"s07_ordinary_explanation_retained")
	_unlock_exit()
	queue_redraw()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s07_" + value)


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
		"shop_counter": return is_shopkeeper_question_asked
		"sales_ledger": return is_sale_ledger_inspected
		"water_bottle": return is_ordinary_explanation_retained
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var question_color := VectorStageStyle.LIGHT_PLANE if is_shopkeeper_question_asked else VectorStageStyle.HUMAN_AMBER
	var ledger_color := VectorStageStyle.CORRECTION_OXIDE if is_sale_ledger_inspected else VectorStageStyle.HUMAN_AMBER
	var commitment_color := VectorStageStyle.ANCHOR_CYAN if is_ordinary_explanation_retained else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(150.0, 250.0), Vector2(190.0, 250.0), question_color, 3.0)
	draw_rect(Rect2(Vector2(280.0, 242.0), Vector2(22.0, 16.0)), ledger_color, false, 2.0)
	draw_circle(Vector2(410.0, 250.0), 8.0, commitment_color, false, 2.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(530.0, 180.0), Vector2(530.0, 310.0), exit_color, 2.0)
