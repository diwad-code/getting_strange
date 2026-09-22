class_name Station08
extends Node2D

## Station 08 — Stairwell and threshold (Rodzina 3: Mieszkalna wspólna / Klatka schodowa).
## Przejście ze strefy miejskiej do mieszkalnej: niski sufit, klatka schodowa,
## sąsiadka witająca Lenę jako stałą lokatorkę lokalu 14 i działający fizyczny klucz w zamku.
##
## PRZESZKODA — dlaczego to tu jest: Drzwi mieszkania 14 są zamknięte na zamek bębenkowy, a wejście wymaga fizycznego klucza Leny.
## PRZESZKODA — czego wymaga od Leny: sprawdzenia drzwi lokalu 12, wysłuchania relacji sąsiadki i przekręcenia własnego klucza w zamku 14.
## PRZESZKODA — koszt porażki: wejście bez rozmowy z sąsiadką nie potwierdza obecności Marty za progiem.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_NEIGHBOUR_ASKED := &"p7.foreign_daily_life.neighbour_asked"
const FACT_NEIGHBOUR_ANSWER := &"p7.foreign_daily_life.neighbour_answer"
const FACT_CAUTIOUS_ENTRY := &"p7.foreign_daily_life.cautious_entry_committed"
const FACT_TRACE := &"p7.foreign_daily_life.trace"
const FACT_FEEDBACK := &"p7.foreign_daily_life.safe_trial_feedback"

signal door_twelve_inspected()
signal neighbour_spoken_to()
signal apartment_fourteen_unlocked()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var props: Node2D = $Props
@onready var apartment_door: AnimatableBody2D = $ApartmentDoor14
@onready var airlock_zone: Area2D = $AirlockZone
@onready var return_zone: Area2D = $ReturnZone
@onready var dialogue: CRTDialogueBox = $CRTDialogueBox
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_door_twelve_inspected := false
var is_neighbour_spoken_to := false
var is_apartment_fourteen_unlocked := false
var is_exit_unlocked := false
var is_level_completed := false


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_action_points()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	if return_zone != null and not return_zone.body_entered.is_connected(_on_return_zone_body_entered):
		return_zone.body_entered.connect(_on_return_zone_body_entered)
	_set_action_available(&"speak_with_neighbour", false)
	_set_action_available(&"unlock_apartment_fourteen", false)
	queue_redraw()


func _connect_action_points() -> void:
	for child in props.get_children():
		if child is OpeningActionPoint:
			var action := child as OpeningActionPoint
			if not action.action_requested.is_connected(_on_action_requested):
				action.action_requested.connect(_on_action_requested)


func _on_action_requested(action_id: StringName) -> void:
	match action_id:
		&"inspect_floor_twelve":
			inspect_floor_twelve()
		&"speak_with_neighbour":
			speak_with_neighbour()
		&"unlock_apartment_fourteen":
			unlock_apartment_fourteen()


func inspect_floor_twelve() -> bool:
	if is_door_twelve_inspected:
		return false
	is_door_twelve_inspected = true
	_record(&"p9.stairwell.door_twelve_inspected", true)
	_resolve_action(&"inspect_floor_twelve")
	_set_action_available(&"speak_with_neighbour", true)
	door_twelve_inspected.emit()
	_present([
		{"speaker": "LENA", "text": "Drzwi numer 12. Mosiężna tabliczka 'Kowalczyk'. Mój klucz nawet nie pasuje do profilu tego zamka."},
	])
	queue_redraw()
	return true


func speak_with_neighbour() -> bool:
	if not is_door_twelve_inspected or is_neighbour_spoken_to:
		_record_feedback(&"door_twelve_check_required")
		return false
	is_neighbour_spoken_to = true
	_record(FACT_NEIGHBOUR_ASKED, true)
	_record(FACT_NEIGHBOUR_ANSWER, "door_14_confirmed")
	_record(&"marta_relationship_disclosed", true)
	_record(&"p9.stairwell.neighbour_testimony_heard", true)
	_resolve_action(&"speak_with_neighbour")
	_set_action_available(&"unlock_apartment_fourteen", true)
	neighbour_spoken_to.emit()
	_present([
		{"speaker": "SĄSIADKA", "text": "Dobry wieczór, pani Leno! Marta wróciła godzinę temu, czeka na panią pod czternastką."},
		{"speaker": "LENA", "text": "Dobry wieczór... Dziękuję pani."},
	])
	queue_redraw()
	return true


func unlock_apartment_fourteen() -> bool:
	if not is_neighbour_spoken_to or is_apartment_fourteen_unlocked:
		_record_feedback(&"neighbour_testimony_required")
		return false
	is_apartment_fourteen_unlocked = true
	_record(FACT_CAUTIOUS_ENTRY, true)
	_record(FACT_TRACE, "neighbour_and_key_confirm_fourteen")
	_record(&"p9.stairwell.key_unlocked_fourteen", true)
	_resolve_action(&"unlock_apartment_fourteen")
	apartment_fourteen_unlocked.emit()
	_present([
		{"speaker": "LENA", "text": "Mój klucz wchodzi gładko. Zapadka ustępuje bez najmniejszego oporu. Drzwi się otwierają."},
	])
	_unlock_exit()
	queue_redraw()
	return true


## Backward compatibility for PKG-0146 early diagnostic tests
func read_certificate() -> bool:
	return inspect_floor_twelve()


func read_directory() -> bool:
	if not is_door_twelve_inspected:
		inspect_floor_twelve()
	return speak_with_neighbour()


func test_intercom_recognition() -> bool:
	if not is_neighbour_spoken_to:
		speak_with_neighbour()
	return unlock_apartment_fourteen()


func unlock_exit_for_return() -> void:
	_unlock_exit()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	if apartment_door != null:
		ExitClearance.disable_collision(apartment_door)
	pass  # PKG-0174: ThresholdZone requires interact


func _complete_if_player_already_in_airlock() -> void:
	if airlock_zone != null and player != null and airlock_zone.overlaps_body(player):
		_trigger_level_completion()


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s08_composition", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s08_reaction", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Znajoma klatka schodowa. Sąsiadka wita mnie jak stałą lokatorkę.", "A familiar stairwell. The neighbour greets me like a resident.", &"", "")
	_register_beat(&"s08_thought", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Dlaczego sąsiadka mówi o czternastce? Sprawdzę zamek.", "Why does the neighbour speak of number fourteen? I will check the lock.", &"renumbered_route", "speak_with_neighbour")
	_register_beat(&"s08_renumbering_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Dlaczego sąsiadka mówi o czternastce? Sprawdzę zamek.", "Why does the neighbour speak of number fourteen? I will check the lock.", &"renumbered_route", "speak_with_neighbour")
	_register_beat(&"s08_intent", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Porozmawiam z sąsiadką i sprawdzę zamek czternastki.", "I will speak with the neighbour and test the lock at fourteen.", &"", "")
	_register_beat(&"s08_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Sprawdź drzwi 12, porozmawiaj z sąsiadką i użyj klucza w drzwiach 14.", "HINT: Inspect door 12, talk to the neighbour, and use your key on door 14.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_08"
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


func _on_return_zone_body_entered(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		previous_level_requested.emit()


func _trigger_level_completion() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))


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
	# Low residential ceiling: y=0..36 px (enclosed interior, no sky)
	draw_rect(Rect2(0.0, 0.0, 640.0, 36.0), VectorStageStyle.INK)
	draw_line(Vector2(0.0, 36.0), Vector2(640.0, 36.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	# Upper wall: light cream paint (y=36..210)
	draw_rect(Rect2(0.0, 36.0, 640.0, 174.0), VectorStageStyle.DEEP_PLANE)
	# Lower wall: olive-grey oil lamperia (y=210..296)
	draw_rect(Rect2(0.0, 210.0, 640.0, 86.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.20))
	draw_line(Vector2(0.0, 210.0), Vector2(640.0, 210.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.40), 2.0)
	# Mailboxes bank at x=60..120
	draw_rect(Rect2(60.0, 140.0, 50.0, 60.0), VectorStageStyle.INK)
	draw_rect(Rect2(60.0, 140.0, 50.0, 60.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.30), false, 1.5)
	for my in [155.0, 170.0, 185.0]:
		draw_line(Vector2(65.0, my), Vector2(105.0, my), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.30), 1.0)
	# Wall sconces (warm amber light on y=130)
	for lx in [220.0, 420.0]:
		draw_line(Vector2(lx, 136.0), Vector2(lx, 126.0), VectorStageStyle.LIGHT_PLANE, 2.0)
		draw_circle(Vector2(lx, 126.0), 4.0, VectorStageStyle.HUMAN_AMBER)
	# Door 12 at x=160..210
	var door12_color := VectorStageStyle.ANCHOR_CYAN if is_door_twelve_inspected else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(160.0, 187.0, 45.0, 109.0), VectorStageStyle.INK)
	draw_rect(Rect2(160.0, 187.0, 45.0, 109.0), door12_color, false, 1.5)
	draw_circle(Vector2(168.0, 230.0), 3.0, door12_color)
	# Short real stair flight: five solid blocks, 12 px risers, up to a half-landing
	# and back down. It is residential architecture, not a timed jump obstacle.
	var stair_fill := VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.35)
	for step_rect in [
		Rect2(228.0, 284.0, 44.0, 12.0),
		Rect2(272.0, 272.0, 44.0, 24.0),
		Rect2(316.0, 260.0, 44.0, 36.0),
		Rect2(360.0, 272.0, 44.0, 24.0),
		Rect2(404.0, 284.0, 44.0, 12.0),
	]:
		draw_rect(step_rect, stair_fill)
		draw_line(step_rect.position, Vector2(step_rect.end.x, step_rect.position.y), VectorStageStyle.LIGHT_PLANE, 1.5)
	# Neighbour is CharacterVisualRig `neighbour` (PKG-0186). Do not draw a circle-head.
	# Potted fern planter on landing
	draw_rect(Rect2(366.0, 256.0, 14.0, 16.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.50))
	draw_circle(Vector2(373.0, 252.0), 6.0, VectorStageStyle.ANCHOR_CYAN)
	# Door 14 at x=540..600 (Apartment threshold)
	var door14_color := VectorStageStyle.ANCHOR_CYAN if is_apartment_fourteen_unlocked else VectorStageStyle.HUMAN_AMBER
	pass  # PKG-0174: exit aperture from ThresholdZone
	pass
	draw_circle(Vector2(550.0, 226.0), 4.0, door14_color)
	# Terrazzo floor (near plane)
	draw_rect(Rect2(0.0, 296.0, 640.0, 64.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.30))
	draw_line(Vector2(0.0, 296.0), Vector2(640.0, 296.0), VectorStageStyle.LIGHT_PLANE, 2.0)
