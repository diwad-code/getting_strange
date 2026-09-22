extends SceneTree

## PKG-0167 normal-driver evidence for Station 42A.
## Three textless M2 state frames (neutral / return executed / sealed other Lena)
## and one true-grayscale M3 structure frame after household consequence on the
## limited-consent / withheld-truth path. This is structural evidence only; it
## does not claim human comprehension, emotion, comfort or PRODUCT GO.

const PACKAGE_ID := "PKG-0167"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0167"
const REPORT_PATH := "res://reports/pkg_0167/visual_evidence_report.txt"
const WAIT_FRAMES := 20

const CASES: Array[Dictionary] = [
	{"id": "neutral", "mono": false},
	{"id": "return_executed", "mono": false},
	{"id": "sealed_other", "mono": false},
	{"id": "structure_mono", "mono": true},
]

var _failures: Array[String] = []
var _records: Array[Dictionary] = []


func _initialize() -> void:
	call_deferred(&"_capture_all")


func _capture_all() -> void:
	root.size = LOGICAL_SIZE
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT_ROOT)) != OK:
		_failures.append("cannot create %s" % OUTPUT_ROOT)
	var state := root.get_node_or_null("GameStateManager")
	if state != null:
		state.campaign_auto_transition_enabled = false
		state.set_pause_menu_visible(false)
	for capture in CASES:
		await _capture_one(capture, state)
	if state != null:
		state.reset_campaign(true)
		state.campaign_auto_transition_enabled = true
	_write_report()
	_finish()


func _capture_one(capture: Dictionary, state: Node) -> void:
	if state != null:
		state.reset_campaign(true)
		state.record_decision(&"p9.method_commitment.method_committed", "force_home")
		state.record_decision(&"method_committed", "force_home")
		state.record_decision(&"route_hypotheses_mapped", true)
		state.record_decision(&"p9.method_commitment.marta_truth_state", "withheld")
		state.record_decision(&"marta_truth_state", "withheld")
		state.record_decision(&"p9.consent_and_cost.jakub_consent_scope", "limited")
		state.record_decision(&"jakub_consent_state", "limited")
	var packed := load("res://scenes/levels/station_42a.tscn") as PackedScene
	if packed == null:
		_failures.append("cannot load station_42a")
		return
	var station := packed.instantiate() as CanvasItem
	if station == null:
		_failures.append("station_42a root is not CanvasItem")
		return
	root.add_child(station)
	for _frame in range(WAIT_FRAMES):
		await physics_frame
	if not _apply_state(station, String(capture["id"])):
		_failures.append("cannot apply station_42a/%s" % String(capture["id"]))
	else:
		var hidden_items := _hide_text_and_ui(station)
		station.queue_redraw()
		for _frame in range(12):
			await physics_frame
		for _frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw
		var image := root.get_texture().get_image()
		if image == null or image.get_size() != LOGICAL_SIZE:
			_failures.append("wrong frame for %s" % String(capture["id"]))
		else:
			_save_frame(image, capture, hidden_items)
	_dispose(station)
	await process_frame


func _save_frame(image: Image, capture: Dictionary, hidden_items: int) -> void:
	if bool(capture["mono"]):
		_make_true_grayscale(image)
		if not _is_grayscale(image):
			_failures.append("residual color in %s" % String(capture["id"]))
	var relative_path := OUTPUT_ROOT.path_join("station_42a_%s.png" % String(capture["id"]))
	if image.save_png(ProjectSettings.globalize_path(relative_path)) != OK:
		_failures.append("cannot save %s" % relative_path)
		return
	_records.append({
		"id": String(capture["id"]),
		"mono": bool(capture["mono"]),
		"hidden": hidden_items,
		"path": relative_path,
		"hash": hash(image.get_data()),
	})
	print("%s CAPTURE PASS: %s hash=%s" % [PACKAGE_ID, relative_path, str(_records.back()["hash"])])


func _apply_state(station: CanvasItem, state_id: String) -> bool:
	match state_id:
		"neutral":
			return true
		"return_executed":
			return bool(station.call("execute_forced_return"))
		"sealed_other":
			return bool(station.call("execute_forced_return")) \
				and bool(station.call("read_sealed_other_lena"))
		"structure_mono":
			return bool(station.call("execute_forced_return")) \
				and bool(station.call("read_sealed_other_lena")) \
				and bool(station.call("read_household_consequence"))
	return false


func _hide_text_and_ui(node: Node) -> int:
	var hidden := 0
	for child in node.get_children():
		if child is CanvasLayer and child.name != "WorldPixelCompositor":
			(child as CanvasLayer).visible = false
			hidden += 1
		if child is CanvasItem and String(child.name).begins_with("CrispDiegeticText"):
			(child as CanvasItem).visible = false
			hidden += 1
		hidden += _hide_text_and_ui(child)
	return hidden


func _make_true_grayscale(image: Image) -> void:
	image.convert(Image.FORMAT_RGBA8)
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var color := image.get_pixel(x, y)
			var luminance := color.r * 0.2126 + color.g * 0.7152 + color.b * 0.0722
			image.set_pixel(x, y, Color(luminance, luminance, luminance, color.a))


func _is_grayscale(image: Image) -> bool:
	for y in range(0, image.get_height(), 8):
		for x in range(0, image.get_width(), 8):
			var color := image.get_pixel(x, y)
			if absf(color.r - color.g) > 0.002 or absf(color.g - color.b) > 0.002:
				return false
	return true


func _dispose(instance: CanvasItem) -> void:
	if instance.get_parent() == root:
		root.remove_child(instance)
	instance.free()


func _write_report() -> void:
	var m2_hashes: Dictionary = {}
	for record in _records:
		if not bool(record["mono"]):
			m2_hashes[record["hash"]] = true
	if m2_hashes.size() != 3:
		_failures.append("three textless M2 frames must have distinct image hashes")
	var mono_records := _records.filter(func(record): return bool(record["mono"]))
	if mono_records.size() != 1:
		_failures.append("one M3 structure frame must be captured")
	var lines := PackedStringArray([
		"PKG-0167 VISUAL EVIDENCE REPORT",
		"Renderer: %s" % RenderingServer.get_video_adapter_name(),
		"Viewport: 640x360; normal Windows display driver; script was not headless.",
		"Three textless M2 frames of Station 42A: neutral, return executed, sealed other Lena.",
		"One M3 true-grayscale structure frame after household consequence on the limited/withheld path.",
		"Hash distinctness and grayscale checks are structural evidence only; no line claims",
		"human comprehension, emotion, comfort or PRODUCT GO (D-012, ADR-003).",
		"",
		"CAPTURED FRAMES",
	])
	for record in _records:
		lines.append("%-18s mono=%-5s hidden=%-2d hash=%s %s" % [record["id"], str(record["mono"]), record["hidden"], str(record["hash"]), record["path"]])
	var file := FileAccess.open(REPORT_PATH, FileAccess.WRITE)
	if file == null:
		_failures.append("cannot write %s" % REPORT_PATH)
		return
	file.store_string("\n".join(lines) + "\n")
	file.close()


func _finish() -> void:
	if _failures.is_empty():
		print("%s CAPTURE PASS: 3 textless M2 frames and 1 M3 structure frame." % PACKAGE_ID)
		quit(0)
		return
	for failure in _failures:
		printerr("%s CAPTURE FAILURE: %s" % [PACKAGE_ID, failure])
	quit(1)
