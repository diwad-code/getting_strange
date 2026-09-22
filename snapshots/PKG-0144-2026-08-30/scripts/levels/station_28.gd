class_name Station28
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Wózek inspekcyjny na torowisku Linii 4 wymaga transferu sygnału przy ograniczonym paśmie transmisyjnym.
## PRZESZKODA — czego wymaga od Leny: Utrzymania ciągłości relacji w czasie jazdy i wyboru między zapamiętaniem detalu a redukcją szumu.
## PRZESZKODA — koszt porażki: Zniekształcenie sygnału w szumie tunelowym, desynchronizacja wagonu i spadek czytelności wskaźników.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("0d1215")
const COLOR_TUNNEL_WALL := Color("141d22")
const COLOR_CARRIAGE_BODY := Color("1e2a31")
const COLOR_CARRIAGE_INTERIOR := Color("182228")
const COLOR_INFRASTRUCTURE := Color("4a6875")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.22)
const COLOR_BEIGE_ASH := Color("c8a370")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CYAN_TECH := Color("5da398")
const COLOR_CORRECTION := Color("c65d58")

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal console_interacted()
signal window_inspected()
signal paradox_inspected()
signal intercom_inspected()
signal exit_unlocked()
signal dialogue_started()
signal dialogue_advanced(line_idx: int)
signal dialogue_completed()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")
@onready var guidance_service: NarrativeGuidanceService = get_node_or_null("NarrativeGuidanceService")

var is_console_interacted: bool = false
var is_window_inspected: bool = false
var is_paradox_inspected: bool = false
var is_intercom_inspected: bool = false
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
		"text": "Wagon toczy się powoli w głąb tunelu Linii 4. Przez okna widać zarysy opuszczonych bocznic technicznych.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "JAKUB",
		"text": "Patrz w okna. Na powierzchni nie ma już tamtego przystanku, Leno. Jest tylko trawnik i parking z płyt betonowych.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Widzę go. Pusty peron, żółta ławka i kiosk z biletami.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Karetki? Ja widzę tylko wersję, którą sama sobie opowiedziałaś, żeby nie zwariować.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Są trzy wersje, Jakub. I każda zostawiła ślad w szkle i miedzi.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Mijane tablice stacyjne rozszczepiają się na potrójny widok zdarzenia. Pustka, interwencja, konsensus.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "JAKUB",
		"text": "Widzę tylko dwie. Trzecia jest zbyt bolesna, żeby na nią patrzeć.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Dlatego jedziemy razem. Nie zniszczę archiwum, ale zabiorę cię stąd.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Głośnik interkomu w kabinie trzeszczy gwałtownie. Głos dr Wierzbickiej rozbrzmiewa w metalowym wnętrzu.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Nie ścigam państwa. Zamykam drogę. Węzeł 29 to ostatni punkt powrotu.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Skład uderza w hamulce pneumatyczne. Wagon zatrzymuje się przed bramą Przestrzeni 29.",
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
	_setup_camera()
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
	beat_start.beat_id = &"s28_line4_travel"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Jazda Linią 4. Z każdym metrem tunel staje się gęstszy od sygnałów."
	beat_start.text_en = "Travelling on Line 4. With every meter the tunnel grows denser with signals."
	guidance_service.register_beat(beat_start)


func _process(delta: float) -> void:
	_pulse_time += delta
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 2.0)
		queue_redraw()


func _on_prop_inspected(id: String, prop_type: int, pt: MemoryResonancePoint = null) -> void:
	var prop_name: String = String(pt.name) if pt else id
	match prop_name:
		"DriverConsole", "prop_driver_console", "CabControlConsole", "prop_cab_control_console":
			interact_console()
		"TransitWindow", "prop_transit_window", "TunnelViewWindow", "prop_tunnel_view_window":
			inspect_window()
		"ParadoxViewport", "prop_paradox_viewport", "SignalLossParadox", "prop_signal_loss_paradox":
			inspect_paradox()
		"ClosingIntercom", "prop_closing_intercom", "PassengerIntercom", "prop_passenger_intercom":
			inspect_intercom()
		"Station28Exit", "prop_station_28_exit":
			if is_exit_unlocked:
				_trigger_level_completion()
	clue_inspected.emit(id, prop_type)


func interact_console() -> void:
	if is_console_interacted:
		return
	is_console_interacted = true
	var p := props.get_node_or_null("DriverConsole") as MemoryResonancePoint
	if p:
		p.is_activated = true
	console_interacted.emit()
	start_dialogue()
	_check_unlock()


func inspect_console() -> void:
	interact_console()


func inspect_window() -> void:
	if is_window_inspected:
		return
	is_window_inspected = true
	var p := props.get_node_or_null("TransitWindow") as MemoryResonancePoint
	if p:
		p.is_activated = true
	window_inspected.emit()
	_check_unlock()


func inspect_paradox() -> void:
	if is_paradox_inspected:
		return
	is_paradox_inspected = true
	var p := props.get_node_or_null("ParadoxViewport") as MemoryResonancePoint
	if p:
		p.is_activated = true
	paradox_inspected.emit()
	_check_unlock()


func inspect_intercom() -> void:
	if is_intercom_inspected:
		return
	is_intercom_inspected = true
	var p := props.get_node_or_null("ClosingIntercom") as MemoryResonancePoint
	if p:
		p.is_activated = true
	intercom_inspected.emit()
	_check_unlock()


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
		if dialogue_index == 2:
			inspect_window()
		elif dialogue_index == 5:
			inspect_paradox()
		elif dialogue_index == 8:
			inspect_intercom()
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
			state.record_decision(&"s28_carriage_travel_completed", true)
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
	var p := props.get_node_or_null("Station28Exit") as MemoryResonancePoint
	if p:
		p.is_activated = true
	queue_redraw()


func _check_unlock() -> void:
	if is_console_interacted and is_window_inspected and is_paradox_inspected and is_intercom_inspected and not is_exit_unlocked:
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
	
	# Train car body and window frames
	draw_rect(Rect2(Vector2(40.0, 180.0), Vector2(480.0, 90.0)), COLOR_CARRIAGE_BODY, true)
	draw_rect(Rect2(Vector2(60.0, 195.0), Vector2(100.0, 45.0)), COLOR_CARRIAGE_INTERIOR, true)
	draw_rect(Rect2(Vector2(180.0, 195.0), Vector2(100.0, 45.0)), COLOR_CARRIAGE_INTERIOR, true)
	draw_rect(Rect2(Vector2(300.0, 195.0), Vector2(100.0, 45.0)), COLOR_CARRIAGE_INTERIOR, true)
	draw_rect(Rect2(Vector2(420.0, 195.0), Vector2(90.0, 45.0)), COLOR_INFRASTRUCTURE, true)
	
	# Exit door frame
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)


## PKG-0141 (D-150). Jedna sciezka kamery dla calej kampanii: nazwa wezla,
## granice komory i kolejnosc podpiec zyja w `StationCameraRig`, nie w 45 kopiach.
func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)
