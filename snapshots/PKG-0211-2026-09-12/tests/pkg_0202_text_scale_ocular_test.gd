extends SceneTree

## PKG-0202 gate — oczny oglad skal 85/115 w pelnej rozdzielczosci (sciezka C).
##
## Dowodzi wylacznie kontraktow mierzalnych, nigdy „ladnosci" (D-012, ADR-003):
## (1) dowod 0202 jest kompletny (TSV 24 wiersze, 24 pliki 640x360, warianty
## full/notext rozlaczne, full s85-vs-s115 rozlaczne — ten sam kadr nie
## zostal zapisany dwa razy pod dwiema nazwami); (2) ludzka inspekcja pokryla
## 4 adresy x 3 skale werdyktem HOLD (pin pokrycia; sam oglad jest w
## `docs/rebuild/PKG_0202_TEXT_SCALE_OCULAR.md` i arkuszach
## `reports/pkg_0202/visual/sheet_*_scales.png`); (3) skale 85/100/115 nie
## lamia runtime: regresja stacji 08 trzema akcjami (wzor PKG-0198/0201) oraz
## ladowanie 11 (najjasniejsza), 14 (najciemniejsza) i 43 (final) na kazdej
## skali bez bledow skryptu. Logika gry nietykalna: zero writerow, flag,
## sygnalow, routingu, enum i serialize IDs; brak zmian w scripts/scenes.

const VISUAL_DIR := "res://reports/pkg_0202/visual"
const FRAMES_TSV := "res://reports/pkg_0202/visual/frames.tsv"

const STATIONS: Array[String] = [
	"station_08", "station_11", "station_14", "station_43",
]
const SCALE_LABELS: Array[int] = [85, 100, 115]
const MODES: Array[String] = ["full", "notext"]

## Wynik inspekcji ocznej PKG-0202: kazdy adres x kazda skala to HOLD.
## Notatki obserwacyjne zyja w raporcie; bramka pinuje wylacznie binarny fakt
## pokrycia i brak zadan naprawy. Bez nowej tezy autorskiej (D-214/D-219).
const OCULAR_HOLD: Array[String] = [
	"station_08/s85", "station_08/s100", "station_08/s115",
	"station_11/s85", "station_11/s100", "station_11/s115",
	"station_14/s85", "station_14/s100", "station_14/s115",
	"station_43/s85", "station_43/s100", "station_43/s115",
]

const RUNTIME_STATIONS: Array[String] = ["station_11", "station_14", "station_43"]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0202: " + message)


func _run() -> void:
	_check_frames_index()
	_check_frame_files()
	_check_variants_are_distinct()
	_check_ocular_coverage()
	await _check_runtime_text_scales()
	_finish()


func _frame_path(station_id: String, scale_label: int, mode: String) -> String:
	return "%s/%s__pkg0202_s%d_%s.png" % [VISUAL_DIR, station_id, scale_label, mode]


# ─── 1. Indeks TSV: 24 wiersze danych ───────────────────────────────────────

func _check_frames_index() -> void:
	var file := FileAccess.open(FRAMES_TSV, FileAccess.READ)
	_expect(file != null, "frames.tsv must be readable: %s" % FRAMES_TSV)
	if file == null:
		return
	var rows := 0
	var seen: Dictionary = {}
	while not file.eof_reached():
		var line: String = file.get_line().strip_edges()
		if line.is_empty() or line.begins_with("station\tscale"):
			continue
		var parts := line.split("\t")
		_expect(parts.size() == 4, "frames.tsv row must have 4 tab columns: %s" % line)
		if parts.size() == 4:
			seen["%s/s%s/%s" % [parts[0], parts[1], parts[2]]] = true
		rows += 1
	file.close()
	_expect(rows == 24, "frames.tsv must index 24 frames (got %d)" % rows)
	for station_id in STATIONS:
		for scale_label in SCALE_LABELS:
			for mode in MODES:
				var key: String = "%s/s%d/%s" % [station_id, scale_label, mode]
				_expect(seen.has(key), "frames.tsv must index %s" % key)


# ─── 2. Pliki: 24 x 640x360 ────────────────────────────────────────────────

func _check_frame_files() -> void:
	for station_id in STATIONS:
		for scale_label in SCALE_LABELS:
			for mode in MODES:
				var path := _frame_path(station_id, scale_label, mode)
				_expect(FileAccess.file_exists(path), "frame file must exist: %s" % path)
				if not FileAccess.file_exists(path):
					continue
				var img: Image = Image.load_from_file(path)
				_expect(img != null and not img.is_empty(), "frame must load: %s" % path)
				if img == null or img.is_empty():
					continue
				_expect(img.get_size() == Vector2i(640, 360), "%s must be 640x360 (got %s)" % [path, str(img.get_size())])


# ─── 3. Warianty rozlaczne (ten sam kadr nie zapisany dwa razy) ─────────────
#
# Probkowanie co 37 px (wzór PKG-0201): full-vs-notext przy s100 musi sie
# roznic znacznie (dialog + diegetyki), a full s85-vs-s115 musi sie roznic
# choc troche (skala tekstu i/lub faza maszyny do pisania i animacji).
# To pinuje, ze capture wzial swieze klatki na kazda skale, nie kopie.

func _sample_diff(a: Image, b: Image) -> float:
	var diff := 0
	var count := 0
	var y := 0
	while y < a.get_height():
		var x := 0
		while x < a.get_width():
			var pa: Color = a.get_pixel(x, y)
			var pb: Color = b.get_pixel(x, y)
			if absf(pa.r - pb.r) > 0.05 or absf(pa.g - pb.g) > 0.05 or absf(pa.b - pb.b) > 0.05:
				diff += 1
			count += 1
			x += 13
		y += 13
	return float(diff) / float(maxi(count, 1))


func _check_variants_are_distinct() -> void:
	for station_id in STATIONS:
		var full100: Image = Image.load_from_file(_frame_path(station_id, 100, "full"))
		var notext100: Image = Image.load_from_file(_frame_path(station_id, 100, "notext"))
		if full100 == null or full100.is_empty() or notext100 == null or notext100.is_empty():
			_expect(false, "full/notext must load for distinctness check: %s" % station_id)
			continue
		var d_fn: float = _sample_diff(full100, notext100)
		_expect(d_fn > 0.05, "%s full-vs-notext s100 must differ (got %.4f)" % [station_id, d_fn])
		var full85: Image = Image.load_from_file(_frame_path(station_id, 85, "full"))
		var full115: Image = Image.load_from_file(_frame_path(station_id, 115, "full"))
		if full85 == null or full85.is_empty() or full115 == null or full115.is_empty():
			_expect(false, "full s85/s115 must load for distinctness check: %s" % station_id)
			continue
		var d_scale: float = _sample_diff(full85, full115)
		_expect(d_scale > 0.001, "%s full s85-vs-s115 must differ (got %.4f)" % [station_id, d_scale])


# ─── 4. Pin pokrycia inspekcji: 12/12 HOLD, zero napraw ─────────────────────

func _check_ocular_coverage() -> void:
	_expect(OCULAR_HOLD.size() == 12, "ocular verdicts must cover 12 station-scales (got %d)" % OCULAR_HOLD.size())
	for station_id in STATIONS:
		for scale_label in SCALE_LABELS:
			var key: String = "%s/s%d" % [station_id, scale_label]
			_expect(OCULAR_HOLD.has(key), "ocular verdict HOLD must exist for %s" % key)


# ─── 5. Runtime: skale 85/100/115 ───────────────────────────────────────────

func _check_runtime_text_scales() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager must exist")
	if state == null:
		return
	var old_scale: float = float(state.get("text_scale"))
	var scales: Array[float] = [0.85, 1.0, 1.15]
	for scale_value in scales:
		state.call("set_text_scale", scale_value, false)
		# Regresja 08 (wzor PKG-0198/0201): trzy akcje na kazdej skali.
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
		# Probka trasy: najjasniejsza / najciemniejsza / final na kazdej skali.
		for sid in RUNTIME_STATIONS:
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
	state.call("set_text_scale", old_scale, false)


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0202 TEXT-SCALE OCULAR PASS: 24 frames intact and distinct, 12/12 HOLD, text scales 85/100/115.")
		quit(0)
	else:
		print("PKG-0202 TEXT-SCALE OCULAR FAIL: %d failures" % _failures.size())
		for failure in _failures:
			print(" - %s" % failure)
		quit(1)
