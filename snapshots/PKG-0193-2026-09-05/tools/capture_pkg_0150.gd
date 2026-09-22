extends SceneTree

## PKG-0150 normal-driver visual evidence for P7 S14–S15 (Station 39–43).
## Run with a Windows rendering device, never headless:
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0150.gd
## The driver uses public station APIs only and makes no claim about human reception.

const PACKAGE_ID := "PKG-0150"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0150"
const REPORT_PATH := "res://reports/pkg_0150_visual_capture_report.txt"
const SETTLE_PROCESS_FRAMES := 8
const SETTLE_PHYSICS_FRAMES := 20

const CAPTURES: Array[Dictionary] = [
	{"scene": &"station_39", "state": &"configs_inspected"},
	{"scene": &"station_39", "state": &"matrix_reviewed"},
	{"scene": &"station_40", "state": &"witnesses_inspected"},
	{"scene": &"station_40", "state": &"negotiation_confronted"},
	{"scene": &"station_41", "state": &"topography_inspected"},
	{"scene": &"station_41", "state": &"operation_committed_a"},
	{"scene": &"station_41", "state": &"operation_committed_b"},
	{"scene": &"station_41", "state": &"operation_committed_c"},
	{"scene": &"station_42a", "state": &"cups_inspected"},
	{"scene": &"station_42a", "state": &"chamber_a_witnessed"},
	{"scene": &"station_42b", "state": &"doorstep_inspected"},
	{"scene": &"station_42b", "state": &"chamber_b_witnessed"},
	{"scene": &"station_42c", "state": &"tram_inspected"},
	{"scene": &"station_42c", "state": &"chamber_c_witnessed"},
	{"scene": &"station_43", "state": &"notice_and_credits"},
	{"scene": &"station_43", "state": &"epilogue_completed"},
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
	if state == null:
		_failures.append("GameStateManager unavailable")
		_finish()
		return
	state.campaign_auto_transition_enabled = false
	state.set_pause_menu_visible(false)
	for reduced_motion in [false, true]:
		MotionAccessibility.set_reduced_motion(reduced_motion)
		var mode := "reduced" if reduced_motion else "normal"
		for capture in CAPTURES:
			await _capture_state(capture, mode, state)
	MotionAccessibility.reset()
	state.reset_campaign(true)
	state.campaign_auto_transition_enabled = false
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
	print("Capturing [%s] %s / %s" % [mode, scene_id, state_id])
	state.reset_campaign(true)
	state.campaign_auto_transition_enabled = false
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
		var filename := "%s_%s.png" % [scene_id, state_id]
		var output_path := "%s/%s/%s" % [OUTPUT_ROOT, mode, filename]
		var written := _save_viewport(output_path)
		if not written:
			_failures.append("failed saving " + output_path)
		else:
			_records.append({
				"scene": scene_id,
				"state": state_id,
				"mode": mode,
				"path": output_path
			})
	station.queue_free()
	await process_frame


func _apply_state(station: Node2D, scene: StringName, state_id: StringName, state: Node) -> bool:
	match scene:
		&"station_39":
			match state_id:
				&"configs_inspected":
					station.call("inspect_config_a")
					station.call("inspect_config_b")
					return true
				&"matrix_reviewed":
					station.call("inspect_config_a")
					station.call("inspect_config_b")
					station.call("inspect_reference_core")
					station.call("inspect_config_c")
					station.call("review_method_matrix")
					return true
		&"station_40":
			match state_id:
				&"witnesses_inspected":
					station.call("inspect_terminal")
					station.call("inspect_cost_matrix")
					return true
				&"negotiation_confronted":
					station.call("inspect_terminal")
					station.call("inspect_cost_matrix")
					station.call("inspect_marta")
					station.call("inspect_szymon")
					station.call("confront_negotiation_costs")
					return true
		&"station_41":
			match state_id:
				&"topography_inspected":
					station.call("inspect_topography")
					return true
				&"operation_committed_a":
					station.call("inspect_topography")
					station.call("select_operation_a")
					return true
				&"operation_committed_b":
					station.call("inspect_topography")
					station.call("select_operation_b")
					return true
				&"operation_committed_c":
					station.call("inspect_topography")
					station.call("select_operation_c")
					return true
		&"station_42a":
			if state != null:
				state.record_decision(&"p9.method_commitment.method_committed", "force_home")
				state.record_decision(&"method_committed", "force_home")
			match state_id:
				&"cups_inspected":
					if station.has_method("execute_forced_return"):
						station.call("execute_forced_return")
					else:
						station.call("inspect_cups")
					return true
				&"chamber_a_witnessed":
					if station.has_method("execute_forced_return"):
						station.call("execute_forced_return")
						station.call("read_sealed_other_lena")
					else:
						station.call("inspect_cups")
						station.call("witness_chamber_a")
					return true
		&"station_42b":
			match state_id:
				&"doorstep_inspected":
					station.call("inspect_doorstep")
					return true
				&"chamber_b_witnessed":
					station.call("inspect_doorstep")
					station.call("witness_chamber_b")
					return true
		&"station_42c":
			match state_id:
				&"tram_inspected":
					station.call("inspect_tram")
					return true
				&"chamber_c_witnessed":
					station.call("inspect_tram")
					station.call("witness_chamber_c")
					return true
		&"station_43":
			match state_id:
				&"notice_and_credits":
					station.call("inspect_notice")
					station.call("inspect_credits")
					return true
				&"epilogue_completed":
					station.call("inspect_notice")
					station.call("inspect_credits")
					station.call("inspect_blackout")
					return true
	return false


func _save_viewport(res_path: String) -> bool:
	var img := root.get_texture().get_image()
	if img == null:
		return false
	var global_path := ProjectSettings.globalize_path(res_path)
	var err := img.save_png(global_path)
	return err == OK


func _write_report() -> void:
	var report_global := ProjectSettings.globalize_path(REPORT_PATH)
	var f := FileAccess.open(report_global, FileAccess.WRITE)
	if f == null:
		_failures.append("cannot write " + report_global)
		return
	f.store_line("=== PKG-0150 Visual Capture Report (P7 S14-S15 Stations 39-43) ===")
	f.store_line("Timestamp: %s" % Time.get_datetime_string_from_system())
	f.store_line("Total captures: %d" % _records.size())
	f.store_line("Failures: %d" % _failures.size())
	for rec in _records:
		f.store_line(" - [%s] %s / %s -> %s" % [rec["mode"], rec["scene"], rec["state"], rec["path"]])
	if not _failures.is_empty():
		f.store_line("\nFailures:")
		for fail in _failures:
			f.store_line(" - " + fail)
	f.close()


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0150 visual capture complete: %d images generated." % _records.size())
		quit(0)
	else:
		printerr("PKG-0150 visual capture failed with %d errors." % _failures.size())
		quit(1)
