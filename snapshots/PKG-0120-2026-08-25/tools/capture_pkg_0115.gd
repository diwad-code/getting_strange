extends SceneTree

## PKG-0115 R1 UI capture harness.
## Run with the normal Windows display driver, never headless:
##   Godot_v4.7-stable_win64_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0115.gd
##
## Captures prove render presence, logical size and the absence of obvious
## viewport overflow. They do not prove readability, ergonomics, comprehension
## or any other audience response.

const PACKAGE_ID := "PKG-0115"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0115"

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_capture_all")


func _capture_all() -> void:
	root.size = LOGICAL_SIZE
	var output_dir := ProjectSettings.globalize_path(OUTPUT_ROOT)
	if DirAccess.make_dir_recursive_absolute(output_dir) != OK:
		push_error(PACKAGE_ID + " CAPTURE: cannot create " + output_dir)
		quit(1)
		return

	var state := root.get_node_or_null("GameStateManager") as Node
	var title := current_scene as TitleScreen
	if title == null:
		var packed := load("res://scenes/shell/title_screen.tscn") as PackedScene
		if packed:
			title = packed.instantiate() as TitleScreen
			root.add_child(title)
			await process_frame
	if state == null or title == null:
		_failures.append("production shell or GameStateManager is unavailable")
	else:
		state.set_pause_menu_visible(false)
		state.restore_default_settings(true)
		state.reset_campaign(true)
		title.show()
		title.refresh_for_test()
		await _settle_frames(8)
		await _capture_frame("shell_pl", "title shell in Polish")

		state.set_locale("en")
		title.refresh_for_test()
		await _settle_frames(8)
		await _capture_frame("shell_en", "title shell in English")

		title.open_settings_for_test()
		await _settle_frames(8)
		await _capture_frame("settings_en", "shared runtime settings overlay")
		var settings := title.get_node_or_null("SettingsPanel") as SettingsOverlay
		if settings:
			settings.open_remap_for_test()
			await _settle_frames(8)
			await _capture_frame("remap_en", "controlled action remap surface")
		settings.close_remap_for_test()
		title.close_settings_for_test()

		state.set_locale("pl")
		state.set_pause_menu_visible(true)
		await _settle_frames(8)
		await _capture_frame("pause_pl", "pause menu in Polish")
		state.set_locale("en")
		await _settle_frames(8)
		await _capture_frame("pause_en", "pause menu in English")
		state.set_pause_menu_visible(false)

		var crt := CRTDialogueBox.new()
		root.add_child(crt)
		await process_frame
		crt.present([{"speaker": "Lena", "text": "The witness channel remains active."}])
		await _settle_frames(10)
		await _capture_frame("crt_en", "representative CRT dialogue surface")
		crt.queue_free()
		await process_frame

		state.set_locale("pl")
		state.restore_default_settings(true)
		state.reset_campaign(true)
		state.set_pause_menu_visible(false)
		title.show()

	if _failures.is_empty():
		print(PACKAGE_ID + " CAPTURE PASS: 7 UI frames in " + OUTPUT_ROOT)
		quit(0)
	else:
		for failure in _failures:
			push_error(PACKAGE_ID + " CAPTURE: " + failure)
		quit(1)


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
