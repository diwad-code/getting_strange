# Prompt dla następnej sesji: PKG-0102 (Station 21..25 — audyt i bezpieczny plaster przeszkód)

> Przeczytaj dokument w całości przed dotknięciem pliku. Wykonuj kroki po
> kolei, zapisuj każdą gotową zmianę od razu i zamknij pakiet. Nie zostawiaj
> pracy w stanie częściowym.

## 0. Zakres twardy

Getting Strange jest wyłącznie grą w Godot 4.7. Nie twórz strony, portalu,
PWA, aplikacji webowej ani artefaktu HTML/CSS/JS. Nie uruchamiaj Git — projekt
nie jest wersjonowany. Pracuj tylko na plikach lokalnych.

To jest narracyjna gra filmowa, nie platformówka. Obowiązuje
`docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`: żadnych ruchomych platform do skakania,
wiszących bloków, kolców, patroli, pasków zdrowia ani nowych czasowników ruchu.
Każda przeszkoda musi wynikać z pracy świata, być opisana jednym zdaniem bez
słowa „gracz” i kończyć się korektą z kosztem zamiast śmierci.

Rola AI pozostaje autonomiczna: Lead Programmer i Art Director (D-025, D-085,
D-096, D-099, D-102, ADR-004). Podejmuj decyzje techniczne i artystyczne po
lekturze kodu, kanonu i wyników bramek. Nie rozszerzaj zakresu poza Station
21..25 oraz konieczne testy, capture i dokumentację pakietu.

## CEL SESJI — PKG-0102

Przeprowadź bezpieczny audyt fizycznego plasterka Station 21..25 i wdroż
tylko przeszkody, które wynikają z ich scen:

1. Zachowaj widoczną warstwę Vector-Stage dostarczaną przez
   `VectorStageEnvironment`; PKG-0097 zamknął ten kontrakt dla Station 21..25.
2. Użyj centralnej mechaniki Zakotwiczenia/Uległości lub diegetycznego stanu
   maszyny tylko tam, gdzie istnieje wiarygodny konflikt drogi, progu albo
   świadectwa.
3. Z góry załóż, że nie każda scena potrzebuje przeszkody. Scena 21 jest ceną
   ulgi po Szymonie, 23 jest pokojem projektantki, 24 obserwacją Marty, a 25
   konfrontacją z Jakubem. Nie dodawaj mechaniki wyłącznie dla symetrii.
4. Kandydatem pierwszego wyboru jest istniejąca `BiometricIdentityGate` w
   Station 22 (rodzina R2 — próg administracyjny), ale decyzję potwierdź
   `FULL_STORY.md`, aktualnym kodem i colliderami. Jeśli audyt wykaże, że
   bramka jest już wystarczającym stanem sceny, rozbuduj ją minimalnie zamiast
   kopiować `IdentityGate` ze Station 10.
5. Nie zmieniaj limitu kampanii 25 i nie otwieraj Station 26.

## 1. Obowiązkowa lektura

Przeczytaj w tej kolejności:

1. `AGENTS.md`.
2. `docs/INDEX.md`, `docs/CURRENT_STATE.md` i ten prompt.
3. `docs/narrative/NARRATIVE_BIBLE.md` oraz
   `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` w całości.
4. `docs/TRAVERSAL_ACT_IIB_AUDIT.md`,
   `docs/VECTOR_STAGE_ACT_IIC_AUDIT.md`, `docs/TRAVERSAL_ACT_I_AUDIT.md`,
   `docs/TRAVERSAL_ACT_II_AUDIT.md` oraz `VISUAL_DESIGN.md` — zwłaszcza
   rozdziały o drodze, akcentach stanu i zakazie platformingu.
5. `docs/narrative/FULL_STORY.md` — sceny 21..25 — oraz odpowiednie fragmenty
   `DIALOGUE_SCRIPT.md` i `CONTINUITY_TRACKER.md`.
6. `scripts/levels/station_21.gd`..`station_25.gd`, ich sceny `.tscn`,
   `scripts/levels/station_10.gd`, `station_20.gd`,
   `scripts/interactables/anchorable_object.gd`,
   `scripts/interactables/movable_anchorable_prop.gd` i
   `scripts/state/game_state_manager.gd`.
7. `tests/pkg_0101_smoke_test.gd`, `tests/pkg_0100_smoke_test.gd`,
   `tests/pkg_0099_smoke_test.gd`, `tests/traversal_lint_test.gd`,
   `tools/capture_pkg_0101.gd`, `tools/verify.ps1` i `tools/snapshot.ps1`.

Jeżeli dokument historyczny różni się od działającego kodu, pierwszeństwo ma
runtime i aktualne pliki na dysku; rozbieżność opisz i skoryguj dokumentację w
tym samym pakiecie.

## 2. Krok po kroku

### Krok 1 — baseline i mapa decyzji

Uruchom przed zmianami:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Zapisz exit code i log. Jeśli baseline nie przechodzi, zdiagnozuj pełny
łańcuch i napraw tylko realną przyczynę w zakresie projektu. Nie obniżaj
progów, nie dodawaj retry, nie filtruj błędu i nie usuwaj wcześniejszych bramek.

Zanim napiszesz kod, utwórz krótką tabelę decyzji w nowym lub istniejącym
audytcie IIC: stacja, rodzina R albo „brak”, rzecz ze świata, istniejąca
mechanika, koszt korekty. Sprawdź, że nie powstanie więcej niż jedna
przeszkoda w scenie.

### Krok 2 — audyt istniejącego runtime Station 21..25

Dla każdej sceny potwierdź bez edycji:

- `VectorStageEnvironment`, `station_number`, z-index i pierwszy krok
  `_draw_state_layer()`;
- realne floor/shell colliders, `AirlockZone`, `Player`, `level_completed` i
  promienie interakcji rekwizytów;
- istniejące sygnały oraz faktyczne warunki odryglowania wyjścia;
- czy aktywny `_draw()` nie rysuje pełnego legacy tła nad Vector-Stage;
- czy sceny 21, 23, 24 i 25 mogą zachować rytm obserwacyjny bez przeszkody.

Nie zmieniaj colliderów, InputMap, fizyki 60 Hz, viewportu 640×360 ani
istniejących profili kompozycji tylko dlatego, że nie są identyczne między
scenami.

### Krok 3 — wdrożenie wyłącznie uzasadnionych przeszkód

Jeżeli audyt potwierdzi Station 22, użyj nazwy rzeczy świata, na przykład
`Geometry/BiometricIdentityGate` jako `AnimatableBody2D` albo istniejącego
diegetycznego obiektu bramki. Rodzina R2 ma wymagać przyjęcia reguły lokalnej
wersji (obrączka na dłoni i Marta jako kontakt), nie testu refleksu.

Dla każdej wdrożonej przeszkody dodaj nagłówki dokładnie w tym formacie:

```gdscript
## PRZESZKODA — dlaczego to tu jest: <zdanie o świecie, bez słowa "gracz">
## PRZESZKODA — czego wymaga od Leny: <czynność człowieka>
## PRZESZKODA — koszt porażki: <utrata lub zmiana w świecie>
```

Użyj `AnchorableObject`, `MovableAnchorableProp` albo stanu pracującej
maszyny. Nie wprowadzaj nowego czasownika. Porażka musi wywołać
`GameStateManager.record_decision(...)`, zresetować Lenę do checkpointu i
pozostawić wyblakły albo usunięty detal. Nie twórz śmierci, health bara ani
ekranu końca.

### Krok 4 — bramka kontraktowa

Utwórz `tests/pkg_0102_smoke_test.gd` na wzór PKG-0101 i wepnij ją do
`tools/verify.ps1`. Test ma sprawdzać:

- ładowanie Station 21..25, profile Vector-Stage i widoczny state pass;
- pierwszy krok `VectorStageStyle.draw_play_plane()` oraz brak aktywnego
  pełnego legacy tła;
- niezmienione faktyczne nazwy/kształty floorów, sufitu, ścian,
  `AirlockZone`, `Player` i promieni interakcji;
- obecność najwyżej jednej przeszkody w scenie, tylko pod ścieżką wybraną w
  audycie;
- realną zmianę stanu, opór lub uległość, zapis decyzji, checkpoint i koszt;
- nagłówki trzech pytań bez słowa „gracz” w zdaniu o świecie;
- łańcuch ukończeń do Station 25 i brak odblokowania Station 26.

Nie usuwaj ani nie osłabiaj PKG-0095..PKG-0101, `smoke_test.gd` ani
`traversal_lint_test.gd`. Nie zwiększaj limitu testów ponad lokalnie ustalony
kontrakt i nie filtruj wyjścia.

### Krok 5 — capture i inspekcja

Utwórz `tools/capture_pkg_0102.gd`, wygeneruj na normalnym sterowniku Windows,
bez `--headless`:

`reports/pkg_0102/station_21.png` .. `reports/pkg_0102/station_25.png`

Obejrzyj każdy obraz. Sprawdź widoczny Vector-Stage, drogę o najwyższym
kontraście, brak geometrii wiszącej bez konstrukcji, punktowość cyjanu/cynobru
i to, czy ewentualna przeszkoda jest rzeczą świata, a nie testem refleksu.
Capture nie jest dowodem funu, emocji ani zrozumienia.

### Krok 6 — dokumentacja, pełna weryfikacja i freeze

1. Utwórz lub zaktualizuj jednoznaczny audyt `docs/TRAVERSAL_ACT_IIC_AUDIT.md`
   i dopisz go do `docs/INDEX.md`. Dla każdej sceny zapisz decyzję „brak” albo
   rodzinę R, trzy pytania, stan sukcesu i model korekty.
2. Zaktualizuj `docs/ROADMAP.md`, `docs/CURRENT_STATE.md`,
   `docs/SESSION_LOG.md` i `docs/DECISION_LOG.md`. Utrzymaj numerację decyzji
   i pakietów. Nie przepisuj historii logu.
3. Zastąp ten plik nowym promptem następnego pakietu dopiero po zamknięciu
   PKG-0102; nie zostawiaj promptu PKG-0102 jako handoffu bieżącej sesji.
4. Uruchom pełne verify i dopiero po PASS zamroź:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0102
```

Sprawdź istnienie snapshotu i opisz jego ścieżkę w `CURRENT_STATE.md` oraz
`SESSION_LOG.md`. `.godot/`, `reports/` i eksporty są wynikami dyspozycyjnymi,
nie zastępują źródeł ani dowodu dokumentacyjnego.

## KRYTERIA AKCEPTACJI

- Tylko Godot 4.7; bez webu, Androida i Git.
- Station 21..25 zachowują istniejącą widoczną warstwę Vector-Stage.
- Nie zmieniono colliderów, promieni, InputMap, fizyki, viewportu ani limitu 25.
- Nie ma platformingu, kolców, wrogów, zdrowia ani nowych czasowników.
- Każda dodana przeszkoda ma sens świata, dokładnie trzy pytania, korektę,
  zapis kosztu, checkpoint i trwały detal; sceny bez przeszkody są zapisane
  jako świadoma decyzja.
- `pkg_0102_smoke_test.gd`, wcześniejsze bramki i lint przechodzą w pełnym
  `tools/verify.ps1`.
- Pięć capture'ów zostało wykonanych normalnym sterownikiem i obejrzanych.
- Audyt, stan, log, decyzja, następny prompt i snapshot opisują faktyczny
  stan końcowy. Testy i capture nie są dowodem jakości przeżycia gry.

## Stan wejściowy

PKG-0101 zamknął widoczność Station 16..20. Użyto R5 w Station 17, R1 w
Station 19 i 20, a Station 16 i 18 pozostawiono bez sztucznej przeszkody.
PKG-0101 ma bramkę `tests/pkg_0101_smoke_test.gd`, capture
`tools/capture_pkg_0101.gd` oraz audyt `docs/TRAVERSAL_ACT_IIB_AUDIT.md`.
Aktualny snapshot to `snapshots/PKG-0101-2026-08-24/`, a limit kampanii to 25.

## SRODOWISKO I BASELINE

Środowisko docelowe to Godot 4.7.stable na Windows i PowerShell 7. Projekt nie
ma repozytorium Git. Baseline PKG-0101 obejmuje pełny `tools/verify.ps1` PASS,
izolowany `pkg_0101_smoke_test.gd` PASS oraz obejrzane capture'y Station 16..20.
Aktualny limit kampanii wynosi 25.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po pełnym PASS wykonaj `pwsh -NoProfile -File .\tools\snapshot.ps1
-Package PKG-0102`, sprawdź powstanie snapshotu i wpisz jego ścieżkę do
`CURRENT_STATE.md` oraz `SESSION_LOG.md`.
