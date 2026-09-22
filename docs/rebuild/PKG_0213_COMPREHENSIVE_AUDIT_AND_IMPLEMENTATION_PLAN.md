# PKG-0213 — Kompleksowy audyt gry 360° i plan wdrożenia zmian

Data: 2026-09-12. Dyspozycja: polecenie właściciela w roli szefa projektu /
dyrektora artystycznego / producenta / wizjonera — „pełny audyt gry, każdy
aspekt, oraz szczegółowy plan wdrożenia zmian do osobnego pliku".
Ścieżka D (minimalna, dokumentacyjna, zero logiki / zero obrazu).
Decyzje D-168, D-220, D-221, D-222, D-223, D-224, D-225, D-226 obowiązują
bez zmian. Ten dokument jest diagnozą i planem. Nie jest werdyktem
o zabawie, emocji ani zrozumieniu (D-012, ADR-003). Nie jest PRODUCT GO.
GATE-REL, release i nowe `.exe` pozostają BLOCKED BY D-168.

Pytanie pakietu: **gdzie gra wymaga poprawek / modyfikacji / zmian,
jakie ulepszenia i nowe kreatywne pomysły warto wdrożyć, oraz w jakiej
kolejności je ciąć, żeby każdy kolejny pakiet domykał się na zielono?**

Metoda: cztery równoległe ścieżki audytowe (narracja, mechaniki, obraz,
audio+technika) na plikach z dysku + baseline `verify_docs.ps1` PASS
(52 pliki). Bez nowych renderów. Bez zewnętrznych testerów — nigdy.
Inwentaryzacja dysku z sesji: 45 skryptów `station_*.gd` ↔ 45 scen
`station_*.tscn` 1:1 (D-226), 105 plików `tests/*.gd`, 107 wywołań
`Invoke-GodotGate` w `verify.ps1` (D-222 po aktualizacji 0212).

Dokumenty źródłowe audytu (kanon nadrzędny, nie diagnoza):
`PLAYER_CONTRACT.md`, `CAMPAIGN_MAP.md`, `LOCATION_FAMILY_BIBLE.md`,
`ACCEPTANCE_MATRIX.md`, `PROJECT_REBUILD_EXECUTION_PLAN.md`,
`NARRATIVE_BIBLE.md`, `FULL_STORY.md`, `DIALOGUE_SCRIPT.md`,
`CONTINUITY_TRACKER.md`, `VISUAL_DESIGN.md`,
`PIXEL_PRESENTATION_ARCHITECTURE.md`, `TRAVERSAL_AND_OBSTACLE_DESIGN.md`,
`THRESHOLD_AND_ENTRY_CONTRACT.md`, `PROGRESSION_FLOW_CONTRACT.md`,
`WORLD_SCALE.md`, `CAST_AND_NPC_BIBLE.md`, `COLD_OPEN_SPEC.md`,
raporty PKG-0187/0190/0193/0194/0205/0206/0207/0208/0211/0212.

---

## 1. Werdykt zbiorczy (jedno spojrzenie)

| Tor | Stan kontraktu | Blokuje GO? |
|---|---|---|
| Narracja / dialogi / fabuła | struktura TRZYMA, 10 findings (słownik, bramka wiedzy, synteza, tempo, głosy) | TAK — F3 bramka wiedzy jest dziurawa (lint omijany przez `creative_scene_lines.gd`) |
| Mechaniki / traversal / Anchor-Yield | kontrakt Threshold/GapLedger NIE WDROŻONY w scenach (kod istnieje, sceny nie) | TAK — F1/F2 mechaniczne (zero `Threshold` w `.tscn`, wyjścia bramkowane `_unlock_exit`) |
| Obraz / obsada / rodziny | TECHNICAL PASS kruchy (farba zamiast bryły, fartuch 09, paleta, sufit, linie 1px) | TAK — F-01/F-02 wizualne (dziura kadru dialogowego w 09) |
| Audio proceduralne | kontrakt PCM TRZYMA (D-225), ambient gra z przerwą retriggera, duck niepełny | NIE BLOKUJE GO samo, ale P1 słyszalne co ~2 s |
| Technika / routing / bramki | TECHNICAL PASS TRZYMA (routing 18, selector 20, pin 107/106/105, warstwy, reentrancja) | NIE — ale GATE-REL nadal BLOCKED, PRODUCT GO CANDIDATE |

Najtańsza kolejność napraw (uzgodniona między torami):
mechaniczne odbramkowanie + Threshold w scenach → domknięcie bramki wiedzy
narracyjnej → fartuch+paleta 09 → pętle ambientu → drabina/Return/luki →
skala otworów → dyferencjacja urządzeń/głosów → rigi vendor/neighbour →
pakiet winietowy → higiena narzędziowa.

Żaden krok nie dodaje adresów, rodzin, interakcji, faktów ani postaci
bez osobnej dyspozycji (granica z `NEXT_SESSION_PROMPT.md`).
Ekstrakcja tabel MRP (PKG-0206 krok 2) nadal wymaga jawnej dyspozycji
(shared-touch → pełna `verify.ps1`).

---

## 2. Audyt narracji (10 findings N1–N10)

Źródła: `NARRATIVE_BIBLE.md` (392 l.), `FULL_STORY.md` (736 l.),
`DIALOGUE_SCRIPT.md` (668 l.), `CONTINUITY_TRACKER.md`,
`creative_scene_lines.gd` (223 l.).

- **N1. Dryf terminologiczny metody (P0).** `Zakotwiczenie` (kanon,
  `NARRATIVE_BIBLE.md:379`) vs `Utrzymanie` (`creative_scene_lines.gd:31`
  `relay_logbook_named`, `FULL_STORY.md:20-21`). Dwa leksemy na jedno
  zachowanie; gracz dostaje synonim bez obrazu. Poprawka:
  `creative_scene_lines.gd:31` → wyłącznie `Zakotwiczenie`; potem
  ujednolicenie `FULL_STORY.md` + `PKG_0193/0194`.
- **N2. Synteza 13 bez trzeciego głosu (P1).** `synthesize` (`gd:27`):
  `Marta: Zostawiła po sobie tę próbę` — sugeruje świadomy test przed
  logiem 15; kanon 13 wymaga tylko `To nie jest mój świat / Więc gdzie
  jest ona? / Nie wiem` (`FULL_STORY.md:11-15`). Legacy trójgłos
  (Lena-nośnik, Jakub-czas, Marta-test, `DIALOGUE_SCRIPT.md:351-355`)
  zredukowany do dwóch. Poprawka: usunąć zdanie o próbie, dodać 1 kwestię
  Jakuba przez łącze / odczyt jego sprawdzenia numeru jako trzeci głos
  przy stole (bez sprowadzania aktora).
- **N3. Bramka wiedzy D-211 omijana (P0, dziura strukturalna).**
  `PKG_0194:69-79` wprost: treść 17/18 żyje w `creative_scene_lines.gd`
  poza zasięgiem linta `pkg_0165`; fallback dynamiczny `gd:8-13,127-128`
  łata. Lint GREEN przez wyłączenie, nie zgodność. Poprawka: rozszerzyć
  lint na prezentowaną treść (test treści, nie pliku stacji), furtki
  D-211 nie trzymać na stałe. Pliki: `station_17.gd` + `pkg_0165_*`.
- **N4. Adres 15 = trzy stacje w jednej (P1).** Nowy 15 = legacy
  26+27+33 (`CAMPAIGN_MAP.md:83`). `loop_logbook` (`gd:35`, 4 linie)
  tłumaczy przyczynowość CR-D tekstem (`DZIENNIK PĘTLI`), fakt powstaje
  w tekście nie czynności; kompresja łamie limit 8–14 wymian
  (`DIALOGUE_SCRIPT.md:39`) i regułę kontraktu §1. Poprawka: rozbić na
  pokaz → nazwanie; część przenieść do obrazu/działania.
- **N5. Rejestr par i prognozy jako gadające tablice (P1).**
  `cost_ledger_console` (`gd:50`, 3 linie) zamyka rachunek Linii 4;
  `forecast_comparator_*` (`gd:57-60`, `TABLICA PROGNOZ`) wypowiada
  chronioną wartość/stratę; w wariancie `granted` brak czerwonych pól
  `brak danych` (`FULL_STORY.md:475-476`); nowe urządzenie-narrator tuż
  przed finałem wbrew `NARRATIVE_BIBLE.md:254-256`. Poprawka:
  zróżnicować urządzenia, dopisać jawne `brak danych`.
- **N6. Finały: `marta_truth_state` bez wypłaty + `Tak/Jadę` (P0/P1).**
  Warianty full/partial/withheld (`gd:71-89`) różnią się 1–2 liniami;
  reszta identyczna. `TRACKER.md:250,268` wymaga jakości skutku ze zgód.
  Sprzeczność: 42B `Jadę` vs `FULL_STORY.md:671-672` `Tak` vs
  `DIALOGUE_SCRIPT.md:168-174`. Brak stołu 6 rzeczy
  (`FULL_STORY.md:599-600`) w `method_commit_post_*` (`gd:64-66`).
  Poprawka: palimpsest (patrz K7), zróżnicowanie `household_*` po
  `truth_state`, 3 warianty czynności zamiast mantry `Moja prośba…`.
- **N7. Wierzbicka-recepcjonistka + homofoniczne urządzenia (P1).**
  Kanon: strona bezosobowa, kwalifikatory (`DIALOGUE_SCRIPT.md:85-94`).
  `gd:21,23` brzmią jak recepcja. `REJESTR/ANALIZATOR/EKRAN/TABLICA/
  DZIENNIK` mówią tym samym capsem; bez etykiet nierozróżnialne
  (łamie `DIALOGUE_SCRIPT.md:41`). Poprawka: przepisać Wierzbicką na
  bezosobową + dyferencjacja urządzeń (rejestr = numery/daty, analizator
  = wykres, notatka = odręczny wtręt).
- **N8. Miejscowa Lena za chuda (P2).** Tylko `NOTATKA SERWISOWA`
  (`gd:39`) + `DZIENNIK PĘTLI`; brak intymnego konkretu do stracenia;
  pytanie Marty z 13 nie ma paliwa do 38. Poprawka: margines ołówkiem
  (patrz K4), bez monologu-ducha (zakaz stoi).
- **N9. Tempo: 09 rozdrobniony, 17 przeładowany (P2).** 09 = 3 punkty
  × 2 linie bez centralnej rozmowy; 17 = 3 akty w limicie ≤3
  (`CAMPAIGN_MAP.md:240-246`). Jakub znika 12→17 poza formułą napędu
  (`TRACKER.md:208-212`). Poprawka: scalić 09 wokół fotografii, odciążyć
  17 (oferta jako gest/przestrzeń, nie trzeci akt tekstowy).
- **N10. Polszczyzna: baza dobra, 5 potknięć (P2).** Konkret/deiksa/
  granica na plus (`parking/kaloryfer`, `W którym tunelu?`,
  `Nie będę cię więcej prosić o bliznę`). Do przepisania:
  nominalizacja `Utrzymanie i uległość`, niejasne `ją` (`gd:35`),
  sensacyjne `ona go zabiła` → `powiązany koszt` (`gd:50`), mantra
  `Moja prośba, mój ruch` ×3, kryptonim `Para 04/17` bez obrazu.

---

## 3. Audyt mechanik (10 findings M1–M10)

Źródła: `TRAVERSAL_AND_OBSTACLE_DESIGN.md`,
`THRESHOLD_AND_ENTRY_CONTRACT.md`, `PROGRESSION_FLOW_CONTRACT.md`,
`station_01/14/15/18.gd`, `prototype_player.gd`, `threshold_zone.gd`,
`ladder_zone.gd`, `gap_ledger.gd`, `anchorable_object.gd`,
`anchor_lab.tscn`, `traversal_lint_test.gd`, `project.godot`.

- **M1. Threshold tylko w kodzie, zero instancji (P0).**
  `threshold_zone.gd:1-283` poprawny (interact-only, `aperture_rect`,
  0,32 s + DOOR 0,95 / VEHICLE 1,40 / HATCH 1,20 s). Grep
  `scenes/levels/*.tscn` = 0× `Threshold`. Wszędzie tylko `AirlockZone`
  x≈590–622 (np. `station_01.tscn:141` 615,238). Wymagany zapas ≥24 px
  od prawej krawędzi (oś ≤ ~584–592) — dziś animacja nie ma gdzie się
  odbyć. Poprawka: dodać węzeł `Threshold` do `station_01..18.tscn`
  z `aperture_rect` z tabeli §7.1; `AirlockZone` zostaje jako domknięcie
  (`pass` już jest); podpiąć `crossed → _trigger_level_completion` +
  `GapLedger.record_on_depart`.
- **M2. Wyjścia bramkowane `_unlock_exit` (P0).**
  `station_01.gd:64,376-382`, `14.gd:52,264-268`, `15.gd:57,305-309`,
  `18.gd:76`: `is_exit_unlocked=false` w `_ready()`, odblokowanie po
  komplecie; `threshold_zone.gd:175-176` dokleja warunek;
  `gap_ledger.gd:201-215` `ensure_exit_open()` woła logikę postępu
  zamiast ustawiać flagę. Wbrew PROGRESSION_FLOW §7 i D-192. Poprawka:
  `is_exit_unlocked=true` w `_ready()` (lub usunięcie flagi);
  `ThresholdZone.is_open=true` domyślnie dla drzwi liniowych.
- **M3. Powrót na `body_entered` (P1).** Strefy są
  (`05.tscn:92`, `14.tscn:144` itd.; 01 słusznie bez), ale
  `previous_level_requested` emitują handlery wejścia ciałem
  (`05.gd:187`, `06.gd:273`, `07.gd:194`), nie `crossed`. Niespójność
  przód/tył; brak `aperture_rect`/rodziny dla powrotu. Poprawka:
  `ReturnZone` jako drugi `ThresholdZone` z `target_station=poprzedni`.
- **M4. Anchor kradnie globalny `interact` (P0).**
  `station_14.gd:96-99` `_unhandled_input` → `_handle_anchor_toggle()`
  po samej odległości (`:156-163`); `threshold_zone.gd:93-100` też słucha
  `interact`. Kolejność `_unhandled_input` nieokreślona — E przy moście
  i progu może zakotwiczyć zamiast wejść. Brak promptu/rezerwacji.
  Poprawka: jawny `OpeningActionPoint`/prompt przy moście, priorytet
  MRP > Anchor > Threshold; gdy `Threshold.is_ready_for_entry()`,
  anchor nie konsumuje inputu.
- **M5. Budżet ≤3 przekroczony w 15 i 18 (P2).** 15: dziennik + 2×
  impuls + uzbrojenie + impuls z błędem + notatka = 5 kroków
  (`15.gd:209-296`); 18: prognozy + prawda + zatwierdzenie + donor = 4
  (`18.gd:148-278`); 14: nazwanie po obu zachowaniach przy
  `PULSE_INTERVAL=7.0 s` (`14.gd:28`) = ~14–21 s czekania. Trudność
  z czasu/łańcucha, nie ze zrozumienia (kanon §6: 3–4 podejścia po
  zrozumieniu). Poprawka: zwinąć do ≤3, skrócić łańcuchy.
- **M6. GapLedger dziurawy (P0).** `FEEDBACK_TO_GAP` (`:184-194`) zna
  9 mapowań na ~30 feedbacków; nie zna `no_element_in_reach` (14),
  `sender_not_armed / controls_incomplete / response_not_confirmed`
  (15), `marta_table_missing / commit_post_missing /
  consent_scope_required` (18) itd. `CATALOG` (`:92-144`) ma
  `station_flag=""` dla s09–s14 — `_is_satisfied()` (`:286-299`) spada
  na sam `close_fact`. Poprawka: uzupełnić mapowania mechanicznie +
  wypełnić flagi 09–14 albo udokumentować `close_fact`-only.
- **M7. Porażka = „nic + feedback” (P1).** `_on_airlock_body_entered():
  pass` wszędzie (słusznie jako closure), ale brak korekty §5.1
  (checkpoint przed próbą + świat zapamiętuje koszt). Jedyny `KillZone`
  to `anchor_lab.tscn:185` — nazwa zakazana §2.3, przepuszczana bo lint
  (`traversal_lint_test.gd:104-116`) skanuje tylko `scenes/levels/`.
  Poprawka: korekta w 14/15 (puszczony most gasi sekcję do następnego
  cyklu + linia L2 + zapis kosztu + zanik wizualny); bez `KillZone`
  w kampanii.
- **M8. Prototyp łamie kanon (P2).** `anchor_lab.tscn:127-137`
  `Chamber2Lift` 120 px pionu jako droga na harmonogramie + most jako
  droga — nie przechodzi testu §2.4 (czy robiłaby to samo bez gracza?).
  Kanon §2: brak wyjątku „tylko prototyp". Donor kampanijny (most 14:
  12 px) już poprawny. Poprawka: windę na wzywaną (R5), usunąć
  `KillZone` lub przenieść prototyp poza lint z adnotacją.
- **M9. Drabina: połowa kontraktu + `jump-off` (P1).**
  `ladder_zone.gd:43-46` podpina na `body_entered`; intencja dopiero
  w graczu (`prototype_player.gd:240-251`) — strefa kłamie. Gorzej:
  `:257-261` skok z drabiny omija D-123 (skrót między piętrami, zakaz
  §7.5). `ServiceLadder` tylko 02/15/16; brak audytu 30/32/37 (§6.1).
  Poprawka: przypięcie za intencją (interact / stop+góra), usunąć
  `jump-off` (zejście = dół / koniec), dopisać lint skali
  (pion ≤2 px, x ≤1 px, wystawanie 8–14 px).
- **M10. Trzy pytania bez rodzin (P2).** Nagłówki są, ale 01 i 18 nie
  wskazują R1–R7; 15 miesza R5/R7 z protokołem; 18 (`commitment`)
  to nie rodzina fizyczna. Kanon §6: max 1 rodzina / adres, cisza
  dozwolona. `18.gd:211-232` `select_operation()` auto-domyka donor,
  porównanie i prawdę — omija luki. Poprawka: oznaczyć 01/18 jako
  adresy bez przeszkody fizycznej; `select_operation` bez
  auto-domykania (brak → luka + ścieżka `unseeded` jak w 43).

Na plus: `MAX_CURB_STEP=18.0` + interpolacja 0,18–0,24 s po łuku
(`prototype_player.gd:23,658-688`) — DEF-5 naprawiony poprawnie;
semantyczny InputMap czysty (`project.godot:37-105`); 14 nazywa metodę
dopiero po obu zachowaniach; maszyna 01 pracuje sama
(`station_01.gd:71-104`, test infrastruktury zdany).

---

## 4. Audyt obrazu (11 findings V1–V11)

Źródła: `VISUAL_DESIGN.md`, `PIXEL_PRESENTATION_ARCHITECTURE.md`,
`LOCATION_FAMILY_BIBLE.md`, `CAST_AND_NPC_BIBLE.md`,
`PKG_0187_VISUAL_AUDIT.md`, `FRAME_LAYOUT_AUDIT.md`, `WORLD_SCALE.md`;
próbki `station_01/09.tscn`, `_draw()` 01 (22 KB) / 09 (14 KB),
`vector_stage_style.gd`, `world_pixel_compositor.gd`,
`cinematic_camera.gd`.

- **V1. Station 09 bez fartucha (P0).** `01.gd:466` woła
  `draw_stage_apron()`; `09.gd` — pusty grep. Przy offsecie dialogowym
  36 (`cinematic_camera.gd:36,211`) i `STAGE_APRON=40`
  (`vector_stage_style.gd:28`) dolne 36 px kadru dialogowego w 09 wyjdzie
  poza scenografię (defekt D-136). Poprawka: `_draw()` 09 + grep po
  wszystkich custom `_draw()` 01–18/42/43; retest
  `capture_preview.gd` + pomiar dolnych 40 wierszy (wzór PKG-0137).
- **V2. Paleta 09 to surowe hexy (P0).** `09.gd:229-310` ~15 literalnych
  `Color("…")` zamiast `VectorStageStyle.*` (01 używa `HUMAN_AMBER` /
  `ANCHOR_CYAN` / `CORRECTION_OXIDE`). Łamie §4 (8–16 + 2 akcenty) i §7.
  Dodatkowo `vector_stage_style.gd:19` `MAX_PALETTE_COLORS := 7` vs kanon
  8–16 — sprzeczka do rozstrzygnięcia decyzją. Poprawka: przepisać
  `_draw()` 09 (potem 08/10/13) na style + lint unikalnych kolorów.
- **V3. Jeden szkielet Geometry (P1).** 01 i 09: podłoga 640×64 (320,328),
  ściany 20×360 x=-10/650, sufit 640×30-36. Różnica wyłącznie w `_draw()`
  — wprost zakaz §11.1. PASS 0187 wisi na farbie, nie bryle. Poprawka:
  profile Geometry per rodzina (techniczna: podest/maszyna jako bryła;
  mieszkalna: węższy plan, niski strop wizualny); progi wyłącznie
  z `ThresholdZone.aperture_rect`.
- **V4. Sufit mieszkalnej na papierze (P1).** Kontrakt: prześwit 20–45 px,
  max 2 plany, drzwi 109 px. W 09: sufit dół y=78, głowa Leny ~y=209
  → prześwit ~131 px (3–6× za dużo). PASS 0187 zalicza „sufit w kadrze"
  — za słaby test. Poprawka: masa do y~160–180 bez collidera (limit
  `OVERHEAD_FLOOR=86` ostrożnie) + lint prześwitu w GATE-SCALE.
- **V5. Linie 1 px pod kompozytorem 2×2 (P1).** 09: `draw_line(...,1.0)`
  (ściany x=42/454, deski, półki). Przy 320×180 nearest
  (`world_pixel_compositor.gd:14-30`) to 0,5 px finalnego — łamie
  PIXEL_ARCH §5. Poprawka: min 2 px logical dla konstrukcyjnych albo
  scalenie w bryły; sprawdzić 08/10/13.
- **V6. Cienie w połowie trasy (P1).** 09 ma cień alpha 0.48 w prawo
  (lampa 230,156) — dobrze. 01 bez jawnego cienia pod bębnem/pulpitem.
  Rig to tylko cień kontaktowy; meble — cień w `_draw()` stacji.
  Poprawka: cienie 01 (i audyt 12/14) spójne z roboczym + zimnym
  wypełnieniem (rodzina 5).
- **V7. Vendor/neighbour niepełne (P1).** `lena/` ~18 klatek (bogato, OK);
  `marta/jakub/wierzbicka` 8 plików = pełne 7 stanów (CAST §4.2 OK);
  `vendor/` 4 pliki, `neighbour/` 5 (brak turn_away/seated/work).
  Fallback do idle ukryje, ale `npc_frame` 0187 będzie płaski tam gdzie
  niosą scenę. Poprawka: dogenerować pipeline'em CAST §6
  (`flux-kontext`, `remove-bg`, `process_cast_sprites.py` NEAREST
  64×104 pivot 32,96; zakazany LANCZOS `process_npc_sprites.py`).
  Portrety CRT dla nich nie wymagane (5 portretów obecnych).
- **V8. Drabina OK, lint niepotwierdzony (P1).** `LadderZone` tylko
  02/15/16 na trasie (30/32/37 legacy — nie ruszać). Zgodne. Ale
  WORLD_SCALE §7.4 (≤2 px pion / ≤1 px x) nie do dowiedzenia z `.tscn`
  bez odczytu `_draw()`. Poprawka: GATE-SCALE lint +
  `capture_pkg_0187.gd` threshold/mono dla 02/15/16; drabin nie doklejać.
- **V9. Tekst czysto, kamery nie (P2).** Dobrze: `draw_string` w
  `scripts/levels/*.gd` = 0; obie próbki mają kompozytor + `CRTDialogueBox`
  + `InnerThoughtSurface` jako rodzeństwo; `CrispDiegeticText` w pasie
  90–190 poza aktorem. Źle: równolegle `cinematic_camera.gd` i
  `station_camera_rig.gd`, `VectorStageEnvironment visible=false` przy
  custom `_draw()` — martwy kod w każdej scenie (ryzyko rozjazdu
  offsetu/budżetu `get_framing_budget()`). Poprawka: inwentaryzacja
  kamer (jedna prawda D-133/D-136), `visible=false` → wyciąć lub
  `tools/retired/`.
- **V10. Róż Marty vs limit akcentów (P1).** CAST §2.2 rozstrzyga słownie
  (róż = zgaszona czerwień, 2 odcienie, 1 slot, nigdzie indziej).
  `marta.png` osobno (D-187 przestrzegany). Brak egzekucji w `_draw()`:
  nic nie zdejmuje bursztynu/turkusu gdy wchodzi róż; przy MAX=7 trzy
  akcenty rozsadzą budżet po cichu. Poprawka: decyzja + reguła (Marta
  w kadrze → 1 akcent → `shade(MID_PLANE)`), weryfikacja w mono.
- **V11. Capture-archiwum (P2).** `tools/capture_*.gd` ~60 plików, w tym
  `capture_act1/act2_vector_stage` dla wygasłej formy 43 adresów.
  Obowiązują: `capture_preview.gd` + `capture_pkg_0187.gd`
  (mono/threshold/npc_frame) + `capture_pkg_0190.gd`. Poprawka: legacy
  → `tools/retired/`, 1 akapit w `INDEX.md` co jest prawdą.

Najtańsza kolejność wizualna: V1+V2+V5 (jeden przepis `_draw()` 09) →
V6+V4 (światło+sufit) → V7 (rigi) → V3 (profile Geometry) → winiety.

---

## 5. Audyt audio (5 findings A1–A5)

Źródła: `PKG_0211_PROCEDURAL_AUDIO_CENSUS.md`,
`procedural_audio.gd` (4647 l., 256× `create_`, 6 param., 9 helperów,
total 265 staticów), `atmosphere_rig.gd`, `crt_dialogue_box.gd:211`,
`PKG_0206 §audio`, `pkg_0211_test.gd:122-135`.

- **A1. Ambient bez pętli (P1, słyszalne).** 7 generatorów PKG-0180
  (`:4542` viaduct, `:4557` perimeter, `:4572` substation, `:4588` vault,
  `:4603` analyzer, `:4618` ledger, `:4633` dawn river) idzie przez
  `generate_wav` z obwiednią `sin(progress*PI)` — cisza na końcach
  2,1–2,6 s. Odtwarzanie `atmosphere_rig.gd:371-378`
  `finished.connect(play)` — retrigger co ~2 s ze szczeliną/klikiem.
  Jedyna poprawna pętla to `generate_looping_wav` (`:4418-4424`,
  LOOP_FORWARD) użyta 2× (`:4444` sustain 1,20 s, `:4486` drag 0,80 s).
  Kontrakt PCM trzyma; ciągłość nie. Poprawka: 7 ambientów na
  `generate_looping_wav` z całkowitą liczbą okresów (wzór z komentarza
  `:4444-4453`) albo crossfade 50–100 ms; double-buffer w rigu zamiast
  `finished→play`.
- **A2. Ducking wąski (P1).** `DUCK_ATTENUATION_DB=7.0` (`:40`),
  bazy -24/-28 dB, lerp 6.0 (`:165-175`) tylko dla humu i sub-struktury.
  `_unease_player` (`:392-397`, -22 dB, 3840 Hz z `:4001`) nie duckowany.
  Trigger: `CRTDialogueBox.is_presenting` + `InnerThoughtSurface.visible`
  + flaga. Wszystko na `Master` (`:375,386,396`), bez busów/kompresora.
  Poprawka: duck dla unease, busy `Ambient/Dialogue`, kompresor
  z sidechainem; 7 dB jako default.
- **A3. Pozycjonowanie (P2).** Kontrakt mono TRZYMA (`:9` 44100,
  `:70-88` 16-bit/mono/parzysty, test `:122-135`), ale komentarz „pozycję
  daje AudioStreamPlayer2D" vs runtime: `atmosphere_rig.gd:371,382,392`
  stawia zwykłe `AudioStreamPlayer`. Poprawka: albo 2D z pozycją, albo
  poprawka komentarza (ambient celowo niepozycjonowany).
- **A4. Cache/drain trzyma, z duplikacją (P2).** `get_cached`
  (równość referencyjna `:14-19`), `clear` (`:22-23`), `size` (`:66-67`),
  `drain` rekurencyjny (`:26-63`), wołane w `game_state_manager.gd:
  1406-1407,1355,1373-1374` (+150 ms headless, Godot #76745) i
  `verify.ps1:33-41` (WASAPI-forced). Problemy: `atmosphere_rig.gd:58-71`
  powiela drain ręcznie (dryf); brak capa/LRU; pierwszy fetch syntetyzuje
  do 114 k próbek z sin/cos per-sample — hitch przy wejściu. Poprawka:
  wołać `ProceduralAudio.drain_playback(self)`; warmup w cold open B
  (pre-cache 7 ambientów + blipów).
- **A5. Rodziny audio bez bramki (P2).** Wizualne GATE-FAM ma ≥3/5 osi na
  mono; audio ma 5 osi (f0, obwiednia, czas, noise, AM) bez pinu.
  Dispatcher (`:4199-4212`, LENA/MARTA/JAKUB/WIERZBICKA/SZYMON/else,
  z `crt_dialogue_box.gd:211`): Lena 587 Hz (`:444-452`), Marta 440 Hz
  (`:681-692`), Jakub 370 Hz+grit (`:925-938`), elderly 480 Hz+tremor
  (`:998-1010`) — wszystko krótkie sine 0,05–0,08 s; blisko siebie;
  `else→system_blip` myli UNKNOWN z systemem. Poprawka: test dystansu
  (f0/centroid/czas/noise) + rozdział UNKNOWN vs SYSTEM.

---

## 6. Audyt techniczny (5 findings T1–T5)

Źródła: `TECHNICAL_DIRECTION.md`, `project.godot`, `game_state_manager.gd`
(1919 l.), `verify.ps1` (107 wywołań), `tests/` (105 plików),
`ACCEPTANCE_MATRIX.md §4.8`, `DECISION_LOG.md` D-220..D-226.

- **T1. TECHNICAL PASS ≠ PRODUCT GO (P0).** Reguła twarda
  (`MATRIX:21-26`); GATE-REL wymaga exit 0 + 14×PASS (`:199-207`);
  `:344` BLOCKED; CHECKPOINT-06 GO ale PRODUCT GO CANDIDATE (`:352-353`).
  Cytowanie zielonego verify jako dowodu zrozumienia/zabawy łamie §6
  i R-039. Release/`.exe` BLOCKED do dyspozycji. Bez zmiany.
- **T2. Routing trzyma, default kruchy (P1).** `game_state_manager.gd:
  571-585` next (18→finale, 41→finale, finales→43), `:588-605` prev,
  `:613-673` complete (18→42a jeśli pusto), `:526-537` selector
  (stations[18] = wybrane finale), `:1903-1910` known/can_enter.
  SELECTOR 20 bez 42b/42c i legacy (D-223, słusznie). Ryzyko: deep-link
  42b/c przed wyborem → warning `:1385-1387`; stan 18 bez
  `method_committed` → cicho 42a (`:618-622`). Poprawka: jawny stan
  `finale_unselected` + tooltip w pauzie zamiast cichego 42a.
- **T3. Pin 107/106/105 poprawny, konwencja łamliwa (P1).**
  `pkg_0207:159-160` liczy `Invoke-GodotGate \`` (z backtickiem) żeby
  odciąć definicję `verify.ps1:24`. Surowy grep daje 108 — nowicjusz
  uzna pin za zły. Rejestr D-222→D-226 działa, zero sierot. Poprawka:
  1-linijkowa dopiska w nagłówku `verify.ps1` (definicja nie jest
  wywołaniem; test mówi to w `:157-158`).
- **T4. Reentrancja wdrożona, bez linta (P1).** Pola + guard
  `if _x==value: return` w `anchorable_object.gd:28-63`,
  `movable_anchorable_prop.gd:42-78`, `opening_action_point.gd:15-32`,
  `memory_resonance_point.gd:246-253`, `vibration_trace_display.gd:50-71`;
  `prototype_player.gd:87` grupa player + `threshold_zone.gd` bez
  get_parent (D-224). Luka: GDScript pozwala pisać do pola z pominięciem
  settera. Poprawka: lint „`_is_anchored\s*=` poza własnym plikiem →
  FAIL" (wzór traversal_lint).
- **T5. Warstwy rozproszone (P2).** `project.godot:114-117` tylko nazwy;
  w kodzie: `threshold 0/1`, `ladder 0/1`, `return 1/1`, `opening 0/1`,
  `exit_clearance` zeruje. D-224 mówi „player layer 3 / mask 1" ale żaden
  test nie pinuje tabeli 4×4. Save schema v1 (`:21,25`) mimo erasure
  D-208/D-211 — słusznie (migracja kluczami `p7.*.migration_revision`
  `:1479-1517`); stary save bez revision przechodzi erasure, fakty P9
  wyjęto z list celowo. Poprawka: centralna `PHYSICS_LAYERS` + test 4×4.

---

## 7. Nowe kreatywne pomysły (wybór skonsolidowany, każdy z uzasadnieniem)

Bez nowych adresów / rodzin / faktów / postaci poza jawnie oznaczonymi.
Każdy mieści się w czasownikach (`interact`, `trigger_correction`, ruch,
sprint-modyfikator) i kanonie przeszkód (zakaz arcade bezwzględny).

### Narracyjne (N)

- **K1. Kurtka-kosztomierz.** Ubytek 16 (kurtka na kaloryferze) wraca
  dotykiem w 42: 42A domowa Marta odwraca kurtkę bez słowa; 42B puste
  miejsce; 42C obie pachną cudzym mydłem. Materializuje cenę pamięci,
  reużywa warm-obiektu z 10, zero assetów.
- **K2. Kubek-przeciek.** Biały kubek z 10 osią 42C (domowa Marta sięga
  po nieistniejący); w 18 Marta odstawia/myje inaczej per `truth_state`
  (full oba, partial chowa jeden, withheld odwraca). Wybaczenie bez tezy.
- **K3. Hełm z garnka.** Konkret Jakuba (`gd:24`) wraca w 37/42C przy
  prosektorium + powrót do napędu. Humor jako sprawczość, nie ofiara.
- **K4. Margines miejscowej Leny.** Dopisek ołówkiem na wydruku 15:
  `przepraszam M. — 3 s`. Proceduralny ślad winy, bez monologu-ducha.
- **K5. Blizna ciałem.** Jakub nigdy nie pokazuje (granica 12); w 42B/C
  poprawia koszulę / zasłania bok przy prosektorium — 1 beat ciała.
- **K6. Ulica 18 = 05 po zmianie.** Ten sam szyld `UCP / PRACE NOCNE`
  z odpryskiem, cykl świateł o 1 klatkę spóźniony. Rym wizualny zamiast
  etykiety.
- **K7. Palimpsest `Tak/Jadę`.** Ekran 42B: `Jadę` nad częściowo startym
  `Tak`. Naprawia sprzeczność N6 bez retconu; wizualny dowód utraty
  adresu.

### Mechaniczne (M, wszystkie R1–R7 + Threshold)

- **K8. Klamka z pamięcią (R2).** Drzwi pamiętają odcisk; Lena pożycza
  profil albo wchodzi jako miejscowa. Porażka = wersja B korytarza.
  1 interakcja, czytelne przed próbą.
- **K9. Wózek-podpora (R4+R5).** Drzwi archiwum zamyka cykl wentylacji;
  Lena podstawia wózek (`MovableAnchorableProp`, istnieje) pod skrzydło.
  Maszyna pracuje bez niej; ona czyta przerwy. Korekta, nie śmierć.
- **K10. Dwa numery (R1).** Tabliczki 12/12A na tych samych drzwiach;
  kotwiczysz wariant sąsiadki. Bez timera/skoku; nazwanie po obu.
- **K11. Sznur-linia wzroku (R6, Akt III/IV).** Plama „poprawia się"
  poza spojrzeniem; idziesz tyłem / przystajesz. Porażka = luka
  w protokole (`nie dopilnowałam zapisu`), wracasz z latarką.
- **K12. Wsiadanie na postoju (R5+VEHICLE).** Wagon stoi, drzwi otwarte,
  stopień 9 px. Odjazd bez ciebie = rozkład (czekasz, słyszysz miasto),
  nie fail. Gotowe `board_vehicle_0..1` + 1,4 s.
- **K13. Przytrzymaj dla drugiej (R3, raz na kampanię).** Sąsiadka z wózkiem
  na nakładających się schodach (wzorzec Sceny 12); trzymasz most/drzwi,
  ona schodzi. Porażka dotyka jej (wstyd/powrót), nie ciebie.
- **K14. Przynieś drabinę (R7).** Właz 56–70 px bez drabiny; stoi 2 kadry
  dalej — przynosisz (ciężar/wysiłek), opierasz (kotwiczysz), wchodzisz.
  Drabina wyłącznie z `LadderZone`, mocowanie co 42 px istnieje.
  Eliminuje pokusę „podskoczę".
- **K15. Spis-bramka (R2+luka).** Kołowrót czyta profil; bez kompletu
  przechodzisz dalej (PROGRESSION §1) ale zapisuje lukę; odmawia później
  1 czynności z nazwą miejsca. Głos L1/L2/L3 z gotowego
  `NarrativeGuidanceService`.

### Wizualne (V, bez colliderów, bez zmiany skali w ruchu)

- **K16. Ciepłe kałuże (09/10/13).** Dwa niskie stożki alpha 0,10–0,14
  z jawnym źródłem-obiektem i wspólnym kierunkiem cienia. Mieszkalną od
  instytucjonalnej odróżnia światło, nie napis.
- **K17. Latarnia-drugi aktor (05/18).** Punkt 200–230 px + długi cień
  Leny przez chodnik. Cel czytelny przed promptem.
- **K18. Maszyna-oddech (01/12/14).** 2-klatkowy cykl przed próbą (R5) +
  światło robocze tylko w rytmie cyklu, nie stale jak quest-marker.
- **K19. Próg-światło VIG-01 (08).** Szczelina drzwi 14 jako jedyny pion
  + kurz w snopie na siatce 2×2. Zamek pokazany przed tekstem.
- **K20. Sygnał-1px VIG-03 (15).** Korekta impulsu jako przesunięcie
  o 1 finalny piksel na czytniku, nie glitch. Jedna niezgodność
  wskazywalna w mono.
- **K21. Mikro-niepokój ciał.** Oddech 1 px/2,6 s + `unease_reaction` +
  `gesture` NPC raz na beat guidance, nie w loopie.
- **K22. Świt bez symboliki (42A/B/C).** Ta sama armatura, inna
  temperatura/długość cienia + 1 fakt osobowy. Zero moralnego koloru.
- **K23. Góra kadru w cichych.** Półka/karnisz/kanał jako masa do y=86
  (gramatyka FRAME_LAYOUT §4.2 w mieszkalnej). Wypełnia 129 px przy
  zamkniętym panelu, 93 px przy dialogu -36 px.

### Dźwiękowe i techniczne (A/T)

- **K24. Miks na busach + nocny tryb.** Busy Master/Ambient/Dialogue/
  Haptic, kompresor sidechain Dialogue→Ambient zamiast -7 dB ręcznie;
  slider `Dialogi +6 dB` + caption każdego blipa (dostępność: gra nie
  zależy wyłącznie od dźwięku).
- **K25. Ambient-gapless.** 7 ambientów na wzór pętli całkowito-okresowej
  (jak sustain/drag) — koniec retriggera, mniej CPU.
- **K26. Raport 5 osi audio.** Dev-skrypt (nie bramka) liczący f0-centroid/
  czas/-60 dB/crest/noise/AM dla każdego `create_*` — łapie kolizje
  (Marta 440 vs elderly 480) przed człowiekiem.
- **K27. Warmup w cold open B.** Pasek rejestratora pre-cache'uje ambient
  następnej stacji w tle; gracz widzi kalibrację, silnik chowa hitch.
- **K28. Dev-Audio-Browser.** Scena tylko `test_mode`: lista 256 dźwięków
  + play/loop/hash — koniec szukania „który `create_` to ten brzęk".
- **K29. GapLedger dźwiękowy.** `open_gap` = cichy motif 330 Hz 0,2 s;
  zamknięcie = 740 Hz. Gracz słyszy niedomknięcie bez dziennika zadań;
  wzmacnia GATE-FLOW bez tekstu.
- **K30. Chunked-synth / krótsze loopy.** `generate_wav` per-sample → lazy
  lub krótsze loopowalne 1,2 s; pomiar w `frame_budget_audit.gd`.

---

## 8. Szczegółowy plan wdrożenia (pakiety PKG-0214+)

Zasady cięcia: pionowo, jeden pakiet = jeden wynik + zielono; shared-touch
(`memory_resonance_point.gd`, `mrp_legacy_renderer.gd`,
`game_state_manager.gd`, `procedural_audio.gd`,
`world_pixel_compositor.gd`, autoloady) → zawsze pełna `verify.ps1`;
docs-only / scena-lokalna → zakresowa D-217 dozwolona (limit: pełna
najpóźniej co 5 pakietów; ostatnia pełna PKG-0210, zakresowe 0211/0212,
licznik: 3. zakresowa dozwolona w 0213, pełna najpóźniej w PKG-0215).

Każdy pakiet: bramka mierzalna (nigdy „ładniej"), kadry przed/po normalnym
sterownikiem dla ruszonych adresów (nie nadpisywać `0187…0203`), inspekcja
ręczna z tekstem i bez + skale 85/100/115%, aktualizacja pinów 0206/0207/
0208 gdy rosną liczby (wzór D-216/D-218/D-224/D-225/D-226, nigdy po cichu),
wpis SESSION_LOG + CURRENT_STATE + NEXT_PROMPT + INDEX + decyzja/ryzyko,
snapshot. Rewizje D-220..D-226 tylko nowym pakietem z bramką.

### Faza R0 — domknięcie PKG-0213 (ten pakiet, zakresowa)

- Pliki: ten plan (nowy), brak zmian kodu. Bramki: `verify_docs` PASS
  + `verify_scoped` PASS. Handoff + snapshot PKG-0213.

### Faza R1 — odbramkowanie i wejście (P0 mechaniczne, 2 pakiety)

- **PKG-0214 — Threshold w scenach + odbramkowanie wyjść (M1+M2).**
  Węzeł `Threshold` w `station_01..18.tscn` (apertury §7.1, x≤~580),
  `is_exit_unlocked=true` w `_ready()`, `is_open=true` domyślnie,
  `ensure_exit_open` jako setter, `crossed → _trigger_level_completion`
  + `record_on_depart`. Bramka: 20/20 `Threshold` w `.tscn` +
  minimalny przebieg (zero odczytów → 43, brak softlocka) + lint
  `body_entered`-progresji = 0. Blast: sceny+stacje (liczne, ale
  lokalne) → pełna `verify.ps1` dla bezpieczeństwa. Kadry: progi
  01/08/15/18 przed/po.
- **PKG-0215 — GapLedger 1:1 + konflikt `interact` (M6+M4).**
  Uzupełnienie `FEEDBACK_TO_GAP` o wszystkie `_record_feedback`,
  flagi 09–14, priorytet MRP > Anchor > Threshold + prompt przy moście.
  Bramka: audyt luk 100% feedbacków ma gapę; E przy moście i progu nie
  kradnie wejścia (test wejścia ×10). Pełna `verify.ps1` (limit D-217
  i tak wymaga pełnej ≤0215).

### Faza R2 — bramka wiedzy i słownik (P0 narracyjne, 1–2 pakiety)

- **PKG-0216 — D-211 domknięte + słownik + `Tak/Jadę` (N1+N3+N6-część).**
  Lint treści prezentowanej (zakres na `creative_scene_lines.gd`),
  `Utrzymanie → Zakotwiczenie` w `gd:31` + `FULL_STORY`, palimpsest
  `Tak/Jadę` w 42B (K7). Bramka: lint łapie wstrzyknięty termin
  w liniach (fail-closed dowód); grep `Utrzymanie` = 0 w kontekście
  metody; oba napisy widoczne w 42B. Zakresowa dozwolona (linie+test,
  bez shared-touch; linie to dana, ale dotykają logiki prezentacji —
  przy shared-touch pełna).
- **PKG-0217 (opcjonalnie łączony z 0216) — synteza 13 + prognozy
  (N2+N5).** Trzeci głos Jakuba, `brak danych` w prognozach,
  dyferencjacja urządzeń. Bramka: synteza wymaga 3 rodzin; prognoza
  `granted` pokazuje czerwone pola. Kadry 13/18.

### Faza R3 — obraz krytyczny (P0 wizualne, 1–2 pakiety)

- **PKG-0218 — Fartuch + paleta + linie 09 (V1+V2+V5).** Przepis
  `_draw()` 09 na `VectorStageStyle`, `MAX_PALETTE_COLORS` decyzją
  (7 vs 8–16), linie ≥2 px, fartuch. Bramka: pomiar dolnych 40 wierszy
  w dialogu (jak PKG-0137) + lint unikalnych kolorów ≤16 + brak linii
  1 px w konstrukcyjnych. Kadry 09 pełny/bez-tekstu/mono przed/po +
  skale 85/115. Zakresowa (scena lokalna).
- **PKG-0219 — Światło+sufit+cienie (V4+V6, +V10 decyzja).** Masa
  mieszkalna, cienie 01, reguła różu (decyzja). Bramka: prześwit
  w widełkach (lint), 1 źródło robocze + wypełnienie w 01, mono 09 vs
  01/11/12/15 na ≥3 osiach. Kadry.

### Faza R4 — dźwięk P1 (1 pakiet)

- **PKG-0220 — Pętle ambientu + duck (A1+A2, +A3/A4).** 7 ambientów na
  `generate_looping_wav`, double-buffer, duck unease, drain przez helper,
  komentarz 2D. Bramka: brak szczeliny (analiza obwiedni / test
  `loop_end>0` + odsłuch), duck wszystkich 3 playerów, cache/drain
  idempotentny. Shared-touch (`procedural_audio.gd`) → pełna verify.
  Kreatywne K24/K25/K29 można dołączyć tu lub jako 0220b.

### Faza R5 — kanon fizyczny (P1 mechaniczne, 1–2 pakiety)

- **PKG-0221 — Drabina + Return + skale (M9+M3+M1-część).** Intencja
  w strefie, koniec `jump-off`, lint 2/1/8–14 px, Return jako Threshold,
  apertury do tabeli (wzór 10: 52×108). Bramka: GATE-SCALE 0 naruszeń +
  wejście tylko intencją (10 prób biegu na drabinę = 0 przypięć) +
  zjazd tylko dołem. Kadry 02/15/16. Pełna lub zakresowa wg blastu
  (lint+strefy lokalne → zakresowa dozwolona).
- **PKG-0222 — Korekta z kosztem + budżety (M7+M5+M10).** Korekta §5.1
  w 14/15, zwinięcie 15/18 do ≤3, `select_operation` bez auto-domykania,
  oznaczenie 01/18 bez przeszkody. Bramka: puszczony most = stan kosztu
  + linia L2 + zapis; 15/18 ≤3 interakcje (M4); brak auto-domykania
  (test luki). Kadry.

### Faza R6 — głosy i tempo (P1/P2 narracyjne, 1 pakiet)

- **PKG-0223 — Wierzbicka + urządzenia + 09/17 + polszczyzna
  (N4+N7+N9+N10, +N8 margines K4).** Przepisanie kwestii, rozbicie
  `loop_logbook`, konkret zamiast mantry, 5 poprawek językowych.
  Bramka: głosy rozróżnialne bez etykiet (audytor ślepy na etykiety,
  test listy), `loop_logbook` ≤2 linie + pokaz w obrazie. Kadry
  dialogowe 15/17/18.

### Faza R7 — obsada i geometria (P1 wizualne, 1 pakiet)

- **PKG-0224 — Rigi vendor/neighbour + profile Geometry (V7+V3).**
  Brakujące stany pipeline'em CAST, profile per rodzina, progi tylko
  z apertur. Bramka: 100% postaci 84–92 px + 7 stanów lub jawny wyjątek;
  podłogi/ściany nieidentyczne między rodzinami (M4). Kadry 06/08.

### Faza R8 — winiety i finały (P2, 1–2 pakiety)

- **PKG-0225 — VIG-01..04 + FINALE + K1–K7 (V-pakiet + N-finały).**
  Implementacja wg `PKG_0190_PLACEMENT` (08/13/15/18/42), sygnał
  1-px (K20), kurtka/kubek/blizna/margines (K1–K5), ulica-rym (K6).
  Bez duplikacji cold openu, bez winiety dla mechaniki 14, skip jednym
  wejściem, reduced-motion cięciami. Bramka: triggery + skip + brak
  podpisów (D-214) + stany 42/43 z `FULL_STORY:704-709`. Kadry winiet.
- **PKG-0226 (opcjonalny) — truth-payoff + stół 6 rzeczy (N6-reszta).**
  Zróżnicowanie `household_*` po `truth_state`, stół 6 rzeczy w 18.
  Bramka: 3× `truth_state` × 3× finał = 9 różnych otwarć (hash/linie).

### Faza R9 — higiena i narzędzia (P1/P2 tech, 1 pakiet)

- **PKG-0227 — Linty + kamery + capture + audio-dev (T3+T4+T5+V9+V11+
  A5+K26/K28).** Dopiska backtick w `verify.ps1`, lint reentrancji,
  pin 4×4, inwentaryzacja kamer, `tools/retired/`, raport 5 osi audio,
  Audio-Browser (tylko test_mode). Bramka: pin 4×4 GREEN + linty
  fail-closed + zero `draw_string` + lista capture-prawdy w INDEX.
  Zakresowa (narzędzia+testy).

### Faza R10 — recertyfikacja

- **PKG-0228 — Pełna recertyfikacja jak 0209/0210.** Zero zmian treści;
  pełna `verify.ps1` PASS (cel: 115+ sekcji), `verify_docs` PASS,
  smoke 01–43, raport luk, kadry kontrolne. Dopiero po niej wolno
  mówić o readiness; nadal nie PRODUCT GO bez właściciela.

Kolejność jest zależnościowa (wejście → wiedza → obraz → dźwięk →
fizyka → głosy → obsada → winiety → higiena → certyfikacja), nie
ważnościowa — właściciel może przestawić 1 decyzją bez zmiany zakresów
(wzór PHASE-08). Pakiety K8–K15 (mechaniczne) wchodzą jako warianty
PKG-0221/0222 tylko na jawne zlecenie (każdy to 1 adres i 1 rodzina);
domyślnie plan nie dodaje przeszkód. Pakiety K24–K30 wchodzą do 0220
lub 0227.

---

## 9. Co NIE wchodzi bez osobnej dyspozycji (granice)

- Nowe adresy, rodziny, interakcje (4.+), fakty, postaci, sceny.
- Ekstrakcja tabel MRP krok 2 (logika; shared-touch; pełna verify).
- Rewizje D-220 (prop_type 18), D-221 (liczby 182/183/6), D-222 (pin
  107/106/105), D-223 (selector/defaulty), D-224 (Aurelius), D-225
  (PCM/cache), D-226 (45↔45) — tylko nowym pakietem z bramką.
- Przebudowa monolitów poza zakresem, zmiany enum / serialize IDs /
  routingu / progów / InputMap.
- Przywracanie podpisów winiet i tez autorskich (D-214/D-219).
- Tłumaczenie wady etykietą/promptem; zaliczanie tekstem; release/`.exe`.
- Tryb `headless` do kadrów (wiesza `frame_post_draw`; tylko normalny
  sterownik, wzór `capture_pkg_0203.gd`, Intel Iris Xe, OpenGL).
- Pułapki narzędziowe z handoffu: tablica `@(...)` przez `pwsh -File`
  nie wiąże (wołać `&` z pliku); `Array[StringName]` szuka `]` za
  `= [`; `var x := variant+float` nie kompiluje (jawne typy); brak
  globalnego `chr()` (literały); CRLF fasady MRP (normalizacja
  `\r\n→\n`); `CrispDiegeticText` gasi warstwę wprost (CanvasLayer 10
  nie dziedziczy `visible`); siatka 37 mija ~1% tekstu (pin krokiem 13);
  kadry łapią maszynę do pisania CRT i żywą maszynerię (wnioski oczne,
  nie pikselowe).

---

## 10. Akceptacja planu (ten pakiet)

- [x] Audyt 4 torów wykonany na plikach (36 findings: N1–N10, M1–M10,
  V1–V11, A1–A5, T1–T5) + 30 pomysłów K1–K30 z uzasadnieniem i mapą
  plików.
- [x] Plan faz R0–R10 (PKG-0214..0228) z bramkami mierzalnymi, blast
  radius i strategią verify (D-217).
- [x] `verify_docs.ps1` PASS (52) jako baseline; `verify_scoped.ps1`
  PASS po zapisie planu (docs-only, mały blast).
- [x] Handoff: SESSION_LOG PKG-0213, CURRENT_STATE PKG-0213,
  NEXT_SESSION_PROMPT PKG-0214, INDEX, snapshot PKG-0213.
- [ ] Dowód zabawy/emocji/zrozumienia: OPEN-NO-EVIDENCE (D-012, ADR-003).
  Plan dowodzi kontraktów, nie odbioru.

---

## 11. Ryzyka i hipotezy (dopisane do rejestru)

- R-xxx: Threshold w scenach to największy blast od cutoveru 0171;
  ryzyko rozjazdu apertur z colliderami — mityguje lint 2 px + kadry
  przed/po + pełna verify w 0214.
- R-xxx: lint treści vs linie — ryzyko gonitwy (autor omija lintem
  nowy plik); mityguje test treści prezentowanej, nie ścieżki pliku.
- R-xxx: paleta 7 vs 8–16 — ryzyko cichego dryfu; mityguje 1 decyzja
  + lint kolorów.
- R-xxx: pętle ambientu — ryzyko zmiany brzmienia; mityguje zachowanie
  f0/obwiedni, zmiana tylko ciągłości + odsłuch A/B.
- H-xxx: „ulica-rym 05/18" i „kurtka-kosztomierz" niosą finał bez słów —
  hipoteza, nie fakt; weryfikacja wyłącznie strukturą (obecność nośnika),
  nie odbiorem.
- H-xxx: „sygnał-1px" czytelny w mono — hipoteza; test mono ją sprawdzi
  strukturalnie, nie percepcyjnie.

---

## 12. Mapa plików do poprawek (skrót operacyjny)

Narracja: `scripts/levels/creative_scene_lines.gd:8-13,15-27,31,35,
39,50,57-66,71-89,127-128`; `station_17.gd` + `pkg_0165_*`;
`FULL_STORY.md:11-23,475-476,599-600,671-672`;
`DIALOGUE_SCRIPT.md:39-41,85-106,168-174,351-355`;
`NARRATIVE_BIBLE.md:237-256,379`; `TRACKER.md:34,140,199,208-269`.

Mechaniki: `scenes/levels/station_01..18.tscn` (dodać Threshold);
`scripts/levels/station_*.gd` (`_unlock_exit`, handlery powrotu,
`_unhandled_input` 14); `scripts/environment/threshold_zone.gd:
18,29,42-43,64-100,113-176`; `ladder_zone.gd:19-20,43-76`;
`return_zone.gd:19-20`; `opening_action_point.gd:48-49`;
`exit_clearance.gd:15-16`; `scripts/campaign/gap_ledger.gd:
92-215,286-299`; `station_18.gd:76,148-278,211-232`;
`prototype_player.gd:23,87,214-261,640-688`;
`anchorable_object.gd:410-413`; `scenes/prototype/anchor_lab.tscn:
115-185`.

Obraz: `scripts/levels/station_09.gd:220-310` (+08/10/13);
`station_01.gd:71-104,466`; `scripts/visual/vector_stage_style.gd:19,28`;
`world_pixel_compositor.gd:14-30`; `scripts/camera/cinematic_camera.gd:
36,211`; `scenes/levels/station_01.tscn` + `station_09.tscn`;
`assets/characters/vendor/` + `neighbour/`; `scripts/camera/*`;
`tools/capture_*.gd` + `capture_preview.gd` + `capture_pkg_0187.gd`.

Audio: `scripts/audio/procedural_audio.gd:9,14-67,70-88,444-1010,
4199-4212,4418-453,4541-4647`; `scripts/levels/atmosphere_rig.gd:
38-71,151-175,369-397`; `crt_dialogue_box.gd:211`.

Technika: `scripts/core/game_state_manager.gd:21,25,242-263,526-585,
588-673,1355,1373-1407,1479-1517,1903-1910`;
`tools/verify.ps1:24,33-41`; `tests/pkg_0207_gate_census_test.gd:
41-44,157-189`; `project.godot:28-117`; pliki `anchorable_object.gd`,
`movable_anchorable_prop.gd`, `opening_action_point.gd`,
`memory_resonance_point.gd:246-253`, `vibration_trace_display.gd:50-71`.

---

*Koniec planu PKG-0213. Następny pakiet: PKG-0214 (Threshold + odbramkowanie)
wg §8 — po decyzji właściciela o kolejności. Bez tej decyzji wolno wykonać
wyłącznie recertyfikację (ścieżka D).*
