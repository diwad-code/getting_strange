class_name Station25
extends Node2D

## Station 25 (Przestrzeń 25: Wejście Jakuba / Węzeł tranzytowy Linii 4, Jakub jako operator UCP, blizna pod żebrem i dialog D-09) for Getting Strange Vertical Slice.
## Features Line 4 Transit & Technical Maintenance Concourse in Compliance Point 6.
## Implements Dialogue D-09 and emotional boundary confrontation per FULL_STORY.md (Scene 25) & DIALOGUE_SCRIPT.md:
## Lena encounters her living brother Jakub Wolski working as a UCP technician/operator,
## who confronts her about her nervous hand habit (cutting finger on edge vs turning wedding ring),
## Lena reveals her memory of identifying his dead body and the glass scar under his left rib,
## Jakub sits on the floor, asserts his living independence ("Nie jestem twoim wspomnieniem"),
## and unlocks the service airlock towards Space 26 (Próba zamknięcia / strefa izolacji).
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 25).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("10171a")
const COLOR_WALL_TUNNEL := Color("162227")
const COLOR_WALL_DARK := Color("0e1518")
const COLOR_INFRASTRUCTURE := Color("4a6d7c")
const COLOR_DARK_STEEL := Color("1e2a30")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.22)
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")
const COLOR_RAIL_STEEL := Color("5a7684")

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal cart_inspected()
signal chart_inspected()
signal sensor_inspected()
signal jakub_confronted()
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

var is_cart_inspected: bool = false
var is_chart_inspected: bool = false
var is_sensor_inspected: bool = false
var is_jakub_confronted: bool = false
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
		"text": "Pokaż dłoń.",
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
		"text": "Moja siostra obraca obrączkę, kiedy kłamie. Ty rozcinasz sobie palec. Od drzwi wiedziałem, że coś jest nie tak.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "W mojej wersji masz bliznę pod lewym żebrem. Od szkła w wagonie.",
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
		"text": "Widziałam ją, kiedy identyfikowałam ciało.",
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
		"text": "Nie jestem twoim wspomnieniem. Jeśli chcesz wyjść, pomogę osobie. Nie żałobie.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Ślad w rejestrze personelu stabilizuje się. Śluza ku Przestrzeni 26 otwiera się z sykiem dekompresji.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_stage_direction": true
	}
]


func _ready() -> void:
	_setup_station()
	_connect_signals()
	station_entered.emit()


func _process(delta: float) -> void:
	_pulse_time += delta
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 1.5)
	queue_redraw()


func _setup_station() -> void:
	if camera:
		camera.setup_chambers([Rect2(Vector2.ZERO, VIEW_SIZE)])
		camera.set_chamber(0, false)
	if player:
		player.reset_to(Vector2(50.0, 240.0))


func _connect_signals() -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint:
				child.resonance_triggered.connect(_on_resonance_triggered)
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_entered)


func _on_resonance_triggered(id: String, type_idx: int) -> void:
	clue_inspected.emit(id, type_idx)
	match type_idx:
		MemoryResonancePoint.PropType.TRANSIT_MAINTENANCE_CART:
			is_cart_inspected = true
			cart_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.SCAR_DIAGNOSTIC_CHART:
			is_chart_inspected = true
			chart_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.JAKUB_HAND_GESTURE_SENSOR:
			is_sensor_inspected = true
			sensor_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.JAKUB_OPERATOR_UCP:
			is_jakub_confronted = true
			jakub_confronted.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.STATION_25_EXIT:
			if is_exit_unlocked:
				_on_airlock_entered(player)


func start_dialogue() -> void:
	if dialogue_active:
		return
	dialogue_active = true
	dialogue_index = 0
	dialogue_started.emit()
	dialogue_advanced.emit(0)


func advance_dialogue() -> int:
	if not dialogue_active:
		return -1
	
	dialogue_index += 1
	if dialogue_index >= dialogue_lines.size():
		dialogue_active = false
		is_dialogue_completed = true
		dialogue_completed.emit()
		_finish_scene()
		return -1
	
	if dialogue_index == 6:
		# Line 6: Jakub sits on floor
		_jakub_sitting = true
		if props:
			var jakub_prop := props.get_node_or_null("JakubOperator") as MemoryResonancePoint
			if jakub_prop:
				jakub_prop.is_activated = true
	elif dialogue_index == 11:
		# Line 11: Exit unlocks
		_unlock_exit()
	
	dialogue_advanced.emit(dialogue_index)
	return dialogue_index


func _finish_scene() -> void:
	is_cart_inspected = true
	is_chart_inspected = true
	is_sensor_inspected = true
	is_jakub_confronted = true
	_unlock_exit()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	if props:
		var exit_prop := props.get_node_or_null("Station25Exit") as MemoryResonancePoint
		if exit_prop:
			exit_prop.is_activated = true
		var cart_prop := props.get_node_or_null("MaintenanceCart") as MemoryResonancePoint
		if cart_prop:
			cart_prop.is_activated = true
		var chart_prop := props.get_node_or_null("ScarChart") as MemoryResonancePoint
		if chart_prop:
			chart_prop.is_activated = true
		var sensor_prop := props.get_node_or_null("GestureSensor") as MemoryResonancePoint
		if sensor_prop:
			sensor_prop.is_activated = true
		var jakub_prop := props.get_node_or_null("JakubOperator") as MemoryResonancePoint
		if jakub_prop:
			jakub_prop.is_activated = true


func _on_airlock_entered(body: Node2D) -> void:
	if not is_exit_unlocked:
		return
	if is_level_completed:
		return
	if body is PrototypePlayer or body == player:
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	# Vector-Stage state pass. The frame itself belongs to VectorStageEnvironment
	# (station_number = 25); this pass only moves the plane relations that carry state.
	_draw_state_layer()

	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_hud(dialogue_lines[dialogue_index])


func _draw_state_layer() -> void:
	# Catenary feed over Line 4: a single practical line above the platform edge.
	var pulse := sin(_pulse_time * 2.2) * 0.5 + 0.5
	draw_line(
		Vector2(8.0, 82.0),
		Vector2(632.0, 116.0),
		Color(VectorStageStyle.LIGHT_PLANE, 0.32 + pulse * 0.24),
		1.5
	)
	# Jakub sits down: the amber silhouette becomes a lower, wider plane. Pose, not effect.
	if _jakub_sitting:
		VectorStageStyle.draw_facet_polygon(
			self,
			PackedVector2Array([Vector2(186.0, 236.0), Vector2(246.0, 232.0), Vector2(252.0, 270.0), Vector2(180.0, 272.0)]),
			VectorStageStyle.HUMAN_AMBER,
			1.0
		)
	# The scar under the rib stays a small oxide facet on the chart, never a wound effect.
	if is_chart_inspected:
		VectorStageStyle.draw_facet_polygon(
			self,
			PackedVector2Array([Vector2(342.0, 196.0), Vector2(392.0, 192.0), Vector2(396.0, 232.0), Vector2(346.0, 236.0)]),
			VectorStageStyle.CORRECTION_OXIDE,
			1.0
		)
	# The living brother keeps his own parameter: the service signal holds its cyan edge.
	if is_jakub_confronted:
		VectorStageStyle.draw_facet_polygon(
			self,
			PackedVector2Array([Vector2(496.0, 78.0), Vector2(532.0, 80.0), Vector2(533.0, 108.0), Vector2(497.0, 106.0)]),
			VectorStageStyle.light(VectorStageStyle.ANCHOR_CYAN, 0.20),
			1.0
		)
	if _exit_open_progress > 0.0:
		var opening := 4.0 + _exit_open_progress * 22.0
		VectorStageStyle.draw_facet_polygon(
			self,
			PackedVector2Array([
				Vector2(596.0 - opening, 168.0),
				Vector2(596.0 + opening, 168.0),
				Vector2(596.0 + opening, 262.0),
				Vector2(596.0 - opening, 262.0),
			]),
			VectorStageStyle.LIGHT_PLANE,
			1.0
		)


func _draw_dialogue_hud(line: Dictionary) -> void:
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_witness: bool = line.get("is_witness", false)
	var is_lena: bool = line.get("is_lena", false)
	var is_jakub: bool = line.get("is_jakub", false)
	
	var box_rect := Rect2(60.0, 285.0, 520.0, 60.0)
	draw_rect(box_rect, Color(0.06, 0.09, 0.11, 0.94))
	
	var border_color := COLOR_AMBER if is_jakub else (COLOR_AMBER_WARM if is_lena else (COLOR_CORRECTION if is_witness else COLOR_INFRASTRUCTURE))
	draw_rect(box_rect, border_color * 0.75, false, 1.0)
	
	# Speaker header bar
	var bar_color := COLOR_AMBER if is_jakub else (COLOR_AMBER_WARM if is_lena else (COLOR_CORRECTION if is_witness else COLOR_INFRASTRUCTURE))
	draw_rect(Rect2(64.0, 288.0, 140.0, 3.0), bar_color)
	
	var font := ThemeDB.fallback_font
	if font:
		draw_string(font, Vector2(70.0, 304.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, bar_color)
		draw_string(font, Vector2(70.0, 324.0), text, HORIZONTAL_ALIGNMENT_LEFT, 500, 10, Color("dcebe4"))
