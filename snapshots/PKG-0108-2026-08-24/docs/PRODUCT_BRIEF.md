# Product Brief: Getting Strange

Status: zalozenia do walidacji

Kryptonim: Getting Strange

Wersja: 0.1, 2026-08-15

## Obietnica dla gracza

Filmowy puzzle-platformer, w ktorym gracz odkrywa reguly pozornie znajomego
swiata i decyduje, co zachowac z wlasnej rzeczywistosci, a czemu ulec, aby
przetrwac.

## Odbiorca i format

- Gracze 16+ lubiacy Another World, INSIDE, LIMBO i spokojniejsze science
  fiction z narastajacym horrorem.
- Premium single-player na Windows i Linux.
- Docelowo 2-3 godziny, bez otwartego swiata i sztucznego wydluzania.
- Klawiatura i pad; podstawowe opcje dostepnosci od poczatku produkcji.

## Trzy filary

1. **Cialo w kadrze.** Ruch jest responsywny, lecz animacja i inscenizacja
   zachowuja fizyczny ciezar postaci.
2. **Regula zamiast instrukcji.** Kazda przestrzen pozwala zaobserwowac,
   sprawdzic i zastosowac jedna nienaturalna zasade.
3. **Adaptacja ma koszt.** Przetrwanie zmienia relacje bohaterki z jej
   wspomnieniami i wplywa na final bez jawnego paska moralnosci.

## Centralna hipoteza mechaniczna

Gracz moze **zakotwiczyc** jeden obiekt, osobe lub parametr przestrzeni w
wersji zapamietanej przez bohaterke. Zakotwiczenie rozwiazuje problem, ale
wywoluje reakcje systemu korekty. Alternatywa jest **uleglosc**, czyli
zaakceptowanie lokalnej reguly za cene trwalej zmiany bohaterki.

Mechanika ta nie wchodzi do Prototype 01. Najpierw ruch musi byc przyjemny bez
wsparcia fabuly i oprawy.

## Petle gry

### 30 sekund

Wejscie w kadr -> dostrzezenie niezgodnosci -> bezpieczna proba -> decyzja ->
przejscie lub unik -> konsekwencja.

### 10 minut

Nauka reguly -> samodzielne zastosowanie -> komplikacja pod presja -> cisza,
zmiana relacji albo krotka narracyjna puenta.

### Cala gra

Bohater zbiera dowody, uczy sie praw swiata i podejmuje nieodwracalne formy
adaptacji. Zakonczenie wynika z czynow podczas gry, nie z wyboru w menu.

## Zarys narracji

Pelna wersja kanoniczna znajduje sie w `docs/narrative/NARRATIVE_BIBLE.md` i
`docs/narrative/FULL_STORY.md`. Ponizsze akapity sa streszczeniem obietnicy.

Kontrolowany eksperyment nad korelacja stanow prozni konczy sie bez widocznej
awarii. Diagnostyka potwierdza sukces, a bohaterka wraca do zwyczajnego zycia.
Nie wie, ze trafila do rzeczywistosci, ktora probuje wpisac ja w miejsce jej
zaginionej lokalnej wersji.

Protagonistka, Lena Wolska, odkrywa w Rowni lokalne zycie swojej zaginionej
wersji: partnerke Marte, zywego brata Jakuba oraz UCP, ktore utrzymuje wspolna
historie kosztem niewygodnych swiadkow. Final nie wskazuje oryginalnego swiata;
pyta, za czyje dalsze istnienie Lena bierze odpowiedzialnosc.

Narastanie dziwnosci:

1. bledne fotografie, relacje i drobne wlasciwosci przedmiotow;
2. architektura zmieniajaca sie po utracie z pola widzenia;
3. ludzie uczestniczacy w rytualach korekty jak w normalnej procedurze;
4. fizyczne mechanizmy utrzymujace wspolna wersje historii;
5. sygnal powrotu, ktory moze zniszczyc albo przepisac jedna z rzeczywistosci.

## Jezyk audiowizualny

Fraza kierunkowa: **kliniczny porzadek, ktory nie potrafi utrzymac tej samej
wersji siebie**.

- Bazowa rozdzielczosc 640x360, skalowanie calkowite, brak filtrowania tekstur.
- Własny `Rówień Vector-Stage`: niskokolorowe, płaskie płaszczyzny i
  asymetryczne sylwetki o rytmie ruchu obserwowanym z życia; inspiracją jest
  ogólna dyscyplina cinematic platformers, nie odtworzenie ekspresji innej gry.
- Glitch jest informacja o stanie swiata, nie stalym filtrem dekoracyjnym.
- Cisza, dzwieki materialow i infrastruktury; muzyka oszczedna.

## Antyfilary

- brak lootowania, craftingu, drzewka umiejetnosci i otwartego swiata;
- brak aren strzeleckich i broni jako domyslnego czasownika;
- brak dziennikow wyjasniajacych cala historie;
- brak proceduralnego wypelniacza;
- brak kopiowania scen, sylwetek, palety lub rekwizytow Another World.

## Mierniki sukcesu vertical slice

- Nowy gracz rozumie podstawowy ruch w mniej niz 30 sekund bez tekstu.
- Restart po bledzie trwa ponizej 2 sekund.
- Co najmniej 70% z 20 zewnetrznych testerow konczy 12-15 minutowy fragment.
- Nikt nie pozostaje w jednym falszywym rozwiazaniu dluzej niz 3 minuty bez
  nowej informacji zwrotnej.
- Co najmniej 90% testerow potrafi powiedziec, ze "swiat jest niepoprawny",
  bez czytania ekspozycji.
- Stabilne 60 klatek na docelowym slabym komputerze testowym.

## Hipotezy, nie fakty

- Zakotwiczenie moze byc centralna mechanika calej gry.
- Powolny ruch i rzadkie zagrozenia moga utrzymac napiecie przez 2-3 godziny.
- Gracz zaakceptuje historie bez dialogowych wyjasnien.

Kazda z tych hipotez wymaga obserwowanego playtestu. Dokument nie jest dowodem,
ze pomysl juz dziala.
