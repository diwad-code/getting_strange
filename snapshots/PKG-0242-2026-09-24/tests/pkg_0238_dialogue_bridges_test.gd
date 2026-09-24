extends SceneTree

## PKG-0238 gate — Pakiet E: mosty dialogowe (plan 2026-09-15, decyzja D-250).
##
## Dowodzi wylacznie mierzalnych kontraktow runtime, nie odbioru (D-012, ADR-003).
## Kryteria (NEXT_SESSION_PROMPT PKG-0238 / plan 2026-09-15 Pakiet E, E1–E3):
## 1. E1: Ogniwa dialogowe i ciaglosc 09–18:
##    - 10: po marta_boundary -> wyjscie z domu do UCP (s10_exit_ucp_record);
##    - 11: minimal_report zawiera kontakt do warsztatu, 186 dni i Jakuba;
##    - 13: synthesize zachowuje „to nie jest moj swiat / gdzie jest ona”;
##    - 17: cost_ledger_console zarabia „Rownie” obok pary pogrzeb / stabilnosc;
##    - 42B: rozdzielenie progu i wiaty, zachowany oddech i klucz;
##    - 42C: oznaczenie przecieku (JAKUB (ECHO)), kubek, polka, odpowiedzialnosc;
##    - ciaglosc narracyjna wejsc i wyjsc na calym odcinku 09–18 bez luk przyczynowych.
## 2. E2: Trzy sekundy — nie wykladac wprost:
##    - brak kwestii wyjasniajacych „aha, to te same trzy sekundy”;
##    - w 15 dopisek olowkiem „przepraszam M. — 3 s.” nienaruszony.
## 3. E3: Rezerwy DIALOGUE_LINES w 42A/B/C:
##    - dokladnie po 4 linie (pin 0107);
##    - wyrownane lub opatrzone komentarzem o roli fallbacku edytora;
##    - brak reliktow wiaty w 42B i fizycznego Jakuba przy imadle w 42C.
## 4. Format i budzet CRT: wszystkie kwestie <= 115 znakow (pin 0194/0195).

const CreativeLines := preload("res://scripts/levels/creative_scene_lines.gd")
const Station42AClass := preload("res://scripts/levels/station_42a.gd")
const Station42BClass := preload("res://scripts/levels/station_42b.gd")
const Station42CClass := preload("res://scripts/levels/station_42c.gd")

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0238 FAILURE: " + message)


func _read(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "plik musi byc czytelny: %s" % path)
	if file == null:
		return ""
	var text := file.get_as_text()
	file.close()
	return text


func _run() -> void:
	print("== PKG-0238 dialogue bridges gate ==")
	_test_e1_dialogue_links()
	_test_e1_route_continuity_09_18()
	_test_e2_three_seconds_implicit()
	_test_e3_reserve_dialogue_lines_42abc()
	_test_crt_line_length()
	_finish()


func _test_e1_dialogue_links() -> void:
	print("1. E1: Ogniwa dialogowe...")
	# 10: wyjscie do UCP
	var s10_gd := _read("res://scripts/levels/station_10.gd")
	_expect(s10_gd.contains("Marta twierdzi, że pracuję w UCP. Zostawiam jej telefon i wychodzę"), "10: s10_exit_ucp_record nazywa wyjscie z domu i zostawienie telefonu")
	_expect(s10_gd.contains("zanim uznam to za moje"), "10: s10_exit_ucp_record trzyma hipoteze sprawdzenia zapisu")

	# 11: kontakt do warsztatu + rejestr 186 dni
	var rep_pairs: Array = CreativeLines.LINES.get("minimal_report", [])
	# PKG-0242 (R1): pins below follow the owner's PKG-0239 text (the
	# bridge contract is kept; only the wording and pair counts moved).
	_expect(rep_pairs.size() == 5, "11: minimal_report trzyma 5 par (wlasciciel, PKG-0239)")
	if rep_pairs.size() >= 1:
		var last_rep := rep_pairs[rep_pairs.size() - 1] as Array
		_expect(String(last_rep[1]).contains("kontakt do warsztatu"), "11: minimal_report zawiera kontakt do warsztatu")
	var rec_pairs: Array = CreativeLines.LINES.get("record_186_days", [])
	_expect(rec_pairs.size() == 5, "11: record_186_days trzyma 5 par")
	if rec_pairs.size() >= 5:
		var last_rec := rec_pairs[4] as Array
		_expect(String(last_rec[1]).contains("Poproszę numer warsztatu"), "11: record_186_days prosi o numer warsztatu")
		var p1 := rec_pairs[1] as Array
		_expect(String(p1[1]).contains("186 dni aktywności") or String((rec_pairs[0] as Array)[1]).contains("186 dni aktywności"), "11: rejestr zawiera 186 dni")
		_expect(String(p1[1]).contains("Jakub"), "11: Lena rozpoznaje Jakuba")

	# 13: to nie jest moj swiat / gdzie jest ona
	var syn_pairs: Array = CreativeLines.LINES.get("synthesize", [])
	_expect(syn_pairs.size() == 8, "13: synthesize trzyma 8 par (wlasciciel, PKG-0239)")
	var syn_text := JSON.stringify(syn_pairs)
	_expect(syn_text.contains("To nie jest mój świat"), "13: synthesize wypowiada wniosek: to nie jest moj swiat")
	_expect(syn_text.contains("gdzie jest ona"), "13: synthesize pyta: gdzie jest ona")
	_expect(syn_text.find("To nie jest mój świat") < syn_text.find("gdzie jest ona"), "13: wniosek poprzedza pytanie")

	# 17: Rownia zarobiona + para pogrzeb/stabilnosc
	var led_pairs: Array = CreativeLines.LINES.get("cost_ledger_console", [])
	_expect(led_pairs.size() == 5, "17: cost_ledger_console trzyma 5 par (wlasciciel, PKG-0239)")
	var led_text := JSON.stringify(led_pairs)
	_expect(led_text.contains("katastrofę, po której pochowałam brata") and led_text.contains("Obszar utrzymywanego wyniku: Równia"), "17: rejestr zestawia utrzymana Rownie i pogrzeb")
	_expect(led_text.contains("Równia. Tak nazywają ten utrzymany obszar"), "17: Lena zarabia imie Rownia")

	# 42B: oddech, klucz, brak wiaty
	var loc_pairs: Array = CreativeLines.LINES.get("local_lena_recovered", [])
	_expect(loc_pairs.size() == 5, "42B: local_lena_recovered trzyma 5 par (wlasciciel, PKG-0239)")
	var loc_text := JSON.stringify(loc_pairs)
	_expect(String((loc_pairs[0] as Array)[1]).contains("Co wiedziałaś przed testem"), "42B: pytanie Marty przed testem")
	_expect(loc_text.contains("Zaczęłam, zanim mogła odpowiedzieć"), "42B: miejscowa przyznaje wlasna decyzje")
	_expect(loc_text.contains("Zaczniemy od tego, co zrobiłaś ty"), "42B: Marta trzyma odpowiedzialnosc miejscowej przy sobie")
	for key: String in ["household_b_full", "household_b_partial", "household_b_withheld"]:
		var pairs: Array = CreativeLines.LINES.get(key, [])
		if not pairs.is_empty():
			var p0 := pairs[0] as Array
			_expect(String(p0[1]).contains("Stoję w progu"), "42B: %s zaczyna sie w progu" % key)
			_expect(not String(p0[1]).contains("wiacie"), "42B: %s nie miesza wiaty w mieszkaniu" % key)

	# 42C: przeciek Jakuba, kubek, polka, odpowiedzialnosc
	var leak_pairs: Array = CreativeLines.LINES.get("memory_leak", [])
	_expect(leak_pairs.size() == 4, "42C: memory_leak trzyma 4 pary")
	if leak_pairs.size() >= 4:
		var p0 := leak_pairs[0] as Array
		_expect(String(p0[0]) == "JAKUB (ECHO)", "42C: glos przecieku to JAKUB (ECHO)")
		_expect(String(p0[1]).contains("prosektorium"), "42C: tresc przecieku imadlo/prosektorium")
	var c_full: Array = CreativeLines.LINES.get("household_c_full", [])
	if c_full.size() >= 5:
		var p0 := c_full[0] as Array
		var p2 := c_full[2] as Array
		var p4 := c_full[4] as Array
		_expect(String(p0[1]).contains("Znam ten kubek"), "42C: Marta rozpoznaje kubek")
		_expect(String(p2[1]).contains("skąd go pamiętam"), "42C: przeciek jako obca pamiec kubka")
		_expect(String(p4[1]).contains("Pamiętam kubek, nie twoją opowieść"), "42C: Marta oddziela przeciek od opowiesci")
	var passage_text := JSON.stringify(CreativeLines.LINES.get("mutual_passage", []))
	_expect(passage_text.contains("To nie usuwa mojej decyzji"), "42C: odpowiedzialnosc miejscowej obok nacisku UCP")


func _test_e1_route_continuity_09_18() -> void:
	print("2. E1: Ciaglosc przyczynowa wejsc i wyjsc na odcinku 09–18...")
	# 09 wyjscie -> 10 wejscie
	var s09_lines: Array = CreativeLines.LINES.get("private_boundary", [])
	_expect(String((s09_lines[1] as Array)[1]).contains("Zapytam Martę"), "09: wyjscie zapowiada rozmowe z Marta")
	var s10_tscn := _read("res://scenes/levels/station_10.tscn")
	_expect(s10_tscn.contains("Marta wyciera blat"), "10: wejscie wita Marta przy stole")

	# 10 wyjscie -> 11 wejscie
	var s10_gd := _read("res://scripts/levels/station_10.gd")
	_expect(s10_gd.contains("zapis sprawdzę w UCP"), "10: wyjscie zapowiada sprawdzenie zapisu w UCP")
	var s11_tscn := _read("res://scenes/levels/station_11.tscn")
	_expect(s11_tscn.contains("Wierzbicka czeka"), "11: wejscie wita lada UCP i Wierzbicka")

	# 11 wyjscie -> 12 wejscie
	var s11_rep: Array = CreativeLines.LINES.get("minimal_report", [])
	_expect(String((s11_rep[s11_rep.size() - 1] as Array)[1]).contains("kontakt do warsztatu"), "11: wyjscie bierze kontakt do warsztatu")
	var s12_tscn := _read("res://scenes/levels/station_12.tscn")
	_expect(s12_tscn.contains("ŁĄCZE WARSZTATOWE") or s12_tscn.contains("łącze"), "12: wejscie wita laczem warsztatowym")

	# 12 wyjscie -> 13 wejscie
	var s12_gd := _read("res://scripts/levels/station_12.gd")
	_expect(s12_gd.contains("Wracam do mieszkania, do wspólnego stołu"), "12: wyjscie zapowiada powrot do wspolnego stolu")
	var s13_tscn := _read("res://scenes/levels/station_13.tscn")
	_expect(s13_tscn.contains("Marta odsunęła filiżanki. Kładę torbę przy znanym stole"), "13: wejscie wita Marta i znanym stolem")

	# 13 wyjscie -> 14 wejscie
	var s13_gd := _read("res://scripts/levels/station_13.gd")
	_expect(s13_gd.contains("Wyciąg wskazuje sekcję rozdzielni — zejdę włazem serwisowym"), "13: wyjscie zapowiada zejscie wlazem do rozdzielni")
	var s14_tscn := _read("res://scenes/levels/station_14.tscn")
	_expect(s14_tscn.contains("Zeszłam włazem serwisowym za klatką schodową"), "14: wejscie potwierdza zejscie wlazem za klatka")

	# 14 wyjscie -> 15 wejscie
	var s14_gd := _read("res://scripts/levels/station_14.gd")
	_expect(s14_gd.contains("Z mostu do pętli — wyciąg mówi, gdzie szukać echa"), "14: wyjscie zapowiada przejscie z mostu do petli")
	var s15_tscn := _read("res://scenes/levels/station_15.tscn")
	_expect(s15_tscn.contains("Schodzę do pętli sprawdzić, czyje to echo"), "15: wejscie potwierdza zejscie do petli")

	# 15 wyjscie -> 16 wejscie
	var s15_gd := _read("res://scripts/levels/station_15.gd")
	_expect(s15_gd.contains("Niosę je do analizatora poza obwodem"), "15: wyjscie zapowiada analizator poza obwodem")
	var s16_tscn := _read("res://scenes/levels/station_16.tscn")
	_expect(s16_tscn.contains("Niosę odpowiedź do analizatora poza obwodem"), "16: wejscie potwierdza analizator poza obwodem")

	# 16 wyjscie -> 17 wejscie
	var s16_gd := _read("res://scripts/levels/station_16.gd")
	_expect(s16_gd.contains("pójdę do rejestru par w hali UCP"), "16: wyjscie zapowiada rejestr par w hali UCP")
	var s17_tscn := _read("res://scenes/levels/station_17.tscn")
	_expect(s17_tscn.contains("idę do rejestru par w hali UCP"), "17: wejscie potwierdza rejestr par w hali UCP")

	# 17 wyjscie -> 18 wejscie
	var s17_gd := _read("res://scripts/levels/station_17.gd")
	_expect(s17_gd.contains("Zabiorę odpisy do Marty na ulicę"), "17: wyjscie zapowiada powrot na ulice")
	var s18_tscn := _read("res://scenes/levels/station_18.tscn")
	_expect(s18_tscn.contains("Przyniosłam odpisy z hali. Marta czeka na znanej ulicy"), "18: wejscie potwierdza znana ulice i Marte")


func _test_e2_three_seconds_implicit() -> void:
	print("3. E2: Trzy sekundy — tajemnica nie wykladana wprost...")
	var s15_gd := _read("res://scripts/levels/station_15.gd")
	_expect(s15_gd.contains("przepraszam M. — 3 s."), "15: dopisek olowkiem przepraszam M. — 3 s. stoi nienaruszony")
	var lines_text := _read("res://scripts/levels/creative_scene_lines.gd")
	_expect(not lines_text.contains("te same trzy sekundy co na stanowisku"), "linie nie wykladaja wprost tozsamosci trzech sekund")
	_expect(not lines_text.contains("Aha, to te same"), "brak dydaktycznych wstawek o trzech sekundach")


func _test_e3_reserve_dialogue_lines_42abc() -> void:
	print("4. E3: Rezerwy DIALOGUE_LINES w 42A/B/C...")
	var lines_a := Station42AClass.DIALOGUE_LINES
	_expect(lines_a.size() == 4, "42A: DIALOGUE_LINES ma dokladnie 4 linie (pin 0107)")
	var lines_b := Station42BClass.DIALOGUE_LINES
	_expect(lines_b.size() == 4, "42B: DIALOGUE_LINES ma dokladnie 4 linie (pin 0107)")
	var lines_c := Station42CClass.DIALOGUE_LINES
	_expect(lines_c.size() == 4, "42C: DIALOGUE_LINES ma dokladnie 4 linie (pin 0107)")

	# Brak reliktow wiaty w 42B
	for entry: Dictionary in lines_b:
		var t := String(entry.get("text", ""))
		_expect(not t.contains("wiacie"), "42B DIALOGUE_LINES bez wiaty")
	var s42b_gd := _read("res://scripts/levels/station_42b.gd")
	_expect(not s42b_gd.contains("odcina się do wiaty"), "42B komentarz bez reliktu wiaty")
	_expect(s42b_gd.contains("fallback") or s42b_gd.contains("rezerwa ta nie gra"), "42B komentarz wyjasnia role fallbacku")

	# Brak fizycznego Jakuba przy imadle w 42C
	_expect(String(lines_c[3].get("speaker", "")) == "JAKUB (ECHO)", "42C DIALOGUE_LINES[3] oznacza Jakuba jako JAKUB (ECHO)")
	var s42c_gd := _read("res://scripts/levels/station_42c.gd")
	_expect(s42c_gd.contains("fallback") or s42c_gd.contains("rezerwa ta nie gra"), "42C komentarz wyjasnia role fallbacku")
	_expect(s42c_gd.contains("JAKUB (ECHO)"), "42C komentarz nazywa echo Jakuba")

	# 42A komentarz fallbacku
	var s42a_gd := _read("res://scripts/levels/station_42a.gd")
	_expect(s42a_gd.contains("fallback") or s42a_gd.contains("rezerwa ta nie gra"), "42A komentarz wyjasnia role fallbacku")


func _test_crt_line_length() -> void:
	print("5. CRT: limit dlugosci linii (<= 115 znakow)...")
	for id: String in CreativeLines.LINES:
		var pairs: Array = CreativeLines.LINES[id]
		for pair_val: Variant in pairs:
			if pair_val is Array and (pair_val as Array).size() >= 2:
				var t := String((pair_val as Array)[1])
				_expect(t.length() <= 115, "kwestia [%s] <= 115 znakow (%d): %s" % [id, t.length(), t])


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0238 PASS: dialogue bridges contracts hold (E1–E3, pins intact).")
		quit(0)
		return
	for failure in _failures:
		printerr("PKG-0238 FAILURE: " + failure)
	quit(1)
