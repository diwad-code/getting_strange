extends SceneTree

## PKG-0135 Capture Tool: visual inspection of Lena scale, Station 09 planter,
## Station 11 sideboard, and bidirectional backtrack spawn.

func _initialize() -> void:
	call_deferred(&"_capture")


func _capture() -> void:
	root.size = Vector2i(640, 360)
	var output_dir := ProjectSettings.globalize_path("res://reports")
	DirAccess.make_dir_recursive_absolute(output_dir)

	# 1. Station 01: Lena scale relative to OperatorDesk (WORLD_SCALE §4)
	var packed_s01 := load("res://scenes/levels/station_01.tscn") as PackedScene
	if packed_s01:
		var st01 := packed_s01.instantiate() as Node2D
		root.add_child(st01)
		for _i in 10:
			await process_frame
		await RenderingServer.frame_post_draw
		var img01 := root.get_texture().get_image()
		if img01:
			var path01 := output_dir.path_join("pkg_0135_station_01_lena.png")
			img01.save_png(path01)
			print("CAPTURE PASS: " + path01)
		st01.queue_free()
		await process_frame

	# 2. Station 09: Lena next to StairwellPlanter (18 px)
	var packed_s09 := load("res://scenes/levels/station_09.tscn") as PackedScene
	if packed_s09:
		var st09 := packed_s09.instantiate() as Node2D
		root.add_child(st09)
		var player09 := st09.get_node_or_null("Player") as CharacterBody2D
		if player09:
			player09.global_position = Vector2(210.0, 296.0)
		for _i in 10:
			await process_frame
		await RenderingServer.frame_post_draw
		var img09 := root.get_texture().get_image()
		if img09:
			var path09 := output_dir.path_join("pkg_0135_station_09_planter.png")
			img09.save_png(path09)
			print("CAPTURE PASS: " + path09)
		st09.queue_free()
		await process_frame

	# 3. Station 11: Lena next to HallwaySideboard (18 px)
	var packed_s11 := load("res://scenes/levels/station_11.tscn") as PackedScene
	if packed_s11:
		var st11 := packed_s11.instantiate() as Node2D
		root.add_child(st11)
		var player11 := st11.get_node_or_null("Player") as CharacterBody2D
		if player11:
			player11.global_position = Vector2(360.0, 296.0)
		for _i in 10:
			await process_frame
		await RenderingServer.frame_post_draw
		var img11 := root.get_texture().get_image()
		if img11:
			var path11 := output_dir.path_join("pkg_0135_station_11_sideboard.png")
			img11.save_png(path11)
			print("CAPTURE PASS: " + path11)
		st11.queue_free()
		await process_frame

	# 4. Station 04: backtrack spawn (facing left, right side)
	var packed_s04 := load("res://scenes/levels/station_04.tscn") as PackedScene
	if packed_s04:
		var st04 := packed_s04.instantiate() as Node2D
		root.add_child(st04)
		var player04 := st04.get_node_or_null("Player") as PrototypePlayer
		if player04:
			player04.global_position = Vector2(560.0, 296.0)
			if player04.visual_rig:
				player04.visual_rig.set_facing(-1.0)
		for _i in 10:
			await process_frame
		await RenderingServer.frame_post_draw
		var img04 := root.get_texture().get_image()
		if img04:
			var path04 := output_dir.path_join("pkg_0135_station_04_backtrack.png")
			img04.save_png(path04)
			print("CAPTURE PASS: " + path04)
		st04.queue_free()
		await process_frame

	print("PKG-0135 visual captures complete.")
	quit(0)
