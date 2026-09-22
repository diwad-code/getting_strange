# Getting Strange — audyt opowieści, dialogu i dramaturgii

**Materiał:** `getting_strange_audyt_fabularny.zip`  
**Data opracowania:** 22 września 2026 r.  
**Zakres:** opowieść, sens dialogów, motywacja przejść, czytelność celów, łuki postaci i konsekwencje wyborów. Bez oceny kodu, wydajności, grafiki i testów.

## 1. Materiały, które mam, i materiały, których brakuje

Mam archiwum zawierające **97 plików**: 7 dokumentów Markdown, 30 plików `.gd`, 45 scen `.tscn` i 15 zasobów `.tres`. Odczytałem dokumenty określające kanon i aktywną adaptację, teksty aktywnych scen, dialogi, komunikaty o zadaniach oraz zapisane następstwa decyzji. Pliki `.gd` wykorzystuję jako źródła wypowiadanych kwestii i opowiadanych czynności, nie jako przedmiot oceny technicznej. Źródło: `getting_strange_audyt_fabularny.zip`; `_CZYTAJ_NAJPIERW.md`, w. 6–43.

Aktywny przebieg to **otwarcie → 01–18 → jeden wariant 42A/42B/42C → 43**. To 20 odwiedzanych adresów i 22 aktywne pliki scen, ponieważ trzy warianty finału są alternatywami. Scen 19–41 nie traktuję jako rozgrywanych etapów. Starsze numery w dokumentach są materiałem dawcy; pierwszeństwo ma opis aktualnej adaptacji. Źródła: `_CZYTAJ_NAJPIERW.md`, w. 37–50; `docs/narrative/FULL_STORY.md`, w. 3–47.

**Brak danych:** nagranie przejścia, rzeczywisty czas przechodzenia scen, wykonanie aktorskie i ostateczny przebieg niemych winiet. W archiwum nie ma też wskazanych dokumentów `docs/rebuild/PKG_0193_CREATIVE_SCENES.md`, `docs/rebuild/PKG_0194_CREATIVE_SCENES_B.md`, `docs/decisions/ADR-008-hybrid-product-rebuild.md` ani `docs/PROJECT_REBUILD_EXECUTION_PLAN.md`. Pełna treść wcześniejszego briefu przywołanego przez użytkownika słowem „wyżej”: **brak danych poza regułami zawartymi w dostarczonym archiwum**. Odesłania do brakujących dokumentów: `docs/narrative/FULL_STORY.md`, w. 23 i 41; `docs/narrative/NARRATIVE_BIBLE.md`, w. 16–17; `docs/rebuild/PLAYER_CONTRACT.md`, w. 5–7.

Dlatego rozróżniam cztery rzeczy: **fakt zapisany w kanonie**, **treść dostępnej kwestii lub czynności**, **ocenę dramaturgiczną** i **propozycję autorską**. Nie zakładam, że gracz zobaczył coś tylko dlatego, że dokument projektowy to przewiduje. Nie zakładam też, że brak wyjaśnienia w dialogu dowodzi braku wyjaśnienia w niedostarczonej winiecie.

**Dokładna sekunda utraty uwagi widza: brak danych.** Wskazuję konkretne momenty, w których tekst osłabia zainteresowanie. To diagnoza redakcyjna, nie pomiar reakcji publiczności. Sam dokument fabuły zastrzega, że czas wymaga pomiaru po nowym otwarciu: `docs/narrative/FULL_STORY.md`, w. 49–52.

## 2. Werdykt

**Ta historia ma mocny konflikt osobisty, ale jej późniejsza część zbyt często zamienia dramat w protokół potwierdzania zasad.** W rozmowie o kurtce dwie osoby tracą wspólną przeszłość. W spotkaniu z Jakubem żałoba Leny zderza się z człowiekiem, który musi jutro przyjść do pracy. W późniejszych kwestiach Lena objaśnia natomiast, że podejmuje „świadomą decyzję”, „braki zostają nazwane” i nie tworzy „legendy”. To nie jest ta sama jakość pisania. Źródło porównania: `scripts/levels/creative_scene_lines.gd`, w. 21, 27–28, 42, 76 i 80.

Najlepszym tematem nie jest samo odkrycie innego świata. Jest nim pytanie: **czy wolno potraktować człowieka podobnego do utraconej osoby jako sposób naprawienia własnego życia?** Odmowa pokazania blizny i pytanie Marty „Więc gdzie jest ona?” przekładają ten temat na konflikt. To elementy bardziej charakterystyczne niż sama tajemnicza instytucja, rejestry i anomalne sygnały. Źródła: `scripts/levels/creative_scene_lines.gd`, w. 28–29; `docs/narrative/NARRATIVE_BIBLE.md`, w. 140–154 i 263–267.

Odpowiedzi na główne pytania audytu:

| Pytanie | Ocena |
|---|---|
| Czy dialogi mają sens? | **Nierówno.** Sceny 10 i 12 mają konkret, podtekst i sprzeczne potrzeby. W 14–18 oraz finałach pojawia się język instrukcji autora, nie postaci. |
| Czy przejścia wynikają z fabuły? | **W dużej części tak.** Dom → zapis pracy → warsztat → ponowna synteza w domu to sensowny łańcuch. Słabsze są przymusowe zatrzymanie w 05 i fabularne pochodzenie kompletnego stanowiska decyzji na ulicy w 18. |
| Czy gracz wie, co robi? | **Często zna czynność, nie zawsze jej sens i granice.** Dobrze działa porównanie adresów i sprawdzenie numeru. Gorzej: czyja pamięć jest tracona, czego dokładnie dowodzi odpowiedź sygnału i co zmienia powtórna prośba o zgodę. |
| Czy historia działałaby jako film? | **Ma potrzebny materiał, ale nie ma jeszcze spójnie rozegranej kulminacji.** Otwarcia 42 mówią o skutkach przed późniejszym wykonaniem czynności; epilog dopowiada tezy narratorem. |
| Czy istnieje droga bohaterki? | **Tak jako projekt, częściowo jako działanie.** Lena ma przejść od przymusu kontroli do odpowiedzialności bez pełnej wiedzy. Część późniejszych scen deklaruje tę zmianę zamiast ją wykazać. |

Podstawa ocen: `scripts/levels/creative_scene_lines.gd`, w. 20–29, 40–52 i 65–82; `scripts/levels/station_05.gd`, w. 84–135; `scripts/levels/station_18.gd`, w. 11–19 i 131; `scenes/levels/station_42b.tscn`, w. 65–66; `scripts/levels/station_43.gd`, w. 218–246; `docs/narrative/NARRATIVE_BIBLE.md`, w. 81–108.

## 3. Granice proponowanych zmian

Propozycje zachowują aktywną trasę i trzy rodziny finałów; nie przywracają etapów 19–41. Pozostają oba powroty fabularne oraz ustalone kierunki przemieszczania się. Źródło: `_CZYTAJ_NAJPIERW.md`, w. 45–50.

Zwyczajny początek pozostaje zwyczajny. Nie dokładam paranormalnego prologu, wcześniejszej diagnozy innego świata ani wyjaśniającego wszystko mentora. Jawna synteza zostaje w 13, a nazwanie metod następuje po doświadczeniu obu zachowań martwego obwodu w 14. Źródła: `docs/narrative/FULL_STORY.md`, w. 9–32 i 59–67, z uwzględnieniem aktualizacji numeracji; `docs/rebuild/PLAYER_CONTRACT.md`, w. 152–160.

Zachowuję różnicę między przybyłą i miejscową Leną, dwiema Martami oraz żyjącym miejscowym Jakubem. Mieszkania pozostają pod adresem Sadowa 7: 12 w dokumencie przybyłej, 14 miejscowo. Kaloryfer należy do wspomnienia miejscowej Marty, parking do biografii przybyłej Leny. Nie pojawia się surowa próbka, której gracz nie zabezpieczył. Źródło: `docs/narrative/NARRATIVE_BIBLE.md`, w. 5–12 i 110–175.

Nie proponuję czwartego, bezkosztowego zakończenia, wskrzeszenia Jakuba z domu przybyłej ani rozstrzygnięcia, który świat jest „prawdziwszy”. Nie dodaję dziennika zadań, moralnego licznika ani nowego urządzenia rozwiązującego finał. Źródła: `docs/narrative/NARRATIVE_BIBLE.md`, w. 75–79, 196–214, 249–256 i 304–334; `docs/rebuild/PLAYER_CONTRACT.md`, w. 154–160.

## 4. Co zachować

### Dom: przedmiot staje się dowodem, a dowód rani

„Oddałaś mi ją na parkingu” kontra „My wtedy zamieszkałyśmy razem” to dobrze napisane zderzenie. Nie wymaga terminu kosmologicznego. Ta sama rzecz oznacza dla jednej kobiety rozstanie, dla drugiej początek wspólnego życia. Poprzedzająca to pomyłka przy kubkach ma skalę zwykłej domowej czynności, a późniejsza granica dotyku zmienia stosunek Marty do Leny. **Nie zastępować tego rozmową o wariantach rzeczywistości.** Źródło: `scripts/levels/creative_scene_lines.gd`, w. 20–22.

### Jakub: prawo do własnego jutra

„Byłam na twoim pogrzebie” — „Ja jutro mam tu wrócić” to jeden z najlepszych punktów całego materiału. Jakub nie odbiera Lenie żałoby, ale odmawia wejścia w rolę jej zmarłego. Później odmawia pokazania blizny i oferuje sprawdzenie urządzenia. Granica nie blokuje całej relacji: zmienia rodzaj współpracy. **To model, według którego warto napisać późniejszą scenę zgody.** Źródło: `scripts/levels/creative_scene_lines.gd`, w. 27–28.

### Adres i klucz: uczciwa eskalacja

Dokument, spis mieszkańców, wypowiedź sąsiadki i działający klucz stopniowo zawężają proste wyjaśnienia. To lepsza konstrukcja niż kolekcja niezależnych „dziwnych rzeczy”, ponieważ kolejne źródło dotyczy tego samego problemu i zmusza Lenę do następnego działania. Źródła: `scripts/levels/station_07.gd`, w. 84–120; `scripts/levels/station_08.gd`, w. 156–197.

### Zmiana pytania w 13 i nauka przez czynność w 14

„To nie jest mój świat” nie kończy historii, ponieważ Marta natychmiast pyta o nieobecną Lenę. Odpowiedź na zagadkę miejsca tworzy obowiązek wobec osoby. Następnie oba zachowania obwodu poprzedzają nazwy. To właściwa kolejność: wynik działania daje znaczenie pojęciu, a nie odwrotnie. Źródła: `scripts/levels/creative_scene_lines.gd`, w. 29–33; `docs/narrative/FULL_STORY.md`, w. 17–32.

## 5. Problemy krytyczne

Priorytet **P0** oznacza problem z sensem zdarzenia, tożsamością, zgodą lub kulminacją. **P1** oznacza problem z siłą sceny, rytmem albo czytelnością, który nie musi niszczyć całej historii.

### P0.1. Kulminacja: wybór, wykonanie i skutek są opowiedziane w sprzecznej kolejności

**Dowód.** Otwarcie 42B: „Przepływ zamknięty. Próg cichy. Ona jest w środku” oraz „W nocy przy słupku zamknęłam przepływ”. Później w tej samej części Lena mówi: „Dopiero po jej powrocie zamknę kanał”, a zapisana czynność finałowa polega na zamknięciu przepływu. Analogicznie otwarcie 42C mówi o już otwartym przejściu, przed czynnością jego otwarcia. Źródła: `scenes/levels/station_42b.tscn`, w. 65–66; `scripts/levels/creative_scene_lines.gd`, w. 96 i 108; `scripts/levels/station_42b.gd`, w. 213–243; `scenes/levels/station_42c.tscn`, w. 65–66; `scripts/levels/station_42c.gd`, w. 216–235.

**Problem.** Nie wiadomo, czy gracz dopiero dokonuje rozstrzygnięcia, odtwarza dokonany czyn, czy jedynie czyta wynik. Jeżeli ma to być retrospekcja, dostępny tekst nie ustanawia takiej ramy. Kulminacja nie może być jednocześnie wspomnieniem i pierwszym wykonaniem bez wyraźnego rozdzielenia.

**Moment utraty napięcia:** pierwsze zdanie 42B oznajmiające wynik przed działaniem. Od tego miejsca czynność może wyglądać jak potwierdzenie formularza, nie ryzyko.

**Propozycja.** W 18 zapada zamiar i zostaje potwierdzony zakres udziału osób. W 42 następuje wykonanie, dopiero potem rozpoznanie skutku. W 43 pokazujemy życie po skutku. Zachować trzy warianty i istniejące czynności; przepisać ich otwarcia oraz przejścia czasowe, a nie dodawać nowy etap.

**Konsekwencja dalsza.** Słowa „wróciła”, „zamknięty”, „obie wróciły” mogą paść dopiero po odpowiednim zdarzeniu albo jako wyraźnie oznaczona prognoza. Wtedy pytania Marty i przeciek u Jakuba stają się następstwami naszego czynu, nie wcześniej znaną planszą wynikową.

### P0.2. Odmowa Jakuba prowadzi do „zapytam jeszcze raz”, bez pokazanej zmiany warunków

**Dowód.** Jakub odmawia „protokołu in blanco”. Przy odmowie wszystkie trzy prognozy są niedostępne. Lena otrzymuje myśl: „Bez jego ręki nie zatwierdzę tej drogi. Wrócę do hali i zapytam jeszcze raz”. Przy ograniczonym udziale B jest dostępne, a Jakub deklaruje jedynie sprawdzenie wskazań. Źródła: `scripts/levels/creative_scene_lines.gd`, w. 65–72; `scripts/levels/station_18.gd`, w. 131 i 384–401.

**Problem.** Powtórna prośba nie jest sama w sobie naruszeniem zgody: Jakub odmawia blankietu, nie wszelkiej możliwej współpracy. Jednak tekst przejścia nie nazywa żadnej zmiany propozycji. Zamiast „zrozumiałam twoją granicę i proszę o coś innego” gracz dostaje „wrócę i zapytam jeszcze raz”. Historia o nieinstrumentalnym traktowaniu człowieka zaczyna sugerować, że jego „nie” jest przeszkodą do usunięcia.

**Drugi problem.** Szczegółowe prognozy metod pojawiają się w 18, po rozmowie o zgodzie w 17. W dostępnych kwestiach samej prośby dominują czas i wyłącznik, nie przewidywane skutki dla uczestnika. Biblia wymaga informacji o ryzyku przed zgodą. Źródła: `docs/narrative/FULL_STORY.md`, w. 35–40; `scripts/levels/creative_scene_lines.gd`, w. 65–70; `docs/narrative/NARRATIVE_BIBLE.md`, w. 144–149.

**Moment utraty wiarygodności:** słowa „zapytam jeszcze raz” bez zdania, co nowego Lena zamierza zaproponować.

**Propozycja.** Zachować odmowę jako rzeczywiste zamknięcie pierwotnej prośby. Po odczytaniu prognoz Lena może wrócić z innym, jawnie ograniczonym zakresem: na przykład z prośbą wyłącznie o odczyt, nie o podłączenie nadajnika do człowieka. Jakub musi dostać treść tej różnicy i odpowiedzieć na nią, nie powtórzyć ten sam zestaw zdań. Końcowe potwierdzenie ma dotyczyć konkretnej metody i znanego ryzyka. Nie dopisywać zgody domyślnie i nie otwierać finału „mimo odmowy”.

**Konsekwencja dalsza.** Zachowujemy trzy finały i ich ograniczenia, ale powrót 18→17 staje się sceną uczenia się granicy. Nie jest już rundką do automatu wydającego zgodę.

### P0.3. Marta stawia warunek klucza, który nie ma dostatecznie widocznej mocy

**Dowód.** Przy częściowej prawdzie Marta mówi: „Klucz synchronizacji dostaniesz przy pełnym zapisie. Nie przy legendzie”. Dostępność przejścia wzajemnego w 18 zależy od pełnej zgody Jakuba; zapisanie częściowej prawdy lub jej wstrzymania również prowadzi do wariantów dalszych rozmów w 42C. Samo wykonanie przejścia nie zawiera nowej rozmowy uzyskującej brakującą zgodę Marty. Źródła: `scripts/levels/creative_scene_lines.gd`, w. 75 i 114–116; `scripts/levels/station_18.gd`, w. 333–388; `scripts/levels/station_42c.gd`, w. 216–235 i 283–321.

**Problem.** Kwestia brzmi jak warunek udziału w konkretnej procedurze, lecz późniejsza opowieść traktuje jej niespełnienie głównie jako chłodniejszy ton relacji. To osłabia Martę: jej bardzo konkretne „nie teraz” staje się dekoracją. Jeżeli klucz nie jest konieczny do tej procedury, właśnie to musi zostać ustalone; obecnie jego znaczenie pozostaje niejasne.

**Moment utraty zaufania do reguł:** przejście do współpracy wzajemnej mimo niezałatwionej odmowy klucza.

**Propozycja.** Utrzymać osobno zgodę na ratunek i zgodę na synchronizację. Marta może pomagać ratować partnerkę bez obietnicy wybaczenia. Jednak procedura wymagająca jej klucza nie powinna ruszać, dopóki nie spełnimy wypowiedzianego warunku albo nie uzyskamy od niej jawnie zmienionej decyzji po przedstawieniu nowych informacji. Korzystamy z już istniejącego klucza, zapisu i rozmowy w 18. Nie dokładamy nowej zagadki.

**Konsekwencja dalsza.** Pełna prawda nie staje się moralnym kuponem na szczęśliwy finał. Daje osobie możliwość świadomego udziału; sam finał C nadal niesie trwały przeciek i nie daje prawa mówić o zgodzie wszystkich bez wskazania, kto na co przystał.

### P0.4. Scena 16 nie precyzuje, czyją pamięć uszkadza Lena

**Dowód.** Kanon: kurtka na kaloryferze to wspomnienie miejscowej Marty; przybyła pamięta parking i rozstanie. W 16 Lena wybiera utratę szczegółu spotkania: „Kurtka na kaloryferze — to robi się niewyraźne”. Następnie urywa się zdanie Marty, a Lena podsumowuje: „Ubytek jest jeden, mały, mój”. W drugiej gałęzi mówi: „Pamięć Marty zostaje cała. Płacę zapisem, nie nią”. Źródła: `docs/narrative/NARRATIVE_BIBLE.md`, w. 8–12; `scripts/levels/creative_scene_lines.gd`, w. 21 i 48–51.

**Problem.** Możliwe są co najmniej trzy odczytania: Lena traci własną pamięć rozmowy z 10; traci cudze wspomnienie, którego sama nie przeżyła; albo uszkadza pamięć Marty. Pierwsze jest zgodne z kanonem, ale tekst nie oddziela go od dwóch pozostałych. To nie jest drobiazg językowy, bo cały sens wyboru zależy od tego, kto płaci.

**Moment utraty orientacji:** urwane „Twoja kurtka była…” w ustach Marty po deklaracji, że koszt jest wyłącznie Leny.

**Propozycja.** Nie przenosić wydarzenia z kaloryfera na parking. Ustalić, że Lena traci **własne wspomnienie dzisiejszej rozmowy o kaloryferze**. Marta pamięta nadal; mówi całe zdanie. Lena nie umie odtworzyć dopiero co usłyszanego szczegółu. W drugiej gałęzi nazwać ochronę „mojej pamięci rozmowy z Martą”, nie niejednoznacznie „pamięcią Marty”.

**Konsekwencja dalsza.** W finałach wraca dokładnie ten ubytek, nie ogólna etykieta „pamięć zbladła”. Zachowujemy małą, konkretną cenę i nie robimy z przybyłej osoby posiadającej lokalną biografię.

### P0.5. Zagadka myli responsywny sygnał z pełną identyfikacją, a koszt z osobistą winą

**Dowód pierwszy.** Po poprawieniu celowego błędu Lena mówi: „To żywy sygnał” oraz „Nie ma jej w domu. Jest po drugiej stronie pętli”. Kanon jednocześnie stanowi, że Podstruktura reaguje na podobieństwo i powtórzenie. Późniejszy kontakt z domem ma osobno podważyć hipotezę zamiany. Źródła: `scripts/levels/creative_scene_lines.gd`, w. 40–44 i 52; `docs/narrative/NARRATIVE_BIBLE.md`, w. 199–200; `docs/narrative/FULL_STORY.md`, w. 28–34.

**Problem.** Korekta dowodzi czegoś mocniejszego niż bierne odtworzenie nagrania, lecz sama wypowiedź przeskakuje od właściwości odpowiedzi do tożsamości osoby i miejsca jej pobytu. Nie wymagam matematycznej pewności w fikcji. Wymagam, żeby ostrożność protagonistki obowiązywała właśnie w kluczowym wnioskowaniu, a nie znikała, kiedy scenariusz potrzebuje odblokować cel. Dodatkowy dowód w nieudostępnionej winiecie: **brak danych**.

**Propozycja pierwsza.** W tym samym nadajniku powiązać odpowiedź z podpisanym zapisem miejscowej i wykonanym warunkiem przerwania. Rozdzielić trzy wnioski: odpowiedź powstaje teraz; mamy dostateczną podstawę szukać miejscowej; późniejsze echo domu odrzuca prostą zamianę. Nie dopisywać myślącej Podstruktury ani nowego urządzenia.

**Dowód drugi.** Rejestr 17 zestawia stabilną Rówień z pogrzebem Jakuba. Lena mówi kolejno „Ktoś drugi zapłacił” i „Korelacja to nie dowód powiązanego kosztu”. Tymczasem aktualna adaptacja rozróżnia związek kosztów od **winy osobowej**, a biblia stwierdza, że UCP znał powiązany koszt i wybierał utrzymywany wynik. Źródła: `scripts/levels/creative_scene_lines.gd`, w. 60; `docs/narrative/FULL_STORY.md`, w. 35–36; `docs/narrative/NARRATIVE_BIBLE.md`, w. 75–79.

**Problem.** Jedna kwestia odbiera dowodowi znaczenie, na którym opiera się reszta konfliktu. Nie wiadomo, czy poznaliśmy mechanizm przenoszenia kosztu, czy nadal mamy tylko niczego nierozstrzygające sąsiedztwo dwóch zdarzeń.

**Propozycja druga.** Powiedzieć dokładnie to, co ustanawia kanon: zapis dowodzi wiedzy instytucji o powiązaniu; nie dowodzi sam z siebie zamiaru zabicia Jakuba przez konkretną osobę. Następnie pozwolić Wierzbickiej bronić wyboru utrzymywanego wyniku. Bez sensacyjnego ujawnienia „morderczyni brata”.

**Konsekwencja dalsza.** Finał jest wyborem wobec poznanej ceny, nie wobec informacji, którą przed chwilą uznano za niewiarygodną.

### P0.6. Druga zagadka potrzebuje wyraźnego rozdzielenia zamiaru miejscowej i interwencji UCP

**Dowód.** Kanon określa cel miejscowej: niezależny od UCP odczyt eksportu kosztów. Nie planowała zamiany; wiedziała o ryzyku dla nieznanej osoby i niedostatecznie zabezpieczyła zgodę. Wierzbicka zakotwiczyła lokalną stronę podczas kontaktu. W odczytanych kwestiach 15 dostajemy „próbę miejscowej”, informację, że „ktoś przerwał z zewnątrz”, oraz warunek przerwania; w finale miejscowa mówi: „Próbę zrobiłam sama. UCP dopisało resztę”. Źródła: `docs/narrative/NARRATIVE_BIBLE.md`, w. 162–175 i 218–228; `scripts/levels/creative_scene_lines.gd`, w. 40, 44 i 97. Pierwszy obowiązkowy odczyt, nie opcjonalna powtórka, nawiązuje kontakt: `docs/narrative/FULL_STORY.md`, w. 43–47.

**Problem.** Aktywne kwestie podają elementy mechanizmu, ale słabiej odpowiadają na ludzkie „po co ona to zrobiła?”. Zdanie „UCP dopisało resztę” łatwo brzmi jak uchylenie odpowiedzialności, choć miejscowa miała być jednocześnie odważna i winna niedostatecznej zgody. Nie twierdzę, że wszystkie brakujące szczegóły nie mogą istnieć w winiecie; stwierdzam, że dostępny dialog nie stanowi samodzielnego, dostatecznie jasnego rozliczenia.

**Moment utraty zainteresowania:** odczyt kolejnego rejestru w 17, jeżeli po 15 odbiorca nadal nie potrafi powiedzieć, czego miejscowa chciała dowieść i co zrobiła inaczej instytucja.

**Propozycja.** Rozłożyć jeden ciąg przyczynowy na istniejące miejsca: w 15 podpisany cel próby i późniejsze polecenie zamknięcia; w 17 cena utrzymywanego wyniku i odpowiedź Wierzbickiej; w 42B/C własne przyznanie miejscowej, że rozpoczęła próbę bez wystarczającej zgody. Nie pisać długiego wykładu. Każde ujawnienie powinno zmienić relację albo decyzję.

**Konsekwencja dalsza.** Ratunek nie wybiela miejscowej. Powrót do Marty otwiera należną rozmowę, a nie zamyka winę technicznym wyjaśnieniem.

## 6. Problemy rytmu, języka i czytelności

### P1.1. Pierwszy wybór obiecuje rozróżnienie, którego zegar nie wspiera

Marta o 20:31 pyta „Wpół do dziewiątej?”. Później mówi „Miałyśmy zacząć o wpół do dziewiątej”, czyli o 20:30. Kontakt przy obowiązkowym odczycie należy do próby 20:40. Mimo to gałąź bez powtórki odpowiada „Jadę zgodnie z obietnicą”. Źródła: `scripts/campaign/cold_open_facts.gd`, w. 98; `scripts/levels/station_01.gd`, w. 387–393; `scripts/levels/creative_scene_lines.gd`, w. 40; `docs/narrative/FULL_STORY.md`, w. 43–47.

To osłabia wybór „próbka albo obietnica”: przy takim odczytaniu zegara Lena już nie dotrzymała godziny rozpoczęcia spotkania. **Nie nazywam sprzecznością archiwalnego znacznika 20:14 — jest oznaczony jako archiwum**, a nie zegar teraźniejszości. Źródło: `scripts/campaign/cold_open_facts.gd`, w. 97.

**Propozycja:** zachować fabularne 20:40, a wiadomości Marty uzgodnić wokół obietnicy wyjścia po jednym odczycie, nie przybycia na już minioną godzinę. Powtórka ma łamać określoną obietnicę; niezależny objazd może zwiększać spóźnienie, ale nie zacierać, za co Lena odpowiada.

### P1.2. Scena 05 jest nudnym sprawdzeniem rzeczy, które już sprawdziliśmy

W 04 Lena ponownie zajmuje się czytnikiem, patrzy na ślad katastrofy i odkłada urządzenie. W 05 musi najpierw potwierdzić zwyczajność ulicy, potem zawartość torby, a dopiero potem przejść przez jezdnię. Mapa kampanii opisuje ten odcinek jako zwykłe przejście bez przeszkody. Źródła: `scripts/levels/station_04.gd`, w. 97–134; `scripts/levels/station_05.gd`, w. 84–135; `docs/rebuild/CAMPAIGN_MAP.md`, w. 67.

**Tu wskazuję pierwszy wyraźny moment utraty uwagi:** konieczność ponownego sprawdzenia torby po scenie odkładania czytnika. Nowa czynność nie daje nowego konfliktu, odkrycia ani zmiany oczekiwania. Powolność nie jest problemem; redundantność jest.

**Propozycja:** zachować lokalizację 05 jako potrzebny punkt odniesienia dla powrotu w 18, lecz uczynić ją zwykłym przejściem. Stan torby może pozostać dostępny do obejrzenia, ale nie powinien fabularnie warunkować skorzystania z zielonego światła. Nie dodawać anomalii dla podkręcenia tempa.

### P1.3. Kiosk nie odpowiada na pytanie, dla którego miał być potrzebny

Lena zauważa inny przebieg linii. Sprzedawca rozpoznaje ją, podaje wodę i mówi o porannym zakupie Marty. Jedynym wypowiedzianym potem pytaniem Leny jest „Długo dziś jeszcze otwarte?”. Nie uzyskujemy rozmowy rozstrzygającej wskazaną rozbieżność trasy. Źródło: `scripts/levels/station_06.gd`, w. 159 i 176–200.

Samo rozpoznanie stałej klientki ani kupienie wody przez Martę nie jest sprzecznością bez ustanowienia przeciwnego faktu. Kiosk może budować drobny dyskomfort, ale obecny dialog nie wystarcza do roli niezależnego źródła rozbieżności, przewidzianej w kontrakcie. Źródło wymogu: `docs/rebuild/PLAYER_CONTRACT.md`, w. 112–129.

**Moment osłabienia sceny:** pytanie o godziny zamknięcia zamiast o powód zatrzymania się Leny przy rozkładzie.

**Propozycja:** zachować wodę, normalny ton i własną pracę sprzedawcy. Zastąpić zbędne pytanie krótkim sprawdzeniem konkretnego odcinka trasy. W aktualnym rozkładzie oraz w wcześniejszym doświadczeniu Leny muszą wystąpić dwie porównywalne informacje. Sprzedawca potwierdza zwykły fakt, nie komentuje tajemnicy świata. Nie wprowadzać do kiosku wcześniejszej informacji o wspólnym mieszkaniu; to funkcja 07–08.

### P1.4. Śmierć brata ma za słaby wcześniejszy nośnik w dostępnych kwestiach

W 04 pada „Pomnik Linii 4. Nie patrzę na niego od dziewięciu lat”. Dopiero przy rejestrze 11 dostępny dialog mówi wprost: „Mój brat zginął dziewięć lat temu”. Powiązanie pomnika z konkretnym Jakubem w niedostarczonym wykonaniu wizualnym: **brak danych**. Źródła: `scripts/levels/station_04.gd`, w. 114; `scripts/levels/creative_scene_lines.gd`, w. 24.

Bez wcześniejszego ustalenia utraty ujawnienie żyjącego Jakuba musi jednocześnie objaśnić, kim był zmarły, i odebrać nam pewność jego śmierci. To zjada część siły odwrócenia.

**Propozycja:** w istniejącym momencie przy śladzie katastrofy w 04 zostawić jeden konkretny nośnik osobistej straty — imię, nazwisko lub krótką reakcję wskazującą brata. Bez sceny pogrzebu, prologu i wykładu. Dopiero na takiej podstawie 11–12 wypłacają wcześniejsze oczekiwanie.

### P1.5. Po rozpoznaniu bohaterowie coraz częściej mówią głosem dokumentu projektowego

Przykłady: „Sekcja pokazała różnicę, zanim dostała nazwę”; „To moja świadoma decyzja”; „Nieustalone pokazuję jako nieustalone”; „To wstrzymanie, nie kłamstwo z litości”; „Braki zostają nazwane”. Źródło: `scripts/levels/creative_scene_lines.gd`, w. 33, 42, 73, 76 i 80.

To **sztywne, wtórne wobec własnych założeń projektu pisanie**: zdania poświadczają, że scena spełnia regułę, zamiast pozwolić odbiorcy zobaczyć zachowanie. Lena nie musi powiedzieć, że zdecydowała świadomie. Musi wiedzieć, co ryzykuje, zawahać się i wykonać czyn. Nie musi zapewniać, że milczenie nie jest litościwym kłamstwem. Może odmówić pokazania kartki i ponieść reakcję Marty.

Szczególnie rażące są otwarcia 42A/C: „O świcie steruję przybyłą Leną” oraz myśl epilogu „przejrzę napisy końcowe i zamknę podróż”. To wypowiedzi o użytkowniku i strukturze gry przypisane perspektywie Leny. Źródła: `scenes/levels/station_42a.tscn`, w. 75–76; `scenes/levels/station_42c.tscn`, w. 66–67; `scripts/levels/station_43.gd`, w. 311–313.

**Moment wyłączenia emocjonalnego:** „To moja świadoma decyzja” tuż przed próbą z sygnałem. Człowiek zamienia się w podpis pod mechanizmem.

**Propozycja:** usunąć autooceny i zamienić je na prośby, odmowy, określenie konkretnego ryzyka oraz ciszę. Pomoc dotycząca obsługi może pozostać pomocą, lecz nie udawać myśli bohaterki. Zachować osobne głosy: Marta — dom i granice; Jakub — praca i zakres pomocy; Wierzbicka — wybiórcza odpowiedzialność instytucji; Lena — konkret i trudność przyznania niewiedzy. Są to także rozróżnienia zapisane w `docs/narrative/DIALOGUE_SCRIPT.md`, w. 45–106.

### P1.6. Wierzbicka ma argument w biblii, ale w dostępnych rozmowach brzmi jak infolinia

Kanon daje jej konkretny cel: stabilność większości, ochronę lokalnego wyniku i uzasadnianie kosztów poza własnym zakresem. W dialogu 11 dominuje „stan”, „zakres” i „dopuszczalne odchylenie”. W 17 oferta domu, Marty i żywego Jakuba zostaje szybko odrzucona. Źródła: `docs/narrative/NARRATIVE_BIBLE.md`, w. 177–192; `scripts/levels/creative_scene_lines.gd`, w. 23, 25 i 61.

Sam proceduralny język nie jest błędem. Błędem dramaturgicznym jest brak równie mocnego zderzenia **interesów**. Oferta ma rangę pokusy w założeniu, lecz w dostępnej wymianie przypomina pytanie kontrolne z od razu poprawną odpowiedzią. Pełnego wykonania opozycji poza tekstem nie widziałem.

**Propozycja:** wykorzystać istniejący spór o czytnik w 11, aby Wierzbicka naprawdę wyznaczyła warunki pozyskania informacji, bez ujawniania kosmologii. W 15 ujawnić autorstwo późniejszego polecenia. W 17 pozwolić jej bronić ludzi, których wynik utrzymała. Lena powinna przez chwilę rzeczywiście chcieć przyjąć ofertę, ale odrzucić zastąpienie nieobecnej osoby. Nie dodawać pościgu ani czwartej drogi.

### P1.7. Ulica 18 ma funkcję finałową, ale słabe uzasadnienie fabularne wyposażenia

Opis uzasadnia tablicę prognoz na chodniku tym, że „trzy trasy rozchodzą się z tej samej ulicy”, a witrynę Marty i słupek tym, że zgoda i koszt mają być widoczne przed dalszym ruchem. To argument o organizacji sceny, nie informacja o tym, kto umieścił tam urządzenia i dlaczego bohaterowie właśnie tutaj z nich korzystają. Źródło: `scripts/levels/station_18.gd`, w. 11–16.

**Problem.** Gracz może doskonale wiedzieć, gdzie zatwierdzić wybór, a jednocześnie czuć, że trafił do sali wyboru zakończenia przebranej za chodnik. To problem tożsamości sytuacji, nie ocena wyglądu.

**Propozycja:** zachować powrót na ulicę z 05, lecz przed wyjściem z 17 dać prosty cel: przynieść Marcie zapis i na własnym czytniku zestawić skutki. W 18 ustanowić, skąd pochodzą używane prognozy i kto je rozłożył lub udostępnił. Korzystać z istniejących przedmiotów. Zwykłe miejsce powinno zostać obciążone decyzją ludzi, nie samoczynnie wyposażone w komplet finałowych stanowisk.

## 7. Audyt konsekwencji finałów

### 42A — utrzymać twardą cenę, nie zacierać nośnika

Kanon: przybyła wraca, miejscowa pozostaje między adresami, lokalna Marta nadal jej szuka, Jakub żyje, a instytucja utrzymuje kontrolę. To wystarczająco mocna cena; nie trzeba dopisywać kary. Źródło: `docs/narrative/NARRATIVE_BIBLE.md`, w. 304–314.

Problemem precyzji jest „Najpierw posłuchaj próbki” oraz „Słyszałam próbkę całą” w wariancie, który nie rozróżnia zabezpieczonej próbki i samego bufora tak, jak robi to 16. Nie twierdzę, że po gałęzi bez powtórki nie istnieje żaden zapis: bufor istnieje i został nazwany wprost. Brakuje jasności, czy finał mówi o pierwotnej surowej próbce, jej pozostałości czy późniejszym zapisie. Źródła: `scripts/levels/creative_scene_lines.gd`, w. 50–51, 90–91 i 242–248; `docs/narrative/NARRATIVE_BIBLE.md`, w. 12.

**Propozycja:** finał musi nazywać to, co Lena rzeczywiście ma: zabezpieczony materiał, uszkodzony zapis albo sam bufor. Niech deklaracja Marty dotyczy wysłuchania dostępnego materiału, nie cudownie odzyskanej pełni. Istniejąca propozycja etykiety „BŁĄD CZUJNIKA” może celnie odbić zawodowy mechanizm obronny Leny, ale jej własna decyzja wobec tej etykiety powinna być widoczna. Źródło obecnej etykiety: `scripts/levels/creative_scene_lines.gd`, w. 85.

### 42B — wygnanie nie może wyglądać tylko jak brak wpisu w ewidencji

Kanon i mapa określają cenę jako własną nieindeksowaną ciągłość przybyłej, nie gwarantowany powrót do domu. Dostępne kwestie 42B zaczynają od progu i czytnika bez adresu. Dopiero epilog daje jednoznaczniejszy konkret obcego przystanku oraz „Jadę” bez adresata. Źródła: `docs/narrative/NARRATIVE_BIBLE.md`, w. 315–322; `docs/rebuild/CAMPAIGN_MAP.md`, w. 97; `scripts/levels/creative_scene_lines.gd`, w. 96–104; `scripts/levels/station_43.gd`, w. 222–223.

**Problem.** Słowo „adres” jest techniczne i łatwo zmniejsza skalę utraty: można odczytać ją jako brak rejestracji, a nie utratę drogi do własnego życia. Nie twierdzę, że przybyła kanonicznie zostaje w mieszkaniu 14 — finał wymaga czytelniejszego rozdzielenia progu, odzyskania miejscowej i późniejszego miejsca przybyłej.

**Propozycja:** wykorzystać istniejący próg i istniejący epilog, bez dodatkowej lokacji. Po powrocie miejscowej wyraźnie oddzielić losy obu Len. Późniejszy brak adresata ma oznaczać niemożność dotarcia do domowej Marty, nie tylko usterkę telefonu. Zachować „Jadę” — to lepsze zamknięcie niż zdanie o przyjęciu niepewności.

### 42C — przeciek jest konkretny, ale późniejszy język go znieczula

Jakub doświadcza przy imadle obrazu prosektorium, po czym mówi „Wracam do napędu. To mija”. Epilog nazywa połączenie „cienką nicią pamięci i obustronnej zgody”. Tymczasem kanon przewiduje trwały przeciek i brak pełnej stabilności. Źródła: `scripts/levels/creative_scene_lines.gd`, w. 111 i 114–116; `scripts/levels/station_43.gd`, w. 241–242; `docs/narrative/NARRATIVE_BIBLE.md`, w. 323–334.

**Problem.** Pierwszy konkretny koszt zostaje natychmiast uspokojony. Sama przemijalność jednego epizodu nie przeczy trwałości problemu, ale zestawienie „To mija” z sentymentalną „nicią” promuje odczytanie C jako prawie bezkosztowego rozwiązania. Do tego „obustronna zgoda” nie może zastępować odpowiedzi, czy zgodzili się wszyscy użyci uczestnicy i na jaki zakres.

W tej scenie występuje też błąd znaczenia: **„To mój pogrzeb w twojej głowie. Nie twój.”** Mówi Lena. W ustanowionej historii chodzi o jej wspomnienie pogrzebu brata, nie pogrzeb Leny. Źródła: `scripts/levels/creative_scene_lines.gd`, w. 111; `docs/narrative/NARRATIVE_BIBLE.md`, w. 65–73.

**Propozycja:** poprawić właściciela wspomnienia. Jakub może przerwać pracę na własnych warunkach, zamiast natychmiast uspokajać wszystkich. Nie dopisywać wypadku ani kolejnej ofiary. Wystarczy konsekwencja w jego zwykłym celu: bezpieczny powrót do napędu nie jest już automatyczny. Epilog pokazuje trwałe zakłócenie codzienności, nie ozdobne połączenie dusz.

### Dwie Marty: należy oddzielić wiedzę, nie tylko etykiety nadawców

W 18 zapis próby otrzymuje miejscowa Marta. Późniejsze warianty finałów rozróżniają wypowiedzi Marty domowej i zawartość jej zgłoszeń w zależności od przekazanej prawdy. W B pojawia się „WIADOMOŚĆ DOMOWA” ze zgłoszeniem bez szczegółu próby albo z samym imieniem. Nośnik, dzięki któremu domowa Marta poznała odpowiedni zakres informacji o lokalnej próbie: **brak danych w przywołanych rozmowach**. Źródła: `scripts/levels/creative_scene_lines.gd`, w. 74–76, 90–92 i 102–104; wybór tych wariantów: ten sam plik, w. 242–248.

Nie oznacza to, że między światami nie istnieje żaden kontakt — echo domu jest zapisane w 16. Oznacza, że kontakt nie przenosi automatycznie każdej późniejszej informacji. Źródło: `scripts/levels/creative_scene_lines.gd`, w. 52.

**Propozycja:** dla każdej wiadomości ustalić osobę, świat, moment i dostępny kanał. Gdy nie ma sposobu przekazania szczegółu, domowa Marta mówi wyłącznie to, co sama może wiedzieć. Nie przenosić stanu rozmowy z jedną osobą na wiedzę drugiej. W miejscach, gdzie istniejący kanał jeszcze działa, pokazać konkretny przekaz, nie dopisywać wszechwiedzy.

### Epilog: narrator odbiera scenom ostatnie słowo

„Miasto nie jest już rozdwojone, lecz nosi bliznę, której nikt nie ukrywa” oraz zdanie o dwóch Lenach połączonych nicią są tezami ponad doświadczeniem konkretnej postaci. Obok pojawia się zbiorczy „ZAPIS” zestawiający zakres prawdy, zgodę Jakuba i mały koszt. Samo zestawienie nie jest moralnym punktomierzem, ale stylistycznie przypomina rozliczenie przejścia. Źródło: `scripts/levels/station_43.gd`, w. 218–246 i 257–273.

Kontrakt epilogu mówi o konsekwencjach konkretnych osób **bez narratora**. Nie wystarczy nazwać narratora „ŚWIADECTWEM”, żeby przestał pełnić jego funkcję. Źródło: `docs/rebuild/CAMPAIGN_MAP.md`, w. 99; `docs/narrative/FULL_STORY.md`, w. 707–724.

**Propozycja:** zachować ostatnie czynności: nieuzupełnioną rubrykę, wiadomość bez adresata, kubek i półkę. Usunąć końcowe interpretacje, które mówią odbiorcy, co oznacza cały świat. Potrzebne informacje o osobach przekazać identyfikowalnym dokumentem lub czyimś działaniem. Nie każdy stan musi zostać przeczytany jednym głosem w jednym miejscu.

## 8. Czy istnieje droga bohaterki i czy działa standard opowiadania historii?

### Łuk jest właściwie pomyślany

Lena ma pragnienie: wrócić do własnego życia i odzyskać sprawdzalność świata. Ma obronne przekonanie: wystarczająca liczba pomiarów umożliwi wybór bez ryzyka i bez żałoby. Ma potrzebę: odpowiedzialność przy niepełnej wiedzy i uznanie cudzej zgody. To nie wymaga dopisywania przeznaczenia ani wielkiej misji. Źródło: `docs/narrative/NARRATIVE_BIBLE.md`, w. 81–108.

W dostępnych scenach można wskazać przejście od małej ceny osobistej w 01, przez utratę domowej oczywistości w 10, do granicy Jakuba w 12 i nowego obowiązku wobec miejscowej w 13. To wystarczająca podstawa pełnej drogi bohaterki. Źródła: `scripts/levels/station_01.gd`, w. 387–393; `scripts/levels/creative_scene_lines.gd`, w. 21–29.

### Przemiana jest jednak za często deklarowana

W 13 pada dobre „Nie wiem”, ale niemal natychmiast zostaje przykryte „Sprawdzę ją. Najpierw muszę ją odnaleźć”. To może celnie utrzymać stary odruch Leny — pod warunkiem, że później rzeczywiście przestanie używać sprawdzania jako obrony przed uczuciem. Jeżeli końcówka jedynie mówi, że decyzja jest świadoma i braki nazwane, przemiana pozostaje na poziomie hasła. Źródło: `scripts/levels/creative_scene_lines.gd`, w. 29, 42 i 80.

**Propozycja:** nie poprawiać bohaterki jednym wyznaniem. Dać jej w 15–18 możliwość zrobienia „jeszcze jednego pomiaru” kosztem czyjejś granicy i pokazać, że rezygnuje z tego ruchu mimo niewygody. Zgoda Jakuba, klucz Marty i warunek przerwania miejscowej już dostarczają potrzebnych sytuacji. Nie trzeba nowej mechaniki ani dodatkowej sceny.

### Trzy finały nie muszą kończyć identycznego, dodatniego łuku

**A** może pokazywać świadomy wybór własnego powrotu mimo cudzej utraty. To nie musi być moralizatorska kara; ważne, żeby Lena nie nazywała cudzego kosztu błędem pomiaru. **B** może pokazać przyjęcie własnej utraty bez gwarancji domu, ale nie powinno sugerować, że Lena spłaca obowiązek cierpienia za samo istnienie. **C** może kończyć się współpracą bez pewności i bez monopolu jednej osoby, ale tylko pod warunkiem realnego rozliczenia zgód oraz trwałej ceny. To interpretacje możliwych łuków, nie dodatkowe fakty kanoniczne. Podstawa wariantów: `docs/narrative/NARRATIVE_BIBLE.md`, w. 304–334.

### Wersja filmowa: materiał dobry, późniejszy ciąg przyczynowy za słaby

W domowej rozmowie czy scenie warsztatu cel, opór i zmiana relacji mieszczą się w jednym spotkaniu. W końcówce zbyt wiele odcinków polega na odczycie, potwierdzeniu i streszczeniu. W scenie 17 kumulują się rozliczenie katastrofy, oferta Wierzbickiej i negocjacja pomocy Jakuba. Każdy temat jest duży; zapis krótkich wymian nie daje im automatycznie osobnych punktów zwrotnych. Źródło: `scripts/levels/creative_scene_lines.gd`, w. 20–28 i 60–67.

Dla oceny nie używam sztywnego wzoru monomitu. Stosuję kryterium, które projekt sam deklaruje: cel → przeszkoda → działanie → reakcja → nowa decyzja lub oczekiwanie. Informacja sama nie wystarcza jako pełna scena. Pod tym względem 10 i 12 spełniają warunek wyraźniej niż 05 oraz część finałowych odczytów. Źródła: `docs/narrative/NARRATIVE_BIBLE.md`, w. 279–289; `scripts/levels/station_05.gd`, w. 84–135; `scripts/levels/creative_scene_lines.gd`, w. 20–28 i 85–116.

## 9. Audyt aktywnej trasy: cel, powód przejścia, korekta

Poniższa tabela dotyczy wyłącznie aktywnych adresów. Ocena dotyczy zapisanej przyczynowości, nie sprawności przemieszczania się.

| Etap | Co Lena robi i dlaczego idzie dalej | Ocena / najważniejsza korekta | Źródło |
|---|---|---|---|
| 01 | Kończy pomiar lub powtarza go; jedzie do czekającej Marty. | Silny mały konflikt. Uzgodnić obietnicę z godziną próby. | `scripts/levels/station_01.gd`, w. 296–393; `docs/narrative/FULL_STORY.md`, w. 43–47. |
| 02 | Zamknięte przejście wymusza obejście na przystanek. | Przyczyna wyjścia czytelna. Nie obciążać zwykłego objazdu tajemnicą. | `scripts/levels/station_02.gd`, w. 84–102. |
| 03 | Sprawdza kurs i odpowiada Marcie przed wejściem do pojazdu. | Czytelne działanie społeczne i praktyczne. Zachować różnicę między kosztem powtórki a objazdem. | `scripts/levels/station_03.gd`, w. 92–127. |
| 04 | Jedzie do dzielnicy; odkładanie pracy przecina ślad katastrofy. | Potrzebny emocjonalny zalążek. W dostępnym tekście związek pomnika z bratem jest zbyt mało konkretny. | `scripts/levels/station_04.gd`, w. 97–134. |
| 05 | Wraca znaną ulicą, zamierza kupić wodę. | Cel jasny, obowiązkowy przystanek przy torbie zbędny dramaturgicznie. | `scripts/levels/station_05.gd`, w. 84–135. |
| 06 | Kupuje wodę, zauważa zmienioną trasę. | Niech wypowiedziane pytanie sprawdza właśnie tę rozbieżność. | `scripts/levels/station_06.gd`, w. 159–200. |
| 07 | Porównuje adres w swoim dokumencie ze spisem, używa kodu. | Dobry materialny konflikt, sensowne wejście do budynku. | `scripts/levels/station_07.gd`, w. 84–120. |
| 08 | Sprawdza numerację u sąsiadki, używa klucza pod 14. | Dobre zawężenie prostych hipotez; zachować zwyczajność sąsiadki. | `scripts/levels/station_08.gd`, w. 156–197. |
| 09 | Rozpoznaje rzeczy dwóch osób, fotografię; nie wchodzi samowolnie do sypialni. | Dom staje się cudzą intymnością, nie tylko zbiorem wskazówek. Zachować. | `scripts/levels/creative_scene_lines.gd`, w. 17–19. |
| 10 | Rozmawia z Martą; po sprzecznych wspomnieniach idzie po zapis pracy. | Jedno z najlepszych przejść: poszukiwanie neutralnego dowodu wynika z konfliktu ludzi. | `scripts/levels/creative_scene_lines.gd`, w. 20–22. |
| 11 | Sprawdza tożsamość, historię pracy i dwa rejestry Jakuba; bierze kontakt do warsztatu. | Cel i następna lokalizacja są uzasadnione. Wzmocnić ludzką presję Wierzbickiej bez ujawnienia świata. | `scripts/levels/creative_scene_lines.gd`, w. 23–25. |
| 12 | Spotyka żywego Jakuba, przyjmuje odmowę, zdobywa sprawdzenie numeru; wraca zestawić źródła. | Właściwy splot śledztwa i granicy. Nie sprowadzać tej sceny do zaliczenia dowodu. | `scripts/levels/creative_scene_lines.gd`, w. 26–28; `scripts/levels/station_12.gd`, w. 89–92. |
| 13 | Zestawia źródła, rozpoznaje obcy świat, przyjmuje pytanie o miejscową; wyciąg wskazuje sekcję rozdzielni. | Dobry punkt zwrotny i wskazanie dalszej drogi. Pozostawić miejsce na niewiedzę. | `scripts/levels/creative_scene_lines.gd`, w. 29; `scripts/levels/station_13.gd`, w. 106–111. |
| 14 | Poznaje oba zachowania na martwym obwodzie, dopiero potem je nazywa; szuka pętli wskazanej zapisem. | Zasadniczo sensowna nauka. Usunąć komentarz o poprawnej kolejności nazwania. | `scripts/levels/station_14.gd`, w. 114–121; `scripts/levels/creative_scene_lines.gd`, w. 32–33. |
| 15 | Sprawdza odpowiedź z pętli i warunek przerwania; kieruje sygnał do analizatora. | Doprecyzować stopień dowodu, cel miejscowej i kolejność ingerencji UCP. | `scripts/levels/creative_scene_lines.gd`, w. 40–44; `scripts/levels/station_16.gd`, w. 149–197. |
| 16 | Ponosi mały koszt i odbiera echo domu; przechodzi do rozliczenia instytucji. | Najpierw wyjaśnić właściciela wspomnienia. Zachować rozróżnienie próbki i bufora. | `scripts/levels/creative_scene_lines.gd`, w. 47–52; `scripts/levels/station_16.gd`, w. 200–241. |
| 17 | Czyta parę kosztów, odrzuca adaptację, prosi Jakuba o określoną pomoc. | Scena przeciążona trzema dużymi tematami. Wzmocnić argument i realne warunki zgody. | `scripts/levels/creative_scene_lines.gd`, w. 60–67. |
| 18 | Wraca na ulicę, zestawia prognozy, rozmawia z Martą, zatwierdza metodę. | Dopowiedzieć powód stanowiska na ulicy i moc warunków Marty. Zachować rozdzielenie wskazania od zatwierdzenia. | `scripts/levels/station_18.gd`, w. 11–19 i 134–136; `scripts/levels/creative_scene_lines.gd`, w. 70–82. |
| 42A | Wykonuje własny powrót i rozpoznaje zamknięcie miejscowej. | Uporządkować czas wykonania, konkretną stratę i materiał przyniesiony do domu. | `scripts/levels/creative_scene_lines.gd`, w. 85–92; `scenes/levels/station_42a.tscn`, w. 74–76. |
| 42B | Odzyskuje miejscową kosztem własnego adresu, zamyka kanał. | Nie opowiadać skutku przed czynem. Wyraźnie rozdzielić losy obu Len. | `scripts/levels/creative_scene_lines.gd`, w. 96–104; `scenes/levels/station_42b.tscn`, w. 65–66. |
| 42C | Wykonuje wzajemne przejście, mierzy się z przeciekiem. | Zgody muszą poprzedzić czyn, a przeciek pozostać ceną, nie metaforą bliskości. | `scripts/levels/creative_scene_lines.gd`, w. 108–116. |
| 43 | Spotyka konsekwencje wybranego wariantu. | Usunąć wszechwiedzące interpretacje i wypowiedzi o napisach końcowych z głosu Leny. Zostawić czynność i konkret. | `scripts/levels/station_43.gd`, w. 178–273 i 307–314. |

## 10. Propozycje konkretnych przepisów dialogu

**Poniższe kwestie są propozycjami autorskimi, nie cytatami z gry.** Nie wprowadzają dodatkowych lokacji, postaci, zakończeń ani urządzeń. To wzorce do osadzenia przy już istniejących czynnościach.

### 13 — niewiedza bez natychmiastowej obietnicy wszechmocy

Marta: „Więc gdzie jest ona?”  
Lena: „Nie wiem.”  
Lena nie sięga od razu po następny przedmiot.  
Marta: „Poszukasz?”  
Lena: „Tak. Nie obiecam ci, że znajdę.”

Cel redakcyjny: odpowiedzialność zamiast pewności. Zastępuje automatyczny powrót do „Sprawdzę ją”, nie przesuwa rozpoznania przed 13. Oryginał: `scripts/levels/creative_scene_lines.gd`, w. 29.

### 15 — działanie zamiast „świadomej decyzji”

Lena: „Dwa razy oddało to samo.”  
Lena: „Teraz zmienię jeden element.”  
Po odpowiedzi: „Poprawione. Tylko to jedno.”

Dalszy wniosek o miejscowej wymaga powiązania odpowiedzi z istniejącym zapisem i warunkiem przerwania, nie dodatkowego zapewnienia Leny. Oryginał i kontekst: `scripts/levels/creative_scene_lines.gd`, w. 40–44.

### 16 — własna pamięć rozmowy, nie cudza biografia

Przed wyborem — Lena: „Mogę stracić sekundę odczytu. Albo szczegół tego, co Marta powiedziała mi dzisiaj o kurtce.”  
Po wyborze pamięci — Marta: „Powiedziałam: na kaloryferze.”  
Lena: „Wiem, że mi mówiłaś. Nie umiem sobie tego przypomnieć.”

Cel redakcyjny: Marta zachowuje własne wspomnienie; przybyła traci własne przyswojenie rozmowy. Kontekst: `docs/narrative/NARRATIVE_BIBLE.md`, w. 8–12; `scripts/levels/creative_scene_lines.gd`, w. 48–51.

### 17 — koszt nie jest automatycznie dowodem zamiaru zabójstwa

Lena: „Wiedzieliście o drugiej stronie.”  
Wierzbicka: „Utrzymaliśmy tunel.”  
Lena: „Tutaj.”  
Wierzbicka: „Tak. Tutaj.”

Wskazany przez rejestr koszt pozostaje faktem; zamiar skrzywdzenia konkretnego Jakuba nie zostaje dopisany. Podstawa: `docs/narrative/NARRATIVE_BIBLE.md`, w. 75–79 i 183–191.

### Powrót po odmowie — inna prośba, nie ta sama presja

Lena: „Nie proszę już o podłączenie nadajnika do ciebie. Zostaje odczyt. Resztę wykonuję sama.”  
Jakub: „Pokaż, co z tego wynika.”  
Lena przedstawia wybrany zakres i znane ryzyko. Dopiero po tej czynności pada jego odpowiedź.

To nie jest gotowa zgoda. To brakująca zmiana warunków rozmowy. Podstawa istniejącego ograniczonego udziału: `scripts/levels/creative_scene_lines.gd`, w. 66–67; `scripts/levels/station_18.gd`, w. 384–388.

### 42B/C — miejscowa odpowiada za własną część

Marta: „Wiedziałaś, że możesz kogoś w to wciągnąć?”  
Miejscowa Lena: „Tak.”  
Marta: „Zapytałaś?”  
Miejscowa Lena: „Nie.”  
Marta: „A zaczęłaś.”  
Miejscowa Lena: „Tak.”

Cel redakcyjny: nie kasować interwencji UCP, ale również nie używać jej jako uniewinnienia pierwszej decyzji. Podstawa: `docs/narrative/NARRATIVE_BIBLE.md`, w. 162–175; obecna wymiana: `scripts/levels/creative_scene_lines.gd`, w. 97.

### 42C — poprawny właściciel wspomnienia i odczuwalna cena

Lena: „To moje wspomnienie pogrzebu brata. Nie twoje przeżycie.”  
Jakub: „To ja muszę teraz odłożyć narzędzie.”  
Jakub odkłada pracę, zanim zdecyduje, czy może bezpiecznie ją kontynuować.

Cel redakcyjny: ani nie uśmiercać Leny, ani nie bagatelizować obcego wspomnienia w cudzym ciele. Obecna kwestia: `scripts/levels/creative_scene_lines.gd`, w. 111.

## 11. Plan poprawek w kolejności zależności

### Przebieg pierwszy: ustalić, co rzeczywiście się wydarza

Najpierw uporządkować relację 18→42→43. Następnie ustalić właściciela małego kosztu, poprawić „mój pogrzeb”, uzgodnić godzinę i treść obietnicy, rozdzielić koszt od winy osobowej oraz doprecyzować informacje przynoszone przez obie Marty. Na tym etapie nie dodawać nowych scen. Problemy dotyczą sprzecznych albo niejednoznacznych twierdzeń w już istniejących scenach. Zakres miejsc zmian: `scripts/levels/creative_scene_lines.gd`, w. 40–52, 60 i 85–116; `scripts/levels/station_01.gd`, w. 387–393; `scenes/levels/station_42a.tscn`; `scenes/levels/station_42b.tscn`; `scenes/levels/station_42c.tscn`; `scripts/levels/station_43.gd`.

**Warunek redakcyjnego domknięcia:** da się opisać każdy finał w kolejności „Lena zamierza → uzyskuje potrzebne odpowiedzi → wykonuje → ktoś ponosi konkretny koszt”, bez cofania skutku przed czyn i bez zmieniania właściciela wspomnienia.

### Przebieg drugi: nadać warunkom ludzi rzeczywistą moc

Przepisać odmowę i ponowną prośbę Jakuba jako dwie różne propozycje. Doprowadzić klucz Marty do jawnego rozstrzygnięcia przed czynnością, która go wymaga. Miejscowej Lenie dać własne przyznanie odpowiedzialności. Wierzbickiej dać obronę wyboru, nie tylko nazwę procedury. Miejsca: 11, 15, 17, 18 i 42B/C. Podstawa istniejących konfliktów: `scripts/levels/creative_scene_lines.gd`, w. 25, 44, 61, 65–76 i 97.

**Warunek redakcyjnego domknięcia:** przy każdej zgodzie wiadomo, kto się zgadza, na co, po otrzymaniu jakiej informacji i jak może przerwać swój udział. Ratunek, bliskość i przebaczenie nie są jednym zezwoleniem.

### Przebieg trzeci: naprawić przyczynowość poszlak i przejść

W 06 pytanie ma odpowiadać zauważonej rozbieżności. W 15 po kolei ustanowić cel próby, responsywność i ingerencję. W 16 oddzielić echo domu od wcześniejszego wniosku. W 17→18 ustanowić zwyczajny powód przeniesienia rozmowy i użycia sprzętu na ulicy. Źródła obecnych scen: `scripts/levels/station_06.gd`, w. 159–200; `scripts/levels/creative_scene_lines.gd`, w. 40–52; `scripts/levels/station_18.gd`, w. 11–16.

**Warunek redakcyjnego domknięcia:** przed opuszczeniem miejsca Lena ma powód pójść do następnego, a źródło zdobytej wiedzy potrafi powiedzieć właśnie to, co z niego wyciągamy — nie więcej.

### Przebieg czwarty: wyciąć nadmiar, nie zastępować go hałasem

Odciążyć 05, zachować ciszę po mocnych kwestiach 10–13, usunąć deklaracje o „świadomej decyzji” i „nazwanych brakach”. Rozdzielić język pomocy od głosu Leny. Z epilogu usunąć tezy, zostawiając konkretne działania i czytelne źródła. Nie przyspieszać historii przedwczesną anomalią. Źródła: `scripts/levels/station_05.gd`, w. 84–135; `scripts/levels/creative_scene_lines.gd`, w. 20–33, 42, 73–82; `scripts/levels/station_43.gd`, w. 218–273 i 311–314.

**Warunek redakcyjnego domknięcia:** każde pozostawione zdanie zmienia wiedzę, zamiar albo relację. Zdanie, które jedynie poświadcza zgodność sceny z zasadą autora, znika.

## 12. Miejsca największego ryzyka utraty uwagi

Dla każdego wpisu dokładna sekunda: **brak danych**. Nie są to wyniki obserwacji publiczności.

| Moment | Dlaczego widz/gracz może się odłączyć | Źródło |
|---|---|---|
| 05: obowiązkowe sprawdzenie torby przed przejściem przez jezdnię | Powtórzenie bez nowego konfliktu. Historia stoi, choć gracz wykonuje czynności. | `scripts/levels/station_05.gd`, w. 100–131. |
| 06: „Długo dziś jeszcze otwarte?” | Scena porzuca własne pytanie o zmienioną trasę. | `scripts/levels/station_06.gd`, w. 159 i 199. |
| 15: „To moja świadoma decyzja” | Znika człowiek, pojawia się instrukcja interpretowania sceny. | `scripts/levels/creative_scene_lines.gd`, w. 42. |
| 16: urwana wypowiedź Marty przy rzekomo własnym koszcie Leny | Odbiorca przestaje wiedzieć, kogo skrzywdził i co wybrał. | `scripts/levels/creative_scene_lines.gd`, w. 49–51. |
| 18: „Wrócę do hali i zapytam jeszcze raz” | Poszanowanie odmowy wygląda jak obowiązek wykonania kolejnego podejścia. | `scripts/levels/station_18.gd`, w. 131. |
| 42B: „Przepływ zamknięty” przed wykonaniem | Rozstrzygnięcie zostaje ogłoszone, zanim odbiorca ma przeżyć decyzję jako czyn. | `scenes/levels/station_42b.tscn`, w. 65–66; `scripts/levels/station_42b.gd`, w. 213–227. |
| 43: „cienka nić pamięci i obustronnej zgody” | Konkretna cena zostaje zastąpiona sentymentalną interpretacją. | `scripts/levels/station_43.gd`, w. 241–242. |

## 13. Konkluzja

Nie rekomenduję wymiany tej historii na bardziej widowiskową zagadkę wieloświata. Jej najlepszy materiał już istnieje: **kurtka, której znaczenia nie da się uzgodnić; brat, który ma własną zmianę w pracy; partnerka, która chce odzyskać konkretną osobę, nie podobną twarz.** Źródła: `scripts/levels/creative_scene_lines.gd`, w. 21–22 i 27–29.

Rekomenduję natomiast **twardą przebudowę narracyjną końcówki w granicach istniejących scen**: uporządkowanie czasu kulminacji, właścicieli wspomnień, przepływu wiedzy, warunków zgody i różnic między kosztami. Bez tego historia mówi o odpowiedzialności, ale jej własny sposób opowiadania nie zawsze pozwala ustalić, kto za co odpowiada. Dowody tych problemów: `scripts/levels/creative_scene_lines.gd`, w. 48–51, 60, 65–76 i 90–116; `scripts/levels/station_18.gd`, w. 131 i 384–388; `scenes/levels/station_42b.tscn`, w. 65–66.

**Najważniejsza zmiana nie brzmi: dopisać więcej wyjaśnień. Brzmi: przestać poświadczać temat dialogiem, a zacząć konsekwentnie obciążać nim działania ludzi.**
