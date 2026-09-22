# PKG-0226 — Truth-payoff + stół sześciu rzeczy (N6-reszta, faza R8)

Data: 2026-09-13. Dyspozycja: `docs/NEXT_SESSION_PROMPT.md` po PKG-0225
(faza R8 planu PKG-0213 §8: PKG-0226 truth-payoff + stół 6 rzeczy).
Decyzja D-239. Nie jest PRODUCT GO. GATE-REL, release i nowe `.exe`
pozostają BLOCKED BY D-168.

## Audyt wejściowy (co było, czego brakowało)

- N6 (audyt PKG-0213): warianty household full/partial/withheld różniły się
  1–2 liniami otwarcia przy identycznej reszcie; brak stołu 6 rzeczy
  (`FULL_STORY.md` §39: próbka domowa, sygnał miejscowej Leny, Marta, Jakub,
  rejestr UCP, stabilność węzła) w `method_commit_post_*`.
- Wypłata `truth_state` nie istniała ani w tekście (poza otwarciami), ani
  w obrazie (kubek K2 z PKG-0225 różnicował 18, ale finały nie).
- Twarde piny sąsiadów na treści household/metody: `pkg_0194` (run A/B/C:
  contains + ordered na liniach aktu i tailach), `pkg_0195` (run A/B/C na
  42A/B/C + tailsy), `pkg_0216` (Jadę/Tak w household_b_*, fallback wiedzy),
  `pkg_0223` (markery aktu), `pkg_0225` (nośniki K1/K2/K3/K5/K6).

## Co zmieniono (dane prezentacyjne + 4 stacje lokalne + testy — zero monolitów)

1. Dziewięć par wypłaty prawdy w `creative_scene_lines.gd` (DOPISANE na końcu
   wariantów, istniejące linie i kolejność nietknięte):
   - 42A (drugie zgłoszenie z APELU): full „dopiszę sama" / partial „zostawiam
     otwarte" / withheld „z samego imienia" (lustro wzoru 42B);
   - 42B (czytnik w torbie, lustro epilogu 43B): full „z pełnym zapisem" /
     partial „z niepełnym zapisem" / withheld „z wiadomością bez adresata";
   - 42C (półka i obcy detal z Ceny 42C): full „Zostaje na półce" / partial
     „opiszesz, kiedy będziesz umiała" / withheld „pusta do czasu zapisu".
   Tailsy świata i otwarcia nietknięte (pinują je 0194/0195). Zero nowych
   faktów/flag/sygnałów; linie ≤ 110 znaków (limit CRT); bez tez (D-214/D-219)
   i bez przedwczesnego słownika (D-211/0216).
2. Stół sześciu rzeczy w `method_commit_post` (FULL_STORY §39): gałąź dokleja
   6 par przeglądu głosem Leny z ISTNIEJĄCYCH decyzji (próbka ←
   home_sample_preserved, sygnał ← mutual_signal.log_reconstructed, Marta ←
   truth, Jakub ← consent, rejestr ← cost_ledger_read, węzeł ← zliczone luki
   w słowniku forecasts); brak to luka („prognozy niezestawione"), nie
   domysł. Kopia robocza `pairs.duplicate()` — const LINES niemutowany
   (idempotentne, pinowane bramką). Warianty serwują 2 pary aktu + 6 par
   stołu = 8.
3. Obraz (prymitywy, zero assetów): 18 — sześć kresek stołu pod słupkiem
   (`commit_table_marks`, cache odświeżany w `_ready`/porównaniu/prawdzie/
   metodzie; cyjan = znana, krótka bursztynowa = luka); 42A/B/C — pierścień
   prawdy NA BLACIE stołu (490,262), r8/w2.5: pełny (full) / połowa
   (partial) / z przerwą (withheld); cyjan po odczycie.
4. Twardy fakt narzędziowy: cienki łuk r5/w1.5 GINIE w próbkowaniu
   kompozytora 2x2 (dotyczy też istniejącego łuku haka K1 z PKG-0225 —
   w kadrze go nie ma, ścieżki bramki 0225 przechodzą); stąd r8/w2.5.
   Kadr (570,262) odpada — stoi na geometrii drzwi środowiska; blat
   (490,262) zweryfikowany jako pusty we wszystkich 3 finałach.

## Weryfikacja

- Baseline: `tools/verify_docs.ps1` PASS (52 pliki) przed edycjami.
- Nowa bramka `tests/pkg_0226_truth_payoff_table_pin_test.gd` PASS (3×):
  9 otwarć o parami różnych hashach; 9 znaczników wypłaty (każdy tylko
  w swoim wariancie); tailsy nietknięte; limity linii ≤ 115; brak tez
  i przedwczesnych terminów w nowych tekstach; stół 2+6 par na wariant
  z odczytem stanu (full/bare) i strażnikiem „surowej próbki" dla runu C;
  zero nowych faktów (brak record_decision + liczniki FACT_ 14/15/16/16);
  ścieżki _draw 18 + 42A/B/C (full/partial/withheld/pusto) bez błędów.
- Sąsiedzi PASS bez JEDNEJ zmiany treści (strategia append-only):
  0194, 0195, 0216, 0217, 0223, 0225, traversal_lint.
- Pin `pkg_0207`: 120/119/118 po aktualizacji (reguła D-222); 127. sekcja
  w `tools/verify.ps1`.
- Kadry 18/42a/42b/42c: 24 PNG s100 full/notext/read pre+post (Iris Xe,
  OpenGL, `reports/pkg_0226/visual/`, narzędzie `tools/capture_pkg_0226.gd`;
  wariant read = stan odczytu BEZ warstw tekstu: czysta scenografia ze
  znacznikami, bez panelu i przesunięcia kamery dialogowej). Inspekcja:
  kompozycje HOLD; 6 cyjanowych kresek pod słupkiem 18; trzy różne
  pierścienie na blatach (domknięty / połowa / z przerwą). Zero napraw
  po korekcie geometrii (r8/w2.5, blat).
- PEŁNA `tools/verify.ps1` PASS (exit 0, 127 sekcji; dowód
  `reports/pkg_0226_verify_full.log`, log bez FAIL/ERROR; licznik D-217
  ZRESETOWANY — ostatnia pełna PKG-0226).
- Blast: dane `creative_scene_lines.gd` (append-only) + station_18/42a/42b/
  42c + testy + pin + 127. sekcja + capture; monolity D-217, enumy,
  serialize, routing, progi, InputMap NIETKNIĘTE.

## Granice dowodu

Zielone bramki dowodzą kontraktów mierzalnych (9 różnych otwarć, stół 6
pozycji z lukami, obecność i kształt znaczników, brak tez w nowych
tekstach), nie tego, że wypłata prawdy jest odczytana ani odczuta (D-012,
ADR-003). Różnice pikselowe pre/post toną w szumie fazowym lamp/CRT —
wnioski oczne, nie pikselowe (fakt PKG-0221/0222/0225). Powrót hełmu w 37
(legacy) pozostaje otwarty (poza blastem). Faza R8 zamknięta w całości
(PKG-0225 + PKG-0226); kolejka: faza R9 (higiena i narzędzia, PKG-0227).
