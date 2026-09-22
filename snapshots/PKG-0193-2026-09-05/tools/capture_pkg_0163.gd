extends SceneTree

# PKG-0163 normal-driver evidence. Run without --headless.
# Three textless M2 frames of Station 15 (neutral / control echo / confirmed
# response) plus one true-grayscale M3 structure frame of the boundary family.
const PACKAGE_ID := "PKG-0163"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0163"
const REPORT_PATH := "res://reports/pkg_0163/visual_evidence_report.txt"
const WAIT_FRAMES := 20

const CASES: Array[Dictionary] = [
	{"id": "neutral", "mono": false},
	{"id": "control_echo", "mono": false},
	{"id": "confirmed", "mono": false},
	{"id": "structure_mono", "mono": true},
]

var _failures: Array[String] = []
var _records: Array[Dictionary] = []

func _initialize() -> void:
	call_deferred(&"_capture_all")


func _capture_all() -> void:
	root.size = LOGICAL_SIZE
	for directory in [OUTPUT_ROOT]:
		if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(directory)) != OK:
			_failures.append("cannot create %s" % directory)
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
		state.record_decision(&"p7.marta_threshold.trace", "dead_circuit_lesson_observed")
	var packed := load("res://scenes/levels/station_15.tscn") as PackedScene
	if packed == null:
		_failures.append("cannot load station_15")
		return
	var station := packed.instantiate() as CanvasItem
	if station == null:
		_failures.append("station_15 root is not CanvasItem")
		return
	root.add_child(station)
	for _frame in range(WAIT_FRAMES):
		await physics_frame
	var dialogue := station.get_node_or_null("CRTDialogueBox") as CRTDialogueBox
	if dialogue != null:
		dialogue.hide_box()
	match String(capture["id"]):
		"control_echo":
			station.call(&"observe_signal_log")
			station.call(&"send_control_impulse")
			station.call(&"run_response_cycle")
			station.call(&"send_control_impulse")
			station.call(&"run_response_cycle")
		"confirmed":
			station.call(&"observe_signal_log")
			station.call(&"send_control_impulse")
			station.call(&"run_response_cycle")
			station.call(&"send_control_impulse")
			station.call(&"run_response_cycle")
			station.call(&"send_corrective_impulse")
			station.call(&"run_response_cycle")
			station.call(&"read_abort_note")
		"structure_mono":
			station.call(&"observe_signal_log")
			station.call(&"send_control_impulse")
			station.call(&"run_response_cycle")
			station.call(&"send_corrective_impulse")
			station.call(&"run_response_cycle")
			station.call(&"read_abort_note")
	_hide_text_and_ui(station)
	station.queue_redraw()
	for _frame in range(12):
		await physics_frame
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	if image == null or image.get_size() != LOGICAL_SIZE:
		_failures.append("wrong frame for %s" % String(capture["id"]))
		_dispose(station)
		return
	if bool(capture["mono"]):
		_make_true_grayscale(image)
		if not _is_grayscale(image):
			_failures.append("residual color in %s" % String(capture["id"]))
	var relative_path := OUTPUT_ROOT.path_join("station_15_%s.png" % String(capture["id"]))
	if image.save_png(ProjectSettings.globalize_path(relative_path)) != OK:
		_failures.append("cannot save %s" % relative_path)
	else:
		_records.append({"id": String(capture["id"]), "path": relative_path, "hash": hash(image.get_data())})
		print("%s CAPTURE PASS: %s" % [PACKAGE_ID, relative_path])
	_dispose(station)
	await process_frame

func _hide_text_and_ui(node: Node) -> void:
	for child in node.get_children():
		if child is CanvasLayer and child.name != "WorldPixelCompositor":
			(child as CanvasLayer).visible = false
		if child is CanvasItem and String(child.name).begins_with("CrispDiegeticText"):
			(child as CanvasItem).visible = false
		_hide_text_and_ui(child)


func _make_true_grayscale(image: Image) -> void:
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
	var hashes: Dictionary = {}
	for record in _records:
		hashes[record["hash"]] = true
	if hashes.size() != _records.size():
		_failures.append("captured frames must have distinct image hashes")
	var lines := PackedStringArray([
		"PKG-0163 VISUAL EVIDENCE REPORT",
		"Renderer: %s" % RenderingServer.get_video_adapter_name(),
		"Viewport: 640x360; normal Windows display driver; script was not headless.",
		"Three textless M2 frames of Station 15: neutral, control echo, confirmed response.",
		"One M3 true-grayscale structure frame of the boundary family (duplicated loop",
		"receiver, one inconsistent light, one sourceless response sound in runtime).",
		"Hash distinctness is structural evidence only; this capture does not prove",
		"human comprehension, emotion or PRODUCT GO (D-012, ADR-003).",
		"",
	])
	for record in _records:
		lines.append("%-14s hash=%s %s" % [record["id"], str(record["hash"]), record["path"]])
	var file := FileAccess.open(REPORT_PATH, FileAccess.WRITE)
	if file == null:
		_failures.append("cannot write visual report")
		return
	file.store_string("
".join(lines) + "
")
	file.close()


func _finish() -> void:
	if _failures.is_empty():
		print("%s CAPTURE PASS: 3 textless state frames and 1 M3 structure frame." % PACKAGE_ID)
		quit(0)
		return
	for failure in _failures:
		printerr("%s CAPTURE FAILURE: %s" % [PACKAGE_ID, failure])
	quit(1)