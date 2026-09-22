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
			station.is_interrupted_ucp_log_observed = true
			station.is_sample_clock_synchronized = true
			station.is_ucp_command_clock_synchronized = true
			station.is_local_generator_clock_synchronized = true
			station.is_ucp_intervention_reconstructed = true
			station.is_exit_unlocked = true
		"station_27":
			station.is_pulse_reference_calibrated = true
			station.is_first_identical_pulse_sent = true
			station.is_second_identical_pulse_sent = true
			station.is_deliberate_error_pulse_sent = true
			station.is_response_correction_compared = true
			station.is_exit_unlocked = true
		"station_28":
			station.is_transfer_constraint_observed = true
			station.is_home_sample_trace_inspected = true
			station.is_local_lena_signal_trace_inspected = true
			station.is_transfer_price_disclosed = true
			station.is_commitment_applied = true
			station.is_exit_unlocked = true
		"station_29":
			station.is_ucp_jakub_contrast_inspected = true
			station.is_jakub_ordinary_life_scope_observed = true
			station.is_jakub_signal_risk_disclosed = true
			station.is_jakub_transmitter_disabled = true
			station.is_jakub_consent_recorded = true
			station.jakub_consent_state = &"limited"
			station.is_exit_unlocked = true
		"station_30":
			station.is_force_home_forecast_built = true
			station.is_close_equal_recover_local_forecast_built = true
			station.is_mutual_passage_forecast_built = true
			station.are_forecast_consent_dependencies_compared = true
			station.is_exit_unlocked = true
			station._exit_open_progress = 1.0

	station.queue_redraw()
