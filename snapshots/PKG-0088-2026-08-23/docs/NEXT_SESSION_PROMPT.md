# Prompt dla następnej sesji: PKG-0089 (Mega-Pakiet Wysokoprzepustowy 2x–5x)

## CEL SESJI

Wdrożenie szerokiego, wielomodułowego **Mega-Pakietu Wysokoprzepustowego (2x–5x Batch Size, D-085)** dla projektu **Getting Strange**, łączącego równolegle:
1. **Potencjał Retardowany Casimira-Poldera i Plazmony Powierzchniowe SPP (Casimir-Polder Retarded Potential & Surface Plasmon Polaritons Dispersion Engine)** w Web Showcase (obliczanie potencjału oddziaływania mikroskopowych cząstek i atomów z dielektrykiem w szczelinie szwu $U_{CP}(z) = -\frac{C_4}{z^4}$ w reżimie retardowanym $z \gg \lambda_0$ oraz $U_{vdW}(z) = -\frac{C_3}{z^3}$ w reżimie van der Waalsa $z \ll \lambda_0$, relacja dyspersji plazmonów powierzchniowych $k_{spp}(\omega) = \frac{\omega}{c}\sqrt{\frac{\varepsilon_m(\omega)\varepsilon_d}{\varepsilon_m(\omega) + \varepsilon_d}}$ na granicy kwarc/żeliwo, nielokalna odpowiedź dielektryczna $\varepsilon(k, \omega)$, 4-ćwiartkowa wizualizacja Canvas 2D/3D);
2. **Kwantowy Rejestr Modów Plazmonowych i Sprzężenia Wielowiązkowego (Surface Plasmon Resonance & Evanescent Field Penetration)** (długość penetracji fali zanikającej $\delta_d, \delta_m$, modulacja nośną 740 Hz, sprzężenie kwantowe polarytonów z matrycą Podstruktury);
3. **Nowe Procedury Syntezy Audio w Godot i Web Audio API** (mikro-szmer plazmonu powierzchniowego, rezonansowy świst potencjału Casimira-Poldera, puls sprzężenia fali zanikającej, trzask retardacji hydrodynamicznej);
4. **Rozszerzenia CLI Retro Terminala o komendy elektrodynamiki plazmonowej (`casimir-polder`, `plasmon-dispersion`, `spp-resonance`, `export-plasmon`)**;
5. **Weryfikację 100% spójności, aktualizację dokumentacji i zamrożenie snapshotu PKG-0089**.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, ADR-004) — praca w trybie wysokoprzepustowym (2x–5x), bez zatrzymywania się i bez pytań o zgodę.
- Baseline po PKG-0088: Wszystkie 43 przestrzenie fabularne w Godot 4.7 + Casimir & Quantum Vacuum Stress Tensor Simulator (siła Casimira $P_C(d) = -\frac{\pi^2 \hbar c}{240 d^4}$, gęstość energii $\varepsilon_{vac}(d) = -\frac{\pi^2 \hbar c}{720 d^3}$, tensor naprężeń $T_{\mu\nu}$, teoria Lifshitza, mody zerowe $\rho(\omega)$ 740 Hz), Onsager Reciprocal Relations & Prigogine Entropy Production Engine, Polder Magnetic Tensor, LLG Spin Simulator, Stochastic Resonance, Gauge Field Matrix, Feigenbaum & Lyapunov, 100 kompletnych odtajnionych akt archiwalnych `doc1`..`doc100`, retro CLI z 79 komendami.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0088-2026-08-23`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Zrealizować kompletny zakres Mega-Pakietu PKG-0089 w trybie wysokoprzepustowym (2x–5x).
3. Zapewnić 100% symetrii kluczy `data-i18n` w `web/locales/pl.json` i `web/locales/en.json`.
4. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
5. Zbudować pakiet dystrybucyjny i zamrozić snapshot poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0089`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0089 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0089`.
