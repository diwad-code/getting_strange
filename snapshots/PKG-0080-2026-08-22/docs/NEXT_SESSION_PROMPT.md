# Prompt dla następnej sesji: PKG-0081 (Mega-Pakiet Wysokoprzepustowy 2x–5x)

## CEL SESJI

Wdrożenie szerokiego, wielomodułowego **Mega-Pakietu Wysokoprzepustowego (2x–5x Batch Size, D-085)** dla projektu **Getting Strange**, łączącego równolegle:
1. **Kwantową Matrycę Topologiczną Przestrzeni Hilberta i Wielomodowy Interferometr Fazowy Równi (Quantum Hilbert Space Topology Matrix & Multi-Mode Phase Interferometer)** w Web Showcase (analiza wielostanowych wektorów bazowych $|\psi\rangle$, iloczynów skalarnych, faz geometrycznych Berry'ego $\gamma_B$, dekoherencji Lindblada $\mathcal{L}(\rho)$, interferogramów wielowiązkowych z modulacją 740 Hz);
2. **Akustyczno-Magnetoelektryczny Analizator Rezonansu Tubingów Żeliwnych i Sieci Trakcyjnej Linii 4 (Acoustic-Magnetoelectric Traction & Cast-Iron Resonance Analyzer)** (sprzężenie magnetostrykcyjne szyn tramwajowych, prądy wirowe w żeliwie tubingów, indukcja wzajemna pętli 50/100/740 Hz);
3. **Nowe Odtajnione Akta Archiwalne `doc61`..`doc65`** (osiągając 65 akt archiwalnych) ze 100% symetrii dwujęzycznej PL/EN;
4. **Rozszerzenia CLI Retro Terminala o komendy analizy przestrzeni Hilberta i sprzężeń magnetoelektrycznych (`hilbert-topology`, `magneto-resonance`, `berry-phase`, `export-hilbert`)**;
5. **Weryfikację 100% spójności, aktualizację dokumentacji i zamrożenie snapshotu PKG-0081**.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, ADR-004) — praca w trybie wysokoprzepustowym (2x–5x), bez zatrzymywania się i bez pytań o zgodę.
- Baseline po PKG-0080: Wszystkie 43 przestrzenie fabularne w Godot 4.7 + Non-Euclidean Spacetime Metric & Lorentz Phase Engine, Relational Vector Field & Vorticity Tensor Matrix, Quantum Relational Hologram, Subterranean Infrasound Matrix, Quantum Entanglement Topology Engine, Waveguide Dispersion Filter, 60 odtajnionych akt `doc1`..`doc60`, retro CLI z 44 komendami.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0080-2026-08-22`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Zrealizować kompletny zakres Mega-Pakietu PKG-0081 w trybie wysokoprzepustowym (2x–5x).
3. Zapewnić 100% symetrii kluczy `data-i18n` w `web/locales/pl.json` i `web/locales/en.json`.
4. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
5. Zbudować pakiet dystrybucyjny i zamrozić snapshot poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0081`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0081 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0081`.

