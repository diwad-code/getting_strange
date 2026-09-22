class_name Station33
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Szyb wentylacyjny łączy poziom depozytów z centralną maszynownią Podstruktury i zabezpiecza magistralę kablową.
## PRZESZKODA — czego wymaga od Leny: Zbadania ciągu drabin i manometru, odnalezienia notatki z warunkiem przerwania po 3 s oraz rekonstrukcji intencji miejscowej Leny.
## PRZESZKODA — koszt porażki: Próba otwarcia dolnego włazu dekompresyjnego bez zrekonstruowania intencji miejscowej Leny blokuje rygiel śluzy.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_ENTRY := &"p7.archive_countermodel.material_memory_anchored"
const FACT_LADDER := &"p7.archive_countermodel.ladder_inspected"
const FACT_GAUGE := &"p7.archive_countermodel.depth_gauge_inspected"
const FACT_NOTE := &"p7.archive_countermodel.abort_note_inspected"
const FACT_LIGHT := &"p7.archive_countermodel.work_light_inspected"
const FACT_LOCAL_INTENT := &"p7.archive_countermodel.local_lena_intent_found"
const FACT_COMMITMENT := &"p7.archive_countermodel.commitment"
const FACT_TRACE := &"p7.archive_countermodel.trace"
const FACT_FEEDBACK := &"p7.archive_countermodel.safe_trial_feedback"

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0
const CHECKPOINT_POSITION := Vector2(65.0, 248.0)

const COLOR_BACKGROUND := Color("080a0e")
const COLOR_PANEL_BASE := Color("141c22")
const COLOR_PANEL_CORE := Color("1c2630")
const COLOR_INFRASTRUCTURE := Color("3d5866")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")

signal level_completed
signal previous_level_requested
signal interaction_triggered(id: String)
signal clue_inspected(id: String, prop_type: int)
signal station_entered
signal ladder_inspected
signal gauge_inspected
signal cable_trunk_inspected
signal work_light_inspected
signal local_lena_intent_reconstructed
signal exit_unlocked

const LEVEL_ID := "station_33"
const LEVEL_NAME := "Przestrzeń 33: Szyb wentylacyjny"
const SCENE_SUBTITLE := "Ciśnienie powrotne / Notatka z warunkiem przerwania"

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = false
@export var dialogue_index: int = 0

var is_ladder_inspected: bool = false
var is_gauge_inspected: bool = false
var is_cable_trunk_inspected: bool = false
var is_work_light_inspected: bool = false
var is_local_lena_intent_found: bool = false

var witness_frame_correction_count: int = 0
var last_witness_frame_correction_target: AnchorableObject.RealityState = AnchorableObject.RealityState.STATE_A
var witness_frame_detail_faded: bool = false
var is_witness_frame_anchored: bool = false

var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

var dialogue_lines: Array[Dictionary] = []

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = get_node_or_null("Geometry")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")
@onready var guidance_service: NarrativeGuidanceService = get_node_or_null("NarrativeGuidanceService")
@onready var witness_frame: AnchorableObject = get_node_or_null("Geometry/DualWitnessFrame")


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_setup_props()
	_setup_witness_frame()
	if airlock_zone and not airlock_zone.body_entered.is_connected(_on_airlock_zone_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_zone_body_entered)
	station_entered.emit()
	queue_redraw()


func _setup_props() -> void:
	if not props:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var pt := child as MemoryResonancePoint
			if not pt.resonance_triggered.is_connected(_on_resonance_triggered):
				pt.resonance_triggered.connect(_on_resonance_triggered)


func _setup_guidance() -> void:
	if not guidance_service:
		return
	_register_beat(&"s33_shaft_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s33_shaft_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Szyb wentylacyjny. Ciśnienie powrotne i skrzynka kablowa.", "Ventilation shaft. Backpressure and cable trunk.", &"", "")
	_register_beat(&"s33_abort_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Jeżeli miejscowa Lena działała bez zgody obu stron, notatka w szybie potwierdzi warunek abortu po 3 s.", "If local Lena acted unilaterally, her note will prove an abort-3s condition.", &"local_lena_unilateral_test", "reconstruct_local_lena_intent")
	_register_beat(&"s33_reconstruct_intent", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zbadam drabinę, manometr, notatkę w skrzynce, lampę i zrekonstruuję zamiar miejscowej Leny.", "Inspect ladder, pressure gauge, trunk note, work light, and reconstruct local Lena's intent.", &"", "reconstruct_local_lena_intent")
	_register_beat(&"s33_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Drabina, manometr, skrzynka kablowa z notatką abortu, lampa robocza, rekonstrukcja intencji.", "HINT: Ladder, gauge, cable trunk abort note, work light, reconstruct intent.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_33"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	beat.predicted_check = predicted_check
	guidance_service.register_beat(beat)


func _setup_witness_frame() -> void:
	if witness_frame == null:
		return
	if not witness_frame.anchor_state_changed.is_connected(_on_witness_frame_anchor_changed):
		witness_frame.anchor_state_changed.connect(_on_witness_frame_anchor_changed)
	witness_frame.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)


func _on_witness_frame_anchor_changed(anchored: bool) -> void:
	is_witness_frame_anchored = anchored
	queue_redraw()


func run_witness_frame_correction_pass() -> void:
	if witness_frame == null:
		return
	last_witness_frame_correction_target = (
		AnchorableObject.RealityState.STATE_B
		if witness_frame.current_reality == AnchorableObject.RealityState.STATE_A
		else AnchorableObject.RealityState.STATE_A
	)
	witness_frame.apply_reality_shift(last_witness_frame_correction_target, false)
	if witness_frame.current_reality == last_witness_frame_correction_target and not witness_frame.is_anchored:
		_apply_witness_frame_correction()
	queue_redraw()


func _apply_witness_frame_correction() -> void:
	witness_frame_correction_count += 1
	witness_frame_detail_faded = true
	_record(&"station_33_dual_witness_corrected", true)
	if player:
		if player.has_method("reset_to"):
			player.reset_to(CHECKPOINT_POSITION)
		else:
			player.global_position = CHECKPOINT_POSITION
	queue_redraw()


func _process(delta: float) -> void:
	_pulse_phase += delta
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 2.0)
		queue_redraw()


func inspect_ladder_infrastructure() -> bool:
	if is_ladder_inspected:
		return false
	if not _has(FACT_ENTRY):
		_record_feedback(&"entry_trace_required")
		return false
	is_ladder_inspected = true
	_record(FACT_LADDER, true)
	ladder_inspected.emit()
	interaction_triggered.emit("prop_ladder")
	_activate_prop_by_id("prop_ladder")
	_activate_prop_by_id("VerticalLadderArray")
	if guidance_service:
		guidance_service.trigger_beat(&"s33_shaft_contact")
	_report_progress(&"s33_ladder_inspected")
	queue_redraw()
	return true


func inspect_ladder() -> bool:
	return inspect_ladder_infrastructure()


func inspect_depth_gauge() -> bool:
	if is_gauge_inspected:
		return false
	if not is_ladder_inspected:
		_record_feedback(&"ladder_inspection_required")
		return false
	is_gauge_inspected = true
	_record(FACT_GAUGE, true)
	gauge_inspected.emit()
	interaction_triggered.emit("prop_depth_gauge")
	_activate_prop_by_id("prop_depth_gauge")
	_activate_prop_by_id("DepthPressureGauge")
	_report_progress(&"s33_gauge_inspected")
	queue_redraw()
	return true


func inspect_gauge() -> bool:
	return inspect_depth_gauge()


func inspect_cable_trunk_note() -> bool:
	if is_cable_trunk_inspected:
		return false
	if not is_gauge_inspected:
		_record_feedback(&"gauge_inspection_required")
		return false
	is_cable_trunk_inspected = true
	_record(FACT_NOTE, true)
	cable_trunk_inspected.emit()
	interaction_triggered.emit("prop_cable_trunk")
	_activate_prop_by_id("prop_cable_trunk")
	_activate_prop_by_id("MemoryBusCableTrunk")
	if guidance_service:
		guidance_service.trigger_beat(&"s33_abort_hypothesis")
	_report_progress(&"s33_cable_trunk_inspected")
	queue_redraw()
	return true


func inspect_cable_trunk() -> bool:
	return inspect_cable_trunk_note()


func inspect_shaft_work_light() -> bool:
	if is_work_light_inspected:
		return false
	if not is_cable_trunk_inspected:
		_record_feedback(&"cable_trunk_note_required")
		return false
	is_work_light_inspected = true
	_record(FACT_LIGHT, true)
	work_light_inspected.emit()
	interaction_triggered.emit("prop_work_light")
	_activate_prop_by_id("prop_work_light")
	_activate_prop_by_id("ShaftWorkLightBeacon")
	_report_progress(&"s33_work_light_inspected")
	queue_redraw()
	return true


func inspect_work_light() -> bool:
	return inspect_shaft_work_light()


func reconstruct_local_lena_intent() -> bool:
	if is_local_lena_intent_found:
		return false
	if not is_work_light_inspected:
		_record_feedback(&"work_light_required")
		return false
	is_local_lena_intent_found = true
	_record(FACT_LOCAL_INTENT, true)
	_record(&"local_lena_intent_found", true)
	_record(FACT_COMMITMENT, &"reconstruct_local_intent")
	_record(FACT_TRACE, "local_lena_intent_found")
	local_lena_intent_reconstructed.emit()
	if witness_frame:
		witness_frame.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)
	if guidance_service:
		guidance_service.close_hypothesis(&"local_lena_unilateral_test")
	_report_progress(&"s33_intent_reconstructed")
	_unlock_exit()
	queue_redraw()
	return true


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_activate_prop_by_id("prop_station_33_exit")
	_activate_prop_by_id("Station33Exit")
	call_deferred(&"_complete_if_player_already_in_airlock")
	queue_redraw()


func _complete_if_player_already_in_airlock() -> void:
	if not is_exit_unlocked or is_level_completed or airlock_zone == null or player == null:
		return
	for body in airlock_zone.get_overlapping_bodies():
		if body == player or (body != null and body.name == "Player"):
			_trigger_level_completion()
			return


func _activate_prop_by_id(id: String) -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint and (child.resonance_id == id or child.name == id):
				child.is_activated = true
				child.queue_redraw()


func _on_resonance_triggered(id: String, prop_type: int) -> void:
	match id:
		"prop_ladder", "VerticalLadderArray":
			inspect_ladder_infrastructure()
		"prop_depth_gauge", "DepthPressureGauge":
			inspect_depth_gauge()
		"prop_cable_trunk", "MemoryBusCableTrunk":
			inspect_cable_trunk_note()
		"prop_work_light", "ShaftWorkLightBeacon":
			inspect_shaft_work_light()
		"prop_station_33_exit", "Station33Exit":
			if is_exit_unlocked:
				_trigger_level_completion()
			else:
				_record_feedback(&"local_lena_intent_reconstruction_required")
	clue_inspected.emit(id, prop_type)


func _on_airlock_zone_body_entered(body: Node2D) -> void:
	if is_level_completed:
		return
	if body == player or (body and body.name == "Player"):
		_trigger_level_completion()


func _trigger_level_completion() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _has(fact_key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	if state == null:
		return true
	if state.decisions.has(fact_key):
		return true
	return state.decisions.has(String(fact_key))


func _record(fact_key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null and state.has_method("record_decision"):
		state.record_decision(fact_key, value)


func _record_feedback(feedback_id: StringName) -> void:
	_record(FACT_FEEDBACK, String(feedback_id))


func _report_progress(action_id: StringName) -> void:
	if guidance_service != null and guidance_service.has_method("report_progress"):
		guidance_service.report_progress(action_id)


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	# Vertical ladder rails
	draw_line(Vector2(120.0, 40.0), Vector2(120.0, 280.0), COLOR_INFRASTRUCTURE, 2.0)
	draw_line(Vector2(140.0, 40.0), Vector2(140.0, 280.0), COLOR_INFRASTRUCTURE, 2.0)
	for y in range(40, 280, 20):
		draw_line(Vector2(120.0, float(y)), Vector2(140.0, float(y)), COLOR_PANEL_BASE, 1.5)

	# Depth pressure gauge dial
	var gauge_col := COLOR_AMBER if is_gauge_inspected else COLOR_INFRASTRUCTURE
	draw_circle(Vector2(235.0, 245.0), 14.0, COLOR_PANEL_BASE)
	draw_circle(Vector2(235.0, 245.0), 14.0, gauge_col)

	# Cable trunk box with note
	var cable_col := COLOR_CYAN if is_cable_trunk_inspected else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(330.0, 210.0), Vector2(30.0, 50.0)), COLOR_PANEL_CORE, true)
	draw_line(Vector2(335.0, 230.0), Vector2(355.0, 230.0), cable_col, 2.0)

	# Work light cone
	if is_work_light_inspected:
		draw_circle(Vector2(455.0, 200.0), 8.0, COLOR_AMBER_WARM)

	# Exit hatch frame
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
