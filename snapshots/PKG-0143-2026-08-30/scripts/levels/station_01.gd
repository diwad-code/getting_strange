class_name Station01
extends Node2D

## Station 01 (Przestrzeń 01: Wieczorny odczyt) — Kanon 2.0
## Zgodny z FULL_STORY.md 0.2, CONTINUITY_TRACKER.md 0.2, VISUAL_DESIGN.md

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")
## Rutynowy wieczorny pomiar drgań przy infrastrukturze kolejowej.
## Gracz uczy się ruchu, oglądania i pracy z czytnikiem.

signal reading_updated(step: int, total_steps: int)
signal measurement_completed()
signal level_completed()

const VIEW_SIZE := Vector2(640.0, 360.0)

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var chamber_door: AnimatableBody2D = $ChamberDoor
@onready var exit_door: Node2D = $ExitDoor
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var dialogue_box: CRTDialogueBox = $CRTDialogueBox

var photo_inspected: bool = false
var clipboard_inspected: bool = false
var circuit_alpha_on: bool = false
var circuit_beta_on: bool = false
var circuit_gamma_on: bool = false
var vacuum_checked: bool = false
var terminal_checked: bool = false

var sensor_checked: bool = false
var second_reading_done: bool = false
var gear_packed: bool = false
var is_procedure_completed: bool = false
var _door_open_progress: float = 0.0
var is_level_completed: bool = false

var _terminal_pulse: float = 0.0
var _hum_player: AudioStreamPlayer
var _scan_player: AudioStreamPlayer
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
	_hum_player = AudioStreamPlayer.new()
	_hum_player.name = "HumAudioPlayer"
	_hum_player.stream = ProceduralAudio.create_vacuum_hum_sound()
	_hum_player.volume_db = -16.0
	_hum_player.bus = &"Master"
	add_child(_hum_player)
	_hum_player.play()
	
	_scan_player = AudioStreamPlayer.new()
	_scan_player.name = "ScanAudioPlayer"
	_scan_player.stream = ProceduralAudio.create_dialogue_blip_sound(true)
	_scan_player.volume_db = -6.0
	_scan_player.bus = &"Master"
	add_child(_scan_player)
	
	_door_player = AudioStreamPlayer.new()
	_door_player.name = "DoorAudioPlayer"
	_door_player.stream = ProceduralAudio.create_airlock_seal_sound()
	_door_player.volume_db = -4.0
	_door_player.bus = &"Master"
	add_child(_door_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	
	var beat_repeat := GuidanceBeat.new()
	beat_repeat.beat_id = &"s01_repeat_reading"
	beat_repeat.scene_id = &"station_01"
	beat_repeat.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_repeat.thought_kind = &"interpretation"
	beat_repeat.text_pl = "Pociąg albo luźny uchwyt. Powtórzę odczyt."
	beat_repeat.text_en = "Train pass or loose bracket. I will repeat the reading."
	beat_repeat.cooldown_s = 8.0
	guidance_service.register_beat(beat_repeat)
	
	var beat_pack := GuidanceBeat.new()
	beat_pack.beat_id = &"s01_pack_and_exit"
	beat_pack.scene_id = &"station_01"
	beat_pack.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_pack.thought_kind = &"intention"
	beat_pack.text_pl = "Odczyt zapisany. Zbieram sprzęt i wychodzę."
	beat_pack.text_en = "Log saved. Packing up gear and leaving."
	beat_pack.cooldown_s = 8.0
	beat_pack.supersedes = &"s01_repeat_reading"
	var beat_door := GuidanceBeat.new()
	beat_door.beat_id = &"s01_door_blocked"
	beat_door.scene_id = &"station_01"
	beat_door.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_door.thought_kind = &"intention"
	beat_door.text_pl = "Śluza czeka na zapis. Najpierw drugi odczyt i torba."
	beat_door.text_en = "The lock waits for the log. Second reading and the bag first."
	beat_door.cooldown_s = 8.0
	guidance_service.register_beat(beat_door)

	guidance_service.register_beat(beat_pack)


func _connect_props() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var prop := child as MemoryResonancePoint
			prop.resonance_triggered.connect(_on_prop_resonance_triggered.bind(prop))


func _process(delta: float) -> void:
	_terminal_pulse += delta * 2.0
	if is_procedure_completed and _door_open_progress < 1.0:
		_door_open_progress = minf(1.0, _door_open_progress + delta * 1.5)


func _on_prop_resonance_triggered(id: String, _type: int, prop: MemoryResonancePoint) -> void:
	match id:
		"photo_desk":
			photo_inspected = true
			prop.is_activated = true
		"clipboard":
			clipboard_inspected = true
			prop.is_activated = true
		"circuit_alpha":
			circuit_alpha_on = true
			prop.is_activated = true
		"circuit_beta":
			circuit_beta_on = true
			prop.is_activated = true
		"circuit_gamma":
			circuit_gamma_on = true
			prop.is_activated = true
		"vacuum_manometer":
			vacuum_checked = true
			prop.is_activated = true
			if circuit_alpha_on and circuit_beta_on and circuit_gamma_on:
				_complete_procedure()
		"chamber_terminal":
			terminal_checked = true
			prop.is_activated = true
		"vibration_sensor":
			if not sensor_checked:
				sensor_checked = true
				prop.is_activated = false
				if _scan_player:
					_scan_player.play()
				if player and player.has_method("play_visual_cue"):
					player.play_visual_cue(&"examine", 0.8)
				if guidance_service:
					guidance_service.trigger_beat(&"s01_repeat_reading")
				reading_updated.emit(1, 3)
			elif not second_reading_done:
				second_reading_done = true
				prop.is_activated = true
				prop.is_one_shot = true
				if _scan_player:
					_scan_player.pitch_scale = 1.15
					_scan_player.play()
				if player and player.has_method("play_visual_cue"):
					player.play_visual_cue(&"interact", 0.6)
				if guidance_service:
					guidance_service.report_progress(&"reading_done")
					guidance_service.trigger_beat(&"s01_pack_and_exit")
				reading_updated.emit(2, 3)
		"packing_bag":
			if second_reading_done and not gear_packed:
				gear_packed = true
				prop.is_activated = true
				_complete_procedure()
				if _scan_player:
					_scan_player.pitch_scale = 0.9
					_scan_player.play()
				if player and player.has_method("play_visual_cue"):
					player.play_visual_cue(&"seam_gesture", 0.7)
				reading_updated.emit(3, 3)
			elif not second_reading_done:
				prop.is_activated = false
				if guidance_service:
					guidance_service.trigger_beat(&"s01_repeat_reading")


func _complete_procedure() -> void:
	if is_procedure_completed:
		return
	is_procedure_completed = true
	_unlock_exit_door()
	measurement_completed.emit()


func _unlock_exit_door() -> void:
	if _door_player:
		_door_player.play()
	if camera:
		camera.add_trauma(0.2)
	if chamber_door:
		ExitClearance.open_body_tweened(self, chamber_door)
	_door_open_progress = 1.0



func _on_airlock_body_entered(body: Node2D) -> void:
	if not (body is PrototypePlayer or body.name == "Player"):
		return
	if not is_procedure_completed:
		if guidance_service:
			guidance_service.trigger_beat(&"s01_door_blocked")
		return
	if not is_level_completed:
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var status_col := VectorStageStyle.ANCHOR_CYAN if is_procedure_completed else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(566.0, 174.0), Vector2(566.0, 252.0), status_col, 2.0)
