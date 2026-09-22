extends SceneTree

## PKG-0216 gate — dictionary pin + presented-content lint + Tak/Jade palimpsest.
##
## N1: the method is named only Zakotwiczenie (canon NARRATIVE_BIBLE section 13:
## holding a bond through interference). Utrzymanie w metodzie jest dryfem.
## Utrzymanie ruchu (ekipa obiektu, station_17 naglowek) to inne znaczenie
## i zostaje. N3: lint pilnuje tresci prezentowanej (creative_scene_lines),
## nie samego pliku stacji — furtka D-211 nie jest trzymana na stale.
## N6-czesc (K7): ekran 42B pokazuje palimpsest Jeda nad czesciowo startym Tak.
##
## Technical proof only: measurable file and presented-text contracts.
## No claim about fun, beauty, comprehension or reception (D-012, ADR-003).

const CreativeLines := preload("res://scripts/levels/creative_scene_lines.gd")

const FORBIDDEN_TERMS: Array[String] = [
	"rówień",
	"miejscowa lena",
	"inny świat",
	"anchor/yield",
]

const GATED_IDS: Array[String] = [
	"cost_ledger_console",
	"adaptation_offer_terminal",
	"consent_scope_desk",
	"forecast_comparator",
	"marta_truth_table",
	"method_commit_post",
]

const HOUSEHOLD_B_IDS: Array[String] = [
	"household_b_full",
	"household_b_partial",
	"household_b_withheld",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0216: " + message)


func _read(path: String) -> String:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "file must be readable: %s" % path)
	if file == null:
		return ""
	var text: String = file.get_as_text().replace("\r\n", "\n")
	file.close()
	return text


func _has_forbidden(text_lower: String) -> bool:
	for term: String in FORBIDDEN_TERMS:
		if text_lower.contains(term):
			return true
	return false


func _join_lines(pairs: Array) -> String:
	var out: String = ""
	for pair: Variant in pairs:
		if pair is Dictionary:
			out += String((pair as Dictionary).get("text", "")) + "\n"
		elif pair is Array and (pair as Array).size() >= 2:
			out += String((pair as Array)[1]) + "\n"
	return out


func _run() -> void:
	_test_dictionary()
	_test_gated_content()
	_test_fail_closed()
	_test_palimpsest()
	_finish()


# --- 1. Dictionary: Zakotwiczenie only as the method name ---

func _test_dictionary() -> void:
	print("1. Method dictionary must read Zakotwiczenie, never Utrzymanie...")
	var lines_src: String = _read("res://scripts/levels/creative_scene_lines.gd").to_lower()
	var s14_src: String = _read("res://scripts/levels/station_14.gd").to_lower()
	var story: String = _read("res://docs/narrative/FULL_STORY.md").to_lower()
	var report_b: String = _read("res://docs/rebuild/PKG_0194_CREATIVE_SCENES_B.md").to_lower()
	var s17_src: String = _read("res://scripts/levels/station_17.gd")
	for entry: Array in [
		["creative_scene_lines.gd", lines_src],
		["station_14.gd", s14_src],
		["FULL_STORY.md", story],
		["PKG_0194_CREATIVE_SCENES_B.md", report_b],
	]:
		var label: String = String(entry[0])
		var body: String = String(entry[1]).to_lower()
		_expect(not body.contains("utrzymanie i uległość"), "%s must not name the method Utrzymanie" % label)
		_expect(body.contains("zakotwiczenie i uległość"), "%s must name the method Zakotwiczenie" % label)
	# Legitimate non-method meaning is preserved, not bleached.
	_expect(s17_src.contains("Utrzymanie ruchu"), "station_17 header keeps the maintenance-crew meaning Utrzymanie ruchu")


# --- 2. Content lint: gated lines serve the fallback before recognition ---

func _test_gated_content() -> void:
	print("2. Presented 17/18 content must fall back before world_recognized...")
	var empty: Dictionary = {}
	for gated_id: String in GATED_IDS:
		var pairs: Array = CreativeLines.lines_for(gated_id, empty)
		var joined: String = _join_lines(pairs)
		_expect(joined.contains("Najpierw muszę nazwać"), "%s without world_recognized must serve the knowledge fallback" % gated_id)
		_expect(not _has_forbidden(joined.to_lower()), "%s fallback must carry no premature term" % gated_id)
	var named: Array = CreativeLines.lines_for("relay_logbook", {&"p9.mechanics.dead_circuit.trace": true})
	var named_text: String = _join_lines(named)
	_expect(named_text.contains("Zakotwiczenie"), "named relay logbook must present Zakotwiczenie")
	_expect(not named_text.contains("Utrzymanie"), "named relay logbook must not present Utrzymanie")


# --- 3. Fail-closed proof: the detector catches an injected term ---

func _test_fail_closed() -> void:
	print("3. Detector must catch an injected premature term (fail-closed)...")
	_expect(_has_forbidden("Rówień pachnie deszczem.".to_lower()), "detector must flag an injected using the guarded vocabulary")
	_expect(not _has_forbidden("kontakt przy pierwszym odczycie.".to_lower()), "detector must pass a clean presented line")


# --- 4. Palimpsest: both inscriptions present in 42B ---

func _test_palimpsest() -> void:
	print("4. Screen 42B must carry Jade over a partly erased Tak...")
	var lines_dict: Dictionary = CreativeLines.LINES
	for key: String in HOUSEHOLD_B_IDS:
		_expect(lines_dict.has(key), "LINES must keep %s" % key)
		var joined: String = _join_lines(lines_dict.get(key, []))
		_expect(joined.contains("Jadę"), "%s must show Jade" % key)
		_expect(joined.contains("Tak"), "%s must keep the partly erased Tak" % key)
	var story: String = _read("res://docs/narrative/FULL_STORY.md")
	var start: int = story.find("## 42B.")
	var stop: int = story.find("## 42C.")
	_expect(start >= 0 and stop > start, "FULL_STORY must keep the 42B section")
	if start >= 0 and stop > start:
		var block: String = story.substr(start, stop - start)
		_expect(block.contains("Jadę"), "FULL_STORY 42B block must name Jade")
		_expect(block.contains("Tak"), "FULL_STORY 42B block must name Tak")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0216 DICTIONARY CONTENT PASS: Zakotwiczenie pinned, gated content falls back, 42B carries both inscriptions.")
		quit(0)
	else:
		print("PKG-0216 DICTIONARY CONTENT FAIL (%d)" % _failures.size())
		for failure: String in _failures:
			print("  - " + failure)
		quit(1)
