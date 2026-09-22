# Prompt na następną sesję

Pakiet: **PKG-0121**  
Zakres: **Sekwencja VI/VII (Station 24–30: Węzeł pod Linią 4, żywa odpowiedź i pierwsze koszty) według Kanonu 0.3**  
Data bazowa: 2026-08-25 po PKG-0120  
Rola agenta: Lead Programmer i Art Director (`D-025`, `D-085`, `ADR-004`, `ADR-007`, `D-114`)  
Tryb pracy: Pełna autonomia, wysoka przepustowość (mega-package), bez zbędnych pytań blokujących.

## CEL SESJI

Przenieść przestrzenie 24–30 z formatu legacy na Kanon 0.3 (`docs/narrative/FULL_STORY.md`, `docs/narrative/DIALOGUE_SCRIPT.md`, `docs/narrative/CONTINUITY_TRACKER.md`):
1. **Station 24 (Monitoring mieszkania 14 i wybór Leny)**: Gabinet nadzoru UCP. Dr Wierzbicka składa propozycję ochrony Marty w zamian za rejestrację współrzędnych przybyłej Leny. Podgląd CCTV mieszkania Marty, wybór pozornej kooperacji lub odmowy (`GameStateManager.record_decision`).
2. **Station 25 (Tranzyt Linii 4 i dialog D-09)**: Węzeł tranzytowy pod Linią 4. Konfrontacja z Jakubem Wolskim. Jakub stawia twarde warunki relacyjne (`Nie jestem twoim wspomnieniem. Jeśli chcesz wyjść, pomogę osobie. Nie żałobie.`). Zgoda na pomoc bez traktowania Jakuba jako zastępnika zmarłego brata.
3. **Station 26 (Śluza izolacyjna)**: Śluza techniczna i izolacja sygnału Linii 4. Kampanijne zastosowanie mechaniki Anchor/Yield: zakotwiczenie bufora pomiarowego, stabilizacja ciśnienia.
4. **Station 27 (Zapis rozmowy z 20:38)**: Odtworzenie archiwalnego zapisu audio rozmowy miejscowej Leny z Martą tuż przed kontaktem o 20:40. Ujawnienie, że miejscowa Lena przewidziała rozdzielenie.
5. **Station 28 (Peron techniczny i wózek inspekcyjny)**: Przestrzeń wzdłuż torowiska Linii 4. Uruchomienie wózka inspekcyjnego z użyciem kotwicy drgań falownika; brak elementów platformówkowych.
6. **Station 29 (Rozjazd podstacji)**: Ręczne przestawienie rozjazdu trakcyjnego z wykorzystaniem podatności mechanizmu (Yield). Rygiel zwrotnicy wymaga precyzyjnego odciążenia zamiast losowego skakania.
7. **Station 30 (Węzeł zasilania Linii 4)**: Główny węzeł energetyczny. Odkrycie skali transferu mocy między ciągłościami. Pierwszy widoczny koszt stabilizacji dla podstacji; otwarcie drogi do Sekwencji VIII (Station 31+).

## SRODOWISKO I BASELINE

- **Silnik**: Godot 4.7.stable.official.5b4e0cb0f (Windows, renderer OpenGL Compatibility, rozdzielczość logiczna 640x360, fizyka 60 Hz).
- **Kanon wizualny**: `VISUAL_DESIGN.md` (Rówień Pixel-Stage), `WorldPixelCompositor` w Layer 5, `CrispDiegeticText` w Layer 10 (zakaz `draw_string` w Layer 0), `InnerThoughtSurface` w Layer 16, `CRTDialogueBox` w Layer 20.
- **Kanon narracyjny**: `docs/narrative/NARRATIVE_BIBLE.md` 0.3, `docs/narrative/FULL_STORY.md` 0.3, `docs/narrative/DIALOGUE_SCRIPT.md` 0.3.
- **Kanon traversal/obstacle**: `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` (D-099 — brak platformówki zręcznościowej, moving jump-timing platforms, kolców, pasków zdrowia; każda przeszkoda ma uzasadnienie w świecie bez słowa "gracz").

## KRYTERIA AKCEPTACJI

1. **Sceny i mechaniki 24–30**:
   - Skrypty `scripts/levels/station_24.gd` do `station_30.gd` oraz sceny `scenes/levels/station_24.tscn` do `station_30.tscn` w pełni wdrożone pod Kanon 0.3.
   - Każdy skrypt zawiera nagłówek z 3 pytaniami o przeszkodę zgodny z traversal lint.
   - Prawidłowe użycie `LenaVisualRig`, `CrispDiegeticText`, `WorldPixelCompositor` i `CRTDialogueBox`.
2. **Guidance i myśli**:
   - `NarrativeGuidanceService` wspiera beats dla stacji 24–30 z cooldownem >= 8s.
3. **Bramka testowa**:
   - `tests/pkg_0121_smoke_test.gd` sprawdza determinizm 60 Hz, brak `draw_string()` w Layer 0, lint terminów, pętle stacji 24–30 i łańcuch kampanii do Station 31.
   - `tools/verify.ps1` przechodzi z kodem wyjścia 0.
4. **Wizualna kontrola**:
   - `tools/capture_preview.gd` generuje i zapisuje świeże klatki dla stacji 24–30 w `reports/`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po ukończeniu implementacji i przejściu testów:
1. Zaktualizować `docs/CURRENT_STATE.md` (stan po PKG-0121).
2. Zaktualizować `docs/ROADMAP.md` oraz `docs/RISKS_AND_HYPOTHESES.md`.
3. Dodać wpis do `docs/SESSION_LOG.md` dla PKG-0121.
4. Przygotować `docs/NEXT_SESSION_PROMPT.md` dla PKG-0122.
5. Wykonać snapshot: `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0121`.
