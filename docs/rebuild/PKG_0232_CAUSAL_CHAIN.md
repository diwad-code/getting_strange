# PKG-0232 — łańcuch przyczynowy: Pakiet A + D1/D3/D4 planu PKG-0231

Data: 2026-09-14
Decyzja: D-244 (wpis w `docs/DECISION_LOG.md`)
Zakres: pierwszy mega-pakiet z `docs/rebuild/PKG_0231_STORY_SENSE_REPAIR_PLAN.md`
(Pakiet A + D1 + D3 + D4). Freeze D-241 zdjęty wyłącznie dla napraw PKG-0231
(D-243); GATE-REL i release nadal BLOCKED BY D-168.
Status: **WDROŻONE, pełna `verify.ps1` PASS (130 sekcji)**.

Werdykt produktowy: nadal **STORY-SENSE CONCERNS / PRODUCT GO zablokowane** —
pakiet domyka przyczynowość punktów nieodwracalnych, nie cały sens (most
13→14, rekwizyty B, fokalizacja 42B i wypłata D2/D5 należą do następnego
mega-pakietu B/C/D2/D5).

## 1. Polityka faktów (A1)

- `REQUIRED_FOR_NEXT_SCENE` — łańcuch nieodwracalny: donor 17 → commit 18 →
  finał → wykonanie → stan → skutek 42 → tablica → pełny dialog → napisy →
  ostatnia czynność → blackout 43. Wymuszany mechanicznie strażnikami (niżej).
- `OPTIONAL_WITH_GAP` — wszystkie luki liniowe 01–18 (katalog GapLedger,
  bramka 0215). Pominięcie legalne; idempotentne domknięcia bez zmian.
- `LOCAL_FLAVOUR` — reszta; bez wpływu na późniejszą wiedzę.

Kampania nie jest blokowana mechanicznie na stacjach liniowych (progi otwarte
od wejścia, D-227 stoi). Blokowane są wyłącznie przejścia nieodwracalne.

## 2. Rozdzielenie writerów od nawigacji (A, S-07)

`GameStateManager.complete_station`: `_handled_completions` rozlicza writerów
dokładnie raz; ponowne przekroczenie progu nawiguje (`_repeat_navigate`)
bez dopisywania faktów — `N→N+1→N→N+1` działa na każdej krawędzi. Bezpośrednie
wywołania harnessów (stare bramki selektora) zachowują dotychczasowy routing,
w tym fallback 42A dla wywołań jawnych.

Świeże instancje po ReturnZone odtwarzają stan lokalny z decyzji (`_ready`):
18 — commit/metoda/prognozy/prawda; 42A/B/C — wykonanie/stan/skutek (+słownik);
43 — tablica i napisy (dialog czyta się od nowa, 5 linii przez ponowne lektury).

## 3. Station 18 — brak metody, brak finału (D1, S-04)

`_trigger_level_completion` odmawia bez `is_method_committed` (luka
`forecast_and_consent_inventory_required` albo `jakub_consent_missing` —
oba w FEEDBACK_TO_GAP, bramka 0215 zielona) i nie emituje `level_completed`.
Normalna ścieżka progowa nie routuje do 42A. Jawne wejścia
(`select_finale_operation/method`, bezpośredni `complete_station` w harnessach)
bez zmian. Odmowa Jakuba nadal zamyka 3 drogi (D-242, pin 0230).

## 4. Station 42A/B/C — wykonanie → stan → skutek → próg 43 (D3, S-05)

- 42A: `read_sealed_other_lena` wymaga rygla (`return_execution_required`);
  `read_household_consequence` wymaga zapieczętowania (`sealed_state_required`).
- 42B: `read_local_lena_recovered` wymaga domknięcia (`flow_closure_required`);
  skutek wymaga odzyskania (`recovered_state_required`).
- 42C: `read_memory_leak` wymaga otwarcia (`passage_execution_required`);
  skutek wymaga przecieku (`leak_state_required`).
- `_trigger_level_completion` każdego wariantu wymaga pełnego łańcucha
  (lokalnie lub w decyzjach po powrocie), inaczej `finale_sequence_incomplete`
  + beat planu odczytu. Wyjścia wizualnie otwarte (D-227, piny 0214/0175 stoją);
  completion bez łańcucha nie istnieje.
- Reguła prezentacja-vs-fakty (realny FAIL 0195 w pakiecie): flaga lokalna +
  fakt w decyzjach = rozliczone (powtórka milczy); flaga pusta + fakt
  w decyzjach = odtworzenie bez zapisu (sygnały/beaty dla winiet i prezentera,
  zero `_record`). Dzięki temu świeża instancja po reloadzie gra winietę
  finałową raz (sygnał `household_consequence_read`), a ponowny akt na tej
  samej instancji nie powtarza winiety ani nie nadpisuje śladu. Restore
  w `_ready` odtwarza tylko stan ekspozycji (rysunek).

## 5. Station 43 — atomowy epilog (D4, S-06)

Kolejność: tablica (2 beaty dialogu) → napisy (2 beaty) → ostatnia czynność
(5. linia) → blackout. `inspect_blackout` i `_complete_campaign` (ścieżka
progu przez ThresholdBinder) wymagają tablicy + napisów + `dialogue_index ≥ 4`;
przed wymaganiami odmawiają (`epilogue_sequence_incomplete`) i NIC nie
zapisują — kampania nie kończy się przed ostatnią czynnością. Ponowne lektury
przesuwają dialog, więc powrót do 43 nie jest ślepą uliczką.

## 6. Chronologia 14 (S-02, twarda sprzeczność)

Otwarcie 14 nie zna już zewnętrznego przerwania (odkrywa je 15):
„Wyciąg mówi: o 20:40 próba równoległa, obcy numer czytnika. […]".
Znacznik „20:40" zachowany (pin 0230). Beat wyjścia 13 (`s13_exit_to_switchyard`)
i pełny most 13→14 świadomie odroczone do następnego pakietu content/staging
(zakres promptu PKG-0232).

## 7. Kontrolowane aktualizacje testów (wzór D-216/D-218)

Realne FAIL-e po zmianie kontraktu, naprawione w pakiecie:
- `pkg_0167/0168/0169` (`_test_incomplete_attempt_keeps_exit`): niepełna próba
  (sam rygiel/zamknięcie/otwarcie) NIE domyka progu (`finale_sequence_incomplete`);
  pełny łańcuch domyka. Wyjścia nadal otwarte.
- `pkg_0175` (bieg minimalny): zero odczytów OPTIONAL + wszystkie czasowniki
  REQUIRED na żywo (seed kwateru donora 17 jako proxy wymaganych odczytów 17,
  wzór `_seed_18_entry` z PKG-0230; łańcuchy 18/42/43 czasownikami).
- `pkg_0177` (M1): nogi 14–17 czasownikami na żywych instancjach (te same
  funkcje co rekwizyty; timing fali i pozycje boczne poza zasięgiem ślepego
  sweepu); noga 18 z dwustopniowym commitem przy dostępnej metodzie
  (adaptacja `_finale_id` do zakresu zgody); nogi 42 łańcuchem przez rekwizyty;
  noga 43 sekwencją tablica → napisy → blackout z flushem CRT.
- `pkg_0137` (framing): warunek 43 to odtąd tablica + napisy + ostatnia linia
  (`dialogue_index` na koniec; przełącznik booli `_satisfy_story_gates` nie
  stawia licznika int).
- `pkg_0166` (prognozy): scena z odmową NIE domyka progu w przód (D1);
  powrót do 17 otwarty, finał niewybrany.
- `pkg_0195` (CR-C): brak zmian w teście — kod 42 gra prezentację na świeżej
  instancji bez ponownego zapisu (reguła wyżej); winieta raz, reread bez
  replayu i bez nadpisania śladu.
- `pkg_0207`: pin 122/121/120 → 123/122/121/121 + nowa bramka w `verify.ps1`
  (130. sekcja).

Twarde fakty z naprawy M1 (dowody, nie deklaracje): fizyczny sweep nie wykonywał
mechanik 14–17 (timing 7 s, kolejności, pozycje boczne) — stary „100% SUKCES"
pokonywał progi, nie łańcuchy; commit słupka wymaga snapa (±40 px przy kroku
fizyki ~4 px); pressy giną w kontencji z prezentacją wejścia (flush przed
każdym pressem); przybycie 17→18 jest z prawej (marsz w lewo do tablicy);
`String(null)` na brakującym `last_feedback` abortuje nogę (14 nie ma tego pola).

## 8. Nowa bramka `pkg_0232_causal_chain_test.gd`

Fail-closed, 8 kryteriów z promptu: zero-interaction nie fabrykuje wiedzy;
18 bez metody nie osiąga 42 (ścieżka progowa); refused blokuje 3 drogi;
42A/B/C odrzucają krok 2 przed 1 i 3 przed 2 (z nazwanymi lukami); 43 odrzuca
golasowy blackout (funkcja i próg); 5 linii osiągalnych; macierz
przód→powrót→przód na prawdziwych tranzycjach (10→11, 17→18, 18→42A, 42A→43,
z odtworzeniem stanu po powrocie bez ponownych commitów); save/reload trzyma
`method → finale → executed → ending_family` (32 asercje, PASS).

## 9. Weryfikacja i ograniczenia

- Pełna `tools/verify.ps1` PASS, exit 0 (130 sekcji: DOCS 52 + import + smoke
  01–43 + bramki 0001–0232; dowód `reports/pkg_0232_verify_full.log`).
- Licznik D-217 ZRESETOWANY (ostatnia pełna PKG-0232; shared-touch).
- Kadry: brak zmian obrazu (zero edycji `_draw`/scenografii); zmiana tscn 14 to
  jedna linia tekstu cue (nie wymaga recertyfikacji obrazu).
- Automat dowodzi stanu i kolejności, nie emocji ani zrozumienia (D-012).
- Otwarte (następny mega-pakiet B/C/D2/D5): most 13→14 i beat wyjścia 13;
  pochodzenie zaświadczenia m.12; status czytnika po UCP; fokalizacja 42B;
  migawka decyzji D2; wypłata kosztu/prawdy/zgody D5.
- Rozjazd baseline: pełna sprzed pakietu FAILowała wyłącznie w 0208
  (`NEXT_SESSION_PROMPT must name expected PKG-0209`) — dryf dokumentacyjny
  PKG-0231 (docs-only), nie regresja runtime; odnotowany w SESSION_LOG przed
  edycjami, naprawiony handoffem (poniżej).
