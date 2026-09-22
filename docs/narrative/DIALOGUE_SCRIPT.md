# Biblia dialogowa i kluczowe rozmowy

## Aktywny dialog po audycie / PKG-0239 / 2026-09-22

Źródłem wykonania są `scripts/levels/creative_scene_lines.gd`, otwarcia
`.tscn` i guidance stacji. Lokatory oraz granice potwierdzenia:
`docs/narrative/NARRATIVE_FIX_IMPLEMENTATION.md`. Poniższy dawca nie
przywraca starej numeracji ani sprzecznego aktywnego brzmienia.

Lena nie mówi o sterowaniu nią, konstrukcji sekcji i przeglądaniu creditsów.
Zamiast deklarować świadomość decyzji, nazywa ryzyko impulsu. Marta odpowiada
na schowaną kartkę, nie zatwierdza jej etyczności. Wierzbicka broni lokalnego
poranka i własnego zakresu pomiaru; Lena pyta o pominiętych ludzi. Miejscowa
przyznaje własne ryzyko przed późniejszą ingerencją UCP.

Zgoda obejmuje prośbę, zakres, koszt i odpowiedź na jedną metodę. Zapis
następuje w `_on_narrative_dialogue_finished()` stacji 17/18. Odczyt ryzyka
nie daje zgody. Wskazówka obsługi ma własny podpis `WSKAZÓWKA`. Odmowa
nie znika przy powrocie. Po odmowie podłączenia dopuszczona jest wyłącznie
nowa propozycja samego odczytu do B; Jakub może odmówić także jej.

Miejscowa Marta oddziela ratunek, synchronizację i przebaczenie. Pełny zapis
nie daje automatycznie klucza. Domowa Marta słyszy własną rozmowę w A/C;
nie dziedziczy `marta_truth_state` miejscowej. Po koszcie 16 miejscowa Marta
nadal kończy zdanie o kaloryferze; przybyła może poznać treść z powtórzenia,
lecz nie odzyskuje wspomnienia pierwszej dzisiejszej wypowiedzi.

W finale podpisy `RÓWNIA — ...` oznaczają odrębną perspektywę osoby lub
dokumentu, nie nowy kanał odbioru po zamknięciu A/B. B używa starego echa
i niewysłanego „Jadę”. Czytelność przejść perspektywy w wykonaniu
nie została potwierdzona przez samo dopisanie tekstu.

## Dostarczone rozmowy CR-A / PKG-0193

Aktywne 09–13 korzystają z `scripts/levels/creative_scene_lines.gd` i
lokalnego `creative_scene_presentation.gd`; szczegółowa mapa:
`docs/rebuild/PKG_0193_CREATIVE_SCENES.md`. Poniższe rozmowy adresów legacy
pozostają dawcą. W 10 Marta chce zachować kontrolę nad telefonem i dotykiem;
Lena chce wyjść po zapis pracy. W 12 Jakub chce skończyć napęd przed końcem
zmiany; nie jest zobowiązany pokazać blizny. W 13 Marta pyta o swoją partnerkę,
a Lena jawnie odpowiada „Nie wiem”. Nowy tekst jest po polsku; nie stanowi
pełnej lokalizacji EN. Dialogi nie nadpisują otwarcia ani winiety, a
zatwierdzanie kolejnych kwestii nie aktywuje MRP pod panelem.

Status: **MATERIAŁ ŹRÓDŁOWY P9 — GŁOSY I AGENDY ZACHOWANE; RUNTIME DIALOGUE DO REWRITE**  
Data: 2026-08-31

Dokument nie jest pełnym plikiem lokalizacji. Ustala agendy, różnice głosów,
progi wiedzy, kluczowe wymiany i zasady wewnętrznego głosu. Implementacja
poszczególnych wycinków może skracać kwestie, ale nie może zmieniać celu sceny,
wiedzy postaci ani relacji bez aktualizacji kanonu.

## 1. Reguły dialogu

1. Każda postać chce w rozmowie czegoś konkretnego teraz.
2. Dwie osoby nie wygłaszają wspólnie tezy dokumentacji. Ich agendy muszą się
   różnić choćby sposobem, tempem albo ceną.
3. Fakt najpierw pojawia się w świecie lub czynności. Dialog może go podważyć,
   nazwać albo użyć, lecz nie materializuje dowodu.
4. Postać może kłamać, unikać i mylić się wyłącznie z ustanowionego powodu.
5. Cisza, cofnięta ręka, przerwany gest i zmiana dystansu są pełnoprawną
   odpowiedzią.
6. Relacja nie jest streszczana zdaniem `jesteśmy blisko`. Widać ją po prawie
   do skrótu, granicy, wspólnym konkrecie i tym, czego nie trzeba tłumaczyć.
7. Po silnej kwestii kamera i tekst zostawiają miejsce na reakcję. Druga postać
   nie dopowiada natychmiast jej znaczenia.
8. W aktywnej trasie przed syntezą 13 nikt nie używa słownika obcego świata.
   W 14 nazwy następują po obu zachowaniach; mały koszt zostaje rozegrany w 16.
9. Centralna rozmowa ma najwyżej 8–14 krótkich wymian pomiędzy działaniami.
   Informacja, którą można pokazać urządzeniem, nie zostaje monologiem.
10. Po usunięciu etykiet mówiących głosy nadal powinny być rozróżnialne.

## 2. Głosy i agendy

### Lena Wolska — przybyła

- **Rytm:** krótkie zdanie faktu, poprawka, następny test. Pod presją urywa
  czasownik albo liczy.
- **Słownictwo:** sprawdzić, porównać, powtórzyć, źródło, czas, numer. Żargon
  znika, gdy wreszcie mówi o własnym pragnieniu.
- **Agenda:** odzyskać sprawczość i nie dać się uznać za chorą, kopię albo stan
  systemu.
- **Unik:** proponuje pomiar, gdy pytanie dotyczy winy, żałoby lub bliskości.
- **Zmiana głosu:** początkowo mówi `jeszcze raz`; później potrafi powiedzieć
  `nie wiem` bez natychmiastowego wypełnienia ciszy.

Nie używa błyskotliwych one-linerów w chwili straty. Jej precyzja ma koszt:
czasem brzmi chłodno wobec osoby, którą właśnie mierzy.

### Marta Kurek — Rówień

- **Rytm:** pytania konkretne, domowe czasowniki, krótkie polecenia. Gdy się
  boi, porządkuje przedmioty; gdy jest zła, przestaje poprawiać bałagan.
- **Słownictwo:** klucz, kubek, łóżko, telefon, wrócić, powiedzieć. Nie mówi
  terminami UCP, jeśli nie musi.
- **Agenda:** dowiedzieć się, gdzie jest partnerka i ochronić jej prawo do
  własnego życia.
- **Unik:** próbuje najpierw naprawić sytuację praktycznie, zanim przyzna, że
  może nie rozpoznawać osoby w znajomym ciele.
- **Granica:** nie daje przybyłej Lenie intymności, danych ani zgody w imieniu
  miejscowej.

### Jakub Wolski — Rówień

- **Rytm:** zwyczajny, suchy humor i język warsztatu. Kiedy ktoś używa go jak
  symbolu, żart znika i zdanie staje się proste.
- **Słownictwo:** przewód, rygiel, zmiana, ręce, warsztat, dość. Zna technikę
  Linii 4, nie pełną teorię Podstruktury.
- **Agenda:** znaleźć siostrę, zachować własne życie i samemu określić zakres
  pomocy.
- **Unik:** odsuwa lęk żartem, dopóki Lena nie mówi do niego jak do zmarłego.
- **Granica:** nie pokazuje ciała, nie oddaje sygnału i nie „spłaca” ocalenia bez
  świadomej decyzji.

### Dr Helena Wierzbicka

- **Rytm:** pełne, spokojne zdania, precyzyjne kwalifikatory i strona
  bezosobowa.
- **Słownictwo:** stan, zakres, stabilność, dopuszczalne odchylenie, procedura.
- **Agenda:** odzyskać próbkę, zamknąć przeciek i utrzymać Rówień.
- **Unik:** usuwa wykonawcę i ofiarę ze zdania: `wynik został odrzucony`, nie
  `odrzuciłam człowieka`.
- **Pęknięcie głosu:** gdy Lena nazywa osobę spoza zakresu, Wierzbicka zaczyna
  mówić w pierwszej osobie, choćby na jedno zdanie.

### Miejscowa Lena — zapis / sygnał

- **Rytm:** podobna precyzja do przybyłej Leny, więcej warunków, znaków
  zapytania i instrukcji przerwania.
- **Słownictwo:** odpowiedź, dwie strony, przerwij, zgoda, korekta.
- **Agenda:** uzyskać zewnętrzny dowód eksportu kosztów i wrócić do swojej
  relacji.
- **Unik:** wierzy w zabezpieczenie proceduralne dłużej, niż powinna; nie mówi
  w notatkach o lęku przed Martą.
- **Forma:** nie wygłasza gotowego monologu z Podstruktury. Istnieje przez log,
  korektę sygnału, krótką odpowiedź i konsekwencje wcześniejszej decyzji.

## 3. Powierzchnie tekstu

- wypowiedź: `IMIĘ // MÓWI`;
- telefon/radio: `IMIĘ // TELEFON` albo `IMIĘ // RADIO`;
- myśl: `LENA // MYŚL`;
- urządzenie: prawdziwa nazwa źródła, bez udawania narratora;
- pomoc L4: `WSKAZÓWKA`, oddzielona od głosu Leny;
- zapis miejscowej Leny: nazwa urządzenia lub `NOTATKA`, nie portret ducha.

Tekst myśli pozostaje krótszy od dialogu. Wszystkie powierzchnie renderują się
ostro nad kompozytorem świata i respektują tempo, skalę oraz pauzę.

## 4. Myśl: fakt, obrona, korekta

Wewnętrzny głos nie jest chodzącym poradnikiem. Każdy beat narracyjny ma
osobne pola:

| Warstwa | Prawda | Funkcja |
|---|---|---|
| obserwacja | zawsze prawdziwa | nazywa widoczny fakt |
| interpretacja | może być błędna | pokazuje aktualną obronę lub hipotezę Leny |
| zamiar | mechanicznie uczciwy | wskazuje bezpieczny następny test |

Błędna interpretacja musi przewidywać coś, co gracz może sprawdzić. Po nowym
dowodzie myśl zostaje zmieniona, nie powtórzona. Systemowa pomoc nigdy nie
podszywa się pod emocję Leny.

### Drabina błędów Leny

| Station | Fakt | Szczera, możliwie błędna interpretacja | Co ją koryguje |
|---|---|---|---|
| 06 | dwie trasy z tą samą datą | `Cache. Najprostsze.` | domofon i klucz nie są cache'em |
| 07 | sprzedawca zna imię i Martę | `Imię zobaczył na karcie.` | zna wczorajszy zakup bez transakcji Leny |
| 08 | nazwisko jest pod innym numerem | `Ktoś przełożył numery.` | klucz i sąsiadka potwierdzają lokalny adres |
| 11 | zdjęcie pokazuje Martę jako partnerkę | `Marta nie zrobiłaby takiego zdjęcia.` | Marta przychodzi do wspólnego domu |
| 14 | Marta chce zabezpieczyć telefon | `Chce mnie uspokoić, nie słuchać.` | Lena sama przerywa odpowiedź o wspomnieniu |
| 18 | dwa rejestry pokazują żywego Jakuba | `Mogą kopiować ten sam błąd.` | ciało, praca i odmienne prywatne wspomnienie |
| 31 | adaptacja obiecuje znajomy dom | `Mogę zostać tylko na chwilę.` | procedura usuwa sprzeczne wspomnienia |
| 36 | UCP łączy dwa wypadki | `Wierzbicka zabiła Jakuba.` | zapis pokazuje wybór ryzyka, nie prostą pojedynczą przyczynę |

## 5. Sekwencja I — zwykły konflikt

### Station 01 — dyspozytor

> **DYSPOZYTOR // RADIO:** Brakuje trzech sekund. Wpisz czujnik i zamknij.
>
> **LENA:** Mocowanie jest dobre.
>
> **DYSPOZYTOR:** Lena, jest po czasie.
>
> **LENA:** Właśnie dlatego jeszcze raz.

Po czystym odczycie:

> **LENA // MYŚL:** Próbka jest. Teraz do Marty.

Nie pada imię Jakuba. Karta Linii 4 i reakcja Leny wykonują pracę zapowiedzi.

### Station 03 — wiadomość Marty

> **MARTA // WIADOMOŚĆ:** Miałaś wrócić. Napisz tylko, czy jedziesz. Bez
> raportu.

[Lena wpisuje `Przepraszam, sygnał...`, kasuje.]

> **LENA // WIADOMOŚĆ:** Jadę.

Ta sama wiadomość brzmi wiarygodnie zarówno między domowymi przyjaciółkami,
jak i między partnerkami Równi. Nie jest sztuczną zagadką.

## 6. Sekwencja II — racjonalizacja

### Station 06 — rozkłady

> **LENA // MYŚL — obserwacja:** Ta sama data. Dwie trasy.
>
> **LENA // MYŚL — interpretacja:** Cache. Najprostsze.

Po dłuższym zastoju:

> **LENA // MYŚL — zamiar:** Sprawdzę numer wersji na papierze.

### Station 07 — sprzedawca

> **SPRZEDAWCA:** Zwykła dla pani, jaśminowa dla Marty?
>
> **LENA:** Skąd pan zna Martę?
>
> **SPRZEDAWCA:** Bo wczoraj tu była. Co się stało?
>
> **LENA:** Nic. Poproszę wodę.

Sprzedawca nie odpowiada zagadką i nie naciska. Lena kończy rozmowę, ponieważ
nie chce ujawnić, że utraciła kontekst.

### Station 08 — domofon

> **LENA // MYŚL — obserwacja:** Moje nazwisko. Czternaście.
>
> **LENA // MYŚL — interpretacja:** Ktoś przełożył numery.

Po otwarciu:

> **LENA // MYŚL — zamiar:** Najpierw drzwi. Potem administracja.

## 7. Sekwencja III — obca intymność

### Station 11 — zdjęcie

[Lena odwraca zdjęcie. Najpierw widzi dwa klucze na wspólnej smyczy, potem
ramiona i twarze.]

> **LENA // MYŚL — obserwacja:** To Marta. To ja.
>
> **LENA // MYŚL — interpretacja:** Nie zrobiłaby takiego zdjęcia.

Nie dodajemy myśli `to życie innej Leny`.

### Station 12 — wiadomość głosowa

> **MARTA // WIADOMOŚĆ:** Nie idź znowu sama do Wierzbickiej. Oddzwoń. I nie
> mów mi rano, że zasnęłaś w laboratorium.

[Lena zatrzymuje nagranie na słowie `znowu`, cofa i słucha bez dodatkowej
kwestii.]

### Station 13 — dwa dokumenty

> **LENA // MÓWI:** Ten był ze mną w terenie.
>
> **LENA // MYŚL — obserwacja:** Dwa adresy. Jeden dzień.
>
> **LENA // MYŚL — zamiar:** Marta opisze dzień bez tych papierów.

## 8. Sekwencja IV — Marta i UCP

### Station 14 — próg

> **MARTA:** Odłóż torbę.
>
> **LENA:** Zostanie przy drzwiach.

[Marta wyjmuje drugi kubek, patrzy na Lenę i odkłada go z powrotem do szafki.]

> **MARTA:** Gdzie byłaś od rana?
>
> **LENA:** Przy torach.
>
> **MARTA:** Nie byłaś. Odwołałaś wyjazd.
>
> **LENA:** Ja go wykonałam.
>
> **MARTA:** Nie pytam o raport. Pytam, gdzie jest Lena.

Ostatnia kwestia może jeszcze znaczyć `co się z tobą stało`, nie diagnozę
drugiej osoby.

### Station 15 — wspólna wyprawa

> **MARTA:** Po deszczu wróciłyśmy tutaj. Zostawiłaś kurtkę na kaloryferze.
>
> **LENA:** Nie wróciłyśmy.
>
> **MARTA:** Co?
>
> **LENA:** Pokłóciłyśmy się na parkingu. Potem już nie pracowałyśmy razem.

[Marta przestaje wycierać mokry blat.]

> **MARTA:** My wtedy zamieszkałyśmy razem.
>
> **LENA:** Marta...
>
> **MARTA:** Nie. Teraz ty posłuchaj.

Scena nie zostaje rozwiązana kilkoma zdaniami. Marta chce lekarza i zabezpiecza
telefon; Lena wychodzi po zapis pracy.

### Station 17 — Wierzbicka przez interkom

> **WIERZBICKA // INTERKOM:** Proszę odłożyć czytnik i zaczekać przy stanowisku.
>
> **LENA:** Kto mówi?
>
> **WIERZBICKA:** Dr Helena Wierzbicka. Urządzenie nie jest zgodne z rejestrem.
>
> **LENA:** Ja też nie.

[Pauza. Zamek drzwi zaczyna pracować.]

> **WIERZBICKA:** Dlatego proszę zaczekać.

Wierzbicka nie mówi, skąd pochodzi Lena ani co zrobi przejście.

## 9. Sekwencja V — Jakub i rozpoznanie

### Station 19 — telefon

> **JAKUB // TELEFON:** Lena? Marta mówi, że zniknęłaś z biura.
>
> **LENA:** Co było pod schodami u babci?
>
> **JAKUB:** Słoiki. I twój hełm z garnka. Nadal sprawdzasz ludzi jak zamki?
>
> **LENA:** Co powiedziałeś mi w tunelu?
>
> **JAKUB:** W którym tunelu?

[Lena rozłącza się. Nie ma natychmiastowej myśli wyjaśniającej.]

### Station 20 — spotkanie

> **JAKUB:** Marta powiedziała, że pamiętasz mój pogrzeb.
>
> **LENA:** Nie musiała ci tego mówić.
>
> **JAKUB:** Nie musiała.

[Lena patrzy na jego lewy bok.]

> **LENA:** Pokaż bliznę.
>
> **JAKUB:** Nie.
>
> **LENA:** Muszę sprawdzić—
>
> **JAKUB:** Możesz zapytać. Nie możesz mnie sprawdzać bez końca.

Po dobrowolnym skanie czytnika:

> **JAKUB:** Tego numeru nie ma w naszej bazie.
>
> **LENA:** Baza może być zmieniona.
>
> **JAKUB:** Pewnie. Moje trzydzieści cztery lata też?

Jakub brzmi jak człowiek zmęczony sytuacją, nie rzecznik tematu.

### Station 21 — synteza

[Gracz układa źródła. Po każdym Lena lub inna postać nazywa tylko to, co dane
źródło dowodzi.]

> **LENA:** Ten czytnik nie istnieje tutaj.
>
> **JAKUB:** A lokalny test zaczął się w tej samej sekundzie.
>
> **MARTA:** Jej test. Nie twój.

[Ostatnie porównanie: publiczna historia Jakuba i prywatna rozbieżność. Cisza.]

> **LENA // MÓWI:** To nie jest mój świat.

[Marta nie podchodzi.]

> **MARTA:** Więc gdzie jest ona?
>
> **LENA:** Nie wiem.

To jest koniec pierwszej tajemnicy i początek drugiej. Nie pada jeszcze teza o
rozerwaniu świata ani kosztach powrotu.

## 10. Sekwencja VI — działanie i zgoda

### Station 22 — oferta UCP

> **WIERZBICKA:** Mamy procedurę dla tego stanu.
>
> **LENA:** Dla mnie?
>
> **WIERZBICKA:** Dla stanu.
>
> **MARTA:** Ona ma imię.
>
> **WIERZBICKA:** W rejestrze już jedno jest.

Po pokazaniu dwóch zachowań sygnału:

> **LENA:** Ten trzyma wybrany związek. Kotwiczy.
>
> **JAKUB:** A ten drugi?
>
> **LENA:** Odpuszcza wynik. Czeka na odpowiedź.
>
> **MARTA:** Nie nazywaj jeszcze tego bezpiecznym.

> **LENA:** Nie nazywam. Uległość. Roboczo.

### Station 24 — granice Marty

> **MARTA:** Telefon zostaje ze mną.
>
> **LENA:** Potrzebuję jej notatek.
>
> **MARTA:** Notatek. Nie jej podpisu. Nie jej łóżka. Nie mojego `tak` za nią.
>
> **LENA:** Chcę wrócić.
>
> **MARTA:** Ja chcę, żeby ona wróciła. Jeśli mamy iść razem, nie pomyl tych
> dwóch zdań.

Marta mówi o konkretnych granicach, a dopiero potem nazywa różnicę celów.

### Station 26 — interwencja

> **REJESTRATOR:** KONTAKT WZAJEMNY — 20:40:03
>
> **REJESTRATOR:** ANCHOR LOCAL PRESENCE — H. WIERZBICKA
>
> **LENA:** Najpierw odpowiedź. Potem kotwica.
>
> **WIERZBICKA // INTERKOM:** Najpierw niekontrolowany kontakt. Potem procedura.
>
> **LENA:** Procedura wciągnęła mnie tutaj.
>
> **WIERZBICKA:** Procedura utrzymała ten świat.

Obie mówią o tym samym następstwie i nadają mu inną wartość.

### Station 27 — odpowiedź miejscowej Leny

> **LENA:** Dwie równe. Trzecia z błędem.

[Odpowiedź poprawia trzecią próbę.]

> **LENA // MYŚL — obserwacja:** Echo nie poprawia pomiaru.
>
> **LENA // MYŚL — zamiar:** Zachowaj oba ślady. Nie odpowiadaj drugi raz.

### Station 29 — odmowa Jakuba

> **JAKUB:** Odłącz to ode mnie.
>
> **LENA:** Jeszcze nic nie uruchomiłam.
>
> **JAKUB:** Mówisz tak, kiedy już policzyłaś.

[Lena wyłącza kanał.]

> **LENA:** Dobrze. Od początku. Potrzebuję twojej zgody na krótki odczyt.
>
> **JAKUB:** Najpierw powiedz, co może mi zabrać.

## 11. Sekwencja VII — prawda i relacje

### Station 31 — adaptacja

> **WIERZBICKA:** Zachowamy ciało, adres i relacje. Sprzeczne wspomnienia
> wygasną.
>
> **LENA:** Czyje relacje?
>
> **WIERZBICKA:** Te, które już są stabilne.

[Lena widzi swój profil z dopiskiem miejscowej Leny.]

> **LENA // MYŚL — interpretacja:** Mogę wejść tylko po dane.

Po zobaczeniu procedury kasowania:

> **LENA // MYŚL — korekta:** `Tylko na chwilę` też jest zgodą.

### Station 33 — procedura miejscowej Leny

> **NOTATKA:** DWIE STRONY / DWA ODCZYTY / BRAK ODPOWIEDZI = PRZERWIJ
>
> **NOTATKA:** BRAK ZGODY PO DRUGIEJ STRONIE. ABORT PO 3 S.
>
> **NOTATKA:** JEŚLI ZAKOTWICZĄ OBECNOŚĆ — NIE KOTWICZ CZŁOWIEKA.

> **LENA:** Wiedziała, że ktoś może odpowiedzieć.
>
> **MARTA // RADIO:** Wiedziała czy zapytała?

[Lena nie odpowiada za miejscową Lenę.]

### Station 35 — echo domu

> **MARTA DOMOWA // NAGRANIE:** Lena, odbierz. Nie jestem zła. Dobra, jestem.
> Odbierz mimo to.

[Lena wyłącza nagranie przed kolejną próbą odtworzenia.]

> **LENA // MYŚL:** Marta czekała. Ja znowu mierzyłam.

To nie jest obiektywne obwinienie, tylko szczera ocena własnego wzoru.

### Station 36 — rejestr Linii 4

> **WIERZBICKA:** Tunel został utrzymany. Dwieście siedem osób wyszło.
>
> **LENA:** Gdzie poszła różnica?
>
> **WIERZBICKA:** Poza zakresem aparatury.
>
> **LENA:** Mój brat był poza zakresem.

[Wierzbicka po raz pierwszy odpowiada bez strony bezosobowej.]

> **WIERZBICKA:** Widziałam korelację. Nie widziałam człowieka.
>
> **LENA:** Nie szukała pani.

Rozmowa nie rozstrzyga metafizycznej winy. Rejestr pokazuje świadomy wybór
zakresu i ukrycie kosztu.

### Station 37 — Jakub po prawdzie

> **JAKUB:** Nie będę umierał za niego.
>
> **LENA:** Nie proszę.
>
> **JAKUB:** Jeszcze nie.

[Lena przedstawia dokładny zakres synchronizacji albo ukrywa część.]

Wariant po pełnej prawdzie:

> **JAKUB:** Dziesięć sekund. Mój nadajnik, moja ręka na wyłączniku.
>
> **LENA:** Dziesięć.

Wariant po zatajeniu:

> **JAKUB:** Przyszłaś po odczyt, a teraz każesz mi podpisać protokół in blanco. Nie ze mną, Lena.

### Station 38 — Marta i miejscowa Lena

> **MARTA:** Ona wiedziała?
>
> **LENA:** Wiedziała, że ktoś może odpowiedzieć.
>
> **MARTA:** To nie jest to samo pytanie.

[Lena pokazuje warunek abortu i interwencję Wierzbickiej albo przemilcza
niewygodny fragment.]

Po pełnej prawdzie:

> **MARTA:** Pomogę ją wyciągnąć. Potem odpowie mi sama.

Po częściowej prawdzie:

> **MARTA:** Dam ci dostęp do ratunku. Nie do decyzji za nią.

Po zatajeniu wykrytym przez Martę:

> **MARTA:** Zabierz swój czytnik. Jej sygnału nie dostaniesz.

## 12. Sekwencja VIII — zamiar i skutek

### Station 39 — wypowiedzenie metody

Kwestia nazywa działanie i jawny brak, nie ocenę moralną.

Wymuszenie:

> **LENA:** Ustawiam domowy numer. Jeśli zamknie drugi sygnał, nie będę mogła
> go otworzyć z domu.

Zamknięcie Równi:

> **LENA:** Najpierw sprowadzę ją do jej adresu. Dla mnie zostanie przejście bez
> numeru.

Przejście wzajemne:

> **LENA:** Otworzę tylko na odpowiedź. Każda z nas wybierze stronę. Most może
> zostać.

Wierzbicka odpowiada zgodnie z celem, nie jako głos „złego zakończenia”:

> **WIERZBICKA:** Stabilność nie zaczeka, aż wszyscy wyrażą zgodę.
>
> **LENA:** Wiem. Dlatego zapisuję, kogo pani pomija.

### Station 40 — ostatnie zatwierdzenie

Przed akcją tekst pokazuje konkretne ryzyko i stan zgód. Po zatwierdzeniu nie ma
żartów, nowego dialogu ekspozycyjnego ani pytania `czy na pewno?` drugi raz.

Możliwe krótkie kwestie działań:

> **MARTA:** Sygnał jest stabilny. Nie trzymaj go dłużej.
>
> **JAKUB:** Dziesięć sekund. Liczę.
>
> **WIERZBICKA:** Wygaszam sektor trzeci.
>
> **LENA:** Teraz.

### Station 41 — rozpoznanie wyniku

> **LENA // MYŚL — obserwacja:** Czytnik odpowiada.

Druga myśl zależy od źródła i nie interpretuje całej kosmologii:

- 42A: `Numer domowy. Brak drugiej odpowiedzi.`
- 42B: `Jej adres wrócił. Mój zniknął.`
- 42C: `Dwa adresy. Most nie zgasł.`

## 13. Epilogi bez sentencji

Ostatnie słowa kończą się czynnością lub pytaniem relacji.

### 42A

> **MARTA DOMOWA:** Gdzie byłaś?

[Lena kładzie czytnik na stole. Ekran proponuje `BŁĄD CZUJNIKA`.]

> **LENA:** Najpierw posłuchaj próbki.

### 42B

[Miejscowa Lena staje w drzwiach numeru 14. Marta trzyma klucz, ale go nie
oddaje.]

> **MARTA:** Co wiedziałaś przed testem?

[Cięcie do przybyłej Leny na obcym przystanku. Wysyłana wiadomość nadal brzmi
`Jadę`, lecz nie ma adresata w sieci.]

### 42C

[W domu przybyłej Leny telefon pokazuje szczegół zdjęcia z numeru 14, którego
tu nie wykonano.]

> **MARTA DOMOWA:** Znam ten kubek.
>
> **LENA:** Nie masz go.

[Obie patrzą na pustą półkę.]

## 14. Myśli awaryjne i pomoc

| Stan | L2 — kontekst | L3 — kierunek | L4 — pomoc systemowa |
|---|---|---|---|
| brak zauważenia | prawdziwy detal sensoryczny | nazwany obiekt | semantyczna czynność i powód |
| zła hipoteza | jej sprawdzalne przewidywanie | test rozróżniający | kolejność testu bez wyniku |
| konflikt relacji | konkret gestu lub granicy | osoba, której trzeba odpowiedzieć | brak automatycznej „poprawnej kwestii” |
| mechanika po 22 | widoczny koszt bieżącego stanu | brakujący warunek | działanie, nie moralna rada |
| finał | stan osób i sygnałów | niedostępny warunek jest jawny | L4 nie otwiera zakończenia poza stanem |

Cooldown, `once_per_state`, pauza, dialog i restart pozostają zgodne z
`PLAYER_GUIDANCE_AND_INNER_VOICE.md`. Pomoc L4 nie jest głosem Leny i nie może
wybrać relacyjnej odpowiedzi za gracza.

## 15. Kontrola wdrożenia

- Każda kwestia ma scene ID, mówiącego, agendę i warunek wiedzy.
- Test słownika blokuje przedwczesne nazwanie świata/metod.
- Test wiedzy sprawdza, czy publiczne źródła pozyskuje Lena, a bazę techniczną
  interpretuje Jakub dopiero po ustanowieniu zawodu.
- Dialog Station 21 nie mówi o koszcie, którego nikt jeszcze nie poznał.
- Imię i nazwisko `Marta Kurek` są jednolite.
- Miejscowa Lena nie przemawia pełnym, wszechwiedzącym monologiem.
- Wypowiedzi są przeplatane działaniem, gestem i ciszą; nie każda linia ma
  mechaniczny tag emocji.
- Tekst jest ostry ponad Pixel-Stage, dostępny w skali 85–115% i bez overlapu.
- Automaty nie dowodzą naturalności, podtekstu, chemii relacji ani emocji.
