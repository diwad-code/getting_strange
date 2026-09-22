class_name Station14
extends Node2D

## Station 14 — P9, rozdzielnia trakcyjna przy Linii 4: pierwsza lekcja martwego obwodu.
## Rozdzielnica pracuje własnym cyklem serwisowym i regularnie wystawia most sekcji
## na falę korekty. Utrzymany most zostaje wersją A; puszczony przejdzie wersją B,
## a sekcja za nim gaśnie. Po wykonaniu obu zachowań metoda dostaje nazwę.

## PRZESZKODA — dlaczego to tu jest: Rozdzielnia co cykl serwisowy sama wystawia most sekcji na falę korekty, bo tak wygląda jej praca, niezależna od obecności Leny.
## PRZESZKODA — czego wymaga od Leny: obserwacji cyklu i jednego gestu ręki przy moście — utrzymania go albo puszczenia.
## PRZESZKODA — koszt porażki: puszczony most zostaje w wersji B i sekcja za mostem gaśnie; kolejny cykl pozwala utrzymać wersję A z powrotem, bez blokady wyjścia.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_CYCLE := &"p9.mechanics.dead_circuit.cycle_observed"
const FACT_ANCHOR := &"p9.mechanics.dead_circuit.anchor_held_through_pulse"
const FACT_COST := &"p9.mechanics.dead_circuit.yield_cost_observed"
const FACT_REVERSAL := &"p9.mechanics.dead_circuit.version_restored"
const FACT_TRACE := &"p9.mechanics.dead_circuit.trace"
const FACT_FEEDBACK := &"p9.mechanics.dead_circuit.safe_trial_feedback"
## Ślad sekwencji marta_threshold pozostaje bramką wejścia Station 15 (BUNDLE-22);
## wartość opisuje teraz lekcję martwego obwodu, nie próg Marty.
const FACT_P7_TRACE := &"p7.marta_threshold.trace"
const FACT_P7_OUTCOME := &"p7.marta_threshold.marta_threshold"

const PULSE_FIRST_DELAY := 4.0
const PULSE_INTERVAL := 7.0
const PULSE_TRAVEL_TIME := 1.6
const PULSE_ORIGIN := Vector2(470.0, 170.0)
const PULSE_TARGET := Vector2(395.0, 176.0)

signal clue_inspected(id: String, prop_type: int)
signal dead_circuit_trial_completed()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var bridge: AnchorableObject = $Machine/TractionBridge
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_cycle_observed := false
var has_anchored_through_pulse := false
var has_yielded_to_pulse := false
var has_restored_version := false
var are_behaviors_named := false
var is_exit_unlocked := false
var is_level_completed := false

var _cycle_timer := PULSE_INTERVAL - PULSE_FIRST_DELAY
var _pulse_travel := 0.0
var _pulse_progress := 0.0
var _drum_phase := 0.0
var _correction_player: AudioStreamPlayer
var _correction_sfx: AudioStreamWAV


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_props()
	_setup_audio()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	queue_redraw()


func _physics_process(delta: float) -> void:
	_drum_phase = fmod(_drum_phase + delta, TAU)
	if _pulse_travel > 0.0:
		_pulse_travel = maxf(0.0, _pulse_travel - delta)
		_pulse_progress = 1.0 - _pulse_travel / PULSE_TRAVEL_TIME
		if _pulse_travel <= 0.0:
			_apply_correction_pulse()
	else:
		_cycle_timer += delta
		if _cycle_timer >= PULSE_INTERVAL:
			_cycle_timer = 0.0
			_start_correction_pulse()
	if bridge != null and player != null:
		bridge.update_player_distance(player.global_position)
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"interact") and not event.is_echo():
		_handle_anchor_toggle()
		get_viewport().set_input_as_handled()


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s14_machine_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", &"")
	_register_beat(&"s14_cycle_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Fala korekty idzie z maszyny. Utrzymam most i zobaczę, co zrobi.", "A correction wave comes from the machine. I will hold the bridge and watch.", &"", &"")
	_register_beat(&"s14_cost_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Jeżeli puszczę most, fala przełoży go na cienki montaż, a sekcja za nim zgaśnie. Koszt zostanie w sekcji.", "If I let go, the wave re-rigs the bridge and the section behind it dies. The cost stays in the section.", &"dead_circuit", "yield_then_read_section")
	_register_beat(&"s14_planned_trial", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Utrzymam wersję A w czasie fali, potem puszczę i przywrócę ją z kolejnym cyklem.", "Hold version A through the wave, then let go and restore it on a later cycle.", &"", &"")
	_register_beat(&"s14_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Stań przy moście, utrzymaj go w czasie fali, potem puść i pozwól fali przełożyć montaż.", "HINT: Stand by the bridge, hold it through the wave, then release and let the wave re-rig it.", &"", &"")
	_register_beat(&"s14_method_named", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Utrzymanie i uległość. Dwa ruchy jednej metody — sekcja pokazała różnicę.", "Holding and yielding. Two motions of one method — the section showed the difference.", &"", &"")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	if guidance_service == null:
		return
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_14"
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
		"relay_logbook":
			observe_machine_cycle()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func _setup_audio() -> void:
	_correction_player = AudioStreamPlayer.new()
	_correction_player.name = "CorrectionAudioPlayer"
	_correction_player.bus = &"Master"
	add_child(_correction_player)
	_correction_sfx = ProceduralAudio.create_correction_pulse_sound()


func _handle_anchor_toggle() -> void:
	if bridge == null or player == null:
		return
	if bridge.get_distance_to_point(player.global_position) > bridge.interaction_radius:
		_record_feedback(&"no_element_in_reach")
		return
	bridge.toggle_anchor()
	queue_redraw()


func observe_machine_cycle() -> bool:
	is_cycle_observed = true
	if not _decision_bool(FACT_CYCLE):
		_record(FACT_CYCLE, "machine_cycle_independent")
	_report_progress(&"s14_cycle_observed")
	queue_redraw()
	return true


func hold_observed_element() -> bool:
	if bridge == null:
		return false
	bridge.set_anchored(true)
	queue_redraw()
	return bridge.is_anchored


func release_observed_element() -> bool:
	if bridge == null:
		return false
	bridge.set_anchored(false)
	queue_redraw()
	return not bridge.is_anchored


func run_correction_pulse() -> void:
	## Deterministyczny wyzwalacz jednego cyklu maszyny (testy, capture, debug).
	_start_correction_pulse()
	_apply_correction_pulse()


func is_section_live() -> bool:
	return bridge != null and bridge.current_reality == AnchorableObject.RealityState.STATE_A


func _start_correction_pulse() -> void:
	_pulse_travel = PULSE_TRAVEL_TIME
	_pulse_progress = 0.0
	if _correction_player != null and _correction_sfx != null:
		_correction_player.stream = _correction_sfx
		_correction_player.play()


func _apply_correction_pulse() -> void:
	is_cycle_observed = true
	_record_cycle_once()
	if bridge == null:
		return
	var was_live := is_section_live()
	var target := AnchorableObject.RealityState.STATE_B if was_live else AnchorableObject.RealityState.STATE_A
	# Donor decyduje: utrzymany most opiera się fali, puszczony przechodzi
	# na drugi montaż. Stacja tylko czyta skutek i zapisuje fakty.
	bridge.apply_reality_shift(target, true)
	var now_live := is_section_live()
	if bridge.is_anchored:
		if not has_anchored_through_pulse:
			has_anchored_through_pulse = true
			_record(FACT_ANCHOR, "version_maintained_under_wave")
	else:
		has_yielded_to_pulse = true
		if not now_live and was_live and not _decision_bool(FACT_COST):
			_record(FACT_COST, "dead_section_downstream")
		if now_live and not was_live:
			has_restored_version = true
			_record(FACT_REVERSAL, "version_a_returned_by_cycle")
	_try_name_behaviors()
	queue_redraw()


func _record_cycle_once() -> void:
	if not _decision_bool(FACT_CYCLE):
		_record(FACT_CYCLE, "machine_cycle_independent")


func _try_name_behaviors() -> void:
	if are_behaviors_named:
		return
	if not (has_anchored_through_pulse and has_yielded_to_pulse):
		return
	are_behaviors_named = true
	_record(FACT_TRACE, "two_behaviors_before_named")
	_record(FACT_P7_TRACE, "dead_circuit_lesson_observed")
	_record(FACT_P7_OUTCOME, "method_observed_before_named")
	if guidance_service != null:
		guidance_service.close_hypothesis(&"dead_circuit")
		guidance_service.trigger_beat(&"s14_method_named", true)
	dead_circuit_trial_completed.emit()
	_report_progress(&"s14_method_named")
	_unlock_exit()
	queue_redraw()


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service != null:
		guidance_service.report_failed_attempt(&"s14_" + value)


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


func _is_resolved(id: String) -> bool:
	match id:
		"relay_logbook":
			return _decision_bool(FACT_CYCLE)
	return false


func _decision_bool(key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	if state == null:
		return false
	var value: Variant = state.decisions.get(key, false)
	if value is bool:
		return value
	if value is String:
		return not String(value).is_empty()
	return false


func _record(key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(key, value)


func _report_progress(progress_id: StringName) -> void:
	if guidance_service != null:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	# Plany tła — hala rozdzielni: zimne wypełnienie z góry, głęboki cień pod maszyną.
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), Color("10171c"))
	draw_rect(Rect2(0.0, 0.0, 640.0, 84.0), Color("1a262c"))
	draw_rect(Rect2(0.0, 84.0, 640.0, 190.0), Color("1e2a30"))
	draw_rect(Rect2(0.0, 274.0, 640.0, 54.0), Color("0c1216"))
	draw_line(Vector2(0.0, 274.0), Vector2(640.0, 274.0), Color("2c3a41"), 1.0)
	draw_rect(Rect2(316.0, 288.0, 250.0, 10.0), Color("070b0e"))
	# Diagonale instalacji prowadzą wzrok do mostu sekcji.
	draw_line(Vector2(470.0, 120.0), Vector2(560.0, 196.0), Color("46565c"), 10.0)
	draw_line(Vector2(210.0, 150.0), Vector2(150.0, 214.0), Color("3d4b51"), 8.0)
	draw_circle(Vector2(560.0, 196.0), 5.0, Color("66747a"))
	draw_circle(Vector2(150.0, 214.0), 4.0, Color("66747a"))
	# Korpus rozdzielni — maszyna zajmuje ponad jedną trzecią kadru i pracuje sama.
	draw_rect(Rect2(210.0, 96.0, 260.0, 178.0), Color("263943"))
	draw_rect(Rect2(210.0, 96.0, 260.0, 10.0), Color("31505a"))
	draw_line(Vector2(340.0, 106.0), Vector2(340.0, 274.0), Color("1d2b32"), 2.0)
	var rivet_x := 222.0
	while rivet_x <= 458.0:
		draw_circle(Vector2(rivet_x, 266.0), 1.5, Color("3c4d55"))
		rivet_x += 26.0
	draw_circle(Vector2(340.0, 160.0), 26.0, Color("2c4650"))
	draw_arc(Vector2(340.0, 160.0), 26.0, 0.0, TAU, 24, Color("66747a"), 1.5)
	var arm_angle := _drum_phase * 0.9
	draw_line(
		Vector2(340.0, 160.0),
		Vector2(340.0, 160.0) + Vector2(cos(arm_angle), sin(arm_angle)) * 20.0,
		Color("d39a62"),
		2.0
	)
	# Rama montażowa i doprowadzenie mostu sekcji.
	draw_line(Vector2(339.0, 168.0), Vector2(339.0, 196.0), Color("3c4d55"), 3.0)
	draw_line(Vector2(451.0, 168.0), Vector2(451.0, 196.0), Color("3c4d55"), 3.0)
	draw_line(Vector2(470.0, 170.0), Vector2(451.0, 176.0), Color("46565c"), 6.0)
	# Robocze światło na stanowisko; martwa sekcja przygasa maszynie.
	var light_alpha := 0.06 if is_section_live() else 0.02
	draw_polygon(
		PackedVector2Array([
			Vector2(300.0, 62.0), Vector2(340.0, 62.0),
			Vector2(430.0, 274.0), Vector2(210.0, 274.0),
		]),
		PackedColorArray([Color(1.0, 0.94, 0.82, light_alpha)])
	)
	draw_rect(Rect2(296.0, 56.0, 48.0, 6.0), Color("66747a"))
	if not is_section_live():
		draw_rect(Rect2(210.0, 96.0, 260.0, 178.0), Color(0.0, 0.0, 0.0, 0.35), true)
	# Lampa sekcji: stan kosztu czytelny bez tekstu.
	var lamp_pos := Vector2(540.0, 196.0)
	if is_section_live():
		draw_circle(lamp_pos, 6.0, Color("d39a62"))
		draw_arc(lamp_pos, 9.0, 0.0, TAU, 12, Color("d39a62", 0.4), 1.0)
	else:
		draw_arc(lamp_pos, 6.0, 0.0, TAU, 12, Color("3c4d55"), 1.5)
	# Fala korekty maszyny podchodzi pod most.
	if _pulse_travel > 0.0:
		var pulse_pos := PULSE_ORIGIN.lerp(PULSE_TARGET, _pulse_progress)
		draw_circle(pulse_pos, 3.0, Color("c65d58"))
	draw_rect(Rect2(210.0, 274.0, 260.0, 22.0), Color("070b0e"))
	var exit_color := Color("75c7c3") if is_exit_unlocked else Color("d39a62")
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_color, 2.0)