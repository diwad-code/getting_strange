# Plan naprawy prezentacji i czytelności — PHASE-08

Status: **AKTYWNA SPECYFIKACJA NADRZĘDNA PHASE-08 — D-184**
Data otwarcia: 2026-09-02
Źródło: bezpośrednia diagnoza właściciela (sesja 2026-09-02, osiem zgłoszeń
z załączonymi kadrami runtime)
Decyzje: D-184..D-193
Powiązane kontrakty: `docs/rebuild/CAST_AND_NPC_BIBLE.md`,
`docs/rebuild/THRESHOLD_AND_ENTRY_CONTRACT.md`,
`docs/rebuild/PROGRESSION_FLOW_CONTRACT.md`,
`docs/rebuild/COLD_OPEN_SPEC.md`,
`docs/WORLD_SCALE.md`, `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`,
`docs/LENA_CHARACTER_AND_ANIMATION.md`, `docs/rebuild/ACCEPTANCE_MATRIX.md`

---

## 0. Dla modelu, który to wdraża — przeczytaj najpierw

Ten dokument jest **nadrzędny** wobec `NEXT_SESSION_PROMPT.md` w zakresie
*co* ma powstać. Prompt mówi *który pakiet* jest aktywny.

Trzy zasady twarde:

1. **Nie rozszerzaj monolitów.** `scripts/interactables/memory_resonance_point.gd`
   ma 10 205 linii, a `scripts/visual/vector_stage_environment.gd` 721 linii.
   D-168 zakazuje ich dalszego rozrostu. Nowa prezentacja postaci, progów i
   animacji powstaje w **nowych, małych węzłach**, a stare rysunki są z
   monolitu **usuwane**, nie duplikowane.
2. **Nie zaliczaj bramki tekstem.** `ACCEPTANCE_MATRIX.md` §6 mówi wprost:
   bramka jest niezaliczona, jeśli fakt istnieje wyłącznie w dialogu albo
   etykiecie. Sześć nowych bramek z rozdziału 5 podlega tej samej regule.
3. **Dowód = świeży kadr z normalnego sterownika Windows**, nie headless.
   Każdy defekt z rozdziału 3 ma zdefiniowany kadr „przed / po”.

---

## 1. Dlaczego ta faza istnieje

PHASE-01..06 zamknęły trasę 20 adresów i wydały serię werdyktów
`TECHNICAL PASS`. Właściciel uruchomił runtime 2026-09-02 i zgłosił osiem
defektów, z których **żaden nie jest wykrywany przez istniejące bramki**.

To jest dokładnie sytuacja opisana w `ACCEPTANCE_MATRIX.md` §1:
`TECHNICAL PASS` nigdy nie implikuje `PRODUCT GO`, a zielone testy nie są
kontrargumentem wobec faktów właściciela (R-039).

Konsekwencja formalna: **GATE-01 wraca ze statusu `PASS` do `CONCERNS`**.
Uzasadnienie w rozdziale 3, defekt DEF-1.

---

## 2. Kolejność wykonania i jej uzasadnienie

Właściciel poprosił o naprawę „jak najszybciej, chyba że inny moment będzie
bardziej odpowiedni”. Rekomendowana kolejność **odsuwa fixy o jeden pakiet**
i jest to świadoma decyzja (D-185).

### Powód

`GameStateManager.CAMPAIGN_ROUTE` (linie 197–207) nadal zawiera
`station_01 .. station_41`. Runtime prowadzi gracza przez **43 adresy**, nie
przez 20 z planu. Cutover trasy nigdy nie został wykonany w kodzie — istnieje
wyłącznie w dokumentach.

Sześć z ośmiu defektów naprawia się **per adres**:

| Defekt | Praca przy 43 adresach | Praca przy 20 adresach |
|---|---|---|
| DEF-3 NPC | wszystkie prop-figury w monolicie | tylko figury użyte na trasie |
| DEF-4 progi wejścia | 43 wejścia | 20 wejść |
| DEF-5 stopnie | audyt 43 geometrii | audyt 20 geometrii |
| DEF-6 drabiny | 6 stacji (02, 15, 16, 30, 32, 37) | 3 stacje (02, 15, 16) |
| DEF-7 drzwi | 43 przęsła | 20 przęseł |
| DEF-8 bramkowanie | 43 blokady | 20 blokad |

Cutover to jeden pakiet. Bez niego PHASE-08 kosztuje **ponad dwa razy więcej**,
a połowa pracy trafia do materiału, który i tak wypada z trasy.

**Jeśli właściciel zdecyduje inaczej**, kolejność wolno odwrócić bez zmiany
zakresu: PKG-0171 wykonuje wtedy BUNDLE-26, a cutover przechodzi na koniec
PHASE-08. Zakres pakietów pozostaje identyczny.

### Kolejność wewnątrz PHASE-08

Kolejność jest **zależnościowa, nie ważnościowa**. Intro (DEF-1, zgłoszenie
nr 1 właściciela) jest przedostatnim pakietem, ponieważ:

- pokazuje Martę → potrzebuje portretu i sprite'a z BUNDLE-26;
- pokazuje wejście do miejsca → potrzebuje kontraktu progu z BUNDLE-28;
- pokazuje Lenę w ruchu → potrzebuje naprawionej animacji z BUNDLE-27.

Zbudowane wcześniej intro trzeba byłoby przerobić trzy razy. Specyfikacja
intra (`COLD_OPEN_SPEC.md`) jest jednak **kompletna od teraz**, więc pakiet da
się przesunąć wcześniej jedną decyzją właściciela.

---

## 3. Katalog defektów — dowód, przyczyna, kontrakt docelowy

Każdy defekt ma ID `DEF-N`. W nawiasach numer zgłoszenia właściciela.

---

### DEF-1 (zgłoszenie 1) — gracz startuje bez wiedzy, kim jest i co robi

**Zgłoszenie:** „Gracz rozpoczyna w absolutnej niewiedzy co się dzieje, nie wie
czym Lena się zajmuje, czym są drgania itd.”

**Dowód w kodzie:**

- `project.godot:16` → `run/main_scene = "res://scenes/shell/title_screen.tscn"`.
- `scripts/ui/title_screen.gd` — `Nowa gra` wchodzi wprost do `station_01`.
  Nie ma sceny pośredniej, prologu ani sekwencji wprowadzającej.
- `scripts/levels/station_01.gd` — pierwsza linia dialogowa pojawia się dopiero
  **po** wykonaniu przez gracza `repeat_line_four_measurement()` albo
  `pack_equipment_for_marta()`. Do tego momentu jedynym nośnikiem tożsamości
  jest etykieta diegetyczna `REJESTRATOR DRGAŃ // TOR 4`.
- Słowo „drgania” nie jest nigdzie wyjaśnione. Gracz nie wie, że Lena mierzy
  wibracje konstrukcji i taboru ani po co.

**Dlaczego bramka tego nie wykryła:** GATE-01 mierzy `M1 + M5` — czy fakty
*da się osiągnąć* w 60 s i czy mają nośnik inny niż prompt UI. Zaliczono ją na
4203 ms w automatycznym trace, w którym skrypt testowy **wie, w co kliknąć**.
Człowiek nie wie. To przypadek z `ACCEPTANCE_MATRIX.md` §6: „gracz wykonuje
właściwe działanie dopiero po podpowiedzi”.

**Kontrakt docelowy:** `docs/rebuild/COLD_OPEN_SPEC.md`. Skrót: zanim gracz
wykona pierwszy czasownik, runtime pokazuje — obrazem i czynnością, nie ekranem
tekstu — kim jest Lena, co mierzy, dlaczego akurat Linia 4 i kto na nią czeka.

**Nowa bramka:** GATE-INTRO.

**Status po PKG-0176: ZAMKNIĘTY TECHNICZNIE.** Warstwa A
(`scenes/shell/cold_open.tscn`) i warstwa B (stan wstępny `station_01.gd`)
istnieją w runtime. `Nowa gra` prowadzi do warstwy A przez
`GameStateManager.start_new_game()`. Pięć faktów `PLAYER_CONTRACT.md` §3 pada
przed rozwidleniem w 25,0 s przy budżecie 90 s; kolejność pojęcia „drgania”
z §4.3 jest zachowana; zakazanych ujawnień z §5 jest zero. Dowód:
`tests/pkg_0176_smoke_test.gd` i `reports/pkg_0176/`.

---

### DEF-2 (zgłoszenie 2) — portret Marty jest przemalowanym portretem Leny

**Zgłoszenie:** „Obecny portret Marty jest nieakceptowalny, wygląda jak zepsuty
wizerunek Leny.”

**Dowód w kodzie:**

- `assets/characters/portraits/marta.png` — ta sama twarz, ta sama szyja, ta
  sama kurtka i ten sam kadr co `lena.png`.
- `tools/update_marta_portrait.py` — skrypt, który to zrobił, operując na
  **istniejącym rastrze Leny**:
  1. `is_old_hair()` przemalowuje piksele włosów na róż w naprzemienny raster
     (`(x + y) % 11 < 6`), co daje skośne pasy zamiast włosów;
  2. dokleja dwa wielokąty `PINK_SHADE` jako „kosmyki” — bez konturu, bez
     cieniowania, bez związku z kształtem głowy;
  3. rysuje septum linią o szerokości 5 px.
- Docstring skryptu przyznaje to wprost: *„it does not regenerate a face”*.

Dla porównania `jakub.png` i `lena.png` powstały z pełnej generacji
(`tools/_convert_portraits.py`) i mają spójne cieniowanie, własną anatomię i
własny kostium. Marta jest jedynym portretem-przeróbką w zestawie.

**Kontrakt docelowy:** `docs/rebuild/CAST_AND_NPC_BIBLE.md` §2. Skrót: Marta
jest **wizualnym przeciwieństwem Leny** — sukienka, długie różowe włosy,
septum, ekspresja ekstrawertyczna, otwarta poza. Portret powstaje od zera przez
`gen-ai`, nie przez nakładkę na Lenę.

`tools/update_marta_portrait.py` zostaje **wycofany** (D-187): przeniesiony do
`tools/retired/` albo usunięty i nigdy więcej nie uruchamiany.

**Nowa bramka:** GATE-CAST (część portretowa).

---

### DEF-3 (zgłoszenie 3) — NPC to kółko i trójkąt, w dodatku w złej skali

**Zgłoszenie:** „Napotkane NPCe są kółkiem jako głową i trójkątem jako tułów.
Wszystkie NPC muszą wyglądać w stylu postaci Leny.”

**Dowód w kodzie** — wszystkie postacie w świecie są rysowane proceduralnie
w `scripts/interactables/memory_resonance_point.gd`:

| Postać | Funkcja | Linie | Wysokość | Konstrukcja |
|---|---|---|---:|---|
| Jakub (operator UCP) | `_draw_jakub_service_operator()` | 7231–7266 | **~36 px** | `draw_circle` r=4.5 (głowa) + `draw_rect` 11×15 (tors) + 2 × `draw_rect` (nogi) + `draw_line` (ręka) |
| Marta (świadek) | fragment `_draw_marta_witness_station()` | 9600–9634 | **~48 px** | `draw_circle` r=4.4 (głowa) + `draw_colored_polygon` trapez 14→17 px (tors) + 2 × `draw_line` (nogi) |
| Szymon Bera | `_draw_szymon_bera()` | 5872–5918 | **~30 px** | `draw_circle` r=3.8 (głowa) + `draw_rect` 11×11 (tors) + `draw_line` (ręce) |
| Wierzbicka (za szybą) | ok. 5417–5421 | — | ~22 px | `draw_circle` r=3.8 + `draw_rect` 12×14 |

**Dwa niezależne błędy naraz:**

1. **Forma.** To są prymitywy geometryczne, nie postacie. Lena jest sprite'em
   64×104 z zapieczonym pivotem (`LenaVisualRig`, D-129). Reszta obsady jest
   rysowana kółkiem i trapezem. Nie ma jednego języka wizualnego postaci.
2. **Skala.** `docs/WORLD_SCALE.md` §3 wymaga: *„Postać tła (Marta, Jakub,
   Wierzbicka) — 84–92 px, jak Lena, ten sam metr”*. Realne wartości to
   22–48 px, czyli **2–4× za małe**. Jakub przy 36 px ma 0,69 m wzrostu.
   To jest złamanie kanonu skali, nie kwestia stylu.

**Kontrakt docelowy:** `docs/rebuild/CAST_AND_NPC_BIBLE.md` §3–§5. Skrót: nowy
`CharacterVisualRig` na kontrakcie identycznym z `LenaVisualRig` (jedno płótno,
zapieczony pivot, nearest, zero skalowania per klatka), sprite'y generowane
przez `gen-ai` z zachowaniem tożsamości, wzrost 84–92 px. Prymitywne figury
znikają z trasy 20 adresów.

**Nowa bramka:** GATE-CAST.

---

### DEF-4 (zgłoszenie 4) — „wejście” do tramwaju i budynków to marsz w prawo

**Zgłoszenie:** „Jeśli Lena ma wejść do tramwaju to wejście do niego musi być
dokładnie wejście do niego, a nie po prostu pójściem w prawo. Cały czas w prawo
— zły pomysł. Wejścia do budynków powinny wyglądać jak np. animacja pierwszego
Prince of Persia.”

**Dowód w kodzie:**

- Każdy adres kończy się identycznie: `AirlockZone` (`Area2D`,
  `collision_layer = 0`) przy prawej krawędzi.
  `scenes/levels/station_03.tscn:101` → `position = Vector2(620, 238)`, kształt
  `Rectangle_airlock` = 54×126.
- `scripts/levels/station_03.gd:161` → `_on_airlock_body_entered()` wywołuje
  `board_line_four()` **na samo wejście ciałem w obszar**. Nie ma czasownika,
  animacji ani zatrzymania.
- „Tramwaj” w Station 03 to `draw_rect(Rect2(vehicle_x, 136, 252, 132))`, cztery
  prostokąty okien i jedna pionowa linia jako drzwi
  (`draw_line(Vector2(592,184), Vector2(592,254))`). Lena nigdy nie staje przed
  tymi drzwiami — mija je i wypada za krawędź kadru.
- Ta sama konstrukcja jest w każdym adresie trasy. Sprawdzone: 01, 02, 03, 04,
  07, 08 mają `AirlockZone` na x ∈ [610, 625] i wyzwalają przejście przez
  `body_entered`.

**Skutek:** wszystkie 20 adresów kończy się tym samym gestem. Gracz nie ma
poczucia, że **wszedł** dokądkolwiek — tylko że ekran się przełączył.

**Kontrakt docelowy:** `docs/rebuild/THRESHOLD_AND_ENTRY_CONTRACT.md` §2–§4.
Skrót: `AirlockZone` przestaje przełączać scenę. Przejście wymaga **czasownika
`interact` przy widocznym wejściu**, po którym gra odtwarza sekwencję wejścia:
Lena zatrzymuje się, obraca w stronę otworu, otwiera go albo wchodzi w jego
cień, kamera trzyma kadr, i dopiero potem następuje zmiana adresu. Trzy rodziny
wejść: drzwi zawiasowe, próg pojazdu, właz/otwór techniczny.

**Nowa bramka:** GATE-THRESH. **TECHNICAL PASS — PKG-0174.**

---

### DEF-5 (zgłoszenie 5) — Lena potyka się i kuca na każdym stopniu

**Zgłoszenie:** „Lena cały czas się o coś potyka. I wtedy dziwnie kuca. Zrób
animacje po prostu wchodzenia po stopniach, schodach.”

**Dowód w kodzie — pełny łańcuch przyczynowy:**

1. `scripts/player/prototype_player.gd:460-481` — `try_curb_step()` przy
   dotknięciu ściany **teleportuje ciało w górę o stałe `MAX_CURB_STEP = 18.0`
   px**, niezależnie od rzeczywistej wysokości stopnia:

   ```gdscript
   global_position.y -= MAX_CURB_STEP
   velocity.y = 0.0
   move_and_slide()
   ```

2. `scenes/levels/station_08.tscn:28-35` — realne podstopnice klatki schodowej
   mają **12 px** (`Rectangle_stair_12`; bryły 24 i 36 px to stos, nie wyższy
   stopień).
3. Różnica 18 − 12 = **6 px swobodnego spadku po każdym stopniu**.
4. `movement_profile.gd:13,17` — `gravity = 720.0`,
   `fall_gravity_multiplier = 1.35` → 972 px/s². Prędkość po 6 px spadku:
   `sqrt(2 · 972 · 6) ≈ 108 px/s`.
5. `prototype_player.gd:282` — próg lądowania to `fall_speed_before_move > 80.0`.
   108 > 80, więc **na każdym stopniu** odpalają się:
   - `play_landing()` — dźwięk uderzenia,
   - `_emit_landing_dust()` — kurz,
   - `_play_squash_stretch(Vector2(1.20, 0.80), ...)` — **skala pionowa 0,80,
     czyli widoczny przysiad**.
6. W międzyczasie `LenaVisualRig.set_mechanical_state()` widzi
   `grounded == false` i wystawia klatkę `jump_fall`
   (`lena_visual_rig.gd:316-320`).

Czyli: teleport → mikrospadek → klatka lotu → kurz → dźwięk uderzenia →
przysiad. Dokładnie „potyka się i dziwnie kuca”, na każdym stopniu klatki
schodowej.

**Kontrakt docelowy:** `docs/rebuild/THRESHOLD_AND_ENTRY_CONTRACT.md` §5.
Skrót: nowe stany `step_up` i `step_down`. Wejście na stopień to
**interpolowany ruch ciała po łuku w czasie**, dopasowany do rzeczywistej
wysokości przeszkody, a nie skok o stałe 18 px. Tłumienie lądowania jest
wyłączone w trakcie kroku po stopniu; kurz i dźwięk uderzenia nie należą do
chodzenia po schodach.

**Nowa bramka:** GATE-ANIM (część schodowa). **TECHNICAL PASS — PKG-0173.**

---

### DEF-6 (zgłoszenie 6) — Lena wisi w powietrzu na drabinie, w złej perspektywie

**Zgłoszenie:** „Wchodzenie po drabinie wygląda absurdalnie, Lena wisi w
powietrzu. Jeśli wchodzi po drabinie powinniśmy widzieć jej plecy.”

**Dowód w kodzie — dwa niezależne defekty.**

**6a. Podwójna, przesunięta drabina w Station 02.**

- `scripts/environment/ladder_zone.gd:53-102` — `LadderZone` **sam rysuje**
  szyny, szczeble i kabłąki bezpieczeństwa w swoim układzie lokalnym.
- `scenes/levels/station_02.tscn:96-102` — węzeł `ServiceLadder` stoi na
  `position = Vector2(570, 310)`, `ladder_height = 86` → funkcjonalna drabina
  zajmuje **y ∈ [224, 310]**, x ≈ 559–581.
- `scripts/levels/station_02.gd`, `_draw_outdoor_detour()`, rysuje **drugą,
  ręczną drabinę**: szyny `draw_line(Vector2(564,164) → Vector2(564,256))` oraz
  `draw_line(Vector2(576,162) → Vector2(576,254))`, szczeble w pętli
  `for y in range(174, 250, 14)` → grafika zajmuje **y ∈ [162, 256]**.

Przesunięcie względem strefy funkcjonalnej to **62 px w górę**, przy 87 px
wzrostu Leny. Gracz widzi drabinę narysowaną nad miejscem, w którym Lena
faktycznie się wspina — stąd „wisi w powietrzu”. Dodatkowo obie drabiny mają
inny rozstaw i inny kolor szczebli, co daje szum widoczny na kadrze właściciela.

**6b. Brak perspektywy tylnej.**

- `assets/characters/lena/climb_0.png` i `climb_1.png` to **profil boczny** z
  uniesioną ręką. Postać wspinająca się po drabinie ustawionej prostopadle do
  kamery musi być widziana **od tyłu**.
- `LenaVisualRig.STATE_NAMES` (linie 37–52) zawiera jeden `&"climb"`; nie ma
  stanu tylnego ani klatek wejścia/zejścia z drabiny.

**Kontrakt docelowy:** `docs/rebuild/THRESHOLD_AND_ENTRY_CONTRACT.md` §6.
Skrót: jedno źródło rysunku drabiny (`LadderZone`), zakaz ręcznego
dorysowywania drabin w `_draw()` stacji, obowiązkowy test zgodności grafiki ze
strefą (±2 px) oraz nowy zestaw klatek `climb_back_0..3` w perspektywie tylnej
plus `ladder_mount` i `ladder_dismount`.

**Nowe bramki:** GATE-ANIM (część drabinowa) — **TECHNICAL PASS PKG-0173**;
GATE-SCALE (zgodność grafiki z colliderem) pozostaje na PKG-0174 dla otworów.

---

### DEF-7 (zgłoszenie 7) — drzwi mają cztery metry i pół metra szerokości

**Zgłoszenie:** „Nadal proporcje niektórych elementów są nieprawidłowe — drzwi
wyglądają jakby miały 4 metry.”

**Kanon:** `docs/WORLD_SCALE.md` §2–§3 — 1 m = 52 px; drzwi mieszkaniowe
**109 px wysokości × 42–48 px szerokości** (2,10 × 0,85 m); drzwi techniczne /
śluza 109–120 × 48–60 px.

**Dowód — collidery drzwi na trasie 20 adresów:**

| Adres | Kształt | Wymiar px | Przeliczenie | Werdykt |
|---|---|---|---|---|
| station_01 | `Rectangle_door` | 20 × **180** | 0,38 × **3,46 m** | FAIL — wys. +65%, szer. −55% |
| station_02 | `Rectangle_door` | 18 × 116 | **0,35** × 2,23 m | FAIL — szerokość |
| station_03 | `Rectangle_door` | 18 × 116 | **0,35** × 2,23 m | FAIL — szerokość |
| station_04 | `Rectangle_exit_doors` | 20 × **172** | 0,38 × **3,31 m** | FAIL |
| station_07 | `Rectangle_door` | 24 × **170** | 0,46 × **3,27 m** | FAIL |
| station_08 | `Rectangle_door` | 24 × **170** | 0,46 × **3,27 m** | FAIL |
| station_10 | `Rectangle_apartment_door` | 52 × 108 | 1,00 × 2,08 m | **PASS** — jedyny |
| station_12 | `Rectangle_balcony_door` | 24 × **132** | 0,46 × 2,54 m | FAIL |

**Dowód — rysunki `_draw()`:**

| Plik | Linia | Wywołanie | Wymiar |
|---|---:|---|---|
| `station_02.gd` | koniec `_draw_outdoor_detour()` | `draw_rect(Rect2(600, 144, 20, 118))` | 20 × 118 |
| `station_07.gd` | 280 | `draw_rect(Rect2(542, 160, 56, 146))` | 56 × **146** |
| `station_08.gd` | 261 | `draw_rect(Rect2(160, 140, 48, 156))` | 48 × **156** |
| `station_08.gd` | 287 | `draw_rect(Rect2(540, 120, 60, 176))` | 60 × **176** |

Siedem z ośmiu przęseł na trasie łamie kanon, którego sam projekt jest autorem.
Najgorszy przypadek — Station 08, 176 px = **3,38 m** — to dokładnie ten, który
właściciel opisał jako „4 metry”.

**Kontrakt docelowy:** `docs/rebuild/THRESHOLD_AND_ENTRY_CONTRACT.md` §7.
Skrót: tabela dopuszczalnych otworów; każdy otwór na trasie doprowadzony do
kanonu w obu warstwach (rysunek i collider) z tolerancją ±10%; automatyczny
lint geometrii jako część nowej bramki.

**Nowa bramka:** GATE-SCALE. **TECHNICAL PASS (część otworów) — PKG-0174.**

---

### DEF-8 (zgłoszenie 8) — przejście dalej jest twardo zablokowane

**Zgłoszenie:** „Przejście do następnej lokacji zawsze powinno być możliwe — po
prostu niewykonanie odczytów miejsc interaktywnych zablokuje jakąś czynność w
przyszłości i gracz będzie musiał się wrócić. Lena może mówić/myśleć np.
»Powinnam odpisać« albo »Chyba o czymś zapomniałam?«”

**Dowód w kodzie:**

- Każdy z 18 adresów liniowych ma prywatne `_unlock_exit()` wywoływane
  **wyłącznie** po wykonaniu konkretnego łańcucha interakcji. Przykład
  kanoniczny, `scripts/levels/station_03.gd`:
  - `read_departure_board()` wymaga `FACT_ROUTE_TIME` ze Station 02, inaczej
    zwraca `false` i zapisuje `route_time_required`;
  - `reply_to_marta()` wymaga `is_departure_board_read`, inaczej
    `departure_required`;
  - `_unlock_exit()` woła się dopiero z `reply_to_marta()`;
  - `board_line_four()` wprost odrzuca wejście:
    `if not is_marta_reply_sent: return false`.
- Fizyczną blokadą jest `AnimatableBody2D` (`TransitDoor` / `ChamberDoor`),
  otwierany przez `ExitClearance.open_body_tweened()` dopiero po odblokowaniu.
- Liczba wywołań `_unlock_exit()` na adres: 01–13 po trzy, 14–18 po dwa.
  **Zero adresów przepuszcza gracza bez kompletu odczytów.**

**Skutek:** gra jest łańcuchem zamków. Gracz, który nie zgadnie kolejności
interakcji, stoi przed zamkniętymi drzwiami bez informacji zwrotnej innej niż
cichy zapis `safe_trial_feedback`.

**Kontrakt docelowy:** `docs/rebuild/PROGRESSION_FLOW_CONTRACT.md`. Skrót:
przejście dalej jest **zawsze możliwe**. Pominięty odczyt zapisuje **lukę**
(`gap`), która blokuje konkretną czynność później i wymusza świadomy powrót
przez istniejącą `ReturnZone` (D-124). Lena komentuje lukę wewnętrznym głosem
przez istniejący `NarrativeGuidanceService` / `InnerThoughtSurface`.

**Precedens w runtime:** Station 43 już obsługuje ścieżkę `unseeded`
(`station_43.gd:50-51,133,139`) — pełny epilog przy braku wybranej metody. Ten
sam wzorzec skaluje się na całą trasę.

**Nowa bramka:** GATE-FLOW.

---

### DEF-9 (znalezisko sesji, nie zgłoszenie właściciela) — obsady nie ma na trasie

**To nie jest zgłoszenie właściciela.** To znalezisko z audytu DEF-3, które
zmienia jego zakres i wymaga decyzji właściciela, bo dotyka contentu, nie
tylko prezentacji.

**Dowód w kodzie:**

Prymitywne figury, które właściciel zobaczył, siedzą prawie wyłącznie w
stacjach **legacy**:

| Prop | Wartość `prop_type` | Jedyna scena, która go używa |
|---|---:|---|
| `JAKUB_SERVICE_OPERATOR` | 122 | `station_27.tscn` (legacy) |
| `MARTA_WITNESS_STATION` | 188 | `station_40.tscn` (legacy) |
| `WIERZBICKA_DESK` | 77 | **żadna** |
| `SZYMON_BERA` | 87 | **żadna** |

Właściciel je zobaczył, bo `CAMPAIGN_ROUTE` prowadzi przez 43 adresy.
Po cutoverze one po prostu wypadną.

Problem jest jednak większy, nie mniejszy. Pełna lista `prop_type` używanych
przez trasę 20 adresów:

| Adres | `prop_type` | Co to jest |
|---|---|---|
| 01–08 | brak | tylko `OpeningActionPoint` |
| 09 | 6, 0, 25 | dwie filiżanki, fotografia, wieszak |
| 10 | 4, 20, 5 | notatka, tabliczka lokatorów, czytnik karty |
| 11 | 4, 26, 3 | dokument, odbita fotografia, konsola |
| 12 | 37, 36, 8 | magnetofon szpulowy, telefon bakelitowy, grafik |
| 13 | 4, 3, 36 | dokument, konsola, telefon |
| 14–18 | 8, 55, 68, 41, 74, 53, 16 | grafik, węzeł, dossier, okno, poczta pneumatyczna |
| 42A/B/C | 197, 198, 16 | filiżanki, **próg Marty**, głośnik |
| 43 | 200, 201, 202 | tablica, credits, wygaszenie |

**Jedyna osoba fizycznie obecna na całej trasie 20 adresów to sylwetka Marty
w drzwiach w finałach 42B/42C** (`EPILOGUE_MARTA_DOORSTEP`).

Dialog potwierdza to samo. Pełny spis mówców na trasie 20 adresów
(`"speaker"` w `_present()`), zmierzony 2026-09-02:

| Mówca | Wystąpień | Gdzie | Ma sprite? | Ma portret? |
|---|---:|---|---|---|
| LENA | 31 | cała trasa | tak | tak |
| MARTA | 7 | 01, 03 (wiadomość), 42A/B/C | tylko sylwetka progowa w 42B/C | tak (**do regeneracji**, DEF-2) |
| JAKUB | 3 | wyłącznie 42A/B/C | **nie** | tak |
| SPRZEDAWCA | 3 | 06 (kiosk) | **nie** | **nie** |
| SĄSIADKA | 1 | 08 (klatka schodowa) | **nie** | **nie** |
| WIERZBICKA | 0 | **nigdzie** | **nie** | tak |
| SZYMON | 0 | **nigdzie** | **nie** | tak |

Reszta mówców to nośniki nieosobowe: `TABLICA MIEJSKA`, `EWIDENCJA UCP`,
`ZARZĄD MIEJSKI`, `ULICA SADOWA`, `ŚWIADECTWO`, `UZGODNIENIE`, `POWRÓT`,
`GETTING STRANGE`.

Dwa wnioski, które trzeba nazwać wprost:

1. **Jakub jest osobą wyłącznie w finale.** Adres 12, opisany w planie §4 jako
   „Jakub jako żywa osoba i technik”, nie zawiera ani jego sylwetki, ani jednej
   jego linii.
2. **Sprzedawca w kiosku i sąsiadka na klatce mówią, ale nie istnieją wizualnie.**
   To są jedyne dwie osoby, z którymi gracz rozmawia w pierwszych 30 minutach,
   i obie są bezcielesne. `PLAYER_CONTRACT.md` §5 opiera na nich dwa z czterech
   źródeł rozbieżności.

**Sprzeczność z planem:** `PROJECT_REBUILD_EXECUTION_PLAN.md` §4 opisuje
adres 10 jako *„Marta i dwie prawdziwe relacje”*, a adres 12 jako
*„Jakub jako żywa osoba i technik”*. Runtime dostarcza w 10 klucz, zamek i
tabliczkę (`station_10.gd`: zużycie klucza, numer 14), a w 12 sekretarkę
automatyczną i balkon (`station_12.gd`: odsłuch nagrania). **Ani jednej osoby.**
Jakub jest „żywą osobą” w postaci magnetofonu szpulowego.

**Dlaczego to jest istotne dla DEF-3:** naprawa punktu 3 właściciela („NPC mają
wyglądać jak Lena”) po cutoverze nie polega na przerysowaniu figur — polega na
**wstawieniu osób tam, gdzie plan mówi, że mają być**. To jest praca contentowa,
a nie prezentacyjna, i jej zakres jest większy niż przerysowanie czterech figur.

**DECYZJA WŁAŚCICIELA: WARIANT B** (2026-09-02, D-194). Rozważane warianty:

| Wariant | Co oznacza | Koszt |
|---|---|---|
| **A** | Trasa zostaje bezosobowa; naprawiamy tylko sylwetkę Marty w 42B/C i portrety | najniższy; ale plan §4 pozostaje nieprawdziwy, a punkt 3 właściciela zostaje bez realnej odpowiedzi |
| **B** | Marta staje fizycznie w 10, Jakub w 12, Wierzbicka w 11 — trzy osoby, po jednej scenie każda | średni; przywraca zgodność z planem §4 bez zmiany liczby interakcji (GATE-INT ≤ 3 zostaje) |
| **C** | Pełna obsada we wszystkich scenach, gdzie kanon narracyjny je przewiduje | najwyższy; ryzyko przekroczenia budżetu interakcji i rozjazdu z `CAMPAIGN_MAP.md` |

**Wybrany wariant B — wiążący dla PKG-0172.** Marta staje fizycznie w adresie 10,
Jakub w 12, Wierzbicka w 11. Osoba **zastępuje przedmiot w istniejącej
interakcji**, nie dokłada czwartej — budżet trzech istotnych interakcji na adres
(GATE-INT) pozostaje nienaruszony, a plan §4 przestaje kłamać.

Sprzedawca w kiosku (06) i sąsiadka na klatce (08) **pozostają bezcieleśni** w
wariancie B. To jest znany, zapisany dług: `PLAYER_CONTRACT.md` §5 opiera na nich
dwa z czterech źródeł rozbieżności. Do ponownego rozważenia po PKG-0177, nie w
tej fazie.

---

## 4. Mapa defektów na pakiety

| Pakiet | Bundle | Zakres | Defekty |
|---|---|---|---|
| PKG-0171 | BUNDLE-25 | Clean cutover trasy + tabela dowodowa defektów + decyzja właściciela A/B/C dla DEF-9 | precondycja, DEF-9 |
| PKG-0172 | BUNDLE-26 | Obsada: portrety + `CharacterVisualRig` + sprite'y NPC | DEF-2, DEF-3, DEF-9 |
| PKG-0173 | BUNDLE-27 | Animacja trawersu: `step_up`/`step_down`, drabina tylna | DEF-5, DEF-6 — **WYKONANE** |
| PKG-0174 | BUNDLE-28 | Progi i skala: wejścia diegetyczne + otwory do kanonu | DEF-4, DEF-7 — **WYKONANE** |
| PKG-0175 | BUNDLE-29 | Ciągła przechodniość trasy + luki + głos wewnętrzny | DEF-8 — **WYKONANE** |
| PKG-0176 | BUNDLE-30 | Cold open / prolog | DEF-1 |
| PKG-0177 | BUNDLE-31 | Integracja, sześć nowych bramek, CHECKPOINT-06 | wszystkie |

---

## 5. Sześć nowych bramek produktu

Pełne definicje trafiają do `docs/rebuild/ACCEPTANCE_MATRIX.md` §3. Tu skrót i
przypisanie do metod pomiaru z §2 macierzy.

| Bramka | Kryterium | Metoda | Próg |
|---|---|---|---|
| GATE-INTRO | po pierwszych 90 s runtime pokazane są: kto to jest, co mierzy, czym są drgania, kto czeka — z nośnika innego niż menu i ekran tekstu | M1 + M5 | 4 z 4 faktów, każdy pokazany czynnością lub obrazem |
| GATE-CAST | każda widoczna postać na trasie jest sprite'em na kontrakcie `LenaVisualRig`, wzrost 84–92 px; żadna nie jest prymitywem `draw_circle` + `draw_rect`/`polygon` | M2 + M4 | 0 prymitywnych figur; 100% postaci w przedziale wzrostu |
| GATE-THRESH | każde przejście między adresami wymaga czasownika przy widocznym wejściu i ma animację wejścia; zero przejść wyzwalanych samym wejściem w niewidzialny obszar | M1 + M2 + M4 | 20 z 20 adresów |
| GATE-SCALE | każdy otwór, stopień, drabina i mebel na trasie mieści się w tabeli `WORLD_SCALE.md` §3 z tolerancją ±10%, a rysunek zgadza się z colliderem do 2 px | M4 + M2 | 0 naruszeń |
| GATE-FLOW | z każdego adresu da się przejść dalej bez odczytów opcjonalnych; przebieg „bez ani jednego opcjonalnego odczytu” dochodzi do Station 43; każda pominięta rzecz daje zapisaną lukę i jedną linię głosu wewnętrznego | M1 + M4 | pełny przebieg minimalny kończy się; 20 z 20 adresów przechodnie |
| GATE-ANIM | żaden trawers nie produkuje niewyjaśnionego przysiadu ani klatki lotu; `step_up`, drabina i próg mają własne animacje; drabina pokazuje plecy postaci | M2 + M4 | 0 wystąpień `jump_fall`/squash przy chodzeniu po schodach; klatki tylne obecne |

**Zasada wspólna:** wszystkie sześć podlega `ACCEPTANCE_MATRIX.md` §6 (sygnały
fałszywego zaliczenia) i §7 (czego macierz nie mierzy). Żadna nie jest dowodem,
że gra jest ładna, zrozumiała czy przyjemna — dowodzą wyłącznie, że opisany
defekt fizycznie zniknął z runtime.

---

## 6. Pipeline generowania grafiki

Właściciel wskazał `gen-ai` (Picsart CLI) jako właściwy kierunek i zasugerował
modele z kontekstem. Stan narzędzia zweryfikowany 2026-09-02:

- binarka: `C:\Users\admin\AppData\Roaming\npm\gen-ai`, wersja 2.69.0
  (dostępna aktualizacja do 2.72.1 — `gen-ai update`);
- saldo: **1358 kredytów**;
- polecenia istotne dla tej fazy: `gen-ai character` (spójna postać
  referencyjna między pozami), `gen-ai edit-image`, `gen-ai multi-image`,
  `gen-ai remove-bg`, `gen-ai describe`, `gen-ai compare`, `gen-ai pricing`,
  `gen-ai validate`;
- modele obrazu dostępne i istotne: `flux-kontext-pro`, `flux-kontext-max`,
  `gemini-3-pro-image` (Nano Banana Pro — użyty do Leny 4.1, PKG-0136),
  `gemini-3.1-flash-image`, `seedream-5.0-pro`, `qwen-image-3.0`,
  `ideogram-character`, `picsart-qwen-image-edit-angle` (zmiana kąta — kandydat
  na ujęcie tylne dla drabiny), `flux-2-pro`, `flux-2-max`.

Reguły użycia — szczegóły w `CAST_AND_NPC_BIBLE.md` §6:

1. **Zanim wydasz kredyty:** `gen-ai pricing` i `gen-ai validate`, a przy
   niepewności `gen-ai compare` na jednej pozie i 2–3 modelach.
2. **Jedna poza = jedno wywołanie.** Zakaz arkuszy „model sheet” w jednej
   klatce (D-122, wniosek z PKG-0132).
3. **Tożsamość trzymana referencją obrazu** (`gen-ai character` albo model
   `*-kontext-*` z obrazem wejściowym), nie samym opisem tekstowym.
4. **Normalizacja jest offline i deterministyczna** — `remove-bg`, przycięcie
   do wspólnego płótna, wypalony pivot, usuwanie wysp. Tak samo jak przy
   Lenie 4.1 (`LENA_CHARACTER_AND_ANIMATION.md` §11.2).
5. **Import Godot:** nearest, bez filtrowania, bez mipmap.
6. **Odrzucaj bez litości.** Kryteria odrzutu w `CAST_AND_NPC_BIBLE.md` §7.
   Klatki odrzucone lądują w `raw/` z `.gdignore`, nie w katalogu produkcyjnym.

Budżet: przy ~1358 kredytach zakłada się **maksymalnie 2 podejścia na pozę**
przed eskalacją do właściciela. Jeśli model nie trzyma tożsamości po dwóch
próbach — zmień model, nie prompt po raz piąty.

---

## 7. Czego ta faza nie robi

- Nie otwiera release'u ani nie generuje `.exe` (D-168 obowiązuje).
- Nie zmienia trasy 20 adresów, rodzin lokacji ani rozstrzygnięć 42A/B/C i 43.
- Nie dodaje platformingu, skoków po platformach ani nowych czasowników
  gameplayowych (D-099, `AGENTS.md`).
- Nie dowodzi, że gra jest zrozumiała dla nowej osoby. Zewnętrznych playtestów
  nie ma i nie będzie (D-012, ADR-003). Bramki tej fazy dowodzą wyłącznie, że
  osiem konkretnych defektów fizycznie zniknęło z runtime.
