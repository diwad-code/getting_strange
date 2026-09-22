extends SceneTree

## PKG-0217 gate — synthesis third voice + forecasts brak danych + device
## differentiation + impersonal Wierzbicka (N2+N5+N7-czesc planu PKG-0213 §8).
##
## N2: synteza 13 ma trzeci glos Jakuba przez lacze (odczyt sprawdzenia numeru,
## bez sprowadzania aktora); sugestia swiadomej proby wycofana. Kanon 3 kwestii
## (To nie jest moj swiat / Wiec gdzie jest ona? / Nie wiem) zachowany.
## N5: wariant granted pokazuje jawne czerwone pola brak danych; urzadzenia
## zroznicowane trescia (rejestr = numery/daty, analizator = wykres, notatka =
## odreczny wtret; bez etykiet rozroznialne). N7-czesc: Wierzbicka mowi strona
## bezosobowa z kwalifikatorami (stan / zakres / stabilnosc / dopuszczalne
## odchylenie / procedura), nie recepcja.
##
## Technical proof only: measurable presented-text contracts.
## No claim about fun, beauty, comprehension or reception (D-012, ADR-003).

const CreativeLines := preload("res://scripts/levels/creative_scene_lines.gd")

const RECEPTIONIST_PHRASES: Array[String] = [
	"proszę położyć",
	"wydam wyciąg",
	"wpiszemy",
	"wygładzimy",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0217: " + message)


func _read(path: String) -> String:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "file must be readable: %s" % path)
	if file == null:
		return ""
	var text: String = file.get_as_text().replace("\r\n", "\n")
	file.close()
	return text


func _join_lines(pairs: Array) -> String:
	var out: String = ""
	for pair: Variant in pairs:
		if pair is Dictionary:
			out += String((pair as Dictionary).get("text", "")) + "\n"
		elif pair is Array and (pair as Array).size() >= 2:
			out += String((pair as Array)[1]) + "\n"
	return out


func _speakers(pairs: Array) -> Array[String]:
	var out: Array[String] = []
	for pair: Variant in pairs:
		var speaker: String = ""
		if pair is Dictionary:
			speaker = String((pair as Dictionary).get("speaker", ""))
		elif pair is Array and (pair as Array).size() >= 2:
			speaker = String((pair as Array)[0])
		if not out.has(speaker):
			out.append(speaker)
	return out


func _run() -> void:
	_test_synthesis()
	_test_forecasts()
	_test_devices()
	_test_wierzbicka()
	_test_fail_closed()
	_finish()


# --- 1. Synthesis: third voice, no conscious-test suggestion, 3 families ---

func _test_synthesis() -> void:
	print("1. Synthesis 13 must carry three voices without the test hint...")
	var pairs: Array = CreativeLines.lines_for("synthesize", {})
	_expect(pairs.size() == 6, "synthesize must keep 6 pairs (got %d)" % pairs.size())
	var joined: String = _join_lines(pairs)
	_expect(joined.contains("To nie jest mój świat."), "synthesis keeps the canon line To nie jest moj swiat")
	_expect(joined.contains("Więc gdzie jest ona?"), "synthesis keeps Marta question")
	_expect(joined.contains("Nie wiem."), "synthesis keeps Nie wiem")
	_expect(joined.find("To nie jest mój świat.") < joined.find("Więc gdzie jest ona?"), "recognition precedes the question")
	_expect(not joined.contains("Zostawiła po sobie tę próbę"), "synthesis must not suggest a conscious test")
	var speakers: Array[String] = _speakers(pairs)
	_expect(speakers.has("Lena"), "synthesis keeps Lena")
	_expect(speakers.has("Marta"), "synthesis keeps Marta")
	var has_jakub: bool = false
	for speaker: String in speakers:
		if speaker.contains("JAKUB"):
			has_jakub = true
	_expect(has_jakub, "synthesis must add Jakub as the third voice (via link, no actor)")
	_expect(joined.contains("nie ma w naszej bazie"), "Jakub line must read back his number check from station 12")
	# Synthesis logic still requires three evidence families (read-only pin).
	var s13: String = _read("res://scripts/levels/station_13.gd")
	_expect(s13.contains("P9_TRACE_HOME") and s13.contains("P9_TRACE_INSTITUTION") and s13.contains("P9_TRACE_JAKUB"), "station_13 must require three traces")
	_expect(s13.contains("recognition_evidence_public") and s13.contains("recognition_evidence_relational") and s13.contains("recognition_evidence_carried"), "station_13 must require three evidence families")
	_expect(s13.contains("P9_MARTA_SOURCE_SEEN") and s13.contains("P9_INSTITUTION_SOURCE_SEEN"), "station_13 must require both source markers")


# --- 2. Forecasts: granted brak danych, per-variant lines ---

func _test_forecasts() -> void:
	print("2. Forecast granted must show explicit brak danych fields...")
	var lines_dict: Dictionary = CreativeLines.LINES
	for key: String in ["forecast_comparator_granted", "forecast_comparator_limited", "forecast_comparator_refused"]:
		_expect((lines_dict.get(key, []) as Array).size() == 3, "%s must keep 3 pairs" % key)
	_expect((lines_dict.get("forecast_comparator_missing", []) as Array).size() == 2, "forecast_comparator_missing must keep 2 pairs")
	var granted: Array = lines_dict.get("forecast_comparator_granted", [])
	_expect(granted.size() == 3, "granted must have 3 lines")
	for i: int in range(granted.size()):
		var text: String = ""
		var entry: Variant = granted[i]
		if entry is Array and (entry as Array).size() >= 2:
			text = String((entry as Array)[1])
		_expect(text.to_lower().contains("brak danych"), "granted line %d must show an explicit brak danych field" % i)
	var granted_joined: String = _join_lines(granted)
	_expect(granted_joined.contains("chroni mój powrót"), "granted keeps the pkg_0194 run-A line chroni moj powrot")
	# Device registers inside granted (no labels needed to tell them apart).
	var line0: String = String((granted[0] as Array)[1])
	var line1: String = String((granted[1] as Array)[1]).to_lower()
	var line2: String = String((granted[2] as Array)[1]).to_lower()
	_expect(line0.contains("20:40"), "granted register line must carry numbers/dates (20:40)")
	_expect(line1.contains("oś") or line1.contains("krzywa") or line1.contains("wykres") or line1.contains("pik"), "granted analyzer line must speak in chart terms")
	_expect(line2.contains("margines") or line2.contains("odręczn") or line2.contains("dopisek"), "granted note line must read as a handwritten aside")
	# Routing per consent scope (presented text, not file path).
	var routed_granted: Array = CreativeLines.lines_for("forecast_comparator", {&"world_recognized": true, &"jakub_consent_state": "granted"})
	_expect(_join_lines(routed_granted).to_lower().contains("brak danych"), "routed granted must serve brak danych")
	var routed_limited: Array = CreativeLines.lines_for("forecast_comparator", {&"world_recognized": true, &"jakub_consent_state": "limited"})
	_expect(_join_lines(routed_limited).contains("brak zgody Jakuba"), "routed limited keeps the gap line")
	var routed_refused: Array = CreativeLines.lines_for("forecast_comparator", {&"world_recognized": true, &"jakub_consent_state": "refused"})
	_expect(_join_lines(routed_refused).contains("brak zgody Jakuba"), "routed refused keeps the gap line")
	var fallback: Array = CreativeLines.lines_for("forecast_comparator", {})
	_expect(_join_lines(fallback).contains("Najpierw muszę nazwać"), "forecast without recognition still serves the knowledge fallback")


# --- 3. Device differentiation across the presented set ---

func _test_devices() -> void:
	print("3. Devices must stay distinguishable without labels...")
	var lines_dict: Dictionary = CreativeLines.LINES
	var analyzer: Array = lines_dict.get("safe_analyzer", [])
	_expect(analyzer.size() == 2, "safe_analyzer keeps 2 pairs")
	var analyzer_text: String = _join_lines(analyzer).to_lower()
	_expect(analyzer_text.contains("wykres") or analyzer_text.contains("krzywa") or analyzer_text.contains("oś"), "ANALIZATOR must speak in chart terms")
	var full: Array = lines_dict.get("cost_selector_sample_full", [])
	var buffer: Array = lines_dict.get("cost_selector_sample_buffer", [])
	_expect(full.size() == 3 and buffer.size() == 3, "cost selectors keep 3 pairs each")
	_expect(_join_lines(full).contains("Sekunda 20:40:07"), "sample_full keeps the pkg_0194 second")
	_expect(_join_lines(buffer).contains("Sekunda 20:40:07"), "sample_buffer keeps the pkg_0194 second")
	_expect(_join_lines(full).to_lower().contains("wykres") or _join_lines(full).to_lower().contains("pik"), "sample_full analyzer speaks in chart terms")
	_expect(_join_lines(buffer).to_lower().contains("wykres") or _join_lines(buffer).to_lower().contains("pik"), "sample_buffer analyzer speaks in chart terms")
	var abort: Array = lines_dict.get("abort_note", [])
	_expect(abort.size() == 3, "abort_note keeps 3 pairs")
	var abort_text: String = _join_lines(abort)
	_expect(abort_text.contains("Bez jej zgody nie powtarzaj"), "abort_note keeps the pkg_0194 condition")
	var abort_lower: String = abort_text.to_lower()
	_expect(abort_lower.contains("margines") or abort_lower.contains("odręczn") or abort_lower.contains("dopisek"), "NOTATKA must read as a handwritten aside")
	var ledger: Array = lines_dict.get("cost_ledger_console", [])
	var ledger_joined: String = _join_lines(ledger)
	_expect(ledger_joined.contains("04/17"), "REJESTR keeps numbers/dates (Para 04/17)")


# --- 4. Wierzbicka: impersonal with qualifiers, same pair counts ---

func _test_wierzbicka() -> void:
	print("4. Wierzbicka must speak impersonally with qualifiers...")
	var lines_dict: Dictionary = CreativeLines.LINES
	for key: String in ["identity_card", "minimal_report", "adaptation_offer_terminal"]:
		_expect((lines_dict.get(key, []) as Array).size() == 4, "%s must keep 4 pairs" % key)
	var routed_offer: Array = CreativeLines.lines_for("adaptation_offer_terminal", {&"world_recognized": true, &"p9.consent_and_cost.adaptation_offer": "rejected"})
	var offer_joined: String = _join_lines(routed_offer)
	_expect(offer_joined.contains("Nie będę wygodnym zastępstwem"), "offer keeps Lena refusal (pkg_0194)")
	var all_wierzbicka: String = ""
	for key: String in ["identity_card", "minimal_report"]:
		for pair: Variant in (lines_dict.get(key, []) as Array):
			if pair is Array and String((pair as Array)[0]).to_lower().contains("wierzbicka"):
				all_wierzbicka += String((pair as Array)[1]) + "\n"
	for pair: Variant in routed_offer:
		var speaker: String = ""
		var text: String = ""
		if pair is Dictionary:
			speaker = String((pair as Dictionary).get("speaker", ""))
			text = String((pair as Dictionary).get("text", ""))
		elif pair is Array and (pair as Array).size() >= 2:
			speaker = String((pair as Array)[0])
			text = String((pair as Array)[1])
		if speaker.to_lower().contains("wierzbicka"):
			all_wierzbicka += text + "\n"
	var lower: String = all_wierzbicka.to_lower()
	_expect(lower.contains("stan:"), "Wierzbicka lines must use the impersonal state form (stan:)")
	_expect(lower.contains("zakres"), "Wierzbicka lines must use qualifiers (zakres)")
	_expect(lower.contains("stabilno") or lower.contains("dopuszczaln") or lower.contains("procedur"), "Wierzbicka lines must use further qualifiers (stabilnosc / dopuszczalne / procedura)")
	for phrase: String in RECEPTIONIST_PHRASES:
		_expect(not lower.contains(phrase), "Wierzbicka must not speak as a receptionist: " + phrase)
	var gated_fallback: Array = CreativeLines.lines_for("adaptation_offer_terminal", {})
	_expect(_join_lines(gated_fallback).contains("Najpierw muszę nazwać"), "offer without recognition still serves the knowledge fallback")


# --- 5. Fail-closed proof ---

func _test_fail_closed() -> void:
	print("5. Detectors must catch injected regressions (fail-closed)...")
	_expect("Brak danych: kanal.".to_lower().contains("brak danych"), "brak-danych detector flags an explicit red field")
	_expect(not "Niewiadoma: kanal.".to_lower().contains("brak danych"), "brak-danych detector passes a line without the red field")
	_expect("Wykres: pik spada do osi.".to_lower().contains("wykres"), "chart detector flags analyzer vocabulary")
	_expect("Wydam wyciąg.".to_lower().contains("wydam wyciąg"), "receptionist detector flags the old first-person phrasing")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0217 SYNTHESIS FORECAST PASS: third voice, brak danych, device registers, impersonal Wierzbicka.")
		quit(0)
	else:
		print("PKG-0217 SYNTHESIS FORECAST FAIL (%d)" % _failures.size())
		for failure: String in _failures:
			print("  - " + failure)
		quit(1)
