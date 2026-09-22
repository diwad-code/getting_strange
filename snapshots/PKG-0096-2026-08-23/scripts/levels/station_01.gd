class_name Station01
extends Node2D

## Station 01 (Przestrzeń 01: Lista kontrolna) for Getting Strange Vertical Slice.
## Represents the IKP Control Room at 21:43.
## Institutional modernist architecture, glass, brushed steel, soft work lighting.
## Follows VISUAL_DESIGN.md and FULL_STORY.md (Scene 01).

const VIEW_SIZE := Vector2(640.0, 360.0)

const COLOR_BACKGROUND := VectorStageStyle.BACKDROP
const COLOR_INFRASTRUCTURE := VectorStageStyle.LIGHT_PLANE
const COLOR_AMBER := VectorStageStyle.HUMAN_AMBER
const COLOR_CYAN := VectorStageStyle.ANCHOR_CYAN
const COLOR_CORRECTION := VectorStageStyle.CORRECTION_OXIDE
const COLOR_DARK_STEEL := VectorStageStyle.MID_PLANE
const COLOR_FLOOR := VectorStageStyle.DEEP_PLANE
const COLOR_FLOOR_EDGE := VectorStageStyle.LIGHT_PLANE

signal checklist_updated(completed_count: int, total_count: int)
signal chamber_unlocked()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var chamber_door: AnimatableBody2D = $ChamberDoor
@onready var airlock_zone: Area2D = $AirlockZone

var circuit_alpha_on: bool = false
var circuit_beta_on: bool = false
var circuit_gamma_on: bool = false
var vacuum_checked: bool = false
var photo_inspected: bool = false

var is_procedure_completed: bool = false
var is_level_completed: bool = false

var _door_open_progress: float = 0.0
var _door_tween: Tween
var _terminal_pulse: float = 0.0

var _vacuum_hum_player: AudioStreamPlayer
var _door_audio_player: AudioStreamPlayer
var _vacuum_hum_sfx: AudioStreamWAV
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
	_vacuum_hum_sfx = ProceduralAudio.create_vacuum_hum_sound()
	_door_seal_sfx = ProceduralAudio.create_airlock_seal_sound()
	
	_vacuum_hum_player = AudioStreamPlayer.new()
	_vacuum_hum_player.name = "VacuumHumAudioPlayer"
	_vacuum_hum_player.stream = _vacuum_hum_sfx
	_vacuum_hum_player.volume_db = -14.0
	_vacuum_hum_player.bus = &"Master"
	add_child(_vacuum_hum_player)
	_vacuum_hum_player.play()
	
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
			prop.state_changed.connect(_on_prop_state_changed.bind(prop))


func _process(delta: float) -> void:
	_terminal_pulse += delta * 2.0
	queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	match id:
		"circuit_alpha":
			circuit_alpha_on = prop.is_activated
		"circuit_beta":
			circuit_beta_on = prop.is_activated
		"circuit_gamma":
			circuit_gamma_on = prop.is_activated
		"vacuum_gauge":
			if circuit_alpha_on and circuit_beta_on and circuit_gamma_on:
				vacuum_checked = true
				prop.is_activated = true
		"photo_desk":
			photo_inspected = true
		"chamber_terminal":
			if is_procedure_completed and not is_level_completed:
				_unlock_chamber_door()
	
	_check_checklist_progress()


func _on_prop_state_changed(is_active: bool, prop: MemoryResonancePoint) -> void:
	match prop.resonance_id:
		"circuit_alpha":
			circuit_alpha_on = is_active
		"circuit_beta":
			circuit_beta_on = is_active
		"circuit_gamma":
			circuit_gamma_on = is_active
	
	_check_checklist_progress()


func _check_checklist_progress() -> void:
	var count := 0
	if circuit_alpha_on: count += 1
	if circuit_beta_on: count += 1
	if circuit_gamma_on: count += 1
	if vacuum_checked: count += 1
	
	checklist_updated.emit(count, 4)
	
	if count >= 3 and not vacuum_checked:
		# Automatically allow vacuum check or trigger once powered
		var gauge := props.get_node_or_null("VacuumManometer") as MemoryResonancePoint
		if gauge and not vacuum_checked:
			gauge.is_activated = true
			vacuum_checked = true
			count += 1
			checklist_updated.emit(count, 4)
	
	if count >= 4 and not is_procedure_completed:
		is_procedure_completed = true
		var terminal := props.get_node_or_null("ChamberTerminal") as MemoryResonancePoint
		if terminal:
			terminal.is_activated = true
		_unlock_chamber_door()


func _unlock_chamber_door() -> void:
	if _door_tween and _door_tween.is_running():
		return
	
	chamber_unlocked.emit()
	if _door_audio_player and _door_seal_sfx:
		_door_audio_player.stream = _door_seal_sfx
		_door_audio_player.play()
	
	if camera:
		camera.add_trauma(0.35)
	
	_door_tween = create_tween()
	_door_tween.tween_property(self, "_door_open_progress", 1.0, 1.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	if chamber_door:
		# Slide chamber door up into ceiling cavity
		var target_y := chamber_door.position.y - 70.0
		_door_tween.parallel().tween_property(chamber_door, "position:y", target_y, 1.2)


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_procedure_completed:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	# Vector-Stage composition: large planes and meaningful silhouettes before detail.
	VectorStageStyle.draw_stage_background(self, VIEW_SIZE, 1, false)
	# 1. Main institutional architecture and wall panels
	_draw_architecture()
	
	# 2. Glass observation window into dark correlation chamber
	_draw_observation_window()
	
	# 3. Institutional apparatus console screens and wall telemetry
	_draw_telemetry_console()
	
	# 4. Work lighting and atmospheric fixtures
	_draw_lighting_fixtures()
	
	# 5. Chamber airlock frame and optical corridor
	_draw_airlock_frame()


func _draw_architecture() -> void:
	# Floor slab and three broad wall facets establish depth without a tiled grid.
	var floor := PackedVector2Array([Vector2(0.0, 296.0), Vector2(640.0, 296.0), Vector2(640.0, 360.0), Vector2(0.0, 360.0)])
	VectorStageStyle.draw_facet_polygon(self, floor, COLOR_FLOOR, 0.0)
	var left_wall := PackedVector2Array([Vector2(0.0, 38.0), Vector2(210.0, 48.0), Vector2(176.0, 296.0), Vector2(0.0, 296.0)])
	var middle_wall := PackedVector2Array([Vector2(210.0, 48.0), Vector2(455.0, 38.0), Vector2(493.0, 296.0), Vector2(176.0, 296.0)])
	var right_wall := PackedVector2Array([Vector2(455.0, 38.0), Vector2(640.0, 52.0), Vector2(640.0, 296.0), Vector2(493.0, 296.0)])
	VectorStageStyle.draw_facet_polygon(self, left_wall, VectorStageStyle.shade(COLOR_DARK_STEEL, 0.22), 0.0)
	VectorStageStyle.draw_facet_polygon(self, middle_wall, COLOR_DARK_STEEL, 0.0)
	VectorStageStyle.draw_facet_polygon(self, right_wall, VectorStageStyle.shade(COLOR_DARK_STEEL, 0.35), 0.0)
	draw_line(Vector2(0.0, 296.0), Vector2(640.0, 296.0), COLOR_FLOOR_EDGE, 2.0)
	
	# Horizontal cable trunking & dado rail (y = 210.0 and y = 110.0)
	draw_rect(Rect2(0.0, 208.0, 640.0, 4.0), VectorStageStyle.shade(COLOR_DARK_STEEL, 0.38))
	draw_rect(Rect2(0.0, 108.0, 640.0, 3.0), VectorStageStyle.shade(COLOR_DARK_STEEL, 0.50))
	
	# Ceiling beam and cable raceways (y = 0..40)
	draw_rect(Rect2(0.0, 0.0, 640.0, 36.0), VectorStageStyle.INK)
	draw_line(Vector2(0.0, 36.0), Vector2(640.0, 36.0), COLOR_INFRASTRUCTURE * 0.4, 2.0)
	
	# Operator Desk (Left area: x = 60..180, y = 264..296)
	var desk_rect := Rect2(60.0, 264.0, 120.0, 32.0)
	draw_rect(desk_rect, COLOR_DARK_STEEL)
	draw_rect(desk_rect, COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	# Desk top surface lip
	draw_rect(Rect2(58.0, 262.0, 124.0, 4.0), Color("344752"))
	# Empty coffee mug per Scene 01 ("Jeden pusty kubek")
	draw_rect(Rect2(76.0, 255.0, 6.0, 7.0), Color("c4c0b4"))
	draw_rect(Rect2(74.0, 257.0, 2.0, 4.0), Color("8a877d")) # handle


func _draw_observation_window() -> void:
	# Heavy leaded observation glass window peering into dark correlation chamber (x = 360..480, y = 120..220)
	var win_rect := Rect2(360.0, 120.0, 120.0, 95.0)
	
	# Window steel frame
	draw_rect(Rect2(356.0, 116.0, 128.0, 103.0), COLOR_DARK_STEEL)
	draw_rect(Rect2(356.0, 116.0, 128.0, 103.0), COLOR_INFRASTRUCTURE * 0.5, false, 2.0)
	
	# Inner chamber background (deep cold void)
	draw_rect(win_rect, Color("0a1014"))
	
	# Faint correlation grid lines inside dark chamber (subtle cyan/grey)
	for gy in range(4):
		var y := 135.0 + float(gy) * 22.0
		draw_line(Vector2(362.0, y), Vector2(478.0, y), Color(0.15, 0.35, 0.38, 0.25), 1.0)
	
	# Twin correlation target markers in chamber
	draw_circle(Vector2(400.0, 168.0), 3.0, COLOR_CYAN * 0.6)
	var mark2_col := COLOR_CYAN * 0.8 if vacuum_checked else Color(0.2, 0.3, 0.32, 0.4)
	draw_circle(Vector2(440.0, 168.0), 3.0, mark2_col)
	
	# Glass diagonal reflection sheen
	draw_line(Vector2(364.0, 124.0), Vector2(430.0, 210.0), Color(1.0, 1.0, 1.0, 0.08), 2.0)
	draw_line(Vector2(380.0, 124.0), Vector2(450.0, 210.0), Color(1.0, 1.0, 1.0, 0.04), 4.0)


func _draw_telemetry_console() -> void:
	# Main wall telemetry display panel (x = 210..340, y = 130..195)
	var panel_rect := Rect2(210.0, 130.0, 130.0, 68.0)
	draw_rect(panel_rect, Color("10171c"))
	draw_rect(panel_rect, COLOR_DARK_STEEL, false, 1.5)
	
	# Institutional header
	draw_rect(Rect2(212.0, 132.0, 126.0, 12.0), Color("17232a"))
	# Cathode phosphor text lines (drawn with vector lines for resolution independence)
	# "IKP STEROWNIA // 21:43:00"
	draw_line(Vector2(216.0, 138.0), Vector2(285.0, 138.0), COLOR_INFRASTRUCTURE * 0.85, 1.5)
	draw_line(Vector2(295.0, 138.0), Vector2(332.0, 138.0), COLOR_CYAN * 0.9, 1.5)
	
	# Status lines: OBWODY [A] [B] [C]
	var p_pulse := sin(_terminal_pulse) * 0.5 + 0.5
	var a_col := COLOR_CYAN if circuit_alpha_on else Color("553333")
	var b_col := COLOR_CYAN if circuit_beta_on else Color("553333")
	var c_col := COLOR_CYAN if circuit_gamma_on else Color("553333")
	
	# Circuit status blocks on panel
	draw_rect(Rect2(218.0, 150.0, 18.0, 6.0), a_col)
	draw_rect(Rect2(242.0, 150.0, 18.0, 6.0), b_col)
	draw_rect(Rect2(266.0, 150.0, 18.0, 6.0), c_col)
	
	# Vacuum status graph
	var vac_col := COLOR_CYAN if vacuum_checked else COLOR_AMBER * (0.6 + p_pulse * 0.4)
	draw_line(Vector2(218.0, 168.0), Vector2(250.0, 168.0), vac_col, 1.5)
	draw_line(Vector2(250.0, 168.0), Vector2(280.0, 162.0 if vacuum_checked else 168.0), vac_col, 1.5)
	draw_line(Vector2(280.0, 162.0 if vacuum_checked else 168.0), Vector2(325.0, 162.0 if vacuum_checked else 168.0), vac_col, 1.5)
	
	# Result status footer: WYNIK ZGODNY / OCZEKIWANIE
	var result_col := COLOR_CYAN if is_procedure_completed else COLOR_INFRASTRUCTURE * 0.6
	draw_line(Vector2(218.0, 184.0), Vector2(310.0, 184.0), result_col, 2.0)
	
	# Console bench below telemetry (x = 205..345, y = 270..296)
	var bench_rect := Rect2(205.0, 270.0, 140.0, 26.0)
	draw_rect(bench_rect, COLOR_DARK_STEEL)
	draw_rect(bench_rect, COLOR_INFRASTRUCTURE * 0.6, false, 1.0)


func _draw_lighting_fixtures() -> void:
	# Ceiling fluorescent fixtures (x = 120, 280, 440, 560)
	var fixture_x := [120.0, 275.0, 420.0, 560.0]
	for fx in fixture_x:
		# Fixture housing
		draw_rect(Rect2(fx - 24.0, 34.0, 48.0, 4.0), COLOR_INFRASTRUCTURE)
		# Tube light (warm white / soft amber)
		draw_rect(Rect2(fx - 20.0, 36.0, 40.0, 3.0), Color("d8dec5"))
		# Soft downward light cone (very subtle alpha polygon)
		var pts := PackedVector2Array([
			Vector2(fx - 20.0, 39.0),
			Vector2(fx + 20.0, 39.0),
			Vector2(fx + 65.0, 296.0),
			Vector2(fx - 65.0, 296.0),
		])
		draw_polygon(pts, [Color(0.85, 0.88, 0.80, 0.025)])


func _draw_airlock_frame() -> void:
	# Heavy Chamber Door Frame (x = 550..620, y = 180..296)
	var frame_rect := Rect2(550.0, 180.0, 70.0, 116.0)
	draw_rect(frame_rect, Color("141c22"))
	draw_rect(frame_rect, COLOR_DARK_STEEL, false, 2.0)
	
	# Top hydraulic housing
	draw_rect(Rect2(546.0, 168.0, 78.0, 14.0), COLOR_DARK_STEEL)
	draw_rect(Rect2(546.0, 168.0, 78.0, 14.0), COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	
	# Airlock status lamp (Red when sealed, Cyan when open/unlocked)
	var lamp_col := COLOR_CYAN if is_procedure_completed else COLOR_CORRECTION
	draw_circle(Vector2(585.0, 175.0), 3.5, lamp_col)
	draw_circle(Vector2(585.0, 175.0), 6.5, Color(lamp_col.r, lamp_col.g, lamp_col.b, 0.25))
	
	# Direction arrow to Chamber 02 Korelacja
	if is_procedure_completed:
		var arr_pulse := sin(_terminal_pulse * 2.0) * 0.5 + 0.5
		var arr_col := Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.5 + arr_pulse * 0.5)
		draw_line(Vector2(575.0, 238.0), Vector2(595.0, 238.0), arr_col, 2.0)
		draw_line(Vector2(590.0, 232.0), Vector2(595.0, 238.0), arr_col, 2.0)
		draw_line(Vector2(590.0, 244.0), Vector2(595.0, 238.0), arr_col, 2.0)
