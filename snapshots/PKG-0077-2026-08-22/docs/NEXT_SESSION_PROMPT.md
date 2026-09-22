# Prompt dla następnej sesji: PKG-0078 (Mega-Pakiet Wysokoprzepustowy 2x–5x)

## CEL SESJI

Wdrożenie szerokiego, wielomodułowego **Mega-Pakietu Wysokoprzepustowego (2x–5x Batch Size, D-085)** dla projektu **Getting Strange**, łączącego równolegle:
1. **Wielowymiarowy Symulator Topologii Splątania Kwantowego i Grafu Fazowego Osnowy (Multi-Beam Quantum Entanglement Topology & Phase Graph Engine)** w Web Showcase (interaktywny graf wektorów stanu Hilberta, macierz gęstości prawdopodobieństwa, symulacja sprzężeń inter-nodalnych);
2. **Symulator Dyspersji Falowodowej i Prędkości Grupowej Podziemi (Subterranean Waveguide Dispersion & Group Velocity Filter Engine)** (częstotliwości odcięcia modów TE/TM, dyspersja fazowa $v_p(\omega)$ i grupowa $v_g(\omega)$ w tunelach Linii 4 i szybach Podstruktury);
3. **Nowe Odtajnione Akta Archiwalne `doc46`..`doc50`** z pełnym tłumaczeniem dwujęzycznym PL/EN;
4. **Rozszerzenia CLI Retro Terminala o komendy analizy grafu i falowodów (`entanglement-matrix`, `dispersion-scan`, `waveguide-cutoff`, `export-topology`)**;
5. **Weryfikację 100% spójności, aktualizację dokumentacji i zamrożenie snapshotu PKG-0078**.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, ADR-004) — praca w trybie wysokoprzepustowym (2x–5x), bez zatrzymywania się i bez pytań o zgodę.
- Baseline po PKG-0077: Wszystkie 43 przestrzenie fabularne w Godot 4.7 + Spatial Acoustic Convolver (43 komory, 7 materiałów, RT60, Waterfall 3D), Quantum Phase Tensor Engine (Cardano solver, elipsoida 3D, PID neutralizacja), Harmonic Wave Coherence Engine, Sedation Strata Isotope Registry, 45 odtajnionych akt `doc1`..`doc45`, retro CLI z 32 komendami.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0077-2026-08-22`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Zrealizować kompletny zakres Mega-Pakietu PKG-0078 w trybie wysokoprzepustowym (2x–5x).
3. Zapewnić 100% symetrii kluczy `data-i18n` w `web/locales/pl.json` i `web/locales/en.json`.
4. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
5. Zbudować pakiet dystrybucyjny i zamrozić snapshot poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0078`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0078 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0078`.



