class_name Station25
extends Node2D

## Station 25 — UCP infrastructure leaves a durable intervention trace.
## Goal: reach the recorder for today's interrupted test.
## Obstacle: ventilation, interlocks and power are performing their normal
## shutdown cycle while UCP removes the easy route through the node.
## Action: Jakub guides both previously committed paths through the same real
## infrastructure without offering his own signal as consent.
## Result: the buffer trace differs by route and survives the station transition.
##
## PRZESZKODA — dlaczego to tu jest: Wentylacja, rygle i zasilanie utrzymują
## tunel serwisowy Linii 4 bezpiecznym podczas wygaszania po interwencji UCP.
## PRZESZKODA — czego wymaga od Leny: odczytania cyklu maszyn z Jakubem i
## wykonania procedury technicznej, nie pokonania toru zręcznościowego.
## PRZESZKODA — koszt porażki: zła kolejność podaje brakujący etap procedury;
## nie używa Jakuba jako parametru, nie odbiera drogi po odmowie Marty.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_BOUNDARY := &"p7.mutual_test.marta_boundary"
const FACT_TRACE := &"p7.mutual_test.ucp_buffer_trace"
const FACT_ROUTE_FEEDBACK := &"p7.mutual_test.technical_route_feedback"

signal clue_inspected(id: String, prop_type: int)
signal infrastructure_step_completed(step_id: StringName)
signal ucp_buffer_retrieved(trace_id: StringName)
signal exit_unlocked()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_ventilation_observed := false
var is_interlock_released := false
var is_power_routed := false
var is_buffer_retrieved := false
var is_exit_unlocked := false
var is_level_completed := false
var active_route: StringName = &""
var _pulse_time := 0.0


func _ready() -> void:
	_setup_camera()
	_setup_props()
	_setup_guidance()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_zone_body_entered):
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
	_register_beat(&"s25_infrastructure_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", "")
	_register_beat(&"s25_infrastructure_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Jakub: najpierw wentylacja. Potem rygiel. Potem zasilanie.", "Jakub: ventilation first. Then the interlock. Then power.", "")
	_register_beat(&"s25_route_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Notatki mogą opisać bufor, ale nie zastąpią cyklu maszyny.", "Notes may describe the buffer, but they cannot replace the machine cycle.", "notes_replace_infrastructure")
	_register_beat(&"s25_technical_route", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Sprawdź wentylację, zwolnij rygiel, potem podaj zasilanie do rejestratora.", "Check ventilation, release the interlock, then route power to the recorder.", "")
	_register_beat(&"s25_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Trzy kroki infrastruktury są wspólne dla obu dróg. Pomoc nie używa sygnału Jakuba.", "HINT: The three infrastructure steps are shared by both routes. Help does not use Jakub's signal.", "")


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
	beat.scene_id = &"station_25"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	if hypothesis_id == &"notes_replace_infrastructure":
		beat.predicted_check = "ventilation_interlock_power_cycle"
	guidance_service.register_beat(beat)


func _process(delta: float) -> void:
	_pulse_time += delta
	queue_redraw()


func _on_prop_inspected(id: String, prop_type: int, _point: MemoryResonancePoint) -> void:
	match id:
		"prop_maintenance_cart":
			observe_ventilation_cycle()
		"prop_scar_chart":
			release_interlock()
		"prop_jakub_operator":
			route_power()
		"prop_gesture_sensor":
			retrieve_ucp_buffer()
		"prop_station_25_exit":
			if is_exit_unlocked:
				_trigger_level_completion()
	clue_inspected.emit(id, prop_type)


func observe_ventilation_cycle() -> bool:
	if not _has_route_boundary() or is_ventilation_observed:
		_record_route_feedback()
		return false
	is_ventilation_observed = true
	infrastructure_step_completed.emit(&"ventilation")
	_report_step(&"s25_ventilation")
	return true


func release_interlock() -> bool:
	if not _has_route_boundary() or not is_ventilation_observed or is_interlock_released:
		_record_route_feedback()
		return false
	is_interlock_released = true
	infrastructure_step_completed.emit(&"interlock")
	_report_step(&"s25_interlock")
	return true


func route_power() -> bool:
	if not _has_route_boundary() or not is_interlock_released or is_power_routed:
		_record_route_feedback()
		return false
	is_power_routed = true
	infrastructure_step_completed.emit(&"power")
	_report_step(&"s25_power")
	return true


func retrieve_ucp_buffer() -> bool:
	if not (is_ventilation_observed and is_interlock_released and is_power_routed) or is_buffer_retrieved:
		_record_route_feedback()
		return false
	var boundary := _boundary_value()
	if boundary == &"limited_access":
		active_route = &"paired_with_notes"
	elif boundary == &"declined":
		active_route = &"technical_route"
	else:
		_record_route_feedback()
		return false
	is_buffer_retrieved = true
	_record(FACT_TRACE, String(active_route))
	ucp_buffer_retrieved.emit(active_route)
	if guidance_service:
		guidance_service.close_hypothesis(&"notes_replace_infrastructure")
		guidance_service.report_progress(&"s25_buffer_retrieved")
	_unlock_exit()
	queue_redraw()
	return true


func _has_route_boundary() -> bool:
	var boundary := _boundary_value()
	return boundary == &"limited_access" or boundary == &"declined"


func _boundary_value() -> StringName:
	var state := get_node_or_null("/root/GameStateManager")
	if state == null:
		return &""
	return StringName(String(state.decisions.get(FACT_BOUNDARY, "")))


func _record_route_feedback() -> void:
	_record(FACT_ROUTE_FEEDBACK, "ventilation_interlock_power_required")
	if guidance_service:
		guidance_service.report_failed_attempt(&"s25_infrastructure_order")


func _report_step(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)
		if is_ventilation_observed and is_interlock_released and is_power_routed:
			guidance_service.trigger_beat(&"s25_technical_route")
	queue_redraw()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	var exit_point := props.get_node_or_null("Station25Exit") as MemoryResonancePoint
	if exit_point:
		exit_point.is_activated = true


func _on_airlock_zone_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_exit_unlocked and not is_level_completed:
		_trigger_level_completion()


func _trigger_level_completion() -> void:
	is_level_completed = true
	level_completed.emit()


func _record(decision_id: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(decision_id, value)


func _draw() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var ventilation_color := VectorStageStyle.ANCHOR_CYAN if is_ventilation_observed else VectorStageStyle.HUMAN_AMBER
	var interlock_color := VectorStageStyle.LIGHT_PLANE if is_interlock_released else VectorStageStyle.HUMAN_AMBER
	var power_color := VectorStageStyle.CORRECTION_OXIDE if is_power_routed else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(108.0, 254.0), Vector2(156.0, 254.0), ventilation_color, 3.0)
	draw_line(Vector2(220.0, 242.0), Vector2(268.0, 242.0), interlock_color, 3.0)
	draw_line(Vector2(370.0, 242.0), Vector2(418.0, 242.0), power_color, 3.0)
	if is_buffer_retrieved:
		var trace_color := VectorStageStyle.ANCHOR_CYAN if active_route == &"paired_with_notes" else VectorStageStyle.CORRECTION_OXIDE
		draw_rect(Rect2(Vector2(470.0, 232.0), Vector2(28.0, 20.0)), trace_color, false, 2.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_color, 2.0)
