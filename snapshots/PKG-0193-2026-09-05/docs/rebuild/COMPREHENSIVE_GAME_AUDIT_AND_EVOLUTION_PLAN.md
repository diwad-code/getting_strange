# Plan absolutnego audytu i ewolucji gry — PHASE-10 / PKG-0182 / BUNDLE-32

## Projekt: *Getting Strange* (Godot 4.7.x)

**Data otwarcia:** 2026-09-03  
**Status:** **WDROŻONY (PKG-0182 TECHNICAL PASS; raport `docs/rebuild/PKG_0182_COMPREHENSIVE_AUDIT_REPORT.md`)**  
**Tryb:** jeden autonomiczny High-Throughput Mega-Package, wykonany od audytu do snapshotu bez przerw na akceptację  
**Prompt wykonawczy:** `docs/PLUS_SESSION_PROMPT_2.md`  
**Zakres:** cała aktualna gra PC w Godot, jej kod, sceny, treść, oprawa, narzędzia, testy i dokumentacja; bez `archive_retired_web/`, snapshotów i wygenerowanego cache `.godot/`

---

## 1. Cel i definicja słowa „wszystko”

Pakiet ma ponownie sprawdzić grę od zera, nie odziedziczyć werdyktów z PKG-0177..0180. „Wszystko” oznacza każdą inspectowalną powierzchnię aktualnego produktu:

1. shell, zimne otwarcie, pauza, ustawienia, zapis, kontynuacja, reset i napisy końcowe;
2. pełną trasę 01–18 → 42A/B/C → 43 oraz wszystkie trzy finały;
3. każdy aktywny skrypt, scenę, zasób, import, tekst widoczny dla odbiorcy, generator audio, test i narzędzie;
4. grafikę, kompozycję, skalę, kolor, kontrast, pixel-grid, portrety, postacie, rekwizyty, UI i czytelność przestrzeni;
5. ruch, animacje, kamerę, kolizje, progi, drabiny, schody, Anchor/Yield, interakcje, guidance i sprzężenie zwrotne;
6. narrację, chronologię wiedzy, ciągłość, dialogi, myśli, słownictwo PL/EN, głosy postaci i realia fachowe;
7. audio, haptykę, dostępność, wydajność, pamięć, deterministyczność, odporność save oraz jakość samych testów;
8. propozycje napraw, ulepszeń i nowych pomysłów, które przejdą bramkę kanonu, ryzyka i dowodu.

Kompletność nie jest deklaracją. Powstaje `coverage_manifest.tsv`, w którym każdy element dostaje właściciela strumienia, metodę, dowód i status `PASS`, `FINDING`, `NOT_APPLICABLE` albo `BLOCKED`. Pakiet nie może się zamknąć z pustym statusem.

### Stan wejściowy wymagający ponownego sprawdzenia

Świeży baseline 2026-09-03 zakończył się `Verification passed.` i M1 20/20 w 188,1 s symulacji, ale wiele historycznych bramek wypisało `ObjectDB instances were leaked at exit` (2–21 instancji), a ostatnia bramka PKG-0180 wypisała 4. Jest to sprzeczne z dokumentacyjną deklaracją „eliminacji wycieków ObjectDB”. PKG-0182 ma ustalić źródła, naprawić je albo jawnie skorygować dokumentację i politykę akceptacji. Exit code 0 nie zamyka tego findingu.

---

## 2. Granice i zasady dowodu

### 2.1 Twarde granice

- Wyłącznie Godot 4.7.x, GDScript i natywna gra PC (D-098). Zero webu, HTML/CSS/JS, PWA, portalu i dystrybucji przeglądarkowej.
- Brak Git (D-016). Dysk jest źródłem stanu; edycje są zapisywane natychmiast.
- Zero nowych `.exe` i zero zdjęcia GATE-REL bez osobnego polecenia właściciela (D-168).
- Zero przeszkód arcade (D-099). Każdą fizyczną trudność da się opisać zdaniem o świecie bez słowa „gracz”.
- Nie rozszerzać wspólnych monolitów. Nowe zachowanie jest lokalnym komponentem albo małym modułem z co najmniej dwoma realnymi użyciami.
- Zachować 640×360, 60 Hz, semantyczny InputMap, ostry tekst i osobno pikselizowany świat.
- Bieżący `WORLD_SCALE.md` jest jedynym źródłem metra; nie kopiować starszej wartości 54 px z historycznych planów.

### 2.2 Klasy dowodu

Każdy finding i werdykt otrzymuje jedną z klas:

| Klasa | Co wolno stwierdzić | Minimalny dowód |
|---|---|---|
| `RUNTIME-MEASURED` | fakty o działającym buildzie edytorowym | surowy log/trace, liczba, data, sprzęt i komenda |
| `RENDER-MEASURED` | fakty o pikselach, geometrii i widoczności | świeży capture normalnym driverem + metoda pomiaru |
| `AUDIO-MEASURED` | fakty o poziomie, klipie, czasie i routingu | zapis próbek/busów + liczby |
| `TEXT-AUDITED` | fakty o obecności, spójności i poprawności tekstu | pełny ekstrakt + identyfikator kwestii i źródło |
| `CONTRACT-PASS` | zgodność z jawnym kontraktem projektu | test z kontrolą pozytywną i negatywną |
| `RESEARCH-SUPPORTED` | decyzja zgodna z aktualnym źródłem zewnętrznym | cytowane źródło pierwotne/instytucjonalne + data dostępu |
| `HEURISTIC` | powtarzalna ocena ekspercka lub modelowa | rubryka, kryteria i jawne ograniczenie |
| `OPEN-NO-EVIDENCE` | hipoteza odbiorcza | zapis braku dowodu i tani plan odwrotu |

Zakazane są wnioski „ładne”, „czytelne dla człowieka”, „straszne”, „wciągające”, „zabawne” lub „emocjonalnie działa” na podstawie automatu, obrazu ocenionego przez model albo własnego przejścia autora. Zgodnie z D-012 i ADR-003 brak zewnętrznych playtestów pozostaje ograniczeniem. W zamian pakiet ma maksymalizować dowody inne niż odbiorcze: pomiary, pełne trace'y, inspekcje obrazu i dźwięku, testy negatywne, badanie źródeł oraz jawne rubryki heurystyczne.

### 2.3 Reguła researchu

- Research jest obowiązkowy przed zmianą normy, terminologii, pipeline'u, dostępności albo metody pomiaru.
- Dla Godot używać dokumentacji zgodnej z 4.7 lub sprawdzić różnicę wersji. Dla zagadnień technicznych preferować dokumentację oficjalną i publikacje pierwotne.
- Dla dostępności użyć aktualnych Xbox Accessibility Guidelines jako checklisty gry; WCAG może być źródłem progów pomiarowych, ale nie wolno przedstawiać gry desktopowej jako „zgodnej z WCAG”.
- Dla polskich realiów, kolei, utrzymania ruchu i języka epoki preferować archiwa, normy, instytucje, słowniki i materiały branżowe. Nie tworzyć faktów historycznych z pamięci modelu.
- Każda ważna decyzja ma cytat/link, datę dostępu, zakres zastosowania i ograniczenie. Snippet wyszukiwarki nie jest źródłem.

---

## 3. Artefakty dowodowe PKG-0182

Wszystkie raporty generowane trafiają do `reports/pkg_0182/`; dokument syntetyczny do `docs/rebuild/PKG_0182_COMPREHENSIVE_AUDIT_REPORT.md`.

| Artefakt | Zawartość |
|---|---|
| `inventory.tsv` | każdy plik w zakresie, typ, aktywność runtime, hash i właściciel audytu |
| `coverage_manifest.tsv` | powierzchnia → metoda → dowód → status → finding/fix |
| `findings.tsv` | ID, ważność P0–P3, klasa dowodu, reprodukcja, przyczyna, naprawa, retest |
| `baseline.log` / `final.log` | pełne, nieprzefiltrowane wyjście weryfikacji |
| `research_ledger.md` | pytanie, źródło, data, wniosek, ograniczenie, decyzja |
| `runtime_routes/` | trace nowej gry, continue, minimal/full/mixed i A/B/C |
| `visual/` + `visual_matrix.tsv` | wymagane kadry i pomiary wszystkich powierzchni |
| `animation/` + `animation_matrix.tsv` | stripy/klatki przejść wszystkich stanów i ich werdykty |
| `text/` + `language_ledger.tsv` | wszystkie teksty PL/EN, mówca, miejsce, funkcja, finding |
| `audio/` + `audio_matrix.tsv` | generatory, busy, routing, piki, klip, ducking i kanał alternatywny |
| `performance.tsv` | startup, frame time p50/p95/p99, pamięć, obiekty, draw calls, audio voices |
| `test_integrity.tsv` | bramka, czego dowodzi, kontrola negatywna, warning policy, fałszywy pass |
| `idea_ledger.md` | kandydat → źródło problemu → zgodność z kanonem → decyzja → wdrożenie → dowód |

Raporty nie stają się ręcznie utrzymywanym drugim źródłem prawdy. Testy i narzędzia muszą pozwalać je odtworzyć.

---

## 4. Plan atomowy

Każdy krok jest mały, kończy się zapisem na dysk i własnym sprawdzeniem. Checkpoint nie kończy bundle'u; służy wyłącznie do wykrycia regresji wcześnie.

### Faza A — źródło prawdy, baseline i kompletność

#### Krok A1 — lektura i routing

Przeczytaj w kolejności `AGENTS.md`, `INDEX`, `CURRENT_STATE`, `NEXT_SESSION_PROMPT`, ten plan, aktywne kontrakty P9, ADR-003/008, `WORKFLOW` oraz źródła wymienione w prompcie.

**Akceptacja:** spis źródeł prawdy i wykrytych sprzeczności zapisany w raporcie.  
**Weryfikacja:** każda sprzeczność ma ścieżkę i cytat/linię.  
**Zależności:** brak.

#### Krok A2 — uruchomienie skilli

Przeczytaj w całości wskazane w prompcie skille: audyt Godot, QA, design/UI/game feel, wydajność, audio, narrację, polszczyznę i — tylko gdy potrzebna jest grafika — image generation.

**Akceptacja:** `skill_usage` w raporcie mapuje każdy użyty skill na decyzje lub testy.  
**Weryfikacja:** brak deklaracji użycia skilla bez odczytanego `SKILL.md`.  
**Zależności:** A1.

#### Krok A3 — świeży baseline

Uruchom pełne `tools/verify.ps1`, zapisując stdout/stderr, czas, exit code oraz wszystkie wystąpienia `ERROR`, `SCRIPT ERROR`, `WARNING`, `ObjectDB`, `leaked`, `orphan` i `RID`.

**Akceptacja:** nieprzefiltrowany `baseline.log` i tabela ostrzeżeń.  
**Weryfikacja:** liczba warningów z tabeli zgadza się z logiem.  
**Zależności:** A1.

#### Krok A4 — pełny inventory

Zbuduj listę plików `scripts/`, `scenes/`, `assets/`, `tests/`, `tools/`, `docs/`, konfiguracji projektu i lokalizacji. Wyłącz wyłącznie zakresy jawnie martwe lub generowane.

**Akceptacja:** każdy plik ma typ, hash, rolę i status aktywności.  
**Weryfikacja:** ponowne `rg --files` nie znajduje elementu bez wpisu.  
**Zależności:** A1.

#### Krok A5 — macierz powierzchni produktu

Rozpisz wszystkie wejścia shellu, adresy, warianty finałów, stany ustawień, urządzenia wejścia, języki i tryby ruchu.

**Akceptacja:** każda osiągalna kombinacja ma test lub jawne `BLOCKED/NOT_APPLICABLE`.  
**Weryfikacja:** zgodność z `CAMPAIGN_ROUTE`, scenami i InputMap.  
**Zależności:** A4.

### Checkpoint A

- baseline zakończony i nie zredukowany do exit code;
- 100% inventory ma status;
- historyczne „PASS” pozostają hipotezą, dopóki nowy dowód ich nie odtworzy.

### Faza B — jakość verifiera, kodu i danych

#### Krok B1 — audyt każdej bramki

Dla każdego testu zapisz zakres, setup, teardown, izolację save/settings, prawdziwość czasowników gracza i obecność negatywnej kontroli.

**Akceptacja:** żadna bramka bez opisu „czego nie dowodzi”.  
**Weryfikacja:** co najmniej jedna kontrolowana awaria pokazuje, że każda bramka krytyczna potrafi upaść; po teście mutacja jest cofnięta przez jawny patch, nie Git.  
**Zależności:** A3–A5.

#### Krok B2 — polityka warningów

Rozdziel warningi oczekiwane (np. celowy malformed-save fallback) od niedopuszczalnych. Weryfikator ma failować na `SCRIPT ERROR`, parser errors, nierozliczone ObjectDB/RID leaks i nowe ostrzeżenia spoza allowlisty z uzasadnieniem.

**Akceptacja:** zero cichego „PASS” sprzecznego z logiem.  
**Weryfikacja:** syntetyczny niedopuszczalny wpis powoduje FAIL parsera logu.  
**Zależności:** B1.

#### Krok B3 — lifecycle i ObjectDB

Uruchom bramki z `--verbose`, wskaż klasy/instancje, odtwórz wycieki w minimalnych harnessach, napraw sygnały, timery, tweeny, audio i sceny osierocone po przejściach.

**Akceptacja:** zero nierozliczonych ObjectDB/RID leaks w pełnym verifierze.  
**Weryfikacja:** co najmniej trzy cykle load/use/free dla każdej naprawionej klasy + full final log.  
**Zależności:** B2.

#### Krok B4 — architektura i jakość GDScript

Sprawdź typowanie, odpowiedzialności, monolity, połączenia sygnałów, duplikację, zależności scen, stałe, błędy asynchroniczne i ścieżki wyjątków.

**Akceptacja:** każdy finding ma minimalną naprawę zgodną z istniejącą architekturą.  
**Weryfikacja:** import, parser i testy jednostkowe zmienionych modułów.  
**Zależności:** A4.

#### Krok B5 — save/settings/migracje

Sprawdź nową grę, continue, reset, corrupted/truncated JSON, starsze schema, niezależność settings/campaign, trzy finały i serializację JSON-safe.

**Akceptacja:** brak utraty ustawień, fabrykowania faktów i softlocka po migracji.  
**Weryfikacja:** macierz round-trip z izolowanymi ścieżkami plików testowych.  
**Zależności:** B4.

### Checkpoint B

- wszystkie P0/P1 verifiera, lifecycle i zapisu naprawione;
- brak osłabionych asercji;
- gate potrafi wykryć kontrolowaną regresję.

### Faza C — pełne przejścia i mechaniki

#### Krok C1 — shell do pierwszej czynności

Zmierz cold start, focus klawiatury/pada, `Nowa gra`, `Kontynuuj`, ustawienia, pause/resume, restart i cold open w trybie zwykłym/reduced motion.

**Akceptacja:** żadna ślepa uliczka focusu, podwójne wejście ani utrata stanu.  
**Weryfikacja:** trace wejść i timestampów, bez bezpośrednich wywołań metod sceny.  
**Zależności:** B5.

#### Krok C2 — trzy przebiegi trasy

Wykonaj od `Nowa gra`: minimalny, pełny i mieszany przebieg 20 adresów wyłącznie czasownikami gracza.

**Akceptacja:** wszystkie dochodzą do 43, a luki i fakty odpowiadają wykonanym czynnościom.  
**Weryfikacja:** trace adres/czas/akcja/stan przed-po; zero ręcznego ustawiania flag.  
**Zależności:** C1.

#### Krok C3 — trzy finały

Przejdź A/B/C od legalnego stanu kampanii, sprawdź konsekwencje siedmiu podmiotów, zapis i epilog.

**Akceptacja:** 3/3 osiągalne i bez moralnego kodowania kolorem/punktami.  
**Weryfikacja:** osobny trace, save round-trip i capture dla każdego wariantu.  
**Zależności:** C2.

#### Krok C4 — Anchor/Yield i feedback

Sprawdź neutralny, Anchor, Yield, błędną bezpieczną próbę, korektę, koszt, zgodę i brak spamu wejścia.

**Akceptacja:** przyczyna, reakcja świata i zapis są spójne; nie powstaje nowy czasownik ruchu.  
**Weryfikacja:** stan przed-po, negatywne kontrole i obrazy trzech stanów.  
**Zależności:** C2.

#### Krok C5 — trawers, kolizje i kamera

Sprawdź oba kierunki na każdym stopniu, drabinie, windzie, progu i ReturnZone; testuj krawędzie wejścia, zmianę kierunku, zatrzymanie i reduced motion.

**Akceptacja:** zero zacięć, teleportów, lotu, kurzu lądowania, clippingu i utraty kadru.  
**Weryfikacja:** pozycje fizyczne per frame + stripy animacji + lint D-099.  
**Zależności:** C2.

#### Krok C6 — input i haptyka

Porównaj klawiaturę i pad, remapping, konflikty bindingów, deadzone, focus, rumble on/off i brak zależności od jednego urządzenia.

**Akceptacja:** parytet wszystkich semantycznych akcji; brak hardcoded gameplay keys.  
**Weryfikacja:** inspekcja InputMap + runtime injection; fizyczny pad `BLOCKED`, jeśli go nie ma.  
**Zależności:** C1.

### Faza D — obraz, UI i animacja

#### Krok D1 — pełny capture matrix

Wyrenderuj normalnym sterownikiem każdy aktywny adres, cold open, shell, pauzę, ustawienia, dialog, myśl, Anchor/Yield i A/B/C w stanach normal/reduced motion oraz reprezentatywnych PL/EN.

**Akceptacja:** wszystkie wiersze `visual_matrix.tsv` mają świeży plik i hash.  
**Weryfikacja:** brak `SCRIPT ERROR`; rozdzielczość logiczna 640×360; obraz nie pochodzi ze starego reportu.  
**Zależności:** C1–C5.

#### Krok D2 — pomiary grafiki

Zmierz proporcje z `WORLD_SCALE`, zgodność collider/rysunek, pixel-grid, filtrację, alpha halos, clipping, overlap UI, kontrast tekstu, użycie koloru i rozróżnialność mono siedmiu rodzin.

**Akceptacja:** liczby i progi są zapisane, nie oceniane „na oko”.  
**Weryfikacja:** automatyczny raport + ręczna inspekcja każdego findingu.  
**Zależności:** D1 i research dostępności.

#### Krok D3 — audyt art-direction

Oceń każdy kadr wspólną rubryką: hierarchia, sylwetka, głębia, rytm, punkt uwagi, materiały, światło, akcent, spójność Rowien Pixel-Stage i tożsamość rodziny.

**Akceptacja:** każda ocena ma konkretne elementy kadru i status `HEURISTIC`.  
**Weryfikacja:** porównanie przed/po obok siebie dla każdej zmiany.  
**Zależności:** D1–D2.

#### Krok D4 — komplet animacji

Zarejestruj idle, start, stop, turn, walk, run, step up/down, jump/fall/land tam gdzie legalne, climb/mount/dismount, examine, carry, Anchor/Yield, enter door/vehicle i stany NPC.

**Akceptacja:** każdy stan i każde legalne przejście ma strip, czas, pivot i finding.  
**Weryfikacja:** test stabilności pivotu, stopy, loop seam, direction flip i stanów przerwanych.  
**Zależności:** D1.

#### Krok D5 — UI i dostępność wizualna

Sprawdź tekst, focus, prompt, oznaczenie mówcy, rozmiar, odstępy, kontrast, miganie, ruch, alternatywne kanały informacji i utrzymanie faktów w reduced motion.

**Akceptacja:** audyt względem jawnie wybranych XAG; WCAG tylko jako narzędzie pomiaru.  
**Weryfikacja:** scenariusze high/low contrast, mute, reduced motion, keyboard-only i controller-only.  
**Zależności:** D1–D2.

#### Krok D6 — naprawy i assety

Napraw wszystkie findings P0–P2 obrazu/animacji. Gdy potrzebny nowy raster, najpierw obejrzyj istniejący asset, użyj skilla imagegen i pipeline'u referencyjnego, zachowaj źródło/prompt/proweniencję oraz import nearest/lossless.

**Akceptacja:** brak prymitywów zastępujących anatomię, brak zmiany stylu, każdy asset ma dowód before/after.  
**Weryfikacja:** import Godot, alpha/paleta/skala, capture normal-driver i test regresji.  
**Zależności:** D2–D5.

### Checkpoint D

- 100% aktywnych powierzchni ma świeży capture;
- 100% stanów animacji ma dowód albo jawne `NOT_APPLICABLE`;
- żaden finding wizualny nie jest zamknięty samym istnieniem pliku.

### Faza E — tekst, narracja i słownictwo

#### Krok E1 — pełny ekstrakt tekstów

Wyodrębnij wszystkie widoczne ciągi z GDScript, scen, lokalizacji, UI, napisów diegetycznych, dialogów, myśli, credits i komunikatów błędów.

**Akceptacja:** każdy ciąg ma ID, język, mówcę, adres, funkcję i źródło.  
**Weryfikacja:** skan źródeł nie znajduje tekstu widocznego dla odbiorcy poza ledgerem.  
**Zależności:** A4.

#### Krok E2 — poprawność PL/EN

Sprawdź ortografię, interpunkcję, typografię, odmianę, rejestr, spójność terminów i parytet znaczenia. Chroń identyfikatory, placeholdery, format i logikę.

**Akceptacja:** brak globalnych zamian; każda edycja jest lokalna i ma semantic diff.  
**Weryfikacja:** parser/build/runtime + lint chronionych tokenów.  
**Zależności:** E1.

#### Krok E3 — głosy postaci i naturalność

Oceń kwestie Marty, Jakuba, Wierzbickiej, sprzedawcy, sąsiadki i Leny pod kątem odrębności, podtekstu, konkretu zawodowego, ekspozycji i „języka instrukcji obsługi”.

**Akceptacja:** każda zmiana zachowuje fakt, zgodę, koszt i chronologię wiedzy.  
**Weryfikacja:** before/after, funkcja kwestii, status dowodu i odczyt w runtime.  
**Zależności:** E1–E2 oraz research słownictwa.

#### Krok E4 — ciągłość i tempo informacji

Porównaj `NARRATIVE_BIBLE`, `FULL_STORY`, `CONTINUITY_TRACKER`, `DIALOGUE_SCRIPT`, kod flag i fakty cold open. Zmierz czas pojawienia się faktów i zakazane przedwczesne ujawnienia.

**Akceptacja:** zero sprzecznych flag, podwójnych originów i ujawnień przed progiem.  
**Weryfikacja:** trace M5 + lint tekstu i stanu.  
**Zależności:** C2–C3, E1.

#### Krok E5 — minimalna ścieżka bez odczytów

Zbadaj, czy narracja zachowuje spójność strukturalną przy pominięciu opcjonalnych tekstów, nie myląc tego z ludzkim zrozumieniem.

**Akceptacja:** każde przejście ma jawny motyw działania lub oznaczony gap; H-048 nadal `OPEN-NO-EVIDENCE` w części odbiorczej.  
**Weryfikacja:** minimalny trace + mapa faktów dostępnych/nieobecnych.  
**Zależności:** C2, E4.

### Faza F — audio, wydajność i odporność

#### Krok F1 — inventory audio

Zmapuj każdy generator, player, bus, sygnał krytyczny, ambience, dialogue blip, krok, landing, Anchor/Yield, haptic i zasady duckingu.

**Akceptacja:** każdy element ma miejsce użycia, poziom i alternatywny kanał, jeśli niesie informację.  
**Weryfikacja:** skan wywołań + runtime event trace.  
**Zależności:** A4.

#### Krok F2 — pomiary audio

Zmierz peak, clipping, DC offset, pętle, przerwy, liczbę głosów, ducking attack/release, zrozumiałość sygnału względem tła i zachowanie mute.

**Akceptacja:** zero cyfrowego clippingu i osieroconych playerów; ważna informacja nie jest wyłącznie dźwiękowa.  
**Weryfikacja:** zapis liczb i kontrola na reprezentatywnych stacjach każdego profilu.  
**Zależności:** F1 i research Godot/XAG.

#### Krok F3 — real-driver performance

Zmierz startup oraz frame time p50/p95/p99 w shellu, cold open, każdej rodzinie, najbardziej obciążonej stacji i finałach. Mierz pamięć, obiekty, draw calls, particles, lights i audio voices.

**Akceptacja:** budżety pochodzą z aktywnego kontraktu albo są opisane jako pomiar bazowy, nie jako wymyślony standard.  
**Weryfikacja:** Godot Performance/profiler na normalnym driverze; headless tylko jako dane pomocnicze.  
**Zależności:** C2, D1.

#### Krok F4 — soak i deterministyczność

Wykonaj wielokrotne przejścia scen, reload, pause/resume, save/load oraz cache eviction.

**Akceptacja:** brak trendu wzrostowego pamięci/obiektów, brak state bleed i losowych różnic kontraktu.  
**Weryfikacja:** min. 3 cykle aktywnej trasy i jawna seria pomiarowa.  
**Zależności:** B3, B5, F3.

### Faza G — pomysły kreatywne i ich wdrożenie

#### Krok G1 — wygenerowanie kandydatów

Wygeneruj kandydatów w co najmniej pięciu osiach: obraz/przestrzeń, ruch/animacja, Anchor/Yield, audio/sensoryka, narracja/relacja oraz UI/dostępność. Każdy odpowiada na finding lub mierzalną lukę.

**Akceptacja:** brak pomysłu będącego ozdobą bez problemu, kopią cudzej sceny lub nowym systemem arcade.  
**Weryfikacja:** mapa finding → pomysł → oczekiwany sygnał → koszt/regresja.  
**Zależności:** B–F.

#### Krok G2 — bramka selekcji

Kandydat staje się `PROPOSED_FOR_IMPLEMENTATION` tylko jeśli: pasuje do kanonu, nie zdradza ontologii za wcześnie, ma tani rollback bez Git, nie rozszerza monolitu, ma mierzalne kryterium i mieści się w bundle'u. Pozostałe oznacz `REJECTED` z powodem.

**Akceptacja:** właściciel z góry akceptuje cały zbiór `PROPOSED_FOR_IMPLEMENTATION`; agent nie pyta ponownie.  
**Weryfikacja:** każdy przyjęty pomysł przechodzi wszystkie sześć filtrów.  
**Zależności:** G1.

#### Krok G3 — implementacja wszystkich przyjętych pomysłów

Wdrażaj po jednym pionowym wycinku: kod/scena/asset → test → runtime → capture/audio → dokumentacja. Po każdym zapisz stan.

**Akceptacja:** zero przyjętych pomysłów pozostawionych wyłącznie w backlogu.  
**Weryfikacja:** before/after i test negatywny dla każdego.  
**Zależności:** G2.

### Faza H — integracja i zamknięcie

#### Krok H1 — ponowny pełny audyt pokrycia

Zaktualizuj manifest po zmianach i ponownie sprawdź każdy wcześniejszy `FINDING`.

**Akceptacja:** P0/P1/P2 = 0 otwartych; P3 ma uzasadniony backlog; brak pustych statusów.  
**Weryfikacja:** automatyczny completeness check manifestu.  
**Zależności:** B–G.

#### Krok H2 — finalne przebiegi i media

Powtórz minimal/full/mixed, A/B/C, input/accessibility matrix, capture matrix, animation matrix, audio i performance.

**Akceptacja:** świeże dowody po ostatniej zmianie, nie przed nią.  
**Weryfikacja:** hashe/czasy w final report.  
**Zależności:** H1.

#### Krok H3 — dokumentacja prawdy

Uzgodnij raport, kontrakty, acceptance matrix, roadmap, decyzje, ryzyka, `CURRENT_STATE`, append-only `SESSION_LOG` i nowy `NEXT_SESSION_PROMPT` z faktycznym runtime.

**Akceptacja:** znikają sprzeczne statusy historyczne albo są jawnie opisane jako baseline historyczny.  
**Weryfikacja:** `verify_docs.ps1`.  
**Zależności:** H2.

#### Krok H4 — finalna bramka i snapshot

Uruchom `verify_docs.ps1`, pełny `verify.ps1`, przeskanuj final log, sprawdź artefakty i wykonaj snapshot PKG-0182.

**Akceptacja:** `Verification passed.`, zero niedopuszczalnych warningów/leaków, snapshot istnieje.  
**Weryfikacja:** sprawdzenie katalogu snapshotu i kluczowych plików.  
**Zależności:** H3.

---

## 5. Priorytety napraw

| Priorytet | Znaczenie | Reguła |
|---|---|---|
| P0 | utrata danych, crash, brak przejścia, złamanie hard rule | naprawić natychmiast przed dalszym audytem zależnym |
| P1 | fałszywy PASS, poważna sprzeczność produktu, accessibility blocker | naprawić w tym bundle'u przed szlifem |
| P2 | widoczny defekt jakości, języka, animacji, audio lub UX | naprawić w tym bundle'u |
| P3 | mała optymalizacja lub kosmetyka bez istotnego wpływu | naprawić, jeśli bezpieczna; inaczej jawny backlog |

Wykonawca nie może obniżyć priorytetu dlatego, że naprawa jest trudna, ani podnieść go dlatego, że pomysł jest atrakcyjny.

---

## 6. Ryzyka i zabezpieczenia

| Ryzyko | Wpływ | Zabezpieczenie |
|---|---|---|
| „Absolutnie wszystko” zamieni się w płytką checklistę | krytyczny | inventory i manifest z dowodem per element |
| gigantyczny bundle utraci spójność | wysoki | atomowe kroki, checkpointy co 2–4 kroki, pełny retest po każdym strumieniu |
| audit sam sobie zaliczy test | krytyczny | negatywne kontrole i test jakości verifiera |
| ocena modelu zostanie nazwana playtestem | krytyczny | klasy dowodu i `OPEN-NO-EVIDENCE` dla odbioru |
| research wniesie niezgodną normę | wysoki | źródło, wersja, zakres i ograniczenie przy każdej decyzji |
| poprawa grafiki rozbije Pixel-Stage lub tekst | wysoki | before/after, nearest/lossless, normal-driver capture, osobna warstwa tekstu |
| naprawa trawersu skręci w arcade | krytyczny | D-099, trzy pytania o przeszkodę, traversal lint |
| twórczy zakres urośnie bez końca | wysoki | tylko pomysły związane z findingiem i przechodzące sześć filtrów G2 |
| brak Git utrudni rollback | wysoki | małe patche, zapis po kroku, snapshot dopiero po pełnym finalu |
| ponowne użycie starych dowodów | wysoki | wszystkie dowody po dacie startu PKG-0182, stare tylko jako porównanie |

---

## 7. Definition of Done PKG-0182

Pakiet jest zamknięty wyłącznie wtedy, gdy:

1. manifest pokrywa 100% plików i powierzchni w zakresie;
2. wszystkie findings P0–P2 są naprawione i ponownie sprawdzone;
3. wszystkie przyjęte pomysły kreatywne są wdrożone, nie tylko opisane;
4. minimal/full/mixed oraz A/B/C przechodzą od prawdziwego `Nowa gra`/legalnego save czasownikami gracza;
5. każdy aktywny kadr i stan animacji ma świeży dowód;
6. wszystkie teksty PL/EN są w ledgerze i po audycie semantic-diff;
7. audio, accessibility, performance, lifecycle i test integrity mają wyniki liczbowe;
8. final log nie zawiera nierozliczonych `SCRIPT ERROR`, parser errors, ObjectDB/RID leaks ani nowych warningów;
9. dokumentacja odróżnia `TECHNICAL/MEASURED/HEURISTIC` od odbioru człowieka;
10. `CURRENT_STATE`, `SESSION_LOG`, `ROADMAP`, decyzje, ryzyka i `NEXT_SESSION_PROMPT` opisują stan po wdrożeniu;
11. `verify_docs.ps1` i `verify.ps1` przechodzą po ostatniej zmianie;
12. snapshot PKG-0182 istnieje i zawiera finalne kluczowe pliki;
13. nie powstał web, Git ani nowy `.exe`.

Nie wolno zamknąć pakietu zdaniem „wszystko sprawdzone” bez podania liczników pokrycia, testów, ograniczeń i ścieżek dowodowych.
