class_name Station05
extends Node2D

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

## Station 05 (Przestrzeń 05: Rówień nocą) for Getting Strange Vertical Slice.
## Represents the street route from the IKP institute to the transit stop in Rówień.
## Implements the rainy night city atmosphere, anachronistic billboard, missing floor building,
## interactive crosswalk acoustic signal whispering Lena's name once, and the restless grid
## observation discontinuity mechanic (#geometry-restless-grid).
## Conforms to VISUAL_DESIGN.md and FULL_STORY.md (Scene 05).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 1280.0

const COLOR_BACKGROUND := VectorStageStyle.BACKDROP
const COLOR_NIGHT_SKY := VectorStageStyle.BACKDROP
const COLOR_INFRASTRUCTURE := VectorStageStyle.LIGHT_PLANE
const COLOR_AMBER := VectorStageStyle.HUMAN_AMBER
const COLOR_CYAN := VectorStageStyle.ANCHOR_CYAN
const COLOR_CORRECTION := VectorStageStyle.CORRECTION_OXIDE
const COLOR_DARK_STEEL := VectorStageStyle.MID_PLANE
const COLOR_FLOOR := VectorStageStyle.DEEP_PLANE
const COLOR_FLOOR_EDGE := VectorStageStyle.LIGHT_PLANE
const COLOR_ASPHALT := Color("18242d")
const COLOR_PUDDLE := Color("23313c")
const COLOR_RAIL := VectorStageStyle.LIGHT_PLANE

signal clue_inspected(id: String, prop_type: int)
signal crosswalk_signal_activated()
signal restless_grid_transformed()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone

var billboard_inspected: bool = false
var missing_floor_inspected: bool = false
var crosswalk_signal_triggered: bool = false
var schedule_inspected: bool = false

var restless_grid_shifted: bool = false
var crosswalk_lamp_green: bool = false

var is_level_completed: bool = false

var _pulse_time: float = 0.0
var _crosswalk_timer: float = 0.0

var _rain_player: AudioStreamPlayer
var _traction_player: AudioStreamPlayer
var _crosswalk_player: AudioStreamPlayer
var _transition_player: AudioStreamPlayer

var _rain_sfx: AudioStreamWAV
var _traction_sfx: AudioStreamWAV
var _crosswalk_sfx: AudioStreamWAV
var _transition_sfx: AudioStreamWAV


func _ready() -> void:
	_setup_camera()
	_setup_audio()
	_setup_guidance()
	_connect_props()
	
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	
	queue_redraw()


func _setup_guidance() -> void:
	var guidance := get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	if guidance:
		var beat := GuidanceBeat.new()
		beat.beat_id = &"s05_roadwork_observation"
		beat.scene_id = &"station_05"
		beat.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
		beat.thought_kind = &"observation"
		beat.text_pl = "Kolejne wykopy. Chodnik rozkopany od poniedziałku."
		beat.text_en = "More excavations. Sidewalk dug up since Monday."
		beat.cooldown_s = 8.0
		guidance.register_beat(beat)


func _setup_camera() -> void:
	if not is_instance_valid(camera):
		camera = CinematicCamera.new()
		camera.name = "Camera"
		add_child(camera)
	
	camera.target = player
	var bounds: Array[Rect2] = [
		Rect2(Vector2(0.0, 0.0), VIEW_SIZE),
		Rect2(Vector2(640.0, 0.0), VIEW_SIZE),
	]
	camera.setup_chambers(bounds)
	camera.chamber_changed.connect(_on_chamber_changed)


func _setup_audio() -> void:
	_rain_sfx = ProceduralAudio.create_rain_asphalt_sound()
	_traction_sfx = ProceduralAudio.create_tram_traction_sound()
	_crosswalk_sfx = ProceduralAudio.create_crosswalk_signal_sound(true)
	_transition_sfx = ProceduralAudio.create_airlock_seal_sound()
	
	_rain_player = AudioStreamPlayer.new()
	_rain_player.name = "RainAudioPlayer"
	_rain_player.stream = _rain_sfx
	_rain_player.volume_db = -10.0
	_rain_player.bus = &"Master"
	add_child(_rain_player)
	_rain_player.play()
	
	_traction_player = AudioStreamPlayer.new()
	_traction_player.name = "TractionAudioPlayer"
	_traction_player.stream = _traction_sfx
	_traction_player.volume_db = -16.0
	_traction_player.bus = &"Master"
	add_child(_traction_player)
	_traction_player.play()
	
	_crosswalk_player = AudioStreamPlayer.new()
	_crosswalk_player.name = "CrosswalkAudioPlayer"
	_crosswalk_player.stream = _crosswalk_sfx
	_crosswalk_player.volume_db = -4.0
	_crosswalk_player.bus = &"Master"
	add_child(_crosswalk_player)
	
	_transition_player = AudioStreamPlayer.new()
	_transition_player.name = "TransitionAudioPlayer"
	_transition_player.volume_db = -5.0
	_transition_player.bus = &"Master"
	add_child(_transition_player)


func _connect_props() -> void:
	if props == null:
		return
	
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var prop := child as MemoryResonancePoint
			prop.resonance_triggered.connect(_on_prop_resonance_triggered.bind(prop))


func _process(delta: float) -> void:
	_pulse_time += delta * 2.0
	
	if crosswalk_lamp_green:
		_crosswalk_timer += delta
	
	# Observation check for restless grid restructure (#geometry-restless-grid)
	# When player has crossed into Chamber 1 (x > 640) and camera is no longer focusing Chamber 0,
	# the background alleyway shifts into its solid alternative configuration.
	if not restless_grid_shifted and player != null:
		if player.global_position.x >= 650.0 and camera != null and camera.active_chamber_index == 1:
			restless_grid_shifted = true
			restless_grid_transformed.emit()
			queue_redraw()
	
	queue_redraw()


func _on_chamber_changed(_from_idx: int, to_idx: int) -> void:
	if to_idx == 1 and not restless_grid_shifted:
		restless_grid_shifted = true
		restless_grid_transformed.emit()
		queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int, _prop: MemoryResonancePoint) -> void:
	match id:
		"billboard", "billboard_anachronism":
			billboard_inspected = true
		"missing_floor_marker", "missing_floor":
			missing_floor_inspected = true
		"crosswalk_beacon", "crosswalk_signal":
			crosswalk_signal_triggered = true
			activate_crosswalk_signal()
		"transit_timetable", "transit_schedule":
			schedule_inspected = true
	
	clue_inspected.emit(id, prop_type)


func activate_crosswalk_signal() -> void:
	if crosswalk_lamp_green:
		return
	crosswalk_lamp_green = true
	crosswalk_signal_triggered = true
	
	if _crosswalk_player and _crosswalk_sfx:
		_crosswalk_player.stream = _crosswalk_sfx
		_crosswalk_player.play()
	
	if camera:
		camera.add_trauma(0.15)
	
	crosswalk_signal_activated.emit()
	queue_redraw()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player"):
		if not is_level_completed:
			is_level_completed = true
			var game_state := get_node_or_null("/root/GameStateManager")
			if game_state and game_state.has_method("set_campaign_flag"):
				game_state.set_campaign_flag(&"ordinary_return_complete", true)
			if _transition_player and _transition_sfx:
				_transition_player.stream = _transition_sfx
				_transition_player.play()
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var crossing_col := VectorStageStyle.MID_PLANE
	if crosswalk_lamp_green:
		crossing_col = VectorStageStyle.HUMAN_AMBER
	if restless_grid_shifted:
		crossing_col = VectorStageStyle.CORRECTION_OXIDE
	draw_line(Vector2(410.0, 216.0), Vector2(590.0, 212.0), crossing_col, 3.0)
	draw_rect(Rect2(662.0, 202.0, 12.0, 42.0), crossing_col)
	if schedule_inspected:
		draw_rect(Rect2(1000.0, 184.0, 14.0, 54.0), VectorStageStyle.ANCHOR_CYAN)


func _draw_sky_and_backdrop() -> void:
	# Dark night sky background
	draw_rect(Rect2(0.0, 0.0, LEVEL_WIDTH, 296.0), COLOR_NIGHT_SKY)
	
	# Distant city skyline silhouettes (Modernist blocks, chimneys, communication towers)
	var skyline_pts := PackedVector2Array([
		Vector2(0.0, 180.0),
		Vector2(50.0, 180.0),
		Vector2(50.0, 130.0),
		Vector2(110.0, 130.0),
		Vector2(110.0, 160.0),
		Vector2(180.0, 160.0),
		Vector2(180.0, 110.0),
		Vector2(260.0, 110.0),
		Vector2(260.0, 175.0),
		Vector2(320.0, 175.0),
		Vector2(320.0, 140.0),
		Vector2(420.0, 140.0),
		Vector2(420.0, 165.0),
		Vector2(520.0, 165.0),
		Vector2(520.0, 120.0),
		Vector2(610.0, 120.0),
		Vector2(610.0, 170.0),
		Vector2(700.0, 170.0),
		Vector2(700.0, 105.0),
		Vector2(790.0, 105.0),
		Vector2(790.0, 155.0),
		Vector2(880.0, 155.0),
		Vector2(880.0, 135.0),
		Vector2(970.0, 135.0),
		Vector2(970.0, 160.0),
		Vector2(1060.0, 160.0),
		Vector2(1060.0, 115.0),
		Vector2(1160.0, 115.0),
		Vector2(1160.0, 165.0),
		Vector2(1280.0, 165.0),
		Vector2(1280.0, 296.0),
		Vector2(0.0, 296.0),
	])
	draw_polygon(skyline_pts, [Color("0e161c")])
	
	# Distant window matrices (rare muted amber/cyan dots across the horizon)
	for i in range(12):
		var wx := 80.0 + float(i) * 95.0
		var wy := 145.0 + sin(float(i) * 2.1) * 20.0
		var is_amber := (i % 3 == 0)
		var col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.25) if is_amber else Color(0.35, 0.45, 0.48, 0.20)
		draw_rect(Rect2(wx, wy, 4.0, 5.0), col)


func _draw_chamber_0_architecture() -> void:
	# ── 1. IKP Institute Entrance Facade (x = 0..100, y = 40..296) ──
	# Main entrance block
	draw_rect(Rect2(0.0, 50.0, 95.0, 246.0), Color("18242c"))
	draw_rect(Rect2(0.0, 50.0, 95.0, 246.0), COLOR_DARK_STEEL, false, 2.0)
	
	# Institutional glass entrance doors with cyan warm interior glow
	draw_rect(Rect2(15.0, 180.0, 65.0, 116.0), Color(0.15, 0.25, 0.28, 0.7))
	draw_rect(Rect2(15.0, 180.0, 65.0, 116.0), COLOR_INFRASTRUCTURE * 0.7, false, 1.5)
	draw_line(Vector2(47.5, 180.0), Vector2(47.5, 296.0), COLOR_INFRASTRUCTURE * 0.7, 1.5)
	
	# Overhanging concrete canopy above institute doors
	draw_rect(Rect2(0.0, 172.0, 105.0, 8.0), Color("243642"))
	draw_rect(Rect2(0.0, 172.0, 105.0, 8.0), COLOR_INFRASTRUCTURE * 0.8, false, 1.0)
	
	# Illuminated neon sign: "INSTYTUT KORELACJI PRÓŻNIOWEJ"
	var sign_rect := Rect2(10.0, 156.0, 80.0, 12.0)
	draw_rect(sign_rect, Color("101a20"))
	draw_rect(sign_rect, COLOR_CYAN * 0.6, false, 1.0)
	draw_line(Vector2(14.0, 162.0), Vector2(86.0, 162.0), COLOR_CYAN * 0.85, 1.0)
	
	# ── 2. Residential Block 1 (x = 110..260, y = 60..296) ──
	draw_rect(Rect2(110.0, 60.0, 150.0, 236.0), Color("162027"))
	draw_rect(Rect2(110.0, 60.0, 150.0, 236.0), Color("22303a"), false, 1.5)
	# Window grid (4 storeys, 3 columns)
	for row in range(4):
		for col in range(3):
			var rx := 125.0 + float(col) * 45.0
			var ry := 80.0 + float(row) * 48.0
			draw_rect(Rect2(rx, ry, 26.0, 30.0), Color("0d1419"))
			draw_rect(Rect2(rx, ry, 26.0, 30.0), COLOR_DARK_STEEL * 0.8, false, 1.0)
			# Window mullion divider
			draw_line(Vector2(rx + 13.0, ry), Vector2(rx + 13.0, ry + 30.0), Color("1c2830"), 1.0)
	
	# ── 3. Missing Floor Building Facade (x = 270..440, y = 30..296) ──
	# 5-Storey modernist block where the 3rd floor (y = 135..185) is cleanly omitted (#geometry-restless-grid)
	# Lower Building Mass: Floors 1 & 2 (y = 185..296)
	draw_rect(Rect2(270.0, 185.0, 170.0, 111.0), Color("17222a"))
	draw_rect(Rect2(270.0, 185.0, 170.0, 111.0), COLOR_DARK_STEEL, false, 1.5)
	# Lower windows
	for row in range(2):
		for col in range(3):
			var rx := 290.0 + float(col) * 50.0
			var ry := 200.0 + float(row) * 45.0
			draw_rect(Rect2(rx, ry, 30.0, 30.0), Color("0d1419"))
			draw_rect(Rect2(rx, ry, 30.0, 30.0), COLOR_DARK_STEEL * 0.8, false, 1.0)
	
	# Upper Building Mass: Floors 4 & 5 (y = 30..135)
	draw_rect(Rect2(270.0, 30.0, 170.0, 105.0), Color("17222a"))
	draw_rect(Rect2(270.0, 30.0, 170.0, 105.0), COLOR_DARK_STEEL, false, 1.5)
	# Upper windows
	for row in range(2):
		for col in range(3):
			var rx := 290.0 + float(col) * 50.0
			var ry := 45.0 + float(row) * 42.0
			draw_rect(Rect2(rx, ry, 30.0, 28.0), Color("0d1419"))
			draw_rect(Rect2(rx, ry, 30.0, 28.0), COLOR_DARK_STEEL * 0.8, false, 1.0)
	
	# Floor 3 Void Gap (y = 135..185): Clean absence of walls/windows; only 3 slender concrete support pillars!
	draw_line(Vector2(290.0, 135.0), Vector2(290.0, 185.0), COLOR_INFRASTRUCTURE * 0.85, 4.0)
	draw_line(Vector2(355.0, 135.0), Vector2(355.0, 185.0), COLOR_INFRASTRUCTURE * 0.85, 4.0)
	draw_line(Vector2(420.0, 135.0), Vector2(420.0, 185.0), COLOR_INFRASTRUCTURE * 0.85, 4.0)
	# Steel reinforcement cross-tie
	draw_line(Vector2(290.0, 160.0), Vector2(420.0, 160.0), Color("283944"), 1.5)
	
	# ── 4. Restless Alleyway / Courtyard Gate (x = 450..580, y = 70..296) ──
	# Shifts state when player moves past (#geometry-restless-grid)
	if not restless_grid_shifted:
		# State 1: Open arched passageway leading to dark cobblestone courtyard
		draw_rect(Rect2(450.0, 70.0, 130.0, 226.0), Color("131c23"))
		draw_rect(Rect2(450.0, 70.0, 130.0, 226.0), COLOR_DARK_STEEL, false, 1.5)
		# Archway cutout (x = 475..555, y = 160..296)
		var arch_rect := Rect2(475.0, 175.0, 80.0, 121.0)
		draw_rect(arch_rect, Color("0a1014"))
		draw_line(Vector2(475.0, 175.0), Vector2(555.0, 175.0), COLOR_INFRASTRUCTURE * 0.6, 2.0)
		# Distant courtyard lamp
		draw_circle(Vector2(515.0, 210.0), 2.5, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.45))
		draw_circle(Vector2(515.0, 210.0), 14.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.08))
	else:
		# State 2: Solid brick/stucco wall with electrical service panel and rain downspout (Clean rationalization)
		draw_rect(Rect2(450.0, 70.0, 130.0, 226.0), Color("17222a"))
		draw_rect(Rect2(450.0, 70.0, 130.0, 226.0), COLOR_DARK_STEEL, false, 1.5)
		# Downspout pipe running from roof to floor
		draw_line(Vector2(480.0, 70.0), Vector2(480.0, 296.0), COLOR_INFRASTRUCTURE * 0.7, 3.0)
		# Wall service junction box
		draw_rect(Rect2(505.0, 210.0, 26.0, 34.0), Color("263742"))
		draw_rect(Rect2(505.0, 210.0, 26.0, 34.0), COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
		draw_circle(Vector2(518.0, 222.0), 2.0, COLOR_CYAN * 0.7)


func _draw_chamber_1_architecture() -> void:
	# ── 1. Commercial Storefront / Street Wall (x = 590..720, y = 50..296) ──
	draw_rect(Rect2(590.0, 50.0, 130.0, 246.0), Color("151e25"))
	draw_rect(Rect2(590.0, 50.0, 130.0, 246.0), COLOR_DARK_STEEL, false, 1.5)
	# Display window
	draw_rect(Rect2(605.0, 195.0, 100.0, 90.0), Color("0d1419"))
	draw_rect(Rect2(605.0, 195.0, 100.0, 90.0), COLOR_INFRASTRUCTURE * 0.5, false, 1.5)
	draw_line(Vector2(655.0, 195.0), Vector2(655.0, 285.0), Color("1c2830"), 1.0)
	
	# ── 2. Background Street Block (x = 730..940, y = 60..296) ──
	draw_rect(Rect2(730.0, 60.0, 210.0, 236.0), Color("141d24"))
	draw_rect(Rect2(730.0, 60.0, 210.0, 236.0), Color("1f2c36"), false, 1.5)
	for row in range(3):
		for col in range(4):
			var rx := 750.0 + float(col) * 48.0
			var ry := 85.0 + float(row) * 55.0
			draw_rect(Rect2(rx, ry, 26.0, 32.0), Color("0b1217"))
			draw_rect(Rect2(rx, ry, 26.0, 32.0), COLOR_DARK_STEEL * 0.6, false, 1.0)
	
	# ── 3. Transit Shelter Structure (Przystanek Linii Zastępczej) (x = 980..1150, y = 170..296) ──
	# Steel corner pillars
	draw_line(Vector2(990.0, 185.0), Vector2(990.0, 296.0), COLOR_INFRASTRUCTURE, 3.0)
	draw_line(Vector2(1140.0, 185.0), Vector2(1140.0, 296.0), COLOR_INFRASTRUCTURE, 3.0)
	draw_line(Vector2(1065.0, 185.0), Vector2(1065.0, 296.0), COLOR_INFRASTRUCTURE * 0.8, 2.0)
	
	# Corrugated curved shelter roof canopy
	var roof_pts := PackedVector2Array([
		Vector2(975.0, 188.0),
		Vector2(1065.0, 176.0),
		Vector2(1155.0, 188.0),
		Vector2(1155.0, 194.0),
		Vector2(1065.0, 182.0),
		Vector2(975.0, 194.0),
	])
	draw_polygon(roof_pts, [Color("283b47")])
	draw_polyline(roof_pts, COLOR_INFRASTRUCTURE, 1.2)
	
	# Tempered glass rear windbreak panels (x = 990..1140, y = 194..285)
	var glass_rect := Rect2(990.0, 194.0, 150.0, 91.0)
	draw_rect(glass_rect, Color(0.18, 0.26, 0.30, 0.35))
	draw_rect(glass_rect, COLOR_DARK_STEEL, false, 1.0)
	# Glass rain streaks
	draw_line(Vector2(1005.0, 200.0), Vector2(1025.0, 280.0), Color(1.0, 1.0, 1.0, 0.05), 1.5)
	draw_line(Vector2(1080.0, 200.0), Vector2(1100.0, 280.0), Color(1.0, 1.0, 1.0, 0.05), 1.5)
	
	# Wooden bench inside shelter (x = 1000..1130, y = 265..272)
	draw_rect(Rect2(1000.0, 265.0, 130.0, 7.0), Color("3d332a"))
	draw_rect(Rect2(1000.0, 265.0, 130.0, 7.0), Color("594c3e"), false, 1.0)
	# Bench legs
	draw_line(Vector2(1015.0, 272.0), Vector2(1015.0, 296.0), COLOR_DARK_STEEL, 2.0)
	draw_line(Vector2(1115.0, 272.0), Vector2(1115.0, 296.0), COLOR_DARK_STEEL, 2.0)
	
	# Shelter illuminated signboard: "RÓWIEŃ // PRZYSTANEK INSTYTUT"
	var shelter_sign := Rect2(1005.0, 184.0, 120.0, 9.0)
	draw_rect(shelter_sign, Color("101b22"))
	draw_rect(shelter_sign, COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	draw_line(Vector2(1010.0, 188.5), Vector2(1120.0, 188.5), Color("e8f0ec"), 1.0)
	
	# ── 4. Exit Transit Zone Platform (x = 1200..1280, y = 140..296) ──
	# Street kerb curb marking where bus stops
	draw_rect(Rect2(1200.0, 200.0, 80.0, 96.0), Color("121a20"))
	draw_rect(Rect2(1200.0, 200.0, 80.0, 96.0), COLOR_DARK_STEEL, false, 1.0)
	# Bus stop post (Znak D-15)
	draw_line(Vector2(1235.0, 180.0), Vector2(1235.0, 296.0), COLOR_DARK_STEEL, 2.5)
	# Blue stop plate
	draw_rect(Rect2(1226.0, 165.0, 18.0, 18.0), Color("1d3e54"))
	draw_rect(Rect2(1226.0, 165.0, 18.0, 18.0), COLOR_INFRASTRUCTURE, false, 1.0)
	# Bus symbol dot
	draw_rect(Rect2(1230.0, 170.0, 10.0, 8.0), Color("e6f2f8"))


func _draw_roadway_and_tracks() -> void:
	# ── 1. Asphalt Roadway Slab (y = 296..360 across LEVEL_WIDTH) ──
	draw_rect(Rect2(0.0, 296.0, LEVEL_WIDTH, 64.0), COLOR_ASPHALT)
	# Granite curb stone edge (y = 296..299)
	draw_rect(Rect2(0.0, 296.0, LEVEL_WIDTH, 3.0), COLOR_FLOOR_EDGE)
	
	# ── 2. Wet Asphalt Puddles & Reflections ──
	var puddles: Array[Rect2] = [
		Rect2(90.0, 310.0, 75.0, 12.0),
		Rect2(240.0, 316.0, 90.0, 14.0),
		Rect2(430.0, 308.0, 80.0, 10.0),
		Rect2(640.0, 314.0, 85.0, 15.0),
		Rect2(850.0, 312.0, 110.0, 16.0),
		Rect2(1040.0, 318.0, 95.0, 12.0),
	]
	for pud in puddles:
		draw_rect(pud, COLOR_PUDDLE)
		draw_line(Vector2(pud.position.x + 6.0, pud.position.y + 4.0), Vector2(pud.end.x - 6.0, pud.position.y + 4.0), Color(0.35, 0.45, 0.50, 0.25), 1.0)
	
	# ── 3. Embedded Tram Tracks (x = 740..850) ──
	# 2 pairs of steel grooved rails
	var rail_x: Array[float] = [750.0, 785.0, 815.0, 850.0]
	for rx in rail_x:
		# Steel rail profile
		draw_line(Vector2(rx, 296.0), Vector2(rx, 360.0), COLOR_RAIL, 2.5)
		# Rail groove shadow
		draw_line(Vector2(rx + 2.0, 296.0), Vector2(rx + 2.0, 360.0), Color("0d1318"), 1.0)
	
	# ── 4. Zebra Pedestrian Crossing Stripes (x = 730..860, y = 300..340) ──
	# Angled worn white crosswalk stripes
	for i in range(8):
		var sx := 732.0 + float(i) * 16.0
		var stripe_pts := PackedVector2Array([
			Vector2(sx, 302.0),
			Vector2(sx + 10.0, 302.0),
			Vector2(sx + 8.0, 338.0),
			Vector2(sx - 2.0, 338.0),
		])
		draw_polygon(stripe_pts, [Color(0.85, 0.90, 0.88, 0.30)])


func _draw_streetlamps_and_lighting() -> void:
	# Streetlamps at x = 230, 480, 710, 960, 1180
	var lamp_x: Array[float] = [230.0, 480.0, 710.0, 960.0, 1180.0]
	for lx in lamp_x:
		# Steel lighting pole (x = lx, y = 90..296)
		draw_line(Vector2(lx, 90.0), Vector2(lx, 296.0), COLOR_DARK_STEEL, 3.0)
		draw_line(Vector2(lx, 90.0), Vector2(lx, 296.0), COLOR_INFRASTRUCTURE * 0.6, 1.0)
		
		# Curved lamp arm extending out to the left
		var arm_pts := PackedVector2Array([
			Vector2(lx, 100.0),
			Vector2(lx - 12.0, 92.0),
			Vector2(lx - 20.0, 96.0),
		])
		draw_polyline(arm_pts, COLOR_DARK_STEEL, 2.5)
		
		# Luminaire housing
		draw_rect(Rect2(lx - 24.0, 94.0, 12.0, 6.0), Color("202e38"))
		draw_circle(Vector2(lx - 18.0, 98.0), 3.0, Color("f4eed6"))
		
		# Downward light cone illuminating rain and asphalt
		var cone_pts := PackedVector2Array([
			Vector2(lx - 22.0, 99.0),
			Vector2(lx - 14.0, 99.0),
			Vector2(lx + 55.0, 296.0),
			Vector2(lx - 90.0, 296.0),
		])
		draw_polygon(cone_pts, [Color(0.92, 0.90, 0.78, 0.035)])
		
		# Hot ground puddle reflection
		draw_ellipse(Vector2(lx - 18.0, 297.0), 40.0, 4.0, Color(0.92, 0.90, 0.78, 0.06))


func _draw_catenary_wires() -> void:
	# Overhead tram catenary power lines running across Chamber 1 (x = 640..1280, y = 75..110)
	# Catenary support poles at x = 680, 890, 1100
	var pole_x: Array[float] = [680.0, 890.0, 1100.0]
	for px in pole_x:
		# Steel lattice catenary mast
		draw_line(Vector2(px, 40.0), Vector2(px, 296.0), COLOR_DARK_STEEL, 3.5)
		# Horizontal cantilever bracket
		draw_line(Vector2(px, 70.0), Vector2(px + 60.0, 70.0), COLOR_INFRASTRUCTURE * 0.7, 2.0)
		draw_line(Vector2(px, 55.0), Vector2(px + 60.0, 70.0), Color("243642"), 1.2)
		# Insulator bell
		draw_circle(Vector2(px + 58.0, 70.0), 2.5, Color("344b59"))
	
	# Horizontal carrier & contact wire pair
	draw_line(Vector2(640.0, 70.0), Vector2(1280.0, 70.0), Color(0.25, 0.35, 0.40, 0.45), 1.0)
	draw_line(Vector2(640.0, 82.0), Vector2(1280.0, 82.0), Color(0.30, 0.40, 0.45, 0.55), 1.2)
	
	# Vertical droppers between wires
	for i in range(16):
		var dx := 650.0 + float(i) * 38.0
		draw_line(Vector2(dx, 70.0), Vector2(dx, 82.0), Color(0.25, 0.35, 0.40, 0.35), 1.0)
