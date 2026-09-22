# PKG-0205 — Decyzja `station_18 MartaTruthTable prop_type`: HOLD na PHOTOGRAPH (ścieżka B)

Data: 2026-09-06. Dyspozycja: ścieżka B z `docs/NEXT_SESSION_PROMPT.md`
(po PKG-0204), z decyzją podjętą w imieniu właściciela — prompt sesji
przekazuje podejmowanie decyzji („kieruj się dobrem projektu"). Ścieżka A
(ekstrakcja interakcji/audio MRP) dotyka logiki i pozostaje nieruszona bez
osobnej dyspozycji technicznej; ten pakiet jej nie dotyka. Ścieżka C
(ogląd 85/115) jest domknięta (0202 + 0203). Ten dokument jest diagnozą
wykonaną, nie werdyktem o urodzie ani odbiorze (D-012, ADR-003).

Pytanie pakietu: **jaki typ ma nieść `MartaTruthTable` na stacji 18 —
skoro blok w `scenes/levels/station_18.tscn` nie ma linii `prop_type`
i jedzie na domyslnym `PHOTOGRAPH` (0)?**

## Decyzja D-220: HOLD na efektywnym 0 (PHOTOGRAPH), zero zmian sceny

Otwarty fakt danych z PKG-0200 zostaje zamknięty decyzją, nie obrazem:
`MartaTruthTable` ZOSTAJE na `PHOTOGRAPH`. Żadna linia `.tscn`, żaden
skrypt, enum, dźwięk ani writer nie zmienia się w tym pakiecie. Każda
przyszła zmiana wartości na niezerową wymaga nowego pakietu z kadrami
przed/po normalnym sterownikiem i rewizji D-220 — pilnuje tego nowa bramka.

## Uzasadnienie (kod + kadr, nie gust)

1. Żaden z 203 istniejących rendererów nie jest „witryną sklepu przy
   ulicy". Jedyny kandydat z nazwy, `SHOWCASE_VITRINE` (48), to gablota
   instytucjonalna UCP 34x46 px: aluminiowa rama, podświetlany panel
   `c2cec8`, dwa białe dokumenty z pieczątką i nagłówkiem, dolna świetlówka
   (`mrp_legacy_renderer.gd:draw_showcase_vitrine`). Na ciemnej ulicy 18
   (kadr 0203 s115 full: głęboki granat, bursztynowa latarnia 266,128)
   byłaby jasną plamą 2x większą od obecnej. `PHOTOGRAPH` (0) to mała
   24x20 px przygaszona ramka (`4b585e`, sylwety po lewej, puste prawe
   trzecie) — nie rozpycha sylwety trzymanej przez 0198/0201/0202/0203
   HOLD. Kadr 0203 s115 full pokazuje drobny szary prostokąt w środku
   rysowanej przez stację witryny; porządek kadru jest zachowany.
2. Zamiana typu to także zamiana dźwięku. `PHOTOGRAPH` nie ma własnej
   gałęzi w `trigger_interaction()` ani w `_setup_audio()` i gra
   generycznym `_memory_sound`; typ 48 grałby `paper_rustle_sound`
   (gałąź `SHOWCASE_VITRINE` w obu funkcjach). Zmiana audio bez dyspozycji
   audio jest poza zakresem.
3. Nowy typ w enum to nowy kontrakt: zmiana enum, ryzyko serialize IDs,
   204. delegacja do dopisania i rewizja pinów D-218 — zakazane bez jawnego
   zlecenia („nie dodawać interakcji"; prompt ścieżki B mówi o wyborze
   spośród istniejących, nie o nowym typie).
4. Diegezę niesie stacja, nie węzeł MRP: `_draw_marta_window()` rysuje
   witrynę 92x70 z szybą, szprosami i trzema kropkami stanu; węzeł MRP
   niesie interakcję. Logika stacji (`station_18.gd:136-146`) rozgałęzia
   po `resonance_id`, a `prop_type` jedynie przekazuje dalej w
   `clue_inspected` — HOLD nie zmienia żadnego przejścia (forecast →
   truth → commit → 42A/B/C).

## Metoda i ograniczenia (uczciwie)

- Przeczytano: `station_18.tscn` (bloki 124-157: 53/brak/16),
  `station_18.gd` w całości (logika ignoruje typ), obie gałęzie audio
  i oba rendery w źródle, kadr 0203 s115 full okiem (bez nowych capture'ów
  — scena nietknięta, więc „przed" z `reports/pkg_0203/visual/` jest
  nadal aktualne; nowych PNG nie generowano i nie nadpisano starszych).
- Twardy fakt narzędziowy: `memory_resonance_point.gd` ma końcówki CRLF —
  asercje tekstowe bramki normalizują `\r\n` do `\n` przed porównaniem.
- Bramka dowodzi kontraktów mierzalnych, nigdy „słuszności artystycznej".
  Stwierdzenie „mała ramka nie psuje kadru" jest oceną na podstawie kadru
  0203, nie pomiarem; pomiar obejmuje typy, dispatch i runtime.
- Bez nowej tezy autorskiej (D-214/D-219). Ścieżka A (interakcje/audio
  MRP) nietknięta — delegacja decyzji nie jest dyspozycją dotykania logiki.

## Wykonane

1. Nowa bramka `tests/pkg_0205_station18_proptype_hold_test.gd`: efektywne
   typy trójki z tekstu `.tscn` (53/0/16; brak linii = default 0, jawne 0
   też przechodzi, niezerowe FAIL) + tożsamość węzła (id/tytuł) + oba
   rendery w helperze i dispatch 0/48 w fasadzie + runtime (ładowanie
   stacji, typy żywe, porządek X 176 < 332 < 484, 2 klatki bez błędów).
2. Rejestracja: bramka dopisana do `tools/verify.ps1` (108. bramka;
   104 z PKG-0200 + 0201 + 0202 + 0203 + 0205; numer 0204 był checkpointem
   bez bramki).
3. Handoff: `CURRENT_STATE.md`, `SESSION_LOG.md` (PKG-0205), ten raport,
   `NEXT_SESSION_PROMPT.md`, `INDEX.md`, `ROADMAP.md` (wiersz 0205),
   `DECISION_LOG.md` (D-220).
4. Zero zmian w `scripts/`, `scenes/`, konfiguracji, enum, serialize IDs,
   routingu, progach i InputMap.

## Kolejka (nie wynik tego pakietu)

1. F-0184-010: rendery MRP zamknięte (203/203, PKG-0200); dług
   interakcji/audio poza rendererami czeka na dyspozycję (dotyka logiki).
2. Otwarty fakt `station_18 prop_type`: ZAMKNIĘTY decyzją D-220 (HOLD 0).
   Rewizja tylko nowym pakietem z kadrami przed/po i bramką mierzalną.
3. Fun, emocja, uroda, zrozumienie: OPEN-NO-EVIDENCE (D-012, ADR-003).
4. Release i `.exe`: BLOCKED (D-168). PRODUCT GO: nie jest wynikiem.
