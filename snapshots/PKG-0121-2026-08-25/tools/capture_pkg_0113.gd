extends SceneTree

## PKG-0113 release-readiness visual controls.
##
## Run with the normal Windows display driver, never headless:
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0113.gd -- --capture-phase=before
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0113.gd -- --capture-phase=after
##
## Captures are technical render evidence. They do not prove readability,
## comprehension, visual appeal, fun or any other audience response.

const PACKAGE_ID := "PKG-0113"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0113"

const CASES: Array[Dictionary] = [
	{"id": "station_01", "path": "res://scenes/levels/station_01.tscn", "dialogue": true},
	{"id": "station_14", "path": "res://scenes/levels/station_14.tscn", "dialogue": false},
	{"id": "station_22", "path": "res://scenes/levels/station_22.tscn", "dialogue": true},
	{"id": "station_38", "path": "res://scenes/levels/station_38.tscn", "dialogue": false},
	{"id": "station_41", "path": "res://scenes/levels/station_41.tscn", "dialogue": false},
	{"id": "station_42a", "path": "res://scenes/levels/station_42a.tscn", "dialogue": false},
	{"id": "station_42b", "path": "res://scenes/levels/station_42b.tscn", "dialogue": false},
	{"id": "station_42c", "path": "res://scenes/levels/station_42c.tscn", "dialogue": false},
	{"id": "station_43", "path": "res://scenes/levels/station_43.tscn", "dialogue": true},
]

var _phase := "before"
var _failures: Array[String] = []


func _initialize() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--capture-phase="):
			_phase = argument.trim_prefix("--capture-phase=").to_lower()
	if _phase not in ["before", "after"]:
		push_error(PACKAGE_ID + " CAPTURE: phase must be before or after")
		quit(1)
		return
	call_deferred("_capture_all")


func _capture_all() -> void:
	root.size = LOGICAL_SIZE
	var output_dir := ProjectSettings.globalize_path(OUTPUT_ROOT.path_join(_phase))
	if DirAccess.make_dir_recursive_absolute(output_dir) != OK:
		push_error(PACKAGE_ID + " CAPTURE: cannot create " + output_dir)
		quit(1)
		return

	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	for case_data in CASES:
		await _capture_case(case_data, "world")
		if bool(case_data["dialogue"]):
			await _capture_case(case_data, "dialogue")
	await _capture_case(CASES[0], "pause")

	if state:
		state.set_pause_menu_visible(false)
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)

	if _failures.is_empty():
		print(PACKAGE_ID + " CAPTURE PASS: 13 frames in " + OUTPUT_ROOT.path_join(_phase))
		quit(0)
	else:
		for failure in _failures:
			push_error(PACKAGE_ID + " CAPTURE: " + failure)
		quit(1)


func _capture_case(case_data: Dictionary, mode: String) -> void:
	var scene_path := String(case_data["path"])
	var packed := load(scene_path) as PackedScene
	if packed == null:
		_failures.append("cannot load " + scene_path)
		return
	var station := packed.instantiate() as Node2D
	if station == null:
		_failures.append("scene root is not Node2D: " + scene_path)
		return
	root.add_child(station)
	for _frame in range(12):
		await process_frame

	_apply_control_pose(station, String(case_data["id"]))
	station.set("dialogue_active", false)
	var dialogue := station.get_node_or_null("CRTDialogueBox") as CRTDialogueBox
	if dialogue:
		dialogue.hide()
	if mode == "dialogue" and dialogue:
		dialogue.show()
		dialogue.present([{
			"speaker": "Lena",
			"text": "Nie szukaj kolejnej wersji. Sprawdź, co naprawdę zostało zapisane.",
		}])
	elif mode == "pause":
		var state := root.get_node_or_null("GameStateManager")
		if state:
			state.set_test_mode(false)
			state.set_pause_menu_visible(true)

	station.queue_redraw()
	for _frame in range(10):
		await process_frame
	await RenderingServer.frame_post_draw

	var image := root.get_texture().get_image()
	var relative_path := OUTPUT_ROOT.path_join(_phase).path_join(mode).path_join(String(case_data["id"]) + ".png")
	var absolute_path := ProjectSettings.globalize_path(relative_path)
	if DirAccess.make_dir_recursive_absolute(absolute_path.get_base_dir()) != OK:
		_failures.append("cannot create directory for " + relative_path)
	elif image == null or image.get_size() != LOGICAL_SIZE or image.save_png(absolute_path) != OK:
		_failures.append("cannot save " + relative_path)
	else:
		print(PACKAGE_ID + " CAPTURE PASS: " + relative_path)

	if mode == "pause":
		var state := root.get_node_or_null("GameStateManager")
		if state:
			state.set_pause_menu_visible(false)
	station.queue_free()
	await process_frame


func _apply_control_pose(station: Node2D, case_id: String) -> void:
	station.set("dialogue_active", false)
	match case_id:
		"station_42a":
			station.set("is_exit_unlocked", true)
			station.set("is_cups_inspected", true)
		"station_42b":
			station.set("is_exit_unlocked", true)
			station.set("is_doorstep_inspected", true)
		"station_42c":
			station.set("is_exit_unlocked", true)
			station.set("is_tram_inspected", true)
		"station_43":
			station.set("is_exit_unlocked", true)
			station.set("is_notice_inspected", true)
			station.set("is_credits_inspected", true)
			station.set("is_blackout_inspected", true)
