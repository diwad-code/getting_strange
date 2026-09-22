class_name Station41
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Komora UCP rozdziela trzy operacje, ponieważ odpowiedzialność za sprzeczną historię musi zostać załączona w jednym, jawnie obserwowalnym miejscu.
## PRZESZKODA — czego wymaga od Leny: Odczytania topografii świadków, porównania nazwanych kosztów i fizycznego załączenia jednej z konsol A/B/C, a następnie przejścia przez wrota wybranej operacji.
## PRZESZKODA — koszt porażki: Nie ma korekty fizycznej; dopóki żadna konsola nie zostanie załączona, wrota pozostają zamknięte, lecz wszystkie trzy operacje nadal są dostępne i nie powstaje test zręcznościowej poprawności.

signal level_completed
signal previous_level_requested
signal interaction_triggered(id: String)
signal operation_selected(op: String)
signal dialogue_advanced(line_index: int)
signal clue_inspected(id: String, prop_type: int)
signal topography_inspected
signal operation_a_selected
signal operation_b_selected
signal operation_c_selected
signal operation_committed(op: String)
signal exit_unlocked

const FACT_ENTRY := &"p7.branch_clarity_and_irreversible_choice.negotiation_confronted"
const FACT_TOPOGRAPHY := &"p7.branch_clarity_and_irreversible_choice.topography_inspected"
const FACT_COMMITTED := &"p7.branch_clarity_and_irreversible_choice.console_committed"
const FACT_CHOSEN_OP := &"p7.branch_clarity_and_irreversible_choice.chosen_operation"
const FACT_COMMITMENT := &"p7.branch_clarity_and_irreversible_choice.commitment"
const FACT_TRACE := &"p7.branch_clarity_and_irreversible_choice.trace"
const FACT_FEEDBACK := &"p7.branch_clarity_and_irreversible_choice.safe_trial_feedback"

@export var chosen_operation: String = ""
@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

var is_topography_inspected: bool = false
var is_op_a_inspected: bool = false
var is_op_b_inspected: bool = false
var is_op_c_inspected: bool = false
var is_operation_committed: bool = false

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
		"text": "Komora Wyboru Operacyjnego. Poziom 0. Trzy niezależne stanowiska egzekucyjne: Powrót (A), Zamknięcie Równi (B), Przejście Wzajemne (C)."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "To nie jest menu dialogowe. Decyzja nie polega na odkryciu jednej prawdy — polega na fizycznym załączeniu odpowiedzialności."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Operacja A (Powrót): Zakotwiczenie własnego gestu i sygnału pierwszej komory z 21:45. Odcięcie lokalnych świadectw. Wyjście do Przestrzeni 42A."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Operacja B (Zamknięcie Równi): Przyjęcie adresu mieszkania 14 i powrót miejscowej Leny. Most zostaje zamknięty. Wyjście do Przestrzeni 42B."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Operacja C (Przejście Wzajemne): Zsynchronizowany powrót obu Len. Most częściowo otwarty, przeciek pamięci. Wyjście do Przestrzeni 42C."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Załącz wybraną konsolę operacyjną (A, B lub C), aby odryglować wrota rozstrzygnięcia."
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
	_register_beat(&"s41_operational_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s41_operational_choice", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Komora wyboru. Trzy konsole i fizyczne załączenie odpowiedzialności.", "Choice chamber. Three consoles and physical commitment of responsibility.", &"", "")
	_register_beat(&"s41_choice_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Wybór metody A, B lub C zdeterminuje ciągłość bez powrotu do stanu neutralnego.", "Choosing method A, B or C determines continuity with no return to neutral state.", &"forced_return_isolation", "commit_operation")
	_register_beat(&"s41_commit_action", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zbadam mapę topografii, wybiorę konsolę (A, B lub C) i załączę operację.", "Inspect topography map, select console (A, B or C) and commit operation.", &"", "commit_operation")
	_register_beat(&"s41_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Podejdź do wybranej konsoli A, B lub C i załącz ją, aby otworzyć bramę.", "HINT: Approach console A, B or C and activate it to open the gateway.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_41"
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
	_pulse_phase += delta * 3.0
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 1.8)
	queue_redraw()


func _connect_prop_signals() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var pt := child as MemoryResonancePoint
			if not pt.resonance_triggered.is_connected(_on_prop_resonance_triggered):
				pt.resonance_triggered.connect(_on_prop_resonance_triggered)


func inspect_topography() -> bool:
	if is_topography_inspected:
		return false
	is_topography_inspected = true
	_record(FACT_TOPOGRAPHY, true)
	topography_inspected.emit()
	interaction_triggered.emit("prop_topography_display")
	_activate_prop_by_id("prop_topography_display")
	_activate_prop_by_id("topography_display")
	if dialogue_index == 0 or dialogue_index == 1:
		advance_dialogue()
	queue_redraw()
	return true


func select_operation_a() -> bool:
	select_operation("A")
	operation_a_selected.emit()
	return true


func select_operation_b() -> bool:
	select_operation("B")
	operation_b_selected.emit()
	return true


func select_operation_c() -> bool:
	select_operation("C")
	operation_c_selected.emit()
	return true


func select_operation(op: String) -> void:
	chosen_operation = op
	is_operation_committed = true
	_record(FACT_COMMITTED, true)
	_record(FACT_CHOSEN_OP, op)
	_record(&"final_branch_chosen", "branch_" + op.to_lower())
	_record(FACT_COMMITMENT, "operation_" + op.to_lower() + "_committed")
	_record(FACT_TRACE, "method_committed_to_branch")
	
	operation_selected.emit(chosen_operation)
	operation_committed.emit(chosen_operation)
	
	var state := get_node_or_null("/root/GameStateManager")
	if state and state.has_method("select_finale_operation"):
		state.select_finale_operation(op)
	
	if props:
		var prop_a := props.get_node_or_null("ConsoleReturnA") as MemoryResonancePoint
		var prop_b := props.get_node_or_null("ConsoleReconciliationB") as MemoryResonancePoint
		var prop_c := props.get_node_or_null("ConsoleTestimonyC") as MemoryResonancePoint
		
		if prop_a:
			prop_a.is_activated = (op == "A")
			prop_a.queue_redraw()
		if prop_b:
			prop_b.is_activated = (op == "B")
			prop_b.queue_redraw()
		if prop_c:
			prop_c.is_activated = (op == "C")
			prop_c.queue_redraw()
	
	unlock_exit()
	
	var op_text := ""
	match op:
		"A":
			op_text = "Wybrano Operację A: Powrót (Własny pokój). Sygnał korelacji 21:45 zakotwiczony. Wrota do Przestrzeni 42A odryglowane."
		"B":
			op_text = "Wybrano Operację B: Zamknięcie Równi (Miejsce po niej). Wzorzec tożsamości z Martą przyjęty. Wrota do Przestrzeni 42B odryglowane."
		"C":
			op_text = "Wybrano Operację C: Przejście Wzajemne (Świadectwo). Synchronizacja obu Len. Wrota do Przestrzeni 42C odryglowane."
	
	dialogue_lines = [
		{
			"speaker": "ROZSTRZYGNIĘCIE",
			"text": op_text
		}
	]
	dialogue_index = 0
	dialogue_active = true
	_show_dialogue_line(0)
	queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int) -> void:
	clue_inspected.emit(id, prop_type)
	match id:
		"topography_display", "prop_topography_display":
			inspect_topography()
		"console_return_a", "prop_console_return_a", "ConsoleReturnA":
			is_op_a_inspected = true
			select_operation_a()
		"console_reconciliation_b", "prop_console_reconciliation_b", "ConsoleReconciliationB":
			is_op_b_inspected = true
			select_operation_b()
		"console_testimony_c", "prop_console_testimony_c", "ConsoleTestimonyC":
			is_op_c_inspected = true
			select_operation_c()
		"station_41_exit", "prop_station_41_exit", "Station41Exit":
			if is_exit_unlocked:
				_complete_level()
			else:
				_record_feedback(&"operation_selection_required")
		_:
			match prop_type:
				195:
					inspect_topography()
				192:
					is_op_a_inspected = true
					select_operation_a()
				193:
					is_op_b_inspected = true
					select_operation_b()
				194:
					is_op_c_inspected = true
					select_operation_c()
				196:
					if is_exit_unlocked:
						_complete_level()


func advance_dialogue() -> void:
	if not dialogue_active:
		return
	if dialogue_index < dialogue_lines.size() - 1:
		dialogue_index += 1
		dialogue_advanced.emit(dialogue_index)
		_show_dialogue_line(dialogue_index)
	else:
		is_dialogue_completed = true
		dialogue_active = false
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
	_activate_prop_by_id("Station41Exit")
	_activate_prop_by_id("station_41_exit")
	_activate_prop_by_id("prop_station_41_exit")
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
	var map_color: Color = VectorStageStyle.LIGHT_PLANE if is_topography_inspected else VectorStageStyle.MID_PLANE
	VectorStageStyle.draw_facet_polygon(
		self,
		PackedVector2Array([
			Vector2(82.0, 92.0),
			Vector2(170.0, 86.0),
			Vector2(176.0, 154.0),
			Vector2(78.0, 160.0),
		]),
		map_color,
		1.0
	)
	var map_accent: Color = VectorStageStyle.ANCHOR_CYAN if is_topography_inspected else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.48)
	for index in range(4):
		var node_position := Vector2(94.0 + float(index) * 22.0, 124.0 - float(index % 2) * 8.0)
		draw_circle(node_position, 3.0, map_accent)
		if index > 0:
			draw_line(node_position - Vector2(22.0, -8.0 if index % 2 == 0 else 8.0), node_position, map_accent, 1.0)

	var console_xs: Array[float] = [220.0, 330.0, 440.0]
	var operation_names: Array[String] = ["A", "B", "C"]
	var console_colors: Array[Color] = [
		VectorStageStyle.ANCHOR_CYAN,
		VectorStageStyle.HUMAN_AMBER,
		VectorStageStyle.CORRECTION_OXIDE,
	]
	for index in range(console_xs.size()):
		var console_x: float = console_xs[index]
		var operation: String = operation_names[index]
		var console_color: Color = console_colors[index]
		var selected := chosen_operation == operation
		if not selected:
			console_color = VectorStageStyle.shade(console_color, 0.46)
		var console_rect := Rect2(console_x - 24.0, 214.0, 48.0, 38.0)
		draw_rect(console_rect, VectorStageStyle.MID_PLANE)
		draw_rect(console_rect, console_color, false, 1.5 if selected else 0.8)
		draw_line(Vector2(console_x - 16.0, 224.0), Vector2(console_x + 16.0, 224.0), console_color, 1.5)
		draw_line(Vector2(console_x - 12.0, 234.0), Vector2(console_x + 12.0, 234.0), console_color, 1.0)
		if selected:
			draw_circle(Vector2(console_x, 246.0), 3.0 + sin(_pulse_phase * 2.8) * 0.8, console_color)

	if is_exit_unlocked:
		draw_line(Vector2(492.0, 224.0), Vector2(604.0, 224.0), VectorStageStyle.HUMAN_AMBER, 2.0)
		draw_line(Vector2(520.0, 232.0), Vector2(604.0, 232.0), VectorStageStyle.ANCHOR_CYAN, 1.0)


func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)
