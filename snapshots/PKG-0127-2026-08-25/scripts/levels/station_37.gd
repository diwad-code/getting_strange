class_name Station37
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Centralny węzeł nadawczo-antenowy wzmacnia i rozdziela sygnały korelacyjne pomiędzy poziomami Podstruktury.
## PRZESZKODA — czego wymaga od Leny: Ustalenia granic współpracy z Jakubem, zestrojenia oscyloskopu z żywym sygnałem miejscowej Leny i otwarcia mostu.
## PRZESZKODA — koszt porażki: Rozstrojenie krosownicy powoduje interferencję szumu, wymagając ponownej kalibracji częstotliwości nośnej.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("070c10")
const COLOR_PANEL_BASE := Color("141c22")
const COLOR_PANEL_CORE := Color("1c2630")
const COLOR_INFRASTRUCTURE := Color("3d5866")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CYAN_TECH := Color("5da398")
const COLOR_CORRECTION := Color("c65d58")

signal level_completed
signal interaction_triggered(id: String)
signal clue_inspected(id: String, prop_type: int)
signal station_entered
signal oscilloscope_inspected
signal patchbay_inspected
signal antenna_inspected
signal pulpit_inspected
signal exit_unlocked
signal dialogue_started
signal dialogue_advanced(line_idx: int)
signal dialogue_completed

const LEVEL_ID := "station_37"
const LEVEL_NAME := "Przestrzeń 37: Komora Sygnałowa"
const SCENE_SUBTITLE := "Węzeł nadawczy / Żywy sygnał i granica Jakuba"

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

var is_oscilloscope_inspected: bool = false
var is_patchbay_inspected: bool = false
var is_antenna_inspected: bool = false
var is_pulpit_inspected: bool = false

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
		"text": "Komora Sygnałowa to centralny węzeł transmisyjny Podstruktury. Anteny i krosownice zbierają fale rezonansowe z całej sieci.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "Spójrz na oscyloskop. Obie fale nakładają się i tworzą rezonans bez wzajemnego znoszenia. Miejscowa Lena żyje i odpowiada.",
		"is_lena": true
	},
	{
		"speaker": "JAKUB",
		"text": "Wierzbicka uważała, że dwie wersje doprowadzą do implozji. Nie będę umierał za niego, Lena. Dziesięć sekund: mój nadajnik, moja ręka na wyłączniku.",
		"is_jakub": true
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Na krosownicy transmisyjnej spięte są obwody czterech sektorów miasta. Fala nośna reaguje na żywą odpowiedź.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "Jeśli przełączymy hebelki krosownicy, zepniemy kanał nadawczy z odbiornikiem Marty i komorą wyboru.",
		"is_lena": true
	},
	{
		"speaker": "JAKUB",
		"text": "To obudzi pamięć całego miasta i zdejmie blokadę z Linii 4. Będziesz musiała stanąć przed Martą z pełną prawdą.",
		"is_jakub": true
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Pulpit sterujący zostaje uzbrojony. Wskaźniki transmisji przechodzą w stan stabilnego rezonansu.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "Nie boję się sprzeczności ani prawdy o moim świecie. Nie pozwolę dłużej wygaszać wspomnień.",
		"is_lena": true
	},
	{
		"speaker": "JAKUB",
		"text": "Za śluzą transmisyjną zaczyna się Strefa Decyzji i Station 38. Brama otwiera się.",
		"is_jakub": true
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Rygiel śluzy transmisyjnej ustępuje. Ciężka brama ekranowana rozsuwa się płynnie.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "Przejdźmy przez to razem, Jakub. Czas dotrzeć do Marty i dokonać ostatecznego wyboru.",
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
	beat_start.beat_id = &"s37_living_signal"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Żywy sygnał. Miejscowa Lena odpowiada, a Jakub pomaga na własnych warunkach."
	beat_start.text_en = "Living signal. Local Lena responds, and Jakub assists on his own terms."
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
			state.record_decision(&"s37_living_signal_bridged", true)
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
			inspect_oscilloscope()
		5:
			inspect_patchbay()
		7:
			inspect_antenna()
		8:
			inspect_pulpit()
		9:
			_unlock_exit()


func inspect_oscilloscope() -> void:
	if is_oscilloscope_inspected:
		return
	is_oscilloscope_inspected = true
	_activate_prop_by_id("prop_oscilloscope")
	oscilloscope_inspected.emit()
	interaction_triggered.emit("prop_oscilloscope")
	if dialogue_index == 0:
		dialogue_index = 1
		dialogue_advanced.emit(1)
		_show_dialogue_line(1)
	_check_unlock()


func inspect_patchbay() -> void:
	if is_patchbay_inspected:
		return
	is_patchbay_inspected = true
	_activate_prop_by_id("prop_patchbay")
	patchbay_inspected.emit()
	interaction_triggered.emit("prop_patchbay")
	_check_unlock()


func inspect_antenna() -> void:
	if is_antenna_inspected:
		return
	is_antenna_inspected = true
	_activate_prop_by_id("prop_antenna")
	antenna_inspected.emit()
	interaction_triggered.emit("prop_antenna")
	_check_unlock()


func inspect_pulpit() -> void:
	if is_pulpit_inspected:
		return
	is_pulpit_inspected = true
	_activate_prop_by_id("prop_pulpit")
	pulpit_inspected.emit()
	interaction_triggered.emit("prop_pulpit")
	_check_unlock()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_activate_prop_by_id("prop_station_37_exit")
	queue_redraw()


func _check_unlock() -> void:
	if is_oscilloscope_inspected and is_patchbay_inspected and is_antenna_inspected and is_pulpit_inspected and not is_exit_unlocked:
		_unlock_exit()


func _activate_prop_by_id(id: String) -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint and child.resonance_id == id:
				child.is_activated = true
				child.queue_redraw()


func _on_resonance_triggered(id: String, prop_type: int) -> void:
	match id:
		"prop_oscilloscope":
			inspect_oscilloscope()
		"prop_patchbay":
			inspect_patchbay()
		"prop_antenna":
			inspect_antenna()
		"prop_pulpit":
			inspect_pulpit()
		"prop_station_37_exit":
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

	# Oscilloscope rack
	draw_rect(Rect2(Vector2(110.0, 140.0), Vector2(60.0, 120.0)), COLOR_PANEL_BASE, true)
	var osc_col := COLOR_CYAN if is_oscilloscope_inspected else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(120.0, 150.0), Vector2(40.0, 40.0)), osc_col.lerp(COLOR_BACKGROUND, 0.4), true)
	draw_line(Vector2(120.0, 170.0), Vector2(160.0, 170.0), osc_col, 1.5)

	# Patchbay matrix
	var pb_col := COLOR_AMBER if is_patchbay_inspected else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(220.0, 150.0), Vector2(50.0, 110.0)), COLOR_PANEL_CORE, true)
	for row in range(3):
		for col in range(3):
			draw_circle(Vector2(230.0 + float(col) * 15.0, 170.0 + float(row) * 20.0), 3.0, pb_col)

	# Transmission antenna tower mast
	draw_line(Vector2(345.0, 80.0), Vector2(345.0, 260.0), COLOR_INFRASTRUCTURE, 3.0)
	if is_antenna_inspected:
		draw_circle(Vector2(345.0, 80.0), 8.0, COLOR_CYAN_TECH)

	# Control pulpit
	var pul_col := COLOR_AMBER_WARM if is_pulpit_inspected else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(430.0, 180.0), Vector2(40.0, 80.0)), pul_col.lerp(COLOR_BACKGROUND, 0.3), true)

	# Exit gate to Station 38
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
