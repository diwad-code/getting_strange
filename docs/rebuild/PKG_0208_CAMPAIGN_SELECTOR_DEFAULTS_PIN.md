# PKG-0208 — Pin selektora kampanii i defaultów prezentacji (zero logiki, zero obrazu)

Data: 2026-09-06. Dyspozycja: `docs/NEXT_SESSION_PROMPT.md` (po PKG-0207)
z decyzją podjętą w imieniu właściciela — prompt sesji przekazuje
podejmowanie decyzji („kieruj się dobrem projektu", ACT). Ścieżka A
(ekstrakcja tabel audio/interakcji MRP wg specyfikacji PKG-0206) dotyka
logiki i wymaga jawnej dyspozycji technicznej; ten pakiet jej NIE wykonuje —
delegacja decyzji o zakresie nie jest dyspozycją dotykania logiki (reguła
z PKG-0205, podtrzymana w D-221, D-222 i tutaj). Ścieżka B (`station_18
prop_type`) jest ZAMKNIĘTA decyzją D-220. Ścieżka C (ogląd 85/115) jest
DOMKNIĘTA (0202 + 0203). Ten dokument jest diagnozą wykonaną, nie werdyktem
o urodzie ani odbiorze (D-012, ADR-003).

Pytanie pakietu: **czy stałe selektora kampanii, routingu finałów i defaultów
prezentacji w `GameStateManager` są nadal dokładnie takie, jak wymagają
D-200 (pauza na mianowniku 20 adresów), D-192 (cutover 01–18 → 42A/B/C → 43)
i ogląd skal 0202/0203 (85/115 HOLD) — bez dotykania logiki ani obrazu?**

## Decyzja D-223: pin selektora/defaultów, HOLD logiki i obrazu

Selektor kampanii, routing finałów i defaulty prezentacji zostają ZAPINOWANE
nową bramką, a logika zostaje NIETKNIĘTA. Zero zmian w `scripts/`, `scenes/`,
konfiguracji, enum, serialize IDs, routingu, progach i InputMap; nowe pliki
wyłącznie: ten raport, bramka
`tests/pkg_0208_campaign_selector_defaults_test.gd`, rejestracja bramki
w `tools/verify.ps1` (105. wywołanie Invoke; 111. sekcja w konwencji
liczenia) oraz kontrolowana aktualizacja liczb w bramce `pkg_0207`
(101 → 102 testów, 103 → 104 wywołania, 102 → 103 skrypty — jawna reguła
ewolucji z D-222, wzór D-216/D-218: stara asercja nazwana i zastąpiona
kontrolą równoważną, nigdy nie obniżoną). Ekstrakcja tabel audio/interakcji
nadal czeka na dyspozycję (shared-touch, pełna verify). D-220, D-221 i D-222
obowiązują bez zmian.

Uzasadnienie (dobro projektu): poprzednie pakiety zapinowały rendery
(203/203), interakcje/audio (182+else / 183+20), fundamenty (640×360 /
60 Hz / 10 akcji) i rejestr bramek — ale selektor 20 adresów, mapa
operacja→finał i granice skali tekstu nie miały żadnego właściciela-pinu.
Cicha zmiana selektora (np. powrót mianownika 43 z D-200 albo wypadnięcie
`station_42a`) lub granic skali (84/116 zamiast 85/115 z 0202/0203) nie
zapaliłaby żadnej bramki. Ten pin zamyka tę lukę przed obowiązkową pełną
weryfikacją w PKG-0209.

## Inwentaryzacja (stan na dysku, narzędzie: odczyt tekstu + runtime)

Plik: `scripts/core/game_state_manager.gd` (read-only; to nie jest plik
współdzielony z listy D-217 w sensie modyfikacji — pakiet go nie zmienia,
tylko czyta tekstowo i ładuje stałe w runtime).

### Selektor i routing (tekst + runtime przez constant map)

- `CAMPAIGN_ROUTE`: **18** wpisów `station_01` … `station_18` w kolejności;
  brak `station_19`, brak `station_42a/b/c`, brak `station_43`.
- `CAMPAIGN_LEGACY_STATIONS`: **23** wpisy `station_19` … `station_41`
  w kolejności (materiał emerytowany, nie na trasie).
- `CAMPAIGN_FINALES`: **3** wpisy `station_42a, station_42b, station_42c`.
- `CAMPAIGN_EPILOGUE`: `station_43` (jeden wpis).
- `CAMPAIGN_SELECTOR_STATIONS`: **20** wpisów w kolejności `station_01` …
  `station_18, station_42a, station_43`; zawiera `station_42a`, NIE zawiera
  `station_42b`/`station_42c` (finały B/C osiągalne wyborem operacji, nie
  selektorem — pinuje jawnie, żeby nikt „nie naprawił" tego po cichu);
  NIE zawiera żadnej stacji legacy 19–41.
- `OPERATION_TO_FINALE`: `A → station_42a, B → station_42b, C → station_42c`
  (3 klucze, wartości w `CAMPAIGN_FINALES`).
- `CAMPAIGN_TRANSITION_LIMIT = 18`,
  `LEGACY_CAMPAIGN_TRANSITION_LIMIT = 41`.

### Defaulty prezentacji i ustawień (tekst + runtime)

- `DEFAULT_MASTER_VOLUME = 0.85`.
- `DEFAULT_TEXT_SPEED_CPS = 42.0`.
- `DEFAULT_TEXT_SCALE = 1.0`, `MIN_TEXT_SCALE = 0.85`,
  `MAX_TEXT_SCALE = 1.15`; porządek `MIN < DEFAULT < MAX` (kotwica oglądu
  0202/0203: 85/100/115%).
- `DEFAULT_REDUCED_MOTION = false` (tryb ograniczonego ruchu domyślnie
  wyłączony, włącza wyłącznie gracz — D-151 / PKG-0141).
- `REMAPPABLE_ACTIONS`: **5** wpisów `jump, interact, pause, restart,
  trigger_correction` (mały deterministyczny zestaw; ruch analogowy trzyma
  własne bindowania).

### Spójność handoffu (read-only)

- `docs/SESSION_LOG.md` kończy się wpisem `## PKG-0208:` (append-only).
- `docs/CURRENT_STATE.md` nazywa PKG-0208 jako stan aktualny.
- `docs/DECISION_LOG.md` zawiera D-223.
- `docs/NEXT_SESSION_PROMPT.md` nazywa PKG-0208 jako wykonany i PKG-0209
  jako spodziewany następny; markery kontraktu dokumentacji
  (`CEL SESJI`, `SRODOWISKO I BASELINE`, `KRYTERIA AKCEPTACJI`,
  `KONIEC PAKIETU JEST OBOWIAZKOWY`) nietknięte.

## Metoda i ograniczenia (uczciwie)

- Przeczytano: `game_state_manager.gd` tekstowo (segmenty stałych) +
  `load(...).get_script_constant_map()` w runtime (rozmiary i wartości),
  cztery dokumenty handoffu tekstowo. `scripts/`, `scenes/` i stacje
  nietknięte i nieczytane poza pinem sąsiedzkim poprzedników (0198/0201/
  0202/0203/0205/0206/0207 PASS bez modyfikacji treści gry w zakresowej;
  0207 z kontrolowaną aktualizacją liczb wg własnej reguły D-222).
- Bramka dowodzi kontraktów mierzalnych (składy, kolejności, liczby,
  defaulty, spójność numerów), nigdy słuszności przyszłej ekstrakcji,
  urody ani odbioru. Stwierdzenie „selektor trzyma 20" znaczy wyłącznie:
  tablica ma 20 wpisów w tej kolejności.
- Bez nowych writerów/flag/sygnałów/routingu. Bez capture'ów — scena
  nietknięta, żaden kadr nie był potrzebny ani generowany.
- Twardy fakt narzędziowy: `Array[StringName]` zawiera `]`, więc ekstrakcja
  segmentu tablicy musi szukać `]` dopiero za `= [` (inaczej pusty zbiór;
  wykryte sondą w tym pakiecie, bez wpływu na bramkę — bramka szuka
  jawnie od `= [`).

## Wykonane

1. Ten raport (inwentaryzacja selektora/routingu/defaultów + spójność
   handoffu).
2. Nowa bramka `tests/pkg_0208_campaign_selector_defaults_test.gd`:
   selektor/routing (18 / 23 / 3 / epilog / 20 w kolejności / mapa A-B-C /
   limity 18/41 + runtime przez constant map) + defaulty (volume, CPS,
   skale z porządkiem, reduced-motion, 5 remapów) + handoff
   (PKG-0208/D-223/PKG-0209) + runtime (autoload GameStateManager,
   2 klatki bez błędów).
3. Kontrolowana aktualizacja bramki `tests/pkg_0207_gate_census_test.gd`:
   101 → 102 testy, 103 → 104 wywołania, 102 → 103 skrypty (reguła D-222;
   asercje handoffu `contains` przechodzą bez zmian).
4. Rejestracja: bramka dopisana do `tools/verify.ps1` (wzór
   0201/0202/0203/0205/0206/0207: wyłącznie dopisanie wywołania).
5. Handoff: `CURRENT_STATE.md`, `SESSION_LOG.md` (PKG-0208), ten raport,
   `NEXT_SESSION_PROMPT.md`, `INDEX.md`, `ROADMAP.md` (wiersz 0208),
   `DECISION_LOG.md` (D-223).
6. Zero zmian w `scripts/`, `scenes/`, konfiguracji, enum, serialize IDs,
   routingu, progach i InputMap.

## Kolejka (nie wynik tego pakietu)

1. F-0184-010: rendery MRP zamknięte (203/203, PKG-0200); interakcje/audio
   ZAPINOWANE i OPISANE (PKG-0206, D-221); ekstrakcja tabel audio/interakcji
   czeka na dyspozycję (dotyka logiki, shared-touch → pełna verify).
2. `station_18 prop_type`: ZAMKNIĘTY decyzją D-220 (HOLD 0); rewizja tylko
   nowym pakietem z kadrami przed/po.
3. Ogląd skal 85/115: DOMKNIĘTY (0202 + 0203); granice 0.85/1.15 ZAPINOWANE
   tym pakietem (D-223).
4. Licznik D-217: ostatnia pełna PKG-0204; zakresowe 0205/0206/0207/0208 (4);
   **PKG-0209 MUSI być pełną `verify.ps1`** (limit pięciu pakietów) albo
   wcześniejszy pakiet shared-touch/checkpoint zamyka się pełną.
5. Fun, emocja, uroda, zrozumienie: OPEN-NO-EVIDENCE (D-012, ADR-003).
6. Release i `.exe`: BLOCKED (D-168). PRODUCT GO: nie jest wynikiem.
