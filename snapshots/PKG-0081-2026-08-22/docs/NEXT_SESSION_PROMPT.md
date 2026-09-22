# Prompt dla następnej sesji: PKG-0082 (Mega-Pakiet Wysokoprzepustowy 2x–5x)

## CEL SESJI

Wdrożenie szerokiego, wielomodułowego **Mega-Pakietu Wysokoprzepustowego (2x–5x Batch Size, D-085)** dla projektu **Getting Strange**, łączącego równolegle:
1. **Wieloskalowy Analizator Solitonów Przestrzennych i Dynamiki Nieliniowej Kortewega-de Vriesa (KdV) oraz NLSE (Multi-Scale Spatial Soliton & Nonlinear Wave Dynamics Engine)** w Web Showcase (nieliniowa propagacja fal samotnych w osnowie relacyjnej $\partial_t u + 6 u \partial_x u + \partial_x^3 u = 0$, nieliniowe równanie Schrödingera NLSE dla nośnej 740 Hz, interakcje zderzeniowe 2 i 3 solitonów, przesunięcia fazowe $\Delta x$ i zachowanie niezmienników całkowych);
2. **Piezoelektryczny i Termoelastyczny Analizator Relaksacji Naprężeń Krystalicznych w Szwie 40 mm (Piezoelectric & Thermoelastic Crystal Seam Relaxation Matrix)** (tensory piezoelektryczne $d_{ijk}$, relaksacja naprężeń $\sigma(t) = \sigma_0 \exp(-t/\tau_r)$, gradienty termosprężyste $\Delta T$ i stabilizacja szczeliny w Mieszkaniu 14);
3. **Nowe Odtajnione Akta Archiwalne `doc66`..`doc70`** (osiągając 70 akt archiwalnych) ze 100% symetrii dwujęzycznej PL/EN;
4. **Rozszerzenia CLI Retro Terminala o komendy solitonowe i termosprężyste (`soliton-dynamics`, `kdv-solver`, `crystal-piezo`, `export-soliton`)**;
5. **Weryfikację 100% spójności, aktualizację dokumentacji i zamrożenie snapshotu PKG-0082**.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, ADR-004) — praca w trybie wysokoprzepustowym (2x–5x), bez zatrzymywania się i bez pytań o zgodę.
- Baseline po PKG-0081: Wszystkie 43 przestrzenie fabularne w Godot 4.7 + Quantum Hilbert Topology Engine, Magnetoelectric Resonance Analyzer, Non-Euclidean Spacetime Metric & Lorentz Phase Engine, Relational Vector Field & Vorticity Tensor Matrix, Quantum Relational Hologram, Subterranean Infrasound Matrix, Quantum Entanglement Topology Engine, Waveguide Dispersion Filter, 65 odtajnionych akt `doc1`..`doc65`, retro CLI z 48 komendami.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0081-2026-08-22`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Zrealizować kompletny zakres Mega-Pakietu PKG-0082 w trybie wysokoprzepustowym (2x–5x).
3. Zapewnić 100% symetrii kluczy `data-i18n` w `web/locales/pl.json` i `web/locales/en.json`.
4. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
5. Zbudować pakiet dystrybucyjny i zamrozić snapshot poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0082`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0082 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0082`.
