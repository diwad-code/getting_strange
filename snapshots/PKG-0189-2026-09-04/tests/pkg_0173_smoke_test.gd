extends SceneTree

## PKG-0173 gate — P9 PHASE-08 / BUNDLE-27: GATE-ANIM
## Traversal animation: steps and ladders (DEF-5, DEF-6).
## Technical proof only: curb-step measures real riser height, interpolates,
## _stepping blocks landing/squash/jump_fall; LenaVisualRig has step_up /
## step_down / climb_back / ladder_mount / ladder_dismount on the 64x104
## pivot contract; campaign ladders on 02/15/16 draw from LadderZone only
## and require climb intent. Does not claim fun, comprehension or PRODUCT GO.

const RIG_PATH := "res://scripts/player/lena_visual_rig.gd"
const PLAYER_PATH := "res://scripts/player/prototype_player.gd"
const PLAYER_SCENE := "res://scenes/player/prototype_player.tscn"
const LADDER_PATH := "res://scripts/environment/ladder_zone.gd"
const ASSET_DIR := "res://assets/characters/lena/"

const STEP_FRAMES: Array[String] = [
	"step_up_0", "step_up_1", "step_down_0",
]
const LADDER_FRAMES: Array[String] = [
	"climb_back_0", "climb_back_1", "climb_back_2", "climb_back_3",
	"ladder_mount", "ladder_dismount",
]
const NEW_STATES: Array[StringName] = [
	&"step_up", &"step_down", &"climb_back", &"ladder_mount", &"ladder_dismount",
]
const LADDER_STATIONS: Array[Dictionary] = [
	{"id": "station_02", "node": "ServiceLadder"},
	{"id": "station_15", "node": "Props/ServiceLadder"},
	{"id": "station_16", "node": "Props/ServiceLadder"},
]
const BANNED_STATION_02_DRAW := [
	"Vector2(564.0, 164.0)",
	"Vector2(564.0, 256.0)",
	"Vector2(576.0, 162.0)",
	"range(174, 250, 14)",
]
const TELEPORT_SNIPPET := "global_position.y -= MAX_CURB_STEP"

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0173: " + message)


func _run() -> void:
	_test_new_frames_exist_on_canvas()
	_test_rig_new_states()
	_test_player_step_contract()
	_test_no_fixed_curb_teleport()
	await _test_measured_curb_step_does_not_land()
	_test_station_02_has_single_ladder_draw()
	await _test_campaign_ladder_alignment()
	await _test_ladder_requires_intent()
	_test_no_new_binaries()
	_finish()


func _test_new_frames_exist_on_canvas() -> void:
	print("1. GATE-ANIM frames on 64x104 baked pivot...")
	var all_frames: Array[String] = []
	all_frames.append_array(STEP_FRAMES)
	all_frames.append_array(LADDER_FRAMES)
	for name in all_frames:
		var path := ASSET_DIR + name + ".png"
		_expect(ResourceLoader.exists(path), "missing frame %s.png" % name)
		if not ResourceLoader.exists(path):
			continue
		var tex := load(path) as Texture2D
		_expect(tex != null, "%s.png must load as a texture" % name)
		if tex == null:
			continue
		_expect(
			tex.get_width() == 64 and tex.get_height() == 104,
			"%s.png must be 64x104, got %dx%d" % [name, tex.get_width(), tex.get_height()]
		)
		var image := tex.get_image()
		_expect(image != null, "%s.png must decode" % name)
		if image == null:
			continue
		var visible_bottom := 0
		var visible_top := image.get_height()
		for y in image.get_height():
			for x in image.get_width():
				if image.get_pixel(x, y).a > 0.2:
					visible_top = mini(visible_top, y)
					visible_bottom = maxi(visible_bottom, y)
					break
		_expect(visible_bottom >= 90, "%s visible foot must sit near pivot y=96 (bottom=%d)" % [name, visible_bottom])
		_expect(visible_top < 40, "%s head must occupy the upper canvas (top=%d)" % [name, visible_top])


func _test_rig_new_states() -> void:
	print("2. LenaVisualRig 4.2 traversal states...")
	_expect(ResourceLoader.exists(RIG_PATH), "lena_visual_rig.gd must exist")
	var script := load(RIG_PATH) as GDScript
	_expect(script != null, "LenaVisualRig must load")
	if script == null:
		return
	var constants: Dictionary = script.get_script_constant_map()
	var names: Dictionary = constants.get("STATE_NAMES", {})
	for state_name in NEW_STATES:
		var found := false
		for key in names:
			if names[key] == state_name:
				found = true
				break
		_expect(found, "STATE_NAMES must include %s" % String(state_name))
	var rig := script.new() as Node2D
	root.add_child(rig)
	_expect(rig.has_method("set_mechanical_state"), "rig must expose set_mechanical_state")
	if rig.has_method("set_mechanical_state"):
		rig.call("set_mechanical_state", Vector2(0.0, 80.0), false, false, false, &"step_up")
		_expect(
			String(rig.call("get_active_state_name")) == "step_up",
			"stepping pose must suppress jump_fall (got %s)" % String(rig.call("get_active_state_name"))
		)
		rig.call("set_mechanical_state", Vector2(0.0, 40.0), false, true, false)
		var climb_name := String(rig.call("get_display_state_name")) if rig.has_method("get_display_state_name") else String(rig.call("get_active_state_name"))
		_expect(
			climb_name == "climb_back" or climb_name == "ladder_mount" or climb_name == "climb",
			"climbing display must prefer climb_back (got %s)" % climb_name
		)
	rig.queue_free()


func _test_player_step_contract() -> void:
	print("3. PrototypePlayer stepping contract...")
	var source := FileAccess.get_file_as_string(PLAYER_PATH)
	_expect(source.contains("var _stepping"), "PrototypePlayer must own a _stepping flag")
	_expect(source.contains("func is_stepping"), "PrototypePlayer must expose is_stepping()")
	_expect(source.contains("0.18"), "step duration must start at 0.18 s")
	_expect(source.contains("0.24"), "step duration must cap at 0.24 s")
	_expect(not source.contains(TELEPORT_SNIPPET), "try_curb_step must not teleport by a fixed MAX_CURB_STEP")
	var packed := load(PLAYER_SCENE) as PackedScene
	_expect(packed != null, "prototype_player.tscn must load")
	if packed == null:
		return
	var player := packed.instantiate() as CharacterBody2D
	root.add_child(player)
	_expect(player.has_method("try_curb_step"), "try_curb_step must exist")
	_expect(player.has_method("is_stepping"), "is_stepping() must exist")
	_expect(player.has_method("measure_curb_height"), "measure_curb_height() must exist")
	_expect(is_equal_approx(float(player.get("MAX_CURB_STEP")), 18.0), "MAX_CURB_STEP limit stays 18 px (D-123)")
	player.queue_free()


func _test_no_fixed_curb_teleport() -> void:
	print("4. Source forbids the DEF-5 18 px teleport...")
	var source := FileAccess.get_file_as_string(PLAYER_PATH)
	_expect(
		source.contains("measure_curb_height") or source.contains("_measure_curb_height"),
		"curb step must probe the real riser height"
	)
	var landing_guard := source.contains("not _stepping") or source.contains("is_stepping()")
	_expect(landing_guard, "landing / squash path must consult _stepping")


func _test_measured_curb_step_does_not_land() -> void:
	print("5. 12 px riser interpolates without landing squash...")
	var world := Node2D.new()
	world.name = "CurbHarness"
	root.add_child(world)

	var floor_body := StaticBody2D.new()
	floor_body.position = Vector2(200.0, 300.0)
	var floor_shape := CollisionShape2D.new()
	var floor_rect := RectangleShape2D.new()
	floor_rect.size = Vector2(400.0, 20.0)
	floor_shape.shape = floor_rect
	floor_body.add_child(floor_shape)
	world.add_child(floor_body)

	# 12 px riser whose face sits just to the right of spawn.
	var step_body := StaticBody2D.new()
	step_body.name = "TerrazzoStair"
	step_body.position = Vector2(280.0, 284.0)
	var step_shape := CollisionShape2D.new()
	var step_rect := RectangleShape2D.new()
	step_rect.size = Vector2(80.0, 12.0)
	step_shape.shape = step_rect
	step_body.add_child(step_shape)
	world.add_child(step_body)

	var packed := load(PLAYER_SCENE) as PackedScene
	if packed == null:
		_expect(false, "prototype_player.tscn must load for the curb harness")
		world.queue_free()
		return
	var player := packed.instantiate() as CharacterBody2D
	player.position = Vector2(230.0, 263.0)
	world.add_child(player)

	for _i in range(12):
		await physics_frame

	var y_before := player.global_position.y
	if player.has_method("measure_curb_height"):
		var probed: float = float(player.call("measure_curb_height", 1.0))
		_expect(probed > 8.0 and probed <= 18.0, "probe must report the 12 px riser (got %.1f)" % probed)

	Input.action_press(&"move_right")
	var jump_fall_frames := 0
	var squash_frames := 0
	var stepped := false
	for _i in range(50):
		await physics_frame
		if player.has_method("is_stepping") and bool(player.call("is_stepping")):
			stepped = true
		var rig := player.get_node_or_null("LenaVisualRig")
		if rig != null and rig.has_method("get_active_state_name"):
			var state_name := String(rig.call("get_active_state_name"))
			if state_name == "jump_fall":
				jump_fall_frames += 1
		var scale: Vector2 = player.get("_visual_scale") if "_visual_scale" in player else Vector2.ONE
		if scale.y < 0.92:
			squash_frames += 1
	Input.action_release(&"move_right")

	var y_after := player.global_position.y
	var lift := y_before - y_after
	_expect(stepped, "walking onto the 12 px riser must raise the _stepping flag")
	_expect(jump_fall_frames == 0, "GATE-ANIM: jump_fall frames on the riser must be 0 (got %d)" % jump_fall_frames)
	_expect(squash_frames == 0, "GATE-ANIM: squash 0.80 must not fire on a curb step (got %d frames)" % squash_frames)
	_expect(lift <= 18.5, "lift must stay inside the 18 px cap (got %.1f)" % lift)
	if lift > 1.0:
		_expect(lift < 16.0, "12 px riser must not be climbed as a 18 px teleport (got %.1f)" % lift)

	world.queue_free()
	await process_frame


func _test_station_02_has_single_ladder_draw() -> void:
	print("6. Station 02 no longer paints a second ladder...")
	var source := FileAccess.get_file_as_string("res://scripts/levels/station_02.gd")
	for snippet in BANNED_STATION_02_DRAW:
		_expect(not source.contains(snippet), "station_02.gd must not draw a second ladder via %s" % snippet)
	for station_id in ["station_15", "station_16"]:
		var path := "res://scripts/levels/%s.gd" % station_id
		if not FileAccess.file_exists(path):
			continue
		var text := FileAccess.get_file_as_string(path)
		_expect(
			not text.contains("range(174, 250, 14)"),
			"%s must not duplicate the Station 02 offset ladder loop" % station_id
		)


func _test_campaign_ladder_alignment() -> void:
	print("7. LadderZone graphic matches the climb volume...")
	for spec in LADDER_STATIONS:
		var station_id: String = spec["id"]
		var node_path: String = spec["node"]
		var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
		_expect(packed != null, "%s.tscn must load" % station_id)
		if packed == null:
			continue
		var station := packed.instantiate() as Node2D
		root.add_child(station)
		await process_frame
		var ladder := station.get_node_or_null(node_path)
		_expect(ladder != null, "%s must own %s" % [station_id, node_path])
		if ladder != null:
			_expect(ladder is LadderZone, "%s %s must be a LadderZone" % [station_id, node_path])
			var shape := ladder.get_node_or_null("CollisionShape2D") as CollisionShape2D
			_expect(shape != null, "%s ladder must have a collision shape" % station_id)
			if shape != null and shape.shape is RectangleShape2D:
				var rect := shape.shape as RectangleShape2D
				var center: Vector2 = ladder.to_global(shape.position)
				var col_top: float = center.y - rect.size.y * 0.5
				var col_bot: float = center.y + rect.size.y * 0.5
				var vis_top: float = ladder.global_position.y - float(ladder.get("ladder_height"))
				var vis_bot: float = ladder.global_position.y
				_expect(
					absf(col_top - vis_top) <= 2.0,
					"%s ladder vertical top mismatch %.1f vs %.1f" % [station_id, vis_top, col_top]
				)
				_expect(
					absf(col_bot - vis_bot) <= 2.0,
					"%s ladder vertical bottom mismatch %.1f vs %.1f" % [station_id, vis_bot, col_bot]
				)
				_expect(
					absf(center.x - ladder.global_position.x) <= 1.0,
					"%s ladder x-axis mismatch %.1f vs %.1f" % [station_id, ladder.global_position.x, center.x]
				)
			if station_id == "station_02":
				var floor_node := station.get_node_or_null("Geometry/Floor") as StaticBody2D
				if floor_node != null:
					var floor_shape := floor_node.get_node_or_null("CollisionShape2D") as CollisionShape2D
					if floor_shape != null and floor_shape.shape is RectangleShape2D:
						var floor_rect := floor_shape.shape as RectangleShape2D
						var floor_top := floor_node.global_position.y - floor_rect.size.y * 0.5
						var vis_bot: float = ladder.global_position.y
						_expect(
							absf(vis_bot - floor_top) <= 2.0,
							"Station 02 ladder bottom must sit on the floor (%.1f vs %.1f)" % [vis_bot, floor_top]
						)
		station.queue_free()
		await process_frame


func _test_ladder_requires_intent() -> void:
	print("8. Ladder attach requires intent, not a running graze...")
	var world := Node2D.new()
	root.add_child(world)
	var ladder := LadderZone.new()
	ladder.position = Vector2(200.0, 296.0)
	ladder.ladder_height = 86.0
	ladder.ladder_width = 22.0
	world.add_child(ladder)
	var packed := load(PLAYER_SCENE) as PackedScene
	if packed == null:
		_expect(false, "prototype_player.tscn must load for ladder intent")
		world.queue_free()
		return
	var player := packed.instantiate() as CharacterBody2D
	player.position = Vector2(200.0, 269.0)
	world.add_child(player)
	await physics_frame
	player.attach_to_ladder(ladder)
	player.velocity = Vector2(90.0, 0.0)
	player.set("is_climbing", false)
	Input.action_press(&"move_up")
	Input.action_press(&"move_right")
	for _i in range(8):
		await physics_frame
	Input.action_release(&"move_up")
	Input.action_release(&"move_right")
	_expect(
		bool(player.get("is_climbing")) == false,
		"running graze plus move_up must not pin Lena to the ladder"
	)
	player.velocity = Vector2.ZERO
	Input.action_press(&"move_up")
	for _i in range(8):
		await physics_frame
	Input.action_release(&"move_up")
	_expect(
		bool(player.get("is_climbing")) == true,
		"a stopped upward input at the ladder must start the climb"
	)
	world.queue_free()
	await process_frame


func _test_no_new_binaries() -> void:
	print("9. D-168: no new packaged .exe...")
	var dir := DirAccess.open("res://")
	_expect(dir != null, "project root must open")
	if dir == null:
		return
	var banned := 0
	dir.list_dir_begin()
	var entry := dir.get_next()
	while entry != "":
		if entry.ends_with(".exe") and not entry.begins_with("Godot"):
			banned += 1
		entry = dir.get_next()
	dir.list_dir_end()
	_expect(banned == 0, "PKG-0173 must not add a packaged .exe")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0173 SMOKE PASS: GATE-ANIM — steps interpolate, ladders draw once, climb shows the back.")
		quit(0)
	else:
		print("PKG-0173 SMOKE FAIL: %d failures" % _failures.size())
		for failure in _failures:
			print(" - %s" % failure)
		quit(1)
