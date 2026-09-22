extends SceneTree

## PKG-0102 control renders for Station 21..25 after the Act IIc route and R2
## threshold pass. Run with the normal Windows display driver, never headless:
##
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0102.gd
##
## Frames land in reports/pkg_0102/station_NN.png and are inspected manually.

const ACT_IIC_PATHS: Array[String] = [
	"res://scenes/levels/station_21.tscn",
	"res://scenes/levels/station_22.tscn",
	"res://scenes/levels/station_23.tscn",
	"res://scenes/levels/station_24.tscn",
	"res://scenes/levels/station_25.tscn",
]


func _initialize() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var output_dir := ProjectSettings.globalize_path("res://reports/pkg_0102")
	if DirAccess.make_dir_recursive_absolute(output_dir) != OK:
		push_error("PKG-0102 CAPTURE: cannot create output directory")
		quit(1)
		return

	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	for scene_path in ACT_IIC_PATHS:
		var packed := load(scene_path) as PackedScene
		if packed == null:
			push_error("PKG-0102 CAPTURE: cannot load " + scene_path)
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
		for _frame in range(12):
			await process_frame
		await RenderingServer.frame_post_draw

		var image := root.get_texture().get_image()
		var output_path := output_dir.path_join(scene_path.get_file().get_basename() + ".png")
		if image == null or image.save_png(output_path) != OK:
			push_error("PKG-0102 CAPTURE: cannot save " + output_path)
			quit(1)
			return
		print("PKG-0102 CAPTURE PASS: " + output_path)
		station.queue_free()
		await process_frame

	if state:
		state.reset_campaign(true)
	print("PKG-0102 ACT IIc CAPTURE PASS")
	quit(0)


func _pose_control_state(station: Node2D, station_id: String) -> void:
	# Dialogue is inspected by its own gates; these frames are for route and
	# diegetic state, so active subtitle plates are suppressed.
	if "dialogue_active" in station:
		station.dialogue_active = false

	match station_id:
		"station_21":
			station.is_szymon_approached = true
			station.is_terminal_inspected = true
			station.is_dossier_inspected = true
			station.is_pedestal_inspected = true
			station.is_erased_name_attempted = true
			station.is_exit_unlocked = true
		"station_22":
			station.is_gate_scanned = true
			station.is_contact_inspected = true
			station.is_ring_inspected = true
			station.is_paint_recalled = true
			station.is_biographical_erasure_measured = true
			station.accept_yield()
			station.is_exit_unlocked = true
		"station_23":
			station.is_terminal_inspected = true
			station.is_model_inspected = true
			station.is_ledger_inspected = true
			station.is_cursor_shifted = true
			station.is_burden_list_scrolled = true
			station.is_purpose_revealed = true
			station.is_archive_confirmed = true
			station.is_exit_unlocked = true
		"station_24":
			station.is_cctv_inspected = true
			station.is_gauge_inspected = true
			station.is_terminal_inspected = true
			station.is_disposition_made = true
			station.is_stress_escalated = true
			station.is_exit_unlocked = true
		"station_25":
			station.is_cart_inspected = true
			station.is_chart_inspected = true
			station.is_sensor_inspected = true
			station.is_jakub_confronted = true
			station._jakub_sitting = true
			station.is_exit_unlocked = true

	station.queue_redraw()
