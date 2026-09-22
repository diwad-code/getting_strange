extends SceneTree

## PKG-0137 capture — evidence for the driven playthrough.
##
## One framed shot per act with the dialogue panel open, which is the state the
## D-133 offset applies in, plus a scanline read of the bottom of the frame.
## Before the D-136 apron those bottom rows were the engine clear colour; the
## report line next to each shot is what makes that claim checkable.
##
## Run windowed (no --headless): the capture needs a rendering device.

const OUT := "res://reports"
## One per act, plus the flat-profile stations called out in FRAME_LAYOUT_AUDIT §4.
const SHOTS := [
	"station_01", "station_08", "station_16", "station_24",
	"station_31", "station_37", "station_41", "station_43",
]
const CLEAR := Color(0.027, 0.035, 0.047)


func _initialize() -> void:
	call_deferred(&"_capture")


func _capture() -> void:
	root.size = Vector2i(640, 360)
	var out := ProjectSettings.globalize_path(OUT)
	DirAccess.make_dir_recursive_absolute(out)
	var lines: Array[String] = []
	for id in SHOTS:
		lines.append(await _shoot(out, id))
	var f := FileAccess.open("res://reports/pkg_0137_capture_report.txt", FileAccess.WRITE)
	if f:
		f.store_string("\n".join(lines) + "\n")
		f.close()
	for line in lines:
		print(line)
	print("PKG-0137 CAPTURE DONE")
	quit(0)


func _shoot(out: String, id: String) -> String:
	var packed := load("res://scenes/levels/%s.tscn" % id) as PackedScene
	if packed == null:
		return "%s MISSING" % id
	var st := packed.instantiate() as Node2D
	root.add_child(st)
	for _i in 8:
		await process_frame
	var box := _find(st, func(n): return n is CanvasLayer and n.has_method("is_presenting"))
	if box and not bool(box.call("is_presenting")):
		box.call("present", [{
			"speaker": "LENA",
			"text": "Kadr dialogowy nie może odsłonić pustki pod planem gry.",
		}])
	# Long enough for the camera easing to reach the framed position.
	for _i in 90:
		await physics_frame
	for _i in 4:
		await process_frame
	await RenderingServer.frame_post_draw

	var img := root.get_texture().get_image()
	var cam := _find(st, func(n): return n is Camera2D) as Camera2D
	var cam_y: float = cam.global_position.y if cam else -1.0
	var void_rows := 0
	var sampled := 0
	if img:
		img.convert(Image.FORMAT_RGBA8)
		for y in range(img.get_height() - 40, img.get_height()):
			sampled += 1
			var voidish := true
			for x in [40, 160, 320, 480, 600]:
				var c := img.get_pixel(x, y)
				var diff := absf(c.r - CLEAR.r) + absf(c.g - CLEAR.g) + absf(c.b - CLEAR.b)
				if diff > 0.02:
					voidish = false
					break
			if voidish:
				void_rows += 1
		img.save_png(out.path_join("pkg_0137_%s_framed.png" % id))

	st.free()
	for _i in 2:
		await process_frame
	return "%-12s cam_y=%.0f  bottom %d rows sampled, %d read as clear colour  -> %s" % [
		id, cam_y, sampled, void_rows, "VOID" if void_rows > 0 else "painted"
	]


func _find(node: Node, pred: Callable) -> Node:
	if pred.call(node):
		return node
	for c in node.get_children():
		var f: Node = _find(c, pred)
		if f:
			return f
	return null
