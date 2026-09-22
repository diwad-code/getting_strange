class_name Station02
extends Node2D

## Station 02 — S01, niezależny czas obejścia serwisowego.
## Przeszkoda istnieje, bo trwa rzeczywista konserwacja; Lena sprawdza czas
## przejścia, nie odtwarza listy inspekcji ani nie wykonuje skoków.

## PRZESZKODA — dlaczego to tu jest: Odcinek serwisowy jest zamknięty po rzeczywistych pracach konserwacyjnych, a kładka obejściowa pozostaje czynna.
## PRZESZKODA — czego wymaga od Leny: odczytania oznaczenia, porównania czasu przejścia z surowym zapisem i przejścia kładką.
## PRZESZKODA — koszt porażki: wejście na kładkę bez porównania czasu tworzy tylko komunikat o brakującym źródle.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_SAMPLE := &"p7.sample_and_promise.sample_preserved"
const FACT_DETOUR := &"p7.sample_and_promise.service_detour_observed"
const FACT_ROUTE_TIME := &"p7.sample_and_promise.route_time_confirmed"
const FACT_BYPASS := &"p7.sample_and_promise.safe_bypass_taken"
const FACT_FEEDBACK := &"p7.sample_and_promise.safe_trial_feedback"

signal clue_inspected(id: String, prop_type: int)
signal route_time_compared()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var chamber_door: AnimatableBody2D = $ChamberDoor
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_detour_observed := false
var is_route_time_compared := false
var is_safe_bypass_taken := false
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
	_register_beat(&"s02_detour_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s02_detour_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Taśma nie kłamie. Obejście ma własny czas.", "The tape is real. The detour has its own time.", &"", "")
	_register_beat(&"s02_route_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Jeśli zapis jest zwykłym błędem, obejście go nie potwierdzi.", "If the log is an ordinary error, the detour will not confirm it.", &"raw_record_valid", "compare_detour_time_to_raw_record")
	_register_beat(&"s02_compare_route_time", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Porównam czas obejścia z surową próbką.", "I will compare the detour time with the raw sample.", &"", "")
	_register_beat(&"s02_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Odczytaj oznaczenie robót, potem porównaj czas przy podrozdzielnicy.", "HINT: Read the maintenance sign, then compare time at the subpanel.", &"", "")


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
		"maintenance_sign":
			observe_service_detour()
		"service_subpanel":
			compare_route_duration()
		"service_catwalk":
			take_safe_bypass()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func observe_service_detour() -> bool:
	if is_detour_observed or not _has(FACT_SAMPLE):
		_record_feedback(&"sample_required")
		return false
	is_detour_observed = true
	_record(FACT_DETOUR, true)
	_report_progress(&"s02_detour_observed")
	if guidance_service:
		guidance_service.trigger_beat(&"s02_route_hypothesis")
	queue_redraw()
	return true


func compare_route_duration() -> bool:
	if is_route_time_compared:
		return false
	if not is_detour_observed:
		_record_feedback(&"detour_required")
		return false
	is_route_time_compared = true
	_record(FACT_ROUTE_TIME, true)
	route_time_compared.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"raw_record_valid")
	_report_progress(&"s02_route_time_compared")
	queue_redraw()
	return true


func take_safe_bypass() -> bool:
	if is_safe_bypass_taken:
		return false
	if not is_route_time_compared:
		_record_feedback(&"route_time_required")
		return false
	is_safe_bypass_taken = true
	_record(FACT_BYPASS, true)
	_report_progress(&"s02_safe_bypass_taken")
	_unlock_exit()
	queue_redraw()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s02_" + value)


func unlock_exit_door() -> void:
	_unlock_exit()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	if chamber_door:
		ExitClearance.open_body_tweened(self, chamber_door)
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
		"maintenance_sign": return is_detour_observed
		"service_subpanel": return is_route_time_compared
		"service_catwalk": return is_safe_bypass_taken
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var detour_color := VectorStageStyle.ANCHOR_CYAN if is_detour_observed else VectorStageStyle.HUMAN_AMBER
	var time_color := VectorStageStyle.LIGHT_PLANE if is_route_time_compared else VectorStageStyle.HUMAN_AMBER
	var bypass_color := VectorStageStyle.CORRECTION_OXIDE if is_safe_bypass_taken else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(144.0, 256.0), Vector2(184.0, 256.0), detour_color, 3.0)
	draw_line(Vector2(324.0, 256.0), Vector2(360.0, 256.0), time_color, 3.0)
	draw_line(Vector2(442.0, 256.0), Vector2(478.0, 256.0), bypass_color, 3.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(566.0, 174.0), Vector2(566.0, 252.0), exit_color, 2.0)
