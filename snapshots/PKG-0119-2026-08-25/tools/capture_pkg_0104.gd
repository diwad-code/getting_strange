extends SceneTree

## PKG-0104 control renders for Station 31..35 after the Act IIIb Vector-Stage
## route and the two auditable physical mechanisms are in place. Run this with
## the normal Windows display driver, never headless:
##
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0104.gd
##
## Frames land in reports/pkg_0104/station_NN.png and are inspected manually.

const ACT_III_B_PATHS: Array[String] = [
	"res://scenes/levels/station_31.tscn",
	"res://scenes/levels/station_32.tscn",
	"res://scenes/levels/station_33.tscn",
	"res://scenes/levels/station_34.tscn",
	"res://scenes/levels/station_35.tscn",
]


func _initialize() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(640, 360)
	var output_dir := ProjectSettings.globalize_path("res://reports/pkg_0104")
	if DirAccess.make_dir_recursive_absolute(output_dir) != OK:
		push_error("PKG-0104 CAPTURE: cannot create output directory")
		quit(1)
		return

	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	for scene_path in ACT_III_B_PATHS:
		var packed := load(scene_path) as PackedScene
		if packed == null:
			push_error("PKG-0104 CAPTURE: cannot load " + scene_path)
			quit(1)
			return
		var station := packed.instantiate() as Node2D
		root.add_child(station)
		for _frame in range(10):
			await process_frame

		var dialogue := station.get_node_or_null("CRTDialogueBox") as CanvasLayer
		if dialogue:
			dialogue.hide()
		_pose_control_state(station, scene_path.get_file().get_basename())
		for _frame in range(14):
			await process_frame
		await RenderingServer.frame_post_draw

		var image := root.get_texture().get_image()
		var output_path := output_dir.path_join(scene_path.get_file().get_basename() + ".png")
		if image == null or image.save_png(output_path) != OK:
			push_error("PKG-0104 CAPTURE: cannot save " + output_path)
			quit(1)
			return
		print("PKG-0104 CAPTURE PASS: " + output_path)
		station.queue_free()
		await process_frame

	if state:
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)
	print("PKG-0104 ACT IIIb CAPTURE PASS")
	quit(0)


func _pose_control_state(station: Node2D, station_id: String) -> void:
	# These are control frames for route readability and diegetic state. The
	# dialogue surface is inspected by the automated contract and is suppressed
	# here so it cannot hide the geometry.
	if "dialogue_active" in station:
		station.dialogue_active = false

	match station_id:
		"station_31":
			station.is_chairs_inspected = true
			station.is_holoterminal_inspected = true
			station.is_twelfth_chair_inspected = true
			station.is_ledger_inspected = true
			station.is_exit_unlocked = true
		"station_32":
			station.is_steamed_pane_inspected = true
			station.is_cracked_pane_inspected = true
			station.is_trace_etched = true
			station.is_polished_pane_inspected = true
			station.is_exit_unlocked = true
			if station.observed_glass:
				station.observed_glass.set_anchored(true)
		"station_33":
			station.is_ladder_inspected = true
			station.is_gauge_inspected = true
			station.is_cable_trunk_inspected = true
			station.is_work_light_inspected = true
			station.is_exit_unlocked = true
			if station.witness_frame:
				station.witness_frame.set_anchored(true)
		"station_34":
			station.is_reactor_inspected = true
			station.is_desk_inspected = true
			station.is_thermal_inspected = true
			station.is_probe_inspected = true
			station.is_exit_unlocked = true
		"station_35":
			station.is_pool_inspected = true
			station.is_valve_inspected = true
			station.is_chemical_inspected = true
			station.is_monitor_inspected = true
			station.is_exit_unlocked = true

	station.queue_redraw()
