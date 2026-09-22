extends SceneTree

## PKG-0202 — sciezka C: oczny ogld skal 85/115 w pelnej rozdzielczosci.
## Dobadanie otwartego ograniczenia PKG-0201 (bramka dowodzila runtime, nie oko)
## dla 4 adresow: 08 (regresja), 11 (najjasniejsza), 14 (najciemniejsza),
## 43 (final z diegetyczna sciana credits). Uruchamiac normalnym sterownikiem
## Windows (headless wiesza sie na frame_post_draw; fakt z PKG-0197).
## Zapis: 24 PNG 640x360 (4 adresy x 3 skale x pelny/bez tekstu) + frames.tsv
## pod reports/pkg_0202/visual. Zero zmian w scripts/scenes; tylko odczyt
## runtime + zapis obrazow. Skala ustawiana przez set_text_scale(..., false)
## (bez persistu, z sygnalem accessibility_changed), po petli powrot do 1.0.

const OUT_DIR := "res://reports/pkg_0202/visual"
const STATIONS: Array[String] = [
	"station_08", "station_11", "station_14", "station_43",
]
const SCALE_LABELS: Array[int] = [85, 100, 115]
const SCALE_VALUES: Array[float] = [0.85, 1.0, 1.15]


func _initialize() -> void:
	call_deferred(&"_run")


func _run() -> void:
	root.size = Vector2i(640, 360)
	var out_path := ProjectSettings.globalize_path(OUT_DIR)
	DirAccess.make_dir_recursive_absolute(out_path)
	var state := root.get_node_or_null("GameStateManager")
	if state == null:
		push_error("CAPTURE 0202: no GameStateManager autoload")
		quit(1)
		return
	var index: Array[String] = []
	for si in range(STATIONS.size()):
		var station_id: String = STATIONS[si]
		var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
		if packed == null:
			push_error("CAPTURE 0202: cannot load %s" % station_id)
			continue
		for sci in range(SCALE_LABELS.size()):
			var label: int = SCALE_LABELS[sci]
			var scale_value: float = SCALE_VALUES[sci]
			state.call("set_text_scale", scale_value, false)
			await process_frame
			await process_frame
			var full_image := await _capture_variant(packed, station_id, false)
			if full_image != null:
				var full_name := "%s__pkg0202_s%d_full.png" % [station_id, label]
				full_image.save_png(out_path.path_join(full_name))
				print("CAPTURE 0202 PASS: %s" % full_name)
				index.append("%s\t%d\tfull\t%s" % [station_id, label, full_name])
			else:
				push_error("CAPTURE 0202: no full image for %s s%d" % [station_id, label])
			var notext_image := await _capture_variant(packed, station_id, true)
			if notext_image != null:
				var notext_name := "%s__pkg0202_s%d_notext.png" % [station_id, label]
				notext_image.save_png(out_path.path_join(notext_name))
				print("CAPTURE 0202 PASS: %s" % notext_name)
				index.append("%s\t%d\tnotext\t%s" % [station_id, label, notext_name])
			else:
				push_error("CAPTURE 0202: no notext image for %s s%d" % [station_id, label])
	state.call("set_text_scale", 1.0, false)
	var tsv := FileAccess.open(out_path.path_join("frames.tsv"), FileAccess.WRITE)
	if tsv != null:
		tsv.store_string("station\tscale\tmode\tfile\n")
		for line in index:
			tsv.store_string(line + "\n")
		tsv.close()
	quit(0)


func _capture_variant(packed: PackedScene, station_id: String, hide_text: bool) -> Image:
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	# Najpierw pozwol stacji zaprezentowac kwestie startowe (OpeningDialogueCue
	# odpala po _ready), dopiero potem czysc — inaczej cue dogania kadr
	# (wzor tools/capture_pkg_0198.gd).
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
	# Wzor PKG-0198: CrispDiegeticText renderuje przez dziecko CanvasLayer
	# (CrispDiegeticLayer, warstwa 10), ktore nie dziedziczy visible po Node2D
	# — trzeba zgasic je wprost.
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
