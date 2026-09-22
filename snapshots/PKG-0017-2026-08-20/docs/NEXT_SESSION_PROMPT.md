# Prompt nastepnej sesji

Aktualny pakiet: `PKG-0018: Polish, udźwiękowienie kroków/wstrząsów i system przejścia do kolejnej strefy`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025, D-026, ADR-004 oraz ADR-005 przejąłeś pełną odpowiedzialność za projekt.
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.

CEL SESJI
Finalny szlif audiowizualny i mechaniczny kompleksu Anchor Lab (Prototype 02):
1. Udźwiękowienie kroków i lądowań Leny:
   - Rozszerzenie syntezy w `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o subtelne odgłosy kroków (laboratoryjne linoleum/beton vs metalowa blacha podnośnika/mostu) generowane w 100% proceduralnie jako `AudioStreamWAV` PCM.
   - Integracja wyzwalania kroków w `PrototypePlayer` na podstawie przemieszczenia i kontaktu z podłożem.
2. System ukończenia strefy i przejścia do kolejnego sektora:
   - Po wejściu do śluzy `Goal` w Komorze 3 uruchomienie sekwencji ryglowania śluzy, rozbłysku/wygaszenia (fade-out) oraz procedury przejściowej.
3. Weryfikacja bramki P2 (Prototype 02 checkpoint).

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\ROADMAP.md
5. C:\getting_strange\docs\WORKFLOW.md

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (`tools/snapshot.ps1`).
- Ostatni pakiet: PKG-0017.
- Jesteś w pełni samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.
- Zachowaj konwencje nazewnictwa i folderów (np. `scripts/`, `scenes/`, `resources/`).

STAN BASELINE (PKG-0017):
- Kompletny 3-komorowy kompleks `scenes/prototype/anchor_lab.tscn` o szerokości 1920 px z ciągłą posadzką (y=320 na dole, y=200 na antresoli).
- Pełny łańcuch przyczynowy Komory 3: most podniesiony i zakotwiczony w Stanie A, fala korekty do Stanu B otwiera bramę bezpieczeństwa i umożliwia przejście do śluzy `Goal`.
- Precyzyjna kalkulacja dystansu `get_distance_to_point` w `AnchorableObject` i `MovableAnchorableProp`.
- Wyspecjalizowana oprawa graficzna bramy żaluzjowej i śluzy pomiarowej Goal.
- Testy `tests/smoke_test.gd`: Test 1..5 zielone (SMOKE PASS).
- Verify: DOCS PASS + SMOKE PASS.

ZADANIE:
1. Rozbuduj `ProceduralAudio` o odgłosy kroków i zintegruj je z `PrototypePlayer`.
2. Zaimplementuj sekwencję ryglowania i przejścia po wejściu do śluzy `Goal` w `AnchorLab`.
3. Rozszerz testy w `tests/smoke_test.gd` o weryfikację nowych funkcji audio i sekwencji śluzy.
4. Zweryfikuj projekt komendą `pwsh -NoProfile -File .\tools\verify.ps1`.
5. Wygeneruj i skontroluj zrzuty ekranu przez `godot --path . --script res://tools/capture_preview.gd`.
6. Zamknij pakiet wykonując `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0018`.
7. Stwórz nowy prompt w `NEXT_SESSION_PROMPT.md` dla PKG-0019.

KRYTERIA AKCEPTACJI
- Proceduralne audio generuje odgłosy kroków/interakcji.
- Wejście do Goal uruchamia sekwencję ryglowania śluzy.
- Bramka weryfikacyjna `tools/verify.ps1` przechodzi bez błędów.
- CURRENT_STATE.md, SESSION_LOG.md i NEXT_SESSION_PROMPT.md są aktualne.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0018` aby zapisać i udokumentować stan po pracy, a następnie utwórz nowy NEXT_SESSION_PROMPT.md dla kolejnego kroku.
```
