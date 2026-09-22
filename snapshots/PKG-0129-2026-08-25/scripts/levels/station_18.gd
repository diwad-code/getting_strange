class_name Station18
extends Node2D

## Station 18 (Przestrzeń 18: Brak aktu zgonu) — Kanon 0.3
## Zgodny z docs/narrative/FULL_STORY.md (18), DIALOGUE_SCRIPT.md,
## docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md oraz docs/PIXEL_PRESENTATION_ARCHITECTURE.md.
##
## Cel: wykluczyć fałszerstwo UCP przez dwa publiczne źródła.
## Przeszkoda: rejestr miejski i szpital nie mają aktu zgonu Jakuba; mają późniejsze wpisy, adres i kartę pracownika Linii 4.
## Działanie: gracz porównuje daty, źródła i numer sprawy katastrofy.
## Pokaż: lokalny Jakub przeżył operację po wypadku, którego data odpowiada katastrofie Leny.
## Zmiana: błąd migracji musiałby objąć dwa niezależne systemy i dziewięć lat życia.

## PRZESZKODA — dlaczego to tu jest: Publiczne terminale archiwum miejskiego są rozdzielone przegrodą techniczną i wymagają manualnego przełączenia rejestru zgonów na rejestr ubezpieczeń.
## PRZESZKODA — czego wymaga od Leny: sprawdzenia daty wypadku w rejestrze zgonów, przejścia do terminala szpitalnego i potwierdzenia numeru karty pracowniczej Jakuba.
## PRZESZKODA — koszt porażki: błędne zapytanie blokuje sesję publiczną na 30 sekund i usuwa filtr spraw wypadkowych; koszt zapisany w rejestrze decyzji.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)

signal clue_inspected(id: String, prop_type: int)
signal municipal_searched()
signal hospital_searched()
signal employment_card_verified()
signal disaster_file_checked()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var dialogue_box: CRTDialogueBox = $CRTDialogueBox

var is_municipal_searched: bool = false
var is_hospital_searched: bool = false
var is_employment_card_verified: bool = false
var is_disaster_file_checked: bool = false
var are_public_sources_verified: bool = false
var is_level_completed: bool = false

var registry_setback_count: int = 0
var filter_reset: bool = false
var _pulse_time: float = 0.0

var _terminal_player: AudioStreamPlayer
var _paper_player: AudioStreamPlayer


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
	_terminal_player = AudioStreamPlayer.new()
	_terminal_player.name = "TerminalAudioPlayer"
	_terminal_player.stream = ProceduralAudio.create_drafting_lamp_hum_sound()
	_terminal_player.volume_db = -14.0
	_terminal_player.bus = &"Master"
	add_child(_terminal_player)

	_paper_player = AudioStreamPlayer.new()
	_paper_player.name = "PaperAudioPlayer"
	_paper_player.stream = ProceduralAudio.create_dossier_paper_turn_sound()
	_paper_player.volume_db = -8.0
	_paper_player.bus = &"Master"
	add_child(_paper_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return

	var beat_obs := GuidanceBeat.new()
	beat_obs.beat_id = &"s18_no_death_record"
	beat_obs.scene_id = &"station_18"
	beat_obs.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_obs.thought_kind = &"observation"
	beat_obs.truth_scope = &"factual"
	beat_obs.text_pl = "Brak aktu zgonu. Dziewięć lat późniejszych wpisów."
	beat_obs.text_en = "No death certificate. Nine years of subsequent records."
	beat_obs.cooldown_s = 8.0
	guidance_service.register_beat(beat_obs)

	var beat_hyp := GuidanceBeat.new()
	beat_hyp.beat_id = &"s18_ucp_database_forgery"
	beat_hyp.scene_id = &"station_18"
	beat_hyp.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_hyp.thought_kind = &"interpretation"
	beat_hyp.truth_scope = &"fallible"
	beat_hyp.text_pl = "UCP mogło sfabrykować miejskie rejestry."
	beat_hyp.text_en = "UCP could have fabricated municipal records."
	beat_hyp.cooldown_s = 8.0
	beat_hyp.hypothesis_id = &"hyp_ucp_forgery"
	beat_hyp.predicted_check = "verify_direct_family_knowledge"
	beat_hyp.supersedes = &"s18_no_death_record"
	guidance_service.register_beat(beat_hyp)

	var beat_intent := GuidanceBeat.new()
	beat_intent.beat_id = &"s18_test_family_knowledge"
	beat_intent.scene_id = &"station_18"
	beat_intent.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_intent.thought_kind = &"intention"
	beat_intent.truth_scope = &"procedural"
	beat_intent.text_pl = "Nie zadzwonię bez prywatnego pytania kontrolnego."
	beat_intent.text_en = "I will not call without a private control question."
	beat_intent.cooldown_s = 8.0
	beat_intent.supersedes = &"s18_ucp_database_forgery"
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
		"municipal_terminal":
			search_municipal_records()
		"hospital_terminal":
			search_hospital_records()
		"employment_card":
			verify_employment_card()
		"disaster_file":
			check_disaster_file()
		"microfiche_reader":
			check_disaster_file()
	clue_inspected.emit(id, prop_type)


func search_municipal_records() -> void:
	if is_municipal_searched:
		return
	is_municipal_searched = true
	if _terminal_player:
		_terminal_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.7)
	_check_records()
	municipal_searched.emit()


func query_municipal_deaths() -> void:
	search_municipal_records()


func search_hospital_records() -> void:
	if is_hospital_searched:
		return
	is_hospital_searched = true
	if _terminal_player:
		_terminal_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.7)
	_check_records()
	hospital_searched.emit()


func query_hospital_deaths() -> void:
	search_hospital_records()


func verify_employment_card() -> void:
	if is_employment_card_verified:
		return
	is_employment_card_verified = true
	if _paper_player:
		_paper_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.8)
	_check_records()
	employment_card_verified.emit()


func query_employment_record() -> void:
	verify_employment_card()


func start_archive_dialogue() -> void:
	check_disaster_file()


func check_disaster_file() -> void:
	if is_disaster_file_checked:
		return
	is_disaster_file_checked = true
	if _paper_player:
		_paper_player.play()
	if player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"examine", 0.8)
	_check_records()
	disaster_file_checked.emit()


func _check_records() -> void:
	if are_public_sources_verified:
		return
	if is_municipal_searched and is_hospital_searched and is_employment_card_verified:
		are_public_sources_verified = true
		var state := get_node_or_null("/root/GameStateManager")
		if state:
			state.record_decision(&"jakub_public_history_verified", true)
			state.record_decision(&"recognition_evidence_public", true)
		if guidance_service:
			guidance_service.report_progress(&"public_sources_verified")
			guidance_service.trigger_beat(&"s18_no_death_record")


func apply_registry_setback() -> void:
	registry_setback_count += 1
	filter_reset = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_18_registry_timeout", registry_setback_count)
	if guidance_service:
		guidance_service.report_failed_attempt(&"registry_timeout")
	if player:
		player.reset_to(Vector2(60.0, 296.0))
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"restart"):
		apply_registry_setback()
		get_viewport().set_input_as_handled()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and are_public_sources_verified:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	var mun_col := VectorStageStyle.ANCHOR_CYAN if is_municipal_searched else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(Vector2(140.0, 240.0), Vector2(30.0, 30.0)), mun_col, false, 1.0)

	var hosp_col := VectorStageStyle.ANCHOR_CYAN if is_hospital_searched else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.6)
	draw_rect(Rect2(Vector2(260.0, 240.0), Vector2(30.0, 30.0)), hosp_col, false, 1.0)

	var emp_col := VectorStageStyle.ANCHOR_CYAN if is_employment_card_verified else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.5)
	draw_rect(Rect2(Vector2(380.0, 250.0), Vector2(24.0, 20.0)), emp_col, false, 1.0)

	var exit_col := VectorStageStyle.ANCHOR_CYAN if are_public_sources_verified else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_col, 2.0)
