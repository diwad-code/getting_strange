# Prompt dla następnej sesji: PKG-0084 (Mega-Pakiet Wysokoprzepustowy 2x–5x)

## CEL SESJI

Wdrożenie szerokiego, wielomodułowego **Mega-Pakietu Wysokoprzepustowego (2x–5x Batch Size, D-085)** dla projektu **Getting Strange**, łączącego równolegle:
1. **Symulator Kaskady Bifurkacji Feigenbauma i Pełnego Widma Lapunowa (Feigenbaum Bifurcation Cascade & Lyapunov Spectrum Simulator)** w Web Showcase (drzewo bifurkacji podwojenia okresu z uniwersalną stałą Feigenbauma $\delta = 4.6692$, pełne trójwymiarowe widmo Lapunowa $\lambda_1, \lambda_2, \lambda_3$, tempo produkcji entropii Shannona $\dot{S}$ oraz tranzycja do chaosu nośnej 740 Hz);
2. **Macierz Relacji Dyspersyjnych Kramersa-Kroniga i Złożonej Przenikalności Dielektrycznej Szwu 40 mm (Kramers-Kronig Dispersion & Complex Permittivity Matrix)** (część rzeczywista $\varepsilon'(\omega)$ i urojona $\varepsilon''(\omega)$ podatności dielektrycznej, transformata Hilberta Kramersa-Kroniga $\varepsilon'(\omega) = 1 + \frac{2}{\pi} \mathcal{P} \int_0^\infty \frac{\omega' \varepsilon''(\omega')}{\omega'^2 - \omega^2} d\omega'$, anomalna absorpcja rezonansowa 740 Hz i współczynnik załamania grupowego $n_g(\omega)$);
3. **Nowe Odtajnione Akta Archiwalne `doc76`..`doc80`** (osiągając 80 akt archiwalnych) ze 100% symetrii dwujęzycznej PL/EN;
4. **Rozszerzenia CLI Retro Terminala o komendy bifurkacji i Kramersa-Kroniga (`bifurcation-scan`, `feigenbaum-calc`, `kramers-kronig`, `export-permittivity`)**;
5. **Weryfikację 100% spójności, aktualizację dokumentacji i zamrożenie snapshotu PKG-0084**.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, ADR-004) — praca w trybie wysokoprzepustowym (2x–5x), bez zatrzymywania się i bez pytań o zgodę.
- Baseline po PKG-0083: Wszystkie 43 przestrzenie fabularne w Godot 4.7 + Deterministic Chaos & Fractal Attractor Engine (Lorenz/Rössler, $\lambda_{\text{max}} = +0.906\text{ s}^{-1}$, Poincaré section, $D_F = 2.062$), Quantum Tunneling & 40 mm Seam Barrier Matrix (WKB $T(E)$, Hartman delay $\tau_g = 18.2\text{ fs}$), Spatial Soliton Dynamics Engine, Crystal Seam Piezoelectric Matrix, Quantum Hilbert Topology, Magnetoelectric Resonance Analyzer, Non-Euclidean Spacetime Metric, 75 odtajnionych akt `doc1`..`doc75`, retro CLI z 56 komendami.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0083-2026-08-23`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Zrealizować kompletny zakres Mega-Pakietu PKG-0084 w trybie wysokoprzepustowym (2x–5x).
3. Zapewnić 100% symetrii kluczy `data-i18n` w `web/locales/pl.json` i `web/locales/en.json`.
4. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
5. Zbudować pakiet dystrybucyjny i zamrozić snapshot poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0084`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0084 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0084`.
