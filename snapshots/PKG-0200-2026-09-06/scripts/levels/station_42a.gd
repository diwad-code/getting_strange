class_name Station42A
extends Node2D

## Station 42A — P9 PHASE-06, wymuszenie powrotu przybyłej Leny.
## Znane mieszkanie z 09/10/13 o świcie: ta sama bryła, jeden zmieniony fakt
## o osobach (puste krzesło i zapieczętowany próg). Lena wykonuje powrót,
## odczytuje stan zamkniętej drugiej Leny i skutek dla osób w tej przestrzeni.
## Pytanie, z którym gracz wychodzi: „co zrobiłam drugiej mnie?".

## PRZESZKODA — dlaczego to tu jest: Rygiel powrotu stoi przy drzwiach, bo
## metoda force_home zamyka przybyłą Lenę w jej adresie; próg między
## adresami zostaje zapieczętowany, a stół zachowuje dwa miejsca, z których
## jedno jest puste.
## PRZESZKODA — czego wymaga od Leny: wykonania wymuszonego powrotu, odczytu
## zamkniętej drugiej Leny i odczytu skutku dla Marty i Jakuba w tej przestrzeni.
## PRZESZKODA — koszt porażki: niepełna próba zostawia fakt informacyjny i nie
## zamyka drogi do 43, jeśli 42A jest wybranym wariantem.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const MemoryResonancePoint := preload("res://scripts/interactables/memory_resonance_point.gd")

const FACT_DONOR_METHOD := &"p9.method_commitment.method_committed"
const FACT_CANONICAL_METHOD := &"method_committed"
const FACT_DONOR_MARTA := &"p9.method_commitment.marta_truth_state"
const FACT_CANONICAL_MARTA := &"marta_truth_state"
const FACT_DONOR_SCOPE := &"p9.consent_and_cost.jakub_consent_scope"
const FACT_CANONICAL_SCOPE := &"jakub_consent_state"
const FACT_RETURN := &"p9.finale.forced_return.executed"
const FACT_SEALED := &"p9.finale.forced_return.local_lena_sealed"
const FACT_HOUSEHOLD := &"p9.finale.forced_return.household_consequence"
const FACT_TRACE := &"p9.finale.forced_return.trace"
const FACT_FEEDBACK := &"p9.finale.forced_return.safe_trial_feedback"
const FACT_ENDING_FAMILY := &"ending_family"
const FACT_ENDING_STABILITY := &"ending_stability"
const FACT_CHAMBER_ENTERED := &"p7.conscious_silence_and_presence.chamber_a_entered"
const FACT_WITNESSED := &"p7.conscious_silence_and_presence.final_chamber_witnessed"

const METHOD_FORCE_HOME := "force_home"
const TRACE_VALUE := "forced_return_local_lena_sealed"
const ENDING_FAMILY_VALUE := "force_home"
const MARTA_FULL := "full"
const MARTA_PARTIAL := "partial"
const MARTA_WITHHELD := "withheld"
const SCOPE_GRANTED := "granted"
const SCOPE_LIMITED := "limited"
const SCOPE_REFUSED := "refused"

signal clue_inspected(id: String, prop_type: int)
signal cups_inspected()
signal chamber_a_witnessed()
signal forced_return_executed()
signal other_lena_sealed()
signal household_consequence_read()
signal exit_unlocked()
signal level_completed()
signal previous_level_requested()
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")

## CR-C (PKG-0195): rozmowa wg DIALOGUE_SCRIPT §13 — domowa Marta pyta
## o zniknięcie, Lena kładzie czytnik zamiast odpowiedzieć. Żaden głos nie
## przychodzi zza zamkniętego mostu; Jakub istnieje wyłącznie we wcześniejszym
## zapisie odczytywanym w punkcie skutku. Dostarcza lokalny prezenter CRT
## (wzór CR-A/CR-B) z `creative_scene_lines.gd`; ta tablica zostaje jako
## zgodny, czteroelementowy przebieg rezerwowy (bramka PKG-0107).
const DIALOGUE_LINES: Array[Dictionary] = [
	{"speaker": "MARTA DOMOWA", "text": "Gdzie byłaś?"},
	{"speaker": "LENA", "text": "Kładę czytnik na stole. Zamiast odpowiedzi."},
	{"speaker": "LENA", "text": "Najpierw posłuchaj próbki."},
	{"speaker": "EKRAN CZYTNIKA", "text": "Proponowana etykieta: BŁĄD CZUJNIKA."},
]

var dialogue_lines: Array[Dictionary] = DIALOGUE_LINES
var dialogue_active := false
var dialogue_index := 0
var is_dialogue_completed := false

var is_return_executed := false
var is_other_lena_sealed := false
var is_household_read := false
var is_cups_inspected := false
var is_chamber_a_witnessed := false
var is_exit_unlocked := false
var is_level_completed := false
var last_feedback: StringName = &""
var household_consequence: Dictionary = {}
var marta_truth_state := ""
var jakub_consent_state := ""

var _lamp_phase := 0.0


func _ready() -> void:
	var presentation := preload("res://scripts/levels/creative_scene_presentation.gd").new()
	presentation.name = "CreativeScenePresentation"
	add_child(presentation)
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_props()
	marta_truth_state = _read_marta_truth()
	jakub_consent_state = _read_jakub_consent()
	_record(FACT_CHAMBER_ENTERED, true)
	if _has_force_home():
		_unlock_exit()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	queue_redraw()


func _physics_process(delta: float) -> void:
	_lamp_phase = fmod(_lamp_phase + delta, TAU)


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s42a_dawn_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s42a_empty_chair", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Ten sam stół o świcie. Jedno krzesło puste, próg między adresami zaciśnięty.", "The same table at dawn. One chair empty, the threshold between addresses sealed.", &"", "")
	_register_beat(&"s42a_both_home_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Może powrót ściągnął nas obie. Próg pokaże, czy to prawda.", "Maybe the return pulled us both. The threshold will show if that is true.", &"other_lena_comes_home_too", "read_sealed_other_lena")
	_register_beat(&"s42a_read_plan", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zamknę rygiel powrotu, odczytam zapieczętowany próg i stół.", "Close the return latch, read the sealed threshold and the table.", &"", "execute_forced_return")
	_register_beat(&"s42a_sealed_seen", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Ona zostaje między adresami. Kanał jest zamknięty.", "She stays between addresses. The channel is closed.", &"", "")
	_register_beat(&"s42a_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Rygiel powrotu, zapieczętowany próg, stół z pustym krzesłem.", "HINT: Return latch, sealed threshold, table with the empty chair.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_42a"
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
		"forced_return_latch", "prop_return_cups", "return_cups":
			execute_forced_return()
		"sealed_other_lena":
			read_sealed_other_lena()
		"household_consequence":
			read_household_consequence()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)
	interaction_triggered.emit(id)


func execute_forced_return() -> bool:
	if is_return_executed:
		return false
	if not _has_force_home():
		_record_feedback(&"method_force_home_required")
		return false
	is_return_executed = true
	is_cups_inspected = true
	_record(FACT_RETURN, true)
	_record(FACT_ENDING_FAMILY, ENDING_FAMILY_VALUE)
	if guidance_service:
		guidance_service.trigger_beat(&"s42a_empty_chair")
	_report_progress(&"s42a_return_executed")
	forced_return_executed.emit()
	cups_inspected.emit()
	_unlock_exit()
	queue_redraw()
	return true


func inspect_cups() -> bool:
	return execute_forced_return()


func read_sealed_other_lena() -> bool:
	if is_other_lena_sealed:
		return false
	if not _has_force_home():
		_record_feedback(&"method_force_home_required")
		return false
	is_other_lena_sealed = true
	is_chamber_a_witnessed = true
	_record(FACT_SEALED, true)
	_record(FACT_WITNESSED, true)
	_record(FACT_TRACE, TRACE_VALUE)
	if guidance_service:
		guidance_service.close_hypothesis(&"other_lena_comes_home_too")
		guidance_service.trigger_beat(&"s42a_sealed_seen")
	_report_progress(&"s42a_other_lena_sealed")
	other_lena_sealed.emit()
	chamber_a_witnessed.emit()
	_unlock_exit()
	queue_redraw()
	return true


func witness_chamber_a() -> bool:
	return read_sealed_other_lena()


func read_household_consequence() -> bool:
	if is_household_read:
		return false
	if not _has_force_home():
		_record_feedback(&"method_force_home_required")
		return false
	marta_truth_state = _read_marta_truth()
	jakub_consent_state = _read_jakub_consent()
	household_consequence = {
		"marta": marta_truth_state if not marta_truth_state.is_empty() else MARTA_PARTIAL,
		"jakub": jakub_consent_state if not jakub_consent_state.is_empty() else SCOPE_LIMITED,
		"empty_place": "sealed_other_lena",
	}
	is_household_read = true
	_record(FACT_HOUSEHOLD, household_consequence)
	_record(FACT_ENDING_STABILITY, _stability_from_household())
	if guidance_service:
		guidance_service.trigger_beat(&"s42a_read_plan")
	_report_progress(&"s42a_household_read")
	household_consequence_read.emit()
	_unlock_exit()
	queue_redraw()
	return true


func advance_dialogue() -> void:
	if dialogue_index < dialogue_lines.size() - 1:
		dialogue_index += 1
		dialogue_advanced.emit(dialogue_index)
		_show_dialogue_line(dialogue_index)
	else:
		is_dialogue_completed = true
		dialogue_active = false
		if dialogue_box and dialogue_box.has_method("hide_box"):
			dialogue_box.hide_box()
	queue_redraw()


func _show_dialogue_line(idx: int) -> void:
	if idx < 0 or idx >= dialogue_lines.size():
		return
	var line: Dictionary = dialogue_lines[idx]
	if dialogue_box and dialogue_box.has_method("show_line"):
		dialogue_box.show_line(line.get("speaker", "LENA"), line.get("text", ""))


func _stability_from_household() -> String:
	var marta := str(household_consequence.get("marta", ""))
	var jakub := str(household_consequence.get("jakub", ""))
	if marta == MARTA_WITHHELD or jakub == SCOPE_REFUSED:
		return "withheld_or_refused_gaps"
	if marta == MARTA_PARTIAL or jakub == SCOPE_LIMITED:
		return "partial_gaps"
	return "named_gaps"


func _record_feedback(value: StringName) -> void:
	last_feedback = value
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s42a_" + value)


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
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


func _has_force_home() -> bool:
	var namespaced := str(_read_decision(FACT_DONOR_METHOD))
	var canonical := str(_read_decision(FACT_CANONICAL_METHOD))
	return namespaced == METHOD_FORCE_HOME or canonical == METHOD_FORCE_HOME


func _read_marta_truth() -> String:
	var namespaced := str(_read_decision(FACT_DONOR_MARTA))
	if namespaced in [MARTA_FULL, MARTA_PARTIAL, MARTA_WITHHELD]:
		return namespaced
	var canonical := str(_read_decision(FACT_CANONICAL_MARTA))
	if canonical in [MARTA_FULL, MARTA_PARTIAL, MARTA_WITHHELD]:
		return canonical
	return ""


func _read_jakub_consent() -> String:
	var scoped := str(_read_decision(FACT_DONOR_SCOPE))
	if scoped in [SCOPE_GRANTED, SCOPE_LIMITED, SCOPE_REFUSED]:
		return scoped
	var canonical := str(_read_decision(FACT_CANONICAL_SCOPE))
	if canonical in [SCOPE_GRANTED, SCOPE_LIMITED, SCOPE_REFUSED]:
		return canonical
	return ""


func _read_decision(id: StringName) -> Variant:
	var state := get_node_or_null("/root/GameStateManager")
	if state == null:
		return null
	return state.decisions.get(id, null)


func _record(id: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(id, value)


func _is_resolved(id: String) -> bool:
	match id:
		"forced_return_latch", "prop_return_cups", "return_cups":
			return is_return_executed
		"sealed_other_lena":
			return is_other_lena_sealed
		"household_consequence":
			return is_household_read
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	_draw_dawn_apartment()
	_draw_return_latch()
	_draw_sealed_threshold()
	_draw_household_table()
	_draw_exit()
	queue_redraw()


func _draw_dawn_apartment() -> void:
	# Rodzina finałowa: znana mieszkalna bryła (niski sufit, dwa komplety
	# codziennych rzeczy) o świcie. Ta sama armatura, inna pora. Jeden
	# zmieniony fakt o osobach: puste krzesło i zapieczętowany próg.
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), VectorStageStyle.INK)
	draw_rect(Rect2(0.0, 0.0, 640.0, 148.0), VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.22))
	draw_line(Vector2(0.0, 148.0), Vector2(640.0, 148.0), VectorStageStyle.MID_PLANE, 2.0)
	draw_rect(Rect2(0.0, 148.0, 640.0, 158.0), VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.08))
	# Okno o świcie — ta sama rama, chłodniejsze światło.
	draw_rect(Rect2(36.0, 164.0, 72.0, 86.0), VectorStageStyle.INK)
	var dawn := 0.22 + 0.06 * sin(_lamp_phase * 0.7)
	draw_rect(Rect2(40.0, 168.0, 64.0, 78.0), Color(VectorStageStyle.HUMAN_AMBER, dawn))
	draw_line(Vector2(72.0, 168.0), Vector2(72.0, 246.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	draw_rect(Rect2(36.0, 248.0, 72.0, 8.0), VectorStageStyle.MID_PLANE)
	# Dwie lampki na wysokości 47–150 px, przygaszone świtem.
	var lamp := 0.28 + 0.08 * sin(_lamp_phase * 1.1)
	draw_circle(Vector2(168.0, 132.0), 5.0, Color(VectorStageStyle.HUMAN_AMBER, lamp))
	draw_line(Vector2(168.0, 132.0), Vector2(168.0, 148.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	draw_circle(Vector2(488.0, 126.0), 4.0, Color(VectorStageStyle.HUMAN_AMBER, lamp * 0.7))
	draw_line(Vector2(488.0, 126.0), Vector2(488.0, 148.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.2), 1.0)
	# Podłoga / dywan.
	draw_rect(Rect2(0.0, 306.0, 640.0, 54.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.35))
	draw_line(Vector2(0.0, 306.0), Vector2(640.0, 306.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	draw_rect(Rect2(118.0, 300.0, 404.0, 10.0), VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.55))


func _draw_return_latch() -> void:
	var latch_color := VectorStageStyle.ANCHOR_CYAN if is_return_executed else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(132.0, 188.0, 88.0, 112.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.18))
	draw_rect(Rect2(132.0, 188.0, 88.0, 112.0), latch_color, false, 1.5)
	draw_rect(Rect2(148.0, 204.0, 56.0, 72.0), VectorStageStyle.INK)
	draw_line(Vector2(176.0, 204.0), Vector2(176.0, 276.0), latch_color, 2.0)
	draw_circle(Vector2(198.0, 248.0), 4.0, latch_color)
	if is_return_executed:
		draw_line(Vector2(148.0, 236.0), Vector2(204.0, 236.0), latch_color, 2.0)


func _draw_sealed_threshold() -> void:
	var seal_color := VectorStageStyle.ANCHOR_CYAN if is_other_lena_sealed else VectorStageStyle.CORRECTION_OXIDE
	draw_rect(Rect2(286.0, 168.0, 92.0, 138.0), VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.12))
	draw_rect(Rect2(286.0, 168.0, 92.0, 138.0), seal_color, false, 1.5)
	# Druga, nierozstrzygalna sylwetka za szwem.
	draw_rect(Rect2(304.0, 196.0, 28.0, 86.0), Color(seal_color, 0.22))
	draw_rect(Rect2(338.0, 196.0, 22.0, 86.0), Color(VectorStageStyle.INK, 0.55))
	draw_line(Vector2(332.0, 168.0), Vector2(332.0, 306.0), seal_color, 2.0)
	draw_line(Vector2(292.0, 188.0), Vector2(368.0, 188.0), VectorStageStyle.shade(seal_color, 0.25), 1.0)
	if is_other_lena_sealed:
		draw_line(Vector2(304.0, 250.0), Vector2(360.0, 250.0), seal_color, 2.0)


func _draw_household_table() -> void:
	var table_color := VectorStageStyle.ANCHOR_CYAN if is_household_read else VectorStageStyle.HUMAN_AMBER
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(424.0, 248.0), Vector2(556.0, 244.0),
			Vector2(560.0, 278.0), Vector2(420.0, 282.0),
		]),
		VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.12),
	)
	draw_line(Vector2(424.0, 248.0), Vector2(556.0, 244.0), table_color, 1.5)
	# Dwa kubki — jeden użyty, jeden zimny.
	var used := VectorStageStyle.HUMAN_AMBER if is_return_executed else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.4)
	draw_colored_polygon(
		PackedVector2Array([Vector2(452.0, 236.0), Vector2(470.0, 234.0), Vector2(472.0, 250.0), Vector2(454.0, 252.0)]),
		used,
	)
	draw_colored_polygon(
		PackedVector2Array([Vector2(498.0, 234.0), Vector2(516.0, 232.0), Vector2(518.0, 248.0), Vector2(500.0, 250.0)]),
		VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.45),
	)
	# Puste krzesło — zmieniony fakt o osobach.
	draw_rect(Rect2(508.0, 258.0, 28.0, 40.0), Color(0, 0, 0, 0), false)
	draw_line(Vector2(512.0, 298.0), Vector2(512.0, 262.0), table_color, 1.5)
	draw_line(Vector2(532.0, 298.0), Vector2(532.0, 262.0), table_color, 1.5)
	draw_line(Vector2(512.0, 262.0), Vector2(532.0, 262.0), table_color, 1.5)
	draw_line(Vector2(508.0, 278.0), Vector2(536.0, 278.0), VectorStageStyle.shade(table_color, 0.3), 1.0)
	if is_household_read:
		draw_circle(Vector2(462.0, 242.0), 3.0, table_color)


func _draw_exit() -> void:
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(572.0, 146.0, 48.0, 12.0), exit_color, false, 1.5)
	draw_line(Vector2(610.0, 158.0), Vector2(610.0, 296.0), exit_color, 2.0)
	draw_line(Vector2(584.0, 296.0), Vector2(620.0, 296.0), exit_color, 2.0)
	# PKG-0198 (ZERO wycinek 2): cień kontaktowy stołu domowego w prawo, 0.48,
	# zgodnie z lampkami świtu (168,132 / 488,126). Finał: cisza z jednym
	# źródłem (dron rigu); brak dodatkowego pozycjonowanego humu — decyzja jawna.
	draw_colored_polygon(PackedVector2Array([
		Vector2(416.0, 298.0), Vector2(564.0, 294.0),
		Vector2(572.0, 302.0), Vector2(424.0, 306.0),
	]), Color(VectorStageStyle.INK, 0.48))
