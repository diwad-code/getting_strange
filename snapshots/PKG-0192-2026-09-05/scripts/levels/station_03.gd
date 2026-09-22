class_name Station03
extends Node2D

## Station 03 — believable Line 4 stop.
## The timetable and Marta's message make the delay personal; boarding is a
## spatial threshold through a vehicle that arrives on its own schedule.
##
## PRZESZKODA — dlaczego to tu jest: Linia 4 utrzymuje nocny kurs przez przystanek, a ograniczony rozkład zmusza spóźnioną Lenę do sprawdzenia realnego czasu odjazdu.
## PRZESZKODA — czego wymaga od Leny: odczytania rozkładu, uczciwej odpowiedzi Marcie i wejścia do nadjeżdżającego wagonu.
## PRZESZKODA — koszt porażki: zatajenie opóźnienia nie zmienia kursu, tylko oddala Lenę od osoby, do której jedzie.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_ROUTE_TIME := &"p7.sample_and_promise.route_time_confirmed"
const FACT_DEPARTURE := &"p7.sample_and_promise.departure_time_observed"
const FACT_NOTICE := &"p7.sample_and_promise.time_notice_sent"
const FACT_TRACE := &"p7.sample_and_promise.trace"
const FACT_FEEDBACK := &"p7.sample_and_promise.safe_trial_feedback"
const OPENING_CHOICE := &"p9.opening.choice"

signal departure_board_read()
signal marta_reply_sent()
signal line_four_boarded()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var props: Node2D = $Props
@onready var transit_door: AnimatableBody2D = $TransitDoor
@onready var airlock_zone: Area2D = $AirlockZone
@onready var dialogue: CRTDialogueBox = $CRTDialogueBox

var is_departure_board_read := false
var is_marta_reply_sent := false
var is_line_four_boarded := false
var is_exit_unlocked := false
var is_level_completed := false
var _tram_phase := 0.0


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_action_points()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	_set_action_available(&"reply_to_marta", false)
	queue_redraw()


func _process(delta: float) -> void:
	var motion := MotionAccessibility.motion_scale()
	if motion <= 0.0 or is_marta_reply_sent:
		return
	_tram_phase = fposmod(_tram_phase + delta * 56.0 * motion, 840.0)
	queue_redraw()


func _connect_action_points() -> void:
	for child in props.get_children():
		if child is OpeningActionPoint:
			var action := child as OpeningActionPoint
			if not action.action_requested.is_connected(_on_action_requested):
				action.action_requested.connect(_on_action_requested)


func _on_action_requested(action_id: StringName) -> void:
	match action_id:
		&"read_departure_board":
			read_departure_board()
		&"reply_to_marta":
			reply_to_marta()


func read_departure_board() -> bool:
	if is_departure_board_read:
		return false
	if not _has(FACT_ROUTE_TIME):
		_record_feedback(&"route_time_required")
		preload("res://scripts/campaign/gap_ledger.gd").annotate_feedback(self, &"route_time_required")
		return false
	is_departure_board_read = true
	_record(FACT_DEPARTURE, true)
	_record(&"p9.opening.line_four_departure_seen", true)
	_resolve_action(&"read_departure_board")
	_set_action_available(&"reply_to_marta", true)
	departure_board_read.emit()
	_present([
		{"speaker": "LENA", "text": "Linia 4 za trzy minuty. Zdążę tylko, jeśli przestanę pracować."},
	])
	queue_redraw()
	return true


func reply_to_marta() -> bool:
	if not is_departure_board_read or is_marta_reply_sent:
		_record_feedback(&"departure_required")
		preload("res://scripts/campaign/gap_ledger.gd").annotate_feedback(self, &"departure_required")
		return false
	is_marta_reply_sent = true
	_record(FACT_NOTICE, true)
	var repeated_sample := _decision_string(OPENING_CHOICE) != "leave_on_time"
	_record(FACT_TRACE, "sample_preserved_and_time_sent" if repeated_sample else "equipment_packed_and_departure_confirmed")
	_record(&"marta_promise_broken", repeated_sample)
	_record(&"p9.opening.marta_knows_delay", true)
	_resolve_action(&"reply_to_marta")
	marta_reply_sent.emit()
	if repeated_sample:
		_present([
			{"speaker": "MARTA", "text": "Miałaś wrócić wcześniej. Napisz tylko, czy jedziesz."},
			{"speaker": "LENA", "text": "Jadę. Będę później o dwanaście minut."},
		])
	else:
		_present([
			{"speaker": "MARTA", "text": "Widzę zamknięcie na trasie. Jedź spokojnie, herbata czeka."},
			{"speaker": "LENA", "text": "Jadę. Tym razem wyszłam z pracy wtedy, kiedy obiecałam."},
		])
	_unlock_exit()
	queue_redraw()
	return true


func board_line_four() -> bool:
	if is_line_four_boarded:
		_trigger_level_completion()
		return true
	if not is_marta_reply_sent:
		_record_feedback(&"marta_reply_required")
		preload("res://scripts/campaign/gap_ledger.gd").annotate_feedback(self, &"marta_reply_required")
	is_line_four_boarded = true
	_record(&"p9.opening.line_four_boarded", true)
	line_four_boarded.emit()
	_trigger_level_completion()
	queue_redraw()
	return true


func unlock_exit_for_return() -> void:
	_unlock_exit()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	if transit_door != null:
		ExitClearance.disable_collision(transit_door)
	pass  # PKG-0174: ThresholdZone requires interact


func _complete_if_player_already_in_airlock() -> void:
	if airlock_zone != null and player != null and airlock_zone.overlaps_body(player):
		board_line_four()


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s03_composition", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")

func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_03"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	beat.predicted_check = predicted_check
	guidance_service.register_beat(beat)

func _on_airlock_body_entered(_body: Node2D) -> void:
	# PKG-0174: AirlockZone is a closure zone, not a trigger.
	pass


func _trigger_level_completion() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _has(key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	return state != null and bool(state.decisions.get(key, false))


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
	_draw_transit_stop()


func _draw_transit_stop() -> void:
	VectorStageStyle.draw_stage_apron(self, Vector2(640.0, 360.0))
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), Color("0d151d"))
	draw_rect(Rect2(0.0, 0.0, 640.0, 126.0), Color("1b2934"))
	# Partial shelter: roof and posts occupy only the left half of the platform.
	draw_colored_polygon(PackedVector2Array([
		Vector2(44.0, 92.0), Vector2(318.0, 78.0), Vector2(334.0, 104.0), Vector2(52.0, 118.0),
	]), VectorStageStyle.MID_PLANE)
	draw_line(Vector2(56.0, 116.0), Vector2(58.0, 276.0), VectorStageStyle.LIGHT_PLANE, 4.0)
	draw_line(Vector2(296.0, 104.0), Vector2(300.0, 270.0), VectorStageStyle.LIGHT_PLANE, 4.0)
	draw_rect(Rect2(104.0, 230.0, 132.0, 18.0), VectorStageStyle.DEEP_PLANE)
	draw_line(Vector2(104.0, 230.0), Vector2(236.0, 230.0), VectorStageStyle.LIGHT_PLANE, 1.5)
	# Platform edge and track split the image horizontally before any text is read.
	draw_colored_polygon(PackedVector2Array([
		Vector2(0.0, 280.0), Vector2(640.0, 270.0), Vector2(640.0, 306.0), Vector2(0.0, 316.0),
	]), VectorStageStyle.MID_PLANE)
	draw_line(Vector2(0.0, 280.0), Vector2(640.0, 270.0), VectorStageStyle.HUMAN_AMBER, 3.0)
	draw_line(Vector2(0.0, 310.0), Vector2(640.0, 300.0), VectorStageStyle.INK, 3.0)
	draw_line(Vector2(0.0, 334.0), Vector2(640.0, 324.0), VectorStageStyle.INK, 3.0)
	# PKG-0187: the scheduled vehicle must be legible in the first quiet frame,
	# not only after its narrative state changes. It still moves for its own
	# timetable; the small drift is scenery, never a timing target.
	var vehicle_x := 382.0 if is_marta_reply_sent else 394.0 + sin(_tram_phase * 0.018) * 18.0
	draw_rect(Rect2(vehicle_x, 136.0, 252.0, 132.0), VectorStageStyle.DEEP_PLANE)
	draw_line(Vector2(vehicle_x, 136.0), Vector2(vehicle_x + 252.0, 136.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	for window_x in [vehicle_x + 18.0, vehicle_x + 78.0, vehicle_x + 138.0, vehicle_x + 198.0]:
		draw_rect(Rect2(window_x, 158.0, 42.0, 48.0), VectorStageStyle.INK)
		draw_line(Vector2(window_x + 3.0, 164.0), Vector2(window_x + 37.0, 164.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.34), 1.0)
	pass  # PKG-0174: vehicle aperture
	# A single practical light points to the waiting area without becoming a quest marker.
	var board_color := VectorStageStyle.LIGHT_PLANE if is_departure_board_read else VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.36)
	draw_rect(Rect2(152.0, 128.0, 86.0, 42.0), VectorStageStyle.INK)
	draw_rect(Rect2(158.0, 134.0, 74.0, 30.0), board_color, false, 1.5)
	var phone_color := VectorStageStyle.ANCHOR_CYAN if is_marta_reply_sent else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.42)
	draw_rect(Rect2(292.0, 244.0, 26.0, 38.0), phone_color, false, 1.5)
