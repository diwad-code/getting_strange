# Prompt na kolejna sesje: PKG-0045

## CEL SESJI

Zaimplementować Przestrzeń 27 z `FULL_STORY.md` (Akt II — Korekta / Dług wdzięczności: Jakub Wolski otwiera wyjście serwisowe z Podstruktury, wyznaje, że dr Helena Wierzbicka uratowała go na Linii 4 i dała mu pracę w UCP, odmawia naiwnego buntu przeciwko systemowi, żądając dowodu, że ujawnienie sprzeczności nie zabije ludzi na powierzchni; odryglowanie wejścia do Przestrzeni 28 / Tramwaj bez pasażerów).

## SRODOWISKO I BASELINE

Przed rozpoczeciem jakichkolwiek zmian:

1. Przeczytaj w tej kolejnosci:
   - `docs/INDEX.md`
   - `docs/CURRENT_STATE.md`
   - `docs/NEXT_SESSION_PROMPT.md`
   - `docs/narrative/FULL_STORY.md` (Scena 27: Dług wdzięczności)
   - `docs/narrative/DIALOGUE_SCRIPT.md` (Scena 27)
   - `VISUAL_DESIGN.md`
   - `tests/smoke_test.gd`
2. Uruchom:
   ```powershell
   pwsh -NoProfile -File .\tools\verify.ps1
   ```
3. Upewnij sie, ze smoke test przechodzi w 100% dla wszystkich dotychczasowych stacji 01..26 oraz Anchor Lab i Movement Lab.

## KRYTERIA AKCEPTACJI

1. **Proceduralne Audio (`scripts/audio/procedural_audio.gd`)**:
   - `create_service_tunnel_hum_sound()` — głęboki szum 52/104 Hz tunelu serwisowego Podstruktury z wentylacją przemysłową;
   - `create_jakub_keycard_latch_sound()` — dźwięk karty magnetycznej i mechanicznego zwolnienia rygla serwisowego Jakuba;
   - `create_gratitude_confession_tone_sound()` — ciepły, melancholijny ton 440/554 Hz wyznania Jakuba o długu życia;
   - `create_surface_danger_siren_sound()` — stłumiony, odległy świst 1200 Hz ostrzeżenia o niestabilności na powierzchni;
   - `create_station27_door_release_sound()` — ciężki pneumatyczny upust rygli bramy technicznej ku torowisku tramwajowemu Przestrzeni 28.

2. **Punkty Rezonansu Pamięci (`scripts/interactables/memory_resonance_point.gd`)**:
   - Dodać typy:
     - `JAKUB_SERVICE_OPERATOR` (122) — postać Jakuba z kartą serwisową i kluczem uniwersalnym UCP;
     - `SAVED_WORKER_BADGE` (123) — odznaka i legitymacja pracownicza Jakuba z datą przyjęcia po wypadku;
     - `SURFACE_STABILITY_MONITOR` (124) — wskaźnik naprężeń siatki powierzchniowej i ewidencji ocalonych;
     - `TECHNICAL_JUNCTION_CONSOLE` (125) — konsola rozrządu zwrotnicy serwisowej tunelu Linii 4;
     - `STATION_27_EXIT` (126) — brama serwisowa prowadząca do peronu technicznego Przestrzeni 28 (Tramwaj bez pasażerów).

3. **Scena i kontroler poziomu (`scripts/levels/station_27.gd`, `scenes/levels/station_27.tscn`)**:
   - Wymiar 640x360, paleta: ciemny grafit, zardzewiała stal, ciepły bursztyn, cyjan techniczny (`#111619`, `#1b2428`, `#527482`, `#d39a62`, `#e2b060`, `#5da398`);
   - Sekwencja dialogowa Scene 27 z `FULL_STORY.md`:
     - Jakub otwiera wyjście serwisowe kartą UCP;
     - Wyznanie długu wdzięczności wobec Wierzbickiej za ocalenie na Linii 4;
     - Konfrontacja: Jakub żąda gwarancji, że ujawnienie sprzeczności nie zdestabilizuje życia na powierzchni;
     - Odnotowanie intencji i odryglowanie bramy do Przestrzeni 28.

4. **Weryfikacja i podglądy**:
   - Zaktualizować `tests/smoke_test.gd` o `_test_station_27()`;
   - Zaktualizować `tools/capture_preview.gd` i wyrenderować `reports/station_27.png` oraz `reports/station_27_dialogue.png`;
   - Uruchomić `pwsh -NoProfile -File .\tools\verify.ps1` i potwierdzić PASS.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Kazdy pakiet konczy sie:

1. `pwsh -NoProfile -File .\tools\verify.ps1`
2. aktualizacja `docs/CURRENT_STATE.md`
3. dopisaniem wpisu w `docs/SESSION_LOG.md`
4. zapisaniem nastepnego kroku w `docs/NEXT_SESSION_PROMPT.md`
5. zamrozeniem przez `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0045`
