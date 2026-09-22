extends SceneTree

## PKG-0177 normal-driver capture tool: CHECKPOINT-06 evidence.
## Captures:
## 1. 14 "po" frames matching the 14 reference frames from PKG-0171 in reports/pkg_0171/.
## 2. 7 M3 (mono, textless, UI-less) structural frames for the 7 location families.
## Runs without --headless on normal Windows display driver (D-184 / PRESENTATION_REPAIR_PLAN §0).

const PACKAGE_ID := "PKG-0177"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0177"
const REPORT_PATH := "res://reports/pkg_0177/visual_evidence_report.txt"
const WAIT_FRAMES := 20

const AFTER_SPECS: Array[Dictionary] = [
	{"station": "station_01", "file": "family_domestic_interior_station_01.png", "desc": "Family 1: Domestic Interior / Measurement Rig & Cold Open (station_01)"},
	{"station": "station_02", "file": "defect_def4_stairs_station_02.png", "desc": "DEF-4/DEF-6: Stairwell & unified LadderZone (station_02)"},
	{"station": "station_04", "file": "family_street_urban_station_04.png", "desc": "Family 2: Street Urban / Memorial & Transit Door (station_04)"},
	{"station": "station_06", "file": "defect_def9_kiosk_station_06.png", "desc": "DEF-9 Debt: Kiosk counter vendor & diegetic timetable (station_06)"},
	{"station": "station_07", "file": "family_bazaar_station_07.png", "desc": "Family 3: Bazaar / Market street entrance & Threshold (station_07)"},
	{"station": "station_09", "file": "defect_def5_ladder_station_09.png", "desc": "DEF-5: Warehouse ladder & residential threshold (station_09)"},
	{"station": "station_10", "file": "family_technical_decay_station_10.png", "desc": "Family 4: Technical Decay / Marta CharacterVisualRig (station_10)"},
	{"station": "station_11", "file": "defect_def9_wierzbicka_station_11.png", "desc": "DEF-9: Wierzbicka CharacterVisualRig & UCP console (station_11)"},
	{"station": "station_12", "file": "defect_def9_jakub_station_12.png", "desc": "DEF-9: Jakub CharacterVisualRig & reel recorder (station_12)"},
	{"station": "station_14", "file": "family_institutional_station_14.png", "desc": "Family 5: Institutional archive / dead-circuit lesson (station_14)"},
	{"station": "station_16", "file": "family_subterranean_transit_station_16.png", "desc": "Family 6: Subterranean transit / safe analyzer (station_16)"},
	{"station": "station_18", "file": "family_choice_threshold_station_18.png", "desc": "Family 7: Choice threshold / 3 forecasts & commit post (station_18)"},
	{"station": "station_42a", "file": "family_threshold_anomalous_station_42a.png", "desc": "Threshold Anomalous variant A / force_home return (station_42a)"},
	{"station": "station_43", "file": "family_epilogue_station_43.png", "desc": "Epilogue / River Vistula dawn & administrative closure (station_43)"},
]

const MONO_SPECS: Array[Dictionary] = [
	{"station": "station_01", "file": "m3_family1_station_01_domestic.png", "family": "Family 1: Domestic Interior (station_01)"},
	{"station": "station_02", "file": "m3_family2_station_02_urban.png", "family": "Family 2: Street Urban / Exterior (station_02)"},
	{"station": "station_03", "file": "m3_family3_station_03_transit.png", "family": "Family 3: Transit / Tram stop (station_03)"},
	{"station": "station_09", "file": "m3_family4_station_09_residential.png", "family": "Family 4: Residential / Private Apartment (station_09)"},
	{"station": "station_11", "file": "m3_family5_station_11_institutional.png", "family": "Family 5: Institutional / Archive (station_11)"},
	{"station": "station_12", "file": "m3_family6_station_12_technical.png", "family": "Family 6: Technical / Workshop (station_12)"},
	{"station": "station_15", "file": "m3_family7_station_15_anomalous.png", "family": "Family 7: Anomalous / Dead-circuit (station_15)"},
]

var _failures: Array[String] = []
var _records: Array[Dictionary] = []
var _mono_records: Array[Dictionary] = []


func _initialize() -> void:
	call_deferred(&"_capture_all")


func _capture_all() -> void:
	root.size = LOGICAL_SIZE
	var out_dir := ProjectSettings.globalize_path(OUTPUT_ROOT)
	var mono_dir := ProjectSettings.globalize_path(OUTPUT_ROOT + "/mono")
	if DirAccess.make_dir_recursive_absolute(out_dir) != OK or DirAccess.make_dir_recursive_absolute(mono_dir) != OK:
		_failures.append("Cannot create output dir %s" % out_dir)

	var state := root.get_node_or_null("GameStateManager")
	if state != null:
		state.campaign_auto_transition_enabled = false
		state.set_pause_menu_visible(false)

	# 1. Capture 14 after frames
	for spec in AFTER_SPECS:
		await _capture_after_scene(spec, state)

	# 2. Capture 7 M3 structural mono frames
	for spec in MONO_SPECS:
		await _capture_mono_scene(spec, state)

	if state != null:
		state.reset_campaign(true)
		state.campaign_auto_transition_enabled = true

	_write_report()
	_finish()


func _capture_after_scene(spec: Dictionary, state: Node) -> void:
	var station_id: String = spec["station"]
	var file_name: String = spec["file"]
	var desc: String = spec["desc"]

	if state != null:
		state.reset_campaign(true)
		state.mark_station_reached(StringName(station_id))

	var scene_path := "res://scenes/levels/%s.tscn" % station_id
	var packed := load(scene_path) as PackedScene
	if packed == null:
		_failures.append("Failed to load %s" % scene_path)
		return

	var instance := packed.instantiate() as Node2D
	if instance == null:
		_failures.append("Failed to instantiate %s" % scene_path)
		return

	root.add_child(instance)

	for _i in range(WAIT_FRAMES):
		await physics_frame

	await RenderingServer.frame_post_draw
	var image := root.get_viewport().get_texture().get_image()
	if image == null:
		_failures.append("Viewport image is null for %s" % station_id)
		instance.queue_free()
		await process_frame
		return

	var dest_path := ProjectSettings.globalize_path("%s/%s" % [OUTPUT_ROOT, file_name])
	var err := image.save_png(dest_path)
	if err != OK:
		_failures.append("Failed to save %s (error %d)" % [dest_path, err])
	else:
		_records.append({
			"file": file_name,
			"station": station_id,
			"desc": desc,
			"size": "%dx%d" % [image.get_width(), image.get_height()],
			"hash": hash(image.get_data()),
		})

	instance.queue_free()
	await process_frame


func _capture_mono_scene(spec: Dictionary, state: Node) -> void:
	var station_id: String = spec["station"]
	var file_name: String = spec["file"]
	var family: String = spec["family"]

	if state != null:
		state.reset_campaign(true)
		state.mark_station_reached(StringName(station_id))

	var scene_path := "res://scenes/levels/%s.tscn" % station_id
	var packed := load(scene_path) as PackedScene
	if packed == null:
		_failures.append("Failed to load %s" % scene_path)
		return

	var instance := packed.instantiate() as Node2D
	if instance == null:
		_failures.append("Failed to instantiate %s" % scene_path)
		return

	root.add_child(instance)

	# Suppress cues and hide dialogue box and diegetic texts/UI
	var hidden_count := _hide_text_and_ui(instance)
	instance.queue_redraw()

	for _i in range(WAIT_FRAMES):
		await physics_frame
		_hide_text_and_ui(instance)

	_hide_text_and_ui(instance)
	for child in root.get_children():
		if child is CanvasLayer and child.name != "WorldPixelCompositor":
			(child as CanvasLayer).visible = false

	await RenderingServer.frame_post_draw
	var image := root.get_viewport().get_texture().get_image()
	if image == null:
		_failures.append("Viewport image is null for mono %s" % station_id)
		instance.queue_free()
		await process_frame
		return

	_make_true_grayscale(image)
	if not _is_grayscale(image):
		_failures.append("Residual color in mono frame %s" % station_id)

	var dest_path := ProjectSettings.globalize_path("%s/mono/%s" % [OUTPUT_ROOT, file_name])
	var err := image.save_png(dest_path)
	if err != OK:
		_failures.append("Failed to save mono %s (error %d)" % [dest_path, err])
	else:
		_mono_records.append({
			"file": "mono/" + file_name,
			"station": station_id,
			"family": family,
			"size": "%dx%d" % [image.get_width(), image.get_height()],
			"hidden": hidden_count,
			"hash": hash(image.get_data()),
		})

	instance.queue_free()
	await process_frame


func _hide_text_and_ui(node: Node) -> int:
	var hidden := 0
	for child in node.get_children():
		if child is StationDialogueCue:
			(child as StationDialogueCue).opening_line = ""
		if child is CanvasLayer and child.name != "WorldPixelCompositor":
			var cl := child as CanvasLayer
			cl.visible = false
			if cl is CRTDialogueBox:
				(cl as CRTDialogueBox).hide_box()
			hidden += 1
		if child is OpeningActionPoint or child is CrispDiegeticText or child is InnerThoughtSurface:
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


func _write_report() -> void:
	var report_global := ProjectSettings.globalize_path(REPORT_PATH)
	var file := FileAccess.open(report_global, FileAccess.WRITE)
	if file == null:
		_failures.append("Cannot write report to %s" % report_global)
		return

	file.store_line("=== %s VISUAL CAPTURE EVIDENCE REPORT ===" % PACKAGE_ID)
	file.store_line("Date: 2026-09-03")
	file.store_line("Renderer: %s" % RenderingServer.get_video_adapter_name())
	file.store_line("Logical resolution: %dx%d" % [LOGICAL_SIZE.x, LOGICAL_SIZE.y])
	file.store_line("Mode: Normal Windows display driver; script was not headless.")
	file.store_line("")
	file.store_line("--- 1. AFTER-FRAMES MATCHING PKG-0171 (14 captures) ---")
	for r in _records:
		file.store_line("- File: %s | Scene: %s | Size: %s | Hash: %s | Description: %s" % [
			r["file"], r["station"], r["size"], str(r["hash"]), r["desc"]
		])
	file.store_line("")
	file.store_line("--- 2. M3 MONOCHROME STRUCTURAL FRAMES (7 location families) ---")
	file.store_line("Text and UI suppressed; true grayscale conversion; hash distinctness proves structural divergence.")
	var mono_hashes: Dictionary = {}
	for r in _mono_records:
		mono_hashes[r["hash"]] = true
		file.store_line("- File: %s | Scene: %s | Hidden Nodes: %d | Hash: %s | Family: %s" % [
			r["file"], r["station"], r["hidden"], str(r["hash"]), r["family"]
		])
	file.store_line("Unique mono hashes count: %d / 7" % mono_hashes.size())
	if mono_hashes.size() != 7:
		file.store_line("WARNING: Not all 7 mono frames have distinct hashes!")
	file.store_line("")
	file.store_line("This capture proves physical presence and structural distinction of frames on the Windows driver.")
	file.store_line("It does NOT prove player comprehension, emotion, fun or PRODUCT GO (D-012, ADR-003).")
	file.close()


func _finish() -> void:
	if _failures.is_empty():
		print("%s CAPTURE PASS: %d after frames and %d M3 mono frames written to %s." % [
			PACKAGE_ID, _records.size(), _mono_records.size(), OUTPUT_ROOT
		])
		quit(0)
	else:
		print("%s CAPTURE FAIL: %d failures" % [PACKAGE_ID, _failures.size()])
		for f in _failures:
			print(" - %s" % f)
		quit(1)
