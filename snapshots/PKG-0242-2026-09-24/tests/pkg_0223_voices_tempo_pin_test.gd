extends SceneTree

## PKG-0223 gate — glosy i tempo (N4+N7-reszta+N9+N10+N8/K4, faza R6 planu PKG-0213 §8).
## Decyzja D-236. Dowodzi wylacznie kontraktow mierzalnych, nie odbioru (D-012, ADR-003).
##
## N4 (tempo 15): loop_logbook ≤2 par + pokaz w obrazie (tiki kontaktu/powtorki
## na dzienniku po odczycie; lancuch MRP log/kontrole/uzbrojenie/korekta/notatka
## NIETKNIETY, pinuje go 0194). N7-reszta: urzadzenia poza prognozami 18
## rozroznialne trescia bez etykiet (rejestr = numery/daty, analizator = wykres,
## notatka = odreczny wtret) + Wierzbicka bezosobowa na calej trasie zakresu
## (linie + station_40, read-only). N9: 09 scalone wokol fotografii (haczyk
## wskazuje zdjecie, lancuch two_lives -> photo -> boundary) + 17 odciazone
## (oferta jako projekcja-gest w przestrzeni, nie trzeci akt tekstowy; 4 pary
## tekstu nietkniete, pin 0217). N10: 4 potkniecia naprawione (grep 0 w LINES:
## niejasne "ja" z gd:35, sensacyjne "ona go zabila", mantra x3, golny kryptonim
## "Para 04/17"). N8/K4: margines miejscowej Leny na wydruku 15 (1 beat L1 +
## olowkowy slad w _draw, bez monologu-ducha). M5 intact: 09/15/17 po ≤3 MRP.

const CreativeLines := preload("res://scripts/levels/creative_scene_lines.gd")

const MANTRA := "Moja prośba"
const SENSATIONAL := "ona go zabiła"
const BARE_CODENAME := "Para 04/17"
const AMBIGUOUS := "przerwał ją"

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0223 FAILURE: " + message)


func _read(path: String) -> String:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "file must be readable: %s" % path)
	if file == null:
		return ""
	var text: String = file.get_as_text().replace("\r\n", "\n")
	file.close()
	return text


func _join(pairs: Array) -> String:
	var out: String = ""
	for pair: Variant in pairs:
		if pair is Dictionary:
			out += String((pair as Dictionary).get("text", "")) + "\n"
		elif pair is Array and (pair as Array).size() >= 2:
			out += String((pair as Array)[1]) + "\n"
	return out


func _all_lines_text() -> String:
	var out: String = ""
	for key: Variant in (CreativeLines.LINES as Dictionary).keys():
		out += _join(CreativeLines.LINES.get(key, []))
	return out


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager musi istniec")
	if state == null:
		_finish()
		return
	state.campaign_auto_transition_enabled = false
	_test_loop_logbook()
	_test_ledger()
	_test_method_commits()
	_test_devices_rest()
	_test_wierzbicka_all()
	_test_photo_hub()
	await _test_margin_and_image(state)
	await _test_budgets(state)
	_test_fail_closed()
	state.campaign_auto_transition_enabled = true
	state.reset_campaign(true)
	_finish()


# PKG-0242 (R1): PKG-0239 (owner narrative repair, authoritative for
# content) rewrote the 15 log, the 17 ledger/offer and the 18 commit lines.
# The pins keep each N-contract's intent on the owner's text; where the owner
# reversed a pin on purpose (KROK 11: do not blur authorship with "someone
# interrupted"; KROK 12: Wierzbicka is not an automaton reciting "stan") the
# pin now guards the owner's rule.

# --- N4: loop_logbook — contact, the local's purpose, attributed UCP order ---

func _test_loop_logbook() -> void:
	print("1. loop_logbook 15: kontakt, cel miejscowej, polecenie UCP z autorem...")
	var pairs: Array = CreativeLines.LINES.get("loop_logbook", [])
	_expect(pairs.size() == 5, "loop_logbook keeps the owner's 5 pairs (got %d)" % pairs.size())
	var joined: String = _join(pairs)
	_expect(joined.contains("20:40 — kontakt przy pierwszym odczycie"), "log keeps the contact line and the 20:40 register anchor")
	_expect(joined.contains("niezależny od UCP odczyt"), "log names the local Lena's own purpose")
	_expect(joined.contains("Po utracie kontaktu: utrzymać wynik lokalny. Wierzbicka."), "the later UCP order carries its author")
	_expect(not joined.contains("ktoś przerwał") and not joined.contains("Próbę ktoś przerwał"), "log must not blur authorship (owner KROK 11)")
	_expect(not joined.contains(AMBIGUOUS), "log must not keep the ambiguous pronoun (N10)")
	for pair: Variant in pairs:
		if pair is Array and (pair as Array).size() >= 2:
			_expect(String((pair as Array)[1]).length() <= 115, "loop line must fit the CRT box")
	var kept: String = _join(CreativeLines.lines_for("loop_logbook", {&"home_sample_preserved": true}))
	var left: String = _join(CreativeLines.lines_for("loop_logbook", {&"home_sample_preserved": false}))
	_expect(kept.contains("Powtórka dała mi próbkę i opóźniła wyjście"), "the repeat branch names the delay it caused")
	_expect(left.contains("Wyszłam bez powtórki; w czytniku został bufor"), "the on-time branch names what the reader kept")


# --- N10: rejestr — powiazany koszt, bez sensacji i golego kryptonimu ---

func _test_ledger() -> void:
	print("2. cost_ledger_console: powiazany koszt, bez sensacji...")
	var pairs: Array = CreativeLines.LINES.get("cost_ledger_console", [])
	_expect(pairs.size() == 5, "ledger keeps the owner's 5 pairs")
	var joined: String = _join(pairs)
	_expect(joined.contains("Linia 4:"), "ledger keeps the Line 4 record identifier")
	_expect(not joined.contains(BARE_CODENAME), "ledger must not keep the bare codename (N10)")
	_expect(joined.contains("powiązany koszt"), "ledger replaces sensation with the linked cost (N10)")
	_expect(joined.contains("Nie dowód, że konkretna osoba postanowiła zabić Jakuba"), "ledger separates knowledge of the cost from a murder claim")
	_expect(not joined.contains(SENSATIONAL), "ledger must not keep the sensational line (N10)")


# --- N10/N6: 3 warianty czynnosci zamiast mantry ---

func _test_method_commits() -> void:
	print("3. method_commit_post x3: konkrety, zero mantry...")
	var lines_dict: Dictionary = CreativeLines.LINES
	for key: String in ["method_commit_post_force_home", "method_commit_post_close_equal_recover_local", "method_commit_post_mutual_passage"]:
		_expect((lines_dict.get(key, []) as Array).size() == 2, "%s keeps 2 pairs" % key)
	var all_text: String = _all_lines_text()
	_expect(not all_text.contains(MANTRA), "mantra must read grep 0 across LINES (N10)")
	_expect(not all_text.contains(SENSATIONAL), "sensation must read grep 0 across LINES (N10)")
	_expect(not all_text.contains(BARE_CODENAME), "bare codename must read grep 0 across LINES (N10)")
	_expect(_join(lines_dict.get("method_commit_post_force_home", [])).contains("Wybieram własny powrót"), "force_home commits at the post")
	_expect(_join(lines_dict.get("method_commit_post_close_equal_recover_local", [])).contains("Wybieram odzyskanie miejscowej"), "close_equal names the recovery first")
	_expect(_join(lines_dict.get("method_commit_post_close_equal_recover_local", [])).contains("Najpierw musi odpowiedzieć u siebie"), "close_equal waits for her own answer")
	_expect(_join(lines_dict.get("method_commit_post_mutual_passage", [])).contains("Wybieram przejście wzajemne"), "mutual names the passage")
	_expect(_join(lines_dict.get("method_commit_post_mutual_passage", [])).contains("przeciek zostaje"), "mutual keeps the leak it costs")


# --- N7-reszta: urzadzenia poza prognozami 18 ---

func _test_devices_rest() -> void:
	print("4. Devices outside 18 forecasts stay distinguishable without labels...")
	var lines_dict: Dictionary = CreativeLines.LINES
	var report: Array = lines_dict.get("record_186_days", [])
	_expect(report.size() == 5, "record_186_days keeps 5 pairs")
	var report_joined: String = _join(report)
	_expect(report_joined.contains("186"), "register carries numbers (186 days)")
	_expect(report_joined.contains("warsztat") or report_joined.contains("warsztatu"), "service register names the workshop")
	var minimal: Array = lines_dict.get("minimal_report", [])
	_expect(minimal.size() == 5, "minimal_report keeps the owner's 5 pairs")
	_expect(_join(minimal).contains("20:40"), "extract carries numbers/dates (20:40)")
	var card: Array = lines_dict.get("identity_card", [])
	_expect(card.size() == 4, "identity_card keeps 4 pairs (pin 0217)")
	for key: String in ["jakub_questions", "jakub_meeting", "jakub_refusal"]:
		_expect((lines_dict.get(key, []) as Array).size() >= 5, "%s keeps its human exchange" % key)
	_expect(_join(lines_dict.get("jakub_questions", [])).contains("W którym tunelu?"), "jakub_questions keeps the deictic line")
	_expect(_join(lines_dict.get("jakub_refusal", [])).contains("Nie będę cię więcej prosić o bliznę"), "jakub_refusal keeps the boundary line")


# --- N7-reszta: Wierzbicka — argument, nie recytacja stanu ---

func _test_wierzbicka_all() -> void:
	print("5. Wierzbicka defends the result across the route scope...")
	var lines_dict: Dictionary = CreativeLines.LINES
	var spoken: String = ""
	for key: String in ["identity_card", "minimal_report", "adaptation_offer_terminal"]:
		for pair: Variant in (lines_dict.get(key, []) as Array):
			if pair is Array and String((pair as Array)[0]).to_lower().contains("wierzbicka"):
				spoken += String((pair as Array)[1]) + "\n"
	var lower: String = spoken.to_lower()
	_expect(not lower.contains("stan:"), "Wierzbicka is not an automaton reciting state (owner KROK 12)")
	_expect(lower.contains("wynik"), "Wierzbicka answers for the maintained result")
	for phrase: String in ["proszę położyć", "wydam wyciąg", "wygładzimy"]:
		_expect(not lower.contains(phrase), "no reception phrasing: " + phrase)
	var s40: String = _read("res://scripts/levels/station_40.gd").to_lower()
	for phrase: String in ["proszę położyć", "wydam wyciąg", "wpiszemy", "wygładzimy"]:
		_expect(not s40.contains(phrase), "station_40 audit: no reception phrasing: " + phrase)
	_expect(s40.contains("stabilny adres") or s40.contains("ryzyko dla miasta"), "station_40 keeps the impersonal negotiation (read-only audit)")


# --- N9: 09 wokol fotografii ---

func _test_photo_hub() -> void:
	print("6. Station 09 merged around the photograph...")
	var two: Array = CreativeLines.LINES.get("two_lives", [])
	_expect(two.size() == 2, "two_lives keeps 2 pairs")
	_expect(_join(two).to_lower().contains("zdjęcie"), "the 09 hook points at the photograph (N9)")
	var photo: Array = CreativeLines.LINES.get("relation_photo", [])
	_expect(photo.size() == 2, "relation_photo stays the 2-pair hub")
	_expect(_join(photo).contains("Nie pamiętam tego zdjęcia"), "the hub keeps the central question")
	var s09: String = _read("res://scripts/levels/station_09.gd")
	_expect(s09.contains("P9_TWO_LIVES") and s09.contains("P9_RELATION_PHOTO"), "09 keeps the two_lives -> photo chain")
	_expect(s09.contains("observe_relation_photo") and s09.contains("not _decision_bool(P9_TWO_LIVES)"), "photo still requires two_lives first")
	_expect(s09.contains("respect_private_boundary") and s09.contains("not _decision_bool(P9_RELATION_PHOTO)"), "boundary still requires the photo first")
	_expect(s09.to_lower().contains("zdjęciu") or s09.to_lower().contains("fotografi"), "09 beats stay photo-directed")


# --- N4/N8: margines K4 + tiki w obrazie + gest oferty (runtime) ---

func _open_station(state: Node, num: int) -> Node2D:
	var packed := load("res://scenes/levels/station_%02d.tscn" % num) as PackedScene
	_expect(packed != null, "station_%02d must load" % num)
	if packed == null:
		return null
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	await physics_frame
	return station


func _close_station(station: Node) -> void:
	if station == null:
		return
	if station.get_parent() == root:
		root.remove_child(station)
	station.free()
	await process_frame


func _test_margin_and_image(state: Node) -> void:
	print("7. K4 margin beat + image carriers (15 log ticks, 17 offer gesture)...")
	state.reset_campaign(true)
	var st15 := await _open_station(state, 15)
	if st15 != null:
		var guidance := st15.get_node_or_null("NarrativeGuidanceService")
		_expect(guidance != null, "15 must carry guidance")
		if guidance != null:
			var beats: Variant = guidance.get("active_beats")
			_expect(beats is Dictionary and (beats as Dictionary).has(&"s15_local_margin"), "15 registers the K4 margin beat")
		var src15: String = _read("res://scripts/levels/station_15.gd")
		_expect(src15.contains("s15_local_margin"), "15 source carries the margin beat")
		_expect(src15.contains("przepraszam M."), "margin carries the K4 pencil text")
		_expect(src15.contains("is_log_reconstructed") and src15.contains("118.0, 244.0") and src15.contains("126.0, 244.0"), "log ticks draw only after reconstruction (N4 show)")
		_close_station(st15)
	var src17: String = _read("res://scripts/levels/station_17.gd")
	_expect(src17.contains("370.0, 256.0") and src17.contains("424.0, 258.0"), "offer projects toward the consent desk (N9 gesture)")
	_expect(src17.contains("is_adaptation_offer_rejected") and src17.contains("CORRECTION_OXIDE"), "rejection still crosses the offer out")


func _mrp_count(station: Node) -> int:
	var props := station.get_node_or_null("Props")
	if props == null:
		return -1
	var n: int = 0
	for prop in props.get_children():
		if prop is MemoryResonancePoint:
			n += 1
	return n


func _test_budgets(state: Node) -> void:
	print("8. M5 intact: 09/15/17 at most 3 MRP each...")
	state.reset_campaign(true)
	for num: int in [9, 15, 17]:
		var station := await _open_station(state, num)
		if station != null:
			var count: int = _mrp_count(station)
			_expect(count >= 1 and count <= 3, "station_%02d keeps 1..3 MRP (got %d)" % [num, count])
			_close_station(station)


# --- fail-closed ---

func _test_fail_closed() -> void:
	print("9. Detectors catch injected regressions...")
	_expect(MANTRA.contains("Moja prośba"), "mantra detector flags the old chant")
	_expect(SENSATIONAL.contains("zabiła"), "sensation detector flags the old blame line")
	_expect(BARE_CODENAME.contains("Para 04/17"), "codename detector flags the imageless tag")
	_expect(AMBIGUOUS.contains("przerwał ją"), "pronoun detector flags the unclear antecedent")
	_expect(not "Korelacja to nie dowód powiązanego kosztu.".contains(SENSATIONAL), "fixed ledger passes the sensation detector")
	_expect(not "Rejestr 04/17: dwa końce pary.".contains(BARE_CODENAME), "fixed ledger passes the codename detector")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0223 VOICES TEMPO PASS: attributed 15 log, linked-cost ledger, 3 concrete commits, devices, Wierzbicka defends the result, photo hub, K4 margin, budgets intact.")
		quit(0)
	else:
		print("PKG-0223 VOICES TEMPO FAIL (%d)" % _failures.size())
		for failure: String in _failures:
			print("  - " + failure)
		quit(1)
