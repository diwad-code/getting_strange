# Specyfikacja zimnego otwarcia (cold open)

Status: **AKTYWNY KONTRAKT OTWARCIA — D-193**
Data: 2026-09-02
Nadrzędne: `docs/rebuild/PRESENTATION_REPAIR_PLAN.md` (DEF-1)
Podrzędne wobec: `docs/rebuild/PLAYER_CONTRACT.md` §3 i §6 (co gracz ma i czego
nie ma prawa wiedzieć), `VISUAL_DESIGN.md`, `docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md`

---

## 1. Problem

Właściciel: *„Gracz rozpoczyna w absolutnej niewiedzy co się dzieje, nie wie
czym Lena się zajmuje, czym są drgania.”*

Dziś `Nowa gra` wchodzi wprost w Station 01. Pierwsza linia dialogowa pojawia
się dopiero po tym, jak gracz sam zgadnie, w co kliknąć. `PLAYER_CONTRACT.md`
§3 wymaga pięciu faktów po minucie; runtime dostarcza je **dopiero jako nagrodę
za odgadnięcie interakcji**, więc dla człowieka nie istnieją.

---

## 2. Rozwiązanie — dwie warstwy, obie w silniku

Żadnego wideo, żadnego pliku filmowego, żadnego ekranu z akapitem tekstu.
Wszystko powstaje z tego, co runtime już umie: `CinematicCamera`,
`LenaVisualRig`, `CRTDialogueBox`, `CrispDiegeticText`, `ProceduralAudio`.

| Warstwa | Charakter | Czas | Sterowanie |
|---|---|---|---|
| **A — Ustawienie** | sekwencja kamery, bez sterowania | 12–16 s | pomijalna po pierwszym przejściu |
| **B — Zimne otwarcie** | grywalne, jedna wymuszona czynność | 40–60 s | pełne |

Razem: gracz ma komplet pięciu faktów z `PLAYER_CONTRACT.md` §3 **zanim**
dojdzie do wyboru „powtórka albo obietnica” w Station 01.

---

## 3. Warstwa A — sekwencja ustawiająca

Trzy ujęcia, jedno cięcie między nimi, zero tekstu ekspozycyjnego.

### Ujęcie 1 — świat (5–6 s)

Nocne torowisko Linii 4. Kamera nisko, statyczna. Z lewej wjeżdża i przejeżdża
tramwaj — **maszyna pracuje bez gracza** (`TRAVERSAL_AND_OBSTACLE_DESIGN.md` §2.4).
Dźwięk: koła, zwrotnica, przewód. Po przejeździe zostaje cisza i jedna lampa.

Co to ustanawia: to jest miasto, noc, koniec zmiany, jeździ tu tramwaj.

### Ujęcie 2 — praca (4–5 s)

Zbliżenie na szynę: przymocowany czujnik, kabel, dłonie Leny w rękawicach
poprawiające mocowanie. Kamera na wysokości rąk. Lena w kadrze tylko od pasa
w dół i barków — **twarz jeszcze nie**.

Co to ustanawia: ktoś tu pracuje rękami, ma narzędzie i procedurę.

### Ujęcie 3 — luka (4–5 s)

Ekran przyrządu wypełnia kadr. Na nim rysuje się **na żywo** przebieg drgań:
szum tła → gwałtowny wzrost przy przejeździe → wygaszenie. Potem wykres
przewija się do zapisu archiwalnego i w tym samym miejscu jest **płaska,
prosta linia o długości trzech sekund**, otoczona normalnym szumem z obu stron.

Wykres jest rysowany proceduralnie w kadrze, nie jest teksturą.
Etykiety wyłącznie diegetyczne, w warstwie `CrispDiegeticText`:
`LINIA 4`, oś czasu, znacznik `−03,0 s`.

Co to ustanawia: **to są drgania, to jest ich zapis, a tu jest dziura**.
To jest jedyne miejsce w grze, gdzie gracz uczy się, czym jest luka — a cała
kampania jest o niej.

### Po ujęciu 3

Cięcie na plan gry Station 01, kamera wraca do kontraktu stacji, sterowanie
wraca do gracza. Bez ekranu ładowania, bez napisu „Rozdział 1”.

### Reguły warstwy A

- **Pomijalna** dowolnym przyciskiem po pierwszym ukończeniu (flaga w
  `GameStateManager`). Za pierwszym razem nie.
- **Reduced motion** (`MotionAccessibility`, D-151): ruch kamery zastąpiony
  cięciami, przejazd tramwaju skrócony; treść ujęć bez zmian.
- **Bez muzyki.** Projekt nie ma ścieżki muzycznej i nie zaczyna jej tutaj.
  Dźwięk jest proceduralny i diegetyczny.
- Budżet klatki jak wszędzie: 60 Hz, 640 × 360.

---

## 4. Warstwa B — zimne otwarcie (grywalne)

Dzieje się w Station 01, **przed** udostępnieniem wyboru
`repeat_sample` / `leave_on_time`.

### 4.1 Sekwencja

| Krok | Co robi gracz | Czego się uczy |
|---|---|---|
| 1 | Idzie 40–60 px do stanowiska. Nic więcej nie działa. | ruch, kierunek „w prawo”, skala ciała wobec sprzętu |
| 2 | `interact` przy rejestratorze — jedyna dostępna czynność | czasownik `interact`, prompt |
| 3 | Ogląda, jak przyrząd robi jeden przebieg pomiaru w czasie rzeczywistym (3–4 s), z narastającym i opadającym wykresem | co znaczy „pomiar”; że maszyna ma własny czas |
| 4 | Widzi wynik: ta sama trzysekundowa luka co w ujęciu 3 | rozbieżność jest **obserwowana**, nie zapowiedziana |
| 5 | Lena reaguje jedną linią (`CRTDialogueBox`) | głos, ton, kim jest |
| 6 | Przyrząd wyświetla wiadomość od Marty — na tym samym ekranie, w tej samej warstwie diegetycznej | ktoś czeka, ma imię i godzinę |
| 7 | Dopiero teraz otwierają się dwie drogi Station 01 | wybór ma stawkę, bo obie strony są znane |

### 4.2 Nośniki pięciu wymaganych faktów

Tabela odpowiada jeden do jednego kolumnie „Musi wynikać z” w
`PLAYER_CONTRACT.md` §3.

| Fakt | Nośnik w zimnym otwarciu | Zakaz |
|---|---|---|
| jestem kobietą przy pracy technicznej | sylwetka 87 px w kombinezonie, dłonie na sprzęcie (ujęcie 2), stanowisko, dźwięk hali | zdanie „jesteś diagnostyczką” |
| to jest miejsce pracy, nie laboratorium fabuły | tramwaj przejeżdżający bez udziału gracza, kabel, mocowanie, ślady zmiany | etykieta z nazwą instytucji |
| mam narzędzie i procedurę | jedna wykonalna czynność: uruchom pomiar | ekran samouczka, lista klawiszy |
| coś jest nie tak z pomiarem | wykres na żywo vs zapis archiwalny w jednym kadrze | myśl „to dziwne” przed obserwacją |
| ktoś na mnie czeka | wiadomość Marty z imieniem i godziną na ekranie przyrządu | ekspozycja o historii ich relacji |

### 4.3 Słowo „drgania”

Gracz ma zrozumieć pojęcie **z obrazu**, nie z definicji. Kolejność jest
obowiązkowa:

1. tramwaj przejeżdża (przyczyna),
2. wykres skacze (skutek widoczny),
3. wykres wraca do szumu (stan spoczynku),
4. archiwum pokazuje w tym samym miejscu płaską linię (anomalia).

Dopiero po tym Lena wolno użyje słowa „drgania” w linii dialogowej. Jeśli padnie
wcześniej, jest to definicja, a nie doświadczenie — i bramka jest niezaliczona.

### 4.4 Ton i długość dialogu

Maksymalnie **cztery linie** w całym zimnym otwarciu. Żadna nie tłumaczy
graczowi mechaniki. Wzorzec istniejących linii Station 01 jest dobry:
*„Mocowanie jest czyste. Zapis dalej gubi trzy sekundy.”* — konkret zawodowy,
zero ekspozycji.

Wiadomość Marty ma być **krótka i domowa**, z imieniem i godziną.
`DIALOGUE_SCRIPT.md` obowiązuje bez zmian.

---

## 5. Czego zimne otwarcie nie wolno ujawnić

`PLAYER_CONTRACT.md` §3, twarda lista:

- że istnieje inny świat,
- **że Jakub żyje**,
- czym jest Anchor/Yield,
- czym naprawdę jest UCP.

Dodatkowo — nie ujawniać jeszcze, że katastrofa Linii 4 dotyczyła brata Leny.
Ślad katastrofy jest zaplanowany na Station 04, „bez wykładu”
(`PLAYER_CONTRACT.md` §4). Zimne otwarcie ustanawia **zawód i lukę**, nie motyw.

---

## 6. Ekran tytułowy — drobna korekta

`scripts/ui/title_screen.gd` ma już `TITLE_PERSONAL_PROMISE`
(„Marta czeka na Lenę. Trzy sekundy z Linii 4 nie chcą zniknąć.”). To zostaje.

Zmiana jedna: `Nowa gra` prowadzi do warstwy A, nie wprost do Station 01.
`Kontynuuj` pomija warstwę A.

**Zakaz:** ekran tytułowy nie jest miejscem na wyjaśnianie fabuły ani
sterowania. `PLAYER_CONTRACT.md` §6 i decyzja PKG-0159 (usunięcie listy
sterowania z pierwszego kadru) obowiązują.

---

## 7. Gdzie to mieszka technicznie

Rekomendacja **potwierdzona wdrożeniem w PKG-0176** (D-195):

- Warstwa A: osobna scena `scenes/shell/cold_open.tscn` + `scripts/ui/cold_open.gd`.
  **Nie jest adresem kampanii** — nie wchodzi do `CAMPAIGN_ROUTE`, nie ma
  `ReturnZone`, nie liczy się do budżetu 20 adresów ani do GATE-INT.
- Warstwa B: rozszerzenie `scripts/levels/station_01.gd` o stan wstępny.
  Nie tworzy nowego adresu i nie zwiększa liczby istotnych interakcji Station 01
  ponad trzy (GATE-INT) — uruchomienie pomiaru jest tą samą interakcją, która
  już istnieje, tylko przeniesioną przed rozwidlenie.
- Zapis: flaga `p9.cold_open.seen` w `GameStateManager`; migracja save'a musi
  przyjąć stary zapis bez tej flagi.

### Co wdrożenie potwierdziło, a co zmieniło (PKG-0176)

| Rekomendacja §7 | Stan w runtime |
|---|---|
| warstwa A jako osobna scena shellu | `scenes/shell/cold_open.tscn` + `scripts/ui/cold_open.gd` (`ColdOpen`) |
| warstwa A nie jest adresem kampanii | nie ma jej w `CAMPAIGN_ROUTE`, w `CAMPAIGN_SELECTOR_STATIONS` ani w budżecie 20 adresów |
| warstwa B jako stan wstępny Station 01 | `Station01.ColdOpenStage`; rejestrator to ta sama `MeasurementRig`, więc GATE-INT nadal 3 |
| flaga pomijalności | **zmiana**: `cold_open_seen` żyje w pliku **ustawień**, nie w zapisie kampanii — `Nowa gra` kasuje zapis kampanii, a raz obejrzana sekwencja pozostaje obejrzana. Migracja starszego pliku bez klucza działa |
| routing `Nowa gra` | **zmiana**: prowadzi `GameStateManager.start_new_game()` → `COLD_OPEN_SCENE`, a nie `scripts/ui/title_screen.gd`. Ekran tytułowy nadal woła tylko `start_new_game()`, więc routing zostaje w jednym miejscu |
| ujęcie 2 | **zmiana (D-197)**: nie jest rysowane w silniku, tylko planszą `assets/cold_open/shot2_rail_hands.png` z `gen-ai character` na referencji istniejącej klatki Leny. Anatomii postaci nie wolno przedłużać prymitywami. Ujęcia 1 i 3 zostają proceduralne, bo muszą się animować |
| dwa nowe moduły poza monolitami | `scripts/campaign/cold_open_facts.gd` (katalog faktów, kolejność §4.3, lint §5) i `scripts/visual/vibration_trace_display.gd` (jeden przebieg dla obu warstw) |

Czasy zmierzone: warstwa A 14,5 s (12,5 s w trybie ograniczonego ruchu),
warstwa B 5,4 s od uruchomienia pomiaru do otwarcia rozwidlenia, całość od
`Nowa gra` do kompletu pięciu faktów **25,0 s** przy budżecie 90 s.

Jedno odstępstwo od §4.1 kroku 1: podejście do stanowiska ma **119 px**, nie
40–60 px. Spawn Leny na `(70, 296)` to zamrożona kompozycja kadru z PKG-0159
i PKG-0175, a kryteria akceptacji nie nazywają dystansu. Koszt: 1,2 s marszu.

Wyjście ze Station 01 jest otwarte od `_ready()` (PKG-0175, D-192), więc gracz
może fizycznie wyjść przed końcem warstwy B. Nie jest to blokowane celowo:
pominięty odczyt otwiera lukę `s01.measurement_unrepeated` w `GapLedger` i Lena
komentuje ją głosem wewnętrznym. Luka zamiast drzwi jest kontraktem projektu.

---

## 8. Bramka GATE-INTRO — jak to udowodnić

| Test | Metoda | Próg |
|---|---|---|
| Od `Nowa gra` do momentu, w którym wszystkie pięć faktów z §4.2 padło w kadrze | M5 | ≤ 90 s |
| Każdy fakt ma nośnik inny niż menu, ekran tekstu i prompt UI | M4 | 5 z 5 |
| Sekwencja pojęcia „drgania” zachowuje kolejność z §4.3 | M4 + M2 | kolejność zachowana |
| Warstwa A pomijalna po pierwszym ukończeniu, niepomijalna za pierwszym razem | M1 | oba przypadki |
| Reduced motion nie usuwa żadnego z pięciu faktów | M1 + M2 | 5 z 5 |
| Zakazane ujawnienia z §5 nie występują | M4 (lint tekstu) | 0 wystąpień |

Bramka **nie** dowodzi, że nowa osoba zrozumiała, kim jest Lena. To hipoteza
odbiorcza i pozostaje bez dowodu (D-012, ADR-003). Dowodzi wyłącznie, że pięć
faktów zostało pokazane, w określonej kolejności, właściwym nośnikiem, w czasie.
