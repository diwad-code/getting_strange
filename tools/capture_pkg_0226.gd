extends SceneTree

## PKG-0226 — capture station_18 / station_42a / station_42b / station_42c at
## 100% x full/notext/read (normal Windows driver; headless hangs on
## frame_post_draw, fact from PKG-0197). Tag via env PKG0226_TAG (pre/post),
## output 12 PNG 640x360 + frames.tsv under reports/pkg_0226/visual.
## No overwrites of 0187..0225 archives. Frames prove HOLD of the commit and
## household compositions plus the new N6 marks: the 6-item review table at
## the 18 commit post and the truth rings at the 42 household tables
## (read variant mirrors the canonical 0195 seeds: 42a full, 42b partial,
## 42c withheld). New-var sets are guarded by `in` so the PRE run on the
## unmodified disk stays green.

const OUT_DIR := "res://reports/pkg_0226/visual"
const CORE_IDS: Array[String] = ["station_18", "station_42a", "station_42b", "station_42c"]
const READ_TRUTH := {
	"station_18": "full",
	"station_42a": "full",
	"station_42b": "partial",
	"station_42c": "withheld",
}


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(640, 360)
	var tag := OS.get_environment("PKG0226_TAG")
	if tag == "":
		tag = "pre"
	var out_path := ProjectSettings.globalize_path(OUT_DIR)
	DirAccess.make_dir_recursive_absolute(out_path)
	var index: Array[String] = []
	for station_id: String in CORE_IDS:
		var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
		if packed == null:
			push_error("CAPTURE 0226: cannot load %s" % station_id)
			continue
		var full_image := await _capture_variant(packed, station_id, 0)
		if full_image != null:
			var full_name := "%s__pkg0226_s100_full_%s.png" % [station_id, tag]
			full_image.save_png(out_path.path_join(full_name))
			print("CAPTURE 0226 PASS: %s" % full_name)
			index.append("%s\t100\tfull\t%s" % [station_id, full_name])
		var notext_image := await _capture_variant(packed, station_id, 1)
		if notext_image != null:
			var notext_name := "%s__pkg0226_s100_notext_%s.png" % [station_id, tag]
			notext_image.save_png(out_path.path_join(notext_name))
			print("CAPTURE 0226 PASS: %s" % notext_name)
			index.append("%s\t100\tnotext\t%s" % [station_id, notext_name])
		var read_image := await _capture_variant(packed, station_id, 2)
		if read_image != null:
			var read_name := "%s__pkg0226_s100_read_%s.png" % [station_id, tag]
			read_image.save_png(out_path.path_join(read_name))
			print("CAPTURE 0226 PASS: %s" % read_name)
			index.append("%s\t100\tread\t%s" % [station_id, read_name])
	var tsv := FileAccess.open(out_path.path_join("frames.tsv"), FileAccess.WRITE)
	if tsv != null:
		tsv.store_string("station\tscale\tmode\tfile\n")
		for line: String in index:
			tsv.store_string(line + "\n")
		tsv.close()
	quit(0)


func _capture_variant(packed: PackedScene, station_id: String, mode: int) -> Image:
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	for frame: int in range(8):
		await process_frame
	if mode == 1:
		_hide_diegetic_text(station)
		for frame: int in range(4):
			await process_frame
	elif mode == 2:
		# PKG-0226: read-state BEZ warstw tekstu — czysta scenografia ze
		# znacznikami (ukrycie zamiast _clear_dialogue: brak panelu, brak
		# przesunięcia kamery dialogowej, zero niejednoznaczności).
		_apply_read_state(station, station_id)
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


func _apply_read_state(station: Node2D, station_id: String) -> void:
	var truth: String = String(READ_TRUTH.get(station_id, "partial"))
	if station_id == "station_18":
		if "are_forecasts_compared" in station:
			station.set("are_forecasts_compared", true)
		if "is_marta_truth_disclosed" in station:
			station.set("is_marta_truth_disclosed", true)
		if "is_method_committed" in station:
			station.set("is_method_committed", true)
		if "marta_truth_state" in station:
			station.set("marta_truth_state", StringName(truth))
		# commit_table_marks jest typowana Array[bool]: mutacja in place,
		# nie set() nietypowanym literałem.
		if "commit_table_marks" in station:
			(station.get("commit_table_marks") as Array).fill(true)
	else:
		if "is_household_read" in station:
			station.set("is_household_read", true)
		if "marta_truth_state" in station:
			station.set("marta_truth_state", truth)
		if "is_return_executed" in station:
			station.set("is_return_executed", true)
		if "is_flow_closed" in station:
			station.set("is_flow_closed", true)
		if "is_passage_opened" in station:
			station.set("is_passage_opened", true)
	station.queue_redraw()
	# (Bez _clear_dialogue: wariant read ukrywa tekst w _capture_variant.)


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
