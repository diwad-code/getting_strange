class_name Station06
extends Node2D

## Station 06 — Kiosk contradiction (Rodzina 1: Zewnętrzna / Miejska / Publiczna).
## Pierwsza publiczna rozbieżność przez człowieka: sprzedawca w kiosku i wydrukowany
## rozkład podają inne fakty niż pamięć Leny, lecz sprzedawca ma własną pracę i nie zna żadnej tajemnicy.
##
## PRZESZKODA — dlaczego to tu jest: Kiosk i tablica rozkładu obsługują pasażerów i mieszkańców osiedla, a zakup i porównanie godzin wymagają kontaktu z publicznym źródłem.
## PRZESZKODA — czego wymaga od Leny: sprawdzenia wydrukowanego rozkładu, zakupu wody i zadania pytania kontrolnego o Martę.
## PRZESZKODA — koszt porażki: przejście obok kiosku bez rozmowy zostawia rozbieżność w sferze domysłów bez weryfikacji u osoby postronnej.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_PAPER := &"p7.address_and_record.paper_route_observed"
const FACT_OFFLINE := &"p7.address_and_record.offline_route_observed"
const FACT_RESULT := &"p7.address_and_record.public_route_result"
const FACT_QUESTION := &"p7.address_and_record.shopkeeper_question_asked"
const FACT_ANSWER := &"p7.address_and_record.shopkeeper_answer"
const FACT_FEEDBACK := &"p7.address_and_record.safe_trial_feedback"

signal timetable_inspected()
signal water_purchased()
signal kiosk_vendor_asked()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var return_zone: Area2D = $ReturnZone
@onready var dialogue: CRTDialogueBox = $CRTDialogueBox
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_timetable_inspected := false
var is_water_purchased := false
var is_kiosk_vendor_asked := false
var is_exit_unlocked := false
var is_level_completed := false


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_action_points()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	if return_zone != null and not return_zone.body_entered.is_connected(_on_return_zone_body_entered):
		return_zone.body_entered.connect(_on_return_zone_body_entered)
	_set_action_available(&"buy_water_at_kiosk", false)
	_set_action_available(&"ask_kiosk_vendor", false)
	queue_redraw()


func _connect_action_points() -> void:
	for child in props.get_children():
		if child is OpeningActionPoint:
			var action := child as OpeningActionPoint
			if not action.action_requested.is_connected(_on_action_requested):
				action.action_requested.connect(_on_action_requested)


func _on_action_requested(action_id: StringName) -> void:
	match action_id:
		&"inspect_street_timetable":
			inspect_street_timetable()
		&"buy_water_at_kiosk":
			buy_water_at_kiosk()
		&"ask_kiosk_vendor":
			ask_kiosk_vendor()


func inspect_street_timetable() -> bool:
	if is_timetable_inspected:
		return false
	is_timetable_inspected = true
	_record(FACT_PAPER, true)
	_record(&"p9.kiosk.timetable_contradiction_seen", true)
	_resolve_action(&"inspect_street_timetable")
	_set_action_available(&"buy_water_at_kiosk", true)
	timetable_inspected.emit()
	_present([
		{"speaker": "LENA", "text": "Rozkład z tego miesiąca. Trasa Linii 4 omija Sadową 12, przystanek przeniesiono pod 14."},
	])
	queue_redraw()
	return true


func buy_water_at_kiosk() -> bool:
	if not is_timetable_inspected or is_water_purchased:
		_record_feedback(&"timetable_check_required")
		return false
	is_water_purchased = true
	_record(FACT_OFFLINE, true)
	_record(&"p9.kiosk.water_purchased", true)
	_resolve_action(&"buy_water_at_kiosk")
	_set_action_available(&"ask_kiosk_vendor", true)
	water_purchased.emit()
	_present([
		{"speaker": "LENA", "text": "Proszę butelkę wody."},
		{"speaker": "SPRZEDAWCA", "text": "Dobry wieczór, pani Leno. Niegazowana jak zawsze. Proszę, cztery złote."},
	])
	queue_redraw()
	return true


func ask_kiosk_vendor() -> bool:
	if not is_water_purchased or is_kiosk_vendor_asked:
		_record_feedback(&"purchase_required")
		return false
	is_kiosk_vendor_asked = true
	_record(FACT_RESULT, "paper_matches_vehicle")
	_record(FACT_QUESTION, true)
	_record(FACT_ANSWER, "yesterday_purchase")
	_record(&"unease_pattern_started", true)
	_record(&"p9.kiosk.vendor_testimony_recorded", true)
	_resolve_action(&"ask_kiosk_vendor")
	kiosk_vendor_asked.emit()
	_present([
		{"speaker": "SPRZEDAWCA", "text": "Marta rano pytała, o której pani wraca na Sadową 14."},
		{"speaker": "LENA", "text": "Na Sadową 14? Przecież mieszkam pod dwunastką."},
		{"speaker": "SPRZEDAWCA", "text": "Od lat pod czternastką na pierwszym piętrze. Przecież widzę, jak panie razem wychodzą."},
	])
	_unlock_exit()
	queue_redraw()
	return true


## Backward compatibility for PKG-0146 early diagnostic tests
func observe_paper_timetable() -> bool:
	return inspect_street_timetable()


func observe_offline_route() -> bool:
	if not is_timetable_inspected:
		inspect_street_timetable()
	return buy_water_at_kiosk()


func compare_public_route() -> bool:
	if not is_water_purchased:
		buy_water_at_kiosk()
	return ask_kiosk_vendor()


func unlock_exit_for_return() -> void:
	_unlock_exit()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	pass  # PKG-0174: ThresholdZone requires interact


func _complete_if_player_already_in_airlock() -> void:
	if airlock_zone != null and player != null and airlock_zone.overlaps_body(player):
		_trigger_level_completion()


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s06_composition", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s06_reaction", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Sprzedawca wita mnie po imieniu. Zapytam o rozkład.", "The shopkeeper greets me by name. I will ask about the schedule.", &"", "")
	_register_beat(&"s06_thought", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Rozkład podaje inny przystanek niż pamiętam. Zapytam sprzedawcę.", "The schedule lists a different stop than I remember. I will ask the vendor.", &"kiosk_schedule", "buy_water_at_kiosk")
	_register_beat(&"s06_cache_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Błąd w druku albo stara tabliczka. Zawsze najpierw szuka się bałaganu w papierach.", "Misprint or an old plate. You always look for paper chaos first.", &"kiosk_schedule", "buy_water_at_kiosk")
	_register_beat(&"s06_intent", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Sprawdzę rozkład, kupię wodę i zadam pytanie o Martę.", "I will check the schedule, buy water, and ask about Marta.", &"", "")
	_register_beat(&"s06_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Obejrzyj rozkład, zrób zakup w kiosku i porozmawiaj ze sprzedawcą.", "HINT: Read the schedule, purchase water at the kiosk, and talk with the vendor.", &"", "")


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


func _on_airlock_body_entered(_body: Node2D) -> void:
	# PKG-0174: AirlockZone is a closure zone, not a trigger.
	pass


func _on_return_zone_body_entered(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		previous_level_requested.emit()


func _trigger_level_completion() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))


func _record(key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(key, value)


func _resolve_action(action_id: StringName) -> void:
	var action := _find_action(action_id)
	if action != null:
		action.resolve()


func _set_action_available(action_id: StringName, available: bool) -> void:
	var action := _find_action(action_id)
	if action != null:
		action.set_available(available)


func _find_action(action_id: StringName) -> OpeningActionPoint:
	for child in props.get_children():
		if child is OpeningActionPoint and (child as OpeningActionPoint).action_id == action_id:
			return child as OpeningActionPoint
	return null


func _present(lines: Array) -> void:
	if dialogue != null:
		dialogue.present(lines)


func _draw() -> void:
	VectorStageStyle.draw_stage_apron(self, Vector2(640.0, 360.0))
	# Open sky: ≥ 25% height (y: 0 to 110 px), no ceiling!
	draw_rect(Rect2(0.0, 0.0, 640.0, 110.0), VectorStageStyle.INK)
	# Distant rooftops and night horizon
	draw_colored_polygon(PackedVector2Array([
		Vector2(0.0, 110.0), Vector2(100.0, 90.0), Vector2(240.0, 80.0),
		Vector2(420.0, 95.0), Vector2(560.0, 85.0), Vector2(640.0, 90.0),
		Vector2(640.0, 110.0),
	]), VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.40))
	# Mid plane: Street facade behind the kiosk
	draw_rect(Rect2(0.0, 110.0, 640.0, 196.0), VectorStageStyle.DEEP_PLANE)
	# Timetable stand at x=150
	var timetable_color := VectorStageStyle.ANCHOR_CYAN if is_timetable_inspected else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(150.0, 306.0), Vector2(150.0, 180.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	draw_rect(Rect2(126.0, 170.0, 48.0, 36.0), VectorStageStyle.INK)
	draw_rect(Rect2(126.0, 170.0, 48.0, 36.0), timetable_color, false, 1.5)
	draw_line(Vector2(132.0, 182.0), Vector2(168.0, 182.0), timetable_color, 1.0)
	draw_line(Vector2(132.0, 192.0), Vector2(168.0, 192.0), timetable_color, 1.0)
	# Kiosk pavilion structure (x=280..490, y=140..306)
	draw_colored_polygon(PackedVector2Array([
		Vector2(270.0, 148.0), Vector2(500.0, 140.0), Vector2(490.0, 306.0), Vector2(280.0, 306.0),
	]), VectorStageStyle.MID_PLANE)
	# Kiosk canopy / roof
	draw_colored_polygon(PackedVector2Array([
		Vector2(255.0, 148.0), Vector2(515.0, 140.0), Vector2(510.0, 160.0), Vector2(260.0, 168.0),
	]), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.35))
	# Kiosk serving window (x=310..460, y=180..260)
	draw_rect(Rect2(310.0, 180.0, 150.0, 80.0), VectorStageStyle.INK)
	var window_color := VectorStageStyle.ANCHOR_CYAN if is_water_purchased else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(310.0, 180.0, 150.0, 80.0), window_color, false, 1.5)
	# Newspaper rack & bottle display
	for nx in [320.0, 340.0, 360.0, 380.0]:
		draw_rect(Rect2(nx, 220.0, 14.0, 20.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.40), false, 1.0)
	# Vendor silhouette inside window
	var vendor_color := VectorStageStyle.ANCHOR_CYAN if is_kiosk_vendor_asked else VectorStageStyle.HUMAN_AMBER
	draw_circle(Vector2(420.0, 205.0), 12.0, vendor_color)
	draw_colored_polygon(PackedVector2Array([
		Vector2(405.0, 260.0), Vector2(435.0, 260.0), Vector2(430.0, 220.0), Vector2(410.0, 220.0),
	]), vendor_color)
	# Sidewalk (near plane)
	draw_rect(Rect2(0.0, 306.0, 640.0, 54.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.30))
	draw_line(Vector2(0.0, 306.0), Vector2(640.0, 306.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	# Exit gate indicator on x=610
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(610.0, 180.0), Vector2(610.0, 306.0), exit_color, 2.0)
