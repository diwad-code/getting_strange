# Mapa kampanii P9 — 20 odwiedzanych adresów

## Uzupełnienie aktywnej mapy / PKG-0239 / 2026-09-22

Tabela aktywnej trasy uwzględnia korekty audytu. Szczegóły:
`docs/narrative/NARRATIVE_FIX_IMPLEMENTATION.md`. Nie dodano miejsca,
urządzenia lub czwartego finału. Numery dawcy 19–41 pozostają historyczne.

„Pierwsza minuta”, „pięć minut” i „trzydzieści minut” to cele projektowe,
nie zmierzone czasy tej wersji. Sekundy odbioru: brak danych. W 18 Lena
przenosi kopie z hali i prognozy we własnym czytniku do Marty na znaną
ulicę. Nie pojawia się tam nowe urządzenie rozwiązujące zagadkę.

Opis ryzyka nie wymaga zgody na wykonanie. Powrót 18→17 służy odpowiedzi
na wskazaną metodę, nie resetuje odmowy. Po odmowie podłączenia możliwa
jest jedna nowa propozycja samego odczytu do B. Marta osobno odpowiada
w sprawie klucza C. Zatwierdzenie 18 zamraża zamiar; istniejące czynności
42 go realizują. W B ta sama zasuwa zamyka kanał dopiero po odzyskaniu
miejscowej. Epilog nie oddaje głosu wszechwiedzącemu narratorowi.

Aktualizacja CR-A / PKG-0193: dla treści i writerów 09–13 obowiązuje mapa
`PKG_0193_CREATIVE_SCENES.md`. 09 używa fotografii (nie osobnej akcji
porównania dwóch dokumentów). `marta_relationship_disclosed` zachowuje
rzeczywistego writera w 08; 10 dostarcza wspomnienia i granicę.
`recognition_evidence_carried` oznacza wyłożenie własnego dokumentu i czytnika;
nie wymaga ani nie fabrykuje opcjonalnej surowej próbki. Adres w 07/08/13:
Sadowa 7, mieszkania 12/14. Rozmowa 06 sprawdza różnicę trasy i hipotezę objazdu (PKG-0239).

Status: **AKTYWNY KONTRAKT PRODUKTU P9 — BUNDLE-03 / PKG-0156**
Data: 2026-08-31
Decyzje nadrzędne: D-168, ADR-008
Źródła: `docs/narrative/FULL_STORY.md`, `docs/narrative/CONTINUITY_TRACKER.md`,
`docs/PROJECT_REBUILD_EXECUTION_PLAN.md` §4
Kontrakt gracza: `docs/rebuild/PLAYER_CONTRACT.md`
Rodziny miejsc: `docs/rebuild/LOCATION_FAMILY_BIBLE.md`

Docelowy przebieg: **Station 01–18 liniowo → jeden wariant 42A/B/C → Station 43.**
To jest 20 odwiedzanych adresów i 22 techniczne zasoby sceniczne (trzy warianty 42).

---

## 1. Słownik statusów

| Status | Znaczenie |
|---|---|
| `KEEP` | scena legacy pozostaje aktywnym zasobem trasy bez przeprojektowania treści |
| `ADAPT` | adres legacy znika z trasy, lecz nazwany materiał przechodzi do wskazanego nowego adresu |
| `RETIRE` | adres i materiał wychodzą z aktywnej trasy; scena zostaje wyłącznie zamrożonym dawcą w snapshotach |

Zasada twarda: **nie zachowujemy adresu z powodu kosztu utopionego.** Brak
statusu, `MAYBE`, `TBD` i domyślny `KEEP` są zabronione.

## 2. Reguła kierunku (czytelność trasy)

- Postęp kampanii biegnie **zawsze w prawo albo w górę**.
- Powrót biegnie **zawsze w lewo albo w dół** (`ReturnZone`, D-142).
- Dwa fabularne powroty w przód trasy wchodzą **z prawej** istniejącym
  mechanizmem (`arrival_side_for`: 12 → 13 powrót do mieszkania, 17 → 18
  powrót na ulicę z 05; PKG-0230, P2-1). Próg jest po stronie wejścia (D-227).
- Pion realizują wyłącznie `LadderZone` i `ServiceLift`; próg wejścia bez nich
  to 18 px (D-123). Zejście do 14 i wyjście z 15 to **właz techniczny**
  (HATCH w Binderze); osobnej windy serwisowej w 14 nie ma (P2-1).
- Gracz nigdy nie musi zgadywać kierunku postępu; ma go pokazać kompozycja
  kadru, nie etykieta.

---

## 3. Trasa liniowa 01–18

Kolumna „zmiana pytania” podaje pytanie, z którym gracz **wychodzi** z adresu.

### Pierwsza minuta i pierwsze pięć minut

| # | Cel Leny | Rodzina | Działanie gracza | Zmiana pytania | Wejście / wyjście | Materiał legacy | Status |
|---|---|---|---|---|---|---|---|
| 01 | zamknąć pomiar trzysekundowej luki i wrócić do Marty | techniczna/przemysłowa | wykonać pierwszy odczyt; wybrać powtórkę z próbką albo wyjście po jednym pomiarze; odpowiedzieć Marcie | „czy ta luka jest prawdziwa, czy to znów artefakt?” | start kampanii / prawa (śluza) | Station 01 | `ADAPT` |
| 02 | wyjść z terenu pomiaru | zewnętrzna/miejska | obejść realne prace serwisowe, wejść po drabinie na nasyp | „ile jeszcze czasu mnie to kosztuje?” | lewa / prawa | Station 02 | `ADAPT` |
| 03 | sprawdzić dojazd i odpowiedzieć Marcie | tranzytowa | odczytać rozkład, odpisać Marcie, wsiąść | „jak bardzo się spóźnię?” | lewa / wejście do pojazdu | Station 03 | `ADAPT` |
| 04 | dojechać do dzielnicy | tranzytowa | porównać bufor czytnika z zapisem, spojrzeć na ślad katastrofy Linii 4 | „dlaczego czytnik pamięta lukę, której nie zapisałam?” | wnętrze pojazdu / prawa (wysiadka) | Station 04 | `ADAPT` |

### Pierwsze trzydzieści minut

| # | Cel Leny | Rodzina | Działanie gracza | Zmiana pytania | Wejście / wyjście | Materiał legacy | Status |
|---|---|---|---|---|---|---|---|
| 05 | przejść ostatni odcinek do domu | zewnętrzna/miejska | przejść znaną ulicą; inspekcje ulicy i torby są opcjonalne | „czy wszystko jest normalne?” (baseline) | lewa / prawa | Station 05 | `ADAPT` |
| 06 | kupić wodę i potwierdzić trasę | zewnętrzna/miejska | porównać druk z pamięcią, kupić wodę, zapytać o rozbieżną trasę Linii 4 i objazd | „pomyliłam rozkład, czy rozkład się zmienił?” | lewa / prawa | Station 06 (rozkłady) + Station 07 (kiosk) | `ADAPT` |
| 07 | wejść do własnego budynku | zewnętrzna/miejska | porównać numer z dokumentu z tabliczką, użyć domofonu, wpisać kod | „mieszkam pod 12 czy pod 14?” | lewa / próg klatki | Station 08 | `ADAPT` |
| 08 | ustalić, czy zmieniono numerację | mieszkalna | wejść po schodach, zapytać sąsiadkę bez sugerowania odpowiedzi, przekręcić klucz w zamku 14 | „dlaczego mój klucz tu działa?” | próg / drzwi mieszkania | Station 09 + Station 10 | `ADAPT` |

### Cudzy dom i pierwsza tajemnica

| # | Cel Leny | Rodzina | Działanie gracza | Zmiana pytania | Wejście / wyjście | Materiał legacy | Status |
|---|---|---|---|---|---|---|---|
| 09 | ustalić, kto tu mieszka | mieszkalna | obejrzeć rzeczy dwóch osób i fotografię, uszanować granicę cudzej prywatności | „kto przygotował życie, które pasuje do mnie?” | drzwi / wnętrze | Station 11 + Station 13 | `ADAPT` |
| 10 | uzyskać od Marty niezależny opis dnia | mieszkalna | wykonać zwykłą domową czynność, wysłuchać dwóch wersji wspólnej wyprawy, przyjąć granicę Marty | „Marta mówi o mnie czy o kimś innym?” | wnętrze / prawa (wyjście z domu) | Station 12 + Station 14 + Station 15 + Station 24 | `ADAPT` |
| 11 | odczytać własną historię pracy | instytucjonalna | przejść kontrolę biometryczną mimo obcego numeru karty, odczytać fizyczny zapis aktywności, skopiować minimalny zakres raportu | „czy instytucja prowadzi inną wersję mojego życia?” | lewa / prawa | Station 16 + Station 17 + Station 18 | `ADAPT` |
| 12 | sprawdzić, czy Jakub jest żywą osobą | techniczna/przemysłowa | zadać dwa pytania kontrolne przez łącze, spotkać go w warsztacie, przyjąć jego odmowę pokazania blizny | „czy mój brat naprawdę tu żyje?” | lewa / prawa | Station 19 + Station 20 | `ADAPT` |
| 13 | wybrać model, który tłumaczy wszystkie fakty | mieszkalna (znane miejsce po zmianie) | zestawić trzy rodziny dowodu, przyjąć wniosek i zobowiązać się do poszukiwania | „gdzie jest miejscowa Lena?” | prawa (powrót do 14) / drzwi na klatkę | Station 21 | `ADAPT` |

### Metoda, koszt i zgoda

| # | Cel Leny | Rodzina | Działanie gracza | Zmiana pytania | Wejście / wyjście | Materiał legacy | Status |
|---|---|---|---|---|---|---|---|
| 14 | nauczyć się działania bez używania człowieka | techniczna/przemysłowa | utrzymać jeden stan martwego obwodu, ustąpić drugiemu, odwrócić próbę bezpiecznie | „czym płacę za utrzymanie jednej wersji?” | lewa / właz techniczny w dół (HATCH) | Station 22 + Station 23 | `ADAPT` |
| 15 | sprawdzić, czy sygnał odpowiada na celową zmianę | graniczna/anomalna | odtworzyć fragment próby z 20:40, wysłać trzy impulsy z jednym celowym błędem, odczytać notatkę z warunkiem przerwania | „czy ona odpowiada, czy to echo mojego urządzenia?” | właz / drabina serwisowa w górę | Station 26 + Station 27 + Station 33 | `ADAPT` |
| 16 | przenieść odpowiedź do bezpiecznego analizatora | graniczna/anomalna | oddać pamięć dzisiejszego zdania Marty albo 20:40:07 właściwego nośnika; odczytać echo domu | „co jeszcze stracę, jeśli będę próbować dalej?” | drabina / prawa | Station 28 + Station 35 | `ADAPT` |
| 17 | ustalić, kto już zapłacił i kto się zgadza | instytucjonalna | odczytać rejestr i ofertę; ustalić zakres; po prognozie wrócić po odpowiedź na jedną metodę | „kto poniósł koszt mojego bezpieczeństwa?” | lewa / prawa | Station 31 + Station 36 + Station 37 | `ADAPT` |
| 18 | wybrać metodę możliwą przy aktualnych zgodach | zewnętrzna/miejska (ulica z 05 po zmianie) | przynieść kopie z hali, poznać prognozy, wskazać propozycję, uzyskać odpowiedzi i zatwierdzić metodę | „którą wartość chronię i czyim kosztem?” | prawa (powrót na ulicę z 05) / przejście do wariantu finału | Station 30 + Station 38 + Station 39 | `ADAPT` |

### Konsekwencja i epilog

| # | Cel Leny | Rodzina | Działanie gracza | Zmiana pytania | Wejście / wyjście | Materiał legacy | Status |
|---|---|---|---|---|---|---|---|
| 42A | wykonać wymuszony powrót przybyłej Leny | finałowa/epilogiczna | przeprowadzić powrót i zobaczyć, kto zostaje zamknięty między adresami | „co zrobiłam drugiej mnie?” | z 18 / do 43 | Station 42A + Station 40 (impuls) + Station 41 (rozpoznanie) | `ADAPT` |
| 42B | oddać miejscowej Lenie jej ciało i zamknąć przepływ | finałowa/epilogiczna | rozpocząć odzyskanie → potwierdzić miejscową przy progu → zamknąć przepływ → odczytać utratę indeksu | „gdzie jestem teraz ja?” | z 18 / do 43 | Station 42B + Station 40 + Station 41 | `ADAPT` |
| 42C | pozwolić obu Lenom odpowiedzieć | finałowa/epilogiczna | otworzyć wzajemne przejście i przyjąć trwały przeciek pamięci | „co zostanie połączone na stałe?” | z 18 / do 43 | Station 42C + Station 40 + Station 41 | `ADAPT` |
| 43 | pokazać konsekwencję dla konkretnych osób | finałowa/epilogiczna | domknąć losy ustanowione w 42 i 43; pięć beatów bez wszechwiedzącego podsumowania | odpowiedź; brak nowego pytania | z 42X / credits | Station 43 | `ADAPT` |

---

## 4. Status materiału legacy 19–41

Każda stacja ma dokładnie jeden status. Zero pozycji `KEEP`: **żaden adres
19–41 nie przetrwał jako adres.**

| Stacja legacy | Tytuł źródłowy | Status | Dokąd trafia materiał / dlaczego znika |
|---|---|---|---|
| 19 | Głos | `ADAPT` | pytania kontrolne przez łącze → nowy 12 |
| 20 | Człowiek po tej dacie | `ADAPT` | spotkanie ciała i odmowa blizny → nowy 12 |
| 21 | Trzy źródła | `ADAPT` | jawna synteza i `world_recognized` → nowy 13 |
| 22 | Odchylenie w rejestrze | `ADAPT` | pierwszy kontakt Wierzbickiej i nazwanie Leny odchyleniem → nowy 14 (warstwa głosu) |
| 23 | Martwy obwód | `ADAPT` | dwa sprzeczne stany kontrolne jako lekcja Anchor/Yield → nowy 14 |
| 24 | Nie jesteś jej zastępstwem | `ADAPT` | granica Marty i odmowa roli zastępstwa → nowy 10 |
| 25 | Węzeł pod Linią 4 | `RETIRE` | korytarz dojścia bez własnego celu; zejście realizuje winda w nowym 14 |
| 26 | Przerwana próba | `ADAPT` | log 20:40 rozdzielony między próbę i procedurę UCP → nowy 15 |
| 27 | Trzy powtórzenia | `ADAPT` | negatywna kontrola echa i sprawcza odpowiedź → nowy 15 |
| 28 | Cena małego wyniku | `ADAPT` | wybór utraty pamięci albo sekundy próbki → nowy 16 |
| 29 | Jakub mówi nie | `RETIRE` | powiela negocjację zgody z 37; jedna scena zgody na kampanię |
| 30 | Trzy prognozy | `ADAPT` | trzy metody i brakujące pola → nowy 18 |
| 31 | Oferta adaptacji | `ADAPT` | pokusa zapisania Leny jako mieszkanki Równi → nowy 17 |
| 32 | Pomieszczenie odpowiedzi | `RETIRE` | komora odtwarzająca własne kotwiczenia; system bez osoby i bez nowego faktu |
| 33 | Notatki z warunkiem przerwania | `ADAPT` | zamiar i warunek abortu miejscowej Leny → nowy 15 |
| 34 | Rozdzielenie | `RETIRE` | rozdzielenie zespołu jako czysty koszt trasy, bez własnej decyzji |
| 35 | Dom bez niej | `ADAPT` | echo domu potwierdzające, że jej tam nie ma → nowy 16 |
| 36 | Para katastrof | `ADAPT` | rejestr par kosztów Linii 4 → nowy 17 |
| 37 | Życie nie jest długiem | `ADAPT` | jawny zakres zgody Jakuba → nowy 17 |
| 38 | Marta nie przyjmuje legendy | `ADAPT` | stan prawdy przekazanej Marcie → nowy 18 |
| 39 | Stół zgód i braków | `ADAPT` | zestawienie metod, zgód i braków → nowy 18 |
| 40 | Ostatni impuls | `RETIRE` | wykonanie metody należy do aktu zatwierdzenia w 18 i do wariantu 42 |
| 41 | Trzy testy po działaniu | `RETIRE` | rozpoznanie skutku należy do wnętrza każdego wariantu 42, nie do wspólnej komory konsol |

Podsumowanie: `ADAPT` 17, `RETIRE` 6, `KEEP` 0.

`RETIRE` dotyczy **adresu i jego treści**. Nie zakazuje ponownego użycia
współdzielonego komponentu technicznego (`ServiceLift`, `LadderZone`,
`AnchorExclusivityController`), jeśli nowy adres realnie go potrzebuje.

### 4.1 Komponenty dawcy z runtime 19–41

Weryfikacja plików `scenes/levels/station_19..41.tscn` i
`scripts/levels/station_19..41.gd` wskazuje mechanizmy warte przeniesienia
niezależnie od numeru stacji. To jedyna dozwolona ścieżka reużycia: nazwany
komponent, nie rozszerzanie monolitów (R-042).

| Mechanizm dawcy | Źródło | Nowy adres | Po co |
|---|---:|---:|---|
| stół trzech slotów + jedna operacja scalająca (`execute_three_family_synthesis`) | 21 | 13 | jawna synteza zamiast checklisty |
| wybór granicy kierunkiem chodzenia (`_unhandled_input` + `move_left/right`) | 24 | 10 | decyzja bez menu, czytana z ruchu |
| wyłączność kotwicy z parą relayów (`AnchorExclusivityController`) | 23, 28 | 14, 16 | jedna aktywna kotwica i jawny reset aparatury |
| impuls kontrolny z celowym błędem (`send_deliberate_error_pulse`) | 27 | 15 | odróżnienie żywej odpowiedzi od echa |
| zgoda jako zapis po usunięciu przymusu (`disable_jakub_transmitter` → `record_jakub_consent`) | 29 | 17 | zgoda bez korekty i bez punktów |
| zobowiązanie z odroczoną aplikacją (`COMMITMENT_*,` stacja 28) | 28 | 16, 18 | koszt zatwierdzany świadomie |
| korekta świata z respawnem (`CHECKPOINT_POSITION` + `player.reset_to`) | 32, 33, 38 | 15, 16 | porażka jako korekta, nie game over |
| komparator trzech prognoz (`compare_forecast_consent_dependencies`) | 30 | 18 | wybór metody przy jawnych brakach |
| bezpieczna błędna próba z trwałym śladem (`disclose_own_theory`) | 19 | 12 | omylność bez blokady postępu |
| `ServiceLift` (travel 85–90 px) | 25, 34 | — (w 14 niezrealizowana; zejście to właz HATCH, PKG-0230 P2-1) | realny pion bez platformingu |
| `LadderZone` (90–100 px) | 30, 32, 37 | 02, 15 | realny pion bez platformingu |
| diegetyczny tor `DIALOGUE_LINES` + `advance_dialogue` | 39, 40, 41 | 10, 13, 17, 18 | rozmowa prowadzona przez gracza |

Nie przenosimy: wspólnego szkieletu `Props` = 4–5 `Area2D` z
`memory_resonance_point.gd`, jednego layoutu `Geometry` (podłoga 640×80,
ściany x=-10/650) ani `VectorStageEnvironment` jako autora wyglądu wszystkich
rodzin. To jest dokładnie ten dług, który tworzy nierozróżnialne lokacje.

## 5. Los materiału legacy 01–18

Slot sceniczny zostaje, treść zostaje ponownie napisana. Tabela pokazuje, gdzie
kończy się dawna treść.

| Stacja legacy | Dawna treść | Trafia do |
|---|---|---|
| 01 | ostatni odczyt | nowy 01 |
| 02 | obejście serwisowe | nowy 02 |
| 03 | wiadomość Marty | nowy 03 |
| 04 | przejazd | nowy 04 |
| 05 | znana ulica | nowy 05 (baseline) i nowy 18 (to samo miejsce po zmianie) |
| 06 | dwa rozkłady | nowy 06 |
| 07 | herbata dla Marty | nowy 06 |
| 08 | numer czternaście | nowy 07 |
| 09 | znajoma sąsiadka | nowy 08 |
| 10 | klucz | nowy 08 |
| 11 | dwie osoby na zdjęciu | nowy 09 |
| 12 | wiadomość głosowa | nowy 10 |
| 13 | dwie ważne wersje | nowy 09 |
| 14 | próg Marty | nowy 10 |
| 15 | ta sama wyprawa, inny skutek | nowy 10 |
| 16 | zespół UCP-4 | nowy 11 |
| 17 | nie powtarzać próbki | nowy 11 |
| 18 | brak aktu zgonu | nowy 11 |

---

## 6. Traceability faktów kanonicznych

Wszystkie 33 flagi z `CONTINUITY_TRACKER.md` §13 przeżywają skrócenie trasy.
Zmienia się wyłącznie **adres powstania**. Żaden fakt nie jest kasowany, więc
migracja zapisu w PHASE-06 jest tabelą re-origination, nie utratą danych.

| Flaga | Adres legacy | Nowy adres | Działanie, które ją tworzy | Wypłata |
|---|---:|---:|---|---|
| `home_sample_preserved` | 01 | 01 | tylko droga `repeat_sample`: zabezpieczenie surowego nośnika; `leave_on_time` zapisuje `false` | warunek dowodu `recognition_evidence_carried` albo jawny brak próbki |
| `marta_promise_broken` | 03–04 | 03 | `true` po powtórce, `false` po spakowaniu sprzętu na czas | ton relacji w 10 |
| `ordinary_return_complete` | 05 | 05 | dojście znaną ulicą bez przeszkody | baseline porównania w 18 |
| `unease_pattern_started` | 06 | 06 | porównanie dwóch aktualnych źródeł | otwarcie śledztwa |
| `local_address_confirmed` | 10 | 08 | przekręcenie klucza w zamku 14 | wejście do 09 |
| `conflicting_documents_found` | 13 | 09 | porównanie dwóch wersji dokumentu | dowód publiczny |
| `marta_relationship_disclosed` | 11–14 | 10 | wysłuchanie dwóch wersji dnia | dowód relacyjny |
| `marta_memories_conflict` | 15 | 10 | pytanie o konkret nie do odgadnięcia | dowód relacyjny |
| `marta_boundary_accepted` | 24 | 10 | przyjęcie granicy Marty bez nacisku | warunek współpracy w 18 |
| `local_lena_ucp_profile_found` | 16 | 11 | przejście biometryki mimo obcej karty | dowód publiczny |
| `parallel_test_trace_found` | 17 | 11 | skopiowanie minimalnego zakresu raportu | wejście w drugą tajemnicę |
| `jakub_public_history_verified` | 18 | 11 | odczyt dwóch niezależnych rejestrów | warunek 12 |
| `jakub_voice_heard` | 19 | 12 | dwa pytania kontrolne przez łącze | warunek spotkania |
| `jakub_met_as_person` | 20 | 12 | spotkanie i przyjęcie odmowy | dowód relacyjny |
| `recognition_evidence_public` | 18–21 | 11 | komplet zapisów instytucjonalnych | wejście do syntezy |
| `recognition_evidence_relational` | 20–21 | 12 | żywy Jakub i różnica wspomnień | wejście do syntezy |
| `recognition_evidence_carried` | 20–21 | 13 | wyłożenie domowego nośnika na stół | wejście do syntezy |
| `world_recognized` | 21 | 13 | jawna synteza trzech rodzin dowodu | koniec pierwszej tajemnicy |
| `local_lena_search_committed` | 21 | 13 | zadeklarowanie nowego celu | początek drugiej tajemnicy |
| `anchor_yield_named` | 22 | 14 | wykonanie obu zachowań przed ich nazwaniem | język metody |
| `mechanic_cost_observed` | 23 | 14 | obserwacja lokalnego kosztu martwego obwodu | uczciwa cena w 16 |
| `ucp_intervention_reconstructed` | 26 | 15 | rekonstrukcja logu 20:40 | motyw działania UCP |
| `local_lena_signal_confirmed` | 27 | 15 | trzeci impuls z celowym błędem | sprawczość miejscowej Leny |
| `local_lena_intent_found` | 33 | 15 | odczyt warunku przerwania | odpowiedzialność bez winnego |
| `small_cost_manifested` | 28 | 16 | wybór, co traci ostrość | realna cena metody |
| `home_echo_verified` | 35 | 16 | potwierdzenie echa domu | wykluczenie prostego swapu |
| `ucp_cost_ledger_found` | 36 | 17 | odczyt rejestru par Linii 4 | rachunek instytucji |
| `jakub_consent_state` | 29/37 | 17 | negocjacja jawnego zakresu | dostępność metod w 18 |
| `route_hypotheses_mapped` | 30 | 18 | zestawienie trzech prognoz | świadomy wybór |
| `marta_truth_state` | 38 | 18 | powiedzenie Marcie prawdy lub jej części | jakość finału |
| `method_committed` | 39 | 18 | fizyczne zatwierdzenie jednej metody | routing 42A/B/C |
| `ending_family` | 41–42 | 42A/B/C | wykonanie metody | rodzina konsekwencji |
| `ending_stability` | 41–43 | 42A/B/C, 43 | stan zgód, kosztów i śladów | jakość epilogu |

Reguły zapisu pozostają bez zmian: `world_recognized` nie powstaje z wejścia do
sceny ani z jednego dialogu, a `method_committed` nie powstaje bez jawnego
zestawienia kosztów i aktualnych zgód.

---

## 7. Budżet interakcji

| Reguła | Wartość |
|---|---|
| istotne interakcje na adres | maksymalnie 3 |
| rodziny przeszkód na adres | maksymalnie 1 (`TRAVERSAL_AND_OBSTACLE_DESIGN.md` §6) |
| adresy bez przeszkody fizycznej | dozwolone: 05, 10, 13, 43 |
| adresy z pionem | 02 (drabina), 14 (właz HATCH, nie winda), 15 (drabina), 16 (drabina) |

Adres, który nie zmienia pytania gracza ani stanu relacji, jest wadliwy
i musi zostać scalony z sąsiadem albo usunięty.

## 8. Czego ta mapa nie dowodzi

Mapa jest kontraktem struktury. Nie dowodzi, że przebieg jest ciekawy,
zrozumiały ani emocjonalnie uczciwy dla nowej osoby (D-012, ADR-003). Dowód
odbiorczy nie istnieje w tym projekcie i nie wolno go symulować testem.
