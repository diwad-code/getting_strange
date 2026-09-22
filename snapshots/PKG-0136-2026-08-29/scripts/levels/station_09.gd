class_name Station09
extends Node2D

## Station 09 (Przestrzeń 09: Sąsiadka z trzeciego) — Kanon 0.3
## Zgodny z docs/narrative/FULL_STORY.md (09 Znajoma sąsiadka), DIALOGUE_SCRIPT.md,
## docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md oraz docs/PIXEL_PRESENTATION_ARCHITECTURE.md.
##
## Cel: ustalić, czy numerację w klatce zmieniono.
## Przeszkoda: klatka jest znajoma, ale w miejscu gaśnicy stoi ciężka donica, a sąsiadka wita Lenę bez wahania.
## Działanie: Lena pyta o numer 12 i nie podaje własnej teorii.
## Pokaż: sąsiadka odpowiada spokojnie, że dwunastka jest piętro niżej, a Lena mieszka pod czternastką od roku.
## Zmiana: trzy lokalne źródła zgadzają się ze sobą i nie zgadzają z pamięcią Leny.

## PRZESZKODA — dlaczego to tu jest: Donica z fikusem stoi w świetle biegu schodów, bo lokatorzy przestawili ją po wymianie gaśnicy i nikt jej nie odniósł.
## PRZESZKODA — czego wymaga od Leny: przepchnięcia ciężkiej donicy do wnęki przy oknie i zostawienia wolnego przejścia dla sąsiadki z zakupami.
## PRZESZKODA — koszt porażki: zbyt szybkie wejście przewraca donicę z powrotem na stopień, a ziemia zakrywa tabliczkę z numerem piętra.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)
const PLANTER_CLEAR_X := 300.0

signal clue_inspected(id: String, prop_type: int)
signal neighbour_dialogue_started()
signal neighbour_dialogue_advanced(line_idx: int)
signal neighbour_dialogue_completed()
signal passage_cleared()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var stairwell_planter: MovableAnchorableProp = $Geometry/StairwellPlanter
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var dialogue_box: CRTDialogueBox = $CRTDialogueBox

## Kanon 0.3: sąsiadka zachowuje się zwyczajnie. Żadnego wieszczenia, żadnej groźby.
var neighbour_dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "SĄSIADKA",
		"text": "Dobry wieczór, Lena.",
		"is_lena": false,
	},
	{
		"speaker": "LENA",
		"text": "Dobry wieczór. Szukam dwunastki.",
		"is_lena": true,
	},
	{
		"speaker": "SĄSIADKA",
		"text": "Dwunastka jest piętro niżej. Pani mieszka pod czternastką.",
		"is_lena": false,
	},
	{
		"speaker": "LENA",
		"text": "Od kiedy?",
		"is_lena": true,
	},
	{
		"speaker": "SĄSIADKA",
		"text": "Od roku, chyba. Pomagałam pani wnosić regał.",
		"is_lena": false,
	},
	{
		"speaker": "ŚWIADECTWO CIAŁA",
		"text": "Lena kiwa głową o pół sekundy za późno i nie prostuje sąsiadki.",
		"is_lena": true,
		"is_stage_direction": true,
	},
]

var floor_plate_read: bool = false
var extinguisher_bracket_read: bool = false
var neighbour_dialogue_active: bool = false
var neighbour_dialogue_index: int = -1
var is_neighbour_dialogue_completed: bool = false
var is_passage_clear: bool = false
var is_level_completed: bool = false

var planter_setback_count: int = 0
var floor_plate_soiled: bool = false

var _pulse_time: float = 0.0

var _blip_player: AudioStreamPlayer
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
	_blip_player = AudioStreamPlayer.new()
	_blip_player.name = "BlipAudioPlayer"
	_blip_player.stream = ProceduralAudio.create_dialogue_blip_sound(false)
	_blip_player.volume_db = -6.0
	_blip_player.bus = &"Master"
	add_child(_blip_player)

	_step_player = AudioStreamPlayer.new()
	_step_player.name = "StairAudioPlayer"
	_step_player.stream = ProceduralAudio.create_stair_footstep_sound()
	_step_player.volume_db = -10.0
	_step_player.bus = &"Master"
	add_child(_step_player)

	_scrape_player = AudioStreamPlayer.new()
	_scrape_player.name = "PlanterAudioPlayer"
	_scrape_player.stream = ProceduralAudio.create_masonry_smooth_sound()
	_scrape_player.volume_db = -9.0
	_scrape_player.bus = &"Master"
	add_child(_scrape_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return

	var beat_obs := GuidanceBeat.new()
	beat_obs.beat_id = &"s09_three_sources_agree"
	beat_obs.scene_id = &"station_09"
	beat_obs.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_obs.thought_kind = &"observation"
	beat_obs.truth_scope = &"factual"
	beat_obs.text_pl = "Zna moje imię. Nie zgadza się tylko numer."
	beat_obs.text_en = "She knows my name. Only the number disagrees."
	beat_obs.cooldown_s = 8.0
	guidance_service.register_beat(beat_obs)

	var beat_hyp := GuidanceBeat.new()
	beat_hyp.beat_id = &"s09_neighbour_mixes_floors"
	beat_hyp.scene_id = &"station_09"
	beat_hyp.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_hyp.thought_kind = &"interpretation"
	beat_hyp.truth_scope = &"fallible"
	beat_hyp.text_pl = "Myli piętra. Ludzie mylą piętra."
	beat_hyp.text_en = "She mixes up floors. People do."
	beat_hyp.cooldown_s = 8.0
	beat_hyp.hypothesis_id = &"hyp_neighbor_confusion"
	beat_hyp.predicted_check = "check_floor_plate_and_lock"
	beat_hyp.supersedes = &"s09_three_sources_agree"
	guidance_service.register_beat(beat_hyp)

	var beat_intent := GuidanceBeat.new()
	beat_intent.beat_id = &"s09_check_the_lock"
	beat_intent.scene_id = &"station_09"
	beat_intent.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_intent.thought_kind = &"intention"
	beat_intent.truth_scope = &"procedural"
	beat_intent.text_pl = "Sprawdzę zamek. Nie wejdę od razu."
	beat_intent.text_en = "I will try the lock. I will not walk straight in."
	beat_intent.cooldown_s = 8.0
	beat_intent.supersedes = &"s09_neighbour_mixes_floors"
	guidance_service.register_beat(beat_intent)


func _connect_props() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var prop := child as MemoryResonancePoint
			prop.resonance_triggered.connect(_on_prop_resonance_triggered.bind(prop))


func _physics_process(_delta: float) -> void:
	if is_instance_valid(player) and is_instance_valid(stairwell_planter) and not stairwell_planter.is_anchored:
		var diff := stairwell_planter.global_position - player.global_position
		var horizontal_dist := absf(diff.x)
		var vertical_overlap := absf(diff.y) < (stairwell_planter.crate_size.y * 0.5 + 40.0)
		if horizontal_dist < 42.0 and vertical_overlap:
			var push_dir := signf(player.velocity.x)
			if push_dir > 0.0 and signf(diff.x) == push_dir:
				stairwell_planter.receive_push(push_dir)


func _process(delta: float) -> void:
	_pulse_time += delta * 2.0
	if not is_passage_clear and stairwell_planter and stairwell_planter.position.x >= PLANTER_CLEAR_X:
		is_passage_clear = true
		if _scrape_player:
			_scrape_player.play()
		if guidance_service:
			guidance_service.report_progress(&"passage_cleared")
		passage_cleared.emit()
	queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	prop.is_activated = true
	match id:
		"neighbour_dialogue":
			if not is_neighbour_dialogue_completed:
				if not neighbour_dialogue_active:
					start_neighbour_dialogue()
				else:
					advance_neighbour_dialogue()
		"floor_plate":
			floor_plate_read = true
			if _step_player:
				_step_player.play()
			if player and player.has_method("play_visual_cue"):
				player.play_visual_cue(&"examine", 0.7)
			if guidance_service:
				guidance_service.trigger_beat(&"s09_three_sources_agree")
		"extinguisher_bracket":
			extinguisher_bracket_read = true
			if player and player.has_method("play_visual_cue"):
				player.play_visual_cue(&"examine", 0.6)
	clue_inspected.emit(id, prop_type)


func start_neighbour_dialogue() -> void:
	if is_neighbour_dialogue_completed or neighbour_dialogue_active:
		return
	neighbour_dialogue_active = true
	neighbour_dialogue_index = 0
	_play_dialogue_blip(false)
	if guidance_service:
		guidance_service.set_dialogue_active(true)
	neighbour_dialogue_started.emit()
	queue_redraw()


func advance_neighbour_dialogue() -> int:
	if not neighbour_dialogue_active:
		start_neighbour_dialogue()
		return neighbour_dialogue_index

	neighbour_dialogue_index += 1
	if neighbour_dialogue_index >= neighbour_dialogue_lines.size():
		neighbour_dialogue_active = false
		is_neighbour_dialogue_completed = true
		if guidance_service:
			guidance_service.set_dialogue_active(false)
			guidance_service.report_progress(&"neighbour_answered")
			guidance_service.trigger_beat(&"s09_neighbour_mixes_floors")
		neighbour_dialogue_completed.emit()
		queue_redraw()
		return -1

	var line: Dictionary = neighbour_dialogue_lines[neighbour_dialogue_index]
	_play_dialogue_blip(bool(line.get("is_lena", false)))
	if bool(line.get("is_stage_direction", false)) and player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"unease_reaction", 0.9)
	neighbour_dialogue_advanced.emit(neighbour_dialogue_index)
	queue_redraw()
	return neighbour_dialogue_index


func push_planter(direction: float) -> void:
	if stairwell_planter:
		stairwell_planter.receive_push(direction)


## Porażka to przestawiona donica i zabrudzona tabliczka, nigdy śmierć ani koniec sceny.
func apply_planter_setback() -> void:
	if is_passage_clear:
		return
	planter_setback_count += 1
	floor_plate_soiled = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_09_planter_reset", planter_setback_count)
	if guidance_service:
		guidance_service.report_failed_attempt(&"planter_tipped")
	if stairwell_planter:
		stairwell_planter.reset_to_spawn()
	if player:
		player.reset_to(Vector2(70.0, 296.0))
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"restart") and not is_passage_clear:
		apply_planter_setback()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed(&"interact") and neighbour_dialogue_active:
		advance_neighbour_dialogue()
		get_viewport().set_input_as_handled()


func _play_dialogue_blip(is_lena: bool) -> void:
	if _blip_player:
		_blip_player.stream = ProceduralAudio.create_dialogue_blip_sound(is_lena)
		_blip_player.play()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_neighbour_dialogue_completed:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	var plate_col := VectorStageStyle.ANCHOR_CYAN if floor_plate_read else VectorStageStyle.HUMAN_AMBER
	if floor_plate_soiled:
		plate_col = VectorStageStyle.shade(plate_col, 0.45)
	draw_rect(Rect2(Vector2(196.0, 196.0), Vector2(30.0, 16.0)), plate_col, false, 1.0)

	var bracket_col := VectorStageStyle.CORRECTION_OXIDE if extinguisher_bracket_read else VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.4)
	draw_rect(Rect2(Vector2(150.0, 236.0), Vector2(14.0, 26.0)), bracket_col, false, 1.0)

	var exit_col := VectorStageStyle.ANCHOR_CYAN if is_neighbour_dialogue_completed else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(566.0, 180.0), Vector2(566.0, 296.0), exit_col, 2.0)
