extends SceneTree

# PKG-0160 normal-driver evidence. Run without --headless.
const PACKAGE_ID := "PKG-0160"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0160"
const REPORT_PATH := "res://reports/pkg_0160/visual_evidence_report.txt"
const CAPTURES: Array[Dictionary] = [
	{"mode": "normal", "scene": &"station_09"},
	{"mode": "normal", "scene": &"station_10"},
	{"mode": "normal", "scene": &"station_11"},
	{"mode": "normal", "scene": &"station_12"},
	{"mode": "normal", "scene": &"station_13"},
	{"mode": "normal", "scene": &"station_20"},
	{"mode": "normal", "scene": &"station_40"},
	{"mode": "mono", "scene": &"station_01"},
	{"mode": "mono", "scene": &"station_02"},
	{"mode": "mono", "scene": &"station_03"},
	{"mode": "mono", "scene": &"station_09"},
	{"mode": "mono", "scene": &"station_11"},
	{"mode": "mono", "scene": &"station_12"},
	{"mode": "mono", "scene": &"station_15"},
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
	var scene_id := capture["scene"] as StringName
	var mode: String = capture["mode"]
	var packed := load("res://scenes/levels/%s.tscn" % scene_id) as PackedScene
	if packed == null:
		_failures.append("cannot load %s" % scene_id)
		return
	var instance := packed.instantiate() as CanvasItem
	if instance == null:
		_failures.append("root is not CanvasItem: %s" % scene_id)
		return
	root.add_child(instance)
	for _frame in range(8):
		await process_frame
	var dialogue := instance.get_node_or_null("CRTDialogueBox") as CRTDialogueBox
	if dialogue != null:
		dialogue.hide_box()
	var hidden := 0
	if mode == "mono":
		hidden = _hide_text_and_ui(instance)
	instance.queue_redraw()
	for _frame in range(20):
		await physics_frame
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	if image == null or image.get_size() != LOGICAL_SIZE:
		_failures.append("wrong frame for %s" % scene_id)
		_dispose(instance)
		return
	if mode == "mono":
		_make_true_grayscale(image)
		if not _is_grayscale(image):
			_failures.append("residual color in %s" % scene_id)
	var relative_path := OUTPUT_ROOT.path_join(mode).path_join("%s_structure.png" % scene_id)
	if image.save_png(ProjectSettings.globalize_path(relative_path)) != OK:
		_failures.append("cannot save %s" % relative_path)
	else:
		_records.append({"mode": mode, "scene": String(scene_id), "path": relative_path, "hidden": hidden, "hash": hash(image.get_data())})
		print("%s CAPTURE PASS: %s hidden=%d" % [PACKAGE_ID, relative_path, hidden])
	_dispose(instance)
	await process_frame

func _hide_text_and_ui(node: Node) -> int:
	var hidden := 0
	for child in node.get_children():
		if child is CanvasLayer and child.name != "WorldPixelCompositor":
			(child as CanvasLayer).visible = false
			hidden += 1
		if child is OpeningActionPoint or child is CrispDiegeticText:
			(child as CanvasItem).visible = false
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
	if mono_hashes.size() != 7:
		_failures.append("seven family blockouts must have distinct image hashes")
	var lines := PackedStringArray([
		"PKG-0160 VISUAL EVIDENCE REPORT",
		"Renderer: %s" % RenderingServer.get_video_adapter_name(),
		"Viewport: 640x360; normal Windows display driver; script was not headless.",
		"M3: seven grayscale, textless structural family frames; hash distinctness is structural evidence only.",
		"Normal frames: Station 09–13 personal-mystery staging plus Station 20/40 Marta identity continuity.",
		"This capture does not prove human recognition, empathy, pacing or PRODUCT GO.",
		"",
	])
	for record in _records:
		lines.append("%-6s %-12s hidden=%-2d hash=%s %s" % [record["mode"], record["scene"], record["hidden"], str(record["hash"]), record["path"]])
	var file := FileAccess.open(REPORT_PATH, FileAccess.WRITE)
	if file == null:
		_failures.append("cannot write visual report")
		return
	file.store_string("\n".join(lines) + "\n")
	file.close()

func _finish() -> void:
	if _failures.is_empty():
		print("%s CAPTURE PASS: 7 normal frames and 7 M3 family frames." % PACKAGE_ID)
		quit(0)
		return
	for failure in _failures:
		printerr("%s CAPTURE FAILURE: %s" % [PACKAGE_ID, failure])
	quit(1)
