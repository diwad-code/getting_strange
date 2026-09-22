class_name Station23
extends Node2D

## Station 23 (Przestrzeń 23: Martwy obwód / Koszt mechaniki) — Kanon 0.3
## Zgodny z docs/narrative/FULL_STORY.md (23), DIALOGUE_SCRIPT.md,
## docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md oraz docs/PIXEL_PRESENTATION_ARCHITECTURE.md.
##
## Cel: zaobserwować koszt mechaniki w wyłączonym segmencie aparatury.
## Przeszkoda: martwy obwód nie ma zasilania; zakotwiczenie wywołuje opór termiczny i rezonans.
## Działanie: Lena podłącza czytnik, bocznikuje bezpiecznik i bada przeciążenie obwodu.
## Pokaż: zmiana stanu nie jest bezpłatna — wymaga stałego utrzymania sygnału.
## Zmiana: Lena rozumie, dlaczego miejscowa Lena nie mogła utrzymać obu stanów jednocześnie.

## PRZESZKODA — dlaczego to tu jest: Wyłączona sekcja podstacji jest odcięta bezpiecznikiem przeciążeniowym; uruchomienie węzła testowego wymaga zmostkowania obwodu bocznikującego.
## PRZESZKODA — czego wymaga od Leny: podłączenia czytnika do złącza diagnostycznego, przełączenia bezpiecznika bocznikującego i ustabilizowania przeciążenia termicznego.
## PRZESZKODA — koszt porażki: zbyt szybkie przełączenie bezpiecznika wyzwala zwarcie testowe i resetuje mostek bocznikujący; koszt zapisany w rejestrze decyzji.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)

signal clue_inspected(id: String, prop_type: int)
signal circuit_connected()
signal shunt_switched()
signal overload_stabilized()
signal mechanic_cost_understood()
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

var is_circuit_connected: bool = false
var is_shunt_switched: bool = false
var is_overload_stabilized: bool = false
var is_cost_understood: bool = false
var is_level_completed: bool = false

var circuit_setback_count: int = 0
var breaker_tripped: bool = false
var _pulse_time: float = 0.0

var _spark_player: AudioStreamPlayer
var _switch_player: AudioStreamPlayer


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
	_spark_player = AudioStreamPlayer.new()
	_spark_player.name = "SparkAudioPlayer"
	_spark_player.stream = ProceduralAudio.create_drafting_lamp_hum_sound()
	_spark_player.volume_db = -8.0
	_spark_player.bus = &"Master"
	add_child(_spark_player)

	_switch_player = AudioStreamPlayer.new()
	_switch_player.name = "SwitchAudioPlayer"
	_switch_player.stream = ProceduralAudio.create_drawer_lock_unlatch_sound()
	_switch_player.volume_db = -6.0
	_switch_player.bus = &"Master"
	add_child(_switch_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return

	var beat_obs := GuidanceBeat.new()
	beat_obs.beat_id = &"s23_circuit_cost"
	beat_obs.scene_id = &"station_23"
	beat_obs.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_obs.thought_kind = &"observation"
	beat_obs.truth_scope = &"factual"
	beat_obs.text_pl = "Zmiana stanu obciąża obwód. Zakotwiczenie ma swój fizyczny koszt."
	beat_obs.text_en = "State change loads the circuit. Anchoring has its physical cost."
	beat_obs.cooldown_s = 8.0
	guidance_service.register_beat(beat_obs)

	var beat_intent := GuidanceBeat.new()
	beat_intent.beat_id = &"s23_explore_substation"
	beat_intent.scene_id = &"station_23"
	beat_intent.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_intent.thought_kind = &"intention"
	beat_intent.truth_scope = &"procedural"
	beat_intent.text_pl = "Zejdę do głównej magistrali podstacji."
	beat_intent.text_en = "I will descend to the main substation trunk."
	beat_intent.cooldown_s = 8.0
	beat_intent.supersedes = &"s23_circuit_cost"
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
		"dead_circuit_port":
			connect_circuit()
		"shunt_fuse_switch":
			switch_shunt()
		"thermal_overload_gauge":
			stabilize_overload()
		"substation_junction":
			connect_circuit()
		"transformer_core":
			switch_shunt()
	clue_inspected.emit(id, prop_type)


func connect_circuit() -> void:
	if is_circuit_connected:
		return
	is_circuit_connected = true
	if _spark_player:
		_spark_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"interact", 0.6)
	circuit_connected.emit()
	_check_circuit()


func examine_circuit() -> void:
	connect_circuit()


func switch_shunt() -> void:
	if not is_circuit_connected:
		apply_circuit_setback()
		return
	if is_shunt_switched:
		return
	is_shunt_switched = true
	if _switch_player:
		_switch_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.7)
	shunt_switched.emit()
	_check_circuit()


func pull_shunt_switch() -> void:
	switch_shunt()


func start_circuit_dialogue() -> void:
	stabilize_overload()


func observe_thermal_load() -> void:
	stabilize_overload()


func stabilize_overload() -> void:
	if not (is_circuit_connected and is_shunt_switched):
		apply_circuit_setback()
		return
	if is_overload_stabilized:
		return
	is_overload_stabilized = true
	is_cost_understood = true
	if _spark_player:
		_spark_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"seam_gesture", 0.9)
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"mechanic_cost_observed", true)
	if guidance_service:
		guidance_service.report_progress(&"cost_understood")
		guidance_service.trigger_beat(&"s23_circuit_cost")
		guidance_service.trigger_beat(&"s23_explore_substation")
	overload_stabilized.emit()
	mechanic_cost_understood.emit()
	_check_circuit()


func _check_circuit() -> void:
	queue_redraw()


func apply_circuit_setback() -> void:
	circuit_setback_count += 1
	breaker_tripped = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_23_breaker_tripped", circuit_setback_count)
	if guidance_service:
		guidance_service.report_failed_attempt(&"breaker_tripped")
	if player:
		player.reset_to(Vector2(60.0, 296.0))
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"restart"):
		apply_circuit_setback()
		get_viewport().set_input_as_handled()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_cost_understood:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	var c_col := VectorStageStyle.ANCHOR_CYAN if is_circuit_connected else VectorStageStyle.HUMAN_AMBER
	draw_circle(Vector2(160.0, 250.0), 7.0, c_col)

	var s_col := VectorStageStyle.ANCHOR_CYAN if is_shunt_switched else VectorStageStyle.SEAM_RED
	draw_rect(Rect2(Vector2(280.0, 240.0), Vector2(30.0, 30.0)), s_col, false, 1.0)

	var o_col := VectorStageStyle.ANCHOR_CYAN if is_overload_stabilized else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.6)
	draw_circle(Vector2(420.0, 250.0), 8.0, o_col)

	var exit_col := VectorStageStyle.ANCHOR_CYAN if is_cost_understood else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_col, 2.0)
