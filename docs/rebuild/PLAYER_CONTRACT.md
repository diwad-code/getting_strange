# Kontrakt gracza — tożsamość, stawka i pierwsze 30 minut

## Uzupełnienie po audycie / PKG-0239 / 2026-09-22

Raport: `docs/narrative/NARRATIVE_FIX_IMPLEMENTATION.md`. Czasy poniżej
pozostają celami, nie wynikiem badania tej wersji. Przejście i odbiór:
**brak danych**. Nie ogłoszono PRODUCT GO.

Obietnica dotyczy wyjścia po jednym odczycie, nie przybycia na spotkanie,
które zaczęło się przed obowiązkowym pomiarem. Kontakt pozostaje o 20:40.
Powtórka łamie obietnicę; objazd opóźnia obie drogi. Bez powtórki Lena ma
czytnik, dokument i bufor. Torba w 05 jest opcjonalna; samo przejście nie
stempluje inspekcji. Kiosk odpowiada o trasie, nie o godzinie zamknięcia.

Po 13 rozpoznanie świata nie daje pełnej wiedzy o nadawcy ani powrocie.
15–18 oddziela obserwację, wniosek, znany koszt, niewiadomą i cudzą odpowiedź.
Dobra obserwacja nie jest automatycznym przyzwoleniem na procedurę.

Prognozy są czytelne także przy odmowie. Wykonanie wymaga odpowiedzi Jakuba
na wskazaną metodę; C także pełnej wiedzy miejscowej Marty i odrębnej zgody
na synchronizację. Pełna prawda nie daje przebaczenia. Przerwanie rozmowy
nie zapisuje niewypowiedzianej odpowiedzi. Ponowienie tej samej prośby nie
usuwa odmowy. Zmiana zakresu wymaga nowej propozycji i nowej odpowiedzi.

Finał nie odtwarza małego kosztu, nie tworzy niezdobytej próbki i nie przenosi
wiedzy między Martami. A/B/C zachowują odrębne ceny. Wskazówki obsługi są
oddzielone od głosu Leny, która nie mówi o sterowaniu sobą lub creditsach.

Status: **AKTYWNY KONTRAKT PRODUKTU P9 — BUNDLE-02 / PKG-0156**
Data: 2026-08-31
Decyzje nadrzędne: D-168, ADR-008
Plan: `docs/PROJECT_REBUILD_EXECUTION_PLAN.md` §3
Bramki: `docs/rebuild/ACCEPTANCE_MATRIX.md`

Ten dokument ustanawia cztery pytania kontraktu: kim jest gracz, co ma robić, po co i według jakich zasad. Każdy
kolejny bundle P9 jest mierzony tym kontraktem, nie zielonym testem.

Zasada nadrzędna dokumentu:

> **Fakt, którego nie da się zobaczyć albo wykonać, nie jest ustanowiony.**
> Dialog może fakt potwierdzić. Nie może go stworzyć w zastępstwie obrazu
> i działania.

---

## 1. Kim jest Lena

**Lena Wolska, 29 lat, diagnostyczka drgań w służbie utrzymania ruchu.**

Nie jest agentką, wybranką, hakerką ani badaczką multiwersum. Jest fachowcem
od jednej wąskiej rzeczy: mierzy, czy konstrukcja i tabor zachowują się tak, jak
zapisano. Ma czytnik, procedurę, godziny pracy i szefa, który liczy nadgodziny.

Dziewięć lat temu w katastrofie Linii 4 zginął jej brat Jakub. W danych z tamtej
nocy jest trzysekundowa luka. Komisja nazwała ją błędem czujnika. Lena nie
uwierzyła i wybrała zawód, w którym można sprawdzić takie luki.

| Warstwa | Treść | Nośnik |
|---|---|---|
| Kim jest | diagnostyczka drgań, nie bohaterka | strój roboczy, czytnik w ręku, stanowisko pomiarowe |
| Co robi teraz | wykonuje jeden odczyt, potem wybiera powtórkę albo wyjście | fizyczna czynność gracza na stanowisku |
| Czego chce | zamknąć pomiar czysto i wrócić do Marty | wiadomość Marty + realny upływ czasu w scenie |
| Czego się boi | że znów nazwą lukę błędem, a przypadek zostanie bezkarny | reakcja ciała przy odczycie, cisza po nim |
| Czego potrzebuje (nie wie o tym) | działać uczciwie przy niepełnej wiedzy i pytać ludzi o zgodę | dopiero po Station 13 |

### Jedno zdanie, które gracz ma umieć powiedzieć po 60 sekundach

> „Jestem Leną, sprawdzam dziwną lukę w pomiarze przy Linii 4, a Marta czeka
> na mnie. Obiecałam wyjść po jednym odczycie.”

Jeśli gracz musi przeczytać opis postaci, żeby to powiedzieć — kontrakt jest
złamany.

---

## 2. Stawka pierwszych minut

Stawka NIE jest ratowaniem świata. Jest mała, prywatna i natychmiast czytelna:

1. **Zawodowa:** niedokończony pomiar oznacza kolejny raport zamknięty słowem
   „artefakt”. Lena już raz to przeżyła i wtedy chodziło o jej brata.
2. **Osobista:** Marta czeka. Powtórka pomiaru kosztuje realny czas i Lena
   płaci go świadomie.
3. **Cielesna:** noc, zimno, koniec zmiany, obejście serwisowe zamiast prostej
   drogi. Zmęczenie jest widoczne w ruchu, nie opisane w tekście.

Konflikt otwierający brzmi: **próbka albo obietnica**. Gracz podejmuje tę
decyzję ręką, nie w menu dialogowym — powtarza pomiar albo pakuje sprzęt.
Obie drogi prowadzą dalej; różnią się tym, co Lena ma w torbie i co powie
Marcie.

---

## 3. Stan wiedzy po 1 minucie

**Gracz rozumie:** kim jest, gdzie stoi, co trzyma w ręku, co jest nie tak
z odczytem i że ktoś na niego czeka.

| Fakt | Musi wynikać z | Nie wolno ustanawiać przez |
|---|---|---|
| jestem kobietą przy pracy technicznej | sylwetka, strój, stanowisko, dźwięk hali | tekst „jesteś diagnostyczką” |
| to jest miejsce pracy, nie laboratorium fabuły | maszyna wykonująca swoją pracę, ślady zmiany | etykieta „UCP-4” |
| mam narzędzie i procedurę | czytnik w ręku i jedna wykonalna czynność | ekran samouczka |
| coś jest nie tak z pomiarem | widoczna rozbieżność dwóch odczytów | myśl „to dziwne” przed obserwacją |
| ktoś na mnie czeka | jedna wiadomość Marty z imieniem i godziną | ekspozycja o relacji |

**Czego gracz NIE ma prawa wiedzieć po minucie:** że istnieje inny świat,
że Jakub żyje, czym jest Anchor/Yield, czym naprawdę jest UCP.

---

## 4. Stan wiedzy po 5 minutach

**Gracz umie grać i wie, dokąd idzie.** Opuścił jednoznacznie techniczne
miejsce pracy i znalazł się w mieście, które wygląda inaczej pod każdym
względem: materiał, światło, dźwięk, głębia.

Gracz zna czasowniki: idź, biegnij (modyfikator), wejdź wyżej do 18 px lub po
drabinie, zbadaj, porównaj dwa źródła, przejdź próg. Nie zna jeszcze żadnego
czasownika anomalnego.

| Fakt | Nośnik | Dowód wykonania |
|---|---|---|
| umiem chodzić, wchodzić i badać | trzy realne użycia w 01–02 bez promptu tekstowego | przejście 01→02 bez podpowiedzi L3 |
| praca ma cenę: wracam później | wiadomość Marty i realna droga naokoło | Station 03 |
| miasto to inna rodzina miejsca niż zakład | niebo, fasady, nawierzchnia, publiczna głębia | monochromatyczny kadr 02 vs 01 |
| jadę do konkretnej osoby, nie do celu questa | rozkład, przystanek, przejazd Linią 4 | Station 03–04 |
| Linia 4 to nie jest neutralna nazwa | ślad katastrofy widziany z okna, bez wykładu | Station 04 |

Po pięciu minutach cel gracza brzmi: **dojechać do domu i stanąć przed
Martą.** Nic więcej.

---

## 5. Stan wiedzy po 30 minutach

**Gracz ma śledztwo, nie dezorientację.** Cztery niezależne, zwyczajne źródła
mówią to samo przeciwko pamięci Leny: rozkład, kiosk, budynek i sąsiadka.

| Źródło | Co mówi | Dlaczego jest uczciwe |
|---|---|---|
| rozkład na przystanku | trasa ma inny przebieg, niż Lena pamięta | druk, data, publiczna informacja |
| sprzedawca w kiosku | potwierdza obecną trasę Linii 4, odróżniając ją od objazdu; zna Martę i „Lenę” | ma własną pracę, nie zna tajemnicy |
| fasada budynku | dokument mówi 12, domofon mówi 14 | dwa fizyczne źródła w kadrze |
| sąsiadka na klatce | wita ją jak kogoś, kto tu mieszka od lat | codzienny ton, brak sugestii |

Bieżące pytanie gracza po 30 minutach:

> **„Czy problem jest w mieście, w danych, w mojej tożsamości, czy w mojej
> pamięci?”**

Wszystkie cztery hipotezy muszą być w tym momencie racjonalne. Gra nie
faworyzuje jeszcze żadnej, a Lena ma prawo bronić najprostszej: „jestem
przemęczona”.

**Czego gracz nadal NIE wie:** że to inna ciągłość, że istnieje druga Lena,
że Jakub żyje. To wiedza Station 13 i dalej.

---

## 6. Podział nośników informacji

| Warstwa | Mówi wyłącznie o | Nigdy nie mówi o |
|---|---|---|
| przestrzeń | gdzie jestem, dokąd prowadzi droga, co działa, co się zmieniło | tożsamości miejsca, której nie widać |
| ciało Leny | uwadze, wahaniu, wysiłku, dotyku, zmęczeniu | fabule zamiast obrazu |
| UI | sterowanie, prompt kontekstowy, pauza, zapis, ustawienia | ocenie moralnej, punktach |
| dialog | czego chce osoba, czego odmawia, jak reaguje na czyn | tłumaczeniu zasad świata |
| głos wewnętrzny | obserwacji, hipotezie, obronie — omylnie | rozwiązaniu zagadki |
| guidance L3/L4 | jaki test wykonać po realnym zastoju | „właściwej” emocji lub odpowiedzi |

Twarda reguła: **etykieta nie nadaje miejscu tożsamości.** Jeśli przestrzeń
jest rozpoznawalna dopiero po przeczytaniu napisu, przestrzeń jest wadliwa.

---

## 7. Zakazy kontraktu

1. Brak ekranu samouczka i brak listy sterowania jako pierwszego obrazu gry.
2. Brak prologu wyjaśniającego katastrofę Linii 4 przed pierwszą czynnością.
3. Brak anomalii, glitcha, sobowtóra i paranormalnego stingu przed Station 05.
4. Brak nazwania Anchor/Yield przed wykonaniem obu zachowań na martwym obwodzie.
5. Brak postaci, która istnieje po to, żeby wyjaśnić graczowi jego cel.
6. Brak dziennika zadań i markera nawigacyjnego zastępującego czytelną drogę.
7. Brak liczby, paska i punktu, który ocenia decyzję gracza.

---

## 8. Kryteria akceptacji kontraktu

Kontrakt jest spełniony, gdy przy przebiegu wyłącznie czasownikami gracza:

1. po 60 s da się zapisać zdanie z §1 bez korzystania z dokumentów;
2. po 5 min gracz wykonał co najmniej trzy różne czasowniki i zmienił rodzinę
   miejsca co najmniej raz;
3. po 30 min gracz potrafi wymienić cztery niezależne źródła rozbieżności
   i sformułować pytanie z §5;
4. żaden z faktów §3–§5 nie powstał wyłącznie w warstwie tekstu;
5. dry-run na bieżącym runtime kończy się `PRODUCT FAIL` (patrz macierz).

Te kryteria mierzy `docs/rebuild/ACCEPTANCE_MATRIX.md`. Automat sprawdza
strukturę i obecność nośnika. Nie dowodzi zrozumienia ani emocji człowieka
(D-012, ADR-003).
