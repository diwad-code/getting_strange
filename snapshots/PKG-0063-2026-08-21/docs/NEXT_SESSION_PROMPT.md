# Prompt dla następnej sesji: PKG-0064

## CEL SESJI

Przygotowanie pakietu demonstracyjnego, optymalizacja pipeline'u generowania assetów oraz dalsze testy i walidacja wieloplatformowej dystrybucji gry **Getting Strange**.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Baseline po PKG-0063: Wszystkie 43 przestrzenie fabularne i epilog (Sceny 01..43) są w 100% zaimplementowane w silniku Godot 4.7. Oficjalny portal webowy w `web/` posiada pełne wsparcie dwujęzyczne (PL/EN) z dynamiczną podmianą i18n, symulator Canvas 2D z komorami 1..3 i profilami A/B/C, 15 modułów proceduralnego Web Audio API, galerię 43 kadrów, czytnik 20 scen dialogowych, matrycę pakietów wieloplatformowych z sumami SHA-256 oraz wsparcie PWA offline.
- Słowniki lokalizacyjne w `web/locales/pl.json`, `web/locales/en.json` oraz `resources/localization/getting_strange_locales.csv`.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0063-2026-08-21`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Zweryfikować pipeline audio/wideo/graficzny oraz przygotować ewentualne rozszerzenia interaktywnych komór testowych w portalu webowym.
3. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
4. Zamrozić pakiet poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0064`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0064 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0064`.
