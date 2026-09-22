# Roadmapa produkcyjna

Status: plan kierunkowy, aktualizowany na bramkach

Daty sa prognozami, nie zobowiazaniem. Kolejny etap otwiera wynik poprzedniego,
nie sam uplyw czasu.

## Model bramek po ADR-003

Zewnetrzne playtesty i czytania stolikowe nie odbeda sie w tym projekcie.
Bramki oparte na testerach zostaly przepisane zgodnie z
`decisions/ADR-003-evidence-model-without-external-testers.md`.

Bramka moze zawierac wylacznie **pomiar obiektywny** albo **audyt kontraktu**.
Kryterium odbioru nie jest bramka; przenosi sie do
`RISKS_AND_HYPOTHESES.md` jako `ACCEPTED-RISK` wraz z nazwanym skutkiem bledu
i planem odwrotu.

Kazda bramka nizej wymienia jawnie, czego **nie** sprawdza. To nie jest
przypis - to jest tresc bramki.

## P0. Fundament koncepcyjny i techniczny

Status: **UKONCZONY**

Zakres:

- research Another World, cinematic platformers, horroru i narzedzi;
- product brief oraz granice inspiracji;
- wybor Godot 4.7.x, GDScript, PC-first i 640x360;
- uruchamialny projekt i automatyczna bramka;
- system dokumentacji oraz przekazywania pracy.

Wersjonowanie istnialo w P0 i zostalo zniesione w `PKG-0006` (D-016).

Bramka:

- projekt uruchamia sie i przechodzi `tools/verify.ps1`;
- katalog projektu ma czysty, odtwarzalny punkt startowy;
- wizja, hipotezy, ryzyka i nastepny pakiet sa zapisane.

## P1. Prototype 01: Movement Lab

Status: **W TOKU**

Cel: potwierdzic, ze filmowy ciezar postaci da sie pogodzic z szybka reakcja
sterowania.

Ukonczone:

- T1 fundament projektu;
- T2 chodzenie, coyote time, bufor i zmienna wysokosc skoku;
- T3 przepasc, automatyczny respawn i reczny restart;
- techniczna przechodniosc calego kadru;
- render kontrolny i headless smoke test;
- typowane profile ruchu A/B/C oraz slepy harness facylitatora;
- automatyczny kontrakt, ze A/B/C roznia sie tylko reakcja pozioma.

Otwarte:

- T4 i T5 w wersji z testerami sa **anulowane**; harness A/B/C pozostaje w
  projekcie jako gotowe narzedzie na wypadek pojawienia sie choc jednej
  osoby z zewnatrz;
- wybor profilu przez wlasciciela z zapisanym powodem;
- decyzja PASS, ITERATE lub STOP/PIVOT.

Bramka P1 (przepisana, ADR-003):

Pomiar obiektywny:

- restart ponizej 2 sekund, mierzony w runtime;
- deterministyczna przechodnosc calego kadru w smoke tescie;
- brak skoku bez widocznego ladowania - audyt geometrii grayboxu, nie odczucie;
- profile A/B/C roznia sie wylacznie zadeklarowanymi czterema parametrami,
  potwierdzone testem automatycznym.

Audyt kontraktu:

- wybrany profil ma wpis w `DECISION_LOG.md` z uzasadnieniem i data;
- `RISKS_AND_HYPOTHESES.md` ma H-001 przestawione na `ACCEPTED-RISK` ze
  skutkiem bledu i planem odwrotu.

**Czego ta bramka nie sprawdza:** czy ruch jest przyjemny, czy nowa osoba
zaczyna bez instrukcji, czy mediana przejscia miesci sie w 90 sekundach i czy
ktorykolwiek profil wygrywa u ludzi. To pozostaje H-001 i nie zostanie
rozstrzygniete.

## Tor rownolegly N1. Kanon narracyjny i wizualny

Status: **DRAFT 0.1 UKONCZONY; H-002a MEASURED (PIVOT w ADR-005)**

Ten tor nie otwiera P2 ani produkcji assetow. Dostarcza cel dla przyszlych
prototypow:

- biblie swiata, postaci, relacji i trzech rodzin finalu;
- pelny przebieg 43 przestrzeni w pieciu aktach po pakiecie `N0.2-C` (układ
  7/10/11/11/4);
- tracker poszlak, wiedzy postaci, rekwizytow i warunkow finalow;
- biblie glosow oraz kluczowe sceny dialogowe;
- kierunek wizualny, palete, gramatyke anomalii i handoff pionowego wycinka.

Otwarte bramki N1 (przepisane, ADR-003):

Stolikowy przeglad przez osoby spoza autorstwa jest **anulowany**. Zastepuje go
audyt kontraktu wykonany przez sesje bez dostepu do rozmowy tworzacej material
(D-008, R-016). Pierwszy taki audyt wykonano 2026-08-15 i jego wyniki sa
zrodlem pakietow N0.2.

Audyt kontraktu:

- zero twardych sprzecznosci miedzy `NARRATIVE_BIBLE.md`, `FULL_STORY.md`,
  `CONTINUITY_TRACKER.md`, `DIALOGUE_SCRIPT.md` i `VISUAL_DESIGN.md`;
- kazdy wiersz trackera cytuje fraze obecna w `FULL_STORY.md` - wiersz bez
  pokrycia jest zadaniem do napisania, nie zapisem stanu (H-010a);
- `DIALOGUE_SCRIPT.md` zawiera scene dla kazdego zwrotu oznaczonego w
  `FULL_STORY.md` jako punkt zwrotny, reversal lub koniec aktu;
- zaden final nie ma przewagi strukturalnej nad pozostalymi (H-011a = 0);
- liczba scen dowodzacych skutecznosci i krzywdy UCP jest porownywalna i
  rozlozona miedzy akty (H-009a).

Pomiar:

- H-002a: audyt 43 przestrzeni zmierzyl **5 odrebnych zastosowan** (14, 20,
  22, 33, 41); próg po decyzji ADR-005 wynosi 5, wiec status **MEASURED**. Pelna metoda i tabela sa w
  `docs/narrative/MECHANICS_AUDIT_H-002A.md`;
- czytelnosc kluczowych elementow w 640x360 na realnym renderze (H-012).

Zamkniety pakiet `N0.2-C`:

- wdrożono D-015: Świadectwo jest zawsze dostępne, a braki połączeń obniżają
  stabilność i są widoczne w epilogu;
- usunięto cztery mierzalne sygnały uprzywilejowania finalu C, pozostawiając
  wyłącznie odrębną regułę palety jako świadomie wizualną;
- scalono sceny 18/36, wchłonięto 22 do 24 i przeniesiono 19 za 11; wszystkie
  dokumenty używają nowej numeracji 43 przestrzeni.

Zamknięty pakiet `N0.2-D`:

- wykonano audyt kontraktowy wszystkich 43 przestrzeni;
- policzono 5 odrębnych zastosowań Zakotwiczenia/Uległości, co po decyzji D-026 wystarcza; H-002a ma status `MEASURED`;
- odrzucono jako nowe zastosowania same rekwizyty, sieć świadków,
  przygotowanie adresu, wypłaty w scenach 21 i 37 oraz rezultaty 42A–42C;
- nie zmieniono liczby przestrzeni, kanonu finałów, runtime ani Prototype 02.

Skutek dla kolejki: Prototype 02 ODBLOKOWANY. Na mocy decyzji D-026 i ADR-005 rygor tekstu zostal zniesiony na rzecz testow mechaniki w kodzie silnika (runtime).

Dopiero po tych bramkach: arkusz produkcyjny scen i pelny dialog.

**Czego te bramki nie sprawdzaja:** czy fabula porusza, czy zwrot zaskakuje,
czy relacje utrzymuja 2-3 godziny i czy trzy finaly maja obroncow. To pozostaje
H-008, H-009b, H-010b i H-011b.

## P2. Prototype 02: Anchor Lab

Status: **UKOŃCZONY (Bramka P2 zaliczona w PKG-0018)**

Zakres zrealizowany:

- obiekty w dwóch wersjach rzeczywistości (zrobione: `AnchorableObject` ze `State A` / `State B`);
- fizycznie przemieszczane skrzynie ładunkowe (zrobione: `MovableAnchorableProp` z pchnięciem, grawitacją i oporem);
- jedno aktywne Zakotwiczenie (zrobione: zasada wyłączności pojedynczej kotwicy w `AnchorLab`);
- trzy komory: nauka (most Ch1), zastosowanie (podnośnik Ch2 i antresola ze skrzynią), komplikacja (chasm, most Ch3, brama żaluzjowa Ch3 i śluza pomiarowa Goal);
- proces korekty konsensusu reagujący na kotwice (zrobione: fala korekty / przesunięcie rzeczywistości z oporem);
- pełne sprzężenie audiowizualne (zrobione: generator `ProceduralAudio` dla kotwic, oporu, fali korekty, kroków na linoleum/metalu, lądowań i ryglowania śluzy, `CPUParticles2D`, aparatura ścienna w świecie gry);
- system przejścia i ryglowania śluzy `Goal` (zrobione: animacja rygli, sygnał `sector_completed` i telemetryczny overlay).

Bramka P2 (przepisana, ADR-003):

Pomiar obiektywny:

- każda możliwa kotwica ma jednoznaczny, zrzutowalny stan przed i po (potwierdzone);
- błędna próba zmienia obserwowalny stan świata, a nie tylko cofa gracza (potwierdzone testem);
- trzy komory wykorzystują trzy różne klasy zastosowania kotwicy, potwierdzone testem automatycznym (most statyczny, podnośnik pionowy, skrzynia ładunkowa, para most-brama).

Audyt kontraktu:

- scenariusz osiągnął próg H-002a wynoszący 5 (zgodnie z D-026);
- żadne rozwiązanie pokoju nie wymaga wiedzy spoza gry.

**Czego ta bramka nie sprawdza:** czy gracz przewiduje efekt bez instrukcji i
czy mechanika jest interesujaca. To pozostaje H-002b i H-006.

## P3. Vertical Slice

Status: **W TOKU (Otwarcie: PKG-0019, postęp: Station 01..36 wdrożone — Akt I oraz Akt II w pełni domknięte w silniku, Akt III: Podstruktura rozwinięty; Kanał Odpływowy / Zimny Ściek: podziemny odpływ burzowy pod Starą Pętlą, zardzewiały jaz ze szczątkami pamięci, rwący nurt osadu sedacyjnego, kładka ze stali kwasoodpornej, kurek probierczy skażenia wód gruntowych Osiedla Tarasowego i brama przeciwsztormowa ku Przestrzeni 37 / Komora Sygnałowa)**

Cel: 12-15 minut materialu o jakosci reprezentujacej produkt.

Wymagane elementy:

- zwyczajny proces i pierwsza mikroniezgodnosc (zrobione: Station 01 Sterownia IKP i Station 02 Komora Pomiarowa z nieciągłością cienia `DiscontinuousShadow`);
- cichy moment relacji i dowody alternatywnego świadka (zrobione: Station 03 Puste Laboratorium — 2 kubki, telefon z 14 wiadomościami, czytnik "URLOP PRZERWANY");
- interakcja społeczna i tabu zaginionego brata (zrobione: Station 04 Bramka — dialog D-01 ze strażnikiem, zgaśnięcie lampy kamery na "Jakub nie żyje", odryglowanie kołowrotu);
- miejska przestrzeń zewnętrzna i spokojna groza korekty (zrobione: Station 05 Rówień nocą — anachronistyczny afisz 1978, budynek bez 3. piętra, sygnał przejścia z imieniem Leny i restless grid poza spojrzeniem kamery);
- podróż linią zastępczą i materialny rekwizyt tożsamości (zrobione: Station 06 Linia Zastępcza — jadący nocny autobus, komunikat PA, złota obrączka);
- relacja z Martą Kurek i zbieżność rysów twarzy (zrobione: Station 07 Klatka schodowa — dialog D-02, badanie skrzynek, ślepe schody);
- cichy moment w mieszkaniu odpowiedniczki (zrobione: Station 08 Mieszkanie po kimś — rekwizyty podwójnego zastosowania, szyfr 0311 szuflady);
- opóźnione odbicie i inskrypcja pod kątem (zrobione: Station 09 Łazienka / Pokój, który nie czeka — lustro, poszlaka R-02 NIE SZUKAJ ORYGINAŁU, dialog D-03);
- konfrontacja ze zmarłym bratem i domknięcie Aktu I (zrobione: Station 10 Telefon Jakuba — telefon bakelitowy, dialog D-04, magnetofon);
- otwarcie Aktu II i interwencja polowa UCP (zrobione: Station 11 Pierwsza korekta — dwupoziomowy dziedziniec, ratunek kobiety i wygładzenie szwu muru);
- pokaz bezpieczeństwa UCP i autoryzacja Poziomu 3 (zrobione: Station 12 Pokaz bezpieczeństwa — nakładające się schody, ratunek dziecka, terminal CRT);
- analiza topograficzna i pamięć jako koszt (zrobione: Station 13 Adres ciągłości — stół kreślarski, włożenie fotografii Jakuba, narastanie dorosłego cienia);
- mechanika Zakotwiczenia w narracji i poszlaka ciszy (zrobione: Station 14 Zakotwiczenie / Schowek techniczny — rysa w belce stalowej z cyjanem, degradacja taśmy Jakuba, poszlaka 3. sekundy ciszy R-04/R-05 i odryglowanie szybu Podstruktury);
- pismo lokalnej Leny i odwrócone odbicie wektora (zrobione: Station 15 Korytarz serwisowy — poszlaka R-06, higiena ciągłości, dekompresja magistrali i asynchroniczne odbicie kałuży);
- konfrontacja relacyjna i wybór tożsamości z obrączką (zrobione: Station 16 Rozmowa przy stole — dialog D-05, teczka dowodów R-01..R-06, klejenie filiżanki Marty i wybór dyspozycji obrączki odryglowujący wyjście balkonowe);
- jedna pelna sekwencja Zakotwiczenia;
- jedna sekwencja pod presja, w ktorej porazka wykonawcza kosztuje czas, a nie
  fabule (D-019); nie jest to walka ani przeciwnik;
- cichy moment relacji z lokalnym zyciem odpowiednika;
- oryginalna oprawa, dzwiek i podstawowe ustawienia dostepnosci;
- stabilny build PC oraz wersjonowany checkpoint.

Bramka P3 (przepisana, ADR-003):

Pomiar obiektywny:

- **zmierzony koszt produkcji jednego finalnego kadru i jednej pelnej animacji
  protagonisty** - to jest teraz najwazniejsze kryterium bramki, bo jako jedyne
  rozstrzyga o wykonalnosci calego projektu (H-005, R-002);
- stabilne 60 klatek na docelowym slabym komputerze testowym;
- czytelnosc w 640x360 potwierdzona pomiarem i symulacja wad widzenia barw
  (H-012);
- kazda przestrzen slice'u przechodzi deterministyczny test przejscia.

Audyt kontraktu:

- slice realizuje wszystkie elementy wymagane wyzej, bez podmiany zakresu;
- kazde twierdzenie o odbiorze w materialach slice'u nosi etykiete braku
  dowodu.

**Czego ta bramka nie sprawdza:** odsetka ukonczen, miejsc zatrzymania, czasu
utkniecia i tego, czy gracz rozumie niezgodnosc swiata bez ekspozycji. To
pozostaje H-003 i R-003 - najwieksza niepokryta luka projektu.

## P4. Preprodukcja pelnej gry

Status: **ZABLOKOWANY PRZEZ P3**

- zamkniecie zakresu rozdzialow, zagrozen i zestawu czasownikow;
- budzet animacji, audio, lokalizacji i QA;
- mapa zaleznosci narracyjnych oraz model zapisu;
- harmonogram, outsourcing i pion artystyczny;
- decyzja o tytule handlowym i przeglad IP;
- strona sklepu dopiero po potwierdzeniu reprezentatywnej jakosci.

## P5. Produkcja, Alpha, Beta

Status: **NIEOTWARTY**

- produkcja pokojow pionowymi wycinkami;
- audyt kontraktu i pomiar czytelnosci co najmniej po kazdym rozdziale; playtest
  tylko wtedy, gdy pojawi sie osoba z zewnatrz - patrz ADR-003;
- Alpha: cala gra przechodnia i kompletna funkcjonalnie;
- Beta: bez nowych duzych funkcji, tylko jakosc, dostepnosc, lokalizacja,
  optymalizacja i naprawy;
- content lock przed finalna regresja.

## P6. Demo i wydanie

Status: **NIEOTWARTY**

- reprezentatywne demo z vertical slice lub poczatku gry;
- Steam i itch.io, Windows i Linux;
- testy czystej instalacji, zapisu, pada i kilku klas sprzetu;
- materialy marketingowe podkreslajace wlasna tozsamosc;
- plan poprawek po premierze bez obietnicy nieograniczonego contentu.

## Prognoza czasu

Po udanym vertical slice:

- solo full-time: orientacyjnie 18-30 miesiecy calosci;
- solo part-time: orientacyjnie 2,5-4 lata;
- trzyosobowy rdzen z kontraktorami: orientacyjnie 12-18 miesiecy.

Prognozy musza zostac przeliczone na podstawie zmierzonego czasu wykonania
finalnego kadru, animacji protagonisty i jednej kompletnej zagadki. Przed tym
momentem sa narzedziem kontroli ambicji, nie harmonogramem.
