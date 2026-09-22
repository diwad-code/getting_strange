class_name Station10
extends Node2D

## Station 10 (Przestrzeń 10: Klucz) — Kanon 0.3
## Zgodny z docs/narrative/FULL_STORY.md (10 Klucz), DIALOGUE_SCRIPT.md,
## docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md oraz docs/PIXEL_PRESENTATION_ARCHITECTURE.md.
##
## Cel: sprawdzić, czy klucz rzeczywiście pasuje do numeru 14.
## Przeszkoda: zamek rozpoznaje klucz bez oporu.
## Działanie: gracz sprawdza numer, próg i obecność innych osób, zanim przekroczy drzwi.
## Pokaż: Lena nie wchodzi odruchowo. Odstawia torbę tak, by móc natychmiast wyjść.
## Zmiana: `przełożone numery` nie tłumaczą klucza; `pomyłka lokalu` pozostaje możliwa.

## PRZESZKODA — dlaczego to tu jest: Drzwi mieszkania 14 mają zamek wielopunktowy, który po jednym obrocie zostaje w połowie i blokuje skrzydło.
## PRZESZKODA — czego wymaga od Leny: przeczytania tabliczki, pełnego obrotu klucza i odstawienia torby na progu, zanim wejdzie do środka.
## PRZESZKODA — koszt porażki: pchnięcie skrzydła z torbą na ramieniu zatrzaskuje zamek i odsyła Lenę na spocznik, a numer na tabliczce zostaje zmatowiony.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)
const DOOR_CLOSED_Y := 252.0
const DOOR_OPEN_Y := 170.0

signal clue_inspected(id: String, prop_type: int)
signal key_turned()
signal bag_set_down()
signal threshold_opened()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var apartment_door: AnimatableBody2D = $Geometry/ApartmentDoor14
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var dialogue_box: CRTDialogueBox = $CRTDialogueBox

var number_plate_read: bool = false
var is_key_turned: bool = false
var is_bag_set_down: bool = false
var is_threshold_open: bool = false
var is_level_completed: bool = false

var threshold_setback_count: int = 0
var number_plate_dulled: bool = false

var _door_progress: float = 0.0
var _pulse_time: float = 0.0

var _lock_player: AudioStreamPlayer
var _door_player: AudioStreamPlayer
var _bag_player: AudioStreamPlayer


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
	_lock_player = AudioStreamPlayer.new()
	_lock_player.name = "LockAudioPlayer"
	_lock_player.stream = ProceduralAudio.create_drawer_lock_unlatch_sound()
	_lock_player.volume_db = -6.0
	_lock_player.bus = &"Master"
	add_child(_lock_player)

	_door_player = AudioStreamPlayer.new()
	_door_player.name = "DoorAudioPlayer"
	_door_player.stream = ProceduralAudio.create_apartment_door_sound()
	_door_player.volume_db = -4.0
	_door_player.bus = &"Master"
	add_child(_door_player)

	_bag_player = AudioStreamPlayer.new()
	_bag_player.name = "BagAudioPlayer"
	_bag_player.stream = ProceduralAudio.create_paper_rustle_sound()
	_bag_player.volume_db = -10.0
	_bag_player.bus = &"Master"
	add_child(_bag_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return

	var beat_obs := GuidanceBeat.new()
	beat_obs.beat_id = &"s10_key_fits"
	beat_obs.scene_id = &"station_10"
	beat_obs.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_obs.thought_kind = &"observation"
	beat_obs.truth_scope = &"factual"
	beat_obs.text_pl = "Zamek ustąpił od razu."
	beat_obs.text_en = "The lock gave way at once."
	beat_obs.cooldown_s = 8.0
	guidance_service.register_beat(beat_obs)

	var beat_hyp := GuidanceBeat.new()
	beat_hyp.beat_id = &"s10_same_lock_series"
	beat_hyp.scene_id = &"station_10"
	beat_hyp.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_hyp.thought_kind = &"interpretation"
	beat_hyp.truth_scope = &"fallible"
	beat_hyp.text_pl = "Ta sama seria zamków. Zdarza się."
	beat_hyp.text_en = "Same lock series. It happens."
	beat_hyp.cooldown_s = 8.0
	beat_hyp.hypothesis_id = &"hyp_lock_coincidence"
	beat_hyp.predicted_check = "check_owner_evidence_inside"
	beat_hyp.supersedes = &"s10_key_fits"
	guidance_service.register_beat(beat_hyp)

	var beat_intent := GuidanceBeat.new()
	beat_intent.beat_id = &"s10_bag_by_the_door"
	beat_intent.scene_id = &"station_10"
	beat_intent.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_intent.thought_kind = &"intention"
	beat_intent.truth_scope = &"procedural"
	beat_intent.text_pl = "Torba przy drzwiach. Wyjdę w trzy kroki."
	beat_intent.text_en = "Bag by the door. Three steps back out."
	beat_intent.cooldown_s = 8.0
	beat_intent.supersedes = &"s10_same_lock_series"
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
	if is_threshold_open and _door_progress < 1.0:
		_door_progress = minf(1.0, _door_progress + delta * 1.3)
		if apartment_door:
			apartment_door.position.y = lerpf(DOOR_CLOSED_Y, DOOR_OPEN_Y, _door_progress)
	queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	prop.is_activated = true
	match id:
		"door_number_plate":
			read_number_plate()
		"lock_cylinder":
			turn_key()
		"field_bag":
			set_bag_down()
	clue_inspected.emit(id, prop_type)


func read_number_plate() -> void:
	if number_plate_read:
		return
	number_plate_read = true
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.7)
	if guidance_service:
		guidance_service.report_progress(&"number_plate_read")
	_check_threshold_conditions()


func turn_key() -> void:
	if is_key_turned:
		return
	is_key_turned = true
	if _lock_player:
		_lock_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"interact", 0.8)
	if guidance_service:
		guidance_service.trigger_beat(&"s10_key_fits")
		## Klucz pasuje, więc przełożone numery przestają cokolwiek tłumaczyć.
		guidance_service.close_hypothesis(&"hyp_address_shift")
		guidance_service.trigger_beat(&"s10_same_lock_series")
	key_turned.emit()
	_check_threshold_conditions()


func set_bag_down() -> void:
	if is_bag_set_down:
		return
	is_bag_set_down = true
	if _bag_player:
		_bag_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"seam_gesture", 0.7)
	if guidance_service:
		guidance_service.report_progress(&"bag_set_down")
		guidance_service.trigger_beat(&"s10_bag_by_the_door")
	bag_set_down.emit()
	_check_threshold_conditions()


func _check_threshold_conditions() -> void:
	if is_threshold_open:
		return
	if not (is_key_turned and is_bag_set_down):
		return
	is_threshold_open = true
	if _door_player:
		_door_player.play()
	if camera:
		camera.add_trauma(0.1)
	threshold_opened.emit()


## Wejście z torbą na ramieniu kończy się zatrzaśniętym zamkiem i powrotem na spocznik.
func apply_threshold_setback() -> void:
	if is_threshold_open:
		return
	threshold_setback_count += 1
	number_plate_dulled = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_10_threshold_reset", threshold_setback_count)
	if guidance_service:
		guidance_service.report_failed_attempt(&"threshold_forced")
	if player:
		player.reset_to(Vector2(70.0, 296.0))
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"restart") and not is_threshold_open:
		apply_threshold_setback()
		get_viewport().set_input_as_handled()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_threshold_open:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	var plate_col := VectorStageStyle.ANCHOR_CYAN if number_plate_read else VectorStageStyle.HUMAN_AMBER
	if number_plate_dulled:
		plate_col = VectorStageStyle.shade(plate_col, 0.45)
	draw_rect(Rect2(Vector2(430.0, 186.0), Vector2(28.0, 18.0)), plate_col, false, 1.0)

	var lock_col := VectorStageStyle.ANCHOR_CYAN if is_key_turned else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.4)
	draw_circle(Vector2(444.0, 240.0), 4.0, lock_col)

	var bag_col := VectorStageStyle.HUMAN_AMBER if is_bag_set_down else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.35)
	draw_rect(Rect2(Vector2(352.0, 286.0), Vector2(26.0, 16.0)), bag_col, is_bag_set_down)

	var door_col := VectorStageStyle.ANCHOR_CYAN if is_threshold_open else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(476.0, 170.0), Vector2(476.0, 300.0), door_col, 2.0)
