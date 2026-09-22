# Ryzyka, hipotezy i przewidywania

Status: **ŻYWY REJESTR P9 PO D-168 / ADR-008**  
Data: 2026-09-04 (PKG-0190)

Implementacja, zielony test, audyt narracyjny i pojedynczy render nie zamieniają
intuicji o odbiorze w fakt. Model dowodu określa ADR-003: zewnętrzne playtesty
pozostają odłożone do końca produkcji, więc pytania o emocje są jawnie otwarte.

## Klasy dowodu

- `MIERZALNA` — może zostać rozstrzygnięta pomiarem, audytem tekstu, renderu lub
  testem automatycznym.
- `ODBIORCZA` — wymaga reakcji nowej osoby; obecnie pozostaje bez bezpośredniego
  dowodu.
- `KOSZTOWA` — wymaga zmierzonego czasu, wydajności albo budżetu.

## Statusy

- `UNTESTED` — brak wystarczającego dowodu;
- `TECHNICAL` — kontrakt działa technicznie, nie dowodzi doświadczenia;
- `MEASURED` — mierzalna hipoteza rozstrzygnięta podaną metodą;
- `ACCEPTED-RISK` — produkcja świadomie buduje na hipotezie odbiorczej;
- `OPEN-NO-EVIDENCE` — pytanie odbiorcze pozostaje otwarte i nie blokuje;
- `REFUTED` — dowód przeczy hipotezie;
- `RETIRED` — hipoteza straciła zastosowanie po zmianie kierunku.

`SUPPORTED` jest zarezerwowane dla powtarzalnego wyniku z udziałem ludzi i nie
jest obecnie używane.

## Aktywne hipotezy

| ID | Hipoteza | Klasa | Status | Dostępna metoda / granica |
|---|---|---|---|---|
| H-001 | Responsywność ruchu da się pogodzić z ciężarem nowej animacji Leny | MIERZALNA + ODBIORCZA | TECHNICAL | 13 stanów kluczowych i proporcje 44-52px weryfikowane w `pkg_0118_smoke_test.gd`; przyjemność ruchu bez dowodu |
| H-002 | Anchor/Yield ma dość znaczących zastosowań, by unieść drugą tajemnicę 22–41 | MIERZALNA + ODBIORCZA | TECHNICAL | wprowadzenie mechaniki w 22-23 (PKG-0120), obiekty `ObservedGlassTrace` (32), `DualWitnessFrame` (33) i `JakubRescueBulkhead` (38) zweryfikowane w `pkg_0123_smoke_test.gd`; pełny audyt 43 scen zakończony |
| H-003 | Narastanie 01–20 buduje niepokój bez zdradzenia rozwiązania i bez nudy | ODBIORCZA | ACCEPTED-RISK | mierzalne proxy: sufity wiedzy, lint terminów w 01-07 (PKG-0118), 08-13 (PKG-0119) i 14-20 (PKG-0120); emocja i nuda bez dowodu |
| H-004 | Obraz i dźwięk wskazują zdarzenie przed myślą Leny | MIERZALNA + ODBIORCZA | TECHNICAL | sekwencje show → reaction → thought w 01-07 (PKG-0118), 08-13 (PKG-0119), 14-23 (PKG-0120), 31-37 (PKG-0122) i 38-43 (PKG-0123); zrozumienie bez dowodu |
| H-005 | Pixel-Stage jest wydajny i powtarzalny w 43 scenach | KOSZTOWA | MEASURED | PKG-0130: p99 <= 14.448 ms na Intel Iris Xe (12 najcięższych scen, vsync off); 45/45 scen w budżetach obiektowych `ParticleBudget`; metoda i granica w `docs/PKG_0130_FRAME_BUDGET_REPORT.md`. Nie mierzy GPU AMD/NVIDIA ani Steam Deck. |
| H-006 | Omylne interpretacje Leny brzmią ludzko, nie jak arbitralne oszustwo | ODBIORCZA | ACCEPTED-RISK | cykl hipoteza -> sprawdzenie wdrożony w 01-20, z syntezą i zamknięciem 4 hipotez w Station 21; odbiór psychologiczny bez dowodu |
| H-007 | Lena pozostaje czytelną osobą w `640x360` po próbkowaniu świata do `320x180` | MIERZALNA + ODBIORCZA | TECHNICAL | sylwetka fasetowa, ciemne spodnie, jasny sweter i torba sprawdzone na klatkach 01-43 |
| H-008 | Marta, Jakub, miejscowa Lena i Wierzbicka zachowują własne cele przez 2,5–3,5 godziny | MIERZALNA + ODBIORCZA | TECHNICAL | odmowa Marty (14-15), odmowa Jakuba (20, 29), oferta Wierzbickiej (31), echo domowej Marty (35), granice Jakuba (37, 38) i negocjacje (40) przetestowane w `pkg_0123_smoke_test.gd`; emocjonalna waga bez dowodu |
| H-009 | Wierzbicka i UCP są skuteczną, racjonalną opozycją, a nie jednowymiarowym złem | ODBIORCZA | OPEN-NO-EVIDENCE | oferta asymilacji w 31, bilans Linii 4 w 36, kontrola maszynowni w 34 i obrona stabilności w 40 przetestowane w PKG-0122/PKG-0123; percepcja gracka bez dowodu |
| H-010 | Rozpoznanie w Station 21 jest uczciwe i nieprzedwczesne | MIERZALNA + ODBIORCZA | TECHNICAL | 3 rodziny dowodów, bramka `is_world_recognized` i lint terminów w 14-20 zweryfikowane w PKG-0120; zaskoczenie bez dowodu |
| H-011 | Trzy zakończenia nie kodują „golden ending” | MIERZALNA + ODBIORCZA | TECHNICAL | bilans kosztów, brak hierarchii moralnej w konsolach 41, osobne epilogi 42A, 42B, 42C i stan podmiotów w 43 zweryfikowane technicznie w `pkg_0123_smoke_test.gd`; moralny odbiór bez dowodu |
| H-012 | Wszystkie czytelne teksty pozostają ostre nad pikselizowanym światem | MIERZALNA | TECHNICAL | CrispDiegeticText w Layer 10 i brak draw_string w Layer 0 zweryfikowane we wszystkich 43 scenach w PKG-0118..PKG-0123 |
| H-013 | System myśli pomaga przy zastoju bez spamowania | MIERZALNA + ODBIORCZA | TECHNICAL | cooldown >= 8.0s, reset po postępie i zamykanie hipotez potwierdzone testem automatycznym |
| H-014 | Dwie różne relacje Marty z dwiema Lenami są zrozumiałe bez wykładu | MIERZALNA + ODBIORCZA | TECHNICAL | próg Marty (14), rozbieżność wspomnień (15), echo domowe (35) i zgody (38, 42A, 42B) przetestowane; zrozumienie bez dowodu |
| H-015 | Miejscowa Lena pozostaje sprawczą osobą mimo fizycznej nieobecności | MIERZALNA + ODBIORCZA | TECHNICAL | odchylenie rejestru w 22, notatka z warunkiem przerwania w 33, alokacja biograficzna w 34, żywy sygnał w 37 i rozstrzygnięcia w 39-42 potwierdzają ślady jej decyzji; poczucie obecności bez dowodu |
| H-016 | Druga tajemnica po Station 21 utrzymuje napięcie zamiast zamienić się w procedurę | ODBIORCZA | ACCEPTED-RISK | przejście z rozpoznania do poszukiwania miejscowej Leny i odkrycia rachunku Linii 4 (21-43); napięcie bez dowodu |
| H-017 | Kobieca sylwetka Leny 3.0 wzmacnia wiarygodność | MIERZALNA + ODBIORCZA | REFUTED (mierzalna) / OPEN-NO-EVIDENCE (odbiór) | Właściciel 2026-08-25: Lena nie wygląda jak kobieta i wygląda jak krasnoludek. Rig 3.0 `_draw()` ~66 px jest PLACEHOLDER. Następca: H-027 / D-122. |
| H-018 | Swobodne cofanie dwukierunkowe wspiera ciągłość przestrzenną | MIERZALNA + ODBIORCZA | TECHNICAL (sygnał) / OPEN-NO-EVIDENCE (odbiór) | PKG-0132: `previous_level_requested` + `ReturnZone` na 02–43; spawn `test_move`. Brak sterowanego chodu 05→04→03 na ekranie. |
| H-019 | Pejzaże dźwiękowe i wieloprofilowe oświetlenie AtmosphereRig podbijają immersję i poczucie podziemnej skali bez zewnętrznych assetów | MIERZALNA + ODBIORCZA | TECHNICAL | 12 syntezatorów ProceduralAudio i dynamiczne oświetlenie/cząsteczki zweryfikowane w `pkg_0126_smoke_test.gd`; odbiór nastroju bez dowodu |
| H-020 | Płynne tempo CRT (42 CPS + auto-advance) eliminuje znużenie tekstem przy zachowaniu retro-teletypowego klimatu | ODBIORCZA | ACCEPTED-RISK | parametryzacja tekstu, dynamiczne blipy i matryca mówców wdrożone w `CRTDialogueBox`; odbiór czytelniczy bez dowodu |
| H-021 | Pula dźwięków proceduralnych i automatyczne czyszczenie pamięci eliminują wycieki RAM przy wielogodzinnej sesji | MIERZALNA | TECHNICAL | buforowanie fal `ProceduralAudio.get_cached_sound()` i `clear_sound_cache()` w `GameStateManager` zweryfikowane w `pkg_0127_smoke_test.gd` |
| H-022 | Warstwowa separacja (Layer 10, 16, 20, 100, 110) oraz matryca kolorów zapewniają 100% czytelność tekstu we wszystkich trybach skalowania | MIERZALNA | TECHNICAL | audyt kontrastu WCAG (>= 4.5:1) i testy skalowania 85%..115% potwierdzone testem `pkg_0127_smoke_test.gd` |
| H-023 | Parzystość mapowania urządzeń (klawiatura + gamepad) i remap z zachowaniem drugiego typu wejścia zapobiegają uwięzieniu gracza | MIERZALNA | TECHNICAL | `_replace_event_of_matching_type` w `GameStateManager` oraz testy pad/key w `pkg_0128_smoke_test.gd` |
| H-024 | Długodystansowy soak test (2 pełne przejścia 45 scen kampanii) dowodzi pełnej odporności na fragmentację sterty i wycieki obiektów w wydaniu Golden Master | MIERZALNA | TECHNICAL | 2 pełne cykle 45 scen przetestowane bez błędów ze stabilnym buforem audio (19 wpisów) w `pkg_0128_smoke_test.gd` |
| H-025 | Audyt geometrii i drabiny eliminują zablokowania | MIERZALNA + ODBIORCZA | TECHNICAL przy 18 px | PKG-0132: `geometry_audit.gd` próg 18, 0 blockerów / 45 scen. Odbiór „nie skaczę po mieście” bez tesci. |
| H-026 | Snap kamery do siatki 2 px usuwa pelzanie pikseli przy drabinie i windzie bez kumulowanego dryfu | MIERZALNA + ODBIORCZA | TECHNICAL | 120 klatek off-grid = 0, dryf <= 1 komórka, wstrząs na siatce — `pkg_0130_smoke_test.gd`; odczucie gładkości bez dowodu |
| H-027 | Lena 4.0 (sprite `gen-ai`) czyta się jako dorosła kobieta w skali mebli | MIERZALNA + ODBIORCZA | TECHNICAL (87 px + sprite + normal-driver capture) / OPEN-NO-EVIDENCE (odbiór) | Idle 46×87, kapsuła 72, biurko 01 = 39 px. PKG-0142 obejrzał świeże kadry normal/reduced na Intel Iris Xe, w tym Lenę obok stołu, panelu i drzwi; ADR-003 nadal wyklucza zamknięcie hipotezy odbiorczej bez człowieka. |
| H-028 | Trzy równe warianty zgody (`granted`/`limited`/`refused`) bez rankingu moralnego czytają się jako decyzja, nie jako ocena gracza | ODBIORCZA | OPEN-NO-EVIDENCE | Struktura Station 17 (PKG-0165): wszystkie warianty zapisują identyczne fakty, odmowa otwiera wyjście, brak liczby i paska oceny; dowód strukturalny w `tests/pkg_0165_smoke_test.gd` i `reports/pkg_0165/`; odbiór bez dowodu (D-012, ADR-003). |

| H-028 | Próg 18 px + drabina/winda usuwa skakanie po mieście z wymaganej trasy | MIERZALNA | TECHNICAL | 0 blockerów przy 18 px. One_way 09/11 nadal nadskakiwalne — PKG-0133. |
| H-029 | Sekwencje `rozbieżność → hipoteza → próba → zobowiązanie → ślad` ograniczą pasywne przechodzenie, nie zamieniając kampanii w zbiór escape roomów | ODBIORCZA | ACCEPTED-RISK | PKG-0144 ustanowił 15-sekwencyjny plan i wycinek 22–25. Przyszła bramka może sprawdzić strukturę informacji, stan, koszt i brak softlocka, nie zaangażowanie człowieka. |
| H-031 | Wczesne fale S01–S05 (01–14) dają czytelny argument `rozbieżność → hipoteza → próba → zobowiązanie → ślad` bez separowania się do checklist | MIERZALNA + ODBIORCZA | TECHNICAL | PKG-0146: próby rozstrzygają przez czasowniki, błędny krok daje `safe_trial_feedback`, brak `_check_unlock`/auto-inspekcji, kanoniczne fakty wyłącznie po działaniu; odbiór (rozumienie sekwencji, wiarygodność hipotez, respekt progu Marty) pozostaje bez dowodu (D-012, ADR-003). |
| H-032 | Fale S06–S07 (15–21) dają czytelny argument `rozbieżność → hipoteza → próba → zobowiązanie → ślad`, a rozpoznanie 21 jest odczuwane jako skutek wykonanej syntezy trzech rodzin, nie zaliczonej listy | MIERZALNA + ODBIORCZA | TECHNICAL | PKG-0147: próby instytucjonalna/publiczna/głosowa/relacyjna rozstrzygają przez czasowniki gracza; trzecie ułożenie dowodu nie uruchamia syntezy automatycznie; `world_recognized` i `local_lena_search_committed` powstają wyłącznie po jawnym wykonaniu; kadr nie ujawnia rozpoznania przed próbą; kanoniczne `world_recognized` otwiera Station 22 bez ręcznej flagi. Odbiór (czytelność argumentu, wiarygodność granicy Jakuba, waga rozpoznania) pozostaje bez dowodu (D-012, ADR-003). |
| H-033 | Fale S09–S10 (26–30) dają czytelny argument `rozbieżność → hipoteza → próba → zobowiązanie → ślad`, a mały koszt i granica Jakuba (`granted|limited|refused`) utrzymują uczciwą drogę bez kary | MIERZALNA + ODBIORCZA | TECHNICAL | PKG-0148: próba trzech zegarów i korekta wyłącznie błędu, cena Anchor/Yield po faktycznym wykonaniu (`marta_first_meeting_detail_blurred` / `sample_exact_second_lost`), trzy JSON-safe forecasty, `jakub_consent_state` wyłącznie po jawnej decyzji Jakuba, odmowa kontynuowalna; błędny bezpieczny krok daje `safe_trial_feedback`; stacje 31–43 bez zmian. Odbiór (czytelność argumentu, wiarygodność granicy Jakuba, waga małego kosztu) pozostaje bez dowodu (D-012, ADR-003). |
| H-034 | Fale S11–S13 (31–38) dają czytelny argument `rozbieżność → hipoteza → próba → zobowiązanie → ślad`, kontrmodel UCP i rejestr par ujawniają strukturę kosztu Linii 4, a prawda dla Marty (`full|partial|withheld`) nie nakłada moralnego długu ani kary | MIERZALNA + ODBIORCZA | TECHNICAL | PKG-0149: materialny depozyt Linii 4, 12. krzesło Jakuba, odrzucenie oferty adaptacji, pamięć materiału szkła laboratoryjnego (`ObservedGlassTrace`), rekonstrukcja zamiaru miejscowej Leny (`DualWitnessFrame` A/B) z kanonicznym faktem `local_lena_intent_found`, alokacja mocy maszynowni, baseny sedacyjne z weryfikacją echa powrotnego Jakuba (`home_echo_verified`), drenaż dielektryczny z rejestrem kosztu UCP (`ucp_cost_ledger_found`), mostek żywego sygnału i lina ratunkowa (`JakubRescueBulkhead` A/B) z jawnym zakresem prawdy dla Marty (`marta_truth_state`). Migracja checkpointów 31, 34, 37; likwidacja dead legacy kluczy; L0–L4 guidance z omylnymi hipotezami i `predicted_check`. Odbiór ludzki (waga prawdy dla Marty, dramatyzm kontrmodelu) pozostaje bez dowodu (D-012, ADR-003). |
| H-035 | Przebudowane otwarcie (TitleScreen + Station 01–04) ustanawia tożsamość Leny, stawkę Marty i odrębność pierwszych trzech rodzin bez żargonu i bez checklist | MIERZALNA + ODBIORCZA | KONTRAKT-MEASURED (GATE-01/GATE-05 PASS po PKG-0159) / OPEN-NO-EVIDENCE (odbiór) | PKG-0159: ciągły M1 od `Nowa gra` do Station 04, wyłącznie dialog/ruch/interakcja; 4203 ms do GATE-01 i 25353 ms do GATE-05 w automatyzacji. Title bez listy sterowania; dwie gałęzie próbka/obietnica mają różny stan torby i dialog. M3 bez tekstu/UI pokazuje trzy odrębne rodziny. Czasy nie są dowodem tempa człowieka. |
| H-036 | Przebudowane pierwsze 30 minut (Station 05–08) ustanawia 4 niezależne źródła rozbieżności, 4 odmienne rodziny i przejście przez próg bez polegania na tekście i bez przekroczenia budżetu ≤3 interakcji | MIERZALNA + ODBIORCZA | KONTRAKT-MEASURED (GATE-30 PASS) / PARTIAL (GATE-FAM 4/7) / OPEN-NO-EVIDENCE (odbiór) | PKG-0159: ciągły M1 `Nowa gra`→08 w 50124 ms automatu; rzeczywiste schody 08 i drożny pomost 02. Cztery reprezentatywne M3 są prawdziwie mono i bez UI/tekstu. Globalny GATE-FAM pozostaje 4/7, więc CHECKPOINT-03 = PIVOT. |
| H-037 | Bezpośrednie wywołania metod stacji i kolorowe captures wystarczą do certyfikacji produktu | MIERZALNA | REFUTED | PKG-0159 wykazał wymuszony liniowy wybór 01, niedrożny pomost 02, płaski substytut schodów 08 i niepełne M3. Nowy gate wymaga InputMap M1, M5 trace oraz prawdziwego mono z wyłączonym UI/tekstem. |

| H-038 | Station 09 czyta się bez tekstu jako obcy, używany salon dwóch osób | MIERZALNA + ODBIORCZA | TECHNICAL (struktura) / OPEN-NO-EVIDENCE (odbiór) | PKG-0161 przebudował wyłącznie obraz 09 i ponowił M3 na Intel Iris Xe: niski sufit, sofa, stół z dwiema filiżankami, drzwi wewnętrzne, fotografia, ceramika i zasłonięte okno w dwóch planach głębi. Inspekcja oraz GATE-FAM 7/7 rozstrzygają kontrakt strukturalny; reakcja nowej osoby pozostaje bez bezpośredniego dowodu (D-012, ADR-003). |
| H-039 | Pierwsza lekcja Anchor/Yield (Station 14) jest czytelna z obrazu i działania przed nazwaniem metody | MIERZALNA + ODBIORCZA | TECHNICAL (stany i kontrakty) / OPEN-NO-EVIDENCE (odbiór) | PKG-0162: rozdzielnia pracuje własnym cyklem i wystawia most sekcji na falę; utrzymanie zachowuje obserwowaną wersję, puszczenie przełącza montaż z kosztem zgaszonej sekcji; nazwanie tylko po obu zachowaniach; trzy beztekstowe M2 o różnych hashach + M3 (`reports/pkg_0162/`). Testy dowodzą stanów, nie zrozumienia ani emocji (D-012, ADR-003). |
| H-040 | Station 16 pokazuje, że kontynuacja odpowiedzi ma mały, jawny koszt i może zakończyć się potwierdzonym echem domu bez utraty drogi | MIERZALNA + ODBIORCZA | TECHNICAL (stany i kontrakty) / OPEN-NO-EVIDENCE (odbiór) | PKG-0164: bezpieczny analizator wymaga wykonanej odpowiedzi, wybór `marta_first_meeting_detail_blurred` lub `sample_exact_second_lost` tworzy `mechanic_cost_observed`/`small_cost_manifested`, a osobne potwierdzenie tworzy `home_echo_verified`; błędne próby są informacyjne. Trzy beztekstowe M2 o różnych hashach i jeden M3 mono w `reports/pkg_0164/`; testy nie dowodzą zrozumienia, emocji ani wagi kosztu (D-012, ADR-003). |
| H-041 | Station 18 pokazuje trzy metody z jawnymi brakami zgody i zatwierdza jedną bez rankingu moralnego | MIERZALNA + ODBIORCZA | TECHNICAL (stany i kontrakty) / OPEN-NO-EVIDENCE (odbiór) | PKG-0166: tablica zestawia `force_home`/`close_equal_recover_local`/`mutual_passage` z `jakub_consent_state`, witryna zapisuje `marta_truth_state` = `full`/`partial`/`withheld`, `method_committed` wyłącznie po zestawieniu; odmowa i wstrzymanie otwierają wyjście. Trzy beztekstowe M2 o różnych hashach i jeden M3 mono w `reports/pkg_0166/`; testy nie dowodzą zrozumienia, emocji ani wagi wyboru (D-012, ADR-003). |
| H-042 | Station 42A pokazuje wymuszony powrót i zamknięcie drugiej Leny między adresami bez rankingu moralnego | MIERZALNA + ODBIORCZA | TECHNICAL (stany i kontrakty) / OPEN-NO-EVIDENCE (odbiór) | PKG-0167: wejście wymaga `force_home`; rygiel zapisuje `ending_family`, próg `local_lena_sealed` (zamyka `other_lena_comes_home_too`), stół JSON-safe skutek dla Marty/Jakuba + `ending_stability`; wybrany wariant nie softlockuje 43. Trzy beztekstowe M2 o różnych hashach i jeden M3 mono w `reports/pkg_0167/`; testy nie dowodzą zrozumienia, emocji ani wagi skutku (D-012, ADR-003). |
| H-043 | Station 42B pokazuje zamknięcie Równi, odzyskanie ciała przez miejscową Lenę i nieindeksowaną obecność przybyłej Leny bez rankingu moralnego | MIERZALNA + ODBIORCZA | TECHNICAL (stany i kontrakty) / OPEN-NO-EVIDENCE (odbiór) | PKG-0168: wejście wymaga `close_equal_recover_local`; przewód zapisuje `ending_family`, próg `local_lena_recovered` (zamyka `arrived_lena_unindexed_presence`), stół JSON-safe skutek dla Marty/Jakuba/obu Len + `ending_stability`; wybrany wariant nie softlockuje 43. Trzy beztekstowe M2 o różnych hashach i jeden M3 mono w `reports/pkg_0168/`; testy nie dowodzą zrozumienia, emocji ani wagi skutku (D-012, ADR-003). |
| H-044 | Zimne otwarcie pokazuje pięć faktów tożsamości i wprowadza pojęcie drgań obrazem, zanim padnie słowo | MIERZALNA + ODBIORCZA | OPEN-NO-EVIDENCE | GATE-INTRO (M1+M5+M4) zmierzy czas, nośnik i kolejność; nie zmierzy, czy nowa osoba zrozumiała, kim jest Lena (D-012, ADR-003) |
| H-045 | Obsada zbudowana jednym rigiem w skali 84–92 px czyta się jako ci sami ludzie w świecie i na portrecie | MIERZALNA + ODBIORCZA | CONTRACT PASS (PKG-0186) / OPEN-NO-EVIDENCE (odbiór) | PKG-0186: jeden język Leny 4.1, 06/08 to `CharacterVisualRig`, Marta kremowa sukienka ≠ różowe włosy, Jakub 1:6,5 nie krasnoludek, Wierzbicka seated prawdziwa. Kadry `reports/pkg_0186/visual/`. „Wygląda dobrze” nadal ocena właściciela (D-012). |
| H-053 | Jeśli każdy człowiek w kadrze używa kreski Leny 4.1, właściciel przestanie zgłaszać „kółka i trójkąty” oraz „inną grę” | MIERZALNA + ODBIORCZA | CONTRACT PASS (PKG-0187) / OPEN-NO-EVIDENCE (odbiór) | PKG-0187: świeże zbliżenia 06/08/10/11/12/42B/42C i pięć CRT, lint bez głowy-kółka w finałach; 42B/C mają tylko nieczytelne odbicie wewnątrz progu. To nie mierzy oceny właściciela ani odbioru człowieka. |
| H-046 | Wejście jako czynność z animacją daje poczucie wejścia do miejsca, którego marsz w prawo nie dawał | ODBIORCZA | CONTRACT-PASS / OPEN-NO-EVIDENCE | PKG-0174: `ThresholdZone` + `interact` na 20 adresach, 0 postępu z `body_entered`. Odbiór „weszłam” pozostaje hipotezą (D-012) |
| H-047 | Krok po stopniu interpolowany o rzeczywistą wysokość usuwa wrażenie potykania się | MIERZALNA | CONTRACT-PASS / OPEN-NO-EVIDENCE | PKG-0173: 0 `jump_fall` i squasha w `pkg_0173_smoke_test.gd`. Odbiór „nie potyka się” pozostaje hipotezą (D-012) |
| H-048 | Trasa zawsze przechodnia z rejestrem luk nie rozsypuje narracji przy przebiegu minimalnym | MIERZALNA + ODBIORCZA | CONTRACT-PASS / OPEN-NO-EVIDENCE | PKG-0175: 20/20 wyjść od `_ready()`, minimalny przebieg do 43, luki zamykają się po powrocie. Czy historia „jeszcze się klei” bez odczytów, pozostaje hipotezą odbiorczą (D-012) |
| H-049 | Egzekwowanie jednego metra przez lint geometrii utrzymuje skalę bez ręcznej dyscypliny | MIERZALNA | CONTRACT-PASS (otwory PKG-0174) / OPEN (meble) | PKG-0174: `aperture_rect` w kanonie §7.1 na trasie; collidery 01/02/03/04/07/08/12. Meble poza otworami bez linta |
| H-050 | Zimne otwarcie w dwóch warstwach sprawia, że nowa osoba wie, kim jest Lena, co mierzy i kto na nią czeka, zanim wykona pierwszy wybór | MIERZALNA + ODBIORCZA | CONTRACT-PASS / OPEN-NO-EVIDENCE | PKG-0176: 5/5 faktów `PLAYER_CONTRACT.md` §3 przed rozwidleniem w 25,0 s (budżet 90 s), każdy z nośnika innego niż menu, ekran tekstu i prompt UI; kolejność pojęcia „drgania” z §4.3 zachowana; 0 zakazanych ujawnień §5; reduced motion 5/5. Że człowiek to **zrozumiał**, pozostaje hipotezą odbiorczą (D-012, ADR-003) |
| H-051 | Pominięcie warstwy A po pierwszym przejściu nie odbiera graczowi żadnego faktu, bo warstwa B dostarcza trzy z pięciu i tak | MIERZALNA | OPEN | PKG-0176 zapisuje kroki pominiętej sekwencji z adnotacją `skipped_seen_before`, więc rejestr nie udaje obejrzenia. Czy powtórne przejście bez warstwy A jest czytelne, nie było mierzone |
| H-052 | Czarna klatka po `Nowa gra` jest błędem produktu, nie dumpem przejścia | MIERZALNA | FALSIFIED-AS-STUCK-FRAME (PKG-0184) | `cold_open` t0/initial mean luma 0.1024 na Windows; nie 100% czerń. Dump w trakcie zrzutu tytułu nadal niezmierzony; odbiór przejścia pozostaje OPEN-NO-EVIDENCE |

## Wiążące fakty produktowe PKG-0155

Właściciel zaakceptował board audit jako prawdę o bieżącym runtime:

- gracz nie zna tożsamości, celu, motywacji ani zasad świata;
- lokacje oraz ich rodziny są wizualnie nierozróżnialne;
- gra nie komunikuje się poprawnie jako doświadczenie;
- bieżące testy techniczne nie są dowodem przeciw tym faktom.

Dotychczasowe statusy `TECHNICAL` pozostają prawdziwe w swoich wąskich
granicach, ale nie mogą być używane do produktowego greenlightu. H-003, H-004,
H-013, H-014, H-016, H-029 i H-031..H-034 tracą rolę uzasadnienia obecnej
formy; ich odbiorcza część jest **REFUTED dla bieżącego runtime** i wymaga
nowego pomiaru dopiero po odbudowie P9.

## Ryzyka kontrolowanej przebudowy

| ID | Ryzyko | Prawdopodobieństwo | Wpływ | Odpowiedź |
|---|---|---|---|---|
| R-001 | Zbyt duże podobieństwo ruchu lub kadru do `Another World` | średnie | bardzo wysoki | zapożyczać zasady ciężaru i ekonomii, nie aktywa ani rozpoznawalne kadry; własny model sheet, timing, paleta i kostium |
| R-002 | Przebudowa zamieni się w pełny reset techniczny | średnie | bardzo wysoki | ADR-006/007 wyliczają systemy zachowane; przepisać komponent dopiero po wykazanej regresji blokującej |
| R-003 | Stary runtime nadal zdradza zwrot w migrowanym wycinku | wysokie | bardzo wysoki | lint terminów, mapa beatów, test flag; tekst legacy nie może pozostać na aktywnej ścieżce |
| R-004 | Station 01–05 są zwyczajne, lecz bez konfliktu i obietnicy działania | średnie | wysoki | konflikt zawodowy wokół próbki Linii 4, materialna procedura i relacja z Martą bez paranormalnej zapowiedzi |
| R-005 | Myśli Leny zastąpią projekt poziomu | wysokie | wysoki | pokaż → naprowadź → pomyśl → sprawdź; L2/L3 dopiero po zastoju |
| R-006 | Błędne myśli nauczą błędnej mechaniki | średnie | bardzo wysoki | omylna tylko interpretacja fabularna; obserwacja, sterowanie i cel czynności zawsze prawdziwe |
| R-007 | Pixel-art będzie globalnym filtrem bez kierunku | wysokie | wysoki | kompozytor + ręczne palety, siatka, dithering i kadry; zakaz automatycznego szumu |
| R-008 | Pikselizacja rozmyje dialog, terminale lub szyldy | wysokie | bardzo wysoki | ostre warstwy po kompozytorze; migracja czytelnych `draw_string()`; test screenshotów |
| R-009 | Nowa Lena nadal wygląda jak znacznik albo krasnoludek | pewne | bardzo wysoki | Zmaterializowane. D-122 + `WORLD_SCALE.md` + capture okiem, nie tylko smoke. |
| R-010 | Animacja Leny pochłonie plan | wysokie | bardzo wysoki | budżety poz, kluczowe stany najpierw, reużycie riga i jawny backlog wariantów |
| R-011 | Biblia, pełna historia, tracker, dialog i flagi rozjadą się | wysokie | bardzo wysoki | jeden zakres na pakiet, czterodokumentowy audyt, test flag i jeden snapshot |
| R-012 | Zachowany save schema uruchomi flagi legacy | średnie | wysoki | PKG-0144 ustanawia namespaced stan P7, rewizję migracji sekwencji oraz zasadę: legacy nie nadaje faktu, zgody ani kosztu; checkpoint migrowanej sekwencji wraca do jej bezpiecznego wejścia. |
| R-013 | Historyczne audyty zostaną potraktowane jak aktywny plan | średnie | wysoki | INDEX kieruje do 3.0; 0.2 ma jawny status odrzuconego projektu pośredniego |
| R-014 | Brak zewnętrznego odbiorcy ukryje niezrozumienie do końca produkcji | pewne | bardzo wysoki | jawne ograniczenia, tanie plany odwrotu i automaty tylko jako proxy; bez deklaracji odbioru |
| R-015 | Brak Git uczyni błędną migrację nieodwracalną | wysokie | bardzo wysoki | natychmiastowy zapis, append-only log i pakietowy snapshot |
| R-016 | Przeszkody skręcą w arcade | średnie | wysoki | D-099, test trzech pytań i traversal lint; maszyna musi mieć funkcję świata |
| R-017 | P8 / build zostanie otwarty przed zamknięciem P7 | średnie | wysoki | Zamknięte technicznie przez PKG-0151 / D-164: P7 jest domknięte audytem i dopiero teraz otwiera P8. Ograniczenie pozostaje: nie budować nowego `.exe` bez jawnej zgody właściciela. |
| R-018 | Zakończenia pozostaną abstrakcyjnymi nazwami systemów | średnie | bardzo wysoki | w 42–43 pokazać jawny stan obu Len, Marty, Jakuba, UCP i obu ciągłości |
| R-019 | Dwie Leny zleją się odbiorcy w jedną abstrakcję | wysokie | bardzo wysoki | osobne określenia robocze, relacje, sprawcze decyzje, nagrania i matryca stanów; unikać „oryginału” |
| R-020 | Relacja Marty zostanie odczytana jako trójkąt lub nagroda dla protagonistki | średnie | bardzo wysoki | Marta rozpoznaje różnicę, stawia granice i nie przenosi automatycznie relacji miejscowej Leny na przybyłą |
| R-021 | Nieudokumentowane zmiany Foundation Slice zostaną nadpisane albo fałszywie uznane za gotowe | wysokie | wysoki | klasyfikacja `KEEP/ADAPT/RETIRE`, świeży test i wpis PKG-0117 przed snapshotem |
| R-022 | Korelacja kosztów Linii 4 zostanie podana jako wygodne, nieudowodnione prawo metafizyczne | średnie | wysoki | rozdzielić zapis pomiarowy, hipotezę Leny i model UCP; finał nie daje wszechwiedzącej odpowiedzi |
| R-023 | Powierzchnia release spakuje stare binaria, źródłowe PNG/prompty/logi albo wyjdzie z błędnego workflow eksportu | średnie | wysoki | PKG-0152: `.gdignore` dla `assets/characters/lena/raw/` i `logs/`, presety bez lokalnych template'ów, `tools/export_builds.ps1` audit-first z blokadą D-125, `tests/pkg_0152_smoke_test.gd` oraz jawny werdykt, że `dist/` z 2026-08-25 nie jest dowodem RC. Nadal brak świeżego build/rehearsal po P7. |
| R-024 | Drabiny lub windy skręcą w platforming precyzyjny (jump timing) | średnie | bardzo wysoki | Zakaz D-099; drabiny są ciągłymi strefami bez timingów, a windy mają sztywne krańcówki bez skoków |
| R-025 | Nadmiar proceduralnego audio lub cząsteczek obciąży mikser lub wątek renderera | niskie | wysoki | `ParticleBudget` 30 Hz na wszystkich emiterach; cache 18 tekstur świateł; pomiar p99 14.45 ms na Iris Xe; headless audit 45 scen |
| R-026 | Wycieki pamięci RAM / ObjectDB przy częstych zmianach scen w kampanii 43 przestrzeni | niskie | wysoki | Jawne zwalnianie `_exit_tree()` w AtmosphereRig i czyszczenie bufora audio `ProceduralAudio.clear_sound_cache()` w `GameStateManager.transition_to_scene()` |
| R-027 | Nadpisanie powiązań drugiego typu kontrolera podczas remappingu akcji | niskie | bardzo wysoki | Wdrożenie `_replace_event_of_matching_type` w `GameStateManager` zachowującego przypisania przeciwnego typu urządzenia (pad/key) |
| R-028 | Niespójności w bilingwalnych kluczach lokalizacji PL/EN lub creditsach | niskie | wysoki | Certyfikacja 100% symetrii słowników w `LocalizationManager` oraz audyt zgodności dialogów epilogu z `docs/LICENSES.md` w teście `pkg_0128_smoke_test.gd` |
| R-029 | Niedrożność geometrii w scenach kampanii lub stopień > 18 px bez drabiny/windy zablokuje ruch Leny | niskie | bardzo wysoki | `geometry_audit.gd` stosuje próg 18 px, pomija disabled collidery i certyfikuje aktualny runtime; każda nowa geometria P7 wymaga D-099, testu trzech pytań i ponownej weryfikacji. |
| R-030 | Snap kamery do siatki 2 px wprowadzi szarpanie kadru przy wolnym ruchu pionowym | niskie | średni | Autorytet float, snap tylko na wyjściu; strefa martwa 46 px; klamra w komorze = 1 widok zachowuje stare kadrowanie |
| R-031 | Certyfikat traweru 100% i Lena 3.0 ukryły niewgrywalność | pewne | bardzo wysoki | Zmaterializowane 2026-08-25. Odpowiedź: D-121..D-126, PKG-0132, unieważnienie certyfikatu 35 px. |
| R-032 | Sprite z `gen-ai` wyjdzie photoreal / chibi / Lester | średnie | bardzo wysoki | Karta postaci, osobne pozy, test dwóch klatek, zakaz siatki model-sheet, paleta Pixel-Stage. |
| R-033 | Reduced-motion wytnie informację razem z ruchem peryferyjnym | niskie | wysoki | D-151 rozdziela amplitudę od poziomu spoczynkowego. PKG-0142: 45+45 kadrów świata i 8+8 kadrów dialogowych, raport różnic oraz ręczna inspekcja reprezentatywnych par; brak dowodu komfortu odbiorcy. |
| R-034 | Wieloetapowe sprawy zamienią się w czytanie dokumentów albo kaskadę checkmarków | średnie | bardzo wysoki | PKG-0145: wycinek 22–25 ma próby przez `apply_reality_shift()`, `safe_trial_feedback` zamiast resetu i brak `_check_unlock` w migrowanych stacjach. Dotyczy to wyłącznie S08; kampania 01–21 i 26–43 pozostaje legacy i będzie mierzona w falach PKG-0146+. |
| R-035 | Zgoda Marty/Jakuba stanie się ukrytym quizem empatii albo punktem moralnym | średnie | bardzo wysoki | PKG-0145: `APPARENT_COOPERATION` usunięty; deklaracja wymaga trzech ujawnień i ma jawną alternatywę po odmowie; brak moral score w danych zobowiązań. Odbiór wiarygodności dialogu pozostaje bez dowodu. |
| R-036 | Rozbudowa ciągłości wyprodukuje globalny kombajn stanu lub softlocki | średnie | bardzo wysoki | PKG-0145: dane w `Resource`, wykonanie w lokalnych skryptach stacji, `GameStateManager.decisions` jedynym zapisem; testy potwierdzają alternatywę po odmowie i brak utraty obowiązkowego dowodu. Nadal dotyczy tylko S08. |
| R-038 | Legacy checklisty, automatyczne dialogi i rozjechane klucze stanu fałszywie zaliczą migrację P7 | wysokie | bardzo wysoki | PKG-0145: w 22–25 nie ma `_check_unlock` / automatycznej inspekcji; `_migrate_p7_mutual_test()` usuwa legacy klucze i nie wyprowadza z nich faktu, zgody ani kosztu; lint cutover w `pkg_0145_smoke_test.gd`. PKG-0146: ten sam wzorzec dla 01–14 (`_migrate_p7_early_sequences()`, lint w `pkg_0146_smoke_test.gd`). PKG-0147: ten sam wzorzec dla 15–21 — usunięte `_check_access`/`_check_records`/`_check_synthesis_readiness` i wszystkie auto-dialogi, migracja wymazuje legacy `world_recognized`/`recognition_evidence_*`/`jakub_*`/`local_lena_search_started`, lint cutover z negatywną kontrolą w `pkg_0147_smoke_test.gd`. Kolejne fale muszą go powtarzać. |
| R-035 | Zgoda Marty/Jakuba stanie się ukrytym quizem empatii albo punktem moralnym | średnie | bardzo wysoki | Zgoda ma jawny zakres, koszt i alternatywną drogę po odmowie; PKG-0145 usuwa preselected `APPARENT_COOPERATION` z kontraktu Station 24. |
| R-036 | Rozbudowa ciągłości wyprodukuje globalny kombajn stanu lub softlocki | średnie | bardzo wysoki | `DiagnosticSequenceDefinition` i lokalny kontroler kotwicy są zasobo- i scena-centryczne; `GameStateManager.decisions` zostaje jedynym zapisem. Test ma sprawdzić alternatywę po odmowie i brak utraty obowiązkowego dowodu. |
| R-037 | P7 cofnie twardy kanon P6 albo przeobrazi wyzwania w arcade | niskie | bardzo wysoki | D-154 zachowuje D-099, 18 px, brak nowych czasowników ruchu, 640×360, 60 Hz, ReturnZone, reduced motion i jedną rodzinę przeszkody na stację. |
| R-038 | Legacy checklisty, automatyczne dialogi i rozjechane klucze stanu fałszywie zaliczą migrację P7 | wysokie | bardzo wysoki | PKG-0151 domknął pełny audyt 15 sekwencji: 45 skryptów stacji bez `set_campaign_flag` / `_check_unlock`, graf bramek z wyjątkiem S08/S09, migracje checkpointów i round-trip faktów końca. Ryzyko pozostaje dla przyszłych zmian P8: każda nowa ingerencja musi utrzymać ten clean cutover. |
| R-039 | Zielone testy techniczne ponownie zostaną uznane za produktowy greenlight | wysokie | bardzo wysoki | D-168 rozdziela `TECHNICAL PASS` i `PRODUCT GO`; acceptance matrix P9 ma wydawać dwa niezależne werdykty |
| R-040 | Zespół zachowa 43-adresowy balast z powodu kosztu utopionego | wysokie | bardzo wysoki | PKG-0156 zamknął klasyfikację w `docs/rebuild/CAMPAIGN_MAP.md`: wszystkie 23 stacje 19–41 mają jawny status (`ADAPT` 17, `RETIRE` 6, `KEEP` 0); bramka `tests/pkg_0156_smoke_test.gd` zabrania `KEEP` w tym zakresie |
| R-041 | Rodziny miejsc znowu będą jednym layoutem różniącym się kolorem i etykietą | wysokie | bardzo wysoki | siedem rodzin ma osobne materiały, topologie, światło, audio i czasownik; obowiązkowy monochromatyczny capture bez labeli |
| R-042 | Monolity `MemoryResonancePoint` i `VectorStageEnvironment` przejmą również nową kampanię | wysokie | wysoki | zakaz rozszerzania ich w P9; nowe zachowanie jest lokalnym komponentem albo małym współdzielonym modułem z co najmniej dwoma realnymi użyciami |
| R-043 | Checkpoint zostanie zaliczony na dowodzie o węższym zakresie niż próg bramki | wysokie | bardzo wysoki | PKG-0159 cofnął CHECKPOINT-03 do PIVOT: cztery rodziny nie spełniają progu GATE-FAM 7/7. Macierz zapisuje licznik `n/7`, metodę i ograniczenie; kolejny handoff wymaga spłaty 7/7 przed CHECKPOINT-04. |
| R-044 | Naprawa prezentacji zostanie zrobiona „przy okazji” w monolicie `memory_resonance_point.gd` zamiast w nowych węzłach | wysokie | wysoki | D-168 i D-186 zakazują wprost; `CharacterVisualRig` i `ThresholdZone` są osobnymi plikami, a stare rysunki usuwane, nie duplikowane |
| R-045 | Portret Marty znowu powstanie jako modyfikacja portretu Leny, bo to tańsze | średnie | bardzo wysoki | D-187 wycofuje `tools/update_marta_portrait.py`; kryterium odrzutu §7 `CAST_AND_NPC_BIBLE.md`: „Marta wygląda jak Lena w peruce” |
| R-046 | Zniesienie twardych bramek wprowadzi softlock w miejscu, którego nikt nie przetestował | średnie | bardzo wysoki | GATE-FLOW wymaga trzech pełnych przebiegów, w tym minimalnego bez ani jednego odczytu opcjonalnego; precedens `unseeded` już działa w `station_43.gd` |
| R-047 | Kredyty `gen-ai` skończą się w połowie obsady | średnie | średni | saldo 1358 (2026-09-02); limit dwóch podejść na pozę, `gen-ai compare` przed serią, zatrzymanie i eskalacja poniżej 300 kredytów |
| R-048 | Ktoś przywróci twarde bramkowanie albo obniży próg nowej bramki, żeby uzyskać zielony wynik | średnie | wysoki | D-192 jest decyzją właściciela; `WORKFLOW.md`: „Nie oslabiaj progow, testow ani kryteriow tylko po to, by uzyskac zielony wynik”; zmiana wymaga nowej decyzji właściciela |
| R-049 | Deklaracja „absolutnie wszystko” stanie się płytką checklistą albo nowy audit odziedziczy fałszywie zielone bramki | wysokie | bardzo wysoki | PKG-0182 zostawił coverage 951 wierszy, fail-closed log policy, negatywną mutację PKG-0180 i świeże kadry/trasy. Residualne ryzyko: red-team PKG-0183 musi falsyfikować te PASS-y, a nie dziedziczyć ich. F-0182-003 (monolit) pozostaje P3. |
| R-050 | Audio factory odzyska pre-clamp albo legacy CSV zostanie niejawnie zarejestrowany po zmianie locale | średnie | wysoki | PKG-0188: `pkg_0188_hygiene_test.gd` odrzuca factory `return clampf`, mierzy raw=4.0 przez jedyną granicę PCM i sprawdza brak routingu CSV w `project.godot` oraz `LocalizationManager`; CSV pozostaje audytowalny jako RETIRED. Test dowodzi kontraktu technicznego, nie jakości miksu ani tłumaczenia. |
| R-051 | Naprawa Station 10–13 podmieni fakty mapy bez rzeczywistego działania albo połączy semantykę P9 z refaktorem MRP | wysokie | bardzo wysoki | D-205/D-206 i `PKG_0189_RESIDUAL_BOUNDARY_SPEC.md`: pierwszy krok jest teraz **PKG-0191** (przenumerowany z PKG-0190 przez D-206, bo PKG-0190 wykonał zamiast tego cinematic vignettes na żądanie właściciela). PKG-0191 ma używać rzeczywistych `resonance_triggered`/`trigger_interaction`, testować negatywne warunki oraz save/reload, nie usuwać P7 ani nie dotykać MRP. PKG-0192 pozostaje osobny. `pkg_0189_boundary_inventory_test.gd` rejestruje stan sprzed migracji, nie udaje jej zakończenia. |
| R-052 | Cinematic vignette stanie się jedynym nośnikiem krytycznej flagi fabularnej albo zablokuje przejściowość, jeśli asset/trigger się rozjedzie | średnie | wysoki | `tests/pkg_0190_cinematics_test.gd` dowodzi: każda flaga (`world_recognized`, `local_lena_signal_confirmed`, `method_committed`, `ending_family`...) jest zapisywana przez samą stację przed emisją sygnału triggera, niezależnie od tego czy winieta się wyrenderuje; skip i reduced motion kończą w identycznym stanie gry; już obejrzana winieta nie odtwarza się drugi raz na tej samej stacji. `CinematicCatalog` wymusza dokładnie 2 klatki i istnienie zasobu na dysku dla każdego z 7 wpisów. |


## Wczesne wskaźniki alarmowe

- Przed Station 21 pojawia się jawna diagnoza sytuacji.
- Po Station 21 pytanie „gdzie jestem?” nie zostaje zastąpione pytaniem o
  miejscową Lenę i koszt Linii 4.
- Marta mówi o obu Lenach tak samo lub nie stawia granicy przybyłej Lenie.
- Miejscowa Lena istnieje tylko jako plik potrzebny do rozwiązania zagadki.
- Jakub jest traktowany jako nagroda, dług albo dowód zamiast osoby ze zgodą.
- Wierzbicka przekazuje ekspozycję, ale nie podejmuje działań blokujących.
- Myśl pojawia się przed obserwacją albo podaje rozwiązanie jako pewnik.
- Czytelny tekst znajduje się pod `WorldPixelCompositor`.
- Dokument mówi „content lock”, choć aktywna trasa nadal zawiera legacy.
- Test lub render jest opisywany jako dowód strachu, zabawy lub zrozumienia.

## Jak aktualizować

Po pakiecie dopisz lub zmień:

- datę, metodę i surowy wynik pomiaru;
- zakres, którego wynik dotyczy;
- ograniczenie dowodu;
- zmianę statusu i wpływ na roadmapę;
- plan odwrotu, jeśli ryzyko się materializuje.

PKG-0193 / CR-A (2026-09-05): nowe ryzyko prezentacji obejmuje kolejność
otwarcie/CRT/winieta i ponowny odczyt po reloadzie. Właściciel lokalny oraz
bramka dostarczenia chronią tę kolejność; zapisane fakty nie dowodzą lektury.
Istniejący uśmiech portretu Marty i ograniczona liczba gestów nadal ograniczają
reżyserię. Hipotezy emocji, urody i zrozumienia pozostają OPEN-NO-EVIDENCE;
CR-A nie ustanawia PRODUCT GO. Stan wykonania: `rebuild/PKG_0193_CREATIVE_SCENES.md`.

Nie ustawiaj `MEASURED` bez metody i nie ustawiaj `SUPPORTED` bez
powtarzalnego wyniku z udziałem ludzi.

## PKG-0231 — zmaterializowane ryzyka sensu aktywnej kampanii

| ID | Ryzyko | Prawdopodobienstwo | Wplyw | Odpowiedz |
|---|---|---|---|---|
| R-053 | Globalnie otwarte progi pozwalaja pominac przyczyny, a kolejne sceny zakladaja zdobyta wiedze | pewne / zmaterializowane | bardzo wysoki | D-243: klasy REQUIRED / OPTIONAL_WITH_GAP / LOCAL_FLAVOUR i stanowe otwarcia; nie otwierac nieodwracalnych progow bez przyczyny |
| R-054 | Brak jawnej metody w 18 zostaje po cichu zamieniony na final 42A | pewne / zmaterializowane | bardzo wysoki | usunac fallback A; brak decyzji ma pozostac brakiem i blokowac final |
| R-055 | Wariant 42 i epilog 43 zapisuja skutek/koniec przed wykonaniem i odczytem konsekwencji | pewne / zmaterializowane | bardzo wysoki | atomowy lancuch commit→wykonanie→skutek→relacja→epilog; blackout dopiero po pelnej sekwencji |
| R-056 | Powrot do ukonczonej stacji blokuje ponowny marsz naprzod przez `_handled_completions` | wysokie / kod potwierdzony | bardzo wysoki | oddzielic idempotencje writerow od nawigacji; test kazdej krawedzi przod→powrot→przod |
| R-057 | Dialog i rekwizyty ustanawiaja wiedze poza kadrem (UCP, 20:40, zaswiadczenie, czytnik) | pewne / zmaterializowane | wysoki | naprawic kolejnosc writerow, pochodzenie rekwizytow i jezyk hipotezy; bez dodatkowego exposition dumpu |

## PKG-0232 — odpowiedź na R-053..R-057 (2026-09-14, D-244, MEASURED bramkami)

| ID | Status po PKG-0232 | Dowód |
|---|---|---|
| R-054 | ZAMKNIĘTE na normalnej ścieżce | 18 bez metody nie commituje progu (bramka 0232 §2); jawne wejścia testowe/selektora bez zmian |
| R-055 | ZAMKNIĘTE | 42A/B/C wymagają wykonanie→stan→skutek; 43 wymaga tablicy+napisów+5 linii przed blackoutem (bramka 0232 §4–6; M1 w 0177) |
| R-056 | ZAMKNIĘTE | `_repeat_navigate`: macierz 10→11, 17→18, 18→42A, 42A→43 na prawdziwych tranzycjach (bramka 0232 §7) |
| R-053 | CZĘŚCIOWO (punkty nieodwracalne) | polityka REQUIRED/OPTIONAL/LOCAL + strażnicy finału/epilogu; claim-side liniowy 17/18 otwarty → następny pakiet |
| R-057 | CZĘŚCIOWO (S-02 twarda) | otwarcie 14 bez zewnętrznego przerwania; beat wyjścia 13, UCP-10, zaświadczenie, czytnik → następny pakiet |

## PKG-0235 — luki P9 / Pakiet C (2026-09-15, D-247, MEASURED bramką 0235)

Luka i flaga byly z dwoch epok tej samej stacji: po 10 mysl o stole Marty,
flaga `is_key_trial_completed`; po 11 mysl o wyciagu, flaga fotografii;
15 miala martwa nazwe `is_local_signal_confirmed`. Pakiet C podmienia
flagi na czasowniki P9 i zdejmuje klamstwo `station_11|passage_required`.
Dowod: bramka `pkg_0235` (P7-proba klucza nie zamyka luki; 11 po wyciagu
nie otwiera fotografii; 10 bez granicy otwiera luke o stole). Nie jest to
dowod odbioru (D-012, ADR-003). Otwarte z tej kolejki: B (ciecia), D, E.

## PKG-0234 — duchy w pokojach / Pakiet A (2026-09-15, D-246, MEASURED bramką 0234)

Geometria klamala kadr (donica klatki w salonie, komoda korytarza przy
ladzie UCP, balkon jako wyjscie z warsztatu, szuflada-prog). Nie jest to
osobne R-0xx: to jest Pakiet A planu 2026-09-15. Wezly zostaja, zdejmowane
z trasy (layer 0/mask 1 albo collider disabled). Kampania 09/11/13 nie
zalezy od `is_passage_clear`; binder 12 nie wskazuje BalconyDoor.
Dowod: bramka `pkg_0234` + pelna verify (`reports/pkg_0234_verify_full.log`).
Nie jest to dowod odbioru (D-012, ADR-003). Otwarte z tej kolejki: C (luki),
B (ciecia), D, E.

## PKG-0233 — odpowiedź na R-053/R-057 (2026-09-14, D-245, MEASURED bramką 0233)

| ID | Status po PKG-0233 | Dowód |
|---|---|---|
| R-053 | CZĘŚCIOWO (claim-side 17/18) | punkty nieodwracalne zamknięte w 0232; liniowe 17/18 mówią głosem luki (s16-gap, niepoliczone prognozy) — brak osobnych linii wejścia; do akceptacji lub kolejnego pakietu |
| R-057 | ZAMKNIĘTE | B1 (hipoteza UCP-10) + B2 (zaświadczenie z torby 01) + B3 (pokwitowanie czytnika 11, pamiętane w 12/13) + B4 (korelat dwóch urządzeń) + mosty 13→14 i 18→42 + fokalizacja 42B + migawka D2 + wypłata D5 (bramka 0233 §1–9; raport `rebuild/PKG_0233_SENSE_BRIDGES.md`) |

Metoda: statyczny, swiezy odczyt aktywnych scen i skryptow 01–18/42/43;
raport `rebuild/PKG_0231_FRESH_STORY_SENSE_AUDIT.md`. To dowodzi struktury
runtime, nie odbioru emocjonalnego.

PKG-0217 / limit dlugosci linii dialogowych (2026-09-12, MEASURED): pudlo CRT 488x52 przy foncie 15 miesci ~2 linie; dopiski ~130 znakow (wykres + margines + brak danych) wylozyly sasiada pkg_0194 realnym FAIL-em fit-at-100 (2x). Po skroceniu do ~104-111 znakow pkg_0194 PASS bez zmiany asercji. Guide dla przyszlych pakietow tresci: linie w scope 0194 (14-18) trzymac <= ~115 znakow; kazda dopiska liczy znaki przed puszczeniem bramek. Bramka 0217 nie mierzy wysokosci pudla (to pinuje wylacznie pkg_0194). Nie jest to dowod odbioru (D-012, ADR-003).

PKG-0219 / sufit + swiatlo + roza (2026-09-12, TECHNICAL): podbitka 09 domyka przeswit do 37 px (kontrakt 20-45, bramka 0219); swiatlo 01: work light + cold fill + cien bebna 0.48 w prawo (audyt 12/14 stoi); regula D-232 (Marta w kadrze -> 1 akcent -> reszta w shade(MID_PLANE); mono 09 vs 01/11/12/15 na 3 osiach strukturalnie). Otwarte: sufity 08 (masa do 36) i 13 (brak masy) oraz near-miss 10 (51 px); egzekucja reguly w 10/13 czeka na przepisanie ich palet (osobny pakiet). Licznik D-217 WYCZERPANY: 4 zakresowe po pelnej PKG-0215 � PKG-0220 MUSI byc pelna verify (faza R4, shared-touch audio). Nie jest to dowod odbioru (D-012, ADR-003).

PKG-0220 / petle ambientu + duck (2026-09-12, TECHNICAL): 7 ambientow PKG-0180 na generate_looping_wav (f0/AM/dlugosci nietkniete, krawedzie RMS>500, szew bez pelnoskalowego trzasku, bramka 0220); duck x3 (hum/sub/unease -7 dB); busy Ambient/Dialogue; back-buffer stopped-spare (budzet 0130 stoi � pierwszy wariant z grajacym spare wylozyl 0130 realnym FAIL-em 5>4 na 8 stacjach 31-41, naprawiony w tym samym pakiecie); drain przez helper. PELNA verify.ps1 PASS (licznik D-217 zresetowany: ostatnia pelna PKG-0220). Otwarte: ambience spoza 7 na one-shot+retrigger; start stacji od pelnego poziomu bez fade-in (transjent wejsciowy mozliwy, maskowany -24 dB, niemierzony). Nie jest to dowod odbioru (D-012, ADR-003).


## PKG-0241 — otwarte ryzyka / 2026-09-22

Nowe 51/51 sprawdzen i 176 kadrów nie dowodza calej kampanii ani odbioru emocjonalnego.
Diagnostyka Linux 83/128 ma 45 niepowodzen: niezgodnosci narracyjne/testowe, braki historycznych
dowodow i timeouty trzeba rozliczyc osobno. Szczegoly i profil Windows sa w raporcie audytu.
Brak dowodu fizycznego pada, dzwieku, DPI i wydajnosci na komputerze gracza; 60 Hz to symulacja.
Talk_0/talk_1 vendor pozostaja identyczne. Ciaglosc kostiumu Leny i detali winiet wymaga R3,
nie losowej regeneracji. Ryzyko ponownego wykluczenia vendor ograniczono wyjatkiem gitignore.
Nie ma PRODUCT GO ani nowego wydania. Plan R1–R4: docs/audits/PKG_0241_IMPLEMENTATION_PLAN.md.
