# Kontrakt progów, wejść, stopni i drabin

Status: **AKTYWNY KONTRAKT TRAWERSU — D-188 / D-189 / D-190 / D-191.
§2–§4 i §7 WDROŻONE w PKG-0174. §5–§6 WDROŻONE w PKG-0173.**
Data: 2026-09-02
Nadrzędne: `docs/rebuild/PRESENTATION_REPAIR_PLAN.md` (DEF-4, DEF-5, DEF-6, DEF-7)
Podrzędne wobec: `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` (kanon przeszkód),
`docs/WORLD_SCALE.md` (metr), `AGENTS.md` §obstacle rule (D-099)

---

## 1. Zasada nadrzędna

> **Zmiana miejsca jest czynnością, nie przekroczeniem niewidzialnej linii.**

Gracz ma zobaczyć, że Lena **weszła** — otworzyła drzwi, wsiadła do wagonu,
zeszła włazem. Dziś każdy z 20 adresów kończy się identycznie: marszem w prawo
w `Area2D` o zerowej warstwie kolizji. To jest przełączenie sceny udające
podróż.

Wzorzec ruchowy: pierwszy *Prince of Persia* — postać zatrzymuje się przed
przeszkodą, wykonuje **rozpoznawalną, zamkniętą sekwencję ruchu**, dopiero
potem zmienia stan. Zapożyczamy zasadę (zatrzymanie → intencja → wykonanie →
zmiana), nie klatki ani kadry (`INSPIRATION_BOUNDARIES.md`).

---

## 2. `ThresholdZone` — nowy węzeł wejścia

Zastępuje rolę przełącznika sceny pełnioną dziś przez `AirlockZone`.

Sugerowana lokalizacja: `scripts/environment/threshold_zone.gd`,
`class_name ThresholdZone extends Area2D`.

### 2.1 Zachowanie

| Faza | Co się dzieje |
|---|---|
| 1. Zbliżenie | Gracz wchodzi w obszar. Wejście dostaje podświetlenie diegetyczne (klamka, lampka nad drzwiami, otwarte drzwi wagonu). **Bez ikony i bez znacznika questu.** |
| 2. Zgłoszenie | Prompt `interact` — ten sam nośnik, którego używają wszystkie inne interakcje. Zero nowego czasownika (D-099). |
| 3. Ustawienie | Po naciśnięciu: sterowanie odbierane, `PrototypePlayer` przesuwa się do punktu `entry_anchor` i obraca w stronę otworu. Maksymalnie 0,35 s. |
| 4. Wykonanie | Odtwarzana jest animacja rodziny wejścia (§3). Kamera trzyma kadr — `CinematicCamera` ma już tryb tłumienia kadru przy transporcie (D-148); użyć go, nie pisać drugiego. |
| 5. Zamknięcie | Po zakończeniu animacji: przejście adresu. |

### 2.2 Właściwości eksportowane

| Pole | Typ | Rola |
|---|---|---|
| `entry_family` | enum | `DOOR`, `VEHICLE`, `HATCH` (§3) |
| `entry_anchor` | `Vector2` | punkt, w którym Lena staje przed otworem |
| `facing` | float | kierunek, w którym Lena patrzy przy wejściu |
| `aperture_rect` | `Rect2` | otwór — **jedno źródło prawdy** dla rysunku, collidera i lintu skali (§7) |
| `target_station` | StringName | dokąd prowadzi |
| `is_open` | bool | czy otwór jest fizycznie przejezdny |
| `blocked_reason` | StringName | dlaczego nie, jeśli nie (§ `PROGRESSION_FLOW_CONTRACT.md`) |

### 2.3 Czego `ThresholdZone` nie robi

- Nie przełącza sceny na `body_entered`. Nigdy.
- Nie jest niewidzialny. Otwór musi być narysowany.
- Nie znika po użyciu — próg powrotny (`ReturnZone`, D-124) działa dalej.
- Nie wprowadza nowego przycisku. Wyłącznie `interact`.

### 2.4 Migracja z `AirlockZone`

`AirlockZone` zostaje jako **strefa domknięcia**: potwierdza, że ciało jest po
właściwej stronie otworu po animacji. Traci rolę wyzwalacza. Wszystkie
`_on_airlock_body_entered()` w `scripts/levels/station_*.gd` przestają wywoływać
metodę postępu; wywołuje ją `ThresholdZone` po zakończeniu animacji.

---

## 3. Trzy rodziny wejść

Więcej rodzin nie wolno dodawać bez decyzji w `DECISION_LOG.md`.

### 3.1 `DOOR` — drzwi zawiasowe (mieszkanie, klatka, biuro, instytucja)

Sekwencja: Lena staje bokiem do otworu → ręka na klamce → drzwi obracają się w
głąb → Lena robi krok w cień otworu → sylwetka gaśnie w ciemności otworu → cięcie.

- Klatki: `enter_door_0..2` (`CAST_AND_NPC_BIBLE.md` §5.3).
- Skrzydło drzwi jest osobnym rysunkiem, obracanym `rotation` albo skracanym w
  osi x; nie jest to podnoszenie prostokąta do góry.
- **Zakaz** obecnego rozwiązania `ExitClearance.open_body()`, które podnosi
  bryłę drzwi o 140 px w górę. Drzwi nie odjeżdżają w sufit.
- Czas trwania: 0,8–1,1 s.

### 3.2 `VEHICLE` — próg pojazdu (tramwaj Linii 4)

Sekwencja: Lena staje **naprzeciw drzwi wagonu**, nie obok → drzwi rozsuwają się
→ krok w górę na stopień pojazdu (pojazd ma podłogę wyżej niż peron) → chwyt
poręczy → wejście w głąb → drzwi zasuwają się → cięcie.

- Klatki: `board_vehicle_0..1`.
- Drzwi wagonu rozsuwają się poziomo, w dwie strony. Wysokość otworu wg §7.
- Pojazd musi **stać**, gdy Lena wsiada. Dziś `station_03.gd` przesuwa
  `vehicle_x` proceduralnie w `_process()` — postój musi być jawnym stanem.
- Czas trwania: 1,2–1,6 s (dłużej niż drzwi; wsiadanie ma ciężar).

### 3.3 `HATCH` — właz / otwór techniczny (podest, szyb, właz drabinowy)

Sekwencja: Lena klęka albo pochyla się przy włazie → chwyt krawędzi → zejście /
wejście nogami → sylwetka znika w otworze → cięcie.

- Wykorzystuje `ladder_mount` / `ladder_dismount` z §6, jeśli za włazem jest
  drabina.
- Czas trwania: 1,0–1,4 s.

---

## 4. Reguła kierunku pozostaje

`CAMPAIGN_MAP.md` §2: postęp idzie „w prawo albo w górę”, powrót w lewo.
Ten kontrakt **nie zmienia kierunku** — zmienia to, że kierunek kończy się
konkretnym wejściem, a nie krawędzią ekranu.

Konsekwencja: wejście musi być narysowane **przed** prawą krawędzią kadru, z
zapasem co najmniej 24 px, żeby Lena zmieściła się w sekwencji wejścia w
widocznym kadrze. Dziś `AirlockZone` stoi na x ∈ [610, 625] przy szerokości
kadru 640 — animacja wejścia nie zmieściłaby się w obrazie.

---

## 5. Stopnie i schody — koniec potykania się

### 5.1 Co jest zepsute

`prototype_player.gd:460-481`, `try_curb_step()` teleportuje ciało o stałe
`MAX_CURB_STEP = 18.0` px niezależnie od rzeczywistej wysokości przeszkody.
Na 12-pikselowej podstopnicy Station 08 daje to 6 px swobodnego spadku,
prędkość ≈ 108 px/s przy progu lądowania 80 px/s, a więc **na każdym stopniu**:
klatka `jump_fall`, kurz, dźwięk uderzenia i squash 0,80 w osi pionowej.
Pełny łańcuch w `PRESENTATION_REPAIR_PLAN.md`, DEF-5.

### 5.2 Kontrakt docelowy

1. **Zmierz, nie zgaduj.** Przed podniesieniem ciała wykonaj sondowanie w dół
   z pozycji podniesionej i ustal **rzeczywistą** wysokość stopnia `h`.
   Podnieś dokładnie o `h`, nie o `MAX_CURB_STEP`.
2. **Interpoluj, nie teleportuj.** Ruch po stopniu trwa **0,18–0,24 s** i idzie
   po łuku (wznios + ruch do przodu), nie skokiem w jednej klatce. Wejście
   fizyczne jest w tym czasie sterowane, nie „wolno spadające”.
3. **Wyłącz reakcję lądowania na czas kroku.** Flaga `_stepping` blokuje
   `play_landing()`, `_emit_landing_dust()` i `_play_squash_stretch()`.
4. **Własny stan animacji.** `LenaVisualRig` dostaje `step_up` i `step_down`.
   `set_mechanical_state()` nie może w trakcie kroku wystawiać `jump_fall`.
5. **Dźwięk.** Krok po stopniu używa zwykłego footstepu odpowiedniego dla
   nawierzchni, nie dźwięku lądowania.
6. **Limit pozostaje.** Maksymalna wysokość wejścia bez drabiny to **18 px**
   (D-123, `TRAVERSAL_AND_OBSTACLE_DESIGN.md` §7.4). Ten kontrakt zmienia
   sposób pokonywania stopnia, nie limit.

### 5.3 Geometria schodów

`WORLD_SCALE.md` §3: stopień 9 px pionu / 14–16 px biegu (17 cm).
Station 08 ma dziś podstopnice 12 px — mieści się w limicie 18 px, ale jest
wyższe niż kanoniczne 9 px. Przy audycie skali (§7) doprowadzić do 9–12 px i
zapisać wybraną wartość, żeby wszystkie schody na trasie były takie same.

---

## 6. Drabiny

### 6.1 Jedno źródło rysunku

`LadderZone._draw()` (`scripts/environment/ladder_zone.gd:53-102`) rysuje
drabinę we własnym układzie. **Żadna stacja nie rysuje drabiny drugi raz.**

Do naprawy natychmiast: `scripts/levels/station_02.gd`,
`_draw_outdoor_detour()` — ręczne szyny `Vector2(564,164)→(564,256)` i
`Vector2(576,162)→(576,254)` oraz pętla szczebli `for y in range(174, 250, 14)`
są przesunięte o **62 px** względem funkcjonalnej strefy
`ServiceLadder` (`position = Vector2(570, 310)`, `ladder_height = 86` →
y ∈ [224, 310]). Ręczny rysunek zostaje **usunięty**, a `LadderZone` dostaje
parametry odpowiadające rzeczywistej trasie wspinaczki.

Sprawdzić tę samą klasę błędu w pozostałych stacjach z drabiną: **15, 16**
(oraz 30, 32, 37, jeśli po cutoverze zostają na trasie).

### 6.2 Zgodność grafiki ze strefą — twardy próg

| Wielkość | Dopuszczalna różnica |
|---|---|
| dolna krawędź rysunku vs dolna krawędź strefy | ≤ 2 px |
| górna krawędź rysunku vs górna krawędź strefy | ≤ 2 px |
| oś x rysunku vs `global_position.x` strefy | ≤ 1 px |
| dolna krawędź drabiny vs poziom podłogi | ≤ 2 px — drabina dotyka gruntu |
| górna krawędź drabiny vs poziom podestu | drabina wystaje 8–14 px ponad podest (jak w rzeczywistości) |

`TRAVERSAL_AND_OBSTACLE_DESIGN.md` §R7 wymaga już, żeby każdy element pionowy
był umocowany do konstrukcji: „Nic nie wisi w powietrzu”. Ten próg czyni ten
wymóg mierzalnym.

### 6.3 Perspektywa — plecy, nie profil

Postać wspinająca się po drabinie ustawionej prostopadle do kamery jest widziana
**od tyłu**. Dziś `climb_0.png` / `climb_1.png` to profil boczny.

| Stan | Pliki | Kiedy |
|---|---|---|
| `ladder_mount` | 1 klatka | przejście z chodu na drabinę: obrót do widoku tylnego, chwyt szczebla |
| `climb_back` | `climb_back_0..3` | cykl wspinaczki, napędzany `velocity.y` (jak dziś `CLIMB_RUNG_PX = 26.0`) |
| `ladder_dismount` | 1 klatka | zejście z drabiny na podest, obrót z powrotem do profilu |

Stary `climb` zostaje jako fallback, ale nie jest już używany na trasie.

### 6.4 Wejście na drabinę wymaga intencji

Dziś `LadderZone._on_body_entered()` przypina ciało do drabiny automatycznie, a
wspinaczka zaczyna się od dowolnego `vertical_input`. Po zmianie:
przypięcie następuje po `interact` przy drabinie albo po świadomym ruchu w górę
przy zatrzymanej postaci — nie przez przypadkowe otarcie się o strefę w biegu.

---

## 7. Skala otworów — audyt i limity

### 7.1 Tabela kanoniczna (z `WORLD_SCALE.md` §3, tolerancja ±10%)

| Otwór | Wysokość px | Szerokość px | Metry |
|---|---:|---:|---|
| Drzwi mieszkaniowe | 109 | 42–48 | 2,10 × 0,85 |
| Drzwi techniczne / śluza | 109–120 | 48–60 | 2,10–2,30 × 0,92–1,15 |
| Drzwi balkonowe | 109–116 | 42–52 | |
| Drzwi wagonu tramwaju | 100–110 | 52–64 | otwór dwuskrzydłowy |
| Właz techniczny | 56–70 | 56–70 | otwór do przejścia na czworaka |
| Brama / wjazd | 130–150 | 120–200 | wyłącznie tam, gdzie wjeżdża pojazd |

### 7.2 Stan zastany — do naprawy

Wszystkie wartości zmierzone 2026-09-02 z plików na dysku.

**Collidery:**

| Adres | Kształt | Jest | Ma być |
|---|---|---|---|
| station_01 | `Rectangle_door` | 20 × 180 | 48–60 × 109–120 |
| station_02 | `Rectangle_door` | 18 × 116 | 48–60 × 109–120 |
| station_03 | `Rectangle_door` | 18 × 116 | 52–64 × 100–110 (wagon) |
| station_04 | `Rectangle_exit_doors` | 20 × 172 | 52–64 × 100–110 (wagon) |
| station_07 | `Rectangle_door` | 24 × 170 | 42–48 × 109 |
| station_08 | `Rectangle_door` | 24 × 170 | 42–48 × 109 |
| station_10 | `Rectangle_apartment_door` | 52 × 108 | **zgodne — wzorzec** |
| station_12 | `Rectangle_balcony_door` | 24 × 132 | 42–52 × 109–116 |

**Rysunki `_draw()`:**

| Plik | Linia | Jest | Uwaga |
|---|---:|---|---|
| `station_02.gd` | koniec `_draw_outdoor_detour()` | `Rect2(600, 144, 20, 118)` | szerokość 0,38 m |
| `station_07.gd` | 280 | `Rect2(542, 160, 56, 146)` | wysokość 2,81 m |
| `station_08.gd` | 261 | `Rect2(160, 140, 48, 156)` | wysokość 3,00 m |
| `station_08.gd` | 287 | `Rect2(540, 120, 60, 176)` | **wysokość 3,38 m — najgorszy przypadek** |

### 7.3 Reguła jednego źródła

Po zmianie **rysunek otworu i collider otworu pochodzą z jednego pola**:
`ThresholdZone.aperture_rect`. Rozjazd między nimi przestaje być możliwy z
konstrukcji, a nie z dyscypliny.

### 7.4 Lint (część GATE-SCALE)

Nowy test w `tests/` przechodzi po wszystkich scenach trasy i zgłasza błąd, gdy:

- otwór wychodzi poza przedział z §7.1 o więcej niż 10%;
- rysunek otworu różni się od collidera o więcej niż 2 px;
- rysunek drabiny różni się od `LadderZone` o więcej niż progi z §6.2;
- podstopnica przekracza 18 px albo różni się między stopniami tej samej klatki
  schodowej;
- postać w scenie ma wysokość poza przedziałem 84–92 px (§`CAST_AND_NPC_BIBLE.md` §3).

Lint jest **automatem**, nie oceną. Dowodzi zgodności z tabelą, nie urody.

---

## 8. Czego ten dokument nie zmienia

- Nie znosi zakazu platformingu (D-099). Wejścia to czynności, nie skoki.
- Nie zmienia reguły „w prawo albo w górę”.
- Nie usuwa `ReturnZone` ani dwukierunkowości (D-124).
- Nie zwiększa limitu wejścia bez drabiny ponad 18 px (D-123).
- Nie dowodzi, że wejście „czuje się dobrze”. Dowodzi, że istnieje.
