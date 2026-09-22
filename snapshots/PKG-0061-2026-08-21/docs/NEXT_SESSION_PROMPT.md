# Prompt dla następnej sesji: PKG-0062

## CEL SESJI

Wydanie produkcyjne, archiwizacja oraz finalizacja dystrybucyjna gry **Getting Strange** oraz jej oficjalnego portalu webowego.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Baseline po PKG-0061: Wszystkie 43 przestrzenie fabularne i epilog (Sceny 01..43) są w pełni zaimplementowane w silniku Godot 4.7. Oficjalny portal webowy z interaktywnym symulatorem fizyki 2D, syntezatorem Web Audio API i galerią 43 lokacji działa w katalogu `web/`.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS.

## KRYTERIA AKCEPTACJI

1. Wykonać całościowy audyt poprawności plików projektu.
2. Uruchomić i zaliczyć `pwsh -NoProfile -File .\tools\verify.ps1`.
3. Zaktualizować dokumentację i przygotować podsumowanie stanu produktu.
4. Zamrozić ostateczny snapshot za pomocą polecenia `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0062`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0062 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/DECISION_LOG.md`, `docs/ROADMAP.md`) oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0062`.
