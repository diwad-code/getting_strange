class_name Station13
extends Node2D

## Station 13 — S05, dwie niezależne wersje dokumentów.
## Szuflada jest rzeczywistą przeszkodą biurka (R4, próg 16 px); dokumenty mają
## niezależne pieczęcie i różne adresy — para odrzuca prostą przeprowadzkę.

## PRZESZKODA — dlaczego to tu jest: Szuflada biurka wysuwa się na spuchniętych prowadnicach i zamyka przejście, a dokumenty leżą wewnątrz.
## PRZESZKODA — czego wymaga od Leny: wysunięcia szuflady, porównania obu dokumentów i weryfikacji pieczęci przed wyjściem.
## PRZESZKODA — koszt porażki: wyjście obok otwartej szuflady bez porównania tworzy informację o braku drugiego źródła.

## PKG-0192 (D-205 §4) — jawna decyzja dla `DeskDrawer`: ZOSTAJE jako
## uzasadniony element diegetyczny P9 (próg R4, 16 px, realny collider
## sprzężony z `_process()`), nie nienazwana hybryda P7. Metody
## `open_drawer()`, `observe_field_certificate()`, `observe_tenancy_contract()`,
## `verify_document_independence()`, `compare_document_versions()`,
## `request_independent_description()` zostają callable (testy wołają je
## bezpośrednio), ale nie piszą już nic pod `p7.marta_threshold.*` — patrz
## `p9.threshold_obstacle.*` niżej. `compare_document_versions()` nadal
## zapisuje `conflicting_documents_found` bez zmian (nie kanoniczny fakt z
## listy 13, niezależna decyzja poza zakresem tego pakietu).

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const DRAWER_CLOSED_X := 360.0
const DRAWER_OPEN_X := 316.0
const FACT_QUESTIONS := &"p9.threshold_obstacle.marta_threshold.independent_questions_ready"
const FACT_CERTIFICATE := &"p9.threshold_obstacle.marta_threshold.field_certificate_observed"
const FACT_CONTRACT := &"p9.threshold_obstacle.marta_threshold.tenancy_contract_observed"
const FACT_SEALS := &"p9.threshold_obstacle.marta_threshold.document_independence_verified"
const FACT_RESULT := &"p9.threshold_obstacle.marta_threshold.document_trial_result"
const FACT_FEEDBACK := &"p9.threshold_obstacle.marta_threshold.safe_trial_feedback"
const P9_TRACE_HOME := &"p9.mystery.home.trace"
const P9_TRACE_INSTITUTION := &"p9.mystery.institution.trace"
const P9_TRACE_JAKUB := &"p9.mystery.jakub.trace"
const P9_TRACE_SYNTHESIS := &"p9.mystery.synthesis.trace"
const P9_MARTA_SOURCE_SEEN := &"p9.mystery.synthesis.marta_source_seen"
const P9_INSTITUTION_SOURCE_SEEN := &"p9.mystery.synthesis.institution_source_seen"

## PKG-0191 — canonical CAMPAIGN_MAP facts. `recognition_evidence_carried` is
## written by the materially appropriate source action (laying the
## home-carried material on the synthesis table, `mark_marta_source_seen()`),
## not fabricated on scene entry. `world_recognized` and
## `local_lena_search_committed` are the two terminal facts written together
## only by an explicit, fully-gated synthesis.
const CANON_EVIDENCE_CARRIED := &"recognition_evidence_carried"
const CANON_WORLD_RECOGNIZED := &"world_recognized"
const CANON_SEARCH_COMMITTED := &"local_lena_search_committed"

signal clue_inspected(id: String, prop_type: int)
signal documents_compared()
signal level_completed()
signal previous_level_requested()
## PKG-0190 — emitowany raz, tuż po zapisie `world_recognized`, żeby
## `CinematicDirector` mógł wyzwolić VIG-02 "Synteza" bez dublowania logiki
## rozpoznania. Nie zmienia żadnej reguły gry ani kolejności zapisu flag.
signal world_difference_synthesized()

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
	var presentation := preload("res://scripts/levels/creative_scene_presentation.gd").new()
	presentation.name = "CreativeScenePresentation"
	add_child(presentation)
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
	_register_beat(&"s13_document_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Na stole jest miejsce na moje dokumenty.", "There is space for my documents on the table.", &"", "")
	_register_beat(&"s13_dates_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Może przeprowadzka tłumaczy adres. Porównam rejestr i spotkanie.", "Perhaps a move explains the address. I will compare the record and meeting.", &"different_dates", "synthesize_world_difference")
	_register_beat(&"s13_compare_documents", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Wyłożę własny nośnik i wyciąg. Dopiero potem je połączę.", "I will lay out my own material and the extract, then connect them.", &"", "")
	_register_beat(&"s13_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Domowy nośnik, zapis UCP, zestawienie ze spotkaniem.", "HINT: Carried material, UCP record, comparison with the meeting.", &"", "")


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
			mark_marta_source_seen()
		"institution_source":
			mark_institution_source_seen()
		"synthesize":
			synthesize_world_difference()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func mark_marta_source_seen() -> bool:
	_record(P9_MARTA_SOURCE_SEEN, true)
	# PKG-0191: laying the home-carried material (Marta's source) on the
	# synthesis table is the material action that establishes it as evidence
	# carried into Station 13, not fabricated on scene entry.
	_record(CANON_EVIDENCE_CARRIED, true)
	_report_progress(&"s13_marta_source_seen")
	queue_redraw()
	return true


func mark_institution_source_seen() -> bool:
	_record(P9_INSTITUTION_SOURCE_SEEN, true)
	_report_progress(&"s13_institution_source_seen")
	queue_redraw()
	return true


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
	_record(&"p9.threshold_obstacle.marta_threshold.recall_requested", true)
	_report_progress(&"s13_recall_requested")
	_unlock_exit()
	queue_redraw()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	GapLedger.annotate_feedback(self, value) # PKG-0215 (D-228): blocked verb speaks its gap, if any.
	if guidance_service:
		guidance_service.report_failed_attempt(&"s13_" + value)


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	pass  # PKG-0174: ThresholdZone requires interact


func _complete_if_player_already_in_airlock() -> void:
	if airlock_zone != null and player != null and airlock_zone.overlaps_body(player):
		_trigger_level_completion()


func _on_airlock_body_entered(_body: Node2D) -> void:
	# PKG-0174: AirlockZone is a closure zone, not a trigger.
	pass


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
	# Same low sofa, curtain and practical lamp as the earlier domestic rooms.
	draw_rect(Rect2(54, 220, 98, 61), Color("514149"))
	draw_rect(Rect2(62, 206, 82, 30), Color("91707a"))
	draw_rect(Rect2(76, 212, 42, 18), Color("6b7980"))
	draw_rect(Rect2(500, 130, 86, 98), Color("332f35"))
	draw_rect(Rect2(507, 138, 72, 82), Color("70838a"))
	draw_line(Vector2(543, 138), Vector2(543, 220), Color("b5c4c0"), 2)
	draw_rect(Rect2(492, 124, 16, 110), Color("8c6670"))
	draw_rect(Rect2(578, 124, 16, 110), Color("6c7880"))
	draw_line(Vector2(230, 188), Vector2(230, 244), Color("cda06f"), 2)
	draw_circle(Vector2(230, 180), 13, Color("e4bd82"))
	# Sources appear only when actually laid out; carried does not imply sample.
	if _decision_bool(P9_MARTA_SOURCE_SEEN):
		draw_rect(Rect2(252, 234, 44, 9), Color("d3d0c5"))
		draw_rect(Rect2(300, 226, 18, 18), Color("3b4d54"))
		if _decision_bool(&"home_sample_preserved"):
			draw_rect(Rect2(320, 236, 12, 8), Color("d3a46e"))
	if _decision_bool(P9_INSTITUTION_SOURCE_SEEN) and _decision_bool(&"recognition_evidence_public"):
		draw_rect(Rect2(350, 232, 54, 11), Color("b7d1d0"))
	# The cups were moved, not replaced by three identical source terminals.
	draw_rect(Rect2(172, 232, 12, 12), Color("d3d0c5"))
	draw_rect(Rect2(191, 232, 12, 12), Color("b7d1d0"))
	# PKG-0198 (ZERO wycinek 2): cień kontaktowy stołu syntezy w prawo, 0.48,
	# zgodnie z lampą praktyczną (230,180) i konwencją 01/06/08.
	draw_colored_polygon(PackedVector2Array([
		Vector2(146.0, 300.0), Vector2(468.0, 296.0),
		Vector2(476.0, 304.0), Vector2(154.0, 308.0),
	]), Color(VectorStageStyle.INK, 0.48))


func synthesize_world_difference() -> bool:
	if _decision_bool(CANON_WORLD_RECOGNIZED):
		return false
	if not (_has(P9_TRACE_HOME) and _has(P9_TRACE_INSTITUTION) and _has(P9_TRACE_JAKUB)):
		return false
	# PKG-0191: an explicit synthesis requires all three prior canonical
	# evidence families (public, relational, carried) plus both local source
	# markers laid out at this table. Rejecting here writes no terminal fact.
	if not (_decision_bool(&"recognition_evidence_public") and _decision_bool(&"recognition_evidence_relational") and _decision_bool(CANON_EVIDENCE_CARRIED)):
		return false
	if not (_decision_bool(P9_MARTA_SOURCE_SEEN) and _decision_bool(P9_INSTITUTION_SOURCE_SEEN)):
		return false
	_record(CANON_WORLD_RECOGNIZED, true)
	_record(CANON_SEARCH_COMMITTED, true)
	_record(P9_TRACE_SYNTHESIS, "this_is_not_my_world")
	world_difference_synthesized.emit()
	_unlock_exit()
	queue_redraw()
	return true

func _decision_bool(key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	return state != null and state.decisions.get(key, false) == true
