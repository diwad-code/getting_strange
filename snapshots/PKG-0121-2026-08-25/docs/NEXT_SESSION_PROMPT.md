# Prompt na następną sesję

Pakiet: **PKG-0122**  
Zakres: **Sekwencja VIII/IX (Station 31–37: Podstruktura, Magazyn Dowodów i rejestr par) według Kanonu 0.3**  
Data bazowa: 2026-08-25 po PKG-0121  
Rola agenta: Lead Programmer i Art Director (`D-025`, `D-085`, `ADR-004`, `ADR-007`, `D-114`)  
Tryb pracy: Pełna autonomia, wysoka przepustowość (mega-package), bez zbędnych pytań blokujących.

## CEL SESJI

Przenieść przestrzenie 31–37 z formatu legacy na Kanon 0.3 (`docs/narrative/FULL_STORY.md`, `docs/narrative/DIALOGUE_SCRIPT.md`, `docs/narrative/CONTINUITY_TRACKER.md`):
1. **Station 31 (Magazyn Dowodów / Dwieście krzeseł)**: Magazyn zdeponowanych przedmiotów pod Podstrukturą. Ewidencja wyposażenia z wypadku na Linii 4, rząd krzeseł tramwajowych, inspekcja ewidencji UCP.
2. **Station 32 (Szkło laboratoryjne / Ostatnie pismo Leny)**: Stanowisko chemiczno-analityczne. Notatka ręczna miejscowej Leny z formułą oporu tożsamościowego, zabezpieczenie próbek.
3. **Station 33 (Szyb wentylacyjny / Ciśnienie powrotne)**: Pionowy ciąg wentylacyjny. Regulacja przepustnic powietrza z wykorzystaniem mechanizmu Anchor/Yield, brak platformówki zręcznościowej.
4. **Station 34 (Rdzeń korelacyjny / Rejestr par)**: Centralny bank rejestru par tożsamościowych. Odkrycie wpisu pary Lena Wolska (A) / Lena Wolska (B) i potwierdzenie lokalizacji uwięzionej miejscowej Leny.
5. **Station 35 (Strefa sedacji / Głos Marty)**: Odizolowana komora wyciszenia. Odsłuchanie transmisji Marty z powierzchni, dramatyczny wybór odpowiedzialności relacyjnej.
6. **Station 36 (Drenaż trakcyjny / Warunek Dr Wierzbickiej)**: Kanał upustowy energii korelacyjnej. Dr Wierzbicka stawia bezpośrednie warunki zakończenia procedury, wyjaśniając koszty dla obu miast.
7. **Station 37 (Żywy sygnał / Odpowiedź miejscowej Leny)**: Odbiór aktywnego odzewu czytnika miejscowej Leny z głębi Podstruktury. Nawiązanie kontaktu i odblokowanie drogi do komory wyboru (Station 38+ / 41).

## SRODOWISKO I BASELINE

- **Silnik**: Godot 4.7.stable.official.5b4e0cb0f (Windows, renderer OpenGL Compatibility, rozdzielczość logiczna 640x360, fizyka 60 Hz).
- **Kanon wizualny**: `VISUAL_DESIGN.md` (Rówień Pixel-Stage), `WorldPixelCompositor` w Layer 5, `CrispDiegeticText` w Layer 10 (zakaz `draw_string` w Layer 0), `InnerThoughtSurface` w Layer 16, `CRTDialogueBox` w Layer 20.
- **Kanon narracyjny**: `docs/narrative/NARRATIVE_BIBLE.md` 0.3, `docs/narrative/FULL_STORY.md` 0.3, `docs/narrative/DIALOGUE_SCRIPT.md` 0.3.
- **Kanon traversal/obstacle**: `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` (D-099 — brak platformówki zręcznościowej, moving jump-timing platforms, kolców, pasków zdrowia; każda przeszkoda ma uzasadnienie w świecie bez słowa "gracz").

## KRYTERIA AKCEPTACJI

1. **Sceny i mechaniki 31–37**:
   - Skrypty `scripts/levels/station_31.gd` do `station_37.gd` oraz sceny `scenes/levels/station_31.tscn` do `station_37.tscn` w pełni zaktualizowane pod Kanon 0.3.
   - Każdy skrypt zawiera nagłówek z 3 pytaniami o przeszkodę zgodny z traversal lint (`## PRZESZKODA — dlaczego to tu jest: ...`, `## PRZESZKODA — czego wymaga od Leny: ...`, `## PRZESZKODA — koszt porażki: ...` bez słowa "gracz").
   - Prawidłowe użycie `LenaVisualRig`, `CrispDiegeticText`, `WorldPixelCompositor` i `CRTDialogueBox`.
2. **Guidance i myśli**:
   - `NarrativeGuidanceService` wspiera beats dla stacji 31–37 z cooldownem >= 8s.
3. **Bramka testowa**:
   - Utworzyć `tests/pkg_0122_smoke_test.gd` sprawdzający determinizm 60 Hz, brak `draw_string()` w Layer 0, lint terminów, pętle stacji 31–37 i łańcuch kampanii do Station 38.
   - `tools/verify.ps1` przechodzi z kodem wyjścia 0 dla wszystkich bramek.
4. **Wizualna kontrola**:
   - `tools/capture_preview.gd` generuje i zapisuje świeże klatki dla stacji 31–37 w `reports/`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po ukończeniu implementacji i przejściu testów:
1. Zaktualizować `docs/CURRENT_STATE.md` (stan po PKG-0122).
2. Zaktualizować `docs/ROADMAP.md` oraz `docs/RISKS_AND_HYPOTHESES.md`.
3. Dodać wpis do `docs/SESSION_LOG.md` dla PKG-0122.
4. Przygotować `docs/NEXT_SESSION_PROMPT.md` dla PKG-0123.
5. Wykonać snapshot: `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0122`.
