class_name Station16
extends Node2D

## Station 16 (Przestrzeń 16: Zespół UCP-4) — Kanon 0.3
## Zgodny z docs/narrative/FULL_STORY.md (16), DIALOGUE_SCRIPT.md,
## docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md oraz docs/PIXEL_PRESENTATION_ARCHITECTURE.md.
##
## Cel: wejść do biura pomiarowego i odczytać historię logowań.
## Przeszkoda: domowa karta Leny ma obcy numer, ale biometria rozpoznaje jej ciało i przypisuje ją do zespołu UCP-4.
## Działanie: gracz porównuje numer karty, profil biometryczny, 186 dni aktywności i grafik dzisiejszej próby.
## Pokaż: nazwisko Wierzbickiej widnieje przy zatwierdzeniu testu o 20:40.
## Zmiana: manipulacja jednego konta nie tłumaczy historii biometrycznej i fizycznego grafiku.

## PRZESZKODA — dlaczego to tu jest: Bramka biometryczna i kołowrót serwisowy wymagają sekwencyjnego skanu dłoni oraz potwierdzenia numeru stanowiska w terminalu.
## PRZESZKODA — czego wymaga od Leny: przyłożenia dłoni do skanera biometrycznego, porównania niezgodnego numeru karty i przejścia przez zwolniony kołowrót.
## PRZESZKODA — koszt porażki: trzykrotne użycie domowej karty blokuje czytnik kart i zmusza do użycia powolnego terminala zapasowego; koszt zapisany w rejestrze decyzji.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)

signal clue_inspected(id: String, prop_type: int)
signal biometrics_scanned()
signal card_scanned()
signal schedule_read()
signal turnstile_passed()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var dialogue_box: CRTDialogueBox = $CRTDialogueBox

var is_biometrics_scanned: bool = false
var is_card_scanned: bool = false
var is_schedule_read: bool = false
var is_turnstile_unlocked: bool = false
var is_level_completed: bool = false

var scanner_setback_count: int = 0
var reader_locked: bool = false
var _pulse_time: float = 0.0

var _scan_player: AudioStreamPlayer
var _door_player: AudioStreamPlayer


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
	_scan_player = AudioStreamPlayer.new()
	_scan_player.name = "ScanAudioPlayer"
	_scan_player.stream = ProceduralAudio.create_drafting_lamp_hum_sound()
	_scan_player.volume_db = -12.0
	_scan_player.bus = &"Master"
	add_child(_scan_player)

	_door_player = AudioStreamPlayer.new()
	_door_player.name = "DoorAudioPlayer"
	_door_player.stream = ProceduralAudio.create_drawer_lock_unlatch_sound()
	_door_player.volume_db = -8.0
	_door_player.bus = &"Master"
	add_child(_door_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return

	var beat_obs := GuidanceBeat.new()
	beat_obs.beat_id = &"s16_biometrics_match"
	beat_obs.scene_id = &"station_16"
	beat_obs.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_obs.thought_kind = &"observation"
	beat_obs.truth_scope = &"factual"
	beat_obs.text_pl = "Moja dłoń. Mój profil. Obcy numer karty."
	beat_obs.text_en = "My hand. My profile. Foreign card number."
	beat_obs.cooldown_s = 8.0
	guidance_service.register_beat(beat_obs)

	var beat_hyp := GuidanceBeat.new()
	beat_hyp.beat_id = &"s16_account_manipulation"
	beat_hyp.scene_id = &"station_16"
	beat_hyp.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_hyp.thought_kind = &"interpretation"
	beat_hyp.truth_scope = &"fallible"
	beat_hyp.text_pl = "Ktoś podmienił identyfikator karty w bazie UCP."
	beat_hyp.text_en = "Someone altered the card identifier in the UCP database."
	beat_hyp.cooldown_s = 8.0
	beat_hyp.hypothesis_id = &"hyp_account_tampering"
	beat_hyp.predicted_check = "access_incident_report"
	beat_hyp.supersedes = &"s16_biometrics_match"
	guidance_service.register_beat(beat_hyp)

	var beat_intent := GuidanceBeat.new()
	beat_intent.beat_id = &"s16_open_incident_log"
	beat_intent.scene_id = &"station_16"
	beat_intent.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_intent.thought_kind = &"intention"
	beat_intent.truth_scope = &"procedural"
	beat_intent.text_pl = "Otworzę raport z dzisiejszej próby."
	beat_intent.text_en = "I will open the report on today's trial."
	beat_intent.cooldown_s = 8.0
	beat_intent.supersedes = &"s16_account_manipulation"
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
		"biometric_scanner":
			scan_biometrics()
		"card_reader_slot":
			scan_home_card()
		"roster_terminal":
			read_schedule()
		"duty_schedule_board":
			read_schedule()
		"turnstile_gate":
			pass_turnstile()
	clue_inspected.emit(id, prop_type)


func scan_biometrics() -> void:
	if is_biometrics_scanned:
		return
	is_biometrics_scanned = true
	if _scan_player:
		_scan_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.7)
	_check_access()
	biometrics_scanned.emit()


func scan_home_card() -> void:
	if is_card_scanned:
		return
	is_card_scanned = true
	if _scan_player:
		_scan_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"interact", 0.6)
	_check_access()
	card_scanned.emit()


func present_id_card() -> void:
	scan_home_card()


func read_schedule() -> void:
	if is_schedule_read:
		return
	is_schedule_read = true
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.8)
	_check_access()
	schedule_read.emit()


func check_duty_roster() -> void:
	read_schedule()


func start_clerk_dialogue() -> void:
	pass_turnstile()


func _check_access() -> void:
	if is_biometrics_scanned and is_card_scanned and is_schedule_read:
		if not is_turnstile_unlocked:
			is_turnstile_unlocked = true
			if _door_player:
				_door_player.play()
			var state := get_node_or_null("/root/GameStateManager")
			if state:
				state.record_decision(&"local_lena_ucp_profile_found", true)
			if guidance_service:
				guidance_service.report_progress(&"turnstile_unlocked")
				guidance_service.trigger_beat(&"s16_biometrics_match")


func pass_turnstile() -> void:
	if not is_turnstile_unlocked:
		apply_scanner_setback()
		return
	if guidance_service:
		guidance_service.trigger_beat(&"s16_account_manipulation")
	turnstile_passed.emit()


func apply_scanner_setback() -> void:
	scanner_setback_count += 1
	reader_locked = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_16_scanner_blocked", scanner_setback_count)
	if guidance_service:
		guidance_service.report_failed_attempt(&"scanner_blocked")
	if player:
		player.reset_to(Vector2(60.0, 296.0))
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"restart"):
		apply_scanner_setback()
		get_viewport().set_input_as_handled()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_turnstile_unlocked:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	var bio_col := VectorStageStyle.ANCHOR_CYAN if is_biometrics_scanned else VectorStageStyle.HUMAN_AMBER
	draw_circle(Vector2(160.0, 250.0), 8.0, bio_col)

	var card_col := VectorStageStyle.ANCHOR_CYAN if is_card_scanned else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.6)
	draw_rect(Rect2(Vector2(260.0, 240.0), Vector2(24.0, 30.0)), card_col, false, 1.0)

	var sched_col := VectorStageStyle.ANCHOR_CYAN if is_schedule_read else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.5)
	draw_rect(Rect2(Vector2(380.0, 230.0), Vector2(30.0, 40.0)), sched_col, false, 1.0)

	var turn_col := VectorStageStyle.ANCHOR_CYAN if is_turnstile_unlocked else VectorStageStyle.SEAM_RED
	draw_line(Vector2(480.0, 220.0), Vector2(480.0, 298.0), turn_col, 2.0)

	var exit_col := VectorStageStyle.ANCHOR_CYAN if is_turnstile_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_col, 2.0)
