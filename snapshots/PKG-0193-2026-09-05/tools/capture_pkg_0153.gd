extends SceneTree

const OUTPUT_DIR := "res://reports/pkg_0153"


func _initialize() -> void:
	call_deferred(&"_capture")


func _capture() -> void:
	root.size = Vector2i(640, 360)
	var output_dir := ProjectSettings.globalize_path(OUTPUT_DIR)
	var err := DirAccess.make_dir_recursive_absolute(output_dir)
	if err != OK:
		push_error("PKG-0153 CAPTURE: cannot create output directory")
		quit(1)
		return

	await _capture_title_screen(output_dir)
	await _capture_station_43_initial(output_dir)
	await _capture_station_43_release_surface(output_dir)
	quit(0)


func _capture_title_screen(output_dir: String) -> void:
	var packed := load("res://scenes/shell/title_screen.tscn") as PackedScene
	if packed == null:
		push_error("PKG-0153 CAPTURE: title_screen.tscn failed to load")
		quit(1)
		return
	var title := packed.instantiate() as Control
	if title == null:
		push_error("PKG-0153 CAPTURE: title_screen failed to instantiate")
		quit(1)
		return
	root.add_child(title)
	for _i in range(8):
		await process_frame
	await RenderingServer.frame_post_draw
	_save_current_frame(output_dir.path_join("title_screen_runtime_version.png"))
	title.queue_free()
	await process_frame


func _capture_station_43_initial(output_dir: String) -> void:
	var packed := load("res://scenes/levels/station_43.tscn") as PackedScene
	if packed == null:
		push_error("PKG-0153 CAPTURE: station_43.tscn failed to load")
		quit(1)
		return
	var station := packed.instantiate() as Station43
	if station == null:
		push_error("PKG-0153 CAPTURE: Station43 failed to instantiate")
		quit(1)
		return
	root.add_child(station)
	for _i in range(8):
		await process_frame
	await RenderingServer.frame_post_draw
	_save_current_frame(output_dir.path_join("station_43_initial_runtime_surface.png"))
	station.queue_free()
	await process_frame


func _capture_station_43_release_surface(output_dir: String) -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state != null:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	var packed := load("res://scenes/levels/station_43.tscn") as PackedScene
	if packed == null:
		push_error("PKG-0153 CAPTURE: station_43.tscn failed to load for release surface")
		quit(1)
		return
	var station := packed.instantiate() as Station43
	if station == null:
		push_error("PKG-0153 CAPTURE: Station43 failed to instantiate for release surface")
		quit(1)
		return
	root.add_child(station)
	await process_frame
	station.inspect_notice()
	station.inspect_credits()
	for _i in range(10):
		await process_frame
	await RenderingServer.frame_post_draw
	_save_current_frame(output_dir.path_join("station_43_release_surface.png"))
	station.queue_free()
	await process_frame


func _save_current_frame(path: String) -> void:
	var image := root.get_texture().get_image()
	if image == null:
		push_error("PKG-0153 CAPTURE: image readback failed")
		quit(1)
		return
	image.save_png(path)
	print("CAPTURE PASS: %s" % path)
