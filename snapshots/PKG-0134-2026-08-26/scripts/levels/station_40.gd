class_name Station40
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Sala Negocjacyjna istnieje, aby świadkowie mogli nazwać koszty trzech operacji przed ich wykonaniem.
## PRZESZKODA — czego wymaga od Leny: Wysłuchania Wierzbickiej, Marty, Jakuba i Szymona oraz wejścia do Komory Wyboru dopiero po rozpoznaniu znanych kosztów.
## PRZESZKODA — koszt porażki: Nie ma korekty fizycznej; decyzja jest trudna i nieodwracalna, a komora blokuje przejście do momentu wysłuchania racji stron.

signal level_completed
signal previous_level_requested
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

# Narrative progress tracking flags
var is_terminal_inspected: bool = false
var is_marta_inspected: bool = false
var is_szymon_inspected: bool = false
var is_cost_matrix_inspected: bool = false

# Internal visuals
var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: Camera2D = get_node_or_null("Camera2D")
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
	if camera:
		camera.position = Vector2(320.0, 180.0)
	
	if airlock_zone and not airlock_zone.body_entered.is_connected(_on_airlock_zone_entered):
		airlock_zone.body_entered.connect(_on_airlock_zone_entered)
	
	_connect_prop_signals()
	_setup_guidance()
	if dialogue_active:
		_show_dialogue_line(dialogue_index)


func _setup_guidance() -> void:
	if not guidance_service:
		return
	var beat_start := GuidanceBeat.new()
	beat_start.beat_id = &"s40_negotiation"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Sala negocjacyjna. Wierzbicka broni stabilności, Marta patrzy bez uniku."
	beat_start.text_en = "Negotiation chamber. Wierzbicka defends stability, Marta looks without evasion."
	guidance_service.register_beat(beat_start)


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


func _on_prop_resonance_triggered(id: String, prop_type: int) -> void:
	interaction_triggered.emit(id)
	
	if id in ["wierzbicka_terminal", "prop_wierzbicka_terminal"] or prop_type == 187:
		is_terminal_inspected = true
		if dialogue_index == 0 or dialogue_index == 1:
			advance_dialogue()
	elif id in ["cost_matrix", "prop_cost_matrix"] or prop_type == 190:
		is_cost_matrix_inspected = true
		if dialogue_index in [2, 3, 4, 5]:
			advance_dialogue()
	elif id in ["marta_witness", "prop_marta_witness"] or prop_type == 188:
		is_marta_inspected = true
		if dialogue_index in [6, 7, 8]:
			advance_dialogue()
	elif id in ["szymon_monitor", "prop_szymon_monitor"] or prop_type == 189:
		is_szymon_inspected = true
		if dialogue_index in [9, 10]:
			advance_dialogue()
	elif id in ["station_40_exit", "prop_station_40_exit"] or prop_type == 191:
		if is_exit_unlocked:
			_complete_level()


func advance_dialogue() -> void:
	if not dialogue_active:
		return
	
	if dialogue_index < DIALOGUE_LINES.size() - 1:
		dialogue_index += 1
		dialogue_advanced.emit(dialogue_index)
		_show_dialogue_line(dialogue_index)
		
		# Line 11/12 triggers the operational choice chamber door unseal
		if dialogue_index >= 11:
			unlock_exit()
	else:
		is_dialogue_completed = true
		dialogue_active = false
		unlock_exit()
		if dialogue_box and dialogue_box.has_method("hide_box"):
			dialogue_box.hide_box()
		var state := get_node_or_null("/root/GameStateManager")
		if state:
			state.record_decision(&"s40_final_impulse_ready", true)


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
	
	if props:
		var exit_prop := props.get_node_or_null("Station40Exit") as MemoryResonancePoint
		if exit_prop:
			exit_prop.is_activated = true
			exit_prop.queue_redraw()
	
	queue_redraw()


func _on_airlock_zone_entered(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		if is_exit_unlocked:
			_complete_level()


func _complete_level() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


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
	var szymon_color := VectorStageStyle.ANCHOR_CYAN if is_szymon_inspected else VectorStageStyle.MID_PLANE
	draw_line(Vector2(410.0, 166.0), Vector2(472.0, 166.0), szymon_color, 2.0)
	if is_exit_unlocked:
		draw_line(Vector2(522.0, 222.0), Vector2(606.0, 222.0), VectorStageStyle.ANCHOR_CYAN, 2.0)
