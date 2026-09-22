# PKG-0206 — Inwentaryzacja interakcji/audio MRP poza rendererami (dług F-0184-010, zero logiki)

Data: 2026-09-06. Dyspozycja: `docs/NEXT_SESSION_PROMPT.md` (po PKG-0205)
z decyzją podjętą w imieniu właściciela — prompt sesji przekazuje
podejmowanie decyzji („kieruj się dobrem projektu", ACT). Ścieżka A
(ekstrakcja interakcji/audio MRP) dotyka logiki i wymaga jawnej dyspozycji
technicznej; ten pakiet jej NIE wykonuje — delegacja decyzji o zakresie
nie jest dyspozycją dotykania logiki (reguła z PKG-0205, podtrzymana).
Ścieżka B (`station_18 prop_type`) jest ZAMKNIĘTA decyzją D-220. Ścieżka C
(ogląd 85/115) jest DOMKNIĘTA (0202 + 0203). Ten dokument jest diagnozą
wykonaną, nie werdyktem o urodzie ani odbiorze (D-012, ADR-003).

Pytanie pakietu: **co dokładnie zostaje w monolicie `MemoryResonancePoint`
po wyjęciu 203 rendererów (PKG-0199/0200), ile gałęzi niesie selekcja
interakcji/audio i jaka jest minimalna granica przyszłej ekstrakcji bez
zmiany zachowania?**

## Decyzja D-221: inwentaryzacja + specyfikacja, HOLD logiki

Dług F-0184-010 poza rendererami zostaje ZAPINOWANY bramką i OPISANY
specyfikacją ekstrakcji, a logika zostaje NIETKNIĘTA. Zero zmian
w `scripts/`, `scenes/`, konfiguracji, enum, serialize IDs, routingu,
progach i InputMap; nowe pliki wyłącznie: ten raport, bramka
`tests/pkg_0206_mrp_interaction_inventory_test.gd`, rejestracja bramki
w `tools/verify.ps1` (109. bramka). Każda przyszła ekstrakcja wymaga
osobnej dyspozycji właściciela i pełnej `verify.ps1` (shared-touch, D-217).

## Inwentaryzacja (stan na dysku, narzędzie: odczyt źródła + runtime)

Plik: `scripts/interactables/memory_resonance_point.gd` — 3566 linii,
221 funkcji, 206 `_draw_*` (203 rendery PropType + 3 overlaye z definicji:
`_draw_in_world_reticule`, `_draw_resolved_mark`, `_draw_contact_read`),
enum `PropType` 203 wartości jawnie numerowane 0..202, 8 exportów, 2 sygnały
(`resonance_triggered`, `state_changed`), 3 metody publiczne
(`get_contact_progress`, `get_touch_flash`, `trigger_interaction`),
most clue-before-activation (`game_state.collect_clue` przed gałęziami),
brak grup. Fasada deleguje 203 typy do `MrpLegacyRenderer` (markery 130x
`PKG-0199 pilot` + 73x `PKG-0200 slice2`) — pin sąsiedzki bez modyfikacji
(wzór 0201/0202/0203/0205).

### Selekcja interakcji: `trigger_interaction()` (linie 949–~3117)

- 1 × `if prop_type == PropType.CIRCUIT_BREAKER` + 181 ×
  `elif prop_type == PropType.*` = **182 gałęzie jawne** + 1 × `else:`
  fallback do generycznego `_memory_sound` = **183 przypisania
  `_audio_player.stream =` i 183 przypisania `pitch_scale =`** (każda gałąź
  gra dokładnie raz).
- Semantyka aktywacji: 179 gałęzi `is_activated = true` (latch) + **4
  przełączniki** `is_activated = not is_activated`: `CIRCUIT_BREAKER`,
  `SEAM_STABILIZER_LEVER`, `REFLECTIVE_PUDDLE`, `PRESSURE_RELIEF_VALVE`.
- Warstwa haptyczna idzie pierwsza i zawsze (D-147): `_touch_flash = 1.0`,
  `prop_type in SWITCH_LIKE_PROPS` → `_play_haptic(_detent_sound, …)`,
  inaczej `_play_haptic(_probe_brush_sound)`, potem `queue_redraw()`.
- `SWITCH_LIKE_PROPS` = 6 wpisów: `CIRCUIT_BREAKER`, `JAKUB_DESK_LAMP`,
  `STAIR_TIMER_SWITCH`, `SEAM_STABILIZER_LEVER`, `PRESSURE_RELIEF_VALVE`,
  `DOOR_CARD_READER`. Zbiór haptyczny ≠ zbiór przełączników: `JAKUB_DESK_LAMP`,
  `STAIR_TIMER_SWITCH`, `DOOR_CARD_READER` są switch-like dla dotyku, ale
  latchują `true`; `REFLECTIVE_PUDDLE` przełącza, ale nie jest switch-like.
- One-shot: `if is_one_shot and is_activated: return` przed haptyką —
  drugi press jest połykany przed clue/sygnałem.
- Emisja: dokładnie 1 × `resonance_triggered.emit(resonance_id,
  int(prop_type))`, potem `_resonance_flash = 1.0` + restart particles
  + `queue_redraw()`. `PHOTOGRAPH` (0) nie ma własnej gałęzi — jedzie
  fallbackiem `else` (generyczny `_memory_sound`, pitch `1.0 ± 0.02`).
  `SHOWCASE_VITRINE` (48) ma gałąź własną z `_paper_rustle_sound`
  (fakt z D-220: zmiana typu 0 ↔ 48 to zmiana dźwięku).

### Selekcja audio: `_setup_audio()` + `_setup_haptic_layer()`

- `_setup_audio()` (352 linie): 1 × `match prop_type`, **165 ramion
  `PropType.*`** (linie po strip zaczynające się od `PropType.`), **183
  unikalne typy** z jawnym dźwiękiem, **170 wywołań
  `ProceduralAudio.create_*`** (niektóre ramiona stawiają 2 dźwięki, np.
  `SZYMON_POST_CORRECTION`, `ANESTHESIA_TERMINAL`,
  `PAINT_RESIN_RESONANCE_SLAB`). 203 − 183 = **20 typów bez własnego
  dźwięku** — grają generyczny `_memory_sound` (setup w linii ~825).
- `_setup_haptic_layer()`: 3 dźwięki przez `get_cached_sound`:
  `contact_tap`, `probe_brush`, `switch_detent` (liczone w globalnych
  173 × `ProceduralAudio.create_` w pliku: 170 setup + 3 haptic).
- Cały plik: **173 × `ProceduralAudio.create_`** (stabilny pin całości).

### Co NIE jest częścią długu interakcji/audio

Rendery (203, zamknięte), 3 overlaye (z definicji w fasadzie), collision
(`_setup_collision`, radius z `interaction_radius`), particles
(`_setup_particles`), sygnały/exports/enum, most stacji
(`resonance_triggered` → `clue_inspected`, Station 10–13 z PKG-0191/0192),
routing 01–18 → 42A/B/C → 43, zapis/odczyt, pauza, kamera.

## Specyfikacja przyszłej ekstrakcji (nie wykonanie)

Gdy właściciel wyda dyspozycję, ekstrakcja dzieli się na dwa niezależne
kroki (kolejność dowolna, każdy z pełną `verify.ps1`):

1. **Tabela audio** (czysta dana): `match prop_type` z `_setup_audio()`
   → statyczna mapa `PropType → AudioStreamWAV factory` poza fasadą.
   Zachować: 183 typy jawne, 20 fallbacków, podwójne ramiona, 3 dźwięki
   haptyczne, kolejność `_setup_haptic_layer()` przed matchem, pitch
   gałęzi `CIRCUIT_BREAKER` (`1.1 / 0.9`). Ryzyko: niska — brak stanu.
2. **Tabela interakcji** (logika): 182 gałęzie + `else` → dispatch
   `PropType → {latch|toggle, sound slot, pitch}` poza fasadą. Zachować:
   kolejność haptyka → clue → gałąź → emit → flash/particles/redraw,
   one-shot przed haptyką, 4 przełączniki, 179 latchy, fallback
   `PHOTOGRAPH`, emisję dokładnie raz. Ryzyko: wysoka — to jest logika
   gry; wymaga bramki dispatch 1:1 + runtime prawdziwym mostem stacji
   (wzór D-216/D-218: stare asercje tnące fasadę prowadzić przez
   delegację, nigdy nie obniżać progu).

Zakazane w obu krokach: zmiana enum i serialize IDs, zmiana routingu,
progów, InputMap, writerów faktów, dodawanie typów/interakcji/faktów,
podpisy winiet i tezy autorskie (D-214/D-219).

## Metoda i ograniczenia (uczciwie)

- Przeczytano: `memory_resonance_point.gd` w całości strukturalnie
  (liczenia narzędziem `python`, nie okiem — liczby powyżej to fakty
  narzędziowe); `mrp_legacy_renderer.gd` tylko jako pin sąsiedzki;
  `station_18.gd:136-146` tylko jako potwierdzenie, że `prop_type`
  idzie dalej w `clue_inspected` (fakt z D-220).
- Bramka dowodzi kontraktów mierzalnych (liczby gałęzi, nazwy, dispatch
  audio, runtime 3 węzłów + one-shot), nigdy słuszności ekstrakcji ani
  odbioru. Stwierdzenie „ekstrakcja jest podzielna na tabelę audio
  i tabelę interakcji" jest propozycją architektury, nie pomiarem.
- Bez nowej tezy autorskiej (D-214/D-219). Bez capture'ów — scena
  nietknięta, żaden kadr nie był potrzebny ani generowany.
- Twardy fakt narzędziowy: fasada MRP ma końcówki CRLF — asercje tekstowe
  bramki normalizują `\r\n` do `\n` przed porównaniem (wzór PKG-0205);
  w GDScript 4.7 nie ma globalnego `chr()`, a `var x := variant + float`
  nie kompiluje się (wzór PKG-0197) — bramka używa jawnych typów.

## Wykonane

1. Ten raport (inwentaryzacja + specyfikacja dwóch kroków).
2. Nowa bramka `tests/pkg_0206_mrp_interaction_inventory_test.gd`:
   kontrakt fasady (221/206, sentinele, exporty, sygnały, metody, clue,
   SWITCH_LIKE 6 nazw, brak grup, markery 130+73, delegacje 203) +
   inwentaryzacja triggera (1 if + 181 elif + else z `_memory_sound`,
   183 stream/pitch, 179 latch + 4 toggles z nazw, haptyka pierwsza,
   one-shot, 1 emit, flash/particles/redraw, PHOTOGRAPH fallback,
   SHOWCASE_VITRINE paper_rustle) + inwentaryzacja audio (match,
   165 ramion, 183 typy jawne, 20 fallbacków wyliczeniowo, 173 create_
   w pliku, 3 haptic cached) + runtime (3 węzły 0/1/48: clue, emit raz,
   latch/toggle, state_changed, 2 klatki bez błędów; one-shot typ 5
   drugi press połykany).
3. Rejestracja: bramka dopisana do `tools/verify.ps1` (109. bramka).
4. Handoff: `CURRENT_STATE.md`, `SESSION_LOG.md` (PKG-0206), ten raport,
   `NEXT_SESSION_PROMPT.md`, `INDEX.md`, `ROADMAP.md` (wiersz 0206),
   `DECISION_LOG.md` (D-221).
5. Zero zmian w `scripts/`, `scenes/`, konfiguracji, enum, serialize IDs,
   routingu, progach i InputMap.

## Kolejka (nie wynik tego pakietu)

1. F-0184-010: rendery MRP zamknięte (203/203, PKG-0200); interakcje/audio
   ZAPINOWANE i OPISANE (ten pakiet); ekstrakcja tabel audio/interakcji
   czeka na dyspozycję (dotyka logiki, shared-touch → pełna verify).
2. `station_18 prop_type`: ZAMKNIĘTY decyzją D-220 (HOLD 0); rewizja tylko
   nowym pakietem z kadrami przed/po.
3. Ogląd skal 85/115: DOMKNIĘTY (0202 + 0203).
4. Fun, emocja, uroda, zrozumienie: OPEN-NO-EVIDENCE (D-012, ADR-003).
5. Release i `.exe`: BLOCKED (D-168). PRODUCT GO: nie jest wynikiem.
