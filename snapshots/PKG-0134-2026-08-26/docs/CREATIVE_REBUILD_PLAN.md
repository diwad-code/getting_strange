# Getting Strange — plan relacyjnej przebudowy kreatywnej

Status: **AKTYWNY PLAN PRODUKCYJNY 3.0 — ADR-007**  
Data: 2026-08-25

## 1. Werdykt

Nie rozpoczynamy pustego projektu i nie kontynuujemy kanonu 0.2 jako gotowej
historii. Zachowujemy zweryfikowaną infrastrukturę Godot oraz twarde bramy
powolnego ujawnienia, a dramaturgię budujemy ponownie wokół Linii 4, dwóch
relacji Marty, podmiotowości Jakuba i miejscowej Leny oraz aktywnej opozycji
Wierzbickiej.

| Zachować | Zaadaptować / ponownie stworzyć |
|---|---|
| Godot 4.7, 640x360, 60 Hz | osobisty rdzeń otwarcia i cele Station 01–43 |
| shell, zapis, ustawienia, InputMap | dwie tajemnice i uczciwe łańcuchy poszlak |
| fizykę gracza | LenaVisualRig i aktorskie reakcje |
| routing 01..41 -> 42A/B/C -> 43 | osiem sekwencji dramaturgicznych na tej topologii |
| audio, CRT i testy infrastruktury | głosy, dialog, myśli i system wiedzy |
| Anchor/Yield jako prototyp | koszt w relacji, pamięci i adresie od Station 22 |
| użyteczne komponenty trwającego Foundation Slice | teksty/beaty 01–07 zgodne z kanonem 0.3 |
| Pixel-Stage / crisp text jako architektura | wszystkie aktywne źródła tekstu i kompozycję |

Pełny reset techniczny nie rozwiązałby problemu fabularnego. Istnienie sceny
lub nowego komponentu nie gwarantuje jednak statusu produkcyjnego.

## 2. Kontrakty nadrzędne

### 2.1 Dwie tajemnice zamiast jednego zwrotu

- 01–21: `co jest nie tak z wieczorem/pamięcią?` -> obca ciągłość.
- 22–39: `co zrobiła miejscowa Lena, gdzie jest i kto płaci?` -> test wzajemny,
  interwencja UCP, rachunek Linii 4 i zgody osób.
- 40–43: wykonanie oraz konkretne życie po skutku.

Station 21 pozostaje pierwszym `To nie jest mój świat`. Station 22 pozostaje
pierwszym świadomym Anchor/Yield. Rozpoznanie nie może automatycznie dawać
wiedzy o metodzie i kosztach.

### 2.2 Normalność ma konflikt, nie paranormalny hak

Lena w Station 01 odmawia zapisania trzysekundowej luki jako błędu czujnika i
łamie obietnicę powrotu do Marty. 01–05 nadal nie pokazują nic niemożliwego.
Uwaga gracza wynika z działania, zawodu, relacji i karty Linii 4.

### 2.3 Każda osoba ma cel i granicę

- Marta chce odzyskać partnerkę, nie zastępstwo.
- Jakub chce chronić przeżyte życie i sam udziela zgody.
- miejscowa Lena chciała udowodnić eksport kosztów, lecz źle zabezpieczyła
  zgodę drugiej strony;
- Wierzbicka chce utrzymać Rówień kosztem autonomii odchyleń;
- przybyła Lena chce wrócić, ale musi przestać mylić pewność z uczciwością.

Relacje otwierają działania przez zgodę/odmowę, nie ukryty licznik dobra.

### 2.4 Pętla gry jest częścią scenariusza

Każda stacja zapisuje:

`cel -> przeszkoda -> działanie -> reakcja -> ocena -> decyzja/oczekiwanie`.

Sama informacja lub terminal nie wystarcza. Cicha przestrzeń może być oddechem
większej sekwencji, ale nie sztuczną osobną poszlaką.

### 2.5 Pokaż -> naprowadź -> pomyśl -> sprawdź

Omylna myśl ma fakt źródłowy, osobisty powód, przewidywanie i test korekty.
Systemowa pomoc jest oznaczona jako `WSKAZÓWKA`. Mechanika, stan obiektu, koszt
i zgoda nigdy nie kłamią.

### 2.6 Świat pikselowy, tekst ostry, Lena ludzka

Świat/postacie/efekty przechodzą przez efektywny raster 320x180; każdy czytelny
tekst oraz UI pozostają w 640x360. `LenaVisualRig` pokazuje ciężar, uwagę i
emocjonalny timing bez opóźnienia mechanicznej odpowiedzi.

## 3. Mapa treści 0.3

- **01–05 — Próbka:** odczyt, Linia 4, obietnica Marty, zwykły powrót.
- **06–09 — Rysa:** rozkład, sprzedawca, numer 14 i sąsiadka.
- **10–13 — Cudzy dom:** klucz, partnerskie zdjęcie, głos i dwa dokumenty.
- **14–17 — Marta i zapis:** dwie relacje, biometria UCP-4, równoległy test.
- **18–21 — Niemożliwy brat:** publiczne życie Jakuba, ciało i synteza.
- **22–30 — Test wzajemny:** nazwanie metod, granice, odpowiedź drugiej Leny i
  pierwszy koszt.
- **31–38 — Rachunek Linii 4:** adaptacja, procedura, echo domu, para katastrof,
  zgody Marty/Jakuba.
- **39–43 — Metoda i skutek:** jawna prognoza, wykonanie, trzy konkretne
  konsekwencje i epilog wszystkich osób.

## 4. Stan zastany przy otwarciu planu 3.0

Po PKG-0116 w katalogu rozpoczęto, lecz nie zamknięto implementacji Foundation
Slice 01–07. Na dysku istnieją nowe lub zmienione komponenty rigu, kompozytora,
guidance, ostrych tekstów, scen 01–07 i `pkg_0117_smoke_test.gd`. Nie ma wpisu
zamykającego PKG-0117 ani snapshotu.

Świeża bramka przed dokumentami 0.3 wykazała:

- dokumentacja: PASS dla 34 starych kontraktów;
- główny smoke: FAIL, 24 asercje w Station 01, 06 i 08;
- dwa procesy `pkg_0117_smoke_test.gd` pozostawały uruchomione od wcześniejszej
  próby;
- zmiany runtime nie zostały nadpisane przez audyt narracyjny.

Po zatrzymaniu wyłącznie dwóch osieroconych procesów i ponownym uruchomieniu
bramki `pkg_0117_smoke_test.gd` komponenty Foundation przeszły swój smoke z
kodem 0. Nie zmienia to statusu treści:

- `KEEP`: rozdzielenie `LenaVisualRig` od fizyki, architektura warstw
  kompozytora, crisp text, serwis guidance i węzły integracyjne 01–07;
- `ADAPT`: sam rysunek/animacja Leny, walidacja faktycznej pikselizacji,
  model danych myśli 0.3, inscenizacja i cele 01–07;
- `RETIRE`: korelacyjna anomalia w 02, „alternatywna” fotografia i podwójne
  przedmioty w 03, żywy Jakub/UCP jako jawna tajemnica w 04, zmienna geometria
  i szept imienia w 05 oraz wejście Marty do mieszkania już w 07.

Wniosek: PKG-0117 domyka rewolucję kanonu i stanowi audyt rekoncyliacyjny.
Nie nadaje częściowemu runtime statusu ukończonego pionowego wycinka.

## 5. Kolejka mega-pakietów

### PKG-0117 — Narrative Revolution + Foundation Reconciliation Audit

Status: **ZAMKNIĘTY — KANON 0.3 + AUDYT REKONCYLIACYJNY**.

Jeden pakiet łączy pięć zależnych elementów:

1. audyt skilli i kanon narracyjny 0.3;
2. rozpoznanie oraz zachowanie nieznanych zmian Foundation Slice;
3. klasyfikację `KEEP / ADAPT / RETIRE` dla riga, Pixel-Stage, crisp text,
   guidance i treści 01–07;
4. nową kolejkę wdrożeniową zaczynającą się od prawdziwego Foundation Slice;
5. testy techniczne zastanych komponentów, dokumentację i snapshot bez
   nieudokumentowanego stanu.

Bramka:

- kanon 0.3 i plan nie nazywają runtime 01–07 gotowym;
- wszystkie zastane zmiany Foundation mają jawną klasyfikację;
- smoke legacy oraz `pkg_0117` przechodzą technicznie;
- capture służy wyłącznie inspekcji stanu zastanego, nie akceptacji artystycznej;
- stan, log, handoff i snapshot podają dokładne ograniczenia.

### PKG-0118 — Foundation Slice 01–07 według kanonu 0.3

Status: **NASTĘPNY**.

- konflikt próbki Linii 4 i obietnicy Marty w 01;
- zwykłe obejście 02, wiadomość 03, przejazd 04 i znana ulica 05;
- dwa rozkłady 06 i kiosk/herbata dla Marty 07;
- produkcyjna iteracja anatomii i ruchu Leny bez kopiowania `Another World`;
- walidacja Pixel-Stage, ostrych tekstów i omylnej drabiny guidance;
- usunięcie wszystkich aktywnych elementów `RETIRE` z 01–07;
- nowy test kontraktu wiedzy oraz świeża macierz capture.

Bramka: 01–05 są całkowicie normalne, 06–07 mają wyłącznie racjonalizowalne
rysy, a technicznie działają trasa, zapis, restart, tekst, guidance i ruch.

### PKG-0119 — Rysa i cudzy dom 08–13

- numer 14, sąsiadka, klucz, zdjęcie Marty, głos i dwa dokumenty;
- hipotezy cache/numeracja/staging/luka pamięci z testami korekty;
- animacje progu, badania, cofnięcia i naruszonej prywatności;
- migracja tekstów oraz flag `local_address_confirmed`,
  `marta_relationship_disclosed`, `conflicting_documents_found`.

Bramka: żadna scena nie nazywa świata; każda prostsza hipoteza jest sprawdzana
działaniem i ma uczciwy powód.

### PKG-0120 — Marta, UCP i rozpoznanie 14–23

- konfrontacja dwóch relacji, wspomnienie, biometria, raport i Wierzbicka;
- publiczne dane, głos i spotkanie z Jakubem;
- interaktywna synteza 21;
- Station 22–23: nazwanie metod oraz martwy obwód z pierwszym lokalnym kosztem;
- test wiedzy postaci i trzy rodziny dowodów.

Bramka: pierwsza diagnoza w 21, pierwsza metoda w 22, koszt mechaniczny widoczny
przed dalszym użyciem.

### PKG-0121 — Test wzajemny 24–30

- granice Marty, wejście z Jakubem, rekonstrukcja interwencji i odpowiedź;
- koszt pamięci/próbki, zgoda Jakuba i trzy prognozy;
- stan integralności dwóch sygnałów oraz relacyjnych ograniczeń;
- zero moralnego licznika i zero osoby jako parametru bez zgody.

### PKG-0122 — Rachunek Linii 4 31–38

- oferta adaptacji, response room, procedura miejscowej Leny, rozdzielenie;
- echo domu, rejestr par kosztów, sceny decyzji Jakuba i Marty;
- aktywna, konsekwentna opozycja Wierzbickiej;
- pełny clue/knowledge audit przed zamknięciem finału.

### PKG-0123 — Metoda, konsekwencje i content lock 39–43

- stół kosztów i zgód, wykonanie znanych działań, Station 41;
- 42A wymuszenie, 42B zamknięcie Równi, 42C przejście wzajemne;
- epilog siedmiu obowiązkowych stanów;
- migracja zapisu, lokalizacja narracji, credits i finalny content manifest;
- pełna capture matrix i end-to-end wszystkich rodzin.

Dopiero ten pakiet może ustanowić content lock 3.0.

### PKG-0124+ — Build i release candidate

Eksporty Windows/Linux, czysta instalacja, wydajność, pakiet licencyjny i RC są
zablokowane do content locka 3.0.

## 6. Bramka jakości planu

Plan jest spójny, gdy:

- kanon 0.2 ma status odrzuconego projektu pośredniego, nie bieżącej prawdy;
- Station 21 i 22 zachowują swoje różne funkcje;
- normalność 01–05 ma konflikt bez paranormalnego ujawnienia;
- druga tajemnica ma poszlaki, przeciwną siłę i wypłatę;
- Marta Kurek ma dwie jawne relacje, Jakub zgodę, a miejscowa Lena stan finału;
- Wierzbicka pojawia się przed kulminacją i działa według jednego celu;
- każda stacja ma pętlę doświadczenia albo funkcję oddechu sekwencji;
- żaden finał nie odzyskuje wszystkiego;
- żaden tekst nie przechodzi przez pixelizację;
- istniejące, nieudokumentowane pliki są rozpoznane przed edycją;
- build pozostaje zablokowany do PKG-0123.

## 7. Reguła migracji

1. Zapisz sumy, timestampy i wynik testu stanu wejściowego.
2. Czytaj runtime przed założeniem, że prompt opisuje aktualny plik.
3. Oznacz każdy element `KEEP / ADAPT / RETIRE`; nie przywracaj hurtowo.
4. Zapisz cel, przeszkodę, działanie, wiedzę i zmianę przed kodem.
5. Zaimplementuj treść, obraz, ciało, guidance i stan razem.
6. Dodaj testy kontraktów, nie subiektywnej emocji.
7. Dla obrazu wykonaj i obejrzyj świeże capture'y normalnym driverem.
8. Uzgodnij wszystkie żywe dokumenty, pełne verify, log i snapshot.

## 8. Dowód a odbiór

Test może dowieść kolejności flag, źródła wiedzy, cooldownu, warstw, ostrości,
osiągalności i kompletności stanów. Capture może pokazać kadr, pikselizację i
pozę. Żadne z nich nie dowodzi napięcia, naturalności dialogu, przywiązania,
zrozumienia, funu ani moralnego ciężaru.

## 9. Kolejka P6 — Human Scale & Playability (D-121)

Content lock 3.0 i P5 zostają jako szkielet. Właściciel unieważnił
certyfikat „gra jest grywalna i Lena jest ludzka”.

### PKG-0131 — Dyrektywa (TEN PAKIET, ZAMKNIĘTY)

Kanon `WORLD_SCALE.md`, zaostrzenie traweru 1.1, Lena 4.0 jako spec,
D-121..D-126, prompt wykonawczy. Bez zmiany runtime.

### PKG-0132 — Wykonanie (NASTĘPNY)

Jeden mega-pakiet: sprite Leny przez `gen-ai`, skala 43 stacji, lewe
wyjścia, próg 18 px, drabiny/windy, audyt przejścia. Zakaz `.exe`.

### PKG-0133 — tylko reszta

Otwierać wyłącznie, gdy tabela `PLAYTHROUGH_TRAVERSAL_AUDIT.md` ma
wiersze OPEN po PKG-0132. Nie wymyślać nowego zakresu.

Bramka planu P6: Lena obok krzesła czyta się jako kobieta; żadna
wymagana trasa miejska nie wymaga skoku na ścianę; 05→04→03 działa
w lewo; zero nowych `.exe`.
