class_name Station12
extends Node2D

## Station 12 — S05, odsłuch wiadomości i numer.
## Balkon jest otwarty, więc odsłuch przy hałasie gubi zdanie; po domknięciu
## Lena słucha całości, sprawdza numer i zapisuje pytania zamiast odpowiadać.

## PRZESZKODA — dlaczego to tu jest: Sekretarka nagrywa lepiej przy zamkniętym balkonie, bo ulica zagłusza zdanie w trakcie odtwarzania.
## PRZESZKODA — czego wymaga od Leny: domknięcia skrzydła przed odsłuchem i sprawdzenia numeru po nagraniu.
## PRZESZKODA — koszt porażki: odsłuch przy otwartym balkonie tworzy fakt o zagubionym zdaniu i nie czyni głosu wiarygodnym źródłem.

## PKG-0192 (D-205 §4) — jawna decyzja dla `BalconyDoor`: ZOSTAJE jako
## uzasadniony element diegetyczny P9 (zamykane skrzydło, realny collider,
## zamykanie odblokowuje ExitClearance), nie nienazwana hybryda P7. Metody
## `close_balcony()`, `listen_to_message()`, `verify_caller_identity()`,
## `prepare_independent_questions()` zostają callable (testy wołają je
## bezpośrednio), ale nie piszą już nic pod `p7.marta_threshold.*` ani
## `p7.foreign_daily_life.*` — patrz `p9.threshold_obstacle.*` niżej.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const BALCONY_OPEN_X := 540.0
const BALCONY_CLOSED_X := 624.0
const FACT_S04_TRACE := &"p9.threshold_obstacle.foreign_daily_life.trace"
const FACT_VOICE := &"p9.threshold_obstacle.marta_threshold.voice_observed"
const FACT_CALLER := &"p9.threshold_obstacle.marta_threshold.caller_verified"
const FACT_QUESTIONS := &"p9.threshold_obstacle.marta_threshold.independent_questions_ready"
const FACT_FEEDBACK := &"p9.threshold_obstacle.marta_threshold.safe_trial_feedback"
const P9_QUESTIONS := &"p9.mystery.jakub.control_questions_asked"
const P9_MEETING := &"p9.mystery.jakub.meeting_completed"
const P9_REFUSAL := &"p9.mystery.jakub.refusal_accepted"
const P9_TRACE := &"p9.mystery.jakub.trace"

## PKG-0191 — canonical CAMPAIGN_MAP facts, written alongside the P9 detail
## keys above at the same semantic action.
const CANON_VOICE_HEARD := &"jakub_voice_heard"
const CANON_MET_AS_PERSON := &"jakub_met_as_person"
const CANON_EVIDENCE_RELATIONAL := &"recognition_evidence_relational"

signal clue_inspected(id: String, prop_type: int)
signal message_heard()
signal questions_prepared()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var balcony_door: AnimatableBody2D = $Geometry/BalconyDoor
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_balcony_closed := false
var is_voice_observed := false
var is_caller_verified := false
var is_message_heard := false
var are_questions_prepared := false
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
	_register_beat(&"s12_voice_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s12_voice_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Głos Marty. Najpierw zamknę balkon.", "Marta's voice. Close the balcony first.", &"", "")
	_register_beat(&"s12_staging_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Ktoś mógł przygotować wiadomość. Numer i oddech ją testują.", "Someone could have staged it. The number and breath test that.", &"staging", "listen_then_verify_caller")
	_register_beat(&"s12_verify_voice", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Domknę balkon, wysłucham całości, sprawdzę numer i zapiszę pytania.", "Close the balcony, hear it all, verify the number, then write questions.", &"", "")
	_register_beat(&"s12_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Domknij balkon, potem sekretarka, rejestr i notes.", "HINT: Close the balcony, then the machine, the caller list, and the notepad.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_12"
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

func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	match id:
		"jakub_questions":
			ask_jakub_control_questions()
		"jakub_meeting":
			meet_jakub()
		"jakub_refusal":
			accept_jakub_refusal()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


var _balcony_progress := 0.0


func close_balcony() -> bool:
	if is_balcony_closed or not _has(FACT_S04_TRACE):
		_record_feedback(&"identity_trace_required")
		return false
	is_balcony_closed = true
	_record(&"p9.threshold_obstacle.marta_threshold.balcony_closed", true)
	if balcony_door:
		ExitClearance._disable_shapes(balcony_door)
	_report_progress(&"s12_balcony_closed")
	queue_redraw()
	return true


func _process(delta: float) -> void:
	if is_balcony_closed and _balcony_progress < 1.0:
		_balcony_progress = minf(1.0, _balcony_progress + delta * 1.6)
		if balcony_door:
			balcony_door.position.x = lerpf(BALCONY_OPEN_X, BALCONY_CLOSED_X, _balcony_progress)
	queue_redraw()


func listen_to_message() -> bool:
	if is_message_heard:
		return false
	if not is_balcony_closed:
		_record_feedback(&"balcony_open")
		return false
	is_message_heard = true
	is_voice_observed = true
	_record(FACT_VOICE, true)
	message_heard.emit()
	if guidance_service:
		guidance_service.trigger_beat(&"s12_staging_hypothesis")
	_report_progress(&"s12_message_heard")
	queue_redraw()
	return true


func verify_caller_identity() -> bool:
	if is_caller_verified or not is_message_heard:
		_record_feedback(&"message_heard_required")
		return false
	is_caller_verified = true
	_record(FACT_CALLER, "marta_call_22_20")
	if guidance_service:
		guidance_service.close_hypothesis(&"staging")
	_report_progress(&"s12_caller_verified")
	queue_redraw()
	return true


func prepare_independent_questions() -> bool:
	if are_questions_prepared:
		return false
	if not is_caller_verified:
		_record_feedback(&"caller_required")
		return false
	are_questions_prepared = true
	_record(FACT_QUESTIONS, true)
	questions_prepared.emit()
	_report_progress(&"s12_questions_prepared")
	_unlock_exit()
	queue_redraw()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s12_" + value)


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
	return state != null and not String(state.decisions.get(key, "")).is_empty()


func _record(key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(key, value)

func _is_resolved(id: String) -> bool:
	match id:
		"jakub_questions": return _decision_bool(P9_QUESTIONS)
		"jakub_meeting": return _decision_bool(P9_MEETING)
		"jakub_refusal": return _decision_bool(P9_REFUSAL)
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	# PKG-0187 visual-family repair: a service workshop with one real recorder
	# machine, working rail and balcony draft. Jakub remains the rig at the bench.
	VectorStageStyle.draw_stage_apron(self, Vector2(640.0, 360.0))
	VectorStageStyle.draw_play_plane(self, geometry)
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), Color("172026"))
	draw_rect(Rect2(0.0, 0.0, 640.0, 76.0), Color("30434a"))
	draw_rect(Rect2(0.0, 76.0, 640.0, 228.0), Color("27363b"))
	# Cable tray and angled service pipes lead toward the recorder rather than
	# becoming decorative diagonals.
	draw_rect(Rect2(42.0, 88.0, 428.0, 14.0), Color("4a5f65"))
	for x in range(64, 446, 48):
		draw_line(Vector2(float(x), 102.0), Vector2(float(x + 18), 128.0), Color("6e8587"), 3.0)
	draw_line(Vector2(382.0, 102.0), Vector2(504.0, 188.0), Color("71888a"), 8.0)
	draw_line(Vector2(504.0, 188.0), Vector2(574.0, 120.0), Color("71888a"), 8.0)
	# Answering-machine rack: its two reels belong to a recognisable service unit.
	draw_rect(Rect2(62.0, 132.0, 218.0, 140.0), Color("40545a"))
	draw_rect(Rect2(72.0, 142.0, 198.0, 120.0), Color("56696b"))
	draw_rect(Rect2(92.0, 160.0, 158.0, 82.0), Color("1b2529"))
	draw_circle(Vector2(132.0, 201.0), 28.0, Color("314149"))
	draw_circle(Vector2(132.0, 201.0), 10.0, Color("d39a62"))
	draw_circle(Vector2(210.0, 201.0), 28.0, Color("314149"))
	draw_circle(Vector2(210.0, 201.0), 10.0, Color("82949a"))
	draw_line(Vector2(160.0, 201.0), Vector2(182.0, 201.0), Color("d3d0c5"), 2.0)
	draw_rect(Rect2(104.0, 238.0, 132.0, 8.0), Color("8b9a94"))
	for x in [112.0, 132.0, 152.0, 172.0, 192.0, 212.0]:
		draw_rect(Rect2(x, 248.0, 8.0, 8.0), Color("d39a62"))
	# Workbench, vice and tool rail give Jakub's professional position a body.
	draw_rect(Rect2(282.0, 254.0, 162.0, 16.0), Color("4b5e62"))
	draw_line(Vector2(296.0, 270.0), Vector2(290.0, 304.0), Color("4b5e62"), 4.0)
	draw_line(Vector2(426.0, 270.0), Vector2(434.0, 304.0), Color("4b5e62"), 4.0)
	draw_rect(Rect2(342.0, 234.0, 32.0, 20.0), Color("1d2b37"))
	draw_line(Vector2(350.0, 234.0), Vector2(350.0, 220.0), Color("b6c6c2"), 2.0)
	draw_line(Vector2(366.0, 234.0), Vector2(366.0, 220.0), Color("b6c6c2"), 2.0)
	draw_rect(Rect2(454.0, 154.0, 54.0, 92.0), Color("40545a"))
	for y in range(166, 234, 16):
		draw_line(Vector2(462.0, float(y)), Vector2(500.0, float(y)), Color("9eb2ae"), 1.0)
	draw_rect(Rect2(0.0, 304.0, 640.0, 56.0), Color("1b2529"))
	draw_line(Vector2(0.0, 304.0), Vector2(640.0, 304.0), Color("82949a"), 2.0)

func ask_jakub_control_questions() -> bool:
	if _decision_bool(P9_QUESTIONS) or not _has(&"p9.mystery.institution.trace"):
		return false
	_record(P9_QUESTIONS, true)
	# PKG-0191: the two control questions through the link are literally
	# hearing Jakub's voice.
	_record(CANON_VOICE_HEARD, true)
	queue_redraw()
	return true
func meet_jakub() -> bool:
	if _decision_bool(P9_MEETING) or not _decision_bool(P9_QUESTIONS):
		return false
	_record(P9_MEETING, true)
	# PKG-0191: the bodily meeting is the material action that establishes
	# Jakub as a met person, not only a voice.
	_record(CANON_MET_AS_PERSON, true)
	queue_redraw()
	return true

func accept_jakub_refusal() -> bool:
	if _decision_bool(P9_REFUSAL) or not _decision_bool(P9_MEETING):
		return false
	_record(P9_REFUSAL, true)
	_record(P9_TRACE, "voluntary_proof_after_refusal")
	# PKG-0191: accepting the refusal without pressure is the terminal
	# Station 12 action; it completes the relational evidence family (living
	# Jakub plus the memory difference) used by Station 13's synthesis gate.
	_record(CANON_EVIDENCE_RELATIONAL, true)
	_unlock_exit()
	queue_redraw()
	return true

func _decision_bool(key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	return state != null and state.decisions.get(key, false) == true
