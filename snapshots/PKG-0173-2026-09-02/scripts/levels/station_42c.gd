class_name Station42C
extends Node2D

## Station 42C — P9 PHASE-06, pozwolenie obu Lenom odpowiedzieć / otwarcie wzajemnego przejścia i przyjęcie trwałego przecieku pamięci.
## Znane mieszkanie z 09/10/13 o świcie: ta sama bryła, jeden zmieniony fakt
## o osobach (most nie zgasł, pamięć przecieka między światami, oba czytniki
## rejestrują tę samą brakującą sekundę).
## Lena zwalnia wzajemne przejście, odczytuje trwały przeciek pamięci i odczytuje
## skutek dla osób w tej przestrzeni. Pytanie, z którym gracz wychodzi:
## „co zostanie połączone na stałe?".

## PRZESZKODA — dlaczego to tu jest: Obwód wzajemnego przejścia łączy dwie
## instancje mieszkania; próg mieszkania 14 rejestruje stały przeciek pamięci
## między światami, a stół zachowuje ślad materialnej obecności obu stron.
## PRZESZKODA — czego wymaga od Leny: zwolnienia wzajemnego przejścia, odczytu
## trwałego przecieku pamięci i odczytu skutku dla Marty i Jakuba w obu domach.
## PRZESZKODA — koszt porażki: niepełna próba zostawia fakt informacyjny i nie
## zamyka drogi do 43, jeśli 42C jest wybranym wariantem.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const MemoryResonancePoint := preload("res://scripts/interactables/memory_resonance_point.gd")

const FACT_DONOR_METHOD := &"p9.method_commitment.method_committed"
const FACT_CANONICAL_METHOD := &"method_committed"
const FACT_DONOR_MARTA := &"p9.method_commitment.marta_truth_state"
const FACT_CANONICAL_MARTA := &"marta_truth_state"
const FACT_DONOR_SCOPE := &"p9.consent_and_cost.jakub_consent_scope"
const FACT_CANONICAL_SCOPE := &"jakub_consent_state"

const FACT_PASSAGE_OPENED := &"p9.finale.mutual_passage.passage_opened"
const FACT_EXECUTED := &"p9.finale.mutual_passage.executed"
const FACT_MEMORY_LEAK := &"p9.finale.mutual_passage.memory_leak_accepted"
const FACT_HOUSEHOLD := &"p9.finale.mutual_passage.household_consequence"
const FACT_TRACE := &"p9.finale.mutual_passage.trace"
const FACT_FEEDBACK := &"p9.finale.mutual_passage.safe_trial_feedback"
const FACT_ENDING_FAMILY := &"ending_family"
const FACT_ENDING_STABILITY := &"ending_stability"
const FACT_CHAMBER_ENTERED := &"p7.conscious_silence_and_presence.chamber_c_entered"
const FACT_WITNESSED := &"p7.conscious_silence_and_presence.final_chamber_witnessed"

const METHOD_MUTUAL_PASSAGE := "mutual_passage"
const TRACE_VALUE := "mutual_passage_memory_leak_accepted"
const ENDING_FAMILY_VALUE := "mutual_passage"
const MARTA_FULL := "full"
const MARTA_PARTIAL := "partial"
const MARTA_WITHHELD := "withheld"
const SCOPE_GRANTED := "granted"
const SCOPE_LIMITED := "limited"
const SCOPE_REFUSED := "refused"

signal clue_inspected(id: String, prop_type: int)
signal passage_opened()
signal memory_leak_accepted()
signal household_consequence_read()
signal exit_unlocked()
signal level_completed()
signal previous_level_requested()
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)
signal tram_inspected()
signal chamber_c_witnessed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")

const DIALOGUE_LINES: Array[Dictionary] = [
	{"speaker": "LENA", "text": "Dwa czytniki. Świt. Ta sama sekunda po obu stronach."},
	{"speaker": "MARTA", "text": "Znam ten kubek na twoim zdjęciu."},
	{"speaker": "LENA", "text": "Nie masz go na półce. Obie to wiemy."},
	{"speaker": "JAKUB", "text": "Most nie zgasł. Odpowiadacie obie przed swoim domem."},
]

var dialogue_lines: Array[Dictionary] = DIALOGUE_LINES
var dialogue_active := false
var dialogue_index := 0
var is_dialogue_completed := false

var is_passage_opened := false
var is_memory_leak_read := false
var is_household_read := false
var is_tram_inspected := false
var is_chamber_c_witnessed := false
var is_exit_unlocked := false
var is_level_completed := false
var last_feedback: StringName = &""
var household_consequence: Dictionary = {}
var marta_truth_state := ""
var jakub_consent_state := ""

var _lamp_phase := 0.0


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_props()
	marta_truth_state = _read_marta_truth()
	jakub_consent_state = _read_jakub_consent()
	_record(FACT_CHAMBER_ENTERED, true)
	if _has_mutual_passage():
		_unlock_exit()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	queue_redraw()


func _physics_process(delta: float) -> void:
	_lamp_phase = fmod(_lamp_phase + delta, TAU)


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s42c_dawn_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s42c_mutual_echo", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Dwa czytniki. Świt. Most pozostaje częściowo otwarty po obu stronach.", "Two readers. Dawn. The bridge remains partially open on both sides.", &"", "")
	_register_beat(&"s42c_leak_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Co zostanie połączone na stałe? Pamięć przecieka między światami, ale obie mamy prawo do odpowiedzi.", "What will be permanently connected? Memory leaks between worlds, but both of us have the right to answer.", &"mutual_memory_leak_uncontrolled", "read_memory_leak")
	_register_beat(&"s42c_read_plan", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Otworzyć wzajemne przejście, przyjąć przeciek pamięci i sprawdzić skutek dla obu domów.", "Open the mutual passage, accept the memory leak, and check the consequence for both homes.", &"", "execute_mutual_passage")
	_register_beat(&"s42c_both_seen", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Obie odpowiadamy przed własnym życiem. To jest skutek wyboru, nie nagroda.", "Both of us answer to our own lives. That is the consequence of choice, not a reward.", &"", "")
	_register_beat(&"s42c_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Zwolnienie wzajemnego przejścia, próg przecieku pamięci, stół dwóch domów.", "HINT: Mutual passage release, memory leak threshold, table of two homes.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_42c"
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
		"mutual_passage", "prop_mutual_passage", "MutualPassageLatch", "TramTracks", "prop_tram_tracks", "tram_inspection":
			execute_mutual_passage()
		"memory_leak", "prop_memory_leak", "MemoryLeakThreshold", "ChamberCEcho", "prop_chamber_c_echo", "witness_c":
			read_memory_leak()
		"household_consequence", "prop_household_consequence", "HouseholdTrace":
			read_household_consequence()
		"station_42c_exit", "prop_station_42c_exit", "Station42CExit":
			if is_exit_unlocked:
				_trigger_level_completion()
			else:
				execute_mutual_passage()
		_:
			match prop_type:
				197:
					execute_mutual_passage()
				198:
					read_memory_leak()
				16:
					read_household_consequence()
				196:
					if is_exit_unlocked:
						_trigger_level_completion()
					else:
						execute_mutual_passage()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)
	interaction_triggered.emit(id)


func execute_mutual_passage() -> bool:
	if is_passage_opened:
		return false
	if not _has_mutual_passage():
		_record_feedback(&"method_mutual_passage_required")
		return false
	is_passage_opened = true
	is_tram_inspected = true
	_record(FACT_PASSAGE_OPENED, true)
	_record(FACT_EXECUTED, true)
	_record(FACT_ENDING_FAMILY, ENDING_FAMILY_VALUE)
	if guidance_service:
		guidance_service.trigger_beat(&"s42c_mutual_echo")
	_report_progress(&"s42c_passage_opened")
	passage_opened.emit()
	tram_inspected.emit()
	_unlock_exit()
	queue_redraw()
	return true


func inspect_tram() -> bool:
	return execute_mutual_passage()


func open_mutual_passage() -> bool:
	return execute_mutual_passage()


func read_memory_leak() -> bool:
	if is_memory_leak_read:
		return false
	if not _has_mutual_passage():
		_record_feedback(&"method_mutual_passage_required")
		return false
	is_memory_leak_read = true
	is_chamber_c_witnessed = true
	_record(FACT_MEMORY_LEAK, true)
	_record(FACT_WITNESSED, true)
	_record(FACT_TRACE, TRACE_VALUE)
	if guidance_service:
		guidance_service.close_hypothesis(&"mutual_memory_leak_uncontrolled")
		guidance_service.trigger_beat(&"s42c_both_seen")
	_report_progress(&"s42c_memory_leak_read")
	memory_leak_accepted.emit()
	chamber_c_witnessed.emit()
	_unlock_exit()
	queue_redraw()
	return true


func witness_chamber_c() -> bool:
	return read_memory_leak()


func accept_memory_leak() -> bool:
	return read_memory_leak()


func read_household_consequence() -> bool:
	if is_household_read:
		return false
	if not _has_mutual_passage():
		_record_feedback(&"method_mutual_passage_required")
		return false
	marta_truth_state = _read_marta_truth()
	jakub_consent_state = _read_jakub_consent()
	household_consequence = {
		"marta": marta_truth_state if not marta_truth_state.is_empty() else MARTA_PARTIAL,
		"jakub": jakub_consent_state if not jakub_consent_state.is_empty() else SCOPE_GRANTED,
		"local_lena": "returned_to_marta_with_leak",
		"arrived_lena": "returned_home_with_leak",
	}
	is_household_read = true
	_record(FACT_HOUSEHOLD, household_consequence)
	_record(FACT_ENDING_STABILITY, _stability_from_household())
	if guidance_service:
		guidance_service.trigger_beat(&"s42c_read_plan")
	_report_progress(&"s42c_household_read")
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
		guidance_service.report_failed_attempt(&"s42c_" + value)


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	call_deferred("_complete_if_player_already_in_airlock")


func unlock_exit() -> void:
	_unlock_exit()


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


func _has_mutual_passage() -> bool:
	var namespaced := str(_read_decision(FACT_DONOR_METHOD))
	var canonical := str(_read_decision(FACT_CANONICAL_METHOD))
	return namespaced == METHOD_MUTUAL_PASSAGE or canonical == METHOD_MUTUAL_PASSAGE


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
		"mutual_passage", "prop_mutual_passage", "MutualPassageLatch", "TramTracks", "prop_tram_tracks", "tram_inspection":
			return is_passage_opened
		"memory_leak", "prop_memory_leak", "MemoryLeakThreshold", "ChamberCEcho", "prop_chamber_c_echo", "witness_c":
			return is_memory_leak_read
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
	_draw_dawn_apartment_c()
	_draw_mutual_passage()
	_draw_memory_leak_threshold()
	_draw_household_table()
	_draw_exit()
	queue_redraw()


func _draw_dawn_apartment_c() -> void:
	# Rodzina finałowa: znana mieszkalna bryła o świcie. Ta sama armatura,
	# inna pora (chłodny świt z obustronnym przejściem). Jeden zmieniony fakt
	# o osobach: most nie zgasł, pamięć przecieka między obydwoma światami,
	# obie Leny zachowują prawo do odpowiedzi przed własnym domem.
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), VectorStageStyle.INK)
	draw_rect(Rect2(0.0, 0.0, 640.0, 148.0), VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.22))
	draw_line(Vector2(0.0, 148.0), Vector2(640.0, 148.0), VectorStageStyle.MID_PLANE, 2.0)
	draw_rect(Rect2(0.0, 148.0, 640.0, 158.0), VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.08))
	# Okno o świcie — ta sama rama, chłodne światło przedświtu.
	draw_rect(Rect2(36.0, 164.0, 72.0, 86.0), VectorStageStyle.INK)
	var dawn := 0.22 + 0.06 * sin(_lamp_phase * 0.75)
	draw_rect(Rect2(40.0, 168.0, 64.0, 78.0), Color(VectorStageStyle.ANCHOR_CYAN, dawn))
	draw_line(Vector2(72.0, 168.0), Vector2(72.0, 246.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	draw_rect(Rect2(36.0, 248.0, 72.0, 8.0), VectorStageStyle.MID_PLANE)
	# Dwie lampki na wysokości 47–150 px, świecące w fazie wzajemnego rezonansu.
	var lamp := 0.28 + 0.08 * sin(_lamp_phase * 1.05)
	draw_circle(Vector2(168.0, 132.0), 5.0, Color(VectorStageStyle.HUMAN_AMBER, lamp))
	draw_line(Vector2(168.0, 132.0), Vector2(168.0, 148.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	draw_circle(Vector2(488.0, 126.0), 4.0, Color(VectorStageStyle.ANCHOR_CYAN, lamp * 0.85))
	draw_line(Vector2(488.0, 126.0), Vector2(488.0, 148.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.2), 1.0)
	# Podłoga i dywan.
	draw_rect(Rect2(0.0, 306.0, 640.0, 54.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.35))
	draw_line(Vector2(0.0, 306.0), Vector2(640.0, 306.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	draw_rect(Rect2(118.0, 300.0, 404.0, 10.0), VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.45))


func _draw_mutual_passage() -> void:
	var passage_color := VectorStageStyle.ANCHOR_CYAN if is_passage_opened else VectorStageStyle.CORRECTION_OXIDE
	draw_rect(Rect2(132.0, 188.0, 88.0, 112.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.18))
	draw_rect(Rect2(132.0, 188.0, 88.0, 112.0), passage_color, false, 1.5)
	draw_rect(Rect2(148.0, 204.0, 56.0, 72.0), VectorStageStyle.INK)
	# Dwa równoległe tory sygnałowe zsynchronizowane przełącznikiem.
	draw_line(Vector2(164.0, 204.0), Vector2(164.0, 276.0), passage_color, 1.5)
	draw_line(Vector2(188.0, 204.0), Vector2(188.0, 276.0), passage_color, 1.5)
	draw_circle(Vector2(164.0, 240.0), 3.0, passage_color)
	draw_circle(Vector2(188.0, 240.0), 3.0, passage_color)
	if is_passage_opened:
		# Most wzajemnego przejścia otwarty — połączenie obu obwodów.
		draw_line(Vector2(164.0, 240.0), Vector2(188.0, 240.0), passage_color, 2.5)
		draw_circle(Vector2(176.0, 240.0), 2.0, VectorStageStyle.HUMAN_AMBER)


func _draw_memory_leak_threshold() -> void:
	var leak_color := VectorStageStyle.ANCHOR_CYAN if is_memory_leak_read else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(286.0, 168.0, 92.0, 138.0), VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.12))
	draw_rect(Rect2(286.0, 168.0, 92.0, 138.0), leak_color, false, 1.5)
	# Próg mieszkania: podwójny czytnik rejestrujący brakującą sekundę.
	draw_rect(Rect2(306.0, 196.0, 22.0, 86.0), Color(VectorStageStyle.HUMAN_AMBER, 0.30))
	draw_rect(Rect2(336.0, 196.0, 22.0, 86.0), Color(VectorStageStyle.ANCHOR_CYAN, 0.30))
	# Dwie sylwetki po obu stronach progu.
	draw_circle(Vector2(317.0, 208.0), 5.0, VectorStageStyle.HUMAN_AMBER)
	draw_line(Vector2(317.0, 213.0), Vector2(317.0, 258.0), VectorStageStyle.HUMAN_AMBER, 1.5)
	draw_circle(Vector2(347.0, 208.0), 5.0, VectorStageStyle.ANCHOR_CYAN)
	draw_line(Vector2(347.0, 213.0), Vector2(347.0, 258.0), VectorStageStyle.ANCHOR_CYAN, 1.5)
	# Linia przecieku pamięci — perforowany próg między światami.
	draw_line(Vector2(332.0, 168.0), Vector2(332.0, 306.0), leak_color, 1.5)
	if is_memory_leak_read:
		draw_line(Vector2(294.0, 300.0), Vector2(370.0, 300.0), leak_color, 2.0)


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
	# Półka z pustym miejscem po kubku (dialog z Martą o zdjęciu z mieszkania 14).
	draw_line(Vector2(436.0, 200.0), Vector2(496.0, 198.0), VectorStageStyle.MID_PLANE, 1.5)
	draw_rect(Rect2(456.0, 188.0, 12.0, 10.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.2), false, 1.0)
	# Dwa kubki na stole — połączona pamięć obu mieszkań.
	var warm_cup := VectorStageStyle.HUMAN_AMBER if is_memory_leak_read else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.4)
	draw_colored_polygon(
		PackedVector2Array([Vector2(452.0, 236.0), Vector2(470.0, 234.0), Vector2(472.0, 250.0), Vector2(454.0, 252.0)]),
		warm_cup,
	)
	draw_colored_polygon(
		PackedVector2Array([Vector2(498.0, 234.0), Vector2(516.0, 232.0), Vector2(518.0, 248.0), Vector2(500.0, 250.0)]),
		VectorStageStyle.ANCHOR_CYAN if is_household_read else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.45),
	)
	# Dwa krzesła.
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
