# Prompt dla następnej sesji: PKG-0066

## CEL SESJI

Integracja CI/CD i automatyzacja testów wielośrodowiskowych, dalsze usprawnienia weryfikacji ciągłej oraz telemetria testów integralności gry **Getting Strange**.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Baseline po PKG-0065: Wszystkie 43 przestrzenie fabularne i epilog (Sceny 01..43) są w 100% zaimplementowane w silniku Godot 4.7. Oficjalny portal webowy w `web/` posiada 6 pełnych modułów nawigacyjnych, symulator Canvas 2D z 5 komorami testowymi, profilami A/B/C i dotykowymi kontrolkami, syntezator Web Audio API z 21 procedurami dźwiękowymi, analizatorem widma częstotliwości 512 FFT, odtwarzaczem teł akustycznych, galerią 43 kadrów, czytnikiem 20 scen dialogowych D-01..D-18, interaktywnym symulatorem wyborów finałowych Leny, archiwami akt IKP/UCP, centrum dystrybucji z pakietami instalacyjnymi i PWA offline oraz automatycznym pipeline'em wydań `tools/package_release.ps1` generującym paczki dystrybucyjne (`dist/getting_strange_web_showcase_v1.0.zip`, `dist/release_manifest.json`, `dist/checksums.sha256`).
- Słowniki lokalizacyjne w `web/locales/pl.json`, `web/locales/en.json` oraz `resources/localization/getting_strange_locales.csv`.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0065-2026-08-21`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Zweryfikować pipeline weryfikacji ciągłej oraz dystrybucji.
3. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
4. Zamrozić pakiet poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0066`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0066 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0066`.
