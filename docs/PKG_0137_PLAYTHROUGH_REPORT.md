# PKG-0137 — sterowany playthrough 01→43 po zmianie kadru dialogowego

Status: **2026-08-29, wykonany na runtime.**
Metoda: `tools/pkg_0137_playthrough_audit.gd` instancjonuje każdą z 45 scen
kampanii, otwiera panel dialogowy, mierzy kadr i etykiety, przeprowadza Lenę
przez całą podłogę sterowanym ruchem, a następnie wchodzi w `AirlockZone`
i wraca do `ReturnZone`. Renderowane dowody: `tools/capture_pkg_0137.gd`
(Windows/OpenGL, Intel Iris Xe — headless nie ma urządzenia renderującego).

Zakres kontrolowany na stację:

1. offset kadru nie odsłania pustki pod planem gry,
2. etykiety `CrispDiegeticText` nie wjeżdżają na panel dialogowy ani na Lenę,
3. `AirlockZone` otwiera się po spełnieniu warunku,
4. `ReturnZone` cofa, a nie kończy poziom (02–43),
5. cykl chodu nie ślizga się na pochyłościach i schodkach 18 px.

## 1. Wynik wejściowy: 103 blokery na 45 scenach

Pierwszy przebieg — przed jakąkolwiek naprawą:

| Kategoria | Liczba stacji | Charakter |
|---|---:|---|
| Kadr odsłania pustkę | **45 / 45** | regresja D-133, cała kampania |
| Poślizg stóp na pochyłości | 7 | 02, 07, 09, 11, 25, 33, 34 |
| Etykieta na sylwetce aktora | 1 | 08 |
| Cofanie fizycznie niemożliwe | 3 | 07, 09 (biegi schodów), 13 (szuflada) |

Pozostałe pozycje pierwszego przebiegu okazały się artefaktami narzędzia
(budżet klatek marszu, stacja zwalniana przez `queue_free()` żyjąca jeszcze
w drzewie przy następnej instancji, wejście do strefy śluzy, w której aktor
już stał, automatyczne przejście kampanii podmieniające scenę w trakcie pomiaru).
Zostały naprawione w narzędziu, nie w grze, i są wyliczone w §8.

## 2. B-1 — kadr dialogowy odsłaniał pustkę na wszystkich 45 stacjach

`CinematicCamera` nakłada `dialogue_framing_offset = 36` **po** klampie komory
(D-133, świadomie). Wszystkie komory kampanii mają dokładnie 640x360, więc
klamp pionowy zapada się do środka (`min_y == max_y == 180`), a offset zjeżdża
z kamerą na y = 216. Kadr obejmuje wtedy świat y 36..396, a `VectorStageEnvironment`
maluje tylko do `world_size.y = 360`.

Pomiar przed naprawą (`reports/pkg_0137_before_apron_*.png`):

```
station_01 cam_y=216.0  y=300 #0c1218, y=320 #0c1218, y=330 #0b1016,
                        y=340 #07090c, y=350 #07090c, y=358 #07090c
```

`#07090c` to `environment/defaults/default_clear_color` z `project.godot`.
Dolne 36 px każdego kadru dialogowego było surowym tłem silnika.

**Naprawa (D-136).** Scena dostaje malowany fartuch, a kamera budżet:

- `VectorStageStyle.STAGE_APRON = 40` i `draw_stage_apron()` — przedłużenie
  planu podłogi pod linią gry, rysowane jako pierwsze, więc kompozycje stacji
  malują nad nim bez zmian. Nogi proscenium sięgają teraz dna fartucha.
- `CinematicCamera.get_framing_budget(focus_y)` zwraca `rect.end.y + stage_apron
  − dolna krawędź kadru`. Offset dialogowy jest klampowany do tego budżetu, więc
  żadna stacja nie może zostać skadrowana na pustkę — niezależnie od tego, jaką
  wartość ktoś wpisze w `dialogue_framing_offset`.

Fartuch to scenografia: nie ma tam żadnego collidera i nie zmienia trawersalu.

Pomiar po naprawie (`reports/pkg_0137_capture_report.txt`, 8 stacji, po 40
dolnych wierszy na kadr, próbkowane w 5 kolumnach):

```
station_01  cam_y=216  bottom 40 rows sampled, 0 read as clear colour -> painted
...
station_43  cam_y=216  bottom 40 rows sampled, 0 read as clear colour -> painted
```

## 3. B-2 — cykl chodu ślizgał się na pochyłościach i schodkach

D-130 napędzał fazę cyklu przez `|velocity.x| * delta / STRIDE`. To dystans
**zamierzony**, nie pokonany. `move_and_slide()` odchyla ruch na pochyłości,
a `try_curb_step()` podnosi ciało na krawężniku, więc na każdej stacji
z profilem innym niż płaski stopa kontaktowa wyprzedzała podłoże.

Zmierzony dryf na przebiegu ~480 px:

| Stacja | Poślizg przed | Poślizg po |
|---|---:|---:|
| 09 | 38,9 px | 0,0 px |
| 07 | 23,0 px | 0,0 px |
| 11 | 16,2 px | 0,0 px |
| 13 (płaska, kontrola) | 0,0 px | 0,0 px |

**Naprawa (D-137).** `LenaVisualRig._sample_travel()` próbkuje własną pozycję
światową rigu i podaje faktycznie pokonany dystans; skok większy niż jeden pełny
krok biegu jest traktowany jako teleport (spawn, wczytanie sceny, przypięcie do
drabiny) i wraca do wartości z prędkości, żeby nie rozkręcić cyklu.

## 4. B-3 — cofanie fizycznie niemożliwe na stacjach 07 i 09

`Geometry/ConcreteStairFlight` (07) i `Geometry/StairFlight` (09) były
trójkątami: `PackedVector2Array(0, 0, 120, −60, 120, 0)`. Od zachodu to rampa
26°, po której Lena wchodzi; od wschodu — pionowa ściana 46–60 px. Idąc na
wschód wchodziła po skosie i spadała z krawędzi na podłogę. Idąc z powrotem
zatrzymywała się pod ścianą na zawsze:

```
station_07  return STALLED at x=488.0  ray dy=+0: ConcreteStairFlight at (480.0, 269.0)
station_09  return STALLED at x=518.0  ray dy=+0: StairFlight        at (510.0, 269.0)
```

To łamało D-132 i D-124 na dwóch stacjach ciągu 02–43.

**Naprawa.** Oba collidery mają teraz realny bieg schodów po stronie wschodniej,
z podstopnicami ≤ 18 px, czyli dokładnie w kontrakcie `MAX_CURB_STEP` (D-123):

- 07: `(0,0) (120,−60) (140,−60) (140,−45) (160,−45) (160,−30) (180,−30) (180,−14) (200,−14) (200,0)`
- 09: `(0,0) (110,−52) (130,−52) (130,−35) (150,−35) (150,−18) (170,−18) (170,0)`

To jedyne dwa `CollisionPolygon2D` w całej kampanii; reszta geometrii to
prostokąty, więc wzorzec nie powtarza się nigdzie indziej.

## 5. B-4 — etykieta na sylwetce aktora, stacja 08

`CrispDiegeticText_Certificate` stała na y=192 i z panelem 21 px sięgała do 213,
czyli 4 px w linię głowy Leny (grunt 296 − 87 = 209). Etykieta przesunięta na
y=172. Pozostałe 64 etykiety kampanii mieszczą się w paśmie i przechodzą bramkę.

## 6. B-5 — wysunięta szuflada dzieliła salę 13 na pół

`Geometry/DeskDrawer` miał collider 46x34 wystający 29 px nad podłogę, czyli
powyżej `MAX_CURB_STEP` (D-123). Po otwarciu szuflady Lena szła do śluzy, a
wracając zatrzymywała się na biurku:

```
station_13  return STALLED at x=347.0  ray dy=+0: DeskDrawer at (339.0, 269.0)
```

Mebel po cichu pełnił rolę bramy, której nikt nie zaprojektował: jedynym
wyjściem był powrót do uchwytu i zamknięcie szuflady. Collider ma teraz 46x18
z przesunięciem `(0, 5)` — górna krawędź 16 px nad podłogą, więc `try_curb_step`
przenosi Lenę nad wysuniętą szufladą (D-140). Rysowanie i odczyt diegetyczny
bez zmian. Audyt i bramka celowo zostawiają szufladę **otwartą**: to gorszy
przypadek i ten wart przejścia.

## 7. Wynik końcowy

Pełna tabela per stacja: `reports/pkg_0137_playthrough_run.txt`.
Dane maszynowe: `reports/pkg_0137_playthrough_audit.json`.

Wszystkie 45 scen: kadr w malowanej scenografii, etykiety poza panelem i poza
aktorem, `AirlockZone` otwiera do przodu, `ReturnZone` cofa na 02–43,
poślizg cyklu 0,0 px, najwyższy pokonany schodek 18 px.

## 8. Czego ten przebieg nie dowodzi

- Nie dowodzi zabawy ani czytelności dramaturgicznej (ADR-003). Sprawdza kadr,
  etykiety, wyjścia i lokomocję.
- Warunki fabularne są w audycie spełniane przez ustawienie flag stacji
  i zakotwiczenie `AnchorableObject`, a nie przez przejście dialogów. Bramka
  sprawdza mechanizm wyjścia, nie kolejność scen — od tego są `pkg_0118`–`pkg_0123`.
- Pomiar kolorów wykonany na Windows/OpenGL, Intel Iris Xe. AMD, NVIDIA
  i Steam Deck pozostają niepotwierdzone (H-027).

Artefakty narzędzia, naprawione w narzędziu i warte zapamiętania przy pisaniu
następnego audytu:

- `queue_free()` plus jedna klatka nie zwalnia stacji; poprzednia scena zostaje
  w drzewie i podstawia swoje collidery następnej. `remove_child()` + `free()`.
- `campaign_auto_transition_enabled` domyślnie `true`: `level_completed`
  podmienia scenę w trakcie pomiaru i dostawia do drzewa drugiego gracza.
- Wejście do strefy, w której aktor już stoi, nie generuje `body_entered`.
- Budżet klatek marszu musi pokrywać powrót przez całą salę, nie tylko dojście.
- Zakotwiczenie `AnchorableObject` to czasownik gracza, nie flaga: sama
  `is_rescue_tether_anchored` nie otwiera stacji 38.

## 9. Dowody

- `reports/pkg_0137_playthrough_run.txt` — przebieg per stacja.
- `reports/pkg_0137_playthrough_audit.json` — dane maszynowe.
- `reports/pkg_0137_capture_report.txt` — pomiar dolnych 40 wierszy kadru.
- `reports/pkg_0137_before_apron_station_{01,24,33}.png` — kadr przed fartuchem.
- `reports/pkg_0137_station_{01,08,16,24,31,37,41,43}_framed.png` — kadr po.
- `tests/pkg_0137_smoke_test.gd` — bramka egzekwująca wszystkie naprawy.

## 10. Jak powtórzyć

```
:: pełny przebieg (headless, ~20 min)
Godot_v4.6.3-stable_win64_console.exe --headless --path . ^
  --script res://tools/pkg_0137_playthrough_audit.gd

:: jedna stacja
Godot_v4.6.3-stable_win64_console.exe --headless --path . ^
  --script res://tools/pkg_0137_playthrough_audit.gd -- station_13

:: dlaczego stacja nie pozwala wrócić (nazywa collider na drodze)
Godot_v4.6.3-stable_win64_console.exe --headless --path . ^
  --script res://tools/pkg_0137_backtrack_probe.gd -- station_09

:: rendery dowodowe — BEZ --headless, potrzebne urządzenie renderujące
Godot_v4.6.3-stable_win64_console.exe --path . ^
  --script res://tools/capture_pkg_0137.gd
```
