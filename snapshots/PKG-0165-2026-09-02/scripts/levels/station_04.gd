class_name Station04
extends Node2D

## Station 04 — Line 4 ride.
## The carriage keeps moving while Lena compares the buffered gap with the city
## outside, then puts the reader away because Marta is still waiting at home.
##
## PRZESZKODA — dlaczego to tu jest: Nocny wagon jedzie do dzielnicy Leny według rozkładu, a bufor czytnika utrzymuje zapis niezależnie od ruchu pojazdu.
## PRZESZKODA — czego wymaga od Leny: sprawdzenia bufora, spojrzenia na ślad katastrofy za oknem i odłożenia czytnika przed wysiadką.
## PRZESZKODA — koszt porażki: dalsza praca w wagonie nie naprawi luki, a tylko odbierze Marcie kolejne minuty oczekiwania.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_S01_TRACE := &"p7.sample_and_promise.trace"
const FACT_READER := &"p7.return_under_control.reader_repeat_observed"
const FACT_CLOCK := &"p7.return_under_control.wagon_clock_observed"
const FACT_RESULT := &"p7.return_under_control.repeat_result"
const FACT_TRACE := &"p7.return_under_control.trace"
const FACT_FEEDBACK := &"p7.return_under_control.safe_trial_feedback"
const OPENING_CHOICE := &"p9.opening.choice"

signal reader_buffer_observed()
signal line_four_memorial_seen()
signal reader_stowed()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var props: Node2D = $Props
@onready var exit_doors: AnimatableBody2D = $ExitDoors
@onready var airlock_zone: Area2D = $AirlockZone
@onready var dialogue: CRTDialogueBox = $CRTDialogueBox

var is_reader_buffer_observed := false
var is_line_four_memorial_seen := false
var is_reader_stowed := false
var is_exit_unlocked := false
var is_level_completed := false
var _window_motion := 0.0


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_action_points()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	_set_action_available(&"watch_line_four_memorial", false)
	_set_action_available(&"stow_reader_for_marta", false)
	queue_redraw()


func _process(delta: float) -> void:
	var motion := MotionAccessibility.motion_scale()
	if motion <= 0.0:
		return
	_window_motion = fposmod(_window_motion + delta * 74.0 * motion, 240.0)
	queue_redraw()


func _connect_action_points() -> void:
	for child in props.get_children():
		if child is OpeningActionPoint:
			var action := child as OpeningActionPoint
			if not action.action_requested.is_connected(_on_action_requested):
				action.action_requested.connect(_on_action_requested)


func _on_action_requested(action_id: StringName) -> void:
	match action_id:
		&"observe_reader_buffer":
			observe_reader_buffer()
		&"watch_line_four_memorial":
			watch_line_four_memorial()
		&"stow_reader_for_marta":
			stow_reader_for_marta()


func observe_reader_buffer() -> bool:
	if is_reader_buffer_observed:
		return false
	if not _has_trace(FACT_S01_TRACE):
		_record_feedback(&"sample_trace_required")
		return false
	is_reader_buffer_observed = true
	_record(FACT_READER, true)
	var repeated_sample := _decision_string(OPENING_CHOICE) != "leave_on_time"
	_record(&"p9.opening.reader_gap_returns_in_transit", repeated_sample)
	_record(&"p9.opening.packed_reader_checked_in_transit", not repeated_sample)
	_resolve_action(&"observe_reader_buffer")
	_set_action_available(&"watch_line_four_memorial", true)
	reader_buffer_observed.emit()
	_present([
		{"speaker": "LENA", "text": "Ten sam brak. Wagon jedzie, a bufor znów traci trzy sekundy." if repeated_sample else "Czytnik jest spakowany. Luka została bez drugiego pomiaru — tak wybrałam."},
	])
	queue_redraw()
	return true


func watch_line_four_memorial() -> bool:
	if not is_reader_buffer_observed or is_line_four_memorial_seen:
		_record_feedback(&"reader_required")
		return false
	is_line_four_memorial_seen = true
	_record(FACT_CLOCK, true)
	_record(&"p9.opening.line_four_memorial_seen", true)
	_resolve_action(&"watch_line_four_memorial")
	_set_action_available(&"stow_reader_for_marta", true)
	line_four_memorial_seen.emit()
	_present([
		{"speaker": "LENA", "text": "Pomnik Linii 4. Nie patrzę na niego od dziewięciu lat."},
	])
	queue_redraw()
	return true


func stow_reader_for_marta() -> bool:
	if not is_line_four_memorial_seen or is_reader_stowed:
		_record_feedback(&"memorial_required")
		return false
	is_reader_stowed = true
	_record(FACT_RESULT, "reader_stowed_after_line_four_memorial")
	_record(FACT_TRACE, "reader_secured_after_line_four_memorial")
	_record(&"p9.opening.reader_put_away_for_marta", true)
	_resolve_action(&"stow_reader_for_marta")
	reader_stowed.emit()
	_present([
		{"speaker": "LENA", "text": "Marta czeka. Czytnik odkładam do domu."},
	])
	_unlock_exit()
	queue_redraw()
	return true


func unlock_exit_for_return() -> void:
	_unlock_exit()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	if exit_doors != null:
		ExitClearance.open_body_tweened(self, exit_doors)
	call_deferred("_complete_if_player_already_in_airlock")


func _complete_if_player_already_in_airlock() -> void:
	if airlock_zone != null and player != null and airlock_zone.overlaps_body(player):
		_trigger_level_completion()


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s04_composition", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")

func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_04"
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


func _trigger_level_completion() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _has_trace(key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	return state != null and not String(state.decisions.get(key, "")).is_empty()


func _decision_string(key: StringName) -> String:
	var state := get_node_or_null("/root/GameStateManager")
	return "" if state == null else String(state.decisions.get(key, ""))


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
	_draw_transit_carriage()


func _draw_transit_carriage() -> void:
	VectorStageStyle.draw_stage_apron(self, Vector2(640.0, 360.0))
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), Color("101820"))
	# Carriage roof, handrail and seats make a long enclosed vehicle rather than a room.
	draw_colored_polygon(PackedVector2Array([
		Vector2(0.0, 38.0), Vector2(640.0, 52.0), Vector2(640.0, 102.0), Vector2(0.0, 92.0),
	]), VectorStageStyle.DEEP_PLANE)
	draw_line(Vector2(30.0, 72.0), Vector2(570.0, 82.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	draw_line(Vector2(34.0, 94.0), Vector2(552.0, 104.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.42), 1.0)
	# Window rhythm: the exterior slides horizontally behind every frame.
	for window_x in [46.0, 154.0, 262.0, 370.0, 478.0]:
		draw_rect(Rect2(window_x, 116.0, 82.0, 94.0), VectorStageStyle.INK)
		var outside_shift := fposmod(_window_motion + window_x, 120.0)
		draw_rect(Rect2(window_x + 4.0, 120.0, 74.0, 38.0), Color("263949"))
		draw_line(Vector2(window_x + 5.0 - outside_shift, 153.0), Vector2(window_x + 88.0 - outside_shift, 145.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.38), 2.0)
		draw_line(Vector2(window_x + 10.0 - outside_shift, 136.0), Vector2(window_x + 70.0 - outside_shift, 136.0), VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.52), 1.0)
	# The memorial is a concrete silhouette outside one window, not a named HUD fact.
	var memorial_color := VectorStageStyle.LIGHT_PLANE if is_line_four_memorial_seen else VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.26)
	draw_rect(Rect2(394.0, 128.0, 24.0, 58.0), memorial_color)
	draw_circle(Vector2(406.0, 140.0), 7.0, VectorStageStyle.CORRECTION_OXIDE, false, 1.5)
	draw_colored_polygon(PackedVector2Array([
		Vector2(0.0, 252.0), Vector2(540.0, 242.0), Vector2(560.0, 300.0), Vector2(0.0, 314.0),
	]), VectorStageStyle.MID_PLANE)
	for seat_x in [88.0, 206.0, 324.0, 442.0]:
		draw_rect(Rect2(seat_x, 226.0, 52.0, 34.0), VectorStageStyle.DEEP_PLANE)
		draw_line(Vector2(seat_x, 226.0), Vector2(seat_x + 52.0, 226.0), VectorStageStyle.LIGHT_PLANE, 1.5)
	draw_colored_polygon(PackedVector2Array([
		Vector2(0.0, 300.0), Vector2(640.0, 286.0), Vector2(640.0, 360.0), Vector2(0.0, 360.0),
	]), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.26))
	var reader_color := VectorStageStyle.CORRECTION_OXIDE if is_reader_buffer_observed else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(174.0, 264.0, 26.0, 18.0), reader_color, false, 2.0)
	var case_color := VectorStageStyle.ANCHOR_CYAN if is_reader_stowed else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(448.0, 262.0, 50.0, 24.0), case_color, false, 2.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(560.0, 118.0, 58.0, 172.0), VectorStageStyle.INK)
	draw_line(Vector2(589.0, 126.0), Vector2(589.0, 284.0), exit_color, 3.0)
