class_name Station36
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Główny kanał drenażu trakcyjnego odprowadza energię zrzutową z węzła Linii 4 do kolektora burzowego.
## PRZESZKODA — czego wymaga od Leny: Odczytania rejestru pary katastrof, konfrontacji z Wierzbicką i odblokowania zasuwy burzowej.
## PRZESZKODA — koszt porażki: Gwałtowny zrzut wody drenażowej zamyka kratę rewizyjną, zmuszając do zresetowania cyklu upustowego.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("05090c")
const COLOR_PANEL_BASE := Color("141c22")
const COLOR_PANEL_CORE := Color("1c2630")
const COLOR_INFRASTRUCTURE := Color("3d5866")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")

signal level_completed
signal interaction_triggered(id: String)
signal clue_inspected(id: String, prop_type: int)
signal station_entered
signal weir_inspected
signal current_inspected
signal ladder_inspected
signal tap_inspected
signal exit_unlocked
signal dialogue_started
signal dialogue_advanced(line_idx: int)
signal dialogue_completed

const LEVEL_ID := "station_36"
const LEVEL_NAME := "Przestrzeń 36: Drenaż trakcyjny"
const SCENE_SUBTITLE := "Para katastrof / Rachunek Linii 4 i warunek Wierzbickiej"

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

var is_weir_inspected: bool = false
var is_current_inspected: bool = false
var is_ladder_inspected: bool = false
var is_tap_inspected: bool = false

var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: Node2D = get_node_or_null("Camera") if get_node_or_null("Camera") else get_node_or_null("Camera2D")
@onready var geometry: Node2D = get_node_or_null("Geometry")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")
@onready var guidance_service: NarrativeGuidanceService = get_node_or_null("NarrativeGuidanceService")

const DIALOGUE_LINES: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Kanał Odpływowy to ponura betonowa gardziel burzowa pod fundamentami Starej Pętli. Woda drenażowa niesie energię zrzutową z Linii 4.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "Spójrz na tę smugę. Fosforyzujący osad spływa bezpośrednio do podziemnych warstw wodonośnych miasta.",
		"is_lena": true
	},
	{
		"speaker": "JAKUB",
		"text": "UCP wiedziało, że zrzut energii korelacyjnej zatruwa drenaż. Dr Wierzbicka uznała to za dopuszczalny koszt stabilizacji.",
		"is_jakub": true
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Na kracie jazu burzowego zatrzymały się odłamki przeszłości: tablica tramwaju linii 4 i wykres korelacyjny.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "To nie był margines błędu. Tunel Linii 4 w Równi ocalono kosztem katastrofy w moim świecie. Mój brat zginął w tamtej kolizji.",
		"is_lena": true
	},
	{
		"speaker": "JAKUB",
		"text": "Dr Wierzbicka uważała, że alternatywą było załamanie całej struktury. Ale rachunek nigdy nie był symetryczny.",
		"is_jakub": true
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Kurek probierczy wód gruntowych wskazuje wysokie stężenie energii zrzutowej Linii 4.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "Marta i inni żyją obok tego skażenia każdego dnia. Nie pozwolę, by ten dług nadal rósł.",
		"is_lena": true
	},
	{
		"speaker": "JAKUB",
		"text": "Jeśli przejdziemy przez bramę przeciwsztormową, wejdziemy do Komory Sygnałowej.",
		"is_jakub": true
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Rygle bramy przeciwsztormowej cofają się z hukiem. Droga do Komory Sygnałowej zostaje otwarta.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "Idziemy do Komory Sygnałowej. Czas nadać żywy sygnał i podjąć decyzję.",
		"is_lena": true
	}
]

var dialogue_lines: Array[Dictionary] = DIALOGUE_LINES


func _ready() -> void:
	if player:
		player.position = Vector2(50.0, 240.0)
	if camera:
		camera.position = Vector2(320.0, 180.0)
	if airlock_zone and not airlock_zone.body_entered.is_connected(_on_airlock_zone_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_zone_body_entered)
	_setup_props()
	_setup_guidance()
	station_entered.emit()
	if dialogue_active:
		_show_dialogue_line(dialogue_index)


func _setup_props() -> void:
	if not props:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var pt := child as MemoryResonancePoint
			if not pt.resonance_triggered.is_connected(_on_resonance_triggered):
				pt.resonance_triggered.connect(_on_resonance_triggered)


func _setup_guidance() -> void:
	if not guidance_service:
		return
	var beat_start := GuidanceBeat.new()
	beat_start.beat_id = &"s36_line4_ledger"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Rachunek Linii 4. Utrzymanie Równi koreluje z katastrofą w domu."
	beat_start.text_en = "Line 4 ledger. Rowien's stability correlates with disaster back home."
	guidance_service.register_beat(beat_start)


func _process(delta: float) -> void:
	_pulse_phase += delta
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 2.0)
		queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		if dialogue_active:
			advance_dialogue()


func advance_dialogue() -> int:
	if not dialogue_active:
		return -1
	dialogue_index += 1
	if dialogue_index < dialogue_lines.size():
		_apply_dialogue_state(dialogue_index)
		dialogue_advanced.emit(dialogue_index)
		_show_dialogue_line(dialogue_index)
		queue_redraw()
		return dialogue_index
	else:
		dialogue_active = false
		is_dialogue_completed = true
		_unlock_exit()
		if dialogue_box and dialogue_box.has_method("hide_box"):
			dialogue_box.hide_box()
		var state := get_node_or_null("/root/GameStateManager")
		if state:
			state.record_decision(&"s36_line4_ledger_revealed", true)
		dialogue_completed.emit()
		queue_redraw()
		return -1


func _show_dialogue_line(idx: int) -> void:
	if idx < 0 or idx >= dialogue_lines.size():
		return
	var line: Dictionary = dialogue_lines[idx]
	if dialogue_box and dialogue_box.has_method("show_line"):
		dialogue_box.show_line(line.get("speaker", "ŚWIADECTWO"), line.get("text", ""))


func _apply_dialogue_state(idx: int) -> void:
	match idx:
		1:
			inspect_current()
		2:
			inspect_weir()
		4:
			inspect_ladder()
		8:
			inspect_tap()
		9:
			_unlock_exit()


func inspect_weir() -> void:
	if is_weir_inspected:
		return
	is_weir_inspected = true
	_activate_prop_by_id("prop_weir")
	weir_inspected.emit()
	interaction_triggered.emit("prop_weir")
	_check_unlock()


func inspect_current() -> void:
	if is_current_inspected:
		return
	is_current_inspected = true
	_activate_prop_by_id("prop_current")
	current_inspected.emit()
	interaction_triggered.emit("prop_current")
	if dialogue_index == 0:
		dialogue_index = 1
		dialogue_advanced.emit(1)
		_show_dialogue_line(1)
	_check_unlock()


func inspect_ladder() -> void:
	if is_ladder_inspected:
		return
	is_ladder_inspected = true
	_activate_prop_by_id("prop_ladder")
	ladder_inspected.emit()
	interaction_triggered.emit("prop_ladder")
	_check_unlock()


func inspect_tap() -> void:
	if is_tap_inspected:
		return
	is_tap_inspected = true
	_activate_prop_by_id("prop_tap")
	tap_inspected.emit()
	interaction_triggered.emit("prop_tap")
	_check_unlock()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_activate_prop_by_id("prop_station_36_exit")
	queue_redraw()


func _check_unlock() -> void:
	if is_weir_inspected and is_current_inspected and is_ladder_inspected and is_tap_inspected and not is_exit_unlocked:
		_unlock_exit()


func _activate_prop_by_id(id: String) -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint and child.resonance_id == id:
				child.is_activated = true
				child.queue_redraw()


func _on_resonance_triggered(id: String, prop_type: int) -> void:
	match id:
		"prop_weir":
			inspect_weir()
		"prop_current":
			inspect_current()
		"prop_ladder":
			inspect_ladder()
		"prop_tap":
			inspect_tap()
		"prop_station_36_exit":
			if is_exit_unlocked:
				_trigger_level_completion()
	clue_inspected.emit(id, prop_type)


func _on_airlock_zone_body_entered(body: Node2D) -> void:
	if is_level_completed:
		return
	if body == player or (body and body.name == "Player"):
		_trigger_level_completion()


func _trigger_level_completion() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	# Storm sewer vaulted culvert
	draw_rect(Rect2(Vector2(80.0, 160.0), Vector2(100.0, 100.0)), COLOR_PANEL_BASE, true)
	draw_rect(Rect2(Vector2(80.0, 160.0), Vector2(100.0, 100.0)), COLOR_INFRASTRUCTURE, false, 1.5)

	# Weir gate structure
	var weir_col := COLOR_CORRECTION if is_weir_inspected else COLOR_INFRASTRUCTURE
	draw_line(Vector2(140.0, 160.0), Vector2(140.0, 260.0), weir_col, 2.5)

	# Drainage current stream
	draw_rect(Rect2(Vector2(190.0, 240.0), Vector2(120.0, 20.0)), COLOR_CYAN.lerp(COLOR_BACKGROUND, 0.4), true)

	# Catwalk ladder
	if is_ladder_inspected:
		draw_line(Vector2(345.0, 140.0), Vector2(345.0, 240.0), COLOR_AMBER, 2.0)

	# Contamination sampling tap
	var tap_col := COLOR_AMBER_WARM if is_tap_inspected else COLOR_INFRASTRUCTURE
	draw_circle(Vector2(445.0, 200.0), 12.0, tap_col)

	# Exit sluice gate
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
