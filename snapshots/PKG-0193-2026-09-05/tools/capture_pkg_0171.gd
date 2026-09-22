extends SceneTree

## PKG-0171 normal-driver capture tool.
## Captures reference frames for 7 location families and baseline defect states
## across campaign addresses into reports/pkg_0171/.

const PACKAGE_ID := "PKG-0171"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0171"
const REPORT_PATH := "res://reports/pkg_0171/visual_evidence_report.txt"
const WAIT_FRAMES := 15

const CAPTURE_SPECS: Array[Dictionary] = [
	{"station": "station_01", "file": "family_domestic_interior_station_01.png", "desc": "Family 1: Domestic Interior (station_01)"},
	{"station": "station_02", "file": "defect_def4_stairs_station_02.png", "desc": "DEF-4: Stairwell geometry (station_02)"},
	{"station": "station_04", "file": "family_street_urban_station_04.png", "desc": "Family 2: Street Urban (station_04)"},
	{"station": "station_06", "file": "defect_def9_kiosk_station_06.png", "desc": "DEF-9 Debt: Kiosk counter vendor (station_06)"},
	{"station": "station_07", "file": "family_bazaar_station_07.png", "desc": "Family 3: Bazaar (station_07)"},
	{"station": "station_09", "file": "defect_def5_ladder_station_09.png", "desc": "DEF-5: Warehouse ladder (station_09)"},
	{"station": "station_10", "file": "family_technical_decay_station_10.png", "desc": "Family 4: Technical Decay / Marta placement (station_10)"},
	{"station": "station_11", "file": "defect_def9_wierzbicka_station_11.png", "desc": "DEF-9: Wierzbicka placement point (station_11)"},
	{"station": "station_12", "file": "defect_def9_jakub_station_12.png", "desc": "DEF-9: Jakub placement point (station_12)"},
	{"station": "station_14", "file": "family_institutional_station_14.png", "desc": "Family 5: Institutional archive / lift (station_14)"},
	{"station": "station_16", "file": "family_subterranean_transit_station_16.png", "desc": "Family 6: Subterranean transit (station_16)"},
	{"station": "station_18", "file": "family_choice_threshold_station_18.png", "desc": "Family 7: Choice threshold (station_18)"},
	{"station": "station_42a", "file": "family_threshold_anomalous_station_42a.png", "desc": "Threshold Anomalous variant A (station_42a)"},
	{"station": "station_43", "file": "family_epilogue_station_43.png", "desc": "Epilogue / River Vistula dawn (station_43)"}
]

var _failures: Array[String] = []
var _records: Array[Dictionary] = []


func _initialize() -> void:
	call_deferred(&"_capture_all")


func _capture_all() -> void:
	root.size = LOGICAL_SIZE
	var out_dir := ProjectSettings.globalize_path(OUTPUT_ROOT)
	if DirAccess.make_dir_recursive_absolute(out_dir) != OK:
		_failures.append("Cannot create output dir %s" % out_dir)

	var state := root.get_node_or_null("GameStateManager")
	if state != null:
		state.campaign_auto_transition_enabled = false
		state.set_pause_menu_visible(false)

	for spec in CAPTURE_SPECS:
		await _capture_single_scene(spec, state)

	if state != null:
		state.reset_campaign(true)
		state.campaign_auto_transition_enabled = true

	_write_report()
	_finish()


func _capture_single_scene(spec: Dictionary, state: Node) -> void:
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
			"size": "%dx%d" % [image.get_width(), image.get_height()]
		})

	instance.queue_free()
	await process_frame


func _write_report() -> void:
	var report_global := ProjectSettings.globalize_path(REPORT_PATH)
	var file := FileAccess.open(report_global, FileAccess.WRITE)
	if file == null:
		_failures.append("Cannot write report to %s" % report_global)
		return

	file.store_line("=== %s VISUAL CAPTURE EVIDENCE REPORT ===" % PACKAGE_ID)
	file.store_line("Date: 2026-09-02")
	file.store_line("Logical resolution: %dx%d" % [LOGICAL_SIZE.x, LOGICAL_SIZE.y])
	file.store_line("Total captures: %d" % _records.size())
	file.store_line("")
	for r in _records:
		file.store_line("- File: %s | Scene: %s | Size: %s | Description: %s" % [r["file"], r["station"], r["size"], r["desc"]])
	file.close()


func _finish() -> void:
	if _failures.is_empty():
		print("%s CAPTURE PASS: %d reference frames written to %s." % [PACKAGE_ID, _records.size(), OUTPUT_ROOT])
		quit(0)
	else:
		print("%s CAPTURE FAIL: %d failures" % [PACKAGE_ID, _failures.size()])
		for f in _failures:
			print(" - %s" % f)
		quit(1)
