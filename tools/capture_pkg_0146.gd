extends SceneTree

## PKG-0146 normal-driver visual evidence for P7 S01–S05 (Station 01–14).
## Run with a Windows rendering device, never headless:
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0146.gd
## The script drives only public station APIs, captures rendered states in both
## motion modes, and makes no claim about human comprehension or enjoyment.

const PACKAGE_ID := "PKG-0146"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0146"
const REPORT_PATH := "res://reports/pkg_0146_visual_capture_report.txt"
const SETTLE_PROCESS_FRAMES := 8
const SETTLE_PHYSICS_FRAMES := 20

const CAPTURES: Array[Dictionary] = [
	{"scene": &"station_01", "state": &"gap_only"},
	{"scene": &"station_01", "state": &"sample_committed"},
	{"scene": &"station_04", "state": &"reader_trial_committed"},
	{"scene": &"station_06", "state": &"public_route_compared"},
	{"scene": &"station_08", "state": &"intercom_completed"},
	{"scene": &"station_10", "state": &"cautious_entry"},
	{"scene": &"station_12", "state": &"questions_prepared"},
	{"scene": &"station_14", "state": &"threshold_respected"},
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
		&"station_01":
			if not bool(station.call("observe_measurement_gap")):
				return false
			if state_id == &"gap_only":
				return true
			if not bool(station.call("inspect_sensor_mount")):
				return false
			if not bool(station.call("record_raw_measurement")):
				return false
			if not bool(station.call("repeat_measurement")):
				return false
			return bool(station.call("preserve_raw_sample"))
		&"station_04":
			state.record_decision(&"p7.sample_and_promise.trace", "sample_preserved_and_time_sent")
			if not bool(station.call("observe_reader_repeat")):
				return false
			if not bool(station.call("observe_wagon_clock")):
				return false
			return bool(station.call("repeat_reader_without_route_change"))
		&"station_06":
			state.record_decision(&"p7.return_under_control.trace", "reader_secured_without_paranormal_claim")
			if not bool(station.call("observe_paper_timetable")):
				return false
			if not bool(station.call("observe_offline_route")):
				return false
			return bool(station.call("compare_public_route"))
		&"station_08":
			state.record_decision(&"p7.address_and_record.shopkeeper_answer", "yesterday_purchase")
			if not bool(station.call("read_certificate")):
				return false
			if not bool(station.call("read_directory")):
				return false
			return bool(station.call("test_intercom_recognition"))
		&"station_10":
			state.record_decision(&"p9.threshold_obstacle.foreign_daily_life.neighbour_account", "twelve_lower_fourteen_home")
			if not bool(station.call("inspect_key_wear")):
				return false
			if not bool(station.call("test_key_without_claiming_home")):
				return false
			return bool(station.call("commit_cautious_entry"))
		&"station_12":
			state.record_decision(&"p9.threshold_obstacle.foreign_daily_life.trace", "foreign_address_and_photograph")
			if not bool(station.call("close_balcony")):
				return false
			if not bool(station.call("listen_to_message")):
				return false
			if not bool(station.call("verify_caller_identity")):
				return false
			return bool(station.call("prepare_independent_questions"))
		&"station_14":
			state.record_decision(&"p9.threshold_obstacle.marta_threshold.recall_requested", true)
			if not bool(station.call("place_bag_at_door")):
				return false
			if not bool(station.call("disclose_arrival_time")):
				return false
			if not bool(station.call("compare_field_equipment")):
				return false
			if not bool(station.call("verify_key_position")):
				return false
			return bool(station.call("ask_independent_day_description"))
	return false


func _write_report() -> void:
	var lines: Array[String] = []
	lines.append(PACKAGE_ID + " VISUAL CAPTURE REPORT")
	lines.append("Technical evidence only: rendered state, layer presence and normal/reduced output. No line claims comprehension, fun, emotional credibility or comfort.")
	lines.append("Logical size: 640x360. Normal Windows rendering device. Public P7 station APIs drove each state.")
	lines.append("")
	lines.append("CAPTURED STATES")
	for record in _records:
		lines.append("%-7s %-12s %-22s %s" % [record["mode"], record["scene"], record["state"], record["path"]])
	lines.append("")
	lines.append("INSPECTION SCOPE")
	lines.append("Station 01: gap observation vs committed sample state.")
	lines.append("Station 04: reader repeat and wagon clock compared, exit unlocked.")
	lines.append("Station 06: paper and offline route compared against the arriving vehicle.")
	lines.append("Station 08: certificate, directory and intercom test completed.")
	lines.append("Station 10: key wear, key trial and cautious entry committed.")
	lines.append("Station 12: balcony closed, message heard, caller verified, questions prepared.")
	lines.append("Station 14: bag placed, three details disclosed and independent day description obtained.")
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
