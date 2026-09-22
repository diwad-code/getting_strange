extends SceneTree

## PKG-0103 control renders for Station 26..30 after the Act III Vector-Stage
## route and the two auditable physical mechanisms are in place. Run this with
## the normal Windows display driver, never headless:
##
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0103.gd
##
## Frames land in reports/pkg_0103/station_NN.png and are inspected manually.

const ACT_III_PATHS: Array[String] = [
	"res://scenes/levels/station_26.tscn",
	"res://scenes/levels/station_27.tscn",
	"res://scenes/levels/station_28.tscn",
	"res://scenes/levels/station_29.tscn",
	"res://scenes/levels/station_30.tscn",
]


func _initialize() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(640, 360)
	var output_dir := ProjectSettings.globalize_path("res://reports/pkg_0103")
	if DirAccess.make_dir_recursive_absolute(output_dir) != OK:
		push_error("PKG-0103 CAPTURE: cannot create output directory")
		quit(1)
		return

	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	for scene_path in ACT_III_PATHS:
		var packed := load(scene_path) as PackedScene
		if packed == null:
			push_error("PKG-0103 CAPTURE: cannot load " + scene_path)
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
			push_error("PKG-0103 CAPTURE: cannot save " + output_path)
			quit(1)
			return
		print("PKG-0103 CAPTURE PASS: " + output_path)
		station.queue_free()
		await process_frame

	if state:
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)
	print("PKG-0103 ACT III CAPTURE PASS")
	quit(0)


func _pose_control_state(station: Node2D, station_id: String) -> void:
	# These are control frames for route readability and diegetic state. The
	# dialogue surface is inspected by the automated contract and is suppressed
	# here so it cannot hide the geometry.
	if "dialogue_active" in station:
		station.dialogue_active = false

	match station_id:
		"station_26":
			station.current_room_state = Station26.RoomState.SEDATION
			station.partition_cycle_time = 2.0
			station._update_partition_cycle()
			station.is_console_inspected = true
			station.is_designator_inspected = true
			station.is_motivation_anchored = true
			station.is_exit_unlocked = true
		"station_27":
			station.is_jakub_interacted = true
			station.is_badge_inspected = true
			station.is_monitor_inspected = true
			station.is_console_inspected = true
			station.is_exit_unlocked = true
		"station_28":
			station.is_console_interacted = true
			station.is_window_inspected = true
			station.is_paradox_inspected = true
			station.is_intercom_inspected = true
			station.is_exit_unlocked = true
		"station_29":
			station.is_tracks_inspected = true
			station.is_neon_inspected = true
			station.is_well_inspected = true
			station.is_beacon_inspected = true
			station.is_exit_unlocked = true
		"station_30":
			station.is_board_inspected = true
			station.is_transformer_inspected = true
			station.is_breaker_thrown = true
			station.is_schematic_inspected = true
			station.is_exit_unlocked = true
			station._exit_open_progress = 1.0
			if station.witness_relay:
				station.witness_relay.set_anchored(false)
				station.witness_relay.apply_reality_shift(AnchorableObject.RealityState.STATE_B, false)
			station.witness_relay_detail_faded = true

	station.queue_redraw()
