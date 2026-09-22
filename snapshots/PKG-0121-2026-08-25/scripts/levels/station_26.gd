class_name Station26
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Stanowisko analizatora bufora izolacji dekomponuje przestrzeń w celu wygaszenia niezgodnych wektorów pamięciowych.
## PRZESZKODA — czego wymaga od Leny: Utrzymania stałego punktu odniesienia i zakotwiczenia pierwotnego celu na panelu przed zmianą geometrii.
## PRZESZKODA — koszt porażki: Cofnięcie adaptacji do stanu spoczynku, narastanie sedacji i utrata ostrości detalu w rejestrze bufora.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("0b1013")
const COLOR_WALL_PANEL := Color("151e24")
const COLOR_WALL_ACCENT := Color("202c34")
const COLOR_INFRASTRUCTURE := Color("405e6c")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.22)
const COLOR_BEIGE_ASH := Color("c8a370")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CYAN_TECH := Color("5da398")
const COLOR_CORRECTION := Color("c65d58")

enum RoomState {
	RESIDENTIAL = 0,
	ARCHIVE = 1,
	SEDATION = 2
}

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal console_inspected()
signal designator_inspected()
signal speaker_inspected()
signal motivation_anchored()
signal exit_unlocked()
signal dialogue_started()
signal dialogue_advanced(line_idx: int)
signal dialogue_completed()
signal level_completed()
signal room_state_changed(new_state: RoomState)

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")
@onready var guidance_service: NarrativeGuidanceService = get_node_or_null("NarrativeGuidanceService")

var is_console_inspected: bool = false
var is_designator_inspected: bool = false
var is_speaker_inspected: bool = false
var is_motivation_anchored: bool = false
var is_exit_unlocked: bool = false
var is_level_completed: bool = false
var current_room_state: RoomState = RoomState.RESIDENTIAL

var partition_cycle_time: float = 0.0
var is_partition_open: bool = false
var partition_correction_count: int = 0
var partition_detail_faded: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _exit_open_progress: float = 0.0

var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "KONTAKT WZAJEMNY — 20:40:03. System rejestruje zbliżenie dwóch wektorów tożsamościowych i uruchamia procedurę adaptacyjną.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "DR WIERZBICKA",
		"text": "Uwaga. W tej części budynku obowiązuje jedna kolejność poruszania się. Rekonfiguracja przestrzeni ma na celu wygaszenie napięcia.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Zmieniacie układ za moimi plecami.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "DR WIERZBICKA",
		"text": "Nie zmieniamy. Pozwalamy przestrzeni przyjąć funkcję właściwą dla państwa stanu emocjonalnego.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Wskaźnik funkcyjny komory płynnie przełącza się na tryb wygaszania. Ściany zbliżają się do osi korytarza.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "DR WIERZBICKA",
		"text": "W przypadku rozbieżności prosimy nie forsować przejść. Każda próba ucieczki zwiększa dawkę sedacji.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Próbujecie odebrać mi powód, dla którego tu zeszłam.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "DR WIERZBICKA",
		"text": "Powód, który rani wszystkich wokół, nie jest wart zachowania. Proszę usiąść.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Lena wyciąga stalowy rysik i z naciskiem ryje na panelu: »Pamiętam, dlaczego przyszłam«.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Nie zgubię tego.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "DR WIERZBICKA",
		"text": "Każda rysa w szwie pociąga za sobą resztę. Odblokowuję śluzę. Zobaczycie sami koszt waszego uporu.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Rekonfiguracja przestrzenna zatrzymuje się z metalicznym zgrzytem. Śluza do Przestrzeni 27 staje otworem.",
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
	beat_start.beat_id = &"s26_log_204003"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Log 20:40:03 pokazuje wzajemny kontakt przed interwencją."
	beat_start.text_en = "Log 20:40:03 shows mutual contact before intervention."
	guidance_service.register_beat(beat_start)


func _process(delta: float) -> void:
	_pulse_time += delta
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 2.0)
		queue_redraw()


func _update_partition_cycle() -> void:
	var partition := geometry.get_node_or_null("AdaptiveIsolationPartition") as AnimatableBody2D
	if current_room_state == RoomState.SEDATION and partition_cycle_time >= 1.5:
		is_partition_open = true
		if partition:
			partition.position = Vector2(380.0, 170.0)
	else:
		is_partition_open = false
		if partition:
			partition.position = Vector2(360.0, 170.0)


func _apply_isolation_correction() -> void:
	partition_correction_count += 1
	partition_detail_faded = true
	current_room_state = RoomState.RESIDENTIAL
	if player:
		player.global_position = Vector2(50.0, 240.0)
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_26_isolation_partition_corrected", partition_correction_count)


func _on_prop_inspected(id: String, prop_type: int, pt: MemoryResonancePoint = null) -> void:
	var prop_name: String = String(pt.name) if pt else id
	match prop_name:
		"IsolationConsole", "prop_isolation_console":
			inspect_console()
		"RoomDesignator", "prop_room_designator":
			inspect_designator()
		"PASpeaker", "prop_pa_speaker":
			inspect_speaker()
		"MotivationAnchor", "prop_motivation_anchor":
			anchor_motivation()
		"Station26Exit", "prop_station_26_exit":
			if is_exit_unlocked:
				_trigger_level_completion()
	clue_inspected.emit(id, prop_type)


func inspect_console() -> void:
	if is_console_inspected:
		return
	is_console_inspected = true
	var p := props.get_node_or_null("IsolationConsole") as MemoryResonancePoint
	if p:
		p.is_activated = true
	console_inspected.emit()
	_check_unlock()


func inspect_designator() -> void:
	if is_designator_inspected:
		return
	is_designator_inspected = true
	var p := props.get_node_or_null("RoomDesignator") as MemoryResonancePoint
	if p:
		p.is_activated = true
	designator_inspected.emit()
	_check_unlock()


func inspect_speaker() -> void:
	if is_speaker_inspected:
		return
	is_speaker_inspected = true
	var p := props.get_node_or_null("PASpeaker") as MemoryResonancePoint
	if p:
		p.is_activated = true
	speaker_inspected.emit()
	_check_unlock()


func anchor_motivation() -> void:
	if is_motivation_anchored:
		return
	is_motivation_anchored = true
	var p := props.get_node_or_null("MotivationAnchor") as MemoryResonancePoint
	if p:
		p.is_activated = true
	motivation_anchored.emit()
	start_dialogue()
	_check_unlock()


func set_room_state(new_state: RoomState) -> void:
	current_room_state = new_state
	room_state_changed.emit(new_state)


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
			current_room_state = RoomState.SEDATION
		elif dialogue_index == 8:
			is_motivation_anchored = true
		elif dialogue_index == 10:
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
			state.record_decision(&"s26_motivation_anchored", true)
		dialogue_completed.emit()
		return -1


func _show_dialogue_line(idx: int) -> void:
	if idx < 0 or idx >= dialogue_lines.size():
		return
	var line: Dictionary = dialogue_lines[idx]
	if dialogue_box and dialogue_box.has_method("show_line"):
		dialogue_box.show_line(line.get("speaker", "WIERZBICKA"), line.get("text", ""))


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	var p := props.get_node_or_null("Station26Exit") as MemoryResonancePoint
	if p:
		p.is_activated = true
	queue_redraw()


func _check_unlock() -> void:
	if is_console_inspected and is_designator_inspected and is_speaker_inspected and is_motivation_anchored and not is_exit_unlocked:
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
	
	# Wall panel structures
	draw_rect(Rect2(Vector2(60.0, 160.0), Vector2(160.0, 120.0)), COLOR_WALL_PANEL, true)
	draw_rect(Rect2(Vector2(260.0, 160.0), Vector2(160.0, 120.0)), COLOR_WALL_ACCENT, true)
	draw_rect(Rect2(Vector2(440.0, 180.0), Vector2(120.0, 100.0)), COLOR_INFRASTRUCTURE, true)
	
	# Exit door frame
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
