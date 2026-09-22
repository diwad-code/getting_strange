extends SceneTree

const ACT_IIC_PATHS := [
	"res://scenes/levels/station_21.tscn",
	"res://scenes/levels/station_22.tscn",
	"res://scenes/levels/station_23.tscn",
	"res://scenes/levels/station_24.tscn",
	"res://scenes/levels/station_25.tscn",
]


func _initialize() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var output_dir := ProjectSettings.globalize_path("res://reports/pkg_0097_act2c")
	if DirAccess.make_dir_recursive_absolute(output_dir) != OK:
		push_error("PKG-0097 CAPTURE: cannot create output directory")
		quit(1)
		return
	for scene_path in ACT_IIC_PATHS:
		var packed := load(scene_path) as PackedScene
		if packed == null:
			push_error("PKG-0097 CAPTURE: cannot load " + scene_path)
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
			push_error("PKG-0097 CAPTURE: cannot save " + output_path)
			quit(1)
			return
		print("PKG-0097 CAPTURE PASS: " + output_path)
		station.queue_free()
		await process_frame
	print("PKG-0097 ACT IIc CAPTURE PASS")
	quit(0)
