class_name Station08
extends Node2D

## Station 08 — S03, test domofonu.
## Dokument i lista dają rozbieżne źródła; domofon sprawdza, czy rozpoznaje
## osobę oraz adres bez wpisywania kodu-zagadki i bez roszczenia do biografii.

## PRZESZKODA — dlaczego to tu jest: Domofon bloku rozpoznaje osobę po kodzie i kluczu, a nie po treści dokumentu z torby.
## PRZESZKODA — czego wymaga od Leny: odczytania dokumentu i listy oraz wykonania testu rozpoznania na klawiaturze.
## PRZESZKODA — koszt porażki: test przed odczytaniem źródeł zostawia komunikat o brakującym porównaniu.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_SHOP := &"p7.address_and_record.shopkeeper_answer"
const FACT_CERTIFICATE := &"p7.address_and_record.certificate_observed"
const FACT_DIRECTORY := &"p7.address_and_record.directory_observed"
const FACT_INTERCOM := &"p7.address_and_record.intercom_result"
const FACT_TRACE := &"p7.address_and_record.trace"
const FACT_FEEDBACK := &"p7.address_and_record.safe_trial_feedback"

signal clue_inspected(id: String, prop_type: int)
signal intercom_test_completed()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var entrance_door: AnimatableBody2D = $Geometry/BuildingEntranceDoor
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_certificate_read := false
var is_directory_read := false
var is_intercom_test_completed := false
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
	_register_beat(&"s08_intercom_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s08_intercom_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Dokument mówi dwanaście. Lista mówi czternaście.", "Document says twelve. Directory says fourteen.", &"", "")
	_register_beat(&"s08_renumbering_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Może przełożyli numery. Domofon rozstrzygnie, co zna.", "Maybe the numbers moved. The intercom can show what it knows.", &"renumbered_route", "test_intercom_identity_without_claim")
	_register_beat(&"s08_test_intercom", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Porównam dokument i listę, potem poproszę domofon o rozpoznanie.", "Compare document and directory, then ask the intercom to recognize me.", &"", "")
	_register_beat(&"s08_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Odczytaj dokument i listę. Klawiatura wykonuje test, nie wpisuje kodu zagadki.", "HINT: Read document and directory. The keypad runs a test, not a puzzle code.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_08"
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
		"field_certificate":
			read_certificate()
		"tenant_directory":
			read_directory()
		"entry_keypad":
			test_intercom_recognition()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func read_certificate() -> bool:
	if is_certificate_read or not _has(FACT_SHOP):
		_record_feedback(&"shopkeeper_context_required")
		return false
	is_certificate_read = true
	_record(FACT_CERTIFICATE, true)
	_report_progress(&"s08_certificate_read")
	queue_redraw()
	return true


func read_directory() -> bool:
	if is_directory_read or not is_certificate_read:
		_record_feedback(&"certificate_required")
		return false
	is_directory_read = true
	_record(FACT_DIRECTORY, true)
	_report_progress(&"s08_directory_read")
	if guidance_service:
		guidance_service.trigger_beat(&"s08_renumbering_hypothesis")
	queue_redraw()
	return true


func test_intercom_recognition() -> bool:
	if is_intercom_test_completed:
		return false
	if not (is_certificate_read and is_directory_read):
		_record_feedback(&"document_or_directory_missing")
		return false
	is_intercom_test_completed = true
	_record(FACT_INTERCOM, "body_and_address_accept")
	_record(FACT_TRACE, "identifiers_agree_and_conflict")
	intercom_test_completed.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"renumbered_route")
	_report_progress(&"s08_intercom_test_completed")
	_unlock_exit()
	queue_redraw()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s08_" + value)


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	if entrance_door:
		ExitClearance._disable_shapes(entrance_door)
		entrance_door.position.y = 176.0
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
		"field_certificate": return is_certificate_read
		"tenant_directory": return is_directory_read
		"entry_keypad": return is_intercom_test_completed
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var certificate_color := VectorStageStyle.LIGHT_PLANE if is_certificate_read else VectorStageStyle.HUMAN_AMBER
	var directory_color := VectorStageStyle.CORRECTION_OXIDE if is_directory_read else VectorStageStyle.HUMAN_AMBER
	var intercom_color := VectorStageStyle.ANCHOR_CYAN if is_intercom_test_completed else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(Vector2(142.0, 244.0), Vector2(22.0, 14.0)), certificate_color, false, 2.0)
	draw_rect(Rect2(Vector2(270.0, 226.0), Vector2(22.0, 20.0)), directory_color, false, 2.0)
	draw_rect(Rect2(Vector2(400.0, 226.0), Vector2(18.0, 22.0)), intercom_color, false, 2.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(500.0, 176.0), Vector2(500.0, 300.0), exit_color, 2.0)
	draw_line(Vector2(556.0, 176.0), Vector2(556.0, 300.0), exit_color, 2.0)
