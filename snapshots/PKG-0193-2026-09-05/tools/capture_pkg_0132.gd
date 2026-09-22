extends SceneTree

func _initialize() -> void:
	call_deferred(&"_capture")


func _capture() -> void:
	root.size = Vector2i(640, 360)
	var output_dir := ProjectSettings.globalize_path("res://reports")
	DirAccess.make_dir_recursive_absolute(output_dir)
	var packed := load("res://scenes/levels/station_01.tscn") as PackedScene
	if packed == null:
		push_error("CAPTURE: station_01 missing")
		quit(1)
		return
	var station := packed.instantiate()
	root.add_child(station)
	for _i in 10:
		await process_frame
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	if image:
		var path := output_dir.path_join("pkg_0132_station_01_lena.png")
		image.save_png(path)
		print("CAPTURE PASS: " + path)
	station.queue_free()
	quit(0)
