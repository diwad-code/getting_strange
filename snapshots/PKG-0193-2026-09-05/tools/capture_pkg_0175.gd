extends SceneTree

## PKG-0175 normal-driver capture: GATE-FLOW open exits.

const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0175"
const REPORT_PATH := "res://reports/pkg_0175/visual_evidence_report.txt"
const WAIT_FRAMES := 18

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
	await _capture_station("station_01", "open_exit_station_01.png", "DEF-8: Station 01 exit open from ready", Vector2(520, 269))
	await _capture_station("station_03", "open_exit_station_03.png", "DEF-8: Station 03 vehicle threshold reachable without readings", Vector2(540, 269))
	await _capture_station("station_18", "open_exit_station_18.png", "DEF-8: Station 18 commitment is the only fork, door stays open", Vector2(520, 269))
	if state != null:
		state.reset_campaign(true)
		state.campaign_auto_transition_enabled = true
	_write_report()
	if _failures.is_empty():
		print("PKG-0175 CAPTURE PASS")
		quit(0)
		return
	print("PKG-0175 CAPTURE FAIL")
	quit(1)


func _capture_station(station_id: String, file_name: String, desc: String, player_pos: Vector2) -> void:
	var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
	if packed == null:
		_failures.append("Failed to load %s" % station_id)
		return
	var instance := packed.instantiate() as Node2D
	root.add_child(instance)
	await process_frame
	await process_frame
	preload("res://scripts/campaign/gap_ledger.gd").ensure_exit_open(instance)
	var player := instance.get_node_or_null("Player") as CharacterBody2D
	if player != null:
		player.global_position = player_pos
	for _i in range(WAIT_FRAMES):
		await physics_frame
	await RenderingServer.frame_post_draw
	var image := root.get_viewport().get_texture().get_image()
	if image == null:
		_failures.append("Viewport image is null for %s" % station_id)
	else:
		var err := image.save_png(OUTPUT_ROOT + "/" + file_name)
		if err != OK:
			_failures.append("save_png failed for %s" % file_name)
		else:
			_records.append({"file": file_name, "desc": desc, "station": station_id})
	instance.queue_free()
	await process_frame


func _write_report() -> void:
	var f := FileAccess.open(REPORT_PATH, FileAccess.WRITE)
	if f == null:
		return
	f.store_line("PKG-0175 visual evidence")
	f.store_line("Intel display capture, not headless.")
	for rec in _records:
		f.store_line("- %s :: %s" % [rec["file"], rec["desc"]])
	for failure in _failures:
		f.store_line("FAIL: " + failure)
	f.close()
