# Prompt na nastepna sesje

Kopiuj calosc ponizszego bloku do nowej sesji, aby zachowac pelny kontekst i ciaglosc projektu.

```markdown
Wklejam zawartosc docs/NEXT_SESSION_PROMPT.md z projektu Getting Strange:

## CEL SESJI

Celem pakietu `PKG-0046` jest kontynuacja fazy `P3 / Vertical Slice` oraz realizacja **Przestrzeni 28: Tramwaj bez pasażerów** (finał Aktu II: Korekta) per `FULL_STORY.md` i `DIALOGUE_SCRIPT.md`.

Lena i Jakub wsiadają do technicznego składu tramwajowego Linii 4 pędzącego przez tunel serwisowy ku Podstrukturze. Przez panoramiczne okna wagonu migają perony prezentujące 3 sprzeczne wersje wypadku na Linii 4:
1. Wersja A: Pusty peron / cisza powypadkowa.
2. Wersja B: Zatłoczony peron / panika i akcja ratunkowa.
3. Wersja C: Zalany oślepiającym światłem konsensusu UCP.

Jakub widzi tylko 2 wersje (brak kalibracji zewnętrznej); Lena dostrzega wszystkie 3. Ślad (Trace) układa z liter mijanych tablic stacyjnych słowo `ŚWIADEK`.
Na koniec aktu dr Helena Wierzbicka nadaje przez interkom wagonu: »Nie ścigam państwa. Zamykam drogę, którą otwieracie za sobą.« Dojechanie do końca toru odryglowuje wyjście i zamyka Akt II, otwierając Akt III (Przestrzeń 29: Peron trzynasty).

Wymagania:
- Skrypt `scripts/levels/station_28.gd` i scena `scenes/levels/station_28.tscn` (640x360, ruchome tło tunelu, wnętrze wagonu technicznego z pulpitem maszynisty, oknami obserwacyjnymi, interkomem Wierzbickiej i tablicami stacyjnymi);
- Rozszerzenie `scripts/audio/procedural_audio.gd` o 5 dedykowanych syntezatorów dźwięku (szum pędzącego składu technicznego, stukot kół na zwrotnicach, interkom zamykającej się drogi Wierzbickiej, dźwięk anomalii 3 wersji peronu, zwolnienie hamulców pneumatycznych na stacji docelowej);
- Rozszerzenie `scripts/interactables/memory_resonance_point.gd` o rekwizyty PropType 127..131 (`TRAM_DRIVER_CONSOLE`, `PANORAMIC_TRANSIT_WINDOW`, `TRIPLE_ACCIDENT_PARADOX_VIEW`, `WIERZBICKA_CLOSING_INTERCOM`, `STATION_28_EXIT`);
- Wdrożenie 11-wersowej sekwencji dialogowej Scene 28 per `FULL_STORY.md` / `DIALOGUE_SCRIPT.md`;
- Rozszerzenie `tests/smoke_test.gd` o `_test_station_28()` oraz asercje audio;
- Rozszerzenie `tools/capture_preview.gd` o zrzuty `reports/station_28.png` i `reports/station_28_transit.png`;
- Aktualizacja `docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/DECISION_LOG.md` (D-060) i `docs/ROADMAP.md`;
- Zamrożenie pakietu `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0046`.

## SRODOWISKO I BASELINE

- Katalog roboczy: `C:\getting_strange`
- Engine: Godot 4.7.x stable (`Godot_v4.7-stable_win64_console.exe`)
- Shell: PowerShell 7 (`pwsh -NoProfile`)
- Projekt nie posiada repozytorium git (D-016).
- Weryfikacja: `pwsh -NoProfile -File .\tools\verify.ps1`.
- Poprzedni zamkniety pakiet: `PKG-0045`.

## ZADANIA DO WYKONANIA

1. Przeczytac `docs/INDEX.md`, `docs/CURRENT_STATE.md`, `docs/NEXT_SESSION_PROMPT.md`, `docs/narrative/FULL_STORY.md` (Scena 28) i `VISUAL_DESIGN.md`.
2. Dodac 5 syntezatorow dzwieku do `scripts/audio/procedural_audio.gd`.
3. Dodac rekwizyty 127..131 do `scripts/interactables/memory_resonance_point.gd`.
4. Utworzyc `scripts/levels/station_28.gd` oraz `scenes/levels/station_28.tscn`.
5. Dodac testy do `tests/smoke_test.gd`.
6. Zaktualizowac `tools/capture_preview.gd` i wyrenderowac zrzuty przez `tools/capture.ps1`.
7. Uruchomic `godot --headless --editor --path . --quit` oraz `pwsh -NoProfile -File .\tools\verify.ps1`.
8. Zaktualizowac dokumentacje (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/DECISION_LOG.md`, `docs/ROADMAP.md`).
9. Przygotowac `docs/NEXT_SESSION_PROMPT.md` dla `PKG-0047` (Przestrzeń 29: Peron trzynasty — Otwarcie Aktu III).
10. Zamrozic stan: `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0046`.

## KRYTERIA AKCEPTACJI

- [ ] `pwsh -NoProfile -File .\tools\verify.ps1` przechodzi w 100% (dokumentacja, import headless, smoke test).
- [ ] Zrzuty `reports/station_28.png` i `reports/station_28_transit.png` wygenerowane i sprawdzone.
- [ ] Decyzja D-060 odnotowana w `docs/DECISION_LOG.md`.
- [ ] `SESSION_LOG.md` zawiera wpis `PKG-0046` z raportem.
- [ ] Snapshot `snapshots/PKG-0046-DATA/` utworzony i kompletny.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet uznaje sie za zakonczony wylacznie po przejsciu wszystkich testow, wyrenderowaniu podgladow i utworzeniu snapshotu.
```
