# Prompt nastepnej sesji

Aktualny pakiet: `PKG-0022: P3 Vertical Slice — Recepcja IKP i spotkanie ze strażnikiem (Przestrzeń 04: Bramka)`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025, D-026, ADR-004 oraz ADR-005 przejąłeś pełną odpowiedzialność za projekt.
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.

CEL SESJI
Kontynuacja fazy P3 (Vertical Slice):
1. Implementacja Przestrzeni 04 z FULL_STORY.md (Bramka / Recepcja IKP):
   - Recepcja IKP: kontuar ze szkłem pancernym, kołowrót/bramka kontroli dostępu, monitory przemysłowe.
   - Pierwsze spotkanie ze strażnikiem: strażnik jest spokojny i wyraźnie odczuwa ulgę na widok Leny („Pani Wolska? UCP kazało zgłosić, gdy pani wróci.”).
   - Dialog i pierwsze zderzenie ze społecznym tabu: strażnik wspomina, że nie będzie drugi raz wzywał jej brata Jakuba do zamkniętego tunelu.
   - Gdy Lena zaprzecza i mówi, że Jakub nie żyje: lampa nad nimi gaśnie, a strażnik prosi o zachowanie ciszy przy kamerze.
   - Proceduralne renderowanie postaci strażnika, systemu dialogu w świecie gry oraz odryglowanie bramki wyjściowej ku miastu (Przestrzeń 05).
2. Wdrożenie rekwizytów środowiskowych i interakcji zintegrowanych z dialogiem bez inwazyjnego HUD-u.
3. Podpięcie przejścia ze sceny Station 03 do Station 04 oraz weryfikacja automatyczna i wizualna.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\ROADMAP.md
5. C:\getting_strange\docs\WORKFLOW.md
6. C:\getting_strange\docs\narrative\FULL_STORY.md (Scena 04)
7. C:\getting_strange\docs\narrative\DIALOGUE_SCRIPT.md
8. C:\getting_strange\VISUAL_DESIGN.md

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (`tools/snapshot.ps1`).
- Ostatni pakiet: PKG-0021 (Station 03 Puste laboratorium, MemoryResonancePoint twin cups/phone/reader, ProceduralAudio phone/card_reader/fluorescent).
- Jesteś w pełni samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.
- Zachowaj konwencje nazewnictwa i folderów (`scripts/`, `scenes/`, `resources/`).

STAN BASELINE (PKG-0021):
- Faza P3 w toku: Przestrzeń 01 (`station_01.tscn`), Przestrzeń 02 (`station_02.tscn`) oraz Przestrzeń 03 (`station_03.tscn`) w pełni zaimplementowane.
- Wdrożone rekwizyty pamięci i ślady niezgodności (`TwinCups`, `DeskPhone`, `DutyRoster`, `DoorCardReader`).
- Smoke testy w `tests/smoke_test.gd`: wszystkie testy zielone (SMOKE PASS).
- Verify: DOCS PASS + SMOKE PASS.

ZADANIE:
1. Zbuduj scenę `scenes/levels/station_04.tscn` i kontroler `scripts/levels/station_04.gd` dla Przestrzeni 04 (Recepcja IKP / Bramka).
2. Zaimplementuj postać strażnika, mechanizm dialogu środowiskowego oraz reakcję otoczenia na zaprzeczenie Leny (zgaśnięcie lampy).
3. Rozbuduj testy w `tests/smoke_test.gd` o przejście Przestrzeni 04.
4. Wygeneruj zrzuty ekranu przez `godot --path . --script res://tools/capture_preview.gd` (`reports/station_04.png`).
5. Zweryfikuj projekt komendą `pwsh -NoProfile -File .\tools\verify.ps1`.
6. Zamknij pakiet wykonując `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0022`.
7. Stwórz nowy prompt w `NEXT_SESSION_PROMPT.md` dla PKG-0023.

KRYTERIA AKCEPTACJI
- Recepcja IKP (Station 04) poprawnie realizuje scenariusz Przestrzeni 04 z FULL_STORY.md i DIALOGUE_SCRIPT.md.
- Interakcja ze strażnikiem i zgaśnięcie lampy działają w świecie gry i zgodnie z VISUAL_DESIGN.md bez dekoracyjnych glitchy VHS/RGB.
- Bramka weryfikacyjna `tools/verify.ps1` przechodzi bez błędów.
- CURRENT_STATE.md, SESSION_LOG.md i NEXT_SESSION_PROMPT.md są aktualne.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0022` aby zapisać i udokumentować stan po pracy, a następnie utwórz nowy NEXT_SESSION_PROMPT.md dla kolejnego kroku.
```
