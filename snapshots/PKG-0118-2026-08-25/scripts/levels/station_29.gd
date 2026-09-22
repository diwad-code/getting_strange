class_name Station29
extends Node2D

## Station 29 (Przestrzeń 29: Peron trzynasty / Otwarcie Aktu III: Podstruktura) for Getting Strange Vertical Slice.
## Features Abandoned Platform 13 at the end of Line 4 tracks on the threshold of the deep Substructure.
## Implements Scene 29 per FULL_STORY.md and NARRATIVE_BIBLE.md:
## Lena and Jakub step out of the technical carriage onto the abandoned 1970s platform,
## rusted rails ending at a concrete buffer stop, dripping water echo, flickering neon "PERON 13",
## deep ventilation shaft resonating with Substructure pressure compensators,
## Jakub's industrial battery torch lighting the way to the rusted security grate leading to Space 30 (Sektor Zasilania).
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 29).

## PRZESZKODA — dlaczego to tu jest: fizyczna przeszkoda nie jest potrzebna;
## peron jest materialnym progiem wejścia do głębszej Podstruktury.
## PRZESZKODA — czego wymaga od Leny: rozpoznania torów, szybu i światła jako
## świadectw miejsca, nie jako celów zręcznościowych.
## PRZESZKODA — koszt porażki: nie ma fizycznej korekty; po przejściu progu
## pozostaje cisza po wygaszonym znaku.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("0b1013")
const COLOR_PLATFORM_TILES := Color("151d22")
const COLOR_TUNNEL_VAULT := Color("212c33")
const COLOR_INFRASTRUCTURE := Color("3e5866")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.22)
const COLOR_BEIGE_ASH := Color("c8a370")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CYAN_TECH := Color("5da398")
const COLOR_CORRECTION := Color("c65d58")

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal tracks_inspected()
signal neon_inspected()
signal well_inspected()
signal beacon_inspected()
signal exit_unlocked()
signal dialogue_started()
signal dialogue_advanced(line_idx: int)
signal dialogue_completed()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone

var is_tracks_inspected: bool = false
var is_neon_inspected: bool = false
var is_well_inspected: bool = false
var is_beacon_inspected: bool = false
var is_exit_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _exit_open_progress: float = 0.0

var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Pneumatyczne drzwi wagonu otwierają się z sykiem. Przed Leną i Jakubem rozpościera się zapomniana stacja — Peron Trzynasty.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_stage_direction": true
	},
	{
		"speaker": "JAKUB",
		"text": "Koniec torowiska Linii 4. Dalej nie ma już rozkładów jazdy ani dyspozytury.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Ten peron wygląda jak wybudowany w latach siedemdziesiątych i porzucony w połowie zmiany.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Bo tak było. Zbudowali go jako bufor bezpieczeństwa przed tym, co jest niżej.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Zardzewiałe szyny kończą się na betonowym koźle oporowym. W powietrzu unosi się ciężki zapach ozonu i mokrego betonu.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Słyszysz ten dźwięk w głębi szybu? Jakby całe miasto opierało się na pracujących pompach.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "To nie pompy. To kompensatory naprężeń. Każda wymazana prawda na powierzchni dodaje tu jeden bar ciśnienia.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Neon nad peronem migocze nieregularnym rytmem. Światło latarki Jakuba wyławia z mroku stalową kratę rewizyjną.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_stage_direction": true
	},
	{
		"speaker": "JAKUB",
		"text": "Za tą kratą zaczyna się Sektor Zasilania. Jeśli tam wejdziemy, Wierzbicka nie cofnie już blokady.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Nie wracamy, Jakub. Otwórzmy to.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Rdzawa krata ustępuje z głuchym jękiem metalu. Otwiera się droga w głąb właściwej Podstruktury. Akt Trzeci rozpoczyna się.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_stage_direction": true
	}
]


func _ready() -> void:
	_setup_station()
	_connect_signals()
	station_entered.emit()


func _process(delta: float) -> void:
	_pulse_time += delta
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 1.5)
	queue_redraw()


func _setup_station() -> void:
	if camera:
		camera.setup_chambers([Rect2(Vector2.ZERO, VIEW_SIZE)])
		camera.set_chamber(0, false)
	if player:
		player.reset_to(Vector2(50.0, 240.0))


func _connect_signals() -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint:
				child.resonance_triggered.connect(_on_resonance_triggered)
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_entered)


func _on_resonance_triggered(id: String, type_idx: int) -> void:
	clue_inspected.emit(id, type_idx)
	match type_idx:
		MemoryResonancePoint.PropType.ABANDONED_PLATFORM_TRACKS:
			is_tracks_inspected = true
			tracks_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.FLICKERING_NEON_SIGN:
			is_neon_inspected = true
			neon_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.DEEP_SUBSTRUCTURE_WELL:
			is_well_inspected = true
			well_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.JAKUB_TORCH_BEACON:
			is_beacon_inspected = true
			beacon_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.STATION_29_EXIT:
			if is_exit_unlocked:
				_on_airlock_entered(player)


func start_dialogue() -> void:
	if dialogue_active:
		return
	dialogue_active = true
	dialogue_index = 0
	dialogue_started.emit()
	dialogue_advanced.emit(0)


func advance_dialogue() -> int:
	if not dialogue_active:
		return -1
	
	dialogue_index += 1
	if dialogue_index >= dialogue_lines.size():
		dialogue_active = false
		is_dialogue_completed = true
		dialogue_completed.emit()
		_finish_scene()
		return -1
	
	if dialogue_index == 2:
		# Line 2: Lena inspects platform tiles & neon
		is_neon_inspected = true
		neon_inspected.emit()
		if props:
			var neon_prop := props.get_node_or_null("FlickeringNeon") as MemoryResonancePoint
			if neon_prop:
				neon_prop.is_activated = true
	elif dialogue_index == 4:
		# Line 4: Buffer stop & rusted tracks inspected
		is_tracks_inspected = true
		tracks_inspected.emit()
		if props:
			var trk_prop := props.get_node_or_null("AbandonedTracks") as MemoryResonancePoint
			if trk_prop:
				trk_prop.is_activated = true
	elif dialogue_index == 6:
		# Line 6: Deep well & pressure compensators inspected
		is_well_inspected = true
		well_inspected.emit()
		if props:
			var well_prop := props.get_node_or_null("SubstructureWell") as MemoryResonancePoint
			if well_prop:
				well_prop.is_activated = true
	elif dialogue_index == 8:
		# Line 8: Jakub torch beacon illuminating the security grate
		is_beacon_inspected = true
		beacon_inspected.emit()
		if props:
			var bcn_prop := props.get_node_or_null("JakubBeacon") as MemoryResonancePoint
			if bcn_prop:
				bcn_prop.is_activated = true
	elif dialogue_index == 9:
		# Line 9: Lena agrees to proceed / gate unlatched
		_unlock_exit()
	
	dialogue_advanced.emit(dialogue_index)
	return dialogue_index


func _finish_scene() -> void:
	is_tracks_inspected = true
	is_neon_inspected = true
	is_well_inspected = true
	is_beacon_inspected = true
	_unlock_exit()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	if props:
		var exit_prop := props.get_node_or_null("Station29Exit") as MemoryResonancePoint
		if exit_prop:
			exit_prop.is_activated = true
		var trk_prop := props.get_node_or_null("AbandonedTracks") as MemoryResonancePoint
		if trk_prop:
			trk_prop.is_activated = true
		var neon_prop := props.get_node_or_null("FlickeringNeon") as MemoryResonancePoint
		if neon_prop:
			neon_prop.is_activated = true
		var well_prop := props.get_node_or_null("SubstructureWell") as MemoryResonancePoint
		if well_prop:
			well_prop.is_activated = true
		var bcn_prop := props.get_node_or_null("JakubBeacon") as MemoryResonancePoint
		if bcn_prop:
			bcn_prop.is_activated = true


func _on_airlock_entered(body: Node2D) -> void:
	if not is_exit_unlocked:
		return
	if is_level_completed:
		return
	if body is PrototypePlayer or body == player:
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	_draw_state_layer()
	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_hud(dialogue_lines[dialogue_index])


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	draw_line(Vector2(38.0, 258.0), Vector2(604.0, 258.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	draw_line(Vector2(42.0, 270.0), Vector2(596.0, 270.0), VectorStageStyle.DEEP_PLANE, 2.0)
	var neon_color := VectorStageStyle.CORRECTION_OXIDE if is_neon_inspected else VectorStageStyle.ANCHOR_CYAN
	draw_line(Vector2(420.0, 70.0), Vector2(548.0, 70.0), neon_color, 3.0)
	if is_well_inspected:
		draw_circle(Vector2(332.0, 218.0), 18.0 + sin(_pulse_time * 2.0) * 2.0, VectorStageStyle.DEEP_PLANE)
		draw_arc(Vector2(332.0, 218.0), 24.0, 0.0, TAU, 24, VectorStageStyle.ANCHOR_CYAN, 1.0)
	if is_beacon_inspected:
		draw_line(Vector2(470.0, 210.0), Vector2(540.0, 150.0), VectorStageStyle.HUMAN_AMBER, 2.0)


func _draw_legacy() -> void:
	# 1. Dark Cavernous Platform Ceiling & Vault (640x360)
	var bg_rect := Rect2(0.0, 0.0, VIEW_SIZE.x, VIEW_SIZE.y)
	draw_rect(bg_rect, COLOR_BACKGROUND)
	
	# Vault concrete arch ribs (y=20..280)
	for a in range(8):
		var ax := float(a) * 85.0 + 20.0
		draw_rect(Rect2(ax, 30.0, 22.0, 250.0), COLOR_TUNNEL_VAULT)
		draw_line(Vector2(ax + 11.0, 30.0), Vector2(ax + 11.0, 280.0), Color("0d1519"), 1.2)
	
	# 1970s cracked subway wall tiles along back wall (y=90..270)
	for tx in range(20):
		for ty in range(6):
			var tile_rect := Rect2(float(tx) * 32.0, 90.0 + float(ty) * 30.0, 30.0, 28.0)
			draw_rect(tile_rect, COLOR_PLATFORM_TILES)
			draw_rect(tile_rect, Color("1f2930", 0.4), false, 0.8)
	
	# Moisture seepage streaks down tiled wall
	for m in range(5):
		var mx := 60.0 + float(m) * 115.0
		draw_line(Vector2(mx, 90.0), Vector2(mx + 4.0, 260.0), Color("091216", 0.75), 2.0)
	
	# High voltage conduit pipes and drooping wire bundles along ceiling
	draw_line(Vector2(0.0, 55.0), Vector2(VIEW_SIZE.x, 55.0), Color("2f424d"), 2.5)
	draw_line(Vector2(0.0, 62.0), Vector2(VIEW_SIZE.x, 62.0), Color("d39a62", 0.5), 1.0)
	
	# 2. Platform Floor & Track Pit (y=280..360)
	var floor_rect := Rect2(0.0, 280.0, VIEW_SIZE.x, 80.0)
	draw_rect(floor_rect, Color("080d10"))
	draw_line(Vector2(0.0, 280.0), Vector2(VIEW_SIZE.x, 280.0), COLOR_INFRASTRUCTURE, 2.0)
	draw_line(Vector2(0.0, 282.0), Vector2(VIEW_SIZE.x, 282.0), Color("e2b060", 0.6), 1.0)
	
	# Platform edge tactile warning tiles with yellow chevrons
	for w in range(20):
		var wx := float(w) * 32.0
		draw_rect(Rect2(wx, 283.0, 30.0, 4.0), Color("121b20"))
		draw_line(Vector2(wx + 4.0, 285.0), Vector2(wx + 10.0, 285.0), Color("e29b42", 0.6), 1.0)
	
	# Platform Station Sign Header: "STACJA TECHNICZNA 13 / GRANICA SIECI POWIERZCHNIOWEJ"
	draw_rect(Rect2(120.0, 68.0, 400.0, 14.0), Color("070e12"))
	draw_rect(Rect2(120.0, 68.0, 400.0, 14.0), COLOR_INFRASTRUCTURE * 0.5, false, 0.8)
	draw_line(Vector2(126.0, 75.0), Vector2(514.0, 75.0), Color("c8a370", 0.7), 0.8)
	
	# Ambient overhead light fixtures (Flickering at neon x=240, deep well x=360, gate x=590)
	var pulse := sin(_pulse_time * 3.0) * 0.5 + 0.5
	draw_circle(Vector2(130.0, 55.0), 3.5, Color("4a6878", 0.6))
	draw_circle(Vector2(240.0, 55.0), 4.5, Color("75c7c3", 0.8 + pulse * 0.2))
	draw_circle(Vector2(360.0, 55.0), 4.0, Color("5da398", 0.7))
	draw_circle(Vector2(470.0, 55.0), 4.0, Color("e2b060", 0.85))
	draw_circle(Vector2(590.0, 55.0), 4.5, Color("d39a62", 0.85))
	
	# 3. Dialogue & Subtitle HUD
	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_hud(dialogue_lines[dialogue_index])


func _draw_dialogue_hud(line: Dictionary) -> void:
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_witness: bool = line.get("is_witness", false)
	var is_lena: bool = line.get("is_lena", false)
	var is_jakub: bool = line.get("is_jakub", false)
	
	var box_rect := Rect2(60.0, 285.0, 520.0, 60.0)
	draw_rect(box_rect, Color(0.04, 0.07, 0.09, 0.94))
	
	var border_color := COLOR_CYAN_TECH if is_jakub else (COLOR_AMBER_WARM if is_lena else (COLOR_CYAN if is_witness else COLOR_INFRASTRUCTURE))
	draw_rect(box_rect, border_color * 0.75, false, 1.0)
	
	# Speaker header bar
	var bar_color := border_color
	draw_rect(Rect2(64.0, 288.0, 140.0, 3.0), bar_color)
	
	var font := ThemeDB.fallback_font
	if font:
		draw_string(font, Vector2(70.0, 304.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, bar_color)
		draw_string(font, Vector2(70.0, 324.0), text, HORIZONTAL_ALIGNMENT_LEFT, 500, 10, Color("dcebe4"))
