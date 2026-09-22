# Prompt dla następnej sesji: PKG-0091 (Mega-Pakiet Szlifu Gry w Silniku Godot 4.7)

## CEL SESJI

Zgodnie z decyzją **D-091 (Kierunek wyłącznie na Grę Godot)** — 100% prac na **właściwej grze Godot 4.7** (`Getting Strange`), bez żadnych prac webowych:

1. **Szlif Game Feel i Odczucia Ruchu Postaci (`scripts/player/player.gd`)**:
   - Kalibracja przyspieszenia, hamowania, skoku ze zmienną wysokością, coyote time i bufora skoku;
   - Wdrożenie procedury squash-and-stretch w kodzie (`_draw()` / `scale` tweens) przy skoku i lądowaniu;
   - Wdrożenie emiterów cząsteczek kurzu i lądowania `CPUParticles2D` pod stopami protagonistki;
   - Płynne pochylanie sylwetki przy gwałtownych zwrotach (lean/tilt) i płynny obrót kierunku patrzenia.
2. **Kinowe Oświetlenie 2D i Atmosfera Poziomów (`scenes/levels/`)**:
   - Dodanie oświetlenia `PointLight2D` z teksturami gradientowymi dla lamp laboratoryjnych, jarzeniówek, neonów i latarń ulicznych w pierwszych poziomach (`station_01.tscn` do `station_05.tscn`);
   - Wolumetryczna mgła i pyłki świetlne w powietrzu (`CPUParticles2D`) potęgujące estetykę deszczowego poranka 1978;
   - Efekt pulsującego światła jarzeniówek (100 Hz micro-flicker) zsynchronizowany z proceduralnym audio.
3. **Interfejs Dialogowy w Silniku Godot (In-Engine CRT Dialogue Box)**:
   - Zastąpienie tymczasowych prostych napisów dedykowanym węzłem interfejsu dialogowego w świecie gry lub na CanvasLayer;
   - Stylowa ramka w estetyce CRT / Teletype 1978 z zielono-bursztynowym luminoforem i portretem postaci;
   - Płynny efekt maszyny do pisania zsynchronizowany z proceduralnymi blipami mowy bohaterów (Lena, Marta, Jakub, dr Wierzbicka, Szymon).
4. **Menedżer Stanu Gry i Punktów Kontrolnych (`scripts/autoload/game_state_manager.gd`)**:
   - Zapisywanie osiągniętych przestrzeni (Station 01..43), zebranych poszlak i decyzji gracza (D-019, D-020);
   - Możliwość restartu od ostatniego punktu kontrolnego oraz menu wyboru poziomu dla testów;
   - Płynne przejście między scenami z efektem ściemnienia (fade-to-black / iris wipe).
5. **Automatyczne Testy i Weryfikacja**:
   - Uruchomienie `pwsh -NoProfile -File .\tools\verify.ps1`, aktualizacja dokumentacji i zamrożenie snapshotu PKG-0091.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, D-089, D-091, ADR-004) — praca wyłącznie nad silnikiem gry Godot, bez prac webowych.
- Baseline: Wszystkie 43 przestrzenie fabularne istnieją w Godot 4.7 (`scenes/levels/station_01.tscn` .. `station_43.tscn`).
- Weryfikacja: `tools/verify.ps1` przechodzi w 100% z wynikiem PASS.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą weryfikację za pomocą `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Wdrożyć ulepszenia fizyki gracza, squash-and-stretch i cząsteczki w `PrototypePlayer`.
3. Wdrożyć oświetlenie 2D i atmosferę w scenach poziomów Godot.
4. Zaimplementować stylowy system dialogowy w silniku z portretami i dźwiękami mowy.
5. Zaktualizować dokumentację (`docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/NEXT_SESSION_PROMPT.md`).
6. Zamrozić snapshot poleceniem `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0091`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0091 musi zostać zweryfikowany przez `tools/verify.ps1`, zaktualizowany w dokumentacji projektu oraz zamrożony za pomocą polecenia:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0091`.
