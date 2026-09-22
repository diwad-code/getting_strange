class_name Station05
extends Node2D

## Station 05 (Przestrzeń 05: Znana ulica) — Kanon 0.3
## Zgodny ze specyfikacją docs/narrative/FULL_STORY.md (05) oraz VISUAL_DESIGN.md
##
## Cel: Przejść ostatni odcinek do domu.
## Przeszkoda: Brak przeszkody fabularnej; scena daje oddech i punkt odniesienia.
## Działanie: Gracz idzie znaną trasą, sprawdza sygnalizację i tablicę prac.
## Pokaż: Szyld wykonawcy "UCP / PRACE NOCNE" wygląda jak logo wykonawcy. Deszcz i światła są znajome.
## Zmiana: Kończy się pełna normalność. Flaga ordinary_return_complete zostaje zapisana.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)

signal clue_inspected(id: String, prop_type: int)
signal crosswalk_signal_activated()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var return_zone: Area2D = $ReturnZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var dialogue_box: CRTDialogueBox = $CRTDialogueBox

var is_ucp_notice_inspected: bool = false
var is_crosswalk_activated: bool = false
var is_street_corner_checked: bool = false
var is_level_completed: bool = false

var _pulse_time: float = 0.0

var _rain_player: AudioStreamPlayer
var _crosswalk_player: AudioStreamPlayer
var _transition_player: AudioStreamPlayer


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
	_rain_player = AudioStreamPlayer.new()
	_rain_player.name = "RainAudioPlayer"
	_rain_player.stream = ProceduralAudio.create_rain_asphalt_sound()
	_rain_player.volume_db = -10.0
	_rain_player.bus = &"Master"
	add_child(_rain_player)
	_rain_player.play()
	
	_crosswalk_player = AudioStreamPlayer.new()
	_crosswalk_player.name = "CrosswalkAudioPlayer"
	_crosswalk_player.stream = ProceduralAudio.create_crosswalk_signal_sound(false)
	_crosswalk_player.volume_db = -6.0
	_crosswalk_player.bus = &"Master"
	add_child(_crosswalk_player)
	
	_transition_player = AudioStreamPlayer.new()
	_transition_player.name = "TransitionAudioPlayer"
	_transition_player.stream = ProceduralAudio.create_airlock_seal_sound()
	_transition_player.volume_db = -5.0
	_transition_player.bus = &"Master"
	add_child(_transition_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	
	var beat_roadwork := GuidanceBeat.new()
	beat_roadwork.beat_id = &"s05_roadwork_observation"
	beat_roadwork.scene_id = &"station_05"
	beat_roadwork.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_roadwork.thought_kind = &"observation"
	beat_roadwork.text_pl = "Kolejne wykopy. Chodnik rozkopany od poniedziałku."
	beat_roadwork.text_en = "More excavations. Sidewalk dug up since Monday."
	beat_roadwork.cooldown_s = 8.0
	guidance_service.register_beat(beat_roadwork)


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
		"ucp_notice_board", "billboard", "billboard_anachronism":
			is_ucp_notice_inspected = true
			if player and player.has_method("play_visual_cue"):
				player.play_visual_cue(&"examine", 0.7)
			if guidance_service:
				guidance_service.trigger_beat(&"s05_roadwork_observation")
			clue_inspected.emit(id, prop_type)
			
		"crosswalk_signal", "crosswalk_beacon":
			is_crosswalk_activated = true
			if _crosswalk_player:
				_crosswalk_player.play()
			if player and player.has_method("play_visual_cue"):
				player.play_visual_cue(&"interact", 0.5)
			crosswalk_signal_activated.emit()
			clue_inspected.emit(id, prop_type)
			
		"street_corner", "transit_timetable", "missing_floor_marker":
			is_street_corner_checked = true
			clue_inspected.emit(id, prop_type)


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player"):
		if not is_level_completed:
			is_level_completed = true
			var game_state := get_node_or_null("/root/GameStateManager")
			if game_state and game_state.has_method("set_campaign_flag"):
				game_state.set_campaign_flag(&"ordinary_return_complete", true)
			if _transition_player:
				_transition_player.play()
			level_completed.emit()



func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	
	# Street signals and zebra crossing markers
	var sig_col := VectorStageStyle.ANCHOR_CYAN if is_crosswalk_activated else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(410.0, 216.0), Vector2(590.0, 212.0), sig_col, 2.0)
