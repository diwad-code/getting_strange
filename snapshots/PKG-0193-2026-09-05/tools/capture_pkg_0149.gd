extends SceneTree

## PKG-0149 normal-driver visual evidence for P7 S11–S13 (Station 31–38).
## Run with a Windows rendering device, never headless:
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0149.gd
## The driver uses public station APIs only and makes no claim about human reception.

const PACKAGE_ID := "PKG-0149"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0149"
const REPORT_PATH := "res://reports/pkg_0149_visual_capture_report.txt"
const SETTLE_PROCESS_FRAMES := 8
const SETTLE_PHYSICS_FRAMES := 20

const CAPTURES: Array[Dictionary] = [
	{"scene": &"station_31", "state": &"chairs_inspected"},
	{"scene": &"station_31", "state": &"adaptation_rejected"},
	{"scene": &"station_32", "state": &"steamed_and_cracked"},
	{"scene": &"station_32", "state": &"material_memory_anchored"},
	{"scene": &"station_33", "state": &"ladder_and_gauge"},
	{"scene": &"station_33", "state": &"intent_reconstructed"},
	{"scene": &"station_34", "state": &"reactor_and_desk"},
	{"scene": &"station_34", "state": &"pair_registry_unlocked"},
	{"scene": &"station_35", "state": &"cooling_pool"},
	{"scene": &"station_35", "state": &"home_echo_verified"},
	{"scene": &"station_36", "state": &"drain_current"},
	{"scene": &"station_36", "state": &"cost_ledger_revealed"},
	{"scene": &"station_37", "state": &"oscilloscope_and_patchbay"},
	{"scene": &"station_37", "state": &"living_signal_bridged"},
	{"scene": &"station_38", "state": &"calculator_and_accident"},
	{"scene": &"station_38", "state": &"truth_disclosed_full"},
	{"scene": &"station_38", "state": &"truth_disclosed_withheld"},
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


func _apply_state(station: Node2D, scene_id: StringName, state_id: StringName, state: Node) -> bool:
	match scene_id:
		&"station_31":
			_record(state, &"p7.jakub_boundary_and_forecasts.trace", "consent_and_forecasts_resolved")
			match state_id:
				&"chairs_inspected":
					return _call_bool(station, &"inspect_passenger_chairs") and _call_bool(station, &"inspect_wierzbicka_proposal")
				&"adaptation_rejected":
					return _call_bool(station, &"inspect_passenger_chairs") and _call_bool(station, &"inspect_wierzbicka_proposal") and _call_bool(station, &"inspect_twelfth_chair") and _call_bool(station, &"compare_passenger_ledger") and _call_bool(station, &"reject_adaptation_offer")
		&"station_32":
			_record(state, &"p7.archive_countermodel.adaptation_offer_rejected", true)
			match state_id:
				&"steamed_and_cracked":
					return _call_bool(station, &"inspect_steamed_pane") and _call_bool(station, &"inspect_cracked_pane")
				&"material_memory_anchored":
					return _call_bool(station, &"inspect_steamed_pane") and _call_bool(station, &"inspect_cracked_pane") and _call_bool(station, &"etch_condensation_trace") and _call_bool(station, &"inspect_polished_pane") and _call_bool(station, &"anchor_material_memory")
		&"station_33":
			_record(state, &"p7.archive_countermodel.material_memory_anchored", true)
			match state_id:
				&"ladder_and_gauge":
					return _call_bool(station, &"inspect_ladder_infrastructure") and _call_bool(station, &"inspect_depth_gauge")
				&"intent_reconstructed":
					return _call_bool(station, &"inspect_ladder_infrastructure") and _call_bool(station, &"inspect_depth_gauge") and _call_bool(station, &"inspect_cable_trunk_note") and _call_bool(station, &"inspect_shaft_work_light") and _call_bool(station, &"reconstruct_local_lena_intent")
		&"station_34":
			_record(state, &"p7.archive_countermodel.trace", "local_lena_intent_found")
			match state_id:
				&"reactor_and_desk":
					return _call_bool(station, &"inspect_correlation_reactor") and _call_bool(station, &"inspect_allocation_desk")
				&"pair_registry_unlocked":
					return _call_bool(station, &"inspect_correlation_reactor") and _call_bool(station, &"inspect_allocation_desk") and _call_bool(station, &"inspect_thermal_indicators") and _call_bool(station, &"inspect_diagnostic_probe") and _call_bool(station, &"unlock_pair_registry")
		&"station_35":
			_record(state, &"p7.pair_cost_and_echo.pair_registry_inspected", true)
			match state_id:
				&"cooling_pool":
					return _call_bool(station, &"inspect_cooling_pool") and _call_bool(station, &"inspect_drain_valve")
				&"home_echo_verified":
					return _call_bool(station, &"inspect_cooling_pool") and _call_bool(station, &"inspect_drain_valve") and _call_bool(station, &"inspect_chemical_sampler") and _call_bool(station, &"process_home_echo")
		&"station_36":
			_record(state, &"p7.pair_cost_and_echo.home_echo_verified", true)
			match state_id:
				&"drain_current":
					return _call_bool(station, &"inspect_drain_weir") and _call_bool(station, &"measure_drain_current")
				&"cost_ledger_revealed":
					return _call_bool(station, &"inspect_drain_weir") and _call_bool(station, &"measure_drain_current") and _call_bool(station, &"inspect_service_ladder") and _call_bool(station, &"sample_contamination_tap") and _call_bool(station, &"reveal_ucp_cost_ledger")
		&"station_37":
			_record(state, &"p7.pair_cost_and_echo.trace", "ucp_cost_ledger_found")
			match state_id:
				&"oscilloscope_and_patchbay":
					return _call_bool(station, &"inspect_frequency_oscilloscope") and _call_bool(station, &"inspect_transmission_patchbay")
				&"living_signal_bridged":
					return _call_bool(station, &"inspect_frequency_oscilloscope") and _call_bool(station, &"inspect_transmission_patchbay") and _call_bool(station, &"inspect_transmitting_antenna") and _call_bool(station, &"inspect_mixing_pulpit") and _call_bool(station, &"bridge_living_signal")
		&"station_38":
			_record(state, &"p7.consent_and_rescue_boundary.living_signal_bridged", true)
			match state_id:
				&"calculator_and_accident":
					return _call_bool(station, &"inspect_radio_receiver") and _call_bool(station, &"inspect_local_procedure_record")
				&"truth_disclosed_full":
					return _call_bool(station, &"inspect_radio_receiver") and _call_bool(station, &"inspect_local_procedure_record") and _call_bool(station, &"inspect_jakub_switchboard") and _call_bool(station, &"anchor_rescue_tether") and _call_bool(station, &"disclose_marta_truth", [&"full"])
				&"truth_disclosed_withheld":
					return _call_bool(station, &"inspect_radio_receiver") and _call_bool(station, &"inspect_local_procedure_record") and _call_bool(station, &"inspect_jakub_switchboard") and _call_bool(station, &"anchor_rescue_tether") and _call_bool(station, &"disclose_marta_truth", [&"withheld"])
	return false


func _write_report() -> void:
	var lines: Array[String] = []
	lines.append("PKG-0149 VISUAL CAPTURE REPORT")
	lines.append("Programmatic visual capture of S11–S13 diagnostic spaces (Station 31–38).")
	lines.append("Captured frames: %d" % _records.size())
	lines.append("")
	for rec in _records:
		lines.append("  [%s] %s / %s -> %s" % [rec["mode"], rec["scene"], rec["state"], rec["path"]])
	var report_abs := ProjectSettings.globalize_path(REPORT_PATH)
	var file := FileAccess.open(report_abs, FileAccess.WRITE)
	if file != null:
		file.store_string("\n".join(lines) + "\n")
		file.close()
		print("PKG-0149 REPORT WRITTEN: " + REPORT_PATH)


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0149 CAPTURE SUCCESS: all frames rendered and saved")
		quit(0)
	else:
		for f in _failures:
			printerr("PKG-0149 CAPTURE FAILURE: " + f)
		quit(1)
