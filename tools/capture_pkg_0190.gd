extends SceneTree

## PKG-0190 cinematic vignette evidence capture.
## Run with the normal Windows display driver, never --headless:
##   godot_console --path C:\getting_strange --script res://tools/capture_pkg_0190.gd --audio-driver WASAPI
## Writes only reports/pkg_0190/cinematics/ and does not overwrite earlier packages.

const REPORT_DIR := "res://reports/pkg_0190/cinematics"

var _rows := PackedStringArray([
	"vignette\tmode\tpath\twidth\theight\tmd5",
])
var _failures: Array[String] = []
var _state: Node


func _initialize() -> void:
	call_deferred(&"_run")


func _run() -> void:
	root.size = Vector2i(640, 360)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(REPORT_DIR))
	_state = root.get_node_or_null("GameStateManager")

	await _capture_threshold()
	await _capture_synthesis()
	await _capture_signal()
	await _capture_commit()
	await _capture_finale(&"station_42a", "force_home", "finale_a")
	await _capture_finale(&"station_42b", "close_equal_recover_local", "finale_b")
	await _capture_finale(&"station_42c", "mutual_passage", "finale_c")

	_write_matrix()
	if _failures.is_empty():
		print("PKG-0190 CINEMATICS CAPTURE PASS: %d Windows frames." % (_rows.size() - 1))
		quit(0)
	else:
		for failure in _failures:
			push_error("PKG-0190 CAPTURE: " + failure)
		quit(1)


func _reset() -> void:
	if _state != null:
		_state.reset_campaign(true)
		_state.cinematics_seen.clear()
		_state.set_reduced_motion(false, false)
		_state.campaign_auto_transition_enabled = false
		_state.set_test_mode(true)


func _load(station_id: String) -> Node2D:
	var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await _settle(6)
	_complete_visible_dialogue(station)
	await _settle(3)
	return station


func _complete_visible_dialogue(node: Node) -> void:
	if node is CRTDialogueBox:
		var dialogue := node as CRTDialogueBox
		var guard := 0
		while dialogue.is_presenting() and guard < 32:
			dialogue.advance_dialogue()
			guard += 1
	for child in node.get_children():
		_complete_visible_dialogue(child)


func _settle(frames: int) -> void:
	for _index in range(frames):
		await process_frame
	await RenderingServer.frame_post_draw


func _find_vignette(station: Node) -> Node:
	for child in station.get_children():
		if String(child.name).begins_with("CinematicVignette_"):
			return child
	return null


func _save(tag: String, mode: String) -> void:
	var image := root.get_texture().get_image()
	if image == null:
		_failures.append("%s/%s returned no viewport image" % [tag, mode])
		return
	var relative_path := "%s/%s__%s.png" % [REPORT_DIR, tag, mode]
	var absolute_path := ProjectSettings.globalize_path(relative_path)
	var error := image.save_png(absolute_path)
	if error != OK:
		_failures.append("cannot save %s (error %d)" % [relative_path, error])
		return
	_rows.append("%s\t%s\t%s\t%d\t%d\t%s" % [
		tag, mode, relative_path.trim_prefix("res://"), image.get_width(), image.get_height(),
		FileAccess.get_md5(absolute_path),
	])
	print("PKG-0190 CAPTURE: %s" % relative_path.trim_prefix("res://"))


func _capture_threshold() -> void:
	_reset()
	var station := await _load("station_08")
	_save("vig_threshold", "before_trigger")
	station.call("inspect_floor_twelve")
	_complete_visible_dialogue(station)
	station.call("speak_with_neighbour")
	_complete_visible_dialogue(station)
	station.call("unlock_apartment_fourteen")
	await _settle(4)
	_complete_visible_dialogue(station)
	await _settle(2)
	var vignette := _find_vignette(station)
	if vignette == null:
		_failures.append("vig_threshold: vignette did not attach after unlock_apartment_fourteen")
	else:
		_save("vig_threshold", "frame_0")
		await _settle(int(2.4 * 60.0))
		_save("vig_threshold", "frame_1")
		vignette.call("skip_for_test")
		await _settle(2)
		_save("vig_threshold", "after_skip")
	station.free()
	await process_frame


func _capture_synthesis() -> void:
	_reset()
	var station := await _load("station_13")
	_state.record_decision(&"p9.mystery.home.trace", "test_trace")
	_state.record_decision(&"p9.mystery.institution.trace", "test_trace")
	_state.record_decision(&"p9.mystery.jakub.trace", "test_trace")
	_save("vig_synthesis", "before_trigger")
	station.call("synthesize_world_difference")
	await _settle(4)
	var vignette := _find_vignette(station)
	if vignette == null:
		_failures.append("vig_synthesis: vignette did not attach after synthesize_world_difference")
	else:
		_save("vig_synthesis", "frame_0")
		# Reduced-motion evidence captured here: shortened hold, same content.
		_state.set_reduced_motion(true, false)
		MotionAccessibility.set_reduced_motion(true)
		await _settle(int(1.3 * 60.0))
		_save("vig_synthesis", "frame_1_reduced_motion")
		MotionAccessibility.set_reduced_motion(false)
		_state.set_reduced_motion(false, false)
	station.free()
	await process_frame


func _capture_signal() -> void:
	_reset()
	var station := await _load("station_15")
	_save("vig_signal", "before_trigger")
	station.call("observe_signal_log")
	station.call("send_control_impulse")
	station.call("run_response_cycle")
	station.call("send_control_impulse")
	station.call("run_response_cycle")
	station.call("send_corrective_impulse")
	station.call("run_response_cycle")
	await _settle(4)
	var vignette := _find_vignette(station)
	if vignette == null:
		_failures.append("vig_signal: vignette did not attach after mutual_signal_test_completed")
	else:
		_save("vig_signal", "frame_0")
		vignette.call("skip_for_test")
		await _settle(2)
		_save("vig_signal", "after_skip")
	station.free()
	await process_frame


func _capture_commit() -> void:
	_reset()
	var station := await _load("station_18")
	_state.record_decision(&"p7.work_history_and_record.trace", "cost_ledger_and_consent_scope_recorded")
	_state.record_decision(&"p9.consent_and_cost.cost_ledger_read", true)
	_state.record_decision(&"p9.consent_and_cost.adaptation_offer", "rejected")
	_state.record_decision(&"jakub_consent_state", "granted")
	_save("vig_commit", "before_trigger")
	station.call("compare_forecast_consent_dependencies")
	station.call("disclose_marta_truth_full")
	station.call("commit_force_home")
	await _settle(4)
	var vignette := _find_vignette(station)
	if vignette == null:
		_failures.append("vig_commit: vignette did not attach after method_committed")
	else:
		_save("vig_commit", "frame_0")
		vignette.call("skip_for_test")
		await _settle(2)
		_save("vig_commit", "after_skip")
	station.free()
	await process_frame


func _capture_finale(station_id: StringName, method_id: String, tag: String) -> void:
	_reset()
	_state.record_decision(&"method_committed", method_id)
	var station := await _load(String(station_id))
	_save(tag, "before_trigger")
	station.call("read_household_consequence")
	await _settle(4)
	var vignette := _find_vignette(station)
	if vignette == null:
		_failures.append("%s: vignette did not attach after household_consequence_read" % tag)
	else:
		_save(tag, "frame_0")
		vignette.call("skip_for_test")
		await _settle(2)
		_save(tag, "after_skip")
	station.free()
	await process_frame


func _write_matrix() -> void:
	var file := FileAccess.open(ProjectSettings.globalize_path(REPORT_DIR + "/cinematics_matrix.tsv"), FileAccess.WRITE)
	if file == null:
		_failures.append("cannot write cinematics_matrix.tsv")
		return
	file.store_string("\n".join(_rows) + "\n")
	file.close()
