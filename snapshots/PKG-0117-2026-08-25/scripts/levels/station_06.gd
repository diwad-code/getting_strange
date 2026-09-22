class_name Station06
extends Node2D

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

## Station 06 (Przestrzeń 06: Linia zastępcza / Autobus Linii 4) for Getting Strange Vertical Slice.
## Represents the interior of the replacement night bus traveling along the shut-down Line 4.
## Implements the moving background parallax, environmental UCP speaker hygiene announcement,
## dialogue with the elderly passenger returning the lost wedding ring, finger examination
## (verifying the absence of any ring mark per VISUAL_DESIGN.md), and arrival at Osiedle Tarasowe
## with pneumatic opening doors leading to Przestrzeń 07.
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 06), and CONTINUITY_TRACKER.md (R-01, ring_disposition).

## PRZESZKODA — dlaczego to tu jest: Autobus zastępczy wykonuje niezależny cykl postoju, zanim otworzy pneumatyczne drzwi na końcu trasy.
## PRZESZKODA — czego wymaga od Leny: zatrzymania się przy drzwiach i rozpoznania pełnego cyklu otwarcia.
## PRZESZKODA — koszt porażki: powrót na przystanek wejścia, a ogłoszenie traci jedną informację o trasie.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("182126") # Sea graphite
const COLOR_NIGHT_SKY := Color("091015")
const COLOR_INFRASTRUCTURE := Color("a8b2ac") # Grey sage
const COLOR_AMBER := Color("d39a62") # Muted amber (Lena / life / memory / gold)
const COLOR_CYAN := Color("75c7c3") # Cool cyan (Anchor / active signal)
const COLOR_CORRECTION := Color("c65d58") # Oxide cinnabar (Anomaly / shut down Line 4)
const COLOR_DARK_STEEL := Color("263943")
const COLOR_FLOOR := Color("151e24")
const COLOR_FLOOR_EDGE := Color("3a4f59")
const COLOR_WINDOW_TINT := Color(0.08, 0.13, 0.17, 0.75)
const COLOR_SEAT_FABRIC := Color("1f2f3c")
const COLOR_SEAT_FRAME := Color("3a4f59")

signal clue_inspected(id: String, prop_type: int)
signal speaker_announced()
signal passenger_dialogue_started()
signal passenger_dialogue_advanced(line_idx: int)
signal passenger_dialogue_completed()
signal ring_inspected_signal()
signal bus_arrived()
signal doors_opened()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var replacement_bus_exit_door: AnimatableBody2D = $Geometry/ReplacementBusExitDoor if has_node("Geometry/ReplacementBusExitDoor") else get_node_or_null("ReplacementBusExitDoor")

var is_bus_moving: bool = true
var bus_speed: float = 160.0
var street_scroll_offset: float = 0.0

var speaker_announcement_triggered: bool = false
var route_map_inspected: bool = false
var passenger_dialogue_active: bool = false
var passenger_dialogue_index: int = -1
var is_passenger_dialogue_completed: bool = false
var is_ring_inspected: bool = false
var is_finger_checked: bool = false

var is_arriving: bool = false
var is_bus_stopped: bool = false
var are_doors_open: bool = false
var door_open_progress: float = 0.0
var is_level_completed: bool = false
var bus_exit_correction_count: int = 0
var bus_exit_detail_faded: bool = false

var _pulse_time: float = 0.0
var _chassis_bounce: float = 0.0
var _strap_sway_angle: float = 0.0
var _announcement_timer: float = 0.0
var _arrival_timer: float = 0.0

# Dialog lines per FULL_STORY 06 & DIALOGUE_SCRIPT / CONTINUITY_TRACKER
var passenger_dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "STARSZY PASAŻER",
		"text": "Pani Wolska? Dobrze panią widzieć z powrotem. Zostawiła to pani na siedzeniu dwa tygodnie temu...",
		"is_lena": false
	},
	{
		"speaker": "LENA",
		"text": "Nigdy jej nie nosiłam. Pomylił mnie pan z kimś.",
		"is_lena": true
	},
	{
		"speaker": "STARSZY PASAŻER",
		"text": "Nosiła pani. Wszyscy na linii widzieli. Zostawię na miejscu, niech pani nie zgubi.",
		"is_lena": false
	},
	{
		"speaker": "ŚWIADECTWO CIAŁA",
		"text": "Lena dociska paznokieć do szwu palca. Na dłoni nie ma najmniejszego śladu po obrączce.",
		"is_lena": true
	}
]

var _engine_player: AudioStreamPlayer
var _rain_player: AudioStreamPlayer
var _announcement_player: AudioStreamPlayer
var _door_player: AudioStreamPlayer
var _ring_player: AudioStreamPlayer
var _blip_player: AudioStreamPlayer
var _transition_player: AudioStreamPlayer

var _engine_sfx: AudioStreamWAV
var _rain_sfx: AudioStreamWAV
var _announcement_sfx: AudioStreamWAV
var _door_sfx: AudioStreamWAV
var _ring_sfx: AudioStreamWAV
var _blip_lena_sfx: AudioStreamWAV
var _blip_guard_sfx: AudioStreamWAV
var _transition_sfx: AudioStreamWAV


func _ready() -> void:
	_setup_camera()
	_setup_audio()
	_setup_guidance()
	_connect_props()
	
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	
	# Initial player spawn position in the front entrance of the bus
	if player:
		player.position = Vector2(80.0, 296.0)
	
	queue_redraw()


func _setup_guidance() -> void:
	var guidance := get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	if guidance:
		var beat := GuidanceBeat.new()
		beat.beat_id = &"s06_timetable_conflict"
		beat.scene_id = &"station_06"
		beat.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
		beat.thought_kind = &"interpretation"
		beat.text_pl = "Na wydruku powinna być data zmiany. Nikt nie wywiesza rozkładu bez pieczęci."
		beat.text_en = "The printout should have a change date. Nobody posts a timetable without a stamp."
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
	]
	camera.setup_chambers(bounds)


func _setup_audio() -> void:
	_engine_sfx = ProceduralAudio.create_bus_engine_sound(false)
	_rain_sfx = ProceduralAudio.create_bus_rain_window_sound()
	_announcement_sfx = ProceduralAudio.create_bus_announcement_sound()
	_door_sfx = ProceduralAudio.create_bus_door_pneumatic_sound()
	_ring_sfx = ProceduralAudio.create_ring_chime_sound()
	_blip_lena_sfx = ProceduralAudio.create_dialogue_blip_sound(true)
	_blip_guard_sfx = ProceduralAudio.create_dialogue_blip_sound(false)
	_transition_sfx = ProceduralAudio.create_airlock_seal_sound()
	
	_engine_player = AudioStreamPlayer.new()
	_engine_player.name = "EngineAudioPlayer"
	_engine_player.stream = _engine_sfx
	_engine_player.volume_db = -8.0
	_engine_player.bus = &"Master"
	add_child(_engine_player)
	_engine_player.play()
	
	_rain_player = AudioStreamPlayer.new()
	_rain_player.name = "RainAudioPlayer"
	_rain_player.stream = _rain_sfx
	_rain_player.volume_db = -12.0
	_rain_player.bus = &"Master"
	add_child(_rain_player)
	_rain_player.play()
	
	_announcement_player = AudioStreamPlayer.new()
	_announcement_player.name = "AnnouncementAudioPlayer"
	_announcement_player.stream = _announcement_sfx
	_announcement_player.volume_db = -4.0
	_announcement_player.bus = &"Master"
	add_child(_announcement_player)
	
	_door_player = AudioStreamPlayer.new()
	_door_player.name = "DoorAudioPlayer"
	_door_player.stream = _door_sfx
	_door_player.volume_db = -5.0
	_door_player.bus = &"Master"
	add_child(_door_player)
	
	_ring_player = AudioStreamPlayer.new()
	_ring_player.name = "RingAudioPlayer"
	_ring_player.stream = _ring_sfx
	_ring_player.volume_db = -6.0
	_ring_player.bus = &"Master"
	add_child(_ring_player)
	
	_blip_player = AudioStreamPlayer.new()
	_blip_player.name = "BlipAudioPlayer"
	_blip_player.volume_db = -6.0
	_blip_player.bus = &"Master"
	add_child(_blip_player)
	
	_transition_player = AudioStreamPlayer.new()
	_transition_player.name = "TransitionAudioPlayer"
	_transition_player.stream = _transition_sfx
	_transition_player.volume_db = -6.0
	_transition_player.bus = &"Master"
	add_child(_transition_player)


func _connect_props() -> void:
	if not props:
		return
	
	for child in props.get_children():
		if child is MemoryResonancePoint:
			child.resonance_triggered.connect(_on_prop_resonance_triggered)


func _process(delta: float) -> void:
	_pulse_time += delta
	
	# Parallax scrolling when bus is moving
	if is_bus_moving:
		street_scroll_offset += bus_speed * delta
		if street_scroll_offset > 640.0:
			street_scroll_offset -= 640.0
		
		_chassis_bounce = sin(_pulse_time * 9.0) * 0.7 + sin(_pulse_time * 17.0) * 0.3
		_strap_sway_angle = sin(_pulse_time * 3.5) * 0.08
	else:
		_chassis_bounce = move_toward(_chassis_bounce, 0.0, delta * 3.0)
		_strap_sway_angle = move_toward(_strap_sway_angle, 0.0, delta * 0.5)
	
	# Auto-trigger speaker announcement after a brief moment if not already done
	if not speaker_announcement_triggered and _pulse_time > 1.8:
		trigger_speaker_announcement()
	
	# Check if conditions for arrival at Osiedle Tarasowe are met
	if is_passenger_dialogue_completed and is_ring_inspected and not is_arriving and not is_bus_stopped:
		trigger_arrival_sequence()
	
	# Handling deceleration and door opening during arrival
	if is_arriving and not is_bus_stopped:
		_arrival_timer += delta
		bus_speed = maxf(0.0, bus_speed - delta * 90.0)
		if bus_speed <= 0.01 or _arrival_timer >= 2.0:
			bus_speed = 0.0
			is_bus_moving = false
			is_bus_stopped = true
			_open_bus_doors()
	
	if are_doors_open and door_open_progress < 1.0:
		door_open_progress = minf(1.0, door_open_progress + delta * 2.2)
	if replacement_bus_exit_door:
		var target_y := 60.0 if are_doors_open else 186.0
		replacement_bus_exit_door.position.y = lerpf(replacement_bus_exit_door.position.y, target_y, delta * 8.0)
	
	queue_redraw()


func trigger_speaker_announcement() -> void:
	speaker_announcement_triggered = true
	if _announcement_player:
		_announcement_player.play()
	
	var speaker_prop := props.get_node_or_null("BusSpeaker") as MemoryResonancePoint
	if speaker_prop:
		speaker_prop.is_activated = true
	
	speaker_announced.emit()
	queue_redraw()


func start_passenger_dialogue() -> void:
	if is_passenger_dialogue_completed or passenger_dialogue_active:
		return
	
	passenger_dialogue_active = true
	passenger_dialogue_index = 0
	_play_dialogue_blip(false)
	passenger_dialogue_started.emit()
	queue_redraw()


func advance_passenger_dialogue() -> int:
	if not passenger_dialogue_active:
		return -1
	
	passenger_dialogue_index += 1
	if passenger_dialogue_index >= passenger_dialogue_lines.size():
		passenger_dialogue_active = false
		is_passenger_dialogue_completed = true
		passenger_dialogue_completed.emit()
		
		# Make the gold ring visible and accessible on the seat
		var ring_prop := props.get_node_or_null("GoldRing") as MemoryResonancePoint
		if ring_prop:
			ring_prop.visible = true
		
		queue_redraw()
		return -1
	
	var current_line: Dictionary = passenger_dialogue_lines[passenger_dialogue_index]
	var is_lena: bool = current_line.get("is_lena", false)
	_play_dialogue_blip(is_lena)
	
	if passenger_dialogue_index == 3:
		is_finger_checked = true
	
	passenger_dialogue_advanced.emit(passenger_dialogue_index)
	queue_redraw()
	return passenger_dialogue_index


func inspect_gold_ring() -> void:
	is_ring_inspected = true
	if _ring_player:
		_ring_player.play()
	
	var ring_prop := props.get_node_or_null("GoldRing") as MemoryResonancePoint
	if ring_prop:
		ring_prop.is_activated = true
	
	ring_inspected_signal.emit()
	queue_redraw()


func trigger_arrival_sequence() -> void:
	is_arriving = true
	_arrival_timer = 0.0
	if _announcement_player:
		_announcement_player.play()
	bus_arrived.emit()
	queue_redraw()


func _open_bus_doors() -> void:
	are_doors_open = true
	door_open_progress = 0.0
	if replacement_bus_exit_door:
		replacement_bus_exit_door.position.y = 60.0
	if _door_player:
		_door_player.play()
	doors_opened.emit()
	queue_redraw()


func _play_dialogue_blip(is_lena: bool) -> void:
	if _blip_player:
		_blip_player.stream = _blip_lena_sfx if is_lena else _blip_guard_sfx
		_blip_player.pitch_scale = 1.0 + randf_range(-0.03, 0.03)
		_blip_player.play()


func _on_prop_resonance_triggered(id: String, prop_type: int) -> void:
	clue_inspected.emit(id, prop_type)
	
	match id:
		"bus_speaker":
			trigger_speaker_announcement()
		"elderly_passenger":
			if not is_passenger_dialogue_completed:
				if not passenger_dialogue_active:
					start_passenger_dialogue()
				else:
					advance_passenger_dialogue()
		"gold_ring":
			inspect_gold_ring()
		"bus_route_map":
			route_map_inspected = true


func _on_airlock_body_entered(body: Node2D) -> void:
	if not are_doors_open or is_level_completed:
		return
	
	if body is PrototypePlayer or body.name == "Player":
		is_level_completed = true
		var game_state := get_node_or_null("/root/GameStateManager")
		if game_state and game_state.has_method("set_campaign_flag"):
			game_state.set_campaign_flag(&"unease_pattern_started", true)
		if _transition_player:
			_transition_player.play()
		level_completed.emit()


func _apply_bus_exit_correction() -> void:
	if are_doors_open:
		return
	bus_exit_correction_count += 1
	bus_exit_detail_faded = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_06_bus_exit_corrected", bus_exit_correction_count)
	if player:
		player.reset_to(Vector2(80.0, 296.0))
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"trigger_correction"):
		_apply_bus_exit_correction()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed(&"interact"):
		if passenger_dialogue_active:
			advance_passenger_dialogue()
			get_viewport().set_input_as_handled()


func _draw() -> void:
	_draw_state_layer()
	_draw_in_world_overlays()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var door_col := VectorStageStyle.CORRECTION_OXIDE if not are_doors_open else VectorStageStyle.ANCHOR_CYAN
	var door_rect := Rect2(560.0, 60.0, 50.0, 252.0)
	if not are_doors_open:
		draw_rect(door_rect, VectorStageStyle.MID_PLANE)
		draw_rect(door_rect, door_col, false, 2.0)
	else:
		draw_line(Vector2(560.0, 60.0), Vector2(560.0, 312.0), door_col, 2.0)
		draw_line(Vector2(610.0, 60.0), Vector2(610.0, 312.0), door_col, 2.0)
	draw_circle(Vector2(585.0, 52.0), 4.0, door_col)
	if bus_exit_detail_faded:
		draw_rect(Rect2(594.0, 110.0, 8.0, 44.0), VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.38))


func _draw_window_backgrounds() -> void:
	# Background rectangle for the entire window row (y=84 to y=216)
	draw_rect(Rect2(0.0, 84.0, LEVEL_WIDTH, 132.0), COLOR_NIGHT_SKY)
	
	# Distant city building silhouette outlines
	for i in range(8):
		var b_x: float = fposmod(float(i) * 90.0 - street_scroll_offset * 0.35, 720.0) - 40.0
		var b_w: float = 65.0
		var b_h: float = 45.0 + float((i * 17) % 35)
		draw_rect(Rect2(b_x, 216.0 - b_h, b_w, b_h), Color("101820"))
		# Micro illuminated windows in distant buildings
		if i % 2 == 0:
			draw_rect(Rect2(b_x + 12.0, 216.0 - b_h + 14.0, 4.0, 6.0), Color("3d4b3e", 0.6))
			draw_rect(Rect2(b_x + 24.0, 216.0 - b_h + 26.0, 4.0, 6.0), Color("d39a62", 0.4))
	
	# Closed Line 4 tracks corridor running parallel outside
	draw_line(Vector2(0.0, 212.0), Vector2(LEVEL_WIDTH, 212.0), Color("34434d"), 1.5)
	draw_line(Vector2(0.0, 215.0), Vector2(LEVEL_WIDTH, 215.0), Color("34434d"), 1.5)
	
	# Red hazard lights and concrete barriers along shut-down Line 4
	for i in range(4):
		var bar_x: float = fposmod(float(i) * 180.0 - street_scroll_offset * 0.7, 720.0) - 40.0
		# Concrete barrier block
		draw_rect(Rect2(bar_x, 204.0, 28.0, 10.0), Color("2b3842"))
		# Flashing red caution diode (#C65D58)
		var flash := sin(_pulse_time * 6.0 + float(i)) * 0.5 + 0.5
		draw_circle(Vector2(bar_x + 14.0, 201.0), 2.2, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.4 + flash * 0.6))
	
	# Passing streetlamps outside (Amber / Cyan pools of light sweeping past)
	for i in range(3):
		var lamp_x: float = fposmod(float(i) * 240.0 - street_scroll_offset, 720.0) - 40.0
		# Lamp pole
		draw_line(Vector2(lamp_x, 100.0), Vector2(lamp_x, 216.0), Color("263943"), 2.0)
		draw_line(Vector2(lamp_x, 100.0), Vector2(lamp_x + 12.0, 94.0), Color("263943"), 2.0)
		# Lamp bulb glow
		var glow_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.35)
		draw_circle(Vector2(lamp_x + 12.0, 95.0), 16.0, glow_col)
		draw_circle(Vector2(lamp_x + 12.0, 95.0), 3.0, Color("fff6d6"))
	
	# Bus stop shelter when arriving at Osiedle Tarasowe
	if is_arriving or is_bus_stopped:
		var shelter_x: float = 460.0 if is_bus_stopped else lerpf(680.0, 460.0, clampf(_arrival_timer / 2.0, 0.0, 1.0))
		# Shelter glass canopy & structure
		draw_rect(Rect2(shelter_x, 120.0, 120.0, 94.0), Color("121b22", 0.9))
		draw_rect(Rect2(shelter_x, 120.0, 120.0, 94.0), COLOR_INFRASTRUCTURE * 0.7, false, 1.5)
		# Shelter roof
		draw_rect(Rect2(shelter_x - 10.0, 114.0, 140.0, 6.0), COLOR_DARK_STEEL)
		# Illuminated transit sign: "OSIEDLE TARASOWE"
		draw_rect(Rect2(shelter_x + 10.0, 124.0, 100.0, 14.0), Color("0d1820"))
		draw_rect(Rect2(shelter_x + 10.0, 124.0, 100.0, 14.0), COLOR_CYAN * 0.8, false, 1.0)
		draw_line(Vector2(shelter_x + 14.0, 131.0), Vector2(shelter_x + 106.0, 131.0), COLOR_CYAN, 1.5)
		# Shelter bench & waiting passenger silhouette
		draw_rect(Rect2(shelter_x + 20.0, 185.0, 45.0, 6.0), COLOR_INFRASTRUCTURE * 0.5)
		draw_circle(Vector2(shelter_x + 40.0, 168.0), 4.5, Color("0a1014")) # Head
		draw_rect(Rect2(shelter_x + 35.0, 173.0, 10.0, 18.0), Color("0a1014")) # Coat
	
	# Rain streaks sliding along outer glass
	for i in range(16):
		var rx: float = fposmod(float(i * 41) - street_scroll_offset * 0.1, LEVEL_WIDTH)
		var ry: float = fposmod(float(i * 29) + _pulse_time * 80.0, 120.0) + 88.0
		var r_len: float = 6.0 + float((i * 7) % 8)
		draw_line(Vector2(rx, ry), Vector2(rx - 3.0, ry + r_len), Color(0.65, 0.75, 0.85, 0.28), 1.0)


func _draw_bus_structure() -> void:
	var bounce := _chassis_bounce
	
	# Ceiling structural block (y=0 to y=60)
	draw_rect(Rect2(0.0, 0.0, LEVEL_WIDTH, 60.0 + bounce), COLOR_DARK_STEEL)
	draw_line(Vector2(0.0, 60.0 + bounce), Vector2(LEVEL_WIDTH, 60.0 + bounce), COLOR_INFRASTRUCTURE * 0.8, 2.0)
	
	# Floor structure (y=312 to y=360)
	draw_rect(Rect2(0.0, 312.0 + bounce, LEVEL_WIDTH, 48.0), COLOR_FLOOR)
	draw_line(Vector2(0.0, 312.0 + bounce), Vector2(LEVEL_WIDTH, 312.0 + bounce), COLOR_FLOOR_EDGE, 2.5)
	
	# Ribbed floor traction stripes
	for i in range(21):
		var fx: float = float(i) * 30.0 + 15.0
		draw_line(Vector2(fx, 316.0 + bounce), Vector2(fx, 355.0 + bounce), Color("1d2932"), 1.5)
	
	# Yellow/Amber safety boundary line near the doors (x=530..610)
	draw_line(Vector2(530.0, 314.0 + bounce), Vector2(620.0, 314.0 + bounce), COLOR_AMBER, 2.0)
	
	# Bus side wall pillars between the 4 large panoramic windows
	var pillar_positions: Array[float] = [0.0, 100.0, 230.0, 360.0, 490.0, 610.0]
	for px in pillar_positions:
		draw_rect(Rect2(px, 60.0 + bounce, 24.0, 252.0), COLOR_DARK_STEEL)
		draw_rect(Rect2(px, 60.0 + bounce, 24.0, 252.0), COLOR_INFRASTRUCTURE * 0.4, false, 1.0)
	
	# Lower side wall / paneling beneath window line (y=216 to y=312)
	draw_rect(Rect2(0.0, 216.0 + bounce, LEVEL_WIDTH, 96.0), Color("1a2732"))
	draw_line(Vector2(0.0, 216.0 + bounce), Vector2(LEVEL_WIDTH, 216.0 + bounce), COLOR_INFRASTRUCTURE * 0.6, 1.5)
	
	# Window frames & glass tint overlay
	var window_rects: Array[Rect2] = [
		Rect2(124.0, 84.0 + bounce, 106.0, 132.0),
		Rect2(254.0, 84.0 + bounce, 106.0, 132.0),
		Rect2(384.0, 84.0 + bounce, 106.0, 132.0),
		Rect2(514.0, 84.0 + bounce, 96.0, 132.0),
	]
	for wr in window_rects:
		draw_rect(wr, COLOR_WINDOW_TINT)
		draw_rect(wr, COLOR_INFRASTRUCTURE * 0.7, false, 1.5)
		# Subtle horizontal glass safety etching
		draw_line(Vector2(wr.position.x, wr.position.y + 66.0), Vector2(wr.position.x + wr.size.x, wr.position.y + 66.0), Color(0.8, 0.9, 1.0, 0.12), 1.0)


func _draw_overhead_fixtures() -> void:
	var bounce := _chassis_bounce
	
	# Stainless steel handrail bar running along ceiling
	var rail_y: float = 78.0 + bounce
	draw_line(Vector2(30.0, rail_y), Vector2(610.0, rail_y), COLOR_INFRASTRUCTURE, 2.5)
	
	# Vertical support stanchion poles to ceiling
	for st_x in [100.0, 230.0, 360.0, 490.0]:
		draw_line(Vector2(st_x, 60.0 + bounce), Vector2(st_x, 312.0 + bounce), COLOR_INFRASTRUCTURE * 0.9, 2.0)
		# Yellow plastic grab grip on vertical pole
		draw_rect(Rect2(st_x - 2.5, 170.0 + bounce, 5.0, 40.0), COLOR_AMBER)
	
	# Hanging hand straps swaying with inertia
	var strap_positions: Array[float] = [150.0, 190.0, 280.0, 320.0, 410.0, 450.0, 540.0]
	for sp_x in strap_positions:
		var strap_len: float = 24.0
		var sway_dx: float = sin(_strap_sway_angle) * strap_len
		var sway_dy: float = cos(_strap_sway_angle) * strap_len
		var p_top := Vector2(sp_x, rail_y)
		var p_bot := Vector2(sp_x + sway_dx, rail_y + sway_dy)
		
		# Leather / nylon strap
		draw_line(p_top, p_bot, Color("202a32"), 2.0)
		# Triangular rubber handle
		draw_circle(p_bot, 4.5, COLOR_INFRASTRUCTURE * 0.8)
		draw_circle(p_bot, 2.8, Color("141e26"))
	
	# Overhead fluorescent light fixtures casting soft downward pools of light
	var light_positions: Array[float] = [170.0, 310.0, 450.0]
	for lx in light_positions:
		# Fixture housing
		draw_rect(Rect2(lx - 22.0, 56.0 + bounce, 44.0, 6.0), COLOR_DARK_STEEL)
		draw_rect(Rect2(lx - 20.0, 58.0 + bounce, 40.0, 3.0), Color("eaf2f2"))
		
		# Soft downward light cone
		var cone_pts := PackedVector2Array([
			Vector2(lx - 18.0, 62.0 + bounce),
			Vector2(lx + 18.0, 62.0 + bounce),
			Vector2(lx + 55.0, 312.0 + bounce),
			Vector2(lx - 55.0, 312.0 + bounce),
		])
		draw_polygon(cone_pts, [Color(0.85, 0.95, 0.95, 0.04)])


func _draw_bus_seats() -> void:
	var bounce := _chassis_bounce
	
	# Seat pairs along the bus floor (Row 1 at x=140, Row 2 at x=260, Row 3 at x=390, Row 4 at x=450)
	var seat_xs: Array[float] = [140.0, 260.0, 390.0, 450.0]
	for sx in seat_xs:
		var sy: float = 270.0 + bounce
		
		# Steel seat mounting pedestal to floor
		draw_line(Vector2(sx + 10.0, sy + 30.0), Vector2(sx + 10.0, 312.0 + bounce), COLOR_INFRASTRUCTURE * 0.7, 3.0)
		
		# Seat cushion (Bottom seat)
		var cushion_rect := Rect2(sx - 12.0, sy + 18.0, 32.0, 12.0)
		draw_rect(cushion_rect, COLOR_SEAT_FABRIC)
		draw_rect(cushion_rect, COLOR_SEAT_FRAME, false, 1.2)
		
		# Seat backrest
		var back_rect := Rect2(sx + 14.0, sy - 22.0, 10.0, 44.0)
		draw_rect(back_rect, COLOR_SEAT_FABRIC)
		draw_rect(back_rect, COLOR_SEAT_FRAME, false, 1.2)
		
		# Top stainless steel grab handle on backrest
		draw_line(Vector2(sx + 14.0, sy - 22.0), Vector2(sx + 24.0, sy - 22.0), COLOR_INFRASTRUCTURE, 2.0)
		draw_line(Vector2(sx + 24.0, sy - 22.0), Vector2(sx + 24.0, sy - 14.0), COLOR_INFRASTRUCTURE, 2.0)


func _draw_driver_partition() -> void:
	var bounce := _chassis_bounce
	
	# Bulkhead separating driver cabin at front (x=0..60)
	draw_rect(Rect2(0.0, 60.0 + bounce, 55.0, 252.0), Color("121d24"))
	draw_rect(Rect2(0.0, 60.0 + bounce, 55.0, 252.0), COLOR_INFRASTRUCTURE * 0.6, false, 1.5)
	
	# Driver partition glass pane
	draw_rect(Rect2(10.0, 80.0 + bounce, 40.0, 120.0), Color(0.1, 0.16, 0.22, 0.85))
	draw_rect(Rect2(10.0, 80.0 + bounce, 40.0, 120.0), COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	
	# Driver console green/amber indicator diodes
	draw_circle(Vector2(20.0, 220.0 + bounce), 2.0, Color("34d399"))
	draw_circle(Vector2(28.0, 220.0 + bounce), 2.0, COLOR_AMBER)
	draw_circle(Vector2(36.0, 220.0 + bounce), 2.0, COLOR_CYAN)
	
	# Institutional Route Display Board above driver: "LINIA ZASTĘPCZA 4"
	var sign_rect := Rect2(65.0, 68.0 + bounce, 80.0, 14.0)
	draw_rect(sign_rect, Color("0a1218"))
	draw_rect(sign_rect, COLOR_AMBER * 0.8, false, 1.0)
	draw_line(Vector2(70.0, 75.0 + bounce), Vector2(140.0, 75.0 + bounce), COLOR_AMBER, 1.5)
	
	# Ticket validator unit on pole (x=75, y=210)
	draw_rect(Rect2(70.0, 200.0 + bounce, 12.0, 22.0), Color("bf8438")) # Yellow/Orange validator casing
	draw_rect(Rect2(72.0, 204.0 + bounce, 8.0, 4.0), Color("0f171e")) # Card slot
	draw_circle(Vector2(76.0, 214.0 + bounce), 1.5, Color("34d399")) # Green ready LED


func _draw_exit_doors() -> void:
	var bounce := _chassis_bounce
	var door_x: float = 560.0
	var door_y: float = 60.0 + bounce
	var door_h: float = 252.0
	var door_w: float = 50.0
	
	# Exit doorway arch
	draw_rect(Rect2(door_x - 4.0, door_y, door_w + 8.0, door_h), Color("16222b"))
	draw_rect(Rect2(door_x - 4.0, door_y, door_w + 8.0, door_h), COLOR_INFRASTRUCTURE * 0.5, false, 1.5)
	
	# Door panels: Folding open when door_open_progress > 0
	var fold_offset: float = door_open_progress * 18.0
	
	# Left folding leaf
	var l_panel := Rect2(door_x + fold_offset * 0.5, door_y, 22.0 - fold_offset, door_h)
	draw_rect(l_panel, COLOR_DARK_STEEL)
	draw_rect(l_panel, COLOR_INFRASTRUCTURE * 0.7, false, 1.2)
	draw_rect(Rect2(l_panel.position.x + 3.0, l_panel.position.y + 24.0, maxf(1.0, l_panel.size.x - 6.0), 160.0), COLOR_WINDOW_TINT)
	
	# Right folding leaf
	var r_panel := Rect2(door_x + 25.0 + fold_offset * 0.5, door_y, 22.0 - fold_offset, door_h)
	draw_rect(r_panel, COLOR_DARK_STEEL)
	draw_rect(r_panel, COLOR_INFRASTRUCTURE * 0.7, false, 1.2)
	draw_rect(Rect2(r_panel.position.x + 3.0, r_panel.position.y + 24.0, maxf(1.0, r_panel.size.x - 6.0), 160.0), COLOR_WINDOW_TINT)
	
	# Vertical rubber edge seals
	draw_line(Vector2(door_x + 24.0, door_y), Vector2(door_x + 24.0, door_y + door_h), Color("10161b"), 2.0)
	
	# Illuminated exit indicator lamp above door (Red/Cinnabar when closed, Cyan/Green when open)
	var lamp_col := COLOR_CYAN if are_doors_open else COLOR_CORRECTION
	draw_circle(Vector2(door_x + 24.0, door_y - 6.0), 3.0, lamp_col)
	if are_doors_open:
		draw_circle(Vector2(door_x + 24.0, door_y - 6.0), 8.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.25))


func _draw_in_world_overlays() -> void:
	# 1. Active dialogue subtitle bubble in the upper screen area
	if passenger_dialogue_active and passenger_dialogue_index >= 0 and passenger_dialogue_index < passenger_dialogue_lines.size():
		var line_data: Dictionary = passenger_dialogue_lines[passenger_dialogue_index]
		var speaker_name: String = line_data.get("speaker", "")
		var text: String = line_data.get("text", "")
		var is_lena: bool = line_data.get("is_lena", false)
		
		# Dialogue container box (Centered at x=320, y=32)
		var box_w: float = 540.0
		var box_h: float = 38.0
		var box_rect := Rect2(320.0 - box_w * 0.5, 14.0, box_w, box_h)
		
		draw_rect(box_rect, Color(0.08, 0.12, 0.16, 0.92))
		var border_col := COLOR_AMBER if is_lena else COLOR_CYAN
		draw_rect(box_rect, border_col, false, 1.2)
		
		# Header & speaker indicator
		var dot_col := COLOR_AMBER if is_lena else COLOR_CYAN
		draw_circle(Vector2(box_rect.position.x + 12.0, box_rect.position.y + 12.0), 2.5, dot_col)
		
		# Minimalistic graphic line representation of text for crisp pixel UI
		draw_line(Vector2(box_rect.position.x + 22.0, box_rect.position.y + 12.0), Vector2(box_rect.position.x + 160.0, box_rect.position.y + 12.0), border_col, 1.2)
		draw_line(Vector2(box_rect.position.x + 12.0, box_rect.position.y + 24.0), Vector2(box_rect.position.x + box_w - 20.0, box_rect.position.y + 24.0), COLOR_INFRASTRUCTURE * 0.85, 1.5)
	
	# 2. UCP Public Advisory Banner when speaker is active
	elif speaker_announcement_triggered and _pulse_time < 8.0:
		var adv_rect := Rect2(120.0, 14.0, 400.0, 26.0)
		draw_rect(adv_rect, Color(0.08, 0.12, 0.16, 0.88))
		draw_rect(adv_rect, COLOR_CORRECTION * 0.8, false, 1.0)
		
		# Institutional speaker icon
		draw_circle(Vector2(134.0, 27.0), 3.0, COLOR_CORRECTION)
		draw_line(Vector2(146.0, 27.0), Vector2(500.0, 27.0), COLOR_INFRASTRUCTURE * 0.75, 1.2)
	
	# 3. Next stop announcement on arrival
	elif is_arriving or is_bus_stopped:
		var arr_rect := Rect2(140.0, 14.0, 360.0, 26.0)
		draw_rect(arr_rect, Color(0.08, 0.12, 0.16, 0.88))
		draw_rect(arr_rect, COLOR_CYAN * 0.8, false, 1.0)
		
		draw_circle(Vector2(154.0, 27.0), 3.0, COLOR_CYAN)
		draw_line(Vector2(166.0, 27.0), Vector2(480.0, 27.0), COLOR_CYAN, 1.2)
