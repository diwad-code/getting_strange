class_name Station02
extends Node2D

## Station 02 (Przestrzeń 02: Obejście serwisowe) — Kanon 0.3
## Zgodny ze specyfikacją docs/narrative/FULL_STORY.md (02) oraz VISUAL_DESIGN.md
##
## Cel: Opuścić teren pomiaru.
## Przeszkoda: Znany skrót jest fizycznie zamknięty z powodu rzeczywistych prac konserwacyjnych.
## Działanie: Lena czyta oznaczenia, sprawdza wygaszony obwód i wybiera bezpieczne obejście po kładce.
## Pokaż: Taśmy ostrzegawcze, ślady kół wózków, pracująca wentylacja i lampy robocze.
## Zmiana: Potwierdzenie kompetencji technicznej; brak jakiejkolwiek anomalii.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)

signal route_inspected(id: String)
signal bypass_unlocked()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var chamber_door: AnimatableBody2D = $ChamberDoor
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var dialogue_box: CRTDialogueBox = $CRTDialogueBox

var is_maintenance_inspected: bool = false
var is_subpanel_checked: bool = false
var is_catwalk_cleared: bool = false
var is_door_unlocked: bool = false
var is_level_completed: bool = false

var _door_open_progress: float = 0.0
var _pulse_time: float = 0.0

var _ambient_hum_player: AudioStreamPlayer
var _door_player: AudioStreamPlayer
var _switch_player: AudioStreamPlayer


func _ready() -> void:
	_setup_camera()
	_setup_audio()
	_setup_guidance()
	_connect_props()
	
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	
	var gsm := get_node_or_null("/root/GameStateManager")
	if gsm and gsm.target_spawn_side == &"right":
		unlock_exit_door()
	
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
	_ambient_hum_player.stream = ProceduralAudio.create_vacuum_hum_sound()
	_ambient_hum_player.volume_db = -16.0
	_ambient_hum_player.bus = &"Master"
	add_child(_ambient_hum_player)
	_ambient_hum_player.play()
	
	_door_player = AudioStreamPlayer.new()
	_door_player.name = "DoorAudioPlayer"
	_door_player.stream = ProceduralAudio.create_airlock_seal_sound()
	_door_player.volume_db = -4.0
	_door_player.bus = &"Master"
	add_child(_door_player)
	
	_switch_player = AudioStreamPlayer.new()
	_switch_player.name = "SwitchAudioPlayer"
	_switch_player.stream = ProceduralAudio.create_dialogue_blip_sound(true)
	_switch_player.volume_db = -6.0
	_switch_player.bus = &"Master"
	add_child(_switch_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	
	var beat_catwalk := GuidanceBeat.new()
	beat_catwalk.beat_id = &"s02_catwalk_observation"
	beat_catwalk.scene_id = &"station_02"
	beat_catwalk.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_catwalk.thought_kind = &"observation"
	beat_catwalk.text_pl = "Ścieżka serwisowa jest wolna. Wyjście z tyłu komory."
	beat_catwalk.text_en = "Service walkway is clear. Exit behind the chamber."
	beat_catwalk.cooldown_s = 8.0
	guidance_service.register_beat(beat_catwalk)
	
	var beat_subpanel := GuidanceBeat.new()
	beat_subpanel.beat_id = &"s02_subpanel_checked"
	beat_subpanel.scene_id = &"station_02"
	beat_subpanel.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_subpanel.thought_kind = &"intention"
	beat_subpanel.text_pl = "Obwód wygaszony na czas robót. Idę kładką."
	beat_subpanel.text_en = "Circuit powered down for maintenance. Taking the catwalk."
	beat_subpanel.cooldown_s = 8.0
	beat_subpanel.supersedes = &"s02_catwalk_observation"
	guidance_service.register_beat(beat_subpanel)


func _connect_props() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var prop := child as MemoryResonancePoint
			prop.resonance_triggered.connect(_on_prop_resonance_triggered.bind(prop))


func _process(delta: float) -> void:
	_pulse_time += delta * 2.0
	if is_door_unlocked and _door_open_progress < 1.0:
		_door_open_progress = minf(1.0, _door_open_progress + delta * 1.5)
	queue_redraw()


func _on_prop_resonance_triggered(id: String, _type: int, prop: MemoryResonancePoint) -> void:
	prop.is_activated = true
	match id:
		"maintenance_sign", "strip_printer":
			is_maintenance_inspected = true
			if _switch_player:
				_switch_player.play()
			if player and player.has_method("play_visual_cue"):
				player.play_visual_cue(&"examine", 0.7)
			if guidance_service:
				guidance_service.trigger_beat(&"s02_catwalk_observation")
			route_inspected.emit(id)
			_check_unlock_condition()
			
		"service_subpanel", "correlation_console":
			is_subpanel_checked = true
			if _switch_player:
				_switch_player.pitch_scale = 1.1
				_switch_player.play()
			if player and player.has_method("play_visual_cue"):
				player.play_visual_cue(&"interact", 0.6)
			if guidance_service:
				guidance_service.report_progress(&"subpanel_checked")
				guidance_service.trigger_beat(&"s02_subpanel_checked")
			route_inspected.emit(id)
			_check_unlock_condition()
			
		"service_catwalk", "optical_calibration":
			is_catwalk_cleared = true
			if player and player.has_method("play_visual_cue"):
				player.play_visual_cue(&"examine", 0.5)
			route_inspected.emit(id)
			_check_unlock_condition()


func _check_unlock_condition() -> void:
	if (is_maintenance_inspected or is_subpanel_checked) and not is_door_unlocked:
		unlock_exit_door()


func unlock_exit_door() -> void:
	if is_door_unlocked:
		return
	is_door_unlocked = true
	bypass_unlocked.emit()
	
	if _door_player:
		_door_player.play()
	if camera:
		camera.add_trauma(0.2)
	
	if chamber_door:
		ExitClearance.open_body_tweened(self, chamber_door)
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
	
	# Maintenance bypass lighting & barrier lines
	var status_col := VectorStageStyle.ANCHOR_CYAN if is_door_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(566.0, 174.0), Vector2(566.0, 252.0), status_col, 2.0)
	
	# Caution stripes on the catwalk barrier (x=240..340, y=280)
	var bar_y := 280.0
	draw_line(Vector2(240.0, bar_y), Vector2(340.0, bar_y), VectorStageStyle.INK, 3.0)
	for i in range(5):
		var bx := 245.0 + float(i) * 18.0
		draw_line(Vector2(bx, bar_y - 2.0), Vector2(bx + 8.0, bar_y + 2.0), VectorStageStyle.HUMAN_AMBER, 2.0)
