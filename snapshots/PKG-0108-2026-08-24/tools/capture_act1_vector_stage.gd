extends SceneTree

const ACT_I_PATHS := [
	"res://scenes/levels/station_06.tscn",
	"res://scenes/levels/station_07.tscn",
	"res://scenes/levels/station_08.tscn",
	"res://scenes/levels/station_09.tscn",
	"res://scenes/levels/station_10.tscn",
]


func _initialize() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var output_dir := ProjectSettings.globalize_path("res://reports/pkg_0094_act1")
	if DirAccess.make_dir_recursive_absolute(output_dir) != OK:
		push_error("PKG-0094 CAPTURE: cannot create output directory")
		quit(1)
		return
	for scene_path in ACT_I_PATHS:
		var packed := load(scene_path) as PackedScene
		if packed == null:
			push_error("PKG-0094 CAPTURE: cannot load " + scene_path)
			quit(1)
			return
		var station := packed.instantiate() as Node2D
		root.add_child(station)
		for frame in range(10):
			await process_frame
		# The opening CRT cue is verified separately; hide it here so the composition
		# audit renders the entire authored stage rather than UI coverage.
		var dialogue := station.get_node_or_null("CRTDialogueBox") as CanvasLayer
		if dialogue:
			dialogue.hide()
		await process_frame
		await RenderingServer.frame_post_draw
		var image := root.get_texture().get_image()
		if image == null:
			push_error("PKG-0094 CAPTURE: no image for " + scene_path)
			quit(1)
			return
		var output_path := output_dir.path_join(scene_path.get_file().get_basename() + ".png")
		if image.save_png(output_path) != OK:
			push_error("PKG-0094 CAPTURE: cannot save " + output_path)
			quit(1)
			return
		print("PKG-0094 CAPTURE PASS: " + output_path)
		station.queue_free()
		await process_frame
	print("PKG-0094 ACT I CAPTURE PASS")
	quit(0)