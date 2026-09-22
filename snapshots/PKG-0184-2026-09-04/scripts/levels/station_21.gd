class_name Station21
extends Node2D

## Station 21 — S07, synteza trzech rodzin dowodów.
## Trzy pola pomiarowe przyjmują czytnik z próbką, rejestry publiczne i zapis
## serwisowy Jakuba. Rozpoznanie i drugi cel powstają wyłącznie po jawnie
## wykonanej syntezie: samo ułożenie materiałów ani wejście do sceny nie
## wystarczają.

## PRZESZKODA — dlaczego to tu jest: Stół warsztatowy ma trzy wydzielone pola pomiarowe, a układ zwiera się tylko wtedy, gdy każde pole trzyma niezależne źródło.
## PRZESZKODA — czego wymaga od Leny: ułożenia czytnika z próbką, rejestrów publicznych i zapisu serwisowego, a następnie wykonania syntezy na stole.
## PRZESZKODA — koszt porażki: synteza przed skompletowaniem trzech rodzin zostawia informację o brakującym polu i nie usuwa już ułożonych materiałów.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const SYNTHESIS_LABEL_PENDING := "STÓŁ SYNTEZY // TRZY POLA POMIAROWE"
const SYNTHESIS_LABEL_RESOLVED := "SYNTEZA // TO NIE JEST MÓJ ŚWIAT"
const EXIT_SUBTITLE_PENDING := "Korytarz serwisowy"
const EXIT_SUBTITLE_RESOLVED := "Kierunek: odnalezienie miejscowej Leny"

const FACT_CARRIED := &"recognition_evidence_carried"
const FACT_PUBLIC := &"recognition_evidence_public"
const FACT_RELATIONAL := &"recognition_evidence_relational"
const FACT_READER_PLACED := &"p7.three_place_proofs.reader_family_placed"
const FACT_PUBLIC_PLACED := &"p7.three_place_proofs.public_family_placed"
const FACT_RELATIONAL_PLACED := &"p7.three_place_proofs.relational_family_placed"
const FACT_SYNTHESIS := &"p7.three_place_proofs.synthesis_result"
const FACT_TRACE := &"p7.three_place_proofs.trace"
const FACT_FEEDBACK := &"p7.three_place_proofs.safe_trial_feedback"

signal clue_inspected(id: String, prop_type: int)
signal synthesis_executed()
signal recognition_committed()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var synthesis_label: CrispDiegeticText = get_node_or_null("CrispDiegeticText_Synthesis")
@onready var corridor_prop: MemoryResonancePoint = get_node_or_null("Props/Station21Exit")

var is_reader_family_placed := false
var is_public_family_placed := false
var is_relational_family_placed := false
var is_synthesis_done := false
var is_world_recognized := false
var is_local_search_committed := false
var is_corridor_observed := false
var is_exit_unlocked := false
var is_level_completed := false


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_props()
	_apply_pre_synthesis_presentation()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	queue_redraw()


## Rozpoznanie i drugi cel nie mogą być widoczne w kadrze przed wykonaną
## syntezą; scena startuje z neutralnym opisem stołu i korytarza.
func _apply_pre_synthesis_presentation() -> void:
	if synthesis_label != null:
		synthesis_label.text = SYNTHESIS_LABEL_PENDING
	if corridor_prop != null:
		corridor_prop.prop_subtitle = EXIT_SUBTITLE_PENDING


func _apply_post_synthesis_presentation() -> void:
	if synthesis_label != null:
		synthesis_label.text = SYNTHESIS_LABEL_RESOLVED
	if corridor_prop != null:
		corridor_prop.prop_subtitle = EXIT_SUBTITLE_RESOLVED


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s21_table_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s21_table_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Trzy pola. Trzy niezależne źródła.", "Three fields. Three independent sources.", &"", "")
	_register_beat(&"s21_single_explanation_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Może jedno wyjaśnienie obejmie wszystko. Zwarcie układu to sprawdzi.", "Maybe one explanation covers everything. Closing the circuit tests that.", &"consistent_foreign_continuity", "execute_three_family_synthesis")
	_register_beat(&"s21_three_family_synthesis", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Ułożę trzy źródła w polach, potem zewrę układ na stole.", "Place the three sources in the fields, then close the circuit on the table.", &"", "execute_three_family_synthesis")
	_register_beat(&"s21_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Czytnik z próbką, rejestry publiczne, zapis serwisowy, potem stół.", "HINT: Reader with sample, public registries, service record, then the table.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_21"
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
		"slot_reader_sample":
			place_reader_and_sample()
		"slot_public_records":
			place_public_records()
		"slot_relational_evidence":
			place_relational_record()
		"synthesis_table":
			execute_three_family_synthesis()
		"airlock_corridor":
			observe_corridor_direction()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func place_reader_and_sample() -> bool:
	if is_reader_family_placed:
		return false
	if not _has(FACT_CARRIED):
		_record_feedback(&"carried_evidence_missing")
		return false
	is_reader_family_placed = true
	_record(FACT_READER_PLACED, true)
	if guidance_service:
		guidance_service.trigger_beat(&"s21_table_contact")
	_report_progress(&"s21_reader_family_placed")
	queue_redraw()
	return true


func place_public_records() -> bool:
	if is_public_family_placed:
		return false
	if not _has(FACT_PUBLIC):
		_record_feedback(&"public_evidence_missing")
		return false
	is_public_family_placed = true
	_record(FACT_PUBLIC_PLACED, true)
	_report_progress(&"s21_public_family_placed")
	queue_redraw()
	return true


func place_relational_record() -> bool:
	if is_relational_family_placed:
		return false
	if not _has(FACT_RELATIONAL):
		_record_feedback(&"relational_evidence_missing")
		return false
	is_relational_family_placed = true
	_record(FACT_RELATIONAL_PLACED, true)
	if guidance_service:
		guidance_service.trigger_beat(&"s21_single_explanation_hypothesis")
	_report_progress(&"s21_relational_family_placed")
	queue_redraw()
	return true


## Jawna próba rozstrzygająca. Ułożenie trzeciego materiału nie uruchamia jej
## automatycznie; brakujące pole zostawia fakt i nie kasuje ułożonych źródeł.
func execute_three_family_synthesis() -> bool:
	if is_synthesis_done:
		return false
	if not is_reader_family_placed:
		_record_feedback(&"reader_family_not_placed")
		return false
	if not is_public_family_placed:
		_record_feedback(&"public_family_not_placed")
		return false
	if not is_relational_family_placed:
		_record_feedback(&"relational_family_not_placed")
		return false
	is_synthesis_done = true
	_record(FACT_SYNTHESIS, "single_world_explanation_fails")
	synthesis_executed.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"consistent_foreign_continuity")
		guidance_service.trigger_beat(&"s21_three_family_synthesis")
	_commit_recognition()
	_report_progress(&"s21_synthesis_done")
	queue_redraw()
	return true


## Rozpoznanie i przyjęcie drugiego celu są jednym skutkiem wykonanej syntezy.
func _commit_recognition() -> void:
	if is_world_recognized:
		return
	is_world_recognized = true
	is_local_search_committed = true
	_record(&"world_recognized", true)
	_record(&"local_lena_search_committed", true)
	_record(FACT_TRACE, "world_recognized_and_search_committed")
	_apply_post_synthesis_presentation()
	recognition_committed.emit()
	_report_progress(&"s21_recognition_committed")
	_unlock_exit()


func observe_corridor_direction() -> bool:
	if is_corridor_observed:
		return false
	if not is_synthesis_done:
		_record_feedback(&"synthesis_required")
		return false
	is_corridor_observed = true
	_record(&"p7.three_place_proofs.corridor_direction_observed", true)
	_report_progress(&"s21_corridor_observed")
	queue_redraw()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s21_" + value)


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
		"slot_reader_sample": return is_reader_family_placed
		"slot_public_records": return is_public_family_placed
		"slot_relational_evidence": return is_relational_family_placed
		"synthesis_table": return is_synthesis_done
		"airlock_corridor": return is_corridor_observed
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var reader_color := VectorStageStyle.ANCHOR_CYAN if is_reader_family_placed else VectorStageStyle.HUMAN_AMBER
	var public_color := VectorStageStyle.LIGHT_PLANE if is_public_family_placed else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.6)
	var relational_color := VectorStageStyle.CORRECTION_OXIDE if is_relational_family_placed else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.5)
	var synthesis_color := VectorStageStyle.ANCHOR_CYAN if is_synthesis_done else VectorStageStyle.SEAM_RED
	draw_rect(Rect2(Vector2(148.0, 242.0), Vector2(24.0, 18.0)), reader_color, false, 1.0)
	draw_rect(Rect2(Vector2(248.0, 242.0), Vector2(24.0, 18.0)), public_color, false, 1.0)
	draw_rect(Rect2(Vector2(348.0, 242.0), Vector2(24.0, 18.0)), relational_color, false, 1.0)
	draw_circle(Vector2(430.0, 250.0), 7.0, synthesis_color, false, 2.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_color, 2.0)
