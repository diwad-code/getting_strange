extends SceneTree

## PKG-0145 normal-driver visual evidence for the P7 diagnostic slice.
## Run with a Windows rendering device, never headless:
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0145.gd
## The script drives only public station APIs, captures rendered states in both
## motion modes, and makes no claim about human comprehension or enjoyment.

const PACKAGE_ID := "PKG-0145"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0145"
const REPORT_PATH := "res://reports/pkg_0145_visual_capture_report.txt"
const SETTLE_PROCESS_FRAMES := 8
const SETTLE_PHYSICS_FRAMES := 20

const CAPTURES: Array[Dictionary] = [
	{"scene": &"station_22", "state": &"hypotheses"},
	{"scene": &"station_23", "state": &"anchor"},
	{"scene": &"station_23", "state": &"yield"},
	{"scene": &"station_24", "state": &"limited_access"},
	{"scene": &"station_24", "state": &"declined"},
	{"scene": &"station_25", "state": &"paired_with_notes"},
	{"scene": &"station_25", "state": &"technical_route"},
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
	var scene_id := capture["scene"] as StringName
	var state_id := capture["state"] as StringName
	if state != null:
		state.reset_campaign(true)
	var packed := load("res://scenes/levels/%s.tscn" % scene_id) as PackedScene
	if packed == null:
		_failures.append("cannot load " + String(scene_id))
		return
	var station := packed.instantiate() as Node2D
	if station == null:
		_failures.append("scene root is not Node2D: " + String(scene_id))
		return
	root.add_child(station)
	for _frame in range(SETTLE_PROCESS_FRAMES):
		await process_frame
	if not _apply_state(station, scene_id, state_id, state):
		_failures.append("cannot apply %s/%s" % [scene_id, state_id])
	else:
		station.queue_redraw()
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
	if station.get_parent() == root:
		root.remove_child(station)
	station.free()
	await process_frame


func _apply_state(station: Node2D, scene_id: StringName, state_id: StringName, state: Node) -> bool:
	match scene_id:
		&"station_22":
			if state == null:
				return false
			state.record_decision(&"world_recognized", true)
			station.call("observe_signal_echo")
			station.call("observe_adjacent_state")
			return station.get("is_hypotheses_opened") == true
		&"station_23":
			if state == null:
				return false
			state.record_decision(&"world_recognized", true)
			state.record_decision(&"p7.mutual_test.signal_echo_observed", true)
			state.record_decision(&"p7.mutual_test.adjacent_state_observed", true)
			if state_id == &"anchor":
				return bool(station.call("perform_anchor_trial"))
			if state_id == &"yield":
				return bool(station.call("perform_yield_trial"))
		&"station_24":
			if state == null:
				return false
			state.record_decision(&"mechanic_cost_observed", true)
			station.call("disclose_marta_scope")
			station.call("disclose_marta_risk")
			station.call("disclose_marta_cost")
			if state_id == &"limited_access":
				return bool(station.call("choose_limited_access"))
			if state_id == &"declined":
				return bool(station.call("choose_declined"))
		&"station_25":
			if state == null:
				return false
			var boundary := "limited_access" if state_id == &"paired_with_notes" else "declined"
			state.record_decision(&"p7.mutual_test.marta_boundary", boundary)
			station.call("observe_ventilation_cycle")
			station.call("release_interlock")
			station.call("route_power")
			return bool(station.call("retrieve_ucp_buffer"))
	return false


func _write_report() -> void:
	var lines: Array[String] = []
	lines.append(PACKAGE_ID + " VISUAL CAPTURE REPORT")
	lines.append("Technical evidence only: rendered state, layer presence and normal/reduced output. No line claims comprehension, fun, emotional credibility or comfort.")
	lines.append("Logical size: 640x360. Normal Windows rendering device. Public P7 station APIs drove each state.")
	lines.append("")
	lines.append("CAPTURED STATES")
	for record in _records:
		lines.append("%-7s %-12s %-20s %s" % [record["mode"], record["scene"], record["state"], record["path"]])
	lines.append("")
	lines.append("INSPECTION SCOPE")
	lines.append("Station 22: two signal observations and opened hypotheses.")
	lines.append("Station 23: Anchor and Yield states with their separate local costs.")
	lines.append("Station 24: limited access and declined boundary states.")
	lines.append("Station 25: paired-with-notes and technical-route buffer traces.")
	lines.append("Reduced-motion frames retain the same state facts while peripheral amplitude is reduced by the existing accessibility system.")
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
