# Prompt dla następnej sesji: PKG-0093 (Pętla Kampanii, Zapis i Integracja Narracyjna Godot 4.7)

## CEL SESJI

Zgodnie z decyzją **D-091 (Kierunek wyłącznie na Grę Godot)** — 100% prac na właściwej grze Godot 4.7 (`Getting Strange`), bez żadnych prac webowych. PKG-0092 dostarczył bazowy game feel, `AtmosphereRig` dla Station 01..05, `CRTDialogueBox` oraz autoload `GameStateManager`; ten pakiet zamienia te fundamenty w pełną, testowalną pętlę kampanii.

1. **Trwały stan kampanii** (`scripts/core/game_state_manager.gd`): zapis `user://`, schema version, obsługa uszkodzonego pliku, checkpoint restart na akcji `restart` i test resetu/reloadu.
2. **Menu gry**: CanvasLayer dla pause/menu wyboru poziomu; wszystkie 43 przestrzenie są dostępne w trybie testowym, zwykła kampania respektuje odblokowanie.
3. **Integracja poziomów i dialogu**: powiązać istniejące `MemoryResonancePoint` oraz decyzje D-019/D-020 z API GameStateManager; dopisać CRT cues dla kluczowych dialogów zgodnie z `docs/narrative/DIALOGUE_SCRIPT.md`.
4. **Dalsza atmosfera**: korzystać z `AtmosphereRig` w kolejnych poziomach według aktów, utrzymując niskie limity CPUParticles2D i render kontrolny każdego zmienionego aktu.
5. **Automatyczne testy i zamknięcie**: rozszerzyć smoke test, uruchomić `pwsh -NoProfile -File .\tools\verify.ps1`, zaktualizować dokumentację i snapshot `PKG-0093`.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, D-089, D-091, ADR-004) — praca wyłącznie nad silnikiem gry Godot, bez prac webowych.
- Baseline: 43 przestrzenie fabularne istnieją w Godot 4.7; `tests/pkg_0091_smoke_test.gd` przechodzi dla game feel, atmosfery, CRT i GameStateManager.
- Weryfikacja obowiązkowa: `pwsh -NoProfile -File .\tools\verify.ps1`; pełny test trwa znacząco dłużej niż pojedynczy limit wywołania terminala, więc należy użyć procesu monitorowanego i odczytać jego końcowy exit code oraz log.

## KRYTERIA AKCEPTACJI

1. Wykonać świeżą pełną weryfikację oraz dedykowany smoke PKG-0091 jako baseline.
2. Wdrożyć i przetestować trwały zapis oraz restart checkpointu.
3. Wdrożyć dostępne menu pauzy i wyboru poziomu dla 43 przestrzeni.
4. Zintegrować stan, poszlaki i dialog CRT z istniejącymi stacjami.
5. Rozszerzyć atmosferę etapami, wykonać i przejrzeć aktualne rendery.
6. Zaktualizować `CURRENT_STATE.md`, `SESSION_LOG.md`, `NEXT_SESSION_PROMPT.md` i zamrozić PKG-0093.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0093 musi zostać zweryfikowany przez `tools/verify.ps1`, opisany w dokumentacji projektu i zamrożony poleceniem:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0093`.
