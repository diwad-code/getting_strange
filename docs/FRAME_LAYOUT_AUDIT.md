# Audyt rozmieszczenia elementów w kadrze 640x360

Status: **PKG-0142, 2026-08-30** — wykonany na runtime i świeżych renderach,
nie na hipotezach.
§4.3 zamknięte przez PKG-0142; wcześniejsze podpunkty §4 zamknięte przez
PKG-0137. Metoda: rendery Windows/OpenGL (Intel Iris Xe) plus przemiar pozycji
w kampanii.


## 1. Budżet pionowy kadru

| Pas ekranu | Zawartość | Wysokość | Uwaga |
|---|---|---:|---|
| 0–24 | wolne | 24 px | |
| 24–80 | `InnerThoughtSurface` (głos wewnętrzny) | 56 px | panel 440 px, x 40..480 |
| 80–209 | **martwe powietrze** | 129 px | tu żyją etykiety diegetyczne |
| 209–296 | sylwetka Leny (87 px) | 87 px | stopy na y=296 |
| 238–340 | `CRTDialogueBox` | 102 px | panel 592 px, x 24..616 |
| 340–360 | margines | 20 px | |

**Wniosek 1 (najcięższy):** pasy postaci i dialogu nachodziły na siebie na
58 px. Panel dialogowy zakrywał Lenę od pasa w dół dokładnie wtedy, gdy scena
chce ją pokazać, a nad jej głową stało 129 px pustej ściany.

**Naprawa (D-133):** `CinematicCamera.dialogue_framing_offset = 36`. Kamera
schodzi o 36 px, kiedy panel prezentuje, i wraca po zamknięciu. Widoczność
sylwetki nad panelem rośnie z 29 px (33%) do 65 px (**75%**). Ciche stacje
zachowują dotychczasowy odczyt wysokiego wnętrza — offset nie jest stały.

## 2. Etykiety diegetyczne (`CrispDiegeticText`)

65 etykiet w 45 scenach. Przemiar pozycji:

- **44 etykiety w paśmie 90–190** — czyli w martwym powietrzu nad głową Leny.
  To jest poprawne i było poprawne wcześniej: etykiety zagospodarowują pas,
  którego nie używa nic innego, i nigdy nie wchodzą na aktora.
- **1 etykieta łamiąca zasadę:** `station_01 / CrispDiegeticText_Terminal`
  („REJESTRATOR DRGAŃ // TOR 4”) stała na **y=210**, czyli 1 px pod linią
  czubka głowy Leny. Wisiała nad jej głową, wchodziła w tors i nie czytała się
  jako podpis przyrządu, który nazywa.

  **Naprawa:** przeniesiona na (252, 166) — nad szafą wskaźników (x 260..360),
  w pasie etykiet, poza sylwetką. Kontrakt zamknięty asercją w
  `tests/pkg_0136_smoke_test.gd`.

**Odpowiedź na pytanie „czy umiejscowienie zegara ma sens?”:** wskaźniki
(okrągłe zegary na stacji 01) stoją poprawnie — na poziomie blatu, w zasięgu
ręki Leny, w skali z `WORLD_SCALE.md`. Nie miał sensu **podpis** nad nimi: był
zawieszony w połowie drogi między wskaźnikami a głową postaci, bez związku
z żadnym z nich. To zostało poprawione.

## 3. Konflikt głosu wewnętrznego z dialogiem

`NarrativeGuidanceService.set_dialogue_active()` istniało od dawna, ale było
wołane ręcznie **w 2 z 45 stacji** (09 i 12). W pozostałych 43 głos wewnętrzny
mógł wejść na panel dialogowy — dwa różne mówiące w jednym kadrze.

**Naprawa (D-134):** serwis czyta powierzchnię dialogową swojej stacji
bezpośrednio i wygasza myśl automatycznie. Ręczne wywołania zachowują
pierwszeństwo. To jest też warunek konieczny dla D-133: przy kadrze dialogowym
20 etykiet diegetycznych wjeżdża w pas 24–80, który wtedy musi być pusty.

## 4. Stan punktów P6

### 4.1 ZAMKNIĘTE w PKG-0137 — kadr dialogowy odsłaniał pustkę

Nieprzewidziany skutek D-133, znaleziony dopiero sterowanym playthroughem.
Offset 36 px nakładany po klampie komory zjeżdżał kamerę na y=216 na **każdej**
z 45 stacji, a scenografia kończyła się na y=360. Dolne 36 px każdego kadru
dialogowego było `default_clear_color` `#07090c`. Naprawa: malowany fartuch
sceny (`VectorStageStyle.STAGE_APRON = 40`) plus klamp offsetu do budżetu
tego, co faktycznie namalowane (`CinematicCamera.get_framing_budget()`).
Szczegóły i pomiary: `docs/PKG_0137_PLAYTHROUGH_REPORT.md` §2, decyzja D-136.

### 4.2 ZAMKNIĘTE w PKG-0137 — martwe powietrze na stacjach o płaskim profilu

Rekomendacja tego audytu brzmiała: „warstwa struktury górnej w
`VectorStageEnvironment`, nie kolejne etykiety”. Tak też zostało zrobione.
`_draw_overhead_structure()` daje stacjom 24 i 31–37 nadwieszony bieg
instalacyjny: jedna belka poza poziomem, wieszaki w nieregularnym rytmie
i jeden kanał dla masy. Twarde ograniczenie: `OVERHEAD_FLOOR = 86`, czyli
struktura nigdy nie schodzi w pas etykiet diegetycznych (od y=90). Zero
colliderów, zero zmian trawersalu.

Dodatkowo sam kadr dialogowy przycina teraz 36 px górnego pasa, więc martwe
powietrze przy otwartym panelu spada ze 129 px do 93 px. Przy zamkniętym
panelu wypełnia je struktura nadwieszona.

### 4.3 ZAMKNIĘTE w PKG-0142 — prawa krawędź stacji 01

Wcześniejszy czarny klin po prawej stronie kadru stacji 01 nie miał funkcji
diegetycznej. `VectorStageEnvironment` zastępuje go teraz kompozycją
`airlock_bulkhead`: fasetową obudową śluzy, oknem inspekcyjnym, panelem
serwisowym i szczeliną drzwi. To scenografia bez nowych węzłów i bez collidera;
istniejące `ChamberDoor`, `AirlockZone` oraz dynamiczna linia statusu pozostają
właścicielami zachowania wyjścia.

Świeży kadr dialogowy stacji 01:
`reports/pkg_0142/normal/dialogue_station_01.png` oraz
`reports/pkg_0142/reduced/dialogue_station_01.png`. Oba kadry pokazują
obudowę po prawej, podpis terminala w paśmie 90–190 i Lenę nad panelem CRT.
Pakiet zapisał również 45 kadrów świata w każdym trybie oraz 7 wymaganych
reprezentatywnych kadrów dialogowych Aktu IV i finałów w każdym trybie.

Ręczna inspekcja dotyczy wskazanych świeżych kadrów. Pozostałe PNG są dowodem
wykonania capture, nie automatycznym dowodem czytelności.

## 5. Dowody

- `reports/pkg_0137_station_{01,08,16,24,31,37,41,43}_framed.png` — kadr dialogowy
  po fartuchu i po strukturze nadwieszonej.
- `reports/pkg_0137_before_apron_station_{01,24,33}.png` — ten sam kadr przed naprawą.
- `reports/pkg_0137_capture_report.txt` — pomiar dolnych 40 wierszy kadru.
- `reports/pkg_0137_playthrough_run.txt` — przebieg 01→43 per stacja.
- `reports/pkg_0136_station_01_layout.png` — kadr dialogowy po PKG-0136.
- `reports/pkg_0136_lena_state_sheet.png` — test sylwetki 14 stanów.
- `reports/pkg_0136_lena_walk_strip.png`, `..._run_strip.png` — cykl na żywo.
- `tests/pkg_0136_smoke_test.gd` — sekcja 6 egzekwuje kadr i wygaszanie.
- `tests/pkg_0137_smoke_test.gd` — egzekwuje budżet kadru i pas etykiet na 45 scenach.
