# Aktualny stan projektu

Stan na: 2026-09-05, PKG-0193 / CR-A: dwie biografie i spotkanie z bratem.
CR-A ZAMKNIĘTY TECHNICZNIE: pełny verifier exit 0, 97 bramek, Verification passed.

## Aktywna faza

P9: Product Rescue & Hybrid Rebuild. PHASE-01..10 zachowują wcześniejsze
zamknięcia techniczne (ostatnia recertyfikacja PKG-0184). Nie jest to PRODUCT GO.
GATE-REL, release i nowe .exe pozostają BLOCKED BY D-168.
Godot 4.7.2 / Windows, 640×360, 60 Hz; projekt bez Gita, wyłącznie gra Godot.

Aktywna specyfikacja:
`docs/rebuild/CREATIVE_REVIEW_AND_EXPANSION_PLAN.md` §8.
Na bezpośrednie zlecenie właściciela CR-A zastąpił sugerowany pilot MRP.
Kolejność kolejnych sesji: CR-B → CR-C → CR-D.

### Wynik PKG-0193

- 15 dotychczasowych punktów 09–13 dostarcza rozmowy i odczyty przez lokalny
  `creative_scene_presentation.gd` oraz `creative_scene_lines.gd`.
  Writerzy, flagi, sygnał syntezy i negatywne warunki PKG-0191 pozostają.
- 10: pomylony kubek, dwie wersje deszczu/kurtki/parkingu, telefon i granica Marty.
  11: biometria, 186 dni oraz dwa odrębne rejestry Jakuba, wyciąg 20:40.
  12: dwa pytania przez łącze, spotkanie przy naprawie napędu, odmowa blizny
  i dobrowolne sprawdzenie numeru czytnika.
- 13: własny dokument/czytnik niezależnie od próbki; próbka w tekście i obrazie
  wyłącznie gdy `home_sample_preserved=true`. Nieobecny raport jest nazwany
  nieobecnym. Po niemej winiecie: rozpoznanie, pytanie Marty i zamiar poszukiwań.
  Semantic skip nie pomija tej rozmowy. Reload pozwala ponownie odczytać
  rozwiązane punkty bez replay winiety i nowych faktów.
- Jeden lokalny właściciel pilnuje otwarcia/CRT/winiety oraz izoluje advance od
  interakcji MRP. Rigi Marty i Jakuba reagują na rozmowy; Marta jest też w 13.
  Stół, sofa, lampa i filiżanki mają lokalną kompozycję; fizyka bez zmian.
- Guidance i GapLedger 09–13 opisują aktualne punkty i sprawdzają fakty P9.
  ID istniejących luk pozostają dla zgodności zapisu.
- 07/08: Sadowa 7, lokale 12/14, Marta Kurek. PKG-0158 chroni teraz wspólny
  budynek i przypisanie obu lokali; nie osłabiono budżetu ani źródeł.
- Raport, mapa punkt → treść → writer i ograniczenia:
  `docs/rebuild/PKG_0193_CREATIVE_SCENES.md`.
  Zaktualizowane cztery dokumenty narracji, mapa kampanii, obsada, D-210 i roadmapa.

### Zachowane wcześniejsze wyniki

PKG-0190: pięć slotów cinematic vignettes z rodziną A/B/C, katalog,
skip i reduced motion. PKG-0191: 12 writerów 10–13 plus istniejący writer
`marta_relationship_disclosed` w 08; naprawione kasowanie kanonicznych faktów
przez migrację save (D-208). PKG-0192: callable bookkeeping 10–13 pod
`p9.threshold_obstacle.*`, decyzje pozostawienia komody/balkonu/szuflady,
idempotentna migracja. F-0184-012 zamknięte technicznie.
PKG-0186/0187: obsada i wcześniejszy audyt 106 kadrów; raporty historyczne
pozostają dowodem tamtej wersji, nie nowej oceny odbioru.

## Ostatnia swieza weryfikacja

- Lokalny `pkg_0191_canonical_fact_test.gd`: PASS, exit 0.
- Nowy `pkg_0193_creative_scene_test.gd`: PASS headless i normalny Windows
  OpenGL / Intel Iris Xe. Rzeczywisty InputEventAction → MRP → CRT line_started,
  izolacja advance, obie próbki, brak źródeł, save/reload, dwie faktycznie
  wyświetlone winiety i semantic skip, reduced motion, 85/100/115%, zamknięcie luk.
- Capture: 267 PNG w `reports/pkg_0193/visual_final/`, indeks `frames.tsv`.
  Bezpośrednio obejrzano reprezentatywne kadry wszystkich 09–13, odmowę,
  pytanie Marty, oba warianty próbki, winiety i trzy rozmiary tekstu.
  Wysokość treści każdego wyświetlonego dialogu sprawdzona automatycznie.
- Pierwszy pełny verifier trwał podczas edycji i zakończył się RED na starym
  adresowym kontrakcie 0158. Nie jest czystym baseline PKG-0192.
  Konflikt został jawnie poprawiony zgodnie z CR-D04 / D-210.
- Końcowy pełny verifier run3: exit 0, 97 bramek, `Verification passed.`;
  nowa bramka 0193 wraz z całym istniejącym łańcuchem GREEN. Brak ERROR,
  SCRIPT ERROR i wycieków; siedem dozwolonych warningów negatywnych prób
  malformed save / unsupported settings. `verify_docs.ps1`: DOCS PASS, 52 pliki.
- Run2 przeszedł M1/14 bramek i wykrył trzy stare asercje otwarć PKG-0184,
  opisujące dormant P7. Poprawiono je na aktywne źródła 11–13, dodając zakaz
  starych wskazówek i wymaganie dziewięciu ID punktów. Samodzielnie ponownie
  PASS: 0184, 0186, 0187, 0190, 0191, 0192, 0193 z fail-closed log policy.
  Końcowy pełny przebieg: reports/pkg_0193_final_verify_run3.log.

Zamrożenie pakietu: `snapshots/PKG-0193-2026-09-05`, przez wymagany
`tools/snapshot.ps1 -Package PKG-0193`; do zakresu scenes/scripts/tests
dołączana jest dokumentacja i narzędzia bieżącego zamknięcia. Reports i .godot
pozostają wyjściem roboczym, a snapshot nie jest źródłem bieżącego stanu.

## Czego jeszcze nie potwierdzono

- Fun, emocja, uroda, zrozumienie: OPEN-NO-EVIDENCE. Zero zewnętrznych testerów.
- CR-B, CR-C, CR-D nie zostały wykonane. W szczególności rozkład/adres w 06,
  gałąź próbki w 05, koszt i zgody 14–18, finały i dług Szymona czekają na
  odpowiednie pakiety. Nie traktować CR-A jako wykonania całego planu.
- Portret Marty zachowuje jedną ekspresję; dalsza inscenizacja 11/17 i globalna
  spójność ilustracji należą do kolejnych wycinków. Nie generowano nowych assetów.
- Nowy harness wybiera flagę zasięgu MRP: dowodzi wejścia i dostarczenia treści,
  nie samodzielnego dojścia do wszystkich punktów. Nie mierzono czasu gracza.
- F-0184-010: MRP pozostaje monolitem, pilot 67–196 jest oddzielnym zadaniem.
- AMD/NVIDIA/Steam Deck i natywny Linux poza WSL bez nowych dowodów.

## Nastepny pakiet

CR-B — odpowiedź, koszt i cudza zgoda, stacje 14–18. Przydzielić kolejny wolny
PKG po sprawdzeniu SESSION_LOG; spodziewany PKG-0194. Ustanowiony konkret
CR-A: kurtka na kaloryferze w wersji miejscowej Marty, parking w wersji przybyłej.
Przed logiem 15 uzgodnić przyczynowość leave_on_time: kontakt przy pierwszym
obowiązkowym pomiarze, opcjonalna powtórka tylko próbka i opóźnienie.
Pełny samodzielny handoff: `docs/NEXT_SESSION_PROMPT.md`.
