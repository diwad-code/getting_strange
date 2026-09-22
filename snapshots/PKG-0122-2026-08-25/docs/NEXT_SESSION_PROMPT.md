# Prompt na następną sesję

Pakiet: **PKG-0123**  
Zakres: **Sekwencja X: Metoda, konsekwencje i content lock 3.0 (Station 38–43: komora wyboru metody, odgałęzienia 42A/42B/42C, epilog 43 i finalny content lock)**  
Data bazowa: 2026-08-25 po PKG-0122  
Rola agenta: Lead Programmer i Art Director (`D-025`, `D-085`, `ADR-004`, `ADR-007`, `D-114`)  
Tryb pracy: Pełna autonomia, wysoka przepustowość (mega-package), bez zbędnych pytań blokujących.

## CEL SESJI

Przenieść finałowy ciąg przestrzeni 38–43 z formatu legacy na Kanon 0.3 (`docs/narrative/FULL_STORY.md`, `docs/narrative/DIALOGUE_SCRIPT.md`, `docs/narrative/CONTINUITY_TRACKER.md`):
1. **Station 38 (Strefa Decyzji / Zgody Marty i Jakuba)**: Węzeł przedkomorowy. Marta na łączu radiowym i Jakub przy rozdzielnicy stawiają ostateczne granice i wydają świadome zgody na wybór procedury.
2. **Station 39 (Pulpit Wyboru Metody)**: Centralna komora sterownicza. Prezentacja trzech równoważnych metod rozstrzygnięcia bez moralizowania i bez „dobrego” zakończenia:
   - **Metoda A (Wymuszenie powrotu)**: Lena A wraca do swojego świata; koszt: miejscowa Lena pozostaje zasymilowana, transfer energii korelacyjnej do Podstruktury.
   - **Metoda B (Zamknięcie Równi / Izolacja światów)**: Zniszczenie mostu korelacyjnego; koszt: Lena A pozostaje w Równi, definitywne odcięcie domowego świata, oboje budują nowe życie na stałe.
   - **Metoda C (Przejście wzajemne / Otwarty transfer)**: Obie Leny wymieniają się miejscami lub synchronizują relację; koszt: ryzyko niestabilności sieci i konieczność ciągłego nadzoru UCP.
3. **Station 40 (Ostatni impuls / Weryfikacja Dr Wierzbickiej)**: Potwierdzenie parametrów transmisyjnych, próba zablokowania przez UCP i ostateczne uruchomienie wybranej metody.
4. **Station 41 (Komora Przejścia / Świadome milczenie)**: Przejście przez rdzeń, wygaszenie szumów korelacyjnych, świadoma pauza przed manifestacją skutków.
5. **Station 42A / 42B / 42C (Sceny konsekwencji wyboru)**:
   - `station_42a.tscn` (Konsekwencje Metody A)
   - `station_42b.tscn` (Konsekwencje Metody B)
   - `station_42c.tscn` (Konsekwencje Metody C)
6. **Station 43 (Epilog / Nowa ciągłość)**: Podsumowanie stanu obu Len, Marty, Jakuba, UCP i obu światów. Równoważna waga epilogów, napisy końcowe i powrót do ekranu tytułowego.

## SRODOWISKO I BASELINE

- **Silnik**: Godot 4.7.stable.official.5b4e0cb0f (Windows, renderer OpenGL Compatibility, rozdzielczość logiczna 640x360, fizyka 60 Hz).
- **Kanon wizualny**: `VISUAL_DESIGN.md` (Rówień Pixel-Stage), `WorldPixelCompositor` w Layer 5, `CrispDiegeticText` w Layer 10 (zakaz `draw_string` w Layer 0), `InnerThoughtSurface` w Layer 16, `CRTDialogueBox` w Layer 20.
- **Kanon narracyjny**: `docs/narrative/NARRATIVE_BIBLE.md` 0.3, `docs/narrative/FULL_STORY.md` 0.3, `docs/narrative/DIALOGUE_SCRIPT.md` 0.3.
- **Kanon traversal/obstacle**: `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` (D-099 — brak platformówki zręcznościowej, moving jump-timing platforms, kolców, pasków zdrowia; każda przeszkoda ma uzasadnienie w świecie bez słowa "gracz").

## KRYTERIA AKCEPTACJI

1. **Sceny i mechaniki 38–43**:
   - Skrypty `scripts/levels/station_38.gd` do `station_43.gd` oraz sceny `scenes/levels/station_38.tscn` do `station_43.tscn` (w tym `station_42a.tscn`, `station_42b.tscn`, `station_42c.tscn`) w pełni zaktualizowane pod Kanon 0.3.
   - Każdy skrypt zawiera nagłówek z 3 pytaniami o przeszkodę zgodny z traversal lint (`## PRZESZKODA — dlaczego to tu jest: ...`, `## PRZESZKODA — czego wymaga od Leny: ...`, `## PRZESZKODA — koszt porażki: ...` bez słowa "gracz").
   - Prawidłowe użycie `LenaVisualRig`, `CrispDiegeticText`, `WorldPixelCompositor` i `CRTDialogueBox`.
2. **Bramka testowa**:
   - Utworzyć `tests/pkg_0123_smoke_test.gd` sprawdzający determinizm 60 Hz, brak `draw_string()` w Layer 0, pętle stacji 38–43, wszystkie 3 gałęzie finałowe 42A/B/C oraz integralność epilogu.
   - `tools/verify.ps1` przechodzi z kodem wyjścia 0 dla wszystkich bramek (w tym pełny 43-scenowy smoke test).
3. **Content lock 3.0**:
   - Potwierdzenie zerowej zawartości legacy w całej kampanii 01–43.
4. **Wizualna kontrola**:
   - `tools/capture_preview.gd` generuje i weryfikuje świeże klatki dla wszystkich finałowych przestrzeni w `reports/`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po ukończeniu implementacji i przejściu testów:
1. Zaktualizować `docs/CURRENT_STATE.md` (stan po PKG-0123 i ustanowienie Content Lock 3.0).
2. Zaktualizować `docs/ROADMAP.md` oraz `docs/RISKS_AND_HYPOTHESES.md`.
3. Dodać wpis do `docs/SESSION_LOG.md` dla PKG-0123.
4. Przygotować `docs/NEXT_SESSION_PROMPT.md` dla PKG-0124 (Faza P5: Release Candidate, packaging i eksport).
5. Wykonać snapshot: `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0123`.
