# Ryzyka, hipotezy i przewidywania

Status: **ŻYWY REJESTR 3.0 PO D-114**  
Data: 2026-08-25

Implementacja, zielony test, audyt narracyjny i pojedynczy render nie zamieniają
intuicji o odbiorze w fakt. Model dowodu określa ADR-003: zewnętrzne playtesty
pozostają odłożone do końca produkcji, więc pytania o emocje są jawnie otwarte.

## Klasy dowodu

- `MIERZALNA` — może zostać rozstrzygnięta pomiarem, audytem tekstu, renderu lub
  testem automatycznym.
- `ODBIORCZA` — wymaga reakcji nowej osoby; obecnie pozostaje bez bezpośredniego
  dowodu.
- `KOSZTOWA` — wymaga zmierzonego czasu, wydajności albo budżetu.

## Statusy

- `UNTESTED` — brak wystarczającego dowodu;
- `TECHNICAL` — kontrakt działa technicznie, nie dowodzi doświadczenia;
- `MEASURED` — mierzalna hipoteza rozstrzygnięta podaną metodą;
- `ACCEPTED-RISK` — produkcja świadomie buduje na hipotezie odbiorczej;
- `OPEN-NO-EVIDENCE` — pytanie odbiorcze pozostaje otwarte i nie blokuje;
- `REFUTED` — dowód przeczy hipotezie;
- `RETIRED` — hipoteza straciła zastosowanie po zmianie kierunku.

`SUPPORTED` jest zarezerwowane dla powtarzalnego wyniku z udziałem ludzi i nie
jest obecnie używane.

## Aktywne hipotezy

| ID | Hipoteza | Klasa | Status | Dostępna metoda / granica |
|---|---|---|---|---|
| H-001 | Responsywność ruchu da się pogodzić z ciężarem nowej animacji Leny | MIERZALNA + ODBIORCZA | TECHNICAL | 13 stanów kluczowych i proporcje 44-52px weryfikowane w `pkg_0118_smoke_test.gd`; przyjemność ruchu bez dowodu |
| H-002 | Anchor/Yield ma dość znaczących zastosowań, by unieść drugą tajemnicę 22–41 | MIERZALNA + ODBIORCZA | TECHNICAL | wprowadzenie mechaniki w 22-23 (PKG-0120), obiekty `ObservedGlassTrace` (32), `DualWitnessFrame` (33) i `JakubRescueBulkhead` (38) zweryfikowane w `pkg_0123_smoke_test.gd`; pełny audyt 43 scen zakończony |
| H-003 | Narastanie 01–20 buduje niepokój bez zdradzenia rozwiązania i bez nudy | ODBIORCZA | ACCEPTED-RISK | mierzalne proxy: sufity wiedzy, lint terminów w 01-07 (PKG-0118), 08-13 (PKG-0119) i 14-20 (PKG-0120); emocja i nuda bez dowodu |
| H-004 | Obraz i dźwięk wskazują zdarzenie przed myślą Leny | MIERZALNA + ODBIORCZA | TECHNICAL | sekwencje show → reaction → thought w 01-07 (PKG-0118), 08-13 (PKG-0119), 14-23 (PKG-0120), 31-37 (PKG-0122) i 38-43 (PKG-0123); zrozumienie bez dowodu |
| H-005 | Pixel-Stage jest wydajny i powtarzalny w 43 scenach | KOSZTOWA | MEASURED | PKG-0130: p99 <= 14.448 ms na Intel Iris Xe (12 najcięższych scen, vsync off); 45/45 scen w budżetach obiektowych `ParticleBudget`; metoda i granica w `docs/PKG_0130_FRAME_BUDGET_REPORT.md`. Nie mierzy GPU AMD/NVIDIA ani Steam Deck. |
| H-006 | Omylne interpretacje Leny brzmią ludzko, nie jak arbitralne oszustwo | ODBIORCZA | ACCEPTED-RISK | cykl hipoteza -> sprawdzenie wdrożony w 01-20, z syntezą i zamknięciem 4 hipotez w Station 21; odbiór psychologiczny bez dowodu |
| H-007 | Lena pozostaje czytelną osobą w `640x360` po próbkowaniu świata do `320x180` | MIERZALNA + ODBIORCZA | TECHNICAL | sylwetka fasetowa, ciemne spodnie, jasny sweter i torba sprawdzone na klatkach 01-43 |
| H-008 | Marta, Jakub, miejscowa Lena i Wierzbicka zachowują własne cele przez 2,5–3,5 godziny | MIERZALNA + ODBIORCZA | TECHNICAL | odmowa Marty (14-15), odmowa Jakuba (20, 29), oferta Wierzbickiej (31), echo domowej Marty (35), granice Jakuba (37, 38) i negocjacje (40) przetestowane w `pkg_0123_smoke_test.gd`; emocjonalna waga bez dowodu |
| H-009 | Wierzbicka i UCP są skuteczną, racjonalną opozycją, a nie jednowymiarowym złem | ODBIORCZA | OPEN-NO-EVIDENCE | oferta asymilacji w 31, bilans Linii 4 w 36, kontrola maszynowni w 34 i obrona stabilności w 40 przetestowane w PKG-0122/PKG-0123; percepcja gracka bez dowodu |
| H-010 | Rozpoznanie w Station 21 jest uczciwe i nieprzedwczesne | MIERZALNA + ODBIORCZA | TECHNICAL | 3 rodziny dowodów, bramka `is_world_recognized` i lint terminów w 14-20 zweryfikowane w PKG-0120; zaskoczenie bez dowodu |
| H-011 | Trzy zakończenia nie kodują „golden ending” | MIERZALNA + ODBIORCZA | TECHNICAL | bilans kosztów, brak hierarchii moralnej w konsolach 41, osobne epilogi 42A, 42B, 42C i stan podmiotów w 43 zweryfikowane technicznie w `pkg_0123_smoke_test.gd`; moralny odbiór bez dowodu |
| H-012 | Wszystkie czytelne teksty pozostają ostre nad pikselizowanym światem | MIERZALNA | TECHNICAL | CrispDiegeticText w Layer 10 i brak draw_string w Layer 0 zweryfikowane we wszystkich 43 scenach w PKG-0118..PKG-0123 |
| H-013 | System myśli pomaga przy zastoju bez spamowania | MIERZALNA + ODBIORCZA | TECHNICAL | cooldown >= 8.0s, reset po postępie i zamykanie hipotez potwierdzone testem automatycznym |
| H-014 | Dwie różne relacje Marty z dwiema Lenami są zrozumiałe bez wykładu | MIERZALNA + ODBIORCZA | TECHNICAL | próg Marty (14), rozbieżność wspomnień (15), echo domowe (35) i zgody (38, 42A, 42B) przetestowane; zrozumienie bez dowodu |
| H-015 | Miejscowa Lena pozostaje sprawczą osobą mimo fizycznej nieobecności | MIERZALNA + ODBIORCZA | TECHNICAL | odchylenie rejestru w 22, notatka z warunkiem przerwania w 33, alokacja biograficzna w 34, żywy sygnał w 37 i rozstrzygnięcia w 39-42 potwierdzają ślady jej decyzji; poczucie obecności bez dowodu |
| H-016 | Druga tajemnica po Station 21 utrzymuje napięcie zamiast zamienić się w procedurę | ODBIORCZA | ACCEPTED-RISK | przejście z rozpoznania do poszukiwania miejscowej Leny i odkrycia rachunku Linii 4 (21-43); napięcie bez dowodu |
| H-017 | Kobieca sylwetka Leny 3.0 wzmacnia wiarygodność | MIERZALNA + ODBIORCZA | REFUTED (mierzalna) / OPEN-NO-EVIDENCE (odbiór) | Właściciel 2026-08-25: Lena nie wygląda jak kobieta i wygląda jak krasnoludek. Rig 3.0 `_draw()` ~66 px jest PLACEHOLDER. Następca: H-027 / D-122. |
| H-018 | Swobodne cofanie dwukierunkowe wspiera ciągłość przestrzenną | MIERZALNA + ODBIORCZA | REFUTED (mierzalna warstwa gracza) | API GSM istnieje; zero stacji emituje `previous_level_requested` (D-124). Gracz idzie tylko w prawo. |
| H-019 | Pejzaże dźwiękowe i wieloprofilowe oświetlenie AtmosphereRig podbijają immersję i poczucie podziemnej skali bez zewnętrznych assetów | MIERZALNA + ODBIORCZA | TECHNICAL | 12 syntezatorów ProceduralAudio i dynamiczne oświetlenie/cząsteczki zweryfikowane w `pkg_0126_smoke_test.gd`; odbiór nastroju bez dowodu |
| H-020 | Płynne tempo CRT (42 CPS + auto-advance) eliminuje znużenie tekstem przy zachowaniu retro-teletypowego klimatu | ODBIORCZA | ACCEPTED-RISK | parametryzacja tekstu, dynamiczne blipy i matryca mówców wdrożone w `CRTDialogueBox`; odbiór czytelniczy bez dowodu |
| H-021 | Pula dźwięków proceduralnych i automatyczne czyszczenie pamięci eliminują wycieki RAM przy wielogodzinnej sesji | MIERZALNA | TECHNICAL | buforowanie fal `ProceduralAudio.get_cached_sound()` i `clear_sound_cache()` w `GameStateManager` zweryfikowane w `pkg_0127_smoke_test.gd` |
| H-022 | Warstwowa separacja (Layer 10, 16, 20, 100, 110) oraz matryca kolorów zapewniają 100% czytelność tekstu we wszystkich trybach skalowania | MIERZALNA | TECHNICAL | audyt kontrastu WCAG (>= 4.5:1) i testy skalowania 85%..115% potwierdzone testem `pkg_0127_smoke_test.gd` |
| H-023 | Parzystość mapowania urządzeń (klawiatura + gamepad) i remap z zachowaniem drugiego typu wejścia zapobiegają uwięzieniu gracza | MIERZALNA | TECHNICAL | `_replace_event_of_matching_type` w `GameStateManager` oraz testy pad/key w `pkg_0128_smoke_test.gd` |
| H-024 | Długodystansowy soak test (2 pełne przejścia 45 scen kampanii) dowodzi pełnej odporności na fragmentację sterty i wycieki obiektów w wydaniu Golden Master | MIERZALNA | TECHNICAL | 2 pełne cykle 45 scen przetestowane bez błędów ze stabilnym buforem audio (19 wpisów) w `pkg_0128_smoke_test.gd` |
| H-025 | Audyt geometrii i drabiny eliminują zablokowania | MIERZALNA + ODBIORCZA | REFUTED przy progu 35 px | Audyt 35 px certyfikował blaty jako wejście. D-123 obniża próg do 18 px. Ponowny pomiar w PKG-0132. |
| H-026 | Snap kamery do siatki 2 px usuwa pelzanie pikseli przy drabinie i windzie bez kumulowanego dryfu | MIERZALNA + ODBIORCZA | TECHNICAL | 120 klatek off-grid = 0, dryf <= 1 komórka, wstrząs na siatce — `pkg_0130_smoke_test.gd`; odczucie gładkości bez dowodu |
| H-027 | Lena 4.0 (sprite `gen-ai`) czyta się jako dorosła kobieta w skali mebli | MIERZALNA + ODBIORCZA | UNTESTED | Metoda: capture Station 01 Lena+krzesło+drzwi vs `WORLD_SCALE.md` §4. Odbiór bez dowodu (ADR-003). |
| H-028 | Próg 18 px + drabina/winda usuwa skakanie po mieście z wymaganej trasy | MIERZALNA | UNTESTED | `geometry_audit.gd` próg 18; tabela `PLAYTHROUGH_TRAVERSAL_AUDIT.md`. |

## Ryzyka kontrolowanej przebudowy

| ID | Ryzyko | Prawdopodobieństwo | Wpływ | Odpowiedź |
|---|---|---|---|---|
| R-001 | Zbyt duże podobieństwo ruchu lub kadru do `Another World` | średnie | bardzo wysoki | zapożyczać zasady ciężaru i ekonomii, nie aktywa ani rozpoznawalne kadry; własny model sheet, timing, paleta i kostium |
| R-002 | Przebudowa zamieni się w pełny reset techniczny | średnie | bardzo wysoki | ADR-006/007 wyliczają systemy zachowane; przepisać komponent dopiero po wykazanej regresji blokującej |
| R-003 | Stary runtime nadal zdradza zwrot w migrowanym wycinku | wysokie | bardzo wysoki | lint terminów, mapa beatów, test flag; tekst legacy nie może pozostać na aktywnej ścieżce |
| R-004 | Station 01–05 są zwyczajne, lecz bez konfliktu i obietnicy działania | średnie | wysoki | konflikt zawodowy wokół próbki Linii 4, materialna procedura i relacja z Martą bez paranormalnej zapowiedzi |
| R-005 | Myśli Leny zastąpią projekt poziomu | wysokie | wysoki | pokaż → naprowadź → pomyśl → sprawdź; L2/L3 dopiero po zastoju |
| R-006 | Błędne myśli nauczą błędnej mechaniki | średnie | bardzo wysoki | omylna tylko interpretacja fabularna; obserwacja, sterowanie i cel czynności zawsze prawdziwe |
| R-007 | Pixel-art będzie globalnym filtrem bez kierunku | wysokie | wysoki | kompozytor + ręczne palety, siatka, dithering i kadry; zakaz automatycznego szumu |
| R-008 | Pikselizacja rozmyje dialog, terminale lub szyldy | wysokie | bardzo wysoki | ostre warstwy po kompozytorze; migracja czytelnych `draw_string()`; test screenshotów |
| R-009 | Nowa Lena nadal wygląda jak znacznik albo krasnoludek | pewne | bardzo wysoki | Zmaterializowane. D-122 + `WORLD_SCALE.md` + capture okiem, nie tylko smoke. |
| R-010 | Animacja Leny pochłonie plan | wysokie | bardzo wysoki | budżety poz, kluczowe stany najpierw, reużycie riga i jawny backlog wariantów |
| R-011 | Biblia, pełna historia, tracker, dialog i flagi rozjadą się | wysokie | bardzo wysoki | jeden zakres na pakiet, czterodokumentowy audyt, test flag i jeden snapshot |
| R-012 | Zachowany save schema uruchomi flagi legacy | średnie | wysoki | migrator lub jawne mapowanie przed 22; stare flagi nie ustawiają `world_recognized` |
| R-013 | Historyczne audyty zostaną potraktowane jak aktywny plan | średnie | wysoki | INDEX kieruje do 3.0; 0.2 ma jawny status odrzuconego projektu pośredniego |
| R-014 | Brak zewnętrznego odbiorcy ukryje niezrozumienie do końca produkcji | pewne | bardzo wysoki | jawne ograniczenia, tanie plany odwrotu i automaty tylko jako proxy; bez deklaracji odbioru |
| R-015 | Brak Git uczyni błędną migrację nieodwracalną | wysokie | bardzo wysoki | natychmiastowy zapis, append-only log i pakietowy snapshot |
| R-016 | Przeszkody skręcą w arcade | średnie | wysoki | D-099, test trzech pytań i traversal lint; maszyna musi mieć funkcję świata |
| R-017 | Build zostanie otwarty przed content lockiem 3.0 | średnie | wysoki | P5 zablokowane do PKG-0123 |
| R-018 | Zakończenia pozostaną abstrakcyjnymi nazwami systemów | średnie | bardzo wysoki | w 42–43 pokazać jawny stan obu Len, Marty, Jakuba, UCP i obu ciągłości |
| R-019 | Dwie Leny zleją się odbiorcy w jedną abstrakcję | wysokie | bardzo wysoki | osobne określenia robocze, relacje, sprawcze decyzje, nagrania i matryca stanów; unikać „oryginału” |
| R-020 | Relacja Marty zostanie odczytana jako trójkąt lub nagroda dla protagonistki | średnie | bardzo wysoki | Marta rozpoznaje różnicę, stawia granice i nie przenosi automatycznie relacji miejscowej Leny na przybyłą |
| R-021 | Nieudokumentowane zmiany Foundation Slice zostaną nadpisane albo fałszywie uznane za gotowe | wysokie | wysoki | klasyfikacja `KEEP/ADAPT/RETIRE`, świeży test i wpis PKG-0117 przed snapshotem |
| R-022 | Korelacja kosztów Linii 4 zostanie podana jako wygodne, nieudowodnione prawo metafizyczne | średnie | wysoki | rozdzielić zapis pomiarowy, hipotezę Leny i model UCP; finał nie daje wszechwiedzącej odpowiedzi |
| R-023 | Pakiety binarne będą zawierały zewnętrzne licencjonowane zasoby lub błędy eksportu | niskie | wysoki | Zero-Asset Architecture, czysta synteza GDScript, testy pakietu pkg_0124_smoke_test.gd i tools/export_builds.ps1 |
| R-024 | Drabiny lub windy skręcą w platforming precyzyjny (jump timing) | średnie | bardzo wysoki | Zakaz D-099; drabiny są ciągłymi strefami bez timingów, a windy mają sztywne krańcówki bez skoków |
| R-025 | Nadmiar proceduralnego audio lub cząsteczek obciąży mikser lub wątek renderera | niskie | wysoki | `ParticleBudget` 30 Hz na wszystkich emiterach; cache 18 tekstur świateł; pomiar p99 14.45 ms na Iris Xe; headless audit 45 scen |
| R-026 | Wycieki pamięci RAM / ObjectDB przy częstych zmianach scen w kampanii 43 przestrzeni | niskie | wysoki | Jawne zwalnianie `_exit_tree()` w AtmosphereRig i czyszczenie bufora audio `ProceduralAudio.clear_sound_cache()` w `GameStateManager.transition_to_scene()` |
| R-027 | Nadpisanie powiązań drugiego typu kontrolera podczas remappingu akcji | niskie | bardzo wysoki | Wdrożenie `_replace_event_of_matching_type` w `GameStateManager` zachowującego przypisania przeciwnego typu urządzenia (pad/key) |
| R-028 | Niespójności w bilingwalnych kluczach lokalizacji PL/EN lub creditsach | niskie | wysoki | Certyfikacja 100% symetrii słowników w `LocalizationManager` oraz audyt zgodności dialogów epilogu z `docs/LICENSES.md` w teście `pkg_0128_smoke_test.gd` |
| R-029 | Niedrożność geometrii w scenach kampanii lub zbyt wysokie stopnie blokujące ruch Leny | niskie | bardzo wysoki | Globalny audyt `geometry_audit.gd`, test wysokości barier (max 35 px) i certyfikacja 100% pokonywalności w `pkg_0129_smoke_test.gd` |
| R-030 | Snap kamery do siatki 2 px wprowadzi szarpanie kadru przy wolnym ruchu pionowym | niskie | średni | Autorytet float, snap tylko na wyjściu; strefa martwa 46 px; klamra w komorze = 1 widok zachowuje stare kadrowanie |
| R-031 | Certyfikat traweru 100% i Lena 3.0 ukryły niewgrywalność | pewne | bardzo wysoki | Zmaterializowane 2026-08-25. Odpowiedź: D-121..D-126, PKG-0132, unieważnienie certyfikatu 35 px. |
| R-032 | Sprite z `gen-ai` wyjdzie photoreal / chibi / Lester | średnie | bardzo wysoki | Karta postaci, osobne pozy, test dwóch klatek, zakaz siatki model-sheet, paleta Pixel-Stage. |

## Wczesne wskaźniki alarmowe

- Przed Station 21 pojawia się jawna diagnoza sytuacji.
- Po Station 21 pytanie „gdzie jestem?” nie zostaje zastąpione pytaniem o
  miejscową Lenę i koszt Linii 4.
- Marta mówi o obu Lenach tak samo lub nie stawia granicy przybyłej Lenie.
- Miejscowa Lena istnieje tylko jako plik potrzebny do rozwiązania zagadki.
- Jakub jest traktowany jako nagroda, dług albo dowód zamiast osoby ze zgodą.
- Wierzbicka przekazuje ekspozycję, ale nie podejmuje działań blokujących.
- Myśl pojawia się przed obserwacją albo podaje rozwiązanie jako pewnik.
- Czytelny tekst znajduje się pod `WorldPixelCompositor`.
- Dokument mówi „content lock”, choć aktywna trasa nadal zawiera legacy.
- Test lub render jest opisywany jako dowód strachu, zabawy lub zrozumienia.

## Jak aktualizować

Po pakiecie dopisz lub zmień:

- datę, metodę i surowy wynik pomiaru;
- zakres, którego wynik dotyczy;
- ograniczenie dowodu;
- zmianę statusu i wpływ na roadmapę;
- plan odwrotu, jeśli ryzyko się materializuje.

Nie ustawiaj `MEASURED` bez metody i nie ustawiaj `SUPPORTED` bez
powtarzalnego wyniku z udziałem ludzi.
