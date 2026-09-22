class_name Station01
extends Node2D

## Station 01 — S01, próba i obietnica.
## Rozbieżność: rejestrator gubi trzy sekundy mimo działającego pomiaru.
## Próba: sprawdzić mocowanie, zachować surowy zapis i powtórzyć odczyt.
## Zobowiązanie: zachować próbkę zamiast ukryć opóźnienie.

## PRZESZKODA — dlaczego to tu jest: Komora pomiarowa Linii 4 zamyka się po rejestracji czystego odczytu, bo procedura wymaga dwóch niezależnych zapisów.
## PRZESZKODA — czego wymaga od Leny: sprawdzenia mocowania i surowego zapisu przed powtórzeniem pomiaru.
## PRZESZKODA — koszt porażki: powtórzenie pomiaru bez obu źródeł tworzy jedynie informację o braku porównania i nie otwiera śluzy.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_GAP := &"p7.sample_and_promise.gap_observed"
const FACT_MOUNT := &"p7.sample_and_promise.mount_checked"
const FACT_RAW := &"p7.sample_and_promise.raw_record_checked"
const FACT_RESULT := &"p7.sample_and_promise.measurement_result"
const FACT_FEEDBACK := &"p7.sample_and_promise.safe_trial_feedback"
const FACT_SAMPLE := &"p7.sample_and_promise.sample_preserved"

signal clue_inspected(id: String, prop_type: int)
signal measurement_trial_completed(result: StringName)
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var chamber_door: AnimatableBody2D = $ChamberDoor
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_gap_observed := false
var is_mount_checked := false
var is_raw_record_checked := false
var is_measurement_repeated := false
var is_sample_preserved := false
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
	_register_beat(&"s01_measurement_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s01_measurement_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Trzy sekundy nie są szumem. Najpierw mocowanie.", "Three seconds are not noise. Check the mount first.", &"", "")
	_register_beat(&"s01_sensor_fault", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Czujnik albo uchwyt. Powtórzę po sprawdzeniu.", "Sensor or mount. I will repeat after checking.", &"sensor_fault", "repeat_after_mount_check")
	_register_beat(&"s01_repeat_measurement", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Sprawdzę uchwyt, surowy zapis i wykonam czysty odczyt.", "Check the mount, raw log, then make a clean reading.", &"", "")
	_register_beat(&"s01_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Porównaj mocowanie z surowym zapisem, potem powtórz pomiar.", "HINT: Compare the mount with the raw log, then repeat the measurement.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_01"
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
		"vibration_sensor":
			observe_measurement_gap()
		"circuit_alpha":
			inspect_sensor_mount()
		"chamber_terminal":
			record_raw_measurement()
		"vacuum_manometer":
			repeat_measurement()
		"packing_bag":
			preserve_raw_sample()
		"photo_desk", "clipboard", "circuit_beta", "circuit_gamma":
			prop.is_activated = true
			clue_inspected.emit(id, prop_type)
			return
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func observe_measurement_gap() -> bool:
	if is_gap_observed:
		return false
	is_gap_observed = true
	_record(FACT_GAP, true)
	_report_progress(&"s01_gap_observed")
	if guidance_service:
		guidance_service.trigger_beat(&"s01_sensor_fault")
	queue_redraw()
	return true


func inspect_sensor_mount() -> bool:
	if not is_gap_observed or is_mount_checked:
		_record_feedback(&"gap_required")
		return false
	is_mount_checked = true
	_record(FACT_MOUNT, true)
	_report_progress(&"s01_mount_checked")
	queue_redraw()
	return true


func record_raw_measurement() -> bool:
	if not is_gap_observed or is_raw_record_checked:
		_record_feedback(&"gap_required")
		return false
	is_raw_record_checked = true
	_record(FACT_RAW, true)
	_report_progress(&"s01_raw_record_checked")
	queue_redraw()
	return true


func repeat_measurement() -> bool:
	if is_measurement_repeated:
		return false
	if not (is_mount_checked and is_raw_record_checked):
		_record_feedback(&"mount_or_raw_record_missing")
		return false
	is_measurement_repeated = true
	_record(FACT_RESULT, "gap_retained_after_mount_check")
	_record(&"home_sample_preserved", true)
	measurement_trial_completed.emit(&"gap_retained_after_mount_check")
	if guidance_service:
		guidance_service.close_hypothesis(&"sensor_fault")
		guidance_service.close_hypothesis(&"mount_fault")
	_report_progress(&"s01_measurement_repeated")
	queue_redraw()
	return true


func preserve_raw_sample() -> bool:
	if is_sample_preserved:
		return false
	if not is_measurement_repeated:
		_record_feedback(&"measurement_trial_required")
		return false
	is_sample_preserved = true
	_record(FACT_SAMPLE, true)
	_report_progress(&"s01_sample_preserved")
	_unlock_exit()
	queue_redraw()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s01_" + value)


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


func _record(key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(key, value)


func _is_resolved(id: String) -> bool:
	match id:
		"vibration_sensor": return is_gap_observed
		"circuit_alpha": return is_mount_checked
		"chamber_terminal": return is_raw_record_checked
		"vacuum_manometer": return is_measurement_repeated
		"packing_bag": return is_sample_preserved
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var gap_color := VectorStageStyle.CORRECTION_OXIDE if is_gap_observed else VectorStageStyle.HUMAN_AMBER
	var mount_color := VectorStageStyle.ANCHOR_CYAN if is_mount_checked else VectorStageStyle.HUMAN_AMBER
	var raw_color := VectorStageStyle.LIGHT_PLANE if is_raw_record_checked else VectorStageStyle.HUMAN_AMBER
	var result_color := VectorStageStyle.ANCHOR_CYAN if is_measurement_repeated else VectorStageStyle.HUMAN_AMBER
	draw_circle(Vector2(270.0, 255.0), 8.0, gap_color, false, 2.0)
	draw_line(Vector2(238.0, 255.0), Vector2(260.0, 255.0), mount_color, 3.0)
	draw_line(Vector2(392.0, 255.0), Vector2(420.0, 255.0), raw_color, 3.0)
	draw_line(Vector2(344.0, 255.0), Vector2(366.0, 255.0), result_color, 3.0)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(566.0, 174.0), Vector2(566.0, 252.0), exit_color, 2.0)
