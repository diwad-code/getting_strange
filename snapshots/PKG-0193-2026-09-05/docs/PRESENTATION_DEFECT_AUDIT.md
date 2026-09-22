# Prezentacyjny Audyt Defektów (DEF-3 .. DEF-9)

**Data audytu:** 2026-09-02  
**Pakiet audytowy:** PKG-0171 (PHASE-07 / BUNDLE-25)  
**Cel:** Inwentaryzacja empiryczna defektów prezentacyjnych DEF-3 przez DEF-9 dla wszystkich 20 zdefiniowanych adresów kampanii (station_01 .. station_18, warianty station_42a/b/c, station_43) przed przystąpieniem do napraw w fazie PHASE-08.  
**Zasada pomiaru:** Wartości w tabeli pochodzą z bezpośredniego odczytu parametrów węzłów i skryptów w drzewie scen Godota (nie są szacunkami ani wartościami domyślnymi).

---

## 1. Tabela dowodowa defektów (20 adresów kampanii)

| Adres | Rodzina lokacji | DEF-3 Drzwi (kolizja / obrys) | DEF-4 Schody / Pochylnie | DEF-5 Drabiny (wys / szer) | DEF-6 Feedback (ciąg tekstowy) | DEF-7 Śluzy (L / P) | DEF-8 A/Y Props (stan) |
|---|---|---|---|---|---|---|---|
| station_01 | Domestic Interior | Brak ościeżnicy; ExitArea x:610-630 y:0-360 | Płaska posadzka (y=300); brak schodów | Brak | Puste ciągi znaków; brak toastu HUD | Spawn: (64, 300); Wyjście: x=620 (brak śluzy) | Brak rekwizytów |
| station_02 | Domestic Interior | DrawDoor proceduralny bez spójnego obrysu | Klatka schodowa: statyczne CollisionPolygon2D, brak stopni 8x12 px | Brak | Brak standaryzowanego powiadomienia | Spawn: (32, 290); Wyjście: x=608 (brak śluzy) | Brak rekwizytów |
| station_03 | Domestic Interior | Brama narysowana liniowo; brak ościeżnicy 16x32 | Bruk bramy; brak rampy standaryzowanej | Brak | Brak etykiety feedbacku | Spawn: (40, 296); Wyjście: x=600 (brak śluzy) | Brak rekwizytów |
| station_04 | Street Urban | Otwarta przestrzeń; brak drzwi tranzytowych | Rampa chodnikowa: kąt nieregularny (~12°) | Brak | Brak powiadomień interakcji | Spawn: (48, 280); Wyjście: x=610 (brak śluzy) | Brak rekwizytów |
| station_05 | Street Urban | Brak drzwi kubaturowych | Zejście podziemne: CollisionPolygon2D, strome (~42°) | Brak | Brak toastu HUD | Spawn: (50, 260); Wyjście: x=600 (brak śluzy) | Brak rekwizytów |
| station_06 | Street Urban | Okno kiosku (brak fizycznych drzwi wejścia gracza) | Płaski plac (y=296) | Brak | Dialog zza lady; brak statusu HUD | Spawn: (48, 296); Wyjście: x=608 (brak śluzy) | Brak rekwizytów |
| station_07 | Bazaar | Brama bazarowa; obrys nieregularny 28x54 | Nierówny bruk straganowy | Brak | Brak toastu HUD | Spawn: (40, 288); Wyjście: x=612 (brak śluzy) | Brak rekwizytów |
| station_08 | Bazaar | Brak drzwi | Płaska alejka bazarowa | Brak | Brak standaryzowanego powiadomienia | Spawn: (48, 290); Wyjście: x=604 (brak śluzy) | Brak rekwizytów |
| station_09 | Bazaar | Wrota magazynu: CollisionShape2D 16x32, przesunięcie 4 px | Rampa rozładunkowa: kąt 20° | LadderZone: 16x80 px (brak spójnego chwytu) | Brak toastu HUD | Spawn: (56, 284); Wyjście: x=596 (brak śluzy) | Skrzynia magazynowa rigid prop (brak tagu A/Y) |
| station_10 | Technical Decay | Właz techniczny / gródź grodziowa: 24x48 px, brak animacji | Brak schodów | Drabina szybu: 16x120 px | Brak toastu statusu | Spawn: (48, 270); Wyjście: x=600 (brak śluzy) | Zasuwa kanałowa (do adaptacji A/Y) |
| station_11 | Technical Decay | Gródź pancerna niespójna z siatką | Pomost stalowy z rampą zejściową (~28°) | Drabina techniczna: 16x96 px | Odczyty manometru w konsoli bez HUD | Spawn: (52, 276); Wyjście: x=604 (brak śluzy) | Dźwignia odciążająca (do adaptacji na Yield) |
| station_12 | Technical Decay | Drzwi ciśnieniowe bez ramy | Kładka nad zbiornikiem filtrów | Drabina inspekcyjna: 16x64 px | Brak toastu statusu | Spawn: (48, 264); Wyjście: x=608 (brak śluzy) | Przeciwwaga filtracyjna (do adaptacji A/Y) |
| station_13 | Institutional | Drzwi podwójne czytelni: wymiar 32x48 px, brak spójnej ościeżnicy | Korytarz ze schodami: stopnie nieregularne | Drabinka archiwalna: 14x72 px | Brak toastu HUD | Spawn: (44, 280); Wyjście: x=600 (brak śluzy) | Wózek z kartotekami (do adaptacji A/Y) |
| station_14 | Institutional | Drzwi wahadłowe czytelni | Płaski parkiet archiwalny | Drabina regałowa: 16x112 px | Etykieta statyczna czytelni | Spawn: (48, 288); Wyjście: x=608 (brak śluzy) | Prototyp ServiceLift / blokada szafy pancernej |
| station_15 | Institutional | Drzwi wyciszone gabinetu: 20x36 px | Płaska posadzka gabinetowa | Brak | Brak toastu HUD | Spawn: (52, 284); Wyjście: x=596 (brak śluzy) | Blokada sejfu ściennego |
| station_16 | Subterranean Transit | Wrota tunelu metra: szeroki otwór rewizyjny | Krawędź peronu: uskok 32 px bez rampy | Drabinka ewakuacyjna: 16x48 px | Brak toastu HUD | Spawn: (48, 272); Wyjście: x=612 (brak śluzy) | Wózek drezyny inspekcyjnej |
| station_17 | Subterranean Transit | Drzwi dyspozytorni z szybą: 16x32 px | Rampa peronowa (kąt 15°) | Brak | Brak standaryzowanego powiadomienia | Spawn: (48, 280); Wyjście: x=608 (brak śluzy) | Cięgno zwrotnicy peronowej |
| station_18 | Choice Threshold | Potrójne wrota wyboru metody: ExitA/B/C (x=590) | Płaska posadzka komory (y=280) | Brak | _record_feedback konsolowe, brak toastu | Spawn: (48, 280); Potrójne wyjście: x=590 | Pulpit prognoz (MethodCommitPost, MartaTruthTable) |
| station_42a | Threshold Anomalous | Portal anomaliowy A (Wymuszenie) | Pomiary zmiennej geometrii wektorowej | Brak | Brak toastu statusu | Spawn: (40, 260); Wyjście: x=600 | Rdzeń anomaliowy (Anchor) |
| station_42b | Threshold Anomalous | Portal anomaliowy B (Równowaga) | Pomiary zmiennej geometrii wektorowej | Brak | Brak toastu statusu | Spawn: (40, 260); Wyjście: x=600 | Rdzeń stabilizacyjny (Yield) |
| station_42c | Threshold Anomalous | Portal anomaliowy C (Wzajemność) | Pomiary zmiennej geometrii wektorowej | Brak | Brak toastu statusu | Spawn: (40, 260); Wyjście: x=600 | Rezonator dwustronny |
| station_43 | Threshold Anomalous | Otwarty brzeg Wisły (brak drzwi) | Schodkowe bulwary nadrzeczne | Brak | Napisy końcowe / cisza | Spawn: (48, 288); Punkt końcowy (tytuł) | Brak rekwizytów (wyciszenie) |

---

## 2. DEF-9: Fizyczna lokalizacja postaci (Decyzja D-194)

### 2.1. Przyjęte rozwiązanie: Wariant B (Fizyczna reprezentacja kluczowych postaci)

W ramach autorytetu Lead Programmer / Art Director zatwierdzono **Decyzję D-194 (Wariant B)**, eliminującą defekt DEF-9 polegający na bezcielesności postaci niezależnych.

1. **Marta w station_10 (Podziemia techniczne):**
   - Umiejscowienie fizyczne: Vector2(420, 296) — `MartaBlockout/Marta` (`CharacterVisualRig`, PKG-0172).
   - Zastępuje kółkowe figury w `_draw()`; trzy istniejące `MemoryResonancePoint` zostają.
   - Zachowuje budżet interakcji GATE-INT <= 3.
2. **Wierzbicka w station_11 (Stacja pomp):**
   - Umiejscowienie fizyczne: Vector2(380, 296) — `InstitutionalBlockout/Wierzbicka` (`seated`).
   - Utrzymuje wskaźnik interakcji <= 3.
3. **Jakub w station_12 (Komora filtrów):**
   - Umiejscowienie fizyczne: Vector2(320, 296) — `WorkshopBlockout/Jakub` (`work`).
   - Utrzymuje wskaźnik interakcji <= 3.

### 2.2. Rejestr długu techniczno-narracyjnego (Akceptowany, nieblokujący)

Dla dwóch pomniejszych postaci zachowano formę bezcielesną (głos / interakcja zza przeszkody):
- **Sprzedawca w kiosku (station_06):** Postać funkcjonuje jako głos z wnętrza kiosku przez okienko podawcze. Nie tworzy się pełnej fizycznej postaci stojącej na scenie.
- **Sąsiad w kamienicy (station_08 / station_02):** Interakcja przez uchylone drzwi / wizjer bez modelowania postaci na zewnątrz.

Dług ten został zarejestrowany jako świadoma decyzja produkcyjna niekolidująca z wymogami GATE-INT ani z głównym łukiem fabularnym.

---

## 3. Macierz referencyjna zrzutów „przed” (Baseline dla PHASE-08)

Poniższe zrzuty ekranu, wygenerowane skryptem 	ools/capture_pkg_0171.gd przy użyciu standardowego sterownika graficznego Windows, dokumentują stan wyjściowy przed wdrożeniem napraw defektów prezentacyjnych:

| ID Referencyjny | Adres / Scena | Rodzina lokacji | Dokumentowany defekt bazowy | Plik zrzutu w eports/pkg_0171/ |
|---|---|---|---|---|
| REF-01 | station_01 | Domestic Interior | DEF-3 (brak ościeżnicy wyjściowej) / DEF-6 | amily_domestic_interior_station_01.png |
| REF-02 | station_02 | Domestic Interior | DEF-4 (niestandaryzowane stopnie klatki schodowej) | defect_def4_stairs_station_02.png |
| REF-03 | station_04 | Street Urban | DEF-4 (pochylnia uliczna bez kąta referencyjnego) | amily_street_urban_station_04.png |
| REF-04 | station_06 | Street Urban | DEF-9 (kiosk bez postaci fizycznej — dług D-194) | defect_def9_kiosk_station_06.png |
| REF-05 | station_07 | Bazaar | DEF-3 (brama wejściowa bazaru bez ościeżnicy) | amily_bazaar_station_07.png |
| REF-06 | station_09 | Bazaar | DEF-5 (drabina magazynowa bez chwytów) / DEF-8 | defect_def5_ladder_station_09.png |
| REF-07 | station_10 | Technical Decay | DEF-9 (miejsce pozycjonowania Marty, x=420) | amily_technical_decay_station_10.png |
| REF-08 | station_11 | Technical Decay | DEF-9 (miejsce pozycjonowania Wierzbickiej, x=380) | defect_def9_wierzbicka_station_11.png |
| REF-09 | station_12 | Technical Decay | DEF-9 (miejsce pozycjonowania Jakuba, x=320) | defect_def9_jakub_station_12.png |
| REF-10 | station_14 | Institutional | DEF-5 (drabina czytelni 112 px) / DEF-8 (ServiceLift) | amily_institutional_station_14.png |
| REF-11 | station_16 | Subterranean Transit | DEF-4 (uskok peronowy 32 px bez rampy) / DEF-5 | amily_subterranean_transit_station_16.png |
| REF-12 | station_18 | Choice Threshold | DEF-3 (potrójne wrota wyjścia) / DEF-7 / DEF-8 | amily_choice_threshold_station_18.png |
| REF-13 | station_42a | Threshold Anomalous | DEF-7 (progi fazowe anomaliów) / DEF-8 | amily_threshold_anomalous_station_42a.png |
| REF-14 | station_43 | Epilogue | DEF-3 (horyzont) / DEF-6 (wyciszenie) | amily_epilogue_station_43.png |
