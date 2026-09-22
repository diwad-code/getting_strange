# Prompt dla następnej sesji: PKG-0073 (Mega-Pakiet Wysokoprzepustowy 2x–5x)

## CEL SESJI

Wdrożenie szerokiego, wielomodułowego **Mega-Pakietu Wysokoprzepustowego (2x–5x Batch Size, D-085)** dla projektu **Getting Strange**, łączącego równolegle:
1. **Spektrometr Rezonansu Pamięciowego i Generator Prążków Dyfrakcyjnych (Memory Resonance Spectrometer & Diffraction Fringes Engine)** w Web Audio & Canvas 2D;
2. **Interaktywny Symulator Pasażerów Linii 4 i Macierz Wariantów Losowych (Passenger Quantum Manifest & Dispersion Engine)**;
3. **Nowe Odtajnione Akta Archiwalne `doc21`..`doc25`** z pełnym tłumaczeniem dwujęzycznym PL/EN;
4. **Rozszerzenia CLI Retro Terminala o komendy spektrometrii, symulacji pasażerów i eksportu widma (`spectro-scan`, `passenger-manifest`, `diffraction-plot`)**;
5. **Weryfikację 100% spójności, aktualizację dokumentacji i zamrożenie snapshotu PKG-0073**.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, ADR-004) — praca w trybie wysokoprzepustowym (2x–5x), bez zatrzymywania się i bez pytań o zgodę.
- Baseline po PKG-0072: Wszystkie 43 przestrzenie fabularne w Godot 4.7 + 20 komór fizyki Canvas 2D, Particle Fluid Rack z eksportem 16-bit WAV PCM, Quantum Field Interference Rack, 4-śladowy mikser Unitra M-531S, oscyloskop Lissajous CRT, wiersz poleceń CLI z 15 komendami oraz 20 odtajnionych akt `doc1`..`doc20`.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0072-2026-08-22`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Zrealizować kompletny zakres Mega-Pakietu PKG-0073 w trybie wysokoprzepustowym (2x–5x).
3. Zapewnić 100% symetrii kluczy `data-i18n` w `web/locales/pl.json` i `web/locales/en.json`.
4. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
5. Zbudować pakiet dystrybucyjny i zamrozić snapshot poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0073`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0073 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0073`.
