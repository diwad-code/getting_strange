class_name Station22
extends Node2D

## Station 22 (Przestrzeń 22: Odchylenie w rejestrze / Oferta UCP) — Kanon 0.3
## Zgodny z docs/narrative/FULL_STORY.md (22), DIALOGUE_SCRIPT.md (Station 22 — oferta UCP),
## docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md oraz docs/PIXEL_PRESENTATION_ARCHITECTURE.md.
##
## Cel: odczytać zarchiwizowaną próbę i zrozumieć dwa zachowania sygnału.
## Przeszkoda: UCP proponuje legalizację statusu w zamian za oddanie czytnika i próbki.
## Działanie: Lena odrzuca propozycję, otwiera archiwum i bada zapis oscyloskopowy.
## Pokaż: dwa tryby sygnału (Zakotwiczenie / Uległość); odchylenie z 20:40 równe przejściu.
## Zmiana: Lena nazywa mechaniki roboczymi terminami (Zakotwiczenie, Uległość) i odrzuca ofertę.

## PRZESZKODA — dlaczego to tu jest: Terminal rejestru UCP jest zabezpieczony blokadą oferty legalizacyjnej; odczyt wykresu oscyloskopowego wymaga odrzucenia umowy licencyjnej na pulpicie.
## PRZESZKODA — czego wymaga od Leny: odrzucenia oferty przejęcia czytnika, otwarcia zapisu oscyloskopowego i zidentyfikowania dwóch faz sygnału.
## PRZESZKODA — koszt porażki: omyłkowe zatwierdzenie umowy blokuje czytnik w stacji dokującej na 15 sekund i wymusza ręczny reset; koszt zapisany w rejestrze decyzji.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)

signal clue_inspected(id: String, prop_type: int)
signal ucp_offer_started()
signal ucp_offer_advanced(step: int)
signal ucp_offer_rejected()
signal oscilloscope_examined()
signal modes_named()
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

var offer_dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "WIERZBICKA // TERMINAL",
		"text": "Status: nieuregulowany. Propozycja: formalna asymilacja w zespole UCP-4.",
		"is_lena": false,
		"is_wierzbicka": true,
	},
	{
		"speaker": "WIERZBICKA // TERMINAL",
		"text": "Warunek: przekazanie obcego czytnika i próbki do depozytu.",
		"is_lena": false,
		"is_wierzbicka": true,
	},
	{
		"speaker": "LENA",
		"text": "Odrzuć propozycję. Otwórz surowy zapis oscyloskopu.",
		"is_lena": true,
		"is_wierzbicka": false,
	},
	{
		"speaker": "WIERZBICKA // TERMINAL",
		"text": "Brak ochrony prawnej poza programem UCP.",
		"is_lena": false,
		"is_wierzbicka": true,
	},
]

var is_offer_active: bool = false
var offer_index: int = -1
var is_offer_completed: bool = false
var is_oscilloscope_checked: bool = false
var are_modes_named: bool = false
var is_level_completed: bool = false

var license_setback_count: int = 0
var reader_locked_in_dock: bool = false
var _pulse_time: float = 0.0

var _terminal_player: AudioStreamPlayer
var _scope_player: AudioStreamPlayer


func _ready() -> void:
	_setup_camera()
	_setup_audio()
	_setup_guidance()
	_connect_props()
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	queue_redraw()


## PKG-0141 (D-150). Jedna sciezka kamery dla calej kampanii: nazwa wezla,
## granice komory i kolejnosc podpiec zyja w `StationCameraRig`, nie w 45 kopiach.
func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)


func _setup_audio() -> void:
	_terminal_player = AudioStreamPlayer.new()
	_terminal_player.name = "TerminalAudioPlayer"
	_terminal_player.stream = ProceduralAudio.create_drafting_lamp_hum_sound()
	_terminal_player.volume_db = -10.0
	_terminal_player.bus = &"Master"
	add_child(_terminal_player)

	_scope_player = AudioStreamPlayer.new()
	_scope_player.name = "ScopeAudioPlayer"
	_scope_player.stream = ProceduralAudio.create_drawer_lock_unlatch_sound()
	_scope_player.volume_db = -8.0
	_scope_player.bus = &"Master"
	add_child(_scope_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return

	var beat_obs := GuidanceBeat.new()
	beat_obs.beat_id = &"s22_two_signal_modes"
	beat_obs.scene_id = &"station_22"
	beat_obs.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_obs.thought_kind = &"observation"
	beat_obs.truth_scope = &"factual"
	beat_obs.text_pl = "Dwa zachowania sygnału w zapisie próby: sztywne zakotwiczenie i podatna uległość."
	beat_obs.text_en = "Two signal behaviors in the test log: rigid anchoring and compliant yield."
	beat_obs.cooldown_s = 8.0
	guidance_service.register_beat(beat_obs)

	var beat_intent := GuidanceBeat.new()
	beat_intent.beat_id = &"s22_reject_ucp"
	beat_intent.scene_id = &"station_22"
	beat_intent.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_intent.thought_kind = &"intention"
	beat_intent.truth_scope = &"procedural"
	beat_intent.text_pl = "Nie oddam czytnika. Sprawdzę martwy obwód w podziemiach."
	beat_intent.text_en = "I will not surrender the reader. I will check the dead circuit below."
	beat_intent.cooldown_s = 8.0
	beat_intent.supersedes = &"s22_two_signal_modes"
	guidance_service.register_beat(beat_intent)


func _connect_props() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var prop := child as MemoryResonancePoint
			prop.resonance_triggered.connect(_on_prop_resonance_triggered.bind(prop))


func _process(delta: float) -> void:
	_pulse_time += delta * 2.0
	queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	prop.is_activated = true
	match id:
		"ucp_offer_console":
			start_offer_dialogue()
		"oscilloscope_display":
			examine_oscilloscope()
		"signal_spectrum_plot":
			examine_oscilloscope()
		"archive_terminal":
			start_offer_dialogue()
		"docking_station":
			examine_oscilloscope()
	clue_inspected.emit(id, prop_type)


func start_offer_dialogue() -> void:
	if is_offer_completed or is_offer_active:
		return
	is_offer_active = true
	offer_index = 0
	if _terminal_player:
		_terminal_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.7)
	if dialogue_box:
		dialogue_box.show_line(
			offer_dialogue_lines[0]["speaker"],
			offer_dialogue_lines[0]["text"]
		)
	ucp_offer_started.emit()


func advance_offer_dialogue() -> void:
	if not is_offer_active:
		return
	offer_index += 1
	if offer_index < offer_dialogue_lines.size():
		if dialogue_box:
			dialogue_box.show_line(
				offer_dialogue_lines[offer_index]["speaker"],
				offer_dialogue_lines[offer_index]["text"]
			)
		ucp_offer_advanced.emit(offer_index)
	else:
		is_offer_active = false
		is_offer_completed = true
		if dialogue_box:
			dialogue_box.hide_box()
		var state := get_node_or_null("/root/GameStateManager")
		if state:
			state.record_decision(&"ucp_offer_rejected", true)
		ucp_offer_rejected.emit()
		_check_readiness()


func examine_oscilloscope() -> void:
	if is_oscilloscope_checked:
		return
	is_oscilloscope_checked = true
	are_modes_named = true
	if _scope_player:
		_scope_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"interact", 0.7)
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"anchor_yield_named", true)
	if guidance_service:
		guidance_service.report_progress(&"oscilloscope_examined")
		guidance_service.trigger_beat(&"s22_two_signal_modes")
		guidance_service.trigger_beat(&"s22_reject_ucp")
	oscilloscope_examined.emit()
	modes_named.emit()
	_check_readiness()


func _check_readiness() -> void:
	queue_redraw()


func apply_license_setback() -> void:
	license_setback_count += 1
	reader_locked_in_dock = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_22_dock_locked", license_setback_count)
	if guidance_service:
		guidance_service.report_failed_attempt(&"dock_locked")
	if player:
		player.reset_to(Vector2(60.0, 296.0))
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if is_offer_active and (event.is_action_pressed(&"interact") or event.is_action_pressed(&"jump")):
		advance_offer_dialogue()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed(&"restart"):
		apply_license_setback()
		get_viewport().set_input_as_handled()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_offer_completed and is_oscilloscope_checked:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	var offer_col := VectorStageStyle.ANCHOR_CYAN if is_offer_completed else VectorStageStyle.SEAM_RED
	draw_rect(Rect2(Vector2(160.0, 240.0), Vector2(30.0, 30.0)), offer_col, false, 1.0)

	var scope_col := VectorStageStyle.ANCHOR_CYAN if is_oscilloscope_checked else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(Vector2(320.0, 230.0), Vector2(40.0, 30.0)), scope_col, false, 1.0)

	var exit_col := VectorStageStyle.ANCHOR_CYAN if (is_offer_completed and is_oscilloscope_checked) else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_col, 2.0)
