# PKG-0198 — ZERO REWIZJA wycinek 2: kadry, mono, cienie, dźwięk

Data: 2026-09-05. Dyspozycja właściciela: zero rewizja artystyczna, wycinek 2
z `docs/NEXT_SESSION_PROMPT.md` (po PKG-0197). Ten dokument jest diagnozą
wykonaną, nie werdyktem o urodzie ani odbiorze (D-012, ADR-003).

Pytanie wycinka: **czy każde z 19 pozostałych miejsc czyta się bryłą
i działaniem bez tekstu i bez koloru, ma cień, nazwane światło i słyszalne
źródło — przy nietykalnej logice?**

## Metoda i ograniczenia (uczciwie)

- Kod rysujący przeczytany w całości dla 02–05, 07, 09–18, 42A/B/C, 43
  (stacje + `vector_stage_environment.gd` + `vector_stage_style.gd`).
- Świeże kadry normalnym sterownikiem Windows (OpenGL, Intel Iris Xe):
  `reports/pkg_0198/visual/` — 57 PNG 640×360 (19 adresów × pełny / bez
  tekstu / mono) + `frames.tsv`. Narzędzie: `tools/capture_pkg_0198.gd`
  (wzór: `tools/capture_pkg_0197.gd`).
- Twarde wykrycie narzędziowe: `CrispDiegeticText` renderuje przez dziecko
  `CanvasLayer` (warstwa 10), które NIE dziedziczy `visible` po Node2D —
  kadr „bez tekstu" musi gasić `CrispDiegeticLayer` wprost. Pierwsza wersja
  narzędzia zostawiała etykiety w kadrze; naprawiona przed capture.
- Automat dowodzi kontraktów mierzalnych
  (`tests/pkg_0198_zero_revision_slice2_test.gd`), nigdy czytelności
  dla człowieka. Skale tekstu 85/100/115 dowodzone żywą prezentacją
  stacji 08 w bramce (wzór PKG-0196), nie samym PNG.
- Inspekcja ręczna: obejrzane pełny/bez-tekstu/mono dla 07, 05, 11, 16, 42A,
  43 (reszta: przebieg narzędzia bez błędów + asercje geometrii w bramce).
  Pełna inspekcja wszystkich 57 kadrów okiem pozostaje otwarta.

## Wykonane (7 punktów kolejki z diagnozy 0197)

### 1. Trzy kadry dla 19 adresów — DONE

Pełny (kolor + tekst) / bez tekstu (dialog wyczyszczony po prezentacji,
`CrispDiegeticLayer` i `CRTDialogueBox` ukryte) / mono (skala szarości L8
z bez-tekstu: czysta sylweta i działanie, zero koloru i zero liter).
Mono dowodzi reguły minimalnej w sensie mierzalnym: ta sama geometria
bez koloru; czy ktoś ją rozpozna, pozostaje OPEN-NO-EVIDENCE.

### 2. Martwy kod 05 — WYCIĘTY

Dwa prostokąty poza kadrem (`x672+`, `x1010+` w `_draw_station_composition`
gałąź 5) usunięte z `vector_stage_environment.gd`. Zostaje jedno
oświetlone przejście jako jedyna jasna bryła. Bramka asertuje nieobecność
obu współrzędnych.

### 3. Drabina — ZMIERZONA, nie podwójna

Sprostowanie diagnozy 0197: podwójny rysunek dotyczył stacji **02**
(kanon 9.3 mówi wprost o 02, nie 07) i jest naprawiony od PKG-0173
(bramka `_test_station_02_has_single_ladder_draw`). Wycinek 2 domyka pomiar:
02/15/16 — `ServiceLadder` jest `LadderZone`, kolizja zgodna z rysunkiem
(pion ≤2 px, oś x ≤1 px); 07 nie ma drabiny wcale (słusznie: stopień
granitu 14 px ≤ 18 px, kanon 7.4 — drabina nie jest wymagana), co bramka
dowodzi runtime (zero węzłów `ladder_zone.gd` w instancji 07).

### 4. Cienie i światło — DONE (22/22 adresy)

Każdy adres 01–18, 42A/B/C, 43 ma dokładnie jeden cień kontaktowy
`Color(VectorStageStyle.INK, 0.48)` kładziony w prawo, zgodnie z nazwaną
lampą praktyczną sceny (maszyna 01, gantry 02, poczekalnia 03, poręcz 04,
latarnia 05, kiosk 06, fasada 07, kinkiety 08, lampa do czytania 09/10,
górne światło 11/17, stanowisko 12/14/15/16, synteza 13, latarnia 18,
lampki świtu 42A, lampa finału 42B/C, świt 43). Każde światło pochodzi
z nazwanego źródła (`_draw_practical_lighting` + lampy stanowisk).
Bramka asertuje obecność cienia w źródle każdej stacji.

### 5. [MONO-Q] 07/11/16 — ROZSTRZYGNIĘTE MIERZALNIE

- 07: sylweta ulicy (niebo ≥25%, horyzont dachów, fasada) + trzy bryły
  czynności (tablica / domofon / klawiatura) + portal wejścia. W mono
  wszystkie trzy punkty i portal trzymają się krawędzią, nie kolorem.
- 11: lada-kontrolka jako linia pozioma przez środek + boksy okienkowe
  w rytmie 64 px + drzwi ochrony. Pytanie diagnozy („blokada czy mebel?")
  rozstrzyga działanie: lada ma przejście rutowane geometrią, nie kolor.
- 16: stół-analizator + lampa-stożek z góry + odbiornik echa. Blok okienny
  200–440 w ciemności to obudowa urządzenia (104,112,196×142), nie okno —
  czyta się masą i lampą-stożkiem.
- Reguła minimalna jako kontrola mierzalna (bramka §4): każdy adres ma
  ≥8 prymitywów rysunku z co najmniej 2 rodzin, linię prowadzącą oraz
  element interaktywny narysowany kształtem i pozycją (prostokąt + obrys),
  nigdy samą zmianą koloru.

### 6. Donica 08 i rack 06 — PRACA, nie dekoracja

- Rack 06: po zakupie wody (`is_water_purchased`) jeden egzemplarz ubywa
  ze stojaka — sprzedawca wydał towar. Stan czytelny bryłą (3 vs 4
  prostokąty), nie samym kolorem. `queue_redraw` już był w akcji.
- Donica 08: po rozmowie z sąsiadką (`is_neighbour_spoken_to`) paprotka
  prostuje się o 2 px (domowa czynność przy donicy); donica obrysowana
  po sprawdzeniu drzwi 12. Oba odczyty ze istniejących flag — zero nowych
  writerów. Bramka asertuje markery `is_water_purchased and nx`
  i `fern_lift`.

### 7. Tekst 85/100/115 — DONE w bramce

`GameStateManager.text_scale` 0.85/1.0/1.15 + `apply_text_scale_to_tree`,
żywa prezentacja 08 (drzwi 12 → sąsiadka → klucz) na każdej skali.
Bramka 0196 dowodziła tego samego na 08; 0198 powtarza po zmianach
cieni/dźwięku/rekwizytów.

## Dźwięk jako część obrazu (stan po wycinku 2)

- `AtmosphereRig._select_primary_soundscape` daje jedno słyszalne źródło
  na każde miejsce 02–05/07/09–18 (wiatr wiaduktu, deszcz, silnik,
  mieszkalny, korytarz, podstacja, vault, analizator, ledger, HVAC;
  bramka asertuje każdą gałąź) — to jest to jedno źródło, jawnie.
- 06: `KioskWorkHum` (AudioStreamPlayer2D przy oknie lady, szum
  świetlówki, −26 dB) + rig (silnik). 08: `StairwellWorkHum`
  (między kinkietami, −28 dB) + rig (mieszkalny). Oba grają od wejścia,
  niezależnie od gracza; zero writerów/flag/sygnałów.
- Finały: jawna decyzja o ciszy z jednym źródłem — dron rigu na finał
  (42A/42B/42C osobne, 43 świt) + dopisany komentarz w 42A/42B/42C/43;
  brak dodatkowego pozycjonowanego humu, żeby obraz nie konkurował
  z ciszą. Stingów paranormalnych przed 05 brak (kontrakt, bez zmian).

## Kolejka po wycinku 2 (nie wynik tego pakietu)

1. Pełna ręczna inspekcja wszystkich 57 kadrów okiem (obejrzane 6×3,
   reszta dowiedziona narzędziem + bramką).
2. F-0184-010: MRP pozostaje monolitem, pilot jest oddzielnym zadaniem.
3. Język miejsc z diagnozy 0197 pozostaje hipotezą roboczą (D-214),
   nie kanonem — wycinek 2 jej nie udowodnił, tylko nie obalił.
4. Fun, emocja, uroda, zrozumienie: OPEN-NO-EVIDENCE (D-012, ADR-003).
