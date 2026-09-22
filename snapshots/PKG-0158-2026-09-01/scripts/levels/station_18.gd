class_name Station18
extends Node2D

## Station 18 — S07, próba publiczna.
## Rejestr miejski nie ma aktu zgonu, szpital ma późniejsze wpisy, karta
## pracownicza i numer sprawy katastrofy zgadzają się z tą samą datą.
## Porównanie na czytniku mikrofisz rozstrzyga, czy to kopia jednego błędu,
## czy dwa niezależne systemy i dziewięć lat wpisów.

## PRZESZKODA — dlaczego to tu jest: Publiczne terminale archiwum są rozdzielone przegrodą techniczną, a rejestr zgonów i rejestr ubezpieczeń przełącza się ręcznie.
## PRZESZKODA — czego wymaga od Leny: sprawdzenia rejestru miejskiego, przejścia do terminala szpitalnego, potwierdzenia karty pracowniczej, odczytu numeru sprawy i porównania na mikrofiszach.
## PRZESZKODA — koszt porażki: porównanie bez trzech niezależnych źródeł zostawia informację o brakującym rejestrze i nie zamyka hipotezy kopii błędu.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_S06_TRACE := &"p7.work_history_and_record.trace"
const FACT_MUNICIPAL := &"p7.three_place_proofs.municipal_registry_read"
const FACT_HOSPITAL := &"p7.three_place_proofs.hospital_registry_read"
const FACT_CARD := &"p7.three_place_proofs.employment_card_verified"
const FACT_DISASTER := &"p7.three_place_proofs.disaster_case_read"
const FACT_TRIAL := &"p7.three_place_proofs.public_trial_result"
const FACT_FEEDBACK := &"p7.three_place_proofs.safe_trial_feedback"

signal clue_inspected(id: String, prop_type: int)
signal public_trial_completed()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_municipal_registry_read := false
var is_hospital_registry_read := false
var is_employment_card_verified := false
var is_disaster_case_read := false
var is_public_trial_done := false
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
	_register_beat(&"s18_registry_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s18_registry_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Brak aktu zgonu. Dziewięć lat późniejszych wpisów.", "No death certificate. Nine years of later entries.", &"", "")
	_register_beat(&"s18_error_copy_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Może jeden błąd rozszedł się po rejestrach. Trzy źródła to rozdzielą.", "Maybe one error spread across registries. Three sources separate that.", &"error_copy", "compare_independent_registries")
	_register_beat(&"s18_public_trial", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zestawię rejestr miejski, szpitalny i numer sprawy na jednym czytniku.", "Compare the municipal registry, the hospital registry and the case number on one reader.", &"", "compare_independent_registries")
	_register_beat(&"s18_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Terminal miejski, szpitalny, karta, teczka sprawy, mikrofisze.", "HINT: Municipal terminal, hospital terminal, card, case file, microfiche.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_18"
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
		"municipal_terminal":
			search_municipal_death_registry()
		"hospital_terminal":
			search_hospital_registry()
		"employment_card":
			verify_employment_card()
		"disaster_file":
			read_disaster_case_file()
		"microfiche_reader":
			compare_independent_registries()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func search_municipal_death_registry() -> bool:
	if is_municipal_registry_read:
		return false
	if not _has(FACT_S06_TRACE):
		_record_feedback(&"institutional_source_required")
		return false
	is_municipal_registry_read = true
	_record(FACT_MUNICIPAL, "no_death_certificate")
	if guidance_service:
		guidance_service.trigger_beat(&"s18_registry_contact")
	_report_progress(&"s18_municipal_registry_read")
	queue_redraw()
	return true


func search_hospital_registry() -> bool:
	if is_hospital_registry_read:
		return false
	if not is_municipal_registry_read:
		_record_feedback(&"municipal_registry_required")
		return false
	is_hospital_registry_read = true
	_record(FACT_HOSPITAL, "surgery_survived_later_entries")
	if guidance_service:
		guidance_service.trigger_beat(&"s18_error_copy_hypothesis")
	_report_progress(&"s18_hospital_registry_read")
	queue_redraw()
	return true


func verify_employment_card() -> bool:
	if is_employment_card_verified:
		return false
	if not is_hospital_registry_read:
		_record_feedback(&"hospital_registry_required")
		return false
	is_employment_card_verified = true
	_record(FACT_CARD, "line_4_worker_card")
	_report_progress(&"s18_employment_card_verified")
	queue_redraw()
	return true


func read_disaster_case_file() -> bool:
	if is_disaster_case_read:
		return false
	if not is_employment_card_verified:
		_record_feedback(&"employment_card_required")
		return false
	is_disaster_case_read = true
	_record(FACT_DISASTER, "case_date_matches_remembered_disaster")
	_report_progress(&"s18_disaster_case_read")
	queue_redraw()
	return true


func compare_independent_registries() -> bool:
	if is_public_trial_done:
		return false
	if not (is_municipal_registry_read and is_hospital_registry_read and is_disaster_case_read):
		_record_feedback(&"registry_sources_incomplete")
		return false
	is_public_trial_done = true
	_record(FACT_TRIAL, "two_systems_and_nine_years")
	_record(&"jakub_public_history_verified", true)
	_record(&"recognition_evidence_public", true)
	public_trial_completed.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"error_copy")
		guidance_service.trigger_beat(&"s18_public_trial")
	_report_progress(&"s18_public_trial_done")
	_unlock_exit()
	queue_redraw()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s18_" + value)


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
		"municipal_terminal": return is_municipal_registry_read
		"hospital_terminal": return is_hospital_registry_read
		"employment_card": return is_employment_card_verified
		"disaster_file": return is_disaster_case_read
		"microfiche_reader": return is_public_trial_done
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var municipal_color := VectorStageStyle.ANCHOR_CYAN if is_municipal_registry_read else VectorStageStyle.HUMAN_AMBER
	var hospital_color := VectorStageStyle.LIGHT_PLANE if is_hospital_registry_read else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.6)
	var card_color := VectorStageStyle.CORRECTION_OXIDE if is_employment_card_verified else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.5)
	var case_color := VectorStageStyle.SEAM_RED if is_disaster_case_read else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.45)
	var trial_color := VectorStageStyle.ANCHOR_CYAN if is_public_trial_done else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.35)
	draw_rect(Rect2(Vector2(136.0, 240.0), Vector2(28.0, 24.0)), municipal_color, false, 1.0)
	draw_rect(Rect2(Vector2(246.0, 240.0), Vector2(28.0, 24.0)), hospital_color, false, 1.0)
	draw_rect(Rect2(Vector2(370.0, 246.0), Vector2(20.0, 14.0)), card_color, false, 1.0)
	draw_rect(Rect2(Vector2(450.0, 244.0), Vector2(20.0, 18.0)), case_color, false, 1.0)
	draw_circle(Vector2(520.0, 250.0), 6.0, trial_color, false, 2.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_color, 2.0)
