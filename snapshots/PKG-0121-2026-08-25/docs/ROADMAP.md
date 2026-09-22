# Roadmapa: Getting Strange

Status: **AKTYWNA ROADMAPA 3.0 — RELACYJNA REWOLUCJA FABUŁY**  
Data: 2026-08-25  
Decyzja: `ADR-007`, `D-114`  
Szczegółowy plan wykonawczy: `CREATIVE_REBUILD_PLAN.md`

## Meta produktu

Ukończona, samodzielna gra narracyjna 2D w Godot 4.7 na Windows i Linux. Lena
wraca z rutynowego pomiaru do miasta, które przez długi czas wydaje się jej
własne. Dopiero po 21 przestrzeniach potrafi udowodnić, że żyje w innej
ciągłości; wtedy pierwsza tajemnica ustępuje drugiej: co zrobiła miejscowa Lena,
gdzie została uwięziona i kto zapłaci za rozdzielenie światów.

Meta obejmuje 43 adresy kampanii, pełny przebieg od tytułu do konsekwencji,
ludzką postać Leny, Rówień Pixel-Stage, ostre teksty, kontekstowe prowadzenie,
zapis, dostępność, buildy oraz jawny pakiet licencyjny.

Istnienie 43 scen technicznych nie jest content lockiem. Po D-114 droga do mety
prowadzi przez ponowne autorstwo kampanii według kanonu 0.3, nie przez
bezpośredni eksport istniejącej treści.

## Co zachowujemy, co przebudowujemy

| Obszar | Status | Decyzja |
|---|---|---|
| Godot 4.7, 640x360, 60 Hz, InputMap | zachowany | nie przepisywać bez regresji blokującej |
| ruch i fizyka `PrototypePlayer` | zachowane jako baseline | oddzielić mechanikę od produkcyjnego `LenaVisualRig` |
| shell, pauza, ustawienia i PL/EN UI | technicznie działają | utrzymać |
| zapis i topologia 01..41 → finał → 43 | technicznie działają | migrować treść bez zerwania trasy |
| proceduralne audio i CRT | infrastruktura | adaptować do scen 0.3 |
| Anchor Lab | techniczny prototyp | przenieść do kampanii od Station 22 |
| Lena, Marta, Jakub, Wierzbicka, UCP i Rówień | zachowany rdzeń | nowe cele, relacje i przyczynowość z biblii 0.3 |
| treść 01–43, stare dialogi i kadry | `LEGACY` | ponownie stworzyć sekwencjami |
| proceduralny rysunek Leny | `PLACEHOLDER` | zastąpić czytelnym rigem produkcyjnym |
| gładki Vector-Stage | częściowo zastąpiony | Pixel-Stage dla świata, ostre warstwy tekstu |

## P4-RB0 — Rebaseline kreatywny

Pakiet: **PKG-0116**  
Status: **ZAKOŃCZONY HISTORYCZNIE; KANON 0.2 ZASTĄPIONY PRZEZ D-114**

Pakiet ustanowił zachowywany szkielet techniczny, bramę Station 21/22, kontrakt
Leny, prowadzenie i architekturę Pixel-Stage. Jego kanon fabularny 0.2 był
projektem pośrednim. Audyt `NARRATIVE_SKILL_AUDIT_0_2.md` wykazał, że nie ma
wystarczającego silnika osobistego, aktywnej opozycji ani konkretnych finałów.

## P4-RB1 — Rewolucja narracji + audyt rekoncyliacyjny

Pakiet: **PKG-0117**  
Status: **ZAKOŃCZONY; RUNTIME 01–07 NIE JEST CONTENT LOCKIEM**

Jeden mega-pakiet łączy:

1. kanon narracyjny 0.3, audyt skilli i `ADR-007`;
2. rozpoznanie oraz klasyfikację zastanych zmian Foundation Slice;
3. techniczny smoke `LenaVisualRig`, `WorldPixelCompositor`, crisp text i
   `NarrativeGuidanceService`;
4. jawne oddzielenie użytecznej architektury od treści zdradzającej zwrot;
5. nowy plan wdrożenia zaczynający się od 01–07.

Bramka:

- kanon i roadmapa nie nazywają częściowego runtime ukończonym wycinkiem;
- wszystkie zastane elementy mają status `KEEP / ADAPT / RETIRE`;
- testy techniczne zachowują pokrycie, lecz nie dowodzą jakości artystycznej;
- pełna weryfikacja, inspekcyjny capture, dokumenty i snapshot są świeże.

## P4-RB2 — Foundation Slice 01–07

Pakiet: **PKG-0118**  
Status: **ZAKOŃCZONY**

- konflikt próbki Linii 4 i obietnicy Marty w 01;
- zwykłe obejście 02, wiadomość 03, przejazd 04 i znana ulica 05;
- dwa rozkłady 06 oraz kiosk/herbata dla Marty 07;
- produkcyjna anatomia i 13 stanów `LenaVisualRig`;
- działająca pikselizacja świata `WorldPixelCompositor`, ostre teksty `CrispDiegeticText` i omylne guidance `NarrativeGuidanceService`;
- usunięcie aktywnych anomalii, żywego Jakuba i jawnego UCP z prologu.

Bramka: 01–05 są całkowicie normalne, 06–07 mają wyłącznie racjonalizowalne
rysy, a trasa, zapis, restart, tekst, guidance i ruch przechodzą testy (exit code 0).

## P4-RB3 — Rysa i cudzy dom 08–13

Pakiet: **PKG-0119**  
Status: **ZAKOŃCZONY**


- numer czternaście, sąsiadka, klucz, fotografia, wiadomość głosowa i dwa
  różniące się wspomnienia;
- pierwsze ślady relacji Marty z miejscową Leną bez jawnej diagnozy;
- aktorski zestaw progów, oglądania, wahania i obronnej racjonalizacji;
- GuidanceBeats prowadzące do sprawdzenia hipotez, nie do przyjęcia prawdy;
- wszystkie czytelne napisy ponad kompozytorem.

Bramka: do końca 13 Lena wie, że nie potrafi wyjaśnić sprzeczności, ale nadal
nie wie, w jakim świecie jest. Każdy fakt ma przynajmniej jedną uczciwą
codzienną interpretację.

Dowód: `tests/pkg_0119_smoke_test.gd` PASS, `tools/verify.ps1` exit code 0,
świeże klatki `reports/station_08..13*.png`.

## P4-RB4 — Marta, UCP i rozpoznanie 14–23

Pakiet: **PKG-0120**  
Status: **ZAKOŃCZONY**

- konflikt Marty z przybyłą Leną, wspomnienie terenu, dokumentacja UCP i żywy
  Jakub;
- trzy niezależne rodziny dowodów i interaktywna synteza w Station 21;
- pierwsze `To nie jest mój świat` wyłącznie po spełnieniu kontraktu wiedzy;
- Station 22 rozpoczyna drugą tajemnicę i świadomy Anchor/Yield;
- Station 23 dostarcza pierwszy ślad miejscowej Leny, nie rozwiązanie.

Bramka: `world_recognized` wymaga kompletu dowodów, a `local_lena_search_started`
nie może zostać ustawione wcześniej niż po rozpoznaniu.

Dowód: `tests/pkg_0120_smoke_test.gd` PASS, `tools/verify.ps1` exit code 0,
świeże klatki `reports/station_14..23*.png`.

## P4-RB5 — Test wzajemny 24–30

Pakiet: **PKG-0121**  
Status: **ZAKOŃCZONY**

- kampanijna integracja Anchor/Yield z istniejącego prototypu;
- mechaniczne odtworzenie części próby miejscowej Leny;
- Marta i Jakub stawiają warunki oraz mogą odmówić udziału;
- widoczne koszty stabilizacji i trzy prognozy operacyjne;
- pętla obserwacja → hipoteza → czynność → konsekwencja w każdej przestrzeni.

Bramka: każda czynność ma funkcję świata, stan przed/po, uczciwą podpowiedź i
trwałą konsekwencję w zapisie; nie powstają przeszkody arcade.

Dowód: `tests/pkg_0121_smoke_test.gd` PASS, `tools/verify.ps1` exit code 0,
świeże klatki `reports/station_24..30*.png`.

## P4-RB6 — Rachunek Linii 4 31–38

Pakiet: **PKG-0122**  
Status: **NASTĘPNY**

- Wierzbicka jako aktywna, racjonalna przeciwniczka, nie automat ekspozycyjny;
- ujawnienie przenoszonego kosztu Linii 4 i warunku przerwania próby;
- miejscowa Lena odzyskuje sprawczość przez zapisane decyzje i stan sygnału;
- Marta oraz Jakub odmawiają roli nagrody lub długu;
- przygotowanie trzech metod bez zakodowanego „dobrego” finału.

Bramka: gracz zna przewidywane koszty dla obu Len, Marty, Jakuba, UCP i obu
ciągłości przed wejściem do finału.

## P4-RB7 — Metoda, konsekwencje i content lock 3.0

Pakiet: **PKG-0123**  
Status: **PLANOWANY**

- Station 39–41 jako zgody, ostatni impuls i trzy testy po działaniu;
- 42A wymuszenie powrotu, 42B zamknięcie Równi, 42C przejście wzajemne;
- 43 pokazuje konkretny stan obu Len, Marty, Jakuba, UCP i relacji światów;
- finalne animacje reakcji, dialogi, audio, indeks treści, credits i źródła;
- end-to-end od Nowej gry i Kontynuuj dla wszystkich wyników.

Bramka: brak aktywnej treści legacy; żadna rodzina zakończeń nie otrzymuje
większego czasu, pełniejszego epilogu ani ukrytej etykiety moralnej; pełny
przebieg, zapis, restart i ostre teksty przechodzą testy techniczne.

## P5 — Build i release candidate

Pakiety: **PKG-0124+**  
Status: **ZABLOKOWANY DO P4-RB7**

1. `export_presets.cfg`, numer wersji, ikony i buildy Windows/Linux.
2. Smoke na artefaktach i czysta instalacja.
3. Kontynuacja, reset, klawiatura/pad, ustawienia i dostępność.
4. Budżet wydajności kompozytora oraz kontrola skalowania.
5. Licencje, credits, manifest źródeł, clearance tytułu i release notes.
6. Archiwum release candidate oraz jawna lista P1/P2.

Nie otwieramy buildów wcześniej tylko dlatego, że shell technicznie działa.

## Bramki stałe każdego pakietu

- wyłącznie Godot; brak webu i Git;
- zgodność z kanonem przeszkód D-099;
- semantyczny InputMap, 60 Hz i 640x360;
- szybki restart i deterministyczny stan debug;
- zgodność `NARRATIVE_BIBLE` + `FULL_STORY` + `CONTINUITY_TRACKER` + dialogu;
- test dokumentacji, import i pakietowy smoke;
- dla zmian wizualnych: normal-driver capture i ręczna inspekcja świeżych kadrów;
- aktualne `CURRENT_STATE`, append-only `SESSION_LOG`, nowy handoff i snapshot;
- jasne rozdzielenie dowodów technicznych od hipotez odbiorczych.

## Warunek ukończenia roadmapy

Roadmapa kończy się dopiero na zweryfikowanym release candidate Windows/Linux.
Test, audyt tekstu ani render nie dowodzą strachu, zabawy, zrozumienia relacji
czy emocjonalnej uczciwości finału.
