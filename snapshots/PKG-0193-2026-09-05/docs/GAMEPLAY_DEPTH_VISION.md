# Getting Strange — wizja pogłębienia gameplayu: Diagnoza pod presją

Status: **AKTYWNY KIERUNEK P7 1.0 — D-153 / PKG-0143**  
Data: 2026-08-30  
Zakres: wizja projektowa; **nie jest planem implementacji ani listą zadań**.

## Decyzja

`Getting Strange` przestaje być przede wszystkim linią „wejdź → obejrzyj →
odpal punkt → wyjdź”. Ma być kameralnym **thrillerem diagnostycznym**, w
którym gracz regularnie buduje model sprzecznej rzeczywistości, sprawdza go
fizycznie, a następnie bierze odpowiedzialność za to, co chwilowo uznaje za
prawdę.

> **Nie zbierasz poszlak. Budujesz model świata, próbujesz go obalić, a potem
> decydujesz, czyją ciągłość wolno utrzymać.**

To nie oznacza walki, lootu, craftingu, nowego ruchu, escape-roomowych kodów
ani platformingu. Decyzja wzmacnia istniejące filary: diagnostyczną tożsamość
Leny, uczciwe dwie tajemnice, Anchor/Yield od Station 22, zgodę osób oraz
fizyczną wiarygodność infrastruktury.

## Problem, który rozwiązujemy

Użytkownik wskazał dominującą pętlę liniowego przejścia i pasywnych aktywacji.
Kod potwierdza ten symptom na reprezentatywnej Station 30: cztery niezależne
flagi inspekcji prowadzą do `_check_unlock()`, a postęp dialogu sam wywołuje
kolejne inspekcje i odryglowuje wyjście. To jest łańcuch zaliczeń, nie
rozumowanie.

Projekt ma jednak dobry materiał do przebudowy bez resetu:

- `AnchorableObject` już rozróżnia dwa stany rzeczywistości; zakotwiczony
  obiekt opiera się korekcie, a niezakotwiczony przechodzi w jej stan.
- `AnchorLab` wymusza **jedną aktywną kotwicę**. To ograniczenie jest cennym
  źródłem decyzji, nie defektem do obejścia ekwipunkiem wielu kotwic.
- `MovableAnchorableProp` daje fizyczną pracę ciała: pchanie, ciężar,
  ustawienie i zamrożenie w miejscu.
- `GameStateManager` zachowuje fakty i decyzje; może przechowywać rezultat
  sprawy bez globalnego „miernika dobra”.
- Kanon `Pokaż → naprowadź → pomyśl → sprawdź` już rozdziela fakt, hipotezę i
  test. Gameplay ma tę strukturę wreszcie wykonywać, a nie tylko opisywać.

## Obietnica doświadczenia

Gracz powinien odczuwać kolejno:

1. **Ciekawość kompetentnej diagnostki** — „co dokładnie nie pasuje?”
2. **Napięcie hipotezy** — „mój model może być błędny, ale wiem, jak go
   sprawdzić”.
3. **Satysfakcję z dowodu** — „to ja połączyłem niezależne źródła i świat
   odpowiedział przewidywalnie”.
4. **Odpowiedzialność** — „rozwiązanie faktu nie mówi jeszcze, co wolno mi
   zrobić z osobą i jej wspomnieniem”.
5. **Ulgę albo żałobę po konsekwencji** — kolejna stacja nie kasuje skutku do
   abstrakcyjnej flagi.

To są hipotezy odbiorcze, nie fakty dowiedzione testem automatycznym.

## Nowa gramatyka gry

Każda istotna sekwencja gameplayowa ma pięć kroków. Nie każdy pojedynczy pokój
musi zawierać wszystkie; pełna sekwencja może rozciągać się na 2–4 stacje.
Dzięki temu nie łamiemy kanonu jednej rodziny przeszkody na przestrzeń.

1. **Rozbieżność** — dwa wiarygodne źródła nie mogą być jednocześnie prawdziwe.
   Źródłem jest osoba, materiał, rejestr albo infrastruktura, nigdy losowy
   symbol na ścianie.
2. **Hipoteza robocza** — gracz wskazuje relację przyczynową, nie wybiera
   „poprawnej odpowiedzi” z quizu. Przykład: czy identyfikator opisuje osobę,
   czy wersję jej życia?
3. **Próba rozstrzygająca** — gracz wykonuje bezpieczny test, którego możliwe
   wyniki rozdzielają co najmniej dwie hipotezy. Czynność zmienia świat:
   przepuszcza próbkę, ustawia element infrastruktury, porównuje odpowiedź
   sygnału albo przeprowadza obiekt przez korektę.
4. **Zobowiązanie** — po poznaniu faktu gracz wybiera działanie z jawnym
   kosztem: utrzymać relację, dopuścić odpowiedź, poprosić o zgodę, ujawnić
   rekord albo odmówić użycia osoby jako narzędzia.
5. **Ślad** — rezultat staje się obserwowalny w geometrii, dźwięku, zachowaniu
   postaci i późniejszym zapisie. Nie jest tylko odblokowaną śluzą.

### Dwie rzeczy, których nie wolno mieszać

| Rodzaj | Pytanie | Kontrakt |
|---|---|---|
| **Zagadka faktu** | „Co jest prawdą o układzie?” | Uczciwa, sprawdzalna, z pełną informacją potrzebną do rozwiązania i co najmniej jedną alternatywną drogą obserwacji tam, gdzie to ma sens. |
| **Decyzja etyczna** | „Co wolno zrobić z prawdą?” | Kilka ważnych odpowiedzi; koszty są czytelne przed wyborem, nie ma ukrytego optymalnego licznika ani bezkosztowego finału. |

Gracz nigdy nie powinien przegrywać fabuły, bo nie odgadł intencji autora.
Może ponieść konsekwencję za świadomie wybraną metodę.

## Pięć rodzin wyzwań

### 1. Rozbieżność trzech źródeł — przed Station 21

Dwa źródła tworzą pozorną sprzeczność, lecz trzecie daje test rozróżniający.
Gracz porównuje **materiał**, **zapis** i **świadka**, zamiast zebrać trzy
checkmarki. Błędna hipoteza musi otworzyć nowy fakt, a nie resetować scenę.

To naturalnie rozwija wczesne akty: normalność 01–05 pozostaje normalna, bo
sprawy dotyczą procedury, trasy, adresu i relacji; dziwność jest wynikiem
uczciwie niewyjaśnionej rozbieżności, nie efektu paranormalnego.

### 2. Próba rozstrzygająca — działanie zamiast odczytu

Ważny dowód ma kosztować **działanie**, nie czas spędzony przy terminalu.
Lena wykonuje mały, bezpieczny eksperyment w działającej infrastrukturze:
przepuszcza próbkę przez inny tor, zestawia dwa rejestry pod jednym źródłem
zasilania, przeprowadza wózek przez kontrolowany próg albo obserwuje, co
pozostaje po wyłączeniu pośrednika.

Powstałe wyzwanie jest logiczne, ale fizyczne: ciało Leny, materiał i miejsce
są częścią argumentu. Nie wymaga precyzji klatkowej ani nowych czasowników
ruchu.

### 3. Pole ciągłości — Anchor/Yield od Station 22

Anchor/Yield ma być centralnym językiem decyzji, nie przyciskiem zmiany koloru.
Jedna aktywna kotwica oznacza: **można utrzymać tylko jedną relację naraz**.
Gdy nadchodzi korekta, gracz decyduje, czy zachować przejście, ślad, świadectwo
albo materialny obiekt; reszta może zmienić adres, czas lub pamięć.

Dobra sekwencja pola ciągłości ma zawsze:

- czytelny stan A i B przed próbą;
- konkretną rzecz, która zostanie utrzymana;
- konkretną rzecz, która zapłaci za Uległość;
- fizyczny test po przejściu korekty;
- korektę jako informację lub lokalny koszt, nigdy ukrytą karę.

Nie zwiększamy liczby kotwic dla pozornej głębi. Głębia bierze się z ich
wyłączności, z rozmieszczenia świata oraz z tego, co dany świadek zgodził się
podtrzymać.

### 4. Wspólne świadectwo — zgoda jako realna sprawczość

Marta i Jakub nie mogą być flagami „zaufanie +1”. Ich zgoda jest precyzyjnym
warunkiem działania: dotyczy określonego rekordu, czasu i ryzyka. Gracz musi
najpierw pokazać, co wie i co działanie może zniszczyć; dopiero wtedy może
prosić o współudział.

Mechanicznie wspólne świadectwo nie daje premii statystycznej. Otwiera inny
rodzaj próby: drugi punkt obserwacji, dodatkową rękę przy infrastrukturze,
legalny dostęp do prywatnego zapisu albo możliwość utrzymania pola dla kogoś
innego. Odmowa pozostaje ważnym wynikiem i kieruje do innej, uczciwej drogi.

### 5. Kontrmodel UCP — opozycja jako system

Wierzbicka i UCP nie stoją przy końcu korytarza, aby wyjaśnić lore. Instytucja
prowadzi własny, spójny model: najbezpieczniejsza wersja rzeczywistości ma
pierwszeństwo przed nieindeksowaną osobą. W późnych aktach gracz buduje
**kontrmodel** z niezależnego zapisu, materialnego skutku i zgody świadka,
a następnie sprawdza, czy model UCP wytrzyma kontrprzykład.

To jest przeciwstawna forma myślenia, nie walka z wrogiem. UCP może ograniczyć
dostęp, skorygować obiekt albo zaoferować łatwiejsze rozwiązanie — ale jej
reguły są widoczne, przewidywalne i możliwe do obejścia przez rozumowanie.

## Rytm kampanii

Docelowo kampania 43 stacji składa się z około **12–15 sekwencji wyzwań** oraz
aktywnych przestrzeni rozmowy i oddechu. Jedna sekwencja obejmuje 2–4 stacje,
a nie cztery niezależne pokoje z tą samą listą aktywacji.

| Zakres | Dominująca umiejętność | Rodzaj szczytu |
|---|---|---|
| 01–05 | Obserwacja i test bez jawnej anomalii | Mała diagnoza: procedura nie daje oczekiwanego wyniku. |
| 06–13 | Łączenie rozbieżnych źródeł | Śledztwo w świecie, który nadal da się racjonalizować. |
| 14–21 | Dowód relacyjny i synteza | Station 21 jako fizyczne złożenie trzech rodzin dowodów. |
| 22–30 | Kontrolowana praca Anchor/Yield | Jedna kotwica, pierwszy widoczny koszt, następnie wariacja. |
| 31–38 | Kontrmodel i zgoda | Opozycja UCP oraz świadectwo, którego nie wolno wymusić. |
| 39–43 | Prognoza i wykonanie metody | Finał jako świadome zastosowanie poznanych reguł, nie kolorowy wybór. |

Po każdym szczycie potrzebne są aktywne doliny: rozmowa, badanie skutku,
przygotowanie hipotezy lub dobrowolna eksploracja. Cisza nie jest wypełniaczem,
jeśli konsoliduje wiedzę albo koszt.

## Przykładowe momenty sygnaturowe

Nie są one przydziałem prac do konkretnych plików scen; pokazują standard
pomysłowości i stawkę, które musi spełnić przyszła implementacja.

### „Adres, który działa tylko dla jednej osoby”

Lena znajduje działający adres, lokalny rejestr i fizyczny domofon. Wszystkie
trzy źródła mają rację, ale odnoszą się do różnych relacji: osoby, mieszkania i
ciągłości. Gracz nie wpisuje kodu. Ustawia próbę z domofonem i zapisem trasy,
by sprawdzić, czy system rozpoznaje ciało, historię czy adres. Rezultat zmienia
późniejszy sposób, w jaki Marta może odczytać intencję Leny.

### „Schody dla kogoś drugiego”

Korekta robi dwie wersje tej samej klatki schodowej. Lena może utrzymać jedną
poręcz jako punkt odniesienia, ale wtedy ślad w rejestrze znika; może też ulec
i zachować ślad, ryzykując drogę drugiej osoby. Przeszkoda istnieje, bo budynek
ma nakładające się przebiegi ewakuacyjne, nie dlatego, że projekt wymaga skoku.

### „Protokół bez właściciela”

UCP przedstawia decyzję jako neutralne bezpieczeństwo. Gracz znajduje materialny
skutek, prawidłowy zapis i świadka, który zgodzi się ujawnić tylko część
własnej historii. Złożenie kontrmodelu nie „pokonuje” Wierzbickiej; zmusza ją
do zmiany procedury i otwiera kosztowny, ale legalny wariant przejścia.

### „Próba wzajemna”

W finale gracz nie wybiera A/B/C z listy. Uruchamia wybraną metodę w
infrastrukturze, świadomie wskazując, co zakotwicza, co poddaje odpowiedzi i
czyj zapis zachowuje. Każda rodzina końca jest skutkiem rozwiązania faktów oraz
wcześniejszych zgód, bez ukrytej czwartej odpowiedzi.

## Twarde zasady jakości

1. **Każdy wymagany wniosek ma dwa niezależne konteksty.** Jeden może być
   wizualny lub dźwiękowy, lecz drugi musi umożliwiać sprawdzenie.
2. **Żaden obiekt nie jest wyłącznie przełącznikiem fabuły.** Musi należeć do
   funkcjonującego miejsca oraz zmieniać stan argumentu gracza.
3. **Błędna próba tworzy informację.** Domyślna Korekta nie usuwa obowiązkowej
   poszlaki ani nie każe powtarzać długiej sekwencji.
4. **Jedna nowa reguła naraz.** Bezpieczny przykład → samodzielne użycie →
   odwrócenie albo połączenie z już znaną regułą.
5. **Pomoc mówi o teście, nie o rozwiązaniu.** L3 rozdziela hipotezy; L4 może
   wskazać czynność, ale nie wybiera zgody ani finału.
6. **Nie ma ukrytej optymalnej moralności.** Fakty mogą mieć poprawne odpowiedzi;
   koszty relacyjne muszą być jawne i trwać w świecie.
7. **Bez zręcznościowej przemocy.** Żadnych timingowych skoków, patroli,
   obrażeń, arbitralnych timerów ani szybkich sekwencji przycisków.
8. **Czytelność ponad dekorację.** Stan A/B, droga, koszt i źródło informacji
   są rozróżnialne także bez samego koloru oraz w trybie ograniczonego ruchu.

## Granica techniczna przyszłej pracy

Wizja zakłada rozbudowę danych i autorstwa, nie nowy globalny kombajn:

- sekwencja powinna mieć jawne dane o rozbieżności, hipotezach, testach,
  zgodach, kosztach i śladzie;
- lokalna logika stacji może prowadzić konkretną infrastrukturę;
- trwałe fakty i decyzje pozostają serializowalne przez istniejący zapis;
- istniejące `AnchorableObject`, `MovableAnchorableProp`, punkty pamięci,
  guidance i audio są podstawą do adaptacji, nie powodem do napisania
  równoległej mechaniki;
- nie dodajemy nowych czasowników ruchu ani HUD-u z punktami, zdrowiem,
  ekwipunkiem lub metą optymalizacji.

Dopiero plan wdrożenia rozstrzygnie nazwy klas, format `Resource`, migrację
zapisu, kolejność pionowych wycinków, testy kontraktów i konkretne sceny.

## Research, który zmienił decyzję

- **Outer Wilds**: Mobius rozłożył wiedzę o „Curiosities” po różnych miejscach,
  a postęp wynikał z poznania reguł świata, nie z nowej umiejętności. Dla
  projektu oznacza to rozproszone, ale kierunkowe źródła dowodu — nie kopiowanie
  kosmicznej pętli czasu. [GamesRadar+, 2020](https://www.gamesradar.com/the-making-of-outer-wilds/)
- **Return of the Obra Dinn**: Lucas Pope dzielił złożoną historię na osobno
  zrozumiałe katastrofy i dodał księgę, gdy samo pamiętanie faktów przestało
  wystarczać. Dla projektu: sekwencje muszą mieć lokalny sens, a zapis ma
  odciążać pamięć bez rozwiązywania sprawy za gracza. [Game Developer,
  2019](https://www.gamedeveloper.com/business/road-to-the-igf-lucas-pope-s-i-return-of-the-obra-dinn-i-)
- **The Case of the Golden Idol**: autorzy ograniczyli informację do rzeczy
  potrzebnych lub do sensownych mylnych tropów, dodali postęp częściowy i
  stosowali różne drogi dedukcji. Dla projektu: nie budować magazynu śmieciowych
  dokumentów ani binarnego „dobrze/źle” po każdym kroku. [Game Developer,
  2022](https://www.gamedeveloper.com/design/case-of-the-golden-idol)
- **Chants of Sennaar**: Rundisc wymagał, aby nieznany element pojawiał się co
  najmniej dwa razy w różnych kontekstach; funkcjonujący świat i jego mieszkańcy
  byli podstawą zagadek. Dla projektu: redundancja dowodu oraz infrastruktura,
  która ma sens bez Leny. [Game Developer,
  2024](https://www.gamedeveloper.com/design/immersing-players-in-the-culture-of-a-people-with-language-puzzler-chants-of-sennaar)
- **Puzzle Writing: Best Practices**: zagadka jest kontraktem — projektant daje
  wszystkie informacje potrzebne do rozwiązania, integruje je ze światem i
  historią, lecz zachowuje wyzwanie. [GDC Vault,
  2010](https://gdcvault.com/play/1013851/Puzzle-Writing-Best)
- **Open-Ended Puzzle Design at Zachtronics**: przestrzeń kilku sensownych
  rozwiązań może tworzyć ekspresję gracza, o ile wynika z prostych, spójnych
  reguł. Dla projektu: otwierać warianty przy zobowiązaniu i zgodzie, nie przy
  faktach wymagających uczciwego dowodu. [GDC Vault,
  2019](https://gdcvault.com/play/1025715/Open-Ended-Puzzle-Design-at)
- **Puzzle Challenge Analysis Tool**: samo przejście lub wynik punktowy nie
  mierzy trudności zagadki; potrzebna jest jawna analiza wymagań poznawczych.
  Dla projektu: przyszłe bramki mogą sprawdzać strukturę informacji i możliwość
  odzyskania stanu, ale nie będą udawać dowodu satysfakcji. [Pusey, Wong,
  Rappa, CHI PLAY 2021](https://dl.acm.org/doi/10.1145/3474703)

Źródła są precedensami projektowymi, nie dowodem, że taka wizja będzie
satysfakcjonująca dla odbiorcy `Getting Strange`. Nie przenosimy ich fabuł,
interfejsów, ikonografii ani konkretnych zagadek.

## Stan po PKG-0143

Wizja jest wiążącym kierunkiem produkcyjnym. Nie zmienia jeszcze scen,
skryptów, stanu zapisu, geometrii ani Content Lock 3.0 na dysku. Najbliższa
praca ma najpierw stworzyć plan realizacji i bramkę pionowego wycinka; dopiero
po tym wolno przebudowywać kampanię.
