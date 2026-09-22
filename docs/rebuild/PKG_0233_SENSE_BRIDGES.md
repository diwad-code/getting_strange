# PKG-0233 — mosty sensu: Pakiet B + C/D2/D5 planu PKG-0231

Data: 2026-09-14
Decyzja: D-245 (wpis w `docs/DECISION_LOG.md`)
Zakres: drugi mega-pakiet z `docs/rebuild/PKG_0231_STORY_SENSE_REPAIR_PLAN.md`
(Pakiet B + C + D2 + D5). Freeze D-241 zdjęty wyłącznie dla napraw PKG-0231
(D-243); GATE-REL i release nadal BLOCKED BY D-168.
Status: **WDROŻONE, pełna `verify.ps1` PASS (131 sekcji)**.

Werdykt produktowy: nadal **STORY-SENSE CONCERNS / PRODUCT GO zablokowane** —
pakiet domyka chronologię rekwizytów, mosty filmowe, migawkę decyzji i wypłatę
stanów. Otwarty zostaje wyłącznie claim-side liniowy 17/18 (R-053 częściowo:
warianty istnieją jako głos luki + niepoliczone prognozy, bez osobnych linii
wejścia) oraz inspekcja obrazu na displayu oraz decyzja właściciela.

## 1. Pakiet B — chronologia i rekwizyty

- **B1 (S-03):** myśl wyjściowa 10 to hipoteza: „Marta twierdzi, że pracuję
  w UCP. Sprawdzę zapis, zanim uznam to za moje." (beat `s10_exit_ucp_record`,
  samo id nietknięte — pin 0230 stoi). Biometryka w 11 potwierdza lokalny
  profil jako pierwsza.
- **B2 (S-08):** zaświadczenie m. 12 ma materialne źródło: pakowanie sprzętu
  w 01 (obie drogi: `secure_raw_sample` i `pack_equipment_for_marta`)
  zapisuje `p9.opening.field_certificate_packed = sadowa_7_m12`, gra beat
  `s01_field_certificate` i rysuje dokument w torbie. 07 wyjmuje ten sam
  dokument (tekst istniejący), 13 kładzie go na stole (tekst istniejący).
  Bez nowej stacji i pobocznego questu.
- **B3 (S-09):** opieka nad czytnikiem rozstrzygnięta wariantem preferowanym
  z planu: Wierzbicka wydaje **warunkowe pokwitowanie minimalnego zakresu**
  (`p9.mystery.institution.reader_custody_receipt`, ten sam akt co wyciąg —
  zero nowych werbów i par dialogowych), widoczne jako beat
  `s11_reader_receipt` i kwit na ladzie. 12 pamięta status (beat
  `s12_reader_receipt` przy pierwszym pytaniu + czytnik z kwitem na stole
  warsztatowym), 13 pamięta (kwit przy wyłożonym źródle). UCP zostaje
  racjonalną instytucją; nie ma kradzieży ani milczącego wyniesienia.
- **B4 (S-13):** synteza ma jeden fizyczny korelat bez wykładu: czytnik
  terenowy i wyciąg UCP noszą **tę samą niemożliwą lukę** (dwa identyczne
  wycięcia + linia powiązania w `_draw`, beat `s13_device_correlate` przy
  domknięciu drugiego źródła, niezależnie od kolejności). Kanoniczna linia
  „To nie jest mój świat." nietknięta (pin 0217 stoi); korelat wynika ze
  współobecności obu źródeł wymaganych bramką syntezy — zero nowych werbów
  i faktów.

## 2. Pakiet C — geografia i filmowe styki

- **C1 (13→14):** beat wyjścia 13 przepisany: wyjście z mieszkania + wyciąg
  wskazuje sekcję rozdzielni + zejście włazem serwisowym; usunięte
  przedwczesne „ktoś przerwał z zewnątrz" (druga połowa S-02 — o przerwaniu
  mówi dopiero dziennik pętli w 15). Wejście 14 trzyma trop „20:40" (pin
  0230) i dokłada drugą linię cue: „Zeszłam włazem serwisowym za klatką
  schodową." Geometria progu już była HATCH (Binder, MAPA) — brakowało
  tylko czynności w fikcji. Bez nowego adresu i bez arcade.
- **C2 (18→42):** zatwierdzenie przy słupku jest wspominane po imieniu po
  drugiej stronie cięcia: drugie linie cue 42A/B/C („W nocy przy słupku
  … O świcie …"), z nazwaną wykonaną metodą. Świt był narysowany; teraz
  jest też wypowiedziany. Perspektywa: wszystkie trzy linie mówią, że
  sterowana postać to przybyła Lena.
- **C3 (42B):** fokalizacja jawna wariantem preferowanym z planu: „O świcie
  jestem przybyłą Leną, stoję w progu." Gracz zostaje przy przybyłej Lenie;
  mieszkanie miejscowej jest przestrzenią obserwowaną z progu, nie
  zamieszkaną. Bez przełączania kontroli i bez udawania ciągłej przestrzeni.

## 3. D2 — migawka decyzji

`Station18._commit_method` zapisuje **jednym zapisem** słownik
`p9.method_commitment.snapshot`: metoda, prawda Marty, zakres zgody Jakuba,
mały koszt z 16, dowody (próbka/sygnał/rejestr/liczba policzonych prognoz)
i wybrany finał. Klucz inline (nie `const FACT_`), więc pin 0226
(14/15/16/16) stoi bez zmian.

Zmiana metody po powrocie jest **niemożliwa** (druga opcja z planu):
strażnik snapshot-lock (`method_snapshot_locked`) i strażnik wykonania
(`finale_execution_started`, dowolny `p9.finale.*.executed`) odmawiają
bez zapisu. Oba feedbacki dopisane do `NON_GAP_FEEDBACKS` (terminalne
odmowy commita — bramka 0215 fail-closed zielona). Jawne wejścia
testowe/selektora bez zmian (jak w PKG-0232).

## 4. D5 — wypłata

Bez mnożenia zakończeń (trzy rodziny nietknięte):

- **42A/B/C:** słownik skutku niesie `"cost"` (wybór z 16: `marta_memory` /
  `sample_second` / `""` = jawna luka; JSON-safe; bramka 0195 czyta tylko
  klucze marta/jakub — zero churnu) oraz znaczki na blacie stołu obok
  pierścienia prawdy: zatrzask zgody (podwójny/poczwórny/X/kropki)
  i wycięcie kosztu (trójkąt/kwadrat/brak). Kształty, nie sam kolor.
- **43:** linia indeksu 2 każdej gałęzi jest komponowaną wypłatą
  (znacznik rodziny + prawda + zgoda + koszt, ≤ 115 znaków); indeksy 0/1/3
  pinuje 0170, rozmiar 5 pinuje 0232. Słupki tablicy/napisów i maszt
  sygnalizatora niosą te same trzy znaczki w obrazie.

## 5. Claim-side 17/18 (R-053, bez zmian kodu)

Warianty istnieją i są pokryte bramkami: 17 bez echa domu mówi głosem luki
`s16.cost_unmanifested` („Nie potwierdziłam echa domu."), 18 bez zakresu
pokazuje prognozy jako niepoliczone (`forecast_comparator_missing`:
„Trzy drogi, żadna niepoliczona."). Brak osobnych linii wejścia 17/18 dla
tych stanów — luka jest nazwana głosem i blokuje werb, nie osobnym
wariantem sceny. R-053 zostaje CZĘŚCIOWO z tego jednego powodu.

## 6. Kontrolowane stany sąsiadów

- Realny FAIL 0195 w pakiecie (reguła D-216): linia 43B[2] pinuje
  „drugie zgłoszenie" — znacznik rodziny 42B zmieniony na
  „Marta: drugie zgłoszenie." (bez zmian testu).
- Realny błąd wyłapany przed zielenią: `_decision_bool` na fakcie
  Stringowym (pokwitowanie) w `_draw` 13 dawał SCRIPT ERROR
  (String == bool) — zamieniony na `_has`. Pełna weryfikacja jest
  fail-closed na błędy, więc błąd nie przeszedłby niezauważony.
- Piny 0194/0207/0214/0215/0230/0232 stoją; 0207 zaktualizowany
  123/122/121/121 → 124/123/122/122 razem z nową bramką (D-222).

## 7. Weryfikacja i ograniczenia

- Nowa bramka `tests/pkg_0233_story_sense_bridges_test.gd` PASS (10 kryteriów
  promptu: B1/B2/B3/B4, C1/C2/C3, D2 ×5 podtestów, D5 macierz 54 łańcuchów
  42 + 144 linie epilogu, pin-compat).
- Pełna `tools/verify.ps1` PASS, exit 0 (131 sekcji; dowód
  `reports/pkg_0233_verify_full.log`); licznik D-217 ZRESETOWANY
  (shared-touch: 18/42/43 + GapLedger + progi).
- Sąsiedzi sprawdzeni pojedynczo przed pełną: 0193/0194/0195/0230/0232/
  0166-0169/0170/0175/0177/0107/0137/0142/0196/0217/0160/0207/0215/0226.
- Kadry: zmiany obrazu to małe znaczki (kwit, dokument, korelat, znaczki
  wypłaty) w istniejących scenach; brak świeżych kadrów displayem
  (sandbox bez displaya — jak w PKG-0228/0231/0232, klaryfikacja D-241).
- Automat dowodzi stanu i kolejności, nie emocji ani zrozumienia (D-012).
- R-053 CZĘŚCIOWO (claim-side 17/18); R-057 ZAMKNIĘTE (UCP-10,
  beat wyjścia 13, zaświadczenie, czytnik, korelat, mosty, fokalizacja,
  D2/D5 — bramka 0233 §1-9).
