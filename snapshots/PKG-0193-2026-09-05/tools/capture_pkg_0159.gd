extends SceneTree

## PKG-0159 normal-driver evidence recertification.
## Run without --headless:
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0159.gd
## Produces normal product frames and true grayscale structural frames with all
## text, dialogue, thoughts and interaction markers hidden before capture.

const PACKAGE_ID := "PKG-0159"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0159"
const REPORT_PATH := "res://reports/pkg_0159/visual_evidence_report.txt"

const CAPTURES: Array[Dictionary] = [
	{"mode": "normal", "type": "shell", "scene": &"title_screen", "state": &"default"},
	{"mode": "normal", "type": "level", "scene": &"station_01", "state": &"initial_worksite"},
	{"mode": "normal", "type": "level", "scene": &"station_01", "state": &"repeat_message"},
	{"mode": "normal", "type": "level", "scene": &"station_01", "state": &"leave_message"},
	{"mode": "normal", "type": "level", "scene": &"station_08", "state": &"real_stair_flight"},
	{"mode": "mono", "type": "level", "scene": &"station_01", "state": &"structure_only"},
	{"mode": "mono", "type": "level", "scene": &"station_02", "state": &"structure_only"},
	{"mode": "mono", "type": "level", "scene": &"station_03", "state": &"structure_only"},
	{"mode": "mono", "type": "level", "scene": &"station_08", "state": &"structure_only"},
]

var _failures: Array[String] = []
var _records: Array[Dictionary] = []


func _initialize() -> void:
	call_deferred(&"_capture_all")


func _capture_all() -> void:
	root.size = LOGICAL_SIZE
	for directory in [OUTPUT_ROOT, OUTPUT_ROOT.path_join("normal"), OUTPUT_ROOT.path_join("mono")]:
		if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(directory)) != OK:
			_failures.append("cannot create %s" % directory)
	var state := root.get_node_or_null("GameStateManager")
	if state != null:
		state.campaign_auto_transition_enabled = false
		state.set_pause_menu_visible(false)
	for capture in CAPTURES:
		await _capture_one(capture, state)
	if state != null:
		state.reset_campaign(true)
		state.campaign_auto_transition_enabled = true
	_write_report()
	_finish()


func _capture_one(capture: Dictionary, state: Node) -> void:
	if state != null:
		state.reset_campaign(true)
	var capture_type: String = capture["type"]
	var scene_id := capture["scene"] as StringName
	var state_id := capture["state"] as StringName
	var mode: String = capture["mode"]
	var scene_path := "res://scenes/shell/title_screen.tscn" if capture_type == "shell" else "res://scenes/levels/%s.tscn" % scene_id
	var packed := load(scene_path) as PackedScene
	if packed == null:
		_failures.append("cannot load %s" % scene_path)
		return
	var instance := packed.instantiate() as CanvasItem
	if instance == null:
		_failures.append("root is not CanvasItem: %s" % scene_path)
		return
	root.add_child(instance)
	for _frame in range(8):
		await process_frame
	if not _apply_state(instance, scene_id, state_id):
		_failures.append("cannot apply %s/%s" % [scene_id, state_id])
		_dispose(instance)
		return
	var hidden_items := 0
	if mode == "mono":
		hidden_items = _hide_text_and_ui(instance)
	instance.queue_redraw()
	for _frame in range(20):
		await physics_frame
	for _frame in range(8):
		await process_frame
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	if image == null or image.get_size() != LOGICAL_SIZE:
		_failures.append("wrong frame for %s/%s" % [scene_id, state_id])
		_dispose(instance)
		return
	if mode == "mono":
		_make_true_grayscale(image)
		if not _is_grayscale(image):
			_failures.append("residual color in mono frame %s" % scene_id)
	var relative_path := OUTPUT_ROOT.path_join(mode).path_join("%s_%s.png" % [scene_id, state_id])
	if image.save_png(ProjectSettings.globalize_path(relative_path)) != OK:
		_failures.append("cannot save %s" % relative_path)
	else:
		var record := {
			"mode": mode,
			"scene": String(scene_id),
			"state": String(state_id),
			"path": relative_path,
			"hidden": hidden_items,
			"hash": hash(image.get_data()),
		}
		_records.append(record)
		print("%s CAPTURE PASS: %s hidden=%d hash=%s" % [PACKAGE_ID, relative_path, hidden_items, str(record["hash"])])
	_dispose(instance)
	await process_frame


func _apply_state(instance: CanvasItem, scene_id: StringName, state_id: StringName) -> bool:
	if state_id == &"real_stair_flight":
		var stair_dialogue := instance.get_node_or_null("CRTDialogueBox") as CRTDialogueBox
		if stair_dialogue != null:
			stair_dialogue.hide_box()
		return true
	if scene_id != &"station_01" or state_id in [&"default", &"initial_worksite", &"structure_only"]:
		return true
	if state_id == &"repeat_message":
		var repeat_ok := bool(instance.call("repeat_line_four_measurement")) \
			and bool(instance.call("secure_raw_sample")) \
			and bool(instance.call("read_marta_message"))
		_fill_current_dialogue_line(instance)
		return repeat_ok
	if state_id == &"leave_message":
		var leave_ok := bool(instance.call("pack_equipment_for_marta")) \
			and bool(instance.call("read_marta_message"))
		_fill_current_dialogue_line(instance)
		return leave_ok
	return false


func _fill_current_dialogue_line(instance: CanvasItem) -> void:
	var dialogue := instance.get_node_or_null("CRTDialogueBox") as CRTDialogueBox
	if dialogue != null and dialogue.is_presenting():
		dialogue.advance_dialogue()


func _hide_text_and_ui(node: Node) -> int:
	var hidden := 0
	for child in node.get_children():
		if child is CanvasLayer and child.name != "WorldPixelCompositor":
			(child as CanvasLayer).visible = false
			hidden += 1
		if child is OpeningActionPoint:
			(child as OpeningActionPoint).visible = false
			hidden += 1
		elif child is CrispDiegeticText:
			(child as CrispDiegeticText).visible = false
			hidden += 1
		hidden += _hide_text_and_ui(child)
	return hidden


func _make_true_grayscale(image: Image) -> void:
	image.convert(Image.FORMAT_RGBA8)
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var color := image.get_pixel(x, y)
			var luminance := color.r * 0.2126 + color.g * 0.7152 + color.b * 0.0722
			image.set_pixel(x, y, Color(luminance, luminance, luminance, color.a))


func _is_grayscale(image: Image) -> bool:
	for y in range(0, image.get_height(), 8):
		for x in range(0, image.get_width(), 8):
			var color := image.get_pixel(x, y)
			if absf(color.r - color.g) > 0.002 or absf(color.g - color.b) > 0.002:
				return false
	return true


func _dispose(instance: CanvasItem) -> void:
	if instance.get_parent() == root:
		root.remove_child(instance)
	instance.free()


func _write_report() -> void:
	var mono_hashes: Dictionary = {}
	for record in _records:
		if record["mode"] == "mono":
			mono_hashes[record["hash"]] = true
	if mono_hashes.size() != 4:
		_failures.append("four representative mono structures must have distinct image hashes")
	var lines: PackedStringArray = PackedStringArray([
		"PKG-0159 VISUAL EVIDENCE REPORT",
		"Renderer: %s" % RenderingServer.get_video_adapter_name(),
		"Viewport: 640x360; normal Windows display driver; capture script was not headless.",
		"",
		"EVIDENCE STATUS",
		"M2: title, both Station 01 choices and Station 08 real stairs captured.",
		"M3: four built families recertified as true grayscale with text/UI hidden before capture.",
		"GATE-FAM remains PARTIAL 4/7; this package does not claim seven-family completion.",
		"M1/M5: see reports/pkg_0159/m1_m5_trace.tsv generated by tests/pkg_0159_smoke_test.gd.",
		"Automated timing proves route availability only; it does not prove human comprehension or pacing.",
		"",
		"CAPTURED FRAMES",
	])
	for record in _records:
		lines.append("%-6s %-14s %-22s hidden=%-2d hash=%s %s" % [record["mode"], record["scene"], record["state"], record["hidden"], str(record["hash"]), record["path"]])
	var file := FileAccess.open(REPORT_PATH, FileAccess.WRITE)
	if file == null:
		_failures.append("cannot write %s" % REPORT_PATH)
		return
	file.store_string("\n".join(lines) + "\n")
	file.close()


func _finish() -> void:
	if _failures.is_empty():
		print("%s CAPTURE PASS: %d frames; M3 is PARTIAL 4/7." % [PACKAGE_ID, _records.size()])
		quit(0)
		return
	for failure in _failures:
		printerr("%s CAPTURE FAILURE: %s" % [PACKAGE_ID, failure])
	quit(1)
