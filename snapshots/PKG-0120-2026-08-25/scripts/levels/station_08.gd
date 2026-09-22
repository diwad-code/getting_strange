class_name Station08
extends Node2D

## Station 08 (Przestrzeń 08: Numer czternaście) — Kanon 0.3
## Zgodny z docs/narrative/FULL_STORY.md (08), DIALOGUE_SCRIPT.md (Station 08 — domofon),
## docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md oraz docs/PIXEL_PRESENTATION_ARCHITECTURE.md.
##
## Cel: wejść do własnego budynku.
## Przeszkoda: zaświadczenie Leny wskazuje numer 12, a lista domofonu przypisuje LENA WOLSKA do numeru 14.
## Działanie: gracz porównuje dokument, nazwiska na liście i własny kod.
## Pokaż: kod i fizyczny klucz otwierają budynek. Nic się nie łamie, nic nie miga.
## Zmiana: hipoteza przechodzi z `zła ulica` na `przełożone numery`.

## PRZESZKODA — dlaczego to tu jest: Drzwi wejściowe bloku są zamknięte na zamek elektryczny, bo budynek stoi przy ruchliwej ulicy i zamyka się po zmroku.
## PRZESZKODA — czego wymaga od Leny: przeczytania listy lokatorów, porównania jej z własnym zaświadczeniem i wpisania własnego kodu przed dotknięciem klamki.
## PRZESZKODA — koszt porażki: szarpnięcie klamki przed weryfikacją odsyła Lenę na chodnik, a jedno nazwisko na liście zostaje wytarte deszczem.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)
const DOOR_CLOSED_Y := 262.0
const DOOR_OPEN_Y := 176.0

signal clue_inspected(id: String, prop_type: int)
signal entry_verified()
signal door_opened()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var entrance_door: AnimatableBody2D = $Geometry/BuildingEntranceDoor
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var dialogue_box: CRTDialogueBox = $CRTDialogueBox

var certificate_read: bool = false
var directory_read: bool = false
var keypad_used: bool = false
var is_entry_verified: bool = false
var is_door_open: bool = false
var is_level_completed: bool = false

var entry_attempt_count: int = 0
var directory_entry_faded: bool = false

var _door_progress: float = 0.0
var _pulse_time: float = 0.0

var _door_player: AudioStreamPlayer
var _keypad_player: AudioStreamPlayer
var _paper_player: AudioStreamPlayer
var _rain_player: AudioStreamPlayer


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
	_rain_player = AudioStreamPlayer.new()
	_rain_player.name = "RainAudioPlayer"
	_rain_player.stream = ProceduralAudio.create_rain_asphalt_sound()
	_rain_player.volume_db = -18.0
	_rain_player.bus = &"Master"
	add_child(_rain_player)
	_rain_player.play()

	_keypad_player = AudioStreamPlayer.new()
	_keypad_player.name = "KeypadAudioPlayer"
	_keypad_player.stream = ProceduralAudio.create_card_reader_beep_sound()
	_keypad_player.volume_db = -8.0
	_keypad_player.bus = &"Master"
	add_child(_keypad_player)

	_paper_player = AudioStreamPlayer.new()
	_paper_player.name = "PaperAudioPlayer"
	_paper_player.stream = ProceduralAudio.create_paper_rustle_sound()
	_paper_player.volume_db = -8.0
	_paper_player.bus = &"Master"
	add_child(_paper_player)

	_door_player = AudioStreamPlayer.new()
	_door_player.name = "DoorAudioPlayer"
	_door_player.stream = ProceduralAudio.create_apartment_door_sound()
	_door_player.volume_db = -4.0
	_door_player.bus = &"Master"
	add_child(_door_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return

	var beat_obs := GuidanceBeat.new()
	beat_obs.beat_id = &"s08_name_on_fourteen"
	beat_obs.scene_id = &"station_08"
	beat_obs.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_obs.thought_kind = &"observation"
	beat_obs.truth_scope = &"factual"
	beat_obs.text_pl = "Moje nazwisko. Czternaście."
	beat_obs.text_en = "My surname. Fourteen."
	beat_obs.cooldown_s = 8.0
	guidance_service.register_beat(beat_obs)

	var beat_hyp := GuidanceBeat.new()
	beat_hyp.beat_id = &"s08_numbers_swapped"
	beat_hyp.scene_id = &"station_08"
	beat_hyp.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_hyp.thought_kind = &"interpretation"
	beat_hyp.truth_scope = &"fallible"
	beat_hyp.text_pl = "Ktoś przełożył numery."
	beat_hyp.text_en = "Somebody swapped the numbers."
	beat_hyp.cooldown_s = 8.0
	beat_hyp.hypothesis_id = &"hyp_address_shift"
	beat_hyp.predicted_check = "check_door_number_and_admin"
	beat_hyp.supersedes = &"s08_name_on_fourteen"
	guidance_service.register_beat(beat_hyp)

	var beat_intent := GuidanceBeat.new()
	beat_intent.beat_id = &"s08_door_then_admin"
	beat_intent.scene_id = &"station_08"
	beat_intent.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_intent.thought_kind = &"intention"
	beat_intent.truth_scope = &"procedural"
	beat_intent.text_pl = "Najpierw drzwi. Potem administracja."
	beat_intent.text_en = "The door first. Administration after."
	beat_intent.cooldown_s = 8.0
	beat_intent.supersedes = &"s08_numbers_swapped"
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
	if is_door_open and _door_progress < 1.0:
		_door_progress = minf(1.0, _door_progress + delta * 1.4)
		if entrance_door:
			entrance_door.position.y = lerpf(DOOR_CLOSED_Y, DOOR_OPEN_Y, _door_progress)
	queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	prop.is_activated = true
	match id:
		"field_certificate":
			read_certificate()
		"tenant_directory":
			read_directory()
		"entry_keypad":
			use_keypad()
	clue_inspected.emit(id, prop_type)


func read_certificate() -> void:
	if certificate_read:
		return
	certificate_read = true
	if _paper_player:
		_paper_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.7)
	if guidance_service:
		guidance_service.report_progress(&"certificate_read")
	_evaluate_verification()


func read_directory() -> void:
	if directory_read:
		return
	directory_read = true
	if _paper_player:
		_paper_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.8)
	if guidance_service:
		guidance_service.trigger_beat(&"s08_name_on_fourteen")
	_evaluate_verification()


func use_keypad() -> void:
	if keypad_used:
		return
	keypad_used = true
	if _keypad_player:
		_keypad_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"interact", 0.6)
	if guidance_service:
		guidance_service.trigger_beat(&"s08_numbers_swapped")
	_evaluate_verification()


func _evaluate_verification() -> void:
	if is_entry_verified:
		return
	if not (certificate_read and directory_read and keypad_used):
		return
	is_entry_verified = true
	entry_verified.emit()
	_open_entrance_door()
	if guidance_service:
		guidance_service.report_progress(&"entry_verified")
		guidance_service.trigger_beat(&"s08_door_then_admin")


func _open_entrance_door() -> void:
	if is_door_open:
		return
	is_door_open = true
	if _door_player:
		_door_player.play()
	if camera:
		camera.add_trauma(0.12)
	door_opened.emit()


## Szarpnięcie klamki przed weryfikacją nie zabija ani nie kończy sceny —
## odsyła Lenę na chodnik i zabiera jeden czytelny szczegół listy lokatorów.
func apply_entry_setback() -> void:
	if is_entry_verified:
		return
	entry_attempt_count += 1
	directory_entry_faded = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_08_entry_retried", entry_attempt_count)
	if guidance_service:
		guidance_service.report_failed_attempt(&"entry_forced")
	if player:
		player.reset_to(Vector2(70.0, 296.0))
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"restart") and not is_entry_verified:
		apply_entry_setback()
		get_viewport().set_input_as_handled()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_door_open:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	var directory_col := VectorStageStyle.HUMAN_AMBER
	if directory_read:
		directory_col = VectorStageStyle.ANCHOR_CYAN
	if directory_entry_faded:
		directory_col = VectorStageStyle.shade(directory_col, 0.45)
	draw_rect(Rect2(Vector2(268.0, 214.0), Vector2(24.0, 46.0)), directory_col, false, 1.0)

	var keypad_col := VectorStageStyle.ANCHOR_CYAN if keypad_used else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.4)
	draw_rect(Rect2(Vector2(400.0, 226.0), Vector2(18.0, 22.0)), keypad_col, false, 1.0)

	var door_col := VectorStageStyle.ANCHOR_CYAN if is_door_open else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(500.0, 176.0), Vector2(500.0, 300.0), door_col, 2.0)
	draw_line(Vector2(556.0, 176.0), Vector2(556.0, 300.0), door_col, 2.0)
