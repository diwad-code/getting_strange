extends SceneTree

## PKG-0225 — winiety i finały (faza R8 planu PKG-0213 §8, decyzja D-238).
##
## Proves (V, winiety — rozszerzenie pinu pkg_0190 bez duplikacji):
## (1) katalog ma DOKŁADNIE 7 winiet na stacjach 08/13/15/18/42a/42b/42c —
## brak winiety dla mechaniki 14 i brak duplikacji cold openu (01);
## (2) zero podpisów we wszystkich 7 wpisach (D-214);
## (3) skip jednym wejściem od pierwszego wyświetlenia (interact/ui_accept,
## _can_skip od startu) + runtime skip drugiej winiety (vig_commit) z flagą;
## (4) stany 43 z FULL_STORY §42/43: 3 gałęzie po 5 linii, konkretna czynność
## na końcu, brak narratora, brak tez.
## Proves (N, nośniki finałowe K1–K6, bez nowych assetów/faktów/sygnałów):
## (5) K1 kurtka: beat + ślad w 42A (odwrócona), 42B (pusty hak), 42C (mydło);
## (6) K2 kubek: 18 różnicuje kubek per truth_state + ścieżki _draw bez błędów;
## (7) K3 hełm z garnka w 42C; (8) K5 blizna ciałem w 42B/42C;
## (9) K6 ulica-rym 05/18: ta sama płyta 28x14 z odpryskiem + cykl 18
## spóźniony o jedną klatkę; (10) nowe beaty to faktyczne L1-obserwacje
## (Tier/kind/scope) bez tez D-214/D-219.
## K4 (margines 15) pinuje bramka pkg_0223 — tu nie duplikowano.
## K7 (palimpsest 42B) pinuje bramka pkg_0216 — tu nie duplikowano.
## 37 (hełm-legacy) celowo nietknięta: poza blastem 42/43 (patrz raport).

const CinematicCatalogScript := preload("res://scripts/cinematics/cinematic_catalog.gd")

const VIGNETTE_STATIONS: Array[String] = [
	"station_08", "station_13", "station_15", "station_18",
	"station_42a", "station_42b", "station_42c",
]

# PKG-0242 (R1): the owner's PKG-0239 epilogue closes each branch on a
# concrete act or an identifiable source (KROK 16 acceptance), not on the
# narrator's paraphrase that PKG-0225 pinned.
const EXPECTED_LAST_LINES := {
	"force_home": "Wpiszę datę. Tę rubrykę zostawię pustą.",
	"close_equal_recover_local": "Niewysłane: Jadę. Adresat: brak w sieci.",
	"mutual_passage": "Postaw tutaj nasz kubek.",
}

const THESIS_STEMS: Array[String] = [
	"sens", "wybacz", "morał", "moral", "lekcja", "los tak",
	"świat mówi", "prawda jest", "znaczy to", "po to tu", "cierpienie",
]

const NEW_BEATS: Array[String] = [
	"s42a_jacket", "s42b_hook", "s42b_shirt",
	"s42c_jacket", "s42c_helmet", "s42c_shirt", "s05_ucp_sign",
]

const NEW_BEAT_PL: Array[String] = [
	"Na oparciu kurtka odwrócona na lewą stronę. Marta nic nie mówi.",
	"Hak po kurtce jest pusty.",
	"Na oparciu koszula ściągnięta w dół. Boku nie pokazuje.",
	"Kurtka na haku pachnie cudzym mydłem.",
	"Przy imadle hełm z garnka. Ten sam, o który pytałam.",
	"Przy imadle koszula ściągnięta w dół. Boku nie pokazuje.",
	"Szyld nocnych prac UCP. Nowy wykonawca.",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("PKG-0225: " + message)


func _run() -> void:
	_check_vignette_placement()
	_check_zero_captions()
	_check_skip_contract()
	_check_station_43_branches()
	await _check_commit_skip_runtime()
	_check_finale_beats_registered()
	_check_finale_visual_markers()
	_check_truth_cups()
	await _check_truth_cup_draw_paths()
	_check_street_rhyme()
	_check_scene_loads()
	if _failures.is_empty():
		print("PKG-0225 VIGNETTES FINALES PASS: placement, skip, 43 states and K1/K2/K3/K5/K6 carriers verified")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0225 FAILURE: " + failure)
		quit(1)


func _read(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "file must be readable: %s" % path)
	if file == null:
		return ""
	var source := file.get_as_text()
	file.close()
	return source


# ─── V: placement / captions / skip ─────────────────────────────────────────

func _check_vignette_placement() -> void:
	var ids := CinematicCatalogScript.all_ids()
	_expect(ids.size() == 7, "catalog must list exactly 7 vignettes, found %d" % ids.size())
	var stations: Array[String] = []
	for id in ids:
		stations.append(String(CinematicCatalogScript.entry(id).get("station_id", "")))
	stations.sort()
	var expected := VIGNETTE_STATIONS.duplicate()
	expected.sort()
	_expect(stations == expected, "vignette stations must be 08/13/15/18/42a/42b/42c, found %s" % str(stations))
	for station_id in stations:
		_expect(station_id != "station_14", "no vignette may target the Station 14 mechanics lesson")
		_expect(station_id != "station_01", "no vignette may duplicate the cold open")


func _check_zero_captions() -> void:
	for id in CinematicCatalogScript.all_ids():
		var entry := CinematicCatalogScript.entry(id)
		var captions: Array = entry.get("captions", [])
		_expect(captions.size() == 2, "%s must keep exactly 2 caption slots, found %d" % [id, captions.size()])
		for caption in captions:
			_expect(String(caption).strip_edges().is_empty(), "%s caption must stay empty (D-214 zero-podpisow), found %s" % [id, String(caption)])


func _check_skip_contract() -> void:
	var source := _read("res://scripts/cinematics/cinematic_vignette.gd")
	_expect(source.contains("&\"interact\""), "vignette skip must accept the semantic interact verb")
	_expect(source.contains("&\"ui_accept\""), "vignette skip must accept ui_accept on the same input")
	_expect(source.contains("var _can_skip := true"), "vignette must be skippable from the first showing")


func _check_commit_skip_runtime() -> void:
	const CinematicVignetteScript := preload("res://scripts/cinematics/cinematic_vignette.gd")
	var state := root.get_node_or_null("GameStateManager")
	if state == null:
		_failures.append("GameStateManager autoload not present; cannot run vignette skip check")
		return
	var entry := CinematicCatalogScript.entry(&"vig_commit")
	var vignette: CanvasLayer = CinematicVignetteScript.new()
	vignette.call("setup", &"vig_commit", entry, null)
	root.add_child(vignette)
	await process_frame
	var skipped: bool = vignette.call("skip_for_test")
	_expect(skipped, "vig_commit must be skippable from the first showing like vig_synthesis")
	await process_frame
	_expect(bool(state.call("is_cinematic_seen", &"vig_commit")), "vig_commit skip must end with the seen-flag set")
	state.cinematics_seen.erase("vig_commit")


# ─── V/N: stany 43 ──────────────────────────────────────────────────────────

func _check_station_43_branches() -> void:
	var packed := load("res://scenes/levels/station_43.tscn") as PackedScene
	_expect(packed != null, "station_43.tscn must load")
	if packed == null:
		return
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	await process_frame
	for family in EXPECTED_LAST_LINES.keys():
		station.set("ending_family", String(family))
		station.call("_setup_dialogue_for_branch")
		var lines := station.get("dialogue_lines") as Array
		_expect(lines.size() == 5, "43/%s must carry exactly 5 epilogue lines, found %d" % [family, lines.size()])
		if lines.size() != 5:
			continue
		for line in lines:
			var entry := line as Dictionary
			_expect(String(entry.get("speaker", "")) != "NARRATOR", "43/%s must have no narrator (FULL_STORY 43)" % family)
		var last := lines[4] as Dictionary
		var expected: String = EXPECTED_LAST_LINES[family]
		_expect(String(last.get("text", "")) == expected, "43/%s must end with the concrete act, not a thesis" % family)
		_check_no_thesis(String(last.get("text", "")), "43/%s last line" % family)
	station.free()
	await process_frame


func _check_no_thesis(text: String, where: String) -> void:
	var lowered := text.to_lower()
	for stem in THESIS_STEMS:
		_expect(not lowered.contains(stem), "%s carries a forbidden thesis stem: %s" % [where, stem])


# ─── N: beaty finałowe ──────────────────────────────────────────────────────

func _check_finale_beats_registered() -> void:
	var files := {
		"s42a_jacket": "res://scripts/levels/station_42a.gd",
		"s42b_hook": "res://scripts/levels/station_42b.gd",
		"s42b_shirt": "res://scripts/levels/station_42b.gd",
		"s42c_jacket": "res://scripts/levels/station_42c.gd",
		"s42c_helmet": "res://scripts/levels/station_42c.gd",
		"s42c_shirt": "res://scripts/levels/station_42c.gd",
		"s05_ucp_sign": "res://scripts/levels/station_05.gd",
	}
	for beat_id in files.keys():
		var source := _read(String(files[beat_id]))
		var pattern := "&\"%s\", GuidanceBeat.Tier.L1_REACTION, &\"observation\", &\"factual\"" % beat_id
		_expect(source.contains(pattern), "%s must be registered as an L1 factual observation" % beat_id)
	for i in NEW_BEATS.size():
		_check_no_thesis(NEW_BEAT_PL[i], "beat %s PL" % NEW_BEATS[i])
		_expect(not String(NEW_BEAT_PL[i]).strip_edges().is_empty(), "beat %s needs a non-empty PL text" % NEW_BEATS[i])


func _check_finale_visual_markers() -> void:
	var markers := {
		"res://scripts/levels/station_42a.gd": ["PKG-0225 (K1)", "s42a_jacket"],
		"res://scripts/levels/station_42b.gd": ["PKG-0225 (K1)", "PKG-0225 (K5)", "s42b_hook", "s42b_shirt"],
		"res://scripts/levels/station_42c.gd": ["PKG-0225 (K1)", "PKG-0225 (K3", "PKG-0225 (K5)", "s42c_jacket", "s42c_helmet", "s42c_shirt"],
	}
	for path in markers.keys():
		var source := _read(String(path))
		for marker in (markers[path] as Array):
			_expect(source.contains(String(marker)), "%s must carry the visual marker %s" % [path, marker])


# ─── N: K2 kubek per truth_state ────────────────────────────────────────────

func _check_truth_cups() -> void:
	var source := _read("res://scripts/levels/station_18.gd")
	_expect(source.contains("marta_truth_state == MARTA_FULL"), "18 must place the cup pair for the full truth")
	_expect(source.contains("marta_truth_state == MARTA_PARTIAL"), "18 must hide the second cup for the partial truth")
	_expect(source.contains("Rect2(318.0, 264.0, 10.0, 4.0)"), "18 must overturn the second cup for the withheld truth")


func _check_truth_cup_draw_paths() -> void:
	var packed := load("res://scenes/levels/station_18.tscn") as PackedScene
	_expect(packed != null, "station_18.tscn must load")
	if packed == null:
		return
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	await process_frame
	station.set("is_marta_truth_disclosed", true)
	for truth_state in [&"full", &"partial", &"withheld", &""]:
		station.set("marta_truth_state", truth_state)
		station.queue_redraw()
		await process_frame
		await process_frame
	station.free()
	await process_frame


# ─── N: K6 ulica-rym ────────────────────────────────────────────────────────

func _check_street_rhyme() -> void:
	var src05 := _read("res://scripts/levels/station_05.gd")
	var src18 := _read("res://scripts/levels/station_18.gd")
	_expect(src05.contains("const RHYME_SIGN_SIZE := Vector2(28.0, 14.0)"), "05 must define the rhyme plate 28x14")
	_expect(src18.contains("const RHYME_SIGN_SIZE := Vector2(28.0, 14.0)"), "18 must reuse the same rhyme plate 28x14")
	_expect(src05.contains("RHYME_BLINK_SPEED"), "05 must run the base rhyme light cycle")
	_expect(src18.contains("RHYME_BLINK_SPEED"), "18 must run the same rhyme light cycle as 05")
	_expect(src18.contains("const RHYME_FRAME_DELAY := 1.6 / 60.0"), "18 must delay its cycle by exactly one physics frame")
	_expect(src18.contains("RHYME_BLINK_SPEED + RHYME_FRAME_DELAY"), "18 lamp must apply the one-frame delay")
	_expect(src05.contains("s05_ucp_sign"), "05 must register the UCP sign observation beat")


func _check_scene_loads() -> void:
	for station_id in ["station_05", "station_42a", "station_42b", "station_42c"]:
		var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
		_expect(packed != null, "%s.tscn must load" % station_id)
		if packed == null:
			continue
		var station := packed.instantiate() as Node2D
		root.add_child(station)
		await process_frame
		await process_frame
		station.queue_redraw()
		await process_frame
		station.free()
		await process_frame
