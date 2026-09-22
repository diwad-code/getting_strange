extends SceneTree

## PKG-0173 normal-driver capture tool.
## GATE-ANIM frames: Station 08 stairs, Station 02 ladder, and the new
## traversal poses on the 64x104 pivot.

const PACKAGE_ID := "PKG-0173"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0173"
const REPORT_PATH := "res://reports/pkg_0173/visual_evidence_report.txt"
const WAIT_FRAMES := 18
const NEW_STATES: Array[StringName] = [
	&"step_up", &"step_down", &"climb_back", &"ladder_mount", &"ladder_dismount",
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

	await _capture_station("station_08", "stairs_station_08.png", "DEF-5: Station 08 stair geometry with Lena on the riser", Vector2(250, 263))
	await _capture_station("station_02", "ladder_station_02.png", "DEF-6: Station 02 ServiceLadder as the only drawn ladder", Vector2(570, 250))
	await _capture_pose_sheet()

	if state != null:
		state.reset_campaign(true)
		state.campaign_auto_transition_enabled = true

	_write_report()
	_finish()


func _capture_station(station_id: String, file_name: String, desc: String, player_pos: Vector2) -> void:
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
	var player := instance.get_node_or_null("Player") as CharacterBody2D
	if player != null:
		player.global_position = player_pos
		if station_id == "station_02":
			var ladder := instance.get_node_or_null("ServiceLadder")
			if ladder != null and player.has_method("attach_to_ladder"):
				player.call("attach_to_ladder", ladder)
				player.set("is_climbing", true)
				player.velocity = Vector2(0.0, -40.0)
			var rig := player.get_node_or_null("LenaVisualRig")
			if rig != null and rig.has_method("debug_override_state"):
				rig.call("debug_override_state", &"climb_back")
		elif station_id == "station_08":
			var rig := player.get_node_or_null("LenaVisualRig")
			if rig != null and rig.has_method("debug_override_state"):
				rig.call("debug_override_state", &"step_up")
	for _i in range(WAIT_FRAMES):
		await physics_frame
	await RenderingServer.frame_post_draw
	var image := root.get_viewport().get_texture().get_image()
	if image == null:
		_failures.append("Viewport image is null for %s" % station_id)
	else:
		var out_path := "%s/%s" % [OUTPUT_ROOT, file_name]
		var err := image.save_png(out_path)
		if err != OK:
			_failures.append("Failed to save %s" % out_path)
		else:
			_records.append({"file": file_name, "desc": desc, "path": out_path})
	instance.queue_free()
	await process_frame


func _capture_pose_sheet() -> void:
	var rig_script := load("res://scripts/player/lena_visual_rig.gd") as GDScript
	var cols := 5
	var cell := Vector2i(80, 128)
	var sheet := Image.create(cols * cell.x, cell.y, false, Image.FORMAT_RGBA8)
	sheet.fill(Color(0.09, 0.10, 0.12, 1.0))
	for i in NEW_STATES.size():
		var holder := Node2D.new()
		root.add_child(holder)
		var rig = rig_script.new()
		holder.add_child(rig)
		rig.debug_override_state(NEW_STATES[i])
		for _f in 4:
			await process_frame
		var sub := SubViewport.new()
		sub.size = cell
		sub.transparent_bg = false
		sub.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		root.add_child(sub)
		holder.reparent(sub)
		holder.position = Vector2(cell.x * 0.5, 96.0)
		for _f in 4:
			await process_frame
		await RenderingServer.frame_post_draw
		var img := sub.get_texture().get_image()
		if img:
			img.convert(Image.FORMAT_RGBA8)
			sheet.blit_rect(img, Rect2i(Vector2i.ZERO, cell), Vector2i(i * cell.x, 0))
		sub.queue_free()
		await process_frame
	var out_path := "%s/traversal_pose_sheet.png" % OUTPUT_ROOT
	sheet.save_png(out_path)
	_records.append({"file": "traversal_pose_sheet.png", "desc": "DEF-5/DEF-6 pose sheet", "path": out_path})


func _write_report() -> void:
	var lines: PackedStringArray = PackedStringArray()
	lines.append("PKG-0173 visual evidence")
	lines.append("GATE-ANIM technical frames. Not a product GO.")
	for rec in _records:
		lines.append("- %s — %s" % [rec["file"], rec["desc"]])
	if not _failures.is_empty():
		lines.append("FAILURES:")
		for failure in _failures:
			lines.append("- %s" % failure)
	var file := FileAccess.open(REPORT_PATH, FileAccess.WRITE)
	if file:
		file.store_string("\n".join(lines) + "\n")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0173 CAPTURE DONE")
		quit(0)
	else:
		print("PKG-0173 CAPTURE FAIL")
		for failure in _failures:
			print(" - %s" % failure)
		quit(1)
