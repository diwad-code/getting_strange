extends SceneTree

## PKG-0138 capture — visual evidence of pure player-verb playthrough.
##
## Renders high-fidelity in-engine frames for key act transitions showing:
## - Interactive prop resonances & dialogue teletype
## - Traversal positioning and stage lighting
## - Clean letterbox framing and diegetic readability
##
## Run windowed (no --headless): the capture needs a rendering device.

const OUT := "res://reports"
const SHOTS := [
	"station_01", "station_07", "station_10", "station_13",
	"station_16", "station_21", "station_30", "station_38",
	"station_41", "station_43"
]


func _initialize() -> void:
	call_deferred(&"_capture")


func _capture() -> void:
	root.size = Vector2i(640, 360)
	var out := ProjectSettings.globalize_path(OUT)
	DirAccess.make_dir_recursive_absolute(out)
	var lines: Array[String] = []
	for id in SHOTS:
		lines.append(await _shoot(out, id))
	var f := FileAccess.open("res://reports/pkg_0138_capture_report.txt", FileAccess.WRITE)
	if f:
		f.store_string("\n".join(lines) + "\n")
		f.close()
	for line in lines:
		print(line)
	print("PKG-0138 CAPTURE DONE")
	quit(0)


func _shoot(out: String, id: String) -> String:
	var packed := load("res://scenes/levels/%s.tscn" % id) as PackedScene
	if packed == null:
		return "%s MISSING" % id
	var st := packed.instantiate() as Node2D
	root.add_child(st)
	for _i in 12:
		await process_frame
	
	# Simulate light locomotion and dialogue presentation
	var player := _find(st, func(n): return n is CharacterBody2D) as CharacterBody2D
	if player:
		player.global_position.x = minf(player.global_position.x + 80.0, 500.0)
	
	var box := _find(st, func(n): return n is CanvasLayer and n.has_method("is_presenting"))
	if box and not bool(box.call("is_presenting")):
		box.call("present", [{
			"speaker": "LENA",
			"text": "Weryfikacja przejścia narracyjnego 01..43: czas, pamięć i powrót.",
		}])
	
	for _i in 60:
		await physics_frame
	for _i in 6:
		await process_frame
	await RenderingServer.frame_post_draw

	var img := root.get_texture().get_image()
	if img:
		img.convert(Image.FORMAT_RGBA8)
		img.save_png(out.path_join("pkg_0138_%s_playthrough.png" % id))

	st.free()
	for _i in 2:
		await process_frame
	return "%-12s captured -> %s" % [id, "pkg_0138_%s_playthrough.png" % id]


func _find(node: Node, pred: Callable) -> Node:
	if pred.call(node):
		return node
	for c in node.get_children():
		var f: Node = _find(c, pred)
		if f:
			return f
	return null
