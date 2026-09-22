class_name Station25
extends Node2D

## OBSTACLE_WORLD_PURPOSE: Rozdzielnica B zasila wentylację tunelu serwisowego Linii 4 i wymaga ręcznego przestawienia.
## OBSTACLE_BEFORE_STATE: Jakub konfrontuje Lenę w uniformie UCP („Nie jestem twoim wspomnieniem”), blokując przejście do śluzy 26.
## OBSTACLE_AFTER_STATE: Lena weryfikuje bliznę i gest dłoni; Jakub wygasza aparaturę UCP i otwiera śluzę do Station 26.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("0d1215")
const COLOR_TUNNEL_WALL := Color("141c21")
const COLOR_PLATFORM_EDGE := Color("1e2a30")
const COLOR_INFRASTRUCTURE := Color("415b67")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.22)
const COLOR_BEIGE_ASH := Color("c8a370")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CYAN_TECH := Color("5da398")
const COLOR_CORRECTION := Color("c65d58")

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal cart_inspected()
signal chart_inspected()
signal jakub_confronted()
signal sensor_inspected()
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

var is_cart_inspected: bool = false
var is_chart_inspected: bool = false
var is_jakub_confronted: bool = false
var is_sensor_inspected: bool = false
var is_exit_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _exit_open_progress: float = 0.0
var _jakub_sitting: bool = false

var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "JAKUB",
		"text": "Nie podchodź bliżej. Znam te procedury.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Co?",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Moja siostra obraca obrączkę, kiedy jest zdenerwowana. Zawsze ten sam ruch palca.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "W mojej wersji masz bliznę pod lewym żebrem. Od drutu kolczastego na działce.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Mam.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Widziałam ją, kiedy identyfikowałam ciało w szpitalu.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Jakub siada na podłodze. Nie patrzy na Lenę.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_stage_direction": true
	},
	{
		"speaker": "JAKUB",
		"text": "I co teraz? Mam ci udowodnić, że oddycham?",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Nie.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Właśnie to robisz. Patrzysz, czy się zgadzam.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Jakub—",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Nie jestem twoim wspomnieniem. Ale możemy iść dalej.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Ślad w rejestrze personelu stabilizuje się. Śluza do Przestrzeni 26 odblokowuje się z cichym pomrukiem siłowników.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
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
	beat_start.beat_id = &"s25_switchboard_b"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Rozdzielnica B zasila wentylację. Musimy ominąć wyłączniki."
	beat_start.text_en = "Switchboard B powers ventilation. We need to bypass breakers."
	guidance_service.register_beat(beat_start)


func _process(delta: float) -> void:
	_pulse_time += delta
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 2.0)
		queue_redraw()


func _on_prop_inspected(id: String, prop_type: int, pt: MemoryResonancePoint = null) -> void:
	var prop_name: String = String(pt.name) if pt else id
	match prop_name:
		"MaintenanceCart", "prop_maintenance_cart":
			inspect_cart()
		"ScarChart", "prop_scar_chart":
			inspect_chart()
		"JakubOperator", "prop_jakub_operator":
			confront_jakub()
		"GestureSensor", "prop_gesture_sensor":
			inspect_sensor()
		"Station25Exit", "prop_station_25_exit":
			if is_exit_unlocked:
				_trigger_level_completion()
	clue_inspected.emit(id, prop_type)


func inspect_cart() -> void:
	if is_cart_inspected:
		return
	is_cart_inspected = true
	var p := props.get_node_or_null("MaintenanceCart") as MemoryResonancePoint
	if p:
		p.is_activated = true
	cart_inspected.emit()
	_check_unlock()


func inspect_chart() -> void:
	if is_chart_inspected:
		return
	is_chart_inspected = true
	var p := props.get_node_or_null("ScarChart") as MemoryResonancePoint
	if p:
		p.is_activated = true
	chart_inspected.emit()
	_check_unlock()


func confront_jakub() -> void:
	if is_jakub_confronted:
		return
	is_jakub_confronted = true
	var p := props.get_node_or_null("JakubOperator") as MemoryResonancePoint
	if p:
		p.is_activated = true
	jakub_confronted.emit()
	start_dialogue()
	_check_unlock()


func inspect_sensor() -> void:
	if is_sensor_inspected:
		return
	is_sensor_inspected = true
	var p := props.get_node_or_null("GestureSensor") as MemoryResonancePoint
	if p:
		p.is_activated = true
	sensor_inspected.emit()
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
		if dialogue_index == 6:
			_jakub_sitting = true
		elif dialogue_index == 11:
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
			state.record_decision(&"s25_jakub_recognized", true)
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
	var p := props.get_node_or_null("Station25Exit") as MemoryResonancePoint
	if p:
		p.is_activated = true
	queue_redraw()


func _check_unlock() -> void:
	if is_cart_inspected and is_chart_inspected and is_jakub_confronted and is_sensor_inspected and not is_exit_unlocked:
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
	
	# Platform edge & tracks
	draw_rect(Rect2(Vector2(0.0, 270.0), Vector2(640.0, 50.0)), COLOR_TUNNEL_WALL, true)
	draw_rect(Rect2(Vector2(0.0, 270.0), Vector2(640.0, 4.0)), COLOR_PLATFORM_EDGE, true)
	draw_rect(Rect2(Vector2(100.0, 200.0), Vector2(80.0, 70.0)), COLOR_INFRASTRUCTURE, true)
	
	# Exit door frame
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
