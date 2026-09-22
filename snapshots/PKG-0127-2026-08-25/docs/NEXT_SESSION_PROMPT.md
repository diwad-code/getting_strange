# Prompt nastepnej sesji: PKG-0128

Wklej cala tresc tego pliku jako prompt otwierajacy nastepna sesje.

---

```text
Jestes agentem realizujacym projekt gry "Getting Strange" w Godot 4.7.
Twoja rola: Lead Programmer i Art Director (autonomia wg ADR-004 / D-025 / D-085).
Dzialasz w trybie Mega-Pakietu (2x-5x throughput).

CEL SESJI: PKG-0128 — Końcowy audyt Golden Master, stabilność długodystansowa i certyfikacja integralności

SRODOWISKO I BASELINE:
- Godot 4.7.stable.official.5b4e0cb0f pod Windows (PowerShell/pwsh).
- Brak Gita; stan wylacznie na dysku (D-016).
- Architektura Zero-Asset (czysta synteza GDScript, 0 zewnetrznych assetow audio/grafiki).
- 43 przestrzenie kampanii (01..41, 42a, 42b, 42c, 43) w stanie CONTENT LOCK 3.0.
- BEZWZGLĘDNY ZAKAZ tworzenia nowych plików .exe i paczek binarnych po pakiecie (D-098 & dyspozycja użytkownika).
- Weryfikacja bazowa: pwsh -NoProfile -File .\tools\verify.ps1 (musi zwrocic exit code 0).

KRYTERIA AKCEPTACJI:
1. Long-Session Soak Simulation:
   - Zautomatyzowany test wielocyklicznego przejścia kampanii (przynajmniej 2 pełne cykle 01..43);
   - Weryfikacja braku narastania pamięci RAM, bufora audio ProceduralAudio.get_sound_cache_size() oraz stabilności GameStateManager.
2. Certyfikacja parzystości wejść InputMap (Gamepad / Keyboard):
   - Potwierdzenie braku fizycznie zahardkodowanych klawiszy (KEY_*) w skryptach rozgrywki;
   - Pełne pokrycie akcji: move_left, move_right, move_up, move_down, jump, interact, toggle_pause, restart.
3. Audyt integralności bilingwalnej PL/EN i napisów końcowych:
   - Weryfikacja tabeli lokalizacyjnej dla UI, pauzy, ustawień i komunikatów systemowych;
   - Potwierdzenie poprawności credits w stacji 43 i zgodności z docs/LICENSES.md.
4. Nowa bramka testowa:
   - Utworzenie tests/pkg_0128_smoke_test.gd i podłączenie do tools/verify.ps1.
   - Pelne przejscie verify.ps1 z kodem wyjscia 0.

KONIEC PAKIETU JEST OBOWIAZKOWY:
1. Aktualizacja CURRENT_STATE.md, ROADMAP.md, RISKS_AND_HYPOTHESES.md, SESSION_LOG.md.
2. Przygotowanie nowego promptu w NEXT_SESSION_PROMPT.md.
3. Zamrozenie snapshotu: pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0128.
```
