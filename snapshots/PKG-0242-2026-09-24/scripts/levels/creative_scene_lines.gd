extends RefCounted

const NarrativeRules := preload("res://scripts/levels/narrative_repair_rules.gd")

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
	# PKG-0223 (N9): haczyk 09 wskazuje wprost fotografie na komodzie —
	# hub calego tryptyku (two_lives -> relation_photo -> private_boundary).
	"two_lives": [["Lena", "Dwa płaszcze. Moje robocze buty stoją obok pantofli Marty."], ["Lena", "Na oparciu został jej sweter. Na komodzie stoi nasze zdjęcie."]],
	"relation_photo": [["Lena", "Marta obejmuje mnie od tyłu. Trzymam jej dłoń na swoim brzuchu."], ["Lena", "Ma mokre włosy przyklejone do policzka. Nie pamiętam tego zdjęcia."]],
	"private_boundary": [["Lena", "Klamka jest ciepła."], ["Lena", "Nie. Zapytam Martę."]],
	"home_task": [["Marta", "Podaj mi ten kubek. Nie ten, z uchem."], ["Lena", "Zawsze brałaś biały."], ["Marta", "Biały jest twój."], ["Lena", "Postawię oba tutaj."]],
	"marta_day": [["Marta", "Po deszczu wróciłyśmy tutaj. Kurtkę zostawiłaś na kaloryferze."], ["Lena", "Oddałaś mi ją na parkingu."], ["Marta", "Potem wróciłyśmy razem."], ["Lena", "Pokłóciłyśmy się. Potem już nie pracowałyśmy razem."], ["Marta", "My wtedy zamieszkałyśmy razem."], ["Lena", "Pamiętam mokry rękaw. Trzymałam go, kiedy odjeżdżałaś."]],
	"marta_boundary": [["Marta", "Telefon zostaje przy mnie. Chcę zadzwonić po lekarza."], ["Lena", "Najpierw sprawdzę zapis pracy. Tam musi być mój odczyt."], ["Marta", "W UCP. Tam pracujesz."], ["Lena", "Nie pracuję w UCP."], ["Marta", "Możesz sprawdzić. Ale nie dotykaj mnie tak, jak ona."], ["Lena", "Dobrze. Zostawię ci numer."]],
	"identity_card": [["Wierzbicka", "Karta nie pasuje do potwierdzenia. Proszę przyłożyć palec."], ["Lena", "A teraz?"], ["Wierzbicka", "Lena Wolska, UCP-4. To pani profil. Nie zmienię go na podstawie tego, co pani pamięta."], ["Lena", "Proszę pokazać historię wejść."]],
	"record_186_days": [["REJESTR UCP", "Lena Wolska: 186 dni aktywności. Wejścia, zmiany, podpisy odbioru."], ["Lena", "Tu jest Jakub. Mój brat zginął dziewięć lat temu."], ["REJESTR SZPITALNY", "Jakub Wolski: wypis po operacji, po dacie katastrofy Linii 4."], ["REJESTR SERWISOWY", "Jakub Wolski: ciągłość zatrudnienia do dziś. Bieżąca zmiana: warsztat."], ["Lena", "To dwa różne rejestry. Poproszę numer warsztatu."]],
	"minimal_report": [["Wierzbicka", "Wyciąg mogę wydać. Czytnik zostaje do sprawdzenia."], ["Lena", "Bez niego nie porównam odczytów. Zostaje ze mną."], ["Wierzbicka", "Wtedy wydam tylko stronę próby. Urządzenia nie potwierdzę."], ["WYCIĄG UCP", "20:40 — próba równoległa. Numer czytnika terenowego: brak w rejestrze."], ["Lena", "Biorę tę stronę i kontakt do warsztatu."]],
	"jakub_questions": [["Lena", "Co było pod schodami u babci?"], ["Jakub", "Słoiki. I twój hełm z garnka. Dlaczego?"], ["Lena", "Co powiedziałeś mi w tunelu?"], ["Jakub", "W którym tunelu?"], ["Lena", "Przyjdę bliżej. Nie rozłączaj."]],
	"jakub_meeting": [["Jakub", "Uważaj na przewód. Muszę oddać ten napęd przed końcem zmiany."], ["Lena", "Jakub."], ["Jakub", "Patrzę na ciebie."], ["Lena", "Byłam na twoim pogrzebie."], ["Jakub", "Ja jutro mam tu wrócić. Nie wiem, co mam ci powiedzieć."]],
	"jakub_refusal": [["Lena", "Pokaż bliznę."], ["Jakub", "Nie."], ["Lena", "Muszę sprawdzić…"], ["Jakub", "Numer mogę sprawdzić. Daj czytnik."], ["Lena", "Proszę."], ["Jakub", "Tego numeru nie ma w naszej bazie."], ["Lena", "Oddaj. Nie będę cię więcej prosić o bliznę."]],
	"synthesize": [["Lena", "Mój zapis, twoja pamięć i dokumenty UCP nie opisują jednego życia."], ["Jakub (łącze)", "Numery czytników też są różne. To nie ten sam egzemplarz."], ["Lena", "To nie jest mój świat."], ["Marta", "Więc gdzie jest ona?"], ["Lena", "Nie wiem."], ["Marta", "Poszukasz?"], ["Lena", "Tak. Nie obiecam ci, że ją znajdę."], ["Lena", "Wyciąg wskazuje sekcję rozdzielni. Zejdę włazem serwisowym."]],
	# --- CR-B: 14, martwy obwód. Oba zachowania zachowane; najpierw widoczna
	# zmiana sekcji, potem robocze nazwanie. ---
	"relay_logbook": [["DZIENNIK PODSTACJI", "Sekcja odłączona od zasilania. Dopuszczone dwa położenia mostu."], ["Lena", "Nie ma tu prądu. Sprawdzę oba położenia."]],
	"relay_logbook_named": [["Lena", "W jednym położeniu trzyma poprzedni układ. W drugim pozwala mu się rozjechać."], ["Lena", "Zakotwiczenie i uległość. Teraz wiem, co oznaczają te nazwy w dzienniku."]],
	# --- CR-B: 15, wzajemny sygnał. Log 20:40 i jego przyczyna (CR-D §2):
	# pierwszy obowiązkowy odczyt nawiązuje kontakt, powtórka zabezpiecza
	# próbkę i opóźnia powrót; komenda UCP przychodzi po kontakcie. ---
	# PKG-0223 (N4): rozbity na pokaz -> nazwanie; dziennik niesie wylacznie
	# kontakt i przyczyne w 2 parach, reszte pokazuje obraz (tiki na czytniku
	# w station_15) i lancuch MRP (kontrole/uzbrojenie/korekta, pin 0194).
	"loop_logbook": [["DZIENNIK PRÓBY", "20:40 — kontakt przy pierwszym odczycie obu czytników."], ["NOTATKA MIEJSCOWEJ", "Cel: niezależny od UCP odczyt eksportu kosztów. Możliwe włączenie nieznanej osoby."], ["NOTATKA MIEJSCOWEJ", "Bez jej odpowiedzi przerwać."], ["POLECENIE UCP", "Po utracie kontaktu: utrzymać wynik lokalny. Wierzbicka."], ["Lena", "Próbę zaczęła ona. Późniejsze polecenie utrzymania wyniku ma podpis Wierzbickiej."]],
	"signal_sender_control": [["Lena", "Impuls kontrolny wraca identyczny. Zapisuję, nie wierzę."], ["Lena", "To może być nagranie. Potrzebuję drugiego takiego samego."]],
	"signal_sender_armed": [["Lena", "Dwa wzory wróciły bez zmiany. W trzecim odwracam tylko ostatni impuls."], ["Lena", "Jeżeli nie odpowie, przerywam. Nie podam następnego impulsu za nią."]],
	"signal_sender_confirmed": [["Lena", "Poprawiony został tylko mój błąd. Ta odpowiedź powstała teraz, nie przed próbą."], ["Lena", "Wraca kanałem z jej dziennika. To ślad miejscowej, jeszcze nie potwierdzenie jej położenia."], ["Lena", "Niosę odpowiedź do analizatora poza obwodem."]],
	"abort_note": [["NOTATKA MIEJSCOWEJ", "Brak odpowiedzi w trzy sekundy — przerwij. Bez jej zgody nie powtarzaj."], ["Lena", "Przerwanie miało nastąpić po podłączeniu obcej osoby. Nie zapytała jej wcześniej."]],
	# --- CR-B: 16, mały koszt. Najpierw alternatywy, potem jeden konkretny
	# ubytek. Bez surowej próbki nośnik nie jest opisywany jako pełna próbka. ---
	"safe_analyzer": [["Lena", "Odpowiedź wchodzi do analizatora. Tryb ochronny trzyma obie wersje."], ["ANALIZATOR", "Dwa odczyty jednego śladu. Oś wspólna. Wybierz, co może stracić ostrość."]],
	"cost_selector_preview": [["ANALIZATOR", "Wybierz nośnik ubytku: pamięć zdania usłyszanego dziś albo sekundę zachowanego odczytu."], ["Lena", "Pamięć Marty zostaje u niej. Mogę stracić tylko własną pamięć rozmowy o kurtce."]],
	# PKG-0242 (UX): martwa strefa selektora 16 przypomina obie strony wyboru.
	"cost_selector": [["ANALIZATOR", "Stań po lewej: pamięć zdania usłyszanego dziś. Po prawej: sekunda zapisu."]],
	"cost_selector_marta": [["Lena", "Wybieram własną pamięć dzisiejszego zdania o kurtce. Nie wspomnienie, którego nie przeżyłam."], ["Marta (łącze)", "Powiedziałam: na kaloryferze."], ["Lena", "Wiem, że mi mówiłaś. Nie umiem sobie przypomnieć tego zdania."]],
	"cost_selector_sample_full": [["Lena", "Wybieram sekundę surowej próbki."], ["ANALIZATOR", "20:40:07 — fragment utracony. Pozostały zapis zachowany."], ["Lena", "Dzisiejszą rozmowę z Martą pamiętam. Tej sekundy już nie odzyskam."]],
	"cost_selector_sample_buffer": [["Lena", "Nie mam pełnej próbki. Wybieram sekundę bufora, który pozostał w czytniku."], ["ANALIZATOR", "20:40:07 — fragment bufora utracony."], ["Lena", "Dzisiejszą rozmowę z Martą pamiętam. Tej sekundy już nie odzyskam."]],
	"home_echo_receiver": [["ECHO DOMOWEJ MARTY", "Zgłosiłam twoje zaginięcie. Odezwij się."], ["Lena", "W chwili tej wiadomości Marta nadal mnie szukała."], ["Lena", "To podważa prostą zamianę. Nie mówi jeszcze, gdzie dokładnie tkwi miejscowa."], ["Lena", "Z odpowiedzią i ceną przejdę do rejestru par w hali UCP."]],
	# --- CR-B: 17, rachunek Linii 4. Trzy akty: para zdarzeń, oferta
	# Wierzbickiej, prośba Leny i odpowiedź Jakuba z jego celem z 12. ---
	# PKG-0223 (N10): kryptonim z obrazem (dwa konce, jedna reka) zamiast
	# golnego szyldu; sensacja o zabojstwie zastapiona powiazanym kosztem.
	# "04/17" i "Ktos utrzymuje zapis" nietkniete (pinuja 0217 i 0194).
	# PKG-0237 (D1/D2): Lena zarabia nazwe Rownia od rejestru w parze 1;
	# kwestia oferty rozpoznaje Wierzbicka z lady ze stacji 11.
	"cost_ledger_console": [["REJESTR KOSZTÓW", "Linia 4: utrzymanie wyniku lokalnego — powiązany koszt po stronie drugiego zapisu."], ["Lena", "Ten drugi zapis obejmuje katastrofę, po której pochowałam brata."], ["REJESTR KOSZTÓW", "Obszar utrzymywanego wyniku: Równia. Powiązanie kosztu odnotowane przed zamknięciem sprawy."], ["Lena", "Równia. Tak nazywają ten utrzymany obszar. Wiedzieli, że ktoś po drugiej stronie płaci."], ["Lena", "To dowód ich wiedzy o koszcie. Nie dowód, że konkretna osoba postanowiła zabić Jakuba."]],
	"adaptation_offer_terminal": [["Wierzbicka (terminal)", "Wpiszemy panią w miejsce Leny Wolskiej. Dostęp, praca, mieszkanie. Wynik zostanie utrzymany."], ["Lena", "Poznaję głos z lady. A ona?"], ["Wierzbicka (terminal)", "Zamkniemy niezgodność. Mieszkańcy pojadą rano do pracy. Tego wyniku mam pilnować."], ["Lena", "A osoby, które nie mieszczą się w pani wyniku?"], ["Wierzbicka (terminal)", "Bez utrzymania nie gwarantuję również bezpieczeństwa tej strony."], ["Lena", "Chce pani, żebym zajęła jej miejsce i przestała pytać. Nie podpiszę."]],
	# PKG-0230 (P1-3, S-07): Jakub mowi przez jawne lacze w 17 (terminal nad lada
	# zgody) — nie z kadru. Poprzednia atrybucja "JAKUB" sugerowala rozmowe
	# twarza w twarz w pustej hali; tekst kwestii nietkniety.
	"consent_scope_desk_granted": [["Lena", "Rozważysz udział w próbie z wyłącznikiem przy sobie?"], ["Jakub (łącze)", "Porozmawiam o tym. Najpierw pokaż konkretną metodę i jej cenę. Teraz niczego nie podłączamy."], ["Lena", "Wrócę z prognozą, nie z pustym protokołem."], ["Jakub (łącze)", "Mam jeszcze napęd do oddania przed końcem zmiany."]],
	"consent_scope_desk_limited": [["Lena", "Potrzebuję pomocy przy odczycie."], ["Jakub (łącze)", "Tylko wskazania, bez podłączenia do człowieka. Pokaż potem, do czego chcesz ich użyć."], ["Lena", "Ten zakres zostaje. Na konkretną metodę zapytam osobno."], ["Jakub (łącze)", "I nie trzymaj mnie tu całą zmianę. Napęd czeka."]],
	"consent_scope_desk_refused": [["Lena", "Podtrzymasz próbę, kiedy ustawię przejście?"], ["Jakub (łącze)", "Przyszłaś po odczyt, a teraz chcesz protokół in blanco. Nie zgadzam się na podłączenie."], ["Lena", "Nie podłączę cię."], ["Jakub (łącze)", "Wracam do napędu."]],
	# --- CR-B: 18, prognozy i prawda. Chroniona wartość, znana strata,
	# niepewność i faktyczne braki; ruch Leny to jej prośba, nie wola Jakuba. ---
	"forecast_comparator_granted": [["CZYTNIK — PROGNOZA", "Wymuszenie domu: przybyła wraca, miejscowa zostaje między adresami. Dalszy ratunek: brak danych."], ["CZYTNIK — PROGNOZA", "Odzyskanie i zamknięcie: miejscowa wraca, przybyła traci indeks. Powrót przybyłej: brak danych."], ["CZYTNIK — PROGNOZA", "Przejście wzajemne: oba powroty, trwały przeciek. Jego moment i rozmiar: brak danych."], ["Lena", "Jakub dopuszcza rozmowę o próbie. Każda metoda wymaga jego odrębnej odpowiedzi."]],
	"forecast_comparator_limited": [["CZYTNIK — PROGNOZA", "Wymuszenie domu: przybyła wraca, miejscowa zostaje między adresami. Dalszy ratunek: brak danych."], ["CZYTNIK — PROGNOZA", "Odzyskanie i zamknięcie: miejscowa wraca, przybyła traci indeks. Powrót przybyłej: brak danych."], ["CZYTNIK — PROGNOZA", "Przejście wzajemne: oba powroty, trwały przeciek. Jego moment i rozmiar: brak danych."], ["Lena", "Jakub dopuszcza tylko wskazania. Ta granica wyklucza jego udział w pozostałych metodach."]],
	"forecast_comparator_refused": [["CZYTNIK — PROGNOZA", "Wymuszenie domu: przybyła wraca, miejscowa zostaje między adresami. Dalszy ratunek: brak danych."], ["CZYTNIK — PROGNOZA", "Odzyskanie i zamknięcie: miejscowa wraca, przybyła traci indeks. Powrót przybyłej: brak danych."], ["CZYTNIK — PROGNOZA", "Przejście wzajemne: oba powroty, trwały przeciek. Jego moment i rozmiar: brak danych."], ["Lena", "Odmówił podłączenia. Mogę zaproponować osobno sam odczyt do odzyskania miejscowej, nie ponowić nacisku."]],
	"forecast_comparator_missing": [["CZYTNIK — PROGNOZA", "Wymuszenie domu: przybyła wraca, miejscowa zostaje między adresami. Dalszy ratunek: brak danych."], ["CZYTNIK — PROGNOZA", "Odzyskanie i zamknięcie: miejscowa wraca, przybyła traci indeks. Powrót przybyłej: brak danych."], ["CZYTNIK — PROGNOZA", "Przejście wzajemne: oba powroty, trwały przeciek. Jego moment i rozmiar: brak danych."], ["Lena", "Nie mam zgodnego zapisu zgody. Znam prognozy, ale nie wolno mi wykonać żadnej metody."]],
	"marta_truth_table_full": [["Lena", "Tu jest jej próba o 20:40. Chciała zmierzyć eksport kosztu bez nadzoru UCP."], ["Lena", "Wiedziała, że może włączyć nieznaną osobę. Warunek przerwania dopisała, ale wcześniej nie zapytała."], ["Marta", "Mnie też nie."], ["Lena", "To jej zapis. To późniejsze polecenie podpisała Wierzbicka."], ["Marta", "Pomogę ją wyciągnąć. Jeśli chcesz synchronizacji, zapytaj mnie osobno o klucz."]],
	"marta_truth_table_partial": [["Lena", "Odpowiedź wraca. Mamy sposób, żeby spróbować ją odzyskać."], ["Marta", "A ta kartka pod spodem?"], ["Lena", "Na razie jej nie pokażę."], ["Marta", "Ratunek tak. Klucz do synchronizacji zostaje u mnie, dopóki nie zobaczę całości."]],
	"marta_truth_table_withheld": [["Marta", "Co jest na kartce?"], ["Lena", "Nie pokażę ci teraz."], ["Marta", "Nie zgodzę się w ciemno na twój plan. Przyjdź z zapisem."]],
	# PKG-0223 (N10/N6): mantra "Moja prosba, moj ruch" x3 zastapiona 3 wariantami
	# czynnosci (slupek / klucz / most); markery 0194 (Oddaje jej miejsce,
	# Otwieram nie zabieram) nietkniete.
	"method_commit_post_force_home": [["Lena", "Wybieram własny powrót. Miejscowa pozostanie między adresami."], ["Lena", "Jeszcze nie zamknęłam kanału. Wykonam to przy czytniku."]],
	"method_commit_post_close_equal_recover_local": [["Lena", "Wybieram odzyskanie miejscowej, potem zamknięcie przepływu."], ["Lena", "Najpierw musi odpowiedzieć u siebie. Dopiero wtedy odetnę własny adres powrotny."]],
	"method_commit_post_mutual_passage": [["Lena", "Wybieram przejście wzajemne. Obie wracamy, ale przeciek zostaje."], ["Lena", "Mam ich odpowiedzi. Teraz muszę jeszcze wykonać strojenie."]],
	# --- CR-C: 42A, wymuszony powrót. Wykonanie metody oddzielone od odczytu
	# skutku; zza zamkniętego mostu nie przychodzi żaden nowy głos. ---
	"forced_return_latch": [["Lena", "Domowa sygnatura odpowiada. Wymuszam powrót i zamykam kanał."], ["EKRAN CZYTNIKA", "Powrót potwierdzony. Drugi adres pozostaje nieosiągalny."], ["EKRAN CZYTNIKA", "Proponowana etykieta: BŁĄD CZUJNIKA."], ["Lena", "Zostawiam tę rubrykę pustą."]],
	"sealed_other_lena": [["EKRAN CZYTNIKA", "Kanał zamknięty. Sygnatura miejscowej pozostała między adresami."], ["Lena", "Nie wróciła ze mną. Teraz nie mogę jej nawet odpowiedzieć."]],
	# PKG-0226 (N6-reszta): wypłata truth_state w otwarciach 42A — dopisane pary
	# konkretu domowego (istniejący kanon: drugie zgłoszenie z APELU); tailsy
	# świata nietknięte (pinują je 0194/0195), zero nowych faktów/flag.
	"household_a_full": [["Marta domowa", "Gdzie byłaś?"], ["Lena", "Spotkałam inną Lenę i Martę, która z nią mieszka. Nie wróciłam z nią."], ["Marta domowa", "Zacznij od początku. Tego nie wiedziałam."], ["Lena", "Pokażę ci to, co przyniosłam. To nie cała odpowiedź."]],
	"household_a_partial": [["Marta domowa", "Gdzie byłaś?"], ["Lena", "Spotkałam inną Lenę i Martę, która z nią mieszka. Nie wróciłam z nią."], ["Marta domowa", "Zacznij od początku. Tego nie wiedziałam."], ["Lena", "Pokażę ci to, co przyniosłam. To nie cała odpowiedź."]],
	"household_a_withheld": [["Marta domowa", "Gdzie byłaś?"], ["Lena", "Spotkałam inną Lenę i Martę, która z nią mieszka. Nie wróciłam z nią."], ["Marta domowa", "Zacznij od początku. Tego nie wiedziałam."], ["Lena", "Pokażę ci to, co przyniosłam. To nie cała odpowiedź."]],
	# --- CR-C: 42B, zamknięcie Równi. Perspektywa przybyłej oddzielona od sceny
	# Marty w Równi; wiata z linii 03 jako miejsce bez indeksu — prezentacja
	# wariantu w tym samym adresie, nie nowa scena ani rodzina lokacji. ---
	"flow_closure": [["Lena", "Odpowiedziała u siebie. Teraz zamykam przepływ."], ["EKRAN CZYTNIKA", "Przepływ tego węzła zamknięty. Domowy adres przybyłej: poza indeksem."], ["Lena", "Nie mam już dokąd wysłać powrotnego wskazania."]],
	"local_lena_recovered": [["Marta", "Jesteś. Co wiedziałaś przed testem?"], ["Miejscowa Lena", "Że mogę wciągnąć obcą osobę. Zaczęłam, zanim mogła odpowiedzieć."], ["Marta", "Mnie też nie zapytałaś."], ["Miejscowa Lena", "Chciałam odczytu kosztów poza UCP. Ja zaczęłam próbę. Wierzbicka potem kazała utrzymać wynik."], ["Marta", "Nie zmieniaj tematu na nią. Zaczniemy od tego, co zrobiłaś ty."]],
	# PKG-0226 (N6-reszta): wypłata truth_state w otwarciach 42B — dopisane pary
	# (czytnik w torbie, lustro epilogu 43B); palimpsest Jadę/Tak nietknięty.
	# PKG-0237 (D4): 42B rozdziela prog od wiaty; stacja 42B dzieje sie w progu
	# mieszkania 14 (wiata linii 03 nalezy do epilogu 43B).
	"household_b_full": [["Lena", "Stoję w progu. Ona wróciła do Marty. Mój dom nie ma już adresu w czytniku."], ["ECHO ZACHOWANE Z ANALIZATORA", "Zgłosiłam twoje zaginięcie. Odezwij się."], ["Lena", "Stara wiadomość Marty. Nie nowa odpowiedź."], ["EKRAN CZYTNIKA", "Niewysłane: Jadę. Pod spodem częściowo starte Tak. Adresat: brak w sieci."]],
	"household_b_partial": [["Lena", "Stoję w progu. Ona wróciła do Marty. Mój dom nie ma już adresu w czytniku."], ["ECHO ZACHOWANE Z ANALIZATORA", "Zgłosiłam twoje zaginięcie. Odezwij się."], ["Lena", "Stara wiadomość Marty. Nie nowa odpowiedź."], ["EKRAN CZYTNIKA", "Niewysłane: Jadę. Pod spodem częściowo starte Tak. Adresat: brak w sieci."]],
	"household_b_withheld": [["Lena", "Stoję w progu. Ona wróciła do Marty. Mój dom nie ma już adresu w czytniku."], ["ECHO ZACHOWANE Z ANALIZATORA", "Zgłosiłam twoje zaginięcie. Odezwij się."], ["Lena", "Stara wiadomość Marty. Nie nowa odpowiedź."], ["EKRAN CZYTNIKA", "Niewysłane: Jadę. Pod spodem częściowo starte Tak. Adresat: brak w sieci."]],
	# --- CR-C: 42C, wzajemne przejście. Konkretny przeciek zamiast ogólnej nici
	# pamięci; epizod obcej pamięci przerywa zwykłą czynność, nie dopisuje
	# nowej katastrofy. ---
	"mutual_passage": [["Lena", "Uzgodnione strojenia odpowiadają. Otwieram okno dla obu sygnatur."], ["EKRAN CZYTNIKA", "Dwa powroty potwierdzone. Kanał pamięci nie został odizolowany."], ["Marta miejscowa (łącze)", "Wróciłaś. Co wiedziałaś przed próbą?"], ["Miejscowa Lena (łącze)", "Że mogę włączyć obcą osobę. Zaczęłam bez jej odpowiedzi i bez pytania ciebie."], ["Miejscowa Lena (łącze)", "Ja chciałam niezależnego odczytu kosztów. Wierzbicka później wymusiła wynik. To nie usuwa mojej decyzji."]],
	# PKG-0237 (D5): przeciek Jakuba jako jawne echo / przeciek, nie fizyczny
	# Jakub warsztatu w salonie mieszkania 14.
	"memory_leak": [["JAKUB (ECHO)", "Przy imadle zobaczyłem prosektorium. Nie mogę teraz utrzymać narzędzia."], ["Lena", "To moje wspomnienie pogrzebu brata. Nie twoje przeżycie."], ["JAKUB (ECHO)", "Odkładam narzędzie. Sam zdecyduję, kiedy wrócę do pracy."], ["EKRAN CZYTNIKA", "Po rozdzieleniu: dalszy dryf. Pełnej izolacji nie potwierdzono."]],
	# PKG-0226 (N6-reszta): wypłata truth_state w otwarciach 42C — dopisane pary
	# (półka i obcy detal z Ceny 42C); pytanie o przeciek i DWA ZAPISY nietknięte.
	"household_c_full": [["Marta domowa", "Znam ten kubek."], ["Lena", "Nie mamy takiego. Po drugiej stronie należy do Marty, która mieszka z inną Leną."], ["Marta domowa", "To skąd go pamiętam?"], ["Lena", "Został przeciek. Nie wybrałaś tego wspomnienia. Opowiem ci, skąd wróciłam."], ["Marta domowa", "Pamiętam kubek, nie twoją opowieść. Zacznij od początku."]],
	"household_c_partial": [["CZYTNIK", "Brak pełnego zapisu i odpowiedzi Marty na synchronizację. Ta wersja przejścia nie jest dostępna."]],
	"household_c_withheld": [["CZYTNIK", "Brak pełnego zapisu i odpowiedzi Marty na synchronizację. Ta wersja przejścia nie jest dostępna."]],
}

## PKG-0242 (UX): a reading point pressed before the point it depends on in
## the same room names that point, instead of the generic "earlier source"
## line (which sent players back to earlier addresses for a step that stood
## next to them). Each entry lists [prerequisite, line] in order; the first
## unmet prerequisite speaks. A prerequisite is another point id of the room
## (its `_is_resolved`) or "@property" of the station. Sources that live at
## earlier addresses still get FALLBACK_LINES.
const STEP_PREREQS := {
	"relation_photo": [["two_lives", "Najpierw rozejrzę się w przedpokoju. Czyje rzeczy tu stoją?"]],
	"private_boundary": [["two_lives", "Najpierw rozejrzę się w przedpokoju. Czyje rzeczy tu stoją?"], ["relation_photo", "Najpierw zdjęcie na komodzie."]],
	"marta_day": [["home_task", "Marta o coś prosi przy stole. Najpierw jej pomogę."]],
	"marta_boundary": [["home_task", "Marta o coś prosi przy stole. Najpierw jej pomogę."], ["marta_day", "Najpierw wysłucham, jak Marta pamięta tamten dzień."]],
	"record_186_days": [["identity_card", "Najpierw karta przy czytniku na ladzie."]],
	"minimal_report": [["identity_card", "Najpierw karta przy czytniku na ladzie."], ["record_186_days", "Najpierw historia wejść w rejestrze. Potem poproszę o wyciąg."]],
	"jakub_meeting": [["jakub_questions", "Najpierw sprawdzę głos przez łącze. Zapytam o to, co wie tylko on."]],
	"jakub_refusal": [["jakub_questions", "Najpierw sprawdzę głos przez łącze. Zapytam o to, co wie tylko on."], ["jakub_meeting", "Najpierw podejdę do niego przy imadle."]],
	"synthesize": [["marta_source", "Najpierw położę na stole zaświadczenie."], ["institution_source", "Najpierw położę obok wyciąg UCP."]],
	"signal_sender": [["loop_logbook", "Najpierw odczytam dziennik próby. Nie wyślę impulsu w ciemno."]],
	"abort_note": [["loop_logbook", "Najpierw odczytam dziennik próby. Nie wyślę impulsu w ciemno."], ["signal_sender", "Najpierw muszę potwierdzić, że po drugiej stronie ktoś odpowiada."]],
	"cost_selector": [["safe_analyzer", "Najpierw wprowadzę odpowiedź do analizatora."]],
	"home_echo_receiver": [["safe_analyzer", "Najpierw wprowadzę odpowiedź do analizatora."], ["cost_selector", "Najpierw wybiorę przy selektorze, co może stracić ostrość."]],
	"adaptation_offer_terminal": [["cost_ledger_console", "Najpierw odczytam rejestr kosztów przy konsoli."]],
	"consent_scope_desk": [["cost_ledger_console", "Najpierw odczytam rejestr kosztów przy konsoli."], ["adaptation_offer_terminal", "Najpierw odpowiem na ofertę na terminalu."]],
	"marta_truth_table": [["forecast_comparator", "Najpierw porównam trzy prognozy na tablicy. Potem pokażę je Marcie."]],
	"method_commit_post": [["forecast_comparator", "Najpierw porównam trzy prognozy na tablicy."]],
	"sealed_other_lena": [["forced_return_latch", "Najpierw wykonam powrót przy czytniku."]],
	"local_lena_recovered": [["@is_recovery_started", "Najpierw wygaszę domową sygnaturę przy zatrzasku."]],
	"memory_leak": [["mutual_passage", "Najpierw otworzę okno dla obu sygnatur."]],
}
## household_consequence depends on its own finale's order.
const HOUSEHOLD_PREREQS := {
	"Station42A": [["forced_return_latch", "Najpierw wykonam powrót przy czytniku."], ["sealed_other_lena", "Najpierw sprawdzę, co zostało po drugiej stronie."]],
	"Station42B": [["@is_recovery_started", "Najpierw wygaszę domową sygnaturę przy zatrzasku."], ["local_lena_recovered", "Najpierw muszę usłyszeć, że odpowiedziała u siebie."], ["flow_closure", "Najpierw zamknę przepływ przy zatrzasku."]],
	"Station42C": [["mutual_passage", "Najpierw otworzę okno dla obu sygnatur."], ["memory_leak", "Najpierw odczytam, co przeciekło między nami."]],
}


static func step_lines_for(id: String, station: Node) -> Array:
	if station == null:
		return []
	var steps: Array = STEP_PREREQS.get(id, [])
	if id == "household_consequence":
		steps = HOUSEHOLD_PREREQS.get(String(station.name), [])
	for step: Array in steps:
		var prereq := String(step[0])
		var met := false
		if prereq.begins_with("@"):
			met = _truthy(station.get(prereq.substr(1)))
		elif station.has_method("_is_resolved"):
			met = bool(station.call("_is_resolved", prereq))
		if not met:
			return [{"speaker": "Lena", "text": String(step[1])}]
	return []


static func lines_for(id: String, decisions: Dictionary, station: Node = null) -> Array:
	var pairs: Array = LINES.get(id, []).duplicate(true)
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
		var pending: Variant = station.get("pending_consent_pairs") if station != null else []
		if pending is Array and not pending.is_empty():
			pairs = pending.duplicate(true)
		else:
			var scope := NarrativeRules.scope(decisions)
			var method := str(decisions.get(NarrativeRules.PROPOSED_KEY, ""))
			var reply := NarrativeRules.response(decisions, method)
			if reply == "accepted":
				pairs = [["Jakub (łącze)", "Zgodziłem się na tę jedną propozycję. Mój zakres nie obejmuje innych prób."]]
			elif reply == "refused":
				pairs = [["Jakub (łącze)", "Na tę propozycję odpowiedziałem: nie. To się nie zmieniło."]]
			else:
				pairs = LINES.get("consent_scope_desk_" + scope, [["Lena", "Brak zgodnego zapisu odpowiedzi Jakuba."]])
	if id == "forecast_comparator" and decisions.get(&"world_recognized", false) == true:
		var scope := NarrativeRules.scope(decisions)
		pairs = LINES.get("forecast_comparator_" + (scope if not scope.is_empty() else "missing"), []).duplicate(true)
		if scope == "refused" and decisions.get(&"p9.consent_and_cost.revised_reading_response", "") == "refused":
			pairs[pairs.size() - 1] = ["Lena", "Odmówił także nowej propozycji samego odczytu. Nie mam jego udziału w żadnej metodzie."]
	if id == "marta_truth_table" and decisions.get(&"world_recognized", false) == true:
		var pending: Variant = station.get("pending_marta_pairs") if station != null else []
		if pending is Array and not pending.is_empty():
			pairs = pending.duplicate(true)
		else:
			pairs = LINES.get("marta_truth_table_" + NarrativeRules.truth(decisions), FALLBACK_LINES)
	if id == "method_commit_post" and decisions.get(&"world_recognized", false) == true:
		var method := str(decisions.get(NarrativeRules.PROPOSED_KEY, ""))
		if NarrativeRules.committed(decisions, method):
			pairs = LINES.get("method_commit_post_" + method, FALLBACK_LINES)
		else:
			var needs: Array = []
			if NarrativeRules.response(decisions, method).is_empty():
				needs.append(["Lena", "Z tą prognozą wrócę do Jakuba przy łączu w hali. Potrzebuję odpowiedzi na tę jedną metodę."])
			elif NarrativeRules.response(decisions, method) == "refused":
				needs.append(["Lena", "Na tę propozycję odpowiedział: nie. Nie wykonam jej z jego udziałem."])
			if method == "mutual_passage" and decisions.get(NarrativeRules.SYNC_KEY, "") != "accepted":
				if decisions.get(NarrativeRules.SYNC_KEY, "") == "refused":
					needs.append(["Lena", "Marta odmówiła klucza do synchronizacji. Nie wykonam tej metody."])
				else:
					needs.append(["Lena", "Muszę pokazać Marcie cały zapis i osobno zapytać przy stole o klucz."])
					needs.append(["WSKAZÓWKA", "Po pełnym zapisie: środek stołu przypomina ryzyko; lewa strona — odmowa, prawa — zgoda na klucz."])
			# PKG-0242 (UX): the full risk table plays once per named method in
			# a visit; a repeated press at the same side only says what is
			# still missing instead of replaying ten lines.
			if station != null and str(station.get("reviewed_method")) == method:
				pairs = needs
				if pairs.is_empty():
					pairs = [["Lena", _knot_state_line(decisions)]]
					if NarrativeRules.truth(decisions).is_empty():
						pairs.append(["Lena", "Jeszcze nie rozmawiałam z Martą o zapisie."])
			else:
				pairs = NarrativeRules.risk_pairs(method).duplicate(true)
				for review_pair in _commit_review_table(decisions):
					pairs.append(review_pair)
				for need in needs:
					pairs.append(need)
	# --- CR-C (PKG-0195): finały 42A/B/C. Wykonanie i odczyt skutku mają
	# własne klucze; wspólny "household_consequence" rozgałęzia się po stacji
	# i stanie prawdy Marty (wzór gałęzi 18). Bez bramki wiedzy: zatwierdzona
	# metoda zakłada przebytą trasę 18, a testy 0167–0169 sieją metodę wprost.
	if id in ["forced_return_latch", "sealed_other_lena", "flow_closure", "local_lena_recovered", "mutual_passage", "memory_leak"]:
		pairs = LINES.get(id, [])
	if id == "household_consequence" and station != null:
		var fam := _finale_family(station, decisions)
		var truth := _finale_truth(decisions)
		pairs = LINES.get("household_%s_%s" % [fam, truth], FALLBACK_LINES).duplicate(true)
		if fam in ["a", "b", "c"] and truth in ["full", "partial", "withheld"]:
			for carrier in NarrativeRules.carrier_pairs(decisions):
				pairs.append(carrier)
			if fam == "a":
				pairs.append(["RÓWNIA — APEL MIEJSCOWEJ MARTY", "Poszukuję Leny Wolskiej. Zaginęła podczas próby UCP. Nie zamykam zgłoszenia."])
				pairs.append(["RÓWNIA — KARTA SERWISOWA", "Jakub Wolski: napęd oddany. Następna zmiana bez zmiany stanowiska."])
				pairs.append(["RÓWNIA — ZAPIS UCP", "Węzeł pozostaje pod nadzorem. Incydent zamknięty."])
			elif fam == "b":
				pairs.append(["RÓWNIA — KARTA SERWISOWA", "Jakub Wolski: napęd oddany. Udział zakończony w uzgodnionym zakresie."])
				pairs.append(["RÓWNIA — ZAPIS WĘZŁA", "Eksport kosztów z tego węzła: zamknięty."])
			elif truth == "full":
				pairs.append(["RÓWNIA — MIEJSCOWA LENA", "Nie wrócę do tej próby. Marta zostaje ze mną przy stole; czeka na odpowiedź."])
				pairs.append(["DWA ODCZYTY", "Dalszy dryf po rozdzieleniu. UCP nie ma wyłączności na odczyt obu stron."])
			if fam in ["a", "b"]:
				var local_reply := {
					"full": "Dostałam cały zapis przed wyborem. Nadal czekam na jej własną odpowiedź.",
					"partial": "Pokazałaś mi tylko sygnał. Kartka o warunku przerwania nadal jest twoim długiem.",
					"withheld": "Nie pokazałaś mi kartki. Nie zgadzałam się w ciemno na twoją procedurę.",
				}
				pairs.append(["RÓWNIA — MIEJSCOWA MARTA", local_reply[truth]])
			if decisions.get(&"p9.method_commitment.marta_was_incomplete", false) == true and truth == "full":
				pairs.append(["RÓWNIA — MIEJSCOWA MARTA", "Uzupełniłaś zapis przed wyborem. Pamiętam też, że najpierw go schowałaś."])
	if id == "flow_closure" and station != null and not _truthy(station.get("is_flow_closed")):
		pairs = [["Lena", "Wygaszam domową sygnaturę i wzmacniam lokalną odpowiedź. Kanał jeszcze zostaje otwarty."],
			["Lena", "Sprawdzę ją przy progu. Zamknę przepływ dopiero, kiedy odpowie u siebie."]]
	if id == "loop_logbook":
		pairs = pairs.duplicate(true)
		pairs.append(["Lena", "Kontakt nastąpił przy pierwszym odczycie. Powtórka dała mi próbkę i opóźniła wyjście."
			if decisions.get(&"home_sample_preserved", false) == true else "Kontakt nastąpił przy pierwszym odczycie. Wyszłam bez powtórki; w czytniku został bufor."])
	if id == "cost_selector_preview":
		pairs = pairs.duplicate(true)
		pairs.append(["Lena", "Zapis, którym mogę zapłacić, to surowa próbka." if decisions.get(&"home_sample_preserved", false) == true
			else "Nie mam pełnej próbki. Mogę oddać sekundę bufora czytnika."])
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


static func _finale_family(station: Node, decisions: Dictionary) -> String:
	match String(station.name):
		"Station42A":
			return "a"
		"Station42B":
			return "b"
		"Station42C":
			return "c"
	match String(decisions.get(&"method_committed", decisions.get(&"p9.method_commitment.method_committed", ""))):
		"close_equal_recover_local":
			return "b"
		"mutual_passage":
			return "c"
	return "a"


static func _finale_truth(decisions: Dictionary) -> String:
	return NarrativeRules.truth(decisions)


static func _commit_review_table(decisions: Dictionary) -> Array:
	var table: Array = NarrativeRules.carrier_pairs(decisions).duplicate(true)
	if decisions.get(&"local_lena_signal_confirmed", false) == true:
		table.append(["Lena", "Mam odpowiedź, która poprawiła mój błąd, i dziennik miejscowej."])
	else:
		table.append(["Lena", "Dziennik kontaktu nie zastąpi potwierdzonej odpowiedzi."])
	match NarrativeRules.truth(decisions):
		"full": table.append(["Lena", "Marta widziała zapis próby i warunek przerwania. To jeszcze nie zgoda na klucz."])
		"partial": table.append(["Lena", "Nie pokazałam Marcie warunku przerwania."])
		"withheld": table.append(["Lena", "Nie pokazałam Marcie kartki."])
		_: table.append(["Lena", "Jeszcze nie rozmawiałam z Martą o zapisie."])
	match NarrativeRules.scope(decisions):
		"granted": table.append(["Lena", "Jakub dopuścił szerszy udział. Liczy się jego osobna odpowiedź na wybraną metodę."])
		"limited": table.append(["Lena", "Jakub dopuszcza tylko wskazania, bez podłączenia do człowieka."])
		"refused": table.append(["Lena", "Jakub odmówił podłączenia. To nie oznacza końca naszej relacji."])
		_: table.append(["Lena", "Zgoda Jakuba: brak zgodnego zapisu."])
	table.append(["Lena", "Rejestr pokazuje, że UCP znało powiązany koszt." if decisions.get(&"ucp_cost_ledger_found", false) == true
		else "Nie mam odczytanego rejestru kosztów UCP."])
	table.append(["Lena", _knot_state_line(decisions)])
	return table


static func _knot_state_line(decisions: Dictionary) -> String:
	var method := str(decisions.get(NarrativeRules.PROPOSED_KEY, ""))
	if not NarrativeRules.METHODS.has(method):
		return "Nie wskazałam jeszcze jednej metody."
	if NarrativeRules.executable(decisions, method):
		return "Mam odpowiedzi potrzebne do tej metody. Wykonanie dopiero przede mną."
	return "Znam koszt tej metody. Nie ma ona wymaganych zgód."


static func _read_consent(decisions: Dictionary) -> String:
	return NarrativeRules.scope(decisions)


