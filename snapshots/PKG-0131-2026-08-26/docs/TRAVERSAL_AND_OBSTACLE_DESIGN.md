# Getting Strange — Kanon przeszkód i poruszania się

Status: **KANON PRODUKCYJNY 1.1 — PKG-0131 (D-123, D-124)**
Data: 2026-08-25
Zakres: każda fizyczna przeszkoda, każdy skok, każde zagrożenie i każda śmierć
w grze Godot 4.7. Dokument jest nadrzędny wobec każdej sceny i każdego pakietu.

Ten dokument czyta **każdy model, zanim doda do sceny jakąkolwiek geometrię
inną niż podłoga i ściany.** Jeżeli nie wiesz, czy Twoja przeszkoda jest
dozwolona — jest niedozwolona, dopóki nie przejdzie testu z rozdziału 3.

---

## 1. Zasada nadrzędna

> **Getting Strange nie jest grą zręcznościową z fabułą w tle.
> Getting Strange jest fabułą, w której ciało bohaterki musi fizycznie
> poradzić sobie z regułą świata.**

Każda przeszkoda musi istnieć **z powodu, który da się opowiedzieć zdaniem
o świecie, a nie zdaniem o poziomie**.

- Dobrze: „Dwie wersje schodów nakładają się, więc trzeba utrzymać jedną
  wystarczająco długo, żeby dziecko zeszło.” (Scena 12)
- Źle: „Tu jest przerwa w podłodze, więc trzeba przeskoczyć.”

Pierwsze zdanie mówi coś o Rówieniu. Drugie mówi tylko, że ktoś projektował
poziom. Drugie zdanie jest w tym projekcie **zakazane**.

---

## 2. Zakazy twarde

Poniższe elementy są **zakazane bezwarunkowo**. Nie ma od nich wyjątku
„tylko w tej jednej scenie”, „tylko w prototypie” ani „tylko tymczasowo”.

### 2.1 Geometria zręcznościowa

- **Platformy poruszające się w górę i w dół (albo lewo-prawo), na które trzeba
  wskoczyć i przeskoczyć na następną.** To jest wzorzec zakazany numer jeden.
- Platformy wiszące w powietrzu bez konstrukcji, która je trzyma.
- Ciągi „wysepek” nad przepaścią; schody z bloków w powietrzu.
- Znikające albo migające platformy, których cykl trzeba wyliczyć.
- Platformy jednokierunkowe (one-way) użyte jako łamigłówka zręcznościowa.
- Skocznie, odbijacze, przyspieszacze, ruchome taśmy jako tor przeszkód.
- Ściany do odbijania się (wall-jump), podwójny skok, dash, szybowanie.
- Huśtawki, liany, haki, wahadła.

### 2.2 Zagrożenia zręcznościowe

- Kolce, ostrza, piły, lawa, kwas, ogień jako dekoracja zagrożenia.
- Cokolwiek, co zabija przez sam dotyk bez wyjaśnienia w świecie.
- Wrogowie patrolujący tam i z powrotem po stałej trasie.
- Pociski lecące w regularnych odstępach, których unika się rytmicznie.
- Pasek zdrowia, serduszka, życia, punkty, combo, licznik wyniku.

### 2.3 Nazewnictwo

Nazwy węzłów `Platform`, `MovingPlatform`, `JumpPad`, `Spike`, `Trap`,
`Enemy`, `Coin`, `PowerUp`, `KillZone` są **zakazane w scenach kampanii**
(`scenes/levels/`). Węzeł nazywa się tym, czym jest w świecie:
`ServiceLadder`, `ArchiveCarriage`, `FloodedSump`, `EvacuationRailing`.

Kontrolę nazw wymusza test `tests/traversal_lint_test.gd`, uruchamiany przez
`tools/verify.ps1`. Złamanie tej reguły **zatrzymuje weryfikację pakietu**.

### 2.4 Co NIE jest zakazane

Zakaz dotyczy **funkcji**, nie ruchu jako takiego. Świat może się poruszać:

- Tramwaj Linii 4 jedzie, bo jest tramwajem i ma rozkład.
- Winda serwisowa jedzie, bo ktoś ją wezwał.
- Wózek archiwum pneumatycznego przesuwa się, bo obsługuje sprawę.
- Śluza basenu filtracyjnego opada, bo trwa cykl technologiczny.

Różnica jest jedna i trzeba ją rozumieć dosłownie:

> Maszyna **wykonuje swoją pracę**, a gracz musi się do tej pracy dostosować.
> Maszyna **nie jest celem skoku, którego jedynym sensem jest wyczucie czasu.**

Test rozstrzygający: **czy ta rzecz robiłaby dokładnie to samo, gdyby gracza
tu nie było?** Jeżeli tak — to infrastruktura i jest dozwolona. Jeżeli
zatrzymuje się, czeka na gracza albo istnieje tylko po to, żeby dało się na nią
wskoczyć — to platforma zręcznościowa i jest zakazana.

---

## 3. Test trzech pytań (obowiązkowy)

Zanim dodasz przeszkodę, odpowiedz pisemnie w nagłówku skryptu sceny:

1. **Dlaczego to tu jest?** — jednym zdaniem o świecie, bez słowa „gracz”.
   Jeżeli zdanie da się napisać tylko ze słowem „gracz”, przeszkoda jest zła.
2. **Czego to wymaga od Leny jako od człowieka?** — wejść wyżej, przenieść
   ciężar, przecisnąć się, utrzymać coś w polu widzenia, zdążyć przed cyklem
   maszyny, podjąć decyzję pod presją. Nie: „wykonać sekwencję skoków”.
3. **Co się dzieje, gdy się nie uda, i dlaczego to boli fabularnie?** —
   patrz rozdział 5. „Gracz umiera i wraca” nie jest odpowiedzią.

Jeżeli którakolwiek odpowiedź jest pusta albo mówi o poziomie zamiast o świecie
— **nie dodawaj tej przeszkody**. Zgłoś to w handoffie zamiast improwizować.

---

## 4. Katalog dozwolonych rodzin przeszkód

To jest zamknięta lista. Nowa rodzina wymaga decyzji w `DECISION_LOG.md`.

### R1. Niezgodność wersji (rdzeń gry)

Ta sama bryła istnieje w dwóch wersjach. Droga istnieje tylko w jednej.
Przełączenie następuje według reguły świata (`#observed-discontinuity`), nie
według timera poziomu.

- Gracz **zakotwicza** jeden obserwowany szczegół, żeby utrzymać wersję A.
- Albo **ulega** i przechodzi wersją B, płacąc biograficznie.
- Wzorzec z fabuły: Scena 12 (nakładające się schody), Scena 14 (rysa w metalu).

**Czym to NIE jest:** to nie jest platforma, która znika i wraca co dwie
sekundy. Przełączenie ma przyczynę, jest czytelne przed próbą i wiąże się
z decyzją, która ma koszt. Gracz nie uczy się rytmu — gracz decyduje,
co utrzymać.

### R2. Próg administracyjny

Przejście otwiera się dla **profilu**, nie dla klucza i nie dla zręczności.
Bramka biometryczna, punkt zgodności, kołowrót, śluza z autoryzacją.

- Rozwiązanie przez Uległość (przyjęcie profilu miejscowej Leny) albo przez
  zakotwiczenie dokumentu lub cudzej wersji zapisu.
- Wzorzec z fabuły: Scena 04 (Bramka), Scena 22 (Uległość).

### R3. Trasa utrzymywana dla kogoś innego

Gracz nie ratuje siebie — utrzymuje przejezdność dla drugiej osoby.
Porażka dotyka **jej**, nie Leny.

- Wzorzec z fabuły: Scena 12 — dziecko na nakładających się schodach.
- To najsilniejsza rodzina emocjonalnie. Używać rzadko, żeby nie spowszedniała.

### R4. Ciężar, przenoszenie, przeciskanie się

Fizyczna praca człowieka w budynku: przesunięcie szafy kartotekowej, wózka
serwisowego, drabiny, kraty; przeciśnięcie się przez wąski szyb; podciągnięcie
się na parapet. Wolno, ciężko, z wysiłkiem widocznym w animacji.

- Runtime ma już `MovableAnchorableProp` (pchanie skrzyń) — używać tego.
- Skok jest tu **ostatecznością**, nie podstawowym czasownikiem.

### R5. Infrastruktura w cyklu

Maszyna pracuje niezależnie od gracza (patrz 2.4). Gracz czyta jej rytm
i się dostosowuje: przejść peronem między kursami, zejść, gdy śluza jest
podniesiona, wjechać windą, którą ktoś właśnie wezwał.

- Cykl musi być **obserwowalny przed próbą** i mieć źródło dźwięku.
- Zakaz: cykl, którego jedyną funkcją jest wymuszenie skoku w oknie czasowym.

### R6. Ograniczona obserwacja

Świat zmienia się poza spojrzeniem. Przeszkodą jest konieczność utrzymania
czegoś w polu widzenia albo poruszania się tak, żeby nie stracić kontaktu
wzrokowego z bryłą, która inaczej „poprawi się” na niekorzyść.

- To rodzina wyłącznie dla Aktu III/IV. Wcześniej gracz nie zna jeszcze reguły.

### R7. Realna architektura pionowa

Drabiny serwisowe, schody, rusztowania, gzymsy, szyby techniczne, kraty.
Wchodzi się tam, bo budynek tak jest zbudowany.

- Każdy element pionowy musi być **umocowany** do konstrukcji na rysunku.
  Nic nie wisi w powietrzu.

---

## 5. Model porażki

Nie ma pasków zdrowia i nie ma żyć.

### 5.1 Korekta (domyślna porażka)

Przestrzeń rozstrzyga się **przeciwko** Lenie. Ekran nie robi „game over”:
scena wraca do ostatniego checkpointu, a świat zapamiętuje koszt — zanika ślad
używania, cichnie fragment nagrania, znika detal, który miał znaczenie.

To jest domyślna porażka dla R1, R2, R3 i R6.

### 5.2 Śmierć fizyczna (rzadka, dozwolona)

Dozwolona wyłącznie tam, gdzie fikcja ją niesie: tramwaj na Linii 4, upadek
z realnej wysokości, maszyneria pod ciśnieniem, zalanie.

Warunki obowiązkowe:

- zagrożenie jest **zapowiedziane obrazem i dźwiękiem, zanim stanie się groźne**;
- gracz ma czas na odczytanie sytuacji — nie ginie od czegoś, czego nie widział;
- śmierć jest **krótka, cicha i bez triumfu**; żadnych efektów, żadnego stingu;
- restart z checkpointu jest natychmiastowy (poniżej 1 s do odzyskania kontroli).

### 5.3 Zakazane formy porażki

- Śmierć od dotknięcia dekoracji.
- Śmierć bez ostrzeżenia, „na pamięć”.
- Powtarzanie długiego odcinka po porażce (checkpoint zawsze bezpośrednio przed
  próbą, nie przed dialogiem).
- Kara za eksplorację.

---

## 6. Budżet trudności

Getting Strange trwa 2–3 godziny i jest grą narracyjną. Trudność jest
**niska–średnia i stała**; nie rośnie „bo trzeba”.

- Żadna pojedyncza próba nie powinna wymagać więcej niż **3–4 podejść** od
  osoby, która zrozumiała regułę.
- Jeżeli próba wymaga precyzji na poziomie klatek — jest źle zaprojektowana.
- Trudność ma pochodzić ze **zrozumienia reguły**, nie z wykonania.
- W jednej przestrzeni występuje **maksymalnie jedna** rodzina przeszkód
  z rozdziału 4. Nie łączymy trzech naraz.
- Nie każda przestrzeń musi mieć przeszkodę. Cisza jest częścią rytmu; scena
  rozmowy ma prawo nie mieć żadnej próby fizycznej.

---

## 7. Kontrakt implementacyjny w Godot 4.7

### 7.1 Czasowniki gracza — zamknięte

`move_left`, `move_right`, `jump`, `interact`, `trigger_correction`,
`restart`, `pause`. **Nie wolno dodawać nowych czasowników ruchu.**
Brak dasha, brak wall-jumpa, brak podwójnego skoku, brak kucania jako akrobacji.

### 7.2 Węzły

- Geometria stała: `StaticBody2D` z nazwą przedmiotu ze świata.
- Infrastruktura w cyklu (R5): `AnimatableBody2D` z nazwą maszyny; ruch sterowany
  własnym cyklem, nigdy pozycją gracza.
- Strefa zagrożenia: `Area2D` o nazwie opisującej rzecz (`TramTrack`,
  `PressureVent`), nigdy `KillZone` w scenach kampanii.
- Każdy skrypt przestrzeni z przeszkodą ma w nagłówku odpowiedzi na trzy
  pytania z rozdziału 3. To jest wymóg, nie sugestia.

### 7.3 Czego nie wolno ruszać

- 640×360 i fizyka 60 Hz.
- Istniejące collidery `Geometry`, zasięgi `Area2D` rekwizytów, `AirlockZone`.
- `VectorStageEnvironment` posiada kadr; przeszkoda jest **grywalną geometrią**
  i musi być czytelna na tle kadru w skali szarości (`VISUAL_DESIGN.md` §11).

### 7.4 Czytelność przeszkody

- Droga przejezdna ma najwyższy kontrast w kadrze.
- Rzecz groźna nigdy nie jest jedynym elementem w kolorze korekty — kolor nie
  może być jedynym nośnikiem stanu (`VISUAL_DESIGN.md` §2).
- Wysokość skoku Leny to stała projektowa. Żadna przeszkoda nie może wymagać skoku dłuższego niż 90% maksymalnego zasięgu profilu A. Skok nie zastępuje drabiny (7.5).
- Wysokość **wejścia bez drabiny** to **18 px** (krawężnik / jeden stopień).
  Próg 35 px z PKG-0129 jest **zbyt wysoki**: to blat, nie schodek.
  Każda ściana, krawędź albo mebel wyższy niż 18 px nad podłogą grywalną
  wymaga `LadderZone` albo `ServiceLift`. Skok nie zastępuje drabiny.

### 7.5 Skok nie jest lokomocją (D-123)

Skok istnieje, żeby zejść z krawężnika, minąć kałużę albo odzyskać
równowagę. **Nie istnieje, żeby poruszać się po mieście.**

Zakazane zastosowania skoku:

- wejście na wyższą kondygnację, dach, parapet, blat, skrzynię;
- pokonanie ściany, której nie da się przejść pieszo;
- „skrót” między piętrami bloku, peronu albo laboratorium.

Jeśli Lena nie wejdzie tam pieszo — stawiasz drabinę serwisową albo
windę. Maszyna musi mieć funkcję świata (R7 / R5). Test trzech pytań
z rozdziału 3 obowiązuje.

### 7.6 Dwukierunkowość jest kontraktem gracza (D-124)

`GameStateManager.get_previous_campaign_station` i
`target_spawn_side` **nie wystarczą**. Każda stacja 02–43 musi mieć
lewą strefę powrotu (`ReturnZone` / `BacktrackAirlock`), która emituje
`previous_level_requested`. Na dysku w chwili D-124 **zero stacji**
ten sygnał deklaruje. To jest błąd, nie brak funkcji silnika.

Stacja 01 nie wraca do tytułu przez lewą krawędź — tytuł zostaje
w pauzie / `Zakończ`.

### 7.7 Skala

Wymiary mebli, drzwi i Leny reguluje `docs/WORLD_SCALE.md`.
Kanon przeszkód nie rozstrzyga, czy krzesło jest za duże — rozstrzyga
tylko, czy da się po nim wejść skokiem (nie wolno).

---

## 8. Czego ten dokument nie rozstrzyga

- Nie dowodzi, że przeszkody są przyjemne — to H-001 i wymaga obserwacji
  człowieka, której ten projekt nie ma (D-012, ADR-003).
- Nie ustala budżetu animacji dla nowych czynności (podciąganie, przeciskanie).
- Nie zamyka listy rodzin — R8 i dalsze wymagają decyzji, nie improwizacji.
- Nie zastępuje `VISUAL_DESIGN.md`; kadr i przeszkoda to dwie różne warstwy.
