class_name Station05
extends Node2D

## Station 05 — S02, aktywny oddech po powtórce.
## Ulica pozostaje zwyczajna: Lena zabezpiecza stan czytnika do późniejszego
## porównania zamiast nazywać przyczynę, której nie zna.

## PRZESZKODA — dlaczego to tu jest: Ulica powrotna zmienia wygląd tylko przez nocne prace wykonawcy, a przejście działa na zwykłej sygnalizacji.
## PRZESZKODA — czego wymaga od Leny: stwierdzenia, że otoczenie jest zwyczajne, i zabezpieczenia stanu czytnika do późniejszego porównania.
## PRZESZKODA — koszt porażki: zejście z ulicy bez zabezpieczenia czytnika nie tworzy śladu porównania.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_RESULT := &"p7.return_under_control.repeat_result"
const FACT_STREET := &"p7.return_under_control.ordinary_street_observed"
const FACT_SECURED := &"p7.return_under_control.reader_secured"
const FACT_TRACE := &"p7.return_under_control.trace"
const FACT_FEEDBACK := &"p7.return_under_control.safe_trial_feedback"

signal clue_inspected(id: String, prop_type: int)
signal reader_state_secured()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_ordinary_street_observed := false
var is_reader_state_secured := false
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
	_register_beat(&"s05_street_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s05_street_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Prace nocne. Zwykły znak, zwykły deszcz.", "Night work. An ordinary sign, ordinary rain.", &"", "")
	_register_beat(&"s05_defer_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Nie wiem jeszcze, co wróciło. Wiem, co zapisał czytnik.", "I do not know what returned. I know what the reader logged.", &"reader_cache", "secure_reader_state")
	_register_beat(&"s05_secure_reader", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zabezpieczę stan czytnika. Resztę sprawdzę później.", "I will secure the reader state. I will test the rest later.", &"", "")
	_register_beat(&"s05_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Obejrzyj ulicę, potem zabezpiecz czytnik przy sygnalizatorze.", "HINT: Observe the street, then secure the reader at the crossing signal.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_05"
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
		"ucp_notice_board", "street_corner":
			observe_ordinary_street()
		"crosswalk_signal":
			secure_reader_state()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func observe_ordinary_street() -> bool:
	if is_ordinary_street_observed or not _has(FACT_RESULT):
		_record_feedback(&"reader_trial_required")
		return false
	is_ordinary_street_observed = true
	_record(FACT_STREET, true)
	_report_progress(&"s05_ordinary_street_observed")
	if guidance_service:
		guidance_service.trigger_beat(&"s05_defer_hypothesis")
	queue_redraw()
	return true


func secure_reader_state() -> bool:
	if is_reader_state_secured:
		return false
	if not is_ordinary_street_observed:
		_record_feedback(&"street_observation_required")
		return false
	is_reader_state_secured = true
	_record(FACT_SECURED, true)
	_record(FACT_TRACE, "reader_secured_without_paranormal_claim")
	_record(&"ordinary_return_complete", true)
	reader_state_secured.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"reader_cache")
	_report_progress(&"s05_reader_state_secured")
	_unlock_exit()
	queue_redraw()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s05_" + value)


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
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
	return state != null and not String(state.decisions.get(key, "")).is_empty()


func _record(key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(key, value)


func _is_resolved(id: String) -> bool:
	match id:
		"ucp_notice_board", "street_corner": return is_ordinary_street_observed
		"crosswalk_signal": return is_reader_state_secured
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var street_color := VectorStageStyle.LIGHT_PLANE if is_ordinary_street_observed else VectorStageStyle.HUMAN_AMBER
	var reader_color := VectorStageStyle.ANCHOR_CYAN if is_reader_state_secured else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(150.0, 216.0), Vector2(190.0, 216.0), street_color, 3.0)
	draw_circle(Vector2(330.0, 250.0), 8.0, reader_color, false, 2.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(410.0, 216.0), Vector2(590.0, 212.0), exit_color, 2.0)
