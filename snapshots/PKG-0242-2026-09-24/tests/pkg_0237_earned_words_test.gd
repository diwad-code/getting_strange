extends SceneTree

## PKG-0237 gate — Pakiet D: slowa, ktore musza byc zarobione (plan 2026-09-15, decyzja D-249).
##
## Dowodzi wylacznie mierzalnych kontraktow runtime, nie odbioru (D-012, ADR-003).
## Kryteria (NEXT_SESSION_PROMPT PKG-0237 / plan 2026-09-15 Pakiet D, D1–D7):
## 1. D1: "Rownia" zarobiona w 17 — Lena slyszy slowo od rejestru i w parze 1
##    rozumie, ze to tutejsza nazwa tej ciaglosci/miasta;
## 2. D2: Wierzbicka dwa tryby — lada w 11, terminal w 17 ("WIERZBICKA / ZAKRES"),
##    kwestia Leny rozpoznaje glos z lady;
## 3. D3: Analizator ma adres w 16 — nazwa na scianie "POMIESZCZENIE POMIARU / POZA OBWODEM";
## 4. D4: Final B jedno miejsce na kwestie — glowna scena 42B to prog m. 14,
##    brak wiaty linii 03 w kwestiach 42B (wiata nalezy do epilogu 43B);
## 5. D5: Final C przeciek Jakuba — echo / ekran czytnika ("JAKUB (ECHO)"),
##    nie fizyczny Jakub warsztatu w salonie;
## 6. D6: Kto steruje — opening_line_2 w 42A/B/C nazywa kontrolowane cialo (przybyla Lena);
## 7. D7: Epilog 43 galaz domyslna (unseeded) — nie kradnie tonu C ("dwie kolejnosci"),
##    brzmi jak brak zatwierdzenia / luka / brak metody.

const CreativeLines := preload("res://scripts/levels/creative_scene_lines.gd")
const Station42BClass := preload("res://scripts/levels/station_42b.gd")
const Station42CClass := preload("res://scripts/levels/station_42c.gd")
const Station43Class := preload("res://scripts/levels/station_43.gd")

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0237 FAILURE: " + message)


func _read(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "plik musi byc czytelny: %s" % path)
	if file == null:
		return ""
	var text := file.get_as_text()
	file.close()
	return text


func _run() -> void:
	print("== PKG-0237 earned words gate ==")
	_test_d1_rownea_earned()
	_test_d2_wierzbicka_two_modes()
	_test_d3_analyzer_address()
	_test_d4_finale_b_single_location()
	_test_d5_finale_c_jakub_echo()
	_test_d6_controlled_body_named()
	_test_d7_epilogue_unseeded_branch()
	_finish()


## PKG-0242 (R1): PKG-0239 (owner narrative repair, authoritative for
## content) rewrote the 17 ledger and offer. D1/D2 keep their intent on the
## owner's text: the register says "Równia" before Lena does, Lena repeats it
## as their name for the maintained area, Wierzbicka is recognised from the
## counter at 11 and defends the result instead of reciting "Stan:" (owner
## KROK 12), and Lena weighs the price before refusing.
func _test_d1_rownea_earned() -> void:
	print("1. D1: Rownia zarobiona w cost_ledger_console...")
	var pairs: Array = CreativeLines.LINES.get("cost_ledger_console", [])
	_expect(pairs.size() == 5, "cost_ledger_console trzyma 5 par (wlasciciel, PKG-0239)")
	var register_at := -1
	var lena_at := -1
	for i in range(pairs.size()):
		var pair: Array = pairs[i] as Array
		if register_at < 0 and String(pair[0]) == "REJESTR KOSZTÓW" and String(pair[1]).contains("Równia"):
			register_at = i
		if lena_at < 0 and String(pair[0]) == "Lena" and String(pair[1]).contains("Równia"):
			lena_at = i
	_expect(register_at >= 0, "rejestr wymienia Rownie")
	_expect(lena_at > register_at, "Lena powtarza Rownie dopiero po rejestrze")
	if lena_at >= 0:
		_expect(String((pairs[lena_at] as Array)[1]).contains("Tak nazywają ten utrzymany obszar"), "Lena rozumie, ze to tutejsza nazwa")
	var joined := ""
	for pair: Variant in pairs:
		joined += String((pair as Array)[1]) + "\n"
		_expect(String((pair as Array)[1]).length() <= 115, "kwestia miesci sie w pudle CRT (<=115): %s" % String((pair as Array)[1]))
	_expect(joined.contains("pochowałam brata"), "Lena zestawia to ze swoim swiatem (pogrzeb brata)")
	_expect(joined.contains("powiązany koszt"), "rejestr trzyma powiazany koszt")
	# Earned: no line served before 17 says the word.
	for key: String in CreativeLines.LINES.keys():
		if key in ["cost_ledger_console"] or key.begins_with("forecast_") or key.begins_with("marta_truth") or key.begins_with("method_commit") or key.begins_with("household") or key in ["flow_closure", "local_lena_recovered", "mutual_passage", "memory_leak", "forced_return_latch", "sealed_other_lena", "adaptation_offer_terminal"] or key.begins_with("consent_scope"):
			continue
		_expect(not JSON.stringify(CreativeLines.LINES[key]).contains("Równi"), "%s nie wypowiada Rowni przed 17" % key)


func _test_d2_wierzbicka_two_modes() -> void:
	print("2. D2: Wierzbicka dwa tryby (11 lada, 17 terminal)...")
	var s17_tscn := _read("res://scenes/levels/station_17.tscn")
	_expect(s17_tscn.contains("WIERZBICKA / ZAKRES"), "station_17.tscn etykieta terminala nazywa Wierzbicka / Zakres")
	var offer_pairs: Array = CreativeLines.LINES.get("adaptation_offer_terminal", [])
	_expect(offer_pairs.size() == 6, "adaptation_offer_terminal trzyma 6 par (wlasciciel, PKG-0239)")
	if offer_pairs.size() >= 6:
		_expect(String((offer_pairs[0] as Array)[0]) == "Wierzbicka (terminal)", "p0: Wierzbicka mowi w 17 przez terminal")
		_expect(String((offer_pairs[0] as Array)[1]).contains("Wynik zostanie utrzymany"), "p0: Wierzbicka broni utrzymanego wyniku")
		_expect(String((offer_pairs[1] as Array)[0]) == "Lena", "p1: Lena reaguje na glos")
		_expect(String((offer_pairs[1] as Array)[1]).contains("Poznaję głos z lady"), "p1: Lena rozpoznaje Wierzbicka z lady w 11")
		_expect(String((offer_pairs[1] as Array)[1]).contains("A ona?"), "p1: Lena pyta o cene zastepstwa")
		_expect(String((offer_pairs[4] as Array)[1]).contains("bezpieczeństwa tej strony"), "p4: Wierzbicka naciska argumentem")
		_expect(String((offer_pairs[5] as Array)[0]) == "Lena", "p5: Lena odmawia")
		_expect(String((offer_pairs[5] as Array)[1]).contains("Nie podpiszę"), "p5: odmowa Leny")
	for pair: Variant in offer_pairs:
		var text := String((pair as Array)[1])
		_expect(text.length() <= 115, "kwestia miesci sie w pudle CRT (<=115): %s" % text)
		_expect(not text.contains("Stan:"), "Wierzbicka nie recytuje stanu (wlasciciel KROK 12)")


func _test_d3_analyzer_address() -> void:
	print("3. D3: Analizator ma adres w station_16...")
	var s16_tscn := _read("res://scenes/levels/station_16.tscn")
	_expect(s16_tscn.contains("POMIESZCZENIE POMIARU / POZA OBWODEM"), "station_16.tscn zawiera diegetyczny adres analizatora")
	var s16_gd := _read("res://scripts/levels/station_16.gd")
	_expect(not s16_gd.contains("draw_string("), "station_16.gd przestrzega zasady zero draw_string (V9)")


func _test_d4_finale_b_single_location() -> void:
	print("4. D4: Final B jedno miejsce na kwestie (prog m. 14, brak wiaty w 42B)...")
	var lines_b := Station42BClass.DIALOGUE_LINES
	_expect(lines_b.size() == 4, "station_42b trzyma 4 kwestie w DIALOGUE_LINES (pin 0107)")
	if lines_b.size() >= 4:
		var last_line := lines_b[3]
		_expect(String(last_line.get("text", "")).contains("Stoję w progu"), "DIALOGUE_LINES[3] stawia Lene w progu")
		_expect(not String(last_line.get("text", "")).contains("wiacie"), "DIALOGUE_LINES[3] nie miesza wiaty w mieszkaniu")
	var s42b_gd := _read("res://scripts/levels/station_42b.gd")
	_expect(not s42b_gd.contains("wiacie z linii 03"), "station_42b.gd nie zawiera wiaty z linii 03")
	for key: String in ["household_b_full", "household_b_partial", "household_b_withheld"]:
		var pairs: Array = CreativeLines.LINES.get(key, [])
		_expect(pairs.size() == 4, "%s trzyma 4 pary (wlasciciel, PKG-0239)" % key)
		if not pairs.is_empty():
			var p0: Array = pairs[0] as Array
			_expect(String(p0[1]).contains("Stoję w progu"), "%s otwiera sie w progu" % key)
			_expect(not String(p0[1]).contains("wiacie"), "%s nie miesza wiaty w mieszkaniu" % key)
		var joined := ""
		for pair: Variant in pairs:
			joined += String((pair as Array)[1]) + " "
		_expect(joined.contains("Jadę"), "%s trzyma palimpsest Jade" % key)
		_expect(joined.contains("Tak"), "%s trzyma palimpsest Tak" % key)


func _test_d5_finale_c_jakub_echo() -> void:
	print("5. D5: Final C przeciek Jakuba to echo / czytnik...")
	var leak_pairs: Array = CreativeLines.LINES.get("memory_leak", [])
	_expect(leak_pairs.size() == 4, "memory_leak trzyma 4 pary")
	if leak_pairs.size() >= 4:
		var p0: Array = leak_pairs[0] as Array
		var p2: Array = leak_pairs[2] as Array
		_expect(String(p0[0]) == "JAKUB (ECHO)", "p0: glos Jakuba to JAKUB (ECHO)")
		_expect(String(p2[0]) == "JAKUB (ECHO)", "p2: odpowiedz Jakuba to JAKUB (ECHO)")
	var lines_c := Station42CClass.DIALOGUE_LINES
	_expect(lines_c.size() == 4, "station_42c trzyma 4 kwestie w DIALOGUE_LINES (pin 0107)")
	if lines_c.size() >= 4:
		var l3 := lines_c[3]
		_expect(String(l3.get("speaker", "")) == "JAKUB (ECHO)", "DIALOGUE_LINES[3] oznacza Jakuba jako JAKUB (ECHO)")
	var s42c_tscn := _read("res://scenes/levels/station_42c.tscn")
	_expect(not s42c_tscn.contains("character_id = &\"jakub\""), "station_42c.tscn nie stawia ciala Jakuba w salonie")


func _test_d6_controlled_body_named() -> void:
	print("6. D6: Kto steruje w 42A/B/C...")
	for scene_name: String in ["station_42a", "station_42b", "station_42c"]:
		var tscn := _read("res://scenes/levels/%s.tscn" % scene_name)
		_expect(tscn.contains("opening_line_2 = \""), "%s ma opening_line_2" % scene_name)
		# PKG-0242 (R1): the owner's cue is spoken by the Lena who chose at
		# the post — the arrived one the player steers.
		_expect(tscn.contains("opening_line_2 = \"W nocy przy słupku wybrałam"), "%s nazywa sterowane cialo: przybyla Lena" % scene_name)


func _test_d7_epilogue_unseeded_branch() -> void:
	print("7. D7: Epilog 43 galaz domyslna (unseeded) bez kradziezy tonu C...")
	var s43_gd := _read("res://scripts/levels/station_43.gd")
	var default_lines := Station43Class.DEFAULT_DIALOGUE_LINES
	_expect(default_lines.size() == 5, "DEFAULT_DIALOGUE_LINES ma 5 linii")
	var all_default := ""
	for entry: Dictionary in default_lines:
		var t := String(entry.get("text", ""))
		all_default += t + " "
		_expect(t.length() <= 115, "linia domyslna <=115 znakow: %s" % t)
	_expect(not all_default.contains("dwie kolejności"), "DEFAULT_DIALOGUE_LINES nie kradnie tonu C (dwie kolejnosci)")
	_expect(all_default.contains("Brak potwierdzonej metody"), "DEFAULT_DIALOGUE_LINES nazywa brak metody")
	_expect(all_default.contains("Brak podpisanego rozstrzygnięcia"), "DEFAULT_DIALOGUE_LINES brzmi jak luka w rejestrze")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0237 PASS: earned words contracts hold (D1–D7, pins intact).")
		quit(0)
		return
	for f in _failures:
		printerr("PKG-0237 FAILURE: " + f)
	quit(1)
