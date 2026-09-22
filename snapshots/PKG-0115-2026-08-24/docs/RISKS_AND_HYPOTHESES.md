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
| H-001 | Filmowy ciezar ruchu da sie pogodzic z responsywnoscia | ODBIORCZA | ACCEPTED-RISK | Profil A jest technicznym baseline całego aktualnego runtime i przechodzi deterministyczny smoke. Brak dowodu, że ruch jest przyjemny. Skutek błędu: sterowanie może być odbierane jako ospałe lub nerwowe. Odwrót: kalibracja zasobu profilu A i ponowne przejście pełnego smoke bez dodawania nowych czasowników | decyzja D-109 zamyka starą bramkę P1 produkcyjnie, ale nie ustanawia `SUPPORTED` |
| H-002a | Zakotwiczenie i Uleglosc maja dosc roznych zastosowan, by uniesc cala gre | MIERZALNA | **MEASURED (2026-08-19, PKG-0011)** | Audyt 43 przestrzeni w `FULL_STORY.md`: 5 odrebnych przestrzeni (14, 20, 22, 33, 41) spelnia rygor jawnej czynnosci, skutku/kosztu i odrebnosci. Próg po decyzji ADR-005 wynosi 5. Pelna tabela i metoda: `docs/narrative/MECHANICS_AUDIT_H-002A.md` | Otwiera Prototype 02 (Decyzja D-026) |
| H-002b | Gracz przewiduje skutek Zakotwiczenia bez instrukcji | ODBIORCZA | OPEN-NO-EVIDENCE | Prototype 02, trzy pokoje | nie blokuje pracy narracyjnej |
| H-003 | Gracz odczyta "swiat jest niepoprawny" glownie z akcji | ODBIORCZA | ACCEPTED-RISK | brak. Skutek bledu: upada antyfilar "brak dziennikow wyjasniajacych". Odwrot tani: diegetyczne instrukcje "higieny ciaglosci" sa juz w kanonie (scena 14) i mozna je rozproszyc | odwrot nie wymaga zmiany mechaniki ani fabuly |
| H-004 | Rzadkie zagrozenia utrzymaja napiecie przez 2-3 godziny | ODBIORCZA | OPEN-NO-EVIDENCE | brak. Zalezy od nierozstrzygnietej kwestii, czy gra ma stan przegranej | zablokowana do decyzji o fail-state |
| H-005 | Rówień Vector-Stage (własne płaszczyzny wielokątne i rytm poz) jest wykonalny w zakładanym zakresie | KOSZTOWA | TECHNICAL | PKG-0109 wykonał świeży pomiar 10 kadrów świata, dwa kadry świata z CRT, cykl proceduralny protagonistki oraz inventory 45 zasobów odpowiadających 43 przestrzeniom. PKG-0110 powtórzył pomiar w dwóch niezależnych procesach na tym samym Windows/OpenGL/Intel Iris Xe: wszystkie 9 wymaganych kadrów miało po 118 próbek, canvas items/primitives/draw calls powtórzyły się dokładnie, a cykl Station 02 miał po 218 próbek w każdym z 5 trybów. PKG-0111 prześledził provenance aktualnych dokumentów, decyzji, konfiguracji, harnessu i danych; nie znaleziono uprzedniego liczbowego budżetu z określonym zakresem i metodą spełnienia. Czasy, zwłaszcza p95 GPU, wykazały zmienność między procesami. Pełna metoda i tabela różnic są w `docs/VECTOR_STAGE_REPEATABILITY_AUDIT_H-005.md`, audyt provenance w `docs/VECTOR_STAGE_BUDGET_PROVENANCE_AUDIT_H-005.md`, dane w `reports/pkg_0110/` | ustanowić lub pozyskać wiarygodny, uprzedni budżet produkcyjny i porównać z nim bezpośredni koszt kadru/animacji; nie awansować statusu na podstawie samej powtarzalności ani konwersji 60 Hz; **rozstrzygalne bez testerów** |
| H-006 | Uleglosc bedzie kuszaca, a nie odbierana jak "zla opcja" | ODBIORCZA | ACCEPTED-RISK | brak. Skutek bledu: jeden z dwoch filarow mechaniki martwy; gracze wybieraja tylko Zakotwiczenie. Odwrot sredni: przeprojektowanie korzysci Uleglosci bez zmiany fabuly | koszt odwrotu rosnie po zaprojektowaniu pokoi |
| H-007 | Brak stalego HUD-u nie pogorszy czytelnosci stanu | ODBIORCZA | ACCEPTED-RISK | brak. Skutek bledu: gracz nie wie, co jest zakotwiczone. Odwrot tani: minimalny HUD dostepnosci czynnosci jest przewidziany w `VISUAL_DESIGN.md` 6.3 | odwrot mozliwy do konca produkcji |
| H-008 | Marta i Jakub utrzymaja emocjonalny rdzen 2-3 godzin bez sprowadzenia ich do nagrod i dowodow | ODBIORCZA | ACCEPTED-RISK | brak. **Najdrozsze przyjete ryzyko projektu.** Skutek bledu: rdzen emocjonalny nie dziala i zaden final nie ma wagi. Odwrot bardzo drogi: dotyka calej struktury relacyjnej | zabezpieczenie zastepcze: audyt strukturalny obecnosci, sprawczosci i granic obu postaci scena po scenie |
| H-009a | Tekst dostarcza porownywalnej liczby dowodow na skutecznosc i na krzywde UCP | MIERZALNA | UNTESTED | audyt `FULL_STORY`: policzenie scen dowodzacych kazdej strony i ich rozlozenia w aktach | rownowaga i brak zageszczenia jednej strony w jednym akcie |
| H-009b | UCP bedzie odbierane jednoczesnie jako skuteczne i krzywdzace | ODBIORCZA | ACCEPTED-RISK | brak. Skutek bledu: dominuje odczyt "czysty zloczynca" albo "brak problemu", co unieważnia trzeci final. Odwrot sredni | zalezy od H-009a jako jedynego dostepnego przyblizenia |
| H-010a | Zwrot o skorygowanej galezi Leny ma co najmniej trzy zapowiedzi obecne w tekscie, na sciezce obowiazkowej i z niewinnym odczytem podanym w scenie | MIERZALNA | **MEASURED (2026-08-15, PKG-0008)** | Ponowna metoda: kazda kandydatka sprawdzona na cztery warunki - (a) obecna jako tekst w `FULL_STORY.md`, (b) na sciezce obowiazkowej, nie za opcjonalnymi ogledzinami, (c) scena sama podaje odczyt niewinny, (d) dotyczy galezi Leny, nie systemu w ogole. Wynik: **trzy** spelniaja wszystkie cztery - scena 01 (pusta prawa trzecia kadru fotografii), scena 14 (cisza w trzeciej sekundzie nagrania), scena 22 (twarzy pielegniarki nie pamietala juz przedtem). Dwie dalsze spelniaja a-c, ale nie d, i licza sie jako wsparcie: scena 02 (`WYNIK ZGODNY`), scena 10 („Ktorego?"). Scena 18 usunieta z lancucha - dowodzi wiedzy systemu, nie korekty jej galezi | **Granica pomiaru:** warunek (b) jest proxy dla „dostrzegalne", a nie dowodem, ze ktokolwiek zauwazy. Faktyczne zauwazenie to H-010b i pozostaje OPEN-NO-EVIDENCE. Ponowny pomiar uwzglednil przenumerowanie i scalenie scen w N0.2-C |
| H-010b | Zwrot jest zaskakujacy dla odbiorcy | ODBIORCZA | OPEN-NO-EVIDENCE | brak | - |
| H-011a | Trzy finaly sa symetrycznie zbudowane: zaden nie ma wiecej strukturalnych sygnalow uprzywilejowania niz pozostale | MIERZALNA | **MEASURED (2026-08-15, PKG-0008)** | Ponowny audyt struktury po N0.2-C policzyl cztery sygnaly porownawcze: dostepnosc, domkniecie relacji Jakub–Wierzbicka, tryb wymiany argumentow w D-14 oraz rejestr epilogu. Wynik: **0 sygnalow przewagi strukturalnej** dla A, B i C. Swiadectwo jest zawsze dostepne, A i B maja dwureplikowe domkniecia z Wierzbicka, D-14 konczy sie cisza po pytaniu, a trzy epilogi sa administracyjne. Wlasna regula palety z `VISUAL_DESIGN.md` 3 pozostaje swiadomie wyjeta z licznika jako sygnal wizualny, nie strukturalna nagroda. Koszt rozproszenia Sladu jest kosztem fabularnym, nie przewaga | **Granica pomiaru:** audyt liczy kontrakty tekstowe, nie odbior. H-011b pozostaje bez dowodu odbiorczego |
| H-011b | Kazdy final ma obroncow i poprawnie rozpoznany koszt | ODBIORCZA | ACCEPTED-RISK | brak. Skutek bledu: gra deklaruje trzy odpowiedzi i dostarcza jedna wlasciwa. Odwrot sredni przed produkcja, bardzo drogi po | H-011a jest jedynym dostepnym przyblizeniem i musi byc utrzymana na zero |
| H-012 | Materialna, nieglitchowa korekta jest czytelna w 640x360 | MIERZALNA | UNTESTED | render przez `tools/capture_preview.gd`, pomiar wielkosci elementu w pikselach, kontrast, zachowanie przy skalowaniu calkowitym 1x-4x, symulacja deuteranopii i protanopii | PKG-0108 wykonał deterministyczny audyt 12 świeżych kadrów (9 świata, 3 UI), 63 pomiary rastera, 48 kontroli skal 1x–4x i 36 wariantów transformacji. PKG-0113 powtórzył ten sam zakres po remediacji wspólnego światła i CRT oraz zapisał 13 par before/after. Droga, granica planu, sylwetka i akcenty są mierzone, ale nadal brak jawnego progu liczbowego i dowodu odbiorczego, więc status pozostaje UNTESTED |

### Podsumowanie klas

- MIERZALNE: H-002a, H-009a, H-010a, H-011a, H-012 - piec, z czego trzy
  rozstrzygniete pozytywnie jako `MEASURED` po audytach PKG-0008, PKG-0009 i nowej decyzji PKG-0011;
- KOSZTOWE: H-005 - jedna;
- ODBIORCZE: H-001, H-002b, H-003, H-004, H-006, H-007, H-008, H-009b, H-010b,
  H-011b - dziesiec, trwale bez dowodu.

Sześciu z dziesieciu hipotez odbiorczych nadano `ACCEPTED-RISK`, bo projekt juz
na nich buduje. Pozostale cztery nadano `OPEN-NO-EVIDENCE`, bo nie sa jeszcze
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
| R-002 | Animacja pochlania wiekszosc budzetu | wysokie | bardzo wysoki | brak uprzedniego budzetu nadal jest jawna luka; PKG-0111 nie dopisal progu po fakcie. Kolejny dowod wymaga wiarygodnego zrodla kosztu i pomiaru; H-005 |
| R-003 | Tajemnica staje sie nieczytelnoscia | wysokie | wysoki | bez playtestow zostaje wylacznie audyt afordancji na papierze; ryzyko rosnie |
| R-004 | Zakotwiczenie i Uleglosc sa sztuczka kilku pokoi, a nie kontraktem na cala gre | **wysokie - zmaterializowalo sie w audycie H-002a, PIVOT w ADR-005** | bardzo wysoki | PKG-0009 policzyl 5/43 odrebnych przestrzeni. Decyzją D-026 (ADR-005) próg zmniejszono do 5, by odblokować prace w silniku i przetestować sam *game feel*. |
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
| R-018 | Sceny istnieją, ale produkt nie ma produkcyjnego wejścia ani pełnego ciągu do napisów | **technicznie zamknięte w PKG-0114; ryzyko wydawnicze pozostaje** | wysokie | `run/main_scene` wskazuje shell, a normalna trasa 01..41 → wybrany 42A/B/C → 43 → tytuł przechodzi gate realnych sygnałów. Nadal brak eksportów i testu czystej instalacji, więc nie jest to gotowość wydawnicza |
| R-019 | Zielony smoke deklaruje szerszy zakres niż rzeczywiście wywołuje | **ograniczone w PKG-0114** | średni | główny smoke wywołuje 01..41, 42A, 42B, 42C i 43, a `pkg_0114_smoke_test.gd` sprawdza dodatkowo normalny shell, trzy odrębne gałęzie i pojedyncze przejścia |
| R-020 | Wspólna oprawa zamienia 43 miejsca w wariant jednej matrycy | wysokie, **częściowo ograniczone** | wysoki | PKG-0113 usunął identyczne trzy lampy, dodał profile aktów/finałów, proscenium i audyt before/after. Przed content lockiem pozostają wskazane P1: 41, 42B, 43 i odrębne portrety obsady |
| R-021 | Build może działać w edytorze, lecz zawieść jako publiczny pakiet PC | wysokie | blokujące wydanie | brak `export_presets.cfg`, buildów, czystej instalacji, pełnej lokalizacji narracji, credits i manifestu praw. R3/R4 oraz content lock R2 są obowiązkowe przed nazwaniem produktu gotowym |

### Aktualizacja po PKG-0114

R-018 nie jest już blokerem wejścia ani topologii runtime: produkcyjny shell,
zapis i trasa do epilogu mają osobny gate end-to-end. Pozostaje ryzykiem
wydawniczym razem z R-021, ponieważ w tej sesji nie wykonano eksportu, czystej
instalacji, pełnej lokalizacji ani odbioru przez ludzi. R-020 nadal wymaga
content locka; dziewięć nowych kadrów R0 jest dowodem renderu, nie dowodem
czytelności ani atrakcyjności.

### Aktualizacja po PKG-0115

R1 jest zamknięte technicznie: shell, pauza i ustawienia mają fokus semantyczny
klawiatury/pada, kontrolowany remap, trwałość ustawień, skalę tekstu oraz PL/EN
dla UI. Zakres remapu jest celowo ograniczony do pięciu akcji produkcyjnych, a
konflikt jest odrzucany jawnie. Siedem kadrów normalnym driverem oraz gate
`pkg_0115_smoke_test.gd` dowodzą wymiaru, renderu i kontraktów technicznych;
nie dowodzą ergonomii, czytelności przez nową osobę ani odbioru emocjonalnego.
Dialog narracyjny nie został mechanicznie lokalizowany. R-020 i R-021 pozostają
otwarte do content locka, eksportów, czystej instalacji i audytu wydawniczego.

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
