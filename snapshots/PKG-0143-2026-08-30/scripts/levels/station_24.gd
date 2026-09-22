class_name Station24
extends Node2D

## OBSTACLE_WORLD_PURPOSE: Monitoring CCTV w mieszkaniu 14 rejestruje narastające naprężenie korelacyjne wokół Marty.
## OBSTACLE_BEFORE_STATE: Brak ustalonej dyspozycji wobec procedur UCP blokuje śluzę wyjściową do magistrali Linii 4.
## OBSTACLE_AFTER_STATE: Gracz deklaruje dyspozycję; Marta zachowuje granice, a śluza do Station 25 zostaje odblokowana.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("0e1317")
const COLOR_MONITOR_CASING := Color("172228")
const COLOR_CCTV_SCREEN := Color("1c2b33")
const COLOR_INFRASTRUCTURE := Color("4b6b7a")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.22)
const COLOR_BEIGE_ASH := Color("c8a370")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CYAN_TECH := Color("5da398")
const COLOR_CORRECTION := Color("c65d58")

enum DispositionChoice {
	EXPLICIT_CONSENT = 0,
	APPARENT_COOPERATION = 1,
	EXPLICIT_REFUSAL = 2
}

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal cctv_inspected()
signal gauge_inspected()
signal terminal_inspected()
signal disposition_selected(choice: DispositionChoice)
signal exit_unlocked()
signal dialogue_started()
signal dialogue_advanced(line_idx: int)
signal dialogue_completed()
signal level_completed()
signal previous_level_requested()
signal marta_stress_escalated()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")
@onready var guidance_service: NarrativeGuidanceService = get_node_or_null("NarrativeGuidanceService")

var is_cctv_inspected: bool = false
var is_gauge_inspected: bool = false
var is_terminal_inspected: bool = false
var is_disposition_made: bool = false
var is_stress_escalated: bool = false
var is_exit_unlocked: bool = false
var is_level_completed: bool = false
var selected_disposition: DispositionChoice = DispositionChoice.EXPLICIT_CONSENT

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _exit_open_progress: float = 0.0
var _marta_stress_ratio: float = 0.0

var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Marta pakuje kartonowe pudło w mieszkaniu 14. Na ekranie CCTV widać drżenie rąk i odwrócony wzrok.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "DR WIERZBICKA",
		"text": "Marta Kurek nie przyjmuje wersji zdarzeń ustalonej w rejestrze. Jej stan zagraża stabilności węzła.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Nie zrobicie jej tego.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "DR WIERZBICKA",
		"text": "My nie robimy niczego z zemsty. Oferujemy ochronę przed rozpadem tożsamości.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Wskaźnik naprężeń korelacyjnych bije w czerwone pole. Drżenie mebli w mieszkaniu 14 nasila się.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "DR WIERZBICKA",
		"text": "Oferuję ochronę Marty. Wymagam jednak państwa jednoznacznej dyspozycji.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Zgadzam się. Chrońcie Martę.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "DR WIERZBICKA",
		"text": "Wybór został odnotowany w magistrali. Śluza techniczna Linii 4 jest dostępna.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Syrena naprężeń cichnie. Śluza ku Przestrzeni 25 otwiera się powoli z metalicznym sykiem.",
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
	beat_start.beat_id = &"s24_marta_boundaries"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Marta stawia granice. Ma do tego prawo."
	beat_start.text_en = "Marta sets boundaries. She has every right to."
	guidance_service.register_beat(beat_start)


func _process(delta: float) -> void:
	_pulse_time += delta
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 2.0)
		queue_redraw()


func _on_prop_inspected(id: String, prop_type: int, pt: MemoryResonancePoint = null) -> void:
	var prop_name: String = String(pt.name) if pt else id
	match prop_name:
		"CCTVArray", "prop_cctv_array":
			inspect_cctv()
		"CorrectionGauge", "prop_correction_gauge":
			inspect_gauge()
		"TransmissionTerminal", "prop_transmission_terminal":
			inspect_terminal()
		"DispositionSelector", "prop_disposition_selector":
			set_disposition(DispositionChoice.APPARENT_COOPERATION)
			start_dialogue()
		"Station24Exit", "prop_station_24_exit":
			if is_exit_unlocked:
				_trigger_level_completion()
	clue_inspected.emit(id, prop_type)


func inspect_cctv() -> void:
	if is_cctv_inspected:
		return
	is_cctv_inspected = true
	var p := props.get_node_or_null("CCTVArray") as MemoryResonancePoint
	if p:
		p.is_activated = true
	cctv_inspected.emit()
	_check_unlock()


func inspect_gauge() -> void:
	if is_gauge_inspected:
		return
	is_gauge_inspected = true
	var p := props.get_node_or_null("CorrectionGauge") as MemoryResonancePoint
	if p:
		p.is_activated = true
	gauge_inspected.emit()
	_check_unlock()


func inspect_terminal() -> void:
	if is_terminal_inspected:
		return
	is_terminal_inspected = true
	var p := props.get_node_or_null("TransmissionTerminal") as MemoryResonancePoint
	if p:
		p.is_activated = true
	terminal_inspected.emit()
	_check_unlock()


func set_disposition(choice: DispositionChoice) -> void:
	selected_disposition = choice
	is_disposition_made = true
	match choice:
		DispositionChoice.EXPLICIT_CONSENT:
			dialogue_lines[6]["text"] = "Zgadzam się. Chrońcie Martę."
		DispositionChoice.EXPLICIT_REFUSAL:
			dialogue_lines[6]["text"] = "Nie kupię jej bezpieczeństwa waszym kłamstwem."
		DispositionChoice.APPARENT_COOPERATION:
			dialogue_lines[6]["text"] = "Podpiszę formularz. Ale sprawdzę każdy odczyt."
	disposition_selected.emit(choice)
	start_dialogue()
	_check_unlock()


func trigger_stress_escalation() -> void:
	is_stress_escalated = true
	marta_stress_escalated.emit()


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
			is_stress_escalated = true
		elif dialogue_index == 6:
			is_disposition_made = true
		elif dialogue_index == 7:
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
			state.record_decision(&"s24_disposition", int(selected_disposition))
		dialogue_completed.emit()
		return -1


func _show_dialogue_line(idx: int) -> void:
	if idx < 0 or idx >= dialogue_lines.size():
		return
	var line: Dictionary = dialogue_lines[idx]
	if dialogue_box and dialogue_box.has_method("show_line"):
		dialogue_box.show_line(line.get("speaker", "LENA"), line.get("text", ""))


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	var p := props.get_node_or_null("Station24Exit") as MemoryResonancePoint
	if p:
		p.is_activated = true
	queue_redraw()


func _check_unlock() -> void:
	if is_cctv_inspected and is_gauge_inspected and is_terminal_inspected and is_disposition_made and not is_exit_unlocked:
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
	
	# Monitor rack & console frames
	draw_rect(Rect2(Vector2(60.0, 160.0), Vector2(160.0, 120.0)), COLOR_MONITOR_CASING, true)
	draw_rect(Rect2(Vector2(70.0, 170.0), Vector2(140.0, 100.0)), COLOR_CCTV_SCREEN, true)
	draw_rect(Rect2(Vector2(240.0, 180.0), Vector2(240.0, 100.0)), COLOR_INFRASTRUCTURE, true)
	
	# Exit door frame
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)


## PKG-0141 (D-150). Jedna sciezka kamery dla calej kampanii: nazwa wezla,
## granice komory i kolejnosc podpiec zyja w `StationCameraRig`, nie w 45 kopiach.
func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)
