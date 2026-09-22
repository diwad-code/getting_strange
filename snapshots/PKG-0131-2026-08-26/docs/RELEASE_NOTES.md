# Getting Strange: Release Notes (Wersja 1.0.0 — Release Candidate 1)

Status: **RELEASE CANDIDATE 1 (RC1)**  
Data: 2026-08-25  
Silnik: Godot Engine 4.7.stable.official.5b4e0cb0f (GL Compatibility, 640x360, 60 Hz)  
Rola: Lead Programmer & Art Director (`D-025`, `D-085`, `ADR-004`, `ADR-007`, `D-114`, `D-115`)

---

## 1. Podsumowanie wydania

Wersja **1.0.0-RC1** gry *Getting Strange* stanowi kompletne, zweryfikowane i zamrożone wydanie Release Candidate relacyjnego thrillera psychologicznego i gry eksploracyjnej 2D. Gra została w całości zaimplementowana w silniku Godot 4.7 z zachowaniem rygorystycznej zasady bezassetowej (Zero-Asset Architecture) oraz całkowitej eliminacji platformówkowych przeszkód typu arcade (`D-099`).

---

## 2. Zawartość kampanii (Content Lock 3.0 — 43 stacje)

Wydanie zawiera pełną trasę narracyjną 43 stacji zorganizowanych w dziesięć sekwencji dramatycznych według Kanonu 0.3:

1. **Sekwencja I: Próbka i obietnica (Station 01–05)**
   - Rutynowy pomiar o 21:45 w IKP, obejście serwisowe, wiadomość od Marty i powrót na znaną ulicę.
2. **Sekwencja II: Rysa w codzienności (Station 06–07)**
   - Dwa sprzeczne rozkłady jazdy na przystanku i kiosk u Pawlaka.
3. **Sekwencja III: Cudzy dom i brakujący lokator (Station 08–13)**
   - Mieszkanie 14, sąsiadka z trzeciego, klucz, fotografia dwóch osób i poczta głosowa z dwoma różnymi wspomnieniami.
4. **Sekwencja IV: Spór o tożsamość i UCP (Station 14–20)**
   - Próg Marty, dokumentacja UCP-4, spotkanie z Wierzbicką, brak aktu zgonu i żywy głos Szymona.
5. **Sekwencja V: Przełom i rozpoznanie (Station 21–23)**
   - Station 21: Synteza trzech niezależnych dowodów i rozpoznanie `To nie jest mój świat`.
   - Station 22–23: Pierwsze świadome użycie procedury Anchor/Yield i odnalezienie śladów miejscowej Leny.
6. **Sekwencja VI–VII: Węzeł pod Linią 4 i żywy sygnał (Station 24–30)**
   - Odmowa Marty, wsparcie Jakuba na peronie 13, stacja transformatorowa i trzy prognozy operacyjne.
7. **Sekwencja VIII–IX: Podstruktura i rejestr par (Station 31–37)**
   - Magazyn dowodów, komora korelacyjna, baseny sedacyjne, drenaż trakcyjny i węzeł nadawczy.
8. **Sekwencja X: Metoda, trzy rozgałęzienia i epilog (Station 38–43)**
   - Station 38: Warunek przerwania próby i ustalenia Jakuba.
   - Station 39: Trzy obwody wyboru metody na Centralnym Pulpicie.
   - Station 40: Poziom 0 i weryfikacja Dr Wierzbickiej.
   - Station 41: Komora z trzema fizycznymi konsolami załączenia odpowiedzialności.
   - **Station 42A**: Wymuszenie powrotu — własny pokój o 21:45 i dwa kubki na stole.
   - **Station 42B**: Zamknięcie Równi — progi Mieszkania 14 i obcy przystanek z wiadomością `Jadę`.
   - **Station 42C**: Przejście wzajemne — dwa równoległe tory porannego tramwaju i jednoczesne istnienie obu Len.
   - **Station 43**: Epilog konkretnych osób — tablice miejskie, rozkłady jazdy i napisy końcowe utrwalające nową ciągłość.

---

## 3. Kluczowe systemy technologiczne

- **Rówień Pixel-Stage Presentation**:
  - `WorldPixelCompositor` (CanvasLayer 5): Siatka renderingu świata 2x2 nearest-neighbor (320x180).
  - `CrispDiegeticText` (CanvasLayer 10): Ostre, czytelne napisy diegetyczne w świecie gry.
  - `InnerThoughtSurface` (CanvasLayer 16): Wyświetlanie wewnętrznego monologu `LENA // MYŚL`.
  - `CRTDialogueBox` (CanvasLayer 20): Klasyczny interkom CRT dla dialogów wypowiadanych.
  - Rygorystyczny zakaz wywołań `draw_string()` w warstwie 0 (Layer 0) — 100% zgodności.
- **LenaVisualRig (`scripts/player/lena_visual_rig.gd`)**:
  - Wzrost 48 px, wektorowa anatomia i 13 płynnych stanów animacji (`idle`, `walk`, `run`, `stop`, `turn`, `jump_rise`, `jump_fall`, `land`, `interact`, `examine`, `unease_reaction`, `seam_gesture`).
- **NarrativeGuidanceService (`scripts/core/narrative_guidance_service.gd`)**:
  - Prowadzenie gracza metodą czteroetapową (Pokaż → Naprowadź → Pomyśl → Sprawdź).
  - Omylne hipotezy poznawcze z 8-sekundowym cooldownem, zapobiegające frustracji bez infantylizacji.
- **Procedural Audio Synthesizer (`scripts/audio/procedural_audio.gd`)**:
  - Ponad 70 unikalnych, matematycznie generowanych barw dźwiękowych PCM (nośne 740 Hz, oscyloskopy, przełączniki bakelitowe, szumy tła, drony epilogu) o zerowej objętości na dysku.
- **GameStateManager (`scripts/core/game_state_manager.gd`)**:
  - Trwały zapis i odczyt stanu JSON (`user://getting_strange_campaign_v1.json`), odporny na błędy parsowania.
  - Wbudowane menu pauzy z mapą stacji kampanii i statusem odkrytych poszlak.
  - System remapowania 5 kluczowych akcji sterowania (`jump`, `interact`, `pause`, `restart`, `trigger_correction`) dla klawiatury i gamepada.
  - Bilingual localization engine (PL/EN) z natychmiastowym przełączaniem tekstów UI i skalowaniem czcionek (0.85x–1.15x).

---

## 4. Dystrybucja i pakiety binarne

Wydanie przygotowano w oparciu o skonfigurowany plik `export_presets.cfg` dla dwóch platform docelowych:

| Platforma | Format / Ścieżka | Architektura | Renderer |
|---|---|---|---|
| **Windows Desktop** | `dist/windows/GettingStrange.exe` | x86_64 | OpenGL Compatibility |
| **Linux Desktop** | `dist/linux/GettingStrange.x86_64` | x86_64 | OpenGL Compatibility |

Skrypt budujący: `tools/export_builds.ps1`

---

## 5. Wyniki audytu weryfikacyjnego i bramek jakości

Wszystkie automatyczne bramki weryfikacyjne przeszły pomyślnie z kodem wyjścia 0 (`PASS`):
- Kontrakt dokumentacji (39 plików obligatoryjnych) — `PASS`
- Import bezgłowy Godot 4.7 — `PASS`
- Smoke test całej gry (43 sceny kampanii) — `PASS`
- Traversal contract lint (D-099, 0 naruszeń) — `PASS`
- Bramki regresyjne PKG-0095 do PKG-0130 — `PASS`
- Audyt wydajności 60 Hz i czasu klatki — `PASS` (p99 14.448 ms na Intel Iris Xe; raport `docs/PKG_0130_FRAME_BUDGET_REPORT.md`)
