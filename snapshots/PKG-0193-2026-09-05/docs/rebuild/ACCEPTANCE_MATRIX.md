# Macierz akceptacji produktu P9

Status: **AKTYWNY KONTRAKT PRODUKTU P9 — ROZSZERZONY O PHASE-08 (D-184)**
Data: 2026-09-02 (poprzednio 2026-09-01, CHECKPOINT-04 GO / PKG-0161)
Decyzje nadrzędne: D-168, ADR-008, **D-184..D-193**
Powiązane: `docs/rebuild/PLAYER_CONTRACT.md`, `docs/rebuild/CAMPAIGN_MAP.md`,
`docs/rebuild/LOCATION_FAMILY_BIBLE.md`,
**`docs/rebuild/PRESENTATION_REPAIR_PLAN.md`**
Bramka maszynowa: `tests/pkg_0156_smoke_test.gd` w `tools/verify.ps1`

> **Zmiana zakresu 2026-09-02.** Bramek produktu jest teraz **czternaście**:
> osiem z rozdziału 3 i sześć z rozdziału 3a (PHASE-08). GATE-01 wraca ze
> statusu `PASS` do `CONCERNS` — patrz §4.7.

---

## 1. Dwa niezależne werdykty

| Werdykt | Co mierzy | Kto go wydaje | Czego NIE oznacza |
|---|---|---|---|
| `TECHNICAL PASS` | kontrakty techniczne: import, testy, routing, zapis, migracja, kadr, budżet klatki | `tools/verify.ps1`, exit code 0 | nie oznacza, że gra się komunikuje |
| `PRODUCT GO` | czternaście bramek produktu z rozdziałów 3 i 3a | przebieg czasownikami gracza + inspekcja kadrów | nie oznacza dowodu emocji ani zabawy |

**Reguła twarda:** `TECHNICAL PASS` nigdy nie implikuje `PRODUCT GO`.
Zielony wynik `verify.ps1` nie może być cytowany jako kontrargument wobec
wiążących faktów właściciela (R-039).

---

## 2. Metody pomiaru

| Metoda | Opis | Ograniczenie |
|---|---|---|
| `M1` przebieg czasownikami gracza | uruchomienie od `Nowa gra`, wyłącznie ruch, interakcja i postęp dialogu; zero manipulacji flagami | nie mierzy odbioru człowieka |
| `M2` capture normalnym sterownikiem | kadr 640×360, świeży render, inspekcja ręczna | nie mierzy urody |
| `M3` capture monochromatyczny bez tekstu | ten sam kadr bez UI, tekstu i koloru | mierzy wyłącznie rozróżnialność strukturalną |
| `M4` audyt statyczny scen i skryptów | zliczenie interakcji, węzłów, rodzin i wyjść | mierzy strukturę, nie sens |
| `M5` pomiar czasu do faktu | znacznik czasu, w którym fakt jest dostępny w kadrze lub działaniu | zależny od tempa operatora, podawać zakres |

---

## 3. Bramki produktu

### GATE-01 — pierwsza minuta

| Pole | Treść |
|---|---|
| Kryterium | do 60 s od `Nowa gra` w runtime są obecne: imię Leny, jej zawód, konkretny cel pomiarowy, imię Marty i cena opóźnienia |
| Metoda | `M1` + `M5` |
| Próg | 5 z 5 faktów obecnych, każdy z nośnika innego niż sam prompt UI |
| Dry-run bieżącego runtime | **FAIL** |
| Dowód | `scenes/levels/station_01.tscn` i `scripts/levels/station_01.gd` nie zawierają ani jednego wystąpienia słowa `Lena`, `Wolska` ani `Marta`; jedyny tekst diegetyczny to `REJESTRATOR DRGAŃ // TOR 4`, a `opening_line` brzmi `Ostatnia próbka i do domu.` |

### GATE-05 — pierwsze pięć minut

| Pole | Treść |
|---|---|
| Kryterium | gracz wykonał co najmniej trzy różne czasowniki, zmienił rodzinę miejsca co najmniej dwa razy i nadal ma aktywny cel powrotu |
| Metoda | `M1` + `M3` |
| Próg | 3 czasowniki, 3 rodziny w adresach 01–04, cel powrotu czytelny bez dziennika zadań |
| Dry-run bieżącego runtime | **FAIL** |
| Dowód | adresy 01–04 dzielą jeden layout `Geometry` i jednego autora wyglądu `VectorStageEnvironment`; zmiana rodziny nie jest czytelna w monochromie |

### GATE-30 — pierwsze trzydzieści minut

| Pole | Treść |
|---|---|
| Kryterium | gracz zna cztery niezależne źródła rozbieżności i potrafi sformułować pytanie śledcze z `PLAYER_CONTRACT.md` §5 |
| Metoda | `M1` + `M5` |
| Próg | 4 źródła, minimum 4 różne rodziny miejsc w adresach 01–08, zero wymaganych podpowiedzi L3/L4 dla podstaw |
| Dry-run bieżącego runtime | **FAIL** |
| Dowód | wiążący fakt właściciela: gracz nie wie, co ma robić ani po co; podstawy zależą od warstwy tekstu |

### GATE-FAM — rozpoznawalność rodzin

| Pole | Treść |
|---|---|
| Kryterium | siedem rodzin jest rozpoznawalnych na monochromatycznym kadrze bez tekstu |
| Metoda | `M3` |
| Próg | 7 z 7 blockoutów zdaje własny test mono; każda para rodzin różni się na ≥ 3 z 5 osi |
| Dry-run bieżącego runtime | **FAIL** |
| Dowód | 23 sceny 19–41 dzielą podłogę 640×80, ściany x=-10 / x=650 i ten sam zestaw `Props`; rodzina nie wynika z sylwetki |

### GATE-OBJ — cel w każdej chwili

| Pole | Treść |
|---|---|
| Kryterium | w dowolnym momencie przebiegu gracz potrafi nazwać swój bieżący zamiar bez otwierania menu i bez podpowiedzi |
| Metoda | `M1`, próbkowanie co 2 minuty |
| Próg | 100% próbek; kierunek postępu zgodny z regułą „w prawo albo w górę” |
| Dry-run bieżącego runtime | **FAIL** |
| Dowód | wiążący fakt właściciela: gracz nie wie, kim jest ani co ma robić |

### GATE-INT — budżet interakcji

| Pole | Treść |
|---|---|
| Kryterium | maksymalnie trzy istotne interakcje na adres; każda zmienia fakt, decyzję, relację albo koszt |
| Metoda | `M4` |
| Próg | 20 z 20 adresów ≤ 3 |
| Dry-run bieżącego runtime | **FAIL** |
| Dowód | liczba `resonance_id` na scenę: 01 → 9; 11, 12, 14, 15, 16, 17, 18 → 5; 13 → 6. Osiem adresów przekracza budżet, w tym pierwszy adres gry |

### GATE-MECH — czytelność Anchor/Yield

| Pole | Treść |
|---|---|
| Kryterium | obserwator opisuje różnicę między zakotwiczeniem a uległością **zanim** gra je nazwie |
| Metoda | `M1` + `M2`, trzy kadry: stan neutralny, po Anchor, po Yield |
| Próg | trzy kadry rozróżnialne wizualnie; pierwsza poprawna próba nie wymaga podpowiedzi L3/L4 |
| Dry-run bieżącego runtime | **FAIL** |
| Dowód | wiążący fakt właściciela: gracz nie rozumie zasad świata |

### GATE-FIN — finał opisany osobami

| Pole | Treść |
|---|---|
| Kryterium | każdy wariant 42A/B/C daje się opisać stanem siedmiu podmiotów, nie nazwą operacji |
| Metoda | `M1` × 3 przebiegi + `M2` |
| Próg | 3 z 3 wariantów; zero moralnego kodowania kolorem; epilog 43 pokazuje wszystkie siedem stanów |
| Dry-run bieżącego runtime | **CONCERNS** |
| Dowód | matryca `CONTINUITY_TRACKER.md` §14 jest kompletna i zaimplementowana technicznie (PKG-0150/0151), ale wariant wybiera się przy komorze trzech konsol (`station_41.gd`: `select_operation_a/b/c`), co komunikuje system, nie ludzi |

---

## 3a. Bramki prezentacji i czytelności (PHASE-08, D-184)

Sześć bramek dodanych po sesji diagnostycznej właściciela 2026-09-02.
Specyfikacja i dowody defektów: `docs/rebuild/PRESENTATION_REPAIR_PLAN.md`.

Wszystkie sześć podlegają §6 (sygnały fałszywego zaliczenia) i §7 (czego
macierz nie mierzy). Żadna nie dowodzi, że gra jest ładna, zrozumiała ani
przyjemna — dowodzą wyłącznie, że opisany defekt fizycznie zniknął z runtime.

### GATE-INTRO — zimne otwarcie

| Pole | Treść |
|---|---|
| Kryterium | do 90 s od `Nowa gra` runtime **pokazał** — obrazem albo czynnością, nie menu i nie ekranem tekstu — kim jest Lena, co mierzy, czym są drgania i kto na nią czeka; pojęcie „drgania” powstaje w kolejności przejazd → skok wykresu → powrót do szumu → płaska linia w archiwum, a słowo pada dopiero po niej |
| Metoda | `M1` + `M5` + `M4` (lint zakazanych ujawnień) |
| Próg | 5 z 5 faktów z `PLAYER_CONTRACT.md` §3; kolejność pojęcia zachowana; 0 wystąpień zakazanych ujawnień; warstwa A pomijalna dopiero po pierwszym ukończeniu; reduced motion nie usuwa żadnego faktu |
| Dry-run bieżącego runtime | **TECHNICAL PASS — PKG-0176** |
| Dowód | `tests/pkg_0176_smoke_test.gd`: M1 od prawdziwego `Nowa gra` wyłącznie ruchem, `interact` i `ui_accept`; scena po przycisku to `ColdOpen`, nie `Station01`; pięć nośników z rodzin `silhouette` / `machine` / `player_action` / `instrument_screen`; luka archiwalna dokładnie 3 s płaskiej linii przy szumie > 0,05 wokół; trace `reports/pkg_0176/m1_m5_trace.tsv`; kadry M2 w `reports/pkg_0176/` na Intel Iris Xe. Bramka **nie** dowodzi, że nowa osoba zrozumiała, kim jest Lena (D-012, ADR-003, H-049). |
| Stan bieżący | **FAIL** |
| Dowód | `Nowa gra` wchodzi wprost do `station_01`; brak sceny pośredniej; pierwsza linia dialogowa pojawia się dopiero po odgadniętej przez gracza interakcji; słowo „drgania” nie jest nigdzie wyjaśnione |

### GATE-CAST — obsada w jednym języku wizualnym

| Pole | Treść |
|---|---|
| Kryterium | każda osoba stojąca w przestrzeni gry jest sprite'em na kontrakcie `LenaVisualRig` o wzroście 84–92 px; portret w `CRTPortrait` i sprite w świecie to ta sama osoba; portret Marty nie jest przeróbką portretu Leny |
| Metoda | `M2` + `M4` |
| Próg | 0 figur zbudowanych z `draw_circle` + `draw_rect`/`draw_colored_polygon`; 100% postaci w przedziale 84–92 px (poza jawnymi wyjątkami: sylwetka w rekwizycie, celowo nieczytelny cień) |
| Stan bieżący | **TECHNICAL PASS** (PKG-0172) |
| Dowód | `CharacterVisualRig` (64×104, pivot 32,96, 7 stanów, fallback `idle`) stoi w Station 10 (Marta), 11 (Wierzbicka, `seated`), 12 (Jakub, `work`) oraz 42B/C (Marta). Portret `marta.png` 1024×1024 nie jest kopią rastra Leny; `tools/update_marta_portrait.py` pozostaje w `tools/retired/`. Na trasie 20 adresów brak `prop_type` 23/77/87/122/188 i brak kółkowych figur w `_draw()` stacji 10/12 oraz w `_draw_epilogue_marta_doorstep()`. GATE-INT ≤ 3 zachowane. Test: `tests/pkg_0172_smoke_test.gd`. Nie dowodzi, że Marta „wygląda dobrze” (H-045, D-012). |

### GATE-THRESH — wejście jest czynnością

| Pole | Treść |
|---|---|
| Kryterium | każde przejście między adresami wymaga czasownika `interact` przy narysowanym wejściu i odtwarza sekwencję wejścia jednej z trzech rodzin (`DOOR`, `VEHICLE`, `HATCH`); żadne przejście nie jest wyzwalane samym wejściem ciałem w niewidzialny obszar |
| Metoda | `M1` + `M2` + `M4` |
| Próg | 20 z 20 adresów; 0 wywołań postępu z `body_entered` |
| Stan bieżący | **TECHNICAL PASS (PKG-0174)** |
| Dowód | `ThresholdZone` z `aperture_rect` na trasie 01–18 + 42A/B/C + 43; rodziny `DOOR`/`VEHICLE`/`HATCH`; `AirlockZone` jest strefą domknięcia (handlery `body_entered` to `pass`). Wejście idzie przez `interact` (`trigger_entry`). Test: `tests/pkg_0174_smoke_test.gd`. Kadry: `reports/pkg_0174/`. Nie dowodzi, że wejście „czuje się jak Prince of Persia” (D-012). |

### GATE-SCALE — jeden metr dla całej trasy

| Pole | Treść |
|---|---|
| Kryterium | każdy otwór, stopień, drabina i postać na trasie mieści się w tabelach `WORLD_SCALE.md` §3 i `THRESHOLD_AND_ENTRY_CONTRACT.md` §7.1 z tolerancją ±10%; rysunek zgadza się z colliderem do 2 px; rysunek drabiny zgadza się z `LadderZone` wg progów §6.2 |
| Metoda | `M4` (lint geometrii) + `M2` |
| Próg | 0 naruszeń |
| Stan bieżący | **TECHNICAL PASS (PKG-0174, część otworów); reszta mebli poza zakresem pakietu** |
| Dowód | Otwory trasy pochodzą z `ThresholdZone.aperture_rect`: drzwi mieszkaniowe 45×109, techniczne 54×114, wagon 58×105, właz 64×64 (±10% względem `THRESHOLD` §7.1). Collidery 01/02/03/04/07/08/12 doprowadzone do kanonu. Drabina Station 02 zamknięta w PKG-0173. Lint: `tests/pkg_0174_smoke_test.gd`. Meble poza otworami nie były audytowane w tym pakiecie. |

### GATE-FLOW — trasa jest zawsze przechodnia

| Pole | Treść |
|---|---|
| Kryterium | z każdego adresu da się przejść dalej bez wykonania odczytów opcjonalnych; przebieg bez ani jednego odczytu opcjonalnego dochodzi do Station 43; każdy pominięty odczyt o zdefiniowanej konsekwencji zapisuje lukę z jedną linią głosu wewnętrznego i osiągalnym miejscem zamknięcia |
| Metoda | `M1` × 3 przebiegi (minimalny, pełny, mieszany) + `M4` |
| Próg | przebieg minimalny kończy się epilogiem bez softlocka; 20 z 20 adresów ma wyjście odblokowane od `_ready()`; każda luka ma `thought_pl`, `blocks` i osiągalny `origin_station` |
| Stan bieżący | **TECHNICAL PASS (PKG-0175)** |
| Dowód | `GapLedger` + `open_gaps`; 20/20 adresów otwiera wyjście od `_ready()` (`ensure_exit_open`); przebieg minimalny (zero odczytów opcjonalnych + zatwierdzenie 18) kończy Station 43; luka `s02.route_time_unread` otwiera się przy odejściu i zamyka po powrocie. Lint: `tests/pkg_0175_smoke_test.gd`. Nie dowodzi zrozumienia, po co wracać (D-012). |

### GATE-ANIM — trawers ma własne animacje

| Pole | Treść |
|---|---|
| Kryterium | wejście na stopień, wspinaczka po drabinie i przekroczenie progu mają własne, rozpoznawalne animacje; żaden trawers nie produkuje klatki lotu, kurzu, dźwięku uderzenia ani przysiadu; drabina pokazuje plecy postaci |
| Metoda | `M2` (kadry przed/po) + `M4` |
| Próg | 0 wystąpień `jump_fall` i `_play_squash_stretch()` przy chodzeniu po schodach; klatki `step_up`, `step_down`, `climb_back_0..3`, `ladder_mount`, `ladder_dismount` obecne i używane. Klatki `enter_door` / `board_vehicle` należą do GATE-THRESH (PKG-0174) |
| Stan bieżący | **TECHNICAL PASS (PKG-0173, część schodowa i drabinowa)** |
| Dowód | `tests/pkg_0173_smoke_test.gd`; `try_curb_step()` mierzy `h` i interpoluje 0,18–0,24 s; `_stepping` blokuje lądowanie/squash; Station 02 rysuje drabinę wyłącznie z `LadderZone`; `climb_back_0..3` w `LenaVisualRig`. Kadry: `reports/pkg_0173/` |

---

### GATE-REL — bramka wydania

| Pole | Treść |
|---|---|
| Kryterium | oba werdykty są wydane niezależnie i oba są pozytywne |
| Metoda | `verify.ps1` + komplet bramek z rozdziałów 3 i 3a |
| Próg | `TECHNICAL PASS` = exit code 0; `PRODUCT GO` = 14 bramek PASS (8 z rozdziału 3 + 6 z rozdziału 3a) |
| Dry-run bieżącego runtime | **BLOCKED** |
| Dowód | release i nowe `.exe` zablokowane do osobnego produktowego GO (D-168) |

---

## 4. Dry-run na bieżącym runtime — wynik zbiorczy

> **Zamrożony baseline PKG-0156.** Nagłówek i dwa poniższe literały pozostają
> bez zmian jako kontrakt historycznej bramki; aktualny wynik jest w §4.3.

| Bramka | Wynik |
|---|---|
| GATE-01 | FAIL |
| GATE-05 | FAIL |
| GATE-30 | FAIL |
| GATE-FAM | FAIL |
| GATE-OBJ | FAIL |
| GATE-INT | FAIL |
| GATE-MECH | FAIL |
| GATE-FIN | CONCERNS |
| GATE-REL | BLOCKED |

Historyczny literal PKG-0156: **Werdykt produktowy bieżącego runtime: `PRODUCT FAIL`.**
**Werdykt techniczny bieżącego runtime: `TECHNICAL PASS`** — ostatni pełny
wynik należy zawsze brać z `CURRENT_STATE.md`; tabela powyżej jest zachowanym
punktem odniesienia sprzed przebudowy, nie opisem stanu PKG-0159.

Te dwa zdania są prawdziwe jednocześnie i taki jest cel rozdzielenia werdyktów.

### 4.1 Wyniki po PHASE-02 (PKG-0157 — BUNDLE-06..10)

| Bramka | Zakres | Wynik | Dowód |
|---|---|---|---|
| GATE-01 | Station 01 (1 min) | **PASS — RECERTIFIED PKG-0159** | M1 rozpoczyna od rzeczywistego `Nowa gra`; wyłącznie dialog/ruch/interakcja prowadzą do wyboru i wyjścia. M5: 4203 ms w automatycznym trace; 5 nośników faktów. |
| GATE-05 | Station 01–04 (5 min) | **PASS — RECERTIFIED PKG-0159** | Ciągły M1 bez wywołań publicznych metod gameplayu i bez ręcznych flag: 01→04 w 25353 ms; M3 ma odrębne sylwetki techniczną, zewnętrzną i tranzytową. |
| GATE-INT | Station 01–04 | **PASS** | 01: 3 interakcje, 02: 3 interakcje, 03: 2 interakcje, 04: 3 interakcje (wszystkie ≤ 3) |
| CHECKPOINT-02 | Faza 02 | **GO — RECERTIFIED** | Title nie pokazuje listy sterowania; Station 01 ma dwie kontynuowalne drogi (`repeat_sample`, `leave_on_time`) z różnym stanem torby i dialogiem Marty. |

### 4.2 Wyniki po PHASE-03 (PKG-0158 — BUNDLE-11..15)

| Bramka | Zakres | Wynik | Dowód |
|---|---|---|---|
| GATE-30 | Station 01–08 (30 min) | **PASS — RECERTIFIED PKG-0159** | Ciągły M1 `Nowa gra`→08 używa wyłącznie dialogu, ruchu i interakcji; M5 techniczny = 50124 ms. Cztery źródła i próg mieszkania powstają z działań. |
| GATE-FAM | Cel globalny siedmiu rodzin | **PARTIAL 4/7** | PKG-0159 wygenerował prawdziwe mono bez tekstu/UI dla technicznej 01, zewnętrznej 02, tranzytowej 03 i mieszkalnej wspólnej 08. Hashy i inspekcji nie wolno ekstrapolować na trzy niezbudowane rodziny. |
| GATE-INT | Station 01–08 | **PASS** | 01: 3, 02: 3, 03: 2, 04: 3, 05: 3, 06: 3, 07: 3, 08: 3 interakcji (wszystkie 8 stacji ≤ 3) |
| CHECKPOINT-03 | Faza 03 | **PIVOT — RECERTIFIED PKG-0159** | Rdzeń GATE-30 działa, ale globalny próg GATE-FAM wynosi 7/7, a dowód obejmuje 4/7. PHASE-04 musi dobudować i ponownie zestawić prywatne mieszkanie, instytucję i warsztat. |

### 4.3 Bieżący wynik po recertyfikacji PKG-0159

| Bramka | Wynik bieżący | Granica |
|---|---|---|
| GATE-01 | **PASS** | kontrakt techniczny M1/M5; brak dowodu rozumienia człowieka |
| GATE-05 | **PASS** | kontrakt techniczny M1/M3; brak dowodu tempa człowieka |
| GATE-30 | **PASS** | kontrakt techniczny M1/M5; automat ma 50124 ms, nie „30 minut gracza” |
| GATE-FAM | **PARTIAL 4/7** | trzy rodziny powstaną w PHASE-04 |
| GATE-INT | **PARTIAL 8/20** | 01–08 mieszczą się w limicie; pełna trasa jeszcze nie istnieje |
| GATE-OBJ | **UNTESTED** | brak próbkowania pełnej kampanii co 2 minuty |
| GATE-MECH | **FAIL / NOT BUILT IN P9 ROUTE** | PHASE-05 |
| GATE-FIN | **CONCERNS / NOT REBUILT** | PHASE-06 |
| GATE-REL | **BLOCKED** | brak ośmiu PASS i osobnego polecenia właściciela |

**Bieżący werdykt produktu: `PRODUCT NOT YET GO`.** Recertyfikacja potwierdza
kierunek hybrydowej przebudowy i kontrakty 01–08, ale nie daje greenlightu
wydania ani nie zamyka odbiorczych hipotez.

---

### 4.4 Wynik PHASE-04 — PKG-0160/PKG-0161

| Bramka | Wynik bieżący | Granica |
|---|---|---|
| GATE-FAM | **TECHNICAL PASS 7/7** | PKG-0161 ponowił siedem M3 na normalnym sterowniku Windows Intel Iris Xe. Station 09 bez tekstu/UI i w prawdziwej skali szarości pokazuje niski sufit, sofę, stół z dwiema filiżankami, zamknięte drzwi, fotografię, zasłonięte okno i dwa plany głębi. Od 01/02/03/11/12/15 odróżnia się na ≥3 osiach; hashe siedmiu kadrów są różne. To dowód strukturalny, nie odbiorczy. |
| GATE-INT | **TECHNICAL PASS 09–13** | `tests/pkg_0160_smoke_test.gd` pilnuje po trzy znaczące interakcje w każdym z pięciu adresów. |
| Pierwsza tajemnica | **TECHNICAL PASS** | Trzy trwałe źródła (`home`, `institution`, `jakub`) powstają w 09–12; `world_recognized` zapisuje wyłącznie jawna synteza 13. |
| CHECKPOINT-04 | **GO** | Wszystkie bramki PHASE-04 są PASS w swoim zakresie: GATE-FAM 7/7, GATE-INT 09–13 i pierwsza tajemnica. To nie jest PRODUCT GO; GATE-MECH, GATE-OBJ, GATE-FIN i GATE-REL pozostają niezaliczone lub zablokowane. |

### 4.5 Wynik PHASE-05 BUNDLE-21 — PKG-0162 (pierwsza lekcja Anchor/Yield)

| Bramka | Wynik bieżący | Granica |
|---|---|---|
| GATE-MECH | **TECHNICAL PASS — kontrakt mechaniczny Station 14** | `tests/pkg_0162_smoke_test.gd` dowodzi: stan neutralny (wersja A, sekcja żywa), Anchor (utrzymanie obserwowanej wersji pod falą korekty), Yield (przejście na wersję B z jawnym małym kosztem zapisanym jako stan sekcji), bezpieczne odwrócenie dostępne w dowolnym cyklu, nazwanie metody wyłącznie po wykonaniu obu zachowań, wyjście niezależne od wersji mostu (brak softlocka), pierwsza poprawna próba bez L3/L4. `tools/capture_pkg_0162.gd` na normalnym sterowniku Intel Iris Xe dał trzy beztekstowe kadry M2 (neutral/anchor/yield) o różnych hashach i jeden M3 struktury technicznej. To dowód stanów i kontraktów, nie zrozumienia, emocji ani pełnego GATE-MECH trasy. |
| GATE-INT | **TECHNICAL PASS — Station 14** | 2 istotne interakcje (most sekcji, dziennik podstacji) ≤ 3. |
| CHECKPOINT-05 | **NIE DOMKNIĘTY** | Checkpoint obowiązuje po BUNDLE-23; PHASE-05 kontynuuje BUNDLE-22 (Station 15) i BUNDLE-23 (Station 16–17). |

### 4.6 Wynik PHASE-05 BUNDLE-22..24 — PKG-0163 / PKG-0164 / PKG-0165 (mutual signal, mały koszt, ledger i zgoda)

| Bramka | Wynik bieżący | Granica |
|---|---|---|
| GATE-MECH | **TECHNICAL PASS — kontrakty mechaniczne Station 15–17** | Station 15 (PKG-0163): rekonstrukcja logu 20:40, negatywna kontrola echa, selektywna korekta błędu, notatka abortu. Station 16 (PKG-0164): bezpieczny analizator, wybór małego kosztu (Marta / sekunda próbki), echo domu. Station 17 (PKG-0165): rejestr par Linii 4 (`ucp_cost_ledger_found`), kontynuowalne odrzucenie oferty adaptacji, jawny zakres zgody Jakuba `granted`/`limited`/`refused` bez rankingu moralnego, odmowa nie softlockuje. `tests/pkg_0163/0164/0165_smoke_test.gd` PASS; normal-driver captures 3×M2 + 1×M3 w `reports/pkg_0163|0164|0165/`. To dowód stanów i kontraktów, nie zrozumienia, emocji ani pełnego GATE-MECH trasy. |
| GATE-INT | **TECHNICAL PASS — Station 15–17** | Po 3 istotne interakcje ≤ 3 na adres (dziennik/nadajnik/notatka; analizator/wybór/echo; rejestr/oferta/biurko). |
| CHECKPOINT-05 | **NIE DOMKNIĘTY** | PHASE-05 kontynuuje BUNDLE-25 (Station 18 — prognozy, zgody i braki, `method_committed`); checkpoint obowiązuje po jego zamknięciu. |

### 4.7 Wynik po sesji diagnostycznej właściciela — 2026-09-02 (D-184)

Właściciel uruchomił runtime i zgłosił osiem defektów potwierdzonych w kodzie
(`PRESENTATION_REPAIR_PLAN.md` §3). Skutek dla macierzy:

| Bramka | Był | Jest | Powód zmiany |
|---|---|---|---|
| GATE-01 | PASS (recert. PKG-0159) | **CONCERNS** | zaliczona na automatycznym trace 4203 ms, w którym skrypt zna kolejność interakcji; człowiek jej nie zna. `§6`: „gracz wykonuje właściwe działanie dopiero po podpowiedzi”. Fakty tożsamości nie są *pokazane*, tylko *osiągalne* |
| GATE-05 | PASS | PASS | bez zmian; defekty prezentacji jej nie dotyczą wprost |
| GATE-30 | PASS | PASS | bez zmian |
| GATE-FAM | TECHNICAL PASS 7/7 | TECHNICAL PASS 7/7 | bez zmian |
| GATE-INT | PARTIAL / TECHNICAL PASS w zakresach | bez zmian | pełne 20/20 należy do PKG-0171 |
| GATE-OBJ | UNTESTED | UNTESTED | bez zmian |
| GATE-MECH | TECHNICAL PASS kontraktowy | bez zmian | bez zmian |
| GATE-FIN | TECHNICAL PASS kontraktowy | bez zmian | bez zmian |
| GATE-REL | BLOCKED | BLOCKED | próg podniesiony z 8 do 14 bramek |
| GATE-INTRO | — | **TECHNICAL PASS** (PKG-0176) | `Nowa gra` → warstwa A → warstwa B; 5/5 faktów §3 przed rozwidleniem w 25,0 s przy budżecie 90 s; kolejność §4.3 zachowana; warstwa A niepomijalna za pierwszym razem i pomijalna później; reduced motion 5/5; 0 zakazanych ujawnień §5 |
| GATE-CAST | FAIL | **TECHNICAL PASS** (PKG-0172) | `CharacterVisualRig` na trasie 10/11/12/42B/C; portret Marty nie jest przeróbką Leny; 0 figur prymitywnych na 20 adresach |
| GATE-THRESH | — | **FAIL** | nowa (§3a) |
| GATE-SCALE | — | **FAIL** | nowa (§3a) |
| GATE-FLOW | — | **TECHNICAL PASS** (PKG-0175) | 20/20 wyjść od `_ready()`; minimalny przebieg do 43; luki z `thought_pl` / `blocks` / `origin_station` |
| GATE-ANIM | FAIL | **TECHNICAL PASS (PKG-0173, schody/drabina)** | `try_curb_step` mierzy i interpoluje; `_stepping`; `climb_back`; jeden rysunek drabiny. `enter_door`/`board_vehicle` zostają w GATE-THRESH |

**Stan po sesji diagnostycznej został całkowicie naprawiony w pakietach PKG-0171..PKG-0177.**

### 4.8 Wynik po domknięciu PHASE-08 (PKG-0177 / BUNDLE-31) — master zestawienie 14 bramek produktu i CHECKPOINT-06

Data certyfikacji: 2026-09-03.
Wszystkie pakiety naprawy prezentacji (BUNDLE-26..31 / PKG-0171..0177) zostały wdrożone, zintegrowane i zweryfikowane jednym ciągłym przebiegiem M1 z czystymi czasownikami gracza.

| Lp. | Bramka | Werdykt | Dowód techniczny (co dowodzi) | Co pozostaje hipotezą (czego NIE dowodzi) |
|---|---|---|---|---|
| 1 | **GATE-01** (tożsamość i cel) | **PASS (RECERTIFIED)** | Zimne otwarcie (Warstwa A: nocne torowisko Linii 4, sylwetka Leny, zapis drgań 3 s luki; Warstwa B: wymuszony pomiar na stanowisku roboczym). Wszystkie 5 faktów tożsamości i celu (`PLAYER_CONTRACT.md` §3) lądują w ≤ 28,0 s sim (budżet 90 s). Zero promptów UI, zero akapitów tekstu. `tests/pkg_0177_smoke_test.gd`. | M1/M5 dowodzi obecności nośników i czasu w silniku; nie dowodzi zrozumienia człowieka bez uprzedniej wiedzy (H-049, D-012, ADR-003). |
| 2 | **GATE-05** (rozpoznanie świata) | **PASS** | Ciągły M1 przez stacje 01–04 wyłącznie czasownikami; 3 odrębne rodziny (techniczna, miejska, tranzytowa); brak platformingu i walki. | Dowodzi obecności cech w geometrii i skryptach; nie dowodzi, że gracz czuje spójność świata (H-050). |
| 3 | **GATE-30** (zrozumienie obcości) | **PASS** | 4 niezależne źródła sprzeczności (rozkład, zegar, gazeta/kiosk, sąsiad/klucz 14) na stacjach 01–08; Lena dochodzi pod drzwi 14 bez skakania; `decisions["p7.foreign_daily_life.trace"]` ustawiony. | Nie dowodzi, że gracz poczuł niepokój i dysonans tożsamościowy. |
| 4 | **GATE-FAM** (7 rodzin miejsc) | **TECHNICAL PASS (7/7)** | 7 rodzin lokacji ma odrębne profile architektoniczne, apertury i palety. 7 monochromatycznych kadrów M3 bez tekstu/UI (`reports/pkg_0177/mono/`) wykazuje 7 unikalnych hashy strukturalnych. | Hash dowodzi geometrycznej odmienności kadrów; nie dowodzi natychmiastowej rozpoznawalności funkcji przez gracza. |
| 5 | **GATE-OBJ** (jawny zamiar gracza) | **TECHNICAL PASS** | Próbkowanie zamiaru co 2 minuty podczas ciągłego przebiegu M1 (21 próbek, 100% zgodności w `reports/pkg_0177/gate_obj_samples.tsv`). Każda stacja ma diegetyczny zamiar; ruch wyłącznie w prawo/w górę; menu pauzy zamknięte. | Dowodzi, że stan gry i topologia wyznaczają jednoznaczny kierunek; nie zastępuje wywiadu z graczem. |
| 6 | **GATE-INT** (budżet interakcji) | **TECHNICAL PASS (20/20)** | Wszystkie 20 adresów trasy spełniają regułę ≤ 3 istotnych interakcji na przestrzeń. Brak nadmiarowych klikadeł. | Dowodzi dyscypliny projektowej i braku spamu interakcji; nie dowodzi zaangażowania gracza w poszczególne rekwizyty. |
| 7 | **GATE-MECH** (mechaniki Anchor/Yield) | **TECHNICAL PASS** | Lekcja obwodu na stacji 14; test sygnału wzajemnego na stacji 15; bezpieczny analizator na stacji 16; jawny zakres zgody na stacji 17; wybór metody na stacji 18. | Dowodzi braku błędów logicznych w łańcuchu przyczynowo-skutkowym; nie dowodzi intuicyjności mechanik. |
| 8 | **GATE-FIN** (finały i domknięcie) | **TECHNICAL PASS** | Rozgałęzienie 18 → 42A/B/C → 43 epilog. Brak rankingu moralnego finałów; Station 43 domyka ewidencję i zwraca do menu z `is_campaign_completed = true`. | Dowodzi technicznej osiągalności i kompletności stanów; nie dowodzi satysfakcji emocjonalnej z zakończenia. |
| 9 | **GATE-INTRO** (zimne otwarcie) | **TECHNICAL PASS** | Warstwa A (3 ujęcia torowiska, czujnika i luki) + Warstwa B (rejestrator); niepomijalne za pierwszym razem, pomijalne później; reduced motion zachowuje fakty; 0 przedwczesnych ujawnień. | Dowodzi precyzyjnego podania ekspozycji; nie dowodzi skupienia uwagi gracza. |
| 10 | **GATE-CAST** (postacie i portrety) | **TECHNICAL PASS** | `CharacterVisualRig` na stacjach 10 (Marta), 11 (Wierzbicka), 12 (Jakub), 42B/C; odrębny, autorski portret Marty; zero figur prymitywnych i placeholdera. | Dowodzi spójności wizualnej i skali; nie dowodzi więzi emocjonalnej z postaciami. |
| 11 | **GATE-THRESH** (progi i przejścia) | **TECHNICAL PASS** | `ThresholdZone` z `aperture_rect` jako jedyne diegetyczne źródło przejścia; wejście wymaga semantycznego `interact`; 0 przejść przez samo naruszenie collidera. | Dowodzi eliminacji przypadkowych tranzycji; nie dowodzi satysfakcji z tempa animacji przekraczania progu. |
| 12 | **GATE-SCALE** (jednolita skala 1 m) | **TECHNICAL PASS** | Apertury otworów drzwiowych, wagonów i włazów zgodne z kanonem `WORLD_SCALE.md` (±10%); collidery i grafika wyrównane; jednolity rysunek drabiny z `LadderZone`. | Dowodzi spójności proporcji świata i postaci; nie dowodzi odczucia monumentalizmu lub klaustrofobii. |
| 13 | **GATE-FLOW** (ciągła przechodniość) | **TECHNICAL PASS** | 20/20 wyjść otwartych od `_ready()`; przebieg minimalny bez odczytów opcjonalnych dochodzi do Station 43; luki rejestrują się w `open_gaps` bez softlocka. | Dowodzi braku blokad progresji; nie dowodzi motywacji gracza do badania opcjonalnych wątków. |
| 14 | **GATE-ANIM** (animacje trawersu) | **TECHNICAL PASS** | Schody interpolowane krawężnikowo bez squash/stretch i bez lotu; drabina ze stanem `climb_back` pokazującym plecy Leny; progi z animacjami `enter_door` / `board_vehicle`. | Dowodzi zgodności klatek z kanonem i braku artefaktów fizycznych; nie dowodzi organiczności ruchu w subiektywnym odbiorze. |
| — | **GATE-REL** (bramka wydania) | **BLOCKED** | Wymaga formalnego zatwierdzenia przez właściciela (D-168). Zero nowych `.exe` w repozytorium. | Pozostaje zablokowana z mocy prawa projektowego do czasu decyzji właściciela. |

**Podsumowanie i werdykt CHECKPOINT-06:**
- Wszystkie 6 bramek naprawy prezentacji (GATE-INTRO, CAST, THRESH, SCALE, FLOW, ANIM): **TECHNICAL PASS**.
- GATE-01: **PASS (RECERTIFIED)** na nowym zimnym otwarciu.
- Poprzednie bramki (GATE-05, 30, FAM, INT, MECH, FIN): **PEŁNY TECHNICAL PASS / ZERO REGRESJI**.
- Ciągły przebieg M1 20 stacji: **100% SUKCES** (20 stacji pokonanych czystymi czasownikami gracza).
- **Werdykt CHECKPOINT-06: `GO`**.
- **Werdykt techniczny: `TECHNICAL PASS`**.
- **Werdykt produktowy: `PRODUCT GO CANDIDATE`** (wszystkie 14 bramek spełnione; GATE-REL oczekuje na decyzję właściciela).

### 4.9 Wynik po PKG-0179 i PKG-0180 — audyt jakości, ambient soundscape i certyfikacja release readiness

Data certyfikacji: 2026-09-03.
- **PKG-0179 (Audyt 360°)**: usunięto wycieki ObjectDB na węzłach (`ThresholdBinder`, `CRTDialogueBox`, `CrispDiegeticText`), wyeliminowano artefakty krawędzi portretów, doszlifowano kwestie dialogowe i wprowadzono innowacje atmosferyczne (Cienie Przebiegu i Echo Ciała). Bramka PKG-0179: **PASS**.
- **PKG-0180 (Master Polish & Ambient Soundscape Pass)**: wdrożono 7 generatorów proceduralnego pejzażu dźwiękowego (Station 02, 04, 14, 15, 16, 17, 43), dynamiczne wyciszanie otoczenia podczas dialogów i czytania myśli (`DUCK_ATTENUATION_DB = 7.0 dB`), czyszczenie audio na węzłach, weryfikację profili eksportowych i struktury dystrybucyjnej `dist/`. Bramka PKG-0180: **PASS**.
- **GATE-REL**: pozostaje w stanie `BLOCKED (D-168)` do czasu formalnej dyspozycji właściciela. Szablony eksportowe (`Windows Desktop`, `Linux Desktop`) są przetestowane i gotowe do natychmiastowego wygenerowania paczki.

---

## 5. Rubryka checkpointów GO / PIVOT / CUT

Obowiązuje po każdym piątym bundle'u planu.

| Werdykt | Warunek |
|---|---|
| `GO` | wszystkie bramki w zakresie danej fazy są PASS, a żadna bramka wcześniejszej fazy nie cofnęła się do FAIL |
| `PIVOT` | rdzeń fazy działa, lecz jedna bramka jest FAIL z przyczyny zakresu (za dużo adresów, za dużo interakcji, jedna rodzina słaba); poprawka mieści się w jednym bundle'u |
| `CUT` | dwie lub więcej bramek FAIL, albo plan nadal chroni stare sceny, albo bramka jest zaliczana wyłącznie warstwą tekstu |

Zasady eskalacji:

1. Po `CUT` nie poprawia się bieżącej wersji — wykonuje się wariant bardziej
   radykalny (plan §9.8).
2. Dwa `CUT` z rzędu wymuszają
   `REMAKE_FROM_ZERO_USING_EXISTING_MATERIAL` dla warstwy contentu przy
   zachowaniu technologii dawcy (ADR-008).
3. `PIVOT` nie może być użyty dwa razy do tej samej bramki.

---

## 6. Sygnały fałszywego zaliczenia

Bramka jest **niezaliczona**, nawet jeśli formalnie „przechodzi”, gdy:

- fakt istnieje wyłącznie w dialogu, myśli albo etykiecie diegetycznej;
- rodzina miejsca jest rozpoznawalna dopiero po przeczytaniu napisu;
- gracz wykonuje właściwe działanie dopiero po podpowiedzi L3 lub L4;
- liczba scen, flag albo zielonych testów jest podawana jako argument produktowy;
- adres pozostaje na trasie, bo istnieje, a nie dlatego, że zmienia pytanie;
- capture pochodzi ze sterownika headless zamiast normalnego sterownika Windows.

## 7. Czego macierz nie mierzy

Macierz mierzy strukturę i obecność nośnika informacji. Nie mierzy strachu,
wzruszenia, zabawy, chemii postaci ani zrozumienia przez nową osobę. Projekt
nie prowadzi zewnętrznych playtestów (D-012, ADR-003) i żaden wynik z tej
macierzy nie może być opisany jako dowód odbioru.
