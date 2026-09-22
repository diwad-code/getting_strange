# Prompt dla następnej sesji: PKG-0075 (Mega-Pakiet Wysokoprzepustowy 2x–5x)

## CEL SESJI

Wdrożenie szerokiego, wielomodułowego **Mega-Pakietu Wysokoprzepustowego (2x–5x Batch Size, D-085)** dla projektu **Getting Strange**, łączącego równolegle:
1. **Interaktywną Mapę Topologiczną Węzłów Przesyłowych i Trakcji Tramwajowej Równi (Transit Topological Vector Map & Grid Simulator)** w Web Showcase (Canvas 2D, wizualizacja przepływu fali nośnej 740 Hz, rozjazdów i podwójnego toru Linii 4);
2. **Generator i Symulator Raportów Bezpieczeństwa Ciągłości UCP (Continuity Safety Protocol Generator & Anomaly Auditor)** z eksportem oficjalnych raportów inspekcji w formatach JSON/TXT;
3. **Nowe Odtajnione Akta Archiwalne `doc31`..`doc35`** z pełnym tłumaczeniem dwujęzycznym PL/EN;
4. **Rozszerzenia CLI Retro Terminala o komendy analizy siatki miejskiej i protokołów inspekcyjnych (`grid-trace`, `safety-audit`, `transit-switch`)**;
5. **Weryfikację 100% spójności, aktualizację dokumentacji i zamrożenie snapshotu PKG-0075**.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, ADR-004) — praca w trybie wysokoprzepustowym (2x–5x), bez zatrzymywania się i bez pytań o zgodę.
- Baseline po PKG-0074: Wszystkie 43 przestrzenie fabularne w Godot 4.7 + Vacuum Tube Resonance Engine (ECC83/EL84/EM84), Acoustic Cross-Coupling Matrix Rack (4x4 AM/FM), Memory Resonance Spectrometer, Passenger Quantum Manifest Engine (12 pasażerów Linii 4 wg D-020), Condensation Fluid Simulation Rack, Quantum Field Interference Rack, 4-śladowy mikser Unitra M-531S, oscyloskop Lissajous CRT, 20 komór fizyki Canvas 2D, retro CLI z 21 komendami oraz 30 odtajnionych akt `doc1`..`doc30`.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0074-2026-08-22`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Zrealizować kompletny zakres Mega-Pakietu PKG-0075 w trybie wysokoprzepustowym (2x–5x).
3. Zapewnić 100% symetrii kluczy `data-i18n` w `web/locales/pl.json` i `web/locales/en.json`.
4. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
5. Zbudować pakiet dystrybucyjny i zamrozić snapshot poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0075`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0075 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0075`.
