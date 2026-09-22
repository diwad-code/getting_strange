extends SceneTree

## PKG-0099 control renders: Station 11..15 after the D-096 visibility fix and
## the Act II obstacle work. Run with the normal Windows display driver, never
## with --headless, or the Vector-Stage layer will not be composited:
##
##   godot --path C:\getting_strange --script res://tools/capture_pkg_0099.gd
##
## Frames land in reports/pkg_0099/station_NN.png and must be looked at, not
## merely produced (VISUAL_DESIGN.md §11).

const ACT_II_PATHS := [
	"res://scenes/levels/station_11.tscn",
	"res://scenes/levels/station_12.tscn",
	"res://scenes/levels/station_13.tscn",
	"res://scenes/levels/station_14.tscn",
	"res://scenes/levels/station_15.tscn",
]


func _initialize() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var output_dir := ProjectSettings.globalize_path("res://reports/pkg_0099")
	if DirAccess.make_dir_recursive_absolute(output_dir) != OK:
		push_error("PKG-0099 CAPTURE: cannot create output directory")
		quit(1)
		return

	var state := root.get_node_or_null("GameStateManager")
	if state and "campaign_auto_transition_enabled" in state:
		state.campaign_auto_transition_enabled = false

	for scene_path in ACT_II_PATHS:
		var packed := load(scene_path) as PackedScene
		if packed == null:
			push_error("PKG-0099 CAPTURE: cannot load " + scene_path)
			quit(1)
			return
		var station := packed.instantiate() as Node2D
		root.add_child(station)
		for frame in range(10):
			await process_frame

		# The CRT surface is UI, not frame. It would hide the composition.
		var dialogue := station.get_node_or_null("CRTDialogueBox") as CanvasLayer
		if dialogue:
			dialogue.hide()

		# Put the obstacle spaces into the state worth inspecting: the contested
		# version held, so the render shows the traversable route at full value.
		_pose_obstacle(station)
		for frame in range(6):
			await process_frame
		# Anything the station started in the meantime is suppressed again, so
		# the control frame shows the composition and not a dialogue plate.
		_pose_obstacle(station)
		await process_frame

		await RenderingServer.frame_post_draw
		var image := root.get_texture().get_image()
		var output_path := output_dir.path_join(scene_path.get_file().get_basename() + ".png")
		if image == null or image.save_png(output_path) != OK:
			push_error("PKG-0099 CAPTURE: cannot save " + output_path)
			quit(1)
			return
		print("PKG-0099 CAPTURE PASS: " + output_path)
		station.queue_free()
		await process_frame

	print("PKG-0099 ACT II CAPTURE PASS")
	quit(0)


func _pose_obstacle(station: Node) -> void:
	# The station-drawn dialogue plate is UI too; it would sit on the composition.
	if "dialogue_active" in station:
		station.dialogue_active = false
	if "marta_dialogue_active" in station:
		station.marta_dialogue_active = false
	var flight := station.get_node_or_null("Geometry/EvacuationStairFlight") as AnchorableObject
	if flight:
		flight.set_anchored(true)
	var panel := station.get_node_or_null("Geometry/ScoredMetalPanel") as AnchorableObject
	if panel:
		panel.set_anchored(true)
