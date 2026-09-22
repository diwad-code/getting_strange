extends SceneTree

## PKG-0224 — capture station_06 (miejska) / station_08 (mieszkalna) at 100%
## x full/notext (normal Windows driver; headless hangs on frame_post_draw,
## fact from PKG-0197). Tag via env PKG0224_TAG (pre/post), output 4 PNG
## 640x360 + frames.tsv under reports/pkg_0224/visual. No overwrites of
## 0187..0223 archives. Asset delta in this package (jakub seated) is not
## visible in 06/08; frames prove HOLD of both family profiles.

const OUT_DIR := "res://reports/pkg_0224/visual"
const CORE_IDS: Array[String] = ["station_06", "station_08"]


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(640, 360)
	var tag := OS.get_environment("PKG0224_TAG")
	if tag == "":
		tag = "pre"
	var out_path := ProjectSettings.globalize_path(OUT_DIR)
	DirAccess.make_dir_recursive_absolute(out_path)
	var index: Array[String] = []
	for station_id: String in CORE_IDS:
		var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
		if packed == null:
			push_error("CAPTURE 0224: cannot load %s" % station_id)
			continue
		var full_image := await _capture_variant(packed, false)
		if full_image != null:
			var full_name := "%s__pkg0224_s100_full_%s.png" % [station_id, tag]
			full_image.save_png(out_path.path_join(full_name))
			print("CAPTURE 0224 PASS: %s" % full_name)
			index.append("%s\t100\tfull\t%s" % [station_id, full_name])
		var notext_image := await _capture_variant(packed, true)
		if notext_image != null:
			var notext_name := "%s__pkg0224_s100_notext_%s.png" % [station_id, tag]
			notext_image.save_png(out_path.path_join(notext_name))
			print("CAPTURE 0224 PASS: %s" % notext_name)
			index.append("%s\t100\tnotext\t%s" % [station_id, notext_name])
	var tsv := FileAccess.open(out_path.path_join("frames.tsv"), FileAccess.WRITE)
	if tsv != null:
		tsv.store_string("station\tscale\tmode\tfile\n")
		for line: String in index:
			tsv.store_string(line + "\n")
		tsv.close()
	quit(0)


func _capture_variant(packed: PackedScene, hide_text: bool) -> Image:
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	for frame: int in range(8):
		await process_frame
	if hide_text:
		_hide_diegetic_text(station)
		for frame: int in range(4):
			await process_frame
	else:
		_clear_dialogue(station)
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	station.free()
	await process_frame
	return image


func _clear_dialogue(node: Node) -> void:
	if node is CRTDialogueBox:
		var dialogue := node as CRTDialogueBox
		var guard := 0
		while dialogue.is_presenting() and guard < 32:
			dialogue.advance_dialogue()
			guard += 1
	for child: Node in node.get_children():
		_clear_dialogue(child)


func _hide_diegetic_text(node: Node) -> void:
	var is_diegetic := (node is CrispDiegeticText) or String(node.name).begins_with("CrispDiegeticText")
	if is_diegetic:
		(node as Node2D).visible = false
		var crisp_layer := node.get_node_or_null("CrispDiegeticLayer") as CanvasLayer
		if crisp_layer != null:
			crisp_layer.visible = false
	if node is CRTDialogueBox:
		(node as CanvasLayer).visible = false
	if String(node.name) == "InnerThoughtSurface":
		(node as CanvasLayer).visible = false
	for child: Node in node.get_children():
		_hide_diegetic_text(child)
