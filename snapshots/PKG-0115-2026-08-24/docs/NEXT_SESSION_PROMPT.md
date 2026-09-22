# PKG-0116 — R2: content lock obrazu, dialogu i dźwięku

Wykonaj ten pakiet autonomicznie, krok po kroku, bez przystanków na aprobatę.
Podejmuj decyzje techniczne i artystyczne jako Lead Programmer i Art Director.
Nie zatrzymuj się, chyba że runtime, dokumentacja i testy nie pozwalają
rozstrzygnąć prawdziwego blokera.

## CEL SESJI

Domknij techniczny content lock R2 dla wskazanego backlogu Vector-Stage,
dialogu CRT i proceduralnego audio. Pracuj na istniejącej grze Godot PC i nie
otwieraj nowego toru produkcyjnego. Pakiet ma:

1. rozróżnić trzy kadry P1 wskazane w audycie art direction: Station 41,
   wariant 42B i epilog 43, bez sugerowania przewagi któregokolwiek finału;
2. dostarczyć odrębne profile portretów obsady oraz techniczną historię/
   przewijanie dialogu, bez mechanicznej zmiany kanonicznych tekstów;
3. ustabilizować miks i priorytety proceduralnych sygnałów, z kontrolą
   clippingu i bez deklaracji jakości odbioru dźwięku przez ludzi;
4. zamrozić listę treści, scen i decyzji finałów na tyle, na ile pozwalają
   istniejące dokumenty i kontrakty runtime;
5. dodać bramki, capture'y i dokumentację, które dowodzą wyłącznie
   obserwowalnych kontraktów technicznych.

R2 nie jest zgodą na nowe przeszkody, platforming, zmianę fabuły, rozgałęzień,
topologii ani save schema. Jeśli backlog nie ma bezpiecznej implementacji w
istniejącym runtime, zapisz ograniczenie i zostaw kontrakt bez ryzykownej
przebudowy.

## SRODOWISKO I BASELINE

- Katalog: `C:\getting_strange`.
- Godot `4.7.stable.official.5b4e0cb0f`, GDScript, logiczny viewport `640x360`,
  integer scaling i fizyka `60 Hz`.
- Zakres jest wyłącznie grą Godot PC. Zero web, Androida, Capacitor, PWA,
  sklepu i innych powierzchni. Projekt nie ma Git; nie uruchamiaj `git`.
- Aktywne kanony to `VISUAL_DESIGN.md`,
  `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`,
  `docs/VECTOR_STAGE_ART_DIRECTION_AUDIT.md` oraz
  `docs/narrative/NARRATIVE_BIBLE.md`.
- Aktualny runtime po PKG-0115: shell jest wejściem projektu; trasa to
  `station_01`..`station_41` → dokładnie wybrany `station_42a`/`station_42b`/
  `station_42c` → `station_43` → tytuł.
- `CAMPAIGN_TRANSITION_LIMIT = 41`, `SAVE_SCHEMA_VERSION = 1`,
  `SETTINGS_SCHEMA_VERSION = 1`; semantyczny InputMap, fokus shellu/pauzy/
  ustawień i kontrolowany remap pięciu akcji są już częścią R1.
- `tests/pkg_0115_smoke_test.gd` jest w `tools/verify.ps1`; normal-driver
  dowody R1 są w `reports/pkg_0115/`. Automaty i obrazy nie są dowodem funu,
  emocji, ergonomii, czytelności przez nową osobę ani zrozumienia fabuły.
- Wymagana kolejność lektury: `AGENTS.md`, `docs/INDEX.md`,
  `docs/CURRENT_STATE.md`, ten prompt, `docs/WORKFLOW.md`, `docs/ROADMAP.md`,
  `docs/RISKS_AND_HYPOTHESES.md`, `docs/DECISION_LOG.md`,
  `docs/VECTOR_STAGE_ART_DIRECTION_AUDIT.md`, `VISUAL_DESIGN.md`, aktywna
  specyfikacja narracyjna, `scripts/core/game_state_manager.gd`,
  `scripts/ui/crt_dialogue_box.gd`, `scripts/ui/settings_overlay.gd`,
  `scripts/core/localization_manager.gd`, `scripts/audio/procedural_audio.gd`,
  `scripts/levels/atmosphere_rig.gd`, odpowiednie sceny Station 41/42/43,
  istniejące testy i narzędzia capture.
- Przed pierwszą edycją uruchom i zapisz:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

## ZAKRES IMPLEMENTACJI

### 1. Art direction i kadry P1

Przeczytaj cały backlog w `docs/VECTOR_STAGE_ART_DIRECTION_AUDIT.md` i
zrealizuj jego P1 przed content lockiem:

- Station 42B: rozbij największą bursztynową płaszczyznę na próg, wnętrze i
  znak relacji; zachowaj mechaniczną ciszę finału i jego istniejące decyzje;
- epilog 43: nadaj trzem dużym panelom różne funkcje materiałowe i hierarchię,
  bez wizualnego „golden ending”;
- Station 41: rozróżnij materiały trzech terminali/wnęk przy zachowaniu
  `H-011a = 0` i istniejącego podziału operacji;
- `CRTPortrait`: dodaj deterministyczne, odrębne profile co najmniej Leny,
  Marty, Jakuba, dr Wierzbickiej, Szymona i Świadectwa. Zachowaj ograniczoną
  paletę, geometrię Vector-Stage i czytelny kontrast bez obietnic odbiorczych;
- sprawdź szerokie kadry i relację postać–architektura. Korekta kadrowania ma
  być lokalna, nie może zmieniać colliderów ani zasięgów interakcji.

Nie dodawaj geometrii tylko dla wypełnienia obrazu. Każda zmiana warstwy
wizualnej ma przejść przez istniejące reguły odpowiedzialności
`VectorStageEnvironment`/warstwa stanu sceny oraz zachować świadomą ciszę.

### 2. Dialog, historia i zamrożenie tekstu

- Przeczytaj `docs/narrative/DIALOGUE_SCRIPT.md`, `FULL_STORY.md`,
  `NARRATIVE_BIBLE.md` i aktualny kod CRT. Utrzymaj źródłowe brzmienie,
  kolejność kwestii, speakerów, flagi i zakończenia; nie wykonuj globalnej
  lokalizacji ani masowej redakcji.
- Dodaj techniczną historię dialogu/scrollback, jeśli obecny CRT może ją
  przyjąć bez zmiany API scen. Historia ma być deterministyczna, ograniczona
  pamięciowo i dostępna przez semantyczne akcje; sprawdź cofnięcie, ponowne
  otwarcie i powrót do bieżącej kwestii.
- Zabezpiecz typewriter, `ui_accept`/interakcję, pauzę, skalę tekstu i oba
  locale R1 przed regresją. Teksty systemowe mogą pozostać PL/EN z PKG-0115;
  narracyjny dialog nie dostaje automatycznego tłumaczenia.
- Zapisz jawny indeks treści zamrożonej i listę elementów odłożonych, zamiast
  deklarować kompletność, której runtime nie potwierdza.

### 3. Audio i miks

- Przejrzyj proceduralne generatory, `AudioBus`/głośność, priorytety dialogu,
  atmosfery i sygnałów interakcji. Wprowadź małą, deterministyczną politykę
  miksu, która nie dopuszcza do wartości poza zakresem i dokumentuje priorytet
  CRT nad sygnałami pomocniczymi.
- Dodaj techniczny test clippingu, liczby aktywnych głosów lub innego
  obserwowalnego kontraktu dostępnego bez odsłuchu przez człowieka. Nie pisz,
  że pomiar dowiódł jakości, nastroju albo zrozumiałości dźwięku.
- Nie zmieniaj kanonicznych cue dialogowych ani audio świata bez odniesienia
  do istniejących scen i dokumentów. Nie dodawaj zależności sieciowych ani
  zewnętrznych runtime assetów.

### 4. Bramka i dowody

Dodaj `tests/pkg_0116_smoke_test.gd` do `tools/verify.ps1`. Bramka ma co
najmniej sprawdzać:

- profile Station 41/42B/43 i obecność wymaganej hierarchii bez nowych
  colliderów/przeszkód;
- odrębne profile portretów i stabilne powiązanie speaker → portrait;
- historię dialogu, powrót do bieżącej kwestii, skalę tekstu i semantyczne
  wejście bez naruszenia tekstu źródłowego;
- zakres audio/miksu, bezpieczne wartości i brak znanego clippingu z kontraktu;
- niezmienność trasy `01..41 → 42A/B/C → 43`, obu schema wersji, flag i
  świadomej ciszy finałów;
- utrzymanie `tests/pkg_0115_smoke_test.gd`, `pkg_0114` i głównego smoke.

Jeśli zmienisz UI lub kadry, dodaj normal-driver capture'y Station 41, 42B,
43, reprezentatywnego CRT z historią i zestawu portretów. Sprawdź każdy plik w
źródłowym rozmiarze 640x360. Opisz tylko render, rozmiar, obecność elementów,
overflow i kontrakt techniczny.

## GRANICE TWARDE

- Zero web/mobile/store work. To jest Godot PC.
- Zero Git.
- Zero nowych przeszkód, colliderów, wrogów, platform, kolców i pasków zdrowia.
- Nie zmieniaj trasy `01..41 → wybrany 42 → 43`, flag finałów, ekonomii ani
  fabuły poza jawną, minimalną korektą content locka.
- Zachowaj `SAVE_SCHEMA_VERSION = 1`, `SETTINGS_SCHEMA_VERSION = 1`,
  semantyczny InputMap, viewport `640x360`, integer scaling i fizykę `60 Hz`.
- Nie awansuj H-005 ani H-012 bez ich własnego dowodu.
- Nie opisuj testów technicznych jako dowodu funu, emocji, odbioru,
  zrozumienia albo ergonomii.

## KRYTERIA AKCEPTACJI

Pakiet jest przyjęty dopiero, gdy:

1. R0/R1 nadal przechodzą: shell startuje, trasa kampanii nie ma regresji,
   a `SAVE_SCHEMA_VERSION = 1` i `SETTINGS_SCHEMA_VERSION = 1` są zachowane.
2. Station 41, 42B i 43 mają odrębny, udokumentowany pass Vector-Stage bez
   nowych colliderów i bez sugestii przewagi finału.
3. Portrety wymaganej obsady są deterministycznie rozróżnione, a CRT ma
   techniczną historię bez zmiany kanonicznych kwestii.
4. Miks ma sprawdzalny kontrakt zakresu/priorytetów/clippingu, bez twierdzenia
   o jakości odbioru.
5. Nowa bramka R2 jest częścią `tools/verify.ps1`, a PKG-0115, PKG-0114 i
   główny smoke nadal przechodzą.
6. Capture'y wykonano normalnym driverem i obejrzano w 640x360, jeżeli UI lub
   kadry zostały zmienione.
7. `README.md`, `CURRENT_STATE.md`, `ROADMAP.md`, `RISKS_AND_HYPOTHESES.md`,
   `DECISION_LOG.md`, `SESSION_LOG.md` i ten prompt opisują ten sam runtime.
8. Końcowe `verify_docs.ps1` i pełne `verify.ps1` kończą się exit code 0.
9. Snapshot `PKG-0116` istnieje.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po implementacji:

1. uruchom izolowane bramki R2, PKG-0115 i PKG-0114;
2. wykonaj i obejrzyj świeże capture'y normalnym driverem;
3. uruchom:

```powershell
pwsh -NoProfile -File .\tools\verify_docs.ps1 -ProjectRoot (Get-Location)
pwsh -NoProfile -File .\tools\verify.ps1
```

4. zaktualizuj dokumenty żywe i dopisz dokładnie jeden wpis PKG-0116 do
   `SESSION_LOG.md`;
5. zapisz samodzielny prompt następnego pakietu;
6. zamroź stan:

```powershell
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0116
```

Raport końcowy ma wymienić testy, capture'y, ograniczenia, wpis PKG-0116,
handoff i snapshot. Nie kończ na planie: wszystkie bezpieczne zmiany R2 mają
działać technicznie w runtime.
