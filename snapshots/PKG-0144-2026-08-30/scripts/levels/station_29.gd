class_name Station29
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Szyb wentylacyjny i porzucone torowisko Sektora 4 zamykają przestrzeń tranzytową przed rozdzielnią główną.
## PRZESZKODA — czego wymaga od Leny: Skoordynowanego zbadania neonu stacyjnego, torów i latarki Jakuba w celu odryglowania bramy rewizyjnej.
## PRZESZKODA — koszt porażki: Zablokowanie bramy z łańcuchem, narastanie szumu kompensatorów naprężeń i restart procedury otwarcia.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("0b1013")
const COLOR_GENERATOR_BASE := Color("141e24")
const COLOR_GENERATOR_CORE := Color("1e2a32")
const COLOR_INFRASTRUCTURE := Color("405e6c")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.22)
const COLOR_BEIGE_ASH := Color("c8a370")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CYAN_TECH := Color("5da398")
const COLOR_CORRECTION := Color("c65d58")

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal tracks_inspected()
signal neon_inspected()
signal well_inspected()
signal beacon_inspected()
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

var is_tracks_inspected: bool = false
var is_neon_inspected: bool = false
var is_well_inspected: bool = false
var is_beacon_inspected: bool = false
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
		"text": "Stacja transformatorowa węzła Sektora 4 buczy niskim, wibrującym basem. Wskaźniki napięcia pulsują w takt pamięci.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "JAKUB",
		"text": "Koniec torowiska Linii 4. Za tą bramą zaczyna się stacja transformatorowa i kompensatory Podstruktury.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Ten peron wygląda jak wymazany w połowie budowy.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Bo tak było. Zatrzymali prace, kiedy zdali sobie sprawę, że szyny prowadzą wprost do archiwum świadków.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Zardzewiałe szyny kończą się nagle przy zaporze oporowej. Plama starego oleju lśni metalicznie.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Słyszysz ten dźwięk? Jakby całe miasto oddychało pod ziemią.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "To nie pompy. To kompensatory naprężeń pamięciowych w szybie wentylacyjnym.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Neon nad peronem migocze nieregularnie, rzucając ostre, bursztynowe cienie na wilgotny beton.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "JAKUB",
		"text": "Za tą kratą zaczyna się Sektor Zasilania. Chodźmy, zanim dr Wierzbicka odetnie zasilanie.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Nie wracamy, Jakub. Otwieram bramę.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Rdzawa krata ustępuje z głuchym jękiem metalu. Droga do Przestrzeni 30 staje otworem.",
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
	beat_start.beat_id = &"s29_power_grid"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Stacja zasilania. Trzy fazy obciążenia pamięciowego."
	beat_start.text_en = "Power substation. Three phases of memory grid load."
	guidance_service.register_beat(beat_start)


func _process(delta: float) -> void:
	_pulse_time += delta
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 2.0)
		queue_redraw()


func _on_prop_inspected(id: String, prop_type: int, pt: MemoryResonancePoint = null) -> void:
	var prop_name: String = String(pt.name) if pt else id
	match prop_name:
		"AbandonedTracks", "prop_abandoned_tracks":
			inspect_tracks()
		"FlickeringNeon", "prop_flickering_neon":
			inspect_neon()
		"SubstructureWell", "prop_substructure_well":
			inspect_well()
		"JakubBeacon", "prop_jakub_beacon":
			inspect_beacon()
		"Station29Exit", "prop_station_29_exit":
			if is_exit_unlocked:
				_trigger_level_completion()
	clue_inspected.emit(id, prop_type)


func inspect_tracks() -> void:
	if is_tracks_inspected:
		return
	is_tracks_inspected = true
	var p := props.get_node_or_null("AbandonedTracks") as MemoryResonancePoint
	if p:
		p.is_activated = true
	tracks_inspected.emit()
	_check_unlock()


func inspect_neon() -> void:
	if is_neon_inspected:
		return
	is_neon_inspected = true
	var p := props.get_node_or_null("FlickeringNeon") as MemoryResonancePoint
	if p:
		p.is_activated = true
	neon_inspected.emit()
	start_dialogue()
	_check_unlock()


func inspect_well() -> void:
	if is_well_inspected:
		return
	is_well_inspected = true
	var p := props.get_node_or_null("SubstructureWell") as MemoryResonancePoint
	if p:
		p.is_activated = true
	well_inspected.emit()
	_check_unlock()


func inspect_beacon() -> void:
	if is_beacon_inspected:
		return
	is_beacon_inspected = true
	var p := props.get_node_or_null("JakubBeacon") as MemoryResonancePoint
	if p:
		p.is_activated = true
	beacon_inspected.emit()
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
			inspect_neon()
		elif dialogue_index == 4:
			inspect_tracks()
		elif dialogue_index == 6:
			inspect_well()
		elif dialogue_index == 8:
			inspect_beacon()
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
			state.record_decision(&"s29_power_balanced", true)
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
	var p := props.get_node_or_null("Station29Exit") as MemoryResonancePoint
	if p:
		p.is_activated = true
	queue_redraw()


func _check_unlock() -> void:
	if is_tracks_inspected and is_neon_inspected and is_well_inspected and is_beacon_inspected and not is_exit_unlocked:
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
	
	# Platform geometry and substructure well
	draw_rect(Rect2(Vector2(50.0, 160.0), Vector2(160.0, 120.0)), COLOR_GENERATOR_BASE, true)
	draw_rect(Rect2(Vector2(70.0, 180.0), Vector2(120.0, 80.0)), COLOR_GENERATOR_CORE, true)
	draw_rect(Rect2(Vector2(240.0, 160.0), Vector2(240.0, 120.0)), COLOR_INFRASTRUCTURE, true)
	
	# Exit door frame
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)


## PKG-0141 (D-150). Jedna sciezka kamery dla calej kampanii: nazwa wezla,
## granice komory i kolejnosc podpiec zyja w `StationCameraRig`, nie w 45 kopiach.
func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)
