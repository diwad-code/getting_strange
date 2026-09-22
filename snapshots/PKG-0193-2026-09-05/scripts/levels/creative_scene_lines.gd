extends RefCounted

## CR-A: presentation data only. No fact writers or inferred missing evidence.
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
}

static func lines_for(id: String, decisions: Dictionary) -> Array:
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
	var result: Array = []
	for pair in pairs:
		result.append({"speaker": pair[0], "text": pair[1]})
	return result
