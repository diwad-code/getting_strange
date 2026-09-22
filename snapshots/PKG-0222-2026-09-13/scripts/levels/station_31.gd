class_name Station31
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Magazyn dowodów przechowuje ewidencję pasażerów i depozyt przedmiotów z wypadku na Linii 4, wyłączonych z oficjalnych rejestrów miasta.
## PRZESZKODA — czego wymaga od Leny: Zbadania ewidencji, zidentyfikowania 12. krzesła Jakuba, odrzucenia oferty adaptacji UCP i zachowania materialnego depozytu przed wyjściem.
## PRZESZKODA — koszt porażki: Próba przejścia bez zbadania rozbieżności w ewidencji i statusu 12. krzesła blokuje otwarcie śluzy analitycznej.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_ENTRY := &"p7.jakub_boundary_and_forecasts.trace"
const FACT_CHAIRS := &"p7.archive_countermodel.passenger_chairs_inspected"
const FACT_HOLOTERMINAL := &"p7.archive_countermodel.wierzbicka_proposal_inspected"
const FACT_TWELFTH := &"p7.archive_countermodel.twelfth_chair_inspected"
const FACT_LEDGER := &"p7.archive_countermodel.passenger_ledger_compared"
const FACT_REJECT := &"p7.archive_countermodel.adaptation_offer_rejected"
const FACT_FEEDBACK := &"p7.archive_countermodel.safe_trial_feedback"

const COLOR_BACKGROUND := Color("090d11")
const COLOR_PANEL_BASE := Color("141c22")
const COLOR_PANEL_CORE := Color("1c2630")
const COLOR_INFRASTRUCTURE := Color("3d5866")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")

signal level_completed
signal previous_level_requested
signal clue_inspected(id: String, prop_type: int)
signal passenger_chairs_inspected
signal wierzbicka_proposal_inspected
signal twelfth_chair_inspected
signal passenger_ledger_compared
signal adaptation_offer_rejected
signal exit_unlocked
signal chairs_inspected
signal holoterminal_inspected
signal ledger_inspected

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")
@onready var guidance_service: NarrativeGuidanceService = get_node_or_null("NarrativeGuidanceService")

var is_chairs_inspected: bool = false
var is_holoterminal_inspected: bool = false
var is_twelfth_chair_inspected: bool = false
var is_ledger_inspected: bool = false
var is_adaptation_rejected: bool = false
var is_exit_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_index: int = 0
var dialogue_active: bool = false
var dialogue_lines: Array[Dictionary] = []
var _exit_open_progress: float = 0.0


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_setup_props()
	if airlock_zone and not airlock_zone.body_entered.is_connected(_on_airlock_zone_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_zone_body_entered)
	queue_redraw()


func _setup_props() -> void:
	if not props:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var pt := child as MemoryResonancePoint
			if not pt.resonance_triggered.is_connected(_on_resonance_triggered):
				pt.resonance_triggered.connect(_on_resonance_triggered)


func _setup_guidance() -> void:
	if not guidance_service:
		return
	_register_beat(&"s31_archive_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s31_archive_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Magazyn dowodów. Ewidencja pasażerów i depozyt Linii 4.", "Evidence archive. Passenger ledger and Line 4 depot.", &"", "")
	_register_beat(&"s31_adaptation_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "UCP oferuje wygodną adaptację. Jeżeli usunę obcy ślad, utracę legitymację Jakuba.", "UCP offers comfortable adaptation. If I remove foreign trace, I lose Jakub's credential.", &"correction_protects_all", "reject_adaptation_offer")
	_register_beat(&"s31_reject_adaptation", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zbadam krzesła, holoterminal Wierzbickiej, dwunaste krzesło, porównam rejestr i odrzucę ofertę adaptacji.", "Inspect chairs, Wierzbicka terminal, twelfth chair, compare ledger, and reject adaptation offer.", &"", "reject_adaptation_offer")
	_register_beat(&"s31_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Krzesła pasażerów, holoterminal, dwunaste krzesło Jakuba, rejestr wariantu, odrzucenie adaptacji.", "HINT: Passenger chairs, holoterminal, twelfth chair, variant ledger, reject adaptation.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_31"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	beat.predicted_check = predicted_check
	guidance_service.register_beat(beat)


func _process(delta: float) -> void:
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 2.0)
		queue_redraw()


func inspect_passenger_chairs() -> bool:
	if is_chairs_inspected:
		return false
	if not _has(FACT_ENTRY):
		_record_feedback(&"entry_trace_required")
		return false
	is_chairs_inspected = true
	_record(FACT_CHAIRS, true)
	passenger_chairs_inspected.emit()
	chairs_inspected.emit()
	_activate_prop_by_id("prop_eleven_chairs")
	if guidance_service:
		guidance_service.trigger_beat(&"s31_archive_contact")
	_report_progress(&"s31_chairs_inspected")
	queue_redraw()
	return true


func inspect_chairs() -> bool:
	return inspect_passenger_chairs()


func inspect_wierzbicka_proposal() -> bool:
	if is_holoterminal_inspected:
		return false
	if not is_chairs_inspected:
		_record_feedback(&"chairs_inspection_required")
		return false
	is_holoterminal_inspected = true
	_record(FACT_HOLOTERMINAL, true)
	wierzbicka_proposal_inspected.emit()
	holoterminal_inspected.emit()
	_activate_prop_by_id("prop_wierzbicka_holoterminal")
	if guidance_service:
		guidance_service.trigger_beat(&"s31_adaptation_hypothesis")
	_report_progress(&"s31_holoterminal_inspected")
	queue_redraw()
	return true


func inspect_holoterminal() -> bool:
	return inspect_wierzbicka_proposal()


func inspect_twelfth_chair() -> bool:
	if is_twelfth_chair_inspected:
		return false
	if not is_holoterminal_inspected:
		_record_feedback(&"holoterminal_inspection_required")
		return false
	is_twelfth_chair_inspected = true
	_record(FACT_TWELFTH, true)
	twelfth_chair_inspected.emit()
	_activate_prop_by_id("prop_jakub_twelfth_chair")
	_report_progress(&"s31_twelfth_chair_inspected")
	queue_redraw()
	return true


func compare_passenger_ledger() -> bool:
	if is_ledger_inspected:
		return false
	if not is_twelfth_chair_inspected:
		_record_feedback(&"twelfth_chair_required")
		return false
	is_ledger_inspected = true
	_record(FACT_LEDGER, true)
	passenger_ledger_compared.emit()
	ledger_inspected.emit()
	_activate_prop_by_id("prop_variant_ledger")
	_report_progress(&"s31_ledger_compared")
	queue_redraw()
	return true


func inspect_ledger() -> bool:
	return compare_passenger_ledger()


func reject_adaptation_offer() -> bool:
	if is_adaptation_rejected:
		return false
	if not is_ledger_inspected:
		_record_feedback(&"ledger_comparison_required")
		return false
	is_adaptation_rejected = true
	_record(FACT_REJECT, true)
	adaptation_offer_rejected.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"correction_protects_all")
	_report_progress(&"s31_adaptation_rejected")
	_unlock_exit()
	queue_redraw()
	return true


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_activate_prop_by_id("prop_station_31_exit")
	call_deferred(&"_complete_if_player_already_in_airlock")
	queue_redraw()


func _complete_if_player_already_in_airlock() -> void:
	if not is_exit_unlocked or is_level_completed or airlock_zone == null or player == null:
		return
	for body in airlock_zone.get_overlapping_bodies():
		if body == player or (body != null and body.name == "Player"):
			_trigger_level_completion()
			return


func _activate_prop_by_id(id: String) -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint and child.resonance_id == id:
				child.is_activated = true
				child.queue_redraw()


func _on_resonance_triggered(id: String, prop_type: int) -> void:
	match id:
		"prop_eleven_chairs":
			inspect_passenger_chairs()
		"prop_wierzbicka_holoterminal":
			inspect_wierzbicka_proposal()
		"prop_jakub_twelfth_chair":
			inspect_twelfth_chair()
		"prop_variant_ledger":
			compare_passenger_ledger()
		"prop_station_31_exit":
			if is_exit_unlocked:
				_trigger_level_completion()
			else:
				_record_feedback(&"adaptation_rejection_required")
	clue_inspected.emit(id, prop_type)


func _on_airlock_zone_body_entered(body: Node2D) -> void:
	if is_level_completed:
		return
	if body == player or (body and body.name == "Player"):
		_trigger_level_completion()


func _trigger_level_completion() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _has(fact_key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	if state == null:
		return true
	if state.decisions.has(fact_key):
		return true
	return state.decisions.has(String(fact_key))


func _record(fact_key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null and state.has_method("record_decision"):
		state.record_decision(fact_key, value)


func _record_feedback(feedback_id: StringName) -> void:
	_record(FACT_FEEDBACK, String(feedback_id))


func _report_progress(action_id: StringName) -> void:
	if guidance_service != null and guidance_service.has_method("report_progress"):
		guidance_service.report_progress(action_id)


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	# Eleven chairs array
	for i in range(11):
		var x := 80.0 + float(i) * 14.0
		var col := COLOR_CYAN if is_chairs_inspected else COLOR_INFRASTRUCTURE
		draw_rect(Rect2(Vector2(x, 235.0), Vector2(10.0, 20.0)), COLOR_PANEL_BASE, true)
		draw_line(Vector2(x + 2.0, 235.0), Vector2(x + 2.0, 255.0), col, 1.5)

	# Holoterminal pedestal
	draw_rect(Rect2(Vector2(260.0, 210.0), Vector2(24.0, 45.0)), COLOR_PANEL_CORE, true)
	var holo_col := COLOR_AMBER if is_holoterminal_inspected else COLOR_INFRASTRUCTURE
	draw_circle(Vector2(272.0, 205.0), 6.0, holo_col)

	# Twelfth chair
	draw_rect(Rect2(Vector2(350.0, 230.0), Vector2(16.0, 25.0)), COLOR_PANEL_BASE, true)
	var twelfth_col := COLOR_AMBER_WARM if is_twelfth_chair_inspected else COLOR_INFRASTRUCTURE
	draw_line(Vector2(354.0, 230.0), Vector2(354.0, 255.0), twelfth_col, 2.0)

	# Variant ledger lectern
	draw_rect(Rect2(Vector2(440.0, 215.0), Vector2(28.0, 40.0)), COLOR_PANEL_CORE, true)
	var ledger_col := COLOR_CYAN if is_ledger_inspected else COLOR_INFRASTRUCTURE
	draw_line(Vector2(444.0, 220.0), Vector2(464.0, 220.0), ledger_col, 1.5)

	# Exit frame
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
