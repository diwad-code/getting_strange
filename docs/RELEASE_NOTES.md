# Getting Strange: historyczny zapis Release Candidate 1 i technicznego dawcy PKG-0154

Status: **ARTEFAKT HISTORYCZNY — `RELEASE CANDIDATE 1 (RC1)` ORAZ PKG-0154 NIE SĄ PRODUKTOWYM GREENLIGHTEM; P9 HYBRID REBUILD OTWARTE**  
Data historycznego zapisu: 2026-08-25  
Aktualizacja board verdict: 2026-08-31  
Status aktywny projektu: P9 Product Rescue & Hybrid Rebuild (`CURRENT_STATE.md`, `ROADMAP.md`, ADR-008).  
Zweryfikowany dawca techniczny: Godot Engine v4.7.2.stable.official.ed1daf0bf (GL Compatibility, 640x360, 60 Hz).

> **Aktualizacja PKG-0242 (2026-09-24), nie jest wydaniem.** Aktywny kształt to 20 adresów
> (22 sceny: 01–18, 42A/B/C, 43), ukończalny wejściem gracza na trzech zakończeniach.
> Twórcy i licencje są w menu głównym (TWÓRCY I LICENCJE, teksty z silnika); stacja 43
> nie niesie już manifestu licencji. D-168 nadal blokuje eksport i `.exe`;
> szczegóły: `docs/audits/PKG_0242_REPORT.md`. Poniższy tekst to zapis historyczny.

## 1. Podsumowanie wydania

Ten plik łączy cztery porządki:

1. zachowuje historyczny zapis RC1 z PKG-0124;
2. zachowuje werdykt audytu PKG-0152 jako fakt historyczny poprzedzający remediację;
3. zachowuje wynik PKG-0153 dla runtime release surface po przebudowie P7;
4. dopisuje wynik PKG-0154 dla świeżego build/rehearsal i clean-install.

Stan po PKG-0154:

- kampania runtime to **15 sekwencji diagnostycznych**, nie dawny liniowy przebieg RC1;
- technicznie potwierdzone są **43 adresy narracyjne** i **45 technicznych zasobów scenicznych**;
- preset eksportu i skrypt builda istnieją, a nowe binaria są nadal kontrolowane przez D-125, ale PKG-0154 wykonał autoryzowany świeży eksport w ramach rehearsal;
- historyczne artefakty `dist/` z 2026-08-25 nie są już jedynym stanem katalogu `dist/`; świeże artefakty PKG-0154 zastępują je jako bieżący dowód RC;
- PKG-0153 domknął runtime credits/licence surface i identyfikację wersji;
- PKG-0154 domknął build/rehearsal, clean-install/save bootstrap i werdykt techniczny RC.

Board verdict PKG-0155 zastępuje produktową interpretację powyższych faktów:
obecna forma gry nie komunikuje tożsamości, celu, stawki ani zasad świata,
a rodziny lokacji są nierozróżnialne. Buildy PKG-0154 pozostają wartościowym
dowodem technicznym i materiałem dawcy, lecz nie są przeznaczone do wydania.
Aktywny kierunek to `HYBRID_REBUILD` według
`docs/PROJECT_REBUILD_EXECUTION_PLAN.md`. Nowe `.exe` pozostają zablokowane.

## 2. Zawartość kampanii (Content Lock 3.0 — 43 stacje, zapis historyczny / runtime P7 bieżący)

Fraza **Content Lock 3.0 — 43 stacje** pozostaje punktem odniesienia historycznego z RC1. Bieżący runtime po P7 jest dokładniej opisany przez sekwencje diagnostyczne:

1. **S01–S05 / Station 01–14** — `sample_and_promise`, `return_under_control`, `address_and_record`, `foreign_daily_life`, `marta_threshold`.
2. **S06–S07 / Station 15–21** — `work_history_and_record`, `three_place_proofs`; rozpoznanie `To nie jest mój świat` powstaje dopiero po syntezie trzech rodzin dowodu.
3. **S08 / Station 22–25** — `mutual_test`; pierwszy świadomy koszt Anchor/Yield, granica Marty i ślad bufora UCP.
4. **S09–S10 / Station 26–30** — `interrupted_trial_and_small_cost`, `jakub_boundary_and_forecasts`; trzy zegary, mały koszt, jawny zakres zgody Jakuba i trzy prognozy.
5. **S11–S13 / Station 31–38** — `archive_countermodel`, `pair_cost_and_echo`, `consent_and_rescue_boundary`; kontrmodel UCP, rejestr kosztów Linii 4, zgoda i granica ratunku.
6. **S14 / Station 39–41** — `branch_clarity_and_irreversible_choice`; metoda A/B/C jest wykonanym zobowiązaniem, nie menu moralnym.
7. **S15 / Station 42A/42B/42C–43** — `conscious_silence_and_presence`; trzy rodziny finału i epilog sześciu podmiotów.

Jedno przejście kampanii odwiedza 43 adresy, ale runtime utrzymuje 45 technicznych scen przez trzy warianty Station 42.

## 3. Kluczowe systemy technologiczne

- **Rówień Pixel-Stage Presentation**:
  - `WorldPixelCompositor` utrzymuje świat w rastrze 320x180 skalowanym nearest do 640x360.
  - `CrispDiegeticText`, `InnerThoughtSurface` i `CRTDialogueBox` pozostają ostre ponad kompozytorem.
  - `Station 43` pełni teraz także funkcję **runtime release surface**: dwa panele
    `CrispDiegeticText` pokazują skrót licencji (`Zero-Asset` audio, proceduralny
    świat, assety Leny/portretów, Godot MIT i główne biblioteki) oraz credits
    produkcyjne bez wychodzenia poza diegezę.
- **LenaVisualRig 4.1 (`scripts/player/lena_visual_rig.gd`)**:
  - runtime używa **22 klatek PNG 64x104** z pivotem `(32, 96)`, bez proceduralnego rysowania ciała;
  - wysokość stojąca wynosi ~87 px, a faza chodu/biegu jest napędzana przebytym dystansem.
- **P7 Diagnostic Runtime**:
  - `DiagnosticSequenceDefinition` + lokalne czasowniki stacji + `GameStateManager.decisions` jako jedyny trwały JSON;
  - `tests/pkg_0151_smoke_test.gd` domknął techniczny audyt 15 sekwencji, routingu A/B/C, migracji checkpointów i round-trip stanu.
- **Shell, zapis i sterowanie**:
  - `project.godot` startuje z `scenes/shell/title_screen.tscn`;
  - `TitleScreen` pokazuje teraz wersję z `ProjectSettings` (`application/config/version`) wraz z viewportem 640x360 i fizyką 60 Hz;
  - `GameStateManager` prowadzi 01..41 → wybrany 42A/B/C → 43, utrzymuje save schema 1, pauzę, remap i PL/EN UI.

## 4. Dystrybucja i pakiety binarne

Aktualny stan powierzchni build/release po PKG-0154:

| Platforma | Bieżąca konfiguracja | Status |
|---|---|---|
| **Windows Desktop** | `export_presets.cfg` → `dist/windows/GettingStrange.exe` | świeży build PKG-0154 uruchomiony poza edytorem; shell pokazuje poprawny build label; clean-install `new_game`/save/`continue` potwierdzone |
| **Linux Desktop** | `export_presets.cfg` → `dist/linux/GettingStrange.x86_64` | świeży build PKG-0154 uruchomiony w WSL; shell pokazuje poprawny build label; `new_game`/`continue` potwierdzone śladem przejścia |

`tools/export_builds.ps1` działa teraz jako **audit-first + template-bootstrap workflow**:

- bez `-AllowBinaryBuild` raportuje tylko stan `dist/` i blokadę D-125;
- przy autoryzowanym rehearshal sam domontowuje zgodne standardowe template'y Godot 4.7.2;
- odrzuca eksport, jeśli preset próbowałby spakować `docs/`, `tests/`, `tools/`, `godot-mcp/`, `vibe-eyes/`, logi lub inne artefakty nietworzące gry;
- ma pozostać jedyną drogą do próbnego buildu P8.

## 5. Wynik audytów PKG-0152, PKG-0153 i PKG-0154 oraz stan gotowości

Potwierdzone po PKG-0154:

- dokumentacja release została zsynchronizowana z runtime P7 i z prawdziwym manifestem assetów;
- `assets/characters/lena/raw/` oraz `assets/characters/lena/logs/` są wyłączone z release surface przez `.gdignore`;
- `Station 43` pokazuje czytelny runtime credits/licence surface zgodny z `docs/LICENSES.md`;
- ekran tytułowy pokazuje wersję runtime z `ProjectSettings`, a nie hardcodowany opis buildu;
- `tests/pkg_0152_smoke_test.gd`, `tests/pkg_0153_smoke_test.gd` i `tests/pkg_0154_smoke_test.gd` domykają odpowiednio: audit-first surface, runtime version/licence surface oraz quarantine/template-bootstrap rehearsal;
- świeży Windows build poza edytorem przeszedł shell capture, `new_game`, zapis schema 1 i `continue` na checkpoint `station_01`;
- świeży Linux build uruchomił się w WSL, pokazał ten sam shell/build label i przeszedł `new_game` / `continue` do `Station01`.

Nadal jawnie ograniczone:

- natywny desktop Linux poza WSL 2 nie został jeszcze potwierdzony na prawdziwym stosie GPU/audio;
- wynik pozostaje dowodem technicznym RC, nie odbioru człowieka.

Werdykt PKG-0154 pozostaje **TECHNICAL PASS**, nie `PRODUCT GO`. PKG-0155
otworzył P9 i zablokował dystrybucję obecnej formy; natywny audit Linuxa może
wrócić dopiero po odbudowie produktu i nowym greenlight gate.
