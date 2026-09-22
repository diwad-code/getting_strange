# Prompt dla następnej sesji: PKG-0085 (Mega-Pakiet Wysokoprzepustowy 2x–5x)

## CEL SESJI

Wdrożenie szerokiego, wielomodułowego **Mega-Pakietu Wysokoprzepustowego (2x–5x Batch Size, D-085)** dla projektu **Getting Strange**, łączącego równolegle:
1. **Analizator Rezonansu Stochastycznego i Wzmocnienia Szumem Tła Korelacyjnego (Stochastic Resonance & Noise-Enhanced Signal Analyzer)** w Web Showcase (dwustabilny potencjał Kramersa $V(x) = -\frac{a}{2}x^2 + \frac{b}{4}x^4$, współczynnik SNR w funkcji gęstości widmowej szumu $D$, częstość przeskoków Kramersa $r_K = \frac{\omega_0 \omega_b}{2\pi \gamma} \exp(-\frac{\Delta V}{D})$, kooperatywna synchronizacja z sub-progową nośną 740 Hz oraz zjawisko rezonansu stochastycznego widmowego);
2. **Wariacyjna Dynamika Pól Cechowania i Tensor Zakrzywienia Wiązki Włóknistej Szwu 40 mm (Gauge Field Dynamics & Fiber Bundle Curvature Tensor)** (tensor natężenia pola $F_{\mu\nu} = \partial_\mu A_\nu - \partial_\nu A_\mu + g [A_\mu, A_\nu]$, nieabelowa pętla Wilsona $W(C) = \text{Tr} \mathcal{P} \exp(i g \oint A_\mu dx^\mu)$, równania Yanga-Millsa dla podstruktury tranzytowej i bilans energii gęstości hamiltonowskiej);
3. **Nowe Odtajnione Akta Archiwalne `doc81`..`doc85`** (osiągając 85 akt archiwalnych) ze 100% symetrii dwujęzycznej PL/EN;
4. **Rozszerzenia CLI Retro Terminala o komendy rezonansu stochastycznego i dynamiki cechowania (`stochastic-resonance`, `gauge-curvature`, `wilson-loop`, `export-stochastic`)**;
5. **Weryfikację 100% spójności, aktualizację dokumentacji i zamrożenie snapshotu PKG-0085**.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, ADR-004) — praca w trybie wysokoprzepustowym (2x–5x), bez zatrzymywania się i bez pytań o zgodę.
- Baseline po PKG-0084: Wszystkie 43 przestrzenie fabularne w Godot 4.7 + Feigenbaum Bifurcation Cascade & Lyapunov Spectrum Simulator (drzewo bifurkacji, $\delta = 4.6692$, $\alpha = 2.5029$, 3D widmo $\{\lambda_1=+0.906, \lambda_2=0.000, \lambda_3=-14.573\}\text{ s}^{-1}$, $D_{KY}=2.062$), Kramers-Kronig Dispersion & Complex Permittivity Matrix (transformata Hilberta $\mathcal{P}\int$, model Lorentza, anomalna dyspersja $n_g = -14.2$, reguła f-sum), Deterministic Chaos & Fractal Attractor Engine, Quantum Tunneling Matrix, 80 odtajnionych akt `doc1`..`doc80`, retro CLI z 62 komendami.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0084-2026-08-23`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Zrealizować kompletny zakres Mega-Pakietu PKG-0085 w trybie wysokoprzepustowym (2x–5x).
3. Zapewnić 100% symetrii kluczy `data-i18n` w `web/locales/pl.json` i `web/locales/en.json`.
4. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
5. Zbudować pakiet dystrybucyjny i zamrozić snapshot poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0085`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0085 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0085`.
