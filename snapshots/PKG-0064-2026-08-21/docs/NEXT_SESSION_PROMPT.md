# Prompt dla następnej sesji: PKG-0065

## CEL SESJI

Przygotowanie pakietów instalacyjnych i optymalizacja zasobów statycznych, walidacja wieloplatformowej dystrybucji oraz dalsze ulepszenia symulatora i narzędzi developerskich gry **Getting Strange**.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Baseline po PKG-0064: Wszystkie 43 przestrzenie fabularne i epilog (Sceny 01..43) są w 100% zaimplementowane w silniku Godot 4.7. Oficjalny portal webowy w `web/` posiada 6 pełnych modułów nawigacyjnych, symulator Canvas 2D z 5 komorami testowymi, profilami A/B/C i dotykowymi kontrolkami, syntezator Web Audio API z 21 procedurami dźwiękowymi, analizatorem widma częstotliwości 512 FFT, odtwarzaczem teł akustycznych, galerią 43 kadrów, czytnikiem 20 scen dialogowych D-01..D-18, interaktywnym symulatorem wyborów finałowych Leny, archiwami akt IKP/UCP oraz centrum pobierania pakietów z selektorem trybów CRT i pełną lokalizacją dwujęzyczną PL/EN.
- Słowniki lokalizacyjne w `web/locales/pl.json`, `web/locales/en.json` oraz `resources/localization/getting_strange_locales.csv`.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0064-2026-08-21`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Zweryfikować pipeline kompresji assetów i automatyzację generowania wydań instalacyjnych.
3. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
4. Zamrozić pakiet poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0065`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0065 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0065`.
