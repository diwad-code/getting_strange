class_name Station15
extends Node2D

## Station 15 (Przestrzeń 15: Ta sama wyprawa, inny skutek) — Kanon 0.3
## Zgodny z docs/narrative/FULL_STORY.md (15), DIALOGUE_SCRIPT.md (Station 15 — wspólna wyprawa),
## docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md oraz docs/PIXEL_PRESENTATION_ARCHITECTURE.md.
##
## Cel: sprawdzić pamięć bez pytań, na które odpowiedź można odgadnąć.
## Przeszkoda: obie pamiętają tę samą wyprawę terenową, lecz w domu Leny zakończyła współpracę, a w Równi rozpoczęła związek.
## Działanie: gracz wybiera konkret (pogoda, uszkodzone ogrodzenie, zdanie po powrocie); każda odpowiedź odsłania inną spójną historię.
## Pokaż: Marta nie zostaje przekonana dialogiem. Chce wezwać lekarza i zabezpieczyć telefon miejscowej Leny.
## Zmiana: Lena odbiera zabezpieczenie telefonu jako próbę odebrania sprawczości i idzie do biura pomiarowego.

## PRZESZKODA — dlaczego to tu jest: Kuchenny blat i wąskie przejście między stołem a szafką są zablokowane przez otwarty laptop i apteczkę przygotowaną przez Martę.
## PRZESZKODA — czego wymaga od Leny: wskazania konkretnych faktów z wyprawy (ogrodzenie, deszcz, klucze) i spokojnego ominięcia stołu bez dotykania zabezpieczanego telefonu.
## PRZESZKODA — koszt porażki: próba sięgnięcia po telefon siłą powoduje schowanie go przez Martę do kieszeni; strata zaufania zapisana w rejestrze decyzji.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)

signal clue_inspected(id: String, prop_type: int)
signal weather_compared()
signal fence_compared()
signal expedition_dialogue_started()
signal expedition_dialogue_advanced(step: int)
signal expedition_dialogue_completed()
signal phone_secured()
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

var expedition_dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "MARTA",
		"text": "Po deszczu wróciłyśmy tutaj. Zostawiłaś kurtkę na kaloryferze.",
		"is_lena": false,
		"is_marta": true,
	},
	{
		"speaker": "LENA",
		"text": "Nie wróciłyśmy.",
		"is_lena": true,
		"is_marta": false,
	},
	{
		"speaker": "MARTA",
		"text": "Co?",
		"is_lena": false,
		"is_marta": true,
	},
	{
		"speaker": "LENA",
		"text": "Pokłóciłyśmy się na parkingu. Potem już nie pracowałyśmy razem.",
		"is_lena": true,
		"is_marta": false,
	},
	{
		"speaker": "MARTA",
		"text": "My wtedy zamieszkałyśmy razem.",
		"is_lena": false,
		"is_marta": true,
	},
	{
		"speaker": "LENA",
		"text": "Marta...",
		"is_lena": true,
		"is_marta": false,
	},
	{
		"speaker": "MARTA",
		"text": "Nie. Teraz ty posłuchaj. Zostaw telefon na stole i nigdzie nie wychodź.",
		"is_lena": false,
		"is_marta": true,
	},
]

var weather_detail_checked: bool = false
var fence_detail_checked: bool = false
var are_details_compared: bool = false
var is_dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false
var is_phone_secured_by_marta: bool = false
var is_level_completed: bool = false

var table_setback_count: int = 0
var phone_pocketed: bool = false
var _pulse_time: float = 0.0

var _paper_player: AudioStreamPlayer
var _cloth_player: AudioStreamPlayer


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
	_paper_player = AudioStreamPlayer.new()
	_paper_player.name = "PaperAudioPlayer"
	_paper_player.stream = ProceduralAudio.create_dossier_paper_turn_sound()
	_paper_player.volume_db = -8.0
	_paper_player.bus = &"Master"
	add_child(_paper_player)

	_cloth_player = AudioStreamPlayer.new()
	_cloth_player.name = "ClothAudioPlayer"
	_cloth_player.stream = ProceduralAudio.create_drawer_lock_unlatch_sound()
	_cloth_player.volume_db = -12.0
	_cloth_player.bus = &"Master"
	add_child(_cloth_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return

	var beat_obs := GuidanceBeat.new()
	beat_obs.beat_id = &"s15_diverging_trip"
	beat_obs.scene_id = &"station_15"
	beat_obs.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_obs.thought_kind = &"observation"
	beat_obs.truth_scope = &"factual"
	beat_obs.text_pl = "Jedna wyprawa. Dwie różne wersje tego, co stało się po deszczu."
	beat_obs.text_en = "One expedition. Two different versions of what happened after the rain."
	beat_obs.cooldown_s = 8.0
	guidance_service.register_beat(beat_obs)

	var beat_hyp := GuidanceBeat.new()
	beat_hyp.beat_id = &"s15_rehearsed_story"
	beat_hyp.scene_id = &"station_15"
	beat_hyp.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_hyp.thought_kind = &"interpretation"
	beat_hyp.truth_scope = &"fallible"
	beat_hyp.text_pl = "Marta mogła ułożyć tę historię po latach opowiadań."
	beat_hyp.text_en = "Marta might have shaped this story over years of retellings."
	beat_hyp.cooldown_s = 8.0
	beat_hyp.hypothesis_id = &"hyp_rehearsed_memory"
	beat_hyp.predicted_check = "verify_official_work_logs"
	beat_hyp.supersedes = &"s15_diverging_trip"
	guidance_service.register_beat(beat_hyp)

	var beat_intent := GuidanceBeat.new()
	beat_intent.beat_id = &"s15_go_to_office"
	beat_intent.scene_id = &"station_15"
	beat_intent.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_intent.thought_kind = &"intention"
	beat_intent.truth_scope = &"procedural"
	beat_intent.text_pl = "Sprawdzę oficjalny grafik w biurze pomiarowym."
	beat_intent.text_en = "I will check the official duty roster at the measurement office."
	beat_intent.cooldown_s = 8.0
	beat_intent.supersedes = &"s15_rehearsed_story"
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
		"expedition_notes":
			compare_weather_detail()
		"kitchen_table":
			compare_fence_detail()
		"marta_dialogue":
			start_expedition_dialogue()
		"counter_cloth":
			start_expedition_dialogue()
		"first_aid_kit":
			secure_phone()
	clue_inspected.emit(id, prop_type)


func compare_weather_detail() -> void:
	if weather_detail_checked:
		return
	weather_detail_checked = true
	if _paper_player:
		_paper_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.7)
	_check_details()
	weather_compared.emit()


func compare_weather() -> void:
	compare_weather_detail()


func inspect_notebook() -> void:
	compare_weather_detail()


func compare_fence_detail() -> void:
	if fence_detail_checked:
		return
	fence_detail_checked = true
	if _cloth_player:
		_cloth_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.7)
	_check_details()
	fence_compared.emit()


func compare_fence() -> void:
	compare_fence_detail()


func examine_fence() -> void:
	compare_fence_detail()


func secure_phone() -> void:
	is_phone_secured_by_marta = true
	phone_secured.emit()


func _check_details() -> void:
	if are_details_compared:
		return
	if weather_detail_checked and fence_detail_checked:
		are_details_compared = true
		if guidance_service:
			guidance_service.trigger_beat(&"s15_diverging_trip")


func start_divergence_dialogue() -> void:
	start_expedition_dialogue()


func start_expedition_dialogue() -> void:
	if is_dialogue_completed:
		return
	is_dialogue_active = true
	dialogue_index = 0
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"unease_reaction", 0.8)
	if dialogue_box:
		dialogue_box.show_line(
			expedition_dialogue_lines[0]["speaker"],
			expedition_dialogue_lines[0]["text"]
		)
	if guidance_service:
		guidance_service.trigger_beat(&"s15_rehearsed_story")
	expedition_dialogue_started.emit()


func advance_expedition_dialogue() -> void:
	if not is_dialogue_active:
		return
	dialogue_index += 1
	if dialogue_index < expedition_dialogue_lines.size():
		if dialogue_box:
			dialogue_box.show_line(
				expedition_dialogue_lines[dialogue_index]["speaker"],
				expedition_dialogue_lines[dialogue_index]["text"]
			)
		expedition_dialogue_advanced.emit(dialogue_index)
	else:
		is_dialogue_active = false
		is_dialogue_completed = true
		is_phone_secured_by_marta = true
		if dialogue_box:
			dialogue_box.hide_box()
		var state := get_node_or_null("/root/GameStateManager")
		if state:
			state.record_decision(&"marta_memories_conflict", true)
		if guidance_service:
			guidance_service.report_progress(&"expedition_dialogue_completed")
			guidance_service.trigger_beat(&"s15_go_to_office")
		expedition_dialogue_completed.emit()


func apply_table_setback() -> void:
	table_setback_count += 1
	phone_pocketed = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_15_table_rushed", table_setback_count)
	if guidance_service:
		guidance_service.report_failed_attempt(&"table_rushed")
	if player:
		player.reset_to(Vector2(60.0, 296.0))
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if is_dialogue_active and (event.is_action_pressed(&"interact") or event.is_action_pressed(&"jump")):
		advance_expedition_dialogue()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed(&"restart"):
		apply_table_setback()
		get_viewport().set_input_as_handled()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_dialogue_completed:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	var notes_col := VectorStageStyle.ANCHOR_CYAN if weather_detail_checked else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(Vector2(140.0, 270.0), Vector2(28.0, 20.0)), notes_col, false, 1.0)

	var table_col := VectorStageStyle.ANCHOR_CYAN if fence_detail_checked else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.6)
	draw_rect(Rect2(Vector2(260.0, 260.0), Vector2(60.0, 30.0)), table_col, false, 1.0)

	var marta_col := VectorStageStyle.ANCHOR_CYAN if is_dialogue_completed else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(400.0, 230.0), Vector2(400.0, 296.0), marta_col, 2.0)

	var exit_col := VectorStageStyle.ANCHOR_CYAN if is_dialogue_completed else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_col, 2.0)
