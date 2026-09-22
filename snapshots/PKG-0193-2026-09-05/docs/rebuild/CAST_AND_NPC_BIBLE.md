# Biblia obsady i NPC — wygląd, skala, rig, pipeline

PKG-0193 / CR-A: Marta ma dodatkowe wystąpienie istniejącego
`CharacterVisualRig` przy stole w Station 13. Rigi Marty 10/13 i Jakuba 12
reagują na lokalne rozmowy. To reużycie istniejącej obsady i assetów, bez
nowych sylwetek, rozdzielczości lub globalnego sterownika postaci.

Status: **AKTYWNY KONTRAKT WIZUALNY OBSADY — D-186 / D-187 / D-202 / PKG-0186**
Data: 2026-09-04 (PKG-0186 wdrożył język Leny 4.1; sukienka Marty ≠ kolor włosów; proporcje 1:6,5)
Nadrzędne: `docs/rebuild/CAST_UNIFICATION_REPAIR_PLAN.md` (PKG-0186),
`docs/rebuild/PKG_0185_CAST_VISUAL_AUDIT.md`,
`docs/rebuild/PRESENTATION_REPAIR_PLAN.md` (DEF-2, DEF-3 ponownie otwarte produktowo)
Powiązane: `docs/WORLD_SCALE.md` §3, `VISUAL_DESIGN.md` §4 i §7,
`docs/LENA_CHARACTER_AND_ANIMATION.md` §11, `docs/narrative/NARRATIVE_BIBLE.md`

---

## 1. Zasada nadrzędna

> **Jeżeli w kadrze stoi człowiek, jest zbudowany tak samo jak Lena.**

Jeden rig, jedno płótno, jeden metr, jedna metoda generacji, jedna metoda
normalizacji. Nie ma „NPC rysowanego proceduralnie, bo to tylko tło”.
Nie ma postaci o wzroście 36 px obok postaci o wzroście 87 px.

Wyjątki są dwa i są jawne:

1. **Sylwetka w rekwizycie** — twarz na zdjęciu, postać na ekranie CCTV,
   figura na rysunku dziecka. To jest obraz *wewnątrz* obiektu, ma własną skalę
   ramki i wolno ją rysować proceduralnie.
2. **Cień / kontur za matową szybą**, gdzie nierozpoznawalność jest treścią
   sceny. Musi być jawnie nieczytelny, a nie „mały człowiek”.

Wszystko inne — osoba stojąca w przestrzeni gry — jest sprite'em.

---

## 2. Karty tożsamości

Karta jest **stała między pozami i między scenami**. Model generujący dostaje
ją w całości przy każdym wywołaniu; poza tym dostaje obraz referencyjny.

### 2.1 Lena Wolska — punkt odniesienia (istniejąca, bez zmian)

29 lat, diagnostyczka drgań. Krótki klin ciemnych włosów, twarz dorosłej
kobiety, roboczy kombinezon / kurtka w chłodnej zieleni, jasny szew na lewym
rękawie, asymetryczna torba. Zamknięta poza, ręce blisko ciała, wzrok
skierowany w przyrząd. Wzrost **87 ± 3 px**.

Assety: `assets/characters/lena/` (rig 4.1, PKG-0136).
**Ten pakiet nie zmienia Leny** poza dodaniem klatek z §5.3.

### 2.2 Marta Kurek — przeciwieństwo Leny (DO WYGENEROWANIA OD ZERA)

30 lat, elektrotechniczka, była partnerka terenowa Leny, w Równi partnerka
życiowa miejscowej Leny (`NARRATIVE_BIBLE.md` §5).

Właściciel zdefiniował jej wygląd wprost — to jest wiążące:

| Cecha | Treść | Kontrast wobec Leny |
|---|---|---|
| Włosy | **długie, różowe**, opadające na ramiona i klatkę piersiową; nie związane | Lena: krótki ciemny klin |
| Twarz | **inna anatomia niż Leny** — okrąglejsza żuchwa, wyżej osadzone kości policzkowe, wyraźny uśmiech pokazujący zęby | Lena: wąska, zamknięta, neutralna |
| Kolczyk | **septum** — mały stalowy pierścień w przegrodzie nosa, czytelny w rastrze portretu | Lena: brak biżuterii |
| Strój (dom, relacja) | **sukienka krem / brudna biel** z kołnierzykiem; **nigdy w kolorze włosów** — róż jest tylko we włosach | Lena: kombinezon roboczy |
| Strój (praca, teren) | kurtka elektrotechniczki **z sukienką pod spodem** albo z tą samą paletą; włosy i septum zostają | — |
| Postawa | **otwarta i ekspresyjna** — ramiona rozłożone, ciężar na jednej nodze, ręce w geście, głowa przechylona | Lena: symetryczna, zwarta |
| Temperament | ekstrawertyczna; mówi konkretami domu i granic (`NARRATIVE_BIBLE.md` §5) | Lena: milczy i mierzy |

**Rozstrzygnięcie sprzeczności zawód/strój:** Marta jest elektrotechniczką, ale
gracz spotyka ją prawie zawsze **poza zmianą** — w mieszkaniu, na progu, w
epilogu. Domyślnym strojem jest sukienka. Wariant roboczy istnieje wyłącznie
tam, gdzie scena wymaga narzędzi (torba narzędziowa jest już w runtime).

**Rozstrzygnięcie paletowe — wymaga świadomej decyzji przy wdrożeniu.**
`VISUAL_DESIGN.md` §4 dopuszcza maksymalnie dwa kolory akcentu na scenę, a
paleta świata nie zawiera różu. Kontrakt:

- róż Marty jest **hue wyprowadzonym z rodziny „zgaszona czerwień”**, nie
  neonowym magentą; dwa odcienie (cień + światło), zero gradientu;
- w scenie z Martą róż **zajmuje jeden ze slotów akcentu**, więc bursztyn albo
  turkus schodzi w tej scenie do roli barwy świata;
- róż nie pojawia się nigdzie indziej w kadrze. Jest identyfikatorem osoby,
  nie dekoracją.

**Zakaz twardy (D-187):** portret Marty nigdy więcej nie powstaje przez
modyfikację rastra Leny. `tools/update_marta_portrait.py` jest wycofany.

### 2.3 Jakub Wolski

34 lata, utrzymanie ruchu Linii 4, brat Leny. Rodzinne podobieństwo do Leny w
kościach twarzy i kolorze włosów — to jest **zamierzone i musi zostać**, ale
sylwetka jest cięższa, barki szersze, poza sztywniejsza. Roboczy kombinezon
UCP z odblaskowymi szelkami (bursztyn), ciężkie buty, karta magnetyczna.
Istniejący portret `assets/characters/portraits/jakub.png` jest **dobry** i
zostaje jako referencja tożsamości dla sprite'ów.

### 2.4 dr Helena Wierzbicka

Instytucja w postaci osoby. Wysoka, pionowa sylwetka, ciemny żakiet, włosy
gładko upięte, zero akcentu ciepłego koloru. Zawsze wyprostowana, zawsze z
czymś między nią a Leną (biurko, szyba, pulpit). Paleta: brudna biel i grafit.

### 2.5 Szymon Bera

Starszy, zniszczony, w instytucjonalnym swetrze. Siedzi. Głowa pochylona.
Siwe włosy. Sylwetka wąska, barki opadnięte. Nawet siedząc musi mieć skalę
zgodną z tabelą (patrz §3.2). Ciało na trasie pozostaje poza zakresem
(D-194 wariant C). Portret CRT jest w języku Leny 4.1 (PKG-0186).

### 2.6 Sprzedawca kiosku (Station 06)

Mężczyzna 50+, wełniana kamizelka grafit na stonowanej teal koszuli, ciemne
spodnie. 3/4, dorosłe 1:6,5, nie krasnoludek. Stoi przy oknie kiosku jako
`CharacterVisualRig` `vendor`. Zakaz `draw_circle` jako głowy.

### 2.7 Sąsiadka Kowalska (Station 08)

Kobieta 60+, wełniany płaszcz grafit, ciemna spódnica, krótkie stalowoszare
włosy. 3/4, 84–92 px, na spoczniku klatki. `CharacterVisualRig` `neighbour`.
Zakaz kółka + trapezu.

---

## 3. Kontrakt skali

### 3.1 Postać stojąca

| Wielkość | Wartość |
|---|---|
| Wzrost widoczny (stopa → czubek głowy) | **84–92 px** |
| Głowa | 13–15 px wysokości, 11–13 px szerokości |
| Barki | 22–28 px |
| Płótno klatki | **64 × 104 px**, identyczne jak Lena |
| Pivot wypalony | (32, 96) — kolumna bioder x = 32, linia gruntu y = 96 |
| Skalowanie per klatka | **zabronione** (D-129) |

### 3.2 Postać w innej pozie

| Poza | Wysokość widoczna | Uwaga |
|---|---|---|
| Siedząca na krześle / łóżku | 56–60 px | biodra na siedzisku 23 px |
| Kucająca / pochylona nad czymś | 58–66 px | |
| Za ladą / biurkiem (widoczny tors) | 46–52 px | reszta zasłonięta, nie skrócona |
| Sylwetka za matową szybą | dowolna, **musi być nieczytelna** | wyjątek §1.2 |

### 3.3 Test odbioru przy wdrożeniu

Kadr jest odrzucony, jeśli:

- postać obok stojącej Leny jest niższa niż 0,92 albo wyższa niż 1,06 jej wzrostu
  (poza uzasadnionymi różnicami: Jakub +3 px, Wierzbicka +2 px, Szymon −4 px);
- głowa postaci jest większa niż 1/5,5 wzrostu (chibi) albo mniejsza niż 1/8;
- postać dotyka podłogi w innym miejscu niż jej cień kontaktowy (>2 px różnicy);
- widać, że postać jest zbudowana z kółka i prostokąta.

---

## 4. `CharacterVisualRig` — kontrakt techniczny

Nowy węzeł, **nie** rozszerzenie `MemoryResonancePoint`.

Sugerowana lokalizacja: `scripts/characters/character_visual_rig.gd`,
`class_name CharacterVisualRig extends Node2D`.

### 4.1 Kontrakt identyczny z `LenaVisualRig`

Skopiuj rozwiązane problemy 4.1, nie wymyślaj ich od nowa
(`LENA_CHARACTER_AND_ANIMATION.md` §11.2):

- jedno płótno 64 × 104, pivot wypalony offline, `Sprite2D.centered = false`;
- `texture_filter = TEXTURE_FILTER_NEAREST`, `texture_repeat = DISABLED`;
- `scale = 1`, stała pozycja, zero arytmetyki per klatka;
- fallback na `idle`, gdy klatki stanu brakuje (nie crash, nie pusty sprite);
- `_draw()` wyłącznie cień kontaktowy.

### 4.2 Czego `CharacterVisualRig` NIE ma

NPC nie chodzą. To nie jest gra z tłumem. Rig ma **stany prezentacyjne**,
nie lokomocję:

| Stan | Pliki | Zastosowanie |
|---|---|---|
| `idle` | `idle.png` | domyślny, + oddech proceduralny 1 px / 2,6 s |
| `talk` | `talk_0`, `talk_1` | cykl podczas linii dialogowej tej postaci |
| `listen` | `listen.png` | podczas linii Leny |
| `gesture` | `gesture.png` | jednorazowy akcent na konkretnym fakcie |
| `turn_away` | `turn_away.png` | granica, odmowa, koniec rozmowy |
| `seated` | `seated.png` | Szymon, Wierzbicka za biurkiem |
| `work` | `work.png` | czynność zawodowa (Jakub przy panelu, Marta przy torbie) |

Siedem stanów, po jednej lub dwóch klatkach. To jest **cały** zakres.
Rozszerzanie tej listy wymaga decyzji w `DECISION_LOG.md`.

### 4.3 Osadzenie w scenie

- NPC jest węzłem w `Props` danej stacji, nie `prop_type` w monolicie;
- rozmowa jest już obsłużona przez `OpeningActionPoint` + `CRTDialogueBox` —
  używać ich, nie budować drugiego systemu dialogu;
- portret w `CRTPortrait` i sprite w świecie muszą pokazywać **tę samą osobę**;
  to jest sprawdzane wzrokowo przy każdym kadrze M2.

---

## 5. Zakres assetów do wygenerowania

### 5.1 Portrety (`assets/characters/portraits/`, 1024 × 1024, alfa)

| Plik | Akcja |
|---|---|
| `marta.png` | **REGENERACJA OD ZERA** wg §2.2 |
| `lena.png` | bez zmian |
| `jakub.png` | bez zmian |
| `wierzbicka.png` | przegląd; regeneracja tylko jeśli inspekcja wykaże ten sam defekt co u Marty |
| `szymon.png` | przegląd; jw. |

Przed decyzją o regeneracji Wierzbickiej i Szymona uruchom
`gen-ai describe` na obu plikach i porównaj z `lena.png` — jeśli opis wskazuje
tę samą twarz, plik jest przeróbką i idzie do regeneracji.

### 5.2 Sprite'y NPC (`assets/characters/<imię>/`, 64 × 104, alfa)

> **Zakres po PKG-0186:** Marta, Jakub, Wierzbicka, sprzedawca (06) i sąsiadka
> (08) mają ciało w języku Leny 4.1. Szymon pozostaje poza ciałem na trasie
> (D-194 wariant C); portret CRT Szymona jest zunifikowany.

**Stan faktyczny trasy 20 adresów, zmierzony 2026-09-02:** jedyną osobą fizycznie
obecną jest sylwetka Marty w drzwiach w finałach 42B/42C
(`EPILOGUE_MARTA_DOORSTEP`, `prop_type = 198`). Jakub i Wierzbicka nie pojawiają
się ani wizualnie, ani w dialogu. `JAKUB_SERVICE_OPERATOR` (122) siedzi tylko
w `station_27`, `MARTA_WITNESS_STATION` (188) tylko w `station_40` — obie stacje
wypadają przy cutoverze. `WIERZBICKA_DESK` (77) i `SZYMON_BERA` (87) nie są
używane przez żadną scenę.

Zakres na postać: 7 stanów, 9 plików (`talk` ma dwie klatki, reszta po jednej).

| Wariant DEF-9 | Kogo generujemy | Liczba plików | Status |
|---|---|---:|---|
| A — trasa bezosobowa | Marta (sylwetka progowa 42B/C) | ~3 | odrzucony |
| **B — WYBRANY** | **Marta (10 + finały), Jakub (12), Wierzbicka (11)** | **~27** | **obowiązuje** |
| C — pełna obsada | + Szymon, sprzedawca, sąsiadka | ~40+ | odrzucony w tej fazie |

Priorytet przy cięciu zakresu wewnątrz wariantu B:

1. **Marta** — najbardziej widoczna, ma najwięcej scen i jest przedmiotem
   osobnego zgłoszenia właściciela.
2. **Jakub** — adres 12 („Jakub jako żywa osoba i technik” wg planu §4).
3. **Wierzbicka** — adres 11 (rodzina instytucjonalna).
4. ~~Szymon~~ — **poza zakresem** (wariant C, odrzucony w tej fazie).

### 5.3 Nowe klatki Leny (DEF-5 i DEF-6 — **WDROŻONE PKG-0173**)

| Stan | Pliki | Opis |
|---|---|---|
| `step_up` | `step_up_0`, `step_up_1` | noga w górę na stopień → przeniesienie ciężaru. Bez przysiadu. |
| `step_down` | `step_down_0` | zejście ze stopnia, kontrolowane, bez lądowania |
| `climb_back` | `climb_back_0..3` | **widok od tyłu**, cykl czterech szczebli |
| `ladder_mount` | `ladder_mount.png` | obrót bokiem → chwyt szczebla, przejście z profilu na plecy |
| `ladder_dismount` | `ladder_dismount.png` | zejście z drabiny na podest |
| `enter_door` | `enter_door_0..2` | ręka na klamce → pchnięcie → wejście w otwór (DEF-4) |
| `board_vehicle` | `board_vehicle_0..1` | krok w górę na stopień pojazdu, chwyt poręczy (DEF-4) |

Wszystkie na tym samym płótnie 64 × 104 z pivotem (32, 96).

---

## 6. Pipeline `gen-ai` — konkretne kroki

Stan narzędzia zweryfikowany 2026-09-02: CLI 2.69.0, **1358 kredytów**.

### 6.1 Przed generacją

```bash
gen-ai credits
gen-ai pricing
```

Jeśli saldo spadnie poniżej **300 kredytów**, zatrzymaj się i zgłoś to
właścicielowi zamiast dokańczać zakres.

### 6.2 Portret Marty — sekwencja

1. **Nie** używaj `lena.png` jako obrazu wejściowego. Nigdy.
2. Wygeneruj bazę tożsamości jednym wywołaniem tekstowym na modelu wysokiej
   jakości (`gemini-3-pro-image` albo `seedream-5.0-pro`), z pełną kartą z §2.2
   plus wymogami stylu z `VISUAL_DESIGN.md` §7 (zakaz szumu, zakaz miękkich
   krawędzi, zakaz neonu, zakaz pseudo-liter).
3. Porównaj kandydatów: `gen-ai compare` na 2–3 modelach, jeden prompt.
4. Wybraną bazę **zapisz jako referencję tożsamości** i od tej pory każdą
   kolejną grafikę Marty rób przez `gen-ai character` albo `flux-kontext-pro`
   z tym obrazem na wejściu.
5. `gen-ai remove-bg`, potem normalizacja offline do 1024 × 1024 z alfą.
6. Ręczna korekta sylwetki, palety i siatki piksela — `VISUAL_DESIGN.md` §7
   ostatni punkt. Surowy output modelu **nie jest kanonem**.

### 6.3 Sprite'y — sekwencja

1. Referencja tożsamości = portret z §6.2 (dla Marty) albo istniejący portret
   (dla Jakuba, Wierzbickiej).
2. **Jedna poza = jedno wywołanie.** Zakaz arkuszy model-sheet (D-122).
3. Model z kontekstem obrazu: `flux-kontext-pro` / `flux-kontext-max` /
   `gen-ai character`. Dla ujęcia tylnego (`climb_back`, `turn_away`)
   rozważ `picsart-qwen-image-edit-angle`.
4. `gen-ai remove-bg` na każdej klatce.
5. Normalizacja **offline i deterministyczna** skryptem `tools/process_cast_sprites.py`
   (NEAREST, płótno 64 × 104, pivot (32, 96)). `tools/process_npc_sprites.py`
   (LANCZOS + fałszywe stany) jest w `tools/retired/` i jest zakazany.
6. Import Godot: nearest, bez filtrowania, bez mipmap.

### 6.4 Higiena katalogu

- surowe outputy → `assets/characters/<imię>/raw/` z `.gdignore`;
- klatki produkcyjne → `assets/characters/<imię>/`;
- odrzuty **nie** zostają w katalogu produkcyjnym;
- `docs/LICENSES.md` dostaje wpis o pochodzeniu każdej nowej grafiki.

---

## 7. Kryteria odrzutu (obowiązkowe)

Odrzuć klatkę i powtórz, jeśli zachodzi którekolwiek:

1. **Tożsamość dryfuje** — to nie jest ta sama osoba co na klatce poprzedniej.
2. **Photoreal, malarska lalka albo krasnoludek** (głowa > 1/5,5 wzrostu; krótke nogi). Sukienka Marty w kolorze włosów.
3. **Chibi / krasnoludek** — głowa większa niż 1/5,5 wzrostu.
4. **Marta wygląda jak Lena w peruce.** Twarz ma być inna, nie przemalowana.
5. **Losowe napisy, pseudo-litery, symbole** wygenerowane w grafice.
6. **Neon** jako domyślny sygnał science-fiction.
7. **Niespójne światło** względem sąsiednich klatek tej samej postaci.
8. **Poza bez masy** — postać nie stoi, tylko pozuje.
9. **Podobieństwo do rozpoznawalnego kadru z gry referencyjnej**
   (`INSPIRATION_BOUNDARIES.md`).

Po **dwóch** odrzutach tej samej pozy zmień model, nie prompt.
Po czterech — zatrzymaj się i zapytaj właściciela.

---

## 8. Czego ten dokument nie rozstrzyga

- Nie dowodzi, że nowa Marta „wygląda dobrze”. To jest ocena właściciela.
- Nie przesądza, czy Szymon zostaje na trasie po cutoverze — decyduje
  `CAMPAIGN_MAP.md` §4.
- Nie zmienia treści relacji ani dialogów. Zmienia wyłącznie to, jak osoby
  wyglądają i jak są zbudowane technicznie.
