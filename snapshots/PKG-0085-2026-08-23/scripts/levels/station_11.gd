class_name Station11
extends Node2D

## Station 11 (Przestrzeń 11: Pierwsza korekta / Dziedziniec za osiedlem i interwencja UCP) for Getting Strange Vertical Slice.
## Represents the elevated technical corridor with observation window overlooking the courtyard at dawn,
## and the ground-level courtyard where a UCP intervention team stabilizes an elderly resident and erases a doorway seam.
## Implements observation of UCP intervention (Clue R-03), dialogue with Marta Kurek, masonry smoothing,
## inspection of the erased doorway trace, and opening of the exit portal to Space 12.
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 11), and CONTINUITY_TRACKER.md (Clue R-03).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("182126") # Sea graphite
const COLOR_DAWN_SKY := Color("1a2a36")
const COLOR_MIST := Color(0.65, 0.78, 0.85, 0.18)
const COLOR_INFRASTRUCTURE := Color("a8b2ac") # Grey sage
const COLOR_AMBER := Color("d39a62") # Muted amber (Lena / Marta / Warmth)
const COLOR_CYAN := Color("75c7c3") # Cool cyan (Stabilizer field / Consensus)
const COLOR_CORRECTION := Color("c65d58") # Oxide cinnabar (Discontinuity / Fading seam)
const COLOR_DARK_STEEL := Color("263943")
const COLOR_BRICK := Color("38261e")
const COLOR_BRICK_DARK := Color("281b15")
const COLOR_CONCRETE := Color("2d3840")
const COLOR_CONCRETE_LIGHT := Color("3d4b54")

signal clue_inspected(id: String, prop_type: int)
signal observation_started()
signal ucp_intervention_triggered()
signal masonry_smoothed()
signal marta_dialogue_started()
signal marta_dialogue_advanced(line_idx: int)
signal marta_dialogue_completed()
signal courtyard_airlock_unlocked()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone

var window_inspected: bool = false
var ucp_team_inspected: bool = false
var resident_inspected: bool = false
var doorway_inspected: bool = false
var marta_inspected: bool = false
var airlock_inspected: bool = false

var is_intervention_active: bool = false
var is_intervention_completed: bool = false
var is_masonry_smoothed: bool = false
var is_airlock_unlocked: bool = false
var is_level_completed: bool = false

var marta_dialogue_active: bool = false
var marta_dialogue_index: int = -1
var is_marta_dialogue_completed: bool = false

var _door_open_progress: float = 0.0
var _smoothing_progress: float = 0.0
var _pulse_time: float = 0.0
var _step_timer: float = 0.0

# Observation & Dialogue lines for Space 11 (per FULL_STORY.md Scene 11 and NEXT_SESSION_PROMPT.md)
var observation_and_dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "KOBIETA (MIESZKANKA)",
		"text": "Tu było wejście do klatki B. Schody były z tej strony, pamiętam mosiężny próg.",
		"is_lena": false,
		"is_marta": false,
		"is_elderly": true,
		"is_ucp": false,
		"is_stage_direction": false
	},
	{
		"speaker": "OPERATOR UCP",
		"text": "Dziękujemy. Już sprawdziliśmy. Wejście jest dwadzieścia metrów dalej, przy numerze czwartym.",
		"is_lena": false,
		"is_marta": false,
		"is_elderly": false,
		"is_ucp": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Operator uruchamia stabilizator polowy. Cichy impuls rezonansu przepływa przez ceglany mur.",
		"is_lena": false,
		"is_marta": false,
		"is_elderly": false,
		"is_ucp": false,
		"is_stage_direction": true
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Obrys dawnego wejścia bezpowrotnie wygładza się w litą ścianę. Ani jednej szczeliny.",
		"is_lena": false,
		"is_marta": false,
		"is_elderly": false,
		"is_ucp": false,
		"is_stage_direction": true
	},
	{
		"speaker": "KOBIETA (MIESZKANKA)",
		"text": "Rzeczywiście... Przecież zawsze tam wchodziłam. Przepraszam za kłopot.",
		"is_lena": false,
		"is_marta": false,
		"is_elderly": true,
		"is_ucp": false,
		"is_stage_direction": false
	},
	{
		"speaker": "MARTA",
		"text": "Zgłosiłam ją, bo bałam się, że skończy jak te drzwi.",
		"is_lena": false,
		"is_marta": true,
		"is_elderly": false,
		"is_ucp": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Jak te drzwi?",
		"is_lena": true,
		"is_marta": false,
		"is_elderly": false,
		"is_ucp": false,
		"is_stage_direction": false
	},
	{
		"speaker": "MARTA",
		"text": "Że jeśli nikt jej nie poszuka, nikt nie zauważy, kiedy zniknie szew.",
		"is_lena": false,
		"is_marta": true,
		"is_elderly": false,
		"is_ucp": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "UCP jej nie skrzywdziło. Pomogli jej bezpiecznie trafić do domu.",
		"is_lena": true,
		"is_marta": false,
		"is_elderly": false,
		"is_ucp": false,
		"is_stage_direction": false
	},
	{
		"speaker": "MARTA",
		"text": "Uratowali ją. I wymazali jej wspomnienie. To nie to samo co krzywda, ale kosztuje tyle samo.",
		"is_lena": false,
		"is_marta": true,
		"is_elderly": false,
		"is_ucp": false,
		"is_stage_direction": false
	}
]

var _ambience_player: AudioStreamPlayer
var _stabilizer_player: AudioStreamPlayer
var _masonry_player: AudioStreamPlayer
var _blip_player: AudioStreamPlayer
var _door_player: AudioStreamPlayer


func _ready() -> void:
	_setup_audio_players()
	_connect_signals()
	_configure_camera()
	observation_started.emit()


func _setup_audio_players() -> void:
	_ambience_player = AudioStreamPlayer.new()
	_ambience_player.name = "AmbienceAudioPlayer"
	_ambience_player.stream = ProceduralAudio.create_morning_ambience_sound()
	_ambience_player.bus = &"Master"
	_ambience_player.volume_db = -6.0
	add_child(_ambience_player)
	_ambience_player.play()

	_stabilizer_player = AudioStreamPlayer.new()
	_stabilizer_player.name = "StabilizerAudioPlayer"
	_stabilizer_player.stream = ProceduralAudio.create_ucp_stabilizer_beam_sound()
	_stabilizer_player.bus = &"Master"
	add_child(_stabilizer_player)

	_masonry_player = AudioStreamPlayer.new()
	_masonry_player.name = "MasonryAudioPlayer"
	_masonry_player.stream = ProceduralAudio.create_masonry_smooth_sound()
	_masonry_player.bus = &"Master"
	add_child(_masonry_player)

	_blip_player = AudioStreamPlayer.new()
	_blip_player.name = "BlipAudioPlayer"
	_blip_player.bus = &"Master"
	add_child(_blip_player)

	_door_player = AudioStreamPlayer.new()
	_door_player.name = "DoorAudioPlayer"
	_door_player.stream = ProceduralAudio.create_apartment_door_sound()
	_door_player.bus = &"Master"
	add_child(_door_player)


func _connect_signals() -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint:
				child.resonance_triggered.connect(_on_prop_resonance)

	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_entered)


func _configure_camera() -> void:
	if camera:
		var bounds: Array[Rect2] = [
			Rect2(Vector2.ZERO, VIEW_SIZE)
		]
		camera.setup_chambers(bounds)
		camera.set_chamber(0, true)


func _process(delta: float) -> void:
	_pulse_time += delta

	# Footsteps on gallery/stairs/courtyard
	if player and player.is_on_floor() and absf(player.velocity.x) > 10.0:
		_step_timer += delta
		if _step_timer >= 0.30:
			_step_timer = 0.0
			if player.has_node("StepAudioPlayer"):
				var sp := player.get_node("StepAudioPlayer") as AudioStreamPlayer2D
				if sp:
					if player.global_position.x < 240.0 and player.global_position.y < 180.0:
						sp.stream = ProceduralAudio.create_footstep_metal_sound()
					else:
						sp.stream = ProceduralAudio.create_footstep_linoleum_sound()
					sp.pitch_scale = randf_range(0.95, 1.05)
					sp.play()

	# Masonry smoothing animation
	if is_masonry_smoothed and _smoothing_progress < 1.0:
		_smoothing_progress = minf(1.0, _smoothing_progress + delta * 0.8)
		queue_redraw()

	# Airlock door opening transition
	if is_airlock_unlocked and _door_open_progress < 1.0:
		_door_open_progress = minf(1.0, _door_open_progress + delta * 0.9)
		queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if marta_dialogue_active:
		if event.is_action_pressed(&"interact") or event.is_action_pressed(&"jump"):
			advance_marta_dialogue()
			get_viewport().set_input_as_handled()


func _on_prop_resonance(id: String, prop_type: int) -> void:
	clue_inspected.emit(id, prop_type)

	match prop_type:
		MemoryResonancePoint.PropType.OBSERVATION_WINDOW:
			window_inspected = true
			if not marta_dialogue_active and not is_marta_dialogue_completed:
				start_marta_dialogue()
		MemoryResonancePoint.PropType.UCP_INTERVENTION_TEAM:
			ucp_team_inspected = true
			if not is_intervention_active and not is_intervention_completed:
				trigger_intervention_procedure()
		MemoryResonancePoint.PropType.ELDERLY_RESIDENT_GUIDE:
			resident_inspected = true
			if not is_intervention_completed:
				trigger_intervention_procedure()
		MemoryResonancePoint.PropType.ERASED_DOORWAY_TRACE:
			doorway_inspected = true
			_check_unlock_conditions()
		MemoryResonancePoint.PropType.MARTA_OBSERVATION_DIALOGUE:
			marta_inspected = true
			if not marta_dialogue_active and not is_marta_dialogue_completed:
				start_marta_dialogue()
		MemoryResonancePoint.PropType.COURTYARD_EXIT_AIRLOCK:
			airlock_inspected = true

	queue_redraw()


func trigger_intervention_procedure() -> void:
	is_intervention_active = true
	ucp_intervention_triggered.emit()
	if _stabilizer_player:
		_stabilizer_player.play()

	# Smooth masonry seam
	is_masonry_smoothed = true
	masonry_smoothed.emit()
	if _masonry_player:
		_masonry_player.play()

	# Update ErasedDoorwayTrace prop state
	if props:
		var doorway_prop := props.get_node_or_null("ErasedDoorwayTrace") as MemoryResonancePoint
		if doorway_prop:
			doorway_prop.is_activated = true

	is_intervention_completed = true
	_check_unlock_conditions()
	queue_redraw()


func start_marta_dialogue() -> void:
	marta_dialogue_active = true
	marta_dialogue_index = 0
	marta_dialogue_started.emit()
	_play_line_audio(0)
	queue_redraw()


func advance_marta_dialogue() -> int:
	if not marta_dialogue_active:
		return -1

	marta_dialogue_index += 1

	# Line 2 trigger stabilizer sound & masonry smooth if not yet triggered
	if marta_dialogue_index == 2 and not is_masonry_smoothed:
		trigger_intervention_procedure()

	if marta_dialogue_index >= observation_and_dialogue_lines.size():
		marta_dialogue_active = false
		is_marta_dialogue_completed = true
		marta_dialogue_completed.emit()
		_check_unlock_conditions()
		queue_redraw()
		return -1

	marta_dialogue_advanced.emit(marta_dialogue_index)
	_play_line_audio(marta_dialogue_index)
	queue_redraw()
	return marta_dialogue_index


func _play_line_audio(idx: int) -> void:
	if idx < 0 or idx >= observation_and_dialogue_lines.size():
		return

	var line := observation_and_dialogue_lines[idx]
	if _blip_player:
		if line.get("is_marta", false):
			_blip_player.stream = ProceduralAudio.create_dialogue_marta_blip_sound()
			_blip_player.pitch_scale = randf_range(0.97, 1.03)
			_blip_player.play()
		elif line.get("is_lena", false):
			_blip_player.stream = ProceduralAudio.create_dialogue_blip_sound(true)
			_blip_player.pitch_scale = randf_range(0.98, 1.02)
			_blip_player.play()
		elif line.get("is_elderly", false):
			_blip_player.stream = ProceduralAudio.create_dialogue_elderly_woman_sound()
			_blip_player.pitch_scale = randf_range(0.96, 1.04)
			_blip_player.play()
		elif line.get("is_ucp", false):
			_blip_player.stream = ProceduralAudio.create_dialogue_blip_sound(false)
			_blip_player.pitch_scale = randf_range(0.95, 1.00)
			_blip_player.play()
		elif line.get("is_stage_direction", false):
			_blip_player.stream = ProceduralAudio.create_paper_rustle_sound()
			_blip_player.pitch_scale = 1.0
			_blip_player.play()


func _check_unlock_conditions() -> void:
	# Unlock courtyard exit airlock once dialogue / intervention is witnessed and doorway is smoothed
	if is_marta_dialogue_completed and is_masonry_smoothed and not is_airlock_unlocked:
		is_airlock_unlocked = true
		courtyard_airlock_unlocked.emit()
		if _door_player:
			_door_player.play()

		if props:
			var airlock_prop := props.get_node_or_null("CourtyardExitAirlock") as MemoryResonancePoint
			if airlock_prop:
				airlock_prop.is_activated = true

		queue_redraw()


func _on_airlock_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and not is_level_completed:
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	_draw_background_dawn()
	_draw_upper_gallery()
	_draw_stairs_and_courtyard()
	_draw_residential_facade()
	if marta_dialogue_active:
		_draw_dialogue_overlay()


func _draw_background_dawn() -> void:
	# Dawn sky gradient & atmospheric mist (#182126 sea graphite with #1a2a36 pale blue horizon)
	draw_rect(Rect2(0.0, 0.0, LEVEL_WIDTH, 360.0), COLOR_BACKGROUND)
	draw_rect(Rect2(0.0, 20.0, LEVEL_WIDTH, 280.0), COLOR_DAWN_SKY)

	# Pale morning light band along horizon (y = 120..220)
	var horizon_poly: PackedVector2Array = [
		Vector2(0.0, 120.0),
		Vector2(LEVEL_WIDTH, 120.0),
		Vector2(LEVEL_WIDTH, 220.0),
		Vector2(0.0, 220.0)
	]
	var dawn_glow := Color(0.35, 0.50, 0.60, 0.22)
	draw_colored_polygon(horizon_poly, dawn_glow)


func _draw_upper_gallery() -> void:
	# Upper Gallery & Corridor Walkway (x = 0..240, floor at y = 160)
	var gallery_wall := Rect2(0.0, 30.0, 240.0, 130.0)
	draw_rect(gallery_wall, Color("151f26"))

	# Structural steel girders and ceiling conduit
	draw_rect(Rect2(0.0, 30.0, 240.0, 14.0), Color("202c34"))
	draw_line(Vector2(0.0, 34.0), Vector2(240.0, 34.0), COLOR_INFRASTRUCTURE, 1.0)
	draw_line(Vector2(0.0, 40.0), Vector2(240.0, 40.0), COLOR_CYAN * 0.6, 1.0)

	# Gallery floor structure (Concrete with steel nosing)
	var floor_rect := Rect2(0.0, 160.0, 240.0, 20.0)
	draw_rect(floor_rect, COLOR_CONCRETE)
	draw_line(Vector2(0.0, 160.0), Vector2(240.0, 160.0), COLOR_CONCRETE_LIGHT, 1.5)

	# Safety Railing on gallery edge (x = 180..240, y = 125..160)
	draw_line(Vector2(180.0, 130.0), Vector2(240.0, 130.0), COLOR_INFRASTRUCTURE * 0.9, 2.0)
	draw_line(Vector2(180.0, 145.0), Vector2(240.0, 145.0), COLOR_INFRASTRUCTURE * 0.7, 1.2)
	for rx in range(185, 240, 18):
		draw_line(Vector2(float(rx), 130.0), Vector2(float(rx), 160.0), COLOR_INFRASTRUCTURE * 0.8, 1.5)


func _draw_stairs_and_courtyard() -> void:
	# Concrete Stairs descending from gallery (x = 240, y = 160) to courtyard (x = 340, y = 300)
	var steps: Array[Vector2] = [
		Vector2(240.0, 160.0),
		Vector2(260.0, 188.0),
		Vector2(280.0, 216.0),
		Vector2(300.0, 244.0),
		Vector2(320.0, 272.0),
		Vector2(340.0, 300.0)
	]
	for s in range(steps.size() - 1):
		var p_cur: Vector2 = steps[s]
		var p_next: Vector2 = steps[s + 1]
		# Horizontal tread
		draw_line(Vector2(p_cur.x, p_next.y), Vector2(p_next.x, p_next.y), COLOR_CONCRETE_LIGHT, 2.0)
		# Vertical riser
		draw_line(Vector2(p_cur.x, p_cur.y), Vector2(p_cur.x, p_next.y), Color("1e272e"), 2.0)
		# Solid masonry beneath stair
		var poly: PackedVector2Array = [
			Vector2(p_cur.x, p_next.y),
			Vector2(p_next.x, p_next.y),
			Vector2(p_next.x, 360.0),
			Vector2(p_cur.x, 360.0)
		]
		draw_colored_polygon(poly, Color("1a2329"))

	# Courtyard Ground Level (x = 240..640, floor at y = 300..360)
	var court_floor := Rect2(240.0, 300.0, 400.0, 60.0)
	draw_rect(court_floor, COLOR_CONCRETE)
	draw_line(Vector2(240.0, 300.0), Vector2(640.0, 300.0), COLOR_CONCRETE_LIGHT, 2.0)

	# Concrete paving slabs expansion joints (spacing 32 px)
	for px in range(256, 640, 32):
		draw_line(Vector2(float(px), 300.0), Vector2(float(px), 360.0), Color("1d262c"), 1.2)
		draw_line(Vector2(240.0, 325.0), Vector2(640.0, 325.0), Color("1d262c"), 1.0)


func _draw_residential_facade() -> void:
	# Residential building brick & concrete facade behind courtyard (x = 340..640, y = 40..300)
	var facade_rect := Rect2(340.0, 40.0, 300.0, 260.0)
	draw_rect(facade_rect, COLOR_BRICK)

	# Brick mortar courses
	for by in range(46, 300, 12):
		draw_line(Vector2(340.0, float(by)), Vector2(640.0, float(by)), COLOR_BRICK_DARK, 1.0)

	# Residential windows on upper floors of Osiedle Tarasowe
	for wx in [370.0, 450.0, 530.0]:
		for wy in [60.0, 120.0, 180.0]:
			var w_rect := Rect2(wx, wy, 45.0, 35.0)
			draw_rect(w_rect, Color("111b22"))
			draw_rect(w_rect, Color("2d3d48"), false, 1.5)
			draw_line(Vector2(wx + 22.5, wy), Vector2(wx + 22.5, wy + 35.0), Color("2d3d48"), 1.0)

	# Drainpipe along facade at x = 355
	draw_line(Vector2(355.0, 40.0), Vector2(355.0, 300.0), Color("22303a"), 3.0)
	draw_circle(Vector2(355.0, 100.0), 2.5, Color("3d505d"))
	draw_circle(Vector2(355.0, 200.0), 2.5, Color("3d505d"))

	# Smoothed Doorway Zone (x = 495..535, y = 250..300)
	var door_zone := Rect2(495.0, 250.0, 40.0, 50.0)
	if not is_masonry_smoothed:
		# Fading doorway seam with cinnabar tension trace (#geometry-restless-grid)
		var p := sin(_pulse_time * 2.5) * 0.5 + 0.5
		var seam_col := Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.4 + p * 0.4)
		draw_rect(door_zone, Color("2c1c15"))
		draw_rect(door_zone, seam_col, false, 1.5)
	else:
		# Uniform solid masonry perfectly restored with subtle cyan settling alignment
		draw_rect(door_zone, COLOR_BRICK)
		for by in range(256, 300, 12):
			draw_line(Vector2(495.0, float(by)), Vector2(535.0, float(by)), COLOR_BRICK_DARK, 1.0)
		var p_cyan := sin(_pulse_time * 1.5) * 0.25 + 0.25
		draw_line(Vector2(495.0, 300.0), Vector2(535.0, 300.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, p_cyan), 1.2)

	# Airlock Door Opening Light
	if is_airlock_unlocked:
		var light_alpha := _door_open_progress * 0.4
		var light_poly: PackedVector2Array = [
			Vector2(585.0, 240.0),
			Vector2(585.0, 300.0),
			Vector2(640.0, 300.0),
			Vector2(640.0, 220.0)
		]
		draw_colored_polygon(light_poly, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, light_alpha))


func _draw_dialogue_overlay() -> void:
	if marta_dialogue_index < 0 or marta_dialogue_index >= observation_and_dialogue_lines.size():
		return

	var line := observation_and_dialogue_lines[marta_dialogue_index]
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_lena: bool = line.get("is_lena", false)
	var is_marta: bool = line.get("is_marta", false)
	var is_elderly: bool = line.get("is_elderly", false)
	var is_ucp: bool = line.get("is_ucp", false)
	var is_stage: bool = line.get("is_stage_direction", false)

	# Dialogue box in top center (x=110..530, y=24..76)
	var box_rect := Rect2(110.0, 24.0, 420.0, 52.0)
	draw_rect(box_rect, Color(0.08, 0.12, 0.15, 0.92))

	# Frame border color
	var frame_col := COLOR_AMBER if (is_lena or is_marta) else (COLOR_CYAN if is_ucp else (COLOR_CORRECTION if is_elderly else COLOR_INFRASTRUCTURE))
	draw_rect(box_rect, frame_col, false, 1.2)

	# Speaker accent bar on left
	draw_rect(Rect2(110.0, 24.0, 4.0, 52.0), frame_col)

	var font := ThemeDB.fallback_font
	if font:
		var speaker_col := COLOR_AMBER if is_lena else (Color("c9a638") if is_marta else (COLOR_CYAN if is_ucp else (Color("d8a287") if is_elderly else COLOR_INFRASTRUCTURE)))
		draw_string(font, Vector2(122.0, 40.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, speaker_col)

		var col_text := Color("ffffff") if not is_stage else COLOR_CYAN * 0.95
		draw_string(font, Vector2(122.0, 58.0), text, HORIZONTAL_ALIGNMENT_LEFT, 390, 11, col_text)

		# Advance hint [E] on bottom right
		var hint_pulse := sin(_pulse_time * 3.5) * 0.5 + 0.5
		var hint_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.4 + hint_pulse * 0.5)
		draw_string(font, Vector2(495.0, 68.0), "[E]", HORIZONTAL_ALIGNMENT_RIGHT, -1, 9, hint_col)

	# Dialogue pulse progress line indicator at bottom of box
	draw_line(Vector2(120.0, 74.0), Vector2(120.0 + 380.0 * (float(marta_dialogue_index + 1) / float(observation_and_dialogue_lines.size())), 74.0), frame_col, 1.5)
