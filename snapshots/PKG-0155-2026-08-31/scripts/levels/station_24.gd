class_name Station24
extends Node2D

## Station 24 — Marta's bounded decision after the dead-circuit result.
## Goal: establish whether notes and a phone may be used for today's test.
## Obstacle: access to a missing person's private life is not interchangeable
## with permission from the person now standing in the room.
## Action: disclose scope, risk and cost; Marta then grants limited access or declines.
## Result: either commitment preserves the shared goal and opens a real technical route.
##
## PRZESZKODA — dlaczego to tu jest: Marta's belongings and UCP telemetry sit
## together because the intervention has put private records beside operating data.
## PRZESZKODA — czego wymaga od Leny: ujawnienia zakresu, ryzyka i kosztu przed
## prośbą o użycie notatek, bez zamieniania osoby w parametr aparatury.
## PRZESZKODA — koszt porażki: niepełne ujawnienie zamyka tylko wybór do czasu
## przeczytania brakującej informacji; odmowa nie zatrzymuje drogi do węzła UCP.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_MECHANIC_COST := &"mechanic_cost_observed"
const FACT_SCOPE_DISCLOSED := &"p7.mutual_test.marta_scope_disclosed"
const FACT_RISK_DISCLOSED := &"p7.mutual_test.marta_risk_disclosed"
const FACT_COST_DISCLOSED := &"p7.mutual_test.marta_cost_disclosed"
const FACT_BOUNDARY := &"p7.mutual_test.marta_boundary"
const FACT_BOUNDARY_ACCEPTED := &"marta_boundary_accepted"
const FACT_DISCLOSURE_FEEDBACK := &"p7.mutual_test.marta_disclosure_feedback"

signal clue_inspected(id: String, prop_type: int)
signal marta_disclosure_completed(disclosure_id: StringName)
signal marta_boundary_committed(boundary: StringName)
signal exit_unlocked()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_scope_disclosed := false
var is_risk_disclosed := false
var is_cost_disclosed := false
var is_choice_active := false
var is_boundary_committed := false
var is_exit_unlocked := false
var is_level_completed := false
var preview_boundary: StringName = &"limited_access"
var committed_boundary: StringName = &""
var _pulse_time := 0.0


func _ready() -> void:
	_setup_camera()
	_setup_props()
	_setup_guidance()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_zone_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_zone_body_entered)
	queue_redraw()


func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)


func _setup_props() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var point := child as MemoryResonancePoint
			if not point.resonance_triggered.is_connected(_on_prop_inspected.bind(point)):
				point.resonance_triggered.connect(_on_prop_inspected.bind(point))


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s24_boundary_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", "")
	_register_beat(&"s24_boundary_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Pudełko zostaje zamknięte. To nie jest mój dostęp.", "The box stays closed. This is not my access.", "")
	_register_beat(&"s24_boundary_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Dostęp do notatek nie jest zgodą na użycie życia Marty.", "Access to notes is not consent to use Marta's life.", "marta_access_equals_consent")
	_register_beat(&"s24_marta_scope", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Najpierw pokażę zakres, ryzyko i koszt. Potem Marta zdecyduje.", "First I will show scope, risk and cost. Then Marta decides.", "")
	_register_beat(&"s24_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Odczytaj trzy informacje, potem wybierz lewo albo prawo. Pomoc nie wybiera za Martę.", "HINT: Read all three disclosures, then choose left or right. Help does not choose for Marta.", "")


func _register_beat(
	beat_id: StringName,
	tier: GuidanceBeat.Tier,
	thought_kind: StringName,
	truth_scope: StringName,
	text_pl: String,
	text_en: String,
	hypothesis_id: StringName
) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_24"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	if hypothesis_id == &"marta_access_equals_consent":
		beat.predicted_check = "disclose_scope_risk_and_cost_before_boundary"
	guidance_service.register_beat(beat)


func _process(delta: float) -> void:
	_pulse_time += delta
	queue_redraw()


func _on_prop_inspected(id: String, prop_type: int, _point: MemoryResonancePoint) -> void:
	match id:
		"prop_cctv_array":
			disclose_marta_scope()
		"prop_correction_gauge":
			disclose_marta_risk()
		"prop_transmission_terminal":
			disclose_marta_cost()
		"prop_disposition_selector":
			open_boundary_choice()
		"prop_station_24_exit":
			if is_exit_unlocked:
				_trigger_level_completion()
	clue_inspected.emit(id, prop_type)


func disclose_marta_scope() -> bool:
	if not _can_disclose() or is_scope_disclosed:
		return false
	is_scope_disclosed = true
	_record(FACT_SCOPE_DISCLOSED, true)
	marta_disclosure_completed.emit(FACT_SCOPE_DISCLOSED)
	_report_disclosure_progress(&"s24_scope")
	return true


func disclose_marta_risk() -> bool:
	if not _can_disclose() or is_risk_disclosed:
		return false
	is_risk_disclosed = true
	_record(FACT_RISK_DISCLOSED, true)
	marta_disclosure_completed.emit(FACT_RISK_DISCLOSED)
	_report_disclosure_progress(&"s24_risk")
	return true


func disclose_marta_cost() -> bool:
	if not _can_disclose() or is_cost_disclosed:
		return false
	is_cost_disclosed = true
	_record(FACT_COST_DISCLOSED, true)
	marta_disclosure_completed.emit(FACT_COST_DISCLOSED)
	_report_disclosure_progress(&"s24_cost")
	return true


func open_boundary_choice() -> bool:
	if is_boundary_committed or not _all_disclosures_complete():
		if not is_boundary_committed:
			_record(FACT_DISCLOSURE_FEEDBACK, "disclosure_incomplete")
		return false
	is_choice_active = true
	if guidance_service:
		guidance_service.report_progress(&"s24_choice_opened")
	queue_redraw()
	return true


func choose_limited_access() -> bool:
	return _commit_boundary(&"limited_access")


func choose_declined() -> bool:
	return _commit_boundary(&"declined")


func _commit_boundary(boundary: StringName) -> bool:
	if is_boundary_committed or not _all_disclosures_complete():
		if not is_boundary_committed:
			_record(FACT_DISCLOSURE_FEEDBACK, "disclosure_incomplete")
		return false
	if boundary != &"limited_access" and boundary != &"declined":
		return false
	committed_boundary = boundary
	preview_boundary = boundary
	is_boundary_committed = true
	is_choice_active = false
	_record(FACT_BOUNDARY, String(boundary))
	_record(FACT_BOUNDARY_ACCEPTED, true)
	marta_boundary_committed.emit(boundary)
	if guidance_service:
		guidance_service.close_hypothesis(&"marta_access_equals_consent")
		guidance_service.report_progress(&"s24_boundary_committed")
	_unlock_exit()
	queue_redraw()
	return true


func _can_disclose() -> bool:
	if _has_decision(FACT_MECHANIC_COST):
		return true
	_record(FACT_DISCLOSURE_FEEDBACK, "dead_circuit_cost_required")
	return false


func _all_disclosures_complete() -> bool:
	return is_scope_disclosed and is_risk_disclosed and is_cost_disclosed


func _report_disclosure_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)
		if _all_disclosures_complete():
			guidance_service.trigger_beat(&"s24_marta_scope")
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if not is_choice_active:
		return
	if event.is_action_pressed(&"move_left"):
		preview_boundary = &"limited_access"
		get_viewport().set_input_as_handled()
		queue_redraw()
	elif event.is_action_pressed(&"move_right"):
		preview_boundary = &"declined"
		get_viewport().set_input_as_handled()
		queue_redraw()
	elif event.is_action_pressed(&"interact"):
		_commit_boundary(preview_boundary)
		get_viewport().set_input_as_handled()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	var exit_point := props.get_node_or_null("Station24Exit") as MemoryResonancePoint
	if exit_point:
		exit_point.is_activated = true
	call_deferred("_complete_if_player_already_in_airlock")


func _complete_if_player_already_in_airlock() -> void:
	if airlock_zone == null or player == null or is_level_completed:
		return
	if airlock_zone.overlaps_body(player):
		_trigger_level_completion()


func _on_airlock_zone_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_exit_unlocked and not is_level_completed:
		_trigger_level_completion()


func _trigger_level_completion() -> void:
	is_level_completed = true
	level_completed.emit()


func _record(decision_id: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(decision_id, value)


func _has_decision(decision_id: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	return state != null and state.decisions.get(decision_id, false) == true


func _draw() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var scope_color := VectorStageStyle.ANCHOR_CYAN if is_scope_disclosed else VectorStageStyle.HUMAN_AMBER
	var risk_color := VectorStageStyle.CORRECTION_OXIDE if is_risk_disclosed else VectorStageStyle.HUMAN_AMBER
	var cost_color := VectorStageStyle.LIGHT_PLANE if is_cost_disclosed else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(Vector2(124.0, 230.0), Vector2(32.0, 20.0)), scope_color, false, 2.0)
	draw_rect(Rect2(Vector2(234.0, 230.0), Vector2(32.0, 20.0)), risk_color, false, 2.0)
	draw_rect(Rect2(Vector2(354.0, 230.0), Vector2(32.0, 20.0)), cost_color, false, 2.0)
	if is_choice_active:
		var selected_x := 452.0 if preview_boundary == &"limited_access" else 512.0
		draw_rect(Rect2(Vector2(selected_x, 232.0), Vector2(40.0, 16.0)), VectorStageStyle.ANCHOR_CYAN, false, 2.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_color, 2.0)
