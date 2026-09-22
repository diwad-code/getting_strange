# PKG-0200 — F-0184-010 MRP renderer extraction slice2 (PropType 0..66,197..202)

Data: 2026-09-06. Dyspozycja: ścieżka A z `docs/NEXT_SESSION_PROMPT.md`
(po PKG-0199) — drugi wycinek pilota MRP. Ten dokument jest diagnozą
wykonaną, nie werdyktem o urodzie ani odbiorze (D-012, ADR-003).

Pytanie pakietu: **czy pozostałe 73 rendery legacy-monolitu
`MemoryResonancePoint` (0..66 z aktywnej trasy + 197..202 z finałów) dadzą
się wyjąć do bezstanowego helpera tym samym wzorcem co pilot 130, bez zmiany
obrazu, dźwięku, writerów i serialize IDs?**

## Metoda i ograniczenia (uczciwie)

- Zakres: wyłącznie `PropType 0..66` + `197..202` (73 typy: `PHOTOGRAPH` …
  `TRANSIT_SERVICE_GATE` + `EPILOGUE_RETURN_CUPS` …
  `EPILOGUE_FINAL_BLACKOUT`). W przeciwieństwie do pilota (2 węzły na żywej
  trasie) wycinek 2 niesie prawie całą aktywną powierzchnię MRP: 09 (6/0/25),
  10 (4/20/5), 11 (4/26/3), 12 (37/36/8), 13 (4/3/36), 14–15 (8), 16
  (55/68/41), 17 (3/74/16), 18 (53/16), 42A/B/C (197/198/16), 43
  (200/201/202). Stacje 01–08 nie mają MRP (inne rigi).
- Audyt przed ekstrakcją (`tools/extract_mrp_slice2.py --audit`): 73/73
  funkcji znalezionych, zero zależności od logiki poza pięcioma wizualnymi
  tokenami: `is_activated` (81), `_pulse_phase` (55), `is_player_in_range`
  (7), `shadow_progress` (3), `_resonance_flash` (2). Zero `self.`,
  `queue_redraw`, `emit`, `GameState`, audio, particles, clue, sygnałów,
  `_contact_progress`/`_touch_flash`, wywołań `_draw_*` między sobą.
  Rysowanie: 411 `draw_rect`, 387 `draw_line`, 245 `draw_circle`, 8
  `draw_arc`, 3 `draw_colored_polygon`, 2 `draw_polygon`, 1 `draw_polyline`.
  Kolory wyłącznie 6 stałych helpera (AMBER 133, CYAN 141, INFRA 124,
  CORRECTION 74, DARK_STEEL 34, BACKGROUND 1) — bez `COLOR_AMBER_GLOW`.
- Trzy specjalne ciała wymagają rozszerzonego podpisu (D-218): 54
  (`JAKUB_PHOTOGRAPH_FRAME`: `is_activated or shadow_progress`, cień
  `clampf(maxf(shadow_progress,…))`), 57 (`METAL_SCRATCH_BEAM`:
  `is_activated or shadow_progress > 0.1`), 63
  (`HANDWRITTEN_CORRELATION_FORMULA`:
  `is_activated or _resonance_flash > 0.0`, glow
  `0.18 + _resonance_flash * 0.25`). Oba dodatkowe tokeny to czyste floaty
  animacji wizualnej (export `shadow_progress`, var `_resonance_flash`),
  przekazywane jako `p_shadow: float` / `p_flash: float` — helper pozostaje
  stateless (`ci` + bool/floaty, zero UNUSED_PARAMETER).
- Trzy overlaye zostają w fasadzie z definicji (nie są rendererami PropType):
  `_draw_in_world_reticule` (miesza `_resonance_flash` z range jako obwiednię
  fokusu), `_draw_resolved_mark` (czysty znacznik), `_draw_contact_read`
  (czyta `_contact_progress`/`_touch_flash`/`interaction_radius` — stan
  interakcji, nie token wizualny). Nie są liczone w 203 delegacjach.
- Ekstrakcja mechaniczna skryptem (nie ręczna): ciała przeniesione verbatim
  do `scripts/interactables/mrp_legacy_renderer.gd` (dopisane 73 do 130
  pilota = 203) z rename'ami `draw_*` → `ci.draw_*`,
  `is_activated` → `p_is_activated`, `_pulse_phase` → `p_pulse`,
  `is_player_in_range` → `p_in_range`, `shadow_progress` → `p_shadow`,
  `_resonance_flash` → `p_flash`. Kolejność parametrów stała:
  `ci, p_is_activated, p_pulse, p_in_range, p_shadow, p_flash` (tylko czytany
  podzbiór). Fasada trzyma 73 jednolinijkowe wrappery z markerem
  `PKG-0200 slice2` (130 markerów pilota nietkniętych).
- Równoważność piksel-w-piksel jest konstrukcyjna (ta sama sekwencja wywołań
  rysowania dla tych samych wejść), nie mierzona hashem klatek: capture
  headless wiesza się na `frame_post_draw` (fakt z PKG-0197).
- Automat dowodzi kontraktów mierzalnych
  (`tests/pkg_0200_mrp_renderer_slice2_test.gd`), nigdy czytelności ani
  odbioru. Przy okazji wykryty fakt danych (nie wynik pakietu):
  `station_18.tscn`/`MartaTruthTable` nie ma linii `prop_type` (default 0 =
  PHOTOGRAPH) — zostawione nietknięte, poza zakresem (zmiana typu to zmiana
  wizualna wymagająca dyspozycji).

## Wykonane

1. Helper `mrp_legacy_renderer.gd`: 203 statyczne rendery (130 pilot + 73
   slice2), własne 6 stałych kolorów, zero Area2D/sygnałów/enuma/audio/
   particles/GameState/interakcji. Sekcja slice2 oznaczona nagłówkiem
   PKG-0200 z kontraktem `p_shadow`/`p_flash`.
2. Fasada nietknięta kontraktowo: 206 `_draw_*`, 221 funkcji, 5 sentineli,
   8 exportów, 2 sygnały, 3 metody publiczne, most clue-before-activation,
   `SWITCH_LIKE_PROPS`, brak grup (`pkg_0189` GREEN bez modyfikacji poza
   bramkami 0199/0160 opisanymi w D-218).
3. Dispatch 1:1: każdy z 73 typów woła helper dokładnie raz; wrappery nie
   zawierają prymitywów rysunku; helper nie zawiera resztek fasady. Razem
   203 delegacje; 3 overlaye bez delegacji z definicji.
4. Runtime: 10 samodzielnych węzłów slice2 (0/5/8/25/54/57/63/66/197/202 —
   krawędzie + aktywna trasa + oba shadow + flash) zbiera clue, emituje raz,
   honoruje one-shot (typ 5, dwukrotny press) i `state_changed`, przeżywa
   pełne 5 tokenów wizualnych + `queue_redraw`; 6 stacji aktywnych (09/10/
   16/17/42B/43) przechodzi przez prawdziwy most MRP
   (`trigger_interaction` → `resonance_triggered` → `clue_inspected`);
   soak 73 typy po jednym węźle + pełny sweep 0..202 na jednym węźle bez
   wycieków (polityka logów).
5. Twarde konflikty migracyjne (D-218, wzór D-216): po ekstrakcji pełna
   weryfikacja byłaby CZERWONA w dwóch starych bramkach mimo zielonej nowej:
   (a) `pkg_0199` pinał helper 130 / delegacje 130 — po slice2 jest 203;
   naprawa: asercje totalu na 203 przy zachowaniu pinu 130 nazw pilota
   jeden-po-jednym (kontrola równoważna/silniejsza); (b) `pkg_0160` ciął
   prozę Marty (`Long pink hair`, `steel septum`) i licznik `draw_arc(`
   wprost z fasady — oba przeniosły się do helpera z rendererami 23/45
   (slice2); naprawa: te trzy kontrole idą przez combined
   facade+helper (ten sam piksel gdziekolwiek żyje), a pin różu `d45b9a`
   już działał przez istniejącą delegację `_renderer_body()` bez zmian.
   Żaden próg nie obniżony, żaden lint nie zmieniony.
6. Rejestracja: nowa bramka `pkg_0200` dopisana do `tools/verify.ps1`
   (104. bramka); skrypt `tools/extract_mrp_slice2.py` (audit/extract)
   zostaje jako dowód mechanicznego ruchu.

## Wynik weryfikacji

- Nowa bramka `pkg_0200` headless: PASS (fasada, helper 203, dispatch 73,
  równoważność 5 tokenów, runtime 10 węzłów + 6 stacji aktywnych, soak
  73 + sweep 203).
- Sąsiedzi: `pkg_0199` PASS po aktualizacji totalu D-218 (bez zmiany pinu
  pilota); `pkg_0160` PASS po aktualizacji prozy/arców D-218 (pin różu bez
  zmian); `pkg_0189` PASS bez modyfikacji.
- `verify_docs.ps1`: DOCS PASS (52 pliki).
- Pełny `tools/verify.ps1`: exit 0, `Verification passed.`,
  `reports/pkg_0200_verify_full.log` (104 bramki: 103 z PKG-0199 + 0200).
- Logika gry: zero writerów, flag, sygnałów, routingu, enum i serialize IDs.
  Dźwięk, zapis/odczyt, pauza, kamera: nietknięte.

## Kolejka (nie wynik tego pakietu)

1. F-0184-010: rendery MRP zamknięte w całości (203/203 PropType + 3 overlaye
   w fasadzie z definicji). Pozostaje dług P3 poza rendererami: selekcja
   interakcji/audio/aktywacji w monolicie (osobne zadanie, wymaga dyspozycji
   — dotyka logiki, nie jest mechanicznym ruchem ciał funkcji).
2. `station_18 MartaTruthTable` bez `prop_type` (default PHOTOGRAPH):
   otwarty fakt danych do decyzji właściciela (naprawa = zmiana wizualna).
3. Ocularna inspekcja 57 kadrów 0198 (ścieżka B): nadal otwarta.
4. Fun, emocja, uroda, zrozumienie: OPEN-NO-EVIDENCE (D-012, ADR-003).
5. Release i `.exe`: BLOCKED (D-168). PRODUCT GO: nie jest wynikiem.
