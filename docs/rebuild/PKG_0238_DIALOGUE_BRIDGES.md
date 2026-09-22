# PKG-0238 — Mosty dialogowe (Pakiet E)

Data: 2026-09-16
Decyzja: D-250
Plan: `docs/narrative/SENS_FABULARNY_PLAN_NAPRAWY_2026-09-15.md` Pakiet E (E1–E3)

Kolejka naprawy sensu fabularnego: Pakiet E z planu 2026-09-15 (po A: PKG-0234, C: PKG-0235, B: PKG-0236, D: PKG-0237).
Ostatni pakiet z 5-częściowego planu naprawy sensu fabularnego (A, C, B, D, E).
Freeze D-241 zdjęty wyłącznie dla tego pakietu.

## Cel

Domknięcie ciągłości narracyjnej i dialogowej trasy kampanii (stacje 09–18 oraz finały 42A/B/C i epilog 43).
Zagwarantowanie, że każde przejście między stacjami jest logicznie powiązane kwestiami wejścia i wyjścia,
tajemnica trzech sekund nie jest łopatologicznie tłumaczona w tekście, a rezerwy `DIALOGUE_LINES` w finałach
są precyzyjnie zaudytowane i udokumentowane jako edytorski fallback (pin 0107).

## Wdrożenie

### E1. Ogniwa dialogowe i ciągłość wejść/wyjść 09–18
Zaudytowano i potwierdzono pełną ciągłość przyczynowo-skutkową sekwencji przejść:
- **09 -> 10**: Wyjście ze stacji 09 (`private_boundary` para 1: „Zapytam Martę...”) zapowiada rozmowę przy stole w mieszkaniu 10 (`station_10.tscn` wita Martą wycierającą blat).
- **10 -> 11**: Wyjście ze stacji 10 (beat L3 `s10_exit_ucp_record`: „zapis sprawdzę w UCP”) zapowiada wizytę w UCP 11 (`station_11.tscn` wita ladą i urzędniczką Wierzbicką).
- **11 -> 12**: Wyjście ze stacji 11 (`minimal_report` para 3: „kontakt do warsztatu”) zapowiada łącznik warsztatowy w stacji 12 (`station_12.tscn` diegetyczny szyld łącza warsztatowego).
- **12 -> 13**: Wyjście ze stacji 12 (beat L3 `s12_exit_home_table`: „Wracam do mieszkania, do wspólnego stołu”) zapowiada powrót do 13 (`station_13.tscn` wita znanym stołem i filiżankami odsuniętymi przez Martę).
- **13 -> 14**: Wyjście ze stacji 13 (beat L3 `s13_exit_service_hatch`: „Wyciąg wskazuje sekcję rozdzielni — zejdę włazem serwisowym”) zapowiada właz do rozdzielni 14 (`station_14.tscn` zdanie wejścia: „Zeszłam włazem serwisowym za klatką schodową”).
- **14 -> 15**: Wyjście ze stacji 14 (beat L3 `s14_exit_loop_echo`: „Z mostu do pętli — wyciąg mówi, gdzie szukać echa”) zapowiada zejście do pętli 15 (`station_15.tscn` zdanie wejścia: „Schodzę do pętli sprawdzić, czyje to echo”).
- **15 -> 16**: Wyjście ze stacji 15 (beat L3 `s15_exit_analyzer_unbound`: „Niosę odpowiedź do analizatora poza obwodem”) zapowiada stację 16 (`station_16.tscn` potwierdza wejście do pomieszczenia analizatora).
- **16 -> 17**: Wyjście ze stacji 16 (beat L3 `s16_exit_ucp_pairs`: „sprawdzę rejestr par w hali UCP”) zapowiada stację 17 (`station_17.tscn` wejście: „Idę do rejestru par w hali UCP”).
- **17 -> 18**: Wyjście ze stacji 17 (beat L3 `s17_exit_street_options`: „Wracam na ulicę — trzy drogi, Marta”) zapowiada powrót na ulicę 18 (`station_18.tscn` wejście: „Wracam na znaną ulicę. Trzy drogi na tablicy, Marta przy oknie”).

Dodatkowo sprawdzono wszystkie linie dialogowe w `scripts/levels/creative_scene_lines.gd` — żadna kwestia nie przekracza limitu 115 znaków CRT (ochrona okna dialogowego 488x52).

### E2. Trzy sekundy — tajemnica nie wykładana wprost
- W stacji 15 diegetyczny dopisek ołówkiem na marginesie: `przepraszam M. — 3 s.` pozostaje na swoim miejscu.
- Dialogi w `scripts/levels/creative_scene_lines.gd` ani skrypty stacji nie dodają dydaktycznych wyjaśnień (np. „te same trzy sekundy co na stanowisku”, „Aha, to te same”). Zbieżność czasowa pozostaje do samodzielnego powiązania przez gracza.

### E3. Rezerwy `DIALOGUE_LINES` w 42A, 42B, 42C
- Zaktualizowano docstringi `DIALOGUE_LINES` w `scripts/levels/station_42a.gd`, `scripts/levels/station_42b.gd` oraz `scripts/levels/station_42c.gd`.
- Precyzyjnie wyjaśniono rolę 4-elementowych tablic (pin PKG-0107):
  1. Tablice te stanowią edytorski i bezstanowy fallback w razie uruchomienia sceny w izolacji bez `CreativeScenePresentation`.
  2. W faktycznej trasie kampanii kwestie są podawane dynamicznie przez `CreativeScenePresentation` z `scripts/levels/creative_scene_lines.gd` na podstawie stanu prawdy (`truth_state`) i historii wyborów gracza.
  3. Wyczyszczono pozostałości odwołań do wiaty w komentarzach stacji 42B.
  4. W 42C potwierdzono rolę głosu jako `JAKUB (ECHO)`.

### Rozwiązanie dyskrepancji bazowej w Station 43
- W `scripts/levels/station_43.gd` linia 1 w `DEFAULT_DIALOGUE_LINES` została sformułowana tak, by spełniać jednocześnie kontrakt PKG-0230 (słowa kluczowe `Linia 4` i `odbudowano`) oraz kontrakt PKG-0237 (brak frazy `dwie kolejności`, długość <= 115 znaków):
  `"Rozkład na wiacie: Linia 4 zamknięta do odwołania, odcinek odbudowano. Żadne przejście nie zostało zatwierdzone."` (107 znaków).

## Weryfikacja

Nowa dedykowana bramka `tests/pkg_0238_dialogue_bridges_test.gd`:
1. E1: Weryfikacja ogniw dialogowych (Równia w 17, oddech/klucz/brak wiaty w 42B, Jakub echo/kubek/półka w 42C);
2. E1: Weryfikacja ciągłości przyczynowej wejść i wyjść na odcinku 09–18 (9 par zapowiedź-potwierdzenie);
3. E2: Weryfikacja nie-dydaktyczności trzech sekund (obecność dopisku w 15, brak wykładania tożsamości w dialogach);
4. E3: Rezerwy `DIALOGUE_LINES` w 42A/B/C (dokładnie 4 linie, poprawność docstringów o fallbacku, brak wiaty w 42B, mówca `JAKUB (ECHO)` w 42C);
5. CRT: Limit długości linii (wszystkie kwestie w `CreativeLines.LINES` <= 115 znaków).

Wszystkie piny i bramki nadrzędne zachowane:
- `tests/pkg_0207_gate_census_test.gd`: 129 wywołań / 128 skryptów / 127 referencji / 127 plików na dysku;
- `tests/pkg_0107_smoke_test.gd`: PASS;
- `tests/pkg_0230_story_sense_repair_test.gd`: PASS;
- `tests/pkg_0234_ghost_props_test.gd`: PASS;
- `tests/pkg_0235_gap_verbs_test.gd`: PASS;
- `tests/pkg_0236_cuts_not_teleports_test.gd`: PASS;
- `tests/pkg_0237_earned_words_test.gd`: PASS;
- `tools/verify.ps1`: 136 sekcji PASS, exit code 0.
