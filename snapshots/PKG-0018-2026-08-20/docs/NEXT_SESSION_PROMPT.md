# Prompt nastepnej sesji

Aktualny pakiet: `PKG-0019: P3 Vertical Slice — Architektura pierwszej lokacji i punkty rezonansu pamięci`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025, D-026, ADR-004 oraz ADR-005 przejąłeś pełną odpowiedzialność za projekt.
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.

CEL SESJI
Otwarcie fazy P3 (Vertical Slice):
1. Przygotowanie architektury sceny pierwszej lokacji (Instytut Korelacji Próżniowej / Stacja Pomiarowa — Przestrzeń 01 z FULL_STORY.md):
   - Modularna struktura geometryczna zgodna z kanonem Aktu I (VISUAL_DESIGN.md, NARRATIVE_BIBLE.md).
2. Implementacja mechaniki punktów rezonansu / śladów pamięci:
   - Obiekty interaktywne w świecie gry reagujące na obecność Leny bez inwazyjnego HUD-u (bursztynowy impuls rezonansu, odgłos interferencji w ProceduralAudio).
3. Weryfikacja ciągłości wizualnej (kadrowanie 640x360, paleta grafit morski / szara szałwia / zgaszony bursztyn).

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\ROADMAP.md
5. C:\getting_strange\docs\WORKFLOW.md
6. C:\getting_strange\docs\narrative\FULL_STORY.md (Scena 01)
7. C:\getting_strange\VISUAL_DESIGN.md

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (`tools/snapshot.ps1`).
- Ostatni pakiet: PKG-0018.
- Jesteś w pełni samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.
- Zachowaj konwencje nazewnictwa i folderów (np. `scripts/`, `scenes/`, `resources/`).

STAN BASELINE (PKG-0018):
- Faza P2 (Anchor Lab) ukończona i zaliczona: 3 pełne komory ze statycznymi obiektami (`AnchorableObject`) i skrzyniami ładunkowymi (`MovableAnchorableProp`), kinową kamerą (`CinematicCamera`), syntezą audio kroków, lądowań i ryglowania śluzy (`ProceduralAudio`) oraz sekwencją telemetryczną ukończenia strefy.
- Testy `tests/smoke_test.gd`: Test 1..5 zielone (SMOKE PASS).
- Verify: DOCS PASS + SMOKE PASS.

ZADANIE:
1. Zaprojektuj i zaimplementuj klasę `MemoryResonancePoint` / `ResonanceProp` (w `scripts/interactables/`) emitującą subtelne audio-wizualne sprzężenie w świecie gry przy zbliżeniu Leny.
2. Przygotuj pierwszą strefę lokacji startowej Vertical Slice w `scenes/vertical_slice/` lub `scenes/levels/station_01.tscn`.
3. Rozszerz testy w `tests/smoke_test.gd` o weryfikację punktów rezonansu i nowej sceny.
4. Zweryfikuj projekt komendą `pwsh -NoProfile -File .\tools\verify.ps1`.
5. Wygeneruj i skontroluj zrzuty ekranu przez `godot --path . --script res://tools/capture_preview.gd`.
6. Zamknij pakiet wykonując `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0019`.
7. Stwórz nowy prompt w `NEXT_SESSION_PROMPT.md` dla PKG-0020.

KRYTERIA AKCEPTACJI
- Nowe obiekty rezonansu pamięci działają bez HUD-u i reagują na obecność gracza.
- Scena startowa zachowuje ścisłe proporcje 640x360 i paletę z VISUAL_DESIGN.md.
- Bramka weryfikacyjna `tools/verify.ps1` przechodzi bez błędów.
- CURRENT_STATE.md, SESSION_LOG.md i NEXT_SESSION_PROMPT.md są aktualne.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0019` aby zapisać i udokumentować stan po pracy, a następnie utwórz nowy NEXT_SESSION_PROMPT.md dla kolejnego kroku.
```
