# Aktualny stan projektu

Stan na: 2026-09-03 po PKG-0182 (absolutny audyt i ewolucja całej gry; BUNDLE-32).

> **PKG-0182 — TECHNICAL PASS, bez PRODUCT GO.** Pełny audyt plików i powierzchni,
> naprawy P0–P2, dwa wdrożone pomysły kreatywne, recertyfikacja i snapshot.
> Raport: `docs/rebuild/PKG_0182_COMPREHENSIVE_AUDIT_REPORT.md`. Dowody:
> `reports/pkg_0182/`. Verifier wymusza WASAPI na Windows headless i fail-closed
> politykę logów (ObjectDB/RID/orphans/WARNING). Release i nowe `.exe` pozostają
> zablokowane (D-168). Następny pakiet: niezależny red-team PKG-0183 według
> `docs/PLUS_SESSION_PROMPT_2_A.md`. Nie uruchamiać równolegle z 0184.

> **UWAGA NADRZĘDNA.** Wszystkie dziewięć defektów prezentacji zgłoszonych przez
> właściciela 2026-09-02 (DEF-1..DEF-9), audyt 360° jakości oraz pakiet szlifu
> akustycznego PKG-0180 zostały wdrożone i zintegrowane. Wprowadzono 7 dedykowanych
> generatorów proceduralnego dźwięku otoczenia (wiatry estakad i peronów, rezonanse
> podziemne, szum Wisły o świcie) oraz płynne wyciszanie tła (ambient ducking)
> podczas odczytów dialogów i dzienników.
> **14 bramek produktu + bramki PKG-0179 i PKG-0180 mają status TECHNICAL PASS / PASS (RECERTIFIED).**
> Ciągły przebieg M1 z czystymi czasownikami gracza pokonuje trasę 20 adresów (187,9 s sim).
> Próbkowanie zamiaru (GATE-OBJ) osiąga 100% zgodności.
> Szablony eksportu i struktura dystrybucji `dist/` w pełni zweryfikowane.
> Werdykt CHECKPOINT-06: **GO**. Status: **PRODUCT GO CANDIDATE / READY FOR RELEASE ORDER**.
> Raport wykonawczy dla właściciela: `docs/rebuild/EXECUTIVE_RELEASE_ASSESSMENT.md`.
> Release i nowe `.exe` pozostają zablokowane do formalnego polecenia właściciela (D-168).
CHECKPOINT-02: GO; CHECKPOINT-03: PIVOT spłacony; CHECKPOINT-04: GO 7/7;
CHECKPOINT-05: GO; CHECKPOINT-06: **GO (14/14 bramek technicznie zaliczonych + PKG-0179 PASS + PKG-0180 PASS)**.
Wszystkie pakiety naprawy prezentacji PKG-0171..0178, audytu PKG-0179 oraz szlifu mistrzowskiego PKG-0180 są zamknięte i zweryfikowane.

Katalog: `C:\getting_strange`
Cel silnika: Godot 4.7.x; `project.godot` deklaruje funkcje 4.7 i GL Compatibility.
Executable zweryfikowany przez `tools/verify.ps1`: `Godot 4.7.2.stable.official.ed1daf0bf`.
Wersjonowanie: brak; pliki na dysku sa jedynym stanem (D-016)

## Aktywna faza

**P6: Human Scale & Playability — ZAMKNIĘTA (PKG-0142).**

**P7: Gameplay Depth Rebuild — ZAMKNIĘTA (PKG-0151 / D-164).**

**P8: Release Candidate Readiness — ZAMKNIĘTA TECHNICZNIE; runtime pozostaje
materiałem dawcy, nie greenlightem produktu.**

**P9: Product Rescue & Hybrid Rebuild — OTWARTA; PHASE-01..07 ZAMKNIĘTE.**

**PHASE-08: Presentation & Comprehension Repair — ZAMKNIĘTA (PKG-0177 / BUNDLE-31).**
Zamknięte pakiety: **PKG-0171 / BUNDLE-26**, **PKG-0172 / BUNDLE-27**,
**PKG-0173 / BUNDLE-28**, **PKG-0174 / BUNDLE-29**, **PKG-0175 / BUNDLE-30**,
**PKG-0176 / BUNDLE-30**, **PKG-0177 / BUNDLE-31** (integracja, 14 bramek i CHECKPOINT-06 GO),
**PKG-0178** (raport wykonawczy gotowości wydania).
Specyfikacja: `docs/rebuild/PRESENTATION_REPAIR_PLAN.md`.

**PHASE-09: 360° Quality Pass & Audit Remediation — ZAMKNIĘTA (PKG-0179).**
Plan nadrzędny wdrożenia: `docs/rebuild/AUDIT_IMPLEMENTATION_PLAN.md`.
Prompt wykonawczy mega-pakietu: `docs/PLUS_SESSION_PROMPT.md`.

**PHASE-10: Absolute Game Audit & Evolution — ZAMKNIĘTA TECHNICZNIE (PKG-0182 / BUNDLE-32).**
Inventory 898 plików / 951 wierszy pokrycia. Otwarte P0/P1/P2 = 0. P3 backlog:
monolit `memory_resonance_point.gd` (F-0182-003). Dwa pomysły kreatywne wdrożone
(audio headroom, nienormatywne wcięcia progu). Żaden PASS nie jest dziedziczony
przez PKG-0183 — red-team ma falsyfikować twierdzenia tego pakietu od zera.

### Dziewięć defektów (2026-09-02) — status po PKG-0177 / PKG-0178

| ID | Defekt | Status |
|---|---|---|
| DEF-1 | brak intra; gracz nie wie, kim jest ani czym są drgania | **ZAMKNIĘTY TECHNICZNIE** — dwie warstwy w silniku, GATE-INTRO |
| DEF-2 | portret Marty to przemalowany portret Leny | **ZAMKNIĘTY TECHNICZNIE** — unikalny `marta.png` 1024×1024 |
| DEF-3 | NPC to kółka i trapezy, 22–48 px zamiast 84–92 px | **ZAMKNIĘTY TECHNICZNIE na trasie 20 adresów** |
| DEF-4 | wejścia to marsz w prawo w niewidzialny `AirlockZone` | **ZAMKNIĘTY TECHNICZNIE** — `ThresholdZone` + `interact`; `AirlockZone` jest domknięciem |
| DEF-5 | potykanie i przysiad na każdym stopniu | **ZAMKNIĘTY TECHNICZNIE** — `try_curb_step()` mierzy `h`, interpoluje 0,18–0,24 s, `_stepping` blokuje lądowanie/squash/`jump_fall` |
| DEF-6 | drabina narysowana 62 px obok strefy; brak widoku od tyłu | **ZAMKNIĘTY TECHNICZNIE** — jeden rysunek z `LadderZone`; `climb_back_0..3`; intencja, nie otarcie |
| DEF-7 | drzwi 170–180 × 18–24 px przy kanonie 109 × 42–48 | **ZAMKNIĘTY TECHNICZNIE (otwory)** — `aperture_rect` w kanonie §7.1 |
| DEF-8 | twarde bramkowanie wyjścia w 18 adresach | **ZAMKNIĘTY TECHNICZNIE** — wyjście otwarte od `_ready()`; luka zamiast drzwi |
| DEF-9 | obsady nie ma na trasie 20 adresów | **ZAMKNIĘTY TECHNICZNIE (D-194 B)** |

Wszystkie dziewięć zgłoszeń właściciela jest zamkniętych i zintegrowanych.
CHECKPOINT-06 zakończony werdyktem **`GO`**.

Decyzje D-121..D-197. Runtime:

1. Lena 4.2: stany `step_up` / `step_down` / `climb_back` / `ladder_mount` /
   `ladder_dismount` / `enter_door` / `board_vehicle` na płótnie 64×104,
   pivot (32, 96).
1b. `ThresholdZone` rysuje otwór z `aperture_rect`. Wejście wymaga `interact`.
   `AirlockZone` nie startuje postępu. Rodziny `DOOR` / `VEHICLE` / `HATCH`.
2. `try_curb_step()` podnosi o zmierzoną wysokość podstopnicy, nie o stałe 18 px.
   Limit `MAX_CURB_STEP = 18` (D-123) zostaje.
3. Flaga `_stepping` blokuje `play_landing()`, `_emit_landing_dust()` i
   `_play_squash_stretch()`.
4. Drabina: `LadderZone` jest jedynym źródłem rysunku. Station 02 `ServiceLadder`
   stoi na podłodze `(570, 296)`, `ladder_height = 80`.
5. Wspinaczka wymaga `interact` albo `move_up` przy zatrzymanej postaci.
6. `CharacterVisualRig`: to samo płótno i pivot, 7 stanów prezentacyjnych.
7. Cykl chodu i biegu napędzany dystansem; `start`/`stop`/`turn` to nakładki.
8. Pełne przejście bazuje wyłącznie na czasownikach gracza (D-141).
8b. `GapLedger` + `GameStateManager.open_gaps`: pominięty odczyt otwiera lukę
    przy wyjściu. `_unlock_exit()` nie jest bramką na trasie 20 adresów.
    `OpeningActionPoint` nie ukrywa odczytu. Station 18 zatwierdza metodę
    z lukami; Station 03 `board_line_four` zawsze kończy stację.
9. **Zimne otwarcie (PKG-0176, D-195, D-197).** `Nowa gra` →
   `scenes/shell/cold_open.tscn` (warstwa A, 14,5 s; 12,5 s w reduced motion)
   → `station_01` w stanie wstępnym (warstwa B). `Kontynuuj` pomija warstwę A.
   Flaga `cold_open_seen` żyje w pliku ustawień; starszy plik bez tego klucza
   jest przyjmowany. Warstwa A nie jest adresem kampanii i nie liczy się do
   budżetu 20 adresów ani do GATE-INT.
10. **Anatomia postaci nie jest rysowana w silniku (D-197).** Ujęcie 2 warstwy A
   jest planszą z `gen-ai character` na referencji istniejącej klatki Leny.
   Ujęcia 1 i 3 zostają proceduralne, bo muszą się animować.

## Zimne otwarcie — co gdzie mieszka

| Element | Plik |
|---|---|
| katalog pięciu faktów, kolejność „drgań”, lint §5 | `scripts/campaign/cold_open_facts.gd` |
| proceduralny przebieg drgań (obie warstwy) | `scripts/visual/vibration_trace_display.gd` |
| warstwa A — trzy ujęcia | `scenes/shell/cold_open.tscn`, `scripts/ui/cold_open.gd` |
| plansza ujęcia 2 (gen-ai, D-197) | `assets/cold_open/shot2_rail_hands.png` |
| prompt i referencja planszy | `assets/characters/lena/raw/pkg_0176/`, referencja `raw/pkg_0173/step_up_0.jpg` |
| pieczenie planszy | `tools/process_cold_open_plate.py` |
| warstwa B — stan wstępny Station 01 | `scripts/levels/station_01.gd`, `scenes/levels/station_01.tscn` |
| routing `Nowa gra` i flaga pomijalności | `scripts/core/game_state_manager.gd` |
| bramka GATE-INTRO | `tests/pkg_0176_smoke_test.gd` |
| kadry „po” | `tools/capture_pkg_0176.gd` → `reports/pkg_0176/` |

## Station 02 / 08 / 15 / 16 po PKG-0173

- Station 02: usunięty ręczny rysunek drabiny z `_draw_outdoor_detour()`
  (szyny `564/576` na y ∈ [162, 256]). `ServiceLadder` rysuje się sam.
- Station 08: podstopnice 12 px; krok interpoluje o zmierzone `h`, nie 18 px.
- Station 15 / 16: `Props/ServiceLadder` bez drugiej drabiny w `_draw()`;
  zgodność rysunku ze strefą ≤ 2 px w pionie, ≤ 1 px w osi x.

## Ostatnia swieza weryfikacja

- Data: 2026-09-03, PKG-0182. Hardware: Intel Iris Xe, OpenGL 3.3.0 Build 32.0.101.7085, Godot 4.7.2.stable.official.ed1daf0bf.
- Baseline przed naprawą: `reports/pkg_0182/baseline.log` — `Verification passed.` przy **49** liniach ObjectDB leak. To był obowiązkowy finding, nie PASS.
- Wąski smoke PKG-0182 (WASAPI + log policy): `PKG-0182 SMOKE PASS` i `LOG_POLICY_PASS` (`reports/pkg_0182/pkg_0182_smoke_probe.log`).
- Trasy czasownikami gracza: minimal 171,72 s (42B), full 187,90 s (42A), mixed 181,43 s (42C); 3/3 finałów.
- Capture: 97 kadrów normal-driver; 22/22 par `normal`/`key_object` o różnych MD5.
- Audio: 256 generatorów, 0 clipped samples.
- Soak 3 cykle: object_count wraca do 1991, cache 0.
- Pełna `tools/verify.ps1`: `Verification passed.` w 1009,4 s; `reports/pkg_0182/final.log` (1020 linii). ObjectDB/RID/Leaked instance = 0. Trzy `WARNING:` to wyłącznie allowlistowane fallbacki zapisu/ustawień.
- 14 bramek produktu pozostaje `TECHNICAL PASS`; PRODUCT GO i GATE-REL nadal zablokowane (D-168).
- Raport: `docs/rebuild/PKG_0182_COMPREHENSIVE_AUDIT_REPORT.md`.

## Czego jeszcze nie potwierdzono

- Zewnętrzne playtesty ludzi (D-012, ADR-003) — brak ze względu na kontrakt projektu.
- Steam Deck / AMD / NVIDIA; natywny desktop Linux poza WSL 2.
- **H-048 odbiór:** testy nie dowodzą, że historia „się klei” bez odczytów;
  dowodzą braku softlocka i 20/20 otwartych wyjść.
- **H-049 zrozumienie otwarcia:** GATE-01 / GATE-INTRO dowodzą, że pięć faktów zostało
  pokazane właściwym nośnikiem, w kolejności i w czasie. Nie dowodzi, że nowa
  osoba zrozumiała, kim jest Lena i czym są drgania.
- GATE-REL: wymaga polecenia właściciela do zdjęcia blokady release (D-168).
- Fizyczna ergonomia pada: `BLOCKED` (brak kontrolera na stacji).
- F-0182-003: monolit `memory_resonance_point.gd` zostaje P3 backlogiem.
- Fun / emocja / uroda / ludzka zrozumiałość: `OPEN-NO-EVIDENCE`.

## Nastepny pakiet

- **PKG-0183 / BUNDLE-33 — niezależny red-team audyt i naprawy** według
  `docs/PLUS_SESSION_PROMPT_2_A.md` (skopiowanego do `docs/NEXT_SESSION_PROMPT.md`).
  Każdy PASS PKG-0182 jest hipotezą do falsyfikacji. Artefakty wyłącznie w
  `reports/pkg_0183/`. Nie nadpisywać dowodów PKG-0182.
- Dopiero po zamknięciu PKG-0183: `docs/PLUS_SESSION_PROMPT_2_B.mm` jako
  PKG-0184 / BUNDLE-34. Nie uruchamiać 0183 i 0184 równolegle.
- Release Execution i nowe `.exe` nadal wymagają osobnej dyspozycji (D-168).
