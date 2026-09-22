# Getting Strange — Hybrid Rebuild Execution Plan

> **Dla kolejnego modelu:** wykonuj plan przez aktywny `NEXT_SESSION_PROMPT.md`, zgodnie z `docs/WORKFLOW.md`. Projekt nie ma Git ani worktree; zapisuj każdą zmianę natychmiast, kończ pełnym `tools/verify.ps1` i snapshotem pakietu.

Status: **ACCEPTED BOARD PLAN 1.0 — D-168 / PKG-0155**  
Data: 2026-08-31  
Ścieżka: `HYBRID_REBUILD`  
Greenlight: `GO WITH HARD PIVOT`

**Cel:** zachować sprawną technologię Godot 4.7, lecz ponownie zbudować produkt: opening, hierarchię informacji, rodziny lokacji, większość contentu i finał.

**Architektura:** zachowujemy shell, InputMap, fizykę, save/load, kamerę, Pixel-Stage compositor, crisp text, proceduralne audio i techniczne zachowania Anchor/Yield. Kampania docelowa ma 18 adresów liniowych, jeden z trzech technicznych wariantów 42A/B/C i Station 43 — łącznie 20 odwiedzanych adresów w jednym przebiegu. Stacje 19–41 przestają być obowiązkową trasą; są wyłącznie dawcami materiału do klasyfikacji `KEEP / ADAPT / RETIRE`.

**Tech stack:** Godot 4.7.2, GDScript, 640×360, fizyka 60 Hz, GL Compatibility, Windows/Linux, semantyczny InputMap.

---

## 1. Wiążąca diagnoza właściciela

Traktować jako fakty produktowe:

1. gracz nie wie, kim jest;
2. gracz nie wie, co ma robić;
3. gracz nie wie, po co ma to robić;
4. gracz nie rozumie zasad świata;
5. lokacje wyglądają zbyt podobnie;
6. rodziny przestrzeni są wizualnie nierozróżnialne;
7. gra nie komunikuje się poprawnie jako doświadczenie.

Zielone testy techniczne nie obalają tych faktów. Baseline PKG-0155: `tools/verify.ps1` PASS, exit 0, 1157,79 s; dowodzi wyłącznie kontraktów technicznych.

## 2. Decyzja zarządcza

- **Zachować:** Godot, InputMap, `PrototypePlayer`, Lena 4.1, shell, ustawienia, save/load, pauzę, lokalizację, `WorldPixelCompositor`, crisp text, kamerę, reduced motion, proceduralne audio, techniczny rdzeń Anchor/Yield, runner testów i export workflow.
- **Zaadaptować:** CRT dialogue, guidance, routing/save migration, fabularny rdzeń dwóch Len, Marty, Jakuba, Wierzbickiej i Linii 4.
- **Przepisać:** opening, tempo pierwszych 30 minut, dialog runtime, staging relacji, większość działań gracza.
- **Zbudować od zera:** rodziny zewnętrzne, tranzytowe, mieszkalne i finałowe oraz układy większości aktywnych lokacji.
- **Wycofać z roli kanonu runtime:** 43-adresowy obowiązek, jeden wspólny layout stacji, `vector_stage_environment.gd` jako autor wszystkich miejsc i `memory_resonance_point.gd` jako rosnący katalog wszystkich zachowań.
- **Zablokować:** release, nowe `.exe`, polerkę 43 starych scen i dalsze rozszerzanie wspólnych monolitów do czasu nowego produktowego greenlightu.

## 3. Docelowe doświadczenie

### Po 1 minucie

Gracz rozumie: „Jestem Leną Wolską, diagnostyczką drgań. Sprawdzam trzysekundową lukę przy Linii 4. Marta czeka, a dodatkowy pomiar znowu opóźnia mój powrót.”

### Po 5 minutach

Gracz zna podstawowe czasowniki, zawód Leny, konflikt próbka/obietnica i opuszcza wyraźnie techniczne miejsce pracy do wizualnie odmiennego miasta.

### Po 30 minutach

Gracz rozumie, że lokalny rozkład, kiosk, budynek i sąsiadka zgadzają się ze sobą przeciw pamięci Leny. Bieżące pytanie brzmi: „Czy problem dotyczy miasta, danych, mojej tożsamości czy pamięci?”

### Reguły informacji

- Przestrzeń mówi: gdzie jestem, dokąd idę, co działa i co się zmieniło.
- UI mówi: sterowanie, prompt, pauza, zapis i ustawienia.
- Dialog mówi: czego chce osoba, czego odmawia i jak reaguje na działanie.
- Guidance mówi wyłącznie: jaki test wykonać po realnym zastoju.
- Tekst nie może nadawać miejscu tożsamości, której nie ma w obrazie.

## 4. Docelowa trasa

| Zakres | Funkcja | Dominujące rodziny |
|---|---|---|
| 01 | worksite: zawód, próbka, obietnica | techniczna |
| 02 | realne obejście serwisowe | zewnętrzna |
| 03 | przystanek i wiadomość Marty | tranzytowa |
| 04 | przejazd i osobista cena pomiaru | tranzytowa |
| 05 | znana ulica jako baseline | miejska |
| 06 | kiosk i pierwsza publiczna rozbieżność | miejska/publiczna |
| 07 | fasada, domofon, numer 12/14 | miejska/mieszkalna |
| 08 | klatka, sąsiadka, działający klucz | mieszkalna wspólna |
| 09 | obca intymność mieszkania | mieszkalna prywatna |
| 10 | Marta i dwie prawdziwe relacje | mieszkalna/relacyjna |
| 11 | historia biometryczna UCP | instytucjonalna |
| 12 | Jakub jako żywa osoba i technik | publiczna/techniczna |
| 13 | jawna synteza pierwszej tajemnicy | robocza/relacyjna |
| 14 | martwy obwód uczy Anchor/Yield | techniczna |
| 15 | odpowiedź miejscowej Leny | techniczna/anomalna |
| 16 | mały koszt pamięci/adresu | anomalna |
| 17 | zgoda Jakuba i rachunek Linii 4 | relacyjna/instytucjonalna |
| 18 | jawne zobowiązanie do metody | znane miejsce po zmianie |
| 42A/B/C | trzy konkretne konsekwencje | finałowa, wariantowa |
| 43 | epilog osób, potem credits | epilogiczna |

## 5. Rodziny lokacji — kontrakt

| Rodzina | Musi być rozpoznawalna przez | Dominujące działanie | Zakazane powtórzenie |
|---|---|---|---|
| zewnętrzna/miejska | niebo, fasady, pogoda, nawierzchnia, publiczna głębia | orientacja i porównanie trasy | laboratoryjne proscenium |
| tranzytowa | wiata, tor/krawężnik, pojazd, rozkład, rytm odjazdu | oczekiwanie, wejście, wybór kierunku | rząd terminali |
| mieszkalna | niski sufit, tkaniny, naczynia, drzwi, ślady dwóch osób | ostrożne badanie i granica prywatności | instytucjonalne labele |
| instytucjonalna | szkło, kolejka, osie, identyfikacja i kontrola | autoryzacja, porównanie, odmowa | domowe ciepło jako dekoracja |
| techniczna/przemysłowa | maszyna o czytelnej funkcji, rury, ciepło, ruch roboczy | czytanie cyklu i fizyczna praca | konsola bez funkcji |
| graniczna/anomalna | dokładnie jeden złamany parametr znanej rodziny | Anchor/Yield i porównanie stanów | globalny glitch |
| finałowa/epilogiczna | znane miejsce i osoba po konsekwencji | odczyt skutku i ostatnia czynność | moralny kolor, manifest jako epilog |

## 6. Bramki produktu

1. **Gate 1 minute:** tożsamość, zawód, próbka, Marta i cena opóźnienia wynikają z runtime.
2. **Gate 5 minutes:** worksite, exterior i transit są rozpoznawalne bez labeli; cel powrotu pozostaje aktywny.
3. **Gate 30 minutes:** gracz zna pytanie śledcze, a 01–08 tworzy czytelną podróż przez co najmniej cztery rodziny.
4. **Gate family:** po ukryciu tekstu każda rodzina jest rozpoznawalna w monochromatycznym capture.
5. **Gate interaction:** maksymalnie trzy istotne interakcje w scenie; każda zmienia fakt, decyzję, relację albo koszt.
6. **Gate mechanic:** Anchor/Yield daje rozróżnialny skutek przed nazwaniem go tekstem.
7. **Gate finale:** każdy wariant opisuje się stanem osób, nie nazwą operacji.
8. **Gate release:** `TECHNICAL PASS` i `PRODUCT GO` są dwoma niezależnymi werdyktami.

## 7. Program faz

> **Aktualizacja 2026-09-02 (D-184).** Program miał sześć faz. Po sesji
> diagnostycznej właściciela dochodzą dwie: PHASE-07 (cutover, wydzielony z
> BUNDLE-25) i PHASE-08 (naprawa prezentacji i czytelności, BUNDLE-26..31).
> Specyfikacja nadrzędna PHASE-08: `docs/rebuild/PRESENTATION_REPAIR_PLAN.md`.

| Phase ID | Nazwa | Bundles | Exit criteria |
|---|---|---|---|
| PHASE-01 | Product Reset Lock | 01–05 | **WYKONANE (PKG-0156, CHECKPOINT-01: GO)** — jeden target, 20 adresów, siedem rodzin i acceptance matrix |
| PHASE-02 | First Five Minutes | 06–10 | **WYKONANE / RECERTIFIED (PKG-0159, CHECKPOINT-02: GO)** — pełny M1 01–04, dwie drogi openingu, GATE-01/GATE-05 |
| PHASE-03 | First Thirty Minutes | 11–15 | **WYKONANE / RECERTIFIED (PKG-0159, CHECKPOINT-03: PIVOT)** — GATE-30 PASS, ale GATE-FAM uczciwie 4/7 |
| PHASE-04 | Personal Mystery | 16–20 | **WYKONANE (PKG-0160/0161, CHECKPOINT-04: GO / 7 z 7 rodzin)** — kontrakt 09–13, trzy źródła syntezy i poprawiony, beztekstowy salon 09 przechodzą GATE-FAM |
| PHASE-05 | Mechanic and Cost | 21–23 | 14–17 uczą metody, kosztu i zgody bez softlocka |
| PHASE-06 | Consequence and Greenlight | 24 | **WYKONANE (PKG-0165..0170)** — 18→42A/B/C→43 zbudowane |
| PHASE-07 | Route Cutover | 25 | **AKTYWNA (PKG-0171)** — runtime prowadzi wyłącznie przez 20 adresów; tabela dowodowa ośmiu defektów |
| PHASE-08 | Presentation & Comprehension Repair | 26–31 | **OTWARTA (D-184, PKG-0172..0177)** — sześć nowych bramek PASS; osiem defektów właściciela zniknęło z runtime |

## 8. Bundle backlog

### BUNDLE-01 — Freeze the false RC

- **Cel:** zastąpić status release statusem technical donor / product rebuild.
- **Targets:** `CURRENT_STATE.md`, `ROADMAP.md`, `RELEASE_NOTES.md`, `DECISION_LOG.md`.
- **5 kroków:** zmień status; zamknij aktywny release; zachowaj buildy jako evidence; zapisz D-168; uruchom docs gate.
- **Akceptacja:** żaden aktywny dokument nie prowadzi do eksportu.
- **Dowód:** `verify_docs.ps1` PASS.
- **Failure signal:** aktywny handoff nadal wskazuje Linux/release.

### BUNDLE-02 — Player identity and stakes contract

- **Cel:** zdefiniować stan wiedzy po 1/5/30 minutach.
- **Targets:** `PRODUCT_BRIEF.md`, `PROJECT_BIBLE.md`, nowy `docs/rebuild/PLAYER_CONTRACT.md`.
- **5 kroków:** jedno zdanie Leny; cel 1 min; stan 5 min; stan 30 min; synchronizacja brief/bible.
- **Akceptacja:** opis pierwszej minuty nie wymaga lore UCP.
- **Dowód:** review kontraktu bez innych dokumentów.
- **Failure signal:** zawód lub Marta nie mają widocznego momentu ustanowienia.

### BUNDLE-03 — Twenty-address campaign cut

- **Cel:** ustanowić 01–18 → 42A/B/C → 43.
- **Targets:** nowy `docs/rebuild/CAMPAIGN_MAP.md`, `FULL_STORY.md`, `CONTINUITY_TRACKER.md`.
- **5 kroków:** mapa 01–18; warianty 42; epilog 43; status legacy 19–41; traceability faktów.
- **Akceptacja:** każdy adres zmienia pytanie lub relację.
- **Dowód:** fakt → scena → działanie → wypłata.
- **Failure signal:** scena trwa wyłącznie dla zachowania starego numeru.

### BUNDLE-04 — Location family bible

- **Cel:** rozdzielić siedem rodzin bez polegania na kolorze.
- **Targets:** nowy `docs/rebuild/LOCATION_FAMILY_BIBLE.md`, `VISUAL_DESIGN.md`.
- **5 kroków:** materiały/światło; topologie; czasowniki; zakazy powtórzeń; monochromatyczne blockouty.
- **Akceptacja:** rodzina rozpoznawalna bez labeli.
- **Dowód:** siedem blockoutów.
- **Failure signal:** trzy rodziny można pomylić.

### BUNDLE-05 — Product acceptance matrix

- **Cel:** rozdzielić technical PASS od product GO.
- **Targets:** nowy `docs/rebuild/ACCEPTANCE_MATRIX.md`, `tools/verify.ps1`.
- **5 kroków:** gate 1/5/30; family gate; objective gate; dwa werdykty; GO/PIVOT/CUT rubric.
- **Akceptacja:** stary opening kończy dry-run wynikiem FAIL.
- **Dowód:** wypełniona macierz na bieżącym runtime.
- **Failure signal:** 45 scen i zielone flagi wystarczają do GO.

### CHECKPOINT-01 — po BUNDLE-05

Właściciel ocenia tylko: target produktu, 20-adresową mapę, kontrakt Leny, rodziny i bramki. `GO`: wszystkie są jednoznaczne. `PIVOT`: rdzeń działa, ale zakres nadal za duży. `CUT`: plan nadal chroni stare sceny.

### BUNDLE-06 — Shell product promise

- **Cel:** shell ma obiecywać osobisty thriller, nie kanał produkcyjny.
- **Targets:** `title_screen.tscn`, `title_screen.gd`, locale.
- **5 kroków:** usuń żargon; jeden motyw Linii 4; skróć blok sterowania; zachowaj focus/save; capture PL/EN.
- **Akceptacja:** CTA i obietnica dominują nad informacją techniczną.
- **Dowód:** captures i focus traversal.
- **Failure signal:** shell wygląda jak konsola QA.

### BUNDLE-07 — Station 01 human worksite

- **Cel:** diagnostyczka, jedna próbka, Marta, jawna cena powtórki.
- **Targets:** `station_01.tscn/.gd`, dialogue/phone, Lena cues.
- **5 kroków:** redukcja do jednego stanowiska; działanie bez dialogu; wiadomość Marty; decyzja o powtórce; capture.
- **Akceptacja:** gate 1 minute PASS.
- **Dowód:** one-minute sequence i targeted smoke.
- **Failure signal:** nadal istnieje galeria przełączników.

### BUNDLE-08 — Station 02 outdoor service detour

- **Cel:** zewnętrze jednoznacznie inne od worksite.
- **Targets:** `station_02.tscn/.gd`, exterior environment/audio.
- **5 kroków:** niebo/nawierzchnia; realne prace; czytelna droga; traversal ≤18 px; źródłowe audio.
- **Akceptacja:** kadr bez tekstu czyta się jako obejście nocne.
- **Dowód:** monochrome capture i live walk.
- **Failure signal:** można pomylić ze Station 01.

### BUNDLE-09 — Station 03 believable transit stop

- **Cel:** wiarygodny przystanek i oczekiwanie na przejazd.
- **Targets:** `station_03.tscn/.gd`, transit scenery.
- **5 kroków:** wiata/krawężnik; ruch pojazdu; wiadomość Marty; semantyczne wejście; captures idle/arrival.
- **Akceptacja:** przystanek ≠ dom ≠ laboratorium.
- **Dowód:** capture bez tekstu i runtime odjazdu.
- **Failure signal:** rozpoznawalność zależy od słowa „przystanek”.

### BUNDLE-10 — Station 04 transit ride

- **Cel:** zakończyć pierwsze pięć minut i pokazać osobisty koszt.
- **Targets:** `station_04.tscn/.gd`, vehicle environment.
- **5 kroków:** wnętrze pojazdu; czytnik/luka; ślad Linii 4 za oknem; Marta nadal czeka; first-five gate.
- **Akceptacja:** gate 5 minutes PASS.
- **Dowód:** nieprzerwany capture/video 0–5.
- **Failure signal:** trzeba wyjaśniać, dlaczego Lena jedzie.

### CHECKPOINT-02 — po BUNDLE-10

Pytania: kim jest Lena, co robi, dokąd jedzie, co straciła przez pomiar? `GO`: odpowiedzi wynikają z runtime. `PIVOT`: tożsamość działa, ale Marta/pomiar są słabe. `CUT`: nadal seria terminali.
**Werdykt po recertyfikacji PKG-0159: GO.** Ciągły M1 rozpoczyna się od
rzeczywistego `Nowa gra` i dochodzi do Station 04 wyłącznie dialogiem, ruchem
i interakcją. Title nie pokazuje listy sterowania, a wybór
`repeat_sample|leave_on_time` zmienia stan torby i relację z Martą.

### BUNDLE-11 — Station 05 home street baseline

- **Cel:** stabilny wzorzec normalnego miasta.
- **Targets:** `station_05.tscn/.gd`, urban environment/audio.
- **5 kroków:** fasady; znana trasa; neutralny UCP; miejskie audio; baseline capture.
- **Akceptacja:** brak anomalnego kodowania.
- **Dowód:** capture bez UI/dialogu.
- **Failure signal:** ulica wygląda technicznie.

### BUNDLE-12 — Station 06 kiosk contradiction

- **Cel:** pierwsza publiczna rozbieżność przez człowieka.
- **Targets:** `station_06.tscn/.gd`, kiosk NPC/dialogue.
- **5 kroków:** kiosk; zwykły zakup; znajomość Marty; pytanie kontrolne; before/after captures.
- **Akceptacja:** sprzedawca ma własną pracę i nie zna tajemnicy.
- **Dowód:** conversation trace.
- **Failure signal:** clue istnieje tylko w terminalu.

### BUNDLE-13 — Station 07 building exterior

- **Cel:** materialny konflikt adresu 12/14.
- **Targets:** `station_07.tscn/.gd`, façade/intercom.
- **5 kroków:** pełna fasada; dokument 12; domofon 14; kod+klucz; exterior/threshold captures.
- **Akceptacja:** dwa fizyczne źródła i działanie gracza.
- **Dowód:** key/code test.
- **Failure signal:** wniosek istnieje tylko w myśli.

### BUNDLE-14 — Station 08 stairwell and threshold

- **Cel:** wiarygodna klatka i próg obcej prywatności.
- **Targets:** `station_08.tscn/.gd`, stair geometry, neighbour.
- **5 kroków:** pięć realnych stopni 12 px i półpiętro; codzienne ślady; pytanie bez sugestii; klucz otwiera 14; stitched capture.
- **Akceptacja:** po progu gracz rozumie spójny lokalny adres.
- **Dowód:** traversal i sequence capture.
- **Failure signal:** klatka przypomina UCP.

### BUNDLE-15 — First-thirty-minute integration gate

- **Cel:** sprawdzić 01–08 jako jeden opening.
- **Targets:** runtime 01–08, save, guidance, timing/capture harness.
- **5 kroków:** player-verbs run; timing; identity/objective rubric; family captures; GO/PIVOT/CUT.
- **Akceptacja:** gate 30 minutes PASS.
- **Dowód:** ciągły ślad M1 od `Nowa gra`, timing M5 i captures M2/M3 bez tekstu/UI.
- **Failure signal:** podstawy wymagają L3/L4.

### CHECKPOINT-03 — po BUNDLE-15

Pytania: kim jest Lena, dokąd idzie, dlaczego, co się nie zgadza, jakie rodziny odwiedziła? `GO`: odpowiedzi z obrazu i działania. `PIVOT`: jedna rodzina nadal słaba. `CUT`: guidance ratuje podstawy.
**Werdykt po recertyfikacji PKG-0159: PIVOT.** GATE-30 jest PASS: ciągły M1
`Nowa gra`→08 zajmuje technicznie 50124 ms i ustanawia cztery materialne
źródła. Jednak GATE-FAM ma próg globalny 7/7, a świeże, prawdziwe M3 bez
tekstu/UI obejmuje tylko 4/7. PKG-0160 wykonuje PHASE-04, ale przed
CHECKPOINT-04 musi dobudować i zestawić trzy brakujące rodziny.

### BUNDLE-16 — Station 09 foreign living room

- **Cel:** obca intymność w prawdziwym domu.
- **Targets:** `station_09.tscn/.gd`, domestic props/photo.
- **5 kroków:** salon dwóch osób; rzeczy Leny; fotografia relacji; zakres oględzin; captures.
- **Akceptacja:** relacja wynika z miejsca przed dialogiem.
- **Dowód:** capture bez tekstu i interaction trace.
- **Failure signal:** dom jest galerią clue.

### BUNDLE-17 — Station 10 Marta at the threshold

- **Cel:** dwie prawdziwe relacje i granica Marty.
- **Targets:** `station_10.tscn/.gd`, Marta staging/dialogue.
- **5 kroków:** działanie domowe; dwie wersje dnia; granica telefonu/rzeczy; cel zapisu UCP; capture gestu.
- **Akceptacja:** Marta ma cel i nie daje teorii świata.
- **Dowód:** dialogue trace.
- **Failure signal:** Marta jest guidance NPC.

### BUNDLE-18 — Station 11 institutional work history

- **Cel:** niezależna biografia bez dumpu terminala.
- **Targets:** `station_11.tscn/.gd`, UCP records.
- **5 kroków:** punkt kontroli; karta vs biometria; fizyczny zapis 186 dni; interkom Wierzbickiej; minimalny raport.
- **Akceptacja:** institution rozpoznawalna bez labeli.
- **Dowód:** scene capture i knowledge lint.
- **Failure signal:** pełny ekran danych jest obowiązkowy.

### BUNDLE-19 — Station 12 Jakub as a person

- **Cel:** żywy człowiek, technik i granica, nie twist-klucz.
- **Targets:** `station_12.tscn/.gd`, Jakub staging/dialogue.
- **5 kroków:** warsztat; pytania kontrolne; spotkanie ciał; odmowa testu; dobrowolny dowód techniczny.
- **Akceptacja:** scena traci sens po zastąpieniu Jakuba terminalem.
- **Dowód:** refusal/consent path.
- **Failure signal:** Jakub jest nagrodą lub urządzeniem.

### BUNDLE-20 — Station 13 explicit synthesis

- **Cel:** rozpoznanie wynika z ludzi i jawnego porównania.
- **Targets:** `station_13.tscn/.gd`, Marta/Jakub staging, state.
- **5 kroków:** wspólna przestrzeń; źródło per osoba; jawna synteza; „To nie jest mój świat”; save trace.
- **Akceptacja:** synteza nie uruchamia się po samym zebraniu źródeł.
- **Dowód:** full mystery run i save round-trip.
- **Failure signal:** checklist automatycznie kończy tajemnicę.

### CHECKPOINT-04 — po BUNDLE-20

Właściciel sprawdza: czy Marta/Jakub istnieją poza funkcją zagadki i czy gracz sam wykonuje wniosek. `GO`: cele, granice i trzy odmienne źródła. `PIVOT`: jedna postać słaba. `CUT`: nadal checklist terminali.

**Werdykt po PKG-0161: GO.** Lokalny poprawczy bundle przebudował wyłącznie
obraz Station 09: M3 bez tekstu/UI ma niski sufit, dwa codzienne nakrycia,
sofę, stół, zamknięte drzwi wewnętrzne i ślady relacji w maksymalnie dwóch
planach głębi. Siedem świeżych M3 z normalnego sterownika spełnia GATE-FAM 7/7.
Werdykt dotyczy kontraktu strukturalnego, nie jest PRODUCT GO.

### BUNDLE-21 — Station 14 dead-circuit mechanic lesson

- **Cel:** Anchor/Yield czytelne bez tekstu.
- **Targets:** `station_14.tscn/.gd`, Anchor/Yield components.
- **5 kroków:** obwód A/B; neutral; Anchor; Yield; bezpieczne odwrócenie.
- **Akceptacja:** obserwator opisuje różnicę przed nazwą.
- **Dowód:** trzy captures i trace.
- **Failure signal:** pierwsza poprawna próba wymaga L3/L4.

### BUNDLE-22 — Station 15 mutual signal test

- **Cel:** odróżnić echo od sprawczej odpowiedzi miejscowej Leny.
- **Targets:** `station_15.tscn/.gd`, signal apparatus.
- **5 kroków:** dwie kontrolne próby; celowy błąd; selektywna korekta; reakcje grupy; save trace.
- **Akceptacja:** gracz sam rozpoznaje odpowiedź.
- **Dowód:** negative-control test.
- **Failure signal:** miejscowa Lena wykłada lore.

### BUNDLE-23 — Stations 16–17 consent and cost

- **Cel:** materialny koszt i kontynuowalna odmowa.
- **Targets:** `station_16/17.tscn/.gd`, consent/save.
- **5 kroków:** konflikt śladów; mały koszt; odmowa Jakuba; zakres zgody; ledger Linii 4.
- **Akceptacja:** brak moral score i brak softlocka.
- **Dowód:** granted/limited/refused tests.
- **Failure signal:** zgoda daje bezkosztowe rozwiązanie.

### BUNDLE-24 — Station 18 choice and three consequences

- **Cel:** decyzja w znanym miejscu, trzy ludzkie skutki.
- **Targets:** `station_18.tscn/.gd`, `station_42a/b/c`.
- **5 kroków:** znane miejsce; stan osób; znany czasownik; trzy warianty; route/save.
- **Akceptacja:** finały różnią się osobami i przestrzenią, nie kolorem.
- **Dowód:** trzy playthrough traces i capture diffs.
- **Failure signal:** finał nadal jest trzema konsolami.

### BUNDLE-25 — Epilogue, clean cutover and final greenlight

- **Cel:** jedna aktywna kampania i epilog ludzi.
- **Targets:** `station_43`, `GameStateManager`, tests, docs, legacy 19–41.
- **5 kroków:** przełącz route; migrate saves; przebuduj epilog; usuń shimy/stare gate’y; pełny product+technical gate.
- **Akceptacja:** 20 adresów, trzy finały, wszystkie siedem faktów właściciela odwrócone dowodem.
- **Dowód:** full verify, 3 ending runs, 1/5/30 evidence, family captures.
- **Failure signal:** technical PASS nadal automatycznie daje product GO.

### CHECKPOINT-05 — po BUNDLE-25

`GO`: metoda, koszt, zgoda, trzy konsekwencje i epilog są czytelne; technical PASS i product GO są osobne. `PIVOT`: jedna rodzina finału do ponownego autorstwa. `CUT`: Anchor/Yield lub epilog nadal komunikuje system zamiast ludzi.

---

## 8a. Bundle backlog PHASE-08 — naprawa prezentacji i czytelności (D-184)

Otwarte po sesji diagnostycznej właściciela 2026-09-02. Dowody defektów,
uzasadnienie kolejności i kontrakty docelowe:
**`docs/rebuild/PRESENTATION_REPAIR_PLAN.md`**.

Kolejność jest **zależnościowa, nie ważnościowa** — właściciel może ją zmienić
jedną decyzją bez zmiany zakresu pakietów (plan §2).

### BUNDLE-26 — Cast, portraits and one visual language (PKG-0172)

- **Cel:** każda osoba w kadrze zbudowana tak samo jak Lena; Marta przestaje być
  przemalowaną Leną.
- **Defekty:** DEF-2, DEF-3.
- **Targets:** `assets/characters/portraits/marta.png` (regeneracja od zera),
  nowy `scripts/characters/character_visual_rig.gd`, sprite'y NPC
  (Marta, Jakub, Wierzbicka, ew. Szymon), usunięcie figur prymitywnych
  z `memory_resonance_point.gd` na trasie, `docs/LICENSES.md`.
- **Kroki:** karta tożsamości Marty → generacja bazy `gen-ai` → referencja
  tożsamości → 7 stanów × N postaci → `remove-bg` + normalizacja offline →
  `CharacterVisualRig` → podmiana w scenach → wycofanie
  `tools/update_marta_portrait.py`.
- **Akceptacja:** GATE-CAST PASS; 0 figur prymitywnych; 100% postaci 84–92 px.
- **Dowód:** normal-driver M2 z Leną i każdą postacią w jednym kadrze; portret
  i sprite tej samej osoby obok siebie.
- **Failure signal:** Marta „to Lena w peruce”; postać niższa niż 0,92 wzrostu Leny.
- **Kontrakt:** `docs/rebuild/CAST_AND_NPC_BIBLE.md`.

### BUNDLE-27 — Traversal animation: steps and ladders (PKG-0173)

- **Cel:** koniec potykania się na schodach i wiszenia w powietrzu na drabinie.
- **Defekty:** DEF-5, DEF-6.
- **Targets:** `scripts/player/prototype_player.gd` (`try_curb_step`),
  `scripts/player/lena_visual_rig.gd` (stany), `scripts/environment/ladder_zone.gd`,
  `scripts/levels/station_02.gd` (usunięcie ręcznej drabiny), stacje 15, 16,
  nowe klatki w `assets/characters/lena/`.
- **Kroki:** sondowanie rzeczywistej wysokości stopnia → interpolacja 0,18–0,24 s
  → flaga `_stepping` blokująca reakcję lądowania → stany `step_up`/`step_down`
  → generacja `climb_back_0..3`, `ladder_mount`, `ladder_dismount` →
  jedno źródło rysunku drabiny → lint zgodności rysunku ze strefą.
- **Akceptacja:** GATE-ANIM PASS w części schodowej i drabinowej.
- **Dowód:** M2 przed/po na Station 08 (schody) i Station 02 (drabina).
- **Failure signal:** squash albo `jump_fall` na jakimkolwiek stopniu trasy.
- **Kontrakt:** `docs/rebuild/THRESHOLD_AND_ENTRY_CONTRACT.md` §5–§6.

### BUNDLE-28 — Thresholds, entrances and aperture scale (PKG-0174)

- **Cel:** wejście do tramwaju jest wejściem do tramwaju; drzwi mają 2,1 m.
- **Defekty:** DEF-4, DEF-7.
- **Targets:** nowy `scripts/environment/threshold_zone.gd`, wszystkie
  `scenes/levels/station_*.tscn` i `station_*.gd` na trasie,
  `scripts/environment/exit_clearance.gd`, nowy lint geometrii w `tests/`.
- **Kroki:** `ThresholdZone` z `aperture_rect` jako jednym źródłem prawdy →
  trzy rodziny wejść `DOOR`/`VEHICLE`/`HATCH` → klatki `enter_door_0..2`,
  `board_vehicle_0..1` → migracja `AirlockZone` na strefę domknięcia →
  doprowadzenie 8 przęseł do kanonu → lint.
- **Akceptacja:** GATE-THRESH PASS 20/20; GATE-SCALE PASS 0 naruszeń.
- **Dowód:** M2 sekwencji wejścia w każdej z trzech rodzin; raport lintu.
- **Failure signal:** jakiekolwiek przejście wyzwalane z `body_entered`.
- **Kontrakt:** `docs/rebuild/THRESHOLD_AND_ENTRY_CONTRACT.md` §2–§4, §7.

### BUNDLE-29 — Continuous passability and gap ledger (PKG-0175)

- **Cel:** droga dalej jest zawsze otwarta; koszt przenosi się z drzwi na
  konsekwencję.
- **Defekt:** DEF-8.
- **Targets:** wszystkie `station_*.gd` na trasie (`_unlock_exit`,
  `_record_feedback`, `set_available`), `scripts/core/game_state_manager.gd`
  (rejestr luk + migracja save), `scripts/core/narrative_guidance_service.gd`
  (beaty luk).
- **Kroki:** przepisz wartości `_record_feedback()` na katalog luk →
  wyjścia odblokowane od `_ready()` → czynność zablokowana informuje słowami
  Leny i pozostaje wykonalna → beaty L1/L2/L3 → migracja zapisu → trzy przebiegi
  kontrolne (minimalny, pełny, mieszany).
- **Akceptacja:** GATE-FLOW PASS; przebieg bez ani jednego odczytu opcjonalnego
  dochodzi do Station 43.
- **Dowód:** trzy pełne M1 z zapisanym śladem; audyt statyczny 20/20 wyjść.
- **Failure signal:** jakikolwiek softlock albo zablokowana czynność bez
  komunikatu Leny.
- **Kontrakt:** `docs/rebuild/PROGRESSION_FLOW_CONTRACT.md`.

### BUNDLE-30 — Cold open (PKG-0176) — WYKONANE

- **Cel:** gracz wie, kim jest, co mierzy i kto czeka, zanim wykona pierwszy wybór.
- **Defekt:** DEF-1.
- **Targets:** nowe `scenes/shell/cold_open.tscn` + `scripts/ui/cold_open.gd`,
  `scripts/ui/title_screen.gd` (routing `Nowa gra`), `scripts/levels/station_01.gd`
  (stan wstępny), `GameStateManager` (flaga `p9.cold_open.seen` + migracja).
- **Kroki:** trzy ujęcia warstwy A → wykres drgań rysowany proceduralnie →
  warstwa B w Station 01 przed rozwidleniem → maks. cztery linie dialogu →
  pomijalność po pierwszym ukończeniu → wariant reduced motion.
- **Akceptacja:** GATE-INTRO PASS; GATE-INT Station 01 nadal ≤ 3.
- **Dowód:** M5 do 90 s; M4 lint zakazanych ujawnień; M2 trzech ujęć.
- **Failure signal:** ekran z akapitem tekstu; słowo „drgania” przed obrazem;
  cold open jako 21. adres kampanii.
- **Kontrakt:** `docs/rebuild/COLD_OPEN_SPEC.md`.

### BUNDLE-31 — Integration and re-certification (PKG-0177)

- **Cel:** jeden przebieg dowodzi wszystkich czternastu bramek naraz.
- **Targets:** `tests/pkg_0177_smoke_test.gd`, `tools/capture_pkg_0177.gd`,
  `docs/rebuild/ACCEPTANCE_MATRIX.md` §3a i §4, `docs/CURRENT_STATE.md`.
- **Kroki:** pełny przebieg M1 trasy 20 adresów → M2 „po” dla każdego kadru
  „przed” z PKG-0171 → M3 siedmiu rodzin → recertyfikacja GATE-01 → zestawienie
  czternastu bramek.
- **Akceptacja:** CHECKPOINT-06 wg rubryki §5 macierzy.
- **Dowód:** komplet kadrów przed/po; pełne `verify.ps1` exit 0.
- **Failure signal:** którakolwiek z sześciu nowych bramek zaliczona warstwą
  tekstu albo dowodem węższym niż jej próg.

### CHECKPOINT-06 — po BUNDLE-31

`GO`: sześć nowych bramek PASS, GATE-01 recertyfikowana na dowodzie
odpowiadającym progowi, żadna wcześniejsza bramka nie cofnęła się do FAIL.
`PIVOT`: jeden defekt wraca z przyczyny zakresu, poprawka mieści się w jednym
bundle'u. `CUT`: dwa lub więcej defektów wraca, albo bramka jest zaliczana
wyłącznie warstwą tekstu, albo plan znowu chroni istniejący kształt zamiast go
naprawić.

## 9. Zasady wykonania

1. Jeden aktywny pakiet z `NEXT_SESSION_PROMPT.md`; bez improwizowania dalszych bundle’ów.
2. Każdy pakiet zaczyna pełne `tools/verify.ps1` i porównuje baseline.
3. Każda scena ma przed kodem zapis: cel, przeszkoda, działanie, reakcja, zmiana, nowe oczekiwanie.
4. Każda scena ma maksymalnie trzy istotne interakcje.
5. Najpierw obraz i działanie, potem dialog, na końcu guidance.
6. Zmiana wizualna wymaga normal-driver capture; zmiana gameplayu — wykonania przez player verbs.
7. Nie rozszerzać monolitów. Nowe zachowanie jest lokalnym komponentem sceny lub małym współdzielonym komponentem użytym co najmniej dwa razy.
8. Po checkpoint `CUT` nie poprawiać dalej bieżącej wersji — wykonać wariant bardziej radykalny.
9. Bez nowych `.exe` do nowego produktowego GO i osobnego polecenia właściciela.
10. Każdy pakiet aktualizuje stan, roadmapę, decyzje, ryzyka, log, handoff i snapshot.

## 10. Status wykonania

### PKG-0156 — PHASE-01 / BUNDLE-01..05 (WYKONANE)

PHASE-01 zamknięty bez zmian runtime. Powstały cztery kontrakty produktu
w `docs/rebuild/`, re-origination 33 flag kanonicznych i reguła kierunku trasy;
bramka `tests/pkg_0156_smoke_test.gd` pilnuje ich w `tools/verify.ps1`.
CHECKPOINT-01: **GO** (jedna tożsamość Leny, jedna 20-adresowa trasa, siedem
rodzin, kompletna acceptance matrix). Release i nowe `.exe` pozostają
zablokowane.

### PKG-0157 / PKG-0158 — PHASE-02/03 (WYKONANE, HISTORYCZNE WERDYKTY SKORYGOWANE)

Runtime 01–08 został zbudowany w dwóch pakietach. Ich bezpośrednie testy metod
i kolorowe captures pozostają dowodem implementacji, lecz nie wystarczały do
ścisłych M1/M3/M5 ani globalnego GATE-FAM.

### PKG-0159 — Opening remediation & evidence recertification (WYKONANE)

Usunięto listę sterowania z pierwszego kadru, wdrożono dwie drogi Station 01,
naprawiono jednokierunkowy pomost Station 02 i pięć realnych stopni Station 08.
`tests/pkg_0159_smoke_test.gd` przechodzi ciągły M1 01–08 bez metod gameplayu
i flag; `tools/capture_pkg_0159.gd` daje 9 kadrów M2/M3. CHECKPOINT-02 = GO,
CHECKPOINT-03 = PIVOT z powodu GATE-FAM 4/7.

### PKG-0160 / PKG-0161 — PHASE-04 / BUNDLE-16..20 (WYKONANE)

Station 09–13 dostarczają trzy brakujące rodziny i pierwszą tajemnicę. PKG-0160
zbudował kontrakt runtime, a PKG-0161 spłacił jedyny pivot: lokalny obraz 09
czyta się w M3 jako zamieszkały salon dwóch osób. CHECKPOINT-04 = GO, GATE-FAM
= TECHNICAL PASS 7/7; PRODUCT GO nadal jest zablokowane przez kolejne bramki.

### PKG-0162 — PHASE-05 / BUNDLE-21 (WYKONANE)

Station 14 jest pierwszą czytelną lekcją martwego obwodu. Rozdzielnia Linii 4
pracuje własnym cyklem (maszyna ≥ 1/3 kadru, diagonale rur, robocze światło,
bęben przełącznika, fala korekty co 7 s) i wystawia most sekcji na falę.
Donor `AnchorableObject` decyduje o wyniku: utrzymany most opiera się fali
(wersja utrzymana), puszczony przechodzi na drugi montaż. Yield zostawia jawny
mały koszt jako stan świata (zgaszona sekcja za mostem, przygaszone światło),
nie ocenę. Nazwanie metody następuje wyłącznie po wykonaniu obu zachowań;
odwrócenie jest bezpieczne i dostępne w dowolnym cyklu; wyjście nie zależy od
wersji mostu. Kontrakty P7 progu Marty zostały zmigrowane w bramkach
`pkg_0099`, `pkg_0120`, `pkg_0146` i `smoke_test` zgodnie z trasą P9; nowa
bramka `tests/pkg_0162_smoke_test.gd` jest w `tools/verify.ps1`. Dowód obrazu:
`reports/pkg_0162/` — trzy beztekstowe M2 (neutral/anchor/yield) o różnych
hashach i jeden M3 struktury technicznej, normalny sterownik Intel Iris Xe.
GATE-MECH = TECHNICAL PASS kontraktowy; PRODUCT GO pozostaje zablokowane.

### PKG-0163 — PHASE-05 / BUNDLE-22 (WYKONANE)

Station 15 jest pierwszym adresem rodziny granicznej/anomalnej i próbą
wzajemnego sygnału. Komora pętli pomiarowej zachowuje topologię techniczną,
lecz dokładnie jeden element istnieje w dwóch wersjach (odbiéracz pętli po
obu stronach szwu anomalii), jedno światło świeci w górę niezgodnie z resztą
kadru, a odpowiedź pętli dociera jako dźwięk bez źródła. Kontrakt: log 20:40
(`ucp_intervention_reconstructed`), dwa identyczne impulsy kontrolne
(identyczne echo), trzeci impuls z celowym błędem otrzymuje selektywną
korektę (`local_lena_signal_confirmed`), notatka z warunkiem przerwania
odczytana dopiero po potwierdzeniu otwiera właz (`local_lena_intent_found`).
Wyjście: `LadderZone` w górę. Kolizja korpusu to podest ≤18 px (D-138).
Hipoteza `living_response` zastępuje legacy `memory_manipulation`. Migracje
bramek: `pkg_0120`, `pkg_0147` (sekcja S06), `smoke_test`, sterownik
`pkg_0138`, `capture_pkg_0147`. Nowa bramka `tests/pkg_0163_smoke_test.gd` w
`tools/verify.ps1`; dowód obrazu `reports/pkg_0163/` (3×M2 bez tekstu + M3
mono, normalny sterownik). PRODUCT GO pozostaje zablokowane; aktywny BUNDLE-23.

### PKG-0164 — PHASE-05 / BUNDLE-23 (WYKONANE)

Station 16 kontynuuje rodzinę graniczną/anomalną jako komora bezpiecznego
analizatora. Odpowiedź przechodzi przez jeden lokalny przekaźnik o dwóch
położeniach; następnie gracz wybiera, czy traci ostrość pamięci pierwszego
spotkania z Martą (`marta_first_meeting_detail_blurred`), czy dokładną sekundę
próbki (`sample_exact_second_lost`). Dopiero wykonany wybór zapisuje
`mechanic_cost_observed` i `small_cost_manifested`; potwierdzenie echa domu
zapisuje `home_echo_verified` i zamyka hipotezę `small_cost`. Wczesne lub
niepełne próby są informacyjne i nie usuwają dalszej drogi.

Zachowano wejście drabiną od Station 15, prawą `AirlockZone`, `ReturnZone`,
trzy istotne interakcje, brak nowych przeszkód oraz semantyczny InputMap.
Migracje objęły `pkg_0120`, `pkg_0147`, `smoke_test`, sterownik `pkg_0138`
i bieżące capture helpers; nowa bramka `tests/pkg_0164_smoke_test.gd` jest
w `tools/verify.ps1`. `tools/capture_pkg_0164.gd` na normalnym sterowniku
Intel Iris Xe zapisał trzy beztekstowe M2 o różnych hashach i jeden M3 mono
do `reports/pkg_0164/`. GATE-MECH = TECHNICAL PASS kontraktowy; nie jest to
PRODUCT GO, dowód odbioru człowieka ani zgoda na release. Następny pakiet:
BUNDLE-24 / Station 17.

### PKG-0165 — PHASE-05 / BUNDLE-24 (WYKONANE)

Station 17 wraca do rodziny instytucjonalnej jako rejestr par kosztów Linii 4
i negocjacja zgody. Trzy istotne interakcje: odczyt rejestru par (wejście
wymaga donor faktów Station 16; zapisuje `p9.consent_and_cost.cost_ledger_read`
i kanoniczny `ucp_cost_ledger_found`), terminal oferty adaptacji, którego
czasownikiem gracza jest kontynuowalna odmowa (`p9.consent_and_cost.adaptation_offer
= "rejected"`, zamyka omylną hipotezę `cheap_adaptation`), oraz biurko zakresu
zgody Jakuba z trzema równymi wariantami `granted` / `limited` / `refused`
(`p9.consent_and_cost.jakub_consent_scope` + kanoniczny `jakub_consent_state`).
Odmowa jest pełnoprawnym zapisem, otwiera wyjście i nie softlockuje; zapisów
nie wolno nadpisywać. Ślad `p7.work_history_and_record.trace =
"cost_ledger_and_consent_scope_recorded"` przygotowuje wejście Station 18;
`route_hypotheses_mapped` i `marta_truth_state` nie powstają w 17.

Rodzina instytucjonalna: moduł 64 px, lada 104 px, brudna biel dokumentów,
zero ciepłego punktu; zero nowych colliderów, usunięta legacy kapsuła
pneumatyczna i ścieżka kopiowania raportu S06. Nowa bramka
`tests/pkg_0165_smoke_test.gd` w `tools/verify.ps1`; zmigrowane `pkg_0120`,
`pkg_0147` (sekcja S06), `smoke_test`, sterownik i audyt `pkg_0138`,
`pkg_0101`, `capture_pkg_0147`, `capture_preview`. `tools/capture_pkg_0165.gd`
na normalnym sterowniku Intel Iris Xe zapisał trzy beztekstowe M2 o różnych
hashach i jeden M3 mono do `reports/pkg_0165/`. GATE-MECH = TECHNICAL PASS
kontraktowy; nie jest to PRODUCT GO, dowód odbioru człowieka ani zgoda na
release. Następny pakiet: BUNDLE-25 / Station 18.

### PKG-0166 — PHASE-05 / BUNDLE-25 (WYKONANE)

Station 18 zamyka linię 01–18 jako ulica z 05 po zmianie (rodzina miejska
wg `CAMPAIGN_MAP.md` wiersz 18 i `LOCATION_FAMILY_BIBLE.md` §3; omyłkowy
cytat „mieszkalna” w prompcie PKG-0166 został skorygowany w D-179). Trzy
istotne interakcje: tablica trzech prognoz (`force_home` /
`close_equal_recover_local` / `mutual_passage` zestawione z aktualnym
`jakub_consent_state`; `p9.method_commitment.forecasts_compared` + kanoniczny
`route_hypotheses_mapped`, zamyka `single_route_sufficient`), witryna Marty
(`marta_truth_state` = `full`/`partial`/`withheld`, wstrzymanie
kontynuowalne) oraz słupek zatwierdzenia (`method_committed` wyłącznie po
zestawieniu kosztów i aktualnych zgodach; routing 42A/B/C). Wejście wymaga
donor faktów Station 17; odmowa i ograniczona zgoda nie softlockują.

Rodzina miejska: niebo ≥ 25% kadru, trzy plany, pionowe fasady, latarnia
z długim cieniem, witryna przy chodniku; sufit colliduje, ale nie jest
malowany; zero nowych colliderów; usunięte legacy rejestry i mikrofisze
S07. Nowa bramka `tests/pkg_0166_smoke_test.gd` w `tools/verify.ps1`;
zmigrowane `pkg_0120`, `pkg_0147` (sekcja S07 dla 18), `smoke_test`,
sterownik i audyt `pkg_0138` (most publiczny dla dawcy 19–21), `pkg_0101`,
`capture_pkg_0147`, `capture_preview`. `tools/capture_pkg_0166.gd` na
normalnym sterowniku Intel Iris Xe zapisał trzy beztekstowe M2 o różnych
hashach i jeden M3 mono do `reports/pkg_0166/`. GATE-MECH = TECHNICAL PASS
kontraktowy; nie jest to PRODUCT GO. Następny pakiet: PHASE-06 / Station 42A.

### PKG-0167 — PHASE-06 / Station 42A (WYKONANE)

Station 42A jest pierwszym adresem rodziny finałowej/epilogicznej P9:
znane mieszkanie z 09/10/13 o świcie, ta sama bryła, jeden zmieniony fakt
o osobach (puste krzesło i zapieczętowany próg). Wejście wymaga
`method_committed = force_home` ze Station 18 i nie fabrykuje wyboru
metody. Trzy istotne interakcje: rygiel wymuszonego powrotu
(`p9.finale.forced_return.executed` + kanoniczny `ending_family =
"force_home"`), zapieczętowany próg drugiej Leny
(`p9.finale.forced_return.local_lena_sealed`, zamyka hipotezę
`other_lena_comes_home_too`) oraz stół z pustym krzesłem
(`p9.finale.forced_return.household_consequence` jako JSON-safe słownik
stanu Marty i Jakuba + `ending_stability`). D-180: wybrany wariant
zostawia drogę do 43 otwartą od wejścia; niepełna próba jest
informacyjna i nie softlockuje. Ograniczona zgoda i wstrzymanie Marty są
kontynuowalne. Żaden finał nie jest rankingiem moralnym.

Zero nowych colliderów; usunięty legacy telefon i dwupunktowy checklist
kubków/wyjścia. Nowa bramka `tests/pkg_0167_smoke_test.gd` w
`tools/verify.ps1`; zmigrowane `pkg_0107`, `smoke_test`, `pkg_0138`,
`pkg_0150`, `pkg_0151` i capture helpers. `tools/capture_pkg_0167.gd` na
normalnym sterowniku Intel Iris Xe zapisał trzy beztekstowe M2 o różnych
hashach i jeden M3 mono do `reports/pkg_0167/`. GATE-MECH = TECHNICAL PASS
kontraktowy; nie jest to PRODUCT GO. Następny pakiet: PHASE-06 / Station 42B.

### PKG-0168 — PHASE-06 / Station 42B (WYKONANE)

Station 42B kontynuuje rodzinę finałową/epilogiczną P9: znane mieszkanie z
09/10/13 o świcie, ta sama bryła, jeden zmieniony fakt o osobach (miejscowa
Lena w odzyskanym ciele, przybyła Lena poza indeksem). Wejście wymaga
`method_committed = close_equal_recover_local` ze Station 18 i nie fabrykuje
wyboru metody. Trzy istotne interakcje: zabezpieczenie przewodu Równi
(`p9.finale.close_equal.flow_closed` + `p9.finale.close_equal.executed` +
kanoniczny `ending_family = "close_equal_recover_local"`), próg mieszkania 14
(`p9.finale.close_equal.local_lena_recovered`, zamyka hipotezę
`arrived_lena_unindexed_presence`) oraz stół nieindeksowanej obecności
(`p9.finale.close_equal.household_consequence` jako JSON-safe słownik
stanu Marty, Jakuba i obu Len + `ending_stability`). D-181: wybrany wariant
zostawia drogę do 43 otwartą od wejścia; niepełna próba jest
informacyjna i nie softlockuje. Ograniczona zgoda i wstrzymanie Marty są
kontynuowalne. Żaden finał nie jest rankingiem moralnym.

Zero nowych colliderów poza podłogą/ścianami. Nowa bramka
`tests/pkg_0168_smoke_test.gd` w `tools/verify.ps1`; zmigrowane `pkg_0107`,
`smoke_test`, `pkg_0138`. `tools/capture_pkg_0168.gd` na normalnym
sterowniku Intel Iris Xe zapisał trzy beztekstowe M2 o różnych hashach i
jeden M3 mono do `reports/pkg_0168/`. GATE-MECH = TECHNICAL PASS
kontraktowy; nie jest to PRODUCT GO. Następny pakiet: PHASE-06 / Station 42C.

### PKG-0169 — PHASE-06 / Station 42C (WYKONANE)

Station 42C kontynuuje rodzinę finałową/epilogiczną P9: znane mieszkanie z
09/10/13 o świcie, ta sama bryła, jeden zmieniony fakt o osobach (most nie
zgasł, pamięć przecieka między obydwoma światami, obie Leny odpowiadają przed
własnym domem). Wejście wymaga `method_committed = mutual_passage` ze Station 18
i nie fabrykuje wyboru metody. Trzy istotne interakcje: zwolnienie wzajemnego
przejścia (`p9.finale.mutual_passage.passage_opened` + `p9.finale.mutual_passage.executed` +
kanoniczny `ending_family = "mutual_passage"`), próg trwałego przecieku pamięci
(`p9.finale.mutual_passage.memory_leak_accepted`, zamyka hipotezę
`mutual_memory_leak_uncontrolled`, zapisuje `final_chamber_witnessed`) oraz stół
dwóch domów (`p9.finale.mutual_passage.household_consequence` jako JSON-safe
słownik stanu Marty, Jakuba i obu Len + `ending_stability`). D-182: wybrany
wariant zostawia drogę do 43 otwartą od wejścia; niepełna próba jest
informacyjna i nie softlockuje. Ograniczona zgoda i wstrzymanie Marty są
kontynuowalne. Żaden finał nie jest rankingiem moralnym.

Zero nowych colliderów poza podłogą/ścianami. Nowa bramka
`tests/pkg_0169_smoke_test.gd` w `tools/verify.ps1`; zmigrowane `pkg_0107`,
`smoke_test`, `pkg_0138`, `pkg_0150`, `pkg_0151`. `tools/capture_pkg_0169.gd`
na normalnym sterowniku Intel Iris Xe zapisał trzy beztekstowe M2 o różnych
hashach i jeden M3 mono do `reports/pkg_0169/`. GATE-MECH = TECHNICAL PASS
kontraktowy; nie jest to PRODUCT GO. Następny pakiet: PHASE-06 / Station 43.

### PKG-0170 — PHASE-06 / Station 43 (WYKONANE)

Station 43 zamyka PHASE-06 jako administracyjne domknięcie, napisy końcowe
i epilog w Rodzinie 7 (finałowa/epilogiczna): przestrzeń już odwiedzona (wiata
i torowisko ze Stacji 03/05/18) o świcie z jednym zmienionym faktem o ludziach,
ciszą z jednym źródłem proceduralnym (`dawn_quietude`), zachowanymi panelami
licencji i creditsów (PKG-0153), oraz trójstanową adaptacją dialogów
odpowiadających na pytanie „co zostało w mieście po nas?” bez moralnego osądu.
Trzy istotne interakcje: tablica ogłoszeń miejskich (`AdminNoticeBoard`,
`p9.epilogue.admin_notice_inspected` + `p7.conscious_silence_and_presence.epilogue_noticed`),
kolumna napisów i licencji (`CreditsRoll`, `p9.epilogue.credits_read` +
`p7.conscious_silence_and_presence.epilogue_credits_read`) oraz sygnalizator
nowej ciągłości (`FinalBlackout`, `p9.epilogue.executed`, `ending_family`,
`ending_stability`, `p9.epilogue.safe_trial_feedback = "epilogue_completed_cleanly"`,
`epilogue_witness_completed = true`, odryglowanie wyjścia i domknięcie kampanii).
Obsłużone przejście przez `AirlockZone` i powrót przez `ReturnZone`.

Zero nowych colliderów poza podłogą/ścianami. Nowa bramka
`tests/pkg_0170_smoke_test.gd` w `tools/verify.ps1`. `tools/capture_pkg_0170.gd`
na normalnym sterowniku Intel Iris Xe zapisał trzy beztekstowe M2 o różnych
hashach i jeden M3 mono do `reports/pkg_0170/`. GATE-FIN = TECHNICAL PASS
kontraktowy; nie jest to PRODUCT GO ani zgoda na release (D-168). Następny pakiet:
PHASE-07 / BUNDLE-25 (Clean cutover, usunięcie legacy shims i finalny audyt trasy).


### Sesja diagnostyczna właściciela — 2026-09-02 (BEZ PAKIETU KODU)

Właściciel uruchomił runtime po PKG-0170 i zgłosił osiem defektów prezentacji
i czytelności z załączonymi kadrami. Sesja **nie zmieniła kodu ani assetów** —
zweryfikowała zgłoszenia w plikach, opisała je z dowodami i przeorganizowała
plan. Wynik:

- nowy dokument nadrzędny `docs/rebuild/PRESENTATION_REPAIR_PLAN.md` z pełnym
  łańcuchem dowodowym dla DEF-1..DEF-8;
- cztery nowe kontrakty: `CAST_AND_NPC_BIBLE.md`,
  `THRESHOLD_AND_ENTRY_CONTRACT.md`, `PROGRESSION_FLOW_CONTRACT.md`,
  `COLD_OPEN_SPEC.md`;
- sześć nowych bramek produktu w `ACCEPTANCE_MATRIX.md` §3a; próg GATE-REL
  podniesiony z ośmiu do czternastu bramek;
- GATE-01 cofnięta z `PASS` do `CONCERNS` (D-184);
- PHASE-07 (cutover) wydzielona z BUNDLE-25 i postawiona jako precondycja
  PHASE-08 (D-185);
- PHASE-08 z BUNDLE-26..31 otwarta i rozpisana na PKG-0172..0177;
- decyzje D-184..D-193 zapisane w `DECISION_LOG.md`;
- zapisano też fakt, który nie był wcześniej jawny w dokumentach stanu:
  `GameStateManager.CAMPAIGN_ROUTE` nadal prowadzi przez `station_01..station_41`,
  więc **trasa 20 adresów nie istnieje w runtime**.

Następny pakiet to był PKG-0171 / PHASE-07 / BUNDLE-25.

### PKG-0171 — PHASE-07 / BUNDLE-25 (WYKONANE)

PKG-0171 zrealizował clean cutover trasy 20 adresów w `GameStateManager` oraz tabelę dowodową defektów prezentacji `docs/PRESENTATION_DEFECT_AUDIT.md`:
1. `CAMPAIGN_ROUTE` skrócony z 41 do 18 adresów (`&"station_01"`..`&"station_18"`).
2. Stacje dawcy 19..41 wyizolowane w `CAMPAIGN_LEGACY_STATIONS` (23 stacje), zachowując kompatybilność testów i mechanik dawcy bez naruszania aktywnej trasy.
3. `CAMPAIGN_SELECTOR_STATIONS` zredukowany z 43 do 20 pozycji (`station_01`..`station_18`, wybrany finał na indeksie 18, `station_43` na indeksie 19).
4. `CAMPAIGN_TRANSITION_LIMIT` wynosi 18; tranzycja ze `station_18` prowadzi bezpośrednio do wybranego finału (`station_42a`/`b`/`c`), a stamtąd do epilogu `station_43`.
5. Zmigrowano historyczne bramki testowe (`pkg_0091`, `pkg_0094`, `pkg_0096`, `pkg_0097`, `pkg_0099`..`pkg_0107`, `pkg_0113`, `pkg_0114`, `pkg_0127`, `pkg_0151`).
6. Utworzono nową bramkę `tests/pkg_0171_smoke_test.gd` sprawdzającą 18-elementową trasę, 20-pozycyjny selektor, izolację dawców, rozgałęzienie finałowe i zachowanie klas dawcy (`AnchorExclusivityController`, `ServiceLift`, `LadderZone`, `MovableAnchorableProp`, `AnchorableObject`).
7. Zarejestrowano dokumenty przebudowy w `tools/verify_docs.ps1` (`DOCS PASS: 52 required files`).
8. Zbudowano `docs/PRESENTATION_DEFECT_AUDIT.md` ze zmierzoną tabelą defektów DEF-3..DEF-8 dla wszystkich 20 adresów, decyzją D-194 (wariant B dla DEF-9) i matrycą 14 kadrów referencyjnych w `reports/pkg_0171/` wygenerowanych na normalnym sterowniku Compatibility.
9. `tools/verify.ps1` zakończone pełnym `Verification passed.` (exit code 0).

### PKG-0172 — PHASE-08 / BUNDLE-26 (WYKONANE)

PKG-0172 wdrożył obsadę na kontrakcie Leny i zaliczył GATE-CAST jako TECHNICAL PASS:
1. Portret `assets/characters/portraits/marta.png` (1024×1024) jest unikalną twarzą (długie różowe włosy, septum, sukienka); `tools/update_marta_portrait.py` pozostaje w `tools/retired/` (D-187).
2. Nowy `scripts/characters/character_visual_rig.gd`: płótno 64×104, pivot (32, 96), nearest, 7 stanów bez lokomocji, fallback `idle`, cień kontaktowy w `_draw()`.
3. Sprite'y 64×104 Marty, Jakuba i Wierzbickiej w `assets/characters/<imię>/` (idle/talk_0/talk_1/listen/gesture/turn_away/seated/work).
4. Fizyczna obsada D-194: Marta w Station 10 i 42B/C, Wierzbicka (`seated`) w Station 11, Jakub (`work`) w Station 12. GATE-INT ≤ 3 nienaruszone.
5. Usunięto kółkowe figury z `station_10.gd` / `station_12.gd` oraz sylwetkę Marty z `_draw_epilogue_marta_doorstep()`.
6. Bramka `tests/pkg_0172_smoke_test.gd` zarejestrowana w `tools/verify.ps1`.

### PKG-0173 — PHASE-08 / BUNDLE-27 (WYKONANE)

PKG-0173 zamknął DEF-5 i DEF-6 i zaliczył GATE-ANIM (część schodowa i drabinowa):
1. `try_curb_step()` mierzy rzeczywistą wysokość podstopnicy i interpoluje 0,18–0,24 s; `_stepping` blokuje lądowanie, kurz i squash. Limit 18 px (D-123) zostaje.
2. `LenaVisualRig` 4.2: stany `step_up`, `step_down`, `climb_back`, `ladder_mount`, `ladder_dismount` na płótnie 64×104, pivot (32, 96). Stary `climb` zostaje fallbackiem.
3. Klatki w `assets/characters/lena/`; normalizacja `tools/process_lena_traversal_sprites.py`.
4. Station 02: usunięty ręczny rysunek drabiny (rozjazd 62 px). `ServiceLadder` na `(570, 296)`, `ladder_height = 80`. Station 15/16 bez drugiej drabiny.
5. Wspinaczka wymaga intencji (`interact` albo `move_up` przy zatrzymanej postaci).
6. Bramka `tests/pkg_0173_smoke_test.gd` w `tools/verify.ps1`. Kadry: `reports/pkg_0173/`.

### PKG-0174 — PHASE-08 / BUNDLE-28 (WYKONANE)

PKG-0174 zamknął DEF-4 i DEF-7 (część otworów) i zaliczył GATE-THRESH:
1. Nowy `scripts/environment/threshold_zone.gd`: `aperture_rect` jest jednym źródłem prawdy; rodziny `DOOR` / `VEHICLE` / `HATCH`; sekwencja podejścia + klatki + obrót skrzydła / rozsunięcie drzwi wagonu / wieko włazu.
2. `ThresholdBinder` instaluje próg na 01–18 + 42A/B/C + 43. `AirlockZone` zostaje strefą domknięcia: handlery `body_entered` to `pass`.
3. Wejście wymaga `interact` (`trigger_entry`). `ExitClearance.disable_collision` zamiast podnoszenia skrzydła o 140 px.
4. Klatki `enter_door_0..2` i `board_vehicle_0..1` na płótnie 64×104, pivot (32, 96).
5. Collidery otworów 01/02/03/04/07/08/12 doprowadzone do kanonu `WORLD_SCALE.md` §3.
6. Bramka `tests/pkg_0174_smoke_test.gd` w `tools/verify.ps1`. Kadry: `reports/pkg_0174/`.

### PKG-0175 — PHASE-08 / BUNDLE-29 (WYKONANE)

PKG-0175 zamknął DEF-8 i zaliczył GATE-FLOW:
1. `scripts/campaign/gap_ledger.gd` — katalog luk, otwarcie przy odejściu, zamknięcie po odczycie.
2. `GameStateManager.open_gaps` w zapisie JSON bez podbicia schematu.
3. Wyjście otwarte od `_ready()` na 01–18 + 42A/B/C + 43. `OpeningActionPoint` nie ukrywa odczytu.
4. Station 03 `board_line_four` i Station 18 `_commit_method` nie twardo bramkują progu.
5. Bramka `tests/pkg_0175_smoke_test.gd` w `tools/verify.ps1`. Kadry: `reports/pkg_0175/`.

### PKG-0176 — PHASE-08 / BUNDLE-30 (WYKONANE)

PKG-0176 zamknął DEF-1 i zaliczył GATE-INTRO:
1. `scripts/campaign/cold_open_facts.gd` — katalog pięciu faktów `PLAYER_CONTRACT.md` §3,
   ich nośników, kolejności pojęcia „drgania” (§4.3) i rdzeni zakazanych ujawnień (§5).
2. `scripts/visual/vibration_trace_display.gd` — jeden proceduralny przebieg drgań
   dla obu warstw; luka archiwalna to dokładnie 3 s płaskiej linii w szumie.
3. Warstwa A: `scenes/shell/cold_open.tscn` + `scripts/ui/cold_open.gd`, trzy ujęcia,
   14,5 s (12,5 s w reduced motion), sekwencja na `_physics_process`.
4. Warstwa B: stan wstępny `station_01.gd` przed rozwidleniem — jedna wymuszona
   czynność na istniejącej `MeasurementRig`; wykres i wiadomość Marty na jednym ekranie.
5. Routing `GameStateManager.start_new_game()` → `COLD_OPEN_SCENE`; flaga
   `cold_open_seen` w pliku ustawień, z migracją starszego pliku bez klucza.
   Zamiast `title_screen.gd` — routing zostaje w jednym miejscu (D-195).
6. Bramka `tests/pkg_0176_smoke_test.gd` w `tools/verify.ps1`. Kadry: `reports/pkg_0176/`.

M1/M5: 25,0 s od `Nowa gra` do kompletu pięciu faktów przy budżecie 90 s.
Station 01 nadal ma dokładnie trzy punkty interakcji (GATE-INT).

### PKG-0177 — PHASE-08 / BUNDLE-31 (WYKONANE)

PKG-0177 zintegrował całą trasę 20 adresów i wydał werdykt CHECKPOINT-06 GO:
1. Ciągły przebieg M1 trasy 20 adresów (Nowa gra → ColdOpen → 01..18 → 42a → 43 → Epilog/Tytuł) pokonany wyłącznie semantycznymi czasownikami gracza (`move_right`, `move_up`, `interact`, `ui_accept`), bez ręcznych flag i wywołań metod gameplayu.
2. Próbkowanie zamiaru (GATE-OBJ) co 2 minuty i na każdej stacji: 21 próbek, 100% zgodności (kierunek w prawo/w górę, brak otwartego menu, niepusty cel diegetyczny). Trace: `reports/pkg_0177/gate_obj_samples.tsv`.
3. Recertyfikacja GATE-01: M5 = 28,0 s sim (budżet 90 s), 5/5 faktów tożsamości i celu, nośniki poza UI. Nowy werdykt: PASS (RECERTIFIED) / TECHNICAL PASS.
4. Komplet 14 kadrów „po” odpowiadających baseline'owi z PKG-0171 oraz 7 kadrów M3 (monochromatycznych bez tekstu/UI) o 7 unikalnych hashach strukturalnych. Raport: `reports/pkg_0177/visual_evidence_report.txt`.
5. Master tabela 14 bramek w `ACCEPTANCE_MATRIX.md` §4.8: wszystkie 14 bramek produktu ma status TECHNICAL PASS / PASS. Zero regresji.
6. CHECKPOINT-06: **GO**.
7. Bramka `tests/pkg_0177_smoke_test.gd` zarejestrowana w `tools/verify.ps1`.
8. D-168: zero nowych binariów `.exe` w drzewie. Release pozostaje zablokowany do decyzji właściciela.

Następny pakiet: **PKG-0178 / Handoff & Release Assessment**.

