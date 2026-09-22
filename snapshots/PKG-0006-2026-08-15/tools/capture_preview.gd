extends SceneTree


func _initialize() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var packed_lab := load("res://scenes/prototype/movement_lab.tscn") as PackedScene
	if packed_lab == null:
		push_error("CAPTURE: movement lab scene does not load")
		quit(1)
		return

	root.size = Vector2i(640, 360)
	root.add_child(packed_lab.instantiate())
	for frame in range(4):
		await process_frame
	await RenderingServer.frame_post_draw

	var output_dir := ProjectSettings.globalize_path("res://reports")
	var directory_error := DirAccess.make_dir_recursive_absolute(output_dir)
	if directory_error != OK:
		push_error("CAPTURE: cannot create reports directory")
		quit(1)
		return

	var output_path := output_dir.path_join("movement_lab.png")
	var image := root.get_texture().get_image()
	if image == null:
		push_error("CAPTURE: active display driver does not expose a rendered frame")
		quit(1)
		return
	var save_error := image.save_png(output_path)
	if save_error != OK:
		push_error("CAPTURE: cannot save preview")
		quit(1)
		return

	print("CAPTURE PASS: " + output_path)
	quit(0)
