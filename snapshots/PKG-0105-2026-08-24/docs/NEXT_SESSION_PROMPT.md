# NEXT SESSION PROMPT — PKG-0106

## CEL SESJI

Jesteś autonomicznym Lead Programmerem i Art Directorem projektu Getting
Strange. Właściciel upoważnił Cię do podejmowania decyzji technicznych,
narracyjnych i artystycznych bez zatrzymywania pracy na prośbę o zgodę.
Wykonuj ten pakiet krok po kroku, zapisuj każdą ukończoną zmianę natychmiast
na dysku i nie czekaj na odpowiedź właściciela.

Wykonaj wyłącznie przygotowany zakres PKG-0106. Jeśli znajdziesz rozjazd,
zdiagnozuj go w całym łańcuchu kod → test → dokumentacja, wybierz bezpieczną
decyzję zgodną z hierarchią prawdy i zapisz ją. Nie kończ pracy na audycie,
izolowanym teście ani samym kodzie.

## Twarde granice

- Katalog projektu: `C:\getting_strange`.
- Silnik: Godot `4.7.stable.official.5b4e0cb0f`, GDScript, Windows/PowerShell.
- To jest wyłącznie gra Godot. Nie buduj, nie przywracaj i nie proponuj strony,
  portalu, PWA, HTML/CSS/JS, Androida, Capacitor ani żadnej dystrybucji webowej.
- Projekt nie ma Git. Nie uruchamiaj `git`, nie inicjalizuj repozytorium i nie
  używaj snapshotów jako bieżącego źródła.
- Obowiązują D-096, D-098, D-099, D-105, D-106, ADR-003 i ADR-004.
- Zachowaj `CAMPAIGN_TRANSITION_LIMIT = 25`, `SAVE_SCHEMA_VERSION = 1`,
  fizykę 60 Hz, logiczny viewport 640x360, InputMap, istniejące podłogi,
  sufity, ściany, `AirlockZone`, checkpointy i promienie interakcji.
  Nie otwieraj przejścia 25→26 ani nie zmieniaj finałów 42A..42C/43.
- Nie dodawaj ruchomych platform do skakania, wiszących bloków, kolców,
  patrolujących wrogów, pasków zdrowia ani przeszkód istniejących wyłącznie po
  to, by mierzyć timing skoku. Maszyna może się poruszać tylko dlatego, że
  wykonuje pracę świata. Każda fizyczna przeszkoda musi mieć jednozdaniowe
  wyjaśnienie świata bez słowa „gracz”.
- Maksymalnie dwie nowe przeszkody diegetyczne w tym pakiecie. Stacja 41 może
  zachować świadomą ciszę mechaniczną, jeśli audyt potwierdzi, że decyzja
  operacyjna nie potrzebuje przeszkody. Nie dodawaj geometrii dla symetrii.
- Testy dowodzą kontraktów technicznych, nie funu, emocji, czytelności przez
  nową osobę ani zrozumienia fabuły. Nie nazywaj renderu playtestem.

## SRODOWISKO I BASELINE

Pracuj w `C:\getting_strange` na Windows/PowerShell z Godot 4.7. Przed
jakąkolwiek edycją uruchom bez filtrowania:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Oczekiwany stan po PKG-0105 to PASS z możliwymi ostrzeżeniami ObjectDB/RID
leak. Jeśli baseline nie pasuje, nie nadpisuj dokumentów dla pozoru zgodności;
prześledź pełny handoff i napraw tylko rzeczywisty kontrakt.

## OBOWIĄZKOWA KOLEJNOŚĆ WEJŚCIA

1. `AGENTS.md`
2. `docs/INDEX.md`
3. `docs/CURRENT_STATE.md`
4. ten plik `docs/NEXT_SESSION_PROMPT.md`
5. aktywna specyfikacja wymieniona w `CURRENT_STATE.md`
6. `docs/narrative/NARRATIVE_BIBLE.md`
7. `docs/PROTOTYPE_01_MOVEMENT_LAB.md`
8. `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`
9. `docs/TRAVERSAL_ACT_IIIC_AUDIT.md`
10. `VISUAL_DESIGN.md`, `docs/ROADMAP.md`, `docs/DECISION_LOG.md`,
    `docs/RISKS_AND_HYPOTHESES.md`, `docs/WORKFLOW.md`
11. `docs/narrative/FULL_STORY.md`, `docs/narrative/DIALOGUE_SCRIPT.md` i
    `docs/narrative/CONTINUITY_TRACKER.md` dla stacji 41 i finałów 42A..43
12. `scenes/levels/station_41.tscn`, `scripts/levels/station_41.gd`,
    odpowiednie skrypty wizualne/UI, testy PKG-0104/0105 i narzędzia capture.

## STAN POTWIERDZONY PO PKG-0105

- Station 01..40 mają aktywną warstwę stanu Vector-Stage; dla Station 21..40
  droga jest wyprowadzana z istniejących colliderów przez
  `VectorStageStyle.draw_play_plane(self, geometry)`.
- Station 38 ma jedyną przeszkodę pakietu PKG-0105: R3
  `Geometry/JakubRescueBulkhead`. Stan A jest przejściem, stan B blokującą
  śluzą tej samej pozycji; kotwica opiera korektę, a niezakotwiczona korekta
  zapisuje decyzję, resetuje checkpoint i wygasza detal węzła ratunkowego.
- Station 36, 37, 39 i 40 zachowują świadomą ciszę mechaniczną. Nie kopiuj
  przeszkód z poprzednich pakietów bez nowego audytu.
- Obowiązkowa bramka `pwsh -NoProfile -File .\tools\verify.ps1` po PKG-0105
  zakończyła się PASS. Ostrzeżenia ObjectDB/RID leak nie zmieniły kodu wyjścia.
- PKG-0105 wykonał i obejrzał pięć renderów
  `reports/pkg_0105/station_36.png`..`station_40.png` normalnym sterownikiem
  Windows/OpenGL Intel Iris Xe. Obecność kompozycji i drogi jest dowodem
  technicznym, nie dowodem odbioru.
- H-012 nadal ma status `UNTESTED`: nie wykonano pomiaru kontrastu, skalowania
  1x–4x ani symulacji deuteranopii/protanopii.
- Runtime i świeży handoff używają kolejności stacji 36..40; starsze fragmenty
  kanonu mają rozbieżne etykiety części scen. Nie renumeruj ich po cichu.
- Snapshot poprzedniego pakietu: `snapshots/PKG-0105-2026-08-24/`.

## CEL PAKIETU

Wykonać kolejny pionowy plaster dla `Station 41` — Komory Wyboru
Operacyjnego, w której Lena fizycznie załącza odpowiedzialność za jedną z
trzech operacji: Powrót (A), Uzgodnienie (B) albo Świadectwo (C). Stacja 41
otwiera przejście do już istniejących finałów 42A..42C, ale ten pakiet nie
przepisuje ich treści i nie rozszerza centralnego łańcucha kampanii poza 25.

## ZADANIA — WYKONUJ PO KOLEI, BEZ POMIJANIA

### 1. Baseline i wejście w kontrakt

Uruchom pełne `tools/verify.ps1`, zapisz wynik i porównaj go z tym promptem,
`CURRENT_STATE.md` oraz `SESSION_LOG.md`. Nie filtruj outputu, nie dodawaj retry,
workerów ani wyjątków dla progów.

### 2. Read-only audyt Station 41

Przed edycją zinwentaryzuj:

- `scenes/levels/station_41.tscn` i `scripts/levels/station_41.gd`;
- istniejące nazwy colliderów, `AirlockZone`, promienie rekwizytów i sygnały;
- istniejące `select_operation`, `operation_selected`, checkpoint i przejście
  do 42A..42C;
- stare procedury `_draw()` oraz wzorzec aktywnej warstwy z PKG-0104/0105;
- kontrakty `VectorStageEnvironment`, `AtmosphereRig`, `CRTDialogueBox`,
  `OpeningDialogueCue` i `AnchorableObject`.

Zapisz wynik w nowym `docs/TRAVERSAL_ACT_IV_AUDIT.md`. Audyt ma jawnie wybrać
„przeszkoda” albo „świadoma cisza” dla Station 41. Jeśli wybierzesz
przeszkodę, zapisz rodzinę R, jedno zdanie świata bez słowa „gracz”, trzy
pytania, koszt korekty, checkpoint i sposób zachowania wybranej operacji.
Komora decyzji nie może stać się testem zręcznościowym ani filtrem poprawnej
odpowiedzi.

### 3. Implementacja Vector-Stage i kontraktu wyboru

- Dodaj ręczny profil `VectorStageEnvironment` dla Station 41 zgodny z
  `VISUAL_DESIGN.md`: duże płaszczyzny, ograniczona paleta, twarde krawędzie,
  asymetryczna sylwetka, droga z realnej geometrii i brak pełnoekranowego filtra.
- Dodaj brakujące `AtmosphereRig`, `CRTDialogueBox` i `OpeningDialogueCue` z
  prawidłowym `station_number = 41` oraz `station_id = &"station_41"`.
- `_draw()` ma zaczynać się od `_draw_state_layer()`, a pierwszą operacją w
  `_draw_state_layer()` ma być `VectorStageStyle.draw_play_plane(self, geometry)`.
  Kadr należy do `VectorStageEnvironment`; stacja dorysowuje tylko relacje
  stanu, rekwizyty i istniejący HUD.
- Usuń z aktywnej ścieżki stare nieprzezroczyste tło, nie usuwając kodu
  narracyjnego, `select_operation`, istniejących rekwizytów ani colliderów.
- Jeśli audyt wybrał przeszkodę, użyj istniejącej klasy i kontraktu korekty:
  decyzja w `GameStateManager`, checkpoint, zanik konkretnego detalu, brak
  śmierci i brak paska zdrowia. Jeśli audyt wybrał ciszę, nie dodawaj
  `AnimatableBody2D`.
- Nie zmieniaj scen 42A..42C ani 43 poza koniecznością wykrytą przez test
  kontraktowy; nie zmieniaj `GameStateManager` ani limitu kampanii.

### 4. Test PKG-0106 i bramka

Utwórz `tests/pkg_0106_smoke_test.gd` i dopisz jedną bramkę do
`tools/verify.ps1`, zachowując wszystkie wcześniejsze bramki. Test ma sprawdzać
co najmniej:

- ładowanie Station 41 i profile `VectorStageEnvironment`, AtmosphereRig,
  CRTDialogueBox oraz OpeningDialogueCue;
- aktywną warstwę stanu, pierwszeństwo `draw_play_plane()` i brak starego
  nieprzezroczystego tła w aktywnym `_draw()`;
- obecność `Player`, `level_completed`, `AirlockZone`, niezmienione shell
  collidery, promienie rekwizytów, `select_operation` i trzy warianty A/B/C;
- dokładną liczbę i nazwy przeszkód, jeśli audyt ją wybierze, albo zero
  `AnimatableBody2D`, jeśli wybierze świadomą ciszę;
- nagłówki trzech pytań bez słowa „gracz” w zdaniu o świecie;
- `CAMPAIGN_TRANSITION_LIMIT == 25`, `SAVE_SCHEMA_VERSION == 1` i brak
  przejścia 25→26.

Nie obniżaj progów i nie wyłączaj istniejących testów.

### 5. Capture i inspekcja

Utwórz `tools/capture_pkg_0106.gd`. Uruchom go normalnym sterownikiem Windows,
nie headless, i zapisz dokładnie:

`reports/pkg_0106/station_41.png`.

Obejrzyj kadr przez narzędzie obrazu. Sprawdź obecność trzech stanowisk,
czytelną drogę i hierarchię komory bez stwierdzania, że nowa osoba ją rozumie.
Jeśli kadr narusza kanon palety, drogę albo skalę akcentów, popraw źródło i
powtórz capture przed zamknięciem.

### 6. Dokumentacja, zamknięcie i handoff

Po PASS zaktualizuj zgodnie z rzeczywistym wynikiem:

- `docs/CURRENT_STATE.md`;
- `docs/SESSION_LOG.md` — jeden wpis PKG-0106, append-only;
- `docs/ROADMAP.md`;
- `docs/DECISION_LOG.md` — D-107, jeśli pakiet zmieni kontrakt;
- `docs/RISKS_AND_HYPOTHESES.md`, jeśli pojawił się nowy dowód lub ograniczenie;
- `docs/INDEX.md` z audytem `TRAVERSAL_ACT_IV_AUDIT.md`;
- ten plik: zastąp go samodzielnym promptem PKG-0107.

Na samym końcu uruchom ponownie:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0106
```

Sprawdź istnienie `snapshots/PKG-0106-2026-08-24/`. Snapshot jest zamrożoną
kopią aktualnego stanu, nie źródłem dalszej edycji. Raport końcowy ma podać
testy, ograniczenia, numer PKG-0106, snapshot i ścieżkę promptu PKG-0107.

## KRYTERIA AKCEPTACJI

Pakiet jest technicznie zaakceptowany dopiero, gdy Station 41 przechodzi
bramkę PKG-0106, pełny verify jest PASS, render istnieje i został obejrzany,
audyt przeszkód jest zapisany, a dokumenty opisują faktyczny zakres bez
twierdzeń o odbiorze.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Nie kończ pracy na kodzie ani na izolowanym teście. Końcem jest dopiero
udokumentowany PASS, świeży capture, aktualny prompt PKG-0107 i snapshot
PKG-0106 na dysku.
