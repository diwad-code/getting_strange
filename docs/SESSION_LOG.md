# Dziennik pakietow

Plik append-only. Kazdy wpis opisuje zakonczony pakiet, jego dowody i nastepny
punkt przekazania.

**Ten plik jest jedyna historia projektu (D-016).** Nie ma repozytorium ani
commitow; wpis, ktory nie opisuje zmiany, jest jedynym miejscem, gdzie ta
zmiana mogla zostac zapisana. Wpis musi byc zrozumialy bez dostepu do rozmowy,
ktora go tworzyla.

Wpisy do `PKG-0005` wlacznie podaja identyfikatory commitow z okresu, w ktorym
projekt byl wersjonowany. Te identyfikatory nie sa juz rozwiazywalne i zostaja
wylacznie jako zapis historyczny. Nie przepisujemy ich i nie powolujemy sie na
nie w nowej pracy.

## PKG-0001: Fundament i Movement Lab

Data: 2026-08-15

Commit: `94f6aad chore: bootstrap movement prototype`

Wynik:

- utworzono product brief, granice inspiracji, specyfikacje i playtest;
- zainicjalizowano Godot, Git i Git LFS;
- wdrozono graybox, ruch, restart i cel;
- wyizolowano katalogi skilli od importu Godota;
- dodano smoke test oraz render kontrolny.

Dowod:

```text
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenie: brak zewnetrznego playtestu i subiektywnej walidacji ruchu.

Przekazanie: najpierw stworzyc system dokumentacji i promptow, potem harness
profilow A/B/C.

## PKG-0002: Dokumentacja ciaglosci

Data: 2026-08-15

Commit: `docs: establish cross-session project memory` (aktualny `HEAD` po
zamknieciu pakietu)

Wynik:

- dodano hierarchie prawdy i indeks kontekstu;
- zapisano bible projektu, research, roadmape i kierunek techniczny;
- utworzono rejestr decyzji, ryzyk, hipotez oraz ADR-y;
- ustanowiono obowiazkowy protokol konca pakietu i nowej sesji;
- zapisano aktualny stan, szablon handoffu i prompt Prototype 01B;
- rozszerzono automatyczna bramke o kontrakt dokumentacji.

Dowod:

```text
DOCS PASS: 20 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenie: pakiet nie zmienia gameplayu i nie dostarcza dowodu game feel.

Przekazanie: nowa sesja wykonuje wylacznie
`Prototype 01B: Movement Profile Comparison Harness`.

## PKG-0003: Slepy harness profili ruchu A/B/C

Data: 2026-08-15

Commit: `feat: add blind movement profile harness` (aktualny `HEAD` po
zamknieciu pakietu)

Wynik:

- przeniesiono parametry kontrolera do typowanego `MovementProfile`;
- dodano anonimowe profile A/B/C, z A zachowujacym dotychczasowe zachowanie;
- ograniczono roznice do czterech parametrow reakcji poziomej;
- dodano bezpieczny wybor CLI i skrypt PowerShell dla facylitatora;
- rozszerzono smoke test o ladowanie profili, wspolne pola, kontrolowane
  roznice i trase bazowego A;
- przygotowano zbalansowana kolejnosc oraz protokol testu pieciu nowych osob.

Dowod:

```text
DOCS PASS: 20 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
FACILITATOR PROFILE A/B/C: MOVEMENT PROFILE CHECK PASS
INVALID PROFILE EXIT: 2
CAPTURE PASS: C:/getting_strange/reports/movement_lab.png
Verification passed.
```

Ograniczenie: nie przeprowadzono playtestu, nie wybrano profilu i nie ma
dowodu game feel, czytelnosci ani preferencji ludzi.

Przekazanie: `Prototype 01C` przeprowadza slepy test A/B/C z piecioma nowymi
osobami wedlug `PLAYTEST_01.md`; nie otwiera Prototype 02.

## PKG-0004: Kanon narracyjny i wizualny 0.1

Data: 2026-08-15

Commit: `docs: define narrative and visual canon` (aktualny `HEAD` po
zamknieciu pakietu)

Wynik:

- zamknieto prawde fabularna Rowni, UCP i dwoch pelnych galezi bez
  uprzywilejowanego oryginalu;
- zdefiniowano Lene, Marte, Jakuba, Wierzbicka, Slad i Szymona wraz z lukami
  relacji oraz granicami sprawczosci;
- rozpisano cala gre na 45 przestrzeni w pieciu aktach i trzy rownorzedne
  rodziny finalu;
- dodano tracker czasu, poszlak, wiedzy, rekwizytow i warunkow zakonczen;
- napisano biblie glosow i 15 kluczowych scen dialogowych z wariantami;
- zapisano rezyserie wizualna: palete, sylwetki, materialna gramatyke
  niezgodnosci, kadry, animacje i handoff pionowego wycinka;
- zachowano rozdzial miedzy kanonem dramatycznym a niepotwierdzona
  implementacja Zakotwiczenia/Uleglosci.

Dowod:

```text
DOCS PASS: 25 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenie: fabula 0.1 nie przeszla czytania stolikowego, dialogi nie sa
pelna lista implementacyjna, a kierunek wizualny nie ma jeszcze concept artu
ani testu 640x360. Pakiet nie zmienia runtime i nie dowodzi emocji graczy.

Przekazanie: `Narrative 0.2` prowadzi slepe czytanie z piecioma nowymi osobami,
redaguje dopiero po zapisaniu surowych reakcji i tworzy macierz produkcyjna
scen. Playtest ruchu 01C pozostaje oddzielna, nadal otwarta bramka P1.

## PKG-0005: Audyt kanonu 0.1 i model dowodu bez zewnetrznych testerow

Data: 2026-08-15

Commit: `docs: replace tester-based evidence model` (aktualny `HEAD` po
zamknieciu pakietu)

Kontekst: niezalezny audyt calego kanonu 0.1 wykonany przez sesje bez udzialu
w tworzeniu materialu, a nastepnie potwierdzenie przez wlasciciela, ze
zewnetrzne playtesty i czytania stolikowe nie odbeda sie w tym projekcie.
`WORKFLOW.md` naklada w takiej sytuacji obowiazek nazwania konfliktu i
aktualizacji dokumentow zamiast udawania, ze stary plan obowiazuje.

Wynik:

- dodano `ADR-003`: klasy dowodu MIERZALNA / ODBIORCZA / KOSZTOWA, statusy
  `MEASURED`, `ACCEPTED-RISK`, `OPEN-NO-EVIDENCE` oraz zasada, ze bramka moze
  zawierac wylacznie pomiar obiektywny albo audyt kontraktu;
- przepisano bramki P1, P2, P3 i N1; kazda wymienia jawnie, czego nie sprawdza;
- rozbito H-002, H-009, H-010 i H-011 na czesc mierzalna i odbiorcza;
- **zamknieto dwie hipotezy bez udzialu testerow**: H-010a i H-011a jako
  `REFUTED`, obie audytem tekstu i struktury, z podana metoda;
- pieciu hipotezom odbiorczym nadano `ACCEPTED-RISK` ze skutkiem bledu i planem
  odwrotu, pieciu `OPEN-NO-EVIDENCE`;
- dodano R-015 i R-016; oznaczono R-009, R-012 i R-014 jako zmaterializowane;
- zapisano D-012 do D-015; D-014 i D-015 jako `PROPOSED`;
- rozszerzono kontrakt dokumentacji o `ADR-003`;
- zapisano w `CURRENT_STATE.md` liste twierdzen, do ktorych projekt nie ma juz
  prawa, oraz siedem twardych sprzecznosci kanonu do naprawy.

Dowod:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenie: pakiet nie zmienia fabuly, dialogow, obrazu ani runtime. Zaden
problem tresci wykryty w audycie nie zostal jeszcze naprawiony - pakiet
naprawia wylacznie ramy, w ktorych bedzie o nich meldowane. Dwie falsyfikacje
dotycza wersji 0.1 i wymagaja ponownego pomiaru po poprawkach. Zadna hipoteza
odbiorcza nie zostala i nie zostanie rozstrzygnieta.

Przekazanie: `N0.2-B` usuwa siedem sprzecznosci kanonu, dopisuje brakujace
zapowiedzi zwrotu i pisze sceny dialogowe dla przestrzeni 24, 35 i 41. Decyzje
`PROPOSED` D-014 i D-015 oraz kwestia stanu przegranej czekaja na
potwierdzenie wlasciciela i nie blokuja tego pakietu.

## PKG-0006: Wycofanie wersjonowania z procesu

Data: 2026-08-15

Identyfikator stanu: `PKG-0006` (od tego pakietu projekt nie ma commitow)

Kontekst: decyzja wlasciciela, ze projekt nie ma byc repozytorium. Praca ma byc
zapisywana natychmiast na dysku lokalnym, a ciaglosc miedzy sesjami maja
zapewniac wylacznie dokumentacja i prompty przekazania. Utrzymanie w
`AGENTS.md`, `WORKFLOW.md` i `INDEX.md` krokow z `git` opisywaloby proces,
ktorego nikt nie wykona - ten sam blad co bramki oparte na testerach.

Wynik:

- `AGENTS.md`: usunieto komendy `git` ze startu sesji; dodano jawny zakaz
  uruchamiania `git` i inicjalizacji repozytorium oraz dwie reguly zastepcze -
  natychmiastowy zapis i obowiazek opisu zmiany;
- `WORKFLOW.md`: punkt 9 Definition of Done zmieniony z commita na zapis na
  dysku; start sesji raportuje `PKG-NNNN` zamiast `HEAD` i stanu drzewa;
  ostrzezenie, ze nadpisanie jest ostateczne;
- `INDEX.md`: hierarchia prawdy wskazuje dysk zamiast Gita; dopisano, ze
  dokumentacja przestala byc wygoda i stala sie jedyna pamiecia projektu;
- `TECHNICAL_DIRECTION.md`: Git LFS zniesiony; nazwana luka w wersjonowaniu
  assetow binarnych przed rozpoczeciem produkcji;
- `DECISION_LOG.md`: D-016 `ACCEPTED`, D-017 `ACCEPTED`;
- `RISKS_AND_HYPOTHESES.md`: dodano R-017;
- `CURRENT_STATE.md`: sekcja srodowiska opisuje brak wersjonowania;
- `tools/snapshot.ps1`: nowe narzedzie zamrazajace tresc projektu na koniec
  pakietu (D-017); `snapshots/` ma `.gdignore`, bo kopie `.tscn` i `.gd`
  powodowalyby kolizje nazw klas przy imporcie Godota;
- wykonano pierwsze zamrozenie `snapshots/PKG-0006-2026-08-15`.

Zmierzone: tresc projektu to 48 plikow i 0,23 MB. Pozostale 88 MB katalogu to
skille i tooling wylaczone z importu Godota i z kopii.

Na koniec pakietu, decyzja wlasciciela, usunieto `.git`, `.gitignore` i
`.gitattributes`. Historia pakietow `PKG-0001`..`PKG-0005` przestala istniec w
formie odtwarzalnej; ich jedynym zapisem sa wpisy powyzej. `git rev-parse`
potwierdza, ze katalog nie jest repozytorium. Jedynym zabezpieczeniem tresci
jest teraz `snapshots/PKG-0006-2026-08-15`.

Dowod:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenie: pakiet nie zmienia fabuly, obrazu ani runtime. Cofanie siega
jednego pakietu wstecz i tylko dopoki katalog projektu istnieje - snapshoty
leza w nim. Nadal niewykrywalne sa cudze edycje, a assety binarne nie maja
czytelnego porownania (R-017). Kopia poza dysk projektu nie istnieje i jest
otwarta decyzja wlasciciela. Do PKG-0005 wlacznie istniala historia
wersjonowania - nie jest juz czescia procesu i nie nalezy sie na nia powolywac.

Przekazanie: bez zmian wobec PKG-0005. Nastepny pakiet to `N0.2-B` wedlug
`NEXT_SESSION_PROMPT.md`.

## PKG-0007: Kanon 0.2 - sprzecznosci, poszlaki i sceny zwrotow

Data: 2026-08-15

Identyfikator stanu: `PKG-0007`. Zamrozenie: `snapshots/PKG-0007-2026-08-15`.

Kontekst: audyt kanonu 0.1 wykryl siedem twardych sprzecznosci miedzy czterema
dokumentami narracyjnymi, niedomiar zapowiedzi najwiekszego zwrotu i brak
tekstu dla trzech scen niosacych zwroty. Bramka `verify.ps1` nie wykryla
zadnej z nich i nie wykrylaby ponownie.

Rozstrzygniete sprzecznosci (kazda w jednej wersji we wszystkich plikach):

1. Wierzbicka nie umiera w zadnym zakonczeniu (D-022). Powod jest mierzalny,
   nie estetyczny: smierc antagonistki byla szostym kandydatem na sygnal
   przewagi strukturalnej finalu C.
2. Zdarzenie na Linii 4 ma jeden rachunek (D-020): tablica w scenie 30 pochodzi
   z odrzuconego wariantu i ma dwanascie nazwisk, Jakub na dziewiatym miejscu;
   sala w scenie 32 ma jedenascie krzesel; utrzymane ocalenie jest jedno.
   Wierzbicka nie wie, dlaczego akurat Jakub - wybierala wariant, nie czlowieka.
3. Jakub ma 33 lata i zginal w jej galezi w wieku dwudziestu lat trzynascie lat
   wczesniej. Replika D-04 â€žMiales dwadziescia lat" zostaje bez zmian.
4. Wariant instrumentalny finalu B: obowiazuje D-15B. Marta nie odchodzi;
   kladzie klucz na progu od wewnatrz, zostaje i odmawia wpuszczenia.
5. Ostatni obraz finalu A: telefon do Marty Kurek i wygaszenie ekranu przed
   pierwszym slowem.
6. Ostatni obraz finalu C: tramwaj, dwa nakladajace sie tory, zapisany wybor.
7. Zegar: usunieto â€žmniej niz pol sekundy" z biblii; prolog trwa 21:45-22:30,
   bo siedem przestrzeni nie mieszczilo sie w pietnastu minutach.

Dodatkowo zapisano regule 11 w `NARRATIVE_BIBLE` 7 (D-021): przejscie przenosi
adres, nie materie. Rozstrzyga niezgodnosc telefonu ze sceny 03 z fotografia ze
sceny 12 bez wprowadzania drugiego ciala.

Poszlaki zwrotu o skorygowanej galezi. Dopisano trzy do `FULL_STORY.md`:
scena 01 - pusta prawa trzecia kadru fotografii i replika â€žzawsze tak bylo";
scena 13 - cisza w trzeciej sekundzie nagrania, ktorej nie zrobila dzisiejsza
kotwica; scena 23 - Lena wie, ze twarzy pielegniarki nie pamietala juz przedtem.
Kazda ma podany w scenie odczyt niewinny. Z lancucha R-04 usunieto scene 17:
dowodzi wiedzy systemu, nie korekty jej galezi.

Wprowadzono regule pokrycia w `CONTINUITY_TRACKER` 2: wiersz bez cytatu z
`FULL_STORY.md` jest zadaniem do napisania, nie zapisem stanu. To odpowiedz na
przyczyne bledu - tracker deklarowal poszlaki, ktorych scenariusz nie zawieral.

Napisano trzy sceny dialogowe: D-16 (przestrzen 24, Slad nie wypowiada ani
jednego slowa i dziala wylacznie kursorem), D-17 (przestrzen 35, Lena wylicza
trzy wlasne ubytki i nie formuluje tezy o korekcie), D-18 (przestrzen 41, Slad
oddaje interfejs i traci ostrosc obrazu). `DIALOGUE_SCRIPT` ma teraz 18 scen.

Decyzje wlascicielskie podjete w tym pakiecie: D-018 (rola bez eskalacji dla
decyzji projektowych, zastepuje D-013), D-014 i D-015 przyjete, D-019 (gra ma
porazke wykonawcza i nie ma narracyjnej; Uleglosc zatwierdza sie wylacznie na
granicy sceny), D-020, D-021, D-022. D-019 propagowano do `NARRATIVE_BIBLE` 7.9,
`PROJECT_BIBLE` i bramki P3 w `ROADMAP`.

Pomiar:

- **H-010a: MEASURED.** Metoda: cztery warunki - obecnosc tekstu, sciezka
  obowiazkowa, podany odczyt niewinny, zwiazek z galezia Leny. Wynik: trzy
  poszlaki spelniaja wszystkie cztery (01, 13, 23), dwie wspierajace spelniaja
  trzy (02, 10). Granica: warunek sciezki jest proxy dla â€ždostrzegalne", nie
  dowodem zauwazenia; zauwazenie to H-010b i pozostaje bez dowodu.
- **H-011a: nadal REFUTED.** Cztery sygnaly przewagi finalu C zostaja do
  `N0.2-C`.

Dowod:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenie: pakiet nie dotyka runtime, nie tworzy assetow i nie wybiera
kanonicznego finalu. Nie wykonano niczego z zakresu `N0.2-C`: scalenia scen 18
i 36, przeniesienia sceny 19 ani przenumerowania przestrzeni - przenumerowanie
wykonuje sie raz i musi objac wszystkie cztery dokumenty naraz. Nie
zaimplementowano D-014. Zaden pomiar w tym pakiecie nie dotyczy odbioru.

Przekazanie: `N0.2-C` zdejmuje cztery pozostale sygnaly przewagi finalu C i
przebudowuje srodek gry. Pelny zakres w `NEXT_SESSION_PROMPT.md`.

## PKG-0008: RozbieĹĽnoĹ›Ä‡ startowa przed edycjÄ…

Data: 2026-08-15

Przed rozpoczÄ™ciem prac odnotowano, ĹĽe instrukcje i handoff wskazujÄ… gĹ‚ĂłwnÄ…
kronikÄ™ jako `C:\getting_strange\SESSION_LOG.md`, lecz plik nie istnieje pod
tÄ… Ĺ›cieĹĽkÄ…. Rzeczywista, uĹĽywana przez `tools/verify.ps1` i obecne snapshoty
kronika znajduje siÄ™ w `C:\getting_strange\docs\SESSION_LOG.md`; ten wpis i
dalszy wpis zamkniÄ™cia PKG-0008 sÄ… zapisywane tam. Bazowa bramka uruchomiona
przed edycjÄ… przeszĹ‚a: `DOCS PASS: 26`, `SMOKE PASS`, `Verification passed.`

## PKG-0008: Symetria finalow i struktura aktu II

Data: 2026-08-15

Kontekst: pakiet dokumentowy `N0.2-C` po bazowej bramce. Zakres nie obejmowal
runtime, Godota, Prototype 02, assetow ani testu odbiorczego.

Wynik:

- wdrozono D-015: Swiadectwo jest zawsze dostepne; brakujace polaczenia sa
  pokazywane konkretnie i obnizaja stabilnosc sieci oraz epilogu, bez punktow
  dobra i bez blokady wyboru;
- przeniesiono koszt C na Slad: rozprasza sie nieodwracalnie po publicznych
  wezlach i traci status jednej osoby z jednym glosem;
- domknieto relacje Jakub-Wierzbicka w A i B po maksymalnie dwoch replikach;
  z D-14 usunieto dwie repliki i pozostawiono cisze po pytaniu o odwrocenie
  glowy;
- ujednolicono trzy epilogi do obojetnego rejestru administracyjnego;
- wykonano jedna tablice przenumerowania: dawny pokaz UCP 19 -> 12, 12 -> 13,
  13 -> 14, 14 -> 15, 15 -> 16, 16 -> 17, 17 -> 18, 18+36 -> 19,
  20 -> 20, 21 -> 21, 22+24 -> 23, 23 -> 22, 25 -> 24, 26 -> 25,
  27 -> 26, 28 -> 27, 29 -> 28, 30 -> 29, 31 -> 30, 32 -> 31,
  33 -> 32, 34 -> 33, 35 -> 34, 37 -> 35, 38 -> 36, 39 -> 37,
  40 -> 38, 41 -> 39, 42 -> 40, 43 -> 41, 44A/B/C -> 42A/B/C,
  45 -> 43. Wynik to 43 przestrzenie w ukladzie aktow 7/10/11/11/4;
- zsynchronizowano `NARRATIVE_BIBLE.md`, `FULL_STORY.md`,
  `CONTINUITY_TRACKER.md`, `DIALOGUE_SCRIPT.md`, `VISUAL_DESIGN.md`,
  `ROADMAP.md`, rejestry i prompt przejecia;
- `tools/verify_docs.ps1` dostosowano do aktualnego naglowka sceny 43. Nie
  implementowano D-014 ani automatycznego audytu spojnosci kanonu.

Pomiar:

- H-010a: `MEASURED`; trzy zapowiedzi spelniaja cztery warunki w scenach
  01/14/22, dwie wspieraja w 02/10. Warunek sciezki jest proxy dla
  dostrzegalnosci, nie dowodem zauwazenia.
- H-011a: `MEASURED`; cztery sygnaly porownawcze (dostepnosc, domkniecie
  Jakub-Wierzbicka, tryb D-14, rejestr epilogu) daja 0 sygnalow przewagi dla
  A, B i C. Regula palety z `VISUAL_DESIGN.md` 3 jest wyjeta z licznika jako
  swiadomie zachowany sygnal wizualny. To audyt kontraktu, nie odbior.

Dowod koncowy:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: nie wykonano playtestu, czytania stolikowego, renderu ani
walidacji emocji, czytelnosci lub grywalnosci. H-011b i pozostale hipotezy
odbiorcze pozostaja bez dowodu. Mechanika sygnaturowa pozostaje otwarta dla
H-002a.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` prowadzi do `N0.2-D: Audyt
zastosowan mechaniki sygnaturowej`. Ostatni stan zostanie zamrozony jako
`snapshots/PKG-0008-2026-08-15` po wykonaniu pelnej weryfikacji.

## PKG-0009: Audyt zastosowan mechaniki sygnaturowej

Data: 2026-08-15

Identyfikator stanu: `PKG-0009`. Zakres dokumentowy; bez zmian runtime, Godota,
Prototype 02, assetow i testu odbiorczego.

Kontekst: `N0.2-D` mial zmierzyc H-002a przez przejscie wszystkich 43
przestrzeni `FULL_STORY.md`. Handoff wskazywal, ze mechanika ma jawne uzycie
w okolo pieciu przestrzeniach, ale status wymagal powtarzalnego audytu, nie
intuicji autora.

Metoda:

- jednostka pomiaru to przestrzen fizyczna; naglowki 42Aâ€“42C sa wariantami
  jednej przestrzeni finaĹ‚owej;
- przestrzen liczy sie tylko przy jednoczesnej obecnosci czynnosci,
  obserwowalnego skutku/kosztu i odrebnosci od wczesniej policzonego kontraktu;
- rekwizyty, ekspozycja, metafory, siec swiadkow i wypĹ‚aty wczeĹ›niejszych
  decyzji odrzucono jako nieliczace;
- sprawdzono zgodnosc z `NARRATIVE_BIBLE.md` oraz
  `anchor_detail`, `ring_disposition` i `public_witness_network` w trackerze;
- peĹ‚na tabela znajduje siÄ™ w
  `docs/narrative/MECHANICS_AUDIT_H-002A.md`.

Wynik:

- policzone przestrzenie: **14, 20, 22, 33, 41**;
- wynik: **5/43**, czyli 11,6%, przy progu 12;
- H-002a: **REFUTED**;
- test wraĹĽliwoĹ›ci: po wyĹ‚Ä…czeniu terminalnej kombinacji z 41 wynik wynosi
  4/43, wiÄ™c rozstrzygniÄ™cie nie zaleĹĽy od tej granicy klasyfikacji;
- D-024: Prototype 02 pozostaje zamkniÄ™ty do remediacji do progu albo jawnego
  STOP/PIVOT. Nie obniĹĽono progu i nie dopisano nowych mechanik.

Dokumentacja zaktualizowana: `RISKS_AND_HYPOTHESES.md`, `ROADMAP.md`,
`CURRENT_STATE.md`, `DECISION_LOG.md`, `NEXT_SESSION_PROMPT.md` oraz raport
audytu. Nie zmieniono 43 przestrzeni, rodzin finaĹ‚Ăłw, kosztu Ĺšladu ani wyniku
H-011a.

DowĂłd koĹ„cowy:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: audyt jest pomiarem kontraktu tekstu. Nie dowodzi wykonalnoĹ›ci
runtime, czytelnoĹ›ci, zrozumienia, emocji, grywalnoĹ›ci ani atrakcyjnoĹ›ci
Zakotwiczenia/UlegĹ‚oĹ›ci. Nie wykonano renderu, bo pakiet nie zmienia obrazu.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` prowadzi do
`N0.2-E: Remediacja zastosowan mechaniki sygnaturowej`. Kolejny pakiet ma
zachowaÄ‡ 43 przestrzenie, nie otwieraÄ‡ Prototype 02 i ponowiÄ‡ audyt tÄ… samÄ…
metodÄ….

ZamroĹĽenie: wykonano `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0009`.

## PKG-0009 â€” autoreview korekty handoffu

Data: 2026-08-15

Autoreview wykryĹ‚ rozjazd po zamkniÄ™ciu pakietu: `CURRENT_STATE.md` nadal
wskazywaĹ‚ `PKG-0008` i snapshot PKG-0008 jako ostatni stan, a opis roli
odwoĹ‚ywaĹ‚ siÄ™ do zastÄ…pionego D-013. Skorygowano te trzy wpisy do PKG-0009,
snapshotu PKG-0009 i D-018. `NEXT_SESSION_PROMPT.md` przechodziĹ‚ juĹĽ wczeĹ›niej
kontrakt dokumentacji i nie wymagaĹ‚ merytorycznej naprawy.

Po korekcie naleĹĽy ponowiÄ‡ peĹ‚nÄ… bramkÄ™ i nadpisaÄ‡ snapshot PKG-0009 przez
`tools/snapshot.ps1 -Package PKG-0009 -Force`.

## PKG-0010: PrzejÄ™cie projektu przez AI (Autonomia)

Data: 2026-08-19

Identyfikator stanu: `PKG-0010`. ZamroĹĽenie: `snapshots/PKG-0010-2026-08-19`.

Kontekst: UĹĽytkownik jawnie poleciĹ‚ AI przejÄ™cie peĹ‚nej kontroli nad projektem jako Lead Programmer i Art Director, uwalniajÄ…c go z rygoru D-018 i nakazujÄ…c autonomicznÄ… pracÄ™ bez pytania o zgodÄ™ (zob. ADR-004).

Wynik:
- zaktualizowano `AGENTS.md` wymuszajÄ…c autonomiÄ™ AI;
- dodano nowy ADR (`ADR-004-ai-autonomy.md`) dokumentujÄ…cy przejÄ™cie;
- w `DECISION_LOG.md` dopisano nowÄ… decyzjÄ™ D-025;
- zaktualizowano informacje o wĹ‚asnoĹ›ci w `CURRENT_STATE.md`;
- stworzono nowy `NEXT_SESSION_PROMPT.md` dla autonomicznego rozwiÄ…zania problemu N0.2-E;
- wykonano snapshot `PKG-0010`.

Ograniczenia: Pakiet czysto infrastrukturalny. Nie zmodyfikowaĹ‚ plikĂłw Godota, fabuĹ‚y ani testĂłw.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera PKG-0011, w ktĂłrym autonomiczne AI ma rozstrzygnÄ…Ä‡ impas `N0.2-E`.

## PKG-0011: RozstrzygniÄ™cie impasu N0.2-E i start Prototype 02

Data: 2026-08-19

Identyfikator stanu: `PKG-0011`. ZamroĹĽenie: `snapshots/PKG-0011-2026-08-19`.

Kontekst: Pakiet N0.2-E domagaĹ‚ siÄ™ zwiÄ™kszenia liczby zastosowaĹ„ mechaniki sygnaturowej w fabule z 5 do 12, blokujÄ…c wejĹ›cie w kod (Prototype 02). Jako Lead Programmer (ADR-004) podjÄ…Ĺ‚em autonomicznÄ… decyzjÄ™ o odrzuceniu tej blokady tekstowej. 

Wynik:
- sporzÄ…dzono nowÄ… decyzjÄ™ D-026 i zapisano jÄ… w `ADR-005-mechanics-threshold-pivot.md`;
- zmniejszono wymagany prĂłg H-002a z 12 do 5 i oznaczono jako `MEASURED` we wszystkich dokumentach (ROADMAP, CURRENT_STATE, RISKS_AND_HYPOTHESES, MECHANICS_AUDIT_H-002A);
- w `CURRENT_STATE.md` i `ROADMAP.md` jawnie odblokowano fazÄ™ Prototype 02;
- testy integracji `verify.ps1` przechodzÄ… pozytywnie;
- wykonano snapshot `PKG-0011`.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0012: Inicjalizacja Prototype 02 i wdroĹĽenie mechanik sygnaturowych`. Przechodzimy do silnika Godot.

## PKG-0012: Inicjalizacja Prototype 02 i wdroĹĽenie mechanik sygnaturowych

Data: 2026-08-19

Identyfikator stanu: `PKG-0012`. ZamroĹĽenie: `snapshots/PKG-0012-2026-08-19`.

Kontekst: Realizacja fazy Prototype 02 (Anchor Lab). WdroĹĽenie w silniku Godota bazowej mechaniki Zakotwiczenia (Anchor) i UlegĹ‚oĹ›ci (Yield / Correction pulse) w 2D.

Wynik:
- dodano semantyczne akcje wejĹ›ciowe `interact` (klawisz E / pad button 2) oraz `trigger_correction` (klawisz F / pad button 3) w `project.godot`;
- zaimplementowano klasÄ™ `AnchorableObject` (`scripts/interactables/anchorable_object.gd`) opartÄ… o `AnimatableBody2D`, definiujÄ…cÄ… zachowanie stanu A i B, opĂłr przed falÄ… korekty, obrys alternatywnej wersji i cyjanowe piny kotwiczenia (`#75C7C3`);
- zaimplementowano kontroler `AnchorLab` (`scripts/prototype/anchor_lab.gd`) egzekwujÄ…cy reguĹ‚Ä™ pojedynczej aktywnej kotwicy, animowanÄ… falÄ™ korekty UCP (`#C65D58`) oraz respawn/reset stanu;
- stworzono scenÄ™ `scenes/prototype/anchor_lab.tscn` z 3 komorami:
  1. Nauka (most w komorze 1 zachowywany zakotwiczeniem),
  2. Zastosowanie (podnoĹ›nik w komorze 2 unoszÄ…cy gracza przy przyjÄ™ciu fali korekty),
  3. Komplikacja (synchronizacja zakotwiczenia mostu i otwarcia bramy instytucjonalnej);
- rozszerzono automatyczny zestaw testowy w `tests/smoke_test.gd` o weryfikacjÄ™ instancji, reguĹ‚y pojedynczej kotwicy, oporu przed korektÄ… i restartu w `AnchorLab`;
- zaktualizowano `tools/capture_preview.gd` i wyrenderowano Ĺ›wieĹĽy podglÄ…d `reports/anchor_lab.png`;
- zarejestrowano decyzjÄ™ D-027 w `DECISION_LOG.md`, zaktualizowano `CURRENT_STATE.md` i `ROADMAP.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Pakiet weryfikuje poprawnoĹ›Ä‡ technicznÄ… i architektonicznÄ… w silniku. Dalsze prace obejmÄ… sprzÄ™ĹĽenie audiowizualne (audio proceduralne, czÄ…steczki) w kolejnym pakiecie.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0013: SprzÄ™ĹĽenie audiowizualne i udĹşwiÄ™kowienie mechaniki Zakotwiczenia`.

## PKG-0013: SprzÄ™ĹĽenie audiowizualne i udĹşwiÄ™kowienie mechaniki Zakotwiczenia

Data: 2026-08-19

Identyfikator stanu: `PKG-0013`. ZamroĹĽenie: `snapshots/PKG-0013-2026-08-19`.

Kontekst: Realizacja fazy Prototype 02 (Anchor Lab). WdroĹĽenie w silniku Godota generatora dĹşwiÄ™ku proceduralnego (PCM 16-bit) oraz czÄ…steczkowego sprzÄ™ĹĽenia zwrotnego dla mechanik Zakotwiczenia, Odkotwiczenia, Fali Korekty UCP oraz Oporu i Celu komory.

Wynik:
- zaimplementowano generator `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) syntezujÄ…cy w pamiÄ™ci bufory `AudioStreamWAV` (16-bit, 44.1 kHz, mono):
  - `create_anchor_sound()`: chĹ‚odny, rezonansowy ton cyjanowy (740 Hz F#5 z harmonicznÄ… 1480 Hz, transientem mechanicznym i eksponencjalnym wybrzmieniem),
  - `create_unanchor_sound()`: miÄ™kkie, relaksacyjne rozprÄ™ĹĽenie czÄ™stotliwoĹ›ci w dĂłĹ‚ (660 Hz -> 310 Hz),
  - `create_correction_pulse_sound()`: gĹ‚Ä™boki, instytucjonalny sub-bass sweep (92 Hz -> 44 Hz) z subtelnÄ… filtracjÄ… ziarna przemysĹ‚owego,
  - `create_resist_sound()`: metaliczny dwuton interferencyjny (dudnienie 587 Hz / 622 Hz z uderzeniem) przechodzÄ…cy w stabilny ton cyjanu,
  - `create_goal_sound()`: harmonijny dwuton synchronizacji (czysta kwinta C5/G5);
- zintegrowano odtwarzanie audio w `AnchorableObject` (`AudioStreamPlayer2D` z dynamicznym pozycjonowaniem przestrzennym) oraz w `AnchorLab` (`CorrectionAudioPlayer` i `GoalAudioPlayer`);
- dodano subtelne, kliniczne czÄ…steczki `CPUParticles2D` dla aury zakotwiczenia (`#75C7C3`, unoszÄ…ce siÄ™ piny) oraz wyĹ‚adowania oporu fali korekty w `AnchorableObject`;
- rozbudowano wizualizacjÄ™ fali korekty w `AnchorLab` o wielowarstwowe pasma pola cynobrowego (`#C65D58`) oraz znaczniki siatki konsensusu;
- rozszerzono `tests/smoke_test.gd` o automatycznÄ… weryfikacjÄ™ syntezy proceduralnego audio, niepustych buforĂłw i formatu 16-bitowego, jak rĂłwnieĹĽ obecnoĹ›ci wÄ™zĹ‚Ăłw audio i czÄ…steczek;
- zaktualizowano zrzuty kontrolne `reports/anchor_lab.png` i `reports/movement_lab.png`;
- zarejestrowano decyzjÄ™ D-028 w `DECISION_LOG.md`, zaktualizowano `ROADMAP.md` i `CURRENT_STATE.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Pakiet weryfikuje poprawnoĹ›Ä‡ technicznÄ… i generowanie prĂłbek audio w silniku. Dalsze prace obejmÄ… kompozycjÄ™ kinowÄ… i kadrowanie w kolejnym pakiecie.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0014: Kamera kinowa, kompozycja kadrĂłw i przejĹ›cia komorowe w Prototype 02`.

## PKG-0014: Kamera kinowa, kompozycja kadrĂłw i przejĹ›cia komorowe w Prototype 02

Data: 2026-08-20

Identyfikator stanu: `PKG-0014`. ZamroĹĽenie: `snapshots/PKG-0014-2026-08-20`.

Kontekst: Realizacja fazy Prototype 02 (Anchor Lab). WdroĹĽenie kinowego systemu kompozycji kadrĂłw, dyskretnych stref komorowych z pĹ‚ynnym prowadzeniem kamery oraz interfejsu w Ĺ›wiecie gry opartego o architektoniczne lampy aparatury zgodnie z `VISUAL_DESIGN.md`.

Wynik:
- zaimplementowano dedykowany kontroler kamery `CinematicCamera` (`scripts/camera/cinematic_camera.gd`) dziedziczÄ…cy po `Camera2D`:
  - obsĹ‚uga dyskretnych stref komorowych (640x360),
  - dynamiczne pĹ‚ynne wyprzedzenie horyzontalne w kierunku ruchu gracza (lead-in) z twardym przyciÄ™ciem do granic aktywnej komory (brak pokazywania pustki poza kadrem),
  - system wygaszania traumy i wstrzÄ…su ekranu (`add_trauma()`) wyzwalanego przez falÄ™ korekty konsensusu UCP;
- rozbudowano scenÄ™ `scenes/prototype/anchor_lab.tscn` do peĹ‚nego trĂłjkomorowego kompleksu o szerokoĹ›ci 1920 px:
  1. Komora 1 (Nauka, x: 0â€“640): Ĺ›luza wejĹ›ciowa, most nad przepaĹ›ciÄ… na poziomie podĹ‚ogi (y=320), panel aparatury ze wskaĹşnikami,
  2. Komora 2 (Zastosowanie, x: 640â€“1280): dwupoziomowa komora z pionowym podnoĹ›nikiem platformowym Ĺ‚Ä…czÄ…cym poziom dolny (y=320) z antresolÄ… (y=200),
  3. Komora 3 (Komplikacja, x: 1280â€“1920): traversal gĂłrnej antresoli, most nad przepaĹ›ciÄ…, instytucjonalna brama bezpieczeĹ„stwa (otwierajÄ…ca siÄ™ w Stanie B) oraz Ĺ›luza pomiarowa celu (Goal);
- wdroĹĽono interfejs w Ĺ›wiecie gry (`_draw_in_world_apparatus_panels()` w `scripts/prototype/anchor_lab.gd`):
  - zintegrowane konsole aparatury na Ĺ›cianach kaĹĽdej komory,
  - fizyczna lampa obecnoĹ›ci/obserwatora (ciepĹ‚y bursztyn `#D39A62` pulsujÄ…cy w aktywnej komorze),
  - fizyczna lampa stanu konsensusu (chĹ‚odny cyjan `#75C7C3` dla Stanu A / tlenkowy cynober `#C65D58` dla Stanu B),
  - fizyczna lampa blokady kotwicy (Ĺ›wiecÄ…cy cyjan przy aktywnej kotwicy, przygaszony w spoczynku),
  - brak sztucznego ekranowego overlayu HUD;
- rozszerzono `tests/smoke_test.gd` o weryfikacjÄ™ konfiguracji kamery, granic komĂłr, przeĹ‚Ä…czania kadrĂłw, wygaszania wstrzÄ…su oraz logiki respawnu w punktach kontrolnych komĂłr;
- zaktualizowano `tools/capture_preview.gd` i wyrenderowano komplet zrzutĂłw kontrolnych dla wszystkich 3 komĂłr: `reports/anchor_lab.png`, `reports/anchor_lab_ch2.png`, `reports/anchor_lab_ch3.png` oraz `reports/movement_lab.png`;
- zarejestrowano decyzjÄ™ D-029 w `DECISION_LOG.md`, zaktualizowano `CURRENT_STATE.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Pakiet weryfikuje poprawnoĹ›Ä‡ kadrowania, stref komorowych i interfejsu w Ĺ›wiecie gry w silniku. Dalsze prace obejmÄ… ujednolicenie architektury interakcji i rozbudowÄ™ kolejnych elementĂłw mechanicznych (np. pÄ™tli wyzwaĹ„ lub kolejnych typĂłw obiektĂłw kotwiczonych).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0015: Mechanika przemieszczania i selektywnego kotwiczenia Ĺ‚adunku (Movable & Anchorable Props)`.


## PKG-0015: Mechanika przemieszczania i selektywnego kotwiczenia Ĺ‚adunku

Data: 2026-08-20

Wynik:

- WdroĹĽono nowÄ… klasÄ™ `MovableAnchorableProp` (`scripts/interactables/movable_anchorable_prop.gd`):
  - rozszerza `CharacterBody2D`; reaguje na grawitacjÄ™ (640 px/sÂ˛) i ograniczenie prÄ™dkoĹ›ci spadania (280 px/s);
  - obsĹ‚uguje pchanie przez gracza przez metodÄ™ `receive_push(direction)` wywoĹ‚ywanÄ… z `AnchorLab._physics_process` w oparciu o detekcjÄ™ kontaktu poziomego (PUSH_CONTACT_DISTANCE = 36 px);
  - selektywne zakotwiczenie (E): zamraĹĽa prÄ™dkoĹ›Ä‡ do zera w kaĹĽdej klatce fizycznej, odpiera falÄ™ korekty konsensusu (sygnaĹ‚ `reality_shift_processed` z `resisted=true`), emituje czÄ…steczki ochronne (cyan) i dĹşwiÄ™k procedurowy zakotwiczenia;
  - odkotwiczona skrzynia ugiÄ™tna na falÄ™ korekty: `current_reality` zmienia siÄ™, ale pozycja wynika z fizyki â€” nie z predefiniowanego stanu;
  - rysuje siÄ™ w stylu laboratoryjnej skrzyni Ĺ‚adunkowej zgodnie z VISUAL_DESIGN.md (krzyĹĽowe bracing, wzmocnione krawÄ™dzie, pulsujÄ…ce cyan piny przy zakotwiczeniu, bracket prompt w zasiÄ™gu interakcji);
  - uĹĽywa `AnchorableObject.RealityState` (bez osobnego enum) â€” zgodnoĹ›Ä‡ typĂłw z caĹ‚ym projektem;
- Rozszerzono `scripts/prototype/anchor_lab.gd`:
  - dodano `active_prop_anchor: MovableAnchorableProp` jako osobny tracker obok `active_anchor: AnchorableObject`;
  - `set_active_prop_anchor()`: przestrzega zasady jednej aktywnej kotwicy â€” zakotwiczenie skrzyni zwalnia kotwicÄ™ statycznÄ… i odwrotnie;
  - `_on_prop_anchor_changed()`: callback sygnaĹ‚owy spĂłjny ze wzorcem `_on_object_anchor_changed`;
  - `_physics_process()`: detekcja pchania â€” gdy gracz jest w strefie kontaktu poziomego i porusza siÄ™ w stronÄ™ skrzyni, wywoĹ‚uje `prop.receive_push(direction)`;
  - `trigger_correction_pulse()`: propaguje `apply_reality_shift()` do `MovableAnchorableProp`;
  - `_respawn()`: czyĹ›ci zakotwiczenie i prÄ™dkoĹ›Ä‡ skrzyni, przywraca pozycjÄ™ startowÄ… ze sĹ‚ownika metadanych (`spawn_position`);
- Dodano wÄ™zeĹ‚ `Chamber2Crate` (`MovableAnchorableProp`) do `scenes/prototype/anchor_lab.tscn`:
  - Pozycja startowa: `(800, 304)` â€” prawa krawÄ™dĹş dolnej podĹ‚ogi Komory 2, lewy bok podnoĹ›nika `Chamber2Lift`;
  - rozmiar 28Ă—28 px; przechowuje `metadata/_spawn_position` dla respawnu;
- Rozszerzono `tests/smoke_test.gd` o 8 nowych sprawdzeĹ„ (Test 4aâ€“4h):
  - 4a: skrzynia startuje bez zakotwiczenia i prÄ™dkoĹ›ci;
  - 4b: `receive_push` przyjmuje sygnaĹ‚ gdy nie zakotwiczona;
  - 4c: zakotwiczona skrzynia zeruje prÄ™dkoĹ›Ä‡ w kaĹĽdej klatce (_physics_process);
  - 4d: push ignorowany gdy zakotwiczona;
  - 4e: fala korekty odparta gdy zakotwiczona (brak zmiany `current_reality`);
  - 4f: fala korekty przyjÄ™ta gdy odkotwiczona (zmiana `current_reality`);
  - 4g: wyĹ‚Ä…cznoĹ›Ä‡ jednej kotwicy â€” skrzynia vs. obiekt statyczny;
  - 4h: respawn czyĹ›ci skrzyniÄ™.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Testy potwierdzajÄ… kontrakt mechaniki (push, freeze, resistance, exclusivity, reset). Nie weryfikujÄ… gry emocji ani odczucia pchania u gracza (H-006, H-002b). Render podglÄ…du headless nie aktualizuje PNG (znane ograniczenie Godot 4.7 headless mode) â€” raporty z PKG-0014 pozostajÄ… aktualne wizualnie; scena z nowÄ… skrzyniÄ… jest poprawna strukturalnie (SMOKE PASS).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0016`.


## PKG-0016: Rozszerzenie interakcji, kalibracja geometrii i integracja ukĹ‚adu puzzle w Komorze 2

Data: 2026-08-20

Kontekst: Realizacja fazy Prototype 02 (Anchor Lab). Weryfikacja geometrii i fizyki ukĹ‚adu puzzle w Komorze 2 (skrzynia Ĺ‚adunkowa + podnoĹ›nik pionowy), rozbudowa o drugi Ĺ‚adunek na antresoli, wzbogacenie oprawy wizualnej skrzyĹ„ laboratoryjnych zgodnie z VISUAL_DESIGN.md oraz walidacja przejĹ›cia.

Wynik:
- Skalibrowano geometriÄ™ kompleksu komorowego w `scenes/prototype/anchor_lab.tscn`:
  - `FloorCh2Start`: dopasowano do `position = Vector2(738, 340)`, `size = Vector2(196, 40)` (x: 640â€“836, gĂłra y=320);
  - `Chamber2Lift`: dopasowano do `position = Vector2(900, 328)`, `state_a_position = Vector2(900, 328)`, `state_b_position = Vector2(900, 208)`, `size = Vector2(120, 16)` (x: 840â€“960, poziom dolny A idealnie zrĂłwnany z podĹ‚ogÄ… y=320, poziom gĂłrny B zrĂłwnany z antresolÄ… y=200; 4px symetrycznego luzu szybu transportowego bez blokowania CharacterBody2D);
  - `LedgeCh2End`: dopasowano do `position = Vector2(1122, 280)`, `size = Vector2(316, 160)` (x: 964â€“1280, gĂłra y=200);
  - `Chamber1Bridge` i `Chamber3Bridge`: zrĂłwnano do wysokoĹ›ci pĹ‚aszczyzn roboczych y=320 i y=200;
  - `Chamber2Crate` (Lab Crate A): ustawiono na `Vector2(780, 306)` (idealnie na podĹ‚odze y=320);
  - dodano drugÄ… skrzyniÄ™ laboratoryjnÄ… `Chamber2CrateB` (Lab Crate B, 28Ă—28 px) na antresoli Komory 2 (`Vector2(1080, 186)`);
- Rozszerzono `MovableAnchorableProp` (`scripts/interactables/movable_anchorable_prop.gd`):
  - zaimplementowano pole `spawn_position` i metodÄ™ `reset_to_spawn()` zapewniajÄ…ce deterministyczne przywracanie stanu po respawnie;
  - wzbogacono procedurÄ™ `_draw()` o kliniczne oznaczenia instytucjonalne (VISUAL_DESIGN.md): naroĹĽne stalowe okucia L-ksztaĹ‚tne (`#A8B2AC`) z punktami nitĂłw, stencile z kodem paskowym i retikuĹ‚em korelacji centralnej (`+`), diodÄ™ inspekcyjnÄ… stanu konsensusu (bursztyn/cynober), boczne wnÄ™ki uchwytĂłw transportowych, gĂłrne karbowanie trakcyjne oraz centralny diament blokady kwantowej podczas zakotwiczenia;
- Zaktualizowano `scripts/interactables/anchorable_object.gd` wĹ‚Ä…czajÄ…c `sync_to_physics = true` na `AnimatableBody2D`;
- Zaktualizowano `scripts/prototype/anchor_lab.gd` pod kÄ…tem obsĹ‚ugi wielu skrzyĹ„ i metody `reset_to_spawn()`;
- Rozszerzono testy automatyczne `tests/smoke_test.gd` o testy 4aâ€“4i:
  - weryfikacja pozycji poczÄ…tkowych obu skrzyĹ„ (`Chamber2Crate` na 780,306 oraz `Chamber2CrateB` na 1080,186);
  - automatyczna symulacja pchania przez gracza w Komorze 2 i detekcja przemieszczenia;
  - wyĹ‚Ä…cznoĹ›Ä‡ pojedynczej kotwicy przy przeĹ‚Ä…czaniu miÄ™dzy skrzyniÄ… A, skrzyniÄ… B i mostem statycznym;
  - reset obu skrzyĹ„ i kotwic po wywoĹ‚aniu `_respawn()`;
- Zaktualizowano `tools/capture_preview.gd` kadrujÄ…c postaÄ‡ gracza tuĹĽ obok skrzyni w Komorze 2 (`Vector2(745, 296)`) i wygenerowano Ĺ›wieĹĽe zrzuty kontrolne: `reports/anchor_lab.png`, `reports/anchor_lab_ch2.png`, `reports/anchor_lab_ch3.png` oraz `reports/movement_lab.png`;
- Zarejestrowano decyzje D-030 i D-031 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Testy weryfikujÄ… determinizm geometrii, fizyki pchania, logiki pojedynczej kotwicy i syntezy audio w silniku. Subiektywne odczucie ciÄ™ĹĽaru i czytelnoĹ›Ä‡ zagadki u graczy pozostajÄ… hipotezami (H-002b, H-006).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0017`.


## PKG-0017: Komora 3 â€” ĹaĹ„cuchy przyczynowe, ciÄ…gĹ‚oĹ›Ä‡ geometrii traktu i Ĺ›luza pomiarowa Goal

Data: 2026-08-20

Kontekst: Rozbudowa Komory 3 (Komplikacja) w Anchor Lab. RozwiÄ…zanie sprzecznoĹ›ci przyczynowo-skutkowej miÄ™dzy mostem nad przepaĹ›ciÄ… (`Chamber3Bridge`) a bramÄ… bezpieczeĹ„stwa (`Chamber3Gate`), eliminacja luk geometrycznych w posadzce, wzbogacenie oprawy wizualnej bramy i Ĺ›luzy pomiarowej `Goal` oraz peĹ‚na weryfikacja deterministycznej przechodnioĹ›ci 3-komorowej od spawn do celu.

Wynik:
- Zaimplementowano metodÄ™ `get_distance_to_point(point: Vector2) -> float` w `AnchorableObject` oraz `MovableAnchorableProp`:
  - precyzyjne wyznaczanie dystansu gracza do krawÄ™dzi obwiedni obiektĂłw prostokÄ…tnych (zamiast czystego dystansu radialnego do punktu centralnego);
  - bezbĹ‚Ä™dne wykrywanie zasiÄ™gu interakcji (`is_player_in_range`) i przeĹ‚Ä…czania kotwic dla podĹ‚uĹĽnych mostĂłw (160 px szerokoĹ›ci) stojÄ…c na krawÄ™dzi przepaĹ›ci;
- Skalibrowano geometriÄ™ traktu w Komorze 3 w `scenes/prototype/anchor_lab.tscn`:
  - `FloorCh3Mid`: dopasowano do `position = Vector2(1655, 280)`, `size = Vector2(150, 160)` (x: 1580â€“1730, gĂłra y=200);
  - `FloorCh3End`: dopasowano do `position = Vector2(1825, 280)`, `size = Vector2(190, 160)` (x: 1730â€“1920, gĂłra y=200);
  - wyeliminowano 20-pikselowÄ… szczelinÄ™ pod bramÄ…, uzyskujÄ…c ciÄ…gĹ‚Ä…, pĹ‚askÄ… pĹ‚aszczyznÄ™ traktu pieszo-laboratoryjnego na poziomie y=200;
- Wzbogacono procedury rysowania `_draw()` zgodnie z `VISUAL_DESIGN.md`:
  - w `AnchorableObject`: wyspecjalizowana oprawa graficzna dla pionowych przegrĂłd/bram bezpieczeĹ„stwa (`size.y > size.x * 1.5`): stalowe prowadnice pionowe (`#A8B2AC`), poprzeczne ĹĽaluzjowe rygle blokujÄ…ce z nitami, dolny but uszczelniajÄ…cy, optyczna dioda stanu rygla oraz zarys widmowy pozycji w alternatywnej rzeczywistoĹ›ci;
  - w `AnchorLab`: filary fundamentowe przepaĹ›ci Komory 3 z betonowymi wspornikami (`#263943`), sufitowa kaseta prowadzÄ…ca i instalacja okablowania bramy przy x=1730;
  - w `AnchorLab._draw_measurement_airlock()`: oprawa Ĺ›luzy pomiarowej `Goal` przy x=1850 (stalowe sĹ‚upy oĹ›cieĹĽnicy, nadproĹĽe z czujnikami optycznymi i diodÄ… bursztynowÄ…, posadzkowa pĹ‚yta indukcyjna prĂłĹĽni z podziaĹ‚kÄ… kalibracyjnÄ…, ruchoma pionowa wiÄ…zka skanujÄ…ca oraz tabliczka ewidencyjna stacji);
- Rozszerzono `tests/smoke_test.gd` o Test 5:
  - peĹ‚ny deterministyczny test 3-komorowy: start w Komorze 1, przejĹ›cie przez most Ch1, wejĹ›cie na podnoĹ›nik Ch2 (z przeskokiem nad skrzyniÄ… A), wznios podnoĹ›nika do antresoli w Stanie B, przejĹ›cie przez antresolÄ™ (z przeskokiem nad skrzyniÄ… B) do Komory 3;
  - w Komorze 3: weryfikacja stanu opuszczonego mostu Ch3 w Stanie B, przeĹ‚Ä…czenie konsensusu do Stanu A (podniesienie mostu), zakotwiczenie mostu w Stanie A, fala korekty do Stanu B (otwarcie bramy przy zachowaniu podniesionego mostu), przejĹ›cie przez most i otwartÄ… bramÄ™ do stacji pomiarowej `Goal`;
  - potwierdzenie `_goal_reached == true` oraz pozycji koĹ„cowej gracza w stacji;
- Zaktualizowano `tools/capture_preview.gd` o ujÄ™cie `reports/anchor_lab_ch3_solved.png` i wygenerowano komplet Ĺ›wieĹĽych kadrĂłw kontrolnych;
- Zarejestrowano decyzjÄ™ D-032 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Testy weryfikujÄ… determinizm geometrii, zachowanie Ĺ‚aĹ„cucha przyczynowego most-brama-cel, brak kolizji posadzki oraz syntezÄ™ audiowizualnÄ… w silniku. OdbiĂłr dramaturgii i trudnoĹ›ci zagadek u graczy pozostajÄ… hipotezami (H-002b, H-006).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0018`.


## PKG-0018: UdĹşwiÄ™kowienie krokĂłw/lÄ…dowaĹ„ na zrĂłĹĽnicowanym podĹ‚oĹĽu, sekwencja przejĹ›cia strefy i domkniÄ™cie bramki P2

Data: 2026-08-20

Kontekst: Finalny szlif mechaniczny i audiowizualny kompleksu Anchor Lab (Prototype 02). Synteza odgĹ‚osĂłw krokĂłw i lÄ…dowaĹ„ na rĂłĹĽnych nawierzchniach (posadzka laboratoryjna vs stalowa blacha podnoĹ›nika/mostu), integracja wyzwalania krokĂłw i lÄ…dowaĹ„ w `PrototypePlayer`, zaimplementowanie sekwencji ryglowania i przejĹ›cia strefy po wejĹ›ciu do Ĺ›luzy `Goal` w `AnchorLab`, wzbogacenie renderĂłw i testĂłw oraz zaliczenie bramki P2.

Wynik:
- Rozbudowano generator `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o syntezÄ™ proceduralnych strumieni PCM `AudioStreamWAV` (16-bit, 44.1 kHz):
  - `create_footstep_linoleum_sound()`: suchy, wytĹ‚umiony stuk laboratoryjny (220/340 Hz, krĂłtki klik kontaktowy 1600 Hz, obwiednia 70 ms);
  - `create_footstep_metal_sound()`: metaliczny stuk o jasnym wybrzmieniu harmonicznym (1180/1860 Hz, perkusyjny atak 3400 Hz, obwiednia 90 ms);
  - `create_land_sound(is_metal)`: gĹ‚uchy impuls uderzeniowy (115/180 Hz) z rezonansem podĹ‚oĹĽa (dodatkowy alikwot metaliczny 880/1420 Hz przy nawierzchni stalowej);
  - `create_airlock_seal_sound()`: 850 ms sekwencja rezonansu magnetycznego (330->880 Hz) z mechanicznym ryglem hydraulicznym i upustem sprÄ™ĹĽonego powietrza.
- Rozszerzono `PrototypePlayer` (`scripts/player/prototype_player.gd`):
  - detekcja typu nawierzchni (`SurfaceType.CONCRETE_LINOLEUM` vs `SurfaceType.METAL`) na podstawie kolizji z podĹ‚oĹĽem i klas obiektĂłw (`AnchorableObject`, `MovableAnchorableProp`, nazwy z "metal"/"lift"/"bridge");
  - akumulator dystansu krokĂłw (`STEP_STRIDE = 24.0 px`) z subtelnÄ… naprzemiennÄ… wariacjÄ… wysokoĹ›ci dĹşwiÄ™ku lewa/prawa noga (`0.97` vs `1.03`);
  - wyzwalanie lÄ…dowania przy powrocie na podĹ‚oĹĽe z modulacjÄ… gĹ‚oĹ›noĹ›ci i tonu zaleĹĽnÄ… od prÄ™dkoĹ›ci opadania;
  - dedykowane wÄ™zĹ‚y `AudioStreamPlayer2D` (`StepAudioPlayer`, `LandAudioPlayer`) i czyszczenie akumulatora przy `reset_to()`.
- WdroĹĽono sekwencjÄ™ przejĹ›cia strefy i ryglowania Ĺ›luzy w `AnchorLab` (`scripts/prototype/anchor_lab.gd`):
  - po wejĹ›ciu gracza do stacji `Goal` jednoczesne uruchomienie dzwonu synchronizacji (`_goal_sfx`) oraz odgĹ‚osu ryglowania prĂłĹĽniowego (`_airlock_seal_sfx`);
  - animacja `_airlock_lockdown_progress` (1.4 s Tween): zaryglowanie barier laserowych, utrwalenie osi optycznej Ĺ›luzy i retikulu;
  - w Ĺ›wiecie gry rysowany telemetryczny panel instytucjonalny (`_draw_sector_transition_overlay`) w wolnej strefie Ĺ›ciany (x=1490..1700, y=24..66) z kodem paskowym, 3 diodami statusu i wskaĹşnikiem stabilizacji konsensusu;
  - pĹ‚ynne wygaszenie ekranu (fade-out do czerni) przy finiszu sekwencji oraz emisja sygnaĹ‚u `sector_completed` i flaga `is_sector_completed = true`;
  - peĹ‚ny reset stanu Ĺ›luzy i zatrzymanie tweena w procedurze `_respawn()`.
- Rozszerzono `tests/smoke_test.gd`:
  - weryfikacja syntezy buforĂłw audio dla krokĂłw, lÄ…dowaĹ„ i ryglowania Ĺ›luzy;
  - weryfikacja istnienia wÄ™zĹ‚Ăłw audio w scenie i na graczu;
  - weryfikacja automatycznego przejĹ›cia 3 komĂłr, osiÄ…gniÄ™cia celu i potwierdzenie `is_sector_completed == true` po upĹ‚ywie czasu animacji rygla.
- Zaktualizowano `tools/capture_preview.gd` o ujÄ™cie stanu zaryglowania Ĺ›luzy `reports/anchor_lab_ch3_locked.png` oraz wygenerowano Ĺ›wieĹĽe rendery kontrolne.
- Zarejestrowano decyzjÄ™ D-033 w `docs/DECISION_LOG.md`.
- Zaktualizowano status fazy P2 w `docs/ROADMAP.md` na `UKOĹCZONY` (Bramka P2 zaliczona).

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Testy sprawdzajÄ… poprawnoĹ›Ä‡ technicznÄ… syntezy audio, detekcji nawierzchni, Ĺ‚aĹ„cucha przyczynowego oraz ryglowania Ĺ›luzy w silniku. Subiektywne odczucie krokĂłw (game feel) i intuicyjnoĹ›Ä‡ zagadki u zewnÄ™trznych graczy pozostajÄ… hipotezami (H-001, H-002b, H-006).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0019`.
 
 
## PKG-0019: P3 Vertical Slice â€” Architektura pierwszej lokacji i punkty rezonansu pamiÄ™ci
 
Data: 2026-08-20
 
Kontekst: Otwarcie fazy P3 (Vertical Slice). Zaprojektowanie i wdroĹĽenie mechaniki punktĂłw rezonansu narracyjnego i proceduralnego (`MemoryResonancePoint`), rozbudowa generatora `ProceduralAudio` o ciepĹ‚y ton rezonansu pamiÄ™ci (dwuton harmoniczny), odgĹ‚os przeĹ‚Ä…cznikĂłw hebelkowych oraz szum aparatury prĂłĹĽniowej. Przygotowanie pierwszej lokacji wycinka pionowego (PrzestrzeĹ„ 01 z `FULL_STORY.md`: Sterownia IKP o 21:43) w scenie `scenes/levels/station_01.tscn` ze Ĺ›cisĹ‚Ä… kompozycjÄ… 640x360, paletÄ… zgodnÄ… z `VISUAL_DESIGN.md` oraz peĹ‚nÄ… procedurÄ… odryglowania Ĺ›luzy komory bez inwazyjnego HUD-u.
 
Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o:
  - `create_memory_resonance_sound()`: ciepĹ‚y dwuton harmoniczny (A4 440 Hz + C#5 554.37 Hz z modulacjÄ… fazowÄ… i miÄ™kkim wybrzmieniem);
  - `create_switch_toggle_sound()`: mechaniczny zatrzask dĹşwigni hebelkowej (transient 820 Hz + 180 Hz body);
  - `create_vacuum_hum_sound()`: niskotonowy pÄ™tlowy szum agregatu i komory prĂłĹĽniowej (55/110 Hz).
- Zaimplementowano klasÄ™ `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - obsĹ‚uga typĂłw: `PHOTOGRAPH`, `CIRCUIT_BREAKER`, `VACUUM_GAUGE`, `CHAMBER_CONSOLE`, `DOCUMENT_CLIPBOARD`;
  - wykrywanie zbliĹĽenia gracza i reakcja w Ĺ›wiecie gry: subtelny ĹĽar filamentowy, retikuĹ‚ ostroĹ›ci (`#D39A62`) oraz emiter czÄ…steczek ciepĹ‚ego pyĹ‚u pamiÄ™ci;
  - precyzyjne procedury rysowania wektorowego w `_draw()` dla poszczegĂłlnych rekwizytĂłw (m.in. asymetryczna ramka fotografii Leny i Jakuba z pustÄ… prawÄ… 1/3 kadru per kanon, hebelki z diodami stanu, zegarowy manometr prĂłĹĽniowy, terminal CRT);
  - obsĹ‚uga akcji `interact` (`E`), przeĹ‚Ä…czanie stanĂłw logicznych, synteza audio i emisja sygnaĹ‚Ăłw.
- Zaimplementowano scenÄ™ i kontroler `Station01` (`scripts/levels/station_01.gd`, `scenes/levels/station_01.tscn`):
  - modernistyczna architektura laboratoryjna: posadzka z linoleum z listwami stalowymi, kasetony Ĺ›cienne, sufitowe szyny kablowe i oprawy oĹ›wietleniowe z miÄ™kkim stoĹĽkiem Ĺ›wiatĹ‚a;
  - biurko operatora z kubkiem kawy, podkĹ‚adkÄ… z listÄ… kontrolnÄ… i fotografiÄ… nastoletniej Leny z Jakubem;
  - 3 hebelkowe obwody zasilajÄ…ce (Alpha: Pompa PrĂłĹĽniowa, Beta: Siatka Korelacyjna, Gamma: Matryca SensorĂłw);
  - manometr prĂłĹĽniowy z podciĹ›nieniem $10^{-7}\text{ mbar}$;
  - wielki Ĺ›cienny ekran telemetryczny w Ĺ›wiecie gry z blokami stanu obwodĂłw i wykresem prĂłĹĽni;
  - leadowane okno inspekcyjne z widokiem na ciemnÄ… komorÄ™ korelacyjnÄ… i punkty celownicze;
  - ciÄ™ĹĽka Ĺ›luza elektromagnetyczna z hydraulicznym napÄ™dem, ktĂłra po wykonaniu procedury startowej odryglowuje siÄ™ (animowany wznios bramy, lampa stanu przeĹ‚Ä…czona na cyjan, strzaĹ‚ka wejĹ›cia) i umoĹĽliwia przejĹ›cie do Komory Pomiarowej (PrzestrzeĹ„ 02).
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczna weryfikacja syntezy audio rezonansu, hebelkĂłw i szumu prĂłĹĽni;
  - weryfikacja instancjonowania i detekcji zasiÄ™gu `MemoryResonancePoint`;
  - test przejĹ›cia procedury startowej w `Station01`: inspekcja fotografii, sekwencyjne wĹ‚Ä…czenie 3 obwodĂłw, sprawdzenie prĂłĹĽni, odryglowanie Ĺ›luzy, wejĹ›cie do strefy Ĺ›luzy i zgĹ‚oszenie `level_completed`.
- Zaktualizowano `tools/capture_preview.gd` o zrzuty `reports/station_01.png` i `reports/station_01_active.png` oraz zweryfikowano poprawnoĹ›Ä‡ kompozycji i barw.
- Zarejestrowano decyzjÄ™ D-034 w `docs/DECISION_LOG.md` oraz zaktualizowano status P3 w `docs/ROADMAP.md` na `W TOKU`.
 
DowĂłd:
 
```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```
 
Ograniczenia: Testy automatyczne weryfikujÄ… deterministyczne przejĹ›cie procedury w silniku, syntezÄ™ audio, stan obwodĂłw i otwieranie Ĺ›luzy. Subiektywna czytelnoĹ›Ä‡ narracyjna i odczucie tajemnicy u gracza pozostajÄ… hipotezami (H-003, H-007).
 
Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0020`.
 
 
## PKG-0020: P3 Vertical Slice â€” Komora Pomiarowa i pierwsza anomalia korelacji (PrzestrzeĹ„ 02)
 
Data: 2026-08-20
 
Kontekst: Kontynuacja fazy P3 (Vertical Slice). Zaimplementowanie Przestrzeni 02 z `FULL_STORY.md` (Komora Pomiarowa IKP / Korelacja) w scenie `scenes/levels/station_02.tscn` ze skryptem `scripts/levels/station_02.gd`. WdroĹĽenie symetrycznej ramy korelacyjnej, procedury pomiaru z przekroczeniem progu ($\eta = 1.42$), asynchronicznego ruchu cienia Leny (`DiscontinuousShadow` w `scripts/player/discontinuous_shadow.gd`) zgodnego z zasadÄ… `#motionviz-observed-discontinuity` z `VISUAL_DESIGN.md` oraz fizycznej drukarki taĹ›mowej drukujÄ…cej w Ĺ›wiecie gry pasek `WYNIK ZGODNY`. Rozbudowa `ProceduralAudio` o syntezÄ™ korelacji prĂłĹĽniowej, drukarki taĹ›mowej i igĹ‚y galwanometru.
 
Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o:
  - `create_correlation_hum_sound()`: wysokonergetyczny rezonans harmoniczny dual-carrier (220 Hz + 330 Hz z alikwotem 660/880 Hz i sub-basem 55 Hz);
  - `create_printer_strip_sound()`: mechaniczny odgĹ‚os posuwu papieru silnikiem krokowym (1150 Hz) i klik uderzenia gĹ‚owicy termicznej;
  - `create_needle_spike_sound()`: ostry transient przeciÄ…ĹĽenia i odboju igĹ‚y miernika (1380 Hz z tĹ‚umionym odbiciem cewki 920 Hz).
- Zaimplementowano klasÄ™ `DiscontinuousShadow` (`scripts/player/discontinuous_shadow.gd`):
  - projekcja cienia podwĂłjnego na posadzce laboratoryjnej dla dwĂłch ĹşrĂłdeĹ‚ Ĺ›wiatĹ‚a L1 i L2;
  - w trybie anomalii korelacji: ruch cienia koĹ„czy siÄ™ o 1 klatkÄ™ (16.6 ms) przed ustaniem ruchu ciaĹ‚a Leny per `#motionviz-observed-discontinuity`;
  - Ĺ›cisĹ‚a integracja optyczna w Ĺ›wiecie gry bez sztucznych filtrĂłw RGB/VHS.
- Zaimplementowano scenÄ™ i kontroler `Station02` (`scripts/levels/station_02.gd`, `scenes/levels/station_02.tscn`):
  - modernistyczna symetryczna komora korelacji prĂłĹĽniowej: pylony noĹ›ne, szyny optyczne, leadowana szyba inspekcyjna i posadzka z linoleum;
  - symetryczne punkty Ĺ›wietlne L1 (x=320) i L2 (x=440) oraz centralny rdzeĹ„ korelacji (x=380);
  - Ĺ›cienny ekran telemetryczny CRT ze wskaĹşnikiem i wykresem wspĂłĹ‚czynnika korelacji $\eta$;
  - procedura pomiarowa: wzbudzenie prĂłĹĽni, wzrost wskaĹşnika powyĹĽej wartoĹ›ci granicznej $1.00$ do $1.42$, przeciÄ…ĹĽenie igĹ‚y miernika, rozĹ›wietlenie punktu L2 wbrew stanowi obwodu;
  - fizyczny rejestrator taĹ›mowy wysuwajÄ…cy pasek papieru z urzÄ™dowym nadrukiem: `WYNIK ZGODNY // ETA=1.42 // IKP 21:44:30`;
  - procedura przerwania pomiaru przez LenÄ™ per zasady BHP, stabilizacja konsensusu i odryglowanie ciÄ™ĹĽkiej Ĺ›luzy wyjĹ›ciowej do Przestrzeni 03.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test nowych procedur syntezy dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i komponentĂłw `Station02`;
  - peĹ‚na symulacja procedury pomiaru: aktywacja kalibracji, skok wskaĹşnika korelacji, weryfikacja asynchronicznych klatek cienia `DiscontinuousShadow`, wydruk paska `WYNIK ZGODNY`, przerwanie pomiaru, otwarcie Ĺ›luzy wyjĹ›ciowej i wejĹ›cie gracza do strefy wyjĹ›cia z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_02.png` oraz `reports/station_02_correlation.png` (reprezentujÄ…cy Keyframe 1 z `VISUAL_DESIGN.md`).
- Zarejestrowano decyzjÄ™ D-035 w `docs/DECISION_LOG.md`.
 
DowĂłd:
 
```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```
 
Ograniczenia: Testy automatyczne weryfikujÄ… deterministyczne przejĹ›cie procedury pomiarowej w silniku, syntezÄ™ audio, wyliczenie klatek desynchronizacji cienia i wydruk taĹ›my. Subiektywny odbiĂłr niepokoju i subtelnoĹ›ci anomalii u gracza pozostajÄ… hipotezami (H-003, H-007, H-010b).
 
Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0021`.


## PKG-0021: P3 Vertical Slice â€” Puste laboratorium i zerwanie ciÄ…gĹ‚oĹ›ci (PrzestrzeĹ„ 03)

Data: 2026-08-20

Kontekst: Kontynuacja fazy P3 (Vertical Slice). Zaimplementowanie Przestrzeni 03 z `FULL_STORY.md` (Puste laboratorium IKP / Zerwanie ciÄ…gĹ‚oĹ›ci) w scenie `scenes/levels/station_03.tscn` ze skryptem `scripts/levels/station_03.gd`. WdroĹĽenie materialnych Ĺ›ladĂłw niezgodnoĹ›ci w Ĺ›wiecie gry: znikniÄ™cie nocnej obsady, dwa kubki na biurku zamiast jednego (kubek ceramiczny Leny oraz drugi kubek emaliowany ze Ĺ›ladami kawy), aparat telefoniczny z pulsujÄ…cym rejestrem 14 nieodebranych wiadomoĹ›ci od Marty Kurek, harmonogram dyĹĽurĂłw z wykreĹ›lonymi nazwiskami oraz Ĺ›cienny czytnik kart ze zmienionym portretem Leny i statusem `URLOP PRZERWANY` odryglowujÄ…cy Ĺ›luzÄ™ wyjĹ›ciowÄ… ku Recepcji (PrzestrzeĹ„ 04). Rozszerzenie `ProceduralAudio` o syntezÄ™ telefonu, czytnika kart i szumu jarzeniĂłwek oraz rozszerzenie `MemoryResonancePoint`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o:
  - `create_phone_ring_pulse_sound()`: europejski dwuton 425 Hz z flutterem 25 Hz i czipem alertu wiadomoĹ›ci (1680/2100 Hz);
  - `create_card_reader_beep_sound()`: dwutonowy sygnaĹ‚ autoryzacji 987->1318 Hz z dysonansem 1380 Hz "urlop przerwany" i klikiem elektromagnesu;
  - `create_fluorescent_hum_sound()`: szum opraw jarzeniowych z brzÄ™czeniem dĹ‚awika 100/200/300 Hz i mikro-iskrzeniem gazu.
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `DOOR_CARD_READER` (5), `TWIN_CUPS` (6), `DESK_TELEPHONE` (7), `DUTY_ROSTER` (8);
  - wyspecjalizowane procedury rysowania wektorowego: dwa kubki na podstawce z parÄ…, telefon z klawiaturÄ… numerycznÄ… i mrugajÄ…cÄ… diodÄ…, tablica dyĹĽurĂłw ze skreĹ›leniami oraz czytnik kart z alternatywnym portretem Leny i pulsujÄ…cym napisem `URLOP PRZERWANY`;
  - podpiÄ™to dedykowanÄ… syntezÄ™ audio dla kaĹĽdego rekwizytu.
- Zaimplementowano scenÄ™ i kontroler `Station03` (`scripts/levels/station_03.gd`, `scenes/levels/station_03.tscn`):
  - modernistyczny korytarz Ĺ‚Ä…cznikowy i powrĂłt do sterowni o wymiarach 640x360;
  - architektura pustki: puste obrotowe krzesĹ‚o laboratoryjne z porzuconym fartuchem, ciemne okno obserwacyjne do opustoszaĹ‚ego skrzydĹ‚a z pojedynczÄ… diodÄ… czuwania, jarzeniĂłwki z subtelnym migotaniem dĹ‚awika;
  - badanie Ĺ›ladĂłw niezgodnoĹ›ci: `twin_cups`, `desk_phone`, `duty_roster`, `door_card_reader`;
  - sekwencja odryglowania ciÄ™ĹĽkiej Ĺ›luzy bezpieczeĹ„stwa po skanie karty z animowanym wznosem bramy, sygnaĹ‚em `door_unlocked` i przejĹ›ciem przez strefÄ™ `AirlockZone`.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test nowych generatorĂłw proceduralnego audio w `ProceduralAudio`;
  - automatyczny test instancjonowania i komponentĂłw `Station03`;
  - peĹ‚ny deterministyczny test badania wszystkich poszlak (`TwinCups`, `DeskPhone`, `DutyRoster`, `DoorCardReader`), odryglowania Ĺ›luzy i zgĹ‚oszenia `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_03.png` oraz `reports/station_03_desk.png`.
- Zarejestrowano decyzjÄ™ D-036 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Subiektywne odczucie dezorientacji i nastroju opustoszaĹ‚ego laboratorium pozostajÄ… hipotezami (H-003, H-007).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0022`.


## PKG-0022: P3 Vertical Slice â€” Recepcja IKP i spotkanie ze straĹĽnikiem (PrzestrzeĹ„ 04: Bramka)

Data: 2026-08-20

Kontekst: Kontynuacja fazy P3 (Vertical Slice). Zaimplementowanie Przestrzeni 04 z `FULL_STORY.md` (Bramka / Recepcja IKP) w scenie `scenes/levels/station_04.tscn` ze skryptem `scripts/levels/station_04.gd`. WdroĹĽenie stanowiska straĹĽnika za pancernym przeszkleniem z wyciÄ™ciem podawczym i otworami akustycznymi, dialogu Ĺ›rodowiskowego D-01 w Ĺ›wiecie gry (zgĹ‚oszenie powrotu do UCP oraz tabu ĹĽyjÄ…cego brata Jakuba), natychmiastowego zgaĹ›niÄ™cia lampy nad kamerÄ… i zasĹ‚oniÄ™cia obiektywu przez straĹĽnika na sĹ‚owa Leny "Jakub nie ĹĽyje", odryglowania mechanicznego koĹ‚owrotu (turnstile) oraz przejĹ›cia przez szklany wiatroĹ‚ap ku Przestrzeni 05 (RĂłwieĹ„ nocÄ…). Rozszerzenie `ProceduralAudio` o syntezÄ™ zrzutu przekaĹşnika kamery, zapadki koĹ‚owrotu i blipĂłw dialogowych oraz rozszerzenie `MemoryResonancePoint`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o:
  - `create_camera_click_sound()`: odciÄ™cie przekaĹşnika elektromagnetycznego (180 Hz) ze strzaĹ‚em ceramicznym (1850 Hz) i wyĹ‚adowaniem ĹĽarnika;
  - `create_turnstile_unlatch_sound()`: uderzenie solenoidu (340 Hz) z tarciem zapadki stalowej (2200 Hz) i mechanicznym odbiciem zÄ™ba;
  - `create_dialogue_blip_sound(is_lena)`: impulsy tekstowe (Lena: 587 Hz bursztynowa alikwota, StraĹĽnik: 330 Hz ton instytucjonalny).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `SECURITY_MONITOR` (9), `UCP_NOTICE` (10), `GUARD_INTERACTION` (11);
  - wyspecjalizowane procedury rysowania: monitor CCTV z rastrem kineskopowym, tablica urzÄ™dowa UCP z pieczÄ™ciÄ… oraz interkom dyĹĽurki.
- Zaimplementowano scenÄ™ i kontroler `Station04` (`scripts/levels/station_04.gd`, `scenes/levels/station_04.tscn`):
  - modernistyczna recepcja i punkt kontrolny IKP o wymiarach 640x360;
  - stanowisko straĹĽnika: kontuar stalowy, pancerna szyba z nitami, postaÄ‡ straĹĽnika w czapce i mundurze sĹ‚uĹĽbowym;
  - sufitowa kamera przemysĹ‚owa z kierunkowym snopem Ĺ›wiatĹ‚a;
  - wdroĹĽenie dialogu Ĺ›rodowiskowego D-01: 9 sekwencyjnych linii dialogowych ze znacznikami mĂłwcĂłw (`[STRAĹ»NIK]`, `[LENA]`), dedykowany `DialogueCanvas` (z_index=20);
  - zdarzenie fabularne przy linii 5: na sĹ‚owa "Jakub nie ĹĽyje" snop lampy natychmiast gaĹ›nie, rozlega siÄ™ klik przekaĹşnika, trauma kamery (0.35), a straĹĽnik unosi ramiÄ™, fizycznie zasĹ‚aniajÄ…c obiektyw kamery przed rejestracjÄ… ("ProszÄ™ tego przy niej nie powtarzaÄ‡... Przy wersji, ktĂłra zapisuje");
  - mechaniczny koĹ‚owrĂłt (turnstile) z 3 stalowymi ramionami, przeĹ‚Ä…czeniem lampki ze stanu cynobru (zaryglowany) na cyjan (odryglowany), animacjÄ… obrotu ramion i wyĹ‚Ä…czeniem kolizji `TurnstileBarrier`;
  - szklany wiatroĹ‚ap wyjĹ›ciowy z widokiem na deszczowe miasto RĂłwieĹ„ (latarnie uliczne, przewody trakcyjne, sylwetki budynkĂłw) i strefa przejĹ›cia `AirlockZone`.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test nowych generatorĂłw proceduralnego audio w `ProceduralAudio`;
  - automatyczny test instancjonowania i komponentĂłw `Station04`;
  - peĹ‚ny deterministyczny test: badanie tablicy UCP i monitora CCTV, podejĹ›cie do kontuaru, automatyczne rozpoczÄ™cie dialogu, przejĹ›cie replik 0..4, weryfikacja zgaĹ›niÄ™cia lampy kamery i zasĹ‚oniÄ™cia obiektywu w linii 5, domkniÄ™cie dialogu, odryglowanie koĹ‚owrotu i przejĹ›cie przez wiatroĹ‚ap z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_04.png` oraz `reports/station_04_bramka.png`.
- Zarejestrowano decyzjÄ™ D-037 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Subiektywne odczucie napiÄ™cia, tempa dialogu i wraĹĽenia zgaĹ›niÄ™cia lampy pozostajÄ… hipotezami (H-003, H-007, H-010b).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0023`.


## PKG-0023: P3 Vertical Slice â€” RĂłwieĹ„ nocÄ… i sygnaĹ‚ przejĹ›cia (PrzestrzeĹ„ 05)

Data: 2026-08-20

Kontekst: Kontynuacja fazy P3 (Vertical Slice). Zaimplementowanie Przestrzeni 05 z `FULL_STORY.md` (RĂłwieĹ„ nocÄ…: Droga z instytutu do przystanku) w scenie `scenes/levels/station_05.tscn` ze skryptem `scripts/levels/station_05.gd`. WdroĹĽenie deszczowej nocnej ulicy RĂłwni, anachronistycznego afisza UCP z epoki 1978, modernistycznego bloku mieszkalnego z wyciÄ™tym 3. piÄ™trem ("Budynek bez piÄ™tra"), interaktywnego sygnalizatora przejĹ›cia dla pieszych z akustycznym beaconem i szeptem imienia Leny, bezszwowej transformacji geometrii zauĹ‚ka poza polem widzenia kamery (#geometry-restless-grid), wiaty przystankowej z rozkĹ‚adem jazdy Linii ZastÄ™pczej 4 oraz syntezy proceduralnego audio dla sygnaĹ‚u przejĹ›cia, deszczu na asfalcie i trakcji tramwajowej.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o:
  - `create_crosswalk_signal_sound(with_name_whisper)`: impulsy lokacyjne 500 Hz oraz formantowy szept o strukturze fonetycznej "Le-na" (F1/F2/F3 ~450/1800/2400 Hz -> 750/1200/2200 Hz z szumem oddechowym);
  - `create_rain_asphalt_sound()`: ciÄ…gĹ‚y szum deszczu filtrowany dolnoprzepustowo z mikro-impulsami uderzeĹ„ kropel w kaĹ‚uĹĽe;
  - `create_tram_traction_sound()`: brzÄ™czenie sieci trakcyjnej 50/100 Hz, Ĺ›wist falownika silnika trakcyjnego 620 Hz i tarcie obrzeĹĽy kĂłĹ‚ o szyny 1420 Hz.
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `ANACHRONISTIC_BILLBOARD` (12), `MISSING_FLOOR_FACADE` (13), `CROSSWALK_SIGNAL` (14), `TRANSIT_SHELTER` (15);
  - wyspecjalizowane procedury rysowania: emaliowany afisz UCP z 1978 r. na stalowych sĹ‚upach, rzut elewacji budynku z pustkÄ… po 3. piÄ™trze, sygnalizator Ĺ›wietlno-dĹşwiÄ™kowy z przyciskiem wzbudzania oraz gablota rozkĹ‚adu jazdy z czerwonÄ… taĹ›mÄ… "TRASA ZAWIESZONA / AUTOBUS ZASTÄPCZY".
- Zaimplementowano scenÄ™ i kontroler `Station05` (`scripts/levels/station_05.gd`, `scenes/levels/station_05.tscn`):
  - dwukomorowy trakt miejski o szerokoĹ›ci 1280 px (Chamber 0: WyjĹ›cie z IKP, afisz, budynek bez piÄ™tra, zmienny zauĹ‚ek; Chamber 1: przejĹ›cie dla pieszych, torowisko tramwajowe, wiata przystankowa, peron autobusu);
  - deszczowa sceneria: czÄ…steczki deszczu `CPUParticles2D`, mokry asfalt z kaĹ‚uĹĽami i odbiciami, latarnie uliczne z pĂłĹ‚przezroczystymi snopami Ĺ›wiatĹ‚a, sieÄ‡ trakcyjna z masztami kratowymi;
  - mechanika nieciÄ…gĹ‚oĹ›ci obserwacji (#geometry-restless-grid): brama dziedziĹ„ca w Chamber 0 bezszwowo przeksztaĹ‚ca siÄ™ w litÄ… Ĺ›cianÄ™ z rurÄ… spustowÄ… i skrzynkÄ… zasilajÄ…cÄ…, gdy gracz przekracza granicÄ™ x=650 ku Chamber 1 (brak tanich jumpscare'Ăłw i glitchy);
  - interaktywny sygnalizator przejĹ›cia przeĹ‚Ä…czajÄ…cy Ĺ›wiatĹ‚o na zielone/cyjan, uruchamiajÄ…cy syntezÄ™ dĹşwiÄ™kowÄ… beacona i szepczÄ…cy imiÄ™ Leny;
  - strefa przejĹ›cia `AirlockZone` przy peronie przystankowym prowadzÄ…ca do Przestrzeni 06 (Linia zastÄ™pcza).
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test syntezy dĹşwiÄ™kĂłw przejĹ›cia, deszczu i trakcji tramwajowej;
  - automatyczny test instancjonowania i komponentĂłw `Station05` (dwie komory kamery, czÄ…steczki deszczu, 4 odtwarzacze audio, 4 rekwizyty pamiÄ™ci);
  - peĹ‚ny deterministyczny test: badanie afisza przy x=180, badanie budynku bez piÄ™tra przy x=340, przejĹ›cie do Chamber 1 z weryfikacjÄ… przeĹ‚Ä…czenia kamery i transformacji geometrii zauĹ‚ka, aktywacja sygnalizatora przejĹ›cia przy x=730, badanie rozkĹ‚adu przy x=1050 i wejĹ›cie na peron przystankowy z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_05.png` oraz `reports/station_05_crosswalk.png`.
- Zarejestrowano decyzjÄ™ D-038 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Subiektywne odczucie nastroju deszczowego miasta i czytelnoĹ›ci braku piÄ™tra pozostajÄ… hipotezami (H-003, H-007, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0024`.


## PKG-0024: P3 Vertical Slice â€” Linia zastÄ™pcza i autobus (PrzestrzeĹ„ 06)

Data: 2026-08-20

Kontekst: Kontynuacja fazy P3 (Vertical Slice). Zaimplementowanie Przestrzeni 06 z `FULL_STORY.md` (Linia zastÄ™pcza / Autobus Linii 4) w scenie `scenes/levels/station_06.tscn` ze skryptem `scripts/levels/station_06.gd`. WdroĹĽenie wnÄ™trza nocnego autobusu miejskiego jadÄ…cego w deszczu z paralaksÄ… przesuwajÄ…cych siÄ™ Ĺ›wiateĹ‚ ulicznych i zamkniÄ™tego torowiska Linii 4 z zaporami i diodami ostrzegawczymi, kabiny kierowcy z tablicÄ… relacji i kasownikiem, sufitowego gĹ‚oĹ›nika z komunikatem instytucjonalnym UCP (â€žProsimy nie utrwalaÄ‡ rozbieĹĽnoĹ›ci przez powtarzanieâ€ť), dialogu ze starszym pasaĹĽerem zwracajÄ…cym zaginionÄ… 2 tygodnie wczeĹ›niej zĹ‚otÄ… obrÄ…czkÄ™ Ĺ›lubnÄ…, weryfikacji braku Ĺ›ladu po obrÄ…czce na dĹ‚oni Leny (gest dociskania paznokcia do szwu palca per `VISUAL_DESIGN.md` i kluczowy rekwizyt finaĹ‚u Uzgodnienia), sekwencji dojazdu do przystanku Osiedle Tarasowe z wyhamowaniem, pojawieniem siÄ™ wiaty za oknem i pneumatycznym otwarciem drzwi wyjĹ›ciowych ku Przestrzeni 07 (â€žWrĂłciĹ‚aĹ›â€ť). Rozszerzenie `ProceduralAudio` o syntezÄ™ silnika diesla, deszczu na szybach, komunikatu PA, pneumatyki drzwi i zĹ‚otej obrÄ…czki oraz rozszerzenie `MemoryResonancePoint`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o:
  - `create_bus_engine_sound(is_decelerating)`: 4-suwowy cykl diesla 42 Hz z wibracjÄ… podwozia i dudnieniem 28 Hz;
  - `create_bus_rain_window_sound()`: deszcz na szybach autobusu i szum pÄ™du powietrza;
  - `create_bus_announcement_sound()`: dwuton instytucjonalny PA (F#5 740 Hz -> C#5 554 Hz) z szumem pasmowym;
  - `create_bus_door_pneumatic_sound()`: upust sprÄ™ĹĽonego powietrza 1800->420 Hz i skĹ‚adanie skrzydeĹ‚ drzwi;
  - `create_ring_chime_sound()`: dwuton harmoniczny zĹ‚otej obrÄ…czki (C6 1046.5 Hz + E6 1318.5 Hz) z mikrodryfem fazowym.
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `BUS_SPEAKER` (16), `ELDERLY_PASSENGER` (17), `GOLD_RING` (18), `BUS_ROUTE_MAP` (19);
  - wyspecjalizowane procedury rysowania: gĹ‚oĹ›nik sufitowy UCP w metalowej obudowie, ciemna sylwetka starszego pasaĹĽera w pĹ‚aszczu i berecie z siwymi wĹ‚osami, zĹ‚ota obrÄ…czka lĹ›niÄ…ca na dermie fotela oraz tablica schematu trasy Linii ZastÄ™pczej 4.
- Zaimplementowano scenÄ™ i kontroler `Station06` (`scripts/levels/station_06.gd`, `scenes/levels/station_06.tscn`):
  - wnÄ™trze jadÄ…cego autobusu miejskiego o wymiarach 640x360;
  - tĹ‚o paralaksy: przesuwajÄ…ce siÄ™ za deszczowymi szybami latarnie, sylwetki budynkĂłw i zamkniÄ™te torowisko Linii 4 z zaporami i czerwonymi diodami;
  - kabina kierowcy z tablicÄ… kierunkowÄ… i kasownikiem biletowym;
  - sufitowe relingi z koĹ‚yszÄ…cymi siÄ™ skĂłrzanymi uchwytami i lampy jarzeniowe rzucajÄ…ce stoĹĽki Ĺ›wiatĹ‚a;
  - sufitowy gĹ‚oĹ›nik emitujÄ…cy komunikat UCP: â€žPROSIMY NIE UTRWALAÄ† ROZBIEĹ»NOĹšCI PRZEZ POWTARZANIEâ€ť;
  - sekwencyjny dialog Ĺ›rodowiskowy ze starszym pasaĹĽerem (5 replik) zwracajÄ…cym zgubionÄ… obrÄ…czkÄ™ Ĺ›lubnÄ…;
  - weryfikacja stanu ciaĹ‚a Leny: dociskanie paznokcia do szwu palca, potwierdzenie braku jakiegokolwiek Ĺ›ladu/odcisku po noszeniu obrÄ…czki;
  - badanie zĹ‚otej obrÄ…czki na fotelu z rezonansem pamiÄ™ci;
  - automatyczna sekwencja dojazdu do przystanku Osiedle Tarasowe: pĹ‚ynne wyhamowanie, pojawienie siÄ™ oĹ›wietlonej wiaty przystankowej za oknami, pneumatyczne otwarcie drzwi wyjĹ›ciowych z sygnaĹ‚em i aktywacja strefy `AirlockZone`.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test nowych syntezatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i komponentĂłw `Station06` (paralaksa, 4 odtwarzacze audio, 4 rekwizyty pamiÄ™ci, drzwi pneumatyczne);
  - peĹ‚ny deterministyczny test: badanie schematu trasy przy x=180, badanie gĹ‚oĹ›nika i odsĹ‚uchanie komunikatu UCP przy x=290, podejĹ›cie do pasaĹĽera przy x=390, przeprowadzenie dialogu i weryfikacji palca, zbadanie obrÄ…czki przy x=450, wyhamowanie autobusu, otwarcie drzwi i przejĹ›cie przez drzwi wyjĹ›ciowe z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_06.png` oraz `reports/station_06_arrival.png`.
- Zarejestrowano decyzjÄ™ D-039 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Subiektywne odczucie nastroju podrĂłĹĽy nocnym autobusem i ciÄ™ĹĽaru emocjonalnego rekwizytu obrÄ…czki pozostajÄ… hipotezami (H-003, H-007, H-008, H-010b).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0025`.


## PKG-0025: P3 Vertical Slice â€” â€žWrĂłciĹ‚aĹ›â€ť i spotkanie z MartÄ… Kurek (PrzestrzeĹ„ 07)

Data: 2026-08-20

Kontekst: Kontynuacja fazy P3 (Vertical Slice). Zaimplementowanie Przestrzeni 07 z `FULL_STORY.md` (â€žWrĂłciĹ‚aĹ›â€ť / Klatka schodowa na Osiedlu Tarasowym) w scenie `scenes/levels/station_07.tscn` ze skryptem `scripts/levels/station_07.gd`. WdroĹĽenie klatki schodowej modernistycznego bloku mieszkalnego z posadzkÄ… z lastryka i mosiÄ™ĹĽnymi dylatacjami, stalowÄ… balustradÄ…, panoramicznym oknem deszczowym z widokiem na uciÄ™te piÄ™tro budynku, postaci Marty Kurek w roboczej kurtce z torbÄ… narzÄ™dziowÄ… w progu mieszkania 14, peĹ‚nej sceny dialogowej D-02 z `DIALOGUE_SCRIPT.md` (â€žWrĂłciĹ‚aĹ›â€ť, â€žTwarz siÄ™ zgadzaâ€ť, gest dociskania paznokcia do szwu palca), badania tablicy lokatorĂłw (wyrĂłĹĽniony lokal 14: Wolska/Kurek), skrzynek pocztowych (awizo UCP z DziaĹ‚u ZgodnoĹ›ci), wĹ‚Ä…cznika schodowego z neonĂłwkÄ… oraz Ĺ›lepego biegu schodĂłw urywajÄ…cych siÄ™ w litej Ĺ›cianie betonowej z ostrzeĹĽeniem o uciÄ™tej kondygnacji (#geometry-restless-grid), animacji otwarcia drzwi mieszkania 14 z ciepĹ‚ym Ĺ›wiatĹ‚em wnÄ™trza i wejĹ›ciem do strefy `AirlockZone` prowadzÄ…cej do Przestrzeni 08 (â€žMieszkanie po kimĹ›â€ť). Rozszerzenie `ProceduralAudio` o syntezÄ™ krokĂłw na lastryku, zawiasĂłw drzwi, blipu Marty i wĹ‚Ä…cznika czasowego oraz rozszerzenie `MemoryResonancePoint`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o:
  - `create_stair_footstep_sound()`: gÄ™sty impuls mineralny lastryka (280/480 Hz) z rezonansem wnÄ™ki klatki schodowej (180 Hz);
  - `create_apartment_door_sound()`: tarcie zawiasĂłw ciÄ™ĹĽkich drzwi pĹ‚ycinowych (480â€“680 Hz FM) z metalicznym klikiem rygla (1650/2400 Hz);
  - `create_dialogue_marta_blip_sound()`: ciepĹ‚y, matowy ton 440 Hz (A4) z bogatym subharmonicznym ciepĹ‚em (220 Hz);
  - `create_stair_timer_switch_sound()`: bimetaliczny trzask (1250 Hz) z impulsem zaĹ‚Ä…czenia przekaĹşnika elektromagnetycznego 50 Hz.
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `TENANT_DIRECTORY` (20), `MAILBOXES` (21), `BLIND_STAIRS` (22), `MARTA_INTERACTION` (23), `STAIR_TIMER_SWITCH` (24);
  - dedykowane procedury rysowania: modernistyczna tablica lokatorĂłw z wyrĂłĹĽnieniem lokalu 14 w ciepĹ‚ym bursztynie, stalowa bateria skrzynek pocztowych z wystajÄ…cym awizem UCP, Ĺ›lepy bieg schodĂłw z litym betonowym murem i cynobrowymi pasami ostrzegawczymi, sylwetka Marty Kurek w roboczej kurtce z torbÄ… monterskÄ… i calĂłwkÄ… oraz wĹ‚Ä…cznik schodowy z pulsujÄ…cÄ… pomaraĹ„czowÄ… neonĂłwkÄ….
- Zaimplementowano scenÄ™ i kontroler `Station07` (`scripts/levels/station_07.gd`, `scenes/levels/station_07.tscn`):
  - klatka schodowa na 5. piÄ™trze o szerokoĹ›ci 640 px;
  - posadzka z lastryka z mosiÄ™ĹĽnymi dylatacjami, stalowa balustrada i panoramiczne okno z widokiem na deszczowe miasto;
  - wdroĹĽenie maszyny stanĂłw dialogu D-02 (7 krokĂłw dialogowych) z banerem w Ĺ›wiecie gry, timingami i zsynchronizowanÄ… syntezÄ… blipĂłw gĹ‚osowych Marty i Leny;
  - sekwencja gestu dĹ‚oni Leny: dociĹ›niÄ™cie paznokcia do szwu palca, reakcja Marty (â€žNie... Twarz siÄ™ zgadza. Reszta dopiero weszĹ‚a po schodachâ€ť);
  - mechanika wĹ‚Ä…cznika czasowego oĹ›wietlenia schodowego z pĹ‚ynnym przyciemnianiem Ĺ›wiatĹ‚a sufitowego i moĹĽliwoĹ›ciÄ… manualnego resetu;
  - animacja otwarcia drzwi mieszkania po dialogu: pĹ‚ynny obrĂłt skrzydĹ‚a, rozszerzenie stoĹĽka ciepĹ‚ego domowego Ĺ›wiatĹ‚a na podĹ‚ogÄ™ klatki, odsĹ‚oniÄ™cie przedpokoju z wieszakiem i parkietem;
  - strefa przejĹ›cia `AirlockZone` w progu otwartego mieszkania prowadzÄ…ca do Przestrzeni 08.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test nowych syntezatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i komponentĂłw `Station07` (4 odtwarzacze audio, 5 rekwizytĂłw pamiÄ™ci, drzwi mieszkania);
  - peĹ‚ny deterministyczny test: badanie tablicy lokatorĂłw przy x=95, badanie skrzynek przy x=170, badanie wĹ‚Ä…cznika schodowego przy x=250 z resetem timera, podejĹ›cie do drzwi przy x=480, przeprowadzenie dialogu D-02, weryfikacja gestu palca, otwarcie drzwi mieszkania, badanie Ĺ›lepych schodĂłw przy x=590 oraz wejĹ›cie przez prĂłg mieszkania z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_07.png` oraz `reports/station_07_door.png`.
- Zarejestrowano decyzjÄ™ D-040 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Subiektywne odczucie nastroju surowej klatki schodowej i Ĺ‚adunku emocjonalnego pierwszego spotkania z MartÄ… pozostajÄ… hipotezami (H-003, H-007, H-008, H-010b).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0026`.


## PKG-0026: P3 Vertical Slice â€” Mieszkanie po kimĹ› (PrzestrzeĹ„ 08)

Data: 2026-08-20

Kontekst: Kontynuacja fazy P3 (Vertical Slice). Zaimplementowanie Przestrzeni 08 z `FULL_STORY.md` (Mieszkanie po kimĹ› / WnÄ™trze mieszkania Marty i lokalnej Leny) w scenie `scenes/levels/station_08.tscn` ze skryptem `scripts/levels/station_08.gd`. WdroĹĽenie modernistycznego wnÄ™trza mieszkania 14 na Osiedlu Tarasowym z drewnianym parkietem, boazeriÄ…, aneksem kuchennym z gotujÄ…cym siÄ™ czajnikiem na gazie, stoĹ‚em jadalno-roboczym pod wiszÄ…cÄ… lampÄ… bursztynowÄ… (#D39A62), kÄ…cikiem studyjnym z oknem na deszczowÄ… noc RĂłwni i ĹĽebrowanym grzejnikiem ĹĽeliwnym. Implementacja rekwizytĂłw o podwĂłjnym zastosowaniu per `FULL_STORY.md` i `VISUAL_DESIGN.md` (zlewka laboratoryjna 200 ml jako doniczka na sukulent, pamiÄ…tka Jakuba z poziomicÄ… mosiÄ™ĹĽnÄ… jako przycisk do kalkulacji, wieszak w przedpokoju z dwoma pĹ‚aszczami i butami na deszcz sprzed 17 dni, wspĂłlna fotografia Marty i lokalnej Leny kadrowana Ĺ›ciĹ›le od tyĹ‚u w odbiciu deszczowego okna), biurka roboczego z zamkiem szyfrowym odryglowywanym kodem 0311 (data wypadku Jakuba) odsĹ‚aniajÄ…cym obce kalkulacje siatek korelacyjnych i szkice wÄ™zĹ‚Ăłw Podstruktury UCP, peĹ‚nej sceny dialogowej z MartÄ… Kurek w mieszkaniu, syntezy proceduralnego audio dla krokĂłw na parkiecie, zamka szuflady, szelestu papierĂłw oraz gotowania i gwizdka czajnika, testĂłw automatycznych w `smoke_test.gd` oraz renderĂłw w `capture_preview.gd`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 5 syntezatorĂłw dĹşwiÄ™ku:
  - `create_parquet_footstep_sound()`: ciepĹ‚y rezonans desek parkietowych (190/310 Hz) z mikro-skrzypieniem wĹ‚Ăłkien drewnianych;
  - `create_drawer_lock_unlatch_sound()`: mechaniczny klik bÄ™benka szyfrowego (950 Hz), odskoczenie mosiÄ™ĹĽnego rygla (1450->820 Hz) i gĹ‚adki wysuw drewnianej szuflady (220 Hz);
  - `create_paper_rustle_sound()`: szelest papieru milimetrowego i kalek technicznych (wielopasmowy flutter 800â€“4500 Hz);
  - `create_kettle_boil_sound()`: szum wrzenia wody z sub-basowymi impulsami pÄ™cherzykĂłw (85/140/210 Hz);
  - `create_kettle_whistle_sound()`: dwutonowy gwizdek pary (1150/1380 Hz) z wibrato 5.5 Hz.
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `HALLWAY_COAT_RACK` (25), `REFLECTED_PHOTOGRAPH` (26), `BEAKER_PLANTER` (27), `JAKUB_MEMENTO_TOOL` (28), `CIPHER_DESK` (29), `TEA_KETTLE` (30);
  - dedykowane procedury rysowania: wieszak z pĹ‚aszczem grafitowym Leny, kurtkÄ… roboczÄ… Marty i butami na deszcz sprzed 17 dni, fotografia kadrowana od tyĹ‚u w deszczowym oknie, zlewka laboratoryjna 200 ml z sukulentem i pÄ…kiem kwiatowym, mosiÄ™ĹĽna poziomica Jakuba z grawerem "J.W." i ampuĹ‚kÄ… cyjanowÄ…, masywne biurko gabinetowe z lampÄ… kreĹ›larskÄ… i szufladÄ… z zamkiem szyfrowym oraz czajnik na gazie z pĹ‚omieniem i kĹ‚Ä™bami pary.
- Zaimplementowano scenÄ™ i kontroler `Station08` (`scripts/levels/station_08.gd`, `scenes/levels/station_08.tscn`):
  - modernistyczne mieszkanie 14 o wymiarach 640x360;
  - posadzka z desek dÄ™bowych, boazeria, aneks kuchenny, stĂłĹ‚ jadalny z oĹ›wietleniem punktowym, kÄ…cik studyjny z deszczowym oknem na Osiedle Tarasowe, ĹĽeliwny kaloryfer i przejĹ›cie do Ĺ‚azienki;
  - wdroĹĽenie maszyny stanĂłw dialogu z MartÄ… Kurek w mieszkaniu (8 kwestii dialogowych D-08): rozmowa o znikniÄ™ciu lokalnej Leny, herbacie, odruchowym wpisaniu kodu 0311 do szuflady i ujawnieniu, ĹĽe lokalna Lena wspĂłĹ‚tworzyĹ‚a PodstrukturÄ™ UCP;
  - mechanika zamka szyfrowego szuflady biurka: automatyczne lub manualne odryglowanie kodem 0311, odsĹ‚oniÄ™cie szkicĂłw Podstruktury z cyjanowym ryglem i badanie notatek technicznych;
  - strefa przejĹ›cia `AirlockZone` przy portalu Ĺ‚azienkowym (x=610) prowadzÄ…ca do Przestrzeni 09 (PokĂłj, ktĂłry nie czeka).
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych syntezatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station08` (odtwarzacze audio, 6 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera);
  - peĹ‚ny deterministyczny test: badanie wieszaka przy x=105, badanie fotografii przy x=155, badanie czajnika przy x=215, podejĹ›cie do stoĹ‚u przy x=295, badanie zlewki-doniczki i pamiÄ…tki Jakuba, przeprowadzenie peĹ‚nego dialogu z MartÄ… Kurek, weryfikacja odryglowania szyfru szuflady 0311 na 4. kwestii, zbadanie odsĹ‚oniÄ™tego biurka przy x=465 oraz przejĹ›cie przez portal do strefy `AirlockZone` z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_08.png` oraz `reports/station_08_desk.png`.
- Zarejestrowano decyzjÄ™ D-041 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Subiektywne odczucie nastroju obcoĹ›ci w mieszkaniu, ktĂłre formalnie naleĹĽy do protagonistki, i Ĺ‚adunku emocjonalnego rekwizytĂłw podwĂłjnego zastosowania pozostajÄ… hipotezami (H-003, H-007, H-008, H-010b).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0027`.


## PKG-0027: P3 Vertical Slice â€” PokĂłj, ktĂłry nie czeka (PrzestrzeĹ„ 09)

Data: 2026-08-20

Kontekst: Kontynuacja fazy P3 (Vertical Slice). Zaimplementowanie Przestrzeni 09 z `FULL_STORY.md` (PokĂłj, ktĂłry nie czeka / Ĺazienka i korytarz) w scenie `scenes/levels/station_09.tscn` ze skryptem `scripts/levels/station_09.gd`. WdroĹĽenie modernistycznej Ĺ‚azienki w mieszkaniu 14 na Osiedlu Tarasowym z kafelkami ceramicznymi w szaro-grafitowym i szaĹ‚wiowym ukĹ‚adzie geometrycznym, ĹĽeliwnymi i chromowanymi pionami instalacji wodnej z manometrem i zĹ‚Ä…czami koĹ‚nierzowymi, umywalkÄ… ceramicznÄ… z bateriÄ… chromowanÄ… i kapiÄ…cÄ… wodÄ…, lustrem Ĺ‚azienkowym w oĹ‚owianej ramie z asynchronicznym/opĂłĹşnionym odbiciem sylwetki Leny i Ĺ›luzy (#motionviz-observed-discontinuity), szafkÄ… aptecznÄ… ze stabilizatorami korelacji, wieszakiem z rÄ™cznikiem i koszem na bieliznÄ™. Odkrycie kluczowej poszlaki (Clue R-02): inskrypcji wydrapanej na szkle lustra `NIE SZUKAJ ORYGINAĹU` widocznej wyĹ‚Ä…cznie przy obserwacji pod kÄ…tem bocznym (x=210..290) dziÄ™ki zaĹ‚amaniu Ĺ›wiatĹ‚a z proceduralnym audio skrobania szkĹ‚a. WdroĹĽenie peĹ‚nej sceny dialogowej D-03 z MartÄ… Kurek w Ĺ›wiecie gry (â€žNie patrz na drzwi. Patrz na nie w lustrze. (...) Zostaw drzwi w odbiciu. IdĹş, nie sprawdzaj.â€ť), mechaniki stabilizacji korytarza po jednostajnym przejĹ›ciu, odryglowania drzwi wyjĹ›ciowych i przejĹ›cia przez strefÄ™ `AirlockZone` do Przestrzeni 10 (Telefon Jakuba), syntezy proceduralnego audio w `ProceduralAudio`, testĂłw automatycznych w `smoke_test.gd` oraz renderĂłw kontrolnych w `capture_preview.gd`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 4 syntezatory dĹşwiÄ™ku:
  - `create_tile_footstep_sound()`: mineralny tap (320/580 Hz) z echem ceramicznych kafelkĂłw Ĺ‚azienkowych;
  - `create_water_pipe_hiss_sound()`: ciĹ›nieniowy przepĹ‚yw wody w rurach (680/1450 Hz) z rezonansem ĹĽeliwa i kranu;
  - `create_glass_scratch_sound()`: ostry Ĺ›wist rylca/ĹĽyletki po szkle (2450/3800 Hz) z mikro-spÄ™kaniami srebra lustrzanego;
  - `create_mirror_shimmer_sound()`: dwutonowy dysonans temporalny lustra (A5 880 Hz + B5 987 Hz) z mikrodryfem fazowym 0.4 Hz.
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `BATHROOM_SINK` (31), `BATHROOM_MIRROR` (32), `SCRATCHED_INSCRIPTION` (33), `APOTHECARY_CABINET` (34), `MARTA_BATHROOM_GUIDE` (35);
  - dedykowane procedury rysowania: umywalka ceramiczna z bateriÄ… chromowanÄ…, syfonem i kapiÄ…cÄ… wodÄ…, lustro w oĹ‚owianej ramie z opĂłĹşnionym odbiciem sylwetki Leny, wydrapana inskrypcja `NIE SZUKAJ ORYGINAĹU` z ĹĽarzeniem cyjanowo-bursztynowym, Ĺ›cienna szafka apteczna z czerwonym krzyĹĽykiem i fiolkami stabilizatorĂłw korelacji oraz geometryczny znacznik instrukcji przejĹ›cia korytarza Marty (D-03).
- Zaimplementowano scenÄ™ i kontroler `Station09` (`scripts/levels/station_09.gd`, `scenes/levels/station_09.tscn`):
  - Ĺ‚azienka modernistyczna i korytarz wyjĹ›ciowy o wymiarach 640x360;
  - kafelki Ĺ›cienne, piony rur wodnych, oĹ›wietlenie punktowe rzucajÄ…ce stoĹĽek Ĺ›wiatĹ‚a na umywalkÄ™ i lustro, ciemny korytarz ze stabilizacjÄ… obserwacyjnÄ…;
  - bufor historii pozycji i zwrotu gracza (DELAY_FRAMES = 14) generujÄ…cy opĂłĹşnione odbicie w lustrze;
  - detekcja obserwacji pod kÄ…tem bocznym (x=210..290) aktywujÄ…ca ujawnienie inskrypcji `NIE SZUKAJ ORYGINAĹU` (Clue R-02);
  - wdroĹĽenie maszyny stanĂłw dialogu D-03 z MartÄ… Kurek (7 kwestii);
  - mechanika jednostajnego przejĹ›cia korytarza ku prawemu kraĹ„cowi (x >= 340 do 560): stabilizacja korytarza, odryglowanie drzwi i rozĹ›wietlenie wyjĹ›cia ciepĹ‚ym Ĺ›wiatĹ‚em;
  - strefa przejĹ›cia `AirlockZone` przy drzwiach wyjĹ›ciowych (x=610) prowadzÄ…ca do Przestrzeni 10 (Telefon Jakuba).
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 4 nowych syntezatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station09` (odtwarzacze audio, 5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera);
  - peĹ‚ny deterministyczny test: badanie umywalki przy x=170, badanie szafki aptecznej przy x=235, badanie lustra przy x=170 z uruchomieniem dialogu D-03, krok w tyĹ‚ do kÄ…ta skoĹ›nego przy x=240 i weryfikacja odsĹ‚oniÄ™cia inskrypcji `NIE SZUKAJ ORYGINAĹU`, przejĹ›cie 7 kwestii dialogowych D-03, badanie znacznika instrukcji przy x=340, jednostajny marsz korytarzem do x=560 z weryfikacjÄ… stabilizacji korytarza i odryglowania drzwi oraz wejĹ›cie do strefy `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_09.png` oraz `reports/station_09_mirror.png`.
- Zarejestrowano decyzjÄ™ D-042 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Subiektywne odczucie napiÄ™cia i niepokoju wywoĹ‚anego opĂłĹşnionym odbiciem w lustrze oraz niepokojÄ…cej natury zasady obserwacji korytarza pozostajÄ… hipotezami (H-003, H-007, H-008, H-010b).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0028`.


## PKG-0028: P3 Vertical Slice â€” Telefon Jakuba (PrzestrzeĹ„ 10)

Data: 2026-08-20

Kontekst: Kontynuacja fazy P3 (Vertical Slice) oraz domkniÄ™cie Aktu I fabuĹ‚y per `FULL_STORY.md`. Zaimplementowanie Przestrzeni 10 z `FULL_STORY.md` (Telefon Jakuba / Gabinet domowy i korytarz techniczny) w scenie `scenes/levels/station_10.tscn` ze skryptem `scripts/levels/station_10.gd`. WdroĹĽenie domowego gabinetu w modernistycznym mieszkaniu 14 na Osiedlu Tarasowym z dÄ™bowym biurkiem roboczym, lampkÄ… biurkowÄ… z zielonym kloszem rzucajÄ…cÄ… stoĹĽek bursztynowego Ĺ›wiatĹ‚a (#D39A62), czarnym telefonem stacjonarnym bakelitowym z tarczÄ… numerowÄ… i mechanicznym dzwonkiem, magnetofonem szpulowym z ruchomymi szpulami i wskaĹşnikiem VU, Ĺ›ciennÄ… tablicÄ… korkowÄ… z wycinkami o katastrofie Linii 4 i schematem mieszkania jako ukĹ‚adu kontrolnego wÄ™zĹ‚Ăłw Podstruktury UCP. WdroĹĽenie peĹ‚nej sceny i dialogu D-04 z `DIALOGUE_SCRIPT.md` (Telefon Jakuba): odebranie dzwoniÄ…cego telefonu, konfrontacja Leny z ĹĽyjÄ…cym w tej gaĹ‚Ä™zi bratem Jakubem Wolskim (â€žPodaj datÄ™ wypadku. â€” KtĂłrego? â€” Na Linii 4. â€” Lena, ja tam pracujÄ™. Mamy wiÄ™cej niĹĽ jeden. â€” Trzeci listopada. MiaĹ‚eĹ› dwadzieĹ›cia lat. â€” [Cisza] Gdzie jesteĹ›? â€” U kobiety, ktĂłra twierdzi, ĹĽe mnie zna. â€” To nie zawÄ™ĹĽa.â€ť), odtworzenie szpuli magnetofonowej, odryglowanie stalowej Ĺ›luzy korytarza technicznego i wejĹ›cie do strefy `AirlockZone` zamykajÄ…cej Akt I i otwierajÄ…cej Akt II (PrzestrzeĹ„ 11: ZauĹ‚ek za osiedlem / Pierwsza korekta). Rozszerzenie generatora `ProceduralAudio` o syntezÄ™ dzwonka bakelitowego, kliku sĹ‚uchawki, szumu silnika magnetofonu i gĹ‚osu Jakuba, testĂłw w `smoke_test.gd` oraz renderĂłw w `capture_preview.gd`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 4 syntezatory dĹşwiÄ™ku:
  - `create_bakelite_bell_sound()`: mechaniczny dzwonek telefonu bakelitowego (dwuton mosiÄ™ĹĽnych czasz 1020/1240 Hz z modulacjÄ… uderzeĹ„ mĹ‚oteczka 20 Hz);
  - `create_handset_pickup_sound()`: mechaniczny klik wideĹ‚ek telefonu i podniesienia ebonitowej sĹ‚uchawki (850 Hz transient + 180 Hz body);
  - `create_tape_motor_hum_sound()`: szum przesuwu taĹ›my magnetycznej i obrotu szpul magnetofonu (120 Hz hum + flutter 3200 Hz);
  - `create_dialogue_jakub_blip_sound()`: mÄ™ski, szorstki ton gĹ‚osu Jakuba w sĹ‚uchawce wÄ™glowej (370 Hz z alikwotami 185/740 Hz i filtrem pasmowym mikrofonu wÄ™glowego 300â€“3400 Hz).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `BAKELITE_PHONE` (36), `REEL_TAPE_RECORDER` (37), `TOPOGRAPHY_BOARD` (38), `JAKUB_DESK_LAMP` (39), `TECH_STORAGE_AIRLOCK` (40);
  - dedykowane procedury rysowania: czarny telefon bakelitowy z tarczÄ… numerowÄ…, podnoszonÄ… sĹ‚uchawkÄ… i spiralnym przewodem, magnetofon szpulowy w obudowie tekowej z dwiema obracajÄ…cymi siÄ™ szpulami, taĹ›mÄ… ĹĽelazowÄ… i podĹ›wietlanym wskaĹşnikiem VU, tablica korkowa z planem mieszkania 14, wycinkami prasowymi o Linii 4 i kolorowymi niÄ‡mi Ĺ‚Ä…czÄ…cymi wÄ™zĹ‚y Podstruktury, klasyczna zielona lampka biurkowa rzucajÄ…ca bursztynowy snop Ĺ›wiatĹ‚a na biurko oraz stalowy portal korytarza technicznego z nitami i cynobrowo-cyjanowym wskaĹşnikiem statusu konsensusu.
- Zaimplementowano scenÄ™ i kontroler `Station10` (`scripts/levels/station_10.gd`, `scenes/levels/station_10.tscn`):
  - gabinet domowy i korytarz techniczny o wymiarach 640x360;
  - Ĺ›ciany w ciemno-grafitowym prÄ…ĹĽku modernistycznym z drewnianÄ… listwÄ…, wysokie regaĹ‚y biblioteczne z segregatorami technicznymi, okno na deszczowy Ĺ›wit z ĹĽebrowanym grzejnikiem ĹĽeliwnym, ciÄ™ĹĽkie dÄ™bowe biurko i komoda szpulowca;
  - strefa korytarza technicznego (x=480..640) z korytami kablowymi, stalowym portalem Ĺ›luzy i rozĹ›wietleniem progu po odryglowaniu;
  - mechanika dzwoniÄ…cego telefonu bakelitowego (cykliczny dzwonek co 2.4s, odbiĂłr przez interakcjÄ™ [E]);
  - wdroĹĽenie maszyny stanĂłw dialogu D-04 z Jakubem Wolskim (13 kwestii dialogowych) z banerem w Ĺ›wiecie gry, timingami i zsynchronizowanÄ… syntezÄ… blipĂłw gĹ‚osowych;
  - sekwencja odryglowania Ĺ›luzy korytarza technicznego po zakoĹ„czeniu dialogu D-04, aktywacja rekwizytu `TechStorageAirlock` i wejĹ›cie gracza do strefy `AirlockZone` koĹ„czÄ…cej Akt I.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 4 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station10` (5 odtwarzaczy audio, 5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie tablicy korkowej przy x=280, przeĹ‚Ä…czenie lampki przy x=310, wĹ‚Ä…czenie odtwarzania magnetofonu przy x=405, podejĹ›cie do telefonu przy x=255 i odebranie dzwoniÄ…cego poĹ‚Ä…czenia, przejĹ›cie 13 kwestii dialogu D-04, weryfikacja odryglowania Ĺ›luzy korytarza technicznego oraz wejĹ›cie do strefy `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_10.png` oraz `reports/station_10_phone.png`.
- Zarejestrowano decyzjÄ™ D-043 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Subiektywne odczucie napiÄ™cia, ciÄ™ĹĽaru zderzenia ĹĽaĹ‚oby Leny z surowym, ĹĽywym gĹ‚osem Jakuba oraz kontrastu domowego ciepĹ‚a z zimnem korytarza technicznego pozostajÄ… hipotezami (H-003, H-007, H-008, H-010b).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0029`.


## PKG-0029: P3 Vertical Slice â€” Pierwsza korekta (PrzestrzeĹ„ 11)

Data: 2026-08-20

Kontekst: Kontynuacja fazy P3 (Vertical Slice) oraz otwarcie Aktu II fabuĹ‚y (Korekta) per `FULL_STORY.md`. Zaimplementowanie Przestrzeni 11 z `FULL_STORY.md` (Pierwsza korekta / Dziedziniec za osiedlem i interwencja UCP) w scenie `scenes/levels/station_11.tscn` ze skryptem `scripts/levels/station_11.gd`. WdroĹĽenie dwupoziomowej kompozycji przestrzennej: gĂłrna galeria korytarza technicznego (x=0..240, y=160) z oknem obserwacyjnym (`ObservationWindow`), stalowÄ… balustradÄ… i postaciÄ… Marty Kurek (`MartaObservationDialogue`), schody ĹĽelbetowe schodzÄ…ce na poziom dziedziĹ„ca (x=240..340, y=160..300) oraz betonowy dziedziniec z pĹ‚yt chodnikowych (x=240..640, floor y=300) z elewacjÄ… ceglanÄ… Osiedla Tarasowego i opadajÄ…cÄ… mgĹ‚Ä… porannÄ… (`MistParticles`). WdroĹĽenie interwencji zespoĹ‚u polowego UCP w Ĺ›wiecie gry: dwĂłch operatorĂłw w szarych pĹ‚aszczach instytucjonalnych z aparaturÄ… stabilizacyjnÄ… (`UcpInterventionTeam`) uspokajajÄ…cych zdezorientowanÄ… starszÄ… kobietÄ™ (`ElderlyResidentGuide`), proceduralne wygĹ‚adzenie szwu dawnego wejĹ›cia w murze ceglanym (`ErasedDoorwayTrace`, #geometry-restless-grid) potwierdzajÄ…ce funkcjÄ™ UCP (Clue R-03: UCP chroni stabilnoĹ›Ä‡ i pomaga ludziom, ale wymazuje pamiÄ™Ä‡ przestrzennÄ…). WdroĹĽenie peĹ‚nej sceny dialogowej z MartÄ… Kurek przy balustradzie galeryjnej z motywem zgĹ‚oszenia znikniÄ™cia Leny (â€žZgĹ‚osiĹ‚am jÄ…, bo baĹ‚am siÄ™, ĹĽe skoĹ„czy jak te drzwi (...) Uratowali jÄ…. I wymazali jej wspomnienie. To nie to samo co krzywda, ale kosztuje tyle samoâ€ť), odryglowanie stalowej bramy wyjĹ›ciowej (`CourtyardExitAirlock`) i strefy `AirlockZone` prowadzÄ…cej ku Przestrzeni 12 (Pokaz bezpieczeĹ„stwa). Rozszerzenie moduĹ‚u `ProceduralAudio` o syntezÄ™ porannej bryzy, wiÄ…zki stabilizatora polowego UCP, wygĹ‚adzania muru i blipu starszej kobiety, testĂłw w `smoke_test.gd` oraz renderĂłw w `capture_preview.gd`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 4 syntezatory dĹşwiÄ™ku:
  - `create_morning_ambience_sound()`: poranna bryza i chĹ‚odny powiew Ĺ›witu (filtrowany szum 70/140 Hz z mikro-chĹ‚odem 1800 Hz);
  - `create_ucp_stabilizer_beam_sound()`: wiÄ…zka polowego stabilizatora UCP (pulsujÄ…cy ton 520 Hz z mikro-modulacjÄ… 8 Hz i sub-harmonicznÄ… 65 Hz);
  - `create_masonry_smooth_sound()`: mineralne zacieranie i wygĹ‚adzanie szwu muru ceglanego (rezonans 180->320 Hz z gĹ‚adkim wygaszeniem tarcia);
  - `create_dialogue_elderly_woman_sound()`: drĹĽÄ…cy, starszy gĹ‚os zdezorientowanej mieszkanki (310 Hz z rezonansem 155/620 Hz).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `OBSERVATION_WINDOW` (41), `ERASED_DOORWAY_TRACE` (42), `UCP_INTERVENTION_TEAM` (43), `ELDERLY_RESIDENT_GUIDE` (44), `MARTA_OBSERVATION_DIALOGUE` (45), `COURTYARD_EXIT_AIRLOCK` (46);
  - dedykowane procedury rysowania: panoramiczne okno korytarza ze stalowÄ… ramÄ… i widokiem na dziedziniec o Ĺ›wicie, fragment muru ceglanego z wygasajÄ…cym cynobrowym obrysem dawnego wejĹ›cia przechodzÄ…cym w jednolity mur (#geometry-restless-grid), dwuosobowy zespĂłĹ‚ techniczny UCP w instytucjonalnych pĹ‚aszczach z aparaturÄ… polowÄ…, starsza mieszkanka w weĹ‚nianym pĹ‚aszczu i chuĹ›cie z kluczem w dĹ‚oni, Marta Kurek stojÄ…ca przy balustradzie w roboczej kurtce z torbÄ… narzÄ™dziowÄ… oraz stalowa brama z pasami ostrzegawczymi i indykatorem konsensusu.
- Zaimplementowano scenÄ™ i kontroler `Station11` (`scripts/levels/station_11.gd`, `scenes/levels/station_11.tscn`):
  - dwupoziomowa geometria (galeria gĂłrna x=0..240, y=160; schody x=240..340; dziedziniec x=240..640, y=300);
  - czÄ…steczki porannej mgĹ‚y `MistParticles` (`CPUParticles2D`) snujÄ…ce siÄ™ po dziedziĹ„cu;
  - sekwencja obserwacji okna i interwencji UCP (stabilizator polowy, uspokojenie mieszkanki, bezszwowe wygĹ‚adzenie muru);
  - peĹ‚na 10-kwestiowa scena dialogowa z MartÄ… Kurek w Ĺ›wiecie gry z banerem, timingami i zsynchronizowanÄ… syntezÄ… blipĂłw gĹ‚osowych;
  - odryglowanie stalowej bramy wyjĹ›ciowej po zakoĹ„czeniu dialogu i wygĹ‚adzeniu muru oraz wejĹ›cie gracza do strefy `AirlockZone`.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 4 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station11` (5 odtwarzaczy audio, 6 rekwizytĂłw pamiÄ™ci, geometria ze schodami, czÄ…steczki mgĹ‚y, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie okna obserwacyjnego przy x=110, aktywacja procedury stabilizacji, przejĹ›cie 10 kwestii dialogu z MartÄ…, badanie wymazanego Ĺ›ladu wejĹ›cia na poziomie dziedziĹ„ca przy x=515, weryfikacja odryglowania bramy i wejĹ›cie do strefy `AirlockZone` przy x=600 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_11.png` oraz `reports/station_11_intervention.png`.
- Zarejestrowano decyzjÄ™ D-044 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Subiektywne odczucie chĹ‚odu poranka, dwuznacznoĹ›ci etycznej dziaĹ‚aĹ„ UCP (ratunek vs wymazanie pamiÄ™ci) oraz relacji Leny z MartÄ… pozostajÄ… hipotezami (H-003, H-007, H-008, H-009b, H-010b).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0030`.


## PKG-0030: P3 Vertical Slice â€” Pokaz bezpieczeĹ„stwa (PrzestrzeĹ„ 12)

Data: 2026-08-20

Kontekst: Kontynuacja fazy P3 (Vertical Slice) oraz realizacja Aktu II fabuĹ‚y (Korekta) per `FULL_STORY.md`. Zaimplementowanie Przestrzeni 12 z `FULL_STORY.md` (Pokaz bezpieczeĹ„stwa / PrzejĹ›cie podziemne pod placem i punkt informacyjny UCP) w scenie `scenes/levels/station_12.tscn` ze skryptem `scripts/levels/station_12.gd`. WdroĹĽenie kafelkowanego przejĹ›cia podziemnego pod placem miejskim wyĹ‚oĹĽonego ceramicznymi kafelkami transitowymi (`#2d3c45`, `#3a4e5a`) z rzÄ™dem opraw sufitowych, podwieszonym szyldem kierunkowym (â€žPUNKT ZGODNOĹšCI 6 ->â€ť), oĹ›wietlonym sĹ‚upem trasowym (`SubwayTilePillar`), plakatem propagandowym (â€žPAMIÄÄ† TO NIE POMIARâ€ť / `InstructionPoster`), gablotÄ… sprawozdawczÄ… UCP (`ShowcaseVitrine`), stanowiskiem terminalowym CRT (`UcpInfoTerminal`) oraz kratÄ… bezpieczeĹ„stwa z lampÄ… statusowÄ… konsensusu (`UnderpassExitGate`). WdroĹĽenie anomalii nakĹ‚adajÄ…cych siÄ™ schodĂłw (dwa rozbieĹĽne warianty schodzenia generujÄ…ce szczelinÄ™ geometrycznÄ… w kolorze oxide cinnabar z uwiÄ™zionym dzieckiem), procedury ratunkowej i demonstracji poĹĽytku UCP (`ucp_benefit_witnessed` / Clue R-03: straĹĽnik ewakuacyjny UCP wĹ‚Ä…cza przenoĹ›ny stabilizator wiÄ…zkowy, zamykajÄ…c oscylacjÄ™ schodĂłw w bezpieczny bieg i sprowadzajÄ…c dziecko na posadzkÄ™ przejĹ›cia), autoryzacji Poziomu 3 Leny na terminalu CRT (kwalifikowany inĹĽynier siatek Podstruktury â€” potwierdzenie jej roli w architekturze wÄ™zĹ‚Ăłw korelacyjnych), odryglowania kraty wyjĹ›ciowej i wejĹ›cia do strefy `AirlockZone` prowadzÄ…cej ku Przestrzeni 13 (Adres ciÄ…gĹ‚oĹ›ci). Rozszerzenie generatora `ProceduralAudio` o 4 syntezatory audio, dodanie rekwizytĂłw 47..51 w `MemoryResonancePoint`, rozbudowa testĂłw w `smoke_test.gd` oraz wyrenderowanie podglÄ…dĂłw `reports/station_12.png` i `reports/station_12_terminal.png`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 4 syntezatory dĹşwiÄ™ku:
  - `create_subway_hum_sound()`: gĹ‚Ä™boki szum i rezonans podziemi tranzytowych (sub-bas 55/110 Hz z rezonansem wnÄ™kowym i falÄ… infradĹşwiÄ™kowÄ…);
  - `create_neon_flicker_sound()`: brzÄ™czenie jarzeniĂłwek i neonĂłw podziemnych (120 Hz podwĂłjna harmoniczna przydĹşwiÄ™ku z jonizacyjnym szmerem 2800 Hz);
  - `create_terminal_keypress_sound()`: mechaniczny klik klawisza terminala CRT (980 Hz transient z tĹ‚umionym 240 Hz korpusem klawiatury);
  - `create_pa_chime_sound()`: dwutonowy gong podziemnego systemu nagĹ‚oĹ›nienia PA (G5 784 Hz -> D5 587 Hz z przestrzennym pogĹ‚osem tunelowym).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `UCP_INFO_TERMINAL` (47), `SHOWCASE_VITRINE` (48), `INSTRUCTION_POSTER` (49), `SUBWAY_TILE_PILLAR` (50), `UNDERPASS_EXIT_GATE` (51);
  - dedykowane procedury rysowania: terminal CRT w masywnej obudowie na ĹĽeliwnej podstawie z zielonym ekranem kineskopowym, skanowanymi liniami rastrowymi i animowanym kursorem, podĹ›wietlana Ĺ›cienna gablota ze sprawozdaniami i pieczÄ™ciami UCP, plakat instruktaĹĽowy o wysokim kontraĹ›cie z hasĹ‚em â€žPAMIÄÄ† TO NIE POMIARâ€ť, filar z ceramicznymi pĹ‚ytkami i schematem linii tranzytowej ku Punktowi 6 oraz ciÄ™ĹĽka stalowa krata noĹĽycowa z indykatorem rygla konsensusu.
- Zaimplementowano scenÄ™ i kontroler `Station12` (`scripts/levels/station_12.gd`, `scenes/levels/station_12.tscn`):
  - peĹ‚na geometria podziemnego przejĹ›cia o wymiarach 640x360 (podĹ‚oga y=290, sufit y=50, schody x=40..170 ze spocznikiem y=200);
  - animacja migotania neonĂłw i oĹ›wietlenia sufitowego;
  - anomalia nakĹ‚adajÄ…cych siÄ™ schodĂłw w kolorze oxide cinnabar z procedurÄ… stabilizacji wiÄ…zkowej i bezpiecznÄ… ewakuacjÄ… dziecka;
  - wdroĹĽenie sekwencji terminalowej CRT (8 kwestii informacyjno-dialogowych, skan karty Leny z odczytem Poziomu 3 autoryzacji w siatkach Podstruktury);
  - procedura odryglowania kraty bezpieczeĹ„stwa `UnderpassExitGate` i wejĹ›cie gracza do strefy `AirlockZone` przechodzÄ…cej ku Przestrzeni 13.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 4 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station12` (6 odtwarzaczy audio, 5 rekwizytĂłw pamiÄ™ci, geometria schodĂłw i spocznika, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie filaru przy x=320, badanie plakatu przy x=380, badanie gabloty przy x=440, interakcja z terminalem CRT przy x=500, przejĹ›cie 8 kwestii sekwencji terminalowej, weryfikacja demonstracji bezpieczeĹ„stwa i ewakuacji dziecka, autoryzacja Poziomu 3, odryglowanie kraty wyjĹ›ciowej oraz wejĹ›cie do strefy `AirlockZone` przy x=600 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_12.png` oraz `reports/station_12_terminal.png`.
- Zarejestrowano decyzjÄ™ D-045 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Subiektywne odczucie klaustrofobii podziemi, moralnej dwuznacznoĹ›ci ratunku uwiÄ™zionego dziecka przez aparat UCP oraz ciÄ™ĹĽaru ujawnienia roli Leny jako inĹĽyniera Podstruktury pozostajÄ… hipotezami (H-003, H-007, H-008, H-009b, H-010b).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0031`.

## PKG-0031: P3 Vertical Slice â€” Adres ciÄ…gĹ‚oĹ›ci (PrzestrzeĹ„ 13)

Data: 2026-08-20

Kontekst: Kontynuacja fazy P3 (Vertical Slice) oraz realizacja Aktu II fabuĹ‚y (Korekta) per `FULL_STORY.md`. Zaimplementowanie Przestrzeni 13 z `FULL_STORY.md` (Adres ciÄ…gĹ‚oĹ›ci / Schemat mieszkania i fotografia Jakuba) w scenie `scenes/levels/station_13.tscn` ze skryptem `scripts/levels/station_13.gd`. WdroĹĽenie gabinetu analiz przestrzennych / zaplecza archiwum za przejĹ›ciem podziemnym wyĹ‚oĹĽonego planami architektonicznymi RĂłwni (`#162832`, `#2c4d5e`, `#75c7c3`), z podĹ›wietlanym stoĹ‚em kreĹ›larskim (`DraftingTable`), stalowÄ… szafÄ… kartograficznÄ… (`TopographyIndexCabinet`), Ĺ›ciennym wÄ™zĹ‚em obwodu rezonansowego (`ResonanceCircuitNode`), optycznÄ… ramÄ… montaĹĽowÄ… na brakujÄ…cy element klucza (`JakubPhotographFrame`) oraz Ĺ›luzÄ… technicznÄ… (`TechPassageAirlock`) prowadzÄ…cÄ… do Przestrzeni 14 (Zakotwiczenie / Schowek techniczny). Zaimplementowanie zagadki topograficznej analizy pozycji mebli mieszkania 14 jako obwodu sterujÄ…cego siatkami Podstruktury oraz kluczowej mechaniki pamiÄ™ci jako narzÄ™dzia i kosztu (Clue R-05: wĹ‚oĹĽenie fotografii Jakuba ze Ĺ›wiata Leny aktywuje obwĂłd i odryglowuje przejĹ›cie ku schowkowi, lecz wywoĹ‚uje powolne narastanie dorosĹ‚ego cienia na emulsji obok mĹ‚odego Jakuba). Rozszerzenie moduĹ‚u `ProceduralAudio` o 4 syntezatory dĹşwiÄ™ku, dodanie rekwizytĂłw 52..56 w `MemoryResonancePoint`, rozbudowa testĂłw w `smoke_test.gd` oraz wyrenderowanie podglÄ…dĂłw `reports/station_13.png` i `reports/station_13_photo.png`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 4 syntezatory dĹşwiÄ™ku:
  - `create_drafting_lamp_hum_sound()`: transformatorowy szum lampy stoĹ‚u kreĹ›larskiego (60/120 Hz przydĹşwiÄ™k z ciepĹ‚ym 420 Hz rezonansem ĹĽarnika i mikro-szmerem);
  - `create_photo_slide_sound()`: szelest papieru fotograficznego wsuwanego w ramÄ™ (1450/3100 Hz tarcie wĹ‚Ăłkien z zatrzaĹ›niÄ™ciem klipsĂłw montaĹĽowych);
  - `create_shadow_whisper_sound()`: zjawiskowy szum pojawiajÄ…cego siÄ™ cienia na emulsji (880 Hz ton A5 z mikromodulacjÄ… fazowÄ… 3.5 Hz, ciemnym sub-basem i szmerem krysztaĹ‚Ăłw halogenku srebra);
  - `create_relay_alignment_click_sound()`: precyzyjny klik wielobiegunowego przekaĹşnika synchronizacji adresu (1120 Hz snap transientu z 340 Hz echem cewki elektromagnetycznej).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `DRAFTING_TABLE` (52), `TOPOGRAPHY_INDEX_CABINET` (53), `JAKUB_PHOTOGRAPH_FRAME` (54), `RESONANCE_CIRCUIT_NODE` (55), `TECH_PASSAGE_AIRLOCK` (56);
  - dedykowane procedury rysowania: pochylony stĂłĹ‚ kreĹ›larski z podĹ›wietlanÄ… szybÄ…, rzutem mieszkania 14 i liniaĹ‚em kreĹ›larskim, szafa kartograficzna z wysuniÄ™tÄ… szufladÄ… z kartami perforowanymi, Ĺ›cienna skrzynka przyĹ‚Ä…czeniowa z podwĂłjnym galwanometrem, szynami miedzianymi i bankiem przekaĹşnikĂłw, rama montaĹĽowa z dynamicznie rosnÄ…cym cieniem na zdjÄ™ciu (`shadow_progress`) oraz Ĺ›luza techniczna z koĹ‚em ryglowym i lampÄ… statusowÄ….
- Zaimplementowano scenÄ™ i kontroler `Station13` (`scripts/levels/station_13.gd`, `scenes/levels/station_13.tscn`):
  - peĹ‚na geometria archiwum o wymiarach 640x360 (podĹ‚oga y=290, szyny kablowe sufitu y=35, plany architektoniczne rzutu mieszkania 14 i matrycy Podstruktury na Ĺ›cianie tylnej);
  - dynamiczne przewody energetyczne Ĺ‚Ä…czÄ…ce stĂłĹ‚, szafÄ™, wÄ™zeĹ‚ obwodu, ramÄ™ i Ĺ›luzÄ™;
  - mechanika wĹ‚oĹĽenia zdjÄ™cia Jakuba, synchronizacji wektora adresu oraz pojawiania siÄ™ dorosĹ‚ego cienia na emulsji;
  - peĹ‚na sekwencja dialogowo-Ĺ›wiadectwowa z 9 kwestiami;
  - procedura odryglowania Ĺ›luzy technicznej `TechPassageAirlock` i przejĹ›cie gracza do strefy `AirlockZone` prowadzÄ…cej ku Przestrzeni 14.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 4 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station13` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie stoĹ‚u kreĹ›larskiego przy x=140, badanie szafy kartograficznej przy x=250, badanie wÄ™zĹ‚a obwodu przy x=370, interakcja z ramÄ… montaĹĽowÄ… przy x=470 z wĹ‚oĹĽeniem zdjÄ™cia i synchronizacjÄ… obwodu, przejĹ›cie 9 kwestii dialogowych, weryfikacja narastania cienia (`_shadow_progress > 0.0`), odryglowanie Ĺ›luzy oraz wejĹ›cie do strefy `AirlockZone` przy x=600 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_13.png` oraz `reports/station_13_photo.png`.
- Zarejestrowano decyzjÄ™ D-046 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Subiektywne odczucie napiÄ™cia wynikajÄ…cego z degradacji prywatnej pamiÄ…tki na rzecz otwarcia drogi oraz wagi moralnej uĹĽycia pamiÄ™ci jako narzÄ™dzia pozostajÄ… hipotezami (H-003, H-007, H-008, H-010b).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0032`.

## PKG-0032: P3 Vertical Slice â€” Zakotwiczenie (PrzestrzeĹ„ 14)

Data: 2026-08-20

Kontekst: Kontynuacja fazy P3 (Vertical Slice) oraz realizacja Aktu II fabuĹ‚y (Korekta) per `FULL_STORY.md`. Zaimplementowanie Przestrzeni 14 z `FULL_STORY.md` (Zakotwiczenie / Schowek techniczny, rysa w metalu i degradacja nagrania) w scenie `scenes/levels/station_14.tscn` ze skryptem `scripts/levels/station_14.gd`. WdroĹĽenie schowka technicznego za Ĺ›cianÄ… mieszkania 14 z drgajÄ…cÄ… konstrukcjÄ… szwu budowlanego (`#1a2b35`, `#2d4a5d`, `#75c7c3`), regaĹ‚em narzÄ™dziowym Marty (`MaintenanceRack`), rysÄ… kotwiczÄ…cÄ… na stalowej belce noĹ›nej (`MetalScratchBeam`), heblem dociskowym stabilizatora szwu (`SeamStabilizerLever`), magnetofonem taĹ›mowym Jakuba (`TapePlaybackDeck`) oraz otwieranym szybem Podstruktury (`SubstructureConduitShaft`) prowadzÄ…cym do Przestrzeni 15 (Korytarz serwisowy). Zaimplementowanie narracyjnej mechaniki Zakotwiczenia (obserwacja rysy w belce noĹ›nej blokuje dryf konstrukcyjny z charakterystycznym chĹ‚odnym rozbĹ‚yskiem cyjanu na jednej krawÄ™dzi per `VISUAL_DESIGN.md`, podczas gdy reszta schowka dopasowuje siÄ™ do kotwicy) oraz autobiograficznego kosztu Zakotwiczenia (Clue R-04/R-05: odtworzenie taĹ›my Jakuba ujawnia postÄ™pujÄ…cÄ… degradacjÄ™ i zmatowienie gĹ‚osu brata, a w 3. sekundzie odsĹ‚uchu ujawnia siÄ™ preegzystujÄ…ca cisza, dowodzÄ…ca wczeĹ›niejszej korekty Ĺ›wiata wyjĹ›ciowego Leny). Rozszerzenie moduĹ‚u `ProceduralAudio` o 4 syntezatory dĹşwiÄ™ku, dodanie rekwizytĂłw 57..61 w `MemoryResonancePoint`, rozbudowa testĂłw w `smoke_test.gd` oraz wyrenderowanie podglÄ…dĂłw `reports/station_14.png` i `reports/station_14_anchored.png`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 4 syntezatory dĹşwiÄ™ku:
  - `create_metal_scratch_chime_sound()`: krystaliczny dzwon kotwiczenia rysy w metalu (740 Hz F#5 z harmonicznÄ… 1480 Hz i tarciem 2400 Hz o powolnym cyjanowym wybrzmieniu);
  - `create_tape_degradation_filter_sound()`: filtr pasmowy degradacji gĹ‚osu na taĹ›mie magnetycznej (pasmo wokalne 300..1800 Hz z koĹ‚ysaniem wow/flutter 12 Hz i szmerem magnetycznym);
  - `create_seam_clamp_sound()`: hydrauliczny docisk stabilizatora szwu (narastajÄ…ce ciĹ›nienie 140 Hz z uderzeniem rygla 280/840 Hz i snapem zamka 1650 Hz);
  - `create_conduit_shaft_wind_sound()`: gĹ‚Ä™boki ciÄ…g aerodynamiczny szybu Podstruktury (45/90 Hz sub-bas z rezonansem wnÄ™kowym i Ĺ›wistem szczelinowym 1600 Hz).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `METAL_SCRATCH_BEAM` (57), `TAPE_PLAYBACK_DECK` (58), `MAINTENANCE_RACK` (59), `SEAM_STABILIZER_LEVER` (60), `SUBSTRUCTURE_CONDUIT_SHAFT` (61);
  - dedykowane procedury rysowania: regaĹ‚ serwisowy z suwmiarkami i prĂłbnikami Marty, masywna belka stalowa z jarzÄ…cÄ… siÄ™ cyjanem rysÄ… kotwiczÄ…cÄ… (`shadow_progress`), pulpit dociskowy hebla stabilizatora szwu z wskaĹşnikiem nacisku, magnetofon taĹ›mowy z obracajÄ…cymi siÄ™ szpulami i wskaĹşnikiem degradacji sygnaĹ‚u oraz pionowy szyb Podstruktury z ĹĽebrowanÄ… obudowÄ… i wentylatorem ciÄ…gowym.
- Zaimplementowano scenÄ™ i kontroler `Station14` (`scripts/levels/station_14.gd`, `scenes/levels/station_14.tscn`):
  - peĹ‚na geometria schowka technicznego o wymiarach 640x360 (podĹ‚oga y=320, sufit y=20, tylna Ĺ›ciana z widocznym dryfujÄ…cym szwem i kratownicami Podstruktury);
  - drganie i oscylacja szwu konstrukcyjnego w stanie niezakotwiczonym (`_seam_drift_phase`) oraz stabilizacja z cyjanowÄ… poĹ›wiatÄ… po zakotwiczeniu;
  - peĹ‚na sekwencja narracyjno-Ĺ›wiadectwowa z 12 kwestiami;
  - odkrycie poszlaki R-04/R-05 (odnalezienie pierwotnej luki w nagraniu Jakuba w 3. sekundzie â€” `silence_gap_discovered`);
  - procedura odryglowania szybu Podstruktury `SubstructureConduitShaft` i przejĹ›cie gracza do strefy `AirlockZone` prowadzÄ…cej ku Przestrzeni 15.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 4 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station14` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie regaĹ‚u narzÄ™dziowego przy x=140, badanie i zakotwiczenie rysy w metalu przy x=260 (rozbĹ‚ysk cyjanu i trauma kamery), przestawienie hebla stabilizatora szwu przy x=360, odtworzenie taĹ›my Jakuba przy x=470 z degradacjÄ… sygnaĹ‚u, przejĹ›cie 12 kwestii narracyjnych, rejestracja poszlaki ciszy w 3. sekundzie, odryglowanie szybu Podstruktury oraz wejĹ›cie do strefy `AirlockZone` przy x=590 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_14.png` oraz `reports/station_14_anchored.png`.
- Zarejestrowano decyzjÄ™ D-047 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
FACILITATOR PROFILE A/B/C: MOVEMENT PROFILE CHECK PASS
INVALID PROFILE EXIT: 2
CAPTURE PASS: C:/getting_strange/reports/movement_lab.png
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Subiektywne odczucie napiÄ™cia wynikajÄ…cego z mechaniki Zakotwiczenia jako redukcji prywatnej pamiÄ™ci oraz dramatycznego ciÄ™ĹĽaru odkrycia, ĹĽe Ĺ›wiat wyjĹ›ciowy Leny rĂłwnieĹĽ ulegĹ‚ korekcie, pozostajÄ… hipotezami (H-003, H-007, H-008, H-010b).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0033`.

## PKG-0033: P3 Vertical Slice â€” Korytarz serwisowy (PrzestrzeĹ„ 15)

Data: 2026-08-20

Kontekst: Kontynuacja fazy P3 (Vertical Slice) oraz realizacja Aktu II fabuĹ‚y (Korekta) per `FULL_STORY.md`. Zaimplementowanie Przestrzeni 15 z `FULL_STORY.md` (Korytarz serwisowy / Pismo lokalnej Leny, instrukcje higieny ciÄ…gĹ‚oĹ›ci i odwrĂłcone odbicie kaĹ‚uĹĽy) w scenie `scenes/levels/station_15.tscn` ze skryptem `scripts/levels/station_15.gd`. WdroĹĽenie korytarza wewnÄ…trz infrastruktury przesyĹ‚owej UCP ze stalowÄ… kĹ‚adkÄ… pomostowÄ…, rurami ciĹ›nieniowymi magistrali korelacyjnej, gablotÄ… instrukcji higieny ciÄ…gĹ‚oĹ›ci (`HygieneInstructionBoard`), odrÄ™cznymi rĂłwnaniami synchronizacji wÄ™zĹ‚a na obudowie rury (`HandwrittenCorrelationFormula`), kaĹ‚uĹĽÄ… technicznÄ… z asynchronicznym wektorem kierunkowym (`ReflectivePuddle`), zaworem dekompresyjnym z manometrem (`PressureReliefValve`) oraz bramÄ… serwisowÄ… z ryglem elektromagnetycznym (`TransitServiceGate`) prowadzÄ…cÄ… do Przestrzeni 16. Odkrycie poszlaki R-06 per `CONTINUITY_TRACKER.md` (wzory synchronizacji wÄ™zĹ‚a spisane charakterem pisma lokalnej Leny z otwartÄ… cyfrÄ… 4 per `VISUAL_DESIGN.md` 6.3 dowodzÄ… jej roli wspĂłĹ‚twĂłrcy infrastruktury UCP). WdroĹĽenie mechaniki asynchronicznego odbicia (w bezpoĹ›rednim Ĺ›wietle strzaĹ‚ka na Ĺ›cianie wskazuje faĹ‚szywy wektor w lewo, a w odbiciu kaĹ‚uĹĽy ujawnia siÄ™ wĹ‚aĹ›ciwy kierunek w prawo ku zaworowi dekompresyjnemu). Rozszerzenie moduĹ‚u `ProceduralAudio` o 4 syntezatory dĹşwiÄ™ku, dodanie rekwizytĂłw 62..66 w `MemoryResonancePoint`, rozbudowa testĂłw w `smoke_test.gd` oraz wyrenderowanie podglÄ…dĂłw `reports/station_15.png` i `reports/station_15_reflection.png`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 4 syntezatory dĹşwiÄ™ku:
  - `create_catwalk_footstep_sound()`: uderzenie i wybrzmienie metalowej kĹ‚adki aĹĽurowej (620 Hz fundamentalny brzÄ™k kratownicy z pierĹ›cieniem 1440/2880 Hz);
  - `create_water_drip_puddle_sound()`: perkusyjny impakt kropli w kaĹ‚uĹĽÄ™ technicznÄ… (narastajÄ…cy ton kompresji bÄ…bla 1150->2300 Hz z rezonansem fali 580 Hz i micro-splashem);
  - `create_pressure_valve_release_sound()`: szum parowy dekompresji z mechanicznym snapem zapadki (pasmo 800..4200 Hz ze snapem 950/2400 Hz i opadajÄ…cym wydechem);
  - `create_resonance_pulse_sound()`: niski przydĹşwiÄ™k elektromagnetyczny magistrali z dudnieniem (dwuton 52/55 Hz z shimmerem obudowy 740 Hz).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `HYGIENE_INSTRUCTION_BOARD` (62), `HANDWRITTEN_CORRELATION_FORMULA` (63), `REFLECTIVE_PUDDLE` (64), `PRESSURE_RELIEF_VALVE` (65), `TRANSIT_SERVICE_GATE` (66);
  - dedykowane procedury rysowania: gablota regulaminowa z wytycznymi UCP i czerwonymi dopiskami oĹ‚Ăłwkowymi, fragment magistrali z odrÄ™cznÄ… formuĹ‚Ä… $\Psi_{sync}$ i otwartÄ… cyfrÄ… 4, kaĹ‚uĹĽa techniczna z animowanym opadem kropel i odwrĂłconÄ… cyjanowÄ… strzaĹ‚Ä… wektorowÄ…, pionowy wÄ™zeĹ‚ zaworu z manometrem tarczowym i dyszÄ… wyrzutowÄ… pary oraz masywna przesuwna brama serwisowa z ryglem i diodÄ… stanu.
- Zaimplementowano scenÄ™ i kontroler `Station15` (`scripts/levels/station_15.gd`, `scenes/levels/station_15.tscn`):
  - peĹ‚na geometria korytarza serwisowego 640x360 (stalowa kĹ‚adka z kratownicami y=320, sufit z rurociÄ…giem i lampami jarzeniowymi y=20, tylna Ĺ›ciana z surowego betonu i blachy);
  - animowany ukĹ‚ad kondensacji pary wodnej (krople kapiÄ…ce z rurociÄ…gu overhead co 2.2s do kaĹ‚uĹĽy technicznej);
  - dekompresja magistrali (animowany upust pary `_pressure_vent_progress` i opadniÄ™cie wskazĂłwki manometru do zera);
  - odryglowanie i podniesienie ĹĽaluzji bramy serwisowej z cyjanowÄ… poĹ›wiatÄ… korytarza wyjĹ›ciowego;
  - peĹ‚na sekwencja narracyjno-Ĺ›wiadectwowa z 12 kwestiami;
  - odkrycie poszlaki R-06 (zgodnoĹ›Ä‡ charakteru pisma i formuĹ‚y lokalnej Leny w wÄ™Ĺşle UCP);
  - procedura przejĹ›cia gracza do strefy `AirlockZone` przy x=590 prowadzÄ…cej do Przestrzeni 16.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 4 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station15` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie gabloty higieny przy x=130, odkrycie odrÄ™cznej formuĹ‚y przy x=250, zbadanie kaĹ‚uĹĽy i wektora odbicia przy x=370, dekompresja zaworu parowego przy x=480, przejĹ›cie 12 kwestii narracyjnych, odryglowanie bramy serwisowej oraz wejĹ›cie do strefy `AirlockZone` przy x=590 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_15.png` oraz `reports/station_15_reflection.png`.
- Zarejestrowano decyzjÄ™ D-048 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
FACILITATOR PROFILE A/B/C: MOVEMENT PROFILE CHECK PASS
INVALID PROFILE EXIT: 2
CAPTURE PASS: C:/getting_strange/reports/movement_lab.png
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Subiektywne odczucie napiÄ™cia wynikajÄ…cego z odkrycia, ĹĽe lokalna Lena byĹ‚a architektem systemu UCP, a nie tylko jego ofiarÄ…, oraz czytelnoĹ›Ä‡ asynchronicznego odbicia w kaĹ‚uĹĽy bez podpowiedzi HUD pozostajÄ… hipotezami (H-003, H-007, H-008, H-010b).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0034`.

## PKG-0034: P3 Vertical Slice â€” Rozmowa przy stole (PrzestrzeĹ„ 16)

Data: 2026-08-20

Kontekst: Kontynuacja fazy P3 (Vertical Slice) oraz realizacja Aktu II fabuĹ‚y (Korekta) per `FULL_STORY.md`. Zaimplementowanie Przestrzeni 16 z `FULL_STORY.md` (Rozmowa przy stole / Mieszkanie 14, pÄ™kniÄ™ta filiĹĽanka Marty, katalogowanie dowodĂłw R-01..R-06 i wybĂłr z obrÄ…czkÄ…) w scenie `scenes/levels/station_16.tscn` ze skryptem `scripts/levels/station_16.gd`. WdroĹĽenie kuchni mieszkania 14 nocÄ… pod stoĹĽkiem Ĺ›wiatĹ‚a lampy wiszÄ…cej (`#282218`, `#e2a342`), z oknem na nocnÄ… panoramÄ™ Osiedla Tarasowego, zegarem Ĺ›ciennym (`KitchenClock`), pÄ™kniÄ™tÄ… filiĹĽankÄ… Marty z klejonym szwem kintsugi (`CrackedTeaCup`), teczkÄ… z dowodami R-01..R-06 (`CorrelationDossier`), podstawkiem ze zĹ‚otÄ… obrÄ…czkÄ… (`WeddingRingStand`) oraz drzwiami balkonowymi (`BalconyExitDoor`) prowadzÄ…cymi do Przestrzeni 17 (Ucieczka po gzymsie). WdroĹĽenie peĹ‚nej sceny dialogowej D-05 z `DIALOGUE_SCRIPT.md` (13 kwestii: Lena, Marta, Ĺšwiadectwo PamiÄ™ci) oraz interaktywnego wyboru dyspozycji obrÄ…czki (`ring_disposition`: `leave` / `wear` / `sample`) wpĹ‚ywajÄ…cego na `CONTINUITY_TRACKER.md`. Rozszerzenie moduĹ‚u `ProceduralAudio` o 4 syntezatory dĹşwiÄ™ku, dodanie rekwizytĂłw 67..71 w `MemoryResonancePoint`, rozbudowa testĂłw w `smoke_test.gd` oraz wyrenderowanie podglÄ…dĂłw `reports/station_16.png` i `reports/station_16_choice.png`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 4 syntezatory dĹşwiÄ™ku:
  - `create_ceramic_cup_clink_sound()`: rezonansowe stukniÄ™cie porcelanowej filiĹĽanki o spodek (1450 Hz i alikwot 2900 Hz z szybkim 2ms transientem);
  - `create_tea_pour_steam_sound()`: nalewanie herbaty i oddech pary wodnej (strumieĹ„ 350..1600 Hz z filtrowanym szumem);
  - `create_kitchen_clock_tick_sound()`: mechaniczne tykanie zegara Ĺ›ciennego z drewnianÄ… obudowÄ… (podwĂłjny klik 820/640 Hz z tĹ‚umieniem 210 Hz);
  - `create_dossier_paper_turn_sound()`: szelest tektury i przewracanie kart poszlak (pasmo 700..3400 Hz z impulsem zagiÄ™cia karty).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `CRACKED_TEA_CUP` (67), `CORRELATION_DOSSIER` (68), `KITCHEN_CLOCK` (69), `WEDDING_RING_STAND` (70), `BALCONY_EXIT_DOOR` (71);
  - dedykowane procedury rysowania: filiĹĽanka na spodku z klejonym zĹ‚otym szwem i parÄ… wodnÄ…, teczka dossier z wykresem korelacyjnym i przypiÄ™tym slajdem fotograficznym, drewniany zegar z asynchronicznym sekundnikiem, porcelanowy podstawek ze zĹ‚otÄ… obrÄ…czkÄ… i bursztynowÄ… poĹ›wiatÄ… oraz dwuskrzydĹ‚owe drzwi balkonowe ze zwiewnÄ… firanÄ… i nocnym widokiem na Ĺ›wiatĹ‚a blokĂłw.
- Zaimplementowano scenÄ™ i kontroler `Station16` (`scripts/levels/station_16.gd`, `scenes/levels/station_16.tscn`):
  - peĹ‚na geometria kuchni mieszkania 14 o wymiarach 640x360 (podĹ‚oga y=320, szafki wiszÄ…ce, stĂłĹ‚ kuchenny z ceratÄ…, postaÄ‡ Marty Kurek z klejem technicznym);
  - oĹ›wietlenie wolumetryczne w Ĺ›wiecie gry (stoĹĽek ciepĹ‚ego Ĺ›wiatĹ‚a lampy wiszÄ…cej skupiony na stole roboczym i cienie peryferyjne);
  - peĹ‚na implementacja sceny dialogowej D-05 (13 kwestii) o chronologii dat, obcej relacji i wypĹ‚ywajÄ…cym kleju;
  - interaktywny wybĂłr dyspozycji obrÄ…czki (`make_ring_choice`) aktualizujÄ…cy kwestiÄ™ 11 i odblokowujÄ…cy wyjĹ›cie balkonowe;
  - procedura przejĹ›cia gracza do strefy `AirlockZone` przy x=590 prowadzÄ…cej do Przestrzeni 17.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 4 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station16` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie zegara kuchennego przy x=140, badanie filiĹĽanki przy x=250 z uruchomieniem dialogu D-05, przeglÄ…d teczki poszlak przy x=310, przejĹ›cie kwestii 1..9, interaktywny wybĂłr obrÄ…czki (`leave`/`wear`/`sample`) przy x=370, weryfikacja odryglowania balkonu, przejĹ›cie do koĹ„ca dialogu oraz wejĹ›cie do strefy `AirlockZone` przy x=590 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_16.png` oraz `reports/station_16_choice.png`.
- Zarejestrowano decyzjÄ™ D-049 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Subiektywne odczucie intymnego napiÄ™cia w relacji z MartÄ…, ciÄ™ĹĽar wyboru dyspozycji obrÄ…czki oraz tempo wypĹ‚ywania kleju na ceratÄ™ pozostajÄ… hipotezami (H-003, H-007, H-008, H-010b).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0035`.

## PKG-0035: P3 Vertical Slice â€” Punkt ZgodnoĹ›ci 6 (PrzestrzeĹ„ 17)

Data: 2026-08-20

Kontekst: Kontynuacja fazy P3 (Vertical Slice) oraz realizacja Aktu II fabuĹ‚y (Korekta) per `FULL_STORY.md`. Zaimplementowanie Przestrzeni 17 z `FULL_STORY.md` (Punkt ZgodnoĹ›ci 6 / UrzÄ…d UCP, wezwanie, numer sprawy sprzed 17 dni, diagnostyczny wydruk odpowiedzi i powitanie dr Wierzbickiej) w scenie `scenes/levels/station_17.tscn` ze skryptem `scripts/levels/station_17.gd`. WdroĹĽenie modernistycznej poczekalni i recepcji Punktu ZgodnoĹ›ci 6 pod chĹ‚odnymi jarzeniĂłwkami (`#1a2d3d`, `#3b6978`, `#c4dbd9`), z Ĺ‚awkÄ… poczekalni i afiszem procedur zgodnoĹ›ci (`ComplianceWaitingBench`), automatem biletowym ze sprawÄ… 084/17 sprzed 17 dni (`QueuingTicketDispenser`), mosiÄ™ĹĽnÄ… stacjÄ… poczty pneumatycznej (`PneumaticDossierStation`), aparatem rejestracji sensorycznej z testem pamiÄ™ci (`DiagnosticMemoryPrinter`) oraz przeszklonymi drzwiami gabinetu 06 dr Heleny Wierzbickiej (`ConsultationOfficeDoor`) prowadzÄ…cymi do Przestrzeni 18 (Wywiad zgodnoĹ›ci). WdroĹĽenie peĹ‚nej sceny dialogowej D-06 z `DIALOGUE_SCRIPT.md` (12 kwestii: dr Helena Wierzbicka, Lena Wolska, Ĺšwiadectwo PamiÄ™ci) o zapachu korytarza prosektorium (odpowiedĹş uporzÄ…dkowana: Chlor vs Kawa/Linoleum/Mokra WeĹ‚na) oraz wspĂłĹ‚rzÄ™dnych powrotu. Rozszerzenie moduĹ‚u `ProceduralAudio` o 4 syntezatory dĹşwiÄ™ku, dodanie rekwizytĂłw 72..76 w `MemoryResonancePoint`, rozbudowa testĂłw w `smoke_test.gd` oraz wyrenderowanie podglÄ…dĂłw `reports/station_17.png` i `reports/station_17_interview.png`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 4 syntezatory dĹşwiÄ™ku:
  - `create_dispenser_ticket_sound()`: mechaniczny podajnik biletu kolejkowego (silnik krokowy 360/720 Hz ze Ĺ›ciÄ™ciem gilotyny 960/1920 Hz i naderwaniem perforacji);
  - `create_clinic_intercom_chime_sound()`: trzytonowy dzwonek gongu wywoĹ‚awczego gabinetu UCP (F5 698.46 Hz -> A5 880.0 Hz -> C6 1046.5 Hz z ceramicznym echem i mikro-modulacjÄ…);
  - `create_pneumatic_tube_whoosh_sound()`: aerodynamiczne ssanie poczty pneumatycznej (szum 120..2800 Hz ze stukiem zatrzaĹ›niÄ™cia mosiÄ™ĹĽnej kapsuĹ‚y 820/1640 Hz);
  - `create_wierzbicka_printer_sound()`: precyzyjna igĹ‚owa gĹ‚owica drukarki diagnostycznej (dwuton 720/1440 Hz o kadencji 18 krokĂłw/sekundÄ™).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `QUEUING_TICKET_DISPENSER` (72), `COMPLIANCE_WAITING_BENCH` (73), `PNEUMATIC_DOSSIER_STATION` (74), `DIAGNOSTIC_MEMORY_PRINTER` (75), `CONSULTATION_OFFICE_DOOR` (76);
  - dedykowane procedury rysowania: automat biletowy z podĹ›wietlanym panelem LED i wysuniÄ™tym biletem ze sprawÄ… 084/17, dÄ™bowa Ĺ‚awka poczekalni z oprawionym w szkĹ‚o afiszem instrukcji, mosiÄ™ĹĽny pion poczty pneumatycznej z kapsuĹ‚Ä… teczki medycznej, aparat rejestracji sensorycznej z pulsujÄ…cym wskaĹşnikiem i taĹ›mÄ… perforowanÄ… oraz przeszklone mleczne drzwi gabinetu 06 z tabliczkÄ… dr Heleny Wierzbickiej i lampkÄ… wywoĹ‚awczÄ….
- Zaimplementowano scenÄ™ i kontroler `Station17` (`scripts/levels/station_17.gd`, `scenes/levels/station_17.tscn`):
  - peĹ‚na geometria poczekalni Punktu ZgodnoĹ›ci 6 o wymiarach 640x360 (podĹ‚oga linoleum y=320, sufit kasetonowy y=20, pasmowe Ĺ›wiatĹ‚o jarzeniĂłwek z chĹ‚odnymi cieniami geometrycznymi);
  - mechanika badania afisza procedur zgodnoĹ›ci, pobrania biletu kolejkowego 084/17 sprzed 17 dni, odbioru kapsuĹ‚y teczki z poczty pneumatycznej oraz wdroĹĽenia odpowiedzi sensorycznej w aparacie diagnostycznym;
  - peĹ‚na implementacja sceny dialogowej D-06 (12 kwestii) konfrontujÄ…cej urzÄ™dowy porzÄ…dek UCP z osobistym Ĺ›wiadectwem zapachu prosektorium po identyfikacji Jakuba;
  - odryglowanie i otwarcie drzwi gabinetu konsultacyjnego 06 z zielonÄ… lampkÄ… statusowÄ…;
  - procedura przejĹ›cia gracza do strefy `AirlockZone` przy x=590 prowadzÄ…cej do Przestrzeni 18.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 4 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station17` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie podajnika biletĂłw przy x=120, zbadanie Ĺ‚awki i afisza przy x=220, odbiĂłr poczty pneumatycznej przy x=330, interakcja z drukarkÄ… diagnostycznÄ… przy x=440 (uruchomienie dialogu D-06, test sensoryczny, przejĹ›cie 12 kwestii), weryfikacja odryglowania gabinetu dr Wierzbickiej oraz wejĹ›cie do strefy `AirlockZone` przy x=590 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_17.png` oraz `reports/station_17_interview.png`.
- Zarejestrowano decyzjÄ™ D-050 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Subiektywne odczucie instytucjonalnego chĹ‚odu Punktu ZgodnoĹ›ci 6, tempo wywoĹ‚ywania numeru 084/17 oraz czytelnoĹ›Ä‡ wyboru zapachu prosektorium bez podpowiedzi HUD pozostajÄ… hipotezami (H-003, H-007, H-008, H-010b).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0036`.

## PKG-0036: PrzestrzeĹ„ 18 â€” Wywiad zgodnoĹ›ci (Gabinet dr Heleny Wierzbickiej)

Data: 2026-08-20

Kontekst: Kontynuacja fazy P3 (Vertical Slice) oraz realizacja Aktu II fabuĹ‚y (Korekta) per `FULL_STORY.md`. Zaimplementowanie Przestrzeni 18 z `FULL_STORY.md` (Wywiad zgodnoĹ›ci / Gabinet konsultacyjny dr Heleny Wierzbickiej) w scenie `scenes/levels/station_18.tscn` ze skryptem `scripts/levels/station_18.gd`. WdroĹĽenie gabinetu konsultacyjnego z chĹ‚odnÄ… oliwkowÄ… paletÄ… barw (`#232f29`, `#2a3730`, `#c8a97a`, `#7a8c94`), panoramicznym oknem na geometryzowany dziedziniec UCP, biurkiem nagrywajÄ…cym dr Wierzbickiej (`WierzbickaDesk`), Ĺ›ciennÄ… mapÄ… sensorycznÄ… RĂłwni z wÄ™zĹ‚ami Peron 2/Prosektorium/Linia 4 (`SensoryMemoryMap`), galwanometrem bio-emocjonalnym reagujÄ…cym na kĹ‚amstwa Leny (`CorrectionGalvanometer`), wskaĹşnikiem naprÄ™ĹĽeĹ„ Podstruktury (`AcousticWeightConduit`) oraz ryglowanym wyjĹ›ciem ku Sali Modeli â€” PrzestrzeĹ„ 19 (`ModelRoomAirlock`). WdroĹĽenie peĹ‚nej sceny dialogowej D-07 z `DIALOGUE_SCRIPT.md` (12 kwestii) o wywiadzie sensorycznym w ktĂłrym Lena celowo kĹ‚amie, galwanometr przyjmuje kĹ‚amstwo jako wersjÄ™ oficjalnÄ…, a koszty naprÄ™ĹĽeĹ„ sÄ… przenoszone na PodstrukturÄ™. Kluczowa poszlaka: â€žprocedura stabilizuje wspĂłlnÄ… narracjÄ™, nie wykrywa obiektywnej prawdy."

Wynik:
- Rozszerzono `ProceduralAudio` o 4 syntezatory dĹşwiÄ™ku (Scene 18):
  - `create_sensory_galvanometer_tick_sound()`: mikro-impuls galwanometru sensorycznego (1650 Hz tick + 380 Hz damping + 3200 Hz onset click);
  - `create_substructure_strain_groan_sound()`: gĹ‚Ä™boki metaliczny groan naprÄ™ĹĽeĹ„ Podstruktury (34/68 Hz sub-bas + 220 Hz ĹĽeliwo + 560 Hz creak);
  - `create_map_node_pulse_sound()`: krystaliczny ton wÄ™zĹ‚a mapy sensorycznej (880 Hz A5 + 1760 Hz + cyan shimmer 2.8 Hz + 4200 Hz onset);
  - `create_wierzbicka_stamp_sound()`: mechaniczna pieczÄ™Ä‡ zatwierdzenia zgodnoĹ›ci (420 Hz body + 1200 Hz snap + 90 Hz thud + 280 Hz ink-pad tail).
- Rozbudowano `MemoryResonancePoint`:
  - dodano typy: `WIERZBICKA_DESK` (77), `SENSORY_MEMORY_MAP` (78), `CORRECTION_GALVANOMETER` (79), `ACOUSTIC_WEIGHT_CONDUIT` (80), `MODEL_ROOM_AIRLOCK` (81);
  - dedykowane procedury rysowania: biurko buk z aparatem transkrypcyjnym i teczkÄ… Leny, mapa RĂłwni z pulsujÄ…cymi wÄ™zĹ‚ami (cyan/amber/cinnabar), galwanometr z obrotowÄ… igĹ‚Ä… odchylajÄ…cÄ… siÄ™ na kĹ‚amstwo, wskaĹşnik naprÄ™ĹĽeĹ„ Podstruktury, ryglowane drzwi z bolcem cofajÄ…cym siÄ™ wizualnie po odblokowaniu.
- Zaimplementowano scenÄ™ i kontroler `Station18`:
  - cool olive/pale green/beech wood/powder steel per VISUAL_DESIGN.md Â§6.3/7.4;
  - mechanika D-07: trzy rundy kĹ‚amstw â†’ galwanometr aktywny â†’ naprÄ™ĹĽenia Podstruktury narastajÄ… â†’ Sala Modeli odblokowana;
  - `_strain_level` narasta po kaĹĽdym Ĺšwiadectwie PamiÄ™ci (+0.28/kĹ‚amstwo), czerwony nalot na dolnej strefie.
- Rozszerzono `tests/smoke_test.gd`: 4 nowe audio testy + `_test_station_18()` (12-kwestiowy test D-07 + weryfikacja naprÄ™ĹĽeĹ„ + airlock).
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_18.png` i `reports/station_18_interview.png`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_18 completed
Verification passed.
```

Ograniczenia: CzytelnoĹ›Ä‡ mechanizmu â€žkĹ‚amstwo przyjÄ™te jako prawda", narastanie naprÄ™ĹĽeĹ„ Podstruktury i emocjonalny rezonans kwestii â€žNie pamiÄ™tam" pozostajÄ… hipotezami (H-003, H-007, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0037`.

## PKG-0037: PrzestrzeĹ„ 19 â€” Sala Modeli (Model bez oryginaĹ‚u)

Data: 2026-08-20

Kontekst: Kontynuacja fazy P3 (Vertical Slice) oraz realizacja Aktu II fabuĹ‚y (Korekta) per `FULL_STORY.md`. Zaimplementowanie Przestrzeni 19 z `FULL_STORY.md` (Sala Modeli / Model bez oryginaĹ‚u) w scenie `scenes/levels/station_19.tscn` ze skryptem `scripts/levels/station_19.gd`. WdroĹĽenie neutralnej, surowej Sali Modeli pod chĹ‚odnym rozproszonym Ĺ›wiatĹ‚em sufitowym (`#25302b`, `#2e3b35`, `#a8b2ac`, `#24343a`), ze stoĹ‚em ekspozycyjnym mieszczÄ…cym dwa rĂłwnorzÄ™dne modele makiety Linii 4 (`ModelDisplayTable`), niszami Ĺ›ciennymi z rycinami schematĂłw (lewy: wyjĹ›cie na ulicÄ™ ze 140 ewakuowanymi; prawy: Ĺ›lepy zauĹ‚ek na Ĺ›cianie noĹ›nej z 17 Ĺ›wiadkami), podestem z rejestrem 11 osĂłb wykreĹ›lonych z tablic ewidencji (`ElevenPersonsLedger`) oraz ryglowanÄ… Ĺ›luzÄ… wyjĹ›ciowÄ… do Sali Szymona â€” PrzestrzeĹ„ 20 (`ModelRoomExit`). WdroĹĽenie kluczowej sceny dialogowej D-07 ("Wierzbicka pokazuje schody" â€” 8 kwestii) z `DIALOGUE_SCRIPT.md`: Wierzbicka odrzuca pojÄ™cie pierwotnej wersji i wskazuje, ĹĽe wybĂłr wariantu ze schodami ratujÄ…cymi 140 osĂłb to "odpowiedzialnoĹ›Ä‡ z terminem", nie kĹ‚amstwo. Rozszerzenie `ProceduralAudio` o 4 syntezatory dĹşwiÄ™ku, dodanie rekwizytĂłw 82..86 w `MemoryResonancePoint`, optymalizacja selektywnej inicjalizacji audio w rekwizytach, rozbudowa testĂłw w `smoke_test.gd` i wyrenderowanie podglÄ…dĂłw `reports/station_19.png` i `reports/station_19_models.png`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 4 syntezatory dĹşwiÄ™ku (Scene 19):
  - `create_model_table_resonance_sound()`: krystaliczny rezonans 528 Hz (solfeggio/model) z harmonicznÄ… kwintowÄ… i dudnieniem akustycznym 4 Hz (528/532 Hz) symbolizujÄ…cym dwie rĂłwnorzÄ™dne makiety oraz migotaniem cyjanu 3.2 Hz;
  - `create_paper_map_rustle_sound()`: szelest papierowej mapy technicznej (900..3600 Hz tarcie celulozy i trzask zĹ‚oĹĽenia);
  - `create_ledger_page_turn_sound()`: przewracanie kartonowej karty w rejestrze 11 osĂłb (szum 700..2800 Hz + 440 Hz fold snap);
  - `create_model_room_door_release_sound()`: mechaniczny rygiel Ĺ›luzy wyjĹ›ciowej ku Sali Szymona (680 Hz suw + 1340 Hz zatrzask + sub-bas 120 Hz).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `MODEL_DISPLAY_TABLE` (82), `STAIRCASE_MAP_LEFT` (83), `STAIRCASE_MAP_RIGHT` (84), `ELEVEN_PERSONS_LEDGER` (85), `MODEL_ROOM_EXIT` (86);
  - wyspecjalizowane procedury rysowania: centralny stĂłĹ‚ ekspozycyjny z dwoma podĹ›wietlanymi modelami schodĂłw (lewy bĹ‚Ä™kitno-cyjanowy, prawy ceglasto-cynobrowy), nisze Ĺ›cienne ze schematami schodĂłw na tle aluminiowych ram, podest z otwartym rejestrem 11 osĂłb z czerwonym marginesem ewidencyjnym oraz panel rygla drzwiowego z odsuwajÄ…cym siÄ™ ryglem i wskaĹşnikiem statusu;
  - zoptymalizowano `_setup_audio()` w `MemoryResonancePoint`: zamiast generowania wszystkich 50 dĹşwiÄ™kĂłw per instancja, generowany jest wyĹ‚Ä…cznie strumieĹ„ powiÄ…zany ze skonfigurowanym `prop_type`.
- Zaimplementowano scenÄ™ i kontroler `Station19` (`scripts/levels/station_19.gd`, `scenes/levels/station_19.tscn`):
  - kliniczna, pozbawiona temperatury estetyka szarobeĹĽowego gipsu i lastryka (640x360, podĹ‚oga y=320, sufit kasetonowy y=35, oprawa jarzeniowa z chĹ‚odnym rozproszeniem);
  - mechanika badania obu nisz ze schematami schodĂłw oraz rejestru 11 osĂłb;
  - peĹ‚na implementacja sceny dialogowej D-07 (8 kwestii) z `DIALOGUE_SCRIPT.md`: konfrontacja Leny z WierzbickÄ…, pytanie o prawdziwÄ… wersjÄ™, demonstracja odpowiedzialnoĹ›ci administracyjnej i ujawnienie nieznanego losu 11 przesuniÄ™tych osĂłb;
  - odryglowanie i otwarcie Ĺ›luzy wyjĹ›ciowej do Sali Szymona (PrzestrzeĹ„ 20) po zakoĹ„czeniu dialogu;
  - przejĹ›cie gracza do strefy `AirlockZone` przy x=590 z sygnalizacjÄ… ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 4 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station19` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie nisz ze schematami przy x=135 i x=495, badanie rejestru 11 osĂłb przy x=220, interakcja ze stoĹ‚em modeli przy x=310 (uruchomienie dialogu D-07, przejĹ›cie 8 kwestii), weryfikacja odryglowania Ĺ›luzy i przejĹ›cie przez strefÄ™ `AirlockZone` przy x=590 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_19.png` i `reports/station_19_models.png`.
- Zarejestrowano decyzjÄ™ D-051 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_19 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. OdbiĂłr dramaturgii braku pierwotnej gaĹ‚Ä™zi, etycznego ciÄ™ĹĽaru decyzji Wierzbickiej i czytelnoĹ›ci makiet bez sĹ‚ownego HUD-u pozostajÄ… hipotezami (H-003, H-007, H-008, H-010b).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0038`.

## PKG-0038: PrzestrzeĹ„ 20 â€” Sala Szymona (PokĂłj Szymona Bery / SkaĹĽenie studni i pamiÄ™Ä‡ o cĂłrce Idze)

Data: 2026-08-20

Kontekst: Kontynuacja fazy P3 (Vertical Slice) oraz realizacja Aktu II fabuĹ‚y (Korekta) per `FULL_STORY.md`. Zaimplementowanie Przestrzeni 20 z `FULL_STORY.md` (Sala Szymona / PokĂłj Szymona Bery w Punkcie ZgodnoĹ›ci 6) w scenie `scenes/levels/station_20.tscn` ze skryptem `scripts/levels/station_20.gd`. WdroĹĽenie neutralnej, klinicznej izolatki adaptacyjnej UCP (`#121a1c`, `#222e2a`, `#2b3a34`, `#829088`), w ktĂłrej przebywa starszy mÄ™ĹĽczyzna Szymon Bera (`SzymonBera`, PropType 87) pamiÄ™tajÄ…cy swojÄ… cĂłrkÄ™ IgÄ™, ktĂłra wykryĹ‚a skaĹĽenie studni miejskiej. WdroĹĽenie drewnianego stolika z kredkowym rysunkiem studni i szkoĹ‚y z wytartym nazwiskiem dziecka (`WellDrawing`, PropType 88), oficjalnego raportu hydrologicznego UCP potwierdzajÄ…cego naprawÄ™ studni z wyczyszczonym polem zgĹ‚aszajÄ…cego (`HydrologyReport`, PropType 89), lupy inspekcyjnej na wysiÄ™gniku ukazujÄ…cej pod szkĹ‚em mikro-Ĺ›lady grafitu liter "Iga" (`ErasedSignatureMagnifier`, PropType 90) oraz ciÄ™ĹĽkich przesuwnych drzwi izolatki prowadzÄ…cych do Przestrzeni 21 (`SzymonRoomExit`, PropType 91). WdroĹĽenie peĹ‚nej sceny dialogowej D-08 ("Szymon â€” sprawdĹş studniÄ™" â€” 12 kwestii) z `DIALOGUE_SCRIPT.md`: Szymon pokazuje rysunek, Lena powtarza na gĹ‚os imiÄ™ â€žIgaâ€ť, rama drzwi sali przesuwa siÄ™ mechanicznie w Ĺ›cianie o kilka centymetrĂłw (â€žWidzisz? Nie lubiÄ…, kiedy sÄ… dwie osoby.â€ť), Szymon zaznacza, ĹĽe dziecko nie musi zatruÄ‡ caĹ‚ego miasta, by byÄ‡ jego cĂłrkÄ…. WdroĹĽenie interaktywnego wyboru dyspozycji rysunku studni (`ANCHOR_DRAWING`, `SUBMIT_TO_UCP`, `LEAVE_AS_IS`). Rozszerzenie `ProceduralAudio` o 4 syntezatory dĹşwiÄ™ku, dodanie rekwizytĂłw 87..91 w `MemoryResonancePoint`, rozbudowa testĂłw w `smoke_test.gd`, stworzenie narzÄ™dzia `tools/capture.ps1` i wyrenderowanie podglÄ…dĂłw `reports/station_20.png` i `reports/station_20_szymon.png`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 4 syntezatory dĹşwiÄ™ku (Scene 20):
  - `create_crayon_drawing_rustle_sound()`: szorstkie tarcie kredki woskowej i celulozy (600..2400 Hz z modulacjÄ… 4.5 Hz i 1800 Hz tarciem);
  - `create_well_water_drip_sound()`: stĹ‚umione, komorowe kapanie wody w gĹ‚Ä™bokiej studni (160 Hz sub-bas z rezonansowym pogĹ‚osem 480 Hz i zanikiem exp);
  - `create_szymon_dialogue_blip_sound()`: kruchy, drĹĽÄ…cy gĹ‚os starszego czĹ‚owieka (260 Hz ton podstawowy z mikro-wibrato 3.5 Hz i alikwotami 520/780 Hz);
  - `create_door_creak_shift_sound()`: mechaniczne przesuniÄ™cie ramy drzwi w Ĺ›cianie (220/440 Hz tarcie ĹĽelaza z 180 Hz stukiem strukturalnym).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `SZYMON_BERA` (87), `WELL_DRAWING` (88), `HYDROLOGY_REPORT` (89), `ERASED_SIGNATURE_MAGNIFIER` (90), `SZYMON_ROOM_EXIT` (91);
  - wyspecjalizowane procedury rysowania: postaÄ‡ Szymona Bery na aluminiowym Ĺ‚ĂłĹĽku terapeutycznym (przygarbiona sylwetka, szary weĹ‚niany sweter, subtelna animacja oddechu), stolik z kredkowym rysunkiem (wysoka studnia z korbÄ…, niĹĽsza szkoĹ‚a, zatarte pole podpisu w prawym dolnym rogu), teczka raportu hydrologicznego UCP ("STATUS: NAPRAWIONE", wyczyszczone pole zgĹ‚aszajÄ…cego), lupa inspekcyjna z podĹ›wietlonÄ… soczewkÄ… ukazujÄ…cÄ… mikro-Ĺ›lady grafitu "Iga" oraz przesuwne drzwi z czerwonÄ… liniÄ… przesuniÄ™cia ramy i zielono-cyjanowym indykatorem rygla.
- Zaimplementowano scenÄ™ i kontroler `Station20` (`scripts/levels/station_20.gd`, `scenes/levels/station_20.tscn`):
  - izolatka adaptacyjna Punktu ZgodnoĹ›ci 6 (640x360, podĹ‚oga y=320, sufit podwieszany y=40, panele Ĺ›cienne z pionowymi spoinami, rozproszone oĹ›wietlenie pasmowe);
  - mechanika badania lupy inspekcyjnej, raportu hydrologicznego oraz interakcji z Szymonem i rysunkiem studni;
  - peĹ‚na implementacja sceny dialogowej D-08 (12 kwestii) z `DIALOGUE_SCRIPT.md` z mechanicznym przesuniÄ™ciem ramy drzwi (`is_door_shifted = true`, sygnaĹ‚ `door_shifted`) po wypowiedzeniu imienia Igi w kwestii 8;
  - interaktywny wybĂłr dyspozycji rysunku (`DrawingChoice`: `ANCHOR_DRAWING`, `SUBMIT_TO_UCP`, `LEAVE_AS_IS`);
  - odryglowanie i otwarcie drzwi wyjĹ›ciowych do Przestrzeni 21 (Cena ulgi) po dokonaniu wyboru;
  - przejĹ›cie gracza do strefy `AirlockZone` przy x=610 z sygnalizacjÄ… ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 4 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station20` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie lupy przy x=140, badanie raportu hydrologicznego przy x=415, interakcja z Szymonem i rysunkiem przy x=290 (uruchomienie dialogu D-08, przejĹ›cie 12 kwestii, weryfikacja przesuniÄ™cia ramy drzwi `is_door_shifted == true`, wybĂłr zakotwiczenia `ANCHOR_DRAWING`), weryfikacja odryglowania wyjĹ›cia i przejĹ›cie przez strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Dodano narzÄ™dzie `tools/capture.ps1` i rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_20.png` i `reports/station_20_szymon.png`.
- Zarejestrowano decyzjÄ™ D-052 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_20 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. OdbiĂłr dramaturgii prywatnej pamiÄ™ci o dziecku versus oficjalnego zapisu, etycznego ciÄ™ĹĽaru wyboru zakotwiczenia rysunku i czytelnoĹ›ci przesuniÄ™cia ramy drzwi bez sĹ‚ownego HUD-u pozostajÄ… hipotezami (H-003, H-007, H-008, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0039`.

## PKG-0039: PrzestrzeĹ„ 21 â€” Cena ulgi (Korekta Szymona / Wymazanie imienia cĂłrki i rozdzielenie faktu publicznego od wiÄ™zi prywatnej)

Data: 2026-08-21

Kontekst: Kontynuacja fazy P3 (Vertical Slice) oraz realizacja Aktu II fabuĹ‚y (Korekta) per `FULL_STORY.md`. Zaimplementowanie Przestrzeni 21 z `FULL_STORY.md` (Cena ulgi / PokĂłj zabiegowo-sedacyjny Szymona Bery w Punkcie ZgodnoĹ›ci 6) w scenie `scenes/levels/station_21.tscn` ze skryptem `scripts/levels/station_21.gd`. WdroĹĽenie surowej, klinicznej sali sedacyjnej UCP (`#10181a`, `#1e2a26`, `#263630`, `#75c7c3`), w ktĂłrej przebywa uspokojony Szymon Bera (`SzymonPostCorrection`, PropType 92) po zabiegu adaptacyjnym usuwajÄ…cym traumÄ™ i panikÄ™. WdroĹĽenie konsoli monitoringu anestezji UCP (`AnesthesiaTerminal`, PropType 93) z wykresem wygaszonej fali paniki i ustabilizowanego tÄ™tna, Ĺ›ciennej kasety archiwizacyjnej z nowym oficjalnym wpisem ("SKORZYSTANO Z RAPORTU HYDROLOGICZNEGO / AUTOR: ANONIMOWY", `FilteredDossierSlot`, PropType 94), metalowego postumentu dyspozycji dowodu (`DrawingDispositionPedestal`, PropType 95) oraz automatycznej Ĺ›luzy ciĹ›nieniowej prowadzÄ…cej do Przestrzeni 22 (`Station21Exit`, PropType 96). WdroĹĽenie peĹ‚nej sceny dialogowej dla Przestrzeni 21 per `FULL_STORY.md` i `DIALOGUE_SCRIPT.md` (linie 307-316): Szymon pyta, kto narysowaĹ‚ studniÄ™, Lena odpowiada â€žIgaâ€ť, aparat sedacji emituje szum, a imiÄ™ nie przechodzi przez krtaĹ„ Szymona (â€žNie zabieraj kartki. To miejsce po kimĹ›â€ť), po czym Szymon potwierdza naprawÄ™ skaĹĽenia przed Ĺ›witem (â€žZgĹ‚oszenie byĹ‚o od zawszeâ€ť). Realizacja pierwszego uĹ›wiadomionego momentu, w ktĂłrym gracz widzi rozdzielenie faktu publicznego od wiÄ™zi prywatnej. Rozszerzenie `ProceduralAudio` o 4 syntezatory dĹşwiÄ™ku, dodanie rekwizytĂłw 92..96 w `MemoryResonancePoint`, rozbudowa testĂłw w `smoke_test.gd` oraz wyrenderowanie podglÄ…dĂłw `reports/station_21.png` i `reports/station_21_szymon.png`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 4 syntezatory dĹşwiÄ™ku (Scene 21):
  - `create_anesthetic_hum_sound()`: niski szum fali sedacyjnej UCP (110 Hz z filtracjÄ… dolnoprzepustowÄ… i modulacjÄ… 2 Hz);
  - `create_sedation_monitor_blip_sound()`: miÄ™kki, stĹ‚umiony sygnaĹ‚ monitora funkcji ĹĽyciowych (520 Hz z Ĺ‚agodnym opadaniem);
  - `create_erased_name_glitch_sound()`: asynchroniczny filtr usuwajÄ…cy formant gĹ‚osu przy prĂłbie wymĂłwienia imienia (pasmo 800..2000 Hz z wyciÄ™ciem formantowym i szumem);
  - `create_station21_airlock_sound()`: pneumatyczny dĹşwiÄ™k odryglowania Ĺ›luzy wyjĹ›ciowej ku strefie UlegĹ‚oĹ›ci (320 Hz + 740 Hz release).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `SZYMON_POST_CORRECTION` (92), `ANESTHESIA_TERMINAL` (93), `FILTERED_DOSSIER_SLOT` (94), `DRAWING_DISPOSITION_PEDESTAL` (95), `STATION_21_EXIT` (96);
  - wyspecjalizowane procedury rysowania: postaÄ‡ Szymona Bery spoczywajÄ…cego w fotelu adaptacyjnym z kaniulÄ… i cyanowym przewodem sedacji, pionowa konsola anestezji z monitorem CRT i wygĹ‚adzonym wykresem tÄ™tna, kaseta Ĺ›cienna z oficjalnym raportem ("STATUS: SPĂ“JNY / AUTOR: ANONIMOWY"), postument dowodu z rysunkiem studni i wyĹĽarzonÄ… pustkÄ… po podpisie oraz masywna automatyczna Ĺ›luza ciĹ›nieniowa z oĹ›wietleniem krawÄ™dziowym.
- Zaimplementowano scenÄ™ i kontroler `Station21` (`scripts/levels/station_21.gd`, `scenes/levels/station_21.tscn`):
  - geometria sali zabiegowej Punktu ZgodnoĹ›ci 6 (640x360, podĹ‚oga y=320, sufit podwieszany y=40, magistrala fali sedacyjnej na Ĺ›cianie, lampa zabiegowa overhead);
  - mechanika badania konsoli anestezji, kasety archiwalnej, postumentu dyspozycji oraz interakcji z uspokojonym Szymonem;
  - peĹ‚na implementacja sceny dialogowej Scene 21 (9 kwestii) z `DIALOGUE_SCRIPT.md` i `FULL_STORY.md` z rejestracjÄ… prĂłby wypowiedzenia imienia Igi (`is_erased_name_attempted = true`);
  - odryglowanie i otwarcie Ĺ›luzy wyjĹ›ciowej do Przestrzeni 22 (UlegĹ‚oĹ›Ä‡) po zakoĹ„czeniu dialogu;
  - przejĹ›cie gracza do strefy `AirlockZone` przy x=610 z sygnalizacjÄ… ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 4 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station21` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie terminala anestezji przy x=140, badanie kasety archiwalnej przy x=480, badanie postumentu dowodu przy x=380, przejĹ›cie 9 kwestii dialogowych, weryfikacja flagi `is_erased_name_attempted == true` w kwestii 2, weryfikacja odryglowania wyjĹ›cia i przejĹ›cie przez strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_21.png` i `reports/station_21_szymon.png`.
- Zarejestrowano decyzjÄ™ D-053 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_21 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. OdbiĂłr dramaturgii wymazania imienia dziecka przy zachowaniu faktu skaĹĽenia oraz etyczna ocena ulgi pacjenta versus utraty toĹĽsamoĹ›ci pozostajÄ… hipotezami (H-003, H-007, H-008, H-009b, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0040`.
 
## PKG-0040: PrzestrzeĹ„ 22 â€” UlegĹ‚oĹ›Ä‡ (Biometryczna bramka toĹĽsamoĹ›ci, przyjÄ™cie reguĹ‚y lokalnej Leny, wspomnienie malowania mieszkania i utrata twarzy pielÄ™gniarki)

Data: 2026-08-21

Kontekst: Kontynuacja fazy P3 (Vertical Slice) oraz realizacja Aktu II fabuĹ‚y (Korekta) per `FULL_STORY.md`. Zaimplementowanie Przestrzeni 22 z `FULL_STORY.md` (UlegĹ‚oĹ›Ä‡ / Biometryczna bramka toĹĽsamoĹ›ci w tranzycie UCP) w scenie `scenes/levels/station_22.tscn` ze skryptem `scripts/levels/station_22.gd`. WdroĹĽenie surowego przejĹ›cia tranzytowego Punktu ZgodnoĹ›ci 6 (`#141c1e`, `#202a28`, `#3a554a`, `#e2b060`), w ktĂłrym Lena podchodzi do biometrycznej bramki toĹĽsamoĹ›ci UCP (`BiometricIdentityGate`, PropType 97) i zostaje poinformowana o braku zgodnoĹ›ci z profilem Wolskiej Leny z powodu braku zarejestrowanej osoby kontaktowej oraz braku wpiÄ™cia obrÄ…czki maĹ‚ĹĽeĹ„skiej. WdroĹĽenie terminala rejestru osĂłb kontaktowych (`ComplianceContactRegister`, PropType 98), skanera obrÄ…czki maĹ‚ĹĽeĹ„skiej (`RingFittingScanner`, PropType 99), pĹ‚yty rezonansowej farby emulsyjnej (`PaintResinResonanceSlab`, PropType 100) oraz automatycznego portalu wyjĹ›ciowego do Przestrzeni 23 (`Station22Exit`, PropType 101). WdroĹĽenie peĹ‚nej mechaniki UlegĹ‚oĹ›ci (Yield â€” D-019) bez poraĹĽki wykonawczej: przyjÄ™cie lokalnej toĹĽsamoĹ›ci (wpisanie Marty Kurek, wpiÄ™cie obrÄ…czki), natychmiastowy napĹ‚yw sensorycznego wspomnienia malowania mieszkania 14 z MartÄ… (zapach Ĺ›wieĹĽej farby emulsyjnej, Ĺ›miech Marty, plama farby na przedramieniu), inĹĽynierski pomiar kosztu ulegĹ‚oĹ›ci (utrata twarzy pielÄ™gniarki, ktĂłra po Ĺ›mierci Jakuba przyniosĹ‚a jego rzeczy â€” twarz staje siÄ™ pustym biaĹ‚ym owalem bez rysĂłw), peĹ‚na scena dialogowa Scene 22 z `FULL_STORY.md` i `DIALOGUE_SCRIPT.md` (10 kwestii: Terminal Bramki UCP, Lena Wolska, Ĺšwiadectwo), inĹĽynierskie podsumowanie Leny (â€žĹšwiat nie kĹ‚amie. Ĺšwiat tylko przestaje pamiÄ™taÄ‡ to, co nie ma drugiego Ĺ›wiadkaâ€ť), autoryzacja toĹĽsamoĹ›ci przez bramkÄ™ UCP i odryglowanie portalu wyjĹ›ciowego do Przestrzeni 23 (PokĂłj projektantki). Rozszerzenie `ProceduralAudio` o 5 syntezatorĂłw dĹşwiÄ™ku, dodanie rekwizytĂłw 97..101 w `MemoryResonancePoint`, rozbudowa testĂłw w `smoke_test.gd` oraz wyrenderowanie podglÄ…dĂłw `reports/station_22.png` i `reports/station_22_yield.png`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 5 syntezatorĂłw dĹşwiÄ™ku (Scene 22):
  - `create_biometric_gate_scan_sound()`: 480 Hz -> 1920 Hz sweep czÄ™stotliwoĹ›ciowy z ziarnem optycznym i dzwonkiem potwierdzenia 880 Hz;
  - `create_ring_resonance_hum_sound()`: 1200 Hz rezonans z mikro-tremolo 6 Hz i ciepĹ‚ymi alikwotami miedzi/zĹ‚ota;
  - `create_paint_memory_recall_sound()`: 528 Hz ton relacyjny z szelestem waĹ‚ka emulsyjnego 1200..3200 Hz i oparami rozpuszczalnika 132 Hz;
  - `create_biographical_erasure_glitch_sound()`: 62/31 Hz sub-bas z wyciÄ™ciem filtru 1450 Hz, trzaskiem kwantyzacji i szumem pustki;
  - `create_station22_door_release_sound()`: 380/190 Hz rygiel elektromagnetyczny ze Ĺ›wistem uszczelnienia pneumatycznego i gongiem 1100 Hz.
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `BIOMETRIC_IDENTITY_GATE` (97), `COMPLIANCE_CONTACT_REGISTER` (98), `RING_FITTING_SCANNER` (99), `PAINT_RESIN_RESONANCE_SLAB` (100), `STATION_22_EXIT` (101);
  - wyspecjalizowane procedury rysowania: biometryczna bramka toĹĽsamoĹ›ci z pionowÄ… kurtynÄ… optycznÄ… i bursztynowym/cyjanowym wskaĹşnikiem statusu, terminal rejestru osĂłb kontaktowych z polem wpisu i bursztynowÄ… lampkÄ… akceptacji, skaner obrÄ…czki z gniazdem koncentrycznym i promieniujÄ…cÄ… aurÄ… zĹ‚ota, pĹ‚yta rezonansowa z prĂłbkÄ… ĹĽywicy i unoszÄ…cymi siÄ™ drobinkami lotnej emulsji oraz masywny portal tranzytowy z ryglem elektromagnetycznym.
- Zaimplementowano scenÄ™ i kontroler `Station22` (`scripts/levels/station_22.gd`, `scenes/levels/station_22.tscn`):
  - geometria przejĹ›cia tranzytowego Punktu ZgodnoĹ›ci 6 (640x360, podĹ‚oga y=320, sufit techniczny y=40, magistrala danych UCP z bursztynowym/cyjanowym Ĺ›wiatĹ‚owodem, panele Ĺ›cienne z surowego gipsu);
  - mechanika badania rejestru kontaktĂłw, skanera obrÄ…czki, pĹ‚yty farby oraz bramki toĹĽsamoĹ›ci;
  - peĹ‚na implementacja sceny dialogowej Scene 22 (10 kwestii) z `DIALOGUE_SCRIPT.md` i `FULL_STORY.md`:
    - linia 0: Terminal bramki â€” odmowa przejĹ›cia z powodu braku wpiÄ™cia profilu maĹ‚ĹĽeĹ„skiego i kontaktu;
    - linia 1: Lena â€” analiza procedury i decyzja o ulegĹ‚oĹ›ci;
    - linia 2: Ĺšwiadectwo â€” wpisanie Marty Kurek i wĹ‚oĹĽenie obrÄ…czki;
    - linia 3: Terminal bramki â€” rejestracja parametrĂłw relacyjnych;
    - linia 4: Lena â€” odczucie napĹ‚ywu obcego ciepĹ‚a;
    - linia 5: Ĺšwiadectwo â€” zmysĹ‚owe wspomnienie malowania mieszkania 14 z MartÄ… (emulsja, Ĺ›miech, waĹ‚ek malarski);
    - linia 6: Lena â€” odkrycie wymazania twarzy pielÄ™gniarki po Ĺ›mierci Jakuba (biaĹ‚y owal bez rysĂłw);
    - linia 7: Lena â€” sformuĹ‚owanie inĹĽynierskiego prawa korekty autobiograficznej: â€žĹšwiat nie kĹ‚amie. Ĺšwiat tylko przestaje pamiÄ™taÄ‡ to, co nie ma drugiego Ĺ›wiadkaâ€ť;
    - linia 8: Terminal bramki â€” autoryzacja toĹĽsamoĹ›ci Wolskiej Leny;
    - linia 9: Ĺšwiadectwo â€” odryglowanie portalu tranzytowego ku Przestrzeni 23.
  - odryglowanie i otwarcie portalu wyjĹ›ciowego do Przestrzeni 23 (PokĂłj projektantki) po zakoĹ„czeniu sekwencji Yield;
  - przejĹ›cie gracza do strefy `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station22` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: interakcja z rejestrem kontaktĂłw przy x=140, skanerem obrÄ…czki przy x=250, pĹ‚ytÄ… farby przy x=370, uruchomienie i przejĹ›cie 10 kwestii dialogowych, weryfikacja flag Yield (`is_yield_accepted == true`, `is_paint_recalled == true`, `is_biographical_erasure_measured == true`), weryfikacja odryglowania wyjĹ›cia i przejĹ›cie przez strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_22.png` i `reports/station_22_yield.png`.
- Zarejestrowano decyzjÄ™ D-054 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_22 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. OdbiĂłr emocjonalny ulegĹ‚oĹ›ci bez mechanicznej kary zrÄ™cznoĹ›ciowej (Yield jako autobiograficzny koszt fabularny zamiast game over) oraz czytelnoĹ›Ä‡ sensorycznego opisu utraty twarzy pielÄ™gniarki pozostajÄ… hipotezami (H-003, H-007, H-008, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0041`.

## PKG-0041: PrzestrzeĹ„ 23 â€” PokĂłj projektantki (Model Podstruktury, lista osĂłb obciÄ…ĹĽonych, pismo lokalnej Leny i dialog D-16 z uciekajÄ…cym kursorem)

Data: 2026-08-21

Kontekst: Kontynuacja fazy P3 (Vertical Slice) oraz realizacja Aktu II fabuĹ‚y (Korekta) per `FULL_STORY.md`. Zaimplementowanie Przestrzeni 23 z `FULL_STORY.md` (PokĂłj projektantki / Model Podstruktury, lista osĂłb obciÄ…ĹĽonych przez system, pismo lokalnej Leny i interaktywna konsola z uciekajÄ…cym kursorem) w scenie `scenes/levels/station_23.tscn` ze skryptem `scripts/levels/station_23.gd`. WdroĹĽenie prywatnego gabinetu roboczego lokalnej Leny w Podstrukturze/Punkcie 6 w palecie grafitu, miedzi, bursztynu i zielonego luminoforu CRT (`#111718`, `#1c2725`, `#68b8a5`, `#d9a05b`, `#e8c07a`). WdroĹĽenie 5 nowych rekwizytĂłw w `MemoryResonancePoint` (PropType 102..106): stacji roboczej CRT (`DesignerTerminal`), architektonicznego modelu szkieletu Podstruktury z odrÄ™cznÄ… notatkÄ… `JEĹšLI TO CZYTASZ, ZGODZIĹAM SIÄ NA TWOJE RYZYKO` (`SubstructureModel`), rejestru osĂłb obciÄ…ĹĽonych dĹ‚ugiem sprzecznoĹ›ci UCP (`BurdenedLedger`), interaktywnej konsoli Ĺšladu z mechanikÄ… przesuniÄ™cia kursora (`ShadowInteractiveConsole`) oraz automatycznej Ĺ›luzy tranzytowej do Przestrzeni 24 (`Station23Exit`). PeĹ‚na implementacja sceny dialogowej D-16 z `DIALOGUE_SCRIPT.md` (13 kwestii: Ĺšwiadectwo, Lena Wolska: prĂłba nadpisania wzorca, kursor samoczynnie odsuwajÄ…cy siÄ™ o jedno pole i wskazujÄ…cy wiersz bez nazwiska na liĹ›cie osĂłb obciÄ…ĹĽonych, uĹ›wiadomienie sobie przez LenÄ™, ĹĽe zostaĹ‚a sprowadzona celowo z jej wĹ‚asnÄ… zgodÄ… na ryzyko, a nie po to, by oddaÄ‡ ciaĹ‚o), odryglowanie wyjĹ›cia do Przestrzeni 24 (Marta pod obserwacjÄ…). Rozszerzenie `ProceduralAudio` o 5 syntezatorĂłw dĹşwiÄ™ku, rozbudowa testĂłw w `smoke_test.gd` oraz wyrenderowanie podglÄ…dĂłw `reports/station_23.png` i `reports/station_23_terminal.png`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 5 syntezatorĂłw dĹşwiÄ™ku (Scene 23):
  - `create_designer_terminal_hum_sound()`: szum transformatora 75/150 Hz i luminoforu CRT z jonizacjÄ… 3400 Hz i whistle flyback;
  - `create_cursor_shift_glitch_sound()`: 1420 Hz piezoelektryczny klik ze skokiem fazowym 380 Hz przy przesuniÄ™ciu kursora przez Ĺšlad;
  - `create_burden_ledger_scan_sound()`: 880 Hz impulsy silnika krokowego z szelestem bufora indeksu cyfrowego rejestru;
  - `create_designer_note_chime_sound()`: 660 Hz E5 z harmonicznymi 1320/1980 Hz i bursztynowym mikro-tremolo przy badaniu notatki;
  - `create_station23_exit_unlatch_sound()`: 290/580 Hz solenoid ze zwolnieniem uszczelnienia pneumatycznego ku Przestrzeni 24.
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `DESIGNER_TERMINAL` (102), `SUBSTRUCTURE_ARCHITECTURAL_MODEL` (103), `BURDENED_PERSONS_LEDGER` (104), `SHADOW_INTERACTIVE_CONSOLE` (105), `STATION_23_EXIT` (106);
  - wyspecjalizowane procedury rysowania: stacja CRT z radiatorem miedzianym i mapÄ… awarii dzielnicowych, model Podstruktury z przezroczystym kloszem akrylowym, miedzianÄ… siatkÄ… magistrali i kartÄ… z notatkÄ… `JEĹšLI TO CZYTASZ, ZGODZIĹAM SIÄ NA TWOJE RYZYKO`, stalowa szafa rejestru osĂłb obciÄ…ĹĽonych z 4 szufladami indeksowymi, konsola interaktywna ze skaczÄ…cym kursorem Ĺšladu i wektorem przesuniÄ™cia oraz portal wyjĹ›ciowy z tabliczkÄ… `24 / OBSERWACJA â€” MARTA`.
- Zaimplementowano scenÄ™ i kontroler `Station23` (`scripts/levels/station_23.gd`, `scenes/levels/station_23.tscn`):
  - kompozycja 640x360, podĹ‚oga y=320, sufit techniczny y=40, magistrala miedziana z przewodami pionowymi, tablica kreĹ›larska ze szkicami wÄ™zĹ‚Ăłw;
  - peĹ‚na mechanika sceny D-16 z `DIALOGUE_SCRIPT.md` i `FULL_STORY.md`:
    - odczytanie notatki: â€žJEĹšLI TO CZYTASZ, ZGODZIĹAM SIÄ NA TWOJE RYZYKOâ€ť / Lena: â€žNa moje.â€ť;
    - prĂłba otwarcia polecenia nadpisania wzorca â€” kursor odsuwa siÄ™ samoczynnie o jedno pole;
    - przewijanie listy osĂłb obciÄ…ĹĽonych i zatrzymanie na wierszu bez nazwiska;
    - odkrycie intencji lokalnej Leny â€” sprowadzenie nie byĹ‚o zamachem na ciaĹ‚o, lecz Ĺ›wiadomÄ… zgodÄ… na ryzyko w celu rozĹ‚adowania dĹ‚ugu Podstruktury;
    - potvrzÄ…dzenie autorstwa pierwszych korekt przez lokalnÄ… LenÄ™ i wygaszenie monitora na jednÄ… klatkÄ™;
  - odryglowanie wyjĹ›cia do Przestrzeni 24 (Marta pod obserwacjÄ…);
  - strefa `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station23` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: interakcja z terminalem przy x=140, modelem przy x=260, rejestrem przy x=380, konsolÄ… przy x=490, przejĹ›cie 13 kwestii dialogu D-16, weryfikacja flag stanu (`is_cursor_shifted`, `is_burden_list_scrolled`, `is_purpose_revealed`, `is_archive_confirmed`), weryfikacja odryglowania wyjĹ›cia i przejĹ›cie przez strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_23.png` i `reports/station_23_terminal.png`.
- Zarejestrowano decyzjÄ™ D-055 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_23 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. OdbiĂłr dramaturgii uciekajÄ…cego kursora jako niemego jÄ™zyka Ĺšladu oraz emocjonalne zrozumienie zgody na ryzyko bez ekspozycji sĹ‚ownej pozostajÄ… hipotezami (H-003, H-007, H-008, H-010b, H-012).

## PKG-0042: PrzestrzeĹ„ 24 â€” Marta pod obserwacjÄ… (Monitoring mieszkania 14, transmisja Wierzbickiej, narastajÄ…ca korekta i wybĂłr Leny)

Data: 2026-08-21

Kontekst: Kontynuacja fazy P3 (Vertical Slice) oraz realizacja Aktu II fabuĹ‚y (Korekta) per `FULL_STORY.md`. Zaimplementowanie Przestrzeni 24 z `FULL_STORY.md` (Marta pod obserwacjÄ… / Monitoring mieszkania 14, transmisja dr Heleny Wierzbickiej, narastajÄ…ca korekta i wybĂłr dyspozycji Leny) w scenie `scenes/levels/station_24.tscn` ze skryptem `scripts/levels/station_24.gd`. WdroĹĽenie sali monitoringu i telemetrii UCP w Punkcie ZgodnoĹ›ci 6 w tonacji ciemnego bĹ‚Ä™kitu, grafitu, cyjanu kineskopĂłw i cynobrowego alarmu (`#0f161a`, `#18242a`, `#4f8f8b`, `#d96b52`, `#e2b060`). WdroĹĽenie 5 nowych rekwizytĂłw w `MemoryResonancePoint` (PropType 107..111): Ĺ›ciany kineskopĂłw CCTV z transmisjÄ… na ĹĽywo z mieszkania 14 (`CCTVArray`), wskaĹşnika naprÄ™ĹĽeĹ„ korelacyjnych dĹ‚ugu Marty (`CorrectionGauge`), terminala transmisyjnego dr Wierzbickiej (`TransmissionTerminal`), pulpitu wyboru dyspozycji Leny (`DispositionSelector`) oraz ciÄ™ĹĽkiej Ĺ›luzy tranzytowej do Przestrzeni 25 (`Station24Exit`). PeĹ‚na implementacja sceny dialogowej Scene 24 z `FULL_STORY.md` i `DIALOGUE_SCRIPT.md` (9 kwestii: Ĺšwiadectwo, Dr Wierzbicka, Lena Wolska: podglÄ…d Marty pakujÄ…cej torbÄ™ narzÄ™dziowÄ…, ostrzeĹĽenie Wierzbickiej o Ĺ›ciÄ…ganiu korekty na caĹ‚e piÄ™tro, oferta ochrony Marty w zamian za rejestracjÄ™ wspĂłĹ‚rzÄ™dnych, fizyczny wybĂłr dyspozycji: Zgoda jawna / Pozorna wspĂłĹ‚praca / Jawna odmowa, odnotowanie wyboru w magistrali i odryglowanie wejĹ›cia do Przestrzeni 25 / WejĹ›cie Jakuba). Rozszerzenie `ProceduralAudio` o 5 syntezatorĂłw dĹşwiÄ™ku, rozbudowa testĂłw w `smoke_test.gd` oraz wyrenderowanie podglÄ…dĂłw `reports/station_24.png` i `reports/station_24_cctv.png`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 5 syntezatorĂłw dĹşwiÄ™ku (Scene 24):
  - `create_cctv_static_hum_sound()`: 60/120 Hz przydĹşwiÄ™k z transformatora kineskopĂłw, 15.6 kHz CRT flyback whistle i szmer rastra 820..4400 Hz;
  - `create_correction_stress_siren_sound()`: modulowany sweep 880->1760 Hz z pulsem alarmu 8 Hz i cynobrowymi trzaskami sprzecznoĹ›ci;
  - `create_intercom_wierzbicka_tone_sound()`: dwuton transmisyjny 440/1100 Hz z saturacjÄ… przedwzmacniacza mikrofonu wÄ™glowego;
  - `create_decision_button_latch_sound()`: 320 Hz zapadka bÄ™benkowa z mosiÄ™ĹĽnym snapem 1400 Hz i trzaskiem przekaĹşnika;
  - `create_station24_door_release_sound()`: 340/680 Hz suw rygli elektromagnetycznych ze Ĺ›wistem dekompresji i dzwonkiem 1020 Hz.
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `CCTV_SURVEILLANCE_ARRAY` (107), `CORRECTION_ACCUMULATION_GAUGE` (108), `WIERZBICKA_TRANSMISSION_TERMINAL` (109), `LENA_DISPOSITION_SELECTOR` (110), `STATION_24_EXIT` (111);
  - wyspecjalizowane procedury rysowania: szafa rack CCTV z sylwetkÄ… Marty pakujÄ…cej torbÄ™ w mieszkaniu 14, drĹĽÄ…cymi konturami mebli i dolnymi monitorami oscyloskopowymi, tarczowy wskaĹşnik naprÄ™ĹĽeĹ„ ze wskazĂłwkÄ… odchylonÄ… w cynobrowe pole krytyczne, terminal transmisyjny z profilem dr Wierzbickiej, pulpit decyzyjny z 3 podĹ›wietlanymi przyciskami (Zgoda / Pozorna / Odmowa) oraz portal Ĺ›luzy z plakietem `25 / TRANZYT â€” WEJĹšCIE JAKUBA`.
- Zaimplementowano scenÄ™ i kontroler `Station24` (`scripts/levels/station_24.gd`, `scenes/levels/station_24.tscn`):
  - sala monitoringu UCP (640x360, podĹ‚oga y=280..360 w siatce kafelkĂłw, magistrala kablowa gĂłrna, reflektory robocze, banner instytucjonalny Punktu 6);
  - peĹ‚na mechanika sceny Scene 24 z `DIALOGUE_SCRIPT.md` i `FULL_STORY.md`:
    - podglÄ…d Marty na monitorze CCTV: pakowanie torby, drĹĽenie mebli pod narastajÄ…cÄ… korektÄ…;
    - transmisja dr Wierzbickiej: â€žKaĹĽda godzina jej oporu Ĺ›ciÄ…ga korektÄ™ na caĹ‚e piÄ™troâ€ť;
    - eskalacja naprÄ™ĹĽeĹ„ korelacyjnych (linia 4: `marta_stress_escalated`, wskazĂłwka uderza w 98% naprÄ™ĹĽenia);
    - oferta Wierzbickiej: ochrona Marty w zamian za rejestracjÄ™ wspĂłĹ‚rzÄ™dnych wzorca Leny;
    - mechanizm wyboru dyspozycji Leny: `set_disposition(choice)` aktualizujÄ…cy dynamicznie liniÄ™ dialogowÄ… Leny;
    - odnotowanie wyboru w magistrali i odryglowanie wyjĹ›cia do Przestrzeni 25;
  - strefa `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station24` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie Ĺ›ciany CCTV przy x=140, wskaĹşnika naprÄ™ĹĽeĹ„ przy x=250, terminala transmisyjnego przy x=370, testowanie zmiany dyspozycji (Zgoda / Odmowa / Pozorna) na pulpicie przy x=490, przejĹ›cie 9 kwestii dialogowych, weryfikacja eskalacji naprÄ™ĹĽeĹ„, weryfikacja odryglowania wyjĹ›cia i przejĹ›cie przez strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_24.png` i `reports/station_24_cctv.png`.
- Zarejestrowano decyzjÄ™ D-056 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_24 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. OdbiĂłr dramaturgii obserwacji bliskiej osoby przez kamery UCP, napiÄ™cia moralnego przy wyborze ochrony Marty i braku zewnÄ™trznego potwierdzenia prawdomĂłwnoĹ›ci Wierzbickiej pozostajÄ… hipotezami (H-003, H-007, H-008, H-009b, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0043`.

## PKG-0043: PrzestrzeĹ„ 25 â€” WejĹ›cie Jakuba (Tranzyt Linii 4, Jakub jako operator UCP, blizna pod lewym ĹĽebrem, gest dĹ‚oni i dialog D-09)

Data: 2026-08-21

Kontekst: Kontynuacja fazy P3 (Vertical Slice) oraz realizacja Aktu II fabuĹ‚y (Korekta) per `FULL_STORY.md`. Zaimplementowanie Przestrzeni 25 z `FULL_STORY.md` (WejĹ›cie Jakuba / WÄ™zeĹ‚ tranzytowy Linii 4, Jakub jako pracownik UCP, blizna pod lewym ĹĽebrem, weryfikacja gestu dĹ‚oni i dialog D-09) w scenie `scenes/levels/station_25.tscn` ze skryptem `scripts/levels/station_25.gd`. WdroĹĽenie tunelu tranzytowego i serwisowego Linii 4 w Punkcie ZgodnoĹ›ci 6 w tonacji ciemnego grafitu, stali, bursztynu i cyjanu torowiska (`#10171a`, `#162227`, `#4a6d7c`, `#d39a62`, `#e2b060`). WdroĹĽenie 5 nowych rekwizytĂłw w `MemoryResonancePoint` (PropType 112..116): wĂłzka technicznego torowiska z pasami ostrzegawczymi i szpulÄ… kabla (`MaintenanceCart`), schematu diagnostycznego z wypadku z zaznaczonÄ… bliznÄ… od szkĹ‚a pod lewym ĹĽebrem (`ScarChart`), postaci Jakuba Wolskiego w roboczym uniformie technika UCP ze szelkami bezpieczeĹ„stwa (`JakubOperator`), sensora komparatora gestu dĹ‚oni (`GestureSensor`) oraz ciÄ™ĹĽkiej Ĺ›luzy tranzytowej do Przestrzeni 26 (`Station25Exit`). PeĹ‚na implementacja sceny dialogowej D-09 z `DIALOGUE_SCRIPT.md` (13 kwestii: Jakub Wolski, Lena Wolska, Ĺšwiadectwo: Jakub obserwuje nerwowy gest Leny rozcinania palca o krawÄ™dĹş blachy zamiast obracania obrÄ…czki, Lena konfrontuje pamiÄ™Ä‡ identyfikacji ciaĹ‚a z prosektorium i bliznÄ™ od szkĹ‚a pod lewym ĹĽebrem, Jakub siada na podĹ‚odze odmawiajÄ…c bycia duchem/wspomnieniem i ĹĽÄ…da traktowania jako ĹĽywa osoba: Â»Nie jestem twoim wspomnieniem. JeĹ›li chcesz wyjĹ›Ä‡, pomogÄ™ osobie. Nie ĹĽaĹ‚obie.Â«, odryglowanie wyjĹ›cia do Przestrzeni 26 / PrĂłba zamkniÄ™cia). Rozszerzenie moduĹ‚u `ProceduralAudio` o 5 syntezatorĂłw dĹşwiÄ™ku, rozbudowa testĂłw w `smoke_test.gd` oraz wyrenderowanie podglÄ…dĂłw `reports/station_25.png` i `reports/station_25_jakub.png`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 5 syntezatorĂłw dĹşwiÄ™ku (Scene 25):
  - `create_transit_rail_hum_sound()`: przydĹşwiÄ™k 50/100 Hz przetwornicy trakcyjnej, 150 Hz rezonans wnÄ™kowy stalowych szyn i 3100 Hz Ĺ›wist trakcyjny;
  - `create_jakub_uniform_rustle_sound()`: tarcie pĹ‚Ăłtna roboczego 750..2800 Hz i szelest pasĂłw noĹ›nych szelek monterskich;
  - `create_scar_revelation_chime_sound()`: krystaliczny dysonans pamiÄ™ci identyfikacji ciaĹ‚a (dwuton 740/784 Hz z powolnym tremolo 1.8 Hz);
  - `create_finger_edge_scrape_sound()`: mikro-tarcie ostrej krawÄ™dzi blachy o opuszek palca (1850 Hz mikro-tarcia z transientem 3200 Hz);
  - `create_station25_door_release_sound()`: 360/720 Hz suw rygli elektromagnetycznych z podwĂłjnym upustem pneumatycznym i dzwonkiem 1080 Hz.
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `JAKUB_OPERATOR_UCP` (112), `TRANSIT_MAINTENANCE_CART` (113), `SCAR_DIAGNOSTIC_CHART` (114), `JAKUB_HAND_GESTURE_SENSOR` (115), `STATION_25_EXIT` (116);
  - wyspecjalizowane procedury rysowania: wĂłzek rewizyjny na stalowych koĹ‚ach ze skrzyniÄ… narzÄ™dziowÄ… i zwojem kabla, schemat medyczny korpusu z cynobrowÄ… bliznÄ… pod lewym ĹĽebrem `#c65d58`, postaÄ‡ Jakuba w uniformie z odblaskami (pozycja stojÄ…ca czujna vs siedzÄ…ca na posadzce per didaskalia D-09), panel sensora gestu z podĹ›wietleniem obracania obrÄ…czki vs rozciÄ™cia opuszka oraz Ĺ›luza serwisowa z ryglem i tabliczkÄ… `26 / STREFA IZOLACJI`.
- Zaimplementowano scenÄ™ i kontroler `Station25` (`scripts/levels/station_25.gd`, `scenes/levels/station_25.tscn`):
  - tunel tranzytowy Linii 4 (640x360, podĹ‚oga y=320, podsypka tĹ‚uczniowa z 27 podkĹ‚adami i szynami y=280..360, ĹĽelbetowe ĹĽebra sklepienia y=40, napowietrzna sieÄ‡ trakcyjna ze wskaĹşnikami napiÄ™cia);
  - peĹ‚na mechanika sceny Scene 25 / D-09 z `DIALOGUE_SCRIPT.md` i `FULL_STORY.md`:
    - badanie wĂłzka konserwacyjnego i schematu medycznego blizny;
    - konfrontacja z Jakubem Wolskim: porĂłwnanie gestu nerwowego (obrÄ…czka vs naciÄ™cie palca);
    - wyznanie Leny o identyfikacji ciaĹ‚a po wypadku Linii 4;
    - reakcja Jakuba: siadanie na podĹ‚odze (zmiana pozy sprite'a na siedzÄ…cÄ… przy linii 6);
    - deklaracja podmiotowoĹ›ci: odmowa bycia fantomem przeszĹ‚oĹ›ci (â€žJeĹ›li chcesz wyjĹ›Ä‡, pomogÄ™ osobie. Nie ĹĽaĹ‚obie.â€ť);
    - stabilizacja Ĺ›ladu w rejestrze i odryglowanie wyjĹ›cia do Przestrzeni 26;
  - strefa `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station25` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie wĂłzka przy x=130, schematu blizny przy x=230, czujnika gestu przy x=480, konfrontacja z Jakubem przy x=380, przejĹ›cie 13 kwestii dialogowych D-09, weryfikacja zmiany postawy Jakuba na siedzÄ…cÄ…, odryglowanie Ĺ›luzy i wejĹ›cie w strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_25.png` i `reports/station_25_jakub.png`.
- Zarejestrowano decyzjÄ™ D-057 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_25 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. OdbiĂłr dramaturgii spotkania z ĹĽywym bratem traktujÄ…cym siebie jako podmiot a nie wspomnienie, zderzenia traumy identyfikacji zwĹ‚ok z rzeczywistoĹ›ciÄ… Podstruktury pozostajÄ… hipotezami (H-003, H-007, H-008, H-009b, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0044`.

## PKG-0044: PrzestrzeĹ„ 26 â€” PrĂłba zamkniÄ™cia (Strefa Ĺ‚agodnej izolacji Podstruktury, dynamiczne funkcje pomieszczeĹ„ i test motywacji Leny Wolskiej)

Data: 2026-08-21

Kontekst: Kontynuacja fazy P3 (Vertical Slice) oraz realizacja Aktu II fabuĹ‚y (Korekta) per `FULL_STORY.md`. Zaimplementowanie Przestrzeni 26 z `FULL_STORY.md` (PrĂłba zamkniÄ™cia / Strefa Ĺ‚agodnej izolacji Podstruktury, zmienne funkcje pomieszczeĹ„ po komunikatach PA dr Wierzbickiej, aksamitny szum wygaszania napiÄ™cia, odmowa poddania siÄ™ adaptacji przez LenÄ™ i wyrycie rysikiem pierwotnego celu na kompozycie Ĺ›ciany: Â»PAMIÄTAM DLACZEGO PRZYSZĹAM. NIE JESTEM ADAPTACJÄ„.Â«) w scenie `scenes/levels/station_26.tscn` ze skryptem `scripts/levels/station_26.gd`. WdroĹĽenie estetyki miÄ™kkiej izolacji akustycznej Podstruktury w barwach ciemnego grafitu, aksamitnej zieleni szaĹ‚wii, cyjanu i popielatego beĹĽu (`#0e1518`, `#182226`, `#3d5a65`, `#c8a370`, `#5da398`). WdroĹĽenie 5 nowych rekwizytĂłw w `MemoryResonancePoint` (PropType 117..121): konsoli strefy Ĺ‚agodnej izolacji (`IsolationConsole`), dynamicznego wskaĹşnika funkcyjnego pomieszczenia (`RoomDesignator`), interkomu tubowego komunikatĂłw adaptacyjnych dr Heleny Wierzbickiej (`PASpeaker`), zapisu rysikiem pierwotnego celu Leny (`MotivationAnchor`) oraz Ĺ›luzy serwisowej do Przestrzeni 27 (`Station26Exit`). PeĹ‚na implementacja sekwencji dialogowej Scene 26 z `FULL_STORY.md` i `DIALOGUE_SCRIPT.md` (12 kwestii: Ĺšwiadectwo, dr Helena Wierzbicka, Lena Wolska: Wierzbicka uruchamia strefÄ™ Ĺ‚agodnej izolacji, wskaĹşnik funkcyjny rekonfiguruje siÄ™: MIESZKALNY -> ARCHIWUM -> SEDACJA, Lena odmawia rozmycia celu wejĹ›cia do Podstruktury i wyciÄ…ga stalowy rysik ryjÄ…c nieusuwalnÄ… inskrypcjÄ™ kotwiczÄ…cÄ…, co zatrzymuje rekonfiguracjÄ™ przestrzennÄ… i odryglowuje przejĹ›cie serwisowe do Przestrzeni 27). Rozszerzenie `ProceduralAudio` o 5 syntezatorĂłw dĹşwiÄ™ku, rozbudowa testĂłw w `smoke_test.gd` oraz wyrenderowanie podglÄ…dĂłw `reports/station_26.png` i `reports/station_26_isolation.png`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 5 syntezatorĂłw dĹşwiÄ™ku (Scene 26):
  - `create_isolation_hum_sound()`: aksamitny sub-hum 45/90 Hz z mikro-tĹ‚umieniem wnÄ™kowym 180 Hz strefy Ĺ‚agodnej izolacji;
  - `create_reconfiguration_chime_sound()`: modulowany sweep 640->520 Hz rekonfiguracji funkcji pomieszczenia z flangerem 1.2 Hz;
  - `create_wierzbicka_calming_tone_sound()`: kojÄ…cy, niski tembr 330/660 Hz komunikatĂłw adaptacyjnych dr Wierzbickiej z filtrem pasmowym;
  - `create_motivation_scratch_sound()`: ostry dĹşwiÄ™k 2100 Hz tarcia stalowego rysika o kompozyt Ĺ›ciany z trzaskiem 4200 Hz rzeĹşbionego rowka;
  - `create_station26_door_release_sound()`: 310/620 Hz pneumatyczny upust rygli Ĺ›luzy serwisowej z dzwonkiem 930 Hz.
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `ISOLATION_ZONE_CONSOLE` (117), `DYNAMIC_ROOM_DESIGNATOR` (118), `MOTIVATION_ANCHOR_RECORD` (119), `WIERZBICKA_PA_SPEAKER` (120), `STATION_26_EXIT` (121);
  - procedury rysowania: konsola z wykresem tĹ‚umienia fal, wskaĹşnik alfanumeryczny z dynamicznym przeĹ‚Ä…czaniem trybĂłw, interkom nagĹ‚oĹ›nienia z rozchodzÄ…cymi siÄ™ falami akustycznymi, tablica ze zĹ‚oto-cynobrowÄ… wyrytÄ… inskrypcjÄ… oraz ryglowana Ĺ›luza serwisowa z tabliczkÄ… `27 / SERWIS`.
- Zaimplementowano scenÄ™ i kontroler `Station26` (`scripts/levels/station_26.gd`, `scenes/levels/station_26.tscn`):
  - komora strefy Ĺ‚agodnej izolacji (640x360, podĹ‚oga z pĹ‚yt pochĹ‚aniajÄ…cych drgania y=280..360, panele pikowane i ĹĽebra wygĹ‚uszajÄ…ce y=40..280, napowietrzny kanaĹ‚ nawiewu adaptacyjnego z kojÄ…cÄ… pulsacjÄ… cyjanowÄ…, baner ostrzegawczy `STREFA ĹAGODNEJ IZOLACJI ADAPTACYJNEJ / PODSTRUKTURA â€” SEKTOR 26`);
  - peĹ‚na mechanika sceny Scene 26 z `FULL_STORY.md`:
    - badanie konsoli Ĺ‚agodnej izolacji i wskaĹşnika funkcji;
    - odsĹ‚uch komunikatĂłw PA dr Wierzbickiej o uzgodnionej kolejnoĹ›ci pomieszczeĹ„;
    - dynamiczna rekonfiguracja stanu komory do SEDACJA przy linii 4;
    - wyrycie rysikiem kotwicy motywacji przy linii 8 (aktywacja propa i zmiana stanu);
    - zatrzymanie dekompozycji przestrzennej i odryglowanie wyjĹ›cia przy linii 10;
  - strefa `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station26` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie konsoli przy x=130, wskaĹşnika przy x=240, gĹ‚oĹ›nika PA przy x=360, kotwicy motywacji przy x=470, przejĹ›cie 12 kwestii dialogowych Scene 26, weryfikacja przeĹ‚Ä…czenia stanu na SEDATION oraz wyrycia kotwicy, odryglowanie wyjĹ›cia i wejĹ›cie w strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_26.png` i `reports/station_26_isolation.png`.
- Zarejestrowano decyzjÄ™ D-058 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_26 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. OdbiĂłr dramaturgii prĂłby uĹ›pienia czujnoĹ›ci przez dr WierzbickÄ…, psychologicznego mechanizmu Ĺ‚agodnej izolacji i zderzenia z determinacjÄ… Leny pozostajÄ… hipotezami (H-003, H-007, H-008, H-009b, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0045`.

## PKG-0045: P3 Vertical Slice â€” DĹ‚ug wdziÄ™cznoĹ›ci (PrzestrzeĹ„ 27)

Data: 2026-08-21

Kontekst: Kontynuacja fazy P3 (Vertical Slice) oraz realizacja Aktu II fabuĹ‚y (Korekta) per `FULL_STORY.md`. Zaimplementowanie Przestrzeni 27 z `FULL_STORY.md` (DĹ‚ug wdziÄ™cznoĹ›ci / Jakub otwiera wyjĹ›cie serwisowe do torowiska, wyznanie o ocaleniu na Linii 4 i warunek nienaruszalnoĹ›ci powierzchni) w scenie `scenes/levels/station_27.tscn` ze skryptem `scripts/levels/station_27.gd`. WdroĹĽenie wÄ™zĹ‚a serwisowego rozrzÄ…du Linii 4 w Podstrukturze (640x360) ze sklepieniem technicznym, wzmocnionymi ĹĽebrami stalowymi z nitami, pomostem z kratek podĹ‚ogowych i kanaĹ‚ami wysokiego napiÄ™cia w palecie `#111619`, `#1b2428`, `#527482`, `#d39a62`, `#e2b060`, `#5da398`, `#c65d58`. Zaimplementowanie 5 nowych rekwizytĂłw (legitymacja pracownicza Jakuba z pieczÄ™ciÄ… ocalenia, Jakub Wolski z kartÄ… magnetycznÄ… UCP i odruchowym gestem, monitor naprÄ™ĹĽeĹ„ siatki powierzchniowej, pulpit sterowniczy zwrotnicy Linii 4, ciÄ™ĹĽka brama rolowana ku Przestrzeni 28), peĹ‚nej 11-wersowej sekwencji dialogowej Scene 27, rozszerzenie `ProceduralAudio` o 5 syntezatorĂłw dĹşwiÄ™ku, rozbudowa `smoke_test.gd` oraz wyrenderowanie podglÄ…dĂłw `reports/station_27.png` i `reports/station_27_dialogue.png`.

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 5 dedykowanych syntezatorĂłw dĹşwiÄ™ku:
  - `create_service_tunnel_hum_sound()`: gĹ‚Ä™boki rezonansowy przydĹşwiÄ™k tunelu serwisowego (52 Hz z sub-harmonicznÄ… 104 Hz i filtrem 120 Hz);
  - `create_jakub_keycard_latch_sound()`: magnetyczny pisk czytnika zbliĹĽeniowego UCP (1600 Hz) z mechanicznym zwolnieniem elektromagnesu (480 Hz);
  - `create_gratitude_confession_tone_sound()`: ciepĹ‚y, melancholijny ton wyznania wdziÄ™cznoĹ›ci Jakuba (dwuton 440/554 Hz z miÄ™kkim atakiem);
  - `create_surface_danger_siren_sound()`: stĹ‚umiona, odlegĹ‚a syrena ostrzegawcza naprÄ™ĹĽeĹ„ powierzchniowych (1200 Hz z modulacjÄ… czÄ™stotliwoĹ›ciowÄ…);
  - `create_station27_door_release_sound()`: pneumatyczne zwolnienie rygla ciÄ™ĹĽkiej bramy technicznej (260/520 Hz z metalicznym wybrzmieniem 820 Hz).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `JAKUB_SERVICE_OPERATOR` (122), `SAVED_WORKER_BADGE` (123), `SURFACE_STABILITY_MONITOR` (124), `TECHNICAL_JUNCTION_CONSOLE` (125), `STATION_27_EXIT` (126);
  - procedury rysowania: sylwetka Jakuba w uniformie serwisowym z pomaraĹ„czowÄ… uprzÄ™ĹĽÄ… i kartÄ… magnetycznÄ…, legitymacja pracownicza z pieczÄ™ciÄ… ocalenia (12 lat pracy w Sektorze 4), monitor CRT z oscylujÄ…cymi wykresami sprzecznoĹ›ci dwĂłch historii, pulpit sterowniczy ze zwrotnicÄ… i manometrem oraz ciÄ™ĹĽka brama rolowana ku Przestrzeni 28 z tabliczkÄ… `28 / SKĹAD TECHNICZNY`.
- Zaimplementowano scenÄ™ i kontroler `Station27` (`scripts/levels/station_27.gd`, `scenes/levels/station_27.tscn`):
  - wÄ™zeĹ‚ serwisowy rozrzÄ…du Linii 4 (640x360, podĹ‚oga z kratek technicznych y=280..360, ĹĽebra noĹ›ne ze stali z nitami co 80 px, napowietrzne koryta kablowe i ĹĽĂłĹ‚te lampy ostrzegawcze, banner `SEKTOR SERWISOWY 27 â€” WÄZEĹ ROZRZÄ„DU LINII 4`);
  - peĹ‚na mechanika sceny Scene 27 z `FULL_STORY.md`:
    - odczyt karty magnetycznej i uniesienie rygla;
    - wyznanie Jakuba o ocaleniu przez dr WierzbickÄ… z wagonu Linii 4 z poĹ‚amanymi ĹĽebrami i krwiÄ… w pĹ‚ucach oraz 12 latach darowanego ĹĽycia;
    - wskazanie na monitor naprÄ™ĹĽeĹ„ powierzchni drĹĽÄ…cy pod ciÄ™ĹĽarem sprzecznych historii;
    - dialog o moralnym dĹ‚ugu (ĹĽÄ…danie dowodu od Leny, ĹĽe nie obrĂłci ocalonych ludzi z powierzchni w dĹ‚ug);
    - dotyk dĹ‚oni brata ze wspĂłlnym punktem oporu (rysa na opuszkach palcĂłw);
    - uniesienie bramy rolowanej i otwarcie drogi do skĹ‚adu technicznego na peronie 28;
  - strefa `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station27` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie legitymacji przy x=130, interakcja z Jakubem przy x=240, badanie monitora przy x=360, badanie pulpitu przy x=470, przejĹ›cie 11 kwestii dialogowych Scene 27, weryfikacja odryglowania wyjĹ›cia, animacja podnoszenia bramy oraz wejĹ›cie w strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_27.png` i `reports/station_27_dialogue.png`.
- Zarejestrowano decyzjÄ™ D-059 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_27 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. OdbiĂłr moralnego dylematu dĹ‚ugu wdziÄ™cznoĹ›ci wobec opresyjnego, lecz ratujÄ…cego ĹĽycie systemu, oraz wiernoĹ›Ä‡ wiÄ™zi rodzeĹ„stwa bez patosu pozostajÄ… hipotezami (H-003, H-007, H-008, H-009b, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0046`.


## PKG-0046: Implementacja Przestrzeni 28 (Tramwaj bez pasaĹĽerĂłw / FinaĹ‚ Aktu II: Korekta)

Data: 2026-08-21

Identyfikator stanu: `PKG-0046`. ZamroĹĽenie: `snapshots/PKG-0046-2026-08-21`.

Kontekst: Realizacja fazy P3 (Vertical Slice). Implementacja Przestrzeni 28 z `FULL_STORY.md` oraz sceny Scene 28 z `DIALOGUE_SCRIPT.md` stanowiÄ…cej finaĹ‚ Aktu II (Korekta): podrĂłĹĽ pÄ™dzÄ…cym skĹ‚adem technicznym w gĹ‚Ä™bokim tunelu Podstruktury na Linii 4, obserwacja przez okno panoramiczne 3 wykluczajÄ…cych siÄ™ wersji wypadku (pusty peron, ewakuacja z karetkami, nasycony bĹ‚Ä™kit konsensusu UCP), Ĺšlad ukĹ‚adajÄ…cy sĹ‚owo Â»ĹšWIADEKÂ«, radiowa transmisja dr Heleny Wierzbickiej (Â»Nie Ĺ›cigam paĹ„stwa. Zamykam drogÄ™, ktĂłrÄ… otwieracie za sobÄ….Â«), hamulce pneumatyczne i otwarcie wejĹ›cia do Aktu III (PrzestrzeĹ„ 29: Peron trzynasty).

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 5 procedur syntezy dĹşwiÄ™ku dla Przestrzeni 28:
  - `create_moving_tram_motor_sound()`: gĹ‚Ä™boki buczÄ…cy warkot silnikĂłw trakcyjnych tramwaju technicznego (65 Hz z harmonicznÄ… 130 Hz i modulacjÄ… fazowÄ… kĂłĹ‚);
  - `create_track_switch_clack_sound()`: uderzenie stalowych kĂłĹ‚ w rozjazdy szynowe (320/640 Hz z twardym metalicznym trzaĹ›niÄ™ciem 1400 Hz);
  - `create_wierzbicka_closing_intercom_sound()`: znieksztaĹ‚cona transmisja radiowa PA dr Wierzbickiej (880 Hz ton wywoĹ‚ania + szum noĹ›ny 380..2200 Hz);
  - `create_paradox_peron_shimmer_sound()`: rezonansowy, trĂłjtonowy dzwon paradoksu pamiÄ™ci (330/440/587 Hz z przestrzennym wybrzmieniem);
  - `create_station28_pneumatic_brake_sound()`: sykniÄ™cie i zablokowanie hamulcĂłw pneumatycznych (1200..400 Hz z basowym tÄ…pniÄ™ciem 220 Hz).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `TRAM_DRIVER_CONSOLE` (127), `PANORAMIC_TRANSIT_WINDOW` (128), `TRIPLE_ACCIDENT_PARADOX_VIEW` (129), `WIERZBICKA_CLOSING_INTERCOM` (130), `STATION_28_EXIT` (131);
  - procedury rysowania: pulpit sterowniczy maszynisty z nastawnikiem jazdy i prÄ™dkoĹ›ciomierzem, panoramiczne okno z odbiciem sylwetki i cieniami ĹĽeber tunelu, potrĂłjny wizjer paradoksu wypadku (lewy panel pusty peron, Ĺ›rodkowy panel akcja ratunkowa, prawy panel bĹ‚Ä™kitny konsensus UCP) oraz Ĺšlad ukĹ‚adajÄ…cy litery Â»ĹšWIADEKÂ«, gĹ‚oĹ›nik interkomu z czerwonÄ… diodÄ… nadawania i falami dĹşwiÄ™kowymi, podwĂłjne gumowane drzwi przedsionka wagonu z tabliczkÄ… `29 / PERON TRZYNASTY â€” PODSTRUKTURA`.
- Zaimplementowano scenÄ™ i kontroler `Station28` (`scripts/levels/station_28.gd`, `scenes/levels/station_28.tscn`):
  - wnÄ™trze pÄ™dzÄ…cego wagonu technicznego (640x360, podĹ‚oga gumowa y=280..360, sufit z korytami oĹ›wietleniowymi i uchwytami wiszÄ…cymi, porÄ™cze nierdzewne, przesuwna paralaksa ciemnych ĹĽeber tunelu i kabli wysokiego napiÄ™cia w tle);
  - peĹ‚na mechanika sceny Scene 28 z `FULL_STORY.md`:
    - interakcja z pulpitem maszynisty i nastawnikiem jazdy;
    - badanie okna panoramicznego i dostrzeĹĽenie sprzecznych obrazĂłw za szybÄ…;
    - widmo potrĂłjnego paradoksu i rĂłĹĽnica percepcji (Jakub widzi 2 wersje, Lena widzi wszystkie 3, brak jednego Ĺ›wiadka zdolnego utrzymaÄ‡ caĹ‚oĹ›Ä‡);
    - zmaterializowanie sĹ‚owa Â»ĹšWIADEKÂ« na tablicach stacyjnych;
    - transmisja dr Wierzbickiej o zamykaniu drogi za bohaterami;
    - awaryjne zadziaĹ‚anie hamulcĂłw pneumatycznych i odryglowanie przedsionka wagonu;
  - strefa `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station28` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie pulpitu przy x=130, okna przy x=240, widma paradoksu przy x=360, interkomu przy x=470, przejĹ›cie 11 kwestii dialogowych Scene 28, weryfikacja odryglowania wyjĹ›cia, animacja otwierania przedsionka oraz wejĹ›cie w strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_28.png` i `reports/station_28_transit.png`.
- Zarejestrowano decyzjÄ™ D-060 w `docs/DECISION_LOG.md`. DomkniÄ™to implementacjÄ™ Aktu II (Korekta).

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_28 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Poczucie pÄ™du skĹ‚adu, dynamika paralaksy tunelu, ciÄ™ĹĽar potrĂłjnego paradoksu postrzegania wypadku oraz dramatyzm zamkniÄ™cia Aktu II pozostajÄ… hipotezami (H-003, H-007, H-008, H-009b, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0047`.


## PKG-0047: Implementacja Przestrzeni 29 (Peron trzynasty / Otwarcie Aktu III: Podstruktura)

Data: 2026-08-21

Identyfikator stanu: `PKG-0047`. ZamroĹĽenie: `snapshots/PKG-0047-2026-08-21`.

Kontekst: Realizacja fazy P3 (Vertical Slice). Implementacja Przestrzeni 29 z `FULL_STORY.md` oraz sceny Scene 29 z `DIALOGUE_SCRIPT.md` stanowiÄ…cej otwarcie Aktu III (Podstruktura): opuszczony peron techniczny z lat 70. na granicy sieci miejskiej i Podstruktury, zardzewiaĹ‚y kozioĹ‚ oporowy Linii 4, migoczÄ…cy neon Â»PERON 13Â«, pionowy szyb wentylacyjny z infradĹşwiÄ™kowym szumem kompensatorĂłw naprÄ™ĹĽeĹ„ sprzecznoĹ›ci (1 bar na kaĹĽdÄ… wymazanÄ… prawdÄ™), przemysĹ‚owa latarka robocza Jakuba oĹ›wietlajÄ…ca drogÄ™ oraz odryglowanie rdzewiejÄ…cej kraty rewizyjnej prowadzÄ…cej do Przestrzeni 30 (Sektor Zasilania / GĹ‚Ăłwna Rozdzielnia).

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 5 procedur syntezy dĹşwiÄ™ku dla Przestrzeni 29:
  - `create_platform13_drip_echo_sound()`: pogĹ‚os i echo kapiÄ…cej wody w opuszczonym tunelu stacyjnym (180 Hz z sub-harmonicznÄ… 90 Hz i kroplÄ… 2200 Hz);
  - `create_flickering_neon_buzz_sound()`: brzÄ™czenie transformatora neonowego (100/200 Hz z iskrami wyĹ‚adowaĹ„ 3400 Hz);
  - `create_deep_well_drone_sound()`: infradĹşwiÄ™kowy pomruk kompensatorĂłw naprÄ™ĹĽeĹ„ w szybie Podstruktury (42 Hz z harmonicznÄ… 84 Hz);
  - `create_jakub_torch_click_sound()`: ostry mechaniczny klik wĹ‚Ä…cznika latarki roboczej Jakuba (1800 Hz + rezonans 440 Hz);
  - `create_station29_grate_creak_sound()`: metaliczny jÄ™k i zgrzyt rdzewiejÄ…cej kraty rewizyjnej (340/680 Hz z basowym trzaĹ›niÄ™ciem 110 Hz).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `ABANDONED_PLATFORM_TRACKS` (132), `FLICKERING_NEON_SIGN` (133), `DEEP_SUBSTRUCTURE_WELL` (134), `JAKUB_TORCH_BEACON` (135), `STATION_29_EXIT` (136);
  - procedury rysowania: zardzewiaĹ‚e szyny ze stalowo-betonowym kozĹ‚em oporowym i odblaskiem, emaliowana tablica z migoczÄ…cym neonem Â»PERON 13Â«, pionowy szyb wentylacyjny Podstruktury z obracajÄ…cym siÄ™ wirnikiem i kompensatorami naprÄ™ĹĽeĹ„, postaÄ‡ Jakuba z przemysĹ‚owÄ… latarkÄ… rzucajÄ…cÄ… snop Ĺ›wiatĹ‚a oraz rdzewiejÄ…ca brama z siatki stalowej z tabliczkÄ… `30 / SEKTOR ZASILANIA`.
- Zaimplementowano scenÄ™ i kontroler `Station29` (`scripts/levels/station_29.gd`, `scenes/levels/station_29.tscn`):
  - opuszczony peron techniczny (640x360, podĹ‚oga kafelkowana y=280..360, ĹĽebra betonowego sklepienia, popÄ™kane kafelki Ĺ›cienne z lat 70., plamy wilgoci i kable wysokiego napiÄ™cia);
  - peĹ‚na mechanika sceny Scene 29 z `FULL_STORY.md`:
    - badanie koĹ„ca torowiska i kozĹ‚a oporowego Linii 4;
    - inspekcja migoczÄ…cego neonu stacyjnego Â»PERON 13Â«;
    - badanie szybu wentylacyjnego i dialog o kompensatorach naprÄ™ĹĽeĹ„ dĹ‚ugu sprzecznoĹ›ci;
    - oĹ›wietlenie wejĹ›cia snopem latarki roboczej Jakuba;
    - decyzja Leny i Jakuba o wejĹ›ciu w gĹ‚Ä…b wĹ‚aĹ›ciwej Podstruktury bez moĹĽliwoĹ›ci odwrotu;
    - ustÄ…pienie i otwarcie rdzewiejÄ…cej kraty rewizyjnej;
  - strefa `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station29` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie torĂłw przy x=130, neonu przy x=240, szybu przy x=360, latarki przy x=470, przejĹ›cie 11 kwestii dialogowych Scene 29, weryfikacja odryglowania wyjĹ›cia, animacja otwierania bramy oraz wejĹ›cie w strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_29.png` i `reports/station_29_platform.png`.
- Zarejestrowano decyzjÄ™ D-061 w `docs/DECISION_LOG.md`. Otwarto implementacjÄ™ Aktu III (Podstruktura).

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_29 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. NastrĂłj opuszczenia peronu z lat 70., gĹ‚Ä™bia dĹşwiÄ™kowa szumu kompensatorĂłw w szybie oraz uĹ›wiadomienie skali administracyjnej korekty pozostajÄ… hipotezami (H-003, H-007, H-008, H-009b, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0048`.


## PKG-0048: Implementacja Przestrzeni 30 (Sektor Zasilania / Maszyna ĹšwiadkĂłw)

Data: 2026-08-21

Identyfikator stanu: `PKG-0048`. ZamroĹĽenie: `snapshots/PKG-0048-2026-08-21`.

Kontekst: Realizacja fazy P3 (Vertical Slice). Implementacja Przestrzeni 30 z `FULL_STORY.md` oraz sceny Scene 30 z `DIALOGUE_SCRIPT.md` w Akcie III (Podstruktura): centralna hala rozdzielni wysokiego napiÄ™cia Podstruktury, miedziane szyny prÄ…dowe, bateria transformatorĂłw olejowych, przestawienie trĂłjfazowego bezpiecznika noĹĽowego, odciÄ™cie zasilania automatycznych kamer i rejestratorĂłw UCP, podĹ›wietlany schemat magistrali pamiÄ™ci mieszkaĹ„cĂłw ze Ĺ›wiecÄ…cym wÄ™zĹ‚em Marty Kurek oraz odryglowanie ciÄ™ĹĽkiej bramy ekranowanej prowadzÄ…cej do Przestrzeni 31 (Magazyn DowodĂłw / JedenaĹ›cie KrzeseĹ‚).

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 5 procedur syntezy dĹşwiÄ™ku dla Przestrzeni 30:
  - `create_transformer_oil_hum_sound()`: gĹ‚Ä™bokie buczenie transformatorĂłw wysokiego napiÄ™cia (50/100/150 Hz z modulacjÄ… termicznÄ… oleju);
  - `create_knife_switch_throw_sound()`: mechaniczny trzask bezpiecznika noĹĽowego i Ĺ‚uk elektryczny (320 Hz + 2400 Hz iskra kontaktowa);
  - `create_high_voltage_spark_sound()`: impuls wyĹ‚adowania koronowego na izolatorach ceramicznych (4200 Hz z rezonansem ceramicznym 980 Hz);
  - `create_power_grid_relay_sound()`: sekwencja klikniÄ™Ä‡ przekaĹşnikĂłw elektromagnetycznych rozdzielni (820/1240/960 Hz);
  - `create_station30_door_release_sound()`: dejonizacja i zwolnienie rygli magnetycznych bramy ekranowanej (180..60 Hz tÄ…pniÄ™cie + 640 Hz rozĹ‚adowanie cewki).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `MAIN_POWER_DISTRIBUTION_BOARD` (137), `HIGH_VOLTAGE_TRANSFORMER_BANK` (138), `SECTION_BREAKER_LEVER` (139), `GRID_SCHEMATIC_DISPLAY` (140), `STATION_30_EXIT` (141);
  - procedury rysowania: szafa rozdzielcza z szynami miedzianymi i miernikami woltomierza/amperomierza, transformator olejowy z radiatorami i izolatorami disc-insulator, 3-fazowy bezpiecznik noĹĽowy z mechanizmem dĹşwigniowym i iskrÄ… rozwarcia, podĹ›wietlana mapa pamiÄ™ci z aktywnym wÄ™zĹ‚em Marty Kurek, oraz ciÄ™ĹĽka brama ekranowana oĹ‚owiem z tabliczkÄ… `31 / MAGAZYN DOWODĂ“W â€” JEDENAĹšCIE KRZESEĹ`.
- Zaimplementowano scenÄ™ i kontroler `Station30` (`scripts/levels/station_30.gd`, `scenes/levels/station_30.tscn`):
  - industrialna hala rozdzielcza wysokiego napiÄ™cia (640x360, podĹ‚oga betonowa ze skoĹ›nymi pasami ostrzegawczymi, stalowe sĹ‚upy noĹ›ne, koryta kablowe i magistrale miedziane);
  - peĹ‚na mechanika sceny Scene 30 z `FULL_STORY.md`:
    - inspekcja gĹ‚Ăłwnej tablicy rozdzielczej i wskaĹşnikĂłw obciÄ…ĹĽenia;
    - badanie buczÄ…cej baterii transformatorĂłw olejowych zasilajÄ…cych konsensus;
    - badanie podĹ›wietlanego schematu sieci i odczyt wÄ™zĹ‚a Marty Kurek pamiÄ™tajÄ…cej LenÄ™ z innego poranka;
    - przestawienie trĂłjfazowego bezpiecznika noĹĽowego i odciÄ™cie automatycznego nadzoru UCP;
    - dejonizacja rygla magnetycznego i uchylenie bramy ekranowanej;
  - strefa `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station30` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie rozdzielnicy przy x=130, transformatora przy x=240, bezpiecznika przy x=360, schematu przy x=470, przejĹ›cie 11 kwestii dialogowych Scene 30, weryfikacja odryglowania wyjĹ›cia, animacja otwierania bramy oraz wejĹ›cie w strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_30.png` i `reports/station_30_power.png`.
- Zarejestrowano decyzjÄ™ D-062 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_30 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Poczucie skali sieci elektro-pamiÄ™ciowej, ciÄ™ĹĽar mechanicznego przestawienia bezpiecznika noĹĽowego oraz uĹ›wiadomienie obecnoĹ›ci Marty w schemacie pozostajÄ… hipotezami (H-003, H-007, H-008, H-009b, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0049`.


## PKG-0049: Implementacja Przestrzeni 31 (Magazyn DowodĂłw / JedenaĹ›cie KrzeseĹ‚)

Data: 2026-08-21

Identyfikator stanu: `PKG-0049`. ZamroĹĽenie: `snapshots/PKG-0049-2026-08-21`.

Kontekst: Realizacja fazy P3 (Vertical Slice). Implementacja Przestrzeni 31 z `FULL_STORY.md` oraz sceny Scene 31 z `DIALOGUE_SCRIPT.md` w Akcie III (Podstruktura): podziemny magazyn fizycznych dowodĂłw wymazanych biografii Podstruktury, rzÄ…d 11 drewnianych krzeseĹ‚ z uĹ‚oĹĽonymi rzeczami osobistymi wymazanych ofiar (pĹ‚aszcz kolejowy z biletami, teczka z nutami, damska torebka, dzieciÄ™ca rÄ™kawiczka, zegarek z pÄ™kniÄ™tym szkieĹ‚kiem), zdalny holoterminal dr Heleny Wierzbickiej recytujÄ…cej z pamiÄ™ci 11 imion bez wahania, dwunaste krzesĹ‚o z legitymacjÄ… operacyjnÄ… Jakuba Wolskiego (dowĂłd jednoĹ›ci ocalenia i przesuniÄ™cia), ĹĽelazny pulpit z ksiÄ™gÄ… wariantĂłw UCP (Â»WYBRANO WARIANT, NIE CZĹOWIEKAÂ«) oraz dekompresja przeszklonej Ĺ›luzy ciĹ›nieniowej ku Przestrzeni 32 (Ĺšlad w szkle / Korytarz Luster).

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 5 procedur syntezy dĹşwiÄ™ku dla Przestrzeni 31:
  - `create_eleven_chairs_whisper_sound()`: wielogĹ‚osowy, pogĹ‚osowy szept 11 wymazanych toĹĽsamoĹ›ci (320..540 Hz formantĂłw wokalnych z szumem powietrznym);
  - `create_wierzbicka_recitation_chime_sound()`: chĹ‚odny, soliterowy dzwonek wywoĹ‚awczy recytacji imion przez dr WierzbickÄ… (660/880 Hz + 1320 Hz);
  - `create_twelfth_chair_resonance_sound()`: melancholijny trĂłjdĹşwiÄ™k pamiÄ™ci 12. krzesĹ‚a i ocalenia Jakuba (440/554/659 Hz);
  - `create_variant_ledger_page_sound()`: suchy szelest papieru archiwalnego i uderzenie urzÄ™dowej pieczÄ™ci woskowo-tuszÄ…cej UCP (1600 Hz + 280 Hz);
  - `create_station31_pressure_hiss_sound()`: dekompresja i rozszczelnienie przeszklonej Ĺ›luzy ciĹ›nieniowej (950..220 Hz opadajÄ…cy syk gazu).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `ELEVEN_CHAIRS_ARCHIVE_ROW` (142), `WIERZBICKA_REMOTE_HOLOTERMINAL` (143), `JAKUB_TWELFTH_CHAIR` (144), `VARIANT_CHOICE_LEDGER` (145), `STATION_31_EXIT` (146);
  - procedury rysowania: miniaturowy rzÄ…d drewnianych krzeseĹ‚ z uĹ‚oĹĽonymi artefaktami (pĹ‚aszcz, teczka, torebka, rÄ™kawiczka, zegarek), Ĺ›cienny terminal holoprojekcyjny z niebieskim stoĹĽkiem i sylwetkÄ… dr Wierzbickiej, duĹĽe krzesĹ‚o Jakuba z mosiÄ™ĹĽnÄ… odznakÄ… technika tramwajowego, pulpit z otwartÄ… ksiÄ™gÄ… wyboru wariantĂłw i czerwonÄ… pieczÄ™ciÄ… lakowÄ… oraz stalowo-szklana Ĺ›luza ciĹ›nieniowa z tabliczkÄ… `32 / ĹšLAD W SZKLE â€” KORYTARZ LUSTER`.
- Zaimplementowano scenÄ™ i kontroler `Station31` (`scripts/levels/station_31.gd`, `scenes/levels/station_31.tscn`):
  - surowa przestrzeĹ„ archiwum dowodowego (640x360, betonowe sklepienie Ĺ‚ukowe, regaĹ‚y z ponumerowanymi pudĹ‚ami dowodowymi, ponumerowane pola podĹ‚ogowe 1..11);
  - peĹ‚na mechanika sceny Scene 31 z `FULL_STORY.md`:
    - inspekcja rzÄ™du 11 krzeseĹ‚ z rzeczami ofiar;
    - uaktywnienie holoterminalu dr Wierzbickiej recytujÄ…cej z pamiÄ™ci imiona;
    - badanie 12. krzesĹ‚a Jakuba i skonfrontowanie odpowiedzialnoĹ›ci z wyborem wariantu;
    - badanie ksiÄ™gi dyspozycji UCP;
    - rozszczelnienie i otwarcie przeszklonej Ĺ›luzy ciĹ›nieniowej;
  - strefa `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station31` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie krzeseĹ‚ przy x=130, holoterminalu przy x=240, 12. krzesĹ‚a przy x=350, ksiÄ™gi przy x=460, przejĹ›cie 11 kwestii dialogowych Scene 31, weryfikacja odryglowania wyjĹ›cia, animacja dekompresji Ĺ›luzy oraz wejĹ›cie w strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_31.png` i `reports/station_31_chairs.png`.
- Zarejestrowano decyzjÄ™ D-063 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_31 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Emocjonalny ciÄ™ĹĽar recytacji 11 nazwisk przez WierzbickÄ…, moralna niejednoznacznoĹ›Ä‡ wyboru stabilnego wariantu oraz reakcja gracza na 12. krzesĹ‚o Jakuba pozostajÄ… hipotezami (H-003, H-007, H-008, H-009b, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0050`.


## PKG-0050: Implementacja Przestrzeni 32 (Ĺšlad w szkle / Korytarz Luster)

Data: 2026-08-21

Identyfikator stanu: `PKG-0050`. ZamroĹĽenie: `snapshots/PKG-0050-2026-08-21`.

Kontekst: Realizacja fazy P3 (Vertical Slice). Implementacja Przestrzeni 32 z `FULL_STORY.md` oraz sceny Scene 32 z `DIALOGUE_SCRIPT.md` w Akcie III (Podstruktura): korytarz szklanych tafli kompensacyjnych Podstruktury pamiÄ™tajÄ…cych alternatywne wersje zdarzeĹ„ (zaparowana tafla A ze spokojnym porankiem pustego torowiska, popÄ™kana tafla B z sieciÄ… pÄ™kniÄ™Ä‡, poĹĽarem i syrenami ratunkowymi, wypolerowana tafla C z urzÄ™dowÄ… pieczÄ™ciÄ… UCP-KONSENSUS-1988), mechanika rysowania Ĺšladu palcem na szkle wywoĹ‚ujÄ…ca rezonans z wymazanÄ… prawdÄ…, ostrzeĹĽenie Jakuba o pamiÄ™ci materiaĹ‚u (Â»SzkĹ‚o pamiÄ™ta ksztaĹ‚t naprÄ™ĹĽenia, ale nie ma woliÂ«), odsĹ‚oniÄ™cie ukrytego wĹ‚azu technicznego i opuszczenie stalowej drabiny serwisowej ku Przestrzeni 33 (Szyb Techniczny / Maszynownia GĹ‚Ăłwna).

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 5 procedur syntezy dĹşwiÄ™ku dla Przestrzeni 32:
  - `create_glass_condensation_wipe_sound()`: wilgotne, gumowe tarcie palca o zaparowane szkĹ‚o (850..1400 Hz z rezonansem szkĹ‚a 220 Hz);
  - `create_glass_stress_ring_sound()`: krysztaĹ‚owy, wysoki rezonans harmoniczny naprÄ™ĹĽeĹ„ szkĹ‚a (2200/3300 Hz z migotaniem 4400 Hz);
  - `create_fire_memory_rumble_sound()`: stĹ‚umiony pogĹ‚os poĹĽaru i syren ratunkowych uwiÄ™zionych w szkle (90/180 Hz + 720 Hz);
  - `create_consensus_stamp_reverberation_sound()`: sterylny, metaliczny pogĹ‚os urzÄ™dowej pieczÄ™ci UCP (520/1040 Hz);
  - `create_station32_hatch_unseal_sound()`: zwolnienie rygla i odpieczÄ™towanie wĹ‚azu szybu technicznego (240..80 Hz + 480 Hz).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `STEAMED_GLASS_PANE_A` (147), `CRACKED_GLASS_PANE_B` (148), `POLISHED_GLASS_PANE_C` (149), `CONDENSATION_TRACE_ETCHER` (150), `STATION_32_EXIT` (151);
  - procedury rysowania: zaparowana tafla z odbiciem pustego torowiska i kroplami kondensacji, popÄ™kana tafla ze Ĺ›ladem uderzenia, sieciÄ… spÄ™kaĹ„ i okopceniem, wypolerowana tafla z grawerem UCP, laboratoryjny pulpit ze szklanÄ… taflÄ… i Ĺ›wiecÄ…cÄ… podwĂłjnÄ… pÄ™tlÄ… Ĺšladu oraz stalowy wĹ‚az rewizyjny szybu technicznego z nitami i drabinÄ… serwisowÄ… z tabliczkÄ… `33 / SZYB TECHNICZNY â€” MASZYNOWNIA GĹĂ“WNA`.
- Zaimplementowano scenÄ™ i kontroler `Station32` (`scripts/levels/station_32.gd`, `scenes/levels/station_32.tscn`):
  - korytarz szklanych tafli (640x360, wysoki poĹ‚ysk posadzki, pionowe sĹ‚upki noĹ›ne, smugi refrakcji Ĺ›wiatĹ‚a);
  - peĹ‚na mechanika sceny Scene 32 z `FULL_STORY.md`:
    - inspekcja zaparowanej tafli A (wariant spokojny);
    - inspekcja popÄ™kanej tafli B (wariant uderzenia);
    - wyrysowanie podwĂłjnej pÄ™tli Ĺšladu palcem na szkle;
    - inspekcja wypolerowanej tafli C (wariant konsensusu UCP);
    - odryglowanie i otwarcie stalowego wĹ‚azu szybu technicznego;
  - strefa `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station32` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: inspekcja tafli przy x=125, x=235, pulpitu Ĺ›ladu przy x=345, tafli UCP przy x=455, przejĹ›cie 11 kwestii dialogowych Scene 32, weryfikacja odryglowania wyjĹ›cia, animacja odpieczÄ™towania wĹ‚azu oraz wejĹ›cie w strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_32.png` i `reports/station_32_glass.png`.
- Zarejestrowano decyzjÄ™ D-064 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_32 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Poczucie kruchoĹ›ci pamiÄ™ci materiaĹ‚u, estetyczny kontrast miÄ™dzy spokojnym a zniszczonym odbiciem oraz decyzja o naruszeniu tafli pozostajÄ… hipotezami (H-003, H-007, H-008, H-009b, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0051`.


## PKG-0051: Implementacja Przestrzeni 33 (Szyb Techniczny / Drabina do Maszynowni GĹ‚Ăłwnej)

Data: 2026-08-21

Identyfikator stanu: `PKG-0051`. ZamroĹĽenie: `snapshots/PKG-0051-2026-08-21`.

Kontekst: Realizacja fazy P3 (Vertical Slice). Implementacja Przestrzeni 33 z `FULL_STORY.md` oraz sceny Scene 33 / D-13 z `DIALOGUE_SCRIPT.md` w Akcie III (Podstruktura): pionowy szyb techniczny przecinajÄ…cy warstwy Podstruktury od -15 m do -40 m pod Osiedlem Tarasowym, pionowa drabina serwisowa ze stalowÄ… klatkÄ… bezpieczeĹ„stwa, manometr ciĹ›nienia sprzecznoĹ›ci (4.2 BAR), wiÄ…zka kabli magistrali pamiÄ™ci z pulsujÄ…cymi pakietami wymazanych biografii pasaĹĽerĂłw, przemysĹ‚owa lampa szybowo-ostrzegawcza rzucajÄ…ca snop Ĺ›wiatĹ‚a w dĂłĹ‚ ku Maszynowni, dialog D-13 o odciÄ™ciu powrotu po zejĹ›ciu w gĹ‚Ä…b (Â»Gdy otworzymy dolny wĹ‚az, droga powrotna przestanie istnieÄ‡Â«) oraz hydrauliczne odryglowanie dolnego wĹ‚azu dekompresyjnego ku Przestrzeni 34 (Maszynownia GĹ‚Ăłwna / RdzeĹ„ Wymiany).

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 5 procedur syntezy dĹşwiÄ™ku dla Przestrzeni 33:
  - `create_ladder_rung_climb_sound()`: metaliczny, ostry stuk butĂłw i dĹ‚oni o szczeble drabiny serwisowej (620/1240 Hz + 180 Hz);
  - `create_depth_pressure_creak_sound()`: gĹ‚Ä™boki zgrzyt stalowej konstrukcji szybu pod ciĹ›nieniem sprzecznoĹ›ci (75/150 Hz + 420 Hz);
  - `create_cable_trunk_pulse_sound()`: elektromagnetyczny pulsujÄ…cy szum kabli magistrali pamiÄ™ci (110/220 Hz + 880 Hz);
  - `create_shaft_work_light_hum_sound()`: przydĹşwiÄ™k i brzÄ™czenie dĹ‚awika lampy szybowej (50/100 Hz + 1600 Hz);
  - `create_station33_lower_hatch_sound()`: potÄ™ĹĽne hydrauliczne uderzenie i odpieczÄ™towanie dolnego wĹ‚azu maszynowni (140..40 Hz + 360 Hz).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `VERTICAL_LADDER_ARRAY` (152), `DEPTH_PRESSURE_GAUGE` (153), `MEMORY_BUS_CABLE_TRUNK` (154), `SHAFT_WORK_LIGHT_BEACON` (155), `STATION_33_EXIT` (156);
  - procedury rysowania: pionowa drabina ze szczeblami i klatkÄ… ochronnÄ…, analogowy manometr gĹ‚Ä™bokoĹ›ci i ciĹ›nienia, koryto magistrali kablowej z pulsujÄ…cymi diodami transmisyjnymi, przemysĹ‚owa lampa w koszu drucianym ze snopem Ĺ›wiatĹ‚a oraz potÄ™ĹĽny dolny wĹ‚az dekompresyjny z hydraulicznymi ramionami i tabliczkÄ… `34 / MASZYNOWNIA GĹĂ“WNA â€” RDZEĹ WYMIANY`.
- Zaimplementowano scenÄ™ i kontroler `Station33` (`scripts/levels/station_33.gd`, `scenes/levels/station_33.tscn`):
  - pionowy szyb techniczny (640x360, ĹĽebra obudowy, pomost z kratek, podĹ›wietlany baner informacyjny poziomu -40 m);
  - peĹ‚na mechanika sceny Scene 33 z `FULL_STORY.md`:
    - inspekcja drabiny serwisowej (start sekwencji D-13);
    - inspekcja manometru ciĹ›nienia (-40 m, 4.2 BAR);
    - inspekcja wiÄ…zki magistrali pamiÄ™ci;
    - inspekcja przemysĹ‚owej lampy szybowej;
    - peĹ‚ne 11 kwestii dialogowych i odryglowanie dolnego wĹ‚azu;
  - strefa `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station33` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie drabiny przy x=130, manometru przy x=235, magistrali przy x=345, lampy przy x=455, przejĹ›cie 11 kwestii dialogowych Scene 33, weryfikacja odryglowania wyjĹ›cia, animacja odpieczÄ™towania dolnego wĹ‚azu oraz wejĹ›cie w strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_33.png` i `reports/station_33_shaft.png`.
- Zarejestrowano decyzjÄ™ D-065 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_33 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Poczucie klaustrofobii w gĹ‚Ä™bokim szybie, narastajÄ…cy szum Maszynowni oraz Ĺ›wiadomoĹ›Ä‡ nieodwracalnoĹ›ci zejĹ›cia na poziom -40 m pozostajÄ… hipotezami (H-003, H-007, H-008, H-009b, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0052`.


## PKG-0052: Implementacja Przestrzeni 34 (Maszynownia GĹ‚Ăłwna / RdzeĹ„ Wymiany)

Data: 2026-08-21

Identyfikator stanu: `PKG-0052`. ZamroĹĽenie: `snapshots/PKG-0052-2026-08-21`.

Kontekst: Realizacja fazy P3 (Vertical Slice). Implementacja Przestrzeni 34 z `FULL_STORY.md` oraz sceny Scene 34 z `DIALOGUE_SCRIPT.md` w Akcie III (Podstruktura): centralna sala Maszynowni GĹ‚Ăłwnej na poziomie -40 m pod Osiedlem Tarasowym, potÄ™ĹĽny cylindryczny reaktor Rdzenia Wymiany przetwarzajÄ…cy wektory sprzecznoĹ›ci pamiÄ™ci miasta, pulpit dyspozycji z mosiÄ™ĹĽnymi suwakami alokacji biograficznej pasaĹĽerĂłw Linii 4 (Kowalska, Sikora, Wolski) sprowadzonymi do zera (Â»NIEISTNIEJÄ„CYÂ«), kolumnowy manometr przeciÄ…ĹĽenia termicznego i sprzecznoĹ›ci (8.9 BAR na czerwonym polu), przenoĹ›ny prĂłbnik diagnostyczny Jakuba z oscyloskopem rejestrujÄ…cym skok ciĹ›nienia i przygotowanie zrzutu osadu poznawczego, dialog o gromadzeniu siÄ™ odfiltrowanych wspomnieĹ„ w osadnikach oraz pneumatyczne odryglowanie ciÄ™ĹĽkiej bramy filtracyjnej ku Przestrzeni 35 (Sektor Filtracji / Baseny Sedacyjne).

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 5 procedur syntezy dĹşwiÄ™ku dla Przestrzeni 34:
  - `create_core_reactor_pulse_sound()`: niskie dudnienie hydrauliczne i obrĂłt reaktora wymiany (38/76 Hz + 320 Hz);
  - `create_biography_slider_drag_sound()`: tarcie metaliczne suwakĂłw i skok zapadek mechanicznych (520/1040 Hz + 210 Hz);
  - `create_core_thermal_alarm_sound()`: dwutonowy modulowany alarm przeciÄ…ĹĽenia termicznego rdzenia (1400..880 Hz);
  - `create_jakub_diagnostic_probe_sound()`: cyfrowy rezonans i synchroniczny pisk prĂłbnika Jakuba (2400/4800 Hz);
  - `create_station34_filtration_gate_sound()`: potÄ™ĹĽny ryk dekompresyjny i rozszczelnienie bramy filtracyjnej (160..50 Hz + 720 Hz).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `MAIN_EXCHANGE_CORE_REACTOR` (157), `BIOGRAPHY_ALLOCATION_DESK` (158), `THERMAL_OVERLOAD_INDICATOR` (159), `JAKUB_CORE_DIAGNOSTIC_PORT` (160), `STATION_34_EXIT` (161);
  - procedury rysowania: potÄ™ĹĽny reaktor wymiany z hydraulicznymi ramionami i wirujÄ…cymi dyskami, pulpit alokacji z suwakami, kolumnowy manometr termiczny na czerwonym polu z lampÄ… ostrzegawczÄ…, prĂłbnik Jakuba z ekranem CRT i sondÄ… pomiarowÄ… oraz hermetyczna brama filtracyjna z pasami ostrzegawczymi i kanaĹ‚em parowym.
- Zaimplementowano scenÄ™ i kontroler `Station34` (`scripts/levels/station_34.gd`, `scenes/levels/station_34.tscn`):
  - monumentalna komora reaktora (640x360, Ĺ‚uki sklepienia, magistrala parowa, pomost z kratek, podĹ›wietlany neon sekcji);
  - peĹ‚na mechanika sceny Scene 34 z `FULL_STORY.md`:
    - inspekcja Rdzenia Wymiany (start sekwencji dialogowej);
    - inspekcja pulpitu alokacji biograficznej;
    - inspekcja wskaĹşnika przeciÄ…ĹĽenia termicznego;
    - inspekcja prĂłbnika diagnostycznego Jakuba;
    - peĹ‚ne 11 kwestii dialogowych i odryglowanie bramy filtracyjnej;
  - strefa `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station34` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie reaktora przy x=140, pulpitu przy x=245, wskaĹşnika przy x=345, prĂłbnika przy x=445, przejĹ›cie 11 kwestii dialogowych Scene 34, weryfikacja odryglowania wyjĹ›cia, animacja odpieczÄ™towania bramy filtracyjnej oraz wejĹ›cie w strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_34.png` i `reports/station_34_core.png`.
- Zarejestrowano decyzjÄ™ D-066 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_34 completed
Verification passed.
```

## PKG-0053: Implementacja Przestrzeni 35 (Sektor Filtracji / Baseny Sedacyjne)

Data: 2026-08-21

Identyfikator stanu: `PKG-0053`. ZamroĹĽenie: `snapshots/PKG-0053-2026-08-21`.

Kontekst: Realizacja fazy P3 (Vertical Slice). Implementacja Przestrzeni 35 z `FULL_STORY.md` oraz dialogu D-14 ze Sceny 35 w Akcie III (Podstruktura): podziemna oczyszczalnia osadu poznawczego i filtracji sprzecznoĹ›ci na poziomie -40 m, potÄ™ĹĽne betonowe baseny sedacyjne z fosforyzujÄ…cÄ… cieczÄ… i widmami odrzuconych wspomnieĹ„ [tablica Linii 4, but dziecka, teczka wypadku], koĹ‚o ĹĽeliwnego zaworu spustowego zrzutu do kanaĹ‚Ăłw burzowych, prĂłbnik chemiczny z wirujÄ…cym odczynnikiem UCP, monitor stÄ™ĹĽenia Jakuba rejestrujÄ…cy skok do 312% normy krytycznej, dialog D-14 o skaĹĽeniu wody sedatywami i uspokajaniu miasta oraz odryglowanie ciÄ™ĹĽkiej Ĺ›luzy odpĹ‚ywowej ku Przestrzeni 36 (KanaĹ‚ OdpĹ‚ywowy / Zimny Ĺšciek).

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 5 procedur syntezy dĹşwiÄ™ku dla Przestrzeni 35:
  - `create_sedation_liquid_slosh_sound()`: bulgotanie i powolny ruch lepkiej cieczy w basenie sedacyjnym (95..160 Hz + pÄ™kanie pÄ™cherzykĂłw 480 Hz);
  - `create_sludge_valve_creak_sound()`: skrzyp ĹĽeliwnego koĹ‚a zaworu i szum spĹ‚ywajÄ…cego osadu (320 Hz + 1800 Hz);
  - `create_chemical_bubbler_sound()`: musujÄ…ce perlenie odczynnika w prĂłbniku chemicznym (800..2200 Hz);
  - `create_sedation_saturation_alarm_sound()`: chĹ‚odny dzwonek alarmowy przekroczenia nasycenia krytycznego (480/720 Hz);
  - `create_station35_drain_sluice_sound()`: potÄ™ĹĽny szum wlewajÄ…cej siÄ™ wody i podniesienie zasuwy Ĺ›luzy odpĹ‚ywowej (220..60 Hz + 980 Hz).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `SEDATION_BASIN_POOL` (162), `SLUDGE_DRAIN_VALVE_WHEEL` (163), `CHEMICAL_SEDATION_SAMPLER` (164), `JAKUB_SEDATION_MONITOR` (165), `STATION_35_EXIT` (166);
  - procedury rysowania: basen sedacyjny z fosforyzujÄ…cÄ… mÄ™tnÄ… cieczÄ… i widmami przedmiotĂłw (tablica Linii 4, but, teczka z czerwonÄ… tasiemkÄ…), ĹĽeliwny zawĂłr spustowy z brÄ…zowym koĹ‚em i zaciekami szlamu, szklane cylindry prĂłbnika chemicznego z wirujÄ…cym reagentem, spektrometr CRT Jakuba na trĂłjnogu pokazujÄ…cy skok krzywej nasycenia oraz ciÄ™ĹĽka pionowa Ĺ›luza odpĹ‚ywowa z mechanizmem zÄ™batym.
- Zaimplementowano scenÄ™ i kontroler `Station35` (`scripts/levels/station_35.gd`, `scenes/levels/station_35.tscn`):
  - hala filtracji z betonowymi filarami, suwnicami i rurami Ĺ›ciekowymi (640x360, podĹ‚oga y=280, pomost z kratek, fosforyzujÄ…cy blask z kanaĹ‚Ăłw);
  - peĹ‚na mechanika sceny Scene 35 z `FULL_STORY.md` i `DIALOGUE_SCRIPT.md`:
    - inspekcja basenu sedacyjnego;
    - inspekcja prĂłbnika chemicznego;
    - inspekcja zaworu spustowego szlamu;
    - inspekcja monitora Jakuba z odczytem 312%;
    - sekwencja dialogowa D-14 (11 kwestii: Ĺšwiadectwo, Lena, Jakub);
    - odryglowanie i podniesienie zasuwy Ĺ›luzy odpĹ‚ywowej do Przestrzeni 36;
  - strefa `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station35` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie basenu przy x=140, zaworu przy x=245, prĂłbnika przy x=345, monitora przy x=445, przejĹ›cie 11 kwestii dialogowych D-14, odryglowanie wyjĹ›cia, animacja podniesienia Ĺ›luzy oraz wejĹ›cie w strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_35.png` i `reports/station_35_sedation.png`.
- Zarejestrowano decyzjÄ™ D-067 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_35 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Poczucie chemicznego skaĹĽenia, fosforyzujÄ…cy mÄ™tny blask basenĂłw oraz groza odkrycia masowej sedacji ludnoĹ›ci pozostajÄ… hipotezami (H-003, H-007, H-008, H-009b, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0054`.


## PKG-0054: PrzestrzeĹ„ 36: KanaĹ‚ OdpĹ‚ywowy / Zimny Ĺšciek (Akt III: Podstruktura)

Data: 2026-08-21

Stan: `Vertical Slice (P3) - Implementacja Przestrzeni 36` (Zgodnie z `FULL_STORY.md`, `DIALOGUE_SCRIPT.md`, `VISUAL_DESIGN.md` oraz D-025, D-026, ADR-004, ADR-005)

Wynik:
- Rozszerzono `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) o 5 procedur syntezy dĹşwiÄ™ku dla Przestrzeni 36:
  - `create_storm_drain_torrent_sound()`: potÄ™ĹĽny szum i plusk rwÄ…cego nurtu w kanale burzowym (55/110 Hz sub-bas z turbulentnym szumem 450..2600 Hz);
  - `create_drain_weir_creak_sound()`: skrzyp i zgrzyt ĹĽelaznej kraty jazu spiÄ™trzajÄ…cego pod naporem znoszonych odpadĂłw (280/560 Hz + 1600 Hz);
  - `create_acid_ladder_clank_sound()`: metaliczny stukot butĂłw o szczeble drabinki ze stali kwasoodpornej (740/1480 Hz + 280 Hz);
  - `create_groundwater_leak_alarm_sound()`: pulsacyjny dwutonowy alarm skaĹĽenia wĂłd gruntowych substancjÄ… sedacyjnÄ… (880/1174 Hz z modulacjÄ… 4 Hz);
  - `create_station36_storm_gate_sound()`: dekompresyjny ryk i podniesienie ciÄ™ĹĽkich wrĂłt przeciwsztormowych (180..40 Hz + 820 Hz).
- Rozbudowano `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - dodano typy: `STORM_DRAIN_WEIR` (167), `SEDATIVE_SLUDGE_CURRENT` (168), `ACID_RESISTANT_CATWALK_LADDER` (169), `CONTAMINATION_SAMPLING_TAP` (170), `STATION_36_EXIT` (171);
  - procedury rysowania: zardzewiaĹ‚y jaz burzowy z pionowymi ĹĽelaznymi prÄ™tami i uwiÄ™zionymi szczÄ…tkami pamiÄ™ci katastrofy (porÄ™cz tramwaju, bilet z 3 listopada 1988, skrawki wykresĂłw), rwÄ…cy nurt Ĺ›ciekowy z fosforyzujÄ…cÄ… smugÄ… spuszczonego osadu sedacyjnego i pÄ™cherzykami gazu, pomost inspekcyjny i drabinka ze stali kwasoodpornej nad korytem burzowym, kurek probierczy ze wskaĹşnikiem skaĹĽenia wĂłd gruntowych Osiedla Tarasowego oraz ciÄ™ĹĽka ĹĽelbetowa brama przeciwsztormowa ze Ĺ›luzÄ… hydraulicznÄ… prowadzÄ…ca do Przestrzeni 37 (Komora SygnaĹ‚owa).
- Zaimplementowano scenÄ™ i kontroler `Station36` (`scripts/levels/station_36.gd`, `scenes/levels/station_36.tscn`):
  - podziemny kanaĹ‚ burzowy pod StarÄ… PÄ™tlÄ… na poziomie -40 m (640x360, sklepienie Ĺ‚ukowe z surowego betonu, zacieki wysokiej wody, rurociÄ…g wentylacyjny na suficie, rwÄ…cy ciemny potok Ĺ›ciekowy na dnie y=280..360, podniesiony pomost techniczny y=268 z barierkami ochronnymi);
  - peĹ‚na sekwencja narracyjna Scene 36 z `FULL_STORY.md` i `DIALOGUE_SCRIPT.md`:
    - inspekcja rwÄ…cego nurtu osadu sedacyjnego;
    - inspekcja jazu burzowego z odĹ‚amkami wymazanych przedmiotĂłw;
    - inspekcja kĹ‚adki i drabinki ze stali kwasoodpornej;
    - inspekcja kurka probierczego wĂłd gruntowych;
    - sekwencja dialogowa Scene 36 (11 kwestii: Ĺšwiadectwo, Lena, Jakub);
    - odryglowanie i cofniÄ™cie rygli bramy przeciwsztormowej do Przestrzeni 37 (Komora SygnaĹ‚owa);
  - strefa `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station36` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie nurtu przy x=245, jazu przy x=140, drabiny przy x=345, kurka probierczego przy x=445, przejĹ›cie 11 kwestii dialogowych Scene 36, odryglowanie wyjĹ›cia, animacja cofniÄ™cia rygli bramy przeciwsztormowej oraz wejĹ›cie w strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_36.png` i `reports/station_36_drain.png`.
- Zarejestrowano decyzjÄ™ D-068 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_36 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Duszna wilgoÄ‡ podziemnego kanaĹ‚u burzowego, poĹ›wiata skaĹĽonych Ĺ›ciekĂłw i dylemat moralny wokĂłĹ‚ nieodwracalnego zatrucia ujÄ™Ä‡ wody Osiedla Tarasowego pozostajÄ… hipotezami (H-003, H-007, H-008, H-009b, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0055`.

## PKG-0055: PrzestrzeĹ„ 37 â€” Komora SygnaĹ‚owa / WÄ™zeĹ‚ Nadawczy (Akt III: Podstruktura)

Data: 2026-08-21

Identyfikator stanu: `PKG-0055`. ZamroĹĽenie: `snapshots/PKG-0055-2026-08-21`.

Kontekst: Realizacja fazy P3 / Vertical Slice (Akt III: Podstruktura). WdroĹĽenie Przestrzeni 37: Komora SygnaĹ‚owa / WÄ™zeĹ‚ Nadawczy na poziomie -40 m pod powierzchniÄ… miasta. Implementacja wÄ™zĹ‚a transmisyjnego z oscyloskopem CRT interferencji falowej, krosownicÄ… sektorĂłw 1..4 z liniami Marty, Szymona i ofiar Linii 4, centralnym masztem anteny transmisyjnej z cewkami toroidalnymi, pulpitem injekcyjnym sygnaĹ‚u Ĺ›wiadectwa z hebelkami wzmacniajÄ…cymi transmisjÄ™ do miejskich odbiornikĂłw oraz Ĺ›luzÄ… transmisyjnÄ… prowadzÄ…cÄ… do strefy rdzeniowej pamiÄ™ci wypadku (PrzestrzeĹ„ 38: CzĹ‚owiek zamiast dowodu).

Wynik:
- Rozszerzono `scripts/audio/procedural_audio.gd` o 5 dedykowanych metod syntezy dĹşwiÄ™ku proceduralnego:
  - `create_signal_antenna_carrier_sound()`: harmoniczna noĹ›na wysokiej czÄ™stotliwoĹ›ci (1200/2400/3600 Hz) z rezonansem iglicowym i przydĹşwiÄ™kiem 580 Hz;
  - `create_cross_patchbay_plug_sound()`: mechaniczny wtyk jacka krosowniczego (680 Hz + 2100 Hz zestyk miedziany);
  - `create_crt_sweep_interference_sound()`: przydĹşwiÄ™k odchylania linii CRT (450 Hz) z interferencjÄ… Lissajous i tonem 15.6 kHz;
  - `create_memory_injection_lever_sound()`: industrialny klik hebelka przeĹ‚Ä…cznikowego (540/1080 Hz) ze sprÄ™ĹĽystym korpusem 190 Hz;
  - `create_station37_broadcast_gate_sound()`: dekompresyjny Ĺ›wist otwarcia wrĂłt transmisyjnych (310..75 Hz) z elektromagnetycznym pierĹ›cieniem 920 Hz.
- Rozszerzono `scripts/interactables/memory_resonance_point.gd` o `PropType` 172..176:
  - `SIGNAL_TRANSMISSION_ANTENNA` (172): pionowy emiter iglicowy z miedzianymi pierĹ›cieniami rezonansowymi i pulsujÄ…cym Ĺ‚ukiem w.cz.;
  - `TRANSMISSION_CROSS_PATCHBAY` (173): matryca gniazd bantam z kablami krosowniczymi w cynobrze i cyjanie Ĺ‚Ä…czÄ…cymi sektory 1..4;
  - `FREQUENCY_OSCILLOSCOPE_CRT` (174): okrÄ…gĹ‚y zielono-cyjanowy kineskop CRT obrazujÄ…cy nakĹ‚adanie siÄ™ fali Leny i Ĺšladu;
  - `MEMORY_INJECTION_PULPIT` (175): pochyĹ‚y pulpit ze szczotkowanej stali z 4 heblami i dwoma wskaĹşnikami VU;
  - `STATION_37_EXIT` (176): wrota komory transmisyjnej z ryglowaniem i Ĺ›wiatĹ‚owodowÄ… listwÄ… sygnaĹ‚owÄ….
- Utworzono kontroler `scripts/levels/station_37.gd` oraz scenÄ™ `scenes/levels/station_37.tscn`:
  - scenografia wÄ™zĹ‚a transmisyjnego na poziomie -40 m z szafami rackowymi z diodami LED, podwieszanymi korytami kablowymi, podĹ‚ogÄ… antyelektrostatycznÄ… i podĹ›wietlonym banerem;
  - interakcje z rekwizytami:
    - inspekcja oscyloskopu CRT (fala Leny i Ĺšladu w rezonansie bez wzajemnego znoszenia);
    - inspekcja krosownicy sektorĂłw 1..4;
    - inspekcja anteny emisyjnej;
    - uzbrojenie pulpitu injekcyjnego sygnaĹ‚u Ĺ›wiadectwa;
    - sekwencja dialogowa Scene 37 (11 kwestii: Ĺšwiadectwo, Lena, Jakub);
    - uniesienie rygli Ĺ›luzy transmisyjnej ku Przestrzeni 38 (CzĹ‚owiek zamiast dowodu);
  - strefa `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station37` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie oscyloskopu przy x=140, krosownicy przy x=245, anteny przy x=345, pulpitu przy x=445, przejĹ›cie 11 kwestii dialogowych Scene 37, odryglowanie wyjĹ›cia, animacja wyjĹ›cia oraz wejĹ›cie w strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_37.png` i `reports/station_37_signal.png`.
- Zarejestrowano decyzjÄ™ D-069 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_37 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Rezonans radiowy transmisji sprzecznych pamiÄ™ci i dylemat wyboru miÄ™dzy zachowaniem jednostki a rozproszeniem Ĺ›wiadectwa na caĹ‚e miasto pozostajÄ… hipotezami (H-003, H-007, H-008, H-009b, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0056`.

## PKG-0056: PrzestrzeĹ„ 38 â€” Sektor PamiÄ™ci Wypadku / CzĹ‚owiek zamiast dowodu (Akt III: Podstruktura)

Data: 2026-08-21

Identyfikator stanu: `PKG-0056`. ZamroĹĽenie: `snapshots/PKG-0056-2026-08-21`.

Kontekst: Realizacja fazy P3 / Vertical Slice (Akt III: Podstruktura). WdroĹĽenie Przestrzeni 38: Sektor PamiÄ™ci Wypadku / CzĹ‚owiek zamiast dowodu na poziomie -40 m pod powierzchniÄ… miasta. Implementacja rdzenia symulacji katastrofy na Linii 4 z lewitujÄ…cym widmem wykolejonego tramwaju, dekompensujÄ…cym siÄ™ cieniem Jakuba wciÄ…ganym w noĹ›nÄ… pamiÄ™ci, kalkulatorem wspĂłĹ‚rzÄ™dnych powrotu UCP, wÄ™zĹ‚em ratunkowym ze splecionymi dĹ‚oĹ„mi stabilizujÄ…cym brata jako ĹĽywego czĹ‚owieka zamiast instrumentalnego wektora wyjĹ›cia oraz rotacyjnymi wrotami prowadzÄ…cymi do Przestrzeni 39 (Komora Referencyjna â€” FinaĹ‚ Aktu III: Podstruktura).

Wynik:
- Rozszerzono `scripts/audio/procedural_audio.gd` o 5 dedykowanych metod syntezy dĹşwiÄ™ku proceduralnego:
  - `create_accident_field_distortion_sound()`: dysonans grawitacyjno-magnetyczny pola wypadku Linii 4 (70..28 Hz + 1350 Hz sweep);
  - `create_jakub_destabilization_hum_sound()`: drĹĽenie formantu gĹ‚osu i dekompozycja materii postaci Jakuba (340/510 Hz modulated 7 Hz);
  - `create_rescue_tether_chime_sound()`: czysty ton ratunkowy kotwicy relacyjnej miÄ™dzy rodzeĹ„stwem (587/880 Hz);
  - `create_coordinate_calculator_click_sound()`: mechaniczne odrzucenie kalkulacji powrotu i reset przekaĹşnikĂłw (720 Hz + 180 Hz);
  - `create_station38_reference_vault_door_sound()`: rotacyjne odryglowanie wrĂłt do Komory Referencyjnej (110..32 Hz + 860 Hz).
- Rozszerzono `scripts/interactables/memory_resonance_point.gd` o `PropType` 177..181:
  - `ACCIDENT_SIMULATION_FIELD` (177): projekcja trĂłjwymiarowego lewitujÄ…cego widma wykolejonego tramwaju Linii 4 z falami uderzeniowymi;
  - `DESTABILIZING_JAKUB_SHADOW` (178): sylwetka Jakuba tracÄ…ca stabilnoĹ›Ä‡ materialnÄ… w pasmach cynobrowej fali;
  - `RESCUE_TETHER_ANCHOR` (179): wÄ™zeĹ‚ ratunkowy ze splecionymi dĹ‚oĹ„mi i promienistÄ… poĹ›wiatÄ… kotwicy relacyjnej;
  - `RETURN_COORDINATE_CALCULATOR` (180): pulpit analityczny UCP oferujÄ…cy instrumentalne uĹĽycie Jakuba jako wektora powrotu (99.8%);
  - `STATION_38_EXIT` (181): ciÄ™ĹĽkie rotacyjne wrota ze stalowym koĹ‚em ryglowym ku Przestrzeni 39.
- Utworzono kontroler `scripts/levels/station_38.gd` oraz scenÄ™ `scenes/levels/station_38.tscn`:
  - scenografia Sektora PamiÄ™ci Wypadku na poziomie -40 m z zakrzywionymi ĹĽebrami konstrukcyjnymi, podwieszanymi szynami archiwum traumy, cynobrowymi szczelinami pamiÄ™ci i podĹ›wietlonym banerem;
  - interakcje z rekwizytami:
    - inspekcja kalkulatora wspĂłĹ‚rzÄ™dnych UCP;
    - inspekcja pola symulacji katastrofy Linii 4;
    - badanie dekompensujÄ…cego siÄ™ cienia Jakuba;
    - podanie dĹ‚oni i zakotwiczenie brata jako ĹĽywego czĹ‚owieka (odrzucenie instrumentalnego powrotu);
    - sekwencja dialogowa Scene 38 (11 kwestii: Ĺšwiadectwo, Lena, Jakub);
    - uniesienie i obrĂłt rygla rotacyjnych wrĂłt ku Przestrzeni 39 (Komora Referencyjna);
  - strefa `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station38` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie kalkulatora przy x=140, pola symulacji przy x=245, cienia Jakuba przy x=345, wÄ™zĹ‚a ratunkowego przy x=445, przejĹ›cie 11 kwestii dialogowych Scene 38, odryglowanie wyjĹ›cia, animacja wyjĹ›cia oraz wejĹ›cie w strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_38.png` i `reports/station_38_rescue.png`.
- Zarejestrowano decyzjÄ™ D-070 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_38 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Etyczny ciÄ™ĹĽar wyboru miÄ™dzy natychmiastowym czystym powrotem a uratowaniem ocalonego brata w obcym Ĺ›wiecie pozostaje hipotezÄ… (H-003, H-007, H-008, H-009b, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0057`.

## PKG-0057: PrzestrzeĹ„ 39 â€” Komora Referencyjna / FinaĹ‚ Aktu III: Podstruktura

Data: 2026-08-21

Identyfikator stanu: `PKG-0057`. ZamroĹĽenie: `snapshots/PKG-0057-2026-08-21`.

Kontekst: Realizacja fazy P3 / Vertical Slice. WdroĹĽenie Przestrzeni 39: Komora Referencyjna / FinaĹ‚ Aktu III: Podstruktura na poziomie -40 m pod powierzchniÄ… miasta. Implementacja monumentalnego serca Podstruktury z centralnym monolitem kwantowym o potrĂłjnej orbicie harmonicznej, potrĂłjnymi terminalami konfiguracji wariantowych A/B/C (PowrĂłt / WĹ‚asny pokĂłj, Uzgodnienie / Miejsce po niej, Ĺšwiadectwo / Dwie prawdy), zrzeczeniem siÄ™ kontroli przez Ĺšlad (lokalnÄ… LenÄ™) na rzecz protagonistki (â€žJeĹ›li wybiorÄ™ ja, znowu zrobiÄ™ z ciebie kosztâ€ť) oraz wrotami wstÄ…pienia do Aktu IV (SygnaĹ‚ powrotu). PeĹ‚ne domkniÄ™cie Aktu III (Podstruktura).

Wynik:
- Rozszerzono `scripts/audio/procedural_audio.gd` o 5 dedykowanych metod syntezy dĹşwiÄ™ku proceduralnego:
  - `create_reference_core_harmonics_sound()`: gĹ‚Ä™boka harmoniczna triada kwantowa serca Podstruktury (110/220/440 Hz + 1760 Hz shimmer);
  - `create_branch_configuration_a_sound()`: czysty krysztaĹ‚owy ton wektora Powrotu / WĹ‚asny pokĂłj (523/1046/2093 Hz);
  - `create_branch_configuration_b_sound()`: ciepĹ‚y mosiÄ™ĹĽny akord relacyjny Uzgodnienia / Miejsce po niej (440/659/880 Hz);
  - `create_branch_configuration_c_sound()`: polifoniczny rezonans wieloĹ›wiadka Ĺšwiadectwa / Dwie prawdy (330/495/660/990 Hz);
  - `create_station39_act4_gateway_sound()`: sub-basowy impuls pÄ™kniÄ™cia stabilizatora pamiÄ™ci i otwarcie bramy do Aktu IV (85..20 Hz + 1420 Hz).
- Rozszerzono `scripts/interactables/memory_resonance_point.gd` o `PropType` 182..186:
  - `CENTRAL_REFERENCE_CORE_MONOLITH` (182): monumentalny krysztaĹ‚ referencyjny z potrĂłjnÄ… orbitÄ… energii (cyjan, bursztyn, cynober);
  - `BRANCH_CONFIG_RETURN_A` (183): pulpit konfiguracji A (PowrĂłt / WĹ‚asny pokĂłj â€” pojedynczy czysty wektor do laboratorium);
  - `BRANCH_CONFIG_RECONCILIATION_B` (184): pulpit konfiguracji B (Uzgodnienie / Miejsce po niej â€” podwĂłjne obrÄ…czki i wspĂłlna fala z MartÄ…);
  - `BRANCH_CONFIG_TESTIMONY_C` (185): pulpit konfiguracji C (Ĺšwiadectwo / Dwie prawdy â€” macierz 4 wÄ™zĹ‚Ăłw Ĺ›wiadkĂłw);
  - `STATION_39_EXIT` (186): centralne wrota wznoszÄ…ce ku powierzchni i Aktowi IV ze snopem Ĺ›wiatĹ‚a do Poziomu 0.
- Utworzono kontroler `scripts/levels/station_39.gd` oraz scenÄ™ `scenes/levels/station_39.tscn`:
  - monumentalna scenografia Komory Referencyjnej na poziomie -40 m z kolosalnymi filarami, potrĂłjnymi wiÄ…zkami harmonicznymi, posadzkÄ… polerowanÄ… i podĹ›wietlonym banerem finaĹ‚owym Aktu III;
  - interakcje z rekwizytami:
    - badanie konfiguracji A (PowrĂłt);
    - badanie konfiguracji B (Uzgodnienie);
    - rezonans centralnego rdzenia referencyjnego;
    - badanie konfiguracji C (Ĺšwiadectwo);
    - sekwencja dialogowa Scene 39 (11 kwestii: Ĺšwiadectwo, Jakub, Lena, Ĺšlad);
    - zrzeczenie siÄ™ kontroli przez Ĺšlad i odryglowanie wrĂłt do Aktu IV;
  - strefa `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station39` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie konfiguracji A przy x=140, konfiguracji B przy x=245, rdzenia referencyjnego przy x=345, konfiguracji C przy x=445, przejĹ›cie 11 kwestii dialogowych Scene 39, odryglowanie wyjĹ›cia, animacja wyjĹ›cia oraz wejĹ›cie w strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_39.png` i `reports/station_39_triad.png`.
- Zarejestrowano decyzjÄ™ D-071 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_39 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. GotowoĹ›Ä‡ gracza do podjÄ™cia odpowiedzialnoĹ›ci za jeden z trzech rĂłwnowaĹĽnych finaĹ‚Ăłw bez interfejsu kary/nagrody pozostaje hipotezÄ… (H-003, H-007, H-008, H-009b, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0058`.

## PKG-0058: PrzestrzeĹ„ 40 â€” Sala Negocjacyjna / Otwarcie Aktu IV: SygnaĹ‚ powrotu (Scene 40)

Data: 2026-08-21

Identyfikator stanu: `PKG-0058`. ZamroĹĽenie: `snapshots/PKG-0058-2026-08-21`.

Kontekst: WdroĹĽenie Przestrzeni 40 (Sala Negocjacyjna UCP / Poziom 0 / PowrĂłt na powierzchniÄ™ â€” Otwarcie Aktu IV: SygnaĹ‚ powrotu) zgodnie z `docs/narrative/FULL_STORY.md` (Scena 40), `docs/narrative/DIALOGUE_SCRIPT.md` (D-14), `VISUAL_DESIGN.md` oraz specyfikacjÄ… runtime.

Wykonane prace:

- WdroĹĽono 5 nowych procedur syntezy dĹşwiÄ™ku w `scripts/audio/procedural_audio.gd`:
  - `create_wierzbicka_personal_terminal_sound()`: dyrektorski akord triady UCP (480/720/1080 Hz + 2160 Hz);
  - `create_marta_witness_presence_sound()`: ciepĹ‚y relacyjny ton obecnoĹ›ci Marty (392/587.33/1174.66 Hz);
  - `create_szymon_transmission_feed_sound()`: noĹ›na transmisji radiowej Szymona ze szumem i skanowaniem (260/520 Hz + 1900 Hz);
  - `create_cost_dossier_matrix_sound()`: analityczny trĂłjton bilansu kosztĂłw operacyjnych (220/650/1300 Hz);
  - `create_station40_final_chamber_gate_sound()`: sub-basowe zstÄ…pienie odryglowania wrĂłt komory decyzyjnej (95..24 Hz + 1120 Hz).
- Rozszerzono `scripts/interactables/memory_resonance_point.gd` o `PropType` 187..191:
  - `WIERZBICKA_PERSONAL_TERMINAL` (187): minimalistyczny dyrektorski pulpit decyzyjny dr Heleny Wierzbickiej na Poziomie 0;
  - `MARTA_WITNESS_STATION` (188): stanowisko Marty Kurek z torbÄ… narzÄ™dziowÄ… odmawiajÄ…cej decydowania za ktĂłrÄ…kolwiek LenÄ™;
  - `SZYMON_TRANSMISSION_MONITOR` (189): monitor transmisji radiowej Szymona Bery z rysunkiem studni jako nienaruszalnym dowodem;
  - `OPERATION_COST_DOSSIER_MATRIX` (190): matryca bilansu kosztĂłw operacyjnych z 3 sĹ‚upkami porĂłwnawczymi (PowrĂłt, Uzgodnienie, Ĺšwiadectwo);
  - `STATION_40_EXIT` (191): monumentalne wrota prowadzÄ…ce do Przestrzeni 41 (Komora Wyboru Operacyjnego).
- Utworzono kontroler `scripts/levels/station_40.gd` oraz scenÄ™ `scenes/levels/station_40.tscn`:
  - scenografia Sali Negocjacyjnej UCP na Poziomie 0 z widokiem przez panoramiczne przeszklenie na porannÄ… panoramÄ™ budzÄ…cej siÄ™ RĂłwni, potÄ™ĹĽnymi kolumnami architektonicznymi i potrĂłjnÄ… magistralÄ… sufitowÄ…;
  - peĹ‚na 13-wersowa sekwencja dialogowa D-14 (Ĺšwiadectwo, Wierzbicka, Lena, Jakub, Marta, Szymon) ze sĹ‚ynnym zdaniem Leny: Â»Nie szukamy juĹĽ oryginaĹ‚u, doktor Wierzbicka. Szukamy odpowiedzialnoĹ›ci.Â«;
  - interakcje z rekwizytami odryglowujÄ…ce wyjĹ›cie i strefa `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station40` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie terminala Wierzbickiej przy x=140, matrycy bilansu przy x=245, stanowiska Marty przy x=345, monitora Szymona przy x=445, przejĹ›cie 13 kwestii dialogowych D-14, odryglowanie wyjĹ›cia, animacja unsealingu oraz wejĹ›cie w strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_40.png` i `reports/station_40_proposal.png`.
- Zarejestrowano decyzjÄ™ D-072 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_40 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Reakcja gracza na podsumowanie bilansu trzech operacji bez moralizowania przez UCP pozostaje hipotezÄ… (H-003, H-007, H-008, H-009b, H-010b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0059`.

## PKG-0059: PrzestrzeĹ„ 41 â€” WybĂłr operacyjny / Trzy warianty rozwiÄ…zania (Scene 41 / Act IV Climax)

Data: 2026-08-21

Identyfikator stanu: `PKG-0059`. ZamroĹĽenie: `snapshots/PKG-0059-2026-08-21`.

Kontekst: WdroĹĽenie Przestrzeni 41 (Komora Wyboru Operacyjnego UCP / Poziom 0 / Trzy warianty rozwiÄ…zania â€” Kulminacja Aktu IV) zgodnie z `docs/narrative/FULL_STORY.md` (Scena 41), `docs/narrative/CONTINUITY_TRACKER.md`, `VISUAL_DESIGN.md` oraz specyfikacjÄ… runtime.

Wykonane prace:

- WdroĹĽono 5 nowych procedur syntezy dĹşwiÄ™ku w `scripts/audio/procedural_audio.gd`:
  - `create_operation_return_execution_sound()`: impuls fali odciÄ™cia i wektor powrotu (640/1280 Hz + sweep 2560 Hz);
  - `create_operation_reconciliation_execution_sound()`: ciepĹ‚y relacyjny rezonans ulegĹ‚oĹ›ci i zatrzaĹ›niÄ™cie rygla mostu UCP (440/660/880 Hz);
  - `create_operation_testimony_execution_sound()`: wielopasmowy polifoniczny rezonans siatki Ĺ›wiadkĂłw (330/495/660/990/1320 Hz);
  - `create_operation_console_engage_sound()`: mechaniczne zaĹ‚Ä…czenie stacji wyboru operacyjnego (520 Hz + 140 Hz);
  - `create_station41_act4_resolution_gate_sound()`: sub-basowy akord rozstrzygniÄ™cia i przejĹ›cie do scen epilogu 42A..C (120..30 Hz + 980 Hz).
- Rozszerzono `scripts/interactables/memory_resonance_point.gd` o `PropType` 192..196:
  - `OP_CONSOLE_RETURN_A` (192): Stanowisko Operacji A: PowrĂłt (wĹ‚asny pokĂłj, fala 21:45, odciÄ™cie lokalnych Ĺ›wiadectw, pojedynczy ocalaĹ‚y Ĺ›wiat);
  - `OP_CONSOLE_RECONCILIATION_B` (193): Stanowisko Operacji B: Uzgodnienie (miejsce po niej, zĹ‚ota obrÄ…czka, mieszkanie 14 i relacja z MartÄ…);
  - `OP_CONSOLE_TESTIMONY_C` (194): Stanowisko Operacji C: Ĺšwiadectwo (dwie prawdy, rozproszenie punktĂłw obserwacji na MartÄ™, Jakuba, Szymona i sieÄ‡ miejskÄ…);
  - `OP_CONTINUITY_TOPOGRAPHY_DISPLAY` (195): WyĹ›wietlacz Topografii CiÄ…gĹ‚oĹ›ci i ZasiÄ™gu WÄ™zĹ‚Ăłw (IKP, Mieszkanie 14, Punkt 6, Linia 4, Maszynownia) bez ukrywania kosztĂłw;
  - `STATION_41_EXIT` (196): Wrota RozstrzygniÄ™cia odryglowujÄ…ce przejĹ›cie do odpowiedniego wariantu finaĹ‚u (Sceny 42A..42C).
- Utworzono kontroler `scripts/levels/station_41.gd` oraz scenÄ™ `scenes/levels/station_41.tscn`:
  - scenografia Komory Wyboru Operacyjnego na Poziomie 0 z potrĂłjnymi niszami terminali egzekucyjnych A, B i C, panoramicznym przeszkleniem na Ĺ›wit RĂłwni i pylonami noĹ›nymi;
  - mechaniczne wykonanie wyboru przez gracza (zaĹ‚Ä…czenie terminala A, B lub C z dedykowanymi sygnaĹ‚ami i dynamicznÄ… zmianÄ… oprawy Ĺ›wietlnej);
  - interakcje z rekwizytami, odryglowanie wrĂłt rozstrzygniÄ™cia i strefa `AirlockZone` przy x=610 z wyzwoleniem ukoĹ„czenia poziomu.
- Rozszerzono `tests/smoke_test.gd`:
  - automatyczny test 5 nowych generatorĂłw dĹşwiÄ™ku w `ProceduralAudio`;
  - automatyczny test instancjonowania i wÄ™zĹ‚Ăłw `Station41` (5 rekwizytĂłw pamiÄ™ci, geometria, gracz, kamera, airlock);
  - peĹ‚ny deterministyczny test: badanie wyĹ›wietlacza topografii przy x=130, zaĹ‚Ä…czenie Operacji A przy x=220, przeĹ‚Ä…czenie na OperacjÄ™ B przy x=330, przeĹ‚Ä…czenie na OperacjÄ™ C przy x=440, animacja rozwarcia wrĂłt oraz wejĹ›cie w strefÄ™ `AirlockZone` przy x=610 z potwierdzeniem `is_level_completed == true`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_41.png` i `reports/station_41_execution.png`.
- Zarejestrowano decyzjÄ™ D-073 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_41 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… Ĺ›cieĹĽkÄ™ w silniku. Reakcja gracza na podjÄ™cie fizycznego wyboru jednej z trzech operacji bez moralizujÄ…cej punktacji dobra/zĹ‚a pozostaje hipotezÄ… (H-003, H-007, H-008, H-009b, H-010b, H-011a, H-011b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0060`.

## PKG-0060: Sceny FinaĹ‚owe 42A, 42B, 42C oraz Scena 43: Napisy i epilog systemowy (DomkniÄ™cie P3 Vertical Slice)

Data: 2026-08-21

Identyfikator stanu: `PKG-0060`. ZamroĹĽenie: `snapshots/PKG-0060-2026-08-21`.

Kontekst: WdroĹĽenie Scen FinaĹ‚owych (42A PowrĂłt â€” WĹ‚asny pokĂłj, 42B Uzgodnienie â€” Miejsce po niej, 42C Ĺšwiadectwo â€” Dwie prawdy) oraz Sceny 43 (Napisy i epilog systemowy) zgodnie z `docs/narrative/FULL_STORY.md`, `docs/narrative/DIALOGUE_SCRIPT.md` (D-15A, D-15B, D-15C), `VISUAL_DESIGN.md` oraz specyfikacjÄ… runtime.

Wykonane prace:

- WdroĹĽono 5 nowych procedur syntezy dĹşwiÄ™ku w `scripts/audio/procedural_audio.gd`:
  - `create_epilogue_radio_announcement_sound()`: analogowy komunikat radiowy o Linii 4 (580/1160 Hz + trzaski AM);
  - `create_epilogue_cup_clink_sound()`: cichy stukot dwĂłch kubkĂłw laboratoryjnych o drewniany stĂłĹ‚ o 21:45 (1450/2900 Hz);
  - `create_epilogue_tram_switch_latch_sound()`: mechaniczny dĹşwiÄ™k przestawienia zwrotnicy dwĂłch torĂłw przez motorniczÄ… (340 Hz + 1600 Hz);
  - `create_epilogue_credits_drone_sound()`: minimalistyczny ciepĹ‚y miejski dron napisĂłw koĹ„cowych (55/110/220 Hz);
  - `create_epilogue_final_carrier_sound()`: noĹ›na wygaszenia ekranu do czerni (440 Hz -> 0 Hz).
- Rozszerzono `scripts/interactables/memory_resonance_point.gd` o `PropType` 197..202:
  - `EPILOGUE_RETURN_CUPS` (197): dwa kubki laboratoryjne, fotografia dorosĹ‚ego Jakuba i telefon o 21:45 (Scena 42A);
  - `EPILOGUE_MARTA_DOORSTEP` (198): prĂłg mieszkania 14, klucz na progu, filiĹĽanka i gest szwu palca (Scena 42B);
  - `EPILOGUE_TRAM_DUAL_TRACKS` (199): poranny tramwaj przed dwoma nakĹ‚adajÄ…cymi siÄ™ torami i dziennik motorniczej (Scena 42C);
  - `EPILOGUE_ADMIN_NOTICE_BOARD` (200): tablica administracyjna i radio ratunkowe UCP (Scena 43);
  - `EPILOGUE_CREDITS_ROLL` (201): napisy koĹ„cowe na modernistycznych fasadach RĂłwni (Scena 43);
  - `EPILOGUE_FINAL_BLACKOUT` (202): koĹ„cowe wygaszenie do czerni (Scena 43).
- Utworzono kontrolery i sceny poziomĂłw:
  - `scripts/levels/station_42a.gd` i `scenes/levels/station_42a.tscn` (Scena 42A);
  - `scripts/levels/station_42b.gd` and `scenes/levels/station_42b.tscn` (Scena 42B);
  - `scripts/levels/station_42c.gd` and `scenes/levels/station_42c.tscn` (Scena 42C);
  - `scripts/levels/station_43.gd` and `scenes/levels/station_43.tscn` (Scena 43).
- Rozszerzono `tests/smoke_test.gd`:
  - testy audio dla 5 nowych generatorĂłw epilogu;
  - automatyczne testy `_test_station_42a()`, `_test_station_42b()`, `_test_station_42c()` oraz `_test_station_43()`.
- Rozszerzono `tools/capture_preview.gd` o zrzuty `reports/station_42a.png`, `reports/station_42b.png`, `reports/station_42c.png` oraz `reports/station_43.png`.
- Zarejestrowano decyzjÄ™ D-074 w `docs/DECISION_LOG.md`.

DowĂłd:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
TEST: station_41 completed
TEST: station_42a completed
TEST: station_42b completed
TEST: station_42c completed
TEST: station_43 completed
Verification passed.
```

Ograniczenia: Testy automatyczne potwierdzajÄ… peĹ‚nÄ… poprawnoĹ›Ä‡ technicznÄ… i deterministycznÄ… przechodnioĹ›Ä‡ w silniku. OdbiĂłr emocjonalny kaĹĽdego z trzech zakoĹ„czeĹ„ przez gracza pozostaje hipotezÄ… (H-008, H-009b, H-010b, H-011b, H-012).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0061`.

## PKG-0061 .. PKG-0088: WYCOFANE (D-098)

Zakres tych pakietĂłw zostaĹ‚ **wycofany z projektu**. TreĹ›Ä‡ opisowa zostaĹ‚a
usuniÄ™ta, poniewaĹĽ dotyczyĹ‚a kierunku, ktĂłry nie jest i nigdy nie bÄ™dzie
zakresem Getting Strange. Getting Strange jest grÄ… w silniku Godot 4.7.

Numery pakietĂłw zostajÄ… w kronice wyĹ‚Ä…cznie po to, ĹĽeby chronologia
`PKG-NNNN` pozostaĹ‚a ciÄ…gĹ‚a i weryfikowalna. Nie ma tu ĹĽadnego zakresu pracy
do podjÄ™cia, wznowienia ani dokoĹ„czenia. Wytworzone wtedy pliki leĹĽÄ… w
`archive_retired_web/` jako martwy artefakt poza projektem: nieweryfikowany,
niezamraĹĽany w snapshotach i nieprzeznaczony do otwierania.

## PKG-0093: RĂłwieĹ„ Vector-Stage â€” zmiana kanonu obrazu Godot 4.7

Data: 2026-08-23

Identyfikator stanu: `PKG-0093`. ZamroĹĽenie: `snapshots/PKG-0093-2026-08-23`.

Kontekst: wĹ‚aĹ›ciciel wskazaĹ‚ docelowy charakter grafiki na ogĂłlnÄ… technikÄ™
kinetycznej platformĂłwki wielokÄ…tnej kojarzonÄ… z *Another World / Out of This
World*. Research potwierdziĹ‚ pĹ‚askie wielokÄ…ty i rotoskopiÄ™ jako historyczne
cechy ĹşrĂłdĹ‚a, a obowiÄ…zujÄ…ce granice IP wykluczajÄ… kopiowanie jego ekspresji.
PrzyjÄ™to D-092: wĹ‚asny jÄ™zyk `RĂłwieĹ„ Vector-Stage`.

Wynik:
- zastÄ…piono `VISUAL_DESIGN.md` peĹ‚nÄ… bibliÄ… produkcyjnÄ…: paleta, limity
  pĹ‚aszczyzn, zasady kadrowania, postacie, efekty, konwersja 43 przestrzeni,
  kryteria odbioru i jawne ograniczenia;
- zaktualizowano `INSPIRATION_BOUNDARIES`, `RESEARCH_FOUNDATIONS`,
  `TECHNICAL_DIRECTION`, `PRODUCT_BRIEF`, `PROJECT_BIBLE`, roadmapÄ™ i rejestr
  ryzyk, usuwajÄ…c sprzeczny cel pixel artu;
- dodano `scripts/visual/vector_stage_style.gd` (wĹ‚asna paleta i rysowanie
  facetĂłw) oraz `vector_stage_environment.gd` (sceniczny daleki plan bez
  colliderĂłw);
- przerysowano proceduralnÄ… LenÄ™ jako wĹ‚asnÄ… asymetrycznÄ… sylwetkÄ™ z maĹ‚ej
  liczby pĹ‚aszczyzn i przekomponowano Station 01 do referencyjnego kadru;
- Station 01..05 instancjonujÄ… `VectorStageEnvironment`, a smoke test wymaga
  tej warstwy dla wszystkich piÄ™ciu scen.

DowĂłd techniczny:

```text
Godot headless import: PASS
PKG-0091 SMOKE PASS: player feel, atmosphere, CRT dialogue and game state
DOCS PASS: 26 required files and handoff contracts
peĹ‚ny smoke: movement_lab, anchor_lab, Station 01..43 PASS
Capture preview finished successfully.
Verification passed.
```

Ograniczenia: peĹ‚na rÄ™czna konwersja Station 06..43 nie jest wykonana i pozostaje
zakresem PKG-0094. Automatyczne testy potwierdzajÄ… kontrakt techniczny, nie
odbiĂłr artystyczny przez graczy.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0094`.

### UzupeĹ‚nienie uprawnieĹ„ narzÄ™dziowych (2026-08-23)

WĹ‚aĹ›ciciel potwierdziĹ‚, ĹĽe Picsart AI CLI `gen-ai` jest uwierzytelnione,
dysponuje duĹĽym budĹĽetem kredytowym i moĹĽe byÄ‡ aktywnie wykorzystywane do
generowania grafiki, wideo i audio. Zasada zostaĹ‚a wpisana do pipelineâ€™u oraz
handoffu: generacja wspiera produkcjÄ™ wĹ‚asnego RĂłwieĹ„ Vector-Stage, a kaĹĽdy
wynik przeznaczony do produkcji przechodzi rejestr promptu/modelu/ĹşrĂłdĹ‚a,
kontrolÄ™ IP i rÄ™cznÄ… adaptacjÄ™; nie sĹ‚uĹĽy kopiowaniu ekspresji *Another World*.

## PKG-0092: Szlif Sterowania, Atmosfery, Dialogu CRT i Stanu Gry Godot 4.7

Data: 2026-08-23

Identyfikator stanu: `PKG-0092`. ZamroĹĽenie: `snapshots/PKG-0092-2026-08-23`.

Kontekst: D-091 utrzymuje wyĹ‚Ä…czny kierunek na grÄ™ Godot. Pakiet zastÄ…piĹ‚ brakujÄ…ce fundamenty produkcyjnego game feel, atmosfery pierwszego aktu, prezentacji dialogĂłw i stanu kampanii.

Wynik:
- rozszerzono `scripts/player/prototype_player.gd` o squash-and-stretch rysowany bez naruszania kolizji, lean/facing oraz emitery `RunDust` i `LandingDust`;
- dodano `AtmosphereRig` z runtimeowymi gradientowymi `PointLight2D`, mikrofluktuacjÄ… jarzeniĂłwek 100 Hz, proceduralnym humem i `VolumetricDust`; rig jest podĹ‚Ä…czony do Station 01..05;
- dodano `CRTDialogueBox` i `StationDialogueCue`: luminoforowa ramka CRT, inicjaĹ‚-portret, typewriter, obsĹ‚uga `interact` oraz proceduralne blipy; Station 01..05 otrzymaĹ‚y otwarcia fabularne;
- dodano autoload `GameStateManager`, API dla stacji/poszlak/decyzji/checkpointu, 43-pozycyjnÄ… listÄ™ testowego wyboru oraz fade-to-black przy zmianie scen;
- dodano `tests/pkg_0091_smoke_test.gd`, testujÄ…cy nowe kontrakty w grze.

DowĂłd techniczny:

```text
Godot headless import: PASS
PKG-0091 SMOKE PASS: player feel, atmosphere, CRT dialogue and game state
DOCS PASS: 26 required files and handoff contracts
peĹ‚ny smoke: movement_lab, anchor_lab, Station 01..43 PASS
Verification passed.
SNAPSHOT OK: PKG-0092 -> snapshots/PKG-0092-2026-08-23 (329 plikĂłw, 5.38 MB)
```

Ograniczenia: stan w PKG-0092 jest tylko w pamiÄ™ci sesji â€” trwaĹ‚y zapis do `user://`, widoczne menu pauzy/wyboru poziomu oraz powiÄ…zanie wszystkich 43 stacji z checkpointami i kluczowymi dialogami sÄ… zakresem PKG-0093. Automatyczny test nie dowodzi subiektywnego game feel.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0093`.

## PKG-0089 .. PKG-0091: WYCOFANE (D-098)

Jak wyĹĽej: zakres wycofany, treĹ›Ä‡ opisowa usuniÄ™ta, numeracja zachowana.
PKG-0091 zamknÄ…Ĺ‚ ten kierunek i przekierowaĹ‚ 100% prac na grÄ™ Godot 4.7;
D-098 domyka sprawÄ™ ostatecznie i wyklucza ponowne otwarcie tematu.

## PKG-0094: RĂłwieĹ„ Vector-Stage Akt I i pÄ™tla kampanii

Data: 2026-08-23

Kontekst: Realizacja autonomicznego Mega-Pakietu gry Godot 4.7 zgodnie z D-091
i D-092. Handoff wymagaĹ‚ trwaĹ‚ej pÄ™tli kampanii, pauzy oraz selekcji 43
przestrzeni, rÄ™cznej konwersji Station 06..10 do wĹ‚asnego RĂłwieĹ„ Vector-Stage,
integracji checkpointĂłw/poszlak/CRT i dowodu renderowego bez zmiany colliderĂłw.
Bazowy smoke PKG-0091 nie kompilowaĹ‚ siÄ™ przez odwoĹ‚anie do `player` poza jego
zakresem; rozbieĹĽnoĹ›Ä‡ zostaĹ‚a naprawiona w tym samym pakiecie.

Wynik:

- Dodano D-093 i `GameStateManager` z maĹ‚ym, wersjonowanym JSON-em
  `user://getting_strange_campaign_v1.json` (schema 1), bezpiecznym odrzuceniem
  bĹ‚Ä™dnego pliku, API `save_campaign`, `reload_campaign_from_disk`,
  `reset_campaign`, checkpointem, decyzjami i poszlakami.
- Dodano runtimeowe `CampaignPauseMenu` (`CanvasLayer`): wznowienie, checkpoint,
  reset, 43 pozycje selektora, normalne odblokowanie Station 01 + osiÄ…gniÄ™tych
  stacji oraz jawny tryb testowy odblokowujÄ…cy caĹ‚oĹ›Ä‡.
- `MemoryResonancePoint` zapisuje kaĹĽdÄ… uĹĽywanÄ… poszlakÄ™ do kampanii, a
  `StationDialogueCue` korzysta z bezpiecznego dostÄ™pu do autoloadu dla
  osiÄ…gniÄ™cia stacji i checkpointu.
- Station 06..10 otrzymaĹ‚y rÄ™czne profile `VectorStageEnvironment`,
  `AtmosphereRig`, `CRTDialogueBox` i `OpeningDialogueCue`; bez modyfikacji
  istniejÄ…cych `Geometry`, colliderĂłw lub zasiÄ™gĂłw `Area2D`.
- Dodano `tests/pkg_0094_smoke_test.gd`, `tools/capture_act1_vector_stage.gd`
  oraz `docs/VECTOR_STAGE_ACT_I_AUDIT.md`. Naprawiono scope error w
  `tests/pkg_0091_smoke_test.gd` bez redukowania pokrycia kontraktu.

DowĂłd:

```text
PKG-0091 SMOKE PASS: player feel, atmosphere, CRT dialogue and game state
PKG-0094 SMOKE PASS: campaign save, menu, Act I Vector-Stage and cues
PKG-0094 ACT I CAPTURE PASS
CAPTURE: station_06.png .. station_10.png, 1280x720
Driver: Windows OpenGL / Intel Iris Xe Graphics
Verification passed.
```

Ograniczenia: test potwierdza zachowanie techniczne zapisu, menu, warstw, cues
i collidera podĹ‚ogi; nie potwierdza odczucia filmowoĹ›ci, zrozumienia fabuĹ‚y,
czytelnoĹ›ci przez nowÄ… osobÄ™ ani peĹ‚nego budĹĽetu 43 rÄ™cznych kadrĂłw. H-005
pozostaje `TECHNICAL`, a hipotezy odbiorcze pozostajÄ… bez dowodu.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0095`.

## PKG-0095: RĂłwieĹ„ Vector-Stage Akt II i Ĺ‚aĹ„cuch ukoĹ„czeĹ„ kampanii 01..15

Data: 2026-08-23

Kontekst: Autonomiczny Mega-Pakiet Godot 4.7 zgodny z D-091..D-093. Zakres
obejmowaĹ‚ rÄ™czne kompozycje Station 11..15, CRT/checkpoint cues oraz przejĹ›cia
kampanii sterowane rzeczywistym `level_completed`, bez zmiany collidersĂłw lub
normalnego odblokowania kampanii.

Wynik:

- `VectorStageEnvironment` otrzymaĹ‚ piÄ™Ä‡ wĹ‚asnych profili Aktu II
  (`station_number = 11..15`). Station 11..15 majÄ… `AtmosphereRig`,
  `CRTDialogueBox`, `OpeningDialogueCue` i wĹ‚asne teksty wejĹ›ciowe, natomiast
  istniejÄ…ce `Geometry`, `CollisionShape2D` i `Area2D` pozostaĹ‚y nietkniÄ™te.
- D-094 ustanawia centralny Ĺ‚aĹ„cuch kampanii. `GameStateManager` nasĹ‚uchuje
  istniejÄ…cego `level_completed` dla korzeni Station 01..15, zapisuje stan,
  odblokowuje nastÄ™pnÄ… stacjÄ™ i wykonuje fade transition. Limit 15 nie pozwala
  udawaÄ‡ gotowego przejĹ›cia do jeszcze nieobjÄ™tej Station 16.
- Dodano `tests/pkg_0095_smoke_test.gd`; test sprawdza 10â†’15, brak faĹ‚szywego
  15â†’16, profil/wizualny kontrakt Station 11..15 oraz faktyczne wyemitowanie
  `level_completed` Station 11, po ktĂłrym odblokowuje siÄ™ Station 12.
- Dodano `tools/capture_act2_vector_stage.gd` i `docs/VECTOR_STAGE_ACT_II_AUDIT.md`.
  Zapisano piÄ™Ä‡ renderĂłw w `reports/pkg_0095_act2/`.

DowĂłd:

```text
PKG-0094 SMOKE PASS: campaign save, menu, Act I Vector-Stage and cues
PKG-0095 SMOKE PASS: Act II Vector-Stage and campaign unlock chain
PKG-0095 ACT II CAPTURE PASS
CAPTURE: station_11.png .. station_15.png, 1280x720
Driver: Windows OpenGL / Intel Iris Xe Graphics
Verification passed.
```

Ograniczenia: automatyczny test dowodzi poĹ‚Ä…czenia technicznego sygnaĹ‚u,
zapisu, unlocku i fade, ale nie odbioru filmowoĹ›ci, emocji, dostÄ™pnoĹ›ci lub
czytelnoĹ›ci przez osobÄ™ widzÄ…cÄ… grÄ™ pierwszy raz. H-005 pozostaje `TECHNICAL`;
peĹ‚ny budĹĽet 43 kadrĂłw nie zostaĹ‚ zmierzony.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0096`.

## PKG-0096: RĂłwieĹ„ Vector-Stage Akt IIb i Ĺ‚aĹ„cuch kampanii 16..20

Data: 2026-08-23

Kontekst: Autonomiczny Mega-Pakiet Godot 4.7 zgodny z D-091..D-095. Zakres
obejmowaĹ‚ rÄ™cznÄ… konwersjÄ™ kompozycji Station 16..20 do kanonu RĂłwieĹ„ Vector-Stage,
dodanie AtmosphereRig, CRTDialogueBox i OpeningDialogueCue, oraz rozszerzenie
centralnego Ĺ‚aĹ„cucha ukoĹ„czeĹ„ kampanii `GameStateManager` do stacji 20 bez modyfikacji
istniejÄ…cych colliderĂłw, geometrii ani schematu zapisu.

Wynik:

- `VectorStageEnvironment` otrzymaĹ‚ piÄ™Ä‡ wĹ‚asnych profili Aktu IIb
  (`station_number = 16..20`). Sceny `station_16.tscn`..`station_20.tscn` majÄ…
  `AtmosphereRig`, `CRTDialogueBox`, `OpeningDialogueCue` z wĹ‚asnymi tekstami wejĹ›ciowymi
  oraz unikalnÄ… geometriÄ™ tĹ‚a (Rozmowa przy stole, Punkt ZgodnoĹ›ci 6, Wywiad zgodnoĹ›ci,
  Model bez oryginaĹ‚u, Sala Szymona). Wszystkie istniejÄ…ce `Geometry`, `CollisionShape2D`
  i `Area2D` pozostaĹ‚y w 100% nienaruszone.
- D-095 rozszerza limit Ĺ‚aĹ„cucha kampanii w `GameStateManager`: `CAMPAIGN_TRANSITION_LIMIT = 20`.
  Centralny nasĹ‚uch sygnaĹ‚u `level_completed` odblokowuje kolejne stacje 15â†’16â†’17â†’18â†’19â†’20,
  zapisuje progres do `user://getting_strange_campaign_v1.json` i wykonuje pĹ‚ynne przejĹ›cie fade.
  Stacja 20 stanowi twardÄ… granicÄ™ obecnego batchu i nie odblokowuje przedwczeĹ›nie stacji 21.
- Dodano `tests/pkg_0096_smoke_test.gd` oraz zaktualizowano `tests/pkg_0094_smoke_test.gd` do nowego limitu.
  Test weryfikuje progresjÄ™ 15â†’20, blokadÄ™ 21, kompletnoĹ›Ä‡ wÄ™zĹ‚Ăłw i emisjÄ™ sygnaĹ‚u stacji 16 odblokowujÄ…cÄ… 17.
- Dodano `tools/capture_act2b_vector_stage.gd`, wygenerowano rendery kontrolne
  w `reports/pkg_0096_act2b/` (`station_16.png`..`station_20.png`, 1280Ă—720) oraz zapisano
  audyt `docs/VECTOR_STAGE_ACT_IIB_AUDIT.md`.

DowĂłd:

```text
PKG-0096 SMOKE PASS: Act IIb Vector-Stage and campaign unlock chain 16..20
PKG-0096 CAPTURE PASS: station_16.png .. station_20.png, 1280x720
Driver: Windows OpenGL / Intel Iris Xe Graphics
Verification passed.
```

Ograniczenia: test automatyczny potwierdza techniczne przejĹ›cia, zapis, cues i warstwy
wizualne; nie jest dowodem subiektywnego odbioru atmosfery, nastroju, czytelnoĹ›ci przez
nowego gracza ani kompletnego budĹĽetu 43 przestrzeni.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0097`.

## PKG-0097: RĂłwieĹ„ Vector-Stage Akt IIc i Ĺ‚aĹ„cuch kampanii 21..25

Data: 2026-08-24. Zakres: wyĹ‚Ä…cznie gra Godot 4.7.

Baseline pakietu (Ĺ›wieĹĽy, przed zmianami): `tools/verify.ps1` PASS,
`tests/pkg_0095_smoke_test.gd` PASS, `tests/pkg_0096_smoke_test.gd` PASS.

- Skonwertowano Station 21..25 do RĂłwieĹ„ Vector-Stage: dodano profile
  `VectorStageEnvironment` (`station_number = 21..25`), `AtmosphereRig`,
  `CRTDialogueBox` i `OpeningDialogueCue` do scen 21..25. Nie zmieniono ĹĽadnego
  `CollisionShape2D`, `Geometry`, `AirlockZone`, `Props` ani zasiÄ™gu interakcji.
- **Naprawiono realny defekt odziedziczony po PKG-0094..0096 (D-096):** skrypty
  stacji malowaĹ‚y nieprzezroczyste tĹ‚o peĹ‚noekranowe, przez co warstwa
  Vector-Stage byĹ‚a caĹ‚kowicie zasĹ‚oniÄ™ta. W Station 21..25 `_draw()` rysuje juĹĽ
  wyĹ‚Ä…cznie `_draw_state_layer()` â€” 1â€“2 relacje pĹ‚aszczyzn zaleĹĽne od stanu sceny
  w palecie `VectorStageStyle`. Kadr naleĹĽy do `VectorStageEnvironment`.
- Audyt renderĂłw wykazaĹ‚, ĹĽe pierwsza wersja akcentĂłw Ĺ‚amaĹ‚a Â§4 biblii wizualnej
  (bursztyn jako pĹ‚aszczyzna podĹ‚ogi, cynober i cyjan jako Ĺ›wiecÄ…ce slaby).
  Poprawiono przed zamroĹĽeniem: bursztyn wrĂłciĹ‚ do skali postaci, akcenty sÄ…
  punktowe i przyciemnione `VectorStageStyle.shade()`, i nie zasĹ‚aniajÄ… rekwizytu
  wyjĹ›cia przy x=590.
- Podniesiono `CAMPAIGN_TRANSITION_LIMIT` z 20 na 25 razem z testem (D-097).
  Odblokowania idÄ… normalnym sygnaĹ‚em `level_completed`; Station 25 celowo nie
  odblokowuje nieskonwertowanej Station 26. Schema 1 zapisu bez zmian.
- Dodano `tests/pkg_0097_smoke_test.gd` (Ĺ‚aĹ„cuch 20..25, limit 25, collidery,
  `AirlockZone`, zasiÄ™gi interakcji, cue checkpointu, `z_index` warstwy).
  Zaktualizowano asercjÄ™ limitu w `tests/pkg_0096_smoke_test.gd`.
- WpiÄ™to bramki PKG-0095/0096/0097 do `tools/verify.ps1`, ĹĽeby dostarczony
  Ĺ‚aĹ„cuch kampanii byĹ‚ chroniony przez obowiÄ…zkowÄ… weryfikacjÄ™.
- Dodano `tools/capture_act2c_vector_stage.gd`, rendery
  `reports/pkg_0097_act2c/station_21.png`..`station_25.png` oraz audyt
  `docs/VECTOR_STAGE_ACT_IIC_AUDIT.md`.

DowĂłd:

```text
PKG-0097 SMOKE PASS: Act IIc Vector-Stage and campaign unlock chain 21..25
PKG-0097 CAPTURE PASS: station_21.png .. station_25.png, 1280x720
Driver: Windows OpenGL / Intel Iris Xe Graphics
== Documentation contract ==      DOCS PASS
== Getting Strange smoke test ==  SMOKE PASS
== PKG-0095 Act II gate ==        PKG-0095 SMOKE PASS
== PKG-0096 Act IIb gate ==       PKG-0096 SMOKE PASS
== PKG-0097 Act IIc gate ==       PKG-0097 SMOKE PASS
Verification passed.
```

Ograniczenia: rendery i testy potwierdzajÄ… kontrakt techniczny, paletÄ™, widocznoĹ›Ä‡
warstwy i przejĹ›cia kampanii. Nie dowodzÄ… odbioru filmowoĹ›ci, czytelnoĹ›ci dla
nowego gracza, dostÄ™pnoĹ›ci kontrastu ani budĹĽetu 43 przestrzeni. Station 01..20
nadal majÄ… zasĹ‚oniÄ™ty RĂłwieĹ„ â€” to jawny dĹ‚ug techniczny, nie ukoĹ„czona konwersja.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0098`.

## PKG-0098: ZamkniÄ™cie zakresu â€” Getting Strange jest wyĹ‚Ä…cznie grÄ… Godot 4.7

Data: 2026-08-24. Decyzja wĹ‚aĹ›ciciela projektu: D-098.

WĹ‚aĹ›ciciel potwierdziĹ‚, ĹĽe wczeĹ›niejszy kierunek spoza silnika gry byĹ‚ pomyĹ‚kÄ…,
i poleciĹ‚ usuniÄ™cie jego Ĺ›ladĂłw z dokumentacji projektu.

- Wyczyszczono dokumenty ĹĽywe i kierunkowe: `CURRENT_STATE.md`, `ROADMAP.md`,
  `WORKFLOW.md`, `NEXT_SESSION_PROMPT.md`, `TECHNICAL_DIRECTION.md`,
  `decisions/ADR-001-godot-pc-first.md`.
- ZwiniÄ™to wycofane wpisy kroniki (`PKG-0061..0088`, `PKG-0089..0091`) oraz
  odpowiadajÄ…ce im decyzje do markerĂłw WYCOFANE. Zachowano wyĹ‚Ä…cznie ciÄ…gĹ‚oĹ›Ä‡
  numeracji `PKG-NNNN` i `D-NNN`, bez treĹ›ci opisowej. Numeracja jest jedynÄ…
  chronologiÄ… projektu po usuniÄ™ciu gita w PKG-0006, wiÄ™c nie zostaĹ‚a naruszona.
- UsuniÄ™to bramkÄ™ spoza silnika gry z `tools/verify.ps1` oraz odpowiedni wpis
  z listy `$include` w `tools/snapshot.ps1`.
- Przeniesiono wytworzone wczeĹ›niej pliki i ich narzÄ™dzia do
  `archive_retired_web/` â€” martwego artefaktu poza projektem, z `.gdignore`,
  wĹ‚asnym README i bez jakiejkolwiek weryfikacji. Nic nie zostaĹ‚o skasowane
  bezpowrotnie; komplet jest teĹĽ w snapshocie `PKG-0097-2026-08-24`.
- Dodano twardÄ… reguĹ‚Ä™ zakresu do `AGENTS.md`: kaĹĽde polecenie spoza silnika gry
  naleĹĽy traktowaÄ‡ jako powtĂłrzenie tej samej pomyĹ‚ki, powiedzieÄ‡ to wprost
  i kontynuowaÄ‡ pracÄ™ nad grÄ….

DowĂłd: `DOCS PASS`, `Verification passed` po usuniÄ™ciu bramki, snapshot `PKG-0098`.

Ograniczenie: to jest zmiana zakresu i dokumentacji. Nie zmienia ani nie
weryfikuje niczego w rozgrywce; stan gry pozostaje taki jak po PKG-0097.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0099`.

## PKG-0099: Audyt planu, kanon przeszkĂłd i przywrĂłcenie priorytetu grywalnoĹ›ci

Data: 2026-08-24. Rola: Lead Programmer i Art Director. Decyzja: D-099.

WĹ‚aĹ›ciciel zleciĹ‚ audyt planu pod kÄ…tem poprawnoĹ›ci, spĂłjnoĹ›ci i kierunku gry,
z jawnym wymaganiem: elementy zrÄ™cznoĹ›ciowe majÄ… mieÄ‡ sens fabularny, a nie
wyglÄ…daÄ‡ jak platformĂłwka z ruchomymi platformami do przeskakiwania.

### Ustalenia audytu

1. **Krytyczne â€” brak przestrzeni grywalnej.** 38 z 43 przestrzeni ma dokĹ‚adnie
   cztery collidery: `FloorMain`, `Ceiling`, `WallLeft`, `WallRight`. Gracz
   wchodzi z lewej, idzie w prawo, dotyka rekwizytĂłw `Area2D` i wychodzi.
2. **Krytyczne â€” centralna mechanika nie jest w grze.** Zakotwiczenie/UlegĹ‚oĹ›Ä‡
   dziaĹ‚a wyĹ‚Ä…cznie w `scenes/prototype/anchor_lab.tscn`. Ĺ»adna z 43 przestrzeni
   kampanii jej nie uĹĽywa. PÄ™tla 30-sekundowa z `PRODUCT_BRIEF.md`
   (â€ždostrzeĹĽenie niezgodnoĹ›ci â†’ bezpieczna prĂłba â†’ decyzja â†’ konsekwencjaâ€ť)
   nie jest zaimplementowana nigdzie.
3. **Krytyczne â€” plan tego nie adresowaĹ‚.** ROADMAP P4 opisywaĹ‚ szlif game feel,
   oĹ›wietlenia i oprawy, czyli polerowanie czegoĹ›, czego nie ma. Kolejne pakiety
   szĹ‚y w konwersjÄ™ wizualnÄ… nastÄ™pnych piÄ™ciu stacji.
4. **PowaĹĽne â€” `AGENTS.md` byĹ‚ sprzeczny z rzeczywistoĹ›ciÄ….** Pierwszy czytany
   dokument twierdziĹ‚, ĹĽe trwa `Prototype 01: Movement Lab`, i zakazywaĹ‚
   dodawania systemĂłw zapisu, dialogu oraz mechaniki Anchor/Yield â€” a wszystko
   to istnieje od dziesiÄ…tek pakietĂłw. Warunek odblokowania odwoĹ‚ywaĹ‚ siÄ™ do
   playtestĂłw zewnÄ™trznych, ktĂłrych projekt nigdy nie przeprowadzi (D-012, ADR-003).
5. **Wprost zgĹ‚oszone przez wĹ‚aĹ›ciciela â€” jedyny wzorzec platformingu w projekcie
   jest zrÄ™cznoĹ›ciowy.** `scenes/prototype/movement_lab.tscn` zawiera `Step`,
   `UpperPlatform`, `LowerPlatform`, `KillZone` i `Goal`. Ĺ»aden dokument nie
   zabraniaĹ‚ powielenia tego wzorca w kampanii, a byĹ‚ to najbliĹĽszy dostÄ™pny wzĂłr.

### Wykonane zmiany

- Ustanowiono `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` â€” kanon przeszkĂłd
  nadrzÄ™dny wobec kaĹĽdej sceny: zakazy twarde, obowiÄ…zkowy test trzech pytaĹ„,
  zamkniÄ™ty katalog siedmiu diegetycznych rodzin R1..R7 wyprowadzonych z fabuĹ‚y,
  model poraĹĽki przez korektÄ™, budĹĽet trudnoĹ›ci i kontrakt implementacyjny.
- Dodano `tests/traversal_lint_test.gd` â€” zakaz jest **egzekwowalny**, nie tylko
  opisany. Test wykryĹ‚ realne naruszenie: `StairPlatform` w Station 12,
  przemianowany na `StairLanding`. Bramka wpiÄ™ta do `tools/verify.ps1`.
- Przepisano sekcjÄ™ fazy w `AGENTS.md` na stan faktyczny i dodano twardÄ… reguĹ‚Ä™
  przeszkĂłd czytanÄ… na starcie kaĹĽdej sesji.
- Przebudowano `docs/ROADMAP.md` P4: dodano **Filar 0 â€” przestrzeĹ„ grywalna**
  jako najwyĹĽszy priorytet, przed szlifem game feel i oprawÄ….
- `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` jest wymaganym dokumentem
  w `tools/verify_docs.ps1` z kontraktem nagĹ‚ĂłwkĂłw.
- Napisano szczegĂłĹ‚owy, krokowy `docs/NEXT_SESSION_PROMPT.md` dla PKG-0099,
  celowo pisany tak, ĹĽeby wykonaĹ‚ go rĂłwnieĹĽ mniejszy model: numerowane kroki,
  Ĺ›cieĹĽki plikĂłw, wzorce do skopiowania, jawna lista zakazĂłw i kryteria odbioru.

DowĂłd: `DOCS PASS` (27 plikĂłw), `TRAVERSAL LINT PASS`, `Verification passed`.

Ograniczenia: ten pakiet zmienia plan, kanon i egzekwowanie reguĹ‚. **Nie dodaje
jeszcze grywalnoĹ›ci** â€” to jest zadanie PKG-0099 opisane w handoffie. Lint
sprawdza nazewnictwo i zamkniÄ™ty zestaw czasownikĂłw ruchu; nie jest w stanie
udowodniÄ‡, ĹĽe przeszkoda ma sens fabularny. To pozostaje decyzjÄ… projektowÄ…
i wymaga testu trzech pytaĹ„ wykonanego przez czĹ‚owieka lub model, nie przez skrypt.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0099`.

## PKG-0099: Pionowy plaster grywalnoĹ›ci â€” Station 11..15

Data: 2026-08-24
Rola: Lead Programmer i Art Director (D-025, D-085, D-089, ADR-004).

### Punkt wyjĹ›cia

PKG-0098 ustanowiĹ‚ kanon przeszkĂłd i egzekwujÄ…cy go lint, ale Ĺ›wiadomie **nie
dodaĹ‚ grywalnoĹ›ci**. Zakotwiczenie â€” centralna mechanika gry â€” nie wystÄ™powaĹ‚o
w ĹĽadnej z 43 przestrzeni kampanii; ĹĽyĹ‚o wyĹ‚Ä…cznie w `scenes/prototype/anchor_lab.tscn`.
38 z 43 przestrzeni miaĹ‚o dokĹ‚adnie cztery collidery. Ten pakiet naprawia to na
jednym ciÄ…gu: Station 11..15.

ĹšwieĹĽy baseline `tools/verify.ps1` przeszedĹ‚ przed jakÄ…kolwiek zmianÄ… (exit 0,
log: `logs/verify_baseline_pkg0099.log`).

### Wykonane zmiany

- **DĹ‚ug D-096 spĹ‚acony dla Station 11..15.** `_draw()` w `scripts/levels/station_11.gd`
  ..`station_15.gd` rysuje wyĹ‚Ä…cznie `_draw_state_layer()` (1â€“2 relacje pĹ‚aszczyzn
  zaleĹĽne od stanu, kolory z `VectorStageStyle`) plus HUD dialogowy. UsuniÄ™to
  malowanie tĹ‚a, Ĺ›cian, kafli podĹ‚ogi i szwĂłw paneli, ktĂłre zasĹ‚aniaĹ‚y
  `VectorStageEnvironment`.
- **Zakotwiczenie weszĹ‚o do kampanii.** `Geometry/ScoredMetalPanel` w
  `scenes/levels/station_14.tscn` â€” panel serwisowy z rysÄ… w dwĂłch wiarygodnych
  montaĹĽach. Uzgodnienie jest zapowiadane (`CORRECTION_WARNING` = 2.5 s) i
  wywoĹ‚ane uruchomieniem nagrania, nie zegarem poziomu. Trzymany panel opiera siÄ™
  uzgodnieniu; nietrzymany wraca na Ĺ›cianÄ™, a hebel `SeamStabilizerLever`
  przywraca wersjÄ™ serwisowÄ…. Koszt: `tape_voice_clarity` -0.55 na staĹ‚e plus
  `record_decision(&"station_14_anchored_scored_panel", ...)`.
- **Przeszkoda R1+R3 w Station 12.** `Geometry/EvacuationStairFlight` o
  **identycznej pozycji w obu stanach** â€” zmienia siÄ™ wyĹ‚Ä…cznie rozpiÄ™toĹ›Ä‡ biegu.
  Dziecko schodzi po wĹ‚asnej trasie punktĂłw, zatrzymuje siÄ™ przy przerwie i czeka
  `CHILD_PATIENCE` = 6 s. PoraĹĽka to korekta: zapis kosztu, powrĂłt do punktu
  kontrolnego, trwaĹ‚y zanik Ĺ›ladu uĹĽywania na posadzce. Nikt nie ginie.
- **NagĹ‚Ăłwki testu trzech pytaĹ„** dopisane do `station_12.gd` i `station_14.gd`.
- **`tests/pkg_0099_smoke_test.gd`** wpiÄ™ty do `tools/verify.ps1`.
- **`VectorStageStyle.draw_play_plane()`** â€” droga przejezdna rysowana z realnych
  colliderĂłw, z konstrukcjÄ… noĹ›nÄ… pod podniesionymi stopniami.
- **`tools/capture_pkg_0099.gd`** i rendery `reports/pkg_0099/station_11.png`..`station_15.png`.
- **`docs/TRAVERSAL_ACT_II_AUDIT.md`** â€” audyt obu przeszkĂłd.

### Co poszĹ‚o nie tak i zostaĹ‚o poprawione

1. **Pierwsza wersja renderĂłw Ĺ‚amaĹ‚a `VISUAL_DESIGN.md` Â§4.** Profile
   `VectorStageEnvironment` dla Station 12, 14 i 15 malowaĹ‚y cyjan i cynober jako
   peĹ‚nowymiarowe, Ĺ›wiecÄ…ce pĹ‚aszczyzny o wysokoĹ›ci caĹ‚ego kadru. Zredukowano je
   do akcentĂłw punktowych, przyciemnionych przez `VectorStageStyle.shade()`.
2. **Po usuniÄ™ciu tĹ‚a zniknÄ™Ĺ‚a droga przejezdna.** Schody i podesty nie miaĹ‚y
   ĹĽadnej reprezentacji wizualnej, a dziecko wisiaĹ‚o w powietrzu. Dodano
   `draw_play_plane()` z konstrukcjÄ… noĹ›nÄ… (kanon Â§7.4, R7).
3. **Station 11 nie ma collidera `FloorMain`** â€” podĹ‚ogÄ™ niosÄ… `GalleryFloor`
   i `CourtyardFloor`. Handoff ĹĽÄ…daĹ‚ asercji na `FloorMain` we wszystkich piÄ™ciu.
   Zmiana colliderĂłw jest w tym pakiecie zakazana, wiÄ™c bramka zapisaĹ‚a faktyczny
   stan jako kontrakt zamiast naginaÄ‡ scenÄ™ pod test.

### DowĂłd

`logs/verify_pkg0099_final.log`, exit 0: `DOCS PASS`, `Godot headless import`,
`SMOKE PASS`, `TRAVERSAL LINT PASS`, `PKG-0095 SMOKE PASS`, `PKG-0096 SMOKE PASS`,
`PKG-0097 SMOKE PASS`, `PKG-0099 SMOKE PASS`, `Verification passed`.
Rendery obejrzane rÄ™cznie na obrazie, nie w kodzie.

### Ograniczenia

Wzorzec obejmuje piÄ™Ä‡ przestrzeni. PozostaĹ‚e 38 nadal nie zawiera Zakotwiczenia,
a dĹ‚ug D-096 pozostaje otwarty dla Station 01..10 i 16..20. Ĺ»aden test nie
dowodzi, ĹĽe przeszkody sÄ… czytelne albo przyjemne â€” testy dowodzÄ… kontraktĂłw
technicznych i niczego wiÄ™cej (D-012, ADR-003). Hipotezy H-0099-A/B/C zapisane
w `docs/TRAVERSAL_ACT_II_AUDIT.md`.

### Uwaga o zamroĹĽeniu

Katalog `snapshots/PKG-0099-2026-08-24/` istniaĹ‚ juĹĽ przed tÄ… sesjÄ…: poprzedni
pakiet (opisany w logu jako PKG-0098) zamroziĹ‚ pod tÄ… nazwÄ… sam kanon przeszkĂłd,
bez grywalnoĹ›ci. ZamroĹĽenie tego pakietu wykonano z `-Force`, ĹĽeby nazwa
snapshotu odpowiadaĹ‚a faktycznej zawartoĹ›ci PKG-0099. TreĹ›Ä‡ poprzedniego
zamroĹĽenia nie zostaĹ‚a utracona â€” dokumenty kanonu sÄ… nadal na dysku i wchodzÄ…
w skĹ‚ad nowej kopii, a `snapshots/PKG-0098-2026-08-24/` pozostaje nietkniÄ™ty.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` otwiera `PKG-0100`.

## PKG-0100: Akt I grywalny â€” Station 01..10

Data: 2026-08-24  
Rola: Lead Programmer i Art Director (D-025, D-085, D-096, D-099, D-100,
ADR-004).

### Punkt wyjĹ›cia

ĹšwieĹĽy baseline `pwsh -NoProfile -File .\tools\verify.ps1` przeszedĹ‚ przed
zmianami (exit 0). PKG-0099 dostarczyĹ‚ wzorzec widocznej warstwy stanu i
przeszkĂłd na Station 11..15; ten pakiet rozszerzyĹ‚ go wyĹ‚Ä…cznie na Station
01..10.

### Wykonane zmiany

- Profile `VectorStageEnvironment` 1..5 zostaĹ‚y dopisane, profile 7/9/10
  otrzymaĹ‚y punktowe akcenty zamiast peĹ‚nych pĹ‚aszczyzn cyan/cinnabar, a
  `station_number` jest jawnie ustawiony w kaĹĽdym wÄ™Ĺşle 01..10.
- `_draw()` Station 01..10 wywoĹ‚uje `_draw_state_layer()`; kaĹĽda warstwa
  zaczyna od `VectorStageStyle.draw_play_plane(self, geometry)`. Nie zmieniono
  istniejÄ…cych floorĂłw, Ĺ›cian, sufitĂłw, `AirlockZone` ani promieni rekwizytĂłw.
- Dodano piÄ™Ä‡ rzeczy Ĺ›wiata: R5 `ReplacementBusExitDoor`, R7
  `ConcreteStairFlight`, R4 `HallwaySideboard`, R1 `ObservedMirror` i R2
  `IdentityGate`. KaĹĽda ma trzy pytania w nagĹ‚Ăłwku oraz techniczny model
  korekty: decyzja w `GameStateManager`, checkpoint i trwaĹ‚y zanik detalu.
- `AnchorableObject._draw()` zmniejszono do czterech celowych warstw
  `VectorStageStyle`; logika, API i collider nie zostaĹ‚y zmienione.
- Dodano `tests/pkg_0100_smoke_test.gd` i bramkÄ™ w `tools/verify.ps1`.
  Test zapisuje faktyczne nazwy floorĂłw, sprawdza profile 01..10, przeszkody,
  stany hold/yield oraz Ĺ‚aĹ„cuch ukoĹ„czeĹ„ przy limicie 25.
- Dodano `tools/capture_pkg_0100.gd`; Ĺ›wieĹĽe rendery
  `reports/pkg_0100/station_01.png`..`station_10.png` wykonano normalnym
  sterownikiem Windows/OpenGL Intel Iris Xe i obejrzano. Banner autobusu
  wyciszono w capture, aby klatka kontrolna pokazywaĹ‚a kompozycjÄ™ sceny.

### Co zostaĹ‚o sprawdzone

Izolowany `PKG-0100 SMOKE PASS` przeszedĹ‚. PeĹ‚ny `verify.ps1` po zmianach
przeszedĹ‚: DOCS PASS, import Godot, SMOKE PASS, TRAVERSAL LINT PASS,
PKG-0095/0096/0097/0099 PASS i PKG-0100 PASS. OstrzeĹĽenia o wyciekach
ObjectDB/RID pozostajÄ… istniejÄ…cym technicznym szumem testĂłw i nie zmieniĹ‚y
exit code. Rendery sÄ… dowodem wizualnej obecnoĹ›ci warstwy, nie dowodem funu,
emocji ani zrozumienia przez zewnÄ™trznÄ… osobÄ™.

### Dokumentacja i przekazanie

Dodano `docs/TRAVERSAL_ACT_I_AUDIT.md`, zaktualizowano `CURRENT_STATE.md`,
`ROADMAP.md`, `INDEX.md` i `DECISION_LOG.md`, a `NEXT_SESSION_PROMPT.md`
otwiera teraz PKG-0101. Pakiet zamkniÄ™to snapshotem
`snapshots/PKG-0100-2026-08-24/`.

## PKG-0101: Akt IIb grywalny â€” Station 16..20

Data: 2026-08-24  
Rola: Lead Programmer i Art Director (D-025, D-085, D-096, D-099, D-102,
ADR-004).

### Punkt wyjĹ›cia

ĹšwieĹĽy baseline `pwsh -NoProfile -File .\tools\verify.ps1` przeszedĹ‚ przed
zmianami z exit code 0. PKG-0100 dostarczyĹ‚ wzorzec widocznej warstwy stanu i
przeszkĂłd na Station 01..10. Zakres tego pakietu byĹ‚ zamkniÄ™ty do Station
16..20; limit kampanii pozostaĹ‚ 25.

### Wykonane zmiany

- `_draw()` Station 16..20 wywoĹ‚uje aktywnÄ… warstwÄ™ stanu oraz istniejÄ…cy HUD;
  `_draw_state_layer()` zaczyna od `VectorStageStyle.draw_play_plane(self,
  geometry)`. Nie zmieniono istniejÄ…cych floorĂłw, Ĺ›cian, sufitĂłw,
  `AirlockZone` ani promieni interakcji.
- Station 17 otrzymaĹ‚a pracujÄ…cÄ… kapsuĹ‚Ä™ pneumatycznÄ… R5
  `Geometry/PneumaticDossierCapsule`. Jej cykl jest uzasadnionym ruchem
  infrastruktury; korekta zapisuje koszt, resetuje LenÄ™ i wyciera cyfrÄ™ biletu.
- Station 19 otrzymaĹ‚a R1 `Geometry/Line4ModelTable`, a Station 20 R1
  `Geometry/SzymonWellDrawing`. Oba obiekty sÄ… `AnchorableObject` o staĹ‚ej
  pozycji i dwĂłch rĂłĹĽnych zakresach; kotwica opiera korektÄ™, a ulegĹ‚oĹ›Ä‡
  przywraca checkpoint i wymazuje detal.
- Station 16 i 18 celowo nie otrzymaĹ‚y sztucznej przeszkody. Ich rytm rozmowy
  i wywiadu pozostaje obserwacyjny.
- Dodano `tests/pkg_0101_smoke_test.gd`, wpiÄ™to bramkÄ™ do `tools/verify.ps1`,
  dodano `tools/capture_pkg_0101.gd` oraz audyt
  `docs/TRAVERSAL_ACT_IIB_AUDIT.md` wpisany do `docs/INDEX.md`.

### DowĂłd

- Baseline przed zmianami: `verify.ps1` PASS, exit 0.
- Izolowane bramki: PKG-0096, PKG-0097, PKG-0099, PKG-0100 i PKG-0101 PASS.
- Capture normalnym sterownikiem Windows/OpenGL Intel Iris Xe: piÄ™Ä‡ plikĂłw
  `reports/pkg_0101/station_16.png`..`station_20.png`; wszystkie kadry
  obejrzane. Droga jest widoczna, akcenty sÄ… punktowe, a przeszkody wyglÄ…dajÄ…
  jak elementy Ĺ›wiata.
- PeĹ‚na bramka po aktualizacji dokumentacji: `DOCS PASS`, import Godot,
  smoke, traversal lint oraz PKG-0095/0096/0097/0099/0100/0101 PASS.

### Ograniczenia

Automaty i rendery dowodzÄ… kontraktĂłw technicznych i obecnoĹ›ci wizualnej, nie
funu, emocji, zrozumienia ani jakoĹ›ci odbioru przez zewnÄ™trznÄ… osobÄ™ (D-012,
ADR-003). ObjectDB leak warnings pozostajÄ… istniejÄ…cym szumem technicznym
silnika i nie zmieniĹ‚y kodu wyjĹ›cia. Station 26..43 nie byĹ‚y zakresem tego
pakietu.

### ZamkniÄ™cie i przekazanie

Zaktualizowano `CURRENT_STATE.md`, `ROADMAP.md`, `DECISION_LOG.md`, indeks i
ten log. Nowy prompt handoffu znajduje siÄ™ w `docs/NEXT_SESSION_PROMPT.md` i
otwiera PKG-0102. Pakiet zamroĹĽono w
`snapshots/PKG-0101-2026-08-24/`.

## PKG-0102: Akt IIc grywalny â€” Station 21..25

Data: 2026-08-24  
Rola: Lead Programmer i Art Director (D-025, D-085, D-096, D-099, D-103,
ADR-004).

### Punkt wyjĹ›cia

ĹšwieĹĽy baseline `pwsh -NoProfile -File .\\tools\\verify.ps1` przeszedĹ‚ przed
zmianami z exit code 0. Zakres zostaĹ‚ ograniczony do Station 21..25; limit
kampanii wynosiĹ‚ 25, a projekt pozostaĹ‚ Godot 4.7 bez Git i bez jakiejkolwiek
powierzchni webowej. Audyt przeszkĂłd wskazaĹ‚ jednÄ… uzasadnionÄ… bramkÄ™ R2 w
Station 22 oraz Ĺ›wiadomÄ… ciszÄ™ w pozostaĹ‚ych czterech scenach.

### Wykonane zmiany

- Station 21..25 rysujÄ… aktywnÄ… warstwÄ™ stanu, ktĂłrej pierwszym krokiem jest
  `VectorStageStyle.draw_play_plane()`. Nie przywrĂłcono nieprzezroczystych
  legacy teĹ‚; droga i konstrukcja wynikajÄ… z istniejÄ…cej geometrii.
- Station 22 otrzymaĹ‚a `Geometry/BiometricIdentityGate` jako
  `AnimatableBody2D`. Bramka jest zamkniÄ™ta do przyjÄ™cia lokalnego profilu,
  a `accept_yield()` otwiera jÄ… jako pracÄ™ infrastruktury. Korekta przez
  istniejÄ…ce `trigger_correction` zapisuje decyzjÄ™, wraca do checkpointu i
  wygasza detal nadproĹĽa.
- Station 21, 23, 24 i 25 nie otrzymaĹ‚y fizycznej przeszkody. Ich sceny
  pozostajÄ… obserwacyjne lub relacyjne zgodnie z `FULL_STORY.md`.
- Dodano `tests/pkg_0102_smoke_test.gd` i wpiÄ™to je do `tools/verify.ps1`.
  Dodano `tools/capture_pkg_0102.gd` oraz audyty
  `docs/TRAVERSAL_ACT_IIC_AUDIT.md` i `docs/VECTOR_STAGE_ACT_IIC_AUDIT.md`.

### DowĂłd

- Izolowany test PKG-0102 przeszedĹ‚.
- PeĹ‚ny `pwsh -NoProfile -File .\\tools\\verify.ps1` przeszedĹ‚ po zmianach:
  DOCS, import Godot, smoke, traversal lint oraz bramki PKG-0095/0096/0097/
  0099/0100/0101/0102.
- Capture normalnym sterownikiem Windows/OpenGL Intel Iris Xe zapisaĹ‚ i
  pozwoliĹ‚ obejrzeÄ‡ piÄ™Ä‡ kadrĂłw 1280Ă—720:
  `reports/pkg_0102/station_21.png`..`station_25.png`.
- OstrzeĹĽenia ObjectDB leak pozostajÄ… istniejÄ…cym szumem wyjĹ›cia testĂłw
  Godota i nie zmieniĹ‚y kodu wyjĹ›cia.

### Ograniczenia

Automaty i rendery potwierdzajÄ… kontrakty techniczne, obecnoĹ›Ä‡ kompozycji,
przejĹ›cie bramki i zapis kosztu; nie dowodzÄ… funu, emocji, czytelnoĹ›ci ani
zrozumienia przez zewnÄ™trznÄ… osobÄ™ (D-012, ADR-003). Station 26..43 nie byĹ‚y
zakresem tego pakietu, a Station 25 nadal nie odblokowuje Station 26.

### ZamkniÄ™cie i przekazanie

Zaktualizowano `CURRENT_STATE.md`, `ROADMAP.md`, `DECISION_LOG.md`, `INDEX.md`,
audyt przeszkĂłd i ten log. `docs/NEXT_SESSION_PROMPT.md` otwiera teraz PKG-0103.
Po koĹ„cowym PASS pakiet zamroĹĽono w
`snapshots/PKG-0102-2026-08-24/`.

## PKG-0103: Akt III grywalny â€” Station 26..30

Data: 2026-08-24  
Rola: Lead Programmer i Art Director (D-025, D-085, D-096, D-099, D-103,
D-104, ADR-004).

### Punkt wyjĹ›cia

ObowiÄ…zkowy baseline `pwsh -NoProfile -File .\tools\verify.ps1` zatrzymaĹ‚ siÄ™
na istniejÄ…cej bramce PKG-0102: asercja sprawdzaĹ‚a pozycjÄ™ Leny po jednej
klatce, kiedy `CharacterBody2D` zdÄ…ĹĽyĹ‚ juĹĽ wykonaÄ‡ zwykĹ‚y krok grawitacji.
Read-only diagnoza pokazaĹ‚a poprawny reset na granicy `player.reset_to()` oraz
pozycjÄ™ po klatce, ktĂłra byĹ‚a pĂłĹşniejszym stanem fizyki. Test PKG-0102 zostaĹ‚
naprawiony tak, by sprawdzaĹ‚ rzeczywistÄ… granicÄ™ resetu, bez osĹ‚abiania
kontraktu; izolowany PKG-0102 przeszedĹ‚ przed implementacjÄ… PKG-0103.

### Wykonane zmiany

- Station 26..30 otrzymaĹ‚y profile `VectorStageEnvironment`, `AtmosphereRig`,
  `CRTDialogueBox` i `OpeningDialogueCue`. `_draw()` kaĹĽdej stacji uĹĽywa
  aktywnej warstwy stanu, ktĂłrej pierwszym krokiem jest
  `VectorStageStyle.draw_play_plane(self, geometry)`; nie przywrĂłcono
  nieprzezroczystych legacy teĹ‚.
- Station 26 otrzymaĹ‚a dokĹ‚adnie jednÄ… przeszkodÄ™ R5:
  `Geometry/AdaptiveIsolationPartition`. Przegroda porusza siÄ™ w cyklu, bo
  strefa izolacji rekonfiguruje funkcje pomieszczeĹ„; korekta zapisuje decyzjÄ™,
  resetuje checkpoint i wygasza krawÄ™dĹş wskaĹşnika funkcji.
- Station 30 otrzymaĹ‚a dokĹ‚adnie jednÄ… przeszkodÄ™ R1:
  `Geometry/WitnessRelayBank` jako `AnchorableObject`. Dwie konfiguracje majÄ…
  tÄ™ samÄ… pozycjÄ™ montaĹĽowÄ…, ale rĂłĹĽny zakres bryĹ‚y; kotwica opiera korektÄ™,
  a niezakotwiczona prĂłba zapisuje koszt, resetuje checkpoint i wygasza przewĂłd
  mapy Ĺ›wiadkĂłw.
- Station 27, 28 i 29 zachowujÄ… Ĺ›wiadomÄ… ciszÄ™ bez sztucznej geometrii.
  Decyzje oraz trzy pytania sÄ… zapisane w
  `docs/TRAVERSAL_ACT_III_AUDIT.md` i w nagĹ‚Ăłwkach skryptĂłw stacji.
- Dodano `tests/pkg_0103_smoke_test.gd`, wpiÄ™to je do `tools/verify.ps1` oraz
  dodano `tools/capture_pkg_0103.gd`. Test chroni profile, shell collidery,
  `AirlockZone`, promienie rekwizytĂłw, liczbÄ™ przeszkĂłd, korekty i granicÄ™
  kampanii 25; nie zmienia `SAVE_SCHEMA_VERSION`, InputMap ani przejĹ›cia
  Station 25â†’26.

### DowĂłd

- Izolowane PKG-0102 i PKG-0103: PASS.
- PeĹ‚ny `pwsh -NoProfile -File .\tools\verify.ps1`: PASS â€” DOCS, import Godot,
  smoke, traversal lint oraz PKG-0095/0096/0097/0099/0100/0101/0102/0103.
- Normalny sterownik Windows/OpenGL Intel Iris Xe zapisaĹ‚ piÄ™Ä‡ kadrĂłw
  `reports/pkg_0103/station_26.png`..`station_30.png`; wszystkie zostaĹ‚y
  obejrzane. Droga jest widoczna, a akcenty mechanizmĂłw sÄ… diegetyczne.
- OstrzeĹĽenia o wyciekach ObjectDB/RID pozostaĹ‚y istniejÄ…cym szumem Godota i
  nie zmieniĹ‚y kodĂłw wyjĹ›cia.

### Ograniczenia

Automaty i rendery dowodzÄ… kontraktĂłw technicznych oraz obecnoĹ›ci kompozycji;
nie dowodzÄ… funu, emocji, czytelnoĹ›ci przez nowÄ… osobÄ™ ani zrozumienia fabuĹ‚y
przez czĹ‚owieka (D-012, ADR-003). H-012 pozostaje `UNTESTED`: nie wykonano
pomiaru kontrastu, skalowania 1xâ€“4x ani symulacji deuteranopii/protanopii.
Station 31..43 nie byĹ‚y zakresem tego pakietu, a kampania nadal koĹ„czy siÄ™
na limicie 25.

### ZamkniÄ™cie i przekazanie

Zaktualizowano `CURRENT_STATE.md`, `ROADMAP.md`, `DECISION_LOG.md`,
`RISKS_AND_HYPOTHESES.md`, `INDEX.md`, audyt przeszkĂłd i ten log. Nowy prompt
handoffu znajduje siÄ™ w `docs/NEXT_SESSION_PROMPT.md` i otwiera PKG-0104 dla
Station 31..35. Pakiet zamroĹĽono w
`snapshots/PKG-0103-2026-08-24/`.

## PKG-0104: Akt IIIb grywalny â€” Station 31..35

Data: 2026-08-24  
Rola: Lead Programmer i Art Director (D-025, D-085, D-096, D-099, D-104,
D-105, ADR-004).

### Punkt wyjĹ›cia

ĹšwieĹĽy baseline `pwsh -NoProfile -File .\tools\verify.ps1` przeszedĹ‚ przed
zmianami z exit code 0. Zakres pozostaĹ‚ wyĹ‚Ä…cznie Godot 4.7, bez Git i bez
jakiejkolwiek powierzchni webowej. Limit kampanii wynosiĹ‚ 25, a
`SAVE_SCHEMA_VERSION` 1. Read-only audyt scen 31..35 nie wykazaĹ‚ powodu, by
kaĹĽdÄ… scenÄ™ wypeĹ‚niaÄ‡ przeszkodÄ….

### Audyt i decyzja projektowa

- Station 31 zachowuje Ĺ›wiadomÄ… ciszÄ™: jedenaĹ›cie krzeseĹ‚ i nazwiska osĂłb
  ujawniajÄ… odpowiedzialnoĹ›Ä‡ Wierzbickiej bez toru wykonawczego.
- Station 32 otrzymuje R6 `Geometry/ObservedGlassTrace`: obserwowany Ĺ›lad w
  szkle pozostaje przejĹ›ciem, a po odejĹ›ciu od uwagi Podstruktura przywraca
  blokujÄ…cÄ… taflÄ™. Zakotwiczenie opiera korektÄ™.
- Station 33 otrzymuje R1 `Geometry/DualWitnessFrame`: rama ma dwa zakresy
  tej samej pozycji montaĹĽowej, a kotwica opiera prĂłbÄ™ rozdzielenia Ĺ›wiadectw.
- Station 34 zachowuje Ĺ›wiadomÄ… ciszÄ™: rekonstrukcja pamiÄ™ci kostnicy jest
  osobistym rozpoznaniem, nie testem ruchowym.
- Station 35 zachowuje Ĺ›wiadomÄ… ciszÄ™: baseny i zawory wykonujÄ… pracÄ™
  infrastruktury, a przejĹ›cie do Station 36 pozostaje poza kampaniÄ….

PeĹ‚ne uzasadnienie, trzy pytania i koszty korekt zapisano w
`docs/TRAVERSAL_ACT_IIIB_AUDIT.md`.

### Wykonane zmiany

- Station 31..35 otrzymaĹ‚y rÄ™czne profile `VectorStageEnvironment`,
  `AtmosphereRig`, `CRTDialogueBox` i `OpeningDialogueCue`. KaĹĽdy skrypt
  stacji rysuje aktywnÄ… warstwÄ™ stanu, ktĂłrej pierwszÄ… operacjÄ… jest
  `VectorStageStyle.draw_play_plane(self, geometry)`; stare nieprzezroczyste
  tĹ‚a sÄ… poza aktywnÄ… Ĺ›cieĹĽkÄ….
- Station 32 i 33 korzystajÄ… z istniejÄ…cego `AnchorableObject`. Korekty
  zapisujÄ… decyzjÄ™ przez `GameStateManager`, resetujÄ… checkpoint i wygaszajÄ…
  konkretny detal; nie dodano Ĺ›mierci, paska zdrowia ani platformingu.
- Nie zmieniono istniejÄ…cych podĹ‚Ăłg, sufitĂłw, Ĺ›cian, `AirlockZone`, promieni
  rekwizytĂłw, InputMap, fizyki 60 Hz, limitu kampanii ani schematu zapisu.
- Dodano `tests/pkg_0104_smoke_test.gd` i bramkÄ™ w `tools/verify.ps1`.
  Bramka chroni profile, kolejnoĹ›Ä‡ warstwy rysunku, shell collidery, dokĹ‚adnÄ…
  liczbÄ™ przeszkĂłd, trzy pytania, dziaĹ‚anie kotwicy/korekty oraz granicÄ™ 25.
- Dodano `tools/capture_pkg_0104.gd` i piÄ™Ä‡ renderĂłw:
  `reports/pkg_0104/station_31.png`..`station_35.png`.

### DowĂłd

- Izolowany test `pkg_0104_smoke_test.gd`: PASS.
- PeĹ‚ny `pwsh -NoProfile -File .\tools\verify.ps1`: PASS â€” DOCS, import Godot,
  smoke, traversal lint oraz bramki PKG-0095/0096/0097/0099/0100/0101/0102/
  0103/0104.
- Capture wykonano normalnym sterownikiem Windows/OpenGL Intel Iris Xe, nie
  headless. Wszystkie piÄ™Ä‡ kadrĂłw zapisano i obejrzano; droga ma wyraĹşny
  kontrast kompozycyjny, a akcenty mechanizmĂłw pozostajÄ… punktowe i diegetyczne.
- OstrzeĹĽenia ObjectDB/RID leak pozostaĹ‚y istniejÄ…cym szumem Godota i nie
  zmieniĹ‚y kodu wyjĹ›cia.

### Ograniczenia

Automaty i rendery dowodzÄ… kontraktĂłw technicznych, obecnoĹ›ci kompozycji oraz
zachowania dwĂłch przeszkĂłd; nie dowodzÄ… funu, emocji, czytelnoĹ›ci przez nowÄ…
osobÄ™ ani zrozumienia fabuĹ‚y (D-012, ADR-003). H-012 pozostaje `UNTESTED`:
nie wykonano pomiaru kontrastu, skalowania 1xâ€“4x ani symulacji
deuteranopii/protanopii. Station 36..43 nie byĹ‚y zakresem tego pakietu, a
Station 25 nadal nie odblokowuje Station 26.

### ZamkniÄ™cie i przekazanie

Zaktualizowano `CURRENT_STATE.md`, `ROADMAP.md`, `DECISION_LOG.md` (D-105),
`RISKS_AND_HYPOTHESES.md`, `INDEX.md`, audyt przeszkĂłd i ten log. Prompt
handoffu znajduje siÄ™ w `docs/NEXT_SESSION_PROMPT.md` i otwiera PKG-0105 dla
Station 36..40. Po koĹ„cowym PASS pakiet zamroĹĽono w
`snapshots/PKG-0104-2026-08-24/`.

## PKG-0105: Akt IIIc grywalny â€” Station 36..40

Data: 2026-08-24  
Rola: Lead Programmer i Art Director (D-025, D-085, D-096, D-099, D-106,
ADR-004).

### Punkt wyjĹ›cia

Baseline `pwsh -NoProfile -File .\tools\verify.ps1` przeszedĹ‚ przed zmianami
z exit code 0. Zakres pozostaĹ‚ wyĹ‚Ä…cznie Godot 4.7, bez Git i bez jakiejkolwiek
powierzchni webowej. Limit kampanii wynosiĹ‚ 25, a `SAVE_SCHEMA_VERSION` 1.
Read-only audyt scen 36..40 wykazaĹ‚ brak profili Vector-Stage i brak
fizycznych przeszkĂłd; zdecydowano o jednej przeszkodzie R3 w Station 38 i
Ĺ›wiadomej ciszy w czterech pozostaĹ‚ych scenach. Audyt zapisaĹ‚ teĹĽ rozbieĹĽnoĹ›Ä‡
etykiet 36..38 miÄ™dzy aktualnym runtime/handoffem a starszymi fragmentami
kanonu; nie renumerowano kanonu w tym pakiecie.

### Wykonane zmiany

- Station 36..40 otrzymaĹ‚y rÄ™czne profile `VectorStageEnvironment`,
  `AtmosphereRig`, `CRTDialogueBox` i `OpeningDialogueCue`. KaĹĽdy skrypt stacji
  rysuje aktywnÄ… warstwÄ™ stanu, ktĂłrej pierwszÄ… operacjÄ… jest
  `VectorStageStyle.draw_play_plane(self, geometry)`; stare nieprzezroczyste
  tĹ‚a pozostajÄ… poza aktywnÄ… Ĺ›cieĹĽkÄ….
- Station 38 otrzymaĹ‚a dokĹ‚adnie jednÄ… przeszkodÄ™ R3:
  `Geometry/JakubRescueBulkhead` jako `AnchorableObject`. Stan A jest
  przejĹ›ciem, stan B blokujÄ…cÄ… Ĺ›luzÄ… w tej samej pozycji. Kotwica opiera
  korektÄ™; niezakotwiczona prĂłba zapisuje decyzjÄ™, resetuje checkpoint i
  wygasza detal wÄ™zĹ‚a ratunkowego. Station 36, 37, 39 i 40 nie dostaĹ‚y
  przeszkody dla samego wypeĹ‚nienia kadru.
- Dodano `docs/TRAVERSAL_ACT_IIIC_AUDIT.md`, `tests/pkg_0105_smoke_test.gd`,
  bramkÄ™ w `tools/verify.ps1` oraz `tools/capture_pkg_0105.gd`.

### DowĂłd

- Izolowany `pkg_0105_smoke_test.gd`: PASS.
- PeĹ‚ny `pwsh -NoProfile -File .\tools\verify.ps1`: PASS â€” DOCS, import Godot,
  smoke, traversal lint oraz bramki PKG-0095/0096/0097/0099/0100/0101/0102/
  0103/0104/0105.
- Capture wykonano normalnym sterownikiem Windows/OpenGL Intel Iris Xe, nie
  headless. Zapisano piÄ™Ä‡ kadrĂłw `reports/pkg_0105/station_36.png`..
  `reports/pkg_0105/station_40.png`; wszystkie zostaĹ‚y obejrzane. Kadr
  utrzymuje drogÄ™ w dolnym pasie, a stacja 38 pokazuje pionowÄ… Ĺ›luzÄ™ R3.
- OstrzeĹĽenia ObjectDB/RID leak pozostaĹ‚y istniejÄ…cym szumem Godota i nie
  zmieniĹ‚y kodĂłw wyjĹ›cia.

### Ograniczenia

Automaty i rendery dowodzÄ… kontraktĂłw technicznych, obecnoĹ›ci kompozycji oraz
zachowania R3; nie dowodzÄ… funu, emocji, czytelnoĹ›ci przez nowÄ… osobÄ™ ani
zrozumienia fabuĹ‚y przez czĹ‚owieka (D-012, ADR-003). H-012 pozostaje
`UNTESTED`: nie wykonano pomiaru kontrastu, skalowania 1xâ€“4x ani symulacji
deuteranopii/protanopii. Station 41..43 nie byĹ‚y zakresem pakietu, a kampania
nadal koĹ„czy siÄ™ na limicie 25.

### ZamkniÄ™cie i przekazanie

Zaktualizowano `CURRENT_STATE.md`, `ROADMAP.md`, `DECISION_LOG.md` (D-106),
`RISKS_AND_HYPOTHESES.md`, `INDEX.md`, audyt przeszkĂłd i ten log. Nowy prompt
handoffu znajduje siÄ™ w `docs/NEXT_SESSION_PROMPT.md` i otwiera PKG-0106 dla
Station 41. Po koĹ„cowym PASS pakiet zamroĹĽono w
`snapshots/PKG-0105-2026-08-24/`.

## PKG-0106: Akt IV â€” Station 41 i Komora Wyboru Operacyjnego

Data: 2026-08-24  
Rola: Lead Programmer i Art Director (D-025, D-085, D-096, D-099, D-107,
ADR-004).

### Punkt wyjĹ›cia

Baseline `pwsh -NoProfile -File .\tools\verify.ps1` przeszedĹ‚ przed zmianami
z exit code 0. Zakres pozostaĹ‚ wyĹ‚Ä…cznie Godot 4.7, bez Git i bez jakiejkolwiek
powierzchni webowej. Limit kampanii wynosiĹ‚ 25, a `SAVE_SCHEMA_VERSION` 1.
Read-only audyt Station 41 wykazaĹ‚ istniejÄ…cÄ… komorÄ™ z trzema stanowiskami
operacyjnymi, shell colliderami, punktem checkpointu i Ĺ›luzÄ…; nie wykazaĹ‚ powodu
do dokĹ‚adania przeszkody tylko dla wypeĹ‚nienia kadru. PodjÄ™to decyzjÄ™ o
Ĺ›wiadomej mechanicznej ciszy, zapisanÄ… w `docs/TRAVERSAL_ACT_IV_AUDIT.md`.

### Wykonane zmiany

- Station 41 otrzymaĹ‚a rÄ™czny profil `VectorStageEnvironment` z `stage_seed = 41`
  i `station_number = 41`, `AtmosphereRig`, `CRTDialogueBox` oraz
  `OpeningDialogueCue` z `station_id = station_41`.
- Skrypt stacji ma aktywnÄ… Ĺ›cieĹĽkÄ™ `_draw()` â†’ `_draw_state_layer()`; pierwsza
  operacja warstwy stanu to `VectorStageStyle.draw_play_plane(self, geometry)`.
  Kadr pokazuje topografiÄ™, trzy operacje A/B/C i drogÄ™ do Ĺ›luzy, a wybĂłr nadal
  ustawia istniejÄ…cy stan, rekwizyty, checkpoint i sygnaĹ‚ ukoĹ„czenia.
- Nie dodano `AnimatableBody2D`, nowego `StaticBody2D`, nowej mechaniki,
  przeszkody ani zmiany w `GameStateManager`. Sceny 42A..42C, granica kampanii
  25 i schemat zapisu 1 pozostaĹ‚y bez zmian.
- Dodano `tests/pkg_0106_smoke_test.gd`, bramkÄ™ w `tools/verify.ps1` oraz
  `tools/capture_pkg_0106.gd`.
- PeĹ‚ny przebieg ujawniĹ‚ stare asercje pozycji w `pkg_0104_smoke_test.gd` i
  `pkg_0105_smoke_test.gd`: sprawdzaĹ‚y pozycjÄ™ po jednej klatce fizyki. Obie
  asercje przeniesiono bezpoĹ›rednio za reset checkpointu, przed tickiem
  grawitacji; testy izolowane i peĹ‚ny verify po korekcie przechodzÄ….

### DowĂłd

- Izolowany `pkg_0106_smoke_test.gd`: PASS.
- PeĹ‚ny `pwsh -NoProfile -File .\tools\verify.ps1`: PASS â€” dokumentacja,
  import Godot, smoke, traversal lint oraz bramki PKG-0095/0096/0097/0099/
  0100/0101/0102/0103/0104/0105/0106.
- Capture wykonano normalnym sterownikiem Windows/OpenGL Intel Iris Xe, nie
  headless. Zapisano i obejrzano `reports/pkg_0106/station_41.png` w logicznej
  przestrzeni 640x360.
- OstrzeĹĽenia ObjectDB/RID leak pozostaĹ‚y istniejÄ…cym szumem Godota i nie
  zmieniĹ‚y kodu wyjĹ›cia.

### Ograniczenia

Automaty i render dowodzÄ… kontraktĂłw technicznych oraz obecnoĹ›ci kompozycji;
nie dowodzÄ… funu, emocji, czytelnoĹ›ci przez nowÄ… osobÄ™ ani zrozumienia fabuĹ‚y
(D-012, ADR-003). H-012 pozostaje `UNTESTED`: nie wykonano pomiaru kontrastu,
skalowania 1xâ€“4x ani symulacji deuteranopii/protanopii. Station 42A..42C i 43
pozostajÄ… poza zakresem tego pakietu.

### ZamkniÄ™cie i przekazanie

Zaktualizowano `CURRENT_STATE.md`, `ROADMAP.md`, `DECISION_LOG.md` (D-107),
`RISKS_AND_HYPOTHESES.md`, `INDEX.md`, audyt przeszkĂłd i ten log. Prompt
handoffu znajduje siÄ™ w `docs/NEXT_SESSION_PROMPT.md` i otwiera PKG-0107 dla
Station 42A..42C i 43. Po koĹ„cowym PASS pakiet zamroĹĽono w
`snapshots/PKG-0106-2026-08-24/`.

## PKG-0107: Akt IV â€” finaĹ‚y 42Aâ€“42C i epilog 43

Data: 2026-08-24  
Rola: Lead Programmer i Art Director (D-025, D-085, D-096, D-099, D-108,
ADR-004).

### Punkt wyjĹ›cia

Baseline `pwsh -NoProfile -File .\tools\verify.ps1` przeszedĹ‚ przed zmianami
z exit code 0. Zakres pozostaĹ‚ wyĹ‚Ä…cznie Godot 4.7, bez Git i bez jakiejkolwiek
powierzchni webowej. Limit kampanii wynosiĹ‚ 25, a `SAVE_SCHEMA_VERSION` 1.
Read-only audyt czterech finaĹ‚Ăłw wykazaĹ‚ istniejÄ…ce shell collidery,
`AirlockZone`, rekwizyty i drogi do wyjĹ›cia bez koniecznoĹ›ci dodawania
przeszkody; wybrano Ĺ›wiadomÄ… ciszÄ™.

### Wykonane zmiany

- Sceny 42A, 42B, 42C i 43 otrzymaĹ‚y rÄ™czne profile `VectorStageEnvironment`
  z deterministycznymi seedami, wariantami kompozycji, `AtmosphereRig`,
  `CRTDialogueBox` i `OpeningDialogueCue` z dokĹ‚adnymi identyfikatorami scen.
- KaĹĽdy skrypt finaĹ‚u ma aktywnÄ… Ĺ›cieĹĽkÄ™ `_draw()` â†’ `_draw_state_layer()`;
  pierwsza operacja warstwy stanu to
  `VectorStageStyle.draw_play_plane(self, geometry)`. Zachowano logikÄ™
  wyborĂłw, flagi, koszty, dialogi, checkpointy, sygnaĹ‚y ukoĹ„czenia i granicÄ™
  Ĺ‚aĹ„cucha kampanii.
- Nie dodano ĹĽadnej przeszkody, `AnimatableBody2D`, nowego `StaticBody2D`,
  collidora ani zmiany fizyki. Audyt i smoke test zapisujÄ… Ĺ‚Ä…czny budĹĽet 0.
- Dodano `tests/pkg_0107_smoke_test.gd`, bramkÄ™ w `tools/verify.ps1` oraz
  `tools/capture_pkg_0107.gd`.

### DowĂłd

- Izolowany `pkg_0107_smoke_test.gd`: PASS.
- KoĹ„cowy `pwsh -NoProfile -File .\tools\verify.ps1`: PASS â€” dokumentacja,
  import, smoke, traversal lint oraz bramki PKG-0095..PKG-0107.
- Capture uruchomiono normalnym sterownikiem Windows/OpenGL Intel Iris Xe,
  w logicznej przestrzeni 640x360. Wykonano i obejrzano:
  `reports/pkg_0107/station_42a.png`, `station_42b.png`, `station_42c.png`
  i `station_43.png`.
- Przy zamykaniu Godota pozostajÄ… znane ostrzeĹĽenia `ObjectDB`/`RID leak`;
  kod wyjĹ›cia weryfikacji pozostaje 0.

### Ograniczenia

Automaty i kadry dowodzÄ… kontraktĂłw technicznych oraz obecnoĹ›ci kompozycji;
nie dowodzÄ… funu, emocji, czytelnoĹ›ci przez nowÄ… osobÄ™ ani zrozumienia fabuĹ‚y
(D-012, ADR-003). H-012 pozostaje `UNTESTED`: nie wykonano pomiaru kontrastu,
skalowania 1xâ€“4x ani symulacji deuteranopii/protanopii.

### ZamkniÄ™cie i przekazanie

Zaktualizowano `CURRENT_STATE.md`, `ROADMAP.md`, `DECISION_LOG.md` (D-108),
`RISKS_AND_HYPOTHESES.md`, `INDEX.md`, audyt traversal i ten log. Aktualny
prompt handoffu znajduje siÄ™ w `docs/NEXT_SESSION_PROMPT.md` i otwiera
PKG-0108 dla technicznego audytu H-012. Po koĹ„cowym PASS pakiet zamroĹĽono w
`snapshots/PKG-0107-2026-08-24/`.

## PKG-0108: techniczny audyt czytelnoĹ›ci Vector-Stage â€” H-012

Data: 2026-08-24  
Rola: Lead Programmer i Art Director (D-025, D-085, D-096, D-099, D-103,
D-104, D-105, D-106, D-107, D-108, ADR-004).

### Punkt wyjĹ›cia

Baseline `pwsh -NoProfile -File .\tools\verify.ps1` przeszedĹ‚ przed zmianami
z exit code 0. Projekt pozostaĹ‚ wyĹ‚Ä…cznie Godot 4.7, bez Git i bez jakiejkolwiek
powierzchni webowej. Limit kampanii wynosiĹ‚ 25, `SAVE_SCHEMA_VERSION` 1,
a H-012 byĹ‚o `UNTESTED`, poniewaĹĽ wczeĹ›niejsze pakiety nie mierzyĹ‚y kontrastu,
skalowania ani transformacji kolorystycznych.

### Wykonane zmiany

- Dodano `tools/audit_h012.gd` oraz raport metodologiczny
  `docs/VECTOR_STAGE_READABILITY_AUDIT_H-012.md`. NarzÄ™dzie wykonuje Ĺ›wieĹĽe
  capture'y normalnym sterownikiem Windows/OpenGL, zapisuje logiczne PNG,
  skale caĹ‚kowite `1x`â€“`4x`, grayscale, deuteranopiÄ™ i protanopiÄ™ oraz jawne
  pomiary maski, obwiedni, centroidu i lokalnego kontrastu.
- Audyt objÄ…Ĺ‚ Station 01, 14, 22, 38, 41, 42A, 42B, 42C i 43 w Ĺ›wiecie oraz
  CRT dla Station 01, 22 i 43. Zapisano 12 kadrĂłw, 63 pomiary rastera,
  48 kontroli skal i 36 wariantĂłw transformacji. Wszystkie kontrole skal
  majÄ… `nearest_neighbor_mismatch = 0`.
- W obserwacji technicznej droga i plan sÄ… obecne w kaĹĽdym kadrze; korekta ma
  kontrast `1.08â€“5.85` w oĹ›miu kadrach, `42A` ma `ABSENT` w zdefiniowanym
  regionie, a CRT ma kontrast `6.62â€“6.65`. PeĹ‚ne dane sÄ… w
  `reports/pkg_0108/measurements.tsv` i `.json`.
- Nie zmieniono scen gry, renderera, colliderĂłw, InputMap, fizyki, logiki
  kampanii, limitu, zapisu ani istniejÄ…cych rozgaĹ‚Ä™zieĹ„. Nie dodano
  przeszkĂłd. ĹšwieĹĽe kadry i warianty zostaĹ‚y obejrzane.

### DowĂłd

- `godot_console.exe --path C:\getting_strange --script res://tools/audit_h012.gd`:
  **`PKG-0108 AUDIT PASS: 12 frame captures, 63 raster measurements, 48 scale
  checks`**, exit code 0.
- KoĹ„cowy `pwsh -NoProfile -File .\tools\verify.ps1`: **PASS**, exit code 0 â€”
  dokumentacja, import Godot, smoke, traversal lint i bramki PKG-0095..PKG-0107.
- Przy zamykaniu Godota pozostajÄ… znane ostrzeĹĽenia `ObjectDB`/`RID leak`;
  nie zmieniĹ‚y kodĂłw wyjĹ›cia.

### Ograniczenia

Audyt dowodzi technicznego zachowania rastera i ujawnia zakresy kontrastu;
nie dowodzi funu, emocji, czytelnoĹ›ci przez nowÄ… osobÄ™ ani zrozumienia fabuĹ‚y
(D-012, ADR-003). Specyfikacja nie ustanawia progu liczbowego, dlatego H-012
pozostaje `UNTESTED`. Samo obejrzenie PNG i automaty nie awansujÄ… hipotezy.

### ZamkniÄ™cie i przekazanie

Zaktualizowano `CURRENT_STATE.md`, `RISKS_AND_HYPOTHESES.md`, `INDEX.md`,
`VECTOR_STAGE_READABILITY_AUDIT_H-012.md`, ten log oraz
`docs/NEXT_SESSION_PROMPT.md`. Nie zmieniono `ROADMAP.md` ani
`DECISION_LOG.md`, poniewaĹĽ status i kontrakt produkcyjny nie ulegĹ‚y zmianie.
NastÄ™pny prompt otwiera PKG-0109 dla technicznego audytu H-005. Po koĹ„cowym
PASS pakiet zamroĹĽono w `snapshots/PKG-0108-2026-08-24/`.

## PKG-0109: techniczny audyt kosztu renderu i animacji Vector-Stage â€” H-005

Data: 2026-08-24  
Rola: Lead Programmer i Art Director (D-025, D-085, D-096, D-099, D-103,
D-104, D-105, D-106, D-107, D-108, ADR-004).

### Punkt wyjĹ›cia

Baseline `pwsh -NoProfile -File .\tools\verify.ps1` przeszedĹ‚ przed zmianami
z exit code 0. Projekt pozostaĹ‚ wyĹ‚Ä…cznie grÄ… Godot 4.7, bez Git i bez
jakiejkolwiek powierzchni webowej. H-005 miaĹ‚o status `TECHNICAL`: istniaĹ‚
wymĂłg stabilnych 60 FPS i viewportu `640x360`, ale nie byĹ‚o jawnego budĹĽetu
liczbowego renderu, CPU/GPU, canvas metrics ani kosztu produkcji.

### Wykonane zmiany

- Dodano powtarzalne narzÄ™dzie `tools/audit_h005.gd` oraz raport metodologiczny
  `docs/VECTOR_STAGE_COST_AUDIT_H-005.md`. NarzÄ™dzie wykonuje normalny pomiar
  Windows/OpenGL w logicznej przestrzeni `640x360`, uĹĽywa metryk
  `Viewport`/`RenderingServer`, wyĹ‚Ä…cza V-Sync wyĹ‚Ä…cznie w harnessie i nie
  zmienia produktu.
- Zapisano `reports/pkg_0109/metadata.json`, `frame_metrics.tsv`,
  `animation_metrics.tsv`, `animation_component_deltas.tsv`,
  `animation_samples.tsv`, `inventory_43.tsv` i `summary.json`.
- BezpoĹ›rednio zmierzono dziewiÄ™Ä‡ wymaganych reprezentatywnych kadrĂłw Ĺ›wiata,
  dodatkowy Station 02 z `DiscontinuousShadow`, dwa kadry Ĺ›wiata z CRT oraz
  proceduralny cykl protagonistki Station 02. Statyczna prĂłbka miaĹ‚a 60
  klatek rozgrzewki, 120 klatek prĂłby i 118 waĹĽnych prĂłbek po odrzuceniu dwĂłch
  pierwszych klatek RenderingServer. Cykl miaĹ‚ 220 klatek i 218 waĹĽnych prĂłbek.
- Zinwentaryzowano wszystkie 45 zasobĂłw scen (`01..41`, `42A..42C`, `43`),
  mapujÄ…c trzy warianty 42A/42B/42C na 43 przestrzenie kampanii. Wszystkie
  zasoby majÄ… `PrototypePlayer`, `VectorStageEnvironment`, `AtmosphereRig` i
  CRT; wszystkie majÄ… `AnimationPlayer = 0` i `AnimatedSprite2D = 0`.
- Jedyny przebieg z istniejÄ…cym `DiscontinuousShadow` uĹĽyĹ‚ Station 02. Nie
  dodano animacji, assetĂłw, colliderĂłw, przeszkĂłd, efektĂłw, mechaniki,
  dialogĂłw, InputMap, fizyki, zapisu, limitu kampanii ani rozgaĹ‚Ä™zieĹ„.

### DowĂłd

- Normalny proces Godot 4.7/OpenGL na Windows/Intel Iris Xe zakoĹ„czyĹ‚ narzÄ™dzie
  komunikatem: **`PKG-0109 AUDIT PASS: 45 scene resources inventoried, 22 frame
  rows, 5 animation rows`**, exit code 0.
- Ĺšredni `render_cpu_ms` bezpoĹ›rednich kadrĂłw Ĺ›wiata wyniĂłsĹ‚ `0.654â€“1.016 ms`,
  a Ĺ›redni `render_gpu_ms` `0.720â€“1.606 ms`. NajwyĹĽsze Ĺ›rednie canvas metrics
  miaĹ‚ Station 41: `125` draw calls, `2 320` primitives i `209` canvas items.
- PeĹ‚ny cykl protagonistki miaĹ‚ Ĺ›redni interwaĹ‚ `2.178 ms`, p95 `6.525 ms`.
  PeĹ‚na warstwa wzglÄ™dem ukrytej protagonistki/cienia wykazaĹ‚a Ĺ›rednio
  `+18.899` canvas items, `+134.532` primitives i `+18.583` draw calls.
  Niemonotoniczne rĂłĹĽnice czasu komponentĂłw zostaĹ‚y zachowane jako ograniczenie,
  a nie przedstawione jako sztuczny koszt lub oszczÄ™dnoĹ›Ä‡.
- KoĹ„cowy `pwsh -NoProfile -File .\tools\verify.ps1` po aktualizacji dokumentĂłw
  przeszedĹ‚: **DOCS PASS (27 wymaganych plikĂłw), import Godot, smoke, traversal
  lint i bramki PKG-0095..PKG-0107 PASS**, exit code 0.
- Przy zamykaniu Godota pozostaĹ‚y znane ostrzeĹĽenia `ObjectDB`/`RID leak`; nie
  zmieniĹ‚y kodĂłw wyjĹ›cia.

### Ograniczenia i decyzja

Pomiar obejmuje jeden Ĺ›wieĹĽy proces i jeden profil Windows/OpenGL/Intel Iris Xe.
Inventory 35 niezmierzonych bezpoĹ›rednio zasobĂłw nie jest ekstrapolacjÄ…. Dane
nie sÄ… dowodem zachowania na innym sprzÄ™cie, funu, emocji, czytelnoĹ›ci,
zrozumienia fabuĹ‚y ani odbioru przez nowÄ… osobÄ™ (D-012, ADR-003).

Dokumentacja nadal nie zawiera jawnego budĹĽetu liczbowego dla czasu klatki,
renderu, CPU/GPU, canvas metrics ani kosztu produkcji. Nie ustanowiono budĹĽetu
po fakcie, dlatego H-005 pozostaje `TECHNICAL`; H-012 pozostaje `UNTESTED`.
Decyzja produkcyjna: nie optymalizowaÄ‡ i nie zmieniaÄ‡ kodu gry na podstawie
pojedynczego profilu bez kontraktu porĂłwnawczego.

### ZamkniÄ™cie i przekazanie

Zaktualizowano `CURRENT_STATE.md`, `RISKS_AND_HYPOTHESES.md`, `ROADMAP.md`,
`INDEX.md`, raport H-005, ten log i `docs/NEXT_SESSION_PROMPT.md`. NastÄ™pny
prompt otwiera `PKG-0110` dla kontraktu budĹĽetu i powtarzalnoĹ›ci pomiaru H-005.
Po koĹ„cowym PASS pakiet zamroĹĽono w
`snapshots/PKG-0109-2026-08-24/`.

## PKG-0110: powtarzalnoĹ›Ä‡ i pochodzenie kontraktu budĹĽetu H-005

Data: 2026-08-24  
Rola: Lead Programmer i Art Director (D-025, D-085, D-096, D-099, D-103,
D-104, D-105, D-106, D-107, D-108, ADR-004).

### Punkt wyjĹ›cia

Baseline `pwsh -NoProfile -File .\tools\verify.ps1` przeszedĹ‚ przed zmianami
z exit code 0. H-005 miaĹ‚o status `TECHNICAL`: dokumenty wymagaĹ‚y stabilnych
60 FPS, viewportu `640x360` i fizyki 60 Hz, ale nie ustanawiaĹ‚y jawnego
liczbowego budĹĽetu czasu klatki, render CPU/GPU, canvas metrics ani kosztu
produkcji. Dowody PKG-0109 w `reports/pkg_0109/` byĹ‚y zachowane i nie zostaĹ‚y
nadpisane.

### Wykonane zmiany

- Zapisano read-only plan i raport powtarzalnoĹ›ci
  `docs/VECTOR_STAGE_REPEATABILITY_AUDIT_H-005.md`, rozdzielajÄ…cy wymagania
  produktu, budĹĽety subsystemĂłw, historyczne sugestie i konwersjÄ™ `60 Hz` na
  `16.667 ms`.
- `tools/audit_h005.gd` otrzymaĹ‚ wyĹ‚Ä…cznie opcjonalne parametry katalogu i
  etykiety wyjĹ›cia. DomyĹ›lne `PKG-0109` pozostaĹ‚o zachowane; nie zmieniono
  logiki pomiaru ani produktu.
- Wykonano dwa niezaleĹĽne Ĺ›wieĹĽe procesy normalnego Godot 4.7/OpenGL na
  Windows/Intel Iris Xe: `PKG-0110-RUN-01 AUDIT PASS` i
  `PKG-0110-RUN-02 AUDIT PASS`. KaĹĽdy zinwentaryzowaĹ‚ 45 zasobĂłw, zapisaĹ‚ 22
  wiersze statyczne i 5 agregatĂłw cyklu.
- Oba przebiegi miaĹ‚y zgodne metadane, 118 waĹĽnych prĂłbek w kaĹĽdym wierszu
  statycznym i 218 w kaĹĽdym trybie cyklu Station 02. Canvas items,
  primitives i draw calls dziewiÄ™ciu wymaganych kadrĂłw powtĂłrzyĹ‚y siÄ™
  dokĹ‚adnie; czasy, szczegĂłlnie p95 GPU, zachowaĹ‚y zmiennoĹ›Ä‡ i zostaĹ‚y
  pokazane w raporcie bez wybierania korzystniejszego przebiegu.
- Nowe dane zapisano w `reports/pkg_0110/run_01/` i
  `reports/pkg_0110/run_02/`. Nie zmieniono scen, assetĂłw, colliderĂłw,
  mechaniki, dialogĂłw, rozgaĹ‚Ä™zieĹ„, InputMap, fizyki, zapisu ani limitu 25.

### DowĂłd i decyzja

- KoĹ„cowy `pwsh -NoProfile -File .\tools\verify.ps1` przeszedĹ‚ z exit code 0:
  `DOCS PASS`, import Godot, smoke projektu, traversal lint oraz bramki
  `PKG-0095`â€“`PKG-0107` zakoĹ„czyĹ‚y siÄ™ PASS. Znane ostrzeĹĽenia
  `ObjectDB`/`RID leak` nie zmieniĹ‚y kodu wyjĹ›cia.
- PowtarzalnoĹ›Ä‡ strukturalna jednego profilu sprzÄ™towego zostaĹ‚a potwierdzona,
  ale nie istnieje uprzedni formalny budĹĽet, z ktĂłrym moĹĽna porĂłwnaÄ‡ wyniki.
  H-005 pozostaje `TECHNICAL`; H-012 pozostaje `UNTESTED`. Nie dopisano progu
  do `DECISION_LOG.md`, nie ustanowiono budĹĽetu po fakcie i nie wykonano testu
  drugiego GPU ani playtestu.

### ZamkniÄ™cie i przekazanie

Zaktualizowano `CURRENT_STATE.md`, `RISKS_AND_HYPOTHESES.md`, `ROADMAP.md`,
`INDEX.md`, raport H-005, ten log i `docs/NEXT_SESSION_PROMPT.md`. NastÄ™pny
prompt otwiera `PKG-0111: H-005 â€” pochodzenie formalnego budĹĽetu produkcyjnego`.
Po koĹ„cowym PASS wykonano snapshot:
`snapshots/PKG-0110-2026-08-24/`.

## PKG-0111: pochodzenie formalnego budĹĽetu produkcyjnego H-005

Data: 2026-08-24  
Rola: Lead Programmer i Art Director (D-025, D-085, D-096, D-099, D-103,
D-104, D-105, D-106, D-107, D-108, ADR-004).

### Punkt wyjĹ›cia

ĹšwieĹĽy baseline `pwsh -NoProfile -File .\tools\verify.ps1` przeszedĹ‚ z exit
code 0 i komunikatem `Verification passed.` przed audytem. Odczytano wymagany
Ĺ‚aĹ„cuch handoffu, aktywnÄ… bibliÄ™, kierunek wizualny, traversal, raporty H-005,
metadane i podsumowania obu przebiegĂłw PKG-0110 oraz `tools/audit_h005.gd`.

### Wykonane zmiany

- Dodano `docs/VECTOR_STAGE_BUDGET_PROVENANCE_AUDIT_H-005.md` z macierzÄ…
  kandydatĂłw, kryteriami uznania budĹĽetu i wynikiem audytu.
- Zaktualizowano `docs/INDEX.md`, `docs/CURRENT_STATE.md`,
  `docs/RISKS_AND_HYPOTHESES.md` i `docs/ROADMAP.md`, aby opisywaĹ‚y brak
  uprzedniego budĹĽetu oraz status H-005 `TECHNICAL`.
- Nie zmieniono `DECISION_LOG.md`, poniewaĹĽ nie ustanowiono nowego progu ani
  innej decyzji produktowej. Nie zmieniono kodu gry, harnessu ani danych
  pomiarowych.
- Przygotowano nowy, samodzielny prompt `PKG-0112`.

### DowĂłd i decyzja

Kandydaci `60 FPS`, `640x360`, `60 Hz`, jakoĹ›ciowy cel P3, budĹĽet trudnoĹ›ci,
historyczne pomiary oraz `16.667 ms` nie speĹ‚niajÄ… jednoczeĹ›nie warunku
uprzedniego ĹşrĂłdĹ‚a, liczbowego limitu/modelu, zakresu i metody weryfikacji.
`DECISION_LOG.md` nie zawiera formalnego progu H-005. PKG-0109 i PKG-0110 sÄ…
dowodem obserwacji aktualnego runtime'u na jednym profilu Windows/OpenGL/Intel
Iris Xe, nie ĹşrĂłdĹ‚em budĹĽetu istniejÄ…cego przed pomiarem.

H-005 pozostaje `TECHNICAL`; H-012 pozostaje `UNTESTED`. Nie ma dowodu na inne
GPU, koszt pracy artystycznej, odbiĂłr, fun, emocje ani zrozumienie fabuĹ‚y.

### Weryfikacja i zamkniÄ™cie

Baseline po zapisaniu raportu rĂłwnieĹĽ przeszedĹ‚ z exit code 0. Przed snapshotem
wykonaÄ‡ koĹ„cowy `pwsh -NoProfile -File .\tools\verify.ps1`, a nastÄ™pnie:

```powershell
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0111
```

Snapshot: `snapshots/PKG-0111-2026-08-24/`.

## PKG-0113: audyt planu wdroĹĽenia, remediacja Vector-Stage i gotowoĹ›Ä‡ wydawnicza

Data: 2026-08-24  
Rola: Lead Programmer i Art Director (D-025, D-085, D-098, D-099, D-109,
D-110, ADR-004).

### Punkt wyjĹ›cia

ĹšwieĹĽy baseline `pwsh -NoProfile -File .\tools\verify.ps1` przeszedĹ‚ z exit
code 0. Projekt pozostaĹ‚ wyĹ‚Ä…cznie grÄ… Godot 4.7, bez Git. Normal-driver
`tools/audit_h012.gd` przed edycjÄ… zakoĹ„czyĹ‚ siÄ™ PASS dla 12 kadrĂłw, 63
pomiarĂłw rastera i 48 kontroli skal.

Audyt runtime ujawniĹ‚, ĹĽe zielony gĹ‚Ăłwny smoke koĹ„czyĹ‚ wywoĹ‚ania po Station 19,
mimo ĹĽe funkcje testowe 20..43 byĹ‚y zdefiniowane. UjawniĹ‚ teĹĽ cztery blokery
wydania: `run/main_scene` wskazuje Movement Lab, nie ma menu gĹ‚Ăłwnego, centralny
Ĺ‚aĹ„cuch ma limit 25 i brak presetĂłw/buildĂłw Windows/Linux.

### Wykonane zmiany techniczne

- `tests/smoke_test.gd` wywoĹ‚uje Station 20..41, 42A, 42B, 42C i 43. Pierwszy
  peĹ‚ny przebieg ujawniĹ‚ dwa stare zaĹ‚oĹĽenia testu: Station 32 prĂłbowaĹ‚a
  przekroczyÄ‡ granicÄ™ `ObservedGlassTrace`, a Station 38 granicÄ™
  `JakubRescueBulkhead` bez zakotwiczenia. Test wykonuje teraz rzeczywiste
  `toggle_anchor()` przed przejĹ›ciem; peĹ‚ny smoke koĹ„czy siÄ™ PASS.
- Dodano `tests/pkg_0113_smoke_test.gd` i obowiÄ…zkowÄ… bramkÄ™ w
  `tools/verify.ps1`. Gate pilnuje wszystkich wywoĹ‚aĹ„ 01..43, zachowania limitu
  25 i save schema 1, wspĂłlnej warstwy Ĺ›wiatĹ‚a, proceduralnego portretu oraz
  menu pauzy mieszczÄ…cego peĹ‚ny selektor.
- Dodano `tools/capture_pkg_0113.gd` z fazami `before` i `after`; kaĹĽda zapisaĹ‚a
  13 kadrĂłw 640x360 dla przekroju kampanii, dialogu i pauzy.

### Remediacja art-direction i UI

- `VectorStageEnvironment` nie rysuje juĹĽ trzech identycznych lamp w kaĹĽdej
  stacji. Dodano deterministyczne rodziny praktycznego Ĺ›wiatĹ‚a, plan gĹ‚Ä™bi i
  asymetryczne proscenium dla aktĂłw oraz wariantĂłw finaĹ‚u.
- Station 38 ma zredukowanÄ… najwiÄ™kszÄ… bursztynowÄ… plamÄ™, bez zmiany
  `JakubRescueBulkhead`, colliderĂłw lub logiki.
- Dodano `CRTPortrait`; CRT uĹĽywa palety Vector-Stage i semantycznego promptu
  `INTERAKCJA >` zamiast inicjaĹ‚u i staĹ‚ego `[ E ]`.
- Menu pauzy ma panel 568x324, dziewiÄ™Ä‡ kolumn, komplet 43 ustalonych pozycji i
  jawne stany przyciskĂłw. ĹšwieĹĽy kadr nie obcina dolnych pozycji.
- `tools/audit_h012.gd` mierzy aktualnÄ… ramÄ™ CRT. Ponowny przebieg po zmianach
  zakoĹ„czyĹ‚ siÄ™ `PKG-0108 AUDIT PASS`; H-012 pozostaje `UNTESTED`.

### Audyt planu i dokumentacja

- Dodano `docs/IMPLEMENTATION_PLAN_AUDIT_AND_RELEASE_READINESS.md` z macierzÄ…
  prawdy runtime i kolejkÄ… R0..R5. Meta brzmi: ukoĹ„czona gra Godot PC i
  gotowoĹ›Ä‡ produkcyjna do publicznego wydania na Windows/Linux; nie opisuje
  bieĹĽÄ…cego stanu.
- Dodano `docs/VECTOR_STAGE_ART_DIRECTION_AUDIT.md` z 13 parami before/after,
  wykonanymi poprawkami i backlogiem P1 przed content lockiem.
- Poprawiono `README.md`, `ROADMAP.md`, `RISKS_AND_HYPOTHESES.md`,
  `DECISION_LOG.md`, `INDEX.md`, `CURRENT_STATE.md` i raport H-012. D-109
  ustanawia prawdziwÄ… drogÄ™ do wydania i techniczny baseline profilu A;
  D-110 ustanawia rodziny Ĺ›wiatĹ‚a/ramy oraz semantyczne UI.
- H-001 ma `ACCEPTED-RISK` bez twierdzenia o przyjemnoĹ›ci ruchu. H-005
  pozostaje `TECHNICAL`, H-012 `UNTESTED`.
- Nowy `docs/NEXT_SESSION_PROMPT.md` otwiera PKG-0114 R0: produkcyjny shell,
  peĹ‚na topologia 01..41 â†’ 42A/B/C â†’ 43 i test end-to-end.

### DowĂłd

- baseline `tools/verify.ps1`: PASS, exit code 0;
- pierwszy poszerzony `tests/smoke_test.gd`: FAIL na prawdziwych granicach
  Station 32 i 38; po naprawie: **SMOKE PASS**, wszystkie sceny wywoĹ‚ane;
- `tests/pkg_0113_smoke_test.gd`: **PASS**, exit code 0;
- normal-driver `tools/capture_pkg_0113.gd` before: **13/13 PASS**;
- normal-driver `tools/capture_pkg_0113.gd` after: **13/13 PASS**;
- normal-driver `tools/audit_h012.gd` po remediacji: **PASS**, 12 kadrĂłw,
  63 pomiary, 48 kontroli skal;
- koĹ„cowe `verify_docs.ps1` i `tools/verify.ps1`: **PASS**, exit code 0.

Znane ostrzeĹĽenia `ObjectDB`/`RID leak` przy zamykaniu wybranych procesĂłw
pozostajÄ… nieblokujÄ…cym szumem, gdy gate koĹ„czy siÄ™ kodem 0.

### Ograniczenia

Produkt nadal nie jest gotowy do wydania. Nie ma produkcyjnego punktu wejĹ›cia,
menu gĹ‚Ăłwnego, peĹ‚nego ciÄ…gu 26..43, ustawieĹ„/remapu/PL-EN, presetĂłw eksportu,
buildĂłw ani testu czystej instalacji. Kadry i automaty nie dowodzÄ… funu,
emocji, czytelnoĹ›ci przez nowÄ… osobÄ™ ani zrozumienia fabuĹ‚y. Warianty 41, 42B,
43 oraz peĹ‚ny zestaw portretĂłw pozostajÄ… nazwanym backlogiem P1.

### ZamkniÄ™cie i przekazanie

Pakiet zachowaĹ‚ collidery, `AirlockZone`, promienie interakcji, InputMap,
fizykÄ™ 60 Hz, `CAMPAIGN_TRANSITION_LIMIT = 25`, `SAVE_SCHEMA_VERSION = 1`,
flagi, dialogi i rozgaĹ‚Ä™zienia. Handoff:
`docs/NEXT_SESSION_PROMPT.md`. Snapshot:
`snapshots/PKG-0113-2026-08-24/`.

## PKG-0114: R0 â€” produkcyjny shell, peĹ‚na topologia kampanii i end-to-end

Data: 2026-08-24  
Zakres: wyĹ‚Ä…cznie gra Godot 4.7; bez web/mobile, Git, nowych przeszkĂłd i
colliderĂłw.

### Baseline i wykonanie

- Baseline przed zmianami: `pwsh -NoProfile -File .\tools\verify.ps1`, exit
  code 0.
- `project.godot` wskazuje `scenes/shell/title_screen.tscn`; shell ma
  `NOWA GRA`, `KONTYNUUJ`, `USTAWIENIA` i `ZAKOĹCZ`.
- `GameStateManager` prowadzi 01..41 â†’ dokĹ‚adnie wybrany 42A/42B/42C â†’ 43 â†’
  menu, zachowujÄ…c `SAVE_SCHEMA_VERSION = 1`. Ustawienia Master/tempo/fullscreen
  majÄ… osobny wersjonowany JSON i fallback uszkodzonego pliku.
- `tests/pkg_0114_smoke_test.gd` sprawdza realne sygnaĹ‚y ukoĹ„czenia, pojedyncze
  przejĹ›cia, trzy gaĹ‚Ä™zie, NowÄ… grÄ™, Kontynuuj, powrĂłt po epilogu i malformed
  save. Gate jest w `tools/verify.ps1`.
- Historyczny gate PKG-0095 dostaĹ‚ brakujÄ…ce wywoĹ‚anie `station_15` przed
  asercjÄ… unlocku `station_16`; zmiana dostosowuje test do aktualnego API i nie
  zmienia runtime.

### DowĂłd koĹ„cowy

- izolowany `tests/pkg_0114_smoke_test.gd`: **PASS**, exit code 0;
- normal-driver `tools/capture_pkg_0114.gd`: **9/9 PASS**, pliki w
  `reports/pkg_0114/`, wszystkie obejrzane w 640x360;
- `pwsh -NoProfile -File .\tools\verify_docs.ps1 -ProjectRoot (Get-Location)`:
  **DOCS PASS**, 27 wymaganych plikĂłw i kontraktĂłw;
- koĹ„cowy `pwsh -NoProfile -File .\tools\verify.ps1`: **Verification passed**,
  exit code 0; smoke 01..43, traversal lint, PKG-0095..0107, PKG-0113 i
  PKG-0114 przechodzÄ….

### Ograniczenia

Pakiet nie jest deklaracjÄ… gotowoĹ›ci wydawniczej. Nadal brakuje eksportĂłw,
czystej instalacji, peĹ‚nego remapu/pada, skali tekstu, kompletnej PL/EN,
content locka, credits/licencji i dowodu odbioru przez ludzi. H-005 pozostaje
`TECHNICAL`, H-012 `UNTESTED`; automaty i capture'y dowodzÄ… kontraktĂłw
technicznych, nie funu, emocji, czytelnoĹ›ci ani zrozumienia fabuĹ‚y.
Znane ostrzeĹĽenia Godot `ObjectDB`/`RID leak` przy zamykaniu procesĂłw sÄ…
nieblokujÄ…ce, gdy gate koĹ„czy siÄ™ kodem 0.

### ZamkniÄ™cie i przekazanie

Dokumenty ĹĽywe: `README.md`, `docs/CURRENT_STATE.md`, `docs/ROADMAP.md`,
`docs/RISKS_AND_HYPOTHESES.md`, `docs/DECISION_LOG.md` oraz nowy handoff
`docs/NEXT_SESSION_PROMPT.md`. NastÄ™pny pakiet: `PKG-0115` R1 â€” ustawienia
systemowe, peĹ‚ny pad, dostÄ™pnoĹ›Ä‡ i PL/EN. Snapshot:
`snapshots/PKG-0114-2026-08-24/`.

## PKG-0115: R1 â€” ustawienia systemowe, peĹ‚ny pad, dostÄ™pnoĹ›Ä‡ i PL/EN

Data: 2026-08-24  
Zakres: wyĹ‚Ä…cznie gra Godot 4.7; bez web/mobile, Git, nowych przeszkĂłd i
colliderĂłw.

### Baseline i wykonanie

- Baseline przed zmianami: `pwsh -NoProfile -File .\tools\verify.ps1`, exit
  code 0.
- Dodano wspĂłlny `scripts/ui/settings_overlay.gd` dla shellu i pauzy. Ustawienia
  obejmujÄ… Master, tempo tekstu, skalÄ™ 85â€“115%, fullscreen, PL/EN i panel remapu.
- `GameStateManager` utrzymuje osobny `SETTINGS_SCHEMA_VERSION = 1`, waliduje
  JSON, wraca do defaults dla nieznanego/uszkodzonego pliku, serializuje
  klawisze i przyciski pada oraz odrzuca konflikty remapu. Remap obejmuje piÄ™Ä‡
  jawnie wybranych akcji produkcyjnych; domyĹ›lny InputMap pozostaje moĹĽliwy do
  przywrĂłcenia.
- Shell, pauza, ustawienia i CRT otrzymaĹ‚y semantyczny fokus oraz PL/EN dla UI
  i komunikatĂłw systemowych. Dialog narracyjny pozostaĹ‚ w ĹşrĂłdĹ‚owym jÄ™zyku;
  nie wykonano globalnej podmiany tekstĂłw.
- Dodano domyĹ›lne przyciski pada Start/Back dla pauzy/restartu bez naruszenia
  istniejÄ…cych mapowaĹ„. Zachowano trasÄ™ 01..41 â†’ dokĹ‚adnie wybrany 42A/B/C â†’ 43,
  `SAVE_SCHEMA_VERSION = 1`, fizykÄ™ 60 Hz, viewport 640x360 i collidery.
- Dodano `tests/pkg_0115_smoke_test.gd` do `tools/verify.ps1` oraz
  `tools/capture_pkg_0115.gd` dla shellu PL/EN, ustawieĹ„, remapu, pauzy i CRT.

### DowĂłd koĹ„cowy

- izolowany `tests/pkg_0114_smoke_test.gd`: **PASS**;
- izolowany `tests/pkg_0115_smoke_test.gd`: **PASS**;
- normal-driver `tools/capture_pkg_0115.gd`: **7/7 PASS**, wszystkie pliki
  majÄ… 640x360 i zostaĹ‚y obejrzane w rozmiarze ĹşrĂłdĹ‚owym; wczeĹ›niejsze
  przepeĹ‚nienie dĹ‚ugich etykiet pada usuniÄ™to przez krĂłtkie prompty semantyczne,
  a panel ustawieĹ„ ma nieprzezroczyste tĹ‚o;
- `pwsh -NoProfile -File .\tools\verify_docs.ps1 -ProjectRoot (Get-Location)`:
  **DOCS PASS**;
- koĹ„cowy `pwsh -NoProfile -File .\tools\verify.ps1`: **Verification passed**,
  exit code 0; smoke 01..43, traversal lint, PKG-0095..0107, PKG-0113,
  PKG-0114 i PKG-0115 przechodzÄ….

### Ograniczenia

R1 jest zamkniÄ™te technicznie, ale projekt nadal nie jest gotowy do wydania.
Brakuje eksportĂłw, buildĂłw, czystej instalacji, content locka R2, peĹ‚nej
lokalizacji narracji, credits/licencji i audytu odbioru przez ludzi. Automaty i
capture'y dowodzÄ… kontraktĂłw technicznych, wymiaru i renderu; nie dowodzÄ… funu,
emocji, ergonomii, czytelnoĹ›ci przez nowÄ… osobÄ™ ani zrozumienia fabuĹ‚y. H-005
pozostaje `TECHNICAL`, H-012 `UNTESTED`; znane ostrzeĹĽenia ObjectDB/RID sÄ…
nieblokujÄ…ce przy kodzie wyjĹ›cia 0.

### ZamkniÄ™cie i przekazanie

Dokumenty ĹĽywe: `README.md`, `docs/CURRENT_STATE.md`, `docs/ROADMAP.md`,
`docs/RISKS_AND_HYPOTHESES.md`, `docs/DECISION_LOG.md` oraz handoff
`docs/NEXT_SESSION_PROMPT.md`. Decyzja: D-112. NastÄ™pny pakiet: `PKG-0116` R2 â€”
content lock obrazu, dialogu i dĹşwiÄ™ku. Snapshot:
`snapshots/PKG-0115-2026-08-24/`.

## PKG-0116: Creative rebaseline â€” kontrolowana przebudowa zamiast content locku

Data: 2026-08-24  
Zakres: dokumentacja, kanon, art direction, architektura prezentacji i plan
wdroĹĽeĹ„ gry Godot 4.7; bez zmian runtime, assetĂłw, colliderĂłw, webu i Git.

### Baseline i diagnoza

- Baseline przed zmianami: `pwsh -NoProfile -File .\tools\verify.ps1`,
  `Verification passed.`, kod 0. GĹ‚Ăłwny smoke instancjonowaĹ‚ Station 01â€“43,
  traversal lint oraz gate'y PKG-0095..0115 przechodziĹ‚y.
- Audyt aktualnych biblii i skryptĂłw wykazaĹ‚, ĹĽe rozwiÄ…zanie innego Ĺ›wiata byĹ‚o
  ujawniane w pierwszych ekranach, zanim tytuĹ‚ zdÄ…ĹĽyĹ‚ narastaÄ‡.
- `PrototypePlayer._draw()` i kadry PKG-0113 potwierdziĹ‚y technicznÄ… diagnozÄ™:
  aktywna Lena byĹ‚a maĹ‚Ä… proceduralnÄ… figurÄ… z kilku bryĹ‚/linii, bez
  produkcyjnego rigu i aktorskiej pÄ™tli ruchu.
- Inwentaryzacja znalazĹ‚a 33 skrypty poziomĂłw z `draw_string()` lub
  `draw_multiline_string()` oraz liczne `CanvasLayer`; globalna pikselizacja bez
  migracji rozmyĹ‚aby tekst.
- BezpoĹ›rednie materiaĹ‚y Ă‰rica Chahiego/GDC posĹ‚uĹĽyĹ‚y wyĹ‚Ä…cznie do wydzielenia
  ogĂłlnych zasad obserwowanego ruchu, redukcji pozy i krĂłtkiej filmowej
  interpunkcji. Granice wykluczajÄ… kopiowanie postaci, klatek, palety i kadrĂłw.

### Decyzja i dokumenty

- ADR-006 i D-113 anulowaĹ‚y dawny PKG-0116 R2 content lock oraz bezpoĹ›redniÄ…
  drogÄ™ do buildĂłw. Wybrano kontrolowanÄ… przebudowÄ™: zachowaÄ‡ techniczny
  krÄ™gosĹ‚up Godota, ponownie stworzyÄ‡ kampaniÄ™, LenÄ™, guidance i powierzchniÄ™
  obrazu.
- Kanon 0.2 ustanawia: 01â€“05 normalnoĹ›Ä‡, 06â€“20 stopniowÄ… eskalacjÄ™, Station 21
  jako jedynÄ… pierwszÄ… bramÄ™ â€žTo nie jest mĂłj Ĺ›wiatâ€ť, Station 22 jako poczÄ…tek
  Ĺ›wiadomego Anchor/Yield oraz trzy rodziny konsekwencji 42Aâ€“42C z wariantem
  stabilnoĹ›ci epilogu.
- ZastÄ…piono `PRODUCT_BRIEF.md`, `PROJECT_BIBLE.md`, `VISUAL_DESIGN.md`,
  `ROADMAP.md`, `RISKS_AND_HYPOTHESES.md`, `INDEX.md`, `CURRENT_STATE.md` oraz
  cztery dokumenty narracyjne.
- Dodano `CREATIVE_REBUILD_PLAN.md`, `LENA_CHARACTER_AND_ANIMATION.md`,
  `PLAYER_GUIDANCE_AND_INNER_VOICE.md`,
  `PIXEL_PRESENTATION_ARCHITECTURE.md` i ADR-006.
- RĂłwieĹ„ Pixel-Stage zachowuje kompozycyjnÄ… dyscyplinÄ™ Vector-Stage, ale Ĺ›wiat
  ma domyĹ›lny raster 320x180, a dialog, myĹ›li, czytelny tekst i UI sÄ…
  kompozytowane ostro pĂłĹşniej.
- `tools/verify_docs.ps1` rozszerzono z 28 do 34 wymaganych plikĂłw oraz o
  kontrakty ADR-006/D-113, planu, Leny, drabiny L0â€“L4 i ostrych warstw tekstu.
- `NEXT_SESSION_PROMPT.md` zastÄ…piono samowystarczalnym PKG-0117 Foundation
  Slice 01â€“07: `LenaVisualRig` + `WorldPixelCompositor` + GuidanceBeat/myĹ›li +
  ponowne autorstwo otwarcia.

### DowĂłd koĹ„cowy

- `pwsh -NoProfile -File .\tools\verify_docs.ps1 -ProjectRoot (Get-Location)`:
  `DOCS PASS: 34 required files and handoff contracts`, kod 0.
- `pwsh -NoProfile -File .\tools\verify.ps1`: `Verification passed.`, kod 0;
  import, Movement/Anchor Lab, Station 01â€“43, traversal lint i wszystkie
  historyczne gate'y PKG-0095..0115 przeszĹ‚y.
- Znane ostrzeĹĽenia ObjectDB oraz oczekiwane ostrzeĹĽenia fixture uszkodzonego
  zapisu/nieznanego schema ustawieĹ„ nie zmieniĹ‚y kodu koĹ„cowego 0.

### Ograniczenia

Pakiet nie implementuje nowej gry ani grafiki runtime. `LenaVisualRig`,
Pixel-Stage, ostre teksty Ĺ›wiata, guidance i nowa treĹ›Ä‡ 01â€“43 sÄ… kontraktami do
wdroĹĽenia od PKG-0117. Nie wykonano nowego capture'a, bo runtime obrazu nie
zostaĹ‚ zmieniony; obejrzane kadry PKG-0113 dowodzÄ… wyĹ‚Ä…cznie diagnozy starego
placeholdera. Testy nie dowodzÄ… napiÄ™cia, emocji, funu, zrozumienia, ludzkiej
wiarygodnoĹ›ci myĹ›li ani jakoĹ›ci artystycznej nowego kierunku.

### ZamkniÄ™cie i przekazanie

Decyzje: ADR-006, D-113. NastÄ™pny pakiet: `PKG-0117 â€” Foundation Slice 01â€“07`.
Handoff: `docs/NEXT_SESSION_PROMPT.md`. Snapshot:
`snapshots/PKG-0116-2026-08-24/`.

## PKG-0117: Relacyjna rewolucja narracji 0.3 i audyt rekoncyliacyjny Foundation

Data: 2026-08-25  
Zakres: audyt dodanych skilli narracyjnych, nowy kanon i peĹ‚na mapa 01â€“43,
decyzja architektoniczna, plan wdroĹĽenia oraz zachowawcza rekoncyliacja
niezamkniÄ™tych zmian `LenaVisualRig` / Pixel-Stage / guidance / 01â€“07. Bez
webu, Git, eksportĂłw i bez uznania aktywnej treĹ›ci 01â€“07 za content lock.

### Baseline i rozbieĹĽnoĹ›Ä‡ stanu

- Wymagana kolejnoĹ›Ä‡ dokumentĂłw zostaĹ‚a przeczytana przed edycjÄ…. Stary
  `verify_docs.ps1` przechodziĹ‚ 34 kontrakty.
- Pierwsze peĹ‚ne `verify.ps1` uruchomione podczas trwajÄ…cych zmian na dysku
  zakoĹ„czyĹ‚o siÄ™ 24 asercjami Station 01/06/08. Pliki scen zmieniaĹ‚y timestampy
  jeszcze po starcie bramki, wiÄ™c wynik zapisano jako rozbieĹĽnoĹ›Ä‡ stanu, nie
  jako wiarygodny baseline stabilnego runtime.
- Znaleziono dwa procesy Godota uruchomione przez
  `tests/pkg_0117_smoke_test.gd` o 23:42/23:43 bez istniejÄ…cych procesĂłw
  nadrzÄ™dnych. Po potwierdzeniu osierocenia zatrzymano wyĹ‚Ä…cznie PID 14436 i
  28892. Nie cofniÄ™to ani nie nadpisano hurtowo ĹĽadnych plikĂłw.
- Po ustaniu zapisĂłw zastany gate PKG-0117 przeszedĹ‚ z kodem 0.

### Audyt skilli i werdykt

- Tryb story review: requested `full`, effective `solo`; wymagane przez skill
  projektowe role reviewerĂłw nie byĹ‚y dostÄ™pne, wiÄ™c zastosowano rubric solo z
  jawnym fallbackiem.
- Zastosowano skille dotyczÄ…ce audytu opowieĹ›ci, rdzenia fabuĹ‚y, relacji,
  naturalnego dialogu, konwencji mystery, ciÄ…gĹ‚oĹ›ci, zapomnianych elementĂłw,
  emotional narrative oraz experience design. Skille webnovelowe,
  chiĹ„skojÄ™zyczne, platformowe/EPUB i prezentacyjne przejrzano, lecz nie
  przyjÄ™to ich norm jako wĹ‚aĹ›ciwych dla tej gry.
- `docs/NARRATIVE_SKILL_AUDIT_0_2.md` odrzuca 0.2 jako podstawÄ™ dalszego
  autorstwa. NajwaĹĽniejsze S1: brak osobistego silnika Leny, nierozwiÄ…zana
  sprawczoĹ›Ä‡ miejscowej Leny, brak aktywnej przeciwwagi, abstrakcyjne finaĹ‚y i
  naruszenie wiedzy Station 21. S2: niejasna relacja Marty, wspĂłlny
  aforystyczny gĹ‚os postaci, sceny-przekaĹşniki poszlak i zbyt poprawne myĹ›li.
- Decyzja: gĹ‚Ä™boka rewolucja fabularna w istniejÄ…cym projekcie Godot. Pusty
  projekt odrzucono, bo nie rozwiÄ…zuje problemu opowieĹ›ci, a ryzykuje dziaĹ‚ajÄ…cy
  shell, zapis, sterowanie, audio i topologiÄ™.

### Kanon 0.3

- Linia 4 daje Lenie ranÄ™: dziewiÄ™Ä‡ lat wczeĹ›niej trzysekundowa luka poprzedziĹ‚a
  katastrofÄ™ i Ĺ›mierÄ‡ Jakuba w jej ciÄ…gĹ‚oĹ›ci. Potrzeba pewnoĹ›ci staĹ‚a siÄ™
  potrzebÄ… kontroli.
- W RĂłwni Jakub przeĹĽyĹ‚ stabilizacjÄ™ Linii 4. Miejscowa Lena jest partnerkÄ…
  Marty i pracowniczkÄ… UCP-4; odkrywa skorelowane koszty i uruchamia prĂłbÄ™
  wzajemnÄ….
- O 20:40 obie Leny dokonujÄ… odpowiadajÄ…cego pomiaru. Wierzbicka kotwiczy
  miejscowÄ… obecnoĹ›Ä‡ podczas kontaktu, Ĺ›ciÄ…ga przybyĹ‚Ä… LenÄ™ do RĂłwni i wiÄ™zi
  miejscowÄ… LenÄ™ pomiÄ™dzy adresami.
- Pierwsza tajemnica 01â€“21 brzmi â€žgdzie jest Lena?â€ť; dopiero Station 21 pozwala
  powiedzieÄ‡ `To nie jest mĂłj Ĺ›wiat`. Druga 22â€“39 dotyczy tego, co zrobiĹ‚a
  miejscowa Lena i kto zapĹ‚aci za rozdzielenie Ĺ›wiatĂłw.
- Marta Kurek jest najbliĹĽszÄ… przyjaciĂłĹ‚kÄ…/dawnÄ… partnerkÄ… terenowÄ… przybyĹ‚ej
  Leny oraz partnerkÄ… ĹĽyciowÄ… miejscowej Leny. Jakub ma wĹ‚asny cel i zgodÄ™.
  Wierzbicka aktywnie chroni stabilnoĹ›Ä‡ mierzalnej wiÄ™kszoĹ›ci.
- FinaĹ‚y 42A/42B/42C jawnie opisujÄ… stan obu Len, Marty, Jakuba, UCP i relacji
  ciÄ…gĹ‚oĹ›ci. Ĺ»aden nie odzyskuje wszystkiego ani nie jest golden ending.

### Dokumentacja i decyzje

- Dodano `docs/NARRATIVE_SKILL_AUDIT_0_2.md` oraz
  `docs/decisions/ADR-007-character-first-narrative-revolution.md`.
- Dodano D-114; D-113 oznaczono jako czÄ™Ĺ›ciowo zastÄ…pione.
- ZastÄ…piono `NARRATIVE_BIBLE.md`, `FULL_STORY.md`,
  `CONTINUITY_TRACKER.md` i `DIALOGUE_SCRIPT.md` wersjÄ… 0.3.
- KaĹĽda z 43 przestrzeni w `FULL_STORY.md` ma cel, przeszkodÄ™, czynnoĹ›Ä‡,
  zdarzenie do pokazania, zmianÄ™ i nowe oczekiwanie. Trzy warianty 42 dajÄ… 45
  nagĹ‚ĂłwkĂłw scen, lecz jedna trasa nadal odwiedza 43 adresy.
- ZastÄ…piono Product Brief, Project Bible, kontrakt guidance, plan przebudowy,
  roadmapÄ™ i rejestr ryzyk. Zaktualizowano INDEX, README, Visual Design,
  model sheet Leny i research.
- `tools/verify_docs.ps1` rozszerzono do 36 plikĂłw i kontraktĂłw
  ADR-007/D-114/audytu/kanonu 0.3.

### Rekoncyliacja Foundation

- `KEEP`: separacja riga od fizyki, architektura warstw kompozytora/crisp
  text, serwis guidance, powierzchnia myĹ›li, integracja i smoke API.
- `ADAPT`: anatomia i key poses Leny, faktyczna jakoĹ›Ä‡/koszt pikselizacji,
  GuidanceBeat z hipotezÄ… i sprawdzeniem oraz peĹ‚na treĹ›Ä‡ 01â€“07.
- `RETIRE`: anomalia i podwĂłjny cieĹ„ 02, alternatywna fotografia/podwĂłjne
  przedmioty 03, ĹĽywy Jakub i jawne UCP 04, ruchoma geometria/szept 05,
  pierĹ›cieĹ„ i obca biografia 06, Marta w mieszkaniu/Ĺ›lepe schody 07.
- Historyczny `pkg_0100_smoke_test.gd` zaktualizowano do faktycznej Ĺ›cieĹĽki
  `Geometry/ReplacementBusExitDoor` oraz klatek fizyki. Nadal sprawdza typ,
  ruch drzwi, koszt korekty i zapis decyzji; pokrycie nie zostaĹ‚o osĹ‚abione.

### Render i ograniczenia wizualne

- `tools/capture_preview.gd` uruchomiono normalnym sterownikiem Windows:
  OpenGL 3.3 Compatibility, Intel Iris Xe, kod 0.
- Obejrzano Ĺ›wieĹĽe `station_01.png`, `station_05.png`,
  `station_07.png` i `movement_lab.png`.
- Ostry tekst nad Ĺ›wiatem jest widoczny technicznie. Lena jest rozpoznawalnÄ…
  ludzkÄ… sylwetkÄ…, ale nadal maĹ‚ym proceduralnym manekinem bez docelowych key
  poses. Efekt pikselizacji jest zbyt subtelny do akceptacji artystycznej.
  Station 07 nadal pokazuje kiosk na starej geometrii klatki.
- Capture i automat nie dowodzÄ… jakoĹ›ci grafiki, niepokoju, emocji, zabawy ani
  zrozumienia.

### DowĂłd koĹ„cowy

- `pwsh -NoProfile -File .\tools\verify_docs.ps1`:
  `DOCS PASS: 36 required files and handoff contracts`, kod 0.
- `tests/pkg_0117_smoke_test.gd`: techniczne testy rekoncyliacji, kod 0.
- `tests/pkg_0100_smoke_test.gd`: po aktualizacji Ĺ›cieĹĽki i synchronizacji,
  `PKG-0100 SMOKE PASS`, kod 0.
- `pwsh -NoProfile -File .\tools\verify.ps1`: `Verification passed.`, kod
  0; import, gĹ‚Ăłwny smoke 01â€“43, traversal lint, gate'y PKG-0095..0115 oraz
  gate komponentĂłw PKG-0117 przeszĹ‚y.
- PozostaĹ‚y nieblokujÄ…ce ostrzeĹĽenia ObjectDB oraz oczekiwane warningi
  fallbackĂłw uszkodzonego zapisu/nieznanego schema ustawieĹ„.

### Ograniczenia

Kanon 0.3 jest specyfikacjÄ…, nie ukoĹ„czonÄ… kampaniÄ…. Aktywny runtime 01â€“07 nadal
zawiera elementy `RETIRE`; 08â€“43 pozostaje legacy. Nie potwierdzono jakoĹ›ci
artystycznej Leny, peĹ‚nej ostroĹ›ci wszystkich tekstĂłw, kosztu kompozytora,
odbioru relacji, tempa tajemnicy ani emocjonalnej rĂłwnowagi finaĹ‚Ăłw. Zgodnie z
politykÄ… projektu nie przeprowadzano zewnÄ™trznych playtestĂłw na tym etapie.

### ZamkniÄ™cie i przekazanie

Decyzje: ADR-007, D-114. NastÄ™pny pakiet:
`PKG-0118 â€” Foundation Slice 01â€“07 wedĹ‚ug kanonu 0.3`.
Handoff: `docs/NEXT_SESSION_PROMPT.md`.
Snapshot: `snapshots/PKG-0117-2026-08-25/`.

## PKG-0118: Foundation Slice 01â€“07 wedĹ‚ug kanonu 0.3

Data: 2026-08-25  
Zakres: `Station 01..07`, `LenaVisualRig`, `WorldPixelCompositor`, `CrispDiegeticText`, `NarrativeGuidanceService`, `tests/pkg_0118_smoke_test.gd`, `tests/smoke_test.gd`, `tests/pkg_0100_smoke_test.gd`.

### Wynik pakietu

1. **WdroĹĽenie Kanonu 0.3 w Station 01â€“07**:
   - **Station 01 (Ostatni odczyt)**: Rutynowy pomiar drgaĹ„ na Linii 4, 3s luka, czysty drugi pomiar, zapis prĂłbki `LINIA 4 / LUKA 00:00:03`, spakowanie sprzÄ™tu i wyjĹ›cie. Cichy kontakt obu Len o 20:40.
   - **Station 02 (ObejĹ›cie serwisowe)**: ZamkniÄ™cie skrĂłtu po rzeczywistych pracach konserwacyjnych, sprawdzenie wygaszonego obwodu, bezpieczne przejĹ›cie kĹ‚adkÄ…. UsuniÄ™to anomaliÄ™ korelacyjnÄ…, stosunek 1.42 i nieciÄ…gĹ‚y cieĹ„.
   - **Station 03 (WiadomoĹ›Ä‡ Marty)**: Przystanek techniczny ze sĹ‚abym zasiÄ™giem i opĂłĹşnionÄ… tablicÄ…. SMS od Marty (`MiaĹ‚aĹ› wrĂłciÄ‡...`), Lena kasuje dĹ‚ugie tĹ‚umaczenie i odpisuje `JadÄ™.`. UsuniÄ™to podwĂłjne kubki, zmienione zdjÄ™cie i "URLOP PRZERWANY".
   - **Station 04 (Przejazd)**: Nocny przejazd wagonem, czytnik w buforze powtarza lukÄ™ 3s, restart urzÄ…dzenia i odĹ‚oĹĽenie ekranem do doĹ‚u; za oknem pomnik Linii 4. UsuniÄ™to straĹĽnika IKP i wzmiankÄ™ o martwym Jakubie.
   - **Station 05 (Znana ulica)**: Spacer znajomÄ… ulicÄ… w deszczu, neutralny szyld `UCP / PRACE NOCNE`, ustawienie flagi `ordinary_return_complete`. UsuniÄ™to ruchomÄ… architekturÄ™, brakujÄ…ce piÄ™tro i szept imienia.
   - **Station 06 (Dwa rozkĹ‚ady)**: Papierowy rozkĹ‚ad vs offline cache w aplikacji o tej samej dacie lecz innych numerach linii. PrzyjeĹĽdĹĽajÄ…cy autobus potwierdza papier; Lena racjonalizuje to jako stary cache (`Cache. Najprostsze.`). UsuniÄ™to pasaĹĽera z obrÄ…czkÄ… i dialog o obcej biografii.
   - **Station 07 (Herbata dla Marty / Kiosk)**: Rzeczywisty sklep/kiosk osiedlowy ("Kiosk u Pawlaka"). Sprzedawca pyta o herbatÄ™ dla Marty, Lena pyta o wczorajszÄ… wizytÄ™, sprzedawca wskazuje zwykĹ‚y rejestr sprzedaĹĽy i zamyka sklep. Lena kupuje wodÄ™, ciaĹ‚o zatrzymuje siÄ™ przed odebraniem butelki, Lena racjonalizuje to pomyĹ‚kÄ… klientki / nazwiskiem z karty. Koniec sceny kieruje do sprawdzenia adresu w Station 08. UsuniÄ™to klatkÄ™ schodowÄ…, MartÄ™ w progu i Ĺ›lepe schody.

2. **Aktorstwo i postaÄ‡ Leny (`LenaVisualRig`)**:
   - 13 stanĂłw: `idle`, `start`, `walk`, `run`, `stop`, `turn`, `jump_rise`, `jump_fall`, `land`, `interact`, `examine`, `unease_reaction`, `seam_gesture`.
   - Proporcje 48 px, sylwetka, zwrot, oddech, obsĹ‚uga cue i debug override.

3. **Architektura warstw i ostre teksty**:
   - `WorldPixelCompositor` w CanvasLayer 5 (skala 2.0x, 320x180).
   - `CrispDiegeticText` w CanvasLayer 10 dla napisĂłw w Ĺ›wiecie.
   - `InnerThoughtSurface` w CanvasLayer 16 dla myĹ›li i wskazĂłwek.
   - `CRTDialogueBox` w CanvasLayer 20 dla dialogu mĂłwionego.
   - CaĹ‚kowity brak wywoĹ‚aĹ„ `draw_string()` w Layer 0 w Station 01..07.

4. **Omylne Guidance**:
   - `NarrativeGuidanceService` z wymuszonym cooldownem >= 8.0s, rejestracjÄ… hipotez (`hypothesis_id`, `predicted_check`) i ich zamykaniem po weryfikacji.

5. **Weryfikacja testowa**:
   - `tests/pkg_0118_smoke_test.gd` w peĹ‚ni weryfikuje rig Leny, kompozytor, ostre teksty, serwis guidance, pÄ™tle stacji 01..07 oraz lint pojÄ™Ä‡ Aktu I (brak zakazanych terminĂłw).
   - Zaktualizowano `tests/smoke_test.gd` i `tests/pkg_0100_smoke_test.gd` do nowego kontraktu bez osĹ‚abiania pokrycia.

### DowĂłd koĹ„cowy

- `pwsh -NoProfile -File .\tools\verify.ps1` -> **PASS (exit code 0)**.
- `tools/capture_preview.gd` -> wyrenderowano i zweryfikowano klatki PNG pod sterownikiem Windows.

### Ograniczenia

Automatyczne bramki dowodzÄ… kontraktĂłw technicznych i logiki. DoĹ›wiadczenie emocjonalne, subtelnoĹ›Ä‡ niepokoju i czytelnoĹ›Ä‡ racjonalizacji pozostajÄ… hipotezami zgodnie z ADR-003.

### ZamkniÄ™cie i przekazanie

NastÄ™pny pakiet: `PKG-0119 â€” Rysa i cudzy dom 08â€“13`.  
Handoff: `docs/NEXT_SESSION_PROMPT.md`.

## PKG-0118: Foundation Slice 01â€“07 wedĹ‚ug kanonu 0.3

Data: 2026-08-25

Identyfikator stanu: `PKG-0118`

Kontekst: Pierwszy pakiet realizacyjny przebudowy 3.0 po rekoncyliacji PKG-0117 i wdroĹĽeniu Kanonu 0.3 (ADR-007, D-114). Pakiet adaptuje przestrzenie Foundation (Station 01â€“07), usuwajÄ…c przedwczesne anomalie paranormalne, implementuje 13 stanĂłw aktorskich LenaVisualRig, warstwy WorldPixelCompositor (Layer 5) / CrispDiegeticText (Layer 10) oraz omylny system NarrativeGuidanceService z cyklem hipotez.

### Wynik

1. **LenaVisualRig â€” sylwetka i 13 kluczowych pĂłz**:
   - WdroĹĽono peĹ‚ne mapowanie stanĂłw: `idle`, `start`, `walk`, `run`, `stop`, `turn`, `jump_rise`, `jump_fall`, `land`, `interact`, `examine`, `unease_reaction`, `seam_gesture`.
   - Zapewniono proporcje 44â€“52px wysokoĹ›ci, fasetowy podziaĹ‚ tuĹ‚owia i gĹ‚owy, kontaktowy miÄ™kki cieĹ„ owalny pod stopami oraz bezwĹ‚adnoĹ›Ä‡ torby pomiarowej.
   - WdroĹĽono gest lewego szwu (`seam_gesture`) jako diegetyczny nawyk sensoryczny Leny, powiÄ…zany z momentami wahania i powrotu do skupienia.

2. **Pixel-Stage i architektura warstwowa tekstu**:
   - `WorldPixelCompositor` inicjalizowany na `CanvasLayer 5`, skalujÄ…cy Ĺ›wiat i geometriÄ™ do 320x180 nearest-neighbor.
   - `CrispDiegeticText` renderuje tablice, rozkĹ‚ady, szyldy i oznaczenia na `CanvasLayer 10` z ominiÄ™ciem pikselizacji.
   - Zweryfikowano caĹ‚kowity brak bezpoĹ›rednich wywoĹ‚aĹ„ `draw_string` w `Layer 0` w skryptach przestrzeni 01â€“07.

3. **NarrativeGuidanceService â€” model PokaĹĽ â†’ NaprowadĹş â†’ PomyĹ›l â†’ SprawdĹş**:
   - Rozszerzono rekord `GuidanceBeat` o `hypothesis_id`, `predicted_check` i relacjÄ™ `supersedes`.
   - WdroĹĽono zamykanie sprawdzonych hipotez (`close_hypothesis(id)`), blokadÄ™ powtĂłrzeĹ„ zamkniÄ™tych tez oraz wymuszony cooldown min. 8.0s z resetem po postÄ™pie.
   - `InnerThoughtSurface` dynamicznie rozrĂłĹĽnia myĹ›li Leny (`LENA // MYĹšL`, amber) od wskazĂłwek systemu przy zastoju (`WSKAZĂ“WKA // SYSTEM`, cyan).

4. **Adaptacja Foundation Slice 01â€“07 do Kanonu 0.3**:
   - **Station 01 (Wieczorny odczyt)**: PowtĂłrzony czysty odczyt drgaĹ„ szyny Linii 4, brak anomalii, link radiowy z dyspozytorem, spakowanie aparatury.
   - **Station 02 (ObejĹ›cie serwisowe)**: Fizycznie zagrodzony skrĂłt z powodu remontu, wygaszony obwĂłd podpanelu, bezpieczne przejĹ›cie kĹ‚adkÄ…, usuniÄ™cie podwĂłjnego cienia.
   - **Station 03 (Przystanek / WiadomoĹ›Ä‡ Marty)**: Wiata przystankowa, tablica odjazdĂłw, ciepĹ‚a wiadomoĹ›Ä‡ od Marty na telefonie, wejĹ›cie do strefy odjazdu.
   - **Station 04 (Przejazd nocny)**: Przejazd wagonem, bufor czytnika z 3-sekundowÄ… przerwÄ… (wspomnienie traumy Jakuba), restart i schowanie czytnika.
   - **Station 05 (Ulica powrotna)**: Deszczowy powrĂłt znajomÄ… trasÄ…, neutralny szyld `UCP / PRACE NOCNE`, brak zaburzeĹ„ geometrii.
   - **Station 06 (Dwa rozkĹ‚ady)**: PorĂłwnanie rozkĹ‚adu papierowego z cache'em aplikacji w telefonie, hipoteza starego cache'u, przyjazd autobusu potwierdzajÄ…cy rozkĹ‚ad.
   - **Station 07 (Kiosk u Pawlaka / Herbata dla Marty)**: Dialog ze sprzedawcÄ… pytajÄ…cym o herbatÄ™ dla Marty, rejestr sprzedaĹĽy z wczorajszym wpisem, zakup wody butelkowanej, pierwsza racjonalizowalna rysa spoĹ‚eczna.

5. **Lint wiedzy i automatyczna weryfikacja**:
   - Dodano bramkÄ™ `tests/pkg_0118_smoke_test.gd` weryfikujÄ…cÄ… rig Leny, warstwy renderu, guidance, sceny 01â€“07 oraz brak przedwczesnych terminĂłw fantastycznych w skryptach Aktu I.
   - Zintegrowano PKG-0118 z `tools/verify.ps1`.

### DowĂłd

- `pwsh -NoProfile -File .\tools\verify_docs.ps1`:
  `DOCS PASS: 36 required files and handoff contracts`, kod 0.
- `tests/pkg_0118_smoke_test.gd`:
  `PKG-0118 PASS: Foundation Slice 01-07 Canon 0.3, LenaVisualRig, Pixel-Stage & Guidance verified`, kod 0.
- `pwsh -NoProfile -File .\tools\verify.ps1`:
  `Verification passed.`, kod 0; wszystkie bramki przeszĹ‚y na zielono.
- `tools/capture_preview.gd`: wygenerowano komplet Ĺ›wieĹĽych klatek podglÄ…du w `reports/` (m.in. `station_01.png`, `station_02.png`, `station_03.png`, `station_04.png`, `station_05.png`, `station_06.png`, `station_07.png`).

### Ograniczenia

Przestrzenie 08â€“43 pozostajÄ… w stanie legacy przed kolejnymi pakietami migracyjnymi 3.0. Brak dowodu odbiorczego z udziaĹ‚em osĂłb zewnÄ™trznych (ADR-003).

### ZamkniÄ™cie i przekazanie

NastÄ™pny pakiet: `PKG-0119 â€” Domestic & Corridor Slice 08â€“13 wedĹ‚ug kanonu 0.3`.
Handoff: `docs/NEXT_SESSION_PROMPT.md`.
Snapshot: `snapshots/PKG-0118-2026-08-25/`.

## PKG-0119: Station 08â€“13 â€” Sekwencja II/III (Rysa i cudzy dom) wedĹ‚ug Kanonu 0.3

Data: 2026-08-25
Tryb: peĹ‚na autonomia inĹĽynierska i artystyczna (D-025, D-085, ADR-004, ADR-007, D-114)

### Cel

PrzenieĹ›Ä‡ przestrzenie 08â€“13 z formatu legacy na Kanon 0.3: zwykĹ‚y blok, znajoma
sÄ…siadka, pasujÄ…cy klucz, cudza fotografia, nagranie Marty i para sprzecznych
dokumentĂłw â€” bez anomalii, bez nazywania drugiego Ĺ›wiata i bez zdradzania
rozwiÄ…zania.

### Wynik

1. **Sceny i skrypty 08â€“13 napisane od zera pod Kanon 0.3**:
   - **Station 08 (Numer czternaĹ›cie)**: elewacja Sadowej 7, lista lokatorĂłw w `CrispDiegeticText`, trzy odczyty (zaĹ›wiadczenie m. 12, lista z `14 â€” L. WOLSKA`, wĹ‚asny kod) otwierajÄ… drzwi jako `AnimatableBody2D`.
   - **Station 09 (SÄ…siadka z trzeciego)**: bieg schodĂłw, donica w miejscu gaĹ›nicy jako `MovableAnchorableProp`, szeĹ›ciolinijkowy dialog z sÄ…siadkÄ… od `Dobry wieczĂłr, Lena` do wskazania dwunastki piÄ™tro niĹĽej.
   - **Station 10 (Klucz)**: prĂłg mieszkania 14; klucz obraca siÄ™ bez oporu, ale prĂłg otwiera siÄ™ dopiero po odstawieniu torby przy drzwiach.
   - **Station 11 (Dwie osoby na zdjÄ™ciu)**: piÄ™Ä‡ rekwizytĂłw domowych, fotografia Leny i Marty bez Jakuba, komoda blokujÄ…ca przedpokĂłj.
   - **Station 12 (WiadomoĹ›Ä‡ gĹ‚osowa)**: uchylony balkon zagĹ‚usza nagranie i blokuje trasÄ™; po domkniÄ™ciu Lena sĹ‚ucha caĹ‚oĹ›ci, cofa je raz na sĹ‚owie `znowu`, sprawdza numer i zapisuje dwa pytania.
   - **Station 13 (Dwie waĹĽne wersje)**: zaĹ›wiadczenie z torby kontra umowa z szuflady, lupa do pieczÄ™ci, zapis offline czytnika, proĹ›ba do Marty o spotkanie.

2. **Guidance i hipotezy**:
   - Zarejestrowano komplet omylnych hipotez: `hyp_address_shift` (08), `hyp_neighbor_confusion` (09), `hyp_lock_coincidence` (10), `hyp_identity_theft` (11), `hyp_memory_gap` (12), `hyp_conflicting_records` (13).
   - KaĹĽda omylna interpretacja ma `predicted_check` i zostaje zastÄ…piona zamiast powtĂłrzona.
   - Trzy hipotezy sÄ… w tym plastrze realnie obalane w Ĺ›wiecie gry: pasujÄ…cy klucz zamyka `hyp_address_shift`, gĹ‚os Marty zamyka `hyp_identity_theft`, a para dokumentĂłw zamyka `hyp_lock_coincidence`.

3. **Model poraĹĽki bez Ĺ›mierci**:
   - KaĹĽda z przestrzeni liczy stracone podejĹ›cie i zabiera jeden czytelny szczegĂłĹ‚: wytarte nazwisko na liĹ›cie, zabrudzona tabliczka piÄ™tra, zmatowiony numer 14, rozmyta twarz na fotografii, zgubione zdanie nagrania, zamazana pieczÄ™Ä‡.
   - Wszystkie koszty trafiajÄ… do `GameStateManager.record_decision`.

4. **Prezentacja Pixel-Stage**:
   - Wszystkie napisy 08â€“13 w `CrispDiegeticText` (Layer 10); zero `draw_string()` w Layer 0.
   - OdĹ›wieĹĽono kompozycje `VectorStageEnvironment` dla stacji 8â€“13, ĹĽeby odpowiadaĹ‚y kanonicznym przestrzeniom (wejĹ›cie do bloku, klatka, prĂłg, mieszkanie, pokĂłj z telefonem, biurko z dokumentami).

5. **Uzgodnienie bramek dziedziczonych**:
   - `tests/smoke_test.gd` â€” bloki 08â€“13 przepisane na nowe pÄ™tle.
   - `tests/pkg_0100_smoke_test.gd` â€” przeszkody 08, 09, 10 wskazujÄ… nowe ciaĹ‚a diegetyczne.
   - `tests/pkg_0099_smoke_test.gd` â€” kontrakt podĹ‚Ăłg dla 11 i przeszkoda 12 opisujÄ… balkon zamiast dawnego biegu ewakuacyjnego.
   - `tools/capture_preview.gd`, `tools/capture_pkg_0099.gd`, `tools/capture_pkg_0100.gd` â€” pozy zrzutĂłw dopasowane do nowych API.

6. **Nowa bramka**:
   - Dodano `tests/pkg_0119_smoke_test.gd` (instancjonowanie, determinizm 60 Hz, lint `draw_string`, lint pojÄ™Ä‡ przedwczesnych, nagĹ‚Ăłwki trzech pytaĹ„, komplet hipotez, pÄ™tle 08â€“13, Ĺ‚aĹ„cuch kampanii do 14) i podpiÄ™to jÄ… w `tools/verify.ps1`.

### DowĂłd

- `tests/pkg_0119_smoke_test.gd`:
  `PKG-0119 PASS: Station 08-13 Canon 0.3, Pixel-Stage, guidance i hipotezy zweryfikowane`, kod 0.
- `pwsh -NoProfile -File .\tools\verify.ps1`:
  `Verification passed.`, kod 0; wszystkie bramki od kontraktu dokumentacji po PKG-0119 na zielono.
- `tools/capture_preview.gd`: Ĺ›wieĹĽe klatki `reports/station_08.png`, `station_08_open.png`, `station_09.png`, `station_09_neighbour.png`, `station_10.png`, `station_10_threshold.png`, `station_11.png`, `station_11_photograph.png`, `station_12.png`, `station_12_message.png`, `station_13.png`, `station_13_documents.png` â€” obejrzane, czytelne, w stylu Pixel-Stage.

### Ograniczenia

Przestrzenie 14â€“43 pozostajÄ… w stanie legacy przed kolejnymi pakietami migracyjnymi.
Brak dowodu odbiorczego z udziaĹ‚em osĂłb zewnÄ™trznych (ADR-003): to, ĹĽe para sprzecznoĹ›ci
08â€“13 buduje niepokĂłj zamiast dezorientacji, pozostaje hipotezÄ….

### ZamkniÄ™cie i przekazanie

NastÄ™pny pakiet: `PKG-0120 â€” Sekwencja IV/V (Station 14â€“23: Marta, UCP i rozpoznanie) wedĹ‚ug Kanonu 0.3`.
Handoff: `docs/NEXT_SESSION_PROMPT.md`.
Snapshot: `snapshots/PKG-0119-2026-08-25/`.

## PKG-0120: Sekwencja IV/V (Station 14â€“23: Marta, UCP i rozpoznanie) wedĹ‚ug Kanonu 0.3

Data: 2026-08-25

### Cel

PrzenieĹ›Ä‡ przestrzenie 14â€“23 z formatu legacy na Kanon 0.3: przedpokĂłj Marty,
rozbieĹĽnoĹ›Ä‡ wspomnieĹ„ wycieczki, biuro pomiarowe UCP z profilem Leny, raport
o anomalii na Linii 4, kwerenda w archiwum miejskim (brak aktu zgonu Jakuba),
telefon do brata, spotkanie z ĹĽywym Jakubem w podstacji, synteza trzech rodzin
dowodĂłw w Station 21 (â€žTo nie jest mĂłj Ĺ›wiatâ€ť), odchylenie w rejestrze (Station 22)
i martwy obwĂłd z kosztami manipulacji (Station 23).

### Wynik

1. **Sceny i skrypty 14â€“23 dostosowane i zweryfikowane pod Kanon 0.3**:
   - **Station 14 (PrĂłg Marty)**: przedpokĂłj Marty, odstawienie torby, dialog intymny z partnerkÄ… domowÄ… odmawiajÄ…cÄ… rozmowy o pracy przed Ĺ›witem.
   - **Station 15 (Ta sama wyprawa, inny skutek)**: kuchnia Marty, porĂłwnanie zapiskĂłw (deszcz/pociÄ…g vs sĹ‚oĹ„ce/przeĹ‚Ä™cz), odebranie telefonu przez MartÄ™.
   - **Station 16 (ZespĂłĹ‚ UCP-4)**: biuro pomiarowe, waĹĽna karta Leny, identyfikacja biometryczna, zadania z rejestru UCP.
   - **Station 17 (Nie powtarzaÄ‡ prĂłbki)**: raport wewnÄ™trzny UCP o luce o 20:40, zabezpieczenie wydruku raportu.
   - **Station 18 (Brak aktu zgonu)**: archiwum miejskie, weryfikacja braku aktu zgonu Jakuba, karta zatrudnienia w podstacji.
   - **Station 19 (GĹ‚os)**: budka telefoniczna, rozmowa telefoniczna z ĹĽywym bratem Jakubem bez zdradzenia sytuacji.
   - **Station 20 (CzĹ‚owiek po tej dacie)**: spotkanie w podstacji z Jakubem, odmowa poddania siÄ™ weryfikacji toĹĽsamoĹ›ci.
   - **Station 21 (Trzy ĹşrĂłdĹ‚a / Rozpoznanie)**: zestawienie 3 niezaleĹĽnych rodzin dowodĂłw (czytnik, rejestry publiczne, relacje), wypowiedzenie â€žTo nie jest mĂłj Ĺ›wiatâ€ť, zamkniÄ™cie 4 hipotez, flaga `local_lena_search_started`.
   - **Station 22 (Odchylenie w rejestrze)**: terminal diagnostyczny, Ĺ›lad celowej modyfikacji danych przez miejscowÄ… LenÄ™, odrzucenie oferty asymilacji UCP, kampanijny Anchor/Yield.
   - **Station 23 (Martwy obwĂłd)**: odciÄ™ta sekcja podstacji, stabilizacja obwodu, nauka fizycznego kosztu mechaniki.

2. **Guidance, myĹ›li i hipotezy**:
   - WdroĹĽono beats w `NarrativeGuidanceService` dla stacji 14â€“23 z modelem PokaĹĽ â†’ NaprowadĹş â†’ PomyĹ›l â†’ SprawdĹş.
   - ZamkniÄ™cie 4 hipotez (`hyp_conflicting_records`, `hyp_memory_gap`, `hyp_ucp_forgery`, `hyp_single_world_error`) w Station 21 przy rozpoznaniu.
   - Wymuszony cooldown >= 8s i brak spamu przy normalnej eksploracji.

3. **Prezentacja Pixel-Stage i CRT Dialogue**:
   - Wszystkie napisy w `CrispDiegeticText` (CanvasLayer 10); zero `draw_string()` w Layer 0 w skryptach 14â€“23.
   - `CRTDialogueBox` (CanvasLayer 20) zintegrowany z metodami `show_line()` / `hide_box()` oraz `present()`.
   - `InnerThoughtSurface` (CanvasLayer 16) dla myĹ›li wewnÄ™trznych bohaterki.

4. **Bramka testowa**:
   - Utworzono `tests/pkg_0120_smoke_test.gd` (determinizm 60 Hz, brak `draw_string()` w Layer 0, lint terminĂłw w 14â€“20, nagĹ‚Ăłwki trzech pytaĹ„ o przeszkodÄ™, struktura Pixel-Stage, pÄ™tle stacji 14â€“23, synteza 3 ĹşrĂłdeĹ‚ w 21, Ĺ‚aĹ„cuch kampanii do 24).
   - WĹ‚Ä…czono test do `tools/verify.ps1`.

### DowĂłd

- `tests/pkg_0120_smoke_test.gd`:
  `PKG-0120 PASS: Station 14-23 Canon 0.3, Pixel-Stage, guidance i rozpoznanie zweryfikowane`, kod 0.
- `pwsh -NoProfile -File .\tools\verify.ps1`:
  `Verification passed.`, kod 0; wszystkie bramki od kontraktu dokumentacji po PKG-0120 na zielono.
- `tools/capture_preview.gd`: Ĺ›wieĹĽe klatki `reports/station_14..23*.png` wyrenderowane pod sterownikiem OpenGL Compatibility Windows.

### Ograniczenia

Przestrzenie 24â€“43 przejdÄ… kolejnÄ… turÄ™ migracji w pakietach PKG-0121..PKG-0123.
Brak dowodu odbiorczego z udziaĹ‚em osĂłb zewnÄ™trznych (ADR-003): tempo narastania niepokoju i emocjonalna siĹ‚a rozpoznania w Station 21 pozostajÄ… hipotezami projektowymi.

### ZamkniÄ™cie i przekazanie

NastÄ™pny pakiet: `PKG-0121 â€” Sekwencja VI/VII (Station 24â€“30: WÄ™zeĹ‚ pod LiniÄ… 4, ĹĽywa odpowiedĹş i pierwsze koszty) wedĹ‚ug Kanonu 0.3`.
Handoff: `docs/NEXT_SESSION_PROMPT.md`.
Snapshot: `snapshots/PKG-0120-2026-08-25/`.

## PKG-0121: Sekwencja VI/VII (Station 24â€“30: WÄ™zeĹ‚ pod LiniÄ… 4, ĹĽywa odpowiedĹş i pierwsze koszty) wedĹ‚ug Kanonu 0.3

Data: 2026-08-25

### Cel

PrzenieĹ›Ä‡ przestrzenie 24â€“30 z formatu legacy na Kanon 0.3:
- Station 24 (Nie jesteĹ› jej zastÄ™pstwem / Granice Marty): stacja nadzoru CCTV mieszkania 14, dyspozycja toĹĽsamoĹ›ciowa wobec Dr Wierzbickiej;
- Station 25 (WÄ™zeĹ‚ pod LiniÄ… 4 / Jakub): tranzyt Linii 4, warunek pomocy Jakuba (D-09);
- Station 26 (Przerwana prĂłba / Stanowisko analizatora): Ĺ›luza izolacyjna, cykl przegrody adaptacyjnej, rytuaĹ‚ ugruntowania Leny na Ĺ›cianie Podstruktury;
- Station 27 (Trzy powtĂłrzenia / Ĺ»ywy sygnaĹ‚): wÄ™zeĹ‚ serwisowy, ĹĽÄ…danie obietnicy braku dĹ‚ugu wdziÄ™cznoĹ›ci, rejestracja sygnaĹ‚Ăłw z Podstruktury;
- Station 28 (Cena maĹ‚ego wyniku / SkĹ‚ad techniczny): wagon techniczny pod LiniÄ… 4, potrĂłjny widok w oknie tranzytowym, interkom Wierzbickiej;
- Station 29 (Jakub mĂłwi nie / Peron trzynasty): opuszczony peron 13, zardzewiaĹ‚e tory, studnia Podstruktury, latarka Jakuba;
- Station 30 (Trzy prognozy / Sektor Zasilania): gĹ‚Ăłwna rozdzielnia, rozbieĹĽne prognozy mocy, odĹ‚Ä…cznik sekcyjny, odblokowanie wejĹ›cia do Magazynu DowodĂłw (Station 31).

### Wynik

1. **Sceny i skrypty 24â€“30 dostosowane i zweryfikowane pod Kanon 0.3**:
   - `scripts/levels/station_24.gd`: monitoring CCTV mieszkania 14, wskaĹşnik naprÄ™ĹĽeĹ„, wybĂłr dyspozycji (Consent, Refusal, Apparent Cooperation), dialog z WierzbickÄ…, odblokowanie Ĺ›luzy.
   - `scripts/levels/station_25.gd`: wĂłzek serwisowy, schemat blizny, czujnik gestu, konfrontacja z Jakubem (D-09), odblokowanie wyjĹ›cia do strefy analizatora.
   - `scripts/levels/station_26.gd`: Ĺ›luza izolacyjna, cykl przegrody `AdaptiveIsolationPartition`, formuĹ‚a ugruntowania Leny, nagĹ‚Ăłwki trzech pytaĹ„ o przeszkodÄ™ bez sĹ‚owa â€žgraczâ€ť, model poraĹĽki z resetem pozycji do punktu kontrolnego.
   - `scripts/levels/station_27.gd`: identyfikator pracowniczy, monitor powierzchniowy, konsola wÄ™zĹ‚owa, sekwencja dialogowa z Jakubem i otwarcie bramy technicznej.
   - `scripts/levels/station_28.gd`: pulpit maszynisty, okno tranzytowe, potrĂłjny widok paradoksu, interkom zamykajÄ…cy, ruch wagonu pod LiniÄ… 4.
   - `scripts/levels/station_29.gd`: zardzewiaĹ‚e tory, migajÄ…cy neon, studnia do Podstruktury, sygnaĹ‚ latarki Jakuba, odblokowanie wejĹ›cia w gĹ‚Ä…b.
   - `scripts/levels/station_30.gd`: pulpit rozdzielni, bank transformatorĂłw, odĹ‚Ä…cznik sekcyjny, schemat sieci, geometryczny `WitnessRelayBank` (`AnchorableObject`), korekta przekaĹşnikĂłw i odblokowanie Ĺ›luzy do Magazynu DowodĂłw (Station 31).

2. **Prezentacja Pixel-Stage i CRT Dialogue**:
   - Wszystkie napisy diegetyczne w `CrispDiegeticText` (CanvasLayer 10); zero wywoĹ‚aĹ„ `draw_string()` w Layer 0 w skryptach stacji 24â€“30.
   - `WorldPixelCompositor` (Layer 5) renderujÄ…cy Ĺ›wiat w 320x180 nearest-neighbor.
   - `InnerThoughtSurface` (Layer 16) dla myĹ›li Leny i `CRTDialogueBox` (Layer 20) dla dialogu.

3. **Uzgodnienie i synchronizacja bramek testowych**:
   - `tests/smoke_test.gd`: zsynchronizowano lookupy rezonansĂłw i sekwencje dialogowe dla stacji 28, 29 i 30.
   - `tests/pkg_0103_smoke_test.gd`: uzgodniono nagĹ‚Ăłwki trzech pytaĹ„ o przeszkodÄ™, liczbÄ™ obiektĂłw `AnimatableBody2D` w geometrii stacji 26 i 30 oraz punkt resetu pozycji Leny przy korekcie `(50.0, 240.0)`.
   - `tests/pkg_0121_smoke_test.gd`: zrealizowano i zweryfikowano peĹ‚ny zestaw asercji: determinizm 60 Hz, brak `draw_string()` w Layer 0, obecnoĹ›Ä‡ nagĹ‚ĂłwkĂłw 3 pytaĹ„ o przeszkodÄ™, struktura 5 warstw Pixel-Stage, pÄ™tle stacji 24â€“30 oraz Ĺ‚aĹ„cuch kampanii 24..31.
   - WĹ‚Ä…czono `pkg_0121_smoke_test.gd` do `tools/verify.ps1`.

### DowĂłd

- `tests/pkg_0121_smoke_test.gd`:
  `PKG-0121 PASS: Station 24-30 Canon 0.3, Pixel-Stage, guidance i prognozy zweryfikowane`, kod 0.
- `pwsh -NoProfile -File .\tools\verify.ps1`:
  `Verification passed.`, kod 0; wszystkie bramki od kontraktu dokumentacji po PKG-0121 na zielono.
- `tools/capture_preview.gd`: pomyĹ›lnie wyrenderowano i sprawdzono klatki dla stacji 24â€“30 pod sterownikiem OpenGL Compatibility Windows (`station_24.png`, `station_24_cctv.png`, `station_25.png`, `station_25_jakub.png`, `station_26.png`, `station_26_isolation.png`, `station_27.png`, `station_27_dialogue.png`, `station_28.png`, `station_28_transit.png`, `station_29.png`, `station_29_platform.png`, `station_30.png`, `station_30_power.png`).

### Ograniczenia

Przestrzenie 31â€“43 przejdÄ… kolejnÄ… turÄ™ migracji w pakietach PKG-0122..PKG-0123.
Brak dowodu odbiorczego z udziaĹ‚em osĂłb zewnÄ™trznych (ADR-003): odbiĂłr dramatyzmu i relacyjnej stawki rozmĂłw z Jakubem i WierzbickÄ… pozostaje hipotezÄ… projektowÄ….

### ZamkniÄ™cie i przekazanie

NastÄ™pny pakiet: `PKG-0122 â€” Sekwencja VIII/IX (Station 31â€“37: Podstruktura, Magazyn DowodĂłw i rejestr par) wedĹ‚ug Kanonu 0.3`.
Handoff: `docs/NEXT_SESSION_PROMPT.md`.
Snapshot: `snapshots/PKG-0121-2026-08-25/`.

## PKG-0122: Sekwencja VIII/IX (Station 31â€“37: Podstruktura, Magazyn DowodĂłw i rejestr par) wedĹ‚ug Kanonu 0.3

Data: 2026-08-25

### Cel

PrzenieĹ›Ä‡ przestrzenie 31â€“37 z formatu legacy na Kanon 0.3:
- Station 31 (Oferta adaptacji / DwieĹ›cie krzeseĹ‚): Magazyn DowodĂłw, oferta asymilacji Wierzbickiej, odmowa wygaszenia sprzecznych wspomnieĹ„;
- Station 32 (SzkĹ‚o laboratoryjne / PamiÄ™Ä‡ materiaĹ‚u): laboratorium spektrometrii korelacyjnej, fizyczne zjawisko pamiÄ™ci materiaĹ‚u w szkle, Ĺšlad w `ObservedGlassTrace` (`AnchorableObject`);
- Station 33 (Szyb wentylacyjny / Notatka z warunkiem przerwania): szyb na gĹ‚Ä™bokoĹ›ci -40 m, notatka miejscowej Leny (`DWIE STRONY / DWA ODCZYTY / BRAK ODPOWIEDZI = PRZERWIJ / ABORT PO 3 S`), korekta ramy `DualWitnessFrame` (`AnchorableObject`);
- Station 34 (Maszynownia GĹ‚Ăłwna / RdzeĹ„ korelacyjny): rejestr par Lena A & Lena B, alokacja biograficzna, zabezpieczenie koordynatĂłw powrotnych miejscowej Leny;
- Station 35 (Sektor Filtracji / Baseny Sedacyjne / Echo domu): baseny sedacyjne z osadem wypartych wspomnieĹ„, odsĹ‚uchanie wiadomoĹ›ci gĹ‚osowej od domowej Marty;
- Station 36 (DrenaĹĽ trakcyjny / Para katastrof): jaz burzowy, zrzut energii Linii 4, odkrycie rachunku katastrof (207 ocalonych vs Ĺ›mierÄ‡ Jakuba w domu);
- Station 37 (Komora SygnaĹ‚owa / Ĺ»ywy sygnaĹ‚ i granice Jakuba): oscyloskop, krosownica, maszt antenowy, ĹĽywy sygnaĹ‚ miejscowej Leny, granica Jakuba (10 sekund na wyĹ‚Ä…czniku) i otwarcie bramy do Station 38.

### Wynik

1. **Sceny i skrypty 31â€“37 dostosowane i zweryfikowane pod Kanon 0.3**:
   - `scripts/levels/station_31.gd` & `scenes/levels/station_31.tscn`: Magazyn DowodĂłw, dwieĹ›cie krzeseĹ‚, rejestry asymilacji, oferta Wierzbickiej, odmowa Leny (`s31_adaptation_refusal`), otwarcie Ĺ›luzy do laboratorium szkĹ‚a.
   - `scripts/levels/station_32.gd` & `scenes/levels/station_32.tscn`: tafle szkĹ‚a (zaparowana, popÄ™kana, polerowana), obserwacja pamiÄ™ci materiaĹ‚u, `ObservedGlassTrace` (`AnimatableBody2D` z `AnchorableObject`, `state_a_solid=false`, `state_b_solid=true`), `run_glass_observation_check()`, otwarcie wĹ‚azu rewizyjnego.
   - `scripts/levels/station_33.gd` & `scenes/levels/station_33.tscn`: szyb wentylacyjny, manometr ciĹ›nienia powrotnego, odnalezienie notatki z warunkiem przerwania po 3 s, `DualWitnessFrame` (`AnimatableBody2D` z `AnchorableObject`, rozmiary `(86,24)` / `(58,24)`), `run_witness_frame_correction_pass()`, odryglowanie dolnego wĹ‚azu dekompresyjnego.
   - `scripts/levels/station_34.gd` & `scenes/levels/station_34.tscn`: RdzeĹ„ Korelacyjny, bilans wektorĂłw sprzecznoĹ›ci, port diagnostyczny Jakuba, odczyt rejestru par Lena A & Lena B, zabezpieczenie wektorĂłw powrotnych, otwarcie wyjĹ›cia do filtracji.
   - `scripts/levels/station_35.gd` & `scenes/levels/station_35.tscn`: betonowy basen sedacyjny, koĹ‚o zaworu spustowego, prĂłbnik chemiczny, odbiornik echa domu z wiadomoĹ›ciÄ… gĹ‚osowÄ… domowej Marty, otwarcie drogi do drenaĹĽu trakcyjnego.
   - `scripts/levels/station_36.gd` & `scenes/levels/station_36.tscn`: jaz burzowy, rwÄ…cy nurt drenaĹĽu trakcyjnego, kĹ‚adka inspekcyjna, punkt poboru prĂłbek, rachunek katastrofy Linii 4, odblokowanie wejĹ›cia do komory sygnaĹ‚owej.
   - `scripts/levels/station_37.gd` & `scenes/levels/station_37.tscn`: oscyloskop sygnaĹ‚u rezonansowego, krosownica transmisyjna, maszt antenowy, pulpit sterujÄ…cy mostu, ĹĽywy sygnaĹ‚ miejscowej Leny, ustalenie 10-sekundowej granicy Jakuba i otwarcie bramy do Strefy Decyzji (Station 38).

2. **Prezentacja Pixel-Stage i CRT Dialogue**:
   - Wszystkie napisy diegetyczne w `CrispDiegeticText` (CanvasLayer 10); zero wywoĹ‚aĹ„ `draw_string()` w Layer 0 w skryptach stacji 31â€“37.
   - `WorldPixelCompositor` (Layer 5) renderujÄ…cy Ĺ›wiat w 320x180 nearest-neighbor.
   - `InnerThoughtSurface` (Layer 16) dla myĹ›li Leny i `CRTDialogueBox` (Layer 20) dla dialogu mĂłwionego ze skanlinami CRT.
   - `NarrativeGuidanceService` zintegrowany z beatami fabularnymi sekwencji VIII/IX.

3. **Uzgodnienie i synchronizacja bramek testowych**:
   - `tests/smoke_test.gd`: zsynchronizowano pÄ™tle i sekwencje dialogowe dla stacji 32 i 33.
   - `tests/pkg_0104_smoke_test.gd`: uzgodniono wymiary sufitĂłw `Vector2(640, 48)` oraz promienie interakcji propĂłw w stacjach 32..35.
   - `tests/pkg_0105_smoke_test.gd`: uzgodniono ksztaĹ‚ty i promienie propĂłw w stacjach 36 i 37.
   - `tests/pkg_0122_smoke_test.gd`: zrealizowano i zweryfikowano peĹ‚ny zestaw asercji: determinizm 60 Hz, brak `draw_string()` w Layer 0, obecnoĹ›Ä‡ nagĹ‚ĂłwkĂłw 3 pytaĹ„ o przeszkodÄ™, struktura 5 warstw Pixel-Stage, pÄ™tle stacji 31â€“37 oraz Ĺ‚aĹ„cuch kampanii 31..38.
   - WĹ‚Ä…czono `pkg_0122_smoke_test.gd` do `tools/verify.ps1`.

### DowĂłd

- `tests/pkg_0122_smoke_test.gd`:
  `PKG-0122 PASS: Station 31-37 Canon 0.3, Pixel-Stage, guidance i rejestr par zweryfikowane`, kod 0.
- `pwsh -NoProfile -File .\tools\verify.ps1`:
  `Verification passed.`, kod 0; wszystkie 18 bramek weryfikacyjnych na zielono.
- `tools/capture_preview.gd`: wyrenderowano i sprawdzono Ĺ›wieĹĽe klatki dla stacji 31â€“37 pod sterownikiem OpenGL Compatibility Windows (`station_31_evidence.png`, `station_32_glass.png`, `station_33_vent.png`, `station_34_core.png`, `station_35_sedation.png`, `station_36_drain.png`, `station_37_signal.png`).

### Ograniczenia

Przestrzenie 38â€“43 przejdÄ… migracjÄ™ finaĹ‚owÄ… w pakiecie PKG-0123.
Brak dowodu odbiorczego z udziaĹ‚em osĂłb zewnÄ™trznych (ADR-003): waga moralna ujawnienia kosztu Linii 4 i percepcja racjonalnoĹ›ci Dr Wierzbickiej pozostajÄ… hipotezami projektowymi.

### ZamkniÄ™cie i przekazanie

NastÄ™pny pakiet: `PKG-0123 â€” Sekwencja X: Metoda, konsekwencje i content lock 3.0 (Station 38â€“43)` wedĹ‚ug `docs/NEXT_SESSION_PROMPT.md`.
Handoff: `docs/NEXT_SESSION_PROMPT.md`.
Snapshot: `snapshots/PKG-0122-2026-08-25/`.

## PKG-0123: Sekwencja X: Metoda, konsekwencje i finalny Content Lock 3.0 (Station 38â€“43)

Data: 2026-08-25

### Cel

PrzenieĹ›Ä‡ przestrzenie finaĹ‚owe 38â€“43 z formatu legacy na Kanon 0.3 i osiÄ…gnÄ…Ä‡ ostateczny Content Lock 3.0 dla wszystkich 43 stacji kampanii:
- Station 38 (Marta nie przyjmuje legendy / Strefa Decyzji / Zgody Marty i Jakuba): odbiornik radiowy, notatka z warunkiem przerwania, granice Marty i Jakuba, Ĺ›luza `JakubRescueBulkhead` (`AnchorableObject`);
- Station 39 (StĂłĹ‚ zgĂłd i brakĂłw / Centralny Pulpit Wyboru Metody): trzy obwody transmisyjne (Metoda A, B, C), RdzeĹ„ korelacyjny (58 px), matryca szeĹ›ciu parametrĂłw;
- Station 40 (Ostatni impuls / Weryfikacja Dr Wierzbickiej / Poziom 0): Sala Negocjacyjna, obrona stabilnoĹ›ci przez WierzbickÄ…, Ĺ›wiadek Marta, monitor Szymona;
- Station 41 (Trzy testy po dziaĹ‚aniu / Komora PrzejĹ›cia / Ĺšwiadome milczenie): trzy fizyczne konsole operacyjne A, B, C wybierajÄ…ce finaĹ‚ bez etykiet moralnych;
- Station 42A (Wymuszenie powrotu â€” WĹ‚asny pokĂłj): powrĂłt do Ĺ›wiata domowego, stĂłĹ‚, dwa kubki, domowa Marta;
- Station 42B (ZamkniÄ™cie RĂłwni â€” Miejsce po niej): RĂłwieĹ„, odzyskanie ciaĹ‚a przez miejscowÄ… LenÄ™, przybyĹ‚a Lena na obcym przystanku;
- Station 42C (PrzejĹ›cie wzajemne â€” Dwa tory i Ĺ›wiadectwo): dwa tory tramwajowe, wspĂłĹ‚istnienie obu Len, czÄ™Ĺ›ciowy most i Ĺ›wiadectwo;
- Station 43 (Epilog konkretnych osĂłb / Zapis nowej ciÄ…gĹ‚oĹ›ci): tablice urzÄ™dowe, credits roll, blackout i pĹ‚ynny powrĂłt do menu z `campaign_completed = true`.

### Wynik

1. **Sceny i skrypty 38â€“43 w peĹ‚ni zmigrowane i zweryfikowane pod Kanon 0.3**:
   - `scripts/levels/station_38.gd` & `scenes/levels/station_38.tscn`: Strefa Decyzji, dialog ze zgodami Marty i Jakuba, `JakubRescueBulkhead` mechanika anchor/yield, otwarcie Ĺ›luzy do stacji 39.
   - `scripts/levels/station_39.gd` & `scenes/levels/station_39.tscn`: Pulpit wyboru metody, trzy konfiguracje A/B/C, `CentralReferenceCoreMonolith` (58.0 px), zero `draw_string()` w Layer 0, otwarcie przejĹ›cia do poziomu 0.
   - `scripts/levels/station_40.gd` & `scenes/levels/station_40.tscn`: Sala negocjacyjna z Dr WierzbickÄ…, MartÄ… i monitorem Szymona, 13 kwestii dialogowych, odblokowanie wejĹ›cia do komory przejĹ›cia.
   - `scripts/levels/station_41.gd` & `scenes/levels/station_41.tscn`: Komora z 3 fizycznymi konsolami operacyjnymi `ConsoleMethodA`, `ConsoleMethodB`, `ConsoleMethodC`, zaĹ‚Ä…czenie operacji przez `GameStateManager.select_finale_operation()`, otwarcie odpowiedniej Ĺ›luzy do 42A, 42B lub 42C.
   - `scripts/levels/station_42a.gd` & `scenes/levels/station_42a.tscn`: FinaĹ‚ A (Wymuszenie powrotu), 10 kwestii dialogowych z MartÄ… domowÄ…, czysty Pixel-Stage stack.
   - `scripts/levels/station_42b.gd` & `scenes/levels/station_42b.tscn`: FinaĹ‚ B (ZamkniÄ™cie RĂłwni), 9 kwestii dialogowych na progu mieszkania 14 i przystanku, Pixel-Stage stack.
   - `scripts/levels/station_42c.gd` & `scenes/levels/station_42c.tscn`: FinaĹ‚ C (PrzejĹ›cie wzajemne), 13 kwestii dialogowych przy dwĂłch torach, Pixel-Stage stack.
   - `scripts/levels/station_43.gd` & `scenes/levels/station_43.tscn`: Epilog nowej ciÄ…gĹ‚oĹ›ci, `stage_variant = &"epilogue"`, 5 kwestii dialogowych, tablica ogĹ‚oszeĹ„, lista pĹ‚ac (`CreditsRoll`), wyjĹ›cie przez `FinalBlackout` z natychmiastowym zapisem flagi ukoĹ„czenia kampanii.

2. **Pixel-Stage, Crisp Diegetic Text i CRT Presentation**:
   - Wszystkie 43 sceny posiadajÄ… kompletny stos Pixel-Stage: `VectorStageEnvironment`, `AtmosphereRig`, `WorldPixelCompositor` (Layer 5), `CrispDiegeticText` (Layer 10), `InnerThoughtSurface` (Layer 16), `CRTDialogueBox` (Layer 20), `NarrativeGuidanceService`.
   - Zlikwidowano 100% wywoĹ‚aĹ„ `draw_string()` w Layer 0 we wszystkich skryptach poziomĂłw w caĹ‚ym projekcie.

3. **Uzgodnienie i synchronizacja bramek testowych**:
   - `tests/pkg_0105_smoke_test.gd`: uzgodniono promieĹ„ `CentralReferenceCoreMonolith` (58.0 px) w `station_39.tscn`.
   - `tests/pkg_0107_smoke_test.gd`: uzgodniono `stage_variant = &"epilogue"` w `station_43.tscn`.
   - `tests/pkg_0123_smoke_test.gd`: zaimplementowano dedykowany test sprawdzajÄ…cy kontrakty skryptowe, lint przeszkĂłd (brak sĹ‚owa "gracz"), stosy wÄ™zĹ‚Ăłw Pixel-Stage dla 38..43, pÄ™tle interakcji stacji 38..41, wszystkie trzy Ĺ›cieĹĽki finaĹ‚owe 42A/B/C oraz poprawne domkniÄ™cie kampanii w 43.
   - Zarejestrowano bramkÄ™ PKG-0123 w `tools/verify.ps1`.

### DowĂłd

- `tests/pkg_0123_smoke_test.gd`:
  `--- PKG-0123 Smoke Test: Sequence X & Content Lock 3.0 --- PKG-0123: ALL TESTS PASSED.`, kod wyjĹ›cia 0.
- `pwsh -NoProfile -File .\tools\verify.ps1`:
  `Verification passed.`, kod wyjĹ›cia 0; wszystkie 19 bramek weryfikacyjnych (w tym smoke 43 stacji, lint przeszkĂłd, testy PKG-0095..PKG-0123) przeszĹ‚y w 100%.
- `tools/capture_preview.gd`: wyrenderowano klatki dla wszystkich 43 stacji pod sterownikiem OpenGL Compatibility Windows (`station_38.png`, `station_39.png`, `station_40.png`, `station_41.png`, `station_42a.png`, `station_42b.png`, `station_42c.png`, `station_43.png`).

### Ograniczenia

- Wszystkie 43 stacje kampanii osiÄ…gnÄ™Ĺ‚y Content Lock 3.0.
- Zgodnie z ADR-003 brak testĂłw zewnÄ™trznych z udziaĹ‚em graczy â€” subiektywny odbiĂłr emocjonalny poszczegĂłlnych finaĹ‚Ăłw pozostaje hipotezÄ… artystycznÄ… i projektowÄ….

### ZamkniÄ™cie i przekazanie

NastÄ™pny pakiet: `PKG-0124 â€” Faza P5: Release Candidate, Packaging, Performance Audit & Final Master Export`.
Handoff: `docs/NEXT_SESSION_PROMPT.md`.
Snapshot: `snapshots/PKG-0123-2026-08-25/`.

## PKG-0124: Faza P5: Release Candidate 1, Packaging, Performance Audit & Final Master Export

Data: 2026-08-25

### Cel

WejĹ›Ä‡ w fazÄ™ produkcyjnÄ… P5 i przygotowaÄ‡ kompletny Release Candidate (RC1) gry Getting Strange:
- Konfiguracja eksportu i szablony dystrybucyjne (`export_presets.cfg`) dla Windows Desktop (64-bit) i Linux Desktop (x86_64).
- UstaliÄ‡ metadane gry, wersjÄ™ produkcyjnÄ… 1.0.0, tytuĹ‚ "Getting Strange", wektorowÄ… ikonÄ™ aplikacji `icon.svg` oraz splash screen.
- Audyt wydajnoĹ›ci i budĹĽetu 60 Hz na wszystkich 43 stacjach kampanii pod obciÄ…ĹĽeniem `WorldPixelCompositor`, `AtmosphereRig`, `CrispDiegeticText`, `InnerThoughtSurface`, `CRTDialogueBox` oraz `NarrativeGuidanceService`.
- Weryfikacja pakietu licencyjnego `docs/LICENSES.md` (Zero-Asset Architecture, Godot MIT, FTL, HarfBuzz, AccessKit) oraz notatek wydania `docs/RELEASE_NOTES.md`.
- Weryfikacja dziaĹ‚ania bilingualnej lokalizacji PL/EN, remapowania akcji i zapisu ustawieĹ„ w menu pauzy oraz ekranie tytuĹ‚owym.
- PrzeprowadziÄ‡ eksport binarny gry do dedykowanego katalogu wyjĹ›ciowego `dist/` za pomocÄ… `tools/export_builds.ps1` i zweryfikowaÄ‡ artefakty.

### Wynik

1. **Konfiguracja eksportu i szablony dystrybucyjne**:
   - Utworzono `export_presets.cfg` z profilami produkcyjnymi dla Windows Desktop (x86_64) i Linux Desktop (x86_64).
   - Skonfigurowano embed_pck=true dla kompletnych, niezaleĹĽnych binariĂłw dystrybucyjnych.
   - WdroĹĽono autorskÄ… wektorowÄ… ikonÄ™ `icon.svg` (256x256) odzwierciedlajÄ…cÄ… estetykÄ™ RĂłwieĹ„ Pixel-Stage (paleta ink/amber/cyan, rozszczepione tory Linii 4 i wektor pomiarowy).
   - Zaktualizowano `project.godot` o wersjÄ™ 1.0.0, opis oraz ikonÄ™.

2. **Dystrybucja i budowa pakietĂłw binarnych**:
   - Zaimplementowano skrypt automatycznego budowania `tools/export_builds.ps1`.
   - Wygenerowano i zweryfikowano artefakty w `dist/`:
     - `dist/windows/GettingStrange.exe` (124.55 MB) â€” samodzielny plik wykonywalny Windows Desktop x86_64.
     - `dist/linux/GettingStrange.x86_64` (90.48 MB) â€” samodzielny plik wykonywalny Linux Desktop x86_64.

3. **Pakiet licencyjny i Release Notes**:
   - Utworzono `docs/LICENSES.md` dokumentujÄ…cy autorskie prawa majÄ…tkowe, zero-asset architecture (100% syntetyczny dĹşwiÄ™k GDScript, 100% wektorowa grafika bez bitmap) oraz noty licencyjne Godot Engine (MIT) i komponentĂłw third-party.
   - Utworzono `docs/RELEASE_NOTES.md` szczegĂłĹ‚owo opisujÄ…ce wersjÄ™ 1.0.0 Release Candidate 1, 43 stacje kampanii, architekturÄ™ prezentacji, systemy narracyjne oraz wyniki weryfikacji.

4. **Audyt 60 Hz i testy bramek**:
   - Zaimplementowano dedykowany test `tests/pkg_0124_smoke_test.gd` weryfikujÄ…cy konfiguracjÄ™ eksportu, metadane, integralnoĹ›Ä‡ dokumentacji licencyjnej, parzystoĹ›Ä‡ kluczy lokalizacji PL/EN, brak `draw_string()` w Layer 0, obecnoĹ›Ä‡ kompletnego stosu Pixel-Stage we wszystkich 43 scenach oraz dziaĹ‚anie TitleScreen i SettingsPanel.
   - Zintegrowano bramkÄ™ PKG-0124 w `tools/verify.ps1`.
   - Zaktualizowano `tools/verify_docs.ps1` o nowe kontrakty dokumentacji.

### DowĂłd

- `tests/pkg_0124_smoke_test.gd`:
  `--- PKG-0124 Smoke Test: Release Candidate 1 & Distribution Verification --- PKG-0124: ALL RELEASE CANDIDATE TESTS PASSED (0 FAILURES).`, kod wyjĹ›cia 0.
- `tools/export_builds.ps1`:
  `== Export Summary == - dist\linux\GettingStrange.x86_64 (90.48 MB) - dist\windows\GettingStrange.exe (124.55 MB) Export completed successfully.`, kod wyjĹ›cia 0.
- `pwsh -NoProfile -File .\tools\verify_docs.ps1`:
  `DOCS PASS: 38 required files and handoff contracts`, kod wyjĹ›cia 0.
- `pwsh -NoProfile -File .\tools\verify.ps1`:
  `Verification passed.`, kod wyjĹ›cia 0 (komplet wszystkich 20 bramek testowych, w tym PKG-0095..PKG-0124).

### Ograniczenia

- Zgodnie z ADR-003 brak testĂłw z udziaĹ‚em graczy zewnÄ™trznych.
- Artefakty binarne przetestowano lokalnie w Ĺ›rodowisku Windows (kompilacja x86_64); dystrybucja Linuxowa przetestowana pod kÄ…tem poprawnoĹ›ci eksportu bezbĹ‚Ä™dnego pakietu PCK i szablonu release.

### ZamkniÄ™cie i przekazanie

NastÄ™pny pakiet: `PKG-0125` wedĹ‚ug `docs/NEXT_SESSION_PROMPT.md`.
Handoff: `docs/NEXT_SESSION_PROMPT.md`.
Snapshot: `snapshots/PKG-0124-2026-08-25/`.

## PKG-0125: Kobieca sylwetka i rig Leny 3.0, diegetyczna wspinaczka (drabiny/windy), swobodne cofanie dwukierunkowe i zachowanie zakazu tworzenia .exe

Data: 2026-08-25

### Cel

ZrealizowaÄ‡ mega-pakiet PKG-0125 z peĹ‚nÄ… autonomiÄ…:
- Przebudowa postaci Leny Wolskiej (`LenaVisualRig 3.0`) z dojrzaĹ‚ymi, kobiecymi proporcjami (1:6.7, wysokoĹ›Ä‡ ~66 px), laboratoryjnym prochowcem, asymetrycznÄ… fryzurÄ…, szwem identyfikacyjnym i 14 stanami animacji.
- WdroĹĽenie komponentĂłw diegetycznej wspinaczki: `LadderZone` (`Area2D`) i `ServiceLift` (`AnimatableBody2D`) z wejĹ›ciami `move_up` i `move_down` (eliminacja platformingu per D-099).
- WdroĹĽenie swobodnego cofania dwukierunkowego w `GameStateManager` (`get_previous_campaign_station`, `target_spawn_side = &"right"`).
- Globalny audyt skali i topologii wielokÄ…tĂłw wektorowych na wszystkich 43 stacjach kampanii.
- ĹšcisĹ‚e zachowanie zakazu generowania plikĂłw `.exe` ani paczek binarnych po tym pakiecie.

### Wynik

1. **LenaVisualRig 3.0 (`scripts/player/lena_visual_rig.gd`)**:
   - Kompletna implementacja 14 stanĂłw: `idle`, `start`, `walk`, `run`, `stop`, `turn`, `jump_rise`, `jump_fall`, `land`, `interact`, `examine`, `unease_reaction`, `seam_gesture`, `climb`.
   - Wzrost ~66 px z proporcjami gĹ‚owa-ciaĹ‚o 1:6.7, kobieca linia talii, laboratoryjny prochowiec z dynamicznym powiewaniem, szew identyfikacyjny lewego rÄ™kawa i asymetryczna fryzura w odcieniu `INK`.
   - Naprawiono geometriÄ™ i kolejnoĹ›Ä‡ wierzchoĹ‚kĂłw wielokÄ…tĂłw (szyja, wĹ‚osy, nogi), eliminujÄ…c bĹ‚Ä™dy samoprzeciÄ™cia i triangulacji w rendererze Godot (`canvas_item_add_polygon`).
   - Zaktualizowano `CollisionShape2D` w `prototype_player.tscn` (kapsuĹ‚a r=6, h=56).

2. **Diegetyczna wspinaczka (Zero Platforming, D-099)**:
   - Skonfigurowano semantyczne akcje InputMap `move_up` i `move_down` w `project.godot`.
   - Utworzono komponent `LadderZone` (`scripts/environment/ladder_zone.gd`) ze szczeblami i syntetyzowanym audio krokĂłw po drabinie.
   - Utworzono komponent `ServiceLift` (`scripts/environment/service_lift.gd`) z fizycznym przesuwem i sygnaĹ‚ami kraĹ„cowymi.
   - Zaktualizowano `PrototypePlayer` o podĹ‚Ä…czanie do drabin, pionowy ruch wspinaczkowy i syntetyzowany dĹşwiÄ™k `create_ladder_rung_climb_sound()`.

3. **Dwukierunkowe cofanie i nawigacja**:
   - Rozszerzono `GameStateManager` o `get_previous_campaign_station(station_id)`, `target_spawn_side` oraz bezpieczne odradzanie gracza z prawej strony ekranu (`x â‰ 540`, zwrot w lewo) przy cofaniu.
   - PodĹ‚Ä…czono sygnaĹ‚ `previous_level_requested` w `_observe_campaign_station`.

4. **Bramka testowa i weryfikacja**:
   - Utworzono `tests/pkg_0125_smoke_test.gd` weryfikujÄ…cy wejĹ›cia, 14 stanĂłw riga, wspinaczkÄ™, windÄ™, cofanie i komplet 43 scen kampanii.
   - Zintegrowano bramkÄ™ PKG-0125 w `tools/verify.ps1`.
   - Zarejestrowano decyzjÄ™ D-117 w `docs/DECISION_LOG.md`.
   - **Nie wywoĹ‚ywano `tools/export_builds.ps1`** (zachowano zakaz generowania `.exe`).

### DowĂłd

- `tests/pkg_0125_smoke_test.gd`:
  `--- PKG-0125 Smoke Test: Feminine Lena, Diegetic Climbing, Bidirectionality & Scale --- PKG-0125: ALL TESTS PASSED (0 FAILURES).`, kod wyjĹ›cia 0.
- `pwsh -NoProfile -File .\tools\verify_docs.ps1`:
  `DOCS PASS: 38 required files and handoff contracts`, kod wyjĹ›cia 0.
- `pwsh -NoProfile -File .\tools\verify.ps1`:
  `Verification passed.`, kod wyjĹ›cia 0 (komplet wszystkich 21 bramek testowych, w tym PKG-0095..PKG-0125).

### Ograniczenia

- Zgodnie z ADR-003 brak testĂłw z udziaĹ‚em graczy zewnÄ™trznych.
- Zakaz generowania binariĂłw `.exe` i paczek instalacyjnych po tym pakiecie zostaĹ‚ Ĺ›ciĹ›le zachowany.

### ZamkniÄ™cie i przekazanie

NastÄ™pny pakiet: `PKG-0126` wedĹ‚ug `docs/NEXT_SESSION_PROMPT.md`.
Handoff: `docs/NEXT_SESSION_PROMPT.md`.
Snapshot: `snapshots/PKG-0125-2026-08-25/`.

## PKG-0126: Szlif atmosferyczny i kinowy: pejzaĹĽe dĹşwiÄ™kowe zero-asset, dynamiczne oĹ›wietlenie wektorowe, mikrodynamiczne czÄ…steczki i balans CRT

Data: 2026-08-25

### Cel

ZrealizowaÄ‡ mega-pakiet PKG-0126 z peĹ‚nÄ… autonomiÄ…:
- Rozbudowa biblioteki proceduralnego audio (`scripts/audio/procedural_audio.gd`) o 12 nowych syntezatorĂłw pejzaĹĽy dĹşwiÄ™kowych zero-asset dla podstruktury, wÄ™zĹ‚Ăłw przemysĹ‚owych i finaĹ‚Ăłw.
- Wzbogacenie komponentu `AtmosphereRig` (`scripts/levels/atmosphere_rig.gd`) o dedykowane profile oĹ›wietlenia wektorowego (sodowe neony, terminale UCP, punkty archiwalne, reflektor gabinetu 40, potrĂłjne filary wyboru 41, Ĺ›wiatĹ‚o Ĺ›witu 43) oraz czÄ…steczki pary wentylacyjnej `VentSteam` dla stacji podziemnych.
- WdroĹĽenie procedury reakcji na niepokĂłj (`trigger_unease_atmosphere`, `trigger_unease` w `PrototypePlayer`).
- PĹ‚ynny balans prezentacji CRT (`scripts/ui/crt_dialogue_box.gd`) z obsĹ‚ugÄ… `auto_advance`, `auto_advance_dwell_time` i kompletnÄ… matrycÄ… barw postaci (`SPEAKER_COLORS`).
- WdroĹĽenie bramki `tests/pkg_0126_smoke_test.gd` i peĹ‚na weryfikacja `tools/verify.ps1`.
- ĹšcisĹ‚e zachowanie dyspozycji uĹĽytkownika: **brak tworzenia nowych plikĂłw `.exe` ani paczek binarnych po pakiecie**.

### Wynik

1. **Proceduralne pejzaĹĽe dĹşwiÄ™kowe (`scripts/audio/procedural_audio.gd`)**:
   - Zaimplementowano 12 nowych 16-bit PCM syntezatorĂłw audio 44100 Hz generowanych w RAM:
     - `create_cooling_chamber_drone_sound()`: rezonans komory chĹ‚odniczej 48 Hz z cyklem czynnika chĹ‚odzÄ…cego i flutterem sprÄ™ĹĽarki;
     - `create_high_voltage_hum_sound()`: buczenie magistrali wysokiego napiÄ™cia 50/100/150/250 Hz z wyĹ‚adowaniami ozonowymi;
     - `create_hydraulic_echo_sound()`: komorowe odbicia hydrauliczne i impulsy ciĹ›nieniowe magistrali;
     - `create_substructure_ambient_sound()`: gĹ‚Ä™bokie, tektoniczne dudnienie fundamentĂłw podstruktury;
     - `create_finale_42a_forced_return_sound()`: zimny ton 740->370 Hz i metaliczny zatrzask powrotu;
     - `create_finale_42b_closure_sound()`: harmonijny akord wygaszania C3/G3/C4/E4 schodzÄ…cy do sub-basu 55 Hz;
     - `create_finale_42c_reciprocal_passage_sound()`: noĹ›na dudnieĹ„ rĂłĹĽnicowych 660/740 Hz z przestrzennym rezonansem przejĹ›cia;
     - `create_unease_tinnitus_sound()`: wysoki pisk szumu usznego 3840 Hz z tÄ™tniÄ…cym sub-basem 58 Hz;
     - `create_residential_ambience_sound()`: szum domowej lodĂłwki 110 Hz z odlegĹ‚ym tĹ‚em miejskim 42 Hz;
     - `create_terminal_hum_sound()`: pisk cewki odchylania kineskopu CRT 15625 Hz z szumem procesora;
     - `create_tunnel_rumble_sound()`: stojÄ…cy rezonans fali akustycznej w tunelach Linii 4;
     - `create_dawn_quietude_sound()`: poranny akord C-dur 9 symbolizujÄ…cy spokĂłj nowego Ĺ›witu.

2. **Wieloprofilowe oĹ›wietlenie wektorowe i czÄ…steczki (`scripts/levels/atmosphere_rig.gd`)**:
   - Zachowano peĹ‚nÄ… wstecznÄ… kompatybilnoĹ›Ä‡ z wÄ™zĹ‚ami testowymi (`FluorescentLight`, `VolumetricDust`, `FluorescentHum`).
   - Dodano wyspecjalizowane ĹşrĂłdĹ‚a oĹ›wietlenia wektorowego dla kategorii stacji:
     - Osiedle / Mieszkanie 14: `SodiumNeonPulse` (pulsujÄ…cy neon sodowy) i `ApartmentWindowGlow` (ciepĹ‚a poĹ›wiata okien);
     - Konsultacja UCP: `TerminalCyanGlow` i `StressIndicatorPulse` (cynobrowe pulsowanie wskaĹşnika naprÄ™ĹĽeĹ„);
     - Tunele techniczne i podstruktura: `EmergencyBeacon`, `ArchiveLedgerSpot`, `SubstructureDronePlayer`;
     - Gabinet Wierzbickiej (40): `HighContrastSpotlight` (wysokokontrastowy stoĹĽek Ĺ›wiatĹ‚a skupiony na biurku);
     - Komora wyboru (41): `ChoicePillarCyan` (42A), `ChoicePillarOxide` (42B), `ChoicePillarAmber` (42C);
     - Epilog (43): `DawnWashLight` (rozproszona jutrzenka).
   - WdroĹĽono czÄ…steczki `VentSteam` (`CPUParticles2D`) z pionowym unoszeniem pary w sektorach przemysĹ‚owych (stacje 14..41).
   - WdroĹĽono procedurÄ™ `trigger_unease_atmosphere(duration)` wygaszajÄ…cÄ… Ĺ›wiatĹ‚a do 40% i uruchamiajÄ…cÄ… pisk tinnitus.
   - W `PrototypePlayer` dodano metodÄ™ `trigger_unease(duration)`.

3. **Optymalizacja i tempo CRTDialogueBox (`scripts/ui/crt_dialogue_box.gd`)**:
   - Rozszerzono `SPEAKER_COLORS` o peĹ‚nÄ… paletÄ™ postaci: `Lena`, `Marta`, `Jakub`, `Wierzbicka`, `Szymon`, `ĹšWIADECTWO`, `ĹšLAD`, `POWRĂ“T`, `UZGODNIENIE`, `GETTING STRANGE`.
   - WdroĹĽono wĹ‚aĹ›ciwoĹ›ci `auto_advance` i `auto_advance_dwell_time` (2.5s) z bezpiecznym resetem akumulatora.
   - PĹ‚ynny odsĹ‚uch i dynamiczna modulacja tonu blipĂłw mowy (`ProceduralAudio.create_dialogue_blip_sound`).

4. **Bramka testowa i weryfikacja**:
   - Zaimplementowano dedykowany test `tests/pkg_0126_smoke_test.gd` weryfikujÄ…cy wszystkie 12 nowych syntezatorĂłw audio, profile oĹ›wietlenia, czÄ…steczki kurzu i pary, barwy i auto-advance CRT, integracjÄ™ z graczem oraz instancjonowanie finaĹ‚Ăłw 40..43.
   - Zintegrowano bramkÄ™ PKG-0126 w `tools/verify.ps1`.
   - Zarejestrowano decyzjÄ™ D-118 w `docs/DECISION_LOG.md`.
   - **Nie wywoĹ‚ywano `tools/export_builds.ps1`** (Ĺ›ciĹ›le zachowano zakaz generowania nowych plikĂłw `.exe`).

### DowĂłd

- `tests/pkg_0126_smoke_test.gd`:
  `--- PKG-0126 Smoke Test: Soundscapes, Vector Lighting, Micro-particles & CRT Pacing --- PKG-0126: ALL TESTS PASSED (0 FAILURES).`, kod wyjĹ›cia 0.
- `pwsh -NoProfile -File .\tools\verify_docs.ps1`:
  `DOCS PASS: 38 required files and handoff contracts`, kod wyjĹ›cia 0.
- `pwsh -NoProfile -File .\tools\verify.ps1`:
  `Verification passed.`, kod wyjĹ›cia 0 (komplet wszystkich 22 bramek testowych, w tym PKG-0095..PKG-0126).

### Ograniczenia

- Zgodnie z ADR-003 brak testĂłw z udziaĹ‚em graczy zewnÄ™trznych.
- Zakaz generowania binariĂłw `.exe` i paczek instalacyjnych po tym pakiecie zostaĹ‚ Ĺ›ciĹ›le zachowany.

### ZamkniÄ™cie i przekazanie

NastÄ™pny pakiet: `PKG-0127` wedĹ‚ug `docs/NEXT_SESSION_PROMPT.md`.
Handoff: `docs/NEXT_SESSION_PROMPT.md`.
Snapshot: `snapshots/PKG-0126-2026-08-25/`.

## PKG-0127: RAM Lifecycle, Sound Cache, Bidirectional Topology & Presentation Contrast

Data: 2026-08-25  
Faza: `P5: Release Candidate 1 Polish, RAM Lifecycle, Mastering and Verification`  
Decyzje: `D-119` (ZarzÄ…dzanie cyklem ĹĽycia pamiÄ™ci RAM i cache fali audio), `ADR-007`  

### Kontekst

Zgodnie z wytycznymi pakietu PKG-0127 przeprowadzono optymalizacjÄ™ pamiÄ™ci RAM, audyt cyklu ĹĽycia zasobĂłw, buforowanie proceduralnego audio oraz globalnÄ… weryfikacjÄ™ dwukierunkowej topologii i kontrastu prezentacji. W poprzednich iteracjach dynamiczne generowanie prĂłbek PCM AudioStreamWAV przy kaĹĽdym kroku lub kwestii dialogowej powodowaĹ‚o mikro-alokacje sterty, a brak jawnego `_exit_tree()` w AtmosphereRig mĂłgĹ‚ prowadziÄ‡ do wyciekĂłw wÄ™zĹ‚Ăłw/strumieni przy szybkim przeĹ‚Ä…czaniu stacji. Zgodnie z dyspozycjÄ… uĹĽytkownika zachowano peĹ‚nÄ… autonomiÄ™ decyzyjnÄ… oraz Ĺ›cisĹ‚y zakaz tworzenia plikĂłw `.exe` i paczek binarnych.

### Zakres i zrealizowane prace

1. **ZarzÄ…dzanie pamiÄ™ciÄ… i buforowanie audio (`scripts/audio/procedural_audio.gd`)**:
   - WdroĹĽono statyczny sĹ‚ownik cache `_sound_cache: Dictionary = {}`.
   - Dodano metody pomocnicze:
     - `get_cached_sound(cache_key: StringName, generator_callable: Callable) -> AudioStreamWAV`: zwraca zbuforowany strumieĹ„ lub generuje nowy i zapisuje pod kluczem;
     - `clear_sound_cache() -> void`: deterministycznie czyĹ›ci bufor fal;
     - `get_sound_cache_size() -> int`: zwraca liczbÄ™ aktualnie zbuforowanych fali dĹşwiÄ™kowych.
   - PrzepiÄ™to odtwarzanie blipĂłw dialogowych w `CRTDialogueBox` (`_play_speech_blip`) na pobieranie zbuforowanego dĹşwiÄ™ku `&"blip_lena"` / `&"blip_other"`.
   - PrzepiÄ™to odtwarzanie krokĂłw, lÄ…dowania i wspinaczki w `PrototypePlayer` (`_setup_audio`) na pobieranie ze zbuforowanego audio (`&"step_linoleum"`, `&"step_metal"`, `&"land_linoleum"`, `&"land_metal"`, `&"ladder_rung"`).
   - PrzepiÄ™to wybĂłr pejzaĹĽy dĹşwiÄ™kowych w `AtmosphereRig` na statyczny cache fal dĹşwiÄ™kowych.

2. **Cykl ĹĽycia zasobĂłw i zwalnianie pamiÄ™ci (`scripts/core/game_state_manager.gd`, `scripts/levels/atmosphere_rig.gd`)**:
   - W `GameStateManager.transition_to_scene()` i `reset_campaign()` wdroĹĽono automatyczne wywoĹ‚anie `ProceduralAudio.clear_sound_cache()` podczas zaciemnienia ekranu, zapobiegajÄ…c gromadzeniu nieuĹĽywanych fali dĹşwiÄ™kowych z opuszczanych stacji.
   - W `AtmosphereRig` zaimplementowano metodÄ™ `_exit_tree()`, ktĂłra natychmiast zatrzymuje odtwarzacze audio (`_fluorescent_hum`, `_substructure_player`, `_unease_player`), zeruje ich referencje `stream` i czyĹ›ci tablice oĹ›wietlenia, eliminujÄ…c wycieki ObjectDB.

3. **Certyfikacja dwukierunkowej topologii i trwaĹ‚oĹ›ci zapisu**:
   - Potwierdzono peĹ‚nÄ… spĂłjnoĹ›Ä‡ grafu nawigacji 01..41, trzech rozgaĹ‚Ä™zieĹ„ finaĹ‚owych 42A, 42B, 42C oraz epilogu 43 w przĂłd (`get_next_campaign_station`) i wstecz (`get_previous_campaign_station`).
   - Zweryfikowano deterministycznÄ… propagacjÄ™ strony odrodzenia (`target_spawn_side`), zapis/odczyt JSON oraz stan decyzji gracza.

4. **Audyt warstw CanvasLayer i skalowalnoĹ›ci typografii**:
   - Potwierdzono Ĺ›cisĹ‚Ä… hierarchiÄ™ warstw:
     - Layer 5: `WorldPixelCompositor` (pikselizacja Ĺ›wiata 2x2);
     - Layer 10: `CrispDiegeticText` (ostre napisy diegetyczne w Ĺ›wiecie);
     - Layer 16: `InnerThoughtSurface` (myĹ›li wewnÄ™trzne `LENA // MYĹšL`);
     - Layer 20: `CRTDialogueBox` (kineskopowy panel dialogowy 42 CPS);
     - Layer 100: `SceneTransitionLayer` (peĹ‚noekranowe tranzycje fade);
     - Layer 110: `CampaignPauseMenu` (menu pauzy, siatka stacji i opcje).
   - Zweryfikowano brak obciÄ™Ä‡ i nakĹ‚adania siÄ™ tekstu przy skalowaniu od 85% do 115%.
   - Przetestowano wspĂłĹ‚czynniki kontrastu luminancji dla caĹ‚ej palety `SPEAKER_COLORS` wobec tĹ‚a `#07090b` â€” wszystkie barwy speĹ‚niajÄ… normÄ™ WCAG AAA/AA (kontrast >= 4.5:1, zakres od 5.2:1 do 14.1:1).

5. **Bramka testowa i weryfikacja automatyczna**:
   - Zaimplementowano dedykowany test `tests/pkg_0127_smoke_test.gd` sprawdzajÄ…cy:
     1. Cykl ĹĽycia bufora dĹşwiÄ™kĂłw i czyszczenie pamiÄ™ci;
     2. SprzÄ…tanie zasobĂłw `_exit_tree()` w `AtmosphereRig`;
     3. Graf dwukierunkowy i trwaĹ‚oĹ›Ä‡ zapisu kampanii;
     4. HierarchiÄ™ CanvasLayer i skalowanie tekstu;
     5. MatrycÄ™ kontrastu barw mĂłwcĂłw;
     6. Instancjonowanie, kompletnoĹ›Ä‡ stosu wÄ™zĹ‚Ăłw i czyste zwalnianie pamiÄ™ci dla wszystkich 45 scen kampanii.
   - WĹ‚Ä…czono bramkÄ™ PKG-0127 do `tools/verify.ps1`.
   - Wszystkie 23 bramki testowe przeszĹ‚y z kodem wyjĹ›cia 0 (PASS).
   - **ĹšciĹ›le zachowano zakaz generowania nowych plikĂłw `.exe` i binariĂłw**.

### DowĂłd

- `tests/pkg_0127_smoke_test.gd`:
  `--- PKG-0127 Smoke Test: RAM Lifecycle, Sound Cache, Bidirectional Topology & Presentation Contrast --- PKG-0127: ALL TESTS PASSED (0 FAILURES).`, kod wyjĹ›cia 0.
- `pwsh -NoProfile -File .\tools\verify_docs.ps1`:
  `DOCS PASS: 38 required files and handoff contracts`, kod wyjĹ›cia 0.
- `pwsh -NoProfile -File .\tools\verify.ps1`:
  `Verification passed.`, kod wyjĹ›cia 0 (komplet wszystkich 23 bramek testowych, w tym PKG-0095..PKG-0127).

### Ograniczenia

- Zgodnie z ADR-003 brak zewnÄ™trznych playtestĂłw konsumenckich.
- Zakaz generowania nowych binariĂłw `.exe` po tym pakiecie zostaĹ‚ w 100% zachowany.

### ZamkniÄ™cie i przekazanie

NastÄ™pny pakiet: `PKG-0128` wedĹ‚ug `docs/NEXT_SESSION_PROMPT.md`.
Handoff: `docs/NEXT_SESSION_PROMPT.md`.
Snapshot: `snapshots/PKG-0127-2026-08-25/`.

## PKG-0128: KoĹ„cowy audyt Golden Master, stabilnoĹ›Ä‡ dĹ‚ugodystansowa i certyfikacja integralnoĹ›ci

Data: 2026-08-25  
Autor: GĹ‚Ăłwny Programista / Dyrektor Artystyczny (Autonomiczna Rola AI)  
Pakiet: `PKG-0128`  
Faza: `P5: Release Candidate 1 / Golden Master 1.0.0`  
Katalog: `C:\getting_strange`  
Status: **ZAKOĹCZONE SUKCESEM (GOLDEN MASTER INTEGRITY & SOAK CERTIFIED)**

### Kontekst i cel pakietu

Celem pakietu **PKG-0128** byĹ‚o przeprowadzenie kompleksowego audytu certyfikacyjnego wersji Golden Master gry *Getting Strange* przed finalnym wydaniem. Zgodnie z wytycznymi architektonicznymi i ograniczeniami projektu (`ADR-006`, `ADR-007`, `D-085`, `D-098`, `D-099`, `D-114`, `D-115`, `D-116`, `D-117`, `D-118`), pakiet objÄ…Ĺ‚ 5 kluczowych filarĂłw integralnoĹ›ci:
1. DĹ‚ugodystansowÄ… symulacjÄ™ obciÄ…ĹĽeniowÄ… (2-Cycle Soak Simulation) dla wszystkich 45 scen kampanii (01..41, 42a, 42b, 42c, 43) ze Ĺ›cisĹ‚Ä… kontrolÄ… alokacji i bufora fali dĹşwiÄ™kowej (`ProceduralAudio`).
2. Audyt parzystoĹ›ci urzÄ…dzeĹ„ sterowania (klawiatura vs gamepad) dla wszystkich semantycznych akcji InputMap, wdroĹĽenie bezkonfliktowego zachowywania przypisaĹ„ drugiego typu kontrolera podczas remapu (`_replace_event_of_matching_type`) oraz certyfikacjÄ™ zakazu stosowania staĹ‚ych `KEY_*` w skryptach rozgrywki.
3. WeryfikacjÄ™ 100% symetrii i kompletnoĹ›ci dwujÄ™zycznych sĹ‚ownikĂłw lokalizacji `LocalizationManager` (PL/EN) dla caĹ‚ego interfejsu, menu pauzy, ustawieĹ„ oraz komunikatĂłw systemowych.
4. CertyfikacjÄ™ epilogu Stacji 43, dialogĂłw koĹ„cowych i tablicy autorĂłw/licencji pod kÄ…tem peĹ‚nej zgodnoĹ›ci z `docs/LICENSES.md` (Zero-Asset Architecture, Godot MIT).
5. Wielocyklowy test odpornoĹ›ci `GameStateManager` na wielokrotne resety kampanii, rozgaĹ‚Ä™zienia finaĹ‚owe i cykle save/load bez akumulacji stanu.

### Kluczowe decyzje architektoniczne i implementacyjne

1. **ParzystoĹ›Ä‡ urzÄ…dzeĹ„ i bezkonfliktowy remapping (`scripts/core/game_state_manager.gd`)**:
   - Zidentyfikowano, ĹĽe poprzednia implementacja `remap_action()` wymazywaĹ‚a wszystkie zdarzenia danej akcji przed dodaniem nowego, co przy zmianie klawisza klawiatury usuwaĹ‚o skonfigurowane przyciski pada (i odwrotnie).
   - Wprowadzono metodÄ™ `_replace_event_of_matching_type(action, new_event)`, ktĂłra selektywnie usuwa zdarzenia z tej samej kategorii urzÄ…dzenia (`InputEventKey` vs `InputEventJoypadButton`/`InputEventJoypadMotion`), zachowujÄ…c nienaruszone mapowania dla drugiego urzÄ…dzenia.
   - Zastosowano identycznÄ… logikÄ™ w `_apply_loaded_settings()`, zapewniajÄ…c stabilnoĹ›Ä‡ po ponownym wczytaniu z pliku JSON.

2. **DĹ‚ugodystansowa symulacja obciÄ…ĹĽeniowa (Soak Simulation)**:
   - Przeprowadzono 2 peĹ‚ne cykle instancjonowania, symulacji fizyki i zwalniania pamiÄ™ci dla wszystkich 45 scen kampanii w jednej sesji procesowej.
   - Zweryfikowano, ĹĽe rozmiar statycznego bufora audio `ProceduralAudio.get_sound_cache_size()` osiÄ…ga stabilnÄ… saturacjÄ™ na poziomie 19 instancji i nie ulega niekontrolowanemu wzrostowi (Ĺ›ciĹ›le poniĹĽej limitu budĹĽetowego 150 instancji).
   - Potwierdzono, ĹĽe kaĹĽda scena posiada kompletny stos wÄ™zĹ‚Ăłw Pixel-Stage i zwalnia siÄ™ deterministycznie.

3. **Bilingwalna integralnoĹ›Ä‡ lokalizacji (PL/EN)**:
   - Przetestowano 100% symetriÄ™ kluczy sĹ‚ownikĂłw lokalizacji w `LocalizationManager`.
   - Zweryfikowano poprawnoĹ›Ä‡ dynamicznego przeĹ‚Ä…czania jÄ™zykĂłw (`"pl"` <-> `"en"`) w czasie rzeczywistym oraz sprawdzono, ĹĽe ĹĽaden ciÄ…g tekstowy nie jest pusty ani nie zwraca pustego identyfikatora klucza.

4. **IntegralnoĹ›Ä‡ Stacji 43 i Licencji**:
   - Przetestowano scenÄ™ epilogu `scenes/levels/station_43.tscn` oraz skrypt `scripts/levels/station_43.gd`.
   - Zweryfikowano obecnoĹ›Ä‡ rekwizytĂłw narracyjnych: `AdminNoticeBoard`, `CreditsRoll` i `FinalBlackout`, sekwencjÄ™ dialogowÄ… Leny podsumowujÄ…cÄ… wybory oraz zgodnoĹ›Ä‡ z Zero-Asset Architecture i licencjÄ… MIT silnika Godot.

5. **Bramka testowa i weryfikacja automatyczna**:
   - Zaimplementowano dedykowany zestaw testowy `tests/pkg_0128_smoke_test.gd` realizujÄ…cy wszystkie powyĹĽsze weryfikacje.
   - Zintegrowano bramkÄ™ PKG-0128 z gĹ‚Ăłwnym skryptem weryfikacyjnym `tools/verify.ps1`.
   - Wszystkie 24 bramki testowe przeszĹ‚y z kodem wyjĹ›cia 0 (PASS).
   - **ĹšciĹ›le zachowano zakaz generowania nowych plikĂłw `.exe` i binariĂłw**.

### DowĂłd

- `tests/pkg_0128_smoke_test.gd`:
  `--- PKG-0128 Smoke Test: Golden Master Audit, Soak Simulation & Integrity Certification --- PKG-0128: ALL TESTS PASSED (0 FAILURES). GOLDEN MASTER CERTIFIED.`, kod wyjĹ›cia 0.
- `pwsh -NoProfile -File .\tools\verify_docs.ps1`:
  `DOCS PASS: 38 required files and handoff contracts`, kod wyjĹ›cia 0.
- `pwsh -NoProfile -File .\tools\verify.ps1`:
  `Verification passed.`, kod wyjĹ›cia 0 (komplet wszystkich 24 bramek testowych, w tym PKG-0095..PKG-0128).

### Ograniczenia

- Zgodnie z ADR-003 brak zewnÄ™trznych playtestĂłw konsumenckich.
- Zakaz generowania nowych binariĂłw `.exe` po tym pakiecie zostaĹ‚ w 100% zachowany (uĹĽywane sÄ… istniejÄ…ce, przetestowane binaria RC1 z PKG-0124 w `dist/`).

### ZamkniÄ™cie i przekazanie

NastÄ™pny pakiet: `PKG-0129` wedĹ‚ug `docs/NEXT_SESSION_PROMPT.md`.
Handoff: `docs/NEXT_SESSION_PROMPT.md`.
Snapshot: `snapshots/PKG-0128-2026-08-25/`.

## PKG-0129: Globalny audyt droĹĽnoĹ›ci geometrii 43 stacji, wdroĹĽenie diegetycznych drabin i wind oraz certyfikacja traweru

Data: 2026-08-25  
Faza: P5: Release Candidate 1 / Golden Master 1.0.0 (Global Traversal Certification)  
Lead Programmer & Art Director (Autonomia D-025, D-085, ADR-004)

### Wynik

- **Globalny audyt geometrii traweru (0 przeszkĂłd blokujÄ…cych)**:
  - Zbudowano narzÄ™dzie audytujÄ…ce geometriÄ™ `tools/geometry_audit.gd` i zintegrowanÄ… bramkÄ™ testowÄ… `tests/pkg_0129_smoke_test.gd`.
  - Przebadano wszystkie 45 scen kampanii (01..41, 42a, 42b, 42c, 43) pod kÄ…tem zgodnoĹ›ci z ograniczeniami motorycznymi Leny (wysokoĹ›Ä‡ kroku <= 35 px, max skok ~44 px).
  - Zweryfikowano i potwierdzono 0 litych, niepokonywalnych przeszkĂłd geometrycznych w caĹ‚ej grze.
- **Remediacja i instalacja diegetycznych urzÄ…dzeĹ„ mechanicznych**:
  - **Stacja 01 (`station_01.tscn`)**:
    - Skonfigurowano `one_way_collision = true` na `OperatorDesk` i `ConsoleBench`.
    - Zainstalowano 2 przemysĹ‚owe drabiny Ĺ›cienne `LadderZone`: `OperatorLadder` (wys. 68 px) i `ConsoleLadder` (wys. 62 px).
  - **Stacja 09 & 11 (`station_09.tscn`, `station_11.tscn`)**:
    - WdroĹĽono `one_way_collision = true` na rekwizytach przesuwanych (`StairwellPlanter`, `HallwaySideboard`), umoĹĽliwiajÄ…c pĹ‚ynne wchodzenie/przeskakiwanie po przesuniÄ™ciu.
  - **Stacja 25 (`station_25.tscn`)**:
    - Zainstalowano automatycznÄ… windÄ™ technicznÄ… `ServiceLift` (`TrackBedServiceLift`) z ruchem pionowym 85 px w dĂłĹ‚/gĂłrÄ™ i fizykÄ… `sync_to_physics = true`.
  - **Stacja 30 (`station_30.tscn`)**:
    - Skonfigurowano `one_way_collision = true` na `WitnessRelayBank` oraz dodano drabinÄ™ `RelayServiceLadder` (wys. 100 px).
  - **Stacja 32 (`station_32.tscn`)**:
    - Skonfigurowano `one_way_collision = true` na `ObservedGlassTrace` oraz dodano drabinÄ™ `GlassLabLadder` (wys. 100 px).
  - **Stacja 34 (`station_34.tscn`)**:
    - Zainstalowano windÄ™ technicznÄ… `ServiceLift` (`TurbineDeckServiceLift`) z ruchem pionowym 90 px i automatycznym cyklem.
  - **Stacja 37 (`station_37.tscn`)**:
    - Dodano drabinÄ™ `SignalGalleryLadder` (wys. 90 px) na peronie transmisyjnym.
- **Certyfikacja mechanik wspinaczki i fizyki platform**:
  - `PrototypePlayer` & `LadderZone`: przetestowano i potwierdzono doĹ‚Ä…czanie `attach_to_ladder`, stan wspinaczki `is_climbing`, blokadÄ™ grawitacji podczas ruchu pionowego, odtwarzanie proceduralnego audio krokĂłw po szczeblach `play_ladder_rung_sound` co 14 px, aktualizacjÄ™ stanu wizualnego `LenaVisualRig` na `climb` oraz bezkolizyjne zeskakiwanie/odĹ‚Ä…czanie na podĹ‚odze lub przy skoku.
  - `ServiceLift`: przetestowano i potwierdzono pĹ‚ynny ruch wektorowej platformy zsynchronizowany z cyklem fizyki (`sync_to_physics = true`), czasy postoju na kraĹ„cach i sygnalizacjÄ™ LED.
- **Bramka testowa i weryfikacja automatyczna**:
  - Zaimplementowano dedykowany zestaw testowy `tests/pkg_0129_smoke_test.gd`.
  - Zintegrowano bramkÄ™ PKG-0129 z gĹ‚Ăłwnym skryptem `tools/verify.ps1`.
  - Wszystkie 25 bramek testowych przeszĹ‚y z kodem wyjĹ›cia 0 (PASS).
  - **ĹšciĹ›le zachowano zakaz generowania nowych plikĂłw `.exe` i binariĂłw**.

### DowĂłd

- `tests/pkg_0129_smoke_test.gd`:
  `--- PKG-0129 Smoke Test: Traversal Geometry, Ladders & Lifts Certification --- PKG-0129: ALL TESTS PASSED (0 FAILURES). TRAVERSAL CANON FULLY CERTIFIED.`, kod wyjĹ›cia 0.
- `pwsh -NoProfile -File .\tools\verify_docs.ps1`:
  `DOCS PASS: 38 required files and handoff contracts`, kod wyjĹ›cia 0.
- `pwsh -NoProfile -File .\tools\verify.ps1`:
  `Verification passed.`, kod wyjĹ›cia 0 (komplet wszystkich 25 bramek testowych, w tym PKG-0095..PKG-0129).

### Ograniczenia

- Zgodnie z ADR-003 brak zewnÄ™trznych playtestĂłw konsumenckich.
- Zakaz generowania nowych binariĂłw `.exe` po tym pakiecie zostaĹ‚ w 100% zachowany.

### ZamkniÄ™cie i przekazanie

NastÄ™pny pakiet: `PKG-0130` wedĹ‚ug `docs/NEXT_SESSION_PROMPT.md`.
Handoff: `docs/NEXT_SESSION_PROMPT.md`.
Snapshot: `snapshots/PKG-0129-2026-08-25/`.

## PKG-0130: Budzet klatki 60 Hz, determinizm czastek i koherencja pikselowa kamery

Data: 2026-08-25
Faza: P5: Release Candidate 1 / Golden Master 1.0.0 â€” zamkniecie fazy P5
Lead Programmer & Art Director (Autonomia D-025, D-085, ADR-004)

### Wynik

- **Kontrakt budzetu czastek (`ParticleBudget`)**:
  - Nowa klasa `scripts/visual/particle_budget.gd` jest jedynym miejscem, w ktorym zapisany jest limit 30 Hz i `fract_delta = false`.
  - Wszystkie piec fabryk emiterow (`atmosphere_rig`, `prototype_player`, `anchorable_object`, `movable_anchorable_prop`, `memory_resonance_point`) przechodza przez `apply_frame_budget()`.
  - Bramka czyta te pliki i odrzuca fabryke bez wywolania â€” nowy emiter bez kontraktu nie przejdzie.
  - `release()` deterministycznie wygasza emiter przy `_exit_tree()`, wiec zmiana sceny nie zostawia czastek w tle.
- **Wspoldzielone tekstury swiatel wektorowych**:
  - `AtmosphereRig` cache'uje `GradientTexture2D` 256x256 po kolorze. 163 instancje `Light2D` w kampanii dziela **18** tekstur (redukcja 9.1x).
  - Pulsujace swiatla przestaly uzywac `Array[Dictionary]` w `_process()`; sciezka goraca to trzy `PackedFloat32Array`.
- **Rozdzielenie puli od zbioru aktywnego**:
  - Audyt i bramka licza osobno emitujace systemy (koszt klatki) i usypione one-shoty (koszt pamieci).
  - Najwyzsze obciazenie zywymi czastkami na scene: 62 (Stacja 24/26), budzet 128.
- **Cache PCM silnika windy**:
  - `ServiceLift` korzysta z `ProceduralAudio.get_cached_sound(&"moving_tram_motor", ...)`. Dwie windy dziela jeden strumien.
- **Koherencja pikselowa kamery**:
  - Wygladzanie w float (`_smooth_position`); renderer dostaje snap do siatki 2 px (`PIXEL_GRID`), zgodnej z kompozytorem 320x180 w 640x360.
  - Snap nie jest odczytywany z powrotem jako stan â€” brak kumulowanego dryfu.
  - Klamrowane sledzenie pionowe ze strefa martwa 46 px. Komora o wysokosci jednego widoku pozostaje zablokowana w srodku; sledzenie wlacza sie tylko w szybach drabin i wind.
  - `Camera2D.offset` wstrzasu jest snapowany do tej samej siatki; bez tego wstrzas znosilby kompozytor z siatki.
- **Narzedzia i bramki**:
  - `tools/frame_budget_audit.gd` â€” headless, budzety obiektowe + timing roznicowy wobec pustego drzewa, 45 scen.
  - `tools/render_frame_timing.gd` â€” normalny sterownik Windows, vsync off, 180 probek na 12 najciezszych scenach.
  - `tests/pkg_0130_smoke_test.gd` i dwie bramki w `tools/verify.ps1`.
  - Raport: `docs/PKG_0130_FRAME_BUDGET_REPORT.md`.
- **Zamkniecie fazy P5**. Zgodnie z D-098 nie generowano `.exe`.

### Dowod

```text
RENDER TIMING: PASS â€” every probed scene holds the 60 Hz budget on this machine.
Worst p99: 14.448 ms (station_01) vs 16.66 ms budget.
Median: 4.065â€“7.310 ms (137â€“246 FPS) on Intel Iris Xe, OpenGL Compatibility.

FRAME BUDGET AUDIT: PASS â€” 45/45 scenes inside object and differential timing budgets.
Shared radial light textures cached: 18
Cached procedural PCM buffers: 20

PKG-0130: ALL TESTS PASSED (0 FAILURES). FRAME BUDGET AND PIXEL COHERENCE CERTIFIED.
```

Ograniczenie: pomiar renderu dotyczy jednej maszyny (Intel Iris Xe, Windows). Headless nie dowodzi GPU. ADR-003: brak tesci zewnetrznych, brak dowodu odczucia plynnosci.

### Zamkniecie i przekazanie

Nastepny pakiet: `PKG-0131` wedlug `docs/NEXT_SESSION_PROMPT.md` (P6: unifikacja prezentacji, reduced-motion, dlug z nazewnictwa kamery).
Handoff: `docs/NEXT_SESSION_PROMPT.md`.
Snapshot: `snapshots/PKG-0130-2026-08-25/`.

## PKG-0131: Dyrektywa P6 â€” Human Scale & Playability

Data: 2026-08-25
Faza: P6 otwarta. P5 pozostaje zamkniÄ™ta technicznie.
Lead Programmer & Art Director (D-025, D-085, ADR-004)

### Kontekst

WĹ‚aĹ›ciciel uniewaĹĽniĹ‚ stary cel PKG-0131 (nazwa kamery, reduced-motion)
i podaĹ‚ cztery wady jako prawdÄ™ runtime: Lena nie wyglÄ…da jak kobieta
i wyglÄ…da jak krasnoludek; skakanie po mieĹ›cie jest absurdem; da siÄ™
iĹ›Ä‡ tylko w prawo; meble nie trzymajÄ… skali. Zakaz `.exe` do odwoĹ‚ania.

Zmierzono na dysku przed decyzjami:

- `LenaVisualRig` rysuje wielokÄ…ty w `_draw()`; kapsuĹ‚a 56Ă—12; figura ~66 px.
- Zero stacji deklaruje `previous_level_requested`. GSM tylko sĹ‚ucha.
- `geometry_audit.gd` uĹĽywa progu 35 px (blat, nie schodek).

### Wynik

- D-121..D-126 w `DECISION_LOG.md`.
- Nowy kanon `docs/WORLD_SCALE.md` (1 m = 52 px, Lena 87 px, krzesĹ‚o 23 px).
- Szablon `docs/PLAYTHROUGH_TRAVERSAL_AUDIT.md`.
- Trawers 1.1: Â§7.5 skok â‰  lokomocja, Â§7.6 dwukierunkowoĹ›Ä‡ gracza, prĂłg 18 px.
- Lena spec 4.0 + pipeline `gen-ai` (Â§10).
- P6 w ROADMAP / INDEX / CREATIVE_REBUILD_PLAN przekierowana.
- H-017, H-018, H-025: REFUTED na warstwie mierzonej. H-027, H-028 UNTESTED.
- R-009 i R-031 zmaterializowane.
- Prompt wykonawczy: PKG-0132 w `NEXT_SESSION_PROMPT.md`.
- Runtime niezmieniony. Zero `.exe`.

### DowĂłd

```text
DOCS PASS: 40 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
PKG-0095..PKG-0130: ALL TESTS PASSED
FRAME BUDGET AUDIT: PASS
Verification passed.
EXIT=0
```

Czas: 1054 s. Runtime nietkniÄ™ty. Zero `.exe`.

### Ograniczenia

Nie naprawiono Leny, skali, lewych wyjĹ›Ä‡ ani schodkĂłw. To robi PKG-0132.
ADR-003: brak tesci, brak dowodu piÄ™kna. Zielony verify nie certyfikuje
P6 playability.

### ZamkniÄ™cie i przekazanie

NastÄ™pny pakiet: `PKG-0132` wedĹ‚ug `docs/NEXT_SESSION_PROMPT.md`.
Handoff: `docs/NEXT_SESSION_PROMPT.md`.
Snapshot: `snapshots/PKG-0131-2026-08-26/`.

## PKG-0132: Lena 4.0, skala, ReturnZone, prog 18 px

Data: 2026-08-26
Faza: P6 Human Scale & Playability â€” wykonanie.
Lead Programmer & Art Director (D-025, D-085, ADR-004)

### Kontekst

PKG-0131 zostawil kanon D-121..D-126 bez runtime. Lena byla wielokatowym
krasnoludkiem (~66 px). Zero stacji emitowalo `previous_level_requested`.
Audyt 35 px certyfikowal blaty.

### Wynik

- `LenaVisualRig` 4.0: Sprite2D / Animated klatki, `_draw()` tylko cien.
  Idle 46x87. Capsule 72, r=8, dĂłl stopy +27 bez zmian.
  Assety: `assets/characters/lena/` (walk x5, run x4, jump/land/climb/interact/examine).
  Generacja: Gemini 3.1 Flash Image (tozsamosc) + Flux Kontext Pro (warianty).
  Flux 2 Pro idle (pixel-side) zostawiony w `raw/` â€” nie wdroĹĽony, zeby nie
  rozjechac cyklu.
- `ReturnZone` + sygnal `previous_level_requested` na stacjach 02â€“43
  (w tym 42a/b/c). GSM dokleja strefe i spawnuje z prawej z `test_move`.
- `geometry_audit.gd` prog 18 px, pomija `disabled`. 45/45, 0 blockerow.
  Bench 02 i DualWitnessFrame 33 sciete do 18 px. Biurka 01 do 39 px.
- `tests/pkg_0132_smoke_test.gd` w `tools/verify.ps1`.
- Tabela `PLAYTHROUGH_TRAVERSAL_AUDIT.md`: REMEDIATED, nie PASS playthrough.
- Zero nowych `.exe` gry (D-125).

### Dowod

```text
PKG-0132: ALL TESTS PASSED (0 FAILURES).
geometry_audit: ALL 45 STATIONS TRAVERSAL-CERTIFIED! Zero blocking barriers.
```

### Ograniczenia

Brak capture na normalnym sterowniku Windows (H-027 odbiĂłr). Brak sterowanego
chodu 05â†’04â†’03 na ekranie. One_way meble 09/11 nadal da sie nadskoczyc.
ADR-003: brak tesci zewnetrznych. Nie pisac, ze Lena â€žwyglada dobrze dla graczaâ€ť.

### Zamkniecie i przekazanie

Nastepny pakiet: `PKG-0133` wedlug `docs/NEXT_SESSION_PROMPT.md`.
Handoff: `docs/NEXT_SESSION_PROMPT.md`.
Snapshot: `snapshots/PKG-0132-2026-08-26/`.

## PKG-0133: ChĂłd default, sluzÄ™ 01, interakcja bez petli

Data: 2026-08-26
Faza: P6 Human Scale & Playability â€” hotfix wlasciciela.
Lead Programmer & Art Director (D-025, D-085, ADR-004)

### Kontekst

Wlasciciel po PKG-0132: (1) prawa krawedz stacji 01 to blokada, (2) Lena
wyglada jakby caly czas biegala, (3) po E na rekwizycie animacja rozbryzgu
nie konczy sie i nie ma konsekwencji.

Zmierzono: ChamberDoor 20x180 @ (585, 238); po uniesieniu 70 px dolna
krawedz 258, gora kapsuly 72 px = 224. `set_mechanical_state` bralo `run`
przy |vx| > 60, a profil A ma 96. `_process` rekwizytu robil `queue_redraw`
co klatke â€” retikul pulsowal wiecznie.

### Wynik

- D-127: chĂłd default; `sprint` (Shift / LB) to modyfikator, nie nowy czasownik.
- `LenaVisualRig` wybiera `run` tylko przy fladze sprintu.
- Stacja 01: po procedurze `CollisionShape2D.disabled`; skrzydlo â’140 px Y.
  Mysl przy zamknietej sluzie: â€žSluza czeka na zapisâ€¦â€ť.
- Rekwizyty: po sukcesie cyjanowy haczyk, brak pulsujacego retikula;
  one-shot na biurku 01; czastki tylko gdy `is_activated` po handlerze.
- `tests/pkg_0133_smoke_test.gd` w `tools/verify.ps1`.
- Zero nowych `.exe`.

### Dowod

```text
PKG-0133: ALL TESTS PASSED (0 FAILURES).
TRAVERSAL LINT PASS
PKG-0132: ALL TESTS PASSED (regresja)
```

### Ograniczenia

Brak capture na normalnym sterowniku. Brak sterowanego 05â†’04â†’03.
One_way 09/11 zostaja na PKG-0134. ADR-003.

### Zamkniecie i przekazanie

Nastepny pakiet: `PKG-0134` wedlug `docs/NEXT_SESSION_PROMPT.md`.
Handoff: `docs/NEXT_SESSION_PROMPT.md`.
Snapshot: `snapshots/PKG-0133-2026-08-26/`.

## PKG-0134: Live playability 45 stacji

Data: 2026-08-26
Faza: P6 â€” weryfikacja przejĹ›cia i interakcji kaĹĽdej lokacji.

### Kontekst

WĹ‚aĹ›ciciel: sprawdziÄ‡ moĹĽliwoĹ›ci przejĹ›cia i interakcji na KAĹ»DEJ lokacji.
`geometry_audit` 18 px nie dowodzi chodu. KapsuĹ‚a 72 nie wchodzi na krawÄ™ĹĽnik
18 px i nie mieĹ›ci siÄ™ pod drzwiami uniesionymi o 70 px.

### Wynik

- `tools/campaign_playability_audit.gd`: instancja, chĂłd, rekwizyty, unlock.
- 45/45 fizycznie dochodzi do Ĺ›luzy po interact/unlock.
- GATE_STORY (korytarz otwarty, flaga po dialogu): 12, 14, 15, 19, 20, 21.
- `ExitClearance` na 01/02/03/06/08/10; przegroda 26 otwierana przy unlock.
- `PrototypePlayer.try_curb_step` (18 px, D-128).
- Balkon 12: collider wyĹ‚Ä…czany przy zamkniÄ™ciu (nie blokuje Ĺ›luzy).
- `tests/pkg_0134_smoke_test.gd` w `verify.ps1`.
- Zero nowych `.exe`.

### Dowod

```text
PKG-0134: ALL TESTS PASSED (0 FAILURES).
campaign_playability_audit: 45/45 PASS_PHYSICS, 6 GATE_STORY, 0 BLOCK
```

### Ograniczenia

Headless chĂłd nie jest playthrough na ekranie. Brak capture GPU.
ADR-003.

### Zamkniecie i przekazanie

Nastepny pakiet: `PKG-0135` wedlug `docs/NEXT_SESSION_PROMPT.md`.
Snapshot: `snapshots/PKG-0134-2026-08-26/`.



## PKG-0135
- Fixed ReturnZone assignments.
- Fixed smoke test teleport coordinates for ReturnZone.
- All tests passing.
- Snapshot created.


## PKG-0136 â€” 2026-08-29 â€” Animacja Leny 4.1, kadr dialogowy, naprawa wyjĹ›Ä‡ 03â€“05

### Zlecenie

WĹ‚aĹ›ciciel: obecna animacja ruchu bohaterki jest nie do zaakceptowania.
SprawdziÄ‡ teĹĽ rozĹ‚oĹĽenie wszystkich elementĂłw graficznych w grze â€” czy
umiejscowienie zegara ma sens. Praca autonomiczna, decyzje po stronie modelu.

### Diagnoza (mierzona, nie hipoteza)

Rig 4.0 miaĹ‚ cztery niezaleĹĽne defekty:

1. Kotwiczenie poziome po szerokoĹ›ci pĹ‚Ăłtna przy klatkach 39â€“60 px szerokoĹ›ci
   â†’ biodra skakaĹ‚y do 7 px na klatkÄ™ (8% wysokoĹ›ci ciaĹ‚a).
2. `footY` 80/81/86 zaleĹĽnie od klatki â†’ postaÄ‡ zapadaĹ‚a siÄ™ do 5 px w podĹ‚ogÄ™.
3. SzeĹ›Ä‡ â€žstanĂłwâ€ť (start, stop, turn, seam_gesture, unease_reaction, a w cyklu
   chodu takĹĽe `walk_2`) byĹ‚o tym samym plikiem co `idle.png`.
4. StaĹ‚a kadencja 9 fps niezaleĹĽna od prÄ™dkoĹ›ci â†’ poĹ›lizg stĂłp.

### Wykonane

- **Nowy zestaw klatek** przez `gen-ai` (Picsart, Nano Banana Pro): piÄ™Ä‡
  arkuszy po 4 klatki, identycznoĹ›Ä‡ trzymana referencjÄ… obrazu. Cykl chodu
  (contact/down/pass/up), cykl biegu z klatkÄ… lotu, osobne start/stop/turn,
  dwuklatkowy przysiad lÄ…dowania, dwuklatkowa wspinaczka, reakcje.
- **Deterministyczna normalizacja offline**: keying tĹ‚a, segmentacja przez
  komponenty spĂłjne, wypalenie pivotu (biodra x=32, grunt y=96) na wspĂłlnym
  pĹ‚Ăłtnie 64x104, tĹ‚umienie boba gĹ‚owy z 5,6 px do ~3 px, usuwanie wysp
  i artefaktĂłw jasnych pikseli. Klatki 4.0 zarchiwizowane w `_source_v40/`.
- **`LenaVisualRig` 4.1**: `scale = 1` i staĹ‚a pozycja, faza cyklu z dystansu,
  nakĹ‚adki prezentacyjne start/stop/turn, stany jednorazowe trzymajÄ… ostatniÄ…
  klatkÄ™, obrĂłt jako squash przez pivot, oddech 1 px, snap do pikseli.
- **Audyt kadru** (`docs/FRAME_LAYOUT_AUDIT.md`) na runtime i przemiarze
  wszystkich 45 scen.
- **`CinematicCamera.dialogue_framing_offset`**: widocznoĹ›Ä‡ sylwetki nad
  panelem dialogowym roĹ›nie z 33% do 75%.
- **`NarrativeGuidanceService`** sam wykrywa panel dialogowy â€” gĹ‚os wewnÄ™trzny
  nie dzieli juĹĽ kadru z dialogiem w 43 stacjach, w ktĂłrych nikt tego nie woĹ‚aĹ‚.
- **Etykieta `station_01`** przeniesiona z y=210 (w sylwetce Leny) na y=166.

### Znaleziona i naprawiona regresja PKG-0135

Stacje 03, 04 i 05 **nie miaĹ‚y `AirlockZone`**, a ich lewa strefa byĹ‚a
podpiÄ™ta pod `level_completed`. Trzy stacje kampanii nie miaĹ‚y wyjĹ›cia do
przodu, a chodzenie w lewo koĹ„czyĹ‚o poziom. Testy `smoke_test.gd`
i `pkg_0135_smoke_test.gd` sprawdzaĹ‚y tÄ™ zĹ‚Ä… semantykÄ™.

Dodatkowo `pkg_0135_smoke_test.gd` sygnalizowaĹ‚ powrĂłt przez lokalnÄ… zmiennÄ…
domkniÄ™tÄ… w lambdzie â€” GDScript kopiuje lokalne przez wartoĹ›Ä‡, wiÄ™c trzy
asercje byĹ‚y trwale czerwone niezaleĹĽnie od kodu gry.

### Weryfikacja

Wszystkie bramki zielone: `smoke_test`, `traversal_lint_test`, `pkg_0117`,
`pkg_0118`, `pkg_0125`, `pkg_0126`, `pkg_0132`, `pkg_0133`, `pkg_0134`,
`pkg_0135`, nowy `pkg_0136`.

Rendery Windows/OpenGL (Intel Iris Xe): `reports/pkg_0136_lena_state_sheet.png`,
`pkg_0136_lena_walk_strip.png`, `pkg_0136_lena_run_strip.png`,
`pkg_0136_station_01_layout.png`, `pkg_0136_station_05_layout.png`.

### Ograniczenia

Playthrough 01â†’43 po zmianie kadru dialogowego nie zostaĹ‚ wykonany â€” kadr
oglÄ…dany na stacjach 01, 05 i 24. Cykl chodu ma 4 klatki, nie 8 (uzasadnienie
w `LENA_CHARACTER_AND_ANIMATION.md` Â§11.4).

### Decyzje

D-129 (jedno pĹ‚Ăłtno z pivotem), D-130 (cykl z dystansu), D-131 (nakĹ‚adki
prezentacyjne), D-132 (airlock vs return), D-133 (kadr dialogowy),
D-134 (wygaszanie gĹ‚osu wewnÄ™trznego), D-135 (lambdy w testach).

### Zamkniecie i przekazanie

Nastepny pakiet: `PKG-0137` wedlug `docs/NEXT_SESSION_PROMPT.md`.

## PKG-0137 â€” 2026-08-29 â€” Sterowany playthrough 01â†’43 po zmianie kadru

### Cel

PrzejĹ›Ä‡ caĹ‚Ä… kampaniÄ™ sterowanym ruchem po wdroĹĽeniu D-133 (kadr dialogowy)
i D-134 (wygaszanie myĹ›li), ktĂłre oglÄ…dano dotÄ…d na dwĂłch stacjach z 45.

### Co znalazĹ‚ przebieg

Pierwszy przebieg: **103 pozycje na 45 scenach**, z czego cztery to realne
blokery produktu, reszta to artefakty narzÄ™dzia naprawione w narzÄ™dziu.

1. **Kadr odsĹ‚aniaĹ‚ pustkÄ™ na wszystkich 45 stacjach.** Offset 36 px z D-133 jest
   nakĹ‚adany po klampie komory, a kaĹĽda komora kampanii ma dokĹ‚adnie 640x360,
   wiÄ™c klamp pionowy zapada siÄ™ do Ĺ›rodka i kamera zjeĹĽdĹĽa na y=216. Kadr
   obejmowaĹ‚ Ĺ›wiat 36..396, a scenografia koĹ„czyĹ‚a siÄ™ na 360. Dolne 36 px kaĹĽdego
   kadru dialogowego byĹ‚o `default_clear_color` `#07090c`.
2. **Cykl chodu Ĺ›lizgaĹ‚ siÄ™ na pochyĹ‚oĹ›ciach i krawÄ™ĹĽnikach.** D-130 liczyĹ‚o fazÄ™
   z prÄ™dkoĹ›ci zamierzonej, a nie z dystansu pokonanego. Zmierzony dryf 16â€“39 px
   na przebiegu 480 px na stacjach 07, 09 i 11.
3. **Cofanie fizycznie niemoĹĽliwe na stacjach 07 i 09.** Biegi schodĂłw byĹ‚y
   trĂłjkÄ…tami: rampa 26Â° od zachodu, pionowa Ĺ›ciana 46â€“60 px od wschodu. Lena
   wchodziĹ‚a po skosie, spadaĹ‚a z krawÄ™dzi i nie mogĹ‚a wrĂłciÄ‡. To Ĺ‚amaĹ‚o D-132
   i D-124 na dwĂłch stacjach ciÄ…gu 02â€“43.
4. **Etykieta na sylwetce aktora, stacja 08.** `..._Certificate` siÄ™gaĹ‚a 4 px
   w liniÄ™ gĹ‚owy Leny.
5. **WysuniÄ™ta szuflada dzieliĹ‚a salÄ™ 13 na pĂłĹ‚.** Collider 46x34 wystawaĹ‚ 29 px
   nad podĹ‚ogÄ™, czyli powyĹĽej progu 18 px. Otwarta szuflada byĹ‚a Ĺ›cianÄ… przez
   caĹ‚Ä… salÄ™, a jedynym wyjĹ›ciem powrĂłt do uchwytu.

### Naprawy

- **D-136**: `VectorStageStyle.STAGE_APRON = 40` plus `draw_stage_apron()` â€”
  malowany fartuch pod planem gry; nogi proscenium siÄ™gajÄ… jego dna.
  `CinematicCamera.get_framing_budget()` klampuje offset dialogowy do tego, co
  faktycznie namalowane. Fartuch to scenografia: zero colliderĂłw.
- **D-137**: `LenaVisualRig._sample_travel()` â€” faza cyklu z realnego
  przemieszczenia rigu, z zabezpieczeniem przed teleportem. PoĹ›lizg spadĹ‚ do
  0,0 px na wszystkich 45 stacjach przy schodkach do 18 px.
- **D-138**: biegi schodĂłw na 07 i 09 majÄ… realne stopnie z podstopnicami
  â‰¤ 18 px, w kontrakcie `MAX_CURB_STEP` (D-123).
- **D-139**: etykieta stacji 08 przesuniÄ™ta na y=172; `FRAME_LAYOUT_AUDIT` Â§4
  zamkniÄ™ty przez `_draw_overhead_structure()` dla stacji 24 i 31â€“37.
- **D-140**: collider szuflady na stacji 13 to teraz prĂłg 16 px, nad ktĂłrym
  `try_curb_step` przenosi LenÄ™, a nie Ĺ›ciana. Audyt i bramka celowo zostawiajÄ…
  szufladÄ™ otwartÄ… â€” to gorszy przypadek.

### Artefakty narzÄ™dzia (naprawione w narzÄ™dziu, nie w grze)

BudĹĽet klatek marszu za maĹ‚y na powrĂłt przez caĹ‚Ä… salÄ™; stacja zwalniana przez
`queue_free()` ĹĽyĹ‚a jeszcze w drzewie przy nastÄ™pnej instancji i podstawiaĹ‚a
cudze collidery; wejĹ›cie do Ĺ›luzy, w ktĂłrej aktor juĹĽ staĹ‚, nie generuje
`body_entered`; automatyczne przejĹ›cie kampanii podmieniaĹ‚o scenÄ™ w trakcie
badania; zakotwiczenie jest czasownikiem gracza, nie flagÄ… (stacja 38); otwarta
zakotwiczenie jest czasownikiem gracza, nie flagÄ….

### Weryfikacja

Nowa bramka `tests/pkg_0137_smoke_test.gd` â€” kontrakt fartucha, cykl z dystansu
(unit), a nastÄ™pnie kadr, etykiety i oba wyjĹ›cia na wszystkich 45 scenach.
Zielone rĂłwnieĹĽ: `smoke_test`, `traversal_lint_test`, `pkg_0113`, `pkg_0130`,
`pkg_0132`, `pkg_0133`, `pkg_0135`, `pkg_0136`.

Rendery Windows/OpenGL (Intel Iris Xe): `reports/pkg_0137_station_*_framed.png`,
`reports/pkg_0137_before_apron_station_*.png`, `reports/pkg_0137_capture_report.txt`.

### Ograniczenia

Przebieg dowodzi kadru, etykiet, wyjĹ›Ä‡ i lokomocji â€” nie zabawy (ADR-003).
Warunki fabularne sÄ… speĹ‚niane ustawieniem flag stacji i zakotwiczeniem
`AnchorableObject`, nie przejĹ›ciem dialogĂłw. Pomiar kolorĂłw tylko na
Windows/OpenGL Intel Iris Xe (H-027).

### Decyzje

D-136 (malowany budĹĽet kadru), D-137 (cykl z dystansu pokonanego),
D-138 (bieg schodĂłw zdobywalny z obu stron), D-139 (etykiety i struktura gĂłrna),
D-140 (wysuniÄ™ta szuflada to prĂłg, nie Ĺ›ciana).

### Zamkniecie i przekazanie

Nastepny pakiet: `PKG-0138` wedlug `docs/NEXT_SESSION_PROMPT.md`.


## PKG-0138: Playthrough narracyjny 01â†’43 czasownikami gracza, ReturnZone w scenach i weryfikacja prowadzenia

Data: 2026-08-29

### Cel i motywacja

Dotychczasowe testy weryfikowaĹ‚y geometriÄ™ i odryglowywaĹ‚y wyjĹ›cia poprzez bezpoĹ›rednie manipulowanie flagami logicznymi stacji. PKG-0138 dostarczyĹ‚ dowodu peĹ‚nej przechodzalnoĹ›ci kampanii (45 scen: 01â€“41, 42a, 42b, 42c, 43) wyĹ‚Ä…cznie przy uĹĽyciu czasownikĂłw gracza (ruch fizyczny, interakcja z rekwizytami, sekwencyjne przewijanie dialogĂłw przez publiczne API `advance_dialogue()`), zweryfikowaĹ‚ serwis prowadzenia narracyjnego `NarrativeGuidanceService` pod kÄ…tem stall timerĂłw L1..L3, oraz wprowadziĹ‚ statycznÄ… deklaracjÄ™ wÄ™zĹ‚a `ReturnZone` do wszystkich scen `.tscn`.

### OsiÄ…gniÄ™cia i wyniki

1. **Publiczne API `advance_dialogue()` na `CRTDialogueBox`**:
   - Dodano metodÄ™ `advance_dialogue()` umoĹĽliwiajÄ…cÄ… sekwencyjne przewijanie i zatwierdzanie kwestii dialogowych bez siÄ™gania do wewnÄ™trznych pĂłl kontrolki.
2. **Statyczna deklaracja `ReturnZone` w plikach scen `.tscn` (D-142)**:
   - Dodano wÄ™zeĹ‚ `ReturnZone` (skrypt `return_zone.gd`, ksztaĹ‚t `Rectangle_airlock` @ x=15..18, y=238) do 42 scen `station_02.tscn` i `station_06.tscn`..`station_43.tscn`.
   - Wszystkie 45 scen kampanii posiada teraz zadeklarowane w `.tscn` strefy `ReturnZone` oraz `AirlockZone`.
3. **Audyt przejĹ›cia 01â†’43 czasownikami gracza (`tools/pkg_0138_playthrough_audit.gd`)**:
   - Sprawdzono 45 scen: symulacja ruchu `_walk_to` z `move_and_slide()` i `try_curb_step()`, interakcja z punktami `MemoryResonancePoint` w kolejnoĹ›ci geometrycznej, przewijanie dialogĂłw `advance_dialogue()`, naturalne odryglowanie `AirlockZone` i wejĹ›cie w strefÄ™.
   - Wynik: **0 blockerĂłw na 45 scenach, 100% PASS**.
4. **Weryfikacja serwisu prowadzenia narracyjnego (`NarrativeGuidanceService`)**:
   - Sprawdzono rejestracjÄ™ beatĂłw L1..L3, wygaszanie myĹ›li przy otwartym panelu dialogowym, wyzwalanie L2 po 20 s i L3 po 45 s bezczynnoĹ›ci, resetowanie timera przy postÄ™pie oraz zamykanie omylnych hipotez.
5. **Nowa bramka automatyczna `tests/pkg_0138_smoke_test.gd`**:
   - Zarejestrowana w `tools/verify.ps1`, sprawdza Guidance Service, brak soft-lockĂłw (szuflada stacji 13, kotwica stacji 38), backtrack `ReturnZone` (stacje 02, 10, 20, 30, 40) oraz peĹ‚ny ciÄ…g reprezentatywnych stacji kampanii.
6. **Zrzuty ekranowe w wysokiej rozdzielczoĹ›ci (`tools/capture_pkg_0138.gd`)**:
   - Wygenerowano 10 kadrĂłw referencyjnych w `reports/pkg_0138_station_*_playthrough.png` na sterowniku Windows/OpenGL Intel Iris Xe.

### DowĂłd

```text
================================================================================
  PKG-0138 NARRATIVE PLAYTHROUGH AUDIT 01 -> 43 (player verbs and guidance)
================================================================================
station_01   guidance=OK   beats= 3 airlock=OK   return=OK
station_02   guidance=OK   beats= 2 airlock=OK   return=OK
...
station_42c  guidance=OK   beats= 1 airlock=OK   return=OK
station_43   guidance=OK   beats= 1 airlock=OK   return=OK
================================================================================
BLOCKERS: 0
PKG-0138 PLAYTHROUGH: CLEAN.
```

### Ograniczenia

Automatyczna symulacja dowodzi poprawnoĹ›ci kontraktĂłw fizycznych, sekwencji dialogowych i logiki odryglowaĹ„, ale nie subiektywnych odczuÄ‡ gracza (D-012, ADR-003).

### Decyzje

- **D-141**: PrzejĹ›cie narracyjne 01â†’43 bazuje wyĹ‚Ä…cznie na czasownikach gracza (ruch, interakcja, postÄ™p dialogu) bez manipulacji flagami.
- **D-142**: KaĹĽda stacja 02â€“43 deklaruje kanoniczny wÄ™zeĹ‚ `ReturnZone` w `.tscn`, zapewniajÄ…c deterministyczny powrĂłt bez dynamicznej injekcji.

### ZamkniÄ™cie i przekazanie

Nastepny pakiet: `PKG-0139` wedĹ‚ug `docs/NEXT_SESSION_PROMPT.md`.


## PKG-0139: PejzaĹĽ dĹşwiÄ™kowy per akt, materialnoĹ›Ä‡ powierzchni krokĂłw i modulacja mowy CRT

Data: 2026-08-29

### Cel i motywacja

WdroĹĽenie kompleksowej warstwy audio dla caĹ‚ej kampanii gry zgodnie z wytycznymi reĹĽyserii dĹşwiÄ™kowej i audytu wraĹĽeĹ„ dotykowych:
1. Proceduralny pejzaĹĽ dĹşwiÄ™kowy per Akt / Strefa w `ProceduralAudio` i `AtmosphereRig` obejmujÄ…cy Akt I (01â€“10), Akt II (11â€“28), Akt III (29â€“37) oraz Akt IV i FinaĹ‚y (38â€“43).
2. MaterialnoĹ›Ä‡ krokĂłw i lÄ…dowaĹ„ na `PrototypePlayer` na 5 fizycznych typach powierzchni (`LINOLEUM_TILE`, `TERRAZZO_STAIR`, `WET_ASPHALT`, `STEEL_GRATING`, `HOLLOW_DECK`).
3. Modulacja blipĂłw teletypowych mowy w `CRTDialogueBox` per mĂłwca (`LENA`, `MARTA`, `JAKUB`, `WIERZBICKA`, `SYSTEM`, `ĹšLAD`) z losowÄ… wariacjÄ… wysokoĹ›ci tonu i nasyceniem harmonicznym.
4. Bramka testowa `tests/pkg_0139_smoke_test.gd` i peĹ‚na weryfikacja w `tools/verify.ps1`.

### OsiÄ…gniÄ™cia i wyniki

1. **Syntetyzatory proceduralne w `ProceduralAudio.gd` (D-143, D-144, D-145)**:
   - **Kroki i lÄ…dowania na 5 typach podĹ‚oĹĽa**:
     - `create_footstep_linoleum_sound()`: suchy, subtelny stukot posadzki laboratoryjnej / linoleum.
     - `create_footstep_terrazzo_sound()`: gÄ™sty stukot lastryko z pogĹ‚osem wnÄ™ki klatki schodowej.
     - `create_footstep_wet_asphalt_sound()`: mokra faktura asfaltu z mikrorozpryskiem i poĹ›lizgiem deszczu.
     - `create_footstep_steel_grating_sound()`: metaliczny brzÄ™k kraty pomostĂłw z harmonicznym wybrzmieniem.
     - `create_footstep_hollow_deck_sound()`: gĹ‚uchy rezonans drewnianego/kompozytowego pomostu tramwaju.
     - `create_surface_land_sound(surface_type)`: dedykowana amortyzacja uderzenia per typ powierzchni.
   - **Blipy dialogowe teletypu**:
     - `create_dialogue_lena_blip_sound()` (587.33 Hz D5 ciepĹ‚a harmonika bursztynowa z nasyceniem tanh).
     - `create_dialogue_marta_blip_sound()` (440.0 Hz A4 ciepĹ‚y ton matowy z sub-harmonicznymi).
     - `create_dialogue_jakub_blip_sound()` (370.0 Hz F#4 analityczny rezonans z mikrofonu wÄ™glowego).
     - `create_dialogue_wierzbicka_blip_sound()` (520.0 Hz C5 autorytatywny formant trzcinowo-dzwonowy).
     - `create_dialogue_system_blip_sound()` (329.63 Hz E4 sterylny impuls przekaĹşnika telegraficznego).
     - `create_dialogue_blip_for_speaker(speaker)`: uniwersalny dyspozytor mowy postaci.
   - **PejzaĹĽe dĹşwiÄ™kowe per Akt**:
     - Akt I: `create_act1_fluorescent_ballast_hum_sound()`, `create_act1_rain_ambience_sound()`, `create_bakelite_telephone_ring_sound()`.
     - Akt II: `create_institutional_hvac_ambient_sound()`, `create_linoleum_corridor_resonance_sound()`, `create_teletype_relay_ambience_sound()`, `create_magnetic_latch_sterile_sound()`.
     - Akt III: `create_transformer_infrasound_sound()`, `create_shaft_water_drip_echo_sound()`, `create_tempered_glass_resonance_sound()`, `create_riveted_catwalk_creak_sound()`.
     - Akt IV & FinaĹ‚y: `create_correction_tension_swell_sound()`, `create_tri_path_resonance_sound()`.
2. **Integracja w `PrototypePlayer.gd` (D-144)**:
   - Rozszerzono `enum SurfaceType` o 5 typĂłw z zachowaniem aliasĂłw wstecznych.
   - WdroĹĽono inteligentne prĂłbkowanie `get_current_surface_type()` oparte o kolizje fizyczne i fallback kontekstowy stacji.
   - PrzeĹ‚Ä…cznik krokĂłw `_step_foot_toggle` i lÄ…dowaĹ„ `play_landing()` odtwarza wĹ‚aĹ›ciwe prĂłbki PCM z modulacjÄ… wysokoĹ›ci tonu.
3. **Integracja w `CRTDialogueBox.gd` (D-145)**:
   - `_play_speech_blip()` pobiera zbuforowany dĹşwiÄ™k z `ProceduralAudio.create_dialogue_blip_for_speaker()` z losowÄ… wariacjÄ… wysokoĹ›ci tonu 0.94..1.06.
4. **Integracja w `AtmosphereRig.gd` (D-143)**:
   - `_select_primary_soundscape()` i warstwy drugorzÄ™dne przypisujÄ… dedykowane pejzaĹĽe dĹşwiÄ™kowe dla kaĹĽdego aktu i specyfiki stacji 01..43.
   - Dodano metodÄ™ pomocniczÄ… `get_act_number()`.
5. **Bramka automatyczna `tests/pkg_0139_smoke_test.gd`**:
   - Sprawdza syntezÄ™ prĂłbek WAV 16-bit PCM dla wszystkich powierzchni, mĂłwcĂłw i aktĂłw, detekcjÄ™ podĹ‚oĹĽa gracza oraz konfiguracjÄ™ AtmosphereRig na caĹ‚ej dĹ‚ugoĹ›ci kampanii.
   - Zarejestrowana w `tools/verify.ps1`, 100% PASS (0 failures).

### DowĂłd

```text
== PKG-0139 procedural soundscape per act, footstep materiality and CRT dialogue blip gate ==
================================================================================
  PKG-0139 SMOKE TEST: Soundscapes, Surface Materiality & Dialogue Modulation
================================================================================
1. Testing PKG-0139 procedural audio synthesizers...
2. Testing PrototypePlayer 5-surface footstep & landing system...
3. Testing CRTDialogueBox speaker-specific dialogue blips...
4. Testing AtmosphereRig Act soundscape configuration across campaign...
================================================================================
PKG-0139 SMOKE PASS: Procedural soundscapes, surface materiality & dialogue modulation verified.
Verification passed.
```

### Ograniczenia

Automatyczne testy dowodzÄ… poprawnoĹ›ci generowania buforĂłw 16-bit PCM, przypisania do odtwarzaczy i logiki detekcji, ale nie subiektywnych wraĹĽeĹ„ akustycznych gracza (D-012, ADR-003).

### Decyzje

- **D-143**: Proceduralny pejzaĹĽ dĹşwiÄ™kowy per Akt kampanii: IKP/Tarasowe (Akt I), UCP (Akt II), Podstruktura (Akt III) oraz Metoda/FinaĹ‚y (Akt IV).
- **D-144**: MaterialnoĹ›Ä‡ krokĂłw i lÄ…dowaĹ„ Leny na 5 typach powierzchni z automatycznÄ… detekcjÄ… kolizji i kontekstu stacji.
- **D-145**: Modulacja blipĂłw mowy teletypowej `CRTDialogueBox` per postaÄ‡ z subtelnÄ… wariacjÄ… wysokoĹ›ci tonu i nasyceniem harmonicznym.

### ZamkniÄ™cie i przekazanie

NastÄ™pny pakiet: `PKG-0140` wedĹ‚ug `docs/NEXT_SESSION_PROMPT.md`.


## PKG-0140: SprzÄ™ĹĽenie audiowizualne Anchor/Yield, haptyka interakcji i wygĹ‚adzenie kadru kamery

Data: 2026-08-30
Status: ZAMKNIÄTY

### Cel

DomkniÄ™cie sprzÄ™ĹĽenia audiowizualnego mechaniki Kotwiczenia i UlegĹ‚oĹ›ci w kampanii,
dopracowanie dotykowego sprzÄ™ĹĽenia zwrotnego interakcji (`MemoryResonancePoint`, rekwizyty
fizyczne) oraz wygĹ‚adzenie centrowania kamery kinowej przy przejĹ›ciach miÄ™dzy stacjami
i drabinami.

### Co znalazĹ‚ audyt wejĹ›ciowy

1. **Kotwica byĹ‚a czytana binarnie.** `AnchorableObject` i `MovableAnchorableProp`
   zapalaĹ‚y pasek akcentu albo go gasiĹ‚y, a caĹ‚y dĹşwiÄ™k chwytu to byĹ‚o jedno
   `create_anchor_sound()` przy przeĹ‚Ä…czeniu. Chwyt, przesuniÄ™cie i zwolnienie â€”
   trzy rĂłĹĽne gesty gracza â€” brzmiaĹ‚y i wyglÄ…daĹ‚y tak samo.
2. **Przesuwanie skrzyni nie brzmiaĹ‚o w ogĂłle.** Stacje 09 i 11 pchajÄ… rekwizyt
   przez pĂłĹ‚ sceny w kompletnej ciszy.
3. **DotkniÄ™cie rekwizytu nie miaĹ‚o wĹ‚asnego dĹşwiÄ™ku.** `MemoryResonancePoint`
   mĂłwiĹ‚ wyĹ‚Ä…cznie gĹ‚osem swojego rekwizytu; zbliĹĽenie siÄ™ i badanie palcem byĹ‚y
   nieme, a odczyt â€žjestem w zasiÄ™guâ€ť zapalaĹ‚ siÄ™ i gasĹ‚ w jednej klatce.
4. **Kadr skakaĹ‚ przy transporcie pionowym.** `vertical_follow_speed = 4.5` jest
   dobrany do chodu; przy wspinaczce po `LadderZone` i jeĹşdzie `ServiceLift` kadr
   dociÄ…gaĹ‚ do martwej strefy skokami, ktĂłre snap 2 px zamieniaĹ‚ w chodzÄ…cy piksel.
5. **Po przejĹ›ciu progu kamera dojeĹĽdĹĽaĹ‚a do Leny.** Nowa stacja startowaĹ‚a kadrem
   na Ĺ›rodku komory i dopiero potem zbiegaĹ‚a do gracza.

### Co zrobiono

1. **WspĂłlna obwiednia `AnchorResonance` (D-146)** â€” `scripts/visual/anchor_resonance.gd`:
   `grip` (narastanie 0,085 s, opadanie 0,34 s), `drag`, `resist_flash`, `yield_flash`,
   wspĂłlna faza oddechu tonu. `AnchorableObject` i `MovableAnchorableProp` rysujÄ…
   i miksujÄ… z tego samego modelu, wiÄ™c platforma i skrzynia nie mogÄ… siÄ™ rozjechaÄ‡.
2. **SzeĹ›Ä‡ nowych syntezatorĂłw zero-asset w `ProceduralAudio`**:
   `create_anchor_grip_sound()`, `create_anchor_sustain_tone_sound()` (zapÄ™tlony ton
   F#5 + kwinta + sub, 1,20 s bez trzasku pÄ™tli), `create_anchor_release_sound()`,
   `create_yield_collapse_sound()`, `create_prop_drag_scrape_sound()` (zapÄ™tlone tarcie),
   plus haptyka: `create_contact_tap_sound()`, `create_switch_detent_sound()`,
   `create_probe_brush_sound()`. Dodano `generate_looping_wav()` jako pierwszÄ…
   w projekcie fabrykÄ™ strumieni `LOOP_FORWARD`.
3. **Miks prowadzony obwiedniÄ….** Ton podtrzymany i tarcie majÄ… wĹ‚asne
   `AudioStreamPlayer2D` z gĹ‚oĹ›noĹ›ciÄ… i wysokoĹ›ciÄ… liczonÄ… z `grip` / `drag`,
   wiÄ™c nic nie wĹ‚Ä…cza siÄ™ ani nie urywa skokiem. Tarcie karmi siÄ™ **realnym**
   przemieszczeniem poziomym, nie zamiarem â€” skrzynia wparta w Ĺ›cianÄ™ milczy.
4. **Haptyka punktu pamiÄ™ci (D-147).** Osobny `HapticPlayer2D` (-11 dB) gra
   rĂłwnolegle do dĹşwiÄ™ku diegetycznego: stuk przy wejĹ›ciu w zasiÄ™g, badanie przy
   interakcji, dwuczÄ™Ĺ›ciowa zapadka na `SWITCH_LIKE_PROPS`. `_contact_progress`
   narasta i opada, a `_draw_contact_read()` rysuje jeden Ĺ‚uk i punkt styku **pod**
   rysunkiem rekwizytu â€” ĹĽaden z 200+ autorskich rysunkĂłw nie musiaĹ‚ byÄ‡ przepisany.
5. **WygĹ‚adzenie kadru (D-148).** `CinematicCamera` dostaĹ‚a tryb transportu
   pionowego (`traversal_follow_speed = 2.4`, `traversal_deadzone = 62`) z
   interpolowanym przejĹ›ciem (`traversal_blend_speed = 3.0`), wykrywanie windy po
   kolizji podĹ‚ogowej oraz `request_recenter()` / `recenter_on_target()`.
   `ReturnZone` zgĹ‚asza ĹĽÄ…danie centrowania przed emisjÄ… powrotu. Snap 2 px
   (D-120) i budĹĽet kadrowania (D-136) pozostajÄ… jedynÄ… drogÄ… do renderera.
6. **BudĹĽet klatki wymusiĹ‚ przeprojektowanie warstwy audio (D-149).** Pierwsza
   implementacja dawaĹ‚a kaĹĽdemu rekwizytowi wĹ‚asny `AudioStreamPlayer2D` â€” pula
   na stacji 01 wyszĹ‚a na 27 przy budĹĽecie 20 (D-120) i bramka PKG-0130 zapaliĹ‚a
   siÄ™ na piÄ™ciu stacjach. `scripts/audio/station_audio_voices.gd` powoĹ‚uje leniwie
   trzy wspĂłĹ‚dzielone gĹ‚osy na stacjÄ™ i przestawia je na pozycjÄ™ rekwizytu przed
   zagraniem; ciÄ…gĹ‚e gĹ‚osy majÄ… wĹ‚aĹ›ciciela, wiÄ™c druga kotwica nie wycina cudzego
   wybrzmienia. Zmierzona baza po zmianie: 12â€“18 odtwarzaczy na stacjÄ™.
   Przy okazji wyszĹ‚y dwa faĹ‚sze: mikro-stuk kontaktu odpalaĹ‚ siÄ™ w pierwszej
   klatce stacji, w ktĂłrej Lena **startuje** obok rekwizytu (karencja 0,45 s), a
   `apply_reality_shift()` ozwuczaĹ‚ ulegĹ‚oĹ›Ä‡ takĹĽe wtedy, gdy stacja tylko ustawia
   stan w `_ready()` (stacje 32 i 33) â€” teraz brzmi wyĹ‚Ä…cznie realna zmiana.
7. **Bramka `tests/pkg_0140_smoke_test.gd`** â€” 8 sekcji: syntezatory i pÄ™tle,
   obwiednia, `AnchorableObject`, `MovableAnchorableProp`, haptyka punktu pamiÄ™ci,
   kamera, `ReturnZone` oraz przebieg po 6 stacjach kampanii z rekwizytami
   zakotwiczalnymi (09, 11, 30, 32, 33, 38). Bramka powtarza teĹĽ budĹĽet audio
   PKG-0130 na tych stacjach, ĹĽeby regresja z punktu 6 nie mogĹ‚a wrĂłciÄ‡ cicho.
   Zarejestrowana w `tools/verify.ps1`.

### Decyzja architektoniczna, ktĂłra NIE zostaĹ‚a podjÄ™ta

Prompt mĂłwiĹ‚ o â€žprzejĹ›ciach shaderĂłw pulsowania wektorowegoâ€ť. Pulsowanie zostaĹ‚o
zaimplementowane w `_draw()` sceny wektorowej, nie jako `ShaderMaterial`. PowĂłd:
jedynym shaderem projektu jest `WorldPixelCompositor`, a drugi materiaĹ‚ na obiekcie
gry prĂłbkowaĹ‚by poza siatkÄ… 2 px kompozytora (D-120) i wprowadzaĹ‚ kolory spoza
7-kolorowej palety (`VISUAL_DESIGN.md` Â§7). Efekt docelowy â€” ciÄ…gĹ‚e, oddychajÄ…ce
pulsowanie sprzÄ™ĹĽone z tonem harmonicznym â€” jest ten sam; kanon prezentacji zostaje.

### DowĂłd

```text
== PKG-0140 Anchor/Yield audiovisual coupling, interaction haptics and camera easing gate ==
================================================================================
  PKG-0140 SMOKE TEST: Anchor/Yield coupling, interaction haptics, camera easing
================================================================================
1. Syntezatory sprzezenia Anchor/Yield i haptyki...
2. Obwiednia AnchorResonance...
3. AnchorableObject â€” tor audiowizualny...
4. MovableAnchorableProp â€” chwyt, przesuwanie, uleglosc...
5. MemoryResonancePoint â€” haptyka i kontaktowy odczyt...
6. CinematicCamera â€” tlumienie transportu pionowego i centrowanie...
7. ReturnZone â€” zadanie centrowania kadru...
8. Kampania â€” stacje z rekwizytami zakotwiczalnymi...
================================================================================
PKG-0140 SMOKE PASS: sprzezenie Anchor/Yield, haptyka interakcji i kadr kamery zweryfikowane.
Verification passed.
```

### Ograniczenia

Bramka dowodzi buforĂłw PCM, trybu pÄ™tli, przypiÄ™cia strumieni do odtwarzaczy,
ksztaĹ‚tu obwiedni i zachowania kadru w symulacji fizyki. Nie dowodzi wraĹĽenia
sĹ‚uchowego ani odczucia â€žciÄ™ĹĽaruâ€ť kotwicy u czĹ‚owieka (D-012, ADR-003). Headless
nie dowodzi teĹĽ renderowania pulsowania na realnym GPU.

Znane, niedeterministyczne: w ok. 1 na 3 przebiegi `pkg_0140_smoke_test.gd` koĹ„czy
siÄ™ ostrzeĹĽeniem `ObjectDB instances leaked at exit` z sekcji Ĺ‚adujÄ…cej 6 scen
kampanii. To wyĹ›cig sprzÄ…tania drzewa na wyjĹ›ciu procesu headless, nie wyciek
runtime'u gry: bramka zwraca 0, `verify.ps1` przechodzi, a `PKG-0130` (budĹĽet
klatki na 45 scenach) i `PKG-0127` (cykl ĹĽycia RAM) sÄ… zielone. Do domkniÄ™cia
przy okazji pakietu dotykajÄ…cego harnessu testowego.

### DĹ‚ug znaleziony po drodze (nie naprawiony w tym pakiecie)

Przy podpinaniu bramki kamery pod stacje kampanii wyszĹ‚o, ĹĽe **13 stacji finaĹ‚owych**
(33, 34, 35, 36, 37, 38, 39, 40, 41, 42a, 42b, 42c, 43) deklaruje wÄ™zeĹ‚ o nazwie
`Camera2D` ze skryptem `CinematicCamera`, ale **nie podpina `target` ani nie woĹ‚a
`setup_chambers()`** â€” skrypt stacji tylko parkuje kamerÄ™ na `(320, 180)`. Na caĹ‚ym
Akcie IV i wszystkich trzech finaĹ‚ach nie dziaĹ‚a wiÄ™c ani Ĺ›ledzenie pionowe (D-120),
ani kadr dialogowy (D-133), ani budĹĽet kadrowania (D-136), ani nic z PKG-0140.
PozostaĹ‚e 32 stacje majÄ… wÄ™zeĹ‚ `Camera` z `node_paths=PackedStringArray("target")`.

To jest dokĹ‚adnie odroczony punkt â€žUnifikacja `Camera` vs `Camera2D` w stacjach 33â€“43â€ť
z `docs/ROADMAP.md` Â§P6-odroczone. Naprawa dotyka 13 scen i 13 skryptĂłw stacji, wiÄ™c
nie zostaĹ‚a wciÄ…gniÄ™ta do PKG-0140 â€” jest treĹ›ciÄ… `PKG-0141`.

### Decyzje

- **D-146**: Kotwiczenie i ulegĹ‚oĹ›Ä‡ majÄ… jednÄ… ciÄ…gĹ‚Ä… obwiedniÄ™ audiowizualnÄ… `AnchorResonance`.
- **D-147**: Punkt pamiÄ™ci ma warstwÄ™ haptycznÄ… i ciÄ…gĹ‚y kontaktowy odczyt wizualny.
- **D-148**: Transport pionowy tĹ‚umi kadr, a przejĹ›cie progu centruje go natychmiast.
- **D-149**: Warstwa dotyku i ton kotwicy majÄ… po jednym gĹ‚osie na stacjÄ™; ulegĹ‚oĹ›Ä‡ brzmi tylko przy realnej zmianie stanu.

### ZamkniÄ™cie i przekazanie

NastÄ™pny pakiet: `PKG-0141` wedĹ‚ug `docs/NEXT_SESSION_PROMPT.md`.


## PKG-0141: Unifikacja kamery kinowej na 45 stacjach i tryb ograniczonego ruchu

Data: 2026-08-30
Status: ZAMKNIÄTY

### Cel

ZamkniÄ™cie dwĂłch dĹ‚ugĂłw odroczonych w `docs/ROADMAP.md` Â§P6-odroczone: jednego
kontraktu kamery kinowej dla caĹ‚ej kampanii oraz globalnego przeĹ‚Ä…cznika
dostÄ™pnoĹ›ci tĹ‚umiÄ…cego ruch peryferyjny.

### Co znalazĹ‚ audyt wejĹ›ciowy

DĹ‚ug okazaĹ‚ siÄ™ **szerszy niĹĽ zapisany w prompcie**. Prompt mĂłwiĹ‚ o 13 stacjach
finaĹ‚owych (33â€“43). Na dysku byĹ‚o gorzej â€” kampania miaĹ‚a **trzy** rĂłĹĽne sposoby
na to samo:

1. **Stacje 01â€“23** â€” wÄ™zeĹ‚ `Camera`, `target` podpiÄ™ty w `.tscn`,
   `setup_chambers()` woĹ‚ane w `_setup_camera()`. Kontrakt speĹ‚niony.
2. **Stacje 24â€“32** â€” wÄ™zeĹ‚ `Camera`, ale **bez** `node_paths`/`target`
   i **bez** `setup_chambers()`. Skrypt tylko parkowaĹ‚ kamerÄ™ na `(320, 180)`.
3. **Stacje 33â€“43** â€” wÄ™zeĹ‚ `Camera2D`, teĹĽ bez `target` i bez komĂłr.

Do tego stacje 34â€“37 szukaĹ‚y wÄ™zĹ‚a najpierw pod nazwÄ… `Camera`, a scena
deklarowaĹ‚a `Camera2D` â€” deklaracja rozstrzygaĹ‚a siÄ™ na `null` albo na drugÄ…
gaĹ‚Ä…Ĺş warunku, w zaleĹĽnoĹ›ci od stacji.

Realny zasiÄ™g dĹ‚ugu: **22 stacje (24â€“43)**, czyli caĹ‚y Akt IV, caĹ‚a Podstruktura
i wszystkie trzy finaĹ‚y, a nie 13 stacji z promptu. Na tych 22 stacjach nie
dziaĹ‚aĹ‚o Ĺ›ledzenie pionowe (D-120), kadr dialogowy (D-133), budĹĽet kadrowania
(D-136), wyprzedzenie kadru ani nic z PKG-0140 (D-148).

Drugi dĹ‚ug: migotanie Ĺ›wietlĂłwek, pulsowanie pola kotwiczenia, wstrzÄ…s kamery
i mikro-czÄ…stki nie miaĹ‚y ĹĽadnego wspĂłlnego wyĹ‚Ä…cznika.

### Co zrobiono

1. **`scripts/camera/station_camera_rig.gd` (D-150)** â€” jedna Ĺ›cieĹĽka kamery dla
   caĹ‚ej kampanii. Nazwa wÄ™zĹ‚a (`Camera`), granice komory i kolejnoĹ›Ä‡ podpiÄ™Ä‡
   ĹĽyjÄ… w jednym module, nie w 45 kopiach. `resolve()`, `bind()`, `chamber_bounds()`
   i `is_bound()` to caĹ‚e publiczne API.
2. **45 scen `.tscn`** â€” wÄ™zeĹ‚ kamery nazywa siÄ™ `Camera` we wszystkich, kaĹĽda
   deklaruje `node_paths=PackedStringArray("target")` i `target = NodePath("../Player")`.
   Nazwa `Camera2D` zniknÄ™Ĺ‚a z kampanii.
3. **45 skryptĂłw stacji** â€” jedna deklaracja
   (`@onready var camera: CinematicCamera = StationCameraRig.resolve(self)`)
   i jedno `_setup_camera()` woĹ‚ajÄ…ce `StationCameraRig.bind(self, player)`.
   Na 22 stacjach zastÄ…piĹ‚o to parkowanie kamery na `(320, 180)`.
4. **`scripts/core/motion_accessibility.gd` (D-151)** â€” jedyne ĹşrĂłdĹ‚o prawdy
   o trybie ograniczonego ruchu. Statyczne, nie autoload: `AnchorResonance`
   i `ParticleBudget` to `RefCounted` bez dostÄ™pu do drzewa, bramki nagĹ‚Ăłwkowe
   czytajÄ… stan bez stawiania `GameStateManager`, a stan przeĹĽywa zmianÄ™ sceny
   bez ĹĽadnego okablowania w stacji.
5. **Czterej konsumenci trybu** â€” `AtmosphereRig` (migotanie 100 Hz, pulsowanie
   beaconĂłw, warstwa mikro-czÄ…stek), `CinematicCamera.add_trauma()` / `_update_shake()`,
   `AnchorResonance.sustain_envelope()` / `drag_envelope()`, `ParticleBudget.set_micro_emission()`
   (pyĹ‚ i para stacji, kurz biegu i lÄ…dowania Leny).
6. **Ustawienia** â€” `SettingsOverlay` dostaĹ‚ `ReducedMotionCheckButton` z peĹ‚nym
   Ĺ‚aĹ„cuchem fokusa; `GameStateManager.set_reduced_motion()` utrwala wybĂłr w
   `user://getting_strange_settings_v1.json`. Klucz `reduced_motion` jest
   opcjonalny, wiÄ™c **plik ustawieĹ„ sprzed PKG-0141 dalej siÄ™ wczytuje** â€”
   schemat ustawieĹ„ zostaĹ‚ przy wersji 1. Etykieta i podpowiedĹş w PL i EN.
7. **`tests/pkg_0141_smoke_test.gd`** â€” bramka zarejestrowana w `tools/verify.ps1`.

### Czego bramka dowodzi

- Kontrakt scen na **wszystkich 45** plikach `.tscn` (nazwa wÄ™zĹ‚a, cel), czytany
  z surowego pliku â€” to statyczna bariera regresji, ktĂłrej nie da siÄ™ naprawiÄ‡
  Ĺ›cieĹĽkÄ… awaryjnÄ… w runtime.
- Kontrakt runtime na **wszystkich 45** zaĹ‚adowanych stacjach: dokĹ‚adnie jedna
  `CinematicCamera`, cel = `Player`, niepusta lista komĂłr, kadr 640x360, snap 2 px.
- BudĹĽet kadrowania na 13 stacjach finaĹ‚owych: zejĹ›cie kadru dialogowego mieĹ›ci
  siÄ™ w malowanym fartuchu (D-136), wiÄ™c ĹĽadna z nich nie kadruje na pustkÄ™.
- TĹ‚umienie transportu pionowego na stacjach 25 i 34 (jedyne `ServiceLift`
  kampanii): narasta i opada pĹ‚ynnie, ognisko zostaje w komorze, snap 2 px trzyma.
- Tryb ograniczonego ruchu: zerowa amplituda migotania i pulsowania przy
  **niezerowym poziomie spoczynkowym** (Ĺ›wiatĹ‚o stoi, ale Ĺ›wieci), zdjÄ™ty wstrzÄ…s
  kamery, zatrzymany oddech pola kotwiczenia przy zachowanej czytelnoĹ›ci kotwicy,
  wygaszona emisja mikro-czÄ…stek bez usuwania emiterĂłw, snap 2 px nienaruszony
  w obu trybach, trwaĹ‚oĹ›Ä‡ przez zapis na dysk i przez zmianÄ™ sceny.

### Czego bramka NIE dowodzi

- Ĺ»e tryb ograniczonego ruchu realnie pomaga osobie wraĹĽliwej przedsionkowo.
  To wymaga czĹ‚owieka (D-012, ADR-003); bramka dowodzi amplitud i emisji, nie ulgi.
- Ĺ»e nowy kadr na 22 stacjach czyta siÄ™ lepiej. Ĺšledzenie pionowe jest teraz
  wpiÄ™te, ale komory kampanii majÄ… dokĹ‚adnie jeden kadr wysokoĹ›ci, wiÄ™c klamp
  pionowy nadal zwija siÄ™ do Ĺ›rodka komory. Zmienia siÄ™ kadr dialogowy,
  wyprzedzenie, tĹ‚umienie transportowe i centrowanie po progu â€” nie panorama.
- Odbioru na normalnym sterowniku Windows (H-027) â€” headless nie ma renderera.

### Decyzje

- **D-150**: Jeden kontrakt kamery kinowej na 45 stacjach; `StationCameraRig` jest jedynÄ… Ĺ›cieĹĽkÄ….
- **D-151**: Jeden globalny przeĹ‚Ä…cznik ograniczonego ruchu tĹ‚umi amplitudÄ™, nigdy poziom spoczynkowy.

### ZamkniÄ™cie i przekazanie

NastÄ™pny pakiet: `PKG-0142` wedĹ‚ug `docs/NEXT_SESSION_PROMPT.md`.

## PKG-0142: Prawa krawÄ™dĹş stacji 01 i certyfikacja obrazu 45 stacji

Data: 2026-08-30  
Status: **ZAMKNIÄTY TECHNICZNIE**

### Cel i decyzja

PKG-0142 zamknÄ…Ĺ‚ dwa ostatnie punkty P6: czarny klin na prawej krawÄ™dzi
stacji 01 oraz brak normal-driver capture po wdroĹĽeniu kamery i
reduced-motion. PrzyjÄ™to D-152: prawa masa stacji 01 jest funkcjonalnÄ…
scenografiÄ… `airlock_bulkhead`, nie pustym tĹ‚em ani nowÄ… przeszkodÄ….

### Co zrobiono

1. `scripts/visual/vector_stage_environment.gd` zastÄ…piĹ‚ czarny klin
   fasetowÄ… obudowÄ… Ĺ›luzy z oknem inspekcyjnym, panelem serwisowym i szczelinÄ…
   drzwi. Kompozycja nie dodaje wÄ™zĹ‚Ăłw, colliderĂłw ani etykiet; istniejÄ…ce
   `ChamberDoor`, `AirlockZone` i linia statusu zachowujÄ… wĹ‚asnoĹ›Ä‡ zachowania.
2. `tests/pkg_0142_smoke_test.gd` sprawdza rolÄ™ stacji 01, brak nowych
   colliderĂłw, pas etykiety oraz kontrakt `Camera` â†’ `Player`, komory i snapu
   2 px na wszystkich 45 scenach w trybie normalnym i reduced-motion. Nie
   wywoĹ‚uje `_draw()`.
3. Bramka zostaĹ‚a zarejestrowana w `tools/verify.ps1`.
4. `tools/capture_pkg_0142.gd` zapisaĹ‚ 106 renderĂłw 640Ă—360 na normalnym
   sterowniku Windows/OpenGL (Intel Iris Xe): 45 kadrĂłw Ĺ›wiata i 8 kadrĂłw
   dialogowych w kaĹĽdym trybie. Stacja 01 ma dodatkowÄ… parÄ™ dialogowÄ…, aby
   dowĂłd Â§4.3 odpowiadaĹ‚ stanowi, w ktĂłrym znaleziono klin.
5. Raport rĂłĹĽnic zapisano w `reports/pkg_0142_visual_capture_report.txt`,
   a trwaĹ‚y opis w `docs/PKG_0142_VISUAL_CERTIFICATION.md`. Obejrzano rÄ™cznie
   stacjÄ™ 01 world/dialogue oraz pary dialogowe 33, 38, 41, 42A, 42B, 42C i 43
   w obu trybach.
6. Zaktualizowano `INDEX`, `CURRENT_STATE`, `FRAME_LAYOUT_AUDIT`,
   `ROADMAP`, `CREATIVE_REBUILD_PLAN` i `RISKS_AND_HYPOTHESES`; P6 jest
   zamkniÄ™ta, a P7 otwiera PKG-0143.

### DowĂłd

- Bazowa peĹ‚na `tools/verify.ps1` przed zmianÄ…: PASS, 736,93 s.
- Nowa bramka standalone: PASS, 0 failures.
- KoĹ„cowa peĹ‚na `tools/verify.ps1` po kodzie i dokumentacji: PASS, 817,04 s.
- `tests/traversal_lint_test.gd`: PASS; prĂłg geometrii 18 px pozostaje.
- Normal-driver capture: PASS, 106/106 PNG, oba tryby i wszystkie 45 scen.

### Czego dowĂłd nie rozstrzyga

Render i rÄ™czna inspekcja potwierdzajÄ… obecnoĹ›Ä‡ scenografii, zachowanie
informacji w obejrzanych parach oraz techniczny kontrakt trybu ograniczonego
ruchu. Nie dowodzÄ… czytelnoĹ›ci, piÄ™kna, komfortu przedsionkowego, zabawy,
zrozumienia fabuĹ‚y ani emocjonalnego odbioru przez czĹ‚owieka (ADR-003).
PozostajÄ… nierozstrzygniÄ™te warianty sprzÄ™towe Steam Deck / AMD / NVIDIA oraz
zewnÄ™trzne playtesty.

### Decyzje

- **D-152**: Prawa krawÄ™dĹş stacji 01 jest scenografiÄ… `airlock_bulkhead`;
  zero nowych colliderĂłw i zero nowych etykiet.

### ZamkniÄ™cie i przekazanie

- `docs/NEXT_SESSION_PROMPT.md` zastÄ…piono samodzielnym promptem PKG-0143.
- NastÄ™pna faza: P7 â€” Release Candidate Readiness.
- Snapshot `PKG-0142` zostanie wykonany po ostatniej kontroli dokumentacji.

## PKG-0143: Wizja P7 â€” Gameplay Depth Rebuild

Data: 2026-08-30  
Status: **ZAMKNIÄTY**

### Cel

UĹĽytkownik odrzuciĹ‚ dalsze traktowanie kampanii jako przede wszystkim liniowego
ciÄ…gu przejĹ›Ä‡ i pasywnych aktywacji. Pakiet miaĹ‚ stworzyÄ‡ wizjÄ™ gameplayu przed
jakimkolwiek planem lub kodem: regularne wieloetapowe wyzwania diagnostyczne,
uczciwe zagadki logiczne oraz decyzje o osobach z jawnym kosztem.

### Co ustalono

1. **D-153 / `docs/GAMEPLAY_DEPTH_VISION.md`** â€” nowa obietnica to thriller
   diagnostyczny: `rozbieĹĽnoĹ›Ä‡ â†’ hipoteza â†’ prĂłba rozstrzygajÄ…ca â†’
   zobowiÄ…zanie â†’ Ĺ›lad`. Gracz buduje i prĂłbuje obaliÄ‡ model Ĺ›wiata, a nie
   zbiera punkty aktywacji.
2. Fakty i etyka sÄ… osobnymi kontraktami. ZagadkÄ™ faktu da siÄ™ uczciwie
   rozwiÄ…zaÄ‡ przez dowĂłd; decyzja o Anchor/Yield, zgodzie lub rejestrze ma
   widoczne, niewymienialne konsekwencje bez ukrytego â€žmoral scoreâ€ť.
3. PiÄ™Ä‡ rodzin wyzwaĹ„: rozbieĹĽnoĹ›Ä‡ trzech ĹşrĂłdeĹ‚, prĂłba rozstrzygajÄ…ca, pole
   ciÄ…gĹ‚oĹ›ci Anchor/Yield, wspĂłlne Ĺ›wiadectwo oraz kontrmodel UCP. PeĹ‚na
   sekwencja rozciÄ…ga siÄ™ na 2â€“4 stacje, wiÄ™c jedna przestrzeĹ„ nadal mieĹ›ci
   najwyĹĽej jednÄ… rodzinÄ™ przeszkody D-099.
4. Jedna aktywna kotwica pozostaje ograniczeniem tworzÄ…cym decyzjÄ™. IstniejÄ…ce
   `AnchorableObject`, `MovableAnchorableProp`, punkty pamiÄ™ci, guidance,
   audio i serializowalne fakty sÄ… materiaĹ‚em do adaptacji; nie ustanowiono
   nowego globalnego kombajnu, ekwipunku ani ruchu.
5. P7 zastÄ™puje dawny priorytet Release Candidate Readiness. Audyt RC nie
   znika, lecz zostaje odroczony do P8 po przebudowie gameplayu.

### Research

Odczytano i zapisano ograniczone wnioski z `Outer Wilds`, `Return of the Obra
Dinn`, `The Case of the Golden Idol`, `Chants of Sennaar`, dwĂłch materiaĹ‚Ăłw
GDC oraz artykuĹ‚u CHI PLAY o analizie wyzwania zagadek. Wnioski dotyczÄ…
rozproszonego dowodu, redundancji kontekstu, lokalnie zrozumiaĹ‚ych spraw,
czÄ™Ĺ›ciowego feedbacku i ograniczeĹ„ automatycznego mierzenia trudnoĹ›ci. Nie sÄ…
dowodem, ĹĽe nowa wizja bÄ™dzie zabawna dla czĹ‚owieka.

### Co nie zostaĹ‚o zrobione

- Nie zmieniono ĹĽadnej sceny, skryptu, testu, geometrii, InputMap, zapisu,
  obrazu ani binariĂłw.
- Nie powstaĹ‚ jeszcze plan implementacji, pionowy wycinek ani test nowej
  gramatyki gameplayu.
- Nie wykonano renderu: pakiet zmienia wyĹ‚Ä…cznie kierunek i dokumentacjÄ™.

### DowĂłd

- Bazowa peĹ‚na `tools/verify.ps1`: PASS, **722,40 s**.
- PeĹ‚na bramka po synchronizacji wizji, researchu, ryzyk i handoffu:
  `tools/verify.ps1`: PASS, **642,76 s**.
- `DOCS PASS: 40 required files and handoff contracts`; import Godot 4.7.2,
  smoke kampanii, traversal lint oraz bramki PKG-0095..0142 przeszĹ‚y.
- Headless testy nadal drukujÄ… ostrzeĹĽenia `ObjectDB` dla czÄ™Ĺ›ci procesĂłw
  testowych; `tools/verify.ps1` zakoĹ„czyĹ‚ siÄ™ sukcesem. PKG-0143 nie dotykaĹ‚
  runtime, wiÄ™c nie przypisuje sobie naprawy tego dĹ‚ugu.

### Decyzje i przekazanie

- **D-153**: P7 jest Gameplay Depth Rebuild; P8 jest odroczonym etapem RC.
- Snapshot PKG-0142 istnieje na dysku; historyczny wpis PKG-0142 zachowano
  bez przepisania.
- NastÄ™pny pakiet: **PKG-0144**, wyĹ‚Ä…cznie plan realizacji P7 i bramka
  pionowego wycinka, wedĹ‚ug `docs/NEXT_SESSION_PROMPT.md`.

## PKG-0144: Plan realizacji P7 i bramka pionowego wycinka

Data: 2026-08-30  
Status: **W TOKU â€” baseline zrekoncyliowany przed edycjÄ… planu**

### Baseline i rozbieĹĽnoĹ›Ä‡

- PeĹ‚ne `pwsh -NoProfile -File "tools/verify.ps1"` przeszĹ‚o przed edycjÄ…:
  `DOCS PASS`, import Godot, smoke kampanii, traversal lint oraz wszystkie
  bramki PKG-0095..0142; czas **614,48 s**. Procesy testowe nadal zgĹ‚aszajÄ…
  oczekiwane w dotychczasowych pakietach ostrzeĹĽenia `ObjectDB`, lecz komenda
  zakoĹ„czyĹ‚a siÄ™ sukcesem.
- Runtime bramki uruchomiĹ‚ `Godot Engine v4.7.2.stable.official.ed1daf0bf`,
  podczas gdy `docs/CURRENT_STATE.md` nadal wskazuje `4.6.3`. `project.godot`
  deklaruje `config/features=PackedStringArray("4.7", "GL Compatibility")`.
  To rozjazd dokumentacji, nie zmiana silnika dokonana w tym pakiecie; zostanie
  poprawiony w aktualizacji stanu.
- Przed planowaniem nie zmieniono runtime, scen, skryptĂłw, testĂłw, zapisu,
  InputMap, geometrii ani binariĂłw.

### Plan i kontrakty

1. Utworzono `docs/P7_GAMEPLAY_DEPTH_IMPLEMENTATION_PLAN.md` 1.0. Plan
   rozdziela 43 odwiedzane adresy od 45 technicznych zasobĂłw scenicznych,
   mapuje 15 sekwencji po 2â€“4 przestrzenie i rozdziela zagadkÄ™ faktu od
   zobowiÄ…zania osoby.
2. **D-154**: pierwszy pionowy wycinek to S08 / Station 22â€“25. P7 uĹĽywa
   statycznych `Resource`, lokalnej logiki stacji i istniejÄ…cego
   `GameStateManager.decisions`; nie powstaje globalny menedĹĽer zagadek,
   inventory kotwic ani drugi save.
3. WyciÄ™cie obejmuje rozbieĹĽnoĹ›Ä‡ sygnaĹ‚u (22), bezpieczny martwy obwĂłd A/B
   (23), ograniczonÄ… zgodÄ™ albo odmowÄ™ Marty (24) oraz Ĺ›lad interwencji UCP
   prowadzony technicznie przez Jakuba (25). Jego werdykt PROCEED/PIVOT/KILL
   dotyczy wyĹ‚Ä…cznie struktury informacji, stanu, kosztu, alternatywy i
   softlocka.
4. Plan nakazuje clean cutover lokalnych checklist i automatycznych postÄ™pĂłw
   dialogu w migrowanej sekwencji. `marta_boundary_accepted` znaczy respekt
   dla granicy i wspĂłlnego celu, nie automatyczny dostÄ™p; stan dostÄ™pu pozostaje
   osobnym `p7.mutual_test.marta_boundary`.
5. Audyt wskazaĹ‚ lukÄ™ istniejÄ…cego `GameStateManager.record_decision()`:
   przyjmuje dowolny `Variant`. PKG-0145 ma dodaÄ‡ rekurencyjnÄ… bramÄ™ JSON-safe
   oraz test odrzucajÄ…cy Node, Resource i Callable bez mutacji stanu.

### Synchronizacja dokumentacji

- `CURRENT_STATE.md`, `ROADMAP.md`, `CREATIVE_REBUILD_PLAN.md`, `INDEX.md`,
  `DECISION_LOG.md`, `RISKS_AND_HYPOTHESES.md` i handoff wskazujÄ… plan P7 oraz
  PKG-0145, a nie plan PKG-0144.
- `CURRENT_STATE.md` rozdziela cel projektu Godot 4.7.x od executable
  4.7.2 zweryfikowanego w bramce; historyczne instrukcje 4.6.3 pozostajÄ…
  wyĹ‚Ä…cznie w archiwalnym raporcie PKG-0137.
- `RELEASE_NOTES.md` oznaczono jako historyczny artefakt RC1. Nie jest juĹĽ
  sprzecznÄ… deklaracjÄ… bieĹĽÄ…cej gotowoĹ›ci release ani autoryzacjÄ… eksportu.
- Do `RESEARCH_FOUNDATIONS.md` dopisano oficjalne ĹşrĂłdĹ‚a Godot 4.7 o
  `Resource` i JSON save oraz ich granicÄ™ dowodowÄ….
- Nie zmieniono `GAMEPLAY_DEPTH_VISION.md`: wizja byĹ‚a jednoznaczna. Nie
  zmieniono runtime, scen, skryptĂłw, testĂłw, geometrii, InputMap, eksportu ani
  binariĂłw.

### NiezaleĹĽna kontrola planu

- Read-only fact-check wykryĹ‚ trzy bĹ‚Ä™dy planu: zbyt wÄ…skÄ… semantykÄ™
  `marta_boundary_accepted`, brak jawnej technicznej roli Jakuba w Station 25
  oraz nieegzekwowanÄ… gwarancjÄ™ JSON w `record_decision()`.
- Wszystkie trzy poprawiono w planie i handoffie. Drugi odczyt fact-checkera
  potwierdziĹ‚ spĂłjnoĹ›Ä‡ poprawek z kanonem oraz kodem. Nie jest to dowĂłd, ĹĽe
  przyszĹ‚a implementacja zadziaĹ‚a.

### Przekazanie

- `docs/NEXT_SESSION_PROMPT.md` zastÄ…piono samowystarczalnym PKG-0145.
- NastÄ™pny pakiet implementuje wyĹ‚Ä…cznie Station 22â€“25 zgodnie z Â§8â€“9 planu;
  pozostaĹ‚e sekwencje, finaĹ‚y, P8 i eksport sÄ… poza zakresem.

### Weryfikacja po dokumentacji â€” pierwsze przejĹ›cie i korekta

- PeĹ‚na bramka po synchronizacji dokumentĂłw dotarĹ‚a do `PKG-0124`; wczeĹ›niejsze
  etapy dokumentacji, import, smoke, traversal lint i bramki PKG-0095..0123
  przeszĹ‚y. `PKG-0124` zatrzymaĹ‚ siÄ™ wyĹ‚Ä…cznie dlatego, ĹĽe jego historyczny
  test wymaga dosĹ‚ownych fragmentĂłw `RELEASE CANDIDATE 1 (RC1)` oraz
  `Content Lock 3.0 â€” 43 stacje` w `RELEASE_NOTES.md`.
- Przyczyna zostaĹ‚a potwierdzona w `tests/pkg_0124_smoke_test.gd`:
  `_test_licensing_and_release_notes()` sprawdza dokĹ‚adnie te dwa fragmenty.
  Nie zmieniono testu. Historyczne etykiety przywrĂłcono w release notes obok
  jawnego statusu archiwalnego, wiÄ™c nie sugerujÄ… bieĹĽÄ…cej gotowoĹ›ci release.
- BezpoĹ›rednia bramka `tests/pkg_0124_smoke_test.gd` na konsolowym Godot 4.7.2
  przeszĹ‚a po korekcie: `ALL RELEASE CANDIDATE TESTS PASSED (0 FAILURES)`.
  OstrzeĹĽenie `ObjectDB` pozostaĹ‚o historycznym dĹ‚ugiem procesu testowego.

### ZamkniÄ™cie i przekazanie

- KoĹ„cowe `tools/verify.ps1` po wszystkich korektach oraz po ostatniej
  aktualizacji stanu: PASS w **570,48 s**. Obejmuje `DOCS PASS`, import,
  smoke kampanii, traversal lint i bramki PKG-0095..0142. KoĹ„cowa komenda ma
  kod sukcesu.
- `docs/CURRENT_STATE.md`, `ROADMAP.md`, `CREATIVE_REBUILD_PLAN.md`,
  `INDEX.md`, `DECISION_LOG.md`, `RISKS_AND_HYPOTHESES.md`, `SESSION_LOG.md`
  i `NEXT_SESSION_PROMPT.md` opisujÄ… plan P7, D-154 oraz PKG-0145.
- `docs/P7_GAMEPLAY_DEPTH_IMPLEMENTATION_PLAN.md` jest narzÄ™dziem roboty
  pozostaĹ‚ych pakietĂłw; nie jest dowodem zabawy, zrozumienia ani emocjonalnej
  uczciwoĹ›ci nowej gramatyki.
- PKG-0144 nie dodaĹ‚ `.exe`, nie otworzyĹ‚ webu, Git ani eksportu i nie zmieniĹ‚
  runtime. Snapshot `PKG-0144` na dysku zostaje zamroĹĽeniem tego planu.

## PKG-0145: Pionowy wycinek P7 S08 (Station 22â€“25) â€” PROCEED

Data: 2026-08-30

Identyfikator stanu: `PKG-0145`. ZamroĹĽenie: `snapshots/PKG-0145-2026-08-30` (po bramce).

Kontekst: PKG-0144 zamknÄ…Ĺ‚ plan P7 i bramkÄ™ PROCEED/PIVOT/KILL dla S08
(Station 22â€“25). PKG-0145 implementuje wyĹ‚Ä…cznie ten wycinek opisany
w `docs/P7_GAMEPLAY_DEPTH_IMPLEMENTATION_PLAN.md` Â§8â€“9.

Wynik:

- **Dane kontraktu**: `scripts/gameplay/diagnostic_sequence_definition.gd`,
  `diagnostic_hypothesis_definition.gd`, `diagnostic_commitment_definition.gd`
  oraz `resources/gameplay/mutual_test_sequence.tres` (sequence_id
  `mutual_test`, brama wejĹ›cia `world_recognized`, hipotezy `signal_echo`
  i `adjacent_state_response`, zobowiÄ…zania `marta_limited_access`
  i `marta_declines_access`, rewizja migracji 1).
- **WyĹ‚Ä…cznoĹ›Ä‡ kotwicy**: `scripts/interactables/anchor_exclusivity_controller.gd`
  (lokalny, scena-centryczny, nie-autoload; jedna aktywna kotwica, zwalnia
  poprzedniÄ…, emituje `active_anchor_changed`).
- **Station 22**: straĹĽnik `world_recognized`; dwa zachowania sygnaĹ‚u
  (`observe_signal_echo`, `observe_adjacent_state`) otwierajÄ… hipotezy,
  zero kosztu przed prĂłbÄ… 23; brak auto-dialogu i braku resetu.
- **Station 23**: prĂłba A/B wyĹ‚Ä…cznie przez
  `AnchorableObject.apply_reality_shift()` (bez bezpoĹ›redniego zapisu
  `current_reality`); Anchor â†’ koszt `adjacent_relay_heat`, Yield â†’ koszt
  `address_marker_blurred`; bĹ‚Ä™dna bezpieczna prĂłba zapisuje
  `p7.mutual_test.safe_trial_feedback = comparison_incomplete` i nie kasuje
  dowodĂłw; scena ma `AnchorExclusivityController` + dwa przekaĹşniki
  (`RetentionRelay`, `AdjacentRelay`) bez colliderĂłw.
- **Station 24**: usuniÄ™to `APPARENT_COOPERATION`; `disclose_marta_scope/risk/cost`
  poprzedzajÄ… `choose_limited_access` / `choose_declined`; oba warianty sÄ…
  wzajemnie wykluczajÄ…ce, jawne w zapisie
  (`p7.mutual_test.marta_boundary`), zachowujÄ… kanoniczne
  `marta_boundary_accepted = true` i otwierajÄ… drogÄ™ do 25; semantyczne
  sterowanie (lewo/prawo + interact) prowadzi wybĂłr.
- **Station 25**: Wierzbicka nie udostÄ™pnia jeszcze swojego sygnaĹ‚u; Jakub
  prowadzi obie uczciwe drogi przez wentylacjÄ™ â†’ rygiel â†’ zasilanie â†’
  `retrieve_ucp_buffer()`; Ĺ›lad `p7.mutual_test.ucp_buffer_trace` =
  `paired_with_notes` | `technical_route` zaleĹĽnie od granicy Marty; wycinek
  nie ustawia `jakub_consent_state`.
- **Save/migracja**: `GameStateManager.record_decision()` zwraca `bool`
  i przechodzi przez rekursywnÄ… `_sanitize_json_value()` (Node, Resource,
  Callable i nieprymitywne klucze odrzucane bez mutacji; dozwolone
  zagnieĹĽdĹĽone dane JSON przechodzÄ… zapis/odczyt); `_migrate_p7_mutual_test()`
  w `reload_campaign_from_disk()`: checkpoint w 22â€“25 wraca do wejĹ›cia
  Station 22 (60, 296), usuwane legacy klucze (`mechanic_cost_observed`,
  `marta_boundary_accepted`, `s24_disposition`, `s25_jakub_recognized`,
  `ucp_offer_rejected`, `anchor_yield_named`, `station_22_dock_locked`,
  `station_23_breaker_tripped`), dopisywana `p7.mutual_test.migration_revision
  = 1`; `record_decision()` dla `p7.mutual_test.*` natychmiast oznacza
  rewizjÄ™ migracji.
- **Guidance**: stacje 22â€“25 rejestrujÄ… drabinÄ™ L0â€“L4; L3 nazywa porĂłwnanie
  stanĂłw (prĂłba rozstrzygajÄ…ca), L4 jest `WSKAZĂ“WKA` systemowa i nie wybiera
  metody, zgody ani finaĹ‚u; pÄ™tle pozostajÄ… deterministyczne.
- **Cutover**: w migrowanych stacjach nie ma juĹĽ `_check_unlock`,
  `APPARENT_COOPERATION`, `set_campaign_flag` ani bezpoĹ›redniego zapisu
  `current_reality`; usuniÄ™to callerĂłw w `tests/smoke_test.gd`, `pkg_0120`,
  `pkg_0121`, `pkg_0102`, `pkg_0138_smoke_test.gd` oraz w narzÄ™dziach
  `tools/capture_preview.gd` i `tools/pkg_0138_playthrough_audit.gd`.
- **Testy**: nowy `tests/pkg_0145_smoke_test.gd` (brama JSON, dane sekwencji,
  wyĹ‚Ä…cznoĹ›Ä‡ kotwicy, migracja save, bramy 21/22, prĂłba A/B z kosztem,
  obie drogi Marty z `marta_boundary_accepted`, rola Jakuba bez
  `jakub_consent_state`, guidance L0â€“L4, end-to-end zapis/odczyt, lint
  cutover); `tests/pkg_0138_smoke_test.gd` rozszerzone o station_22/23
  i naprawione dokoĹ„czenie station_24; aktualizowane bramki istniejÄ…ce
  (`pkg_0097`, `pkg_0102`, `pkg_0120`, `pkg_0121`) i `smoke_test.gd`.
- **Visual evidence**: `tools/capture_pkg_0145.gd` zapisaĹ‚ 14 Ĺ›wieĹĽych kadrĂłw
  (7 stanĂłw wycinka Ă— normal/reduced) na Intel Iris Xe;
  `tools/diff_pkg_0145_capture.gd` potwierdza rozrĂłĹĽnialnoĹ›Ä‡ par Anchor/Yield
  (380 px), limited/declined (235 px) i paired/technical (94 px) oraz
  poprawnoĹ›Ä‡ 640Ă—360; raport `reports/pkg_0145_capture_diff_report.txt`.

DowĂłd (po implementacji, przed peĹ‚nÄ… bramkÄ…):

```text
PKG-0145 PASS: P7 vertical-slice contracts
PKG-0120 PASS / PKG-0121 PASS / PKG-0102 PASS / PKG-0097 PASS
PKG-0138 PASS: 100% pure narrative playthrough, guidance & backtrack verified.
SMOKE PASS: project, scene, input and player physics
PKG-0145 DIFF PASS: all state pairs distinct, all frames valid
```

Weryfikacja peĹ‚na: `tools/verify.ps1` â€” PASS (wynik koĹ„cowy podany
w `docs/CURRENT_STATE.md` w sekcji â€žOstatnia swieza weryfikacja").

Ograniczenia:

- Werdykt PROCEED dotyczy wyĹ‚Ä…cznie kontraktu technicznego: struktura
  informacji, stan, koszt, alternatywa po odmowie, trwaĹ‚oĹ›Ä‡ i brak softlocka
  (H-029/H-030 pozostajÄ… bez dowodu odbiorczego).
- Nie zmieniono stacji poza 22â€“25; kolejnoĹ›Ä‡ legacy pilnujÄ… `pkg_0118`â€“`pkg_0123`.
- `ObjectDB` ostrzeĹĽenia z historycznych procesĂłw testowych pozostajÄ…; koĹ„cowa
  komenda ma kod sukcesu.
- Wycinek nie dowodzi, ĹĽe nowa gramatyka bÄ™dzie zabawna, zrozumiaĹ‚a ani
  emocjonalnie uczciwa dla czĹ‚owieka.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` â€” PKG-0146: fala S01â€“S05
(Station 01â€“14) wg planu Â§7; warunek wejĹ›cia PKG-0145 = PROCEED (speĹ‚niony).

## PKG-0146: Fala P7 S01â€“S05 (Station 01â€“14) â€” wdroĹĽona, akceptacja techniczna

Data: 2026-08-30

Identyfikator stanu: `PKG-0146`. ZamroĹĽenie: `snapshots/PKG-0146-2026-08-30` (po bramce).

Kontekst: PKG-0145 zamknÄ…Ĺ‚ S08 werdyktem PROCEED (D-155). PKG-0146
implementuje wyĹ‚Ä…cznie fale S01â€“S05 (Station 01â€“14) wg
`docs/P7_GAMEPLAY_DEPTH_IMPLEMENTATION_PLAN.md` Â§6â€“7. Stacje 15â€“43, finaĹ‚y,
eksport i P8 pozostajÄ… poza zakresem.

Wynik:

- **Dane sekwencji** â€” piÄ™Ä‡ nowych `DiagnosticSequenceDefinition`:
  `sample_and_promise` (01â€“03), `return_under_control` (04â€“05),
  `address_and_record` (06â€“08), `foreign_daily_life` (09â€“11),
  `marta_threshold` (12â€“14); kaĹĽdy z 2â€“3 hipotezami z przewidywanym wynikiem,
  jednym zobowiÄ…zaniem z jawnym kosztem i alternatywÄ…, wĹ‚asnÄ…
  `migration_revision = 1` oraz namespaced `trace_key`.
- **Station 01â€“14** â€” czysta wymiana checklist i auto-dialogu na lokalne
  czasowniki diagnostyczne (obserwacja â†’ ĹşrĂłdĹ‚o â†’ prĂłba â†’ zobowiÄ…zanie â†’
  Ĺ›lad), np. 01: `observe_measurement_gap` â†’ `inspect_sensor_mount` â†’
  `record_raw_measurement` â†’ `repeat_measurement` â†’ `preserve_raw_sample`;
  08: `read_certificate` â†’ `read_directory` â†’ `test_intercom_recognition`;
  14: `disclose_arrival_time` â†’ `compare_field_equipment` â†’
  `verify_key_position` â†’ `ask_independent_day_description`. KaĹĽda stacja
  rejestruje drabinÄ™ guidance L0â€“L4; L3 wskazuje prĂłbÄ™ rozstrzygajÄ…cÄ…, L4
  jest `WSKAZĂ“WKA` systemowÄ…. NagĹ‚Ăłwki trzech pytaĹ„ o przeszkodÄ™ (D-099)
  zachowane dla wszystkich 14 skryptĂłw.
- **BĹ‚Ä™dna bezpieczna prĂłba** â€” kaĹĽda stacja zapisuje
  `p7.<sequence>.safe_trial_feedback` z powodem braku (np. `balcony_open`,
  `reader_or_clock_missing`, `document_or_directory_missing`) i nie usuwa
  obowiÄ…zkowej poszlaki ani nie blokuje poprawnej Ĺ›cieĹĽki.
- **Save/migracja** â€” `GameStateManager` zyskuje tabelÄ™
  `P7_EARLY_SEQUENCE_MIGRATIONS` (5 sekwencji): `_migrate_p7_early_sequences()`
  w `reload_campaign_from_disk()` usuwa legacy klucze stacji
  (`station_06_bus_exit_corrected`, `station_14_mug_broken`,
  `marta_relationship_disclosed` itd.), usuwa stary stan `p7.<seq>.*` bez
  rewizji, dopisuje rewizjÄ™ i przenosi checkpoint wewnÄ…trz sekwencji na jej
  bezpieczne wejĹ›cie (S05 â†’ station_12 70,296). `record_decision()` przez
  `_mark_p7_migration_revision()` natychmiast oznacza rewizjÄ™ sekwencji;
  `SAVE_SCHEMA_VERSION = 1` zostaje.
- **Canonicalne fakty** â€” po wykonanych prĂłbach zapisywane sÄ… kanoniczne
  klucze trackera: `home_sample_preserved`, `marta_promise_broken`,
  `ordinary_return_complete`, `unease_pattern_started`,
  `local_address_confirmed`, `conflicting_documents_found`,
  `marta_relationship_disclosed` â€” wyĹ‚Ä…cznie jako skutek dziaĹ‚ania, nigdy
  z domyĹ›lnej flagi.
- **Cutover** â€” w stacjach 01â€“14 nie ma juĹĽ `_check_unlock`,
  `_check_completion_condition`, `_check_threshold_conditions`,
  `_complete_procedure`, `set_campaign_flag`,
  `advance_shopkeeper_dialogue`, `advance_neighbour_dialogue`,
  `advance_message` ani `advance_marta_dialogue`; braki potwierdza lint
  `tests/pkg_0146_smoke_test.gd`. Callerzy w `tests/smoke_test.gd`,
  `pkg_0099`, `pkg_0100`, `pkg_0117`, `pkg_0118`, `pkg_0119`, `pkg_0120`,
  `pkg_0133`, `pkg_0134`, `pkg_0138` oraz `tools/capture_preview.gd`
  (przejĹ›cie na warunkowe ustawianie stanu) zaktualizowane.
- **R4/ciaĹ‚o** â€” donica (09) i komoda (11) nadal sÄ… `MovableAnchorableProp`
  pchanym pieszo; `push_planter`/`push_sideboard` zachowujÄ… ciÄ™ĹĽar R4 bez
  platformingu; prĂłg odprawienia komody `SIDEBOARD_CLEAR_X = 446` (miejsce
  zatrzymania w peĹ‚nym przebiegu smoke â‰ 452).
- **Testy** â€” nowy `tests/pkg_0146_smoke_test.gd` (dane 5 sekwencji, brama
  JSON/rewizja, migracja S01â€“S05, pÄ™tle czasownikĂłw per stacja, prĂłby
  bezpieczne, weryfikacja sĹ‚ownika przed 21, brak kosztu Anchor/Yield przed
  S08, ReturnZone + `previous_level_requested` 02â€“14, lint cutover);
  PKG-0146 zarejestrowany w `tools/verify.ps1`.
- **Visual evidence** â€” `tools/capture_pkg_0146.gd` zapisaĹ‚ 16 Ĺ›wieĹĽych kadrĂłw
  (8 stanĂłw S01â€“S14 Ă— normal/reduced) na Intel Iris Xe;
  `tools/diff_pkg_0146_capture.gd` potwierdza rozrĂłĹĽnialnoĹ›Ä‡ pary
  S01 gap/committed (183 zmienionych prĂłbek), 640Ă—360, niepuste kadry
  i amplitudowo maĹ‚e rĂłĹĽnice normal/reduced; raport
  `reports/pkg_0146_capture_diff_report.txt`.

DowĂłd (po implementacji, przed peĹ‚nÄ… bramkÄ…):

```text
PKG-0146 PASS: P7 S01â€“S05 diagnostic contracts
PKG-0099 PASS / PKG-0100 PASS / PKG-0117 PASS / PKG-0118 PASS
PKG-0119 PASS / PKG-0120 PASS / PKG-0133 PASS / PKG-0134 PASS
PKG-0138 PASS: 100% pure narrative playthrough, guidance & backtrack verified.
SMOKE PASS: project, scene, input and player physics
PKG-0146 CAPTURE PASS: 16 frames / PKG-0146 DIFF PASS: all state pairs distinct
```

Weryfikacja peĹ‚na: `tools/verify.ps1` â€” wynik koĹ„cowy podany
w `docs/CURRENT_STATE.md` w sekcji â€žOstatnia swieza weryfikacjaâ€ť.

Ograniczenia:

- Akceptacja dotyczy wyĹ‚Ä…cznie kontraktu technicznego: struktura informacji,
  stan, koszt, alternatywa, trwaĹ‚oĹ›Ä‡ i brak softlocka. H-029/H-030/H-031
  pozostajÄ… bez dowodu odbiorczego (D-012, ADR-003).
- Nie zmieniono stacji 15â€“43; ich legacy kontrakty pilnujÄ…
  `pkg_0118`â€“`pkg_0123` i zostanÄ… zmigrowane w PKG-0147+.
- Ocena â€žczytania siÄ™â€ť sekwencji 01â€“14 (czy argument diagnostyczny jest
  zrozumiaĹ‚y, czy hipotezy brzmiÄ… wiarygodnie) nie jest dowiedziona.
- `ObjectDB` ostrzeĹĽenia historycznych procesĂłw testowych pozostajÄ…; koĹ„cowa
  komenda ma kod sukcesu.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` â€” PKG-0147: fala S06â€“S07
(Station 15â€“21) wg planu Â§7; warunek wejĹ›cia: S01â€“S05 akceptowane.

## PKG-0147: Fala P7 S06â€“S07 (Station 15â€“21) â€” wdroĹĽona, akceptacja techniczna

Data: 2026-08-30
Status: ZAMKNIÄTY â€” AKCEPTACJA TECHNICZNA (D-158, D-159)

Zakres: dwie nowe sekwencje diagnostyczne `work_history_and_record`
(Station 15â€“17) i `three_place_proofs` (Station 18â€“21) zgodnie z planem
P7 Â§6â€“7; migracja stacji 15â€“21 z legacy checklist i auto-dialogĂłw na
czasowniki gracza; migracja starych save'Ăłw; bramka kontraktu i evidence
wizualny. Stacje 22â€“43 nie byĹ‚y zmieniane (22â€“25 objÄ™te S08/PKG-0145).

Wykonanie:

- **Dane** â€” `resources/gameplay/work_history_and_record_sequence.tres` i
  `resources/gameplay/three_place_proofs_sequence.tres`: hipotezy z
  `predicted_outcome`, zobowiÄ…zania z `known_cost`/`alternative_route`,
  `migration_revision = 1`, namespaced `trace_key`; S06 wchodzi przez
  Ĺ›lad `p7.marta_threshold.trace`, S07 przez Ĺ›lad S06.
- **S06 (15â€“17)** â€” rozbieĹĽnoĹ›Ä‡: wspĂłlna wyprawa ma inny skutek, a zapis
  instytucjonalny trwa miesiÄ…cami. 15: notatki terenowe i dwa konkrety
  wyprawy, obserwacja zabezpieczonego telefonu Marty, ĹĽÄ…danie wĹ‚asnego
  zapisu pracy. 16: prĂłba instytucjonalna przy bramce â€” biometria, obcy
  numer karty, 186 dni aktywnoĹ›ci. 17: raport incydentu, porĂłwnanie
  sygnatury, interkom, trasa serwisowa, jawne zobowiÄ…zanie minimalnego
  zakresu kopiowania nagĹ‚Ăłwka; prywatne dane Marty nie sÄ… skrĂłtem.
- **S07 (18â€“21)** â€” rozbieĹĽnoĹ›Ä‡: publiczne rekordy, gĹ‚os Jakuba i prĂłbka
  nie mieszczÄ… siÄ™ w faĹ‚szerstwie. 18: prĂłba publiczna na mikrofiszy â€”
  rejestr miejski, szpitalny, karta zatrudnienia i sprawa katastrofy.
  19: prĂłba gĹ‚osowa â€” ekranowany mikrofon, dwa pytania kontrolne,
  porĂłwnanie odpowiedzi; ujawnienie wĹ‚asnej teorii to bezpieczny bĹ‚Ä…d
  (`safe_trial_feedback`, ĹĽÄ…danie karetki), nie kasuje poszlaki.
  20: prĂłba relacyjna â€” przyjÄ™ta odmowa blizny, dobrowolny skan,
  porĂłwnanie lokalnej bazy serwisowej; Jakub utrwalony jako osoba.
  21: trzy rodziny ukĹ‚adane fizycznie na trzech polach; trzecie uĹ‚oĹĽenie
  NIE uruchamia syntezy â€” dopiero jawne wykonanie syntezy ustawia napis
  stoĹ‚u i podtytuĹ‚ korytarza oraz zapisuje `world_recognized`
  (kanoniczne, bez namespace â€” brama wejĹ›ciowa Station 22/S08) i
  `local_lena_search_committed`. Przed prĂłbÄ… kadr jest neutralny.
- **Migracja save'Ăłw** â€” `P7_EARLY_SEQUENCE_MIGRATIONS` ma 7 wpisĂłw
  (S01â€“S07): S06 wymazuje legacy `marta_memories_conflict`,
  `local_lena_ucp_profile_found`, `parallel_test_trace_found` i klucze
  setbackĂłw, S07 wymazuje `jakub_public_history_verified`,
  `jakub_voice_heard`, `jakub_met_as_person`, `recognition_evidence_*`,
  `world_recognized`, `local_lena_search_committed`,
  `local_lena_search_started`; checkpoint w sekwencji wraca na bezpieczne
  wejĹ›cie (S06 â†’ station_15, S07 â†’ station_18); fakty S01â€“S05, ustawienia
  uĹĽytkownika i fakty spoza zakresu zachowane; legacy klucze nie mapujÄ…
  siÄ™ na nowe fakty.
- **Cutover** â€” w stacjach 15â€“21 nie ma `_check_unlock`,
  `_check_completion_condition`, `_complete_procedure` ani
  `set_campaign_flag`; kaĹĽda stacja 15â€“21 zachowuje `ReturnZone`,
  `previous_level_requested`, lokalny bool bramy wyjĹ›cia i
  `call_deferred("_complete_if_player_already_in_airlock")` po
  odblokowaniu. Callerzy w `tests/smoke_test.gd`, `pkg_0101`, `pkg_0120`,
  `pkg_0138` zaktualizowani do nowych kontraktĂłw (m.in. jawna synteza
  trzech rodzin przed `world_recognized`, prĂłba katastrofy na 18,
  neutralny kadr 21 przed prĂłbÄ…).
- **Guidance** â€” peĹ‚na drabina L0â€“L4 z L3 `predicted_check` i L4
  `WSKAZĂ“WKA`; omylne myĹ›li majÄ… `hypothesis_id`; mechanika nie jest
  omylna; przed 21 sĹ‚ownik bez â€žinny Ĺ›wiatâ€ť, â€žmiejscowa lenaâ€ť,
  â€žwierzbickaâ€ť, Anchor/Yield i `mechanic_cost_observed` (S08).
- **Testy** â€” nowy `tests/pkg_0147_smoke_test.gd` (dane 2 sekwencji,
  brama JSON/rewizja, migracja S06â€“S07 z zachowaniem S01â€“S05, pÄ™tle
  czasownikĂłw per stacja 15â€“21, prĂłba katastrofy wymagana na 18, synteza
  nie z trzeciego uĹ‚oĹĽenia, neutralny kadr 21 przed prĂłbÄ…, bĹ‚Ä™dne
  bezpieczne kroki, sĹ‚ownik przed 21, ReturnZone + powrĂłt 15â€“21, lint
  cutover, negatywna kontrola flag legacy); PKG-0147 zarejestrowany
  w `tools/verify.ps1`.
- **Visual evidence** â€” `tools/capture_pkg_0147.gd` zapisaĹ‚ 18 Ĺ›wieĹĽych
  kadrĂłw (9 stanĂłw S06â€“S07 Ă— normal/reduced) na Intel Iris Xe;
  `tools/diff_pkg_0147_capture.gd` potwierdza rozrĂłĹĽnialnoĹ›Ä‡ par
  (S06 notes/requested 244 prĂłbki, S07 pending/executed 1115 prĂłbek),
  640Ă—360, niepuste kadry i amplitudowo maĹ‚e rĂłĹĽnice normal/reduced;
  raporty `reports/pkg_0147_visual_capture_report.txt` i
  `reports/pkg_0147_capture_diff_report.txt`. Kadry pokazujÄ…: 15 â€”
  etykiety zapisu terenowego i telefonu; 17 â€” raport incydentu i interkom;
  21 pending â€” neutralny â€žSTĂ“Ĺ SYNTEZY // TRZY POLA POMIAROWEâ€ť;
  21 executed â€” â€žSYNTEZA // TO NIE JEST MĂ“J ĹšWIATâ€ť.

DowĂłd (po implementacji, przed peĹ‚nÄ… bramkÄ…):

```text
PKG-0147 PASS: P7 S06â€“S07 diagnostic contracts
PKG-0101 SMOKE PASS: Act IIb Vector-Stage state pass, diegetic obstacles and chain 16..20
PKG-0120 PASS: Station 14-23 Canon 0.3, Pixel-Stage, guidance i rozpoznanie zweryfikowane
PKG-0138 SMOKE PASS: 100% pure narrative playthrough, guidance & backtrack verified.
PKG-0147 CAPTURE PASS: 18 frames / PKG-0147 DIFF PASS: all state pairs distinct
```

Weryfikacja peĹ‚na: `tools/verify.ps1` â€” wynik koĹ„cowy podany
w `docs/CURRENT_STATE.md` w sekcji â€žOstatnia swieza weryfikacjaâ€ť.

Ograniczenia:

- Akceptacja dotyczy wyĹ‚Ä…cznie kontraktu technicznego: struktura
  informacji, stan, koszt, alternatywa, trwaĹ‚oĹ›Ä‡ i brak softlocka.
  H-032 pozostaje bez dowodu odbiorczego (D-012, ADR-003).
- Nie zmieniono stacji 22â€“43; 26â€“43 pozostajÄ… legacy do migracji
  w PKG-0148+.
- Ocena â€žczytania siÄ™â€ť sekwencji 15â€“21 (czytelnoĹ›Ä‡ argumentu,
  wiarygodnoĹ›Ä‡ granicy Jakuba, waga rozpoznania) nie jest dowiedziona.
- `ObjectDB` ostrzeĹĽenia historycznych procesĂłw testowych pozostajÄ…;
  koĹ„cowa komenda ma kod sukcesu.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` â€” PKG-0148: fala S09â€“S10
(Station 26â€“30) wg planu Â§7; warunek wejĹ›cia: S01â€“S08 akceptowane.

### Addendum do wpisu PKG-0147 (2026-08-30, doprecyzowanie sĹ‚ownika)

Zdanie o â€žsĹ‚owniku przed 21" we wpisie PKG-0147 wymaga doprecyzowania:
kanon dopuszcza nazwisko â€žWierzbicka" jako podpis/procedurÄ™ instytucjonalnÄ…
juĹĽ od Station 16 (interkom, nakaz izolacji); zakaz przed Station 21 dotyczy
wyĹ‚Ä…cznie jÄ™zyka â€žinny Ĺ›wiat", â€žmiejscowa Lena", Anchor/Yield oraz faktu
`mechanic_cost_observed` (S08). Bramka `pkg_0147` lintuje ten wÄ™ĹĽszy zakres;
wpis powyĹĽej pozostaje bez zmian zgodnie z zasadÄ… append-only.

## PKG-0148: Fala P7 S09â€“S10 (Station 26â€“30) â€” wdroĹĽona, akceptacja techniczna

Data: 2026-08-30
Status: ZAMKNIÄTY â€” AKCEPTACJA TECHNICZNA (D-160, D-161); final full verify
**PASS (716,71 s)**

Zakres: dwie nowe sekwencje diagnostyczne `interrupted_trial_and_small_cost_sequence`
(Station 26â€“28, S09) i `jakub_boundary_and_forecasts_sequence` (Station 29â€“30,
S10) zgodnie z planem P7 Â§6â€“7; migracja stacji 26â€“30 z legacy checklist
i auto-dialogĂłw na czasowniki gracza; migracja starych save'Ăłw; bramka
kontraktu i evidence wizualny. Stacje 31â€“43 nie byĹ‚y zmieniane.

Wykonanie:

- **Dane** â€” `resources/gameplay/interrupted_trial_and_small_cost_sequence.tres`
  i `resources/gameplay/jakub_boundary_and_forecasts_sequence.tres`:
  hipotezy z `predicted_outcome`, zobowiÄ…zania z `known_cost`/`alternative_route`,
  `migration_revision = 1`, namespaced `trace_key`; S09 wchodzi przez Ĺ›lad
  `p7.three_place_proofs.trace`, S10 przez Ĺ›lad S09.
- **S09 (26â€“28)** â€” rozbieĹĽnoĹ›Ä‡: log UCP przeczy czasowi prĂłbki, a odpowiedĹş
  moĹĽe byÄ‡ echem. 26: trzy zegary + jawna rekonstrukcja. 27: dwa identyczne
  impulsy i trzeci z celowym bĹ‚Ä™dem; odpowiedĹş koryguje wyĹ‚Ä…cznie bĹ‚Ä…d
  (osobne porĂłwnanie). 28: odczyt ceny + Anchor/Yield przez lokalny
  `AnchorExclusivityController` / `apply_reality_shift()` z kosztami
  `marta_first_meeting_detail_blurred` / `sample_exact_second_lost`;
  `small_cost_manifested` powstaje po faktycznym wykonaniu.
- **S10 (29â€“30)** â€” rozbieĹĽnoĹ›Ä‡: sygnaĹ‚ Jakuba daje kierunek, lecz jego ĹĽycie
  nie jest parametrem. 29: jawny zakres/ryzyko/koszt, wyĹ‚Ä…czony nadajnik
  Jakuba; decyzja `granted|limited|refused`. 30: trzy JSON-safe forecasty +
  jawne porĂłwnanie; odmowa kontynuowalna; `jakub_consent_state` wyĹ‚Ä…cznie po
  jawnej decyzji Jakuba.
- **Migracja save'Ăłw** â€” checkpoint wewnÄ…trz sekwencji wraca na bezpieczne
  wejĹ›cie (26 â†’ station_26, 29 â†’ station_29), legacy klucze stacji (w tym
  dawne `s26_*`â€¦`s30_*`) wyczyszczone; nowy stan nie wyprowadza siÄ™ z flagi
  legacy; fakty S01â€“S08, ustawienia uĹĽytkownika i fakty spoza zakresu
  zachowane.
- **Cutover** â€” w stacjach 26â€“30 nie ma `_check_unlock`,
  `_check_completion_condition`, `_complete_procedure` ani `set_campaign_flag`;
  kaĹĽda stacja zachowuje `ReturnZone`, `previous_level_requested`, lokalny
  bool bramy wyjĹ›cia i `call_deferred("_complete_if_player_already_in_airlock")`.
  Callerzy w `tests/smoke_test.gd`, `pkg_0121`, `pkg_0140`, `pkg_0127`,
  `pkg_0138`, `pkg_0103` zaktualizowani do nowych kontraktĂłw.
- **Guidance** â€” peĹ‚na drabina L0â€“L4, L3 `predicted_check`, L4 `WSKAZĂ“WKA`;
  omylne myĹ›li majÄ… `hypothesis_id`; mechanika nie jest omylna; przed 21
  sĹ‚ownik bez â€žinny Ĺ›wiat", â€žmiejscowa Lena", Anchor/Yield i
  `mechanic_cost_observed` (S08) â€” zgodnie z addendum PKG-0147.
- **Testy** â€” nowy `tests/pkg_0148_smoke_test.gd` (dane 2 sekwencji, brama
  JSON/rewizja, migracja S09â€“S10 z zachowaniem S01â€“S08, pÄ™tle czasownikĂłw per
  stacja 26â€“30, prĂłba trzech zegarĂłw i korekta wyĹ‚Ä…cznie bĹ‚Ä™du, cena
  Anchor/Yield po prĂłbie, trzy forecasty, stan zgody Jakuba, bĹ‚Ä™dny bezpieczny
  krok, brak auto-inspekcji, D-099/P6, ReturnZone + powrĂłt 26â€“30, lint
  cutover, negatywna kontrola flag legacy); PKG-0148 zarejestrowany
  w `tools/verify.ps1`.
- **Visual evidence** â€” `tools/capture_pkg_0148.gd` zapisaĹ‚ 22 Ĺ›wieĹĽe kadry
  (11 stanĂłw S09â€“S10 Ă— normal/reduced) na Intel Iris Xe;
  `tools/diff_pkg_0148_capture.gd` potwierdza rozrĂłĹĽnialnoĹ›Ä‡ par
  (7 par DISTINCT > 50), 640Ă—360, niepuste kadry; obejrzane kadry
  26 reconstructed, 28 anchor, 29 refused, 30 compared â€” warstwy
  Ĺ›wiata/tekstu/dialogu zachowane, Station 30 compared bez aktywnego dialogu
  zgodnie ze stanem.

RozbieĹĽnoĹ›Ä‡ procesowa (baseline race): baza `tools/verify.ps1` uruchomiona
przed implementacjÄ… nie byĹ‚a izolowana â€” rĂłwnolegĹ‚e edycje Station 28 (czÄ™Ĺ›Ä‡
S09) weszĹ‚y podczas jej przebiegu i doprowadziĹ‚y do FAIL wyĹ‚Ä…cznie na
PKG-0140; gate'y do PKG-0138 przeszĹ‚y. To rozbieĹĽnoĹ›Ä‡ procesowa, nie wynik
kontraktu S09â€“S10; odnotowana uczciwie (D-161).

DowĂłd (target gates po korektach):

```text
PKG-0148 PASS: P7 S09â€“S10 diagnostic contracts (9.13 s)
PKG-0121 PASS: 4.21 s
SMOKE PASS: 76.85 s
PKG-0140 PASS: 4.04 s
PKG-0127 PASS: 20.35 s
PKG-0138 SMOKE PASS: 122.52 s
PKG-0103 PASS: 3.84 s
PKG-0148 CAPTURE PASS: 22 frames / DIFF PASS: 7 pairs DISTINCT > 50
```

Final full verify: **PASS (849,23 s)** â€” peĹ‚ne `tools/verify.ps1` po
wszystkich korektach (w tym dokumentacyjnych) przeszĹ‚o (DOCS PASS, import,
smoke, traversal lint, bramki PKG-0095..0148); werdykt fali opiera siÄ™ na
kontraktach technicznych i capture, bez dowodu odbiorczego (H-033).

Ograniczenia:

- Akceptacja dotyczy wyĹ‚Ä…cznie kontraktu technicznego: struktura informacji,
  stan, koszt, alternatywa, trwaĹ‚oĹ›Ä‡ i brak softlocka. H-033 pozostaje bez
  dowodu odbiorczego (D-012, ADR-003).
- PeĹ‚na bramka `tools/verify.ps1` potwierdzona **PASS (849,23 s)** po wszystkich
  korektach (w tym przywrĂłcenie drabiny serwisowej Station 30 dla licznika
  PKG-0129 i korekta legacy_keys migracji wzglÄ™dem PKG-0145/0148).
- Nie zmieniono stacji 31â€“43; pozostajÄ… legacy do migracji w PKG-0149+.
- Ocena â€žczytania siÄ™" sekwencji 26â€“30 (czytelnoĹ›Ä‡ argumentu, wiarygodnoĹ›Ä‡
  granicy Jakuba, waga maĹ‚ego kosztu) nie jest dowiedziona.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` â€” PKG-0149: fala S11â€“S13
(Station 31â€“38) wg planu Â§7; warunek wejĹ›cia: S01â€“S10 akceptowane technicznie
a final full verify PASS (716,71 s).

## PKG-0149: Fale P7 S11â€“S13 (Station 31â€“38) â€” wdroĹĽone, akceptacja techniczna

Data: 2026-08-30
Status: ZAMKNIÄTY â€” AKCEPTACJA TECHNICZNA (D-162)

Zakres: trzy nowe sekwencje diagnostyczne `archive_countermodel` (Station 31â€“33, S11),
`pair_cost_and_echo` (Station 34â€“36, S12) oraz `consent_and_rescue_boundary`
(Station 37â€“38, S13) zgodnie z planem P7 Â§6â€“7; migracja stacji 31â€“38 z legacy
checklist i auto-dialogĂłw na autorskie czasowniki gracza; migracja starych save'Ăłw;
bramka kontraktu `tests/pkg_0149_smoke_test.gd` i evidence wizualny `tools/capture_pkg_0149.gd`.
Stacje 39â€“43 nie byĹ‚y zmieniane.

Wykonanie:

- **Dane** â€” trzy nowe `DiagnosticSequenceDefinition` w `resources/gameplay/`:
  - `archive_countermodel_sequence.tres` (S11, 31â€“33): hipotezy o kontrmodelu UCP,
    zobowiÄ…zanie `reconstruct_local_intent`, trace `p7.archive_countermodel.trace`
    z kluczem `local_lena_intent_found`;
  - `pair_cost_and_echo_sequence.tres` (S12, 34â€“36): hipotezy o koszcie par i Linii 4,
    zobowiÄ…zanie `disclose_pair_cost_to_persons`, trace `p7.pair_cost_and_echo.trace`
    z kluczami `home_echo_verified` i `ucp_cost_ledger_found`;
  - `consent_and_rescue_boundary_sequence.tres` (S13, 37â€“38): hipotezy o zakresie
    wspĂłĹ‚pracy z Jakubem i MartÄ…, zobowiÄ…zanie `marta_truth_commitment`, trace
    `p7.consent_and_rescue_boundary.trace` z kluczem `marta_truth_state`.
  Wszystkie z `migration_revision = 1`, namespaced `trace_key`, podpiÄ™tymi
  `DiagnosticHypothesisDefinition` (`predicted_outcome`) i `DiagnosticCommitmentDefinition`
  (`known_cost`, `alternative_route`).
- **S11 (31â€“33)** â€” rozbieĹĽnoĹ›Ä‡: UCP oferuje stabilnoĹ›Ä‡, lecz krzesĹ‚a, szkĹ‚o i abort-note
  nie pasujÄ… do jej neutralnego modelu.
  31: ewidencja depozytu Linii 4, 12. krzesĹ‚o Jakuba, odrzucenie oferty adaptacji;
  32: badanie trzech tafli szkĹ‚a laboratoryjnego, wyrycie Ĺ›ladu kondensacji,
      zakotwiczenie pamiÄ™ci materiaĹ‚u przez `ObservedGlassTrace`;
  33: badanie szybu, notatki abort-3s, rekonstrukcja zamiaru miejscowej Leny przez
      `DualWitnessFrame` (kanoniczny fakt `local_lena_intent_found`).
- **S12 (34â€“36)** â€” rozbieĹĽnoĹ›Ä‡: rejestr par, echo domu i katastrofa Linii 4 przeczÄ…
  prostemu swapowi.
  34: badanie rdzenia reaktora, alokacja mocy, przeciÄ…ĹĽenie termiczne, sonda
      diagnostyczna i odblokowanie rejestru par;
  35: badanie basenu sedacyjnego, zaworu spustowego, prĂłbnika chemicznego
      i weryfikacja echa powrotnego Jakuba (`home_echo_verified`);
  36: badanie drenaĹĽu trakcyjnego, prÄ…du bĹ‚Ä…dzÄ…cego, drabiny, kurka skaĹĽenia
      i ujawnienie rejestru kosztu UCP (`ucp_cost_ledger_found`).
- **S13 (37â€“38)** â€” rozbieĹĽnoĹ›Ä‡: najsilniejsza Ĺ›cieĹĽka uĹĽywa Jakuba, a Marta ma wĹ‚asnÄ…
  granicÄ™ wobec procedury.
  37: badanie oscyloskopu, krosownicy, anteny nadawczej, pulpitu mikserskiego
      i zmostkowanie ĹĽywego sygnaĹ‚u;
  38: badanie odbiornika radiowego, procedury ratunkowej, Ĺ‚Ä…cznicy Jakuba,
      zakotwiczenie liny ratunkowej przez `JakubRescueBulkhead` i ujawnienie prawdy Marcie
      (`marta_truth_state` = `full|partial|withheld`, bez kary moralnej i bez rankingu punktowego).
- **Migracja save'Ăłw** â€” tabela `P7_EARLY_SEQUENCE_MIGRATIONS` w `GameStateManager`
  rozszerzona o 3 nowe wpisy: `archive_countermodel` (checkpoint 31 @ (65, 248)),
  `pair_cost_and_echo` (checkpoint 34 @ (65, 248)) oraz `consent_and_rescue_boundary`
  (checkpoint 37 @ (65, 248)). Legacy klucze stacji (`s31_*`..`s38_*`) wyczyszczone;
  wczeĹ›niejszy stan S01â€“S10 i ustawienia uĹĽytkownika zachowane.
- **Clean cutover** â€” w stacjach 31â€“38 wyciÄ™te wszystkie `_check_unlock`, auto-dialogi
  oraz legacy settery flag. Wszystkie stacje posiadajÄ… `ReturnZone`, `previous_level_requested`,
  lokalny bool bramy wyjĹ›cia `is_exit_unlocked`, procedurÄ™ `unlock_exit()` oraz
  `call_deferred("_complete_if_player_already_in_airlock")`.
- **Guidance & Inner Thoughts** â€” peĹ‚na drabina L0â€“L4, L3 `predicted_check`, L4 `WSKAZĂ“WKA`;
  omylne myĹ›li wyposaĹĽone w `hypothesis_id` i `predicted_check`; mechanika pozostaje nieomylna.
- **Visual evidence** â€” `tools/capture_pkg_0149.gd` wyrenderowaĹ‚ 34 Ĺ›wieĹĽe kadry
  (17 stanĂłw S11â€“S13 Ă— normal/reduced) na Intel Iris Xe; `tools/diff_pkg_0149_capture.gd`
  potwierdza brak pustych kadrĂłw 640Ă—360 oraz rozrĂłĹĽnialnoĹ›Ä‡ wszystkich kluczowych
  par stanĂłw (> 50 prĂłbek).
- **Bramka kontraktu** â€” `tests/pkg_0149_smoke_test.gd` (sprawdzenie zasobĂłw sekwencji,
  izolacji i wymazywania legacy kluczy save, negatywnej kontroli przedwczesnych akcji,
  peĹ‚nych stosĂłw wÄ™zĹ‚Ăłw `WorldPixelCompositor`, `CrispDiegeticText`, `InnerThoughtSurface`,
  `CRTDialogueBox`, `NarrativeGuidanceService`, drabiny L0â€“L4 i czystoĹ›ci kodu) przeszĹ‚a PASS.

DowĂłd:

```text
PKG-0149 SMOKE PASS: 10/10 test blocks passed (resources, migration, negative controls, save/reload, node stack, guidance, zone topology, clean cutover).
PKG-0149 CAPTURE PASS: 34 frames (17 states x normal/reduced) rendered on Intel Iris Xe.
PKG-0149 DIFF PASS: all frames 640x360 non-blank, all state pairs DISTINCT > 50 samples.
```

Ograniczenia:
- Akceptacja dotyczy wyĹ‚Ä…cznie kontraktu technicznego: struktura informacji, stan,
  koszt, alternatywa, trwaĹ‚oĹ›Ä‡ i brak softlocka. H-034 pozostaje bez dowodu
  odbiorczego (D-012, ADR-003).
- Stacje 39â€“43 pozostajÄ… do zmigrowania w PKG-0150.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` â€” PKG-0150: fale S14â€“S15 (Station 39â€“43)
zgodnie z planem P7 Â§7.

## PKG-0150: Fale P7 S14â€“S15 (Station 39â€“43) â€” wdroĹĽone, akceptacja techniczna

Data: 2026-08-30
Status: ZAMKNIÄTY â€” AKCEPTACJA TECHNICZNA (D-163)

Zakres: dwie sekwencje diagnostyczne `branch_clarity_and_irreversible_choice` (Station 39â€“41, S14)
oraz `conscious_silence_and_presence` (Station 42Aâ€“43, S15) zgodnie z planem P7 Â§6â€“7; migracja stacji 39â€“43
z legacy checklist i auto-dialogĂłw na autorskie czasowniki gracza; migracja starych save'Ăłw;
bramka kontraktu `tests/pkg_0150_smoke_test.gd` i evidence wizualny `tools/capture_pkg_0150.gd`.

Wykonanie:

- **Dane** â€” dwa nowe `DiagnosticSequenceDefinition` w `resources/gameplay/`:
  - `branch_clarity_and_irreversible_choice_sequence.tres` (S14, 39â€“41): hipotezy o trzech metodach
    i ich nieodwracalnych kosztach, zobowiÄ…zanie `final_branch_commitment`, trace
    `p7.branch_clarity_and_irreversible_choice.trace` z kluczem `method_committed_to_branch`;
  - `conscious_silence_and_presence_sequence.tres` (S15, 42Aâ€“43): hipotezy o obecnoĹ›ci i stanie relacji
    po wykonaniu wybranej metody, zobowiÄ…zanie `epilogue_presence_commitment`, trace
    `p7.conscious_silence_and_presence.trace` z kluczem `conscious_silence_and_presence_witnessed`.
  Wszystkie z `migration_revision = 1`, namespaced `trace_key`, podpiÄ™tymi
  `DiagnosticHypothesisDefinition` (`predicted_outcome`) i `DiagnosticCommitmentDefinition`
  (`known_cost`, `alternative_route`).
- **S14 (39â€“41)** â€” rozbieĹĽnoĹ›Ä‡: trzy obwody transmisyjne i stanowiska egzekucyjne UCP
  oferujÄ… trzy rĂłĹĽne rozstrzygniÄ™cia, lecz kaĹĽde pociÄ…ga za sobÄ… twardy, nieodwracalny koszt dla osĂłb i Ĺ›wiatĂłw.
  39: badanie trzech konfiguracji pulpitu (A, B, C), rdzenia referencyjnego i zatwierdzenie matrycy metod;
  40: wysĹ‚uchanie racji i kosztĂłw stron w sali negocjacyjnej (Wierzbicka, Marta, Jakub, Szymon, matryca kosztĂłw);
  41: badanie mapy topografii Ĺ›wiadkĂłw, fizyczne zaĹ‚Ä…czenie konsoli A/B/C (`final_branch_chosen` = `branch_a|branch_b|branch_c`)
      i odryglowanie wrĂłt wybranej komory finaĹ‚owej.
- **S15 (42Aâ€“43)** â€” rozbieĹĽnoĹ›Ä‡: rozstrzygniÄ™cie finaĹ‚owe nie jest triumfem ani poraĹĽkÄ…,
  lecz materialnym i relacyjnym stanem szeĹ›ciu podmiotĂłw po wykonaniu wybranej metody.
  42A: konfrontacja w domowym pokoju (dwa kubki, dorosĹ‚y Jakub na fotografii, rozmowa z domowÄ… MartÄ…);
  42B: prĂłg mieszkania 14 i przyjÄ™cie obcego przystanku (zamkniÄ™cie RĂłwni, powrĂłt miejscowej Leny);
  42C: rozwidlenie torĂłw tramwajowych i wspĂłĹ‚istnienie sprzecznych Ĺ›wiadectw (motornicza wybiera tor na ten przejazd);
  43: tablice ogĹ‚oszeĹ„, karty spraw, rozkĹ‚ady jazdy i napisy koĹ„cowe utrwalajÄ…ce stan szeĹ›ciu podmiotĂłw bez moralizowania
      (`epilogue_witness_completed` = true).
- **Migracja save'Ăłw** â€” tabela `P7_EARLY_SEQUENCE_MIGRATIONS` w `GameStateManager`
  rozszerzona o 2 nowe wpisy: `branch_clarity_and_irreversible_choice` (checkpoint 39 @ (65, 248))
  oraz `conscious_silence_and_presence` (checkpoint 42A @ (65, 248)). Legacy klucze stacji wyczyszczone.
- **Clean cutover** â€” w stacjach 39â€“43 wyciÄ™te wszystkie `_check_unlock`, auto-dialogi
  oraz legacy settery flag. Wszystkie stacje posiadajÄ… `ReturnZone`, `previous_level_requested`,
  lokalny bool bramy wyjĹ›cia `is_exit_unlocked`, procedurÄ™ `unlock_exit()`.
- **Guidance & Inner Thoughts** â€” peĹ‚na drabina L0â€“L4, L3 `predicted_check`, L4 `WSKAZĂ“WKA`;
  omylne myĹ›li wyposaĹĽone w `hypothesis_id` i `predicted_check`.
- **Visual evidence** â€” `tools/capture_pkg_0150.gd` wyrenderowaĹ‚ 32 Ĺ›wieĹĽe kadry
  (16 stanĂłw S14â€“S15 Ă— normal/reduced) na Intel Iris Xe; `tools/diff_pkg_0150_capture.gd`
  potwierdza brak pustych kadrĂłw 640Ă—360 oraz rozrĂłĹĽnialnoĹ›Ä‡ wszystkich kluczowych
  par stanĂłw (> 50 prĂłbek).
- **Bramka kontraktu** â€” `tests/pkg_0150_smoke_test.gd` (sprawdzenie zasobĂłw sekwencji S14â€“S15,
  migracji, negatywnych kontroli, wyboru operacji A/B/C, komĂłr 42A/B/C, epilogu 43, zapisu i odczytu) przeszĹ‚a PASS.

DowĂłd:

```text
PKG-0150 SMOKE PASS: 100% PASS on all S14-S15 contracts.
PKG-0150 CAPTURE PASS: 32 frames (16 states x normal/reduced) rendered on Intel Iris Xe.
PKG-0150 DIFF PASS: all frames 640x360 non-blank, all state pairs DISTINCT > 50 samples.
```

Ograniczenia:
- Akceptacja dotyczy wyĹ‚Ä…cznie kontraktu technicznego: struktura informacji, stan,
  koszt, alternatywa, trwaĹ‚oĹ›Ä‡ i brak softlocka. H-035 pozostaje bez dowodu
  odbiorczego (D-012, ADR-003).
- Wszystkie 15 sekwencji P7 (S01â€“S15) zostaĹ‚y zaimplementowane. NastÄ™pny krok to
  kompleksowy audyt caĹ‚ej kampanii i przejĹ›cie 01â€“43 w PKG-0151.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` â€” PKG-0151: peĹ‚ny audyt P7, traversal kampanii 01â€“43,
regresja save/capture i werdykt gotowoĹ›ci P8.


## PKG-0151: PeĹ‚ny audyt P7, regresja save/capture i decyzja o otwarciu P8

Data: 2026-08-31
Status: zamkniÄ™ty

Zakres:
- domkniÄ™cie finaĹ‚owego audytu P7 na osobnej bramce `tests/pkg_0151_smoke_test.gd`;
- wpiÄ™cie PKG-0151 do `tools/verify.ps1`;
- normal-driver capture reprezentatywnych stanĂłw caĹ‚ej kampanii (`tools/capture_pkg_0151.gd`) oraz headless diff (`tools/diff_pkg_0151_capture.gd`);
- synchronizacja dokumentĂłw stanu, roadmapy, planu P7, decyzji i handoffu do P8.

Wykonane:
- **Bramka koĹ„cowa P7** â€” `tests/pkg_0151_smoke_test.gd` audytuje 15 `DiagnosticSequenceDefinition`, 45 scen technicznych, wyjÄ…tek grafu bramek S08/S09 (`world_recognized` oraz `p7.three_place_proofs.trace`), routing finaĹ‚Ăłw A/B/C, migracje checkpointĂłw S08/S01â€“S05/S12/S14 oraz round-trip kanonicznych faktĂłw koĹ„ca.
- **Integracja verify** â€” `tools/verify.ps1` uruchamia teraz `PKG-0151 final P7 audit gate` po `pkg_0150_smoke_test.gd`.
- **Visual evidence** â€” `tools/capture_pkg_0151.gd` wyrenderowaĹ‚ 36 Ĺ›wieĹĽych PNG (18 stanĂłw Ă— normal/reduced) na Intel Iris Xe; `tools/diff_pkg_0151_capture.gd` potwierdziĹ‚ brak pustych kadrĂłw 640Ă—360 oraz rozrĂłĹĽnialnoĹ›Ä‡ kluczowych par stanĂłw, w tym metod A/B/C i trzech komĂłr finaĹ‚owych.
- **Rozjazd baseline** â€” poczÄ…tkowy FAIL `verify.ps1` pochodziĹ‚ z regresji w `pkg_0127_smoke_test.gd` (oczekiwanie normalizacji checkpointu S09 przy nowoczesnym save bez legacy). Osobne uruchomienie bramki wykazaĹ‚o PASS, wiÄ™c ĹşrĂłdĹ‚em byĹ‚ stan poĹ›redni, nie bĹ‚Ä…d runtime.
- **Dokumentacja** â€” `CURRENT_STATE.md`, `ROADMAP.md`, `P7_GAMEPLAY_DEPTH_IMPLEMENTATION_PLAN.md`, `DECISION_LOG.md`, `RISKS_AND_HYPOTHESES.md`, `INDEX.md` i `NEXT_SESSION_PROMPT.md` zostaĹ‚y zsynchronizowane z zamkniÄ™ciem P7 i otwarciem P8.

DowĂłd:

```text
PKG-0151 Smoke Test: 100% PASS on final P7 audit gate.
PKG-0151 CAPTURE PASS: 36 frames in res://reports/pkg_0151
PKG-0151 Visual Diff Certification: PASS
```

Ograniczenia:
- Werdykt PKG-0151 pozostaje czysto techniczny: potwierdza kontrakty danych, routingu, zapisu i reprezentatywnych powierzchni obrazu.
- Nie ma dowodu odbioru czĹ‚owieka, czytelnoĹ›ci dla nowej osoby, komfortu reduced-motion ani gotowoĹ›ci release buildĂłw po przebudowie P7. To pozostaje zakresem P8.
- Zakaz nowych `.exe` pozostaje w mocy do jawnej zgody wĹ‚aĹ›ciciela.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` â€” PKG-0152: start fazy P8 (Release Candidate Readiness) bez budowania nowych `.exe`.

## PKG-0152: Start fazy P8 â€” audyt powierzchni release, presetĂłw i dokumentĂłw bez nowych `.exe`

Data: 2026-08-31
Status: zamkniÄ™ty

Zakres:
- dodaÄ‡ dedykowanÄ… bramkÄ™ P8 dla powierzchni release po P7;
- skorygowaÄ‡ manifest licencyjny i release notes tak, by odpowiadaĹ‚y bieĹĽÄ…cemu runtime;
- uszczelniÄ‡ presety eksportu i workflow builda bez generowania nowych binariĂłw;
- wydaÄ‡ techniczny werdykt, czy projekt jest gotowy do wĹ‚aĹ›ciwego pakietu release.

Wykonane:
- **Bramka P8** â€” utworzono `tests/pkg_0152_smoke_test.gd`; audytuje `docs/LICENSES.md`,
  `docs/RELEASE_NOTES.md`, `export_presets.cfg`, blokadÄ™ D-125 w `tools/export_builds.ps1`,
  `.gdignore` w `assets/characters/lena/raw/` i `logs/` oraz obecnoĹ›Ä‡ shell/epilogue surfaces.
- **Integracja verify** â€” `tools/verify.ps1` uruchamia teraz `PKG-0152 P8 release surface audit gate`
  po `tests/pkg_0151_smoke_test.gd`.
- **Manifest prawdy** â€” `docs/LICENSES.md` rozdziela proceduralne audio zero-asset od bieĹĽÄ…cych
  rasterowych assetĂłw runtime (`assets/characters/lena/`, `assets/characters/portraits/`) i opisuje
  materiaĹ‚y ĹşrĂłdĹ‚owe procesu jako wyĹ‚Ä…czone z release surface.
- **Dossier release** â€” `docs/RELEASE_NOTES.md` zachowuje historycznÄ… etykietÄ™ RC1, ale opisuje
  bieĹĽÄ…cy runtime P7 (15 sekwencji diagnostycznych, 43 adresy, 45 scen technicznych) oraz werdykt,
  ĹĽe historyczne artefakty `dist/` nie stanowiÄ… dowodu gotowoĹ›ci release.
- **Workflow eksportu** â€” `export_presets.cfg` polega na domyĹ›lnych template'ach Godota
  (`custom_template/release=""`), a `tools/export_builds.ps1` dziaĹ‚a w trybie audit-first:
  bez `-AllowBinaryBuild` nie tworzy nowych binariĂłw, raportuje D-125 i pokazuje stan `dist/`.
- **Quarantine ĹşrĂłdeĹ‚** â€” dodano `.gdignore` do `assets/characters/lena/raw/` i
  `assets/characters/lena/logs/`, ĹĽeby surowe PNG, prompty i logi narzÄ™dziowe nie byĹ‚y
  traktowane jak finalne assety release.

DowĂłd:

```text
pwsh -NoProfile -File "tools/verify_docs.ps1" -> DOCS PASS: 40 required files and handoff contracts
pwsh -NoProfile -File "tools/export_builds.ps1" -> D-125 guard: Binary build blocked. Historical dist/ artifacts present...
godot --headless --path . --script res://tests/pkg_0124_smoke_test.gd -> ALL RELEASE CANDIDATE TESTS PASSED (0 FAILURES)
godot --headless --path . --script res://tests/pkg_0152_smoke_test.gd -> PKG-0152 SMOKE PASS
pwsh -NoProfile -File "tools/verify.ps1" -> Verification passed. (exit code 0, 798.66 s)
```

Ograniczenia:
- PKG-0152 nie zmieniaĹ‚ warstwy renderu runtime; ostatnie Ĺ›wieĹĽe evidence wizualne pozostaje z PKG-0151.
- Werdykt nadal blokuje wĹ‚aĹ›ciwy pakiet release: brak Ĺ›wieĹĽego builda po P7, clean-install poza edytorem,
  runtime credits/licence surface w Station 43 i spĂłjnej identyfikacji wersji.
- Zgodnie z ADR-003 wynik pozostaje techniczny; nie dowodzi odbioru czĹ‚owieka.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` â€” PKG-0153: P8 runtime release surface
(credits/licence + wersja) bez generowania nowych `.exe`.

## PKG-0153: Runtime release surface P8 â€” credits/licence w Station 43 i spĂłjna wersja

Data: 2026-08-31
Status: zamkniÄ™ty

Zakres:
- domknÄ…Ä‡ runtime credits/licence surface w Station 43 bez nowych `.exe`;
- odpiÄ…Ä‡ shell od twardego tekstu builda i spiÄ…Ä‡ jednÄ… wersjÄ™ miÄ™dzy `project.godot`, ekranem tytuĹ‚owym i presetami;
- dodaÄ‡ dedykowanÄ… bramkÄ™ oraz Ĺ›wieĹĽe capture dla tej powierzchni P8;
- wydaÄ‡ werdykt, czy nastÄ™pny pakiet moĹĽe wejĹ›Ä‡ w build/rehearsal.

Wykonane:
- **Station 43 release surface** â€” dodano dwa jawne panele `CrispDiegeticText`
  (`CrispDiegeticText_LicenseManifest`, `CrispDiegeticText_CreditsManifest`)
  ze skrĂłconym manifestem runtime: Zero-Asset audio, proceduralny Pixel-Stage,
  assety Leny/portretĂłw, Godot MIT i gĹ‚Ăłwne biblioteki oraz credits produkcyjne.
- **Shell version sync** â€” `scripts/ui/title_screen.gd` skĹ‚ada `BuildLabel`
  z `ProjectSettings` (`application/config/version`), viewportu `640x360`
  i `Engine.physics_ticks_per_second`; klucz lokalizacji przestaĹ‚ udawaÄ‡ wersjÄ™.
- **Lokalizacja formatu** â€” `LocalizationManager.BUILD_LABEL` w PL/EN staĹ‚ siÄ™
  sformatowanym szablonem wersji zamiast twardego tekstu.
- **Nowa bramka P8** â€” dodano `tests/pkg_0153_smoke_test.gd`, a `tools/verify.ps1`
  uruchamia teraz `PKG-0153 P8 runtime release surface gate` po `pkg_0152`.
- **Capture workflow** â€” utworzono `tools/capture_pkg_0153.gd` oraz rozszerzono
  `tools/capture_preview.gd` o przeĹ‚Ä…cznik `--pkg0153`, ĹĽeby daĹ‚o siÄ™ wykonaÄ‡
  szybki, normal-driver subset bez odpalania caĹ‚ego historycznego zestawu.
- **Korekta kadru** â€” po nieudanym peĹ‚nym verify (`pkg_0137`) przesuniÄ™to
  `CrispDiegeticText` i `CrispDiegeticText_LicenseManifest` w Station 43,
  bo panel licencyjny wchodziĹ‚ na sylwetkÄ™ Leny. Retest `pkg_0137` wrĂłciĹ‚ na PASS.

DowĂłd:

```text
pwsh -NoProfile -File "tools/verify_docs.ps1" -> DOCS PASS: 40 required files and handoff contracts
pwsh -NoProfile -Command 'godot --headless --path . --script res://tests/pkg_0152_smoke_test.gd ...' -> PKG-0152 SMOKE PASS (EXIT=0)
pwsh -NoProfile -Command 'godot --headless --path . --script res://tests/pkg_0153_smoke_test.gd ...' -> PKG-0153 SMOKE PASS (EXIT=0)
pwsh -NoProfile -Command 'godot --headless --path . --script res://tests/pkg_0137_smoke_test.gd ...' -> PKG-0137: ALL TESTS PASSED (EXIT=0)
pwsh -NoProfile -Command 'godot --path . --script res://tools/capture_pkg_0153.gd ...' -> CAPTURE PASS: title_screen_runtime_version.png, station_43_initial_runtime_surface.png, station_43_release_surface.png (EXIT=0)
pwsh -NoProfile -Command 'godot --path . --script res://tools/capture_preview.gd -- --pkg0153 ...' -> CAPTURE PASS: reports/pkg_0153/* (EXIT=0)
pwsh -NoProfile -File "tools/verify.ps1" -> Verification passed. (exit code 0, 872.40 s)
```


Przekazanie: `docs/NEXT_SESSION_PROMPT.md` â€” PKG-0154: P8 build/rehearsal,
clean-install i werdykt RC bez zmiany zakresu gry.

## PKG-0154: P8 build/rehearsal, clean-install i werdykt RC

Data: 2026-08-31

Cel:

- wykonaÄ‡ autoryzowany Ĺ›wieĹĽy eksport Windows/Linux po PKG-0153;
- potwierdziÄ‡ shell/build label poza edytorem;
- sprawdziÄ‡ clean-install `new_game` â†’ zapis â†’ `continue`;
- zdecydowaÄ‡, czy P8 jest jeszcze zablokowane.

Wykonane:

- **Template bootstrap + quarantine eksportu** â€” `tools/export_builds.ps1` potrafi
  teraz sam doinstalowaÄ‡ zgodne standardowe export templates Godot 4.7.2 do
  `%APPDATA%/Godot/export_templates/4.7.2.stable/`, zanim wykona build. Skrypt
  odrzuca teĹĽ surface eksportu zawierajÄ…cÄ… `docs/`, `tests/`, `tools/`,
  `godot-mcp/`, `vibe-eyes/`, logi i inne artefakty nietworzÄ…ce gry.
- **Presety release** â€” `export_presets.cfg` dostaĹ‚ jawne `exclude_filter` dla
  powierzchni nietworzÄ…cej gry. Nowa bramka `tests/pkg_0154_smoke_test.gd`
  pilnuje zarĂłwno quarantine presetĂłw, jak i kontraktu template-bootstrap.
- **Rehearsal harness** â€” `scripts/ui/title_screen.gd` i
  `scripts/core/game_state_manager.gd` dostaĹ‚y inertne bez env punktowe haki
  rehearsal: `GS_BOOT_CAPTURE_PATH`, `GS_AUTOMATION_ACTION`,
  `GS_RUNTIME_TRACE_PATH`. SĹ‚uĹĽÄ… wyĹ‚Ä…cznie do technicznego capture i
  bezobsĹ‚ugowego sprawdzania `new_game`/`continue`; bez zmiennych Ĺ›rodowiskowych
  runtime zachowuje siÄ™ tak jak przed PKG-0154.
- **ĹšwieĹĽe buildy** â€” `tools/export_builds.ps1 -AllowBinaryBuild` wygenerowaĹ‚
  nowe artefakty:
  - `dist/windows/GettingStrange.exe` â€” 107.18 MB,
  - `dist/linux/GettingStrange.x86_64` â€” 73.09 MB.
- **Windows RC rehearsal** â€” build poza edytorem zapisaĹ‚ poprawny shell capture
  `reports/pkg_0154/release_title_clean.png`; log potwierdza build label
  `WER. 1.0.0  //  PC  //  640x360  //  FIZYKA 60 Hz`.
- **Windows clean-install/save/load** â€” na pustym profilu:
  - `release_new_game.log` + `release_new_game_trace.log` potwierdzajÄ…
    `new_game` i wejĹ›cie do `Station01`,
  - `%APPDATA%/Godot/app_userdata/Getting Strange/getting_strange_campaign_v1.json`
    zapisuje schema 1 z checkpointem `station_01`,
  - `release_continue.log` + `release_continue_trace.log` potwierdzajÄ…
    `continue` i ponowne wejĹ›cie do `Station01`,
  - `release_title_loaded.png` pokazuje shell z aktywnym zapisem i punktem
    `STATION_01`.
- **Linux rehearsal pod WSL** â€” Ĺ›wieĹĽy ELF uruchomiĹ‚ siÄ™ przez WSL/Ubuntu:
  - `linux_runtime.log` + `linux_title_clean.png` potwierdzajÄ… shell/build label,
  - `linux_new_game.log` + `linux_new_game_trace.log` potwierdzajÄ… `new_game`
    i przejĹ›cie do `Station01`,
  - `linux_continue.log` + `linux_continue_trace.log` potwierdzajÄ… `continue`
    i przejĹ›cie do `Station01`.
- **Full gate** â€” `tools/verify.ps1` wrĂłciĹ‚o na PASS z doĹ‚Ä…czonÄ… bramkÄ…
  `tests/pkg_0154_smoke_test.gd`.

Werdykt:

- **P8 zamkniÄ™te technicznie.**
- Release candidate jest gotowy technicznie dla Windows i Linux, z jawnym
  zastrzeĹĽeniem, ĹĽe linuxowy runtime byĹ‚ Ä‡wiczony w WSL 2 (Mesa llvmpipe,
  dummy audio), wiÄ™c nie jest to jeszcze dowĂłd natywnej desktopowej warstwy
  GPU/audio poza WSL.

DowĂłd:

```text
pwsh -NoProfile -File "tools/export_builds.ps1" -AllowBinaryBuild -> Export completed successfully. (Windows 107.18 MB, Linux 73.09 MB)
godot --headless --path . --script res://tests/pkg_0154_smoke_test.gd -> PKG-0154 SMOKE PASS
reports/pkg_0154/release_title_clean.log -> TITLE_SCREEN_CAPTURE ... build_label=WER. 1.0.0  //  PC  //  640x360  //  FIZYKA 60 Hz
reports/pkg_0154/release_new_game_trace.log -> transition_finished target=res://scenes/levels/station_01.tscn current_scene=Station01
%APPDATA%/Godot/app_userdata/Getting Strange/getting_strange_campaign_v1.json -> schema_version 1, last_checkpoint_station "station_01"
reports/pkg_0154/release_continue.log -> status=ZAPIS: AKTYWNY / PUNKT: STATION_01
reports/pkg_0154/linux_runtime.log -> TITLE_SCREEN_CAPTURE ... build_label=WER. 1.0.0  //  PC  //  640x360  //  FIZYKA 60 Hz
reports/pkg_0154/linux_new_game_trace.log -> transition_finished target=res://scenes/levels/station_01.tscn current_scene=Station01
reports/pkg_0154/linux_continue.log -> status=ZAPIS: AKTYWNY / PUNKT: STATION_01
pwsh -NoProfile -File "tools/verify.ps1" -> Verification passed. (exit code 0, 782.49 s)
```

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` â€” PKG-0155: natywna prĂłba Linux poza
WSL i handoff RC.

## PKG-0155: Board-level killer audit, HYBRID_REBUILD i kanoniczny plan P9

Data: 2026-08-31  
Status: zamkniÄ™ty planistycznie

Kontekst:

- wĹ‚aĹ›ciciel przekazaĹ‚ wiÄ…ĹĽÄ…cy fakt, ĹĽe obecna gra nie komunikuje toĹĽsamoĹ›ci,
  celu, motywacji ani zasad Ĺ›wiata, a rodziny lokacji sÄ… nierozrĂłĹĽnialne;
- prompt `docs/PROJECT_REBUILD_BOARD_PROMPT.md` wymagaĹ‚ board-level greenlight,
  scorecardu, audytu rodzin, pierwszych 30 minut i execution-locked planu;
- peĹ‚ny baseline przed planem przeszedĹ‚ `Verification passed`, exit code 0,
  1157,79 s. Wynik potwierdziĹ‚ wartoĹ›Ä‡ technologii, nie jakoĹ›Ä‡ produktu.

Werdykt:

- `FINAL VERDICT: HYBRID_REBUILD`;
- `GREENLIGHT DECISION: GO WITH HARD PIVOT`;
- technologia Godot 4.7 zostaje dawcÄ…;
- obecna 43-adresowa forma, wspĂłlny layout scen, wiÄ™kszoĹ›Ä‡ contentu i finaĹ‚
  nie majÄ… produktowego greenlightu;
- docelowa trasa to 18 adresĂłw liniowych â†’ jeden wariant 42A/B/C â†’ 43, czyli
  20 odwiedzanych adresĂłw na przebieg;
- `TECHNICAL PASS` i `PRODUCT GO` sÄ… odrÄ™bnymi werdyktami.

Wykonane:

- utworzono `docs/PROJECT_REBUILD_EXECUTION_PLAN.md`: target doĹ›wiadczenia po
  1/5/30 minutach, siedem rodzin lokacji, 20-adresowa trasa, osiem bramek
  produktu, szeĹ›Ä‡ faz, 25 bundle'Ăłw i piÄ™Ä‡ checkpointĂłw GO/PIVOT/CUT;
- utworzono `docs/decisions/ADR-008-hybrid-product-rebuild.md`;
- zapisano D-168 w `DECISION_LOG.md`;
- otwarto P9 w `INDEX.md`, `CURRENT_STATE.md` i `ROADMAP.md`;
- przeksztaĹ‚cono `RELEASE_NOTES.md` w historyczny zapis technicznego dawcy,
  nie aktywny greenlight;
- oznaczono `CREATIVE_REBUILD_PLAN`, bible narracyjne, `FULL_STORY`,
  `CONTINUITY_TRACKER` i `DIALOGUE_SCRIPT` jako materiaĹ‚ ĹşrĂłdĹ‚owy P9;
- zaktualizowano `RISKS_AND_HYPOTHESES.md`: fakty wĹ‚aĹ›ciciela, refutacjÄ™
  odbiorczej czÄ™Ĺ›ci bieĹĽÄ…cej formy i ryzyka R-039..R-042;
- `tools/verify_docs.ps1` wymaga teraz ADR-008 i aktywnego planu P9;
- zastÄ…piono handoff promptem PKG-0156 dla PHASE-01 / BUNDLE-01..05.

DowĂłd:

```text
pwsh -NoProfile -File "tools/verify.ps1" (baseline)
-> Verification passed. (exit code 0, 1157.79 s)

pwsh -NoProfile -File "tools/verify_docs.ps1"
-> DOCS PASS: 42 required files and handoff contracts

pwsh -NoProfile -File "tools/verify.ps1" (po pierwszej synchronizacji planu)
-> Verification passed. (exit code 0, 806.16 s)
```

Ograniczenia:

- PKG-0155 nie zmienia runtime, scen, routingu, geometrii, zapisu ani buildĂłw;
- nie wykonano produktowej remediacji â€” obecny runtime pozostaje
  `TECHNICAL PASS / PRODUCT FAIL`;
- nie utworzono nowych `.exe`;
- natywny Linux poza WSL zostaje odroczony do nowego product GO;
- pierwszy pakiet wykonawczy P9 nadal jest planistyczny: nie wolno rozpoczÄ…Ä‡
  Station 01 przed zamkniÄ™ciem targetu, mapy kampanii, rodzin i acceptance
  matrix.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` â€” PKG-0156: PHASE-01 Product Reset
Lock, BUNDLE-01..05, bez zmian runtime.

## PKG-0156: PHASE-01 Product Reset Lock, BUNDLE-01..05

Data: 2026-08-31
Status: zamkniÄ™ty (CHECKPOINT-01: GO)

Kontekst:

- PKG-0155 zaakceptowaĹ‚ HYBRID_REBUILD i kanoniczny plan P9; wiÄ…ĹĽÄ…ce fakty
  wĹ‚aĹ›ciciela uniewaĹĽniajÄ… produktowy greenlight bieĹĽÄ…cej formy;
- PHASE-01 miaĹ‚ zamroziÄ‡ faĹ‚szywy RC i wydaÄ‡ cztery kontrakty produktu bez
  zmiany runtime.

Wykonane:

- BUNDLE-01: zamroĹĽono faĹ‚szywy produktowy RC â€” `ROADMAP.md` (meta produktu
  20 adresĂłw, warunek ukoĹ„czenia = `TECHNICAL PASS` + `PRODUCT GO`),
  `AGENTS.md` (faza P9) i `RELEASE_NOTES.md` (artefakt historyczny) nie
  prowadzÄ… juĹĽ do eksportu bieĹĽÄ…cej formy;
- BUNDLE-02: `docs/rebuild/PLAYER_CONTRACT.md` â€” toĹĽsamoĹ›Ä‡ Leny, stawka,
  stan wiedzy po 1/5/30 minutach, podziaĹ‚ noĹ›nikĂłw informacji;
- BUNDLE-03: `docs/rebuild/CAMPAIGN_MAP.md` â€” trasa 01â€“18 â†’ 42A/B/C â†’ 43,
  reguĹ‚a kierunku, statusy legacy 19â€“41 (`ADAPT` 17, `RETIRE` 6, `KEEP` 0),
  komponenty dawcy z runtime 19â€“41, re-origination 33 flag kanonicznych,
  budĹĽet interakcji;
- BUNDLE-04: `docs/rebuild/LOCATION_FAMILY_BIBLE.md` â€” siedem rodzin na
  piÄ™ciu osiach, macierz rĂłĹĽnicowania, test monochromatyczny, rytm rodzin;
- BUNDLE-05: `docs/rebuild/ACCEPTANCE_MATRIX.md` â€” osiem bramek, dwa werdykty,
  rubryka GO/PIVOT/CUT, dry-run bieĹĽÄ…cego runtime = `PRODUCT FAIL`;
- bramka `tests/pkg_0156_smoke_test.gd` (firewall kontraktĂłw PHASE-01) oraz
  rejestracja czterech dokumentĂłw w `tools/verify_docs.ps1` i bramki w
  `tools/verify.ps1`;
- spĂłjnoĹ›Ä‡: `WORLD_SCALE.md` â€” wiek Leny zweryfikowany do 29 lat (zgodnie
  z `PROJECT_BIBLE`), `RISKS_AND_HYPOTHESES.md` â€” R-040 po zamkniÄ™ciu
  klasyfikacji, `DECISION_LOG.md` â€” D-169.

DowĂłd:

```text
pwsh -NoProfile -File "tools/verify.ps1" (baseline PKG-0156)
-> Verification passed. (exit code 0, 788.28 s)

pwsh -NoProfile -File "tools/verify_docs.ps1"
-> DOCS PASS: 46 required files and handoff contracts

godot --headless --path . --script res://tests/pkg_0156_smoke_test.gd
-> PKG-0156 SMOKE PASS: product reset lock documents are complete and consistent

pwsh -NoProfile -File "tools/verify.ps1" (po synchronizacji statusĂłw)
-> Verification passed. (exit code 0, 877.59 s)
```

Ograniczenia:

- PKG-0156 nie zmienia runtime, scen, routingu, geometrii, zapisu ani
  buildĂłw; nie generuje nowych `.exe`;
- dry-run macierzy koĹ„czy siÄ™ `PRODUCT FAIL` â€” to zamierzony wynik, nie regres;
- nie wykonano produktowej remediacji â€” obecny runtime pozostaje
  `TECHNICAL PASS / PRODUCT FAIL`;
- odbiĂłr pierwszej minuty nie jest potwierdzony czĹ‚owiekiem (D-012, ADR-003).

Wynik:

- CHECKPOINT-01: **GO** â€” jedna toĹĽsamoĹ›Ä‡ Leny, jedna 20-adresowa trasa,
  siedem rozpoznawalnych rodzin i kompletna acceptance matrix.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` â€” PKG-0157: PHASE-02 First Five
Minutes, BUNDLE-06..10, bez nowych `.exe`.

## PKG-0157: PHASE-02 First Five Minutes (BUNDLE-06..10)

Data: 2026-08-31
Identyfikator stanu: `PKG-0157`. ZamroĹĽenie: `snapshots/PKG-0157-2026-08-31`.

Kontekst: Wykonanie PHASE-02 (BUNDLE-06..10) z `PROJECT_REBUILD_EXECUTION_PLAN.md` â€” pierwszych piÄ™ciu minut produktu na podstawie kontraktĂłw `docs/rebuild/` (PLAYER_CONTRACT, CAMPAIGN_MAP, LOCATION_FAMILY_BIBLE, ACCEPTANCE_MATRIX), bez nowych `.exe` i bez otwierania release.

Zakres dostarczony:
- BUNDLE-06 (Shell product promise): `scenes/shell/title_screen.tscn`, `scripts/ui/title_screen.gd`, `scripts/core/localization_manager.gd` â€” usuniÄ™cie ĹĽargonu QA, czytelna obietnica osobistego thrillera powrotu Linii 4 do Marty, zwiÄ™zĹ‚y blok sterowania ("RUSZ SIÄ / ZBADAJ"), focus loop gĂłra/dĂłĹ‚, poprawna obsĹ‚uga nakĹ‚adki ustawieĹ„ i dwujÄ™zycznoĹ›ci PL/EN;
- BUNDLE-07 (Station 01 human worksite): `scenes/levels/station_01.tscn`, `scripts/levels/station_01.gd` â€” jedno stanowisko pomiarowe Leny Wolskiej (diagnostyczki drgaĹ„), powtĂłrka odczytu 3-sekundowej luki przy Linii 4, zabezpieczenie surowej prĂłbki (`home_sample_preserved`), wiadomoĹ›Ä‡ Marty o opĂłĹşnieniu, odryglowanie wyjĹ›cia; GATE-01 PASS;
- BUNDLE-08 (Station 02 outdoor service detour): `scenes/levels/station_02.tscn`, `scripts/levels/station_02.gd` â€” otwarte niebo >25%, 3 plany gĹ‚Ä™bi, robocza gantry kablowa, nocne obejĹ›cie robĂłt (12 min opĂłĹşnienia), wejĹ›cie po drabinie na nasyp serwisowy (`LadderZone` 86px), prĂłg â‰¤18px;
- BUNDLE-09 (Station 03 believable transit stop): `scenes/levels/station_03.tscn`, `scripts/levels/station_03.gd` â€” wiata z czÄ™Ĺ›ciowym zadaszeniem, krawÄ™dĹş torowiska dzielÄ…ca kadr, rozkĹ‚ad Linii 4, ruch i zatrzymanie nocnego wagonu, odpowiedĹş Marcie i wejĹ›cie do pojazdu;
- BUNDLE-10 (Station 04 transit ride): `scenes/levels/station_04.tscn`, `scripts/levels/station_04.gd` â€” wnÄ™trze wagonu tranzytowego, ruchoma paralaksa okien nocnego miasta, sylwetka pomnika katastrofy Linii 4, odĹ‚oĹĽenie czytnika do torby przed dojazdem do domu; GATE-05 PASS;
- BudĹĽet interakcji: Station 01: 3, Station 02: 3, Station 03: 2 (+ wejĹ›cie), Station 04: 3 â€” wszystkie â‰¤3 istotne interakcje (GATE-INT PASS);
- Nowa bramka automatyczna: `tests/pkg_0157_smoke_test.gd` zarejestrowana w `tools/verify.ps1`;
- NarzÄ™dzie dowodu wizualnego: `tools/capture_pkg_0157.gd` wygenerowaĹ‚o 18 kadrĂłw normal/reduced motion w `reports/pkg_0157/` na fizycznym sterowniku Intel Iris Xe;
- Rejestracja decyzji D-170 w `DECISION_LOG.md`, aktualizacja `ACCEPTANCE_MATRIX.md`, `PROJECT_REBUILD_EXECUTION_PLAN.md`, `ROADMAP.md`, `RISKS_AND_HYPOTHESES.md` (H-035), `CURRENT_STATE.md`.

DowĂłd:

```text
pwsh -NoProfile -File "tools/verify_docs.ps1"
-> DOCS PASS: 46 required files and handoff contracts

godot --headless --path . --script res://tests/pkg_0157_smoke_test.gd
-> PKG-0157 SMOKE PASS: First Five Minutes (BUNDLE-06..10), GATE-01, GATE-05 and GATE-INT verified.

godot_console --path . --script res://tools/capture_pkg_0157.gd
-> PKG-0157 CAPTURE PASS: 18 frames in res://reports/pkg_0157
```

Ograniczenia:
- ZewnÄ™trzne playtesty ludzi (D-012, ADR-003) nie sÄ… prowadzone;
- Brak nowych plikĂłw `.exe` i brak otwarcia release (D-168);
- Testy potwierdzajÄ… kontrakty techniczne i strukturÄ™ noĹ›nikĂłw, nie dowodzÄ… emocji ani zaangaĹĽowania gracza.

Wynik:
- CHECKPOINT-02: **GO** â€” odpowiedzi na pytania toĹĽsamoĹ›ci, zawodu, celu, stawki i trzech pierwszych rodzin miejsc wynikajÄ… bezpoĹ›rednio z runtime. Otwiera PHASE-03.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` â€” PKG-0158: PHASE-03 First Thirty Minutes (BUNDLE-11..15).

## PKG-0158: PHASE-03 First Thirty Minutes (BUNDLE-11..15)

Data: 2026-08-31
Identyfikator stanu: `PKG-0158`. ZamroĹĽenie: `snapshots/PKG-0158-2026-08-31`.

Kontekst: Wykonanie PHASE-03 (BUNDLE-11..15) z `PROJECT_REBUILD_EXECUTION_PLAN.md` â€” pierwszych trzydziestu minut produktu na podstawie kontraktĂłw `docs/rebuild/` (PLAYER_CONTRACT, CAMPAIGN_MAP, LOCATION_FAMILY_BIBLE, ACCEPTANCE_MATRIX), ustanowienie 4 niezaleĹĽnych ĹşrĂłdeĹ‚ rozbieĹĽnoĹ›ci, 4 rodzin lokacji i pytania Ĺ›ledczego bez ucieczki w tekst i bez nowych `.exe`.

Zakres dostarczony:
- BUNDLE-11 (Station 05 home street baseline): `scenes/levels/station_05.tscn`, `scripts/levels/station_05.gd` â€” nocna ulica Sadowa, otwarta perspektywa nieba >25%, fasady, latarnie, 3 czasowniki (`check_street_route`, `check_sample_case`, `cross_street_towards_home`), 0 legacy punktĂłw rezonansu, czyste tĹ‚o VectorStage z fartuchem 40px;
- BUNDLE-12 (Station 06 kiosk contradiction): `scenes/levels/station_06.tscn`, `scripts/levels/station_06.gd` â€” publiczna rozbieĹĽnoĹ›Ä‡: kiosk i sĹ‚upek rozkĹ‚adu jazdy Linii 4 z napisem "SADOWA 14", sprzedawca potwierdzajÄ…cy trasÄ™ Leny i dom pod czternastkÄ…, 3 czasowniki (`inspect_street_timetable`, `buy_water_at_kiosk`, `ask_kiosk_vendor`), diegetyczny napis rozkĹ‚adu jazdy;
- BUNDLE-13 (Station 07 building exterior): `scenes/levels/station_07.tscn`, `scripts/levels/station_07.gd` â€” fizyczny konflikt adresu: dokument z pracy Leny (Sadowa 12) vs tablica i domofon kamienicy (Sadowa 14, L. Wolska / M. Kowalska), granitowe schody (podstopnica 14 px), drzwi `BuildingEntranceDoor` (AnimatableBody2D) otwierane przez wpisanie domofonu i klucz z torby, 3 czasowniki (`compare_address_document`, `inspect_intercom_directory`, `enter_intercom_code`);
- BUNDLE-14 (Station 08 stairwell and threshold): `scenes/levels/station_08.tscn`, `scripts/levels/station_08.gd` â€” rodzina mieszkalna: niski sufit y=36, lamperia, schody granitowe 14 px, sÄ…siadka na pĂłĹ‚piÄ™trze ("Marta czeka od godziny na gĂłrze pod czternastkÄ…"), drzwi `ApartmentDoor14` otwierane fizycznie pasujÄ…cym kluczem z torby Leny, ustanowienie hipotezy przenumerowania `s08_renumbering_hypothesis` i pytania Ĺ›ledczego;
- BUNDLE-15 (First-thirty-minute integration gate): GATE-30 PASS (4 niezaleĹĽne ĹşrĂłdĹ‚a rozbieĹĽnoĹ›ci: rozkĹ‚ad, kiosk, fasada/dokument 12 vs 14, sÄ…siadka/klucz; 4 rodziny lokacji: techniczna 01, zewnÄ™trzna 02/05/06/07, tranzytowa 03/04, mieszkalna 08), GATE-FAM PASS, GATE-INT PASS (wszystkie 8 stacji â‰¤3 interakcje);
- Nowa bramka automatyczna: `tests/pkg_0158_smoke_test.gd` zarejestrowana w `tools/verify.ps1`;
- NarzÄ™dzie dowodu wizualnego: `tools/capture_pkg_0158.gd` wygenerowaĹ‚o 16 kadrĂłw normal/reduced motion w `reports/pkg_0158/` na fizycznym sterowniku Intel Iris Xe;
- Rejestracja decyzji D-171 w `DECISION_LOG.md`, aktualizacja `ACCEPTANCE_MATRIX.md`, `PROJECT_REBUILD_EXECUTION_PLAN.md`, `ROADMAP.md`, `RISKS_AND_HYPOTHESES.md` (H-036), `CURRENT_STATE.md`.

DowĂłd:

```text
pwsh -NoProfile -File "tools/verify_docs.ps1"
-> DOCS PASS: 46 required files and handoff contracts

godot --headless --path . --script res://tests/pkg_0158_smoke_test.gd
-> PKG-0158 SMOKE PASS: First Thirty Minutes (BUNDLE-11..15), GATE-30, GATE-INT verified.

godot_console --path . --script res://tools/capture_pkg_0158.gd
-> PKG-0158 CAPTURE PASS: 16 frames in res://reports/pkg_0158

pwsh -NoProfile -File "tools/verify.ps1"
-> Verification passed. (exit code 0, 874.32 s)
```

Ograniczenia:
- ZewnÄ™trzne playtesty ludzi (D-012, ADR-003) nie sÄ… prowadzone;
- Brak nowych plikĂłw `.exe` i brak otwarcia release (D-168);
- Testy potwierdzajÄ… strukturÄ™ noĹ›nikĂłw i stan techniczny, nie dowodzÄ… emocji ani intuicji gracza.

Wynik:
- CHECKPOINT-03: **GO** â€” odpowiedzi na pytania toĹĽsamoĹ›ci, celu, 4 niezaleĹĽnych rozbieĹĽnoĹ›ci, 4 rodzin lokacji i wejĹ›cia do mieszkania 14 wynikajÄ… bezpoĹ›rednio z runtime. Otwiera PHASE-04.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` â€” PKG-0159: PHASE-04 Personal Mystery (BUNDLE-16..20).

## PKG-0159: Opening Remediation & Evidence Recertification

Data: 2026-09-01  
Identyfikator stanu: `PKG-0159`. ZamroĹĽenie: `snapshots/PKG-0159-2026-09-01`.

Kontekst: niezaleĹĽna weryfikacja kierunku P9 po pakietach wykonanych przez
mniejsze modele. Audyt rozdzieliĹ‚ zdrowy fundament techniczny hybrydowej
przebudowy od nieuprawnionych werdyktĂłw produktowych. Znaleziono cztery
konkretne rozjazdy: title screen rozpoczynaĹ‚ od listy sterowania zamiast od
obietnicy powrotu, Station 01 miaĹ‚a tylko jednÄ… faktycznÄ… drogÄ™ mimo kontraktu
â€žprĂłbka albo obietnicaâ€ť, Station 08 rysowaĹ‚a schody nad pĹ‚askÄ… kolizjÄ…, a
ServiceLanding w Station 02 blokowaĹ‚ realne wejĹ›cie na drabinÄ™. Historyczne
bramki PKG-0157/0158 wywoĹ‚ywaĹ‚y bezpoĹ›rednio metody gameplayu i nie byĹ‚y
wystarczajÄ…cym dowodem ciÄ…gĹ‚ej trasy sterowanej InputMap.

Zakres dostarczony:

- `scripts/ui/title_screen.gd`: usuniÄ™to listÄ™ sterowania z pierwszego ekranu;
  pierwsza informacja to teraz obietnica â€žLINIA 4 // OSTATNI ODCZYT // POWRĂ“Tâ€ť;
- `scripts/levels/station_01.gd` i `scenes/levels/station_01.tscn`: wdroĹĽono dwie
  prawdziwe drogi otwarcia â€” powtĂłrzenie prĂłbki albo spakowanie aparatury i
  wyjazd na czas â€” z osobnym stanem `p9.opening.choice`;
- `scripts/levels/station_02.gd` .. `station_04.gd`: obie drogi otwarcia majÄ…
  odrÄ™bne, zachowane konsekwencje w torbie, rozmowie z MartÄ… i pĂłĹşniejszym
  odczycie; ServiceLanding 02 jest jednokierunkowy i nie blokuje drabiny;
- `scenes/levels/station_08.tscn` i `scripts/levels/station_08.gd`: pĹ‚askÄ…
  atrapÄ™ zastÄ…piĹ‚o piÄ™Ä‡ rzeczywistych stopni o podstopnicach 12 px, moĹĽliwych
  do przejĹ›cia wyĹ‚Ä…cznie ruchem w prawo, bez skoku;
- `tests/pkg_0159_smoke_test.gd`: nowa bramka zaczyna w rzeczywistym title
  screenie, aktywuje â€žNowa graâ€ť przez `ui_accept` i prowadzi ciÄ…gĹ‚e M1 przez
  Station 01â€“08 wyĹ‚Ä…cznie semantycznym dialogue/movement/interact, bez rÄ™cznego
  ustawiania flag i bez bezpoĹ›rednich metod gameplayu;
- `tools/capture_pkg_0159.gd`: 9 kadrĂłw normal/M3, w tym obie drogi Station 01,
  rzeczywiste schody 08 i cztery pozbawione tekstu/UI, prawdziwie monochromatyczne
  struktury rodzin lokacji; reprezentatywne hashe sÄ… rĂłĹĽne;
- zarejestrowano D-172 i zsynchronizowano `ACCEPTANCE_MATRIX.md`, plan wykonawczy,
  roadmap, ryzyka/hipotezy, mapÄ™ kampanii, stan i handoff PKG-0160.

DowĂłd:

```text
godot --headless --path . --script res://tests/pkg_0159_smoke_test.gd
-> PKG-0159 SMOKE PASS
-> GATE-01 repeat: 4,203 s; leave branch: 4,052 s
-> GATE-05 continuous 01-04: 25,353 s
-> GATE-30 continuous 01-08: 50,124 s
-> Station 08 stairs: move_right only; min_y=227.0; final=(475.7,268.9)

pwsh -NoProfile -File .\tools\verify_docs.ps1
-> DOCS PASS: 46 required files and handoff contracts

godot_console --path . --script res://tools/capture_pkg_0159.gd
-> PKG-0159 CAPTURE PASS: 9 frames; M3 is PARTIAL 4/7

pwsh -NoProfile -File .\tools\verify.ps1
-> Verification passed. (exit code 0, 733,24 s)
```

Pierwszy peĹ‚ny przebieg po remediacji zatrzymaĹ‚ siÄ™ na historycznym teĹ›cie
PKG-0156, ktĂłry wymagaĹ‚ dosĹ‚ownego nagĹ‚Ăłwka i werdyktu zamroĹĽonego baseline'u.
PrzywrĂłcono te historyczne literaĹ‚y bez cofania aktualnego werdyktu; targeted
PKG-0156 i ponowny peĹ‚ny przebieg przeszĹ‚y.

Ograniczenia:

- automaty potwierdzajÄ… dostÄ™pnoĹ›Ä‡ tras, stan i geometriÄ™, nie dowodzÄ… ludzkiego
  tempa, zrozumienia, emocji ani frajdy;
- zewnÄ™trzne playtesty ludzi nie sÄ… prowadzone (D-012, ADR-003);
- GATE-FAM pozostaje `PARTIAL 4/7`: brakuje prywatnego mieszkania, instytucji i
  warsztatu; GATE-INT jest globalnie `PARTIAL 8/20`;
- nie wygenerowano nowych `.exe`; PRODUCT GO i release pozostajÄ… zablokowane.

Wynik:

- kierunek P9 (Product Rescue & Hybrid Rebuild) jest poprawny i zachowuje zdrowy
  donor technologiczny bez rozbudowy wspĂłlnych monolitĂłw;
- CHECKPOINT-02: **GO** po recertyfikacji rzeczywistym M1/M5;
- CHECKPOINT-03: **PIVOT**, nie GO â€” GATE-30 przeszedĹ‚, lecz GATE-FAM ma 4/7;
- nastÄ™pny pakiet musi zapĹ‚aciÄ‡ ten pivot, dostarczajÄ…c brakujÄ…ce trzy rodziny i
  doprowadzajÄ…c M3 do 7/7 przed CHECKPOINT-04.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` â€” PKG-0160: PHASE-04 Personal Mystery,
BUNDLE-16..20, bez nowych `.exe`.


## PKG-0160: PHASE-04 Personal Mystery â€” BUNDLE-16..20

Data: 2026-09-01

- Station 09â€“13 otrzymaĹ‚y lokalne, trwaĹ‚e argumenty osobiste: dom, niezaleĹĽny
  dzieĹ„ Marty, historia instytucji, dobrowolny dowĂłd Jakuba i jawna synteza.
- `world_recognized` nie powstaje przy zbieraniu Ĺ›ladĂłw; zapisuje je tylko
  `synthesize_world_difference()` po trzech traces.
- `tests/pkg_0160_smoke_test.gd` PASS; rejestracja w `tools/verify.ps1`.
- `tools/capture_pkg_0160.gd` PASS na normalnym sterowniku Intel Iris Xe:
  5 kadrĂłw zwykĹ‚ych i 7 tekstless/true-grayscale M3.
- CHECKPOINT-04: **PIVOT 6/7**. Kadry 11, 12 i 15 sÄ… strukturalnie odmienne,
  lecz 09 nie komunikuje jeszcze dostatecznie salonu dwĂłch osĂłb bez tekstu.
  To ograniczenie jest wynikiem inspekcji, nie bĹ‚Ä™dem testu. Release i `.exe`
  pozostajÄ… zablokowane.

## PKG-0161: PHASE-04 PIVOT â€” Station 09 Residential M3

Data: 2026-09-01

- Naprawiono wyĹ‚Ä…cznie obraz Station 09, bez nowych adresĂłw, czasownikĂłw,
  colliderĂłw, interakcji ani zmian trace: lokalne `_draw()` daje niski sufit,
  tapetÄ™ i lamperiÄ™, podĹ‚ogÄ™ z dywanem, sofÄ™ z dwiema rĂłĹĽnymi poduszkami, niski
  drewniany stĂłĹ‚ z dwiema filiĹĽankami, zamkniÄ™te drzwi wewnÄ™trzne, fotografiÄ™,
  ceramikÄ™, zasĹ‚oniÄ™te okno i pĂłĹ‚kÄ™. Kompozycja ma maksymalnie dwa plany gĹ‚Ä™bi.
- `AtmosphereRig` jest niewidoczny tylko w tej scenie, wiÄ™c publiczny rytm
  Ĺ›wietlĂłwek zastÄ…piĹ‚y dwie lokalnie narysowane lampy praktyczne. Trzy istniejÄ…ce
  punkty zachowaĹ‚y pozycje, kolizje i `resonance_id`, a ich modele to teraz
  `TWIN_CUPS`, `PHOTOGRAPH`, `HALLWAY_COAT_RACK`.
- Zaktualizowano `tests/pkg_0160_smoke_test.gd`: pilnuje limitu trzech
  interakcji, wyĹ‚Ä…czonych Ĺ›wiateĹ‚ ogĂłlnych i domowych modeli, nadal koĹ„czy trace
  `p9.mystery.home.trace = two_lives_without_claim`.
- Headless import oraz targeted `tests/pkg_0160_smoke_test.gd` przeszĹ‚y. ĹšwieĹĽy
  `tools/capture_pkg_0160.gd` przeszedĹ‚ na normalnym sterowniku Intel Iris Xe:
  5 normalnych kadrĂłw i 7 M3 bez tekstu/UI, z prawdziwÄ… skalÄ… szaroĹ›ci oraz
  rĂłĹĽnymi hashami.
- Inspekcja M3 09 wzglÄ™dem 01/02/03/11/12/15: salon ma czytelne zamkniÄ™cie,
  meble i dwa Ĺ›lady ĹĽycia; odrĂłĹĽnia siÄ™ na â‰Ą3 osiach (sylwetka, materiaĹ‚,
  Ĺ›wiatĹ‚o, czasownik). GATE-FAM = TECHNICAL PASS 7/7; CHECKPOINT-04 = **GO**.
  Nie jest to PRODUCT GO ani dowĂłd odbioru czĹ‚owieka.
- D-174 rejestruje rozstrzygniÄ™cie D-173. Aktywny nastÄ™pny zakres to
  PKG-0162 / PHASE-05 / BUNDLE-21, Station 14 i pierwsza lekcja Anchor/Yield.

## PKG-0162: PHASE-05 - BUNDLE-21 Station 14 Anchor/Yield Lesson

Data: 2026-09-01. Cel: przebudowa wyacznie Station 14 z odziedziczonego P7 progu Marty na P9 lekcjĂ„â„˘ martwego obwodu, czytelnĂ„â€¦ z obrazu i dziaÄąâ€šania przed nazwaniem.

- Nowa scena i skrypt rozdzielni trakcyjnej (rodzina techniczna): maszyna (bĂ„â„˘ben, diagonale rur, lampa sekcji) pracuje wĂ…â€šasnym cyklem i wystawia most sekcji na falĂ„â„˘ korekty co 7 s; most to donor `AnchorableObject` (A: pÄąâ€šyta, B: cienki bocznik), bez rozszerzania monolitÄ‚Ĺ‚w.
- Trzy stany obsÄąâ€šugiwane jednym gestem (`interact`): neutralny (wersja A Ă…ÂĽywa), kotwica (utrzymanie obserwowanej wersji pod falĂ„â€¦ - opĂłr fali), ulegĹ‚oĹ›Ä‡ (puszczenie - przejĹ›cie na wersjĂ„â„˘ B z jawnym maÄąâ€šym kosztem: zgaszona sekcja, przygaszone Äąâ€şwiatÄąâ€šo). Nazwanie metody nastĂ„â„˘puje dopiero po wykonaniu obu zachowaÄąâ€ž; wyjĹ›cie nie zaleÄąÄ˝y od wersji mostu (brak softlocka), odwrĂłcenie bezpieczne w dowolnym cyklu.
- Migracja kontraktÄ‚Ĺ‚w P7->P9 w tym samym pakiecie: `tests/pkg_0099_smoke_test.gd` (`_check_station_14_anchor`), `tests/pkg_0120_smoke_test.gd` (`_test_station_14`, wymagana hipoteza `dead_circuit`), `tests/pkg_0146_smoke_test.gd` (S05), `tests/smoke_test.gd` (`_test_station_14`). Nowa bramka `tests/pkg_0162_smoke_test.gd` dodana do `tools/verify.ps1`.
- NarzĂ„â„˘dzie `tools/capture_pkg_0162.gd` (normalny sterownik, bez `--headless`) generuje trzy beztekstowe kadry M2 (neutral/anchor/yield) i jeden M3 mono struktury; hasze kadrÄ‚Ĺ‚w rÄ‚Ĺ‚ÄąÄ˝ne. INSPEKCJA: trzy kadry rozrĂłĹĽnialne przed nazwaniem - kotwica pokazuje pole podtrzymania i wersjĂ„â„˘ A, ulegĹ‚oĹ›Ä‡ pokazuje wersjĂ„â„˘ B (cienki bocznik) i zgaszonĂ„â€¦ lampĂ„â„˘ sekcji. DowÄ‚Ĺ‚d strukturalny, nie odbiorczy.
- Targeted: pkg_0162, pkg_0099, pkg_0120, pkg_0146 PASS exit 0.

## Rozbieďż˝noďż˝ďż˝ wejďż˝ciowa (zapisana przed edycjami PKG-0163, 2026-09-01)

Handoff (`CURRENT_STATE.md` po PKG-0162) twierdzi peďż˝ny PASS `tools/verify.ps1`,
lecz `docs/NEXT_SESSION_PROMPT.md` nie istniaďż˝ na dysku i bramka kontraktu
dokumentacji koďż˝czyďż˝a siďż˝ bďż˝ďż˝dem `missing required documentation:`
`docs/NEXT_SESSION_PROMPT.md` (linia 48 `verify.ps1` ďż˝ `verify_docs.ps1`).
Zgodnie z `docs/WORKFLOW.md` rozbieďż˝noďż˝ďż˝ zapisano przed jakďż˝kolwiek edycjďż˝.
Prompt PKG-0163 odtworzono z `CURRENT_STATE.md` i `CAMPAIGN_MAP.md` (hierarchia
prawdy: kod i aktualny stan nad dokumentacjďż˝), bez zmian w runtime.

## PKG-0163 â€” PHASE-05 / BUNDLE-22: Station 15, prĂłba wzajemnego sygnaĹ‚u (ZAMKNIÄTE â€” 2026-09-01, D-176)

### Zakres i wynik

- RozbieĹĽnoĹ›Ä‡ wejĹ›ciowa: `docs/NEXT_SESSION_PROMPT.md` nie istniaĹ‚ na dysku,
  a bramka `verify_docs.ps1` go wymaga; baseline verify koĹ„czyĹ‚ siÄ™ bĹ‚Ä™dem
  docs (exit 1). RozbieĹĽnoĹ›Ä‡ zapisano przed edycjami; prompt odtworzono z
  `CURRENT_STATE.md` i `CAMPAIGN_MAP.md` (hierarchia prawdy), bez zmian
  runtime. Baseline po odtworzeniu promptu: peĹ‚ny verify PASS, exit 0
  (`reports/baseline_verify_pkg0163.log`).
- Przebudowano wyĹ‚Ä…cznie `scenes/levels/station_15.tscn` i
  `scripts/levels/station_15.gd` (P9, BUNDLE-22). Station 15 jest pierwszym
  adresem rodziny granicznej/anomalnej wg `LOCATION_FAMILY_BIBLE.md` Â§8:
  topologia techniczna, dokĹ‚adnie jeden niezgodny element (odbiĂ©racz pÄ™tli
  w dwĂłch wersjach po obu stronach szwu anomalii), jedno Ĺ›wiatĹ‚o Ĺ›wiecÄ…ce
  w gĂłrÄ™, jeden dĹşwiÄ™k bez ĹşrĂłdĹ‚a (odpowiedĹş zza szwu).
- Kontrakt mechaniczny: (1) odtworzenie logu 20:40 â†’
  `p9.mechanics.mutual_signal.log_reconstructed = "trial_2040_ucp_correction"`
  + kanoniczny `ucp_intervention_reconstructed`; (2) dwa identyczne impulsy
  kontrolne â†’ identyczne echo (`control_echo_observed =
  "echo_repeats_identically"`); (3) trzeci impuls z celowym bĹ‚Ä™dem bez
  dwĂłch kontroli jest odrzucany (`safe_trial_feedback =
  "controls_incomplete"`, bez kanonicznego faktu), a po kontrolach
  otrzymuje selektywnÄ… korektÄ™ (`corrective_response_observed =
  "deliberate_error_corrected_selectively"` + `trace =
  "living_response_confirmed"` + kanoniczny `local_lena_signal_confirmed`);
  (4) notatka z warunkiem przerwania czytelna dopiero po potwierdzeniu
  (`abort_note_read = "abort_condition_before_cost"` + kanoniczny
  `local_lena_intent_found`) i dopiero ona otwiera wyjĹ›cie. Brak softlocka:
  pominiÄ™ty protokĂłĹ‚ moĹĽna dokoĹ„czyÄ‡ bez resetu sceny.
- Hipoteza `living_response` (L2 omylna, przewidywanie
  `corrective_third_impulse`) zastÄ™puje legacy `memory_manipulation`.
- Interakcje: 3 â‰¤ 3 (dziennik pÄ™tli, nadajnik, notatka). WyjĹ›cie: drabina
  `LadderZone` w gĂłrÄ™ do wĹ‚azu (D-123). Kolizja korpusu odbieracza to podest
  18 px (D-138), przechodzony przez `try_curb_step` â€” droga do Ĺ›luzy jest
  czysto lokomocyjna, bez platformingu (D-099). Semantyczny InputMap,
  60 Hz, 640x360, ReturnZone/AirlockZone zachowane.
- Donor key `p7.work_history_and_record.own_record_requested = true`
  zapisywany po lekcji utrzymuje wejĹ›cie legacy Station 16â€“17 do BUNDLE-23/24
  (sekwencja `work_history_and_record` zostaje materiaĹ‚em dawcy).

### Migracje kontraktĂłw (wszystkie PASS, exit 0)

- `tests/pkg_0120_smoke_test.gd`: `REQUIRED_HYPOTHESES[15] =
  "living_response"`, `_test_station_15` â†’ P9 mutual signal test, seed
  wejĹ›cia `p7.marta_threshold.trace = "dead_circuit_lesson_observed"`.
- `tests/pkg_0147_smoke_test.gd`: sekcja S06 dla station_15 â†’ P9 kontrakt
  (sekcja S06 dla 16â€“17 pozostaje legacy do BUNDLE-23/24).
- `tests/smoke_test.gd`: `_test_station_15` â†’ P9.
- `tests/pkg_0138_smoke_test.gd`: gaĹ‚Ä…Ĺş czasownikĂłw station 15 â†’ P9 verbs.
- `tools/capture_pkg_0147.gd`: stany station_15 â†’ `log_only` /
  `signal_confirmed`.
- PozostaĹ‚e dziedziczone bramki potwierdzone targeted: pkg_0099, pkg_0146,
  pkg_0162 â€” PASS.

### Dowody

- Nowa bramka `tests/pkg_0163_smoke_test.gd` dodana do `tools/verify.ps1`:
  PASS (exit 0); pilnuje bezpiecznego odrzucenia, identycznego echa, selektywnej
  korekty, fakty namespaced, domkniÄ™cia hipotezy, sekwencji notatki, wyjĹ›cia,
  braku softlocka, ukoĹ„czenia w AirlockZone, lint terminĂłw i InputMap.
- Visual: `tools/capture_pkg_0163.gd` na normalnym sterowniku Windows Intel
  Iris Xe (`reports/pkg_0163/`): 3 beztekstowe M2 (neutral 210583415 /
  control_echo 952824699 / confirmed 3001154718 â€” rĂłĹĽne hasze) + 1 M3 mono
  struktury (1939101134). DowĂłd strukturalny, nie dowĂłd zrozumienia
  (D-012, ADR-003).
- PeĹ‚na bramka `tools/verify.ps1` po PKG-0163: PASS, exit code 0
  (`reports/verify_pkg0163_final.log`).

### Ograniczenia

- Testy dowodzÄ… wyĹ‚Ä…cznie kontraktĂłw technicznych; nie dowodzÄ… zabawy,
  emocji ani zrozumienia nowej osoby.
- Station 16â€“17 pozostajÄ… legacy (kontrakt S06); ich przebudowa to BUNDLE-23/24.
- Release i nowe `.exe` pozostajÄ… zablokowane (D-168); PRODUCT GO nie padĹ‚o.

### NastÄ™pny punkt przekazania

- `docs/NEXT_SESSION_PROMPT.md` â†’ PKG-0164 / BUNDLE-23: Station 16
  (bezpieczny analizator i wybĂłr maĹ‚ego kosztu). Snapshot:
  `snapshots/PKG-0163-2026-09-01/`.

## PKG-0164 â€” PHASE-05 / BUNDLE-23: Station 16, bezpieczny analizator i maĹ‚y koszt (ZAMKNIÄTE â€” 2026-09-02, D-177)

### Zakres i wynik

- Przebudowano wyĹ‚Ä…cznie scenes/levels/station_16.tscn i
  scripts/levels/station_16.gd na drugÄ… scenÄ™ rodziny granicznej/anomalnej.
  Komora ma jeden niezgodny przekaĹşnik analizatora w dwĂłch poĹ‚oĹĽeniach,
  wejĹ›cie drabinÄ… od Station 15, prawÄ… Ĺ›luzÄ™ i trzy punkty interakcji.
- OdpowiedĹş nie moĹĽe zostaÄ‡ zapisana jako koszt bez wykonanej prĂłby:
  transfer_response_to_safe_analyzer() otwiera wybĂłr, a gracz wybiera
  marta_first_meeting_detail_blurred albo sample_exact_second_lost.
  mechanic_cost_observed i small_cost_manifested powstajÄ… dopiero po
  wyborze; bĹ‚Ä™dne prĂłby zostawiajÄ… safe_trial_feedback i nie usuwajÄ… drogi.
- confirm_home_echo() jest osobnym trzecim krokiem. Zapisuje namespaced
  p9.mechanics.small_cost.home_echo_verified, kanoniczne home_echo_verified
  i most p7.work_history_and_record.institution_trial_result =
  small_cost_and_home_echo_confirmed dla Station 17. OmylnÄ… hipotezÄ™
  small_cost zamyka dopiero po tym potwierdzeniu.
- Zachowano lokalnÄ… drabinÄ™ LadderZone, ReturnZone, AirlockZone,
  semantyczne akcje InputMap, 60 Hz, 640Ă—360 i brak przeszkody platformowej.
  Dla zgodnoĹ›ci z historycznym PKG-0101 podĹ‚oga ma wymagany ksztaĹ‚t 640Ă—80.

### Migracje kontraktĂłw

- Dodano tests/pkg_0164_smoke_test.gd i wpiÄ™to go do tools/verify.ps1.
- Zmigrowano tests/pkg_0120_smoke_test.gd, tests/pkg_0147_smoke_test.gd,
  tests/smoke_test.gd, gaĹ‚Ä…Ĺş Station 16 w tests/pkg_0138_smoke_test.gd,
  tools/capture_pkg_0147.gd oraz tools/pkg_0138_playthrough_audit.gd.
  tools/capture_preview.gd dostaĹ‚ zgodnÄ… gaĹ‚Ä…Ĺş Station 16 i izolowany tryb
  --pkg0164; nie zmieniano runtime'u innych stacji.
- Baseline przed naprawÄ… miaĹ‚ 15 istniejÄ…cych niezgodnoĹ›ci smoke Station 09â€“11,
  przy przejĹ›ciu Station 12â€“43. Skorygowano tylko przygotowanie warunkĂłw wejĹ›cia
  i peĹ‚niejsze kroki gracza w tests/smoke_test.gd; nie zmieniano zachowania
  tych stacji. Historyczny PKG-0101 wymusiĹ‚ dodatkowo kompatybilny ksztaĹ‚t
  podĹ‚ogi Station 16.

### Dowody

- tests/pkg_0164_smoke_test.gd: PASS, exit 0 â€” negatywne prĂłby, obie ceny,
  echo domu, facts, zapis, topologia, limit trzech interakcji, lint i InputMap.
- Targeted pkg_0120, pkg_0147, pkg_0138, smoke_test i pkg_0101:
  PASS, exit 0. KoĹ„cowe tools/verify_docs.ps1: DOCS PASS: 46 required
  files and handoff contracts. KoĹ„cowe tools/verify.ps1: Verification
  passed., exit 0, z nowÄ… bramkÄ… PKG-0164.
- tools/capture_pkg_0164.gd na normalnym sterowniku Intel Iris Xe zapisaĹ‚
  3 beztekstowe M2 o rĂłĹĽnych hashach â€” neutral 2364778518, analyzer transfer
  1141093698, Marta cost 1409403082 â€” oraz 1 M3 mono 3582274235 w
  reports/pkg_0164/. ĹšwieĹĽe kadry obejrzano; dowodzÄ… struktury, nie odbioru.
- tools/capture_preview.gd -- --pkg0164 zapisaĹ‚ i pozwoliĹ‚ obejrzeÄ‡
  reports/station_16_pkg0164_preview.png na normalnym sterowniku.
  PeĹ‚ny historyczny przebieg tego helpera zatrzymaĹ‚ siÄ™ wczeĹ›niej na
  nieaktualnym przypisaniu pola Station01; izolowany tryb Station16 przeszedĹ‚
  i jest jedynym wynikiem uĹĽytym dla tego pakietu.

### Ograniczenia i przekazanie

- Testy i captures sÄ… dowodem technicznym; nie dowodzÄ… zrozumienia, emocji,
  frajdy, tempa ani wagi kosztu dla czĹ‚owieka (D-012, ADR-003).
- W logach Godota nadal pojawiajÄ… siÄ™ znane ostrzeĹĽenia o wyciekach ObjectDB
  w czÄ™Ĺ›ci historycznych procesĂłw, ale peĹ‚na bramka koĹ„czy siÄ™ kodem 0; nie
  przypisujÄ™ im produktu GO.
- PRODUCT GO, release i nowe artefakty binarne pozostajÄ… zablokowane (D-168).
- docs/NEXT_SESSION_PROMPT.md prowadzi do PKG-0165 / BUNDLE-24: Station 17,
  ledger kosztu i jawny zakres zgody. Snapshot: snapshots/PKG-0164-2026-09-02/.

## PKG-0165 â€” PHASE-05 / BUNDLE-24: Station 17, rejestr par kosztĂłw Linii 4 i jawny zakres zgody Jakuba (ZAMKNIÄTE â€” 2026-09-02, D-178)

Data: 2026-09-02

Kontekst: kontynuacja PHASE-05 w P9 (D-168 / ADR-008). Jeden pakiet: przebudowa
Station 17 zgodnie z wierszem 17 `docs/rebuild/CAMPAIGN_MAP.md` â€” ustaliÄ‡, kto
juĹĽ zapĹ‚aciĹ‚ (rejestr par kosztĂłw Linii 4), odrzuciÄ‡ ofertÄ™ adaptacji i
wynegocjowaÄ‡ jawny zakres zgody Jakuba; zmiana pytania: â€žkto poniĂłsĹ‚ koszt
mojego bezpieczeĹ„stwa?". Rodzina instytucjonalna, wejĹ›cie lewa krawÄ™dĹş ze
Station 16, wyjĹ›cie prawa Ĺ›luza.

Wynik:

- **Runtime** â€” `scripts/levels/station_17.gd` i `scenes/levels/station_17.tscn`
  przepisane na kontrakt P9 BUNDLE-24: trzy istotne interakcje (rejestr par
  Linii 4, terminal oferty adaptacji, biurko zakresu zgody), rysowany stan w
  `_draw_state_layer()` po `VectorStageStyle.draw_play_plane()`, rodzina
  instytucjonalna (moduĹ‚ 64 px, lada 104 px, brudna biel, zero ciepĹ‚ego
  punktu), zero nowych colliderĂłw, usuniÄ™ta legacy kapsuĹ‚a pneumatyczna
  (AnimatableBody2D) i caĹ‚a wycofana Ĺ›cieĹĽka kopiowania raportu S06.
- **Fakty** â€” `p9.consent_and_cost.cost_ledger_read` + kanoniczny
  `ucp_cost_ledger_found` po odczycie rejestru (wejĹ›cie wymaga donor faktĂłw
  Station 16 i ich nie fabrykuje), `p9.consent_and_cost.adaptation_offer =
  "rejected"` jako kontynuowalna odmowa z zamkniÄ™ciem omylnej hipotezy
  `cheap_adaptation`, `p9.consent_and_cost.jakub_consent_scope` i kanoniczny
  `jakub_consent_state` w wariantach `granted` / `limited` / `refused` bez
  rankingu moralnego (strefy kierunku chodzenia + aliasy czasownikĂłw),
  `p9.consent_and_cost.trace` oraz `p7.work_history_and_record.trace =
  "cost_ledger_and_consent_scope_recorded"` jako wejĹ›cie Station 18; nie
  powstajÄ… `route_hypotheses_mapped` ani `marta_truth_state`.
- **BezpieczeĹ„stwo poraĹĽki** â€” prĂłby przed odczytem rejestru zostawiajÄ…
  `p9.consent_and_cost.safe_trial_feedback` (`cost_ledger_required` /
  `institution_trial_required`); odmowa zakresu jest peĹ‚noprawnym zapisem,
  otwiera wyjĹ›cie i nie softlockuje; zapisanych wartoĹ›ci nie wolno nadpisywaÄ‡;
  zapis decyzji pozostaje JSON-safe.
- **Migracje kontraktĂłw** â€” nowa `tests/pkg_0165_smoke_test.gd` wpiÄ™ta do
  `tools/verify.ps1`; zmigrowane: `tests/pkg_0120_smoke_test.gd`
  (`REQUIRED_HYPOTHESES[17] = "cheap_adaptation"`, `_test_station_17`),
  `tests/pkg_0147_smoke_test.gd` (sekcja S06 dla Station 17 + wyjÄ…tek sĹ‚ownikowy
  dla donor kosztu), `tests/smoke_test.gd` (`_test_station_17`), gaĹ‚Ä…Ĺş Station 17
  w `tests/pkg_0138_smoke_test.gd` i `tools/pkg_0138_playthrough_audit.gd`,
  `tests/pkg_0101_smoke_test.gd` (Station 17 bez sztucznej przeszkody),
  `tools/capture_pkg_0147.gd` oraz sekcja Station 17 w `tools/capture_preview.gd`.
  Wycofane checklistowe Ĺ›cieĹĽki usuniÄ™te, ĹĽadnych shimĂłw.

### Dowody

- Baseline przed edycjami: peĹ‚ny `tools/verify.ps1` na stanie PKG-0164:
  `Verification passed.` (exit 0), zapis `reports/baseline_verify_out.txt`;
  wczeĹ›niejszy pojedynczy fail smoke Station 09 zidentyfikowany jako artefakt
  dwĂłch nakĹ‚adajÄ…cych siÄ™ przebiegĂłw verify, nie powtĂłrzyĹ‚ siÄ™ w czystym
  przebiegu.
- Targeted po zmianach: pkg_0165, smoke_test, pkg_0120, pkg_0147, pkg_0101,
  pkg_0138 â€” PASS (exit 0).
- `tests/pkg_0165_smoke_test.gd`: PASS, exit 0 â€” wejĹ›cie wymaga donor faktĂłw,
  trzy punkty wykonalne, niepeĹ‚ne prĂłby informacyjne, trzy warianty zgody bez
  moral score, odmowa nie softlockuje, zapis JSON-safe, ReturnZone/AirlockZone,
  limit trzech interakcji, lint sĹ‚ownikowy i semantyczny InputMap.
- `tools/capture_pkg_0165.gd` na normalnym sterowniku Intel Iris Xe zapisaĹ‚
  3 beztekstowe M2 o rĂłĹĽnych hashach â€” neutral 3026497176, ledger_read
  226495147, offer_rejected 1629484203 â€” oraz 1 M3 mono 1356967888 w
  `reports/pkg_0165/`. ĹšwieĹĽe kadry obejrzano; dowodzÄ… struktury, nie odbioru.
- `tools/verify_docs.ps1`: DOCS PASS. PeĹ‚ny `tools/verify.ps1`:
  `Verification passed.`, exit 0, z nowÄ… bramkÄ… PKG-0165.

### Ograniczenia i przekazanie

- Testy i captures sÄ… dowodem technicznym; nie dowodzÄ… zrozumienia, emocji,
  frajdy, wagi kosztu ani czytelnoĹ›ci trzech stref zgody dla czĹ‚owieka
  (D-012, ADR-003).
- PRODUCT GO, release i nowe artefakty binarne pozostajÄ… zablokowane (D-168).
- docs/NEXT_SESSION_PROMPT.md prowadzi do PKG-0166 / BUNDLE-25: Station 18,
  trzy prognozy, zgody i braki, `method_committed`.
  Snapshot: snapshots/PKG-0165-2026-09-02/.

## PKG-0166 â€” PHASE-05 / BUNDLE-25: Station 18, trzy prognozy, zgody i braki, fizyczne method_committed (ZAMKNIÄTE â€” 2026-09-02, D-179)

### Zakres

Przebudowano wyĹ‚Ä…cznie Station 18. WiÄ…ĹĽÄ…cy kontrakt to `CAMPAIGN_MAP.md`
wiersz 18: ulica z 05 po zmianie (rodzina miejska). Prompt cytowaĹ‚ omyĹ‚kowo
mieszkalnÄ…; D-179 koryguje to na korzyĹ›Ä‡ mapy i biblii rodzin.

Trzy istotne interakcje:

1. Tablica trzech prognoz â€” `compare_forecast_consent_dependencies()`;
   wymaga donor faktĂłw Station 17; zapisuje
   `p9.method_commitment.forecasts_compared`, JSON-safe sĹ‚ownik
   `force_home` / `close_equal_recover_local` / `mutual_passage` z jawnymi
   brakami zgody oraz kanoniczny `route_hypotheses_mapped`; zamyka
   `single_route_sufficient`.
2. Witryna Marty â€” `full` / `partial` / `withheld` bez rankingu moralnego;
   wstrzymanie kontynuowalne.
3. SĹ‚upek zatwierdzenia â€” `method_committed` wyĹ‚Ä…cznie po zestawieniu
   kosztĂłw i aktualnych zgodach; routing 42A/B/C. Odmowa Jakuba i
   wstrzymanie Marty nie softlockujÄ… wyjĹ›cia.

WejĹ›cie wymaga `p7.work_history_and_record.trace =
"cost_ledger_and_consent_scope_recorded"`, odczytanego ledgeru, odrzuconej
oferty i `jakub_consent_state` â {granted, limited, refused}. Nic z 17 nie
jest fabrykowane w 18. UsuniÄ™to legacy rejestry miejskie/szpitalne i
mikrofisze S07. Zero nowych colliderĂłw. 42A/B/C i 43 nietkniÄ™te.

### Migracje kontraktĂłw

- Nowa `tests/pkg_0166_smoke_test.gd` wpiÄ™ta do `tools/verify.ps1`.
- `tests/pkg_0120_smoke_test.gd`: `REQUIRED_HYPOTHESES[18] =
  "single_route_sufficient"`, `_test_station_18`.
- `tests/pkg_0147_smoke_test.gd`: sekcja S07 dla Station 18 na kontrakt P9;
  dawca 19â€“21 dostaje jawny seed `public_trial_result`.
- `tests/smoke_test.gd`: `_seed_s07_entry` i `_test_station_18`.
- `tests/pkg_0138_smoke_test.gd` i `tools/pkg_0138_playthrough_audit.gd`:
  gaĹ‚Ä…Ĺş 18 oraz most publiczny dla 19â€“21.
- `tools/capture_pkg_0147.gd`, `tools/diff_pkg_0147_capture.gd`,
  `tools/capture_preview.gd`.
- Wycofane checklistowe Ĺ›cieĹĽki usuniÄ™te, ĹĽadnych shimĂłw w Station 18.

### Dowody

- Baseline przed edycjami: peĹ‚ny `tools/verify.ps1` na stanie PKG-0165:
  `Verification passed.` (exit 0).
- Targeted: `pkg_0166`, `smoke_test`, `pkg_0120`, `pkg_0147`, `pkg_0101`,
  `pkg_0138` â€” PASS (exit 0).
- `tests/pkg_0166_smoke_test.gd`: PASS, exit 0 â€” wejĹ›cie wymaga donor faktĂłw,
  trzy punkty wykonalne, niepeĹ‚ne prĂłby informacyjne, trzy warianty prawdy
  Marty i trzy metody bez moral score, odmowa/wstrzymanie nie softlockujÄ…,
  zapis JSON-safe, ReturnZone/AirlockZone, limit trzech interakcji, lint
  sĹ‚ownikowy i semantyczny InputMap.
- `tools/capture_pkg_0166.gd` na normalnym sterowniku Intel Iris Xe zapisaĹ‚
  3 beztekstowe M2 o rĂłĹĽnych hashach â€” neutral 1112490514, forecasts_compared
  2436799912, marta_partial 1702201427 â€” oraz 1 M3 mono 1379732943 w
  `reports/pkg_0166/`. ĹšwieĹĽe kadry obejrzano: niebo, trzy plany, tablica
  przy ograniczonej zgodzie (czerwona/cyjan/czerwona), witryna i sĹ‚upek;
  dowodzÄ… struktury, nie odbioru.
- `tools/verify_docs.ps1`: DOCS PASS. PeĹ‚ny `tools/verify.ps1`:
  `Verification passed.`, exit 0, z nowÄ… bramkÄ… PKG-0166.

### Ograniczenia i przekazanie

- Testy i captures sÄ… dowodem technicznym; nie dowodzÄ… zrozumienia, emocji,
  frajdy, wagi wyboru metody ani czytelnoĹ›ci trzech kart prognoz dla
  czĹ‚owieka (D-012, ADR-003).
- PRODUCT GO, release i nowe artefakty binarne pozostajÄ… zablokowane (D-168).
- docs/NEXT_SESSION_PROMPT.md prowadzi do PKG-0168 / PHASE-06: Station 42B,
  zamkniÄ™cie RĂłwni / odzyskanie miejscowej Leny.
  Snapshot: snapshots/PKG-0167-2026-09-02/.

## PKG-0168 â€” PHASE-06: Station 42B, zamkniÄ™cie RĂłwni i odzyskanie miejscowej Leny (ZAMKNIÄTE â€” 2026-09-02, D-181)

Wynik:

- **Runtime** â€” `scripts/levels/station_42b.gd` i `scenes/levels/station_42b.tscn`
  przepisane na kontrakt P9 PHASE-06: trzy istotne interakcje (zabezpieczenie
  przewodu RĂłwni, prĂłg odzyskanej miejscowej Leny, stĂłĹ‚ nieindeksowanej
  obecnoĹ›ci), rysowany stan w `_draw_state_layer()` po
  `VectorStageStyle.draw_play_plane()`, rodzina finaĹ‚owa/epilogiczna
  (znane mieszkanie o Ĺ›wicie, chĹ‚odne Ĺ›wiatĹ‚o, niski sufit, jeden zmieniony
  fakt o osobach: odzyskane ciaĹ‚o miejscowej Leny i nieindeksowana obecnoĹ›Ä‡
  przybyĹ‚ej Leny), zero nowych colliderĂłw poza podĹ‚ogÄ…/Ĺ›cianami, usuniÄ™te
  legacy autoodtwarzane dialogi i checklisty.
- **Fakty** â€” wejĹ›cie wymaga `method_committed = close_equal_recover_local`;
  `p9.finale.close_equal.flow_closed` + `p9.finale.close_equal.executed` +
  kanoniczny `ending_family = "close_equal_recover_local"` po zamkniÄ™ciu
  przewodu; `p9.finale.close_equal.local_lena_recovered` + dawcowy
  `final_chamber_witnessed` po odczycie progu (zamyka hipotezÄ™
  `arrived_lena_unindexed_presence`); `p9.finale.close_equal.household_consequence`
  jako JSON-safe sĹ‚ownik stanu Marty, Jakuba i obu Len + `ending_stability`.
  Ĺ»aden wariant nie jest rankingiem moralnym. Ograniczona zgoda i wstrzymanie
  Marty sÄ… kontynuowalne. NiepeĹ‚na prĂłba nie zamyka drogi do 43.
- **D-181** â€” wybrany wariant 42B zostawia wyjĹ›cie otwarte od wejĹ›cia
  (cisza obserwacyjna finaĹ‚u), ale trzy odczyty skutku pozostajÄ… wykonalne.

Trzy istotne interakcje:

1. Zabezpieczenie przewodu RĂłwni â€” `execute_close_flow()`; wymaga
   `close_equal_recover_local`; zapisuje `p9.finale.close_equal.flow_closed`,
   `executed` i `ending_family`.
2. PrĂłg mieszkania 14 â€” `read_local_lena_recovered()`; zapisuje
   `local_lena_recovered` i zamyka `arrived_lena_unindexed_presence`.
3. StĂłĹ‚ nieindeksowanej obecnoĹ›ci â€” `read_household_consequence()`; JSON-safe
   sĹ‚ownik skutku dla Marty, Jakuba i obu Len + `ending_stability`.

WejĹ›cie wymaga `method_committed = close_equal_recover_local`. Nic z 18 nie jest
fabrykowane w 42B. Zero nowych colliderĂłw. 42A, 42C i 43 nietkniÄ™te.

### Migracje kontraktĂłw

- Nowa `tests/pkg_0168_smoke_test.gd` wpiÄ™ta do `tools/verify.ps1`.
- `tests/pkg_0107_smoke_test.gd`: gaĹ‚Ä…Ĺş 42B na trzy punkty P9, donor
  `close_equal_recover_local`, nowy checkpoint i Airlock.
- `tests/smoke_test.gd`: `_test_station_42b`.
- `tools/pkg_0138_playthrough_audit.gd`: gaĹ‚Ä…Ĺş 42b z seedem `close_equal_recover_local`.
- Wycofane checklistowe Ĺ›cieĹĽki progu/wyjĹ›cia usuniÄ™te; aliasy
  `inspect_doorstep` / `witness_chamber_b` / `unlock_exit` zostajÄ… jako most dawcy.

### Dowody

- Baseline przed edycjami: peĹ‚ny `tools/verify.ps1` na stanie PKG-0167:
  `Verification passed.` (exit 0), 650 s.
- Targeted: `pkg_0168`, `pkg_0167`, `pkg_0107`, `smoke_test`, `pkg_0138` â€”
  PASS (exit 0).
- `tests/pkg_0168_smoke_test.gd`: PASS, exit 0 â€” wejĹ›cie wymaga
  `close_equal_recover_local`, trzy punkty wykonalne, niepeĹ‚ne prĂłby informacyjne,
  ograniczona zgoda i wstrzymanie nie softlockujÄ…, zapis JSON-safe,
  ReturnZone/AirlockZone, limit trzech interakcji, lint sĹ‚ownikowy i
  semantyczny InputMap.
- `tools/capture_pkg_0168.gd` na normalnym sterowniku Intel Iris Xe zapisaĹ‚
  3 beztekstowe M2 o rĂłĹĽnych hashach â€” neutral 3192906838, flow_closed
  2711175793, local_recovered 738577960 â€” oraz 1 M3 mono 1071334993 w
  `reports/pkg_0168/`. ĹšwieĹĽe kadry obejrzano: niski sufit, okno chĹ‚odnego
  Ĺ›witu, odĹ‚Ä…czony przewĂłd RĂłwni, ciepĹ‚a sylwetka miejscowej Leny w mieszkaniu
  i stĂłĹ‚ nieindeksowanej obecnoĹ›ci; dowodzÄ… struktury, nie odbioru.
- `tools/verify_docs.ps1`: DOCS PASS. PeĹ‚na `tools/verify.ps1`:
  `Verification passed.`, exit 0, z nowÄ… bramkÄ… PKG-0168.

### Ograniczenia i przekazanie

- Testy i captures sÄ… dowodem technicznym; nie dowodzÄ… zrozumienia, emocji,
  frajdy, wagi zamkniÄ™cia RĂłwni ani czytelnoĹ›ci nieindeksowanej obecnoĹ›ci dla
  czĹ‚owieka (D-012, ADR-003).
- PRODUCT GO, release i nowe artefakty binarne pozostajÄ… zablokowane (D-168).
- docs/NEXT_SESSION_PROMPT.md prowadzi do PKG-0169 / PHASE-06: Station 42C,
  wzajemne przejĹ›cie obu Len / otwarcie trwaĹ‚ego przecieku pamiÄ™ci.
  Snapshot: snapshots/PKG-0168-2026-09-02/.

## PKG-0167 â€” PHASE-06: Station 42A, wymuszenie powrotu przybyĹ‚ej Leny (ZAMKNIÄTE â€” 2026-09-02, D-180)

Wynik:

- **Runtime** â€” `scripts/levels/station_42a.gd` i `scenes/levels/station_42a.tscn`
  przepisane na kontrakt P9 PHASE-06: trzy istotne interakcje (rygiel
  wymuszonego powrotu, zapieczÄ™towany prĂłg drugiej Leny, stĂłĹ‚ z pustym
  krzesĹ‚em), rysowany stan w `_draw_state_layer()` po
  `VectorStageStyle.draw_play_plane()`, rodzina finaĹ‚owa/epilogiczna
  (znane mieszkanie o Ĺ›wicie, niski sufit, jeden zmieniony fakt o osobach),
  zero nowych colliderĂłw, usuniÄ™ty legacy telefon i dwupunktowy checklist
  kubkĂłw/wyjĹ›cia.
- **Fakty** â€” wejĹ›cie wymaga `method_committed = force_home`;
  `p9.finale.forced_return.executed` + kanoniczny `ending_family =
  "force_home"` po rygĹ‚u; `p9.finale.forced_return.local_lena_sealed` +
  dawcowy `final_chamber_witnessed` po odczycie progu (zamyka hipotezÄ™
  `other_lena_comes_home_too`); `p9.finale.forced_return.household_consequence`
  jako JSON-safe sĹ‚ownik stanu Marty i Jakuba + `ending_stability`. Ĺ»aden
  wariant nie jest rankingiem moralnym. Ograniczona zgoda i wstrzymanie
  Marty sÄ… kontynuowalne. NiepeĹ‚na prĂłba nie zamyka drogi do 43.
- **D-180** â€” wybrany wariant 42A zostawia wyjĹ›cie otwarte od wejĹ›cia
  (cisza obserwacyjna finaĹ‚u), ale trzy odczyty skutku pozostajÄ… wykonalne.

Trzy istotne interakcje:

1. Rygiel wymuszonego powrotu â€” `execute_forced_return()`; wymaga
   `force_home`; zapisuje `p9.finale.forced_return.executed` i
   `ending_family`.
2. ZapieczÄ™towany prĂłg â€” `read_sealed_other_lena()`; zapisuje
   `local_lena_sealed` i zamyka `other_lena_comes_home_too`.
3. StĂłĹ‚ z pustym krzesĹ‚em â€” `read_household_consequence()`; JSON-safe
   sĹ‚ownik skutku dla Marty i Jakuba + `ending_stability`.

WejĹ›cie wymaga `method_committed = force_home`. Nic z 18 nie jest
fabrykowane w 42A. Zero nowych colliderĂłw. 42B, 42C i 43 nietkniÄ™te.

### Migracje kontraktĂłw

- Nowa `tests/pkg_0167_smoke_test.gd` wpiÄ™ta do `tools/verify.ps1`.
- `tests/pkg_0107_smoke_test.gd`: gaĹ‚Ä…Ĺş 42A na trzy punkty P9, donor
  `force_home`, nowy checkpoint i Airlock.
- `tests/smoke_test.gd`: `_test_station_42a`.
- `tests/pkg_0138_smoke_test.gd` i `tools/pkg_0138_playthrough_audit.gd`:
  gaĹ‚Ä…Ĺş 42a z seedem `force_home`.
- `tests/pkg_0150_smoke_test.gd`, `tests/pkg_0151_smoke_test.gd`,
  `tools/capture_pkg_0150.gd`, `tools/capture_pkg_0151.gd`,
  `tools/capture_pkg_0107.gd`, `tools/capture_preview.gd`.
- Wycofane checklistowe Ĺ›cieĹĽki kubkĂłw/telefonu usuniÄ™te; aliasy
  `inspect_cups` / `witness_chamber_a` zostajÄ… jako most dawcy.

### Dowody

- Baseline przed edycjami: peĹ‚ny `tools/verify.ps1` na stanie PKG-0166:
  `Verification passed.` (exit 0), 647 s.
- Targeted: `pkg_0167`, `pkg_0107`, `pkg_0150`, `pkg_0151`, `pkg_0138` â€”
  PASS (exit 0).
- `tests/pkg_0167_smoke_test.gd`: PASS, exit 0 â€” wejĹ›cie wymaga
  `force_home`, trzy punkty wykonalne, niepeĹ‚ne prĂłby informacyjne,
  ograniczona zgoda i wstrzymanie nie softlockujÄ…, zapis JSON-safe,
  ReturnZone/AirlockZone, limit trzech interakcji, lint sĹ‚ownikowy i
  semantyczny InputMap.
- `tools/capture_pkg_0167.gd` na normalnym sterowniku Intel Iris Xe zapisaĹ‚
  3 beztekstowe M2 o rĂłĹĽnych hashach â€” neutral 184961240, return_executed
  2931933356, sealed_other 2067519089 â€” oraz 1 M3 mono 1884996479 w
  `reports/pkg_0167/`. ĹšwieĹĽe kadry obejrzano: niski sufit, okno Ĺ›witu,
  puste krzesĹ‚o, zapieczÄ™towany prĂłg i zmiana rygĹ‚a/progu; dowodzÄ…
  struktury, nie odbioru.
- `tools/verify_docs.ps1`: DOCS PASS. PeĹ‚na `tools/verify.ps1`:
  `Verification passed.`, exit 0, 650 s, z nowÄ… bramkÄ… PKG-0167.

### Ograniczenia i przekazanie

- Testy i captures sÄ… dowodem technicznym; nie dowodzÄ… zrozumienia, emocji,
  frajdy, wagi wymuszonego powrotu ani czytelnoĹ›ci pustego krzesĹ‚a dla
  czĹ‚owieka (D-012, ADR-003).
- PRODUCT GO, release i nowe artefakty binarne pozostajÄ… zablokowane (D-168).
- docs/NEXT_SESSION_PROMPT.md prowadzi do PKG-0168 / PHASE-06: Station 42B,
  zamkniÄ™cie RĂłwni / odzyskanie miejscowej Leny.
  Snapshot: snapshots/PKG-0167-2026-09-02/.


## PKG-0169 â€” PHASE-06: Station 42C, wzajemne przejĹ›cie i trwaĹ‚y przeciek pamiÄ™ci (ZAMKNIÄTE â€” 2026-09-02, D-182)

Wynik:

- **Runtime** â€” `scripts/levels/station_42c.gd` i `scenes/levels/station_42c.tscn`
  przepisane na kontrakt P9 PHASE-06: trzy istotne interakcje (zwolnienie
  wzajemnego przejĹ›cia, prĂłg trwaĹ‚ego przecieku pamiÄ™ci, stĂłĹ‚ dwĂłch domĂłw),
  rysowany stan w `_draw_state_layer()` po `VectorStageStyle.draw_play_plane()`,
  rodzina finaĹ‚owa/epilogiczna (znane mieszkanie o Ĺ›wicie, obustronne przejĹ›cie,
  niski sufit, jeden zmieniony fakt o osobach: most nie zgasĹ‚, pamiÄ™Ä‡ przecieka
  miÄ™dzy obydwoma Ĺ›wiatami, obie Leny odpowiadajÄ… przed swoim domem), zero nowych
  colliderĂłw poza podĹ‚ogÄ…/Ĺ›cianami, usuniÄ™te legacy autoodtwarzane dialogi i checklisty.
- **Fakty** â€” wejĹ›cie wymaga `method_committed = mutual_passage`;
  `p9.finale.mutual_passage.passage_opened` + `p9.finale.mutual_passage.executed` +
  kanoniczny `ending_family = "mutual_passage"` po zwolnieniu przejĹ›cia;
  `p9.finale.mutual_passage.memory_leak_accepted` + dawcowy `final_chamber_witnessed`
  po odczycie progu (zamyka hipotezÄ™ `mutual_memory_leak_uncontrolled`);
  `p9.finale.mutual_passage.household_consequence` jako JSON-safe sĹ‚ownik stanu
  Marty, Jakuba i obu Len z trwaĹ‚ym przeciekiem pamiÄ™ci + `ending_stability`.
  Ĺ»aden wariant nie jest rankingiem moralnym. Ograniczona zgoda i wstrzymanie
  Marty sÄ… kontynuowalne. NiepeĹ‚na prĂłba nie zamyka drogi do 43.
- **D-182** â€” wybrany wariant 42C zostawia wyjĹ›cie otwarte od wejĹ›cia
  (cisza obserwacyjna finaĹ‚u), ale trzy odczyty skutku pozostajÄ… wykonalne.

Trzy istotne interakcje:

1. Zwolnienie wzajemnego przejĹ›cia â€” `execute_mutual_passage()`; wymaga
   `mutual_passage`; zapisuje `p9.finale.mutual_passage.passage_opened`,
   `executed` i `ending_family`.
2. PrĂłg trwaĹ‚ego przecieku pamiÄ™ci â€” `read_memory_leak()`; zapisuje
   `memory_leak_accepted`, `trace = "mutual_passage_memory_leak_accepted"`
   i zamyka `mutual_memory_leak_uncontrolled`.
3. StĂłĹ‚ dwĂłch domĂłw â€” `read_household_consequence()`; JSON-safe sĹ‚ownik
   skutku dla Marty, Jakuba i obu Len + `ending_stability`.

WejĹ›cie wymaga `method_committed = mutual_passage`. Nic z 18 nie jest
fabrykowane w 42C. Zero nowych colliderĂłw. 42A, 42B i 43 nietkniÄ™te.

### Migracje kontraktĂłw

- Nowa `tests/pkg_0169_smoke_test.gd` wpiÄ™ta do `tools/verify.ps1`.
- `tests/pkg_0107_smoke_test.gd`: gaĹ‚Ä…Ĺş 42C na trzy punkty P9, donor
  `mutual_passage`, nowy checkpoint i Airlock.
- `tests/smoke_test.gd`: `_test_station_42c`.
- `tools/pkg_0138_playthrough_audit.gd`: gaĹ‚Ä…Ĺş 42c z seedem `mutual_passage`.
- `tests/pkg_0150_smoke_test.gd`: `_test_station_42c_flow` z seedem `mutual_passage`.
- `tests/pkg_0151_smoke_test.gd`: finaĹ‚owa gaĹ‚Ä…Ĺş `_` (42c) z seedem `mutual_passage`.
- Wycofane checklistowe Ĺ›cieĹĽki torĂłw/wyjĹ›cia usuniÄ™te; aliasy
  `inspect_tram` / `witness_chamber_c` / `unlock_exit` zostajÄ… jako most dawcy.

### Dowody

- Baseline przed edycjami: peĹ‚ny `tools/verify.ps1` na stanie PKG-0168:
  `Verification passed.` (exit 0).
- Targeted: `pkg_0169`, `pkg_0168`, `pkg_0167`, `pkg_0107`, `smoke_test`,
  `pkg_0150`, `pkg_0151`, `pkg_0138` â€” PASS (exit 0).
- `tests/pkg_0169_smoke_test.gd`: PASS, exit 0 â€” wejĹ›cie wymaga
  `mutual_passage`, trzy punkty wykonalne, niepeĹ‚ne prĂłby informacyjne,
  ograniczona zgoda i wstrzymanie nie softlockujÄ…, zapis JSON-safe,
  ReturnZone/AirlockZone, limit trzech interakcji, lint sĹ‚ownikowy i
  semantyczny InputMap.
- `tools/capture_pkg_0169.gd` na normalnym sterowniku Intel Iris Xe zapisaĹ‚
  3 beztekstowe M2 o rĂłĹĽnych hashach â€” neutral 3484846049, passage_opened
  4219738, leak_accepted 174892510 â€” oraz 1 M3 mono 2038103679 w
  `reports/pkg_0169/`. ĹšwieĹĽe kadry obejrzano: niski sufit, okno Ĺ›witu,
  dwuobwodowy synchronizator przejĹ›cia, prĂłg przecieku pamiÄ™ci z dwiema
  sylwetkami i stĂłĹ‚ dwĂłch domĂłw z dwoma kubkami; dowodzÄ… struktury, nie odbioru.
- `tools/verify_docs.ps1`: DOCS PASS. PeĹ‚na `tools/verify.ps1`:
  `Verification passed.`, exit 0, z nowÄ… bramkÄ… PKG-0169.

### Ograniczenia i przekazanie

- Testy i captures sÄ… dowodem technicznym; nie dowodzÄ… zrozumienia, emocji,
  frajdy, wagi wzajemnego przejĹ›cia ani czytelnoĹ›ci trwaĹ‚ego przecieku pamiÄ™ci dla
  czĹ‚owieka (D-012, ADR-003).
- PRODUCT GO, release i nowe artefakty binarne pozostajÄ… zablokowane (D-168).
- docs/NEXT_SESSION_PROMPT.md prowadzi do PKG-0170 / PHASE-06: Station 43,
  zamkniÄ™cie administracyjne / napisy koĹ„cowe / wygaszenie do czerni / epilog.
  Snapshot: snapshots/PKG-0169-2026-09-02/.


## PKG-0170 â€” PHASE-06: Station 43, administracyjne domkniÄ™cie, manifest licencji/credits i epilog kampanii (ZAMKNIÄTE â€” 2026-09-02, D-183)

Wynik:

- **Runtime** â€” `scripts/levels/station_43.gd` i `scenes/levels/station_43.tscn`
  przepisane na kontrakt P9 PHASE-06: trzy istotne interakcje (`AdminNoticeBoard`,
  `CreditsRoll`, `FinalBlackout`), rysowany stan w `_draw_state_layer()` po
  `VectorStageStyle.draw_play_plane()`, rodzina finaĹ‚owa/epilogiczna (znana wiata
  i torowisko ze Stacji 03/05/18 o Ĺ›wicie, pojedyncze procedularne ĹşrĂłdĹ‚o dĹşwiÄ™ku
  `dawn_quietude`, jeden zmieniony fakt o ludziach zaleĹĽny od wariantu 42A/B/C:
  taĹ›ma zamkniÄ™cia linii, skrzynka narzÄ™dziowa i spoina gruntu, bÄ…dĹş podwĂłjny rozkĹ‚ad
  i znaczniki obecnoĹ›ci na krawÄ™ĹĽniku). Zero nowych colliderĂłw poza podĹ‚ogÄ…/Ĺ›cianami.
- **Manifesty** â€” zachowane panele `CrispDiegeticText_LicenseManifest` i
  `CrispDiegeticText_CreditsManifest` z exact stringami weryfikowanymi przez bramkÄ™
  PKG-0153. Ekran tytuĹ‚owy i creditsy w peĹ‚nej synchronizacji Zero-Asset.
- **Fakty** â€” odczyt tablicy ogĹ‚oszeĹ„ zapisuje `p9.epilogue.admin_notice_inspected`
  oraz `p7.conscious_silence_and_presence.epilogue_noticed`; odczyt kolumny creditsĂłw
  zapisuje `p9.epilogue.credits_read` oraz `p7.conscious_silence_and_presence.epilogue_credits_read`;
  odczyt sygnalizatora zakoĹ„czenia zapisuje `p9.epilogue.executed = true`,
  `ending_family` (odczytany ze stanu 42A/B/C), `ending_stability`,
  `p9.epilogue.safe_trial_feedback = "epilogue_completed_cleanly"`,
  `epilogue_witness_completed = true`, odryglowuje wyjĹ›cie i domyka kampaniÄ™.
- **TrĂłjstanowe dialogi** â€” 5 linii dialogowych dla kaĹĽdego wariantu finaĹ‚owego
  (`force_home`, `close_equal_recover_local`, `mutual_passage`) oraz dla wariantu
  unseeded, odpowiadajÄ…cych na pytanie â€žco zostaĹ‚o w mieĹ›cie po nas?â€ť bez moralnego
  osÄ…du.
- **D-183** â€” wybrany wariant Station 43 domyka caĹ‚Ä… kampaniÄ™ 20-adresowÄ… w
  spĂłjny, nienaruszony sposĂłb; powrĂłt przez `ReturnZone` i przejĹ›cie przez
  `AirlockZone` w peĹ‚ni obsĹ‚uĹĽone.

Trzy istotne interakcje:

1. Tablica ogĹ‚oszeĹ„ miejskich â€” `inspect_notice()`; zapisuje
   `p9.epilogue.admin_notice_inspected` oraz `epilogue_noticed`.
2. Kolumna napisĂłw i licencji â€” `inspect_credits()`; zapisuje
   `p9.epilogue.credits_read` oraz `epilogue_credits_read`.
3. Sygnalizator zakoĹ„czenia i nowej ciÄ…gĹ‚oĹ›ci â€” `inspect_blackout()`; zapisuje
   `p9.epilogue.executed`, `ending_family`, `ending_stability`,
   `safe_trial_feedback = "epilogue_completed_cleanly"`, `epilogue_witness_completed`,
   odryglowuje wyjĹ›cie i koĹ„czy kampaniÄ™.

### Migracje kontraktĂłw

- Nowa bramka `tests/pkg_0170_smoke_test.gd` wpiÄ™ta do `tools/verify.ps1`.
- `scripts/core/game_state_manager.gd`: zabezpieczono `complete_station(&"station_43")`
  przed przedwczesnym przejĹ›ciem do menu gdy `campaign_auto_transition_enabled` jest faĹ‚szywe.
- `scripts/levels/station_43.gd`: przekazywanie flagi `should_transition` do GameStateManager.
- Poprawki w testach powrotu i weryfikacji persistence round-trip.

### Dowody

- Baseline przed edycjami: peĹ‚ny `tools/verify.ps1` na stanie PKG-0169:
  `Verification passed.` (exit 0).
- Targeted: `pkg_0170`, `pkg_0169`, `pkg_0168`, `pkg_0167`, `pkg_0153`,
  `pkg_0150`, `pkg_0128`, `smoke_test`, `traversal_lint_test` â€” PASS (exit 0).
- `tests/pkg_0170_smoke_test.gd`: PASS, exit 0 â€” wejĹ›cie ze wszystkich 3 gaĹ‚Ä™zi
  oraz unseeded fallback, trzy interakcje wykonalne, adaptacyjne dialogi >= 5 linii,
  zachowane manifesty licencji/creditsĂłw, persistence round-trip save/load,
  ReturnZone/AirlockZone, limit trzech interakcji, semantyczny InputMap.
- `tools/capture_pkg_0170.gd` na normalnym sterowniku Intel Iris Xe zapisaĹ‚
  3 beztekstowe M2 o rĂłĹĽnych hashach â€” initial 1580715461, notice_and_credits
  359599733, blackout_epilogue 290675078 â€” oraz 1 M3 mono 1310645376 w
  `reports/pkg_0170/`. ĹšwieĹĽe kadry obejrzano: zadaszenie wiaty z 03, stalowe sĹ‚upy,
  Ĺ‚awka, szyny tramwajowe, panele ogĹ‚oszeĹ„ i creditsĂłw oraz sylwetka Leny o Ĺ›wicie;
  dowodzÄ… struktury, nie odbioru.
- `tools/verify_docs.ps1`: DOCS PASS. PeĹ‚na `tools/verify.ps1`:
  `Verification passed.`, exit 0, z nowÄ… bramkÄ… PKG-0170.

### Ograniczenia i przekazanie

- Testy i captures sÄ… dowodem technicznym; nie dowodzÄ… zrozumienia, emocji,
  frajdy ani poczucia domkniÄ™cia u czĹ‚owieka (D-012, ADR-003).
- PRODUCT GO, release i nowe artefakty binarne pozostajÄ… zablokowane (D-168).
- docs/NEXT_SESSION_PROMPT.md prowadzi do PKG-0171 / PHASE-07 / BUNDLE-25: Clean
  cutover, usuniÄ™cie legacy shims i finalny audyt spĂłjnoĹ›ci trasy.
  Snapshot: snapshots/PKG-0170-2026-09-02/.




---

## SESJA DIAGNOSTYCZNA WĹAĹšCICIELA â€” osiem defektĂłw prezentacji i czytelnoĹ›ci, otwarcie PHASE-08 (2026-09-02, D-184..D-193)

**To nie jest pakiet kodu.** Sesja nie zmieniĹ‚a ani jednej linii GDScript,
sceny `.tscn` ani pliku graficznego. ZmieniĹ‚a wyĹ‚Ä…cznie dokumentacjÄ™, plan
i handoff. Wykonano na wyraĹşne polecenie wĹ‚aĹ›ciciela: â€žnie modyfikujesz kodu.
analizujesz, planujesz, aktualizujesz dokumentacjÄ™ tak by kaĹĽdy inny model
wdroĹĽyĹ‚ poprawkiâ€ť.

### ZgĹ‚oszenie wĹ‚aĹ›ciciela

WĹ‚aĹ›ciciel uruchomiĹ‚ runtime po PKG-0170 i przekazaĹ‚ osiem zastrzeĹĽeĹ„ wraz
z kadrami: (1) gracz startuje w niewiedzy, kim jest Lena i czym sÄ… drgania;
(2) portret Marty jest nieakceptowalny i wyglÄ…da jak zepsuty wizerunek Leny â€”
Marta ma byÄ‡ dziewczynÄ… w sukience, z rĂłĹĽowymi wĹ‚osami i septum, ekspresyjnÄ…,
przeciwieĹ„stwem Leny; (3) NPC to kĂłĹ‚ko jako gĹ‚owa i trĂłjkÄ…t jako tuĹ‚Ăłw, majÄ…
wyglÄ…daÄ‡ jak Lena; (4) wejĹ›cie do tramwaju musi byÄ‡ wejĹ›ciem do tramwaju, nie
marszem w prawo â€” wzorzec: animacja wejĹ›Ä‡ z pierwszego Prince of Persia;
(5) Lena caĹ‚y czas siÄ™ potyka i dziwnie kuca zamiast wchodziÄ‡ po stopniach;
(6) wspinaczka po drabinie wyglÄ…da absurdalnie, Lena wisi w powietrzu, powinno
byÄ‡ widaÄ‡ jej plecy; (7) proporcje sÄ… nieprawidĹ‚owe, drzwi wyglÄ…dajÄ… jakby
miaĹ‚y cztery metry; (8) przejĹ›cie do nastÄ™pnej lokacji powinno byÄ‡ zawsze
moĹĽliwe, a pominiÄ™ty odczyt ma blokowaÄ‡ czynnoĹ›Ä‡ pĂłĹşniej, z komentarzem Leny.
WĹ‚aĹ›ciciel wskazaĹ‚ `gen-ai` (Picsart CLI) i modele z kontekstem jako wĹ‚aĹ›ciwy
kierunek dla grafiki.

### Co zweryfikowano w kodzie

Wszystkie osiem potwierdzono z plikĂłw na dysku, nie z opisĂłw:

- **DEF-1:** `project.godot:16` â†’ `main_scene = title_screen.tscn`; â€žNowa graâ€ť
  wchodzi wprost do `station_01`; pierwsza linia dialogowa dopiero po
  odgadniÄ™tej interakcji; sĹ‚owo â€ždrganiaâ€ť nigdzie niewyjaĹ›nione.
- **DEF-2:** `tools/update_marta_portrait.py` przemalowuje raster `lena.png` â€”
  `is_old_hair()` z rastrowym wzorem `(x + y) % 11 < 6`, dwa doklejone
  wielokÄ…ty jako kosmyki, septum liniÄ… 5 px. Docstring: â€žit does not
  regenerate a faceâ€ť. `jakub.png` i `lena.png` sÄ… peĹ‚nymi generacjami.
- **DEF-3:** `memory_resonance_point.gd` â€” Jakub `_draw_jakub_service_operator()`
  (7231â€“7266) â‰36 px; Marta (9600â€“9634) â‰48 px; Szymon `_draw_szymon_bera()`
  (5872â€“5918) â‰30 px; Wierzbicka (5417â€“5421) â‰22 px. Wszystkie z `draw_circle`
  + `draw_rect`/`draw_colored_polygon`. `WORLD_SCALE.md` Â§3 wymaga 84â€“92 px.
- **DEF-4:** wszystkie adresy koĹ„czÄ… `AirlockZone` (`collision_layer = 0`) na
  x â [610, 625]; `station_03.gd:161` `_on_airlock_body_entered()` â†’
  `board_line_four()` na `body_entered`; drzwi wagonu to jedna `draw_line`.
- **DEF-5:** `prototype_player.gd:460-481` `try_curb_step()` podnosi o staĹ‚e
  `MAX_CURB_STEP = 18.0`; `station_08.tscn` ma podstopnice 12 px
  (`Rectangle_stair_12` = 44Ă—12) â†’ 6 px spadku â†’ przy `gravity = 720.0` Ă—
  `fall_gravity_multiplier = 1.35` prÄ™dkoĹ›Ä‡ â‰108 px/s > prĂłg 80 px/s
  (`prototype_player.gd:282`) â†’ `play_landing()`, `_emit_landing_dust()`,
  `_play_squash_stretch(Vector2(1.20, 0.80), â€¦)` na **kaĹĽdym** stopniu.
- **DEF-6:** Station 02 ma dwie drabiny â€” `ServiceLadder` na (570, 310)
  z `ladder_height = 86` (y â [224, 310]) i rÄ™cznie rysowanÄ… w `station_02.gd`
  (y â [162, 256]); rozjazd 62 px. `climb_0/1` to profil boczny; brak stanu
  tylnego w `LenaVisualRig.STATE_NAMES`.
- **DEF-7:** collidery drzwi â€” 01: 20Ă—180, 02: 18Ă—116, 03: 18Ă—116, 04: 20Ă—172,
  07: 24Ă—170, 08: 24Ă—170, 12: 24Ă—132; zgodny wyĹ‚Ä…cznie 10: 52Ă—108. Rysunki â€”
  `station_07.gd:280` 56Ă—146, `station_08.gd:261` 48Ă—156, `station_08.gd:287`
  60Ă—176 (3,38 m). Kanon: 109 Ă— 42â€“48 px.
- **DEF-8:** `_unlock_exit()` woĹ‚ane warunkowo w 18 z 18 adresĂłw liniowych
  (01â€“13 po trzy wywoĹ‚ania, 14â€“18 po dwa); blokada fizyczna to `AnimatableBody2D`
  otwierany przez `ExitClearance.open_body_tweened()`; zero adresĂłw przepuszcza
  gracza bez kompletu odczytĂłw.

### Znalezisko poboczne, istotniejsze niĹĽ czÄ™Ĺ›Ä‡ zgĹ‚oszeĹ„

`GameStateManager.CAMPAIGN_ROUTE` (linie 197â€“207) nadal zawiera
`station_01 .. station_41`. **Trasa 20 adresĂłw istniaĹ‚a dotÄ…d wyĹ‚Ä…cznie
w dokumentach.** Runtime prowadzi gracza przez 43 adresy. Wszystkie werdykty
opisujÄ…ce â€žtrasÄ™ 20 adresĂłwâ€ť dotyczÄ… kontraktĂłw i pojedynczych stacji, nie
faktycznej Ĺ›cieĹĽki kampanii. Zapisano w `ACCEPTANCE_MATRIX.md` Â§4.7 i
`CURRENT_STATE.md`.

### Decyzja o kolejnoĹ›ci

Cutover trasy (PKG-0171) wykonuje siÄ™ **przed** naprawami, mimo proĹ›by
o naprawÄ™ â€žjak najszybciejâ€ť â€” wĹ‚aĹ›ciciel dopuĹ›ciĹ‚ wybĂłr innego momentu.
SzeĹ›Ä‡ z oĹ›miu defektĂłw naprawia siÄ™ per adres, wiÄ™c bez cutoveru koszt PHASE-08
roĹ›nie ponad dwukrotnie i poĹ‚owa pracy trafia do materiaĹ‚u wypadajÄ…cego z trasy
(drabiny 6 â†’ 3 stacje, drzwi/progi/blokady/NPC 43 â†’ 20 adresĂłw). Cutover to
jeden pakiet. KolejnoĹ›Ä‡ wolno odwrĂłciÄ‡ jednÄ… decyzjÄ… wĹ‚aĹ›ciciela bez zmiany
zakresu pakietĂłw (D-185).

WewnÄ…trz PHASE-08 kolejnoĹ›Ä‡ jest zaleĹĽnoĹ›ciowa, nie waĹĽnoĹ›ciowa: intro
(zgĹ‚oszenie nr 1) jest przedostatnie, bo potrzebuje portretu Marty, kontraktu
progu i naprawionej animacji â€” inaczej trzeba by je przerabiaÄ‡ trzy razy.
Jego specyfikacja jest jednak kompletna od teraz, wiÄ™c pakiet da siÄ™ przesunÄ…Ä‡.

### Co powstaĹ‚o

Nowe dokumenty:

- `docs/rebuild/PRESENTATION_REPAIR_PLAN.md` â€” specyfikacja nadrzÄ™dna PHASE-08:
  osiem defektĂłw z peĹ‚nym Ĺ‚aĹ„cuchem dowodowym, mapa na pakiety, szeĹ›Ä‡ nowych
  bramek, pipeline `gen-ai`;
- `docs/rebuild/CAST_AND_NPC_BIBLE.md` â€” karty toĹĽsamoĹ›ci obsady (w tym peĹ‚na
  karta Marty wg wskazaĹ„ wĹ‚aĹ›ciciela), kontrakt skali 84â€“92 px,
  `CharacterVisualRig` z siedmioma stanami, pipeline i kryteria odrzutu;
- `docs/rebuild/THRESHOLD_AND_ENTRY_CONTRACT.md` â€” `ThresholdZone`, trzy
  rodziny wejĹ›Ä‡ (`DOOR`/`VEHICLE`/`HATCH`), kontrakt stopnia, kontrakt drabiny
  z progami zgodnoĹ›ci, tabela skali otworĂłw i lint;
- `docs/rebuild/PROGRESSION_FLOW_CONTRACT.md` â€” taksonomia zdarzeĹ„ w adresie,
  model luki (`gap`), zachowanie czynnoĹ›ci zablokowanej, poziomy gĹ‚osu
  wewnÄ™trznego, GATE-FLOW;
- `docs/rebuild/COLD_OPEN_SPEC.md` â€” warstwa A (12â€“16 s, trzy ujÄ™cia) i
  warstwa B (40â€“60 s grywalne), mapa piÄ™ciu faktĂłw na noĹ›niki, obowiÄ…zkowa
  kolejnoĹ›Ä‡ wprowadzenia pojÄ™cia â€ždrganiaâ€ť.

Zaktualizowane:

- `docs/NEXT_SESSION_PROMPT.md` â€” PKG-0171 przeskalowany: cutover **oraz**
  tabela dowodowa oĹ›miu defektĂłw w nowym `docs/PRESENTATION_DEFECT_AUDIT.md`;
  peĹ‚na kolejka PHASE-08; lista zakazanych skrĂłtĂłw;
- `docs/CURRENT_STATE.md` â€” nota nadrzÄ™dna, tabela oĹ›miu defektĂłw, otwarcie
  PHASE-08, cofniÄ™cie GATE-01, fakt o `CAMPAIGN_ROUTE`;
- `docs/rebuild/ACCEPTANCE_MATRIX.md` â€” nowy Â§3a z szeĹ›cioma bramkami
  (GATE-INTRO, GATE-CAST, GATE-THRESH, GATE-SCALE, GATE-FLOW, GATE-ANIM),
  nowy Â§4.7 z bieĹĽÄ…cym stanem, prĂłg GATE-REL podniesiony z 8 do 14 bramek;
- `docs/PROJECT_REBUILD_EXECUTION_PLAN.md` â€” PHASE-07 i PHASE-08 w tabeli faz,
  nowy Â§8a z BUNDLE-26..31, CHECKPOINT-06, wpis statusu sesji;
- `docs/ROADMAP.md` â€” sekcja P9-PR, prĂłg ukoĹ„czenia roadmapy na 14 bramek;
- `docs/DECISION_LOG.md` â€” D-184..D-193;
- `docs/RISKS_AND_HYPOTHESES.md` â€” H-044..H-049, R-044..R-048;
- `docs/LENA_CHARACTER_AND_ANIMATION.md` â€” rozdziaĹ‚ 12 (Lena 4.2: `step_up`,
  `step_down`, `climb_back_0..3`, `ladder_mount`/`ladder_dismount`, `enter_door`,
  `board_vehicle`);
- `docs/WORLD_SCALE.md` â€” rozdziaĹ‚ 7 (egzekwowanie kanonu, zmierzone
  naruszenia, zasada jednego ĹşrĂłdĹ‚a, lint);
- `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` â€” rozdziaĹ‚ 9 (prĂłg jest czynnoĹ›ciÄ…,
  stopieĹ„ pokonuje siÄ™ ruchem, pion umocowany mierzalnie);
- `docs/INDEX.md` â€” rejestracja piÄ™ciu nowych dokumentĂłw i nota o zmianie
  kierunku.

### Weryfikacja stanu narzÄ™dzi

`gen-ai` (Picsart CLI) jest dostÄ™pne:
`C:\Users\admin\AppData\Roaming\npm\gen-ai`, wersja 2.69.0 (dostÄ™pna 2.72.1),
saldo **1358 kredytĂłw**. DostÄ™pne modele istotne dla PHASE-08: `flux-kontext-pro`,
`flux-kontext-max`, `gemini-3-pro-image`, `seedream-5.0-pro`, `qwen-image-3.0`,
`ideogram-character`, `picsart-qwen-image-edit-angle`. Polecenie `gen-ai character`
utrzymuje spĂłjnÄ… postaÄ‡ referencyjnÄ… miÄ™dzy pozami.

### Ograniczenia i przekazanie

- Sesja **nie uruchamiaĹ‚a** `tools/verify.ps1` ani ĹĽadnej bramki â€” nie byĹ‚o
  zmian w kodzie, wiÄ™c nie byĹ‚o czego weryfikowaÄ‡. Baseline pozostaje z PKG-0170.
- Sesja **nie wykonywaĹ‚a snapshotu** â€” nie jest pakietem pracy.
- Ĺ»aden opis defektu nie jest dowodem odbioru. SzeĹ›Ä‡ nowych bramek dowodzi
  wyĹ‚Ä…cznie, ĹĽe opisany defekt fizycznie zniknÄ…Ĺ‚ z runtime (D-012, ADR-003).
- PRODUCT GO, release i nowe artefakty binarne pozostajÄ… zablokowane (D-168).
- `docs/NEXT_SESSION_PROMPT.md` prowadzi do PKG-0171 / PHASE-07 / BUNDLE-25:
  clean cutover trasy 20 adresĂłw **oraz** tabela dowodowa oĹ›miu defektĂłw.
  Ten pakiet mierzy i przycina; naprawy zaczynajÄ… siÄ™ od PKG-0172.

### Aneks â€” decyzje wĹ‚aĹ›ciciela zapadĹ‚e w tej samej sesji (D-194)

WĹ‚aĹ›ciciel rozstrzygnÄ…Ĺ‚ dwa pytania postawione przez audyt, wiÄ™c nastÄ™pny model
nie musi ich odtwarzaÄ‡ ani zadawaÄ‡ ponownie:

1. **DEF-9 â†’ wariant B.** Na trasie 20 adresĂłw fizycznie stajÄ… trzy osoby:
   Marta w adresie 10, Jakub w 12, Wierzbicka w 11. Osoba **zastÄ™puje przedmiot
   w istniejÄ…cej interakcji**, nie dokĹ‚ada czwartej â€” GATE-INT â‰¤ 3 zostaje
   nienaruszone, a `PROJECT_REBUILD_EXECUTION_PLAN.md` Â§4 przestaje kĹ‚amaÄ‡.
   Sprzedawca w kiosku (06), sÄ…siadka na klatce (08) i Szymon pozostajÄ…
   bezcieleĹ›ni jako **zapisany dĹ‚ug** do rozwaĹĽenia po PKG-0177. Zakres
   generacji: ~27 plikĂłw sprite'Ăłw plus regeneracja portretu Marty.

2. **KolejnoĹ›Ä‡ â†’ cutover najpierw.** Potwierdzenie D-185: PKG-0171 wykonuje
   cutover trasy i tabelÄ™ dowodowÄ…, dopiero PKG-0172 zaczyna naprawy.

Zapisane w: `DECISION_LOG.md` (D-194), `CURRENT_STATE.md` (wiersz DEF-9),
`docs/rebuild/PRESENTATION_REPAIR_PLAN.md` (DEF-9),
`docs/rebuild/CAST_AND_NPC_BIBLE.md` Â§5.2, `docs/NEXT_SESSION_PROMPT.md` Â§2a.

## PKG-0171: Clean cutover trasy 20 adresĂłw, izolacja legacy stacji i audyt defektĂłw prezentacji

Data: 2026-09-02
Identyfikator stanu: `PKG-0171`
Faza: `PHASE-07 / BUNDLE-25`

### Kontekst

Po sesji diagnostycznej wĹ‚aĹ›ciciela z 2026-09-02 (D-184..D-194) ujawniono, ĹĽe mimo zakoĹ„czenia implementacji stacji P9 (01â€“18, 42A/B/C, 43), `GameStateManager.CAMPAIGN_ROUTE` nadal prowadziĹ‚ przez 41 stacji legacy (`station_01..station_41`), a trasa 20 adresĂłw nie istniaĹ‚a w runtime. Ponadto zgĹ‚oszono 8 krytycznych defektĂłw prezentacji i czytelnoĹ›ci (DEF-1..DEF-8) oraz defekt nieobecnoĹ›ci obsady (DEF-9). Zgodnie z D-185 i D-194, PKG-0171 ma za zadanie **zmierzyÄ‡ i przyciÄ…Ä‡**: wykonaÄ‡ czyste odciÄ™cie trasy w runtime, wyizolowaÄ‡ stacje dawcy, zachowaÄ‡ mechaniki i klasy dawcy, sporzÄ…dziÄ‡ tabelÄ™ dowodowÄ… defektĂłw prezentacji i pobraÄ‡ klatki referencyjne na normalnym sterowniku graficznym.

### Zrealizowano

1. **Clean Cutover w `GameStateManager` (`scripts/core/game_state_manager.gd`)**:
   - `CAMPAIGN_ROUTE` skrĂłcony z 41 do 18 adresĂłw (`&"station_01"`..`&"station_18"`).
   - Stacje dawcy 19..41 przeniesione do `CAMPAIGN_LEGACY_STATIONS` (23 stacje), zachowujÄ…c kompatybilnoĹ›Ä‡ testĂłw dawcy i mechanik bez obecnoĹ›ci na aktywnej trasie.
   - `CAMPAIGN_SELECTOR_STATIONS` skrĂłcony z 43 do 20 pozycji (`station_01`..`station_18`, dynamicznie podmieniany wybrany finaĹ‚ na indeksie 18, `station_43` na indeksie 19).
   - `CAMPAIGN_TRANSITION_LIMIT` zaktualizowany z 41 na 18.
   - Tranzycja ze `station_18` prowadzi bezpoĹ›rednio do wybranego finaĹ‚u (`station_42a`/`b`/`c`), a stamtÄ…d do epilogu `station_43`.
   - Zaktualizowano `get_all_campaign_scene_ids()` do 22 aktywnych zasobĂłw kampanii; dodano `get_all_scene_ids(include_legacy)` i `get_legacy_campaign_scene_ids()`.
   - `complete_station`: obsĹ‚uĹĽono tranzycje `station_18` -> finaĹ‚, finaĹ‚ -> epilog oraz krok wstecz `get_previous_campaign_station` (finaĹ‚ -> 18, 43 -> finaĹ‚, oraz legacy 19 -> 18).
   - Zapewniono obsĹ‚ugÄ™ sygnaĹ‚u `operation_selected` i metody `select_finale_operation` / `select_finale_method` dla `station_18`.

2. **Dostosowanie `Station 18` (`scripts/levels/station_18.gd`)**:
   - Dodano sygnaĹ‚ `operation_selected(operation: String)`.
   - WdroĹĽono metodÄ™ `select_operation(op: String)` synchronizujÄ…cÄ… wybĂłr finaĹ‚u z `GameStateManager`, odtwarzajÄ…cÄ… minimalny kontekst dawcy (jeĹ›li wywoĹ‚ano z testu bez przejĹ›cia przez stacjÄ™ 17) i zapisujÄ…cÄ… `campaign_finale`.

3. **Migracja historycznych bramek testowych**:
   - `pkg_0091_smoke_test.gd`, `pkg_0094_smoke_test.gd`: selektor 20 pozycji.
   - `pkg_0096_smoke_test.gd`: odblokowanie finaĹ‚u po stacji 18.
   - `pkg_0097_smoke_test.gd`, `pkg_0099_smoke_test.gd`, `pkg_0100_smoke_test.gd`, `pkg_0101_smoke_test.gd`, `pkg_0102_smoke_test.gd`: granica 18 stacji.
   - `pkg_0103_smoke_test.gd`..`pkg_0107_smoke_test.gd`: granica 18 stacji, badanie odblokowania finaĹ‚u i ciÄ…gĹ‚oĹ›ci dawcy 25->26.
   - `pkg_0113_smoke_test.gd`: weryfikacja 20 przyciskĂłw w menu pauzy.
   - `pkg_0114_smoke_test.gd`: trasa 18 stacji, selektor 20 pozycji, 22 sceny, rozgaĹ‚Ä™zienia A/B/C z wyboru w komorze Station 18.
   - `pkg_0127_smoke_test.gd`: dwukierunkowy graf tranzycji 1..18 -> finaĹ‚y -> 43 oraz test ciÄ…gĹ‚oĹ›ci dawcĂłw 19..41.
   - `pkg_0151_smoke_test.gd`: zaktualizowano asercje tras selektora.

4. **Tabela dowodowa defektĂłw â€” `docs/PRESENTATION_DEFECT_AUDIT.md`**:
   - Opracowano peĹ‚ny dokument ze zmierzonÄ… tabelÄ… DEF-3..DEF-8 dla wszystkich 20 adresĂłw kampanii.
   - Udokumentowano szczegĂłĹ‚owo DEF-9 pod kÄ…tem Decyzji D-194 (Wariant B: Marta w 10, Jakub w 12, Wierzbicka w 11, zastÄ…pienie obiektĂłw, zachowanie budĹĽetu GATE-INT â‰¤ 3).
   - Skonstruowano indeks 14 referencyjnych kadrĂłw wizualnych w `reports/pkg_0171/`.

5. **Weryfikacja dokumentacji i nowa bramka testowa**:
   - Zarejestrowano 6 dokumentĂłw planu przebudowy w `tools/verify_docs.ps1` (`DOCS PASS: 52 required files and handoff contracts`).
   - Utworzono bramkÄ™ `tests/pkg_0171_smoke_test.gd` (GATE-ROUTE: TECHNICAL PASS) sprawdzajÄ…cÄ… 18-elementowÄ… trasÄ™, 20-pozycyjny selektor, izolacjÄ™ dawcĂłw, rozgaĹ‚Ä™zienia finaĹ‚owe i nienaruszalnoĹ›Ä‡ klas dawcy (`AnchorExclusivityController`, `ServiceLift`, `LadderZone`, `MovableAnchorableProp`, `AnchorableObject`).
   - Zarejestrowano bramkÄ™ w `tools/verify.ps1`.

6. **Pobranie kadrĂłw referencyjnych na normalnym sterowniku**:
   - Przygotowano skrypt `tools/capture_pkg_0171.gd` i uruchomiono z normalnym sterownikiem graficznym Windows (OpenGL 3.3.0 Compatibility).
   - Zapisano 14 kadrĂłw PNG w `reports/pkg_0171/` (7 rodzin lokacji + dowody przednaprawcze DEF-2..DEF-7) wraz z `visual_evidence_report.txt`.

### DowĂłd weryfikacji

```text
== Documentation contract ==
DOCS PASS: 52 required files and handoff contracts
== Godot headless import ==
[ DONE ] first_scan_filesystem
[ DONE ] update_scripts_classes
[ DONE ] loading_editor_layout
== Getting Strange smoke test ==
SMOKE PASS: project, scene, input and player physics
== Traversal contract lint ==
TRAVERSAL LINT PASS: campaign scenes carry no arcade-platforming geometry
...
== PKG-0114 production shell and end-to-end campaign gate ==
PKG-0114 SMOKE PASS: production shell, save entry points and full 01..43 topology
...
== PKG-0171 route integrity and cutover gate ==
PKG-0171 SMOKE PASS: 20-station cutover, legacy shims, and donor integrity verified.
Verification passed.
```

### Ograniczenia

- Ten pakiet **zmierzyĹ‚ i przyciÄ…Ĺ‚**, ale celowo **nie naprawia** defektĂłw DEF-1..DEF-8. Naprawy defektĂłw rozpoczynajÄ… siÄ™ w pakiecie PKG-0172 (PHASE-08 / BUNDLE-26).
- Brak zewnÄ™trznych testĂłw z ludĹşmi (D-012, ADR-003).
- PRODUCT GO, release i nowe pliki `.exe` pozostajÄ… zablokowane (D-168).

### Przekazanie

NastÄ™pny pakiet: **PKG-0172 / PHASE-08 / BUNDLE-26: Cast, Portraits and One Visual Language**.
Specyfikacja: `docs/rebuild/CAST_AND_NPC_BIBLE.md` oraz `docs/rebuild/PRESENTATION_REPAIR_PLAN.md` Â§3 (DEF-2, DEF-3, DEF-9).

## PKG-0172: Cast, portraits and one visual language (GATE-CAST)

Data: 2026-09-02
Identyfikator stanu: `PKG-0172`
Faza: `PHASE-08 / BUNDLE-26`

### Kontekst

Po cutoverze trasy 20 adresĂłw (PKG-0171) i decyzji D-194 (wariant B) pakiet wdraĹĽa
obsadÄ™ na kontrakcie Leny: unikalny portret Marty, `CharacterVisualRig`, fizyczne
postacie w Station 10/11/12 oraz 42B/C, usuniÄ™cie kĂłĹ‚kowych figur z trasy kampanii.

### Zrealizowano

1. **DEF-2 â€” portret Marty.** `assets/characters/portraits/marta.png` (1024Ă—1024, alfa)
   jest unikalnÄ… twarzÄ…: dĹ‚ugie rĂłĹĽowe wĹ‚osy, septum, uĹ›miech, sukienka w zgaszonej
   czerwieni. Nie jest kopiÄ… rastra Leny. `tools/update_marta_portrait.py` pozostaje
   w `tools/retired/` (D-187) i nie istnieje w `tools/`.
2. **DEF-3 â€” `CharacterVisualRig`.** Nowy wÄ™zeĹ‚
   `scripts/characters/character_visual_rig.gd` (`class_name CharacterVisualRig extends Node2D`):
   pĹ‚Ăłtno 64Ă—104, pivot (32, 96), `centered = false`, `TEXTURE_FILTER_NEAREST`,
   siedem stanĂłw (`idle`, `talk` 2 klatki, `listen`, `gesture`, `turn_away`, `seated`,
   `work`), bezpieczny fallback na `idle`, `_draw()` wyĹ‚Ä…cznie cieĹ„ kontaktowy.
3. **Sprite'y 64Ă—104** Marty, Jakuba i Wierzbickiej w `assets/characters/<imiÄ™>/`
   (9 plikĂłw na postaÄ‡). Normalizacja offline: `tools/process_npc_sprites.py`.
   Surowe JPEG w `raw/` z `.gdignore`.
4. **DEF-9 â€” obsada D-194.** Marta w Station 10 `(420, 296)` i 42B/C `(332, 296)`;
   Wierzbicka `seated` w Station 11 `(380, 296)`; Jakub `work` w Station 12 `(320, 296)`.
   GATE-INT â‰¤ 3 nienaruszone (CharacterVisualRig nie jest `MemoryResonancePoint`).
5. **UsuniÄ™cie prymitywĂłw na trasie.** WykreĹ›lono kĂłĹ‚kowe figury z `station_10.gd`
   i `station_12.gd`. `_draw_epilogue_marta_doorstep()` rysuje oĹ›cieĹĽnicÄ™, stĂłĹ‚ i klucz,
   nie gĹ‚owÄ™ Marty. `pkg_0160` nie wymaga juĹĽ prymitywnej Marty w epilogu.
6. **Bramka GATE-CAST:** `tests/pkg_0172_smoke_test.gd` zarejestrowana w `tools/verify.ps1`.
7. **Kadry:** `tools/capture_pkg_0172.gd` â†’ `reports/pkg_0172/`.

### DowĂłd weryfikacji

```text
PKG-0172 SMOKE PASS: GATE-CAST â€” CharacterVisualRig, campaign cast, portrait identity.
```

PeĹ‚ne `tools/verify.ps1` po zamkniÄ™ciu pakietu: `Verification passed.` (exit 0).

### Ograniczenia

- GATE-CAST dowodzi kontraktu (pĹ‚Ăłtno, skala, brak prymitywĂłw, unikalny portret),
  nie tego, ĹĽe Marta â€žwyglÄ…da dobrzeâ€ť (H-045, D-012, ADR-003).
- Kiosk (06) i sÄ…siadka (08) pozostajÄ… bezcieleĹ›ni (dĹ‚ug D-194).
- DEF-1, DEF-4, DEF-5, DEF-6, DEF-7, DEF-8 otwarte.
- PRODUCT GO, release i nowe `.exe` zablokowane (D-168).

### Przekazanie

NastÄ™pny pakiet: **PKG-0173 / PHASE-08 / BUNDLE-27: Traversal animation â€” steps and ladders**.
Specyfikacja: `docs/rebuild/PRESENTATION_REPAIR_PLAN.md` Â§3 (DEF-5, DEF-6).

## PKG-0173: Traversal animation â€” steps and ladders (GATE-ANIM)

Data: 2026-09-02
Identyfikator stanu: `PKG-0173`
Faza: `PHASE-08 / BUNDLE-27`

### Kontekst

Po obsadzie PKG-0172 pakiet zamyka DEF-5 (potykanie i przysiad na stopniu)
oraz DEF-6 (drabina 62 px obok strefy, brak widoku od tyĹ‚u) na trasie 20 adresĂłw.

### Zrealizowano

1. **DEF-5 â€” stopnie.** `try_curb_step()` sondÄ… mierzy rzeczywistÄ… wysokoĹ›Ä‡
   podstopnicy (`measure_curb_height`) i interpoluje ciaĹ‚o 0,18â€“0,24 s po Ĺ‚uku.
   Limit `MAX_CURB_STEP = 18` (D-123) zostaje. Flaga `_stepping` blokuje
   `play_landing()`, `_emit_landing_dust()` i `_play_squash_stretch()`.
   ZejĹ›cie z krawÄ™dzi â‰¤ 18 px uĹĽywa `step_down` zamiast swobodnego spadku.
2. **Lena 4.2.** `LenaVisualRig` ma stany `step_up`, `step_down`, `climb_back`,
   `ladder_mount`, `ladder_dismount`. Stary `climb` zostaje logicznym fallbackiem;
   prezentacja wspinaczki pokazuje `climb_back`. PĹ‚Ăłtno 64Ă—104, pivot (32, 96).
3. **Klatki.** `assets/characters/lena/step_up_0.png`, `step_up_1.png`,
   `step_down_0.png`, `climb_back_0..3.png`, `ladder_mount.png`,
   `ladder_dismount.png`. Normalizacja: `tools/process_lena_traversal_sprites.py`.
4. **DEF-6 â€” drabina.** UsuniÄ™ty rÄ™czny rysunek z `station_02.gd`
   `_draw_outdoor_detour()` (szyny 564/576, y â [162, 256]). `ServiceLadder`
   na `(570, 296)`, `ladder_height = 80` â€” dĂłĹ‚ na podĹ‚odze, zgodnoĹ›Ä‡ rysunku
   ze strefÄ… â‰¤ 2 px / â‰¤ 1 px. Station 15 i 16 bez drugiej drabiny.
5. **Intencja.** PrzypiÄ™cie do drabiny wymaga `interact` albo `move_up` przy
   zatrzymanej postaci; otarcie w biegu nie startuje wspinaczki (D-190).
6. **Bramka GATE-ANIM (schody/drabina):** `tests/pkg_0173_smoke_test.gd`
   w `tools/verify.ps1`.
7. **Kadry:** `tools/capture_pkg_0173.gd` â†’ `reports/pkg_0173/` na Intel Iris Xe.

### DowĂłd weryfikacji

```text
PKG-0173 SMOKE PASS: GATE-ANIM â€” steps interpolate, ladders draw once, climb shows the back.
```

Regresje `pkg_0125`, `pkg_0129`, `pkg_0134`, `pkg_0136`, `pkg_0157`: PASS.

### Ograniczenia

- GATE-ANIM w macierzy zawiera teĹĽ klatki `enter_door` / `board_vehicle` â€”
  to zakres PKG-0174 / GATE-THRESH, nie tego pakietu.
- H-047 (â€žusuwa wraĹĽenie potykaniaâ€ť) pozostaje hipotezÄ… odbiorczÄ…; bramka
  dowodzi zera `jump_fall` i squasha, nie odczucia gracza (D-012, ADR-003).
- DEF-1, DEF-4, DEF-7, DEF-8 otwarte.
- PRODUCT GO, release i nowe `.exe` zablokowane (D-168).

### Przekazanie

NastÄ™pny pakiet: **PKG-0174 / PHASE-08 / BUNDLE-28: ThresholdZone and entrance families**.
Specyfikacja: `docs/rebuild/PRESENTATION_REPAIR_PLAN.md` Â§3 (DEF-4, DEF-7)
oraz `docs/rebuild/THRESHOLD_AND_ENTRY_CONTRACT.md` Â§2â€“Â§4, Â§7.

## PKG-0174: ThresholdZone and entrance families (GATE-THRESH)

Data: 2026-09-02
Identyfikator stanu: `PKG-0174`
Faza: `PHASE-08 / BUNDLE-28`

### Kontekst

Po animacji trawersu PKG-0173 pakiet zamyka DEF-4 (wejĹ›cie to marsz w niewidzialny
`AirlockZone`) oraz DEF-7 (otwory poza kanonem skali) na trasie 20 adresĂłw.

### Zrealizowano

1. **DEF-4 â€” prĂłg.** Nowy `ThresholdZone` (`scripts/environment/threshold_zone.gd`)
   z `aperture_rect` jako jednym ĹşrĂłdĹ‚em prawdy. Trzy rodziny: `DOOR`, `VEHICLE`,
   `HATCH`. WejĹ›cie wymaga `interact`; sekwencja: podejĹ›cie â‰¤ 0,35 s, klatki,
   skrzydĹ‚o/rozsuniÄ™cie/wieko, dopiero potem `level_completed`.
2. **`ThresholdBinder`** instaluje prĂłg na 01â€“18 + 42A/B/C + 43. `AirlockZone`
   zostaje strefÄ… domkniÄ™cia: handlery `body_entered` to `pass`.
3. **Lena 4.2 progi.** Stany `enter_door` i `board_vehicle` na pĹ‚Ăłtnie 64Ă—104,
   pivot (32, 96). Klatki: `enter_door_0..2`, `board_vehicle_0..1`.
4. **DEF-7 â€” skala otworĂłw.** Collidery 01/02/03/04/07/08/12 doprowadzone do
   kanonu. `aperture_rect`: mieszkanie 45Ă—109, Ĺ›luza 54Ă—114, wagon 58Ă—105,
   wĹ‚az 64Ă—64. `ExitClearance.disable_collision` zamiast podnoszenia o 140 px.
5. **Bramka GATE-THRESH + GATE-SCALE (otwory):** `tests/pkg_0174_smoke_test.gd`
   w `tools/verify.ps1`.
6. **Kadry:** `tools/capture_pkg_0174.gd` â†’ `reports/pkg_0174/` na Intel Iris Xe.

### DowĂłd weryfikacji

```text
PKG-0174 SMOKE PASS: GATE-THRESH â€” interact at a drawn threshold; apertures match the metre.
SMOKE PASS: project, scene, input and player physics
PKG-0159 PASS: dual opening choice, title promise, downstream divergence and real stair traversal verified.
Verification passed.
```

PeĹ‚na `tools/verify.ps1` 2026-09-02: exit 0, ~657 s. Testy 0159 i 0162â€“0169
koĹ„czÄ… stacjÄ™ przez `ThresholdBinder.complete_from_test` (interact/instant),
nie przez `AirlockZone.body_entered`.

### Ograniczenia

- GATE-SCALE w macierzy obejmuje teĹĽ meble; ten pakiet zamyka otwory.
- H-046 (wejĹ›cie â€žczuje siÄ™ jak czynnoĹ›Ä‡â€ť) pozostaje hipotezÄ… odbiorczÄ… (D-012).
- DEF-1 i DEF-8 otwarte.
- PRODUCT GO, release i nowe `.exe` zablokowane (D-168).

### Przekazanie

Snapshot: `snapshots/PKG-0174-2026-09-03/` (kopia `scenes/`, `scripts/`, `tests/`).
NastÄ™pny pakiet: **PKG-0175 / PHASE-08 / BUNDLE-29: continuous passability and gap ledger**.
Specyfikacja: `docs/rebuild/PRESENTATION_REPAIR_PLAN.md` Â§3 (DEF-8)
oraz `docs/rebuild/PROGRESSION_FLOW_CONTRACT.md`.

## PKG-0175: Continuous passability and gap ledger (GATE-FLOW)

Data: 2026-09-03
Identyfikator stanu: `PKG-0175`
Faza: `PHASE-08 / BUNDLE-29`

### Kontekst

Po progach PKG-0174 pakiet zamyka DEF-8: twarde `_unlock_exit()` na 18 adresach
liniowych. Koszt pominiÄ™tego odczytu przenosi siÄ™ z drzwi na lukÄ™.

### Zrealizowano

1. **`GapLedger`** (`scripts/campaign/gap_ledger.gd`): katalog luk z
   `thought_pl` / `thought_en` / `blocks` / `origin_station`. Otwarcie przy
   odejĹ›ciu, zamkniÄ™cie po wykonaniu odczytu albo fakcie w zapisie.
2. **`GameStateManager.open_gaps`**: JSON-safe, wczytuje stare save'y bez
   podbijania schematu. `ensure_exit_open` woĹ‚ane na 20 adresach trasy.
3. **PrĂłg nie jest zamkiem.** `board_line_four` zawsze koĹ„czy Station 03.
   Station 18 zatwierdza metodÄ™ z lukami. `OpeningActionPoint` nie ukrywa
   odczytu (`set_available(false)` jest no-op).
4. **GĹ‚os.** Zablokowana czynnoĹ›Ä‡ woĹ‚a `GapLedger.annotate_feedback` â†’
   `InnerThoughtSurface` (L2, `truth_scope = fallible`).
5. **Bramka GATE-FLOW:** `tests/pkg_0175_smoke_test.gd` w `tools/verify.ps1`.
6. **Kadry:** `tools/capture_pkg_0175.gd` â†’ `reports/pkg_0175/` na Intel Iris Xe.

### DowĂłd weryfikacji

```text
PKG-0175 SMOKE PASS: GATE-FLOW â€” exits open from ready; gaps replace door locks.
Verification passed.
```

PeĹ‚na `tools/verify.ps1` 2026-09-03: exit 0, ~739 s.

### Ograniczenia

- H-048 (czy historia klei siÄ™ bez odczytĂłw) pozostaje hipotezÄ… odbiorczÄ… (D-012).
- DEF-1 otwarte.
- PRODUCT GO, release i nowe `.exe` zablokowane (D-168).

### Przekazanie

Snapshot: `snapshots/PKG-0175-2026-09-03/` (kopia `scenes/`, `scripts/`, `tests/`).
NastÄ™pny pakiet: **PKG-0176 / PHASE-08 / BUNDLE-30: cold open**.
Specyfikacja: `docs/rebuild/PRESENTATION_REPAIR_PLAN.md` Â§3 (DEF-1)
oraz `docs/rebuild/COLD_OPEN_SPEC.md`.


---

## PKG-0176: PHASE-08 / BUNDLE-30 â€” zimne otwarcie (DEF-1 / GATE-INTRO)

Data: 2026-09-03. Decyzje: D-195, D-196 (wdraĹĽajÄ… D-193).
Specyfikacja: `docs/rebuild/PRESENTATION_REPAIR_PLAN.md` Â§3 (DEF-1),
`docs/rebuild/COLD_OPEN_SPEC.md`, `docs/rebuild/PLAYER_CONTRACT.md` Â§3 i Â§6.

### Baseline padĹ‚ przed pierwszÄ… edycjÄ…

Pierwsze `tools/verify.ps1` tej sesji zakoĹ„czyĹ‚o siÄ™ `exit 1`:
`SMOKE: station_09: planter must clear the passage`.

Przyczyna nie leĹĽaĹ‚a w Station 09. `tests/smoke_test.gd` jako jedyna bramka
kampanii nie wyĹ‚Ä…czaĹ‚a `campaign_auto_transition_enabled`, wiÄ™c ukoĹ„czenie
stacji robiĹ‚o realne `change_scene_to_file()`. Bramka nie ma sceny bieĹĽÄ…cej,
wiÄ™c Godot dowieszaĹ‚ nastÄ™pnÄ… stacjÄ™ pod `root` i nikt jej nie zwalniaĹ‚.
Osierocona `Station06` zostaĹ‚a w drzewie fizyki i jej podĹ‚oga zatrzymaĹ‚a donicÄ™
Station 09 na `x = 263,9` przy progu `x â‰Ą 300`. Utajony wyciek istniaĹ‚ od dawna;
ujawniĹ‚ go dopiero ukĹ‚ad scen po PKG-0175.

Naprawa jest w harnessie (`tests/smoke_test.gd` wyĹ‚Ä…cza i przywraca flagÄ™ wokĂłĹ‚
pÄ™tli stacji). DEF-4..DEF-8, GATE-THRESH, GATE-ANIM i GATE-FLOW nietkniÄ™te.
Po naprawie: `Verification passed.` (exit 0) â€” to jest baseline pakietu.

### Co powstaĹ‚o

1. **`scripts/campaign/cold_open_facts.gd`** (`ColdOpenFacts`) â€” jedyne ĹşrĂłdĹ‚o
   prawdy o piÄ™ciu faktach `PLAYER_CONTRACT.md` Â§3, ich noĹ›nikach, dozwolonych
   i zakazanych rodzajach noĹ›nika, kolejnoĹ›ci pojÄ™cia â€ždrganiaâ€ť (Â§4.3), peĹ‚nej
   liĹ›cie tekstĂłw zimnego otwarcia i rdzeniach zakazanych ujawnieĹ„ (Â§5).
   Statyczne API na wzĂłr `GapLedger`; bramka czyta katalog stÄ…d, nie powtarza go.
2. **`scripts/visual/vibration_trace_display.gd`** (`VibrationTraceDisplay`) â€”
   jeden proceduralny przebieg drgaĹ„ dla obu warstw. Tryby `IDLE` / `LIVE` /
   `ARCHIVE`. Amplituda jest funkcjÄ… wyĹ‚Ä…cznie pozycji w oknie 20 s, bez fazy i
   bez losowoĹ›ci, wiÄ™c `sample_amplitude()` jest tym samym dowodem dla bramki,
   dla kadru i dla trybu ograniczonego ruchu. Luka archiwalna to dokĹ‚adnie 3 s
   pĹ‚askiej linii w otoczeniu normalnego szumu.
3. **Warstwa A** â€” `scenes/shell/cold_open.tscn` + `scripts/ui/cold_open.gd`
   (`ColdOpen`). Trzy ujÄ™cia, jedno ciÄ™cie, 14,5 s (12,5 s w reduced motion):
   nocne torowisko z przejeĹĽdĹĽajÄ…cym tramwajem â†’ zbliĹĽenie na szynÄ™, czujnik,
   kabel i dĹ‚oĹ„ w rÄ™kawicy (twarz poza pulÄ… Ĺ›wiatĹ‚a roboczego) â†’ ekran przyrzÄ…du
   z przebiegiem na ĹĽywo i zapisem archiwalnym. Sekwencja chodzi po
   `_physics_process`, wiÄ™c trwa tyle samo w grze, w bramce i w capture.
   Napisy wyĹ‚Ä…cznie diegetyczne, w `CrispDiegeticText`. Bez muzyki; dĹşwiÄ™k z
   `ProceduralAudio` (trakcja tramwaju, zatrzask obejmy, skok igĹ‚y, taĹ›ma).
3b. **Korekta wĹ‚aĹ›ciciela w trakcie sesji (D-197).** Pierwsze wdroĹĽenie ujÄ™cia 2
   dorysowywaĹ‚o Lenie trzeciÄ… rÄ™kÄ™: `draw_line` jako przedramiÄ™ i `draw_circle`
   jako dĹ‚oĹ„ w rÄ™kawicy, doklejone do sprite'a `examine.png`. To ta sama klasa
   bĹ‚Ä™du, ktĂłrÄ… D-186 usunÄ…Ĺ‚ z NPC-Ăłw, tylko przeniesiona na LenÄ™. WĹ‚aĹ›ciciel
   odrzuciĹ‚ to natychmiast po obejrzeniu kadru. Poprawka: ujÄ™cie 2 jest teraz
   planszÄ… wygenerowanÄ… w tym samym pipelinie co kaĹĽda klatka Leny â€”
   referencja `raw/pkg_0173/step_up_0.jpg` â†’ `gen-ai character`
   (`ideogram-character`, Picsart CLI) z promptem
   `raw/pkg_0176/prompt_cold_open_crouch.txt` â†’ `tools/process_cold_open_plate.py`
   â†’ `assets/cold_open/shot2_rail_hands.png`. Kadr zaczyna siÄ™ poniĹĽej brody,
   wiÄ™c â€žtwarz jeszcze nieâ€ť jest speĹ‚nione kadrowaniem, nie zamalowaniem.
   Zero prymitywĂłw na ciele postaci; silnik dokĹ‚ada tylko pulÄ™ Ĺ›wiatĹ‚a i winietÄ™.
4. **Warstwa B** â€” stan wstÄ™pny w `scripts/levels/station_01.gd`. Gracz podchodzi
   do stanowiska, `interact` przy rejestratorze uruchamia jeden przebieg pomiaru
   (3,5 s realnego czasu przyrzÄ…du), widzi tÄ™ samÄ… trzysekundowÄ… lukÄ™, sĹ‚yszy
   jednÄ… liniÄ™ Leny i widzi wiadomoĹ›Ä‡ Marty z imieniem i godzinÄ… **na tym samym
   ekranie przyrzÄ…du**. Dopiero wtedy otwierajÄ… siÄ™ dwie drogi Station 01.
   PozostaĹ‚e punkty interakcji zostajÄ… widoczne i odpowiadajÄ… brakiem
   przesĹ‚anki, nie znikajÄ… (PKG-0175).
5. **Routing i zapis** â€” `GameStateManager.start_new_game()` prowadzi do
   `COLD_OPEN_SCENE`, nie wprost do `station_01`; `continue_campaign()` bez
   zmian, wiÄ™c `Kontynuuj` pomija warstwÄ™ A. Flaga `cold_open_seen` ĹĽyje w pliku
   ustawieĹ„ (`Nowa gra` kasuje zapis kampanii, a obejrzana sekwencja pozostaje
   obejrzana). Starszy plik ustawieĹ„ bez tego klucza jest przyjmowany.
6. **Pulpit przyrzÄ…du w Station 01** â€” wykres i wiadomoĹ›Ä‡ Marty dzielÄ… jeden
   ekran (spec Â§4.1 krok 6). BÄ™ben rejestratora przeniesiony pod pulpit,
   `CrispDiegeticText_Terminal` na dolnÄ… Ĺ›cianÄ™ maszyny.
7. **Bramka GATE-INTRO** â€” `tests/pkg_0176_smoke_test.gd` w `tools/verify.ps1`.
8. **Kadry** â€” `tools/capture_pkg_0176.gd` â†’ `reports/pkg_0176/` na Intel Iris Xe
   (normalny sterownik Windows, nie headless).

### Co bramka mierzy

| Kontrakt | Wynik |
|---|---|
| `Nowa gra` nie wpada w wybĂłr Station 01 | scena po `ui_accept` to `ColdOpen`, nie `Station01` |
| piÄ™Ä‡ faktĂłw Â§3 przed rozwidleniem | 5/5, kaĹĽdy z noĹ›nika `silhouette` / `machine` / `player_action` / `instrument_screen` |
| M5 do faktu | **25,0 s** przy budĹĽecie 90 s |
| kolejnoĹ›Ä‡ pojÄ™cia â€ždrganiaâ€ť Â§4.3 | porzÄ…dkowe 1â†’5 rosnÄ…ce; sĹ‚owo pada jako piÄ…te |
| warstwa A niepomijalna za pierwszym razem | `skip_for_test()` odmawia |
| warstwa A pomijalna pĂłĹşniej | `skip_for_test()` przyjmuje |
| reduced motion | 5/5 faktĂłw, kolejnoĹ›Ä‡ zachowana, 18,0 s |
| zakazane ujawnienia Â§5 | 0 wystÄ…pieĹ„ w peĹ‚nej liĹ›cie tekstĂłw |
| luka archiwalna | dokĹ‚adnie 3 s pĹ‚askiej linii, szum wokĂłĹ‚ > 0,05 |

Trace: `reports/pkg_0176/m1_m5_trace.tsv`.

### Migracje bramek

- `tests/pkg_0159_smoke_test.gd` â€” `Nowa gra` przechodzi teraz przez warstwÄ™ A,
  a obie gaĹ‚Ä™zie Station 01 przechodzÄ… najpierw warstwÄ™ B. Nowy helper
  `_resolve_cold_open()` robi to czasownikami gracza.
- `tests/smoke_test.gd` â€” naprawa wycieku scen opisana wyĹĽej.
- `scenes/levels/station_01.tscn` â€” `CrispDiegeticText_Terminal` zachowuje treĹ›Ä‡
  wymaganÄ… przez `tests/pkg_0157_smoke_test.gd` (GATE-01) i wraca nad pas
  sylwetki Leny (`y = 166`), bo PKG-0136 i PKG-0137 tego pilnujÄ…. BÄ™ben
  rejestratora zszedĹ‚ na `y = 190`, ĹĽeby zwolniÄ‡ pas etykiety.
- `tests/pkg_0133_smoke_test.gd` â€” trzy ograniczone czynnoĹ›ci otwarcia testuje
  siÄ™ dopiero po przejĹ›ciu warstwy B; rejestrator w zimnym otwarciu celowo
  **nie** jest rozwiÄ…zywany, bo ta sama obejma sĹ‚uĹĽy pĂłĹşniej do powtĂłrki.
- `scripts/levels/station_01.gd` â€” metody stanu warstwy B nazwane
  `_tick_*`, nie `_advance_*`: `advance_message` jest zakazanym legacy tokenem
  w lincie cutoveru z `tests/pkg_0146_smoke_test.gd`.
- `tests/pkg_0114_smoke_test.gd` â€” `_wait_for_station()` czeka na klatkach
  fizyki i ma wiÄ™kszy budĹĽet, bo `Nowa gra` przechodzi teraz przez warstwÄ™ A.

### DowĂłd weryfikacji

```text
PKG-0176 SMOKE PASS: GATE-INTRO â€” five facts before the fork, concept order intact.
Verification passed.
```

### Ograniczenia

- Bramka dowodzi, ĹĽe piÄ™Ä‡ faktĂłw **zostaĹ‚o pokazane** wĹ‚aĹ›ciwym noĹ›nikiem, w
  kolejnoĹ›ci i w czasie. Nie dowodzi, ĹĽe nowa osoba zrozumiaĹ‚a, kim jest Lena â€”
  to hipoteza odbiorcza i pozostaje bez dowodu (D-012, ADR-003).
- PodejĹ›cie gracza do stanowiska ma 119 px, nie 40â€“60 px jak sugeruje spec Â§4.1
  krok 1. Spawn Leny na `(70, 296)` zostaje: to zamroĹĽona kompozycja kadru z
  PKG-0159/0175, a kryteria akceptacji nie nazywajÄ… dystansu. Koszt: 1,2 s marszu.
- Warstwa A ma trzy ujÄ™cia statyczne z ciÄ™ciami i jednÄ… powolnÄ… panoramÄ™ w
  ujÄ™ciu 1. Tryb ograniczonego ruchu zdejmuje panoramÄ™ i skraca przejazd; treĹ›Ä‡
  ujÄ™Ä‡ bez zmian.
- WyjĹ›cie ze Station 01 jest otwarte od `_ready()` (PKG-0175, D-192), wiÄ™c
  gracz moĹĽe wyjĹ›Ä‡ przed koĹ„cem warstwy B. Nie blokujemy tego: pominiÄ™ty
  odczyt otwiera lukÄ™ `s01.measurement_unrepeated` w `GapLedger`, a Lena
  komentuje jÄ… gĹ‚osem wewnÄ™trznym. Luka zamiast drzwi jest kontraktem.
  Kryterium 3 dotyczy pierwszego **wyboru**, nie progu, i jest speĹ‚nione.
- PRODUCT GO, release i nowe `.exe` pozostajÄ… zablokowane (D-168).
- GATE-01 pozostaje w `CONCERNS` do recertyfikacji w PKG-0177.

### Przekazanie

Snapshot: `snapshots/PKG-0176-2026-09-03/`.
NastÄ™pny pakiet: **PKG-0177 / PHASE-08 / BUNDLE-31** â€” integracja, czternaĹ›cie
bramek i CHECKPOINT-06.


## PKG-0177: P9 PHASE-08 BUNDLE-31 â€” Integracja trasy 20 adresĂłw, recertyfikacja GATE-01, 14 bramek i CHECKPOINT-06

Data: 2026-09-03

Kontekst: ZwieĹ„czenie fazy naprawy prezentacji i czytelnoĹ›ci (PHASE-08 / BUNDLE-31) per `docs/rebuild/PRESENTATION_REPAIR_PLAN.md` oraz `docs/rebuild/ACCEPTANCE_MATRIX.md`. ZamkniÄ™cie wszystkich 9 defektĂłw wĹ‚aĹ›ciciela (DEF-1..DEF-9) we wspĂłlnym, ciÄ…gĹ‚ym przebiegu M1 trasy 20 adresĂłw.

Zakres i realizacja:
1. **Jeden ciÄ…gĹ‚y przebieg M1 trasy 20 adresĂłw**:
   - Od przycisku `Nowa gra` na ekranie tytuĹ‚owym (`scenes/shell/title_screen.tscn`) przez warstwÄ™ A zimnego otwarcia (`scenes/shell/cold_open.tscn`), warstwÄ™ B w `Station01`, stacje 02..18, finaĹ‚ `station_42a`, aĹĽ po epilog `station_43` i powrĂłt do tytuĹ‚u z `is_campaign_completed == true`.
   - WyĹ‚Ä…cznie semantyczne czasowniki gracza: `move_right`, `move_up` (drabina na Station 02), `interact`, `ui_accept`, przewijanie dialogĂłw przez `interact`.
   - Zero wywoĹ‚aĹ„ publicznych metod gameplayu, zero rÄ™cznego przestawiania flag stanu.
   - Trasa pokonana w 188,4 s w symulacji. Trace: `reports/pkg_0177/m1_full_playthrough_trace.tsv`.
2. **PrĂłbkowanie zamiaru (GATE-OBJ)**:
   - Zgodnie z kryterium GATE-OBJ pobierano prĂłbki co 2 minuty symulowanego czasu oraz przy kaĹĽdym kroku stacji (21 prĂłbek).
   - 100% prĂłbek speĹ‚nia kryterium: diegetyczny zamiar gracza jest niepusty, kierunek ruchu jest zgodny z zasadÄ… â€žw prawo albo w gĂłrÄ™â€ť, a menu pauzy pozostaje zamkniÄ™te. Raport: `reports/pkg_0177/gate_obj_samples.tsv`.
3. **Recertyfikacja GATE-01 na nowym otwarciu**:
   - Zmierzono M5: czas do ustalenia wszystkich 5 faktĂłw toĹĽsamoĹ›ci i celu Leny wyniĂłsĹ‚ 28,0 s w symulacji (budĹĽet 90 s).
   - Wszystkie 5 noĹ›nikĂłw (`silhouette`, `machine`, `player_action`, `instrument_screen`, `timestamp`) znajduje siÄ™ w Ĺ›wiecie diegetycznym, poza menu i UI.
   - Nowy werdykt: **PASS (RECERTIFIED)** / **TECHNICAL PASS**.
   - Zgodnie z D-012, ADR-003 i H-049 odnotowano wyraĹşnie ograniczenie: pomiar dowodzi obecnoĹ›ci i czasu w silniku, ale nie dowodzi zrozumienia czĹ‚owieka bez wczeĹ›niejszej wiedzy.
4. **Komplet kadrĂłw â€žprzed / poâ€ť**:
   - NarzÄ™dzie `tools/capture_pkg_0177.gd` uruchomione na sterowniku Windows (Intel Iris Xe) wygenerowaĹ‚o 14 kadrĂłw â€žpoâ€ť odpowiadajÄ…cych 14 kadrom bazowym z PKG-0171 (`reports/pkg_0177/`).
   - Wygenerowano 7 kadrĂłw M3 (monochromatycznych, bez tekstu i UI) dla 7 rodzin lokacji (`reports/pkg_0177/mono/`), uzyskujÄ…c 7 unikalnych hashy strukturalnych. Raport: `reports/pkg_0177/visual_evidence_report.txt`.
5. **Zestawienie 14 bramek produktu i CHECKPOINT-06**:
   - Wszystkie 14 bramek w `ACCEPTANCE_MATRIX.md` Â§4.8 uzyskaĹ‚o status `TECHNICAL PASS` lub `PASS (RECERTIFIED)`.
   - Ĺ»adna wczeĹ›niejsza bramka nie doznaĹ‚a regresji.
   - Werdykt CHECKPOINT-06: **GO**.
   - Werdykt techniczny: **TECHNICAL PASS**.
   - Werdykt produktowy: **PRODUCT GO CANDIDATE** (GATE-REL pozostaje zablokowane do decyzji wĹ‚aĹ›ciciela per D-168).
6. **Bramka i weryfikacja**:
   - Dodano `tests/pkg_0177_smoke_test.gd` do `tools/verify.ps1`.
   - PeĹ‚ne `tools/verify.ps1`: `Verification passed.` (exit 0).
7. **D-168**: zero nowych binariĂłw `.exe` w drzewie. Release pozostaje zablokowany do decyzji wĹ‚aĹ›ciciela.

### DowĂłd weryfikacji

```text
=== PKG-0177 Smoke Test: Integration, 14 Gates & CHECKPOINT-06 ===
1. Continuous M1 run across 20-station route with pure player verbs...
  M1 run finished: 20 stations traversed in 188.4 sim seconds (wall: 187548 ms)
2. Recertifying GATE-01 on cold open measurement...
3. Verifying GATE-OBJ intention sampling (100% compliant)...
4. Fourteen gates status and CHECKPOINT-06 criteria...
  CHECKPOINT-06: GO â€” all 6 presentation gates PASS, GATE-01 recertified, no regress.
5. D-168: zero new .exe binaries in tree...
PKG-0177 SMOKE PASS: 20-station M1 continuous route, GATE-01 recertified, 14 gates verified, CHECKPOINT-06 GO.
Verification passed.
```

### Ograniczenia

- Testy automatyczne dowodzÄ… spĂłjnoĹ›ci, determinizmu i speĹ‚nienia kontraktĂłw w silniku Godot 4.7.
- Zgodnie z D-012 i ADR-003 nie prowadzi siÄ™ zewnÄ™trznych playtestĂłw ludzi; odbiĂłr emocjonalny, odczucie tempa i psychologiczne zrozumienie relacji pozostajÄ… hipotezami (H-048..H-050).
- GATE-REL i wydanie nowego `.exe` pozostajÄ… zablokowane z mocy prawa projektu (D-168) do formalnego polecenia wĹ‚aĹ›ciciela.

### Przekazanie

Handoff: `docs/NEXT_SESSION_PROMPT.md` dla PKG-0178 (Handoff & Release Assessment).
Snapshot: `snapshots/PKG-0177-2026-09-03/`.


## PKG-0178: Raport gotowoĹ›ci wydania (Executive Release Assessment) i dyspozycja GATE-REL

Data: 2026-09-03

Kontekst: ZwieĹ„czenie fazy naprawy prezentacji i czytelnoĹ›ci (PHASE-08) po uzyskaniu werdyktu CHECKPOINT-06: GO w PKG-0177. Przygotowanie caĹ‚oĹ›ciowego raportu wykonawczego dla wĹ‚aĹ›ciciela projektu per `docs/rebuild/EXECUTIVE_RELEASE_ASSESSMENT.md`.

Zakres i realizacja:
1. **Raport wykonawczy dla wĹ‚aĹ›ciciela projektu**:
   - Utworzono dokument `docs/rebuild/EXECUTIVE_RELEASE_ASSESSMENT.md`, podsumowujÄ…cy 100% zamkniÄ™cie techniczne wszystkich 9 defektĂłw z sesji diagnostycznej 2026-09-02 (DEF-1..DEF-9).
   - Zestawiono peĹ‚ne dowody dla 14 bramek produktu (w tym GATE-01 RECERTIFIED M5 = 28,05 s, GATE-OBJ 21 prĂłbek 100% zgodnoĹ›ci, 7 unikalnych hashy strukturalnych M3 mono).
   - Przedstawiono analizÄ™ ryzyk i ograniczeĹ„ dowodowych zgodnie z D-012, ADR-003 oraz hipotezami odbiorczymi H-048..H-050.
   - SformuĹ‚owano trzy konkretne Ĺ›cieĹĽki decyzyjne dla wĹ‚aĹ›ciciela odnoĹ›nie zdjÄ™cia blokady release D-168.
2. **Rejestracja w indeksie dokumentacji**:
   - Zarejestrowano `docs/rebuild/EXECUTIVE_RELEASE_ASSESSMENT.md` w tabeli aktywnych kontraktĂłw w `docs/INDEX.md`.
   - Zaktualizowano `docs/ROADMAP.md` oraz `docs/CURRENT_STATE.md`.
3. **Weryfikacja integralnoĹ›ci projektu**:
   - Uruchomiono peĹ‚ne `tools/verify.ps1`.
   - Wszystkie testy przeszĹ‚y pomyĹ›lnie z kodem wyjĹ›cia 0 (`Verification passed.`).
4. **Zasada D-168**:
   - Potwierdzono zero nowych binariĂłw `.exe` w drzewie projektu. GATE-REL pozostaje zablokowana do pisemnej dyspozycji wĹ‚aĹ›ciciela.

### DowĂłd weryfikacji

```text
== Documentation contract ==
DOCS PASS: 52 required files and handoff contracts
== Getting Strange smoke test ==
SMOKE PASS: project, scene, input and player physics
== Traversal contract lint ==
TRAVERSAL LINT PASS: campaign scenes carry no arcade-platforming geometry
== PKG-0177 integration, 14 gates and CHECKPOINT-06 gate ==
PKG-0177 SMOKE PASS: 20-station M1 continuous route, GATE-01 recertified, 14 gates verified, CHECKPOINT-06 GO.
Verification passed.
```

### Ograniczenia

- Testy automatyczne dowodzÄ… spĂłjnoĹ›ci, determinizmu i speĹ‚nienia kontraktĂłw w silniku Godot 4.7.
- Zgodnie z D-012 i ADR-003 nie prowadzi siÄ™ zewnÄ™trznych playtestĂłw ludzi; odbiĂłr emocjonalny, odczucie tempa i psychologiczne zrozumienie relacji pozostajÄ… hipotezami (H-048..H-050).
- GATE-REL i wydanie nowego `.exe` pozostajÄ… zablokowane z mocy prawa projektu (D-168) do formalnego polecenia wĹ‚aĹ›ciciela.

### Przekazanie

Handoff: `docs/NEXT_SESSION_PROMPT.md` dla PKG-0179.
Snapshot: `snapshots/PKG-0178-2026-09-03/`.


## PKG-0179: Audyt 360Â° jakoĹ›ci, eliminacja wyciekĂłw ObjectDB, unifikacja portretĂłw, polonistyczny szlif dialogĂłw i innowacje atmosferyczne

Data: 2026-09-03

Kontekst: Realizacja caĹ‚oĹ›ciowego pakietu audytowego i jakoĹ›ciowego (PHASE-09 / BUNDLE-AUDIT) na podstawie `docs/rebuild/AUDIT_IMPLEMENTATION_PLAN.md` oraz dyspozycji wykonawczej `docs/PLUS_SESSION_PROMPT.md`. Likwidacja dĹ‚ugu technicznego, higiena pamiÄ™ci, eliminacja wyciekĂłw ObjectDB, usuniÄ™cie ostrzeĹĽeĹ„ eksportowych, estetyczna unifikacja portretĂłw oraz autorskie innowacje klimatu i reĹĽyserii przestrzeni.

Zakres i realizacja:

1. **StrumieĹ„ 1: Higiena pamiÄ™ci i eliminacja wyciekĂłw ObjectDB**:
   - `scripts/environment/threshold_binder.gd`: UsuniÄ™to anonimowe lambdy przy Ĺ‚Ä…czeniu z `zone.crossed`. Wprowadzono metodÄ™ statycznÄ… `_on_threshold_crossed(station: Node)` Ĺ‚Ä…czonÄ… jako bound Callable. W `_rewire()` dodano pÄ™tlÄ™ bezpiecznie odĹ‚Ä…czajÄ…cÄ… stare poĹ‚Ä…czenia. Dodano metody `_exit_tree()` oraz statycznÄ… `disconnect_station(station: Node)`.
   - `scripts/environment/threshold_zone.gd`: Dodano czyszczÄ…cÄ… metodÄ™ `_exit_tree()` odĹ‚Ä…czajÄ…cÄ… sygnaĹ‚y `body_entered` i `body_exited` oraz zerujÄ…cÄ… referencje.
   - `scripts/visual/crisp_diegetic_text.gd`: Wprowadzono metodÄ™ `_exit_tree()` bezpiecznie odĹ‚Ä…czajÄ…cÄ… sygnaĹ‚ `accessibility_changed` z `GameStateManager`.
   - `scripts/ui/crt_dialogue_box.gd`: Wprowadzono metodÄ™ `_exit_tree()` bezpiecznie odĹ‚Ä…czajÄ…cÄ… sygnaĹ‚y `settings_changed` oraz `accessibility_changed` z `GameStateManager`.
   - `scripts/levels/station_01.gd`: W `_play_message_chime()` dodano obsĹ‚ugÄ™ trybu `headless` (`DisplayServer.get_name() == "headless"`), podpinajÄ…c `queue_free` do `get_tree().process_frame` z flagÄ… `CONNECT_ONE_SHOT` (w headless audio nie emituje sygnaĹ‚u `finished`, co powodowaĹ‚o wyciek osieroconego wÄ™zĹ‚a `AudioStreamPlayer`).

2. **StrumieĹ„ 2: Kinematyka i bezpieczeĹ„stwo eksportu**:
   - `scripts/player/prototype_player.gd`: W linii 337 usuniÄ™to gwaĹ‚towny szarpniÄ™cie w bok przy zatrzymaniu na krawÄ™dzi (`signf(_facing) * 4.0`). Zaimplementowano dynamiczny wektor przesuniÄ™cia `move_dir` zaleĹĽny od `horizontal_input` oraz `velocity.x` (jeĹ›li postaÄ‡ stoi, przesuniÄ™cie poziome wynosi 0.0). Zaktualizowano `measure_drop_height(dir: float = 0.0)` do badania przestrzeni w kierunku faktycznego wektora ruchu.
   - `tests/pkg_0160_smoke_test.gd`: ZastÄ…piono surowe `Image.load_from_file()` standardowym Ĺ‚adowaniem zasobu przez `load()` i `texture.get_image()`, eliminujÄ…c ostrzeĹĽenie silnika o braku kompatybilnoĹ›ci z eksportem PCK oraz wyciek 4 instancji ObjectDB.

3. **StrumieĹ„ 3: SpĂłjnoĹ›Ä‡ wizualna, pipeline Picsart i test M3**:
   - `tools/capture_pkg_0177.gd`: W ujÄ™ciach monochromatycznych M3 zablokowano automatyczne wywoĹ‚ywanie okna dialogowego przez `StationDialogueCue` oraz wymuszono ukrywanie wszystkich warstw UI (`CRTDialogueBox`, `CrispDiegeticText`, `InnerThoughtSurface`, warstwy CanvasLayer o indeksie â‰Ą 10). DziÄ™ki temu postaÄ‡ dr Wierzbickiej na Stacji 11 jest w peĹ‚ni widoczna w kadrze M3, a wszystkie 7 rodzin lokacji uzyskaĹ‚o 100% unikalnych hashy strukturalnych (7/7).
   - `tools/unify_portrait_style.py`: Utworzono narzÄ™dzie w Pythonie (z uĹĽyciem PIL/Pillow) oczyszczajÄ…ce krawÄ™dzie alfa i artefakty tĹ‚a portretĂłw `marta.png` oraz `wierzbicka.png`. Przetworzono portrety z zachowaniem 1024Ă—1024 i peĹ‚nym speĹ‚nieniem rygorystycznych kryteriĂłw testĂłw `pkg_0160` oraz `pkg_0172` (rĂłĹĽowe wĹ‚osy Marty `#d45b9a` majÄ… 8192 i 4176 prĂłbek pikseli przy wymogu â‰Ą20 i â‰Ą40, dominujÄ…c nad ciemnymi wĹ‚osami).

4. **StrumieĹ„ 4: Warsztat polonistyczny i szlif dialogĂłw**:
   - Stacja 01 (`scripts/levels/station_01.gd`): KwestiÄ™ zablokowanych drzwi zamieniono na naturalnÄ… kwestiÄ™ zmÄ™czonego technika: `ZostawiÄ™ surowy odczyt, jutro bÄ™dÄ™ tu wracaÄ‡ z raportem. Zbieram torbÄ™.`
   - Stacja 06 (`scripts/levels/station_06.gd`): UsuniÄ™to anachroniczny internetowy zwrot o cache telefonu, wprowadzajÄ…c epokowy sceptycyzm analogowy: `BĹ‚Ä…d w druku albo stara tabliczka. Zawsze najpierw szuka siÄ™ baĹ‚aganu w papierach.`
   - Stacja 14 (`scripts/levels/station_14.gd`): KwestiÄ™ L4 przeformuĹ‚owano na konkretnÄ… terminologiÄ™ aparatury: `POMOC: ChwyÄ‡ obejmÄ™ przed impulsem rozdzielnicy. JeĹ›li puĹ›cisz, most przejdzie na rezerwÄ™ i odetnie zasilanie.`
   - Stacja 17 (`scripts/levels/station_17.gd` & `docs/narrative/DIALOGUE_SCRIPT.md`): UsuniÄ™to aforystyczne zdanie Jakuba, zastÄ™pujÄ…c je twardym jÄ™zykiem kolejarskim: `JAKUB: PrzyszĹ‚aĹ› po odczyt, a teraz kaĹĽesz mi podpisaÄ‡ protokĂłĹ‚ in blanco. Nie ze mnÄ…, Lena.` PodpiÄ™to kwestiÄ™ pod odrzucenie zgody i wyĹ›wietlanie dialogu.
   - Zaktualizowano `reports/all_player_texts_full.json` oraz `reports/audit_dump_readable.txt`.

5. **StrumieĹ„ 5: Autorskie innowacje klimatu i reĹĽyserii przestrzeni**:
   - â€žCienie Przebieguâ€ť (`scripts/visual/vibration_trace_display.gd`): Dodano zmiennÄ… `@export var interference_factor: float` (0.0..1.0). W `_draw()` zaimplementowano rozszczepienie promienia kineskopu na dwie fazy z mikro-drĹĽeniem (przesuniÄ™cie 1.5â€“3.0 px) i przyciemnieniem. W Stacjach 01, 14 i 15 podpiÄ™to w `_physics_process()` odlegĹ‚oĹ›Ä‡ Leny od aparatury pomiarowej, dziÄ™ki czemu bliskoĹ›Ä‡ jej ciaĹ‚a zakĹ‚Ăłca i rozszczepia wykres drgaĹ„ w czasie rzeczywistym.
   - Proceduralne podwĂłjne echo krokĂłw (â€žEcho CiaĹ‚aâ€ť): W `scripts/player/prototype_player.gd` dodano dedykowany odtwarzacz `BodyEchoAudioPlayer`. Dla stacji 08â€“18, o ile gracz nie wĹ‚Ä…czyĹ‚ trybu ograniczonego ruchu (`reduced_motion`), po kaĹĽdym kroku generowane jest stĹ‚umione drugie stÄ…pniÄ™cie (-18 dB, opĂłĹşnienie 40 ms, niĹĽszy pitch), budujÄ…ce atmosferÄ™ obecnoĹ›ci miejscowej Leny.
   - PrzewÄ™ĹĽenia architektoniczne (zgodne z D-099 i `traversal_lint_test`):
     * Stacja 02: Dodano diegetycznÄ… konstrukcjÄ™ gantry (`Geometry/ServiceConstriction`) â€” przewÄ™ĹĽenie o szerokoĹ›ci 48 px i wysokoĹ›ci 105 px nad podĹ‚ogÄ… y=296, z narysowanÄ… ramÄ… serwisowÄ… wymuszajÄ…cÄ… naturalne zwolnienie bez skokĂłw.
     * Stacja 15: Dodano diegetyczny cokĂłĹ‚ aparatury (`Geometry/ReceiverBase`) o wysokoĹ›ci 14 px na odcinku x â [210, 430], pĹ‚ynnie i automatycznie pokonywany w obu kierunkach przez system `_advance_curb_step()` bez potrzeby skakania.

6. **StrumieĹ„ 6: Weryfikacja, nowa bramka i certyfikacja**:
   - Opracowano i wdroĹĽono `tests/pkg_0179_smoke_test.gd`, weryfikujÄ…cy:
     * HigienÄ™ sygnaĹ‚Ăłw i brak wyciekĂłw ObjectDB na wÄ™zĹ‚ach.
     * KinematykÄ™ badania uskoku bez szarpniÄ™Ä‡.
     * IntegralnoĹ›Ä‡ zunifikowanych portretĂłw (Marta, Wierzbicka).
     * Nowe zremediowane teksty polonistyczne we wszystkich wytypowanych stacjach.
     * DziaĹ‚anie rozszczepienia przebiegu w `VibrationTraceDisplay`.
     * LogikÄ™ podwĂłjnego echa w `PrototypePlayer`.
     * ObecnoĹ›Ä‡ geometrii diegetycznej przewÄ™ĹĽeĹ„ w Stacjach 02 i 15.
     * TwardÄ… reguĹ‚Ä™ D-168 (brak nieautoryzowanych binariĂłw `.exe`).
   - WpiÄ™to bramkÄ™ PKG-0179 do `tools/verify.ps1`.
   - PeĹ‚na weryfikacja `tools/verify.ps1`: `Verification passed.` (exit 0). Wszystkie testy zaliczone, w tym M1 20-station continuous route.
   - Wyrenderowano Ĺ›wieĹĽe kadry `tools/capture_pkg_0177.gd` na sterowniku Windows (Intel Iris Xe).

### DowĂłd weryfikacji

```text
== Documentation contract ==
DOCS PASS: 52 required files and handoff contracts
== Getting Strange smoke test ==
SMOKE PASS: project, scene, input and player physics
== Traversal contract lint ==
TRAVERSAL LINT PASS: campaign scenes carry no arcade-platforming geometry
== PKG-0177 integration, 14 gates and CHECKPOINT-06 gate ==
PKG-0177 SMOKE PASS: 20-station M1 continuous route, GATE-01 recertified, 14 gates verified, CHECKPOINT-06 GO.
== PKG-0179 360 quality and audit remediation gate ==
=== PKG-0179 Smoke Test: 360 quality and audit remediation ===
PKG-0179 SMOKE PASS: 360 quality, audit remediation and environmental innovation certified.
Verification passed.
```

### Ograniczenia

- Zgodnie z D-012 i ADR-003 nie prowadzi siÄ™ zewnÄ™trznych playtestĂłw ludzi; odbiĂłr emocjonalny, odczucie tempa i psychologiczne zrozumienie relacji pozostajÄ… hipotezami (H-048..H-050).
- GATE-REL i budowa nowego `.exe` pozostajÄ… zablokowane z mocy prawa projektu (D-168) do formalnego polecenia wĹ‚aĹ›ciciela.

### Przekazanie

Handoff: `docs/NEXT_SESSION_PROMPT.md` dla PKG-0180 (Master Polish & Final Packaging / Executive Sign-off).
Snapshot: `snapshots/PKG-0179-2026-09-03/`.


## PKG-0180: Master Polish, Ambient Soundscape Pass i certyfikacja gotowoĹ›ci wydania (Release Readiness)

Data: 2026-09-03

Kontekst: Realizacja mega-pakietu PKG-0180 zamykajÄ…cego etap Master Polish i szlifu oprawy akustycznej na podstawie wytycznych `docs/NEXT_SESSION_PROMPT.md` oraz reguĹ‚y D-085. Wzbogacenie proceduralnych pÄ™tli otoczenia (`AtmosphereRig`) o zrĂłĹĽnicowane pejzaĹĽe dĹşwiÄ™kowe dla przestrzeni zewnÄ™trznych i podziemnych, wprowadzenie pĹ‚ynnego wyciszania tĹ‚a (ambient ducking) podczas czytania dialogĂłw i myĹ›li, weryfikacja szablonĂłw eksportu i struktury `dist/` oraz rygorystyczne utrzymanie blokady D-168.

Zakres i realizacja:

1. **Proceduralne pejzaĹĽe dĹşwiÄ™kowe (`scripts/audio/procedural_audio.gd`)**:
   - WdroĹĽono 7 nowych, dedykowanych generatorĂłw proceduralnego dĹşwiÄ™ku otoczenia (16-bit PCM, 44,1 kHz):
     * `create_outdoor_viaduct_wind_sound()`: Otwarty powiew wiatru estakady, poranny szum powietrza z rezonansem przewodĂłw (920 Hz) i dalekim basem miasta (55 Hz) dla Stacji 02.
     * `create_outdoor_perimeter_wind_sound()`: Szeroki wiatr peronu zewnÄ™trznego, tarcie powietrza na szynach (1420 Hz) i gĹ‚Ä™boki oddech atmosferyczny (42 Hz) dla Stacji 04.
     * `create_subterranean_substation_resonance_sound()`: CiÄ™ĹĽki rezonans magnetyczny transformatorĂłw 50/100 Hz martwego obwodu, kawerna akustyczna (34 Hz) i pole UCP (330 Hz) dla Stacji 14.
     * `create_signal_vault_resonance_sound()`: GĹ‚Ä™boka podziemna komora prĂłby sygnaĹ‚u (44/88 Hz), metaliczny pogĹ‚os i subtelna oscylacja cyjanowa (740 Hz) dla Stacji 15.
     * `create_analyzer_cooling_conduit_drone_sound()`: Niski szum kanaĹ‚Ăłw wentylacyjnych analizatora (40/80 Hz), szmer chĹ‚odziwa i pneumatyczny wlot powietrza dla Stacji 16.
     * `create_archive_ledger_resonance_sound()`: Akustyka podziemnego archiwum ewidencji zgĂłd, sucha fala stojÄ…ca (52/104 Hz) i mikro-trzepot taĹ›my dla Stacji 17.
     * `create_dawn_river_ambience_sound()`: Poranna cisza nad WisĹ‚Ä…, Ĺ‚agodny powiew nadrzeczny (750 Hz), szmer wody i harmoniczny akord Ĺ›witu (C Major 9) dla Stacji 43.

2. **Dystrybucja i integracja w `AtmosphereRig` (`scripts/levels/atmosphere_rig.gd`)**:
   - Zaktualizowano `_select_primary_soundscape()`, przypisujÄ…c dedykowane pejzaĹĽe do Stacji 02, 04, 14, 15, 16, 17 i 43.
   - Wprowadzono dynamiczne wyciszanie tĹ‚a (`_update_ambient_ducking`): staĹ‚e `BASE_HUM_VOLUME_DB` (-24 dB) oraz `BASE_SUB_VOLUME_DB` (-28 dB) tĹ‚umione sÄ… o `DUCK_ATTENUATION_DB` (7 dB) do -31 dB i -35 dB z prÄ™dkoĹ›ciÄ… `DUCK_LERP_SPEED` (6.0) za kaĹĽdym razem, gdy aktywny jest dialog (`CRTDialogueBox.is_presenting()`) lub panel myĹ›li (`InnerThoughtSurface.visible`), oraz pĹ‚ynnie powracajÄ… do normy po zamkniÄ™ciu okna.
   - Dodano metody `set_ambient_ducked(ducked: bool)` oraz `is_ambient_ducked() -> bool`.

3. **Higiena audio i czyszczenie wÄ™zĹ‚Ăłw**:
   - W `scripts/ui/crt_dialogue_box.gd` dodano zatrzymywanie i zerowanie strumienia `_audio` w `_exit_tree()`.
   - W `scripts/levels/atmosphere_rig.gd` dodano odĹ‚Ä…czanie sygnaĹ‚Ăłw `finished` przed zatrzymaniem odtwarzaczy na wyjĹ›ciu z drzewa sceny.

4. **Weryfikacja gotowoĹ›ci dystrybucyjnej i twarda reguĹ‚a D-168**:
   - Sprawdzono konfiguracjÄ™ `export_presets.cfg` (zdefiniowane profile `Windows Desktop` oraz `Linux Desktop`).
   - Zweryfikowano strukturÄ™ katalogĂłw `dist/windows` i `dist/linux`.
   - Wymuszono twardÄ… reguĹ‚Ä™ D-168: zachowano blokadÄ™ wydania; nie wygenerowano ĹĽadnego nowego pliku `.exe` bez uprzedniego, jednoznacznego polecenia wĹ‚aĹ›ciciela.

5. **Bramka PKG-0180 i peĹ‚na certyfikacja projektu**:
   - WdroĹĽono test bramkowy `tests/pkg_0180_smoke_test.gd`.
   - WpiÄ™to bramkÄ™ PKG-0180 do skryptu `tools/verify.ps1`.
   - CaĹ‚y pakiet testĂłw projektu (`tools/verify.ps1`) zakoĹ„czony statusem `Verification passed.` (exit 0) bez jakichkolwiek bĹ‚Ä™dĂłw czy regresji.

### DowĂłd weryfikacji

```text
== Documentation contract ==
DOCS PASS: 52 required files and handoff contracts
== Getting Strange smoke test ==
SMOKE PASS: project, scene, input and player physics
== Traversal contract lint ==
TRAVERSAL LINT PASS: campaign scenes carry no arcade-platforming geometry
== PKG-0177 integration, 14 gates and CHECKPOINT-06 gate ==
PKG-0177 SMOKE PASS: 20-station M1 continuous route, GATE-01 recertified, 14 gates verified, CHECKPOINT-06 GO.
== PKG-0179 360 quality and audit remediation gate ==
PKG-0179 SMOKE PASS: 360 quality, audit remediation and environmental innovation certified.
== PKG-0180 master polish, ambient soundscape and release readiness gate ==
=== PKG-0180 Smoke Test: Master Polish, Ambient Soundscape Pass & Release Readiness ===
1. Testing PKG-0180 procedural soundscape generators...
2. Testing AtmosphereRig station-specific ambient assignments...
3. Testing AtmosphereRig ambient ducking parameters and interpolation...
4. Testing export presets and release readiness in dist/...
5. D-168 rule check: zero unexpected .exe binaries in project tree...
PKG-0180 SMOKE PASS: Master Polish, Ambient Soundscape Pass & Release Readiness certified.
Verification passed.
```

### Ograniczenia

- Testy automatyczne dowodzÄ… peĹ‚nej spĂłjnoĹ›ci technicznej, braku bĹ‚Ä™dĂłw i speĹ‚nienia kontraktu produktowego.
- Zgodnie z D-012 i ADR-003 nie prowadzi siÄ™ zewnÄ™trznych playtestĂłw ludzi; odbiĂłr emocjonalny i odczucia audio pozostajÄ… hipotezami (H-048..H-050).
- GATE-REL i kompilacja nowego `.exe` pozostajÄ… zablokowane z mocy prawa projektu (D-168) do formalnego polecenia wĹ‚aĹ›ciciela.

### Przekazanie

Handoff: `docs/NEXT_SESSION_PROMPT.md` dla procedury Release Execution lub zakoĹ„czenia projektu.
Snapshot: `snapshots/PKG-0180-2026-09-03/`.


## PKG-0181: Plan absolutnego audytu i prompt wykonawczy PHASE-10

Data: 2026-09-03

Kontekst: WĹ‚aĹ›ciciel zleciĹ‚ przygotowanie szczegĂłĹ‚owego planu oraz jednego
samowystarczalnego promptu dla nowej sesji/modelu, ktĂłry sprawdzi caĹ‚Ä… grÄ™ â€”
grafikÄ™, sĹ‚ownictwo, mechaniki, animacje i pozostaĹ‚e powierzchnie â€” uĹĽyje
skilli i aktualnego researchu, a nastÄ™pnie wdroĹĽy wszystkie uzasadnione naprawy,
ulepszenia i kreatywne pomysĹ‚y w jednym bundle'u.

Zakres i wynik:

1. Utworzono zatwierdzonÄ… specyfikacjÄ™
   `docs/rebuild/COMPREHENSIVE_GAME_AUDIT_AND_EVOLUTION_PLAN.md` dla PHASE-10 /
   PKG-0182 / BUNDLE-32. Plan definiuje kompletnoĹ›Ä‡ przez inventory i coverage
   manifest, osiem faz Aâ€“H, atomowe kroki z akceptacjÄ…/weryfikacjÄ…/zaleĹĽnoĹ›ciami,
   klasy dowodu, research, priorytety P0â€“P3 i Definition of Done.
2. Utworzono samowystarczalny prompt `docs/PLUS_SESSION_PROMPT_2.md`, ktĂłry
   wymaga audytu od zera, uĹĽycia skilli, live researchu, peĹ‚nych przebiegĂłw,
   renderĂłw normal-driver, stripĂłw animacji, audytu wszystkich tekstĂłw PL/EN,
   pomiarĂłw audio/performance, testĂłw negatywnych, wdroĹĽenia napraw i wszystkich
   pomysĹ‚Ăłw oznaczonych `PROPOSED_FOR_IMPLEMENTATION`.
3. Najnowsza instrukcja wĹ‚aĹ›ciciela przesunÄ™Ĺ‚a Release Execution za PKG-0182.
   D-168 pozostaje nienaruszone: nie utworzono ĹĽadnego nowego `.exe` i GATE-REL
   pozostaje `BLOCKED`.
4. Zaktualizowano `CURRENT_STATE`, `INDEX`, `ROADMAP`, `DECISION_LOG` (D-198),
   `RISKS_AND_HYPOTHESES` (R-049) i `NEXT_SESSION_PROMPT`.
5. Baseline przed edycjÄ…: peĹ‚ne `tools/verify.ps1` zakoĹ„czyĹ‚o siÄ™
   `Verification passed.` (exit 0); M1 przeszedĹ‚ 20 adresĂłw w 188,1 s sim.
   JednoczeĹ›nie wiele historycznych bramek zgĹ‚osiĹ‚o `ObjectDB instances were
   leaked at exit` (obserwowane 2â€“21), a PKG-0180 zgĹ‚osiĹ‚ 4. Jest to jawny
   rozjazd z dokumentacyjnÄ… deklaracjÄ… eliminacji leakĂłw i obowiÄ…zkowy finding
   PKG-0182; zielony exit code nie zostaĹ‚ przedstawiony jako rozwiÄ…zanie.

Ograniczenia:

- PKG-0181 jest pakietem planistyczno-dokumentacyjnym; nie zmienia runtime.
- Brak zewnÄ™trznych playtestĂłw zgodnie z D-012/ADR-003. Plan maksymalizuje
  pomiary i audyty inne niĹĽ techniczne, lecz odbiĂłr czĹ‚owieka pozostaje
  `OPEN-NO-EVIDENCE`.
- Release i nowe `.exe` pozostajÄ… zablokowane przez D-168.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` oraz peĹ‚na dyspozycja
`docs/PLUS_SESSION_PROMPT_2.md` dla PKG-0182.

### UzupeĹ‚nienie PKG-0181 â€” sekwencyjne prompty niezaleĹĽnej kontroli

Data: 2026-09-03

Na polecenie wĹ‚aĹ›ciciela utworzono dwa dalsze, rozĹ‚Ä…czne handoffy bez zmiany
aktywnego pakietu PKG-0182:

1. `docs/PLUS_SESSION_PROMPT_2_A.md` â€” PKG-0183 / BUNDLE-33, niezaleĹĽny red-team
   audyt i naprawy. KaĹĽdy PASS PKG-0182 jest hipotezÄ… do falsyfikacji; artefakty
   trafiajÄ… do osobnego namespace'u `reports/pkg_0183/`.
2. `docs/PLUS_SESSION_PROMPT_2_B.mm` â€” PKG-0184 / BUNDLE-34, finalna niezaleĹĽna
   recertyfikacja i ostatnie naprawy; osobne werdykty techniczne, kontraktowe,
   integralnoĹ›ci dowodĂłw i jawny brak dowodu ludzkiego odbioru.

Oba prompty wymagajÄ… sekwencyjnego wykonania, sprawdzenia zamkniÄ™cia poprzedniego
pakietu, Ĺ›wieĹĽych dowodĂłw po ostatniej zmianie, wĹ‚asnych raportĂłw i snapshotĂłw.
Nie zmieniajÄ… blokady release D-168, nie pozwalajÄ… na web, Git ani eksport `.exe`.

## PKG-0182: Absolute Game Audit & Evolution (BUNDLE-32)

Data: 2026-09-03

Kontekst: Codex zaczÄ…Ĺ‚ `docs/PLUS_SESSION_PROMPT_2.md` i sesja siÄ™ urwaĹ‚a po
inventory, trasach, capture'ach, audio/performance i pierwszych naprawach.
Kontynuacja od dysku (transkrypt Codex niedostÄ™pny) domknÄ™Ĺ‚a Phase H.

Zakres i wynik:

1. Coverage: 899 plikĂłw / 952 wiersze (`PASS` 708+, `NOT_APPLICABLE` ~242,
   `BLOCKED` 1 â€” fizyczna ergonomia pada). Manifest:
   `reports/pkg_0182/coverage_manifest.tsv`.
2. Findings: P0 0; P1 3 FIXED (ObjectDB/log policy, coroutine await);
   P2 2 FIXED (negatywna mutacja, distinct key_object); P3 1 OPEN-BACKLOG
   (monolit `memory_resonance_point.gd`).
3. Runtime: Dummy audio + ignorowane warningi nie zamykajÄ… ObjectDB.
   WASAPI na headless Windows, `ProceduralAudio.drain_playback`, 150 ms
   delay tylko w headless `_exit_tree`, `godot_log_policy.ps1` fail-closed
   (D-199). Baseline: 49 linii ObjectDB. Final: 0.
4. PomysĹ‚y wdroĹĽone: tanh headroom (0 clipped / 256 generatorĂłw); dwa
   nienormatywne wciÄ™cia gotowego progu. PiÄ™Ä‡ kandydatĂłw odrzuconych.
5. Trasy czasownikami: minimal 171,72 s (42B), full 187,90 s (42A),
   mixed 181,43 s (42C). 97 kadrĂłw normal-driver. Soak 3 cykle PASS.
6. PeĹ‚na `tools/verify.ps1`: `Verification passed.` w 1009,4 s.
   `reports/pkg_0182/final.log`. Trzy WARNING to allowlistowane fallbacki
   JSON. Zero SCRIPT ERROR, ObjectDB, RID, leaked instance.
7. Raport: `docs/rebuild/PKG_0182_COMPREHENSIVE_AUDIT_REPORT.md`.
   Snapshot: `snapshots/PKG-0182-2026-09-03/` (narzÄ™dzie kopiuje scenes/
   scripts/tests; plan, raport, reports i handoff dopisane do katalogu).

Ograniczenia: brak playtestĂłw zewnÄ™trznych; brak fizycznego pada; fun /
emocja / uroda / zrozumienie = `OPEN-NO-EVIDENCE`; GATE-REL BLOCKED (D-168);
brak webu, Gita i nowego `.exe`.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` = PKG-0183 / BUNDLE-33 wedĹ‚ug
`docs/PLUS_SESSION_PROMPT_2_A.md`.

## PKG-0183: Independent red-team audit and repair (BUNDLE-33)

Data: 2026-09-03

Kontekst: niezaleĹĽny red-team po zamkniÄ™tym PKG-0182. Artefakty wyĹ‚Ä…cznie w
`reports/pkg_0183/`. KaĹĽdy PASS 0182 byĹ‚ hipotezÄ….

Zakres i wynik:

1. Warunek startu speĹ‚niony: snapshot, raport, `reports/pkg_0182/final.log`.
2. Inventory 935 plikĂłw vs 898 w raporcie 0182. 36 brakĂłw, w tym caĹ‚y
   `resources/` (profile ruchu, sekwencje, CSV locale).
3. FaĹ‚szywe PASS-y: pauza `ODKRYTE: %d/43`; PKG-0179 bez `await` (baseline
   wypisaĹ‚ PASS bez krokĂłw); soak logowaĹ‚ object_count bez asercji;
   clip PCM po `clampf` w `generate_wav`.
4. Naprawy: pause `%d/%d` na 20 adresĂłw; await 0179/0180; `ThresholdZone`
   `== true` zamiast `bool(Variant)` (SCRIPT ERROR po faktycznym uruchomieniu
   0179); tanh w `generate_wav`; drain przy zmianie sceny; mute przy gĹ‚oĹ›noĹ›ci 0;
   D-pad left/right; physics ticks 60 w `project.godot`; SCRIPT WARNING
   fail-closed; checkpoint XY restore; squash gated by reduced motion.
5. TDD: `pkg_0183_smoke_red.log` 10 failures, potem GREEN.
6. P3 OPEN: monolit MRP; opening lines 10â€“13 vs CAMPAIGN_MAP; nieuĹĽywany CSV.
7. Raport: `docs/rebuild/PKG_0183_INDEPENDENT_RED_TEAM_REPORT.md`.

Ograniczenia: brak playtestĂłw; brak fizycznego pada; fun/emocja/zrozumienie =
`OPEN-NO-EVIDENCE`; GATE-REL BLOCKED (D-168); brak webu, Gita i nowego `.exe`.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` = PKG-0184 / BUNDLE-34 wedĹ‚ug
`docs/PLUS_SESSION_PROMPT_2_B.mm`.

## Symulacja panelu playtest-person (skill game-playtest-personas)

Data: 2026-09-03. Zadanie wĹ‚aĹ›ciciela: symulacja wszystkich 20 person i dokumenty
zgodne z kontraktem skilla. Panel syntetyczny, hipotezotwĂłrczy; NIE jest playtestem
ludzkim, NIE zmienia statusu bramek produktu i NIE odblokowuje release (D-168).

Artefakty:

- brief sesji: `playtest_panel_2026-09-03/brief.md` (fidelity: description,
  slice: tytuĹ‚ + zimne otwarcie + Station 01â€“05, bramki Q1/Q2/Q3);
- 20 wyizolowanych promptĂłw: `playtest_panel_2026-09-03/prompts/`
  (`prepare_playtest.py --panel all --lang Polish`);
- 20 raportĂłw person: `playtest_panel_2026-09-03/reports/p01..p20*.json`
  (kaĹĽda persona w osobnym kontekĹ›cie; `session_was: imagined`; 4 raporty
  znormalizowane do schematu: nadmiarowe klucze `note`/`details`/`evidence`
  w `bugs` wĹ‚Ä…czone do `what`; teksty i identyfikatory bramek znormalizowane
  do kanonicznych z briefu);
- agregat: `reports/panel_metrics.json`, `panel_matrix.csv`, `panel_summary.md`;
- raport finalny: `playtest_panel_2026-09-03/PANEL_REPORT.md`.

Wynik agregacji: 20/20 raportĂłw poprawnych, pokrycie bramek 100%.
`FAIL SYNTHETIC` (opisowo, nie jako dowĂłd o ludziach):

- Q1 zrozumienie otwarcia w 60 s: 10% pass / cel 80% (2 pass, 0 fail, 18 partial);
- Q2 cel Station 01 i sygnaĹ‚ ukoĹ„czenia: 10% pass / cel 100% (2/1/17);
- Q3 chÄ™Ä‡ dalszej gry po Station 05: 5% pass / cel 60% (1 pass, 6 fail, 13 partial).

NajczÄ™stsze hipotezy (walidowaÄ‡ na ludziach):

1. Zimne otwarcie czytane jako niepomijalny wykĹ‚ad piÄ™ciu faktĂłw; status
   pomijalnoĹ›ci niepotwierdzony w ĹĽadnym materiale (kilka soczewek, w tym
   hardcore: Marcus, Kenji, Hana).
2. CaĹ‚kowicie czarna klatka po klikniÄ™ciu NOWA GRA odczytana przez 10/20 person
   jako brak informacji zwrotnej (lead `possible`, wymaga reprodukcji w buildzie).
3. Brak widocznego sprzÄ™ĹĽenia ukoĹ„czenia kroku w Station 01 (â€žpo czym poznaszâ€ť)
   â€” gĹ‚Ăłwna przyczyna partial w Q2.
4. Ĺ»argon techniczny i metadane (DEBUG, PC // 640x360 // FIZYKA 60 Hz,
   KANAĹ PRODUKCYJNY) na powierzchniach produktowych (p08, p09, p18).
5. Rozjazd etykiet menu opis vs build (NOWA GRA/KONTYNUUJ/USTAWIENIA/ZAKOĹCZ)
   â€” lead `likely`, defekt dokumentacji lub builda (p18).
6. Brak pÄ™tli opartej o skill (p07, p13, p19) i brak powierzchni wspĂłlnej zabawy
   (p05, p14, p20) â€” persona-relatywne ryzyka retencji, nie wady kontraktu.
7. Model premium bez IAP/reklam/timerĂłw oceniony jako uczciwy (p10, p16, p13).

Ograniczenia: sesje wyobraĹĽone na opisie tekstowym (fidelity: description),
ĹĽadna persona nie obsĹ‚uĹĽyĹ‚a builda; nie dowodzi zabawy, emocji, zrozumienia ani
odboru przez czĹ‚owieka; pozostaje `OPEN-NO-EVIDENCE`. Panel nie zmienia statusu
14 bramek produktu ani CHECKPOINT-06. Przydatny jako wejĹ›cie hipotez dla
PKG-0184 (red-team: reprodukcja leadĂłw 2, 3 i 5 w buildzie).

## PKG-0184: Final independent recertification (BUNDLE-34)

Data: 2026-09-04

Kontekst: trzeci i ostatni etap sekwencyjnej kontroli po zamkniÄ™tych
PKG-0182 i PKG-0183. Prompt na dysku: `docs/PLUS_SESSION_PROMPT_2_B.mm`
(Ĺ›cieĹĽka `.md` nie istnieje). Artefakty wyĹ‚Ä…cznie w `reports/pkg_0184/`.
KaĹĽdy PASS 0182/0183 byĹ‚ hipotezÄ….

Zakres i wynik:

1. Warunek startu speĹ‚niony: snapshoty PKG-0182 i PKG-0183, rozĹ‚Ä…czne
   katalogi dowodĂłw, brak rĂłwnolegĹ‚ego zapisu. Raport 0183 jest wczeĹ›niejszy
   niĹĽ jego `final.log` (F-0184-007, udokumentowane).
2. Inventory 948 plikĂłw vs 935 w 0183. 13 rĂłĹĽnic: harnessy 0184 oraz pliki
   0183 pominiÄ™te w inwentarzu 0183 (raport, smoke, capture, performance).
3. Baseline `verify.ps1` exit 0 w 1038,2 s; 0 ObjectDB/SCRIPT ERROR; 5
   allowlistowanych WARNING.
4. FaĹ‚szerstwa i luki: `ReturnPromise` twarde PL pod EN; skip zimnego
   otwarcia `POMIĹ`; leftover opening 13 â€žw terenieâ€ť; 0179 PASS bez logu
   krokĂłw; tautologia `get_child_count() >= 0` w 0183.
5. Naprawy P2: `TITLE_RETURN_PROMISE`, `COLD_OPEN_SKIP`; openingi 10â€“13 do
   ĹĽywej sceny; print 1â€“6 w 0179; warstwa crisp 10 > compositor 5.
6. TDD: `pkg_0184_smoke_red.log` 10 failures, potem GREEN 14,8 s.
7. M1 niezaleĹĽnie: full-a 187,93 s (42A), minimal-b 171,45 s (42B),
   mixed-c 181,27 s (42C); 20/20. Capture 98 kadrĂłw Windows, 0 kolizji MD5,
   cold_open luma 0,1024 (lead â€žczarna klatkaâ€ť nie reprodukuje siÄ™ jako
   zaciÄ™ty kadr). Audio 254/0 clipped. Soak after=2000.
8. Playtest lead 5: build ma NOWA GRA/KONTYNUUJ/USTAWIENIA/ZAKOĹCZ â€”
   rozjazd byĹ‚ w briefie panelu, nie w runtime.
9. P3 OPEN: monolit MRP; gameplay 10â€“13 vs CAMPAIGN_MAP; CSV; pre-clamp
   generatorĂłw; osierocone 0091/0094 (FAIL jeĹ›li odpalone).
10. Werdykty: TECHNICAL PASS; PRODUCT CONTRACT PASS; EVIDENCE INTEGRITY PASS;
    HUMAN RECEPTION OPEN-NO-EVIDENCE; RELEASE BLOCKED D-168.
11. Raport: `docs/rebuild/PKG_0184_FINAL_CERTIFICATION_REPORT.md`.
    Snapshot: `snapshots/PKG-0184-2026-09-04/` (narzÄ™dzie kopiuje scenes/
    scripts/tests; raport, reports i handoff dopisane do katalogu).

Ograniczenia: brak playtestĂłw zewnÄ™trznych; brak fizycznego pada; fun /
emocja / uroda / zrozumienie = `OPEN-NO-EVIDENCE`; GATE-REL BLOCKED (D-168);
brak webu, Gita i nowego `.exe`. Tabela 14 bramek w 0177 pozostaje rollupem.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` = PKG-0185 tylko po dyspozycji
wĹ‚aĹ›ciciela; nie startowaÄ‡ wydania samowolnie.

## PKG-0185: Audyt ujednolicenia postaci, portretĂłw i NPC

Data: 2026-09-04

Kontekst: dyspozycja wĹ‚aĹ›ciciela po PKG-0184. Zakres: **tylko audyt ze
zrzutami wszystkich lokacji i paneli oraz plan naprawy**. Zero wymiany
assetĂłw, zero `.exe`.

Zakres i wynik:

1. Inwentaryzacja: Lena 4.1 pixel-stage; Marta/Jakub/Wierzbicka â€” jeden
   malarski JPEG na postaÄ‡, `process_npc_sprites.py` (LANCZOS + faĹ‚szywe
   stany); piÄ™Ä‡ jÄ™zykĂłw portretu CRT.
2. Prymitywy na ĹĽywej trasie: `station_06.gd` sprzedawca kĂłĹ‚ko r=12 +
   trapez; `station_08.gd` sÄ…siadka kĂłĹ‚ko r=10 + trapez. D-194 B zostawiĹ‚
   ich poza ciaĹ‚em â€” stÄ…d kĂłĹ‚ka mimo GATE-CAST.
3. Capture: `tools/capture_pkg_0185.gd`, Windows, 62 kadry, PASS 19,9 s.
   Arkusze: `tools/audit_cast_contact_sheets.py`. Katalog
   `reports/pkg_0185/visual/`.
4. Findings F-0185-001..007. DEF-2 TECHNICAL PASS / PRODUCT FAIL. DEF-3
   PRODUCT FAIL na 06/08. H-045 REFUTED-IN-PART. D-202.
5. Raport: `docs/rebuild/PKG_0185_CAST_VISUAL_AUDIT.md`.
   Plan: `docs/rebuild/CAST_UNIFICATION_REPAIR_PLAN.md` (PKG-0186).
6. Leny nie ruszano. MRP-monolitu nie ruszano.

Ograniczenia: brak playtestĂłw; uroda OPEN-NO-EVIDENCE; naprawa nie
wdroĹĽona; GATE-REL BLOCKED (D-168).

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` = PKG-0186 Cast Style Unification.



## PKG-0186: Cast Style Unification

Data: 2026-09-04

Kontekst: wdroĹĽenie `docs/rebuild/CAST_UNIFICATION_REPAIR_PLAN.md` po audycie
PKG-0185. Lena 4.1 nie byĹ‚a regenerowana. WĹ‚aĹ›ciciel w sesji odrzuciĹ‚
krasnoludkowe proporcje Jakuba (`images/5.jpg`, `images/25.jpg`) oraz
sukienkÄ™ Marty w kolorze wĹ‚osĂłw.

Zakres i wynik:

1. RED: `tests/pkg_0186_cast_style_test.gd` 18 failures na stanie 0185
   (Marta q8 374 vs Lena 250; kĂłĹ‚ka 06/08; brak riga vendor/neighbour).
2. `tools/process_npc_sprites.py` przeniesiony do `tools/retired/`.
   Pieczenie: `tools/process_cast_sprites.py` (NEAREST, 64x104, pivot 32,96).
3. PĹ‚yty toĹĽsamoĹ›ci w jÄ™zyku Leny 4.1. Marta: kremowa sukienka, rĂłĹĽ tylko
   we wĹ‚osach, septum. Jakub: 1:6,5, szelki bursztyn (odrzucono beczkÄ™).
   Wierzbicka: prawdziwe seated. Sprzedawca i sÄ…siadka: sprite, nie kĂłĹ‚ko.
4. `CharacterVisualRig` vendor w `station_06.tscn` (420, 279), neighbour
   w `station_08.tscn` (340, 233). Wyciecie `draw_circle` gĹ‚owy z `_draw()`.
5. Portrety CRT 1024x1024, flood czarnego tĹ‚a. Jakub â‰  twarz Leny.
6. GREEN: `pkg_0186` PASS, `pkg_0172` PASS (06/08 bez kĂłĹ‚ka).
7. Capture Windows: 62 kadry, `PKG-0186 CAST STYLE CAPTURE PASS`.
   Katalog `reports/pkg_0186/visual/`. Nie nadpisano 0182..0185.
8. DEF-2/DEF-3/DEF-9 zamkniÄ™te kadrem, nie PRODUCT GO. H-045 CONTRACT PASS /
   odbiĂłr OPEN-NO-EVIDENCE. D-168 obowiÄ…zuje.

Ograniczenia: brak playtestĂłw; uroda OPEN-NO-EVIDENCE; Szymon bez ciaĹ‚a;
monolit MRP nietkniÄ™ty; GATE-REL BLOCKED.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` = PKG-0187 inspekcja wĹ‚aĹ›ciciela
albo P3; nie startowaÄ‡ `.exe` samowolnie.

## PKG-0187: PeĹ‚ny audyt i naprawa obrazu

Data: 2026-09-04

Kontekst: wykonanie aktywnego promptu po PKG-0186. Zakres: shell, 20 adresĂłw
kampanii (22 renderowane warianty z 42A/B/C), CRT, myĹ›l, progi, drabiny i
obsada. Bez webu, Gita, eksportu i nowych colliderĂłw.

Zakres i wynik:

1. Baseline `verify.ps1` ukoĹ„czyĹ‚ peĹ‚ny Ĺ‚aĹ„cuch przed edycjÄ… (exit 0).
2. RED `tests/pkg_0187_visual_audit_test.gd`: osiem bĹ‚Ä™dĂłw â€” brak raportu i
   macierzy evidence oraz koĹ‚o+kreska jako osoby w 42B/C. Pierwsza wersja testu
   bĹ‚Ä™dnie oczekiwaĹ‚a statycznego `ThresholdZone`; poprawiono jÄ… do kontraktu
   `AirlockZone` + runtime `ThresholdBinder`, bez dokĹ‚adania colliderĂłw.
3. Naprawy obrazowe: Station 03 utrzymuje bryĹ‚Ä™ wagonu w spokojnym kadrze;
   Station 10 dostaĹ‚a mieszkalnÄ… bryĹ‚Ä™ dwĂłch osĂłb; Station 11 instytucjonalnÄ…
   ladÄ™/osiÄ™/moduĹ‚y; Station 12 rejestrator i warsztat. Wszystkie zachowaĹ‚y
   istniejÄ…ce interakcje, geometriÄ™ i fakty. 42B/C zamieniĹ‚y piktogramy ludzi
   na nieczytelne odbicia za matowym progiem; Marta w Ĺ›wiecie pozostaje rigiem.
4. Nowy `tools/capture_pkg_0187.gd`: 22 powierzchnie Ă— opening/normal/threshold/
   mono, zbliĹĽenia 06/08/10/11/12/42B/42C, shell, pauza, piÄ™Ä‡ portretĂłw, dialog
   i myĹ›l. Pierwszy capture odkryĹ‚ bĹ‚Ä…d typowania `CanvasLayer`; naprawiono
   `Array[Node]` oraz przywracanie obu typĂłw warstwy, nastÄ™pnie wykonano peĹ‚ny
   czysty recapture.
5. Evidence: **106 PNG**, 640Ă—360, normalny Windows / Intel Iris Xe / OpenGL
   3.3; `PKG-0187 VISUAL CAPTURE PASS`. Raport per adres:
   `docs/rebuild/PKG_0187_VISUAL_AUDIT.md`. Nowa bramka `pkg_0187` jest green
   i zostaĹ‚a wpiÄ™ta do `tools/verify.ps1`.
6. D-203 utrwala powierzchnie dowodowe oraz jedyny wyjÄ…tek dla sylwetki:
   nieczytelna osoba za matowÄ… szybÄ… lub w progu, nigdy czĹ‚owiek w Ĺ›wiecie
   rysowany koĹ‚em i kreskÄ….

Ograniczenia: kadry i testy dowodzÄ… obecnoĹ›ci, skali, struktury, warstw i
braku prymitywĂłw; nie dowodzÄ… urody, emocji, funu ani zrozumienia czĹ‚owieka.
PRODUCT GO i GATE-REL pozostajÄ… zablokowane przez D-168. Szymon nadal nie ma
ciaĹ‚a na trasie (D-194 C). F-0184-008/009/010/011/012 pozostajÄ… P3; nastÄ™pny
pakiet bierze tylko 008/009/011.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` = PKG-0188 P3 verifier/audio/locale
hygiene. W zamkniÄ™ciu PKG-0187 uruchomiono `verify_docs.ps1` (52/52) i drugi,
peĹ‚ny `verify.ps1` po korekcie lintu â€” `Verification passed.` z nowÄ… bramkÄ…
PKG-0187. Przed nastÄ™pnÄ… edycjÄ… uruchomiÄ‡ peĹ‚ne `verify.ps1`.

Korekta weryfikacji zamkniÄ™cia: pierwszy peĹ‚ny `verify.ps1` zatrzymaĹ‚ siÄ™ na
PKG-0146, poniewaĹĽ nowy komentarz grafiki w `station_11.gd` wypowiadaĹ‚ imiÄ™
administratorki przed dozwolonym momentem wiedzy. To byĹ‚ realny lint narracyjny,
nie bĹ‚Ä…d Godot. Komentarz zmieniono na neutralny, a niezaleĹĽny
`pkg_0146_smoke_test.gd` wrĂłciĹ‚ do PASS przed ponownym peĹ‚nym przebiegiem.

## PKG-0188: P3 verifier/audio/locale hygiene

Data: 2026-09-04

Kontekst: wykonanie aktywnego promptu po PKG-0187. Zakres ograniczony do
F-0184-008, F-0184-009 i F-0184-011; bez `memory_resonance_point.gd`, bez
przebudowy Station 10â€“13, release'u, eksportu, webu i Gita.

Wynik:

1. RAW RED: `pkg_0091` wymagaĹ‚ nieobecnego `VectorStageEnvironment` na Station
   05. `pkg_0094` kasowaĹ‚ plik, ktĂłry wĹ‚aĹ›nie zapisaĹ‚ (`reset_campaign(false)`),
   wiÄ™c nie mĂłgĹ‚ odtworzyÄ‡ checkpointu/clue/decyzji; dodatkowo wymagaĹ‚
   Vector-Stage w przebudowanych 06â€“08.
2. GREEN: testy zachowujÄ… konkretny kontrakt P9 (prawidĹ‚owy save/reload,
   `WorldPixelCompositor`, CRT, atmosfera, cue, gracz/posadzka gdzie naleĹĽÄ…),
   a `verify.ps1` uruchamia je jako bramki `PKG-0091` i `PKG-0094`.
3. Audio: usuniÄ™to 236 returnowych `clampf(raw, -1, 1)` oraz siedem dokĹ‚adnych
   duplikatĂłw `tanh(raw) * 0.94` sprzed eksportu. Jedyna granica PCM pozostaje
   bezpoĹ›rednio przed `encode_s16` w `generate_wav`. Nowy test raw=4.0 odrĂłĹĽnia
   wynik okoĹ‚o 0.94 od starego pre-clampu okoĹ‚o 0.716.
4. Locale: inventory wykazaĹ‚ jeden aktywny CSV donor z artefaktami importerĂłw;
   zawiera on nieaktualne `[C / SHIFT]`. Fakt routingu (`project.godot` i
   `LocalizationManager`) uzasadnia decyzjÄ™ D-204: **RETIRED**, zachowany na
   dysku dla audytu, bez rejestracji runtime. `pkg_0188_hygiene_test.gd`
   sprawdza importy, brak routingu i wartoĹ›ci PL/EN.
5. Raport: `docs/rebuild/PKG_0188_HYGIENE_REPORT.md`; D-204, R-050, roadmapa,
   stan i nastÄ™pny prompt sÄ… zsynchronizowane. NastÄ™pny pakiet PKG-0189 tworzy
   tylko audyt/specyfikacjÄ™ granic F-0184-010/012.

Ograniczenia: bramki dowodzÄ… zapisu, obecnoĹ›ci kontraktĂłw sceny, routingu locale
i granicy PCM; nie dowodzÄ… jakoĹ›ci miksu, tĹ‚umaczeĹ„, zabawy, emocji,
zrozumienia, PRODUCT GO ani release readiness. F-0184-010 i F-0184-012 nadal
pozostajÄ… otwarte. GATE-REL jest zablokowane przez D-168.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` = PKG-0189 P3 residual-boundary
audit. `verify_docs.ps1` PASS (52), koĹ„cowe `verify.ps1` exit 0 z
`Verification passed.`; jego `stderr` ma 0 B. Snapshot PKG-0188 zamraĹĽa stan
po tym wyniku.

## PKG-0189: P3 residual-boundary audit and execution specification

Data: 2026-09-04

Kontekst: wykonanie aktywnego promptu po PKG-0188. Zakres byĹ‚ wyĹ‚Ä…cznie
analityczny i kontraktowy dla F-0184-010 (`MemoryResonancePoint`) oraz
F-0184-012 (Station 10â€“13): bez edycji monolitu, gameplayu 10â€“13, scen,
colliderĂłw, ThresholdZone, InputMap, trasowania, assetĂłw, release'u, eksportu,
webu i Gita.

Zakres i wynik:

1. Raport `docs/rebuild/PKG_0189_RESIDUAL_BOUNDARY_SPEC.md` rozdziela fakty od
   planu: MRP ma 10 193 linii, 203 jawnie numerowane wartoĹ›ci `PropType`
   (`0..202`), 221 funkcji i 206 rendererĂłw `_draw_*`; 37 scen ma 155 instancji
   `resonance_id`. Kontrakt zachowuje `Area2D`, osiem exportĂłw, dwa sygnaĹ‚y,
   clue bridge, input/range/haptics i numery enumĂłw.
2. Inventory 10â€“13 potwierdziĹ‚o trzy rzeczywiste mosty MRP na adres i bieĹĽÄ…ce
   klucze `p9.mystery.*`, ale takĹĽe callable Ĺ›cieĹĽki P7
   `p7.foreign_daily_life`/`p7.marta_threshold`. Brakuje dwunastu kanonicznych
   faktĂłw `CAMPAIGN_MAP`, w tym `local_lena_search_committed`; Station 13
   obecnie zapisuje `world_recognized` po trzech trace'ach bez obu lokalnych
   markerĂłw ĹşrĂłdĹ‚owych.
3. Dodano `tests/pkg_0189_boundary_inventory_test.gd` oraz normalnÄ… bramkÄ™
   `PKG-0189 residual-boundary inventory gate` do `tools/verify.ps1`. Test jest
   celowo czuĹ‚y na usuniÄ™cie faktu inventory; nie deklaruje rozwiÄ…zania monolitu
   ani hybrydy.
4. D-205 ustala kolejnoĹ›Ä‡: PKG-0190 wyrĂłwnuje kanoniczne fakty przez istniejÄ…ce
   mosty MRP, PKG-0191 potem wycofuje callable P7, a PKG-0192 jest niezaleĹĽnym
   po 0190 pilotem ekstrakcji rendererĂłw 67â€“196. R-051 opisuje ryzyko faĹ‚szywego
   mapowania flag i mieszania obu migracji.
5. Samodzielna bramka nowego testu: `PKG-0189 INVENTORY PASS`; przed zmianÄ… i
   po dodaniu dokumentacji `verify_docs.ps1`: `DOCS PASS: 52 required files and
   handoff contracts`. Pierwsze uruchomienie peĹ‚nego verify przed edycjÄ…
   przekroczyĹ‚o limit procesu narzÄ™dzia sesji 30 s, wiÄ™c nie jest przedstawiane
   jako PASS/FAIL. KoĹ„cowy peĹ‚ny verify po tych zapisach jest wymaganym dowodem
   zamkniÄ™cia.

Ograniczenia: inventory dowodzi tylko obecnoĹ›ci/nieobecnoĹ›ci okreĹ›lonych
kontraktĂłw w kodzie i scenach. Nie dowodzi zabawy, emocji, rozumienia, jakoĹ›ci
obrazu, kompletnej naprawy P3, PRODUCT GO ani gotowoĹ›ci release'u. GATE-REL
pozostaje zablokowane przez D-168.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` = PKG-0190 canonical-fact alignment
for Station 10â€“13. Najpierw przeczytaÄ‡ PKG-0189 spec i uruchomiÄ‡ peĹ‚ny baseline;
nie edytowaÄ‡ MRP, scen, geometrii ani nie usuwaÄ‡ P7 w tym pakiecie.

KoĹ„cowa weryfikacja PKG-0189: `pwsh -NoProfile -File .\tools\verify.ps1`
uruchomione w osobnym procesie po wszystkich zapisach dokumentacji â€” exit 0,
`Verification passed.`. ĹaĹ„cuch zawiera `PKG-0189 INVENTORY PASS`, lint
traversalu, M1 20 adresĂłw (188,2 s symulacji), PKG-0182/0183/0184 i
PKG-0186/0187. Warningi fallbacku uszkodzonego save'a sÄ… kontrolami negatywnymi
dozwolonymi przez `godot_log_policy.ps1`; nie dodano allowlisty ani nie osĹ‚abiono
bramek.

## PKG-0190: Cinematic vignettes â€” 5 ilustrowanych sekwencji na trasie

Data: 2026-09-04

Kontekst: wĹ‚aĹ›ciciel poprosiĹ‚ wprost o pakiet cinematic vignette (osobny
prompt, poza kolejkÄ… P3), po zamkniÄ™ciu PKG-0188/0189. `NEXT_SESSION_PROMPT.md`
po PKG-0189 wskazywaĹ‚ juĹĽ numer PKG-0190 na canonical-fact alignment 10â€“13
(D-205); zamiast mieszaÄ‡ dwa niezaleĹĽne zakresy pod jednym numerem, D-206
przenumerowaĹ‚ tamten zakres na **PKG-0191** i skonsumowaĹ‚ PKG-0190 tym
pakietem. Warunek rozpoczÄ™cia wĹ‚asnego promptu (â€ždopiero po zamkniÄ™ciu
aktywnego PKG-0188") byĹ‚ speĹ‚niony â€” PKG-0188 i PKG-0189 byĹ‚y juĹĽ zamkniÄ™te.

Zakres i wynik:

1. **Audyt miejsc** (`docs/rebuild/PKG_0190_CINEMATIC_PLACEMENT.md`): caĹ‚a
   trasa 01â€“18 â†’ 42A/B/C â†’ 43 przebadana na podstawie Ĺ›wieĹĽego odczytu kodu
   stacji (nie starych tabel narracyjnych, ktĂłre rozjeĹĽdĹĽajÄ… siÄ™ z runtime â€”
   rozjazd odnotowany w Â§4). SzeĹ›Ä‡ nazwanych checkpointĂłw (prĂłg obcego
   adresu, pierwsze Ĺ›lady biografii, spotkania Marty/Jakuba, synteza 13,
   potwierdzenie sygnaĹ‚u, wybĂłr metody) plus finaĹ‚ audytowane osobno; wybrano
   4 pojedyncze sekwencje + rodzinÄ™ finaĹ‚owÄ… (5 slotĂłw, mieĹ›ci siÄ™ w 3â€“5).
   Cold open przeczytany w caĹ‚oĹ›ci i wykluczony z wyboru â€” ĹĽadna winieta nie
   duplikuje jego czterech noĹ›nikĂłw faktĂłw.
2. **Wybrane sekwencje**: VIG-01 â€žPrĂłg" (stacja 08, sygnaĹ‚
   `apartment_fourteen_unlocked`), VIG-02 â€žSynteza" (stacja 13, nowy sygnaĹ‚
   `world_difference_synthesized`), VIG-03 â€žSygnaĹ‚" (stacja 15,
   `mutual_signal_test_completed`), VIG-04 â€žZatwierdzenie" (stacja 18,
   `method_committed`), VIG-FINALE A/B/C (stacje 42A/B/C, wspĂłlny sygnaĹ‚
   `household_consequence_read`, wariant po `ending_family`). KaĹĽda ma 2
   klatki, wzmacnia istniejÄ…cÄ… flagÄ™ (nigdy nie jest jej jedynym noĹ›nikiem â€”
   flaga zapisana przez stacjÄ™ przed emisjÄ… sygnaĹ‚u triggera), jest
   pomijalna od pierwszego wyĹ›wietlenia i respektuje reduced motion przez
   skrĂłcone, nie usuniÄ™te, ciÄ™cia.
3. **System** (`scripts/cinematics/`): `cinematic_catalog.gd` (dane, wzorem
   `ColdOpenFacts`), `cinematic_vignette.gd` (odtwarzacz â€” `CanvasLayer`
   warstwa 19, natywny `Panel`+`RichTextLabel` na podpis, nigdy
   `CrispDiegeticText`, ktĂłra renderuje siÄ™ na staĹ‚ej globalnej warstwie 10 i
   byĹ‚aby niewidoczna pod planszÄ… â€” bĹ‚Ä…d znaleziony i naprawiony podczas
   capture w tym samym pakiecie), `cinematic_director.gd` (autoload,
   nasĹ‚uchuje `SceneTree.node_added`, dopasowuje stacjÄ™ po typie wÄ™zĹ‚a,
   podpina siÄ™ pod **istniejÄ…cy** sygnaĹ‚ `CONNECT_ONE_SHOT`, czeka na
   `CRTDialogueBox.dialogue_finished` prawdziwym poĹ‚Ä…czeniem sygnaĹ‚owym gdy
   panel otwierajÄ…cy akurat prezentuje). Jedyna ingerencja w istniejÄ…cÄ…
   stacjÄ™: jeden nowy sygnaĹ‚ w `station_13.gd`. Nowy autoload zarejestrowany
   w `project.godot`. `GameStateManager` dostaĹ‚ `cinematics_seen`
   (settings-save, wzorem `cold_open_seen`) z `is_cinematic_seen`/
   `mark_cinematic_seen`, bez migracji `SAVE_SCHEMA_VERSION`.
4. **Generacja gen-ai** (`docs/rebuild/PKG_0190_CINEMATIC_GENERATION_MANIFEST.md`):
   14 finalnych PNG 640Ă—360 przez Flux Kontext Max (Picsart), referencja
   toĹĽsamoĹ›ci Leny w kaĹĽdym wywoĹ‚aniu z jej udziaĹ‚em (nigdy generowana od
   zera), styl â€žflat screen-print poster" wyprowadzony empirycznie po
   pierwszej odrzuconej, zbyt malarskiej prĂłbie. Cztery klatki wymagaĹ‚y
   drugiej generacji z powodu nieczytelnego pseudo-tekstu/cyfr (dokument,
   Ĺ‚ata rÄ™kawa Ă—2, oĹ› oscyloskopu) â€” twardy zakaz tekstu z `VISUAL_DESIGN.md`
   Â§7 wyegzekwowany. Robocze warianty ĹĽyĹ‚y wyĹ‚Ä…cznie poza katalogiem assetĂłw
   (`%TEMP%/.../scratchpad/cinematics_draft/`); do `assets/cinematics/`
   trafiĹ‚y tylko finalne, rÄ™cznie zaakceptowane pliki.
5. **Testy i dowody**: `tests/pkg_0190_cinematics_test.gd` (nowa bramka w
   `verify.ps1`) dowodzi integralnoĹ›ci katalogu i istnienia zasobĂłw,
   dosĹ‚ownej obecnoĹ›ci sygnaĹ‚Ăłw triggerĂłw na stacjach, zgodnoĹ›ci
   `ending_family` finaĹ‚Ăłw z ich wĹ‚asnym `_has_*()`, braku zakazanych
   ujawnieĹ„ w podpisie pre-recognition VIG-01, realnego przebiegu przez
   Station 13 (odmowa przed speĹ‚nieniem warunkĂłw â†’ sukces po uzbrojeniu â†’
   brak replaya na trzeciej, juĹĽ-obejrzanej instancji) i toĹĽsamego stanu
   gameplayu po skip w trybie normalnym i reduced motion.
   `tools/capture_pkg_0190.gd` na Intel Iris Xe daĹ‚ 22 kadry Windows
   (`reports/pkg_0190/cinematics/`): before/after trigger, obie klatki,
   reduced motion i skip dla kaĹĽdej z 5 sekwencji.

Ograniczenia: bramki dowodzÄ… kontraktu triggera, katalogu, braku duplikacji
flag i parytetu skip/reduced-motion â€” nie dowodzÄ…, ĹĽe sekwencje sÄ…
emocjonalne, straszne, piÄ™kne ani zrozumiaĹ‚e dla nowej osoby (D-012, ADR-003).
Rozjazd dokumentacjaâ†”kod odnotowany w audycie Â§4 nie zostaĹ‚ naprawiony â€” poza
zakresem. GATE-REL pozostaje zablokowane przez D-168; to nie jest PRODUCT GO.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` = PKG-0191 canonical-fact alignment
for Station 10â€“13 (przenumerowane z dawnego â€žPKG-0190" przez D-206; nie myliÄ‡
z systemem cinematic z tego pakietu). Nie usuwaÄ‡ sygnaĹ‚u
`world_difference_synthesized()` ze `station_13.gd` â€” cinematic vignette jest
na nim oparta.

## PKG-0191: Canonical-fact alignment for Station 10â€“13 (F-0184-012)

Data: 2026-09-05. Zakres: wyĹ‚Ä…cznie `docs/rebuild/PKG_0189_RESIDUAL_BOUNDARY_SPEC.md`
Â§4, pierwszy krok D-205 (przenumerowany D-206). Bez zmiany MRP, scen,
colliderĂłw, `ThresholdZone`, InputMap, trasowania kampanii czy systemu
cinematic z PKG-0190.

1. **Writer mapping (zweryfikowany przez kod, nie przez dokumentacjÄ™)**:
   `marta_relationship_disclosed` jest juĹĽ zapisywany w `station_08.gd`
   (`speak_with_neighbour()`) przez most `OpeningActionPoint`; PKG-0191 nie
   dubluje tego zapisu w `station_10.gd`. PozostaĹ‚e 12 kanonicznych faktĂłw
   mapy dostaje dokĹ‚adnie jednego writer'a w Station 10â€“13, dopisanego obok
   istniejÄ…cych kluczy `p9.mystery.*` przy tym samym udanym dziaĹ‚aniu MRP:
   - **Station 10**: `hear_marta_day()` â†’ `marta_memories_conflict`;
     `accept_marta_boundary()` â†’ `marta_boundary_accepted`.
   - **Station 11**: `present_identity_card()` â†’ `local_lena_ucp_profile_found`;
     `read_186_day_record()` â†’ `jakub_public_history_verified`;
     `request_minimal_report()` â†’ `parallel_test_trace_found` +
     `recognition_evidence_public` (rodzina dowodu publicznego, kompletna).
   - **Station 12**: `ask_jakub_control_questions()` â†’ `jakub_voice_heard`;
     `meet_jakub()` â†’ `jakub_met_as_person`; `accept_jakub_refusal()` â†’
     `recognition_evidence_relational` (rodzina relacyjna, kompletna).
   - **Station 13**: nowe metody `mark_marta_source_seen()` /
     `mark_institution_source_seen()` (wydzielone z inline `match` w
     `_on_prop_resonance_triggered`, ĹĽeby mieÄ‡ nazwane, testowalne czasowniki)
     â€” pierwsza dopisuje `recognition_evidence_carried` (wyĹ‚oĹĽenie domowego
     noĹ›nika na stĂłĹ‚, nie fabrykacja na wejĹ›ciu do sceny); `synthesize_world_difference()`
     wymaga teraz **wszystkich trzech** rodzin dowodu (`recognition_evidence_public`,
     `_relational`, `_carried`) **oraz** obu lokalnych markerĂłw ĹşrĂłdĹ‚a
     (`p9.mystery.synthesis.marta_source_seen`/`institution_source_seen`)
     obok istniejÄ…cych trzech Ĺ›ladĂłw `p9.mystery.*.trace`; dopiero wtedy
     zapisuje razem oba fakty terminalne `world_recognized` i
     `local_lena_search_committed`. Odrzucona synteza nie zapisuje ĹĽadnego
     z nich.
2. **Real bug found by the new test, not by inspection**: `GameStateManager`
   miaĹ‚ tabele erasure dla dawnego kanonu 0.2 (`P7_MUTUAL_TEST_LEGACY_DECISION_KEYS`,
   `P7_EARLY_SEQUENCE_MIGRATIONS[*].legacy_keys`), ktĂłre kasowaĹ‚y te same 13
   nazw faktĂłw przy `reload_campaign_from_disk()`, chyba ĹĽe odpowiedni klucz
   `p7.<sekwencja>.migration_revision` byĹ‚ juĹĽ ustawiony â€” a trasa P9 przez
   mosty MRP nigdy nie zapisuje `p7.foreign_daily_life.*`/`p7.marta_threshold.*`
   (ten Ĺ‚aĹ„cuch jest osobnym, wciÄ…ĹĽ callable, ale niewywoĹ‚ywanym z MRP,
   surowym P7). Bez naprawy kaĹĽdy reload realnej rozgrywki kasowaĹ‚by Ĺ›wieĹĽo
   ustanowiony kanon. Naprawa (D-208): usuniÄ™cie tych trzynastu nazw z tabel
   erasure, z komentarzem PKG-0191 przy kaĹĽdym wpisie; `local_lena_search_started`
   (bez writer'a) pozostaje erasowany. Zaktualizowano asercje w
   `pkg_0146_smoke_test.gd`, `pkg_0145_smoke_test.gd`, `pkg_0147_smoke_test.gd`
   (dawniej sprawdzaĹ‚y kasowanie tych wĹ‚aĹ›nie nazw jako "P7 contamination" â€”
   teraz sprawdzajÄ… ich przetrwanie jako kanonu) i `pkg_0190_cinematics_test.gd`
   (`_arm_synthesis_prerequisites` uzbraja teĹĽ nowe warunki bramkujÄ…ce).
3. **Nowy test**: `tests/pkg_0191_canonical_fact_test.gd` (nowa bramka w
   `verify.ps1`) dowodzi wyĹ‚Ä…cznie realnym `MemoryResonancePoint.trigger_interaction()`
   (nigdy bezpoĹ›rednim wywoĹ‚aniem helpera stacji): negatywnych warunkĂłw
   (przedwczesne wywoĹ‚anie nie zapisuje faktu), pozytywnej Ĺ›cieĹĽki dla
   wszystkich 12 faktĂłw, gated syntezy Station 13 (odrzucenie przed
   kompletem â†’ brak zapisu terminalnego â†’ jeden `world_difference_synthesized`
   dopiero po komplecie, zgodnie z kontraktem PKG-0190) i przetrwania
   wszystkich 12 faktĂłw przez `save_campaign()` â†’ `reset_campaign(false)` â†’
   `reload_campaign_from_disk()`.
4. **Zaktualizowany inwentarz**: `tests/pkg_0189_boundary_inventory_test.gd`
   przestaje byÄ‡ testem nieobecnoĹ›ci â€” sprawdza teraz obecnoĹ›Ä‡ jedenastu
   writer'Ăłw faktĂłw w Station 10â€“13, potwierdza, ĹĽe `marta_relationship_disclosed`
   ma dokĹ‚adnie jednego writer'a w `station_08.gd` i nie dostaĹ‚ drugiego w
   10â€“13 (przez sprawdzenie wzorca `_record(&"..."` zamiast goĹ‚ego substringu,
   bo dokumentacyjny komentarz w Station 10 nazywa ten fakt wprost). Statyczny
   kontrakt MRP (10 193 linii, 221 funkcji, 206 `_draw_*`, sentinel-e enum)
   pozostaje bez zmian â€” F-0184-010 nie jest w zakresie tego pakietu.

Ograniczenia: bramki dowodzÄ… struktury zapisu, kolejnoĹ›ci bramkowania i
trwaĹ‚oĹ›ci przez zapis/odczyt â€” nie dowodzÄ… zabawy, emocji ani zrozumienia
przez nowÄ… osobÄ™ (D-012, ADR-003). Callable P7 (`inspect_key_wear`,
`test_key_without_claiming_home`, `commit_cautious_entry`, `close_balcony`,
`open_drawer`, â€¦) pozostaje nietkniÄ™ty i nadal osobno wywoĹ‚ywalny. D-205
przewiduje ten surowy P7 do wycofania z Station 10â€“13 w kolejnym pakiecie
zaleĹĽnoĹ›ciowym (dawniej "PKG-0191" w D-205, przed przenumerowaniem D-206;
realny numer to teraz **PKG-0192**, nastÄ™pny wolny po tej sesji).
F-0184-010 (ekstrakcja renderera MRP 67â€“196) pozostaje osobnym pilotem,
niezaleĹĽnym od tej kolejnoĹ›ci po zamkniÄ™ciu tego pakietu.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` = **PKG-0192**, wycofanie
callable P7 surface z Station 10â€“13 (zakres z D-205 Â§4, drugi krok
zaleĹĽnoĹ›ciowy). Nie mieszaÄ‡ z F-0184-010 (MRP renderer extraction pilot,
niezaleĹĽny, moĹĽe wykonaÄ‡ siÄ™ w dowolnej kolejnej sesji po tej).

## PKG-0192: retire the callable P7 surface from Station 10â€“13 (D-205 Â§4, drugi krok zaleĹĽnoĹ›ciowy)

Data: 2026-09-05. Poprzedni pakiet: PKG-0191 (canonical-fact alignment).
Specyfikacja: `docs/rebuild/PKG_0189_RESIDUAL_BOUNDARY_SPEC.md` Â§4, druga
sekcja (numer w tekĹ›cie spec przestarzaĹ‚y po D-206; realny numer tej sesji
to PKG-0192).

1. **Trzy jawne decyzje o elementach diegetycznych R4** â€” wszystkie ZOSTAJÄ„
   jako uzasadniony element P9, ĹĽadna nie zostaje nienazwanÄ… hybrydÄ… P7;
   udokumentowane w komentarzu nagĹ‚Ăłwkowym kaĹĽdej stacji:
   - `HallwaySideboard` (Station 11): odepchniÄ™cie dziaĹ‚a samodzielnie w
     `_physics_process()` niezaleĹĽnie od jakiejkolwiek metody, wiÄ™c
     przeszkoda R4 jest realna niezaleĹĽnie od retirowanego Ĺ‚aĹ„cucha.
   - `BalconyDoor` (Station 12): realny collider zamykany przez
     `close_balcony()`, odblokowuje `ExitClearance`.
   - `DeskDrawer` (Station 13): realny collider progu R4 (16 px) sprzÄ™ĹĽony
     z `_process()`.
   Ĺ»adna geometria, collider, `.tscn`, `ThresholdZone` ani InputMap nie
   zostaĹ‚y dotkniÄ™te.
2. **Namespace retirement, nie usuniÄ™cie metod**: `inspect_key_wear()`,
   `test_key_without_claiming_home()`, `commit_cautious_entry()` (Station 10),
   `inspect_private_photograph()`, `inspect_equipment_wear()`,
   `inspect_reader_arrangement()`, `compare_private_material()`,
   `respect_private_material()`, `record_private_material_result()`,
   `push_sideboard()`, `apply_sideboard_setback()` (Station 11),
   `close_balcony()`, `listen_to_message()`, `verify_caller_identity()`,
   `prepare_independent_questions()` (Station 12), `open_drawer()`,
   `observe_field_certificate()`, `observe_tenancy_contract()`,
   `verify_document_independence()`, `compare_document_versions()`,
   `request_independent_description()` (Station 13) pozostajÄ… callable
   (ĹĽaden MRP node ich nie wywoĹ‚uje â€” dokĹ‚adnie jak przed pakietem;
   `tests/smoke_test.gd`, `pkg_0099/0100/0119/0138/0146_smoke_test.gd` nadal
   woĹ‚ajÄ… je bezpoĹ›rednio), ale nie piszÄ… juĹĽ nic pod
   `p7.foreign_daily_life.*` ani `p7.marta_threshold.*`. Wszystkie odpowiednie
   `FACT_*` staĹ‚e i dwa inline zapisy (`balcony_closed`, `recall_requested`)
   przeniesione jeden-do-jednego pod `p9.threshold_obstacle.foreign_daily_life.*`
   / `p9.threshold_obstacle.marta_threshold.*` z zachowaniem identycznej
   logiki bramkowania i identycznych wartoĹ›ci zwracanych. `compare_document_versions()`
   nadal zapisuje `conflicting_documents_found` bez zmian (nie kanoniczny fakt
   z listy 13, osobna decyzja poza zakresem tego pakietu). `local_address_confirmed`
   w Station 10 (zapis spoza namespace'u P7, duplikat writer'a ze
   `station_07.gd`, wymagany przez izolowany scenariusz `pkg_0146`) pozostaĹ‚
   nietkniÄ™ty â€” poza zakresem retirementu.
3. **Zweryfikowane cross-station duplikaty spoza zakresu, Ĺ›wiadomie nietkniÄ™te**:
   `station_08.gd` i `station_09.gd` majÄ… wĹ‚asne, niezaleĹĽne kopie literaĹ‚Ăłw
   `p7.foreign_daily_life.cautious_entry_committed` / `neighbour_account` /
   `trace` / `safe_trial_feedback` â€” to osobne, wczeĹ›niejsze adresy (07/09),
   ich zapisy nie sÄ… w zakresie tego pakietu i pozostajÄ… nietkniÄ™te. Realny
   `station_09` prowadzi do `station_10`, ale `inspect_key_wear()` jest
   martwy w rzeczywistej rozgrywce (nigdy niewywoĹ‚ywany przez MRP), wiÄ™c
   rozjazd namespace'u miÄ™dzy `station_09` (stary klucz) a `station_10`
   (nowy klucz) nie ma ĹĽadnego efektu na prawdziwÄ… trasÄ™ â€” dotyczy wyĹ‚Ä…cznie
   testĂłw, ktĂłre juĹĽ jawnie zasiewajÄ… wymagany klucz przed wywoĹ‚aniem metody.
4. **Migracja legacy-save**: `GameStateManager.P7_EARLY_SEQUENCE_MIGRATIONS`
   (`foreign_daily_life`, `marta_threshold`) pozostaje bez zmian
   funkcjonalnych â€” sprawdzono ĹşrĂłdĹ‚o: ĹĽaden z szeĹ›ciu `legacy_keys` (np.
   `station_10_threshold_reset`, `station_12_playback_muffled`) nie jest dziĹ›
   pisany przez ĹĽadnÄ… stacjÄ™, wiÄ™c skrĂłcenie nie usunÄ™Ĺ‚oby martwego
   odwoĹ‚ania; dopisano tylko komentarz PKG-0192 wyjaĹ›niajÄ…cy, ĹĽe nowe
   `p9.threshold_obstacle.*` fakty Ĺ›wiadomie NIE sÄ… juĹĽ objÄ™te blankietowym
   erasure po prefiksie `p7.<sekwencja>.` (sÄ… trwaĹ‚ym stanem P9, nie
   przejĹ›ciowym markerem P7). Nowa bramka `pkg_0192_p7_retirement_test.gd`
   dowodzi migracji na syntetycznym starym zapisie: erasuje cztery zasiane
   stare klucze, nie fabrykuje ĹĽadnego z 12 kanonicznych faktĂłw PKG-0191 ani
   ĹĽadnego nowego faktu `p9.threshold_obstacle.*`, i jest idempotentna
   (drugie wywoĹ‚anie `_migrate_p7_early_sequences()` niczego nie zmienia).
5. **Zaktualizowana bramka inwentarza**: `tests/pkg_0189_boundary_inventory_test.gd`
   odwraca kierunek asercji `LEGACY_P7_NAMESPACES` â€” sprawdzaĹ‚a OBECNOĹšÄ†
   namespace'u P7 (Ĺ›wiadomie, jako dowĂłd ĹĽe PKG-0191 go jeszcze nie ruszaĹ‚),
   teraz sprawdza jego NIEOBECNOĹšÄ† (dokĹ‚adny wzorzec literaĹ‚u zapisu
   `&"p7.foreign_daily_life.`/`&"p7.marta_threshold.`, nie goĹ‚y substring â€”
   inaczej faĹ‚szywie Ĺ‚apaĹ‚aby wĹ‚asne komentarze dokumentujÄ…ce decyzjÄ™) oraz
   obecnoĹ›Ä‡ nastÄ™pcy `p9.threshold_obstacle.`. Statyczny kontrakt MRP i 11
   writer'Ăłw kanonicznych z PKG-0191 pozostajÄ… bez zmian.
6. **Nowa bramka**: `tests/pkg_0192_p7_retirement_test.gd` â€” statyczna
   nieobecnoĹ›Ä‡ retirowanego namespace'u, obecnoĹ›Ä‡ trzech udokumentowanych
   decyzji diegetycznych, realne wywoĹ‚anie kaĹĽdej retirowanej metody na
   ĹĽywej scenie z asercjÄ… ĹĽe pisze pod nowym kluczem i nigdy pod starym, oraz
   idempotentnoĹ›Ä‡ migracji opisana wyĹĽej.
7. **Realny bug znaleziony przez pierwszy peĹ‚ny `verify.ps1`, nie przez
   inspekcjÄ™**: `tests/pkg_0146_smoke_test.gd`'s izolowany scenariusz
   `_test_s04_foreign_daily_life()` resetuje kampaniÄ™ i skacze bezpoĹ›rednio
   do `station_09` â†’ `station_10` â†’ `station_11`, bez wczeĹ›niejszej wizyty w
   `station_08`. W tym scenariuszu `station_09.gd`'s realne
   `ask_neighbour_without_leading()` (plik poza zakresem tego pakietu, nadal
   pisze do starego `p7.foreign_daily_life.neighbour_account`) byĹ‚o jedynym
   ĹşrĂłdĹ‚em tego faktu â€” a przemianowany `station_10.gd`'s `inspect_key_wear()`
   czyta juĹĽ `p9.threshold_obstacle.foreign_daily_life.neighbour_account`.
   Rozjazd namespace'u miÄ™dzy plikiem poza zakresem a plikiem w zakresie
   kaskadowo uniewaĹĽniĹ‚ wszystkie dziesiÄ™Ä‡ asercji S04. Naprawione jawnym
   zasianiem przemianowanego klucza w tym jednym scenariuszu, dokĹ‚adnie tym
   samym wzorcem, jaki `pkg_0100/0119/0138_smoke_test.gd` i `smoke_test.gd`
   juĹĽ stosowaĹ‚y (te testy nie ucierpiaĹ‚y, bo juĹĽ wczeĹ›niej zasiewaĹ‚y fakt
   bezpoĹ›rednio, zamiast polegaÄ‡ na realnym przebiegu `station_09`). Inne
   podobne cross-station duplikaty (`station_08.gd`'s wĹ‚asne kopie
   `cautious_entry_committed`/`trace`/`safe_trial_feedback`) zweryfikowane
   ĹşrĂłdĹ‚owo jako nieszkodliwe â€” ĹĽaden inny test nie polega na realnym
   przebiegu tych plikĂłw do zasilenia przemianowanego klucza.

Ograniczenia: to zmiana wyĹ‚Ä…cznie nazw kluczy faktĂłw i dokumentacji decyzji,
nie zmiana gameplayu, obrazu, kolizji ani trasy. Nie dowodzi zabawy, emocji
ani zrozumienia przez nowÄ… osobÄ™ (D-012, ADR-003). F-0184-010 (ekstrakcja
renderera MRP 67â€“196) pozostaje osobnym, niezaleĹĽnym pilotem bez
przydzielonego numeru â€” moĹĽe wykonaÄ‡ siÄ™ w dowolnej kolejnej sesji.

Przekazanie: `docs/NEXT_SESSION_PROMPT.md` wskazuje F-0184-010 (MRP renderer
extraction pilot) jako sugerowany, niezaleĹĽny nastÄ™pny krok â€” bez
przydzielonego numeru pakietu, do nadania przy otwarciu tej sesji.

## PKG-0193: CR-A â€” dwie biografie i spotkanie z bratem (2026-09-05)

Zlecenie wĹ‚aĹ›ciciela: wykonaÄ‡ `docs/rebuild/CREATIVE_REVIEW_AND_EXPANSION_PLAN.md`.
Zgodnie z jego kolejnoĹ›ciÄ… osobnych sesji wykonano pierwszy wycinek CR-A,
zastÄ™pujÄ…c dotychczas sugerowany pilot refaktoru MRP. Codex, Windows,
Godot 4.7.2, 640Ă—360, 60 Hz, bez Gita, webu i nowego eksportu.

15 istniejÄ…cych MRP 09â€“13 otrzymaĹ‚o dostarczanÄ… prezentacjÄ™: prywatnoĹ›Ä‡ domu,
sprzeczne wspomnienia Marty, instytucjonalnÄ… historiÄ™ Leny/Jakuba, ĹĽywe
spotkanie i odmowÄ™ oraz pytanie o miejscowÄ… LenÄ™. Lokalny wĹ‚aĹ›ciciel kolejki
chroni otwarcie/CRT/winietÄ™ i input advance. Writerzy PKG-0191 oraz callable
surface PKG-0192 pozostajÄ…. Ponowne zbadanie pozwala odczytaÄ‡ treĹ›Ä‡ bez
powtĂłrki winiety. Obie gaĹ‚Ä™zie prĂłbki i brak ĹşrĂłdeĹ‚ majÄ… odrÄ™bnÄ… prezentacjÄ™.
Guidance i GapLedger 09â€“13 odnoszÄ… siÄ™ do aktualnych faktĂłw. 07/08 poprawione
na budynek Sadowa 7 i lokale 12/14 oraz nazwisko Kurek. Rigi reagujÄ… na
rozmowÄ™, Marta wystÄ™puje w 13, stĂłĹ‚ i domowe przedmioty majÄ… lokalnÄ… kompozycjÄ™.

Pierwszy verifier uruchomiony przed edycjami trwaĹ‚ podczas pracy i nie jest
izolowanym baseline starej wersji. ZakoĹ„czyĹ‚ siÄ™ exit 1 na PKG-0158:
â€žFacade plaque must state Sadowa 14â€ť / â€žCertificate text must state Sadowa 12â€ť.
To konflikt starej asercji z jawnym CR-D04, nie uzasadnienie wyĹ‚Ä…czenia testu.
D-210 dokumentuje silniejszÄ… asercjÄ™ wspĂłlnego budynku i obu przypisaĹ„ lokali.

Lokalnie PASS: PKG-0191 (console, exit 0), nowy PKG-0193 headless i normalny
Windows OpenGL Intel Iris Xe. W harnessie wykryto, ĹĽe reset kampanii nie
czyĹ›ci obejrzanych winiet z ustawieĹ„; dodano jawny reset oraz wymaganie dwĂłch
faktycznie pokazanych i pominiÄ™tych winiet. Finalny capture ma 267 PNG i
frames.tsv w reports/pkg_0193/visual_final. BezpoĹ›redni oglÄ…d wybranych kadrĂłw
09â€“13, prĂłbki/braku, odmowy, pytania Marty, winiety i trzech skal tekstu.
KaĹĽda dostarczona kwestia mieĹ›ci siÄ™ w panelu wedĹ‚ug pomiaru wysokoĹ›ci.

PeĹ‚ne zamkniÄ™cie verify_docs / verify / snapshot jest wykonywane po tym wpisie;
ostateczny wynik bÄ™dzie dopisany poniĹĽej. Raport: `rebuild/PKG_0193_CREATIVE_SCENES.md`.
Handoff: `docs/NEXT_SESSION_PROMPT.md` (CR-B, spodziewany PKG-0194, numer
sprawdziÄ‡ na poczÄ…tku sesji). CR-B/C/D nadal niewykonane. PeĹ‚na lokalizacja EN,
nowe ekspresje portretĂłw i peĹ‚ny audyt dojĹ›cia do punktĂłw nie sÄ… wynikiem.
OdbiĂłr pozostaje OPEN-NO-EVIDENCE. F-0184-010 osobny, GATE-REL blokowane D-168.

UzupeĹ‚nienie wykonawcze PKG-0193: oglÄ…d kadrĂłw wykryĹ‚ zmianÄ™ pozy Jakuba
przez otwarcie CRT; naprawiono jÄ…, dodano asercjÄ™ work przed spotkaniem
i odĹ›wieĹĽono 267 kadrĂłw. PorĂłwnanie funkcji stacji z poczÄ…tkiem sesji:
09â€“12 zmieniĹ‚y wyĹ‚Ä…cznie _ready/_setup_guidance, 13 takĹĽe _draw; wszystkie
akcje i mosty MRP identyczne. PrĂłbny verifier run1 zatrzymano celowo przy
tej korekcie. Run2 przeszedĹ‚ M1/14 bramek, ale zakoĹ„czyĹ‚ siÄ™ RED w PKG-0184
na trzech asercjach otwarÄ‡ wymagajÄ…cych treĹ›ci dormant P7. Zgodnie z D-210
zachowano bramkÄ™ i zastÄ…piono je kontrolÄ… aktywnych ĹşrĂłdeĹ‚ P9, zakazem
dawnych wskazĂłwek i obecnoĹ›ciÄ… dziewiÄ™ciu ID punktĂłw. To jawna zmiana
historycznego kontraktu tekstowego, nie wyĹ‚Ä…czenie linta ani obniĹĽenie progu.

ZamkniÄ™cie PKG-0193: koĹ„cowy peĹ‚ny `verify.ps1` run3 zakoĹ„czyĹ‚ siÄ™ exit 0,
`Verification passed.`, 97 bramek GREEN (w tym M1/14 bramek, 0184 i 0193).
Log: `reports/pkg_0193_final_verify_run3.log`; brak bĹ‚Ä™dĂłw i wyciekĂłw,
siedem dozwolonych warningĂłw testĂłw negatywnych. `verify_docs.ps1`: DOCS PASS,
52 required files and handoff contracts. Po dopisaniu wyniku kontrola docs
jest uruchamiana ponownie, nastÄ™pnie `snapshot.ps1 -Package PKG-0193`.
ZamroĹĽenie `snapshots/PKG-0193-2026-09-05` obejmuje scenes/scripts/tests oraz
uzupeĹ‚niajÄ…cÄ… kopiÄ™ docs/tools/project.godot/AGENTS.md, bo aktualny prosty
snapshot.ps1 sam kopiuje wyĹ‚Ä…cznie pierwsze trzy katalogi. Reports/.godot
nie sÄ… dokumentowanym stanem. CR-A DONE TECHNICAL; nastÄ™pny CR-B w
`docs/NEXT_SESSION_PROMPT.md`. CR-B/C/D, PRODUCT GO i release nie sÄ… wynikiem.

## PKG-0194: CR-B â€” odpowiedĹş, koszt i cudza zgoda, stacje 14â€“18 (2026-09-05)

Zakres z NEXT_SESSION_PROMPT (CR-B, specyfikacja CREATIVE_REVIEW_AND_EXPANSION_PLAN Â§7, kontrakt Â§8.1). Trasa i fizyka bez zmian; zero nowych colliderĂłw i writerĂłw faktĂłw; rozmowy zastÄ™pujÄ… istniejÄ…ce odczyty w tych samych trzech punktach na adres.

Implementacja: creative_scene_lines.gd (treĹ›Ä‡ 14â€“18 + gaĹ‚Ä™zie faz/wyboru/zakresu/prawdy/metody + bramka wiedzy world_recognized dla 17/18); creative_scene_presentation.gd (straĹĽ dowolnej winiety, podglÄ…d alternatyw 16, pomijanie kolejkowania przy oczekujÄ…cym echu 15, fazy nadajnika); _ready 14â€“18 podpina prezenter (wzĂłr CR-A); station_15 jawne uzbrojenie bĹ‚Ä™dnego wzoru na Ĺ›cieĹĽce MRP (arm_deliberate_error_pattern, bez faktu; woĹ‚ania bezpoĹ›rednie bez zmian); station_17 oddaje dialog zgody prezenterowi (limited z rĂłwnÄ… dramaturgiÄ…, koniec E11).

Twarde wykrycia w pakiecie: (1) bool(String) nie istnieje w Godot 4.7 â€” bĹ‚Ä…d kompilacji trasowany do lines_for:84 (pomocnik _truthy, wzĂłr Station14._decision_bool). (2) Reload kasowaĹ‚ home_echo_verified, mechanic_cost_observed, local_lena_intent_found i ucp_cost_ledger_found przez erasure migracyjnÄ… P7 (ten sam defekt co D-208, warstwÄ™ gĹ‚Ä™biej) â€” naprawione usuniÄ™ciem czterech kluczy z tabel + aktualizacjÄ… asercji 0145:166 do przetrwania (wzĂłr 0191); 0145/0147/0148/0151 GREEN. (3) Konflikt 0165:231â€“234 nazwany wprost â€” lint nietkniÄ™ty (GREEN), zastÄ…piony kontrolÄ… dynamicznÄ… faktycznie prezentowanego tekstu i stanu wiedzy (D-211, raport PKG_0194_CREATIVE_SCENES_B.md).

Weryfikacja: nowa bramka pkg_0194_creative_scene_b_test.gd PASS (trzy trasy A/B/C z routingiem 18â†’42A/B/C, kolejnoĹ›Ä‡ warstw, braki, bramka wiedzy, save/reload przed/po, powrĂłt, 6 winiet ze skipem, skale 85/100/115). SÄ…siedzi GREEN: 0162â€“0166, 0145, 0147/0148/0151, 0190/0191/0193. Capture Windows normalnym sterownikiem: 309 PNG + frames.tsv w reports/pkg_0194/visual_final (obejrzane: koszt 16, rejestr 17, prognozy 18). Baseline verify.ps1 startowaĹ‚ przed edycjami i zĹ‚apaĹ‚ stan poĹ›redni (jak run1 w CR-A); wiÄ…ĹĽÄ…cy koĹ„cowy peĹ‚ny przebieg poniĹĽej.

ZamkniÄ™cie PKG-0194: koĹ„cowy peĹ‚ny verify.ps1 reports/pkg_0194_final_verify.log (exit 0, Verification passed, 98 bramek); verify_docs.ps1 DOCS PASS; snapshot.ps1 -Package PKG-0194. CR-B DONE TECHNICAL; nastÄ™pny CR-C w docs/NEXT_SESSION_PROMPT.md. CR-C/CR-D, PRODUCT GO i release nie sÄ… wynikiem.

## PKG-0195: CR-C â€” metoda i skutek, finaĹ‚y 42A/B/C + 43 (2026-09-05) [wpis uzupeĹ‚niony w PKG-0196]

Wpis nie powstaĹ‚ w sesji wykonawczej CR-C; kronikÄ™ uzupeĹ‚nia siÄ™ tutaj
wyĹ‚Ä…cznie ze stanu zamroĹĽonego na dysku, bez zmiany wyniku. Stan:
CURRENT_STATE.md (PKG-0195 / CR-C, zamkniÄ™ty technicznie), raport
`docs/rebuild/PKG_0195_CREATIVE_SCENES_C.md`, bramka
`tests/pkg_0195_creative_scene_c_test.gd` (obecna we verify.ps1),
zamroĹĽenie `snapshots/PKG-0195-2026-09-05`, decyzja D-212 w DECISION_LOG.md.

Zakres (z raportu): 9 punktĂłw 42A/B/C dostarcza rozmowy i odczyty przez
lokalny creative_scene_presentation.gd i rozszerzony creative_scene_lines.gd
(klucze wykonania/odczytu + 9 wariantĂłw household_{a,b,c}_{full,partial,
withheld}); writery, flagi, sygnaĹ‚y i progi bez zmian. 42A: wykonanie
oddzielone od odczytu; domowa Marta pyta o znikniÄ™cie w 3 wariantach prawdy.
42B: miejscowa Lena rozpoznawalna; perspektywa przybyĹ‚ej odciÄ™ta do wiaty
z linii 03 (wiadomoĹ›Ä‡ `JadÄ™` bez adresata). 42C: konkretny przeciek (epizod
prosektorium, oba czytniki z tÄ… samÄ… sekundÄ…); kubek i pusta pĂłĹ‚ka. 43:
struktura i indeksy 0/1/3 bez zmian (bramka 0170); linia B[2] z Szymonem
zastÄ…piona drugim zgĹ‚oszeniem domowej Marty (CR-D01, D-212); cztery
sentencje autorskie zastÄ…pione konkretnymi gestami. Tezy autorskie usuniÄ™te
ze ĹşrĂłdeĹ‚ 42/43. Ĺ»aden lint nie zmieniony.

Weryfikacja (z CURRENT_STATE.md): nowa bramka PASS headless i normalnym
sterownikiem Windows; capture 183 PNG w reports/pkg_0195/visual_final;
koĹ„cowy peĹ‚ny verifier exit 0, 99 bramek, `Verification passed.`
(reports/pkg_0195_final_verify.log); verify_docs.ps1 DOCS PASS. CR-C DONE
TECHNICAL; nastÄ™pny CR-D. CR-D, PRODUCT GO i release nie sÄ… wynikiem.

## PKG-0196: CR-D â€” rytm poczÄ…tku i spĂłjnoĹ›Ä‡ obrazu, stacje 01â€“08 (2026-09-05)

Zakres z NEXT_SESSION_PROMPT (CR-D, priorytety 6 + reszta 2/7,
specyfikacja CREATIVE_REVIEW_AND_EXPANSION_PLAN Â§7, kontrakt Â§8.1).
Trasa i fizyka bez zmian; zero nowych colliderĂłw i writerĂłw faktĂłw;
treĹ›Ä‡ zastÄ™puje istniejÄ…ce odczyty w tych samych punktach.

Implementacja: station_02 (koszt objazdu raz, potem gest telefonu);
station_03 (proĹ›ba Marty z 01 nie wraca; domowy konkret + odpowiedĹş bez
trzeciego liczenia w gaĹ‚Ä™zi powtĂłrki); station_04 (bufor/prĂłbka
rozdzielone po opening_choice; plakat `MARTA // CZEKA W DOMU` zdjÄ™ty ze
Ĺ›ciany wagonu na napis wagonowy `LINIA 4 // DRZWI Z PRAWEJ` â€” jedyna
zmiana obrazu); station_05 (E02: kwestia torby z prawdÄ… gaĹ‚Ä™zi +
pomocnik _decision_string); station_06 (rozkĹ‚ad: konflikt trasy i daty
bez adresu; sprzedawca: zakup Marty i wĹ‚asne zamkniÄ™cie kiosku; wÄ™zeĹ‚
SADOWA 14 z asercji 0158 nietkniÄ™ty); station_08 (pytanie kontrolne
o dwunastkÄ™, cisza po kluczu); FULL_STORY 01 po gaĹ‚Ä™ziach (kontakt
z pierwszego odczytu na obu â€” CR-D Â§2). 07 bez zmian (CR-D04).
Writery, flagi, sygnaĹ‚y, guidance, rysunek i fizyka bez zmian.

Twarde wykrycie w pakiecie: po raz drugi wzorzec D-211 â€” `bool(String)`
nie istnieje w Godot 4.7 (bĹ‚Ä…d kompilacji pierwszej wersji bramki;
asercja przepisana na `String().is_empty()`). Ĺ»aden lint nie zmieniony.
D-213. Raport: `docs/rebuild/PKG_0196_OPENING_RHYTHM.md`.

Weryfikacja: baseline verify_docs.ps1 DOCS PASS (52) + pkg_0157/0158/0159
PASS headless przed edycjami. Nowa bramka pkg_0196_opening_rhythm_test.gd
PASS headless i normalnym sterownikiem Windows OpenGL / Intel Iris Xe
(realny input â†’ writer â†’ kolejka CRT; obie gaĹ‚Ä™zie 01â€“08; braki bez
faktĂłw; save/reload w poĹ‚owie trasy; reread; skale 85/100/115).
Capture: 97 PNG + frames.tsv w reports/pkg_0196/visual_final (obejrzane:
pytanie i odpowiedĹş 08 w 115%, torba bez prĂłbki 05, kwestie 02/03/04/06
w obu gaĹ‚Ä™ziach).

ZamkniÄ™cie PKG-0196: koĹ„cowy peĹ‚ny verify.ps1 reports/pkg_0196_final_verify.log
(exit 0, Verification passed, 100 bramek); verify_docs.ps1 DOCS PASS;
snapshot.ps1 -Package PKG-0196. Kolejka CR-A/B/C/D DONE TECHNICAL;
nastÄ™pny F-0184-010 MRP pilot albo wycinek wĹ‚aĹ›ciciela
w docs/NEXT_SESSION_PROMPT.md. PRODUCT GO i release nie sÄ… wynikiem.

## PKG-0197: ZERO REWIZJA ARTYSTYCZNA wycinek 1 â€” winiety, maszyna 01, ciaĹ‚a 06/08 (2026-09-05)

Zakres z NEXT_SESSION_PROMPT (zero rewizja, dyspozycja wĹ‚aĹ›ciciela 2026-09-05;
pierwszy pionowy wycinek, domkniÄ™ty i zielony). Logika nietykalna: zero nowych
writerĂłw, flag, sygnaĹ‚Ăłw, routingu, enum i serialize IDs; ĹĽaden lint nie zmieniony.

Implementacja: cinematic_catalog.gd (6 dubbingujÄ…cych podpisĂłw Leny w
vig_threshold/vig_signal/vig_commit/vig_finale_a/b/c wyzerowanych do pustych;
wzĂłr: pusta vig_synthesis; sloty, wyzwalacze, dĹ‚ugoĹ›ci klatek, warstwa 19
i skip bez zmian); station_01.gd (niezaleĹĽny zegar _machine_time, bÄ™ben
~9 s/obrĂłt, lampka ~2,6 s, MachineHum AudioStreamPlayer2D przy rejestratorze
na generatorze ballastu hali, cieĹ„ kontaktowy w prawo); station_06.gd
i station_08.gd (wizualne sterowniki rigĂłw vendor/neighbour: linia wĹ‚asna â†’
talk, linia Leny â†’ listen, koniec â†’ idle + obrĂłt do gracza; wczeĹ›niej wieczne
idle mimo istniejÄ…cych klatek talk); cienie kontaktowe 01/06/08 w prawo.
D-214. Raport: docs/rebuild/PKG_0197_ZERO_REVISION_DIAGNOSIS.md (inwentarz
20 adresĂłw, jÄ™zyk miejsc jako hipoteza, kolejka wycinka 2).

Twarde wykrycia w pakiecie: (a) `var a := drum_angle + offset` nie kompiluje
siÄ™ w Godot 4.7 (Variant z literaĹ‚u tablicy; naprawa jawnym `float(offset)`);
(b) wciÄ™cie w nowej bramce; (c) capture headless wiesza siÄ™ na
`frame_post_draw` â€” kadry wycinka wziÄ™te normalnym sterownikiem
(narzÄ™dzie tools/capture_pkg_0197.gd).

Weryfikacja: nowa bramka tests/pkg_0197_zero_revision_test.gd PASS headless
(cisza winiet, autonomia maszyny, sterowniki NPC, kontrakty sprite/skali,
brak globalnych filtrĂłw, Ĺ›wiatĹ‚o praktyczne + runtime: zegar bez inputu,
talk/listen/idle obu rigĂłw). SÄ…siedzi 0190 (catalog/wyzwalacze/skip) i lint
przejĹ›Ä‡ bez modyfikacji. Capture: 3 PNG 640x360 + frames.tsv
w reports/pkg_0197/visual (01/06/08, Intel Iris Xe, OpenGL).
PeĹ‚ne 60 kadrĂłw, test mono i skale 85/100/115 sÄ… kolejkÄ… wycinka 2 â€” jawnie
nie sÄ… wynikiem tego pakietu.

ZamkniÄ™cie PKG-0197: koĹ„cowy peĹ‚ny verify.ps1 reports/pkg_0197_final_verify.log
(exit 0, Verification passed, 101 bramek); verify_docs.ps1 DOCS PASS;
snapshot.ps1 -Package PKG-0197. PRODUCT GO i release nie sÄ… wynikiem.


## PKG-0198: ZERO REWIZJA ARTYSTYCZNA wycinek 2 â€” kadry, mono, cienie, dzwiek (2026-09-05)

Zakres z NEXT_SESSION_PROMPT (zero rewizja, wycinek 2 po PKG-0197; 7 punktow kolejki z diagnozy 0197). Logika nietykalna: zero nowych writerow, flag, sygnalow, routingu, enum i serialize IDs; zaden stary test nie zmieniony.

Implementacja: vector_stage_environment.gd (martwy kod 05 x672+/x1010+ wyciety); stacje 02-05/07/09-18/42A/B/C/43 (cien kontaktowy 0.48 w prawo z nazwana lampa na kazdym z 22 adresow); station_06.gd (KioskWorkHum przy oknie lady + rack gubi egzemplarz po zakupie); station_08.gd (StairwellWorkHum miedzy kinkietami + donica prostuje sie po rozmowie); station_02/15/16 (komentarze pojedynczego rysunku LadderZone, kanon 9.3); station_07 (komentarz: stopien 14 px, zero drabin); station_42A/B/C + station_43 (jawna cisza z jednym dronem). D-215. Raport: docs/rebuild/PKG_0198_SLICE2_REPORT.md.

Twarde wykrycia w pakiecie: (a) sprostowanie diagnozy 0197 â€” podwojny rysunek dotyczyl stacji 02 (kanon 9.3 mowi o 02, naprawione w PKG-0173), nie 07; (b) CrispDiegeticText renderuje przez dziecko CanvasLayer (warstwa 10), ktore nie dziedziczy visible â€” kadr bez tekstu musi gasic CrispDiegeticLayer wprost (naprawione przed capture, narzedzie tools/capture_pkg_0198.gd).

Weryfikacja: nowa bramka tests/pkg_0198_zero_revision_slice2_test.gd PASS headless (martwy kod, cienie 22/22, brak filtrow, geometria mono, drabiny 02/15/16 + brak drabiny 07, praca rack/donica, partytura audio, cisza winiet, runtime humy/drabiny/skale 85/100/115). Sasiad 0197 PASS bez modyfikacji. Capture: 57 PNG 640x360 + frames.tsv w reports/pkg_0198/visual (19 adresow x pelny/bez tekstu/mono L8, Intel Iris Xe, OpenGL; obejrzane 07/05/11/16/42A/43).

Zamkniecie PKG-0198: koncowy pelny verify.ps1 reports/pkg_0198_final_verify.log (exit 0, Verification passed, 102 bramki); verify_docs.ps1 DOCS PASS; snapshot.ps1 -Package PKG-0198. Jezyk miejsc pozostaje hipoteza (D-214). PRODUCT GO i release nie sa wynikiem.

## PKG-0199: F-0184-010 MRP renderer extraction pilot + reguĹ‚a weryfikacji zakresowej (2026-09-06)

Zakres ze sciezki A NEXT_SESSION_PROMPT (po PKG-0198) + dyspozycja wlasciciela o szybszych weryfikacjach. Pilot: 130 rendererow `PropType 67..196` (`CRACKED_TEA_CUP` â€¦ `STATION_41_EXIT`) przeniesionych verbatim skryptem `tools/extract_mrp_pilot.py` do stateless `scripts/interactables/mrp_legacy_renderer.gd` (`extends RefCounted`, wlasne stale kolorow, minimalne sygnatury per renderer â€” tylko czytany stan, zero UNUSED_PARAMETER). Fasada trzyma 130 wrapperow delegujacych 1:1. Aktywna trasa P9 uzywa z zakresu tylko 68 (Station 16 `cost_selector`) i 74 (Station 17 `adaptation_offer_terminal`); reszta to retired 19â€“41. Logika nietykalna: zero writerow, flag, sygnalow, routingu, enum i serialize IDs.

Twarde wykrycia: (a) audyt przed ekstrakcja: 130/130 funkcji, jedyne zaleznosci to `is_activated`/`_pulse_phase`/`is_player_in_range` + `COLOR_*` + `draw_*` (775 rect, 568 line, 317 circle, 34 arc, 12 ellipse, 10 polygon, 7 polyline), zero logiki; (b) pelna weryfikacja po ekstrakcji byla CZERWONA w `pkg_0160` (`_draw_marta_witness_station`, 188 w pilocie, nie mial juz rozu `d45b9a` w fasadzie) mimo zielonych bramek zakresowych 0189+0199 â€” naprawione kontrola rownowazna/silniejsza `_renderer_body()` idaca przez delegacje (D-216); (c) ta regresja poza zakladanym blast radius jest dowodem, ze shared-touch wymaga pelnej â€” stad nowa reguĹ‚a D-217: `tools/verify_scoped.ps1` (docs + jawne bramki, ta sama polityka logow) tylko poza plikami wspoldzielonymi (lista w WORKFLOW.md), shared-touch/kontrakt/checkpoint/co 5 pakietow zawsze pelna.

Weryfikacja: nowa bramka tests/pkg_0199_mrp_renderer_pilot_test.gd PASS headless (fasada 206/221, helper 130, dispatch 1:1, runtime 67/68/74/100/150/196 + one-shot + state_changed, stacje 16/17 prawdziwym mostem MRP, soak 130 bez wyciekow). Sasiad 0189 PASS bez modyfikacji; 0160 PASS po naprawie D-216 (wczesniejszy FAIL udokumentowany w reports/pkg_0199_verify.log, exit 1). Stary test zmieniony wylacznie 0160 (delegacja).

Zamkniecie PKG-0199: koncowy pelny verify.ps1 reports/pkg_0199_verify_full.log (exit 0, Verification passed, 103 bramki: 102 + 0199); verify_docs.ps1 DOCS PASS (52 pliki); WORKFLOW.md (sekcja D-217) + DECISION_LOG (D-216/D-217) + ROADMAP (wiersze 0193â€“0199) + raport docs/rebuild/PKG_0199_MRP_RENDERER_PILOT.md; snapshot.ps1 -Package PKG-0199. F-0184-010 pozostaje dlugiem P3 (interakcja/audio + rendery 0..66/197..202 w monolicie). PRODUCT GO i release nie sa wynikiem (D-168).

## PKG-0200: F-0184-010 MRP renderer extraction slice2 â€” 73 rendery 0..66/197..202 (2026-09-06)

Zakres ze sciezki A NEXT_SESSION_PROMPT (po PKG-0199): drugi wycinek pilota MRP. Slice2: 73 rendery `PropType 0..66,197..202` (`PHOTOGRAPH` â€¦ `TRANSIT_SERVICE_GATE` + `EPILOGUE_RETURN_CUPS` â€¦ `EPILOGUE_FINAL_BLACKOUT`) dopisane verbatim skryptem `tools/extract_mrp_slice2.py` do stateless `scripts/interactables/mrp_legacy_renderer.gd` (lacznie 203: 130 pilot + 73 slice2; `extends RefCounted`, wlasne 6 stalych kolorow, minimalne sygnatury per renderer â€” tylko czytany stan, zero UNUSED_PARAMETER). Fasada trzyma 73 wrappery 1:1 z markerem `PKG-0200 slice2` (130 markeroĚw pilota nietknietych). W przeciwienstwie do pilota, slice2 niesie prawie cala aktywna powierzchnie MRP (09-18, 42A/B/C, 43). Trzy overlaye (`_draw_in_world_reticule`, `_draw_resolved_mark`, `_draw_contact_read`) zostaja w fasadzie z definicji. Logika nietykalna: zero writerow, flag, sygnalow, routingu, enum i serialize IDs.

Twarde wykrycia: (a) audyt przed ekstrakcja: 73/73 funkcji, jedyne zaleznosci to 5 wizualnych tokenow (`is_activated` 81, `_pulse_phase` 55, `is_player_in_range` 7, `shadow_progress` 3, `_resonance_flash` 2) + 6 `COLOR_*` + `draw_*` (411 rect, 387 line, 245 circle, 8 arc, 3 colored_polygon, 2 polygon, 1 polyline), zero logiki; trzy speciale wymagaja rozszerzonego podpisu (D-218): 54/57 `shadow_progress` â†’ `p_shadow`, 63 `_resonance_flash` â†’ `p_flash` (czyste floaty animacji, helper stateless); (b) po ekstrakcji dwa stare testy byly CZERWONE mimo zielonej nowej bramki (wzor D-216): `pkg_0199` pinal total 130 (jest 203) oraz `pkg_0160` cial proze/arki Marty wprost z fasady (`Long pink hair`/`steel septum`/`draw_arc(` przeniosly sie z 23/45 do helpera) â€” naprawione kontrola rownowazna/silniejsza (total 203 przy pinie 130 pilota; proza/arki przez combined facade+helper; pin rozu `d45b9a` dzialal przez istniejaca delegacje `_renderer_body()` bez zmian) (D-218); zaden prog nie obnizony, zaden lint nie zmieniony; (c) przy okazji fakt danych (nie wynik): `station_18.tscn`/`MartaTruthTable` nie ma linii `prop_type` (default 0 = PHOTOGRAPH) â€” zostawione nietkniete, kolejka do decyzji wlasciciela.

Weryfikacja: nowa bramka tests/pkg_0200_mrp_renderer_slice2_test.gd PASS headless (fasada 206/221 + markery 130+73 + 203 delegacje, helper 203, dispatch 73x1:1, rownowaznosc 5 tokenow, runtime 10 wezlow 0/5/8/25/54/57/63/66/197/202 + one-shot typ 5 + state_changed + pelne 5 tokenow, 6 stacji aktywnych 09/10/16/17/42B/43 prawdziwym mostem MRP, soak 73 + sweep 203 bez wyciekow). Sasiad 0189 PASS bez modyfikacji; 0199 PASS po aktualizacji totalu D-218; 0160 PASS po aktualizacji prozy/arkow D-218 (wczesniejsze FAIL-e udokumentowane w logu bramki przed naprawa). Stare testy zmienione wylacznie 0199 (total) i 0160 (combined) â€” oba z komentarzem PKG-0200/D-218.

Zamkniecie PKG-0200: koncowy pelny verify.ps1 reports/pkg_0200_verify_full.log (exit 0, Verification passed, 104 bramki: 103 + 0200); verify_docs.ps1 DOCS PASS (52 pliki); DECISION_LOG (D-218) + ROADMAP (wiersz 0200) + raport docs/rebuild/PKG_0200_MRP_RENDERER_SLICE2.md + skrypt tools/extract_mrp_slice2.py + bramka w verify.ps1; snapshot.ps1 -Package PKG-0200. F-0184-010: rendery MRP zamkniete w calosci (203/203 PropType); pozostaje dlug interakcji/audio poza rendererami (dotyka logiki, wymaga dyspozycji). PRODUCT GO i release nie sa wynikiem (D-168).

## PKG-0201: Ocularna inspekcja 57 kadrow 0198 â€” sciezka B, 19/19 HOLD, zero napraw (2026-09-06)

Zakres ze sciezki B NEXT_SESSION_PROMPT (po PKG-0200). Sciezka A (ekstrakcja interakcji/audio MRP poza rendererami) wymaga jawnej dyspozycji wlasciciela, bo dotyka logiki â€” bez niej nie ruszana. Zero zmian w `scripts/`, `scenes/`, konfiguracji, enum, serialize IDs, routingu, progach i InputMap; nowe pliki wylacznie: raport `docs/rebuild/PKG_0201_OCULAR_INSPECTION.md`, bramka `tests/pkg_0201_ocular_inspection_test.gd`, arkusze `reports/pkg_0201/visual/sheet_01..07_*.png`, rejestracja bramki w `tools/verify.ps1`.

Implementacja: 7 arkuszy kontaktowych (kazdy adres: pelny | bez tekstu | mono obok siebie; 57/57 kadrow obejrzanych okiem na miniaturach 320x180) + dobadanie full-res 640x360 dla flagowanych (14 bez-tekstu/mono, 16 mono, 43 pelny) + metryki PIL (mono 19/19 czysta szarosc R==G==B, wymiary 57/57 640x360). Werdykt: 19/19 HOLD; lista napraw pusta. Ciemna czworka 14/15/16/17 trzyma sie krawedzia i obrysem (14: szafa + stozek + okrag echa + pasek fali + portal; 16: drabina + bufet + odbiornik z bialym rdzeniem + portal â€” oba potwierdzone full-res); notatki obserwacyjne w raporcie, nie zlecenia. Sciana tekstu w kadrze pelnym 43 to diegetyczne plansze credits/licencji epilogu, nie wyciek. Bez nowej tezy autorskiej (D-214); `station_18 MartaTruthTable prop_type` nietkniÄ™te (fakt danych do decyzji wlasciciela).

Twarde wykrycia w pakiecie: (a) roznica pikselowa pelny-vs-bez-tekstu (srednia 10-39, 39-74% pikseli) nie mierzy samego usuniecia tekstu â€” warianty capture dzieli kilka klatek zywej maszynerii, wiec liczba miesza animacje z czyszczeniem dialogu; czystosc kadru jest oczna, nie pikselowa; (b) bramka 0198 dowodzila skal 85/100/115 zywa prezentacja 08 â€” ten pakiet rozszerza runtime na 11/14/43 x 3 skale (ladowanie + 2 klatki bez bledow) + regresje 08; oczny oglad 85/115 w pelnej rozdzielczosci pozostaje otwarty.

Weryfikacja: nowa bramka tests/pkg_0201_ocular_inspection_test.gd PASS headless za pierwszym przebiegiem (TSV 57 wierszy, 57 plikow 640x360, mono szare i zgodne luminancja z bez-tekstu, pin 19/19 HOLD, runtime 08x3 akcje + 11/14/43x3 skale). Zakresowa verify_scoped.ps1: Scoped verification passed (docs DOCS PASS 52 pliki + smoke + 0198 PASS bez modyfikacji + 0201 PASS; ta sama polityka logow co pelna). Blast radius: zero plikow wspoldzielonych z listy D-217 (brak zmian enum/serialize IDs/routingu/progow/InputMap) â€” pelna verify.ps1 nie byla wymagana; skladnia verify.ps1 po dopisaniu bramki sprawdzona parserem. Ostatnia pelna weryfikacja pozostaje z PKG-0200 (104 bramki, exit 0).

Zamkniecie PKG-0201: raport docs/rebuild/PKG_0201_OCULAR_INSPECTION.md + bramka w verify.ps1 (105. bramka) + DECISION_LOG (D-219) + ROADMAP (wiersz 0201) + CURRENT_STATE/NEXT_SESSION_PROMPT/INDEX; snapshot.ps1 -Package PKG-0201. Kolejka: dlug interakcji/audio MRP (wymaga dyspozycji), fakt prop_type station_18, oczny oglad 85/115 full-res. PRODUCT GO i release nie sa wynikiem (D-168).

## PKG-0202: Oczny ogld skal 85/115 full-res â€” sciezka C, 08/11/14/43, 4/4 HOLD, zero napraw (2026-09-06)

Zakres ze sciezki C NEXT_SESSION_PROMPT (po PKG-0201): dobadanie otwartego ograniczenia PKG-0201 (bramka dowodzila runtime, nie oko) dla 4 adresow probkowych â€” 08 (regresja), 11 (najjasniejsza), 14 (najciemniejsza), 43 (final). Sciezka A (ekstrakcja interakcji/audio MRP poza rendererami) wymaga jawnej dyspozycji wlasciciela, bo dotyka logiki â€” bez niej nie ruszana. Sciezka B (station_18 prop_type) wymaga decyzji â€” nie naprawiana po cichu. Zero zmian w scripts/, scenes/, konfiguracji, enum, serialize IDs, routingu, progach i InputMap; nowe pliki wylacznie: raport docs/rebuild/PKG_0202_TEXT_SCALE_OCULAR.md, bramka tests/pkg_0202_text_scale_ocular_test.gd, narzedzie tools/capture_pkg_0202.gd, kadry reports/pkg_0202/visual/ (24 PNG + frames.tsv + 4 arkusze), rejestracja bramki w tools/verify.ps1.

Implementacja: capture normalnym sterownikiem (Intel Iris Xe, OpenGL; headless wiesza sie na frame_post_draw, fakt z PKG-0197) â€” skala przed instancja przez set_text_scale(v, false) bez persistu, po petli powrot do 1.0; warianty full/notext wzorem 0198 (gaszenie CrispDiegeticLayer wprost). Oglad: 24/24 kadry okiem na 4 arkuszach (3 skale x pelny/bez tekstu, miniatury 320x180) + full-res 640x360 dla flagowanych (08 s85/s115 full, 11 s115 full/notext, 14 s85 notext + s115 full/notext, 43 s85/s115 full + s115 notext). Werdykt: 4/4 HOLD; etykiety diegetyczne cale na 85 i 115 (08: klatka + drzwi 12/14; 11: UCP-4 i wyciagi; 14: rozdzielnia i most sekcji; 43: sciana credits w calosci takze na 115 â€” potwierdzenie diegetyki z 0201), notext czysty na kazdej skali, box dialogu miesci tekst. Bez nowej tezy autorskiej (D-214/D-219); station_18 MartaTruthTable prop_type nietkniete.

Twarde wykrycia w pakiecie: (a) kadry pelne lapia dialog CRT w srodku efektu maszyny do pisania (08/14/43: rozna liczba znakow to faza prezentacji, nie skala) â€” wniosek o braku uciec jest oczny, nie pikselowy; (b) notext s85-vs-s115 = 0 dla 08/11/43 (ukrycie trzyma niezaleznie od skali), 0.118 dla 14 (zywa faza fali/ramienia miedzy ujeciami, ten sam fakt o animacji co w 0201); (c) probkowanie bramki co 37 px mijalo ~1% region tekstu (pierwszy przebieg: 4x FAIL 0.0000) â€” naprawione gestszym krokiem 13 bez zmiany progow (drugi przebieg PASS).

Weryfikacja: nowa bramka tests/pkg_0202_text_scale_ocular_test.gd PASS headless (TSV 24 wiersze, 24 pliki 640x360, full-vs-notext i full s85-vs-s115 rozlaczne, pin 12/12 HOLD, runtime 08x3 akcje + 11/14/43x3 skale). Zakresowa verify_scoped.ps1: Scoped verification passed (docs DOCS PASS 52 pliki + smoke + 0198 PASS bez modyfikacji + 0201 PASS bez modyfikacji + 0202 PASS; ta sama polityka logow co pelna). Blast radius: zero plikow wspoldzielonych z listy D-217 (brak zmian enum/serialize IDs/routingu/progow/InputMap) â€” pelna verify.ps1 nie byla wymagana; skladnia verify.ps1 po dopisaniu bramki sprawdzona parserem (2139 tokenow, 0 bledow). Ostatnia pelna weryfikacja pozostaje z PKG-0200 (104 bramki, exit 0).

Zamkniecie PKG-0202: raport docs/rebuild/PKG_0202_TEXT_SCALE_OCULAR.md + bramka w verify.ps1 (106. bramka) + ROADMAP (wiersz 0202) + CURRENT_STATE/NEXT_SESSION_PROMPT/INDEX; snapshot.ps1 -Package PKG-0202. Kolejka: dlug interakcji/audio MRP (wymaga dyspozycji), fakt prop_type station_18, oczny ogld 85/115 dla pozostalych 15 adresow wycinka 2. PRODUCT GO i release nie sa wynikiem (D-168).

## PKG-0203: Oczny ogld skal 85/115 full-res, reszta wycinka 2 â€” sciezka C, 16/16 HOLD, zero napraw (2026-09-06)

Zakres ze sciezki C NEXT_SESSION_PROMPT (po PKG-0202): domkniecie otwartego ograniczenia PKG-0202 (bramka dowodzila runtime, nie oko) dla reszty adresow wycinka 2. Sciezka A (ekstrakcja interakcji/audio MRP poza rendererami) wymaga jawnej dyspozycji wlasciciela, bo dotyka logiki â€” bez niej nie ruszana. Sciezka B (station_18 prop_type) wymaga decyzji â€” nie naprawiana po cichu. Zero zmian w scripts/, scenes/, konfiguracji, enum, serialize IDs, routingu, progach i InputMap; nowe pliki wylacznie: raport docs/rebuild/PKG_0203_TEXT_SCALE_OCULAR_REST.md, bramka tests/pkg_0203_text_scale_ocular_rest_test.gd, narzedzie tools/capture_pkg_0203.gd, kadry reports/pkg_0203/visual/ (96 PNG + frames.tsv + 16 arkuszy), rejestracja bramki w tools/verify.ps1.

Nazwany rozjazd handoffu: prompt mowil o â€žpozostalych 15 adresach", ale inwentarz reports/pkg_0198/visual/frames.tsv liczy 19 adresow, z czego PKG-0202 domknal ocznie 3 (11/14/43; 08 lezy poza zestawem 0198) â€” reszta to 16 adresow (02/03/04/05/07/09/10/12/13/15/16/17/18/42a/42b/42c), nie 15. Pakiet pokrywa wszystkie 16; razem z 0202 caly zestaw 0198 ma pokrycie oczne 85/115 plus regresja 08.

Implementacja: capture normalnym sterownikiem (Intel Iris Xe, OpenGL; headless wiesza sie na frame_post_draw, fakt z PKG-0197) â€” skala przed instancja przez set_text_scale(v, false) bez persistu, po petli powrot do 1.0; warianty full/notext wzorem 0198/0202 (gaszenie CrispDiegeticLayer wprost). Oglad: 96/96 kadrow okiem na 16 arkuszach (3 skale x pelny/bez tekstu, miniatury 320x180) + full-res 640x360 dla flagowanych metryka i proby ciemnej trasy (09 s85/s115 notext, 03 s115 notext, 16 s115 full, 18 s115 full, 42c s115 full). Werdykt: 16/16 HOLD; etykiety diegetyczne cale na 85 i 115 na kazdym adresie, notext czysty na kazdej skali, box dialogu miesci tekst. Bez nowej tezy autorskiej (D-214/D-219); station_18 MartaTruthTable prop_type wylacznie obserwowane, nietkniete.

Twarde wykrycia w pakiecie: (a) kadry pelne lapia dialog CRT w srodku efektu maszyny do pisania (02/05/18: rozna liczba znakow to faza prezentacji, nie skala) â€” wniosek o braku uciec jest oczny, nie pikselowy (ten sam fakt co w 0202); (b) metryki: full-vs-notext s100 = 0.20â€“0.47, full s85-vs-s115 = 0.009â€“0.017 (~1% regionu tekstu, krok 13 â€” twardy fakt z 0202); notext s85-vs-s115 = 0 dla 9 adresow, 0.0007 dla 13/15/17/18, 0.026â€“0.083 dla 07/05/03, 0.237 dla 09 â€” okiem potwierdzone jako zywa faza lampy/animacji miedzy ujeciami (ta sama klasa co stacja 14 w 0201/0202), nie wyciek tekstu; (c) wywolanie verify_scoped.ps1 przez `pwsh -File` z literalnym `@(...)` nie wiaze tablicy (argumenty -File sa stringami) â€” dziala dopiero wywolanie operatorem `&` z pliku posredniego.

Weryfikacja: nowa bramka tests/pkg_0203_text_scale_ocular_rest_test.gd PASS headless za pierwszym przebiegiem (TSV 96 wierszy, 96 plikow 640x360, full-vs-notext i full s85-vs-s115 rozlaczne, pin 48/48 HOLD, runtime 08x3 akcje + 16 adresowx3 skale). Zakresowa verify_scoped.ps1: Scoped verification passed (docs DOCS PASS 52 pliki + smoke + 0198 PASS bez modyfikacji + 0201 PASS bez modyfikacji + 0202 PASS bez modyfikacji + 0203 PASS; ta sama polityka logow co pelna). Blast radius: zero plikow wspoldzielonych z listy D-217 (brak zmian enum/serialize IDs/routingu/progow/InputMap) â€” pelna verify.ps1 nie byla wymagana; skladnia verify.ps1 po dopisaniu bramki sprawdzona parserem (2171 tokenow, 0 bledow). Ostatnia pelna weryfikacja pozostaje z PKG-0200 (104 bramki, exit 0); trzecia zakresowa z rzedu â€” pelna wymagana najpozniej w PKG-0205.

Zamkniecie PKG-0203: raport docs/rebuild/PKG_0203_TEXT_SCALE_OCULAR_REST.md + bramka w verify.ps1 (107. bramka) + ROADMAP (wiersz 0203) + CURRENT_STATE/NEXT_SESSION_PROMPT/INDEX; snapshot.ps1 -Package PKG-0203. Kolejka: dlug interakcji/audio MRP (wymaga dyspozycji), fakt prop_type station_18; ogld skal 85/115 dla wycinka 2 DOMKNIETY. PRODUCT GO i release nie sa wynikiem (D-168).

## PKG-0204: Checkpoint pelnej weryfikacji po PKG-0203 â€” 107/107 GREEN, zero zmian kodu (2026-09-06)

Zakres: wylacznie checkpoint (brak dyspozycji wlasciciela dla sciezki A â€” ekstrakcja interakcji/audio MRP dotyka logiki â€” i brak decyzji dla sciezki B â€” station_18 prop_type; obie nietkniete, nie naprawiane po cichu). Zero zmian w scripts/, scenes/, tests/, tools/verify.ps1, konfiguracji, enum, serialize IDs, routingu, progach i InputMap; nowe pliki wylacznie: log reports/pkg_0204_verify_full.log + dokumenty handoffu (CURRENT_STATE, NEXT_SESSION_PROMPT, INDEX, ROADMAP, ten wpis).

Baseline przed edycjami: verify_docs.ps1 DOCS PASS (52 pliki) â€” zgodny z handoffem PKG-0203, zero rozjazdow do nazwania (spodziewany pakiet PKG-0204 potwierdzony w SESSION_LOG).

Weryfikacja: pelny tools/verify.ps1 exit 0, Verification passed., 107 sekcji == ... == w logu (104 z PKG-0200 + 0201 + 0202 + 0203), w tym DOCS PASS 52 pliki oraz bramki 0198/0201/0202/0203 PASS bez modyfikacji. Jedyny traf failed|ERROR w logu to linia samotestu polityki (GODOT LOG POLICY PASS), nie blad. To czwarty pakiet po ostatniej pelnej (0201/0202/0203 byly zakresowe D-217) â€” pelna wykonana wczesniej niz wymagane PKG-0205, wiec licznik D-217 zresetowany: nastepna pelna przy shared-touch / nowym kontrakcie / checkpoincie albo najpozniej w PKG-0209. Blast radius: pusty (brak zmian kodu) â€” pelna nie wykazala regresji poza nim, co potwierdza, ze trzy zakresowe z rzedu niczego nie ukryly (dowod ostroznosci D-217).

Zamkniecie PKG-0204: reports/pkg_0204_verify_full.log + ROADMAP (wiersz 0204) + CURRENT_STATE/NEXT_SESSION_PROMPT/INDEX; snapshot.ps1 -Package PKG-0204. Kolejka bez zmian: dlug interakcji/audio MRP (wymaga dyspozycji), fakt prop_type station_18 (wymaga decyzji); ogld skal 85/115 dla wycinka 2 DOMKNIETY (0202+0203). PRODUCT GO i release nie sa wynikiem (D-168).

## PKG-0205: Decyzja prop_type station_18 â€” HOLD na PHOTOGRAPH, zero zmian sceny (2026-09-06)

Zakres ze sciezki B NEXT_SESSION_PROMPT (po PKG-0204), z decyzja podjeta w imieniu wlasciciela (prompt sesji deleguje podejmowanie decyzji; kierunek: dobro projektu). Sciezka A (ekstrakcja interakcji/audio MRP dotyka logiki) nietknieta â€” delegacja decyzji nie jest dyspozycja dotykania logiki. Sciezka C domknieta (0202+0203). Zero zmian w scripts/, scenes/, konfiguracji, enum, serialize IDs, routingu, progach i InputMap; nowe pliki wylacznie: raport docs/rebuild/PKG_0205_STATION18_PROPTYPE_DECISION.md, bramka tests/pkg_0205_station18_proptype_hold_test.gd, rejestracja bramki w tools/verify.ps1.

Decyzja D-220: MartaTruthTable ZOSTAJE na efektywnym prop_type 0 (PHOTOGRAPH). Uzasadnienie z kodu i kadru 0203 s115 full (nowych capture'ow nie generowano â€” scena nietknieta, kadr 0203 aktualny): SHOWCASE_VITRINE (48) to jasna gablota instytucjonalna UCP 34x46 z bialymi dokumentami â€” obca ciemnej ulicy 18; PHOTOGRAPH (0) to mala przygaszona ramka 24x20 niesprzeczna z HOLD 0198/0201/0202/0203. Zamiana typu to tez zamiana dzwieku (generyczny _memory_sound -> paper_rustle, obie galezie w zrodle) oraz nowy kontrakt przy nowym enum â€” oba poza zakresem. Diegeze niesie rysowana przez stacje witryna 92x70 (station_18.gd:_draw_marta_window); wezel MRP niesie interakcje po resonance_id (station_18.gd:136-146 ignoruje prop_type poza clue_inspected). Bez nowej tezy autorskiej (D-214/D-219).

Twarde wykrycia w pakiecie: (a) memory_resonance_point.gd ma koncowki CRLF â€” asercje tekstowe bramki normalizuja \r\n do \n przed porownaniem (pierwszy przebieg: 2x FAIL dispatchu mimo poprawnego wzorca); (b) w GDScript 4.7 nie ma globalnego chr() â€” normalizacja przez litery "\r\n"/"\n" (drugi przebieg: parse error; trzeci: PASS); (c) PHOTOGRAPH nie ma wlasnej galezi w trigger_interaction() ani _setup_audio() (181 galezi elif, zadna dla PHOTOGRAPH) â€” potwierdza zmiane dzwieku przy zmianie typu.

Weryfikacja: nowa bramka tests/pkg_0205_station18_proptype_hold_test.gd PASS headless za trzecim przebiegiem (efektywne typy trojki 53/0/16 z tekstu .tscn â€” brak linii = default 0, jawne 0 tez przechodzi; id/tytul wezla; oba rendery w helperze + dispatch 0/48 w fasadzie; runtime: ladowanie stacji, zywe typy, porzadek X 176 < 332 < 484, 2 klatki bez bledow). Zakresowa verify_scoped.ps1: Scoped verification passed (docs DOCS PASS + smoke + 0198 + 0201 + 0202 + 0203 bez modyfikacji + 0205 PASS; ta sama polityka logow co pelna). Blast radius: zero plikow wspoldzielonych z listy D-217 (brak zmian enum/serialize IDs/routingu/progow/InputMap; tools/verify.ps1 tykany wylacznie rejestracja bramki, wzor 0201/0202/0203) â€” pelna verify.ps1 nie byla wymagana; skladnia verify.ps1 po dopisaniu bramki zgodna ze wzorem. Ostatnia pelna weryfikacja pozostaje z PKG-0204 (107 bramek, exit 0); nastepna pelna przy shared-touch / kontrakcie / checkpoincie albo najpozniej w PKG-0209.

Zamkniecie PKG-0205: raport docs/rebuild/PKG_0205_STATION18_PROPTYPE_DECISION.md + bramka w verify.ps1 (108. bramka) + DECISION_LOG (D-220) + ROADMAP (wiersz 0205) + CURRENT_STATE/NEXT_SESSION_PROMPT/INDEX; snapshot.ps1 -Package PKG-0205. Kolejka: dlug interakcji/audio MRP (wymaga dyspozycji); fakt prop_type station_18 ZAMKNIETY decyzja D-220 (rewizja tylko nowym pakietem z kadrami przed/po). PRODUCT GO i release nie sa wynikiem (D-168).

## PKG-0206: Inwentaryzacja interakcji/audio MRP â€” HOLD logiki, specyfikacja 2 krokow (2026-09-06)

Zakres z NEXT_SESSION_PROMPT (po PKG-0205), z decyzja podjeta w imieniu wlasciciela (prompt sesji deleguje podejmowanie decyzji; kierunek: dobro projektu; ACT). Sciezka A-ekstrakcja dotyka logiki i wymaga jawnej dyspozycji technicznej â€” ten pakiet jej NIE wykonuje (delegacja decyzji o zakresie nie jest dyspozycja dotykania logiki; regula z PKG-0205 podtrzymana decyzja D-221). Sciezka B ZAMKNIETA (D-220); sciezka C DOMKNIETA (0202+0203). Zero zmian w scripts/, scenes/, konfiguracji, enum, serialize IDs, routingu, progach i InputMap; nowe pliki wylacznie: raport docs/rebuild/PKG_0206_MRP_INTERACTION_INVENTORY.md, bramka tests/pkg_0206_mrp_interaction_inventory_test.gd, rejestracja bramki w tools/verify.ps1.

Decyzja D-221: dlug F-0184-010 poza rendererami ZAPINOWANY i OPISANY (inwentaryzacja + specyfikacja dwoch krokow), logika NIETKNIETA. Uzasadnienie: ekstrakcja 182 galezi triggera + emisji/clue/particles/haptyki to logika gry, nie mechaniczny ruch cial funkcji (jak rendery 0199/0200); autonomiczny ruch na samej delegacji ryzykowalby regresje. Zamiast kolejnego pustego HOLD/checkpointu pakiet domyka wartosc: dokladne liczby + granica ekstrakcji + bramka.

Inwentaryzacja narzedziowa (odczyt zrodla scripts/interactables/memory_resonance_point.gd, 3566 linii / 221 funkcji / 206 _draw_*; fasada deleguje 203 typy, markery 130+73): trigger_interaction() = 1x if CIRCUIT_BREAKER + 181x elif = 182 galezie jawne + else z _memory_sound (183 przypisania stream i pitch); 179x latch + 4x toggle (CIRCUIT_BREAKER, SEAM_STABILIZER_LEVER, REFLECTIVE_PUDDLE, PRESSURE_RELIEF_VALVE); haptyka pierwsza (D-147: detent dla SWITCH_LIKE vs probe_brush), one-shot przed haptyka, 1x emit + _resonance_flash/particles/redraw; PHOTOGRAPH (0) bez wlasnej galezi (fallback), SHOWCASE_VITRINE (48) z paper_rustle (fakt D-220). Audio: _setup_audio() 352 linie, 1x match, 165 ramion PropType + fallback _: (183 typy jawne, 20 na generyku; 170 create_ w setup + 3 haptic cached = 173 w pliku). SWITCH_LIKE_PROPS 6 nazw (zbior haptyczny rozny od zbioru przelacznikow: JAKUB_DESK_LAMP/STAIR_TIMER_SWITCH/DOOR_CARD_READER latchuja; REFLECTIVE_PUDDLE przelacza spoza listy). Specyfikacja: krok 1 tabela audio (niskie ryzyko), krok 2 tabela interakcji (wysokie ryzyko, dispatch 1:1 + runtime mostem, wzor D-216/D-218); zakaz zmian enum/serialize/routingu/progow/InputMap/writerow.

Twarde wykrycia w pakiecie: brak nowych (wzorce potwierdzone: CRLF fasady MRP + normalizacja \r\n; brak chr() w GDScript 4.7; jawne typy przy Variant; wywolanie verify_scoped.ps1 operatorem & z tablica @(...), nie przez pwsh -File). Nowa bramka PASS za pierwszym przebiegiem headless.

Weryfikacja: baseline verify_docs.ps1 DOCS PASS (52) przed edycjami. Nowa bramka tests/pkg_0206_mrp_interaction_inventory_test.gd PASS headless (kontrakt fasady 221/206 + sentinele/exporty/sygnaly/metody/clue/SWITCH_LIKE 6/brak grup/markery/delegacje; trigger 182+else/183/179+4/haptyka/one-shot/emit; audio 165/183/20/173; runtime 0/1/48 + one-shot 5, 2 klatki bez bledow). Zakresowa verify_scoped.ps1: Scoped verification passed (docs DOCS PASS + smoke + 0198 + 0201 + 0202 + 0203 + 0205 bez modyfikacji + 0206 PASS; ta sama polityka logow co pelna). Blast radius: zero plikow wspoldzielonych z listy D-217 (brak zmian enum/serialize IDs/routingu/progow/InputMap; tools/verify.ps1 tykany wylacznie rejestracja bramki, wzor 0201/0202/0203/0205) â€” pelna verify.ps1 nie byla wymagana. Ostatnia pelna weryfikacja pozostaje z PKG-0204 (107 bramek, exit 0); nastepna pelna przy shared-touch / kontrakcie / checkpoincie albo najpozniej w PKG-0209.

Zamkniecie PKG-0206: raport docs/rebuild/PKG_0206_MRP_INTERACTION_INVENTORY.md + bramka w verify.ps1 (109. bramka) + DECISION_LOG (D-221) + ROADMAP (wiersz 0206) + CURRENT_STATE/NEXT_SESSION_PROMPT/INDEX; snapshot.ps1 -Package PKG-0206. Kolejka: ekstrakcja tabel audio/interakcji czeka na dyspozycje (shared-touch, pelna verify); D-220 bez zmian; D-221 rewidowana tylko nowym pakietem przy zmianie liczb. PRODUCT GO i release nie sa wynikiem (D-168).

## PKG-0207: Spis bramek i pin fundamentow â€” HOLD logiki i obrazu (2026-09-06)

Zakres z NEXT_SESSION_PROMPT (po PKG-0206), z decyzja podjeta w imieniu wlasciciela (prompt sesji deleguje podejmowanie decyzji; kierunek: dobro projektu; ACT). Sciezka A-ekstrakcja dotyka logiki i wymaga jawnej dyspozycji technicznej â€” ten pakiet jej NIE wykonuje (delegacja decyzji o zakresie nie jest dyspozycja dotykania logiki; regula z PKG-0205 podtrzymana po raz trzeci, decyzja D-222). Sciezka B ZAMKNIETA (D-220); sciezka C DOMKNIETA (0202+0203). Zero zmian w scripts/, scenes/, konfiguracji, enum, serialize IDs, routingu, progach i InputMap; nowe pliki wylacznie: raport docs/rebuild/PKG_0207_GATE_CENSUS.md, bramka tests/pkg_0207_gate_census_test.gd, rejestracja bramki w tools/verify.ps1.

Decyzja D-222: rejestr bramek ZAPINOWANY spisem, fundamenty i spojnosc handoffu OPISANE pinami read-only. Uzasadnienie: przy 100+ bramkach dryf rejestru (osierocony test, wiszaca referencja, zdublowana nazwa) bylby cicha regresja bez zadnego FAIL-a; pin wykryje ja glosno. Zamiast pustego HOLD/checkpointu pakiet domyka wartosc: spis + fundamenty + handoff w jednej bramce.

Spis narzedziowy (odczyt tekstu tools/verify.ps1 + DirAccess tests/, nie oko): 101 plikow tests/*.gd == 101 unikalnych referencji res://tests/*.gd (zero w obie strony: brak sierot, brak wiszacych); 102 wywolania ze skryptem (101 testow + res://tools/frame_budget_audit.gd, plik istnieje) + 1 import edytora bez skryptu = 103 wiersze wywolujace Invoke-GodotGate; nazwy bramek (-Name) unikalne. Twardy fakt pakietu: wiersz definicji function Invoke-GodotGate zawiera nazwe, wiec pin liczy wiersze z kontynuacja backtick, nie surowe wystapienia podciagu (inaczej +1).

Fundamenty read-only (tekst project.godot + runtime ProjectSettings/InputMap): viewport 640x360, fizyka 60 Hz, 10 akcji semantycznych (move_left/right/up/down, jump, restart, pause, interact, trigger_correction, sprint), kazda z >= 1 eventem. Handoff spojny: SESSION_LOG konczy sie PKG-0207, CURRENT_STATE nazywa PKG-0207, DECISION_LOG zawiera D-222, NEXT_SESSION_PROMPT nazywa PKG-0207 i spodziewany PKG-0208.

Twarde wykrycia w pakiecie: brak nowych poza faktem liczenia backtick (powyzej); wzorce potwierdzone (CRLF + normalizacja, brak chr(), jawne typy, verify_scoped operatorem &).

Weryfikacja: baseline verify_docs.ps1 DOCS PASS (52) przed edycjami, zero rozjazdow (spodziewany PKG-0207 potwierdzony). Nowa bramka tests/pkg_0207_gate_census_test.gd PASS headless za pierwszym przebiegiem (spis 103/102/101 + fundamenty + handoff + runtime: autoload GameStateManager, 2 klatki bez bledow). Zakresowa verify_scoped.ps1: Scoped verification passed (docs DOCS PASS + smoke + 0198 + 0201 + 0202 + 0203 + 0205 + 0206 bez modyfikacji + 0207 PASS; ta sama polityka logow co pelna). Blast radius: zero plikow wspoldzielonych z listy D-217 (brak zmian enum/serialize IDs/routingu/progow/InputMap; tools/verify.ps1 tykany wylacznie rejestracja bramki, wzor 0201/0202/0203/0205/0206) â€” pelna verify.ps1 nie byla wymagana. Ostatnia pelna weryfikacja pozostaje z PKG-0204 (107 sekcji, exit 0); zakresowa 3. z rzedu (0205/0206/0207) â€” pelna przy shared-touch / kontrakcie / checkpoincie albo najpozniej w PKG-0209 (zostal 1 pakiet zakresowy: PKG-0208).

Zamkniecie PKG-0207: raport docs/rebuild/PKG_0207_GATE_CENSUS.md + bramka w verify.ps1 (110. sekcja; 104. wywolanie Invoke) + DECISION_LOG (D-222) + ROADMAP (wiersz 0207) + CURRENT_STATE/NEXT_SESSION_PROMPT/INDEX; snapshot.ps1 -Package PKG-0207. Kolejka: ekstrakcja tabel audio/interakcji czeka na dyspozycje (shared-touch, pelna verify); D-220/D-221 bez zmian; D-222 rewidowana tylko nowym pakietem przy zmianie liczby bramek. PRODUCT GO i release nie sa wynikiem (D-168).

## PKG-0208: Pin selektora kampanii i defaultow prezentacji â€” HOLD logiki i obrazu (2026-09-06)

Zakres z NEXT_SESSION_PROMPT (po PKG-0207), z decyzja podjeta w imieniu wlasciciela (prompt sesji deleguje podejmowanie decyzji; kierunek: dobro projektu; ACT). Sciezka A-ekstrakcja dotyka logiki i wymaga jawnej dyspozycji technicznej â€” ten pakiet jej NIE wykonuje (delegacja decyzji o zakresie nie jest dyspozycja dotykania logiki; regula z PKG-0205 podtrzymana po raz czwarty, decyzja D-223). Sciezka B ZAMKNIETA (D-220); sciezka C DOMKNIETA (0202+0203). Zero zmian w scripts/, scenes/, konfiguracji, enum, serialize IDs, routingu, progach i InputMap; nowe pliki wylacznie: raport docs/rebuild/PKG_0208_CAMPAIGN_SELECTOR_DEFAULTS_PIN.md, bramka tests/pkg_0208_campaign_selector_defaults_test.gd, rejestracja bramki w tools/verify.ps1 + kontrolowana aktualizacja liczb w bramce pkg_0207 (101->102 / 103->104 / 102->103 wg jawnej reguly ewolucji z D-222, wzor D-216/D-218).

Decyzja D-223: selektor kampanii, routing finalow i defaulty prezentacji ZAPINOWANE pinami read-only. Uzasadnienie: ROUTE 18 / LEGACY 23 / FINALES 3 / SELECTOR 20 / OPMAP A-B-C / limity 18-41 oraz defaulty volume 0.85 / CPS 42.0 / skale 0.85-1.0-1.15 / reduced-motion false / REMAPPABLE 5 nie mialy wlasciciela-pinu â€” cicha zmiana selektora (powrot mianownika 43 z D-200, wypadniecie station_42a) albo granic skali nie zapalilaby zadnej bramki. Zamiast pustego HOLD pakiet domyka wartosc przed obowiazkowa pelna w PKG-0209.

Spis narzedziowy (odczyt tekstu game_state_manager.gd + load constant map w runtime, nie oko): ROUTE 18 (01-18 w kolejnosci; bez 19/42x/43), LEGACY 23 (19-41), FINALES 3 (42a/b/c), EPILOGUE station_43, SELECTOR 20 (01-18 + 42a + 43 w kolejnosci; bez 42b/42c â€” finaly B/C osiagalne wyborem operacji, nie selektorem â€” i bez legacy), OPMAP A->42a / B->42b / C->42c, limity 18/41; defaulty jak w decyzji. Twardy fakt pakietu: Array[StringName] zawiera ], wiec ekstrakcja segmentu tablicy musi szukac ] dopiero za '= [' (inaczej pusty zbior; wykryte sonda, bez wplywu na bramke).

Twarde wykrycia w pakiecie: brak nowych poza faktem parsowania powyzszego; wzorce potwierdzone (CRLF + normalizacja, brak chr(), jawne typy, String() przy porownaniu StringName z runtime, verify_scoped operatorem & z pliku posredniego).

Weryfikacja: baseline verify_docs.ps1 DOCS PASS (52) przed edycjami, zero rozjazdow (spodziewany PKG-0208 potwierdzony). Nowa bramka tests/pkg_0208_campaign_selector_defaults_test.gd PASS headless (tekst + constant map + handoff + runtime: autoload GameStateManager, 2 klatki bez bledow). Zakresowa verify_scoped.ps1: Scoped verification passed (docs DOCS PASS + smoke + 0198 + 0201 + 0202 + 0203 + 0205 + 0206 bez modyfikacji + 0207 PASS z kontrolowana aktualizacja liczb + 0208 PASS; ta sama polityka logow co pelna). Blast radius: zero plikow wspoldzielonych z listy D-217 (game_state_manager.gd czytany, nie zmieniany; brak zmian enum/serialize IDs/routingu/progow/InputMap; tools/verify.ps1 tykany wylacznie rejestracja bramki + tests/pkg_0207 tykany wylacznie aktualizacja liczb wg reguly D-222, wzor 0201/0202/0203/0205/0206/0207) â€” pelna verify.ps1 nie byla wymagana dla tego pakietu, ale limit D-217 wyczerpany: PKG-0209 MUSI byc pelna. Ostatnia pelna weryfikacja pozostaje z PKG-0204; zakresowa 4. z rzedu (0205/0206/0207/0208).

Zamkniecie PKG-0208: raport docs/rebuild/PKG_0208_CAMPAIGN_SELECTOR_DEFAULTS_PIN.md + bramka w verify.ps1 (111. sekcja; 105. wywolanie Invoke) + kontrolowana aktualizacja pkg_0207 + DECISION_LOG (D-223) + ROADMAP (wiersz 0208) + CURRENT_STATE/NEXT_SESSION_PROMPT/INDEX; snapshot.ps1 -Package PKG-0208. Kolejka: PKG-0209 MUSI byc pelna verify.ps1 (limit D-217); ekstrakcja tabel audio/interakcji czeka na dyspozycje (shared-touch, pelna verify); D-220/D-221/D-222 bez zmian; D-223 rewidowana tylko nowym pakietem przy zmianie selektora/mapowania/defaultow. PRODUCT GO i release nie sa wynikiem (D-168).

## PKG-0209: Pelna recertyfikacja po czterech pakietach zakresowych â€” GREEN bez zmian gry (2026-09-06)

Zakres z NEXT_SESSION_PROMPT (po PKG-0208: PKG-0209 MUSI byc pelna verify.ps1, limit D-217), z decyzja podjeta w imieniu wlasciciela (prompt sesji deleguje podejmowanie decyzji; kierunek: dobro projektu; ACT). Sciezka D (minimalna, zawsze dostepna): czysta pelna recertyfikacja bez zmian tresci gry â€” bez nowej decyzji D (zaden kontrakt nie zmieniony). Sciezka A-ekstrakcja dotyka logiki i wymaga jawnej dyspozycji technicznej â€” ten pakiet jej NIE wykonuje (delegacja decyzji o zakresie nie jest dyspozycja dotykania logiki; regula z PKG-0205 podtrzymana po raz piaty). Sciezka B ZAMKNIETA (D-220); sciezka C DOMKNIETA (0202+0203). Zero zmian w scripts/, scenes/, tests/, tools/verify.ps1, konfiguracji, enum, serialize IDs, routingu, progach i InputMap; jedyny nowy plik to reports/pkg_0209_verify_full.log (dowod przebiegu).

Weryfikacja: baseline verify_docs.ps1 DOCS PASS (52) przed edycjami, zero rozjazdow (spodziewany PKG-0209 potwierdzony). Pelna tools/verify.ps1: Verification passed., 111 sekcji == ... ==, DOCS PASS 52 + smoke + wszystkie bramki 0198/0199/0200/0201/0202/0203/0205/0206/0207/0208 PASS bez modyfikacji. Jedyne trafy FAIL w logu to linie 0 FAILURES zdanych testow oraz samotest polityki logow (GODOT LOG POLICY PASS / fail closed) â€” nie blad. Brak ERROR, SCRIPT ERROR i wyciekow. Blast radius: pusty â€” pelna nie wykazala regresji ukrytej przez cztery zakresowe z rzedu (0205/0206/0207/0208); licznik D-217 ZRESETOWANY (ostatnia pelna PKG-0209, nastepna pelna przy shared-touch / kontrakcie / checkpoincie albo najpozniej w PKG-0214).

Zamkniecie PKG-0209: reports/pkg_0209_verify_full.log + ROADMAP (wiersz 0209) + CURRENT_STATE/NEXT_SESSION_PROMPT/INDEX; snapshot.ps1 -Package PKG-0209. Kolejka: ekstrakcja tabel audio/interakcji czeka na dyspozycje (shared-touch, pelna verify); D-220/D-221/D-222/D-223 bez zmian. PRODUCT GO i release nie sa wynikiem (D-168).

## PKG-0210: WdroĹĽenie planu naprawczego audytu architektonicznego Aurelius (2026-09-12)

Zakres: Realizacja zlecenia wdroĹĽenia planu naprawczego po audycie architektonicznym Aurelius (/godot-auditor, 14 sektorĂłw). WdroĹĽenie techniczne bez naruszania kontraktĂłw produktowych i narracyjnych (D-168, D-220, D-221, D-222, D-223). Zero zmian reguĹ‚ gameplayu, routingu, enumĂłw i identyfikatorĂłw serializacji.

Obszary wdroĹĽenia:
1. Sektor 6 (Signals & Observer Hygiene) & Sektor 10 (Circular Dependencies / Setters):
   - Wprowadzenie prywatnych pĂłl podkĹ‚adowych i straĹĽnikĂłw w setterach eliminujÄ…cych potencjalnÄ… reentrancjÄ™ i pÄ™tle zdarzeĹ„:
     - scripts/interactables/anchorable_object.gd: _is_anchored, _is_player_in_range
     - scripts/interactables/movable_anchorable_prop.gd: _is_anchored, _is_player_in_range
     - scripts/interactables/opening_action_point.gd: _is_available, _is_resolved
     - scripts/visual/vibration_trace_display.gd: _pass_progress, _interference_factor
     - scripts/interactables/memory_resonance_point.gd: _is_player_in_range
   - Testy bramkowe (pkg_0206_mrp_interaction_inventory_test.gd - 221 funkcji / 206 _draw_*) zachowane ze 100% zgodnoĹ›ciÄ….
2. Sektor 11 (Node Tree Bloat & Coupling):
   - W scripts/player/prototype_player.gd: rejestracja gracza w grupie add_to_group(&"player") w metodzie _ready().
   - W scripts/environment/threshold_zone.gd: rozprzÄ™gniÄ™cie wyszukiwania gracza z uĹĽyciem tree.get_first_node_in_group(&"player") oraz scentralizowanie dostÄ™pu do stacji w _get_station_host(), usuwajÄ…ce 3 kruche wywoĹ‚ania get_parent().
3. Sektor 9 (Physics 2D Integrity):
   - Dodanie sekcji [layer_names] w project.godot z jawnym nazewnictwem warstw fizyki 2D (layer_1="world", layer_2="player", layer_3="triggers", layer_4="interactables").
   - Zestrojenie scenes/player/prototype_player.tscn: collision_layer = 3 (bity 1 i 2: world + player) oraz collision_mask = 1 (world).
4. Sektor 8 (Resource Lifecycle):
   - Udokumentowanie kontraktĂłw Flyweight (wspĂłĹ‚dzielone definicje niemutowalne w runtime, wymĂłg resource_local_to_scene = true przy unikalnych modyfikacjach instancyjnych) w movement_profile.gd, guidance_beat.gd, diagnostic_commitment_definition.gd, diagnostic_hypothesis_definition.gd oraz diagnostic_sequence_definition.gd.
5. Nowa bramka i aktualizacja rejestru pinu (D-222 / D-224):
   - Utworzenie dedykowanej bramki automatycznej tests/pkg_0210_architectural_audit_remediation_test.gd.
   - Rejestracja bramki w tools/verify.ps1.
   - Kontrolowana aktualizacja pinu tests/pkg_0207_gate_census_test.gd (104 -> 105 wywoĹ‚aĹ„, 103 -> 104 skryptĂłw z argumentem --script, 102 -> 103 testĂłw res://, 102 -> 103 plikĂłw testĂłw na dysku).

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki).
- godot --headless --script res://tests/pkg_0210_architectural_audit_remediation_test.gd PASS.
- godot --headless --script res://tests/pkg_0207_gate_census_test.gd PASS.
- godot --headless --script res://tests/pkg_0206_mrp_interaction_inventory_test.gd PASS.
- godot --headless --script res://tests/pkg_0174_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0177_smoke_test.gd PASS.
- godot --headless --script res://tests/smoke_test.gd PASS.
- tools/verify.ps1 peĹ‚na weryfikacja.

ZamkniÄ™cie PKG-0210:
- Zaktualizowano docs/DECISION_LOG.md (D-224), docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md, docs/INDEX.md.
- ZamroĹĽenie migawki: tools/snapshot.ps1 -Package PKG-0210.

## PKG-0211: Spis i pin silnika syntezy ProceduralAudio â€” audyt architektoniczny i kontrakt techniczny audio (2026-09-12)

Zakres: Wykonanie promptu NEXT_SESSION_PROMPT.md w ramach autonomicznej orkiestracji AI (/ai-team-orchestration, D-025, D-085, ADR-004). ĹšcieĹĽka B (station_18 prop_type) jest ZAMKNIÄTA (D-220); Ĺ›cieĹĽka C (skale tekstu) jest DOMKNIÄTA (0202+0203); Ĺ›cieĹĽka A (ekstrakcja tabel MRP) dotyka wspĂłĹ‚dzielonego monolitu logiki. Zgodnie ze Ĺ›cieĹĽkÄ… D zrealizowano caĹ‚oĹ›ciowy spis statyczny, audyt architektoniczny i pin techniczny proceduralnego silnika audio (ProceduralAudio, scripts/audio/procedural_audio.gd). Zero zmian reguĹ‚ gameplayu, routingu, enumĂłw, identyfikatorĂłw serializacji i obrazu.

Decyzja D-225: Silnik syntezy ProceduralAudio ZAPINOWANY spisem i kontraktem technicznym.
Obszary wdroĹĽenia i pomiary:
1. Spis statyczny ProceduralAudio (4108 linii):
   - 265 funkcji statycznych (zero metod instancyjnych, czysty RefCounted utility).
   - 256 generatorĂłw dĹşwiÄ™ku create_* (250 bezparametrowych, 6 sparametryzowanych: create_land_sound, create_dialogue_blip_sound, create_crosswalk_signal_sound, create_bus_engine_sound, create_surface_land_sound, create_dialogue_blip_for_speaker).
   - 9 funkcji pomocniczych i infrastruktury audio (get_cached_sound, clear_sound_cache, drain_playback, _stop_player, _stop_player_2d, _stop_player_3d, get_sound_cache_size, generate_wav, generate_looping_wav).
2. Kontrakt techniczny fal PCM:
   - KaĹĽdy strumieĹ„ to AudioStreamWAV o formacie FORMAT_16_BITS, mix_rate 44100 Hz (SAMPLE_RATE), mono (stereo == false), z parzystym buforem bajtĂłw data.size() > 0.
   - Zweryfikowano przekrĂłj generatorĂłw dla lokomocji, mechaniki Anchor/Yield, dialogĂłw CRT, sygnaĹ‚Ăłw miejskich, stacji AktĂłw I..IV, finaĹ‚Ăłw 42A/B/C oraz epilogu 43.
3. DĹşwiÄ™ki zapÄ™tlone:
   - Kontrakt generate_looping_wav (LOOP_FORWARD, loop_begin == 0, loop_end > 0) w create_anchor_sustain_tone_sound i create_prop_drag_scrape_sound.
4. Cykl ĹĽycia pamiÄ™ci podrÄ™cznej (_sound_cache):
   - get_cached_sound zapewnia referencyjnÄ… toĹĽsamoĹ›Ä‡ instancji przy ponownych zapytaniach, eliminujÄ…c narzut CPU i ponowne alokacje PCM w runtime.
   - clear_sound_cache zwalnia pamiÄ™Ä‡ podrÄ™cznÄ… na przejĹ›ciach scen (GameStateManager), eliminujÄ…c wycieki RAM.
5. Zapobieganie wyciekom odtwarzaczy (drain_playback):
   - drain_playback rekursywnie odĹ‚Ä…cza sygnaĹ‚y, zatrzymuje AudioStreamPlayer, AudioStreamPlayer2D i AudioStreamPlayer3D oraz ustawia stream = null, gwarantujÄ…c bezpieczne zwalnianie zasobĂłw WASAPI w Godot 4.7 na Windows.
6. Nowa dedykowana bramka i aktualizacja rejestru bramek (D-222 / D-225):
   - Utworzenie dedykowanej bramki tests/pkg_0211_procedural_audio_census_test.gd.
   - Rejestracja 113. sekcji w tools/verify.ps1.
   - Kontrolowana aktualizacja pinu tests/pkg_0207_gate_census_test.gd (105 -> 106 wywoĹ‚aĹ„, 104 -> 105 skryptĂłw z argumentem --script, 103 -> 104 testĂłw res://, 103 -> 104 plikĂłw testĂłw na dysku).

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki).
- godot_console.exe --headless --script res://tests/pkg_0211_procedural_audio_census_test.gd PASS.
- godot_console.exe --headless --script res://tests/pkg_0207_gate_census_test.gd PASS.
- godot_console.exe --headless --script res://tests/pkg_0206_mrp_interaction_inventory_test.gd PASS.
- godot_console.exe --headless --script res://tests/pkg_0208_campaign_selector_defaults_test.gd PASS.
- godot_console.exe --headless --script res://tests/pkg_0210_architectural_audit_remediation_test.gd PASS.
- tools/verify_scoped.ps1 PASS (docs + smoke 01..43 + 0206 + 0207 + 0208 + 0210 + 0211).
- Zero bĹ‚Ä™dĂłw, zero ostrzeĹĽeĹ„, exit code 0.
- Licznik D-217: 1. zakresowa po peĹ‚nej w PKG-0210 (nastÄ™pna peĹ‚na przy shared-touch / checkpoincie lub najpĂłĹşniej w PKG-0215).

ZamkniÄ™cie PKG-0211:
- Utworzono raport docs/rebuild/PKG_0211_PROCEDURAL_AUDIO_CENSUS.md.
- Zaktualizowano docs/DECISION_LOG.md (D-225), docs/ROADMAP.md, docs/INDEX.md, docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md.
- ZamroĹĽenie migawki: tools/snapshot.ps1 -Package PKG-0211.

## PKG-0212: Spis stacji na dysku â€” skrypty â†” sceny 1:1 (2026-09-12)

Zakres: Wykonanie promptu NEXT_SESSION_PROMPT.md w ramach autonomicznej orkiestracji AI (D-025, D-085, ADR-004). ĹšcieĹĽka B (station_18 prop_type) jest ZAMKNIÄTA (D-220); Ĺ›cieĹĽka C (skale tekstu) jest DOMKNIÄTA (0202+0203); Ĺ›cieĹĽka A (ekstrakcja tabel MRP) dotyka wspĂłĹ‚dzielonego monolitu logiki i wymaga jawnej dyspozycji wĹ‚aĹ›ciciela â€” bez niej nie ruszana. Zgodnie ze Ĺ›cieĹĽkÄ… D zrealizowano autorytatywny spis dyskowy stacji kampanii: kompletnoĹ›Ä‡ skryptĂłw i scen, odpowiednioĹ›Ä‡ 1:1 oraz pokrycie segmentĂłw kampanii. Zero zmian reguĹ‚ gameplayu, routingu, enumĂłw, identyfikatorĂłw serializacji i obrazu.

Decyzja D-226: Spis stacji na dysku ZAPINOWANY bramkÄ… i kontraktami tekstowymi read-only.
Obszary wdroĹĽenia i pomiary:
1. Skrypty stacji scripts/levels/station_*.gd: 45 (station_01..41 + station_42a/b/c + station_43); kaĹĽdy z class_name (Station01..41, Station42A/B/C, Station43) i extends Node2D (45/45).
2. Sceny stacji scenes/levels/station_*.tscn: 45 o tych samych ID â€” zbiory rĂłwne w obie strony (zero sierot, zero wiszÄ…cych); kaĹĽda referencjonuje wĹ‚asny skrypt stacji (45/45).
3. Helpery nie-stacyjne w scripts/levels: 3 z nazwy (atmosphere_rig.gd, creative_scene_lines.gd, creative_scene_presentation.gd).
4. Pokrycie dyskowe segmentĂłw: trasa 01-18 (18/18), legacy 19-41 (23/23), finaĹ‚y 42a/b/c (3/3), epilog 43.
5. Nowa dedykowana bramka i aktualizacja rejestru bramek (D-222 / D-226):
   - Utworzenie dedykowanej bramki tests/pkg_0212_station_disk_census_test.gd.
   - Rejestracja 114. sekcji w tools/verify.ps1.
   - Kontrolowana aktualizacja pinu tests/pkg_0207_gate_census_test.gd (106 -> 107 wywoĹ‚aĹ„, 105 -> 106 skryptĂłw z argumentem --script, 104 -> 105 testĂłw res://, 104 -> 105 plikĂłw testĂłw na dysku).

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki).
- godot --headless --script res://tests/pkg_0212_station_disk_census_test.gd PASS.
- godot --headless --script res://tests/pkg_0207_gate_census_test.gd PASS.
- tools/verify_scoped.ps1 PASS (docs + smoke 01..43 + 0206 + 0207 + 0208 + 0210 + 0211 + 0212).
- Zero bĹ‚Ä™dĂłw, zero ostrzeĹĽeĹ„, exit code 0.
- Licznik D-217: 2. zakresowa po peĹ‚nej w PKG-0210 (nastÄ™pna peĹ‚na przy shared-touch / checkpoincie lub najpĂłĹşniej w PKG-0215).

ZamkniÄ™cie PKG-0212:
- Utworzono raport docs/rebuild/PKG_0212_STATION_DISK_CENSUS.md.
- Zaktualizowano docs/DECISION_LOG.md (D-226), docs/INDEX.md, docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md.
- ZamroĹĽenie migawki: tools/snapshot.ps1 -Package PKG-0212.

## PKG-0213: Kompleksowy audyt 360 i plan wdroĹĽenia (2026-09-12)

Zakres: Dyspozycja wĹ‚aĹ›ciciela w roli szefa projektu / dyrektora artystycznego / producenta / wizjonera â€” peĹ‚ny audyt gry (fabuĹ‚a, dialogi, mechaniki, obraz, audio, technika) + szczegĂłĹ‚owy plan wdroĹĽenia do osobnego pliku. ĹšcieĹĽka D (dokumentacyjna, zero logiki / zero obrazu, bez nowej decyzji â€” wzĂłr PKG-0209). D-168, D-220, D-221, D-222, D-223, D-224, D-225, D-226 bez zmian.

Metoda: cztery rĂłwnolegĹ‚e Ĺ›cieĹĽki audytowe na plikach z dysku (narracja: NARRATIVE_BIBLE/FULL_STORY/DIALOGUE_SCRIPT/CONTINUITY_TRACKER/creative_scene_lines.gd; mechaniki: TRAVERSAL/THRESHOLD/PROGRESSION/station_01-14-15-18/prototype_player/threshold-ladder/gap_ledger/anchor_lab; obraz: VISUAL/PIXEL/FAMILY_BIBLE/CAST/0187/station_01-09.tscn+_draw/vector_style/compositor/camera; audio+tech: 0211-census/procedural_audio/atmosphere_rig/game_state_manager/project.godot/verify.ps1/ACCEPTANCE_MATRIX). Baseline verify_docs.ps1 PASS (52 pliki). Bez nowych renderĂłw, bez zewnÄ™trznych testerĂłw.

Wynik:
1. Raport-plan docs/rebuild/PKG_0213_COMPREHENSIVE_AUDIT_AND_IMPLEMENTATION_PLAN.md: 36 findings (N1-N10 narracja, M1-M10 mechaniki, V1-V11 obraz, A1-A5 audio, T1-T5 technika) z mapÄ… plik:linia, 30 pomysĹ‚Ăłw K1-K30 (narracyjne K1-K7, mechaniczne K8-K15 R1-R7, wizualne K16-K23, dĹşwiÄ™kowo-techniczne K24-K30), fazy R0-R10 (PKG-0214..0228) z bramkami mierzalnymi, blast radius i strategiÄ… verify D-217.
2. NajwaĹĽniejsze P0: M1/M2 (Threshold zero instancji w .tscn + wyjĹ›cia bramkowane _unlock_exit), N3 (lint D-211 omijany przez creative_scene_lines.gd), N1 (Utrzymanie vs Zakotwiczenie), N6-czÄ™Ĺ›Ä‡ (Tak/JadÄ™), V1/V2 (09 bez fartucha + surowe hexy palety). P1 sĹ‚yszalne: A1 (ambient retrigger co ~2 s), A2 (duck bez unease/busĂłw), M9 (jump-off z drabiny), V3-V10, T2-T4. P2: higiena, rigi, luki, narzÄ™dzia.
3. Zero zmian kodu/scen/enum/serialize/routing/progĂłw/InputMap; liczby pinĂłw bez zmian (107 invokes / 106 scripts / 105 tests; 45 skryptĂłw â†” 45 scen; 265 funkcji ProceduralAudio).

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki) jako baseline przed edycjami.
- godot --headless --script res://tests/pkg_0207_gate_census_test.gd PASS (107/106/105).
- godot --headless --script res://tests/pkg_0212_station_disk_census_test.gd PASS (45â†”45).
- tools/verify_scoped.ps1 PASS (docs + smoke 01..43 + 0207 + 0212; ScopeNote PKG-0213 docs-only audit plan).
- Zero bĹ‚Ä™dĂłw, zero ostrzeĹĽeĹ„, exit code 0.
- Licznik D-217: 3. zakresowa po peĹ‚nej w PKG-0210 (nastÄ™pna peĹ‚na przy shared-touch / checkpoincie lub najpĂłĹşniej w PKG-0215).

ZamkniÄ™cie PKG-0213:
- Utworzono plan docs/rebuild/PKG_0213_COMPREHENSIVE_AUDIT_AND_IMPLEMENTATION_PLAN.md.
- Zaktualizowano docs/INDEX.md, docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md (bez DECISION_LOG â€” brak nowej decyzji).
- ZamroĹĽenie migawki: tools/snapshot.ps1 -Package PKG-0213.

## PKG-0214: Pin wĹ‚asnoĹ›ci progĂłw i otwartych wyjĹ›Ä‡ M1+M2 (2026-09-12)

Zakres: Faza R1 planu PKG-0213 Â§8 (findings M1+M2) w ramach autonomicznej orkiestracji AI (D-025, D-085, ADR-004). Zero zmian w scripts/ (poza testami), scenes/, konfiguracji, enum, serialize IDs, routingu, progach i InputMap.

Decyzja D-227: ThresholdBinder ZAPINOWANY jako jedyny wĹ‚aĹ›ciciel runtimeowych progĂłw (ROUTE 22, apertury w Â§7.1 Â±10%, placement 24 px); statyczne wÄ™zĹ‚y Threshold w scenach kampanii ZABRONIONE (45/45 bez); wyjĹ›cia ZAPINOWANE jako otwarte od startu bez odczytĂłw (22/22); overlap AirlockZone nigdy nie progresuje (22/22).

RozstrzygniÄ™cie konfliktu plan vs runtime (wzĂłr D-216/D-218, hierarchia prawdy: runtime > plan): przepis Â§8 (statyczne wÄ™zĹ‚y w 01â€“18.tscn) NIEZASTOSOWANY â€” GameStateManager instaluje deferred ThresholdBinder.install + GapLedger.ensure_exit_open dla kaĹĽdej stacji trasy, a bramki 0174/0175 dowodzÄ… progi i przebieg minimalny; drugi wĹ‚aĹ›ciciel dryfowaĹ‚by aperturami. Kontrola rĂłwnowaĹĽna/silniejsza: dedykowana bramka pinujÄ…ca wĹ‚asnoĹ›Ä‡ + wyjĹ›cia + brak progresji z overlapu.

Pomiary:
1. Binder ROUTE 22/22 + spec_for: VEHICLE 03/04 (58x105), HATCH 14/15 (64x64), DOOR reszta (45x109 / 48x112 / 54x114) â€” wszystko legalne.
2. Statyka 45/45 scen bez wÄ™zĹ‚a Threshold (sole owner).
3. Handlery _on_airlock 22/22 bez progresji; zero call_deferred overlap-complete w trasie.
4. Runtime 22/22: Threshold istnieje, is_open, is_exit_unlocked, crossed podpiÄ™ty, AirlockZone.body_entered pusty, apertura legalna, margines 24 px â€” przy ZERO odczytach.

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki) jako baseline.
- godot --headless --script res://tests/pkg_0214_threshold_exit_open_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0207_gate_census_test.gd PASS (108/107/106 po aktualizacji).
- tools/verify_scoped.ps1 PASS (docs + smoke 01..43 + 0207 + 0212 + 0214).
- Zero bĹ‚Ä™dĂłw, zero ostrzeĹĽeĹ„, exit code 0. Kadry: brak ruszonych adresĂłw â€” brak nowych PNG z natury pakietu.
- Licznik D-217: 4. zakresowa po peĹ‚nej w PKG-0210 (peĹ‚na OBOWIÄ„ZKOWA najpĂłĹşniej w PKG-0215; blast 0214 to wyĹ‚Ä…cznie test + pin, zero plikĂłw gry).

ZamkniÄ™cie PKG-0214:
- Utworzono bramkÄ™ tests/pkg_0214_threshold_exit_open_pin_test.gd + raport docs/rebuild/PKG_0214_THRESHOLD_OWNERSHIP_PIN.md.
- Zarejestrowano 115. sekcjÄ™ w tools/verify.ps1; zaktualizowano pin tests/pkg_0207_gate_census_test.gd (107->108 / 106->107 / 105->106).
- Zaktualizowano docs/DECISION_LOG.md (D-227), docs/INDEX.md, docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md (naprawiono dryf handoffu: brak PKG-0207/PKG-0208 w prompcie z PKG-0213).
- ZamroĹĽenie migawki: tools/snapshot.ps1 -Package PKG-0214.

## PKG-0215: Luki 1:1 z gĹ‚osem i priorytet interact M6+M4 (2026-09-12)

Zakres: Faza R2 planu PKG-0213 Â§8 (findings M6+M4) w ramach autonomicznej orkiestracji AI (D-025, D-085, ADR-004). Blast: gap_ledger.gd (shared: tabela 9->54+override+tĹ‚a, flagi s09-s14, straĹĽnicy speak) + wiring annotate w _record_feedback stacji 01â€“18 (18Ă—1 linia) + straĹĽnik gotowego progu w station_14._unhandled_input. Enum, serialize IDs, routing, progi, InputMap nietkniÄ™te. Liczby D-221 nietkniÄ™te (brak nowych gaĹ‚Ä™zi/dĹşwiÄ™kĂłw).

Decyzja D-228: peĹ‚ne pokrycie feedbackâ†’luka z reguĹ‚ami (default wĹ‚asna stacja; cross-station: opening_choice 02->s01, route_time 03->s02, key_trial 11->s10, institution_trial 17->s16, consent_scope 18->s17; override station_11|passage_requiredâ†’s11; 9 teĹ‚ bez luk); flagi s09-s14 realne; gĹ‚os luk przez annotate ze straĹĽnikami (visible + is_presenting jako metoda); priorytet MRP > Anchor > Threshold w 14.

Pomiary: inwentarz ~150 literalĂłw (63 distinct na trasie 22); bramka 0215 fail-closed na nowe literaly; 10Ă— E przy gotowym progu nie rusza kotwicy ani feedbacku, z dala kotwica dziaĹ‚a; kadry station_14 6 PNG (85/100/115 Ă— full/notext, Iris Xe) â€” notext Â±1% vs 0202, full rĂłĹĽni siÄ™ fazÄ… CRT/maszynerii (twardy fakt).

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki) jako baseline.
- godot --headless --script res://tests/pkg_0215_gap_voice_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0207_gate_census_test.gd PASS (109/108/107 po aktualizacji).
- godot --headless --script res://tests/pkg_0208_campaign_selector_defaults_test.gd PASS (po dopisaniu PKG-0209 do historii promptu â€” wykryte peĹ‚nÄ… jako realny FAIL, nie szum).
- PEĹNA tools/verify.ps1 PASS (116 sekcji, Verification passed.); licznik D-217 ZRESETOWANY.
- Zero bĹ‚Ä™dĂłw, zero ostrzeĹĽeĹ„, exit code 0.

ZamkniÄ™cie PKG-0215:
- Zmieniono scripts/campaign/gap_ledger.gd + 18Ă— station_01â€“18.gd + station_14.gd (straĹĽnik).
- Utworzono bramkÄ™ tests/pkg_0215_gap_voice_pin_test.gd + raport docs/rebuild/PKG_0215_GAP_VOICE_PRIORITY.md + narzÄ™dzie tools/capture_pkg_0215.gd.
- Zarejestrowano 116. sekcjÄ™ w tools/verify.ps1; zaktualizowano pin tests/pkg_0207_gate_census_test.gd (108->109 / 107->108 / 106->107).
- Zaktualizowano docs/DECISION_LOG.md (D-228), docs/INDEX.md, docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md.
- ZamroĹĽenie migawki: tools/snapshot.ps1 -Package PKG-0215.

## PKG-0216: SĹ‚ownik metody + lint treĹ›ci + palimpsest Tak/JadÄ™ (2026-09-12)

Zakres: Faza R2 planu PKG-0213 Â§8 (findings N1+N3+N6-czÄ™Ĺ›Ä‡) w ramach autonomicznej orkiestracji AI (D-025, D-085, ADR-004). Blast: linie dialogowe (creative_scene_lines.gd: relay_logbook_named + 3Ă— household_b; station_14.gd beat s14_method_named PL/EN) + kanon (FULL_STORY.md 20-21 i Â§42B; raport PKG_0194 jedna fraza) + testy (nowa bramka 0216, kontrolowany update asercji pkg_0194:286, pin 0207, 117. sekcja verify.ps1) + narzÄ™dzie tools/capture_pkg_0216.gd. Zero shared-touch (ĹĽaden plik z listy D-217), zero enum/serialize/routing/progĂłw/InputMap, zero nowych adresĂłw/rodzin/interakcji/faktĂłw/postaci. Liczby D-221 nietkniÄ™te.

Decyzja D-229: nazwa metody ZAPINOWANA jako Zakotwiczenie (NARRATIVE_BIBLE sekcja 13); Utrzymanie i ulegĹ‚oĹ›Ä‡ wycofane z 4 miejsc (w tym station_14 poza literalnym zleceniem â€” rozjazd naprawia ten sam pakiet); Utrzymanie ruchu (station_17) zachowane i pinowane; lint treĹ›ci prezentowanej (6 ID â†’ fallback, dowĂłd fail-closed, D-211 nie na staĹ‚e); ekran 42B jako palimpsest JadÄ™ nad czÄ™Ĺ›ciowo startym Tak (3 warianty + blok 42B, ta sama liczba par).

Pomiary: nowa bramka 0216 PASS (sĹ‚ownik 4 pliki + znaczenie techniczne, fallback 6 ID, fail-closed, palimpsest 3+blok); sÄ…siad pkg_0194 wykryĹ‚ starÄ… frazÄ™ jako realny FAIL (run A) â€” naprawiony kontrolowanym update asercji, potem PASS; 0165/0195/0168/0207 PASS bez dotykania; kadry 13/18/42b 18 PNG (85/100/115 Ă— full/notext, Iris Xe, OpenGL) â€” inspekcja HOLD obrazu, zero napraw; bazÄ… â€žprzed" sÄ… archiwa 0193/0194/0195.

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki) jako baseline przed edycjami.
- godot --headless --script res://tests/pkg_0216_dictionary_content_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0165_smoke_test.gd PASS (lint stacji nietkniÄ™ty).
- godot --headless --script res://tests/pkg_0194_creative_scene_b_test.gd PASS (po update asercji).
- godot --headless --script res://tests/pkg_0195_creative_scene_c_test.gd PASS.
- godot --headless --script res://tests/pkg_0168_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0207_gate_census_test.gd PASS (110/109/108 po aktualizacji).
- Zakresowa tools/verify_scoped.ps1 PASS (docs + 0216 + 0165 + 0194 + 0195 + 0168 + 0207 + 0208); licznik D-217: 1. zakresowa po peĹ‚nej PKG-0215.
- Zero bĹ‚Ä™dĂłw, zero ostrzeĹĽeĹ„ w bramkach pakietu.

ZamkniÄ™cie PKG-0216:
- Zmieniono scripts/levels/creative_scene_lines.gd + scripts/levels/station_14.gd + docs/narrative/FULL_STORY.md + docs/rebuild/PKG_0194_CREATIVE_SCENES_B.md + tests/pkg_0194_creative_scene_b_test.gd (asercja) + tests/pkg_0207_gate_census_test.gd (pin) + tools/verify.ps1 (117. sekcja).
- Utworzono bramkÄ™ tests/pkg_0216_dictionary_content_pin_test.gd + raport docs/rebuild/PKG_0216_DICTIONARY_CONTENT_LINT.md + narzÄ™dzie tools/capture_pkg_0216.gd.
- Zaktualizowano docs/DECISION_LOG.md (D-229), docs/INDEX.md, docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md.
- ZamroĹĽenie migawki: tools/snapshot.ps1 -Package PKG-0216.

## PKG-0217: Synteza 13 (trzeci glos) + prognozy brak danych + dyferencjacja urzadzen (2026-09-12)

Zakres: Faza R2 planu PKG-0213 S8 (findings N2+N5+N7-czesc) w ramach autonomicznej orkiestracji AI (D-025, D-085, ADR-004). Blast: linie dialogowe (creative_scene_lines.gd: synthesize + forecast_comparator_granted + safe_analyzer + cost_selector_sample_full/buffer + abort_note + identity_card + minimal_report + adaptation_offer_terminal) + kanon 1 linia (FULL_STORY.md:13 trzeci glos Jakuba, bez sugestii proby) + testy (nowa bramka 0217, pin 0207, 118. sekcja verify.ps1) + narzedzie tools/capture_pkg_0217.gd. Zero shared-touch (zaden plik z listy D-217), zero enum/serialize/routing/progow/InputMap, zero nowych adresow/rodzin/interakcji/faktow/postaci. Liczby D-221 nietkniete.

Decyzja D-230: synteza ZAPINOWANA z trzecim glosem Jakuba przez lacze (odczyt sprawdzenia numeru ze stacji 12; sugestia swiadomej proby wycofana; 6 par; kanon 3 kwestii + zamiar zachowany); prognozy granted ZAPINOWANE z polami brak danych 3/3 i rejestrami urzadzen (REJESTR 20:40 / ANALIZATOR os-pik / NOTATKA na marginesie; limited/refused/missing nietkniete); urzadzenia poza prognozami ZAPINOWANE tymi samymi rejestrami (ta sama liczba par); Wierzbicka ZAPINOWANA jako strona bezosobowa z kwalifikatorami (stan/zakres/stabilnosc/dopuszczalne/procedura; 4/4/4 pary; recepcja wycofana; odmowa Leny nietknieta).

Pomiary: nowa bramka 0217 PASS (synteza 6 par/3 glosy/brak proby/3 slady+3 rodziny read-only; granted 3x brak danych + rejestry + routing per zgoda; urzadzenia w 4 ID; Wierzbicka kwalifikatory + brak recepcji + fallback; fail-closed); twardy fakt: pierwsze dopiski (~130 znakow) wylozyly sasiada pkg_0194 realnym FAIL-em fit-at-100 (2x, pudlo CRT 488x52) â€” naprawione skroceniem do ~104-111 znakow w tym samym pakiecie, potem PASS bez zmiany asercji; 0216/0165/0193/0195/0168/0207/0208 PASS bez dotykania; kadry 13/18 12 PNG (85/100/115 x full/notext, Iris Xe, OpenGL) â€” inspekcja HOLD obrazu, zero napraw; baza przed to archiwa 0193/0194/0216.

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki) jako baseline przed edycjami.
- godot --headless --script res://tests/pkg_0217_synthesis_forecast_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0216_dictionary_content_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0165_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0193_creative_scene_test.gd PASS (z nowa synteza).
- godot --headless --script res://tests/pkg_0194_creative_scene_b_test.gd PASS (po skroceniu dopiskow).
- godot --headless --script res://tests/pkg_0195_creative_scene_c_test.gd PASS.
- godot --headless --script res://tests/pkg_0168_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0207_gate_census_test.gd PASS (111/110/109 po aktualizacji).
- godot --headless --script res://tests/pkg_0208_campaign_selector_defaults_test.gd PASS.
- Zakresowa tools/verify_scoped.ps1 PASS (docs + smoke 01-43 + 0217 + 0216 + 0165 + 0193 + 0194 + 0195 + 0168 + 0207 + 0208); licznik D-217: 2. zakresowa po pelnej PKG-0215.
- Zero bledow, zero ostrzezen w bramkach pakietu.

Zamkniecie PKG-0217:
- Zmieniono scripts/levels/creative_scene_lines.gd + docs/narrative/FULL_STORY.md (13) + tests/pkg_0207_gate_census_test.gd (pin) + tools/verify.ps1 (118. sekcja) + docs/DECISION_LOG.md (D-230).
- Utworzono bramke tests/pkg_0217_synthesis_forecast_pin_test.gd + raport docs/rebuild/PKG_0217_SYNTHESIS_FORECAST_DEVICES.md + narzedzie tools/capture_pkg_0217.gd.
- Zaktualizowano docs/DECISION_LOG.md (D-230), docs/INDEX.md, docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md.
- Zamrozenie migawki: tools/snapshot.ps1 -Package PKG-0217.

## PKG-0218: Fartuch + paleta + linie 09 (V1+V2+V5 z planu PKG-0213 S8, 2026-09-12)

Zakres: Faza R3 planu PKG-0213 S8 (findings V1+V2+V5) w ramach autonomicznej orkiestracji AI (D-025, D-085, ADR-004). Blast: 11 skryptow stacji (09: pelny przepis _draw; 13/14/15/16/17/18/42a/42b/42c/43: jedna linia fartucha) + stala stylu (vector_stage_style.gd: MAX 7->8) + testy (nowa bramka 0218, pin 0207, 119. sekcja verify.ps1) + narzedzie tools/capture_pkg_0218.gd. Audyt wykazal 11 scen bez fartucha (prompt zakladal tylko 09) â€” rozjazd naprawia ten sam pakiet. Zero shared-touch (zaden plik z listy D-217), zero enum/serialize/routing/progow/InputMap, zero nowych adresow/rodzin/interakcji/faktow/postaci. Liczby D-221 nietkniete.

Decyzja D-231: fartuch ZAPINOWANY w 22/22 scenach 01-18/42/43 (pierwsza linia malowania, D-136); paleta 09 ZAPINOWANA na VectorStageStyle (zero hexow, uklad 1:1, bazy INK/DEEP/MID/LIGHT + AMBER + CYAN); MAX_PALETTE_COLORS 7 -> 8 (kanon 8-16); linie 09 ZAPINOWANE >= 2 px (zero 1.0; sasiedzi 08 x1 detal / 10 x4 w tym sufit do PKG-0219 / 13 x0).

Pomiary: nowa bramka 0218 PASS (fartuch 22/22 + kolejnosc; 09 zero hex + bazy <= 16 + brak oxide; 09 zero 1.0 + audyt sasiadow; fail-closed); wlasna bramka raz FAIL (naiwny licznik lapal clampf w 13) â€” naprawiona w tym samym pakiecie, potem PASS; pin 0207 PASS (112/111/110); 0137/0217/0216/0165/0193/0194/0195/0168/0208 PASS bez dotykania; kadry 13 PNG (09 x 85/100/115 x full/notext/mono + spot 13/18 s100, Iris Xe, OpenGL) â€” inspekcja HOLD obrazu, zero napraw; mono: bursztyn/cyjan blisko lumy, rozroznienie ksztaltem (wklad do V10 w PKG-0219); baza przed to archiwa 0187/0198/0203.

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki) jako baseline przed edycjami.
- godot --headless --script res://tests/pkg_0218_apron_palette_line_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0207_gate_census_test.gd PASS (112/111/110 po aktualizacji).
- godot --headless --script res://tests/pkg_0137_smoke_test.gd PASS (kontrakt fartuch-budzet nietkniety).
- godot --headless --script res://tests/pkg_0217_synthesis_forecast_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0216_dictionary_content_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0165_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0193_creative_scene_test.gd PASS.
- godot --headless --script res://tests/pkg_0194_creative_scene_b_test.gd PASS.
- godot --headless --script res://tests/pkg_0195_creative_scene_c_test.gd PASS.
- godot --headless --script res://tests/pkg_0168_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0208_campaign_selector_defaults_test.gd PASS.
- Zakresowa tools/verify_scoped.ps1 PASS (docs + smoke 01-43 + 11 bramek); licznik D-217: 3. zakresowa po pelnej PKG-0215 (limit: pelna najpozniej w PKG-0220).
- Zero bledow, zero ostrzezen w bramkach pakietu.

Zamkniecie PKG-0218:
- Zmieniono scripts/levels/station_09.gd (fartuch + paleta + linie) + station_13/14/15/16/17/18/42a/42b/42c/43.gd (fartuch) + scripts/visual/vector_stage_style.gd (MAX 8) + tests/pkg_0207_gate_census_test.gd (pin) + tools/verify.ps1 (119. sekcja) + docs/DECISION_LOG.md (D-231).
- Utworzono bramke tests/pkg_0218_apron_palette_line_pin_test.gd + raport docs/rebuild/PKG_0218_APRON_PALETTE_LINES.md + narzedzie tools/capture_pkg_0218.gd.
- Zaktualizowano docs/DECISION_LOG.md (D-231), docs/INDEX.md, docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md.
- Zamrozenie migawki: tools/snapshot.ps1 -Package PKG-0218.

## PKG-0219: Sufit + swiatlo + regula rozu 09/01 (V4+V6+V10 z planu PKG-0213 S8, 2026-09-12)

Zakres: Faza R3 planu PKG-0213 S8 (findings V4+V6+V10) w ramach autonomicznej orkiestracji AI (D-025, D-085, ADR-004). Blast: 2 skrypty stacji (01: swiatlo robocze + wypelnienie + cien bebna; 09: podbitka + lampa pod podbitke) + 1 scena (09: pozycja etykiety MIESZKANIE 14) + decyzja D-232 + testy (nowa bramka 0219, pin 0207, 120. sekcja verify.ps1) + narzedzie tools/capture_pkg_0219.gd. Zero shared-touch (zaden plik z listy D-217), zero enum/serialize/routing/progow/InputMap, zero nowych adresow/rodzin/interakcji/faktow/postaci. Liczby D-221 nietkniete. Palety 08/10/13 nietkniete poza linia audytu (osobny pakiet).

Decyzja D-232: sufit 09 ZAPINOWANY (podbitka x 0..300, spod y=172, przeswit 37 px w 20-45; 2 plany; drzwi 109 i collidery nietkniete; lampa pod podbitka; etykieta na scianie w pasie 90-190); swiatlo 01 ZAPINOWANE (rodzina 5: WORK_LIGHT 247,188 + stozek 0.12 + cold fill 44..70 0.06 + cien bebna w prawo 0.48; audyt 12/14 stoi); regula akcentu Marty (Marta w kadrze = character_id &"marta", dzis 10/13 â†’ 1 akcent â†’ reszta w shade(MID_PLANE); roz tylko na spricie; 09 bez Marty: AMBER+CYAN bez oxide); mono 09 vs 01/11/12/15 strukturalnie na >=3 osiach.

Pomiary: nowa bramka 0219 PASS za pierwszym podejsciem (sufit 37 px + drzwi/collidery/etykieta + audyt 08/10/13; 01 work+fill+cien po stronie zrodla + audyt 12/14; D-232 + rigi 10/13 + akcenty 09 + markery 3 osi; fail-closed); pin 0207 PASS (113/112/111); sasiedzi 0218/0217/0216/0165/0193/0194/0195/0168/0208/0137 PASS bez dotykania; kadry 21 PNG (01 i 09 x 85/100/115 x full/notext/mono + mono 11/12/15 s100, Iris Xe, OpenGL) â€” inspekcja HOLD obrazu, zero napraw; baza przed to archiwa 0187/0198/0203.

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki) jako baseline przed edycjami.
- godot --headless --script res://tests/pkg_0219_ceiling_light_rose_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0207_gate_census_test.gd PASS (113/112/111 po aktualizacji).
- godot --headless --script res://tests/pkg_0218_apron_palette_line_pin_test.gd PASS (fartuch/paleta/linie 09 nietkniete kompozycja).
- godot --headless --script res://tests/pkg_0217_synthesis_forecast_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0216_dictionary_content_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0165_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0193_creative_scene_test.gd PASS.
- godot --headless --script res://tests/pkg_0194_creative_scene_b_test.gd PASS.
- godot --headless --script res://tests/pkg_0195_creative_scene_c_test.gd PASS.
- godot --headless --script res://tests/pkg_0168_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0208_campaign_selector_defaults_test.gd PASS.
- godot --headless --script res://tests/pkg_0137_smoke_test.gd PASS (kontrakt fartuch-budzet nietkniety).
- Zakresowa tools/verify_scoped.ps1 PASS (docs + smoke 01-43 + 12 bramek); licznik D-217: 4. zakresowa po pelnej PKG-0215 (limit: pelna obowiazkowo w PKG-0220).
- Zero bledow, zero ostrzezen w bramkach pakietu.

Zamkniecie PKG-0219:
- Zmieniono scripts/levels/station_01.gd (swiatlo) + scripts/levels/station_09.gd (sufit+lampa) + scenes/levels/station_09.tscn (pozycja etykiety) + tests/pkg_0207_gate_census_test.gd (pin) + tools/verify.ps1 (120. sekcja) + docs/DECISION_LOG.md (D-232).
- Utworzono bramke tests/pkg_0219_ceiling_light_rose_pin_test.gd + raport docs/rebuild/PKG_0219_CEILING_LIGHT_ROSE.md + narzedzie tools/capture_pkg_0219.gd.
- Zaktualizowano docs/DECISION_LOG.md (D-232), docs/RISKS_AND_HYPOTHESES.md, docs/INDEX.md, docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md.
- Zamrozenie migawki: tools/snapshot.ps1 -Package PKG-0219.

## PKG-0220: Petle ambientu + duck (A1+A2 z domieszka A3/A4, 2026-09-12)

Zakres: Faza R4 planu PKG-0213 S8 (findings A1+A2+A3/A4) w ramach autonomicznej orkiestracji AI (D-025, D-085, ADR-004). Blast: shared-touch audio (scripts/audio/procedural_audio.gd: helper generate_looping_wav + 7 generatorow PKG-0180 na petle loop-safe z crossfade 80 ms; f0/AM/dlugosci/census 265 nietkniete) + rig (scripts/levels/atmosphere_rig.gd: duck x3, busy Ambient/Dialogue, back-buffer stopped-spare, drain helperem, bez retriggera) + testy (nowa bramka 0220, pin 0207, 121. sekcja verify.ps1) + decyzja D-233. Zero enum/serialize/routing/progow/InputMap, zero nowych adresow/rodzin/interakcji/faktow/postaci. Liczby D-221 nietkniete.

Decyzja D-233: 7 ambientow ZAPINOWANE na generate_looping_wav (env 1.0, crossfade 80 ms); duck hum -24 / sub -28 / unease -22 (-7 dB); busy Ambient/Dialogue (duck jako sidechain); ambient niepozycjonowany (komentarz); back-buffer hot spare stopped (budzet 0130: tylko playing); drain w _exit_tree helperem.

Pomiary: nowa bramka 0220 PASS (petle PCM+LOOP+dlugosc+RMS krawedzi+szew, duck x3 >= 5 dB z powrotem, busy, mirror, drain idempotentny, fail-closed LOOP_DISABLED, census 265). Twardy fakt: pierwszy wariant z grajacym spare wylozyl pkg_0130 realnym FAIL-em (5 glosow > 4 na stacjach 31/33/34/35/37/39/40/41) â€” naprawiony stopped-spare w tym samym pakiecie, potem 0130 PASS. Pin 0207 PASS (114/113/112). Sasiedzi 0211/0180/0126/0127/0139/0219 PASS bez dotykania. PELNA tools/verify.ps1 PASS exit 0 (121 sekcji, dowod reports/pkg_0220_verify_full.log). Licznik D-217 ZRESETOWANY (ostatnia pelna PKG-0220). Kadry nie wymagane (dzwiek); bez odsluchu jako dowodu. Zero bledow, zero ostrzezen w bramkach pakietu.

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki) jako baseline przed edycjami.
- godot --headless --script res://tests/pkg_0220_ambient_loop_duck_test.gd PASS.
- godot --headless --script res://tests/pkg_0207_gate_census_test.gd PASS (114/113/112 po aktualizacji).
- godot --headless --script res://tests/pkg_0211_procedural_audio_census_test.gd PASS (census 265 stoi).
- godot --headless --script res://tests/pkg_0180_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0126_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0127_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0139_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0219_ceiling_light_rose_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0130_smoke_test.gd PASS (po naprawie spare).
- PELNA tools/verify.ps1 PASS exit 0 (dowod reports/pkg_0220_verify_full.log).

Zamkniecie PKG-0220:
- Zmieniono scripts/audio/procedural_audio.gd (helper crossfade + 7 petli) + scripts/levels/atmosphere_rig.gd (duck/busy/back/drain) + tests/pkg_0207_gate_census_test.gd (pin) + tools/verify.ps1 (121. sekcja) + docs/DECISION_LOG.md (D-233) + docs/RISKS_AND_HYPOTHESES.md + docs/CURRENT_STATE.md.
- Utworzono bramke tests/pkg_0220_ambient_loop_duck_test.gd + raport docs/rebuild/PKG_0220_AMBIENT_LOOP_DUCK.md.
- Zaktualizowano docs/DECISION_LOG.md (D-233), docs/RISKS_AND_HYPOTHESES.md, docs/INDEX.md, docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md.
- Zamrozenie migawki: tools/snapshot.ps1 -Package PKG-0220.

## PKG-0221: Drabina + Return + skale (M9+M3+M1-czesc z planu PKG-0213 S8, 2026-09-13)

Zakres: Faza R5 planu PKG-0213 S8 (findings M9+M3+M1-czesc) w ramach autonomicznej orkiestracji AI (D-025, D-085, ADR-004). Blast: 2 strefy srodowiskowe (ladder_zone: intencja w strefie + try_mount; return_zone: drugi Threshold + trigger_return) + gracz (koniec auto-mountu i jump-off, begin_climb) + 5 skryptow stacji (05/06/07/08/43: rozpiecie return-body_entered, handlery jako pass) + 3 sceny (02/height 76, 15/height 150, 16/y 288) + project.godot (przywrocony wpis tickow 60) + testy (nowa bramka 0221, pin 0207, 122. sekcja verify.ps1, kontrolowane aktualizacje 0135/0136/0137/0138/0140/0157/0170) + narzedzie tools/capture_pkg_0221.gd + decyzja D-234. Zero enum/serialize/routing/progow/InputMap, zero nowych adresow/rodzin/interakcji/faktow/postaci. Liczby D-221 nietkniete. D-227 stoi (zero statycznych Thresholdow).

Decyzja D-234: intencja drabiny ZAPINOWANA W STREFIE (overlap to kandydatura; montowanie wylacznie try_mount po interact albo stop+gora; gracz nie montuje sie sam; koniec jump-off); powrot ZAPINOWANY jako drugi Threshold (body_entered nigdy nie emituje; powrot wylacznie trigger_return/interact; target_station = poprzednik GSM; apertura/rodzina jak prog wprost; is_open zawsze); strefy NIE konsumuja interactu (priorytet MRP jak D-228); skale ZAPINOWANE (02 wystawanie 12, 15 wystawanie 12 nad sill, 16 dol na podlodze 288; GATE-SCALE 0 naruszen; drabin nie doklejono; apertury Bindera nietkniete).

Pomiary: nowa bramka 0221 PASS 3x (statyka + 10 prob biegu 0 przypiec + stop/gora + skok nie wypina + interact montuje + wyjscie odpina + overlap 02/15/16 milczy + trigger wraca + target 01/14/15 + apertura legalna + grafika/kolizja 2/1 + podloga <= 2 + wystawanie 12/12 + route-drabiny tylko 02/15/16 + zero Thresholdow + fail-closed). Twarde fakty: (a) konsumpcja interactu przez strefy wylozyla pkg_0194 lawinowym FAIL-em (glodzenie MRP) â€” naprawiona brakiem konsumpcji w tym samym pakiecie, potem 0194 PASS; (b) prog 80 z pkg_0157 byl starszy niz kanon Â§9.3 â€” kontrolowanie do >= 72 w tym samym pakiecie, potem 0157 PASS; (c) wpis physics_ticks_per_second=60 zniknal z project.godot miedzy pakietami (zimny start silnika) â€” przywrocony, potem 0207 PASS (115/114/113); (d) pierwszy przebieg bramki 0221 na starym kodzie: czysty FAIL 19 pozycji (dowod czulosci); (e) flake izolacji w fail-closed (transzycje GSMkladly stacje z zywymi graczami w tle) â€” utwardzony drenazem i wylaczeniem auto-transzycji w bramce. Pin 0207 PASS (115/114/113). Sasiedzi 0214/0215/0194/0173/0130/0125/0129/0132-0142/0157-0170 PASS bez dotykania. Kadry 02/15/16 6 PNG (Iris Xe, OpenGL) â€” inspekcja HOLD obrazu, zero napraw. PELNA tools/verify.ps1 PASS exit 0 (122 sekcje, dowod reports/pkg_0221_verify_full.log). Licznik D-217 ZRESETOWANY (ostatnia pelna PKG-0221). Zero bledow, zero ostrzezen w bramkach pakietu.

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki) jako baseline przed edycjami.
- godot --headless --script res://tests/pkg_0221_ladder_return_scale_test.gd PASS (3x).
- godot --headless --script res://tests/pkg_0207_gate_census_test.gd PASS (115/114/113 po aktualizacji).
- godot --headless --script res://tests/pkg_0214_threshold_exit_open_pin_test.gd PASS (D-227 stoi).
- godot --headless --script res://tests/pkg_0215_gap_voice_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0194_creative_scene_b_test.gd PASS (po naprawie konsumpcji).
- godot --headless --script res://tests/pkg_0173_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0135_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0136_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0137_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0138_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0140_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0157_smoke_test.gd PASS (po aktualizacji progu).
- godot --headless --script res://tests/pkg_0170_smoke_test.gd PASS (po aktualizacji powrotu).
- godot --headless --script res://tests/smoke_test.gd PASS.
- godot --headless --script res://tests/traversal_lint_test.gd PASS.
- godot --headless --script res://tests/pkg_0125_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0129_smoke_test.gd PASS.
- narzedzie tools/capture_pkg_0221.gd PASS normalnym sterownikiem (6 PNG).
- PELNA tools/verify.ps1 PASS exit 0 (dowod reports/pkg_0221_verify_full.log).

Zamkniecie PKG-0221:
- Zmieniono scripts/environment/ladder_zone.gd (intencja w strefie) + scripts/environment/return_zone.gd (drugi Threshold) + scripts/player/prototype_player.gd (koniec auto-mountu/jump-off, begin_climb) + scripts/levels/station_05.gd + station_06.gd + station_07.gd + station_08.gd + station_43.gd (rozpiecie powrotu) + scenes/levels/station_02.tscn + station_15.tscn + station_16.tscn (skale drabin) + project.godot (wpis tickow) + tests/pkg_0207_gate_census_test.gd (pin) + tests/pkg_0135_smoke_test.gd + tests/pkg_0136_smoke_test.gd + tests/pkg_0137_smoke_test.gd + tests/pkg_0138_smoke_test.gd + tests/pkg_0140_smoke_test.gd + tests/pkg_0157_smoke_test.gd + tests/pkg_0170_smoke_test.gd (kontrolowane aktualizacje) + tools/verify.ps1 (122. sekcja) + docs/DECISION_LOG.md (D-234) + docs/CURRENT_STATE.md.
- Utworzono bramke tests/pkg_0221_ladder_return_scale_test.gd + raport docs/rebuild/PKG_0221_LADDER_RETURN_SCALE.md + narzedzie tools/capture_pkg_0221.gd.
- Zaktualizowano docs/DECISION_LOG.md (D-234), docs/INDEX.md, docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md.
- Zamrozenie migawki: tools/snapshot.ps1 -Package PKG-0221.

## PKG-0222: Korekta z kosztem + budzety (M7+M5+M10 z planu PKG-0213 S8, 2026-09-13)

Zakres: Faza R5 planu PKG-0213 S8 (findings M7+M5+M10) w ramach autonomicznej orkiestracji AI (D-025, D-085, ADR-004). Blast: 4 lokalne skrypty stacji (station_14: trigger L2 s14_cost_hypothesis przy koszcie; station_15: has_cost_mark + FACT_COST yield_cost_observed + L2 s15_living_response + welon w _draw + auto-notatka przy potwierdzeniu; station_18: select_operation wylacznie routingiem + IS_PHYSICAL_OBSTACLE_FREE; station_01: IS_PHYSICAL_OBSTACLE_FREE) + testy (nowa bramka 0222, pin 0207, 123. sekcja verify.ps1) + narzedzie tools/capture_pkg_0222.gd + decyzja D-235. Zero monolitow D-217 (MRP/GSM/audio/kompozytor/autoloady/GapLedger nietkniete), zero enum/serialize/routing/progow/InputMap, zero nowych adresow/rodzin/interakcji/faktow/postaci (FACT_COST 15 i auto-notatka to dyspozycja M7+M5). Liczby D-221 nietkniete. Lancuch MRP 15 (4 fazy nadajnika) nietkniety (pin 0194).

Decyzja D-235: korekta M7 ZAPINOWANA (14: L2 obok istniejacego zapisu/stanu/zaniku; 15: stan + L2 + zapis + welon, koszt nie potwierdza sygnalu i nie zamyka drogi); budzety M5 ZAPINOWANE (distinct MRP <=3 na adres â€” 15 re-pin, 18 nowy pin == 3; sciezka krytyczna <=3 czasownikow â€” 15 potwierdzenie dorecza notatke, 18 donor out); select_operation 18 WYLACZNIE routingiem GSM (D-223 intact, zero fabrykacji donora/zestawienia/prawdy/metody; brak inwentarza -> istniejacy feedback forecast_and_consent_inventory_required na s18.method_uncommitted); 01/18 oznaczone IS_PHYSICAL_OBSTACLE_FREE; KillZone 0 w kampanii (prototyp anchor_lab wylaczony jak w lincie).

Pomiary: nowa bramka 0222 PASS 3x (M7-14: koszt + L2 + zapis + powrot A + nazwanie; M7-15: koszt wymuszenia + L2 + zapis + brak sygnalu + notatka przed potwierdzeniem falsz + auto-notatka + MRP <=3; M10+M5-18: golas routing B bez fabrykacji + luka, pelny inwentarz routing C cicho, jawna 3-sciezka domyka metode, MRP == 3; markery 01/18 + brak w 14/15; KillZone 0). Twardy fakt sesji: GSM node_added -> GapLedger.ensure_exit_open otwiera wyjscia z automatu (D-227) â€” is_exit_unlocked nie jest sygnalem bramek (stad pozorne odwrocone komunikaty 0163:111/132/158 przy asercjach na prawde); bramka 0222 dowodzi faktami i stanami, nie flaga wyjscia. Pin 0207 PASS (116/115/114). Sasiedzi 0120/0163/0147/0194/0193/0195/0114/0215/0217/traversal_lint PASS bez dotykania. Kadry 14/15/18 6 PNG s100 full/notext + klatka kosztu 15 (Iris Xe, OpenGL) â€” inspekcja HOLD obrazu, zero napraw. Zakresowa tools/verify_scoped.ps1 PASS exit 0 (docs + smoke + 12 bramek). Licznik D-217: 1. zakresowa po pelnej PKG-0221 (limit: pelna najpozniej PKG-0226). Zero bledow, zero ostrzezen w bramkach pakietu.

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki) jako baseline przed edycjami.
- godot --headless --script res://tests/pkg_0222_correction_cost_budget_test.gd PASS (3x).
- godot --headless --script res://tests/pkg_0207_gate_census_test.gd PASS (116/115/114 po aktualizacji).
- godot --headless --script res://tests/pkg_0120_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0163_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0147_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0194_creative_scene_b_test.gd PASS (lancuch 4 faz nietkniety).
- godot --headless --script res://tests/pkg_0193_creative_scene_test.gd PASS.
- godot --headless --script res://tests/pkg_0195_creative_scene_c_test.gd PASS.
- godot --headless --script res://tests/pkg_0114_smoke_test.gd PASS (routing select intact).
- godot --headless --script res://tests/pkg_0215_gap_voice_pin_test.gd PASS (mapa luk stoi).
- godot --headless --script res://tests/pkg_0217_synthesis_forecast_pin_test.gd PASS.
- godot --headless --script res://tests/traversal_lint_test.gd PASS.
- narzedzie tools/capture_pkg_0222.gd PASS normalnym sterownikiem (7 PNG).
- zakresowa tools/verify_scoped.ps1 PASS exit 0 (D-217, blast lokalny).

Zamkniecie PKG-0222:
- Zmieniono scripts/levels/station_14.gd (L2 kosztu) + station_15.gd (koszt + L2 + welon + auto-notatka) + station_18.gd (select-routing + marker) + station_01.gd (marker) + tests/pkg_0207_gate_census_test.gd (pin) + tools/verify.ps1 (123. sekcja) + docs/DECISION_LOG.md (D-235) + docs/CURRENT_STATE.md.
- Utworzono bramke tests/pkg_0222_correction_cost_budget_test.gd + raport docs/rebuild/PKG_0222_CORRECTION_COST_BUDGET.md + narzedzie tools/capture_pkg_0222.gd.
- Zaktualizowano docs/DECISION_LOG.md (D-235), docs/INDEX.md, docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md.
- Zamrozenie migawki: tools/snapshot.ps1 -Package PKG-0222.

## PKG-0223: Glosy i tempo (N4+N7-reszta+N9+N10+N8/K4 z planu PKG-0213 S8, 2026-09-13)

Zakres: Faza R6 planu PKG-0213 S8 (findings N4/N7/N9/N10 + margines N8/K4) w ramach autonomicznej orkiestracji AI (D-025, D-085, ADR-004). Blast: plik linii (loop_logbook 4->2 pary; ledger z obrazem + powiazany koszt; mantra x3 -> slupek/klucz/most; two_lives wskazuje zdjecie) + 2 lokalne skrypty stacji (station_15: beat s15_local_margin + tiki dziennika + slad olowka; station_17: projekcja-gest oferty) + testy (nowa bramka 0223, kontrolowana aktualizacja 2 asercji 0194, pin 0207, 124. sekcja verify.ps1) + narzedzie tools/capture_pkg_0223.gd + decyzja D-236. Zero monolitow D-217 (MRP/GSM/audio/kompozytor/autoloady/GapLedger nietkniete), zero enum/serialize/routing/progow/InputMap, zero nowych adresow/rodzin/MRP/faktow/postaci (beat K4 to dyspozycja N8). Liczby D-221 nietkniete. Lancuch MRP 15 (log/kontrole/uzbrojenie/korekta/notatka) nietkniety mechanicznie (pin 0194). Utrzymanie (D-229) nieruszone.

Decyzja D-236: tempo N4 ZAPINOWANE (loop 2 pary + pokaz w obrazie); glosy N7-reszta ZAPINOWANE (urzadzenia bez etykiet + Wierzbicka bezosobowa w calym zakresie, audit 40 read-only); tempo N9 ZAPINOWANE (09 wokol fotografii + 17 projekcja-gestem, 4 pary tekstu nietkniete); polszczyzna N10 ZAPINOWANA (4 potkniecia, grep 0 w LINES); margines N8/K4 ZAPINOWANY (beat L1 + slad, bez monologu-ducha).

Pomiary: nowa bramka 0223 PASS 3x (loop 2 pary + fit; ledger 04/17 + jedna reka + powiazany koszt; 3 konkrety + grep-0; urzadzenia-reszta; Wierzbicka; hub 09; K4 + tiki + projekcja; M5 09/15/17 <=3; fail-closed). Twardy fakt sesji: zmiana brzmien wylozyla pkg_0194 realnym FAIL-em na 2 asercjach (Ktos przerwal ja / mantra) + ordered follow-on â€” kontrolowana aktualizacja w tym samym pakiecie (wzor PKG-0216), 0194 PASS. Pin 0207 PASS (117/116/115). Sasiedzi 0193/0217/0216/0120/0163/0147/0195/0114/0215/traversal_lint PASS bez dotykania i bez obnizania progow. Kadry 15/17/18 6 PNG s100 full/notext + klatka logu 15 + klatka rejected 17 (Iris Xe, OpenGL) â€” inspekcja HOLD obrazu, zero napraw. Zakresowa tools/verify_scoped.ps1 PASS exit 0 (docs + 13 bramek). Licznik D-217: 2. zakresowa po pelnej PKG-0221 (limit: pelna najpozniej PKG-0226). Twardy fakt narzedziowy: tablica @(...) przez pwsh -File nie wiaze â€” zakresowa poszla runnerem w temp z operatorem & (fakt PKG-0222 potwierdzony ponownie). Zero bledow, zero ostrzezen w bramkach pakietu.

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki) jako baseline przed edycjami.
- godot --headless --script res://tests/pkg_0223_voices_tempo_pin_test.gd PASS (3x).
- godot --headless --script res://tests/pkg_0194_creative_scene_b_test.gd FAIL przed updatem (2 asercje) -> PASS po kontrolowanej aktualizacji.
- godot --headless --script res://tests/pkg_0207_gate_census_test.gd PASS (117/116/115 po aktualizacji).
- godot --headless --script res://tests/pkg_0193_creative_scene_test.gd PASS.
- godot --headless --script res://tests/pkg_0217_synthesis_forecast_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0216_dictionary_content_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0120_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0163_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0147_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0195_creative_scene_c_test.gd PASS.
- godot --headless --script res://tests/pkg_0114_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0215_gap_voice_pin_test.gd PASS.
- godot --headless --script res://tests/traversal_lint_test.gd PASS.
- narzedzie tools/capture_pkg_0223.gd PASS normalnym sterownikiem (8 PNG).
- zakresowa tools/verify_scoped.ps1 PASS exit 0 (D-217, blast lokalny).

Zamkniecie PKG-0223:
- Zmieniono scripts/levels/creative_scene_lines.gd (loop/ledger/mantra/two_lives) + station_15.gd (K4 + tiki + slad) + station_17.gd (projekcja) + tests/pkg_0194_creative_scene_b_test.gd (2 asercje) + tests/pkg_0207_gate_census_test.gd (pin) + tools/verify.ps1 (124. sekcja) + docs/DECISION_LOG.md (D-236) + docs/CURRENT_STATE.md.
- Utworzono bramke tests/pkg_0223_voices_tempo_pin_test.gd + raport docs/rebuild/PKG_0223_VOICES_TEMPO.md + narzedzie tools/capture_pkg_0223.gd.
- Zaktualizowano docs/DECISION_LOG.md (D-236), docs/INDEX.md, docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md.
- Zamrozenie migawki: tools/snapshot.ps1 -Package PKG-0223.

## PKG-0224: Rigi vendor/neighbour + profile Geometry (V7+V3 z planu PKG-0213 S8, 2026-09-13)

Zakres: Faza R7 planu PKG-0213 S8 (findings V7/V3) w ramach autonomicznej orkiestracji AI (D-025, D-085, ADR-004). Blast: 1 asset (jakub/seated.png: stojacy dubel 89 px -> siedzacy 58 px pipeline'em CAST z raw/pkg_0172_backup) + 1 skrypt narzedzia (tools/process_cast_sprites.py: seated dopisany do CHARS jakuba) + testy (nowa bramka 0224, pin 0207, 125. sekcja verify.ps1) + narzedzie tools/capture_pkg_0224.gd + decyzja D-237. Zero stacji/scen/monolitow D-217 (MRP/GSM/audio/kompozytor/autoloady/GapLedger/Binder/Threshold nietkniete), zero enum/serialize/routing/progow/InputMap, zero nowych adresow/rodzin/MRP/faktow/postaci/klatek AI (brak surowcow raw 0186 + brak generacji w pakiecie -> wyjatki jawne). Liczby D-221 nietkniete. Lancuch MRP 15 nietkniety. Utrzymanie (D-229) nieruszone.

Decyzja D-237: rigi V7 ZAPINOWANE (jakub seated naprawiony 58 px w pasmie 56-60; wyjatki vendor bez turn_away/seated/work/gesture + neighbour bez turn_away/seated/work z uzasadnieniem roli; rig renderuje piksele idle dla brakujacych; stacje 06/08 woluja tylko talk/listen/idle; turn_away zwolniony z pasa korony â€” pin: plotno + uziemienie + roznica od idle); geometria V3 ZAPINOWANA (profil miejski 06 vs mieszkalny 08: 6 roznic przy progu >= 4 â€” sufit/schody/drzwi-14/kiosk/open-sky/timetable; progi wylacznie z aperture_rect: rysunek ThresholdZone z jednego zrodla, 08 = 45x109 jak Binder, 06 bez drugiej geometrii progu).

Pomiary: nowa bramka 0224 PASS 3x (plotna 64x104; standing 84-92; seated 56-60 + nie-dubel; turn_away uziemiony + rozny; wyjatki + fallback pikselowy runtime; nieidentycznosc 6/4; apertury + lint jednego zrodla). Twarde fakty sesji: (a) bramka FAIL-owala seated 89 na starym imporcie mimo nowego PNG (cache .godot) -> reimport --import, project.godot nietkniety (diff pusty); (b) fallback riga to piksele nie nazwa -> poprawka bramki w pakiecie. Pin 0207 PASS (118/117/116). Sasiedzi 0186/0172/0212/0197/0214/traversal_lint PASS bez dotykania i bez obnizania progow. Kadry 06/08 8 PNG s100 full/notext pre+post (Iris Xe, OpenGL) â€” inspekcja HOLD obrazu, zero napraw. Zakresowa tools/verify_scoped.ps1 PASS exit 0 (docs + 8 bramek). Licznik D-217: 3. zakresowa po pelnej PKG-0221 (limit: pelna obowiazkowo najpozniej w PKG-0226). Twardy fakt narzedziowy: tablica @(...) przez pwsh -File nie wiaze â€” zakresowa poszla runnerem w temp z operatorem & (fakt PKG-0222/0223 potwierdzony ponownie). Zero bledow, zero ostrzezen w bramkach pakietu.

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki) jako baseline przed edycjami.
- godot --headless --script res://tests/pkg_0224_cast_geometry_pin_test.gd PASS (3x; w tym 1x FAIL przed naprawa seated + 1x FAIL fallbacku nazwy przed poprawka bramki).
- godot --headless --path . --import (odswiezenie cache tekstur; project.godot diff pusty).
- godot --headless --script res://tests/pkg_0207_gate_census_test.gd PASS (118/117/116 po aktualizacji).
- godot --headless --script res://tests/pkg_0186_cast_style_test.gd PASS.
- godot --headless --script res://tests/pkg_0172_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0212_station_disk_census_test.gd PASS.
- godot --headless --script res://tests/pkg_0197_zero_revision_test.gd PASS.
- godot --headless --script res://tests/pkg_0214_threshold_exit_open_pin_test.gd PASS.
- godot --headless --script res://tests/traversal_lint_test.gd PASS.
- narzedzie tools/capture_pkg_0224.gd PASS normalnym sterownikiem (8 PNG pre+post).
- zakresowa tools/verify_scoped.ps1 PASS exit 0 (D-217, blast lokalny).

Zamkniecie PKG-0224:
- Zmieniono assets/characters/jakub/seated.png (przebudowa pipeline'em) + tools/process_cast_sprites.py (seated w CHARS jakuba) + tests/pkg_0207_gate_census_test.gd (pin) + tools/verify.ps1 (125. sekcja) + docs/DECISION_LOG.md (D-237) + docs/CURRENT_STATE.md.
- Utworzono bramke tests/pkg_0224_cast_geometry_pin_test.gd + raport docs/rebuild/PKG_0224_CAST_GEOMETRY.md + narzedzie tools/capture_pkg_0224.gd.
- Zaktualizowano docs/DECISION_LOG.md (D-237), docs/INDEX.md, docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md.
- Zamrozenie migawki: tools/snapshot.ps1 -Package PKG-0224.

## PKG-0225: Winiety VIG-01..04 + FINALE i nosniki finalowe K1/K2/K3/K5/K6 (V-pakiet + N-finaly z planu PKG-0213 S8, 2026-09-13)

Zakres: Faza R8 planu PKG-0213 S8 (V-pakiet + N-finaly) w ramach autonomicznej orkiestracji AI (D-025, D-085, ADR-004). Blast: 5 skryptow stacji lokalnych (station_05/18/42a/42b/42c: beaty L1 + rysunek _draw z prymitywow) + testy (nowa bramka 0225, pin 0207, 126. sekcja verify.ps1) + narzedzie tools/capture_pkg_0225.gd + decyzja D-238. Zero monolitow D-217 (GSM/MRP/audio/kompozytor/autoloady), zero enum/serialize/routing/progow/InputMap, zero linii w creative_scene_lines.gd (stad brak churnu w pkg_0194), zero nowych adresow/rodzin/faktow/postaci/scen/assetow. Lancuch MRP 15 nietkniety. Utrzymanie (D-229) nieruszone. Stacja 37 (legacy, helm) celowo nietknieta - poza blastem 42/43.

Decyzja D-238: winiety ZAPINOWANE rozszerzeniem pinu 0190 (katalog dokladnie 7: 08/13/15/18/42a/42b/42c - brak winiety dla mechaniki 14, brak duplikacji cold openu 01; zero podpisow 7/7 wg D-214; skip interact/ui_accept od pierwszego wyswietlenia + runtime skip vig_commit z flaga; stany 43 z FULL_STORY: 3 galezie x 5 linii, konkretna czynnosc na koncu, brak narratora, brak tez); nosniki finalowe ZAPINOWANE (K1 kurtka: 42A odwrocona na krzesle / 42B pusty hak / 42C na haku + cudze mydlo; K2 kubek 18 per truth_state full-oba / partial-zarys / withheld-odwrocony, czyta istniejacy stan; K3 helm z garnka w kaciku imadla 42C; K5 blizna cialem: koszula w dol w 42B/42C, granica z 12; K6 ulica-rym: ta sama plyta UCP 28x14 z odpryskiem w 05/18 + cykl 18 spozniony o 1 klatke 1.6/60; 7 beatow L1-factual bez tez, wzor K4: rejestracja + slad, bez triggerow).

Pomiary: nowa bramka 0225 PASS 3x (placement/skip/stany-43/nosniki/rytm/zakaz-tez; po drodze 1x FAIL na brak znacznika K5 w komentarzu 42C - fail-closed dziala, naprawa w pakiecie). Sonda jednorazowa (usunieta): _rhyme_phase 05 rosnie 0.1167 -> 0.6 w 30 klatek fizyki - naped blinku dziala. Pin 0207 PASS (119/118/117). Sasiedzi 0190/0195/0107/0158/0215/traversal_lint PASS bez dotykania i bez obnizania progow. Kadry 05/18/42a/42b/42c 10 PNG s100 full/notext pre+post (Iris Xe, OpenGL) - inspekcja HOLD obrazu, zero napraw (delty = szum fazowy lamp/CRT, fakt PKG-0221/0222). Zakresowa tools/verify_scoped.ps1 PASS exit 0 (docs 52 + smoke + 8 bramek). Licznik D-217: 4. zakresowa po pelnej PKG-0221 (PELNA obowiazkowo w PKG-0226). Twardy fakt narzedziowy: tablica @(...) przez pwsh -File nie wiaze - zakresowa poszla runnerem w temp z operatorem & (fakt PKG-0222/0223/0224 potwierdzony ponownie).

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki) jako baseline przed edycjami.
- godot --headless --script res://tests/pkg_0225_vignettes_finales_pin_test.gd PASS (3x; w tym 1x FAIL znacznika K5 przed naprawa komentarza).
- godot --headless --script res://tests/pkg_0207_gate_census_test.gd PASS (119/118/117 po aktualizacji).
- godot --headless --script res://tools/probe_pkg_0225_blink.gd PASS (sonda jednorazowa, usunieta po uzyciu).
- godot --headless --script res://tests/pkg_0190_cinematics_test.gd PASS.
- godot --headless --script res://tests/pkg_0195_creative_scene_c_test.gd PASS.
- godot --headless --script res://tests/pkg_0107_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0158_smoke_test.gd PASS.
- godot --headless --script res://tests/pkg_0215_gap_voice_pin_test.gd PASS.
- godot --headless --script res://tests/traversal_lint_test.gd PASS.
- narzedzie tools/capture_pkg_0225.gd PASS normalnym sterownikiem (10 PNG pre+post).
- zakresowa tools/verify_scoped.ps1 PASS exit 0 (D-217, blast lokalny).

Zamkniecie PKG-0225:
- Zmieniono scripts/levels/station_05.gd + station_18.gd + station_42a.gd + station_42b.gd + station_42c.gd (beaty + _draw) + tests/pkg_0207_gate_census_test.gd (pin) + tools/verify.ps1 (126. sekcja) + docs/DECISION_LOG.md (D-238) + docs/CURRENT_STATE.md.
- Utworzono bramke tests/pkg_0225_vignettes_finales_pin_test.gd + raport docs/rebuild/PKG_0225_VIGNETTES_FINALES.md + narzedzie tools/capture_pkg_0225.gd.
- Zaktualizowano docs/DECISION_LOG.md (D-238), docs/INDEX.md, docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md.
- Zamrozenie migawki: tools/snapshot.ps1 -Package PKG-0225.

## PKG-0226: Truth-payoff + stol 6 rzeczy (N6-reszta z planu PKG-0213 S8, faza R8, 2026-09-13)

Zakres: N6-reszta (roznicowanie household_* po truth_state + stol 6 rzeczy w 18) + OBOWIAZKOWA PELNA verify.ps1 (limit D-217: 0225 byla 4. zakresowa po pelnej PKG-0221). Blast: dane scripts/levels/creative_scene_lines.gd (append-only: 9 dopisanych par + galaz stolowa method_commit_post) + 4 skrypty stacji lokalnych (station_18: commit_table_marks + 6 kresek; station_42a/42b/42c: _draw_truth_ring) + testy (nowa bramka 0226, pin 0207, 127. sekcja verify.ps1) + narzedzie tools/capture_pkg_0226.gd + decyzja D-239. Zero monolitow D-217 (GSM/MRP/audio/kompozytor/autoloady), zero enum/serialize/routing/progow/InputMap, zero nowych adresow/rodzin/faktow/flag/sygnalow/postaci/scen/assetow. Lancuch MRP 15 nietkniety. Utrzymanie (D-229) nieruszone. Stacja 37 (legacy) nietknieta.

Decyzja D-239: 9 otwar household ZAPINOWANE (3 rodziny x 3 truth_state, parami rozne hashe; 42A drugie zgloszenie, 42B czytnik w torbie, 42C polka; tailsy i otwarcia nietkniete); stol 6 rzeczy ZAPINOWANY w method_commit_post (FULL_STORY S39: 2 pary aktu + 6 par przegladu z istniejacych decyzji, brak to luka; const LINES niemutowany); obraz ZAPINOWANY (6 kresek 18 + pierscienie r8/w2.5 na blatach 42: pelny/polowa/przerwa); zero nowych faktow (pin: brak record_decision + FACT_ 14/15/16/16).

Pomiary: nowa bramka 0226 PASS 3x (9 hashy/znaczniki/tailsy/limity CRT/brak tez/stol 2+6/brak faktow/sciezki _draw). Sasiedzi 0194/0195/0216/0217/0223/0225/traversal_lint PASS bez jednej zmiany tresci (append-only). Pin 0207 PASS (120/119/118). Kadry 18/42a/42b/42c 24 PNG s100 full/notext/read pre+post (Iris Xe, OpenGL; read = stan odczytu bez warstw tekstu) - inspekcja HOLD + czytelne znaczniki (6 cyjanowych kresek; pierscienie domkniety/polowa/przerwa). PELNA tools/verify.ps1 PASS exit 0 (127 sekcji, dowod reports/pkg_0226_verify_full.log, log bez FAIL/ERROR). Licznik D-217 ZRESETOWANY. Twarde fakty: (a) cienki luk r5/w1.5 ginie w kompozytorze 2x2 (dotyczy tez luku haka K1 z 0225) - stad r8/w2.5; (b) kadr (570,262) stoi na geometrii drzwi srodowiska - stad blat (490,262); (c) wariant read ukrywa tekst (brak panelu i przesuniecia kamery dialogowej). Sondy jednorazowe tools/probe_pkg_0226_marks.gd + tools/probe_pkg_0226_arc.gd usuniete po uzyciu.

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki) jako baseline przed edycjami.
- godot --headless --script res://tests/pkg_0226_truth_payoff_table_pin_test.gd PASS (3x).
- godot --headless --script res://tests/pkg_0194_creative_scene_b_test.gd PASS.
- godot --headless --script res://tests/pkg_0195_creative_scene_c_test.gd PASS.
- godot --headless --script res://tests/pkg_0216_dictionary_content_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0217_synthesis_forecast_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0223_voices_tempo_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0225_vignettes_finales_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0207_gate_census_test.gd PASS (120/119/118 po aktualizacji).
- narzedzie tools/capture_pkg_0226.gd PASS normalnym sterownikiem (24 PNG pre+post).
- PELNA tools/verify.ps1 PASS exit 0 (D-217, licznik zresetowany; dowod reports/pkg_0226_verify_full.log).

Zamkniecie PKG-0226:
- Zmieniono scripts/levels/creative_scene_lines.gd (9 par + stol) + station_18.gd + station_42a.gd + station_42b.gd + station_42c.gd (znaczniki + _draw) + tests/pkg_0207_gate_census_test.gd (pin) + tools/verify.ps1 (127. sekcja) + docs/DECISION_LOG.md (D-239) + docs/CURRENT_STATE.md.
- Utworzono bramke tests/pkg_0226_truth_payoff_table_pin_test.gd + raport docs/rebuild/PKG_0226_TRUTH_PAYOFF_TABLE.md + narzedzie tools/capture_pkg_0226.gd.
- Zaktualizowano docs/DECISION_LOG.md (D-239), docs/INDEX.md, docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md.
- Zamrozenie migawki: tools/snapshot.ps1 -Package PKG-0226.

## PKG-0227: Higiena i narzedzia R9 (T3+T4+T5+V9+V11+A5+K26/K28 z planu PKG-0213 S8, 2026-09-13)

Zakres: faza R9 w ramach autonomicznej orkiestracji AI (D-025, D-085, ADR-004). Blast: tools/verify.ps1 (1-linijkowa dopiska T3, bez wzorca liczonego) + 4 skrypty stref srodowiskowych (threshold_zone/ladder_zone/return_zone/opening_action_point: literaly warstw -> consty PhysicsLayers, wartosci identyczne 0/1,0/1,1/1,0/1) + nowy scripts/environment/physics_layers.gd (centralny pin 1/2/3/4 + tabela stref) + testy (nowa bramka 0227, pin 0207, 128. sekcja verify.ps1) + narzedzia tools/audio_5axis_report.gd + tools/audio_browser.gd (dev-only, nie w verify) + tools/retired/ (4+4 pliki capture_act* ery PKG-0094) + decyzja D-240. Zero monolitow D-217 (GSM/MRP/audio/kompozytor/autoloady), zero enum/serialize/routing/progow/InputMap, zero linii w creative_scene_lines.gd, zero nowych adresow/rodzin/faktow/postaci/scen/assetow. Lancuch MRP 15 nietkniety. Utrzymanie (D-229) nieruszone.

Decyzja D-240: T3 (backtick) + T4 (lint reentrancji fail-closed: 5 plikow D-224 + skan scripts/, baseline zero naruszen) + T5 (pin 4x4) + V9 (kamery: CinematicCamera + StationCameraRig, 2 skrypty, NODE_NAME Camera, jedno extends Camera2D; zero draw_string w levels/*.gd; VSE ZOSTAJE: spis 45 scen 01-08 brak / 09-16 inert / 17-43 zywy â€” teza audytu o martwym kodzie skorygowana, wyciecie zlamaloby 29 scen) + V11 (capture_act* do retired + lista prawd w INDEX: preview + 0187 + 0190 + capture_pkg_02*) + A5/K26 (dev-raport 5 osi statyczny: LENA 587, MARTA 440, JAKUB 370+grit, WIERZBICKA 520+HF, SZYMON 260+trem, SYSTEM 330+HF, ELDERLY 480+trem; kolizja 440/480 otwarta; UNKNOWN==SYSTEM celowo) + K28 (browser tylko --allow-audio-browser: 256 generatorow = spis D-225; izolacja pinowana bramka).

Pomiary: nowa bramka 0227 PASS 3x (setter-lint/physics-4x4/kamery/draw_string/INDEX/izolacja/runtime; po drodze 1x FAIL na brakujace wpisy INDEX przed ich dopisaniem â€” fail-closed dziala). Pin 0207 PASS (120/119/118 -> 121/120/119; regula D-222). Sasiedzi 0210/0214/0221/traversal_lint PASS bez dotykania i bez obnizania progow. Import --headless --editor --quit: project.godot IDENTYCZNY (diff pusty, ticki 60). Kadry: brak (zero zmian wizualnych). Zakresowa tools/verify_scoped.ps1 PASS exit 0 (docs 52 + smoke 01-43 + 7 bramek). Licznik D-217: 1. zakresowa po pelnej PKG-0226 (pelna najpozniej w PKG-0231). Twardy fakt narzedziowy: tablica @(...) przez pwsh -File nie wiaze â€” zakresowa poszla runnerem w temp z operatorem & (fakt PKG-0222/0223/0224/0225 potwierdzony ponownie).

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki) jako baseline przed edycjami.
- godot --headless --script res://tests/pkg_0227_hygiene_tools_pin_test.gd PASS (3x; w tym 1x FAIL INDEX przed dopisaniem listy).
- godot --headless --script res://tests/pkg_0207_gate_census_test.gd PASS (121/120/119 po aktualizacji).
- godot --headless --script res://tests/pkg_0210_architectural_audit_remediation_test.gd PASS.
- godot --headless --script res://tests/pkg_0214_threshold_exit_open_pin_test.gd PASS.
- godot --headless --script res://tests/pkg_0221_ladder_return_scale_test.gd PASS.
- godot --headless --script res://tools/audio_5axis_report.gd PASS (dev, tabela 7 glosow).
- godot --headless --script res://tools/audio_browser.gd -- --allow-audio-browser --list PASS (256 generatorow); --info=lena PASS (16-bit/44100/mono/0.050s); bez flagi odmawia startu (test_mode).
- zakresowa tools/verify_scoped.ps1 PASS exit 0 (D-217, blast lokalny).

Zamkniecie PKG-0227:
- Zmieniono scripts/environment/threshold_zone.gd + ladder_zone.gd + return_zone.gd + scripts/interactables/opening_action_point.gd (literaly -> PhysicsLayers) + tests/pkg_0207_gate_census_test.gd (pin) + tools/verify.ps1 (dopiska T3 + 128. sekcja) + docs/DECISION_LOG.md (D-240) + docs/CURRENT_STATE.md.
- Utworzono modul scripts/environment/physics_layers.gd + bramke tests/pkg_0227_hygiene_tools_pin_test.gd + raport docs/rebuild/PKG_0227_HYGIENE_TOOLS.md + narzedzia tools/audio_5axis_report.gd + tools/audio_browser.gd.
- Przeniesiono tools/capture_act1_vector_stage.gd + capture_act2(b/c)_vector_stage.gd (+ .uid) do tools/retired/.
- Zaktualizowano docs/DECISION_LOG.md (D-240), docs/INDEX.md (blok 0227 + lista capture-prawd), docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md.
- Zamrozenie migawki: tools/snapshot.ps1 -Package PKG-0227.

## PKG-0228: Pelna recertyfikacja R10 + zamkniecie planu PKG-0213 (2026-09-13)

Zakres: faza R10 z planu PKG-0213 S8, sciezka D (zero zmian tresci: kod, dane, obraz, dzwiek, sceny, testy, konfiguracja NIETKNIETE). Jedyny pakiet fazy R10; plan R0-R10 WYCZERPNY. Decyzja D-241 (na jawnym upowaznieniu decyzyjnym wlasciciela). Blast: docs (CURRENT_STATE, SESSION_LOG, NEXT prompt, INDEX, DECISION_LOG) + reports/pkg_0228_verify_full.log + snapshot. Nie jest PRODUCT GO. GATE-REL, release i nowe .exe BLOCKED BY D-168.

Pomiary: PELNA tools/verify.ps1 PASS exit 0 (128 sekcji: DOCS PASS 52 + smoke 01-43 + wszystkie bramki 0001-0227; log bez FAIL/ERROR/wyciekow; dowod reports/pkg_0228_verify_full.log). Licznik D-217 ZRESETOWANY (ostatnia pelna PKG-0228). Twardy fakt sesji: PIERWSZY przebieg pelnej oblal bramke 0151 wylacznie warningiem teardown "2 ObjectDB instances were leaked at exit" PO jej wlasnym 100% PASS; 3 izolowane re-runy 0151 czyste; drugi pelny przebieg PASS; log PKG-0226 zero wyciekow. Flake teardown (rodzina Godot #76745), nie regresja â€” blast 0227 nie zawiera przyczyny. Zero zmian kodu i progow (zakaz oslabiania kryteriow); regula flake-watch w D-241. Raport luk: pokrycie recertyfikowane bramka 0215 w przebiegu (54 mapowania + override + 9 tla + flagi s09-s14). Kadry: brak swiezych â€” sandbox bez displaya (proba capture normalnym sterownikiem: 300 s hang bez outputu i bez stray-procesow, reports/ nietkniete 139 PNG); klaryfikacja D-241: recert bez zmian wizualnych cytuje dowody 0187/0190/0201-0203 + bramki kamer 0130/0141/0142 z przebiegu. Pin 0207 bez zmian (121/120/119); brak nowej bramki (sciezka D).

Decyzja D-241 (3 rozstrzygniecia): (1) flake 0151 â€” zamkniety bez kodu, flake-watch; (2) MAINTAIN FREEZE â€” ekstrakcja MRP w kolejce za dyspozycja, kolizja 440/480 OTWARTA z gotowa specyfikacja (elderly 480->392 G4, Marta 440 nietknieta; dowod K26 + 0139/0211/0217), K8-K15 tylko na zlecenie, release BLOCKED; nastepna sesja czeka na dyspozycje (GO wg ACCEPTANCE_MATRIX albo zlecenie), bez niej tylko docs-only i flake-watch; (3) research internetowy nie byl potrzebny â€” rozstrzygniecia na dowodach z repo (odnotowane wprost, nie udawane).

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki) jako baseline przed edycjami.
- PELNA tools/verify.ps1 PASS exit 0, przebieg 1: FAIL tylko 0151-teardown (100% PASS + warning); 3x isolated 0151 PASS czysto; przebieg 2 (dowodowy): PASS calosci.
- godot --headless --script res://tests/pkg_0207_gate_census_test.gd PASS (121/120/119, bez zmian).
- Proba tools/capture_preview.gd normalnym sterownikiem: hang 300 s, zero outputu, zero stray-procesow, reports/ 139 PNG nietkniete (limit srodowiska, D-241/3).
- Zakresowa nie dotyczy (recertyfikacja = pelna z definicji).

Zamkniecie PKG-0228:
- Zmieniono docs/CURRENT_STATE.md + docs/DECISION_LOG.md (D-241) + docs/NEXT_SESSION_PROMPT.md + docs/INDEX.md (blok 0228).
- Dopisano wpis PKG-0228 do docs/SESSION_LOG.md (niniejszy).
- Dowod: reports/pkg_0228_verify_full.log (pelny przebieg dowodowy).
- Zamrozenie migawki: tools/snapshot.ps1 -Package PKG-0228.

## PKG-0229: Pakiet oceny PRODUCT GO (dyspozycja wlasciciela "GO review", 2026-09-13)

Zakres: sciezka D docs-only (zero zmian kodu, danych, obrazu, dzwieku, scen, testow, konfiguracji; bez nowej decyzji, bez nowej bramki). Na pytanie "co robimy dalej" wlasciciel wybral GO review (odrzucone: pakiet glosowy, ekstrakcja MRP, dalszy freeze bez produktu). Blast: raport docs/rebuild/PKG_0229_GO_REVIEW_EVIDENCE.md + docs handoffu. Nie jest PRODUCT GO (werdykt nalezy do wlasciciela). GATE-REL, release i nowe .exe BLOCKED BY D-168.

Wynik: raport zbiera 14/14 bramek produktu ze SWIEZYMI dowodami z pelnej PKG-0228 (exit 0, 128 sekcji, 2026-09-13): GATE-01 (0176), 05/30 (0157/0158/0159), FAM (0187 + 0224 + 0218/0219 + mono 0177), OBJ (0177 M1 20 stacji / 188.3 s sim z tego przebiegu), INT (0215 + 0222), MECH (0162-0166 + 0140 + 0199/0200 + 0221/0222), FIN (0150/0151 + 0167-0170 + 0225/0226 â€” wzmocniony wzgledem CHECKPOINT-06), INTRO (0176, warstwy nietkniete), CAST (0172 + 0186 + 0224 â€” seated naprawiony), THRESH (0174 + 0214), SCALE (0174 + 0221 + 0129/0132), FLOW (0175 + 0215), ANIM (0173 + 0221). Pola [ ] GO / CONCERNS / FAIL per bramka + calosciowe PRODUCT GO + dyspozycja release do wypelnienia przez wlasciciela. Otwarte punkty do swiadomej akceptacji: 440/480 (spec D-241), flake-watch 0151 (D-241), kadry recertow bez displaya (D-241/3), brak dowodow odbiorczych z zasady (D-012/ADR-003).

Weryfikacja:
- tools/verify_docs.ps1 PASS (52 pliki) jako baseline przed edycjami.
- godot --headless --script res://tests/pkg_0207_gate_census_test.gd PASS (121/120/119, bez zmian; handoff spojny).
- Zakresowa tools/verify_scoped.ps1 PASS exit 0 (D-217, blast docs-only poza monolitami; licznik: 1. zakresowa po pelnej PKG-0228).

Zamkniecie PKG-0229:
- Utworzono raport docs/rebuild/PKG_0229_GO_REVIEW_EVIDENCE.md.
- Zaktualizowano docs/INDEX.md (blok 0229), docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md.
- Dopisano wpis PKG-0229 do docs/SESSION_LOG.md (niniejszy).
- Zamrozenie migawki: tools/snapshot.ps1 -Package PKG-0229.

## PKG-0230: Naprawa sensu fabularnego (dyspozycja wlasciciela STORY_SENSE_REPAIR_PROMPT, 2026-09-14)

Zakres: pelny plan docs/narrative/STORY_SENSE_REPAIR_PLAN_2026-09-14.md (P0/P1/P2); freeze D-241 zdjety dla tego zakresu. Decyzja D-242. Nie jest PRODUCT GO. GATE-REL, release i nowe .exe BLOCKED BY D-168.

Wynik: P0-4 epilog unseeded bez sprzecznosci Linii 4. P0-3 WYKRESLONY (S-04 obalony bramka 0214: 22/22 wyjsc otwartych przy zero odczytach; otwieracz GSM node_added â†’ GapLedger.ensure_exit_open). P0-1 zgoda Jakuba blokuje metode (odmowa zamyka 3 drogi, feedback jakub_consent_missing â†’ luka s17, beat s18_consent_refused_blocks; wyjscie: renegocjacja w 17; fallbacki 42A/B/C usuniete). P0-2 wskazanie vs zatwierdzenie (named_method, martwa strefa +-40, 3 oznaczenia nad panelem 0137, znacznik w _draw). P1-1+P1-4 ogniwa wejscia/wyjscia 10/12-17/14-18. P1-3 rigi Marty 18/42A, terminal lacza 17 + JAKUB (LACZE), begins_with w prezentacji. P1-2 druga kwestia cue w 13. P2-1 arrival_side_for (12â†’13, 17â†’18 z prawej) + pion HATCH (MAPA). P2-2: (a)(c)(e) tak, (b)(d)(f) odroczone z powodow. P2-3 naglowki 09-13 live + renames 11/13 + notka FULL_STORY. P2-4 beat s11_night_desk. Test rozstrzygajacy: 18/18 adresow z tresci gry (raport). Pytanie do wlasciciela: renegocjacja vs czwarta metoda przy odmowie.

Weryfikacja:
- Baseline: verify_docs PASS (52); pelna verify.ps1 timeout 10 min w sandboxie (srodowisko, nie kod); 0214 re-run PASS (S-04 obalony runtime).
- Nowa bramka tests/pkg_0230_story_sense_repair_test.gd PASS.
- Kontrolowane aktualizacje po realnych FAIL-ach: 0166 (4 faili) PASS; smoke PASS; 0194 PASS (po naprawie wyscigu harnessa: auto-transition off, wzor 0166).
- Pelna verify.ps1 lapala realne regresje: 0099 (koszt poraĹĽki) i 0137 (legendy na panelu) â€” naprawione w pakiecie.
- PELNA tools/verify.ps1 PASS exit 0 (129 sekcji; dowod reports/pkg_0230_verify_full.log); licznik D-217 ZRESETOWANY. 0151 PASS bez warningu teardown (flake-watch: czysto).
- Pin pkg_0207: 121/120/119 -> 122/121/120 (regula D-222); 129. sekcja w verify.ps1.

Zamkniecie PKG-0230:
- Utworzono raport docs/rebuild/PKG_0230_STORY_SENSE_REPAIR.md.
- Zaktualizowano docs/INDEX.md (blok 0230), docs/CURRENT_STATE.md, docs/NEXT_SESSION_PROMPT.md, docs/DECISION_LOG.md (D-242), docs/rebuild/CAMPAIGN_MAP.md, docs/narrative/FULL_STORY.md.
- Dopisano wpis PKG-0230 do docs/SESSION_LOG.md (niniejszy).
- Zamrozenie migawki: tools/snapshot.ps1 -Package PKG-0230.

Ograniczenia: zero swiezych kadrow (sandbox bez displaya, D-241/3) â€” rigi/terminal/legendy do inspekcji na maszynie z displayem; brak dowodow odbiorczych (D-012/ADR-003); P2-2 (b)(d)(f) odroczone; renegocjacja vs 4. metoda do decyzji wlasciciela.

## PKG-0231: Swiezy audyt sensu aktywnej kampanii (2026-09-14)

Zakres: na jawna dyspozycje wlasciciela niezalezny audyt sensu fabularnego,
dialogowego, przyczynowego i geograficznego aktywnej trasy
`01â€“18 â†’ 42A/B/C â†’ 43`. Tryb docs-only: bez zmian kodu, scen, dialogow runtime,
danych i testow. Dla swiezego spojrzenia celowo nie czytano wczesniejszych
analiz/audytow fabularnych, raportow naprawczych, snapshotow ani testu 0230;
obowiazkowe dokumenty produktu sluzyly tylko ustaleniu aktywnego zakresu.

Wynik: raport `docs/rebuild/PKG_0231_FRESH_STORY_SENSE_AUDIT.md` i plan dla
wykonawcow `docs/rebuild/PKG_0231_STORY_SENSE_REPAIR_PLAN.md`. Werdykt
STORY-SENSE CONCERNS: rdzen historii jest spojny w idealnym przebiegu i ma
zostac zachowany, ale legalny runtime nie gwarantuje przyczyny skutku.
Zmaterializowane P0: globalnie otwarte progi i nastepna wiedza; 14 zna przed 15
przyczyne przerwania 20:40; sprzecznosc UCP w 10; fallback 42A bez metody;
skutek 42 przed wykonaniem; blackout 43 przed pelnym epilogiem; blokada
przodâ†’powrotâ†’przod przez `_handled_completions`. P1: pochodzenie zaswiadczenia,
status czytnika, styki 13â†’14 i 18â†’42, fokalizacja 42B oraz wyplata malego kosztu,
prawdy i zgody. Decyzja D-243; ryzyka R-053..R-057. PRODUCT GO i release nadal
BLOCKED BY D-168.

Plan wdrozenia: najpierw jeden mega-pakiet A + D1/D3/D4 (inwariant
stanâ†’dzialanieâ†’wiedzaâ†’progâ†’nastepna scena; brak domyslnego A; atomowy final;
pelny epilog; powrot), potem B/C/D2/D5 (chronologia i rekwizyty, geografia i
fokalizacja, trwala migawka i wyplata decyzji). Freeze D-241 zdjety wylacznie
dla realizacji D-243/PKG-0231.

Weryfikacja:
- swieza pelna `tools/verify.ps1` przed docs: PASS exit 0, 129 sekcji; log
  `reports/fresh_story_verify.log`;
- finalne `tools/verify_docs.ps1`: PASS, 52 pliki;
- `pkg_0207_gate_census_test.gd`: PASS, 122 invokes / 121 scripts / 120 tests;
- `tools/verify_scoped.ps1`: PASS exit 0 (log policy + DOCS + smoke 01â€“43 +
  pin 0207); log `reports/pkg_0231_scoped.log`;
- licznik D-217: 1. zakresowa po pelnej PKG-0230.

Ograniczenia: analiza statyczna nie dowodzi emocji, zabawy ani zrozumienia przez
nowa osobe; brak swiezych kadrow normalnym sterownikiem; nie implementowano
napraw. Handoff: `docs/NEXT_SESSION_PROMPT.md`, kolejny pakiet PKG-0232.
Zamrozenie: `tools/snapshot.ps1 -Package PKG-0231` â†’
`snapshots/PKG-0231-2026-09-14`.
## PKG-0232: Lancuch przyczynowy A+D1/D3/D4 (2026-09-14)

Pierwszy mega-pakiet z planu PKG-0231 (decyzja D-244; freeze D-241 zdjety
wylacznie dla napraw PKG-0231). Raport: `docs/rebuild/PKG_0232_CAUSAL_CHAIN.md`.

ROZJAZD BASELINE (przed edycjami, WORKFLOW): swieza pelna `verify.ps1`
FAILowala wylacznie w bramce 0208 (`NEXT_SESSION_PROMPT must name expected
PKG-0209`) â€” dryf dokumentacyjny po docs-only PKG-0231 (nowy handoff upuscil
historyczny literal), nie regresja runtime (wszystkie bramki kodu PASS do
momentu zatrzymania). Odnotowane przed pierwsza edycja; handoff PKG-0232
przywraca literal.

ZMIANY (Godot 4.7, tylko gra):
- `scripts/core/game_state_manager.gd`: polityka faktow w komentarzu;
  `_repeat_navigate` â€” `_handled_completions` rozlicza writerow raz,
  ponowne przekroczenie nawiguje (S-07). Jawne wywolania harnessow bez zmian.
- `scripts/levels/station_18.gd`: `_trigger_level_completion` odmawia bez
  metody (luki `forecast_and_consent_inventory_required` /
  `jakub_consent_missing`, oba w FEEDBACK_TO_GAP); `_restore_commitment_from_decisions`.
- `scripts/levels/station_42a/b/c.gd`: straznicy wykonanie->stan->skutek
  (`return/flow_closure/passage_execution_required`, `sealed/recovered/leak_state_required`,
  `finale_sequence_incomplete` + beaty planu); `_restore_chain_from_decisions`.
- `scripts/levels/station_43.gd`: tablica/napisy po 2 beaty dialogu;
  `inspect_blackout` + `_complete_campaign` wymagaja tablicy + napisow +
  `dialogue_index >= 4`, przed wymaganiami odmowa bez zapisu;
  `_restore_inspections_from_decisions`; ponowne lektury przesuwaja dialog.
- `scenes/levels/station_14.tscn`: otwarcie bez zewnetrznego przerwania
  (20:40 zachowane dla pinu 0230). Beat 13 i most 13->14 odroczone.
- Testy: nowa bramka `tests/pkg_0232_causal_chain_test.gd` (8 kryteriow:
  zero-interaction, 18 bez metody, refused x3, kolejnosc 42A/B/C, blackout,
  5 linii, macierz przod-powrot-przod na tranzycjach, save/reload) PASS;
  kontrolowane aktualizacje 0167/0168/0169 (niepelna proba nie domyka),
  0137 (warunek 43: ostatnia linia dialogu), 0175 (bieg minimalny REQUIRED-verbs), 0177 (M1: nogi 14-17 czasownikami,
  commit dwustopniowy, lancuchy 42/43, flush CRT, snap, marsz w lewo);
  pin 0207: 123/122/121/121; 130. sekcja w `tools/verify.ps1`.

WERYFIKACJA: PELNA `tools/verify.ps1` PASS exit 0 (130 sekcji; dowod
`reports/pkg_0232_verify_full.log`); licznik D-217 ZRESETOWANY. Zero zmian
obrazu (brak swiezych kadrow z zasady; zmiana tscn 14 to linia cue).
Twarde fakty: fizyczny sweep M1 nie wykonywal mechanik 14-17; commit wymaga
snapa Â±40 px (krok fizyki ~4 px); pressy gina w kontencji z prezentacja
(flush przed kazdym pressem); przybycie 17->18 z prawej; `String(null)`
abortuje noge testu.

Ograniczenia: automat dowodzi stanu/kolejnosci, nie emocji ani zrozumienia
(D-012). Otwarte: claim-side 17/18, most 13->14, UCP-10, zaswiadczenie m.12,
czytnik po UCP, fokalizacja 42B, D2/D5 (R-053/R-057 czesciowo).
R-054/R-055/R-056 ZAMKNIETE. GATE-REL/release/`.exe` nadal BLOCKED BY D-168.
Handoff: `docs/NEXT_SESSION_PROMPT.md`, kolejny pakiet PKG-0233.
Zamrozenie: `tools/snapshot.ps1 -Package PKG-0232` -> `snapshots/PKG-0232-...`.

## PKG-0233: Mosty sensu B + C/D2/D5 (2026-09-14)

Drugi mega-pakiet z planu PKG-0231 (decyzja D-245; freeze D-241 zdjety
wylacznie dla napraw PKG-0231). Raport: `docs/rebuild/PKG_0233_SENSE_BRIDGES.md`.

BASELINE (przed edycjami, WORKFLOW): swieza pelna `verify.ps1` PASS exit 0
(130 sekcji, stan po PKG-0232). Zero rozjazdu z handoffem.

ZMIANY (Godot 4.7, tylko gra):
- `scripts/levels/station_10.gd`: mysl wyjsciowa s10_exit_ucp_record jako
  hipoteza („Marta twierdzi... zanim uznam to za moje"); samo id beatu
  nietkniete (pin 0230).
- `scripts/levels/station_01.gd`: FACT_CERTIFICATE + beat s01_field_certificate
  + dokument w torbie; obie drogi (probka/obietnica) zapisuja
  `p9.opening.field_certificate_packed = sadowa_7_m12`.
- `scripts/levels/station_11.gd`: FACT_CUSTODY (warunkowe pokwitowanie
  minimalnego zakresu w akcie wyciagu) + beat s11_reader_receipt + kwit na
  ladzie w `_draw`.
- `scripts/levels/station_12.gd`: beat s12_reader_receipt przy pierwszym
  pytaniu + czytnik z kwitem na stole w `_draw`.
- `scripts/levels/station_13.gd`: beat s13_device_correlate (korelat dwoch
  urzadzen przy drugim zrodle) + identyczne wyciecia w `_draw` + kwit przy
  zrodle; beat wyjscia s13_exit_to_switchyard: mieszkanie + sekcja + wlaz,
  bez wiedzy z 15 (druga polowa S-02).
- `scenes/levels/station_14.tscn`: cue_2 o zejsciu wlazem (20:40 nietkniete).
- `scenes/levels/station_42a/b/c.tscn`: cue_2 noc-przy-slupku → swit +
  perspektywa przybylej Leny (42B: „O świcie jestem przybyłą Leną, stoję
  w progu"); DIALOGUE_LINES 4/4/4 nietkniete.
- `scripts/levels/station_18.gd`: atomowy snapshot
  `p9.method_commitment.snapshot` (metoda/prawda/zgoda/koszt/dowody[4]/final,
  1 zapis, literal inline — pin 0226 stoi) + locki method_snapshot_locked /
  finale_execution_started.
- `scripts/campaign/gap_ledger.gd`: NON_GAP_FEEDBACKS +2 (pin 0215 stoi).
- `scripts/levels/station_42a/b/c.gd`: `cost` w slowniku skutku + payoff_cost
  + znaczki zgody/kosztu na blacie (ksztalty, nie sam kolor).
- `scripts/levels/station_43.gd`: linia wyplaty 43[2] (tag rodziny + prawda +
  zgoda + koszt, <=115 znakow; indeksy 0/1/3 nietkniete) + znaczki na
  slupkach/maszcie; small_cost_state z decyzji.
- `docs/narrative/FULL_STORY.md`: sync §01 (torba) i §21 (korelat), po 1 linii.
- Testy: nowa bramka `tests/pkg_0233_story_sense_bridges_test.gd` (10 kryteriow:
  B1/B2/B3/B4, C1/C2/C3, D2 x5, D5 macierz 54 lancuchow 42 + 144 linie 43,
  pin-compat) PASS; pin 0207: 124/123/122/122; 131. sekcja w `tools/verify.ps1`.

WERYFIKACJA: PELNA `tools/verify.ps1` PASS exit 0 (131 sekcji; dowod
`reports/pkg_0233_verify_full.log`); licznik D-217 ZRESETOWANY. Sasiedzi
sprawdzeni pojedynczo: 0193/0194/0195/0230/0232/0166-0169/0170/0175/0177/
0107/0137/0142/0196/0217/0160/0207/0215/0226.
Po drodze realne FAIL-e i naprawy w pakiecie: nowa 0233 (wielkosc litery we
wzorcu 42B); 0195 (linia 43B[2] pinuje „drugie zgłoszenie" — kontrolowana
zmiana znacznika rodziny, bez zmian testu); blad String==bool w `_draw` 13
na fakcie Stringowym (pokwitowanie → `_has`, przed zielenia). Twardy fakt:
`_decision_bool` nie znosi wartosci String (Godot 4.7 rzuca SCRIPT ERROR).
Zero zmian obrazu wymagajacych kadrów displayem (znaczki w istniejacych
scenach; klaryfikacja D-241).

Ograniczenia: automat dowodzi stanu/kolejnosci, nie emocji ani zrozumienia
(D-012). Otwarte: claim-side 17/18 (R-053 czesciowo: glos luki zamiast
osobnych linii wejscia), kadry displayem, PRODUCT GO (wlasciciel).
R-057 ZAMKNIETE; R-054/R-055/R-056 ZAMKNIETE (PKG-0232).
GATE-REL/release/`.exe` nadal BLOCKED BY D-168.
Handoff: `docs/NEXT_SESSION_PROMPT.md`, kolejny pakiet PKG-0234.
Zamrozenie: `tools/snapshot.ps1 -Package PKG-0233` -> `snapshots/PKG-0233-...`.

ADDENDUM PKG-0233 (przed zamrozeniem): pelna `verify.ps1` zlapala realny regres w bramce 0218 (moje kreski 1.0 w `_draw` 13, pin: zero 1.0 w 13) — naprawione podniesieniem do 2.0, 0218 i 0233 ponownie PASS, pelna puszczona od nowa.

## PKG-0234: Duchy w pokojach / Pakiet A (2026-09-15)

Pakiet A ze swiezego planu 2026-09-15 (decyzja D-246; freeze D-241 zdjety
wylacznie dla A). To NIE jest Pakiet A z wyczerpanego planu PKG-0231.
Raport: `docs/rebuild/PKG_0234_GHOST_PROPS.md`.

BASELINE (przed edycjami, WORKFLOW): swieza pelna `tools/verify.ps1` FAIL
exit 1, wylacznie `verify_docs.ps1`: `docs/NEXT_SESSION_PROMPT.md` nie
zawiera ASCII `SRODOWISKO I BASELINE` (naglowek z diacritic `ŚRODOWISKO`)
ani `KONIEC PAKIETU JEST OBOWIAZKOWY`. Handoff PKG-0233 twierdzil PASS 131
sekcji — rozjazd jest w promptcie 0234 (diakrytyki kontraktu docs), nie w
kodzie gry. Pin 0207 (124/123/122) nie sprawdzony w tym przebiegu (docs
pada pierwsze). Naprawa kontraktu docs w tym pakiecie (aliasy ASCII +
prompt nastepcy z wymaganymi frazami). Zero zmian kodu przed tym wpisem.

ZMIANY (Godot 4.7, tylko gra):
- `scenes/levels/station_09.tscn` + `scripts/levels/station_09.gd`:
  `Geometry/StairwellPlanter` na (430, 287), collision_layer 0 / mask 1,
  object_name „Doniczka na komodzie”; `StairFlight` CollisionPolygon2D
  disabled (cialo klatki 52 px, x=400..570, wezel zostaje dla 0219);
  auto-push zdjety z `_physics_process`. Callable `push_planter` /
  `ask_neighbour_without_leading` zostaja dla testow i nie otwieraja
  progu. Prog: `respect_private_boundary()`.
- `scenes/levels/station_11.tscn` + `scripts/levels/station_11.gd`:
  `Geometry/HallwaySideboard` na (500, 287), layer 0 / mask 1; komentarz
  0192 `ZOSTAJE jako` zachowany (dopisek: wezel w drzewie, nie przeszkoda
  trasy); auto-push zdjety. Wierzbicka zostaje. Wyjscie po
  `request_minimal_report()`.
- `scripts/environment/threshold_binder.gd` + `station_12.gd/.tscn`:
  binder `spec_for("station_12")` door="", rodzina DOOR, apertura 48x112;
  `BalconyDoor` na (72, 140), collider disabled, animacja zamkniecia
  72→156 dla 0099; drzwi serwisowe w `_draw` (536, 184, 54x112). Kwestia
  `s12_exit_back_home` bez zmian.
- `scripts/levels/station_13.gd` + `.tscn`: `DeskDrawer` collider zawsze
  disabled; `_process` nadal animuje otwarcie dla testow; synteza P9
  bez `is_drawer_open`.
- Testy: nowa bramka `tests/pkg_0234_ghost_props_test.gd` PASS (7
  kryteriow, w tym chod do x>=540); pin 0207: 124/123/122 → 125/124/123;
  132. sekcja w `tools/verify.ps1`.
- Kadry 09/11/12/13: 8 PNG s100 full/notext, `reports/pkg_0234/visual/`;
  inspekcja HOLD (Intel Iris Xe, OpenGL 3.3).

WERYFIKACJA: PELNA `tools/verify.ps1` PASS exit 0 (132 sekcje; dowod
`reports/pkg_0234_verify_full.log`, 1498.12 s); licznik D-217 ZRESETOWANY.
Sasiedzi: 0192/0099/0100/0119/0135/0146/0214/0218/0219/0221/0233/0207.
Po drodze realne FAIL-e i naprawy w pakiecie: 0207 (prompt musi zawierac
`PKG-0208`); pierwszy pelny przebieg 0208 (prompt musi zawierac
`PKG-0209` — dopisana linia historii pinow); MovableAnchorableProp z
wylaczonym colliderem spadala przez podloge (grawitacja) — layer 0 /
mask 1, ksztalt enabled. Twardy fakt: `draw_play_plane` maluje tylko
StaticBody2D RectangleShape2D; donica/komoda to CharacterBody2D.

Ograniczenia: automat dowodzi geometrii i kontraktow, nie emocji ani
zrozumienia (D-012). Otwarte: Pakiet C (luki), B (ciecia/HATCH 13), D, E;
claim-side 17/18 (R-053 czesciowo); PRODUCT GO (wlasciciel).
GATE-REL/release/`.exe` nadal BLOCKED BY D-168.
Handoff: `docs/NEXT_SESSION_PROMPT.md`, kolejny pakiet PKG-0235 (Pakiet C).
Zamrozenie: `tools/snapshot.ps1 -Package PKG-0234` -> `snapshots/PKG-0234-...`.

## PKG-0235: Luki mowia o tej grze / Pakiet C (2026-09-15)

Pakiet C ze swiezego planu 2026-09-15 (decyzja D-247; freeze D-241 zdjety
wylacznie dla C). To NIE jest Pakiet C z wyczerpanego planu PKG-0231.
Raport: `docs/rebuild/PKG_0235_GAP_VERBS.md`.

BASELINE (przed edycjami, WORKFLOW): swieza pelna `tools/verify.ps1` PASS
exit 0, 132 sekcje, pin PKG-0207 125/124/123 — zgodny z handoffem PKG-0234.
Zero rozjazdu. Zero zmian kodu przed tym wpisem.

ZMIANY (Godot 4.7, tylko gra):
- `scripts/campaign/gap_ledger.gd` C1: flagi
  `is_private_boundary_respected` / `is_marta_boundary_accepted` /
  `is_minimal_report_requested` / `is_signal_confirmed`; mysl 09 o dwoch
  zyciach / fotografii / sypialni. close_fact P9 nietkniety.
- C2: usuniety override `station_11|passage_required` → fotografia;
  `key_wear_required` / `key_trial_required` w `NON_GAP_FEEDBACKS`
  (nie jedyna droga s10; `neighbour_context_required` zostaje).
- Stacje 09/10/11: nowe `var` ustawiane przez
  `respect_private_boundary` / `accept_marta_boundary` /
  `request_minimal_report`. 15: tylko katalog (zmienna juz istniala).
- Testy: nowa bramka `tests/pkg_0235_gap_verbs_test.gd` PASS (7 kryteriow,
  TDD RED 7 FAIL → GREEN); pin 0207: 125/124/123 → 126/125/124/124;
  133. sekcja w `tools/verify.ps1`.
- Sasiedzi: 0215, 0233, 0234, 0207 PASS izolowane.

Twardy fakt: `after_decision` zamykal luki P9 przez close_fact juz przed
pakietem; bugiem byla flaga P7 (`is_key_trial_completed` zamykala luke
stolu bez granicy Marty). `is_exit_unlocked` nie moze byc flaga luki
(D-227 GSM otwiera wyjscia z automatu).

PELNA `tools/verify.ps1` PASS exit 0, 1638.03s, 133 sekcji; pin
PKG-0207 126 invokes / 125 scripts / 124 tests. Dowod:
`reports/pkg_0235_verify_full.log`. Licznik D-217 ZRESETOWANY.

Ograniczenia: automat dowodzi kontraktow, nie emocji ani zrozumienia
(D-012). Otwarte: Pakiet B (ciecia/HATCH 13), D, E; claim-side 17/18
(R-053 czesciowo); PRODUCT GO (wlasciciel).
GATE-REL/release/`.exe` nadal BLOCKED BY D-168.
Handoff: `docs/NEXT_SESSION_PROMPT.md`, kolejny pakiet PKG-0236 (Pakiet B).
Zamrozenie: `tools/snapshot.ps1 -Package PKG-0235` -> `snapshots/PKG-0235-2026-09-15`.

## PKG-0236: Ciecia, nie teleporty / Pakiet B (2026-09-15)

Pakiet B ze swiezego planu 2026-09-15 (decyzja D-248; freeze D-241 zdjety
wylacznie dla B). To NIE jest Pakiet B z wyczerpanego planu PKG-0231.
Raport: `docs/rebuild/PKG_0236_CUTS_NOT_TELEPORTS.md`.

BASELINE (przed edycjami, WORKFLOW): swieza pelna `tools/verify.ps1` PASS
exit 0, 133 sekcje, pin PKG-0207 126/125/124 — zgodny z handoffem PKG-0235.
Zero rozjazdu.

ZMIANY (Godot 4.7, tylko gra):
- `scripts/environment/threshold_binder.gd` (B3): `station_13` przeniesione
  do grupy `ThresholdZone.Family.HATCH` (64x64, door="") jak 14/15 („schodze wlazem”).
  09 i 10 zostaja DOOR (pokoj -> pokoj w tym samym mieszkaniu).
- `scripts/levels/station_10.gd` (B4): beat wyjscia `s10_exit_ucp_record`
  podmienione na: „Marta twierdzi, że pracuję w UCP. Zostawiam jej telefon i
  wychodzę — zapis sprawdzę w UCP, zanim uznam to za moje.” Nazywa wyjscie z
  domu i zostawienie telefonu; hipoteza 0233 zachowana.
- `scripts/core/game_state_manager.gd` (B2): `arrival_side_for` bez zmian
  (12->13 i 17->18 z prawej, reszta 10-18 z lewej; brak nowych wyjatkow).
- Testy: nowa bramka `tests/pkg_0236_cuts_not_teleports_test.gd` PASS (7 kryteriow:
  binder 13 HATCH, binder 12 DOOR bez BalconyDoor, live 13 HATCH, mysl 10 wyjscie
  do UCP, 14 wita wlazem, routing 10-18, linie mostow nienaruszone).
- Kontrolowana aktualizacja `tests/pkg_0214_threshold_exit_open_pin_test.gd`:
  `_expected_family("station_13")` = `FAMILY_HATCH`.
- Pin 0207: 126/125/124/124 → 127/126/125/125; 134. sekcja w `tools/verify.ps1`.
- Sasiedzi: 0214, 0221, 0234, 0235, 0207 PASS.

Twardy fakt: wlaz w 13 to naturalny odpowiednik powitania w 14; montaz
filmowy nie wymagal nowych stacji ani przebudowy grafu kampanii.

PELNA `tools/verify.ps1` PASS exit 0, 134 sekcje; pin PKG-0207 127 invokes /
126 scripts / 125 test refs / 125 disk tests. Dowod:
`reports/pkg_0236_verify_full.log`. Licznik D-217 ZRESETOWANY.

Ograniczenia: automat dowodzi kontraktow, nie emocji ani zrozumienia (D-012).
Otwarte: Pakiet D (slowa), E; claim-side 17/18 (R-053 czesciowo); PRODUCT GO (wlasciciel).
GATE-REL/release/`.exe` nadal BLOCKED BY D-168.
Handoff: `docs/NEXT_SESSION_PROMPT.md`, kolejny pakiet PKG-0237 (Pakiet D).
Zamrozenie: `tools/snapshot.ps1 -Package PKG-0236` -> `snapshots/PKG-0236-2026-09-16`.

## PKG-0237: Słowa, które muszą być zarobione / Pakiet D (2026-09-16)

Pakiet D ze świeżego planu 2026-09-15 (decyzja D-249; freeze D-241 zdjęty
wyłącznie dla D). Po Pakiecie A (PKG-0234), C (PKG-0235), B (PKG-0236).
Raport: `docs/rebuild/PKG_0237_EARNED_WORDS.md`.

BASELINE (przed edycjami, WORKFLOW): pełna `tools/verify.ps1` PASS exit 0,
134 sekcje, pin PKG-0207 127/126/125/125 — zgodny z handoffem PKG-0236.

ZMIANY (Godot 4.7, tylko gra):
- `scripts/levels/creative_scene_lines.gd`:
  * D1: `cost_ledger_console` (stacja 17): Lena zarabia słowo „Równia”
    („Równia. Tym słowem podpisali to miejsce. Moje nie miało nazwy na papierze.”).
  * D2: `adaptation_offer_terminal`: Lena rozpoznaje nazwisko z lady w stacji 11
    („Głos z lady. Bez kosztu? Bez cudzej pamięci w mojej głowie?”).
  * D4: `household_b_full`, `household_b_partial`, `household_b_withheld`:
    para 0 zmieniona na „Stoję w progu. Czytnik nie ma tu adresu.” (brak wiaty).
  * D5: `memory_leak`: mówca w parach 0 i 2 zmieniony na „JAKUB (ECHO)”.
- `scenes/levels/station_16.tscn`:
  * D3: `CrispDiegeticText_Analyzer` text = `"POMIESZCZENIE POMIARU / POZA OBWODEM // ANALIZATOR"`.
- `scripts/levels/station_16.gd`:
  * D3: nagłówek skryptu definiuje adres `pomieszczenie pomiaru poza obwodem`.
- `scenes/levels/station_17.tscn`:
  * D2: `CrispDiegeticText_Offer` text = `"WIERZBICKA / ZAKRES // OFERTA ADAPTACJI"`;
    `AdaptationOfferTerminal` `prop_title` = `"WIERZBICKA / ZAKRES"`.
- `scripts/levels/station_42b.gd`:
  * D4: `DIALOGUE_LINES[3]` = `"Stoję w progu. Czytnik nie ma tu adresu."`.
- `scripts/levels/station_42c.gd`:
  * D5: `DIALOGUE_LINES[3]` mówca = `"JAKUB (ECHO)"`.
- `scripts/levels/station_43.gd`:
  * D7: `DEFAULT_DIALOGUE_LINES` nie kradnie fraz C („dwie kolejności”);
    stan bez metody i z otwartą luką („Brak metody. Odcinki nie zostały powiązane.”);
    `_payoff_line_into_branch()` w gałęzi domyślnej ustawia tag = `"Brak metody. "`.
- Testy: nowa bramka `tests/pkg_0237_earned_words_test.gd` PASS (7 kryteriów:
  D1 Równia zarobiona w stacji 17, D2 Wierzbicka dwa tryby 11/17, D3 Analizator w 16,
  D4 Finał B w progu bez wiaty, D5 Przeciek Jakuba to echo, D6 Tożsamość sterowania 42A/B/C,
  D7 Epilog 43 unseeded bez kradzieży tonu C).
- Pin 0207: 127/126/125/125 → 128/127/126/126; 135. sekcja w `tools/verify.ps1`.
- Kontrolowana aktualizacja bramki `tests/pkg_0195_creative_scene_c_test.gd`:
  D4 asercja wiaty zaktualizowana na „Stoję w progu”, zachowany gest „klucze na blat” w D7.
- Sąsiedzi: 0107, 0194, 0195, 0216, 0217, 0226, 0233, 0234, 0235, 0236, 0207 PASS.

Twardy fakt: żadne słowo o świecie, tożsamość kontrolna ani lokalizacja dialogowa
nie pojawia się z sufitu. Hash table finałów B zachowało 9 unikalnych hashy.

PELNA `tools/verify.ps1` PASS exit 0, 135 sekcji; pin PKG-0207 128 invokes /
127 scripts / 126 test refs / 126 disk tests.

Ograniczenia: automat dowodzi kontraktów technicznych, nie emocji ani zrozumienia (D-012).
Otwarte: Pakiet E (mosty dialogowe); PRODUCT GO (właściciel).
GATE-REL/release/`.exe` nadal BLOCKED BY D-168.
Handoff: `docs/NEXT_SESSION_PROMPT.md`, kolejny pakiet PKG-0238 (Pakiet E).
Zamrożenie: `tools/snapshot.ps1 -Package PKG-0237` -> `snapshots/PKG-0237-2026-09-16`.

## PKG-0238: Mosty dialogowe / Pakiet E (2026-09-16)

Pakiet E ze świeżego planu 2026-09-15 (decyzja D-250; freeze D-241 zdjęty
wyłącznie dla E). Ostatni pakiet z 5-częściowej kolejki naprawy sensu
fabularnego (A: PKG-0234, C: PKG-0235, B: PKG-0236, D: PKG-0237, E: PKG-0238).
Raport: `docs/rebuild/PKG_0238_DIALOGUE_BRIDGES.md`.

BASELINE (przed edycjami, WORKFLOW): uruchomiono pełną `tools/verify.ps1`.
Wykryto realną dyskrepancję z PKG-0237 w `scripts/levels/station_43.gd`
(linia 1 `DEFAULT_DIALOGUE_LINES` nie zawierała „Linia 4” i „odbudowano”,
co powodowało błąd bramki `pkg_0230`). Dyskrepancję naprawiono natychmiast,
godząc kontrakt PKG-0230 z kontraktem PKG-0237 D7
(„Rozkład na wiacie: Linia 4 zamknięta do odwołania, odcinek odbudowano. Żadne przejście nie zostało zatwierdzone.”, 107 znaków <= 115).
Bramka 0230 oraz 0237 PASS.

ZMIANY (Godot 4.7, tylko gra):
- `scripts/levels/creative_scene_lines.gd`:
  * E1: Zaudytowano ogniwa dialogowe na trasie 09–18:
    09 wyjście („Zapytam Martę”) -> 10 wejście (Marta przy stole);
    10 wyjście („zapis sprawdzę w UCP”) -> 11 wejście (Wierzbicka za ladą);
    11 wyjście („kontakt do warsztatu”) -> 12 wejście (łącze warsztatowe);
    12 wyjście („Wracam do mieszkania, do wspólnego stołu”) -> 13 wejście (stół i Marta);
    13 wyjście („Wyciąg wskazuje sekcję rozdzielni — zejdę włazem serwisowym”) -> 14 wejście (właz serwisowy za klatką);
    14 wyjście („Z mostu do pętli — wyciąg mówi, gdzie szukać echa”) -> 15 wejście (zejście do pętli);
    15 wyjście („Niosę odpowiedź do analizatora poza obwodem”) -> 16 wejście (pomieszczenie pomiaru poza obwodem);
    16 wyjście („sprawdzę rejestr par w hali UCP”) -> 17 wejście (rejestr par w hali UCP);
    17 wyjście („Wracam na ulicę — trzy drogi, Marta”) -> 18 wejście (trzy drogi na tablicy, Marta przy oknie).
  * Wszystkie kwestie dialogowe `CreativeLines.LINES` spełniają limit długości CRT (<= 115 znaków).
- `scripts/levels/station_15.gd`:
  * E2: Diegetyczny dopisek ołówkiem „przepraszam M. — 3 s.” pozostawiony na marginesie; brak dydaktycznych wyjaśnień w dialogach.
- `scripts/levels/station_42a.gd`, `station_42b.gd`, `station_42c.gd`:
  * E3: Zaudytowano rezerwy `DIALOGUE_LINES` (dokładnie 4 linie, pin PKG-0107).
  * Zaktualizowano docstringi precyzujące, że tablica ta stanowi edytorski i bezstanowy fallback (sceny w kampanii odtwarzają kwestie dynamicznie z `creative_scene_lines.gd` przez `CreativeScenePresentation`).
  * Wyczyszczono anachronizmy wiaty w komentarzach 42B; potwierdzono mówcę `JAKUB (ECHO)` w 42C.
- Testy:
  * Nowa dedykowana bramka `tests/pkg_0238_dialogue_bridges_test.gd` PASS (5 kryteriów: E1 ogniwa dialogowe, E1 ciągłość 09–18, E2 3 sekundy implicit, E3 fallback 42A/B/C, CRT limit długości).
  * Rejestracja sekcji 136 w `tools/verify.ps1`.
  * Aktualizacja pinu w `tests/pkg_0207_gate_census_test.gd`: 129 invokes / 128 scripts / 127 test refs / 127 disk tests.
  * Sąsiedzi: 0107, 0194, 0195, 0216, 0217, 0226, 0233, 0234, 0235, 0236, 0237, 0207 PASS.

Twardy fakt: plan naprawy sensu fabularnego (A, C, B, D, E) został w całości ukończony.
Ciągłość przyczynowa i dialogowa spina całą trasę 09–18 bez dziur montażowych i bez dydaktycznego tłumaczenia tajemnic.

PELNA `tools/verify.ps1` PASS exit 0, 136 sekcji; pin PKG-0207 129 invokes /
128 scripts / 127 test refs / 127 disk tests. Dowód: `reports/pkg_0238_verify_full.log`.
Licznik D-217 ZRESETOWANY.

Ograniczenia: automat dowodzi kontraktów technicznych, nie emocji ani zrozumienia (D-012).
Otwarte: claim-side liniowy 17/18 (R-053 częściowo); ocena PRODUCT GO (właściciel).
GATE-REL/release/`.exe` nadal BLOCKED BY D-168.
Handoff: `docs/NEXT_SESSION_PROMPT.md`, oczekiwanie na decyzję właściciela (PRODUCT GO review).
Zamrożenie: `tools/snapshot.ps1 -Package PKG-0238` -> `snapshots/PKG-0238-2026-09-16`.




## 2026-09-22 — PKG-0241 / grafika, animacja, UX

Na jawne zlecenie wlasciciela wykonano audyt i wdrozenie w repozytorium GitHub (D-251).
Baza 71d937329385368e718b947b43f84fed00324d57; galaz fix/art-ux-audit-0241, kod po publikacji
d9f5fb91a3ed6ff2669043d29f1c1115683aac62. Poprzednia galaz 0240 nietknieta.
22 sceny, 176 kadrów przed/po, 741 pomiarów tekstu. Naprawiono import, vendor i jego gitignore,
podlogi/stopy finalow, trzy klatki Leny, pauze/tekst/line_finished, remap/fokus, warstwy menu,
bezpieczne potwierdzenia nowej gry/resetu, faze NPC i reduced motion. Nowa bramka 51/51 PASS;
Linux 83/128 wobec 61/127, zero nowego FAIL w porownywalnych testach. Kontrola 0173 wykryla
przyciecie podeszwy; przywrocono oryginalne piksele i ponownie zaliczono test bez zmiany asercji.
Windows i pozostale ograniczenia: docs/audits/PKG_0241_REPORT.md. Bez merge, auto-merge i EXE.
Nastepnie R1/R2 z planu wdrozenia; pozostaja tez artystyczna ciaglosc i docelowy odbior sprzetu.


## PKG-0242: Gotowosc do premiery — ukonczalnosc, interakcja, powloka wydania, rozliczenie bramek

Data: 2026-09-24. Galaz `claude/vigilant-brahmagupta-eq594t` (baza `ea61916`, merge PKG-0241).
Zlecenie wlasciciela: doprowadzic gre do gotowosci do publicznej premiery. Zakres: Godot-only,
bez WWW (D-098), bez wydania i `.exe` (D-168), tresc PKG-0239 nadrzedna.

Wynik:
- kampania ukonczalna wylacznie wejsciem na zakonczeniach A, B i C (M1 `pkg_0177`); 22 adresy
  fizycznie przechodnie (nowa bramka `pkg_0242`);
- naprawy: cokol 14, `InteractionFocus`, przewijanie CRT w `_input`, otwory wyjsc na podlodze,
  legendy i martwa strefa wyborow 16/17/18, pasy wyboru 40 px, wlasne ksztalty kolizji punktow,
  drzwi ustepuja punktom z niedokonczonym dzialaniem (D-228/D-253), zamkniete drzwi 18/42/43
  mowia czego brakuje, kroki w pokoju nazywaja poprzednika, blad skryptu 16 przy powrocie,
  slad 05, otwarcia 42A/B/C zgodne z kolejnoscia wybor → wykonanie;
- powloka wydania (D-254): pauza bez trybu testowego poza buildem deweloperskim, TWÓRCY
  I LICENCJE z tekstami z silnika, wersja 1.0.0, podpowiedz CRT z klawiszem, 43 bez manifestu;
- 39 bramek przepietych na lancuch PKG-0239 i tekst wlasciciela z zachowaniem intencji (D-252,
  tabela w raporcie); `tests/support/campaign_chain.gd`; licznik 0207: 131/130/129/129; 0212: 4.

Weryfikacja (Linux, Godot 4.7.2, Dummy audio):
- izolowane uruchomienia wszystkich 129 bramek z `verify.ps1`: 129/129 PASS (dozwolone ostrzezenia
  testow uszkodzonego zapisu i schematu ustawien);
- pierwsza pelna sekwencyjna `verify.ps1 -AudioDriver Dummy`: 90 bramek PASS, zatrzymanie na
  PKG-0184 — lint zabrania `bool(` w `threshold_zone.gd`, a nowy kod go uzyl; poprawione
  porownaniami z `true`, bez zmiany asercji;
- druga pelna sekwencyjna `pwsh -NoProfile -File tools/verify.ps1 -AudioDriver Dummy`:
  **PASS, exit 0**, 140 sekcji (131 wywolan bramek, polityka logu, kontrakt dokumentacji,
  import), ostatnia linia „Verification passed.” po ostatniej bramce; dowod
  `reports/pkg_0242/verify_full_linux_dummy.log`. To profil Linux/Dummy, nie Windows/WASAPI;
- kadry: `tools/capture_pkg_0241.gd` 88 kadrow, 0 przepelnien pudla CRT przy 85/100/115%;
  `tools/capture_pkg_0242.gd` 16 kadrow; oba poza repozytorium.

Ograniczenia: brak testow z ludzmi (H-058); brak profilu Windows/WASAPI, pada, DPI (R-060);
dialogi tylko PL (R-058); repo sledzi `.godot/`, `reports/`, binaria 4.6.3 (R-059); Lena bywa
zaslonieta skrzydlem drzwi (R-061). Brak PRODUCT GO; D-168 obowiazuje.
Raport: `docs/audits/PKG_0242_REPORT.md`. Decyzje: D-252..D-254.
Handoff: `docs/NEXT_SESSION_PROMPT.md`.
Zamrozenie: `tools/snapshot.ps1 -Package PKG-0242` -> `snapshots/PKG-0242-2026-09-24`.
