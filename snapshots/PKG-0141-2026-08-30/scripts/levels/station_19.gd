class_name Station19
extends Node2D

## Station 19 (Przestrzeń 19: Głos) — Kanon 0.3
## Zgodny z docs/narrative/FULL_STORY.md (19), DIALOGUE_SCRIPT.md (Station 19 — telefon),
## docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md oraz docs/PIXEL_PRESENTATION_ARCHITECTURE.md.
##
## Cel: zweryfikować rozmówcę bez ujawniania całej historii.
## Przeszkoda: Jakub dzwoni po wiadomości od Marty i zna rodzinny konkret spoza bazy.
## Działanie: Lena zadaje pytanie o schowek u babci, potem o ostatnią rozmowę przed katastrofą.
## Pokaż: pierwszą odpowiedź zna (słoiki i hełm z garnka); drugą pamięta inaczej. W tle realny warsztat L4.
## Zmiana: oszustwo i stare nagranie stają się niewystarczające; Lena decyduje się na spotkanie w cztery oczy.

## PRZESZKODA — dlaczego to tu jest: Publiczna budka/terminal telefoniczny przy hałaśliwej magistrali wymaga osłonięcia mikrofonu przed wiatrem i precyzyjnego doboru pytań kontrolnych.
## PRZESZKODA — czego wymaga od Leny: odebrania połączenia, zadania dwóch pytań rozróżniających (domowe vs rozbieżne) i rozłączenia się bez podawania własnej teorii.
## PRZESZKODA — koszt porażki: wahanie lub odsłonięcie prawdy o pamięci pogrzebu sprawia, że Jakub żąda natychmiastowego przyjazdu karetki; koszt zapisany w rejestrze decyzji.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)

signal clue_inspected(id: String, prop_type: int)
signal phone_answered()
signal grandma_stash_asked()
signal tunnel_asked()
signal phone_completed()
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

var phone_dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "JAKUB // TELEFON",
		"text": "Lena? Marta mówi, że zniknęłaś z biura.",
		"is_lena": false,
		"is_jakub": true,
	},
	{
		"speaker": "LENA",
		"text": "Co było pod schodami u babci?",
		"is_lena": true,
		"is_jakub": false,
	},
	{
		"speaker": "JAKUB // TELEFON",
		"text": "Słoiki. I twój hełm z garnka. Nadal sprawdzasz ludzi jak zamki?",
		"is_lena": false,
		"is_jakub": true,
	},
	{
		"speaker": "LENA",
		"text": "Co powiedziałeś mi w tunelu?",
		"is_lena": true,
		"is_jakub": false,
	},
	{
		"speaker": "JAKUB // TELEFON",
		"text": "W którym tunelu?",
		"is_lena": false,
		"is_jakub": true,
	},
]

var is_phone_answered: bool = false
var is_dialogue_active: bool = false
var dialogue_index: int = -1
var is_phone_completed: bool = false
var is_level_completed: bool = false

var phone_setback_count: int = 0
var line_interrupted: bool = false
var _pulse_time: float = 0.0

var _ring_player: AudioStreamPlayer
var _workshop_bg_player: AudioStreamPlayer


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
	_ring_player = AudioStreamPlayer.new()
	_ring_player.name = "RingAudioPlayer"
	_ring_player.stream = ProceduralAudio.create_handset_pickup_sound()
	_ring_player.volume_db = -8.0
	_ring_player.bus = &"Master"
	add_child(_ring_player)

	_workshop_bg_player = AudioStreamPlayer.new()
	_workshop_bg_player.name = "WorkshopAudioPlayer"
	_workshop_bg_player.stream = ProceduralAudio.create_drafting_lamp_hum_sound()
	_workshop_bg_player.volume_db = -16.0
	_workshop_bg_player.bus = &"Master"
	add_child(_workshop_bg_player)
	_workshop_bg_player.play()


func _setup_guidance() -> void:
	if guidance_service == null:
		return

	var beat_obs := GuidanceBeat.new()
	beat_obs.beat_id = &"s19_voice_heard"
	beat_obs.scene_id = &"station_19"
	beat_obs.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_obs.thought_kind = &"observation"
	beat_obs.truth_scope = &"factual"
	beat_obs.text_pl = "Zna schowek u babci. Nie wie nic o tunelu."
	beat_obs.text_en = "He knows grandma's pantry. He knows nothing about the tunnel."
	beat_obs.cooldown_s = 8.0
	guidance_service.register_beat(beat_obs)

	var beat_hyp := GuidanceBeat.new()
	beat_hyp.beat_id = &"s19_impersonation_fear"
	beat_hyp.scene_id = &"station_19"
	beat_hyp.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_hyp.thought_kind = &"interpretation"
	beat_hyp.truth_scope = &"fallible"
	beat_hyp.text_pl = "Ktoś mógł zebrać rodzinne wspomnienia z moich notatek."
	beat_hyp.text_en = "Someone could have gathered family memories from my notes."
	beat_hyp.cooldown_s = 8.0
	beat_hyp.hypothesis_id = &"hyp_impersonation_call"
	beat_hyp.predicted_check = "meet_jakub_in_person"
	beat_hyp.supersedes = &"s19_voice_heard"
	guidance_service.register_beat(beat_hyp)

	var beat_intent := GuidanceBeat.new()
	beat_intent.beat_id = &"s19_meet_in_public"
	beat_intent.scene_id = &"station_19"
	beat_intent.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_intent.thought_kind = &"intention"
	beat_intent.truth_scope = &"procedural"
	beat_intent.text_pl = "Spotkamy się na placu warsztatowym z Martą obok."
	beat_intent.text_en = "We will meet at the workshop square with Marta present."
	beat_intent.cooldown_s = 8.0
	beat_intent.supersedes = &"s19_impersonation_fear"
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
		"payphone_handset":
			answer_phone()
		"phone_directory":
			answer_phone()
		"workshop_acoustic":
			answer_phone()
		"notepad":
			answer_phone()
		"wind_shield":
			answer_phone()
	clue_inspected.emit(id, prop_type)


func insert_coin() -> void:
	answer_phone()


func dial_number() -> void:
	answer_phone()


func answer_phone() -> void:
	if is_phone_completed:
		return
	if not is_phone_answered:
		is_phone_answered = true
		is_dialogue_active = true
		dialogue_index = 0
		if _ring_player:
			_ring_player.play()
		if player and player.has_method("play_visual_cue"):
			player.play_visual_cue(&"interact", 0.6)
		if dialogue_box:
			dialogue_box.show_line(
				phone_dialogue_lines[0]["speaker"],
				phone_dialogue_lines[0]["text"]
			)
		phone_answered.emit()


func advance_phone_dialogue() -> void:
	if not is_dialogue_active:
		return
	dialogue_index += 1
	if dialogue_index < phone_dialogue_lines.size():
		if dialogue_box:
			dialogue_box.show_line(
				phone_dialogue_lines[dialogue_index]["speaker"],
				phone_dialogue_lines[dialogue_index]["text"]
			)
		if dialogue_index == 2:
			grandma_stash_asked.emit()
		elif dialogue_index == 4:
			tunnel_asked.emit()
	else:
		is_dialogue_active = false
		is_phone_completed = true
		if dialogue_box:
			dialogue_box.hide_box()
		var state := get_node_or_null("/root/GameStateManager")
		if state:
			state.record_decision(&"jakub_voice_heard", true)
		if guidance_service:
			guidance_service.report_progress(&"phone_completed")
			guidance_service.trigger_beat(&"s19_voice_heard")
		phone_completed.emit()


func apply_phone_setback() -> void:
	phone_setback_count += 1
	line_interrupted = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_19_call_interrupted", phone_setback_count)
	if guidance_service:
		guidance_service.report_failed_attempt(&"call_interrupted")
	if player:
		player.reset_to(Vector2(60.0, 296.0))
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if is_dialogue_active and (event.is_action_pressed(&"interact") or event.is_action_pressed(&"jump")):
		advance_phone_dialogue()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed(&"restart"):
		apply_phone_setback()
		get_viewport().set_input_as_handled()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_phone_completed:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	var booth_col := VectorStageStyle.ANCHOR_CYAN if is_phone_completed else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(Vector2(260.0, 210.0), Vector2(40.0, 70.0)), booth_col, false, 1.0)

	var phone_col := VectorStageStyle.ANCHOR_CYAN if is_phone_answered else VectorStageStyle.SEAM_RED
	draw_circle(Vector2(280.0, 240.0), 5.0, phone_col)

	var exit_col := VectorStageStyle.ANCHOR_CYAN if is_phone_completed else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_col, 2.0)
