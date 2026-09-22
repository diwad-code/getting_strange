class_name Station04
extends Node2D

## Station 04 (Przestrzeń 04: Przejazd) — Kanon 0.3
## Zgodny ze specyfikacją docs/narrative/FULL_STORY.md (04) oraz VISUAL_DESIGN.md
##
## Cel: Dojechać do dzielnicy.
## Przeszkoda: Czytnik ponownie pokazuje trzysekundową lukę, jakby zachował bufor.
## Działanie: Lena restartuje urządzenie, zabezpiecza kartę i odkłada pracę w wagonie.
## Pokaż: Mijany pomnik Linii 4 odbija się w szybie; Lena odwraca czytnik ekranem do dołu.
## Zmiana: Konflikt osobisty — kolejny pomiar zajął miejsce obiecanej rozmowy.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)

signal clue_inspected(id: String, prop_type: int)
signal reader_restarted()
signal reader_stowed()
signal turnstile_unlocked()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var turnstile_barrier: Node2D = $TurnstileBarrier
@onready var airlock_zone: Area2D = $AirlockZone
@onready var return_zone: Area2D = $ReturnZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var dialogue_box: CRTDialogueBox = $CRTDialogueBox

var is_reader_restarted: bool = false
var is_card_secured: bool = false
var is_work_put_away: bool = false
var is_window_inspected: bool = false

var is_turnstile_unlocked: bool = false
var is_level_completed: bool = false

var _turnstile_tween: Tween
var _pulse_time: float = 0.0

var _ambient_hum_player: AudioStreamPlayer
var _device_blip_player: AudioStreamPlayer
var _door_player: AudioStreamPlayer


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
	_ambient_hum_player = AudioStreamPlayer.new()
	_ambient_hum_player.name = "AmbientHumPlayer"
	_ambient_hum_player.stream = ProceduralAudio.create_tram_traction_sound()
	_ambient_hum_player.volume_db = -14.0
	_ambient_hum_player.bus = &"Master"
	add_child(_ambient_hum_player)
	_ambient_hum_player.play()
	
	_device_blip_player = AudioStreamPlayer.new()
	_device_blip_player.name = "DeviceBlipPlayer"
	_device_blip_player.stream = ProceduralAudio.create_dialogue_blip_sound(true)
	_device_blip_player.volume_db = -4.0
	_device_blip_player.bus = &"Master"
	add_child(_device_blip_player)
	
	_door_player = AudioStreamPlayer.new()
	_door_player.name = "DoorAudioPlayer"
	_door_player.stream = ProceduralAudio.create_airlock_seal_sound()
	_door_player.volume_db = -4.0
	_door_player.bus = &"Master"
	add_child(_door_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	
	var beat_journey := GuidanceBeat.new()
	beat_journey.beat_id = &"s04_train_journey"
	beat_journey.scene_id = &"station_04"
	beat_journey.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_journey.thought_kind = &"observation"
	beat_journey.text_pl = "Wagon kołysze na zwrotnicach. Jeszcze dwa przystanki."
	beat_journey.text_en = "Carriage sways across switches. Two stops left."
	beat_journey.cooldown_s = 8.0
	guidance_service.register_beat(beat_journey)
	
	var beat_reader := GuidanceBeat.new()
	beat_reader.beat_id = &"s04_stow_reader"
	beat_reader.scene_id = &"station_04"
	beat_reader.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_reader.thought_kind = &"intention"
	beat_reader.text_pl = "Dość pomiarów na dzisiaj. Chowam czytnik."
	beat_reader.text_en = "Enough readings for today. Stowing the reader."
	beat_reader.cooldown_s = 8.0
	beat_reader.supersedes = &"s04_train_journey"
	guidance_service.register_beat(beat_reader)


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
		"reader_buffer", "guard_station", "security_monitor":
			is_reader_restarted = true
			is_card_secured = true
			if _device_blip_player:
				_device_blip_player.play()
			if player and player.has_method("play_visual_cue"):
				player.play_visual_cue(&"examine", 0.8)
			if guidance_service:
				guidance_service.report_progress(&"reader_reset")
				guidance_service.trigger_beat(&"s04_stow_reader")
			reader_restarted.emit()
			clue_inspected.emit(id, prop_type)
			_check_unlock_condition()
			
		"window_reflection", "ucp_notice":
			is_window_inspected = true
			if player and player.has_method("play_visual_cue"):
				player.play_visual_cue(&"unease_reaction", 0.8)
			clue_inspected.emit(id, prop_type)
			_check_unlock_condition()
			
		"bag_stash":
			is_work_put_away = true
			if _device_blip_player:
				_device_blip_player.pitch_scale = 0.9
				_device_blip_player.play()
			if player and player.has_method("play_visual_cue"):
				player.play_visual_cue(&"seam_gesture", 0.7)
			reader_stowed.emit()
			clue_inspected.emit(id, prop_type)
			_check_unlock_condition()


func _check_unlock_condition() -> void:
	if (is_reader_restarted or is_window_inspected or is_work_put_away) and not is_turnstile_unlocked:
		unlock_turnstile()


func unlock_turnstile() -> void:
	if is_turnstile_unlocked:
		return
	is_turnstile_unlocked = true
	turnstile_unlocked.emit()
	
	if _door_player:
		_door_player.play()
	if camera:
		camera.add_trauma(0.2)
	
	if _turnstile_tween:
		_turnstile_tween.kill()
	_turnstile_tween = create_tween()
	
	if turnstile_barrier:
		var target_y := turnstile_barrier.position.y - 80.0
		_turnstile_tween.tween_property(turnstile_barrier, "position:y", target_y, 0.8).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		for child in turnstile_barrier.get_children():
			if child is CollisionShape2D:
				(child as CollisionShape2D).set_deferred("disabled", true)


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_turnstile_unlocked:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()



func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	
	var gate_col := VectorStageStyle.ANCHOR_CYAN if is_turnstile_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(500.0, 186.0), Vector2(500.0, 250.0), gate_col, 3.0)
