# Prompt dla następnej sesji: PKG-0076 (Mega-Pakiet Wysokoprzepustowy 2x–5x)

## CEL SESJI

Wdrożenie szerokiego, wielomodułowego **Mega-Pakietu Wysokoprzepustowego (2x–5x Batch Size, D-085)** dla projektu **Getting Strange**, łączącego równolegle:
1. **Zaawansowany Moduł Kalibracji Harmonicznej i Koherencji Osnowy Miejskiej (Harmonic Calibration & Wave Coherence Engine)** w Web Showcase (Canvas 2D, wielofazowa analiza widmowa, symulacja interferencji wielowiązkowej);
2. **Kwantowy Rejestr Struktur Sedacyjnych i Izotopów Pamięciowych (Sedation Strata & Memory Isotope Registry)** z eksportem telemetrycznym;
3. **Nowe Odtajnione Akta Archiwalne `doc36`..`doc40`** z pełnym tłumaczeniem dwujęzycznym PL/EN;
4. **Rozszerzenia CLI Retro Terminala o komendy kalibracji falowej i spektroskopii osadów (`wave-calibrate`, `strata-scan`, `coherence-lock`)**;
5. **Weryfikację 100% spójności, aktualizację dokumentacji i zamrożenie snapshotu PKG-0076**.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, ADR-004) — praca w trybie wysokoprzepustowym (2x–5x), bez zatrzymywania się i bez pytań o zgodę.
- Baseline po PKG-0075: Wszystkie 43 przestrzenie fabularne w Godot 4.7 + Transit Topological Vector Map & Grid Simulator, Continuity Safety Protocol Generator & Anomaly Auditor, Vacuum Tube Resonance Engine (ECC83/EL84/EM84), Acoustic Cross-Coupling Matrix Rack (4x4 AM/FM), Memory Resonance Spectrometer, Passenger Quantum Manifest Engine (12 pasażerów Linii 4 wg D-020), 35 odtajnionych akt `doc1`..`doc35`, retro CLI z 24 komendami.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0075-2026-08-22`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Zrealizować kompletny zakres Mega-Pakietu PKG-0076 w trybie wysokoprzepustowym (2x–5x).
3. Zapewnić 100% symetrii kluczy `data-i18n` w `web/locales/pl.json` i `web/locales/en.json`.
4. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
5. Zbudować pakiet dystrybucyjny i zamrozić snapshot poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0076`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0076 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0076`.

