extends SceneTree

## PKG-0198 — trzy kadry (pelny / bez tekstu / mono) dla 02-05, 07, 09-18,
## 42A/B/C, 43. Wzor na tools/capture_pkg_0197.gd; uruchamiac normalnym
## sterownikiem Windows (headless wiesza sie na frame_post_draw).
## Zapis: 640x360 PNG + frames.tsv pod reports/pkg_0198/visual.

const OUT_DIR := "res://reports/pkg_0198/visual"
const STATIONS: Array[String] = [
	"station_02", "station_03", "station_04", "station_05",
	"station_07",
	"station_09", "station_10", "station_11", "station_12",
	"station_13", "station_14", "station_15", "station_16",
	"station_17", "station_18",
	"station_42a", "station_42b", "station_42c", "station_43",
]


func _initialize() -> void:
	call_deferred(&"_run")


func _run() -> void:
	root.size = Vector2i(640, 360)
	var out_path := ProjectSettings.globalize_path(OUT_DIR)
	DirAccess.make_dir_recursive_absolute(out_path)
	var index: Array[String] = []
	for station_id in STATIONS:
		var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
		if packed == null:
			push_error("CAPTURE 0198: cannot load %s" % station_id)
			continue
		# Tryb 1: pelny (jak po wejsciu, z napisami diegetycznymi).
		var full_image := await _capture_variant(packed, station_id, false)
		if full_image != null:
			var full_name := "%s__pkg0198_full.png" % station_id
			full_image.save_png(out_path.path_join(full_name))
			print("CAPTURE 0198 PASS: %s" % full_name)
			index.append("%s\tfull\t%s" % [station_id, full_name])
		else:
			push_error("CAPTURE 0198: no full image for %s" % station_id)
		# Tryb 2: bez tekstu (dialog wyczyszczony po prezentacji, napisy
		# diegetyczne ukryte). Tryb 3: mono (skala szarosci z bez-tekstu:
		# czysta sylweta i dzialanie, zero koloru i zero liter).
		var notext_image := await _capture_variant(packed, station_id, true)
		if notext_image != null:
			var notext_name := "%s__pkg0198_notext.png" % station_id
			notext_image.save_png(out_path.path_join(notext_name))
			print("CAPTURE 0198 PASS: %s" % notext_name)
			index.append("%s\tnotext\t%s" % [station_id, notext_name])
			var mono_image := notext_image.duplicate() as Image
			mono_image.convert(Image.FORMAT_L8)
			var mono_name := "%s__pkg0198_mono.png" % station_id
			mono_image.save_png(out_path.path_join(mono_name))
			print("CAPTURE 0198 PASS: %s" % mono_name)
			index.append("%s\tmono\t%s" % [station_id, mono_name])
		else:
			push_error("CAPTURE 0198: no notext image for %s" % station_id)
	var tsv := FileAccess.open(out_path.path_join("frames.tsv"), FileAccess.WRITE)
	if tsv != null:
		tsv.store_string("station\tmode\tfile\n")
		for line in index:
			tsv.store_string(line + "\n")
		tsv.close()
	quit(0)


func _capture_variant(packed: PackedScene, station_id: String, hide_text: bool) -> Image:
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	# Najpierw pozwol stacji zaprezentowac kwestie startowe (OpeningDialogueCue
	# odpala po _ready), dopiero potem czysc — inaczej cue dogania kadr.
	for frame in range(8):
		await process_frame
	if hide_text:
		_clear_dialogue(station)
		_hide_diegetic_text(station)
		for frame in range(4):
			await process_frame
		_clear_dialogue(station)
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	station.free()
	await process_frame
	return image


func _clear_dialogue(node: Node) -> void:
	if node is CRTDialogueBox:
		var dialogue := node as CRTDialogueBox
		var guard := 0
		while dialogue.is_presenting() and guard < 32:
			dialogue.advance_dialogue()
			guard += 1
	for child in node.get_children():
		_clear_dialogue(child)


func _hide_diegetic_text(node: Node) -> void:
	# Po nazwie i po klasie: etykiety fasad, tablic i domofonow nie moga
	# wejsc w kadr „bez tekstu" zadna sciezka. CrispDiegeticText renderuje
	# przez dziecko CanvasLayer (CrispDiegeticLayer, warstwa 10), ktore nie
	# dziedziczy visible po Node2D — trzeba zgasic je wprost.
	var is_diegetic := (node is CrispDiegeticText) or String(node.name).begins_with("CrispDiegeticText")
	if is_diegetic:
		(node as Node2D).visible = false
		var crisp_layer := node.get_node_or_null("CrispDiegeticLayer") as CanvasLayer
		if crisp_layer != null:
			crisp_layer.visible = false
	if node is CRTDialogueBox:
		(node as CanvasLayer).visible = false
	if String(node.name) == "InnerThoughtSurface":
		(node as CanvasLayer).visible = false
	for child in node.get_children():
		_hide_diegetic_text(child)
