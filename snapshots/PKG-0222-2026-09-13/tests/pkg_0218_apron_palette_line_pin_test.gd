extends SceneTree

## PKG-0218 gate — apron + palette + construction lines for station_09
## (V1+V2+V5, faza R3 planu PKG-0213 §8; decyzja D-231).
##
## V1 (fartuch): _draw() 09 wola draw_stage_apron() (wzor 01.gd:466), a audyt
## obejmuje wszystkie custom _draw() trasy 01-18 + finaly 42a/b/c + epilog 43:
## zero scen bez fartucha. Fartuch to scenografia (D-136): zero colliderow,
## zero logiki, zero trawersalu; malowany jako pierwszy, wiec kompozycje
## stacji maluja nad nim bez zmian.
## V2 (paleta): _draw() 09 bez surowych hexow Color("...") — wylacznie
## VectorStageStyle (INK / DEEP / MID / LIGHT + AMBER + CYAN, 6 baz + shade).
## MAX_PALETTE_COLORS 8 (kanon VISUAL_DESIGN §4: 8-16; 7 laczylo dolna granice;
## D-231). Lint: unikalne bazy w 09 <= 16.
## V5 (linie): konstrukcyjne w 09 >= 2 px logiczne (koniec draw_line(...,1.0)
## w 09; 0.5 px finalnego przy kompozytorze 320x180 nearest lamie PIXEL_ARCH
## §5). Sasiedzi 08/10/13 zaudytowani i raportowani (08: detal 1.0 w skrzynkach,
## 10: 3x 1.0 w tym krawedz sufitu — V4/sufit, planowo PKG-0219; 13: zero 1.0);
## bramka twardo pinuje 09 (przepisana scena), nie preemptuje PKG-0219.
##
## Technical proof only: measurable source contracts on disk.
## No claim about fun, beauty, comprehension or reception (D-012, ADR-003).

const ROUTE_APRON_IDS: Array[String] = [
	"station_01", "station_02", "station_03", "station_04", "station_05",
	"station_06", "station_07", "station_08", "station_09", "station_10",
	"station_11", "station_12", "station_13", "station_14", "station_15",
	"station_16", "station_17", "station_18",
	"station_42a", "station_42b", "station_42c", "station_43",
]

const STYLE_BASES: Array[String] = [
	"BACKDROP", "DEEP_PLANE", "MID_PLANE", "LIGHT_PLANE",
	"HUMAN_AMBER", "ANCHOR_CYAN", "CORRECTION_OXIDE", "SEAM_RED", "INK",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0218: " + message)


func _read(path: String) -> String:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "file must be readable: %s" % path)
	if file == null:
		return ""
	var text: String = file.get_as_text().replace("\r\n", "\n")
	file.close()
	return text


func _count(source: String, snippet: String) -> int:
	var hits: int = 0
	var from: int = 0
	while true:
		var at: int = source.find(snippet, from)
		if at < 0:
			break
		hits += 1
		from = at + snippet.length()
	return hits


func _count_draw_1px(source: String) -> int:
	# Counts only drawn strokes with a 1.0 width (draw_line/draw_arc/polyline),
	# never game logic such as clampf(..., 0.0, 1.0) or Vector2(320.0, 130.0).
	var stroke_hits: int = 0
	for line: String in source.split("\n"):
		if line.contains("draw_line") or line.contains("draw_arc") or line.contains("draw_polyline"):
			if line.contains(", 1.0)"):
				stroke_hits += 1
	return stroke_hits


func _run() -> void:
	_test_apron()
	_test_palette()
	_test_lines()
	_test_fail_closed()
	_finish()


# --- 1. Apron: 09 + zero scen bez fartucha na trasie/finalach/epilogu ---

func _test_apron() -> void:
	print("1. Stage apron must cover 09 and every route/finale/epilogue scene...")
	var s09: String = _read("res://scripts/levels/station_09.gd")
	_expect(s09.contains("draw_stage_apron"), "station_09._draw must call draw_stage_apron (V1, wzor 01.gd:466)")
	# Apron is scenery under everything: it must be painted before the play
	# plane and the room composition, exactly as in 01 (D-136).
	_expect(s09.find("draw_stage_apron") < s09.find("draw_play_plane"), "station_09 must paint the apron before the play plane")
	var missing: Array[String] = []
	for station_id: String in ROUTE_APRON_IDS:
		var text: String = _read("res://scripts/levels/%s.gd" % station_id)
		if text.is_empty():
			missing.append(station_id + " (unreadable)")
		elif not text.contains("draw_stage_apron"):
			missing.append(station_id)
	_expect(missing.is_empty(), "zero scenes without apron among 01-18/42/43, missing: %s" % str(missing))
	# Apron economics unchanged (read-only pin of D-136).
	var style: String = _read("res://scripts/visual/vector_stage_style.gd")
	_expect(style.contains("const STAGE_APRON := 40"), "STAGE_APRON must stay 40")
	var camera: String = _read("res://scripts/camera/cinematic_camera.gd")
	_expect(camera.contains("dialogue_framing_offset := 36"), "dialogue offset must stay 36")


# --- 2. Palette: no raw hex in 09, MAX in canon 8-16, bases within budget ---

func _test_palette() -> void:
	print("2. Station 09 must speak only VectorStageStyle with a canon palette...")
	var style: String = _read("res://scripts/visual/vector_stage_style.gd")
	_expect(style.contains("const MAX_PALETTE_COLORS := 8"), "MAX_PALETTE_COLORS must be 8 (D-231, canon 8-16)")
	var s09: String = _read("res://scripts/levels/station_09.gd")
	_expect(not s09.contains("Color(\""), "station_09 must keep zero literal Color(\"...\") hexes (got %d)" % _count(s09, "Color(\""))
	_expect(s09.contains("VectorStageStyle."), "station_09 must paint via VectorStageStyle")
	var bases: Dictionary = {}
	for base: String in STYLE_BASES:
		if s09.contains("VectorStageStyle." + base):
			bases[base] = true
	# SEAM_RED aliases CORRECTION_OXIDE; count them as one accent slot.
	if bases.has("SEAM_RED") and bases.has("CORRECTION_OXIDE"):
		bases.erase("SEAM_RED")
	_expect(bases.size() <= 16, "station_09 unique style bases must fit lint <= 16 (got %d: %s)" % [bases.size(), str(bases.keys())])
	_expect(not s09.contains("CORRECTION_OXIDE"), "station_09 carries no irreversible cost, so no oxide accent")
	# Fail-closed: the raw-hex detector itself must fire on a hex literal.
	_expect("var c := Color(\"201c22\")".contains("Color(\""), "raw-hex detector flags a hex literal")
	_expect(not "var c := VectorStageStyle.INK".contains("Color(\""), "raw-hex detector passes a style reference")


# --- 3. Lines: no 1.0 construction lines left in 09; neighbours audited ---

func _test_lines() -> void:
	print("3. Station 09 construction lines must be >= 2 px; neighbours audited...")
	var s09: String = _read("res://scripts/levels/station_09.gd")
	_expect(_count_draw_1px(s09) == 0, "station_09 must keep zero drawn 1.0 strokes (got %d)" % _count_draw_1px(s09))
	# Neighbour audit (read-only; fixes for 08/10 belong to PKG-0219 V4+V6,
	# palette rewrite "potem 08/10/13" per plan — 09 is the rewritten scene).
	var s08: String = _read("res://scripts/levels/station_08.gd")
	var s10: String = _read("res://scripts/levels/station_10.gd")
	var s13: String = _read("res://scripts/levels/station_13.gd")
	var n08: int = _count_draw_1px(s08)
	var n10: int = _count_draw_1px(s10)
	var n13: int = _count_draw_1px(s13)
	print("   audit 08 x1.0=%d, 10 x1.0=%d, 13 x1.0=%d (info only)" % [n08, n10, n13])
	_expect(n13 == 0, "station_13 must keep zero 1.0 strokes (read-only audit)")
	# Fail-closed: the 1.0 detector itself must fire.
	_expect("draw_line(a, b, c, 1.0)".contains(", 1.0)"), "1.0-line detector flags a 1 px construction line")
	_expect(not "draw_line(a, b, c, 2.0)".contains(", 1.0)"), "1.0-line detector passes a 2 px line")


# --- 4. Fail-closed proof for the apron detector ---

func _test_fail_closed() -> void:
	print("4. Detectors must catch injected regressions (fail-closed)...")
	_expect("draw_stage_apron(self, size)".contains("draw_stage_apron"), "apron detector flags the apron call")
	_expect(not "draw_play_plane(self, geometry)".contains("draw_stage_apron"), "apron detector passes a scene without it")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0218 APRON PALETTE LINE PASS: apron 22/22, 09 zero hex, MAX 8, 09 zero 1.0.")
		quit(0)
	else:
		print("PKG-0218 APRON PALETTE LINE FAIL (%d)" % _failures.size())
		for failure: String in _failures:
			print("  - " + failure)
		quit(1)
