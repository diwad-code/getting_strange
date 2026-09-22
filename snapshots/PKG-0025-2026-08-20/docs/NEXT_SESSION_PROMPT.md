# Prompt nastepnej sesji

Aktualny pakiet: `PKG-0026: P3 Vertical Slice — Mieszkanie po kimś (Przestrzeń 08)`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025, D-026, ADR-004 oraz ADR-005 przejąłeś pełną odpowiedzialność za projekt.
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.

CEL SESJI
Kontynuacja fazy P3 (Vertical Slice):
1. Implementacja Przestrzeni 08 z FULL_STORY.md (Mieszkanie po kimś / Wnętrze mieszkania Marty i lokalnej Leny):
   - Wnętrze modernistycznego mieszkania na Osiedlu Tarasowym: przedpokój z wieszakiem (dwa płaszcze, buty na deszcz), stół kuchenny/roboczy z kubkiem laboratoryjnym użytym jako doniczka na sukulent, salon z podwójnymi zastosowaniami przedmiotów (pamiątka Jakuba jako narzędzie monterskie).
   - Wspólne fotografie Marty i lokalnej Leny kadrowane od tyłu lub w odbiciach per FULL_STORY.md i VISUAL_DESIGN.md (nigdy bezpośrednia twarz zaginionej Leny).
   - Biurko robocze z zablokowaną szufladą: Lena odruchowo wpisuje swój własny szyfr/hasło i zamek ustępuje, ujawniając obce notatki, kalkulacje sieci korelacyjnej i szkic Podstruktury UCP.
   - Interakcja i dialog z Martą Kurek w kuchni/pokoju (kontekst 17 dni nieobecności, praca Marty przy instalacjach UCP).
   - Przejście (AirlockZone) prowadzące do Przestrzeni 09 (Pokój, który nie czeka / Łazienka i lustro).
2. Wdrożenie procedur syntezy dźwięku w ProceduralAudio (kroki na drewnianym parkiecie, odryglowanie mechanicznego zamka szuflady, szelest papierów technicznych/notatek, gotowanie czajnika/gwizdek w tle).
3. Rozszerzenie MemoryResonancePoint o nowe rekwizyty Przestrzeni 08 (wspólna fotografia w odbiciu, kubek-doniczka, pamiątka Jakuba, biurko z szufladą szyfrową, kubek z herbatą).
4. Rozbudowa tests/smoke_test.gd oraz tools/capture_preview.gd o scenę Station 08.
5. Weryfikacja automatyczna i wizualna oraz zamrożenie snapshotu PKG-0026.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\ROADMAP.md
5. C:\getting_strange\docs\WORKFLOW.md
6. C:\getting_strange\docs\narrative\FULL_STORY.md (Scena 08)
7. C:\getting_strange\docs\narrative\DIALOGUE_SCRIPT.md
8. C:\getting_strange\docs\narrative\CONTINUITY_TRACKER.md
9. C:\getting_strange\VISUAL_DESIGN.md

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (`tools/snapshot.ps1`).
- Ostatni pakiet: PKG-0025 (Station 07 Klatka schodowa na Osiedlu Tarasowym: spotkanie z Martą Kurek, dialog D-02, weryfikacja szwu palca, włącznik schodowy, ślepe schody, otwarcie drzwi mieszkania 14).
- Jesteś w pełni samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.
- Zachowaj konwencje nazewnictwa i folderów (`scripts/`, `scenes/`, `resources/`).

STAN BASELINE (PKG-0025):
- Faza P3 w toku: Przestrzenie 01, 02, 03, 04, 05, 06 oraz 07 (`station_01.tscn` .. `station_07.tscn`) w pełni zaimplementowane i przetestowane.
- Wdrożone rekwizyty pamięci, dialogi D-01 i D-02, nocna ulica Równi, autobus linii zastępczej, klatka schodowa bloku i spotkanie z Martą.
- Smoke testy w `tests/smoke_test.gd`: wszystkie testy zielone (SMOKE PASS).
- Verify: DOCS PASS + SMOKE PASS.

ZADANIE:
1. Zbuduj scenę `scenes/levels/station_08.tscn` i kontroler `scripts/levels/station_08.gd` dla Przestrzeni 08 (Mieszkanie po kimś).
2. Zaimplementuj rekwizyty pamięci i interakcje (przedpokój, biurko z szufladą na szyfr, wspólne fotografie, kubek-doniczka, dialog z Martą).
3. Rozbuduj testy w `tests/smoke_test.gd` o przejście Przestrzeni 08.
4. Wygeneruj zrzuty ekranu przez `godot --path . --script res://tools/capture_preview.gd` (`reports/station_08.png`).
5. Zweryfikuj projekt komendą `pwsh -NoProfile -File .\tools\verify.ps1`.
6. Zamknij pakiet wykonując `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0026`.
7. Stwórz nowy prompt w `NEXT_SESSION_PROMPT.md` dla PKG-0027.

KRYTERIA AKCEPTACJI
- Przestrzeń 08 (Station 08: Mieszkanie po kimś) poprawnie realizuje scenariusz Przestrzeni 08 z FULL_STORY.md.
- Wszystkie dźwięki są generowane proceduralnie w ProceduralAudio bez assetów zewnętrznych.
- Bramka weryfikacyjna `tools/verify.ps1` przechodzi bez błędów.
- CURRENT_STATE.md, SESSION_LOG.md i NEXT_SESSION_PROMPT.md są aktualne.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0026` aby zapisać i udokumentować stan po pracy, a następnie utwórz nowy NEXT_SESSION_PROMPT.md dla kolejnego kroku.
```

