extends SceneTree

## PKG-0106 control render for Station 41 after the Act IV Vector-Stage profile
## and conscious mechanical silence decision are in place.
## Run this with the normal Windows display driver, never headless:
##
##   godot_console.exe --path C:\getting_strange --script res://tools/capture_pkg_0106.gd
##
## The single control frame lands in reports/pkg_0106/station_41.png and is
## inspected manually. It is technical render evidence, not a playtest.

const STATION_PATH := "res://scenes/levels/station_41.tscn"


func _initialize() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(640, 360)
	var output_dir := ProjectSettings.globalize_path("res://reports/pkg_0106")
	if DirAccess.make_dir_recursive_absolute(output_dir) != OK:
		push_error("PKG-0106 CAPTURE: cannot create output directory")
		quit(1)
		return

	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	var packed := load(STATION_PATH) as PackedScene
	if packed == null:
		push_error("PKG-0106 CAPTURE: cannot load " + STATION_PATH)
		quit(1)
		return
	var station := packed.instantiate() as Station41
	root.add_child(station)
	for _frame in range(10):
		await process_frame

	# Control pose: all three stations remain visible, while B supplies one
	# selected responsibility and the resolution route is technically open.
	station.dialogue_active = false
	station.is_topography_inspected = true
	station.is_op_a_inspected = true
	station.is_op_b_inspected = true
	station.is_op_c_inspected = true
	station.select_operation("B")
	station.dialogue_active = false
	var dialogue := station.get_node_or_null("CRTDialogueBox") as CanvasLayer
	if dialogue:
		dialogue.hide()
	station.queue_redraw()

	for _frame in range(14):
		await process_frame
	await RenderingServer.frame_post_draw

	var image := root.get_texture().get_image()
	var output_path := output_dir.path_join("station_41.png")
	if image == null or image.save_png(output_path) != OK:
		push_error("PKG-0106 CAPTURE: cannot save " + output_path)
		quit(1)
		return
	print("PKG-0106 CAPTURE PASS: " + output_path)

	station.queue_free()
	await process_frame
	if state:
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)
	print("PKG-0106 STATION 41 CAPTURE PASS")
	quit(0)
