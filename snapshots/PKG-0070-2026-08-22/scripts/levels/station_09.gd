class_name Station09
extends Node2D

## Station 09 (Przestrzeń 09: Pokój, który nie czeka / Łazienka i lustro) for Getting Strange Vertical Slice.
## Represents the bathroom and connecting inner corridor of apartment 14 at Osiedle Tarasowe.
## Implements observation-dependent geometry (#motionviz-observed-discontinuity),
## asynchronous / delayed mirror reflection, oblique angle discovery of Clue R-02
## ("NIE SZUKAJ ORYGINAŁU"), dialogue D-03 with Marta Kurek ("Zostaw drzwi w odbiciu. Idź, nie sprawdzaj."),
## and doorway stabilization leading to Przestrzeń 10 (Telefon Jakuba).
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 09), CONTINUITY_TRACKER.md (R-02), and DIALOGUE_SCRIPT.md.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("182126") # Sea graphite
const COLOR_NIGHT_SKY := Color("0a1117")
const COLOR_INFRASTRUCTURE := Color("a8b2ac") # Grey sage
const COLOR_AMBER := Color("d39a62") # Muted amber (Lena / Marta / domestic warmth)
const COLOR_CYAN := Color("75c7c3") # Cool cyan (Anchor / Inscription / Glass reflection)
const COLOR_CORRECTION := Color("c65d58") # Oxide cinnabar (Correction / Instability)
const COLOR_DARK_STEEL := Color("263943")
const COLOR_TILE_DARK := Color("1a262e")
const COLOR_TILE_LIGHT := Color("243642")
const COLOR_TILE_GROUT := Color("2f4553")
const COLOR_FLOOR_TILE := Color("17222a")
const COLOR_FLOOR_GROUT := Color("283944")

signal clue_inspected(id: String, prop_type: int)
signal marta_dialogue_started()
signal marta_dialogue_advanced(line_idx: int)
signal marta_dialogue_completed()
signal mirror_oblique_revealed()
signal corridor_stabilized()
signal exit_door_unlocked()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone

var sink_inspected: bool = false
var mirror_inspected: bool = false
var inscription_revealed: bool = false
var apothecary_inspected: bool = false
var marta_guide_inspected: bool = false

var is_oblique_angle: bool = false
var is_looking_at_mirror: bool = false
var is_corridor_stabilized: bool = false
var is_door_unlocked: bool = false
var is_level_completed: bool = false

var marta_dialogue_active: bool = false
var marta_dialogue_index: int = -1
var is_marta_dialogue_completed: bool = false

var corridor_progress: float = 0.0
var _pulse_time: float = 0.0
var _door_open_progress: float = 0.0
var _step_timer: float = 0.0

# Delayed reflection history buffer (records player state from ~14 frames ago)
var player_history: Array[Dictionary] = []
const DELAY_FRAMES: int = 14

# Dialogue lines for Space 09 (D-03 per FULL_STORY 09 & DIALOGUE_SCRIPT.md)
var marta_dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "MARTA",
		"text": "Nie patrz na drzwi. Patrz na nie w lustrze.",
		"is_lena": false,
		"is_marta": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Odbicie jest opóźnione.",
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "MARTA",
		"text": "Wiem.",
		"is_lena": false,
		"is_marta": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Ile?",
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "MARTA",
		"text": "Tyle, żebyś zdążyła się przestraszyć. Za mało, żebyś zdążyła to zmierzyć.",
		"is_lena": false,
		"is_marta": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Zmierzę po przejściu.",
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "MARTA",
		"text": "Ona też tak powiedziała.",
		"is_lena": false,
		"is_marta": true,
		"is_stage_direction": false
	}
]

var _pipe_player: AudioStreamPlayer
var _scratch_player: AudioStreamPlayer
var _shimmer_player: AudioStreamPlayer
var _door_player: AudioStreamPlayer
var _blip_player: AudioStreamPlayer
var _step_player: AudioStreamPlayer
var _transition_player: AudioStreamPlayer

var _blip_lena_sfx: AudioStreamWAV
var _blip_marta_sfx: AudioStreamWAV
var _tile_footstep_sfx: AudioStreamWAV


func _ready() -> void:
	_setup_camera()
	_setup_audio()
	_setup_props()
	_setup_airlock()
	
	if player:
		player.position = Vector2(80.0, 296.0)


func _setup_audio() -> void:
	_blip_lena_sfx = ProceduralAudio.create_dialogue_blip_sound(true)
	_blip_marta_sfx = ProceduralAudio.create_dialogue_marta_blip_sound()
	_tile_footstep_sfx = ProceduralAudio.create_tile_footstep_sound()
	
	_pipe_player = AudioStreamPlayer.new()
	_pipe_player.stream = ProceduralAudio.create_water_pipe_hiss_sound()
	_pipe_player.volume_db = -10.0
	_pipe_player.bus = &"Master"
	add_child(_pipe_player)
	
	_scratch_player = AudioStreamPlayer.new()
	_scratch_player.stream = ProceduralAudio.create_glass_scratch_sound()
	_scratch_player.volume_db = -4.0
	_scratch_player.bus = &"Master"
	add_child(_scratch_player)
	
	_shimmer_player = AudioStreamPlayer.new()
	_shimmer_player.stream = ProceduralAudio.create_mirror_shimmer_sound()
	_shimmer_player.volume_db = -8.0
	_shimmer_player.bus = &"Master"
	add_child(_shimmer_player)
	
	_door_player = AudioStreamPlayer.new()
	_door_player.stream = ProceduralAudio.create_apartment_door_sound()
	_door_player.volume_db = -4.0
	_door_player.bus = &"Master"
	add_child(_door_player)
	
	_blip_player = AudioStreamPlayer.new()
	_blip_player.bus = &"Master"
	_blip_player.volume_db = -3.0
	add_child(_blip_player)
	
	_step_player = AudioStreamPlayer.new()
	_step_player.stream = _tile_footstep_sfx
	_step_player.bus = &"Master"
	_step_player.volume_db = -12.0
	add_child(_step_player)
	
	_transition_player = AudioStreamPlayer.new()
	_transition_player.stream = ProceduralAudio.create_airlock_seal_sound()
	_transition_player.volume_db = -5.0
	_transition_player.bus = &"Master"
	add_child(_transition_player)


func _setup_camera() -> void:
	if not is_instance_valid(camera):
		camera = CinematicCamera.new()
		camera.name = "Camera"
		add_child(camera)
	
	camera.target = player
	var bounds: Array[Rect2] = [
		Rect2(Vector2(0.0, 0.0), VIEW_SIZE),
	]
	camera.setup_chambers(bounds)
	camera.set_chamber(0, true)


func _setup_props() -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint:
				child.resonance_triggered.connect(_on_prop_resonance_triggered)


func _setup_airlock() -> void:
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_body_entered)


func _physics_process(delta: float) -> void:
	_pulse_time += delta
	
	if player:
		# Maintain delayed reflection history buffer
		var is_facing_left := player.velocity.x < -1.0 or (is_looking_at_mirror and player.velocity.x <= 1.0)
		player_history.push_back({
			"pos": player.global_position,
			"facing_left": is_facing_left,
			"vel": player.velocity,
			"on_floor": player.is_on_floor()
		})
		if player_history.size() > DELAY_FRAMES + 20:
			player_history.pop_front()
		
		# Check player position & gaze relative to mirror at x=170
		var px := player.global_position.x
		is_looking_at_mirror = (px > 170.0 and player.velocity.x < 0.0) or (px >= 150.0 and px <= 200.0)
		
		# Oblique angle check (standing at x=210..290 looking back left towards mirror at x=170)
		is_oblique_angle = (px >= 210.0 and px <= 290.0 and (player.velocity.x <= 0.0 or is_looking_at_mirror))
		
		if is_oblique_angle and not inscription_revealed:
			reveal_inscription()
		
		# Tile footstep audio
		if player.is_on_floor() and absf(player.velocity.x) > 20.0:
			_step_timer += delta
			if _step_timer >= 0.32:
				_step_timer = 0.0
				if _step_player:
					_step_player.pitch_scale = randf_range(0.95, 1.05)
					_step_player.play()
		else:
			_step_timer = 0.20
		
		# Corridor observation progression:
		# After dialogue D-03 and revealing inscription, steady traversal to right unlocks the door
		if inscription_revealed:
			if px >= 340.0:
				var dist_factor: float = clampf((px - 340.0) / 200.0, 0.0, 1.0)
				corridor_progress = maxf(corridor_progress, dist_factor)
				
				if corridor_progress >= 0.95 and not is_corridor_stabilized:
					stabilize_corridor()
	
	if is_door_unlocked and _door_open_progress < 1.0:
		_door_open_progress = minf(1.0, _door_open_progress + delta * 2.0)
	
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if marta_dialogue_active and event.is_action_pressed(&"interact"):
		advance_marta_dialogue()
		get_viewport().set_input_as_handled()


func _on_prop_resonance_triggered(id: String, prop_type: int) -> void:
	clue_inspected.emit(id, prop_type)
	
	match prop_type:
		MemoryResonancePoint.PropType.BATHROOM_SINK:
			sink_inspected = true
			if _pipe_player and not _pipe_player.playing:
				_pipe_player.play()
		MemoryResonancePoint.PropType.BATHROOM_MIRROR:
			mirror_inspected = true
			if _shimmer_player and not _shimmer_player.playing:
				_shimmer_player.play()
			if not is_marta_dialogue_completed and not marta_dialogue_active:
				start_marta_dialogue()
		MemoryResonancePoint.PropType.SCRATCHED_INSCRIPTION:
			if not inscription_revealed:
				reveal_inscription()
		MemoryResonancePoint.PropType.APOTHECARY_CABINET:
			apothecary_inspected = true
		MemoryResonancePoint.PropType.MARTA_BATHROOM_GUIDE:
			marta_guide_inspected = true
			if not is_marta_dialogue_completed and not marta_dialogue_active:
				start_marta_dialogue()


func reveal_inscription() -> void:
	if inscription_revealed:
		return
	
	inscription_revealed = true
	if _scratch_player:
		_scratch_player.play()
	
	var p := props.get_node_or_null("ScratchedInscription") as MemoryResonancePoint
	if p:
		p.is_activated = true
	
	mirror_oblique_revealed.emit()
	clue_inspected.emit("ScratchedInscription", int(MemoryResonancePoint.PropType.SCRATCHED_INSCRIPTION))
	
	if not is_marta_dialogue_completed and not marta_dialogue_active:
		start_marta_dialogue()


func stabilize_corridor() -> void:
	if is_corridor_stabilized:
		return
	
	is_corridor_stabilized = true
	corridor_stabilized.emit()
	unlock_exit_door()


func unlock_exit_door() -> void:
	if is_door_unlocked:
		return
	
	is_door_unlocked = true
	if _door_player:
		_door_player.play()
	exit_door_unlocked.emit()


func start_marta_dialogue() -> void:
	marta_dialogue_active = true
	marta_dialogue_index = 0
	marta_dialogue_started.emit()
	_play_dialogue_blip(marta_dialogue_lines[0])


func advance_marta_dialogue() -> int:
	if not marta_dialogue_active:
		return -1
	
	marta_dialogue_index += 1
	if marta_dialogue_index < marta_dialogue_lines.size():
		var line_info: Dictionary = marta_dialogue_lines[marta_dialogue_index]
		_play_dialogue_blip(line_info)
		marta_dialogue_advanced.emit(marta_dialogue_index)
		return marta_dialogue_index
	else:
		marta_dialogue_active = false
		is_marta_dialogue_completed = true
		marta_dialogue_completed.emit()
		return -1


func _play_dialogue_blip(line_info: Dictionary) -> void:
	if _blip_player == null:
		return
	
	if line_info.get("is_stage_direction", false):
		return
	
	if line_info.get("is_lena", false):
		_blip_player.stream = _blip_lena_sfx
	else:
		_blip_player.stream = _blip_marta_sfx
	
	_blip_player.pitch_scale = randf_range(0.96, 1.04)
	_blip_player.play()


func _on_airlock_body_entered(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		if not is_level_completed and is_door_unlocked:
			is_level_completed = true
			if _transition_player:
				_transition_player.play()
			level_completed.emit()


func _draw() -> void:
	_draw_bathroom_environment()
	_draw_delayed_reflection()
	_draw_corridor_and_door()
	_draw_dialogue_ui()


func _draw_bathroom_environment() -> void:
	# 1. Background wall plaster (Sea graphite base #182126)
	draw_rect(Rect2(0.0, 0.0, LEVEL_WIDTH, 360.0), COLOR_BACKGROUND)
	
	# 2. Geometric ceramic tile wall grid (x=0..320, y=70..310)
	var tile_w := 20.0
	var tile_h := 20.0
	for ty in range(70, 310, int(tile_h)):
		for tx in range(0, 320, int(tile_w)):
			var is_even := (int(tx / tile_w) + int(ty / tile_h)) % 2 == 0
			var tile_col := COLOR_TILE_DARK if is_even else COLOR_TILE_LIGHT
			var t_rect := Rect2(float(tx), float(ty), tile_w, tile_h)
			draw_rect(t_rect, tile_col)
			draw_rect(t_rect, COLOR_TILE_GROUT, false, 0.6)
	
	# Decorative horizontal ceramic border stripe (y=160..166)
	draw_rect(Rect2(0.0, 160.0, 320.0, 6.0), Color("1e3d45"))
	draw_line(Vector2(0.0, 160.0), Vector2(320.0, 160.0), COLOR_CYAN * 0.5, 0.8)
	draw_line(Vector2(0.0, 166.0), Vector2(320.0, 166.0), COLOR_CYAN * 0.5, 0.8)
	
	# 3. Tiled Floor (y=310..360) with wet sheen
	draw_rect(Rect2(0.0, 310.0, LEVEL_WIDTH, 50.0), COLOR_FLOOR_TILE)
	for fx in range(0, int(LEVEL_WIDTH), 24):
		var x_pos := float(fx)
		draw_line(Vector2(x_pos, 310.0), Vector2(x_pos, 360.0), COLOR_FLOOR_GROUT, 0.8)
		draw_line(Vector2(x_pos, 325.0), Vector2(x_pos + 24.0, 325.0), COLOR_FLOOR_GROUT, 0.6)
		draw_line(Vector2(x_pos, 342.0), Vector2(x_pos + 24.0, 342.0), COLOR_FLOOR_GROUT, 0.6)
	
	# Stainless floor drain grate (x=170, y=322)
	draw_rect(Rect2(162.0, 318.0, 16.0, 8.0), Color("12191f"))
	draw_rect(Rect2(162.0, 318.0, 16.0, 8.0), COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	for i in range(4):
		draw_line(Vector2(164.0 + float(i) * 3.5, 320.0), Vector2(164.0 + float(i) * 3.5, 324.0), Color("0a1014"), 1.0)
	
	# Baseboard trim
	draw_rect(Rect2(0.0, 308.0, LEVEL_WIDTH, 3.0), Color("12191f"))
	
	# 4. Exposed Plumbing & Pipe Risers (Left wall, x=24..40)
	# Cast iron main riser pipe
	draw_rect(Rect2(28.0, 20.0, 8.0, 290.0), Color("222f38"))
	draw_rect(Rect2(28.0, 20.0, 8.0, 290.0), COLOR_DARK_STEEL, false, 1.0)
	# Flanged pipe joints with hex bolts
	for py in [60.0, 140.0, 220.0, 290.0]:
		draw_rect(Rect2(26.0, py, 12.0, 6.0), Color("2e3f4a"))
		draw_circle(Vector2(27.5, py + 3.0), 1.0, COLOR_INFRASTRUCTURE)
		draw_circle(Vector2(36.5, py + 3.0), 1.0, COLOR_INFRASTRUCTURE)
	
	# Chrome horizontal branches feeding sink
	draw_line(Vector2(36.0, 245.0), Vector2(170.0, 245.0), COLOR_INFRASTRUCTURE, 2.0)
	draw_line(Vector2(36.0, 255.0), Vector2(170.0, 255.0), COLOR_INFRASTRUCTURE, 2.0)
	# Brass pressure gauge on pipe riser (x=32, y=100)
	draw_circle(Vector2(32.0, 100.0), 5.5, Color("8f6f32"))
	draw_circle(Vector2(32.0, 100.0), 4.5, Color("dcd8cd"))
	draw_line(Vector2(32.0, 100.0), Vector2(34.0, 98.0), Color("a6382b"), 1.0) # Gauge needle
	
	# 5. Laundry Hamper & Towel Rail (x=80..115)
	# Stainless towel bar
	draw_line(Vector2(75.0, 210.0), Vector2(115.0, 210.0), COLOR_INFRASTRUCTURE, 2.0)
	# Muted sage/amber folded towel hanging
	draw_rect(Rect2(82.0, 212.0, 24.0, 36.0), Color("3d4e48"))
	draw_rect(Rect2(82.0, 212.0, 24.0, 36.0), Color("586d65"), false, 0.8)
	# Woven laundry basket beneath (x=78..112, y=268..310)
	draw_rect(Rect2(78.0, 268.0, 34.0, 42.0), Color("2c2016"))
	draw_rect(Rect2(78.0, 268.0, 34.0, 42.0), Color("453224"), false, 1.0)
	for ly in range(272, 310, 6):
		draw_line(Vector2(78.0, float(ly)), Vector2(112.0, float(ly)), Color("453224"), 0.8)
	
	# 6. Overhead Bathroom Lamp (x=170, y=55)
	draw_rect(Rect2(158.0, 48.0, 24.0, 10.0), Color("202a30"))
	draw_rect(Rect2(160.0, 56.0, 20.0, 5.0), Color("dcd8cd")) # Opal glass diffuser
	# Warm amber light cone casting down onto mirror and sink
	var cone_points := PackedVector2Array([
		Vector2(170.0, 61.0),
		Vector2(110.0, 310.0),
		Vector2(230.0, 310.0)
	])
	var lamp_pulse := sin(_pulse_time * 2.0) * 0.04 + 0.16
	draw_colored_polygon(cone_points, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, lamp_pulse))


func _draw_delayed_reflection() -> void:
	# Visualizes the temporal lag / asynchronous mirror reflection (#motionviz-observed-discontinuity)
	var mirror_x := 170.0
	var mirror_y := 205.0
	
	# Delayed player silhouette from buffer
	if player_history.size() >= DELAY_FRAMES:
		var delayed_state: Dictionary = player_history[player_history.size() - DELAY_FRAMES]
		var delayed_pos: Vector2 = delayed_state.get("pos", Vector2.ZERO)
		var is_fl: bool = delayed_state.get("facing_left", true)
		
		# Map delayed player X position to reflection pane X offset (mirror pane: x=154..186)
		# Relative distance from mirror determines reflection position and size
		var rel_x := delayed_pos.x - mirror_x
		if rel_x >= -40.0 and rel_x <= 160.0:
			var ref_x := mirror_x - rel_x * 0.12
			var ref_y := mirror_y + 4.0
			
			var ref_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.35)
			# Reflected head
			draw_circle(Vector2(ref_x, ref_y - 12.0), 3.5, ref_col)
			# Reflected coat torso
			draw_rect(Rect2(ref_x - 3.5, ref_y - 8.0, 7.0, 14.0), ref_col)
			# Coat flap asymmetry
			var flap_x := ref_x + (3.0 if is_fl else -3.0)
			draw_line(Vector2(ref_x, ref_y - 2.0), Vector2(flap_x, ref_y + 6.0), ref_col, 1.2)
			
			# Cyan reflection phase dissonance shimmer
			if is_looking_at_mirror:
				var shimmer_alpha := (sin(_pulse_time * 4.0) * 0.5 + 0.5) * 0.22
				draw_rect(Rect2(156.0, 187.0, 28.0, 36.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, shimmer_alpha))


func _draw_corridor_and_door() -> void:
	# Corridor transition (x=320..640)
	# Wall plaster in corridor (dark teal / sea graphite)
	draw_rect(Rect2(320.0, 0.0, 320.0, 310.0), Color("151e24"))
	
	# Corridor ceiling lighting strip (y=40..46)
	draw_rect(Rect2(340.0, 42.0, 260.0, 4.0), Color("202a30"))
	draw_rect(Rect2(360.0, 46.0, 60.0, 2.0), Color("dcd8cd") * 0.8)
	draw_rect(Rect2(480.0, 46.0, 60.0, 2.0), Color("dcd8cd") * 0.8)
	
	# Corridor perspective lines (restless grid indication)
	var corr_color := COLOR_INFRASTRUCTURE * 0.35
	if not is_corridor_stabilized and player and player.global_position.x > 320.0:
		# Slight cinnabar tension ripple when corridor is unstable
		var ripple := sin(_pulse_time * 5.0) * 0.5 + 0.5
		corr_color = lerp(corr_color, COLOR_CORRECTION * 0.5, ripple * 0.6)
	
	draw_line(Vector2(320.0, 70.0), Vector2(640.0, 70.0), corr_color, 1.0)
	draw_line(Vector2(320.0, 190.0), Vector2(640.0, 190.0), corr_color, 0.8)
	
	# Exit doorway at right end (x=575..625, y=140..310)
	var door_frame_rect := Rect2(575.0, 138.0, 50.0, 172.0)
	draw_rect(door_frame_rect, Color("11181e"))
	draw_rect(door_frame_rect, COLOR_INFRASTRUCTURE * 0.7, false, 1.2)
	
	if is_door_unlocked:
		# Door unlatched / opening with warm amber light spilling from Space 10
		var open_w := 46.0 * _door_open_progress
		var door_rect := Rect2(577.0, 140.0, 46.0 - open_w, 170.0)
		draw_rect(door_rect, Color("2a1f16")) # Wooden door leaf moving
		
		# Amber light spill through door gap
		var spill_rect := Rect2(577.0 + (46.0 - open_w), 140.0, open_w, 170.0)
		draw_rect(spill_rect, Color("d39a62"))
		draw_rect(spill_rect, Color("ffe4b5") * 0.9)
		
		# Floor light trapezoid spill
		var floor_cone := PackedVector2Array([
			Vector2(577.0 + (46.0 - open_w), 310.0),
			Vector2(640.0, 310.0),
			Vector2(640.0, 345.0),
			Vector2(520.0, 345.0)
		])
		draw_colored_polygon(floor_cone, Color(0.827, 0.604, 0.384, 0.28 * _door_open_progress))
	else:
		# Closed and locked door
		var door_rect := Rect2(577.0, 140.0, 46.0, 170.0)
		draw_rect(door_rect, Color("241b14"))
		draw_rect(door_rect, Color("3d2c1e"), false, 1.0)
		# Brass door handle & deadbolt lock
		draw_rect(Rect2(583.0, 222.0, 6.0, 12.0), Color("8f6f32"))
		draw_circle(Vector2(586.0, 225.0), 1.5, Color("cda35d"))
		draw_line(Vector2(586.0, 225.0), Vector2(580.0, 225.0), Color("cda35d"), 1.8) # Handle lever


func _draw_dialogue_ui() -> void:
	if not marta_dialogue_active or marta_dialogue_index < 0 or marta_dialogue_index >= marta_dialogue_lines.size():
		return
	
	var line_info: Dictionary = marta_dialogue_lines[marta_dialogue_index]
	var speaker: String = line_info.get("speaker", "")
	var text: String = line_info.get("text", "")
	var is_lena: bool = line_info.get("is_lena", false)
	var is_stage_direction: bool = line_info.get("is_stage_direction", false)
	
	# Minimalist in-world dialogue banner (x=110..530, y=24..72)
	var box_rect := Rect2(110.0, 24.0, 420.0, 48.0)
	draw_rect(box_rect, Color(0.08, 0.12, 0.15, 0.92))
	
	var border_col := COLOR_AMBER if is_lena else (Color("dcd8cd") if not is_stage_direction else COLOR_CYAN)
	draw_rect(box_rect, border_col * 0.8, false, 1.2)
	
	# Speaker accent bar on left
	draw_rect(Rect2(110.0, 24.0, 4.0, 48.0), border_col)
	
	# Speaker label
	var font := ThemeDB.fallback_font
	if font:
		var speaker_col := COLOR_AMBER if is_lena else (COLOR_CYAN if is_stage_direction else Color("dcd8cd"))
		draw_string(font, Vector2(122.0, 40.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, speaker_col)
		
		var text_col := Color("ffffff") if not is_stage_direction else COLOR_CYAN * 0.95
		draw_string(font, Vector2(122.0, 58.0), text, HORIZONTAL_ALIGNMENT_LEFT, 390, 11, text_col)
		
		# Advance hint [E] on bottom right
		var hint_pulse := sin(_pulse_time * 3.5) * 0.5 + 0.5
		var hint_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.4 + hint_pulse * 0.5)
		draw_string(font, Vector2(495.0, 64.0), "[E]", HORIZONTAL_ALIGNMENT_RIGHT, -1, 9, hint_col)
