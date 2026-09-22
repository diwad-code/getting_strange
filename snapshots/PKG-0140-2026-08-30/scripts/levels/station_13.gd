class_name Station13
extends Node2D

## Station 13 (Przestrzeń 13: Dwie ważne wersje) — Kanon 0.3
## Zgodny z docs/narrative/FULL_STORY.md (13), DIALOGUE_SCRIPT.md (Station 13 — dwa dokumenty),
## docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md oraz docs/PIXEL_PRESENTATION_ARCHITECTURE.md.
##
## Cel: zbudować pakiet faktów niezależnych od pamięci.
## Przeszkoda: zaświadczenie z torby i umowa z szuflady mają zachodzące daty, różne adresy i prawidłowe pieczęcie.
## Działanie: gracz sprawdza pieczęcie, terminy i zapis offline czytnika.
## Pokaż: żaden pojedynczy dokument nie rozstrzyga; dopiero para wyklucza zwykłą przeprowadzkę.
## Zmiana: Lena prosi Martę o spotkanie i mówi tylko, że potrzebuje potwierdzić dzisiejszy dzień.

## PRZESZKODA — dlaczego to tu jest: Szuflada biurka chodzi po spuchniętych prowadnicach i po wysunięciu blokuje jedyne przejście między biurkiem a ścianą.
## PRZESZKODA — czego wymaga od Leny: wysunięcia szuflady po umowę, a potem domknięcia jej, zanim spróbuje wyjść z pokoju.
## PRZESZKODA — koszt porażki: przeciskanie się obok wysuniętej szuflady rozsypuje dokumenty i zamazuje jedną z dwóch pieczęci.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)
const DRAWER_CLOSED_X := 360.0
const DRAWER_OPEN_X := 316.0

signal clue_inspected(id: String, prop_type: int)
signal drawer_opened()
signal drawer_closed()
signal documents_compared()
signal meeting_requested()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var desk_drawer: AnimatableBody2D = $Geometry/DeskDrawer
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var dialogue_box: CRTDialogueBox = $CRTDialogueBox

## Jedyna wypowiedziana kwestia sceny (`LENA // MÓWI`) oraz prośba do Marty.
var spoken_lines: Array[Dictionary] = [
	{
		"speaker": "LENA",
		"text": "Ten był ze mną w terenie.",
		"is_lena": true,
	},
	{
		"speaker": "LENA // TELEFON",
		"text": "Marto, przyjedź. Muszę potwierdzić dzisiejszy dzień.",
		"is_lena": true,
	},
]

var is_drawer_open: bool = false
var certificate_compared: bool = false
var contract_compared: bool = false
var seals_verified: bool = false
var reader_log_checked: bool = false
var are_documents_compared: bool = false
var is_meeting_requested: bool = false
var is_level_completed: bool = false

var squeeze_setback_count: int = 0
var seal_smudged: bool = false

var _drawer_progress: float = 0.0
var _pulse_time: float = 0.0

var _drawer_player: AudioStreamPlayer
var _paper_player: AudioStreamPlayer
var _phone_player: AudioStreamPlayer
var _lamp_player: AudioStreamPlayer


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
	_lamp_player = AudioStreamPlayer.new()
	_lamp_player.name = "LampAudioPlayer"
	_lamp_player.stream = ProceduralAudio.create_drafting_lamp_hum_sound()
	_lamp_player.volume_db = -20.0
	_lamp_player.bus = &"Master"
	add_child(_lamp_player)
	_lamp_player.play()

	_drawer_player = AudioStreamPlayer.new()
	_drawer_player.name = "DrawerAudioPlayer"
	_drawer_player.stream = ProceduralAudio.create_drawer_lock_unlatch_sound()
	_drawer_player.volume_db = -7.0
	_drawer_player.bus = &"Master"
	add_child(_drawer_player)

	_paper_player = AudioStreamPlayer.new()
	_paper_player.name = "PaperAudioPlayer"
	_paper_player.stream = ProceduralAudio.create_dossier_paper_turn_sound()
	_paper_player.volume_db = -8.0
	_paper_player.bus = &"Master"
	add_child(_paper_player)

	_phone_player = AudioStreamPlayer.new()
	_phone_player.name = "PhoneAudioPlayer"
	_phone_player.stream = ProceduralAudio.create_handset_pickup_sound()
	_phone_player.volume_db = -8.0
	_phone_player.bus = &"Master"
	add_child(_phone_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return

	var beat_obs := GuidanceBeat.new()
	beat_obs.beat_id = &"s13_two_addresses"
	beat_obs.scene_id = &"station_13"
	beat_obs.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_obs.thought_kind = &"observation"
	beat_obs.truth_scope = &"factual"
	beat_obs.text_pl = "Dwa adresy. Jeden dzień."
	beat_obs.text_en = "Two addresses. One day."
	beat_obs.cooldown_s = 8.0
	guidance_service.register_beat(beat_obs)

	var beat_hyp := GuidanceBeat.new()
	beat_hyp.beat_id = &"s13_paperwork_lag"
	beat_hyp.scene_id = &"station_13"
	beat_hyp.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_hyp.thought_kind = &"interpretation"
	beat_hyp.truth_scope = &"fallible"
	beat_hyp.text_pl = "Papiery czasem się nakładają przy przeprowadzce."
	beat_hyp.text_en = "Paperwork overlaps when someone moves."
	beat_hyp.cooldown_s = 8.0
	beat_hyp.hypothesis_id = &"hyp_conflicting_records"
	beat_hyp.predicted_check = "verify_day_with_marta"
	beat_hyp.supersedes = &"s13_two_addresses"
	guidance_service.register_beat(beat_hyp)

	var beat_intent := GuidanceBeat.new()
	beat_intent.beat_id = &"s13_ask_marta_for_the_day"
	beat_intent.scene_id = &"station_13"
	beat_intent.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_intent.thought_kind = &"intention"
	beat_intent.truth_scope = &"procedural"
	beat_intent.text_pl = "Marta opisze dzień z pamięci."
	beat_intent.text_en = "Marta can describe the day without these papers."
	beat_intent.cooldown_s = 8.0
	beat_intent.supersedes = &"s13_paperwork_lag"
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
	var target := DRAWER_OPEN_X if is_drawer_open else DRAWER_CLOSED_X
	if desk_drawer:
		desk_drawer.position.x = move_toward(desk_drawer.position.x, target, delta * 90.0)
		_drawer_progress = clampf(
			(DRAWER_CLOSED_X - desk_drawer.position.x) / (DRAWER_CLOSED_X - DRAWER_OPEN_X),
			0.0,
			1.0
		)
		## Wsunięta szuflada jest równa z frontem biurka i niczego nie blokuje.
		var shape := desk_drawer.get_node_or_null("CollisionShape2D") as CollisionShape2D
		if shape:
			shape.disabled = _drawer_progress < 0.35
	queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	prop.is_activated = true
	match id:
		"drawer_handle":
			toggle_drawer()
		"bag_certificate":
			compare_certificate()
		"drawer_contract":
			compare_contract()
		"seal_magnifier":
			verify_seals()
		"reader_offline_log":
			check_reader_log()
		"phone_to_marta":
			request_meeting()
	clue_inspected.emit(id, prop_type)


func toggle_drawer() -> void:
	is_drawer_open = not is_drawer_open
	if _drawer_player:
		_drawer_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"interact", 0.6)
	if is_drawer_open:
		drawer_opened.emit()
	else:
		drawer_closed.emit()
		if guidance_service:
			guidance_service.report_progress(&"drawer_closed")


func compare_certificate() -> void:
	if certificate_compared:
		return
	certificate_compared = true
	if _paper_player:
		_paper_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.7)
	if guidance_service:
		guidance_service.trigger_beat(&"s13_two_addresses")
	_check_comparison()


func compare_contract() -> void:
	if contract_compared:
		return
	if not is_drawer_open:
		## Umowa leży w szufladzie; bez jej wysunięcia nie ma czego porównywać.
		toggle_drawer()
		return
	contract_compared = true
	if _paper_player:
		_paper_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.8)
	_check_comparison()


func verify_seals() -> void:
	if seals_verified:
		return
	seals_verified = true
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.9)
	_check_comparison()


func check_reader_log() -> void:
	if reader_log_checked:
		return
	reader_log_checked = true
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"interact", 0.6)
	if guidance_service:
		guidance_service.report_progress(&"reader_log_checked")


func _check_comparison() -> void:
	if are_documents_compared:
		return
	if not (certificate_compared and contract_compared and seals_verified):
		return
	are_documents_compared = true
	if guidance_service:
		guidance_service.report_progress(&"documents_compared")
		## Para dokumentów wyklucza zwykłą przeprowadzkę i pomyłkę lokalu.
		guidance_service.close_hypothesis(&"hyp_lock_coincidence")
		guidance_service.trigger_beat(&"s13_paperwork_lag")
	documents_compared.emit()


func request_meeting() -> void:
	if is_meeting_requested or not are_documents_compared:
		return
	is_meeting_requested = true
	if _phone_player:
		_phone_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"seam_gesture", 0.8)
	if guidance_service:
		guidance_service.report_progress(&"meeting_requested")
		guidance_service.trigger_beat(&"s13_ask_marta_for_the_day")
	meeting_requested.emit()


## Przeciskanie się obok wysuniętej szuflady rozsypuje papiery i zamazuje pieczęć.
func apply_squeeze_setback() -> void:
	if not is_drawer_open:
		return
	squeeze_setback_count += 1
	seal_smudged = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_13_papers_scattered", squeeze_setback_count)
	if guidance_service:
		guidance_service.report_failed_attempt(&"drawer_squeezed")
	if player:
		player.reset_to(Vector2(70.0, 296.0))
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"restart") and is_drawer_open:
		apply_squeeze_setback()
		get_viewport().set_input_as_handled()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_meeting_requested:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	var cert_col := VectorStageStyle.ANCHOR_CYAN if certificate_compared else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(Vector2(168.0, 244.0), Vector2(30.0, 20.0)), cert_col, false, 1.0)

	var contract_col := VectorStageStyle.ANCHOR_CYAN if contract_compared else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.5)
	draw_rect(Rect2(Vector2(316.0, 244.0), Vector2(30.0, 20.0)), contract_col, false, 1.0)

	var seal_col := VectorStageStyle.ANCHOR_CYAN if seals_verified else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.35)
	if seal_smudged:
		seal_col = VectorStageStyle.shade(seal_col, 0.45)
	draw_circle(Vector2(190.0, 236.0), 3.0, seal_col)
	draw_circle(Vector2(338.0, 236.0), 3.0, seal_col)

	var exit_col := VectorStageStyle.ANCHOR_CYAN if is_meeting_requested else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(574.0, 180.0), Vector2(574.0, 298.0), exit_col, 2.0)
