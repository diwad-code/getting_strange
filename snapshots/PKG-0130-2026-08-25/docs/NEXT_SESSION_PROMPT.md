# Prompt nastepnej sesji: PKG-0131

Wklej cala tresc tego pliku jako prompt otwierajacy nastepna sesje.

---

```text
Jestes agentem realizujacym projekt gry "Getting Strange" w Godot 4.7.
Twoja rola: Lead Programmer i Art Director (autonomia wg ADR-004 / D-025 / D-085).
Dzialasz w trybie Mega-Pakietu (2x-5x throughput).

CEL SESJI: PKG-0131 — P6 Post-RC1: unifikacja prezentacji kamery, reduced-motion / dostepnosc migotania i czastek, porzadek nazewnictwa po zamknieciu P5

SRODOWISKO I BASELINE:
- Godot 4.7.stable.official.5b4e0cb0f pod Windows (PowerShell/pwsh).
- Brak Gita; stan wylacznie na dysku (D-016).
- Architektura Zero-Asset. 43 stacje kampanii, trawers i budzet klatki 60 Hz certyfikowane w PKG-0129/0130.
- Faza P5 zamknieta. Raport wydajnosci: docs/PKG_0130_FRAME_BUDGET_REPORT.md.
- BEZWZGLEDNY ZAKAZ tworzenia nowych plikow .exe i paczek binarnych (D-098).
- Weryfikacja bazowa: pwsh -NoProfile -File .\tools\verify.ps1 (musi zwrocic exit code 0).

KRYTERIA AKCEPTACJI:
1. Unifikacja wezla kamery:
   - Stacje 33–43 uzywaja nazwy wezla "Camera2D", stacje 01–32 nazwy "Camera". Ujednolic do jednego kontraktu nazwy (decyzja Art Directora: "Camera") i zaktualizuj wszystkie referencje w skryptach stacji. Zero zmian zachowania.
2. Reduced-motion / dostepnosc prezentacji:
   - Ustawienie w SettingsOverlay tlumi 100 Hz flicker jarzeniowek AtmosphereRig i obniza amount aktywnych czastek (VentSteam / VolumetricDust) bez wylaczania swiatla narracyjnego.
   - Zachowaj istniejacy zakres skali fontow 85–115% i schema ustawien z migracja, bez zrywania SETTINGS_SCHEMA_VERSION bez potrzeby.
3. Porzadek prezentacji po P5:
   - Zadnych nowych mechanik rozgrywki, zadnych arcade'owych przeszkod (D-099), zadnego web.
   - Bramka tests/pkg_0131_smoke_test.gd + podlaczenie do tools/verify.ps1.
4. Zamrozenie snapshotu PKG-0131.

KONIEC PAKIETU JEST OBOWIAZKOWY:
1. Aktualizacja CURRENT_STATE.md, ROADMAP.md, RISKS_AND_HYPOTHESES.md, SESSION_LOG.md.
2. Przygotowanie nowego promptu w NEXT_SESSION_PROMPT.md.
3. Zamrozenie snapshotu: pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0131.
```
