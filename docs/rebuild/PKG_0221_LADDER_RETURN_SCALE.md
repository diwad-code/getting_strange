# PKG-0221 — Drabina + Return + skale (M9+M3+M1-część, faza R5)

Data: 2026-09-13. Dyspozycja: `docs/NEXT_SESSION_PROMPT.md` po PKG-0220
(faza R5 planu PKG-0213 §8, findings M9+M3+M1-część). Decyzja D-234.
Nie jest PRODUCT GO. GATE-REL, release i nowe `.exe` pozostają BLOCKED BY D-168.

## Co zmieniono

1. Drabina — intencja w strefie (M9):
   - `scripts/environment/ladder_zone.gd`: `_on_body_entered` rejestruje
     wyłącznie kandydaturę (`is_player_in_range` + `_candidate`), nigdy
     `attach_to_ladder`. Montowanie wyłącznie przez `try_mount()` po bramie
     intencji ocenianej W STREFIE (interact albo stop+góra: `velocity.x`
     < 28 px/s i poziomowy input < 0.2); `_unhandled_input` (interact) oraz
     polling góra-przy-zatrzymaniu w `_physics_process`.
   - `scripts/player/prototype_player.gd`: usunięty auto-mount z bliskosci
     i cały `jump-off` (skok na drabinie nie wypina; zejście = dół przy
     podłodze / opuszczenie strefy, D-123/§7.5). Nowe `begin_climb()`
     wołane wyłącznie przez strefę; gracz tylko podtrzymuje wspinaczkę.
2. Return jako drugi Threshold (M3):
   - `scripts/environment/return_zone.gd`: `_on_body_entered` ustawia tylko
     zasięg (zero emisji); powrót wyłącznie `trigger_return()` (interact),
     jak próg wprost; `target_station` = poprzednik wg GameStateManager,
     `aperture_rect`/`entry_family` jak specyfikacja Bindera (fallback DOOR
     54×114), `is_open` zawsze; centrowanie kamery przed emisją (D-148).
   - Priorytet jak D-228: strefy NIE konsumują `interact`
     (propsy MRP i progi pierwsze) — konsumpcja wyłożyła bramkę 0194
     realnym FAIL-em (głodzenie MRP), naprawiona w tym samym pakiecie.
   - `station_05/06/07/08/43.gd`: usunięte podpięcia
     `return_zone.body_entered` → emisja (progresja z overlapu) i ich
     handlery sprowadzone do `pass` (wzór Airlock z PKG-0174).
3. Skale (M1-część + lint):
   - `station_02.tscn`: drabina 80 → 76 (wystawanie 12 px nad lądowiskiem).
   - `station_15.tscn`: drabina 130 → 150 (wystawanie 12 px nad sill włazu).
   - `station_16.tscn`: drabina y 296 → 288 (dół na podłodze 288).
   - Drabin nie doklejono (route: tylko 02/15/16); legacy 30/32/37 nietknięte;
     apertury Bindera nietknięte (re-pin read-only); D-227 stoi.

## Weryfikacja

- Baseline: `tools/verify_docs.ps1` PASS (52 pliki) przed edycjami.
- Nowa bramka `tests/pkg_0221_ladder_return_scale_test.gd` PASS (3× z rzędu):
  statyka (intencja w strefie, brak jump-off, powrót bez progresji, zero
  podpięć `return_zone.body_entered` w 45 skryptach), runtime drabiny
  (10 prób biegu = 0 przypięć, stop+góra = wejście, skok nie wypina,
  interact montuje, wyjście odpina), runtime powrotu (overlap 02/15/16
  milczy, trigger wraca, target 01/14/15 = GSM, apertura legalna),
  GATE-SCALE (grafika vs kolizja 2/1 px, dół na podłodze ≤ 2 px,
  wystawanie 12/12 px, route-drabiny tylko 02/15/16, zero statycznych
  Thresholdów, apertury Bindera legalne), fail-closed (fallback 54×114,
  pusty target, odmowa poza zasięgiem).
- Pin `pkg_0207`: 115/114/113 po aktualizacji (reguła D-222);
  122. sekcja w `tools/verify.ps1`.
- Kontrolowane aktualizacje starych asercji (wzór D-216/D-218, wykryte
  realnymi FAIL-ami): 0135/0136/0137/0138/0140 (powrót przez trigger),
  0157 (`ladder_height >= 72`, próg 80 starszy niż kanon §9.3),
  0170 (powrót 43 przez trigger).
- Przywrócony wpis `common/physics_ticks_per_second=60` w `project.godot`
  (zniknął między PKG-0220 a sesją przy zimnym starcie silnika; runtime
  cały czas 60; wpis przetrwał wszystkie przebiegi pakietu).
- Kadry 02/15/16 6 PNG (`reports/pkg_0221/visual/`, Iris Xe, OpenGL);
  inspekcja HOLD obrazu, zero napraw.
- PEŁNA `tools/verify.ps1` PASS (exit 0, dowód
  `reports/pkg_0221_verify_full.log`); licznik D-217 ZRESETOWANY
  (ostatnia pełna PKG-0221).

## Granice dowodu

Zielone bramki dowodzą kontraktów mierzalnych (intencja, brak jump-off,
powrót interact-only, skale, piny), nie wygody wspinaczki ani czytelności
powrotu (D-012, ADR-003). Bramka 0221 wyłącza auto-transzycje GSM na czas
pomiaru ciszy (osobny proces; transzycje w grze nietknięte). Spawny graczy
8 px w podłodze na stacjach z grubszą płytą (np. 16) to zastany fakt poza
zakresem — lint mierzy drabinę, nie spawn.
