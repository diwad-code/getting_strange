extends SceneTree

## PKG-0218 — capture station_09 (rewritten _draw: apron + style palette +
## >=2 px lines) at 3 scales x full/notext/mono, plus apron spot-checks
## station_13 / station_18 at 100% full/notext (normal Windows driver;
## headless hangs on frame_post_draw, fact from PKG-0197).
## Output: 13 PNG 640x360 + frames.tsv under reports/pkg_0218/visual.
## No overwrites of 0187..0217 archives.
## Scale via set_text_scale(..., false) without persist, back to 1.0 after.
## Mono = luma conversion (0.299/0.587/0.114) for the LOCATION_FAMILY_BIBLE
## monochrome read; proves amber/cyan accents stay separable without hue.

const OUT_DIR := "res://reports/pkg_0218/visual"
const CORE_ID := "station_09"
const SPOT_IDS: Array[String] = ["station_13", "station_18"]
const SCALE_LABELS: Array[int] = [85, 100, 115]
const SCALE_VALUES: Array[float] = [0.85, 1.0, 1.15]


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(640, 360)
	var out_path := ProjectSettings.globalize_path(OUT_DIR)
	DirAccess.make_dir_recursive_absolute(out_path)
	var state := root.get_node_or_null("GameStateManager")
	if state == null:
		push_error("CAPTURE 0218: no GameStateManager autoload")
		quit(1)
		return
	var index: Array[String] = []
	var packed_core := load("res://scenes/levels/%s.tscn" % CORE_ID) as PackedScene
	if packed_core == null:
		push_error("CAPTURE 0218: cannot load %s" % CORE_ID)
		quit(1)
		return
	for sci: int in range(SCALE_LABELS.size()):
		var label: int = SCALE_LABELS[sci]
		var scale_value: float = SCALE_VALUES[sci]
		state.call("set_text_scale", scale_value, false)
		await process_frame
		await process_frame
		var full_image := await _capture_variant(packed_core, false)
		if full_image != null:
			var full_name := "%s__pkg0218_s%d_full.png" % [CORE_ID, label]
			full_image.save_png(out_path.path_join(full_name))
			print("CAPTURE 0218 PASS: %s" % full_name)
			index.append("%s\t%d\tfull\t%s" % [CORE_ID, label, full_name])
			var mono_full := _to_mono(full_image)
			var mono_full_name := "%s__pkg0218_s%d_mono.png" % [CORE_ID, label]
			mono_full.save_png(out_path.path_join(mono_full_name))
			print("CAPTURE 0218 PASS: %s" % mono_full_name)
			index.append("%s\t%d\tmono\t%s" % [CORE_ID, label, mono_full_name])
		else:
			push_error("CAPTURE 0218: no full image %s s%d" % [CORE_ID, label])
		var notext_image := await _capture_variant(packed_core, true)
		if notext_image != null:
			var notext_name := "%s__pkg0218_s%d_notext.png" % [CORE_ID, label]
			notext_image.save_png(out_path.path_join(notext_name))
			print("CAPTURE 0218 PASS: %s" % notext_name)
			index.append("%s\t%d\tnotext\t%s" % [CORE_ID, label, notext_name])
		else:
			push_error("CAPTURE 0218: no notext image %s s%d" % [CORE_ID, label])
	# Apron spot-checks at 100% (source-pinned HOLD: apron paints 360..400,
	# outside standard framing, so these prove no regression, not new paint).
	state.call("set_text_scale", 1.0, false)
	await process_frame
	await process_frame
	for station_id: String in SPOT_IDS:
		var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
		if packed == null:
			push_error("CAPTURE 0218: cannot load %s" % station_id)
			continue
		var spot_full := await _capture_variant(packed, false)
		if spot_full != null:
			var spot_name := "%s__pkg0218_s100_full.png" % station_id
			spot_full.save_png(out_path.path_join(spot_name))
			print("CAPTURE 0218 PASS: %s" % spot_name)
			index.append("%s\t100\tfull\t%s" % [station_id, spot_name])
		var spot_notext := await _capture_variant(packed, true)
		if spot_notext != null:
			var spot_notext_name := "%s__pkg0218_s100_notext.png" % station_id
			spot_notext.save_png(out_path.path_join(spot_notext_name))
			print("CAPTURE 0218 PASS: %s" % spot_notext_name)
			index.append("%s\t100\tnotext\t%s" % [station_id, spot_notext_name])
	state.call("set_text_scale", 1.0, false)
	var tsv := FileAccess.open(out_path.path_join("frames.tsv"), FileAccess.WRITE)
	if tsv != null:
		tsv.store_string("station\tscale\tmode\tfile\n")
		for line: String in index:
			tsv.store_string(line + "\n")
		tsv.close()
	quit(0)


func _to_mono(source: Image) -> Image:
	var mono := source.duplicate() as Image
	var width: int = mono.get_width()
	var height: int = mono.get_height()
	for y: int in range(height):
		for x: int in range(width):
			var pixel: Color = mono.get_pixel(x, y)
			var luma: float = pixel.r * 0.299 + pixel.g * 0.587 + pixel.b * 0.114
			mono.set_pixel(x, y, Color(luma, luma, luma, pixel.a))
	return mono


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
