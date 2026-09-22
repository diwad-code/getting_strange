# Prompt nastepnej sesji

Aktualny pakiet: `PKG-0029: P3 Vertical Slice — Pierwsza korekta (Przestrzeń 11 / Dziedziniec i interwencja UCP)`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025, D-026, ADR-004 oraz ADR-005 przejąłeś pełną odpowiedzialność za projekt.
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.

CEL SESJI
Otwarcie Aktu II fabuły (Korekta) i implementacja Przestrzeni 11 z FULL_STORY.md (Pierwsza korekta / Dziedziniec za osiedlem widziany z okna korytarza technicznego):
1. Implementacja Przestrzeni 11 w scenes/levels/station_11.tscn i scripts/levels/station_11.gd:
   - Przestrzeń dwupoziomowa / kompozycja: podwyższony korytarz techniczny z panoramicznym oknem obserwacyjnym na dziedziniec oraz schody / rampa prowadząca na poziom dziedzińca z płytami chodnikowymi i murem osiedlowym o świcie (chłód poranka, blady błękit i mgła).
   - Zdarzenie fabularne i obserwacja interwencji UCP (Clue R-03):
     - Zespół techniczny UCP (2 operatorów w szarych kombinezonach instytucjonalnych z aparaturą korekcyjną) pomaga zdezorientowanej starszej kobiecie powtarzającej, że budynek miał inne wejście.
     - Po przeprowadzeniu spokojnej procedury stabilizacji kobieta uspokaja się i bezpiecznie trafia do klatki schodowej.
     - Jednocześnie z muru dziedzińca bezpowrotnie znika ślad / obrys dawnych drzwi (#geometry-restless-grid) — korekta wygładza fakt bez przemocy, ocalając człowieka, lecz usuwając pamięć przestrzeni.
   - Dialog i rezonans Marty Kurek:
     - Marta dołącza w oknie korytarza i przyznaje, dlaczego zgłosiła zaginięcie lokalnej Leny: „Zgłosiłam ją, bo bałam się, że skończy jak te drzwi. Że jeśli nikt jej nie poszuka, nikt nie zauważy, kiedy zniknie szew.”
   - Rekwizyty pamięci w MemoryResonancePoint:
     - `ObservationWindow`: okno obserwacyjne na dziedziniec z widokiem na operację UCP,
     - `ErasedDoorwayTrace`: fragment muru z zacierającym się obrysem dawnego wejścia,
     - `UcpInterventionTeam`: sylwetki operatorów UCP z aparaturą pomiarową,
     - `ElderlyResidentGuide`: ścieżka powrotu kobiety do bezpiecznego lokalu,
     - `MartaObservationDialogue`: interakcja z Martą odsłaniająca motyw zgłoszenia zaginięcia,
     - `CourtyardExitAirlock`: przejście ku Przestrzeni 12 (Pokaz bezpieczeństwa / Przejście podziemne).
2. Wdrożenie procedur syntezy dźwięku w ProceduralAudio:
   - `create_morning_ambience_sound()`: chłodny powiew porannego wiatru i mgły z odległym szumem miasta (80 Hz rumble + 950 Hz filter);
   - `create_ucp_stabilizer_beam_sound()`: cichy, modulowany impuls rezonansu stabilizatora polowego UCP (330 Hz z harmoniczną 660 Hz i modulacją 4 Hz);
   - `create_masonry_smooth_sound()`: subtelny mineralny szmer zacierania spoiny ceglanej / zanikania śladu drzwi w murze (1800->600 Hz z szumem ziarnistym);
   - `create_dialogue_elderly_woman_sound()`: cichy, drżący głos starszej mieszkanki (480 Hz z wibrato 6 Hz).
3. Rozbudowa tests/smoke_test.gd oraz tools/capture_preview.gd o scenę Station 11 (`reports/station_11.png`, `reports/station_11_intervention.png`).
4. Weryfikacja automatyczna i wizualna oraz zamrożenie snapshotu PKG-0029.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\ROADMAP.md
5. C:\getting_strange\docs\WORKFLOW.md
6. C:\getting_strange\docs\narrative\FULL_STORY.md (Scena 11: Pierwsza korekta)
7. C:\getting_strange\docs\narrative\CONTINUITY_TRACKER.md (Clue R-03: UCP realnie pomaga i realnie przenosi krzywdę)
8. C:\getting_strange\VISUAL_DESIGN.md (Akt II Korekta: administracyjna siatka, czystość, cynober i szara szałwia)

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (`tools/snapshot.ps1`).
- Ostatni pakiet: PKG-0028 (Station 10 Telefon Jakuba: domowy gabinet, dialog D-04 z żyjącym Jakubem, dzwoniący telefon bakelitowy, szpulowiec, tablica topologii, odryglowanie śluzy i domknięcie Aktu I).
- Jesteś w pełni samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.
- Zachowaj konwencje nazewnictwa i folderów (`scripts/`, `scenes/`, `resources/`).

STAN BASELINE (PKG-0028):
- Faza P3 w toku: Przestrzenie 01..10 (`station_01.tscn` .. `station_10.tscn`) w pełni zaimplementowane i przetestowane.
- Wdrożone rekwizyty pamięci, dialogi D-01 do D-04, mechaniki obserwacji, zsynchronizowane procedury audio.
- Smoke testy w `tests/smoke_test.gd`: wszystkie testy zielone (SMOKE PASS).
- Verify: DOCS PASS + SMOKE PASS.

ZADANIE:
1. Zbuduj scenę `scenes/levels/station_11.tscn` i kontroler `scripts/levels/station_11.gd` dla Przestrzeni 11 (Pierwsza korekta / Dziedziniec za osiedlem).
2. Zaimplementuj mechanikę obserwacji interwencji UCP, zacierania śladu drzwi w murze, dialogu z Martą oraz przejścia do Przestrzeni 12.
3. Rozbuduj testy w `tests/smoke_test.gd` o przejście Przestrzeni 11.
4. Wygeneruj zrzuty ekranu przez `godot --path . --script res://tools/capture_preview.gd` (`reports/station_11.png`, `reports/station_11_intervention.png`).
5. Zweryfikuj projekt komendą `pwsh -NoProfile -File .\tools\verify.ps1`.
6. Zamknij pakiet wykonując `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0029`.
7. Stwórz nowy prompt w `NEXT_SESSION_PROMPT.md` dla PKG-0030.

KRYTERIA AKCEPTACJI
- Przestrzeń 11 (Station 11: Pierwsza korekta) poprawnie realizuje scenariusz Przestrzeni 11 z FULL_STORY.md i reguły Aktu II z VISUAL_DESIGN.md.
- Wszystkie dźwięki są generowane proceduralnie w ProceduralAudio bez assetów zewnętrznych.
- Bramka weryfikacyjna `tools/verify.ps1` przechodzi bez błędów.
- CURRENT_STATE.md, SESSION_LOG.md i NEXT_SESSION_PROMPT.md są aktualne.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0029` aby zapisać i udokumentować stan po pracy, a następnie utwórz nowy NEXT_SESSION_PROMPT.md dla kolejnego kroku.
```
