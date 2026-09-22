# CEL SESJI: PKG-0055 — Implementacja Przestrzeni 37 (Komora Sygnałowa / Węzeł Nadawczy)

## SRODOWISKO I BASELINE

- Katalog roboczy: `C:\getting_strange`
- Godot: `4.7.stable.official.5b4e0cb0f`
- Platforma: Windows, PowerShell 7 (pwsh)
- Brak gita (D-016), stan wylacznie na dysku
- Poprzedni zamkniety pakiet: `PKG-0054` (Przestrzeń 36: Kanał Odpływowy / Zimny Ściek)
- Aktywny stan: `docs/CURRENT_STATE.md`
- Historia projektu: `docs/SESSION_LOG.md`
- Decyzje architektoniczne: `docs/DECISION_LOG.md` (D-001..D-068)

## KRYTERIA AKCEPTACJI

1. **Proceduralne audio dla Przestrzeni 37**:
   - Rozbudowa `scripts/audio/procedural_audio.gd` o 5 dedykowanych metod syntezy audio:
     - `create_signal_antenna_carrier_sound()`: nośna wysokiej częstotliwości i rezonans emitera iglicowego (1200..3600 Hz);
     - `create_cross_patchbay_plug_sound()`: mechaniczny wtyk kabla krosowniczego i trzask zestyku miedzianego (680 Hz + 2100 Hz);
     - `create_crt_sweep_interference_sound()`: przydźwięk linii odchylania pionowego CRT i interferencja falowa (450 Hz + 15.6 kHz);
     - `create_memory_injection_lever_sound()`: skok hebelka przełącznika kanału nadawczego (540/1080 Hz + 190 Hz);
     - `create_station37_broadcast_gate_sound()`: modulowany szum otwarcia śluzy transmisyjnej ku Przestrzeni 38 (310..75 Hz + 920 Hz).

2. **Rekwizyty i punkty rezonansu w `MemoryResonancePoint`**:
   - Rozszerzenie typu `PropType` w `scripts/interactables/memory_resonance_point.gd` o identyfikatory 172..176:
     - `SIGNAL_TRANSMISSION_ANTENNA` (172): pionowy emiter iglicowy z pierścieniami rezonansowymi nadający w paśmie pamięci Podstruktury;
     - `TRANSMISSION_CROSS_PATCHBAY` (173): krosownica kablowa łącząca linie sygnałowe z sektorów 1..4;
     - `FREQUENCY_OSCILLOSCOPE_CRT` (174): monitor falowy CRT obrazujący interferencję sygnału Leny i Śladu;
     - `MEMORY_INJECTION_PULPIT` (175): konsola do wzmocnienia sygnału świadectwa z hebelkami kanałów;
     - `STATION_37_EXIT` (176): ciśnieniowa śluza transmisyjna prowadząca do Przestrzeni 38 (Człowiek zamiast dowodu).
   - Implementacja procedur rysunkowych `_draw_*` dla wszystkich nowych typów w spójnej palecie barwnej.

3. **Scena i kontroler poziomu `Station37`**:
   - Utworzenie `scripts/levels/station_37.gd` oraz `scenes/levels/station_37.tscn` (640x360).
   - Odtworzenie scenografii Komory Sygnałowej: geometryczne filary, koryta kablowe, szafy transmisyjne, centralny maszt nadawczy.
   - Wdrożenie pełnej sekwencji narracyjno-dialogowej Scene 37 z `FULL_STORY.md` i `DIALOGUE_SCRIPT.md`.
   - Obsługa strefy `AirlockZone` przy wyjściu z poziomu z emisją sygnału `level_completed`.

4. **Weryfikacja testowa i wizualna**:
   - Rozbudowa `tests/smoke_test.gd` o testy audio oraz procedurę `_test_station_37()`.
   - Rozbudowa `tools/capture_preview.gd` o zrzuty `reports/station_37.png` i `reports/station_37_signal.png`.
   - Wygenerowanie podglądów przez `tools/capture.ps1` i inspekcja wizualna.
   - Pełne przejście `pwsh -NoProfile -File .\tools\verify.ps1`.

5. **Aktualizacja dokumentacji i zamrożenie**:
   - Aktualizacja `docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/DECISION_LOG.md` (D-069) i `docs/ROADMAP.md`.
   - Wykonanie snapshotu `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0055`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Przed zamknieciem sesji wykonaj:
1. `pwsh -NoProfile -File .\tools\verify.ps1`
2. `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0055`
