# Prompt dla następnej sesji: PKG-0063

## CEL SESJI

Wsparcie post-produkcyjne, przygotowanie wieloplatformowych pakietów instalacyjnych oraz wdrożenie lokalizacji językowej (angielski/polski) dla gry **Getting Strange** i oficjalnego portalu webowego.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Baseline po PKG-0062: Wszystkie 43 przestrzenie fabularne i epilog (Sceny 01..43) są w 100% zaimplementowane w silniku Godot 4.7. Oficjalny portal webowy z interaktywnym symulatorem fizyki 2D (Chambers 1..3, Profile A/B/C, touch controls), 15 modułami syntezy proceduralnego Web Audio API, galerią 43 kadrów, czytnikiem 20 scen dialogowych i konsolą telemetrii działa w katalogu `web/`.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0062-2026-08-21`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Przygotować strukturę plików słowników lokalizacyjnych JSON / CSV dla warstwy dialogowej i interfejsu portalu webowego.
3. Zweryfikować eksport statyczny portalu webowego oraz zintegrować ewentualne profile eksportu WebGL/WASM Godota.
4. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
5. Zamrozić pakiet poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0063`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0063 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0063`.
