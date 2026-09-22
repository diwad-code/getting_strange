# PKG-0237 — Słowa, które muszą być zarobione (Pakiet D)

Data: 2026-09-16
Decyzja: D-249
Plan: `docs/narrative/SENS_FABULARNY_PLAN_NAPRAWY_2026-09-15.md` Pakiet D (D1–D7)

Kolejka naprawy sensu fabularnego: Pakiet D z planu 2026-09-15 (po A: PKG-0234, C: PKG-0235, B: PKG-0236).
Freeze D-241 zdjęty wyłącznie dla tego pakietu.

## Cel

Żadne słowo kluczowe dla świata („Równia”), tożsamość kontrolna (kto stoi w progu w 42A/B/C)
ani lokalizacja dialogowa nie pojawia się z sufitu. Każdy termin, postać i przestrzeń
są zarobione w narracji i zakorzenione w świecie gry.

## Wdrożenie

### D1. Słowo „Równia” zarobione w stacji 17
W `scripts/levels/creative_scene_lines.gd` w dialogu `cost_ledger_console` (stacja 17):
- Para 1 kwestii zaktualizowana:
  *Lena*: „Równia. Tym słowem podpisali to miejsce. Moje nie miało nazwy na papierze.”
- Lena po raz pierwszy używa nazwy „Równia” jako etykiety odczytanej z dokumentów i rejestrów instytucji,
  a nie jako pojęcia przywiezionego z własnego świata.

### D2. Wierzbicka — dwa tryby obecności (11 i 17)
- W stacji 11 Wierzbicka występuje cieleśnie jako urzędniczka za ladą (`station_11.tscn`).
- W stacji 17 Wierzbicka występuje systemowo jako nazwisko na terminalu ofert adaptacji.
- W `scenes/levels/station_17.tscn`:
  * `CrispDiegeticText_Offer` ustawione na `"WIERZBICKA / ZAKRES // OFERTA ADAPTACJI"`.
  * `AdaptationOfferTerminal` `prop_title` ustawione na `"WIERZBICKA / ZAKRES"`.
- W `scripts/levels/creative_scene_lines.gd` w dialogu `adaptation_offer_terminal`:
  * Lena rozpoznaje nazwisko z lady w stacji 11:
    *Lena*: „Głos z lady. Bez kosztu? Bez cudzej pamięci w mojej głowie?”

### D3. Pomieszczenie analizatora nazwane w świecie (stacja 16)
- W `scenes/levels/station_16.tscn`:
  * `CrispDiegeticText_Analyzer` zaktualizowane na:
    `"POMIESZCZENIE POMIARU / POZA OBWODEM // ANALIZATOR"`.
- W `scripts/levels/station_16.gd`:
  * Nagłówek skryptu jednoznacznie definiuje adres:
    `pomieszczenie pomiaru poza obwodem`.
- Żadnego `draw_string` w `scripts/levels/station_16.gd` (zgodnie z regułą V9).

### D4. Finał B: jedno miejsce na kwestie (próg mieszkania 14)
- Usunięto anachronizm wiaty tramwajowej ze stacji 42B i kwestii finałowych B.
- W `scripts/levels/station_42b.gd`:
  * `DIALOGUE_LINES[3]` (kwestia Leny): „Stoję w progu. Czytnik nie ma tu adresu.”
- W `scripts/levels/creative_scene_lines.gd`:
  * Warianty `household_b_full`, `household_b_partial`, `household_b_withheld`:
    para 0 kwestii Leny: „Stoję w progu. Czytnik nie ma tu adresu.”
- Zachowano 9 parami różnych hashy finałowych (pin PKG-0226 nienaruszony).

### D5. Przeciek Jakuba w 42C i dialogu to echo / czytnik
- W stacji 42C Lena nie rozmawia z fizycznym Jakubem.
- W `scripts/levels/station_42c.gd`:
  * Mówca w `DIALOGUE_LINES[3]` to `"JAKUB (ECHO)"`.
- W `scripts/levels/creative_scene_lines.gd` w dialogu `memory_leak`:
  * Mówca w parach 0 i 2 zmieniony z `"Jakub"` na `"JAKUB (ECHO)"`.

### D6. Kto steruje w 42A/B/C
- W finałach 42A, 42B, 42C gracz steruje przybyłą Leną (ta, która przeszła całą drogę przez stacje 01–18).
- Przybyła Lena stoi w progu lub przy stole (czytnik w torbie, aparat w dłoni).
- Druga Lena / ciało / echo jest zastanym elementem kadrów i świata.

### D7. Epilog 43 gałąź domyślna (unseeded) bez kradzieży tonu C
- W `scripts/levels/station_43.gd`:
  * `DEFAULT_DIALOGUE_LINES` nie kradnie fraz finału C („dwie kolejności”).
  * Zamiast tego jawnie wyraża stan bez wybranej metody i otwartą lukę:
    0: „Wyjście z obwodu nie zapisało metody.”
    1: „Zostawiam to miejsce bez podpisu.”
    2: „Brak metody. Odcinki nie zostały powiązane.”
    3: „Wracam na ulicę, zanim obwód zamknie odczyt.”
    4: „Nie ma wniosku. Droga pozostaje otwarta.”
  * `_payoff_line_into_branch()` w gałęzi domyślnej (`_:`) ustawia prefiks:
    `tag = "Brak metody. "`.

## Weryfikacja

Nowa dedykowana bramka `tests/pkg_0237_earned_words_test.gd`:
1. D1: `cost_ledger_console` zawiera kwestię Leny o nazwaniu miejsca „Równia” na papierze;
2. D2: Wierzbicka ma dwa tryby (postać przy ladzie w 11, terminal „WIERZBICKA / ZAKRES” w 17 z kwestią Leny „Głos z lady”);
3. D3: Stacja 16 nosi diegetyczny szyld „POMIESZCZENIE POMIARU / POZA OBWODEM // ANALIZATOR”;
4. D4: Finał B nie zawiera wiaty tramwajowej ani w 42B, ani w wariantach household_b; kwestia mówi o progu m. 14 i braku adresu w czytniku;
5. D5: Przeciek Jakuba w 42C i memory_leak ma mówcę „JAKUB (ECHO)”;
6. D6: Weryfikacja sterowania i obecności w 42A/B/C;
7. D7: Epilog 43 w gałęzi domyślnej nie zawiera frazy „dwie kolejności” i zwraca linię z tagiem „Brak metody”.

Wszystkie piny i bramki nadrzędne zachowane:
- `tests/pkg_0207_gate_census_test.gd`: 128 wywołań / 127 skryptów / 126 referencji / 126 plików na dysku;
- `tests/pkg_0107_smoke_test.gd`: PASS;
- `tests/pkg_0195_creative_scene_c_test.gd`: PASS (kontrolowana aktualizacja D4 'Stoję w progu' zamiast wiaty + zachowanie 'klucze na blat' w D7);
- `tests/pkg_0226_truth_payoff_table_pin_test.gd`: PASS (9 unikalnych hashy);
- `tests/pkg_0234_ghost_props_test.gd`: PASS;
- `tests/pkg_0235_gap_verbs_test.gd`: PASS;
- `tests/pkg_0236_cuts_not_teleports_test.gd`: PASS;
- `tests/pkg_0216_dictionary_content_pin_test.gd`: PASS;
- `tests/pkg_0217_synthesis_forecast_pin_test.gd`: PASS.

## Ograniczenia i zakazy

- Brak zmian w Pakiecie E (mosty dialogowe).
- Brak platformingu i przeszkód zręcznościowych (D-099).
- Brak web deliverables ani gita (D-098, D-016).
- Brak przedwczesnego release/.exe ani twierdzeń o emocjach gracza (D-012, D-168).
