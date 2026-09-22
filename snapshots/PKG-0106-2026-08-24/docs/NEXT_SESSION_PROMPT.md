# NEXT_SESSION_PROMPT — PKG-0107

## CEL SESJI

Domknąć techniczną, widoczną warstwę Vector-Stage dla scen 42A–42C i 43,
zachowując bez zmian istniejące trzy finały, ich rozgałęzienia oraz granicę
kampanii.

## SRODOWISKO I BASELINE

Godot 4.7, Windows/PowerShell, logiczny viewport 640x360, projekt bez Git.
Pierwszą bramką jest `pwsh -NoProfile -File .\tools\verify.ps1`; wynik musi
być zapisany przed edycją i ponownie po zamknięciu pakietu.

## Tożsamość pakietu

Jesteś Lead Programmerem i Art Directorem projektu Getting Strange. Wykonaj
ten pakiet autonomicznie, krok po kroku, bez pytania o zgodę i bez zatrzymywania
pracy dla ręcznego review. Decyzje techniczne, mechaniczne i artystyczne
podejmuj na podstawie aktualnego kodu, kanonu oraz lokalnych skilli. Zapisuj
każdy ukończony etap natychmiast na dysku.

## Twardy zakres

Getting Strange jest grą w Godot 4.7 i niczym innym. Nie twórz ani nie
przywracaj strony WWW, HTML/CSS/JS, PWA, portalu, WebView, Capacitor, Androida,
Gradle, Google Play ani żadnej innej powierzchni dystrybucji poza silnikiem
Godot. Nie uruchamiaj Git: projekt nie ma repozytorium, gałęzi ani historii.

Ten pakiet dotyczy wyłącznie widocznej warstwy scen finałowych:

- `scenes/levels/station_42a.tscn` — finał Powrót;
- `scenes/levels/station_42b.tscn` — finał Uzgodnienie;
- `scenes/levels/station_42c.tscn` — finał Świadectwo;
- `scenes/levels/station_43.tscn` — ostatnia przestrzeń / domknięcie kampanii.

Nie zmieniaj bez osobnej, zapisanej decyzji kanonu finałów, treści dialogów,
warunków wyboru, kosztów decyzji, sygnałów ukończenia, `GameStateManager`,
`CAMPAIGN_TRANSITION_LIMIT = 25`, `SAVE_SCHEMA_VERSION = 1`, InputMap, fizyki
60 Hz, istniejących shell colliderów, `AirlockZone` ani sceny Station 41.
Nie renumeruj scen 42A–42C/43 i nie scalaj ich. Runtime i aktualny handoff
mają pierwszeństwo przed starszymi etykietami w dokumentach.

## Stan potwierdzony po PKG-0106

- Pełny `pwsh -NoProfile -File .\tools\verify.ps1` przechodzi przed
  rozpoczęciem tego pakietu.
- Widoczna warstwa Vector-Stage jest zamknięta dla Station 06..41. Station 41
  ma ręczny profil sceny, trzy stanowiska A/B/C, zachowany wybór operacji oraz
  świadomą mechaniczną ciszę: zero nowej przeszkody, `AnimatableBody2D` i
  `StaticBody2D`. Dowód znajduje się w `docs/TRAVERSAL_ACT_IV_AUDIT.md`.
- Wzorzec sceny to `VectorStageEnvironment`, `AtmosphereRig`, `CRTDialogueBox`
  i `OpeningDialogueCue`; aktywny `_draw()` skryptu stacji wywołuje
  `_draw_state_layer()`, którego pierwszą operacją jest
  `VectorStageStyle.draw_play_plane(self, geometry)`.
- `tests/pkg_0106_smoke_test.gd` i pełna bramka verify chronią Station 41 oraz
  granicę 25. Testy PKG-0104/0105 sprawdzają checkpoint na granicy resetu,
  przed następnym tickiem fizyki.
- `H-012` pozostaje `UNTESTED`: render i automaty dowodzą kontraktów
  technicznych, nie funu, emocji, czytelności przez nową osobę ani zrozumienia
  fabuły. Nie zapisuj twierdzeń o playtestach ani o odbiorze gracza.

## Obowiązkowa kolejność pracy

### 1. Start i baseline

W katalogu `C:\getting_strange` przeczytaj w tej kolejności:

1. `AGENTS.md`;
2. `docs/INDEX.md`;
3. `docs/CURRENT_STATE.md`;
4. ten plik `docs/NEXT_SESSION_PROMPT.md`;
5. aktywną specyfikację wskazaną przez `CURRENT_STATE.md`, w szczególności
   `docs/narrative/NARRATIVE_BIBLE.md`, `VISUAL_DESIGN.md` i
   `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`;
6. `docs/narrative/FULL_STORY.md`, `docs/narrative/DIALOGUE_SCRIPT.md` i
   `docs/narrative/CONTINUITY_TRACKER.md` dla czterech scen finałowych;
7. źródła `scripts/levels/station_42a.gd`, `station_42b.gd`, `station_42c.gd`,
   `station_43.gd`, sceny 42A–42C/43, `VectorStageEnvironment`,
   `AtmosphereRig`, `CRTDialogueBox`, `OpeningDialogueCue`, `GameStateManager`
   oraz odpowiadające testy w `tests/smoke_test.gd`.

Następnie uruchom i zapisz wynik baseline:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Jeśli baseline nie przejdzie, zdiagnozuj pełny łańcuch i napraw tylko regresję
niezbędną do odzyskania kontraktu; nie zmieniaj progów, timeoutów, workerów,
retry ani zakresu testów.

### 2. Audyt traversal przed edycją

Wykonaj read-only audyt 42A–42C/43 i zapisz go jako
`docs/TRAVERSAL_ACT_IV_FINAL_AUDIT.md`. Dla każdej sceny zinwentaryzuj:

- istniejące floor/walls/shell collidery, `AirlockZone` i rekwizyty;
- istniejące `StaticBody2D`, `AnimatableBody2D`, `AnchorableObject` i ruchome
  elementy, bez uznawania samej obecności za dowód przeszkody;
- świat, funkcję pomieszczenia, aktywną logikę finału i drogę do wyjścia;
- odpowiedź na trzy pytania z kanonu przeszkód: co robi obiekt w świecie, co
  się zmienia po stanie A/B oraz jaki jest koszt korekty.

Domyślny wybór dla scen finałowych to świadoma cisza, jeśli nowa geometria nie
jest konieczna dla opisanej pracy świata. Nie dodawaj przeszkód do dekoracji.
Jeżeli audyt wykaże konieczny element diegetyczny, cały pakiet może dodać
najwyżej dwie przeszkody łącznie; każda musi mieć uzasadnienie bez słowa
„gracz”, stałą pozycję lub stałe montaże, istniejącą rodzinę R1–R7,
`AnchorableObject`/istniejący wzorzec korekty oraz test kontraktu. Zakaz
platform do skakania, kolców, wrogów, pasków zdrowia i obstacle-course pozostaje
twardy. Nie dodawaj `AnimatableBody2D` w wariancie świadomej ciszy.

### 3. Implementacja widocznej warstwy finałów

Dla 42A, 42B, 42C i 43 dodaj ręcznie dobrany, deterministyczny profil
`VectorStageEnvironment` zgodny z `VISUAL_DESIGN.md`: duże płaszczyzny,
ograniczona paleta, twarde krawędzie, asymetryczne sylwetki, droga widoczna w
dolinie kadru i punktowe akcenty stanu. Warianty finału mają być rozróżnialne
kompozycyjnie, ale nie mogą kodować „dobrej” odpowiedzi jako nagrody wizualnej;
utrzymaj symetrię H-011a.

Każda scena ma otrzymać, jeśli nie ma ich już w aktualnym runtime:

- `VectorStageEnvironment` z deterministycznym profilem i seedem;
- `AtmosphereRig` z właściwym numerem sceny;
- `CRTDialogueBox`;
- `OpeningDialogueCue` z dokładnym `station_id` (`station_42a`,
  `station_42b`, `station_42c`, `station_43`).

Każdy skrypt ma zachować aktywny podział odpowiedzialności:

```gdscript
func _draw() -> void:
    _draw_state_layer()
    # dopiero potem HUD/dialogue, jeśli scena go potrzebuje
```

Pierwszą operacją w `_draw_state_layer()` musi być dokładnie:

```gdscript
VectorStageStyle.draw_play_plane(self, geometry)
```

Stare nieprzezroczyste tła mogą pozostać wyłącznie jako nieaktywna ścieżka
legacy. Zachowaj wszystkie istniejące rozgałęzienia, flagi, koszty, wybory
finale, interakcje, sygnały, checkpointy, napisy i warunki wyjścia. Nie twórz
globalnego menedżera i nie przenoś logiki do `GameStateManager`.

### 4. Test i dowód runtime

Dodaj `tests/pkg_0107_smoke_test.gd` oraz dokładnie jedną bramkę do
`tools/verify.ps1`, zachowując wszystkie poprzednie bramki. Test ma sprawdzić
co najmniej:

- ładowanie i typy scen 42A–42C/43;
- profile, seed/numer sceny, `AtmosphereRig`, `CRTDialogueBox` i cue z poprawnym
  `station_id`;
- kolejność `_draw()` / `_draw_state_layer()` / `draw_play_plane()` oraz brak
  aktywnego starego pełnoekranowego tła;
- pełne istniejące rozgałęzienia A/B/C i stan `station_43`, wyjścia oraz
  sygnały ukończenia, bez zmiany ich semantyki;
- shell collidery, `AirlockZone`, promienie rekwizytów i brak niedozwolonej
  geometrii; jeśli audyt wybrał ciszę, dokładnie zero nowych przeszkód;
- `CAMPAIGN_TRANSITION_LIMIT = 25`, `SAVE_SCHEMA_VERSION = 1` oraz fakt, że
  Station 25 nie odblokowuje niedostarczonej Station 26;
- trzy pytania i korektę dla każdej ewentualnej nowej przeszkody.

Nie maskuj błędów przez `process_frame`, jeśli asercja dotyczy granicy resetu:
sprawdzaj checkpoint natychmiast po operacji resetującej, przed tickiem fizyki,
tak jak naprawiono w PKG-0104/0105. Nie zmieniaj runtime tylko po to, żeby
dopasować stary test.

### 5. Capture i inspekcja

Dodaj `tools/capture_pkg_0107.gd`. Uruchom capture normalnym sterownikiem
Windows/OpenGL, nie headless, i zapisz świeże kadry:

```text
reports/pkg_0107/station_42a.png
reports/pkg_0107/station_42b.png
reports/pkg_0107/station_42c.png
reports/pkg_0107/station_43.png
```

Użyj logicznego viewportu 640x360. Obejrzyj wszystkie cztery pliki narzędziem
obrazu. Sprawdź technicznie, bez twierdzeń o odbiorze: czy droga nie jest
zasłonięta, profile faktycznie widać, akcenty są punktowe, paleta ograniczona,
nie ma filtra pełnoekranowego ani przypadkowej geometrii zręcznościowej.

### 6. Dokumentacja i zamknięcie

Po przejściu testu:

- uzupełnij `docs/CURRENT_STATE.md` o zamknięty PKG-0107 i kolejny prompt;
- dopisz dokładnie jeden wpis PKG-0107 do `docs/SESSION_LOG.md`;
- uzupełnij `docs/ROADMAP.md`, `docs/DECISION_LOG.md` (D-108, jeśli audyt
  ustanawia nowy kontrakt), `docs/RISKS_AND_HYPOTHESES.md` i `docs/INDEX.md`;
- opisz ograniczenia: brak playtestów, H-012 nadal `UNTESTED`, brak dowodu
  funu, emocji, czytelności przez nową osobę i zrozumienia fabuły;
- zastąp ten plik samowystarczalnym promptem PKG-0108 dla następnego pakietu;
- uruchom końcowo:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0107
```

Sprawdź, że snapshot istnieje w `snapshots/PKG-0107-2026-08-24/`. Nie czytaj
go jako bieżącego stanu i nie edytuj go. W końcowym raporcie podaj testy,
capture'y, ostrzeżenia, ograniczenia, identyfikator pakietu i ścieżkę handoffu.

## KRYTERIA AKCEPTACJI

Pakiet jest zamknięty dopiero, gdy Station 42A–42C/43 ma widoczną, rzeczywistą
warstwę Vector-Stage, wszystkie istniejące finały nadal działają, audyt i test
są zapisane, cztery kadry zostały wykonane i obejrzane, dokumentacja opisuje
stan faktyczny, końcowy verify przechodzi, a snapshot PKG-0107 istnieje. Nie
opisuj hipotez odbiorczych jako faktów i nie otwieraj żadnego zakresu poza
Godotem.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Nie kończ sesji przed aktualizacją `CURRENT_STATE.md`, `SESSION_LOG.md`,
`ROADMAP.md`, `DECISION_LOG.md`, `RISKS_AND_HYPOTHESES.md`, `INDEX.md` i tego
promptu, końcowym verify oraz snapshotem `PKG-0107`.
