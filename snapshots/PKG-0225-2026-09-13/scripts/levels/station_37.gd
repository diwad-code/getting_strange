class_name Station37
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Komora sygnałowa moduluje pasmo transmisyjne łączące węzły podziemne ze stacją przekaźnikową na powierzchni.
## PRZESZKODA — czego wymaga od Leny: Zbadania oscyloskopu, krosownicy, anteny nadawczej, pulpitu mikserskiego i zmostkowania żywego sygnału.
## PRZESZKODA — koszt porażki: Próba przejścia bez zbadania pasma i zmostkowania sygnału blokuje nadajnik śluzy wyjściowej.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_ENTRY := &"p7.pair_cost_and_echo.trace"
const FACT_OSCILLOSCOPE := &"p7.consent_and_rescue_boundary.oscilloscope_inspected"
const FACT_PATCHBAY := &"p7.consent_and_rescue_boundary.patchbay_inspected"
const FACT_ANTENNA := &"p7.consent_and_rescue_boundary.antenna_inspected"
const FACT_PULPIT := &"p7.consent_and_rescue_boundary.pulpit_inspected"
const FACT_BRIDGE := &"p7.consent_and_rescue_boundary.living_signal_bridged"
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
signal signal_oscilloscope_inspected
signal patchbay_inspected
signal transmitting_antenna_inspected
signal mixing_pulpit_inspected
signal living_signal_bridged
signal exit_unlocked

const LEVEL_ID := "station_37"
const LEVEL_NAME := "Przestrzeń 37: Komora Sygnałowa"
const SCENE_SUBTITLE := "Węzeł nadawczy / Zmostkowanie żywego sygnału"

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = false
@export var dialogue_index: int = 0

var is_signal_oscilloscope_inspected: bool = false
var is_oscilloscope_inspected: bool = false
var is_patchbay_inspected: bool = false
var is_transmitting_antenna_inspected: bool = false
var is_antenna_inspected: bool = false
var is_mixing_pulpit_inspected: bool = false
var is_pulpit_inspected: bool = false
var is_living_signal_bridged: bool = false

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


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_setup_props()
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
	_register_beat(&"s37_signal_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s37_signal_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Komora sygnałowa. Żywy sygnał i pasmo nadawcze.", "Signal chamber. Living signal and transmission band.", &"", "")
	_register_beat(&"s37_bridge_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Sygnał Marty i Jakuba nie może być przekazany jednostronnie — wymaga jawnego zmostkowania.", "Marta and Jakub's signal cannot be routed unilaterally — it requires explicit bridge.", &"full_truth_collaboration", "bridge_living_signal")
	_register_beat(&"s37_bridge_signal", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zbadam oscyloskop, krosownicę, antenę, pulpit i zmostkuję żywy sygnał.", "Inspect oscilloscope, patchbay, antenna, pulpit, and bridge living signal.", &"", "bridge_living_signal")
	_register_beat(&"s37_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Oscyloskop, krosownica sygnałowa, antena nadawcza, pulpit mikserski, mostek sygnału.", "HINT: Oscilloscope, signal patchbay, transmitting antenna, mixing pulpit, signal bridge.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_37"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	beat.predicted_check = predicted_check
	guidance_service.register_beat(beat)


func _process(delta: float) -> void:
	_pulse_phase += delta
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 2.0)
		queue_redraw()


func inspect_signal_oscilloscope() -> bool:
	if is_signal_oscilloscope_inspected:
		return false
	if not _has(FACT_ENTRY):
		_record_feedback(&"entry_trace_required")
		return false
	is_signal_oscilloscope_inspected = true
	is_oscilloscope_inspected = true
	_record(FACT_OSCILLOSCOPE, true)
	signal_oscilloscope_inspected.emit()
	interaction_triggered.emit("prop_oscilloscope")
	_activate_prop_by_id("prop_oscilloscope")
	_activate_prop_by_id("SignalOscilloscope")
	if guidance_service:
		guidance_service.trigger_beat(&"s37_signal_contact")
	_report_progress(&"s37_oscilloscope_inspected")
	queue_redraw()
	return true


func inspect_oscilloscope() -> bool:
	return inspect_signal_oscilloscope()


func inspect_frequency_oscilloscope() -> bool:
	return inspect_signal_oscilloscope()


func inspect_patchbay() -> bool:
	if is_patchbay_inspected:
		return false
	if not is_signal_oscilloscope_inspected:
		_record_feedback(&"oscilloscope_inspection_required")
		return false
	is_patchbay_inspected = true
	_record(FACT_PATCHBAY, true)
	patchbay_inspected.emit()
	interaction_triggered.emit("prop_patchbay")
	_activate_prop_by_id("prop_patchbay")
	_activate_prop_by_id("SignalPatchbay")
	if guidance_service:
		guidance_service.trigger_beat(&"s37_bridge_hypothesis")
	_report_progress(&"s37_patchbay_inspected")
	queue_redraw()
	return true


func inspect_transmission_patchbay() -> bool:
	return inspect_patchbay()


func inspect_transmitting_antenna() -> bool:
	if is_transmitting_antenna_inspected:
		return false
	if not is_patchbay_inspected:
		_record_feedback(&"patchbay_inspection_required")
		return false
	is_transmitting_antenna_inspected = true
	is_antenna_inspected = true
	_record(FACT_ANTENNA, true)
	transmitting_antenna_inspected.emit()
	interaction_triggered.emit("prop_antenna")
	_activate_prop_by_id("prop_antenna")
	_activate_prop_by_id("TransmittingAntennaFeed")
	_report_progress(&"s37_antenna_inspected")
	queue_redraw()
	return true


func inspect_antenna() -> bool:
	return inspect_transmitting_antenna()


func inspect_mixing_pulpit() -> bool:
	if is_mixing_pulpit_inspected:
		return false
	if not is_transmitting_antenna_inspected:
		_record_feedback(&"transmitting_antenna_required")
		return false
	is_mixing_pulpit_inspected = true
	is_pulpit_inspected = true
	_record(FACT_PULPIT, true)
	mixing_pulpit_inspected.emit()
	interaction_triggered.emit("prop_pulpit")
	_activate_prop_by_id("prop_pulpit")
	_activate_prop_by_id("SignalMixingPulpit")
	_report_progress(&"s37_pulpit_inspected")
	queue_redraw()
	return true


func inspect_pulpit() -> bool:
	return inspect_mixing_pulpit()


func bridge_living_signal() -> bool:
	if is_living_signal_bridged:
		return false
	if not is_mixing_pulpit_inspected:
		_record_feedback(&"pulpit_inspection_required")
		return false
	is_living_signal_bridged = true
	_record(FACT_BRIDGE, true)
	living_signal_bridged.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"full_truth_collaboration")
	_report_progress(&"s37_signal_bridged")
	_unlock_exit()
	queue_redraw()
	return true


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_activate_prop_by_id("prop_station_37_exit")
	_activate_prop_by_id("Station37Exit")
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
		"prop_oscilloscope", "SignalOscilloscope":
			inspect_signal_oscilloscope()
		"prop_patchbay", "SignalPatchbay":
			inspect_patchbay()
		"prop_antenna", "TransmittingAntennaFeed":
			inspect_transmitting_antenna()
		"prop_pulpit", "SignalMixingPulpit":
			inspect_mixing_pulpit()
		"prop_station_37_exit", "Station37Exit":
			if is_exit_unlocked:
				_trigger_level_completion()
			else:
				_record_feedback(&"living_signal_bridge_required")
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

	# Signal Oscilloscope
	var osc_col := COLOR_CYAN if is_signal_oscilloscope_inspected else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(90.0, 200.0), Vector2(40.0, 60.0)), COLOR_PANEL_CORE, true)
	draw_circle(Vector2(110.0, 220.0), 12.0, osc_col.lerp(COLOR_BACKGROUND, 0.3))

	# Signal Patchbay
	var patch_col := COLOR_AMBER if is_patchbay_inspected else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(200.0, 190.0), Vector2(50.0, 70.0)), COLOR_PANEL_BASE, true)
	draw_line(Vector2(210.0, 210.0), Vector2(240.0, 210.0), patch_col, 2.0)

	# Transmitting Antenna Feed
	var ant_col := COLOR_AMBER_WARM if is_transmitting_antenna_inspected else COLOR_INFRASTRUCTURE
	draw_line(Vector2(330.0, 100.0), Vector2(330.0, 260.0), COLOR_INFRASTRUCTURE, 3.0)
	draw_circle(Vector2(330.0, 100.0), 8.0, ant_col)

	# Signal Mixing Pulpit
	var pulp_col := COLOR_CYAN if is_living_signal_bridged else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(430.0, 210.0), Vector2(40.0, 50.0)), COLOR_PANEL_CORE, true)
	draw_line(Vector2(435.0, 220.0), Vector2(465.0, 220.0), pulp_col, 2.0)

	# Exit hatch frame
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
