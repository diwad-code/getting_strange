class_name Station11
extends Node2D

## Station 11 (Przestrzeń 11: Dwie osoby na zdjęciu) — Kanon 0.3
## Zgodny z docs/narrative/FULL_STORY.md (11), DIALOGUE_SCRIPT.md (Station 11 — zdjęcie),
## docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md oraz docs/PIXEL_PRESENTATION_ARCHITECTURE.md.
##
## Cel: ustalić, kto tu mieszka.
## Przeszkoda: ubrania, buty robocze i ustawienie czytnika pasują do ciała i zawodu Leny.
## Działanie: gracz porównuje własne zużycie sprzętu, pismo i datę zdjęcia.
## Pokaż: fotografia przedstawia Lenę i Martę w domowej, partnerskiej relacji. Nie ma na niej Jakuba.
## Zmiana: Lena rozważa kradzież tożsamości i lukę pamięci; nie przyjmuje tej relacji za swoją.

## PRZESZKODA — dlaczego to tu jest: Komoda w przedpokoju stoi bokiem w świetle przejścia, bo ktoś odsunął ją od ściany i nie dokończył sprzątania.
## PRZESZKODA — czego wymaga od Leny: przepchnięcia komody z powrotem pod ścianę, żeby dostać się do pokoju bez przewracania cudzych rzeczy.
## PRZESZKODA — koszt porażki: przeciśnięcie się na siłę zrzuca ramkę ze zdjęciem i jedna twarz na fotografii traci ostrość do końca sceny.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)
const SIDEBOARD_CLEAR_X := 452.0

signal clue_inspected(id: String, prop_type: int)
signal photograph_examined()
signal ownership_evidence_gathered()
signal passage_cleared()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var hallway_sideboard: MovableAnchorableProp = $Geometry/HallwaySideboard
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var dialogue_box: CRTDialogueBox = $CRTDialogueBox

var photograph_inspected: bool = false
var boots_inspected: bool = false
var reader_dock_inspected: bool = false
var handwriting_inspected: bool = false
var coat_inspected: bool = false
var is_evidence_complete: bool = false
var is_passage_clear: bool = false
var is_level_completed: bool = false

var sideboard_setback_count: int = 0
var photograph_face_blurred: bool = false

var _pulse_time: float = 0.0

var _photo_player: AudioStreamPlayer
var _step_player: AudioStreamPlayer
var _scrape_player: AudioStreamPlayer


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
	_photo_player = AudioStreamPlayer.new()
	_photo_player.name = "PhotoAudioPlayer"
	_photo_player.stream = ProceduralAudio.create_photo_slide_sound()
	_photo_player.volume_db = -7.0
	_photo_player.bus = &"Master"
	add_child(_photo_player)

	_step_player = AudioStreamPlayer.new()
	_step_player.name = "ParquetAudioPlayer"
	_step_player.stream = ProceduralAudio.create_parquet_footstep_sound()
	_step_player.volume_db = -12.0
	_step_player.bus = &"Master"
	add_child(_step_player)

	_scrape_player = AudioStreamPlayer.new()
	_scrape_player.name = "SideboardAudioPlayer"
	_scrape_player.stream = ProceduralAudio.create_masonry_smooth_sound()
	_scrape_player.volume_db = -9.0
	_scrape_player.bus = &"Master"
	add_child(_scrape_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return

	var beat_obs := GuidanceBeat.new()
	beat_obs.beat_id = &"s11_that_is_marta"
	beat_obs.scene_id = &"station_11"
	beat_obs.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_obs.thought_kind = &"observation"
	beat_obs.truth_scope = &"factual"
	beat_obs.text_pl = "To Marta. To ja."
	beat_obs.text_en = "That is Marta. That is me."
	beat_obs.cooldown_s = 8.0
	guidance_service.register_beat(beat_obs)

	var beat_hyp := GuidanceBeat.new()
	beat_hyp.beat_id = &"s11_marta_would_not"
	beat_hyp.scene_id = &"station_11"
	beat_hyp.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_hyp.thought_kind = &"interpretation"
	beat_hyp.truth_scope = &"fallible"
	beat_hyp.text_pl = "Nie zrobiłaby takiego zdjęcia."
	beat_hyp.text_en = "She would not take a photo like this."
	beat_hyp.cooldown_s = 8.0
	beat_hyp.hypothesis_id = &"hyp_identity_theft"
	beat_hyp.predicted_check = "check_marta_directly"
	beat_hyp.supersedes = &"s11_that_is_marta"
	guidance_service.register_beat(beat_hyp)

	var beat_intent := GuidanceBeat.new()
	beat_intent.beat_id = &"s11_reach_marta"
	beat_intent.scene_id = &"station_11"
	beat_intent.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_intent.thought_kind = &"intention"
	beat_intent.truth_scope = &"procedural"
	beat_intent.text_pl = "Potrzebuję faktu spoza tego mieszkania."
	beat_intent.text_en = "I need a fact from outside this flat."
	beat_intent.cooldown_s = 8.0
	beat_intent.supersedes = &"s11_marta_would_not"
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
	if not is_passage_clear and hallway_sideboard and hallway_sideboard.position.x >= SIDEBOARD_CLEAR_X:
		is_passage_clear = true
		if _scrape_player:
			_scrape_player.play()
		if guidance_service:
			guidance_service.report_progress(&"hallway_cleared")
		passage_cleared.emit()
	queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	prop.is_activated = true
	match id:
		"commode_photograph":
			examine_photograph()
		"work_boots":
			boots_inspected = true
			_note_domestic_detail(&"examine")
		"field_reader_dock":
			reader_dock_inspected = true
			_note_domestic_detail(&"examine")
		"handwriting_note":
			handwriting_inspected = true
			_note_domestic_detail(&"examine")
		"wardrobe_coat":
			coat_inspected = true
			_note_domestic_detail(&"unease_reaction")
	clue_inspected.emit(id, prop_type)
	_check_evidence_complete()


func examine_photograph() -> void:
	if photograph_inspected:
		return
	photograph_inspected = true
	if _photo_player:
		_photo_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"unease_reaction", 1.0)
	if guidance_service:
		guidance_service.trigger_beat(&"s11_that_is_marta")
	photograph_examined.emit()
	_check_evidence_complete()


func _note_domestic_detail(cue: StringName) -> void:
	if _step_player:
		_step_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(cue, 0.7)


func _check_evidence_complete() -> void:
	if is_evidence_complete:
		return
	if not (photograph_inspected and boots_inspected and reader_dock_inspected):
		return
	is_evidence_complete = true
	if guidance_service:
		guidance_service.report_progress(&"ownership_evidence")
		guidance_service.trigger_beat(&"s11_marta_would_not")
	ownership_evidence_gathered.emit()


func push_sideboard(direction: float) -> void:
	if hallway_sideboard:
		hallway_sideboard.receive_push(direction)


## Przeciśnięcie się obok komody zrzuca ramkę: powrót na próg i jedna twarz mniej ostra.
func apply_sideboard_setback() -> void:
	if is_passage_clear:
		return
	sideboard_setback_count += 1
	photograph_face_blurred = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_11_sideboard_reset", sideboard_setback_count)
	if guidance_service:
		guidance_service.report_failed_attempt(&"sideboard_squeezed")
	if hallway_sideboard:
		hallway_sideboard.reset_to_spawn()
	if player:
		player.reset_to(Vector2(70.0, 296.0))
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"restart") and not is_passage_clear:
		apply_sideboard_setback()
		get_viewport().set_input_as_handled()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_evidence_complete:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	var photo_col := VectorStageStyle.HUMAN_AMBER
	if photograph_inspected:
		photo_col = VectorStageStyle.ANCHOR_CYAN
	if photograph_face_blurred:
		photo_col = VectorStageStyle.shade(photo_col, 0.45)
	draw_rect(Rect2(Vector2(214.0, 214.0), Vector2(34.0, 26.0)), photo_col, false, 1.0)

	var boots_col := VectorStageStyle.HUMAN_AMBER if boots_inspected else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.35)
	draw_rect(Rect2(Vector2(120.0, 288.0), Vector2(28.0, 12.0)), boots_col, boots_inspected)

	var reader_col := VectorStageStyle.ANCHOR_CYAN if reader_dock_inspected else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.35)
	draw_rect(Rect2(Vector2(322.0, 244.0), Vector2(22.0, 14.0)), reader_col, false, 1.0)

	var exit_col := VectorStageStyle.ANCHOR_CYAN if is_evidence_complete else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(580.0, 182.0), Vector2(580.0, 298.0), exit_col, 2.0)
