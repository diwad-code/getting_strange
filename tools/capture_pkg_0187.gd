extends SceneTree

## PKG-0187 full visual-audit evidence capture.
## Run with the normal Windows display driver, never --headless:
##   godot_console --path C:\getting_strange --script res://tools/capture_pkg_0187.gd --audio-driver WASAPI
## It writes only reports/pkg_0187/ and does not overwrite earlier packages.

const ACTIVE_IDS: Array[String] = [
	"station_01", "station_02", "station_03", "station_04", "station_05",
	"station_06", "station_07", "station_08", "station_09", "station_10",
	"station_11", "station_12", "station_13", "station_14", "station_15",
	"station_16", "station_17", "station_18",
	"station_42a", "station_42b", "station_42c", "station_43",
]

const NPC_CLOSEUPS: Array[String] = [
	"station_06", "station_08", "station_10", "station_11", "station_12", "station_42b", "station_42c",
]

const PORTRAIT_SPEAKERS := [
	{"id": "lena", "speaker": "Lena", "line": "To nie jest mój świat. Zostawiam próbkę."},
	{"id": "marta", "speaker": "Marta", "line": "Wróć na czternastkę. Czekam."},
	{"id": "jakub", "speaker": "Jakub", "line": "Nie pokażę blizny. Nie tutaj."},
	{"id": "wierzbicka", "speaker": "dr Wierzbicka", "line": "Pani Wolska jest odchyleniem w rejestrze."},
	{"id": "szymon", "speaker": "Szymon", "line": "Studnia była prawdziwa. Reszta nie."},
]

const REPORT_DIR := "res://reports/pkg_0187"
const VISUAL_DIR := REPORT_DIR + "/visual"

var _rows := PackedStringArray([
	"surface\tmode\tpath\tdriver\twidth\theight\ttextless\tmd5\tmean_luma",
])
var _failures: Array[String] = []


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
	await _capture_panels(state)
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
		print("PKG-0187 VISUAL CAPTURE PASS: %d Windows frames." % (_rows.size() - 1))
		quit(0)
	else:
		for failure in _failures:
			push_error("PKG-0187 CAPTURE: " + failure)
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

	var cold_scene := load("res://scenes/shell/cold_open.tscn") as PackedScene
	if cold_scene == null:
		_failures.append("cold_open failed to load")
		return
	var cold := cold_scene.instantiate()
	root.add_child(cold)
	await _settle(12)
	_save_frame("cold_open", "initial", false)
	cold.free()
	await process_frame
	if state != null:
		state.set_locale("pl", false)


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
	await _settle(10)

	var dialogue := _find_dialogue(station)
	if dialogue == null or not dialogue.is_presenting():
		_failures.append("%s has no visible opening CRT panel" % station_id)
	else:
		_save_frame(station_id, "opening_panel", false)
		_complete_visible_dialogue(station)
		await _settle(3)
	_save_frame(station_id, "normal", false)

	var player := station.get_node_or_null("Player") as Node2D
	var threshold := station.get_node_or_null("Threshold") as ThresholdZone
	if threshold == null:
		_failures.append("%s missing runtime ThresholdZone" % station_id)
	elif player != null:
		var anchor := threshold.to_global(threshold.entry_anchor)
		if player.has_method("reset_to"):
			player.call("reset_to", Vector2(clampf(anchor.x, 48.0, 568.0), player.global_position.y))
		else:
			player.global_position.x = clampf(anchor.x, 48.0, 568.0)
		threshold.is_open = true
		threshold.is_player_in_range = true
		threshold.queue_redraw()
		await _settle(6)
	_save_frame(station_id, "threshold", false)

	if station_id in NPC_CLOSEUPS:
		var rig := _find_rig(station)
		if rig == null:
			_failures.append("%s has no CharacterVisualRig for close-up" % station_id)
		elif player != null:
			var focus_x := clampf(rig.global_position.x - 48.0, 48.0, 560.0)
			if player.has_method("reset_to"):
				player.call("reset_to", Vector2(focus_x, player.global_position.y))
			else:
				player.global_position.x = focus_x
			await _settle(6)
			_save_frame(station_id, "npc_frame", false)

	var hidden: Array[Node] = []
	_hide_text_and_ui(station, hidden)
	await _settle(3)
	_save_frame(station_id, "mono", true)
	for item in hidden:
		if not is_instance_valid(item):
			continue
		if item is CanvasLayer:
			(item as CanvasLayer).visible = true
		elif item is CanvasItem:
			(item as CanvasItem).visible = true

	if station_id == "station_01" and state != null:
		state.set_pause_menu_visible(true)
		await _settle(4)
		_save_frame("pause", "campaign", false)
		state.set_pause_menu_visible(false)

	station.free()
	await process_frame


func _capture_panels(state: Node) -> void:
	if state != null:
		state.reset_campaign(true)
		state.campaign_auto_transition_enabled = false
		state.set_test_mode(true)
	var packed := load("res://scenes/levels/station_10.tscn") as PackedScene
	if packed == null:
		_failures.append("station_10 failed to load for panel capture")
		return
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await _settle(8)
	_complete_visible_dialogue(station)
	await _settle(2)
	var dialogue := _find_dialogue(station)
	if dialogue == null:
		_failures.append("CRTDialogueBox missing on station_10")
		station.free()
		return
	for speaker in PORTRAIT_SPEAKERS:
		dialogue.present([{"speaker": String(speaker["speaker"]), "text": String(speaker["line"])}])
		await _settle(2)
		dialogue.advance_dialogue()
		await _settle(3)
		_save_frame("panel_portrait", String(speaker["id"]), false)

	var thought := _find_thought(station)
	if thought != null and thought.has_method("present_thought"):
		thought.call("present_thought", null, "Klucz pasuje. To nie jest moje mieszkanie.")
		await _settle(4)
		_save_frame("panel_thought", "lena", false)
		if thought.has_method("dismiss"):
			thought.call("dismiss")
	dialogue.present([
		{"speaker": "Marta", "text": "Nie jesteś jej zastępstwem."},
		{"speaker": "Lena", "text": "Nie proszę o zastępstwo. Proszę o fakt."},
	])
	await _settle(2)
	dialogue.advance_dialogue()
	await _settle(3)
	_save_frame("panel_dialogue", "marta_then_lena", false)
	station.free()
	await process_frame


func _find_dialogue(node: Node) -> CRTDialogueBox:
	if node is CRTDialogueBox:
		return node as CRTDialogueBox
	for child in node.get_children():
		var found := _find_dialogue(child)
		if found != null:
			return found
	return null


func _find_thought(node: Node) -> InnerThoughtSurface:
	if node is InnerThoughtSurface:
		return node as InnerThoughtSurface
	for child in node.get_children():
		var found := _find_thought(child)
		if found != null:
			return found
	return null


func _find_rig(node: Node) -> Node2D:
	if node.get_script() != null and String(node.get_script().resource_path).ends_with("character_visual_rig.gd"):
		return node as Node2D
	for child in node.get_children():
		var found := _find_rig(child)
		if found != null:
			return found
	return null


func _complete_visible_dialogue(node: Node) -> void:
	if node is CRTDialogueBox:
		var dialogue := node as CRTDialogueBox
		var guard := 0
		while dialogue.is_presenting() and guard < 32:
			dialogue.advance_dialogue()
			guard += 1
	for child in node.get_children():
		_complete_visible_dialogue(child)


func _hide_text_and_ui(node: Node, hidden: Array[Node]) -> void:
	for child in node.get_children():
		if child is CanvasLayer and child.name != "WorldPixelCompositor":
			var layer := child as CanvasLayer
			if layer.visible:
				layer.visible = false
				hidden.append(layer)
		elif child is CrispDiegeticText or child is InnerThoughtSurface or child is CRTDialogueBox:
			var item := child as CanvasItem
			if item.visible:
				item.visible = false
				hidden.append(item)
		_hide_text_and_ui(child, hidden)


func _settle(frames: int) -> void:
	for _index in range(frames):
		await process_frame
	await RenderingServer.frame_post_draw


func _save_frame(surface: String, mode: String, grayscale: bool) -> void:
	var image := root.get_texture().get_image()
	if image == null:
		_failures.append("%s/%s returned no viewport image" % [surface, mode])
		return
	if grayscale:
		image.convert(Image.FORMAT_L8)
	var relative_path := "%s/%s__%s.png" % [VISUAL_DIR, surface, mode]
	var absolute_path := ProjectSettings.globalize_path(relative_path)
	var error := image.save_png(absolute_path)
	if error != OK:
		_failures.append("cannot save %s (error %d)" % [relative_path, error])
		return
	_rows.append("%s\t%s\t%s\t%s\t%d\t%d\t%s\t%s\t%.4f" % [
		surface, mode, relative_path.trim_prefix("res://"), DisplayServer.get_name(), image.get_width(), image.get_height(),
		str(grayscale).to_lower(), FileAccess.get_md5(absolute_path), _mean_luma(image),
	])
	print("PKG-0187 CAPTURE: %s" % relative_path.trim_prefix("res://"))


func _mean_luma(image: Image) -> float:
	var total := 0.0
	var count := 0
	var step_x := maxi(1, image.get_width() / 80)
	var step_y := maxi(1, image.get_height() / 45)
	for y in range(0, image.get_height(), step_y):
		for x in range(0, image.get_width(), step_x):
			var color := image.get_pixel(x, y)
			total += color.r * 0.2126 + color.g * 0.7152 + color.b * 0.0722
			count += 1
	return total / maxf(1.0, float(count))


func _write_matrix() -> void:
	var file := FileAccess.open(ProjectSettings.globalize_path(REPORT_DIR + "/visual_matrix.tsv"), FileAccess.WRITE)
	if file == null:
		_failures.append("cannot write visual_matrix.tsv")
		return
	file.store_string("\n".join(_rows) + "\n")
	file.close()
