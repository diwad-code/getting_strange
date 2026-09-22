class_name Station20
extends Node2D

## Station 20 (Przestrzeń 20: Człowiek po tej dacie) — Kanon 0.3
## Zgodny z docs/narrative/FULL_STORY.md (20), DIALOGUE_SCRIPT.md (Station 20 — spotkanie),
## docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md oraz docs/PIXEL_PRESENTATION_ARCHITECTURE.md.
##
## Cel: sprawdzić, czy Jakub jest żywą osobą z lokalną historią.
## Przeszkoda: obie strony widzą znajome ciało i obcą relację. Lena odruchowo traktuje bliznę jak materiał dowodowy.
## Działanie: rozmowa, prośba o bliznę (odmowa), dobrowolny skan czytnika w stacji diagnostycznej.
## Pokaż: czytnik Leny nie istnieje w lokalnej bazie serwisowej L4; Jakub ma 34 lata i realne życie.
## Zmiana: Lena ma relacyjny i materialny dowód; przechodzi do syntezy trzech źródeł.

## PRZESZKODA — dlaczego to tu jest: Warsztatowy wózek z częściami rozdziela przestrzeń rozmowy; Jakub stoi przy stole montażowym i wymaga uszanowania swoich granic cielesnych.
## PRZESZKODA — czego wymaga od Leny: rozmowy twarzą w twarz, poproszenia o dobrowolny skan czytnika w stacji serwisowej i zaakceptowania odmowy obnażenia blizny.
## PRZESZKODA — koszt porażki: próba dotknięcia boku Jakuba siłą powoduje przerwanie rozmowy i cofnięcie się Jakuba za stół montażowy; koszt zapisany w rejestrze decyzji.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)

signal clue_inspected(id: String, prop_type: int)
signal jakub_dialogue_started()
signal jakub_dialogue_advanced(step: int)
signal jakub_dialogue_completed()
signal scar_requested()
signal reader_diagnosed()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var dialogue_box: CRTDialogueBox = $CRTDialogueBox

var meeting_dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "JAKUB",
		"text": "Marta powiedziała, że pamiętasz mój pogrzeb.",
		"is_lena": false,
		"is_jakub": true,
	},
	{
		"speaker": "LENA",
		"text": "Nie musiała ci tego mówić.",
		"is_lena": true,
		"is_jakub": false,
	},
	{
		"speaker": "JAKUB",
		"text": "Nie musiała.",
		"is_lena": false,
		"is_jakub": true,
	},
	{
		"speaker": "LENA",
		"text": "Pokaż bliznę.",
		"is_lena": true,
		"is_jakub": false,
	},
	{
		"speaker": "JAKUB",
		"text": "Nie. Możesz zapytać. Nie możesz mnie sprawdzać bez końca.",
		"is_lena": false,
		"is_jakub": true,
	},
	{
		"speaker": "JAKUB",
		"text": "Tego numeru czytnika nie ma w naszej bazie serwisowej.",
		"is_lena": false,
		"is_jakub": true,
	},
	{
		"speaker": "LENA",
		"text": "Baza może być zmieniona.",
		"is_lena": true,
		"is_jakub": false,
	},
	{
		"speaker": "JAKUB",
		"text": "Pewnie. Moje trzydzieści cztery lata też?",
		"is_lena": false,
		"is_jakub": true,
	},
]

var is_dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false
var is_scar_refused: bool = false
var is_reader_diagnosed: bool = false
var is_level_completed: bool = false

var boundary_setback_count: int = 0
var jakub_stepped_back: bool = false
var _pulse_time: float = 0.0

var _dock_player: AudioStreamPlayer
var _wrench_player: AudioStreamPlayer


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
	_dock_player = AudioStreamPlayer.new()
	_dock_player.name = "DockAudioPlayer"
	_dock_player.stream = ProceduralAudio.create_drafting_lamp_hum_sound()
	_dock_player.volume_db = -10.0
	_dock_player.bus = &"Master"
	add_child(_dock_player)

	_wrench_player = AudioStreamPlayer.new()
	_wrench_player.name = "WrenchAudioPlayer"
	_wrench_player.stream = ProceduralAudio.create_drawer_lock_unlatch_sound()
	_wrench_player.volume_db = -8.0
	_wrench_player.bus = &"Master"
	add_child(_wrench_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return

	var beat_obs := GuidanceBeat.new()
	beat_obs.beat_id = &"s20_living_brother"
	beat_obs.scene_id = &"station_20"
	beat_obs.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_obs.thought_kind = &"observation"
	beat_obs.truth_scope = &"factual"
	beat_obs.text_pl = "Ciało żyje. Ma pracę, zmęczenie i własne granice."
	beat_obs.text_en = "The body is alive. He has work, fatigue, and his own boundaries."
	beat_obs.cooldown_s = 8.0
	guidance_service.register_beat(beat_obs)

	var beat_intent := GuidanceBeat.new()
	beat_intent.beat_id = &"s20_synthesize_sources"
	beat_intent.scene_id = &"station_20"
	beat_intent.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_intent.thought_kind = &"intention"
	beat_intent.truth_scope = &"procedural"
	beat_intent.text_pl = "Zestawię trzy źródła dowodów na stole pomiarowym."
	beat_intent.text_en = "I will synthesize the three sources of evidence on the measurement table."
	beat_intent.cooldown_s = 8.0
	beat_intent.supersedes = &"s20_living_brother"
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
		"jakub_presence":
			start_meeting_dialogue()
		"marta_presence":
			start_meeting_dialogue()
		"diagnostic_dock":
			dock_reader()
		"parts_trolley":
			start_meeting_dialogue()
		"workbench":
			dock_reader()
	clue_inspected.emit(id, prop_type)


func observe_scar() -> void:
	is_scar_refused = true
	scar_requested.emit()


func request_scar() -> void:
	observe_scar()


func start_jakub_dialogue() -> void:
	start_meeting_dialogue()


func advance_jakub_dialogue() -> void:
	advance_meeting_dialogue()


func start_meeting_dialogue() -> void:
	if is_dialogue_completed or is_dialogue_active:
		return
	is_dialogue_active = true
	dialogue_index = 0
	if _wrench_player:
		_wrench_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.7)
	if dialogue_box:
		dialogue_box.show_line(
			meeting_dialogue_lines[0]["speaker"],
			meeting_dialogue_lines[0]["text"]
		)
	jakub_dialogue_started.emit()


func advance_meeting_dialogue() -> void:
	if not is_dialogue_active:
		return
	dialogue_index += 1
	if dialogue_index < meeting_dialogue_lines.size():
		if dialogue_box:
			dialogue_box.show_line(
				meeting_dialogue_lines[dialogue_index]["speaker"],
				meeting_dialogue_lines[dialogue_index]["text"]
			)
		if dialogue_index == 4:
			is_scar_refused = true
			scar_requested.emit()
		elif dialogue_index == 5:
			dock_reader()
		jakub_dialogue_advanced.emit(dialogue_index)
	else:
		is_dialogue_active = false
		is_dialogue_completed = true
		if dialogue_box:
			dialogue_box.hide_box()
		var state := get_node_or_null("/root/GameStateManager")
		if state:
			state.record_decision(&"jakub_met_as_person", true)
			state.record_decision(&"recognition_evidence_carried", true)
			state.record_decision(&"recognition_evidence_relational", true)
		if guidance_service:
			guidance_service.report_progress(&"meeting_completed")
			guidance_service.trigger_beat(&"s20_living_brother")
			guidance_service.trigger_beat(&"s20_synthesize_sources")
		jakub_dialogue_completed.emit()


func dock_reader() -> void:
	if is_reader_diagnosed:
		return
	is_reader_diagnosed = true
	if _dock_player:
		_dock_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"interact", 0.6)
	reader_diagnosed.emit()


func apply_boundary_setback() -> void:
	boundary_setback_count += 1
	jakub_stepped_back = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_20_boundary_violated", boundary_setback_count)
	if guidance_service:
		guidance_service.report_failed_attempt(&"boundary_violated")
	if player:
		player.reset_to(Vector2(60.0, 296.0))
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if is_dialogue_active and (event.is_action_pressed(&"interact") or event.is_action_pressed(&"jump")):
		advance_meeting_dialogue()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed(&"restart"):
		apply_boundary_setback()
		get_viewport().set_input_as_handled()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_dialogue_completed and is_reader_diagnosed:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	var jakub_col := VectorStageStyle.ANCHOR_CYAN if is_dialogue_completed else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(320.0, 230.0), Vector2(320.0, 296.0), jakub_col, 2.0)

	var marta_col := VectorStageStyle.ANCHOR_CYAN if is_dialogue_completed else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.6)
	draw_line(Vector2(260.0, 240.0), Vector2(260.0, 296.0), marta_col, 2.0)

	var dock_col := VectorStageStyle.ANCHOR_CYAN if is_reader_diagnosed else VectorStageStyle.SEAM_RED
	draw_rect(Rect2(Vector2(420.0, 240.0), Vector2(30.0, 30.0)), dock_col, false, 1.0)

	var exit_col := VectorStageStyle.ANCHOR_CYAN if (is_dialogue_completed and is_reader_diagnosed) else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_col, 2.0)
