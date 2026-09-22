# PKG-0114 — R0: produkcyjny shell i pełna topologia kampanii

Wykonaj ten pakiet autonomicznie, krok po kroku, bez przystanków na aprobatę.
Podejmuj decyzje techniczne i artystyczne jako Lead Programmer i Art Director.
Zatrzymaj się wyłącznie przy prawdziwym blokerze, którego nie da się rozstrzygnąć
z runtime, dokumentacji i testów.

## CEL SESJI

Zamień istniejący zbiór scen w grę, którą można technicznie przejść od ekranu
tytułowego do epilogu bez edytora i selektora testowego:

1. produkcyjny punkt wejścia i menu główne;
2. Nowa gra i Kontynuuj oparte na rzeczywistym zapisie;
3. pełna topologia Station 01..41 → wybrany wariant 42A/B/C → Station 43;
4. bezpieczny powrót po epilogu do powłoki produktu;
5. deterministyczny test end-to-end korzystający z realnych sygnałów
   ukończenia, a nie z listy ręcznych teleportów.

To jest R0 z
`docs/IMPLEMENTATION_PLAN_AUDIT_AND_RELEASE_READINESS.md`. Nie eksportuj jeszcze
buildów i nie udawaj gotowości wydawniczej; R1–R4 pozostają kolejnymi bramkami.

## SRODOWISKO I BASELINE

- Katalog: `C:\getting_strange`.
- Godot `4.7.x`, GDScript, logiczny viewport `640x360`, integer scaling,
  fizyka 60 Hz.
- Projekt jest wyłącznie grą Godot PC na Windows/Linux (D-098). Zero web,
  Androida, Capacitor, PWA, sklepu lub innej powierzchni.
- Projekt nie ma Git. Nie uruchamiaj żadnych poleceń `git`.
- Najpierw przeczytaj w tej kolejności:
  1. `AGENTS.md`;
  2. `docs/INDEX.md`;
  3. `docs/CURRENT_STATE.md`;
  4. ten prompt;
  5. `docs/IMPLEMENTATION_PLAN_AUDIT_AND_RELEASE_READINESS.md`;
  6. `docs/narrative/NARRATIVE_BIBLE.md`;
  7. `docs/PROTOTYPE_01_MOVEMENT_LAB.md`;
  8. `docs/WORKFLOW.md`, `docs/ROADMAP.md`, `docs/RISKS_AND_HYPOTHESES.md`,
     `docs/DECISION_LOG.md`;
  9. `project.godot`, `scripts/core/game_state_manager.gd`, Station 40, 41,
     42A/B/C i 43 oraz odpowiadające testy.
- Przed pierwszą edycją uruchom i zapisz wynik:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Aktualna prawda wejściowa:

- `run/main_scene` wskazuje `scenes/prototype/movement_lab.tscn`;
- `CAMPAIGN_TRANSITION_LIMIT = 25` i `SAVE_SCHEMA_VERSION = 1`;
- Station 01..41, 42A/B/C i 43 istnieją i pełny smoke je wywołuje;
- Station 41 ma wybór A/B/C, ale centralny menedżer nie prowadzi do wariantu
  42 ani z 42 do 43;
- menu pauzy i zapis istnieją; produkcyjne menu główne i presety eksportu nie;
- H-005 = `TECHNICAL`, H-012 = `UNTESTED`.

## ZAKRES IMPLEMENTACJI

### 1. Produkcyjny shell

Dodaj małą, samodzielną scenę tytułową w Godot, zgodną z Rówień Vector-Stage.
Musi mieć co najmniej:

- `NOWA GRA` — czyści kampanię i uruchamia Station 01;
- `KONTYNUUJ` — aktywne tylko przy prawidłowym zapisie; prowadzi do ostatniego
  checkpointu albo bezpiecznie do Station 01;
- `USTAWIENIA` — rzeczywisty, minimalny ekran dla głośności Master, tempa
  tekstu i trybu pełnoekranowego; bez atrap. Remap, pełna dostępność i PL/EN
  należą do R1;
- `ZAKOŃCZ` — zamyka aplikację w buildzie, a test może wywołać bezpieczny
  odpowiednik bez zamykania harnessu;
- czytelną informację o aktualnym sterowaniu, bez wpisywania jednego klawisza
  jako uniwersalnego kontraktu akcji.

Ustaw tę scenę jako `run/main_scene`. Nie usuwaj Movement Lab ani Anchor Lab;
pozostają narzędziami deweloperskimi.

### 2. Jawna topologia kampanii

Zastąp prosty limit 25 testowalną mapą przejść lub inną małą strukturą, która
opisuje rzeczywisty produkt:

- 01 → 02 → ... → 40 → 41;
- Station 41 po potwierdzonym wyborze prowadzi do 42A, 42B albo 42C;
- każdy wariant 42 prowadzi do Station 43;
- zakończenie 43 zapisuje ukończenie kampanii i wraca do menu głównego bez
  kasowania zapisu;
- selektor testowy pozostaje odseparowany od normalnej progresji;
- nie wolno pominąć sceny, odblokować niewybranego finału ani wywołać dwóch
  przejść z jednego sygnału.

Możesz zmienić lub usunąć `CAMPAIGN_TRANSITION_LIMIT = 25`, ponieważ R0 właśnie
domyka cały ciąg, ale tylko razem z nową decyzją i bramką. Nie zmieniaj
colliderów, `AirlockZone`, logiki scen ani rozgałęzień bez wykazanego defektu.

### 3. Save i Kontynuuj

- Kontynuuj ma wynikać z prawidłowego save, nie z trybu testowego.
- Nowa gra ma jednoznacznie resetować osiągnięcia i decyzje.
- Jeśli schema 1 wystarcza, zachowaj ją i dopisz brakujące znaczenie przez
  istniejące decyzje/checkpoint. Jeśli potrzebujesz schema 2, implementuj
  kontrolowaną migrację v1 → v2 i test zachowania v1; nie odrzucaj po cichu
  aktualnych zapisów.
- Zapis ukończenia i wybranego finału ma być deterministyczny.
- Błędny JSON nadal ma prowadzić do czystej kampanii, bez crasha.

### 4. Test end-to-end

Dodaj gate PKG-0114 do `tools/verify.ps1`, który co najmniej:

- sprawdza produkcyjny `run/main_scene` i wszystkie przyciski shellu;
- wykonuje Nowa gra i Kontynuuj na kontrolowanym pliku `user://`;
- przechodzi mapę 01..40 przez normalne API ukończenia;
- ćwiczy osobno A, B i C z Station 41, właściwy wariant 42 i Station 43;
- potwierdza dokładnie jedno przejście na krok, brak pominięć oraz zapis
  ukończenia;
- zachowuje pełny `tests/smoke_test.gd` dla wszystkich scen;
- izoluje i sprząta własne dane testowe.

Gate techniczny nie może twierdzić, że przebieg jest ciekawy, zrozumiały lub
emocjonalny.

### 5. Świeże kadry

Dodaj normal-driver capture PKG-0114 i obejrzyj w 640x360:

- menu tytułowe z aktywnym i nieaktywnym Kontynuuj;
- ekran ustawień;
- przejście/menu po epilogu;
- Station 41 i co najmniej jeden kontrolny kadr każdego 42A/B/C po spięciu.

Kadr dowodzi renderu i dopasowania viewportu, nie odbioru.

## GRANICE TWARDE

- Zero web/mobile/store work. To jest Godot PC.
- Zero Git.
- Zero nowych przeszkód i colliderów w tym pakiecie. R0 spina produkt.
- Zachowaj D-099 i świadomą ciszę finałów.
- Zachowaj semantyczny InputMap; UI może pokazywać nazwę akcji albo aktualne
  mapowanie pobrane z InputMap, nigdy stały klawisz jako prawdę uniwersalną.
- Zachowaj 640x360, integer scaling i fizykę 60 Hz.
- Nie zmieniaj H-005 ani H-012 bez dowodu spełniającego ich własny kontrakt.
- Nie opisuj automatu lub renderu jako dowodu funu, emocji, czytelności przez
  nową osobę ani zrozumienia fabuły.

## KRYTERIA AKCEPTACJI

Pakiet jest przyjęty dopiero, gdy:

1. F5/uruchomienie projektu otwiera produkcyjne menu, nie Movement Lab.
2. Nowa gra prowadzi do Station 01; Kontynuuj działa tylko z prawidłowego save.
3. Automatyczna topologia obejmuje 01..41, dokładnie jeden wariant 42 oraz 43.
4. Wszystkie warianty A/B/C przechodzą osobne testy i nie odblokowują się
   wzajemnie w normalnej kampanii.
5. Station 43 zapisuje ukończenie i wraca do shellu.
6. Główny smoke nadal rzeczywiście wywołuje wszystkie sceny.
7. `tests/pkg_0114_smoke_test.gd` jest częścią `tools/verify.ps1` i przechodzi.
8. Świeże kadry menu/ustawień/finałów wykonano normalnym sterownikiem i
   obejrzano w źródłowym rozmiarze.
9. Nie zmieniono geometrii, przeszkód, fizyki ani fabuły bez wykazanego defektu.
10. `README.md`, `CURRENT_STATE.md`, `ROADMAP.md`, `RISKS_AND_HYPOTHESES.md`,
    `DECISION_LOG.md`, `SESSION_LOG.md` i ten handoff opisują ten sam runtime.
11. Końcowe `verify_docs.ps1` i pełne `verify.ps1` kończą się exit code 0.
12. Snapshot `PKG-0114` istnieje.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po implementacji:

1. uruchom izolowany gate PKG-0114;
2. wykonaj i obejrzyj świeże capture'y normalnym sterownikiem;
3. uruchom:

```powershell
pwsh -NoProfile -File .\tools\verify_docs.ps1 -ProjectRoot (Get-Location)
pwsh -NoProfile -File .\tools\verify.ps1
```

4. zaktualizuj dokumenty żywe i dopisz dokładnie jeden wpis PKG-0114 do
   `SESSION_LOG.md`;
5. zapisz samodzielny prompt następnego pakietu R1;
6. zamroź stan:

```powershell
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0114
```

Raport końcowy ma wymienić testy, ścieżki capture, ograniczenia, wpis
PKG-0114, handoff i snapshot. Nie kończ na planie: R0 ma działać w runtime.
