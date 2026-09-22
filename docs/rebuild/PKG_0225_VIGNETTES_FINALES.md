# PKG-0225 — Winiety i finały (V-pakiet + N-finały, faza R8)

Data: 2026-09-13. Dyspozycja: `docs/NEXT_SESSION_PROMPT.md` po PKG-0224
(faza R8 planu PKG-0213 §8: VIG-01..04 + FINALE + K1–K7). Decyzja D-238.
Nie jest PRODUCT GO. GATE-REL, release i nowe `.exe` pozostaja BLOCKED BY D-168.

## Audyt wejściowy (co było, czego brakowało)

- V (winiety): system kompletny od PKG-0190 (katalog 7, reżyser-autoload,
  odtwarzacz warstwa 19, skip od pierwszego wyświetlenia, tabele
  reduced-motion, zero podpisów od D-214), pinowany bramką `pkg_0190`.
  Brakowało pinów: zakaz winiety dla mechaniki 14, zakaz duplikacji cold
  openu, zero podpisów we WSZYSTKICH wpisach (0190 sprawdzał tylko VIG-01),
  skip drugiej winiety runtime, stany 43 z FULL_STORY.
- N (nośniki): K2-kubek częściowo obecny (42A-wizual, 42B-ciepły kubek,
  42C-dialog+półka, 43-epilog), K4-margines obecny (PKG-0223),
  K7-palimpsest obecny (PKG-0216). Brakowało: K1-kurtka w 42A/B/C (zero),
  K2-różnicowanie w 18 per truth_state (zero), K3-hełm w 42C (tylko linia
  `jakub_questions`), K5-blizna w 42B/C (zero), K6-szyld UCP w 05/18
  (tracker C-05 wymaga szyldu w 05, na dysku był generyczny drogowskaz).

## Co zmieniono (5 skryptów stacji lokalnych + testy — zero monolitów)

1. K1-kurtka (42A/42B/42C, prymitywy, zero assetów): 42A kurtka odwrócona na
   lewą stronę na oparciu pustego krzesła (jaśniejsza podszewka = odwrócenie)
   + beat `s42a_jacket`; 42B pusty hak na ścianie między progiem a stołem
   + beat `s42b_hook`; 42C kurtka na haku + beat `s42c_jacket` (cudze mydło).
2. K2-kubek (18): `_draw_marta_window` różnicuje drugi kubek per istniejący
   `marta_truth_state` (zero nowych faktów): full = oba obok siebie,
   partial = drugi jako słaby zarys, withheld = drugi odwrócony do góry dnem.
3. K3-hełm (42C): kącik imadła między przejściem a progiem (stół, imadło,
   hełm-kopuła z garnka, rant) + beat `s42c_helmet` (odsyłacz do konkretu
   z `jakub_questions`). Stacja 37 (legacy) celowo NIETKNIĘTA — poza
   blastem 42/43; powrót hełmu w 37 pozostaje otwarty.
4. K5-blizna (42B/42C): 42B koszula ściągnięta w dół na oparciu krzesła
   (dół poniżej listwy, beat `s42b_shirt`); 42C koszula przy imadle
   (beat `s42c_shirt`). Granica z 12 trzyma: zasłania, nie pokazuje.
   Bez nowych postaci (dyscyplina CAST/D-237).
5. K6-ulica-rym (05/18): 05 — drogowskaz staje się szyldem nocnych prac UCP
   (ta sama płyta 28×14, ten sam odprysk w prawym górnym rogu) + beat
   `s05_ucp_sign` ("Nowy wykonawca", tracker C-05) + bazowy cykl lampy
   (`_rhyme_phase`, 1.6 rad/s); 18 — ta sama płyta 28×14 z tym samym
   odpryskiem na fasadzie (pas między rzędami okien) + lampa z tym samym
   cyklem spóźnionym o `RHYME_FRAME_DELAY = 1.6/60` (dokładnie 1 klatka).
6. Beaty: 7 nowych L1-obserwacji (factual, bez hipotez), wzór K4 z PKG-0223
   (rejestracja + ślad w `_draw`, bez nowych triggerów — istniejące
   surfacingi nietknięte). Zero nowych writerów/flag/sygnałów/routingu;
   `creative_scene_lines.gd` NIETKNIĘTA (stąd brak churnu w `pkg_0194`).

## Weryfikacja

- Baseline: `tools/verify_docs.ps1` PASS (52 pliki) przed edycjami.
- Nowa bramka `tests/pkg_0225_vignettes_finales_pin_test.gd` PASS (3× z rzędu;
  po drodze 1× FAIL na brak znacznika K5 w komentarzu 42C — kontrolka
  fail-closed działa, naprawione w pakiecie): placement 7 (brak 14 i 01),
  zero podpisów 7/7, skip interact+ui_accept od startu + runtime skip
  vig_commit z flagą, 43: 3 gałęzie × 5 linii, konkretna czynność na końcu,
  brak narratora, brak tez; K1/K3/K5 beaty + markery; K2 trzy stany + ścieżki
  _draw bez błędów; K6 płyta/cykl/opóźnienie; zakaz tez na nowych tekstach.
- Sonda jednorazowa (usunięta po użyciu): `_rhyme_phase` 05 rośnie
  0.1167 → 0.6 w 30 klatek fizyki — napęd blinku działa.
- Pin `pkg_0207`: 119/118/117 po aktualizacji (reguła D-222); 126. sekcja
  w `tools/verify.ps1`.
- Sąsiedzi PASS bez obniżania progów: 0207, 0190 (winiety), 0195 (finały CR-C,
  43 bez tezy), 0107 (przebiegi rezerwowe 42), 0158 (05 Sadowa), 0215 (luki),
  traversal_lint.
- Kadry 05/18/42a/42b/42c 10 PNG s100 full/notext pre+post (Iris Xe, OpenGL,
  `reports/pkg_0225/visual/`, narzędzie `tools/capture_pkg_0225.gd`);
  inspekcja HOLD — kompozycje nietknięte, dodatki czytają się jako
  drobna scenografia (hak, koszula, kącik imadła, płyta UCP); zero napraw.
- Zakresowa `verify_scoped.ps1` PASS (exit 0; docs + smoke + 8 bramek;
  licznik D-217: 4. zakresowa po pełnej PKG-0221; PEŁNA obowiązkowo
  w PKG-0226). Blast: 5 skryptów stacji lokalnych + testy + pin + 126.
  sekcja + capture; monolity D-217, enumy, serialize, routing, progi,
  InputMap, linie, MRP-15 NIETKNIĘTE.

## Granice dowodu

Zielone bramki dowodzą kontraktów mierzalnych (placement, skip, stany 43,
obecność nośników, brak tez w nowych tekstach), nie tego, że kurtka "niesie
cenę pamięci" ani że rym 05/18 jest odczytany (D-012, ADR-003). Różnice
pikselowe pre/post toną w szumie fazowym lamp/CRT (fakt PKG-0221/0222) —
wnioski oczne, nie pikselowe. Odprysk szyldu (trójkąt 6×6 w kolorze ściany)
jest celowo subtelny: czyta się jako wyszczerbiony róg płyty, nie jako plama.
Kubki 18 widać dopiero po ujawnieniu prawdy (stan przechwycenia: nieujawniona).
Powrót hełmu w 37 oraz różnicowanie `household_*` po truth_state (N6-reszta,
PKG-0226) pozostają otwarte.
