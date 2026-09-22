extends SceneTree

## PKG-0216 — capture station_13 / station_18 / station_42b after the
## dictionary + palimpsest edit (normal Windows driver; headless hangs on
## frame_post_draw, fact from PKG-0197). Output: 18 PNG 640x360
## (3 stations x 3 scales x full/notext) + frames.tsv
## under reports/pkg_0216/visual. No overwrites of 0187..0215 archives.
## Scale via set_text_scale(..., false) without persist, back to 1.0 after.

const OUT_DIR := "res://reports/pkg_0216/visual"
const STATION_IDS: Array[String] = ["station_13", "station_18", "station_42b"]
const SCALE_LABELS: Array[int] = [85, 100, 115]
const SCALE_VALUES: Array[float] = [0.85, 1.0, 1.15]


func _initialize() -> void:
	call_deferred(&"_run")


func _run() -> void:
	root.size = Vector2i(640, 360)
	var out_path := ProjectSettings.globalize_path(OUT_DIR)
	DirAccess.make_dir_recursive_absolute(out_path)
	var state := root.get_node_or_null("GameStateManager")
	if state == null:
		push_error("CAPTURE 0216: no GameStateManager autoload")
		quit(1)
		return
	var index: Array[String] = []
	for station_id: String in STATION_IDS:
		var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
		if packed == null:
			push_error("CAPTURE 0216: cannot load %s" % station_id)
			continue
		for sci: int in range(SCALE_LABELS.size()):
			var label: int = SCALE_LABELS[sci]
			var scale_value: float = SCALE_VALUES[sci]
			state.call("set_text_scale", scale_value, false)
			await process_frame
			await process_frame
			var full_image := await _capture_variant(packed, false)
			if full_image != null:
				var full_name := "%s__pkg0216_s%d_full.png" % [station_id, label]
				full_image.save_png(out_path.path_join(full_name))
				print("CAPTURE 0216 PASS: %s" % full_name)
				index.append("%s\t%d\tfull\t%s" % [station_id, label, full_name])
			else:
				push_error("CAPTURE 0216: no full image %s s%d" % [station_id, label])
			var notext_image := await _capture_variant(packed, true)
			if notext_image != null:
				var notext_name := "%s__pkg0216_s%d_notext.png" % [station_id, label]
				notext_image.save_png(out_path.path_join(notext_name))
				print("CAPTURE 0216 PASS: %s" % notext_name)
				index.append("%s\t%d\tnotext\t%s" % [station_id, label, notext_name])
			else:
				push_error("CAPTURE 0216: no notext image %s s%d" % [station_id, label])
	state.call("set_text_scale", 1.0, false)
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
