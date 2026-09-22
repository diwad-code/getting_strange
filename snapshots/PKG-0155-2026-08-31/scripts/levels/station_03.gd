class_name Station03
extends Node2D

## Station 03 — S01, odrzucenie pokusy ukrycia opóźnienia.
## Tablica daje czas niezależny od próbki; wiadomość do Marty zamyka zobowiązanie.

## PRZESZKODA — dlaczego to tu jest: Przystanek odprawia kursy według tablicy przyjazdów i wiadomości, a nie według domysłów osób czekających.
## PRZESZKODA — czego wymaga od Leny: odczytania czasu odjazdu i wysłania Marcie rzeczywistej informacji o opóźnieniu.
## PRZESZKODA — koszt porażki: wyjście bez wiadomości nie tworzy śladu zobowiązania i nie odblokowuje drzwi.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_ROUTE_TIME := &"p7.sample_and_promise.route_time_confirmed"
const FACT_DEPARTURE := &"p7.sample_and_promise.departure_time_observed"
const FACT_NOTICE := &"p7.sample_and_promise.time_notice_sent"
const FACT_TRACE := &"p7.sample_and_promise.trace"
const FACT_FEEDBACK := &"p7.sample_and_promise.safe_trial_feedback"

signal clue_inspected(id: String, prop_type: int)
signal time_notice_sent()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var security_door: AnimatableBody2D = $SecurityDoor
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_departure_time_observed := false
var is_time_notice_sent := false
var is_exit_unlocked := false
var is_level_completed := false


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_props()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	queue_redraw()


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s03_departure_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s03_departure_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Tablica ma własny czas. Nie poprawię go w głowie.", "The board keeps its own time. I will not edit it in my head.", &"", "")
	_register_beat(&"s03_hide_delay_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Mogę napisać tylko: jadę. To byłby skrót.", "I could only write: on my way. That would be a shortcut.", &"hide_delay", "send_measured_delay_to_marta")
	_register_beat(&"s03_notify_marta", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Podam Marcie czas z tablicy i próbkę, nie wymówkę.", "I will send Marta the board time and the sample, not an excuse.", &"", "")
	_register_beat(&"s03_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Odczytaj tablicę, potem wyślij wiadomość z rzeczywistym czasem.", "HINT: Read the board, then send the message with the actual time.", &"", "")


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


func _connect_props() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var prop := child as MemoryResonancePoint
			if not prop.resonance_triggered.is_connected(_on_prop_resonance_triggered.bind(prop)):
				prop.resonance_triggered.connect(_on_prop_resonance_triggered.bind(prop))


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	match id:
		"transit_board":
			observe_departure_time()
		"phone_message":
			send_measurement_time_notice()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func observe_departure_time() -> bool:
	if is_departure_time_observed or not _has(FACT_ROUTE_TIME):
		_record_feedback(&"route_time_required")
		return false
	is_departure_time_observed = true
	_record(FACT_DEPARTURE, true)
	_report_progress(&"s03_departure_time_observed")
	if guidance_service:
		guidance_service.trigger_beat(&"s03_hide_delay_hypothesis")
	queue_redraw()
	return true


func send_measurement_time_notice() -> bool:
	if is_time_notice_sent:
		return false
	if not is_departure_time_observed:
		_record_feedback(&"departure_time_required")
		return false
	is_time_notice_sent = true
	_record(FACT_NOTICE, true)
	_record(FACT_TRACE, "sample_preserved_and_time_sent")
	_record(&"marta_promise_broken", true)
	time_notice_sent.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"hide_delay")
	_report_progress(&"s03_time_notice_sent")
	_unlock_exit()
	queue_redraw()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s03_" + value)


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	if security_door:
		ExitClearance.open_body_tweened(self, security_door)
	call_deferred("_complete_if_player_already_in_airlock")


func _complete_if_player_already_in_airlock() -> void:
	if airlock_zone != null and player != null and airlock_zone.overlaps_body(player):
		_trigger_level_completion()


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


func _record(key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(key, value)


func _is_resolved(id: String) -> bool:
	match id:
		"transit_board": return is_departure_time_observed
		"phone_message": return is_time_notice_sent
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var board_color := VectorStageStyle.LIGHT_PLANE if is_departure_time_observed else VectorStageStyle.HUMAN_AMBER
	var notice_color := VectorStageStyle.ANCHOR_CYAN if is_time_notice_sent else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(Vector2(160.0, 228.0), Vector2(24.0, 16.0)), board_color, false, 2.0)
	draw_rect(Rect2(Vector2(290.0, 236.0), Vector2(22.0, 14.0)), notice_color, false, 2.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(566.0, 174.0), Vector2(566.0, 252.0), exit_color, 2.0)
