extends SceneTree

## PKG-0201 gate — ocularna inspekcja 57 kadrów 0198 (ścieżka B).
##
## Dowodzi wyłącznie kontraktów mierzalnych, nigdy „ładności" (D-012, ADR-003):
## (1) dowód 0198 jest kompletny i nienaruszony (TSV 57 wierszy, 57 plików
## 640x360, kadry mono rzeczywiście szare, mono zgodne luminancją z wariantem
## bez tekstu); (2) ludzka inspekcja pokryła wszystkie 19 adresów werdyktem
## HOLD (pin pokrycia; sam ogląd jest w `docs/rebuild/PKG_0201_OCULAR_INSPECTION.md`
## i arkuszach `reports/pkg_0201/visual/`); (3) skale tekstu 85/100/115 nie
## łamią runtime: regresja stacji 08 trzema akcjami (wzór PKG-0198) oraz
## ładowanie najjaśniejszej (11), najciemniejszej (14) i finału (43) na każdej
## skali bez błędów skryptu. Logika gry nietykalna: zero writerów, flag,
## sygnałów, routingu, enum i serialize IDs; brak zmian w scripts/scenes.

const VISUAL_DIR := "res://reports/pkg_0198/visual"
const FRAMES_TSV := "res://reports/pkg_0198/visual/frames.tsv"

const SLICE_IDS: Array[String] = [
	"station_02", "station_03", "station_04", "station_05", "station_07",
	"station_09", "station_10", "station_11", "station_12", "station_13",
	"station_14", "station_15", "station_16", "station_17", "station_18",
	"station_42a", "station_42b", "station_42c", "station_43",
]

const MODES: Array[String] = ["full", "notext", "mono"]

## Wynik inspekcji ocznej PKG-0201: każdy adres pokryty werdyktem HOLD.
## Notatki obserwacyjne (marginalne 14/15/16/17) żyją w raporcie; bramka
## pinuje wyłącznie binarny fakt pokrycia i brak żądań naprawy.
const OCULAR_HOLD: Array[String] = [
	"station_02", "station_03", "station_04", "station_05", "station_07",
	"station_09", "station_10", "station_11", "station_12", "station_13",
	"station_14", "station_15", "station_16", "station_17", "station_18",
	"station_42a", "station_42b", "station_42c", "station_43",
]

const SCALE_STATIONS: Array[String] = ["station_11", "station_14", "station_43"]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0201: " + message)


func _run() -> void:
	_check_frames_index()
	_check_frame_files()
	_check_mono_is_gray()
	_check_mono_matches_notext()
	_check_ocular_coverage()
	await _check_runtime_text_scales()
	_finish()


func _frame_path(station_id: String, mode: String) -> String:
	return "%s/%s__pkg0198_%s.png" % [VISUAL_DIR, station_id, mode]


# ─── 1. Indeks TSV: 57 wierszy danych ───────────────────────────────────────

func _check_frames_index() -> void:
	var file := FileAccess.open(FRAMES_TSV, FileAccess.READ)
	_expect(file != null, "frames.tsv must be readable: %s" % FRAMES_TSV)
	if file == null:
		return
	var rows := 0
	var seen: Dictionary = {}
	while not file.eof_reached():
		var line: String = file.get_line().strip_edges()
		if line.is_empty() or line.begins_with("station\tmode") or line.begins_with("station,mode"):
			continue
		var parts := line.split("\t")
		_expect(parts.size() == 3, "frames.tsv row must have 3 tab columns: %s" % line)
		if parts.size() == 3:
			seen["%s/%s" % [parts[0], parts[1]]] = true
		rows += 1
	file.close()
	_expect(rows == 57, "frames.tsv must index 57 frames (got %d)" % rows)
	for station_id in SLICE_IDS:
		for mode in MODES:
			_expect(seen.has("%s/%s" % [station_id, mode]), "frames.tsv must index %s %s" % [station_id, mode])


# ─── 2. Pliki: 57 × 640x360 ────────────────────────────────────────────────

func _check_frame_files() -> void:
	for station_id in SLICE_IDS:
		for mode in MODES:
			var path := _frame_path(station_id, mode)
			_expect(FileAccess.file_exists(path), "frame file must exist: %s" % path)
			if not FileAccess.file_exists(path):
				continue
			var img: Image = Image.load_from_file(path)
			_expect(img != null and not img.is_empty(), "frame must load: %s" % path)
			if img == null or img.is_empty():
				continue
			_expect(img.get_size() == Vector2i(640, 360), "%s must be 640x360 (got %s)" % [path, str(img.get_size())])


# ─── 3. Mono to czysta skala szarości ───────────────────────────────────────

func _check_mono_is_gray() -> void:
	for station_id in SLICE_IDS:
		var img: Image = Image.load_from_file(_frame_path(station_id, "mono"))
		if img == null or img.is_empty():
			_expect(false, "mono frame must load for gray check: %s" % station_id)
			continue
		var bad := 0
		var y := 0
		while y < img.get_height():
			var x := 0
			while x < img.get_width():
				var c: Color = img.get_pixel(x, y)
				if absf(c.r - c.g) > 0.004 or absf(c.g - c.b) > 0.004:
					bad += 1
				x += 37
			y += 37
		_expect(bad == 0, "%s mono must be true gray (R==G==B), %d tinted samples" % [station_id, bad])


# ─── 4. Mono zgodne luminancją z bez-tekstu ─────────────────────────────────
#
# Mono powstało w 0198 jako duplicate + convert(FORMAT_L8) z wariantu
# bez-tekstu, więc luminancja próbek musi się zgadzać (Rec.601, tolerancja
# na zaokrąglenia konwersji). Samo to nie dowodzi czystości kadru — ta jest
# oczna (raport); tu pinujemy, że mono jest wierną pochodną bez-tekstu.

func _check_mono_matches_notext() -> void:
	for station_id in SLICE_IDS:
		var mono: Image = Image.load_from_file(_frame_path(station_id, "mono"))
		var notext: Image = Image.load_from_file(_frame_path(station_id, "notext"))
		if mono == null or mono.is_empty() or notext == null or notext.is_empty():
			_expect(false, "mono/notext must load for luminance check: %s" % station_id)
			continue
		var total := 0.0
		var count := 0
		var worst := 0.0
		var y := 0
		while y < mono.get_height():
			var x := 0
			while x < mono.get_width():
				var m: Color = mono.get_pixel(x, y)
				var n: Color = notext.get_pixel(x, y)
				var lum: float = 0.299 * n.r + 0.587 * n.g + 0.114 * n.b
				var d: float = absf(m.r - lum)
				total += d
				count += 1
				worst = maxf(worst, d)
				x += 43
			y += 43
		var mean: float = total / float(maxi(count, 1))
		_expect(mean <= 0.06, "%s mono mean luminance drift too high (%.4f)" % [station_id, mean])
		_expect(worst <= 0.20, "%s mono worst-sample drift too high (%.4f)" % [station_id, worst])


# ─── 5. Pin pokrycia inspekcji: 19/19 HOLD, zero napraw ─────────────────────

func _check_ocular_coverage() -> void:
	_expect(OCULAR_HOLD.size() == 19, "ocular verdicts must cover 19 stations (got %d)" % OCULAR_HOLD.size())
	for station_id in SLICE_IDS:
		_expect(OCULAR_HOLD.has(station_id), "ocular verdict HOLD must exist for %s" % station_id)


# ─── 6. Runtime: skale 85/100/115 ───────────────────────────────────────────

func _check_runtime_text_scales() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager must exist")
	if state == null:
		return
	var old_scale: float = float(state.get("text_scale"))
	var scales: Array[float] = [0.85, 1.0, 1.15]
	for scale_value in scales:
		state.set("text_scale", scale_value)
		if state.has_method("apply_text_scale_to_tree"):
			state.call("apply_text_scale_to_tree")
		# Regresja 08 (wzór PKG-0198): trzy akcje na każdej skali.
		var packed08 := load("res://scenes/levels/station_08.tscn") as PackedScene
		_expect(packed08 != null, "station_08 scene must load at scale %d" % int(scale_value * 100.0))
		if packed08 != null:
			var st08 := packed08.instantiate() as Node2D
			root.add_child(st08)
			await process_frame
			await process_frame
			_expect(bool(st08.call("inspect_floor_twelve")), "08 door-12 must resolve at scale %d" % int(scale_value * 100.0))
			_expect(bool(st08.call("speak_with_neighbour")), "08 neighbour must resolve at scale %d" % int(scale_value * 100.0))
			_expect(bool(st08.call("unlock_apartment_fourteen")), "08 key must resolve at scale %d" % int(scale_value * 100.0))
			st08.free()
			await process_frame
		# Próbka trasy: najjaśniejsza / najciemniejsza / finał na każdej skali.
		for sid in SCALE_STATIONS:
			var packed := load("res://scenes/levels/%s.tscn" % sid) as PackedScene
			_expect(packed != null, "%s scene must load at scale %d" % [sid, int(scale_value * 100.0)])
			if packed == null:
				continue
			var st := packed.instantiate() as Node2D
			_expect(st != null, "%s must instantiate at scale %d" % [sid, int(scale_value * 100.0)])
			if st == null:
				continue
			root.add_child(st)
			await process_frame
			await process_frame
			_expect(st.get_child_count() > 0, "%s must own drawn children at scale %d" % [sid, int(scale_value * 100.0)])
			st.free()
			await process_frame
	state.set("text_scale", old_scale)
	if state.has_method("apply_text_scale_to_tree"):
		state.call("apply_text_scale_to_tree")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0201 OCULAR PASS: 57 frames intact, mono true gray and faithful, 19/19 HOLD, text scales 85/100/115.")
		quit(0)
	else:
		print("PKG-0201 OCULAR FAIL: %d failures" % _failures.size())
		for failure in _failures:
			print(" - %s" % failure)
		quit(1)
