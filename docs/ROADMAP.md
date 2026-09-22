# Roadmapa: Getting Strange

2026-09-15: kolejka sensu ze swiezego planu
`docs/narrative/SENS_FABULARNY_PLAN_NAPRAWY_2026-09-15.md` (D-246):
A → C → B → D → E, jeden pakiet na sesje. PKG-0234 (Pakiet A, duchy)
DONE. PKG-0235 (Pakiet C, luki P9) DONE. Nastepna sesja: PKG-0236
Pakiet B (ciecia, nie teleporty). To nie jest Pakiet B z wyczerpanego
planu PKG-0231. GATE-REL / PRODUCT GO nadal BLOCKED BY D-168.

2026-09-14: PKG-0231 przeprowadzil swiezy audyt sensu aktywnej kampanii bez
oparcia na poprzednich analizach. Werdykt STORY-SENSE CONCERNS materializuje
blokade produktu mimo pelnego TECHNICAL PASS: rdzen historii zostaje, ale
przed PRODUCT GO trzeba wdrozyc
`rebuild/PKG_0231_STORY_SENSE_REPAIR_PLAN.md`. Kolejnosc: (1) inwariant
przejsc/wiedzy + atomowy final/epilog, (2) chronologia/rekwizyty, (3) geografia,
fokalizacja i wyplata kosztow. Raport:
`rebuild/PKG_0231_FRESH_STORY_SENSE_AUDIT.md`; D-243; R-053..R-057.

2026-09-05: na polecenie właściciela aktywną kolejką autorstwa jest
`rebuild/CREATIVE_REVIEW_AND_EXPANSION_PLAN.md`: CR-A (PKG-0193) → CR-B
(PKG-0194) → CR-C (PKG-0195, wpis uzupełniony w PKG-0196) → CR-D
(PKG-0196, w trakcie zamykania), po jednym zamykanym
mega-pakiecie. Refaktor MRP F-0184-010 jest
niezależny. Werdykty produktu i blokada wydania D-168 nie zmieniają się.

Status: **P9 — PRODUCT RESCUE & HYBRID REBUILD (D-168 / ADR-008)**  
Data: 2026-08-31  
Decyzja: `ADR-008`, `D-168`  
Szczegółowy plan wykonawczy: `PROJECT_REBUILD_EXECUTION_PLAN.md`

## Meta produktu

Ukończona, samodzielna gra narracyjna 2D w Godot 4.7 na Windows i Linux. Lena
wraca z rutynowego pomiaru do miasta, które przez długi czas wydaje się jej
własne. Dopiero po 21 przestrzeniach potrafi udowodnić, że żyje w innej
ciągłości; wtedy pierwsza tajemnica ustępuje drugiej: co zrobiła miejscowa Lena,
gdzie została uwięziona i kto zapłaci za rozdzielenie światów.

Meta obejmuje kampanię 20 odwiedzanych adresów — Station 01–18 liniowo, jeden
wariant 42A/B/C i Station 43 — pełny przebieg od tytułu do konsekwencji,
ludzką postać Leny, siedem rozpoznawalnych rodzin lokacji, ostre teksty,
zapis, dostępność oraz jawny pakiet licencyjny. Kontrakt gracza:
`docs/rebuild/PLAYER_CONTRACT.md`; mapa trasy: `docs/rebuild/CAMPAIGN_MAP.md`.

Istnienie 45 technicznych zasobów scenicznych nie jest content lockiem. Po
D-168 droga do mety prowadzi przez HYBRID_REBUILD: stacje 19–41 są wyłącznie
dawcami materiału z jawnym statusem `KEEP / ADAPT / RETIRE`, a wydanie gry
wymaga osobnych werdyktów `TECHNICAL PASS` i `PRODUCT GO`
(`docs/rebuild/ACCEPTANCE_MATRIX.md`).

## Co zachowujemy, co przebudowujemy

| Obszar | Status | Decyzja |
|---|---|---|
| Godot 4.7, 640x360, 60 Hz, InputMap | zachowany | nie przepisywać bez regresji blokującej |
| ruch i fizyka `PrototypePlayer` | zachowane jako baseline | oddzielić mechanikę od produkcyjnego `LenaVisualRig` |
| shell, pauza, ustawienia i PL/EN UI | technicznie działają | utrzymać |
| zapis i topologia 01..41 → finał → 43 | technicznie działają | migrować treść bez zerwania trasy |
| proceduralne audio i CRT | infrastruktura | adaptować do scen 0.3 |
| Anchor Lab | techniczny prototyp | przenieść do kampanii od Station 22 |
| Lena, Marta, Jakub, Wierzbicka, UCP i Rówień | zachowany rdzeń | nowe cele, relacje i przyczynowość z biblii 0.3 |
| treść 01–43, stare dialogi i kadry | `LEGACY` | ponownie stworzyć sekwencjami |
| proceduralny rysunek Leny | `PLACEHOLDER` | zastąpić czytelnym rigem produkcyjnym |
| gładki Vector-Stage | częściowo zastąpiony | Pixel-Stage dla świata, ostre warstwy tekstu |

## P4-RB0 — Rebaseline kreatywny

Pakiet: **PKG-0116**  
Status: **ZAKOŃCZONY HISTORYCZNIE; KANON 0.2 ZASTĄPIONY PRZEZ D-114**

Pakiet ustanowił zachowywany szkielet techniczny, bramę Station 21/22, kontrakt
Leny, prowadzenie i architekturę Pixel-Stage. Jego kanon fabularny 0.2 był
projektem pośrednim. Audyt `NARRATIVE_SKILL_AUDIT_0_2.md` wykazał, że nie ma
wystarczającego silnika osobistego, aktywnej opozycji ani konkretnych finałów.

## P4-RB1 — Rewolucja narracji + audyt rekoncyliacyjny

Pakiet: **PKG-0117**  
Status: **ZAKOŃCZONY; RUNTIME 01–07 NIE JEST CONTENT LOCKIEM**

Jeden mega-pakiet łączy:

1. kanon narracyjny 0.3, audyt skilli i `ADR-007`;
2. rozpoznanie oraz klasyfikację zastanych zmian Foundation Slice;
3. techniczny smoke `LenaVisualRig`, `WorldPixelCompositor`, crisp text i
   `NarrativeGuidanceService`;
4. jawne oddzielenie użytecznej architektury od treści zdradzającej zwrot;
5. nowy plan wdrożenia zaczynający się od 01–07.

Bramka:

- kanon i roadmapa nie nazywają częściowego runtime ukończonym wycinkiem;
- wszystkie zastane elementy mają status `KEEP / ADAPT / RETIRE`;
- testy techniczne zachowują pokrycie, lecz nie dowodzą jakości artystycznej;
- pełna weryfikacja, inspekcyjny capture, dokumenty i snapshot są świeże.

## P4-RB2 — Foundation Slice 01–07

Pakiet: **PKG-0118**  
Status: **ZAKOŃCZONY**

- konflikt próbki Linii 4 i obietnicy Marty w 01;
- zwykłe obejście 02, wiadomość 03, przejazd 04 i znana ulica 05;
- dwa rozkłady 06 oraz kiosk/herbata dla Marty 07;
- produkcyjna anatomia i 13 stanów `LenaVisualRig`;
- działająca pikselizacja świata `WorldPixelCompositor`, ostre teksty `CrispDiegeticText` i omylne guidance `NarrativeGuidanceService`;
- usunięcie aktywnych anomalii, żywego Jakuba i jawnego UCP z prologu.

Bramka: 01–05 są całkowicie normalne, 06–07 mają wyłącznie racjonalizowalne
rysy, a trasa, zapis, restart, tekst, guidance i ruch przechodzą testy (exit code 0).

## P4-RB3 — Rysa i cudzy dom 08–13

Pakiet: **PKG-0119**  
Status: **ZAKOŃCZONY**


- numer czternaście, sąsiadka, klucz, fotografia, wiadomość głosowa i dwa
  różniące się wspomnienia;
- pierwsze ślady relacji Marty z miejscową Leną bez jawnej diagnozy;
- aktorski zestaw progów, oglądania, wahania i obronnej racjonalizacji;
- GuidanceBeats prowadzące do sprawdzenia hipotez, nie do przyjęcia prawdy;
- wszystkie czytelne napisy ponad kompozytorem.

Bramka: do końca 13 Lena wie, że nie potrafi wyjaśnić sprzeczności, ale nadal
nie wie, w jakim świecie jest. Każdy fakt ma przynajmniej jedną uczciwą
codzienną interpretację.

Dowód: `tests/pkg_0119_smoke_test.gd` PASS, `tools/verify.ps1` exit code 0,
świeże klatki `reports/station_08..13*.png`.

## P4-RB4 — Marta, UCP i rozpoznanie 14–23

Pakiet: **PKG-0120**  
Status: **ZAKOŃCZONY**

- konflikt Marty z przybyłą Leną, wspomnienie terenu, dokumentacja UCP i żywy
  Jakub;
- trzy niezależne rodziny dowodów i interaktywna synteza w Station 21;
- pierwsze `To nie jest mój świat` wyłącznie po spełnieniu kontraktu wiedzy;
- Station 22 rozpoczyna drugą tajemnicę i świadomy Anchor/Yield;
- Station 23 dostarcza pierwszy ślad miejscowej Leny, nie rozwiązanie.

Bramka: `world_recognized` wymaga kompletu dowodów, a `local_lena_search_started`
nie może zostać ustawione wcześniej niż po rozpoznaniu.

Dowód: `tests/pkg_0120_smoke_test.gd` PASS, `tools/verify.ps1` exit code 0,
świeże klatki `reports/station_14..23*.png`.

## P4-RB5 — Test wzajemny 24–30

Pakiet: **PKG-0121**  
Status: **ZAKOŃCZONY**

- kampanijna integracja Anchor/Yield z istniejącego prototypu;
- mechaniczne odtworzenie części próby miejscowej Leny;
- Marta i Jakub stawiają warunki oraz mogą odmówić udziału;
- widoczne koszty stabilizacji i trzy prognozy operacyjne;
- pętla obserwacja → hipoteza → czynność → konsekwencja w każdej przestrzeni.

Bramka: każda czynność ma funkcję świata, stan przed/po, uczciwą podpowiedź i
trwałą konsekwencję w zapisie; nie powstają przeszkody arcade.

Dowód: `tests/pkg_0121_smoke_test.gd` PASS, `tools/verify.ps1` exit code 0,
świeże klatki `reports/station_24..30*.png`.

## P4-RB6 — Rachunek Linii 4 31–38

Pakiet: **PKG-0122**  
Status: **ZAKOŃCZONY**

- Wierzbicka jako aktywna, racjonalna przeciwniczka, nie automat ekspozycyjny;
- ujawnienie przenoszonego kosztu Linii 4 i warunku przerwania próby;
- miejscowa Lena odzyskuje sprawczość przez zapisane decyzje i stan sygnału;
- Marta oraz Jakub odmawiają roli nagrody lub długu;
- przygotowanie trzech metod bez zakodowanego „dobrego” finału.

Bramka: gracz zna przewidywane koszty dla obu Len, Marty, Jakuba, UCP i obu
ciągłości przed wejściem do finału.

## P4-RB7 — Metoda, konsekwencje i content lock 3.0

Pakiet: **PKG-0123**  
Status: **ZAKOŃCZONY (CONTENT LOCK 3.0 OSIĄGNIĘTY DLA WSZYSTKICH 43 STACJI)**

- Station 38–41 jako zgody, ostatni impuls, pulpit wyboru i komora z trzema konsolami;
- 42A wymuszenie powrotu, 42B zamknięcie Równi, 42C przejście wzajemne;
- 43 pokazuje konkretny stan obu Len, Marty, Jakuba, UCP i relacji miast na tablicach i rozkładach;
- finalna integracja Pixel-Stage, CrispDiegeticText, CRTDialogueBox i NarrativeGuidanceService;
- end-to-end od Nowej gry, przez rozgałęzienia 42A/B/C, aż po epilog 43 i czysty powrót do tytułu.

Bramka: brak aktywnej treści legacy; żadna rodzina zakończeń nie otrzymuje
ukrytej etykiety moralnej; pełny przebieg, routing, zapis, restart i ostre teksty
przechodzą automatyczne testy techniczne (exit code 0).

Dowód: `tests/pkg_0123_smoke_test.gd` PASS, `tools/verify.ps1` exit code 0,
świeże klatki `reports/station_38..43*.png`.

## P5 — Build, release candidate i mechaniczny szlif

Pakiety: **PKG-0124 (Release Candidate 1), PKG-0125 (Lena 3.0, Wspinaczka, Dwukierunkowość), PKG-0126 (Szlif atmosferyczny, Soundscapes, Cząsteczki, CRT Pacing), PKG-0127 (RAM Lifecycle, Sound Cache, Bidirectional Topology, Contrast Audit), PKG-0128 (Golden Master Audit, Long-Session Soak Simulation, Device Parity & Integrity Certification), PKG-0129 (Global Traversal Geometry Audit, Diegetic Ladders & Lifts, Full Traversal Certification), PKG-0130 (Frame Budget 60 Hz, Particle Determinism, Pixel-Grid Camera Coherence)**
Status: **ZAKOŃCZONE SUKCESEM — FAZA P5 ZAMKNIĘTA**

1. `export_presets.cfg`, wersja 1.0.0, wektorowa ikona `icon.svg` i buildy Windows/Linux w `dist/`.
2. Dedykowany smoke test `tests/pkg_0124_smoke_test.gd` i skrypt exportu `tools/export_builds.ps1`.
3. Kontynuacja, reset, remapping 5 akcji, ustawienia, dostępność i bilingualizm PL/EN.
4. Budżet wydajności kompozytora 60 Hz i brak `draw_string` w Layer 0 na wszystkich 43 stacjach.
5. Licencje `docs/LICENSES.md`, credits w epilogu 43 oraz oficjalne `docs/RELEASE_NOTES.md`.
6. Przebudowa postaci Leny Wolskiej (`LenaVisualRig 3.0`, 14 stanów animacji, proporcje kobiece 1:6.7, wysokość ~66 px, laboratoryjny prochowiec).
7. Diegetyczne drabiny (`LadderZone`) i windy (`ServiceLift`) z wejściami `move_up`/`move_down` bez platformingu (D-099).
8. Dwukierunkowa nawigacja i cofanie w `GameStateManager` (`get_previous_campaign_station`, `target_spawn_side`).
9. Rozbudowa syntezy proceduralnego audio o 12 nowych pejzaży dźwiękowych zero-asset (chłodnie, wysokie napięcie, hydraulika, podstruktura, motywy finałowe 42A/B/C, tinnitus, szum miejski, rezonans tuneli i świt).
10. Wieloprofilowe oświetlenie wektorowe w `AtmosphereRig` (neony sodowe, ekrany UCP, reflektory gabinetu 40, filary komory wyboru 41, światło świtu 43).
11. Mikrodynamiczne cząsteczki pary wentylacyjnej `VentSteam` oraz pyłu `VolumetricDust` na stacjach przemysłowych i podstruktury.
12. Balans tempa CRT, dwell time i rozszerzona matryca barw rozmówców (`SPEAKER_COLORS`).
13. Zarządzanie cyklem życia pamięci RAM: deterministyczny cache fal dźwiękowych `ProceduralAudio.get_cached_sound()`, czyszczenie `clear_sound_cache()` podczas przejść scenicznych i restartu kampanii oraz zwolnienia `_exit_tree()` w `AtmosphereRig` eliminujące wycieki ObjectDB.
14. Globalna walidacja i certyfikacja 45 scen (01..41, 42a, 42b, 42c, 43), warstw CanvasLayer (10, 16, 20, 100, 110) oraz kontrastu barw mówców WCAG AA/AAA.
15. Ścisłe zachowanie zakazu generowania plików `.exe` i paczek binarnych po pakiecie (weryfikacja bramką `pkg_0127_smoke_test.gd`).
16. 2-cyklowa symulacja obciążeniowa (Soak Simulation) obejmująca wszystkie 45 scen, ze ścisłym ograniczeniem bufora audio cache (<= 150 pozycji, faktycznie 19) i deterministycznym resetem/zapisem/odczytem `GameStateManager`.
17. Certyfikacja pełnej parzystości klawiatura/pad dla akcji wejścia, remap z zachowaniem przypisań drugiego kontrolera (`_replace_event_of_matching_type`) oraz zero stałych `KEY_*` w skryptach poziomów i rozgrywki.
18. 100% symetria i kompletność bilingwalnego słownika `LocalizationManager` (PL/EN) oraz zgodność dialogów/napisów końcowych Stacji 43 z `docs/LICENSES.md`.
19. Globalny audyt drożności geometrii 45 scen (`tools/geometry_audit.gd`, `tests/pkg_0129_smoke_test.gd`): 0 blokujących barier > 35 px bez drabiny, windy lub `one_way_collision = true`.
20. Remediacja Stacji 01, 09, 11, 25, 30, 32, 34, 37 za pomocą diegetycznych drabin `LadderZone` i wind `ServiceLift`, certyfikacja wspinaczki, audio szczebli, animacji i fizyki platform.

21. Kontrakt `ParticleBudget` (30 Hz, `fract_delta = false`) na wszystkich fabrykach emiterów; cache 18 tekstur świateł zamiast 163; snap kamery i wstrząsu do siatki 2 px; klamrowane śledzenie pionowe w szybach.
22. Pomiar realny 60 Hz na Intel Iris Xe: najgorsze p99 = 14.448 ms wobec 16.66 ms; raport `docs/PKG_0130_FRAME_BUDGET_REPORT.md`.

## P6 — Human Scale & Playability

Pakiety: **PKG-0131..0142 zamknięte**
Status: **ZAMKNIĘTA — PKG-0142**

Wykonane w PKG-0134:

1. Live walk wszystkich 45 scen (`campaign_playability_audit.gd`).
2. `try_curb_step` 18 px; `ExitClearance` na drzwiach i przegrodzie 26.
3. GATE_STORY nazwane: 12, 14, 15, 19, 20, 21.

Wykonane w PKG-0136..0142:

4. Lena 4.1, cykl napędzany przebytym dystansem, kadr dialogowy i malowany fartuch (D-129..D-137).
5. Playthrough 01→43 wyłącznie czasownikami gracza (D-141), `ReturnZone` na 42 stacjach (D-142).
6. Pejzaż per Akt, materialność kroków, blipy mowy per mówca (D-143..D-145).
7. Sprzężenie Anchor/Yield, haptyka interakcji, tłumienie kadru w transporcie pionowym (D-146..D-149).
8. Jeden kontrakt kamery kinowej na 45 stacjach i tryb ograniczonego ruchu (D-150, D-151).
9. Prawa krawędź stacji 01 jest funkcjonalną scenografią `airlock_bulkhead` (D-152).
10. Normal-driver capture 45 scen w dwóch trybach oraz osobne kadry dialogowe 01, 33, 38, 41, 42A, 42B, 42C i 43.

P6 nie ma otwartych punktów technicznych. Hipotezy odbiorcze pozostają jawne
w `RISKS_AND_HYPOTHESES.md` zgodnie z ADR-003.

Zakaz `.exe` (D-125).

## P6-odroczone (nie otwierać przed PKG-0135)

Kolejka **pusta**. Historyczne punkty zostały zamknięte w kolejnych pakietach:

- ~~Unifikacja `Camera` vs `Camera2D` w stacjach 33–43.~~ Zamknięte w PKG-0141 (D-150).
  Realny zasięg okazał się szerszy niż zapisany: 22 stacje 24–43, nie 13.
  Wszystkie 45 stacji mają teraz jeden kontrakt kamery (`StationCameraRig`).
- ~~Reduced-motion / tłumienie flickeru 100 Hz i cząstek.~~ Zamknięte w PKG-0141 (D-151).
  Jeden przełącznik dostępności w `SettingsOverlay` tłumi migotanie, pulsowanie,
  wstrząs kamery, oddech pola kotwiczenia i emisję mikro-cząstek.
- ~~Prawa krawędź stacji 01 i certyfikacja normal-driver.~~ Zamknięte w PKG-0142 (D-152).
  `airlock_bulkhead` zastąpił czarny klin, a 106 świeżych renderów normal/reduced
  ma raport różnic i ręcznie obejrzane kadry reprezentatywne.

## P7 — Gameplay Depth Rebuild

Pakiety: **PKG-0143 (wizja, zamknięty) → PKG-0144 (plan, zamknięty) →
PKG-0145 (S08, PROCEED) → PKG-0146 (S01–S05, akceptacja techniczna) →
PKG-0147 (S06–S07, akceptacja techniczna) → PKG-0148 (S09–S10, akceptacja
techniczna) → PKG-0149 (S11–S13, akceptacja techniczna) → PKG-0150 (S14–S15,
akceptacja techniczna) → PKG-0151 (finałowy audyt P7, zamknięty)**
Status: **ZAMKNIĘTA — wszystkie 15 sekwencji diagnostycznych S01–S15 dla 43 adresów
i 45 zasobów scenicznych zostało zaimplementowanych, zintegrowanych i domkniętych
pełnym audytem technicznym (D-164).**

PKG-0151 domknął P7 przez trzy warstwy dowodu technicznego:
1. `tests/pkg_0151_smoke_test.gd` potwierdza 15 `DiagnosticSequenceDefinition`,
   wyjątek bramki S08/S09 (`world_recognized` oraz `p7.three_place_proofs.trace`),
   routing finałów A/B/C, migracje checkpointów oraz round-trip kanonicznych faktów końca.
2. `tools/verify.ps1` przechodzi PASS z dołączoną bramką PKG-0151.
3. `tools/capture_pkg_0151.gd` + `tools/diff_pkg_0151_capture.gd` certyfikują 36
   reprezentatywnych kadrów kampanii (18 stanów × normal/reduced), wszystkie 640×360,
   niepuste i rozróżnialne w kluczowych parach stanów.

Werdykt zamyka wyłącznie kontrakty techniczne: stan, routing, zapis, migrację,
warstwy scen i reprezentatywne powierzchnie obrazu. Nie jest dowodem odbioru,
czytelności, emocjonalnej siły ani komfortu człowieka.

## P8 — Release Candidate Readiness

Pakiety: **PKG-0152 (audyt powierzchni release, presety, manifest, guard D-125) →
PKG-0153 (runtime release surface: credits/licence + wersja) →
PKG-0154 (build/rehearsal, clean-install, RC verdict)**  
Status: **ZAMKNIĘTA TECHNICZNIE — świeży release candidate został zbudowany i uruchomiony, a P8 nie ma już otwartych blockerów kontraktowych.**

PKG-0152 domknął pierwszy krok P8:
1. dodał bramkę `tests/pkg_0152_smoke_test.gd` i wpiął ją do `tools/verify.ps1`;
2. zsynchronizował `docs/LICENSES.md` i `docs/RELEASE_NOTES.md` z runtime po P7;
3. wyczyścił presety z lokalnych ścieżek template'ów i ustawił `tools/export_builds.ps1` na audit-first z jawną blokadą D-125;
4. odciął `assets/characters/lena/raw/` i `logs/` od powierzchni release przez `.gdignore`;
5. wydał werdykt: brak gotowości do nowego pakietu release bez remediacji runtime credits/licence surface, wersji i świeżej próby build/rehearsal.

PKG-0153 domknął drugi krok P8:
1. Station 43 pokazuje runtime credits/licence surface przez dwa jawne panele diegetyczne zgodne z `docs/LICENSES.md`;
2. ekran tytułowy buduje etykietę wersji z `ProjectSettings`, viewportu i tick rate zamiast z twardego stringa;
3. `tests/pkg_0153_smoke_test.gd` i `tools/capture_pkg_0153.gd` domykają bramkę oraz świeże evidence wizualne dla tej powierzchni;
4. werdykt przesuwa P8 z remediacji na build/rehearsal — bez twierdzenia, że RC jest już dowiedziony.

PKG-0154 domknął trzeci krok P8:
1. `tools/export_builds.ps1 -AllowBinaryBuild` auto-instaluje zgodne standardowe template'y 4.7.2 i tworzy świeże artefakty Windows/Linux;
2. `export_presets.cfg` quarantinuje powierzchnię release (`docs/`, `tests/`, `tools/`, `godot-mcp/`, `vibe-eyes/`, logi i inne artefakty nietworzące gry), a `tests/pkg_0154_smoke_test.gd` pilnuje tego kontraktu;
3. Windows build poza edytorem przeszedł clean-install/save/continue rehearsal z evidence w `reports/pkg_0154/` i zapisem schema 1;
4. Linux build uruchomił się pod WSL, pokazał poprawny shell/build label i przeszedł `new_game` / `continue` do `Station01`;
5. pełne `tools/verify.ps1` wróciło na PASS z nową bramką PKG-0154.


## P9 — Product Rescue & Hybrid Rebuild

Pakiety: **PKG-0155 → PKG-0156 (CHECKPOINT-01 GO) → PKG-0157/0158
(runtime 01–08) → PKG-0159 (recertyfikacja: CHECKPOINT-02 GO,
CHECKPOINT-03 PIVOT, GATE-FAM 4/7) → PKG-0160/0161 (PHASE-04,
CHECKPOINT-04 GO, GATE-FAM 7/7) → PKG-0162/0163/0164 (PHASE-05,
Station 14–16)**  
Status: **OTWARTA — PHASE-05 ACTIVE**

Wiążąca diagnoza właściciela unieważnia produktowy greenlight obecnej formy:
gracz nie zna swojej tożsamości, celu, motywacji ani zasad świata, a rodziny
lokacji są nierozróżnialne. PKG-0154 pozostaje dowodem technicznym i materiałem
dawcy; nie jest zgodą na wydanie.

Obowiązują:

1. ścieżka `HYBRID_REBUILD`;
2. zachowanie sprawnej technologii Godot 4.7;
3. ponowne autorstwo openingu, pierwszych 30 minut, rodzin lokacji, większości
   contentu i finału;
4. target 18 adresów liniowych → jeden wariant 42A/B/C → Station 43, czyli
   20 odwiedzanych adresów na przebieg;
5. stacje 19–41 jako dawcy `KEEP / ADAPT / RETIRE`, nie obowiązkowa trasa;
6. osobne werdykty `TECHNICAL PASS` i `PRODUCT GO`;
7. release oraz nowe `.exe` zablokowane do nowego produktowego GO i osobnego
   polecenia właściciela.

Plan, sześć faz, 25 bundle'ów i checkpointy GO/PIVOT/CUT:
`docs/PROJECT_REBUILD_EXECUTION_PLAN.md`.

PKG-0156 domknął PHASE-01 (BUNDLE-01..05) bez zmian runtime:

1. zamrożono fałszywy produktowy RC — żaden aktywny dokument nie prowadzi do
   eksportu obecnej formy;
2. `docs/rebuild/PLAYER_CONTRACT.md` ustanawia tożsamość Leny, stawkę i stan
   wiedzy po 1/5/30 minutach;
3. `docs/rebuild/CAMPAIGN_MAP.md` ustanawia trasę 01–18 → 42A/B/C → 43 oraz
   statusy wszystkich stacji legacy 19–41 (`ADAPT` 17, `RETIRE` 6, `KEEP` 0)
   wraz z re-origination wszystkich 33 flag kanonicznych;
4. `docs/rebuild/LOCATION_FAMILY_BIBLE.md` definiuje siedem rodzin lokacji na
   pięciu osiach różnicowania z testem monochromatycznym;
5. `docs/rebuild/ACCEPTANCE_MATRIX.md` rozdziela `TECHNICAL PASS` od
   `PRODUCT GO` i rejestruje dry-run bieżącego runtime jako `PRODUCT FAIL`;
6. bramka `tests/pkg_0156_smoke_test.gd` pilnuje tych kontraktów w
   `tools/verify.ps1`;
7. CHECKPOINT-01: **GO** — otwarta jest PHASE-02 (First Five Minutes).

PKG-0157 domknął PHASE-02 (BUNDLE-06..10) — First Five Minutes:

1. BUNDLE-06 (Shell product promise): `TitleScreen` bez żargonu QA i bez listy
   sterowania w pierwszym kadrze, obietnica powrotu przez Linię 4 do Marty,
   sprawny loop focusu i save;
2. BUNDLE-07 (Station 01 worksite): jedno stanowisko diagnostyki drgań i dwie
   kontynuowalne drogi `repeat_sample|leave_on_time`, różne stany torby oraz
   różne odpowiedzi Marty; GATE-01 PASS po recertyfikacji;
3. BUNDLE-08 (Station 02 outdoor detour): otwarte niebo >25%, nocne obejście robót,
   drabina nasypu serwisowego (LadderZone), próg ≤18px;
4. BUNDLE-09 (Station 03 transit stop): wiata przystankowa, krawędź toru, rozkład
   Linii 4, ruch i zatrzymanie wagonu, odpowiedź Marcie;
5. BUNDLE-10 (Station 04 transit ride): wnętrze wagonu, ruchoma paralaksa okien,
   sylwetka pomnika Linii 4 za oknem, odłożenie czytnika do torby; GATE-05 PASS;
6. Budżet interakcji ≤3 na każdy adres (GATE-INT PASS);
7. Bramka `tests/pkg_0157_smoke_test.gd` oraz 18 kadrów normal/reduced w `reports/pkg_0157/`;
8. CHECKPOINT-02: **GO po recertyfikacji PKG-0159** — ciągły M1 01–04 PASS.

PKG-0158 domknął PHASE-03 (BUNDLE-11..15) — First Thirty Minutes:

1. BUNDLE-11 (Station 05 home street baseline): miejski baseline nocnej ulicy Sadowej,
   fasady i latarnie pod otwartym niebem >25%, sprawdzenie trasy i próbki, przejście przez ulicę;
2. BUNDLE-12 (Station 06 kiosk contradiction): kiosk i rozkład Linii 4 ("SADOWA 14"),
   zeznanie sprzedawcy potwierdzające trasę i dom Leny, pytanie kontrolne;
3. BUNDLE-13 (Station 07 building exterior): fasada kamienicy, materialny konflikt
   między dokumentem Leny (Sadowa 12) a tablicą/domofonem (Sadowa 14, L. Wolska / M. Kowalska),
   drzwi wejściowe `BuildingEntranceDoor` otwierane kodem z pamięci i kluczem z torby;
4. BUNDLE-14 (Station 08 stairwell and threshold): rodzina mieszkalna z niskim sufitem (y=36)
   i lamperią, pięć realnych stopni 12 px, rozmowa z sąsiadką ("Marta od godziny czeka na górze"),
   drzwi 14 `ApartmentDoor14` otwierane pasującym kluczem z torby, ustanowienie hipotezy przenumerowania;
5. BUNDLE-15 po recertyfikacji PKG-0159: GATE-30 PASS na ciągłym M1
   `Nowa gra`→08; GATE-FAM **PARTIAL 4/7**, GATE-INT 01–08 PASS lokalnie;
6. Bramka `tests/pkg_0158_smoke_test.gd` oraz 16 kadrów normal/reduced w `reports/pkg_0158/`;
7. CHECKPOINT-03: **PIVOT** — PKG-0160 wykonuje PHASE-04, ale musi najpierw
   dobudować prywatną, instytucjonalną i warsztatową rodzinę oraz M3 7/7.

PKG-0159 skorygował fałszywie zielone dowody PKG-0157/0158:

1. usunął listę sterowania z pierwszego obrazu;
2. wdrożył wybór „próbka albo obietnica” i jego konsekwencje w 01–04;
3. naprawił pomost Station 02 i fizyczne schody Station 08;
4. dodał `tests/pkg_0159_smoke_test.gd` — ciągły M1 01–08 oraz M5 trace;
5. dodał `tools/capture_pkg_0159.gd` — 9 kadrów normal/M3; M3 ma prawdziwą
   skalę szarości i ukryty tekst/UI;
6. utrzymał release i nowe `.exe` w blokadzie.

PKG-0160 wykonał PHASE-04 / BUNDLE-16..20: 09 buduje ślad dwóch żyć i granicę
prywatności, 10 daje Marcie własny dzień i odmowę, 11 prowadzi przez kartę,
biometrię oraz fizyczne 186 dni, 12 przez pytania Jakuba, spotkanie i
kontynuowalną odmowę, a 13 zapisuje `world_recognized` wyłącznie po jawnej
syntezie trzech źródeł. `tests/pkg_0160_smoke_test.gd` jest w `verify.ps1`;
normal-driver capture tworzy 5 kadrów zwykłych i 7 M3. Początkowy wynik 09
spowodował PIVOT 6/7.

PKG-0161 spłacił ten lokalny pivot bez rozszerzania kampanii: Station 09 ma
teraz niski sufit, sofę, niski stół z dwiema filiżankami, zamknięte drzwi,
fotografię, domową ceramikę i zasłonięte okno; ogólne świetlówki są wyłączone
na rzecz dwóch praktycznych świateł. Świeży M3 bez tekstu/UI na Intel Iris Xe
czyta strukturę salonu i różni się od pozostałych sześciu rodzin na ≥3 osiach.
GATE-FAM = TECHNICAL PASS 7/7, CHECKPOINT-04 = **GO**. Release pozostaje
zablokowany; aktywny jest PHASE-05 / BUNDLE-21.

PKG-0162 wykonał BUNDLE-21: Station 14 jest teraz rozdzielnią Linii 4
(rodzina techniczna), w której maszyna pracuje własnym cyklem i wystawia most
sekcji na falę korekty. Utrzymanie mostu zachowuje obserwowaną wersję,
puszczenie przełącza montaż i gasi sekcję (jawny mały koszt jako stan);
nazwanie metody następuje dopiero po wykonaniu obu zachowań, a odwrócenie jest
bezpieczne i dostępne w każdym cyklu. `tests/pkg_0162_smoke_test.gd` pilnuje
kontraktu w `verify.ps1`; `reports/pkg_0162/` ma trzy beztekstowe M2 i jeden
M3. GATE-MECH = TECHNICAL PASS kontraktowy.

PKG-0163 wykonał BUNDLE-22: Station 15 jest pierwszym adresem rodziny
granicznej/anomalnej (topologia techniczna z jednym niezgodnym elementem —
odbiéracz pętli w dwóch wersjach po przeciwnych stronach szwu anomalii, jedno
światło świecące w górę, jeden dźwięk bez źródła). Próba wzajemnego sygnału:
odtworzenie logu 20:40 (`ucp_intervention_reconstructed`), dwa identyczne
impulsy kontrolne dają identyczne echo, dopiero trzeci impuls z celowym
błędem otrzymuje selektywną korektę (`local_lena_signal_confirmed`), a
notatka z warunkiem przerwania otwiera drabinę w górę
(`local_lena_intent_found`). `tests/pkg_0163_smoke_test.gd` w `verify.ps1`;
`reports/pkg_0163/` ma trzy beztekstowe M2 i jeden M3 mono. Aktywny jest
BUNDLE-23 / Station 16.

PKG-0164 wykonał BUNDLE-23: Station 16 jest drugą sceną rodziny
granicznej/anomalnej — techniczna komora bezpiecznego analizatora ma jeden
niezgodny przekaźnik w dwóch położeniach, wejście drabiną od 15 i wyjście
po prawej. Próba wymaga trzech jawnych punktów i nie więcej niż trzech
istotnych interakcji: przekazania odpowiedzi do analizatora, wyboru utraty
ostrości pamięci pierwszego spotkania z Martą albo dokładnej sekundy próbki,
a następnie potwierdzenia echa domu. Nieudana kolejność pozostawia informację
bez utraty stanu; koszt `mechanic_cost_observed` powstaje dopiero po wykonanym
wyborze. `tests/pkg_0164_smoke_test.gd` jest w `tools/verify.ps1`, a
`reports/pkg_0164/` zawiera trzy beztekstowe M2 o różnych hashach i jeden M3
mono z normalnego sterownika Intel Iris Xe. GATE-MECH = TECHNICAL PASS
kontraktowy; PRODUCT GO i release pozostają zablokowane. Aktywny jest
BUNDLE-24 / Station 17.

PKG-0165 wykonał BUNDLE-24: Station 17 wraca do rodziny instytucjonalnej —
hala z długą osią w głąb, powtarzalny moduł 64 px i jawna linia kontroli
(lada 104 px). Trzy interakcje: rejestr par kosztów Linii 4
(`ucp_cost_ledger_found`, wejście wymaga donor faktów Station 16), terminal
oferty adaptacji z kontynuowalną odmową (zamyka hipotezę `cheap_adaptation`)
oraz biurko zakresu zgody Jakuba z trzema równymi wariantami `granted` /
`limited` / `refused` bez rankingu moralnego; odmowa jest pełnoprawnym
zapisem i nie softlockuje wyjścia. `tests/pkg_0165_smoke_test.gd` jest w
`tools/verify.ps1`, a `reports/pkg_0165/` zawiera trzy beztekstowe M2 o
różnych hashach i jeden M3 mono z normalnego sterownika Intel Iris Xe.
GATE-MECH = TECHNICAL PASS kontraktowy; PRODUCT GO i release pozostają
zablokowane. Aktywny jest BUNDLE-25 / Station 18.

PKG-0166 wykonał BUNDLE-25: Station 18 zamyka linię 01–18 jako ulica z 05
po zmianie (rodzina miejska). Trzy interakcje: tablica trzech prognoz
(`route_hypotheses_mapped`, zamyka `single_route_sufficient`), witryna
Marty (`marta_truth_state` = `full`/`partial`/`withheld`) oraz fizyczne
zatwierdzenie `method_committed` (`force_home`/`close_equal_recover_local`/
`mutual_passage` → 42A/B/C). Wejście wymaga donor faktów Station 17; odmowa
i wstrzymanie nie softlockują. `tests/pkg_0166_smoke_test.gd` jest w
`tools/verify.ps1`, a `reports/pkg_0166/` zawiera trzy beztekstowe M2 o
różnych hashach i jeden M3 mono z normalnego sterownika Intel Iris Xe.
GATE-MECH = TECHNICAL PASS kontraktowy; PRODUCT GO i release pozostają
zablokowane. Aktywny jest PHASE-06 / Station 42A.

PKG-0167 wykonał pierwszy adres PHASE-06: Station 42A jest znanym mieszkaniem
o świcie (rodzina finałowa/epilogiczna). Wejście wymaga
`method_committed = force_home`. Trzy interakcje: rygiel wymuszonego
powrotu (`ending_family = "force_home"`), zapieczętowany próg drugiej Leny
(`local_lena_sealed`, zamyka `other_lena_comes_home_too`) oraz stół z
pustym krzesłem (`household_consequence` + `ending_stability`). Wybrany
wariant zostawia drogę do 43 otwartą od wejścia; niepełna próba jest
informacyjna. `tests/pkg_0167_smoke_test.gd` jest w `tools/verify.ps1`, a
`reports/pkg_0167/` zawiera trzy beztekstowe M2 o różnych hashach i jeden
M3 mono z normalnego sterownika Intel Iris Xe. GATE-MECH = TECHNICAL PASS
kontraktowy; PRODUCT GO i release pozostają zablokowane. Aktywny jest
PHASE-06 / Station 42B.

PKG-0168 wykonał drugi adres PHASE-06: Station 42B kontynuuje znane mieszkanie
o świcie (rodzina finałowa/epilogiczna). Wejście wymaga
`method_committed = close_equal_recover_local`. Trzy interakcje: zabezpieczenie
przewodu Równi (`ending_family = "close_equal_recover_local"`), próg
mieszkania 14 (`local_lena_recovered`, zamyka `arrived_lena_unindexed_presence`)
oraz stół nieindeksowanej obecności (`household_consequence` + `ending_stability`).
Wybrany wariant zostawia drogę do 43 otwartą od wejścia; niepełna próba jest
informacyjna. `tests/pkg_0168_smoke_test.gd` jest w `tools/verify.ps1`, a
`reports/pkg_0168/` zawiera trzy beztekstowe M2 o różnych hashach i jeden
M3 mono z normalnego sterownika Intel Iris Xe. GATE-MECH = TECHNICAL PASS
kontraktowy; PRODUCT GO i release pozostają zablokowane. Aktywny jest
PHASE-06 / Station 42C.

PKG-0169 wykonał trzeci adres PHASE-06: Station 42C kontynuuje znane mieszkanie
o świcie (rodzina finałowa/epilogiczna). Wejście wymaga
`method_committed = mutual_passage`. Trzy interakcje: zwolnienie wzajemnego
przejścia (`ending_family = "mutual_passage"`), próg trwałego przecieku pamięci
(`memory_leak_accepted`, zamyka `mutual_memory_leak_uncontrolled`) oraz stół
dwóch domów (`household_consequence` + `ending_stability`). Wybrany wariant
zostawia drogę do 43 otwartą od wejścia; niepełna próba jest informacyjna.
`tests/pkg_0169_smoke_test.gd` jest w `tools/verify.ps1`, a `reports/pkg_0169/`
zawiera trzy beztekstowe M2 o różnych hashach i jeden M3 mono z normalnego
sterownika Intel Iris Xe. GATE-MECH = TECHNICAL PASS kontraktowy; PRODUCT GO
i release pozostają zablokowane. Aktywny jest PHASE-06 / Station 43.



## P9-PR — Presentation & Comprehension Repair (PHASE-07 + PHASE-08)

Otwarta 2026-09-02 decyzją D-184 po sesji diagnostycznej właściciela.
Nie jest osobną fazą produktu — jest **rozszerzeniem P9** o dwie fazy
wykonawcze, bo diagnoza dotyczy tego samego runtime i tych samych kontraktów.

Specyfikacja nadrzędna: `docs/rebuild/PRESENTATION_REPAIR_PLAN.md`.

### Dlaczego

Właściciel uruchomił runtime po PKG-0170 i zgłosił osiem defektów prezentacji
i czytelności. Wszystkie osiem potwierdzono w kodzie. **Żadna z ośmiu
istniejących bramek produktu ich nie wykrywa** — to jest dokładnie sytuacja
z `ACCEPTANCE_MATRIX.md` §1: `TECHNICAL PASS` nie implikuje `PRODUCT GO`.

Przy okazji ujawnił się fakt, którego dokumenty stanu nie mówiły wprost:
`GameStateManager.CAMPAIGN_ROUTE` nadal prowadzi przez `station_01..station_41`,
więc **trasa 20 adresów istniała dotąd wyłącznie w dokumentach**.

### Osiem defektów

| ID | Defekt | Bramka, która to złapie |
|---|---|---|
| DEF-1 | brak intra; gracz nie wie, kim jest ani czym są drgania | GATE-INTRO — **TECHNICAL PASS (PKG-0176)** |
| DEF-2 | portret Marty to przemalowany portret Leny | GATE-CAST — **ZAMKNIĘTY KADREM (PKG-0186)** |
| DEF-3 | NPC to kółka i trapezy 22–48 px zamiast sprite'ów 84–92 px | GATE-CAST — **ZAMKNIĘTY KADREM na 06/08 (PKG-0186)** |
| DEF-4 | wejścia to marsz w prawo w niewidzialny `AirlockZone` | GATE-THRESH |
| DEF-5 | potykanie i przysiad na każdym stopniu | GATE-ANIM |
| DEF-6 | drabina 62 px obok strefy; brak widoku od tyłu | GATE-ANIM, GATE-SCALE |
| DEF-7 | drzwi 170–180 px wysokości przy kanonie 109 px | GATE-SCALE |
| DEF-8 | twarde bramkowanie wyjścia w 18 z 18 adresów | GATE-FLOW |
| DEF-9 | *(znalezisko sesji)* obsady nie ma na trasie: jedyna osoba to sylwetka Marty w 42B/C | GATE-CAST — **ZAMKNIĘTY KADREM języka (PKG-0186)**; Szymon bez ciała (D-194 C) |

PKG-0185 (2026-09-04) jest audytem. PKG-0186 (2026-09-04) wdraża język Leny 4.1:
kadry `reports/pkg_0186/visual/`.
D-202: Lena 4.1 jest wzorcem języka; D-194 B nie usprawiedliwia kółek na
żywej trasie 06/08.

### Kolejka

| Pakiet | Bundle | Zakres | Status |
|---|---|---|---|
| PKG-0171 | BUNDLE-25 | PHASE-07: cutover trasy 20 adresów + tabela dowodowa defektów | **ZAKOŃCZONY** |
| PKG-0172 | BUNDLE-26 | obsada: portret Marty od zera, `CharacterVisualRig`, sprite'y NPC | **ZAKOŃCZONY** (GATE-CAST TECHNICAL PASS) |
| PKG-0173 | BUNDLE-27 | `step_up`/`step_down`, drabina w widoku tylnym, jedno źródło rysunku drabiny | **ZAKOŃCZONY** (GATE-ANIM schody/drabina TECHNICAL PASS) |
| PKG-0174 | BUNDLE-28 | `ThresholdZone`, trzy rodziny wejść, otwory do kanonu skali | **ZAKOŃCZONY** (GATE-THRESH TECHNICAL PASS; GATE-SCALE część otworów TECHNICAL PASS) |
| PKG-0175 | BUNDLE-29 | ciągła przechodniość i rejestr luk | **ZAKOŃCZONY** (GATE-FLOW TECHNICAL PASS) |
| PKG-0176 | BUNDLE-30 | zimne otwarcie w dwóch warstwach | **ZAKOŃCZONY** (GATE-INTRO TECHNICAL PASS) |
| PKG-0177 | BUNDLE-31 | integracja, czternaście bramek, CHECKPOINT-06 | **ZAKOŃCZONY** (CHECKPOINT-06 GO, GATE-01 RECERTIFIED, 14 bramek TECHNICAL PASS) |
| PKG-0178 | — | raport gotowości wydania (Executive Release Assessment) i dyspozycja GATE-REL | **ZAKOŃCZONY** (PRODUCT GO CANDIDATE, GATE-REL BLOCKED D-168) |
| PKG-0179 | BUNDLE-AUDIT | PHASE-09: audyt 360°, eliminacja wycieków ObjectDB, unifikacja portretów, szlif dialogów, innowacje atmosferyczne | **ZAKOŃCZONY** (PKG-0179 TECHNICAL PASS, 15 bramek PASS) |
| PKG-0180 | BUNDLE-POLISH | Master Polish, Ambient Soundscape Pass, wyciszanie dialogowe, higiena audio i weryfikacja Release Readiness | **ZAKOŃCZONY** (PKG-0180 TECHNICAL PASS, 16 bramek PASS) |
| PKG-0181 | — | PHASE-10: plan absolutnego audytu i samowystarczalny prompt wykonawczy | **ZAKOŃCZONY — PLAN ZATWIERDZONY** |
| PKG-0182 | BUNDLE-32 | Absolutny audyt całej gry, research, naprawy P0–P2, ulepszenia, kreatywna ewolucja i pełna recertyfikacja | **ZAKOŃCZONY — TECHNICAL PASS; PRODUCT GO / GATE-REL BLOCKED** |
| PKG-0183 | BUNDLE-33 | Niezależny red-team audyt i naprawy po PKG-0182 | **ZAKOŃCZONY — TECHNICAL PASS; PRODUCT GO / GATE-REL BLOCKED** |
| PKG-0184 | BUNDLE-34 | Finalna niezależna recertyfikacja | **ZAKOŃCZONY — TECHNICAL / CONTRACT / EVIDENCE PASS; HUMAN RECEPTION OPEN; GATE-REL BLOCKED D-168** |
| PKG-0185 | — | Audyt ujednolicenia obsady (tylko kadry + plan) | **ZAKOŃCZONY — AUDYT** |
| PKG-0186 | — | Cast Style Unification: język Leny 4.1, 06/08 rigi, Marta krem, Jakub 1:6,5 | **ZAKOŃCZONY — ZAMKNIĘTY KADREM; GATE-REL BLOCKED D-168** |
| PKG-0187 | — | Pełny audyt i naprawa obrazu: 20 lokacji, skala, rodziny, kreska | **ZAKOŃCZONY — 106 kadrów Windows, 22 renderowane powierzchnie, `pkg_0187` PASS; PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0188 | — | P3 verifier/audio/locale hygiene: naprawić F-0184-008/009/011 bez monolitu MRP ani przebudowy contentu | **ZAKOŃCZONY — 0091/0094 re-aktywowane; jedna granica PCM; CSV RETIRED; GATE-REL BLOCKED D-168** |
| PKG-0189 | — | P3 residual-boundary audit: inventory F-0184-010/012, statyczna bramka i specyfikacja małych migracji | **ZAKOŃCZONY — D-205; `pkg_0189` inventory PASS; runtime 10–13 i MRP nietknięte; GATE-REL BLOCKED D-168** |
| PKG-0190 | — | Cinematic vignettes: 5 krótkich, ilustrowanych sekwencji (VIG-01..04 + finałowa rodzina A/B/C) na trasie 01–18 → 42A/B/C → 43, na wprost zlecenie właściciela (D-206) | **ZAKOŃCZONY — 5 sekwencji, 14 finalnych PNG (Flux Kontext Max), `scripts/cinematics/`, `pkg_0190_cinematics_test.gd` PASS, 22 kadry Windows; PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0191 | — | Wyrównać kanoniczne fakty mapy na aktywnej trasie 10–13 przez istniejące mosty MRP (przenumerowane z dawnego „PKG-0190" przez D-206) | **ZAKOŃCZONY TECHNICZNIE — 12 faktów w Station 10–13 + 1 audytowany w Station 08, gated synteza Station 13, `pkg_0191_canonical_fact_test.gd` PASS, migration-erasure bug naprawiony (D-208); bez ekstrakcji MRP, bez usuwania P7 i bez zmian geometrii; PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0192 | — | Wycofać callable P7 surface z Station 10–13 (drugi krok z D-205 §4) | **ZAKOŃCZONY TECHNICZNIE — `HallwaySideboard`/`BalconyDoor`/`DeskDrawer` ZOSTAJĄ jako P9 (udokumentowane), `p7.foreign_daily_life.*`/`p7.marta_threshold.*` przemianowane na `p9.threshold_obstacle.*`, callable metody bez zmian sygnatur, `pkg_0192_p7_retirement_test.gd` PASS, migracja legacy-save idempotentna bez zmian; bez zmian geometrii ani MRP; PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0193 | CR-A | Dwie biografie i spotkanie z bratem: rozmowy 09–13 lokalnym prezenterem CRT | **ZAKOŃCZONY TECHNICZNIE — `pkg_0193` PASS; PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0194 | CR-B | Odpowiedź, koszt i cudza zgoda: rozmowy 14–18 lokalnym prezenterem CRT | **ZAKOŃCZONY TECHNICZNIE — `pkg_0194` PASS; PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0195 | CR-C | Metoda i skutek: finały 42A/B/C + 43 lokalnym prezenterem CRT | **ZAKOŃCZONY TECHNICZNIE — `pkg_0195` PASS; PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0196 | CR-D | Rytm początku i spójność obrazu: stacje 01–08 | **ZAKOŃCZONY TECHNICZNIE — `pkg_0196` PASS; PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0197 | — | ZERO REWIZJA wycinek 1: winiety wyciszone, maszyna 01 pracuje, ciała 06/08 | **ZAKOŃCZONY TECHNICZNIE — `pkg_0197` PASS; PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0198 | — | ZERO REWIZJA wycinek 2: 57 kadrów, mono, cienie 22/22, dźwięk miejsc | **ZAKOŃCZONY TECHNICZNIE — `pkg_0198` PASS, 102 bramki; PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0199 | — | F-0184-010 MRP renderer extraction pilot: 130 rendererów 67..196 do stateless `MrpLegacyRenderer`, fasada 206/221 nietknięta | **ZAKOŃCZONY TECHNICZNIE — `pkg_0199` PASS, pełna 103 bramki; 0160 naprawione delegacją (D-216); reguła weryfikacji zakresowej (D-217); PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0200 | — | F-0184-010 MRP renderer extraction slice2: 73 rendery 0..66/197..202 do stateless `MrpLegacyRenderer` (łącznie 203), fasada 206/221 nietknięta, 3 overlaye zostają | **ZAKOŃCZONY TECHNICZNIE — `pkg_0200` PASS, pełna 104 bramki; 0199/0160 naprawione delegacją/combined (D-218); PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0201 | — | Ocularna inspekcja 57 kadrów 0198 (ścieżka B): 19/19 HOLD, lista napraw pusta, bramka integralności + pin pokrycia + runtime skale 85/100/115 | **ZAKOŃCZONY TECHNICZNIE — `pkg_0201` PASS, zakresowa D-217 (docs + smoke + 0198 + 0201); 0198 bez modyfikacji; zero zmian w scripts/scenes; PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0202 | — | Oczny ogląd skal 85/115 full-res (ścieżka C): 08/11/14/43 × 3 skale × pełny/bez tekstu, 4/4 HOLD, lista napraw pusta | **ZAKOŃCZONY TECHNICZNIE — `pkg_0202` PASS, zakresowa D-217 (docs + smoke + 0198 + 0201 + 0202); zero zmian w scripts/scenes; PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0203 | — | Oczny ogląd skal 85/115 full-res, reszta wycinka 2 (ścieżka C): 16 adresów × 3 skale × pełny/bez tekstu, 16/16 HOLD, lista napraw pusta; ogląd skal dla zestawu 0198 DOMKNIĘTY | **ZAKOŃCZONY TECHNICZNIE — `pkg_0203` PASS, zakresowa D-217 (docs + smoke + 0198 + 0201 + 0202 + 0203); zero zmian w scripts/scenes; pełna verify.ps1 wymagana najpóźniej w PKG-0205; PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0204 | — | Checkpoint pełnej weryfikacji po PKG-0203: 107/107 bramek exit 0, zero zmian kodu | **ZAKOŃCZONY TECHNICZNIE — pełna `verify.ps1` PASS (`reports/pkg_0204_verify_full.log`); licznik D-217 zresetowany (następna pełna przy shared-touch / kontrakcie / checkpoincie albo najpóźniej w PKG-0209); PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0205 | — | Decyzja prop_type station_18 (ścieżka B): HOLD na PHOTOGRAPH (0), zero zmian sceny/skryptów; bramka pinu trójki 53/0/16 + dispatch + runtime | **ZAKOŃCZONY TECHNICZNIE — `pkg_0205` PASS, zakresowa D-217 (docs + smoke + 0198 + 0201 + 0202 + 0203 + 0205); fakt prop_type ZAMKNIĘTY decyzją D-220; PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0206 | — | F-0184-010 inwentaryzacja interakcji/audio MRP: trigger 182+else / audio 183+20 / SWITCH_LIKE 6, specyfikacja 2 kroków ekstrakcji, HOLD logiki | **ZAKOŃCZONY TECHNICZNIE — `pkg_0206` PASS, zakresowa D-217 (docs + smoke + 0198 + 0201 + 0202 + 0203 + 0205 + 0206); zero zmian w scripts/scenes; dług ZAPINOWANY decyzją D-221; PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0207 | — | Spis bramek i pin fundamentów: 101 testów == 101 referencji (zero sierot/wiszących/dubli), 103 wywołania Invoke, fundamenty 640×360 / 60 Hz / 10 akcji, handoff spójny, HOLD logiki i obrazu | **ZAKOŃCZONY TECHNICZNIE — `pkg_0207` PASS, zakresowa D-217 (docs + smoke + 0198 + 0201 + 0202 + 0203 + 0205 + 0206 + 0207); zero zmian w scripts/scenes; rejestr ZAPINOWANY decyzją D-222; PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0208 | — | Pin selektora kampanii i defaultów prezentacji: ROUTE 18 / LEGACY 23 / FINALES 3 / EPILOGUE 43 / SELECTOR 20 (01–18 + 42a + 43, bez 42b/42c i legacy) / OPMAP A-B-C / limity 18-41, defaulty volume 0.85 / CPS 42.0 / skale 0.85-1.0-1.15 / remap 5, HOLD logiki i obrazu | **ZAKOŃCZONY TECHNICZNIE — `pkg_0208` PASS, zakresowa D-217 (docs + smoke + 0198 + 0201 + 0202 + 0203 + 0205 + 0206 + 0207 z kontrolowaną aktualizacją liczb 101→102 wg reguły D-222 + 0208); zero zmian w scripts/scenes; selektor ZAPINOWANY decyzją D-223; PKG-0209 MUSI być pełną `verify.ps1`; PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0209 | — | Pełna recertyfikacja po czterech pakietach zakresowych (ścieżka D): 111/111 GREEN bez zmian gry, bez nowej decyzji | **ZAKOŃCZONY TECHNICZNIE — pełna `verify.ps1` PASS (`reports/pkg_0209_verify_full.log`, DOCS PASS 52); zero zmian w scripts/scenes/tests/verify.ps1; licznik D-217 zresetowany (następna pełna przy shared-touch / kontrakcie / checkpoincie albo najpóźniej w PKG-0214); PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0210 | — | Audyt architektoniczny Aurelius: eliminacja reentrancji setterów w 5 skryptach, odsprzężenie stref, warstwy fizyki 2D (1..4), kontrakt Flyweight | **ZAKOŃCZONY TECHNICZNIE — `pkg_0210` PASS, pełna `verify.ps1` PASS (112 sekcji, DOCS PASS 52); rejestr pinu `pkg_0207` zaktualizowany (D-224); PRODUCT GO / GATE-REL nadal BLOCKED D-168** |
| PKG-0211 | — | Spis i pin silnika syntezy ProceduralAudio: 265 funkcji statycznych (256 create_*), kontrakt fali 16-bit PCM 44.1kHz mono, pętle, cykl życia cache i drain_playback | **ZAKOŃCZONY TECHNICZNIE — `pkg_0211` PASS, zakresowa D-217 (docs + smoke + 0206 + 0207 + 0208 + 0210 + 0211); rejestr pinu `pkg_0207` zaktualizowany (105->106 / 104->105 / 103->104 wg D-222/D-225); zero zmian w scripts/scenes; PRODUCT GO / GATE-REL nadal BLOCKED D-168** |

Kolejność jest zależnościowa, nie ważnościowa. Intro (zgłoszenie nr 1
właściciela) jest przedostatnie, bo potrzebuje portretu Marty, kontraktu progu
i naprawionej animacji — inaczej trzeba by je przerabiać trzy razy.
Właściciel może zmienić kolejność jedną decyzją; zakres pakietów zostaje.

### Zmiany w bramkach

- Bramek produktu jest **czternaście**, nie osiem (`ACCEPTANCE_MATRIX.md` §3a).
- **GATE-01 cofnięta z `PASS` do `CONCERNS`.** Zaliczono ją na automatycznym
  trace 4203 ms, w którym skrypt zna kolejność interakcji; człowiek jej nie zna.
- GATE-REL wymaga teraz 14 bramek PASS.

### Czego ta faza nie zmienia

Trasy 20 adresów, siedmiu rodzin lokacji, rozstrzygnięć 42A/B/C i 43,
zakazu platformingu (D-099), limitu 18 px wejścia bez drabiny (D-123),
dwukierunkowości (D-124) ani blokady release'u (D-168).

## Bramki stałe każdego pakietu

- wyłącznie Godot; brak webu i Git;
- zgodność z kanonem przeszkód D-099;
- semantyczny InputMap, 60 Hz i 640x360;
- szybki restart i deterministyczny stan debug;
- zgodność `NARRATIVE_BIBLE` + `FULL_STORY` + `CONTINUITY_TRACKER` + dialogu;
- test dokumentacji, import i pakietowy smoke;
- dla zmian wizualnych: normal-driver capture i ręczna inspekcja świeżych kadrów;
- aktualne `CURRENT_STATE`, append-only `SESSION_LOG`, nowy handoff i snapshot;
- jasne rozdzielenie dowodów technicznych od hipotez odbiorczych.

## Warunek ukończenia roadmapy

Droga do mety przechodzi przez HYBRID_REBUILD. Kryterium ukończenia to
jednocześnie:

1. `TECHNICAL PASS` — pełny `tools/verify.ps1` z exit code 0;
2. `PRODUCT GO` — wszystkie **czternaście** bramek produktu z
   `docs/rebuild/ACCEPTANCE_MATRIX.md` (osiem z §3 i sześć z §3a) zaliczone
   na przebiegu czasownikami gracza;
3. kampania 20 odwiedzanych adresów (01–18 → 42A/B/C → 43);
4. siedem rozpoznawalnych rodzin lokacji potwierdzonych monochromatycznym
   blockoutem.

Warunek **nie** jest osiągnięty przez sam istniejący release candidate
techniczny ani przez natywny Linux poza WSL; oba są częściowo odłożone do
nowego produktowego GO. Test, audyt tekstu ani render nie dowodzą strachu,
zabawy, zrozumienia relacji czy emocjonalnej uczciwości finału (D-012,
ADR-003).
