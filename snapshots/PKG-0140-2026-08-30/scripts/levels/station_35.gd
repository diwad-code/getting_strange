class_name Station35
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Baseny filtracji sedacyjnej odprowadzają osad zniekształceń korelacyjnych z instalacji Podstruktury.
## PRZESZKODA — czego wymaga od Leny: Zbadania lustra osadu, odsłuchania transmisji domowej Marty i zrozumienia braku prostego swapu.
## PRZESZKODA — koszt porażki: Próba ignorowania sygnału domowego zamazuje stabilność kotwicy, wymuszając ponowne zestrojenie odbiornika.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("060b0e")
const COLOR_PANEL_BASE := Color("141c22")
const COLOR_PANEL_CORE := Color("1c2630")
const COLOR_INFRASTRUCTURE := Color("3d5866")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CYAN_TECH := Color("5da398")
const COLOR_CORRECTION := Color("c65d58")

signal level_completed
signal previous_level_requested
signal interaction_triggered(id: String)
signal clue_inspected(id: String, prop_type: int)
signal station_entered
signal pool_inspected
signal valve_inspected
signal chemical_inspected
signal monitor_inspected
signal exit_unlocked
signal dialogue_started
signal dialogue_advanced(line_idx: int)
signal dialogue_completed

const LEVEL_ID := "station_35"
const LEVEL_NAME := "Przestrzeń 35: Sektor Filtracji"
const SCENE_SUBTITLE := "Baseny sedacyjne / Echo domu i głos Marty"

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

var is_pool_inspected: bool = false
var is_valve_inspected: bool = false
var is_chemical_inspected: bool = false
var is_monitor_inspected: bool = false

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
		"text": "Sektor Filtracji to rozległa podziemna hala z betonowymi basenami sedacyjnymi. W mętnej cieczy unoszą się nieostre smugi — ślady wypartych wariantów pamięci.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "Ta woda... świeci tym samym odcieniem co zrzut skażenia z rysunku Szymona. To osad z procedur wygaszania.",
		"is_lena": true
	},
	{
		"speaker": "JAKUB",
		"text": "To roztwór sedacyjny nasycony osadem korelacyjnym. Wszystko, co UCP wymazało z pamięci miasta, spływa tutaj i ulega rozkładowi.",
		"is_jakub": true
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Odbiornik echa domu rejestruje urwaną transmisję z domowej ciągłości przybyłej Leny.",
		"is_witness": true
	},
	{
		"speaker": "MARTA DOMOWA // NAGRANIE",
		"text": "Lena, odbierz. Nie jestem zła. Dobra, jestem. Odbierz mimo to.",
		"is_marta_home": true
	},
	{
		"speaker": "LENA",
		"text": "Marta czekała. Ja znowu mierzyłam. Mój świat nie czekał zamrożony — zgłoszono moje zaginięcie.",
		"is_lena": true
	},
	{
		"speaker": "JAKUB",
		"text": "Monitor nie rejestruje miejscowej Leny w twoim domu. Nie doszło do prostej zamiany miejsc. Ona jest uwięziona w kanale drenażowym.",
		"is_jakub": true
	},
	{
		"speaker": "LENA",
		"text": "Jeśli otworzymy zawór spustowy, osuszymy baseny i odblokujemy przejście do drenażu trakcyjnego.",
		"is_lena": true
	},
	{
		"speaker": "JAKUB",
		"text": "Odpływ prowadzi bezpośrednio do Zimnego Ścieku pod starą pętlą tramwajową.",
		"is_jakub": true
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Koło zaworu spustowego obraca się z ciężkim oporem. Poziom roztworu w basenach opada, odsłaniając śluzę do Kanału Odpływowego.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "Pora skonfrontować Wierzbicką z rachunkiem Linii 4.",
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
	beat_start.beat_id = &"s35_home_echo"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Echo domu. Wiadomość Marty potwierdza, że tamten świat poszedł dalej."
	beat_start.text_en = "Home echo. Marta's message confirms that world has moved on."
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
			state.record_decision(&"s35_home_echo_processed", true)
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
			inspect_pool()
		3:
			inspect_chemical()
		4:
			inspect_monitor()
		8:
			inspect_valve()
		9:
			_unlock_exit()


func inspect_pool() -> void:
	if is_pool_inspected:
		return
	is_pool_inspected = true
	_activate_prop_by_id("prop_pool")
	pool_inspected.emit()
	interaction_triggered.emit("prop_pool")
	if dialogue_index == 0:
		dialogue_index = 1
		dialogue_advanced.emit(1)
		_show_dialogue_line(1)
	_check_unlock()


func inspect_valve() -> void:
	if is_valve_inspected:
		return
	is_valve_inspected = true
	_activate_prop_by_id("prop_valve")
	valve_inspected.emit()
	interaction_triggered.emit("prop_valve")
	_check_unlock()


func inspect_chemical() -> void:
	if is_chemical_inspected:
		return
	is_chemical_inspected = true
	_activate_prop_by_id("prop_chemical")
	chemical_inspected.emit()
	interaction_triggered.emit("prop_chemical")
	_check_unlock()


func inspect_monitor() -> void:
	if is_monitor_inspected:
		return
	is_monitor_inspected = true
	_activate_prop_by_id("prop_monitor")
	monitor_inspected.emit()
	interaction_triggered.emit("prop_monitor")
	_check_unlock()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_activate_prop_by_id("prop_station_35_exit")
	queue_redraw()


func _check_unlock() -> void:
	if is_pool_inspected and is_valve_inspected and is_chemical_inspected and is_monitor_inspected and not is_exit_unlocked:
		_unlock_exit()


func _activate_prop_by_id(id: String) -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint and child.resonance_id == id:
				child.is_activated = true
				child.queue_redraw()


func _on_resonance_triggered(id: String, prop_type: int) -> void:
	match id:
		"prop_pool":
			inspect_pool()
		"prop_valve":
			inspect_valve()
		"prop_chemical":
			inspect_chemical()
		"prop_monitor":
			inspect_monitor()
		"prop_station_35_exit":
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

	# Concrete basin structures
	draw_rect(Rect2(Vector2(90.0, 160.0), Vector2(120.0, 100.0)), COLOR_PANEL_BASE, true)
	draw_rect(Rect2(Vector2(90.0, 160.0), Vector2(120.0, 100.0)), COLOR_CYAN_TECH.lerp(COLOR_BACKGROUND, 0.4), false, 1.5)

	# Phosphorescent liquid pool surface
	var liquid_col := COLOR_CYAN_TECH.lerp(COLOR_BACKGROUND, 0.2)
	draw_rect(Rect2(Vector2(100.0, 190.0), Vector2(100.0, 60.0)), liquid_col, true)

	# Valve wheel
	var valve_col := COLOR_AMBER if is_valve_inspected else COLOR_INFRASTRUCTURE
	draw_circle(Vector2(245.0, 200.0), 16.0, COLOR_PANEL_BASE)
	draw_circle(Vector2(245.0, 200.0), 16.0, valve_col)

	# Chemical sampler port
	if is_chemical_inspected:
		draw_rect(Rect2(Vector2(335.0, 160.0), Vector2(20.0, 50.0)), COLOR_CYAN, true)

	# Home echo monitor
	var mon_col := COLOR_AMBER_WARM if is_monitor_inspected else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(435.0, 140.0), Vector2(30.0, 30.0)), mon_col.lerp(COLOR_BACKGROUND, 0.3), true)

	# Exit sluice
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
