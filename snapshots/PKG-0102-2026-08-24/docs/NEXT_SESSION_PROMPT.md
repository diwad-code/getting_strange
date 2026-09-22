# Prompt dla następnej sesji: PKG-0103 (Station 26..30 — audyt i bezpieczny plaster)

Przeczytaj ten dokument w całości przed dotknięciem pliku. Wykonuj kroki po
kolei i zapisuj każdą ukończoną zmianę natychmiast. Podejmujesz decyzje
autonomicznie jako Lead Programmer i Art Director; nie czekasz na zgodę
właściciela na decyzje techniczne ani artystyczne. Zakres jest wyłącznie
grą Godot 4.7. Nie buduj, nie przywracaj i nie opisuj strony, HTML/CSS/JS,
PWA, Androida ani innej powierzchni poza silnikiem gry.

## CEL SESJI — PKG-0103

Przenieś sprawdzony kontrakt widocznego Równia Vector-Stage na następny
zwarty plaster Station 26..30. Najpierw wykonaj audyt fabularny i techniczny,
potem wdrażaj tylko elementy, które mają uzasadnienie w świecie. Kampania
pozostaje zamknięta na limicie 25: Station 25 nadal nie odblokowuje Station 26,
a ten pakiet nie zmienia `CAMPAIGN_TRANSITION_LIMIT`, schematu zapisu ani
łańcucha ukończeń.

Pakiet może wdrożyć najwyżej dwie nowe przeszkody diegetyczne. Każda musi
przejść test trzech pytań i model korekty; jeśli scena nie potrzebuje
przeszkody, zachowaj świadomą ciszę. Zakaz D-099 jest twardy: żadnych
ruchomych platform do skakania, wiszących bloków, kolców, patrolujących
wrogów, pasków zdrowia ani geometrii, której jedynym sensem jest timing skoku.

## OBOWIĄZKOWA KOLEJNOŚĆ WEJŚCIA

1. `AGENTS.md`
2. `docs/INDEX.md`
3. `docs/CURRENT_STATE.md`
4. ten `docs/NEXT_SESSION_PROMPT.md`
5. aktywna specyfikacja wskazana w `CURRENT_STATE.md`, przede wszystkim
   `docs/narrative/NARRATIVE_BIBLE.md`
6. `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`,
   `docs/TRAVERSAL_ACT_IIC_AUDIT.md`,
   `docs/VECTOR_STAGE_ACT_IIC_AUDIT.md`,
   `VISUAL_DESIGN.md`, `docs/ROADMAP.md`, `docs/DECISION_LOG.md`
7. `docs/narrative/FULL_STORY.md` dla scen 26..30,
   `docs/narrative/DIALOGUE_SCRIPT.md` i
   `docs/narrative/CONTINUITY_TRACKER.md` dla tych scen
8. `scripts/levels/station_26.gd`..`station_30.gd`,
   `scenes/levels/station_26.tscn`..`station_30.tscn`,
   `scripts/visual/vector_stage_style.gd`,
   `scripts/interactables/anchorable_object.gd`,
   `scripts/interactables/movable_anchorable_prop.gd` oraz faktyczny
   `scripts/core/game_state_manager.gd`
9. `tests/pkg_0102_smoke_test.gd`, wcześniejsze bramki PKG-0099..0102,
   `tests/traversal_lint_test.gd`, `tools/verify.ps1` i
   `tools/snapshot.ps1`

Jeżeli dokument historyczny różni się od uruchomionego kodu, pierwszeństwo ma
runtime, źródła i pełny wynik testów. Nie uruchamiaj `git`: ten projekt nie
jest wersjonowany.

## SRODOWISKO I BASELINE

Środowisko docelowe to Godot 4.7.stable na Windows i PowerShell 7, logiczny
viewport 640×360, fizyka 60 Hz. Na samym początku uruchom:

`pwsh -NoProfile -File .\tools\verify.ps1`

Zapisz wynik baseline'u. Jeśli baseline nie przejdzie, zdiagnozuj pełny łańcuch
i napraw tylko rozjazdy w zakresie tego pakietu; nie filtruj wyjścia, nie
zmieniaj timeoutów, workerów, retry, progów ani kontraktów poprzednich bramek.

## KROK 1 — audyt Station 26..30 przed edycją

Read-only przeanalizuj pięć skryptów i scen:

- profile `VectorStageEnvironment`, kolejność `_draw_state_layer()` i istniejące
  legacy draw calls;
- realne floor/ceiling/wall collidery, `AirlockZone`, typ `Player`,
  `level_completed` i promienie interakcji;
- istniejące rekwizyty, `AnchorableObject`, `MovableAnchorableProp`,
  checkpointy i decyzje w `GameStateManager`;
- stan wejściowy scen 26..30 w `FULL_STORY.md`, dialogu i trackerze.

Nie zmieniaj jeszcze plików. Zapisz krótki audyt decyzji: dla każdej sceny
decyzja „przeszkoda” albo „świadoma cisza”, rzecz ze świata, istniejąca
mechanika i koszt korekty. Nie zmieniaj istniejących colliderów ani kampanii
tylko po to, żeby dopasować scenę do pomysłu.

## KROK 2 — audyt przeszkód

Utwórz lub zaktualizuj `docs/TRAVERSAL_ACT_III_AUDIT.md`. Dla każdej
wdrażanej przeszkody wpisz:

1. dlaczego istnieje w świecie bez słowa „gracz” w odpowiedzi;
2. czego wymaga od Leny bez testu refleksu;
3. jaki jest koszt porażki, gdzie jest checkpoint i co trwale wygasa.

Audyt ma także jawnie wymienić sceny pozostawione bez przeszkody. Łączna liczba
nowych przeszkód w tym pakiecie nie może przekroczyć dwóch.

## KROK 3 — wdrożenie Vector-Stage i mechaniki

Dla Station 26..30:

- spraw, aby `_draw_state_layer()` zaczynał się od
  `VectorStageStyle.draw_play_plane(self, geometry)`;
- usuń wyłącznie nieprzezroczyste legacy tła z rysunku stacji; kadr,
  architektura, negatywna przestrzeń i droga należą do
  `VectorStageEnvironment`;
- zachowaj małe, punktowe akcenty `VectorStageStyle` oraz istniejące
  rekwizyty, bez pełnoekranowego cyan/cinnabar glow;
- użyj wyłącznie istniejących czasowników i semantycznych akcji InputMap;
- dodaj co najwyżej dwie przeszkody wybrane w audycie. Maszyna może się
  poruszać tylko wtedy, gdy wykonuje pracę świata; nie twórz celu skoku;
- każda korekta ma zapisać decyzję, odtworzyć checkpoint i wygasić konkretny
  detal. Nie wprowadzaj śmierci ani paska zdrowia;
- nie zmieniaj floorów, sufitów, ścian, `AirlockZone`, promieni interakcji,
  `CAMPAIGN_TRANSITION_LIMIT`, `SAVE_SCHEMA_VERSION` ani łańcucha 25→26.

## KROK 4 — bramka kontraktowa

Utwórz `tests/pkg_0103_smoke_test.gd` i wepnij ją do `tools/verify.ps1`.
Test ma sprawdzać co najmniej:

- ładowanie Station 26..30, profile Vector-Stage, typ `Player`, sygnał
  `level_completed`, geometrię shell/floor i `AirlockZone`;
- niezmienione promienie interakcji i brak naruszenia wcześniejszych stacji;
- pierwszy krok `draw_play_plane()` oraz brak nieprzezroczystego legacy tła;
- dokładną listę wdrożonych przeszkód, limit najwyżej dwóch, ich trzy pytania,
  korektę, checkpoint, zapis kosztu i trwałe wygaszenie detalu;
- świadomą ciszę scen bez przeszkody;
- zachowany limit kampanii 25: normalny łańcuch kończy się na Station 25,
  a Station 26 nie zostaje odblokowana w tym pakiecie.

Nie usuwaj ani nie osłabiaj `smoke_test.gd`, `traversal_lint_test.gd` ani
bramek PKG-0095..PKG-0102. Nie filtruj wyjścia i nie obniżaj progów.

## KROK 5 — świeży capture i inspekcja

Dodaj `tools/capture_pkg_0103.gd`. Wykonaj pięć świeżych kadrów:

`reports/pkg_0103/station_26.png`..`station_30.png`

Uruchom capture normalnym sterownikiem Windows/OpenGL, bez `--headless`.
Obejrzyj każdy plik. Sprawdź, czy droga ma najwyższy kontrast, nic nie wisi
w powietrzu, akcenty są punktowe, a przeszkoda (jeżeli występuje) wygląda
jak element świata, nie jak tor zręcznościowy. Zapisz wynik i ograniczenia
inspekcji; render nie jest dowodem funu, emocji ani zrozumienia.

## KRYTERIA AKCEPTACJI

Pakiet jest zaakceptowany dopiero, gdy:

- baseline i pełny `pwsh -NoProfile -File .\tools\verify.ps1` kończą się PASS;
- izolowany `pkg_0103_smoke_test.gd` przechodzi;
- wcześniejsze bramki pozostają PASS, a traversal lint nie jest osłabiony;
- pięć capture'ów z normalnego sterownika istnieje i zostało obejrzanych;
- powstał `docs/TRAVERSAL_ACT_III_AUDIT.md` z decyzjami i trzema pytaniami;
- `CURRENT_STATE.md`, `ROADMAP.md`, `DECISION_LOG.md`, `INDEX.md` i
  `SESSION_LOG.md` opisują faktyczny wynik;
- ten plik został zastąpiony promptem następnego pakietu, a nie pozostawiony
  jako handoff PKG-0103;
- nie zmieniono limitu kampanii 25 i nie powstała żadna powierzchnia webowa.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po końcowym PASS:

1. dopisz wpis PKG-0103 do `docs/SESSION_LOG.md` (append-only);
2. dodaj decyzję D-104 do `docs/DECISION_LOG.md`;
3. zaktualizuj `CURRENT_STATE.md`, roadmapę i indeks;
4. zastąp ten plik promptem PKG-0104;
5. uruchom ponownie pełne:

`pwsh -NoProfile -File .\tools\verify.ps1`

6. zamroź pakiet:

`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0103`

7. sprawdź istnienie `snapshots/PKG-0103-2026-08-24/` i wpisz tę ścieżkę
   do `CURRENT_STATE.md` oraz `SESSION_LOG.md`.

`.godot/`, `reports/` i eksporty są wynikami dyspozycyjnymi, nie zastępują
źródeł ani dokumentacyjnego dowodu pakietu.

## Stan wejściowy

PKG-0102 zamknął widoczność drogi Station 21..25: pierwszy krok warstwy stanu
wywołuje `VectorStageStyle.draw_play_plane()`. Station 22 ma jedyną nową
przeszkodę R2 `Geometry/BiometricIdentityGate`, z korektą, checkpointem,
zapisem kosztu i wygaszeniem detalu. Station 21, 23, 24 i 25 pozostają bez
sztucznej przeszkody. Wykonano test PKG-0102, pełny verify i pięć obejrzanych
capture'ów. Snapshot bieżący to `snapshots/PKG-0102-2026-08-24/`.

Station 26..43 nie są jeszcze objęte tym pionowym plasterkiem. Limit kampanii
wynosi 25 i musi pozostać niezmieniony w PKG-0103. Nie ma zewnętrznych
playtestów; automaty i rendery potwierdzają kontrakty techniczne, nie jakość
przeżycia gry.
