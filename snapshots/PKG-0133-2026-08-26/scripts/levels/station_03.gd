class_name Station03
extends Node2D

## Station 03 (Przestrzeń 03: Wiadomość Marty) — Kanon 0.3
## Zgodny ze specyfikacją docs/narrative/FULL_STORY.md (03), DIALOGUE_SCRIPT.md oraz VISUAL_DESIGN.md
##
## Cel: Sprawdzić dojazd i odpowiedzieć Marcie.
## Przeszkoda: Opóźniona tablica przyjazdów i słaby zasięg wydłużają zwykły powrót.
## Działanie: Gracz odczytuje tablicę odjazdów i otwiera wiadomość na telefonie.
## Pokaż: Marta pisze: "Miałaś wrócić. Napisz tylko, czy jedziesz." Lena kasuje dłuższą odpowiedź i wysyła "Jadę."
## Zmiana: Bliskość i zmęczenie Marty; brak jawnej romantycznej relacji w Równi.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)

signal clue_inspected(id: String, prop_type: int)
signal message_sent()
signal door_unlocked()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var security_door: AnimatableBody2D = $SecurityDoor
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var dialogue_box: CRTDialogueBox = $CRTDialogueBox

var is_transit_board_inspected: bool = false
var is_message_opened: bool = false
var is_response_sent: bool = false
var is_shelter_bench_checked: bool = false

var is_door_unlocked: bool = false
var is_level_completed: bool = false

var _door_open_progress: float = 0.0
var _pulse_time: float = 0.0

var _ambient_hum_player: AudioStreamPlayer
var _door_audio_player: AudioStreamPlayer
var _phone_blip_player: AudioStreamPlayer


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
	_ambient_hum_player = AudioStreamPlayer.new()
	_ambient_hum_player.name = "AmbientHumPlayer"
	_ambient_hum_player.stream = ProceduralAudio.create_fluorescent_hum_sound()
	_ambient_hum_player.volume_db = -12.0
	_ambient_hum_player.bus = &"Master"
	add_child(_ambient_hum_player)
	_ambient_hum_player.play()
	
	_door_audio_player = AudioStreamPlayer.new()
	_door_audio_player.name = "DoorAudioPlayer"
	_door_audio_player.stream = ProceduralAudio.create_airlock_seal_sound()
	_door_audio_player.volume_db = -4.0
	_door_audio_player.bus = &"Master"
	add_child(_door_audio_player)
	
	_phone_blip_player = AudioStreamPlayer.new()
	_phone_blip_player.name = "PhoneBlipPlayer"
	_phone_blip_player.stream = ProceduralAudio.create_dialogue_blip_sound(true)
	_phone_blip_player.volume_db = -4.0
	_phone_blip_player.bus = &"Master"
	add_child(_phone_blip_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	
	var beat_msg := GuidanceBeat.new()
	beat_msg.beat_id = &"s03_marta_message"
	beat_msg.scene_id = &"station_03"
	beat_msg.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_msg.thought_kind = &"intention"
	beat_msg.text_pl = "Wracam do domu. Marta czeka."
	beat_msg.text_en = "Heading home. Marta is waiting."
	beat_msg.cooldown_s = 8.0
	guidance_service.register_beat(beat_msg)
	
	var beat_board := GuidanceBeat.new()
	beat_board.beat_id = &"s03_board_checked"
	beat_board.scene_id = &"station_03"
	beat_board.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_board.thought_kind = &"observation"
	beat_board.text_pl = "Opóźnienie na tablicy. Odpiszę krótko, że jadę."
	beat_board.text_en = "Delay on the board. I'll text briefly that I'm on my way."
	beat_board.cooldown_s = 8.0
	beat_board.supersedes = &"s03_marta_message"
	guidance_service.register_beat(beat_board)


func _connect_props() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var prop := child as MemoryResonancePoint
			prop.resonance_triggered.connect(_on_prop_resonance_triggered.bind(prop))


func _process(delta: float) -> void:
	_pulse_time += delta * 2.5
	if is_door_unlocked and _door_open_progress < 1.0:
		_door_open_progress = minf(1.0, _door_open_progress + delta * 1.5)
	queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	prop.is_activated = true
	match id:
		"transit_board", "duty_roster":
			is_transit_board_inspected = true
			if _phone_blip_player:
				_phone_blip_player.play()
			if player and player.has_method("play_visual_cue"):
				player.play_visual_cue(&"examine", 0.7)
			if guidance_service:
				guidance_service.trigger_beat(&"s03_board_checked")
			clue_inspected.emit(id, prop_type)
			_check_completion_condition()
			
		"phone_message", "desk_phone", "twin_cups":
			is_message_opened = true
			is_response_sent = true
			if _phone_blip_player:
				_phone_blip_player.pitch_scale = 1.2
				_phone_blip_player.play()
			if player and player.has_method("play_visual_cue"):
				player.play_visual_cue(&"interact", 0.8)
			if guidance_service:
				guidance_service.report_progress(&"message_sent")
				guidance_service.trigger_beat(&"s03_marta_message")
			message_sent.emit()
			clue_inspected.emit(id, prop_type)
			_check_completion_condition()
			
		"shelter_bench", "door_card_reader":
			is_shelter_bench_checked = true
			if player and player.has_method("play_visual_cue"):
				player.play_visual_cue(&"examine", 0.5)
			clue_inspected.emit(id, prop_type)
			_check_completion_condition()


func _check_completion_condition() -> void:
	if (is_message_opened or is_transit_board_inspected) and not is_door_unlocked:
		unlock_security_door()


func unlock_security_door() -> void:
	if is_door_unlocked:
		return
	is_door_unlocked = true
	door_unlocked.emit()
	
	if _door_audio_player:
		_door_audio_player.play()
	if camera:
		camera.add_trauma(0.2)
	
	var tween := create_tween()
	if security_door:
		tween.tween_property(security_door, "position:y", security_door.position.y - 70.0, 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_door_open_progress = 1.0


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_door_unlocked:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	
	var status_col := VectorStageStyle.ANCHOR_CYAN if is_door_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(566.0, 174.0), Vector2(566.0, 252.0), status_col, 2.0)
