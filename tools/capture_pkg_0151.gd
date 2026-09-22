extends SceneTree

## PKG-0151 normal-driver visual evidence for the full P7 campaign state set.
## Run with a Windows rendering device, never headless:
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0151.gd
## The script drives only public station APIs, captures representative states in
## both motion modes, and makes no claim about human comprehension or enjoyment.

const PACKAGE_ID := "PKG-0151"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0151"
const REPORT_PATH := "res://reports/pkg_0151_visual_capture_report.txt"
const SETTLE_PROCESS_FRAMES := 8
const SETTLE_PHYSICS_FRAMES := 20

const CAPTURES: Array[Dictionary] = [
	{"scene": &"station_01", "state": &"sample_committed"},
	{"scene": &"station_04", "state": &"reader_trial_committed"},
	{"scene": &"station_08", "state": &"intercom_completed"},
	{"scene": &"station_14", "state": &"threshold_respected"},
	{"scene": &"station_21", "state": &"synthesis_executed"},
	{"scene": &"station_25", "state": &"paired_with_notes"},
	{"scene": &"station_28", "state": &"shared_drift_yielded"},
	{"scene": &"station_30", "state": &"dependencies_compared"},
	{"scene": &"station_33", "state": &"intent_reconstructed"},
	{"scene": &"station_36", "state": &"cost_ledger_revealed"},
	{"scene": &"station_38", "state": &"truth_disclosed_full"},
	{"scene": &"station_41", "state": &"operation_committed_a"},
	{"scene": &"station_41", "state": &"operation_committed_b"},
	{"scene": &"station_41", "state": &"operation_committed_c"},
	{"scene": &"station_42a", "state": &"chamber_a_witnessed"},
	{"scene": &"station_42b", "state": &"chamber_b_witnessed"},
	{"scene": &"station_42c", "state": &"chamber_c_witnessed"},
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
		for capture_spec in CAPTURES:
			await _capture_state(capture_spec, mode, state)
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


func _capture_state(capture_spec: Dictionary, mode: String, state: Node) -> void:
	var scene_id := capture_spec["scene"] as StringName
	var state_id := capture_spec["state"] as StringName
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
		await RenderingServer.frame_post_draw
		var image := root.get_texture().get_image()
		var relative_path := OUTPUT_ROOT.path_join(mode).path_join("%s_%s.png" % [scene_id, state_id])
		var absolute_path := ProjectSettings.globalize_path(relative_path)
		if image == null or image.get_size() != LOGICAL_SIZE:
			_failures.append("wrong image size for " + relative_path)
		elif image.save_png(absolute_path) != OK:
			_failures.append("cannot save " + relative_path)
		else:
			_records.append({"mode": mode, "scene": String(scene_id), "state": String(state_id), "path": relative_path})
			print(PACKAGE_ID + " CAPTURE PASS: " + relative_path)
	if station.get_parent() == root:
		root.remove_child(station)
	station.free()
	await process_frame


func _call_bool(station: Node, method_name: StringName, arguments: Array = []) -> bool:
	if not station.has_method(method_name):
		_failures.append("missing public API: " + String(method_name))
		return false
	return bool(station.callv(method_name, arguments))


func _record(state: Node, key: StringName, value: Variant) -> void:
	state.record_decision(key, value)


func _apply_state(station: Node2D, scene_id: StringName, state_id: StringName, state: Node) -> bool:
	match scene_id:
		&"station_01":
			if not _call_bool(station, &"observe_measurement_gap"):
				return false
			if not _call_bool(station, &"inspect_sensor_mount"):
				return false
			if not _call_bool(station, &"record_raw_measurement"):
				return false
			if not _call_bool(station, &"repeat_measurement"):
				return false
			return _call_bool(station, &"preserve_raw_sample")
		&"station_04":
			_record(state, &"p7.sample_and_promise.trace", "sample_preserved_and_time_sent")
			return _call_bool(station, &"observe_reader_repeat") and _call_bool(station, &"observe_wagon_clock") and _call_bool(station, &"repeat_reader_without_route_change")
		&"station_08":
			_record(state, &"p7.address_and_record.shopkeeper_answer", "yesterday_purchase")
			return _call_bool(station, &"read_certificate") and _call_bool(station, &"read_directory") and _call_bool(station, &"test_intercom_recognition")
		&"station_14":
			_record(state, &"p9.threshold_obstacle.marta_threshold.recall_requested", true)
			return _call_bool(station, &"place_bag_at_door") and _call_bool(station, &"disclose_arrival_time") and _call_bool(station, &"compare_field_equipment") and _call_bool(station, &"verify_key_position") and _call_bool(station, &"ask_independent_day_description")
		&"station_21":
			_record(state, &"recognition_evidence_carried", true)
			_record(state, &"recognition_evidence_public", true)
			_record(state, &"recognition_evidence_relational", true)
			return _call_bool(station, &"place_reader_and_sample") and _call_bool(station, &"place_public_records") and _call_bool(station, &"place_relational_record") and _call_bool(station, &"execute_three_family_synthesis")
		&"station_25":
			_record(state, &"p7.mutual_test.marta_boundary", "limited_access")
			station.call("observe_ventilation_cycle")
			station.call("release_interlock")
			station.call("route_power")
			return _call_bool(station, &"retrieve_ucp_buffer")
		&"station_28":
			_record(state, &"p7.three_place_proofs.trace", "world_recognized_and_search_committed")
			_record(state, &"p7.interrupted_trial_and_small_cost.ucp_intervention_reconstructed", true)
			_record(state, &"p7.interrupted_trial_and_small_cost.local_lena_signal_confirmed", true)
			return _call_bool(station, &"observe_transfer_constraint") and _call_bool(station, &"inspect_home_sample_trace") and _call_bool(station, &"inspect_local_lena_signal_trace") and _call_bool(station, &"disclose_transfer_price") and _call_bool(station, &"perform_shared_drift_yield")
		&"station_30":
			_record(state, &"p7.interrupted_trial_and_small_cost.trace", "shared_drift_yield")
			_record(state, &"p7.jakub_boundary_and_forecasts.jakub_consent_state", "refused")
			return _call_bool(station, &"build_force_home_forecast") and _call_bool(station, &"build_close_equal_recover_local_forecast") and _call_bool(station, &"build_mutual_passage_forecast") and _call_bool(station, &"compare_forecast_consent_dependencies")
		&"station_33":
			_record(state, &"p7.archive_countermodel.material_memory_anchored", true)
			return _call_bool(station, &"inspect_ladder_infrastructure") and _call_bool(station, &"inspect_depth_gauge") and _call_bool(station, &"inspect_cable_trunk_note") and _call_bool(station, &"inspect_shaft_work_light") and _call_bool(station, &"reconstruct_local_lena_intent")
		&"station_36":
			_record(state, &"p7.pair_cost_and_echo.home_echo_verified", true)
			return _call_bool(station, &"inspect_drain_weir") and _call_bool(station, &"measure_drain_current") and _call_bool(station, &"inspect_service_ladder") and _call_bool(station, &"sample_contamination_tap") and _call_bool(station, &"reveal_ucp_cost_ledger")
		&"station_38":
			_record(state, &"p7.consent_and_rescue_boundary.living_signal_bridged", true)
			return _call_bool(station, &"inspect_radio_receiver") and _call_bool(station, &"inspect_local_procedure_record") and _call_bool(station, &"inspect_jakub_switchboard") and _call_bool(station, &"anchor_rescue_tether") and _call_bool(station, &"disclose_marta_truth", [&"full"])
		&"station_41":
			_record(state, &"p7.consent_and_rescue_boundary.trace", "truth_disclosed_with_scope")
			if not _call_bool(station, &"inspect_topography"):
				return false
			match state_id:
				&"operation_committed_a":
					return _call_bool(station, &"select_operation_a")
				&"operation_committed_b":
					return _call_bool(station, &"select_operation_b")
				&"operation_committed_c":
					return _call_bool(station, &"select_operation_c")
		&"station_42a":
			_record(state, &"p7.branch_clarity_and_irreversible_choice.trace", "method_committed_to_branch")
			_record(state, &"p9.method_commitment.method_committed", "force_home")
			_record(state, &"method_committed", "force_home")
			state.select_finale_operation("A")
			if station.has_method(&"execute_forced_return"):
				return _call_bool(station, &"execute_forced_return")
			return _call_bool(station, &"inspect_cups")
		&"station_42b":
			_record(state, &"p7.branch_clarity_and_irreversible_choice.trace", "method_committed_to_branch")
			state.select_finale_operation("B")
			return _call_bool(station, &"inspect_doorstep")
		&"station_42c":
			_record(state, &"p7.branch_clarity_and_irreversible_choice.trace", "method_committed_to_branch")
			state.select_finale_operation("C")
			return _call_bool(station, &"inspect_tram")
		&"station_43":
			_record(state, &"p7.conscious_silence_and_presence.final_chamber_witnessed", true)
			return _call_bool(station, &"inspect_notice") and _call_bool(station, &"inspect_credits") and _call_bool(station, &"inspect_blackout")
	return false


func _write_report() -> void:
	var lines: Array[String] = []
	lines.append(PACKAGE_ID + " VISUAL CAPTURE REPORT")
	lines.append("Technical evidence only: representative P7 rendered states in normal and reduced-motion modes.")
	lines.append("Logical size: 640x360. Public station APIs only. No claim about comprehension, fun, emotion or comfort.")
	lines.append("")
	for record in _records:
		lines.append("[%s] %s / %s -> %s" % [record["mode"], record["scene"], record["state"], record["path"]])
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
