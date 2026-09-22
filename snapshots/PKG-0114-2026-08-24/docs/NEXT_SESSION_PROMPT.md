# PKG-0115 — R1: ustawienia systemowe, pełny pad, dostępność i PL/EN

Wykonaj ten pakiet autonomicznie, krok po kroku, bez przystanków na aprobatę.
Podejmuj decyzje techniczne i artystyczne jako Lead Programmer i Art Director.
Nie zatrzymuj się, chyba że runtime, dokumentacja i testy nie pozwalają
rozstrzygnąć prawdziwego blokera.

## CEL SESJI

Rozwiń technicznie zamknięty shell R0 do systemowej bety R1, bez naruszania
działającej trasy kampanii:

1. domknij nawigację klawiaturą i padem w shellu, ustawieniach, pauzie i
   elementach interaktywnych, zachowując semantyczny InputMap;
2. dodaj kontrolowany remap akcji albo, jeśli istnieje już częściowy tor,
   dokończ go z trwałym zapisem i bez utraty domyślnych mapowań;
3. rozbuduj ustawienia o skalę/rozmiar tekstu oraz techniczne minimum
   dostępności, zachowując działające Master, tempo tekstu i fullscreen;
4. doprowadź do rzeczywistego przełączania PL/EN dla tekstów shellu i UI,
   bez globalnych zamian w dialogach, nazwach zasobów, kodzie, ICU ani
   MessageFormat; teksty wymagające osobnej decyzji zapisz jako jawny backlog;
5. dodaj bramki trwałości ustawień, remapu, fokusu i lokalizacji oraz świeże
   capture'y normalnym driverem, jeśli zmieniony UI tego wymaga.

R1 nie jest content lockiem. Nie projektuj nowych przeszkód, nie zmieniaj
colliderów, scenografii poziomów, fabuły, rozgałęzień ani ekonomii kampanii.

## SRODOWISKO I BASELINE

- Katalog: `C:\getting_strange`.
- Godot `4.7.stable.official.5b4e0cb0f`, GDScript, logiczny viewport `640x360`,
  integer scaling i fizyka `60 Hz`.
- Zakres jest wyłącznie grą Godot PC. Zero web, Androida, Capacitor, PWA,
  sklepu i innych powierzchni. Projekt nie ma Git; nie uruchamiaj `git`.
- Wymagana kolejność lektury:
  1. `AGENTS.md`;
  2. `docs/INDEX.md`;
  3. `docs/CURRENT_STATE.md`;
  4. ten prompt;
  5. `docs/IMPLEMENTATION_PLAN_AUDIT_AND_RELEASE_READINESS.md`;
  6. `docs/narrative/NARRATIVE_BIBLE.md`;
  7. `docs/PROTOTYPE_01_MOVEMENT_LAB.md`;
  8. `docs/WORKFLOW.md`, `docs/ROADMAP.md`, `docs/RISKS_AND_HYPOTHESES.md`,
     `docs/DECISION_LOG.md`;
  9. `project.godot`, `scripts/core/game_state_manager.gd`,
     `scripts/ui/title_screen.gd`, `scripts/ui/crt_dialogue_box.gd`, skrypty
     pauzy, testy pakietowe i aktualny InputMap.
- Przed pierwszą edycją uruchom i zapisz:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

### Aktualna prawda runtime po PKG-0114

- `run/main_scene` wskazuje `res://scenes/shell/title_screen.tscn`;
- shell ma `NOWA GRA`, `KONTYNUUJ`, `USTAWIENIA` i `ZAKOŃCZ`;
- `GameStateManager` prowadzi `station_01`..`station_41` do dokładnie jednego
  z `station_42a`, `station_42b`, `station_42c`, dalej do `station_43`, a po
  epilogu wraca do tytułu bez kasowania zapisu;
- `CAMPAIGN_TRANSITION_LIMIT = 41`, `SAVE_SCHEMA_VERSION = 1`;
- ustawienia Master, tempo tekstu i fullscreen są w osobnym, wersjonowanym
  pliku `user://getting_strange_settings_v1.json`;
- `tests/pkg_0114_smoke_test.gd` jest obowiązkową bramką `tools/verify.ps1`;
- normal-driver dowody R0 są w `reports/pkg_0114/`; automaty i rendery są
  dowodem kontraktów technicznych, nie funu, emocji, czytelności ani
  zrozumienia przez nową osobę;
- H-005 pozostaje `TECHNICAL`, H-012 `UNTESTED`, a D-099 nadal zakazuje
  platformingu zręcznościowego i nowych przeszkód bez osobnego audytu.

## ZAKRES IMPLEMENTACJI

### 1. System ustawień i trwałość

- Utrzymaj osobny plik ustawień i jego własną wersję; nie mieszaj go z
  `SAVE_SCHEMA_VERSION` kampanii.
- Master volume, tempo tekstu, fullscreen i nowa skala tekstu muszą działać
  przez runtime API, aktualizować istniejące kontrolki i przetrwać restart.
- Nie pozwól, aby fullscreen lub ustawienie tekstu psuło logiczny viewport
  640x360 albo ekran ustawień poza kadrem.
- Uszkodzony lub nieznany JSON ustawień ma bezpiecznie wracać do domyślnych
  wartości i nie może zatrzymać startu projektu.

### 2. Semantyczny pad, klawiatura i remap

- Oprzyj wszystkie akcje na InputMap; nie wpisuj klawiszy jako uniwersalnej
  prawdy w logice gry.
- Zapewnij nawigację fokusem, aktywację, cofnięcie i pauzę dla klawiatury oraz
  pada. Zachowaj istniejące mapowania jako domyślne i pokaż konflikt zamiast
  cicho nadpisywać akcję.
- Jeśli pełny remap wymaga ograniczenia zakresu, wybierz mały, deterministyczny
  zestaw akcji produkcyjnych i zapisz ograniczenie w dokumentacji oraz teście.
- Testuj zachowanie bez fizycznego urządzenia przez syntetyczne zdarzenia lub
  API Godot, ale nie przedstawiaj tego jako dowodu ergonomii.

### 3. Dostępność i PL/EN

- Dodaj techniczną kontrolę skali tekstu i sprawdź jej wpływ na CRT, shell,
  pauzę oraz ustawienia.
- Rozszerz `LocalizationManager` w sposób zachowujący istniejące klucze i
  fallback; nie wykonuj mechanicznej podmiany tekstów narracyjnych bez audytu.
- Shell, ustawienia, pauza, komunikaty zapisu i sterowania muszą mieć oba
  warianty językowe. Dłuższy tekst ma przechodzić kontrolę overflow w 640x360.
- Zapisz pozostałe teksty bez bezpiecznej ekstrakcji jako ograniczenie R1, nie
  udawaj kompletnej lokalizacji.

### 4. Testy i dowody

Dodaj bramkę PKG-0115 do `tools/verify.ps1`, która co najmniej:

- sprawdza domyślne i zapisane ustawienia po ponownym załadowaniu;
- sprawdza fallback uszkodzonego/nieznanego pliku ustawień;
- sprawdza remap, konflikt, przywrócenie domyślnych mapowań i fokus UI;
- sprawdza oba locale dla shellu, ustawień, pauzy i komunikatów;
- sprawdza, że ustawienia R1 nie zmieniają topologii R0 ani save schema 1;
- utrzymuje `tests/pkg_0114_smoke_test.gd` i pełny `tests/smoke_test.gd`.

Jeśli zmienisz UI, wykonaj normal-driver capture ustawień, shellu, pauzy i
reprezentatywnego CRT. Obejrzyj świeże pliki w źródłowym rozmiarze. Opisz
wyłącznie render, rozmiar, overflow i kontrakt techniczny; nie opisuj funu,
czytelności lub odbioru jako wyniku automatu.

## GRANICE TWARDE

- Zero web/mobile/store work. To jest Godot PC.
- Zero Git.
- Zero nowych przeszkód, colliderów, wrogów, platform, kolców i pasków zdrowia.
- Nie zmieniaj trasy `01..41 → wybrany 42 → 43`, flag finałów ani fabuły.
- Zachowaj `SAVE_SCHEMA_VERSION = 1`, chyba że kontrolowana migracja jest
  bezwzględnie konieczna i ma osobny test v1.
- Zachowaj semantyczny InputMap, viewport `640x360`, integer scaling i fizykę
  `60 Hz`.
- Nie awansuj H-005 ani H-012 bez ich własnego dowodu.

## KRYTERIA AKCEPTACJI

Pakiet jest przyjęty dopiero, gdy:

1. R0 nadal startuje w shellu i pełna trasa kampanii przechodzi bez regresji.
2. Master, tempo tekstu, fullscreen i skala tekstu zapisują się oraz odtwarzają
   po restarcie, a uszkodzone ustawienia wracają do defaults.
3. Klawiatura i pad mogą przejść shell, ustawienia i pauzę przez fokus oraz
   semantyczne akcje.
4. Remap zapisuje się, wykrywa konflikt i przywraca domyślne mapowania.
5. Shell, ustawienia, pauza i komunikaty zapisu mają działające PL/EN albo
   jawnie zapisany, ograniczony fallback R1.
6. Nowa bramka R1 jest częścią `tools/verify.ps1`, a PKG-0114 i główny smoke
   nadal przechodzą.
7. Capture'y UI wykonano normalnym driverem i obejrzano w 640x360, jeśli UI
   zostało zmienione.
8. `README.md`, `CURRENT_STATE.md`, `ROADMAP.md`, `RISKS_AND_HYPOTHESES.md`,
   `DECISION_LOG.md`, `SESSION_LOG.md` i ten prompt opisują ten sam runtime.
9. Końcowe `verify_docs.ps1` i pełne `verify.ps1` kończą się exit code 0.
10. Snapshot `PKG-0115` istnieje.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po implementacji:

1. uruchom izolowane bramki R1 oraz PKG-0114;
2. wykonaj i obejrzyj świeże capture'y normalnym driverem;
3. uruchom:

```powershell
pwsh -NoProfile -File .\tools\verify_docs.ps1 -ProjectRoot (Get-Location)
pwsh -NoProfile -File .\tools\verify.ps1
```

4. zaktualizuj dokumenty żywe i dopisz dokładnie jeden wpis PKG-0115 do
   `SESSION_LOG.md`;
5. zapisz samodzielny prompt następnego pakietu;
6. zamroź stan:

```powershell
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0115
```

Raport końcowy ma wymienić testy, capture'y, ograniczenia, wpis PKG-0115,
handoff i snapshot. Nie kończ na planie: zmiany R1 mają działać technicznie w
runtime.
