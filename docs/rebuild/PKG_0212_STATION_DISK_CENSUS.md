# PKG-0212 — Spis stacji na dysku: skrypty ↔ sceny 1:1 (zero logiki, zero obrazu)

Data: 2026-09-12. Dyspozycja: `docs/NEXT_SESSION_PROMPT.md` (po PKG-0211) z decyzją
podjętą autonomicznie w ramach orkiestracji AI (D-025, D-085, ADR-004).
Ścieżka B (`station_18 prop_type`) jest ZAMKNIĘTA decyzją D-220. Ścieżka C (ogląd 85/115)
jest DOMKNIĘTA (0202 + 0203). Ścieżka A (ekstrakcja tabel MRP) dotyka współdzielonego monolitu
i wymaga jawnej dyspozycji właściciela; bez niej nie ruszana. Ścieżka D dostarcza
autorytatywny spis dyskowy stacji kampanii: kompletność skryptów i scen, ich
wzajemną odpowiedniość 1:1 oraz pokrycie segmentów kampanii na dysku.
Ten dokument jest diagnozą techniczną wykonaną, nie werdyktem o urodzie ani odbiorze (D-012, ADR-003).

Pytanie pakietu: **czy każdy adres kampanii (trasa 01–18, legacy 19–41, finały 42A/B/C,
epilog 43) ma na dysku dokładnie jeden skrypt i jedną scenę o tym samym ID, bez sierot
i wiszących referencji, oraz czy każda scena referencjonuje własny skrypt stacji?**

## Decyzja D-226: spis + pin, HOLD logiki i obrazu

Spis stacji na dysku zostaje ZAPINOWANY nową bramką, a liczby i kontrakty tekstowe
OPISANE pinami read-only. Zero zmian w `scripts/`, `scenes/`, konfiguracji, enum,
serialize IDs, routingu, progach i InputMap; nowe pliki wyłącznie: ten raport, bramka
`tests/pkg_0212_station_disk_census_test.gd`, rejestracja bramki w `tools/verify.ps1`
(107. wywołanie Invoke; 114. sekcja w verify.ps1) oraz kontrolowana aktualizacja pinu
`tests/pkg_0207_gate_census_test.gd` (106->107 wywołań, 105->106 skryptów,
104->105 testów w verify, 104->105 testów na dysku). D-168, D-220..D-225 obowiązują bez zmian.

## Inwentaryzacja i pomiary (stan na dysku, narzędzie: odczyt tekstu + runtime)

### Skrypty stacji `scripts/levels/station_*.gd`: 45

- `station_01.gd` .. `station_41.gd` (41), `station_42a.gd` / `station_42b.gd` /
  `station_42c.gd` (3), `station_43.gd` (1) — łącznie **45**.
- Każdy definiuje `class_name` (`Station01` .. `Station41`, `Station42A` / `Station42B` /
  `Station42C`, `Station43`) oraz `extends Node2D` (45/45).

### Sceny stacji `scenes/levels/station_*.tscn`: 45

- Te same 45 ID co skrypty — zbiory równe w obie strony (zero sierot, zero wiszących).
- Każda scena referencjonuje własny skrypt stacji przez ext_resource
  (`path="res://scripts/levels/station_XX.gd"`) — 45/45.

### Helpery nie-stacyjne w `scripts/levels`: 3

- `atmosphere_rig.gd`, `creative_scene_lines.gd`, `creative_scene_presentation.gd`.
- Nie wchodzą do zbioru stacji; pinowane z nazwy, żeby cichy czwarty helper
  (albo ciche zniknięcie jednego z trzech) zapaliło bramkę.

### Pokrycie segmentów kampanii na dysku

- Trasa P9 01–18: 18/18 skryptów + 18/18 scen.
- Legacy 19–41: 23/23 skryptów + 23/23 scen.
- Finały 42A/B/C: 3/3 skryptów + 3/3 scen.
- Epilog 43: skrypt + scena.

## Wynik weryfikacji bramkowej

- Nowa bramka `tests/pkg_0212_station_disk_census_test.gd` PASS headless.
- Zaktualizowany rejestr pinu `tests/pkg_0207_gate_census_test.gd` PASS (107 invokes / 106 scripts / 105 tests).
- Weryfikacja zakresowa `tools/verify_scoped.ps1` (docs + smoke + 0206 + 0207 + 0208 + 0210 + 0211 + 0212) PASS.
- Exit code 0, zero błędów i ostrzeżeń.
