# PKG-0215 — Luki 1:1 z głosem i priorytet interact (M6+M4, decyzja D-228)

Data: 2026-09-12. Dyspozycja: `docs/NEXT_SESSION_PROMPT.md` (po PKG-0214)
z decyzją podjętą autonomicznie w ramach orkiestracji AI (D-025, D-085, ADR-004).
Faza R2 planu `PKG_0213_COMPREHENSIVE_AUDIT_AND_IMPLEMENTATION_PLAN.md` §8
(findings M6: 9 mapowań na ~30 feedbacków, puste flagi 09–14; M4: anchor
kradnie `interact` most-vs-próg). Blast: `gap_ledger.gd` (shared) + logika
inputu `station_14.gd` + wiring w 01–18 → PEŁNA `verify.ps1` (limit D-217).
D-168, D-220..D-227 obowiązują bez zmian. Enum, serialize IDs, routing,
progi i InputMap nietknięte. Ten dokument jest diagnozą techniczną wykonaną,
nie werdyktem o urodzie ani odbiorze (D-012, ADR-003).

Pytanie pakietu: **czy każdy zablokowany czasownik na trasie 01–18 nazywa
swoją lukę głosem Leny (albo jest jawnym tłem), czy luki s09–s14 mają realne
flagi stacji oraz czy gotowy próg wygrywa z kotwicą o `interact` w 14?**

## Decyzja D-228: tabela 1:1 + głos + priorytet, HOLD liczb

`FEEDBACK_TO_GAP` uzupełniona do pełnego pokrycia trasy (9 → 54 wpisy +
1 override + 9 wpisów tła); flagi s09–s14 wypełnione realnymi zmiennymi
stacji; zablokowane czasowniki mówią myślą luki (strażnicy: jedna myśl
naraz, nigdy na dialog CRT); w 14 gotowy `Threshold` wygrywa z kotwicą.
Liczby D-221 (182+else / 183+20 / SWITCH_LIKE 6) nietknięte — pakiet nie
dodaje gałęzi triggerów ani dźwięków, tylko mapuje istniejące feedbacki.
Rewizja tylko nowym pakietem z bramką.

## Inwentaryzacja i pomiary

### M6-dane: 63 distinct feedbacki trasy → 54 mapy + 1 override + 9 teł

- Inwentarz: ~150 literalów `_record_feedback` w `scripts/levels/` (w tym
  szum parametrów `feedback_id/val/value`); trasa 01–18 + 42a/b/c + 43:
  63 distinct.
- Reguła default: zablokowany czasownik stacji S nazywa lukę S.
  Wyjątki cross-station (brak w S, odczyt w innej): `opening_choice`
  (02→s01), `route_time_required` (03→s02, pre-existing), `key_trial_required`
  (11→s10), `institution_trial_required` (17→s16 fakty donorowe:
  trial/home_echo/mechanic_cost), `consent_scope_required` (18→s17).
  Dzielony literał `passage_required` (09+11): default s09, override
  `station_11|passage_required` → s11.
- Tła (terminalne, bez późniejszej blokady): `choice_already_committed`,
  `planter_returned_to_step`, `sideboard_returned`,
  `method_force_home/close_equal/mutual_passage_required` (finałowe lokalne —
  mapa do s18 kazałaby wracać do 18, fałszywie),
  `admin_notice/credits_inspected`, `epilogue_completed_cleanly`.
- Flagi: s09 `is_floor_record_observed`, s10 `is_key_trial_completed`,
  s11 `is_private_photograph_inspected`, s12 `is_message_heard`,
  s13 `are_documents_compared`, s14 `are_behaviors_named` (wszystkie
  zweryfikowane jako `var` w skryptach i runtime).

### M6-głos: martwa ścieżka ożywiona z dwojgiem strażników

- `annotate_feedback` istniała, lecz NIKT jej nie wołał (martwa); `speak`
  wołany wprost nigdzie. Głos luk milczał w 100% przypadków.
- Wiring: 1 linia `GapLedger.annotate_feedback(self, value)` w każdym
  `_record_feedback` stacji 01–18 (finały/epilog nietknięte — ich feedbacki
  są tłem). `present_thought` nie throttluje, więc `speak` pomija: (1) gdy
  `InnerThoughtSurface.visible` (jedna myśl naraz, 3,5–7 s), (2) gdy
  `CRTDialogueBox.is_presenting()` (myśl nigdy na dialog; metoda, nie flaga —
  twardy fakt implementacyjny).

### M4: strażnik gotowego progu w 14

- Stan zastany: `station_14._unhandled_input` konsumował KAŻDY `interact`
  (toggle albo `no_element_in_reach` — także przy drzwiach, 190 px od mostu).
- Poprawka: gdy `Threshold.is_ready_for_entry()`, 14 zwraca bez konsumpcji
  i bez feedbacku (priorytet MRP > Anchor > Threshold). Propagacja
  dziecko-najpierw i tak dawała pierwszeństwo progowi; strażnik czyni je
  niezależnym od kolejności. Jedyny `_unhandled_input` na trasie poza
  legacy 24 (donor, nietknięty).

## Wynik weryfikacji bramkowej

- Nowa bramka `tests/pkg_0215_gap_voice_pin_test.gd` PASS headless:
  (1) literaly 01–18 → mapa/override/tło, brak martwych wpisów i luk
  bez pokrycia; (2) wiring w 18/18; (3) flagi s09–s14 realne statycznie
  i runtime; (4) 10× E przy gotowym progu nie rusza kotwicy ani feedbacku,
  z dala od progu kotwica działa.
- Zaktualizowany rejestr pinu `tests/pkg_0207_gate_census_test.gd` PASS
  (109 invokes / 108 scripts / 107 tests).
- Rejestracja 116. sekcji w `tools/verify.ps1`.
- Kadry `reports/pkg_0215/visual/` (station_14 × 85/100/115 × full/notext,
  Intel Iris Xe, OpenGL): notext ±1% rozmiaru vs 0202 (struktura stabilna,
  `_draw` nietknięty); full różni się fazą maszyny do pisania CRT i żywą
  maszynerią (twardy fakt: wnioski oczne, nie pikselowe).
- PEŁNA `tools/verify.ps1` PASS (116 sekcji, `Verification passed.`,
  dowód w logu pakietu); licznik D-217 ZRESETOWANY (0 zakresowych po pełnej).
- Exit code 0. D-221 (0206) GREEN bez modyfikacji — potwierdza, że liczby
  gałęzi/dźwięków nietknięte.
