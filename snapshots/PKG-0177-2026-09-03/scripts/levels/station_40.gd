class_name Station40
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Sala Negocjacyjna istnieje, aby świadkowie mogli nazwać koszty trzech operacji przed ich wykonaniem.
## PRZESZKODA — czego wymaga od Leny: Wysłuchania Wierzbickiej, Marty, Jakuba i Szymona oraz wejścia do Komory Wyboru dopiero po rozpoznaniu znanych kosztów.
## PRZESZKODA — koszt porażki: Nie ma korekty fizycznej; decyzja jest trudna i nieodwracalna, a komora blokuje przejście do momentu wysłuchania racji stron.

signal level_completed
signal previous_level_requested
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)
signal clue_inspected(id: String, prop_type: int)
signal terminal_inspected
signal marta_inspected
signal szymon_inspected
signal cost_matrix_inspected
signal negotiation_confronted
signal exit_unlocked

const FACT_ENTRY := &"p7.branch_clarity_and_irreversible_choice.matrix_reviewed"
const FACT_TERMINAL := &"p7.branch_clarity_and_irreversible_choice.terminal_inspected"
const FACT_MARTA := &"p7.branch_clarity_and_irreversible_choice.marta_inspected"
const FACT_SZYMON := &"p7.branch_clarity_and_irreversible_choice.szymon_inspected"
const FACT_COST_MATRIX := &"p7.branch_clarity_and_irreversible_choice.cost_matrix_inspected"
const FACT_CONFRONTED := &"p7.branch_clarity_and_irreversible_choice.negotiation_confronted"
const FACT_FEEDBACK := &"p7.branch_clarity_and_irreversible_choice.safe_trial_feedback"

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

var is_terminal_inspected: bool = false
var is_marta_inspected: bool = false
var is_szymon_inspected: bool = false
var is_cost_matrix_inspected: bool = false
var is_negotiation_confronted: bool = false

var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = get_node_or_null("Geometry")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")
@onready var guidance_service: NarrativeGuidanceService = get_node_or_null("NarrativeGuidanceService")

const DIALOGUE_LINES: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Sala Negocjacyjna UCP. Poziom 0. Powrót na powierzchnię. Za pancernymi szybami majaczą zarysy porannej Równi."
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Powrót ma jeden stabilny adres i nieznany skutek po tej stronie. Uzgodnienie ma znany koszt dla pani i najniższe ryzyko dla miasta."
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Sieć świadków ma zbyt wiele zmiennych, by nazwać ją rozwiązaniem."
	},
	{
		"speaker": "LENA",
		"text": "Ale działała."
	},
	{
		"speaker": "WIERZBICKA",
		"text": "W jednym pokoju przez czterdzieści trzy sekundy."
	},
	{
		"speaker": "JAKUB",
		"text": "Wystarczyło, żebyśmy wyszli."
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Nie wystarczy, żeby przejechał poranny tramwaj."
	},
	{
		"speaker": "MARTA",
		"text": "Więc nauczymy motorniczą patrzeć."
	},
	{
		"speaker": "WIERZBICKA",
		"text": "A jeśli odwróci głowę?"
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Cisza. Marta nie odsuwa wzroku. Wierzbicka zapisuje brak odpowiedzi, ale nie dopowiada go za nią."
	},
	{
		"speaker": "SZYMON",
		"text": "Była ktoś. Nie trzymam imienia, ale trzymam dowód. Jeśli miasto nie chce pamiętać, będziemy pamiętać my."
	},
	{
		"speaker": "LENA",
		"text": "Nie szukamy już oryginału, doktor Wierzbicka. Szukamy odpowiedzialności."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Wrota do Komory Wyboru Operacyjnego (Przestrzeń 41) zostają odryglowane. Wszystkie trzy operacje są gotowe do egzekucji."
	}
]

var dialogue_lines: Array[Dictionary] = DIALOGUE_LINES


func _ready() -> void:
	if player:
		player.position = Vector2(65.0, 248.0)
	_setup_camera()
	_setup_guidance()
	_connect_prop_signals()
	if airlock_zone and not airlock_zone.body_entered.is_connected(_on_airlock_zone_entered):
		airlock_zone.body_entered.connect(_on_airlock_zone_entered)
	if dialogue_active:
		_show_dialogue_line(dialogue_index)
	queue_redraw()


func _setup_guidance() -> void:
	if not guidance_service:
		return
	_register_beat(&"s40_negotiation_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s40_negotiation_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Sala negocjacyjna. Wierzbicka broni stabilności, Marta patrzy bez uniku.", "Negotiation chamber. Wierzbicka defends stability, Marta looks without evasion.", &"", "")
	_register_beat(&"s40_costs_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Wierzbicka proponuje procedurę, Marta obecność, Szymon pamięć. Każda z opcji ma realny koszt.", "Wierzbicka proposes procedure, Marta presence, Szymon memory. Each option carries real costs.", &"forced_return_isolation", "confront_negotiation_costs")
	_register_beat(&"s40_listen_witnesses", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Wysłucham terminalu Wierzbickiej, matrycy kosztów, Marty i Szymona, by otworzyć przejście.", "Listen to Wierzbicka terminal, cost matrix, Marta and Szymon to unlock passage.", &"", "confront_negotiation_costs")
	_register_beat(&"s40_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Wysłuchaj wszystkich świadków i zbadaj matrycę kosztów.", "HINT: Listen to all witnesses and inspect the cost matrix.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_40"
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
	_pulse_phase += delta * 2.8
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 1.6)
		queue_redraw()


func _connect_prop_signals() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var pt := child as MemoryResonancePoint
			if not pt.resonance_triggered.is_connected(_on_prop_resonance_triggered):
				pt.resonance_triggered.connect(_on_prop_resonance_triggered)


func inspect_terminal() -> bool:
	if is_terminal_inspected:
		return false
	is_terminal_inspected = true
	_record(FACT_TERMINAL, true)
	terminal_inspected.emit()
	interaction_triggered.emit("prop_wierzbicka_terminal")
	_activate_prop_by_id("prop_wierzbicka_terminal")
	_activate_prop_by_id("wierzbicka_terminal")
	if dialogue_index == 0 or dialogue_index == 1:
		advance_dialogue()
	_check_confrontation_ready()
	queue_redraw()
	return true


func inspect_cost_matrix() -> bool:
	if is_cost_matrix_inspected:
		return false
	is_cost_matrix_inspected = true
	_record(FACT_COST_MATRIX, true)
	cost_matrix_inspected.emit()
	interaction_triggered.emit("prop_cost_matrix")
	_activate_prop_by_id("prop_cost_matrix")
	_activate_prop_by_id("cost_matrix")
	if dialogue_index in [2, 3, 4, 5]:
		advance_dialogue()
	_check_confrontation_ready()
	queue_redraw()
	return true


func inspect_marta() -> bool:
	if is_marta_inspected:
		return false
	is_marta_inspected = true
	_record(FACT_MARTA, true)
	marta_inspected.emit()
	interaction_triggered.emit("prop_marta_witness")
	_activate_prop_by_id("prop_marta_witness")
	_activate_prop_by_id("marta_witness")
	if dialogue_index in [6, 7, 8]:
		advance_dialogue()
	_check_confrontation_ready()
	queue_redraw()
	return true


func inspect_szymon() -> bool:
	if is_szymon_inspected:
		return false
	is_szymon_inspected = true
	_record(FACT_SZYMON, true)
	szymon_inspected.emit()
	interaction_triggered.emit("prop_szymon_monitor")
	_activate_prop_by_id("prop_szymon_monitor")
	_activate_prop_by_id("szymon_monitor")
	if dialogue_index in [9, 10]:
		advance_dialogue()
	_check_confrontation_ready()
	queue_redraw()
	return true


func confront_negotiation_costs() -> bool:
	if is_negotiation_confronted:
		return false
	if not (is_terminal_inspected and is_cost_matrix_inspected and is_marta_inspected and is_szymon_inspected):
		_record_feedback(&"witnesses_incomplete")
		return false
	is_negotiation_confronted = true
	_record(FACT_CONFRONTED, true)
	negotiation_confronted.emit()
	unlock_exit()
	queue_redraw()
	return true


func _check_confrontation_ready() -> void:
	if is_terminal_inspected and is_cost_matrix_inspected and is_marta_inspected and is_szymon_inspected:
		confront_negotiation_costs()


func _on_prop_resonance_triggered(id: String, prop_type: int) -> void:
	clue_inspected.emit(id, prop_type)
	match id:
		"wierzbicka_terminal", "prop_wierzbicka_terminal":
			inspect_terminal()
		"cost_matrix", "prop_cost_matrix":
			inspect_cost_matrix()
		"marta_witness", "prop_marta_witness":
			inspect_marta()
		"szymon_monitor", "prop_szymon_monitor":
			inspect_szymon()
		"station_40_exit", "prop_station_40_exit", "Station40Exit":
			if is_exit_unlocked:
				_complete_level()
			else:
				_record_feedback(&"confrontation_required")
		_:
			match prop_type:
				187:
					inspect_terminal()
				190:
					inspect_cost_matrix()
				188:
					inspect_marta()
				189:
					inspect_szymon()
				191:
					if is_exit_unlocked:
						_complete_level()


func advance_dialogue() -> void:
	if not dialogue_active:
		return
	if dialogue_index < DIALOGUE_LINES.size() - 1:
		dialogue_index += 1
		dialogue_advanced.emit(dialogue_index)
		_show_dialogue_line(dialogue_index)
		if dialogue_index >= 11:
			unlock_exit()
	else:
		is_dialogue_completed = true
		dialogue_active = false
		unlock_exit()
		if dialogue_box and dialogue_box.has_method("hide_box"):
			dialogue_box.hide_box()


func _show_dialogue_line(idx: int) -> void:
	if idx < 0 or idx >= dialogue_lines.size():
		return
	var line: Dictionary = dialogue_lines[idx]
	if dialogue_box and dialogue_box.has_method("show_line"):
		dialogue_box.show_line(line.get("speaker", "ŚWIADECTWO"), line.get("text", ""))


func unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_activate_prop_by_id("Station40Exit")
	_activate_prop_by_id("station_40_exit")
	_activate_prop_by_id("prop_station_40_exit")
	queue_redraw()


func _activate_prop_by_id(id: String) -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint and (child.resonance_id == id or child.name == id):
				child.is_activated = true
				child.queue_redraw()


func _on_airlock_zone_entered(body: Node2D) -> void:
	if body is PrototypePlayer or (body != null and body.name == "Player"):
		if is_exit_unlocked:
			_complete_level()


func _complete_level() -> void:
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


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var terminal_color := VectorStageStyle.LIGHT_PLANE if is_terminal_inspected else VectorStageStyle.MID_PLANE
	draw_rect(Rect2(112.0, 112.0, 58.0, 44.0), VectorStageStyle.INK)
	draw_rect(Rect2(112.0, 112.0, 58.0, 44.0), terminal_color, false, 1.2)
	var matrix_color := VectorStageStyle.CORRECTION_OXIDE if is_cost_matrix_inspected else VectorStageStyle.MID_PLANE
	draw_colored_polygon(PackedVector2Array([Vector2(210.0, 174.0), Vector2(278.0, 168.0), Vector2(286.0, 204.0), Vector2(216.0, 210.0)]), matrix_color)
	var marta_color := VectorStageStyle.HUMAN_AMBER if is_marta_inspected else VectorStageStyle.LIGHT_PLANE
	draw_colored_polygon(PackedVector2Array([Vector2(318.0, 176.0), Vector2(348.0, 172.0), Vector2(354.0, 232.0), Vector2(324.0, 236.0)]), marta_color)
	# Marta's pink hair and steel septum retain her identity at the wide campaign scale.
	draw_circle(Vector2(336.0, 172.0), 9.0, Color("6d294f"))
	draw_line(Vector2(328.0, 167.0), Vector2(344.0, 165.0), Color("d45b9a"), 3.0)
	draw_line(Vector2(329.0, 171.0), Vector2(329.0, 189.0), Color("d45b9a"), 2.0)
	draw_line(Vector2(343.0, 171.0), Vector2(343.0, 189.0), Color("d45b9a"), 2.0)
	draw_arc(Vector2(338.0, 175.0), 2.0, 0.15, PI - 0.15, 6, Color("c7d3d6"), 1.0)
	var szymon_color := VectorStageStyle.ANCHOR_CYAN if is_szymon_inspected else VectorStageStyle.MID_PLANE
	draw_line(Vector2(410.0, 166.0), Vector2(472.0, 166.0), szymon_color, 2.0)
	if is_exit_unlocked:
		draw_line(Vector2(522.0, 222.0), Vector2(606.0, 222.0), VectorStageStyle.ANCHOR_CYAN, 2.0)


func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)
