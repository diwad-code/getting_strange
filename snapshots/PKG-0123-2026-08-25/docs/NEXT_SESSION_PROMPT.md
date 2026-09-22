# Prompt na następną sesję

Pakiet: **PKG-0124**  
Zakres: **Faza P5: Release Candidate, Packaging, Performance Audit & Final Master Export**  
Data bazowa: 2026-08-25 po PKG-0123 (Content Lock 3.0 dla wszystkich 43 stacji)  
Rola agenta: Lead Programmer i Art Director (`D-025`, `D-085`, `ADR-004`, `ADR-007`, `D-114`, `D-115`)  
Tryb pracy: Pełna autonomia, wysoka przepustowość (mega-package), bez zbędnych pytań blokujących.

## CEL SESJI

Wejść w fazę produkcyjną P5 i przygotować kompletny Release Candidate (RC1) gry Getting Strange:
1. **Konfiguracja eksportu i szablony dystrybucyjne**:
   - Skonfigurować `export_presets.cfg` dla systemów Windows Desktop (64-bit) i Linux Desktop (x86_64).
   - Ustalić metadane gry, wersję produkcyjną 1.0.0, tytuł diegetyczny "Getting Strange", ikony aplikacji oraz splash screen.
2. **Audyt wydajności i budżetu 60 Hz**:
   - Przetestować czas ramki i zużycie pamięci pod obciążeniem `WorldPixelCompositor`, `AtmosphereRig` i `CrispDiegeticText` na wszystkich 43 stacjach kampanii.
   - Zweryfikować determinizm 60 Hz, brak wycieków zasobów w cyklach przechodzenia scen oraz stabilność przejść airlockowych.
3. **Weryfikacja pakietu licencyjnego, credits i dostępności**:
   - Sprawdzić kompletność `docs/LICENSES.md`, planszy napisów końcowych w `station_43.gd` (`CreditsRoll`) oraz manifestu źródeł.
   - Zweryfikować poprawność działania przełączania języków PL/EN, remapowania klawiszy/pada i zapisu ustawień dźwięku w menu pauzy/głównym.
4. **Paczka dystrybucyjna i smoke test artefaktów**:
   - Przeprowadzić eksport binarny gry do dedykowanego katalogu wyjściowego `dist/` (lub `builds/`).
   - Uruchomić automatyczny test weryfikacyjny na wyeksportowanych artefaktach.

## SRODOWISKO I BASELINE

- **Silnik**: Godot 4.7.stable.official.5b4e0cb0f (Windows, renderer OpenGL Compatibility, rozdzielczość logiczna 640x360, fizyka 60 Hz).
- **Kanon wizualny**: `VISUAL_DESIGN.md` (Rówień Pixel-Stage — 43 stacje w pełni zintegrowane).
- **Kanon narracyjny**: `docs/narrative/NARRATIVE_BIBLE.md` 0.3, `docs/narrative/FULL_STORY.md` 0.3, `docs/narrative/DIALOGUE_SCRIPT.md` 0.3 (Content Lock 3.0).
- **Zasada twarda D-098**: Gra jest budowana wyłącznie w silniku Godot 4.7. Zakaz jakichkolwiek deliverabli webowych.

## KRYTERIA AKCEPTACJI

1. **Eksport i konfiguracja**:
   - Utworzony i przetestowany `export_presets.cfg` z profilami produkcyjnymi dla Windows i Linux.
2. **Audyt stabilności**:
   - Wszystkie 43 sceny, 3 ścieżki finałowe (42A, 42B, 42C), menu główne i epilog 43 przechodzą bezbłędnie pełny smoke test.
   - `tools/verify.ps1` przechodzi z kodem wyjścia 0 dla wszystkich bramek (w tym testy PKG-0095..PKG-0124).
3. **Dokumentacja release'owa**:
   - Zaktualizować `CURRENT_STATE.md`, `ROADMAP.md`, `SESSION_LOG.md` oraz przygotować `RELEASE_NOTES.md` dla wersji RC1.
4. **Snapshot końcowy**:
   - Wykonać zamrożenie stanu: `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0124`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po zakończeniu mega-pakietu:
1. Zaktualizować `docs/CURRENT_STATE.md`, `docs/ROADMAP.md`, `docs/RISKS_AND_HYPOTHESES.md`.
2. Dodać wpis do `docs/SESSION_LOG.md`.
3. Wygenerować prompt dla kolejnego pakietu w `docs/NEXT_SESSION_PROMPT.md`.
4. Wykonać snapshot: `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0124`.
