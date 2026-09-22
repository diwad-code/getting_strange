# Indeks dokumentacji

> KOLEJKA (2026-09-15, dyspozycja wlasciciela): swiezy audyt sensu
> `docs/narrative/SENS_FABULARNY_RAPORT_2026-09-15.md` + plan
> `docs/narrative/SENS_FABULARNY_PLAN_NAPRAWY_2026-09-15.md`.
> **Plan naprawy sensu fabularnego (A, C, B, D, E) ZOSTAŁ W PEŁNI UKOŃCZONY**:
> A (PKG-0234, DONE) → C (PKG-0235, DONE) → B (PKG-0236, DONE) → D (PKG-0237, DONE) → E (PKG-0238, DONE).
> Kolejna sesja: ocena PRODUCT GO / dyspozycja wlasciciela.
> GATE-REL i release nadal BLOCKED BY D-168.
>
> PKG-0238 / mosty dialogowe Pakiet E (2026-09-16): decyzja D-250; freeze
> D-241 zdjety wylacznie dla E z planu 2026-09-15. Raport:
> `docs/rebuild/PKG_0238_DIALOGUE_BRIDGES.md`. Wdrozono: E1 (zaudytowana i zabezpieczona
> ciaglosc wejsc i wyjsc 09–18, 9 par zapowiedz-potwierdzenie; limit CRT <= 115 znakow),
> E2 (trzy sekundy: dopisek na marginesie stacji 15 nienaruszony, tajemnica nie wykladana wprost),
> E3 (rezerwy DIALOGUE_LINES w 42A/B/C zaudytowane i opisane jako edytorski fallback, pin 0107,
> brak wiaty w 42B, JAKUB (ECHO) w 42C), rozwiazanie dyskrepancji stacji 43 (Linia 4 odbudowano + brak metody).
> Nowa bramka `pkg_0238`; pin `pkg_0207` (129/128/127/127); 136. sekcja w verify.ps1.
> PELNA `verify.ps1` PASS exit 0. GATE-REL i release nadal BLOCKED BY D-168.
> D-220..D-250 zachowane. Starszy naglowek PKG-0237 nizej opisuje D.
>
> PKG-0237 / slowa zarobione Pakiet D (2026-09-16): decyzja D-249; freeze
> D-241 zdjety wylacznie dla D z planu 2026-09-15. Raport:
> `docs/rebuild/PKG_0237_EARNED_WORDS.md`. Wdrozono: D1 (slowo „Rownia” zarobione
> w stacji 17 w cost_ledger_console), D2 (Wierzbicka w dwoch trybach: lada 11, terminal 17
> z rozpoznaniem glosu przez Lene), D3 (analizator w stacji 16 z szyldem w swiecie
> i adresem w naglowku), D4 (final B w progu m. 14, czytnik w torbie, brak wiaty w 42B),
> D5 (przeciek Jakuba w 42C i memory_leak to JAKUB (ECHO)), D6 (Lena przybyla sterowana
> przez gracza w 42A/B/C), D7 (epilog 43 unseeded bez kradziezy tonu C, tag „Brak metody. ”).
> Nowa bramka `pkg_0237`; pin `pkg_0207` (128/127/126/126); 135. sekcja w verify.ps1.
> PELNA `verify.ps1` PASS exit 0. GATE-REL i release nadal BLOCKED BY D-168.
> D-220..D-249 zachowane. Starszy naglowek PKG-0236 nizej opisuje B.
>
> PKG-0236 / ciecia nie teleporty Pakiet B (2026-09-15): decyzja D-248; freeze
> D-241 zdjety wylacznie dla B z planu 2026-09-15. Raport:
> `docs/rebuild/PKG_0236_CUTS_NOT_TELEPORTS.md`. Wdrozono: binder 13 jako
> HATCH (64x64, door="") jak 14/15; 09/10 zostaja DOOR; binder 12 DOOR bez
> BalconyDoor (pin A); mysl wyjscia 10 (s10_exit_ucp_record) nazywa wyjscie z
> domu do UCP (zostawia telefon, sprawdza zapis, hipoteza 0233 zachowana);
> 14 wita wlazem, 13 wychodzi wlazem; arrival_side_for 12->13 i 17->18 z
> prawej, reszta 10-18 z lewej. Nowa bramka `pkg_0236`; pin `pkg_0207`
> (127/126/125/125); kontrolowana aktualizacja 0214; 134. sekcja w verify.ps1.
> PELNA `verify.ps1` PASS exit 0 (dowod `reports/pkg_0236_verify_full.log`,
> licznik D-217 ZRESETOWANY). GATE-REL i release nadal BLOCKED BY D-168.
> D-220..D-248 zachowane. Starszy naglowek PKG-0235 nizej opisuje C.

>
> PKG-0235 / luki P9 Pakiet C (2026-09-15): decyzja D-247; freeze D-241
> zdjety wylacznie dla C z planu 2026-09-15. Raport:
> `docs/rebuild/PKG_0235_GAP_VERBS.md`. Wdrozono: flagi 09/10/11/15 na
> czasownikach P9 (`is_private_boundary_respected` /
> `is_marta_boundary_accepted` / `is_minimal_report_requested` /
> `is_signal_confirmed`); override fotografii na 11 usuniety;
> `key_wear_required` / `key_trial_required` w NON_GAP. Nowa bramka
> `pkg_0235`; pin `pkg_0207` (126/125/124/124); 133. sekcja.
> PELNA `verify.ps1` PASS exit 0 (dowod `reports/pkg_0235_verify_full.log`,
> licznik D-217 ZRESETOWANY). GATE-REL i release nadal BLOCKED BY D-168.
> D-220..D-247 zachowane. Starszy naglowek PKG-0234 nizej opisuje A.
>
> PKG-0234 / duchy w pokojach Pakiet A (2026-09-15): decyzja D-246; freeze
> D-241 zdjety wylacznie dla A z planu 2026-09-15. Raport:
> `docs/rebuild/PKG_0234_GHOST_PROPS.md`. Wdrozono: donica 09 i StairFlight
> z trasy salonu (wezly zostaja); komoda 11 z trasy lady; binder 12 door=""
> (nie BalconyDoor) + drzwi serwisowe; szuflada 13 nie jest bramka syntezy.
> Nowa bramka `pkg_0234`; pin `pkg_0207` (125/124/123/123); 132. sekcja.
> Kadry 09/11/12/13 8 PNG HOLD. PELNA `verify.ps1` PASS exit 0 (dowod
> `reports/pkg_0234_verify_full.log`, licznik D-217 ZRESETOWANY).
> GATE-REL i release nadal BLOCKED BY D-168. D-220..D-246 zachowane.
> Starszy naglowek PKG-0233 nizej opisuje poprzedni pakiet mostow.

> PKG-0233 / drugi mega-pakiet sensu: B + C/D2/D5 (2026-09-14): drugi
> mega-pakiet z planu PKG-0231 (decyzja D-245; freeze D-241 zdjety wylacznie
> dla napraw PKG-0231). Raport: `docs/rebuild/PKG_0233_SENSE_BRIDGES.md`.
> Wdrozono: hipoteza UCP-10 (B1); zaswiadczenie m. 12 z torby 01, ciaglosc
> 07→13 (B2); warunkowe pokwitowanie czytnika 11, pamietane w 12/13 (B3);
> korelat dwoch urzadzen w syntezie 13 (B4); most 13→14 (wyjscie + wlaz
> HATCH, bez wiedzy z 15) i most 18→42 (cue noc→swit + perspektywa
> przybylej Leny); fokalizacja 42B (przybyla Lena w progu); atomowa migawka
> snapshot przy commicie z lockami (D2); wyplata prawda/zgoda/koszt w 42
> (slownik + znaczki) i w 43 (linia 2 + znaczki, D5). Kontrolowane: FAIL
> 0195 na linii 43B[2] (znacznik rodziny) + blad String==bool w _draw 13.
> Pin `pkg_0207` (124/123/122/122) + nowa bramka `pkg_0233` (131. sekcja).
> PELNA `verify.ps1` PASS exit 0 (dowod `reports/pkg_0233_verify_full.log`,
> licznik D-217 ZRESETOWANY). R-057 ZAMKNIETE; R-053 CZESCIOWO (claim-side
> 17/18 glosem luki). GATE-REL i release nadal BLOCKED BY D-168.
> D-220..D-245 zachowane. Starszy naglowek PKG-0232 nizej opisuje poprzedni
> pakiet przyczynowy.

> PKG-0232 / lancuch przyczynowy A+D1/D3/D4 (2026-09-14): pierwszy mega-pakiet
> z planu PKG-0231 (decyzja D-244; freeze D-241 zdjety wylacznie dla napraw
> PKG-0231). Raport: `docs/rebuild/PKG_0232_CAUSAL_CHAIN.md`. Wdrozono:
> polityke faktow REQUIRED/OPTIONAL/LOCAL; `_repeat_navigate` w GSM (S-07);
> 18 bez metody nie commituje progu (jawne wejscia testowe/selektora bez
> zmian); 42A/B/C: wykonanie→stan→skutek→prog 43 z nazwanymi lukami;
> 43: tablica(2 beaty)→napisy(2 beaty)→5 linii→blackout, odmowa bez zapisu;
> otwarcie 14 bez zewnetrznego przerwania (20:40 zachowane). Kontrolowane
> aktualizacje 0167/0168/0169/0175/0177 + pin `pkg_0207` (123/122/121/121)
> + nowa bramka `pkg_0232` (130. sekcja). PELNA `verify.ps1` PASS exit 0
> (dowod `reports/pkg_0232_verify_full.log`, licznik D-217 ZRESETOWANY).
> Twardy fakt: fizyczny sweep M1 nie wykonywal mechanik 14–17. R-054/R-055/
> R-056 ZAMKNIETE; R-053/R-057 CZESCIOWO; PRODUCT GO nadal zablokowane.
> GATE-REL i release nadal BLOCKED BY D-168. D-220..D-244 zachowane.
> Starszy naglowek PKG-0231 nizej opisuje poprzedni audyt.

> PKG-0231 / swiezy audyt sensu fabularnego (2026-09-14): niezalezny odczyt
> aktywnego runtime 01–18 → 42A/B/C → 43, bez czytania wczesniejszych analiz,
> raportow narracyjnych, snapshotow i testu 0230. Raport:
> `docs/rebuild/PKG_0231_FRESH_STORY_SENSE_AUDIT.md`; plan dla wykonawcow:
> `docs/rebuild/PKG_0231_STORY_SENSE_REPAIR_PLAN.md`. Werdykt:
> STORY-SENSE CONCERNS / PRODUCT GO nadal zablokowane. Rdzen historii jest
> spojny w pelnym przebiegu, ale runtime rozlacza przyczyne od skutku:
> globalnie otwarte progi, przedwczesna wiedza 14, sprzecznosc UCP w 10,
> domyslne 42A bez metody, skutek 42 przed wykonaniem, blackout 43 przed pelnym
> epilogiem oraz blokada przod→powrot→przod przez `_handled_completions`.
> Decyzja D-243; ryzyka R-053..R-057. Kod/sceny nietkniete. Swieza pelna
> `verify.ps1` przed docs PASS (129 sekcji); finalna zakresowa PASS exit 0
> (DOCS 52 + smoke 01–43 + pin 0207 122/121/120; log
> `reports/pkg_0231_scoped.log`). GATE-REL i release nadal BLOCKED BY D-168.
> Starszy naglowek PKG-0230 nizej opisuje poprzednia implementacje.

> PKG-0230 / naprawa sensu fabularnego (2026-09-14): dyspozycja wlasciciela
> (STORY_SENSE_REPAIR_PROMPT, freeze D-241 zdjety dla zakresu), decyzja D-242.
> Raport `docs/rebuild/PKG_0230_STORY_SENSE_REPAIR.md`: P0-4 epilog bez
> sprzecznosci Linii 4; P0-3 WYKRESLONY (S-04 obalony bramka 0214, otwieracz
> GSM→ensure_exit_open); P0-1 zgoda wiaze metody + renegocjacja w 17;
> P0-2 wskazanie vs zatwierdzenie (+-40, oznaczenia); P1-1+P1-4 ogniwa;
> P1-3 rigi 18/42A + lacze 17; P1-2 zawias Marty; P2-1 arrival_side_for +
> HATCH; P2-2 (a)(c)(e)/(b)(d)(f) odroczone; P2-3 naglowki live + renames;
> P2-4 nocny dyzur. PELNA `verify.ps1` PASS exit 0 (129 sekcji, dowod
> `reports/pkg_0230_verify_full.log`, licznik D-217 ZRESETOWANY; po drodze
> realne regresje 0099 i 0137 + wyscig harnessa 0194 naprawione w pakiecie).
> Pin `pkg_0207` (122/121/120). Test 18/18 z tresci gry. Otwarte: inspekcja
> obrazu na displayu, renegocjacja vs 4. metoda, PRODUCT GO (wlasciciel).
> GATE-REL nadal BLOCKED BY D-168. D-220..D-242 zachowane.
> Starszy naglowek PKG-0229 nizej opisuje poprzedni pakiet oceny GO.

> PKG-0229 / pakiet oceny PRODUCT GO (2026-09-13): dyspozycja wlasciciela
> ("GO review"), sciezka D docs-only, bez nowej decyzji. Raport
> `docs/rebuild/PKG_0229_GO_REVIEW_EVIDENCE.md`: 14 bramek produktu ze
> SWIEZYMI dowodami z pelnej 0228 (wszystkie TECHNICAL PASS recertyfikowane;
> FIN/CAST wzmocnione pakietami R8/R7) + pola werdyktu [ ] GO / CONCERNS /
> FAIL per bramka i calosciowe PRODUCT GO do wypelnienia przez wlasciciela.
> Otwarte punkty do swiadomej akceptacji: 440/480, flake-watch 0151, kadry
> recertow bez displaya, brak dowodow odbiorczych z zasady. GATE-REL nadal
> BLOCKED BY D-168. Pin `pkg_0207` bez zmian (121/120/119); zakresowa
> (docs-only, blast poza monolitami). D-220..D-241 zachowane.
> Starszy naglowek PKG-0228 nizej opisuje poprzednia recertyfikacje R10.

> PKG-0228 / pelna recertyfikacja R10 (2026-09-13): decyzja D-241 (sciezka
> D, zero zmian tresci), plan PKG-0213 R0-R10 WYCZERPNY. PELNA `verify.ps1`
> PASS exit 0 (128 sekcji, dowod `reports/pkg_0228_verify_full.log`,
> licznik D-217 ZRESETOWANY). Twardy fakt: pierwszy przebieg oblal 0151
> wylacznie warningiem teardown PO jej 100% PASS (3x isolated czysto,
> drugi pelny PASS) — flake, nie regresja; regula flake-watch w D-241.
> MAINTAIN FREEZE: ekstrakcja MRP w kolejce, 440/480 otwarte ze specyfikacja
> (elderly -> 392 G4), K8-K15 na zlecenie, release BLOCKED BY D-168.
> Kadry: brak swiezych (sandbox bez displaya); stoja dowody 0187/0190/
> 0201-0203 + bramki kamer z przebiegu. Pin `pkg_0207` bez zmian
> (121/120/119). D-220..D-241 zachowane.
> Starszy naglowek PKG-0227 nizej opisuje poprzednia higienie R9.

> PKG-0227 / higiena i narzedzia R9 (2026-09-13): decyzja D-240,
> T3 (dopiska o backticku w verify.ps1) + T4 (lint reentrancji setterow,
> fail-closed) + T5 (centralny pin warstw fizyki 4x4
> scripts/environment/physics_layers.gd) + V9 (inwentarz kamer:
> scripts/camera/ to dokladnie cinematic_camera.gd + station_camera_rig.gd;
> NODE_NAME Camera; jedno extends Camera2D; zero draw_string
> w scripts/levels/*.gd) + V11 (legacy capture_act1/act2/act2b/act2c
> ery PKG-0094 przeniesione do tools/retired/) + A5/K26/K28 (dev-raport
> 5 osi audio tools/audio_5axis_report.gd + Audio-Browser
> tools/audio_browser.gd wylacznie w trybie testowym, gra ich nie
> referencjonuje). Nowa bramka `pkg_0227` PASS (3x), pin `pkg_0207`
> (121 invokes / 120 scripts / 119 tests), 128. sekcja `verify.ps1`,
> zakresowa `verify_scoped.ps1` PASS (licznik D-217: 1. zakresowa po
> pelnej PKG-0226). D-220..D-240 zachowane.
> Starszy naglowek PKG-0226 nizej opisuje poprzedni truth-payoff i stol.
> LISTA CAPTURE-PRAWD (V11): prawda to `tools/capture_preview.gd`
> (podglady Movement/Anchor Lab), `tools/capture_pkg_0187.gd`
> (mono/threshold/npc_frame) i `tools/capture_pkg_0190.gd` (winiety)
> oraz bramkowe `tools/capture_pkg_02*.gd` aktywnej trasy 01-18/42/43;
> legacy ery wygaslej formy 43 adresow lezy w `tools/retired/`
> (capture_act1/act2/act2b/act2c_vector_stage.gd + .uid) i nie jest prawda.

> PKG-0226 / truth-payoff + stół 6 rzeczy (2026-09-13): decyzja D-239,
> N6-reszta fazy R8 (faza R8 zamknięta w całości: PKG-0225 + PKG-0226) —
> 9 otwarć household o parami różnych hashach (42A drugie zgłoszenie,
> 42B czytnik w torbie, 42C półka; tailsy i otwarcia nietknięte, pinują je
> 0194/0195); stół 6 rzeczy w method_commit_post (FULL_STORY §39: 2 pary
> aktu + 6 par przeglądu z istniejących decyzji, brak to luka, const LINES
> niemutowany); obraz (6 kresek stołu w 18; pierścienie prawdy r8/w2.5 na
> blatach 42: pełny/połowa/przerwa); zero nowych faktów (FACT_ 14/15/16/16).
> Twarde fakty: sąsiedzi PASS bez churnu (append-only); łuk r5/w1.5 ginie
> w kompozytorze 2x2; kadr (570,262) na geometrii drzwi → blat (490,262).
> Nowa bramka `pkg_0226` PASS (3×), pin `pkg_0207` (120 invokes / 119
> scripts / 118 tests), 127. sekcja `verify.ps1`, kadry 18/42a/42b/42c
> 24 PNG pre+post HOLD, PEŁNA `verify.ps1` PASS (dowód
> `reports/pkg_0226_verify_full.log`, licznik D-217 ZRESETOWANY).
> D-220..D-239 zachowane.
> Starszy nagłówek PKG-0225 niżej opisuje poprzednie winiety i finały.
> N-finały fazy R8 — winiety rozszerzonym pinem 0190 (katalog dokładnie 7:
> 08/13/15/18/42a/42b/42c; brak winiety dla mechaniki 14, brak duplikacji
> cold openu; zero podpisów 7/7; skip od startu + runtime vig_commit; stany
> 43: 3×5 linii, konkret, brak narratora/tez); nośniki K1 (kurtka 42A/42B/42C),
> K2 (kubek 18 per truth_state), K3 (hełm 42C; 37 nietknięta), K5 (koszula
> 42B/42C), K6 (płyta UCP 28×14 + cykl −1 klatka w 05/18); 7 beatów L1 bez
> tez, zero nowych faktów/sygnałów/linii (brak churnu 0194). Twardy fakt:
> bramka złapała brak K5 FAIL-em. Nowa bramka `pkg_0225` PASS (3×), pin
> `pkg_0207` (119 invokes / 118 scripts / 117 tests), 126. sekcja
> `verify.ps1`, kadry 05/18/42a/42b/42c 10 PNG pre+post HOLD, zakresowa
> `verify_scoped.ps1` PASS (licznik D-217: 4. zakresowa po pełnej PKG-0221;
> PEŁNA obowiązkowo w PKG-0226). D-220..D-238 zachowane.
> Starszy nagłówek PKG-0224 niżej opisuje poprzednie rigi i geometrię.
> PKG-0224 / rigi i geometria (2026-09-13): decyzja D-237, jakub seated
> naprawiony pipeline'em CAST z raw 0172 (stojacy dubel 89 px → siedzacy
> 58 px w pasmie 56-60, dopisany do CHARS); wyjatki jawne vendor (bez
> turn_away/seated/work/gesture) + neighbour (bez turn_away/seated/work) —
> brak surowcow raw 0186, brak generacji; rig renderuje piksele idle,
> stacje 06/08 woluja tylko talk/listen/idle; turn_away zwolniony z pasa
> korony (pin: plotno + uziemienie + roznica od idle); profil miejski 06 vs
> mieszkalny 08: 6 roznic przy progu >= 4; progi wylacznie z aperture_rect
> (08 = 45x109 jak Binder, 06 bez drugiej geometrii). Twarde fakty: cache
> .godot trzymal stare seated 89 po wymianie PNG (reimport --import,
> project.godot diff pusty); fallback riga to piksele nie nazwa. Nowa bramka
> `pkg_0224` PASS (3×), pin `pkg_0207` (118 invokes / 117 scripts / 116 tests),
> 125. sekcja `verify.ps1`, kadry 06/08 8 PNG pre+post HOLD, zakresowa
> `verify_scoped.ps1` PASS (licznik D-217: 3. zakresowa po pełnej PKG-0221;
> pelna obowiazkowo najpozniej w PKG-0226). D-220..D-237 zachowane.
> Starszy nagłówek PKG-0223 niżej opisuje poprzednie głosy i tempo.
> PKG-0223 / głosy i tempo (2026-09-13): decyzja D-236, loop_logbook 15
> 4→2 pary + tiki na dzienniku po odczycie (łańcuch MRP nietknięty, pin
> 0194); urządzenia-reszta bez etykiet + Wierzbicka bezosobowa (audit 40
> read-only); hub 09 (haczyk wskazuje zdjęcie); projekcja-gest oferty 17;
> N10 grep-0 w LINES (ją→próbę, sensacja→powiązany koszt, mantra ×3→
> słupek/klucz/most, Para 04/17→rejestr z obrazem); margines K4 (beat L1 +
> ślad ołówka); kontrolowana aktualizacja 2 asercji `pkg_0194` po realnym
> FAIL-u (wzór PKG-0216). Nowa bramka `pkg_0223` PASS (3×), pin `pkg_0207`
> (117 invokes / 116 scripts / 115 tests), 124. sekcja `verify.ps1`, kadry
> 15/17/18 6 PNG + klatka logu + klatka rejected, zakresowa
> `verify_scoped.ps1` PASS (licznik D-217: 2. zakresowa po pełnej PKG-0221).
> D-220..D-236 zachowane.
> Starszy nagłówek PKG-0222 niżej opisuje poprzednią korektę z kosztem.
> PKG-0222 / korekta z kosztem + budzety (2026-09-13): decyzja D-235,
> korekta M7 w stacjach lokalnych (14: L2 s14_cost_hypothesis przy A→B;
> 15: has_cost_mark + FACT_COST + L2 s15_living_response + welon; koszt
> nie potwierdza sygnalu); budzety M5 (distinct MRP ≤3: 15 re-pin, 18 pin
> == 3; sciezka ≤3 czasowniki: 15 auto-notatka, 18 donor out; lancuch MRP
> 15 nietkniety, pin 0194); select 18 wylacznie routingiem (zero fabrykacji,
> brak → istniejacy feedback na s18.method_uncommitted); markery
> IS_PHYSICAL_OBSTACLE_FREE 01/18; KillZone 0 w kampanii. Twardy fakt:
> GSM node_added → ensure_exit_open otwiera wyjscia z automatu (D-227),
> is_exit_unlocked nie jest sygnalem bramek. Nowa bramka `pkg_0222` PASS
> (3×), pin `pkg_0207` (116 invokes / 115 scripts / 114 tests), 123. sekcja
> `verify.ps1`, kadry 14/15/18 6 PNG + klatka kosztu, zakresowa
> `verify_scoped.ps1` PASS (licznik D-217: 1. zakresowa po pelnej PKG-0221).
> D-220..D-235 zachowane.
> Starszy nagłówek PKG-0221 niżej opisuje poprzednią drabinę z Return i skalami.
> PKG-0221 / drabina + Return + skale 0221 (2026-09-13): decyzja D-234,
> intencja drabiny w LadderZone (try_mount: interact/stop+gora; koniec
> jump-off; begin_climb w graczu); ReturnZone jako drugi ThresholdZone
> (overlap milczy; powrot wylacznie trigger_return; target = poprzednik
> GSM; apertura/rodzina jak prog; podpiecia body_entered w 05/06/07/08/43
> usuniete); strefy nie konsumuja interactu (priorytet MRP); skale
> 02/h76 + 15/h150 (wystawanie 12) + 16/y288; GATE-SCALE 0 naruszen.
> Nowa bramka `pkg_0221` PASS, pin `pkg_0207`
> (115 invokes / 114 scripts / 113 tests), 122. sekcja `verify.ps1`,
> kadry 02/15/16 6 PNG, PELNA `verify.ps1` PASS (dowod
> `reports/pkg_0221_verify_full.log`, licznik D-217 ZRESETOWANY).
> D-220..D-234 zachowane.
> Starszy nagłówek PKG-0220 niżej opisuje poprzednie pętle ambientu z duckiem.
> 7 ambientow PKG-0180 na `generate_looping_wav` z obwiednia loop-safe
> (f0/AM/dlugosci nietkniete; crossfade 80 ms w helperze; spis 265 stoi);
> duck hum/sub/unease (-24/-28/-22, -7 dB); busy Ambient/Dialogue
> (duck jako sidechain); ambient niepozycjonowany (komentarz);
> back-buffer stopped-spare (0130 liczy tylko playing — grajacy spare
> wylozyl realny FAIL 5>4, naprawiony w tym samym pakiecie); drain
> helperem. Nowa bramka `pkg_0220` PASS, pin `pkg_0207`
> (114 invokes / 113 scripts / 112 tests), 121. sekcja `verify.ps1`,
> PELNA `verify.ps1` PASS (dowod `reports/pkg_0220_verify_full.log`,
> licznik D-217 ZRESETOWANY). D-220..D-233 zachowane.
> Starszy nagłówek PKG-0219 niżej opisuje poprzedni sufit ze światłem.
> PKG-0219 / sufit + światło + reguła różu 09/01 (2026-09-12): decyzja D-232,
> podbitka 09 x 0..300 ze spodem y=172 (prześwit 37 px w kontrakcie 20–45;
> drzwi 109 i collidery nietknięte; lampa pod podbitką; etykieta MIESZKANIE 14
> na ścianie w pasie 90–190); światło 01 rodziny 5 (źródło robocze na bęben +
> zimne wypełnienie + cień bębna w prawo 0.48; audyt 12/14 stoi); reguła
> 1-akcentu Marty (character_id &"marta": 10 i 13 → reszta w shade(MID_PLANE);
> 09 bez Marty: AMBER+CYAN); mono 09 vs 01/11/12/15 na 3 osiach.
> Nowa bramka `pkg_0219` PASS, pin `pkg_0207` (113 invokes / 112 scripts /
> 111 tests), 120. sekcja `verify.ps1`, kadry 01+09 18 PNG + mono 11/12/15
> 3 PNG, zakresowa `verify_scoped.ps1` PASS (licznik D-217: 4. zakresowa po
> pełnej PKG-0215; limit: pełna obowiązkowo w PKG-0220). D-220..D-232 zachowane.
> Starszy nagłówek PKG-0218 niżej opisuje poprzedni fartuch z paletą i liniami.
> PKG-0218 / fartuch + paleta + linie 09 (2026-09-12): decyzja D-231,
> fartuch w 22/22 scenach 01–18/42/43 (audyt wykazał 11 braków, prompt
> zakładał tylko 09 — naprawione w tym samym pakiecie); paleta 09 w całości
> na `VectorStageStyle` (zero `Color("…")`, było ~36 hexów; układ 1:1;
> MAX_PALETTE_COLORS 7 → 8, kanon 8–16); linie 09 ≥ 2 px (zero stroke 1.0;
> sąsiedzi 08 ×1 detal / 10 ×4 / 13 ×0, sufit 10 do PKG-0219).
> Nowa bramka `pkg_0218` PASS, pin `pkg_0207` (112 invokes / 111 scripts /
> 110 tests), 119. sekcja `verify.ps1`, kadry 09 9 PNG + spot 13/18 4 PNG,
> zakresowa `verify_scoped.ps1` PASS (licznik D-217: 3. zakresowa po pełnej
> PKG-0215; limit: pełna w PKG-0220). D-220..D-231 zachowane.
> Starszy nagłówek PKG-0217 niżej opisuje poprzednią syntezę z prognozami.
> PKG-0217 / synteza + prognozy + urządzenia (2026-09-12): decyzja D-230,
> synteza 13 z trzecim głosem Jakuba przez łącze (sugestia próby wycofana,
> 6 par; logika 3+3+2 nietknięta; FULL_STORY 13 zsynchronizowany); granted
> 3× `brak danych` + rejestry urządzeń (REJESTR 20:40 / ANALIZATOR oś-pik /
> NOTATKA margines); Wierzbicka bezosobowa (4/4/4, recepcja wycofana).
> Twardy fakt: dopiski ~130 znaków wyłożyły `pkg_0194` FAIL-em fit-at-100,
> skrócone do ~104–111 w tym samym pakiecie. Nowa bramka `pkg_0217` PASS,
> pin `pkg_0207` (111 invokes / 110 scripts / 109 tests), 118. sekcja
> `verify.ps1`, kadry 13/18 12 PNG, zakresowa `verify_scoped.ps1` PASS
> (licznik D-217: 2. zakresowa po pełnej PKG-0215). D-220..D-230 zachowane.
> Starszy nagłówek PKG-0216 niżej opisuje poprzedni słownik z lintem.
> PKG-0216 / słownik + lint treści + Tak/Jadę (2026-09-12): decyzja D-229,
> `Zakotwiczenie` jedyną nazwą metody (linie + station_14 PL/EN + FULL_STORY
> + raport 0194; `Utrzymanie ruchu` zachowane); lint treści prezentowanej
> (6 ID → fallback, dowód fail-closed, furtka D-211 nie na stałe, 0165 stoi);
> palimpsest 42B `Jadę nad częściowo startym Tak` (3 warianty + blok 42B).
> Nowa bramka `pkg_0216_dictionary_content_pin_test.gd` PASS, aktualizacja pinu
> `pkg_0207` (110 invokes / 109 scripts / 108 tests), 117. sekcja `verify.ps1`,
> kadry 13/18/42b 18 PNG, zakresowa `verify_scoped.ps1` PASS (licznik D-217:
> 1. zakresowa po pełnej PKG-0215). Kontrolowany update asercji `pkg_0194:286`
> (wykryty realnym FAIL-em). D-220..D-229 zachowane.
> Starszy nagłówek PKG-0215 niżej opisuje poprzednie luki z głosem.
> PKG-0215 / luki 1:1 z głosem i priorytet interact M6+M4 (2026-09-12): decyzja D-228,
> tabela 9→54 + override + 9 teł; flagi s09–s14 realne; wiring annotate w 18/18
> ze strażnikami (visible + is_presenting); strażnik progu w 14 (MRP > Anchor >
> Threshold). Nowa bramka `pkg_0215_gap_voice_pin_test.gd` PASS, aktualizacja pinu
> `pkg_0207` (109 invokes / 108 scripts / 107 tests), 116. sekcja `verify.ps1`,
> kadry station_14 6 PNG, PEŁNA `verify.ps1` PASS (licznik D-217 zresetowany).
> Po drodze naprawiono zamrożone oczekiwanie 0208 (dopisano PKG-0209 do historii
> promptu, wykryte pełną jako realny FAIL). D-220..D-228 zachowane.
> Starszy nagłówek PKG-0214 niżej opisuje poprzedni pin progów.
> PKG-0214 / pin własności progów i otwartych wyjść M1+M2 (2026-09-12): decyzja D-227,
> Binder jedynym właścicielem (ROUTE 22, apertury §7.1, margines 24 px); statyka
> 45/45 bez węzła Threshold; wyjścia 22/22 otwarte przy zero odczytach; overlap
> Airlock 22/22 bez progresji. Rozstrzygnięcie plan-vs-runtime (wzór D-216/D-218):
> statyczne węzły z §8 planu niezastosowane (dual ownership). Nowa bramka
> `pkg_0214_threshold_exit_open_pin_test.gd` PASS, aktualizacja pinu `pkg_0207`
> (108 invokes / 107 scripts / 106 tests), 115. sekcja `verify.ps1`,
> zakresowa `verify_scoped.ps1` PASS. D-220..D-227 zachowane. Licznik D-217:
> 4. zakresowa po pełnej PKG-0210 (pełna obowiązkowa w PKG-0215).
> Starszy nagłówek PKG-0213 niżej opisuje poprzedni audyt 360.
> PKG-0213 / kompleksowy audyt 360 + plan wdrożenia (2026-09-12): ścieżka D,
> bez nowej decyzji, zero logiki/obrazu. 36 findings (N1–N10 / M1–M10 /
> V1–V11 / A1–A5 / T1–T5) + 30 pomysłów K1–K30 + fazy R0–R10
> (PKG-0214..0228) w `docs/rebuild/PKG_0213_COMPREHENSIVE_AUDIT_AND_IMPLEMENTATION_PLAN.md`.
> P0: Threshold zero instancji + wyjścia bramkowane, lint D-211 omijany,
> słownik metody, Tak/Jadę, fartuch+paleta 09. Zakresowa `verify_scoped.ps1`
> PASS (docs 52 + smoke + 0207 pin 107/106/105 + 0212 census).
> D-220/D-221/D-222/D-223/D-224/D-225/D-226 zachowane. Licznik D-217:
> 3. zakresowa po pełnej PKG-0210 (pełna najpóźniej w PKG-0215).
> Starszy nagłówek PKG-0212 niżej opisuje poprzedni spis stacji.
> PKG-0212 / spis stacji na dysku skrypty ↔ sceny 1:1 (2026-09-12): decyzja D-226,
> 45 skryptów station_*.gd (01–41 + 42a/b/c + 43, każdy z class_name i extends Node2D)
> ↔ 45 scen station_*.tscn o tych samych ID (zero sierot/wiszących, każda scena
> referencjonuje własny skrypt), 3 helpery nie-stacyjne z nazwy, pokrycie dyskowe
> trasa 18 / legacy 23 / finały 3 / epilog 43.
> Nowa dedykowana bramka `pkg_0212_station_disk_census_test.gd` PASS,
> aktualizacja pinu `pkg_0207` (107 invokes / 106 scripts / 105 tests),
> zakresowa `verify_scoped.ps1` PASS (docs DOCS PASS 52 + smoke + 0206 + 0207 + 0208 + 0210 + 0211 + 0212).
> D-220/D-221/D-222/D-223/D-224/D-225/D-226 zachowane.
> Starszy nagłówek PKG-0211 niżej opisuje poprzedni spis silnika ProceduralAudio.
> PKG-0211 / spis i pin silnika syntezy ProceduralAudio (2026-09-12): decyzja D-225,
> autorytatywny spis 265 funkcji statycznych (256 generatorów create_*, 250 bezparametrowych,
> 6 sparametryzowanych, 9 pomocniczych), kontrakt fali 16-bit PCM 44100 Hz mono,
> pętle w create_anchor_sustain_tone_sound i create_prop_drag_scrape_sound,
> weryfikacja cyklu życia pamięci podręcznej _sound_cache oraz procedury drain_playback.
> Nowa dedykowana bramka `pkg_0211_procedural_audio_census_test.gd` PASS,
> aktualizacja pinu `pkg_0207` (106 invokes / 105 scripts / 104 tests),
> zakresowa `verify_scoped.ps1` PASS (docs DOCS PASS 52 + smoke + 0206 + 0207 + 0208 + 0210 + 0211).
> D-220/D-221/D-222/D-223/D-224/D-225 zachowane.
> Starszy nagłówek PKG-0210 niżej opisuje poprzedni audyt architektoniczny Aurelius.
> PKG-0210 / audyt architektoniczny Aurelius (2026-09-12): decyzja D-224,
> wdrożenie planu naprawczego 14 sektorów bez naruszania kontraktów i logiki gry.
> Reentrancja setterów wyeliminowana w 5 skryptach interakcji, rozprzęgnięcie
> prototype_player (&"player") i threshold_zone, jawne warstwy fizyki 2D (1..4)
> w project.godot, formalizacja niemutowalności Flyweight. Nowa dedykowana bramka
> `pkg_0210_architectural_audit_remediation_test.gd` PASS, aktualizacja pinu `pkg_0207`
> (105 invokes / 104 scripts / 103 tests), pełna `verify.ps1` PASS (112 sekcji, DOCS PASS 52).
> D-220/D-221/D-222/D-223/D-224 zachowane.
> Starszy nagłówek PKG-0209 niżej opisuje poprzednią pełną recertyfikację.
> PKG-0209 / pełna recertyfikacja (2026-09-06): ścieżka D bez nowej decyzji,
> logika i obraz NIETKNIĘTE — pełna `verify.ps1` PASS (111 sekcji,
> DOCS PASS 52, dowód `reports/pkg_0209_verify_full.log`); licznik D-217
> ZRESETOWANY (ostatnia pełna PKG-0209, następna najpóźniej PKG-0214).
> D-220/D-221/D-222/D-223 bez zmian.
> Starszy nagłówek PKG-0208 niżej opisuje poprzedni pin selektora.
> PKG-0208 / decyzja D-223 (2026-09-06): selektor kampanii i defaulty
> ZAPINOWANE, logika i obraz NIETKNIĘTE — ROUTE 18 / LEGACY 23 / FINALES 3 /
> EPILOGUE 43 / SELECTOR 20 (01–18 + 42a + 43; bez 42b/42c i bez legacy) /
> OPMAP A-B-C / limity 18-41; defaulty volume 0.85 / CPS 42.0 / skale
> 0.85 < 1.0 < 1.15 / reduced-motion false / REMAPPABLE 5; kontrolowana
> aktualizacja pinu 0207 (101 → 102 / 103 → 104 / 102 → 103, reguła D-222);
> zakresowa `verify_scoped.ps1` PASS (docs + smoke + 0198/0201/0202/0203/0205/
> 0206 bez modyfikacji + 0207 z aktualizacją + nowa bramka 0208; 111. sekcja
> w `verify.ps1`); licznik D-217 WYCZERPANY (ostatnia pełna PKG-0204,
> zakresowe 0205/0206/0207/0208 — PKG-0209 MUSI być pełną).
> Raport: `rebuild/PKG_0208_CAMPAIGN_SELECTOR_DEFAULTS_PIN.md`. D-220/D-221/
> D-222 bez zmian.
> Starszy nagłówek PKG-0207 niżej opisuje poprzedni spis bramek.
> PKG-0207 / decyzja D-222 (2026-09-06): rejestr bramek ZAPINOWANY,
> fundamenty OPISANE, logika i obraz NIETKNIĘTE — 101 plików tests/*.gd
> == 101 referencji w `verify.ps1` (zero sierot/wiszących/dubli);
> 103 wiersze wywołujące Invoke (102 ze skryptem: 101 testów +
> `tools/frame_budget_audit.gd` + import bez skryptu); fundamenty read-only
> 640×360 / 60 Hz / 10 akcji InputMap; handoff spójny (SESSION_LOG PKG-0207,
> CURRENT_STATE PKG-0207, DECISION_LOG D-222, prompt zna PKG-0208); zakresowa
> `verify_scoped.ps1` PASS (docs + smoke + 0198/0201/0202/0203/0205/0206 bez
> modyfikacji + nowa bramka 0207; 110. sekcja w `verify.ps1`); licznik
> D-217 biegnie (ostatnia pełna PKG-0204, limit PKG-0209, został 1 zakresowy).
> Raport: `rebuild/PKG_0207_GATE_CENSUS.md`. D-220/D-221 bez zmian.
> Starszy nagłówek PKG-0206 niżej opisuje poprzednią inwentaryzację.
> PKG-0206 / decyzja D-221 (2026-09-06): dług interakcji/audio MRP
> ZAPINOWANY i OPISANY, logika NIETKNIĘTA — trigger 182 gałęzie jawne
> (1 if + 181 elif) + else z `_memory_sound` (183 stream/pitch; 179 latch
> + 4 toggles), audio match 165 ramion + fallback `_:` (183 typy jawne,
> 20 na generyku; 170 + 3 cached = 173 create_), SWITCH_LIKE 6 nazw;
> specyfikacja 2 kroków ekstrakcji (raport:
> `rebuild/PKG_0206_MRP_INTERACTION_INVENTORY.md`); zakresowa
> `verify_scoped.ps1` PASS (docs + smoke + 0198/0201/0202/0203/0205 bez
> modyfikacji + nowa bramka 0206; 109. bramka w `verify.ps1`); licznik
> D-217 biegnie (ostatnia pełna PKG-0204, limit PKG-0209). Ogląd skal
> 85/115 dla zestawu 0198 DOMKNIĘTY (0202 + 0203). Rendery MRP 203/203
> (PKG-0200); D-220 (prop_type 0 HOLD) bez zmian. Raport: brak nowych
> kadrów (scena nietknięta); kolejka jak w raporcie 0206. Następna sesja:
> wolny wybór (ekstrakcja tabel czeka na dyspozycję; D-221 zamyka
> inwentaryzację).
> Bieżący wynik weryfikacji: `CURRENT_STATE.md`.
> Starszy nagłówek PKG-0205 niżej opisuje poprzednie zamknięcie techniczne.

Status: **P9 — PRODUCT RESCUE & HYBRID REBUILD OTWARTE (D-168 / ADR-008);
PHASE-09 ZAMKNIĘTA; PHASE-10 ZAMKNIĘTA TECHNICZNIE (PKG-0182);
NIEZALEŻNY RED-TEAM PKG-0183 ZAMKNIĘTY TECHNICZNIE;
FINALNA RECERTYFIKACJA PKG-0184 ZAMKNIĘTA TECHNICZNIE;
PKG-0185 AUDYT OBSADY ZAMKNIĘTY; PKG-0186 CAST STYLE WDROŻONY;
PKG-0187 PEŁNY AUDYT OBRAZU, PKG-0188 P3 HYGIENE, PKG-0189 AUDYT GRANIC P3,
PKG-0190 CINEMATIC VIGNETTES, PKG-0191 CANONICAL-FACT ALIGNMENT I
PKG-0192 RETIREMENT CALLABLE P7 SURFACE (F-0184-012)
ZAMKNIĘTE TECHNICZNIE; KOLEJKA CR-A/B/C/D (PKG-0193/0194/0195/0196)
ZAMKNIĘTA TECHNICZNIE; ZERO REWIZJA WYCINEK 1 (PKG-0197) I WYCINEK 2
(PKG-0198) ZAMKNIĘTE TECHNICZNIE; F-0184-010 MRP RENDERER PILOT (PKG-0199)
ZAMKNIĘTY TECHNICZNIE (D-216/D-217); F-0184-010 MRP RENDERER SLICE2 (PKG-0200)
ZAMKNIĘTY TECHNICZNIE (D-218);
GATE-REL NADAL ZABLOKOWANE**
Data: 2026-09-06 (PKG-0199)

> **Stan po PKG-0187.** Pełny audit obejmuje 22 renderowane powierzchnie
> aktywnej trasy (20 adresów) w czterech trybach, 106 kadrów Windows i naprawy
> brył 03, 10–12 oraz finałów 42B/C. Raport:
> `docs/rebuild/PKG_0187_VISUAL_AUDIT.md`; dowody:
> `reports/pkg_0187/visual/`. Nie jest to PRODUCT GO.
> Recertyfikacja techniczna PHASE-10 (PKG-0184) pozostaje w mocy.
> `reports/pkg_0182/` … `pkg_0187/`. PKG-0188 przywrócił bramki 0091/0094,
> usunął pre-clamp eksportu PCM i wycofał nieroutowany donor CSV; raport:
> `docs/rebuild/PKG_0188_HYGIENE_REPORT.md`. Release zablokowany (D-168).
> PKG-0189 dopisał statyczną bramkę inventory dla F-0184-010/012 i raport
> `docs/rebuild/PKG_0189_RESIDUAL_BOUNDARY_SPEC.md`; nie zmienił gameplayu.
> **PKG-0190 dodał 5 cinematic vignettes** (VIG-01..04 + finałowa rodzina
> A/B/C) na trasie 01–18 → 42A/B/C → 43, na wprost zlecenie właściciela
> (D-206 przenumerował dawne zadanie „PKG-0190 canonical-fact" na
> **PKG-0191**). Audyt miejsc: `docs/rebuild/PKG_0190_CINEMATIC_PLACEMENT.md`;
> manifest generacji gen-ai: `docs/rebuild/PKG_0190_CINEMATIC_GENERATION_MANIFEST.md`;
> system: `scripts/cinematics/`; dowody: `reports/pkg_0190/cinematics/`.
> **PKG-0191 wdrożył F-0184-012**: 12 kanonicznych faktów `CAMPAIGN_MAP`
> dostały writer w Station 10–13 (13. fakt, `marta_relationship_disclosed`,
> miał już writer w `station_08.gd`), a synteza Station 13 wymaga teraz
> wszystkich trzech rodzin dowodu plus obu lokalnych markerów źródła przed
> zapisem `world_recognized` + `local_lena_search_committed`. Po drodze
> naprawiono realny bug (D-208): `GameStateManager`'s P7 legacy-save erasure
> tabele kasowały te same 13 nazw faktów przy każdym reloadzie, bo trasa P9
> nigdy nie znakuje `p7.*.migration_revision`. Nowa bramka:
> `tests/pkg_0191_canonical_fact_test.gd`. Nie jest to PRODUCT GO ani
> release.
> **PKG-0192 wycofał callable P7 surface z Station 10–13** (D-205 §4, drugi
> krok zależnościowy, po PKG-0191). Trzy jawne decyzje o elementach
> diegetycznych R4 (`HallwaySideboard`, `BalconyDoor`, `DeskDrawer`) — ZOSTAJĄ
> jako P9, udokumentowane w nagłówku każdej stacji. Wszystkie callable
> metody z D-205 pozostają callable (żaden MRP node ich nie wywołuje, jak
> przed pakietem), ale żaden aktywny writer nie pisze już nic pod
> `p7.foreign_daily_life.*` ani `p7.marta_threshold.*` — bookkeeping
> przeniesiony jeden-do-jednego pod `p9.threshold_obstacle.*`. Migracja
> legacy-save pozostaje funkcjonalnie bez zmian i idempotentna. Nowa bramka:
> `tests/pkg_0192_p7_retirement_test.gd`; `tests/pkg_0189_boundary_inventory_test.gd`
> odwraca kierunek asercji namespace'u P7 (obecność → nieobecność). Nie jest
> to PRODUCT GO ani release. F-0184-012 zamknięte technicznie. Sugerowany
> następny, niezależny krok: F-0184-010 MRP renderer extraction pilot (bez
> przydzielonego numeru).

P5–P8 pozostają zamknięte technicznie, a PKG-0154 jest prawdziwym dowodem
sprawności buildów, shellu, zapisu i kampanijnego runtime. Nie jest jednak
greenlightem produktu. Wiążąca diagnoza właściciela i board audit PKG-0155
odrzuciły obecną 43-adresową formę jako nieczytelną produktowo. Aktywna faza P9
zachowuje technologię Godot 4.7, lecz przebudowuje opening, hierarchię
informacji, rodziny lokacji, większość contentu i finał według
`PROJECT_REBUILD_EXECUTION_PLAN.md`.




## Kolejnosc wejscia w nowej sesji

1. `AGENTS.md` — twarde granice Godot-only, no-Git i zasady przeszkód.
2. `docs/CURRENT_STATE.md` — aktualna prawda runtime i ostatnia weryfikacja.
3. `docs/NEXT_SESSION_PROMPT.md` — jedyny aktywny pakiet.
4. Aktywna specyfikacja wskazana w `CURRENT_STATE.md`.
5. Źródła i testy nazwane w prompcie.
6. ADR-y i bible tylko w zakresie potrzebnym do decyzji pakietu.

Przed pierwszą edycją uruchom:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Projekt nie ma repozytorium ani historii Git. Pliki na dysku są jedynym stanem,
`SESSION_LOG.md` kroniką, a `snapshots/` zamrożeniem zamkniętych pakietów.

## Hierarchia prawdy

W razie sprzeczności:

1. aktualnie uruchomiony runtime i świeży wynik testów;
2. aktualny kod, sceny, zasoby i konfiguracja na dysku;
3. `CURRENT_STATE.md`, `NEXT_SESSION_PROMPT.md` i aktywna specyfikacja;
4. najnowsze zaakceptowane ADR-y i decyzje;
5. bible 0.3, plan przebudowy i roadmapa;
6. historyczne audyty, wpisy sesji, snapshoty i stare prompty.

Kod nie może służyć jako pretekst do pozostawienia niezgodnej dokumentacji.
Rozjazd naprawia ten sam pakiet. Snapshot jest zamrożoną kopią, nie źródłem
bieżącej prawdy.

## Dokumenty zywe

| Plik | Rola | Reguła |
|---|---|---|
| `CURRENT_STATE.md` | jeden aktualny stan projektu | zastąpić prawdą po każdym pakiecie |
| `NEXT_SESSION_PROMPT.md` | jeden samowystarczalny handoff | zawsze zastąpić aktualnym promptem |
| `SESSION_LOG.md` | chronologiczna historia pakietów | tylko dopisywać |
| `CREATIVE_REBUILD_PLAN.md` | historyczna kolejka P4–P7 i status zamkniętych fal | materiał dawcy, nie aktywny plan P9 |
| `P7_GAMEPLAY_DEPTH_IMPLEMENTATION_PLAN.md` | zamknięta mapa 15 sekwencji i migracji P7 | materiał dawcy dla mapy P9 |
| `ROADMAP.md` | fazy i meta wydania | aktualizować przy otwarciu/zamknięciu etapu |
| `PROJECT_REBUILD_EXECUTION_PLAN.md` | zaakceptowany board plan P9: HYBRID_REBUILD, target 20 adresów, 6 faz i 25 bundle'ów | jedyna aktywna kolejka odbudowy produktu |
| `decisions/ADR-008-hybrid-product-rebuild.md` | dlaczego technologia zostaje, a obecna forma gry nie | obowiązuje wszystkie pakiety P9 |
| `RISKS_AND_HYPOTHESES.md` | dowody, braki i ryzyka | nie zamieniać hipotez w fakty |
| `DECISION_LOG.md` | lekki rejestr decyzji | dopisywać zmianę, nie usuwać historii |
| `WORLD_SCALE.md` | Lena jest linijką; 1 m = 52 px | aktualizować przy zmianie metra |
| `PLAYTHROUGH_TRAVERSAL_AUDIT.md` | tabela przejścia 43 stacji | wypełniać w PKG-0132, nie spekulować |
| `FRAME_LAYOUT_AUDIT.md` | budżet pionowy kadru 640x360, etykiety, kolizje HUD | aktualizować przy zmianie kadru lub panelu |
| `PKG_0138_PLAYTHROUGH_REPORT.md` | sterowany przebieg 01→43: kadr, etykiety, wyjścia, lokomocja | aktualizować przy kolejnym pełnym przebiegu |
| `PKG_0130_FRAME_BUDGET_REPORT.md` | pomiar 60 Hz | aktualizować tylko przy nowym pomiarze |
| `PKG_0142_VISUAL_CERTIFICATION.md` | raport renderów 45 scen, trybów ruchu i ręcznej inspekcji | aktualizować przy kolejnym certyfikowanym przebiegu |

## Aktywne kontrakty P9

| Plik | Odpowiada za |
|---|---|
| `decisions/ADR-006-controlled-creative-rebuild.md` | dlaczego nie pełny reset i dlaczego nie stary content lock |
| `decisions/ADR-008-hybrid-product-rebuild.md` | dlaczego technologia zostaje, a obecna forma i trasa 43 adresów nie |
| `rebuild/PLAYER_CONTRACT.md` | tożsamość Leny, stawka i stan wiedzy po 1/5/30 minutach |
| `rebuild/CAMPAIGN_MAP.md` | trasa 01–18 → 42A/B/C → 43 oraz statusy legacy 19–41 (`KEEP / ADAPT / RETIRE`) |
| `rebuild/LOCATION_FAMILY_BIBLE.md` | siedem rodzin lokacji na pięciu osiach z testem monochromatycznym |
| `rebuild/ACCEPTANCE_MATRIX.md` | **czternaście** bramek produktu (§3 + §3a) i osobne werdykty `TECHNICAL PASS` / `PRODUCT GO` |
| `rebuild/EXECUTIVE_RELEASE_ASSESSMENT.md` | całościowy raport gotowości wydania dla właściciela, status 14 bramek i CHECKPOINT-06 GO |
| `PROJECT_REBUILD_EXECUTION_PLAN.md` | target 20 adresów, osiem faz, 31 bundle'ów i checkpointy GO/PIVOT/CUT |
| **`rebuild/PRESENTATION_REPAIR_PLAN.md`** | **specyfikacja nadrzędna PHASE-08**: osiem defektów prezentacji zgłoszonych przez właściciela 2026-09-02, z dowodami w kodzie, kolejnością pakietów i sześcioma nowymi bramkami |
| **`rebuild/AUDIT_IMPLEMENTATION_PLAN.md`** | **specyfikacja nadrzędna PHASE-09 (PKG-0179)**: całościowy plan wdrożenia zaleceń audytu 360°, eliminacji wycieków ObjectDB, unifikacji portretów i szlifu dialogów |
| **`rebuild/COMPREHENSIVE_GAME_AUDIT_AND_EVOLUTION_PLAN.md`** | **specyfikacja PHASE-10 / PKG-0182**: kompletne pokrycie gry, dowody, naprawy i kreatywna ewolucja |
| **`rebuild/PKG_0182_COMPREHENSIVE_AUDIT_REPORT.md`** | **raport wykonawczy PKG-0182**: coverage, findings, pomysły, pomiary, ograniczenia |
| **`PLUS_SESSION_PROMPT_2.md`** | **wykonany prompt PKG-0182 / BUNDLE-32** (zamknięty) |
| **`PLUS_SESSION_PROMPT_2_A.md`** | **wykonany prompt PKG-0183 / BUNDLE-33** (zamknięty) |
| **`rebuild/PKG_0183_INDEPENDENT_RED_TEAM_REPORT.md`** | **raport niezależnego red-team PKG-0183** |
| **`PLUS_SESSION_PROMPT_2_B.mm`** | **wykonany prompt PKG-0184 / BUNDLE-34** (zamknięty; plik `.md` nie istnieje) |
| **`rebuild/PKG_0184_FINAL_CERTIFICATION_REPORT.md`** | **raport końcowej niezależnej recertyfikacji PKG-0184** |
| **`rebuild/PKG_0185_CAST_VISUAL_AUDIT.md`** | **audyt postaci/portretów/NPC: 62 kadry, DEF-2/DEF-3 produktowo otwarte** |
| **`rebuild/CAST_UNIFICATION_REPAIR_PLAN.md`** | **specyfikacja PKG-0186 (wdrożona): jeden język Leny 4.1 dla całej obsady** |
| **`rebuild/PKG_0187_VISUAL_AUDIT.md`** | **raport PKG-0187: 22 powierzchnie renderowane, findings i 106 kadrów Windows** |
| **`rebuild/PKG_0190_CINEMATIC_PLACEMENT.md`** | **audyt miejsc PKG-0190: kandydaci na całej trasie, SELECT/REJECT z uzasadnieniem, kontrakt techniczny cinematic vignette** |
| **`rebuild/PKG_0190_CINEMATIC_GENERATION_MANIFEST.md`** | **manifest generacji gen-ai PKG-0190: model, referencje, prompty, odrzucone warianty, ręczne poprawki dla 14 finalnych PNG** |
| **`rebuild/PKG_0211_PROCEDURAL_AUDIO_CENSUS.md`** | **spis i pin silnika ProceduralAudio: 265 funkcji, kontrakt PCM 16-bit 44.1kHz, pętle, cache i drain** |
| **`rebuild/PKG_0238_DIALOGUE_BRIDGES.md`** | **raport PKG-0238: mosty dialogowe Pakiet E (E1–E3), domknięcie planu naprawy sensu fabularnego 2026-09-15** |
| `rebuild/CAST_AND_NPC_BIBLE.md` | wygląd, skala 84–92 px, `CharacterVisualRig` i pipeline `gen-ai` dla całej obsady |
| `rebuild/THRESHOLD_AND_ENTRY_CONTRACT.md` | `ThresholdZone`, trzy rodziny wejść, animacja stopni, drabiny i tabela skali otworów |
| `rebuild/PROGRESSION_FLOW_CONTRACT.md` | trasa zawsze przechodnia, rejestr luk i głos wewnętrzny zamiast twardych bramek |
| `rebuild/COLD_OPEN_SPEC.md` | zimne otwarcie w dwóch warstwach: sekwencja ustawiająca i grywalny prolog |
| `decisions/ADR-007-character-first-narrative-revolution.md` | dlaczego kanon 0.2 wymagał relacyjnej rewolucji |
| `NARRATIVE_SKILL_AUDIT_0_2.md` | findings S1–S2, adaptacja skilli i werdykt REJECT |
| `CREATIVE_REBUILD_PLAN.md` | zakres zachowany/przebudowany, wynik rekoncyliacji PKG-0117 i kolejność wycinków |
| `GAMEPLAY_DEPTH_VISION.md` | kierunek P7: aktywne sekwencje diagnozy, próby i zobowiązania |
| `P7_GAMEPLAY_DEPTH_IMPLEMENTATION_PLAN.md` | konkretna mapa P7, granice danych, migracja save i status wszystkich 15 sekwencji domkniętych przez PKG-0151 |
| `LENA_CHARACTER_AND_ANIMATION.md` | nowa postać, rig, stany i kryteria animacji |
| `PLAYER_GUIDANCE_AND_INNER_VOICE.md` | pokaż → naprowadź → pomyśl, zastój i omylne interpretacje |
| `PIXEL_PRESENTATION_ARCHITECTURE.md` | pikselizowany świat i ostre warstwy tekstu |
| `../VISUAL_DESIGN.md` | Rówień Pixel-Stage i reżyseria obrazu |
| `TRAVERSAL_AND_OBSTACLE_DESIGN.md` | dozwolone wyzwania, zakaz arcade, skok ≠ lokomocja, próg 18 px |
| `WORLD_SCALE.md` | jedna skala mebli i Leny |

## Kanon narracyjny 3.0 — materiał źródłowy P9

| Plik | Odpowiada za |
|---|---|
| `PRODUCT_BRIEF.md` | krótka obietnica produktu i filary |
| `PROJECT_BIBLE.md` | nadrzędny kierunek produkcyjny |
| `narrative/NARRATIVE_BIBLE.md` | Linia 4, dwie Leny, relacje, UCP i bramy 21/22 |
| `narrative/FULL_STORY.md` | osiem sekwencji oraz pętle Station 01–43 |
| `narrative/CONTINUITY_TRACKER.md` | dwie tajemnice, wiedza, clue ledger, zgody i finały |
| `narrative/DIALOGUE_SCRIPT.md` | agendy, odrębne głosy, podtekst i omylne myśli |

Najważniejszy kontrakt: 01–05 normalność z konfliktem próbka/obietnica, 06–20
eskalacja bez diagnozy, Station 21 rozpoznanie „To nie jest mój świat”,
Station 22 pierwsze świadome Anchor/Yield. Od 21 głównym pytaniem staje się los
miejscowej Leny i koszt Linii 4; każdy finał pokazuje stan obu Len.

P9 zachowuje osoby, relacje, dwie tajemnice i koszt Linii 4 jako materiał
źródłowy, lecz BUNDLE-02..03 przeliczą progi oraz topologię na target
01–18 → 42A/B/C → 43. Do ich zamknięcia nadrzędne są D-168, ADR-008
i `PROJECT_REBUILD_EXECUTION_PLAN.md`.

## Dokumenty techniczne i procesowe

| Plik | Rola |
|---|---|
| `TECHNICAL_DIRECTION.md` | architektura Godot, InputMap, viewport i moduły |
| `WORKFLOW.md` | start, Definition of Done, weryfikacja i snapshot |
| `RESEARCH_FOUNDATIONS.md` | źródła i ograniczone wnioski researchu |
| `INSPIRATION_BOUNDARIES.md` | granice inspiracji i ryzyka podobieństwa |
| `PROTOTYPE_01_MOVEMENT_LAB.md` | historyczny kontrakt ruchu bazowego |
| `PLAYTEST_01.md` | model dowodu bez zewnętrznych testerów |
| `decisions/ADR-001-godot-pc-first.md` | wybór silnika i platformy |
| `decisions/ADR-002-evidence-gated-prototypes.md` | bramki prototypów |
| `decisions/ADR-003-evidence-model-without-external-testers.md` | granice wniosków |
| `decisions/ADR-004-ai-autonomy.md` | autonomia roli |
| `decisions/ADR-005-mechanics-threshold-pivot.md` | historyczny pivot Anchor |

## Dokumenty historyczne / nieaktywne jako plan

- `IMPLEMENTATION_PLAN_AUDIT_AND_RELEASE_READINESS.md` opisuje stan przed
  D-113; jego droga R2 content lock → build jest zastąpiona przez plan 3.0.
- Kanon 0.2 zachowany w snapshotcie PKG-0116 jest audytowanym projektem
  pośrednim, nie aktywną prawdą. Audyt wskazuje jego dokładne źródło.
- `VECTOR_STAGE_ART_DIRECTION_AUDIT.md` i audyty `VECTOR_STAGE_*` są dowodem
  dawnego runtime, nie aktywnym kanonem powierzchni obrazu.
- `TRAVERSAL_ACT_*_AUDIT.md` zachowują fakty o istniejących colliderach; ponowne
  autorstwo nadal podlega nadrzędnemu kanonowi przeszkód.
- Snapshoty i stare `NEXT_SESSION_PROMPT.md` w zamrożeniach nie są czytane jako
  stan bieżący.
- `archive_retired_web/` jest martwym artefaktem poza projektem gry.

## Protokol przekazania

Pakiet kończy się dopiero po:

1. testach proporcjonalnych do zmiany;
2. synchronizacji kodu, kanonu i dokumentacji;
3. wpisie append-only w `SESSION_LOG.md`;
4. zastąpieniu `CURRENT_STATE.md` i `NEXT_SESSION_PROMPT.md`;
5. pełnym `tools/verify.ps1` z kodem 0;
6. dla obrazu — świeżych capture'ach normalnym driverem i inspekcji;
7. snapshotcie `tools/snapshot.ps1 -Package PKG-NNNN`.

Test lub render dowodzi wyłącznie mierzonego kontraktu, nie zabawy, emocji,
zrozumienia ani odbioru przez zewnętrznego gracza.
