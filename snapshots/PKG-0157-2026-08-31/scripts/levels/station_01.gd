class_name Station01
extends Node2D

## Station 01 — human worksite.
## Lena is finishing one vibration reading near Line 4. The machine works without
## her; she decides whether to repeat, preserve the raw sample, and answer Marta.
##
## PRZESZKODA — dlaczego to tu jest: Stanowisko pomiarowe wymaga domknięcia jednej serii, bo surowy zapis i powtórka muszą dać się porównać po zakończeniu zmiany.
## PRZESZKODA — czego wymaga od Leny: powtórzenia odczytu, zabezpieczenia próbki i przyjęcia ceny opóźnienia wobec Marty.
## PRZESZKODA — koszt porażki: wyjście bez zabezpieczonej próbki zostawia jej tylko raport z artefaktem, a Marta nadal nie wie, czy Lena jedzie.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_GAP := &"p7.sample_and_promise.gap_observed"
const FACT_MOUNT := &"p7.sample_and_promise.mount_checked"
const FACT_RAW := &"p7.sample_and_promise.raw_record_checked"
const FACT_RESULT := &"p7.sample_and_promise.measurement_result"
const FACT_SAMPLE := &"p7.sample_and_promise.sample_preserved"
const FACT_FEEDBACK := &"p7.sample_and_promise.safe_trial_feedback"

signal measurement_repeated()
signal sample_secured()
signal marta_message_read()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var props: Node2D = $Props
@onready var chamber_door: AnimatableBody2D = $ChamberDoor
@onready var airlock_zone: Area2D = $AirlockZone
@onready var dialogue: CRTDialogueBox = $CRTDialogueBox

var is_measurement_repeated := false
var is_sample_secured := false
var is_marta_message_read := false
var is_exit_unlocked := false
var is_level_completed := false


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_action_points()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	_set_action_available(&"secure_raw_sample", false)
	_set_action_available(&"read_marta_message", false)
	queue_redraw()


func _connect_action_points() -> void:
	for child in props.get_children():
		if child is OpeningActionPoint:
			var action := child as OpeningActionPoint
			if not action.action_requested.is_connected(_on_action_requested):
				action.action_requested.connect(_on_action_requested)


func _on_action_requested(action_id: StringName) -> void:
	match action_id:
		&"repeat_line_four_measurement":
			repeat_line_four_measurement()
		&"secure_raw_sample":
			secure_raw_sample()
		&"read_marta_message":
			read_marta_message()


func repeat_line_four_measurement() -> bool:
	if is_measurement_repeated:
		return false
	is_measurement_repeated = true
	_record(FACT_GAP, true)
	_record(FACT_MOUNT, true)
	_record(FACT_RAW, true)
	_record(FACT_RESULT, "gap_retained_after_clean_repeat")
	_record(&"p9.opening.line_four_gap_seen", true)
	_resolve_action(&"repeat_line_four_measurement")
	_set_action_available(&"secure_raw_sample", true)
	measurement_repeated.emit()
	_present([
		{"speaker": "LENA", "text": "Mocowanie jest czyste. Zapis dalej gubi trzy sekundy."},
	])
	queue_redraw()
	return true


func secure_raw_sample() -> bool:
	if not is_measurement_repeated or is_sample_secured:
		_record_feedback(&"measurement_required")
		return false
	is_sample_secured = true
	_record(FACT_SAMPLE, true)
	_record(&"home_sample_preserved", true)
	_record(&"p9.opening.sample_carried_home", true)
	_resolve_action(&"secure_raw_sample")
	_set_action_available(&"read_marta_message", true)
	sample_secured.emit()
	_present([
		{"speaker": "LENA", "text": "Biorę surową próbkę. Raport może poczekać."},
	])
	queue_redraw()
	return true


func read_marta_message() -> bool:
	if not is_sample_secured or is_marta_message_read:
		_record_feedback(&"sample_required")
		return false
	is_marta_message_read = true
	_record(&"p9.opening.marta_waiting", true)
	_resolve_action(&"read_marta_message")
	marta_message_read.emit()
	_present([
		{"speaker": "MARTA", "text": "Miałyśmy zacząć o wpół do dziewiątej. Napisz tylko, czy jedziesz."},
		{"speaker": "LENA", "text": "Jadę. Jeszcze tylko zabezpieczyłam próbkę."},
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
	if chamber_door != null:
		ExitClearance.open_body_tweened(self, chamber_door)
	call_deferred("_complete_if_player_already_in_airlock")


func _complete_if_player_already_in_airlock() -> void:
	if airlock_zone != null and player != null and airlock_zone.overlaps_body(player):
		_trigger_level_completion()


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s01_composition", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")

func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_01"
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
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), VectorStageStyle.INK)
	draw_rect(Rect2(18.0, 44.0, 604.0, 262.0), VectorStageStyle.DEEP_PLANE)
	draw_rect(Rect2(18.0, 306.0, 604.0, 54.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.30))
	draw_line(Vector2(18.0, 306.0), Vector2(622.0, 306.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	# Machine: one clear job, one moving recorder drum and a path to the exit.
	draw_colored_polygon(PackedVector2Array([
		Vector2(70.0, 92.0), Vector2(318.0, 76.0), Vector2(342.0, 286.0), Vector2(54.0, 294.0),
	]), VectorStageStyle.MID_PLANE)
	draw_rect(Rect2(176.0, 148.0, 122.0, 100.0), VectorStageStyle.DEEP_PLANE)
	draw_rect(Rect2(194.0, 164.0, 86.0, 54.0), VectorStageStyle.INK)
	var drum_color := VectorStageStyle.CORRECTION_OXIDE if is_measurement_repeated else VectorStageStyle.HUMAN_AMBER
	draw_circle(Vector2(237.0, 191.0), 22.0, drum_color, false, 3.0)
	draw_line(Vector2(237.0, 166.0), Vector2(237.0, 216.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	draw_line(Vector2(210.0, 191.0), Vector2(264.0, 191.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	for x in [96.0, 126.0, 314.0, 350.0, 382.0]:
		draw_line(Vector2(x, 84.0), Vector2(x + 28.0, 146.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.28), 4.0)
	# The sample case and phone establish the two private consequences of the job.
	var sample_color := VectorStageStyle.ANCHOR_CYAN if is_sample_secured else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(344.0, 250.0, 62.0, 28.0), sample_color, false, 2.0)
	draw_line(Vector2(350.0, 260.0), Vector2(400.0, 260.0), sample_color, 1.0)
	var phone_color := VectorStageStyle.LIGHT_PLANE if is_marta_message_read else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.40)
	draw_rect(Rect2(444.0, 236.0, 30.0, 48.0), VectorStageStyle.INK)
	draw_rect(Rect2(448.0, 242.0, 22.0, 28.0), phone_color, false, 1.5)
	# Airlock reads as a door, not a terminal; it opens only after the message.
	draw_rect(Rect2(530.0, 82.0, 70.0, 210.0), VectorStageStyle.DEEP_PLANE)
	draw_rect(Rect2(540.0, 112.0, 48.0, 58.0), VectorStageStyle.LIGHT_PLANE)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(566.0, 176.0), Vector2(566.0, 292.0), exit_color, 3.0)
