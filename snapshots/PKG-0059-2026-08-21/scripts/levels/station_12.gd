class_name Station12
extends Node2D

## Station 12 (Przestrzeń 12: Pokaz bezpieczeństwa / Przejście podziemne i punkt informacyjny UCP) for Getting Strange Vertical Slice.
## Represents the subterranean underpass under the city square at dawn, featuring ceramic subway tiles,
## institutional neon signage, a dual overlapping staircase anomaly being stabilized by a UCP safety warden,
## and a public UCP information terminal revealing local Lena's Level 3 clearance and role in Substructure nodes.
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 12), and CONTINUITY_TRACKER.md (Clue R-03, ucp_benefit_witnessed).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("182126") # Sea graphite
const COLOR_UNDERPASS_CEILING := Color("151f26")
const COLOR_INFRASTRUCTURE := Color("a8b2ac") # Grey sage
const COLOR_AMBER := Color("d39a62") # Muted amber (Lena / Warmth)
const COLOR_CYAN := Color("75c7c3") # Cool cyan (Stabilizer field / Consensus)
const COLOR_CORRECTION := Color("c65d58") # Oxide cinnabar (Discontinuity / Fading anomaly)
const COLOR_DARK_STEEL := Color("263943")
const COLOR_SUBWAY_TILE := Color("2d3c45")
const COLOR_SUBWAY_TILE_LIGHT := Color("3a4e5a")
const COLOR_CONCRETE := Color("27343d")

signal clue_inspected(id: String, prop_type: int)
signal underpass_entered()
signal stabilization_triggered()
signal child_evacuated()
signal terminal_scanned()
signal safety_dialogue_started()
signal safety_dialogue_advanced(line_idx: int)
signal safety_dialogue_completed()
signal underpass_gate_unlocked()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone

var terminal_inspected: bool = false
var vitrine_inspected: bool = false
var poster_inspected: bool = false
var pillar_inspected: bool = false
var gate_inspected: bool = false

var is_stabilization_active: bool = false
var is_child_evacuated: bool = false
var is_safety_demonstrated: bool = false
var is_gate_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _gate_open_progress: float = 0.0
var _stabilizer_beam_progress: float = 0.0
var _child_pos_x: float = 85.0
var _child_pos_y: float = 205.0
var _pulse_time: float = 0.0
var _neon_flicker: float = 1.0

# Dialogue & Terminal Readouts for Space 12 (per FULL_STORY.md Scene 12 and NEXT_SESSION_PROMPT.md)
var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "KOMUNIKAT PA",
		"text": "Uwaga pasażerowie. W korytarzu zachodnim występuje lokalna rozbieżność geometryczna. Prosimy o zachowanie spokoju.",
		"is_pa": true,
		"is_warden": false,
		"is_lena": false,
		"is_terminal": false,
		"is_stage_direction": false
	},
	{
		"speaker": "STRAŻNIK EWAKUACJI UCP",
		"text": "Nie bój się, mała. Zespół trzyma szew. Za chwilę zejdziesz na peron.",
		"is_pa": false,
		"is_warden": true,
		"is_lena": false,
		"is_terminal": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Dwie wersje schodów nakładają się w przestrzeni. Stopnie rozchodzą się o pół metra w powietrzu.",
		"is_pa": false,
		"is_warden": false,
		"is_lena": false,
		"is_terminal": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Pomogę wam. Przełączam zasilanie stabilizatora pomostu.",
		"is_pa": false,
		"is_warden": false,
		"is_lena": true,
		"is_terminal": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Wiązka stabilizatora blokuje stopnie w jednym, bezpiecznym ciągu. Dziewczynka zbiega bezpiecznie do strażnika.",
		"is_pa": false,
		"is_warden": false,
		"is_lena": false,
		"is_terminal": false,
		"is_stage_direction": true
	},
	{
		"speaker": "STRAŻNIK EWAKUACJI UCP",
		"text": "Dziękuję za asystę. Rozbieżność zabezpieczona bez urazów. Wpisuję do rejestru Punktu 6.",
		"is_pa": false,
		"is_warden": true,
		"is_lena": false,
		"is_terminal": false,
		"is_stage_direction": false
	},
	{
		"speaker": "TERMINAL INFORMACYJNY UCP",
		"text": "[AUTORYZACJA POZIOMU 3: INŻ. LENA WOLSKA — PRACOWNIK KWALIFIKOWANY SIATEK PODSTRUKTURY]",
		"is_pa": false,
		"is_warden": false,
		"is_lena": false,
		"is_terminal": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Poziom 3...? Lokalna Lena nie tylko uciekała przed UCP. Ona współtworzyła ten system.",
		"is_pa": false,
		"is_warden": false,
		"is_lena": true,
		"is_terminal": false,
		"is_stage_direction": false
	},
	{
		"speaker": "TERMINAL INFORMACYJNY UCP",
		"text": "[ZASADA 01: PAMIĘĆ TO NIE POMIAR. W PRZYPADKU NIEZGODNOŚCI ZGŁOŚ SIĘ DO PUNKTU ZGODNOŚCI 6].",
		"is_pa": false,
		"is_warden": false,
		"is_lena": false,
		"is_terminal": true,
		"is_stage_direction": false
	}
]

var _subway_player: AudioStreamPlayer
var _neon_player: AudioStreamPlayer
var _pa_player: AudioStreamPlayer
var _terminal_player: AudioStreamPlayer
var _door_player: AudioStreamPlayer
var _blip_player: AudioStreamPlayer


func _ready() -> void:
	_setup_audio_players()
	_connect_signals()
	_configure_camera()
	underpass_entered.emit()


func _setup_audio_players() -> void:
	_subway_player = AudioStreamPlayer.new()
	_subway_player.name = "SubwayHumPlayer"
	_subway_player.stream = ProceduralAudio.create_subway_hum_sound()
	_subway_player.bus = &"Master"
	_subway_player.volume_db = -6.0
	add_child(_subway_player)
	_subway_player.play()

	_neon_player = AudioStreamPlayer.new()
	_neon_player.name = "NeonFlickerPlayer"
	_neon_player.stream = ProceduralAudio.create_neon_flicker_sound()
	_neon_player.bus = &"Master"
	_neon_player.volume_db = -10.0
	add_child(_neon_player)
	_neon_player.play()

	_pa_player = AudioStreamPlayer.new()
	_pa_player.name = "PaChimePlayer"
	_pa_player.stream = ProceduralAudio.create_pa_chime_sound()
	_pa_player.bus = &"Master"
	_pa_player.volume_db = -4.0
	add_child(_pa_player)

	_terminal_player = AudioStreamPlayer.new()
	_terminal_player.name = "TerminalPlayer"
	_terminal_player.stream = ProceduralAudio.create_terminal_keypress_sound()
	_terminal_player.bus = &"Master"
	_terminal_player.volume_db = -2.0
	add_child(_terminal_player)

	_door_player = AudioStreamPlayer.new()
	_door_player.name = "DoorAudioPlayer"
	_door_player.stream = ProceduralAudio.create_apartment_door_sound()
	_door_player.bus = &"Master"
	add_child(_door_player)

	_blip_player = AudioStreamPlayer.new()
	_blip_player.name = "BlipAudioPlayer"
	_blip_player.bus = &"Master"
	add_child(_blip_player)


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
	_neon_flicker = 0.85 + 0.15 * sin(_pulse_time * 18.0) * cos(_pulse_time * 42.0)

	if is_stabilization_active and _stabilizer_beam_progress < 1.0:
		_stabilizer_beam_progress = minf(1.0, _stabilizer_beam_progress + delta * 1.5)
		queue_redraw()

	if is_child_evacuated and _child_pos_y < 275.0:
		_child_pos_x = minf(140.0, _child_pos_x + delta * 45.0)
		_child_pos_y = minf(275.0, _child_pos_y + delta * 50.0)
		queue_redraw()

	if is_gate_unlocked and _gate_open_progress < 1.0:
		_gate_open_progress = minf(1.0, _gate_open_progress + delta * 0.9)
		queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if dialogue_active:
		if event.is_action_pressed(&"interact") or event.is_action_pressed(&"jump"):
			advance_dialogue()
			get_viewport().set_input_as_handled()


func _on_prop_resonance(id: String, prop_type: int) -> void:
	clue_inspected.emit(id, prop_type)

	match prop_type:
		MemoryResonancePoint.PropType.UCP_INFO_TERMINAL:
			terminal_inspected = true
			if not dialogue_active and not is_dialogue_completed:
				start_dialogue()
			elif is_dialogue_completed:
				_check_unlock_conditions()
		MemoryResonancePoint.PropType.SHOWCASE_VITRINE:
			vitrine_inspected = true
			_check_unlock_conditions()
		MemoryResonancePoint.PropType.INSTRUCTION_POSTER:
			poster_inspected = true
			_check_unlock_conditions()
		MemoryResonancePoint.PropType.SUBWAY_TILE_PILLAR:
			pillar_inspected = true
			_check_unlock_conditions()
		MemoryResonancePoint.PropType.UNDERPASS_EXIT_GATE:
			gate_inspected = true

	queue_redraw()


func trigger_stabilization_procedure() -> void:
	is_stabilization_active = true
	stabilization_triggered.emit()

	# Child safely runs down to warden
	is_child_evacuated = true
	child_evacuated.emit()

	is_safety_demonstrated = true
	_check_unlock_conditions()
	queue_redraw()


func start_dialogue() -> void:
	dialogue_active = true
	dialogue_index = 0
	safety_dialogue_started.emit()
	_play_line_audio(0)
	queue_redraw()


func advance_dialogue() -> int:
	if not dialogue_active:
		return -1

	dialogue_index += 1

	# Line 4: Trigger stabilization & child evacuation
	if dialogue_index == 4 and not is_stabilization_active:
		trigger_stabilization_procedure()

	if dialogue_index >= dialogue_lines.size():
		dialogue_active = false
		is_dialogue_completed = true
		safety_dialogue_completed.emit()
		_check_unlock_conditions()
		queue_redraw()
		return -1

	safety_dialogue_advanced.emit(dialogue_index)
	_play_line_audio(dialogue_index)
	queue_redraw()
	return dialogue_index


func _play_line_audio(idx: int) -> void:
	if idx < 0 or idx >= dialogue_lines.size():
		return

	var line := dialogue_lines[idx]
	if _blip_player:
		if line.get("is_pa", false):
			_blip_player.stream = ProceduralAudio.create_pa_chime_sound()
			_blip_player.pitch_scale = 1.0
			_blip_player.play()
		elif line.get("is_warden", false):
			_blip_player.stream = ProceduralAudio.create_dialogue_blip_sound(false)
			_blip_player.pitch_scale = randf_range(0.94, 0.98)
			_blip_player.play()
		elif line.get("is_lena", false):
			_blip_player.stream = ProceduralAudio.create_dialogue_blip_sound(true)
			_blip_player.pitch_scale = randf_range(0.98, 1.02)
			_blip_player.play()
		elif line.get("is_terminal", false):
			_blip_player.stream = ProceduralAudio.create_terminal_keypress_sound()
			_blip_player.pitch_scale = randf_range(0.98, 1.02)
			_blip_player.play()
		elif line.get("is_stage_direction", false):
			_blip_player.stream = ProceduralAudio.create_ucp_stabilizer_beam_sound()
			_blip_player.pitch_scale = 1.0
			_blip_player.play()


func _check_unlock_conditions() -> void:
	# Unlock underpass security exit gate once safety demonstrated & terminal verified
	if is_safety_demonstrated and terminal_inspected and not is_gate_unlocked:
		is_gate_unlocked = true
		underpass_gate_unlocked.emit()
		if _door_player:
			_door_player.play()

		if props:
			var gate_prop := props.get_node_or_null("UnderpassExitGate") as MemoryResonancePoint
			if gate_prop:
				gate_prop.is_activated = true

		queue_redraw()


func _on_airlock_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and not is_level_completed:
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	_draw_subway_tile_walls()
	_draw_ceiling_and_lights()
	_draw_overlapping_staircase_zone()
	_draw_floor_and_signs()
	_draw_npcs()
	if dialogue_active:
		_draw_dialogue_overlay()


func _draw_subway_tile_walls() -> void:
	# Deep background subterranean wall
	draw_rect(Rect2(0.0, 0.0, LEVEL_WIDTH, 360.0), COLOR_BACKGROUND)

	# Subterranean ceramic tile wall (x = 0..640, y = 40..280)
	var wall_rect := Rect2(0.0, 40.0, LEVEL_WIDTH, 240.0)
	draw_rect(wall_rect, COLOR_SUBWAY_TILE)

	# Tile grout grid (16x10 px tiles)
	for gy in range(40, 280, 10):
		draw_line(Vector2(0.0, float(gy)), Vector2(LEVEL_WIDTH, float(gy)), Color("1a242a"), 1.0)
	for gx in range(0, int(LEVEL_WIDTH), 16):
		draw_line(Vector2(float(gx), 40.0), Vector2(float(gx), 280.0), Color("1a242a"), 0.8)

	# Top decorative institutional ceramic border strip (Sage / Cinnabar band)
	draw_rect(Rect2(0.0, 52.0, LEVEL_WIDTH, 4.0), COLOR_INFRASTRUCTURE * 0.8)
	draw_rect(Rect2(0.0, 56.0, LEVEL_WIDTH, 2.0), COLOR_CORRECTION * 0.7)


func _draw_ceiling_and_lights() -> void:
	# Heavy subterranean concrete ceiling slab
	draw_rect(Rect2(0.0, 0.0, LEVEL_WIDTH, 40.0), COLOR_UNDERPASS_CEILING)
	draw_line(Vector2(0.0, 40.0), Vector2(LEVEL_WIDTH, 40.0), COLOR_INFRASTRUCTURE, 1.2)

	# Suspended fluorescent strip lights along underpass ceiling
	var light_positions: Array[float] = [80.0, 200.0, 340.0, 480.0, 580.0]
	for lx in light_positions:
		# Light fixture housing
		draw_rect(Rect2(lx - 25.0, 36.0, 50.0, 4.0), Color("32424a"))
		# Fluorescent tube with flicker
		var tube_col := Color(0.85, 0.95, 0.98, 0.85 * _neon_flicker)
		draw_rect(Rect2(lx - 22.0, 38.0, 44.0, 2.0), tube_col)
		# Downward soft cone of light
		var cone_poly: PackedVector2Array = [
			Vector2(lx - 20.0, 40.0),
			Vector2(lx + 20.0, 40.0),
			Vector2(lx + 45.0, 280.0),
			Vector2(lx - 45.0, 280.0)
		]
		draw_colored_polygon(cone_poly, Color(0.75, 0.90, 0.95, 0.04 * _neon_flicker))


func _draw_overlapping_staircase_zone() -> void:
	# Dual overlapping staircase anomaly zone (x = 30..180)
	# Shifted reality ghost staircase (oxide cinnabar wireframe & misaligned steps)
	var ghost_steps: Array[Vector2] = [
		Vector2(40.0, 280.0),
		Vector2(65.0, 255.0),
		Vector2(90.0, 230.0),
		Vector2(115.0, 205.0),
		Vector2(140.0, 180.0)
	]
	for i in range(ghost_steps.size() - 1):
		var p1 := ghost_steps[i]
		var p2 := ghost_steps[i + 1]
		# Discontinuity offset line
		var offset := sin(_pulse_time * 3.0 + float(i)) * 2.5
		var col := COLOR_CORRECTION * (0.45 if is_stabilization_active else 0.8)
		draw_line(Vector2(p1.x, p1.y + offset), Vector2(p2.x, p1.y + offset), col, 1.5)
		draw_line(Vector2(p2.x, p1.y + offset), Vector2(p2.x, p2.y + offset), col, 1.5)

	# Real stabilized concrete staircase structure
	for s_idx in range(5):
		var sx := 40.0 + float(s_idx) * 25.0
		var sy := 280.0 - float(s_idx) * 20.0
		var step_rect := Rect2(sx, sy, 35.0, 20.0)
		draw_rect(step_rect, COLOR_CONCRETE)
		draw_rect(step_rect, COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
		# Steel step nosing
		draw_line(Vector2(sx, sy), Vector2(sx + 35.0, sy), COLOR_INFRASTRUCTURE, 1.5)

	# UCP Field Stabilization Beam & Pylons (Cyan energy bridge holding steps)
	if is_stabilization_active:
		var beam_alpha := 0.65 + 0.35 * sin(_pulse_time * 8.0)
		var beam_col := Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, beam_alpha * _stabilizer_beam_progress)
		# Energy contour along the stairway
		draw_line(Vector2(38.0, 280.0), Vector2(165.0, 180.0), beam_col, 2.5)
		draw_line(Vector2(40.0, 282.0), Vector2(167.0, 182.0), Color(beam_col.r, beam_col.g, beam_col.b, beam_alpha * 0.4), 4.5)

	# Upper landing platform (x = 40..100, y = 200)
	draw_rect(Rect2(40.0, 200.0, 60.0, 12.0), COLOR_CONCRETE)
	draw_line(Vector2(40.0, 200.0), Vector2(100.0, 200.0), COLOR_INFRASTRUCTURE, 1.5)


func _draw_floor_and_signs() -> void:
	# Main Underpass Floor (Concrete and terrazzo slab, y = 280..360)
	var floor_rect := Rect2(0.0, 280.0, LEVEL_WIDTH, 80.0)
	draw_rect(floor_rect, COLOR_CONCRETE)
	draw_line(Vector2(0.0, 280.0), Vector2(LEVEL_WIDTH, 280.0), COLOR_INFRASTRUCTURE, 1.5)

	# Floor tile joint lines
	for fx in range(0, int(LEVEL_WIDTH), 32):
		draw_line(Vector2(float(fx), 280.0), Vector2(float(fx), 360.0), Color("1d272e"), 1.0)

	# Large Institutional Neon Signboard above center wall: "UCP // PUNKT OBSŁUGI ZGODNOŚCI 6"
	var sign_box := Rect2(260.0, 48.0, 180.0, 22.0)
	draw_rect(sign_box, Color("141c22"))
	draw_rect(sign_box, COLOR_DARK_STEEL, false, 1.2)
	# Neon tubes in signboard
	var neon_col := Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.9 * _neon_flicker)
	draw_rect(Rect2(265.0, 52.0, 70.0, 6.0), neon_col * 0.8)
	draw_rect(Rect2(340.0, 52.0, 95.0, 6.0), neon_col * 0.8)
	draw_line(Vector2(265.0, 63.0), Vector2(435.0, 63.0), COLOR_AMBER * 0.8, 1.0)


func _draw_npcs() -> void:
	# UCP Safety Warden standing near evacuation boundary: x = 165, y = 280
	var wx: float = 165.0
	var wy: float = 280.0
	# Long institutional charcoal/sage coat
	draw_rect(Rect2(wx - 5.0, wy - 28.0, 10.0, 20.0), Color("263740"))
	draw_rect(Rect2(wx - 5.0, wy - 28.0, 10.0, 20.0), Color("182329"), false, 0.8)
	# Trousers & boots
	draw_rect(Rect2(wx - 4.0, wy - 8.0, 3.5, 8.0), Color("151e24"))
	draw_rect(Rect2(wx + 0.5, wy - 8.0, 3.5, 8.0), Color("151e24"))
	# UCP arm badge (Cyan band)
	draw_rect(Rect2(wx - 5.0, wy - 24.0, 2.5, 4.0), COLOR_CYAN)
	# Head & Officer Cap
	draw_circle(Vector2(wx, wy - 31.0), 3.5, Color("182329"))
	draw_circle(Vector2(wx, wy - 30.5), 2.2, COLOR_AMBER * 0.8)
	# Handheld Field Stabilizer Wand
	draw_line(Vector2(wx - 6.0, wy - 18.0), Vector2(wx - 14.0, wy - 22.0), COLOR_INFRASTRUCTURE, 1.8)
	draw_circle(Vector2(wx - 14.0, wy - 22.0), 2.0, COLOR_CYAN if is_stabilization_active else COLOR_AMBER)

	# Stranded Child on stairs/platform: (_child_pos_x, _child_pos_y)
	var cx: float = _child_pos_x
	var cy: float = _child_pos_y
	# Bright warm coat (Yellow/Amber)
	draw_rect(Rect2(cx - 3.5, cy - 14.0, 7.0, 10.0), Color("c4923e"))
	draw_rect(Rect2(cx - 3.5, cy - 14.0, 7.0, 10.0), Color("8a6322"), false, 0.6)
	# Boots
	draw_rect(Rect2(cx - 3.0, cy - 4.0, 2.5, 4.0), Color("1b1510"))
	draw_rect(Rect2(cx + 0.5, cy - 4.0, 2.5, 4.0), Color("1b1510"))
	# Head / Woolen beanie
	draw_circle(Vector2(cx, cy - 16.5), 3.0, Color("8f382a"))
	draw_circle(Vector2(cx, cy - 16.0), 1.8, COLOR_AMBER * 0.9)


func _draw_dialogue_overlay() -> void:
	if dialogue_index < 0 or dialogue_index >= dialogue_lines.size():
		return

	var line := dialogue_lines[dialogue_index]
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_lena: bool = line.get("is_lena", false)
	var is_terminal: bool = line.get("is_terminal", false)
	var is_stage: bool = line.get("is_stage_direction", false)

	var box_y := 16.0
	var box_rect := Rect2(60.0, box_y, LEVEL_WIDTH - 120.0, 52.0)

	# Institutional dialogue substrate
	draw_rect(box_rect, Color(0.09, 0.13, 0.16, 0.92))
	var border_col := COLOR_CYAN if is_terminal else (COLOR_AMBER if is_lena else (COLOR_CORRECTION if is_stage else COLOR_INFRASTRUCTURE))
	draw_rect(box_rect, border_col, false, 1.2)

	# Speaker Badge
	var badge_rect := Rect2(72.0, box_y - 8.0, 195.0, 14.0)
	draw_rect(badge_rect, Color("121b21"))
	draw_rect(badge_rect, border_col, false, 0.8)

	var font: Font = ThemeDB.fallback_font
	if font:
		draw_string(font, Vector2(76.0, box_y + 3.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, 190.0, 10, border_col)
		# Subtitle / Line text
		var text_col := Color("edf2ee") if not is_terminal else COLOR_CYAN
		draw_string(font, Vector2(74.0, box_y + 24.0), text, HORIZONTAL_ALIGNMENT_LEFT, LEVEL_WIDTH - 120.0, 9, text_col)
		# Advance hint
		var prompt_str := "[SPACJA / E: DALEJ]"
		draw_string(font, Vector2(LEVEL_WIDTH - 170.0, box_y + 44.0), prompt_str, HORIZONTAL_ALIGNMENT_RIGHT, 100.0, 9, COLOR_INFRASTRUCTURE * 0.7)
