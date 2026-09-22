class_name Station16
extends Node2D

## Station 16 — S06, próba instytucjonalna.
## Biometryka rozpoznaje ciało Leny, domowa karta ma obcy numer, a historia
## aktywności i grafik dzisiejszej próby trwają miesiącami. Porównanie tych
## trzech źródeł przy bramce rozstrzyga między jednorazową ingerencją
## a trwałą chronologią.

## PRZESZKODA — dlaczego to tu jest: Bramka biometryczna i kołowrót serwisowy zwalniają się dopiero wtedy, gdy skan dłoni, numer stanowiska i grafik zgadzają się w jednym zapytaniu.
## PRZESZKODA — czego wymaga od Leny: przyłożenia dłoni do skanera, porównania niezgodnego numeru karty, odczytania historii aktywności i wykonania porównania przy kołowrocie.
## PRZESZKODA — koszt porażki: porównanie przy kołowrocie bez trzech odczytów zostawia informację o brakującym źródle i nie zwalnia rygla.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_S06_REQUEST := &"p7.work_history_and_record.own_record_requested"
const FACT_BIOMETRICS := &"p7.work_history_and_record.biometric_profile_matched"
const FACT_CARD := &"p7.work_history_and_record.card_number_compared"
const FACT_ACTIVITY := &"p7.work_history_and_record.activity_history_read"
const FACT_TRIAL := &"p7.work_history_and_record.institution_trial_result"
const FACT_SIGNATURE_SOURCE := &"p7.work_history_and_record.roster_signature_read"
const FACT_FEEDBACK := &"p7.work_history_and_record.safe_trial_feedback"

signal clue_inspected(id: String, prop_type: int)
signal institution_trial_completed()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_biometric_profile_matched := false
var is_card_number_compared := false
var is_activity_history_read := false
var is_institution_trial_done := false
var is_roster_signature_read := false
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
	_register_beat(&"s16_office_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s16_office_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Moja dłoń. Mój profil. Obcy numer karty.", "My hand. My profile. A foreign card number.", &"", "")
	_register_beat(&"s16_falsified_record_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Ktoś mógł podmienić jeden rekord. Grafik i biometryka to rozstrzygną.", "Someone could have swapped one record. The roster and biometrics decide.", &"falsified_record", "compare_field_biometrics_and_audit")
	_register_beat(&"s16_institution_trial", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zestawię skan, numer karty i historię aktywności w jednym zapytaniu przy kołowrocie.", "Compare the scan, the card number and the activity history in one query at the turnstile.", &"", "compare_field_biometrics_and_audit")
	_register_beat(&"s16_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Skaner, czytnik karty, tablica grafiku, potem kołowrót.", "HINT: Scanner, card reader, roster board, then the turnstile.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_16"
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
		"biometric_scanner":
			scan_biometric_profile()
		"card_reader_slot":
			compare_card_number()
		"duty_schedule_board":
			read_activity_history()
		"turnstile_gate":
			compare_field_biometrics_and_audit()
		"roster_terminal":
			read_roster_signature()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func scan_biometric_profile() -> bool:
	if is_biometric_profile_matched:
		return false
	if not _has(FACT_S06_REQUEST):
		_record_feedback(&"own_record_request_required")
		return false
	is_biometric_profile_matched = true
	_record(FACT_BIOMETRICS, "body_recognised_as_team_member")
	if guidance_service:
		guidance_service.trigger_beat(&"s16_office_contact")
	_report_progress(&"s16_biometric_profile_matched")
	queue_redraw()
	return true


func compare_card_number() -> bool:
	if is_card_number_compared:
		return false
	if not is_biometric_profile_matched:
		_record_feedback(&"biometric_profile_required")
		return false
	is_card_number_compared = true
	_record(FACT_CARD, "home_card_number_foreign")
	if guidance_service:
		guidance_service.trigger_beat(&"s16_falsified_record_hypothesis")
	_report_progress(&"s16_card_number_compared")
	queue_redraw()
	return true


func read_activity_history() -> bool:
	if is_activity_history_read:
		return false
	if not is_card_number_compared:
		_record_feedback(&"card_number_required")
		return false
	is_activity_history_read = true
	_record(FACT_ACTIVITY, "one_hundred_eighty_six_days")
	_report_progress(&"s16_activity_history_read")
	queue_redraw()
	return true


func compare_field_biometrics_and_audit() -> bool:
	if is_institution_trial_done:
		return false
	if not (is_biometric_profile_matched and is_card_number_compared and is_activity_history_read):
		_record_feedback(&"institution_sources_incomplete")
		return false
	is_institution_trial_done = true
	_record(FACT_TRIAL, "persistent_chronology_confirmed")
	_record(&"local_lena_ucp_profile_found", true)
	institution_trial_completed.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"memory_manipulation")
		guidance_service.close_hypothesis(&"falsified_record")
		guidance_service.close_hypothesis(&"consistent_foreign_biography")
		guidance_service.trigger_beat(&"s16_institution_trial")
	_report_progress(&"s16_institution_trial_done")
	_unlock_exit()
	queue_redraw()
	return true


func read_roster_signature() -> bool:
	if is_roster_signature_read:
		return false
	if not is_activity_history_read:
		_record_feedback(&"activity_history_required")
		return false
	is_roster_signature_read = true
	_record(FACT_SIGNATURE_SOURCE, "approval_20_40_wierzbicka")
	_report_progress(&"s16_roster_signature_read")
	queue_redraw()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s16_" + value)


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
		"biometric_scanner": return is_biometric_profile_matched
		"card_reader_slot": return is_card_number_compared
		"duty_schedule_board": return is_activity_history_read
		"turnstile_gate": return is_institution_trial_done
		"roster_terminal": return is_roster_signature_read
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var bio_color := VectorStageStyle.ANCHOR_CYAN if is_biometric_profile_matched else VectorStageStyle.HUMAN_AMBER
	var card_color := VectorStageStyle.CORRECTION_OXIDE if is_card_number_compared else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.6)
	var activity_color := VectorStageStyle.LIGHT_PLANE if is_activity_history_read else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.5)
	var gate_color := VectorStageStyle.ANCHOR_CYAN if is_institution_trial_done else VectorStageStyle.SEAM_RED
	draw_circle(Vector2(160.0, 250.0), 6.0, bio_color, false, 2.0)
	draw_rect(Rect2(Vector2(248.0, 240.0), Vector2(24.0, 20.0)), card_color, false, 1.0)
	draw_rect(Rect2(Vector2(364.0, 232.0), Vector2(32.0, 26.0)), activity_color, false, 1.0)
	draw_line(Vector2(480.0, 220.0), Vector2(480.0, 296.0), gate_color, 2.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_color, 2.0)
