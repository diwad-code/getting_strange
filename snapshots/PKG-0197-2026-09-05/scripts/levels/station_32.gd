class_name Station32
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Stanowisko analityczne bada właściwości rezonansowe szkła i zjawisko pamięci materiałowej po uderzeniu fali.
## PRZESZKODA — czego wymaga od Leny: Zbadania trzech tafli szkła (zaparowanej, pękniętej, wygładzonej), wyrycia śladu kondensacji i zestrojenia kotwicy pamięci materiału przed otwarciem włazu.
## PRZESZKODA — koszt porażki: Próba otwarcia włazu bez wyrycia śladu i zestrojenia kotwicy blokuje mechanizm rygla.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_ENTRY := &"p7.archive_countermodel.adaptation_offer_rejected"
const FACT_STEAMED := &"p7.archive_countermodel.steamed_pane_inspected"
const FACT_CRACKED := &"p7.archive_countermodel.cracked_pane_inspected"
const FACT_TRACE := &"p7.archive_countermodel.condensation_trace_etched"
const FACT_POLISHED := &"p7.archive_countermodel.polished_pane_inspected"
const FACT_ANCHOR := &"p7.archive_countermodel.material_memory_anchored"
const FACT_FEEDBACK := &"p7.archive_countermodel.safe_trial_feedback"

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0
const CHECKPOINT_POSITION := Vector2(65.0, 248.0)

const COLOR_BACKGROUND := Color("080c10")
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
signal steamed_pane_inspected
signal cracked_pane_inspected
signal trace_etched
signal polished_pane_inspected
signal material_memory_anchored
signal exit_unlocked

const LEVEL_ID := "station_32"
const LEVEL_NAME := "Przestrzeń 32: Szkło laboratoryjne"
const SCENE_SUBTITLE := "Pamięć materiału / Ślad kondensacji i odpowiedź"

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = false
@export var dialogue_index: int = 0

var is_steamed_pane_inspected: bool = false
var is_cracked_pane_inspected: bool = false
var is_trace_etched: bool = false
var is_polished_pane_inspected: bool = false
var is_material_memory_anchored: bool = false

var glass_observation_correction_count: int = 0
var glass_detail_faded: bool = false
var is_glass_anchored: bool = false
var observation_boundary_crossed: bool = false

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
@onready var observed_glass: AnchorableObject = get_node_or_null("Geometry/ObservedGlassTrace")


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_setup_props()
	_setup_glass()
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
	_register_beat(&"s32_glass_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s32_glass_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Pamięć materiału. Szkło laboratoryjne reaguje na moje dłonie.", "Material memory. The lab glass responds to my hands.", &"", "")
	_register_beat(&"s32_memory_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Wygładzenie nie zniszczyło prawdy — tylko ją przykryło. Wytrawienie śladu ujawni rezonans.", "Polishing did not destroy the truth — it only covered it. Etching the trace reveals resonance.", &"selective_evidence_erasure", "anchor_material_memory")
	_register_beat(&"s32_anchor_trace", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zbadam zaparowaną taflę, pękniętą taflę, wyryję ślad kondensacji, zbadam taflę wygładzoną i zakotwiczę pamięć materiału.", "Inspect steamed pane, cracked pane, etch trace, inspect polished pane, and anchor material memory.", &"", "anchor_material_memory")
	_register_beat(&"s32_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Zaparowane szkło, pęknięte szkło, wytrawiacz śladu, wygładzone szkło, zakotwiczenie pamięci.", "HINT: Steamed glass, cracked glass, trace etcher, polished glass, anchor material memory.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_32"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	beat.predicted_check = predicted_check
	guidance_service.register_beat(beat)


func _setup_glass() -> void:
	if observed_glass == null:
		return
	if not observed_glass.anchor_state_changed.is_connected(_on_glass_anchor_state_changed):
		observed_glass.anchor_state_changed.connect(_on_glass_anchor_state_changed)
	observed_glass.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)


func _on_glass_anchor_state_changed(anchored: bool) -> void:
	is_glass_anchored = anchored
	queue_redraw()


func run_glass_observation_check() -> void:
	if observed_glass == null:
		return
	observed_glass.apply_reality_shift(AnchorableObject.RealityState.STATE_B, false)
	if observed_glass.current_reality == AnchorableObject.RealityState.STATE_B:
		_apply_glass_correction()


func _apply_glass_correction() -> void:
	glass_observation_correction_count += 1
	glass_detail_faded = true
	_record(&"station_32_observed_glass_corrected", true)
	observed_glass.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)
	if player:
		if player.has_method("reset_to"):
			player.reset_to(CHECKPOINT_POSITION)
		else:
			player.global_position = CHECKPOINT_POSITION
	observation_boundary_crossed = false
	queue_redraw()


func _process(delta: float) -> void:
	_pulse_phase += delta
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 2.0)
		queue_redraw()


func inspect_steamed_pane() -> bool:
	if is_steamed_pane_inspected:
		return false
	if not _has(FACT_ENTRY):
		_record_feedback(&"entry_trace_required")
		return false
	is_steamed_pane_inspected = true
	_record(FACT_STEAMED, true)
	steamed_pane_inspected.emit()
	interaction_triggered.emit("prop_steamed_glass_pane")
	_activate_prop_by_id("prop_steamed_glass_pane")
	_activate_prop_by_id("prop_steamed_glass_pane_a")
	if guidance_service:
		guidance_service.trigger_beat(&"s32_glass_contact")
	_report_progress(&"s32_steamed_inspected")
	queue_redraw()
	return true


func inspect_cracked_pane() -> bool:
	if is_cracked_pane_inspected:
		return false
	if not is_steamed_pane_inspected:
		_record_feedback(&"steamed_pane_required")
		return false
	is_cracked_pane_inspected = true
	_record(FACT_CRACKED, true)
	cracked_pane_inspected.emit()
	interaction_triggered.emit("prop_cracked_glass_pane")
	_activate_prop_by_id("prop_cracked_glass_pane")
	_activate_prop_by_id("prop_cracked_glass_pane_b")
	if guidance_service:
		guidance_service.trigger_beat(&"s32_memory_hypothesis")
	_report_progress(&"s32_cracked_inspected")
	queue_redraw()
	return true


func etch_condensation_trace() -> bool:
	if is_trace_etched:
		return false
	if not is_cracked_pane_inspected:
		_record_feedback(&"cracked_pane_required")
		return false
	is_trace_etched = true
	_record(FACT_TRACE, true)
	trace_etched.emit()
	interaction_triggered.emit("prop_condensation_trace_etcher")
	_activate_prop_by_id("prop_condensation_trace_etcher")
	_activate_prop_by_id("prop_trace_etcher")
	_report_progress(&"s32_trace_etched")
	queue_redraw()
	return true


func etch_trace() -> bool:
	return etch_condensation_trace()


func inspect_polished_pane() -> bool:
	if is_polished_pane_inspected:
		return false
	if not is_trace_etched:
		_record_feedback(&"trace_etching_required")
		return false
	is_polished_pane_inspected = true
	_record(FACT_POLISHED, true)
	polished_pane_inspected.emit()
	interaction_triggered.emit("prop_polished_glass_pane")
	_activate_prop_by_id("prop_polished_glass_pane")
	_activate_prop_by_id("prop_polished_glass_pane_c")
	_report_progress(&"s32_polished_inspected")
	queue_redraw()
	return true


func anchor_material_memory() -> bool:
	if is_material_memory_anchored:
		return false
	if not is_polished_pane_inspected:
		_record_feedback(&"polished_pane_required")
		return false
	is_material_memory_anchored = true
	_record(FACT_ANCHOR, true)
	material_memory_anchored.emit()
	if observed_glass:
		observed_glass.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)
	if guidance_service:
		guidance_service.close_hypothesis(&"selective_evidence_erasure")
	_report_progress(&"s32_memory_anchored")
	_unlock_exit()
	queue_redraw()
	return true


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_activate_prop_by_id("prop_station_32_exit")
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
		"prop_steamed_glass_pane", "prop_steamed_glass_pane_a":
			inspect_steamed_pane()
		"prop_cracked_glass_pane", "prop_cracked_glass_pane_b":
			inspect_cracked_pane()
		"prop_condensation_trace_etcher", "prop_trace_etcher":
			etch_condensation_trace()
		"prop_polished_glass_pane", "prop_polished_glass_pane_c":
			inspect_polished_pane()
		"prop_station_32_exit":
			if is_exit_unlocked:
				_trigger_level_completion()
			else:
				_record_feedback(&"material_memory_anchor_required")
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

	# Steamed pane stand
	draw_rect(Rect2(Vector2(110.0, 160.0), Vector2(30.0, 100.0)), COLOR_PANEL_BASE, true)
	var stm_col := COLOR_CYAN.lerp(COLOR_BACKGROUND, 0.4) if is_steamed_pane_inspected else COLOR_INFRASTRUCTURE
	draw_line(Vector2(125.0, 160.0), Vector2(125.0, 260.0), stm_col, 2.0)

	# Cracked pane stand
	draw_rect(Rect2(Vector2(220.0, 160.0), Vector2(30.0, 100.0)), COLOR_PANEL_BASE, true)
	var crk_col := COLOR_AMBER if is_cracked_pane_inspected else COLOR_INFRASTRUCTURE
	draw_line(Vector2(235.0, 160.0), Vector2(235.0, 260.0), crk_col, 2.0)

	# Condensation trace plate
	var trace_col := COLOR_CORRECTION if glass_detail_faded else COLOR_CYAN
	draw_rect(Rect2(Vector2(330.0, 150.0), Vector2(30.0, 110.0)), COLOR_PANEL_CORE, true)
	if is_trace_etched:
		draw_line(Vector2(345.0, 170.0), Vector2(345.0, 240.0), trace_col, 2.5)

	# Polished pane stand
	draw_rect(Rect2(Vector2(440.0, 160.0), Vector2(30.0, 100.0)), COLOR_PANEL_BASE, true)
	if is_polished_pane_inspected:
		draw_line(Vector2(455.0, 160.0), Vector2(455.0, 260.0), COLOR_CYAN, 1.5)

	# Exit hatch frame
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
