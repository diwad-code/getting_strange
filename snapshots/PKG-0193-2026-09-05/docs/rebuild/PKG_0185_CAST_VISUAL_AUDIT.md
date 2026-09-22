# PKG-0185 — Audyt ujednolicenia postaci, portretów i NPC

Status: **AUDYT ZAMKNIĘTY; NAPRAWA NIE WDROŻONA**
Data: 2026-09-04
Pakiet: PKG-0185 (dyspozycja właściciela: tylko audyt + plan)
Dowody: `reports/pkg_0185/visual/` (62 kadry runtime + 5 arkuszy kontaktowych)
Plan naprawy: `docs/rebuild/CAST_UNIFICATION_REPAIR_PLAN.md`

> Właściciel: NPC nadal są kółkiem i trójkątem; Lena i Marta wyglądają inaczej
> zarówno jako postaci, jak i na portretach; obsada ma być w stylu Leny i nie
> jest. Dokumentacja PKG-0172 / CURRENT_STATE nazywała DEF-2 i DEF-3
> „ZAMKNIĘTYMI TECHNICZNIE”. **Świeży kadr przeczy temu werdyktowi.**

---

## 1. Werdykt

| Warstwa | Werdykt | Jedno zdanie |
|---|---|---|
| DEF-2 (portret Marty = przemalowana Lena) | **TECHNICAL PASS, PRODUCT FAIL** | Raster Marty nie jest kopią Leny, ale **nie jest w jej języku graficznym**. |
| DEF-3 (NPC = kółka i trapezy, 22–48 px) | **PRODUCT FAIL na trasie 20 adresów** | Sprzedawca (06) i sąsiadka (08) są nadal kółkiem + trapezem. Marta/Jakub/Wierzbicka mają sprite, ale z innego medium. |
| H-045 (jedna obsada, jeden język) | **REFUTED-IN-PART** | Rig i płótno 64×104 istnieją. Język obrazu nie. |
| Kanon stylu | **Lena 4.1 jest jedynym wzorcem** | `assets/characters/lena/idle.png` + `portraits/lena.png`. Reszta ma do nich dojść, nie odwrotnie. |

Nie ruszać Leny. Nie wydawać `.exe`. Nie traktować GATE-CAST PKG-0172 jako dowodu urody.

---

## 2. Metoda

1. Inwentaryzacja assetów: `assets/characters/{lena,marta,jakub,wierzbicka}/`, `portraits/`, surowe JPEG-i, `tools/process_npc_sprites.py`.
2. Grep prymitywów ludzkich w `scripts/levels/station_*.gd` i `memory_resonance_point.gd`.
3. Świeży capture normalnym driverem Windows (Intel Iris Xe, OpenGL 3.3, Godot 4.7.2):
   `godot --path . --script res://tools/capture_pkg_0185.gd --audio-driver WASAPI`
   → 62 kadry, `PKG-0185 CAST AUDIT CAPTURE PASS`.
4. Arkusze kontaktowe: `tools/audit_cast_contact_sheets.py`.
5. Inspekcja kadrów (heurystyka: sylwetka, krawędź, paleta, skala, tożsamość sprite↔portret). To nie jest playtest.

Nie nadpisano `reports/pkg_0182/`, `pkg_0183/`, `pkg_0184/`.

---

## 3. Co jest kanonem (Lena 4.1)

Prompt produkcyjny Leny (`assets/characters/lena/raw/prompt_idle.txt`) jest wiążący:

- widok 3/4, dorosła anatomia, stosunek głowy do ciała ~1:6,5;
- płaskie, twarde płaszczyzny, ograniczona paleta (grafit, bursztyn skóry, atramentowe włosy, stonowany teł);
- zakaz photoreal, malarskiego rozmycia, tekstur, napisów, UI;
- płótno 64×104, pivot (32, 96), nearest, bez skalowania per klatka.

W kadrze 640×360 Lena czyta się jako **graficzna postać Pixel-Stage**. Portret CRT 56×62 zachowuje tę samą twarz po nearest.

To jest jedyny akceptowalny język dla każdego człowieka w kadrze.

---

## 4. Mapa ludzi na trasie 20 adresów

| Adres | Osoba w kadrze | Nośnik faktyczny | Styl | Skala vs Lena |
|---|---|---|---|---|
| 01–05, 07, 09, 13–18, 42A, 43 | tylko Lena | `LenaVisualRig` | Pixel-Stage 4.1 | kanon 87±3 px |
| **06 kiosk** | **sprzedawca** | `_draw()`: `draw_circle` r=12 + trapez | **kółko + trójkąt** | ~55 px, bez anatomii |
| **08 klatka** | **sąsiadka** | `_draw()`: `draw_circle` r=10 + trapez | **kółko + trójkąt** | ~55 px, bez anatomii |
| **10 mieszkanie** | Marta | `CharacterVisualRig` `idle.png` | malarska lalka 3/4 | zbliżona wysokość, obcy język |
| **11 instytucja** | Wierzbicka | `CharacterVisualRig` `seated.png` | profil 3D, **pomniejszony standing** | **dziecko** względem Leny |
| **12 warsztat** | Jakub | `CharacterVisualRig` `work.png` | malarski kombinezon | zbliżona wysokość, obcy język |
| **42B / 42C próg** | Marta | ten sam `idle.png` | j.w. | j.w. |

`CharacterVisualRig` stoi tylko w pięciu scenach: 10, 11, 12, 42b, 42c.
D-194 wariant B **celowo** zostawił sprzedawcę, sąsiadkę i Szymona „bezcieleśnymi”.
To jest przyczyna, dla której właściciel nadal widzi kółka na trasie, mimo GATE-CAST.

---

## 5. Findings

### F-0185-001 — Prymitywy ludzkie na żywej trasie (P0)

`scripts/levels/station_06.gd` linie 274–279:

```
draw_circle(Vector2(420.0, 205.0), 12.0, vendor_color)
draw_colored_polygon([trapez], vendor_color)
```

`scripts/levels/station_08.gd` linie 275–280:

```
draw_circle(Vector2(340.0, 205.0), 10.0, neighbour_color)
draw_colored_polygon([trapez], neighbour_color)
```

Kadry: `station_06__npc_frame.png`, `station_06__opening_panel.png`,
`station_08__npc_frame.png`. Lena (pixel-art) stoi obok kółka.

Test `pkg_0172_smoke_test.gd` szuka **konkretnych** współrzędnych
`(248, 214)` / `(348, 214)` / `(478, 146)` / `(480, 206)` oraz
`prop_type` prymitywnych osób. Nie szuka `station_06`/`station_08`.
Bramka jest ślepa na ten defekt.

### F-0185-002 — Sprite'y obsady są z innego medium (P0)

`tools/process_npc_sprites.py` bierze **jeden** JPEG na postać
(`marta/raw/cdf1c0d4-….jpeg`, `jakub/raw/40365fc3-….jpeg`,
`wierzbicka/raw/7d5423b5-….jpeg`) — malarskie ilustracje 3/4 lub profil —
i wpisuje je na płótno 64×104 przez **LANCZOS**.

Wynik w kadrze (`station_10__npc_frame.png`, `station_12__npc_frame.png`,
`station_42b__npc_frame.png`): lalki z miękkim cieniowaniem obok twardej
Lena 4.1. To nie jest „ta sama gra”.

Arkusz: `contact_sprites_idle.png`, `contact_lena_vs_cast.png`.

### F-0185-003 — Siedem stanów NPC jest fałszerstwem (P1)

`generate_states()` w `process_npc_sprites.py` nie generuje poz.
`talk_0` / `talk_1` / `listen` / `gesture` / `work` to przesunięcie wycinka
głowy o 1–2 px. `turn_away` to lustrzane odbicie. `seated` to **obcięcie
i zmniejszenie tej samej stojącej figury** do 58 px.

Arkusz: `contact_npc_states.png`. Wierzbicka „siedząca” w Station 11
(`station_11__npc_frame.png`) jest miniaturową stojącą kobietą obok Leny —
wygląda jak dziecko, łamie kanon 84–92 px / seated 56–60 px z anatomią
siedzącą.

### F-0185-004 — Pięć języków portretu w jednym CRT (P0)

| Plik | Język | Czytelność w 56×62 |
|---|---|---|
| `lena.png` | płaski graphic bust, twarda krawędź | wysoka |
| `marta.png` | malarski portret, miękkie pasma różu, septum | niska (papka) |
| `jakub.png` | pół-pixel, kamuflaż UCP, inna kreska niż Lena | średnia |
| `wierzbicka.png` | fotoreal / półton | niska |
| `szymon.png` | bliżej Leny, ale miększy rendering | średnia |

Kadry paneli: `panel_portrait__{lena,marta,jakub,wierzbicka,szymon}.png`.
Arkusz CRT: `contact_portraits_crt_scale.png`.
W `panel_dialogue__marta_then_lena.png` portret Marty i sprite Marty
**nie są tą samą osobą w tym samym języku**.

`pkg_0172` sprawdza: plik istnieje, 1024×1024, dane ≠ `lena.png`, liczba
pikseli „różowych” > ciemnych. To przechodzi dla dowolnej malarskiej Marty
z różowymi włosami. Nie mierzy języka.

### F-0185-005 — Tożsamość sprite ↔ portret zerwana (P1)

- Lena sprite ≈ Lena portret (ten sam klin, płaszcz, kreska).
- Marta sprite: sukienka 3/4, lalka. Marta portret: inne rysy, inne światło, inne medium.
- Jakub sprite: 3/4 standing. Jakub portret: inna kreska, kamuflaż.
- Wierzbicka sprite: **profil**. Wierzbicka portret: **3/4 twarz**. To nie jest ten sam ujęcie-język.

CAST_AND_NPC_BIBLE §4.3: „portret w CRT i sprite w świecie muszą pokazywać
**tę samą osobę**”. Niespełnione wzrokowo.

### F-0185-006 — Monolit MRP nadal rysuje ludzi z kółek (P2, dawca)

`memory_resonance_point.gd` nadal zawiera m.in.:

- `_draw_marta_interaction` — „Marta's head” `draw_circle`
- `_draw_marta_observation_dialogue`
- `_draw_elderly_passenger`, `_draw_elderly_resident_guide`
- `_draw_ucp_intervention_team`
- `_draw_szymon_bera`
- `_draw_jakub_service_operator`

Na trasie 20 adresów te `prop_type` nie są instancjonowane (GATE-CAST to
sprawdza). Sceny 19–41 pozostają na dysku jako dawcy. Pauza nie oferuje
ich w selektorze (D-200). Ryzyko: powrót dawcy albo `prop_type = 198`
(`MARTA_WITNESS_STATION`) w 42B/C — próg 42B/C ma **równolegle**
`CharacterVisualRig` Marty i prop 198. Inspekcja 42B nie pokazała drugiej
głowy-kółka na progu (rysunek doorstep został ogołocony z głowy w 0172),
ale funkcje prymitywów żyją w monolicie.

### F-0185-007 — Testy certyfikowały kontrakt pliku, nie obrazu (P0 procesowy)

| Bramka | Co naprawdę zmierzyła | Czego nie widzi |
|---|---|---|
| `pkg_0172_smoke_test.gd` | rig, 64×104, wysokość 56–92, `draws_polygonal_body()==false`, Marta ≠ kopia rastra Leny, róż ≥ 40 px | język, kółka w `_draw()` stacji 06/08, fałszywe stany, CRT 56×62 |
| `pkg_0160_smoke_test.gd` | róż Marty ≥ 20 px | styl |
| `pkg_0179_smoke_test.gd` | 1024×1024, alfa Wierzbickiej | photoreal |

Dlatego CURRENT_STATE mógł napisać „DEF-3 ZAMKNIĘTY TECHNICZNIE na trasie
20 adresów”, a właściciel nadal widzi kółko w kiosku.

---

## 6. Pokrycie kadrów PKG-0185

Katalog: `reports/pkg_0185/visual/`. Driver: Windows / Intel Iris Xe.

| Powierzchnia | Pliki |
|---|---|
| Tytuł, ustawienia, pauza, zimne otwarcie | `shell_title__pl.png`, `settings__pl.png`, `pause__campaign.png`, `cold_open__initial.png` |
| 20 adresów kampanii, kadr spokojny | `station_XX__normal.png` (01–18, 42a/b/c, 43) |
| 20 adresów, panel otwarcia (CRT) | `station_XX__opening_panel.png` |
| NPC / prymityw z bliska | `station_{06,08,10,11,12,42b,42c}__npc_frame.png` |
| Portrety CRT per mówca | `panel_portrait__{lena,marta,jakub,wierzbicka,szymon}.png` |
| Myśl Leny | `panel_thought__lena.png` |
| Dialog Marta na tle sprite'a Marty | `panel_dialogue__marta_then_lena.png` |
| Arkusze | `contact_portraits.png`, `contact_portraits_crt_scale.png`, `contact_sprites_idle.png`, `contact_npc_states.png`, `contact_lena_vs_cast.png` |

Panele tytułu / pauzy / ustawień nie noszą portretów — niespójność ich nie
dotyka. Zimne otwarcie nie pokazuje twarzy (D-197, kadr poniżej brody).
Otwierające linie 01–18 to zwykle Lena; portret Leny w CRT jest spójny ze
sprite'em. Problem wychodzi, gdy mówi ktoś inny albo gdy w kadrze stoi
druga osoba.

---

## 7. Co audyt świadomie zostawia

- Stacje legacy 19–41: nie są na trasie; prymitywy MRP tam żyją jako dług P2.
- Szymon: portret jest, sprite'u nie ma; D-194 zostawił go poza wariantem B.
  Portret i tak wisi w CRT, więc musi wejść w unifikację języka.
- Uroda / „czy Marta jest ładna”: `OPEN-NO-EVIDENCE` (D-012). Audyt twierdzi
  tylko, że **nie jest w języku Leny**.
- Lena 4.1 sama w sobie: poza zakresem naprawy. Jest wzorcem.

---

## 8. Dlaczego poprzednie zamknięcia nie wystarczyły

1. D-194 wyłączył sprzedawcę i sąsiadkę z zakresu „naprawy ludzi”.
2. Pipeline NPC wziął malarski JPEG i przeskalował LANCZOS zamiast
   powtórzyć prompt Leny (`flat hard-edged graphic illustration`).
3. Bramki mierzyły istnienie pliku, rozmiar płótna i hue różu.
4. CURRENT_STATE zrównał „jest `CharacterVisualRig`” z „wygląda jak Lena”.

Właściciel ma rację. Dokumentacja się myliła.
