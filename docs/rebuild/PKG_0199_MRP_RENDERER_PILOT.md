# PKG-0199 — F-0184-010 MRP renderer extraction pilot (PropType 67..196)

Data: 2026-09-06. Dyspozycja: ścieżka A z `docs/NEXT_SESSION_PROMPT.md`
(po PKG-0198) + dyspozycja właściciela o weryfikacji zakresowej (D-217).
Ten dokument jest diagnozą wykonaną, nie werdyktem o urodzie ani odbiorze
(D-012, ADR-003).

Pytanie pakietu: **czy 130 rendererów legacy-donora da się wyjąć z 10-tysięcznego
monolitu `MemoryResonancePoint` do bezstanowego helpera bez zmiany obrazu,
dźwięku, writerów i serialize IDs?**

## Metoda i ograniczenia (uczciwie)

- Zakres: wyłącznie `PropType 67..196` (ciągły legacy-donor z PKG-0189 §2:
  `CRACKED_TEA_CUP` … `STATION_41_EXIT`). Aktywna trasa P9 używa z tego
  zakresu tylko dwóch typów: 68 (`cost_selector` w Station 16) i 74
  (`adaptation_offer_terminal` w Station 17); reszta to sceny 19–41
  (retired) i ich sąsiedzi. Blast radius na żywą trasę: 2 węzły.
- Audyt przed ekstrakcją (`tools/extract_mrp_pilot.py --audit`): 130/130
  funkcji znalezionych, zero zależności od logiki (brak `self.`,
  `queue_redraw`, `emit`, `GameState`, audio, particles, clue, sygnałów,
  `_resonance_flash`/`_contact_progress`/`_touch_flash`, wywołań `_draw_*`
  między sobą). Jedyne czytane stany: `is_activated` (271), `_pulse_phase`
  (166), `is_player_in_range` (22) + stałe `COLOR_*`. Rysowanie: 775
  `draw_rect`, 568 `draw_line`, 317 `draw_circle`, 34 `draw_arc`, 12
  `draw_ellipse`, 10 `draw_colored_polygon`, 7 `draw_polyline`.
- Ekstrakcja mechaniczna skryptem (nie ręczna): ciała funkcji przeniesione
  verbatim do `scripts/interactables/mrp_legacy_renderer.gd`
  (`class_name MrpLegacyRenderer extends RefCounted`) z rename'ami
  `draw_*` → `ci.draw_*`, `is_activated` → `p_is_activated`, `_pulse_phase` →
  `p_pulse`, `is_player_in_range` → `p_in_range`. Minimalne sygnatury per
  renderer (tylko czytany stan), żeby nie tripować polityki logów
  `UNUSED_PARAMETER`. Fasada trzyma 130 jednolinijkowych wrapperów:
  `func _draw_x() -> void: MrpLegacyRenderer.draw_x(self, …)`.
- Równoważność piksel-w-piksel jest konstrukcyjna (ta sama sekwencja
  wywołań rysowania dla tych samych wejść), nie mierzona hashem klatek:
  capture headless wiesza się na `frame_post_draw` (fakt z PKG-0197),
  a żaden adres nie zmienił wyglądu z definicji (delegacja 1:1).
- Automat dowodzi kontraktów mierzalnych
  (`tests/pkg_0199_mrp_renderer_pilot_test.gd`), nigdy czytelności ani odbioru.

## Wykonane

1. Helper `mrp_legacy_renderer.gd`: 130 statycznych rendererów, własne stałe
   kolorów (brak cyklu zależności z fasadą), zero Area2D/sygnałów/enuma/
   audio/particles/GameState/interakcji.
2. Fasada nietknięta kontraktowo: 206 `_draw_*`, 221 funkcji, 5 sentineli,
   8 exportów, 2 sygnały, 3 metody publiczne, most clue-before-activation,
   `SWITCH_LIKE_PROPS`, brak grup (`pkg_0189` GREEN bez modyfikacji).
3. Dispatch 1:1: każdy z 130 typów woła helper dokładnie raz; wrappery nie
   zawierają prymitywów rysunku; helper nie zawiera resztek fasady.
4. Runtime: 6 samodzielnych węzłów pilota (67/68/74/100/150/196) zbiera clue,
   emituje raz, honoruje one-shot i `state_changed`, przeżywa
   `is_player_in_range`/`_pulse_phase`/`queue_redraw`; Station 16 (68) i 17
   (74) przechodzą przez prawdziwy most MRP (`trigger_interaction` →
   `resonance_triggered` → `clue_inspected`); soak 130 typów bez wycieków
   (polityka logów).
5. Twardy konflikt migracyjny (D-216): pełna weryfikacja po ekstrakcji była
   CZERWONA w `pkg_0160` (`_draw_marta_witness_station` (188, w pilocie)
   nie miał już różu `d45b9a` w fasadzie — róż przeniósł się do helpera),
   mimo zielonych bramek zakresowych 0189+0199. Naprawa: `pkg_0160`
   rozwiązuje ciało renderera przez delegację (`_renderer_body()`),
   pinując ten sam piksel gdziekolwiek żyje — kontrola równoważna lub
   silniejsza, nie obniżenie progu. Po naprawie pełna zielona.
6. Reguła właściciela (D-217): `tools/verify_scoped.ps1` (kontrakt
   dokumentacji + jawne bramki, ta sama polityka logów) + polityka w
   `docs/WORKFLOW.md`: zakresowa tylko poza plikami współdzielonymi;
   shared-touch zawsze pełną. Ten pakiet, jako shared-touch, zamknięty pełną.

## Wynik weryfikacji

- Nowa bramka `pkg_0199` headless: PASS (fasada, helper, dispatch,
  równoważność, runtime 6 węzłów, stacje 16/17, soak).
- Sąsiad `pkg_0189`: PASS bez modyfikacji. `pkg_0160` po naprawie D-216: PASS.
- `verify_docs.ps1`: DOCS PASS (52 pliki).
- Pełny `tools/verify.ps1`: exit 0, `Verification passed.`,
  `reports/pkg_0199_verify_full.log` (103 bramki: 102 z PKG-0198 + 0199).
  Pierwszy pełny przebieg przed naprawą 0160: exit 1, log
  `reports/pkg_0199_verify.log` (dowód regresji i naprawy, nie wynik).
- Logika gry: zero writerów, flag, sygnałów, routingu, enum i serialize IDs.
  Dźwięk, zapis/odczyt, pauza, kamera: nietknięte.

## Kolejka (nie wynik tego pakietu)

1. F-0184-010 pozostaje długiem P3: interakcja/audio i rendery 0..66/197..202
   nadal w monolicie; pilot dowiódł wzorca, nie zamknął całości.
2. Ocularna inspekcja 57 kadrów 0198 (ścieżka B): nadal otwarta.
3. Fun, emocja, uroda, zrozumienie: OPEN-NO-EVIDENCE (D-012, ADR-003).
4. Release i `.exe`: BLOCKED (D-168). PRODUCT GO: nie jest wynikiem.
