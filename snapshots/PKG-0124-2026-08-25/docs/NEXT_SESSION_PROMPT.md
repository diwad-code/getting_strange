# Prompt na następną sesję

Pakiet: **PKG-0125**  
Zakres: **Faza P5: Master Gold Sign-off, Packaging Archives (ZIP/tar.gz) & Final Distribution Verification**  
Data bazowa: 2026-08-25 po PKG-0124 (Release Candidate 1 dla Windows i Linux)  
Rola agenta: Lead Programmer i Art Director (`D-025`, `D-085`, `ADR-004`, `ADR-007`, `D-114`, `D-115`, `D-116`)  
Tryb pracy: Pełna autonomia, wysoka przepustowość (mega-package), bez zbędnych pytań blokujących.

## CEL SESJI

Doprowadzić wersję Release Candidate do ostatecznego stanu **Master Gold (v1.0.0-FINAL)**:
1. **Automatyczne pakowanie archiwów dystrybucyjnych**:
   - Rozszerzyć `tools/export_builds.ps1` o automatyczne pakowanie archiwów `.zip` dla Windows oraz `.tar.gz` dla Linux w podkatalogu `dist/packages/`.
   - Dołączyć do każdego archiwum pliki `README.md`, `LICENSES.md` oraz `RELEASE_NOTES.md`.
2. **Weryfikacja sum kontrolnych SHA-256**:
   - Wygenerować plik `dist/SHA256SUMS.txt` zawierający skróty kryptograficzne dla wszystkich wyeksportowanych artefaktów i archiwów dystrybucyjnych.
3. **Kompleksowa weryfikacja integralności dystrybucji**:
   - Zaimplementować bramkę `tests/pkg_0125_smoke_test.gd` weryfikującą kompletność paczek, obecność dokumentacji w archiwach oraz integralność sum kontrolnych.
   - Zweryfikować, że `tools/verify.ps1` przechodzi z kodem wyjścia 0 dla wszystkich bramek regresyjnych (PKG-0095..PKG-0125).
4. **Zamknięcie produkcyjne i finalny snapshot**:
   - Zaktualizować `CURRENT_STATE.md`, `ROADMAP.md`, `SESSION_LOG.md`.
   - Wykonać zamrożenie: `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0125`.

## SRODOWISKO I BASELINE

- **Silnik**: Godot 4.7.stable.official.5b4e0cb0f (Windows, renderer OpenGL Compatibility, rozdzielczość logiczna 640x360, fizyka 60 Hz).
- **Kanon wizualny**: `VISUAL_DESIGN.md` (Rówień Pixel-Stage — 43 stacje w pełni zintegrowane).
- **Kanon narracyjny**: `docs/narrative/NARRATIVE_BIBLE.md` 0.3, `docs/narrative/FULL_STORY.md` 0.3, `docs/narrative/DIALOGUE_SCRIPT.md` 0.3 (Content Lock 3.0).
- **Artefakty bazowe**: `dist/windows/GettingStrange.exe` (124.55 MB), `dist/linux/GettingStrange.x86_64` (90.48 MB), `icon.svg`, `docs/LICENSES.md`, `docs/RELEASE_NOTES.md`.
- **Zasada twarda D-098**: Gra jest budowana wyłącznie w silniku Godot 4.7. Zakaz jakichkolwiek deliverabli webowych.

## KRYTERIA AKCEPTACJI

1. **Paczki i sumy kontrolne**:
   - Wygenerowane archiwa `dist/packages/GettingStrange-v1.0.0-windows-x86_64.zip` oraz `dist/packages/GettingStrange-v1.0.0-linux-x86_64.tar.gz`.
   - Utworzony plik `dist/SHA256SUMS.txt` z prawidłowymi hashami.
2. **Audyt stabilności**:
   - Wszystkie 43 sceny, menu główne, pauza i epilog 43 przechodzą bezbłędnie pełny smoke test.
   - `tools/verify.ps1` przechodzi z kodem wyjścia 0 dla wszystkich 21 bramek.
3. **Dokumentacja master**:
   - Zaktualizować `CURRENT_STATE.md`, `ROADMAP.md`, `SESSION_LOG.md`.
4. **Snapshot końcowy**:
   - Wykonać zamrożenie stanu: `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0125`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po zakończeniu mega-pakietu:
1. Zaktualizować `docs/CURRENT_STATE.md`, `docs/ROADMAP.md`, `docs/RISKS_AND_HYPOTHESES.md`.
2. Dodać wpis do `docs/SESSION_LOG.md`.
3. Wygenerować prompt dla kolejnego pakietu w `docs/NEXT_SESSION_PROMPT.md`.
4. Wykonać snapshot: `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0125`.
