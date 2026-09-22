# PLUS_SESSION_PROMPT_2 — PKG-0182 / BUNDLE-32: absolutny audyt i ewolucja całej gry

> Ten prompt jest kompletną dyspozycją wykonawczą właściciela. Wykonaj cały zakres w jednym autonomicznym mega-bundle'u: audyt → findings → naprawy → ulepszenia → nowe pomysły → ponowny audyt → dokumentacja → weryfikacja → snapshot. Nie pytaj o zgodę na decyzje techniczne lub artystyczne i nie kończ na samym raporcie. Zatrzymaj się wyłącznie przy prawdziwym zewnętrznym blockerze po wyczerpaniu bezpiecznych alternatyw; brak zewnętrznych testerów nie jest blockerem pracy, tylko granicą twierdzeń.

---

## CEL SESJI

Jesteś Lead Programmerem, Art Directorem, projektantem gry, audytorem QA, redaktorem narracji i badaczem dla *Getting Strange*. Masz sprawdzić **absolutnie każdą inspectowalną część aktualnej gry** w `C:\getting_strange`, empirycznie tam, gdzie jest to możliwe, oraz wdrożyć wszystkie uzasadnione naprawy i ulepszenia w jednym pakiecie **PKG-0182 / BUNDLE-32**.

Specyfikacja nadrzędna:  
`docs/rebuild/COMPREHENSIVE_GAME_AUDIT_AND_EVOLUTION_PLAN.md`

Nie przyjmuj za prawdę wcześniejszych deklaracji „PASS”. Odtwórz dowody ze świeżego stanu dysku. Exit code 0 jest tylko jednym sygnałem. W szczególności świeży baseline z 2026-09-03 zakończył się `Verification passed.` i M1 20/20 w 188,1 s, lecz wiele bramek zgłosiło `ObjectDB instances were leaked at exit` (od 2 do 21), a PKG-0180 zgłosił 4 — mimo że dokumentacja twierdzi, że wycieki wyeliminowano. To obowiązkowy finding do reprodukcji, przyczyny, naprawy i recertyfikacji.

### Wynik, który masz zostawić

1. pełny manifest pokrycia plików i powierzchni gry;
2. raport findings z dowodami, przyczynami, priorytetem i retestem;
3. zaimplementowane poprawki P0–P2 oraz bezpieczne P3;
4. zaimplementowane wszystkie kreatywne pomysły, które sam oznaczysz `PROPOSED_FOR_IMPLEMENTATION` po rygorystycznej selekcji;
5. świeże przebiegi, rendery, stripy animacji, pomiary audio i performance;
6. uzgodnioną dokumentację i nowy handoff;
7. finalne `Verification passed.` bez nierozliczonych błędów, warningów ObjectDB/RID i sprzecznych deklaracji;
8. snapshot PKG-0182.

---

## TWARDE REGUŁY

1. **Godot-only (D-098).** To natywna gra PC w Godot 4.7.x i GDScript. Nie twórz, nie otwieraj ani nie proponuj strony, HTML/CSS/JS, PWA, portalu, browser showcase czy web distribution. `archive_retired_web/` jest martwe i poza audytem.
2. **No Git (D-016).** Nie uruchamiaj żadnego polecenia Git, nie inicjalizuj repozytorium. Pliki na dysku są jedynym stanem. Zapisuj każdy skończony krok natychmiast.
3. **No release (D-168).** Nie buduj i nie dodawaj żadnego nowego `.exe`; nie przełączaj GATE-REL na PASS. Niniejsza zgoda dotyczy audytu i zmian w grze, nie wydania binarnego.
4. **Narrative, not arcade (D-099).** Zero moving-platform jump targets, floating blocks, spikes, enemies, health bars i timingowych skoków. Każda przeszkoda musi mieć jednozdaniowe wyjaśnienie w świecie bez słowa „gracz”.
5. **Kanon runtime.** Zachowaj 640×360, 60 Hz, InputMap, fast restart, deterministyczny debug, osobno pikselizowany świat i ostre teksty.
6. **Skala.** Czytaj bieżący `docs/WORLD_SCALE.md`; obowiązuje 1 m = 52 logical px. Nie kopiuj historycznej wartości 54 px z wcześniejszych planów.
7. **Architektura.** Nie rozszerzaj `MemoryResonancePoint`, `VectorStageEnvironment` ani `GameStateManager` o nowe niespokrewnione obowiązki. Preferuj małe typed scenes/scripts. Wspólny moduł wymaga co najmniej dwóch realnych użyć.
8. **Kanon narracyjny.** Dziwność narasta powoli. Nie ujawniaj innego świata, drugiej Leny, prawdziwej natury UCP ani rozwiązania Anchor/Yield przed progami kanonu. Myśli Leny prowadzą obserwacja → hipoteza → sprawdzenie i mogą mylić się fabularnie, lecz nie mogą kłamać o sterowaniu ani celu czynności.
9. **Dowód.** Testy nie dowodzą zabawy, emocji, urody, komfortu ani ludzkiego zrozumienia. Używaj klas `RUNTIME-MEASURED`, `RENDER-MEASURED`, `AUDIO-MEASURED`, `TEXT-AUDITED`, `CONTRACT-PASS`, `RESEARCH-SUPPORTED`, `HEURISTIC`, `OPEN-NO-EVIDENCE`.
10. **Zakaz skrótów.** Nie osłabiaj testu, progu ani asercji, by uzyskać zieleń. Nie uznawaj istnienia pliku, unikalnego hasha lub wyjścia 0 za dowód jakości doświadczenia.

---

## SRODOWISKO I BASELINE

- Katalog: `C:\getting_strange`
- Silnik oczekiwany: Godot 4.7.2 stable lub aktualna 4.7.x wskazana przez runtime
- Renderer: GL Compatibility
- Viewport: 640×360; fizyka: 60 Hz
- Ostatni zamknięty pakiet kodu przed tą dyspozycją: PKG-0180
- Pakiet planistyczny przygotowujący tę dyspozycję: PKG-0181
- Aktywna trasa: 01–18 → 42A/B/C → 43 (20 odwiedzanych adresów, 22 zasoby scen finałowych włącznie)
- Release i nowe `.exe`: zablokowane

### Obowiązkowa kolejność czytania

Przeczytaj **w całości**, w tej kolejności:

1. `AGENTS.md`
2. `docs/INDEX.md`
3. `docs/CURRENT_STATE.md`
4. `docs/NEXT_SESSION_PROMPT.md`
5. `docs/PLUS_SESSION_PROMPT_2.md`
6. `docs/rebuild/COMPREHENSIVE_GAME_AUDIT_AND_EVOLUTION_PLAN.md`
7. `docs/WORKFLOW.md`
8. `docs/decisions/ADR-003-evidence-model-without-external-testers.md`
9. `docs/decisions/ADR-008-hybrid-product-rebuild.md`
10. `docs/PROJECT_REBUILD_EXECUTION_PLAN.md`
11. `docs/rebuild/PLAYER_CONTRACT.md`
12. `docs/rebuild/CAMPAIGN_MAP.md`
13. `docs/rebuild/LOCATION_FAMILY_BIBLE.md`
14. `docs/rebuild/ACCEPTANCE_MATRIX.md`
15. `VISUAL_DESIGN.md`
16. `docs/WORLD_SCALE.md`
17. `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`
18. `docs/rebuild/CAST_AND_NPC_BIBLE.md`
19. `docs/rebuild/THRESHOLD_AND_ENTRY_CONTRACT.md`
20. `docs/rebuild/PROGRESSION_FLOW_CONTRACT.md`
21. `docs/rebuild/COLD_OPEN_SPEC.md`
22. `docs/narrative/NARRATIVE_BIBLE.md`
23. `docs/narrative/FULL_STORY.md`
24. `docs/narrative/CONTINUITY_TRACKER.md`
25. `docs/narrative/DIALOGUE_SCRIPT.md`
26. `docs/RISKS_AND_HYPOTHESES.md`
27. `docs/DECISION_LOG.md`
28. `tools/verify.ps1`, `tools/verify_docs.ps1`, skrypty capture/audytu, wszystkie aktywne testy oraz źródła wskazane przez inventory.

Jeżeli dokument przeczy runtime, zanotuj rozjazd przed edycją. Bieżący kod i świeży runtime wygrywają z historycznym handoffem, ale kontrakt produktu nie może zostać po cichu zmieniony, aby dopasować go do błędu.

### Baseline obowiązkowy

Przed pierwszą edycją uruchom i zapisz pełne stdout/stderr do `reports/pkg_0182/baseline.log`:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Zapisz czas, kod wyjścia oraz policz wszystkie `ERROR`, `SCRIPT ERROR`, `WARNING`, `ObjectDB`, `leaked`, `orphan` i `RID`. Nie filtruj logu do samego końcowego wiersza.

---

## SKILLE — OBOWIĄZKOWE UŻYCIE

Najpierw przeczytaj `.github/skills/README.md`. Potem znajdź i przeczytaj w całości `SKILL.md` dla poniższych skilli w dostępnych katalogach `.agents/skills/`, `.codex/skills/` lub `skills/`. Użyj ich w odpowiednich strumieniach i odnotuj konkretny wpływ w sekcji `skill_usage` raportu:

- `planning-and-task-breakdown` — atomizacja i zależności;
- `full-review` i `godot-auditor` — pełny audit kodu, scen i kontraktów;
- `game-qa` — scenariusze, negatywne kontrole i regresje;
- `design-review`, `game-ui-ux`, `game-feel`, `player-ux` — rubryki obrazu, feedbacku i UX;
- `godot-debugging` i `godot-performance-optimization` — ObjectDB, profiler, performance i soak;
- `godot-audio` — routing, clipping, ducking i lifecycle;
- `emotional-narrative`, `natural-dialogue-techniques`, `polska-proza-gamedev2` — narracja, głosy, polszczyzna i chronologia wiedzy;
- `imagegen` — tylko jeśli finding wymaga utworzenia lub edycji assetu; najpierw obejrzyj istniejący obraz i zachowaj referencję/proweniencję.

Jeśli nazwa lub ścieżka skilla zmieniła się, wyszukaj odpowiednik po opisie. Jeśli skill jest naprawdę niedostępny, odnotuj `SKILL-BLOCKED` i wykonaj strumień najlepszą dostępną metodą; nie zatrzymuj całego bundle'u.

---

## RESEARCH — OBOWIĄZKOWY I AKTUALNY

Wykonaj live research przed zmianą standardu lub terminologii. Otwieraj źródła, nie opieraj się na snippetach. Dla każdego pytania zapisz w `reports/pkg_0182/research_ledger.md`: pytanie, zapytanie, źródło/link, data dostępu, wersja, wniosek, ograniczenie i konkretna decyzja w grze.

Minimalne obszary:

1. oficjalna dokumentacja Godot 4.7: profiler/Performance, ObjectDB, asset import, 2D pixel art, animation, audio buses/effects, InputMap i lifecycle;
2. aktualne Xbox Accessibility Guidelines: text display, contrast, additional channels, subtitles/captions, audio, input, focus/navigation, motion i photosensitivity;
3. WCAG 2.2 wyłącznie jako źródło mierzalnych progów kontrastu/migania/ruchu — bez deklaracji compliance desktopowej gry;
4. polskie źródła językowe i branżowe dla spornych słów, rejestru technicznego, realiów kolei/utrzymania ruchu i chronologii epoki;
5. publikacje pierwotne lub oficjalne materiały dotyczące metod pomiaru, jeżeli istniejący próg nie ma źródła.

Dla ważnej decyzji użyj dwóch niezależnych wiarygodnych źródeł, gdy to możliwe. Nie wymyślaj budżetu wydajności, poziomu audio ani normy artystycznej. Jeśli źródła nie rozstrzygają, oznacz decyzję `HEURISTIC` lub `OPEN-NO-EVIDENCE`.

---

## WYKONANIE JEDNEGO BUNDLE'U

Wykonaj wszystkie fazy A–H planu bez rozbijania ich na osobne pakiety i bez pauzy na akceptację. Poniższa kolejność jest wiążąca.

### 1. Inventory i coverage manifest

- Użyj `rg --files` do pełnej listy `scripts/`, `scenes/`, `assets/`, `tests/`, `tools/`, `docs/`, lokalizacji i konfiguracji.
- Wyłącz tylko `.godot/`, `reports/`, `snapshots/`, binarne artefakty `dist/` oraz twardo wyłączone `archive_retired_web/`. Audytuj jednak skrypty eksportowe, presety i manifest licencji bez tworzenia `.exe`.
- Zapisz `inventory.tsv` oraz `coverage_manifest.tsv`.
- Każdy plik i każda powierzchnia produktu musi mieć `PASS`, `FINDING`, `NOT_APPLICABLE` albo `BLOCKED`, metodę i dowód. Brak wiersza = niekompletny audyt.
- Odtwórz liczniki zamiast kopiować stare. Historycznie katalog zawierał około 190 skryptów, 50 scen, 154 testów, 221 assetów, 186 narzędzi i 82 dokumenty; różnica jest findingiem do wyjaśnienia, nie błędem samym w sobie.

### 2. Audit verifiera i techniki

- Przeczytaj każde wywołanie w `tools/verify.ps1` i każdy test.
- Zmapuj: setup, teardown, izolację save/settings, realne czasowniki, kontrolę negatywną, warning policy i dowodzony kontrakt.
- Zidentyfikuj testy, które sprawdzają literal lub istnienie pliku zamiast zachowania, albo przechodzą mimo błędu w logu.
- Wprowadź parser logu, który failuje na niedopuszczalne `SCRIPT ERROR`, parser errors, ObjectDB/RID leaks i nowe warningi. Oczekiwany warning musi mieć wąską allowlistę, przyczynę i test.
- Dla bramek krytycznych wykonaj bezpieczną kontrolowaną mutację dowodzącą, że test potrafi upaść. Cofnij ją od razu dokładnym patchem; nie używaj Git.
- Uruchom `--verbose` dla leaków, zbuduj minimalne reprodukcje, napraw sygnały, timery, tweens, audio players, autoload connections, osierocone sceny i teardown.
- Przejrzyj architekturę GDScript, typowanie, monolity, duplikację, imports, resource loading, error paths, save/settings/migrations i JSON-safe state.

### 3. Wszystkie przepływy runtime i mechaniki

- Uruchom prawdziwy shell, `Nowa gra`, `Kontynuuj`, reset, pauzę, ustawienia, restart i cold open. Nie wywołuj bezpośrednio gameplayowych metod sceny tam, gdzie dowód ma reprezentować grę.
- Wykonaj trzy pełne trasy od legalnego stanu: minimalną, pełną i mieszaną.
- Wykonaj 3/3 finałów A/B/C i Station 43.
- Zapisuj trace: timestamp, adres, pozycja, semantyczna akcja, stan przed/po, fakt, gap, koszt, zgoda i wynik.
- Sprawdź backtracking, ReturnZone, thresholds, schody, drabiny, windę, krawędzie kolizji, zmianę kierunku, stop/start, camera clamps oraz reduced motion.
- Sprawdź Anchor/Yield: neutral, oba stany, błędna bezpieczna próba, correction/reset, koszt, consent, feedback audio/wideo/haptic i zapis.
- Sprawdź klawiaturę i pad poprzez InputMap/runtime injection. Jeżeli fizycznego pada nie ma, oznacz tylko fizyczną ergonomię `BLOCKED`; nie blokuj parytetu mapowań.

### 4. Grafika, kompozycja, UI i dostępność

- Użyj normalnego Windows display driver oraz `tools/capture_preview.gd`/dedykowanego capture. Headless nie jest dowodem wyglądu.
- Wygeneruj świeże kadry dla: shellu, cold open, każdego aktywnego adresu, wszystkich finałów, dialogu, myśli, pause, settings, Anchor/Yield, normal/reduced motion oraz reprezentatywnych PL/EN.
- Dla każdej stacji zrób co najmniej: normalny kadr, beztekstowy kadr M3, Lena obok kluczowego obiektu/wejścia oraz kadr stanu interakcji.
- Zmierz, a nie zgaduj: `WORLD_SCALE`, collider↔rysunek, pixel-grid, nearest filtering, alpha halos, clipping, safe areas, overlap, kontrast tekstu, kolor bez jedynego znaczenia, liczebność akcentów, głębię, widoczność celu i rozróżnialność siedmiu rodzin w mono.
- Następnie wykonaj jawnie `HEURISTIC` art-direction review każdego kadru: hierarchia, silhouette, focal point, material, depth, rhythm, lighting, palette, identity, clutter i zgodność z Leną/Rowien Pixel-Stage.
- Sprawdź XAG dla text display, focus/navigation, additional channels, audio-only information, motion/photosensitivity i input.
- Napraw każdy P0–P2. Dla nowej grafiki użyj skilla `imagegen`, istniejącego obrazu jako referencji i pipeline'u projektu. Nigdy nie rysuj anatomii kółkami/prostokątami. Zachowaj prompt, referencję, źródło, alpha, paletę, skalę i ustawienia importu nearest/lossless.

### 5. Wszystkie animacje

Zbuduj `animation_matrix.tsv` i świeże stripy/klatki dla wszystkich używanych stanów i przejść:

- idle, start, stop, turn, walk, run;
- step_up, step_down, jump/fall/land tylko tam, gdzie legalne;
- climb_back_0..3, ladder_mount, ladder_dismount;
- examine, carry, Anchor, Yield, correction/reset;
- enter_door, board_vehicle i warianty threshold;
- NPC: idle, talk, listen, gesture, turn_away, seated, work;
- cold open i wszystkie ruchome elementy świata.

Zmierz czas, liczbę klatek, pivot, pozycję stopy, seam pętli, flip kierunku, przerwanie, wejście/wyjście i reduced motion. Sprawdź, czy animacja pasuje do fizyki oraz czy nie tworzy teleportu, clippingu, fałszywego lądowania, pyłu lub squasha. Każdy stan ma dowód lub `NOT_APPLICABLE` z powodem.

### 6. Wszystkie teksty, słownictwo i narracja

- Wyodrębnij każdy widoczny tekst PL/EN ze skryptów, scen, lokalizacji, UI, diegetic labels, dialogów, myśli, błędów i credits do `language_ledger.tsv`.
- Dla każdego wiersza zapisz ID, źródło, język, mówcę, adres, moment, funkcję, chronologię wiedzy i status.
- Sprawdź ortografię, interpunkcję, typografię, odmianę, rejestr, naturalność, rytm, długość, czytelność, parity PL/EN, głos postaci, ekspozycję, videogame-speak, anachronizm i fachowość.
- Chroń identyfikatory, placeholdery, formatowanie, ścieżki, logikę, JSON i wygenerowane pliki. Zero globalnych zamian. Każda edycja ma semantic diff i runtime readback.
- Porównaj `NARRATIVE_BIBLE`, `FULL_STORY`, `CONTINUITY_TRACKER`, `DIALOGUE_SCRIPT`, kod flag, cold-open facts i wszystkie trzy finały.
- Zmierz, kiedy pojawia się każdy fakt; sprawdź zakazane wczesne ujawnienia. Nie naprawiaj tekstem problemu obrazu, przestrzeni albo interakcji.
- Oceń minimalną trasę bez opcjonalnych odczytów. Możesz dowieść spójności stanów i obecności motywu; nie możesz dowieść ludzkiego zrozumienia.

### 7. Audio, haptyka, wydajność i soak

- Zmapuj każdy generator audio, player, bus, ambience, dialogue blip, footstep/material, landing, Anchor/Yield, cold open, ducking, mute i haptic.
- Zmierz peak/clipping, DC offset, pętle, przerwy, opóźnienie, voices, attack/release duckingu i alternatywny kanał dla informacji krytycznej.
- Sprawdź osobne poziomy/kategorie zgodnie z zakresem XAG; nie twierdź, że miks „brzmi dobrze” na podstawie samego peak meter.
- Na normalnym driverze zmierz startup, frame time p50/p95/p99, pamięć, obiekty, draw calls, particles, lights, audio voices i najbardziej obciążone sceny. Użyj Godot `Performance`/profilera. Headless jest tylko pomiarem pomocniczym.
- Wykonaj co najmniej 3 cykle load/use/free pełnej aktywnej trasy, save/load, pause/resume i cache eviction. Szukaj trendu wzrostowego, state bleed i nondeterminism.
- Budżet musi pochodzić z aktywnego kontraktu albo być opisany jako baseline pomiarowy. Nie wymyślaj 16,667 ms jako automatycznego budżetu sceny.

### 8. Kreatywne nowe pomysły — wygeneruj, wybierz i wdroż

Wygeneruj kandydatów w minimum sześciu osiach: przestrzeń/obraz, animacja/ruch, Anchor/Yield, audio/sensoryka, narracja/relacje, UI/dostępność. Każdy kandydat musi odpowiadać na finding albo mierzalną lukę.

Kandydat może otrzymać status `PROPOSED_FOR_IMPLEMENTATION` tylko jeśli jednocześnie:

1. jest zgodny z kanonem i powolną progresją dziwności;
2. nie jest webem, arcade ani kopią rozpoznawalnego rozwiązania z cudzej gry;
3. nie zdradza ontologii ani naprawy świata za wcześnie;
4. nie rozbudowuje wspólnego monolitu;
5. ma tani rollback przez mały, jawny patch i nie wymaga Git;
6. ma mierzalne kryterium before/after i test regresji;
7. mieści się bezpiecznie w PKG-0182.

Właściciel **z góry akceptuje wszystkie pomysły oznaczone przez Ciebie `PROPOSED_FOR_IMPLEMENTATION`**. Nie pytaj o ponowne zatwierdzenie. Wdróż je wszystkie w tym bundle'u, po jednym pionowym wycinku. Pomysły niespełniające filtrów oznacz `REJECTED` z konkretnym powodem — nie nazywaj ich propozycjami do późniejszego wdrożenia.

### 9. Kolejność napraw

- P0: crash, utrata danych, softlock, złamanie hard rule;
- P1: fałszywy PASS, accessibility blocker, poważny rozjazd runtime↔docs;
- P2: widoczny defekt grafiki, animacji, języka, audio, UX lub mechaniki;
- P3: mała kosmetyka/optymalizacja.

Napraw P0–P2 w tym bundle'u. Bezpieczne P3 również napraw; jeśli P3 wymaga ryzykownej przebudowy niezwiązanej z celem, zostaw jawny backlog z dowodem. Po każdym atomowym kroku uruchom najwęższy test i zapisz zmianę. Po każdej fazie uruchom checkpoint. Po ostatniej zmianie powtórz cały audit dowodowy.

---

## KRYTERIA AKCEPTACJI

PKG-0182 jest `DONE` tylko, gdy wszystkie punkty są prawdziwe:

1. `coverage_manifest.tsv` obejmuje 100% plików i powierzchni w zakresie, bez pustych statusów.
2. Każdy finding ma reprodukcję, klasę dowodu, przyczynę, fix i retest.
3. Otwarte P0/P1/P2 = 0.
4. Wszystkie `PROPOSED_FOR_IMPLEMENTATION` są wdrożone; nie istnieje lista zaakceptowanych pomysłów „na później”.
5. Baseline i final log są pełne; final nie zawiera nierozliczonych `SCRIPT ERROR`, parser errors, ObjectDB/RID leaks, orphanów ani nowych warningów.
6. Minimal/full/mixed dochodzą do Station 43 wyłącznie czasownikami gracza.
7. 3/3 finałów A/B/C przechodzą od legalnego stanu i zapisują właściwe konsekwencje.
8. Shell, save, continue, reset, pause, settings, cold open, remap, PL/EN i reduced motion są sprawdzone w runtime.
9. Każdy aktywny adres i powierzchnia UI ma świeży normal-driver capture po ostatniej zmianie.
10. Każdy używany stan animacji ma strip/klatki i pomiar albo jawne `NOT_APPLICABLE`.
11. 100% tekstów widocznych dla odbiorcy znajduje się w ledgerze i przeszło audit PL/EN bez uszkodzenia tokenów/logiki.
12. Audio ma inventory, pomiary i alternatywne kanały informacji krytycznej.
13. Performance ma pomiary normal-driver p50/p95/p99 oraz min. 3-cycle soak.
14. Każdy test krytyczny ma negatywną kontrolę lub uzasadniony brak; verifier nie zalicza logu z niedopuszczalnym warningiem.
15. Dokumentacja nie nazywa dowodu technicznego dowodem emocji, frajdy, urody ani ludzkiego zrozumienia.
16. Nie powstał web, Git ani nowy `.exe`; D-098/D-099/D-168 są zachowane.
17. Dokumentacja i snapshot opisują dokładnie ostatni stan dysku.

Jeżeli jakaś rzecz jest naprawdę nieweryfikowalna bez człowieka lub sprzętu, nie fabrykuj wyniku. Oznacz `OPEN-NO-EVIDENCE` lub `BLOCKED`, podaj skutek, tani plan odwrotu i wszystko, co zostało empirycznie sprawdzone wokół tej granicy. Sam brak playtestu ludzkiego nie pozwala zatrzymać implementacji ani zamknąć hipotezy jako `SUPPORTED`.

---

## WYMAGANE PLIKI KOŃCOWE

Utwórz/uzupełnij co najmniej:

- `docs/rebuild/PKG_0182_COMPREHENSIVE_AUDIT_REPORT.md`
- `reports/pkg_0182/inventory.tsv`
- `reports/pkg_0182/coverage_manifest.tsv`
- `reports/pkg_0182/findings.tsv`
- `reports/pkg_0182/research_ledger.md`
- `reports/pkg_0182/baseline.log`
- `reports/pkg_0182/final.log`
- `reports/pkg_0182/runtime_routes/`
- `reports/pkg_0182/visual/` i `visual_matrix.tsv`
- `reports/pkg_0182/animation/` i `animation_matrix.tsv`
- `reports/pkg_0182/text/` i `language_ledger.tsv`
- `reports/pkg_0182/audio/` i `audio_matrix.tsv`
- `reports/pkg_0182/performance.tsv`
- `reports/pkg_0182/test_integrity.tsv`
- `reports/pkg_0182/idea_ledger.md`
- proporcjonalne nowe/zmienione testy i narzędzia odtwarzające raporty;
- aktualne `docs/CURRENT_STATE.md`, `docs/INDEX.md`, `docs/ROADMAP.md`, `docs/RISKS_AND_HYPOTHESES.md`, `docs/DECISION_LOG.md`, append-only `docs/SESSION_LOG.md`, aktywne kontrakty i `docs/NEXT_SESSION_PROMPT.md`.

Nie dokumentuj wygenerowanych `.godot/`, starych `reports/` ani `dist/` jako źródła prawdy.

---

## KONIEC PAKIETU JEST OBOWIAZKOWY

1. Po wszystkich zmianach uruchom dokumentacyjny gate:

```powershell
pwsh -NoProfile -File .\tools\verify_docs.ps1 -ProjectRoot (Get-Location)
```

2. Uruchom pełną weryfikację i zachowaj pełny log:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

3. Przeskanuj final log. `Verification passed.` nie wystarcza, jeśli pozostał nierozliczony błąd/warning/leak.
4. Sprawdź świeże rendery normal-driver wizualnie i liczbowo. Sprawdź, że dowody powstały po ostatniej zmianie.
5. Zaktualizuj wszystkie dokumenty stanu, decyzji, ryzyk i handoffu.
6. Dopisz jeden kompletny wpis `## PKG-0182` do `docs/SESSION_LOG.md`.
7. Zamroź finalny stan:

```powershell
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0182
```

8. Potwierdź, że katalog snapshotu istnieje i zawiera plan, raport, zmienione źródła, testy i nowy handoff. Jeśli po snapshotcie zmienisz choć jeden plik, ponów finalne bramki i odśwież snapshot świadomie z `-Force`.

### Format raportu końcowego do właściciela

Podaj:

- wynik `PASS / PARTIAL / BLOCKED`;
- liczniki pokrycia per typ pliku i powierzchnię;
- findings P0/P1/P2/P3: znalezione, naprawione, otwarte;
- wszystkie wdrożone pomysły kreatywne i ich dowody before/after;
- komendy/testy, czasy, wyniki, hardware/driver i ścieżki raportów;
- status ObjectDB/RID oraz warning policy;
- osobno fakty `MEASURED/CONTRACT-PASS`, oceny `HEURISTIC` i odbiór `OPEN-NO-EVIDENCE`;
- ograniczenia (w tym brak zewnętrznych playtestów i brak fizycznego sprzętu, jeśli dotyczy);
- numer pakietu PKG-0182, ścieżkę snapshotu i nowy `NEXT_SESSION_PROMPT.md`.

Nie kończ na planie ani diagnozie. Wykonaj, sprawdź, popraw, recertyfikuj, zapisz historię i zamroź pakiet.
