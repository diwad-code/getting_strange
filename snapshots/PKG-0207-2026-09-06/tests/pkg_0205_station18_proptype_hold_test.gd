extends SceneTree

## PKG-0205 gate — decyzja D-220: `station_18/MartaTruthTable` ZOSTAJE na
## efektywnym `prop_type = 0` (PHOTOGRAPH). HOLD, nie naprawa.
##
## Otwarty fakt danych z PKG-0200: blok `MartaTruthTable` w
## `scenes/levels/station_18.tscn` nie ma linii `prop_type`, wiec jedzie na
## domyslnym eksporcie `MemoryResonancePoint.prop_type = PHOTOGRAPH`.
## Dyspozycja wlasciciela delegowana na ten pakiet (decyzja w imieniu
## wlasciciela, kierunek: dobro projektu) rozstrzyga HOLD:
## (1) zaden z 203 istniejacych rendererow nie jest „witryna sklepu przy
## ulicy" — `SHOWCASE_VITRINE` (48) to 34x46 px instytucjonalnej gabloty UCP
## z bialymi dokumentami i naglowkiem, jasna plama na ciemnej ulicy
## (kadr 0203 s115: gleboki granat, bursztynowa latarnia); `PHOTOGRAPH` (0)
## to mala 24x20 px przygaszona ramka, ktora nie rozpycha sylwety
## trzymanej przez 0198/0201/0202/0203 HOLD;
## (2) zamiana typu to tez zamiana dzwieku (PHOTOGRAPH nie ma wlasnej galezi
## triggera i gra generycznym `_memory_sound`; 48 gralby `paper_rustle`),
## czyli zmiana audio bez dyspozycji audio — poza zakresem;
## (3) nowy typ w enum to nowy kontrakt (enum + serialize IDs + 203
## delegacje D-218) — zakazany bez jawnego zlecenia wlasciciela;
## (4) diegeze niesie rysowana przez stacje witryna 92x70
## (`station_18.gd:_draw_marta_window`); wezel MRP niesie interakcje
## (clue/trigger po `resonance_id`, nie po typie — logika stacji ignoruje
## `prop_type` poza przekazaniem dalej w `clue_inspected`).
## Bez nowej tezy autorskiej (D-214/D-219); dowod techniczny, nie odbiorczy
## (D-012, ADR-003). Zmiana wartosci na niezerowa wymaga nowego pakietu
## z kadrami przed/po normalnym sterownikiem i aktualizacja D-220.
##
## Bramka pinuje wylacznie kontrakty mierzalne: efektywne typy trojki
## ulicy 18 (53/0/16), tozsamosc wezla (id/tytuly), porzadek na osi X,
## istnienie obu rendererow i dispatchu 0 -> `_draw_photograph` oraz
## ladowanie stacji + 2 klatki bez bledow. Logike (forecast/truth/commit)
## kryje istniejacy smoke (`smoke_test.gd:_test_station_18`).

const STATION_PATH := "res://scenes/levels/station_18.tscn"
const MRP_PATH := "res://scripts/interactables/memory_resonance_point.gd"
const RENDERER_PATH := "res://scripts/interactables/mrp_legacy_renderer.gd"

const EXPECTED_FORECAST_TYPE := 53
const EXPECTED_TRUTH_TYPE := 0
const EXPECTED_COMMIT_TYPE := 16

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0205: " + message)


func _run() -> void:
	_check_tscn_effective_types()
	_check_renderer_dispatch_exists()
	await _check_runtime_station_18()
	_finish()


# ─── 1. Tekst .tscn: efektywne typy trojki ──────────────────────────────
#
# Blok bez linii `prop_type` znaczy default eksportu (0). Jawna linia musi
# niec 0 — cokolwiek innego to zmiana wizualno-dzwiekowa spoza D-220.

func _node_block(text: String, node_name: String) -> String:
	var marker: String = "[node name=\"" + node_name + "\""
	var start: int = text.find(marker)
	if start < 0:
		return ""
	var next: int = text.find("[node name=\"", start + marker.length())
	if next < 0:
		return text.substr(start)
	return text.substr(start, next - start)


func _block_prop_type(block: String) -> int:
	if block.is_empty():
		return -1
	for line: String in block.split("\n"):
		var stripped: String = line.strip_edges()
		if stripped.begins_with("prop_type"):
			var parts: PackedStringArray = stripped.split("=")
			if parts.size() == 2:
				return int(parts[1].strip_edges())
	return 0


func _check_tscn_effective_types() -> void:
	var file: FileAccess = FileAccess.open(STATION_PATH, FileAccess.READ)
	_expect(file != null, "station_18.tscn must be readable")
	if file == null:
		return
	var text: String = file.get_as_text()
	file.close()
	var forecast_block: String = _node_block(text, "ForecastComparator")
	var truth_block: String = _node_block(text, "MartaTruthTable")
	var commit_block: String = _node_block(text, "MethodCommitPost")
	_expect(not forecast_block.is_empty(), "ForecastComparator node must exist")
	_expect(not truth_block.is_empty(), "MartaTruthTable node must exist")
	_expect(not commit_block.is_empty(), "MethodCommitPost node must exist")
	_expect(_block_prop_type(forecast_block) == EXPECTED_FORECAST_TYPE, "ForecastComparator effective prop_type must be 53 (got %d)" % _block_prop_type(forecast_block))
	_expect(_block_prop_type(truth_block) == EXPECTED_TRUTH_TYPE, "MartaTruthTable effective prop_type must be 0 PHOTOGRAPH (got %d)" % _block_prop_type(truth_block))
	_expect(_block_prop_type(commit_block) == EXPECTED_COMMIT_TYPE, "MethodCommitPost effective prop_type must be 16 (got %d)" % _block_prop_type(commit_block))
	_expect(truth_block.contains("resonance_id = \"marta_truth_table\""), "MartaTruthTable resonance_id must stay marta_truth_table")
	_expect(truth_block.contains("prop_title = \"Witryna Marty\""), "MartaTruthTable title must stay Witryna Marty")


# ─── 2. Mechanizm decyzji istnieje (oba rendery + dispatch) ─────────────

func _check_renderer_dispatch_exists() -> void:
	var renderer_file: FileAccess = FileAccess.open(RENDERER_PATH, FileAccess.READ)
	_expect(renderer_file != null, "mrp_legacy_renderer.gd must be readable")
	var renderer_text: String = ""
	if renderer_file != null:
		renderer_text = renderer_file.get_as_text().replace("\r\n", "\n")
		renderer_file.close()
	_expect(renderer_text.contains("static func draw_photograph"), "helper must keep draw_photograph renderer")
	_expect(renderer_text.contains("static func draw_showcase_vitrine"), "helper must keep draw_showcase_vitrine renderer")
	var mrp_file: FileAccess = FileAccess.open(MRP_PATH, FileAccess.READ)
	_expect(mrp_file != null, "memory_resonance_point.gd must be readable")
	var mrp_text: String = ""
	if mrp_file != null:
		mrp_text = mrp_file.get_as_text().replace("\r\n", "\n")
		mrp_file.close()
	_expect(mrp_text.contains("PropType.PHOTOGRAPH:\n\t\t\t_draw_photograph()"), "facade must dispatch PHOTOGRAPH to _draw_photograph")
	_expect(mrp_text.contains("PropType.SHOWCASE_VITRINE:\n\t\t\t_draw_showcase_vitrine()"), "facade must dispatch SHOWCASE_VITRINE to _draw_showcase_vitrine")


# ─── 3. Runtime: stacja laduje sie, trojka stoi, 2 klatki bez bledow ────

func _check_runtime_station_18() -> void:
	var packed: PackedScene = load(STATION_PATH) as PackedScene
	_expect(packed != null, "station_18.tscn must load")
	if packed == null:
		return
	var station: Node2D = packed.instantiate() as Node2D
	_expect(station != null, "station_18 must instantiate")
	if station == null:
		return
	root.add_child(station)
	await process_frame
	await process_frame
	var props: Node = station.get_node_or_null("Props")
	_expect(props != null, "station_18 Props must exist")
	if props != null:
		var forecast: Node = props.get_node_or_null("ForecastComparator")
		var truth: Node = props.get_node_or_null("MartaTruthTable")
		var commit: Node = props.get_node_or_null("MethodCommitPost")
		_expect(forecast != null and int(forecast.get("prop_type")) == EXPECTED_FORECAST_TYPE, "runtime ForecastComparator must be 53")
		_expect(truth != null and int(truth.get("prop_type")) == EXPECTED_TRUTH_TYPE, "runtime MartaTruthTable must be 0 PHOTOGRAPH")
		_expect(commit != null and int(commit.get("prop_type")) == EXPECTED_COMMIT_TYPE, "runtime MethodCommitPost must be 16")
		if forecast is Node2D and truth is Node2D and commit is Node2D:
			var fx: float = (forecast as Node2D).position.x
			var tx: float = (truth as Node2D).position.x
			var cx: float = (commit as Node2D).position.x
			_expect(fx < tx and tx < cx, "street trio must keep X order 176 < 332 < 484 (got %.1f/%.1f/%.1f)" % [fx, tx, cx])
	station.free()
	await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0205 STATION18 PROPTYPE HOLD PASS: trio 53/0/16, dispatch intact, station_18 loads.")
		quit(0)
	else:
		print("PKG-0205 STATION18 PROPTYPE HOLD FAIL: %d failures" % _failures.size())
		for failure: String in _failures:
			print(" - %s" % failure)
		quit(1)
