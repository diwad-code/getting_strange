extends SceneTree

## PKG-0107 control renders for the four finale Vector-Stage profiles.
## Run with the normal Windows display driver, never headless:
##
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0107.gd
##
## Frames are technical render evidence, not a playtest or audience finding.

const CAPTURE_CASES: Array[Dictionary] = [
	{"path": "res://scenes/levels/station_42a.tscn", "output": "station_42a.png", "kind": "42a"},
	{"path": "res://scenes/levels/station_42b.tscn", "output": "station_42b.png", "kind": "42b"},
	{"path": "res://scenes/levels/station_42c.tscn", "output": "station_42c.png", "kind": "42c"},
	{"path": "res://scenes/levels/station_43.tscn", "output": "station_43.png", "kind": "43"},
]


func _initialize() -> void:
	call_deferred("_capture_all")


func _capture_all() -> void:
	root.size = Vector2i(640, 360)
	var output_dir := ProjectSettings.globalize_path("res://reports/pkg_0107")
	if DirAccess.make_dir_recursive_absolute(output_dir) != OK:
		push_error("PKG-0107 CAPTURE: cannot create output directory")
		quit(1)
		return

	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	for case_data in CAPTURE_CASES:
		var packed := load(String(case_data["path"])) as PackedScene
		if packed == null:
			push_error("PKG-0107 CAPTURE: cannot load " + String(case_data["path"]))
			quit(1)
			return
		var station := packed.instantiate() as Node2D
		if station == null:
			push_error("PKG-0107 CAPTURE: root is not Node2D " + String(case_data["path"]))
			quit(1)
			return
		root.add_child(station)
		for _frame in range(12):
			await process_frame

		_apply_control_pose(station, String(case_data["kind"]))
		var dialogue := station.get_node_or_null("CRTDialogueBox") as CanvasLayer
		if dialogue:
			dialogue.hide()
		station.queue_redraw()
		for _frame in range(14):
			await process_frame
		await RenderingServer.frame_post_draw

		var image := root.get_texture().get_image()
		var output_path := output_dir.path_join(String(case_data["output"]))
		if image == null or image.save_png(output_path) != OK:
			push_error("PKG-0107 CAPTURE: cannot save " + output_path)
			station.queue_free()
			await process_frame
			quit(1)
			return
		print("PKG-0107 CAPTURE PASS: " + output_path)

		station.queue_free()
		await process_frame

	if state:
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)
	print("PKG-0107 CAPTURE PASS: four finale frames")
	quit(0)


func _apply_control_pose(station: Node2D, kind: String) -> void:
	station.set("dialogue_active", false)
	station.set("is_exit_unlocked", true)
	match kind:
		"42a":
			station.set("is_cups_inspected", true)
		"42b":
			station.set("is_doorstep_inspected", true)
		"42c":
			station.set("is_tram_inspected", true)
		"43":
			station.set("is_notice_inspected", true)
			station.set("is_credits_inspected", true)
			station.set("is_blackout_inspected", true)
