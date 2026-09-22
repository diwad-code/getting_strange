extends SceneTree


func _initialize() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(640, 360)
	var output_dir := ProjectSettings.globalize_path("res://reports")
	var directory_error := DirAccess.make_dir_recursive_absolute(output_dir)
	if directory_error != OK:
		push_error("CAPTURE: cannot create reports directory")
		quit(1)
		return

	var scenes := {
		"movement_lab.png": "res://scenes/prototype/movement_lab.tscn",
		"anchor_lab.png": "res://scenes/prototype/anchor_lab.tscn",
	}

	for filename in scenes:
		var scene_path: String = scenes[filename]
		var packed := load(scene_path) as PackedScene
		if packed == null:
			push_error("CAPTURE: scene %s does not load" % scene_path)
			quit(1)
			return

		var instance := packed.instantiate()
		root.add_child(instance)
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var output_path := output_dir.path_join(filename)
		var image := root.get_texture().get_image()
		if image == null:
			push_error("CAPTURE: active display driver does not expose a rendered frame")
			quit(1)
			return
		var save_error := image.save_png(output_path)
		if save_error != OK:
			push_error("CAPTURE: cannot save preview %s" % filename)
			quit(1)
			return

		print("CAPTURE PASS: " + output_path)
		instance.queue_free()
		await process_frame

	quit(0)
