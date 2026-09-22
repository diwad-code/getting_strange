class_name Station02
extends Node2D

## Station 02 — outdoor service detour.
## A real maintenance closure has removed the shortcut. Lena reads the work,
## compares the delay, then takes the laddered embankment toward the stop.
##
## PRZESZKODA — dlaczego to tu jest: Nocne prace wymieniają przewód nad kładką, więc zamknięty skrót prowadzi pieszych na istniejący nasyp serwisowy.
## PRZESZKODA — czego wymaga od Leny: rozpoznania prac, porównania czasu obejścia i wejścia na umocowaną drabinę serwisową.
## PRZESZKODA — koszt porażki: zlekceważenie obejścia zostawia ją bez czasu potrzebnego do uczciwej wiadomości dla Marty.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_SAMPLE := &"p7.sample_and_promise.sample_preserved"
const FACT_DETOUR := &"p7.sample_and_promise.service_detour_observed"
const FACT_ROUTE_TIME := &"p7.sample_and_promise.route_time_confirmed"
const FACT_BYPASS := &"p7.sample_and_promise.safe_bypass_taken"
const FACT_FEEDBACK := &"p7.sample_and_promise.safe_trial_feedback"
const OPENING_CHOICE := &"p9.opening.choice"

signal detour_closure_inspected()
signal service_ladder_taken()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var props: Node2D = $Props
@onready var chamber_door: AnimatableBody2D = $ChamberDoor
@onready var airlock_zone: Area2D = $AirlockZone
@onready var dialogue: CRTDialogueBox = $CRTDialogueBox

var is_detour_closure_inspected := false
var is_detour_time_compared := false
var is_service_ladder_taken := false
var is_exit_unlocked := false
var is_level_completed := false


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_action_points()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	_set_action_available(&"compare_detour_time", false)
	_set_action_available(&"take_service_ladder", false)
	queue_redraw()


func _connect_action_points() -> void:
	for child in props.get_children():
		if child is OpeningActionPoint:
			var action := child as OpeningActionPoint
			if not action.action_requested.is_connected(_on_action_requested):
				action.action_requested.connect(_on_action_requested)


func _on_action_requested(action_id: StringName) -> void:
	match action_id:
		&"inspect_detour_closure":
			inspect_detour_closure()
		&"compare_detour_time":
			compare_detour_time()
		&"take_service_ladder":
			take_service_ladder()


func inspect_detour_closure() -> bool:
	if is_detour_closure_inspected:
		return false
	if not _has(FACT_SAMPLE) and _decision_string(OPENING_CHOICE).is_empty():
		_record_feedback(&"opening_choice_required")
		return false
	is_detour_closure_inspected = true
	_record(FACT_DETOUR, true)
	_record(&"p9.opening.night_detour_seen", true)
	_resolve_action(&"inspect_detour_closure")
	_set_action_available(&"compare_detour_time", true)
	detour_closure_inspected.emit()
	_present([
		{"speaker": "LENA", "text": "Przewód jest naprawdę wymieniany. Nasyp doda mi dwanaście minut."},
	])
	queue_redraw()
	return true


func compare_detour_time() -> bool:
	if not is_detour_closure_inspected or is_detour_time_compared:
		_record_feedback(&"closure_required")
		return false
	is_detour_time_compared = true
	_record(FACT_ROUTE_TIME, true)
	_record(&"p9.opening.detour_cost_confirmed", true)
	_resolve_action(&"compare_detour_time")
	_set_action_available(&"take_service_ladder", true)
	_present([
		{"speaker": "LENA", "text": "Dwanaście minut. Marta będzie czekała dłużej, niż obiecałam."},
	])
	queue_redraw()
	return true


func take_service_ladder() -> bool:
	if not is_detour_time_compared or is_service_ladder_taken:
		_record_feedback(&"detour_time_required")
		return false
	is_service_ladder_taken = true
	_record(FACT_BYPASS, true)
	_record(&"p9.opening.service_ladder_route_taken", true)
	_resolve_action(&"take_service_ladder")
	service_ladder_taken.emit()
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
	_register_beat(&"s02_composition", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")

func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_02"
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
	_draw_outdoor_detour()


func _draw_outdoor_detour() -> void:
	VectorStageStyle.draw_stage_apron(self, Vector2(640.0, 360.0))
	# Open sky occupies more than a quarter of the frame; all route information
	# remains readable when text is hidden.
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), Color("101922"))
	draw_rect(Rect2(0.0, 0.0, 640.0, 132.0), Color("162635"))
	draw_rect(Rect2(0.0, 116.0, 640.0, 48.0), Color("223747"))
	# Three depth planes: distant facades, working gantry and foreground asphalt.
	for x in [28.0, 108.0, 210.0, 470.0, 548.0]:
		draw_rect(Rect2(x, 86.0, 52.0, 116.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.30))
		draw_rect(Rect2(x + 10.0, 108.0, 10.0, 18.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.36))
		draw_rect(Rect2(x + 30.0, 142.0, 10.0, 18.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.46))
	draw_colored_polygon(PackedVector2Array([
		Vector2(0.0, 214.0), Vector2(406.0, 196.0), Vector2(454.0, 258.0), Vector2(0.0, 286.0),
	]), VectorStageStyle.DEEP_PLANE)
	draw_line(Vector2(44.0, 224.0), Vector2(402.0, 210.0), VectorStageStyle.HUMAN_AMBER, 3.0)
	draw_line(Vector2(44.0, 238.0), Vector2(402.0, 224.0), VectorStageStyle.HUMAN_AMBER, 1.0)
	# Active maintenance gantry: cables and work lamps exist independently of Lena.
	draw_line(Vector2(176.0, 48.0), Vector2(170.0, 196.0), VectorStageStyle.LIGHT_PLANE, 3.0)
	draw_line(Vector2(334.0, 42.0), Vector2(350.0, 190.0), VectorStageStyle.LIGHT_PLANE, 3.0)
	draw_line(Vector2(164.0, 92.0), Vector2(350.0, 82.0), VectorStageStyle.MID_PLANE, 6.0)
	var work_light := VectorStageStyle.ANCHOR_CYAN if is_detour_closure_inspected else VectorStageStyle.HUMAN_AMBER
	draw_circle(Vector2(196.0, 104.0), 12.0, Color(work_light, 0.14))
	draw_circle(Vector2(196.0, 104.0), 4.0, work_light)
	draw_circle(Vector2(314.0, 98.0), 4.0, work_light)
	draw_colored_polygon(PackedVector2Array([
		Vector2(0.0, 296.0), Vector2(640.0, 270.0), Vector2(640.0, 360.0), Vector2(0.0, 360.0),
	]), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.22))
	draw_line(Vector2(0.0, 296.0), Vector2(640.0, 270.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	# Landing and the ladder are physical world architecture, never floating steps.
	draw_rect(Rect2(418.0, 232.0, 198.0, 24.0), VectorStageStyle.MID_PLANE)
	draw_line(Vector2(418.0, 232.0), Vector2(616.0, 232.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	var route_color := VectorStageStyle.ANCHOR_CYAN if is_service_ladder_taken else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(564.0, 164.0), Vector2(564.0, 256.0), route_color, 3.0)
	draw_line(Vector2(576.0, 162.0), Vector2(576.0, 254.0), route_color, 3.0)
	for y in range(174, 250, 14):
		draw_line(Vector2(564.0, float(y)), Vector2(576.0, float(y)), route_color, 1.5)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(600.0, 144.0, 20.0, 118.0), VectorStageStyle.INK)
	draw_line(Vector2(610.0, 150.0), Vector2(610.0, 260.0), exit_color, 2.0)
