# Prompt dla następnej sesji: PKG-0087 (Mega-Pakiet Wysokoprzepustowy 2x–5x)

## CEL SESJI

Wdrożenie szerokiego, wielomodułowego **Mega-Pakietu Wysokoprzepustowego (2x–5x Batch Size, D-085)** dla projektu **Getting Strange**, łączącego równolegle:
1. **Macierz Współczynników Kinetycznych i Relacje Wzajemności Onsagera (Onsager Reciprocal Relations & Phenomenological Coefficients Matrix $L_{ij}$)** w Web Showcase (sprzężenie transportu ciepła $J_q = -L_{qq}\nabla(\frac{1}{T}) - L_{qm}\nabla(\frac{\mu}{T})$, przepływu materii relacyjnej $J_m$ i strumienia spinowego wzdłuż szwu 40 mm, test symetrii relacji wzajemności $L_{ij} = L_{ji}$ oraz dodatniej określoności macierzy kinetycznej $\det(L) > 0$);
2. **Lokalna Produkcja Entropii i Twierdzenie Prigogine'a (Non-Equilibrium Entropy Production & Prigogine Minimum Dissipation Engine)** (numeryczne obliczanie lokalnego tempa produkcji entropii $\sigma = \sum J_i X_i \ge 0$, relaksacja do stanu stacjonarnego o minimalnej dyssypacji $\frac{d\sigma}{dt} \le 0$, fluktuacje termodynamiczne Einsteina wokół stanu równowagi i 4-ćwiartkowa wizualizacja Canvas 2D/3D);
3. **Nowe Procedury Syntezy Audio w Godot i Web Audio API** (szum fluktuacji termodynamicznych, termoelektryczny świst sprzężenia Onsagera, puls produkcji entropii, snap relaksacji stacjonarnej);
4. **Nowe Odtajnione Akta Archiwalne `doc91`..`doc95`** (osiągając 95 akt archiwalnych) ze 100% symetrii dwujęzycznej PL/EN;
5. **Rozszerzenia CLI Retro Terminala o komendy termodynamiki nierównowagowej (`onsager-matrix`, `entropy-prod`, `kinetic-flux`, `export-onsager`)**;
6. **Weryfikację 100% spójności, aktualizację dokumentacji i zamrożenie snapshotu PKG-0087**.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, ADR-004) — praca w trybie wysokoprzepustowym (2x–5x), bez zatrzymywania się i bez pytań o zgodę.
- Baseline po PKG-0086: Wszystkie 43 przestrzenie fabularne w Godot 4.7 + Dynamic Magnetic Susceptibility Tensor & LLG Spin Simulator (macierz Poldera $\hat{\mu}(\omega)$, rezonans ferrimagnetyczny Kittela $f_{FMR} = 740\text{ Hz}$, numeryczny solver RK4 równania LLG, czas Gilberta $\tau_{LLG} = 14.20\text{ ns}$), Stochastic Resonance Engine, Gauge Field Matrix, Feigenbaum & Lyapunov Simulator, Kramers-Kronig Dispersion Matrix, 90 odtajnionych akt `doc1`..`doc90`, retro CLI z 70 komendami.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0086-2026-08-23`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Zrealizować kompletny zakres Mega-Pakietu PKG-0087 w trybie wysokoprzepustowym (2x–5x).
3. Zapewnić 100% symetrii kluczy `data-i18n` w `web/locales/pl.json` i `web/locales/en.json`.
4. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
5. Zbudować pakiet dystrybucyjny i zamrozić snapshot poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0087`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0087 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0087`.
