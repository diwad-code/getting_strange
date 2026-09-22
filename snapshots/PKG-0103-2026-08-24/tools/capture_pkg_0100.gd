extends SceneTree

## PKG-0100 control renders for Station 01..10 after the Act I state-pass and
## obstacle conversion. Run with the normal Windows display driver, never with
## --headless, so the Vector-Stage layer is composited:
##
##   godot --path C:\getting_strange --script res://tools/capture_pkg_0100.gd
##
## Frames land in reports/pkg_0100/station_NN.png and are inspected manually.

const ACT_I_PATHS := [
	"res://scenes/levels/station_01.tscn",
	"res://scenes/levels/station_02.tscn",
	"res://scenes/levels/station_03.tscn",
	"res://scenes/levels/station_04.tscn",
	"res://scenes/levels/station_05.tscn",
	"res://scenes/levels/station_06.tscn",
	"res://scenes/levels/station_07.tscn",
	"res://scenes/levels/station_08.tscn",
	"res://scenes/levels/station_09.tscn",
	"res://scenes/levels/station_10.tscn",
]


func _initialize() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var output_dir := ProjectSettings.globalize_path("res://reports/pkg_0100")
	if DirAccess.make_dir_recursive_absolute(output_dir) != OK:
		push_error("PKG-0100 CAPTURE: cannot create output directory")
		quit(1)
		return

	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.campaign_auto_transition_enabled = false

	for scene_path in ACT_I_PATHS:
		var packed := load(scene_path) as PackedScene
		if packed == null:
			push_error("PKG-0100 CAPTURE: cannot load " + scene_path)
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
			push_error("PKG-0100 CAPTURE: cannot save " + output_path)
			quit(1)
			return
		print("PKG-0100 CAPTURE PASS: " + output_path)
		station.queue_free()
		await process_frame

	print("PKG-0100 ACT I CAPTURE PASS")
	quit(0)


func _pose_control_state(station: Node2D, station_id: String) -> void:
	# Dialogue is inspected by its own tests; these frames are for the route and
	# the diegetic object, so active subtitle plates are suppressed.
	if "passenger_dialogue_active" in station:
		station.passenger_dialogue_active = false
	if "marta_dialogue_active" in station:
		station.marta_dialogue_active = false
	if "jakub_dialogue_active" in station:
		station.jakub_dialogue_active = false
	if "is_dialogue_active" in station:
		station.is_dialogue_active = false

	match station_id:
		"station_01":
			station.is_procedure_completed = true
			station.circuit_alpha_on = true
			station.circuit_beta_on = true
			station.circuit_gamma_on = true
			station.vacuum_checked = true
		"station_02":
			station.procedure_state = Station02.ProcedureState.ANOMALY_ACTIVE
			station.is_optical_calibrated = true
			station.is_anomaly_active = true
			station.correlation_ratio = 0.86
			station.target_correlation_ratio = 0.86
		"station_03":
			station.cups_inspected = true
			station.phone_inspected = true
			station.card_reader_inspected = true
			station.is_door_unlocked = true
		"station_04":
			station.is_turnstile_unlocked = true
			station.dialogue_index = 6
		"station_05":
			station.crosswalk_signal_triggered = true
			station.crosswalk_lamp_green = true
		"station_06":
			station.is_bus_moving = false
			station.is_bus_stopped = true
			station._open_bus_doors()
			station.is_bus_stopped = false
			station.is_arriving = false
			station.speaker_announcement_triggered = false
		"station_07":
			station.stair_flight_crossed = true
			station.is_door_open = true
			station.door_open_progress = 1.0
		"station_08":
			var sideboard := station.get_node_or_null("Geometry/HallwaySideboard") as MovableAnchorableProp
			if sideboard:
				sideboard.position.x = 528.0
			station.sideboard_repositioned = true
		"station_09":
			var mirror := station.get_node_or_null("Geometry/ObservedMirror") as AnchorableObject
			if mirror:
				mirror.set_anchored(true)
			station.inscription_revealed = true
			station.is_corridor_stabilized = true
			station.is_door_unlocked = true
		"station_10":
			station.is_jakub_dialogue_completed = true
			station._check_unlock_conditions()

	station.queue_redraw()
