class_name Station17
extends Node2D

## Station 17 — S06, zakres kopiowania raportu.
## Raport ma status incydentu ciągłości pomiaru, dwie próby startują w tej
## samej sekundzie, a numeru czytnika Leny nie ma w lokalnym spisie. Przy
## włazie serwisowym Lena decyduje, ile z tego wynosi: sam nagłówek wystarczy
## do testu, prywatne dane Marty nie są skrótem.

## PRZESZKODA — dlaczego to tu jest: Drzwi główne domyka procedura izolacji, a właz serwisowy zwalnia się dopiero po ręcznym otwarciu rygla wentylacji.
## PRZESZKODA — czego wymaga od Leny: odczytania raportu, porównania sygnatury z własną kartą, zwolnienia rygla wentylacji i wyniesienia wyłącznie nagłówka.
## PRZESZKODA — koszt porażki: próba wyniesienia raportu bez porównanej sygnatury i zwolnionego rygla zostawia informację o niekompletnym zakresie i nie otwiera włazu.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_S06_TRIAL := &"p7.work_history_and_record.institution_trial_result"
const FACT_REPORT := &"p7.work_history_and_record.incident_report_read"
const FACT_SIGNATURE := &"p7.work_history_and_record.signature_compared"
const FACT_UCP_CONTACT := &"p7.work_history_and_record.ucp_contact_observed"
const FACT_ROUTE := &"p7.work_history_and_record.service_route_released"
const FACT_SCOPE := &"p7.work_history_and_record.report_scope"
const FACT_TRACE := &"p7.work_history_and_record.trace"
const FACT_FEEDBACK := &"p7.work_history_and_record.safe_trial_feedback"

signal clue_inspected(id: String, prop_type: int)
signal report_scope_committed()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_incident_report_read := false
var is_signature_compared := false
var is_ucp_contact_observed := false
var is_service_route_released := false
var is_report_scope_committed := false
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
	_register_beat(&"s17_report_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s17_report_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Dwa pomiary w tej samej sekundzie. Mojego czytnika nie ma w spisie.", "Two measurements in the same second. My reader is not in the index.", &"", "")
	_register_beat(&"s17_shortcut_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Prościej byłoby wziąć notatki Marty. To nie jest mój materiał.", "Taking Marta's notes would be easier. That material is not mine.", &"consistent_foreign_biography", "copy_report_header")
	_register_beat(&"s17_report_scope", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Porównam sygnaturę z kartą, zwolnię rygiel i wyniosę tylko nagłówek.", "Compare the signature with the card, release the latch, take only the header.", &"", "copy_report_header")
	_register_beat(&"s17_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Konsola, nośnik, interkom, rygiel wentylacji, właz.", "HINT: Console, drive, intercom, ventilation latch, hatch.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_17"
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
		"incident_console":
			read_incident_report()
		"data_storage_drive":
			compare_signature_with_card()
		"intercom_speaker":
			listen_intercom_warning()
		"ventilation_lever":
			release_service_route()
		"service_exit_hatch":
			copy_report_header()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func read_incident_report() -> bool:
	if is_incident_report_read:
		return false
	if not _has(FACT_S06_TRIAL):
		_record_feedback(&"institution_trial_required")
		return false
	is_incident_report_read = true
	_record(FACT_REPORT, "measurement_continuity_incident")
	if guidance_service:
		guidance_service.trigger_beat(&"s17_report_contact")
	_report_progress(&"s17_incident_report_read")
	queue_redraw()
	return true


func compare_signature_with_card() -> bool:
	if is_signature_compared:
		return false
	if not is_incident_report_read:
		_record_feedback(&"incident_report_required")
		return false
	is_signature_compared = true
	_record(FACT_SIGNATURE, "same_second_reader_absent")
	if guidance_service:
		guidance_service.trigger_beat(&"s17_shortcut_hypothesis")
	_report_progress(&"s17_signature_compared")
	queue_redraw()
	return true


func listen_intercom_warning() -> bool:
	if is_ucp_contact_observed:
		return false
	if not is_incident_report_read:
		_record_feedback(&"incident_report_required")
		return false
	is_ucp_contact_observed = true
	_record(FACT_UCP_CONTACT, "wierzbicka_asks_to_wait")
	_report_progress(&"s17_ucp_contact_observed")
	queue_redraw()
	return true


func release_service_route() -> bool:
	if is_service_route_released:
		return false
	if not is_signature_compared:
		_record_feedback(&"signature_comparison_required")
		return false
	is_service_route_released = true
	_record(FACT_ROUTE, true)
	_report_progress(&"s17_service_route_released")
	queue_redraw()
	return true


func copy_report_header() -> bool:
	if is_report_scope_committed:
		return false
	if not (is_incident_report_read and is_signature_compared and is_service_route_released):
		_record_feedback(&"report_scope_incomplete")
		return false
	is_report_scope_committed = true
	_record(FACT_SCOPE, "minimum_for_test")
	_record(&"parallel_test_trace_found", true)
	_record(FACT_TRACE, "institutional_source_and_document_conflict")
	report_scope_committed.emit()
	if guidance_service:
		guidance_service.trigger_beat(&"s17_report_scope")
	_report_progress(&"s17_report_scope_committed")
	_unlock_exit()
	queue_redraw()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s17_" + value)


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
		"incident_console": return is_incident_report_read
		"data_storage_drive": return is_signature_compared
		"intercom_speaker": return is_ucp_contact_observed
		"ventilation_lever": return is_service_route_released
		"service_exit_hatch": return is_report_scope_committed
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var console_color := VectorStageStyle.ANCHOR_CYAN if is_incident_report_read else VectorStageStyle.HUMAN_AMBER
	var signature_color := VectorStageStyle.CORRECTION_OXIDE if is_signature_compared else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.6)
	var intercom_color := VectorStageStyle.SEAM_RED if is_ucp_contact_observed else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.5)
	var latch_color := VectorStageStyle.LIGHT_PLANE if is_service_route_released else VectorStageStyle.HUMAN_AMBER
	var scope_color := VectorStageStyle.ANCHOR_CYAN if is_report_scope_committed else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.35)
	draw_rect(Rect2(Vector2(136.0, 240.0), Vector2(30.0, 24.0)), console_color, false, 1.0)
	draw_rect(Rect2(Vector2(230.0, 246.0), Vector2(20.0, 14.0)), signature_color, false, 1.0)
	draw_circle(Vector2(340.0, 230.0), 5.0, intercom_color, false, 2.0)
	draw_line(Vector2(444.0, 236.0), Vector2(456.0, 260.0), latch_color, 3.0)
	draw_rect(Rect2(Vector2(502.0, 244.0), Vector2(16.0, 12.0)), scope_color, true)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_color, 2.0)
