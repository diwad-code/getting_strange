extends SceneTree

## PKG-0223 — capture station_15/17/18 (glosy i tempo: loop 2 pary + tiki,
## margines K4, projekcja oferty, rejestr z obrazem, konkrety zamiast mantry)
## at 100% x full/notext (normal Windows driver; headless hangs on
## frame_post_draw, fact from PKG-0197) + stan klatek: 15-log (tiki po odczycie)
## i 17-rejected (projekcja zgasla, przekreslenie).
## Output: 8 PNG 640x360 + frames.tsv under reports/pkg_0223/visual.
## No overwrites of 0187..0222 archives.

const OUT_DIR := "res://reports/pkg_0223/visual"
const CORE_IDS: Array[String] = ["station_15", "station_17", "station_18"]


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
			push_error("CAPTURE 0223: cannot load %s" % station_id)
			continue
		var full_image := await _capture_variant(packed, false, 0)
		if full_image != null:
			var full_name := "%s__pkg0223_s100_full.png" % station_id
			full_image.save_png(out_path.path_join(full_name))
			print("CAPTURE 0223 PASS: %s" % full_name)
			index.append("%s\t100\tfull\t%s" % [station_id, full_name])
		var notext_image := await _capture_variant(packed, true, 0)
		if notext_image != null:
			var notext_name := "%s__pkg0223_s100_notext.png" % station_id
			notext_image.save_png(out_path.path_join(notext_name))
			print("CAPTURE 0223 PASS: %s" % notext_name)
			index.append("%s\t100\tnotext\t%s" % [station_id, notext_name])
	var packed15 := load("res://scenes/levels/station_15.tscn") as PackedScene
	if packed15 != null:
		var log_image := await _capture_variant(packed15, false, 15)
		if log_image != null:
			var log_name := "station_15__pkg0223_s100_log.png"
			log_image.save_png(out_path.path_join(log_name))
			print("CAPTURE 0223 PASS: %s" % log_name)
			index.append("station_15\t100\tlog\t%s" % log_name)
	var packed17 := load("res://scenes/levels/station_17.tscn") as PackedScene
	if packed17 != null:
		var rej_image := await _capture_variant(packed17, false, 17)
		if rej_image != null:
			var rej_name := "station_17__pkg0223_s100_rejected.png"
			rej_image.save_png(out_path.path_join(rej_name))
			print("CAPTURE 0223 PASS: %s" % rej_name)
			index.append("station_17\t100\trejected\t%s" % rej_name)
	var tsv := FileAccess.open(out_path.path_join("frames.tsv"), FileAccess.WRITE)
	if tsv != null:
		tsv.store_string("station\tscale\tmode\tfile\n")
		for line: String in index:
			tsv.store_string(line + "\n")
		tsv.close()
	quit(0)


func _capture_variant(packed: PackedScene, hide_text: bool, state_mode: int) -> Image:
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	for frame: int in range(8):
		await process_frame
	if state_mode == 15 and station.has_method("observe_signal_log"):
		station.call("observe_signal_log")
		for frame: int in range(4):
			await process_frame
	if state_mode == 17:
		_seed_donor()
		if station.has_method("read_cost_ledger"):
			station.call("read_cost_ledger")
		if station.has_method("reject_adaptation_offer"):
			station.call("reject_adaptation_offer")
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


func _seed_donor() -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state == null:
		return
	state.record_decision(&"p7.work_history_and_record.institution_trial_result", "small_cost_and_home_echo_confirmed")
	state.record_decision(&"p9.mechanics.small_cost.home_echo_verified", true)
	state.record_decision(&"mechanic_cost_observed", true)


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
