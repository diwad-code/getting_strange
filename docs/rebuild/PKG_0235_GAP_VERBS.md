# PKG-0235 — Luki mowia o tej grze (Pakiet C)

Data: 2026-09-15
Decyzja: D-247
Plan: `docs/narrative/SENS_FABULARNY_PLAN_NAPRAWY_2026-09-15.md` Pakiet C (C1–C2)

To **nie** jest Pakiet C z wyczerpanego planu PKG-0231 (tamten poszedl
jako czesc PKG-0233). Freeze D-241 zdjety wylacznie dla tego pakietu.

## Cel

`GapLedger` nazywa pominiecie, ktore gracz naprawde pominol na trasie P9.
Odjazd bez P9-czynnosci otwiera luke o wlasciwej nazwie. Odjazd po
P9-czynnosci nie otwiera luki o kluczu, fotografii ani rekordzie pietra.

## Wdrozenie

### C1. Flagi i mysli na czasowniki kampanii

| Luka | Flaga (bylo / jest) | close_fact (nietkniety) | Mysl |
|---|---|---|---|
| `s09.floor_record_unread` | `is_floor_record_observed` → `is_private_boundary_respected` | `p9.mystery.home.trace` | dwa zycia / fotografia / granica sypialni |
| `s10.key_untried` | `is_key_trial_completed` → `is_marta_boundary_accepted` | `p9.mystery.marta.trace` | rozmowa z Marta przy stole (nietknieta) |
| `s11.photograph_unread` | `is_private_photograph_inspected` → `is_minimal_report_requested` | `p9.mystery.institution.trace` | wyciag z rejestru UCP (nietknieta) |
| `s15.signal_unconfirmed` | `is_local_signal_confirmed` (martwa) → `is_signal_confirmed` | `local_lena_signal_confirmed` | proba sygnalu (nietknieta) |

Id luk zostaja (0215 pinuje cele mapowan). Flagi sa realnymi `var` stacji
i ustawiaja je `respect_private_boundary` / `accept_marta_boundary` /
`request_minimal_report`. P7-callable (`test_key_without_claiming_home`,
`inspect_private_photograph`, `observe_floor_record`) nie zamykaja luk P9.

### C2. Feedback map

- `STATION_FEEDBACK_OVERRIDES["station_11|passage_required"]` usuniete.
  `passage_required` na 11 nie mapuje na fotografie (komoda z trasy, Pakiet A).
- `key_wear_required` / `key_trial_required` przeniesione do
  `NON_GAP_FEEDBACKS`. Nie sa jedyna droga `s10.key_untried`
  (`neighbour_context_required` zostaje). `key_trial_required` na 11 nie
  znaczy „brak fotografii”.
- Piny 0233: `method_snapshot_locked` i `finale_execution_started` zostaja
  w `NON_GAP_FEEDBACKS`.

## Weryfikacja

Bramka `tests/pkg_0235_gap_verbs_test.gd`:

1. flagi 09/10/11/15 sa P9, nie P7;
2. mysli 09/10/11 nie nazywaja rekordu pietra / klucza / fotografii;
3. wyjscie z 10 po tryptyku Marty nie otwiera `s10.key_untried`;
4. wyjscie z 10 bez granicy otwiera luke o stole; 11 nie przyjmie karty
   (wymaga `p9.mystery.marta.trace`);
5. P7-proba klucza w 10 nie zamyka luki P9;
6. wyjscie z 11 po wyciagu nie otwiera luki o fotografii;
7. C2: `passage_required` i `key_trial_required` na 11 nie mapuja na fotografie.

Sasiedzi: 0215 (fail-closed), 0233 (NON_GAP), 0234 (A nie cofniete), 0207.

## Twarde fakty

- `after_decision` zamykal luki P9 przez `close_fact` juz przed pakietem;
  tryptyk Marty i wyciag 11 nie otwieraly luk. Bugiem byla **flaga P7**:
  `is_key_trial_completed` zamykala `s10.key_untried` bez granicy Marty.
- `is_exit_unlocked` nie moze byc flaga luki: GSM `ensure_exit_open`
  (D-227) ustawia ja na kazdej stacji.

## Poza zakresem

Pakiet B (ciecia, HATCH 13, `arrival_side_for`), D, E. Akt I. Sceny `.tscn`.
PRODUCT GO. Release / `.exe` (D-168).

Automat dowodzi kontraktow, nie emocji ani zrozumienia (D-012, ADR-003).
