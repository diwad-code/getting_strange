class_name Station06
extends Node2D

## Station 06 (Przestrzeń 06: Dwa rozkłady) — Kanon 0.3
## Zgodny ze specyfikacją docs/narrative/FULL_STORY.md (06), DIALOGUE_SCRIPT.md oraz VISUAL_DESIGN.md
##
## Cel: Wybrać właściwy przystanek lub drogę pieszą.
## Przeszkoda: Papierowy rozkład i zapis offline w aplikacji mają tę samą datę, lecz różne numery linii.
## Działanie: Gracz porównuje datę, identyfikator wersji i tablicę kierunku nadjeżdżającego autobusu.
## Pokaż: Obie wersje są poprawne; bieżący autobus potwierdza papier.
## Zmiana: Lena uznaje cache aplikacji za stary ("Cache. Najprostsze."). Pierwsza racjonalizowalna rysa.

## PRZESZKODA — dlaczego to tu jest: Drzwi autobusu komunikacji nocnej otwierają się po potwierdzeniu kursu z rozkładu.
## PRZESZKODA — czego wymaga od Leny: porównania rozkładu papierowego z cache aplikacji i wejścia do pojazdu.
## PRZESZKODA — koszt porażki: odesłanie do wiaty przystankowej i utrata pewności co do numeru linii.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)

signal clue_inspected(id: String, prop_type: int)
signal timetable_compared()
signal bus_arrived()
signal doors_opened()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var replacement_bus_exit_door: AnimatableBody2D = $Geometry/ReplacementBusExitDoor if has_node("Geometry/ReplacementBusExitDoor") else get_node_or_null("ReplacementBusExitDoor")
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var dialogue_box: CRTDialogueBox = $CRTDialogueBox

var is_paper_timetable_inspected: bool = false
var is_phone_app_inspected: bool = false
var is_bus_stop_checked: bool = false

var are_doors_open: bool = false
var door_open_progress: float = 0.0
var is_level_completed: bool = false

var bus_exit_correction_count: int = 0
var bus_exit_detail_faded: bool = false

var _pulse_time: float = 0.0


var _bus_player: AudioStreamPlayer
var _door_player: AudioStreamPlayer
var _blip_player: AudioStreamPlayer
var _transition_player: AudioStreamPlayer


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
	_bus_player = AudioStreamPlayer.new()
	_bus_player.name = "BusAudioPlayer"
	_bus_player.stream = ProceduralAudio.create_bus_engine_sound(false)
	_bus_player.volume_db = -10.0
	_bus_player.bus = &"Master"
	add_child(_bus_player)
	_bus_player.play()
	
	_door_player = AudioStreamPlayer.new()
	_door_player.name = "DoorAudioPlayer"
	_door_player.stream = ProceduralAudio.create_bus_door_pneumatic_sound()
	_door_player.volume_db = -5.0
	_door_player.bus = &"Master"
	add_child(_door_player)
	
	_blip_player = AudioStreamPlayer.new()
	_blip_player.name = "BlipAudioPlayer"
	_blip_player.stream = ProceduralAudio.create_dialogue_blip_sound(true)
	_blip_player.volume_db = -5.0
	_blip_player.bus = &"Master"
	add_child(_blip_player)
	
	_transition_player = AudioStreamPlayer.new()
	_transition_player.name = "TransitionAudioPlayer"
	_transition_player.stream = ProceduralAudio.create_airlock_seal_sound()
	_transition_player.volume_db = -6.0
	_transition_player.bus = &"Master"
	add_child(_transition_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	
	var beat_obs := GuidanceBeat.new()
	beat_obs.beat_id = &"s06_two_schedules_observation"
	beat_obs.scene_id = &"station_06"
	beat_obs.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_obs.thought_kind = &"observation"
	beat_obs.text_pl = "Ta sama data. Dwie trasy."
	beat_obs.text_en = "Same date. Two different routes."
	beat_obs.cooldown_s = 8.0
	guidance_service.register_beat(beat_obs)
	
	var beat_hyp := GuidanceBeat.new()
	beat_hyp.beat_id = &"s06_cache_hypothesis"
	beat_hyp.scene_id = &"station_06"
	beat_hyp.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_hyp.thought_kind = &"interpretation"
	beat_hyp.text_pl = "Cache w telefonie. Najprostsze."
	beat_hyp.text_en = "Phone app cache. Most likely."
	beat_hyp.cooldown_s = 8.0
	beat_hyp.hypothesis_id = &"hyp_app_cache"
	beat_hyp.predicted_check = "check_paper_stamp"
	beat_hyp.supersedes = &"s06_two_schedules_observation"
	guidance_service.register_beat(beat_hyp)
	
	var beat_intent := GuidanceBeat.new()
	beat_intent.beat_id = &"s06_check_paper_intent"
	beat_intent.scene_id = &"station_06"
	beat_intent.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_intent.thought_kind = &"intention"
	beat_intent.text_pl = "Sprawdzę datę na papierze."
	beat_intent.text_en = "I'll check the version stamp on the paper."
	beat_intent.cooldown_s = 8.0
	beat_intent.supersedes = &"s06_cache_hypothesis"
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
	if are_doors_open and door_open_progress < 1.0:
		door_open_progress = minf(1.0, door_open_progress + delta * 2.2)
	queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	prop.is_activated = true
	match id:
		"paper_timetable", "bus_route_map":
			is_paper_timetable_inspected = true
			if _blip_player:
				_blip_player.play()
			if player and player.has_method("play_visual_cue"):
				player.play_visual_cue(&"examine", 0.7)
			if guidance_service:
				guidance_service.trigger_beat(&"s06_two_schedules_observation")
			clue_inspected.emit(id, prop_type)
			_check_unlock_condition()
			
		"phone_app_schedule", "elderly_passenger", "bus_speaker":
			is_phone_app_inspected = true
			if _blip_player:
				_blip_player.pitch_scale = 1.15
				_blip_player.play()
			if player and player.has_method("play_visual_cue"):
				player.play_visual_cue(&"interact", 0.6)
			if guidance_service:
				guidance_service.trigger_beat(&"s06_cache_hypothesis")
			timetable_compared.emit()
			clue_inspected.emit(id, prop_type)
			_check_unlock_condition()
			
		"bus_arrival_stop", "gold_ring":
			is_bus_stop_checked = true
			if player and player.has_method("play_visual_cue"):
				player.play_visual_cue(&"examine", 0.5)
			clue_inspected.emit(id, prop_type)
			_check_unlock_condition()


func _check_unlock_condition() -> void:
	if (is_paper_timetable_inspected or is_phone_app_inspected) and not are_doors_open:
		open_bus_doors()


func _apply_bus_exit_correction() -> void:
	bus_exit_correction_count += 1
	bus_exit_detail_faded = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_06_bus_exit_corrected", bus_exit_correction_count)
	queue_redraw()


func _open_bus_doors() -> void:
	open_bus_doors()


func open_bus_doors() -> void:
	if are_doors_open:
		return
	are_doors_open = true
	door_open_progress = 0.0
	bus_arrived.emit()
	doors_opened.emit()
	
	if _door_player:
		_door_player.play()
	if camera:
		camera.add_trauma(0.18)
	
	if replacement_bus_exit_door:
		ExitClearance.open_body_tweened(self, replacement_bus_exit_door, 126.0, 0.8)


	
	doors_opened.emit()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and are_doors_open:
		if not is_level_completed:
			is_level_completed = true
			var game_state := get_node_or_null("/root/GameStateManager")
			if game_state and game_state.has_method("set_campaign_flag"):
				game_state.set_campaign_flag(&"unease_pattern_started", true)
			if _transition_player:
				_transition_player.play()
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	
	var door_col := VectorStageStyle.ANCHOR_CYAN if are_doors_open else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(560.0, 60.0), Vector2(560.0, 312.0), door_col, 2.0)
	draw_line(Vector2(610.0, 60.0), Vector2(610.0, 312.0), door_col, 2.0)
	draw_circle(Vector2(585.0, 52.0), 4.0, door_col)
