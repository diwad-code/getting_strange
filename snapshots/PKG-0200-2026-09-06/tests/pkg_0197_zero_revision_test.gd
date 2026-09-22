extends SceneTree

## PKG-0197 gate — ZERO REWIZJA ARTYSTYCZNA, wycinek 1 (01/06/08 + winiety).
##
## Dowodzi wyłącznie kontraktów mierzalnych, nigdy „ładności" (D-012, ADR-003):
## (1) winiety nie dubbingują sceny — wszystkie podpisy puste, sloty/wyzwalacze
##     i długości klatek bez zmian; (2) maszyna stacji 01 pracuje własnym cyklem
##     niezależnie od gracza i ma słyszalne źródło w kadrze; (3) rigi sprzedawcy
##     (06) i sąsiadki (08) są sterowane talk/listen/idle z linii dialogu, a nie
##     tkwią w idle; (4) Lena i obsada zachowują kontrakty sprite'ów i skali;
##     (5) brak globalnych filtrów/glitchy nakładanych na cały ekran;
##     (6) każda stacja ma nazwane źródło światła praktycznego.
## Logika gry nietykalna: zero nowych writerów, flag, sygnałów i zmian routingu.

const CinematicCatalogScript := preload("res://scripts/cinematics/cinematic_catalog.gd")
const LenaRigScript := preload("res://scripts/player/lena_visual_rig.gd")
const CharacterRigScript := preload("res://scripts/characters/character_visual_rig.gd")

const ACTIVE_IDS: Array[String] = [
	"station_01", "station_02", "station_03", "station_04", "station_05",
	"station_06", "station_07", "station_08", "station_09", "station_10",
	"station_11", "station_12", "station_13", "station_14", "station_15",
	"station_16", "station_17", "station_18",
	"station_42a", "station_42b", "station_42c", "station_43",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0197: " + message)


func _read(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "file must be readable: %s" % path)
	if file == null:
		return ""
	var source := file.get_as_text()
	file.close()
	return source


func _run() -> void:
	_check_vignette_silence()
	_check_station_01_autonomy()
	_check_npc_drivers()
	_check_lena_and_cast_contracts()
	_check_no_global_filters()
	_check_practical_lighting()
	await _check_runtime_drivers()
	_finish()


# ─── 1. Winiety: czysty obraz, zero dubbingu ────────────────────────────────

func _check_vignette_silence() -> void:
	var ids := CinematicCatalogScript.all_ids()
	_expect(ids.size() == 7, "catalog must still list exactly 7 vignettes, found %d" % ids.size())
	for id in ids:
		var entry := CinematicCatalogScript.entry(id)
		var frames: Array = entry.get("frames", [])
		var captions: Array = entry.get("captions", [])
		_expect(frames.size() == 2, "%s must keep exactly 2 frames" % id)
		_expect(captions.size() == frames.size(), "%s captions length must match frames length" % id)
		for i in captions.size():
			_expect(String(captions[i]).is_empty(), "%s caption %d must be empty (image reinforces, never dubs)" % [id, i])
		for frame_path in frames:
			_expect(ResourceLoader.exists(String(frame_path)), "%s frame missing on disk: %s" % [id, frame_path])
		var normal: Array = entry.get("frame_seconds", [])
		var reduced: Array = entry.get("frame_seconds_reduced", [])
		_expect(normal.size() == frames.size() and reduced.size() == frames.size(), "%s durations must match frames" % id)


# ─── 2. Stacja 01: maszyna pracuje sama ─────────────────────────────────────

func _check_station_01_autonomy() -> void:
	var source := _read("res://scripts/levels/station_01.gd")
	_expect(source.contains("_machine_time"), "station_01 must own an independent machine clock")
	_expect(source.contains("_machine_time * TAU / 9.0"), "station_01 drum must rotate on its own ~9s cycle")
	_expect(source.contains("MachineHum"), "station_01 must carry an audible machine source in frame")
	_expect(source.contains("AudioStreamPlayer2D"), "station_01 hum must be a positioned 2D source")
	_expect(source.contains("create_act1_fluorescent_ballast_hum_sound"), "station_01 hum must reuse the hall-ballast generator")
	_expect(source.contains("Color(VectorStageStyle.INK, 0.48)"), "station_01 machine must have a contact shadow")
	_expect(not source.contains("signal machine_"), "station_01 must add no gameplay signals")
	_expect(not source.contains("signal npc_"), "station_01 must add no NPC signals")


# ─── 3. Stacje 06/08: postacie pracują ciałem ───────────────────────────────

func _check_npc_drivers() -> void:
	var s06 := _read("res://scripts/levels/station_06.gd")
	_expect(s06.contains("KioskBlockout/Vendor"), "station_06 must address its vendor rig by world name")
	_expect(s06.contains("line_started"), "station_06 must drive the rig from dialogue lines")
	_expect(s06.contains("set_state(&\"talk\")"), "station_06 must show talk")
	_expect(s06.contains("set_state(&\"listen\")"), "station_06 must show listen")
	_expect(s06.contains("set_state(&\"idle\")"), "station_06 must rest to idle")
	_expect(not s06.contains("signal npc_"), "station_06 must add no gameplay signals")
	var s08 := _read("res://scripts/levels/station_08.gd")
	_expect(s08.contains("LandingBlockout/Neighbour"), "station_08 must address its neighbour rig by world name")
	_expect(s08.contains("line_started"), "station_08 must drive the rig from dialogue lines")
	_expect(s08.contains("set_state(&\"talk\")"), "station_08 must show talk")
	_expect(s08.contains("set_state(&\"listen\")"), "station_08 must show listen")
	_expect(s08.contains("set_state(&\"idle\")"), "station_08 must rest to idle")
	_expect(not s08.contains("signal npc_"), "station_08 must add no gameplay signals")


# ─── 4. Kontrakty sprite'ów i skali ─────────────────────────────────────────

func _check_lena_and_cast_contracts() -> void:
	for state_name in [&"step_up", &"step_down", &"climb_back", &"enter_door", &"board_vehicle"]:
		_expect(LenaRigScript.STATE_NAMES.values().has(state_name), "LenaVisualRig must keep state %s" % state_name)
	for frame in ["res://assets/characters/lena/idle.png", "res://assets/characters/lena/walk_0.png",
			"res://assets/characters/lena/climb_back_0.png", "res://assets/characters/lena/step_up_0.png",
			"res://assets/characters/lena/enter_door_0.png", "res://assets/characters/lena/board_vehicle_0.png"]:
		_expect(ResourceLoader.exists(frame), "Lena frame missing: %s" % frame)
	for character_id in [&"vendor", &"neighbour"]:
		var height := float(CharacterRigScript.STANDING_HEIGHTS.get(character_id, 0.0))
		_expect(height >= 84.0 and height <= 92.0, "%s height %.1f must stay in 84-92 px" % [character_id, height])
	for frame in ["res://assets/characters/vendor/idle.png", "res://assets/characters/vendor/talk_0.png",
			"res://assets/characters/vendor/listen.png", "res://assets/characters/neighbour/idle.png",
			"res://assets/characters/neighbour/talk_0.png", "res://assets/characters/neighbour/listen.png",
			"res://assets/characters/neighbour/gesture.png"]:
		_expect(ResourceLoader.exists(frame), "cast frame missing: %s" % frame)


# ─── 5. Zero globalnych filtrów ─────────────────────────────────────────────

func _check_no_global_filters() -> void:
	_expect(_read("res://scripts/visual/world_pixel_compositor.gd").contains("screen_texture"),
			"only WorldPixelCompositor may sample screen_texture")
	for station_id in ACTIVE_IDS:
		var source := _read("res://scripts/levels/%s.gd" % station_id)
		_expect(not source.contains("screen_texture"), "%s must not sample the screen" % station_id)
		_expect(not source.contains("glitch"), "%s must not run a fullscreen glitch" % station_id)
		_expect(source.contains("func _draw"), "%s must own a drawn world surface" % station_id)
		_expect(not source.contains("draw_string("), "%s must not put readable text in the pixelated world" % station_id)


# ─── 6. Nazwane światło w każdym miejscu ────────────────────────────────────

func _check_practical_lighting() -> void:
	var source := _read("res://scripts/visual/vector_stage_environment.gd")
	_expect(source.contains("func _draw_practical_lighting"), "environment must own practical lighting")
	_expect(source.contains("draw_faceted_lamp"), "environment must place at least one faceted lamp")
	_expect(source.contains("_draw_strip_light"), "environment must place strip lights")
	_expect(source.contains("_draw_vertical_service_light"), "environment must place service lights")
	_expect(source.contains("station_number <= 13"), "lighting must cover act 01-13")
	_expect(source.contains("station_number <= 30"), "lighting must cover act 14-30")


# ─── 7. Runtime: zegar maszyny i stany NPC ──────────────────────────────────

func _check_runtime_drivers() -> void:
	var packed_01 := load("res://scenes/levels/station_01.tscn") as PackedScene
	_expect(packed_01 != null, "station_01 scene must load")
	if packed_01 != null:
		var station_01 := packed_01.instantiate() as Node2D
		root.add_child(station_01)
		await process_frame
		await process_frame
		await process_frame
		var mt_variant: Variant = station_01.get("_machine_time")
		_expect(mt_variant is float and float(mt_variant) > 0.0, "station_01 machine clock must advance without player input")
		var hum := station_01.get_node_or_null("MachineHum")
		_expect(hum != null, "station_01 MachineHum must exist in the frame")
		station_01.free()
		await process_frame
	var packed_06 := load("res://scenes/levels/station_06.tscn") as PackedScene
	_expect(packed_06 != null, "station_06 scene must load")
	if packed_06 != null:
		var station_06 := packed_06.instantiate() as Node2D
		root.add_child(station_06)
		await process_frame
		await process_frame
		station_06.call("_on_npc_dialogue_line", &"SPRZEDAWCA", "test")
		var rig_06: CharacterVisualRig = station_06.call("_npc_rig")
		_expect(rig_06 != null, "station_06 vendor rig must resolve")
		if rig_06 != null:
			_expect(rig_06.get_active_state_name() == &"talk", "vendor must show talk on his own line")
			station_06.call("_on_npc_dialogue_line", &"LENA", "test")
			_expect(rig_06.get_active_state_name() == &"listen", "vendor must show listen on Lena's line")
			station_06.call("_on_npc_dialogue_finished")
			_expect(rig_06.get_active_state_name() == &"idle", "vendor must rest to idle")
		station_06.free()
		await process_frame
	var packed_08 := load("res://scenes/levels/station_08.tscn") as PackedScene
	_expect(packed_08 != null, "station_08 scene must load")
	if packed_08 != null:
		var station_08 := packed_08.instantiate() as Node2D
		root.add_child(station_08)
		await process_frame
		await process_frame
		station_08.call("_on_npc_dialogue_line", &"SĄSIADKA", "test")
		var rig_08: CharacterVisualRig = station_08.call("_npc_rig")
		_expect(rig_08 != null, "station_08 neighbour rig must resolve")
		if rig_08 != null:
			_expect(rig_08.get_active_state_name() == &"talk", "neighbour must show talk on her own line")
			station_08.call("_on_npc_dialogue_line", &"LENA", "test")
			_expect(rig_08.get_active_state_name() == &"listen", "neighbour must show listen on Lena's line")
			station_08.call("_on_npc_dialogue_finished")
			_expect(rig_08.get_active_state_name() == &"idle", "neighbour must rest to idle")
		station_08.free()
		await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0197 ZERO REVISION PASS: vignette silence, machine autonomy, NPC drivers, cast contracts, no global filters, practical lighting.")
		quit(0)
	else:
		print("PKG-0197 ZERO REVISION FAIL: %d failures" % _failures.size())
		for failure in _failures:
			print(" - %s" % failure)
		quit(1)
