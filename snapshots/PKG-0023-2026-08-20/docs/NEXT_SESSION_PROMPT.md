# Prompt nastepnej sesji

Aktualny pakiet: `PKG-0024: P3 Vertical Slice — Linia zastępcza i autobus (Przestrzeń 06)`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025, D-026, ADR-004 oraz ADR-005 przejąłeś pełną odpowiedzialność za projekt.
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.

CEL SESJI
Kontynuacja fazy P3 (Vertical Slice):
1. Implementacja Przestrzeni 06 z FULL_STORY.md (Linia zastępcza / Autobus Linii 4):
   - Wnętrze nocnego autobusu zastępczego jadącego wzdłuż wyłączonej Linii 4 (kolebotał, deszcz na szybach, mijane nocne latarnie za oknami).
   - Środowiskowy głośnik z komunikatem instytucjonalnym UCP: „Prosimy nie utrwalać rozbieżności przez powtarzanie”.
   - Interakcja ze starszym pasażerem, który rozpoznaje Lenę i oddaje jej zgubioną złotą obrączkę.
   - Oględziny dłoni Leny (brak śladu po obrączce), reakcja na przedmiot i odłożenie go na sąsiednie siedzenie (obrączka powracająca w zakończeniu Uzgodnienia).
   - Dojazd do przystanku Osiedle Tarasowe i przygotowanie do wejścia w Przestrzeń 07 („Wróciłaś” / spotkanie z Martą Kurek).
2. Wdrożenie procedur syntezy dźwięku w ProceduralAudio (pomruk silnika autobusu, deszcz na szybie, komunikat głośnikowy z filtrem pasmowym).
3. Podpięcie przejścia ze sceny Station 05 do Station 06 oraz weryfikacja automatyczna i wizualna.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\ROADMAP.md
5. C:\getting_strange\docs\WORKFLOW.md
6. C:\getting_strange\docs\narrative\FULL_STORY.md (Scena 06)
7. C:\getting_strange\docs\narrative\DIALOGUE_SCRIPT.md
8. C:\getting_strange\VISUAL_DESIGN.md

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (`tools/snapshot.ps1`).
- Ostatni pakiet: PKG-0023 (Station 05 Rówień nocą: afisz 1978, budynek bez piętra, sygnał przejścia z imieniem Leny, restless grid zaułka, wiata przystankowa).
- Jesteś w pełni samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.
- Zachowaj konwencje nazewnictwa i folderów (`scripts/`, `scenes/`, `resources/`).

STAN BASELINE (PKG-0023):
- Faza P3 w toku: Przestrzenie 01, 02, 03, 04 oraz 05 (`station_01.tscn`, `station_02.tscn`, `station_03.tscn`, `station_04.tscn`, `station_05.tscn`) w pełni zaimplementowane i przetestowane.
- Wdrożone rekwizyty pamięci, dialog D-01, mechanika kołowrotu, nocna ulica Równi, sygnał przejścia i restless grid.
- Smoke testy w `tests/smoke_test.gd`: wszystkie testy zielone (SMOKE PASS).
- Verify: DOCS PASS + SMOKE PASS.

ZADANIE:
1. Zbuduj scenę `scenes/levels/station_06.tscn` i kontroler `scripts/levels/station_06.gd` dla Przestrzeni 06 (Linia zastępcza / Autobus).
2. Zaimplementuj ruchome tło za oknami autobusu, komunikat radiowy UCP, dialog ze starszym pasażerem i interakcję z obrączką.
3. Rozbuduj testy w `tests/smoke_test.gd` o przejście Przestrzeni 06.
4. Wygeneruj zrzuty ekranu przez `godot --path . --script res://tools/capture_preview.gd` (`reports/station_06.png`).
5. Zweryfikuj projekt komendą `pwsh -NoProfile -File .\tools\verify.ps1`.
6. Zamknij pakiet wykonując `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0024`.
7. Stwórz nowy prompt w `NEXT_SESSION_PROMPT.md` dla PKG-0025.

KRYTERIA AKCEPTACJI
- Przestrzeń 06 (Station 06: Linia zastępcza) poprawnie realizuje scenariusz Przestrzeni 06 z FULL_STORY.md.
- Wszystkie dźwięki są generowane proceduralnie w ProceduralAudio bez assetów zewnętrznych.
- Bramka weryfikacyjna `tools/verify.ps1` przechodzi bez błędów.
- CURRENT_STATE.md, SESSION_LOG.md i NEXT_SESSION_PROMPT.md są aktualne.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0024` aby zapisać i udokumentować stan po pracy, a następnie utwórz nowy NEXT_SESSION_PROMPT.md dla kolejnego kroku.
```
