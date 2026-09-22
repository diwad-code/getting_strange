class_name Station38
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Stanowisko koordynacji łączy centralę ratunkową z węzłem komunikacji Marty i rejestruje decyzję o zakresie ujawnienia prawdy.
## PRZESZKODA — czego wymaga od Leny: Zbadania odbiornika radiowego, procedury miejscowej, łącznicy Jakuba, zakotwiczenia liny ratunkowej i ujawnienia prawdy Marcie.
## PRZESZKODA — koszt porażki: Próba przejścia bez zakotwiczenia liny i rozstrzygnięcia prawdy blokuje procedurę wejścia do śluzy korytarza.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_ENTRY := &"p7.consent_and_rescue_boundary.living_signal_bridged"
const FACT_RADIO := &"p7.consent_and_rescue_boundary.radio_receiver_inspected"
const FACT_PROCEDURE := &"p7.consent_and_rescue_boundary.procedure_record_inspected"
const FACT_SWITCHBOARD := &"p7.consent_and_rescue_boundary.switchboard_inspected"
const FACT_TETHER := &"p7.consent_and_rescue_boundary.rescue_tether_anchored"
const FACT_MARTA_TRUTH := &"p7.consent_and_rescue_boundary.marta_truth_disclosed"
const FACT_COMMITMENT := &"p7.consent_and_rescue_boundary.commitment"
const FACT_TRACE := &"p7.consent_and_rescue_boundary.trace"
const FACT_FEEDBACK := &"p7.consent_and_rescue_boundary.safe_trial_feedback"

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0
const CHECKPOINT_POSITION := Vector2(65.0, 248.0)

const COLOR_BACKGROUND := Color("070a0e")
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
signal radio_receiver_inspected
signal local_procedure_record_inspected
signal jakub_switchboard_inspected
signal rescue_tether_anchored
signal marta_truth_disclosed(truth_state: StringName)
signal exit_unlocked

const LEVEL_ID := "station_38"
const LEVEL_NAME := "Przestrzeń 38: Stanowisko Koordynacji"
const SCENE_SUBTITLE := "Ujawnienie prawdy Marcie / Granica ratunku"

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = false
@export var dialogue_index: int = 0

var is_radio_receiver_inspected: bool = false
var is_local_procedure_record_inspected: bool = false
var is_jakub_switchboard_inspected: bool = false
var is_rescue_tether_anchored: bool = false
var is_marta_truth_disclosed: bool = false
var marta_truth_state: StringName = &"undecided"

var rescue_bulkhead_correction_count: int = 0
var rescue_bulkhead_detail_faded: bool = false
var rescue_correction_count: int:
	get:
		return rescue_bulkhead_correction_count
	set(val):
		rescue_bulkhead_correction_count = val
var rescue_detail_faded: bool:
	get:
		return rescue_bulkhead_detail_faded
	set(val):
		rescue_bulkhead_detail_faded = val
var is_rescue_bulkhead_anchored: bool = false

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
@onready var rescue_bulkhead: AnchorableObject = get_node_or_null("Geometry/JakubRescueBulkhead")


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_setup_props()
	_setup_rescue_bulkhead()
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
	_register_beat(&"s38_coord_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s38_coord_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Stanowisko koordynacji. Łącznica Jakuba i kanał Marty.", "Coordination post. Jakub's switchboard and Marta's channel.", &"", "")
	_register_beat(&"s38_truth_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Prawda wobec Marty nie zależy od kalkulacji sukcesu — to wybór szacunku i zgody.", "Truth to Marta does not depend on success calculation — it is a choice of respect and consent.", &"full_truth_collaboration", "disclose_marta_truth")
	_register_beat(&"s38_disclose_truth", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zbadam odbiornik, procedurę, łącznicę, zakotwiczę linę ratunkową i ujawnię prawdę Marcie.", "Inspect receiver, procedure, switchboard, anchor rescue tether, and disclose truth to Marta.", &"", "disclose_marta_truth")
	_register_beat(&"s38_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Odbiornik radiowy, procedura miejscowa, łącznica Jakuba, lina ratunkowa, ujawnienie prawdy.", "HINT: Radio receiver, local procedure, Jakub switchboard, rescue tether, disclose truth.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_38"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	beat.predicted_check = predicted_check
	guidance_service.register_beat(beat)


func _setup_rescue_bulkhead() -> void:
	if rescue_bulkhead == null:
		return
	if not rescue_bulkhead.anchor_state_changed.is_connected(_on_rescue_bulkhead_anchor_changed):
		rescue_bulkhead.anchor_state_changed.connect(_on_rescue_bulkhead_anchor_changed)
	rescue_bulkhead.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)


func _on_rescue_bulkhead_anchor_changed(anchored: bool) -> void:
	is_rescue_bulkhead_anchored = anchored
	queue_redraw()


func run_rescue_bulkhead_correction_check() -> void:
	if rescue_bulkhead == null:
		return
	rescue_bulkhead.apply_reality_shift(AnchorableObject.RealityState.STATE_B, false)
	if rescue_bulkhead.current_reality == AnchorableObject.RealityState.STATE_B:
		_apply_rescue_bulkhead_correction()


func run_rescue_bulkhead_correction_pass() -> void:
	run_rescue_bulkhead_correction_check()


func _apply_rescue_bulkhead_correction() -> void:
	rescue_bulkhead_correction_count += 1
	rescue_bulkhead_detail_faded = true
	_record(&"station_38_jakub_rescue_corrected", true)
	rescue_bulkhead.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)
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


func inspect_radio_receiver() -> bool:
	if is_radio_receiver_inspected:
		return false
	if not _has(FACT_ENTRY):
		_record_feedback(&"entry_trace_required")
		return false
	is_radio_receiver_inspected = true
	_record(FACT_RADIO, true)
	radio_receiver_inspected.emit()
	interaction_triggered.emit("prop_radio_receiver")
	_activate_prop_by_id("prop_radio_receiver")
	_activate_prop_by_id("EmergencyRadioReceiver")
	if guidance_service:
		guidance_service.trigger_beat(&"s38_coord_contact")
	_report_progress(&"s38_radio_inspected")
	queue_redraw()
	return true


func inspect_local_procedure_record() -> bool:
	if is_local_procedure_record_inspected:
		return false
	if not is_radio_receiver_inspected:
		_record_feedback(&"radio_receiver_required")
		return false
	is_local_procedure_record_inspected = true
	_record(FACT_PROCEDURE, true)
	local_procedure_record_inspected.emit()
	interaction_triggered.emit("prop_procedure_record")
	_activate_prop_by_id("prop_procedure_record")
	_activate_prop_by_id("LocalRescueProcedure")
	if guidance_service:
		guidance_service.trigger_beat(&"s38_truth_hypothesis")
	_report_progress(&"s38_procedure_inspected")
	queue_redraw()
	return true


func inspect_jakub_switchboard() -> bool:
	if is_jakub_switchboard_inspected:
		return false
	if not is_local_procedure_record_inspected:
		_record_feedback(&"procedure_record_required")
		return false
	is_jakub_switchboard_inspected = true
	_record(FACT_SWITCHBOARD, true)
	jakub_switchboard_inspected.emit()
	interaction_triggered.emit("prop_switchboard")
	_activate_prop_by_id("prop_switchboard")
	_activate_prop_by_id("JakubCoordinationSwitchboard")
	_report_progress(&"s38_switchboard_inspected")
	queue_redraw()
	return true


func anchor_rescue_tether() -> bool:
	if is_rescue_tether_anchored:
		return false
	if not is_jakub_switchboard_inspected:
		_record_feedback(&"switchboard_inspection_required")
		return false
	is_rescue_tether_anchored = true
	_record(FACT_TETHER, true)
	rescue_tether_anchored.emit()
	interaction_triggered.emit("prop_rescue_tether")
	_activate_prop_by_id("prop_rescue_tether")
	_activate_prop_by_id("RescueTetherWinch")
	if rescue_bulkhead:
		rescue_bulkhead.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)
	_report_progress(&"s38_tether_anchored")
	queue_redraw()
	return true


func disclose_marta_truth(p_state: StringName = &"full") -> bool:
	if is_marta_truth_disclosed:
		return false
	if not is_rescue_tether_anchored:
		_record_feedback(&"rescue_tether_anchor_required")
		return false
	is_marta_truth_disclosed = true
	marta_truth_state = p_state
	_record(FACT_MARTA_TRUTH, String(p_state))
	_record(&"marta_truth_state", String(p_state))
	_record(FACT_COMMITMENT, &"marta_truth_commitment")
	_record(FACT_TRACE, "consent_and_rescue_boundary_established")
	marta_truth_disclosed.emit(p_state)
	if guidance_service:
		guidance_service.close_hypothesis(&"full_truth_collaboration")
	_report_progress(&"s38_truth_disclosed")
	_unlock_exit()
	queue_redraw()
	return true


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_activate_prop_by_id("prop_station_38_exit")
	_activate_prop_by_id("Station38Exit")
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
		"prop_radio_receiver", "EmergencyRadioReceiver":
			inspect_radio_receiver()
		"prop_procedure_record", "LocalRescueProcedure":
			inspect_local_procedure_record()
		"prop_switchboard", "JakubCoordinationSwitchboard":
			inspect_jakub_switchboard()
		"prop_rescue_tether", "RescueTetherWinch":
			anchor_rescue_tether()
		"prop_station_38_exit", "Station38Exit":
			if is_exit_unlocked:
				_trigger_level_completion()
			else:
				_record_feedback(&"truth_disclosure_required")
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

	# Emergency Radio Receiver
	var rad_col := COLOR_CYAN if is_radio_receiver_inspected else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(90.0, 200.0), Vector2(35.0, 50.0)), COLOR_PANEL_BASE, true)
	draw_line(Vector2(95.0, 210.0), Vector2(120.0, 210.0), rad_col, 2.0)

	# Local Rescue Procedure Document
	var doc_col := COLOR_AMBER if is_local_procedure_record_inspected else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(200.0, 215.0), Vector2(25.0, 35.0)), COLOR_PANEL_CORE, true)
	draw_line(Vector2(205.0, 220.0), Vector2(220.0, 220.0), doc_col, 1.5)

	# Jakub Coordination Switchboard
	var sw_col := COLOR_AMBER_WARM if is_jakub_switchboard_inspected else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(300.0, 190.0), Vector2(50.0, 70.0)), COLOR_PANEL_BASE, true)
	draw_line(Vector2(310.0, 210.0), Vector2(340.0, 210.0), sw_col, 2.0)

	# Rescue Tether Winch
	var winch_col := COLOR_CYAN if is_rescue_tether_anchored else COLOR_INFRASTRUCTURE
	draw_circle(Vector2(430.0, 235.0), 14.0, COLOR_PANEL_CORE)
	draw_circle(Vector2(430.0, 235.0), 14.0, winch_col)

	# Exit hatch frame
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
