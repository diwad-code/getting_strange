class_name Station14
extends Node2D

## Station 14 (Przestrzeń 14: Zakotwiczenie / Schowek techniczny, rysa w metalu i degradacja nagrania) for Getting Strange Vertical Slice.
## Represents the cramped technical closet / maintenance chamber behind apartment 14's wall.
## Features shifting structural frames, maintenance tool racks, an observed scratch in the steel column acting
## as the primary anchor, a hydraulic seam stabilizer lever, an archival reel tape player exhibiting voice degradation,
## the 3rd-second silence clue proving Lena's home branch was previously corrected (Clue R-04/R-05), and the Substructure conduit shaft.
## Conforms to VISUAL_DESIGN.md (Section 6.1 Zakotwiczenie, Cyan holds one edge), FULL_STORY.md (Scene 14), and CONTINUITY_TRACKER.md (Clues R-04 and R-05).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("141c21") # Dark sea graphite
const COLOR_CHAMBER_WALL := Color("192329")
const COLOR_INFRASTRUCTURE := Color("a8b2ac") # Grey sage
const COLOR_AMBER := Color("d39a62") # Muted amber (Lena / Warmth)
const COLOR_CYAN := Color("75c7c3") # Cool cyan (Anchor Resonance / "cyjan zatrzymuje jedną krawędź")
const COLOR_CORRECTION := Color("c65d58") # Oxide cinnabar (Seam tension / Discontinuity)
const COLOR_DARK_STEEL := Color("24333b")
const COLOR_CONCRETE := Color("202a30")
const COLOR_BEAM_FRAME := Color("2c3c46")

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal rack_searched()
signal scratch_anchored()
signal seam_clamped()
signal tape_playback_started()
signal silence_gap_discovered()
signal substructure_shaft_unlocked()
signal dialogue_started()
signal dialogue_advanced(line_idx: int)
signal dialogue_completed()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone

var rack_inspected: bool = false
var is_scratch_anchored: bool = false
var is_seam_clamped: bool = false
var is_tape_playing: bool = false
var is_silence_discovered: bool = false
var is_shaft_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _seam_drift_phase: float = 0.0
var _anchor_glow_progress: float = 0.0
var _tape_progress: float = 0.0
var _shaft_open_progress: float = 0.0
var _pulse_time: float = 0.0

# Dialogue & Narrative Readouts for Space 14 (per FULL_STORY.md Scene 14, CONTINUITY_TRACKER.md R-04/R-05, NEXT_SESSION_PROMPT.md)
var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "LENA",
		"text": "Schowek techniczny za ścianą czternastki... Przestrzeń jest niestabilna. Dwie wersje konstrukcji nakładają się na siebie.",
		"is_witness": false,
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "MARTA",
		"text": "To szew konstrukcyjny. Jeśli nie utrzymasz jednego stałego punktu, ściana przesunie się i odetnie szyb.",
		"is_witness": false,
		"is_lena": false,
		"is_marta": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Trzymanie szwu... Muszę skupić uwagę na jednym fizycznym detalu. Ta rysa na stalowej belce — pojedyncza bruzda w metalu.",
		"is_witness": false,
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Obserwujesz rysę w metalu. Krawędź rozbłyskuje chłodnym cyjanem. Drżenie konstrukcji zwalnia, gdy reszta pomieszczenia dopasowuje się do kotwicy.",
		"is_witness": true,
		"is_lena": false,
		"is_marta": false,
		"is_stage_direction": true
	},
	{
		"speaker": "MARTA",
		"text": "Działa. Trzymasz szew. W dokumentach UCP nazywają to Zakotwiczeniem.",
		"is_witness": false,
		"is_lena": false,
		"is_marta": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Kotwica utrzymała geometrię, ale... coś się zmieniło. Taśma w odtwarzaczu. Nagranie głosu Jakuba.",
		"is_witness": false,
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Uruchamiasz odtwarzacz taśmowy. Głos brata jest przytłumiony, jakby oddalił się o kilkanaście lat.",
		"is_witness": true,
		"is_lena": false,
		"is_marta": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Głos uległ degradacji... Użycie kotwicy niszczy prywatne znaczenie przedmiotu. Szukam miejsca, w którym taśma ucierpiała...",
		"is_witness": false,
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Odsłuchujesz taśmę od początku. W trzeciej sekundzie pojawia się nagła, idealna cisza.",
		"is_witness": true,
		"is_lena": false,
		"is_marta": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Ta cisza w trzeciej sekundzie... To nie dzisiejsza kotwica. To nagranie zawsze miało tę przerwę.",
		"is_witness": false,
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Mój świat... moja gałąź także nosiła ślady korekty na długo przed moim przybyciem. Nie ma pierwotnego oryginału.",
		"is_witness": false,
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Stabilizator szwu rygluje się. Właz pionowego szybu do Podstruktury staje otworem.",
		"is_witness": true,
		"is_lena": false,
		"is_marta": false,
		"is_stage_direction": true
	}
]


func _ready() -> void:
	if camera:
		camera.chamber_bounds = [Rect2(Vector2.ZERO, VIEW_SIZE)]
		camera.set_chamber(0, true)
	
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_zone_body_entered)
	
	_connect_prop_signals()
	station_entered.emit()
	queue_redraw()


func _connect_prop_signals() -> void:
	if not props:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			child.resonance_triggered.connect(_on_prop_resonance_triggered)


func _process(delta: float) -> void:
	_pulse_time += delta
	
	# Seam drift oscillation when unanchored vs locked
	if not is_scratch_anchored:
		_seam_drift_phase += delta * 3.5
	else:
		_seam_drift_phase = lerpf(_seam_drift_phase, 0.0, delta * 4.0)
		_anchor_glow_progress = minf(1.0, _anchor_glow_progress + delta * 2.0)
	
	# Tape playback progress
	if is_tape_playing and _tape_progress < 1.0:
		_tape_progress = minf(1.0, _tape_progress + delta * 0.45)
		if _tape_progress >= 0.5 and not is_silence_discovered:
			is_silence_discovered = true
			silence_gap_discovered.emit()
	
	# Substructure shaft unlock animation
	if is_shaft_unlocked and _shaft_open_progress < 1.0:
		_shaft_open_progress = minf(1.0, _shaft_open_progress + delta * 1.4)
	
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"interact"):
		if dialogue_active:
			advance_dialogue()
		else:
			_check_player_interactions()


func _check_player_interactions() -> void:
	if not props:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint and child.is_player_in_range:
			child.trigger_interaction()
			break


func _on_prop_resonance_triggered(id: String, type_idx: int) -> void:
	clue_inspected.emit(id, type_idx)
	
	if id == "prop_maintenance_rack":
		rack_inspected = true
		rack_searched.emit()
		if not dialogue_active and dialogue_index < 0:
			start_dialogue(0)
	elif id == "prop_scratch_beam":
		anchor_scratch()
	elif id == "prop_seam_lever":
		toggle_seam_stabilizer()
	elif id == "prop_tape_deck":
		start_tape_playback()
	elif id == "prop_conduit_shaft":
		if is_shaft_unlocked:
			complete_level()


func anchor_scratch() -> void:
	if is_scratch_anchored:
		return
	is_scratch_anchored = true
	scratch_anchored.emit()
	
	var beam_prop := props.get_node_or_null("MetalScratchBeam") as MemoryResonancePoint
	if beam_prop:
		beam_prop.is_activated = true
		beam_prop.shadow_progress = 1.0
	
	if camera:
		camera.add_trauma(0.35)
	
	if not dialogue_active or dialogue_index < 2:
		start_dialogue(2)


func toggle_seam_stabilizer() -> void:
	is_seam_clamped = not is_seam_clamped
	seam_clamped.emit()
	
	var lever_prop := props.get_node_or_null("SeamStabilizerLever") as MemoryResonancePoint
	if lever_prop:
		lever_prop.is_activated = is_seam_clamped
	
	# If scratch is anchored and lever is engaged, unlock the conduit shaft
	if is_scratch_anchored and is_seam_clamped:
		unlock_substructure_shaft()


func start_tape_playback() -> void:
	if is_tape_playing:
		return
	is_tape_playing = true
	tape_playback_started.emit()
	
	var tape_prop := props.get_node_or_null("TapePlaybackDeck") as MemoryResonancePoint
	if tape_prop:
		tape_prop.is_activated = true
	
	if not dialogue_active or dialogue_index < 5:
		start_dialogue(5)


func unlock_substructure_shaft() -> void:
	if is_shaft_unlocked:
		return
	is_shaft_unlocked = true
	substructure_shaft_unlocked.emit()
	
	var shaft_prop := props.get_node_or_null("SubstructureConduitShaft") as MemoryResonancePoint
	if shaft_prop:
		shaft_prop.is_activated = true


func start_dialogue(start_idx: int = 0) -> void:
	dialogue_active = true
	dialogue_index = start_idx
	dialogue_started.emit()
	queue_redraw()


func advance_dialogue() -> int:
	if not dialogue_active:
		return -1
	
	dialogue_index += 1
	
	# Narrative progression triggers tied to dialogue beats
	if dialogue_index == 3:
		# Observation of scratch locks anchor
		if not is_scratch_anchored:
			is_scratch_anchored = true
			scratch_anchored.emit()
			var beam_prop := props.get_node_or_null("MetalScratchBeam") as MemoryResonancePoint
			if beam_prop:
				beam_prop.is_activated = true
				beam_prop.shadow_progress = 1.0
			if camera:
				camera.add_trauma(0.35)
	elif dialogue_index == 6:
		# Tape starts playback and degradation is noticed
		if not is_tape_playing:
			is_tape_playing = true
			tape_playback_started.emit()
			var tape_prop := props.get_node_or_null("TapePlaybackDeck") as MemoryResonancePoint
			if tape_prop:
				tape_prop.is_activated = true
	elif dialogue_index == 9:
		# 3rd-second silence discovered
		is_silence_discovered = true
		silence_gap_discovered.emit()
	elif dialogue_index == 11:
		# Final realization: unlock the conduit shaft
		is_seam_clamped = true
		var lever_prop := props.get_node_or_null("SeamStabilizerLever") as MemoryResonancePoint
		if lever_prop:
			lever_prop.is_activated = true
		unlock_substructure_shaft()
	
	if dialogue_index >= dialogue_lines.size():
		dialogue_active = false
		is_dialogue_completed = true
		dialogue_completed.emit()
		queue_redraw()
		return -1
	
	dialogue_advanced.emit(dialogue_index)
	queue_redraw()
	return dialogue_index


func complete_level() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _on_airlock_zone_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_shaft_unlocked:
		complete_level()


func _draw() -> void:
	_draw_technical_chamber_background()
	_draw_shifting_framework()
	_draw_conduit_lines()
	
	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_box()


func _draw_technical_chamber_background() -> void:
	# Background rectangle: narrow, cramped service bay
	var bg_rect := Rect2(Vector2.ZERO, VIEW_SIZE)
	draw_rect(bg_rect, COLOR_BACKGROUND)
	
	# Vertical service studs & structural partitions
	for x in range(50, 640, 70):
		var drift_offset := sin(_seam_drift_phase + float(x) * 0.05) * 2.5 if not is_scratch_anchored else 0.0
		draw_line(Vector2(float(x) + drift_offset, 35.0), Vector2(float(x), 290.0), Color("1a262e"), 1.2)
	
	# Horizontal cable trays and conduit brackets
	for y in [80, 130, 180, 230]:
		draw_line(Vector2(0.0, float(y)), Vector2(LEVEL_WIDTH, float(y)), Color("1e2a32"), 1.0)
	
	# Concrete floor base (y=290..360)
	var floor_rect := Rect2(0.0, 290.0, LEVEL_WIDTH, 70.0)
	draw_rect(floor_rect, COLOR_CONCRETE)
	draw_line(Vector2(0.0, 290.0), Vector2(LEVEL_WIDTH, 290.0), COLOR_INFRASTRUCTURE * 0.9, 1.5)
	
	# Steel baseplate guide rail with anchoring calibration notches
	draw_rect(Rect2(0.0, 284.0, LEVEL_WIDTH, 6.0), Color("172228"))
	draw_line(Vector2(0.0, 284.0), Vector2(LEVEL_WIDTH, 284.0), Color("2d3e48"), 1.0)
	for nx in range(20, 640, 20):
		draw_line(Vector2(float(nx), 284.0), Vector2(float(nx), 288.0), Color("3a4f5c"), 0.8)
	
	# Heavy upper structural steel beam & ceiling conduit tray (y=0..35)
	draw_rect(Rect2(0.0, 0.0, LEVEL_WIDTH, 35.0), Color("10161a"))
	draw_line(Vector2(0.0, 35.0), Vector2(LEVEL_WIDTH, 35.0), Color("233139"), 1.5)


func _draw_shifting_framework() -> void:
	# Seam area between x=220 and x=400 where the two versions of the room collide
	var seam_x := 310.0
	var drift := sin(_seam_drift_phase) * 4.0 if not is_scratch_anchored else 0.0
	
	# Left structural partition (Version A)
	var col_a := COLOR_BEAM_FRAME
	draw_rect(Rect2(210.0 + drift, 45.0, 18.0, 240.0), Color("1a252c"))
	draw_rect(Rect2(210.0 + drift, 45.0, 18.0, 240.0), col_a, false, 1.0)
	
	# Right structural partition (Version B)
	var col_b := Color("223540") if not is_scratch_anchored else COLOR_BEAM_FRAME
	draw_rect(Rect2(360.0 - drift * 0.8, 45.0, 18.0, 240.0), Color("182329"))
	draw_rect(Rect2(360.0 - drift * 0.8, 45.0, 18.0, 240.0), col_b, false, 1.0)
	
	# Seam tension lines across the chamber
	if not is_scratch_anchored:
		# Unanchored: cinnabar stress lines ("dług sprzeczności")
		var stress_col := Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.45 + sin(_pulse_time * 6.0) * 0.25)
		draw_line(Vector2(seam_x + drift, 50.0), Vector2(seam_x - drift, 285.0), stress_col, 1.2)
		draw_line(Vector2(228.0 + drift, 120.0), Vector2(360.0 - drift, 120.0), stress_col * 0.7, 0.8)
		draw_line(Vector2(228.0 + drift, 200.0), Vector2(360.0 - drift, 200.0), stress_col * 0.7, 0.8)
	else:
		# Anchored: Pure cyan anchoring stabilization web holding the seam
		var cyan_pull := Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.55)
		# Tension lines converging onto the scratch beam at (260, 230)
		draw_line(Vector2(210.0, 70.0), Vector2(260.0, 230.0), cyan_pull * 0.6, 1.0)
		draw_line(Vector2(360.0, 70.0), Vector2(260.0, 230.0), cyan_pull * 0.6, 1.0)
		draw_line(Vector2(360.0, 230.0), Vector2(260.0, 230.0), cyan_pull * 0.9, 1.5)
		draw_line(Vector2(210.0, 230.0), Vector2(260.0, 230.0), cyan_pull * 0.9, 1.5)


func _draw_conduit_lines() -> void:
	# Heavy industrial cables linking props across the technical closet
	var cable_dark := Color("10171c")
	
	# Cable 1: Maintenance Rack (x=140, y=260) to Scratch Beam (x=260, y=230)
	draw_line(Vector2(140.0, 275.0), Vector2(260.0, 275.0), cable_dark, 3.0)
	draw_line(Vector2(260.0, 275.0), Vector2(260.0, 255.0), cable_dark, 3.0)
	draw_line(Vector2(140.0, 275.0), Vector2(260.0, 275.0), Color("2d3d47"), 1.0)
	
	# Cable 2: Scratch Beam (x=260, y=230) to Seam Lever (x=360, y=270)
	draw_line(Vector2(260.0, 275.0), Vector2(360.0, 275.0), cable_dark, 3.0)
	if is_scratch_anchored:
		var glow_cyan := Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.7)
		draw_line(Vector2(260.0, 275.0), Vector2(360.0, 275.0), glow_cyan, 1.2)
	
	# Cable 3: Seam Lever (x=360, y=270) to Tape Deck (x=470, y=265)
	draw_line(Vector2(360.0, 275.0), Vector2(470.0, 275.0), cable_dark, 3.0)
	draw_line(Vector2(470.0, 275.0), Vector2(470.0, 272.0), cable_dark, 3.0)
	
	# Cable 4: Tape Deck (x=470, y=265) to Substructure Shaft (x=580, y=250)
	draw_line(Vector2(470.0, 275.0), Vector2(580.0, 275.0), cable_dark, 3.0)
	if is_shaft_unlocked:
		var pulse_glow := sin(_pulse_time * 4.5) * 0.3 + 0.7
		draw_line(Vector2(470.0, 275.0), Vector2(580.0, 275.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, pulse_glow), 1.5)


func _draw_dialogue_box() -> void:
	var line: Dictionary = dialogue_lines[dialogue_index]
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_witness: bool = line.get("is_witness", false)
	var is_lena: bool = line.get("is_lena", false)
	var is_marta: bool = line.get("is_marta", false)
	var is_stage_direction: bool = line.get("is_stage_direction", false)
	
	var box_rect := Rect2(60.0, 280.0, 520.0, 68.0)
	draw_rect(box_rect, Color(0.07, 0.11, 0.14, 0.95))
	
	# Border color
	var border_color := COLOR_INFRASTRUCTURE
	if is_witness:
		border_color = COLOR_CORRECTION
	elif is_lena:
		border_color = COLOR_AMBER
	elif is_marta:
		border_color = COLOR_CYAN
	
	draw_rect(box_rect, border_color, false, 1.2)
	
	# Header bar with speaker name
	var header_rect := Rect2(60.0, 280.0, 520.0, 18.0)
	draw_rect(header_rect, Color(0.11, 0.16, 0.20, 0.96))
	draw_line(Vector2(60.0, 298.0), Vector2(580.0, 298.0), border_color * 0.7, 1.0)
	
	# Speaker tag
	var default_font := ThemeDB.fallback_font
	if default_font:
		var speaker_col := COLOR_AMBER if is_lena else (COLOR_CYAN if is_marta else (COLOR_CORRECTION if is_witness else COLOR_INFRASTRUCTURE))
		draw_string(default_font, Vector2(72.0, 294.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 11, speaker_col)
		
		# Text content
		var text_col := Color("e6ece8") if not is_stage_direction else Color("a2b5ac")
		draw_string(default_font, Vector2(72.0, 314.0), text, HORIZONTAL_ALIGNMENT_LEFT, 496, 11, text_col)
		
		# Next prompt indicator
		var pulse := sin(_pulse_time * 4.0) * 0.5 + 0.5
		var prompt_str := "[E] Dalej..." if dialogue_index < dialogue_lines.size() - 1 else "[E] Zamknij"
		draw_string(default_font, Vector2(510.0, 340.0), prompt_str, HORIZONTAL_ALIGNMENT_RIGHT, -1, 9, Color(border_color.r, border_color.g, border_color.b, 0.5 + pulse * 0.5))
