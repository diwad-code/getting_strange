extends SceneTree

## PKG-0142 normal-driver visual evidence.
##
## Run with a rendering device, never headless:
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0142.gd
##
## The capture deliberately separates technical evidence from audience claims:
## every campaign scene is rendered in normal and reduced-motion modes, while
## only the named Act IV/finale frames receive the dialogue panel. The script
## never calls `_draw()`; it only drives the public scene surface and saves the
## resulting viewport image.

const PACKAGE_ID := "PKG-0142"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0142"
const REPORT_PATH := "res://reports/pkg_0142_visual_capture_report.txt"
const SETTLE_PHYSICS_FRAMES := 48
const SETTLE_PROCESS_FRAMES := 4

const ALL_SCENE_IDS: Array[StringName] = [
	&"station_01", &"station_02", &"station_03", &"station_04", &"station_05",
	&"station_06", &"station_07", &"station_08", &"station_09", &"station_10",
	&"station_11", &"station_12", &"station_13", &"station_14", &"station_15",
	&"station_16", &"station_17", &"station_18", &"station_19", &"station_20",
	&"station_21", &"station_22", &"station_23", &"station_24", &"station_25",
	&"station_26", &"station_27", &"station_28", &"station_29", &"station_30",
	&"station_31", &"station_32", &"station_33", &"station_34", &"station_35",
	&"station_36", &"station_37", &"station_38", &"station_39", &"station_40",
	&"station_41", &"station_42a", &"station_42b", &"station_42c", &"station_43",
]

const DIALOGUE_SCENE_IDS: Array[StringName] = [
	&"station_33", &"station_38", &"station_41",
	&"station_42a", &"station_42b", &"station_42c", &"station_43",
]

## Station 01 receives one extra framed shot so §4.3 is evidenced in the
## same dialogue state that exposed the former black wedge.
const LAYOUT_DIALOGUE_SCENE_IDS: Array[StringName] = [&"station_01"]


var _failures: Array[String] = []
var _capture_records: Array[Dictionary] = []


func _initialize() -> void:
	call_deferred(&"_capture_all")


func _capture_all() -> void:
	root.size = LOGICAL_SIZE
	var output_dir := ProjectSettings.globalize_path(OUTPUT_ROOT)
	if DirAccess.make_dir_recursive_absolute(output_dir) != OK:
		push_error(PACKAGE_ID + " CAPTURE: cannot create " + output_dir)
		quit(1)
		return
	for mode in ["normal", "reduced"]:
		var mode_dir := output_dir.path_join(mode)
		if DirAccess.make_dir_recursive_absolute(mode_dir) != OK:
			push_error(PACKAGE_ID + " CAPTURE: cannot create " + mode_dir)
			quit(1)
			return

	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.campaign_auto_transition_enabled = false
		state.set_pause_menu_visible(false)

	for reduced_motion in [false, true]:
		var mode := "reduced" if reduced_motion else "normal"
		MotionAccessibility.set_reduced_motion(reduced_motion)
		print(PACKAGE_ID + " CAPTURE: mode=" + mode + " scenes=" + str(ALL_SCENE_IDS.size()))
		for scene_id in ALL_SCENE_IDS:
			await _capture_scene(scene_id, mode, false)
		for scene_id in LAYOUT_DIALOGUE_SCENE_IDS:
			await _capture_scene(scene_id, mode, true)
		for scene_id in DIALOGUE_SCENE_IDS:
			await _capture_scene(scene_id, mode, true)


	MotionAccessibility.reset()
	if state:
		state.set_pause_menu_visible(false)
		state.campaign_auto_transition_enabled = true

	_write_capture_report()
	if _failures.is_empty():
		print(PACKAGE_ID + " CAPTURE PASS: 106 frames in " + OUTPUT_ROOT)

		quit(0)
	else:
		for failure in _failures:
			push_error(PACKAGE_ID + " CAPTURE: " + failure)
		quit(1)


func _capture_scene(scene_id: StringName, mode: String, include_dialogue: bool) -> void:
	var scene_path := "%s/%s.tscn" % ["res://scenes/levels", scene_id]
	var packed := load(scene_path) as PackedScene
	if packed == null:
		_failures.append("cannot load " + scene_path)
		return

	var station := packed.instantiate() as Node2D
	if station == null:
		_failures.append("scene root is not Node2D: " + scene_path)
		return
	root.add_child(station)
	for _frame in range(12):
		await process_frame

	var dialogue := _find(station, func(node): return node is CanvasLayer and node.has_method("is_presenting"))
	if dialogue != null and dialogue.has_method("hide_box"):
		dialogue.call("hide_box")
	if include_dialogue:
		if dialogue == null or not dialogue.has_method("present"):
			_failures.append("%s: dialogue capture needs CRTDialogueBox" % scene_id)
		else:
			dialogue.call("present", [{
				"speaker": "LENA",
				"text": "Dowód kadru: zdarzenie, reakcja, tekst.",
			}])

	station.queue_redraw()
	for _frame in range(SETTLE_PHYSICS_FRAMES):
		await physics_frame
	for _frame in range(SETTLE_PROCESS_FRAMES):
		await process_frame
	await RenderingServer.frame_post_draw

	var image := root.get_texture().get_image()
	var relative_path := OUTPUT_ROOT.path_join(mode).path_join(
		("dialogue_" if include_dialogue else "") + String(scene_id) + ".png"
	)
	var absolute_path := ProjectSettings.globalize_path(relative_path)
	if image == null or image.get_size() != LOGICAL_SIZE:
		_failures.append("%s: wrong render size for %s" % [scene_id, relative_path])
	elif image.save_png(absolute_path) != OK:
		_failures.append("%s: cannot save %s" % [scene_id, relative_path])
	else:
		var camera := _find(station, func(node): return node is CinematicCamera) as CinematicCamera
		var camera_y := camera.global_position.y if camera != null else -1.0
		_capture_records.append({
			"mode": mode,
			"id": String(scene_id),
			"dialogue": include_dialogue,
			"path": relative_path,
			"camera_y": camera_y,
		})
		print(PACKAGE_ID + " CAPTURE PASS: " + relative_path)

	if station.get_parent() == root:
		root.remove_child(station)
	station.free()
	await process_frame


func _write_capture_report() -> void:
	var lines: Array[String] = []
	lines.append(PACKAGE_ID + " VISUAL CAPTURE REPORT")
	lines.append("Technical evidence only; no line below claims readability, appeal, comprehension or fun.")
	lines.append("Logical size: 640x360; normal Windows rendering device; physics settle frames: %d." % SETTLE_PHYSICS_FRAMES)
	lines.append("")
	lines.append("CAPTURED FRAMES")
	for record in _capture_records:
		lines.append(
			"%-7s %-19s cam_y=%6.1f  %s" % [
				String(record["mode"]),
				String(record["path"]),
				float(record["camera_y"]),
				"dialogue" if bool(record["dialogue"]) else "world",
			]
		)

	lines.append("")
	lines.append("NORMAL VS REDUCED COMPARISON (2x2 sample grid; threshold 0.015 per RGB sum)")
	for scene_id in ALL_SCENE_IDS:
		lines.append(_compare_pair(String(scene_id), false))
	for scene_id in LAYOUT_DIALOGUE_SCENE_IDS:
		lines.append(_compare_pair("dialogue_" + String(scene_id), true))
	for scene_id in DIALOGUE_SCENE_IDS:
		lines.append(_compare_pair("dialogue_" + String(scene_id), true))

	lines.append("")
	lines.append("INTERPRETATION BOUNDARY")
	lines.append("Reduced motion is intended to remove peripheral amplitude and decorative micro-particle emission only.")
	lines.append("The image delta is a rendered-difference measurement; manual inspection records what remains visible.")
	lines.append("It does not prove that any human reader finds a frame clear or comfortable.")

	var file := FileAccess.open(REPORT_PATH, FileAccess.WRITE)
	if file == null:
		_failures.append("cannot write " + REPORT_PATH)
		return
	file.store_string("\n".join(lines) + "\n")
	file.close()


func _compare_pair(stem: String, dialogue: bool) -> String:
	var normal_relative := OUTPUT_ROOT.path_join("normal").path_join(stem + ".png")
	var reduced_relative := OUTPUT_ROOT.path_join("reduced").path_join(stem + ".png")
	var normal := Image.load_from_file(ProjectSettings.globalize_path(normal_relative))
	var reduced := Image.load_from_file(ProjectSettings.globalize_path(reduced_relative))
	if normal == null or reduced == null:
		return "%s missing normal/reduced image" % stem
	if normal.get_size() != reduced.get_size():
		return "%s size mismatch %s vs %s" % [stem, str(normal.get_size()), str(reduced.get_size())]

	var changed := 0
	var sampled := 0
	var sum_delta := 0.0
	var max_delta := 0.0
	for y in range(0, normal.get_height(), 2):
		for x in range(0, normal.get_width(), 2):
			var a := normal.get_pixel(x, y)
			var b := reduced.get_pixel(x, y)
			var delta := absf(a.r - b.r) + absf(a.g - b.g) + absf(a.b - b.b)
			sampled += 1
			sum_delta += delta
			max_delta = maxf(max_delta, delta)
			if delta > 0.015:
				changed += 1
	var mean_delta := sum_delta / float(sampled) if sampled > 0 else 0.0
	return "%s sampled=%d changed=%d mean_delta=%.5f max_delta=%.5f" % [
		stem, sampled, changed, mean_delta, max_delta,
	]


func _find(node: Node, predicate: Callable) -> Node:
	if predicate.call(node):
		return node
	for child in node.get_children():
		var found := _find(child, predicate)
		if found != null:
			return found
	return null
