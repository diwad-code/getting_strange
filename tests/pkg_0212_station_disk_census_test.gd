extends SceneTree

## PKG-0212 gate — spis stacji na dysku: skrypty ↔ sceny 1:1 (decyzja D-226).
##
## Pinuje wylacznie kontrakty mierzalne na dysku i runtime, nigdy slusznosc
## przyszlej ekstrakcji ani odbior (D-012, ADR-003). Zero zmian w scripts/,
## scenes/, konfiguracji: bramka czyta katalogi scripts/levels i
## scenes/levels tekstowo (read-only) plus 2 klatki runtime.
## Wzor: PKG-0206 (normalizacja CRLF, jawne typy, brak chr()) i PKG-0211
## (spis statyczny + kontrakty tekstowe + runtime frames).
##
## Fakty pinowane (stan na dysku po PKG-0211):
## (1) 45 skryptow stacji scripts/levels/station_*.gd o ID:
##     station_01..station_41 + station_42a/b/c + station_43;
## (2) 45 scen scenes/levels/station_*.tscn o tych samych ID — zbiory rowne
##     w obie strony (zero sierot, zero wiszacych);
## (3) 4 helpery nie-stacyjne w scripts/levels: atmosphere_rig.gd,
##     creative_scene_lines.gd, creative_scene_presentation.gd oraz
##     narrative_repair_rules.gd (PKG-0239, wlasciciel: jedna regula zgody,
##     prawdy i metody dla 17/18/42; PKG-0242 kontrolowana aktualizacja 3 -> 4);
## (4) kazdy skrypt stacji definiuje class_name (Station01..Station43,
##     Station42A/B/C) i extends Node2D;
## (5) kazda scena referencjonuje wlasny skrypt stacji przez ext_resource
##     (path="res://scripts/levels/station_XX.gd");
## (6) pokrycie dyskowe segmentow kampanii: trasa 01-18, legacy 19-41,
##     finaly 42a/b/c, epilog 43.

const SCRIPTS_DIR := "res://scripts/levels"
const SCENES_DIR := "res://scenes/levels"

const EXPECTED_STATION_N := 45
const EXPECTED_HELPER_N := 4

const HELPER_NAMES: Array[String] = [
	"atmosphere_rig.gd",
	"creative_scene_lines.gd",
	"creative_scene_presentation.gd",
	"narrative_repair_rules.gd",
]

const FINALE_IDS: Array[String] = [
	"station_42a",
	"station_42b",
	"station_42c",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0212: " + message)


func _read(path: String) -> String:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "file must be readable: %s" % path)
	if file == null:
		return ""
	var text: String = file.get_as_text().replace("\r\n", "\n")
	file.close()
	return text


func _list_files(dir_path: String, suffix: String) -> Array[String]:
	var out: Array[String] = []
	var dir: DirAccess = DirAccess.open(dir_path)
	_expect(dir != null, "dir must be listable: %s" % dir_path)
	if dir == null:
		return out
	dir.list_dir_begin()
	var fname: String = dir.get_next()
	while fname != "":
		if fname.ends_with(suffix) and not dir.current_is_dir():
			out.append(fname)
		fname = dir.get_next()
	dir.list_dir_end()
	return out


func _expected_station_ids() -> Array[String]:
	var out: Array[String] = []
	for i: int in range(1, 42):
		out.append("station_%02d" % i)
	for fid: String in FINALE_IDS:
		out.append(fid)
	out.append("station_43")
	return out


func _expected_class_name(station_id: String) -> String:
	if station_id == "station_42a":
		return "Station42A"
	if station_id == "station_42b":
		return "Station42B"
	if station_id == "station_42c":
		return "Station42C"
	var num_part: String = station_id.replace("station_", "")
	return "Station" + num_part


func _run() -> void:
	_check_disk_sets()
	_check_script_contracts()
	_check_scene_contracts()
	_check_campaign_coverage()
	await _check_runtime_frames()
	_finish()


# ─── 1. Zbiory dyskowe: 45 skryptow ↔ 45 scen, 3 helpery ─────────────────

func _check_disk_sets() -> void:
	var scripts: Array[String] = _list_files(SCRIPTS_DIR, ".gd")
	var station_scripts: Array[String] = []
	var helpers: Array[String] = []
	for fname: String in scripts:
		if fname.begins_with("station_"):
			station_scripts.append(fname)
		else:
			helpers.append(fname)
	_expect(station_scripts.size() == EXPECTED_STATION_N,
		"scripts/levels must hold %d station scripts (got %d)" % [EXPECTED_STATION_N, station_scripts.size()])
	_expect(helpers.size() == EXPECTED_HELPER_N,
		"scripts/levels must hold %d non-station helpers (got %d: %s)" % [EXPECTED_HELPER_N, helpers.size(), ", ".join(helpers)])
	for want: String in HELPER_NAMES:
		_expect(helpers.has(want), "helper missing in scripts/levels: %s" % want)
	var scenes: Array[String] = _list_files(SCENES_DIR, ".tscn")
	_expect(scenes.size() == EXPECTED_STATION_N,
		"scenes/levels must hold %d station scenes (got %d)" % [EXPECTED_STATION_N, scenes.size()])
	var script_ids: Dictionary = {}
	for fname: String in station_scripts:
		script_ids[fname.replace(".gd", "")] = true
	var scene_ids: Dictionary = {}
	for fname: String in scenes:
		scene_ids[fname.replace(".tscn", "")] = true
	_expect(script_ids.size() == EXPECTED_STATION_N, "station script IDs must be unique")
	_expect(scene_ids.size() == EXPECTED_STATION_N, "station scene IDs must be unique")
	for want_id: String in _expected_station_ids():
		_expect(script_ids.has(want_id), "station script missing on disk: %s.gd" % want_id)
		_expect(scene_ids.has(want_id), "station scene missing on disk: %s.tscn" % want_id)
	for got_id: String in script_ids.keys():
		_expect(scene_ids.has(got_id), "orphan station script without scene: %s" % String(got_id))
	for got_id: String in scene_ids.keys():
		_expect(script_ids.has(got_id), "orphan station scene without script: %s" % String(got_id))


# ─── 2. Skrypty stacji: class_name + extends Node2D ──────────────────────

func _check_script_contracts() -> void:
	for station_id: String in _expected_station_ids():
		var path: String = SCRIPTS_DIR + "/" + station_id + ".gd"
		var src: String = _read(path)
		if src.is_empty():
			continue
		_expect(src.contains("class_name " + _expected_class_name(station_id)),
			"%s must define class_name %s" % [path, _expected_class_name(station_id)])
		_expect(src.contains("extends Node2D"),
			"%s must extend Node2D" % path)


# ─── 3. Sceny: referencja wlasnego skryptu stacji ────────────────────────

func _check_scene_contracts() -> void:
	for station_id: String in _expected_station_ids():
		var path: String = SCENES_DIR + "/" + station_id + ".tscn"
		var src: String = _read(path)
		if src.is_empty():
			continue
		_expect(src.contains("res://scripts/levels/" + station_id + ".gd"),
			"%s must reference its station script" % path)


# ─── 4. Pokrycie segmentow kampanii na dysku ─────────────────────────────

func _check_campaign_coverage() -> void:
	for i: int in range(1, 19):
		var rid: String = "station_%02d" % i
		_expect(FileAccess.file_exists(SCRIPTS_DIR + "/" + rid + ".gd"), "route script missing: %s" % rid)
		_expect(FileAccess.file_exists(SCENES_DIR + "/" + rid + ".tscn"), "route scene missing: %s" % rid)
	for i: int in range(19, 42):
		var lid: String = "station_%02d" % i
		_expect(FileAccess.file_exists(SCRIPTS_DIR + "/" + lid + ".gd"), "legacy script missing: %s" % lid)
		_expect(FileAccess.file_exists(SCENES_DIR + "/" + lid + ".tscn"), "legacy scene missing: %s" % lid)
	for fid: String in FINALE_IDS:
		_expect(FileAccess.file_exists(SCRIPTS_DIR + "/" + fid + ".gd"), "finale script missing: %s" % fid)
		_expect(FileAccess.file_exists(SCENES_DIR + "/" + fid + ".tscn"), "finale scene missing: %s" % fid)
	_expect(FileAccess.file_exists(SCRIPTS_DIR + "/station_43.gd"), "epilogue script missing: station_43")
	_expect(FileAccess.file_exists(SCENES_DIR + "/station_43.tscn"), "epilogue scene missing: station_43")


# ─── 5. Runtime: 2 klatki bez bledow ─────────────────────────────────────

func _check_runtime_frames() -> void:
	var state: Node = root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload must exist")
	await process_frame
	await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0212 STATION DISK CENSUS PASS: %d scripts <-> %d scenes 1:1, %d helpers, class/extends/scene-ref/campaign coverage verified." % [EXPECTED_STATION_N, EXPECTED_STATION_N, EXPECTED_HELPER_N])
		quit(0)
	else:
		print("PKG-0212 STATION DISK CENSUS FAIL: %d failures" % _failures.size())
		for failure: String in _failures:
			print(" - %s" % failure)
		quit(1)
