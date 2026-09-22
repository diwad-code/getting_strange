extends RefCounted

## CR-A: presentation data only. No fact writers or inferred missing evidence.
## CR-B (PKG-0194): same contract for stations 14-18. stations/17+18
## conversations are knowledge-gated behind `world_recognized` (Station 13):
## before recognition the presenter serves the knowledge fallback, never the
## recognition vocabulary. See D-211 for the named pkg_0165 conflict.
const KNOWLEDGE_GATE_IDS := [
	"cost_ledger_console", "adaptation_offer_terminal", "consent_scope_desk",
	"forecast_comparator", "marta_truth_table", "method_commit_post",
]
const FALLBACK_LINES := [["Lena", "Brakuje mi wcześniejszego źródła. Mogę wrócić i je sprawdzić."]]
const KNOWLEDGE_FALLBACK_LINES := [["Lena", "Najpierw muszę nazwać to, co widziałam przy stole. Wrócę, kiedy będę wiedzieć."]]
const LINES := {
	"two_lives": [["Lena", "Dwa płaszcze. Moje robocze buty stoją obok pantofli Marty."], ["Lena", "Na oparciu został jej sweter. Jeszcze pachnie mydłem."]],
	"relation_photo": [["Lena", "Marta obejmuje mnie od tyłu. Trzymam jej dłoń na swoim brzuchu."], ["Lena", "Ma mokre włosy przyklejone do policzka. Nie pamiętam tego zdjęcia."]],
	"private_boundary": [["Lena", "Klamka jest ciepła."], ["Lena", "Nie. Zapytam Martę."]],
	"home_task": [["Marta", "Podaj mi ten kubek. Nie ten, z uchem."], ["Lena", "Zawsze brałaś biały."], ["Marta", "Biały jest twój."], ["Lena", "Postawię oba tutaj."]],
	"marta_day": [["Marta", "Po deszczu wróciłyśmy tutaj. Kurtkę zostawiłaś na kaloryferze."], ["Lena", "Oddałaś mi ją na parkingu."], ["Marta", "Potem wróciłyśmy razem."], ["Lena", "Pokłóciłyśmy się. Potem już nie pracowałyśmy razem."], ["Marta", "My wtedy zamieszkałyśmy razem."], ["Lena", "Pamiętam mokry rękaw. Trzymałam go, kiedy odjeżdżałaś."]],
	"marta_boundary": [["Marta", "Telefon zostaje przy mnie. Chcę zadzwonić po lekarza."], ["Lena", "Najpierw sprawdzę zapis pracy. Tam musi być mój odczyt."], ["Marta", "W UCP. Tam pracujesz."], ["Lena", "Nie pracuję w UCP."], ["Marta", "Możesz sprawdzić. Ale nie dotykaj mnie tak, jak ona."], ["Lena", "Dobrze. Zostawię ci numer."]],
	"identity_card": [["Wierzbicka", "Karta ma obcy numer. Proszę położyć palec na czytniku."], ["Lena", "A teraz?"], ["Wierzbicka", "Lena Wolska. Zespół UCP-4. Biometria zgodna."], ["Lena", "Proszę pokazać historię wejść."]],
	"record_186_days": [["REJESTR UCP", "Lena Wolska: 186 dni aktywności. Wejścia, zmiany, podpisy odbioru."], ["Lena", "Tu jest Jakub. Mój brat zginął dziewięć lat temu."], ["REJESTR SZPITALNY", "Jakub Wolski: wypis po operacji, po dacie katastrofy Linii 4."], ["REJESTR SERWISOWY", "Jakub Wolski: ciągłość zatrudnienia do dziś. Bieżąca zmiana: warsztat."], ["Lena", "To dwa różne rejestry. Poproszę numer warsztatu."]],
	"minimal_report": [["Wierzbicka", "Wydam wyciąg. Czytnik proszę zostawić do sprawdzenia."], ["Lena", "Zostaje ze mną. Potrzebuję godziny próby i numeru urządzenia."], ["WYCIĄG UCP", "20:40 — próba równoległa. Numer czytnika terenowego: brak w rejestrze."], ["Lena", "Zabieram tylko tę stronę i kontakt do warsztatu."]],
	"jakub_questions": [["Lena", "Co było pod schodami u babci?"], ["Jakub", "Słoiki. I twój hełm z garnka. Dlaczego?"], ["Lena", "Co powiedziałeś mi w tunelu?"], ["Jakub", "W którym tunelu?"], ["Lena", "Przyjdę bliżej. Nie rozłączaj."]],
	"jakub_meeting": [["Jakub", "Uważaj na przewód. Muszę oddać ten napęd przed końcem zmiany."], ["Lena", "Jakub."], ["Jakub", "Patrzę na ciebie."], ["Lena", "Byłam na twoim pogrzebie."], ["Jakub", "Ja jutro mam tu wrócić. Nie wiem, co mam ci powiedzieć."]],
	"jakub_refusal": [["Lena", "Pokaż bliznę."], ["Jakub", "Nie."], ["Lena", "Muszę sprawdzić…"], ["Jakub", "Numer mogę sprawdzić. Daj czytnik."], ["Lena", "Proszę."], ["Jakub", "Tego numeru nie ma w naszej bazie."], ["Lena", "Oddaj. Nie będę cię więcej prosić o bliznę."]],
	"synthesize": [["Lena", "Czytnik jest mój. Wasze zapisy i wspomnienia do niego nie pasują. Jakub żyje."], ["Lena", "To nie jest mój świat."], ["Marta", "Więc gdzie jest ona?"], ["Lena", "Nie wiem."], ["Marta", "Zostawiła po sobie tę próbę."], ["Lena", "Sprawdzę ją. Najpierw muszę ją odnaleźć."]],
	# --- CR-B: 14, martwy obwód. Oba zachowania zachowane; najpierw widoczna
	# zmiana sekcji, potem robocze nazwanie. ---
	"relay_logbook": [["Lena", "Dziennik podstacji: fala korekty co siedem sekund."], ["Lena", "Najpierw zobaczę, co most robi z sekcją. Nazwę to potem."]],
	"relay_logbook_named": [["Lena", "Utrzymanie i uległość. Dwa ruchy jednej metody."], ["Lena", "Sekcja pokazała różnicę, zanim dostała nazwę."]],
	# --- CR-B: 15, wzajemny sygnał. Log 20:40 i jego przyczyna (CR-D §2):
	# pierwszy obowiązkowy odczyt nawiązuje kontakt, powtórka zabezpiecza
	# próbkę i opóźnia powrót; komenda UCP przychodzi po kontakcie. ---
	"loop_logbook": [["DZIENNIK PĘTLI", "20:40 — próba miejscowej. Kontakt przy pierwszym odczycie."], ["Lena", "Ten sam odczyt, który ja zrobiłam przed rozwidleniem. Kontakt, nie portal."], ["DZIENNIK PĘTLI", "Powtórka: pełna próbka i późniejszy powrót. Wyjście na czas: sam czytnik, bez próbki."], ["Lena", "Komenda UCP przyszła po kontakcie. Ktoś przerwał ją z zewnątrz."]],
	"signal_sender_control": [["Lena", "Impuls kontrolny wraca identyczny. Zapisuję, nie wierzę."], ["Lena", "To może być nagranie. Potrzebuję drugiego takiego samego."]],
	"signal_sender_armed": [["Lena", "Dwa identyczne echa. Teraz w tym samym nadajniku przestawię jeden element trzeciej próby."], ["Lena", "To moja świadoma decyzja. Jeśli odpowiedź poprawi tylko ten błąd, to nie nagranie."]],
	"signal_sender_confirmed": [["Lena", "Odpowiedź poprawiła tylko mój celowy błąd. To żywy sygnał."], ["Lena", "Nie ma jej w domu. Jest po drugiej stronie pętli."]],
	"abort_note": [["NOTATKA SERWISOWA", "Brak odpowiedzi w trzy sekundy — przerwij. Bez jej zgody nie powtarzaj."], ["Lena", "Zostawiła warunek przerwania. To była decyzja, nie wypadek."], ["Lena", "Przerwę tak samo: po braku odpowiedzi. Za nią działać nie będę."]],
	# --- CR-B: 16, mały koszt. Najpierw alternatywy, potem jeden konkretny
	# ubytek. Bez surowej próbki nośnik nie jest opisywany jako pełna próbka. ---
	"safe_analyzer": [["Lena", "Odpowiedź wchodzi do analizatora. Tryb ochronny trzyma obie wersje."], ["ANALIZATOR", "Dwa odczyty jednego śladu. Wybierz, co może stracić ostrość."]],
	"cost_selector_preview": [["Lena", "Albo szczegół spotkania z Martą — kurtka na kaloryferze. Albo dokładna sekunda próbki."], ["Lena", "Jedno zostanie ostre. Drugie straci ostrość. Wybieram przy selektorze."]],
	"cost_selector_marta": [["Lena", "Wybieram pamięć spotkania. Kurtka na kaloryferze — to robi się niewyraźne."], ["MARTA (ŁĄCZE)", "Padało. Twoja kurtka była…"], ["Lena", "Nie dopowiadam za nią. Ubytek jest jeden, mały, mój."]],
	"cost_selector_sample_full": [["Lena", "Wybieram sekundę surowej próbki. Zapis pokaże lukę tam, gdzie była pełnia."], ["ANALIZATOR", "Sekunda 20:40:07 — ostrość utracona. Reszta śladu czytelna."], ["Lena", "Pamięć Marty zostaje cała. Płacę zapisem, nie nią."]],
	"cost_selector_sample_buffer": [["Lena", "Wybieram sekundę z bufora czytnika. Próbki nie zabezpieczyłam — płacę tym, co mam."], ["ANALIZATOR", "Sekunda 20:40:07 — ostrość utracona. Reszta śladu czytelna."], ["Lena", "Pamięć Marty zostaje cała. Płacę zapisem, nie nią."]],
	"home_echo_receiver": [["ECHO DOMU", "Marta: zgłosiłam zaginięcie. Wróć, kiedy będziesz mogła."], ["Lena", "Dom poszedł dalej beze mnie. Jej tam nie ma — odpowiedź idzie spomiędzy."], ["Lena", "To nie podmiana. Nikt nie zamienił się ze mną miejscami."]],
	# --- CR-B: 17, rachunek Linii 4. Trzy akty: para zdarzeń, oferta
	# Wierzbickiej, prośba Leny i odpowiedź Jakuba z jego celem z 12. ---
	"cost_ledger_console": [["REJESTR UCP", "Para 04/17: stabilizacja Równi — katastrofa Linii 4 w jej domu."], ["REJESTR UCP", "Drugi koniec pary: śmierć Jakuba tam, gdzie ja go pochowałam."], ["Lena", "Ktoś utrzymuje zapis. Ktoś drugi zapłacił. Korelacja to nie dowód, że ona go zabiła."]],
	"adaptation_offer_terminal": [["WIERZBICKA", "Wpiszemy cię do rejestru jako miejscową. Dom, Marta, żywy Jakub — wszystko zostaje."], ["Lena", "Bez kosztu? Bez cudzej pamięci w mojej głowie?"], ["WIERZBICKA", "Procedura zachowuje rolę. Sprzeczne wspomnienia wygładzimy."], ["Lena", "Odmawiam. Nie będę wygodnym zastępstwem."]],
	"consent_scope_desk_granted": [["Lena", "Potrzebuję twojej ręki na nadajniku. Dziesięć sekund, ty na wyłączniku."], ["JAKUB", "Ten napęd muszę oddać przed końcem zmiany. Potem dziesięć sekund."], ["JAKUB", "Mój nadajnik, moja ręka na wyłączniku."], ["Lena", "Dziesięć."]],
	"consent_scope_desk_limited": [["Lena", "Potrzebuję twojej ręki na nadajniku przy próbie."], ["JAKUB", "Nadajnika do mnie nie podłączysz. Sprawdzę wskazania."], ["JAKUB", "Ten napęd oddaję przed końcem zmiany. Tyle mogę."], ["Lena", "Tyle wystarczy. Resztę zrobię sama."]],
	"consent_scope_desk_refused": [["Lena", "Potrzebuję twojej ręki na nadajniku przy próbie."], ["JAKUB", "Przyszłaś po odczyt, a teraz każesz mi podpisać protokół in blanco. Nie ze mną, Lena."], ["Lena", "Ten napęd i tak musisz oddać przed końcem zmiany. Nie zatrzymuję cię."]],
	# --- CR-B: 18, prognozy i prawda. Chroniona wartość, znana strata,
	# niepewność i faktyczne braki; ruch Leny to jej prośba, nie wola Jakuba. ---
	"forecast_comparator_granted": [["TABLICA PROGNOZ", "Wymuszenie domu: chroni mój powrót. Strata: jej miejsce. Niewiadoma: czy kanał da się zamknąć."], ["TABLICA PROGNOZ", "Zamknięcie z odzyskaniem miejscowej: chroni jej powrót. Strata: mój adres. Niewiadoma: gdzie ja wtedy jestem."], ["TABLICA PROGNOZ", "Przejście wzajemne: chroni obie. Strata: przeciek pamięci. Niewiadoma: co połączy się na stałe."]],
	"forecast_comparator_limited": [["TABLICA PROGNOZ", "Wymuszenie domu: brak. Wymaga pełnej zgody — luka: brak zgody Jakuba."], ["TABLICA PROGNOZ", "Zamknięcie z odzyskaniem miejscowej: chroni jej powrót. Strata: mój adres. Niewiadoma: gdzie ja wtedy jestem."], ["TABLICA PROGNOZ", "Przejście wzajemne: brak. Wymaga pełnej zgody — luka: brak zgody Jakuba."]],
	"forecast_comparator_refused": [["TABLICA PROGNOZ", "Wymuszenie domu: brak. Odmowa zamyka metody na jego relacji — luka: brak zgody Jakuba."], ["TABLICA PROGNOZ", "Zamknięcie z odzyskaniem miejscowej: brak. Odmowa zamyka metody na jego relacji — luka: brak zgody Jakuba."], ["TABLICA PROGNOZ", "Przejście wzajemne: brak. Odmowa zamyka metody na jego relacji — luka: brak zgody Jakuba."]],
	"forecast_comparator_missing": [["TABLICA PROGNOZ", "Trzy drogi, żadna niepoliczona. Bez rejestru i zakresu nie ma prognozy — tylko chęci."], ["Lena", "Nieustalone pokazuję jako nieustalone. Nie zatwierdzę metody z luki."]],
	"marta_truth_table_full": [["Lena", "Pokazuję Marcie zapis miejscowej: próbę o 20:40, warunek przerwania, brak jej zgody."], ["MARTA", "Wiedziała czy zapytała? Ona mnie nie zapytała."], ["MARTA", "Pomogę ją wyciągnąć. Potem odpowie mi sama."]],
	"marta_truth_table_partial": [["Lena", "Mówię Marcie o sygnale. Warunek przerwania pomijam — tego fragmentu nie pokazuję."], ["MARTA", "Coś chowasz. Ratunek tak, resztę powiesz, kiedy będziesz gotowa."], ["MARTA", "Klucz synchronizacji dostaniesz przy pełnym zapisie. Nie przy legendzie."]],
	"marta_truth_table_withheld": [["Lena", "Nie mówię Marcie nic. To wstrzymanie, nie kłamstwo z litości."], ["MARTA", "Milczysz. To też jest odpowiedź."], ["MARTA", "Kiedy będziesz gotowa, przyjdź z zapisem. Nie z legendą."]],
	"method_commit_post_force_home": [["Lena", "Zatwierdzam wymuszenie domu. Moja prośba, mój ruch — nie jego wola."], ["Lena", "Kładę rękę na słupku. Braki zostają nazwane."]],
	"method_commit_post_close_equal_recover_local": [["Lena", "Zatwierdzam zamknięcie z odzyskaniem miejscowej. Oddaję jej miejsce."], ["Lena", "Moja prośba, mój ruch. Bez jej adresu nie wracam."]],
	"method_commit_post_mutual_passage": [["Lena", "Zatwierdzam przejście wzajemne. Otwieram, nie zabieram."], ["Lena", "Moja prośba, mój ruch. Przeciek przyjmuję z góry."]],
}

static func lines_for(id: String, decisions: Dictionary, station: Node = null) -> Array:
	var pairs: Array = LINES.get(id, [])
	if id == "marta_source":
		pairs = [["Lena", "Kładę zaświadczenie: Sadowa 7, mieszkanie 12. Czytnik przywiozłam ze sobą."]]
		if decisions.get(&"home_sample_preserved", false) == true:
			pairs.append(["Lena", "Obok jest surowa próbka z powtórzonego pomiaru."])
		else:
			pairs.append(["Lena", "Nie mam zabezpieczonej surowej próbki. Mam dokument i własny czytnik."])
		if decisions.get(&"marta_memories_conflict", false) == true:
			pairs.append(["Marta", "Mój adres to Sadowa 7, mieszkanie 14. Kurtka schła tutaj."])
	if id == "institution_source":
		if decisions.get(&"recognition_evidence_public", false) == true:
			pairs = [["Lena", "Wyciąg UCP: 186 dni. Obok zapis szpitala i praca Jakuba po katastrofie."]]
		else:
			pairs = [["Lena", "Nie przyniosłam pełnego wyciągu UCP. Tego miejsca nie wypełnię domysłem."]]
	if id == "relay_logbook" and _truthy(decisions.get(&"p9.mechanics.dead_circuit.trace", false)):
		pairs = LINES.get("relay_logbook_named", [])
	if id == "signal_sender" and station != null:
		if _truthy(station.get("is_signal_confirmed")):
			pairs = LINES.get("signal_sender_confirmed", [])
		elif _truthy(station.get("is_error_pattern_armed")):
			pairs = LINES.get("signal_sender_armed", [])
		elif _truthy(station.get("is_log_reconstructed")):
			pairs = LINES.get("signal_sender_control", [])
		else:
			pairs = FALLBACK_LINES
	if id == "cost_selector" and station != null and _truthy(station.get("is_cost_selected")):
		var choice := String(decisions.get(&"p9.mechanics.small_cost.choice", ""))
		if choice == "sample_second":
			if _truthy(decisions.get(&"home_sample_preserved", false)):
				pairs = LINES.get("cost_selector_sample_full", [])
			else:
				pairs = LINES.get("cost_selector_sample_buffer", [])
		else:
			pairs = LINES.get("cost_selector_marta", [])
	if id in KNOWLEDGE_GATE_IDS and decisions.get(&"world_recognized", false) != true:
		pairs = KNOWLEDGE_FALLBACK_LINES
	if id == "consent_scope_desk" and decisions.get(&"world_recognized", false) == true:
		match String(decisions.get(&"jakub_consent_state", decisions.get(&"p9.consent_and_cost.jakub_consent_scope", ""))):
			"limited":
				pairs = LINES.get("consent_scope_desk_limited", [])
			"refused":
				pairs = LINES.get("consent_scope_desk_refused", [])
			_:
				pairs = LINES.get("consent_scope_desk_granted", [])
	if id == "forecast_comparator" and decisions.get(&"world_recognized", false) == true:
		match _read_consent(decisions):
			"limited":
				pairs = LINES.get("forecast_comparator_limited", [])
			"refused":
				pairs = LINES.get("forecast_comparator_refused", [])
			"granted":
				pairs = LINES.get("forecast_comparator_granted", [])
			_:
				pairs = LINES.get("forecast_comparator_missing", [])
	if id == "marta_truth_table" and decisions.get(&"world_recognized", false) == true:
		match String(decisions.get(&"marta_truth_state", decisions.get(&"p9.method_commitment.marta_truth_state", ""))):
			"partial":
				pairs = LINES.get("marta_truth_table_partial", [])
			"withheld":
				pairs = LINES.get("marta_truth_table_withheld", [])
			_:
				pairs = LINES.get("marta_truth_table_full", [])
	if id == "method_commit_post" and decisions.get(&"world_recognized", false) == true:
		match String(decisions.get(&"method_committed", decisions.get(&"p9.method_commitment.method_committed", ""))):
			"close_equal_recover_local":
				pairs = LINES.get("method_commit_post_close_equal_recover_local", [])
			"mutual_passage":
				pairs = LINES.get("method_commit_post_mutual_passage", [])
			_:
				pairs = LINES.get("method_commit_post_force_home", [])
	var result: Array = []
	for pair in pairs:
		result.append({"speaker": pair[0], "text": pair[1]})
	return result


static func _truthy(value: Variant) -> bool:
	# Godot 4.7 has no String -> bool constructor; station code (Station14
	#._decision_bool) uses this same explicit pattern. Never wrap facts here.
	if value is bool:
		return value
	if value is String or value is StringName:
		return not String(value).is_empty()
	if value == null:
		return false
	return true


static func _read_consent(decisions: Dictionary) -> String:
	var scoped := String(decisions.get(&"p9.consent_and_cost.jakub_consent_scope", ""))
	if scoped in ["granted", "limited", "refused"]:
		return scoped
	var canonical := String(decisions.get(&"jakub_consent_state", ""))
	if canonical in ["granted", "limited", "refused"]:
		return canonical
	return ""
