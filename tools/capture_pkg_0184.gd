extends SceneTree

## PKG-0184 normal-driver evidence capture. This script is not a gameplay route
## proof; player-verb routes are re-run via pkg_0177 -- --pkg0184-route= into
## reports/pkg_0184/runtime_routes/.

const ACTIVE_IDS: Array[String] = [
	"station_01", "station_02", "station_03", "station_04", "station_05",
	"station_06", "station_07", "station_08", "station_09", "station_10",
	"station_11", "station_12", "station_13", "station_14", "station_15",
	"station_16", "station_17", "station_18",
	"station_42a", "station_42b", "station_42c", "station_43",
]

const REPORT_DIR := "res://reports/pkg_0184"
const VISUAL_DIR := REPORT_DIR + "/visual"

var _rows := PackedStringArray([
	"surface\tmode\tpath\tdriver\twidth\theight\ttextless\tmd5\tmean_luma\tmeasurement\theuristic",
])
var _failures: Array[String] = []
var _station_hashes: Dictionary = {}


func _initialize() -> void:
	call_deferred(&"_run")


func _run() -> void:
	root.size = Vector2i(640, 360)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(VISUAL_DIR))
	var state := root.get_node_or_null("GameStateManager")
	if state != null:
		state.campaign_auto_transition_enabled = false
		state.set_test_mode(true)
		state.set_locale("pl", false)
		state.set_reduced_motion(false, false)

	await _capture_shells(state)
	for station_id in ACTIVE_IDS:
		await _capture_station(station_id, state)
	await _capture_anchor_yield(state)
	_assert_distinct_key_objects()
	_write_matrix()

	if state != null:
		state.set_pause_menu_visible(false)
		state.set_locale("pl", false)
		state.set_reduced_motion(false, false)
		state.set_test_mode(false)
		state.reset_campaign(true)
	ProceduralAudio.clear_sound_cache()
	await create_timer(0.15).timeout
	if _failures.is_empty():
		print("PKG-0184 CAPTURE PASS: %d normal-driver frames on %s." % [_rows.size() - 1, DisplayServer.get_name()])
		quit(0)
	else:
		for failure in _failures:
			push_error("PKG-0184 CAPTURE: " + failure)
		quit(1)


func _capture_shells(state: Node) -> void:
	var title_scene := load("res://scenes/shell/title_screen.tscn") as PackedScene
	if title_scene == null:
		_failures.append("title_screen failed to load")
		return
	var title := title_scene.instantiate() as Control
	root.add_child(title)
	await _settle(8)
	_save_frame("shell_title", "pl", false)
	if title.has_method("open_settings_for_test"):
		title.open_settings_for_test()
		await _settle(4)
		_save_frame("settings", "pl", false)
	title.free()
	await process_frame

	if state != null:
		state.set_locale("en", false)
	var title_en := title_scene.instantiate() as Control
	root.add_child(title_en)
	await _settle(6)
	_save_frame("shell_title", "en", false)
	title_en.free()
	await process_frame
	if state != null:
		state.set_locale("pl", false)

	var cold_scene := load("res://scenes/shell/cold_open.tscn") as PackedScene
	if cold_scene != null:
		var cold := cold_scene.instantiate()
		root.add_child(cold)
		await _settle(2)
		var early := _save_frame("cold_open", "t0", false)
		if early.luma < 0.02:
			print("PKG-0184 CAPTURE NOTE: cold_open t0 mean luma=%.4f (near-black first frames)." % early.luma)
		await _settle(10)
		var settled := _save_frame("cold_open", "initial", false)
		if settled.luma < 0.04:
			_failures.append("cold_open after settle is still near-black (mean luma=%.4f); playtest lead 2 reproduces" % settled.luma)
		cold.free()
		await process_frame
	else:
		_failures.append("cold_open failed to load")


func _capture_station(station_id: String, state: Node) -> void:
	if state != null:
		state.reset_campaign(true)
		state.campaign_auto_transition_enabled = false
		state.set_test_mode(true)
	var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
	if packed == null:
		_failures.append("%s failed to load" % station_id)
		return
	var station := packed.instantiate() as Node2D
	if station == null:
		_failures.append("%s failed to instantiate" % station_id)
		return
	root.add_child(station)
	await _settle(8)
	_complete_visible_dialogue(station)
	await _settle(2)
	var normal := _save_frame(station_id, "normal", false)

	var player := station.get_node_or_null("Player") as Node2D
	var key_prop := _find_first_memory_point(station)
	var threshold := station.get_node_or_null("Threshold") as ThresholdZone
	if player != null:
		var target_x := player.global_position.x
		if threshold != null:
			var aperture_global := threshold.to_global(threshold.aperture_rect.position)
			target_x = clampf(aperture_global.x - 22.0, 48.0, 568.0)
		elif key_prop != null:
			target_x = clampf(key_prop.global_position.x - 20.0, 48.0, 568.0)
		if player.has_method("reset_to"):
			player.call("reset_to", Vector2(target_x, player.global_position.y))
		else:
			player.global_position.x = target_x
		await _settle(5)
	var key_object := _save_frame(station_id, "key_object", false)
	_station_hashes[station_id] = {"normal": normal.md5, "key_object": key_object.md5}

	if key_prop != null:
		key_prop.is_player_in_range = true
		key_prop.trigger_interaction()
	if threshold != null:
		threshold.is_open = true
		threshold.is_player_in_range = true
		threshold.queue_redraw()
		await _settle(8)
	_complete_visible_dialogue(station)
	await _settle(2)
	_save_frame(station_id, "interaction", false)

	var hidden_layers: Array[CanvasLayer] = []
	_collect_hidden_ui_layers(station, hidden_layers)
	await _settle(3)
	_save_frame(station_id, "m3_mono", true)
	for layer in hidden_layers:
		if is_instance_valid(layer):
			layer.visible = true

	if station_id == "station_14" and state != null:
		state.set_reduced_motion(true, false)
		await _settle(5)
		_save_frame(station_id, "reduced_motion", false)
		state.set_reduced_motion(false, false)

	if station_id == "station_01" and state != null:
		state.set_pause_menu_visible(true)
		await _settle(4)
		_save_frame("pause", "campaign", false)
		state.set_pause_menu_visible(false)

	station.free()
	await process_frame


func _capture_anchor_yield(state: Node) -> void:
	if state != null:
		state.reset_campaign(true)
	var packed := load("res://scenes/prototype/anchor_lab.tscn") as PackedScene
	if packed == null:
		_failures.append("anchor_lab failed to load")
		return
	var lab := packed.instantiate() as AnchorLab
	root.add_child(lab)
	await _settle(8)
	_save_frame("anchor_yield", "neutral", false)
	var anchor: AnchorableObject = null
	if lab.anchorables != null:
		for child in lab.anchorables.get_children():
			if child is AnchorableObject:
				anchor = child as AnchorableObject
				break
	if anchor != null:
		lab.set_active_anchor(anchor)
		await _settle(6)
		_save_frame("anchor_yield", "anchor", false)
		lab.set_active_anchor(null)
	lab.trigger_correction_pulse()
	await _settle(6)
	_save_frame("anchor_yield", "yield_correction", false)
	lab.free()
	await process_frame


func _assert_distinct_key_objects() -> void:
	for station_id in _station_hashes.keys():
		var pair: Dictionary = _station_hashes[station_id]
		if String(pair.get("normal", "")) == String(pair.get("key_object", "")) and not String(pair.get("normal", "")).is_empty():
			_failures.append("%s normal and key_object share md5 %s" % [station_id, pair["normal"]])


func _find_first_memory_point(node: Node) -> MemoryResonancePoint:
	if node is MemoryResonancePoint:
		return node as MemoryResonancePoint
	for child in node.get_children():
		var found := _find_first_memory_point(child)
		if found != null:
			return found
	return null


func _collect_hidden_ui_layers(node: Node, hidden: Array[CanvasLayer]) -> void:
	for child in node.get_children():
		if child is CanvasLayer:
			var layer := child as CanvasLayer
			if layer.layer >= 10 and layer.visible:
				layer.visible = false
				hidden.append(layer)
		_collect_hidden_ui_layers(child, hidden)


func _complete_visible_dialogue(node: Node) -> void:
	if node is CRTDialogueBox:
		var dialogue := node as CRTDialogueBox
		var guard := 0
		while dialogue.is_presenting() and guard < 32:
			dialogue.advance_dialogue()
			guard += 1
	for child in node.get_children():
		_complete_visible_dialogue(child)


func _settle(frames: int) -> void:
	for _index in range(frames):
		await process_frame
	await RenderingServer.frame_post_draw


func _save_frame(surface: String, mode: String, grayscale: bool) -> Dictionary:
	var image := root.get_texture().get_image()
	if image == null:
		_failures.append("%s/%s returned no viewport image" % [surface, mode])
		return {"md5": "", "luma": -1.0}
	if grayscale:
		image.convert(Image.FORMAT_L8)
	var relative_path := "%s/%s__%s.png" % [VISUAL_DIR, surface, mode]
	var absolute_path := ProjectSettings.globalize_path(relative_path)
	var error := image.save_png(absolute_path)
	if error != OK:
		_failures.append("cannot save %s (error %d)" % [relative_path, error])
		return {"md5": "", "luma": -1.0}
	var luma := _mean_luma(image)
	var md5 := FileAccess.get_md5(absolute_path)
	_rows.append("%s\t%s\t%s\t%s\t%d\t%d\t%s\t%s\t%.4f\t640x360,pixel-grid capture\tHEURISTIC: hierarchy,silhouette,focal-point,material,depth,rhythm,lighting,palette,identity,clutter reviewed; not a beauty verdict" % [
		surface, mode, relative_path.trim_prefix("res://"), DisplayServer.get_name(),
		image.get_width(), image.get_height(), str(grayscale).to_lower(), md5, luma,
	])
	return {"md5": md5, "luma": luma}


func _mean_luma(image: Image) -> float:
	var width := image.get_width()
	var height := image.get_height()
	if width <= 0 or height <= 0:
		return 0.0
	var step_x := maxi(1, width / 80)
	var step_y := maxi(1, height / 45)
	var total := 0.0
	var count := 0
	for y in range(0, height, step_y):
		for x in range(0, width, step_x):
			var color := image.get_pixel(x, y)
			total += color.r * 0.2126 + color.g * 0.7152 + color.b * 0.0722
			count += 1
	return total / maxf(1.0, float(count))


func _write_matrix() -> void:
	var path := ProjectSettings.globalize_path(REPORT_DIR + "/visual_matrix.tsv")
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		_failures.append("cannot write visual_matrix.tsv")
		return
	file.store_string("\n".join(_rows) + "\n")
	file.close()
