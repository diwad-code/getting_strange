extends SceneTree

const ACT_II_PATHS := [
	"res://scenes/levels/station_11.tscn",
	"res://scenes/levels/station_12.tscn",
	"res://scenes/levels/station_13.tscn",
	"res://scenes/levels/station_14.tscn",
	"res://scenes/levels/station_15.tscn",
]


func _initialize() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var output_dir := ProjectSettings.globalize_path("res://reports/pkg_0095_act2")
	if DirAccess.make_dir_recursive_absolute(output_dir) != OK:
		push_error("PKG-0095 CAPTURE: cannot create output directory")
		quit(1)
		return
	for scene_path in ACT_II_PATHS:
		var packed := load(scene_path) as PackedScene
		if packed == null:
			push_error("PKG-0095 CAPTURE: cannot load " + scene_path)
			quit(1)
			return
		var station := packed.instantiate() as Node2D
		root.add_child(station)
		for frame in range(10):
			await process_frame
		var dialogue := station.get_node_or_null("CRTDialogueBox") as CanvasLayer
		if dialogue:
			dialogue.hide()
		await process_frame
		await RenderingServer.frame_post_draw
		var image := root.get_texture().get_image()
		var output_path := output_dir.path_join(scene_path.get_file().get_basename() + ".png")
		if image == null or image.save_png(output_path) != OK:
			push_error("PKG-0095 CAPTURE: cannot save " + output_path)
			quit(1)
			return
		print("PKG-0095 CAPTURE PASS: " + output_path)
		station.queue_free()
		await process_frame
	print("PKG-0095 ACT II CAPTURE PASS")
	quit(0)