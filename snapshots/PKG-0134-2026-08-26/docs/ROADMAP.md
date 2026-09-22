# Roadmapa: Getting Strange

Status: **AKTYWNA ROADMAPA 3.0 — RELACYJNA REWOLUCJA FABUŁY**  
Data: 2026-08-25  
Decyzja: `ADR-007`, `D-114`  
Szczegółowy plan wykonawczy: `CREATIVE_REBUILD_PLAN.md`

## Meta produktu

Ukończona, samodzielna gra narracyjna 2D w Godot 4.7 na Windows i Linux. Lena
wraca z rutynowego pomiaru do miasta, które przez długi czas wydaje się jej
własne. Dopiero po 21 przestrzeniach potrafi udowodnić, że żyje w innej
ciągłości; wtedy pierwsza tajemnica ustępuje drugiej: co zrobiła miejscowa Lena,
gdzie została uwięziona i kto zapłaci za rozdzielenie światów.

Meta obejmuje 43 adresy kampanii, pełny przebieg od tytułu do konsekwencji,
ludzką postać Leny, Rówień Pixel-Stage, ostre teksty, kontekstowe prowadzenie,
zapis, dostępność, buildy oraz jawny pakiet licencyjny.

Istnienie 43 scen technicznych nie jest content lockiem. Po D-114 droga do mety
prowadzi przez ponowne autorstwo kampanii według kanonu 0.3, nie przez
bezpośredni eksport istniejącej treści.

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

Pakiety: **PKG-0131..0134 zamknięte; PKG-0135 otwarty (oko + one_way + 05→03)**
Status: **OTWARTA — PKG-0134 ZAMKNIĘTY**

Wykonane w PKG-0134:

1. Live walk wszystkich 45 scen (`campaign_playability_audit.gd`).
2. `try_curb_step` 18 px; `ExitClearance` na drzwiach i przegrodzie 26.
3. GATE_STORY nazwane: 12, 14, 15, 19, 20, 21.

Zostaje: capture okiem, one_way 09/11, chód 05→04→03.

Zakaz `.exe` (D-125).

## P6-odroczone (nie otwierać przed PKG-0135)

- Unifikacja `Camera` vs `Camera2D` w stacjach 33–43.
- Reduced-motion / tłumienie flickeru 100 Hz i cząstek.



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

Roadmapa kończy się dopiero na zweryfikowanym release candidate Windows/Linux.
Test, audyt tekstu ani render nie dowodzą strachu, zabawy, zrozumienia relacji
czy emocjonalnej uczciwości finału.
