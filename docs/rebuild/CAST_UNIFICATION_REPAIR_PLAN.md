# Plan naprawy — jeden język postaci (styl Leny 4.1)

Status: **WDROŻONA PRZEZ PKG-0186 (2026-09-04)**
Data: 2026-09-04
Nadrzędne: `docs/rebuild/PKG_0185_CAST_VISUAL_AUDIT.md`, `CAST_AND_NPC_BIBLE.md`,
`VISUAL_DESIGN.md` §5 i §7, `docs/LENA_CHARACTER_AND_ANIMATION.md` §3 i §10
Decyzja: D-202 (Lena 4.1 = wzorzec języka; DEF-2/DEF-3 ponownie otwarte produktowo)

Ten dokument jest planem. **Nie wdraża assetów.** Wdrożenie = PKG-0186.

---

## 1. Cel

Każdy człowiek w kadrze — sprite, portret CRT, sprzedawca, sąsiadka —
należy do tego samego języka co Lena 4.1. Gracz nie ma widzieć dwóch gier
w jednym kadrze ani kółka z trapezem tam, gdzie stoi osoba.

Leny nie regenerujemy. `assets/characters/lena/` i `portraits/lena.png`
są **masterem**.

---

## 2. Definicja „stylu Leny” (kontrakt odrzutu)

Klatka / portret **przechodzi**, gdy spełnia wszystkie punkty naraz:

1. Widok 3/4 (nie czysty profil, nie en face), poza z masą, stopy na linii gruntu.
2. Płaskie wypełnienia, twarde krawędzie. Zero malarskiego blendu, zero
   photoreal, zero porów skóry, zero miękkiego halo.
3. Paleta ≤ 12 barw funkcjonalnych na postać. Skóra = ciepły bursztyn z
   kanonu Leny, nie fotografowany cielisty gradient.
4. Stosunek głowy do wzrostu 1:6–1:8. Zakaz chibi i krasnoludka.
5. Płótno sprite: 64×104, pivot (32, 96), nearest, bez mipmap, `scale = 1`.
6. Portret: 1024×1024 alfa, ta sama twarz co sprite, czytelna po downscale
   nearest do 56×62 (rozmiar CRT).
7. Jedna poza = jedno wywołanie generatora. Zakaz `process_npc_sprites.py`
   (przesuwanie głowy, flip, shrink jako „seated”).
8. W kadrze obok Leny wzrost 0,92–1,06 (Jakub +3 px, Wierzbicka +2 px
   stojąc; seated 56–60 px z biodrami na siedzisku, nie miniaturka standing).

Odrzut natychmiast, jeśli klatka wygląda jak downskalowana ilustracja 3D
albo jak kółko + wielokąt.

Wzorzec pozytywny: `assets/characters/lena/idle.png`,
`assets/characters/lena/walk_0.png`, `portraits/lena.png`.
Wzorzec negatywny (stan 2026-09-04): `marta/idle.png`,
`jakub/idle.png`, `wierzbicka/idle.png`, `portraits/marta.png`,
`portraits/wierzbicka.png`, `_draw()` w `station_06.gd` / `station_08.gd`.

---

## 3. Zakres ludzi

| Osoba | Sprite | Portret | Gdzie stoi | Priorytet |
|---|---|---|---|---|
| Lena Wolska | **bez zmian** | **bez zmian** | wszędzie | wzorzec |
| Marta Kurek | 7 prawdziwych poz | regeneracja w języku Leny | 10, 42B, 42C (+ CRT) | 1 |
| Jakub Wolski | 7 prawdziwych poz | regeneracja | 12 + CRT | 2 |
| dr Helena Wierzbicka | 7 poz, **seated = siedząca** | regeneracja 3/4 (nie photoreal) | 11 + CRT | 2 |
| Sprzedawca kiosku | idle + talk_0/1 + listen | opcjonalny bust CRT | 06 | 1 (P0 prymityw) |
| Sąsiadka Kowalska | idle + talk_0/1 + listen + gesture | opcjonalny bust CRT | 08 | 1 (P0 prymityw) |
| Szymon Bera | poza zakresem ciała (D-194) | regeneracja języka, bo CRT go pokazuje | tylko panel | 3 |

Karty tożsamości z `CAST_AND_NPC_BIBLE.md` §2 **zostają** (róż Marty, septum,
sukienka, szelki Jakuba, żakiet Wierzbickiej). Zmienia się wyłącznie medium.

Sprzedawca: mężczyzna 50+, wełniana kamizelka, za szybą kiosku, 3/4,
tors + głowa czytelne w oknie 150×80. Nie kółko.
Sąsiadka: kobieta 60+, wełniany płaszcz, na spoczniku klatki, 84–92 px.

---

## 4. Pipeline (obowiązkowa kolejność)

Nie wolno zacząć od `process_npc_sprites.py`. Ten skrypt idzie do
`tools/retired/` w pierwszym commicie pakietu naprawczego (tu: pierwszym
zapisem PKG-0186).

Dla każdej osoby:

1. **Płyta tożsamości (identity plate)** — `image_edit` z dwoma wejściami:
   - styl: `assets/characters/lena/idle.png` (sprite) albo `portraits/lena.png` (portret);
   - treść: karta z biblii + ewentualnie obecny portret wyłącznie jako
     nośnik rysów, **nie** jako styl.
   Prompt: „flat hard-edged graphic illustration in the exact pixel-stage
   language of the Lena reference, limited palette, no painterly blend,
   no photoreal, no text”. Jedna płyta na osobę, zapis w
   `assets/characters/<id>/raw/pkg_0186/identity.png`.
2. **Portret CRT** — ta sama płyta, kadr popiersia 1024×1024 alfa.
   Weryfikacja: downscale nearest 56×62 nadal pokazuje klin/włosy/nos,
   nie papkę. Porównaj z `portraits/lena.png` w tym samym rozmiarze.
3. **Pozy sprite** — każda poza osobnym wywołaniem z płyty jako referencją
   tożsamości i `lena/idle.png` jako referencją języka. Zakaz arkuszy.
   Lista minimalna:
   - Marta/Jakub/Wierzbicka: idle, talk_0, talk_1, listen, gesture,
     turn_away, seated **albo** work (Wierzbicka: seated prawdziwe;
     Jakub: work; Marta: gesture).
   - Sprzedawca/sąsiadka: idle, talk_0, talk_1, listen.
4. **Pieczenie** — ten sam skrypt co Lena (`tools/process_lena_sprites.py`
   albo jego kopia `process_cast_sprites.py`): flood bg, bbox, wpisanie
   na 64×104, pivot (32, 96), nearest. **Bez LANCZOS na końcu** jeśli
   źródło jest już w rastrze docelowym; jeśli źródło jest większe,
   downscale **NEAREST** albo 2× nearest po ręcznym zmniejszeniu do
   wielokrotności 64.
5. **Import Godot**: `texture_filter = nearest`, mipmap off, repeat off.
6. **Osadzenie**: `CharacterVisualRig` w `Props` / istniejącym blockout.
   Stacje 06 i 08: usunąć rysunek kółka z `_draw()`, dodać węzeł riga.
7. **CRT**: istniejący `CRTPortrait` ładuje `portraits/<id>.png`. Nowe
   busty sprzedawcy/sąsiadki tylko jeśli dialog ich nazywa; w przeciwnym
   razie zostaje pusta ramka (obecne zachowanie).

Po dwóch odrzutach tej samej pozy zmień model, nie prompt (bible §7).
Po czterech — stop i wpis w SESSION_LOG.

---

## 5. Kod, który musi się zmienić

| Plik | Zmiana |
|---|---|
| `scripts/levels/station_06.gd` | usunąć `draw_circle` + trapez sprzedawcy; riga nie rysować w `_draw()` |
| `scripts/levels/station_08.gd` | usunąć `draw_circle` + trapez sąsiadki |
| `scenes/levels/station_06.tscn` | dodać `CharacterVisualRig` `vendor` przy oknie (ok. 420, 296 albo za ladą, seated/tors) |
| `scenes/levels/station_08.tscn` | dodać `CharacterVisualRig` `neighbour` na spoczniku (340, 296) |
| `scripts/characters/character_visual_rig.gd` | dodać `vendor`, `neighbour` do `STANDING_HEIGHTS`; nie rysować ciała |
| `tools/process_npc_sprites.py` | przenieść do `tools/retired/` |
| `tests/pkg_0172_smoke_test.gd` | **rozszerzyć** (nie osłabiać): 06/08 bez kółka-głowy; vendor/neighbour mają riga; heurystyka języka |
| nowy `tests/pkg_0186_cast_style_test.gd` | RED na obecnym `marta/idle.png` vs `lena/idle.png`; GREEN po wymianie |
| `scripts/ui/crt_portrait.gd` | dodać normalizację `vendor` / `sąsiadka` tylko jeśli powstaną busty |
| `docs/rebuild/CAST_AND_NPC_BIBLE.md` | dopisać §2.6 sprzedawca, §2.7 sąsiadka; §7 odrzut „malarska lalka”; wycofać LANCZOS |
| `memory_resonance_point.gd` | nie ruszać monolitów dawcy w tym pakiecie (P3, F-0184-010), chyba że 42B/C `prop_type = 198` znów narysuje głowę |

Nie rozszerzać `PrototypePlayer`. Nie ruszać fizyki.

---

## 6. Testy — najpierw czerwone

Nowy test `tests/pkg_0186_cast_style_test.gd` musi **padać na stanie
PKG-0185** zanim powstanie jakikolwiek nowy asset.

### 6.1 Prymityw na trasie (deterministyczne)

- `station_06.gd` nie zawiera `draw_circle(Vector2(420.0, 205.0)`
- `station_08.gd` nie zawiera `draw_circle(Vector2(340.0, 205.0)`
- obie sceny zawierają `character_visual_rig.gd` i `character_id` vendor/neighbour
- `tools/process_npc_sprites.py` nie istnieje poza `tools/retired/`

### 6.2 Heurystyka języka sprite (Marta vs Lena)

Na `idle.png` 64×104, tylko piksele a>0.4:

- liczba unikalnych kolorów skwantowanych do 16 poziomów / kanał:
  Lena jest wzorcem; Marta nie może przekraczać 1,8× Leny (malarska lalka
  ma dużo więcej półtonów);
- udział pikseli, których dwaj sąsiedzi 4-connected różnią się o ΔRGB<12
  (miękki blend): próg odcięcia = 1,5× wartość Leny;
- bounding-box wysokości 84–92 px (standing) albo 56–60 px (seated).

Dokładne progi **zmierzyć na Lenie w RED** i wpisać stałe. Nie zgadywać.

### 6.3 Portret CRT

- każdy `portraits/*.png` 1024×1024;
- kopia nearest 56×62: wariancja krawędzi Sobel ≥ 0,6× Leny (photoreal
  Wierzbickiej spadnie);
- Marta: nadal róż (kontrakt biblii), ale **w dwóch płaskich odcieniach**,
  nie w gradiencie malarskim. Przepisać `pkg_0160`/`pkg_0172` pink-count
  tak, by płaski róż przechodził, a malarski nie był jedyną drogą.

### 6.4 Capture

`tools/capture_pkg_0186.gd` (kopia 0185): po naprawie te same powierzchnie
do `reports/pkg_0186/visual/`. Inspekcja: 06/08 bez kółka; 10/11/12/42B/C
Marta/Jakub/Wierzbicka w kresce Leny; panele CRT tej samej osoby co sprite.

---

## 7. Pakiet wykonawczy PKG-0186 (mega, 2×–5×)

Jeden pakiet, siedem strumieni. Nie rozbijać na mikro-PKG, chyba że
kredyty `gen-ai` spadną poniżej 300 (bible §6.1).

| # | Strumień | Wejście | Wyjście | Stop jeśli |
|---|---|---|---|---|
| A | RED test + emerytura `process_npc_sprites.py` + D-202 w kodzie testu | audyt 0185 | padający `pkg_0186_cast_style_test.gd` | test nie pada na obecnym `marta/idle.png` |
| B | Płyty tożsamości Marta, Jakub, Wierzbicka, sprzedawca, sąsiadka | Lena idle + karty biblii | `raw/pkg_0186/identity.png` ×5 | płyta jest malarska |
| C | Portrety CRT (5 + Szymon) | płyty | `portraits/*.png` czytelne w 56×62 | papka w CRT |
| D | Pozy sprite (Marta pełne 7, Jakub 7, Wierzbicka 7 z prawdziwym seated) | płyty | `assets/characters/<id>/*.png` | seated = shrink |
| E | Sprzedawca + sąsiadka: asset + `CharacterVisualRig` w 06/08, wycinanie `_draw()` | płyty + tscn | brak kółek w kadrze 06/08 | kółko zostaje |
| F | GREEN test + capture 0186 + inspekcja arkuszy | A–E | `pkg_0186` PASS, 62+ kadrów | kadr 10 nadal pokazuje dwie gry |
| G | Dokumentacja, H-045, DEF-2/DEF-3, snapshot | F | living docs = dysk | CURRENT_STATE znowu kłamie „zamknięte technicznie” bez kadru |

Szacunek assetów: ~5 płyt + 6 portretów + ~25 klatek sprite ≈ 36 wywołań
generatora. Lena 0. Kredyty: sprawdzić `gen-ai credits` przed B.

---

## 8. Kryteria zamknięcia PKG-0186

Pakiet jest DONE tylko gdy:

1. `tests/pkg_0186_cast_style_test.gd` przechodzi.
2. `pkg_0172` nadal przechodzi **i** obejmuje 06/08.
3. Świeże kadry 06 i 08: zero kółka-głowy. Sprzedawca i sąsiadka są sprite'em
   w kresce Leny.
4. Kadr 10: Lena i Marta to ten sam język, dwie różne osoby (róż, septum,
   sukienka vs klin i płaszcz).
5. Kadr 11: Wierzbicka siedzi, nie jest miniaturką standing.
6. Kadr 12: Jakub w kresce Leny, szelki bursztyn.
7. Panel CRT Marty pokazuje tę samą twarz co sprite Marty.
8. `verify.ps1` exit 0. ObjectDB 0.
9. CURRENT_STATE nazywa DEF-2/DEF-3 **zamkniętymi produktowo dopiero po
   kadrze**, nie po istnieniu pliku.
10. Snapshot `PKG-0186`.

Nie wolno napisać „TECHNICAL PASS” na podstawie samego riga.

---

## 9. Świadome poza zakresem PKG-0186

- Regeneracja Leny, nowych stanów lokomocji, cold_open shot 2.
- Szymon jako ciało na trasie (zostaje długiem D-194 / wariant C).
- Czyszczenie wszystkich `_draw_*person*` w monolicie MRP (P3, chyba że
  42B/C znów pokaże kółko).
- PRODUCT GO, GATE-REL, nowe `.exe` (D-168).
- Ocena „czy Marta jest ładna” (D-012).

---

## 10. Rollback

Assety stare zostawić w `assets/characters/<id>/raw/pkg_0172_backup/` przed
nadpisaniem. Sceny 06/08: jeśli rig nie wstanie, przywrócić `_draw()` z
snapshotu PKG-0185, nie z pamięci. Test 0186 ma wtedy znowu paść — to jest
sygnał, nie wstyd.
