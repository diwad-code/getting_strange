class_name Station21
extends Node2D

## Station 21 (Przestrzeń 21: Trzy źródła / Rozpoznanie) — Kanon 0.3
## Zgodny z docs/narrative/FULL_STORY.md (21), DIALOGUE_SCRIPT.md (Station 21 — synteza),
## docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md oraz docs/PIXEL_PRESENTATION_ARCHITECTURE.md.
##
## Cel: wybrać model, który wyjaśnia wszystkie fakty najmniejszą liczbą wyjątków.
## Przeszkoda: każda prostsza hipoteza wyjaśnia tylko część dowodów.
## Działanie: gracz układa trzy rodziny dowodów (czytnik/próbka, rejestry publiczne, Jakub).
## Pokaż: rezonans próbki odpowiada węzłowi UCP, ale jej numer i historia pozostają obce.
## Zmiana: Lena mówi: „To nie jest mój świat.” Marta pyta: „Więc gdzie jest ona?”

## PRZESZKODA — dlaczego to tu jest: Stół warsztatowy ma trzy wydzielone pola pomiarowe; synteza wymaga ułożenia trzech niezależnych rodzin dowodów we właściwych gniazdach.
## PRZESZKODA — czego wymaga od Leny: ułożenia próbki z czytnikiem, dokumentów publicznych oraz odczytu serwisowego Jakuba, a następnie wyciągnięcia jedynego logicznego wniosku.
## PRZESZKODA — koszt porażki: próba syntezy przed skompletowaniem trzech źródeł kończy się brakiem zbieżności i koniecznością ponownego ułożenia materiałów; koszt zapisany w rejestrze decyzji.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)

signal clue_inspected(id: String, prop_type: int)
signal reader_evidence_placed()
signal public_evidence_placed()
signal relational_evidence_placed()
signal synthesis_executed()
signal recognition_spoken()
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

var synthesis_dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "LENA",
		"text": "Ten czytnik nie istnieje tutaj.",
		"is_lena": true,
	},
	{
		"speaker": "JAKUB",
		"text": "A lokalny test zaczął się w tej samej sekundzie.",
		"is_lena": false,
		"is_jakub": true,
	},
	{
		"speaker": "MARTA",
		"text": "Jej test. Nie twój.",
		"is_lena": false,
		"is_marta": true,
	},
	{
		"speaker": "LENA",
		"text": "To nie jest mój świat.",
		"is_lena": true,
	},
	{
		"speaker": "MARTA",
		"text": "Więc gdzie jest ona?",
		"is_lena": false,
		"is_marta": true,
	},
	{
		"speaker": "LENA",
		"text": "Nie wiem.",
		"is_lena": true,
	},
]

var reader_evidence_ready: bool = false
var public_evidence_ready: bool = false
var relational_evidence_ready: bool = false
var is_synthesis_complete: bool = false
var is_dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false
var is_world_recognized: bool = false
var is_level_completed: bool = false

var synthesis_setback_count: int = 0
var synthesis_reset: bool = false
var _pulse_time: float = 0.0

var _slot_player: AudioStreamPlayer
var _synthesis_player: AudioStreamPlayer


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
	_slot_player = AudioStreamPlayer.new()
	_slot_player.name = "SlotAudioPlayer"
	_slot_player.stream = ProceduralAudio.create_drawer_lock_unlatch_sound()
	_slot_player.volume_db = -8.0
	_slot_player.bus = &"Master"
	add_child(_slot_player)

	_synthesis_player = AudioStreamPlayer.new()
	_synthesis_player.name = "SynthesisAudioPlayer"
	_synthesis_player.stream = ProceduralAudio.create_drafting_lamp_hum_sound()
	_synthesis_player.volume_db = -10.0
	_synthesis_player.bus = &"Master"
	add_child(_synthesis_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return

	var beat_obs := GuidanceBeat.new()
	beat_obs.beat_id = &"s21_three_sources"
	beat_obs.scene_id = &"station_21"
	beat_obs.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_obs.thought_kind = &"observation"
	beat_obs.truth_scope = &"factual"
	beat_obs.text_pl = "Trzy niezależne rodziny dowodów."
	beat_obs.text_en = "Three independent families of evidence."
	beat_obs.cooldown_s = 8.0
	guidance_service.register_beat(beat_obs)

	var beat_hyp := GuidanceBeat.new()
	beat_hyp.beat_id = &"s21_single_world_impossibility"
	beat_hyp.scene_id = &"station_21"
	beat_hyp.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_hyp.thought_kind = &"interpretation"
	beat_hyp.truth_scope = &"fallible"
	beat_hyp.text_pl = "Żaden pojedynczy błąd w jednym świecie nie tłumaczy wszystkich trzech źródeł."
	beat_hyp.text_en = "No single mistake in one world explains all three sources."
	beat_hyp.cooldown_s = 8.0
	beat_hyp.hypothesis_id = &"hyp_single_world_error"
	beat_hyp.predicted_check = "synthesize_three_families"
	beat_hyp.supersedes = &"s21_three_sources"
	guidance_service.register_beat(beat_hyp)

	var beat_intent := GuidanceBeat.new()
	beat_intent.beat_id = &"s21_recognition_truth"
	beat_intent.scene_id = &"station_21"
	beat_intent.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_intent.thought_kind = &"intention"
	beat_intent.truth_scope = &"procedural"
	beat_intent.text_pl = "To nie jest mój świat. Muszę odnaleźć miejscową Lenę."
	beat_intent.text_en = "This is not my world. I must find the local Lena."
	beat_intent.cooldown_s = 8.0
	beat_intent.supersedes = &"s21_single_world_impossibility"
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
		"slot_reader_sample":
			place_reader_evidence()
		"slot_public_records":
			place_public_evidence()
		"slot_relational_evidence":
			place_relational_evidence()
		"synthesis_table":
			execute_synthesis()
		"airlock_corridor":
			execute_synthesis()
	clue_inspected.emit(id, prop_type)


func place_reader_evidence() -> void:
	if reader_evidence_ready:
		return
	reader_evidence_ready = true
	if _slot_player:
		_slot_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.7)
	reader_evidence_placed.emit()
	_check_synthesis_readiness()


func place_sample_reader() -> void:
	place_reader_evidence()


func place_public_evidence() -> void:
	if public_evidence_ready:
		return
	public_evidence_ready = true
	if _slot_player:
		_slot_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.7)
	public_evidence_placed.emit()
	_check_synthesis_readiness()


func place_public_records() -> void:
	place_public_evidence()


func place_relational_evidence() -> void:
	if relational_evidence_ready:
		return
	relational_evidence_ready = true
	if _slot_player:
		_slot_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.7)
	relational_evidence_placed.emit()
	_check_synthesis_readiness()


func _check_synthesis_readiness() -> void:
	if reader_evidence_ready and public_evidence_ready and relational_evidence_ready:
		execute_synthesis()


func synthesize_evidence() -> void:
	execute_synthesis()


func start_recognition_dialogue() -> void:
	if not is_dialogue_active:
		execute_synthesis()


func execute_synthesis() -> void:
	if is_synthesis_complete or is_dialogue_active:
		return
	if not (reader_evidence_ready and public_evidence_ready and relational_evidence_ready):
		apply_synthesis_setback()
		return
	is_synthesis_complete = true
	is_dialogue_active = true
	dialogue_index = 0
	if _synthesis_player:
		_synthesis_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"seam_gesture", 0.9)
	if dialogue_box:
		dialogue_box.show_line(
			synthesis_dialogue_lines[0]["speaker"],
			synthesis_dialogue_lines[0]["text"]
		)
	synthesis_executed.emit()


func advance_synthesis_dialogue() -> void:
	if not is_dialogue_active:
		return
	dialogue_index += 1
	if dialogue_index < synthesis_dialogue_lines.size():
		if dialogue_box:
			dialogue_box.show_line(
				synthesis_dialogue_lines[dialogue_index]["speaker"],
				synthesis_dialogue_lines[dialogue_index]["text"]
			)
		if dialogue_index == 3:
			is_world_recognized = true
			recognition_spoken.emit()
	else:
		is_dialogue_active = false
		is_dialogue_completed = true
		if dialogue_box:
			dialogue_box.hide_box()
		var state := get_node_or_null("/root/GameStateManager")
		if state:
			state.record_decision(&"world_recognized", true)
			state.record_decision(&"local_lena_search_committed", true)
			state.record_decision(&"local_lena_search_started", true)
		if guidance_service:
			guidance_service.close_hypothesis(&"hyp_conflicting_records")
			guidance_service.close_hypothesis(&"hyp_memory_gap")
			guidance_service.close_hypothesis(&"hyp_ucp_forgery")
			guidance_service.close_hypothesis(&"hyp_single_world_error")
			guidance_service.report_progress(&"synthesis_completed")
			guidance_service.trigger_beat(&"s21_recognition_truth")


func apply_synthesis_setback() -> void:
	synthesis_setback_count += 1
	synthesis_reset = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_21_incomplete_synthesis", synthesis_setback_count)
	if guidance_service:
		guidance_service.report_failed_attempt(&"incomplete_synthesis")
	if player:
		player.reset_to(Vector2(60.0, 296.0))
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if is_dialogue_active and (event.is_action_pressed(&"interact") or event.is_action_pressed(&"jump")):
		advance_synthesis_dialogue()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed(&"restart"):
		apply_synthesis_setback()
		get_viewport().set_input_as_handled()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_world_recognized and is_dialogue_completed:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	var s1_col := VectorStageStyle.ANCHOR_CYAN if reader_evidence_ready else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(Vector2(160.0, 240.0), Vector2(28.0, 24.0)), s1_col, false, 1.0)

	var s2_col := VectorStageStyle.ANCHOR_CYAN if public_evidence_ready else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(Vector2(260.0, 240.0), Vector2(28.0, 24.0)), s2_col, false, 1.0)

	var s3_col := VectorStageStyle.ANCHOR_CYAN if relational_evidence_ready else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(Vector2(360.0, 240.0), Vector2(28.0, 24.0)), s3_col, false, 1.0)

	var table_col := VectorStageStyle.ANCHOR_CYAN if is_world_recognized else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.6)
	draw_line(Vector2(140.0, 280.0), Vector2(410.0, 280.0), table_col, 2.0)

	var exit_col := VectorStageStyle.ANCHOR_CYAN if (is_world_recognized and is_dialogue_completed) else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_col, 2.0)
