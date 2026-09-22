# Getting Strange — kanon skali świata

Status: **KANON PRODUKCYJNY 1.0 — PKG-0131 (D-126)**
Data: 2026-08-25
Zakres: każda figura, mebel, drzwi, schodek, krawężnik i bryła rysowana
w 43 stacjach kampanii. Dokument jest nadrzędny wobec każdego `_draw()`
rekwizytu i każdej nowej geometrii.

Ten dokument czyta **każdy model, zanim narysuje albo przeskaluje
jakikolwiek obiekt inny niż podłoga i ściany.**

---

## 1. Zasada nadrzędna

> **Lena jest linijką.**
> Krzesło nie może być wielkości człowieka. Drzwi nie mogą być
> budką dla krasnoludka. Jeśli obiekt wygląda źle obok stojącej Leny,
> winny jest obiekt albo skala Leny — nigdy „styl”.

Właściciel (2026-08-25) nazwał obecną postać krasnoludkiem i meble
niewspółmiernymi. To jest **prawda runtime**, nie hipoteza odbiorcza.
H-017 (sylwetka 3.0) i D-117 (66 px) nie zamykają tematu.

---

## 2. Jednostka

| Wielkość | Wartość | Uwaga |
|---|---|---|
| Viewport logiczny | 640 × 360 | bez zmian (D-005) |
| Kompozytor świata | 320 × 180 | nearest, 2 px komórka |
| **1 metr** | **52 logical px** | w przestrzeni 640 × 360 |
| Lena stojąca (36 lat, ~168 cm) | **87 ± 3 px** od stopy do czubka włosów | nie collider |
| Collider Leny | kapsuła **wys. 72, promień 8** | fizyka, nie rysunek |
| Maksymalny schodek do wejścia bez drabiny | **18 px** (~35 cm, krawężnik / stopień) | D-123 |
| Skok nie jest lokomocją | zakaz używania skoku, by wejść na ścianę, blat, dach, parapet wyższy niż 18 px | D-123 |

Collider może być niższy niż sylwetka (luz nad głową, fryzura), ale
**nie może być wyższy**. Stopa wizualna i dół kapsuły muszą się zgadzać
co do krawędzi podłogi (max 2 px różnicy).

---

## 3. Katalog proporcji względem Leny

Wszystkie wartości w logical px (640 × 360). `H` = wysokość wizualna Leny
= 87 px.

| Obiekt | Wysokość | Szerokość | Uzasadnienie |
|---|---:|---:|---|
| Lena stojąca | 87 | 22–28 w barkach | dorosła kobieta, nie chibi |
| Lena siedząca | 58 | — | biodra na siedzisku |
| Głowa Leny | 13–15 | 11–13 | ~1:6.5, nie 1:4 |
| Krzesło — siedzisko od podłogi | 23 | 18–22 | 0.45 m |
| Krzesło — oparcie (całość) | 42–46 | 18–22 | nie wyższe niż klatka Leny |
| Stół / biurko | 39 | dowolna | 0.75 m |
| Blat kuchenny | 47 | — | 0.90 m |
| Łóżko (rama + materac) | 26 | — | |
| Drzwi mieszkaniowe | 109 | 42–48 | 2.10 × 0.85 m |
| Drzwi techniczne / śluza | 109–120 | 48–60 | |
| Poręcz | 52 | — | 1.00 m do dłoni |
| Stopień schodów | 9 pion / 14–16 bieg | — | 17 cm |
| Krawężnik | 8–12 | — | wejście bez skoku |
| Okno parapet | 47–52 | — | |
| Latarnia uliczna | 200–230 | — | 4 m |
| Tramwaj / autobus (wys. pudła) | 160–180 | — | |
| Postać tła (Marta, Jakub, Wierzbicka) | 84–92 | jak Lena | ten sam metr |

Zakaz: mebel, którego najwyższy czytelny kant jest ≥ 0.85 × H, chyba że
jest szafą, drzwiami albo ścianą.

---

## 4. Test dwóch klatek (obowiązkowy)

Zanim zamkniesz stację po zmianie skali, zrób dwa capture'y
`tools/capture_preview.gd` (normalny sterownik Windows):

1. **Lena obok krzesła / stołu / drzwi** tej stacji.
2. **Lena w pełnej sylwetce na tle podłogi i ściany**, bez UI.

Odrzuć kadr, gdy zachodzi którekolwiek:

- siedzisko krzesła jest na wysokości bioder stojącej Leny albo wyżej;
- blat stołu jest na wysokości mostka albo wyżej;
- drzwi są niższe niż wyciągnięta ręka Leny;
- Lena zajmuje mniej niż 1/5 wysokości kadru 360, gdy stoi na podłodze
  w kadrze 1:1 (640 × 360 bez zoomu);
- Lena wygląda jak dziecko albo krasnoludek obok mebla.

Capture nie dowodzi piękna. Dowodzi wyłącznie, że proporcje spełniają
tabelę z rozdziału 3.

---

## 5. Co wolno, czego nie

Wolno:

- zmniejszyć rysunek mebla w `_draw()` bez ruszania collidera, jeśli
  collider i tak nie blokuje drogi;
- przesunąć collider mebla, żeby pasował do nowego rysunku;
- podnieść visual Leny do 87 px i collider do 72, **raz**, w
  `prototype_player.tscn` + `LenaVisualRig`;
- użyć `gen-ai` / Picsart do sprite'ów Leny i wybranych rekwizytów.

Nie wolno:

- skalować całej sceny przez `scale` na rootcie;
- zostawić krzesła-olbrzyma „bo tak było w Vector-Stage”;
- rosnąć Leny powyżej 96 px (wychodzi z kadru kompozytora i psuje
  drzwi 109 px);
- zmienić 640 × 360 ani 60 Hz.

---

## 6. Audyt 43 stacji

PKG-0132 wypełnia `docs/PLAYTHROUGH_TRAVERSAL_AUDIT.md` tabelą:

`stacja | mebel-olbrzym (tak/nie) | schodek > 18 px bez drabiny | wyjście w lewo | status`.

Stacja nie jest `PASS`, dopóki trzy kolumny nie są czyste.
Ten audyt nie jest dowodem zabawy (ADR-003).
