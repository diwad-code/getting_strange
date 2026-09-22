class_name Station13
extends Node2D

## Station 13 — S05, dwie niezależne wersje dokumentów.
## Szuflada jest rzeczywistą przeszkodą biurka (R4, próg 16 px); dokumenty mają
## niezależne pieczęcie i różne adresy — para odrzuca prostą przeprowadzkę.

## PRZESZKODA — dlaczego to tu jest: Szuflada biurka wysuwa się na spuchniętych prowadnicach i zamyka przejście, a dokumenty leżą wewnątrz.
## PRZESZKODA — czego wymaga od Leny: wysunięcia szuflady, porównania obu dokumentów i weryfikacji pieczęci przed wyjściem.
## PRZESZKODA — koszt porażki: wyjście obok otwartej szuflady bez porównania tworzy informację o braku drugiego źródła.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const DRAWER_CLOSED_X := 360.0
const DRAWER_OPEN_X := 316.0
const FACT_QUESTIONS := &"p7.marta_threshold.independent_questions_ready"
const FACT_CERTIFICATE := &"p7.marta_threshold.field_certificate_observed"
const FACT_CONTRACT := &"p7.marta_threshold.tenancy_contract_observed"
const FACT_SEALS := &"p7.marta_threshold.document_independence_verified"
const FACT_RESULT := &"p7.marta_threshold.document_trial_result"
const FACT_FEEDBACK := &"p7.marta_threshold.safe_trial_feedback"
const P9_TRACE_HOME := &"p9.mystery.home.trace"
const P9_TRACE_INSTITUTION := &"p9.mystery.institution.trace"
const P9_TRACE_JAKUB := &"p9.mystery.jakub.trace"
const P9_TRACE_SYNTHESIS := &"p9.mystery.synthesis.trace"

signal clue_inspected(id: String, prop_type: int)
signal documents_compared()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var desk_drawer: AnimatableBody2D = $Geometry/DeskDrawer
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_drawer_open := false
var is_certificate_observed := false
var is_contract_observed := false
var are_seals_verified := false
var are_documents_compared := false
var is_meeting_requested := false
var is_exit_unlocked := false
var is_level_completed := false


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_props()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	queue_redraw()


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s13_document_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s13_document_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Jedna pieczęć, dwa adresy. Sprawdzę daty i wystawców.", "One seal set, two addresses. Check dates and issuers.", &"", "")
	_register_beat(&"s13_dates_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Może papiery nakładają się przy przeprowadzce. Pieczęcie to rozstrzygną.", "Maybe paperwork overlaps on a move. The seals can test that.", &"different_dates", "compare_independent_seals")
	_register_beat(&"s13_compare_documents", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Otworzę szufladę, porównam pieczęcie i daty obu dokumentów.", "Open the drawer, compare seals and dates of both documents.", &"", "")
	_register_beat(&"s13_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Otwórz szufladę, potem zaświadczenie, umowa, lupa, zapis czytnika.", "HINT: Open the drawer, then certificate, contract, magnifier, reader log.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_13"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	beat.predicted_check = predicted_check
	guidance_service.register_beat(beat)


func _connect_props() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var prop := child as MemoryResonancePoint
			if not prop.resonance_triggered.is_connected(_on_prop_resonance_triggered.bind(prop)):
				prop.resonance_triggered.connect(_on_prop_resonance_triggered.bind(prop))


func _process(delta: float) -> void:
	var target := DRAWER_OPEN_X if is_drawer_open else DRAWER_CLOSED_X
	if desk_drawer:
		desk_drawer.position.x = move_toward(desk_drawer.position.x, target, delta * 90.0)
		var drawer_progress := clampf((DRAWER_CLOSED_X - desk_drawer.position.x) / (DRAWER_CLOSED_X - DRAWER_OPEN_X), 0.0, 1.0)
		var shape := desk_drawer.get_node_or_null("CollisionShape2D") as CollisionShape2D
		if shape:
			shape.disabled = drawer_progress < 0.35
	queue_redraw()

func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	match id:
		"marta_source":
			_record(&"p9.mystery.synthesis.marta_source_seen", true)
		"institution_source":
			_record(&"p9.mystery.synthesis.institution_source_seen", true)
		"synthesize":
			synthesize_world_difference()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func open_drawer() -> bool:
	if is_drawer_open or not _has(FACT_QUESTIONS):
		_record_feedback(&"questions_required")
		return false
	is_drawer_open = true
	_report_progress(&"s13_drawer_opened")
	queue_redraw()
	return true


func observe_field_certificate() -> bool:
	if is_certificate_observed or not _has(FACT_QUESTIONS):
		_record_feedback(&"questions_required")
		return false
	is_certificate_observed = true
	_record(FACT_CERTIFICATE, true)
	_report_progress(&"s13_field_certificate_observed")
	queue_redraw()
	return true


func observe_tenancy_contract() -> bool:
	if is_contract_observed or not is_drawer_open:
		if not is_drawer_open:
			_record_feedback(&"drawer_required")
		return false
	is_contract_observed = true
	_record(FACT_CONTRACT, true)
	_report_progress(&"s13_tenancy_contract_observed")
	if guidance_service:
		guidance_service.trigger_beat(&"s13_dates_hypothesis")
	queue_redraw()
	return true


func verify_document_independence() -> bool:
	if are_seals_verified or not (is_certificate_observed and is_contract_observed):
		_record_feedback(&"both_documents_required")
		return false
	are_seals_verified = true
	_record(FACT_SEALS, true)
	_report_progress(&"s13_seals_verified")
	queue_redraw()
	return true


func compare_document_versions() -> bool:
	if are_documents_compared:
		return false
	if not are_seals_verified:
		_record_feedback(&"seals_required")
		return false
	are_documents_compared = true
	_record(FACT_RESULT, "independent_detail_conflicts")
	_record(&"conflicting_documents_found", true)
	documents_compared.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"different_dates")
	_report_progress(&"s13_documents_compared")
	queue_redraw()
	return true


func request_independent_description() -> bool:
	if is_meeting_requested or not are_documents_compared:
		if not are_documents_compared:
			_record_feedback(&"documents_required")
		return false
	is_meeting_requested = true
	_record(&"p7.marta_threshold.recall_requested", true)
	_report_progress(&"s13_recall_requested")
	_unlock_exit()
	queue_redraw()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s13_" + value)


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	call_deferred("_complete_if_player_already_in_airlock")


func _complete_if_player_already_in_airlock() -> void:
	if airlock_zone != null and player != null and airlock_zone.overlaps_body(player):
		_trigger_level_completion()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_exit_unlocked:
		_trigger_level_completion()


func _trigger_level_completion() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _has(key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	return state != null and state.decisions.has(key) and state.decisions.get(key) != null


func _record(key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(key, value)

func _is_resolved(id: String) -> bool:
	match id:
		"marta_source": return _decision_bool(&"p9.mystery.synthesis.marta_source_seen")
		"institution_source": return _decision_bool(&"p9.mystery.synthesis.institution_source_seen")
		"synthesize": return _decision_bool(&"world_recognized")
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	draw_rect(Rect2(0, 0, 640, 360), Color("28232a"))
	draw_rect(Rect2(0, 42, 640, 42), Color("51424e"))
	draw_rect(Rect2(0, 84, 640, 220), Color("725e59"))
	draw_rect(Rect2(0, 304, 640, 24), Color("3d3438"))
	draw_rect(Rect2(154, 244, 306, 22), Color("493936"))
	draw_rect(Rect2(198, 266, 22, 38), Color("493936"))
	draw_rect(Rect2(394, 266, 22, 38), Color("493936"))
	draw_rect(Rect2(212, 218, 52, 26), Color("d3d0c5"))
	draw_rect(Rect2(282, 218, 52, 26), Color("b7d1d0"))
	draw_rect(Rect2(352, 218, 52, 26), Color("d3a46e"))
	draw_rect(Rect2(74, 146, 82, 104), Color("4a3d43"))
	draw_rect(Rect2(498, 146, 82, 104), Color("4a3d43"))
	draw_circle(Vector2(290, 188), 14, Color("f0cc8d"))
	draw_circle(Vector2(350, 188), 14, Color("f0cc8d"))


func synthesize_world_difference() -> bool:
	if _decision_bool(&"world_recognized"):
		return false
	if not (_has(P9_TRACE_HOME) and _has(P9_TRACE_INSTITUTION) and _has(P9_TRACE_JAKUB)):
		return false
	_record(&"world_recognized", true)
	_record(P9_TRACE_SYNTHESIS, "this_is_not_my_world")
	_unlock_exit()
	queue_redraw()
	return true

func _decision_bool(key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	return state != null and state.decisions.get(key, false) == true
