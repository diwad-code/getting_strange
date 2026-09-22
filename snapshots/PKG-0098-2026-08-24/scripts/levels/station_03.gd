class_name Station03
extends Node2D

## Station 03 (Przestrzeń 03: Puste laboratorium) for Getting Strange Vertical Slice.
## Represents the deserted IKP corridor and return to control station after correlation anomaly.
## Night staff has disappeared, door card reader displays alternate photo with 'URLOP PRZERWANY',
## two coffee cups sit on the desk instead of one, and the desk telephone shows 14 unread messages from Marta.
## Follows VISUAL_DESIGN.md and FULL_STORY.md (Scene 03).

const VIEW_SIZE := Vector2(640.0, 360.0)

const COLOR_BACKGROUND := VectorStageStyle.BACKDROP
const COLOR_INFRASTRUCTURE := VectorStageStyle.LIGHT_PLANE
const COLOR_AMBER := VectorStageStyle.HUMAN_AMBER
const COLOR_CYAN := VectorStageStyle.ANCHOR_CYAN
const COLOR_CORRECTION := VectorStageStyle.CORRECTION_OXIDE
const COLOR_DARK_STEEL := VectorStageStyle.MID_PLANE
const COLOR_FLOOR := VectorStageStyle.DEEP_PLANE
const COLOR_FLOOR_EDGE := VectorStageStyle.LIGHT_PLANE

signal clue_inspected(id: String, prop_type: int)
signal door_unlocked()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var security_door: AnimatableBody2D = $SecurityDoor
@onready var airlock_zone: Area2D = $AirlockZone

var cups_inspected: bool = false
var phone_inspected: bool = false
var roster_inspected: bool = false
var card_reader_inspected: bool = false

var is_door_unlocked: bool = false
var is_level_completed: bool = false

var _door_open_progress: float = 0.0
var _door_tween: Tween
var _pulse_time: float = 0.0
var _flicker_phase: float = 0.0

var _ambient_hum_player: AudioStreamPlayer
var _door_audio_player: AudioStreamPlayer
var _ambient_hum_sfx: AudioStreamWAV
var _door_seal_sfx: AudioStreamWAV


func _ready() -> void:
	_setup_camera()
	_setup_audio()
	_connect_props()
	
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	
	queue_redraw()


func _setup_camera() -> void:
	if not is_instance_valid(camera):
		camera = CinematicCamera.new()
		camera.name = "Camera"
		add_child(camera)
	
	camera.target = player
	var bounds: Array[Rect2] = [Rect2(Vector2.ZERO, VIEW_SIZE)]
	camera.setup_chambers(bounds)


func _setup_audio() -> void:
	_ambient_hum_sfx = ProceduralAudio.create_fluorescent_hum_sound()
	_door_seal_sfx = ProceduralAudio.create_airlock_seal_sound()
	
	_ambient_hum_player = AudioStreamPlayer.new()
	_ambient_hum_player.name = "AmbientHumPlayer"
	_ambient_hum_player.stream = _ambient_hum_sfx
	_ambient_hum_player.volume_db = -12.0
	_ambient_hum_player.bus = &"Master"
	add_child(_ambient_hum_player)
	_ambient_hum_player.play()
	
	_door_audio_player = AudioStreamPlayer.new()
	_door_audio_player.name = "DoorAudioPlayer"
	_door_audio_player.volume_db = -4.0
	_door_audio_player.bus = &"Master"
	add_child(_door_audio_player)


func _connect_props() -> void:
	if props == null:
		return
	
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var prop := child as MemoryResonancePoint
			prop.resonance_triggered.connect(_on_prop_resonance_triggered.bind(prop))


func _process(delta: float) -> void:
	_pulse_time += delta * 2.5
	_flicker_phase += delta * 8.0
	queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	match id:
		"twin_cups":
			cups_inspected = true
		"desk_phone":
			phone_inspected = true
		"duty_roster":
			roster_inspected = true
		"door_card_reader":
			card_reader_inspected = true
			if not is_door_unlocked:
				unlock_security_door()
	
	clue_inspected.emit(id, prop_type)


func unlock_security_door() -> void:
	if is_door_unlocked:
		return
	is_door_unlocked = true
	
	door_unlocked.emit()
	if _door_audio_player and _door_seal_sfx:
		_door_audio_player.stream = _door_seal_sfx
		_door_audio_player.play()
	
	if camera:
		camera.add_trauma(0.28)
	
	_door_tween = create_tween()
	_door_tween.tween_property(self, "_door_open_progress", 1.0, 1.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	if security_door:
		var target_y := security_door.position.y - 70.0
		_door_tween.parallel().tween_property(security_door, "position:y", target_y, 1.2)


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_door_unlocked:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	# 1. Architectural structure and modernist wall panels
	_draw_architecture()
	
	# 2. Left entrance airlock frame (returning from Chamber 02 Korelacja)
	_draw_entrance_airlock()
	
	# 3. Deserted operator desk & empty workstation
	_draw_workstation_and_furniture()
	
	# 4. Deserted corridor observation window & darkened wing
	_draw_corridor_window()
	
	# 5. Fluorescent lighting fixtures with subtle ballast flicker
	_draw_lighting_fixtures()
	
	# 6. Exit security door frame & badge reader terminal
	_draw_exit_door_frame()


func _draw_architecture() -> void:
	# Floor slab (y = 296..360)
	draw_rect(Rect2(0.0, 296.0, 640.0, 64.0), COLOR_FLOOR)
	draw_rect(Rect2(0.0, 296.0, 640.0, 3.0), COLOR_FLOOR_EDGE)
	
	# Wall panel seam lines (modernist grid at 80px intervals)
	for i in range(1, 8):
		var x := float(i) * 80.0
		draw_line(Vector2(x, 36.0), Vector2(x, 296.0), Color(0.12, 0.18, 0.22, 0.45), 1.0)
	
	# Horizontal cable trunking & dado rail (y = 208.0 and y = 108.0)
	draw_rect(Rect2(0.0, 208.0, 640.0, 4.0), COLOR_DARK_STEEL)
	draw_rect(Rect2(0.0, 108.0, 640.0, 3.0), COLOR_DARK_STEEL * 0.8)
	
	# Ceiling beam and cable raceways (y = 0..36)
	draw_rect(Rect2(0.0, 0.0, 640.0, 36.0), Color("121a20"))
	draw_line(Vector2(0.0, 36.0), Vector2(640.0, 36.0), COLOR_INFRASTRUCTURE * 0.4, 2.0)


func _draw_entrance_airlock() -> void:
	# Left Entrance Airlock Frame (x = 10..70, y = 180..296) - where Lena returns from
	var frame_rect := Rect2(10.0, 180.0, 60.0, 116.0)
	draw_rect(frame_rect, Color("141c22"))
	draw_rect(frame_rect, COLOR_DARK_STEEL, false, 2.0)
	
	# Hydraulic casing above door
	draw_rect(Rect2(6.0, 168.0, 68.0, 14.0), COLOR_DARK_STEEL)
	draw_rect(Rect2(6.0, 168.0, 68.0, 14.0), COLOR_INFRASTRUCTURE * 0.6, false, 1.0)
	
	# Open status indicator lamp (Cyan - open corridor behind Lena)
	draw_circle(Vector2(40.0, 175.0), 3.0, COLOR_CYAN * 0.8)


func _draw_workstation_and_furniture() -> void:
	# ── Operator Desk (x = 135..255, y = 264..296) ──
	var desk_rect := Rect2(135.0, 264.0, 120.0, 32.0)
	draw_rect(desk_rect, COLOR_DARK_STEEL)
	draw_rect(desk_rect, COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	draw_rect(Rect2(133.0, 262.0, 124.0, 4.0), Color("344752"))
	
	# Deserted operator console display on desk (x = 138..172, y = 236..262)
	var mon_rect := Rect2(138.0, 238.0, 34.0, 24.0)
	draw_rect(mon_rect, Color("10171c"))
	draw_rect(mon_rect, COLOR_DARK_STEEL, false, 1.0)
	# Screen bezel & standby text
	draw_rect(Rect2(141.0, 241.0, 28.0, 16.0), Color("0b1318"))
	draw_line(Vector2(144.0, 246.0), Vector2(164.0, 246.0), COLOR_INFRASTRUCTURE * 0.6, 1.0)
	draw_line(Vector2(144.0, 250.0), Vector2(158.0, 250.0), COLOR_CORRECTION * 0.7, 1.0) # "STAN: NIEZAREJESTROWANY"
	
	# ── Empty Swivel Office Chair (x = 195, y = 265..296) ──
	# Illustrating that the night staff colleague vanished abruptly
	var chair_center := Vector2(195.0, 276.0)
	# Chair base & casters
	draw_line(Vector2(188.0, 295.0), Vector2(202.0, 295.0), Color("172026"), 2.0)
	draw_line(Vector2(195.0, 283.0), Vector2(195.0, 295.0), Color("26343d"), 2.5)
	# Chair seat cushion
	draw_rect(Rect2(186.0, 280.0, 18.0, 4.0), Color("2b3c46"))
	# Chair backrest
	draw_rect(Rect2(188.0, 265.0, 14.0, 15.0), Color("24333c"))
	draw_rect(Rect2(188.0, 265.0, 14.0, 15.0), COLOR_INFRASTRUCTURE * 0.4, false, 1.0)
	
	# Abandoned institutional lab coat draped over back of chair
	var coat_pts := PackedVector2Array([
		Vector2(187.0, 267.0),
		Vector2(203.0, 267.0),
		Vector2(205.0, 282.0),
		Vector2(185.0, 280.0),
	])
	draw_polygon(coat_pts, [Color("8f9c96", 0.65)])
	draw_line(Vector2(187.0, 267.0), Vector2(203.0, 267.0), Color("b4c2bc", 0.8), 1.2)


func _draw_corridor_window() -> void:
	# Large Leaded Corridor Window peering into darkened IKP wing (x = 310..460, y = 115..220)
	var win_rect := Rect2(310.0, 115.0, 150.0, 105.0)
	draw_rect(Rect2(306.0, 111.0, 158.0, 113.0), COLOR_DARK_STEEL)
	draw_rect(Rect2(306.0, 111.0, 158.0, 113.0), COLOR_INFRASTRUCTURE * 0.5, false, 2.0)
	
	# Darkened deserted wing interior
	draw_rect(win_rect, Color("0a1014"))
	
	# Faint architectural depth lines inside dark wing
	draw_line(Vector2(350.0, 115.0), Vector2(330.0, 220.0), Color(0.12, 0.20, 0.24, 0.35), 1.0)
	draw_line(Vector2(420.0, 115.0), Vector2(440.0, 220.0), Color(0.12, 0.20, 0.24, 0.35), 1.0)
	draw_line(Vector2(310.0, 195.0), Vector2(460.0, 195.0), Color(0.15, 0.25, 0.28, 0.25), 1.0)
	
	# Darkened empty desks inside wing
	draw_rect(Rect2(340.0, 185.0, 45.0, 15.0), Color("121d22"))
	draw_rect(Rect2(405.0, 185.0, 45.0, 15.0), Color("121d22"))
	
	# Single blinking standby telemetry dot inside dark wing (amber)
	var p := sin(_pulse_time * 2.0) * 0.5 + 0.5
	draw_circle(Vector2(365.0, 180.0), 1.5, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, p * 0.7))
	
	# Glass diagonal sheen
	draw_line(Vector2(315.0, 120.0), Vector2(400.0, 215.0), Color(1.0, 1.0, 1.0, 0.06), 3.0)
	draw_line(Vector2(350.0, 120.0), Vector2(435.0, 215.0), Color(1.0, 1.0, 1.0, 0.04), 2.0)


func _draw_lighting_fixtures() -> void:
	# Fluorescent ceiling fixtures (x = 100, 260, 420, 560)
	var fixture_x: Array[float] = [100.0, 260.0, 420.0, 560.0]
	for idx in range(fixture_x.size()):
		var fx: float = fixture_x[idx]
		
		# Fixture housing
		draw_rect(Rect2(fx - 22.0, 34.0, 44.0, 4.0), COLOR_INFRASTRUCTURE)
		
		# Tube light intensity (Fixture 2 at x=260 has slight subtle ballast flicker)
		var intensity := 1.0
		if idx == 1:
			var flick := sin(_flicker_phase) * cos(_flicker_phase * 0.7)
			intensity = 0.85 + (0.15 if flick > 0.3 else -0.25 if flick < -0.6 else 0.0)
		
		var tube_col := Color("d8dec5") * intensity
		draw_rect(Rect2(fx - 18.0, 36.0, 36.0, 3.0), tube_col)
		
		# Downward illumination cone
		var cone_pts := PackedVector2Array([
			Vector2(fx - 18.0, 39.0),
			Vector2(fx + 18.0, 39.0),
			Vector2(fx + 60.0, 296.0),
			Vector2(fx - 60.0, 296.0),
		])
		draw_polygon(cone_pts, [Color(0.85, 0.88, 0.80, 0.024 * intensity)])


func _draw_exit_door_frame() -> void:
	# Heavy Security Exit Door Frame (x = 550..620, y = 180..296)
	var frame_rect := Rect2(550.0, 180.0, 70.0, 116.0)
	draw_rect(frame_rect, Color("141c22"))
	draw_rect(frame_rect, COLOR_DARK_STEEL, false, 2.0)
	
	# Top hydraulic housing
	draw_rect(Rect2(546.0, 168.0, 78.0, 14.0), COLOR_DARK_STEEL)
	draw_rect(Rect2(546.0, 168.0, 78.0, 14.0), COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	
	# Exit door status lamp (Red when sealed, Cyan when unlocked by card reader)
	var lamp_col := COLOR_CYAN if is_door_unlocked else COLOR_CORRECTION
	draw_circle(Vector2(585.0, 175.0), 3.5, lamp_col)
	draw_circle(Vector2(585.0, 175.0), 6.5, Color(lamp_col.r, lamp_col.g, lamp_col.b, 0.25))
	
	# Direction arrow to Reception / Bramka (Przestrzeń 04)
	if is_door_unlocked:
		var arr_pulse := sin(_pulse_time * 2.0) * 0.5 + 0.5
		var arr_col := Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.5 + arr_pulse * 0.5)
		draw_line(Vector2(575.0, 238.0), Vector2(595.0, 238.0), arr_col, 2.0)
		draw_line(Vector2(590.0, 232.0), Vector2(595.0, 238.0), arr_col, 2.0)
		draw_line(Vector2(590.0, 244.0), Vector2(595.0, 238.0), arr_col, 2.0)
