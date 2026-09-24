extends SceneTree

## PKG-0226 — truth-payoff + stół sześciu rzeczy (N6-reszta z planu PKG-0213
## §8, faza R8, decyzja D-239).
##
## Proves (N6, bez nowych adresów/rodzin/faktów/postaci/scen/assetów):
## (1) 9 otwarć household (3 rodziny × 3 truth_state) ma parami różne hashe
##     pełnej treści — wypłata prawdy jest mierzalna, nie deklaratywna;
## (2) każdy wariant niesie własny znacznik wypłaty (9 dopisanych par
##     konkretu), tailsy świata nietknięte (pinują je 0194/0195);
## (3) method_commit_post dokleja stół sześciu rzeczy (FULL_STORY §39:
##     próbka, sygnał, Marta, Jakub, rejestr, węzeł) z istniejących decyzji;
## (4) zero nowych faktów: creative_scene_lines.gd nic nie zapisuje, stacje
##     18/42a/42b/42c nie dodają stałych FACT_;
## (5) nowe teksty bez tez (D-214/D-219) i bez przedwczesnego słownika
##     (D-211/0216), wszystkie linie w limicie pudła CRT;
## (6) _draw: 6 kresek stołu w 18 i pierścienie prawdy w 42A/B/C rysują się
##     bez błędów dla każdego stanu.
## Nie dowodzi odbioru ani zrozumienia (D-012, ADR-003).

const CreativeLines := preload("res://scripts/levels/creative_scene_lines.gd")

## PKG-0242 (R1): PKG-0239 (owner narrative repair, authoritative for
## content) moved the truth payoff out of nine hand-written openings into the
## presented household conversation: the local Marta answers the truth state
## in A/B, C exists only after the full record and Marta's key, and the
## commit post reads a review in Lena's own voice before Jakub's answer and
## only the act after the commit. The contracts below measure that presented
## text (lines_for), not the raw LINES table the old pins read.

const HOUSEHOLD_KEYS: Array[String] = [
	"household_a_full", "household_a_partial", "household_a_withheld",
	"household_b_full", "household_b_partial", "household_b_withheld",
	"household_c_full", "household_c_partial", "household_c_withheld",
]

## Reachable (family, truth) pairs: C requires the full record (PKG-0239).
const REACHABLE := [["a", "full"], ["a", "partial"], ["a", "withheld"],
	["b", "full"], ["b", "partial"], ["b", "withheld"], ["c", "full"]]

const TRUTH_MARKS := {
	"a_full": "Dostałam cały zapis przed wyborem.",
	"a_partial": "Kartka o warunku przerwania nadal jest twoim długiem.",
	"a_withheld": "Nie zgadzałam się w ciemno na twoją procedurę.",
	"b_full": "Dostałam cały zapis przed wyborem.",
	"b_partial": "Kartka o warunku przerwania nadal jest twoim długiem.",
	"b_withheld": "Nie zgadzałam się w ciemno na twoją procedurę.",
	"c_full": "Marta zostaje ze mną przy stole",
}

const WORLD_TAILS := {
	"a": "Węzeł pozostaje pod nadzorem. Incydent zamknięty.",
	"b": "Eksport kosztów z tego węzła: zamknięty.",
	"c": "UCP nie ma wyłączności na odczyt obu stron.",
}

const THESIS_STEMS: Array[String] = [
	"sens", "wybacz", "morał", "moral", "lekcja", "los tak",
	"świat mówi", "prawda jest", "znaczy to", "po to tu", "cierpienie",
]

const PREMATURE_TERMS: Array[String] = [
	"równi", "miejscowa lena", "inny świat", "anchor/yield",
]

const MAX_LINE_LEN := 115

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("PKG-0226: " + message)


func _join_rows(rows: Array) -> String:
	var out := ""
	for row: Variant in rows:
		if row is Dictionary:
			out += String((row as Dictionary).get("text", "")) + "\n"
		elif row is Array and (row as Array).size() >= 2:
			out += String((row as Array)[1]) + "\n"
	return out


func _run() -> void:
	_check_distinct_households()
	_check_truth_marks()
	_check_world_tails()
	_check_line_limits()
	_check_no_thesis_or_premature()
	_check_commit_review_table()
	_check_no_new_facts()
	await _check_draw_paths()
	_finish()


func _truth_decisions(truth: String) -> Dictionary:
	return {
		&"world_recognized": true,
		&"marta_truth_state": truth,
		&"p9.method_commitment.marta_truth_state": truth,
		&"home_sample_preserved": true,
		&"p9.mechanics.small_cost.choice": "sample_second",
	}


func _household(family: String, truth: String) -> String:
	var stub := Node.new()
	stub.name = "Station42" + family.to_upper()
	var text := _join_rows(CreativeLines.lines_for("household_consequence", _truth_decisions(truth), stub))
	stub.free()
	return text


func _check_distinct_households() -> void:
	var seen: Dictionary = {}
	for pair: Array in REACHABLE:
		var text := _household(pair[0], pair[1])
		_expect(not text.is_empty(), "household %s/%s must serve lines" % pair)
		var digest := str(hash(text))
		_expect(not seen.has(digest), "household %s/%s must differ from every other reachable variant" % pair)
		seen[digest] = true
	_expect(seen.size() == REACHABLE.size(), "7 reachable household variants must be pairwise distinct")
	for truth: String in ["partial", "withheld"]:
		_expect(_household("c", truth).contains("Ta wersja przejścia nie jest dostępna"), "C without the full record must name the gap, not invent a household")
	for key: String in HOUSEHOLD_KEYS:
		_expect(CreativeLines.LINES.has(key), "LINES must keep %s" % key)


func _check_truth_marks() -> void:
	for pair: Array in REACHABLE:
		var key := "%s_%s" % pair
		var text := _household(pair[0], pair[1])
		_expect(text.contains(String(TRUTH_MARKS[key])), "%s must carry its truth payoff" % key)
		for other: String in TRUTH_MARKS.keys():
			if String(TRUTH_MARKS[other]) != String(TRUTH_MARKS[key]):
				_expect(not text.contains(String(TRUTH_MARKS[other])), "%s must not carry the %s payoff" % [key, other])


func _check_world_tails() -> void:
	for pair: Array in REACHABLE:
		_expect(_household(pair[0], pair[1]).contains(String(WORLD_TAILS[pair[0]])), "world tail must survive for %s/%s" % pair)
	_expect(_household("b", "full").contains("Niewysłane: Jadę. Pod spodem częściowo starte Tak."), "42B keeps the Jadę-over-Tak palimpsest")


func _check_line_limits() -> void:
	var keys: Array[String] = HOUSEHOLD_KEYS.duplicate()
	keys.append("method_commit_post_force_home")
	keys.append("method_commit_post_close_equal_recover_local")
	keys.append("method_commit_post_mutual_passage")
	for key: String in keys:
		for pair: Variant in CreativeLines.LINES.get(key, []):
			if pair is Array and (pair as Array).size() >= 2:
				var text: String = String((pair as Array)[1])
				_expect(text.length() <= MAX_LINE_LEN, "%s line exceeds CRT fitting: %s" % [key, text])
	for pair: Array in REACHABLE:
		for line: String in _household(pair[0], pair[1]).split("\n", false):
			_expect(line.length() <= MAX_LINE_LEN, "household %s/%s line exceeds CRT fitting: %s" % [pair[0], pair[1], line])


func _check_no_thesis_or_premature() -> void:
	for mark: Variant in TRUTH_MARKS.values():
		_check_clean(String(mark).to_lower(), "truth payoff")
	for text: String in _review_texts(_proposal_decisions("force_home", "full", "granted")) + _review_texts(_bare_decisions()):
		_check_clean(text.to_lower(), "review table")
		_expect(text.length() <= MAX_LINE_LEN, "review line exceeds CRT fitting: %s" % text)


func _check_clean(lowered: String, where: String) -> void:
	for stem: String in THESIS_STEMS:
		_expect(not lowered.contains(stem), "%s carries a forbidden thesis stem: %s" % [where, stem])
	for term: String in PREMATURE_TERMS:
		_expect(not lowered.contains(term), "%s carries a premature term: %s" % [where, term])


## A named, unanswered proposal (first visit to 18).
func _proposal_decisions(method: String, truth: String, scope: String) -> Dictionary:
	return {
		&"world_recognized": true,
		&"p9.method_commitment.proposed_method": method,
		&"marta_truth_state": truth,
		&"p9.method_commitment.marta_truth_state": truth,
		&"jakub_consent_state": scope,
		&"p9.consent_and_cost.jakub_consent_scope": scope,
		&"home_sample_preserved": true,
		&"p9.mechanics.small_cost.choice": "sample_second",
		&"local_lena_signal_confirmed": true,
		&"ucp_cost_ledger_found": true,
	}


## The same chain after Jakub's answer and the commit (NarrativeRules.committed).
func _committed_decisions(method: String, truth: String, scope: String) -> Dictionary:
	var decisions := _proposal_decisions(method, truth, scope)
	decisions[&"p9.consent_and_cost.method_responses"] = {method: "accepted"}
	decisions[&"p9.method_commitment.marta_sync_response"] = "accepted"
	decisions[&"method_committed"] = method
	decisions[&"p9.method_commitment.method_committed"] = method
	decisions[&"p9.method_commitment.snapshot"] = {"method": method, "jakub_method_response": "accepted"}
	return decisions


func _bare_decisions() -> Dictionary:
	return {&"world_recognized": true}


func _review_texts(decisions: Dictionary) -> Array[String]:
	var out: Array[String] = []
	for row: Variant in CreativeLines.lines_for("method_commit_post", decisions):
		if row is Dictionary:
			out.append(String((row as Dictionary).get("text", "")))
	return out


func _check_commit_review_table() -> void:
	# Before Jakub's answer: the method's risks, then the six-part review in
	# Lena's voice (carrier, signal, Marta, Jakub, ledger, knot), then what is
	# still missing.
	var proposal := "\n".join(_review_texts(_proposal_decisions("force_home", "full", "granted")))
	for expected: String in [
		"Wymuszenie domu: przybyła wraca", "Została surowa próbka",
		"Mam odpowiedź, która poprawiła mój błąd", "Marta widziała zapis próby",
		"Jakub dopuścił szerszy udział", "UCP znało powiązany koszt",
		"Nie ma ona wymaganych zgód", "wrócę do Jakuba",
	]:
		_expect(proposal.contains(expected), "proposal review must read: %s" % expected)
	var bare := "\n".join(_review_texts(_bare_decisions()))
	for expected: String in [
		"Brak potwierdzenia, jaki nośnik zachowałam", "Dziennik kontaktu nie zastąpi potwierdzonej odpowiedzi",
		"Jeszcze nie rozmawiałam z Martą o zapisie", "Zgoda Jakuba: brak zgodnego zapisu",
		"Nie mam odczytanego rejestru kosztów UCP", "Nie wskazałam jeszcze jednej metody",
	]:
		_expect(bare.contains(expected), "bare state must name its gap: %s" % expected)
	_expect(not bare.contains("surowej próbki"), "branch without a kept sample must not speak of a full carrier")
	# After the commit: only the act, never the review again.
	var markers := {"force_home": ["Wybieram własny powrót", "full", "granted"],
		"close_equal_recover_local": ["Wybieram odzyskanie miejscowej", "partial", "limited"],
		"mutual_passage": ["Wybieram przejście wzajemne", "full", "granted"]}
	for method: String in markers.keys():
		var spec: Array = markers[method]
		var rows := _review_texts(_committed_decisions(method, spec[1], spec[2]))
		_expect(rows.size() == 2, "%s committed post serves only its 2 act pairs, got %d" % [method, rows.size()])
		_expect("\n".join(rows).contains(String(spec[0])), "%s keeps its act marker" % method)
	var again := _review_texts(_committed_decisions("force_home", "full", "granted"))
	_expect(again.size() == 2, "lines_for must not mutate const LINES")


func _read_source(path: String) -> String:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		_expect(false, "file must be readable: %s" % path)
		return ""
	var text: String = file.get_as_text().replace("\r\n", "\n")
	file.close()
	return text


func _check_no_new_facts() -> void:
	var lines_src: String = _read_source("res://scripts/levels/creative_scene_lines.gd")
	_expect(not lines_src.contains("record_decision"), "presentation data must only read decisions, never record them")
	var fact_counts := {
		"res://scripts/levels/station_18.gd": 14,
		"res://scripts/levels/station_42a.gd": 15,
		"res://scripts/levels/station_42b.gd": 16,
		"res://scripts/levels/station_42c.gd": 16,
	}
	for path: String in fact_counts.keys():
		var count := 0
		for line: String in _read_source(path).split("\n"):
			if line.strip_edges().begins_with("const FACT_"):
				count += 1
		_expect(count == int(fact_counts[path]), "%s must keep %d FACT consts, got %d" % [path, int(fact_counts[path]), count])


func _check_draw_paths() -> void:
	var packed18 := load("res://scenes/levels/station_18.tscn") as PackedScene
	_expect(packed18 != null, "station_18.tscn must load")
	if packed18 != null:
		var station := packed18.instantiate() as Node2D
		root.add_child(station)
		await process_frame
		await process_frame
		if "commit_table_marks" in station:
			(station.get("commit_table_marks") as Array).fill(true)
		station.set("are_forecasts_compared", true)
		station.set("is_marta_truth_disclosed", true)
		station.set("is_method_committed", true)
		station.set("marta_truth_state", &"withheld")
		station.queue_redraw()
		await process_frame
		await process_frame
		station.free()
		await process_frame
	for entry: Array in [["station_42a", "full"], ["station_42b", "partial"], ["station_42c", "withheld"], ["station_42c", ""]]:
		var station_id: String = String(entry[0])
		var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
		_expect(packed != null, "%s.tscn must load" % station_id)
		if packed == null:
			continue
		var finale := packed.instantiate() as Node2D
		root.add_child(finale)
		await process_frame
		await process_frame
		finale.set("is_household_read", true)
		finale.set("marta_truth_state", String(entry[1]))
		finale.queue_redraw()
		await process_frame
		await process_frame
		finale.free()
		await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0226 TRUTH PAYOFF TABLE PASS: 7 distinct reachable households, truth replies, review before the answer, act after the commit, no new facts, draw paths clean")
		quit(0)
	else:
		print("PKG-0226 TRUTH PAYOFF TABLE FAIL (%d)" % _failures.size())
		for failure: String in _failures:
			print("  - " + failure)
		quit(1)
