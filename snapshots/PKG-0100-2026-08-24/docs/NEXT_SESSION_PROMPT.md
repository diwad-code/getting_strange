# Prompt dla następnej sesji: PKG-0101 (Station 16..20 — widoczność i diegetyczne przeszkody)

> Przeczytaj ten dokument w całości przed dotknięciem pliku. Wykonuj kroki po
> kolei i zamknij pakiet; nie zostawiaj pracy w stanie częściowym.

## 0. Zakres twardy

Getting Strange jest wyłącznie grą w Godot 4.7. Nie twórz strony, portalu,
PWA, aplikacji webowej ani żadnego artefaktu HTML/CSS/JS. Nie uruchamiaj Git —
projekt nie jest wersjonowany. Pracuj na plikach lokalnych i zapisuj każdą
gotową zmianę od razu.

To jest narracyjna gra filmowa, nie platformówka. Obowiązuje
`docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`: żadnych ruchomych platform do skakania,
wiszących bloków, kolców, patroli, pasków zdrowia ani nowych czasowników ruchu.
Każda przeszkoda musi wynikać z pracy świata, być opisana jednym zdaniem bez
słowa „gracz”, i kończyć się korektą z kosztem zamiast śmierci.

Rola AI pozostaje autonomiczna: Lead Programmer i Art Director (D-025, D-085,
D-098, D-099, D-100, D-101). Podejmuj decyzje techniczne i artystyczne po
lekturze kodu, kanonu i wyników bramek. Nie rozszerzaj zakresu poza ten pakiet.

## CEL SESJI — PKG-0101

Spłać pozostały dług D-096 w Station 16..20 i przenieś sprawdzony wzorzec
PKG-0100/PKG-0099 na kolejny spójny plaster:

1. `VectorStageEnvironment` ma faktycznie dostarczać kadr, a każdy skrypt
   stacji ma rysować wyłącznie warstwę stanu i HUD.
2. Droga przejezdna ma pochodzić z realnych colliderów przez
   `VectorStageStyle.draw_play_plane()`.
3. Dodaj najwyżej po jednej, fabularnie uzasadnionej przeszkodzie R1..R7 w
   Station 16..20. Najpierw przeczytaj sceny i kod, potem wybierz rodzinę;
   nie kopiuj mechaniki bez związku ze światem i nie dodawaj przeszkody tylko
   po to, żeby zapełnić kadr.
4. Nie zmieniaj limitu kampanii 25 i nie konwertuj Station 21..43.

## 2. Obowiązkowa lektura

Przeczytaj w tej kolejności:

1. `AGENTS.md` — zakres, faza P4 i reguła przeszkód.
2. `docs/INDEX.md`, `docs/CURRENT_STATE.md` i ten prompt.
3. `docs/narrative/NARRATIVE_BIBLE.md` oraz
   `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` w całości.
4. `docs/TRAVERSAL_ACT_I_AUDIT.md`, `docs/TRAVERSAL_ACT_II_AUDIT.md`,
   `docs/VECTOR_STAGE_ACT_IIB_AUDIT.md` i `VISUAL_DESIGN.md` — rozdziały
   2, 4 i 11.
5. `docs/narrative/FULL_STORY.md` oraz sceny 16..20, a także odpowiednie
   fragmenty `DIALOGUE_SCRIPT.md` i `CONTINUITY_TRACKER.md`.
6. `scripts/levels/station_16.gd`..`station_20.gd`, ich sceny `.tscn`,
   `scripts/levels/station_14.gd`, `station_21.gd`,
   `scripts/interactables/anchorable_object.gd` i
   `scripts/interactables/movable_anchorable_prop.gd`.
7. `tests/pkg_0100_smoke_test.gd`, `tests/pkg_0099_smoke_test.gd`,
   `tests/traversal_lint_test.gd`, `tools/capture_pkg_0100.gd`,
   `tools/verify.ps1` i `tools/snapshot.ps1`.

Jeżeli dokument historyczny różni się od działającego kodu, pierwszeństwo ma
runtime i aktualny handoff; rozbieżność opisz i skoryguj dokumentację w tym
pakiecie.

## 3. Krok po kroku

### Krok 1 — baseline

Uruchom przed zmianami i zachowaj końcowy exit code oraz log:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Jeśli baseline nie przechodzi, zdiagnozuj pełny łańcuch i napraw tylko realną
przyczynę w zakresie projektu; nie obniżaj progów, nie dodawaj retry i nie
ukrywaj błędu filtrowaniem wyjścia.

### Krok 2 — widoczność Station 16..20

Dla każdej stacji:

1. Zachowaj istniejące collidery, `AirlockZone`, zasięgi interakcji, fizykę
   60 Hz, viewport 640×360 i semanticzne akcje InputMap.
2. W aktywnym `_draw()` usuń nieprzezroczyste, pełnokadrowe tło, ściany,
   płytki i szwy. Zostaw `_draw_state_layer()` oraz istniejący HUD dialogowy.
3. Pierwszą operacją rysunkową `_draw_state_layer()` ustaw
   `VectorStageStyle.draw_play_plane(self, geometry)`.
4. Kolory i akcenty czerp wyłącznie z `VectorStageStyle`; cyjan i cynober
   mają być punktowymi relacjami stanu, nie pełnowysokimi neonowymi płaszczyznami.
5. Sprawdź profil 16..20 w `scripts/visual/vector_stage_environment.gd`.
   Zredukuj akcenty zasłaniające drogę do małych, znaczących form.

### Krok 3 — przeszkody R1..R7

Najpierw zrób krótką tabelę decyzji w audycie: stacja, rodzina R, rzecz ze
świata, istniejąca mechanika użyta ponownie i koszt korekty. Następnie dodaj
nie więcej niż jedną przeszkodę na stację, tylko jeśli scena rzeczywiście jej
potrzebuje. Kandydatami są m.in. cykl pneumatycznej kapsuły w Station 17,
dwie równoważne wersje modeli w Station 19 albo zakotwiczenie rekwizytu w
mieszkaniu/klinice — lecz ostateczny wybór musi wynikać z `FULL_STORY.md` i
aktualnego kodu.

Dla każdej wdrożonej przeszkody:

1. Nazwij węzeł rzeczą ze świata; nie używaj nazw zakazanych przez lint ani
   fragmentu `platform`.
2. Dodaj nagłówek dokładnie w tym formacie:

```gdscript
## PRZESZKODA — dlaczego to tu jest: <zdanie o świecie, bez słowa "gracz">
## PRZESZKODA — czego wymaga od Leny: <czynność człowieka>
## PRZESZKODA — koszt porażki: <utrata lub zmiana w świecie>
```

3. Użyj istniejącego `AnchorableObject`, `MovableAnchorableProp` albo
   diegetycznego stanu maszyny, zamiast tworzyć nowy czasownik ruchu.
4. Dwie wersje kotwicy muszą być wiarygodne i stałe albo mieć uzasadniony
   ruch roboczy; żadna bryła nie może być celem skoku na czas.
5. Porażka ma wywołać `GameStateManager.record_decision(...)`, reset do
   checkpointu i trwałe wyblaknięcie jednego detalu sceny. Stan sukcesu i
   korekty muszą być testowalne bez zewnętrznego playtestu.

### Krok 4 — bramka kontraktowa

Utwórz `tests/pkg_0101_smoke_test.gd` na wzór PKG-0100. Test ma sprawdzać:

- ładowanie Station 16..20, profile `station_number` i obecność warstwy stanu;
- pierwszy krok `draw_play_plane()` oraz brak aktywnego, pełnego legacy tła;
- faktyczne nazwy i kształty floorów, sufitów i ścian bez ich zmiany;
- niezmienione `AirlockZone`, rekwizyty i promienie interakcji;
- realną zmianę stanu każdej wdrożonej przeszkody i działanie korekty;
- nagłówki trzech pytań oraz brak słowa „gracz” w zdaniu o świecie;
- łańcuch ukończeń do 25 i brak próby odblokowania Station 26.

Wepnij test do `tools/verify.ps1`. Nie usuwaj i nie osłabiaj bramek
PKG-0095..PKG-0100 ani `traversal_lint_test.gd`.

### Krok 5 — capture i inspekcja

Utwórz `tools/capture_pkg_0101.gd`, wygeneruj
`reports/pkg_0101/station_16.png`..`station_20.png` na normalnym sterowniku
Windows, bez `--headless`, i obejrzyj każdy obraz. Sprawdź wzrokowo:

- widoczną warstwę Vector-Stage;
- drogę przejezdną o najwyższym kontraście;
- brak geometrii wiszącej bez konstrukcji;
- punktowość akcentów cyjan/cynober;
- czy przeszkoda jest czytelna jako element świata, nie jako test refleksu.

Jeśli obraz łamie `VISUAL_DESIGN.md`, popraw kod i wyrenderuj ponownie przed
przejściem dalej. Nie opisuj tego jako dowodu fun, emocji ani zrozumienia;
capture jest dowodem wizualnego kontraktu technicznego.

### Krok 6 — dokumentacja, pełna weryfikacja i freeze

1. Utwórz audyt `docs/TRAVERSAL_ACT_IIB_AUDIT.md` albo inny jednoznacznie
   nazwany audyt zaakceptowany przez istniejącą strukturę `docs/`; dopisz go
   do `docs/INDEX.md`. Dla każdej przeszkody zapisz rodzinę R, trzy pytania,
   stan sukcesu i model korekty.
2. Zaktualizuj `docs/ROADMAP.md`, `docs/CURRENT_STATE.md`,
   `docs/SESSION_LOG.md` i `docs/DECISION_LOG.md`. Zamknij D-096 dla 16..20
   tylko jeśli capture i test faktycznie to potwierdzają.
3. Napisz nowy `docs/NEXT_SESSION_PROMPT.md` dla następnego pakietu; nie
   zostawiaj promptu PKG-0101 jako bieżącego handoffu.
4. Uruchom pełny verify i dopiero po PASS zamroź:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0101
```

Zweryfikuj istnienie snapshotu i opisz jego ścieżkę w `CURRENT_STATE.md` oraz
`SESSION_LOG.md`. Pliki `.godot/`, `reports/` i eksporty są wynikami
dyspozycyjnymi, nie wpisuj ich jako źródła stanu projektu.

## KRYTERIA AKCEPTACJI

- Tylko Godot 4.7; bez webu, Androida i Git.
- Bez zmian istniejących colliderów, promieni interakcji, InputMap, fizyki,
  viewportu i limitu kampanii 25.
- Bez platformingu, kolców, wrogów, zdrowia i nowych czasowników ruchu.
- Bez osłabiania testów, progów lub filtracji logów.
- `pkg_0101_smoke_test.gd`, wcześniejsze bramki i lint przechodzą w pełnym
  `tools/verify.ps1`.
- Station 16..20 mają faktycznie widoczny Vector-Stage, potwierdzony pięcioma
  obejrzanymi capture'ami.
- Każda nowa przeszkoda ma trzy pytania, diegetyczny model porażki i dowód
  korekty; testy nie są dowodem przyjemności ani comprehension.
- Dokumentacja i snapshot opisują dokładnie stan końcowy.

## SRODOWISKO I BASELINE

Środowisko docelowe to Godot 4.7.stable na Windows i PowerShell 7. Projekt
nie ma repozytorium Git. Baseline PKG-0100 to pełny `tools/verify.ps1` PASS,
izolowany `pkg_0100_smoke_test.gd` PASS oraz obejrzane capture'y Station 01..10.
Aktualny limit kampanii wynosi 25.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po pełnym PASS wykonaj `pwsh -NoProfile -File .\tools\snapshot.ps1
-Package PKG-0101`, sprawdź powstanie snapshotu i wpisz jego ścieżkę do
`CURRENT_STATE.md` oraz `SESSION_LOG.md`.

## 5. Punkt wyjścia PKG-0101

PKG-0100 zamknął widoczność i przeszkody w Station 01..10, zachował limit
kampanii 25, zredukował rysunek `AnchorableObject` i zostawił działający wzór
`VectorStageStyle.draw_play_plane()`. W kampanii istnieją już użycia
Zakotwiczenia w Station 09, 12 i 14 oraz przeszkody w 06..10. Pozostał dług
widoczności Station 16..20 i decyzja, które z tych pięciu scen naprawdę
potrzebują fizycznej próby. Następny pakiet ma spłacić ten dług bez
mechanicznego kopiowania i bez rozszerzania zakresu.
