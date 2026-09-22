class_name Station17
extends Node2D

## Station 17 (Przestrzeń 17: Nie powtarzać próbki) — Kanon 0.3
## Zgodny z docs/narrative/FULL_STORY.md (17), DIALOGUE_SCRIPT.md (Station 17 — Wierzbicka przez interkom),
## docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md oraz docs/PIXEL_PRESENTATION_ARCHITECTURE.md.
##
## Cel: skopiować raport przed blokadą konta.
## Przeszkoda: dokument ma status INCYDENT CIĄGŁOŚCI POMIARU, a głos dr Wierzbickiej nakazuje odłożyć czytnik.
## Działanie: Lena kopiuje nagłówek i wybiera drogę serwisową, zanim ochrona zamknie sektor.
## Pokaż: dwie próby rozpoczęły się o tej samej sekundzie; lokalny raport nie zawiera numeru czytnika Leny.
## Zmiana: UCP wie o zdarzeniu i próbuje zabezpieczyć jedyny obcy nośnik.

## PRZESZKODA — dlaczego to tu jest: Drzwi główne zostają zablokowane procedurą izolacji UCP, a wyjście serwisowe wymaga ręcznego zwolnienia rygla wentylacji.
## PRZESZKODA — czego wymaga od Leny: skopiowania nagłówka raportu, odciągnięcia dźwigni wentylacji i opuszczenia sektora przed ryglem bezpieczeństwa.
## PRZESZKODA — koszt porażki: zwłoka przy terminalu uruchamia syrenę ostrzegawczą i zamazuje sygnaturę czasową drugiego odczytu; koszt zapisany w rejestrze decyzji.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)

signal clue_inspected(id: String, prop_type: int)
signal report_read()
signal intercom_started()
signal intercom_advanced(step: int)
signal intercom_completed()
signal vent_pulled()
signal header_copied()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var dialogue_box: CRTDialogueBox = $CRTDialogueBox

var intercom_dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "WIERZBICKA // INTERKOM",
		"text": "Proszę odłożyć czytnik i zaczekać przy stanowisku.",
		"is_lena": false,
		"is_wierzbicka": true,
	},
	{
		"speaker": "LENA",
		"text": "Kto mówi?",
		"is_lena": true,
		"is_wierzbicka": false,
	},
	{
		"speaker": "WIERZBICKA // INTERKOM",
		"text": "Dr Helena Wierzbicka. Urządzenie nie jest zgodne z rejestrem.",
		"is_lena": false,
		"is_wierzbicka": true,
	},
	{
		"speaker": "LENA",
		"text": "Ja też nie.",
		"is_lena": true,
		"is_wierzbicka": false,
	},
	{
		"speaker": "WIERZBICKA // INTERKOM",
		"text": "Dlatego proszę zaczekać.",
		"is_lena": false,
		"is_wierzbicka": true,
	},
]

var is_report_read: bool = false
var is_intercom_active: bool = false
var intercom_index: int = -1
var is_intercom_completed: bool = false
var is_vent_pulled: bool = false
var is_header_copied: bool = false
var is_level_completed: bool = false

var intercom_setback_count: int = 0
var timestamp_smudged: bool = false
var _pulse_time: float = 0.0

var _alarm_player: AudioStreamPlayer
var _lever_player: AudioStreamPlayer


func _ready() -> void:
	_setup_camera()
	_setup_audio()
	_setup_guidance()
	_connect_props()
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	queue_redraw()


func _setup_camera() -> void:
	if not is_instance_valid(camera):
		camera = CinematicCamera.new()
		camera.name = "Camera"
		add_child(camera)
	camera.target = player
	camera.setup_chambers([Rect2(Vector2.ZERO, VIEW_SIZE)])


func _setup_audio() -> void:
	_alarm_player = AudioStreamPlayer.new()
	_alarm_player.name = "AlarmAudioPlayer"
	_alarm_player.stream = ProceduralAudio.create_drafting_lamp_hum_sound()
	_alarm_player.volume_db = -10.0
	_alarm_player.bus = &"Master"
	add_child(_alarm_player)

	_lever_player = AudioStreamPlayer.new()
	_lever_player.name = "LeverAudioPlayer"
	_lever_player.stream = ProceduralAudio.create_drawer_lock_unlatch_sound()
	_lever_player.volume_db = -6.0
	_lever_player.bus = &"Master"
	add_child(_lever_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return

	var beat_obs := GuidanceBeat.new()
	beat_obs.beat_id = &"s17_parallel_test"
	beat_obs.scene_id = &"station_17"
	beat_obs.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_obs.thought_kind = &"observation"
	beat_obs.truth_scope = &"factual"
	beat_obs.text_pl = "Dwa pomiary w tej samej sekundzie. Mój czytnik jest poza ich spisem."
	beat_obs.text_en = "Two measurements in the exact same second. My reader is absent from their index."
	beat_obs.cooldown_s = 8.0
	guidance_service.register_beat(beat_obs)

	var beat_intent := GuidanceBeat.new()
	beat_intent.beat_id = &"s17_ucp_containment"
	beat_intent.scene_id = &"station_17"
	beat_intent.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_intent.thought_kind = &"intention"
	beat_intent.truth_scope = &"procedural"
	beat_intent.text_pl = "Skopiuję nagłówek i wyjdę szybem wentylacji zanim zaryglują sektor."
	beat_intent.text_en = "I will copy the header and leave through the ventilation shaft before lockdown."
	beat_intent.cooldown_s = 8.0
	beat_intent.supersedes = &"s17_parallel_test"
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
		"incident_console":
			read_incident_report()
		"data_storage_drive":
			copy_report_header()
		"intercom_speaker":
			listen_intercom()
		"ventilation_lever":
			pull_vent_lever()
		"service_exit_hatch":
			pull_vent_lever()
	clue_inspected.emit(id, prop_type)


func read_incident_report() -> void:
	if is_report_read:
		return
	is_report_read = true
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.7)
	listen_intercom()
	report_read.emit()


func copy_report_header() -> void:
	if is_header_copied:
		return
	is_header_copied = true
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"interact", 0.6)
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"parallel_test_trace_found", true)
	if guidance_service:
		guidance_service.report_progress(&"header_copied")
		guidance_service.trigger_beat(&"s17_parallel_test")
	header_copied.emit()


func listen_intercom() -> void:
	if is_intercom_completed or is_intercom_active:
		return
	is_intercom_active = true
	intercom_index = 0
	if _alarm_player:
		_alarm_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"unease_reaction", 0.8)
	if dialogue_box:
		dialogue_box.show_line(
			intercom_dialogue_lines[0]["speaker"],
			intercom_dialogue_lines[0]["text"]
		)
	intercom_started.emit()


func advance_intercom() -> void:
	if not is_intercom_active:
		return
	intercom_index += 1
	if intercom_index < intercom_dialogue_lines.size():
		if dialogue_box:
			dialogue_box.show_line(
				intercom_dialogue_lines[intercom_index]["speaker"],
				intercom_dialogue_lines[intercom_index]["text"]
			)
		intercom_advanced.emit(intercom_index)
	else:
		is_intercom_active = false
		is_intercom_completed = true
		if dialogue_box:
			dialogue_box.hide_box()
		if guidance_service:
			guidance_service.trigger_beat(&"s17_ucp_containment")
		intercom_completed.emit()


func pull_vent_lever() -> void:
	if is_vent_pulled:
		return
	is_vent_pulled = true
	if _lever_player:
		_lever_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"seam_gesture", 0.8)
	vent_pulled.emit()


func apply_intercom_setback() -> void:
	intercom_setback_count += 1
	timestamp_smudged = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_17_alarm_delayed", intercom_setback_count)
	if guidance_service:
		guidance_service.report_failed_attempt(&"intercom_delayed")
	if player:
		player.reset_to(Vector2(60.0, 296.0))
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if is_intercom_active and (event.is_action_pressed(&"interact") or event.is_action_pressed(&"jump")):
		advance_intercom()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed(&"restart"):
		apply_intercom_setback()
		get_viewport().set_input_as_handled()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_header_copied and is_vent_pulled:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	var console_col := VectorStageStyle.ANCHOR_CYAN if is_report_read else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(Vector2(140.0, 240.0), Vector2(34.0, 30.0)), console_col, false, 1.0)

	var speaker_col := VectorStageStyle.ANCHOR_CYAN if is_intercom_completed else VectorStageStyle.SEAM_RED
	draw_circle(Vector2(280.0, 200.0), 6.0, speaker_col)

	var drive_col := VectorStageStyle.ANCHOR_CYAN if is_header_copied else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.6)
	draw_rect(Rect2(Vector2(380.0, 250.0), Vector2(24.0, 20.0)), drive_col, false, 1.0)

	var vent_col := VectorStageStyle.ANCHOR_CYAN if is_vent_pulled else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(490.0, 230.0), Vector2(490.0, 290.0), vent_col, 2.0)

	var exit_col := VectorStageStyle.ANCHOR_CYAN if (is_header_copied and is_vent_pulled) else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_col, 2.0)
