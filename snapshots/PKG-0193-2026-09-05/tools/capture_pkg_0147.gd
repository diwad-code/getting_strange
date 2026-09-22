extends SceneTree

## PKG-0147 normal-driver visual evidence for P7 S06–S07 (Station 15–21).
## Run with a Windows rendering device, never headless:
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0147.gd
## The script drives only public station APIs, captures rendered states in both
## motion modes, and makes no claim about human comprehension or enjoyment.

const PACKAGE_ID := "PKG-0147"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0147"
const REPORT_PATH := "res://reports/pkg_0147_visual_capture_report.txt"
const SETTLE_PROCESS_FRAMES := 8
const SETTLE_PHYSICS_FRAMES := 20

const CAPTURES: Array[Dictionary] = [
	{"scene": &"station_15", "state": &"log_only"},
	{"scene": &"station_15", "state": &"signal_confirmed"},
	{"scene": &"station_16", "state": &"institution_trial"},
	{"scene": &"station_17", "state": &"report_scope_committed"},
	{"scene": &"station_18", "state": &"method_committed"},
	{"scene": &"station_19", "state": &"control_answers_compared"},
	{"scene": &"station_20", "state": &"relational_trial"},
	{"scene": &"station_21", "state": &"synthesis_pending"},
	{"scene": &"station_21", "state": &"synthesis_executed"},
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
		&"station_15":
			state.record_decision(&"p7.marta_threshold.trace", "dead_circuit_lesson_observed")
			if not bool(station.call("observe_signal_log")):
				return false
			if state_id == &"log_only":
				return true
			if not bool(station.call("send_control_impulse")):
				return false
			station.call("run_response_cycle")
			if not bool(station.call("send_control_impulse")):
				return false
			station.call("run_response_cycle")
			if not bool(station.call("send_corrective_impulse")):
				return false
			station.call("run_response_cycle")
			return bool(station.call("read_abort_note"))
		&"station_16":
			state.record_decision(&"p7.work_history_and_record.own_record_requested", true)
			if not bool(station.call("transfer_response_to_safe_analyzer")):
				return false
			if not bool(station.call("choose_sample_second_cost")):
				return false
			return bool(station.call("confirm_home_echo"))
		&"station_17":
			state.record_decision(&"p7.work_history_and_record.institution_trial_result", "small_cost_and_home_echo_confirmed")
			state.record_decision(&"p9.mechanics.small_cost.home_echo_verified", true)
			state.record_decision(&"mechanic_cost_observed", true)
			if not bool(station.call("read_cost_ledger")):
				return false
			if not bool(station.call("reject_adaptation_offer")):
				return false
			return bool(station.call("record_jakub_consent_limited"))
		&"station_18":
			state.record_decision(&"p7.work_history_and_record.trace", "cost_ledger_and_consent_scope_recorded")
			state.record_decision(&"p9.consent_and_cost.cost_ledger_read", true)
			state.record_decision(&"p9.consent_and_cost.adaptation_offer", "rejected")
			state.record_decision(&"p9.consent_and_cost.jakub_consent_scope", "limited")
			state.record_decision(&"jakub_consent_state", "limited")
			if not bool(station.call("compare_forecast_consent_dependencies")):
				return false
			if not bool(station.call("disclose_marta_truth_partial")):
				return false
			return bool(station.call("commit_close_equal"))
		&"station_19":
			state.record_decision(&"p7.three_place_proofs.public_trial_result", "two_systems_and_nine_years")
			if not bool(station.call("shield_microphone")):
				return false
			if not bool(station.call("prepare_control_questions")):
				return false
			if not bool(station.call("answer_payphone")):
				return false
			if not bool(station.call("ask_control_questions")):
				return false
			return bool(station.call("compare_control_answers"))
		&"station_20":
			state.record_decision(&"p7.three_place_proofs.voice_trial_result", "impostor_and_recording_insufficient")
			if not bool(station.call("move_parts_trolley")):
				return false
			if not bool(station.call("confirm_marta_presence")):
				return false
			if not bool(station.call("meet_jakub_face_to_face")):
				return false
			if not bool(station.call("accept_scar_refusal")):
				return false
			if not bool(station.call("request_voluntary_reader_scan")):
				return false
			return bool(station.call("compare_local_service_base"))
		&"station_21":
			state.record_decision(&"recognition_evidence_carried", true)
			state.record_decision(&"recognition_evidence_public", true)
			state.record_decision(&"recognition_evidence_relational", true)
			if not bool(station.call("place_reader_and_sample")):
				return false
			if not bool(station.call("place_public_records")):
				return false
			if not bool(station.call("place_relational_record")):
				return false
			if state_id == &"synthesis_pending":
				return true
			return bool(station.call("execute_three_family_synthesis"))
	return false


func _write_report() -> void:
	var lines: Array[String] = []
	lines.append(PACKAGE_ID + " VISUAL CAPTURE REPORT")
	lines.append("Technical evidence only: rendered state, layer presence and normal/reduced output. No line claims comprehension, fun, emotional credibility or comfort.")
	lines.append("Logical size: 640x360. Normal Windows rendering device. Public P7 station APIs drove each state.")
	lines.append("")
	lines.append("CAPTURED STATES")
	for record in _records:
		lines.append("%-7s %-12s %-24s %s" % [record["mode"], record["scene"], record["state"], record["path"]])
	lines.append("")
	lines.append("INSPECTION SCOPE")
	lines.append("Station 15: field notes observed vs two details compared, phone observed and own work record requested.")
	lines.append("Station 16: response transferred to the safe analyzer, sample-second cost manifested, home echo confirmed.")
	lines.append("Station 17: report read, signature compared, intercom observed, service route released, header copied in minimum scope.")
	lines.append("Station 18: municipal and hospital registries, employment card and disaster case resolved on the microfiche reader.")
	lines.append("Station 19: microphone shielded, control questions asked and both answers compared in the notepad.")
	lines.append("Station 20: trolley moved, Marta present, Jakub met, refusal accepted, voluntary scan, local service base compared.")
	lines.append("Station 21 pending: three families placed, synthesis NOT executed; the table label and corridor stay neutral.")
	lines.append("Station 21 executed: explicit synthesis completed; the table label names the recognition and the corridor names the second goal.")
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
