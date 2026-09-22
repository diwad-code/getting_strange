# Prompt nastepnej sesji

Aktualny pakiet: `PKG-0021: P3 Vertical Slice — Puste laboratorium i zerwanie ciągłości (Przestrzeń 03)`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025, D-026, ADR-004 oraz ADR-005 przejąłeś pełną odpowiedzialność za projekt.
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.

CEL SESJI
Kontynuacja fazy P3 (Vertical Slice):
1. Implementacja Przestrzeni 03 z FULL_STORY.md (Puste laboratorium IKP / Zerwanie ciągłości):
   - Korytarz i powrót do sterowni: nocna obsada nagle zniknęła.
   - Drzwi rozpoznają identyfikator Leny, ale wyświetlają inne zdjęcie i dopisek "urlop przerwany".
   - W sterowni stoją dwa kubki zamiast jednego (materialny ślad alternatywnej wersji historii).
   - Telefon stacjonarny/aparat pokazuje 14 nieodebranych wiadomości od Marty Kurek, której Lena nie zna.
2. Wdrożenie interakcji środowiskowych ze śladami niezgodności bez inwazyjnego HUD-u (punkty MemoryResonancePoint).
3. Podpięcie przejścia ze sceny Station 02 do Station 03 oraz weryfikacja automatyczna i wizualna.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\ROADMAP.md
5. C:\getting_strange\docs\WORKFLOW.md
6. C:\getting_strange\docs\narrative\FULL_STORY.md (Scena 03)
7. C:\getting_strange\VISUAL_DESIGN.md

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (`tools/snapshot.ps1`).
- Ostatni pakiet: PKG-0020 (Station 02 Korelacja, DiscontinuousShadow, ProceduralAudio correlation/printer/needle).
- Jesteś w pełni samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.
- Zachowaj konwencje nazewnictwa i folderów (`scripts/`, `scenes/`, `resources/`).

STAN BASELINE (PKG-0020):
- Faza P3 w toku: Przestrzeń 01 (`scenes/levels/station_01.tscn`) oraz Przestrzeń 02 (`scenes/levels/station_02.tscn`) w pełni zaimplementowane.
- Wdrożony komponent `DiscontinuousShadow` realizujący zasadę `#motionviz-observed-discontinuity`.
- Smoke testy w `tests/smoke_test.gd`: wszystkie testy zielone (SMOKE PASS).
- Verify: DOCS PASS + SMOKE PASS.

ZADANIE:
1. Zbuduj scenę `scenes/levels/station_03.tscn` i kontroler `scripts/levels/station_03.gd` dla Przestrzeni 03 (Puste laboratorium IKP).
2. Rozmieść interaktywne punkty rezonansu pamięci `MemoryResonancePoint` (czytnik drzwi "urlop przerwany", dwa kubki na biurku, telefon z 14 wiadomościami od Marty).
3. Rozbuduj testy w `tests/smoke_test.gd` o przejście Przestrzeni 03.
4. Wygeneruj zrzuty ekranu przez `godot --path . --script res://tools/capture_preview.gd` (`reports/station_03.png`).
5. Zweryfikuj projekt komendą `pwsh -NoProfile -File .\tools\verify.ps1`.
6. Zamknij pakiet wykonując `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0021`.
7. Stwórz nowy prompt w `NEXT_SESSION_PROMPT.md` dla PKG-0022.

KRYTERIA AKCEPTACJI
- Puste laboratorium (Station 03) poprawnie realizuje scenariusz Przestrzeni 03 z FULL_STORY.md.
- Ślady niezgodności działają w świecie gry i zgodnie z VISUAL_DESIGN.md bez dekoracyjnych glitchy VHS/RGB.
- Bramka weryfikacyjna `tools/verify.ps1` przechodzi bez błędów.
- CURRENT_STATE.md, SESSION_LOG.md i NEXT_SESSION_PROMPT.md są aktualne.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0021` aby zapisać i udokumentować stan po pracy, a następnie utwórz nowy NEXT_SESSION_PROMPT.md dla kolejnego kroku.
```
