extends SceneTree

## PKG-0136 Capture Tool — Lena 4.1 locomotion.
##
## 1. A state sheet: every named state rendered on the same ground line, so the
##    silhouette test from LENA_CHARACTER_AND_ANIMATION.md §9 can be read.
## 2. A live walk strip: the player is driven at walk and at sprint speed and a
##    frame is grabbed every few physics ticks, which is what actually proves
##    the cycle no longer slides or jitters.
## 3. Station framing shots for the HUD / element placement review.

const OUT := "res://reports"
const STATES := [
	&"idle", &"start", &"walk", &"run", &"stop", &"turn",
	&"jump_rise", &"jump_fall", &"land", &"interact",
	&"examine", &"unease_reaction", &"seam_gesture", &"climb",
]


func _initialize() -> void:
	call_deferred(&"_capture")


func _capture() -> void:
	root.size = Vector2i(640, 360)
	var out := ProjectSettings.globalize_path(OUT)
	DirAccess.make_dir_recursive_absolute(out)

	await _capture_state_sheet(out)
	await _capture_locomotion_strip(out, false, "walk")
	await _capture_locomotion_strip(out, true, "run")
	await _capture_station(out, "station_01", 1)
	await _capture_station(out, "station_05", 5)

	print("PKG-0136 CAPTURE DONE")
	quit()


## Renders one 64x104 cell per state onto a single sheet, on a neutral ground.
func _capture_state_sheet(out: String) -> void:
	var rig_script := load("res://scripts/player/lena_visual_rig.gd") as GDScript
	var cols := 7
	var cell := Vector2i(72, 120)
	var sheet := Image.create(cols * cell.x, 2 * cell.y, false, Image.FORMAT_RGBA8)
	sheet.fill(Color(0.09, 0.10, 0.12, 1.0))

	for i in STATES.size():
		var holder := Node2D.new()
		root.add_child(holder)
		var rig = rig_script.new()
		holder.add_child(rig)
		rig.debug_override_state(STATES[i])
		for _f in 4:
			await process_frame
		var sub := SubViewport.new()
		sub.size = cell
		sub.transparent_bg = false
		sub.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		root.add_child(sub)
		holder.reparent(sub)
		holder.position = Vector2(cell.x * 0.5, 90.0)
		for _f in 4:
			await process_frame
		await RenderingServer.frame_post_draw
		var img := sub.get_texture().get_image()
		if img:
			img.convert(Image.FORMAT_RGBA8)
			sheet.blit_rect(
				img,
				Rect2i(Vector2i.ZERO, cell),
				Vector2i((i % cols) * cell.x, (i / cols) * cell.y)
			)
		sub.queue_free()
		await process_frame

	var path := out.path_join("pkg_0136_lena_state_sheet.png")
	sheet.save_png(path)
	print("CAPTURE PASS: " + path)


## Drives the real player across the floor and samples the rendered frame, so
## foot slide and per-frame jitter would show up as a broken strip.
func _capture_locomotion_strip(out: String, sprint: bool, label: String) -> void:
	var packed := load("res://scenes/levels/station_01.tscn") as PackedScene
	if packed == null:
		return
	var st := packed.instantiate() as Node2D
	root.add_child(st)
	for _f in 8:
		await process_frame
	var player := st.get_node_or_null("Player") as CharacterBody2D
	if player == null:
		st.queue_free()
		return

	# HUD layers would cover the legs; the strip is about the body, not the UI.
	for layer_name in ["CRTDialogueBox", "InnerThoughtSurface"]:
		var layer := st.get_node_or_null(layer_name) as CanvasLayer
		if layer:
			layer.visible = false

	var rig = player.get("visual_rig")
	var speed: float = 96.0 * (1.35 if sprint else 1.0)
	player.set_physics_process(false)
	# LenaAnimationState keeps re-driving the rig from the player's own flags,
	# so the sprint flag has to be set on the player, not just passed to the rig.
	player.set("is_sprinting", sprint)
	player.global_position = Vector2(120.0, 296.0)

	var shots := 8
	var crop := Vector2i(96, 128)
	var strip := Image.create(crop.x * shots, crop.y, false, Image.FORMAT_RGBA8)
	strip.fill(Color(0.09, 0.10, 0.12, 1.0))

	for s in shots:
		for _f in 5:
			player.velocity = Vector2(speed, 0.0)
			player.move_and_slide()
			if rig:
				rig.set_mechanical_state(player.velocity, player.is_on_floor(), false, sprint)
			await physics_frame
		await process_frame
		await RenderingServer.frame_post_draw
		var img := root.get_texture().get_image()
		if img == null:
			continue
		img.convert(Image.FORMAT_RGBA8)
		var px := int(player.global_position.x) - crop.x / 2
		px = clampi(px, 0, img.get_width() - crop.x)
		var py = clampi(int(player.global_position.y) - 96, 0, img.get_height() - crop.y)
		strip.blit_rect(img, Rect2i(Vector2i(px, py), crop), Vector2i(s * crop.x, 0))

	var path := out.path_join("pkg_0136_lena_%s_strip.png" % label)
	strip.save_png(path)
	print("CAPTURE PASS: " + path)
	st.queue_free()
	await process_frame


func _capture_station(out: String, station_id: String, _n: int) -> void:
	var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
	if packed == null:
		return
	var st := packed.instantiate() as Node2D
	root.add_child(st)
	var player := st.get_node_or_null("Player") as CharacterBody2D
	if player:
		player.global_position = Vector2(300.0, 296.0)
	for _f in 14:
		await process_frame
	await RenderingServer.frame_post_draw
	var img := root.get_texture().get_image()
	if img:
		var path := out.path_join("pkg_0136_%s_layout.png" % station_id)
		img.save_png(path)
		print("CAPTURE PASS: " + path)
	st.queue_free()
	await process_frame
