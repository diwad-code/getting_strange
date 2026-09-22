# PKG-0196 / CR-D — Raport: rytm początku i spójność obrazu (stacje 01–08)

Data: 2026-09-05. Pakiet wykonawczy CR-D z
`docs/rebuild/CREATIVE_REVIEW_AND_EXPANSION_PLAN.md` §7 (ostatni wycinek
kolejki CR-A → CR-B → CR-C → **CR-D**, kontrakt §8.1). Nie jest PRODUCT GO
ani decyzją wydawniczą (D-168 blokuje release i nowy `.exe`).

## Co dostarczono (rytm, nie fakty)

Trasa i fizyka bez zmian: 20 adresów, progi, InputMap, 60 Hz, 640×360, zero
nowych colliderów, ≤3 istotne interakcje na adres. Nowi writerzy faktów nie
powstali; wszystkie zapisy robią dotychczasowe czasowniki stacji. Plastyka
rodzin i powrotów (druga połowa CR-D) sprowadzona do jednej nazwanej korekty
obrazu; układy domu 09/10/13/42 i geometria pozostają po CR-A/CR-B bez zmian.

- **01:** bez zmian treści. Rozwidlenie `repeat_sample / leave_on_time`
  i dwa stany torby zachowane; to kotwica obu gałęzi.
- **02:** drugie nazwanie dwunastu minut zastąpione gestem
  (`Marta poczeka dłużej, niż obiecałam. Idę nasypem.`). Czas podaje raz
  znak robót i poprzedni odczyt. Fakty i sygnały bez zmian.
- **03:** prośba Marty z 01 nie wraca. Gałąź powtórki: domowy konkret
  (`Herbata stygnie. Napisz, kiedy wsiądziesz.`) i odpowiedź bez trzeciego
  liczenia opóźnienia (`Jadę. Przez objazd będę później.`). Gałąź wyjścia
  na czas bez zmian (obietnica dotrzymana). Fakty (`marta_promise_broken`,
  `marta_knows_delay`) i routing bez zmian.
- **04:** odłożenie czytnika (bufor) oddzielone od fizycznej próbki, osobno
  dla każdej gałęzi z 01: powtórka (`Odwracam czytnik ekranem do dołu.
  Próbka jedzie w torbie.`), wyjście na czas (`…Tyle z pracy na dziś.`).
  Gałąź wyjścia nie wymyśla drugiego pomiaru. Pomnik i odwrócenie ekranu
  przerywają rytm wagonu; linia pomnika bez zmian.
- **04 (obraz):** plakat autora `MARTA // CZEKA W DOMU` zdjęty ze ściany
  wagonu (E-tabela §6.2: wiadomość mieszka w urządzeniu). Węzeł niesie
  teraz napis wagonowy `LINIA 4 // DRZWI Z PRAWEJ` (nazwa węzła
  `CrispDiegeticText_CarriageDoors`). Żaden test nie asertował starego
  napisu ani nazwy; colliderów i pozycji nie ruszono.
- **05 (E02, realny rozjazd gałęzi):** kwestia torby mówi prawdę gałęzi —
  powtórka zachowuje dotychczasową linię o surowej próbce, wyjście na czas
  mówi o spakowanym czytniku (`W torbie spakowany czytnik. Surowego zapisu
  nie wzięłam — tak wybrałam.`). Trzy punkty i fakty bez zmian.
- **06:** rozkład daje konkretny konflikt trasy i daty bez adresu
  (`Linia 4 jedzie inaczej, niż pamiętam — a data druku się zgadza.`).
  Sprzedawca: zakup Marty, imię i własny zamiar zamknięcia kiosku
  (`Marta rano kupiła wodę…` / `Zwijam kiosk po tej zmianie…`); adres
  i wspólne zamieszkanie zostają źródłom 07/08. Diegetyczny węzeł rozkładu
  (`ROZKŁAD JAZDY // LINIA 4: SADOWA 14`, asercja 0158) nietknięty.
  Fakty (`unease_pattern_started`, `vendor_testimony_recorded`) bez zmian.
- **07:** bez zmian (CR-D04 z CR-A: Sadowa 7, lokale 12/14, Kurek).
- **08:** sąsiadka odpowiada na wprost zadane pytanie kontrolne
  (`Kto mieszka pod dwunastką?` → `Pan Kowalczyk, od lat. A pani z Martą
  pod czternastką…`); po kluczu cisza zamiast opisu zapadki
  (`Klucz działa. Wchodzę bez słowa.`). Fakty (`neighbour_answer`,
  `marta_relationship_disclosed`, `cautious_entry_committed`) bez zmian.
- **Kanon:** `FULL_STORY.md` 01 mówi teraz gałęziami (powtórka zabezpiecza
  próbkę / wyjście pakuje czytnik bez próbki; kontakt nawiązuje pierwszy
  obowiązkowy odczyt na obu gałęziach — CR-D §2). Nagłówek
  przyczynowości dopisany przy CR-B (D-211) pozostaje w mocy; 15/16 nie
  wymagały zmian (log odnosi się do tego samego odczytu, nośnik bez
  próbki to bufor — linie `loop_logbook` i `cost_selector_sample_buffer`
  z CR-B).

## Zmiany kodu

- `scripts/levels/station_02/03/04/05/06/08.gd` — wyłącznie treść `_present()`
  (powyżej) oraz w 04/05 rozgałęzienie tekstu po `opening_choice`
  (`_decision_string`, wzór stacji 02–04; 05 dostał ten sam pomocnik).
  Writery, flagi, sygnały, dostępność punktów, guidance i `_draw()` bez zmian.
- `scenes/levels/station_04.tscn` — wyłącznie tekst i nazwa jednego węzła
  napisu diegetycznego (powyżej). Geometria, collidery, progi bez zmian.
- `docs/narrative/FULL_STORY.md` — wyłącznie akapit `Zmiana` sekcji 01
  (gałęzie + kontakt z pierwszego odczytu). Reszta kanonu już opisywała
  te stany; synchronizacja bez nowych faktów.
- `tests/pkg_0196_opening_rhythm_test.gd` — nowa bramka + wpis w
  `tools/verify.ps1`. Realny input (`interact` na `OpeningActionPoint`)
  → writer → kolejka CRT (nie same wołania metod); obie gałęzie otwarcia
  na pełnej trasie 01–08; kolejność nazwanie-raz-potem-gest; braki
  przesłanek informacyjne bez faktów; save/reload w połowie trasy;
  reread bez nowych faktów; skale 85/100/115% z kontrolą wysokości tekstu.
- W trakcie pakietu twardo wykryto po raz drugi wzorzec D-211:
  `bool(String)` nie istnieje w Godot 4.7 — błąd kompilacji w pierwszej
  wersji bramki; asercja przepisana na `String().is_empty()` (ten sam
  jawny wzorzec co `_truthy()` i `Station14._decision_bool`).

## Weryfikacja

- Baseline przed edycjami: `verify_docs.ps1` DOCS PASS (52 pliki);
  `pkg_0157` / `pkg_0158` / `pkg_0159` PASS headless (dysk GREEN przed zmianą).
- Nowa bramka PASS headless i normalnym sterownikiem Windows OpenGL /
  Intel Iris Xe (ten sam proces, flaga `--capture`).
- Capture: 97 PNG w `reports/pkg_0196/visual_final/`, indeks `frames.tsv`.
  Bezpośrednio obejrzano: pytanie o dwunastkę i odpowiedź sąsiadki w 08
  (115%), wariant torby bez próbki w 05, kwestie 02/03/04/06 w obu
  gałęziach. Wysokość treści każdego wyświetlonego dialogu sprawdzona
  automatycznie we wszystkich skalach.
- Wiążący końcowy pełny verifier: `reports/pkg_0196_final_verify.log`
  (uruchomiony po wszystkich edycjach; wynik dopisany do SESSION_LOG
  po zakończeniu tła).

## Czego pakiet nie dowodzi i nie zmienia

- Testy dowodzą kontraktów i dostarczenia treści, nie odbioru ani PRODUCT GO.
- Rytm 01–08 mierzony kolejnością i brakiem powtórzeń, nie czasem lektury
  człowieka. Układ domu 09/10/13/42, portrety i globalna plastyka rodzin
  poza jedną korektą plakatu — materiał kolejnych wycinków, nie tego pakietu.
- F-0184-010 (MRP renderer pilot) pozostaje osobnym zadaniem.
- AMD/NVIDIA/Steam Deck i natywny Linux poza WSL bez nowych dowodów.

## Znalezisko porządkowe

`SESSION_LOG.md` nie zawierał wpisu PKG-0195 mimo zamknięcia CR-C
(CURRENT_STATE, snapshot `PKG-0195-2026-09-05` i raport istnieją). Wpis
uzupełniono w tym pakiecie na podstawie zamrożonego stanu (sekcja
uzupełniająca przed wpisem PKG-0196); nie jest to zmiana wyniku CR-C.
