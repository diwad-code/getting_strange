extends SceneTree

## PKG-0148 normal-driver visual evidence for P7 S09–S10 (Station 26–30).
## Run with a Windows rendering device, never headless:
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0148.gd
## The driver uses public station APIs only and makes no claim about human reception.

const PACKAGE_ID := "PKG-0148"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0148"
const REPORT_PATH := "res://reports/pkg_0148_visual_capture_report.txt"
const SETTLE_PROCESS_FRAMES := 8
const SETTLE_PHYSICS_FRAMES := 20

const S09_PREFIX := "p7.interrupted_trial_and_small_cost."
const S10_PREFIX := "p7.jakub_boundary_and_forecasts."
const S08_TRACE := &"p7.three_place_proofs.trace"
const S09_TRACE := &"p7.interrupted_trial_and_small_cost.trace"
const S09_TRACE_VALUE := "ucp_intervention_reconstructed_local_lena_confirmed_small_cost_paid"

const CAPTURES: Array[Dictionary] = [
	{"scene": &"station_26", "state": &"interrupted_log"},
	{"scene": &"station_26", "state": &"intervention_reconstructed"},
	{"scene": &"station_27", "state": &"identical_pulse_pair"},
	{"scene": &"station_27", "state": &"error_correction_compared"},
	{"scene": &"station_28", "state": &"price_disclosed"},
	{"scene": &"station_28", "state": &"home_trace_anchored"},
	{"scene": &"station_28", "state": &"shared_drift_yielded"},
	{"scene": &"station_29", "state": &"boundary_evidence"},
	{"scene": &"station_29", "state": &"consent_refused"},
	{"scene": &"station_30", "state": &"three_forecasts"},
	{"scene": &"station_30", "state": &"dependencies_compared"},
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
	state.set_pause_menu_visible(false)
	for reduced_motion in [false, true]:
		MotionAccessibility.set_reduced_motion(reduced_motion)
		var mode := "reduced" if reduced_motion else "normal"
		for capture in CAPTURES:
			await _capture_state(capture, mode, state)
	MotionAccessibility.reset()
	state.reset_campaign(true)
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


func _call_bool(station: Node, method: StringName, arguments: Array = []) -> bool:
	if not station.has_method(method):
		_failures.append("missing public API: " + String(method))
		return false
	return bool(station.callv(method, arguments))


func _record(state: Node, key: StringName, value: Variant) -> void:
	state.call("record_decision", key, value)


func _seed_s09_entry(state: Node) -> void:
	_record(state, S08_TRACE, "world_recognized_and_search_committed")


func _seed_s09_reconstruction(state: Node) -> void:
	_seed_s09_entry(state)
	_record(state, StringName(S09_PREFIX + "ucp_intervention_reconstructed"), true)


func _seed_s09_price_entry(state: Node) -> void:
	_seed_s09_reconstruction(state)
	_record(state, StringName(S09_PREFIX + "local_lena_signal_confirmed"), true)


func _seed_s10_entry(state: Node) -> void:
	_record(state, S09_TRACE, S09_TRACE_VALUE)


func _drive_station_26(station: Node, state_id: StringName, state: Node) -> bool:
	_seed_s09_entry(state)
	if not _call_bool(station, &"observe_interrupted_ucp_log"):
		return false
	if state_id == &"interrupted_log":
		return true
	for method in [
		&"synchronize_sample_clock",
		&"synchronize_ucp_command_clock",
		&"synchronize_local_generator_clock",
		&"reconstruct_ucp_intervention",
	]:
		if not _call_bool(station, method):
			return false
	return state_id == &"intervention_reconstructed"


func _drive_station_27(station: Node, state_id: StringName, state: Node) -> bool:
	_seed_s09_reconstruction(state)
	for method in [
		&"calibrate_pulse_reference",
		&"send_first_identical_pulse",
		&"send_second_identical_pulse",
	]:
		if not _call_bool(station, method):
			return false
	if state_id == &"identical_pulse_pair":
		return true
	if not _call_bool(station, &"send_deliberate_error_pulse"):
		return false
	if not _call_bool(station, &"compare_response_correction"):
		return false
	return state_id == &"error_correction_compared"


func _drive_station_28(station: Node, state_id: StringName, state: Node) -> bool:
	_seed_s09_price_entry(state)
	for method in [
		&"observe_transfer_constraint",
		&"inspect_home_sample_trace",
		&"inspect_local_lena_signal_trace",
		&"disclose_transfer_price",
	]:
		if not _call_bool(station, method):
			return false
	if state_id == &"price_disclosed":
		return true
	if state_id == &"home_trace_anchored":
		return _call_bool(station, &"perform_home_trace_anchor")
	if state_id == &"shared_drift_yielded":
		return _call_bool(station, &"perform_shared_drift_yield")
	return false


func _drive_station_29(station: Node, state_id: StringName, state: Node) -> bool:
	_seed_s10_entry(state)
	for method in [
		&"inspect_ucp_jakub_contrast_proposal",
		&"observe_jakub_ordinary_life_scope",
		&"disclose_jakub_signal_risk",
		&"disable_jakub_transmitter",
	]:
		if not _call_bool(station, method):
			return false
	if state_id == &"boundary_evidence":
		return true
	if state_id == &"consent_refused":
		return _call_bool(station, &"record_jakub_consent", [&"refused"])
	return false


func _drive_station_30(station: Node, state_id: StringName, state: Node) -> bool:
	_seed_s10_entry(state)
	_record(state, StringName(S10_PREFIX + "jakub_consent_state"), "refused")
	for method in [
		&"build_force_home_forecast",
		&"build_close_equal_recover_local_forecast",
		&"build_mutual_passage_forecast",
	]:
		if not _call_bool(station, method):
			return false
	if state_id == &"three_forecasts":
		return true
	if state_id == &"dependencies_compared":
		return _call_bool(station, &"compare_forecast_consent_dependencies")
	return false


func _apply_state(station: Node, scene_id: StringName, state_id: StringName, state: Node) -> bool:
	match scene_id:
		&"station_26":
			return _drive_station_26(station, state_id, state)
		&"station_27":
			return _drive_station_27(station, state_id, state)
		&"station_28":
			return _drive_station_28(station, state_id, state)
		&"station_29":
			return _drive_station_29(station, state_id, state)
		&"station_30":
			return _drive_station_30(station, state_id, state)
	return false


func _write_report() -> void:
	var lines: Array[String] = []
	lines.append(PACKAGE_ID + " VISUAL CAPTURE REPORT")
	lines.append("Technical evidence only: rendered state, layer presence and normal/reduced output. No line claims comprehension, fun, emotion or comfort.")
	lines.append("Logical size: 640x360. Normal Windows rendering device. Eleven states were driven through public P7 station APIs.")
	lines.append("")
	lines.append("CAPTURED STATES")
	for record in _records:
		lines.append("%-7s %-12s %-28s %s" % [record["mode"], record["scene"], record["state"], record["path"]])
	lines.append("")
	lines.append("INSPECTION SCOPE")
	lines.append("Station 26: interrupted UCP log before and after three-clock reconstruction.")
	lines.append("Station 27: identical pulse pair before deliberate-error correction is compared.")
	lines.append("Station 28: disclosed transfer price, Anchor cost and Yield cost as separate states.")
	lines.append("Station 29: boundary evidence before Jakub's explicit, continuable refusal.")
	lines.append("Station 30: three forecasts before and after consent dependencies are compared.")
	lines.append("Reduced-motion frames retain the same state facts while the existing accessibility system reduces peripheral motion.")
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
