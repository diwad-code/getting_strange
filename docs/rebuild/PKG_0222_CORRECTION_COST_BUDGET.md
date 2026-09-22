# PKG-0222 — Korekta z kosztem + budżety (M7+M5+M10, faza R5)

Data: 2026-09-13. Dyspozycja: `docs/NEXT_SESSION_PROMPT.md` po PKG-0221
(faza R5 planu PKG-0213 §8, findings M7+M5+M10). Decyzja D-235.
Nie jest PRODUCT GO. GATE-REL, release i nowe `.exe` pozostają BLOCKED BY D-168.

## Co zmieniono (wylacznie stacje lokalne 14/15/18/01 — zero monolitow D-217)

1. Korekta M7 — puszczony most/krok = stan kosztu + linia L2 + zapis + zanik:
   - `station_14.gd` (`_apply_correction_pulse`, galaz yield): przy przejsciu
     A→B zapis `FACT_COST` = `dead_section_downstream` (istnial) + NOWE:
     wymuszony trigger linii L2 `s14_cost_hypothesis` (istniejacy beat, nigdy
     wczesniej nie wywolywany). Stan kosztu (`has_yielded_to_pulse` +
     `is_section_live() == false`) i zanik wizualny (przygaszenie sekcji
     w `_draw()`) istnialy — domknieto brakujace L2.
   - `station_15.gd`: NOWY `FACT_COST` (`p9.mechanics.mutual_signal.
     yield_cost_observed`) + flaga `has_cost_mark`. Proba korekty bez
     protokolu (`controls_incomplete`) zostawia odtad oprocz feedbacku trwaly
     stan kosztu, zapis kosztu i linie L2 (`s15_living_response`, istniejacy
     beat, force). Zanik wizualny: warunkowa wstawka w `_draw_station_props`
     (przygaszenie komory 0.18 + ostry czerwony akcent szwu) — domyslny kadr
     NIETKNIETY (HOLD 0198/0202/0203). Koszt nie potwierdza sygnalu i nie
     zamyka drogi (kontrakt §5).
2. Budzety M5 — 15/18 ≤3 interakcje:
   - Definicja pinowana bramka: distinct MRP ≤3 NA ADRES + sciezka krytyczna
     ≤3 distinct czasownikow tresci. Lancuch MRP 15 (log + 4 fazy nadajnika +
     notatka) jest ZAPINOWANY przez `pkg_0194` (swiadome uzbrojenie jako beat
     tresci) — nietkniety; trudnosc rozroznienia kontrola/korekta TO jest
     trudnosc ze zrozumienia, nie z czasu.
   - Realne skrocenie 15: potwierdzenie (`_apply_response`, galaz corrective)
     dorecza notatke tym samym zapisem (`abort_condition_before_cost` +
     `local_lena_intent_found` + `FACT_P7_REQUEST`); jawny `read_abort_note()`
     zostaje idempotentny (przed potwierdzeniem nadal `false` — pinuja to
     0163/0147/0120/0194 bez zmian). Sciezka direct-call: 5 wywolan / 3
     czasowniki (log / kontrola / korekta).
   - Realne skrocenie 18: patrz M10 — po usunieciu auto-domykania donora
     sciezka tresci to dokladnie 3 czasowniki (zestawienie / prawda /
     zatwierdzenie); wczesniej 4 (donor + 3).
3. Rodziny M10:
   - `station_18.gd` `select_operation()`: WYLACZNIE routing
     (`GameStateManager.select_finale_operation`, D-223 intact) + emit.
     Usunieto fabrykacje donora (4 wpisy), auto-`compare`, auto-`disclose_full`
     i auto-`commit_*`. Brak inwentarza (donor / zestawienie / prawda) ->
     istniejacy feedback `forecast_and_consent_inventory_required` z mapa na
     `s18.method_uncommitted` (GapLedger NIETKNIETY — shared) + mysl L2
     istniejaca maszyneria. Stan stacji zostaje niezatwierdzony (sciezka
     unseeded jak w 43).
   - `station_01.gd` + `station_18.gd`: NOWY const
     `IS_PHYSICAL_OBSTACLE_FREE := true` z komentarzem M10 (adresy decyzyjne,
     nie geometryczne; 14/15 znacznika NIE maja — maja fizyczna maszyne).

## Weryfikacja

- Baseline: `tools/verify_docs.ps1` PASS (52 pliki) przed edycjami.
- Nowa bramka `tests/pkg_0222_correction_cost_budget_test.gd` PASS (3× z rzedu):
  M7-14 (koszt + L2 + zapis + przywrocenie A + nazwanie), M7-15 (koszt
  wymuszenia + L2 + zapis + brak sygnalu + notatka przed potwierdzeniem falsz
  + auto-notatka po potwierdzeniu + MRP ≤3), M10+M5-18 (golas: routing B bez
  fabrykacji + luka; pelny inwentarz: routing C cicho; jawna 3-sciezka domyka
  metode; MRP == 3), markery 01/18 (const; 14/15 bez), KillZone 0 w
  `scripts/levels` + `scenes/levels` (prototyp `anchor_lab` wylaczony
  jawnie, jak w lincie).
- Czulosc: bramka asercjonuje NOWE symbole (`has_cost_mark`, `FACT_COST` 15,
  auto-`FACT_NOTE` bez odczytu, brak fabrykacji) — na starym kodzie FAIL.
- Pin `pkg_0207`: 116/115/114 po aktualizacji (regula D-222); 123. sekcja
  w `tools/verify.ps1`.
- Sasiedzi PASS bez dotykania: 0120, 0163, 0147, 0194, 0193, 0195, 0114
  (routing select intact), 0215 (mapa luk), 0217 (linie 13/18), traversal_lint.
- Kadry 14/15/18 6 PNG s100 full/notext + klatka kosztu 15
  (`reports/pkg_0222/visual/`, Iris Xe, OpenGL); inspekcja HOLD — domyslne
  kadry w duchu archiwow, klatka kosztu pokazuje wylacznie przygaszenie
  i czerwony szew.
- Zakresowa `verify_scoped.ps1` PASS (docs + smoke + 12 bramek; licznik D-217:
  1. zakresowa po pelnej PKG-0221). Blast: 4 skrypty stacji lokalnych + test
  + pin + 123. sekcja; monolity D-217 (MRP/GSM/audio/kompozytor/autoloady),
  enum, serialize, routing, progi, InputMap NIETKNIETE.

## Granice dowodu

Zielone bramki dowodza kontraktow mierzalnych (koszt/L2/zapis/zanik warunkowy,
budzety, brak auto-domykania, markery), nie czytelnosci kosztu ani wygody
sciezki (D-012, ADR-003). `is_exit_unlocked` NIE jest sygnalem bramki: GSM
`node_added → GapLedger.ensure_exit_open` otwiera wyjscia z automatu (D-227,
twardy fakt sesji — stad pozorne "odwrocone" komunikaty w 0163:111/132/158
przy asercjach na prawde). Checkpoint przed proba (§5.1 nawias) nie wdrozony —
poza kryteriami akceptacji pakietu; odnotowane jako otwarte.
