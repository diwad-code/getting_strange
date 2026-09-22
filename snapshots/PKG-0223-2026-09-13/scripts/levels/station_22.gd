class_name Station22
extends Node2D

## Station 22 — first conscious observation of Anchor/Yield.
## Goal: compare two repeatable signal behaviours after Station 21 recognition.
## Obstacle: UCP's isolation offer substitutes custody for evidence.
## Action: Lena observes a retained relation and a neighbouring-state response.
## Result: two hypotheses open, but no mechanical cost exists until Station 23.
##
## PRZESZKODA — dlaczego to tu jest: Rejestr UCP utrzymuje dwa kanały diagnostyczne,
## ponieważ aparatura musi odróżnić powtarzany echo od odpowiedzi sąsiedniego stanu.
## PRZESZKODA — czego wymaga od Leny: porównania dwóch odczytów, a nie akceptacji
## oferty UCP ani odgadnięcia odpowiedzi w dialogu.
## PRZESZKODA — koszt porażki: próba przed rozpoznaniem miejsca zostawia tylko
## komunikat bramki; nie nadaje wiedzy o metodzie, koszcie ani zgodzie.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")
const MUTUAL_TEST_SEQUENCE: DiagnosticSequenceDefinition = preload("res://resources/gameplay/mutual_test_sequence.tres")

const VIEW_SIZE := Vector2(640.0, 360.0)
const FACT_WORLD_RECOGNIZED := &"world_recognized"
const FACT_SIGNAL_ECHO := &"p7.mutual_test.signal_echo_observed"
const FACT_ADJACENT_RESPONSE := &"p7.mutual_test.adjacent_state_observed"
const FACT_HYPOTHESES_OPENED := &"p7.mutual_test.hypotheses_opened"
const FACT_UCP_OFFER_OBSERVED := &"p7.mutual_test.ucp_offer_observed"
const FACT_GATE_FEEDBACK := &"p7.mutual_test.station22_gate_feedback"

signal clue_inspected(id: String, prop_type: int)
signal signal_observed(hypothesis_id: StringName)
signal hypotheses_opened()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var dialogue_box: CRTDialogueBox = $CRTDialogueBox

var is_ucp_offer_observed := false
var is_signal_echo_observed := false
var is_adjacent_state_observed := false
var is_hypotheses_opened := false
var is_level_completed := false
var _pulse_time := 0.0


func _ready() -> void:
	_setup_camera()
	_setup_guidance()
	_connect_props()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	queue_redraw()


func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s22_signal_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", "")
	_register_beat(&"s22_signal_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Utrzymany ślad. Odpowiedź obok.", "A held trace. A response beside it.", "")
	_register_beat(&"s22_compare_signal_states", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Echo może tylko powtarzać urządzenie.", "An echo may only repeat the device.", "signal_echo")
	_register_beat(&"s22_discriminating_trial", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Porównam oba kanały na martwym obwodzie.", "I will compare both channels on the dead circuit.", "")
	_register_beat(&"s22_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Zbadaj oba kanały. Nie wybieraj jeszcze metody ani osoby.", "HINT: Examine both channels. Do not choose a method or a person yet.", "")


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
	beat.scene_id = &"station_22"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	if hypothesis_id == &"signal_echo":
		beat.predicted_check = "compare_retained_relation_and_adjacent_response"
	guidance_service.register_beat(beat)


func _connect_props() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var prop := child as MemoryResonancePoint
			if not prop.resonance_triggered.is_connected(_on_prop_resonance_triggered.bind(prop)):
				prop.resonance_triggered.connect(_on_prop_resonance_triggered.bind(prop))


func _process(delta: float) -> void:
	_pulse_time += delta * 2.0
	queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int, _prop: MemoryResonancePoint) -> void:
	match id:
		"ucp_offer_console", "archive_terminal":
			observe_ucp_offer()
		"oscilloscope_display":
			observe_signal_echo()
		"signal_spectrum_plot", "docking_station":
			observe_adjacent_state()
	clue_inspected.emit(id, prop_type)


func observe_ucp_offer() -> bool:
	if not _can_interpret_signal():
		return false
	if is_ucp_offer_observed:
		return false
	is_ucp_offer_observed = true
	_record(FACT_UCP_OFFER_OBSERVED, true)
	if guidance_service:
		guidance_service.report_progress(&"s22_ucp_offer_observed")
	queue_redraw()
	return true


func observe_signal_echo() -> bool:
	if not _can_interpret_signal() or is_signal_echo_observed:
		return false
	is_signal_echo_observed = true
	_record(FACT_SIGNAL_ECHO, true)
	signal_observed.emit(&"signal_echo")
	if guidance_service:
		guidance_service.report_progress(&"s22_signal_echo")
		guidance_service.trigger_beat(&"s22_compare_signal_states")
	_open_hypotheses_if_ready()
	queue_redraw()
	return true


func observe_adjacent_state() -> bool:
	if not _can_interpret_signal() or is_adjacent_state_observed:
		return false
	is_adjacent_state_observed = true
	_record(FACT_ADJACENT_RESPONSE, true)
	signal_observed.emit(&"adjacent_state_response")
	if guidance_service:
		guidance_service.report_progress(&"s22_adjacent_state")
	_open_hypotheses_if_ready()
	queue_redraw()
	return true


func _can_interpret_signal() -> bool:
	if _has_decision(FACT_WORLD_RECOGNIZED):
		return true
	_record(FACT_GATE_FEEDBACK, "world_recognized_required")
	return false


func _open_hypotheses_if_ready() -> void:
	if is_hypotheses_opened or not (is_signal_echo_observed and is_adjacent_state_observed):
		return
	is_hypotheses_opened = true
	_record(FACT_HYPOTHESES_OPENED, true)
	hypotheses_opened.emit()
	if guidance_service:
		guidance_service.report_progress(&"s22_hypotheses_opened")
		guidance_service.trigger_beat(&"s22_discriminating_trial")


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_hypotheses_opened and not is_level_completed:
		is_level_completed = true
		level_completed.emit()


func _record(decision_id: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(decision_id, value)


func _has_decision(decision_id: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	return state != null and bool(state.decisions.get(decision_id, false))


func _draw() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var echo_color := VectorStageStyle.ANCHOR_CYAN if is_signal_echo_observed else VectorStageStyle.HUMAN_AMBER
	var adjacent_color := VectorStageStyle.CORRECTION_OXIDE if is_adjacent_state_observed else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(300.0, 238.0), Vector2(350.0, 238.0), echo_color, 3.0)
	draw_line(Vector2(386.0, 250.0), Vector2(438.0, 250.0), adjacent_color, 3.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_hypotheses_opened else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_color, 2.0)
