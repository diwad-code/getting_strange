class_name Station42B
extends Node2D

## Station 42B — P9 PHASE-06, oddanie miejscowej Lenie jej ciała i zamknięcie przepływu.
## Znane mieszkanie z 09/10/13 o świcie: ta sama bryła, jeden zmieniony fakt
## o osobach (miejscowa Lena w odzyskanym ciele, przybyła Lena poza indeksem).
## Lena zamyka przepływ Równi, odczytuje stan miejscowej Leny i skutek dla
## osób w tej przestrzeni. Pytanie, z którym gracz wychodzi: „gdzie jestem teraz ja?".

## PRZESZKODA — dlaczego to tu jest: Przepływ Równi zostaje zamknięty przy
## przewodzie wejściowym; próg mieszkania 14 chroni odzyskaną obecność miejscowej
## Leny, a stół zachowuje ślad nieindeksowanej obecności przybyłej Leny.
## PRZESZKODA — czego wymaga od Leny: zamknięcia przepływu Równi, odczytu
## odzyskanej miejscowej Leny i odczytu skutku dla Marty i Jakuba w tej przestrzeni.
## PRZESZKODA — koszt porażki: niepełna próba zostawia fakt informacyjny i nie
## zamyka drogi do 43, jeśli 42B jest wybranym wariantem.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const MemoryResonancePoint := preload("res://scripts/interactables/memory_resonance_point.gd")

const FACT_DONOR_METHOD := &"p9.method_commitment.method_committed"
const FACT_CANONICAL_METHOD := &"method_committed"
const FACT_DONOR_MARTA := &"p9.method_commitment.marta_truth_state"
const FACT_CANONICAL_MARTA := &"marta_truth_state"
const FACT_DONOR_SCOPE := &"p9.consent_and_cost.jakub_consent_scope"
const FACT_CANONICAL_SCOPE := &"jakub_consent_state"

const FACT_FLOW_CLOSED := &"p9.finale.close_equal.flow_closed"
const FACT_EXECUTED := &"p9.finale.close_equal.executed"
const FACT_LOCAL_RECOVERED := &"p9.finale.close_equal.local_lena_recovered"
const FACT_HOUSEHOLD := &"p9.finale.close_equal.household_consequence"
const FACT_TRACE := &"p9.finale.close_equal.trace"
const FACT_FEEDBACK := &"p9.finale.close_equal.safe_trial_feedback"
const FACT_ENDING_FAMILY := &"ending_family"
const FACT_ENDING_STABILITY := &"ending_stability"
const FACT_CHAMBER_ENTERED := &"p7.conscious_silence_and_presence.chamber_b_entered"
const FACT_WITNESSED := &"p7.conscious_silence_and_presence.final_chamber_witnessed"

const METHOD_CLOSE_EQUAL := "close_equal_recover_local"
const TRACE_VALUE := "close_equal_local_lena_recovered"
const ENDING_FAMILY_VALUE := "close_equal_recover_local"
const MARTA_FULL := "full"
const MARTA_PARTIAL := "partial"
const MARTA_WITHHELD := "withheld"
const SCOPE_GRANTED := "granted"
const SCOPE_LIMITED := "limited"
const SCOPE_REFUSED := "refused"

signal clue_inspected(id: String, prop_type: int)
signal flow_closed()
signal local_lena_recovered()
signal household_consequence_read()
signal exit_unlocked()
signal level_completed()
signal previous_level_requested()
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)
signal doorstep_inspected()
signal chamber_b_witnessed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")

## CR-C (PKG-0195): rozmowa wg DIALOGUE_SCRIPT §13 — miejscowa Lena wraca
## rozpoznawalnym gestem (oddech, klucz wstrzymany do odpowiedzi), Marta pyta
## o wiedzę przed testem, a perspektywa przybyłej odcina się do wiaty bez
## indeksu. Bez hasła o dwóch prawdziwych; bez oceny moralnej. Dostarcza
## lokalny prezenter CRT (wzór CR-A/CR-B); tablica zostaje jako zgodny,
## czteroelementowy przebieg rezerwowy (bramka PKG-0107).
const DIALOGUE_LINES: Array[Dictionary] = [
	{"speaker": "MARTA", "text": "Co wiedziałaś przed testem?"},
	{"speaker": "MIEJSCOWA LENA", "text": "Próbę zrobiłam sama. UCP dopisało resztę."},
	{"speaker": "MARTA", "text": "Poznaję twój oddech. Klucz dostaniesz, kiedy odpowiesz."},
	{"speaker": "LENA", "text": "Jestem na wiacie z linii 03. Czytnik nie ma tu adresu."},
]

var dialogue_lines: Array[Dictionary] = DIALOGUE_LINES
var dialogue_active := false
var dialogue_index := 0
var is_dialogue_completed := false

var is_flow_closed := false
var is_local_lena_recovered := false
var is_household_read := false
var is_doorstep_inspected := false
var is_chamber_b_witnessed := false
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
	if _has_close_equal():
		_unlock_exit()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	queue_redraw()


func _physics_process(delta: float) -> void:
	_lamp_phase = fmod(_lamp_phase + delta, TAU)


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s42b_dawn_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s42b_closure_echo", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Miejscowa Lena wraca do swojego życia. Przepływ Równi jest zamknięty.", "Local Lena returns to her life. The flow of the Plane is closed.", &"", "")
	_register_beat(&"s42b_unindexed_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Gdzie jestem teraz ja? Zostałam poza rejestrem instytucji, ale stoję tu naprawdę.", "Where am I now? I remained outside the institution index, but I am standing here.", &"arrived_lena_unindexed_presence", "read_local_lena_recovered")
	_register_beat(&"s42b_read_plan", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zamknąć przepływ, sprawdzić stan miejscowej Leny i przyjąć nieindeksowaną obecność.", "Close the flow, check local Lena's state, and accept unindexed presence.", &"", "execute_close_flow")
	_register_beat(&"s42b_recovered_seen", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Ona jest u siebie. Oddycha i odpowiada sama.", "She is home. She breathes and answers on her own.", &"", "")
	_register_beat(&"s42b_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Zamknięcie przepływu, próg miejscowej Leny, stół nieindeksowanej obecności.", "HINT: Flow closure, local Lena threshold, unindexed presence table.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_42b"
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
		"flow_closure", "prop_flow_closure", "FlowClosureLatch":
			execute_close_flow()
		"local_lena_recovered", "prop_local_lena_recovered", "LocalLenaThreshold", "MartaDoorstep", "prop_marta_doorstep", "return_doorstep", "prop_return_doorstep":
			read_local_lena_recovered()
		"household_consequence", "prop_household_consequence", "HouseholdTrace":
			read_household_consequence()
		"station_42b_exit", "prop_station_42b_exit", "Station42BExit":
			if is_exit_unlocked:
				_trigger_level_completion()
			else:
				execute_close_flow()
		_:
			match prop_type:
				197:
					execute_close_flow()
				198:
					read_local_lena_recovered()
				16:
					read_household_consequence()
				196:
					if is_exit_unlocked:
						_trigger_level_completion()
					else:
						execute_close_flow()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)
	interaction_triggered.emit(id)


func execute_close_flow() -> bool:
	if is_flow_closed:
		return false
	if not _has_close_equal():
		_record_feedback(&"method_close_equal_required")
		return false
	is_flow_closed = true
	_record(FACT_FLOW_CLOSED, true)
	_record(FACT_EXECUTED, true)
	_record(FACT_ENDING_FAMILY, ENDING_FAMILY_VALUE)
	if guidance_service:
		guidance_service.trigger_beat(&"s42b_closure_echo")
	_report_progress(&"s42b_flow_closed")
	flow_closed.emit()
	_unlock_exit()
	queue_redraw()
	return true


func close_flow() -> bool:
	return execute_close_flow()


func read_local_lena_recovered() -> bool:
	if is_local_lena_recovered:
		return false
	if not _has_close_equal():
		_record_feedback(&"method_close_equal_required")
		return false
	is_local_lena_recovered = true
	is_doorstep_inspected = true
	is_chamber_b_witnessed = true
	_record(FACT_LOCAL_RECOVERED, true)
	_record(FACT_WITNESSED, true)
	_record(FACT_TRACE, TRACE_VALUE)
	if guidance_service:
		guidance_service.close_hypothesis(&"arrived_lena_unindexed_presence")
		guidance_service.trigger_beat(&"s42b_recovered_seen")
	_report_progress(&"s42b_local_lena_recovered")
	local_lena_recovered.emit()
	doorstep_inspected.emit()
	chamber_b_witnessed.emit()
	_unlock_exit()
	queue_redraw()
	return true


func inspect_doorstep() -> bool:
	return read_local_lena_recovered()


func witness_chamber_b() -> bool:
	return read_local_lena_recovered()


func read_household_consequence() -> bool:
	if is_household_read:
		return false
	if not _has_close_equal():
		_record_feedback(&"method_close_equal_required")
		return false
	marta_truth_state = _read_marta_truth()
	jakub_consent_state = _read_jakub_consent()
	household_consequence = {
		"marta": marta_truth_state if not marta_truth_state.is_empty() else MARTA_PARTIAL,
		"jakub": jakub_consent_state if not jakub_consent_state.is_empty() else SCOPE_LIMITED,
		"local_lena": "recovered_in_body",
		"arrived_lena": "unindexed_presence",
	}
	is_household_read = true
	_record(FACT_HOUSEHOLD, household_consequence)
	_record(FACT_ENDING_STABILITY, _stability_from_household())
	if guidance_service:
		guidance_service.trigger_beat(&"s42b_read_plan")
	_report_progress(&"s42b_household_read")
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
		guidance_service.report_failed_attempt(&"s42b_" + value)


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	pass  # PKG-0174: ThresholdZone requires interact


func unlock_exit() -> void:
	_unlock_exit()


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


func _has_close_equal() -> bool:
	var namespaced := str(_read_decision(FACT_DONOR_METHOD))
	var canonical := str(_read_decision(FACT_CANONICAL_METHOD))
	return namespaced == METHOD_CLOSE_EQUAL or canonical == METHOD_CLOSE_EQUAL


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
		"flow_closure", "prop_flow_closure", "FlowClosureLatch":
			return is_flow_closed
		"local_lena_recovered", "prop_local_lena_recovered", "LocalLenaThreshold", "MartaDoorstep", "prop_marta_doorstep", "return_doorstep", "prop_return_doorstep":
			return is_local_lena_recovered
		"household_consequence", "prop_household_consequence", "HouseholdTrace":
			return is_household_read
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	_draw_dawn_apartment_b()
	_draw_flow_closure()
	_draw_local_lena_recovered()
	_draw_household_table()
	_draw_exit()
	queue_redraw()


func _draw_dawn_apartment_b() -> void:
	# Rodzina finałowa: znana mieszkalna bryła o świcie. Ta sama armatura,
	# inna pora (chłodny świt). Jeden zmieniony fakt o osobach: miejscowa Lena
	# odzyskała ciało i dom, przybyła Lena stoi po drugiej stronie progu.
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), VectorStageStyle.INK)
	draw_rect(Rect2(0.0, 0.0, 640.0, 148.0), VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.22))
	draw_line(Vector2(0.0, 148.0), Vector2(640.0, 148.0), VectorStageStyle.MID_PLANE, 2.0)
	draw_rect(Rect2(0.0, 148.0, 640.0, 158.0), VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.08))
	# Okno o świcie — ta sama rama, chłodne światło przedświtu.
	draw_rect(Rect2(36.0, 164.0, 72.0, 86.0), VectorStageStyle.INK)
	var dawn := 0.20 + 0.05 * sin(_lamp_phase * 0.75)
	draw_rect(Rect2(40.0, 168.0, 64.0, 78.0), Color(VectorStageStyle.ANCHOR_CYAN, dawn))
	draw_line(Vector2(72.0, 168.0), Vector2(72.0, 246.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	draw_rect(Rect2(36.0, 248.0, 72.0, 8.0), VectorStageStyle.MID_PLANE)
	# Dwie lampki na wysokości 47–150 px, przygaszone.
	var lamp := 0.26 + 0.07 * sin(_lamp_phase * 1.05)
	draw_circle(Vector2(168.0, 132.0), 5.0, Color(VectorStageStyle.HUMAN_AMBER, lamp))
	draw_line(Vector2(168.0, 132.0), Vector2(168.0, 148.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	draw_circle(Vector2(488.0, 126.0), 4.0, Color(VectorStageStyle.ANCHOR_CYAN, lamp * 0.75))
	draw_line(Vector2(488.0, 126.0), Vector2(488.0, 148.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.2), 1.0)
	# Podłoga i dywan.
	draw_rect(Rect2(0.0, 306.0, 640.0, 54.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.35))
	draw_line(Vector2(0.0, 306.0), Vector2(640.0, 306.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	draw_rect(Rect2(118.0, 300.0, 404.0, 10.0), VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.45))


func _draw_flow_closure() -> void:
	var flow_color := VectorStageStyle.ANCHOR_CYAN if is_flow_closed else VectorStageStyle.CORRECTION_OXIDE
	draw_rect(Rect2(132.0, 188.0, 88.0, 112.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.18))
	draw_rect(Rect2(132.0, 188.0, 88.0, 112.0), flow_color, false, 1.5)
	draw_rect(Rect2(148.0, 204.0, 56.0, 72.0), VectorStageStyle.INK)
	# Przewód Równi — rozłączony i zapieczętowany.
	draw_line(Vector2(176.0, 204.0), Vector2(176.0, 232.0), flow_color, 2.0)
	draw_line(Vector2(176.0, 248.0), Vector2(176.0, 276.0), flow_color, 2.0)
	draw_circle(Vector2(176.0, 240.0), 3.0, flow_color)
	if is_flow_closed:
		draw_line(Vector2(154.0, 240.0), Vector2(198.0, 240.0), flow_color, 2.0)


func _draw_local_lena_recovered() -> void:
	var threshold_color := VectorStageStyle.ANCHOR_CYAN if is_local_lena_recovered else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(286.0, 168.0, 92.0, 138.0), VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.12))
	draw_rect(Rect2(286.0, 168.0, 92.0, 138.0), threshold_color, false, 1.5)
	# PKG-0187: this is a deliberately unreadable silhouette behind frosted
	# glass, not a tiny person assembled from a circle and a line. The opaque
	# pane is the explicit CAST_AND_NPC_BIBLE §1 exception: a presence inside a
	# threshold, not a standing NPC in shared world space.
	draw_rect(Rect2(304.0, 188.0, 56.0, 104.0), Color(VectorStageStyle.INK, 0.34))
	draw_colored_polygon(PackedVector2Array([
		Vector2(314.0, 282.0), Vector2(350.0, 282.0), Vector2(348.0, 236.0),
		Vector2(342.0, 216.0), Vector2(344.0, 206.0), Vector2(336.0, 198.0),
		Vector2(326.0, 198.0), Vector2(318.0, 206.0), Vector2(320.0, 216.0),
		Vector2(314.0, 236.0),
	]), Color(VectorStageStyle.HUMAN_AMBER, 0.24))
	draw_line(Vector2(310.0, 232.0), Vector2(354.0, 232.0), Color(threshold_color, 0.32), 1.0)
	draw_line(Vector2(332.0, 168.0), Vector2(332.0, 306.0), threshold_color, 1.5)
	if is_local_lena_recovered:
		draw_line(Vector2(294.0, 300.0), Vector2(370.0, 300.0), threshold_color, 2.0)


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
	# Dwa kubki — stół przygotowany na spotkanie bez wymuszonej tożsamości.
	var warm_cup := VectorStageStyle.HUMAN_AMBER if is_local_lena_recovered else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.4)
	draw_colored_polygon(
		PackedVector2Array([Vector2(452.0, 236.0), Vector2(470.0, 234.0), Vector2(472.0, 250.0), Vector2(454.0, 252.0)]),
		warm_cup,
	)
	draw_colored_polygon(
		PackedVector2Array([Vector2(498.0, 234.0), Vector2(516.0, 232.0), Vector2(518.0, 248.0), Vector2(500.0, 250.0)]),
		VectorStageStyle.ANCHOR_CYAN if is_household_read else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.45),
	)
	# Dwa krzesła — obecność uznana bez fałszerstwa rejestru.
	draw_line(Vector2(512.0, 298.0), Vector2(512.0, 262.0), table_color, 1.5)
	draw_line(Vector2(532.0, 298.0), Vector2(532.0, 262.0), table_color, 1.5)
	draw_line(Vector2(512.0, 262.0), Vector2(532.0, 262.0), table_color, 1.5)
	if is_household_read:
		draw_circle(Vector2(507.0, 241.0), 3.0, table_color)


func _draw_exit() -> void:
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(572.0, 146.0, 48.0, 12.0), exit_color, false, 1.5)
	draw_line(Vector2(610.0, 158.0), Vector2(610.0, 296.0), exit_color, 2.0)
	draw_line(Vector2(584.0, 296.0), Vector2(620.0, 296.0), exit_color, 2.0)
