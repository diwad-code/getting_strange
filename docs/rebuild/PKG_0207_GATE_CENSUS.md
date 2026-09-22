# PKG-0207 — Spis bramek i pin fundamentów (zero logiki, zero obrazu)

Data: 2026-09-06. Dyspozycja: `docs/NEXT_SESSION_PROMPT.md` (po PKG-0206)
z decyzją podjętą w imieniu właściciela — prompt sesji przekazuje
podejmowanie decyzji („kieruj się dobrem projektu", ACT). Ścieżka A
(ekstrakcja tabel audio/interakcji MRP wg specyfikacji PKG-0206) dotyka
logiki i wymaga jawnej dyspozycji technicznej; ten pakiet jej NIE wykonuje —
delegacja decyzji o zakresie nie jest dyspozycją dotykania logiki (reguła
z PKG-0205, podtrzymana w D-221 i tutaj). Ścieżka B (`station_18 prop_type`)
jest ZAMKNIĘTA decyzją D-220. Ścieżka C (ogląd 85/115) jest DOMKNIĘTA
(0202 + 0203). Ten dokument jest diagnozą wykonaną, nie werdyktem o urodzie
ani odbiorze (D-012, ADR-003).

Pytanie pakietu: **czy przy 100 plikach testów i 100+ wywołaniach bramek
rejestr `tools/verify.ps1` jest nadal w pełni spójny z dyskiem (zero
osieroconych testów, zero wiszących referencji, zero zdublowanych nazw),
a fundamenty kontraktu (viewport, fizyka, InputMap) i handoff dokumentów
trzymają pin — bez dotykania logiki ani obrazu?**

## Decyzja D-222: spis + pin, HOLD logiki i obrazu

Rejestr bramek zostaje ZAPINOWANY nową bramką spisu, a fundamenty i spójność
handoffu OPISANE pinami read-only. Zero zmian w `scripts/`, `scenes/`,
konfiguracji, enum, serialize IDs, routingu, progach i InputMap; nowe pliki
wyłącznie: ten raport, bramka
`tests/pkg_0207_gate_census_test.gd`, rejestracja bramki w `tools/verify.ps1`
(104. wywołanie Invoke; 110. sekcja w konwencji liczenia z CURRENT_STATE).
Ekstrakcja tabel audio/interakcji nadal czeka na dyspozycję (shared-touch,
pełna verify). D-220 i D-221 obowiązują bez zmian.

## Inwentaryzacja (stan na dysku, narzędzie: odczyt tekstu + runtime)

### Spis bramek (przed tym pakietem: 100 / 100 / 102)

- Pliki testów na dysku (`tests/*.gd`): **100**.
- Unikalne referencje `res://tests/*.gd` w `tools/verify.ps1`: **100**.
- Różnica w obie strony: **zero** — brak testów osieroconych (plik bez
  rejestracji) i brak referencji wiszących (rejestracja bez pliku).
- Wywołania bramek ze skryptem (`'--script'`): **101** = 100 testów + 1
  narzędzie `res://tools/frame_budget_audit.gd` (bramka audytu budżetu klatki
  PKG-0130; plik istnieje, pinowany).
- Wywołania `Invoke-GodotGate` łącznie: **102** = 101 ze skryptem + 1 import
  edytora bez skryptu (`--editor --quit`). Wiersz definicji
  `function Invoke-GodotGate` nie jest wywołaniem i nie wchodzi do pinu —
  bramka liczy wyłącznie wiersze wywołujące (z kontynuacją backtick).
- Nazwy bramek (`-Name '...'`): wszystkie unikalne, zero dubli.
- Po tym pakiecie: 101 testów, 101 referencji, 102 wywołania ze skryptem,
  103 wywołania łącznie.

### Fundamenty (read-only, tekst + runtime)

- `project.godot`: `viewport_width=640`, `viewport_height=360`,
  `physics_ticks_per_second=60` (tekst); runtime `ProjectSettings` zwraca te
  same wartości dla `display/window/size/viewport_width`,
  `display/window/size/viewport_height`,
  `physics/common/physics_ticks_per_second`.
- InputMap: 10 semantycznych akcji, każda z co najmniej jednym eventem:
  `move_left`, `move_right`, `move_up`, `move_down`, `jump`, `restart`,
  `pause`, `interact`, `trigger_correction`, `sprint`.

### Spójność handoffu (read-only)

- `docs/SESSION_LOG.md` kończy się wpisem `## PKG-0207:` (append-only).
- `docs/CURRENT_STATE.md` nazywa PKG-0207 jako stan aktualny.
- `docs/DECISION_LOG.md` zawiera D-222.
- `docs/NEXT_SESSION_PROMPT.md` nazywa PKG-0207 jako wykonany i PKG-0208
  jako spodziewany następny; markery kontraktu dokumentacji
  (`CEL SESJI`, `SRODOWISKO I BASELINE`, `KRYTERIA AKCEPTACJI`,
  `KONIEC PAKIETU JEST OBOWIAZKOWY`) nietknięte (dowodzi bramka docs).

## Metoda i ograniczenia (uczciwie)

- Przeczytano: `tools/verify.ps1` w całości tekstowo (spis narzędziem, nie
  okiem), katalog `tests/` przez `DirAccess`, `project.godot` tekstowo
  + `ProjectSettings`/`InputMap` w runtime, cztery dokumenty handoffu
  tekstowo. `scripts/`, `scenes/` i stacje nietknięte i nieczytane poza
  pinem sąsiedzkim poprzedników (0198/0201/0202/0203/0205/0206 PASS bez
  modyfikacji w zakresowej).
- Bramka dowodzi kontraktów mierzalnych (zbiory równe, liczby, viewport,
  ticki, akcje, spójność numerów), nigdy słuszności przyszłej ekstrakcji,
  urody ani odbioru. Stwierdzenie „rejestr jest zdrowy" znaczy wyłącznie:
  każdy test jest uruchamiany i każda rejestracja ma plik.
- Liczby 103/102/101 to fakty narzędziowe na moment pakietu; każda nowa
  bramka aktualizuje je razem z tym pinem (wzór D-216/D-218: konflikt starej
  asercji z nową decyzją nazwać i zastąpić kontrolą równoważną lub
  silniejszą, nigdy nie obniżać progu).
- Bez nowych writerów/flag/sygnałów/routingu. Bez capture'ów — scena
  nietknięta, żaden kadr nie był potrzebny ani generowany.
- Twardy fakt narzędziowy: wiersz `function Invoke-GodotGate` zawiera nazwę
  funkcji, więc pin wywołań liczy wiersze z kontynuacją backtick, nie
  surowe wystąpienia podciągu (inaczej +1).

## Wykonane

1. Ten raport (spis + pin fundamentów + spójność handoffu).
2. Nowa bramka `tests/pkg_0207_gate_census_test.gd`: spis (zbiory równe,
   103 wywołania / 102 skrypty / 101 testów + self, audyt istnieje, nazwy
   unikalne) + fundamenty (tekst i runtime: 640×360, 60 Hz, 10 akcji
   z eventami) + handoff (PKG-0207/D-222/PKG-0208) + runtime (autoload
   GameStateManager, 2 klatki bez błędów).
3. Rejestracja: bramka dopisana do `tools/verify.ps1` (wzór
   0201/0202/0203/0205/0206: wyłącznie dopisanie wywołania).
4. Handoff: `CURRENT_STATE.md`, `SESSION_LOG.md` (PKG-0207), ten raport,
   `NEXT_SESSION_PROMPT.md`, `INDEX.md`, `ROADMAP.md` (wiersz 0207),
   `DECISION_LOG.md` (D-222).
5. Zero zmian w `scripts/`, `scenes/`, konfiguracji, enum, serialize IDs,
   routingu, progach i InputMap.

## Kolejka (nie wynik tego pakietu)

1. F-0184-010: rendery MRP zamknięte (203/203, PKG-0200); interakcje/audio
   ZAPINOWANE i OPISANE (PKG-0206, D-221); ekstrakcja tabel audio/interakcji
   czeka na dyspozycję (dotyka logiki, shared-touch → pełna verify).
2. `station_18 prop_type`: ZAMKNIĘTY decyzją D-220 (HOLD 0); rewizja tylko
   nowym pakietem z kadrami przed/po.
3. Ogląd skal 85/115: DOMKNIĘTY (0202 + 0203).
4. Licznik D-217: ostatnia pełna PKG-0204; zakresowe 0205/0206/0207 (3);
   pełna wymagana przy shared-touch / kontrakcie / checkpoincie albo
   najpóźniej w PKG-0209 (został 1 pakiet zakresowy: PKG-0208).
5. Fun, emocja, uroda, zrozumienie: OPEN-NO-EVIDENCE (D-012, ADR-003).
6. Release i `.exe`: BLOCKED (D-168). PRODUCT GO: nie jest wynikiem.
