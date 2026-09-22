class_name Station04
extends Node2D

## Station 04 (Przestrzeń 04: Bramka / Recepcja IKP) for Getting Strange Vertical Slice.
## Represents the IKP reception, guard booth, overhead security camera with directional lamp,
## metal turnstile gate, and transition towards Space 05 (Rówień nocą).
## Implements Dialogue D-01: Guard reports return to UCP and mentions calling brother Jakub.
## When Lena states "Jakub nie żyje", the camera lamp abruptly dies and the guard shields the lens.
## Follows VISUAL_DESIGN.md and FULL_STORY.md (Scene 04).

const VIEW_SIZE := Vector2(640.0, 360.0)

const COLOR_BACKGROUND := VectorStageStyle.BACKDROP
const COLOR_INFRASTRUCTURE := VectorStageStyle.LIGHT_PLANE
const COLOR_AMBER := VectorStageStyle.HUMAN_AMBER
const COLOR_CYAN := VectorStageStyle.ANCHOR_CYAN
const COLOR_CORRECTION := VectorStageStyle.CORRECTION_OXIDE
const COLOR_DARK_STEEL := VectorStageStyle.MID_PLANE
const COLOR_FLOOR := VectorStageStyle.DEEP_PLANE
const COLOR_FLOOR_EDGE := VectorStageStyle.LIGHT_PLANE

const DIALOGUE_LINES: Array[Dictionary] = [
	{
		"speaker": "STRAŻNIK",
		"is_lena": false,
		"text": "Pani Wolska. Dobrze. Proszę chwilę nie wychodzić."
	},
	{
		"speaker": "LENA",
		"is_lena": true,
		"text": "Dlaczego?"
	},
	{
		"speaker": "STRAŻNIK",
		"is_lena": false,
		"text": "Mam zgłosić powrót."
	},
	{
		"speaker": "LENA",
		"is_lena": true,
		"text": "Komu?"
	},
	{
		"speaker": "STRAŻNIK",
		"is_lena": false,
		"text": "UCP. I pani bratu, jeśli nie odbiorą. Nie będę go drugi raz wzywał do zamkniętego tunelu."
	},
	{
		"speaker": "LENA",
		"is_lena": true,
		"text": "Jakub nie żyje."
	},
	{
		"speaker": "STRAŻNIK",
		"is_lena": false,
		"text": "Proszę tego przy niej nie powtarzać."
	},
	{
		"speaker": "LENA",
		"is_lena": true,
		"text": "Przy kamerze?"
	},
	{
		"speaker": "STRAŻNIK",
		"is_lena": false,
		"text": "Przy wersji, która zapisuje."
	}
]

signal dialogue_started()
signal dialogue_advanced(line_index: int, speaker: String, text: String)
signal camera_lamp_killed()
signal dialogue_completed()
signal turnstile_unlocked()
signal clue_inspected(id: String, prop_type: int)
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var turnstile_barrier: AnimatableBody2D = $TurnstileBarrier
@onready var airlock_zone: Area2D = $AirlockZone

var dialogue_index: int = -1
var is_dialogue_active: bool = false
var is_dialogue_completed: bool = false

var camera_lamp_lit: bool = true
var camera_lamp_alpha: float = 1.0
var guard_blocks_camera: bool = false
var guard_shift_offset: float = 0.0

var is_turnstile_unlocked: bool = false
var turnstile_rotation_progress: float = 0.0
var is_level_completed: bool = false

var ucp_notice_inspected: bool = false
var monitor_inspected: bool = false

var _pulse_time: float = 0.0
var _dialogue_timer: float = 0.0
var _auto_advance_delay: float = 4.0
var _turnstile_tween: Tween
var _guard_tween: Tween

var _dialogue_canvas: Node2D
var _ambient_hum_player: AudioStreamPlayer
var _relay_click_player: AudioStreamPlayer
var _turnstile_audio_player: AudioStreamPlayer
var _dialogue_blip_player: AudioStreamPlayer
var _door_audio_player: AudioStreamPlayer

var _ambient_hum_sfx: AudioStreamWAV
var _relay_click_sfx: AudioStreamWAV
var _turnstile_unlatch_sfx: AudioStreamWAV
var _door_seal_sfx: AudioStreamWAV
var _dialogue_blip_lena_sfx: AudioStreamWAV
var _dialogue_blip_guard_sfx: AudioStreamWAV


func _ready() -> void:
	_setup_camera()
	_setup_audio()
	_setup_dialogue_canvas()
	_connect_props()
	
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	
	queue_redraw()


func _setup_dialogue_canvas() -> void:
	_dialogue_canvas = Node2D.new()
	_dialogue_canvas.name = "DialogueCanvas"
	_dialogue_canvas.z_index = 20
	_dialogue_canvas.draw.connect(_draw_in_world_dialogue.bind(_dialogue_canvas))
	add_child(_dialogue_canvas)


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
	_relay_click_sfx = ProceduralAudio.create_camera_click_sound()
	_turnstile_unlatch_sfx = ProceduralAudio.create_turnstile_unlatch_sound()
	_door_seal_sfx = ProceduralAudio.create_airlock_seal_sound()
	_dialogue_blip_lena_sfx = ProceduralAudio.create_dialogue_blip_sound(true)
	_dialogue_blip_guard_sfx = ProceduralAudio.create_dialogue_blip_sound(false)
	
	_ambient_hum_player = AudioStreamPlayer.new()
	_ambient_hum_player.name = "AmbientHumPlayer"
	_ambient_hum_player.stream = _ambient_hum_sfx
	_ambient_hum_player.volume_db = -14.0
	_ambient_hum_player.bus = &"Master"
	add_child(_ambient_hum_player)
	_ambient_hum_player.play()
	
	_relay_click_player = AudioStreamPlayer.new()
	_relay_click_player.name = "RelayClickPlayer"
	_relay_click_player.volume_db = -2.0
	_relay_click_player.bus = &"Master"
	add_child(_relay_click_player)
	
	_turnstile_audio_player = AudioStreamPlayer.new()
	_turnstile_audio_player.name = "TurnstileAudioPlayer"
	_turnstile_audio_player.volume_db = -3.0
	_turnstile_audio_player.bus = &"Master"
	add_child(_turnstile_audio_player)
	
	_dialogue_blip_player = AudioStreamPlayer.new()
	_dialogue_blip_player.name = "DialogueBlipPlayer"
	_dialogue_blip_player.volume_db = -10.0
	_dialogue_blip_player.bus = &"Master"
	add_child(_dialogue_blip_player)
	
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
	
	# Auto-advance dialogue timer if active
	if is_dialogue_active and not is_dialogue_completed:
		_dialogue_timer += delta
		if _dialogue_timer >= _auto_advance_delay:
			advance_dialogue()
	
	queue_redraw()
	if _dialogue_canvas:
		_dialogue_canvas.queue_redraw()


func _physics_process(_delta: float) -> void:
	# Proximity check to initiate guard interaction automatically if player reaches counter
	if not is_dialogue_active and not is_dialogue_completed and player != null:
		if player.global_position.x >= 180.0 and player.global_position.x <= 280.0:
			start_dialogue()


func _unhandled_input(event: InputEvent) -> void:
	if is_dialogue_active and not is_dialogue_completed:
		if event.is_action_pressed(&"interact") or event.is_action_pressed(&"jump") or event.is_action_pressed(&"ui_accept"):
			advance_dialogue()
			get_viewport().set_input_as_handled()


func _on_prop_resonance_triggered(id: String, prop_type: int, _prop: MemoryResonancePoint) -> void:
	match id:
		"ucp_notice":
			ucp_notice_inspected = true
		"security_monitor":
			monitor_inspected = true
		"guard_station":
			if not is_dialogue_active and not is_dialogue_completed:
				start_dialogue()
			elif is_dialogue_active:
				advance_dialogue()
	
	clue_inspected.emit(id, prop_type)


func start_dialogue() -> void:
	if is_dialogue_active or is_dialogue_completed:
		return
	
	is_dialogue_active = true
	dialogue_index = 0
	_dialogue_timer = 0.0
	
	var line: Dictionary = DIALOGUE_LINES[dialogue_index]
	_play_dialogue_blip(line.get("is_lena", false))
	dialogue_started.emit()
	dialogue_advanced.emit(dialogue_index, line.get("speaker", ""), line.get("text", ""))
	queue_redraw()


func advance_dialogue() -> int:
	if not is_dialogue_active:
		start_dialogue()
		return dialogue_index
	
	_dialogue_timer = 0.0
	dialogue_index += 1
	
	if dialogue_index >= DIALOGUE_LINES.size():
		# Dialogue finished
		is_dialogue_active = false
		is_dialogue_completed = true
		dialogue_completed.emit()
		unlock_turnstile()
		queue_redraw()
		return -1
	
	var line: Dictionary = DIALOGUE_LINES[dialogue_index]
	_play_dialogue_blip(line.get("is_lena", false))
	
	# Event trigger on Line 5: LENA: "Jakub nie żyje."
	# Lamp cuts off abruptly, relay sound plays, guard shifts forward to block camera lens
	if dialogue_index == 5:
		_trigger_camera_lamp_kill()
	
	dialogue_advanced.emit(dialogue_index, line.get("speaker", ""), line.get("text", ""))
	queue_redraw()
	return dialogue_index


func complete_dialogue_instantly() -> void:
	if not is_dialogue_completed:
		if camera_lamp_lit:
			_trigger_camera_lamp_kill()
		dialogue_index = DIALOGUE_LINES.size()
		is_dialogue_active = false
		is_dialogue_completed = true
		dialogue_completed.emit()
		unlock_turnstile()
		queue_redraw()


func _trigger_camera_lamp_kill() -> void:
	if not camera_lamp_lit:
		return
	
	camera_lamp_lit = false
	camera_lamp_alpha = 0.0
	guard_blocks_camera = true
	
	if _relay_click_player and _relay_click_sfx:
		_relay_click_player.stream = _relay_click_sfx
		_relay_click_player.play()
	
	if camera:
		camera.add_trauma(0.35)
	
	# Guard shifts forward to shield the camera lens
	if _guard_tween:
		_guard_tween.kill()
	_guard_tween = create_tween()
	_guard_tween.tween_property(self, "guard_shift_offset", 14.0, 0.45).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	camera_lamp_killed.emit()


func unlock_turnstile() -> void:
	if is_turnstile_unlocked:
		return
	is_turnstile_unlocked = true
	
	if _turnstile_audio_player and _turnstile_unlatch_sfx:
		_turnstile_audio_player.stream = _turnstile_unlatch_sfx
		_turnstile_audio_player.play()
	
	if camera:
		camera.add_trauma(0.20)
	
	if _turnstile_tween:
		_turnstile_tween.kill()
	_turnstile_tween = create_tween()
	_turnstile_tween.tween_property(self, "turnstile_rotation_progress", 1.0, 0.8).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	if turnstile_barrier:
		var target_y := turnstile_barrier.position.y - 80.0
		_turnstile_tween.parallel().tween_property(turnstile_barrier, "position:y", target_y, 0.8)
		# Clear barrier collision
		for child in turnstile_barrier.get_children():
			if child is CollisionShape2D:
				(child as CollisionShape2D).set_deferred("disabled", true)
	
	turnstile_unlocked.emit()


func _play_dialogue_blip(is_lena: bool) -> void:
	if _dialogue_blip_player:
		_dialogue_blip_player.stream = _dialogue_blip_lena_sfx if is_lena else _dialogue_blip_guard_sfx
		_dialogue_blip_player.play()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_turnstile_unlocked:
		if not is_level_completed:
			is_level_completed = true
			if _door_audio_player and _door_seal_sfx:
				_door_audio_player.stream = _door_seal_sfx
				_door_audio_player.play()
			level_completed.emit()


func _draw() -> void:
	# 1. Architectural structure and modernist grid panels
	_draw_architecture()
	
	# 2. Left entrance airlock frame (returning from Station 03 Puste laboratorium)
	_draw_entrance_frame()
	
	# 3. Exterior glass vestibule peering out at Space 05 (Rówień nocą)
	_draw_exterior_vestibule()
	
	# 4. Guard reception desk, armored lead-glass partition & guard figure
	_draw_guard_booth_and_figure()
	
	# 5. Overhead institutional security camera & directional spotlight lamp
	_draw_security_camera_and_lamp()
	
	# 6. Mechanical security turnstile gate
	_draw_turnstile_gate()
	
	# 7. Fluorescent corridor lighting fixtures
	_draw_fluorescent_fixtures()


func _draw_architecture() -> void:
	# Floor slab (y = 296..360)
	draw_rect(Rect2(0.0, 296.0, 640.0, 64.0), COLOR_FLOOR)
	draw_rect(Rect2(0.0, 296.0, 640.0, 3.0), COLOR_FLOOR_EDGE)
	
	# Wall panel seam lines (modernist grid at 80px intervals)
	for i in range(1, 8):
		var x := float(i) * 80.0
		draw_line(Vector2(x, 36.0), Vector2(x, 296.0), Color(0.12, 0.18, 0.22, 0.45), 1.0)
	
	# Horizontal dado rail and trunking (y = 212.0 and y = 104.0)
	draw_rect(Rect2(0.0, 212.0, 640.0, 4.0), COLOR_DARK_STEEL)
	draw_rect(Rect2(0.0, 104.0, 640.0, 3.0), COLOR_DARK_STEEL * 0.8)
	
	# Ceiling beam structure (y = 0..36)
	draw_rect(Rect2(0.0, 0.0, 640.0, 36.0), Color("121a20"))
	draw_line(Vector2(0.0, 36.0), Vector2(640.0, 36.0), COLOR_INFRASTRUCTURE * 0.4, 2.0)


func _draw_entrance_frame() -> void:
	# Left Entrance frame (x = 10..70, y = 180..296) - where Lena arrives from Station 03
	var frame_rect := Rect2(10.0, 180.0, 60.0, 116.0)
	draw_rect(frame_rect, Color("141c22"))
	draw_rect(frame_rect, COLOR_DARK_STEEL, false, 2.0)
	
	# Top casing
	draw_rect(Rect2(6.0, 168.0, 68.0, 14.0), COLOR_DARK_STEEL)
	draw_rect(Rect2(6.0, 168.0, 68.0, 14.0), COLOR_INFRASTRUCTURE * 0.6, false, 1.0)
	
	# Door indicator lamp (Cyan - open corridor behind Lena)
	draw_circle(Vector2(40.0, 175.0), 3.0, COLOR_CYAN * 0.8)


func _draw_exterior_vestibule() -> void:
	# Large floor-to-ceiling glass vestibule on right side (x = 520..640, y = 110..296)
	# Opens up towards Space 05: Rówień nocą (the cold exterior city night)
	var win_rect := Rect2(520.0, 110.0, 120.0, 186.0)
	draw_rect(Rect2(516.0, 106.0, 124.0, 190.0), COLOR_DARK_STEEL)
	draw_rect(Rect2(516.0, 106.0, 124.0, 190.0), COLOR_INFRASTRUCTURE * 0.5, false, 2.0)
	
	# Deep exterior night sky (#0c1318)
	draw_rect(win_rect, Color("0a1014"))
	
	# City silhouettes in the far distance (Streetlamps, tram overhead wire poles, damp rain reflections)
	# Distant streetlamp glow (warm muted amber in distance)
	draw_circle(Vector2(580.0, 210.0), 3.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.45))
	draw_circle(Vector2(580.0, 210.0), 18.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.08))
	draw_line(Vector2(580.0, 213.0), Vector2(580.0, 296.0), Color("18232a"), 1.5)
	
	# Overhead tram catenary wire lines
	draw_line(Vector2(520.0, 160.0), Vector2(640.0, 172.0), Color(0.20, 0.30, 0.35, 0.4), 1.0)
	draw_line(Vector2(520.0, 168.0), Vector2(640.0, 180.0), Color(0.18, 0.28, 0.32, 0.35), 1.0)
	
	# Distant building block outline
	draw_rect(Rect2(540.0, 170.0, 35.0, 126.0), Color("0f161c"))
	draw_rect(Rect2(605.0, 150.0, 35.0, 146.0), Color("0d1419"))
	
	# Glass panes reflection diagonals
	draw_line(Vector2(525.0, 115.0), Vector2(600.0, 290.0), Color(1.0, 1.0, 1.0, 0.04), 2.5)
	draw_line(Vector2(560.0, 115.0), Vector2(635.0, 290.0), Color(1.0, 1.0, 1.0, 0.03), 2.0)
	
	# Exit door frame vertical dividers (Mullions)
	draw_line(Vector2(570.0, 110.0), Vector2(570.0, 296.0), COLOR_DARK_STEEL, 2.0)
	
	# Green/Cyan exit sign above vestibule: "WYJŚCIE / RÓWIEŃ"
	var sign_rect := Rect2(550.0, 94.0, 60.0, 12.0)
	draw_rect(sign_rect, Color("14221d"))
	draw_rect(sign_rect, COLOR_CYAN * 0.7, false, 1.0)
	draw_line(Vector2(556.0, 100.0), Vector2(604.0, 100.0), COLOR_CYAN * 0.85, 1.0)


func _draw_guard_booth_and_figure() -> void:
	# ── Guard Reception Counter (x = 220..330, y = 220..296) ──
	var counter_rect := Rect2(220.0, 252.0, 110.0, 44.0)
	draw_rect(counter_rect, COLOR_DARK_STEEL)
	draw_rect(counter_rect, COLOR_INFRASTRUCTURE * 0.65, false, 1.5)
	
	# Countertop dark oak/linoleum slab (x = 216..334, y = 250..254)
	draw_rect(Rect2(216.0, 250.0, 118.0, 4.0), Color("344752"))
	
	# ── Armored Lead Glass Partition (x = 230..330, y = 145..250) ──
	var glass_rect := Rect2(230.0, 145.0, 100.0, 105.0)
	draw_rect(glass_rect, Color(0.12, 0.18, 0.22, 0.45))
	draw_rect(glass_rect, COLOR_INFRASTRUCTURE * 0.7, false, 1.5)
	
	# Brass/steel mounting frame posts
	draw_line(Vector2(230.0, 145.0), Vector2(230.0, 250.0), COLOR_INFRASTRUCTURE, 2.0)
	draw_line(Vector2(330.0, 145.0), Vector2(330.0, 250.0), COLOR_INFRASTRUCTURE, 2.0)
	
	# Document pass-through cutout at bottom center (x = 265..295, y = 244..250)
	draw_rect(Rect2(265.0, 244.0, 30.0, 6.0), Color("121a20"))
	draw_rect(Rect2(265.0, 244.0, 30.0, 6.0), COLOR_INFRASTRUCTURE * 0.5, false, 1.0)
	
	# Circular acoustic speaking hole array on glass
	for row in range(3):
		for col in range(3):
			var sx := 275.0 + float(col) * 5.0
			var sy := 185.0 + float(row) * 5.0
			draw_circle(Vector2(sx, sy), 0.9, Color("141c22"))
	
	# Diagonal reflection sheens across armored glass
	draw_line(Vector2(235.0, 150.0), Vector2(295.0, 245.0), Color(1.0, 1.0, 1.0, 0.08), 2.0)
	draw_line(Vector2(260.0, 150.0), Vector2(320.0, 245.0), Color(1.0, 1.0, 1.0, 0.05), 1.5)
	
	# ── Guard Character Figure (Behind Glass Counter) ──
	# Base guard coordinates (x = 280, y = 205..250)
	# When guard_blocks_camera is true, guard leans forward / right by guard_shift_offset
	var gx := 280.0 + guard_shift_offset
	var gy := 215.0
	
	# Guard chair backrest
	draw_rect(Rect2(gx - 10.0, gy - 8.0, 20.0, 26.0), Color("1b272f"))
	draw_rect(Rect2(gx - 10.0, gy - 8.0, 20.0, 26.0), COLOR_DARK_STEEL, false, 1.0)
	
	# Guard Torso & Institutional Uniform (#182126 dark sea graphite jacket with #263943 steel lapels)
	var torso_pts := PackedVector2Array([
		Vector2(gx - 8.0, gy - 2.0),
		Vector2(gx + 8.0, gy - 2.0),
		Vector2(gx + 10.0, gy + 32.0),
		Vector2(gx - 10.0, gy + 32.0),
	])
	draw_polygon(torso_pts, [Color("182126")])
	# Uniform epaulets & collar
	draw_line(Vector2(gx - 8.0, gy - 2.0), Vector2(gx + 8.0, gy - 2.0), COLOR_INFRASTRUCTURE * 0.7, 1.5)
	draw_line(Vector2(gx, gy - 2.0), Vector2(gx, gy + 16.0), Color("263943"), 1.2)
	# Security badge on chest (Muted sage rectangle)
	draw_rect(Rect2(gx + 2.0, gy + 4.0, 4.0, 5.0), COLOR_INFRASTRUCTURE * 0.8)
	
	# Guard Head & Cap
	draw_circle(Vector2(gx, gy - 12.0), 6.5, Color("cca078")) # Muted skin tone
	# Service peaked cap (Dark graphite visor)
	draw_rect(Rect2(gx - 7.0, gy - 18.0, 14.0, 6.0), Color("151e24"))
	draw_line(Vector2(gx - 8.0, gy - 12.0), Vector2(gx + 8.0, gy - 12.0), Color("0d1317"), 2.0)
	
	# If guard is shielding camera lens (Scene 04 action):
	if guard_blocks_camera:
		# Raised arm and hand covering the camera field of view
		var arm_pts := PackedVector2Array([
			Vector2(gx + 4.0, gy + 2.0),
			Vector2(gx + 14.0, gy - 8.0),
			Vector2(gx + 18.0, gy - 18.0),
			Vector2(gx + 12.0, gy - 16.0),
		])
		draw_polygon(arm_pts, [Color("182126")])
		draw_circle(Vector2(gx + 16.0, gy - 17.0), 3.2, Color("cca078")) # Hand shielding lens


func _draw_security_camera_and_lamp() -> void:
	# ── Overhead Institutional CCTV Camera (x = 300, y = 92) ──
	var cam_pos := Vector2(300.0, 92.0)
	
	# Wall ceiling bracket
	draw_line(Vector2(cam_pos.x, 36.0), cam_pos, COLOR_DARK_STEEL, 3.0)
	draw_circle(cam_pos, 4.0, COLOR_INFRASTRUCTURE)
	
	# Camera body angled down towards Lena at reception counter (approx 55 deg)
	var cam_pts := PackedVector2Array([
		Vector2(cam_pos.x - 6.0, cam_pos.y - 4.0),
		Vector2(cam_pos.x + 8.0, cam_pos.y - 4.0),
		Vector2(cam_pos.x + 12.0, cam_pos.y + 10.0),
		Vector2(cam_pos.x - 8.0, cam_pos.y + 6.0),
	])
	draw_polygon(cam_pts, [Color("1e2a32")])
	draw_polyline(cam_pts, COLOR_INFRASTRUCTURE * 0.7, 1.0)
	
	# Optical lens cylinder
	draw_line(cam_pos + Vector2(2.0, 8.0), cam_pos + Vector2(-6.0, 16.0), Color("0d1318"), 4.0)
	
	# Recording status LED
	# If camera_lamp_lit is true: steady red recording LED; if killed: dark off LED
	var led_col := COLOR_CORRECTION if camera_lamp_lit else Color("221515")
	draw_circle(cam_pos + Vector2(6.0, 0.0), 1.5, led_col)
	if camera_lamp_lit:
		draw_circle(cam_pos + Vector2(6.0, 0.0), 3.0, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.35))
	
	# ── Directional Spotlight Lamp Attached to Camera ──
	# Housing
	draw_rect(Rect2(cam_pos.x - 12.0, cam_pos.y + 2.0, 6.0, 10.0), COLOR_DARK_STEEL)
	
	if camera_lamp_lit and camera_lamp_alpha > 0.0:
		# Bright directional spotlight cone illuminating Lena & counter
		var cone_pts := PackedVector2Array([
			cam_pos + Vector2(-9.0, 10.0),
			cam_pos + Vector2(-4.0, 12.0),
			Vector2(260.0, 296.0),
			Vector2(140.0, 296.0),
		])
		var light_color := Color(0.92, 0.95, 0.88, 0.065 * camera_lamp_alpha)
		draw_polygon(cone_pts, [light_color])
		
		# Hot center beam
		var core_pts := PackedVector2Array([
			cam_pos + Vector2(-8.0, 11.0),
			cam_pos + Vector2(-5.0, 12.0),
			Vector2(230.0, 296.0),
			Vector2(180.0, 296.0),
		])
		draw_polygon(core_pts, [Color(0.95, 0.98, 0.90, 0.04 * camera_lamp_alpha)])
		
		# Lamp bulb lens glow
		draw_circle(cam_pos + Vector2(-7.0, 11.0), 3.0, Color("f4f8e6", camera_lamp_alpha * 0.9))


func _draw_turnstile_gate() -> void:
	# ── Security Control Turnstile Gate (x = 360..400, y = 230..296) ──
	var base_rect := Rect2(365.0, 250.0, 24.0, 46.0)
	draw_rect(base_rect, Color("202c34"))
	draw_rect(base_rect, COLOR_DARK_STEEL, false, 1.5)
	
	# Stainless steel pedestal top cap
	draw_rect(Rect2(363.0, 246.0, 28.0, 5.0), COLOR_INFRASTRUCTURE * 0.85)
	
	# Status Indicator Lamp (Red/Cinnabar = Locked; Cyan = Unlocked/Open)
	var lamp_col := COLOR_CYAN if is_turnstile_unlocked else COLOR_CORRECTION
	draw_circle(Vector2(377.0, 242.0), 2.5, lamp_col)
	draw_circle(Vector2(377.0, 242.0), 5.5, Color(lamp_col.r, lamp_col.g, lamp_col.b, 0.35))
	
	# Turnstile rotor hub (x = 377, y = 260)
	var hub := Vector2(377.0, 260.0)
	draw_circle(hub, 4.5, COLOR_INFRASTRUCTURE)
	
	# 3 Rotating Tubular Stainless Steel Arms (120 deg apart)
	# When unlocked, rotates by turnstile_rotation_progress * 120 deg
	var base_angle := turnstile_rotation_progress * (TAU / 3.0)
	for i in range(3):
		var angle := base_angle + float(i) * (TAU / 3.0)
		var arm_end := hub + Vector2(cos(angle), sin(angle)) * 22.0
		# If locked, horizontal arm blocks passage to right (angle = 0)
		draw_line(hub, arm_end, Color("ccd4d0"), 2.5)
		draw_circle(arm_end, 1.8, Color("a0aca6"))
	
	# Floor railing guides
	draw_line(Vector2(355.0, 296.0), Vector2(355.0, 255.0), COLOR_INFRASTRUCTURE * 0.7, 2.0)
	draw_line(Vector2(405.0, 296.0), Vector2(405.0, 255.0), COLOR_INFRASTRUCTURE * 0.7, 2.0)
	draw_line(Vector2(355.0, 255.0), Vector2(405.0, 255.0), COLOR_INFRASTRUCTURE * 0.7, 1.5)


func _draw_fluorescent_fixtures() -> void:
	# Ceiling fixtures (x = 100, 260, 420, 560)
	var fixtures: Array[float] = [100.0, 260.0, 420.0, 560.0]
	for fx in fixtures:
		draw_rect(Rect2(fx - 22.0, 34.0, 44.0, 4.0), COLOR_INFRASTRUCTURE)
		draw_rect(Rect2(fx - 18.0, 36.0, 36.0, 3.0), Color("d8dec5"))
		
		# Downward illumination cone
		var cone_pts := PackedVector2Array([
			Vector2(fx - 18.0, 39.0),
			Vector2(fx + 18.0, 39.0),
			Vector2(fx + 60.0, 296.0),
			Vector2(fx - 60.0, 296.0),
		])
		draw_polygon(cone_pts, [Color(0.85, 0.88, 0.80, 0.024)])


func _draw_in_world_dialogue(canvas: CanvasItem = null) -> void:
	if not is_dialogue_active or dialogue_index < 0 or dialogue_index >= DIALOGUE_LINES.size():
		return
	
	var target: CanvasItem = canvas if canvas != null else self
	var line: Dictionary = DIALOGUE_LINES[dialogue_index]
	var speaker: String = line.get("speaker", "")
	var is_lena: bool = line.get("is_lena", false)
	var text: String = line.get("text", "")
	
	# Determine anchor position for speech bubble
	var bubble_center: Vector2
	if is_lena:
		var px := player.global_position.x if player != null else 205.0
		var py := player.global_position.y if player != null else 296.0
		bubble_center = Vector2(clampf(px, 140.0, 260.0), py - 64.0)
	else:
		# Guard bubble above reception counter
		bubble_center = Vector2(285.0 + guard_shift_offset, 126.0)
	
	var border_color := COLOR_AMBER if is_lena else COLOR_INFRASTRUCTURE
	var speaker_color := COLOR_AMBER if is_lena else Color("d8e0dc")
	var text_color := Color("f0f4f2") if not is_lena else Color("f8ecd8")
	
	# Measure text dimensions
	var font := ThemeDB.fallback_font
	var font_size := 11
	var speaker_text := "[" + speaker + "]"
	var speaker_width := font.get_string_size(speaker_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	var text_width := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	var total_w := maxf(speaker_width + 16.0, text_width + 18.0)
	var box_w := clampf(total_w, 140.0, 340.0)
	var box_h := 36.0
	
	var box_rect := Rect2(bubble_center.x - box_w * 0.5, bubble_center.y - box_h * 0.5, box_w, box_h)
	
	# Semi-transparent high-contrast dark graphite backdrop
	target.draw_rect(box_rect, Color(0.08, 0.12, 0.15, 0.94))
	target.draw_rect(box_rect, border_color * 0.85, false, 1.2)
	
	# Small pointer triangle towards character
	var pointer_pts: PackedVector2Array
	if is_lena:
		pointer_pts = PackedVector2Array([
			Vector2(bubble_center.x - 5.0, box_rect.position.y + box_h),
			Vector2(bubble_center.x + 5.0, box_rect.position.y + box_h),
			Vector2(bubble_center.x, box_rect.position.y + box_h + 6.0),
		])
	else:
		pointer_pts = PackedVector2Array([
			Vector2(bubble_center.x - 5.0, box_rect.position.y + box_h),
			Vector2(bubble_center.x + 5.0, box_rect.position.y + box_h),
			Vector2(bubble_center.x, box_rect.position.y + box_h + 6.0),
		])
	target.draw_polygon(pointer_pts, [Color(0.08, 0.12, 0.15, 0.94)])
	target.draw_polyline(pointer_pts, border_color * 0.85, 1.0)
	
	# Speaker tag
	target.draw_string(font, Vector2(box_rect.position.x + 8.0, box_rect.position.y + 13.0), speaker_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size - 1, speaker_color)
	
	# Dialogue text
	target.draw_string(font, Vector2(box_rect.position.x + 8.0, box_rect.position.y + 28.0), text, HORIZONTAL_ALIGNMENT_LEFT, box_w - 16.0, font_size, text_color)
