class_name Station16
extends Node2D

## Station 16 — P9, bezpieczny analizator i wybór małego kosztu.
## Odpowiedź z poprzedniej komory trafia do analizatora, który pokazuje dwa
## wiarygodne odczyty tego samego śladu. Lena wybiera jeden szczegół, który
## może stracić ostrość, a potem sprawdza, czy echo domu wraca bez wymiany.

## PRZESZKODA — dlaczego to tu jest: Analizator pracuje w trybie ochronnym i
## utrzymuje ślad w dwóch wersjach, ponieważ urządzenie porównuje próbkę z
## pamięcią zamiast nadpisywać ją jednym wynikiem.
## PRZESZKODA — czego wymaga od Leny: przekazania odpowiedzi, wybrania jednego
## szczegółu kosztu oraz potwierdzenia echa domu przy odbiorniku.
## PRZESZKODA — koszt porażki: przedwczesny wybór lub odbiór zapisuje brakujący
## krok, ale nie usuwa wcześniejszych obserwacji i nie zamyka drogi.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const AnchorableObject := preload("res://scripts/interactables/anchorable_object.gd")

const FACT_ENTRY := &"p7.work_history_and_record.own_record_requested"
const FACT_RESPONSE := &"p9.mechanics.safe_analyzer.response_transferred"
const FACT_COST_CHOICE := &"p9.mechanics.small_cost.choice"
const FACT_COST_MANIFESTED := &"p9.mechanics.small_cost.manifested"
const FACT_HOME_ECHO := &"p9.mechanics.small_cost.home_echo_verified"
const FACT_TRACE := &"p9.mechanics.small_cost.trace"
const FACT_FEEDBACK := &"p9.mechanics.small_cost.safe_trial_feedback"
const FACT_MECHANIC_COST := &"mechanic_cost_observed"
const FACT_SMALL_COST := &"small_cost_manifested"
const FACT_HOME_ECHO_CANONICAL := &"home_echo_verified"
const FACT_S06_TRIAL := &"p7.work_history_and_record.institution_trial_result"

const COST_MARTA_MEMORY := &"marta_first_meeting_detail_blurred"
const COST_SAMPLE_SECOND := &"sample_exact_second_lost"

signal clue_inspected(id: String, prop_type: int)
signal response_transferred()
signal small_cost_manifested(cost_id: StringName)
signal home_echo_verified()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var analyzer_relay: AnchorableObject = $Machine/SafeAnalyzerRelay
@onready var cost_selector: MemoryResonancePoint = $Props/CostSelector
@onready var home_echo_receiver: MemoryResonancePoint = $Props/HomeEchoReceiver
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var home_echo_audio: AudioStreamPlayer = $HomeEchoAudioPlayer

var is_response_transferred := false
var is_cost_selected := false
var is_home_echo_confirmed := false
var is_exit_unlocked := false
var is_level_completed := false
var selected_cost: StringName = &""
var last_feedback: StringName = &""

var _analyzer_phase := 0.0
var _echo_phase := 0.0
var _home_echo_sfx: AudioStreamWAV


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
	_analyzer_phase = fmod(_analyzer_phase + delta, TAU)
	_echo_phase = fmod(_echo_phase + delta, TAU)
	if analyzer_relay != null and player != null:
		analyzer_relay.update_player_distance(player.global_position)
	queue_redraw()


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s16_analyzer_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s16_analyzer_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Odpowiedź przechodzi do bezpiecznego analizatora.", "The response enters the safe analyzer.", &"", "")
	_register_beat(&"s16_small_cost_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Może wystarczy utrzymać jeden szczegół. Sprawdzę, co zostanie ostrzejsze.", "Maybe one detail can stay sharp. I will check what remains clear.", &"small_cost", "choose_marta_memory_cost")
	_register_beat(&"s16_cost_plan", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Przeniosę odpowiedź, wybiorę jeden szczegół i potwierdzę echo domu.", "Transfer the response, choose one detail, and confirm the home echo.", &"", "confirm_home_echo")
	_register_beat(&"s16_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Analizator, jeden wybór kosztu, odbiornik echa.", "HINT: Analyzer, one cost choice, echo receiver.", &"", "")
	_register_beat(&"s16_home_echo_confirmed", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Echo domu wraca po jednym małym ubytku.", "The home echo returns after one small loss.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_16"
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


func _setup_audio() -> void:
	if home_echo_audio == null:
		home_echo_audio = AudioStreamPlayer.new()
		home_echo_audio.name = "HomeEchoAudioPlayer"
		home_echo_audio.bus = &"Master"
		add_child(home_echo_audio)
	_home_echo_sfx = ProceduralAudio.create_contact_tap_sound()


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	match id:
		"safe_analyzer":
			transfer_response_to_safe_analyzer()
		"cost_selector":
			choose_cost_from_player_side()
		"home_echo_receiver":
			confirm_home_echo()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func transfer_response_to_safe_analyzer() -> bool:
	if is_response_transferred:
		return false
	if not _has(FACT_ENTRY):
		_record_feedback(&"previous_response_required")
		return false
	is_response_transferred = true
	_record(FACT_RESPONSE, "living_response_loaded")
	if analyzer_relay != null:
		analyzer_relay.apply_reality_shift(AnchorableObject.RealityState.STATE_B, true)
	if guidance_service:
		guidance_service.trigger_beat(&"s16_analyzer_contact")
	_report_progress(&"s16_response_transferred")
	response_transferred.emit()
	queue_redraw()
	return true


func inspect_safe_analyzer() -> bool:
	return transfer_response_to_safe_analyzer()


func observe_safe_analyzer() -> bool:
	return transfer_response_to_safe_analyzer()


func choose_marta_memory_cost() -> bool:
	return _commit_cost(COST_MARTA_MEMORY, &"marta_memory")


func select_marta_memory_cost() -> bool:
	return choose_marta_memory_cost()


func choose_sample_second_cost() -> bool:
	return _commit_cost(COST_SAMPLE_SECOND, &"sample_second")


func select_sample_second_cost() -> bool:
	return choose_sample_second_cost()


func choose_cost_from_player_side() -> bool:
	if player == null or cost_selector == null:
		_record_feedback(&"cost_selector_missing")
		return false
	if player.global_position.x <= cost_selector.global_position.x:
		return choose_marta_memory_cost()
	return choose_sample_second_cost()


func _commit_cost(cost_id: StringName, choice_id: StringName) -> bool:
	if is_cost_selected:
		return false
	if not is_response_transferred:
		_record_feedback(&"response_transfer_required")
		return false
	is_cost_selected = true
	selected_cost = cost_id
	_record(FACT_COST_CHOICE, String(choice_id))
	_record(FACT_COST_MANIFESTED, String(cost_id))
	_record(FACT_SMALL_COST, String(cost_id))
	_record(FACT_MECHANIC_COST, true)
	_record(FACT_TRACE, String(choice_id))
	small_cost_manifested.emit(cost_id)
	_report_progress(&"s16_small_cost_selected")
	queue_redraw()
	return true


func confirm_home_echo() -> bool:
	if is_home_echo_confirmed:
		return false
	if not is_cost_selected:
		_record_feedback(&"cost_choice_required")
		return false
	is_home_echo_confirmed = true
	_record(FACT_HOME_ECHO, true)
	_record(FACT_HOME_ECHO_CANONICAL, true)
	_record(FACT_TRACE, "cost_choice_and_home_echo_verified")
	_record(FACT_S06_TRIAL, "small_cost_and_home_echo_confirmed")
	if home_echo_audio != null and _home_echo_sfx != null:
		home_echo_audio.stream = _home_echo_sfx
		home_echo_audio.play()
	if guidance_service:
		guidance_service.close_hypothesis(&"small_cost")
		guidance_service.trigger_beat(&"s16_home_echo_confirmed", true)
	_report_progress(&"s16_home_echo_confirmed")
	home_echo_verified.emit()
	_unlock_exit()
	queue_redraw()
	return true


func process_home_echo() -> bool:
	return confirm_home_echo()


func verify_home_echo() -> bool:
	return confirm_home_echo()


func _record_feedback(value: StringName) -> void:
	last_feedback = value
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s16_" + value)


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


func _has(key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	if state == null:
		return false
	var value: Variant = state.decisions.get(key, null)
	if value == null:
		return false
	if value is String or value is StringName:
		return not String(value).is_empty()
	return bool(value)


func _record(key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(key, value)


func _is_resolved(id: String) -> bool:
	match id:
		"safe_analyzer": return is_response_transferred
		"cost_selector": return is_cost_selected
		"home_echo_receiver": return is_home_echo_confirmed
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	_draw_analyzer_room()
	_draw_relay_context()
	_draw_cost_panel()
	_draw_echo_receiver()
	_draw_exit()


func _draw_analyzer_room() -> void:
	# Techniczna baza: jeden korpus, jedna długa oś pracy i dużo ciszy wokół celu.
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), Color("10171c"))
	draw_rect(Rect2(0.0, 0.0, 640.0, 82.0), Color("1b272d"))
	draw_rect(Rect2(0.0, 82.0, 640.0, 192.0), Color("1e2b31"))
	draw_rect(Rect2(0.0, 274.0, 640.0, 54.0), Color("0b1216"))
	draw_line(Vector2(0.0, 274.0), Vector2(640.0, 274.0), Color("2c3b42"), 1.0)
	# Panel urządzenia pracuje wzdłuż osi ruchu; jego obudowa nie jest przeszkodą.
	draw_rect(Rect2(104.0, 112.0, 196.0, 142.0), Color("263943"))
	draw_rect(Rect2(104.0, 112.0, 196.0, 8.0), Color("31505a"))
	draw_line(Vector2(104.0, 254.0), Vector2(300.0, 254.0), Color("66747a"), 1.0)
	var rivet_x := 114.0
	while rivet_x <= 290.0:
		draw_circle(Vector2(rivet_x, 246.0), 1.2, Color("3c4d55"))
		rivet_x += 26.0
	# Jedno światło odstaje kierunkiem: świeci pod sufit, nie na stanowisko.
	draw_polygon(
		PackedVector2Array([
			Vector2(490.0, 128.0), Vector2(526.0, 128.0),
			Vector2(558.0, 82.0), Vector2(460.0, 82.0),
		]),
		PackedColorArray([Color(1.0, 0.94, 0.82, 0.06)])
	)
	draw_rect(Rect2(488.0, 124.0, 40.0, 5.0), Color("66747a"))
	# Przewód prowadzi do odbiornika echa, ale jego źródło pozostaje poza kadrem.
	draw_line(Vector2(300.0, 188.0), Vector2(454.0, 214.0), Color("46565c"), 7.0)
	draw_line(Vector2(300.0, 188.0), Vector2(454.0, 214.0), Color("66747a"), 1.0)


func _draw_relay_context() -> void:
	# SafeAnalyzerRelay rysuje realną wersję i cichy ślad drugiej wersji.
	var relay_color := VectorStageStyle.ANCHOR_CYAN if is_response_transferred else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(308.0, 166.0, 116.0, 48.0), Color("17232a"))
	draw_line(Vector2(308.0, 214.0), Vector2(424.0, 214.0), Color("3c4d55"), 1.0)
	draw_circle(Vector2(366.0, 190.0), 9.0 + sin(_analyzer_phase) * 1.5, Color(relay_color, 0.22), false, 1.0)
	if is_response_transferred:
		draw_line(Vector2(326.0, 190.0), Vector2(350.0, 190.0), relay_color, 2.0)
		draw_line(Vector2(382.0, 190.0), Vector2(406.0, 190.0), relay_color, 2.0)
	else:
		draw_line(Vector2(340.0, 190.0), Vector2(392.0, 190.0), Color("66747a"), 1.0)


func _draw_cost_panel() -> void:
	var panel_color := VectorStageStyle.LIGHT_PLANE if is_response_transferred else VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.38)
	draw_rect(Rect2(322.0, 226.0, 138.0, 34.0), Color("162229"))
	draw_rect(Rect2(322.0, 226.0, 138.0, 34.0), panel_color, false, 1.0)
	draw_line(Vector2(334.0, 244.0), Vector2(448.0, 244.0), Color("3c4d55"), 1.0)
	if is_cost_selected:
		var cost_color := VectorStageStyle.CORRECTION_OXIDE if selected_cost == COST_MARTA_MEMORY else VectorStageStyle.HUMAN_AMBER
		draw_line(Vector2(334.0, 252.0), Vector2(388.0, 252.0), cost_color, 2.0)
		draw_circle(Vector2(438.0, 244.0), 4.0, cost_color)
	else:
		draw_line(Vector2(334.0, 252.0), Vector2(372.0, 252.0), panel_color, 1.0)


func _draw_echo_receiver() -> void:
	var receiver_color := VectorStageStyle.ANCHOR_CYAN if is_home_echo_confirmed else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(474.0, 196.0, 54.0, 58.0), Color("263943"))
	draw_rect(Rect2(482.0, 204.0, 38.0, 28.0), Color("11191e"))
	draw_line(Vector2(484.0, 238.0), Vector2(518.0, 238.0), receiver_color, 2.0)
	if is_home_echo_confirmed:
		var pulse := 0.5 + 0.15 * sin(_echo_phase * 2.0)
		draw_arc(Vector2(501.0, 218.0), 9.0, 0.0, TAU, 16, Color(receiver_color, pulse), 1.5)
		draw_arc(Vector2(501.0, 218.0), 15.0, 0.0, TAU, 16, Color(receiver_color, pulse * 0.55), 1.0)
	else:
		draw_circle(Vector2(501.0, 218.0), 4.0, Color(receiver_color, 0.55))


func _draw_exit() -> void:
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(572.0, 146.0, 48.0, 12.0), exit_color, false, 1.5)
	draw_line(Vector2(610.0, 158.0), Vector2(610.0, 296.0), exit_color, 2.0)
	draw_line(Vector2(584.0, 296.0), Vector2(620.0, 296.0), exit_color, 2.0)
	# PKG-0198 (ZERO wycinek 2): cień kontaktowy korpusu analizatora w prawo,
	# 0.48, zgodnie z lampą stanowiska i konwencją 01/06/08. [MONO-Q] blok
	# okienny 200–440 czyta się bryłą stołu i lampą-stożkiem, nie kolorem.
	# Drabinę rysuje wyłącznie LadderZone (kanon 9.3); pomiar w bramce 0198.
	draw_colored_polygon(PackedVector2Array([
		Vector2(96.0, 292.0), Vector2(308.0, 290.0),
		Vector2(316.0, 298.0), Vector2(104.0, 300.0),
	]), Color(VectorStageStyle.INK, 0.48))
