class_name Station15
extends Node2D

## Station 15 — P9, komora pętli pomiarowej pod Linii 4: próba wzajemnego sygnału.
## Lena odtwarza przebieg próby z 20:40 z dziennika pętli, wysyła dwa identyczne
## impulsy kontrolne i dopiero potem trzeci z celowym błędem. Identyczne echo
## to wciąż nagranie; selektywna korekta celowego błędu dowodzi sprawczej
## odpowiedzi. Notatka serwisowa z warunkiem przerwania otwiera właz w górę
## i zostawia zamiar bez winnego.

## PRZESZKODA — dlaczego to tu jest: Pętla pomiarowa odpowiada własnym rytmem —
## wysłany impuls wraca zza szwu anomalii po stałym czasie, niezależnie od
## obecności Leny; serwisowy właz w górze to jedyne wyjście z komory.
## PRZESZKODA — czego wymaga od Leny: odtworzenia logu 20:40, wysłania dwóch
## identycznych impulsów kontrolnych i jednego z celowym błędem oraz odczytu
## notatki przy włazie.
## PRZESZKODA — koszt porażki: trzeci impuls bez dwóch kontroli zostawia
## wyłącznie informację o niekompletnym protokole; żaden wynik nie zamyka
## drogi do włazu.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_LOG := &"p9.mechanics.mutual_signal.log_reconstructed"
const FACT_CONTROL := &"p9.mechanics.mutual_signal.control_echo_observed"
const FACT_CORRECTIVE := &"p9.mechanics.mutual_signal.corrective_response_observed"
const FACT_NOTE := &"p9.mechanics.mutual_signal.abort_note_read"
const FACT_TRACE := &"p9.mechanics.mutual_signal.trace"
const FACT_FEEDBACK := &"p9.mechanics.mutual_signal.safe_trial_feedback"
## Donor key sekwencji P7: Station 16 (BUNDLE-23) oczekuje go jako wejścia
## do swojej próby instytucjonalnej; wartość opisuje teraz wykonaną próbę
## wzajemnego sygnału, nie prośbę o zapis pracy.
const FACT_P7_REQUEST := &"p7.work_history_and_record.own_record_requested"

const RESPONSE_TRAVEL_TIME := 1.4
const RESPONSE_ORIGIN := Vector2(420.0, 210.0)
const RESPONSE_TARGET := Vector2(268.0, 214.0)

signal clue_inspected(id: String, prop_type: int)
signal mutual_signal_test_completed()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var instrument_trace: VibrationTraceDisplay = get_node_or_null("InstrumentTrace")

var is_log_reconstructed := false
var control_impulses_sent := 0
var is_error_pattern_armed := false
var is_signal_confirmed := false
var is_note_read := false
var is_exit_unlocked := false
var is_level_completed := false

var _pending_impulse := false
var _pending_corrective := false
var _response_travel := 0.0
var _response_progress := 0.0
var _seam_phase := 0.0
var _impulse_player: AudioStreamPlayer
var _response_player: AudioStreamPlayer
var _impulse_sfx: AudioStreamWAV
var _response_sfx: AudioStreamWAV


func _ready() -> void:
	var presentation := preload("res://scripts/levels/creative_scene_presentation.gd").new()
	presentation.name = "CreativeScenePresentation"
	add_child(presentation)
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_props()
	_setup_audio()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	queue_redraw()


func _physics_process(delta: float) -> void:
	_seam_phase = fmod(_seam_phase + delta, TAU)
	if instrument_trace != null and player != null:
		var dist := player.global_position.distance_to(instrument_trace.global_position)
		instrument_trace.interference_factor = clampf(1.0 - (dist / 140.0), 0.0, 1.0)
	if _response_travel > 0.0:
		_response_travel = maxf(0.0, _response_travel - delta)
		_response_progress = 1.0 - _response_travel / RESPONSE_TRAVEL_TIME
		if _response_travel <= 0.0:
			_apply_response()
	queue_redraw()

func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s15_seam_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", &"")
	_register_beat(&"s15_echo_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Impuls wraca identyczny. To może być nagranie.", "The impulse returns identical. That could be a recording.", &"", &"")
	_register_beat(&"s15_living_response", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Jeżeli odpowiedź poprawi tylko celowy błąd, pochodzi od osoby, nie od nagrania.", "If the response corrects only the deliberate error, it comes from a person, not a recording.", &"living_response", &"corrective_third_impulse")
	_register_beat(&"s15_protocol_plan", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Dwa identyczne impulsy kontrolne, potem trzeci z celowym błędem. Różnica wskaże źródło.", "Two identical control impulses, then a third with a deliberate error. The difference names the source.", &"", &"corrective_third_impulse")
	_register_beat(&"s15_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Dziennik pętli, dwa impulsy kontrolne, impuls z błędem, notatka serwisowa.", "HINT: The loop logbook, two control impulses, the error impulse, the service note.", &"", &"")
	_register_beat(&"s15_log_reconstructed", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Próbę z 20:40 ucięła korekta spoza pętli. Ktoś ją przerwał od zewnątrz.", "The 20:40 trial was cut by a correction from outside the loop. Someone interrupted it.", &"", &"")
	_register_beat(&"s15_response_confirmed", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Odpowiedź poprawiła tylko mój celowy błąd. To żywy sygnał, nie echo.", "The response corrected only my deliberate error. That is a living signal, not an echo.", &"", &"")
	_register_beat(&"s15_abort_note", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Zostawiła warunek przerwania. To była decyzja, nie wypadek.", "She left an abort condition. This was a decision, not an accident.", &"", &"")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	if guidance_service == null:
		return
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_15"
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
		"loop_logbook":
			observe_signal_log()
		"signal_sender":
			if control_impulses_sent < 2:
				send_control_impulse()
			elif not is_error_pattern_armed and not is_signal_confirmed:
				arm_deliberate_error_pattern()
			else:
				send_corrective_impulse()
		"abort_note":
			read_abort_note()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func _setup_audio() -> void:
	_impulse_player = AudioStreamPlayer.new()
	_impulse_player.name = "ImpulseAudioPlayer"
	_impulse_player.bus = &"Master"
	add_child(_impulse_player)
	_response_player = AudioStreamPlayer.new()
	_response_player.name = "ResponseAudioPlayer"
	_response_player.bus = &"Master"
	add_child(_response_player)
	_impulse_sfx = ProceduralAudio.create_correction_pulse_sound()
	_response_sfx = ProceduralAudio.create_contact_tap_sound()

func observe_signal_log() -> bool:
	if is_log_reconstructed:
		return true
	is_log_reconstructed = true
	_record(FACT_LOG, "trial_2040_ucp_correction")
	_record(&"ucp_intervention_reconstructed", true)
	if guidance_service != null:
		guidance_service.trigger_beat(&"s15_log_reconstructed")
	_report_progress(&"s15_log_reconstructed")
	queue_redraw()
	return true


func send_control_impulse() -> bool:
	if not is_log_reconstructed:
		_record_feedback(&"sender_not_armed")
		return false
	if _pending_impulse:
		return false
	_pending_impulse = true
	_pending_corrective = false
	_start_response_travel()
	return true


func send_corrective_impulse() -> bool:
	if control_impulses_sent < 2:
		_record_feedback(&"controls_incomplete")
		return false
	if not is_log_reconstructed:
		_record_feedback(&"sender_not_armed")
		return false
	if _pending_impulse:
		return false
	_pending_impulse = true
	_pending_corrective = true
	_start_response_travel()
	return true


## CR-B (PKG-0194): jawna czynność przygotowania celowo błędnego trzeciego
## wzoru w tym samym nadajniku. Nie zapisuje faktu i nie wysyła impulsu;
## samo uzbrojenie. Bezpośrednie wołanie send_corrective_impulse() (bramki
## PKG-0163) działa bez niego; ścieżka MRP wymaga go przed wysłaniem.
func arm_deliberate_error_pattern() -> bool:
	if is_error_pattern_armed or is_signal_confirmed:
		return false
	if not is_log_reconstructed:
		_record_feedback(&"sender_not_armed")
		return false
	if control_impulses_sent < 2:
		_record_feedback(&"controls_incomplete")
		return false
	is_error_pattern_armed = true
	_report_progress(&"s15_error_pattern_armed")
	queue_redraw()
	return true


func run_response_cycle() -> void:
	## Deterministyczny wyzwalacz odpowiedzi pętli (testy, capture, debug).
	_apply_response()


func is_sender_armed() -> bool:
	return is_log_reconstructed


## CR-B: odpowiedź pętli nadchodzi z opóźnieniem. Prezenter pomija kolejkowanie
## w chwili wysłania (oczekujący impuls) i dostarcza rozmowę dopiero, gdy echo
## faktycznie wraca — przez ten sam sygnał co akcje MRP.
func is_response_pending() -> bool:
	return _pending_impulse


func are_controls_complete() -> bool:
	return control_impulses_sent >= 2


func _start_response_travel() -> void:
	_response_travel = RESPONSE_TRAVEL_TIME
	_response_progress = 0.0
	if _impulse_player != null and _impulse_sfx != null:
		_impulse_player.stream = _impulse_sfx
		_impulse_player.play()


func _apply_response() -> void:
	if not _pending_impulse:
		return
	_pending_impulse = false
	if _response_player != null and _response_sfx != null:
		_response_player.stream = _response_sfx
		_response_player.play()
	if _pending_corrective:
		_pending_corrective = false
		if not is_signal_confirmed:
			is_signal_confirmed = true
			_record(FACT_CORRECTIVE, "deliberate_error_corrected_selectively")
			_record(FACT_TRACE, "living_response_confirmed")
			_record(&"local_lena_signal_confirmed", true)
			if guidance_service != null:
				guidance_service.close_hypothesis(&"living_response")
				guidance_service.trigger_beat(&"s15_response_confirmed", true)
			mutual_signal_test_completed.emit()
			_report_progress(&"s15_signal_confirmed")
	else:
		control_impulses_sent += 1
		if control_impulses_sent >= 2 and not _decision_bool(FACT_CONTROL):
			_record(FACT_CONTROL, "echo_repeats_identically")
			if guidance_service != null:
				guidance_service.trigger_beat(&"s15_echo_contact")
	clue_inspected.emit("signal_sender", 8)
	queue_redraw()


func read_abort_note() -> bool:
	if not is_signal_confirmed:
		_record_feedback(&"response_not_confirmed")
		return false
	if is_note_read:
		return true
	is_note_read = true
	_record(FACT_NOTE, "abort_condition_before_cost")
	_record(&"local_lena_intent_found", true)
	_record(FACT_P7_REQUEST, true)
	if guidance_service != null:
		guidance_service.trigger_beat(&"s15_abort_note", true)
	_report_progress(&"s15_abort_note_read")
	_unlock_exit()
	queue_redraw()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	GapLedger.annotate_feedback(self, value) # PKG-0215 (D-228): blocked verb speaks its gap, if any.
	if guidance_service != null:
		guidance_service.report_failed_attempt(&"s15_" + value)


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	pass  # PKG-0174: ThresholdZone requires interact


func _complete_if_player_already_in_airlock() -> void:
	if airlock_zone != null and player != null and airlock_zone.overlaps_body(player):
		_trigger_level_completion()


func _on_airlock_body_entered(_body: Node2D) -> void:
	# PKG-0174: AirlockZone is a closure zone, not a trigger.
	pass


func _trigger_level_completion() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _is_resolved(id: String) -> bool:
	match id:
		"loop_logbook":
			return is_log_reconstructed
		"signal_sender":
			return is_signal_confirmed
		"abort_note":
			return is_note_read
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
	# PKG-0218 (V1): stage apron first (D-136).
	VectorStageStyle.draw_stage_apron(self, Vector2(640.0, 360.0))
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	_draw_chamber()
	_draw_receivers()
	_draw_seam()
	_draw_station_props()
	_draw_exit()


func _draw_chamber() -> void:
	# Plany tła — komora pętli: techniczna baza rodziny, zimne wypełnienie.
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), Color("10171c"))
	draw_rect(Rect2(0.0, 0.0, 640.0, 84.0), Color("1a262c"))
	draw_rect(Rect2(0.0, 84.0, 640.0, 190.0), Color("1e2a30"))
	draw_rect(Rect2(0.0, 274.0, 640.0, 54.0), Color("0c1216"))
	draw_line(Vector2(0.0, 274.0), Vector2(640.0, 274.0), Color("2c3a41"), 1.0)
	draw_rect(Rect2(96.0, 288.0, 220.0, 10.0), Color("070b0e"))
	# PKG-0179: 14 px raised receiver base plinth (x in [210, 430], top at 282, height 14 px)
	var base_rect := Rect2(210.0, 282.0, 220.0, 14.0)
	draw_rect(base_rect, Color("1a2931"))
	draw_rect(base_rect, Color("2d4653"), false, 1.0)
	draw_line(Vector2(210.0, 282.0), Vector2(430.0, 282.0), VectorStageStyle.ANCHOR_CYAN, 1.5)
	# Rury i kanał kablowy prowadzą wzrok do szwu anomalii.
	draw_line(Vector2(120.0, 108.0), Vector2(352.0, 132.0), Color("46565c"), 8.0)
	draw_line(Vector2(60.0, 232.0), Vector2(180.0, 268.0), Color("3d4b51"), 6.0)
	draw_circle(Vector2(120.0, 108.0), 4.0, Color("66747a"))
	# Korpus odbieracza pętli — masa maszyny po lewej stronie szwu.
	draw_rect(Rect2(150.0, 96.0, 170.0, 178.0), Color("263943"))
	draw_rect(Rect2(150.0, 96.0, 170.0, 10.0), Color("31505a"))
	draw_line(Vector2(235.0, 106.0), Vector2(235.0, 274.0), Color("1d2b32"), 2.0)
	var rivet_x := 160.0
	while rivet_x <= 310.0:
		draw_circle(Vector2(rivet_x, 266.0), 1.5, Color("3c4d55"))
		rivet_x += 24.0
	# Robocze światło na nadajnik oraz jedno światło niezgodne z resztą kadru.
	draw_polygon(
		PackedVector2Array([
			Vector2(288.0, 62.0), Vector2(328.0, 62.0),
			Vector2(392.0, 274.0), Vector2(238.0, 274.0),
		]),
		PackedColorArray([Color(1.0, 0.94, 0.82, 0.05)])
	)
	draw_rect(Rect2(284.0, 56.0, 48.0, 6.0), Color("66747a"))
	# Światło niezgodne: jedyna lampa świeci w górę, pod sufit, nie na stanowisko.
	draw_polygon(
		PackedVector2Array([
			Vector2(496.0, 132.0), Vector2(534.0, 132.0),
			Vector2(560.0, 84.0), Vector2(470.0, 84.0),
		]),
		PackedColorArray([Color(1.0, 0.94, 0.82, 0.06)])
	)
	draw_rect(Rect2(498.0, 128.0, 34.0, 5.0), Color("66747a"))


func _draw_receivers() -> void:
	# Ten sam element pętli istnieje w dwóch wersjach: po lewej stronie szwu
	# cewka z igłą przy godzienie próby, za szwem drugi egzemplarz, przygaszony,
	# z igłą odchyloną w przeciwną stronę.
	draw_arc(Vector2(250.0, 214.0), 24.0, 0.0, TAU, 20, Color("66747a"), 1.5)
	draw_line(Vector2(250.0, 214.0), Vector2(266.0, 198.0), Color("d39a62"), 2.0)
	draw_arc(Vector2(250.0, 214.0), 32.0, PI, TAU, 20, Color("3c4d55"), 2.0)
	draw_arc(Vector2(412.0, 214.0), 24.0, 0.0, TAU, 20, Color("4a5a60"), 1.2)
	draw_line(Vector2(412.0, 214.0), Vector2(428.0, 230.0), Color("8a7a5a"), 2.0)
	draw_arc(Vector2(412.0, 214.0), 32.0, 0.0, PI, 20, Color("33414a"), 2.0)


func _draw_seam() -> void:
	# Szew anomalii: jedna pionowa krawędź oddziela dwa stany komory.
	var shimmer := 0.35 + 0.1 * sin(_seam_phase * 2.0)
	draw_line(Vector2(352.0, 40.0), Vector2(352.0, 296.0), Color(VectorStageStyle.SEAM_RED, shimmer), 2.0)
	draw_line(Vector2(354.0, 40.0), Vector2(354.0, 296.0), Color(VectorStageStyle.LIGHT_PLANE, 0.12), 1.0)


func _draw_station_props() -> void:
	# Nadajnik pętli przy szwie — stan protokołu czytelny bez tekstu.
	var sender_color := VectorStageStyle.ANCHOR_CYAN if is_signal_confirmed else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(316.0, 236.0, 44.0, 38.0), Color("263943"))
	draw_rect(Rect2(322.0, 226.0, 32.0, 12.0), sender_color, false, 1.5)
	if _pending_impulse:
		var pulse_pos := RESPONSE_ORIGIN.lerp(RESPONSE_TARGET, _response_progress)
		var pulse_color := VectorStageStyle.SEAM_RED if _pending_corrective else VectorStageStyle.LIGHT_PLANE
		draw_circle(pulse_pos, 3.0, pulse_color)
	# Dziennik pętli.
	var log_color := VectorStageStyle.ANCHOR_CYAN if is_log_reconstructed else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(112.0, 246.0, 26.0, 14.0), log_color, false, 1.0)
	# Notatka serwisowa: nośnik zamiaru, czytelna dopiero po potwierdzeniu.
	var note_color := VectorStageStyle.ANCHOR_CYAN if is_note_read else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.55)
	draw_polygon(
		PackedVector2Array([
			Vector2(508.0, 246.0), Vector2(530.0, 246.0),
			Vector2(526.0, 260.0), Vector2(504.0, 260.0),
		]),
		PackedColorArray([note_color])
	)


func _draw_exit() -> void:
	# Serwisowy właz w górze przy drabinie; kolor pionu pokazuje stan wyjścia.
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(576.0, 148.0, 48.0, 10.0), exit_color, false, 1.5)
	draw_line(Vector2(612.0, 158.0), Vector2(612.0, 296.0), exit_color, 2.0)
	# PKG-0198 (ZERO wycinek 2): cień kontaktowy cokołu odbiornika w prawo,
	# 0.48, zgodnie z lampą nadajnika i konwencją 01/06/08. Drabinę rysuje
	# wyłącznie LadderZone (kanon 9.3); pomiar w bramce 0198.
	draw_colored_polygon(PackedVector2Array([
		Vector2(202.0, 294.0), Vector2(438.0, 292.0),
		Vector2(446.0, 300.0), Vector2(210.0, 302.0),
	]), Color(VectorStageStyle.INK, 0.48))