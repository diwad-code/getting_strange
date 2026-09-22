class_name Station27
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Posterunek rozrządu Linii 4 wymaga nadania trzech impulsów kontrolnych w celu synchronizacji zwrotnicy Podstruktury.
## PRZESZKODA — czego wymaga od Leny: Wprowadzenia żywego sygnału z celowym błędem w porozumieniu z Jakubem, co potwierdza autentyczność świadectwa.
## PRZESZKODA — koszt porażki: Zablokowanie zwrotnicy, zrzut bufora impulsów i konieczność ponownej synchronizacji odczytów monitora.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("0c1114")
const COLOR_CONSOLE_FRAME := Color("162026")
const COLOR_MONITOR_SCREEN := Color("1c2830")
const COLOR_INFRASTRUCTURE := Color("456372")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.22)
const COLOR_BEIGE_ASH := Color("c8a370")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CYAN_TECH := Color("5da398")
const COLOR_CORRECTION := Color("c65d58")

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal badge_inspected()
signal jakub_interacted()
signal monitor_inspected()
signal console_inspected()
signal exit_unlocked()
signal dialogue_started()
signal dialogue_advanced(line_idx: int)
signal dialogue_completed()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")
@onready var guidance_service: NarrativeGuidanceService = get_node_or_null("NarrativeGuidanceService")

var is_badge_inspected: bool = false
var is_jakub_interacted: bool = false
var is_monitor_inspected: bool = false
var is_console_inspected: bool = false
var is_exit_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _exit_open_progress: float = 0.0

var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Dwie równe. Trzecia z błędem. Pulpit rozrządu rejestruje testowe impulsy przesyłane wzdłuż trakcji Linii 4.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "JAKUB",
		"text": "Wierzbicka wyciągnęła mnie z tamtego wagonu. Dała mi drugą szansę w świecie, który nie pamięta tamtego poranka.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "I dała ci mundur i numer pracowniczy, żebyś nigdy nie zapytał o prawdę.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Dała mi dwanaście lat życia bez strachu, że rozpadnę się na ulicy.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Jakub wskazuje monitor stabilności. Wykresy naprężeń korelacyjnych błękitnieją w równym rytmie.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "JAKUB",
		"text": "Nie chcę umierać znowu. Jeśli ten świat zniknie, ja zniknę razem z nim.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Nie przyszłam burzyć miasta. Przyszłam zabrać cię do domu.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Więc udowodnij to. Przejedźmy Linię 4 razem.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Lena dotyka dłoni brata. Trzeci impuls wprowadzony do konsoli stabilizuje zwrotnicę.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "JAKUB",
		"text": "Skład techniczny Linii 4 stoi na peronie dwudziestym ósmym. Droga jest wolna.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Brama techniczna Podstruktury unosi się. Sygnalizator manewrowy otwiera drogę do Przestrzeni 28.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	}
]


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


func _setup_props() -> void:
	if not props:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var pt := child as MemoryResonancePoint
			if not pt.resonance_triggered.is_connected(_on_prop_inspected):
				pt.resonance_triggered.connect(_on_prop_inspected.bind(pt))


func _setup_guidance() -> void:
	if not guidance_service:
		return
	var beat_start := GuidanceBeat.new()
	beat_start.beat_id = &"s27_three_repeats"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Wysyłam trzy impulsy. Trzeci ma celowy błąd."
	beat_start.text_en = "Sending three pulses. The third contains an intentional error."
	guidance_service.register_beat(beat_start)


func _process(delta: float) -> void:
	_pulse_time += delta
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 2.0)
		queue_redraw()


func _on_prop_inspected(id: String, prop_type: int, pt: MemoryResonancePoint = null) -> void:
	var prop_name: String = String(pt.name) if pt else id
	match prop_name:
		"WorkerBadge", "prop_worker_badge":
			inspect_badge()
		"JakubOperator", "prop_jakub_operator":
			interact_jakub()
		"SurfaceMonitor", "prop_surface_monitor":
			inspect_monitor()
		"JunctionConsole", "prop_junction_console":
			inspect_console()
		"Station27Exit", "prop_station_27_exit":
			if is_exit_unlocked:
				_trigger_level_completion()
	clue_inspected.emit(id, prop_type)


func inspect_badge() -> void:
	if is_badge_inspected:
		return
	is_badge_inspected = true
	var p := props.get_node_or_null("WorkerBadge") as MemoryResonancePoint
	if p:
		p.is_activated = true
	badge_inspected.emit()
	_check_unlock()


func interact_jakub() -> void:
	if is_jakub_interacted:
		return
	is_jakub_interacted = true
	var p := props.get_node_or_null("JakubOperator") as MemoryResonancePoint
	if p:
		p.is_activated = true
	jakub_interacted.emit()
	start_dialogue()
	_check_unlock()


func inspect_monitor() -> void:
	if is_monitor_inspected:
		return
	is_monitor_inspected = true
	var p := props.get_node_or_null("SurfaceMonitor") as MemoryResonancePoint
	if p:
		p.is_activated = true
	monitor_inspected.emit()
	_check_unlock()


func inspect_console() -> void:
	if is_console_inspected:
		return
	is_console_inspected = true
	var p := props.get_node_or_null("JunctionConsole") as MemoryResonancePoint
	if p:
		p.is_activated = true
	console_inspected.emit()
	_check_unlock()


func send_first_pulse() -> void:
	inspect_badge()


func send_second_pulse() -> void:
	interact_jakub()


func send_third_pulse() -> void:
	inspect_console()


func start_dialogue() -> void:
	if is_dialogue_completed or dialogue_active:
		return
	dialogue_active = true
	dialogue_index = 0
	dialogue_started.emit()
	_show_dialogue_line(0)


func advance_dialogue() -> int:
	if not dialogue_active:
		return -1
	dialogue_index += 1
	if dialogue_index < dialogue_lines.size():
		if dialogue_index == 4:
			is_monitor_inspected = true
		elif dialogue_index == 9:
			_unlock_exit()
		dialogue_advanced.emit(dialogue_index)
		_show_dialogue_line(dialogue_index)
		return dialogue_index
	else:
		dialogue_active = false
		is_dialogue_completed = true
		_unlock_exit()
		if dialogue_box and dialogue_box.has_method("hide_box"):
			dialogue_box.hide_box()
		var state := get_node_or_null("/root/GameStateManager")
		if state:
			state.record_decision(&"s27_pulses_sent", true)
		dialogue_completed.emit()
		return -1


func _show_dialogue_line(idx: int) -> void:
	if idx < 0 or idx >= dialogue_lines.size():
		return
	var line: Dictionary = dialogue_lines[idx]
	if dialogue_box and dialogue_box.has_method("show_line"):
		dialogue_box.show_line(line.get("speaker", "JAKUB"), line.get("text", ""))


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	var p := props.get_node_or_null("Station27Exit") as MemoryResonancePoint
	if p:
		p.is_activated = true
	queue_redraw()


func _check_unlock() -> void:
	if is_badge_inspected and is_jakub_interacted and is_monitor_inspected and is_console_inspected and not is_exit_unlocked:
		_unlock_exit()


func _on_airlock_zone_body_entered(body: Node2D) -> void:
	if body == player and is_exit_unlocked and not is_level_completed:
		_trigger_level_completion()


func _trigger_level_completion() -> void:
	is_level_completed = true
	level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	
	# Console frame & monitor
	draw_rect(Rect2(Vector2(60.0, 170.0), Vector2(140.0, 110.0)), COLOR_CONSOLE_FRAME, true)
	draw_rect(Rect2(Vector2(70.0, 180.0), Vector2(120.0, 90.0)), COLOR_MONITOR_SCREEN, true)
	draw_rect(Rect2(Vector2(240.0, 170.0), Vector2(240.0, 110.0)), COLOR_INFRASTRUCTURE, true)
	
	# Exit door frame
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
