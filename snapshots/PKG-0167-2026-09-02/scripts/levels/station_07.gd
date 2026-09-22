class_name Station07
extends Node2D

## Station 07 — Building exterior (Rodzina 1: Zewnętrzna / Miejska / Fasada).
## Materialny konflikt adresu: dokument z torby Leny podaje numer 12, tabliczka na murze mówi 14,
## a lista lokatorów i kod domofonu potwierdzają lokal 14 jako miejsce zamieszkania Leny i Marty.
##
## PRZESZKODA — dlaczego to tu jest: Brama wejściowa do kamienicy jest zaryglowana zamkiem elektromagnetycznym, a wejście wymaga autoryzacji kodem lub kluczem.
## PRZESZKODA — czego wymaga od Leny: porównania dokumentu z tabliczką adresową, sprawdzenia spisu lokatorów i wpisania kodu wejściowego.
## PRZESZKODA — koszt porażki: próba wejścia bez weryfikacji adresu nie tłumaczy rozbieżności między dokumentem zlecenia a fizycznym budynkiem.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_CERTIFICATE := &"p7.address_and_record.certificate_observed"
const FACT_DIRECTORY := &"p7.address_and_record.directory_observed"
const FACT_INTERCOM := &"p7.address_and_record.intercom_result"
const FACT_TRACE := &"p7.address_and_record.trace"
const FACT_FEEDBACK := &"p7.address_and_record.safe_trial_feedback"

signal address_document_compared()
signal intercom_directory_inspected()
signal intercom_code_unlocked()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var props: Node2D = $Props
@onready var entrance_door: AnimatableBody2D = $BuildingEntranceDoor
@onready var airlock_zone: Area2D = $AirlockZone
@onready var return_zone: Area2D = $ReturnZone
@onready var dialogue: CRTDialogueBox = $CRTDialogueBox
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_address_document_compared := false
var is_intercom_directory_inspected := false
var is_intercom_code_unlocked := false
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
	_set_action_available(&"inspect_intercom_directory", false)
	_set_action_available(&"enter_intercom_code", false)
	queue_redraw()


func _connect_action_points() -> void:
	for child in props.get_children():
		if child is OpeningActionPoint:
			var action := child as OpeningActionPoint
			if not action.action_requested.is_connected(_on_action_requested):
				action.action_requested.connect(_on_action_requested)


func _on_action_requested(action_id: StringName) -> void:
	match action_id:
		&"compare_address_document":
			compare_address_document()
		&"inspect_intercom_directory":
			inspect_intercom_directory()
		&"enter_intercom_code":
			enter_intercom_code()


func compare_address_document() -> bool:
	if is_address_document_compared:
		return false
	is_address_document_compared = true
	_record(FACT_CERTIFICATE, true)
	_record(&"p9.exterior.address_document_compared", true)
	_resolve_action(&"compare_address_document")
	_set_action_available(&"inspect_intercom_directory", true)
	address_document_compared.emit()
	_present([
		{"speaker": "LENA", "text": "Moje zaświadczenie z pracy ma pieczęć: Sadowa 12. Na fasadzie wisi mosiężna tabliczka: Sadowa 14."},
	])
	queue_redraw()
	return true


func inspect_intercom_directory() -> bool:
	if not is_address_document_compared or is_intercom_directory_inspected:
		_record_feedback(&"document_check_required")
		return false
	is_intercom_directory_inspected = true
	_record(FACT_DIRECTORY, true)
	_record(&"p9.exterior.intercom_directory_inspected", true)
	_resolve_action(&"inspect_intercom_directory")
	_set_action_available(&"enter_intercom_code", true)
	intercom_directory_inspected.emit()
	_present([
		{"speaker": "LENA", "text": "Lista lokatorów na domofonie: 12 to Kowalczyk. Pod 14 widnieje: L. Wolska / M. Kowalska."},
	])
	queue_redraw()
	return true


func enter_intercom_code() -> bool:
	if not is_intercom_directory_inspected or is_intercom_code_unlocked:
		_record_feedback(&"directory_check_required")
		return false
	is_intercom_code_unlocked = true
	_record(FACT_INTERCOM, "body_and_address_accept")
	_record(FACT_TRACE, "identifiers_agree_and_conflict")
	_record(&"local_address_confirmed", true)
	_record(&"conflicting_documents_found", true)
	_record(&"p9.exterior.intercom_code_unlocked", true)
	_resolve_action(&"enter_intercom_code")
	intercom_code_unlocked.emit()
	_present([
		{"speaker": "LENA", "text": "Wpisuję mój stały kod. Zamek brzęczy i odryglowuje bramę wejściową."},
	])
	_unlock_exit()
	queue_redraw()
	return true


## Backward compatibility for PKG-0146 early diagnostic tests
func ask_shopkeeper_recent_visit() -> bool:
	return compare_address_document()


func inspect_sale_ledger() -> bool:
	if not is_address_document_compared:
		compare_address_document()
	return inspect_intercom_directory()


func commit_ordinary_explanation() -> bool:
	if not is_intercom_directory_inspected:
		inspect_intercom_directory()
	return enter_intercom_code()


func unlock_exit_for_return() -> void:
	_unlock_exit()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	if entrance_door != null:
		ExitClearance.open_body_tweened(self, entrance_door, 116.0, 0.6)
	call_deferred("_complete_if_player_already_in_airlock")


func _complete_if_player_already_in_airlock() -> void:
	if airlock_zone != null and player != null and airlock_zone.overlaps_body(player):
		_trigger_level_completion()


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s07_composition", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s07_reaction", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Sadowa 14. Moje zaświadczenie podaje dwunastkę.", "Sadowa 14. My workplace certificate states number twelve.", &"", "")
	_register_beat(&"s07_thought", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Sprawdzę spis lokatorów na domofonie przed wejściem.", "I will check the tenant directory before entering.", &"address_conflict", "inspect_intercom_directory")
	_register_beat(&"s07_intent", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Porównam dokument, listę i sprawdzę czy kod działa.", "I will compare document, directory, and test the entrance code.", &"", "")
	_register_beat(&"s07_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Porównaj dokument z tabliczką, sprawdź listę domofonu i wpisz kod.", "HINT: Compare document with plaque, check intercom list, and enter your code.", &"", "")


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


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_exit_unlocked:
		_trigger_level_completion()


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
		Vector2(0.0, 110.0), Vector2(140.0, 95.0), Vector2(280.0, 85.0),
		Vector2(450.0, 90.0), Vector2(580.0, 80.0), Vector2(640.0, 85.0),
		Vector2(640.0, 110.0),
	]), VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.40))
	# Mid plane: Tenement façade (x=0..640, y=110..306)
	draw_rect(Rect2(0.0, 110.0, 640.0, 196.0), VectorStageStyle.DEEP_PLANE)
	# Architectural cornices and stonework
	draw_line(Vector2(0.0, 120.0), Vector2(640.0, 120.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.25), 3.0)
	draw_line(Vector2(0.0, 200.0), Vector2(640.0, 200.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.20), 2.0)
	# Windows on the facade
	for wx in [60.0, 180.0, 300.0]:
		draw_rect(Rect2(wx, 136.0, 36.0, 48.0), VectorStageStyle.INK)
		draw_rect(Rect2(wx + 2.0, 138.0, 32.0, 44.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.30), false, 1.0)
		draw_line(Vector2(wx + 18.0, 138.0), Vector2(wx + 18.0, 182.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.30), 1.0)
	# Address plaque at x=160 (SADOWA 14)
	var plaque_color := VectorStageStyle.ANCHOR_CYAN if is_address_document_compared else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(146.0, 220.0, 36.0, 22.0), VectorStageStyle.INK)
	draw_rect(Rect2(146.0, 220.0, 36.0, 22.0), plaque_color, false, 2.0)
	draw_line(Vector2(152.0, 231.0), Vector2(176.0, 231.0), plaque_color, 1.5)
	# Intercom directory panel at x=330
	var dir_color := VectorStageStyle.ANCHOR_CYAN if is_intercom_directory_inspected else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(316.0, 210.0, 32.0, 44.0), VectorStageStyle.INK)
	draw_rect(Rect2(316.0, 210.0, 32.0, 44.0), dir_color, false, 1.5)
	draw_line(Vector2(322.0, 222.0), Vector2(342.0, 222.0), dir_color, 1.0)
	draw_line(Vector2(322.0, 234.0), Vector2(342.0, 234.0), dir_color, 1.0)
	# Intercom keypad at x=460
	var keypad_color := VectorStageStyle.ANCHOR_CYAN if is_intercom_code_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(448.0, 216.0, 24.0, 36.0), VectorStageStyle.INK)
	draw_rect(Rect2(448.0, 216.0, 24.0, 36.0), keypad_color, false, 1.5)
	draw_circle(Vector2(460.0, 226.0), 3.0, keypad_color)
	# Entrance portal & door frame at x=530..610
	draw_colored_polygon(PackedVector2Array([
		Vector2(530.0, 140.0), Vector2(610.0, 140.0), Vector2(610.0, 306.0), Vector2(530.0, 306.0),
	]), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.20))
	draw_rect(Rect2(542.0, 160.0, 56.0, 146.0), VectorStageStyle.INK)
	var door_indicator := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(542.0, 160.0, 56.0, 146.0), door_indicator, false, 2.0)
	# Granite entrance steps (step riser 14 px)
	draw_rect(Rect2(516.0, 292.0, 80.0, 14.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.40))
	draw_line(Vector2(516.0, 292.0), Vector2(596.0, 292.0), VectorStageStyle.LIGHT_PLANE, 1.5)
	# Sidewalk (near plane)
	draw_rect(Rect2(0.0, 306.0, 640.0, 54.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.30))
	draw_line(Vector2(0.0, 306.0), Vector2(640.0, 306.0), VectorStageStyle.LIGHT_PLANE, 2.0)
