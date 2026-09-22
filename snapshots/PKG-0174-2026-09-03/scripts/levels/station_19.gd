class_name Station19
extends Node2D

## Station 19 — S07, dwa pytania kontrolne.
## Rozmówca zna rodzinny szczegół spoza jakiejkolwiek bazy, ale nie zna
## zdarzenia, które Lena pamięta. Dopiero zestawienie obu odpowiedzi w notesie
## rozstrzyga, czy oszust i stare nagranie wystarczą jako wyjaśnienie.

## PRZESZKODA — dlaczego to tu jest: Budka przy hałaśliwej magistrali gubi połowę zdania, dopóki panel osłonowy nie zasłoni mikrofonu.
## PRZESZKODA — czego wymaga od Leny: zasłonięcia mikrofonu, przygotowania dwóch pytań kontrolnych, odebrania połączenia i zestawienia obu odpowiedzi w notesie.
## PRZESZKODA — koszt porażki: zestawienie odpowiedzi przed zadaniem obu pytań zostawia informację o niekompletnym materiale, a ujawnienie własnej teorii zapisuje żądanie karetki.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_S07_PUBLIC := &"p7.three_place_proofs.public_trial_result"
const FACT_SHIELD := &"p7.three_place_proofs.microphone_shielded"
const FACT_QUESTIONS := &"p7.three_place_proofs.control_questions_prepared"
const FACT_CONTACT := &"p7.three_place_proofs.voice_contact_opened"
const FACT_FAMILY := &"p7.three_place_proofs.family_answer"
const FACT_DIVERGENT := &"p7.three_place_proofs.divergent_answer"
const FACT_TRIAL := &"p7.three_place_proofs.voice_trial_result"
const FACT_FEEDBACK := &"p7.three_place_proofs.safe_trial_feedback"

signal clue_inspected(id: String, prop_type: int)
signal control_answers_compared()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_microphone_shielded := false
var are_control_questions_prepared := false
var is_voice_contact_opened := false
var is_family_answer_heard := false
var is_divergent_answer_heard := false
var is_voice_trial_done := false
var is_own_theory_disclosed := false
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
	_register_beat(&"s19_call_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s19_call_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Ten głos. W tle prawdziwy warsztat, nie nagranie.", "That voice. A real workshop behind it, not a recording.", &"", "")
	_register_beat(&"s19_impostor_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Ktoś mógł zebrać rodzinne szczegóły z moich notatek. Drugie pytanie to sprawdzi.", "Someone could have gathered family details from my notes. The second question tests that.", &"impostor", "compare_control_answers")
	_register_beat(&"s19_control_answers", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zadam pytanie znane tylko rodzinie i pytanie o zdarzenie, które pamiętam, potem zestawię odpowiedzi.", "Ask a family-only question and one about the event I remember, then compare the answers.", &"", "compare_control_answers")
	_register_beat(&"s19_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Panel osłonowy, spis numerów, słuchawka, rozmowa, notes.", "HINT: Shield panel, directory, handset, the call, the notepad.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_19"
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
		"wind_shield":
			shield_microphone()
		"phone_directory":
			prepare_control_questions()
		"payphone_handset":
			answer_payphone()
		"workshop_acoustic":
			ask_control_questions()
		"notepad":
			compare_control_answers()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func shield_microphone() -> bool:
	if is_microphone_shielded:
		return false
	if not _has(FACT_S07_PUBLIC):
		_record_feedback(&"public_trial_required")
		return false
	is_microphone_shielded = true
	_record(FACT_SHIELD, true)
	_report_progress(&"s19_microphone_shielded")
	queue_redraw()
	return true


func prepare_control_questions() -> bool:
	if are_control_questions_prepared:
		return false
	if not is_microphone_shielded:
		_record_feedback(&"microphone_shield_required")
		return false
	are_control_questions_prepared = true
	_record(FACT_QUESTIONS, true)
	_report_progress(&"s19_control_questions_prepared")
	queue_redraw()
	return true


func answer_payphone() -> bool:
	if is_voice_contact_opened:
		return false
	if not are_control_questions_prepared:
		_record_feedback(&"control_questions_required")
		return false
	is_voice_contact_opened = true
	_record(FACT_CONTACT, true)
	if guidance_service:
		guidance_service.trigger_beat(&"s19_call_contact")
	_report_progress(&"s19_voice_contact_opened")
	queue_redraw()
	return true


func ask_control_questions() -> bool:
	if is_family_answer_heard and is_divergent_answer_heard:
		return false
	if not is_voice_contact_opened:
		_record_feedback(&"voice_contact_required")
		return false
	is_family_answer_heard = true
	is_divergent_answer_heard = true
	_record(FACT_FAMILY, "known_detail_confirmed")
	_record(FACT_DIVERGENT, "unknown_to_caller")
	if guidance_service:
		guidance_service.trigger_beat(&"s19_impostor_hypothesis")
	_report_progress(&"s19_control_questions_asked")
	queue_redraw()
	return true


func compare_control_answers() -> bool:
	if is_voice_trial_done:
		return false
	if not (is_family_answer_heard and is_divergent_answer_heard):
		_record_feedback(&"control_answers_incomplete")
		return false
	is_voice_trial_done = true
	_record(FACT_TRIAL, "impostor_and_recording_insufficient")
	_record(&"jakub_voice_heard", true)
	control_answers_compared.emit()
	if guidance_service:
		guidance_service.trigger_beat(&"s19_control_answers")
	_report_progress(&"s19_voice_trial_done")
	_unlock_exit()
	queue_redraw()
	return true


## Bezpieczna błędna próba: ujawnienie własnej teorii nie blokuje porównania,
## ale zostawia fakt o żądaniu karetki i o utraconej kontroli nad rozmową.
func disclose_own_theory() -> bool:
	if is_own_theory_disclosed or not is_voice_contact_opened:
		return false
	is_own_theory_disclosed = true
	_record_feedback(&"own_theory_disclosed")
	_record(&"p7.three_place_proofs.ambulance_demanded", true)
	queue_redraw()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s19_" + value)


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
		"wind_shield": return is_microphone_shielded
		"phone_directory": return are_control_questions_prepared
		"payphone_handset": return is_voice_contact_opened
		"workshop_acoustic": return is_family_answer_heard and is_divergent_answer_heard
		"notepad": return is_voice_trial_done
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var shield_color := VectorStageStyle.LIGHT_PLANE if is_microphone_shielded else VectorStageStyle.HUMAN_AMBER
	var questions_color := VectorStageStyle.CORRECTION_OXIDE if are_control_questions_prepared else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.6)
	var contact_color := VectorStageStyle.SEAM_RED if is_voice_contact_opened else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.5)
	var answers_color := VectorStageStyle.HUMAN_AMBER if is_family_answer_heard else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.4)
	var trial_color := VectorStageStyle.ANCHOR_CYAN if is_voice_trial_done else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.35)
	draw_line(Vector2(144.0, 232.0), Vector2(144.0, 266.0), shield_color, 3.0)
	draw_rect(Rect2(Vector2(200.0, 244.0), Vector2(20.0, 14.0)), questions_color, false, 1.0)
	draw_circle(Vector2(280.0, 240.0), 5.0, contact_color, false, 2.0)
	draw_line(Vector2(348.0, 236.0), Vector2(372.0, 236.0), answers_color, 2.0)
	draw_rect(Rect2(Vector2(432.0, 246.0), Vector2(18.0, 12.0)), trial_color, true)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_color, 2.0)
