# NEXT SESSION PROMPT — PKG-0105

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
- Obowiązują D-096, D-098, D-099, D-104, D-105, ADR-003 i ADR-004.
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
po PKG-0104 to PASS z możliwymi ostrzeżeniami ObjectDB/RID leak.

## OBOWIĄZKOWA KOLEJNOŚĆ WEJŚCIA

1. `AGENTS.md`
2. `docs/INDEX.md`
3. `docs/CURRENT_STATE.md`
4. ten plik `docs/NEXT_SESSION_PROMPT.md`
5. `docs/narrative/NARRATIVE_BIBLE.md`
6. `docs/PROTOTYPE_01_MOVEMENT_LAB.md`
7. `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`
8. `docs/TRAVERSAL_ACT_IIIB_AUDIT.md`
9. `VISUAL_DESIGN.md`, `docs/ROADMAP.md`, `docs/DECISION_LOG.md`,
   `docs/RISKS_AND_HYPOTHESES.md`, `docs/WORKFLOW.md`
10. `docs/narrative/FULL_STORY.md`, `docs/narrative/DIALOGUE_SCRIPT.md` i
    `docs/narrative/CONTINUITY_TRACKER.md` dla scen 36–40.
11. Źródła i sceny wymienione poniżej oraz istniejące bramki PKG-0102,
    PKG-0103 i PKG-0104.

## STAN POTWIERDZONY PO PKG-0104

- Station 01..35 mają aktywną warstwę stanu Vector-Stage; dla Station 21..35
  droga jest wyprowadzana z istniejących colliderów przez
  `VectorStageStyle.draw_play_plane(self, geometry)`.
- Station 30 ma R1 `Geometry/WitnessRelayBank`, Station 32 ma R6
  `Geometry/ObservedGlassTrace`, a Station 33 ma R1
  `Geometry/DualWitnessFrame`; wszystkie są chronione przez istniejące API
  `AnchorableObject` i własne bramki pakietów.
- Station 27..29 oraz 31, 34 i 35 zachowują świadomą ciszę. Ich decyzje są
  zapisane w audytach przeszkód, więc kolejny pakiet nie może dodawać geometrii
  tylko dla symetrii.
- Obowiązkowa bramka `pwsh -NoProfile -File .\tools\verify.ps1` zakończyła się
  po PKG-0104 wynikiem PASS. Ostrzeżenia ObjectDB/RID leak nie zmieniły kodu
  wyjścia.
- PKG-0104 wykonał i obejrzał pięć renderów w
  `reports/pkg_0104/station_31.png`..`station_35.png` normalnym sterownikiem
  Windows/OpenGL Intel Iris Xe. Obecność kompozycji i drogi jest dowodem
  technicznym, nie dowodem odbioru.
- H-012 nadal ma status `UNTESTED`: nie wykonano pomiaru kontrastu, skalowania
  1x–4x ani symulacji deuteranopii/protanopii.
- Snapshot bieżącego pakietu: `snapshots/PKG-0104-2026-08-24/`.

## CEL PAKIETU

Wykonać następny bezpieczny pionowy plaster dla `Station 36..40` — Kanał
Odpływowy / Zimny Ściek, Komora Sygnałowa, Człowiek zamiast dowodu, Komora
Referencyjna i Sala Negocjacyjna otwierająca Akt IV. Każda scena ma otrzymać
realnie widoczną kompozycję Vector-Stage i kontrakt zgodny z audytem przeszkód.
Nie rozszerzać łańcucha kampanii poza Station 25.

## ZADANIA — WYKONUJ PO KOLEI, BEZ POMIJANIA

### 1. Baseline i rozbieżność handoffu

Uruchom bez filtrowania:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Zapisz wynik i porównaj go z `CURRENT_STATE.md`. Jeśli wynik przeczy temu
promptowi, najpierw zdiagnozuj pełny łańcuch handoffu; nie nadpisuj żadnego
stanu tylko po to, by dopasować dokument.

### 2. Read-only audyt scen 36–40

Przeczytaj i zinwentaryzuj przed edycją:

- `scenes/levels/station_36.tscn` … `station_40.tscn`;
- `scripts/levels/station_36.gd` … `station_40.gd`;
- istniejące nazwy colliderów, `AirlockZone`, promienie rekwizytów, sceniczne
  `VectorStageEnvironment` oraz ewentualne stare procedury `_draw()`;
- istniejące klasy `AnchorableObject`, `MovableAnchorableProp`, korektę,
  checkpoint i sygnał `level_completed`;
- profile i aktywne warstwy stanu z PKG-0103 i PKG-0104 jako wzorzec techniczny,
  nie jako powód do kopiowania przeszkód.

Zapisz wynik w nowym pliku `docs/TRAVERSAL_ACT_IIIC_AUDIT.md`. Dla każdej z
pięciu scen zapisz decyzję „przeszkoda” albo „świadoma cisza”, rodzinę R,
jedno zdanie świata, trzy pytania, koszt korekty albo powód braku korekty.
Uwzględnij, że Station 39 domyka Podstrukturę, a Station 40 otwiera Akt IV;
nie zamieniaj tego przejścia fabularnego w test zręcznościowy. Nie dodawaj
przeszkody tylko dla symetrii pakietu.

### 3. Implementacja Vector-Stage i mechaniki

- Dodaj ręczne profile `VectorStageEnvironment` dla Station 36..40 zgodne z
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
  decyzja w `GameStateManager`, checkpoint, zanik konkretnego detalu, brak
  śmierci i brak paska zdrowia. Jeśli wybierze ciszę, nie dodawaj
  `AnimatableBody2D` tylko po to, by wypełnić scenę.

### 4. Test PKG-0105 i bramka

Utwórz `tests/pkg_0105_smoke_test.gd` i dopisz ją do `tools/verify.ps1`.
Test musi sprawdzać co najmniej:

- ładowanie scen 36..40 i profile `VectorStageEnvironment`;
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

Utwórz `tools/capture_pkg_0105.gd`. Uruchom go normalnym sterownikiem Windows,
nie headless, i zapisz dokładnie:

`reports/pkg_0105/station_36.png` … `reports/pkg_0105/station_40.png`.

Obejrzyj wszystkie pięć plików przez narzędzie obrazu. Zapisz w logu, co
faktycznie widać i czego render nie dowodzi. Jeśli kadr narusza kanon palety,
czytelność drogi albo skalę akcentu, popraw źródło i powtórz capture przed
zamknięciem.

### 6. Dokumentacja, zamknięcie i handoff

## KRYTERIA AKCEPTACJI

Pakiet jest technicznie zaakceptowany dopiero, gdy sceny 36..40 przechodzą
bramkę PKG-0105, pełny verify jest PASS, pięć renderów istnieje i zostało
obejrzanych, a dokumenty opisują faktyczny zakres bez twierdzeń o odbiorze.

Po PASS zaktualizuj zgodnie z rzeczywistym wynikiem:

- `docs/CURRENT_STATE.md`;
- `docs/SESSION_LOG.md` — jeden wpis PKG-0105, append-only;
- `docs/ROADMAP.md`;
- `docs/DECISION_LOG.md` — następna decyzja D-106, jeśli pakiet zmienia kontrakt;
- `docs/RISKS_AND_HYPOTHESES.md`, jeśli pojawił się nowy dowód lub ograniczenie;
- `docs/INDEX.md` z audytem `TRAVERSAL_ACT_IIIC_AUDIT.md`;
- ten plik: zastąp go samodzielnym promptem PKG-0106.

Na samym końcu uruchom ponownie:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0105
```

Sprawdź, że istnieje `snapshots/PKG-0105-2026-08-24/` i że snapshot jest
zamrożoną kopią aktualnego stanu, nie źródłem dalszej edycji. Raport końcowy
ma podać testy, ograniczenia, numer PKG-0105, snapshot i ścieżkę nowego promptu.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Nie kończ pracy na kodzie ani na izolowanym teście. Końcem jest dopiero
udokumentowany PASS, świeży capture, aktualny prompt PKG-0106 i snapshot
PKG-0105 na dysku.
