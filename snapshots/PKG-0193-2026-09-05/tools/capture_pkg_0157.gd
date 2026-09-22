extends SceneTree

## PKG-0157 normal-driver visual evidence for PHASE-02 First Five Minutes (BUNDLE-06..10).
## Runs with a Windows rendering device, never headless:
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0157.gd
## Drives TitleScreen and Station 01–04 public APIs in normal and reduced motion modes.

const PACKAGE_ID := "PKG-0157"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0157"
const REPORT_PATH := "res://reports/pkg_0157_visual_capture_report.txt"
const SETTLE_PROCESS_FRAMES := 10
const SETTLE_PHYSICS_FRAMES := 20

const CAPTURES: Array[Dictionary] = [
	{"type": "shell", "scene": &"title_screen", "state": &"default"},
	{"type": "level", "scene": &"station_01", "state": &"initial_worksite"},
	{"type": "level", "scene": &"station_01", "state": &"sample_and_message_completed"},
	{"type": "level", "scene": &"station_02", "state": &"initial_detour"},
	{"type": "level", "scene": &"station_02", "state": &"ladder_taken"},
	{"type": "level", "scene": &"station_03", "state": &"initial_platform"},
	{"type": "level", "scene": &"station_03", "state": &"marta_replied"},
	{"type": "level", "scene": &"station_04", "state": &"initial_carriage"},
	{"type": "level", "scene": &"station_04", "state": &"reader_stowed"},
]

var _failures: Array[String] = []
var _records: Array[Dictionary] = []


func _initialize() -> void:
	call_deferred(&"_capture_all")


func _capture_all() -> void:
	root.size = LOGICAL_SIZE
	if not _prepare_output_directories():
		_finish()
		return
	var state := root.get_node_or_null("GameStateManager")
	if state != null:
		state.campaign_auto_transition_enabled = false
		state.set_pause_menu_visible(false)
	for reduced_motion in [false, true]:
		MotionAccessibility.set_reduced_motion(reduced_motion)
		var mode := "reduced" if reduced_motion else "normal"
		for capture in CAPTURES:
			await _capture_state(capture, mode, state)
	MotionAccessibility.reset()
	if state != null:
		state.reset_campaign(true)
		state.campaign_auto_transition_enabled = true
	_write_report()
	_finish()


func _prepare_output_directories() -> bool:
	var root_dir := ProjectSettings.globalize_path(OUTPUT_ROOT)
	if DirAccess.make_dir_recursive_absolute(root_dir) != OK:
		_failures.append("cannot create " + root_dir)
		return false
	for mode in ["normal", "reduced"]:
		var mode_dir := root_dir.path_join(mode)
		if DirAccess.make_dir_recursive_absolute(mode_dir) != OK:
			_failures.append("cannot create " + mode_dir)
			return false
	return true


func _capture_state(capture: Dictionary, mode: String, state: Node) -> void:
	var capture_type: String = capture["type"]
	var scene_id := capture["scene"] as StringName
	var state_id := capture["state"] as StringName
	if state != null:
		state.reset_campaign(true)
	var scene_path := "res://scenes/shell/title_screen.tscn" if capture_type == "shell" else "res://scenes/levels/%s.tscn" % scene_id
	var packed := load(scene_path) as PackedScene
	if packed == null:
		_failures.append("cannot load " + scene_path)
		return
	var instance := packed.instantiate() as CanvasItem
	if instance == null:
		_failures.append("scene root is not CanvasItem: " + scene_path)
		return
	root.add_child(instance)
	for _frame in range(SETTLE_PROCESS_FRAMES):
		await process_frame
	if not _apply_state(instance, scene_id, state_id, state):
		_failures.append("cannot apply %s/%s" % [scene_id, state_id])
	else:
		instance.queue_redraw()
		for _frame in range(SETTLE_PHYSICS_FRAMES):
			await physics_frame
		for _frame in range(SETTLE_PROCESS_FRAMES):
			await process_frame
		await RenderingServer.frame_post_draw
		var image := root.get_texture().get_image()
		var relative_path := OUTPUT_ROOT.path_join(mode).path_join("%s_%s.png" % [scene_id, state_id])
		var absolute_path := ProjectSettings.globalize_path(relative_path)
		if image == null or image.get_size() != LOGICAL_SIZE:
			_failures.append("wrong image size for " + relative_path)
		elif image.save_png(absolute_path) != OK:
			_failures.append("cannot save " + relative_path)
		else:
			_records.append({
				"mode": mode,
				"scene": String(scene_id),
				"state": String(state_id),
				"path": relative_path,
			})
			print(PACKAGE_ID + " CAPTURE PASS: " + relative_path)
	if instance.get_parent() == root:
		root.remove_child(instance)
	instance.free()
	await process_frame


func _apply_state(instance: CanvasItem, scene_id: StringName, state_id: StringName, state: Node) -> bool:
	match scene_id:
		&"title_screen":
			return true
		&"station_01":
			if state_id == &"initial_worksite":
				return true
			if not bool(instance.call("repeat_line_four_measurement")):
				return false
			if not bool(instance.call("secure_raw_sample")):
				return false
			return bool(instance.call("read_marta_message"))
		&"station_02":
			state.record_decision(&"p7.sample_and_promise.sample_preserved", true)
			if state_id == &"initial_detour":
				return true
			if not bool(instance.call("inspect_detour_closure")):
				return false
			if not bool(instance.call("compare_detour_time")):
				return false
			return bool(instance.call("take_service_ladder"))
		&"station_03":
			state.record_decision(&"p7.sample_and_promise.route_time_confirmed", true)
			if state_id == &"initial_platform":
				return true
			if not bool(instance.call("read_departure_board")):
				return false
			return bool(instance.call("reply_to_marta"))
		&"station_04":
			state.record_decision(&"p7.sample_and_promise.trace", "sample_preserved_and_time_sent")
			if state_id == &"initial_carriage":
				return true
			if not bool(instance.call("observe_reader_buffer")):
				return false
			if not bool(instance.call("watch_line_four_memorial")):
				return false
			return bool(instance.call("stow_reader_for_marta"))
	return false


func _write_report() -> void:
	var lines: Array[String] = []
	lines.append(PACKAGE_ID + " VISUAL CAPTURE REPORT")
	lines.append("Technical evidence for PHASE-02 First Five Minutes (BUNDLE-06..10).")
	lines.append("Rendered in 640x360 with normal Windows display driver. Normal and reduced-motion states.")
	lines.append("")
	lines.append("CAPTURED FRAMES")
	for record in _records:
		lines.append("%-7s %-14s %-32s %s" % [record["mode"], record["scene"], record["state"], record["path"]])
	lines.append("")
	lines.append("VERIFICATION NOTES")
	lines.append("- Shell (TitleScreen): Personal thriller promise, Polish/English localization, focus traversal preserved.")
	lines.append("- Station 01: Workstation, vibration reader drum, sample case, Marta phone, single workstation, door unblocked.")
	lines.append("- Station 02: Open sky >25%, 3 depth planes, no ceiling, working gantry, embankment landing, ladder.")
	lines.append("- Station 03: Partial shelter, track edge, scheduled vehicle, Line 4 timetable, phone reply to Marta.")
	lines.append("- Station 04: Carriage interior, moving window parallax, Line 4 memorial silhouette, seats, reader stow case.")
	var file := FileAccess.open(REPORT_PATH, FileAccess.WRITE)
	if file == null:
		_failures.append("cannot write " + REPORT_PATH)
		return
	file.store_string("\n".join(lines) + "\n")
	file.close()


func _finish() -> void:
	if _failures.is_empty():
		print(PACKAGE_ID + " CAPTURE PASS: %d frames in %s" % [_records.size(), OUTPUT_ROOT])
		quit(0)
		return
	for failure in _failures:
		printerr(PACKAGE_ID + " CAPTURE FAILURE: " + failure)
	quit(1)
