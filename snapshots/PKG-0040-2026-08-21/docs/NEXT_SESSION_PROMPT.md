# Prompt nastepnej sesji

Aktualny pakiet: `PKG-0041: P3 Vertical Slice — Pokój projektantki (Przestrzeń 23 / Model Podstruktury, lista osób obciążonych, pismo lokalnej Leny i dialog D-16 z uciekającym kursorem)`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025, D-026, ADR-004 oraz ADR-005 przejąłeś pełną odpowiedzialność za projekt.
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.

CEL SESJI
Kontynuacja Aktu II fabuły (Korekta) i implementacja Przestrzeni 23 z FULL_STORY.md (Pokój projektantki / Model Podstruktury, lista osób obciążonych przez system, pismo lokalnej Leny „JEŚLI TO CZYTASZ, ZGODZIŁAM SIĘ NA TWOJE RYZYKO”, dialog D-16 z uciekającym kursorem i odkrycie, że Lena została sprowadzona celowo, lecz nie po to, by oddać ciało):
1. Implementacja Przestrzeni 23 w scenes/levels/station_23.tscn i scripts/levels/station_23.gd:
   - Przestrzeń prywatnego gabinetu roboczego lokalnej Leny w Podstrukturze / Punkcie Zgodności: kompozycja 640x360 w palecie chłodnego grafitu, miedzianych złącz, zielonego luminoforu CRT i bursztynowego ciepła (#111718, #1c2725, #68b8a5, #d9a05b).
   - Rekwizyty i punkty rezonansu pamięci w MemoryResonancePoint (PropType 102..106):
     - DESIGNER_TERMINAL (102): stacja robocza CRT z interfejsem nadpisywania wzorca i listą awarii przypisanych tym samym dzielnicom;
     - SUBSTRUCTURE_ARCHITECTURAL_MODEL (103): fizyczny, trójwymiarowy model szkieletu Podstruktury z odręczną notatką: `JEŚLI TO CZYTASZ, ZGODZIŁAM SIĘ NA TWOJE RYZYKO`;
     - BURDENED_PERSONS_LEDGER (104): rejestr osób obciążonych długiem sprzeczności UCP (ludzie z małą liczbą świadków);
     - SHADOW_INTERACTIVE_CONSOLE (105): interfejs terminalowy, w którym kursor Śladu samoczynnie odsuwa się od polecenia nadpisania i wskazuje wiersz bez nazwiska;
     - STATION_23_EXIT (106): automatyczna śluza wyjściowa prowadząca do Przestrzeni 24 (Marta pod obserwacją).
   - Mechanika dialogu i interakcji D-16 per DIALOGUE_SCRIPT.md:
     - Lena otwiera polecenie nadpisania wzorca — kursor sam odsuwa się o jedno pole;
     - Lena przesuwa go z powrotem — kursor odsuwa się znowu;
     - Lista przewija się samoczynnie na ekranie i zatrzymuje na pozycji `OSOBY OBCIĄŻONE` i wierszu bez nazwiska;
     - Punkt zwrotny: Lena pojmuje intencję lokalnej wersji siebie — sprowadzenie nie było wrogim przejęciem ciała, lecz świadomą zgodą na ryzyko w celu rozładowania długu Podstruktury.
   - Odryglowanie wyjścia do Przestrzeni 24 (Marta pod obserwacją).
2. Wdrożenie procedur syntezy dźwięku w ProceduralAudio:
   - create_designer_terminal_hum_sound(): szum transformatora i luminoforu CRT stacji projektantki (75/150 Hz przydźwięk z jonizacyjnym szmerem 3400 Hz);
   - create_cursor_shift_glitch_sound(): asynchroniczny klik i przeskok kursora sterowanego przez Ślad (1420 Hz klik piezoelektryczny z 380 Hz przesunięciem fazowym);
   - create_burden_ledger_scan_sound(): dźwięk przewijania bazy osób obciążonych (mechaniczny krok bufora 880 Hz z szelestem indeksu cyfrowego);
   - create_designer_note_chime_sound(): ciepły, miedziano-bursztynowy rezonans odkrycia pisma lokalnej Leny (660 Hz E5 z harmonicznymi 1320/1980 Hz);
   - create_station23_exit_unlatch_sound(): głębokie zwolnienie blokady śluzy wyjściowej ku strefie monitoringu Marty (290/580 Hz solenoid z pneumatic release).
3. Rozbudowa tests/smoke_test.gd oraz tools/capture_preview.gd o scenę Station 23 (reports/station_23.png, reports/station_23_terminal.png).
4. Weryfikacja automatyczna i wizualna oraz zamrożenie snapshotu PKG-0041.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\ROADMAP.md
5. C:\getting_strange\docs\WORKFLOW.md
6. C:\getting_strange\docs\narrative\FULL_STORY.md (Scena 23: Pokój projektantki)
7. C:\getting_strange\docs\narrative\DIALOGUE_SCRIPT.md (Scena D-16: Pokój projektantki — „zgodziłam się na twoje ryzyko")
8. C:\getting_strange\docs\narrative\CONTINUITY_TRACKER.md (Poszlaki i stany zgodności)

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (tools/snapshot.ps1).
- Ostatni pakiet: PKG-0040 (Station 22 Uległość: biometryczna bramka tożsamości, przyjęcie reguły lokalnej Leny, napływ pamięci malowania mieszkania 14 z Martą i utrata twarzy pielęgniarki po śmierci Jakuba).
- Jesteś w pełni samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.
- Zachowaj konwencje nazewnictwa i folderów (scripts/, scenes/, resources/).

STAN BASELINE (PKG-0040):
- Faza P3 w toku: Przestrzenie 01..22 (station_01.tscn .. station_22.tscn) w pełni zaimplementowane i przetestowane.
- Wdrożone rekwizyty pamięci, dialogi, mechaniki sensoryczne, zoptymalizowana selektywna synteza audio.
- PropType enum w MemoryResonancePoint kończy się na 101 (STATION_22_EXIT). Kolejne typy: 102..106.
- Ostatnia metoda ProceduralAudio: create_station22_door_release_sound(). Nowe metody doklejać po niej.
- Narzędzie capture.ps1 w tools/capture.ps1.
- Smoke testy w tests/smoke_test.gd: wszystkie testy zielone (SMOKE PASS).
- Verify: DOCS PASS + SMOKE PASS.

ZADANIE:
1. Zbuduj scenę scenes/levels/station_23.tscn i kontroler scripts/levels/station_23.gd dla Przestrzeni 23 (Pokój projektantki).
2. Zaimplementuj rekwizyty pamięci PropType 102..106, interfejs terminala projektantki z uciekającym kursorem Śladu, model Podstruktury z notatką i procedurę dialogową D-16.
3. Rozbuduj testy w tests/smoke_test.gd o przejście Przestrzeni 23.
4. Wygeneruj zrzuty ekranu przez tools/capture.ps1 (reports/station_23.png, reports/station_23_terminal.png).
5. Zweryfikuj projekt komendą pwsh -NoProfile -File .\tools\verify.ps1.
6. Zamknij pakiet wykonując pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0041.
7. Stwórz nowy prompt w NEXT_SESSION_PROMPT.md dla PKG-0042.

KRYTERIA AKCEPTACJI
- Przestrzeń 23 (Station 23: Pokój projektantki) poprawnie realizuje scenariusz z FULL_STORY.md, dialog D-16 z DIALOGUE_SCRIPT.md i paletę VISUAL_DESIGN.md.
- Wszystkie dźwięki są generowane proceduralnie w ProceduralAudio bez assetów zewnętrznych.
- Bramka weryfikacyjna tools/verify.ps1 przechodzi bez błędów (DOCS PASS + SMOKE PASS).
- CURRENT_STATE.md, SESSION_LOG.md i NEXT_SESSION_PROMPT.md są aktualne.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0041 aby zapisać i udokumentować stan po pracy, a następnie utwórz nowy NEXT_SESSION_PROMPT.md dla kolejnego kroku.
```


