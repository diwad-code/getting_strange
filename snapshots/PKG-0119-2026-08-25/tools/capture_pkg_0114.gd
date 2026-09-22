extends SceneTree

## PKG-0114 production shell and campaign topology visual controls.
##
## Run with the normal Windows display driver, never headless:
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0114.gd
##
## Captures are technical render evidence. They do not prove readability,
## comprehension, visual appeal, fun or any other audience response.

const PACKAGE_ID := "PKG-0114"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0114"

var _failures: Array[String] = []
var _title_screen: TitleScreen


func _initialize() -> void:
	call_deferred("_capture_all")


func _capture_all() -> void:
	root.size = LOGICAL_SIZE
	var output_dir := ProjectSettings.globalize_path(OUTPUT_ROOT)
	if DirAccess.make_dir_recursive_absolute(output_dir) != OK:
		push_error(PACKAGE_ID + " CAPTURE: cannot create " + output_dir)
		quit(1)
		return

	var state := root.get_node_or_null("GameStateManager")
	var title := current_scene as TitleScreen
	if title == null:
		var title_scene := load("res://scenes/shell/title_screen.tscn") as PackedScene
		if title_scene:
			title = title_scene.instantiate() as TitleScreen
			root.add_child(title)
	_title_screen = title
	if state == null or title == null:
		_failures.append("production shell or GameStateManager is unavailable")
	else:
		state.campaign_auto_transition_enabled = false
		state.set_pause_menu_visible(false)
		state.restore_default_settings(true)
		state.reset_campaign(true)
		title.show()
		title.refresh_for_test()
		await _settle_frames(8)
		await _capture_frame("menu_no_save", "title shell with no campaign save")

		state.set_checkpoint(&"station_01", Vector2(65.0, 248.0))
		title.refresh_for_test()
		await _settle_frames(8)
		await _capture_frame("menu_continue", "title shell with a resumable save")

		title.open_settings_for_test()
		await _settle_frames(8)
		await _capture_frame("settings", "runtime settings panel")
		title.close_settings_for_test()

		state.select_finale_operation("B")
		state.decisions[&"campaign_completed"] = true
		state.save_campaign()
		title.refresh_for_test()
		await _settle_frames(8)
		await _capture_frame("menu_after_epilogue", "title shell after epilogue return")

		await _capture_station("station_41", "res://scenes/levels/station_41.tscn", "B")
		await _capture_station("station_42a", "res://scenes/levels/station_42a.tscn", "")
		await _capture_station("station_42b", "res://scenes/levels/station_42b.tscn", "")
		await _capture_station("station_42c", "res://scenes/levels/station_42c.tscn", "")
		await _capture_station("station_43", "res://scenes/levels/station_43.tscn", "")

		state.set_pause_menu_visible(false)
		state.restore_default_settings(true)
		state.reset_campaign(true)
		state.campaign_auto_transition_enabled = true
		title.show()

	if _failures.is_empty():
		print(PACKAGE_ID + " CAPTURE PASS: 9 frames in " + OUTPUT_ROOT)
		quit(0)
	else:
		for failure in _failures:
			push_error(PACKAGE_ID + " CAPTURE: " + failure)
		quit(1)


func _capture_station(case_id: String, scene_path: String, operation: String) -> void:
	var packed := load(scene_path) as PackedScene
	if packed == null:
		_failures.append("cannot load " + scene_path)
		return
	var title := _title_screen as Control
	if title:
		title.hide()
	var station := packed.instantiate() as Node2D
	if station == null:
		_failures.append("scene root is not Node2D: " + scene_path)
		if title:
			title.show()
		return
	root.add_child(station)
	await _settle_frames(12)
	station.set("dialogue_active", false)
	station.set("is_exit_unlocked", true)
	if not operation.is_empty() and station.has_method("select_operation"):
		station.call("select_operation", operation)
		station.set("dialogue_active", false)
	_apply_station_pose(station, case_id)
	var dialogue := station.get_node_or_null("CRTDialogueBox") as CanvasLayer
	if dialogue:
		dialogue.hide()
	station.queue_redraw()
	await _settle_frames(10)
	await RenderingServer.frame_post_draw
	await _capture_frame(case_id, scene_path)
	station.queue_free()
	await process_frame
	if title:
		title.show()


func _apply_station_pose(station: Node2D, case_id: String) -> void:
	match case_id:
		"station_42a":
			station.set("is_cups_inspected", true)
		"station_42b":
			station.set("is_doorstep_inspected", true)
		"station_42c":
			station.set("is_tram_inspected", true)
		"station_43":
			station.set("is_notice_inspected", true)
			station.set("is_credits_inspected", true)
			station.set("is_blackout_inspected", true)


func _capture_frame(case_id: String, description: String) -> void:
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	var relative_path := OUTPUT_ROOT.path_join(case_id + ".png")
	var absolute_path := ProjectSettings.globalize_path(relative_path)
	if image == null or image.get_size() != LOGICAL_SIZE:
		_failures.append("wrong render size for %s (%s)" % [case_id, description])
	elif image.save_png(absolute_path) != OK:
		_failures.append("cannot save " + relative_path)
	else:
		print(PACKAGE_ID + " CAPTURE PASS: " + relative_path)


func _settle_frames(count: int) -> void:
	for _frame in range(count):
		await process_frame
