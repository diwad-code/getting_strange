extends SceneTree

## PKG-0197 — fresh before/after frames for the touched addresses (01/06/08).
## Headless capture; normal-driver manual inspection is recorded as a limit in
## the package report. Saves 640x360 PNGs + frames.tsv under reports/pkg_0197.

const OUT_DIR := "res://reports/pkg_0197/visual"
const STATIONS: Array[String] = ["station_01", "station_06", "station_08"]


func _initialize() -> void:
	call_deferred(&"_run")


func _run() -> void:
	root.size = Vector2i(640, 360)
	var out_path := ProjectSettings.globalize_path(OUT_DIR)
	DirAccess.make_dir_recursive_absolute(out_path)
	var index: Array[String] = []
	for station_id in STATIONS:
		var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
		if packed == null:
			push_error("CAPTURE 0197: cannot load %s" % station_id)
			continue
		var station := packed.instantiate() as Node2D
		root.add_child(station)
		_clear_dialogue(station)
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw
		var image := root.get_texture().get_image()
		var file_name := "%s__pkg0197.png" % station_id
		if image != null:
			image.save_png(out_path.path_join(file_name))
			print("CAPTURE 0197 PASS: %s" % file_name)
			index.append("%s\tpkg0197\t%s" % [station_id, file_name])
		else:
			push_error("CAPTURE 0197: no image for %s" % station_id)
		station.free()
		await process_frame
	var tsv := FileAccess.open(out_path.path_join("frames.tsv"), FileAccess.WRITE)
	if tsv != null:
		tsv.store_string("station\tmode\tfile\n")
		for line in index:
			tsv.store_string(line + "\n")
		tsv.close()
	quit(0)


func _clear_dialogue(node: Node) -> void:
	if node is CRTDialogueBox:
		var dialogue := node as CRTDialogueBox
		var guard := 0
		while dialogue.is_presenting() and guard < 32:
			dialogue.advance_dialogue()
			guard += 1
	for child in node.get_children():
		_clear_dialogue(child)
