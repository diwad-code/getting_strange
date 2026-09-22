extends SceneTree

## PKG-0222 — capture station_14/15/18 (correction cost + budgets, zero paint
## changes to default frames) at 100% x full/notext (normal Windows driver;
## headless hangs on frame_post_draw, fact from PKG-0197) + one cost-state
## frame for station_15 (forced corrective without protocol → veil).
## Output: 7 PNG 640x360 + frames.tsv under reports/pkg_0222/visual.
## No overwrites of 0187..0221 archives. Inspection: default frames identical
## in spirit to archives; cost frame shows dim + red seam accent only.

const OUT_DIR := "res://reports/pkg_0222/visual"
const CORE_IDS: Array[String] = ["station_14", "station_15", "station_18"]


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(640, 360)
	var out_path := ProjectSettings.globalize_path(OUT_DIR)
	DirAccess.make_dir_recursive_absolute(out_path)
	var index: Array[String] = []
	for station_id: String in CORE_IDS:
		var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
		if packed == null:
			push_error("CAPTURE 0222: cannot load %s" % station_id)
			continue
		var full_image := await _capture_variant(packed, false, false)
		if full_image != null:
			var full_name := "%s__pkg0222_s100_full.png" % station_id
			full_image.save_png(out_path.path_join(full_name))
			print("CAPTURE 0222 PASS: %s" % full_name)
			index.append("%s\t100\tfull\t%s" % [station_id, full_name])
		else:
			push_error("CAPTURE 0222: no full image %s" % station_id)
		var notext_image := await _capture_variant(packed, true, false)
		if notext_image != null:
			var notext_name := "%s__pkg0222_s100_notext.png" % station_id
			notext_image.save_png(out_path.path_join(notext_name))
			print("CAPTURE 0222 PASS: %s" % notext_name)
			index.append("%s\t100\tnotext\t%s" % [station_id, notext_name])
		else:
			push_error("CAPTURE 0222: no notext image %s" % station_id)
	var packed15 := load("res://scenes/levels/station_15.tscn") as PackedScene
	if packed15 != null:
		var cost_image := await _capture_variant(packed15, false, true)
		if cost_image != null:
			var cost_name := "station_15__pkg0222_s100_cost.png"
			cost_image.save_png(out_path.path_join(cost_name))
			print("CAPTURE 0222 PASS: %s" % cost_name)
			index.append("station_15\t100\tcost\t%s" % cost_name)
		else:
			push_error("CAPTURE 0222: no cost image station_15")
	var tsv := FileAccess.open(out_path.path_join("frames.tsv"), FileAccess.WRITE)
	if tsv != null:
		tsv.store_string("station\tscale\tmode\tfile\n")
		for line: String in index:
			tsv.store_string(line + "\n")
		tsv.close()
	quit(0)


func _capture_variant(packed: PackedScene, hide_text: bool, force_cost: bool) -> Image:
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	for frame: int in range(8):
		await process_frame
	if force_cost and station.has_method("send_corrective_impulse"):
		station.call("send_corrective_impulse")
		for frame: int in range(4):
			await process_frame
	if hide_text:
		_clear_dialogue(station)
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
