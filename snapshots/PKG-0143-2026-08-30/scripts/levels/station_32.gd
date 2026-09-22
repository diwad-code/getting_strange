class_name Station32
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Stanowisko analityczne bada właściwości rezonansowe szkła i zjawisko pamięci materiałowej.
## PRZESZKODA — czego wymaga od Leny: Zbadania wariantów szkła, wyrycia śladu kondensacji, zabezpieczenia kotwicy i otwarcia włazu.
## PRZESZKODA — koszt porażki: Próba przejścia przez niestabilną taflę bez kotwicy cofa Lenę do punktu kontrolnego i wyczerpuje wyrazistość śladu.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0
const CHECKPOINT_POSITION := Vector2(65.0, 248.0)

const COLOR_BACKGROUND := Color("080c10")
const COLOR_PANEL_BASE := Color("141c22")
const COLOR_PANEL_CORE := Color("1c2630")
const COLOR_INFRASTRUCTURE := Color("3d5866")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")

signal level_completed
signal previous_level_requested
signal interaction_triggered(id: String)
signal clue_inspected(id: String, prop_type: int)
signal station_entered
signal steamed_pane_inspected
signal cracked_pane_inspected
signal trace_etched
signal polished_pane_inspected
signal exit_unlocked
signal dialogue_started
signal dialogue_advanced(line_idx: int)
signal dialogue_completed

const LEVEL_ID := "station_32"
const LEVEL_NAME := "Przestrzeń 32: Szkło laboratoryjne"
const SCENE_SUBTITLE := "Pamięć materiału / Ślad kondensacji i odpowiedź"

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

var is_steamed_pane_inspected: bool = false
var is_cracked_pane_inspected: bool = false
var is_trace_etched: bool = false
var is_polished_pane_inspected: bool = false

var glass_observation_correction_count: int = 0
var glass_detail_faded: bool = false
var is_glass_anchored: bool = false
var observation_boundary_crossed: bool = false

var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = get_node_or_null("Geometry")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")
@onready var guidance_service: NarrativeGuidanceService = get_node_or_null("NarrativeGuidanceService")
@onready var observed_glass: AnchorableObject = get_node_or_null("Geometry/ObservedGlassTrace")

const DIALOGUE_LINES: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "W laboratorium badawczym stoją trzy tafle szkła laboratoryjnego. Zaparowana powierzchnia reaguje na obecność Leny drobnymi drganiami.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "Szkło pamięta strukturę fali uderzeniowej. Każda rysa w szkle to zapis tamtego poranka.",
		"is_lena": true
	},
	{
		"speaker": "JAKUB",
		"text": "Materia nie zapomina tak szybko jak ludzie. Dr Wierzbicka potrzebowała filtrów sedacyjnych, bo zwykłe szkło zdradzało prawdę.",
		"is_jakub": true
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Lena zbliża dłoń do zaparowanej tafli. Przeciągnięcie palcem po szkle wywołuje rezonans — na tafli pojawia się ślad dłoni.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "Gdy dotykam zaparowanej powierzchni i przeciągam palcem, słyszę dźwięk tamtego poranka. Ślad pamięta to, co wymazano z dokumentów.",
		"is_lena": true
	},
	{
		"speaker": "JAKUB",
		"text": "Druga tafla ma ślad po uderzeniu, a trzecia została sztucznie wygładzona przez procedury UCP.",
		"is_jakub": true
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Wygładzona tafla szkła nie zawiera żadnych rys. Raporty w szkle milczą, ale krawędź rezonuje z podziemnym szybem.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "Wygładzenie nie zniszczyło prawdy — tylko ją przykryło. Właz do szybu wentylacyjnego jest pod trzecią taflą.",
		"is_lena": true
	},
	{
		"speaker": "JAKUB",
		"text": "Właz prowadzi pionowo w dół, do magistrali kablowej i maszynowni. Otwórzmy go.",
		"is_jakub": true
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Mechanizm rygla włazu technicznego zwalnia blokadę. Ciężka klapa ze szkła zbrojonego unosi się.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "Schodzimy do szybu. Pora sprawdzić, co miejscowa Lena zostawiła w skrzynce kablowej.",
		"is_lena": true
	}
]

var dialogue_lines: Array[Dictionary] = DIALOGUE_LINES


func _ready() -> void:
	if player:
		player.position = Vector2(50.0, 240.0)
	_setup_camera()
	if airlock_zone and not airlock_zone.body_entered.is_connected(_on_airlock_zone_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_zone_body_entered)
	_setup_props()
	_setup_guidance()
	_setup_glass()
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
	beat_start.beat_id = &"s32_material_memory"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Pamięć materiału. Szkło laboratoryjne reaguje na moje dłonie."
	beat_start.text_en = "Material memory. The lab glass responds to my hands."
	guidance_service.register_beat(beat_start)


func _setup_glass() -> void:
	if observed_glass == null:
		return
	if not observed_glass.anchor_state_changed.is_connected(_on_glass_anchor_state_changed):
		observed_glass.anchor_state_changed.connect(_on_glass_anchor_state_changed)
	observed_glass.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)
	var state := get_node_or_null("/root/GameStateManager")
	if state and state.has_method("has_recorded_decision"):
		glass_detail_faded = state.has_recorded_decision(&"station_32_observed_glass_corrected")
	elif state:
		var decisions: Variant = state.get("decisions")
		if decisions is Dictionary:
			glass_detail_faded = (decisions as Dictionary).has(&"station_32_observed_glass_corrected")


func _on_glass_anchor_state_changed(anchored: bool) -> void:
	is_glass_anchored = anchored
	queue_redraw()


func run_glass_observation_check() -> void:
	if observed_glass == null:
		return
	observed_glass.apply_reality_shift(AnchorableObject.RealityState.STATE_B, false)
	if observed_glass.current_reality == AnchorableObject.RealityState.STATE_B:
		_apply_glass_correction()


func _apply_glass_correction() -> void:
	glass_observation_correction_count += 1
	glass_detail_faded = true
	var state := get_node_or_null("/root/GameStateManager")
	if state and state.has_method("record_decision"):
		state.record_decision(&"station_32_observed_glass_corrected", glass_observation_correction_count)
	observed_glass.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)
	if player:
		if player.has_method("reset_to"):
			player.reset_to(CHECKPOINT_POSITION)
		else:
			player.global_position = CHECKPOINT_POSITION
	observation_boundary_crossed = false
	queue_redraw()


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
			state.record_decision(&"s32_glass_memory_witnessed", true)
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
			inspect_steamed_pane()
		2:
			inspect_cracked_pane()
		4:
			etch_trace()
		7:
			inspect_polished_pane()
		10:
			_unlock_exit()


func inspect_steamed_pane() -> void:
	if is_steamed_pane_inspected:
		return
	is_steamed_pane_inspected = true
	_activate_prop_by_id("prop_steamed_glass_pane_a")
	steamed_pane_inspected.emit()
	interaction_triggered.emit("prop_steamed_glass_pane_a")
	_check_unlock()


func inspect_cracked_pane() -> void:
	if is_cracked_pane_inspected:
		return
	is_cracked_pane_inspected = true
	_activate_prop_by_id("prop_cracked_glass_pane_b")
	cracked_pane_inspected.emit()
	interaction_triggered.emit("prop_cracked_glass_pane_b")
	_check_unlock()


func etch_trace() -> void:
	if is_trace_etched:
		return
	is_trace_etched = true
	_activate_prop_by_id("prop_trace_etcher")
	trace_etched.emit()
	interaction_triggered.emit("prop_trace_etcher")
	_check_unlock()


func inspect_polished_pane() -> void:
	if is_polished_pane_inspected:
		return
	is_polished_pane_inspected = true
	_activate_prop_by_id("prop_polished_glass_pane_c")
	polished_pane_inspected.emit()
	interaction_triggered.emit("prop_polished_glass_pane_c")
	_check_unlock()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_activate_prop_by_id("prop_station_32_exit")
	queue_redraw()


func _check_unlock() -> void:
	if is_steamed_pane_inspected and is_cracked_pane_inspected and is_trace_etched and is_polished_pane_inspected and not is_exit_unlocked:
		_unlock_exit()


func _activate_prop_by_id(id: String) -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint and child.resonance_id == id:
				child.is_activated = true
				child.queue_redraw()


func _on_resonance_triggered(id: String, prop_type: int) -> void:
	match id:
		"prop_steamed_glass_pane_a":
			inspect_steamed_pane()
		"prop_cracked_glass_pane_b":
			inspect_cracked_pane()
		"prop_trace_etcher":
			etch_trace()
		"prop_polished_glass_pane_c":
			inspect_polished_pane()
		"prop_station_32_exit":
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

	# Steamed pane stand
	draw_rect(Rect2(Vector2(110.0, 160.0), Vector2(30.0, 100.0)), COLOR_PANEL_BASE, true)
	var stm_col := COLOR_CYAN.lerp(COLOR_BACKGROUND, 0.4) if is_steamed_pane_inspected else COLOR_INFRASTRUCTURE
	draw_line(Vector2(125.0, 160.0), Vector2(125.0, 260.0), stm_col, 2.0)

	# Cracked pane stand
	draw_rect(Rect2(Vector2(220.0, 160.0), Vector2(30.0, 100.0)), COLOR_PANEL_BASE, true)
	var crk_col := COLOR_AMBER if is_cracked_pane_inspected else COLOR_INFRASTRUCTURE
	draw_line(Vector2(235.0, 160.0), Vector2(235.0, 260.0), crk_col, 2.0)

	# Condensation trace plate
	var trace_col := COLOR_CORRECTION if glass_detail_faded else COLOR_CYAN
	draw_rect(Rect2(Vector2(330.0, 150.0), Vector2(30.0, 110.0)), COLOR_PANEL_CORE, true)
	if is_trace_etched:
		draw_line(Vector2(345.0, 170.0), Vector2(345.0, 240.0), trace_col, 2.5)

	# Polished pane stand
	draw_rect(Rect2(Vector2(440.0, 160.0), Vector2(30.0, 100.0)), COLOR_PANEL_BASE, true)
	if is_polished_pane_inspected:
		draw_line(Vector2(455.0, 160.0), Vector2(455.0, 260.0), COLOR_CYAN, 1.5)

	# Exit hatch frame
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)


## PKG-0141 (D-150). Jedna sciezka kamery dla calej kampanii: nazwa wezla,
## granice komory i kolejnosc podpiec zyja w `StationCameraRig`, nie w 45 kopiach.
func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)
