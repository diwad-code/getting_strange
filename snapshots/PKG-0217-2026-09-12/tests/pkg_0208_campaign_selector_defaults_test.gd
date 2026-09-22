extends SceneTree

## PKG-0208 gate — pin selektora kampanii i defaultów prezentacji
## (decyzja D-223: HOLD logiki i obrazu, selektor/routing/defaulty ZAPINOWANE).
##
## Pinuje wylacznie kontrakty mierzalne na dysku i runtime, nigdy slusznosc
## przyszlej ekstrakcji ani odbior (D-012, ADR-003). Zero zmian w scripts/,
## scenes/, konfiguracji: bramka czyta game_state_manager.gd tekstowo oraz
## przez constant map zaladowanego skryptu i cztery dokumenty handoffu.
## Wzor: PKG-0206 (normalizacja CRLF, jawne typy, brak chr()) i PKG-0207
## (handoff contains, runtime 2 klatki).
##
## Fakty pinowane (stan po tym pakiecie):
## (1) routing: CAMPAIGN_ROUTE 18 (01-18 w kolejnosci), LEGACY 23 (19-41),
## FINALES 3 (42a/b/c), EPILOGUE station_43, SELECTOR 20 (01-18 + 42a + 43
## w kolejnosci; bez 42b/42c i bez legacy), OPERATION_TO_FINALE A/B/C,
## limity 18/41;
## (2) defaulty: volume 0.85, CPS 42.0, skale MIN 0.85 < DEFAULT 1.0 < MAX
## 1.15, REDUCED_MOTION false, REMAPPABLE 5 akcji;
## (3) handoff: SESSION_LOG konczy sie PKG-0208, CURRENT_STATE nazywa PKG-0208,
## DECISION_LOG zawiera D-223, NEXT_SESSION_PROMPT nazywa PKG-0208 i PKG-0209;
## (4) runtime: autoload GameStateManager istnieje, constant map trzyma te
## same rozmiary/wartosci, 2 klatki bez bledow.

const GSM_PATH := "res://scripts/core/game_state_manager.gd"
const SESSION_PATH := "res://docs/SESSION_LOG.md"
const STATE_PATH := "res://docs/CURRENT_STATE.md"
const DECISIONS_PATH := "res://docs/DECISION_LOG.md"
const PROMPT_PATH := "res://docs/NEXT_SESSION_PROMPT.md"

const EXPECTED_ROUTE_N := 18
const EXPECTED_LEGACY_N := 23
const EXPECTED_FINALES_N := 3
const EXPECTED_SELECTOR_N := 20
const EXPECTED_TRANSITION_LIMIT := 18
const EXPECTED_LEGACY_LIMIT := 41

const EXPECTED_ROUTE_FIRST := "station_01"
const EXPECTED_ROUTE_LAST := "station_18"
const EXPECTED_LEGACY_FIRST := "station_19"
const EXPECTED_LEGACY_LAST := "station_41"
const EXPECTED_EPILOGUE := "station_43"
const EXPECTED_SELECTOR_TAIL_A := "station_42a"
const EXPECTED_SELECTOR_TAIL_EP := "station_43"

const EXPECTED_REMAP: Array[String] = [
	"jump",
	"interact",
	"pause",
	"restart",
	"trigger_correction",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0208: " + message)


func _read(path: String) -> String:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "file must be readable: %s" % path)
	if file == null:
		return ""
	var text: String = file.get_as_text().replace("\r\n", "\n")
	file.close()
	return text


func _array_entries(source: String, const_name: String) -> Array[String]:
	var out: Array[String] = []
	var anchor: int = source.find(const_name)
	_expect(anchor >= 0, "const missing: %s" % const_name)
	if anchor < 0:
		return out
	var open_rel: int = source.find("= [", anchor)
	_expect(open_rel > anchor, "array must open with '= [' for %s" % const_name)
	if open_rel <= anchor:
		return out
	var body_start: int = open_rel + 3
	var close_rel: int = source.find("]", body_start)
	_expect(close_rel > body_start, "array must close for %s" % const_name)
	if close_rel <= body_start:
		return out
	var body: String = source.substr(body_start, close_rel - body_start)
	var from: int = 0
	var marker: String = "&\""
	while true:
		var at: int = body.find(marker, from)
		if at < 0:
			break
		var start: int = at + marker.length()
		var stop: int = body.find("\"", start)
		if stop < 0:
			break
		out.append(body.substr(start, stop - start))
		from = stop + 1
	return out


func _run() -> void:
	_check_routing_text()
	_check_defaults_text()
	await _check_runtime_constants()
	_check_handoff()
	await _check_runtime_frames()
	_finish()


# ─── 1. Routing tekstowo ───────────────────────────────────────────────

func _check_routing_text() -> void:
	var source: String = _read(GSM_PATH)
	if source.is_empty():
		return
	var route: Array[String] = _array_entries(source, "CAMPAIGN_ROUTE:")
	_expect(route.size() == EXPECTED_ROUTE_N, "CAMPAIGN_ROUTE must hold 18 (got %d)" % route.size())
	if route.size() == EXPECTED_ROUTE_N:
		_expect(route[0] == EXPECTED_ROUTE_FIRST, "route must start at station_01")
		_expect(route[17] == EXPECTED_ROUTE_LAST, "route must end at station_18")
		for i: int in range(18):
			var want: String = "station_%02d" % (i + 1)
			_expect(route[i] == want, "route entry %d must be %s (got %s)" % [i, want, route[i]])
		_expect(not route.has("station_19"), "route must not contain legacy station_19")
		_expect(not route.has("station_42a"), "route must not contain station_42a")
		_expect(not route.has("station_43"), "route must not contain station_43")
	var legacy: Array[String] = _array_entries(source, "CAMPAIGN_LEGACY_STATIONS")
	_expect(legacy.size() == EXPECTED_LEGACY_N, "LEGACY must hold 23 (got %d)" % legacy.size())
	if legacy.size() == EXPECTED_LEGACY_N:
		_expect(legacy[0] == EXPECTED_LEGACY_FIRST, "legacy must start at station_19")
		_expect(legacy[22] == EXPECTED_LEGACY_LAST, "legacy must end at station_41")
	var finales: Array[String] = _array_entries(source, "CAMPAIGN_FINALES")
	_expect(finales.size() == EXPECTED_FINALES_N, "FINALES must hold 3 (got %d)" % finales.size())
	_expect(finales.has("station_42a") and finales.has("station_42b") and finales.has("station_42c"),
		"FINALES must be exactly 42a/42b/42c")
	_expect(source.contains("CAMPAIGN_EPILOGUE := &\"station_43\""), "EPILOGUE must be station_43")
	var selector: Array[String] = _array_entries(source, "CAMPAIGN_SELECTOR_STATIONS")
	_expect(selector.size() == EXPECTED_SELECTOR_N, "SELECTOR must hold 20 (got %d)" % selector.size())
	if selector.size() == EXPECTED_SELECTOR_N:
		for i: int in range(18):
			var want: String = "station_%02d" % (i + 1)
			_expect(selector[i] == want, "selector entry %d must be %s (got %s)" % [i, want, selector[i]])
		_expect(selector[18] == EXPECTED_SELECTOR_TAIL_A, "selector entry 18 must be station_42a")
		_expect(selector[19] == EXPECTED_SELECTOR_TAIL_EP, "selector entry 19 must be station_43")
		_expect(not selector.has("station_42b"), "selector must not list station_42b (operation-routed)")
		_expect(not selector.has("station_42c"), "selector must not list station_42c (operation-routed)")
		_expect(not selector.has("station_19"), "selector must not list legacy stations")
		_expect(not selector.has("station_41"), "selector must not list legacy stations")
	_expect(source.contains("\"A\": &\"station_42a\""), "OPERATION_TO_FINALE must map A to 42a")
	_expect(source.contains("\"B\": &\"station_42b\""), "OPERATION_TO_FINALE must map B to 42b")
	_expect(source.contains("\"C\": &\"station_42c\""), "OPERATION_TO_FINALE must map C to 42c")
	_expect(source.contains("CAMPAIGN_TRANSITION_LIMIT := 18"), "transition limit must be 18")
	_expect(source.contains("LEGACY_CAMPAIGN_TRANSITION_LIMIT := 41"), "legacy limit must be 41")


# ─── 2. Defaulty tekstowo ──────────────────────────────────────────────

func _check_defaults_text() -> void:
	var source: String = _read(GSM_PATH)
	if source.is_empty():
		return
	_expect(source.contains("DEFAULT_MASTER_VOLUME := 0.85"), "default master volume must be 0.85")
	_expect(source.contains("DEFAULT_TEXT_SPEED_CPS := 42.0"), "default text speed must be 42.0")
	_expect(source.contains("DEFAULT_TEXT_SCALE := 1.0"), "default text scale must be 1.0")
	_expect(source.contains("MIN_TEXT_SCALE := 0.85"), "min text scale must be 0.85")
	_expect(source.contains("MAX_TEXT_SCALE := 1.15"), "max text scale must be 1.15")
	_expect(source.contains("DEFAULT_REDUCED_MOTION := false"), "reduced motion must default to false")
	var remap: Array[String] = _array_entries(source, "REMAPPABLE_ACTIONS")
	_expect(remap.size() == EXPECTED_REMAP.size(), "REMAPPABLE must hold 5 (got %d)" % remap.size())
	for action: String in EXPECTED_REMAP:
		_expect(remap.has(action), "REMAPPABLE must list %s" % action)


# ─── 3. Runtime: constant map trzyma te same wartosci ──────────────────

func _check_runtime_constants() -> void:
	var state: Node = root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload must exist")
	var script: GDScript = load(GSM_PATH) as GDScript
	_expect(script != null, "game_state_manager script must load")
	if script == null:
		return
	var consts: Dictionary = script.get_script_constant_map()
	for key: String in ["CAMPAIGN_ROUTE", "CAMPAIGN_LEGACY_STATIONS", "CAMPAIGN_FINALES",
			"CAMPAIGN_SELECTOR_STATIONS", "CAMPAIGN_EPILOGUE", "OPERATION_TO_FINALE",
			"CAMPAIGN_TRANSITION_LIMIT", "LEGACY_CAMPAIGN_TRANSITION_LIMIT",
			"DEFAULT_MASTER_VOLUME", "DEFAULT_TEXT_SPEED_CPS", "DEFAULT_TEXT_SCALE",
			"MIN_TEXT_SCALE", "MAX_TEXT_SCALE", "DEFAULT_REDUCED_MOTION", "REMAPPABLE_ACTIONS"]:
		_expect(consts.has(key), "constant map must carry %s" % key)
	if consts.has("CAMPAIGN_ROUTE"):
		_expect((consts["CAMPAIGN_ROUTE"] as Array).size() == EXPECTED_ROUTE_N, "runtime ROUTE must hold 18")
	if consts.has("CAMPAIGN_LEGACY_STATIONS"):
		_expect((consts["CAMPAIGN_LEGACY_STATIONS"] as Array).size() == EXPECTED_LEGACY_N, "runtime LEGACY must hold 23")
	if consts.has("CAMPAIGN_FINALES"):
		_expect((consts["CAMPAIGN_FINALES"] as Array).size() == EXPECTED_FINALES_N, "runtime FINALES must hold 3")
	if consts.has("CAMPAIGN_SELECTOR_STATIONS"):
		var sel: Array = consts["CAMPAIGN_SELECTOR_STATIONS"] as Array
		_expect(sel.size() == EXPECTED_SELECTOR_N, "runtime SELECTOR must hold 20")
		if sel.size() == EXPECTED_SELECTOR_N:
			_expect(String(sel[0]) == EXPECTED_ROUTE_FIRST, "runtime selector must start at station_01")
			_expect(String(sel[18]) == EXPECTED_SELECTOR_TAIL_A, "runtime selector tail must be 42a")
			_expect(String(sel[19]) == EXPECTED_SELECTOR_TAIL_EP, "runtime selector tail must be 43")
	if consts.has("CAMPAIGN_EPILOGUE"):
		_expect(String(consts["CAMPAIGN_EPILOGUE"]) == EXPECTED_EPILOGUE, "runtime EPILOGUE must be station_43")
	if consts.has("OPERATION_TO_FINALE"):
		var opmap: Dictionary = consts["OPERATION_TO_FINALE"] as Dictionary
		_expect(String(opmap.get("A")) == "station_42a", "runtime opmap A must be 42a")
		_expect(String(opmap.get("B")) == "station_42b", "runtime opmap B must be 42b")
		_expect(String(opmap.get("C")) == "station_42c", "runtime opmap C must be 42c")
	if consts.has("CAMPAIGN_TRANSITION_LIMIT"):
		_expect(int(consts["CAMPAIGN_TRANSITION_LIMIT"]) == EXPECTED_TRANSITION_LIMIT, "runtime transition limit must be 18")
	if consts.has("LEGACY_CAMPAIGN_TRANSITION_LIMIT"):
		_expect(int(consts["LEGACY_CAMPAIGN_TRANSITION_LIMIT"]) == EXPECTED_LEGACY_LIMIT, "runtime legacy limit must be 41")
	if consts.has("DEFAULT_MASTER_VOLUME"):
		_expect(is_equal_approx(float(consts["DEFAULT_MASTER_VOLUME"]), 0.85), "runtime volume must be 0.85")
	if consts.has("DEFAULT_TEXT_SPEED_CPS"):
		_expect(is_equal_approx(float(consts["DEFAULT_TEXT_SPEED_CPS"]), 42.0), "runtime CPS must be 42.0")
	if consts.has("DEFAULT_TEXT_SCALE") and consts.has("MIN_TEXT_SCALE") and consts.has("MAX_TEXT_SCALE"):
		var def: float = float(consts["DEFAULT_TEXT_SCALE"])
		var lo: float = float(consts["MIN_TEXT_SCALE"])
		var hi: float = float(consts["MAX_TEXT_SCALE"])
		_expect(is_equal_approx(lo, 0.85) and is_equal_approx(def, 1.0) and is_equal_approx(hi, 1.15),
			"runtime scales must be 0.85/1.0/1.15")
		_expect(lo < def and def < hi, "runtime scales must keep MIN < DEFAULT < MAX")
	if consts.has("DEFAULT_REDUCED_MOTION"):
		_expect(bool(consts["DEFAULT_REDUCED_MOTION"]) == false, "runtime reduced motion must default false")
	if consts.has("REMAPPABLE_ACTIONS"):
		var remap: Array = consts["REMAPPABLE_ACTIONS"] as Array
		_expect(remap.size() == 5, "runtime REMAPPABLE must hold 5")
		for action: String in EXPECTED_REMAP:
			_expect(remap.has(StringName(action)), "runtime REMAPPABLE must list %s" % action)


# ─── 4. Spojnosc handoffu (read-only) ──────────────────────────────────

func _check_handoff() -> void:
	var session: String = _read(SESSION_PATH)
	if not session.is_empty():
		_expect(session.contains("## PKG-0208:"), "SESSION_LOG must close with PKG-0208 entry")
	var state: String = _read(STATE_PATH)
	if not state.is_empty():
		_expect(state.contains("PKG-0208"), "CURRENT_STATE must name PKG-0208 as current")
	var decisions: String = _read(DECISIONS_PATH)
	if not decisions.is_empty():
		_expect(decisions.contains("D-223"), "DECISION_LOG must contain D-223")
	var prompt: String = _read(PROMPT_PATH)
	if not prompt.is_empty():
		_expect(prompt.contains("PKG-0208"), "NEXT_SESSION_PROMPT must name executed PKG-0208")
		_expect(prompt.contains("PKG-0209"), "NEXT_SESSION_PROMPT must name expected PKG-0209")


# ─── 5. Runtime: 2 klatki ──────────────────────────────────────────────

func _check_runtime_frames() -> void:
	await process_frame
	await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0208 SELECTOR DEFAULTS PASS: route 18 / legacy 23 / finales 3 / selector 20 / opmap A-B-C / limits 18-41 / scales 0.85-1.0-1.15 / remap 5, handoff coherent.")
		quit(0)
	else:
		print("PKG-0208 SELECTOR DEFAULTS FAIL: %d failures" % _failures.size())
		for failure: String in _failures:
			print(" - %s" % failure)
		quit(1)
