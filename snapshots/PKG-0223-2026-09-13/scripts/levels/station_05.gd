class_name Station05
extends Node2D

## Station 05 — Home street baseline (Rodzina 1: Zewnętrzna / Miejska).
## Lena wraca znaną ulicą w stronę domu; otoczenie jest zwyczajne, nocne,
## a deszcz i ruch uliczny potwierdzają stabilny punkt odniesienia przed pojawieniem się rozbieżności.
##
## PRZESZKODA — dlaczego to tu jest: Przejście dla pieszych i sygnalizacja uliczna regulują ruch nocny, a odcinek drogi do domu wymaga sprawdzenia trasy i zabezpieczonej próbki.
## PRZESZKODA — czego wymaga od Leny: potwierdzenia zwyczajnej trasy miejskiej, sprawdzenia torby ze sprzętem i przejścia przez pasy.
## PRZESZKODA — koszt porażki: przejście ulicy bez sprawdzenia sprzętu zostawia wątpliwość co do stanu próbki po wyjściu z tramwaju.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_STREET := &"p7.return_under_control.ordinary_street_observed"
const FACT_SECURED := &"p7.return_under_control.reader_secured"
const FACT_TRACE := &"p7.return_under_control.trace"
const FACT_FEEDBACK := &"p7.return_under_control.safe_trial_feedback"

signal street_route_checked()
signal sample_case_verified()
signal crossing_completed()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var return_zone: Area2D = $ReturnZone
@onready var dialogue: CRTDialogueBox = $CRTDialogueBox
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_street_route_checked := false
var is_sample_case_verified := false
var is_crossing_completed := false
var is_exit_unlocked := false
var is_level_completed := false


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_action_points()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	# PKG-0221 (D-234): ReturnZone wylacznikiem interactu (trigger_return);
	# overlap stacji nie progresuje — wlasnego podpiecia brak.
	_set_action_available(&"check_sample_case", false)
	_set_action_available(&"cross_street_towards_home", false)
	queue_redraw()


func _connect_action_points() -> void:
	for child in props.get_children():
		if child is OpeningActionPoint:
			var action := child as OpeningActionPoint
			if not action.action_requested.is_connected(_on_action_requested):
				action.action_requested.connect(_on_action_requested)


func _on_action_requested(action_id: StringName) -> void:
	match action_id:
		&"check_street_route":
			check_street_route()
		&"check_sample_case":
			check_sample_case()
		&"cross_street_towards_home":
			cross_street_towards_home()


func check_street_route() -> bool:
	if is_street_route_checked:
		return false
	is_street_route_checked = true
	_record(FACT_STREET, true)
	_record(&"p9.street.home_street_observed", true)
	_resolve_action(&"check_street_route")
	_set_action_available(&"check_sample_case", true)
	street_route_checked.emit()
	_present([
		{"speaker": "LENA", "text": "Moja ulica. Za rogiem Sadowa i dom. Wszystko wygląda tak samo jak rano."},
	])
	queue_redraw()
	return true


func check_sample_case() -> bool:
	if not is_street_route_checked or is_sample_case_verified:
		_record_feedback(&"street_check_required")
		return false
	is_sample_case_verified = true
	_record(FACT_SECURED, true)
	_record(&"p9.street.sample_case_verified", true)
	_resolve_action(&"check_sample_case")
	_set_action_available(&"cross_street_towards_home", true)
	sample_case_verified.emit()
	# CR-D (PKG-0196, E02): torba mówi prawdę gałęzi z 01. Bez powtórzonego
	# pomiaru nie ma w niej surowej próbki — jest spakowany czytnik.
	var carried_sample := _decision_string(&"p9.opening.choice") != "leave_on_time"
	_present([
		{"speaker": "LENA", "text": "Surowa próbka drgań jest w torbie. Sprawdzę cały raport jutro z Martą." if carried_sample else "W torbie spakowany czytnik. Surowego zapisu nie wzięłam — tak wybrałam."},
	])
	queue_redraw()
	return true


func cross_street_towards_home() -> bool:
	if not is_sample_case_verified or is_crossing_completed:
		_record_feedback(&"sample_check_required")
		return false
	is_crossing_completed = true
	_record(FACT_TRACE, "reader_secured_without_paranormal_claim")
	_record(&"ordinary_return_complete", true)
	_record(&"p9.street.crossing_completed", true)
	_resolve_action(&"cross_street_towards_home")
	crossing_completed.emit()
	_present([
		{"speaker": "LENA", "text": "Zielone światło na przejściu. Jeszcze tylko woda w kiosku i jestem w domu."},
	])
	_unlock_exit()
	queue_redraw()
	return true


## Backward compatibility for PKG-0146 early diagnostic tests
func observe_ordinary_street() -> bool:
	return check_street_route()


func secure_reader_state() -> bool:
	if not is_street_route_checked:
		check_street_route()
	if not is_sample_case_verified:
		check_sample_case()
	return cross_street_towards_home()


func unlock_exit_for_return() -> void:
	_unlock_exit()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	pass  # PKG-0174: ThresholdZone requires interact


func _complete_if_player_already_in_airlock() -> void:
	if airlock_zone != null and player != null and airlock_zone.overlaps_body(player):
		_trigger_level_completion()


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s05_composition", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s05_reaction", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Zwykła ulica. Deszcz pada tak samo jak rano.", "An ordinary street. The rain falls just like this morning.", &"", "")
	_register_beat(&"s05_thought", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Wszystko wygląda normalnie. Sprawdzę torbę przed skrzyżowaniem.", "Everything looks normal. I will check my bag before the crossing.", &"street_baseline", "check_sample_case")
	_register_beat(&"s05_intent", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Sprawdzę próbkę i przejdę przez pasy.", "I will check the sample and cross at the signal.", &"", "")
	_register_beat(&"s05_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Sprawdź ulicę, torbę ze sprzętem i przejdź przez pasy.", "HINT: Check the street, inspect your equipment case, and cross the street.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_05"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	beat.predicted_check = predicted_check
	guidance_service.register_beat(beat)


func _on_airlock_body_entered(_body: Node2D) -> void:
	# PKG-0174: AirlockZone is a closure zone, not a trigger.
	pass


func _on_return_zone_body_entered(_body: Node2D) -> void:
	# PKG-0221 (D-234): ReturnZone is a closure zone, not a trigger.
	pass


func _trigger_level_completion() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	GapLedger.annotate_feedback(self, value) # PKG-0215 (D-228): blocked verb speaks its gap, if any.


func _decision_string(key: StringName) -> String:
	var state := get_node_or_null("/root/GameStateManager")
	return "" if state == null else String(state.decisions.get(key, ""))


func _record(key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(key, value)


func _resolve_action(action_id: StringName) -> void:
	var action := _find_action(action_id)
	if action != null:
		action.resolve()


func _set_action_available(action_id: StringName, available: bool) -> void:
	var action := _find_action(action_id)
	if action != null:
		action.set_available(available)


func _find_action(action_id: StringName) -> OpeningActionPoint:
	for child in props.get_children():
		if child is OpeningActionPoint and (child as OpeningActionPoint).action_id == action_id:
			return child as OpeningActionPoint
	return null


func _present(lines: Array) -> void:
	if dialogue != null:
		dialogue.present(lines)


func _draw() -> void:
	VectorStageStyle.draw_stage_apron(self, Vector2(640.0, 360.0))
	# Open sky: ≥ 25% height (y: 0 to 110 px), no ceiling!
	draw_rect(Rect2(0.0, 0.0, 640.0, 110.0), VectorStageStyle.INK)
	# Distant rooftops and night horizon
	draw_colored_polygon(PackedVector2Array([
		Vector2(0.0, 110.0), Vector2(120.0, 85.0), Vector2(210.0, 95.0),
		Vector2(380.0, 75.0), Vector2(510.0, 90.0), Vector2(640.0, 80.0),
		Vector2(640.0, 110.0),
	]), VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.40))
	# Mid plane: Tenement facades, vertical rhythm, windows every 28 px
	draw_rect(Rect2(0.0, 110.0, 640.0, 196.0), VectorStageStyle.DEEP_PLANE)
	for x in range(30, 610, 56):
		draw_rect(Rect2(float(x), 130.0, 24.0, 36.0), VectorStageStyle.INK)
		draw_rect(Rect2(float(x + 2), 132.0, 20.0, 32.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.25), false, 1.0)
		draw_rect(Rect2(float(x), 190.0, 24.0, 36.0), VectorStageStyle.INK)
		draw_rect(Rect2(float(x + 2), 192.0, 20.0, 32.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.25), false, 1.0)
	# Streetlamp on x=240
	draw_line(Vector2(240.0, 296.0), Vector2(240.0, 140.0), VectorStageStyle.LIGHT_PLANE, 2.5)
	draw_line(Vector2(240.0, 140.0), Vector2(258.0, 134.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	draw_circle(Vector2(258.0, 136.0), 4.0, VectorStageStyle.HUMAN_AMBER)
	# Sidewalk & Roadway (near plane)
	draw_rect(Rect2(0.0, 306.0, 640.0, 54.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.30))
	draw_line(Vector2(0.0, 306.0), Vector2(640.0, 306.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	# Pedestrian crossing (Zebra stripes on x=440..560)
	for zx in [450.0, 480.0, 510.0, 540.0]:
		draw_line(Vector2(zx, 312.0), Vector2(zx + 18.0, 336.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.45), 4.0)
	# Signpost / Street sign at x=160
	var sign_color := VectorStageStyle.ANCHOR_CYAN if is_street_route_checked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(160.0, 306.0), Vector2(160.0, 240.0), VectorStageStyle.MID_PLANE, 2.0)
	draw_rect(Rect2(146.0, 230.0, 28.0, 14.0), sign_color, false, 1.5)
	# Bag/Sample marker at x=320
	var bag_color := VectorStageStyle.ANCHOR_CYAN if is_sample_case_verified else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(310.0, 284.0, 20.0, 14.0), bag_color, false, 1.5)
	# Crossing signal at x=480
	var signal_color := VectorStageStyle.ANCHOR_CYAN if is_crossing_completed else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(480.0, 306.0), Vector2(480.0, 220.0), VectorStageStyle.MID_PLANE, 2.0)
	draw_circle(Vector2(480.0, 226.0), 5.0, signal_color)
	# PKG-0198 (ZERO wycinek 2): cień kontaktowy latarni i oznakowania
	# w prawo, 0.48, zgodnie z latarnią x=240 i konwencją 01/06/08.
	draw_colored_polygon(PackedVector2Array([
		Vector2(140.0, 302.0), Vector2(500.0, 300.0),
		Vector2(508.0, 308.0), Vector2(148.0, 310.0),
	]), Color(VectorStageStyle.INK, 0.48))
