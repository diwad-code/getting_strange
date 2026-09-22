extends SceneTree

## PKG-0101 control renders for Station 16..20 after the Act IIb visibility
## pass and diegetic obstacle conversion. Run with the normal Windows display
## driver, never with --headless, so the Vector-Stage layer is composited:
##
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0101.gd
##
## Frames land in reports/pkg_0101/station_NN.png and are inspected manually.

const ACT_IIB_PATHS := [
	"res://scenes/levels/station_16.tscn",
	"res://scenes/levels/station_17.tscn",
	"res://scenes/levels/station_18.tscn",
	"res://scenes/levels/station_19.tscn",
	"res://scenes/levels/station_20.tscn",
]


func _initialize() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var output_dir := ProjectSettings.globalize_path("res://reports/pkg_0101")
	if DirAccess.make_dir_recursive_absolute(output_dir) != OK:
		push_error("PKG-0101 CAPTURE: cannot create output directory")
		quit(1)
		return

	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.campaign_auto_transition_enabled = false

	for scene_path in ACT_IIB_PATHS:
		var packed := load(scene_path) as PackedScene
		if packed == null:
			push_error("PKG-0101 CAPTURE: cannot load " + scene_path)
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
		for _frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var image := root.get_texture().get_image()
		var output_path := output_dir.path_join(scene_path.get_file().get_basename() + ".png")
		if image == null or image.save_png(output_path) != OK:
			push_error("PKG-0101 CAPTURE: cannot save " + output_path)
			quit(1)
			return
		print("PKG-0101 CAPTURE PASS: " + output_path)
		station.queue_free()
		await process_frame

	print("PKG-0101 ACT IIb CAPTURE PASS")
	quit(0)


func _pose_control_state(station: Node2D, station_id: String) -> void:
	# Dialogue is inspected by its own gates; these frames are for route and
	# diegetic state, so active subtitle plates are suppressed.
	if "dialogue_active" in station:
		station.dialogue_active = false

	match station_id:
		"station_16":
			station.is_cup_inspected = true
			station.is_dossier_reviewed = true
			station.is_ring_chosen = true
			station.ring_disposition = "leave"
			station.is_balcony_unlocked = true
		"station_17":
			station.pneumatic_cycle_time = 1.5
			station._update_pneumatic_cycle()
			station.is_office_door_unlocked = true
		"station_18":
			station.is_galvanometer_triggered = true
			station.is_strain_detected = true
			station._strain_level = 0.85
			station.is_airlock_unlocked = true
		"station_19":
			station.is_table_approached = true
			station.is_map_left_inspected = true
			station.is_map_right_inspected = true
			station.is_ledger_inspected = true
			station.is_exit_unlocked = true
			var model_table := station.get_node_or_null("Geometry/Line4ModelTable") as AnchorableObject
			if model_table:
				model_table.set_anchored(true)
		"station_20":
			station.is_szymon_approached = true
			station.is_drawing_inspected = true
			station.is_report_inspected = true
			station.is_magnifier_inspected = true
			station.is_door_shifted = true
			station._door_shift_offset = 14.0
			station.choose_drawing_disposition(Station20.DrawingChoice.ANCHOR_DRAWING)
			station.is_exit_unlocked = true

	station.queue_redraw()
