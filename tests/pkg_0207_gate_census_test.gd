extends SceneTree

## PKG-0207 gate — spis bramek i pin fundamentów (decyzja D-222: HOLD logiki
## i obrazu, rejestr ZAPINOWANY, fundamenty OPISANE).
##
## Pinuje wylacznie kontrakty mierzalne na dysku i runtime, nigdy slusznosc
## przyszlej ekstrakcji ani odbior (D-012, ADR-003). Zero zmian w scripts/,
## scenes/, konfiguracji: bramka czyta tools/verify.ps1, tests/, project.godot
## i cztery dokumenty handoffu. Wzor: PKG-0206 (normalizacja CRLF, jawne typy,
## brak chr()) i PKG-0205 (asercje tekstowe na plikach z CRLF).
##
## Fakty pinowane (stan po PKG-0208, z self + pkg_0208):
## (1) spis: 104 wiersze wywolujace Invoke-GodotGate (103 ze skryptem + import
## bez skryptu), 102 unikalnych res://tests/*.gd == 102 plikow tests/*.gd
## (zbiory rowne w obie strony: zero sierot, zero wiszacych), audyt
## tools/frame_budget_audit.gd istnieje, nazwy bramek unikalne;
## (2) fundamenty: project.godot 640x360 / 60 Hz (tekst + runtime
## ProjectSettings), 10 akcji InputMap kazda z >= 1 eventem;
## (3) handoff: SESSION_LOG zawiera PKG-0207, CURRENT_STATE nazywa PKG-0207
## w historii, DECISION_LOG zawiera D-222, NEXT_SESSION_PROMPT nazywa PKG-0207
## w historii oraz PKG-0208 jako wykonany;
## (4) runtime: autoload GameStateManager istnieje, 2 klatki bez bledow.
##
## PKG-0208 (D-223), PKG-0210 (D-224), PKG-0211 (D-225) & PKG-0212 (D-226):
## kontrolowana aktualizacja liczb 106 -> 107 / 105 -> 106 / 104 -> 105 /
## 104 -> 105 razem z bramka station disk census
## (jawna regula ewolucji z D-222, wzor D-216/D-218/D-223/D-224/D-225).
## PKG-0214 (D-227): kontrolowana aktualizacja liczb 107 -> 108 /
## 106 -> 107 / 105 -> 106 / 105 -> 106 razem z bramka threshold ownership
## (ta sama regula ewolucji).
## PKG-0215 (D-228): kontrolowana aktualizacja liczb 108 -> 109 /
## 107 -> 108 / 106 -> 107 / 106 -> 107 razem z bramka gap voice
## (ta sama regula ewolucji).
## PKG-0216 (slownik + lint tresci + palimpsest): kontrolowana aktualizacja
## liczb 109 -> 110 / 108 -> 109 / 107 -> 108 / 107 -> 108 razem z bramka
## dictionary content (ta sama regula ewolucji).
## PKG-0217 (synteza + prognozy + urzadzenia): kontrolowana aktualizacja
## liczb 110 -> 111 / 109 -> 110 / 108 -> 109 / 108 -> 109 razem z bramka
## synthesis forecast (ta sama regula ewolucji).
## PKG-0218 (fartuch + paleta + linie 09): kontrolowana aktualizacja
## liczb 111 -> 112 / 110 -> 111 / 109 -> 110 / 109 -> 110 razem z bramka
## apron palette line (ta sama regula ewolucji).
## PKG-0219 (sufit + swiatlo + regula rozu): kontrolowana aktualizacja
## liczb 112 -> 113 / 111 -> 112 / 110 -> 111 / 110 -> 111 razem z bramka
## ceiling light rose (ta sama regula ewolucji).
## PKG-0220 (petle ambientu + duck): kontrolowana aktualizacja
## liczb 113 -> 114 / 112 -> 113 / 111 -> 112 / 111 -> 112 razem z bramka
## ambient loop duck (ta sama regula ewolucji).
## PKG-0221 (drabina + powrot + skale): kontrolowana aktualizacja
## liczb 114 -> 115 / 113 -> 114 / 112 -> 113 / 112 -> 113 razem z bramka
## ladder return scale (ta sama regula ewolucji).
## PKG-0222 (korekta z kosztem + budzety): kontrolowana aktualizacja
## liczb 115 -> 116 / 114 -> 115 / 113 -> 114 / 113 -> 114 razem z bramka
## correction cost budget (ta sama regula ewolucji).
## PKG-0223 (glosy i tempo): kontrolowana aktualizacja
## liczb 116 -> 117 / 115 -> 116 / 114 -> 115 / 114 -> 115 razem z bramka
## voices tempo (ta sama regula ewolucji).
## PKG-0224 (rigi + geometria): kontrolowana aktualizacja
## liczb 117 -> 118 / 116 -> 117 / 115 -> 116 / 115 -> 116 razem z bramka
## cast geometry (ta sama regula ewolucji).
## PKG-0225 (winiety + finaly): kontrolowana aktualizacja
## liczb 118 -> 119 / 117 -> 118 / 116 -> 117 / 116 -> 117 razem z bramka
## vignettes finales (ta sama regula ewolucji).
## PKG-0226 (truth-payoff + stol 6 rzeczy): kontrolowana aktualizacja
## liczb 119 -> 120 / 118 -> 119 / 117 -> 118 / 117 -> 118 razem z bramka
## truth payoff table (ta sama regula ewolucji).
## PKG-0227 (higiena i narzedzia R9): kontrolowana aktualizacja
## liczb 120 -> 121 / 119 -> 120 / 118 -> 119 / 118 -> 119 razem z bramka
## hygiene tools (ta sama regula ewolucji).
## PKG-0230 (naprawa sensu fabularnego): kontrolowana aktualizacja
## liczb 121 -> 122 / 120 -> 121 / 119 -> 120 / 119 -> 120 razem z bramka
## story sense repair (ta sama regula ewolucji).
## PKG-0232 (lancuch przyczynowy D-244): kontrolowana aktualizacja
## liczb 122 -> 123 / 121 -> 122 / 120 -> 121 / 120 -> 121 razem z bramka
## causal chain (ta sama regula ewolucji).
## PKG-0233 (mosty sensu B/C/D2/D5): kontrolowana aktualizacja
## liczb 123 -> 124 / 122 -> 123 / 121 -> 122 / 121 -> 122 razem z bramka
## story sense bridges (ta sama regula ewolucji).
## PKG-0234 (duchy w pokojach / Pakiet A): kontrolowana aktualizacja
## liczb 124 -> 125 / 123 -> 124 / 122 -> 123 / 122 -> 123 razem z bramka
## ghost props (ta sama regula ewolucji).
## PKG-0235 (luki P9 / Pakiet C): kontrolowana aktualizacja
## liczb 125 -> 126 / 124 -> 125 / 123 -> 124 / 123 -> 124 razem z bramka
## gap verbs (ta sama regula ewolucji).
## PKG-0236 (ciecia / Pakiet B): kontrolowana aktualizacja
## liczb 126 -> 127 / 125 -> 126 / 124 -> 125 / 124 -> 125 razem z bramka
## cuts not teleports (ta sama regula ewolucji).
## PKG-0237 (slowa zarobione / Pakiet D): kontrolowana aktualizacja
## liczb 127 -> 128 / 126 -> 127 / 125 -> 126 / 125 -> 126 razem z bramka
## earned words (ta sama regula ewolucji).
## PKG-0238 (mosty dialogowe / Pakiet E): kontrolowana aktualizacja
## liczb 128 -> 129 / 127 -> 128 / 126 -> 127 / 126 -> 127 razem z bramka
## dialogue bridges (ta sama regula ewolucji).
## Asercje handoffu contains przechodza bez zmian.

const VERIFY_PATH := "res://tools/verify.ps1"
const TESTS_DIR := "res://tests"
const PROJECT_PATH := "res://project.godot"
const FRAME_AUDIT_PATH := "res://tools/frame_budget_audit.gd"
const SESSION_PATH := "res://docs/SESSION_LOG.md"
const STATE_PATH := "res://docs/CURRENT_STATE.md"
const DECISIONS_PATH := "res://docs/DECISION_LOG.md"
const PROMPT_PATH := "res://docs/NEXT_SESSION_PROMPT.md"

const SELF_REF := "res://tests/pkg_0207_gate_census_test.gd"

const EXPECTED_INVOKE_LINES := 129
const EXPECTED_SCRIPT_ARGS := 128
const EXPECTED_TEST_REFS := 127
const EXPECTED_DISK_TESTS := 127

const INPUT_ACTIONS: Array[String] = [
	"move_left",
	"move_right",
	"move_up",
	"move_down",
	"jump",
	"restart",
	"pause",
	"interact",
	"trigger_correction",
	"sprint",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0207: " + message)


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


func _run() -> void:
	_check_census()
	_check_foundations()
	_check_handoff()
	await _check_runtime()
	_finish()


# ─── 1. Spis bramek: zbiory rowne, liczby, nazwy ───────────────────────

func _extract_test_refs(source: String) -> Array[String]:
	var out: Array[String] = []
	var from: int = 0
	while true:
		var at: int = source.find("res://tests/", from)
		if at < 0:
			break
		var end: int = source.find(".gd", at)
		if end < 0:
			break
		out.append(source.substr(at, end - at + 3))
		from = end + 3
	return out


func _extract_gate_names(source: String) -> Array[String]:
	var out: Array[String] = []
	var from: int = 0
	var marker: String = "-Name '"
	while true:
		var at: int = source.find(marker, from)
		if at < 0:
			break
		var start: int = at + marker.length()
		var end: int = source.find("'", start)
		if end < 0:
			break
		out.append(source.substr(start, end - start))
		from = end + 1
	return out


func _list_disk_tests() -> Array[String]:
	var out: Array[String] = []
	var dir: DirAccess = DirAccess.open(TESTS_DIR)
	_expect(dir != null, "tests dir must be listable: %s" % TESTS_DIR)
	if dir == null:
		return out
	dir.list_dir_begin()
	var fname: String = dir.get_next()
	while fname != "":
		if fname.ends_with(".gd") and not dir.current_is_dir():
			out.append("res://tests/" + fname)
		fname = dir.get_next()
	dir.list_dir_end()
	return out


func _check_census() -> void:
	var verify: String = _read(VERIFY_PATH)
	if verify.is_empty():
		return
	# Wiersz definicji funkcji zawiera nazwe, ale nie jest wywolaniem:
	# wywolania maja kontynuacje backtick (wzór rejestracji 0201-0206).
	_expect(_count(verify, "Invoke-GodotGate `") == EXPECTED_INVOKE_LINES,
		"verify must keep %d invoking Invoke-GodotGate lines (got %d)" % [EXPECTED_INVOKE_LINES, _count(verify, "Invoke-GodotGate `")])
	_expect(_count(verify, "'--script'") == EXPECTED_SCRIPT_ARGS,
		"verify must keep %d script args (got %d)" % [EXPECTED_SCRIPT_ARGS, _count(verify, "'--script'")])
	var refs: Array[String] = _extract_test_refs(verify)
	var unique: Dictionary = {}
	for ref: String in refs:
		unique[ref] = true
	_expect(unique.size() == EXPECTED_TEST_REFS,
		"verify must reference %d unique tests (got %d)" % [EXPECTED_TEST_REFS, unique.size()])
	_expect(refs.size() == unique.size(), "no test script may be registered twice")
	_expect(unique.has(SELF_REF), "verify must register this census gate itself")
	var disk: Array[String] = _list_disk_tests()
	_expect(disk.size() == EXPECTED_DISK_TESTS,
		"tests dir must hold %d scripts (got %d)" % [EXPECTED_DISK_TESTS, disk.size()])
	for ref: String in unique.keys():
		var rel: String = String(ref).replace("res://tests/", "")
		_expect(FileAccess.file_exists("res://tests/" + rel), "dangling gate registration without file: %s" % String(ref))
	for entry: String in disk:
		_expect(unique.has(entry), "orphan test file without gate registration: %s" % entry)
	# Jedyny skrypt bramki spoza tests/ (audyt budzetu klatki PKG-0130).
	_expect(verify.contains(FRAME_AUDIT_PATH), "verify must keep frame budget audit ref")
	_expect(FileAccess.file_exists(FRAME_AUDIT_PATH), "frame budget audit script must exist")
	# Nazwy bramek unikalne (cichy dubl Gromadzilby sekcje w logu).
	var names: Array[String] = _extract_gate_names(verify)
	var seen: Dictionary = {}
	for gate_name: String in names:
		_expect(not seen.has(gate_name), "duplicate gate name: %s" % gate_name)
		seen[gate_name] = true
	_expect(names.size() >= EXPECTED_INVOKE_LINES,
		"every invocation must carry a -Name (got %d names)" % names.size())


# ─── 2. Fundamenty: viewport, fizyka, InputMap (read-only) ──────────────

func _check_foundations() -> void:
	var project: String = _read(PROJECT_PATH)
	if not project.is_empty():
		_expect(project.contains("viewport_width=640"), "project must pin viewport width 640")
		_expect(project.contains("viewport_height=360"), "project must pin viewport height 360")
		_expect(project.contains("physics_ticks_per_second=60"), "project must pin physics 60 Hz")
	_expect(int(ProjectSettings.get_setting("display/window/size/viewport_width")) == 640,
		"runtime viewport width must be 640")
	_expect(int(ProjectSettings.get_setting("display/window/size/viewport_height")) == 360,
		"runtime viewport height must be 360")
	_expect(int(ProjectSettings.get_setting("physics/common/physics_ticks_per_second")) == 60,
		"runtime physics ticks must be 60")
	for action: StringName in INPUT_ACTIONS:
		_expect(InputMap.has_action(action), "InputMap must keep semantic action: %s" % String(action))
		if InputMap.has_action(action):
			_expect(InputMap.action_get_events(action).size() >= 1,
				"InputMap action must carry at least one event: %s" % String(action))


# ─── 3. Spojnosc handoffu (read-only) ────────────────────────────────────

func _check_handoff() -> void:
	var session: String = _read(SESSION_PATH)
	if not session.is_empty():
		_expect(session.contains("## PKG-0207:"), "SESSION_LOG must close with PKG-0207 entry")
	var state: String = _read(STATE_PATH)
	if not state.is_empty():
		_expect(state.contains("PKG-0207"), "CURRENT_STATE must name PKG-0207 as current")
	var decisions: String = _read(DECISIONS_PATH)
	if not decisions.is_empty():
		_expect(decisions.contains("D-222"), "DECISION_LOG must contain D-222")
	var prompt: String = _read(PROMPT_PATH)
	if not prompt.is_empty():
		_expect(prompt.contains("PKG-0207"), "NEXT_SESSION_PROMPT must name executed PKG-0207")
		_expect(prompt.contains("PKG-0208"), "NEXT_SESSION_PROMPT must name expected PKG-0208")


# ─── 4. Runtime: autoload + 2 klatki ─────────────────────────────────────

func _check_runtime() -> void:
	var state: Node = root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload must exist")
	await process_frame
	await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0207 GATE CENSUS PASS: %d invokes / %d scripts / %d tests, 640x360, 60 Hz, 10 actions, handoff coherent." % [EXPECTED_INVOKE_LINES, EXPECTED_SCRIPT_ARGS, EXPECTED_TEST_REFS])
		quit(0)
	else:
		print("PKG-0207 GATE CENSUS FAIL: %d failures" % _failures.size())
		for failure: String in _failures:
			print(" - %s" % failure)
		quit(1)
