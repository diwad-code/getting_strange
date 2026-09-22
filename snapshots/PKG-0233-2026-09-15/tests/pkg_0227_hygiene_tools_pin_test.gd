extends SceneTree

## PKG-0227 hygiene + tools pin (decyzja D-240: T3+T4+T5+V9+V11, zakresowa).
##
## Pinuje wylacznie kontrakty mierzalne na dysku i runtime, nigdy odbior
## (D-012, ADR-003). Zero zmian w monolitach D-217 (GSM/MRP/audio/kompozytor/
## autoloady), zero enum/serialize/routing/progow/InputMap, zero nowych
## adresow/rodzin/faktow. Wzor: PKG-0216 (dowod fail-closed wstrzyknieciem)
## i PKG-0214 (pin wlasnosci).
##
## Fakty pinowane:
## (1) T4: straznicy reentrancji setterow w 5 plikach + lint "pole _x = ..."
## poza plikiem-wlascicielem (fail-closed, wzor traversal_lint);
## (2) T5: centralny pin warstw fizyki 4x4 (scripts/environment/
## physics_layers.gd): 4 nazwy warstw z project.godot, 4 consty stref,
## 4 referencje w zrodlach stref, 4x runtime layer/mask po _ready;
## (3) V9: inwentarz kamer (dokladnie 2 skrypty w scripts/camera/,
## NODE_NAME "Camera", jedno "extends Camera2D") + zero draw_string
## w scripts/levels/*.gd (tekst tylko w ostych warstwach);
## (4) V11: lista capture-prawd w docs/INDEX.md (preview + 0187 + 0190
## + tools/retired/) po przeniesieniu capture_act* do tools/retired/;
## (5) A5/K28: dev-narzedzia audio (audio_5axis_report, audio_browser)
## wystepuja wylacznie w tools/ + tests/ + docs/ (tylko test_mode,
## gra ich nie referencjonuje).

const PHYSICS_PATH := "res://scripts/environment/physics_layers.gd"
const PROJECT_PATH := "res://project.godot"
const INDEX_PATH := "res://docs/INDEX.md"
const SCRIPTS_DIR := "res://scripts"
const LEVELS_DIR := "res://scripts/levels"
const CAMERA_DIR := "res://scripts/camera"

## Pole strzezone -> pliki-wlasciciele (jedyni z prawem do zapisu "_x = ...").
const GUARDED_OWNERS := {
	"_is_anchored": [
		"res://scripts/interactables/anchorable_object.gd",
		"res://scripts/interactables/movable_anchorable_prop.gd",
	],
	"_is_player_in_range": [
		"res://scripts/interactables/anchorable_object.gd",
		"res://scripts/interactables/movable_anchorable_prop.gd",
		"res://scripts/interactables/opening_action_point.gd",
		"res://scripts/interactables/memory_resonance_point.gd",
	],
	"_is_available": [
		"res://scripts/interactables/opening_action_point.gd",
	],
	"_is_resolved": [
		"res://scripts/interactables/opening_action_point.gd",
	],
	"_pass_progress": [
		"res://scripts/visual/vibration_trace_display.gd",
	],
	"_interference_factor": [
		"res://scripts/visual/vibration_trace_display.gd",
	],
}

## Plik -> wymagane strazniki w setterach (dowod reentrancji D-224).
const GUARD_SNIPPETS := {
	"res://scripts/interactables/anchorable_object.gd": [
		"if _is_anchored == value:",
		"if _is_player_in_range == value:",
	],
	"res://scripts/interactables/movable_anchorable_prop.gd": [
		"if _is_anchored == value:",
		"if _is_player_in_range == value:",
	],
	"res://scripts/interactables/opening_action_point.gd": [
		"if _is_player_in_range == value:",
		"if _is_available == value:",
		"if _is_resolved == value:",
	],
	"res://scripts/interactables/memory_resonance_point.gd": [
		"if _is_player_in_range == value:",
	],
	"res://scripts/visual/vibration_trace_display.gd": [
		"if _pass_progress == clamped:",
		"if _interference_factor == clamped:",
	],
}

## Strefa -> [plik, const w PhysicsLayers, oczekiwany layer, oczekiwany mask].
const ZONE_TABLE := {
	"threshold": ["res://scripts/environment/threshold_zone.gd", "THRESHOLD", 0, 1],
	"ladder": ["res://scripts/environment/ladder_zone.gd", "LADDER", 0, 1],
	"return": ["res://scripts/environment/return_zone.gd", "RETURN", 1, 1],
	"opening": ["res://scripts/interactables/opening_action_point.gd", "OPENING", 0, 1],
}

const LAYER_NAMES: Array[String] = ["world", "player", "triggers", "interactables"]

## Katalogi gry, w ktorych dev-narzedzia audio nie maja prawa wystepowac.
const GAME_DIRS: Array[String] = [
	"res://scripts/levels",
	"res://scripts/core",
	"res://scripts/environment",
	"res://scripts/camera",
	"res://scripts/visual",
	"res://scripts/cinematics",
	"res://scripts/player",
	"res://scripts/prototype",
	"res://scripts/interactables",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0227: " + message)


func _read(path: String) -> String:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "file must be readable: %s" % path)
	if file == null:
		return ""
	var text: String = file.get_as_text().replace("\r\n", "\n")
	file.close()
	return text


func _collect_gd(dir_path: String, out: Array[String], recursive: bool) -> void:
	var dir: DirAccess = DirAccess.open(dir_path)
	if dir == null:
		return
	dir.list_dir_begin()
	var fname: String = dir.get_next()
	while fname != "":
		var full: String = dir_path + "/" + fname
		if dir.current_is_dir():
			if recursive and not fname.begins_with("."):
				_collect_gd(full, out, true)
		elif fname.ends_with(".gd"):
			out.append(full)
		fname = dir.get_next()
	dir.list_dir_end()


## Detektor linta T4: zapis "_pole = ..." z wykluczeniem porownan "==".
func _has_direct_write(text: String, field: String) -> bool:
	var re := RegEx.new()
	var err: int = re.compile(field + "\\s*=(?!=)")
	if err != OK:
		return true
	return re.search(text) != null


func _run() -> void:
	_check_setter_lint()
	_check_physics_pin()
	_check_cameras()
	_check_draw_string()
	_check_capture_index()
	_check_devtool_isolation()
	await _check_runtime_physics()
	_finish()


# ─── 1. T4: straznicy + lint zapisow poza wlascicielem ────────────────

func _check_setter_lint() -> void:
	for path: String in GUARD_SNIPPETS.keys():
		var text: String = _read(path)
		if text.is_empty():
			continue
		var snippets: Array = GUARD_SNIPPETS[path]
		for snippet: String in snippets:
			_expect(text.contains(snippet), "setter guard missing in %s: %s" % [path, snippet])
	# Dowod fail-closed na wstrzyknietym tekscie (wzor PKG-0216).
	_expect(_has_direct_write("node._is_anchored = true", "_is_anchored"),
		"lint must flag injected direct write to _is_anchored")
	_expect(not _has_direct_write("if _is_anchored == value:", "_is_anchored"),
		"lint must not flag guard comparison on _is_anchored")
	_expect(not _has_direct_write("if _is_available != value:", "_is_available"),
		"lint must not flag inequality on _is_available")
	# Skan calego scripts/: zapis strzezonego pola tylko u wlasciciela.
	var files: Array[String] = []
	_collect_gd(SCRIPTS_DIR, files, true)
	_expect(not files.is_empty(), "scripts dir must hold gate-readable .gd files")
	for field: String in GUARDED_OWNERS.keys():
		var owners: Array = GUARDED_OWNERS[field]
		for fpath: String in files:
			var content: String = _read(fpath)
			if content.is_empty():
				continue
			if _has_direct_write(content, field) and not owners.has(fpath):
				_expect(false, "direct write to %s outside owner: %s" % [field, fpath])


# ─── 2. T5: centralny pin warstw 4x4 (statyka) ────────────────────────

func _check_physics_pin() -> void:
	var project: String = _read(PROJECT_PATH)
	if not project.is_empty():
		for lname: String in LAYER_NAMES:
			_expect(project.contains("\"" + lname + "\""),
				"project must pin physics layer name: %s" % lname)
	var pin: String = _read(PHYSICS_PATH)
	if not pin.is_empty():
		_expect(pin.contains("const WORLD := 1"), "pin must hold WORLD := 1")
		_expect(pin.contains("const PLAYER := 2"), "pin must hold PLAYER := 2")
		_expect(pin.contains("const TRIGGERS := 3"), "pin must hold TRIGGERS := 3")
		_expect(pin.contains("const INTERACTABLES := 4"), "pin must hold INTERACTABLES := 4")
		_expect(pin.contains("const THRESHOLD := Vector2i(0, 1)"), "pin must hold THRESHOLD (0, 1)")
		_expect(pin.contains("const LADDER := Vector2i(0, 1)"), "pin must hold LADDER (0, 1)")
		_expect(pin.contains("const RETURN := Vector2i(1, 1)"), "pin must hold RETURN (1, 1)")
		_expect(pin.contains("const OPENING := Vector2i(0, 1)"), "pin must hold OPENING (0, 1)")
	for zone: String in ZONE_TABLE.keys():
		var row: Array = ZONE_TABLE[zone]
		var zpath: String = row[0]
		var zconst: String = row[1]
		var ztext: String = _read(zpath)
		if ztext.is_empty():
			continue
		_expect(ztext.contains("PhysicsLayers." + zconst),
			"zone %s must reference central pin PhysicsLayers.%s" % [zone, zconst])


# ─── 3. V9: kamery + zero draw_string ─────────────────────────────────

func _check_cameras() -> void:
	var files: Array[String] = []
	_collect_gd(CAMERA_DIR, files, false)
	var names: Array[String] = []
	for fpath: String in files:
		names.append(fpath.get_file())
	_expect(names.has("cinematic_camera.gd"), "camera dir must hold cinematic_camera.gd")
	_expect(names.has("station_camera_rig.gd"), "camera dir must hold station_camera_rig.gd")
	_expect(names.size() == 2, "camera dir must hold exactly 2 scripts (got %d)" % names.size())
	var rig: String = _read("res://scripts/camera/station_camera_rig.gd")
	if not rig.is_empty():
		_expect(rig.contains('NODE_NAME := "Camera"'), "rig must pin NODE_NAME Camera")
	var all: Array[String] = []
	_collect_gd(SCRIPTS_DIR, all, true)
	var extenders := 0
	for fpath: String in all:
		var content: String = _read(fpath)
		if content.contains("extends Camera2D"):
			extenders += 1
	_expect(extenders == 1, "exactly one script may extend Camera2D (got %d)" % extenders)


func _check_draw_string() -> void:
	var files: Array[String] = []
	_collect_gd(LEVELS_DIR, files, false)
	_expect(not files.is_empty(), "levels dir must hold station scripts")
	for fpath: String in files:
		var content: String = _read(fpath)
		_expect(not content.contains("draw_string("),
			"station script must not draw text under compositor: %s" % fpath)


# ─── 4. V11 + A5/K28: INDEX i izolacja dev-narzedzi ───────────────────

func _check_capture_index() -> void:
	var index: String = _read(INDEX_PATH)
	if index.is_empty():
		return
	_expect(index.contains("capture_preview.gd"), "INDEX must list capture_preview.gd as truth")
	_expect(index.contains("capture_pkg_0187.gd"), "INDEX must list capture_pkg_0187.gd as truth")
	_expect(index.contains("capture_pkg_0190.gd"), "INDEX must list capture_pkg_0190.gd as truth")
	_expect(index.contains("tools/retired/"), "INDEX must list tools/retired/ for legacy captures")


func _check_devtool_isolation() -> void:
	for dir_path: String in GAME_DIRS:
		var files: Array[String] = []
		_collect_gd(dir_path, files, true)
		for fpath: String in files:
			var content: String = _read(fpath)
			if content.is_empty():
				continue
			_expect(not content.contains("audio_browser"),
				"game code must not reference audio_browser: %s" % fpath)
			_expect(not content.contains("audio_5axis_report"),
				"game code must not reference audio_5axis_report: %s" % fpath)


# ─── 5. T5 runtime: 4 strefy x layer/mask po _ready ───────────────────

func _check_runtime_physics() -> void:
	var threshold := ThresholdZone.new()
	root.add_child(threshold)
	var ladder := LadderZone.new()
	root.add_child(ladder)
	var ret := ReturnZone.new()
	root.add_child(ret)
	var opening := OpeningActionPoint.new()
	root.add_child(opening)
	await process_frame
	await process_frame
	_expect(threshold.collision_layer == PhysicsLayers.THRESHOLD.x,
		"runtime threshold layer must be 0")
	_expect(threshold.collision_mask == PhysicsLayers.THRESHOLD.y,
		"runtime threshold mask must be 1")
	_expect(ladder.collision_layer == PhysicsLayers.LADDER.x,
		"runtime ladder layer must be 0")
	_expect(ladder.collision_mask == PhysicsLayers.LADDER.y,
		"runtime ladder mask must be 1")
	_expect(ret.collision_layer == PhysicsLayers.RETURN.x,
		"runtime return layer must be 1")
	_expect(ret.collision_mask == PhysicsLayers.RETURN.y,
		"runtime return mask must be 1")
	_expect(opening.collision_layer == PhysicsLayers.OPENING.x,
		"runtime opening layer must be 0")
	_expect(opening.collision_mask == PhysicsLayers.OPENING.y,
		"runtime opening mask must be 1")
	threshold.queue_free()
	ladder.queue_free()
	ret.queue_free()
	opening.queue_free()


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0227 HYGIENE TOOLS PASS: setter lint + physics 4x4 + cameras + no draw_string + capture INDEX + dev isolation.")
		quit(0)
	else:
		print("PKG-0227 HYGIENE TOOLS FAIL: %d failures" % _failures.size())
		for failure: String in _failures:
			print(" - %s" % failure)
		quit(1)
