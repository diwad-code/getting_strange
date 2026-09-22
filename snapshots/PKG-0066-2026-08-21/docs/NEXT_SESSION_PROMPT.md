# Prompt dla następnej sesji: PKG-0067

## CEL SESJI

Rozbudowa aparatury dźwiękowej o generator motywów polifonicznych retro-synth, interaktywny soundboard efektów w portalu Web Showcase, generator certyfikatów weryfikacji IKP oraz dalszy rozwój funkcji eksploracji świata **Getting Strange**.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Baseline po PKG-0066: Wszystkie 43 przestrzenie fabularne i epilog (Sceny 01..43) są w 100% zaimplementowane w silniku Godot 4.7.
- Oficjalny portal webowy w `web/` posiada:
  - symulator fizyki Canvas 2D (5 komór, profile A/B/C, dotyk, fullscreen);
  - galerię 43 kadrów z zaawansowaną wyszukiwarką live i filtrami;
  - aparaturę audio z master volume, mute, analizatorem widma 512 FFT i generatorami tła;
  - czytnik 20 scen dialogowych z autoodtwarzaniem, regulacją prędkości i syntezą mowy;
  - symulator wyborów z dynamicznymi paskami wag wektorów finałowych A/B/C;
  - odtajnione akta archiwalne IKP/UCP z modalnym czytnikiem akt;
  - zintegrowaną automatyczną walidację statyczną `tools/verify_web.ps1` w bramce `tools/verify.ps1`;
  - dystrybucję z generatorem paczek `tools/package_release.ps1` (`dist/getting_strange_web_showcase_v1.0.zip` wraz z SHA-256 i manifestem).
- Słowniki lokalizacyjne w `web/locales/pl.json`, `web/locales/en.json` oraz `resources/localization/getting_strange_locales.csv`.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0066-2026-08-21`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Zrealizować zadania przewidziane dla PKG-0067.
3. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
4. Zamrozić pakiet poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0067`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0067 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0067`.

