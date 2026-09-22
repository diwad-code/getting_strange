class_name Station12
extends Node2D

## Station 12 (Przestrzeń 12: Wiadomość głosowa) — Kanon 0.3
## Zgodny z docs/narrative/FULL_STORY.md (12), DIALOGUE_SCRIPT.md (Station 12 — wiadomość głosowa),
## docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md oraz docs/PIXEL_PRESENTATION_ARCHITECTURE.md.
##
## Cel: ustalić, czego Marta oczekuje od właścicielki tego mieszkania.
## Przeszkoda: Marta mówi jak partnerka po konflikcie i odnosi się do procedury UCP, której Lena nie pamięta.
## Działanie: Lena odsłuchuje całość, sprawdza numer i zapisuje dwa pytania zamiast odpowiadać emocjonalnie.
## Pokaż: głos, oddech i charakterystyczne poprawienie słowa należą do Marty, którą Lena zna z domu.
## Zmiana: `fałszywa Marta` upada; `luka pamięci` rośnie.

## PRZESZKODA — dlaczego to tu jest: Drzwi balkonowe stoją uchylone od wywietrzenia i wpuszczają hałas ulicy prosto na głośnik sekretarki.
## PRZESZKODA — czego wymaga od Leny: domknięcia skrzydła balkonowego i dopiero potem odsłuchania całego nagrania bez przewijania na skróty.
## PRZESZKODA — koszt porażki: odsłuchanie przy otwartym balkonie gubi jedno zdanie nagrania i przewraca kartki na stole.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)
const BALCONY_OPEN_X := 540.0
const BALCONY_CLOSED_X := 624.0

signal clue_inspected(id: String, prop_type: int)
signal balcony_closed()
signal message_started()
signal message_advanced(segment_idx: int)
signal message_completed()
signal questions_written()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var balcony_door: AnimatableBody2D = $Geometry/BalconyDoor
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var dialogue_box: CRTDialogueBox = $CRTDialogueBox

## Kanon 0.3: powierzchnia `MARTA // WIADOMOŚĆ`, bez narratora i bez portretu ducha.
var message_segments: Array[Dictionary] = [
	{
		"speaker": "MARTA // WIADOMOŚĆ",
		"text": "Nie idź znowu sama do Wierzbickiej.",
		"is_lena": false,
	},
	{
		"speaker": "MARTA // WIADOMOŚĆ",
		"text": "Oddzwoń.",
		"is_lena": false,
	},
	{
		"speaker": "MARTA // WIADOMOŚĆ",
		"text": "I nie mów mi rano, że zasnęłaś w laboratorium.",
		"is_lena": false,
	},
	{
		"speaker": "ŚWIADECTWO CIAŁA",
		"text": "Lena cofa nagranie do słowa „znowu” i słucha go drugi raz bez komentarza.",
		"is_lena": true,
		"is_stage_direction": true,
	},
]

var is_balcony_closed: bool = false
var message_active: bool = false
var message_index: int = -1
var is_message_completed: bool = false
var rewind_count: int = 0
var number_checked: bool = false
var are_questions_written: bool = false
var is_level_completed: bool = false

var muffled_playback_count: int = 0
var lost_message_line: bool = false

var _balcony_progress: float = 0.0
var _pulse_time: float = 0.0

var _machine_player: AudioStreamPlayer
var _handset_player: AudioStreamPlayer
var _street_player: AudioStreamPlayer
var _paper_player: AudioStreamPlayer


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
	_street_player = AudioStreamPlayer.new()
	_street_player.name = "StreetAudioPlayer"
	_street_player.stream = ProceduralAudio.create_rain_asphalt_sound()
	_street_player.volume_db = -14.0
	_street_player.bus = &"Master"
	add_child(_street_player)
	_street_player.play()

	_machine_player = AudioStreamPlayer.new()
	_machine_player.name = "AnsweringMachinePlayer"
	_machine_player.stream = ProceduralAudio.create_tape_motor_hum_sound()
	_machine_player.volume_db = -8.0
	_machine_player.bus = &"Master"
	add_child(_machine_player)

	_handset_player = AudioStreamPlayer.new()
	_handset_player.name = "HandsetAudioPlayer"
	_handset_player.stream = ProceduralAudio.create_handset_pickup_sound()
	_handset_player.volume_db = -8.0
	_handset_player.bus = &"Master"
	add_child(_handset_player)

	_paper_player = AudioStreamPlayer.new()
	_paper_player.name = "NotePadAudioPlayer"
	_paper_player.stream = ProceduralAudio.create_paper_rustle_sound()
	_paper_player.volume_db = -9.0
	_paper_player.bus = &"Master"
	add_child(_paper_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return

	var beat_obs := GuidanceBeat.new()
	beat_obs.beat_id = &"s12_her_voice"
	beat_obs.scene_id = &"station_12"
	beat_obs.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_obs.thought_kind = &"observation"
	beat_obs.truth_scope = &"factual"
	beat_obs.text_pl = "Jej oddech. Jej poprawka w połowie słowa."
	beat_obs.text_en = "Her breath. Her mid-word correction."
	beat_obs.cooldown_s = 8.0
	guidance_service.register_beat(beat_obs)

	var beat_hyp := GuidanceBeat.new()
	beat_hyp.beat_id = &"s12_missing_months"
	beat_hyp.scene_id = &"station_12"
	beat_hyp.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_hyp.thought_kind = &"interpretation"
	beat_hyp.truth_scope = &"fallible"
	beat_hyp.text_pl = "Brakuje mi kawałka miesięcy, nie rozmowy."
	beat_hyp.text_en = "It is months I am missing, not one talk."
	beat_hyp.cooldown_s = 8.0
	beat_hyp.hypothesis_id = &"hyp_memory_gap"
	beat_hyp.predicted_check = "compare_documents"
	beat_hyp.supersedes = &"s12_her_voice"
	guidance_service.register_beat(beat_hyp)

	var beat_intent := GuidanceBeat.new()
	beat_intent.beat_id = &"s12_two_questions"
	beat_intent.scene_id = &"station_12"
	beat_intent.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_intent.thought_kind = &"intention"
	beat_intent.truth_scope = &"procedural"
	beat_intent.text_pl = "Zapiszę dwa pytania. Nie oddzwonię na gorąco."
	beat_intent.text_en = "Two questions on paper. No hot call back."
	beat_intent.cooldown_s = 8.0
	beat_intent.supersedes = &"s12_missing_months"
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
	if is_balcony_closed and _balcony_progress < 1.0:
		_balcony_progress = minf(1.0, _balcony_progress + delta * 1.6)
		if balcony_door:
			balcony_door.position.x = lerpf(BALCONY_OPEN_X, BALCONY_CLOSED_X, _balcony_progress)
		if _street_player:
			_street_player.volume_db = lerpf(-14.0, -26.0, _balcony_progress)
	queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	prop.is_activated = true
	match id:
		"balcony_handle":
			close_balcony()
		"answering_machine":
			if not is_message_completed:
				if not message_active:
					play_message()
				else:
					advance_message()
		"phone_handset":
			check_caller_number()
		"caller_id_list":
			check_caller_number()
		"note_pad":
			write_two_questions()
	clue_inspected.emit(id, prop_type)


func close_balcony() -> void:
	if is_balcony_closed:
		return
	is_balcony_closed = true
	if balcony_door:
		ExitClearance._disable_shapes(balcony_door)
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"interact", 0.7)
	if guidance_service:
		guidance_service.report_progress(&"balcony_closed")
	balcony_closed.emit()



func play_message() -> void:
	if is_message_completed or message_active:
		return
	if not is_balcony_closed:
		## Odsłuchanie przy otwartym balkonie gubi zdanie i nic nie rozstrzyga.
		apply_muffled_playback()
		return
	message_active = true
	message_index = 0
	if _machine_player:
		_machine_player.play()
	if guidance_service:
		guidance_service.set_dialogue_active(true)
	message_started.emit()
	queue_redraw()


func advance_message() -> int:
	if not message_active:
		play_message()
		return message_index

	if message_index == 0 and rewind_count == 0:
		## Lena zatrzymuje nagranie na słowie `znowu` i cofa je raz.
		rewind_count += 1
		if player and player.has_method("play_visual_cue"):
			player.play_visual_cue(&"unease_reaction", 0.9)
		message_advanced.emit(message_index)
		queue_redraw()
		return message_index

	message_index += 1
	if message_index >= message_segments.size():
		message_active = false
		is_message_completed = true
		if guidance_service:
			guidance_service.set_dialogue_active(false)
			guidance_service.report_progress(&"message_heard")
			## Głos jest niewątpliwie Marty, więc podszywanie się przestaje tłumaczyć zdjęcie.
			guidance_service.close_hypothesis(&"hyp_identity_theft")
			guidance_service.trigger_beat(&"s12_her_voice")
		message_completed.emit()
		queue_redraw()
		return -1

	var segment: Dictionary = message_segments[message_index]
	if bool(segment.get("is_stage_direction", false)) and player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.8)
	message_advanced.emit(message_index)
	queue_redraw()
	return message_index


func check_caller_number() -> void:
	if number_checked:
		return
	number_checked = true
	if _handset_player:
		_handset_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.7)
	if guidance_service:
		guidance_service.report_progress(&"number_checked")
		guidance_service.trigger_beat(&"s12_missing_months")


func write_two_questions() -> void:
	if are_questions_written or not is_message_completed:
		return
	are_questions_written = true
	if _paper_player:
		_paper_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"seam_gesture", 0.7)
	if guidance_service:
		guidance_service.report_progress(&"questions_written")
		guidance_service.trigger_beat(&"s12_two_questions")
	questions_written.emit()


## Porażka to zgubione zdanie i rozsypane kartki, nigdy śmierć ani koniec sceny.
func apply_muffled_playback() -> void:
	muffled_playback_count += 1
	lost_message_line = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_12_playback_muffled", muffled_playback_count)
	if guidance_service:
		guidance_service.report_failed_attempt(&"playback_muffled")
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"interact") and message_active:
		advance_message()
		get_viewport().set_input_as_handled()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and are_questions_written:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	var machine_col := VectorStageStyle.HUMAN_AMBER
	if is_message_completed:
		machine_col = VectorStageStyle.ANCHOR_CYAN
	elif message_active:
		machine_col = VectorStageStyle.light(VectorStageStyle.HUMAN_AMBER, 0.2)
	if lost_message_line:
		machine_col = VectorStageStyle.shade(machine_col, 0.45)
	draw_rect(Rect2(Vector2(228.0, 240.0), Vector2(38.0, 18.0)), machine_col, false, 1.0)

	var note_col := VectorStageStyle.ANCHOR_CYAN if are_questions_written else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.35)
	draw_rect(Rect2(Vector2(340.0, 250.0), Vector2(26.0, 12.0)), note_col, are_questions_written)

	var balcony_col := VectorStageStyle.ANCHOR_CYAN if is_balcony_closed else VectorStageStyle.CORRECTION_OXIDE
	draw_line(Vector2(540.0, 168.0), Vector2(540.0, 296.0), balcony_col, 2.0)
