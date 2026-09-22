# PKG-0227 — Higiena i narzedzia (faza R9 z planu PKG-0213 S8)

Data: 2026-09-13. Dyspozycja: `docs/NEXT_SESSION_PROMPT.md` po PKG-0226
(faza R9: T3+T4+T5+V9+V11+A5+K26/K28). Decyzja D-240. Nie jest PRODUCT GO.
GATE-REL, release i nowe `.exe` pozostaja BLOCKED BY D-168.

## Co zmieniono (narzedzia + testy + pin + raporty — zero monolitow)

1. T3: dopiska o backticku w `tools/verify.ps1` (definicja wywolania nie
   jest wywolaniem; pin liczy linie z kontynuacja; surowy grep daje +1
   przez definicje — nowicjusz ma to na tacy w naglowku). Komentarz celowo
   nie zawiera liczonego wzorca, pin 0207 stoi.
2. T4: lint reentrancji setterow, fail-closed, wzor traversal_lint.
   Nowa bramka `tests/pkg_0227_hygiene_tools_pin_test.gd` pinuje straznikow
   (`if _x == value: return` / clamped) w 5 plikach z D-224
   (anchorable_object, movable_anchorable_prop, opening_action_point,
   memory_resonance_point, vibration_trace_display) oraz skanuje cale
   `scripts/` na zapis `_pole = ...` poza plikiem-wlascicielem.
   Baseline: zero naruszen (wszystkie zapisy `_is_anchored`,
   `_is_player_in_range`, `_is_available`, `_is_resolved`,
   `_pass_progress`, `_interference_factor` zyja wylacznie u wlascicieli;
   zapis `is_activated` idzie jawnym setterem, nie polem — dozwolony).
   Dowod fail-closed: bramka na wstrzyknietym tekscie lapie
   `node._is_anchored = true`, a przepuszcza `==` i `!=` (pierwszy
   FAIL sesji padl na brakujace wpisy INDEX — lint dziala, nie milczy).
3. T5: centralny pin warstw fizyki `scripts/environment/physics_layers.gd`
   (nowy): numery WORLD/PLAYER/TRIGGERS/INTERACTABLES 1/2/3/4 z project.godot
   + bity + tabela stref THRESHOLD/LADDER/RETURN/OPENING (0/1, 0/1, 1/1,
   0/1). 4 strefy przepiete z literalow na consty pinu (threshold_zone,
   ladder_zone, return_zone, opening_action_point) — wartosci identyczne,
   zero zmiany zachowania. Bramka pinuje 4x4: 4 nazwy warstw + 4 consty
   + 4 referencje w zrodlach + 8 runtime layer/mask po _ready.
   `exit_clearance` zeruje warstwy cial celowo (inny mechanizm) — poza
   pinem, jawnie. Gracz layer 3 pinuje osobno `pkg_0210` (nietkniety).
4. V9: inwentarz kamer. Prawda jest jedna: `CinematicCamera`
   (D-133 offset dialogowy 36 + D-136 budzet kadrowania + D-120/D-148)
   podpinana wylacznie przez `StationCameraRig` (NODE_NAME "Camera",
   D-150). W `scripts/camera/` dokladnie 2 skrypty, jedno
   `extends Camera2D` w calym `scripts/`. Zero `draw_string` w
   `scripts/levels/*.gd` (jedyny trafiony `draw_string` w repo to logi
   JSON w `scripts/levels/logs/`, nie kod — poza skanem celowo).
   Korekta audytu V9: `VectorStageEnvironment visible=false` NIE jest
   "martwym kodem w kazdej scenie". Spis 45 scen: 01-08 bez wezla VSE
   (stacje maluja same), 09-16 z wezlem inertnym (visible=false,
   placeholder), 17-43 z wezlem ZYWYM (maluje scenografie: tlo, fartuch,
   nadwieszenia, swiatla). Wyciecie zlamaloby 29 scen — stad decyzja:
   ZOSTAJE, inwentarz w tym raporcie jest prawda, a kamery pinuje bramka.
5. V11: legacy capture ery wygaslej formy 43 adresow (PKG-0094:
   capture_act1/act2/act2b/act2c_vector_stage.gd + .uid) przeniesione
   do `tools/retired/`. Lista capture-prawd dopisana w `docs/INDEX.md`:
   prawda to `capture_preview.gd` + `capture_pkg_0187.gd`
   (mono/threshold/npc_frame) + `capture_pkg_0190.gd` (winiety) oraz
   bramkowe `capture_pkg_02*.gd` aktywnej trasy; `tools/retired/` to
   archiwum, nie prawda.
6. A5+K26: dev-raport 5 osi audio `tools/audio_5axis_report.gd`
   (NIE bramka, wylacznie reczny start). Wynik statyczny dla rodziny
   dyspozytora (osi: f0 / obwiednia / czas / noise-HF / AM-tremolo):

   | glos | dur | f0 | env | noise | AM |
   |---|---|---|---|---|---|
   | LENA | 0.05 | 587/1175/294 | exp-decay | - | - |
   | MARTA | 0.075 | 440/220/880 | sine-window | - | - |
   | JAKUB | 0.08 | 370/185/740/1480 | sine-window | grit | - |
   | WIERZBICKA | 0.06 | 520/1040/1560/3120 | exp-decay | HFx1 | - |
   | SZYMON | 0.09 | 260/520/780 | sine-window | - | 3.5+trem |
   | SYSTEM | 0.045 | 330/659/2600 | exp-decay | HFx1 | - |
   | ELDERLY | 0.075 | 480/240/960 | sine-window | - | 6.0+trem |

   Obserwacje (nie bramki): kolizja Marta 440 vs elderly 480 stoi
   (ten sam env, ten sam czas; roznia tylko tremolo i sub-struktura) —
   otwarte, do decyzji przy pakiecie glosowym. UNKNOWN celowo brzmi jak
   SYSTEM (else dyspozytora) — zaudytowane, nie pomylka. Granice narzedzia:
   analiza statyczna tekstu, nie odsluch ani DSP probek.
7. K28: Dev-Audio-Browser `tools/audio_browser.gd` (tylko test_mode:
   bez `--allow-audio-browser` odmawia startu; gra go nie referencjonuje
   — pinuje to bramka w isolated). `--list` zwraca 256 generatorow
   (zgodnie ze spisem D-225), `--info=<glos>` format/mix/dlugosc/hash
   (np. lena: 16-bit/44100/mono/0.050s), `--play=<glos>` odtwarza
   w sesji z audio. Nie rejestrowany w verify.

## Weryfikacja

- Baseline: `tools/verify_docs.ps1` PASS (52 pliki) przed edycjami.
- Nowa bramka `tests/pkg_0227_hygiene_tools_pin_test.gd` PASS (3x;
  po drodze 1x FAIL na brakujace wpisy INDEX przed ich dopisaniem —
  dowod fail-closed).
- Pin `pkg_0207` PASS (121/120/119 po aktualizacji, regula D-222);
  128. sekcja w `tools/verify.ps1`.
- Sasiedzi PASS bez dotykania: 0210 (settery/warstwy), 0214 (Binder),
  0221 (drabina/powrot), traversal_lint, smoke 01-43.
- Import `--headless --editor --quit` po dodaniu PhysicsLayers:
  `project.godot` IDENTYCZNY (diff pusty, ticki 60 na miejscu).
- Zakresowa `tools/verify_scoped.ps1` PASS exit 0 (docs 52 + smoke +
  7 bramek: 0227/0207/0210/0214/0221/traversal_lint/smoke).
  Licznik D-217: 1. zakresowa po pelnej PKG-0226 (limit: pelna
  najpozniej w PKG-0231).
- Blast: tools/verify.ps1 (komentarz), 4 strefy (literal->const,
  wartosci identyczne), nowy physics_layers.gd, testy (nowa bramka,
  pin, 128. sekcja), tools/ (2 dev-skrypty), tools/retired/ (4+4 pliki),
  docs. Monolity D-217, enumy, serialize, routing, progi, InputMap,
  linie, MRP-15, rigi, winiety, wyplata prawdy NIETKNIETE.
- Kadry: brak (zero zmian wizualnych; wartosci warstw identyczne,
  VSE i kamery nietkniete; runtime bramki dowodzi wartosci).

## Granice dowodu

Zielone bramki dowodza kontraktow mierzalnych (straznicy, warstwy 4x4,
spis kamer, zero draw_string, lista INDEX, izolacja dev-narzedzi), nie
tego, ze dzwieki sa rozroznialne ani obraz czytelny (D-012, ADR-003).
Raport 5 osi jest statyczny — kolizja 440/480 wymaga decyzji czlowieka
przy pakiecie glosowym, nie kolejnego linta. Faza R9 zamknieta w calosci
tym pakietem; kolejka: faza R10 (recertyfikacja PKG-0228).
