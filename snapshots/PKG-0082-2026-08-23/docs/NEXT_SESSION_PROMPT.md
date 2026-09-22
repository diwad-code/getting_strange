# Prompt dla następnej sesji: PKG-0083 (Mega-Pakiet Wysokoprzepustowy 2x–5x)

## CEL SESJI

Wdrożenie szerokiego, wielomodułowego **Mega-Pakietu Wysokoprzepustowego (2x–5x Batch Size, D-085)** dla projektu **Getting Strange**, łączącego równolegle:
1. **Analizator Chaosu Deterministycznego i Fraktalnej Wymiarowości Atraktora Równi (Deterministic Chaos & Fractal Attractor Engine)** w Web Showcase (przestrzeń fazowa Lorenza/Rösslera, wyznacznik Lapunowa $\lambda_{\text{max}}$, przekrój Poincarégo, wymiar fraktalny pudełkowy $D_F$ oraz wrażliwość na warunki początkowe nośnej 740 Hz);
2. **Kwantowy Analizator Tunelowania i Przenikania Potencjału Szwu 40 mm (Quantum Tunneling & Barrier Transmission Matrix)** (bariera potencjału progu poddrzwiowego $V(x)$, współczynnik transmisji WKB $T(E) = \exp\left(-2\int \sqrt{2m(V-E)}/\hbar\,dx\right)$, rozszczepienie pakietu falowego na granicy Mieszkania 14 i prąd tunelowy $J_t$);
3. **Nowe Odtajnione Akta Archiwalne `doc71`..`doc75`** (osiągając 75 akt archiwalnych) ze 100% symetrii dwujęzycznej PL/EN;
4. **Rozszerzenia CLI Retro Terminala o komendy chaosu i tunelowania (`chaos-attractor`, `lyapunov-calc`, `quantum-tunnel`, `export-chaos`)**;
5. **Weryfikację 100% spójności, aktualizację dokumentacji i zamrożenie snapshotu PKG-0083**.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, ADR-004) — praca w trybie wysokoprzepustowym (2x–5x), bez zatrzymywania się i bez pytań o zgodę.
- Baseline po PKG-0082: Wszystkie 43 przestrzenie fabularne w Godot 4.7 + Spatial Soliton Dynamics Engine (KdV/NLSE), Crystal Seam Piezoelectric Relaxation Matrix (d33, sigma(t)), Quantum Hilbert Topology Engine, Magnetoelectric Resonance Analyzer, Non-Euclidean Spacetime Metric & Lorentz Phase Engine, Relational Vector Field & Vorticity Tensor Matrix, Quantum Relational Hologram, Subterranean Infrasound Matrix, Quantum Entanglement Topology Engine, Waveguide Dispersion Filter, 70 odtajnionych akt `doc1`..`doc70`, retro CLI z 52 komendami.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0082-2026-08-23`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Zrealizować kompletny zakres Mega-Pakietu PKG-0083 w trybie wysokoprzepustowym (2x–5x).
3. Zapewnić 100% symetrii kluczy `data-i18n` w `web/locales/pl.json` i `web/locales/en.json`.
4. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
5. Zbudować pakiet dystrybucyjny i zamrozić snapshot poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0083`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0083 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0083`.
