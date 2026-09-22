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

Status: **TECHNICZNIE ZAMKNIETY; H-001 = ACCEPTED-RISK (PKG-0113)**

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

Domkniecie:

- T4 i T5 w wersji z testerami sa **anulowane**;
- profil A jest technicznym baseline produkcyjnym, ponieważ cały aktualny
  runtime i deterministyczny smoke używają jego parametrów;
- nie jest to dowód przyjemności ruchu. H-001 ma `ACCEPTED-RISK`: skutkiem
  błędu byłaby konieczność ponownej kalibracji zasobu profilu i całego smoke,
  bez zmiany zestawu czasowników lub fabuły.

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

Status: **ZAWARTOŚĆ TECHNICZNA UKOŃCZONA; BRAMKA PRODUKTU NIEZAMKNIĘTA**

Wszystkie sceny 01..43 istnieją i są wywoływane przez pełny smoke, ale projekt
nie ma jeszcze produkcyjnego punktu wejścia, pełnego łańcucha 26..43, eksportu
Windows/Linux ani testu czystej instalacji. Szczegóły:
`IMPLEMENTATION_PLAN_AUDIT_AND_RELEASE_READINESS.md`.

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

## P4. Produkcja i Szlif Gry w Silniku Godot 4.7 (Pure Godot Game Focus, D-089, D-091)

Status: **W TOKU** (jedyny zakres prac: **gra Godot 4.7**, D-098)

Postęp PKG-0094: pętla kampanii ma wersjonowany zapis lokalny, checkpoint,
bezpieczny reload/reset, menu pauzy i selektor 43 przestrzeni z odblokowaniem
kampanii oraz jawnym trybem testowym. Rówień Vector-Stage objął ręcznie
Station 06..10; techniczny dowód to `tests/pkg_0094_smoke_test.gd`, capture
Windows i audyt `docs/VECTOR_STAGE_ACT_I_AUDIT.md`. Następny batch rozszerza
konwersję o Station 11..15 i domyka przejścia kampanii między stacjami.

Postęp PKG-0095: Rówień Vector-Stage objął ręcznie Station 11..15, z audytem
Aktu II i capture Windows. Istniejące sygnały `level_completed` Station 01..15
zostały połączone centralnie z zapisem, odblokowaniem i przejściem fade w
`GameStateManager`; Station 15 jest jawną, przetestowaną granicą batchu.
Następny batch konwertuje Station 16..20 i rozszerza granicę przejść wyłącznie
wraz z odpowiednim testem kontraktowym.

Postęp PKG-0096: Rówień Vector-Stage objął ręcznie Station 16..20, z audytem
Aktu IIb (`docs/VECTOR_STAGE_ACT_IIB_AUDIT.md`) i capture Windows. Łańcuch
ukończeń rozszerzono do Station 20.

Postęp PKG-0097: Rówień Vector-Stage objął ręcznie Station 21..25, z audytem
Aktu IIc (`docs/VECTOR_STAGE_ACT_IIC_AUDIT.md`) i capture Windows. Naprawiono
defekt D-096: do tego pakietu warstwa Vector-Stage była zasłaniana przez
nieprzezroczyste tło rysowane przez skrypt stacji, więc konwersja Aktów I/II/IIb
jest w grze niewidoczna. Station 21..25 rysują wyłącznie warstwę stanu
(`_draw_state_layer()`); kadr należy do `VectorStageEnvironment`. Łańcuch
ukończeń rozszerzono do Station 25 razem z testem, a bramki PKG-0095/0096/0097
wpięto do `tools/verify.ps1`. Następny batch (PKG-0098) przenosi wzorzec D-096 na
Station 01..20, wzmacnia smoke o kontrolę widoczności kadru i konwertuje
Station 26..30.

Postęp PKG-0100: wzorzec widocznego kadru został przeniesiony na Station 01..10.
Station 01..05 otrzymały ręczne profile Vector-Stage, Station 06..10 po jednej
przeszkodzie diegetycznej z katalogu R, a `AnchorableObject` dostał ograniczoną,
celową warstwę rysunku bez zmiany API, logiki i colliderów. Dodano bramkę
`pkg_0100_smoke_test.gd`, capture Windows i audyt `TRAVERSAL_ACT_I_AUDIT.md`.
Łańcuch kampanii pozostaje zamknięty na limicie 25. Pozostały dług widoczności
obejmuje Station 16..20; następny pakiet to PKG-0101.

Postęp PKG-0101: dług D-096 został spłacony dla Station 16..20. Station 17
otrzymała jedną przeszkodę R5 (`PneumaticDossierCapsule`), a Station 19 i 20
po jednej przeszkodzie R1 (`Line4ModelTable` i `SzymonWellDrawing`). Station 16
i 18 zachowują sceniczny oddech bez sztucznej przeszkody. Każdy wdrożony koszt
ma zapis decyzji, reset checkpointu i trwały zanik detalu; test PKG-0101,
capture Windows i audyt `TRAVERSAL_ACT_IIB_AUDIT.md` są wykonane. Limit kampanii
25 pozostaje bez zmian. Następny pakiet nie rozszerza tego zakresu bez osobnego
audytu.

Postęp PKG-0102: domknięto techniczny plaster Station 21..25. Każda warstwa
stanu zaczyna się od `VectorStageStyle.draw_play_plane()`, a test źródłowy
potwierdza, że droga wynika z istniejących colliderów. Wdrożono dokładnie
jedną przeszkodę diegetyczną R2 w Station 22
(`Geometry/BiometricIdentityGate`), z korektą, checkpointem, zapisem kosztu
i wygaszeniem detalu. Station 21, 23, 24 i 25 zachowują świadomy rytm bez
sztucznej przeszkody. Powstały bramka `pkg_0102_smoke_test.gd`, capture
Windows oraz audyt `TRAVERSAL_ACT_IIC_AUDIT.md`. Limit kampanii 25, istniejące
collidery, zasięgi, InputMap i fizyka 60 Hz pozostały bez zmian. Następny
pakiet może audytować Station 26..30, ale nie może rozszerzyć łańcucha bez
osobnej decyzji i testu.

Postęp PKG-0103: domknięto techniczny plaster Station 26..30. Każda warstwa
stanu zaczyna się od `VectorStageStyle.draw_play_plane()`. Wdrożono dokładnie
dwie przeszkody diegetyczne: R5 `Geometry/AdaptiveIsolationPartition` w
Station 26 i R1 `Geometry/WitnessRelayBank` w Station 30; Station 27..29
pozostają świadomą ciszą. Obie korekty zapisują koszt, resetują checkpoint i
wygaszają detal. Powstały bramka `pkg_0103_smoke_test.gd`, capture Windows i
audyt `TRAVERSAL_ACT_III_AUDIT.md`. Limit kampanii 25, istniejące collidery,
zasięgi, InputMap i fizyka 60 Hz pozostały bez zmian. Następny pakiet to
PKG-0104 dla Station 31..35 i wymaga osobnego audytu przed implementacją.

Postęp PKG-0104: domknięto techniczny plaster Station 31..35. Każda warstwa
stanu zaczyna się od `VectorStageStyle.draw_play_plane()`, a sceny otrzymały
profile `VectorStageEnvironment`, `AtmosphereRig`, `CRTDialogueBox` i
`OpeningDialogueCue`. Wdrożono dokładnie dwie przeszkody diegetyczne: R6
`Geometry/ObservedGlassTrace` w Station 32 oraz R1
`Geometry/DualWitnessFrame` w Station 33; Station 31, 34 i 35 pozostają
świadomą ciszą. Obie korekty zapisują koszt, resetują checkpoint i wygaszają
konkretny detal. Powstały bramka `pkg_0104_smoke_test.gd`, capture Windows i
audyt `TRAVERSAL_ACT_IIIB_AUDIT.md`. Limit kampanii 25, istniejące collidery,
zasięgi, InputMap i fizyka 60 Hz pozostały bez zmian. Następny pakiet to
PKG-0105 dla Station 36..40 i wymaga osobnego audytu przed implementacją.

Postęp PKG-0105: domknięto techniczny plaster Station 36..40. Każda warstwa
stanu zaczyna się od `VectorStageStyle.draw_play_plane()`, a sceny otrzymały
profile `VectorStageEnvironment`, `AtmosphereRig`, `CRTDialogueBox` i
`OpeningDialogueCue`. Wdrożono dokładnie jedną przeszkodę diegetyczną: R3
`Geometry/JakubRescueBulkhead` w Station 38; Station 36, 37, 39 i 40
pozostają świadomą ciszą. Korekta zapisuje decyzję, resetuje checkpoint i
wygasza detal węzła ratunkowego. Powstały bramka `pkg_0105_smoke_test.gd`,
capture Windows oraz audyt `TRAVERSAL_ACT_IIIC_AUDIT.md`; pięć kadrów zostało
obejrzanych. Limit kampanii 25, istniejące collidery, zasięgi, InputMap i
fizyka 60 Hz pozostały bez zmian. Następny pakiet to PKG-0106 dla Station 41.

Postęp PKG-0106: domknięto techniczny plaster Station 41 jako Komorę Wyboru
Operacyjnego. Scena otrzymała ręczne profile `VectorStageEnvironment`,
`AtmosphereRig`, `CRTDialogueBox` i `OpeningDialogueCue`; warstwa stanu stacji
zaczyna się od `VectorStageStyle.draw_play_plane()`, pokazuje trzy operacje A/B/C
i zachowuje istniejący łańcuch ukończenia do granicy 25. Audyt
`TRAVERSAL_ACT_IV_AUDIT.md` wybrał świadomą ciszę: nie dodano żadnej przeszkody,
`AnimatableBody2D` ani nowego `StaticBody2D`. Powstały bramka
`pkg_0106_smoke_test.gd`, capture Windows i jeden obejrzany kadr
`reports/pkg_0106/station_41.png`. Pełny verify przechodzi, a poprawki testów
PKG-0104/0105 przywracają asercję checkpointu do właściwej granicy resetu.
Limit kampanii 25, istniejące collidery, zasięgi, InputMap i fizyka 60 Hz
pozostały bez zmian. Następny pakiet to PKG-0107 dla Station 42A..42C i 43.

Postęp PKG-0107: domknięto widoczną warstwę Vector-Stage dla finałów 42A, 42B,
42C i epilogu 43. Każda scena ma deterministyczny profil, `AtmosphereRig`,
`CRTDialogueBox` i `OpeningDialogueCue`, a aktywna warstwa stanu zaczyna od
`VectorStageStyle.draw_play_plane()`. Audyt
`TRAVERSAL_ACT_IV_FINAL_AUDIT.md` wybrał świadomą ciszę: łączny budżet nowych
przeszkód wynosi 0, bez nowych colliderów, `AnimatableBody2D` i
`StaticBody2D`. Powstały bramka `pkg_0107_smoke_test.gd`, capture Windows i
cztery obejrzane kadry finałów. Limit kampanii 25, istniejące collidery,
zasięgi, InputMap i fizyka 60 Hz pozostały bez zmian. Następny pakiet to
PKG-0108: techniczny audyt czytelności H-012.

Postęp PKG-0108: wykonano techniczny audyt rastera czytelności dla 12 świeżych
kadrów, 63 pomiarów, 48 kontroli skal i 36 transformacji widzenia barw. H-012
pozostało `UNTESTED`, ponieważ roadmapa nie definiuje progu odbiorczego, a
automatyczny pomiar nie jest playtestem.

Postęp PKG-0109: wykonano świeży audyt kosztu H-005. Zmierzono dziewięć
reprezentatywnych kadrów świata, dodatkowy Station 02, dwa kadry świata z CRT,
cykl proceduralnej protagonistki oraz inventory 45 zasobów odpowiadających 43
przestrzeniom kampanii. H-005 pozostaje `TECHNICAL`, bo istnieje wymóg 60 FPS,
ale nie ma jawnego budżetu liczbowego renderu ani produkcji. Nie zmieniono
scen, logiki, colliderów, limitu 25 ani rozgałęzień. Następny pakiet to
PKG-0110: kontrakt budżetu i powtarzalność pomiaru H-005.

Postęp PKG-0110: zapisano plan i audyt powtarzalności H-005 w
`docs/VECTOR_STAGE_REPEATABILITY_AUDIT_H-005.md`. Dwa niezależne świeże
procesy normalnego Godot 4.7/OpenGL na tym samym Windows/Intel Iris Xe
zakończyły się PASS; metadane i liczności próbek są zgodne, a statyczne canvas
metrics dziewięciu wymaganych kadrów powtarzają się dokładnie. Czasy, zwłaszcza
p95 GPU, zachowują zmienność między procesami i zostały zachowane jako wynik.
Nie znaleziono uprzednio istniejącego jawnego budżetu renderu, CPU/GPU, canvas
ani kosztu produkcji; `16.667 ms` nie zostało ustanowione z 60 Hz. H-005
pozostaje `TECHNICAL`, nie zmieniono kodu gry ani kontraktów runtime.

Postęp PKG-0111: audyt `docs/VECTOR_STAGE_BUDGET_PROVENANCE_AUDIT_H-005.md`
prześledził aktualne źródła, decyzje, roadmapę, ryzyka, konfigurację projektu,
harness i oba świeże przebiegi PKG-0110. Nie znaleziono uprzedniego, liczbowego
budżetu z jednoznacznym zakresem i metodą spełnienia. Wymaganie 60 FPS,
viewport 640x360 i fizyka 60 Hz pozostały rozdzielone od budżetu subsystemu;
`16.667 ms` nie zostało ustanowione z 60 Hz. H-005 nadal ma status
`TECHNICAL`, a produkt pozostał niezmieniony. Następny pakiet to PKG-0112:
kontrolowane przyjęcie ewentualnego uprzedniego źródła budżetu i bezpośrednia
weryfikacja bez retroaktywnego progu.

Postęp PKG-0113: audyt runtime ujawnił, że produkt startuje w Movement Lab,
centralny łańcuch kończy się na Station 25, nie ma menu głównego ani presetów
eksportu, a główny smoke mimo zdefiniowanych funkcji wykonywał tylko Station
01..19. Smoke uruchamia teraz Station 01..41, 42A..42C i 43 oraz sprawdza
granice Zakotwiczenia Station 32/38. Wykonano także wspólną remediację
Vector-Stage, proceduralny portret CRT i dopasowanie pełnego selektora pauzy do
640x360. Produkt nadal nie jest gotowy do wydania; następna praca zaczyna od
produkcyjnego shellu i pełnej topologii kampanii, nie od kolejnych przeszkód.

Postęp PKG-0114: `run/main_scene` wskazuje produkcyjny shell, a `GameStateManager`
prowadzi normalną kampanię przez 01..41, dokładnie jeden wybrany wariant 42,
43 i powrót do tytułu. Shell ma prawdziwe Nowa gra/Kontynuuj/Ustawienia/Zakończ,
save schema 1 pozostał kompatybilny, a gate używa realnych sygnałów ukończenia
dla wszystkich trzech gałęzi. R0 jest zamknięty technicznie; R1 zaczyna się od
remapu, pełnego pada, skali tekstu, PL/EN i testu trwałości ustawień. Nie
zmieniono colliderów ani świadomej ciszy finałów.

Postęp PKG-0115: R1 jest zamknięty technicznie. Wspólny ekran ustawień obsługuje
Master, tempo tekstu, skalę tekstu, fullscreen i PL/EN dla shellu/UI, a osobny
plik ustawień ma własny schema 1 i bezpieczny fallback. Shell, ustawienia i
pauza mają semantyczny fokus klawiatury/pada; pięć produkcyjnych akcji ma
kontrolowany remap z wykrywaniem konfliktu, defaults i trwałością. Gate
`pkg_0115_smoke_test.gd` oraz siedem kadrów normalnym driverem dowodzą kontraktów
technicznych w 640x360. Nie zmieniono trasy 01..41 → 42A/B/C → 43, save schema 1,
colliderów ani świadomej ciszy finałów; odbiór przez ludzi pozostaje bez dowodu.

Główne filary produkcji w Godot, w **kolejności priorytetu**:

### Filar 0 (najwyższy priorytet): Przestrzeń grywalna

Audyt PKG-0100 wykazał, że **38 z 43 pozycji kampanii miało wtedy dokładnie
cztery collidery**. Pakiety PKG-0099..0107 przeprowadziły wymagane audyty
każdego wycinka. Część scen dostała fabularnie uzasadnione przeszkody, a część
ma zapisaną świadomą ciszę. Nie istnieje już ogólny mandat „wypełnić pozostałe
pudełka”. Nowy collider wymaga konkretnego problemu świata, testu trzech pytań
i osobnego audytu D-099.

Najwyższym aktualnym brakiem przestrzeni grywalnej nie jest liczba przeszkód.
PKG-0114 spiął istniejące sceny i zakończenia w produkcyjny ciąg 01..41 →
wybrany wariant 42 → 43, zachowując dotychczasowe collidery oraz świadomą
ciszę. PKG-0115 rozwinął systemy R1 bez poszerzania geometrii; następny pakiet
przechodzi do content locka R2.

### Filar 1: Szlif sterowania i game feel (PrototypePlayer)

- Kalibracja reakcji poziomej, coyote time, jump buffering, przyspieszenia i opadania.
- Klatki squash-and-stretch, pył przy skoku i lądowaniu (`CPUParticles2D`), pochylenie przy zwrocie.
- Kinowa kamera 2D z płynnym śledzeniem, dynamicznym deadzone i mikro-wstrząsami przy anomaliach.
- Zestaw czasowników ruchu jest **zamknięty** (kanon przeszkód 7.1).

### Filar 2: Oprawa wizualna poziomów i oświetlenie 2D (Station 01..43)

- Kanoniczną techniką jest własny `Rówień Vector-Stage`: duże płaszczyzny,
  ograniczona paleta, twarde krawędzie, asymetryczne sylwetki i sceniczne
  kadrowanie; zob. `VISUAL_DESIGN.md`.
- Dressing architektury (modernistyczne płytki, kasetony, rury, żeliwo, jarzeniówki 100 Hz).
- Oświetlenie 2D (`PointLight2D`) z cieniami okluzyjnymi i wolumetryczną mgłą.
- Efekty anomalii (przesunięcia cienia, cynobrowe szczeliny) — nigdy jako filtr pełnoekranowy.
- **Stan D-096:** Station 01..20 mają zamkniętą widoczną warstwę stanu w
  PKG-0100/PKG-0101, Station 21..25 w PKG-0097/PKG-0102, Station 26..30 w
  PKG-0103, Station 31..35 w PKG-0104, Station 36..40 w PKG-0105, a Station
  41 w PKG-0106 oraz Station 42A..42C i 43 w PKG-0107. PKG-0108 i PKG-0113
  wykonały pomiary rastera, skalowanie 1x–4x i transformacje widzenia barw.
  H-012 pozostaje `UNTESTED`, ponieważ nie istnieje próg rozstrzygający, a
  automat nie dowodzi czytelności przez nową osobę.

### Filar 3: Interfejs dialogowy i narracyjny w silniku

- Ramki dialogowe w estetyce CRT / Teletype 1978.
- Portrety postaci (Lena Wolska, Marta Kurek, Jakub Wolski, dr Helena Wierzbicka, Szymon Bera, Strażnik).
- Efekt maszyny do pisania zsynchronizowany z proceduralnymi blipami głosu.
- Historia dialogu (backlog) i płynne przewijanie.

### Filar 4: Pełna pętla gry

- Menu główne, ekran pauzy, ustawienia dźwięku i sterowania.
- Menedżer zapisu i punktów kontrolnych spinający 43 przestrzenie oraz 3 rodziny zakończeń.
- Sprzężenie dźwiękowe i wizualne przy badaniu rekwizytów pamięci.

## P5. Alpha i Beta w Silniku Godot

Status: **R0 I R1 TECHNICZNIE ZAMKNIĘTE W PKG-0114/PKG-0115; R2 NASTĘPNY**

Kolejność bramek:

1. **R0 / Alpha shell — ZAMKNIĘTY:** ekran tytułowy, Nowa gra/Kontynuuj/
   Ustawienia/Zakończ, właściwy `run/main_scene`, pełny ciąg 01..41 → 42A/B/C
   → 43 i test end-to-end używający realnych sygnałów ukończenia (`PKG-0114`).
2. **R1 / Beta systemowa — TECHNICZNIE ZAMKNIĘTA:** pełna klawiatura i pad,
   remap, głośność, tempo i skala tekstu, przełączalne PL/EN dla shellu/UI oraz
   test trwałości ustawień (`PKG-0115`). Nie jest to dowód ergonomii ani odbioru.
3. **R2 / Content lock — NASTĘPNY:** ręczny pass obrazu wskazany w audycie PKG-0113,
   odrębne portrety obsady, historia dialogu, miks i zamrożenie treści.

Bramka wyjścia P5: pełny przebieg od ekranu tytułowego do napisów bez edytora,
zero znanych P0 w runtime i jawna lista zaakceptowanych P1/P2. Automat nadal
nie jest dowodem odbioru przez ludzi.

## P6. Wydanie i Dystrybucja

Status: **PLANOWANY — brak eksportowalnego release candidate**

1. **R3 / Build:** `export_presets.cfg`, numer wersji, ikony, deterministyczne
   buildy Windows i Linux oraz smoke uruchamiany na artefaktach.
2. **R4 / Release candidate:** czysta instalacja, nowy zapis/kontynuacja/reset,
   klawiatura i pad, kontrola wydajności, credits, manifest licencji i źródeł,
   clearance tytułu, release notes oraz archiwum artefaktów.
3. **R5 / Meta:** **ukończona gra Godot PC i gotowość produkcyjna do
   publicznego wydania na Windows/Linux.**

R5 jest ostatnim krokiem planu i nie opisuje aktualnego stanu.
