# PKG-0239 — raport wdrożenia poprawek narracyjnych

Data: 2026-09-22. Repozytorium: `diwad-code/getting_strange`.
Baza: `081e7711105a184934b80f35f43cf3682fde4e2b`.
Gałąź: `fix/narrative-audit-2026-09-22`.

**Status: poprawki zastosowane w źródłach; wykonanie w silniku niepotwierdzone.
To nie jest PRODUCT GO, wydanie ani potwierdzenie działania wszystkich gałęzi.**
Zakres: opowieść, dialog, czytelność celu, warunki zgód i następstw decyzji.

## A. Materiały i granice potwierdzenia

Podstawa: `PROMPT_WDROZENIA_POPRAWEK_GETTING_STRANGE.md`, raport
`Audyt_fabularny_Getting_Strange.md`, ZIP audytowy oraz źródła repozytorium.
Odczytano dokumenty kanonu i aktywnej trasy, AGENTS oraz przekazanie projektu.
Z GitHuba odczytano też brakujące w dawnym wycinku
`docs/rebuild/PKG_0193_CREATIVE_SCENES.md`,
`docs/rebuild/PKG_0194_CREATIVE_SCENES_B.md` i
`scripts/ui/station_dialogue_cue.gd`. Numeracja aktywna: **01–18→42A/B/C→43**.
Sceny 19–41 pozostają wycofanymi dawcami; nie są przywracane.

Oryginalny tekst każdego zmienianego pliku jest powiązany z SHA obiektu Git
na wskazanej bazie. Publikacja musi przerwać się przy różnicy, nie nadpisać
innej wersji. Nowe pozytywne stany nie są dopisywane do wcześniejszych
zapisów jako domyślna zgoda lub zdobyta wiedza.

Nie uruchomiono Godota ani PowerShella: brak ich w środowisku wykonawcy.
Nie wykonano verify.ps1, verify_docs.ps1, snapshot.ps1, seansu winiet,
przejścia gry ani pomiaru czasu. Nie modyfikowano testów i nie ogłoszono
wyniku PASS. Odnotowano wyłącznie lekturę źródeł, porównanie zmian,
zgodność nazw i podstawowe kontrole treści. 56 wpisów stałego LINES zostało
odczytanych; ich pojedyncze kwestie mają do 115 znaków. To nie jest dowód
czytelności całej prezentacji, jej rytmu lub dopasowania do ekranu.

## B. Wdrożenie kroków 00–17

Każdy poniższy wiersz oznacza zmianę zastosowaną w źródłach. Status wykonania
w grze dla wszystkich: **brak danych**. Numery wierszy dotyczą tej wersji.

| Krok / problem | Przed | Po | Źródło | Konsekwencje i ograniczenia |
|---|---|---|---|---|
| 00 | Stan wejściowy | Bezpośrednia praca na bazie GitHub, źródła audytu i prompt | `scripts/levels/creative_scene_lines.gd:16` — `const LINES` | Oryginały zabezpieczone; zastosowanie wymaga zgodnego SHA, nie nadpisuje odmiennej treści. |
| 01 / P0.1 | Skutek ogłaszany przed wykonaniem | Zamiar 18, wykonanie 42, następstwa 43; B odzyskuje przed zamknięciem | `scripts/levels/station_42b.gd:216` — `func execute_close_flow` | Otwarcia .tscn prospektywne; cue nie powtarza ich po wykonaniu; finały odtwarzają utrwalone etapy. |
| 02 / P0.4 | Niejasny właściciel pamięci i nośnika | Własne zdanie usłyszane dziś albo 20:40:07 faktycznego nośnika | `scripts/levels/creative_scene_lines.gd:51` — `"cost_selector_marta"` | Marta pamięta; helper rozdziela próbkę/bufor i integralność; 16 nie pozwala wymienić kosztu po powrocie. |
| 03 / P1.1 | Sprzeczna obietnica punktualności | Obietnica wyjścia po jednym odczycie, bez przesuwania 20:40 | `scripts/campaign/cold_open_facts.gd:98` — `Jeden odczyt i wychodzisz?` | Odpowiedzi 01/03 rozróżniają powtórkę i objazd. |
| 04 / P1.4 | Za słaby wcześniejszy ślad osobistej straty | Nazwisko Jakuba na istniejącym pomniku | `scripts/levels/station_04.gd:114` — `Nazwisko Jakuba` | Bez prologu, nowego obiektu i przedwczesnej anomalii. |
| 05 / P1.2 | Powtórna kontrola torby blokowała ulicę | Inspekcje opcjonalne, samo przejście nie stempluje oględzin | `scripts/levels/station_05.gd:120` — `func cross_street_towards_home` | Również guidance i stary obowiązek gap_ledger zostały uzgodnione. |
| 06 / P1.3 | Pytanie o zamknięcie kiosku | Pytanie sprawdzające trasę Linii 4 oraz hipotezę objazdu | `scripts/levels/station_06.gd:183` — `func ask_kiosk_vendor` | Nie wymyślono nazw przystanków niepodanych w źródłach. |
| 07 | Autoocena syntezy zamiast zobowiązania | Lena przyjmuje poszukiwanie, nie obiecuje pewnego wyniku | `scripts/levels/creative_scene_lines.gd:31` — `"synthesize"` | Mocne sceny domu/Jakuba i istniejące przejścia pozostają; nazwy 14 po zachowaniach. |
| 08 / P0.5–6 | Odpowiedź równała się pełnej identyfikacji; koszt mylono z winą | Etapy dowodu, cel miejscowej, późniejszy podpis Wierzbickiej, wiedza UCP | `scripts/levels/creative_scene_lines.gd:42` — `"loop_logbook"` | Korekta nie daje wszechwiedzy; echo dotyczy chwili wiadomości; rejestr nie ustala zamiaru zabójstwa. |
| 09 / P0.2 | Zakres działał jak blankiet, odmowa jak stan do ponowienia | Ryzyko jednej metody, prośba i osobna odpowiedź | `scripts/levels/station_17.gd:203` — `func _commit_consent` | Tylko zmieniona propozycja odczytu do B po odmowie podłączenia; odpowiedź dopiero po pełnej wymianie. |
| 10 / P0.3 | Warunek klucza Marty nie rozstrzygał procedury | Pełny zapis i osobna odpowiedź o synchronizacji przed migawką | `scripts/levels/station_18.gd:328` — `func _request_marta_sync` | Full nie znaczy zgoda ani przebaczenie; uzupełnienie zachowuje historię wcześniejszego uniku. |
| 11 | Wiedza obu Mart mieszała się | Własna rozmowa domowej; osobno podpisane źródła miejscowej | `scripts/levels/creative_scene_lines.gd:92` — `"household_a_full"` | B używa starego echa i niewysłanej wiadomości, nie nowego kontaktu przez zamknięty kanał. |
| 12 / P1.6 | Wierzbicka bez argumentu, miejscowa bez rozliczenia | Obrona lokalnego wyniku; miejscowa przyznaje swoje ryzyko w B/C | `scripts/levels/creative_scene_lines.gd:11` — `"adaptation_offer_terminal"` | Wcześniejszy spór o czytnik w 11; ratunek nie uniewinnia miejscowej. |
| 13 / P1.7 | Uliczny wybór motywowany funkcją sceny | Lena przynosi kopie i swój czytnik do Marty | `scenes/levels/station_18.tscn:73` — `opening_line =` | Również wyjście 17 i guidance18 wyjaśniają cel, bez nowego urządzenia. |
| 14 | Niejasna utrata B, łagodzony przeciek C, odtwarzany materiał A | A pozostawia miejscową; B traci indeks; C zakłóca pracę Jakuba | `scripts/levels/creative_scene_lines.gd:113` — `"memory_leak"` | Poprawny właściciel pogrzebu; nośnik i koszt pozostają zgodne z wyborem16. |
| 15 / P1.5 | Język dokumentacji i sterowania w ustach postaci | Konkret zamiast autooceny; instrukcja obsługi ma osobny głos | `scripts/levels/creative_scene_lines.gd:44` — `"signal_sender_armed"` | Otwarcia, guidance, rezerwowe DIALOGUE_LINES i epilog nie przywracają naprawionych kwestii. |
| 16 | Wszechwiedzące ŚWIADECTWO i bilans moralny | Pięć beatów osób i dokumentów, nośnik zamiast flagowej oceny | `scripts/levels/station_43.gd:188` — `func _setup_dialogue_for_branch` | Losy rozłożone na42/43. Ich czytelność audiowizualna wymaga uruchomienia gry. |
| 17 | Sprzeczne aktywne skróty dokumentacji | Sześć aktywnych dokumentów uzgodnionych z poprawkami | `docs/narrative/FULL_STORY.md:3` — `## Aktywny przebieg po audycie` | Stare sekcje dawców oznaczone, nie kasowane. Braki nie są oznaczone jako PASS. |

## C. Właściciele zapisu i zależności

`station_17._on_narrative_dialogue_finished()` zapisuje pierwszy zakres,
`p9.consent_and_cost.initial_scope`, `method_responses` i ewentualną
`revised_reading_response`. Samo ustawienie kolejki lub środkowy odczyt
warunków nie zapisuje odpowiedzi. Po odmowie podłączenia nowa propozycja
samych wskazań do B nie usuwa pierwszej odmowy. Odpowiedź na tę samą
metodę jest niezmienna. Granice dotyczą udziału osoby, nie moralnego
uniewinnienia Leny: Jakub w A nie udziela zgody za pokrzywdzoną siostrę.

`station_18.choose_method_from_player_side()` zapisuje propozycję.
`_on_narrative_dialogue_finished()` zapisuje ujawnioną prawdę, jej pierwotny
zakres i historię uniku, oraz osobno `marta_sync_response`.
`_commit_method()` dopiero po odpowiedziach zamraża snapshot. Full nie
zapisuje sync; uzupełnienie prawdy nie kasuje wcześniejszego przemilczenia.

`narrative_repair_rules.gd` jest współdzielonym odczytem tych faktów, nie
nowym urządzeniem ani nowym systemem dialogowym. `scope()` i `truth()`
wymagają zgodności istniejących par kluczy. `executable()` oddziela opis
prognozy od zgody. `committed()` wymaga właściwej odpowiedzi i migawki.
`carrier_pairs()` rozdziela nośnik, integralność i brak danych.

W B pierwszy `execute_close_flow()` zapisuje rozpoczęcie odzyskania,
nie `flow_closed`. Próg potwierdza miejscową, drugie użycie zasuwy zamyka
przepływ. Dopiero potem dostępny jest skutek i epilog. Stan zostaje
odtworzony przy powrocie. W 01/16 nie można wymienić dawnego wyboru na nową
próbkę lub wygodniejszy koszt. Domowa Marta otrzymuje własny fakt rozmowy
po swojej wymianie w A/C, nie przez skopiowanie stanu miejscowej.

## D. Odbiór 36 kryteriów narracyjnych

**Poniżej: potwierdzenie lekturą tekstu i warunku, nie uruchomieniem gry.**
Czas, prezentacja audiowizualna i przejście gracza: **brak danych**.

| Nr | Kryterium | Źródło | Ustalenie |
|---|---|---|---|
| 1 | Kontakt przy pierwszym odczycie obu gałęzi | `scripts/levels/creative_scene_lines.gd:236` — `if id == "loop_logbook"` | Powtórka oznacza próbkę i opóźnienie, nie przejście. |
| 2 | Obietnica bez zmiany20:40 | `scripts/levels/station_01.gd:414` — `Jeden odczyt. Spakowałam` | Dwie odpowiedzi zależne od rzeczywistego wyboru; objazd oddzielnie w03. |
| 3 | 01–05 zwyczajne; kiosk nierozstrzygający | `scripts/levels/station_06.gd:199` — `Na tym rozkładzie` | Pytanie o trasę, nie teoria innego świata. |
| 4 | Rozpoznanie dopiero w13 | `scripts/levels/creative_scene_lines.gd:31` — `"synthesize"` | Zachowana bramka world_recognized; brak wczesnej diagnozy. |
| 5 | Synteza z dostępnych źródeł | `scripts/levels/station_13.gd:374` — `func synthesize` | Warunki istniejącej syntezy zachowane; selektory nazywają brak materiału. |
| 6 | Nazwy po obu zachowaniach14 | `scripts/levels/creative_scene_lines.gd:35` — `"relay_logbook_named"` | Nazwanie pozostaje po wykonaniu, nie wyprzedza obserwacji. |
| 7 | Responsywność nie daje pełnej identyfikacji | `scripts/levels/creative_scene_lines.gd:45` — `"signal_sender_confirmed"` | Korekta, log i echo mają odrębne role dowodowe. |
| 8 | Koszt różny od osobistego zamiaru | `scripts/levels/creative_scene_lines.gd:11` — `"cost_ledger_console"` | Dowód wiedzy instytucji bez dopisanego zabójstwa. |
| 9 | 18→42→43 i powroty | `scripts/levels/station_42b.gd:416` — `func _restore_chain_from_decisions` | Otwarcia przyszłe; odtworzenie nie zapisuje nowego wykonania. |
| 10 | Brak próbki nie usuwa reszty sprzętu | `scripts/levels/station_01.gd:364` — `func pack_equipment_for_marta` | Zachowany czytnik, dokument i bufor; brak nie staje się próbką. |
| 11 | Istnienie i integralność osobno | `scripts/levels/narrative_repair_rules.gd:87` — `static func carrier_pairs` | Oddzielne home_sample_preserved i small_cost.choice. |
| 12 | Kaloryfer nie jest biografią przybyłej | `scripts/levels/creative_scene_lines.gd:51` — `"cost_selector_marta"` | Ubytek własnej pamięci dzisiejszego zdania. |
| 13 | Marta nadal pamięta | `scripts/levels/creative_scene_lines.gd:51` — `Powiedziałam: na kaloryferze.` | Marta kończy zdanie, przybyła nie odtwarza pamięci. |
| 14 | Sekunda właściwego nośnika | `scripts/levels/creative_scene_lines.gd:53` — `"cost_selector_sample_buffer"` | Gałąź próbki odrębna od bufora; obie20:40:07. |
| 15 | Finał nie odtwarza zasobu | `scripts/levels/station_16.gd:214` — `state.decisions.has(FACT_COST_CHOICE)` | Powrót do16 nie wymienia kosztu;01 nie produkuje próbki ponownie. |
| 16 | Prośba, zakres, ryzyko, odpowiedź | `scripts/levels/station_17.gd:280` — `func _on_narrative_dialogue_finished` | Odpowiedź zapisywana po wymianie, nie po wskazaniu biurka. |
| 17 | Limited nie otwieraA/C; odmowa nie otwiera metody | `scripts/levels/narrative_repair_rules.gd:28` — `static func scope_allows` | B dopuszcza ograniczony odczyt, nadal z osobną odpowiedzią. |
| 18 | Prognoza mimo odmowy | `scripts/levels/station_18.gd:469` — `"description_available": true` | Opis i możliwość wykonania są rozdzielone. |
| 19 | Nowa propozycja, nie reset odmowy | `scripts/levels/station_17.gd:232` — `revised_reading_response` | Jedna zmieniona propozycjaB; nowa odmowa również wiążąca. |
| 20 | Brak i sprzeczność nie dają granted | `scripts/levels/narrative_repair_rules.gd:17` — `static func _agreed_value` | Oba zapisy muszą się zgadzać; brak to brak. |
| 21 | Full nie daje przebaczenia ani klucza | `scripts/levels/station_18.gd:313` — `func _commit_marta_truth` | Odrębny stan i rozmowa o synchronizacji. |
| 22 | C rozstrzygnięte przed snapshotem | `scripts/levels/narrative_repair_rules.gd:34` — `static func executable` | Full i sync=accepted wymagane przed commit_method. |
| 23 | Dwie Marty mają oddzielną wiedzę | `scripts/levels/creative_scene_lines.gd:116` — `"household_c_full"` | Domowa słyszy własne wyjaśnienie; przeciek kubka nie jest pełną biografią. |
| 24 | Odpowiedzialność miejscowej B/C | `scripts/levels/creative_scene_lines.gd:99` — `"local_lena_recovered"` | Własny zamiar i brak uprzedniej zgody; późniejsze UCP nie uniewinnia. |
| 25 | Brak nowej odpowiedzi po zamknięciu | `scripts/levels/creative_scene_lines.gd:104` — `ECHO ZACHOWANE Z ANALIZATORA` | Stare echo, niewysłane Jadę, odrębnie podpisane dokumentyRówni. |
| 26 | 05 bez obowiązkowej torby | `scripts/levels/station_05.gd:120` — `func cross_street_towards_home` | Przejście nie zapisuje inspekcji; rejestr luk wycofuje obowiązek. |
| 27 | Kiosk sprawdza trasę | `scripts/levels/station_06.gd:183` — `func ask_kiosk_vendor` | Brak niepodanych nazw przystanków. |
| 28 | Przejścia10–13 i17–18 | `scripts/levels/creative_scene_lines.gd:27` — `"minimal_report"` | Istniejące cele pozostają;17/18 wyjaśniają kopie i spotkanie. |
| 29 | Mocne sceny zachowane | `scripts/levels/creative_scene_lines.gd:30` — `"jakub_refusal"` | Nie zamieniono granicy blizny w techniczny warunek zdobycia dowodu. |
| 30 | Argument Wierzbickiej | `scripts/levels/creative_scene_lines.gd:63` — `Tego wyniku mam pilnować.` | Konflikt interesów, nie dodatkowy pościg lub nowa postać. |
| 31 | Różne ceny A/B/C | `scripts/levels/creative_scene_lines.gd:88` — `"sealed_other_lena"` | A: nieobecność; B: brak własnego indeksu; C: przeciek. |
| 32 | Przeciek C nie znika po uspokojeniu | `scripts/levels/creative_scene_lines.gd:113` — `Sam zdecyduję, kiedy wrócę do pracy.` | Cel Jakuba i przerwana praca pozostają jego sprawą. |
| 33 | Stany wszystkich podmiotów42/43 | `scripts/levels/creative_scene_lines.gd:215` — `RÓWNIA — APEL MIEJSCOWEJ MARTY` | Podpisane źródła obu Len/Mart, Jakuba, UCP i odczytów; wykonanie wieloperspektywiczne nieobejrzane. |
| 34 | Brak metakomentarzy postaci | `scenes/levels/station_42a.tscn:74` — `opening_line =` | Usunięte sterowanie i przedwczesny wynik; instrukcje oddzielnie. |
| 35 | Epilog bez globalnej tezy | `scripts/levels/station_43.gd:188` — `func _setup_dialogue_for_branch` | Pięć konkretnych beatów; brak bilansu moralnego. |
| 36 | Twardy zakres zachowany | `docs/rebuild/CAMPAIGN_MAP.md:3` — `## Uzupełnienie aktywnej mapy` | Ta sama trasa, postacie, urządzenia i trzy rodziny finałów. |

### Cztery przekroje kosztu

| Nośnik 01 | Koszt 16 | Stan 18/42/43 |
|---|---|---|
| Surowa próbka | `marta_memory` | Próbka istnieje; przybyła nie pamięta własnego dzisiejszego zdania Marty |
| Surowa próbka | `sample_second` | Próbka istnieje bez 20:40:07 |
| Bufor | `marta_memory` | Bufor istnieje; brak własnej pamięci wypowiedzi; Marta pamięta |
| Bufor | `sample_second` | Bufor bez 20:40:07; nie pojawia się pełna próbka |

Źródła: `creative_scene_lines.gd`, klucze cost_selector_* oraz
`narrative_repair_rules.carrier_pairs()`. Cztery rozgałęzienia potwierdzono
w źródłach; przejście w silniku pozostaje niepotwierdzone. Opowieść nie
przywraca wspomnienia przez to, że Lena usłyszała treść ponownie.

### Zakresy i osiągalność

| Zakres i odpowiedź | Opisy prognoz | A | B | C |
|---|---|---|---|---|
| granted, bez odpowiedzi na metodę | Dostępne po źródłach | Niedostępne | Niedostępne | Niedostępne |
| granted i accepted na tę metodę | Dostępne | Zgodnie z odpowiedzią | Zgodnie z odpowiedzią | Tylko full i sync=accepted |
| limited i accepted na B | Dostępne | Niedostępne | Dostępne po pozostałych warunkach | Niedostępne |
| refused, bez nowej propozycji | Dostępne | Niedostępne | Niedostępne | Niedostępne |
| refused, nowy sam odczyt B zaakceptowany | Dostępne | Niedostępne | Efektywny zakres limited; pierwsza odmowa pozostaje | Niedostępne |
| Odmowa także nowego odczytu | Dostępne | Niedostępne | Niedostępne | Niedostępne |
| Brak lub sprzeczność | Dostępne z nazwaniem luki | Niedostępne | Niedostępne | Niedostępne |

Full/partial/withheld mogą występować w A/B, które nie używają klucza do
synchronizacji. Nie oznacza to zgody Marty na cały plan. C z partial/withheld
jest **nieosiągalne zgodnie z warunkami**. Przed wyborem można uzupełnić
prawdę, lecz historia uniku i odrębna odpowiedź o kluczu pozostają.
Odmowa klucza nie znika po powrocie. Po snapshotcie lub rozpoczęciu finału
nie wymienia się zgód, prawdy i metody.

Kolejka dialogu 17/18 nie jest zgodą. Odpowiedź powstaje w callbacku końca
wymiany. Przerwanie sceny przed nim nie zapisuje jeszcze odpowiedzi.
Powrót odczytuje utrwalone fakty. Zachowanie w rzeczywistym save/reload
oraz podczas animacji pozostaje do potwierdzenia w silniku.

## E. Zachowane ograniczenia

Bez zmian: trasa, trzy zakończenia, postacie, miejsca, urządzenia,
Sadowa 7 i lokale 12/14, dwie biografie kurtki, granica blizny Jakuba,
jego napęd, rozpoznanie 13, zachowania martwego obwodu przed nazwami 14,
kontrole i jawne uzbrojenie błędu 15. Nie dodano narratora, moralnego
licznika, pościgu, nowej ofiary ani prawdziwszego świata. Nie wyjaśniono
trzysekundowego dopisku wykładem. Helper odczytuje istniejący magazyn
faktów; główny menedżer zapisu nie jest przebudowany.

Zmiany .tscn obejmują teksty otwarć i podpisy, nie geometrię i zasoby.
Nie zmieniano oprawy, sterowania, fizyki, testów ani legacy 19–41.
Poprawki dokumentów dotyczą aktywnych fragmentów i oznaczenia dawcy,
nie przerobienia zamrożonej historii na nową kampanię.

## F. Braki i przekazanie

**Uruchomienie:** brak Godota i PowerShella, brak potwierdzenia działania
skryptów i narzędzi projektu. Nie przenosić historycznego PASS na ten pakiet.

**Realizacja scen:** nie obejrzano winiet, reakcje ciała i rytm pozostają
niepotwierdzone. Podpisane perspektywy Równi są konkretnymi źródłami, ale
ich czytelność w prezentacji musi zostać sprawdzona. Same teksty nie
uprawniają do uznania całej sceny audiowizualnej za poprawioną.

**Starsze zapisy po wyborze:** nie mają nowej odpowiedzi na metodę ani
odrębnej zgody na klucz. Są odrzucane zamiast otrzymać dorozumianą zgodę.
Do sprawdzenia nowej trasy potrzebny jest nowy przebieg lub zapis sprzed
zobowiązania. Nie usuwano i nie przerabiano zapisu użytkownika.

**Kiosk:** brak nazw porównywanych punktów trasy w materiale. Nie dopisano
wymyślonych przystanków; sprzedawca odpowiada na różnicę trasy i objazd.

**Status projektu:** historyczne CURRENT_STATE, SESSION_LOG i
NEXT_SESSION_PROMPT nie potwierdzają tego pakietu. Ten raport jest
przekazaniem zmiany bez fikcyjnego snapshotu, wydania i PRODUCT GO.
Wymaga sprawdzenia 17/18, powrotów, przekrojów kosztu i osiągalnych finałów.
Nie wolno uzyskać zgodności przez automatyczne przyznanie zgody, odzyskanie
nośnika lub zatarcie pierwszej odmowy. Nie scalać ani nie wydawać automatycznie.
