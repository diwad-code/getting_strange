# Getting Strange — niezależny red-team kreatywny i plan poprawy

> Aktualizacja wykonawcza 2026-09-05: CR-A zamknięty technicznie jako PKG-0193;
> wynik i ograniczenia: `PKG_0193_CREATIVE_SCENES.md`. CR-B → CR-C → CR-D
> pozostają kolejką następnych sesji. Poniższy opis sesji planistycznej jest
> historycznym zakresem tamtego zlecenia, nie zakazem obecnej implementacji.

**Data:** 2026-09-05.  
**Punkt odniesienia:** stan dysku po PKG-0192, Godot 4.7.2, P9.  
**Status:** PLAN DO WDROŻENIA W OSOBNYCH SESJACH — OPINIA REDAKCYJNA JEDNEGO MODELU.  
**Zakres:** 20 odwiedzanych adresów `01–18 → 42A/B/C → 43`, czyli 22 warianty sceniczne.  
**Wynik sesji:** wyłącznie ten nowy dokument. Bez zmian w istniejących dokumentach, kodzie, scenach i assetach; bez przydzielenia numeru PKG, wpisu do SESSION_LOG ani snapshotu pakietu implementacyjnego. To jawny wyjątek wynikający z polecenia właściciela dla tej sesji.

## 1. Werdykt ogólny

**Zachować opowieść i trasę 20 adresów. Przemodelować sposób rozegrania środka i finału. Nie traktować obecnej prezentacji jako skończonej gry wymagającej wyłącznie kosmetyki.**

Moim zdaniem fundament wystarcza na tę trasę: diagnostyczka uciekająca w pomiary przed żałobą; bliska osoba, której znajome ciało nie daje prawa do cudzej intymności; brat, który nie chce być dowodem; druga Lena odpowiadająca dzięki wspólnej kompetencji; instytucja, która ocala własnych ludzi, usuwając koszt poza pole widzenia. To są konflikty zdolne wzajemnie się wzmacniać. Nie potrzeba następnej tajemnicy, postaci przewodnika ani nowych stacji.

**Problemem dominującym jest niedostarczenie tych konfliktów w aktywnych scenach.** Czytając biblię, dostaję rozmowę z Martą i spotkanie z żywym bratem. Czytając podpięte akcje 10–12, dostaję głównie zapis faktu, że rozmowa lub spotkanie nastąpiły. W stacji 13 rozpoznanie ma obecnie wyraźne zdanie w winiecie, ale nie dostaje równie wyraźnej wymiany „Więc gdzie jest ona?” / „Nie wiem” w scenie. W drugiej połowie złożona etyka zamienia się często w wybór strony stanowiska i zapis zakresu.

Tempo ma zatem dwa różne problemy: **01–08 za często potwierdza to, co właśnie pokazało; 09–18 za szybko przechodzi nad tym, co powinno się wydarzyć między osobami.** Dodawanie tekstu wszędzie pogorszyłoby pierwszy problem. Skracanie tekstu wszędzie pogłębiłoby drugi. Zalecam przenieść uwagę i czas z komentarzy o czynnościach do kilku konkretnych scen relacyjnych.

Trzy zakończenia mają odrębne wartości i straty w kanonie. W aktualnej prezentacji ich podobny układ „wykonaj → odczytaj próg → odczytaj stół”, podobne wnętrza i zdania objaśniające znaczenie spłaszczają różnicę. **42C grozi odczytaniem jako wariant uprzywilejowany:** obie Leny wracają, podczas gdy koszt przecieku jest bardziej abstrakcyjny od uwięzienia w A i utraty domu w B. To moja ocena konstrukcji, nie wynik badania odbiorców.

Nie zmieniam `PRODUCT GO CANDIDATE`, czternastu formalnych werdyktów ani GATE-REL. Werdykt tego dokumentu jest osobny: **fundament — zachować; dramatyzacja i reżyseria — wymagają istotnej poprawy.**

## 2. Metoda, źródła i granica twierdzeń

Przeczytano AGENTS, CURRENT_STATE, INDEX, PLAYER_CONTRACT, CAMPAIGN_MAP, cztery dokumenty narracyjne, master §4.8 ACCEPTANCE_MATRIX, cały RISKS_AND_HYPOTHESES, audyt PKG-0187 oraz dziewięć defektów. Następnie prześledzono akcje, teksty, guidance i podpięcia wszystkich 22 skryptów aktywnych stacji, teksty ich scen oraz wspólne mechanizmy prezentacji. NEXT_SESSION_PROMPT i specyfikację PKG-0189 przeczytano jako kontekst granic, nie zlecenie uruchomienia refaktoru MRP.

Skill `natural-dialogue-techniques` służył do pytań o cel mówiącego, odrębność głosu, podtekst, gest i ekspozycję. Nie zastosowano norm powieści internetowej, punktacji „AI-owości” ani symulowanych person. Wnioski twórcze wynikają z bieżącego materiału projektu, nie z poprzednich ocen modelu.

**Obejrzano bezpośrednio wszystkie 106 PNG z `reports/pkg_0187/visual/`:** 88 kadrów stacji (22 × opening/normal/threshold/mono), 7 kadrów NPC, 5 portretów, dialog, myśl, tytuł, ustawienia, pauzę i zimne otwarcie. Dodatkowo obejrzano wszystkie 14 aktualnych plansz z `assets/cinematics/` i przeczytano katalog oraz reżyser winiet PKG-0190. Nie wykonano nowego capture'u ani ręcznego przejścia gry. Nie oceniano hashy i luminancji jako urody.

| Oznaczenie | Co znaczy | Granica |
|---|---|---|
| FAKT ŹRÓDŁOWY | konkretny tekst, warunek, podpięcie lub zawartość obrazu | nie oznacza zmierzonego doświadczenia w grze |
| OPINIA | mój osąd redakcyjny lub plastyczny, oparty na wskazanym materiale | inny redaktor może zasadnie ocenić go inaczej |
| REKOMENDACJA | świadoma propozycja do następnej sesji wykonawczej | nie jest wdrożeniem ani nową zaakceptowaną decyzją D-xxx |
| DO SPRAWDZENIA W RUNTIME | zachowanie, którego kolejności/czasu nie rozstrzyga lektura i statyczny kadr | nie jest ukrytym PASS ani automatycznie blockerem |

### 2.1 Najważniejsze kotwice dowodowe

Ścieżki i numery linii dotyczą stanu odczytanego w tej sesji; po implementacji lokalizować też po nazwie funkcji. Skrót `station_NN.gd` oznacza `scripts/levels/station_NN.gd`, a `station_NN.tscn` — `scenes/levels/station_NN.tscn`. Fragment kodu w tabeli jest dowodem treści, nie oceną literacką samą w sobie.

| ID | Fakt źródłowy | Znaczenie dla planu |
|---|---|---|
| E01 | `station_01.gd:329–335`, `station_02.gd:100`, `station_03.gd:111–120`, `station_04.gd:114`: kolejne deklaracje powrotu, opóźnienia i odkładania czytnika | materiał do odchudzenia ekspozycji, bez kasowania wyboru próbka/obietnica |
| E02 | `station_05.gd:88–100` mówi bez warunku „Surowa próbka drgań jest w torbie”; `station_01.gd`, `pack_equipment_for_marta()` zapisuje `home_sample_preserved=false` | faktyczny rozjazd gałęzi tekstowej, nie subiektywna nuda |
| E03 | `station_07.gd:101`, `station_07.tscn:79`, `station_08.tscn:98`: „Kowalska”; biblia ustanawia Martę Kurek. `station_13.tscn:74–81`: Sadowa **7 m.** 12/14, podczas gdy 07 mówi o numerze fasady | niezamierzona dodatkowa zagadka nazwiska i numeracji; wybrać jeden adresowy zapis |
| E04 | `station_09.gd`, `observe_two_lives/observe_relation_photo/respect_private_boundary`: zapis stanu; `_setup_guidance()` nadal mówi o donicy, piętrze i sąsiadce | scenariusz salonu i pomoc mówią o innych czynnościach |
| E05 | `station_10.gd:269–295`: trzy akcje zapisują domową czynność, dzień Marty i granicę, bez prezentacji rozmowy; `station_10.tscn:146–174` daje tytuły i podtytuły rekwizytów | „Pamięta inny dzień” nie dostarcza dwóch konkretnych wspomnień |
| E06 | `station_11.gd:319–352`: profil, 186 dni i raport; `station_11.tscn:78–90` nadal mówi o prywatnych rzeczach, odbitce i ładowaniu czytnika | aktywna instytucja jest opowiadana językiem wcześniejszego mieszkania |
| E07 | `station_12.gd:281–310`: pytania, spotkanie i odmowa zapisują fakty; `station_12.tscn:77–89` otwiera sekretarka i telefon Marty; rig ma `initial_state=work` | brakuje treści pytań i odpowiedzi, na których ma stać emocjonalny zwrot |
| E08 | `station_13.gd:308–325` zapisuje syntezę i emituje sygnał; `cinematic_catalog.gd:60` zawiera „To nie jest mój świat”; brak wymiany Marty w tej akcji | winieta daje zdanie rozpoznania, ale nie pełny zwrot celu na drugą Lenę |
| E09 | `station_15.gd`, `_on_prop_resonance_triggered()`: po dwóch kontrolach ten sam nadajnik sam wybiera impuls korygujący. Tekst notatki w scenie to „Warunek przerwania próby” | dobry pomysł testu, słabsze autorstwo błędu i niedostarczona treść zamiaru |
| E10 | `station_16.gd:184–210`: strona selektora wybiera pamięć Marty albo sekundę próbki; `confirm_home_echo()` używa dźwięku kontaktu i zdania „Echo domu wraca po jednym małym ubytku” | zapis kosztu nie jest sceną utraty konkretnego wspomnienia; brak tu rozmowy domowej Marty z biblii |
| E11 | `station_17.gd:172–227`: pozycja względem biurka wybiera `refused/limited/granted`; CRT ma kwestie odmowy i zgody pełnej, brak równorzędnej kwestii `limited` | nierówna dramaturgia odpowiedzi; zgoda wygląda jak nastawa stanowiska |
| E12 | `station_18.gd:251–266` zapisuje prawdę Marty bez rozmowy; `_build_forecasts()` buduje zależności od zgody Jakuba; scena nazywa „witrynę Marty” i „słupek zatwierdzenia” | rzeczy świata są nazwami funkcji projektu; brakuje wypowiedzianej prawdy i osobistej ceny metod |
| E13 | `station_42a/b/c.gd`, `DIALOGUE_LINES` i `_setup_guidance()`: „To skutek, nie ocena”, „nie nagroda”, tezy Jakuba o obu Lenach | do napisania ponownie, jeśli mają wejść w żywy dialog; nie cytować jako udowodnionego przebiegu rozmowy |
| E14 | `station_43.gd:160–239`: różne tablice epilogu, Szymon w B i wspólna sentencja „Prawda nie wybiera za człowieka… Koniec wycinka fabularnego”; `_setup_guidance()` mówi o „stanie podmiotów” i „fałszywym happy endzie” | język dokumentacji przenika zakończenie |
| E15 | `tools/capture_pkg_0187.gd:25–31` i `_capture_panels()`: kwestie portretowe, w tym Szymona i odmowa Jakuba, są podawane przez narzędzie capture | portret z kwestią nie dowodzi obecności tej rozmowy na trasie |
| E16 | `CharacterVisualRig` ma siedem stanów, lecz nie prowadzi rozmów; `StationDialogueCue` prezentuje pojedyncze otwarcie; `CRTDialogueBox.show_line()` tworzy jednoelementową kolejkę | istnienie riga i tablicy DIALOGUE_LINES nie wystarcza do uznania sceny za rozegraną |

**Istotne zastrzeżenie o finałach:** w odczytanych 42A/B/C nie ma uruchomienia pełnego `DIALOGUE_LINES` z ich aktywnych akcji. `advance_dialogue()` jest dostępne, ale samo istnienie metody nie dowodzi wejścia do rozmowy. W 43 `_ready()` i interakcje pokazują pojedyncze linie przez `show_line()`, podczas gdy `OpeningDialogueCue` osobno prezentuje otwarcie. Kolejność, nadpisywanie oraz osiągnięcie każdej kwestii trzeba sprawdzić przy wdrożeniu. Nie przypisuję graczowi przeczytania wszystkich znalezionych tablic.

## 3. Osiem sekwencji po kompresji do P9

Sekwencje I–VIII są funkcjami dramatycznymi z FULL_STORY, nie dawnymi numerami do przywrócenia. Granice częściowo się nakładają: obecny 10 scala III/IV i granicę z VI, 11 scala IV/V, 15 i 16 zawierają również materiał VII, 18 łączy VI/VII/VIII.

Wszystkie sądy w poniższej tabeli są **moją opinią redakcyjną**. Pytanie o finały dotyczy tego, jak dana sekwencja przygotowuje późniejsze emocjonalne rozróżnienie A/B/C.

| Sekwencja i obecne adresy | Tempo | Dialog i człowiek | Eskalacja mystery | Przygotowanie A/B/C | Gdzie najbardziej czuć system |
|---|---|---|---|---|---|
| I — Próbka: 01–05 | Konflikt jest dobry, lecz pięć stacji wielokrotnie mówi „Marta czeka / odkładam czytnik”. 05 miało dawać oddech, a ma trzy potwierdzenia | Wiadomość Marty działa; odpowiedzi Leny za często są raportem z poprawnie wykonanego wyboru | Luka i pomnik są wystarczającą zapowiedzią. Nie dokładać paranormalności | Muszę zobaczyć wartość domowej Marty, aby rozumieć pokusę A i stratę B; obecnie jest głównie oczekującym adresatem | „Sprawdzę ulicę”, „sprawdzę torbę”, statusy domknięcia |
| II — Rysa: 06–08 | Kolejne niezależne źródła mają sens, ale każde kończy na 14; sprzedawca zdradza zbyt wiele naraz | Zakup wody brzmi zwyczajnie. Długa pewna deklaracja sprzedawcy o wspólnym wychodzeniu jest nadmiernie użyteczna dla autora | Rośnie liczba potwierdzeń; słabiej zmienia się rodzaj zagrożenia | Powinna ustanowić codzienność miejscowej Leny, którą A poświęci; nie wyłącznie poprawny numer | Kupno wody wymaga wcześniejszego odczytu rozkładu; komplet kroków przewidziany z góry |
| III — Cudzy dom: końcówka 08, 09, część 10 | Dobre miejsce na gwałtowne zwolnienie, obecnie fotografia i granica zostają zaliczone niemal bez sceny | Brakuje prawa do małego odruchu: Lena zna gest Marty, ale nie zna domowego rytuału | Z adresu powinno powstać pytanie o intymność; nazwa „Fotografia Marty i Leny” w danych punktu nie zastępuje takiego odkrycia | Potrzebny ślad miejscowej Leny niewynikający z eksperymentu, aby nie była tylko brakującym kluczem finału | Stemplowanie prywatności i guidance od sąsiadki pozostawiony w salonie |
| IV — Marta i zapis: 10–11 | Tu potrzebna jest scena, po której Lena ma konkretny powód iść do UCP; obecnie most jest głównie ciągiem flag | Nie oceniam nieistniejącej aktywnej rozmowy jako „sztywnej”: najpierw należy ją dostarczyć. Materiał biblii o kurtce i parkingu nadaje się do adaptacji | Wspomnienie → obca praca to mocna eskalacja, jeśli źródła rzeczywiście pokazują różne biografie | Granica Marty ma przygotować odmowę zastępstwa w każdym finale, nie punkt przyjaźni | Biometria, minimalny zakres raportu i akceptacja granicy brzmią jak cele testu |
| V — Niemożliwy brat: część 11, 12–13 | Największy potencjalny szczyt zostaje przyciśnięty między rejestrem a stołem syntezy | Potrzebne pytanie o schowek, niepasująca odpowiedź i odmowa blizny; potem zwykła czynność Jakuba. Sam rig przy imadle nie wystarcza | Ontologicznie to najmocniejszy dowód. Emocjonalnie musi najpierw zdarzyć się spotkanie, dopiero potem wniosek | Żywy brat powinien być pokusą pozostania i osobą, której nie wolno rozliczyć za cudzą śmierć | „Trzeci znak: Jakub” i `meeting_completed` sprowadzają go do źródła |
| VI — Test wzajemny: 14–16, prognozy w 18 | 14 faktycznie zmienia czasownik; 15 ma najlepszy pomysł sprawdzalnego odkrycia. 16 znów staje się obsługą aparatu | Precyzja jest wiarygodna u Leny, ale potrzebuje przerwania przez cudzą odpowiedź. Brak sceny utraty pamięci zabiera kosztowi ciężar | Log → celowo błędny impuls → brak drugiej Leny w domu to dobra drabina; ostatni szczebel jest obecnie zbyt ogólny | Koszt pamięci musi być wcześniej konkretny, aby C nie wyglądało jak drobna dopłata do uratowania wszystkich | Automatycznie „błędny” trzeci klik i wybór kosztu po stronie selektora |
| VII — Rachunek Linii 4: notatka 15, echo 16, 17 i prawda w 18 | Za dużo ciężkich rozstrzygnięć w dwóch końcowych adresach; nie zwiększać liczby adresów, uporządkować trzy akty 17 | Wierzbicka ma moralnie złożony argument w biblii, w aktywnej scenie zastępuje ją oferta terminala. Jakub odmawia mocniej, niż rozmowa zdążyła przygotować | Osobista katastrofa powinna stać się oskarżeniem wobec sposobu liczenia UCP; „ktoś drugi zapłacił” to zbyt ogólny skrót | A ma powtarzać logikę UCP; B ma chronić realną społeczność; C ma oddawać kontrolę. Wszystkie wymagają konkretu przed wyborem | Biurko „zakresu zgody”, brak równorzędnej wypowiedzi limited, wybór „prawdy albo części” bez treści |
| VIII — Metoda i skutek: część 18, 42A/B/C, 43 | Trzy finały powtarzają format odczytu, potem epilog ponownie tłumaczy. Brakuje ciszy po ostatnim ludzkim zdarzeniu | Głosy zastępują hasła „Obie jesteście prawdziwe” i sentencja autora. Kubek w C jest lepszy od tych komentarzy | Nowego mystery już nie potrzeba. Trzeba jasno odróżnić miejsce obu Len, dwie Marty i kanał każdego głosu | A: ulga skażona przemilczeniem; B: oddanie miejsca i samotność; C: powrót z naruszoną prywatnością. Obecnie odrębność mocniejsza w kanonie niż w rozegraniu | Odczyt konsekwencji, etykiety „nieindeksowanej obecności”, credits i „stan podmiotów” |

## 4. Tabela problemów całej trasy

Wielkość opisuje nakład twórczy, nie estymację godzin. „Mały tekst” nie oznacza zwolnienia z kontroli wiedzy i wariantów. „Przepisanie sceny” dotyczy istniejącego adresu, nie dodania lokacji. Każda pozycja zawiera propozycję, a nie stwierdzenie dokonanej poprawy.

| Adres / sekwencja | Co jest słabe | Dlaczego — opinia redakcyjna | Konkretna poprawka | Szacowana wielkość zmiany |
|---|---|---|---|---|
| 01 / I | Lena od razu raportuje dokonany wybór; wiadomość wróci prawie tak samo w 03 (E01) | Zawodowy unik powinien być cechą człowieka, nie podsumowaniem zadania | Zostawić wybór, nośniki i różne stany. Skrócić odpowiedź do Marty; po odłożeniu/ochronie próbki jeden gest torby zamiast kolejnego opisu. Nie usuwać warstwy B | mały tekst |
| 02 / I | Dwanaście minut zostaje nazwane dwa razy; obejście dostaje osobną procedurę potwierdzania (E01) | Powrót zaczyna przypominać serię odbiorów technicznych | Jedno miejsce podaje czas, drugie pokazuje Lenę chowającą telefon przed wejściem na drabinę. Zachować akcje i drogę; nie wydłużać przejścia przeszkodą | mały tekst |
| 03 / I | Ponownie „czy jedziesz”; godzina 20:47 i obejście po pomiarze 20:40 wymagają spójnej interpretacji | Stawka czasu staje się umowna, kiedy kolejne wiadomości nie wnoszą nowego nacisku | Nie powtarzać prośby z 01. Marta odpowiada krótkim domowym konkretem. Ujednolicić czas jako zegar zdarzeń, nie obietnicę zmierzonego czasu gry | mały tekst |
| 04 / I | Pomnik opisany wprost; czytnik zostaje ponownie „odłożony” nawet po spakowaniu (E01–02) | Motyw żałoby ma potencjał w uniku, opis odbiera mu przestrzeń | Po spojrzeniu na pomnik Lena zasłania ekran i nie dopowiada emocji. Oddzielić bufor od fizycznej próbki dla obu decyzji z 01. Bez imienia Jakuba w dodatkowej ekspozycji | mały tekst |
| 05 / I | Oddech wymaga trzech potwierdzeń; tekst wymyśla próbkę w torbie (E02) | Znana ulica wygląda jak następny test, a wcześniejszy wybór traci wiarygodność | Natychmiast rozdzielić tekst pełnej próbki / spakowanego czytnika / pominiętego sprawdzenia. Zachować trzy punkty, ale usunąć komentarze do każdego; pełne tło i zwykły dźwięk mają unieść spacer | mały tekst |
| 06 / II | Rozkład od razu mówi o 12/14; sprzedawca podaje adres i wspólne życie (E03) | Zamiast osobnych rozbieżności dostaję trzy potwierdzenia tej samej odpowiedzi | Rozkład: konkretny konflikt trasy i daty. Sprzedawca: zakup Marty, imię i własny zamiar zamknięcia kiosku. Adres i wspólne zamieszkanie pozostawić późniejszym źródłom | przepisanie sceny |
| 07 / II | M. Kowalska i niejasność budynek/lokal (E03) | Przy celowo niewiarygodnej rzeczywistości redakcyjny błąd udaje poszlakę | Przyjąć: Sadowa 7, mieszkanie 12 w dokumentach przybyłej, 14 lokalnie. Zmienić odczyty rozkładu/fasady/domofonu spójnie; Marta Kurek, Kowalczyk nadal lokator 12. Nie podmieniać wszystkich Kowalskich globalnie — sąsiadka ma to nazwisko | mały tekst |
| 08 / II–III | Sąsiadka ogłasza informację bez rzeczywistego pytania kontrolnego; otwarcie klucza ma długi opis (E03) | Postać istnieje dla zeznania, a odruch Leny nie dostaje miejsca | W istniejącym punkcie dodać „Kto mieszka pod dwunastką?” i rzeczową odpowiedź podczas domowej czynności. Po kluczu cisza. Podpis winiety ograniczyć do ostrożnej hipotezy o kluczu, bez pewności „nie jestem intruzem” | przepisanie sceny |
| 09 / III | Fotografia i granica to nazwy punktów, guidance opisuje dawną klatkę (E04) | Brakuje niewygodnego odkrycia bliskości; zamiast niego zostaje tabliczka o dwóch nakryciach | Trzy istniejące punkty: dwa komplety rzeczy; czytelny detal zdjęcia z Martą; cofnięta ręka przy zamkniętej sypialni. Usunąć pomoc o sąsiadce/donicy i komentujący plakat. Nie dodawać zbieralnych sekretów | przepisanie sceny |
| 10 / III–IV | Główna rozmowa Marty nie jest dostarczona przez czynności (E05) | To luka dramatyczna w sercu gry | W trzech punktach rozegrać: przerwany domowy rytuał; deszcz/kurtka/parking kontra początek związku; telefon pozostający przy Marcie. Lena wychodzi po historię pracy, bo boi się oddać sprawczość | przepisanie sceny |
| 11 / IV–V | Czyta się jak dawny salon, a zapisywana historia Jakuba nie ma równorzędnej prezentacji (E06) | Zmieniam instytucję w menu źródeł, a niemożliwy brat pojawia się w stanie przed sceną | Karta: obcy numer przy zgodnej biometrii; rejestr: 186 dni Leny i dwa nazwane niezależne źródła życia Jakuba po dacie katastrofy; raport: 20:40 i brak numeru czytnika. Wierzbicka żąda urządzenia, ogranicza dostęp do danych, nie wyjście | przepisanie sceny |
| 12 / V | Brak właściwej rozmowy; Jakub przy imadle od wejścia, tekst o sekretarce (E07) | Spotkanie nie dostaje różnicy między głosem a żywą osobą; ciało brata jest wyposażeniem planszy | Pierwszy punkt: łącze z pytaniami o schowek i tunel; drugi: odłożenie narzędzia i kontakt wzrokowy; trzeci: „Pokaż bliznę” / „Nie” oraz dobrowolne sprawdzenie numeru czytnika. Przed pierwszym kontaktem kadrować Jakuba zajętego pracą, bez paranormalnego ukrywania | przepisanie sceny |
| 13 / V | Trzy źródła i rozpoznanie są abstrakcyjne; brak pytania Marty po wniosku (E08) | Wniosek logiczny nie staje się nowym osobistym celem | Zestawić domowy nośnik, lokalny zapis i ślad spotkania z Jakubem przy znanym stole. Po jawnej syntezie: zdanie Leny, reakcja Marty „Więc gdzie jest ona?”, „Nie wiem”. Nie powielać zdania z winietą; zapewnić sens również po jej pominięciu | przepisanie sceny |
| 14 / VI | Prawdziwa zmiana czasownika dostaje instrukcję przewidującą cały eksperyment | Po 13 potrzebuję pierwszej ostrożnej próby, nie nowej pewności Leny | Zachować działający obwód i odwracalność. Najpierw widoczna zmiana sekcji, potem robocze nazwanie. Hipoteza ma przewidywać jedną rzecz, a pełna instrukcja pozostać pomocą przy zastoju | mały tekst |
| 15 / VI–VII | Trzeci klik sam jest „celowym błędem”, notatka nie podaje konkretnego abortu (E09) | Odkrycie jest interesujące, lecz Lena wykonuje je za rękę odbiorcy | W tym samym nadajniku pokazać dwie równe próby, następnie świadomie przestawiany jeden element trzeciej; nie nowa zagadka. Dziennik pokazuje kolejność kontakt → komenda Wierzbickiej, notatka: brak zgody i abort po 3 s. Wyjaśnić, dlaczego ta korekta wskazuje na miejscową Lenę, nie dowolny układ automatyczny | przepisanie sceny |
| 16 / VI–VII | Płaci się nazwą wspomnienia lub sekundy, echo domu nie jest domowym zdarzeniem (E10) | Nie mogę odczuć utraty szczegółu, którego nigdy nie dostałem; tęsknota znika w aparacie | Użyć konkretu wyprawy ustanowionego w 10: Marta przez łącze nie kończy zdania. Alternatywnie ubytek w pokazanym wcześniej zapisie. Przy odbiorniku wiadomość domowej Marty i sprawdzenie braku miejscowej Leny, bez podróży w czasie | przepisanie sceny |
| 17 / VII | Rejestr, pokusa i zgoda są trzema abstrakcyjnymi stanowiskami (E11) | To kulminacja Linii 4, a brzmi jak negocjacja uprawnień | Trzy akty: zestawienie pary katastrof; propozycja Wierzbickiej zachowania roli kosztem pamięci; konkretne pytanie do Jakuba i jego odpowiedź dla każdego zakresu. Nie odmawiać adaptacji w myśli zanim oferta wybrzmi | przeprojektowanie sekwencji |
| 18 / VI–VIII | Prawda bez treści; trzy pozycje ciała wybierają intymną decyzję; witryna nie ma właściciela fabularnego (E12) | Najważniejszy wybór ma postać ustawienia przełącznika | Tablica pokazuje osoby, chronioną wartość i znaną stratę każdej metody; istniejące łącze/witryna obsługuje rozmowę z Martą; słupek staje się rozpoznawalnym sterownikiem serwisowym. Każdy wybór zapowiada konkretną czynność przed zatwierdzeniem | przeprojektowanie sekwencji |
| 42A / VIII | Pusty stół i raportowanie krzywdy, nie ulga spotkania; niewyjaśniony głos Jakuba w domowej ciągłości (E13) | Bez ulgi nie ma czego skazić; nagły Jakub może sugerować cofnięcie jego śmierci | Domowa Marta pyta, gdzie Lena była; Lena wyciąga czytnik zamiast odpowiedzieć. Pozostaje brak drugiego sygnału i propozycja „BŁĄD CZUJNIKA”. Jakub tylko w wyraźnie wcześniejszym zapisie, nigdy jako żywy domowy rozmówca | przepisanie sceny |
| 42B / VIII | Przybyła stoi przy odzyskanym domu, ale opisuje się ją jako nieindeksowaną; miejscowa jest matową plamą | Niejasność punktu widzenia osłabia stratę, a odzyskanie osoby nadal jest symbolem | Najpierw czytelny powrót miejscowej Leny i pytanie Marty o wiedzę przed testem, potem wyraźne cięcie perspektywy przybyłej do znanej rodziny przystanku bez indeksu domu. W tym samym adresie, z zachowanym układem przejścia | przepisanie sceny |
| 42C / VIII | Dwa domy odzyskane, koszt przedstawiony jako ogólna nić pamięci (E13–14) | C może wyglądać jak poprawna odpowiedź na quiz o zgodzie | Zachować powrót obu. Wykorzystać kubek/pustą półkę i konkretny obcy szczegół domowej Marty; krótki zapis epizodu pamięci śmierci Jakuba. Zapowiedzieć rodzaj ryzyka już w 16–18; nie wymyślać nowej katastrofy jako dopłaty | przepisanie sceny |
| 43 / VIII | Szymon znikąd, administracyjne streszczenie, sentencja i manifest techniczny (E14–16) | Gra kończy się głosem dokumentacji po opowieści o prawie ludzi do własnego głosu | Trzy istniejące punkty: konsekwencja publiczna i osobiste domknięcia; credits/licencje pokazane na żądanie; ostatnia konkretna czynność. Wszystkie siedem podmiotów z trackera ma jawny nośnik, bez siedmiu nowych klikadeł. Zakończyć gestem, nie tezą | przeprojektowanie sekwencji |

**Rozróżnienie warstw:** `prop_title` i `prop_subtitle` w scenie są metadanymi rekwizytu. Nie zaliczam ich automatycznie do przeczytanego przez gracza tekstu: w sprawdzonych skryptach MRP nie stanowią wywołania CRT. Osobno oceniono rzeczywiste `CrispDiegeticText.text`, `opening_line`, `_present()`, guidance i podpisy winiet. Problem braku sceny nie znika nawet wtedy, gdy podtytuł jest poprawnym opisem intencji autora.

## 5. Jawna decyzja o Szymonie

**REKOMENDACJA CR-D01: wariant (b) — Szymon pozaekranowy, bez planowanego ciała na aktywnej trasie. Zamknąć dług D-194 C przy wdrożeniu.**

### Co rzeczywiście znaleziono

| Źródło | Ustalenie | Czego z niego nie wywodzę |
|---|---|---|
| NARRATIVE_BIBLE, FULL_STORY, CONTINUITY_TRACKER, DIALOGUE_SCRIPT | W czterech odczytanych plikach nie ma Szymona Bery ani Igi; tracker siedmiu podmiotów finału go nie zawiera | nie mogę uczciwie opisać go jako ustanowionej postaci obecnej wersji fabuły |
| `CAST_AND_NPC_BIBLE.md` §2.5 | Starszy, zniszczony mężczyzna w instytucjonalnym swetrze; portret istnieje, ciało poza zakresem | projekt wyglądu nie ustanawia roli fabularnej |
| `DECISION_LOG.md`, D-052/D-053 | W starej wersji Szymon Bera był człowiekiem poddanym adaptacji; rysunek studni i imię córki Igi pokazywały różnicę między zachowaniem publicznego faktu a utratą prywatnej więzi | to historyczna funkcja, nie pozwolenie na przywrócenie dawnej sali 20/21 |
| D-194 | Wybrano wariant B obsady; pełna obsada C była odłożona. Samo hasło „D-194 C” nie jest zleceniem wstawienia Szymona | brak ciała nie oznacza automatycznie błędu w obecnej fabule |
| `station_43.gd:203` | W gałęzi B pojawia się rozmowa Szymona i Marty o pogodzie | wzmianka bez wcześniejszego ustanowienia nie zamyka starego wątku |
| `tools/capture_pkg_0187.gd`, PORTRAIT_SPEAKERS | Portret i zdanie o studni zostały pokazane przez harness | nie jest to spotkanie Szymona z Leną na trasie |

### Uzasadnienie twórcze

Historyczna funkcja Szymona była dobra: szkoda wyrządzona konkretnej relacji, której poprawny raport nie rejestruje. Obecna historia ma już silniejsze, bezpośrednio związane z Leną nośniki tego samego tematu: utrata pamięci Marty w 16, życie Jakuba i rejestr Linii 4 w 17 oraz los obu Len. To im należy oddać czas.

Najbardziej logicznym adresem ewentualnego spotkania byłby 17, ale jego trzy sloty już niosą rachunek katastrofy, ofertę adaptacji i zgodę Jakuba. Zastąpienie jednego Szymonem usuwa istotny etap głównego konfliktu; dopisanie opowieści o studni i Idze do rejestru obciąża kulminację nowym wątkiem. Ciało bez tej historii byłoby tylko dekoracją spełniającą stary dług obsadowy.

**Docelowy zapis decyzji wykonawczej:** „Szymon Bera pozostaje poza wydarzeniami aktywnej trasy P9. Materiał studni/Igi jest historią wycofanego przebiegu; nie wymaga spotkania, ratunku ani epilogu w kampanii 20 adresów. Funkcję pokazania prywatnego kosztu instytucjonalnej korekty realizują Marta i Jakub. Brak ciała Szymona nie jest otwartym długiem P9”.

Nie dopisywać, że zmarł, został uratowany, uciekł albo że Lena go zna: żadne takie zdarzenie nie jest potrzebne. W 43B zastąpić osieroconą wzmiankę konsekwencją dla już ustanowionej osoby, najlepiej nadal poszukującej przybyłej Leny domowej Marty. W aktualizacji dokumentów zamknąć wyłącznie dług obsadowy, zachować historyczne wpisy D-052/D-053. Istniejącego portretu nie usuwać tylko dla porządku. **Bilans interakcji: +0; bilans nowych scen: +0.** Decyzja jest podjęta w tym planie, formalny wpis i zmiana epilogu należą do następnej sesji.

## 6. Ocena obrazu

### 6.1 Werdykt plastyczny

**Moim zdaniem gra nadal ma miejscami jakość dopracowanego blockoutu, a nie jednolicie wyreżyserowanej przestrzeni.** Najlepiej broni się salon 09: niski sufit, sofa, mały stół, ceramika i zasłony tworzą jedno wnętrze. Czytelny jest też rytm wiaty i wagonu 03–04. Bardziej szczegółowe sprite'y ludzi kontrastują jednak z dużymi prostokątnymi meblami i pustymi ścianami. Powtarzalne obramowanie wyjścia ma często większą siłę niż relacja osób.

To nie rekomendacja pokrycia świata większą liczbą faktur. Potrzebne są przede wszystkim **kontakt rzeczy ze sobą, hierarchia i sytuacja**: ręka faktycznie pracująca przy imadle, filiżanka odsunięta od drugiego nakrycia, lada zasłaniająca właściwą część siedzącej osoby, dom rozpoznawany po układzie przedmiotów. Trzy kontrastowe punkty w równych odstępach pozostają trzema punktami także po ozdobieniu.

### 6.2 Ewidencja oglądu wszystkich adresów

Dla każdego adresu obejrzano jego `__normal`, `__opening_panel`, `__threshold` i `__mono`. Dodatkowe `__npc_frame` obejrzano dla 06/08/10/11/12/42B/42C. Nazwy poniżej są skrótami plików w `reports/pkg_0187/visual/`; uwagi są opinią o obrazach, nie nową oceną GATE-FAM.

| Kadry | Co widzę / oceniam | Kierunek korekty |
|---|---|---|
| 01 | Duża skośna maszyna daje dominantę; reszta przypomina osobne ikony stanowisk, śluza jest bardzo wyraźna | Podłączyć bęben, ekran i przewody w jeden wiarygodny układ pomiarowy; zachować czytelną dominantę |
| 02 | Nasyp i sylweta miasta tworzą warstwy, lecz czarny środkowy prostokąt i cienkie podpory są trudne do nazwania | Pokazać materialny związek remontu z obejściem, bez dodatkowej przeszkody |
| 03 | Wiata i wagon czytelne; scena bardzo pusta, ale tutaj pustka pasuje do nocnego czekania | Utrzymać prostotę; zwykły ślad używania ławki i światło z drzwi wystarczą |
| 04 | Rytm okien i siedzeń działa; napis „MARTA // CZEKA W DOMU” jest plakatem autora nad wagonem | Przenieść wiadomość do istniejącego urządzenia; pomnik i odwrócenie czytnika niech przerwą rytm |
| 05 | Fasada to równy rząd ciemnych okien, trzy punkty układają się jak ćwiczenie | Nadać ulicy jeden zapamiętywalny codzienny detal; ten sam detal wraca w 18 |
| 06 | Sprzedawca jest człowiekiem, ale jego całe nogi widać przed pełną dolną ścianą kiosku; mało towaru | Jasno wybrać, czy obsługuje z wnętrza, czy zamyka kiosk na zewnątrz; poprawić zasłanianie i rękę z zakupem |
| 07 | Fasada i domofon są czytelne; trzy podpisy dominują nad samym wejściem | Domofon i tablica lokatorów jako dwa realne źródła, wspólny materiał elewacji, mniej haseł nad sceną |
| 08 | Sąsiadka stoi na małym symetrycznym podeście; szerokie puste pole nie przypomina ciasnej klatki | Poręcz, lokalne światło i widoczny cel jej zwykłej czynności, bez zmiany wysokości stopni |
| 09 | Najbardziej przekonujące używane wnętrze; fotografia ma mało czytelnego szczegółu, a napis „DWA NAKRYCIA // JEDEN POWRÓT” wyjaśnia metaforę | Traktować 09 jako bazę domu; dopracować zdjęcie w istniejącej interakcji, usunąć komentarz z dekoracji |
| 10 | Marta jasna i odrębna, ale stoi jak wklejona przed półką; Lena i Marta mają różnie odczuwane plany podparcia | Związać pozę Marty z kubkiem/blatem i kierunkiem rozmowy; nie zwiększać liczby ozdób |
| 11 | Mocna jasna instytucja, ale Wierzbicka wygląda jak mała figurka posadzona na ladzie przed szybą | Ustawić krzesło, biodra, blat i maskowanie nóg jako jedną relację przestrzenną; nie powiększać samej głowy |
| 12 | Szpule identyfikują urządzenie; Jakub ma pozę pracy, lecz dłonie i imadło nie tworzą przekonującego kontaktu | Dopracować styk ręka–narzędzie i moment przerwania pracy; ograniczyć konkurencję wielkiego rejestratora w chwili spotkania |
| 13 | Stół, trzy prostokąty, dwa koła lamp i dwie nisze: najbardziej schematyczny domowy kadr | Przenieść rozpoznawalny układ 09/10, rozłożyć konkretne źródła asymetrycznie; oświetlić dłonie i twarze w chwili syntezy |
| 14 | Jedna duża maszyna działa jako dominanta, ale obejma wygląda jak zawieszony element planszy | Dorysować funkcjonalne połączenie obwodu, nie nowy pomost do skakania |
| 15 | Dwa odbieracze i odwrócone światło są dobrym lokalnym zaburzeniem; urządzenia nadal diagramatyczne | Uczytelnić trzy próby i pojedynczą korektę; nie dokładać drugiej anomalii |
| 16 | Duża pusta obudowa z lewej, po prawej kolejne małe panele; echo domu wygląda jak sygnał aparatu | Odbiornik pokazuje konkretny domowy przedmiot/wiadomość, a nie kolejny pulsujący okrąg |
| 17 | Prawie pusta ciemna hala i trzy równe stanowiska; „oś w głąb” jest słabsza niż w 11 | Reużyć wiarygodną geometrię wizualną instytucji z 11; rejestr fizycznie ciągnie się poza odczytywaną kartą, ukazując skalę procedury |
| 18 | Fasada 05 wraca, ale przed nią stoją trzy abstrakcyjne urządzenia z nazwami funkcji | Zachować rozpoznanie ulicy; podpiąć aparaturę do infrastruktury i kontakt Marty do konkretnego kanału, nie budować ołtarza wyboru |
| 42A | Trzy różne obramowania i stół nie przywołują dostatecznie salonu 09/10; pusty stołek jest za słaby jako osoba nieobecna | Ten sam domowy motyw i przerwana czynność domowej Marty; koszt potwierdzony brakiem znanej odpowiedzi |
| 42B | Marta przy progu jest czytelna, lecz miejscowa Lena to matowa masa; obietnica odzyskania ciała nie ma mocnego obrazu ciała | Lokalny gest miejscowej Leny na bazie istniejącej tożsamości; wyraźna zmiana perspektywy przybyłej po odejściu |
| 42C | Niemal ten sam kadr co B z dwoma znakami w szybie; zmiana jest przede wszystkim oznaczeniem systemu | Konkretny przeciek pamięci i dwie różne relacje z Martą; nie różnicować finału „lepszym” kolorem |
| 43 | Duże tablice „LICENCJE // MANIFEST RUNTIME”, PNG, rozdzielczość i InputMap dominują nad świtem | Credits zachować i udostępnić przy istniejącym punkcie, lecz odsłonić finałową przestrzeń dla ostatniego działania |

### 6.3 DEF-2 i DEF-3 — co naprawdę zostało

**DEF-2, portret Marty:** na `panel_portrait__marta.png` widzę własną twarz, długie brązowe włosy i kremowy strój. Nie powtarzam dawnego zarzutu „Lena przemalowana na Martę”. Problemem jest stały szeroki uśmiech widoczny także w demonstracyjnym `panel_dialogue__marta_then_lena.png` przy „Nie jesteś jej zastępstwem”. Ten kadr jest aranżacją narzędzia, ale dobrze ujawnia ograniczenie pojedynczej ekspresji. Zalecam neutralną/wycofaną wersję tej samej twarzy do scen granicy; nie nową tożsamość i nie kolejną globalną regenerację obsady.

**DEF-3, rigi:** oglądane osoby nie są już kółkami i trapezami. Nadal tymczasowo wygląda ich inscenizacja: sprzedawca niejednoznacznie względem ściany kiosku, Wierzbicka względem lady, Marta względem stołu, Jakub względem imadła. Kod riga potwierdza, że stan `work` jest pojedynczą pozą; istnienie siedmiu nazw stanów nie stanowi gry aktorskiej. Najpierw wykorzystać istniejące pozy i poprawić kontakt/przesłanianie. Nowe klatki tylko tam, gdzie konkretnego gestu nie da się złożyć z obecnych.

**DEF-9 w finale:** matowa szyba jest uzasadnionym wyjątkiem plastycznym, ale dla mnie nie wystarcza jako cała wypłata poszukiwania miejscowej Leny. Można zachować szybę jako etap, a potem pokazać rozpoznawalną osobę w tym samym istniejącym adresie. To rekomendacja dramatyzacji, nie podważanie technicznego zakazu piktogramów.

### 6.4 Nowsze winiety PKG-0190

106 kadrów pochodzi sprzed winiet, dlatego sama ich ocena nie opisywałaby całego dzisiejszego obrazu. Wszystkie 14 plansz obejrzano osobno. Czytelniejsze zbliżenie dłoni i twarzy to korzyść. W mojej ocenie kontrast medium pozostaje jednak duży: gładkie modelowane portrety w winietach, płaski świat z małymi sprite'ami, a w `vig_finale_a/frame_0` i `vig_finale_b/frame_0` dodatkowo ziarnisty, plakatowy rysunek. Kolejne ujęcia tej samej chwili bywają w różnych językach obrazu.

Największe zastrzeżenia: pogodna twarz w `vig_synthesis/frame_0` i `vig_finale_b/frame_1`; druga plansza C znów pokazuje bohaterkę przy kubkach i sylwetkę w oknie, zamiast konkretnego naruszenia pamięci. Podpis „Wybór jest jeden. Braki zostają nazwane” brzmi jak zapis kryterium akceptacji. Nie proponuję nowych slotów winiet. Korygować obecne pary, ekspresję i podpisy dopiero po napisaniu scen, które mają wzmacniać. Zachować wyzwalacze, jednorazowość, skip i reduced motion.

## 7. Siedem poprawek o największym zwrocie

Priorytet oznacza wagę twórczą. Kolejność techniczna pakietów w §8 uwzględnia też zależności. Ryzyko dotyczy naruszenia obecnych kontraktów, nie prawdopodobieństwa emocji odbiorcy.

| Priorytet | Poprawka i granica | Oczekiwany zwrot — hipoteza | Ryzyko techniczne / ochrona |
|---|---|---|---|
| P0 / 1 | **Odzyskać sceny Marty, Jakuba i syntezy 09–13**: konkretne wspomnienia, odmowa, zwykły gest, nowe pytanie po rozpoznaniu | Największy: ustanawia ludzi, których dotyczą wszystkie późniejsze koszty | Średnie: kolejność CRT i faktów. Zachować identyfikatory trzech punktów, warunki źródeł, writerów i sygnał 13; kontrola 0160/0191/0192/0190 plus nowy test dostarczenia sceny |
| P0 / 2 | **Ujednolicić to, co scena mówi o bieżącym stanie**: nazwisko, budynek/lokal, próbka, guidance 09–13, zegar nocy | Wysoki przy małym nakładzie: przypadkowe błędy przestają udawać poszlaki | Niskie dla tekstu, średnie dla guidance. Bez globalnych podmian nazwisk i nowych writerów; warianty repeat/leave/minimalny, brak wcześniejszych ujawnień |
| P1 / 3 | **Pokazać treść drugiej tajemnicy 15–17**: zapis komendy, konkretny abort, jeden utracony detal, wiadomość domowej Marty, para Linii 4 | Wysoki: koszt zaczyna dotyczyć rozpoznawalnego życia | Średnie: zachować test trzech impulsów i dwie wartości kosztu; rozróżnić czytnik/bufor/próbkę i nie zakładać pełnej próbki po leave |
| P1 / 4 | **Przywrócić cudzą sprawczość w 17–18**: propozycja Wierzbickiej, prośba Leny, odpowiedź Jakuba, pełna/częściowa/wstrzymana prawda dla Marty | Wysoki: konflikt wartości zastępuje mechaniczne wybieranie zakresu | Średnie–wyższe: nie zmieniać routingów A/B/C ani nie przywracać blokad wyjścia; jawne konsekwencje także przy brakach. Równorzędne przedstawienie `limited` |
| P1 / 5 | **Rozróżnić emocjonalnie 42A/B/C i zakończyć 43 czynnością**; równocześnie zamknąć Szymona pozaekranowo | Wysoki: finał wypłaca motywy z początku i przestaje być spisem | Średnie: siedem podmiotów, trzy rodziny, stany częściowe i unseeded; nie dopisywać domowego żywego Jakuba ani nowego kosztu. Licencje pozostają dostępne |
| P2 / 6 | **Odchudzić komentarze 01–08 i powtarzane podpowiedzi**; szczególnie chronić ciszę 04–05 | Umiarkowany–wysoki: mniej recytacji bez utraty powolnego narastania | Niskie, jeśli najpierw zmienia się tekst i czas prezentacji, a zachowuje punkty i fakty. Nie traktować maksymalnie trzech interakcji jako nakazu trzech długich scen |
| P2 / 7 | **Wyreżyserować miejsca i obsadę**: dom 09/10/13/42, lada 11/17, warsztat 12, ulica 05/18; dopasować obecne winiety | Wysoki dla spójności, szerszy nakład niż poprawki tekstowe | Niskie–średnie przy zmianach prezentacji bez fizyki; aktualne Windows capture, dialog 85/100/115%, mono jako pomoc kompozycyjna, nie wynik odbioru |

### 7.1 Decyzje twórcze zamykające rozgałęzienia planu

- **CR-D02 — nie dodawać stacji.** Dwadzieścia adresów pozostaje docelową trasą. „Expansion” w nazwie dokumentu oznacza rozwinięcie scen w obecnych slotach.
- **CR-D03 — dramatyczne centrum 10 i 12, punkt zwrotny 13.** Nie przenosić diagnozy wcześniej, nie maskować brakującego spotkania kolejną winietą.
- **CR-D04 — adres: Sadowa 7, lokale 12 i 14.** To rekomendowane ujednolicenie materialnego problemu klucza/sąsiadki/dokumentów; rozkład pokazuje rozbieżność trasy, nie nową numerację mieszkania. Zachować znane dwa numery i nazwiska osób.
- **CR-D05 — celowy błąd jest czynnością, nie czwartym punktem.** Nadajnik 15 nadal jest jedną istotną interakcją z powtarzanymi próbami, o ile nie dokładamy odrębnej decyzji fabularnej ani nowego rekwizytu.
- **CR-D06 — żadna rodzina finału nie dostaje nowej kary dla równowagi.** C uwidacznia istniejący koszt przecieku; B zachowuje niepewność adresu; A zachowuje realną wartość domu i realną krzywdę drugiej Leny.
- **CR-D07 — autor nie komentuje poprawności moralnej w ustach Leny.** Usunąć kwestie o „nie nagrodzie”, „nie ocenie”, „fałszywym happy endzie” i „stanie podmiotów”. Pozostawić osobom prawo do gniewu, winy, niechęci i oceny własnych czynów. Brak punktacji moralnej nie wymaga emocjonalnej neutralności.

### 7.2 Próbki tonu — propozycje, nie gotowe nowe fakty

| Miejsce | Kierunek dialogu / działania | Co zachowuje |
|---|---|---|
| 10, drugi punkt | Marta odkłada mokrą ścierkę. „Kurtkę zostawiłaś na kaloryferze”. Lena: „Na parkingu. Oddałaś mi ją na parkingu”. Marta: „Potem wróciłyśmy tutaj”. | konkretną wyprawę o dwóch skutkach; brak diagnozy świata |
| 12, trzeci punkt | Lena: „Pokaż bliznę”. Jakub: „Nie”. Lena nie sięga do jego ubrania. Jakub odwraca czytnik: „Numer mogę sprawdzić”. | granicę ciała i dobrowolną kompetencję, bez przemowy o podmiotowości |
| 16, koszt pamięci | Marta: „Padało. Twoja kurtka była…” Urwana wypowiedź dotyczy szczegółu już ustanowionego w 10. Lena nie dopowiada odpowiedzi za nią. | dokładnie jeden dotychczasowy koszt; nie wymyśla utraty całej relacji |
| 17, limited | Jakub: „Sprawdzę wskazania. Nadajnika do mnie nie podłączysz”. | ograniczoną rolę technika; zakres do dopasowania do istniejącej semantyki `limited`, nie nową zgodę |
| 18, prawda | Lena pokazuje zapis miejscowej Leny. Marta: „Wiedziała czy zapytała?”. Po pełnym ujawnieniu: „Pomogę ją wyciągnąć. Potem odpowie mi sama”. | różnicę ratunku, aprobaty i przebaczenia |
| 42C | Domowa Marta: „Znam ten kubek”. Lena: „Nie masz go”. Obie patrzą na pustą półkę; brak końcowego objaśnienia Jakuba. | istniejący motyw konkretnego przecieku |

Nie mnożyć aforyzmów. Milczenie ma wynikać z gestu lub z braku odpowiedzi; nie dokładać obowiązkowych kilkusekundowych postojów po każdej linijce. Potencjalnie dłuższa rozmowa musi wykorzystać czas odzyskany z powtórzeń, nie stać się pretekstem do wydłużenia całej gry.

## 8. Kolejność wdrożenia — cztery mega-pakiety

**Rola następnej sesji:** Lead Programmer & Art Director. **Katalog:** `C:\getting_strange`. **Technologia:** Godot 4.7.x / GDScript, 640×360, fizyka 60 Hz. **Cel:** wykonać poniższe pionowe wycinki, nie uruchamiać samoczynnie równoległego planu refaktoru MRP z dotychczasowego NEXT_SESSION_PROMPT.

Numery rzeczywistych `PKG-NNNN` przydzielać dopiero przy otwieraniu pakietu po odczycie SESSION_LOG. `CR-A`…`CR-D` są identyfikatorami kolejności w tym planie, nie zajętymi numerami produkcyjnymi. Ekstrakcja MRP F-0184-010 pozostaje oddzielnym zadaniem; nie jest warunkiem poprawienia rozmów.

### CR-A — Dwie biografie i spotkanie z bratem

**Priorytety:** 1 + część 2 i 7. **Zakres:** cztery powiązane warstwy: treść 09–13; lokalne podpięcie dialogu; guidance i nośniki faktów; inscenizacja Marty/Jakuba oraz stołu.

1. Utworzyć mapę sceny 09–13: źródło → realny punkt → treść widoczna/słyszalna → zapis istniejącego faktu. Włączyć stacje 07–08 tylko w zakresie nazwiska i spójności lokalu. Nie uruchamiać dormant P7 jako skrótu do odzyskania scen.
2. Wdrożyć trzy punkty każdego adresu zgodnie z §4. Dla 10 centralna rozmowa niech zmieści się orientacyjnie w 8–12 krótkich wymianach rozłożonych między czynności; dla 12 podobnie. To budżet redakcyjny do cięcia, nie nowa bramka liczby zdań. Nie realizować piętnastu nowych mini-zadań pod osłoną trzech Area2D.
3. Użyć obecnego CRT i obecnych rigów przez małe lokalne moduły. Scena ma jednego właściciela kolejności otwarcie → czynność → rozmowa → odpowiedź/gest. Fakty i sygnały zachować w ich semantycznych akcjach. Samo wejście do sceny, podgląd lub nieudana akcja nie nadaje faktu. Nie dodawać zarządcy narracji do monolitu.
4. Przy 13 rozróżnić domowy czytnik/posiadany dokument od opcjonalnej surowej próbki. Nigdy nie pokazywać fizycznej próbki wyłącznie dlatego, że istnieje `recognition_evidence_carried`. Po syntezie dostarczyć pytanie Marty i nowy zamiar Leny; winieta ma wzmacniać tę samą chwilę. Dodać jawne zachowanie po pominięciu winiety, bez wymuszania ponownego oglądania.
5. Guidance 09–13 odpowiada wyłącznie aktualnym punktom. Pierwszą hipotezę kierować do źródła rozróżniającego, po odczycie ją zamknąć. Sprawdzić też teksty GapLedger: obecnie przypominają o piętrze, kluczu, fotografii i sekretarce pod starymi adresami. Nie zmieniać przy okazji fizyki donicy/komody/balkonu/szuflady.

**Pliki:** `scripts/levels/station_09.gd`…`station_13.gd`, odpowiadające `.tscn`; lokalne nowe dane/sterowniki rozmów; tylko potrzebne teksty 07/08 i `scripts/campaign/gap_ledger.gd`; prezentacja przez istniejące `scripts/ui/crt_dialogue_box.gd`, `scripts/characters/character_visual_rig.gd`, `scripts/cinematics/`. Kanon scen 09–13 w dokumentach narracyjnych i mapa wiedzy wymagają synchronizacji podczas wdrożenia.

**Kryterium wykonania:** w realnej ścieżce interakcji 10 dostarcza dwa sprzeczne wspomnienia, 12 dostarcza pytania/odpowiedzi i odmowę, 13 dostarcza wniosek i pytanie o drugą Lenę; każdy komunikat ma właściwego nadawcę i źródło wiedzy. Czy brzmi to dobrze — osobna opinia redaktora, z cytatem i uzasadnieniem. Nie zaliczać po samej obecności tablicy tekstów.

**Weryfikacja:** 0160, 0189, 0191, 0192, 0190; test kolejności rzeczywiście prezentowanych kwestii z użyciem punktów i InputMap, zachowania po ponownej interakcji, save/reload i skip. Porównać obraz 09/10/11/12/13 z niniejszym opisem; sprawdzić dialog w skali 85/100/115% i reduced motion. Pełny verifier po zamknięciu spójnej zmiany.

### CR-B — Odpowiedź, koszt i cudza zgoda

**Zależność:** CR-A, ponieważ detal pamięci Marty musi wcześniej istnieć. **Priorytety:** 3 + 4, lokalnie 7. **Zakres:** cztery warstwy: śledztwo 14–16; konkret kosztu/echo domu; opozycja 17; decyzja 18.

1. Zachować mechaniczne zachowania 14 i sygnałową próbę 15. Nadajnik daje świadome przygotowanie błędnego trzeciego wzoru w tym samym punkcie, bez zręcznościowego okna czasowego. Log ma odróżnić intencję miejscowej Leny od późniejszej interwencji UCP; notatka podaje rzeczywiste „brak odpowiedzi = przerwij” i brak uprzedniej zgody drugiej strony.
2. W 16 najpierw przedstawić alternatywy kosztu, potem jedną wybrać i odczytać konkretny skutek. Nie nazywać procedury bezpieczną dla pamięci tylko dlatego, że aparatura pracuje w trybie ochronnym. Zachować obie wartości kosztu i nie rozszerzać ubytku na całą relację. Odbiornik domu ma dostarczyć wiadomość z domowej ciągłości i przesłankę przeciw prostemu swapowi.
3. W 17 trzy dotychczasowe interakcje stają się trzema aktami: karta pary Linii 4 z datą i dwiema stronami; Wierzbicka z kuszącym argumentem za adaptacją; Jakub z prawem do zakresu. Przywołać jego codzienny cel z 12. Nie utożsamiać korelacji katastrof z dowodem, że Wierzbicka osobiście „zabiła Jakuba”.
4. W 17–18 pozycja Leny może nadal wybierać wariant w istniejącym punkcie, ale przed zatwierdzeniem musi wyświetlać konkretną **prośbę/czynność Leny**, a po nim wypowiedź i granicę drugiej osoby. Nie przedstawiać ruchu protagonistki jako sterowania wolą Jakuba. `limited` dostaje własną kwestię i widoczny zakres. W 18 „pełna prawda” pokazuje ryzyko i brak zgody w teście, „częściowa” nazwany pominięty fragment, „wstrzymana” odmowę ujawnienia — nie trzy abstrakcyjne etykiety.
5. Prognozy metod mają pokazać: chronioną osobę/wartość, znaną stratę, nieznany skutek i bieżące braki. Zachować obecny wybór 18→42 oraz przechodniość przy brakach; nie proponować naprawy etyki przez zamknięcie wyjść. Odmowa nie może po cichu stać się zgodą w opisie. Minimalny przebieg ma pokazywać nieustalone fakty jako nieustalone.

**Pliki:** stacje/sceny 14–18; lokalne dane rozmów i odczytów; potrzebne powierzchnie instrumentów; `cinematic_catalog.gd` tylko w zakresie podpisu zatwierdzenia i koordynacji; związane fragmenty kanonu i mapy wiedzy. Bez nowych autoloadów, nowych typów MRP i zmian fizycznej topologii.

**Kryterium wykonania:** można wskazać konkretny detal przed utratą i po niej; osobno treść pytania do Jakuba i jego odpowiedzi; osobno treść ujawnienia Marcie i jej granicy. Rejestr pokazuje dwa powiązane zdarzenia, nie hasło o kosztach. Wszystkie trzy zakresy i stany prawdy mają pełnoprawną prezentację, również bez pozytywnej odpowiedzi.

**Weryfikacja:** 0162–0166, 0175, 0177, 0190. Próba kosztu dla repeat i leave; trzy zakresy, trzy stany prawdy, pominięte źródła, powrót, reload przed i po zatwierdzeniu. Nie dowodzić etycznej wiarygodności testem porównującym string `granted`.

### CR-C — Trzy różne poranki i zamknięcie Szymona

**Zależność:** CR-B; zebrane wcześniej konkrety muszą zostać wypłacone. **Priorytety:** 5 + odpowiednia część 7. **Zakres:** cztery warstwy: finałowe sceny działań; nośniki stanów osób; obraz/istniejące winiety; epilog i credits.

1. Przepisać obecne trzy punkty 42A/B/C zgodnie z §4 i poniższą matrycą. Wprowadzić źródło i ciągłość każdego głosu. Wyraźnie oddzielić wykonanie metody od odczytu skutku, bez dodawania następnej konsoli i bez ponownego potwierdzania identycznego wyboru.
2. Pokazać miejscową Lenę jako rozpoznawalną osobę tam, gdzie wraca. W B oddzielić perspektywę przybyłej od sceny Marty w Równi; można wykorzystać wewnątrz obecnego adresu kadr znanej wiaty jako miejsce bez indeksu. To prezentacja wariantu, nie nowa scena kampanii ani nowa rodzina lokacji. Utrzymać sygnały dotychczasowych akcji i próg do 43.
3. W 43 zszyć wszystkie osobiste konsekwencje z trzech istniejących punktów. Napisy i licencje nadal są dostępne oraz zgodne ze stanem assetów; ich duże tablice nie muszą dominować od wejścia. Przed otwarciem creditsów scena ma zakończyć własne zdarzenie. Nie wymuszać przeczytania pełnych licencji jako emocjonalnej kulminacji.
4. Wdrożyć CR-D01: zapisać formalną decyzję pozaekranowego Szymona, zamknąć dług w CURRENT_STATE/CAST bible, zastąpić osieroconą kwestię 43B. Nie usuwać starych decyzji, portretu ani scen dawcy.
5. Skorygować istniejące plansze finałowe i ekspresje dopiero według ukończonych scen. Nie zwiększać liczby winiet; nie przerabiać C w dodatkową katastrofę, A w prostą karę, a B w samobójczy obowiązek.

**Matryca docelowych nośników w obrębie 42X/43 — plan, nie obecny stan:**

| Podmiot | A — powrót wymuszony | B — zamknięcie | C — wzajemne przejście |
|---|---|---|---|
| Lena przybyła | kładzie czytnik we własnym domu zamiast odpowiedzieć na pytanie | urządzenie bez indeksu domu przy znanej wiacie | wraca, dostrzega obcy szczegół we własnym domu |
| Lena miejscowa | brak wcześniej ustanowionej odpowiedzi; zamknięty kanał | rozpoznawalny gest w odzyskanym progu | własna odpowiedź i powrót po drugiej stronie |
| Marta domowa | pyta o zniknięcie, ulga nie usuwa gniewu | nadal próbuje skontaktować się z przyjaciółką; komunikat z jej strony | rozpoznaje detal intymności, której nie przeżyła |
| Marta Równi | nie kończy poszukiwania partnerki; wiadomość lub pozostawiony apel z określonego źródła | pyta miejscową Lenę, co wiedziała przed testem | odzyskuje partnerkę, zachowuje pytanie o odpowiedzialność |
| Jakub | lokalna wypowiedź/zapis potwierdza, że żyje i zna cenę; żadnego nowego głosu zza zamkniętego mostu | wraca do własnej pracy w udzielonym zakresie | epizod obcej pamięci śmierci przerywa zwykłą czynność |
| Wierzbicka/UCP | raport wygładza incydent, pozostaje kontrola | zapis potwierdza zamknięcie eksportu kosztów z tego węzła, nie upadek całej instytucji | dwa dostępne zapisy odbierają UCP wyłączność na opis |
| Relacja światów | kanał zamknięty przemocą | przepływ zamknięty, adres przybyłej nieznany | dalszy wspólny ubytek czasu po rozdzieleniu |

Nie potrzeba siedmiu paneli. Stan można dostarczyć przez krótką sekwencję już uruchomionego odczytu, czynność w kadrze i określony zapis z drugiej strony. Ważne, by nie pojawiały się nieustanowione nowe kanały łączności po zamknięciu mostu; informacje z odciętej strony wymagają jawnego cięcia perspektywy albo wcześniejszego zapisu, nie wszechwiedzy Leny.

**Pliki:** `station_42a.gd`, `station_42b.gd`, `station_42c.gd`, `station_43.gd` i sceny; obecne plansze `assets/cinematics/vig_finale_*`; lokalna prezentacja aktorów; CAST bible i DIALOGUE/FULL_STORY/CONTINUITY; dokumenty wymagane WORKFLOW przy zamknięciu.

**Weryfikacja:** 0167–0170, 0153 dla credits/licencji, 0175, 0186/0187, 0190; wszystkie trzy rodziny, stany pełne/częściowe i unseeded. Test ma przejść realny start i zamykanie kolejki CRT, a nie tylko wywoływać `advance_dialogue()` na tablicy. Zrzuty każdego istotnego skutku, nie tylko pustej sceny po `_ready()`.

### CR-D — Rytm początku i spójność całego obrazu

**Zależność:** CR-A/B/C dla ustalonych motywów i wypłat. **Priorytety:** 6 + reszta 2/7. **Zakres:** trzy warstwy: rytm 01–08; plastyka rodzin i powrotów; ciągła kontrola narracji po montażu.

1. Usunąć redundantne komunikaty, nie źródła. Zachować kolejność cold open → pierwszy pomiar → wybór próbka/obietnica. Rozdzielić koszt świadomej powtórki od niezawinionego obejścia. Zapewnić zwykłą ciszę 04/05 bez dodatkowego zadania lub sztucznego oczekiwania.
2. Uzgodnić w kanonie i nośnikach **przyczynę przejścia po `leave_on_time`**: rekomendowane ustanowienie kontaktu przy pierwszym obowiązkowym odczycie z warstwy B; opcjonalna powtórka decyduje o zachowaniu pełnej próbki i opóźnieniu. To jawna korekta opisu przyczynowości do istniejących dwóch dróg, nie nowe zdarzenie. W 15 log odnosi się do tego samego odczytu; w 16 nośnik pozbawiony próbki nie może być opisywany jako pełna próbka. Nie nadawać brakujących flag jako sposobu „naprawy historii”.
3. Dopracować scenografię według §6: rzeczy osadzone w użyciu, mniej konkurujących ramek, jeden codzienny motyw ulicy w 05/18 i jeden układ domu w 09/10/13/42. Rytm okien nie jest jedyną tożsamością miejsca. Pracować nad lokalnym kontrastem, podparciem i przesłanianiem, nie dodawać globalnego szumu ani nowych efektów anomalii.
4. Przejść tekstowo i automatyczną trasą obie decyzje otwarcia oraz świadome pomijanie informacji. Rejestrować osobno fakty podane i fakty nieustalone. Historia nie może udawać, że Lena przeprowadziła wszystkie rozmowy tylko dlatego, że wolno jej dojść do 43.

**Pliki:** stacje/sceny 01–08; wyłącznie potrzebne lokalne warstwy prezentacji z §6; ewentualne podpisy już istniejących winiet progu/syntezy/sygnału; mapy wiedzy, zegara i konsekwencji. Ujednolicenie przyczyny leave uzgodnić już przy otwieraniu CR-B, zanim napisze się log 15; CR-D sprawdza i domyka całą trasę.

**Weryfikacja:** 0091/0094, 0157–0159, 0175–0177, 0186/0187, 0190; ciągły przebieg od „Nowa gra”, trzy finały w osobnych przebiegach, próby z brakami. Pełne testy i świeże obrazy zamykają technikę; redaktor osobno opisuje, gdzie nadal czuje procedurę.

### 8.1 Wspólny kontrakt każdego pakietu wykonawczego

| Obszar | Musi zostać zachowany / wykonany |
|---|---|
| Trasa i fizyka | 20 adresów, istniejące progi i kierunki, InputMap, 60 Hz, 640×360. Nie dodawać colliderów w tych pakietach. Jeśli następna implementacja uzna zmianę collidera za konieczną, najpierw obowiązuje pełna lektura TRAVERSAL_AND_OBSTACLE_DESIGN i osobne uzasadnienie świata; ten plan jej nie wymaga |
| Budżet | ≤3 istotne interakcje na adres; rozmowa ma zastępować istniejący odczyt. Nie ukrywać czwartej decyzji w nazwie podetapu; nie zwiększać całej trasy ani czasu jako celu |
| Fakty i zapis | zachować aktualne klucze, typy, rodzinę finału, negatywne warunki 13, brak automatycznego nadawania źródeł, save/reload i szybki restart. Dane o zgłębieniu sceny nie są dowodem przeczytania ani zrozumienia przez człowieka |
| Swobodny przebieg | wyjścia pozostają przechodnie zgodnie z D-192/GATE-FLOW. Nie wymuszać rozmowy przez zamknięcie progu; zapewnić prawdziwe komunikaty również po jej pominięciu. Prognoza z luką nie może udawać otrzymanej zgody |
| Prezentacja | ostre dialogi i napisy ponad pikselizacją; jeden właściciel kolejki sceny; brak jednoczesnych sprzecznych myśli/CRT/winiety; skip/reduced motion nie zmieniają znaczenia i zapisów |
| Architektura | nowe treści i zachowania w małych lokalnych komponentach; bez rozszerzenia monolitów MRP/VectorStageEnvironment, bez zmiany enum i serialize IDs |
| Testy | bieżące 96 bramek pozostaje GREEN po każdej spójnej poprawce; nowe testy dotyczą rzeczywistego dostarczenia treści, a nie zastępują istniejące testy flag. Pełne `verify.ps1` po każdym pakiecie i po każdej z jego niezależnie domykanych poprawek |
| Dowody obrazu | nowe PNG normalnym sterownikiem Windows, przez `tools/capture_preview.gd` lub lokalny harness właściwego pakietu; inspekcja w grze, z tekstem i bez, przed/po zdarzeniu. Nie nadpisywać `reports/pkg_0182/`…`pkg_0192*`. Raport opisuje kadry; wygenerowane reports pozostają wyjściem roboczym, nie źródłem prawdy |
| Zamknięcie | dopiero sesja wykonawcza aktualizuje CURRENT_STATE, SESSION_LOG, NEXT_SESSION_PROMPT, INDEX, decyzje, ryzyka i właściwe fragmenty kanonu; `verify_docs.ps1`, `verify.ps1`, `snapshot.ps1 -Package PKG-NNNN`; po snapshotcie nie edytować pakietu bez ponownej weryfikacji i świadomego odświeżenia zamknięcia |

**Dwa miejsca szczególnego ryzyka w istniejących testach:**

1. `tests/pkg_0191_canonical_fact_test.gd` sprawdza fakty po rzeczywistych triggerach MRP, ale nie wymaga wypowiedzenia rozmowy. Zachować te asercje i dodać kontrolę dostarczenia treści. Jeśli scena wymaga innego czasu ukończenia dialogu, jawnie zsynchronizować harness z zakończeniem sceny; nie sprowadzać oczekiwań do samej obecności pliku.
2. `tests/pkg_0165_smoke_test.gd:231–234` zabrania niektórych pojęć w całym `station_17.gd`, choć w mapie P9 rozpoznanie następuje w 13. `pkg_0170` sprawdza również konkretne frazy i indeksy linii epilogu. Przed zmianą takich treści nazwać konflikt starej asercji z aktywnym kontraktem i określić równoważne lub silniejsze sprawdzenie. **Nie usuwać linta, nie obniżać progów i nie wynosić tekstu do innego pliku wyłącznie po to, by ominąć test.** Kontrola wiedzy powinna obejmować rzeczywiście prezentowany tekst i stan przed/po rozpoznaniu; kontrola epilogu zachować te same podmioty, rodziny i sprawdzalne fakty. Zmianę kontraktu opisać jawnie w pakiecie, nie nazywać jej „kosmetyką testów”.

Nie obiecuję, że wszystkie zalecenia przejdą 96 bramek bez modyfikacji harnessów. Obiecany kierunek to zachowanie ich chronionych kontraktów, identyfikacja kolizji i pełne GREEN po każdej wdrożonej poprawce. W razie RED wykonawca diagnozuje przyczynę i naprawia własną zmianę; nie deklaruje ukończenia na podstawie tego planu.

## 9. Czego ten plan NIE dowodzi

- Nie dowodzi, że ktokolwiek odczuł niepokój, empatię, wzruszenie, przyjemność, nudę albo zrozumiał fabułę. To lektura i opinia jednego modelu znającego pełne rozwiązanie. Nie jest próbą odtworzenia reakcji nowej osoby.
- Nie dowodzi rzeczywistego czasu przejścia. „1/5/30 minut” to okna kontraktu; dawne godziny i wynik automatycznej trasy nie są czasem człowieka. Oceniłem rozkład zdarzeń i powtórzeń, nie zmierzone tempo lektury.
- Nie dowodzi komfortu sterowania, jakości dźwięku, naturalności animacji w ruchu ani wydajności obrazu po przyszłych zmianach. PNG są statyczne; asset winiety nie jest jej runtime capture'em. Nie odsłuchiwałem całości miksu.
- Nie dowodzi dostarczenia całej tablicy DIALOGUE_LINES w rozgrywce. Wskazane luki podpięć i wyścigi prezentacji trzeba odróżnić od literackiej jakości zapisanej kwestii.
- Nie rozstrzyga wszystkich możliwych konsekwencji ciągłości ani nie ustanawia nowej kosmologii. Propozycje zdań i gestów nie są zatwierdzonym kanonem.
- Nie zamyka hipotez odbiorczych. Najbliższe temu planowi są H-003/H-006/H-008/H-009/H-010/H-011/H-014/H-015/H-016/H-029, H-038–H-043, H-045/H-048/H-053; ich wymiar odbiorczy pozostaje otwarty albo ACCEPTED-RISK. Nie ustawiać `SUPPORTED` po wdrożeniu.
- Nie jest audytem naprawiającym całą ewidencję hipotez. W odczytanym RISKS są powtórzone H-028, brak osobnego H-030 i odniesienia do starej topologii; wstęp nadal mówi o odłożeniu testerów. Nie interpretować tych starszych zapisów jako zmiany obowiązującej w tej sesji zasady **zero zewnętrznych testerów, nigdy**.
- Nie jest PRODUCT GO, decyzją wydawniczą ani poleceniem budowy `.exe`. GATE-REL pozostaje zablokowane przez D-168. Nie proponuje strony, webu, PWA, dodatkowych adresów, platformingu, Gita, commitów, gałęzi ani PR-ów.

Brak dowodu odbioru nie wymaga zawieszenia pracy. Uzasadnieniem wykonania są wskazane sprzeczności, niedostarczone sceny i jawny wybór rzemieślniczy. Po zmianach wolno powiedzieć „kwestia ma nadawcę, koszt ma konkretny nośnik, kolejność działa”; nie wolno powiedzieć „test potwierdził, że scena wzrusza”.

## 10. Stan weryfikacji tej sesji i przejęcie

| Kontrola tej sesji | Wynik | Granica |
|---|---|---|
| `pwsh -NoProfile -File .\tools\verify.ps1` | **PASS, exit 0, `Verification passed.`**; cały istniejący łańcuch doszedł do końcowej bramki PKG-0192, w tym 0177, 0184, 0186/0187 i 0190/0191 | baseline aktualnego runtime, nie dowód poprawy gry przez ten plan. Proces rozpoczęto przed zapisem planu; kod/sceny/istniejąca dokumentacja nie były edytowane |
| `pwsh -NoProfile -File .\tools\verify_docs.ps1` po zapisaniu planu | **PASS, `DOCS PASS: 52 required files and handoff contracts`** | zgodność istniejącego kontraktu dokumentacji; nowy plan nie jest dodatkową bramką produktu |
| Inspekcja materiału wizualnego | **106/106 PNG PKG-0187 obejrzanych**, dodatkowo **14/14 plansz winiet PKG-0190** | ogląd statyczny, nie nowe rendery ani pomiar animacji |
| Kontrola zakresu wyniku | nowy plik planu; bez implementacji i bez aktualizacji NEXT_SESSION_PROMPT/SESSION_LOG | nie przydzielono PKG i nie wykonano snapshotu; to sesja planistyczna na wyraźne polecenie właściciela |

Verifier zgłaszał ostrzeżenia z negatywnych prób niepoprawnego zapisu, dopuszczone przez jego politykę fail-closed. Końcowy kod procesu wyniósł 0. Nie naprawiano testów ani ich progów. Żaden wynik tego przebiegu nie jest użyty jako argument za jakością literacką lub plastyczną.

**Przejęcie:** ten plik jest samodzielną specyfikacją dla kolejnej sesji wykonawczej. Rozpocząć od CR-A po sprawdzeniu aktualnego dysku i ostatniego numeru SESSION_LOG; pozostałe pakiety wykonywać w kolejności CR-B → CR-C → CR-D. Dotychczasowy `docs/NEXT_SESSION_PROMPT.md` pozostawiono bez zmian zgodnie z poleceniem właściciela. Plan nie oznacza wykonania żadnej z rekomendacji.
