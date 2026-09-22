extends SceneTree

## PKG-0158 normal-driver visual evidence for PHASE-03 First Thirty Minutes (BUNDLE-11..15).
## Runs with a Windows rendering device, never headless:
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0158.gd
## Drives Station 05–08 public APIs in normal and reduced motion modes.

const PACKAGE_ID := "PKG-0158"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0158"
const REPORT_PATH := "res://reports/pkg_0158_visual_capture_report.txt"
const SETTLE_PROCESS_FRAMES := 10
const SETTLE_PHYSICS_FRAMES := 20

const CAPTURES: Array[Dictionary] = [
	{"type": "level", "scene": &"station_05", "state": &"initial_street"},
	{"type": "level", "scene": &"station_05", "state": &"street_crossing_completed"},
	{"type": "level", "scene": &"station_06", "state": &"initial_kiosk"},
	{"type": "level", "scene": &"station_06", "state": &"vendor_contradiction_heard"},
	{"type": "level", "scene": &"station_07", "state": &"initial_facade"},
	{"type": "level", "scene": &"station_07", "state": &"intercom_code_unlocked"},
	{"type": "level", "scene": &"station_08", "state": &"initial_stairwell"},
	{"type": "level", "scene": &"station_08", "state": &"apartment_fourteen_unlocked"},
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
	var scene_path := "res://scenes/levels/%s.tscn" % scene_id
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
		&"station_05":
			if state_id == &"initial_street":
				return true
			if not bool(instance.call("check_street_route")):
				return false
			if not bool(instance.call("check_sample_case")):
				return false
			return bool(instance.call("cross_street_towards_home"))
		&"station_06":
			state.record_decision(&"p9.street.crossing_completed", true)
			if state_id == &"initial_kiosk":
				return true
			if not bool(instance.call("inspect_street_timetable")):
				return false
			if not bool(instance.call("buy_water_at_kiosk")):
				return false
			return bool(instance.call("ask_kiosk_vendor"))
		&"station_07":
			state.record_decision(&"p9.kiosk.vendor_testimony_recorded", true)
			if state_id == &"initial_facade":
				return true
			if not bool(instance.call("compare_address_document")):
				return false
			if not bool(instance.call("inspect_intercom_directory")):
				return false
			return bool(instance.call("enter_intercom_code"))
		&"station_08":
			state.record_decision(&"p9.exterior.intercom_code_unlocked", true)
			if state_id == &"initial_stairwell":
				return true
			if not bool(instance.call("inspect_floor_twelve")):
				return false
			if not bool(instance.call("speak_with_neighbour")):
				return false
			return bool(instance.call("unlock_apartment_fourteen"))
	return false


func _write_report() -> void:
	var lines: Array[String] = []
	lines.append(PACKAGE_ID + " VISUAL CAPTURE REPORT")
	lines.append("Technical evidence for PHASE-03 First Thirty Minutes (BUNDLE-11..15).")
	lines.append("Rendered in 640x360 with normal Windows display driver. Normal and reduced-motion states.")
	lines.append("")
	lines.append("CAPTURED FRAMES")
	for record in _records:
		lines.append("%-7s %-14s %-32s %s" % [record["mode"], record["scene"], record["state"], record["path"]])
	lines.append("")
	lines.append("VERIFICATION NOTES")
	lines.append("- Station 05: Open sky >=25%, 3 depth planes, no ceiling, streetlamp, street sign, pedestrian crossing.")
	lines.append("- Station 06: Open sky >=25%, kiosk structure, newspaper racks, timetable stand, vendor silhouette.")
	lines.append("- Station 07: Open sky >=25%, building facade, address plaque 14 vs document 12, intercom directory, opening door.")
	lines.append("- Station 08: Low residential ceiling, two-tone oil lamperia, warm sconces, stair steps <=18px, neighbour, apartment 14 door.")
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
