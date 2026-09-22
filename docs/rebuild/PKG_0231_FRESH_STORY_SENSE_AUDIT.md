# PKG-0231 — świeży audyt sensu fabularnego aktywnej kampanii

Data: 2026-09-14  
Zakres: aktywny runtime `01–18 → 42A/B/C → 43`  
Tryb: read-only względem kodu, scen i treści gry; pakiet dokumentacyjny  
Werdykt: **STORY-SENSE CONCERNS — blokada PRODUCT GO pozostaje**

## 1. Zasada i niezależność audytu

Audyt powstał na bezpośrednim odczycie aktualnych scen, skryptów stacji,
`GameStateManager`, progów, powrotów, prezentacji dialogów i danych aktywnej
kampanii. Celowo nie czytano wcześniejszych analiz fabularnych, audytów,
raportów naprawczych, snapshotów ani testu narracyjnego PKG-0230. Obowiązkowe
dokumenty produktu wykorzystano tylko do ustalenia aktywnej trasy i kontraktu.

Nie oceniano stacji 19–41 jako części bieżącej kampanii. Są zasobami legacy;
aktywny przebieg definiuje `CAMPAIGN_ROUTE` w
`scripts/core/game_state_manager.gd:242-257`.

To nie jest playtest i nie dowodzi emocji, zabawy ani zrozumienia przez nową
osobę. Jest to audyt struktury przyczynowej, wiedzy, dialogu i geografii na
podstawie źródeł runtime.

## 2. Werdykt w jednym zdaniu

**Rdzeń opowieści ma sens w pełnym, idealnym przebiegu, ale gra nie gwarantuje,
że pokazane skutki wynikają z wykonanych działań: otwarte progi pozwalają ominąć
przyczyny, następne sceny często zakładają pominiętą wiedzę, a finał i epilog
można osiągnąć bez wyboru, wykonania i odczytania konsekwencji.**

Dlatego obecny stan jest technicznie przechodni, lecz fabularnie nie może
otrzymać PRODUCT GO.

## 3. Co już ma sens i należy zachować

### 3.1. Kręgosłup historii

Pełna ścieżka tworzy czytelny ciąg:

1. Lena wybiera między rzetelną próbką a obietnicą złożoną Marcie (`01`).
2. Wraca przez realne obejście, przystanek, Linię 4 i znaną ulicę (`02–05`).
3. Zwyczajne źródła podważają jej pamięć: rozkład, sprzedawca, adres, domofon,
   sąsiadka i działający klucz (`06–08`).
4. Domowe, instytucjonalne i relacyjne dowody budują odmienną ciągłość:
   wspólne życie z Martą, lokalny profil Leny i żywy Jakub (`09–13`).
5. Lena uczy się Anchor/Yield przez obserwację skutku, bada sygnał miejscowej
   Leny, płaci mały koszt i dopiero potem przechodzi do rachunku oraz zgód
   (`14–17`).
6. Zestawia prognozy, mówi lub wstrzymuje prawdę wobec Marty i wybiera metodę
   (`18`).
7. Wariant 42 pokazuje konsekwencję, a 43 stan miasta po rozstrzygnięciu.

To jest sensowna konstrukcja filmu: prywatny obowiązek przechodzi w śledztwo,
śledztwo w odpowiedzialność, a odpowiedzialność w wybór.

### 3.2. Najmocniejsze odcinki

- `05–08`: eskalacja przez źródła mające własne funkcje w świecie. Sprzedawca
  sprzedaje wodę, sąsiadka wykonuje domową czynność, zamek i kod działają.
- `09–13`: trzy rodziny dowodów są od siebie różne; Jakub odmawia pokazania
  blizny, lecz oferuje sprawdzenie numeru (`creative_scene_lines.gd:26-29`).
- `14`: nazwa mechaniki pada dopiero po wykonaniu obu zachowań
  (`station_14.gd:255-270`).
- `15`: dwa impulsy kontrolne i celowy błąd są uczciwym eksperymentem
  odróżniającym nagranie od żywej odpowiedzi (`station_15.gd:176-325`).
- `16–18`: mały koszt, echo domu, rejestr par, zgoda i prognozy tworzą logiczny
  łańcuch warunków (`station_16.gd:149-241`, `station_17.gd:135-223`,
  `station_18.gd:176-386`).
- Kierunek podstawowej trasy jest konsekwentny: postęp w prawo, powrót w lewo;
  powroty `12→13` i `17→18` prawidłowo wchodzą od prawej
  (`game_state_manager.gd:613-623`).

## 4. Model wiedzy — gdzie opowieść się rozszczelnia

### 4.1. P0 — następne sceny zakładają wiedzę, którą wolno pominąć

`GameStateManager` instaluje próg dla każdej aktywnej stacji i odracza
`GapLedger.ensure_exit_open()` (`game_state_manager.gd:1788-1802`). Funkcja ta
wywołuje lokalne odblokowanie oraz ustawia `Threshold.is_open = true`
(`scripts/campaign/gap_ledger.gd:280-294`). W rezultacie można opuścić adres bez
lokalnego łańcucha działań.

Samo pomijanie nie musi być błędem. Błędem jest to, że następne otwarcia mówią
tak, jakby pominięte fakty zostały zdobyte. Przykłady:

- `station_14.tscn:68-71` otwiera się zdaniem „Próbę o 20:40 ktoś przerwał z
  zewnątrz”, mimo że ten fakt dopiero zapisuje odczyt logu w późniejszej stacji
  15 (`station_15.gd:176-184`, `creative_scene_lines.gd:40`). Jest to także
  **odwrócenie chronologii** nawet w pełnym przebiegu: 14 wie to, co 15 dopiero
  odkrywa.
- `station_17.tscn:60-64` stwierdza, że echo domu wykluczyło zamianę, choć można
  pominąć analizator i odbiornik w 16.
- `station_18.tscn:70-73` zapowiada powrót, trzy drogi i rozmowę z Martą, mimo że
  rejestr oraz zakres zgody w 17 mogą być pominięte.

To najważniejszy problem całej kampanii: istnieją dwie wersje fabuły — pełna i
legalnie skrócona — lecz dialog napisano tylko dla pełnej.

### 4.2. P0 — bezpośrednia sprzeczność Leny wobec UCP

W rozmowie z Martą Lena mówi: „Nie pracuję w UCP”
(`creative_scene_lines.gd:22`). Po tej samej scenie myśl wyjściowa brzmi:
„W UCP, tam pracuję” (`station_10.gd:90-93`), chociaż lokalny profil potwierdza
dopiero biometryka w 11 (`creative_scene_lines.gd:23`).

To nie jest subtelna zmiana hipotezy, lecz sprzeczność stanu wiedzy. Prawidłowa
intencja powinna brzmieć: „Marta twierdzi, że pracuję w UCP. Sprawdzę zapis”.

### 4.3. P1 — zaświadczenie mieszkania 12 pojawia się bez pochodzenia

Stacja 07 zaczyna od „mojego zaświadczenia” podającego Sadową 7 m. 12
(`station_07.tscn:57-74`, `station_07.gd:74-85`). W aktywnych stacjach 01–06 nie
ma sceny pozyskania ani wcześniejszego ustanowienia tego dokumentu. Dokument
następnie staje się niesionym dowodem przy stole w 13
(`creative_scene_lines.gd:113-123`).

Dokument jest logicznie użyteczny, ale wchodzi do filmu jak rekwizyt wyjęty
spoza kadru. Potrzebuje jednego wcześniejszego, materialnego źródła — najlepiej
w torbie od początku albo jako element zlecenia w 01.

### 4.4. P1 — wniosek „to nie jest mój świat” jest o krok silniejszy od dowodu

Dom, rejestry i Jakub bardzo mocno dowodzą, że publiczna i relacyjna ciągłość
nie zgadza się z pamięcią oraz czytnikiem Leny. Nie wykluczają jednak wprost
manipulacji pamięci, podmiany tożsamości lub instytucjonalnego fałszerstwa.
Linia „To nie jest mój świat” (`creative_scene_lines.gd:29`) jest przekonującą
hipotezą Leny, lecz runtime od razu zapisuje ją jako `world_recognized`
(`station_13.gd:344-363`).

Nie jest to twarda sprzeczność. Jest to luka inferencyjna. Wystarczy jeden
niezależny fakt niemożliwy do wyjaśnienia samą pamięcią lub fałszerstwem albo
zmiana sformułowania na „To nie jest ciągłość, z której przyszłam”.

### 4.5. P1 — status czytnika po UCP jest nierozstrzygnięty

Wierzbicka mówi, że czytnik pozostaje do sprawdzenia; Lena odpowiada, że zostaje
z nią i wychodzi z minimalnym wyciągiem (`creative_scene_lines.gd:25`). Brakuje
reakcji osoby lub procedury mającej władzę zatrzymać urządzenie. Następne sceny
traktują czytnik jako legalnie niesiony materiał.

Potrzebne jest krótkie proceduralne rozstrzygnięcie: zgoda warunkowa, protokół
depozytu albo jawne ryzyko wyniesienia urządzenia wbrew procedurze.

## 5. Przyczynowość scen i decyzji

### 5.1. P0 — Station 18 ma ukrytą domyślną decyzję A

Jeżeli gracz przekroczy otwarty próg 18 bez zatwierdzenia metody,
`complete_station()` wybiera `station_42a` i zapisuje ją jako finał
(`game_state_manager.gd:626-641`). Nie zapisuje jednak odpowiadającej metody.

Powstaje przebieg:

`brak prognoz → brak rozmowy z Martą → brak metody → domyślne 42A`.

To przeczy sensowi sceny 18 oraz zasadzie, że nieodwracalny skutek wynika z
jawnej decyzji. Brak decyzji musi pozostać brakiem i zatrzymać routing albo
prowadzić do jawnego wariantu „nierozstrzygnięte”, nigdy do A.

### 5.2. P0 — finały pozwalają zapisać skutek przed przyczyną

Warianty 42 mają trzy działania w porządku lewo→prawo, lecz ich funkcje
sprawdzają głównie zgodność metody, nie wcześniejsze działanie lokalne:

- 42A: odczyt zapieczętowanej Leny i skutek gospodarstwa nie wymagają wykonania
  rygla (`station_42a.gd:176-253`).
- 42B: odzyskanie miejscowej Leny i skutek nie wymagają zamknięcia przepływu
  (`station_42b.gd:196-279`).
- 42C: odczyt przecieku i skutek nie wymagają otwarcia wzajemnego przejścia
  (`station_42c.gd:199-286`).

Dodatkowo globalnie otwarty próg pozwala opuścić każdy wariant bez żadnego z
tych działań. Epilog może więc nastąpić po metodzie jedynie zapisanej w 18, ale
niewykonanej w 42.

Wymagany inwariant: **zatwierdzenie → wykonanie → obserwacja skutku → odczyt
relacyjny → epilog**.

### 5.3. P0 — epilog można zakończyć przed jego przeczytaniem

`inspect_blackout()` nie wymaga tablicy, napisów ani ukończonego dialogu i od
razu wywołuje `_complete_campaign()` (`station_43.gd:315-337`).

Nawet zamierzona kolejność ma błąd: dialog ma pięć linii, a wejście pokazuje
pierwszą; tablica i napisy przesuwają go tylko do linii trzeciej
(`station_43.gd:281-312`). Użycie blackout kończy kampanię bez pokazania dwóch
ostatnich linii. To właśnie ostatnie linie zawierają osobisty obraz Leny
(`station_43.gd:166-236`).

Epilog nie jest zatem rzeczywistą wypłatą konsekwencji, tylko powierzchnią,
którą można zamknąć przed wypłatą.

### 5.4. P1 — mały koszt z 16 nie wraca w finale

Stacja 16 zapisuje konkretnie rozmycie pamięci spotkania z Martą albo dokładnej
sekundy próbki (`station_16.gd:175-216`, `creative_scene_lines.gd:47-52`).
Stacje 42 i 43 nie rozgałęziają swojej treści po tym wyborze. Koszt jest realny
w chwili wyboru, lecz znika z dramaturgicznego rachunku końca.

Wystarczy jedna materialna wypłata per wariant: brakujący detal rozmowy albo
ubytek na wykresie. Nie należy dodawać punktów moralnych ani nowego systemu.

### 5.5. P1 — 43 wczytuje prawdę, zgodę i stabilność, ale prawie ich nie używa

Epilog odczytuje `marta_truth_state`, `jakub_consent_state`,
`ending_stability` i `household_consequence` (`station_43.gd:111-163`), lecz
dobór pięciu linii zależy wyłącznie od `ending_family`
(`station_43.gd:166-238`).

Warianty 42 częściowo wypłacają prawdę Marty, ale końcowy obraz miasta nie
odróżnia pełnej prawdy od wstrzymania ani pełnej zgody od ograniczonej. Nie
potrzeba dziewięciu nowych zakończeń; wystarczy jedna zmienna linia relacyjna i
jedna zmienna materialna w każdej rodzinie.

## 6. Geografia i ciągłość „jak w filmie”

### 6.1. Co jest spójne

- `01→02→03→04→05`: miejsce pracy, obejście, przystanek, wagon, domowa ulica.
- `05→06→07→08`: ulica, kiosk, fasada Sadowej 7, klatka i drzwi 14.
- `09→10`: dalsze pomieszczenia tego samego mieszkania.
- `10→11→12→13`: wyjście do UCP, warsztat Jakuba, powrót do mieszkania.
- `14→15→16→17→18`: rozdzielnia, pętla, analizator, hala rejestru, powrót na
  znaną ulicę.

Wyjątki kierunku `12→13` i `17→18` wzmacniają poczucie powrotu.

### 6.2. P1 — 13→14 nie ma uczciwego progu ani motywacji przestrzennej

13 jest mieszkaniem i używa zwykłego progu drzwiowego; 14 otwiera się w
rozdzielni Linii 4. Brakuje czynności „wyjść z domu i zejść włazem do
rozdzielni” albo krótkiego cięcia transportowego. Ponadto otwarcie 14 od razu
podaje wiedzę dopiero zdobywaną w 15.

Naprawa powinna połączyć motywację z geografią: wyciąg z UCP wskazuje
rozdzielnię/sekcję, Lena wychodzi z mieszkania, a cięcie pokazuje właz lub wejście
serwisowe. Nie należy dodawać kolejnego pełnego adresu.

### 6.3. P1 — 18→42 jest teleportem czasu, miejsca i wykonania

18 kończy się na nocnej ulicy przy słupku decyzji. Każdy wariant 42 zaczyna się
w mieszkaniu 14 o świcie, już z widocznym stanem metody. Brakuje odpowiedzi:

- gdzie Lena fizycznie wykonuje operację;
- dlaczego jej skutki materializują się właśnie w mieszkaniu;
- ile czasu minęło i jak trafiła tam Marta/Jakub;
- czy sterowana postać nadal jest przybyłą Leną.

Wymagany jest krótki most, nie nowa lokacja: zatwierdzenie uruchamia konkretną
czynność/urządzenie, cięcie pokazuje noc→świt i utrzymuje perspektywę Leny.

### 6.4. P0 — cofnięcie może uniemożliwić ponowny marsz naprzód

`complete_station()` ignoruje stację obecną już w `_handled_completions`
(`game_state_manager.gd:626-629`). Słownik jest czyszczony dopiero przy resecie
kampanii, nie przy zwykłym przejściu (`game_state_manager.gd:321,1369`).

Po ukończeniu stacji, cofnięciu przez `ReturnZone` i ponownym przekroczeniu jej
prawego progu nowa instancja stacji emituje ukończenie, ale GSM je ignoruje.
Fabularnie poprawna droga powrotna staje się jednokierunkową pułapką. To
techniczny problem nawigacji o bezpośrednim skutku geograficznym.

### 6.5. P1 — perspektywa 42B jest niejednoznaczna

42B mówi, że miejscowa Lena odzyskała ciało i dom, a przybyła Lena jest na
wiacie bez adresu (`station_42b.gd:70-81`). Jednocześnie aktywny `Player`
pozostaje fizycznie w scenie mieszkania (`station_42b.tscn:164-169`). Nie wiadomo,
czy gracz steruje miejscową Leną, projekcją przybyłej, czy ogląda montaż dwóch
miejsc.

To może być artystyczne cięcie, ale runtime nie ustanawia jego gramatyki.
Należy zachować sterowanie przy przybyłej Lenie albo jawnie przełączyć
fokalizację krótką winietą i nie udawać ciągłej przestrzeni.

## 7. Dialog i postacie

### Lena

Jej metoda myślenia jest zwykle konsekwentna: obserwuje, stawia hipotezę,
sprawdza. Największe odstępstwa to sprzeczność UCP, przedwczesna wiedza w 14 i
automatyczny wniosek o świecie. Naprawa powinna przywrócić język hipotezy tam,
gdzie dowód nie jest jeszcze rozstrzygający.

### Marta

Ma własną granicę i praktyczny cel: telefon, lekarz, mieszkanie, sprawdzenie
grafiku. To działa. Słabiej wypada przejście od alarmu medycznego w 10 do
wspólnego stołu w 13; istniejąca druga kwestia otwarcia 13 pomaga, ale jeden
krótki beat „najpierw sprawdziłam rzeczy, których nie mogłaś mi podpowiedzieć”
uczyniłby zmianę decyzją Marty, nie wygodą scenariusza.

### Jakub

Jest najbardziej konsekwentną postacią poboczną: pracuje, odmawia naruszenia
ciała, oferuje techniczny zamiennik dowodu i wraca do napędu. Problem leży nie
w jego dialogu, lecz w systemie: gracz wybiera stan jego zgody pozycją Leny przy
biurku (`station_17.gd:180-207`). Dialog może to uzasadnić, ale zgoda powinna
być przedstawiona jako odpowiedź Jakuba na jasno sformułowany zakres, nie jako
nazwa nastawy urządzenia.

### Wierzbicka / UCP

Proceduralny, bezosobowy głos jest spójny. UCP ma jednak zbyt mało oporu wobec
wyniesienia czytnika, a oferta adaptacji jest obowiązkowo odrzucana
(`station_17.gd:152-165`), nie rozważana. Jeśli oferta nie ma być wyborem,
powinna istnieć jako pokusa/kontrast i zawierać konkretną korzyść oraz konkretny
koszt, nie tylko krok do kolejnej interakcji.

## 8. Macierz problemów

| ID | Priorytet | Problem | Rodzaj | Dowód główny |
|---|---|---|---|---|
| S-01 | P0 | otwarte progi rozłączają działanie od wiedzy następnej sceny | przyczynowość | GSM 1788–1802; GapLedger 280–294 |
| S-02 | P0 | 14 zna przed 15 przyczynę przerwania próby 20:40 | chronologia | station_14.tscn 68–71; station_15.gd 176–184 |
| S-03 | P0 | Lena „nie pracuje” i „pracuje” w UCP przed weryfikacją | dialog/wiedza | creative lines 22; station_10.gd 90–93 |
| S-04 | P0 | brak wyboru w 18 routuje do 42A | decyzja | GSM 626–641 |
| S-05 | P0 | 42 pozwala odczytać skutek przed wykonaniem | finał | station_42a/b/c funkcje działań |
| S-06 | P0 | blackout kończy 43 przed pełnym epilogiem | wypłata | station_43.gd 281–370 |
| S-07 | P0 | powrót i ponowne przejście blokuje `_handled_completions` | geografia/runtime | GSM 626–629 |
| S-08 | P1 | zaświadczenie m. 12 nie ma źródła | rekwizyt | station_07.tscn 57–74 |
| S-09 | P1 | czytnik opuszcza UCP bez rozstrzygnięcia procedury | motywacja | creative lines 25 |
| S-10 | P1 | 13→14 i 18→42 są niezakotwiczonymi cięciami | geografia/film | sceny 13/14/18/42 |
| S-11 | P1 | mały koszt, prawda i zgoda słabo wracają w 43 | konsekwencje | station_16; station_43 111–238 |
| S-12 | P1 | perspektywa sterowanej Leny w 42B jest niejasna | fokalizacja | station_42b.gd 70–81; tscn 164–169 |
| S-13 | P2 | świat rozpoznany o jeden krok wcześniej niż wykluczenie alternatyw | inferencja | station_13.gd 344–363 |

## 9. Werdykty cząstkowe

| Oś | Werdykt |
|---|---|
| Główna idea i stawka | **PASS strukturalny** |
| Pełny przebieg 01–18 | **CONCERNS**, lecz rdzeń jest naprawialny |
| Logika wiedzy | **FAIL** przez S-02/S-03 i ścieżki pominięcia |
| Geografia nominalna | **PASS z CONCERNS** na 13→14, 18→42 i 42B |
| Geografia z cofaniem | **FAIL** przez S-07 |
| Sprawczość decyzji finałowej | **FAIL** przez domyślne A |
| Wykonanie finału | **FAIL** przez brak kolejności przyczynowej |
| Epilog | **FAIL** przez możliwe pominięcie i nieosiągalne końcowe linie |
| Spójność postaci | **CONCERNS**, ogólnie mocna poza wskazanymi sprzecznościami |
| Dowód emocji/zabawy | **OPEN-NO-EVIDENCE** |

## 10. Konkluzja

Nie należy przepisywać całej historii. Jej oś — próbka, Marta, obca codzienność,
żywy Jakub, miejscowa Lena, koszt, zgoda i trzy metody — jest wartościowa i
spójna. Naprawy wymagają przede wszystkim granice między scenami oraz system
przejść.

Największym błędem byłoby teraz dopisywanie kolejnych objaśnień. Najpierw trzeba
sprawić, aby **to, co scena następna wie, wynikało z tego, co gracz rzeczywiście
zrobił**, a finał był atomowym ciągiem decyzji i konsekwencji. Szczegółowy plan:
`docs/rebuild/PKG_0231_STORY_SENSE_REPAIR_PLAN.md`.

## 11. Weryfikacja i ograniczenia

- świeża pełna `pwsh -NoProfile -File .\tools\verify.ps1`: PASS, exit 0,
  129 sekcji przed zmianami dokumentacyjnymi; log:
  `reports/fresh_story_verify.log`;
- po zapisaniu dokumentów: `tools/verify_docs.ps1` PASS (52 pliki),
  `pkg_0207_gate_census_test.gd` PASS (122/121/120) oraz zakresowa
  `tools/verify_scoped.ps1` PASS, exit 0 (log:
  `reports/pkg_0231_scoped.log`);
- brak zmian kodu, scen, dialogów runtime i danych;
- brak świeżej inspekcji obrazu na normalnym sterowniku Windows;
- audyt statyczny nie dowodzi tempa operatora, czytelności obrazu, emocji ani
  zrozumienia przez człowieka.