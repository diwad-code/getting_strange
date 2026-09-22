# Ryzyka, hipotezy i przewidywania

Status: zywy rejestr walidacji

Nie zamieniamy intuicji w fakt przez zapisanie jej w dokumencie.

## Klasy dowodu

Wprowadzone przez `decisions/ADR-003-evidence-model-without-external-testers.md`
po potwierdzeniu, ze zewnetrzne czytania stolikowe i playtesty nie odbeda sie w
tym projekcie.

- `MIERZALNA` - da sie rozstrzygnac pomiarem, renderem, audytem tekstu albo
  testem automatycznym, bez udzialu nowej osoby;
- `ODBIORCZA` - da sie rozstrzygnac wylacznie reakcja czlowieka widzacego
  material pierwszy raz; w tym projekcie pozostanie nierozstrzygnieta;
- `KOSZTOWA` - da sie rozstrzygnac zmierzonym czasem wykonania albo modelem
  budzetowym opartym na danych zewnetrznych.

## Statusy

- `UNTESTED` - brak bezposredniego dowodu;
- `TECHNICAL` - dziala technicznie, ale nie potwierdzono doswiadczenia gracza;
- `MEASURED` - hipoteza MIERZALNA rozstrzygnieta pomiarem; wpis podaje metode,
  liczbe i date;
- `ACCEPTED-RISK` - hipoteza ODBIORCZA, na ktorej projekt swiadomie buduje mimo
  braku dowodu; wpis podaje skutek bledu i plan odwrotu;
- `OPEN-NO-EVIDENCE` - hipoteza ODBIORCZA, ktorej projekt jeszcze nie
  potrzebuje; nie blokuje pracy i nie wolno sie na nia powolywac;
- `SUPPORTED` - powtarzalny wynik z udzialem ludzi wspiera hipoteze;
- `REFUTED` - dowod przeczy hipotezie;
- `RETIRED` - pytanie przestalo miec znaczenie po zmianie kierunku.

**Zakaz nadrzedny:** `SUPPORTED` wymaga powtarzalnego wyniku z udzialem ludzi.
Ocena modelu, autora ani test automatyczny nie moga ustawic tego statusu. Brak
testerow nie jest licencja na optymizm; jest powodem do zapisania braku.

## Rejestr hipotez

| ID | Hipoteza | Klasa | Status | Dowod lub metoda | Warunek decyzji |
|---|---|---|---|---|---|
| H-001 | Filmowy ciezar ruchu da sie pogodzic z responsywnoscia | ODBIORCZA | OPEN-NO-EVIDENCE | harness A/B/C gotowy; slepy test nie odbedzie sie | wybor profilu przez wlasciciela zmienia status na ACCEPTED-RISK z zapisanym powodem |
| H-002a | Zakotwiczenie i Uleglosc maja dosc roznych zastosowan, by uniesc cala gre | MIERZALNA | **REFUTED (2026-08-15, PKG-0009)** | Audyt wszystkich 43 przestrzeni w `FULL_STORY.md`: 5 odrebnych przestrzeni (14, 20, 22, 33, 41) spelnia rygor jawnej czynnosci, skutku/kosztu i odrebnosci; prog wynosi 12. Pelna tabela i metoda: `docs/narrative/MECHANICS_AUDIT_H-002A.md` | przed Prototype 02 potrzebna remediacja do progu albo jawna decyzja o zmianie kontraktu; obecny tekst nie przechodzi bramki |
| H-002b | Gracz przewiduje skutek Zakotwiczenia bez instrukcji | ODBIORCZA | OPEN-NO-EVIDENCE | Prototype 02, trzy pokoje | nie blokuje pracy narracyjnej |
| H-003 | Gracz odczyta "swiat jest niepoprawny" glownie z akcji | ODBIORCZA | ACCEPTED-RISK | brak. Skutek bledu: upada antyfilar "brak dziennikow wyjasniajacych". Odwrot tani: diegetyczne instrukcje "higieny ciaglosci" sa juz w kanonie (scena 14) i mozna je rozproszyc | odwrot nie wymaga zmiany mechaniki ani fabuly |
| H-004 | Rzadkie zagrozenia utrzymaja napiecie przez 2-3 godziny | ODBIORCZA | OPEN-NO-EVIDENCE | brak. Zalezy od nierozstrzygnietej kwestii, czy gra ma stan przegranej | zablokowana do decyzji o fail-state |
| H-005 | Rotoskopowy pixel art jest wykonalny w zakladanym zakresie | KOSZTOWA | UNTESTED | spike jednej finalnej sekwencji plus model budzetowy z danych zewnetrznych | zmierzony koszt kadru i animacji miesci sie w budzecie; **rozstrzygalne bez testerow** |
| H-006 | Uleglosc bedzie kuszaca, a nie odbierana jak "zla opcja" | ODBIORCZA | ACCEPTED-RISK | brak. Skutek bledu: jeden z dwoch filarow mechaniki martwy; gracze wybieraja tylko Zakotwiczenie. Odwrot sredni: przeprojektowanie korzysci Uleglosci bez zmiany fabuly | koszt odwrotu rosnie po zaprojektowaniu pokoi |
| H-007 | Brak stalego HUD-u nie pogorszy czytelnosci stanu | ODBIORCZA | ACCEPTED-RISK | brak. Skutek bledu: gracz nie wie, co jest zakotwiczone. Odwrot tani: minimalny HUD dostepnosci czynnosci jest przewidziany w `VISUAL_DESIGN.md` 6.3 | odwrot mozliwy do konca produkcji |
| H-008 | Marta i Jakub utrzymaja emocjonalny rdzen 2-3 godzin bez sprowadzenia ich do nagrod i dowodow | ODBIORCZA | ACCEPTED-RISK | brak. **Najdrozsze przyjete ryzyko projektu.** Skutek bledu: rdzen emocjonalny nie dziala i zaden final nie ma wagi. Odwrot bardzo drogi: dotyka calej struktury relacyjnej | zabezpieczenie zastepcze: audyt strukturalny obecnosci, sprawczosci i granic obu postaci scena po scenie |
| H-009a | Tekst dostarcza porownywalnej liczby dowodow na skutecznosc i na krzywde UCP | MIERZALNA | UNTESTED | audyt `FULL_STORY`: policzenie scen dowodzacych kazdej strony i ich rozlozenia w aktach | rownowaga i brak zageszczenia jednej strony w jednym akcie |
| H-009b | UCP bedzie odbierane jednoczesnie jako skuteczne i krzywdzace | ODBIORCZA | ACCEPTED-RISK | brak. Skutek bledu: dominuje odczyt "czysty zloczynca" albo "brak problemu", co unieważnia trzeci final. Odwrot sredni | zalezy od H-009a jako jedynego dostepnego przyblizenia |
| H-010a | Zwrot o skorygowanej galezi Leny ma co najmniej trzy zapowiedzi obecne w tekscie, na sciezce obowiazkowej i z niewinnym odczytem podanym w scenie | MIERZALNA | **MEASURED (2026-08-15, PKG-0008)** | Ponowna metoda: kazda kandydatka sprawdzona na cztery warunki - (a) obecna jako tekst w `FULL_STORY.md`, (b) na sciezce obowiazkowej, nie za opcjonalnymi ogledzinami, (c) scena sama podaje odczyt niewinny, (d) dotyczy galezi Leny, nie systemu w ogole. Wynik: **trzy** spelniaja wszystkie cztery - scena 01 (pusta prawa trzecia kadru fotografii), scena 14 (cisza w trzeciej sekundzie nagrania), scena 22 (twarzy pielegniarki nie pamietala juz przedtem). Dwie dalsze spelniaja a-c, ale nie d, i licza sie jako wsparcie: scena 02 (`WYNIK ZGODNY`), scena 10 („Ktorego?"). Scena 18 usunieta z lancucha - dowodzi wiedzy systemu, nie korekty jej galezi | **Granica pomiaru:** warunek (b) jest proxy dla „dostrzegalne", a nie dowodem, ze ktokolwiek zauwazy. Faktyczne zauwazenie to H-010b i pozostaje OPEN-NO-EVIDENCE. Ponowny pomiar uwzglednil przenumerowanie i scalenie scen w N0.2-C |
| H-010b | Zwrot jest zaskakujacy dla odbiorcy | ODBIORCZA | OPEN-NO-EVIDENCE | brak | - |
| H-011a | Trzy finaly sa symetrycznie zbudowane: zaden nie ma wiecej strukturalnych sygnalow uprzywilejowania niz pozostale | MIERZALNA | **MEASURED (2026-08-15, PKG-0008)** | Ponowny audyt struktury po N0.2-C policzyl cztery sygnaly porownawcze: dostepnosc, domkniecie relacji Jakub–Wierzbicka, tryb wymiany argumentow w D-14 oraz rejestr epilogu. Wynik: **0 sygnalow przewagi strukturalnej** dla A, B i C. Swiadectwo jest zawsze dostepne, A i B maja dwureplikowe domkniecia z Wierzbicka, D-14 konczy sie cisza po pytaniu, a trzy epilogi sa administracyjne. Wlasna regula palety z `VISUAL_DESIGN.md` 3 pozostaje swiadomie wyjeta z licznika jako sygnal wizualny, nie strukturalna nagroda. Koszt rozproszenia Sladu jest kosztem fabularnym, nie przewaga | **Granica pomiaru:** audyt liczy kontrakty tekstowe, nie odbior. H-011b pozostaje bez dowodu odbiorczego |
| H-011b | Kazdy final ma obroncow i poprawnie rozpoznany koszt | ODBIORCZA | ACCEPTED-RISK | brak. Skutek bledu: gra deklaruje trzy odpowiedzi i dostarcza jedna wlasciwa. Odwrot sredni przed produkcja, bardzo drogi po | H-011a jest jedynym dostepnym przyblizeniem i musi byc utrzymana na zero |
| H-012 | Materialna, nieglitchowa korekta jest czytelna w 640x360 | MIERZALNA | UNTESTED | render przez `tools/capture_preview.gd`, pomiar wielkosci elementu w pikselach, kontrast, zachowanie przy skalowaniu calkowitym 1x-4x, symulacja deuteranopii i protanopii | protagonista, regula i swiadek rozpoznawalne bez HUD; **rozstrzygalne bez testerow** |

### Podsumowanie klas

- MIERZALNE: H-002a, H-009a, H-010a, H-011a, H-012 - piec, z czego trzy
  rozstrzygniete: H-002a jako `REFUTED`, a H-010a i H-011a pozytywnie jako
  `MEASURED` po audytach PKG-0008 i PKG-0009;
- KOSZTOWE: H-005 - jedna;
- ODBIORCZE: H-001, H-002b, H-003, H-004, H-006, H-007, H-008, H-009b, H-010b,
  H-011b - dziesiec, trwale bez dowodu.

Pieciu z dziesieciu hipotez odbiorczych nadano `ACCEPTED-RISK`, bo projekt juz
na nich buduje. Pozostale pieciu nadano `OPEN-NO-EVIDENCE`, bo nie sa jeszcze
potrzebne i nie wolno sie na nie powolywac.

## Przewidywania projektowe

To sa prognozy, ktore pomagaja projektowac eksperymenty:

1. Profil ruchu preferowany przez testerow bedzie bardziej bezposredni niz
   historyczne cinematic platformers, ale wizualnie nadal moze wygladac ciezko.
2. Zakotwiczenie bedzie czytelne tylko przy malym zbiorze kandydatow i silnym
   stanie przed/po; podswietlenie wszystkiego zniszczy obserwacje.
3. Staly glitch szybko stanie sie niewidzialnym szumem i odbierze projektowi
   najwazniejszy kanal informacji.
4. Finalna animacja protagonisty bedzie glownym waskim gardlem, nie kod ruchu.
5. Zbyt dlugi normalny poczatek oslabia obietnice gry; mikroniezgodnosc musi
   pojawic sie szybko, nawet jesli bohater jej jeszcze nie rozumie.
6. Im bardziej niejednoznaczna metafizyka, tym bardziej jednoznaczne musza byc
   lokalne zasady zagadek.
7. Mechanika decyzji bez jawnego miernika zadziala tylko wtedy, gdy konsekwencje
   pojawiaja sie wystarczajaco szybko, by gracz polaczyl je z czynem.
8. Bez zewnetrznego odbiorcy najczestszym trybem porazki przestaje byc zla
   decyzja, a staje sie niezauwazona niespojnosc miedzy dokumentami. Audyt
   kontraktu jest wazniejszy niz kolejna iteracja pomyslu.

## Rejestr ryzyk

| ID | Ryzyko | Prawdopodobienstwo | Wplyw | Wczesna odpowiedz |
|---|---|---|---|---|
| R-001 | Zbyt duze podobienstwo do konkretnego otwarcia Another World | srednie | bardzo wysoki | granice inspiracji, przeglad IP przed ujawnieniem |
| R-002 | Animacja pochlania wiekszosc budzetu | wysokie | bardzo wysoki | spike jednej finalnej sekwencji przed produkcja; H-005 |
| R-003 | Tajemnica staje sie nieczytelnoscia | wysokie | wysoki | bez playtestow zostaje wylacznie audyt afordancji na papierze; ryzyko rosnie |
| R-004 | Zakotwiczenie i Uleglosc sa sztuczka kilku pokoi, a nie kontraktem na cala gre | **wysokie - zmaterializowalo sie w audycie H-002a** | bardzo wysoki | PKG-0009 policzyl 5/43 odrebnych przestrzeni przy progu 12. Przed Prototype 02 potrzebna jest remediacja scen albo jawna zmiana kontraktu; nie implementowac na podstawie obecnego wyniku |
| R-005 | Zakres rosnie przez nowe mechaniki i finaly | wysokie | bardzo wysoki | jedna mechanika sygnaturowa, nowa funkcja wymaga ciecia |
| R-006 | Ciezkie sterowanie powoduje niesprawiedliwe smierci | srednie | wysoki | profile A/B/C, restart ponizej 2 sekund; zalezy od decyzji o fail-state |
| R-007 | Horror opiera sie na efektach zamiast regulach | srednie | sredni | kazdy efekt musi miec znaczenie mechaniczne lub narracyjne |
| R-008 | Kryptonim koliduje z istniejacymi tytulami | srednie | sredni | clearance tytulu przed sklepem i marketingiem |
| R-009 | Dokumentacja wyprzedza kod i zaczyna klamac | **wysokie - zmaterializowalo sie** | wysoki | ujawnione 2026-08-15: bramki oparte na testerach, ktorzy nie istnieja, oraz tracker deklarujacy nieistniejace poszlaki. Odpowiedz: ADR-003, obowiazek etykiety, propozycja audytu kanonu w bramce |
| R-010 | Kolejna sesja poszerza zakres na podstawie starego promptu | srednie | wysoki | prompt wskazuje oczekiwany numer pakietu z `docs/SESSION_LOG.md`, wynik bramki i aktywna specyfikacje |
| R-011 | Pelna fabula zostanie potraktowana jak zatwierdzony zakres produkcyjny | wysokie | bardzo wysoki | rozdzielac kanon dramatyczny od hipotez mechanicznych i budzetu scen |
| R-012 | Trzeci final stanie sie oczywistym "golden ending" | **wysokie - zmaterializowalo sie, ograniczone audytem** | wysoki | H-011a w PKG-0008 zmierzylo zero sygnalow strukturalnej przewagi po D-015, domknieciach A/B, ciszy D-14 i rownym rejestrze epilogow. Odbior nadal pozostaje bez dowodu (H-011b) |
| R-013 | Zlozonosc metafizyki wyprze relacje | srednie | wysoki | kazde ujawnienie rozlicza relacje; wyciac wyklad bez zmiany dzialania |
| R-014 | Dokumenty fabularne rozjada sie po redakcji | **srednie - zmaterializowalo sie, ograniczone recenzja PKG-0008** | wysoki | w PKG-0008 zbudowano jedna tablice przenumerowania, zsynchronizowano cztery dokumenty scen i tracker, a bramka oraz recenzja tekstu pozostaja wymagane po kolejnych zmianach |
| R-015 | Brak dowodu odbiorczego jest trwaly, wiec zaden blad rozumienia gracza nie zostanie wykryty przed premiera | **pewne** | bardzo wysoki | ADR-003; dziesiec hipotez odbiorczych zapisanych jawnie; kazde twierdzenie o odbiorze nosi etykiete; priorytet dla tanich planow odwrotu przy H-003, H-006 i H-007 |
| R-016 | Ten sam autor jest jednoczesnie projektantem i recenzentem, wiec krytyka zewnetrzna znika z procesu | wysokie | wysoki | D-008 przestaje byc higiena kontekstu i staje sie zabezpieczeniem jakosci: audyt wykonuje sesja bez dostepu do rozmowy, ktora tworzyla material |
| R-017 | Brak wersjonowania: bledna edycja, nadpisany plik zrodlowy albo utrata katalogu sa nieodwracalne | wysokie, **czesciowo ograniczone** | bardzo wysoki | D-016 zniosl wersjonowanie swiadomie; D-017 przywraca minimum. Odpowiedzi: snapshot pakietu przez `tools/snapshot.ps1` (0,23 MB), natychmiastowy zapis, `SESSION_LOG.md` jako jedyna kronika, obowiazek przeczytania calego pliku przed zastapieniem, zakaz odtwarzania tresci z pamieci. **Nadal nierozwiazane:** utrata calego katalogu (snapshoty leza w nim), bledy wykryte pozniej niz po jednym pakiecie, brak wykrywania cudzych edycji i brak porownania dla assetow binarnych. Kopia poza dysk projektu pozostaje decyzja wlasciciela |

## Jak aktualizowac

Po eksperymencie dopisz:

- date i metode pomiaru albo liczbe nowych testerow;
- obserwowane zachowania i surowe pomiary;
- ograniczenia testu;
- zmiane statusu hipotezy;
- decyzje oraz jej wplyw na roadmape.

Nie zmieniaj `UNTESTED` ani `OPEN-NO-EVIDENCE` na `SUPPORTED` na podstawie
opinii tworcow, oceny modelu, testu automatycznego ani jednego zaprzyjaznionego
gracza. Hipoteze MIERZALNA wolno zamknac wylacznie statusem `MEASURED` albo
`REFUTED` i wylacznie z podana metoda.
