extends SceneTree

## PKG-0105 control renders for Station 36..40 after the Act IIIc Vector-Stage
## route and the single audited R3 rescue-bulkhead mechanism are in place.
## Run this with the normal Windows display driver, never headless:
##
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0105.gd
##
## Frames land in reports/pkg_0105/station_NN.png and are inspected manually.

const ACT_III_C_PATHS: Array[String] = [
	"res://scenes/levels/station_36.tscn",
	"res://scenes/levels/station_37.tscn",
	"res://scenes/levels/station_38.tscn",
	"res://scenes/levels/station_39.tscn",
	"res://scenes/levels/station_40.tscn",
]


func _initialize() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(640, 360)
	var output_dir := ProjectSettings.globalize_path("res://reports/pkg_0105")
	if DirAccess.make_dir_recursive_absolute(output_dir) != OK:
		push_error("PKG-0105 CAPTURE: cannot create output directory")
		quit(1)
		return

	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	for scene_path in ACT_III_C_PATHS:
		var packed := load(scene_path) as PackedScene
		if packed == null:
			push_error("PKG-0105 CAPTURE: cannot load " + scene_path)
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
			push_error("PKG-0105 CAPTURE: cannot save " + output_path)
			quit(1)
			return
		print("PKG-0105 CAPTURE PASS: " + output_path)
		station.queue_free()
		await process_frame

	if state:
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)
	print("PKG-0105 ACT IIIc CAPTURE PASS")
	quit(0)


func _pose_control_state(station: Node2D, station_id: String) -> void:
	# These are control frames for route readability and diegetic state. The
	# dialogue surface is inspected by the automated contract and is suppressed
	# here so it cannot hide the geometry.
	if "dialogue_active" in station:
		station.dialogue_active = false

	match station_id:
		"station_36":
			station.is_weir_inspected = true
			station.is_current_inspected = true
			station.is_ladder_inspected = true
			station.is_tap_inspected = true
			station.is_exit_unlocked = true
		"station_37":
			station.is_oscilloscope_inspected = true
			station.is_patchbay_inspected = true
			station.is_antenna_inspected = true
			station.is_pulpit_inspected = true
			station.is_exit_unlocked = true
		"station_38":
			station.is_calculator_inspected = true
			station.is_accident_field_inspected = true
			station.is_jakub_shadow_inspected = true
			station.is_rescue_tether_anchored = true
			station.is_exit_unlocked = true
			var bulkhead := station.get_node_or_null("Geometry/JakubRescueBulkhead") as AnchorableObject
			if bulkhead:
				bulkhead.set_anchored(true)
		"station_39":
			station.is_config_a_inspected = true
			station.is_config_b_inspected = true
			station.is_reference_core_inspected = true
			station.is_config_c_inspected = true
			station.is_exit_unlocked = true
		"station_40":
			station.is_terminal_inspected = true
			station.is_cost_matrix_inspected = true
			station.is_marta_inspected = true
			station.is_szymon_inspected = true
			station.is_exit_unlocked = true

	station.queue_redraw()
