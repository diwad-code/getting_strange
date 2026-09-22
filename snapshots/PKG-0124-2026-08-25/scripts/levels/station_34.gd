class_name Station34
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Centralny bank rejestru par przetwarza korelacje biograficzne i bilansuje obciążenie sieci trakcyjnej.
## PRZESZKODA — czego wymaga od Leny: Odnalezienia pary wpisów obu Len w rejestrze, skoordynowania łączności z Jakubem i odryglowania pulpitu.
## PRZESZKODA — koszt porażki: Błędna alokacja kanału przeciąża łącze radiowe i opóźnia odczyt współrzędnych sygnału.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("070a0e")
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
signal reactor_inspected
signal desk_inspected
signal thermal_inspected
signal probe_inspected
signal exit_unlocked
signal dialogue_started
signal dialogue_advanced(line_idx: int)
signal dialogue_completed

const LEVEL_ID := "station_34"
const LEVEL_NAME := "Przestrzeń 34: Maszynownia Główna"
const SCENE_SUBTITLE := "Rdzeń korelacyjny / Rejestr par"

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

var is_reactor_inspected: bool = false
var is_desk_inspected: bool = false
var is_thermal_inspected: bool = false
var is_probe_inspected: bool = false

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
		"text": "Maszynownia Główna dudni niskim, wibrującym tonem. W centrum sali obraca się potężny Rdzeń Korelacyjny — rejestr par tożsamościowych.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "To tutaj UCP rejestruje rozbieżności i bilansuje obciążenie sieci trakcyjnej?",
		"is_lena": true
	},
	{
		"speaker": "JAKUB",
		"text": "Rdzeń nie podejmuje decyzji moralnych. On tylko bilansuje wektory sprzeczności. Jeśli dwie wersje zajmują ten sam adres, system wymusza wygaszenie jednej z nich.",
		"is_jakub": true
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Na pulpicie alokacji widnieje wpis pary: LENA WOLSKA (A) oraz LENA WOLSKA (B). Suwak miejscowej Leny ma status: ZAWIESZONA MIĘDZY ADRESAMI.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "Ona nie zginęła i nie uciekła. UCP zablokowało jej powrót, żeby utrzymać konsensus Równi.",
		"is_lena": true
	},
	{
		"speaker": "JAKUB",
		"text": "Wskaźnik termiczny rośnie, gdy obie gałęzie sygnału pozostają aktywne. Prawda nie znika, Lena. Ona po prostu nagrzewa wymienniki.",
		"is_jakub": true
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Próbnik diagnostyczny Jakuba rejestruje współrzędne rezonansu dochodzące z Sektora Filtracji.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "Jeśli zablokujemy suwaki alokacji UCP, zdejmiemy blokadę z jej kanału i zyskamy drogę do basenów filtracyjnych.",
		"is_lena": true
	},
	{
		"speaker": "JAKUB",
		"text": "Zablokowanie alokacji wywoła dekompensację zaworów. Droga do Sektora Filtracji staje otworem.",
		"is_jakub": true
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Zawory dekompresyjne Rdzenia otwierają się z metalicznym trzaskiem. Brama do Sektora 35 zostaje odryglowana.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "Idziemy do filtrów. Pora sprawdzić echo domu i dowiedzieć się, co UCP ukrywało w basenach.",
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
	beat_start.beat_id = &"s34_pair_registry"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Rejestr par tożsamościowych. Obie Leny widnieją w banku maszynowni."
	beat_start.text_en = "Identity pair registry. Both Lenas appear in the engine bank."
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
			state.record_decision(&"s34_pair_registry_unlocked", true)
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
			inspect_reactor()
		3:
			inspect_desk()
		5:
			inspect_thermal()
		6:
			inspect_probe()
		9:
			_unlock_exit()


func inspect_reactor() -> void:
	if is_reactor_inspected:
		return
	is_reactor_inspected = true
	_activate_prop_by_id("prop_reactor")
	reactor_inspected.emit()
	interaction_triggered.emit("prop_reactor")
	_check_unlock()


func inspect_desk() -> void:
	if is_desk_inspected:
		return
	is_desk_inspected = true
	_activate_prop_by_id("prop_desk")
	desk_inspected.emit()
	interaction_triggered.emit("prop_desk")
	_check_unlock()


func inspect_thermal() -> void:
	if is_thermal_inspected:
		return
	is_thermal_inspected = true
	_activate_prop_by_id("prop_thermal")
	thermal_inspected.emit()
	interaction_triggered.emit("prop_thermal")
	_check_unlock()


func inspect_probe() -> void:
	if is_probe_inspected:
		return
	is_probe_inspected = true
	_activate_prop_by_id("prop_probe")
	probe_inspected.emit()
	interaction_triggered.emit("prop_probe")
	_check_unlock()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_activate_prop_by_id("prop_station_34_exit")
	queue_redraw()


func _check_unlock() -> void:
	if is_reactor_inspected and is_desk_inspected and is_thermal_inspected and is_probe_inspected and not is_exit_unlocked:
		_unlock_exit()


func _activate_prop_by_id(id: String) -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint and child.resonance_id == id:
				child.is_activated = true
				child.queue_redraw()


func _on_resonance_triggered(id: String, prop_type: int) -> void:
	match id:
		"prop_reactor":
			inspect_reactor()
		"prop_desk":
			inspect_desk()
		"prop_thermal":
			inspect_thermal()
		"prop_probe":
			inspect_probe()
		"prop_station_34_exit":
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

	# Massive central core reactor cylinder
	draw_rect(Rect2(Vector2(110.0, 80.0), Vector2(60.0, 180.0)), COLOR_PANEL_BASE, true)
	draw_rect(Rect2(Vector2(110.0, 80.0), Vector2(60.0, 180.0)), COLOR_CYAN.lerp(COLOR_BACKGROUND, 0.4), false, 1.5)
	draw_line(Vector2(140.0, 80.0), Vector2(140.0, 260.0), COLOR_CYAN, 2.0)

	# Allocation console desk
	draw_rect(Rect2(Vector2(220.0, 160.0), Vector2(50.0, 100.0)), COLOR_PANEL_CORE, true)
	draw_line(Vector2(220.0, 180.0), Vector2(270.0, 180.0), COLOR_AMBER, 1.5)

	# Thermal indicator gauge
	var therm_col := COLOR_CORRECTION if is_thermal_inspected else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(335.0, 140.0), Vector2(20.0, 60.0)), therm_col.lerp(COLOR_BACKGROUND, 0.3), true)

	# Diagnostic probe connection
	if is_probe_inspected:
		draw_line(Vector2(445.0, 150.0), Vector2(445.0, 240.0), COLOR_CYAN_TECH, 2.0)

	# Exit door frame
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
