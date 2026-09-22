class_name Station14
extends Node2D

## Station 14 (Przestrzeń 14: Próg Marty) — Kanon 0.3
## Zgodny z docs/narrative/FULL_STORY.md (14), DIALOGUE_SCRIPT.md (Station 14 — próg),
## docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md oraz docs/PIXEL_PRESENTATION_ARCHITECTURE.md.
##
## Cel: uzyskać od Marty niezależny opis dnia.
## Przeszkoda: Marta przychodzi do wspólnego domu i oczekuje partnerki. Lena zna ją dobrze, ale nie w ten sposób.
## Działanie: obie porównują godzinę, terenowy sprzęt i położenie klucza.
## Pokaż: Marta zatrzymuje gest powitania, gdy Lena cofa się o pół kroku. Zajmuje dłonie odkładaniem czajnika.
## Zmiana: Marta dopuszcza uraz, chorobę lub manipulację. Lena widzi, że pomyłka dotyczy relacji, nie tylko danych.

## PRZESZKODA — dlaczego to tu jest: Drzwi wejściowe i próg przedpokoju są zastawione suszarką na pranie i stojakiem na płaszcze, wymuszając zachowanie dystansu fizycznego między obiema kobietami.
## PRZESZKODA — czego wymaga od Leny: odłożenia torby przy ścianie i spokojnego przejścia do stołu bez gwałtownego zbliżania się do Marty.
## PRZESZKODA — koszt porażki: pośpiech przewraca stojak, tłucze kubek i zamyka możliwość spokojnej rozmowy; koszt zapisany w rejestrze decyzji.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)

signal clue_inspected(id: String, prop_type: int)
signal bag_placed()
signal marta_dialogue_started()
signal marta_dialogue_advanced(step: int)
signal marta_dialogue_completed()
signal kettle_inspected()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var dialogue_box: CRTDialogueBox = $CRTDialogueBox

var marta_dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "MARTA",
		"text": "Odłóż torbę.",
		"is_lena": false,
		"is_marta": true,
	},
	{
		"speaker": "LENA",
		"text": "Zostanie przy drzwiach.",
		"is_lena": true,
		"is_marta": false,
	},
	{
		"speaker": "MARTA",
		"text": "Gdzie byłaś od rana?",
		"is_lena": false,
		"is_marta": true,
	},
	{
		"speaker": "LENA",
		"text": "Przy torach.",
		"is_lena": true,
		"is_marta": false,
	},
	{
		"speaker": "MARTA",
		"text": "Nie byłaś. Odwołałaś wyjazd.",
		"is_lena": false,
		"is_marta": true,
	},
	{
		"speaker": "LENA",
		"text": "Ja go wykonałam.",
		"is_lena": true,
		"is_marta": false,
	},
	{
		"speaker": "MARTA",
		"text": "Nie pytam o raport. Pytam, gdzie jest Lena.",
		"is_lena": false,
		"is_marta": true,
	},
]

var is_bag_placed: bool = false
var is_kettle_inspected: bool = false
var is_marta_dialogue_active: bool = false
var marta_dialogue_index: int = -1
var is_marta_dialogue_completed: bool = false
var is_level_completed: bool = false

var threshold_setback_count: int = 0
var mug_broken: bool = false
var _pulse_time: float = 0.0

var _kettle_player: AudioStreamPlayer
var _door_player: AudioStreamPlayer
var _cup_player: AudioStreamPlayer


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
	_kettle_player = AudioStreamPlayer.new()
	_kettle_player.name = "KettleAudioPlayer"
	_kettle_player.stream = ProceduralAudio.create_drafting_lamp_hum_sound()
	_kettle_player.volume_db = -18.0
	_kettle_player.bus = &"Master"
	add_child(_kettle_player)

	_door_player = AudioStreamPlayer.new()
	_door_player.name = "DoorAudioPlayer"
	_door_player.stream = ProceduralAudio.create_drawer_lock_unlatch_sound()
	_door_player.volume_db = -8.0
	_door_player.bus = &"Master"
	add_child(_door_player)

	_cup_player = AudioStreamPlayer.new()
	_cup_player.name = "CupAudioPlayer"
	_cup_player.stream = ProceduralAudio.create_dossier_paper_turn_sound()
	_cup_player.volume_db = -10.0
	_cup_player.bus = &"Master"
	add_child(_cup_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return

	var beat_obs := GuidanceBeat.new()
	beat_obs.beat_id = &"s14_marta_expects_partner"
	beat_obs.scene_id = &"station_14"
	beat_obs.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_obs.thought_kind = &"observation"
	beat_obs.truth_scope = &"factual"
	beat_obs.text_pl = "Marta czeka na partnerkę. Odkłada drugi kubek."
	beat_obs.text_en = "Marta expects her partner. She puts away the second mug."
	beat_obs.cooldown_s = 8.0
	guidance_service.register_beat(beat_obs)

	var beat_hyp := GuidanceBeat.new()
	beat_hyp.beat_id = &"s14_medical_fear"
	beat_hyp.scene_id = &"station_14"
	beat_hyp.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_hyp.thought_kind = &"interpretation"
	beat_hyp.truth_scope = &"fallible"
	beat_hyp.text_pl = "Marta uważa, że mam wstrząśnienie mózgu lub atak paniki."
	beat_hyp.text_en = "Marta thinks I have a concussion or panic attack."
	beat_hyp.cooldown_s = 8.0
	beat_hyp.hypothesis_id = &"hyp_medical_cause"
	beat_hyp.predicted_check = "test_shared_field_memory"
	beat_hyp.supersedes = &"s14_marta_expects_partner"
	guidance_service.register_beat(beat_hyp)

	var beat_intent := GuidanceBeat.new()
	beat_intent.beat_id = &"s14_ask_about_field_trip"
	beat_intent.scene_id = &"station_14"
	beat_intent.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_intent.thought_kind = &"intention"
	beat_intent.truth_scope = &"procedural"
	beat_intent.text_pl = "Zapytam o wyprawę terenową z października."
	beat_intent.text_en = "I will ask about the October field expedition."
	beat_intent.cooldown_s = 8.0
	beat_intent.supersedes = &"s14_medical_fear"
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
		"field_bag":
			place_bag_at_door()
		"door_threshold":
			place_bag_at_door()
		"marta_interaction":
			start_marta_dialogue()
		"tea_kettle":
			inspect_kettle()
		"mug_cabinet":
			inspect_kettle()
	clue_inspected.emit(id, prop_type)


func place_bag_at_door() -> void:
	if is_bag_placed:
		return
	is_bag_placed = true
	if _door_player:
		_door_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"interact", 0.6)
	if guidance_service:
		guidance_service.report_progress(&"bag_placed")
		guidance_service.trigger_beat(&"s14_marta_expects_partner")
	bag_placed.emit()


func inspect_kettle() -> void:
	if is_kettle_inspected:
		return
	is_kettle_inspected = true
	if _kettle_player:
		_kettle_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.7)
	kettle_inspected.emit()


func start_marta_dialogue() -> void:
	if is_marta_dialogue_completed:
		return
	is_marta_dialogue_active = true
	marta_dialogue_index = 0
	if _cup_player:
		_cup_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"unease_reaction", 0.8)
	if dialogue_box:
		dialogue_box.show_line(
			marta_dialogue_lines[0]["speaker"],
			marta_dialogue_lines[0]["text"]
		)
	if guidance_service:
		guidance_service.trigger_beat(&"s14_medical_fear")
	marta_dialogue_started.emit()


func advance_marta_dialogue() -> void:
	if not is_marta_dialogue_active:
		return
	marta_dialogue_index += 1
	if marta_dialogue_index < marta_dialogue_lines.size():
		if dialogue_box:
			dialogue_box.show_line(
				marta_dialogue_lines[marta_dialogue_index]["speaker"],
				marta_dialogue_lines[marta_dialogue_index]["text"]
			)
		marta_dialogue_advanced.emit(marta_dialogue_index)
	else:
		is_marta_dialogue_active = false
		is_marta_dialogue_completed = true
		if dialogue_box:
			dialogue_box.hide_box()
		var state := get_node_or_null("/root/GameStateManager")
		if state:
			state.record_decision(&"marta_relationship_disclosed", true)
		if guidance_service:
			guidance_service.report_progress(&"marta_dialogue_completed")
			guidance_service.trigger_beat(&"s14_ask_about_field_trip")
		marta_dialogue_completed.emit()


func apply_threshold_setback() -> void:
	threshold_setback_count += 1
	mug_broken = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_14_mug_broken", threshold_setback_count)
	if guidance_service:
		guidance_service.report_failed_attempt(&"threshold_rushed")
	if player:
		player.reset_to(Vector2(60.0, 296.0))
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if is_marta_dialogue_active and (event.is_action_pressed(&"interact") or event.is_action_pressed(&"jump")):
		advance_marta_dialogue()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed(&"restart"):
		apply_threshold_setback()
		get_viewport().set_input_as_handled()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_marta_dialogue_completed:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	var bag_col := VectorStageStyle.ANCHOR_CYAN if is_bag_placed else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(Vector2(110.0, 274.0), Vector2(24.0, 22.0)), bag_col, false, 1.0)

	var kettle_col := VectorStageStyle.ANCHOR_CYAN if is_kettle_inspected else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.6)
	draw_circle(Vector2(320.0, 260.0), 6.0, kettle_col)

	var marta_col := VectorStageStyle.ANCHOR_CYAN if is_marta_dialogue_completed else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(440.0, 240.0), Vector2(440.0, 296.0), marta_col, 2.0)

	if mug_broken:
		draw_line(Vector2(326.0, 294.0), Vector2(334.0, 298.0), VectorStageStyle.SEAM_RED, 1.0)

	var exit_col := VectorStageStyle.ANCHOR_CYAN if is_marta_dialogue_completed else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_col, 2.0)
