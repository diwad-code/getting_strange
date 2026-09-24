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

# PKG-0242 (R1): "wpiszemy" left the list — the owner's PKG-0239 offer names
# the substitution itself ("Wpiszemy panią w miejsce Leny Wolskiej").
const RECEPTIONIST_PHRASES: Array[String] = [
	"proszę położyć",
	"wydam wyciąg",
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


# PKG-0242 (R1): PKG-0239 (owner narrative repair, authoritative for content)
# rewrote 13-17. The pins below keep each contract's intent on the owner's
# text; where the owner deliberately reversed a pin (Wierzbicka as a
# "neutral automaton reciting state", KROK 12 / check 30) the owner wins and
# the pin now guards the owner's rule instead.

# --- 1. Synthesis: third voice, no conscious-test suggestion, 3 families ---

func _test_synthesis() -> void:
	print("1. Synthesis 13 must carry three voices without the test hint...")
	var pairs: Array = CreativeLines.lines_for("synthesize", {})
	_expect(pairs.size() == 8, "synthesize keeps the owner's 8 pairs (got %d)" % pairs.size())
	var joined: String = _join_lines(pairs)
	_expect(joined.contains("To nie jest mój świat."), "synthesis keeps the canon line To nie jest moj swiat")
	_expect(joined.contains("Więc gdzie jest ona?"), "synthesis keeps Marta question")
	_expect(joined.contains("Nie wiem."), "synthesis keeps Nie wiem")
	_expect(joined.find("To nie jest mój świat.") < joined.find("Więc gdzie jest ona?"), "recognition precedes the question")
	_expect(not joined.contains("Zostawiła po sobie tę próbę"), "synthesis must not suggest a conscious test")
	var speakers: Array[String] = _speakers(pairs)
	_expect(speakers.has("Lena"), "synthesis keeps Lena")
	_expect(speakers.has("Marta"), "synthesis keeps Marta")
	var has_jakub_link: bool = false
	for speaker: String in speakers:
		if speaker.to_lower().contains("jakub") and speaker.to_lower().contains("łącze"):
			has_jakub_link = true
	_expect(has_jakub_link, "synthesis must add Jakub as the third voice (via link, no actor)")
	_expect(joined.contains("Numery czytników też są różne"), "Jakub line must read back his number check from station 12")
	# Synthesis logic still requires three evidence families (read-only pin).
	var s13: String = _read("res://scripts/levels/station_13.gd")
	_expect(s13.contains("P9_TRACE_HOME") and s13.contains("P9_TRACE_INSTITUTION") and s13.contains("P9_TRACE_JAKUB"), "station_13 must require three traces")
	_expect(s13.contains("recognition_evidence_public") and s13.contains("recognition_evidence_relational") and s13.contains("recognition_evidence_carried"), "station_13 must require three evidence families")
	_expect(s13.contains("P9_MARTA_SOURCE_SEEN") and s13.contains("P9_INSTITUTION_SOURCE_SEEN"), "station_13 must require both source markers")


# --- 2. Forecasts: brak danych in every method line, per-scope routing ---

func _scope(value: String) -> Dictionary:
	return {&"world_recognized": true, &"jakub_consent_state": value, &"p9.consent_and_cost.jakub_consent_scope": value}


func _test_forecasts() -> void:
	print("2. Forecasts must show explicit brak danych fields...")
	var lines_dict: Dictionary = CreativeLines.LINES
	for key: String in ["forecast_comparator_granted", "forecast_comparator_limited", "forecast_comparator_refused", "forecast_comparator_missing"]:
		var variant: Array = lines_dict.get(key, [])
		_expect(variant.size() == 4, "%s keeps three method forecasts and one line of Lena" % key)
		var methods_named := 0
		for i: int in range(mini(3, variant.size())):
			var entry: Array = variant[i]
			_expect(String(entry[0]) == "CZYTNIK — PROGNOZA", "%s line %d must come from the reader" % [key, i])
			_expect(String(entry[1]).to_lower().contains("brak danych"), "%s line %d must show an explicit brak danych field" % [key, i])
			for method_name: String in ["Wymuszenie domu", "Odzyskanie i zamknięcie", "Przejście wzajemne"]:
				if String(entry[1]).begins_with(method_name):
					methods_named += 1
		_expect(methods_named == 3, "%s must name each of the three methods once" % key)
	var routed_granted: String = _join_lines(CreativeLines.lines_for("forecast_comparator", _scope("granted")))
	_expect(routed_granted.contains("Każda metoda wymaga jego odrębnej odpowiedzi"), "routed granted keeps the per-method answer line")
	var routed_limited: String = _join_lines(CreativeLines.lines_for("forecast_comparator", _scope("limited")))
	_expect(routed_limited.contains("Jakub dopuszcza tylko wskazania"), "routed limited keeps the gap line")
	var routed_refused: String = _join_lines(CreativeLines.lines_for("forecast_comparator", _scope("refused")))
	_expect(routed_refused.contains("Odmówił podłączenia"), "routed refused keeps the gap line")
	var routed_missing: String = _join_lines(CreativeLines.lines_for("forecast_comparator", {&"world_recognized": true}))
	_expect(routed_missing.contains("Nie mam zgodnego zapisu zgody"), "routed without a consistent scope serves the missing line")
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
	for variant: Array in [full, buffer]:
		var analyzer_line := ""
		for pair: Variant in variant:
			if String((pair as Array)[0]) == "ANALIZATOR":
				analyzer_line = String((pair as Array)[1])
		_expect(analyzer_line.begins_with("20:40:07 — fragment"), "cost selector analyzer names the lost second as a record fragment")
	_expect(not _join_lines(buffer).contains("surowej próbki"), "the buffer branch never speaks of a full sample")
	var abort: Array = lines_dict.get("abort_note", [])
	_expect(abort.size() == 2, "abort_note keeps the owner's 2 pairs")
	var abort_text: String = _join_lines(abort)
	_expect(abort_text.contains("Bez jej zgody nie powtarzaj"), "abort_note keeps the pkg_0194 condition")
	_expect(_speakers(abort).has("NOTATKA MIEJSCOWEJ"), "the note is the local Lena's own hand")
	var ledger: Array = lines_dict.get("cost_ledger_console", [])
	_expect(_speakers(ledger).has("REJESTR KOSZTÓW"), "the ledger speaks as a register")
	_expect(_join_lines(ledger).contains("Linia 4:"), "REJESTR keeps the Line 4 record identifier")


# --- 4. Wierzbicka: argument and pressure, not procedural recitation ---

func _test_wierzbicka() -> void:
	print("4. Wierzbicka must defend the result with an argument...")
	var lines_dict: Dictionary = CreativeLines.LINES
	_expect((lines_dict.get("identity_card", []) as Array).size() == 4, "identity_card must keep 4 pairs")
	_expect((lines_dict.get("minimal_report", []) as Array).size() == 5, "minimal_report keeps the owner's 5 pairs")
	_expect((lines_dict.get("adaptation_offer_terminal", []) as Array).size() == 6, "adaptation_offer_terminal keeps the owner's 6 pairs")
	var routed_offer: Array = CreativeLines.lines_for("adaptation_offer_terminal", {&"world_recognized": true, &"p9.consent_and_cost.adaptation_offer": "rejected"})
	var offer_joined: String = _join_lines(routed_offer)
	_expect(offer_joined.contains("Nie podpiszę"), "offer keeps Lena refusal")
	_expect(offer_joined.find("A ona?") >= 0 and offer_joined.find("A ona?") < offer_joined.find("Nie podpiszę"), "Lena weighs the price (her question) before refusing")
	var all_wierzbicka: String = ""
	for key: String in ["identity_card", "minimal_report"]:
		for pair: Variant in (lines_dict.get(key, []) as Array):
			if pair is Array and String((pair as Array)[0]).to_lower().contains("wierzbicka"):
				all_wierzbicka += String((pair as Array)[1]) + "\n"
	for pair: Variant in routed_offer:
		if String((pair as Dictionary).get("speaker", "")).to_lower().contains("wierzbicka"):
			all_wierzbicka += String((pair as Dictionary).get("text", "")) + "\n"
	var lower: String = all_wierzbicka.to_lower()
	_expect(lower.contains("wynik"), "Wierzbicka answers for the maintained result")
	_expect(lower.contains("bezpieczeństwa tej strony"), "Wierzbicka presses with what the result protects")
	_expect(not lower.contains("stan:"), "Wierzbicka is not a neutral automaton reciting state (owner KROK 12)")
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
		print("PKG-0217 SYNTHESIS FORECAST PASS: third voice, brak danych, device registers, Wierzbicka defends the result.")
		quit(0)
	else:
		print("PKG-0217 SYNTHESIS FORECAST FAIL (%d)" % _failures.size())
		for failure: String in _failures:
			print("  - " + failure)
		quit(1)
