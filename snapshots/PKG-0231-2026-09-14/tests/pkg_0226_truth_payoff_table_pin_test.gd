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

const HOUSEHOLD_KEYS: Array[String] = [
	"household_a_full", "household_a_partial", "household_a_withheld",
	"household_b_full", "household_b_partial", "household_b_withheld",
	"household_c_full", "household_c_partial", "household_c_withheld",
]

const TRUTH_MARKS := {
	"household_a_full": "Drugie zgłoszenie dopiszę sama.",
	"household_a_partial": "Drugie zgłoszenie zostawiam otwarte.",
	"household_a_withheld": "drugie zgłoszenie piszę z samego imienia.",
	"household_b_full": "Czytnik z pełnym zapisem chowam do torby.",
	"household_b_partial": "czytnik z niepełnym zapisem.",
	"household_b_withheld": "czytnik z wiadomością bez adresata.",
	"household_c_full": "Zostaje na półce.",
	"household_c_partial": "Półkę opiszesz, kiedy będziesz umiała.",
	"household_c_withheld": "Półka zostaje pusta do czasu zapisu.",
}

const SHARED_TAILS: Array[String] = [
	"Kontrola utrzymana",
	"Eksport kosztów z tego węzła zamknięty.",
	"Ten sam ubytek po obu stronach.",
	"Jadę nad częściowo startym Tak.",
]

const REVIEW_SUBJECTS: Array[String] = [
	"Próbka domowa:", "Sygnał miejscowej:", "Marta:", "Jakub:",
	"Rejestr UCP:", "Węzeł:",
]

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


func _join_pairs(pairs: Array) -> String:
	var out := ""
	for pair: Variant in pairs:
		if pair is Array and (pair as Array).size() >= 2:
			out += String((pair as Array)[1]) + "\n"
	return out


func _run() -> void:
	_check_nine_distinct_openings()
	_check_truth_marks()
	_check_shared_tails()
	_check_line_limits()
	_check_no_thesis_or_premature()
	_check_commit_review_table()
	_check_no_new_facts()
	await _check_draw_paths()
	_finish()


func _check_nine_distinct_openings() -> void:
	var seen: Array[String] = []
	for key: String in HOUSEHOLD_KEYS:
		_expect(CreativeLines.LINES.has(key), "LINES must keep %s" % key)
		var joined: String = _join_pairs(CreativeLines.LINES.get(key, []))
		_expect(not joined.is_empty(), "%s must serve lines" % key)
		var digest: String = str(hash(joined))
		_expect(not seen.has(digest), "%s must differ from every other opening" % key)
		seen.append(digest)
	_expect(seen.size() == 9, "3 families x 3 truths must give 9 distinct openings")


func _check_truth_marks() -> void:
	for key: String in HOUSEHOLD_KEYS:
		var joined: String = _join_pairs(CreativeLines.LINES.get(key, []))
		var mark: String = String(TRUTH_MARKS.get(key, ""))
		_expect(not mark.is_empty(), "truth mark defined for %s" % key)
		_expect(joined.contains(mark), "%s must carry its truth payoff" % key)
		for other: String in HOUSEHOLD_KEYS:
			if other == key:
				continue
			var other_mark: String = String(TRUTH_MARKS.get(other, ""))
			_expect(not joined.contains(other_mark), "%s must not carry the %s payoff" % [key, other])


func _check_shared_tails() -> void:
	for tail: String in SHARED_TAILS:
		var carriers := 0
		for key: String in HOUSEHOLD_KEYS:
			if _join_pairs(CreativeLines.LINES.get(key, [])).contains(tail):
				carriers += 1
		_expect(carriers >= 1, "shared tail must survive: %s" % tail)


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


func _check_no_thesis_or_premature() -> void:
	for key: String in HOUSEHOLD_KEYS:
		var mark: String = String(TRUTH_MARKS.get(key, "")).to_lower()
		_check_clean(mark, "payoff %s" % key)
	for text: String in _review_texts(_full_decisions()) + _review_texts(_bare_decisions()):
		_check_clean(text.to_lower(), "review table")
		_expect(text.length() <= MAX_LINE_LEN, "review line exceeds CRT fitting: %s" % text)


func _check_clean(lowered: String, where: String) -> void:
	for stem: String in THESIS_STEMS:
		_expect(not lowered.contains(stem), "%s carries a forbidden thesis stem: %s" % [where, stem])
	for term: String in PREMATURE_TERMS:
		_expect(not lowered.contains(term), "%s carries a premature term: %s" % [where, term])


func _full_decisions() -> Dictionary:
	return {
		&"world_recognized": true,
		&"method_committed": "force_home",
		&"marta_truth_state": "full",
		&"jakub_consent_state": "granted",
		&"home_sample_preserved": true,
		&"p9.mechanics.mutual_signal.log_reconstructed": true,
		&"p9.consent_and_cost.cost_ledger_read": true,
		&"p9.method_commitment.forecasts": {
			"force_home": {"available": true},
			"close_equal_recover_local": {"available": true},
			"mutual_passage": {"available": true},
		},
	}


func _bare_decisions() -> Dictionary:
	return {&"world_recognized": true}


func _review_texts(decisions: Dictionary) -> Array[String]:
	var out: Array[String] = []
	for row: Variant in CreativeLines.lines_for("method_commit_post", decisions):
		if row is Dictionary:
			out.append(String((row as Dictionary).get("text", "")))
	return out


func _check_commit_review_table() -> void:
	var full_rows: Array = CreativeLines.lines_for("method_commit_post", _full_decisions())
	_expect(full_rows.size() == 8, "committed post must serve 2 act pairs + 6 table pairs, got %d" % full_rows.size())
	var full_joined := ""
	for row: Variant in full_rows:
		if row is Dictionary:
			full_joined += String((row as Dictionary).get("text", "")) + "\n"
	_expect(full_joined.contains("Staję przy słupku sama"), "force_home keeps the pkg_0194 act marker")
	for subject: String in REVIEW_SUBJECTS:
		_expect(full_joined.contains(subject), "review table must name %s" % subject)
	for expected: String in [
		"surowa próbka z powtórzonego pomiaru", "kontakt przy pierwszym odczycie",
		"pełny zapis przekazany", "pełna zgoda", "para zdarzeń odczytana",
		"wszystkie drogi policzone",
	]:
		_expect(full_joined.contains(expected), "full state must read: %s" % expected)
	var bare_rows: Array = CreativeLines.lines_for("method_commit_post", _bare_decisions())
	_expect(bare_rows.size() == 8, "bare post must still serve 2 + 6 pairs, got %d" % bare_rows.size())
	var bare_joined := ""
	for row: Variant in bare_rows:
		if row is Dictionary:
			bare_joined += String((row as Dictionary).get("text", "")) + "\n"
	for expected: String in [
		"tylko zapis z bufora", "brak kontaktu w dzienniku", "stan nieustalony",
		"zakres nieustalony", "luka, brak odczytu", "prognozy niezestawione",
	]:
		_expect(bare_joined.contains(expected), "bare state must name its gap: %s" % expected)
	_expect(not bare_joined.contains("surowej próbki"), "branch without a kept sample must not speak of a full carrier")
	var again: Array = CreativeLines.lines_for("method_commit_post", _full_decisions())
	_expect(again.size() == 8, "review append must not mutate const LINES")
	var close_rows: Array = CreativeLines.lines_for("method_commit_post", _method_decisions("close_equal_recover_local", "partial", "limited"))
	var close_joined := ""
	for row: Variant in close_rows:
		if row is Dictionary:
			close_joined += String((row as Dictionary).get("text", "")) + "\n"
	_expect(close_joined.contains("Oddaję jej miejsce"), "close_equal keeps the pkg_0223 act marker")
	_expect(close_rows.size() == 8, "close_equal must serve 2 + 6 pairs")
	var mutual_rows: Array = CreativeLines.lines_for("method_commit_post", _method_decisions("mutual_passage", "withheld", "refused"))
	var mutual_joined := ""
	for row: Variant in mutual_rows:
		if row is Dictionary:
			mutual_joined += String((row as Dictionary).get("text", "")) + "\n"
	_expect(mutual_joined.contains("Otwieram, nie zabieram"), "mutual keeps the pkg_0194 act marker")
	_expect(mutual_rows.size() == 8, "mutual must serve 2 + 6 pairs")


func _method_decisions(method: String, truth: String, scope: String) -> Dictionary:
	var decisions: Dictionary = _full_decisions()
	decisions[&"method_committed"] = method
	decisions[&"marta_truth_state"] = truth
	decisions[&"jakub_consent_state"] = scope
	return decisions


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
		print("PKG-0226 TRUTH PAYOFF TABLE PASS: 9 distinct openings, payoff marks, 6-item table, no new facts, draw paths clean")
		quit(0)
	else:
		print("PKG-0226 TRUTH PAYOFF TABLE FAIL (%d)" % _failures.size())
		for failure: String in _failures:
			print("  - " + failure)
		quit(1)
