extends SceneTree

## PKG-0172 gate — P9 PHASE-08 / BUNDLE-26: GATE-CAST
## Cast, portraits and one visual language.
## Technical proof only: CharacterVisualRig contract, physical Marta/Jakub/
## Wierzbicka on the 20-address route, GATE-INT <= 3, no primitive-person
## substitutes on the campaign route, Marta portrait not derived from Lena.
## It does not claim comprehension, emotion, fun or PRODUCT GO.

const RIG_PATH := "res://scripts/characters/character_visual_rig.gd"
const MARTA_PORTRAIT := "res://assets/characters/portraits/marta.png"
const LENA_PORTRAIT := "res://assets/characters/portraits/lena.png"
const RETIRED_PORTRAIT_TOOL := "res://tools/update_marta_portrait.py"
const CAMPAIGN_STATIONS: Array[String] = [
	"station_01", "station_02", "station_03", "station_04", "station_05",
	"station_06", "station_07", "station_08", "station_09", "station_10",
	"station_11", "station_12", "station_13", "station_14", "station_15",
	"station_16", "station_17", "station_18", "station_42a", "station_42b",
	"station_42c", "station_43",
]
const PRIMITIVE_PERSON_PROP_TYPES: Array[int] = [
	23,  # MARTA_INTERACTION
	77,  # WIERZBICKA_DESK
	87,  # SZYMON_BERA
	122, # JAKUB_SERVICE_OPERATOR
	188, # MARTA_WITNESS_STATION
]
const PRESENTATION_STATES: Array[StringName] = [
	&"idle", &"talk", &"listen", &"gesture", &"turn_away", &"seated", &"work",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0172: " + message)


func _run() -> void:
	_test_marta_portrait_identity()
	_test_retired_portrait_tool()
	_test_character_visual_rig_contract()
	await _test_campaign_cast_placement()
	_test_campaign_route_has_no_primitive_people()
	_test_sprite_canvas_contract()
	_finish()


func _test_marta_portrait_identity() -> void:
	_expect(FileAccess.file_exists(MARTA_PORTRAIT), "Marta portrait must exist at assets/characters/portraits/marta.png")
	_expect(FileAccess.file_exists(LENA_PORTRAIT), "Lena portrait must remain as the identity reference")
	if not FileAccess.file_exists(MARTA_PORTRAIT) or not FileAccess.file_exists(LENA_PORTRAIT):
		return
	var marta_tex := load(MARTA_PORTRAIT) as Texture2D
	var lena_tex := load(LENA_PORTRAIT) as Texture2D
	_expect(marta_tex != null and lena_tex != null, "Both portraits must load as textures")
	var marta := marta_tex.get_image() if marta_tex else null
	var lena := lena_tex.get_image() if lena_tex else null
	_expect(marta != null and lena != null, "Both portraits must load as images")
	if marta == null or lena == null:
		return
	_expect(marta.get_width() == 1024 and marta.get_height() == 1024, "Marta portrait must be 1024x1024")
	_expect(marta.get_width() != lena.get_width() or marta.get_data() != lena.get_data(), "Marta portrait must not be a copy of Lena's raster")
	var pink_pixels := 0
	var dark_hair_pixels := 0
	for y in range(0, marta.get_height(), 8):
		for x in range(0, marta.get_width(), 8):
			var pixel := marta.get_pixel(x, y)
			if pixel.a < 0.4:
				continue
			if pixel.r > 0.55 and pixel.b > 0.28 and pixel.g < 0.55:
				pink_pixels += 1
			if pixel.r < 0.28 and pixel.g < 0.28 and pixel.b < 0.32:
				dark_hair_pixels += 1
	_expect(pink_pixels >= 40, "Marta portrait must carry a substantial muted-pink hair accent (got %d)" % pink_pixels)
	_expect(pink_pixels > dark_hair_pixels, "Marta portrait must not be Lena's dark crop with a pink overlay")


func _test_retired_portrait_tool() -> void:
	_expect(not FileAccess.file_exists(RETIRED_PORTRAIT_TOOL), "tools/update_marta_portrait.py must stay retired (D-187)")
	_expect(FileAccess.file_exists("res://tools/retired/update_marta_portrait.py"), "Retired portrait tool must remain under tools/retired/")


func _test_character_visual_rig_contract() -> void:
	_expect(ResourceLoader.exists(RIG_PATH), "scripts/characters/character_visual_rig.gd must exist")
	if not ResourceLoader.exists(RIG_PATH):
		return
	var script := load(RIG_PATH) as GDScript
	_expect(script != null, "CharacterVisualRig script must load")
	if script == null:
		return
	var rig := script.new() as Node2D
	_expect(rig != null, "CharacterVisualRig must instantiate as Node2D")
	if rig == null:
		return
	_expect(rig.get_class() == "Node2D" or rig is Node2D, "CharacterVisualRig must extend Node2D")
	var constants: Dictionary = script.get_script_constant_map()
	_expect(int(constants.get("CANVAS_W", -1)) == 64, "CANVAS_W must be 64")
	_expect(int(constants.get("CANVAS_H", -1)) == 104, "CANVAS_H must be 104")
	_expect(is_equal_approx(float(constants.get("PIVOT_X", -1.0)), 32.0), "PIVOT_X must be 32")
	_expect(is_equal_approx(float(constants.get("PIVOT_Y", -1.0)), 96.0), "PIVOT_Y must be 96")
	_expect(rig.has_method("set_state"), "CharacterVisualRig must expose set_state")
	_expect(rig.has_method("get_active_state_name"), "CharacterVisualRig must expose get_active_state_name")
	_expect(rig.has_method("get_visual_height"), "CharacterVisualRig must expose get_visual_height")
	_expect(rig.has_method("draws_polygonal_body"), "CharacterVisualRig must expose draws_polygonal_body")
	rig.set("character_id", &"marta")
	rig.set("initial_state", &"idle")
	root.add_child(rig)
	_expect(rig.draws_polygonal_body() == false, "CharacterVisualRig must not draw a polygonal body")
	var idle_height := float(rig.get_visual_height())
	_expect(idle_height >= 84.0 and idle_height <= 92.0, "Idle visual height must sit in 84-92 px (got %.1f)" % idle_height)
	var body := rig.get_node_or_null("BodySprite") as Sprite2D
	_expect(body != null, "CharacterVisualRig must own a BodySprite")
	if body != null:
		_expect(body.centered == false, "BodySprite.centered must be false")
		_expect(body.texture_filter == CanvasItem.TEXTURE_FILTER_NEAREST, "BodySprite must use TEXTURE_FILTER_NEAREST")
		_expect(body.texture != null, "Idle texture must load")
		if body.texture != null:
			_expect(body.texture.get_width() == 64 and body.texture.get_height() == 104, "Loaded frame must be 64x104")
	for state_name in PRESENTATION_STATES:
		rig.set_state(state_name)
		_expect(rig.get_active_state_name() == state_name, "set_state(%s) must stick" % String(state_name))
		_expect(body != null and body.texture != null, "State %s must display a texture (idle fallback allowed)" % String(state_name))
	rig.set_state(&"missing_pose")
	_expect(rig.get_active_state_name() == &"idle", "Unknown states must fall back to idle")
	rig.queue_free()


func _test_campaign_cast_placement() -> void:
	await _expect_cast_on_station(
		"res://scenes/levels/station_10.tscn",
		&"marta",
		"Marta",
		3
	)
	await _expect_cast_on_station(
		"res://scenes/levels/station_11.tscn",
		&"wierzbicka",
		"Wierzbicka",
		3
	)
	await _expect_cast_on_station(
		"res://scenes/levels/station_12.tscn",
		&"jakub",
		"Jakub",
		3
	)
	await _expect_cast_on_station(
		"res://scenes/levels/station_42b.tscn",
		&"marta",
		"Marta",
		3
	)
	await _expect_cast_on_station(
		"res://scenes/levels/station_42c.tscn",
		&"marta",
		"Marta",
		3
	)


func _expect_cast_on_station(path: String, character_id: StringName, display_name: String, max_int: int) -> void:
	var packed := load(path) as PackedScene
	_expect(packed != null, "%s must load" % path)
	if packed == null:
		return
	var station := packed.instantiate() as Node2D
	_expect(station != null, "%s must instantiate" % path)
	if station == null:
		return
	root.add_child(station)
	for _i in range(3):
		await process_frame
	var found := _find_rig(station, character_id)
	_expect(found != null, "%s must contain a CharacterVisualRig for %s" % [path, display_name])
	if found != null:
		var height := float(found.get_visual_height())
		_expect(height >= 56.0 and height <= 92.0, "%s visual height must be in canon (standing 84-92 or seated 56-60), got %.1f" % [display_name, height])
		_expect(found.draws_polygonal_body() == false, "%s must not use a polygonal body" % display_name)
	_expect(_count_interactions(station) <= max_int, "%s must keep GATE-INT <= %d (got %d)" % [path, max_int, _count_interactions(station)])
	station.queue_free()
	await process_frame


func _find_rig(node: Node, character_id: StringName) -> Node:
	if node.get_script() != null:
		var script_path := String(node.get_script().resource_path)
		if script_path.ends_with("character_visual_rig.gd"):
			if StringName(node.get("character_id")) == character_id:
				return node
	for child in node.get_children():
		var found := _find_rig(child, character_id)
		if found != null:
			return found
	return null


func _count_interactions(station: Node) -> int:
	var props := station.get_node_or_null("Props")
	if props == null:
		return 0
	var count := 0
	for child in props.get_children():
		if child is MemoryResonancePoint:
			count += 1
	return count


func _test_campaign_route_has_no_primitive_people() -> void:
	for station_id in CAMPAIGN_STATIONS:
		var tscn_path := "res://scenes/levels/%s.tscn" % station_id
		var gd_path := "res://scripts/levels/%s.gd" % station_id
		if FileAccess.file_exists(tscn_path):
			var tscn := FileAccess.get_file_as_string(tscn_path)
			for prop_type in PRIMITIVE_PERSON_PROP_TYPES:
				_expect(
					not tscn.contains("prop_type = %d" % prop_type),
					"%s must not instantiate primitive-person prop_type %d" % [station_id, prop_type]
				)
		if FileAccess.file_exists(gd_path):
			var source := FileAccess.get_file_as_string(gd_path)
			_expect(
				not source.contains("draw_circle(Vector2(248, 214)"),
				"%s must not paint the DEF-3 circle-head figure at (248, 214)" % station_id
			)
			_expect(
				not source.contains("draw_circle(Vector2(348, 214)"),
				"%s must not paint the DEF-3 circle-head figure at (348, 214)" % station_id
			)
			_expect(
				not source.contains("draw_circle(Vector2(478, 146)"),
				"%s must not paint the DEF-3 circle-head figure at (478, 146)" % station_id
			)
			_expect(
				not source.contains("draw_circle(Vector2(480, 206)"),
				"%s must not paint the DEF-3 circle-head figure at (480, 206)" % station_id
			)
	var mrp := FileAccess.get_file_as_string("res://scripts/interactables/memory_resonance_point.gd")
	var start := mrp.find("func _draw_epilogue_marta_doorstep")
	var finish := mrp.find("\nfunc ", start + 1)
	if finish < 0:
		finish = mrp.length()
	_expect(start >= 0, "_draw_epilogue_marta_doorstep must still exist as the doorframe prop")
	if start >= 0:
		var body := mrp.substr(start, finish - start)
		_expect(not body.contains("draw_circle(Vector2(0.0, -18.0)"), "Epilogue doorstep must not draw a primitive Marta head")
		_expect(not body.contains("Color(\"d45b9a\")"), "Epilogue doorstep must not substitute a pink-hair primitive for Marta")


func _test_sprite_canvas_contract() -> void:
	for character_id in ["marta", "jakub", "wierzbicka"]:
		var idle_path := "res://assets/characters/%s/idle.png" % character_id
		_expect(FileAccess.file_exists(idle_path), "%s idle sprite must exist" % character_id)
		if not FileAccess.file_exists(idle_path):
			continue
		var idle_tex := load(idle_path) as Texture2D
		_expect(idle_tex != null, "%s idle sprite must load as a texture" % character_id)
		var image := idle_tex.get_image() if idle_tex else null
		_expect(image != null, "%s idle sprite must load" % character_id)
		if image == null:
			continue
		_expect(image.get_width() == 64 and image.get_height() == 104, "%s idle canvas must be 64x104" % character_id)
		var visible_top := image.get_height()
		var visible_bottom := 0
		for y in image.get_height():
			for x in image.get_width():
				if image.get_pixel(x, y).a > 0.2:
					visible_top = mini(visible_top, y)
					visible_bottom = maxi(visible_bottom, y)
					break
		var visible_h := visible_bottom - visible_top + 1
		_expect(visible_h >= 56 and visible_h <= 92, "%s visible height must be 56-92 px (got %d)" % [character_id, visible_h])


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0172 SMOKE PASS: GATE-CAST — CharacterVisualRig, campaign cast, portrait identity.")
		quit(0)
	else:
		print("PKG-0172 SMOKE FAIL: %d failures" % _failures.size())
		for failure in _failures:
			print(" - %s" % failure)
		quit(1)
