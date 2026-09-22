class_name Station08
extends Node2D

## Station 08 (Przestrzeń 08: Mieszkanie po kimś / Wnętrze mieszkania Marty i lokalnej Leny) for Getting Strange Vertical Slice.
## Represents the interior of apartment 14 at Osiedle Tarasowe.
## Implements the exploration of the unfamiliar domestic life of local Lena,
## full dialogue interaction with Marta Kurek, examination of dual-purpose items
## (beaker succulent planter, Jakub's brass memento, reflected photograph),
## unlocking of the cipher desk drawer revealing the UCP Substructure drafts,
## and transition through the inner hallway to Przestrzeń 09 (Pokój, który nie czeka).
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 08), CONTINUITY_TRACKER.md (R-01/R-02), and DIALOGUE_SCRIPT.md.

## PRZESZKODA — dlaczego to tu jest: Szafka kartotekowa zablokowała jedyny korytarz, bo ciężar mebla przesunął się razem z mieszkaniem.
## PRZESZKODA — czego wymaga od Leny: odepchnięcia ciężkiej szafki do wnęki i zostawienia przejścia dla następnej osoby.
## PRZESZKODA — koszt porażki: korekta przywraca szafkę na wejście, a jeden szczegół mieszkania traci ostrość.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("182126") # Sea graphite
const COLOR_NIGHT_SKY := Color("0a1117")
const COLOR_INFRASTRUCTURE := Color("a8b2ac") # Grey sage
const COLOR_AMBER := Color("d39a62") # Muted amber (Lena / Marta / domestic warmth)
const COLOR_CYAN := Color("75c7c3") # Cool cyan (Anchor / Substructure blueprint)
const COLOR_CORRECTION := Color("c65d58") # Oxide cinnabar
const COLOR_DARK_STEEL := Color("263943")
const COLOR_PARQUET := Color("3d2b1f")
const COLOR_PARQUET_LIGHT := Color("543b2c")
const COLOR_WALL_PLASTER := Color("24313a")
const COLOR_WALL_DADO := Color("1a242c")
const COLOR_FURNITURE_TEAK := Color("453224")
const COLOR_FURNITURE_DARK := Color("281d15")

signal clue_inspected(id: String, prop_type: int)
signal marta_dialogue_started()
signal marta_dialogue_advanced(line_idx: int)
signal marta_dialogue_completed()
signal cipher_drawer_unlocked()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var hallway_sideboard: MovableAnchorableProp = $Geometry/HallwaySideboard

var coat_rack_inspected: bool = false
var reflected_photo_inspected: bool = false
var beaker_planter_inspected: bool = false
var jakub_memento_inspected: bool = false
var tea_kettle_inspected: bool = false
var cipher_drawer_unlocked_state: bool = false

var marta_dialogue_active: bool = false
var marta_dialogue_index: int = -1
var is_marta_dialogue_completed: bool = false

var drawer_unlock_progress: float = 0.0
var is_level_completed: bool = false
var sideboard_repositioned: bool = false
var sideboard_correction_count: int = 0
var sideboard_detail_faded: bool = false
var _pulse_time: float = 0.0

# Dialogue lines for Space 08 per FULL_STORY 08 & DIALOGUE_SCRIPT.md
var marta_dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "LENA",
		"text": "To nie moje rzeczy... Płaszcz, klucze, pamiątka Jakuba.",
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "MARTA",
		"text": "Wiem. Twoja Lena nie stawiała pytań przed wejściem. Zostawiła kubek z ziemią i wyszła.",
		"is_lena": false,
		"is_marta": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Szuflada biurka ma zamek szyfrowy. Nie znam kodu.",
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "MARTA",
		"text": "Znasz. Każda wersja ciebie go zna. Pamięć rąk jest starsza niż decyzje UCP. Zawsze 0311.",
		"is_lena": false,
		"is_marta": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO CIAŁA",
		"text": "Lena odruchowo obraca bębenki zamka. Mechanizm ustępuje z cichym klikiem.",
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Obce pismo... ale wzory są moje. Siatka korelacji. Szkic węzłów Podstruktury.",
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "MARTA",
		"text": "Ona nie uciekała przed systemem, Lena. Ona go budowała. Zanim zrozumiała, co ten system wycina.",
		"is_lena": false,
		"is_marta": true,
		"is_stage_direction": false
	},
	{
		"speaker": "MARTA",
		"text": "Herbata paruje na stole. Jeśli musisz przemyć twarz, łazienka jest na końcu korytarza. Pamiętaj: patrz w lustro.",
		"is_lena": false,
		"is_marta": true,
		"is_stage_direction": false
	}
]

var _kettle_player: AudioStreamPlayer
var _drawer_player: AudioStreamPlayer
var _blip_player: AudioStreamPlayer
var _transition_player: AudioStreamPlayer

var _kettle_boil_sfx: AudioStreamWAV
var _drawer_unlatch_sfx: AudioStreamWAV
var _blip_lena_sfx: AudioStreamWAV
var _blip_marta_sfx: AudioStreamWAV
var _transition_sfx: AudioStreamWAV


func _ready() -> void:
	_setup_camera()
	_setup_audio()
	_connect_props()
	
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	
	# Initial player spawn inside entrance hallway at left (from Station 07)
	if player:
		player.position = Vector2(65.0, 296.0)


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


func _setup_audio() -> void:
	_kettle_boil_sfx = ProceduralAudio.create_kettle_boil_sound()
	_drawer_unlatch_sfx = ProceduralAudio.create_drawer_lock_unlatch_sound()
	_blip_lena_sfx = ProceduralAudio.create_dialogue_blip_sound(true)
	_blip_marta_sfx = ProceduralAudio.create_dialogue_marta_blip_sound()
	_transition_sfx = ProceduralAudio.create_airlock_seal_sound()
	
	_kettle_player = AudioStreamPlayer.new()
	_kettle_player.name = "KettleAudioPlayer"
	_kettle_player.stream = _kettle_boil_sfx
	_kettle_player.volume_db = -12.0
	_kettle_player.bus = &"Master"
	add_child(_kettle_player)
	_kettle_player.play()
	
	_drawer_player = AudioStreamPlayer.new()
	_drawer_player.name = "DrawerAudioPlayer"
	_drawer_player.stream = _drawer_unlatch_sfx
	_drawer_player.volume_db = -2.0
	_drawer_player.bus = &"Master"
	add_child(_drawer_player)
	
	_blip_player = AudioStreamPlayer.new()
	_blip_player.name = "BlipAudioPlayer"
	_blip_player.volume_db = -4.0
	_blip_player.bus = &"Master"
	add_child(_blip_player)
	
	_transition_player = AudioStreamPlayer.new()
	_transition_player.name = "TransitionAudioPlayer"
	_transition_player.stream = _transition_sfx
	_transition_player.volume_db = -2.0
	_transition_player.bus = &"Master"
	add_child(_transition_player)


func _connect_props() -> void:
	if props == null:
		return
	
	for child in props.get_children():
		if child is MemoryResonancePoint:
			child.resonance_triggered.connect(_on_resonance_triggered)


func _process(delta: float) -> void:
	_pulse_time += delta
	
	# Keep simmering audio active
	if _kettle_player and not _kettle_player.playing:
		_kettle_player.play()
	
	queue_redraw()


func _physics_process(_delta: float) -> void:
	if hallway_sideboard == null or player == null:
		return
	hallway_sideboard.update_player_distance(player.global_position)
	if hallway_sideboard.is_player_in_range and player.is_on_floor():
		var push_direction := Input.get_axis(&"move_left", &"move_right")
		if not is_zero_approx(push_direction):
			hallway_sideboard.receive_push(push_direction)
	if not sideboard_repositioned and hallway_sideboard.position.x >= 528.0:
		sideboard_repositioned = true
		queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"trigger_correction"):
		_apply_sideboard_correction()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed(&"interact"):
		if hallway_sideboard and hallway_sideboard.is_player_in_range:
			hallway_sideboard.toggle_anchor()
			get_viewport().set_input_as_handled()
			return
		if marta_dialogue_active:
			advance_marta_dialogue()
			get_viewport().set_input_as_handled()


func _on_resonance_triggered(id: String, prop_type_val: int) -> void:
	clue_inspected.emit(id, prop_type_val)
	
	match id:
		"CoatRack":
			coat_rack_inspected = true
		"ReflectedPhoto":
			reflected_photo_inspected = true
		"BeakerPlanter":
			beaker_planter_inspected = true
		"JakubMemento":
			jakub_memento_inspected = true
		"TeaKettle":
			tea_kettle_inspected = true
		"CipherDesk":
			if not cipher_drawer_unlocked_state:
				unlock_cipher_drawer()
		"MartaInteraction":
			if not is_marta_dialogue_completed and not marta_dialogue_active:
				start_marta_dialogue()


func unlock_cipher_drawer() -> void:
	cipher_drawer_unlocked_state = true
	if _drawer_player:
		_drawer_player.play()
	
	var desk_prop := props.get_node_or_null("CipherDesk") as MemoryResonancePoint
	if desk_prop:
		desk_prop.is_activated = true
	
	cipher_drawer_unlocked.emit()
	
	# If Marta dialogue was not started yet, examining the desk triggers dialogue at line 2
	if not is_marta_dialogue_completed and not marta_dialogue_active:
		start_marta_dialogue()


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
		
		# On line 4 (muscle memory unlocks cipher drawer), ensure drawer is unlocked
		if marta_dialogue_index == 4:
			if not cipher_drawer_unlocked_state:
				unlock_cipher_drawer()
		
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
		if sideboard_repositioned and not is_level_completed:
			is_level_completed = true
			if _transition_player:
				_transition_player.play()
			level_completed.emit()


func push_sideboard(direction: float) -> void:
	if hallway_sideboard:
		hallway_sideboard.receive_push(direction)


func _apply_sideboard_correction() -> void:
	if sideboard_repositioned:
		return
	sideboard_correction_count += 1
	sideboard_detail_faded = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_08_sideboard_corrected", sideboard_correction_count)
	if hallway_sideboard:
		hallway_sideboard.reset_to_spawn()
	if player:
		player.reset_to(Vector2(65.0, 296.0))
	queue_redraw()


func _draw() -> void:
	_draw_state_layer()
	_draw_dialogue_ui()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var passage_col := VectorStageStyle.CORRECTION_OXIDE if not sideboard_repositioned else VectorStageStyle.ANCHOR_CYAN
	draw_line(Vector2(528.0, 96.0), Vector2(528.0, 244.0), passage_col, 3.0)
	draw_rect(Rect2(524.0, 244.0, 72.0, 5.0), passage_col)
	if sideboard_detail_faded:
		draw_rect(Rect2(344.0, 148.0, 10.0, 38.0), VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.38))


func _draw_apartment_environment() -> void:
	# 1. Background wall plaster (warm sea graphite / domestic studio)
	draw_rect(Rect2(0.0, 0.0, LEVEL_WIDTH, 360.0), COLOR_WALL_PLASTER)
	
	# Lower wall modernist wainscoting / dado (y=190..310)
	draw_rect(Rect2(0.0, 190.0, LEVEL_WIDTH, 120.0), COLOR_WALL_DADO)
	draw_line(Vector2(0.0, 190.0), Vector2(LEVEL_WIDTH, 190.0), COLOR_INFRASTRUCTURE * 0.5, 1.2)
	
	# 2. Parquet Floor (y=310..360) with alternating wood planks
	draw_rect(Rect2(0.0, 310.0, LEVEL_WIDTH, 50.0), COLOR_PARQUET)
	# Parquet board dividing lines
	for x in range(0, int(LEVEL_WIDTH), 24):
		var x_pos := float(x)
		draw_line(Vector2(x_pos, 310.0), Vector2(x_pos, 360.0), COLOR_PARQUET_LIGHT * 0.7, 0.8)
		# Horizontal plank seams
		draw_line(Vector2(x_pos, 325.0), Vector2(x_pos + 24.0, 325.0), COLOR_PARQUET_LIGHT * 0.5, 0.6)
		draw_line(Vector2(x_pos, 342.0), Vector2(x_pos + 24.0, 342.0), COLOR_PARQUET_LIGHT * 0.5, 0.6)
	
	# Baseboard trim (listwa przypodłogowa)
	draw_rect(Rect2(0.0, 307.0, LEVEL_WIDTH, 4.0), COLOR_FURNITURE_DARK)
	
	# 3. Entrance area (Left, x=20..75)
	# Front apartment door (open from Station 07)
	draw_rect(Rect2(25.0, 120.0, 42.0, 188.0), Color("1a2228"))
	draw_rect(Rect2(25.0, 120.0, 42.0, 188.0), COLOR_INFRASTRUCTURE * 0.6, false, 1.2)
	# Entryway floor rubber runner
	draw_rect(Rect2(20.0, 308.0, 80.0, 3.0), Color("12181d"))
	
	# 4. Modernist Shelving Unit / Credenza (x=125..175)
	var credenza_rect := Rect2(125.0, 200.0, 50.0, 108.0)
	draw_rect(credenza_rect, COLOR_FURNITURE_TEAK)
	draw_rect(credenza_rect, COLOR_FURNITURE_DARK, false, 1.0)
	# Shelf dividers
	draw_line(Vector2(125.0, 235.0), Vector2(175.0, 235.0), COLOR_FURNITURE_DARK, 1.2)
	draw_line(Vector2(125.0, 270.0), Vector2(175.0, 270.0), COLOR_FURNITURE_DARK, 1.2)
	# Technical binders and books on lower shelves
	for i in range(5):
		var bx := 130.0 + float(i) * 8.0
		var col := Color("2b3d36") if i % 2 == 0 else Color("3d2c1e")
		draw_rect(Rect2(bx, 272.0, 6.5, 34.0), col)
	
	# 5. Kitchenette / Counter area (x=185..245)
	var counter_rect := Rect2(185.0, 230.0, 60.0, 78.0)
	draw_rect(counter_rect, Color("202c34"))
	draw_rect(counter_rect, COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	# Tiled kitchen backsplash
	for ty in range(160, 230, 14):
		for tx in range(185, 245, 15):
			draw_rect(Rect2(float(tx), float(ty), 14.0, 13.0), Color("1b252c"))
			draw_rect(Rect2(float(tx), float(ty), 14.0, 13.0), Color("26353f"), false, 0.6)
	# Upper spice / cup rack
	draw_rect(Rect2(190.0, 150.0, 50.0, 4.0), COLOR_FURNITURE_TEAK)
	
	# 6. Dining / Work Table (x=275..355)
	var table_top := Rect2(275.0, 245.0, 80.0, 8.0)
	draw_rect(table_top, COLOR_FURNITURE_TEAK)
	draw_rect(table_top, COLOR_FURNITURE_DARK, false, 1.0)
	# Table legs
	draw_rect(Rect2(280.0, 253.0, 4.0, 55.0), COLOR_FURNITURE_DARK)
	draw_rect(Rect2(346.0, 253.0, 4.0, 55.0), COLOR_FURNITURE_DARK)
	# Wooden dining chairs
	draw_rect(Rect2(262.0, 235.0, 10.0, 73.0), Color("2a1e16")) # Left chair
	draw_rect(Rect2(358.0, 235.0, 10.0, 73.0), Color("2a1e16")) # Right chair
	
	# 7. Overhead pendant lamp with warm cone onto dining table
	draw_line(Vector2(315.0, 0.0), Vector2(315.0, 95.0), Color("12181d"), 1.2)
	draw_circle(Vector2(315.0, 98.0), 9.0, Color("354854")) # Enamel shade
	draw_circle(Vector2(315.0, 101.0), 3.0, COLOR_AMBER) # Filament bulb
	# Warm amber light cone (#d39a62)
	var pulse := sin(_pulse_time * 1.8) * 0.5 + 0.5
	var cone_poly := PackedVector2Array([
		Vector2(315.0, 102.0),
		Vector2(230.0, 310.0),
		Vector2(400.0, 310.0)
	])
	draw_colored_polygon(cone_poly, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.12 + pulse * 0.03))
	
	# 8. Modernist Studio Window with Night Rain & City Lights (x=495..575, y=70..195)
	var win_rect := Rect2(495.0, 70.0, 80.0, 125.0)
	draw_rect(win_rect, COLOR_NIGHT_SKY)
	# Distant city window dots in rain
	draw_circle(Vector2(515.0, 120.0), 1.2, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.35))
	draw_circle(Vector2(550.0, 140.0), 1.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.30))
	draw_circle(Vector2(535.0, 160.0), 1.4, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.25))
	# Rain streaks down glass
	for r in range(6):
		var rx := 502.0 + float(r) * 12.0 + sin(_pulse_time * 2.0 + float(r)) * 2.0
		var ry := 75.0 + fmod(_pulse_time * 45.0 + float(r * 22), 110.0)
		draw_line(Vector2(rx, ry), Vector2(rx - 1.5, ry + 8.0), Color(0.46, 0.78, 0.76, 0.25), 0.8)
	# Window frame & glazing mullions
	draw_rect(win_rect, Color("1e2a32"), false, 2.0)
	draw_line(Vector2(535.0, 70.0), Vector2(535.0, 195.0), Color("1e2a32"), 1.6)
	draw_line(Vector2(495.0, 130.0), Vector2(575.0, 130.0), Color("1e2a32"), 1.6)
	
	# Cast iron radiator under window (x=505..565, y=240..305)
	var rad_rect := Rect2(505.0, 240.0, 60.0, 65.0)
	draw_rect(rad_rect, Color("202c34"))
	draw_rect(rad_rect, COLOR_INFRASTRUCTURE * 0.6, false, 1.0)
	for col_idx in range(7):
		var cx := 510.0 + float(col_idx) * 7.5
		draw_rect(Rect2(cx, 243.0, 4.5, 59.0), Color("283943"))
		draw_rect(Rect2(cx, 243.0, 4.5, 59.0), COLOR_INFRASTRUCTURE * 0.4, false, 0.6)
	
	# 9. Bathroom hallway portal on right (x=590..640) leading to Space 09
	draw_rect(Rect2(590.0, 110.0, 50.0, 198.0), Color("10161a"))
	draw_rect(Rect2(590.0, 110.0, 50.0, 198.0), COLOR_INFRASTRUCTURE * 0.5, false, 1.2)
	# Subtle mirror reflection shimmer coming from bathroom corridor
	var mirror_pulse := sin(_pulse_time * 2.5) * 0.5 + 0.5
	draw_rect(Rect2(600.0, 130.0, 30.0, 150.0), Color(0.46, 0.78, 0.76, 0.06 + mirror_pulse * 0.04))


func _draw_dialogue_ui() -> void:
	if not marta_dialogue_active or marta_dialogue_index < 0 or marta_dialogue_index >= marta_dialogue_lines.size():
		return
	
	var line_info: Dictionary = marta_dialogue_lines[marta_dialogue_index]
	var speaker: String = line_info["speaker"]
	var text: String = line_info["text"]
	var is_stage_direction: bool = line_info.get("is_stage_direction", false)
	var is_lena: bool = line_info.get("is_lena", false)
	
	# Dialogue box in upper center (x=70..570, y=18..66)
	var box_rect := Rect2(70.0, 18.0, 500.0, 50.0)
	draw_rect(box_rect, Color(0.08, 0.11, 0.14, 0.94))
	
	var border_col := COLOR_AMBER if is_lena else (COLOR_CYAN if not is_stage_direction else COLOR_INFRASTRUCTURE)
	draw_rect(box_rect, border_col, false, 1.2)
	
	# Speaker header tag
	var default_font := ThemeDB.fallback_font
	if default_font:
		var speaker_col := COLOR_AMBER if is_lena else (Color("8ec5b6") if not is_stage_direction else COLOR_CYAN)
		draw_string(default_font, Vector2(85.0, 34.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, speaker_col)
		
		var text_col := Color("e2e8e5") if not is_stage_direction else COLOR_INFRASTRUCTURE
		draw_string(default_font, Vector2(85.0, 52.0), text, HORIZONTAL_ALIGNMENT_LEFT, 470.0, 11, text_col)
		
		# Advance hint at bottom right
		var hint_pulse := sin(_pulse_time * 4.0) * 0.5 + 0.5
		var hint_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.4 + hint_pulse * 0.5)
		draw_string(default_font, Vector2(520.0, 60.0), "[E]", HORIZONTAL_ALIGNMENT_RIGHT, -1, 9, hint_col)
