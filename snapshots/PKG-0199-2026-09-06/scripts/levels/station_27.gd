class_name Station27
extends Node2D
## PRZESZKODA — dlaczego to tu jest: Węzeł impulsowy odróżnia echo urządzenia od sprawczej odpowiedzi przez selektywną korektę kontrolowanego błędu.
## PRZESZKODA — czego wymaga od Leny: Skalibrowania odniesienia, wysłania dwóch identycznych impulsów i trzeciego z błędem, a następnie porównania odpowiedzi.
## PRZESZKODA — koszt porażki: Zła kolejność zawęża model i wskazuje brakujący krok bez resetowania wykonanych impulsów.

## Station 27 — discriminating pulse trial.
## Two identical pulses establish the echo baseline. A third pulse contains one
## deliberate error; a living response corrects only that error.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_RECONSTRUCTED := &"p7.interrupted_trial_and_small_cost.ucp_intervention_reconstructed"
const FACT_LOCAL_SIGNAL := &"p7.interrupted_trial_and_small_cost.local_lena_signal_confirmed"
const FACT_SAFE_FEEDBACK := &"p7.interrupted_trial_and_small_cost.safe_trial_feedback"

const COLOR_BACKGROUND := Color("0c1114")
const COLOR_CONSOLE_FRAME := Color("162026")
const COLOR_MONITOR_SCREEN := Color("1c2830")
const COLOR_INFRASTRUCTURE := Color("456372")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")

signal clue_inspected(id: String, prop_type: int)
signal pulse_sent(pulse_id: StringName)
signal response_correction_compared()
signal safe_trial_feedback_observed(feedback: StringName)
signal exit_unlocked()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_pulse_reference_calibrated := false
var is_first_identical_pulse_sent := false
var is_second_identical_pulse_sent := false
var is_deliberate_error_pulse_sent := false
var is_response_correction_compared := false
var is_exit_unlocked := false
var is_level_completed := false
var _pulse_time := 0.0
var _exit_open_progress := 0.0


func _ready() -> void:
	if player:
		player.position = Vector2(50.0, 240.0)
	_setup_camera()
	_setup_props()
	_setup_guidance()
	if airlock_zone and not airlock_zone.body_entered.is_connected(_on_airlock_zone_body_entered):
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
	_register_beat(&"s27_pulse_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", "")
	_register_beat(&"s27_pulse_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Pulpit przyjmuje dwa identyczne impulsy i jeden kontrolowany błąd.", "The console accepts two identical pulses and one controlled error.", "")
	_register_beat(&"s27_echo_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Echo powtórzy błąd. Żywa odpowiedź może skorygować tylko jego pozycję.", "An echo will repeat the error. A living response may correct only its position.", "own_echo")
	_register_beat(&"s27_error_correction_trial", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Skalibruj odniesienie, wyślij dwa identyczne impulsy, trzeci z błędem i porównaj korektę.", "Calibrate the reference, send two identical pulses, a third with an error, then compare the correction.", "selective_correction_trial")
	_register_beat(&"s27_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: porównanie odpowiedzi jest osobnym działaniem po trzecim impulsie.", "HINT: comparing the response is a separate action after the third pulse.", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_27"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	if hypothesis_id == &"own_echo":
		beat.predicted_check = "only_deliberate_error_is_corrected"
	elif hypothesis_id == &"selective_correction_trial":
		beat.predicted_check = "third_error_only"
	guidance_service.register_beat(beat)


func _process(delta: float) -> void:
	_pulse_time += delta
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 2.0)
	queue_redraw()


func _on_prop_inspected(id: String, prop_type: int, _point: MemoryResonancePoint) -> void:
	match id:
		"prop_worker_badge":
			calibrate_pulse_reference()
		"prop_jakub_operator":
			send_first_identical_pulse()
		"prop_surface_monitor":
			send_second_identical_pulse()
		"prop_junction_console":
			send_deliberate_error_pulse()
		"prop_station_27_exit":
			if is_exit_unlocked:
				_trigger_level_completion()
			else:
				compare_response_correction()
	clue_inspected.emit(id, prop_type)


func calibrate_pulse_reference() -> bool:
	if is_pulse_reference_calibrated:
		return false
	if not _has_true(FACT_RECONSTRUCTED):
		_record_feedback(&"intervention_reconstruction_required")
		return false
	is_pulse_reference_calibrated = true
	_mark_prop("WorkerBadge")
	_report_progress(&"s27_pulse_reference")
	return true


func send_first_identical_pulse() -> bool:
	if is_first_identical_pulse_sent:
		return false
	if not is_pulse_reference_calibrated:
		_record_feedback(&"pulse_reference_required")
		return false
	is_first_identical_pulse_sent = true
	_mark_prop("JakubOperator")
	pulse_sent.emit(&"identical_1")
	_report_progress(&"s27_identical_pulse_1")
	return true


func send_second_identical_pulse() -> bool:
	if is_second_identical_pulse_sent:
		return false
	if not is_first_identical_pulse_sent:
		_record_feedback(&"first_identical_pulse_required")
		return false
	is_second_identical_pulse_sent = true
	_mark_prop("SurfaceMonitor")
	pulse_sent.emit(&"identical_2")
	_report_progress(&"s27_identical_pulse_2")
	return true


func send_deliberate_error_pulse() -> bool:
	if is_deliberate_error_pulse_sent:
		return false
	if not is_second_identical_pulse_sent:
		_record_feedback(&"second_identical_pulse_required")
		return false
	is_deliberate_error_pulse_sent = true
	_mark_prop("JunctionConsole")
	pulse_sent.emit(&"deliberate_error")
	if guidance_service:
		guidance_service.trigger_beat(&"s27_error_correction_trial")
	_report_progress(&"s27_deliberate_error_pulse")
	return true


func compare_response_correction() -> bool:
	if is_response_correction_compared:
		return false
	if not is_pulse_reference_calibrated:
		_record_feedback(&"pulse_reference_required")
		return false
	if not is_first_identical_pulse_sent:
		_record_feedback(&"first_identical_pulse_required")
		return false
	if not is_second_identical_pulse_sent:
		_record_feedback(&"second_identical_pulse_required")
		return false
	if not is_deliberate_error_pulse_sent:
		_record_feedback(&"deliberate_error_pulse_required")
		return false
	is_response_correction_compared = true
	_record(FACT_LOCAL_SIGNAL, true)
	_record(&"local_lena_signal_confirmed", true)
	response_correction_compared.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"own_echo")
		guidance_service.report_progress(&"s27_response_correction_compared")
	_unlock_exit()
	return true


func unlock_exit_door() -> bool:
	if is_exit_unlocked:
		return false
	_unlock_exit()
	return true


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_mark_prop("Station27Exit")
	call_deferred("_complete_if_player_already_in_airlock")
	queue_redraw()


func _complete_if_player_already_in_airlock() -> void:
	if airlock_zone and player and airlock_zone.overlaps_body(player):
		_trigger_level_completion()


func _on_airlock_zone_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_exit_unlocked:
		_trigger_level_completion()


func _trigger_level_completion() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _mark_prop(node_name: StringName) -> void:
	if props == null:
		return
	var point := props.get_node_or_null(NodePath(String(node_name))) as MemoryResonancePoint
	if point:
		point.is_activated = true


func _has_true(decision_id: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	return state != null and state.decisions.get(decision_id, false) == true


func _record_feedback(value: StringName) -> void:
	_record(FACT_SAFE_FEEDBACK, String(value))
	safe_trial_feedback_observed.emit(value)
	if guidance_service:
		guidance_service.report_failed_attempt(StringName("s27_" + String(value)))


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)
	queue_redraw()


func _record(decision_id: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(decision_id, value)


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	draw_rect(Rect2(Vector2(60.0, 170.0), Vector2(140.0, 110.0)), COLOR_CONSOLE_FRAME, true)
	draw_rect(Rect2(Vector2(70.0, 180.0), Vector2(120.0, 90.0)), COLOR_MONITOR_SCREEN, true)
	draw_rect(Rect2(Vector2(240.0, 170.0), Vector2(240.0, 110.0)), COLOR_INFRASTRUCTURE, true)
	var pulse_colors: Array[Color] = [
		COLOR_CYAN if is_first_identical_pulse_sent else COLOR_CORRECTION,
		COLOR_CYAN if is_second_identical_pulse_sent else COLOR_CORRECTION,
		COLOR_CORRECTION if is_deliberate_error_pulse_sent else COLOR_BACKGROUND,
	]
	for index in range(3):
		draw_line(Vector2(278.0 + index * 54.0, 246.0), Vector2(310.0 + index * 54.0, 246.0), pulse_colors[index], 3.0)
	if is_response_correction_compared:
		draw_line(Vector2(402.0, 236.0), Vector2(418.0, 246.0), COLOR_CYAN, 2.0)
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
