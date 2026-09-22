extends SceneTree

## PKG-0174 normal-driver capture: GATE-THRESH families and scaled apertures.

const PACKAGE_ID := "PKG-0174"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0174"
const REPORT_PATH := "res://reports/pkg_0174/visual_evidence_report.txt"
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

	await _capture_station("station_01", "door_station_01.png", "DEF-4/7: technical door aperture at human scale", Vector2(520, 269), &"enter_door")
	await _capture_station("station_03", "vehicle_station_03.png", "DEF-4: Line 4 vehicle threshold", Vector2(540, 269), &"board_vehicle")
	await _capture_station("station_08", "door_station_08.png", "DEF-7: residential door 109x45", Vector2(500, 269), &"enter_door")
	await _capture_station("station_14", "hatch_station_14.png", "DEF-4: hatch family on the dead-circuit station", Vector2(540, 269), &"ladder_dismount")
	await _capture_pose_sheet()

	if state != null:
		state.reset_campaign(true)
		state.campaign_auto_transition_enabled = true

	_write_report()
	_finish()


func _capture_station(station_id: String, file_name: String, desc: String, player_pos: Vector2, pose: StringName) -> void:
	var scene_path := "res://scenes/levels/%s.tscn" % station_id
	var packed := load(scene_path) as PackedScene
	if packed == null:
		_failures.append("Failed to load %s" % scene_path)
		return
	var instance := packed.instantiate() as Node2D
	root.add_child(instance)
	await process_frame
	await process_frame
	if instance.get("is_exit_unlocked") != null:
		instance.set("is_exit_unlocked", true)
	var zone := instance.get_node_or_null("Threshold")
	if zone != null:
		zone.set("is_open", true)
	var player := instance.get_node_or_null("Player") as CharacterBody2D
	if player != null:
		player.global_position = player_pos
		var rig := player.get_node_or_null("LenaVisualRig")
		if rig != null and rig.has_method("debug_override_state"):
			rig.call("debug_override_state", pose)
	for _i in range(WAIT_FRAMES):
		await physics_frame
	await RenderingServer.frame_post_draw
	var image := root.get_viewport().get_texture().get_image()
	if image == null:
		_failures.append("Viewport image is null for %s" % station_id)
	else:
		var out_path := OUTPUT_ROOT + "/" + file_name
		var err := image.save_png(out_path)
		if err != OK:
			_failures.append("save_png failed for %s" % out_path)
		else:
			_records.append({"file": file_name, "desc": desc, "station": station_id})
	instance.queue_free()
	await process_frame


func _capture_pose_sheet() -> void:
	var packed := load("res://scenes/player/prototype_player.tscn") as PackedScene
	if packed == null:
		_failures.append("player scene missing for pose sheet")
		return
	var host := Node2D.new()
	root.add_child(host)
	var poses: Array[StringName] = [&"enter_door", &"board_vehicle", &"idle"]
	var x := 80.0
	for pose in poses:
		var player := packed.instantiate() as CharacterBody2D
		player.position = Vector2(x, 280.0)
		host.add_child(player)
		var rig := player.get_node_or_null("LenaVisualRig")
		if rig != null and rig.has_method("debug_override_state"):
			rig.call("debug_override_state", pose)
		x += 160.0
	for _i in range(WAIT_FRAMES):
		await physics_frame
	await RenderingServer.frame_post_draw
	var image := root.get_viewport().get_texture().get_image()
	if image != null:
		image.save_png(OUTPUT_ROOT + "/threshold_pose_sheet.png")
		_records.append({"file": "threshold_pose_sheet.png", "desc": "enter_door / board_vehicle / idle", "station": "rig"})
	host.queue_free()
	await process_frame


func _write_report() -> void:
	var f := FileAccess.open(REPORT_PATH, FileAccess.WRITE)
	if f == null:
		return
	f.store_line("PKG-0174 visual evidence")
	f.store_line("Intel display capture, not headless.")
	for rec in _records:
		f.store_line("- %s :: %s" % [rec["file"], rec["desc"]])
	for failure in _failures:
		f.store_line("FAIL: " + failure)
	f.close()


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0174 CAPTURE PASS")
		quit(0)
		return
	print("PKG-0174 CAPTURE FAIL")
	for failure in _failures:
		print("  - " + failure)
	quit(1)
