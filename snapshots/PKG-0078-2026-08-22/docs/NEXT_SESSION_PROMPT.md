# Prompt dla następnej sesji: PKG-0079 (Mega-Pakiet Wysokoprzepustowy 2x–5x)

## CEL SESJI

Wdrożenie szerokiego, wielomodułowego **Mega-Pakietu Wysokoprzepustowego (2x–5x Batch Size, D-085)** dla projektu **Getting Strange**, łączącego równolegle:
1. **Kwantowy Hologram Relacyjny i Interferometr Projekcji Przestrzennej (Quantum Relational Hologram & Spatial Projection Interferometer)** w Web Showcase (rekonstrukcja fazowa fali odniesienia 740 Hz i fali przedmiotowej świadków, wolumetryczna siatka interferencyjna 3D, zjawisko rozmycia dyfrakcyjnego);
2. **Matrycę Infradźwięków i Sejsmologii Podziemnej Równi (Subterranean Infrasound & Seismic Resonance Matrix)** (analiza drgań sejsmicznych Podstruktury 0.5–20 Hz, fale powierzchniowe Rayleigha i Love'a, rezonans żeliwnych tubingów tunelu Linii 4);
3. **Nowe Odtajnione Akta Archiwalne `doc51`..`doc55`** z pełnym tłumaczeniem dwujęzycznym PL/EN;
4. **Rozszerzenia CLI Retro Terminala o komendy analizy holografii i sejsmologii (`hologram-project`, `seismic-scan`, `infrasound-matrix`, `export-hologram`)**;
5. **Weryfikację 100% spójności, aktualizację dokumentacji i zamrożenie snapshotu PKG-0079**.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, ADR-004) — praca w trybie wysokoprzepustowym (2x–5x), bez zatrzymywania się i bez pytań o zgodę.
- Baseline po PKG-0078: Wszystkie 43 przestrzenie fabularne w Godot 4.7 + Multi-Beam Quantum Entanglement Topology Engine (8 węzłów Hilberta, Bell state |Φ+⟩, macierz gęstości, Concurrence, entropia von Neumanna), Waveguide Dispersion & Group Velocity Filter Engine (mody TE/TM, częstotliwość fc, vp(f), vg(f), GVD, impuls paczki), Spatial Acoustic Convolver, Quantum Phase Tensor Engine, 50 odtajnionych akt `doc1`..`doc50`, retro CLI z 36 komendami.
- Testy automatyczne `tools/verify.ps1` przechodzą w 100% z wynikiem PASS (Exit code: 0).
- Snapshot produkcyjny: `snapshots/PKG-0078-2026-08-22`.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Zrealizować kompletny zakres Mega-Pakietu PKG-0079 w trybie wysokoprzepustowym (2x–5x).
3. Zapewnić 100% symetrii kluczy `data-i18n` w `web/locales/pl.json` i `web/locales/en.json`.
4. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
5. Zbudować pakiet dystrybucyjny i zamrozić snapshot poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0079`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0079 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0079`.
