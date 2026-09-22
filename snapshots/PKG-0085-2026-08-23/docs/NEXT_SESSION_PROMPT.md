# Prompt dla następnej sesji: PKG-0086 (Mega-Pakiet Wysokoprzepustowy 2x–5x)

## CEL SESJI

Wdrożenie szerokiego, wielomodułowego **Mega-Pakietu Wysokoprzepustowego (2x–5x Batch Size, D-085)** dla projektu **Getting Strange**, łączącego równolegle:
1. **Tensor Przenikalności Magnetycznej i Rezonans Ferrimagnetyczny w Żeliwie Tunelowym (Ferrimagnetic Resonance & Dynamic Magnetic Susceptibility Matrix $\hat{\mu}(\omega)$)** w Web Showcase (tensor dynamicznej podatności magnetycznej Poldera $\hat{\mu}(\omega)$, rezonans Kittel'a dla cylindrycznych tubingów żeliwnych tunelu Linii 4, składowe dyspersji $\mu'(\omega)$ i stratności $\mu''(\omega)$, pole anizotropii magnetokrystalicznej $H_k$ i tłumienie wirowe);
2. **Symulator Relaksacji Landaua-Lifshitza-Gilberta (Landau-Lifshitz-Gilbert Nonlinear Spin Dynamics Engine)** (numeryczne rozwiązanie nieliniowego równania wektorowego LLG: $\frac{d\mathbf{M}}{dt} = -\gamma_L (\mathbf{M} \times \mathbf{H}_{eff}) + \frac{\alpha_G}{M_s} (\mathbf{M} \times \frac{d\mathbf{M}}{dt})$, precesja wektora namagnesowania $\mathbf{M}(t)$ na sferze Blocha, trajektoria spiralna relaksacji, czas Gilberta $\tau_{LLG}$ i bilans dyssypacji energii magnetycznej);
3. **Nowe Odtajnione Akta Archiwalne `doc86`..`doc90`** (osiągając 90 akt archiwalnych) ze 100% symetrii dwujęzycznej PL/EN;
4. **Rozszerzenia CLI Retro Terminala o komendy dynamiki magnetycznej i relaksacji LLG (`magnetic-tensor`, `llg-solver`, `fmr-resonance`, `export-magnetic`)**;
5. **Weryfikację 100% spójności, aktualizację dokumentacji i zamrożenie snapshotu PKG-0086**.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, ADR-004) — praca w trybie wysokoprzepustowym (2x–5x), bez zatrzymywania się i bez pytań o zgodę.
- Baseline po PKG-0085: Wszystkie 43 przestrzenie fabularne w Godot 4.7 + Stochastic Resonance Signal Engine (dwustabilny potencjał Kramersa $V(x)$, Euler-Maruyama SDE, $\text{SNR}_{out}=+18.42\text{ dB}$, $\rho_{sync}=0.942$), Gauge Field Dynamics & Wilson Loop Matrix (koneksja $U(1)\times SU(2)$, pętla Wilsona $W(C)=0.624$, faza holonomii $\Phi_W=1.842\text{ rad}$, ładunek instantonowy $Q_{top}=1.00$, Chern-Simons), Feigenbaum Cascade & Lyapunov Spectrum Simulator, Kramers-Kronig Dispersion Matrix, 85 odtajnionych akt `doc1`..`doc85`, retro CLI z 66 komendami.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0085-2026-08-23`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Zrealizować kompletny zakres Mega-Pakietu PKG-0086 w trybie wysokoprzepustowym (2x–5x).
3. Zapewnić 100% symetrii kluczy `data-i18n` w `web/locales/pl.json` i `web/locales/en.json`.
4. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
5. Zbudować pakiet dystrybucyjny i zamrozić snapshot poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0086`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0086 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0086`.
