# PKG-0214 — Pin własności progów i otwartych wyjść (M1+M2, decyzja D-227)

Data: 2026-09-12. Dyspozycja: `docs/NEXT_SESSION_PROMPT.md` (po PKG-0213)
z decyzją podjętą autonomicznie w ramach orkiestracji AI (D-025, D-085, ADR-004).
Faza R1 planu `PKG_0213_COMPREHENSIVE_AUDIT_AND_IMPLEMENTATION_PLAN.md` §8
(findings M1+M2). Zero zmian w `scripts/`, `scenes/`, konfiguracji, enum,
serialize IDs, routingu, progach i InputMap; nowe pliki wyłącznie: ten raport
i bramka `tests/pkg_0214_threshold_exit_open_pin_test.gd`, rejestracja bramki
w `tools/verify.ps1` (108. wywołanie Invoke; 115. sekcja) oraz kontrolowana
aktualizacja pinu `tests/pkg_0207_gate_census_test.gd` (107->108 wywołań,
106->107 skryptów, 105->106 testów) wg reguły D-222. D-168, D-220..D-226
obowiązują bez zmian. Ten dokument jest diagnozą techniczną wykonaną, nie
werdyktem o urodzie ani odbiorze (D-012, ADR-003).

Pytanie pakietu: **czy każde z 22 odwiedzanych miejsc trasy (01–18, 42A/B/C,
43) dostaje w runtime dokładnie jeden ThresholdZone od jedynego właściciela
z aperturą z kontraktu i otwartym wyjściem od startu sceny — bez ani jednego
odczytu — oraz czy overlap AirlockZone nigdy nie uruchamia progresji?**

## Decyzja D-227: pin własności + wyjścia, HOLD scen i statyki

`ThresholdBinder` zostaje ZAPINOWANY jako jedyny właściciel runtime'owych
progów kampanii; statyczne węzły `Threshold` w scenach kampanii są ZABRONIONE
(pin fail-closed); wyjścia są ZAPINOWANE jako otwarte od startu sceny bez
odczytów. Konflikt przepisu planu 0213 §8 (statyczne węzły w 01–18.tscn)
z dowodem runtime: `GameStateManager._observe_campaign_station` instaluje
deferred `ThresholdBinder.install(node)` + `GapLedger.ensure_exit_open(node)`
dla każdej stacji trasy, a bramki 0174/0175 dowodzą progi i przebieg
minimalny. Drugi właściciel (statyka + Binder) dryfowałby aperturami —
dlatego kontrola równoważna lub silniejsza (wzór D-216/D-218): pin Bindowany
zamiast duplikacji węzłów. Rewizja tylko nowym pakietem z bramką.

## Inwentaryzacja i pomiary (stan na dysku + runtime headless)

### Własność (statyka, 45 scen kampanii)

- `scenes/levels/station_*.tscn`: 45/45 BEZ statycznego węzła `Threshold`
  (`name="Threshold"` nie występuje) — Binder jedynym właścicielem.
- `ThresholdBinder.ROUTE`: 22 wpisy (01–18 + 42a/b/c + 43); zbiór zgodny
  z trasą w obie strony.
- `spec_for` per stacja: VEHICLE dla 03/04 (58×105), HATCH dla 14/15
  (64×64), DOOR dla reszty (45×109 mieszkalne 07/08/09/10/13, 48×112 dla
  12, 54×114 techniczne 01/02/05/06/11/16/17/18/42a/b/c/43) — wszystko
  w THRESHOLD §7.1 ±10%; placement `x = 640-24-w/2` (margines 24 px).

### Wyjścia (runtime, zero odczytów, 22/22)

- Po deferred parze GSM (install + ensure) każda stacja: `Threshold`
  istnieje, `is_open == true`, `is_exit_unlocked == true`,
  `Threshold.crossed` podpięty, `AirlockZone.body_entered` bez połączeń,
  `is_level_completed == false`.
- Rodziny żywe: DOOR + VEHICLE + HATCH (wszystkie trzy w użyciu).
- Żaden z 22 skryptów nie woła
  `call_deferred("_complete_if_player_already_in_airlock")`; handlery
  `_on_airlock*` nie zawierają progresji (`_trigger_level_completion`,
  `board_line_four`, `level_completed.emit`, `_complete_campaign`).

## Wynik weryfikacji bramkowej

- Nowa bramka `tests/pkg_0214_threshold_exit_open_pin_test.gd` PASS headless.
- Zaktualizowany rejestr pinu `tests/pkg_0207_gate_census_test.gd` PASS (108 invokes / 107 scripts / 106 tests).
- Weryfikacja zakresowa `tools/verify_scoped.ps1` (docs + smoke + 0207 + 0212 + 0214) PASS.
- Exit code 0, zero błędów i ostrzeżeń. Kadry: brak ruszonych adresów
  (zero zmian scen/skryptów) — brak nowych PNG z natury pakietu.
- Licznik D-217: 4. zakresowa po pełnej w PKG-0210 (limit PKG-0215 —
  następna pełna obowiązkowa).
