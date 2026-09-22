class_name Station26
extends Node2D
## PRZESZKODA — dlaczego to tu jest: Analizator rozdziela log próby i awaryjną komendę UCP, ponieważ oba źródła pracują na niezależnych zegarach.
## PRZESZKODA — czego wymaga od Leny: Odczytania logu, zsynchronizowania trzech zegarów i jawnego odtworzenia kolejności.
## PRZESZKODA — koszt porażki: Błędna kolejność zostawia informacyjny ślad o pierwszym brakującym źródle bez utraty danych.

## Station 26 — reconstruction of the interrupted UCP intervention.
## The station does not accept the log timestamp as an answer: Lena must align
## the sample, UCP command and local-generator clocks before reconstructing it.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_ENTRY := &"p7.three_place_proofs.trace"
const FACT_RECONSTRUCTED := &"p7.interrupted_trial_and_small_cost.ucp_intervention_reconstructed"
const FACT_SAFE_FEEDBACK := &"p7.interrupted_trial_and_small_cost.safe_trial_feedback"

const COLOR_BACKGROUND := Color("0b1013")
const COLOR_WALL_PANEL := Color("151e24")
const COLOR_WALL_ACCENT := Color("202c34")
const COLOR_INFRASTRUCTURE := Color("405e6c")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")

enum RoomState {
	RESIDENTIAL = 0,
	ARCHIVE = 1,
	SEDATION = 2,
}

signal clue_inspected(id: String, prop_type: int)
signal clock_synchronized(clock_id: StringName)
signal ucp_intervention_reconstructed()
signal safe_trial_feedback_observed(feedback: StringName)
signal exit_unlocked()
signal level_completed()
signal previous_level_requested()
signal room_state_changed(new_state: RoomState)

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_interrupted_ucp_log_observed := false
var is_sample_clock_synchronized := false
var is_ucp_command_clock_synchronized := false
var is_local_generator_clock_synchronized := false
var is_ucp_intervention_reconstructed := false
var is_exit_unlocked := false
var is_level_completed := false
var current_room_state := RoomState.RESIDENTIAL

var partition_cycle_time := 0.0
var is_partition_open := false
var partition_correction_count := 0
var partition_detail_faded := false
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
	_register_beat(&"s26_interrupted_log_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", "")
	_register_beat(&"s26_interrupted_log_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Log UCP i próbka wskazują różne chwile.", "The UCP log and the sample point to different moments.", "")
	_register_beat(&"s26_clock_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Późniejsza komenda UCP może wyglądać jak przyczyna, jeśli zegary nie mają wspólnego zera.", "A later UCP command can look causal when the clocks do not share a zero point.", "late_ucp_intervention")
	_register_beat(&"s26_three_clock_reconstruction", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zsynchronizuj zegar próbki, komendy UCP i lokalnego generatora, potem odtwórz kolejność.", "Synchronize the sample, UCP command and local-generator clocks, then reconstruct the order.", "three_clock_trial")
	_register_beat(&"s26_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: najpierw log, potem trzy zegary. Rekonstrukcja jest osobnym działaniem.", "HINT: inspect the log, then align all three clocks. Reconstruction is a separate action.", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_26"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	if hypothesis_id == &"late_ucp_intervention":
		beat.predicted_check = "sample_ucp_and_local_generator_clock_order"
	elif hypothesis_id == &"three_clock_trial":
		beat.predicted_check = "contact_precedes_ucp_anchor_command"
	guidance_service.register_beat(beat)


func _process(delta: float) -> void:
	_pulse_time += delta
	partition_cycle_time += delta
	_update_partition_cycle()
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 2.0)
	queue_redraw()


func _on_prop_inspected(id: String, prop_type: int, _point: MemoryResonancePoint) -> void:
	match id:
		"prop_isolation_console":
			observe_interrupted_ucp_log()
		"prop_room_designator":
			synchronize_sample_clock()
		"prop_pa_speaker":
			synchronize_ucp_command_clock()
		"prop_motivation_anchor":
			synchronize_local_generator_clock()
		"prop_station_26_exit":
			if is_exit_unlocked:
				_trigger_level_completion()
			else:
				reconstruct_ucp_intervention()
	clue_inspected.emit(id, prop_type)


func observe_interrupted_ucp_log() -> bool:
	if is_interrupted_ucp_log_observed:
		return false
	if not _has_entry_trace():
		_record_feedback(&"entry_trace_required")
		return false
	is_interrupted_ucp_log_observed = true
	_mark_prop("IsolationConsole")
	_report_progress(&"s26_interrupted_log_observed")
	return true


func synchronize_sample_clock() -> bool:
	if is_sample_clock_synchronized:
		return false
	if not is_interrupted_ucp_log_observed:
		_record_feedback(&"interrupted_log_required")
		return false
	is_sample_clock_synchronized = true
	_mark_prop("RoomDesignator")
	clock_synchronized.emit(&"sample")
	_report_progress(&"s26_sample_clock")
	return true


func synchronize_ucp_command_clock() -> bool:
	if is_ucp_command_clock_synchronized:
		return false
	if not is_sample_clock_synchronized:
		_record_feedback(&"sample_clock_required")
		return false
	is_ucp_command_clock_synchronized = true
	_mark_prop("PASpeaker")
	clock_synchronized.emit(&"ucp_command")
	_report_progress(&"s26_ucp_command_clock")
	return true


func synchronize_local_generator_clock() -> bool:
	if is_local_generator_clock_synchronized:
		return false
	if not is_ucp_command_clock_synchronized:
		_record_feedback(&"ucp_command_clock_required")
		return false
	is_local_generator_clock_synchronized = true
	_mark_prop("MotivationAnchor")
	clock_synchronized.emit(&"local_generator")
	_report_progress(&"s26_local_generator_clock")
	return true


func reconstruct_ucp_intervention() -> bool:
	if is_ucp_intervention_reconstructed:
		return false
	if not is_interrupted_ucp_log_observed:
		_record_feedback(&"interrupted_log_required")
		return false
	if not is_sample_clock_synchronized:
		_record_feedback(&"sample_clock_required")
		return false
	if not is_ucp_command_clock_synchronized:
		_record_feedback(&"ucp_command_clock_required")
		return false
	if not is_local_generator_clock_synchronized:
		_record_feedback(&"local_generator_clock_required")
		return false
	is_ucp_intervention_reconstructed = true
	set_room_state(RoomState.ARCHIVE)
	_record(FACT_RECONSTRUCTED, true)
	_record(&"ucp_intervention_reconstructed", true)
	ucp_intervention_reconstructed.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"late_ucp_intervention")
		guidance_service.report_progress(&"s26_intervention_reconstructed")
	_unlock_exit()
	return true


func unlock_exit_door() -> bool:
	if is_exit_unlocked:
		return false
	_unlock_exit()
	return true


func set_room_state(new_state: RoomState) -> void:
	current_room_state = new_state
	room_state_changed.emit(new_state)


func _update_partition_cycle() -> void:
	var partition := geometry.get_node_or_null("AdaptiveIsolationPartition") as AnimatableBody2D
	if current_room_state == RoomState.SEDATION and partition_cycle_time >= 1.5:
		is_partition_open = true
		if partition:
			partition.position = Vector2(380.0, 170.0)
	else:
		is_partition_open = false
		if partition:
			partition.position = Vector2(360.0, 170.0)


func _apply_isolation_correction() -> void:
	partition_correction_count += 1
	partition_detail_faded = true
	set_room_state(RoomState.RESIDENTIAL)
	if player:
		player.global_position = Vector2(50.0, 240.0)


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	var partition := geometry.get_node_or_null("AdaptiveIsolationPartition") as Node2D
	if partition:
		ExitClearance.open_body_tweened(self, partition)
	_mark_prop("Station26Exit")
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


func _has_entry_trace() -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	return state != null and not String(state.decisions.get(FACT_ENTRY, "")).is_empty()


func _record_feedback(value: StringName) -> void:
	_record(FACT_SAFE_FEEDBACK, String(value))
	safe_trial_feedback_observed.emit(value)
	if guidance_service:
		guidance_service.report_failed_attempt(StringName("s26_" + String(value)))


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
	draw_rect(Rect2(Vector2(60.0, 160.0), Vector2(160.0, 120.0)), COLOR_WALL_PANEL, true)
	draw_rect(Rect2(Vector2(260.0, 160.0), Vector2(160.0, 120.0)), COLOR_WALL_ACCENT, true)
	draw_rect(Rect2(Vector2(440.0, 180.0), Vector2(120.0, 100.0)), COLOR_INFRASTRUCTURE, true)
	var clocks := int(is_sample_clock_synchronized) + int(is_ucp_command_clock_synchronized) + int(is_local_generator_clock_synchronized)
	for index in range(3):
		var clock_color := COLOR_CYAN if index < clocks else COLOR_CORRECTION
		draw_circle(Vector2(132.0 + index * 58.0, 250.0), 7.0, clock_color, false, 2.0)
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
