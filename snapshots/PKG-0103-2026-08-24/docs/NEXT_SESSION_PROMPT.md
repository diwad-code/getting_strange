# NEXT SESSION PROMPT — PKG-0104

## CEL SESJI

Jesteś autonomicznym Lead Programmerem i Art Directorem projektu Getting
Strange. Właściciel upoważnił Cię do podejmowania decyzji technicznych,
narracyjnych i artystycznych bez zatrzymywania pracy na prośbę o zgodę.
Wykonuj ten pakiet krok po kroku, zapisuj każdą ukończoną zmianę natychmiast
na dysku i nie czekaj na odpowiedź właściciela.

## Twarde granice

- Katalog projektu: `C:\getting_strange`.
- Silnik: Godot `4.7.stable.official.5b4e0cb0f`, GDScript, Windows/PowerShell.
- To jest wyłącznie gra Godot. Nie buduj, nie przywracaj i nie proponuj strony,
  portalu, PWA, HTML/CSS/JS, Androida, Capacitor ani żadnej dystrybucji webowej.
- Projekt nie ma Git. Nie uruchamiaj `git`, nie inicjalizuj repozytorium i nie
  używaj snapshotów jako bieżącego źródła.
- Obowiązują D-096, D-098, D-099, D-104, ADR-003 i ADR-004.
- Zachowaj `CAMPAIGN_TRANSITION_LIMIT = 25`, `SAVE_SCHEMA_VERSION = 1`,
  fizykę 60 Hz, logiczny viewport 640x360, InputMap, istniejące podłogi,
  sufity, ściany, `AirlockZone`, checkpointy i promienie interakcji.
  Nie otwieraj przejścia 25→26 w tym pakiecie.
- Nie dodawaj ruchomych platform do skakania, wiszących bloków, kolców,
  patrolujących wrogów, pasków zdrowia ani przeszkód istniejących wyłącznie po
  to, by mierzyć timing skoku. Maszyna może się poruszać tylko dlatego, że
  wykonuje pracę świata. Każda fizyczna przeszkoda musi mieć jednozdaniowe
  wyjaśnienie świata bez słowa „gracz”.
- Maksymalnie dwie nowe przeszkody diegetyczne w tym pakiecie. Pozostałe sceny
  mogą i powinny zachować świadomą ciszę, jeśli wynika to z audytu.
- Testy dowodzą kontraktów technicznych, nie funu, emocji, czytelności przez
  nową osobę ani zrozumienia fabuły. Nie nazywaj renderu playtestem.

## SRODOWISKO I BASELINE

Pracuj w `C:\getting_strange` na Windows/PowerShell z Godot 4.7. Przed
jakąkolwiek edycją uruchom pełne `tools/verify.ps1`; aktualny oczekiwany stan
po PKG-0103 to PASS z możliwymi ostrzeżeniami ObjectDB leak.

## Obowiązkowa kolejność wejścia

1. `AGENTS.md`
2. `docs/INDEX.md`
3. `docs/CURRENT_STATE.md`
4. ten plik `docs/NEXT_SESSION_PROMPT.md`
5. `docs/narrative/NARRATIVE_BIBLE.md`
6. `docs/PROTOTYPE_01_MOVEMENT_LAB.md`
7. `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`
8. `docs/TRAVERSAL_ACT_III_AUDIT.md`
9. `VISUAL_DESIGN.md`, `docs/ROADMAP.md`, `docs/DECISION_LOG.md`,
   `docs/RISKS_AND_HYPOTHESES.md`, `docs/WORKFLOW.md`
10. `docs/narrative/FULL_STORY.md`, `docs/narrative/DIALOGUE_SCRIPT.md` i
    `docs/narrative/CONTINUITY_TRACKER.md` dla scen 31–35.
11. Źródła i sceny wymienione poniżej oraz istniejące bramki PKG-0101,
    PKG-0102 i PKG-0103.

## Stan potwierdzony po PKG-0103

- Station 01..30 mają aktywną warstwę stanu Vector-Stage; dla 26..30 drogę
  wyprowadza `VectorStageStyle.draw_play_plane(self, geometry)`.
- Station 26 ma R5 `Geometry/AdaptiveIsolationPartition`; Station 30 ma R1
  `Geometry/WitnessRelayBank` jako `AnchorableObject`; Station 27..29 mają
  świadomą ciszę. Ich kontrakt jest zapisany w
  `docs/TRAVERSAL_ACT_III_AUDIT.md`.
- Obowiązkowa bramka `pwsh -NoProfile -File .\tools\verify.ps1` zakończyła się
  po PKG-0103 wynikiem PASS. Istniejące ostrzeżenia ObjectDB leak nie zmieniły
  kodu wyjścia.
- PKG-0103 wykonał pięć obejrzanych renderów w
  `reports/pkg_0103/station_26.png`..`station_30.png` normalnym sterownikiem
  Windows/OpenGL Intel Iris Xe.
- H-012 nadal ma status `UNTESTED`: obecność kadru została obejrzana, ale nie
  wykonano pomiaru kontrastu, skalowania 1x–4x ani symulacji daltonizmu.
- Snapshot bieżącego pakietu: `snapshots/PKG-0103-2026-08-24/`.

## Cel pakietu

Wykonać następny bezpieczny pionowy plaster dla `Station 31..35` — magazyn
Jedenaście Krzeseł, Ślad w szkle, Próba rozdzielenia, Pamięć kostnicy i Marta
schodzi — z aktywną kompozycją Vector-Stage, audytem przeszkód zgodnym z
kanonem oraz dowodem technicznym. Nie rozszerzać łańcucha kampanii.

## Zadania — wykonuj po kolei, bez pomijania

### 1. Baseline i rozbieżność handoffu

Uruchom bez filtrowania:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Zapisz wynik i porównaj go z `CURRENT_STATE.md`. Jeśli wynik przeczy temu
promptowi, najpierw zdiagnozuj pełny łańcuch handoffu; nie nadpisuj żadnego
stanu tylko po to, by dopasować dokument.

### 2. Read-only audyt scen 31–35

Przeczytaj i zinwentaryzuj przed edycją:

- `scenes/levels/station_31.tscn` … `station_35.tscn`;
- `scripts/levels/station_31.gd` … `station_35.gd`;
- istniejące nazwy colliderów, `AirlockZone`, promienie rekwizytów, sceniczne
  `VectorStageEnvironment` oraz ewentualne stare procedury `_draw()`;
- istniejące klasy `AnchorableObject`, `MovableAnchorableProp`, korekta,
  checkpoint i sygnał `level_completed`.

Zapisz wynik w nowym pliku `docs/TRAVERSAL_ACT_IIIB_AUDIT.md`. Dla każdej z
pięciu scen zapisz: decyzję „przeszkoda” albo „świadoma cisza”, rodzinę R,
jedno zdanie świata, trzy pytania, koszt korekty albo powód braku korekty.
Nie dodawaj przeszkody tylko dla symetrii pakietu.

### 3. Implementacja Vector-Stage i mechaniki

- Dodaj ręczne profile `VectorStageEnvironment` dla Station 31..35 zgodne z
  `VISUAL_DESIGN.md`; nie kopiuj pełnoekranowego tła ze starych skryptów.
- Dodaj `AtmosphereRig`, `CRTDialogueBox`, `OpeningDialogueCue` i prawidłowy
  `station_number` tylko tam, gdzie ich brakuje.
- `_draw()` każdej konwertowanej stacji ma zaczynać się od
  `_draw_state_layer()`, a pierwszą operacją w `_draw_state_layer()` ma być
  `VectorStageStyle.draw_play_plane(self, geometry)`. Kadr należy do
  `VectorStageEnvironment`; warstwa stacji może dorysować tylko relacje stanu,
  rekwizyty i istniejący HUD.
- Usuń z aktywnej ścieżki tylko nieprzezroczyste legacy backgrounds; nie ruszaj
  podłogi, sufitu, ścian, `AirlockZone`, zasięgów ani danych zapisu.
- Jeśli audyt wybierze przeszkodę, użyj istniejącej klasy i kontraktu korekty:
  decyzja w `GameStateManager`, checkpoint, zanik konkretnego detalu, brak śmierci
  i brak paska zdrowia. Jeśli wybierze ciszę, nie dodawaj `AnimatableBody2D`.

### 4. Test PKG-0104 i bramka

Utwórz `tests/pkg_0104_smoke_test.gd` i dopisz ją do `tools/verify.ps1`.
Test musi sprawdzać co najmniej:

- ładowanie scen 31..35 i profile `VectorStageEnvironment`;
- aktywną warstwę stanu oraz pierwszeństwo `draw_play_plane()`;
- obecność `Player`, `level_completed`, `AirlockZone` i niezmienione shell
  collidery oraz promienie rekwizytów;
- dokładną liczbę i nazwy wybranych przeszkód, zero dodatkowych przeszkód w
  scenach świadomej ciszy oraz techniczne działanie korekty;
- nagłówki trzech pytań bez słowa „gracz” w zdaniu o świecie;
- `CAMPAIGN_TRANSITION_LIMIT == 25`, `SAVE_SCHEMA_VERSION == 1` i granicę
  bez przejścia 25→26.

Nie obniżaj progów, nie filtruj outputu, nie dodawaj retry/workerów ani nie
wyłączaj istniejących bramek.

### 5. Capture i inspekcja

Utwórz `tools/capture_pkg_0104.gd`. Uruchom go normalnym sterownikiem Windows,
nie headless, i zapisz dokładnie:

`reports/pkg_0104/station_31.png` … `reports/pkg_0104/station_35.png`.

Obejrzyj wszystkie pięć plików przez narzędzie obrazu. Zapisz w logu, co
faktycznie widać i czego render nie dowodzi. Jeśli kadr narusza kanon palety,
czytelność drogi albo skalę akcentu, popraw źródło i powtórz capture przed
zamknięciem.

### 6. Dokumentacja, zamknięcie i handoff

## KRYTERIA AKCEPTACJI

Pakiet jest technicznie zaakceptowany dopiero, gdy sceny 31..35 przechodzą
bramkę PKG-0104, pełny verify jest PASS, pięć renderów istnieje i zostało
obejrzanych, a dokumenty opisują faktyczny zakres bez twierdzeń o odbiorze.

Po PASS zaktualizuj zgodnie z rzeczywistym wynikiem:

- `docs/CURRENT_STATE.md`;
- `docs/SESSION_LOG.md` — jeden wpis PKG-0104, append-only;
- `docs/ROADMAP.md`;
- `docs/DECISION_LOG.md` — następna decyzja D-105, jeśli pakiet zmienia kontrakt;
- `docs/RISKS_AND_HYPOTHESES.md`, jeśli pojawił się nowy dowód lub ograniczenie;
- `docs/INDEX.md` z audytem `TRAVERSAL_ACT_IIIB_AUDIT.md`;
- ten plik: zastąp go samodzielnym promptem PKG-0105.

Na samym końcu uruchom ponownie:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0104
```

Sprawdź, że istnieje `snapshots/PKG-0104-2026-08-24/` i że snapshot jest
zamrożoną kopią aktualnego stanu, nie źródłem dalszej edycji. Raport końcowy
ma podać testy, ograniczenia, numer PKG-0104, snapshot i ścieżkę nowego promptu.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Nie kończ pracy na kodzie ani na izolowanym teście. Końcem jest dopiero
udokumentowany PASS, świeży capture, aktualny prompt PKG-0105 i snapshot
PKG-0104 na dysku.
