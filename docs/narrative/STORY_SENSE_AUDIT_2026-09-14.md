# Audyt sensu fabularnego i ciągłości świata

Data: 2026-09-14
Zakres: aktywna trasa kampanii 01–18 → 42A/B/C → 43
Metoda: odczyt runtime (sceny `.tscn`, skrypty `scripts/levels/*.gd`, routing
`scripts/core/game_state_manager.gd`, progi `scripts/environment/*.gd`, treść
prezentowana `scripts/levels/creative_scene_lines.gd`), zestawiony z kontraktami
produktu. **Hierarchia prawdy: runtime > dokumentacja** (`docs/INDEX.md`).
Gra nie była uruchamiana; wszystkie twierdzenia pochodzą z kodu i są oznaczone,
gdy wymagają potwierdzenia w runtime.

Ten dokument nie ocenia technologii. Ocenia **sens**: czy zdarzenia wynikają
jedno z drugiego, czy świat ma geografię i czy kolejne sceny złożyłyby się
w film.

---

## 0. Werdykt w jednym akapicie

Gra ma dobrze napisany akt I i bardzo dobre dialogi, ale **nie ma świata** —
ma listę. Osiemnaście przestrzeni to osiemnaście osobnych prostokątów
640×360, połączonych wyłącznie indeksem w tablicy `CAMPAIGN_ROUTE`. Gracz
wchodzi każdą z nich od lewej, dotyka trzech przedmiotów i wychodzi prawą,
niezależnie od tego, czy fabuła każe mu wejść do mieszkania, zjechać pod
torowisko, czy wrócić do miejsca, w którym już był. Do stacji 13 zdarzenia
wynikają z siebie nawzajem; **od 14 do 18 są połączone wyłącznie kolejnością**.
Najcięższa decyzja gry — wybór zakończenia — zapada przez to, po której stronie
słupka stoi gracz, i ignoruje zgodę, o którą gra kazała mu wcześniej walczyć.

Jako film: akt I obroniłby się bez poprawek. Akty II i III czytałyby się jak
montaż z wyciętymi scenami łączącymi.

---

## 1. Co jest faktycznie grą (stan runtime)

Trasa: `station_01 … station_18` liniowo, potem jeden wariant `42A/42B/42C`
wybrany metodą z 18, potem epilog `43`. Sceny 19–41 istnieją na dysku, są poza
trasą (`CAMPAIGN_LEGACY_STATIONS`) i nie wchodzą do tej oceny.

| # | Miejsce w runtime | Kto jest w kadrze | Trzy działania |
|---|---|---|---|
| 01 | stanowisko pomiarowe przy Linii 4 | — | pomiar, próbka, wiadomość Marty |
| 02 | obejście serwisowe, nasyp | — | odczyt prac, drabina |
| 03 | przystanek Linii 4 | — | rozkład, odpowiedź Marcie, wejście do wagonu |
| 04 | wnętrze wagonu | — | bufor czytnika, ślad katastrofy, wysiadka |
| 05 | ulica do domu | — | trasa, torba, przejście |
| 06 | kiosk | sprzedawca | rozkład, zakup, pytanie o Martę |
| 07 | fasada Sadowa 7 | — | dokument vs. tabliczka, spis, kod |
| 08 | klatka schodowa | sąsiadka | drzwi 12, rozmowa, klucz do 14 |
| 09 | cudzy salon | — | dwa komplety rzeczy, fotografia, granica sypialni |
| 10 | pokój z Martą | Marta | kubek, wersja dnia, granica |
| 11 | lada UCP | Wierzbicka | karta, rejestr 186 dni, wyciąg |
| 12 | warsztat | Jakub | pytania przez łącze, spotkanie, odmowa blizny |
| 13 | wspólny stół | Marta | źródło Marty, źródło UCP, **synteza** |
| 14 | rozdzielnia trakcyjna | — | dziennik (1 punkt) + mechanika mostu |
| 15 | komora pętli pod Linią 4 | — | dziennik 20:40, trzy impulsy, notatka |
| 16 | analizator | — | transfer, wybór kosztu, echo domu |
| 17 | hala UCP | **nikogo** | rejestr par, oferta adaptacji, zgoda Jakuba |
| 18 | ulica z 05 | **nikogo** | trzy prognozy, prawda dla Marty, zatwierdzenie |
| 42A/B/C | finał wariantowy | Marta (tylko B i C) | wykonanie, skutek, dom |
| 43 | epilog | — | tablica, napisy, wygaszenie |

Niezmienna forma każdej sceny: spawn gracza `x ≈ 60–88`, wyjście
`x ≈ 590–622`, `ReturnZone` na `x = 15–20`, trzy punkty interakcji
(wyjątek: 14 — jeden punkt plus mechanika).

---

## 2. Co ma sens i czego nie wolno zepsuć przy naprawie

Zaczynam od tego, bo plan naprawy musi tego bronić.

1. **Akt I (01–08) jest dobrze zbudowany.** Cel jest osobisty i konkretny
   (zdążyć do Marty), przeszkody rosną z zawodowych w tożsamościowe, każda
   scena zmienia pytanie, z którym gracz wychodzi. Sprzedawca z 06, który wita
   Lenę po imieniu, a jednocześnie ma rozkład niezgodny z jej pamięcią, to
   najlepszy pojedynczy pomysł w grze.
2. **Trójkąt dowodowy 09–13 jest poprawnie zaprojektowany**: materialny (09),
   relacyjny (10), instytucjonalny (11), osobowy (12), synteza (13). Zdanie
   „To nie jest mój świat" pada dokładnie tam, gdzie powinno, i dopiero po
   trzech niezależnych źródłach.
3. **Dialogi są konkretne i pozbawione ekspozycji.** Postacie mają własne
   cele i granice: Marta zatrzymuje telefon i mówi „nie dotykaj mnie tak, jak
   ona"; Jakub odmawia pokazania blizny, ale z własnej woli sprawdza numer
   i wraca do napędu przed końcem zmiany. Wierzbicka mówi stroną bezosobową.
   To jest poziom, którego nie należy przepisywać.
4. **Mechanika kosztu (16) i zgody (17) to rzadki, mocny pomysł.** Gracz płaci
   za wiedzę konkretnym ubytkiem (rozmyta kurtka na kaloryferze albo sekunda
   20:40:07) i musi wynegocjować zgodę drugiego człowieka zamiast jej założyć.
5. **Epilogi wariantowe w 43** mówią rzeczami, nie tezami (dwa rozkłady na
   wiacie, drugie zgłoszenie bez numeru zwrotnego, kubek na pustej półce).

---

## 3. Geografia i przejścia — odpowiedź na pytanie wprost

### 3.1 Świat nie ma mapy, ma indeks

Jedyną strukturą przestrzenną gry jest pozycja w tablicy
`CAMPAIGN_ROUTE` (`scripts/core/game_state_manager.gd:242`). Przejście to
`transition_to_station(route[i+1])` z przejściem na czarno. Żadna scena nie
wie, co leży za jej progiem. `ThresholdBinder._place_on_floor()`
(`scripts/environment/threshold_binder.gd:145`) wstawia próg **zawsze** przy
prawej krawędzi kadru, niezależnie od tego, co dana scena przedstawia.

### 3.2 Konkretne przejścia, które kłamią o położeniu

| Przejście | Co mówi fikcja | Co robi gra |
|---|---|---|
| 10 → 11 | Lena wychodzi z mieszkania 14, żeby sprawdzić zapis pracy | wychodzi węzłem `Geometry/ApartmentDoor14`, czyli drzwiami mieszkania, za którymi leży klatka z 09/08 — i ląduje przy ladzie UCP |
| 12 → 13 | wraca z warsztatu do mieszkania, do wspólnego stołu | idzie **w prawo**, czyli kierunkiem, który cała gra definiuje jako „dalej", do miejsca, w którym już był |
| 16 → 17 | wraca do instytucji po rejestr kosztów | znów w prawo; nic nie sygnalizuje, że 17 to ten sam UCP co 11 |
| 17 → 18 | wraca na ulicę z 05 | znów w prawo, mimo że `CAMPAIGN_MAP.md` §2 sam ustala: „powrót biegnie zawsze w lewo albo w dół" |

Trzy z osiemnastu przejść to fabularne **powroty**, a gra wykonuje je gestem
postępu. Gracz nigdy nie idzie w lewo do miejsca, które zna.

### 3.3 Deklarowany pion nie istnieje

`CAMPAIGN_MAP.md` §3 opisuje wyjście z 14 jako „winda serwisowa w dół",
a wejście do 16 jako „drabina w górę". `ServiceLift` występuje wyłącznie
w wycofanych scenach `station_25.tscn` i `station_34.tscn`. Zejście pod
Linię 4 i wyjście spod niej realizuje ten sam poziomy ruch w prawo, co
przejście z kiosku na ulicę.

### 3.4 Nie ma żadnego nośnika przejścia

`ThresholdZone` nie ma etykiety ani podpisu (`scripts/environment/threshold_zone.gd`) —
zgodnie z zasadą „kierunek pokazuje kompozycja, nie napis". Problem w tym, że
kompozycja też go nie pokazuje, bo każda scena ma tę samą sylwetkę: podłoga
640×80, ściana lewa, ściana prawa, trzy przedmioty w rzędzie. Nie ma karty
lokacji, nie ma zdania „jadę do UCP", nie ma widoku celu w tle. Gracz po
prostu znika i pojawia się gdzie indziej.

### 3.5 Zegar nocy kontra czynne instytucje

`CONTINUITY_TRACKER.md` §1 umieszcza mieszkanie w 21:45–22:20, a instytucję
zaraz potem. Lena przechodzi kontrolę biometryczną i czyta **fizyczny**
rejestr 186 dni około 22:30, a około 03:00 wraca do tej samej hali po rejestr
par kosztów. Nigdzie w grze nie pada powód, dla którego UCP pracuje w nocy.
Warsztat Jakuba ma to rozwiązane wzorowo („muszę oddać ten napęd przed końcem
zmiany") — instytucja nie ma nic.

---

## 4. Kauzalność: dlaczego Lena w ogóle tam idzie

### 4.1 Złamanie łańcucha na 13 → 14 (najcięższy defekt fabularny)

Ze stacji 13 Lena wychodzi z zapisanymi faktami `world_recognized` oraz
`local_lena_search_committed` i z ostatnią kwestią sceny: „Sprawdzę ją.
Najpierw muszę ją odnaleźć."

Stacja 14 zaczyna się zdaniem „Maszyna pracuje własnym cyklem. Zobaczę, co
utrzyma." Wszystkie beaty 14 (`scripts/levels/station_14.gd:111-116`) są
proceduralne: chwyć obejmę, utrzymaj wersję A, puść, nazwij zachowania.
**Żadna linia, beat ani kwestia nie łączy rozdzielni trakcyjnej z szukaniem
drugiej Leny.** Scena istnieje, bo gracz musi poznać Anchor/Yield przed 15 —
to cel projektanta, nie cel bohaterki.

W filmie: bohaterka dowiaduje się, że jest w cudzym świecie, a w następnym
ujęciu ćwiczy trzymanie przełącznika w podstacji.

### 4.2 Ten sam wzorzec dalej

- **14 → 15**: „Pętla odpowiada własnym rytmem. Sprawdzam, czyje to echo."
  Skąd Lena wie o pętli pomiarowej, kto jej o niej powiedział, dlaczego wierzy,
  że tam jest odpowiedź. Trop istnieje w 11 (`WYCIĄG UCP: 20:40 — próba
  równoległa. Numer czytnika terenowego: brak w rejestrze`), ale nigdy nie
  zostaje wypowiedziany jako decyzja.
- **15 → 16**: „Bezpieczny analizator pokaże, co zostaje po odpowiedzi."
  Czyj analizator, gdzie stoi, skąd Lena ma do niego dostęp.
- **16 → 17**: „Najpierw rejestr par." Kto powiedział, że taki rejestr
  istnieje i że wolno go czytać.

Wniosek: **akt I (01–13) ma prawie kompletny łańcuch przyczyn** (jedyne
przejście bez sceny drogi, 10 → 11, jest uzasadnione repliką Marty „W UCP.
Tam pracujesz"). **Akty II i III (14–18) nie mają go wcale.**

---

## 5. Wiedza postaci i sprzeczności kanonu

### 5.1 Marta wie za wcześnie i nic z tego nie wynika

W 10 Marta mówi: „Możesz sprawdzić. Ale nie dotykaj mnie tak, jak ona."
To znaczy, że **już rozpoznała**, iż osoba przed nią nie jest jej partnerką.
Zatrzymuje telefon, chce dzwonić po lekarza, odmawia bliskości.

W 13 ta sama Marta siedzi z Leną przy wspólnym stole, odsuwa filiżanki, robi
jej miejsce na dokumenty i po syntezie pyta rzeczowo: „Więc gdzie jest ona?"

Między tymi scenami nie ma **niczego**, co tę zmianę tłumaczy. Obie sceny są
dobre osobno; brakuje zawiasu. W dodatku moment rozpoznania w 13 traci wagę,
bo drugą osobę w kadrze rozpoznanie już nie zaskakuje.

### 5.2 Głosy bez ciał w 17 i 18

Rigi postaci (`CharacterVisualRig`) istnieją wyłącznie w scenach 06, 08, 10,
11, 12, 13, 42B i 42C.

- W **17** mówią `WIERZBICKA` i `JAKUB`. Żadnego z nich nie ma w scenie
  (`scenes/levels/station_17.tscn` zawiera wyłącznie geometrię i trzy
  konsole). Kwestie Jakuba brzmią jak rozmowa twarzą w twarz („Ten napęd
  muszę oddać przed końcem zmiany. Potem dziesięć sekund."), a nic nie mówi,
  że to przez łącze.
- W **18** mówi `MARTA`, przy elemencie podpisanym „WITRYNA MARTY". Marty
  w kadrze nie ma. Najcięższa rozmowa relacyjna gry — ile prawdy przekazać
  partnerce — odbywa się z wystawą sklepową.
- W **42A** mówi „Marta domowa" — riga w tej scenie również nie ma.

### 5.3 Epilog domyślny przeczy kanonowi

`scripts/levels/station_43.gd:75` (`DEFAULT_DIALOGUE_LINES`):

> „Radio podaje: »Linia 4 zamknięta do odwołania.« **W mieście Leny ta linia
> według niej nigdy nie istniała.**"

W świecie Leny Linia 4 istnieje i jest osią całej pierwszej godziny gry:
mierzy przy niej drgania (01), czeka na jej przystanku (03), jedzie nią (04),
a katastrofa Linii 4 zabiła w jej świecie Jakuba. Te linie są dostępne dla
gracza, bo selektor kampanii pozwala wejść do 43 bez rodziny zakończenia
(`ending_family = "unseeded"` → `DEFAULT_DIALOGUE_LINES`).

---

## 6. Decyzje bez konsekwencji

### 6.1 Zakończenie wybierane pozycją ciała

`Station18.choose_method_from_player_side()`
(`scripts/levels/station_18.gd:241-256`) rozstrzyga finał różnicą współrzędnej
X gracza względem słupka: mniej niż −24 px to wymuszenie domu (42A), więcej
niż +24 px to przejście wzajemne (42C), środek to zamknięcie z odzyskaniem
miejscowej (42B). Słupek nie ma żadnych oznaczeń — `_draw()` rysuje pionową
kreskę i okrąg, a scena zawiera tylko dwa podpisy diegetyczne, żaden przy
słupku. **Nie ma nazwania wyboru przed zatwierdzeniem ani potwierdzenia.**
Gracz może dostać zakończenie, którego nie wybrał.

### 6.2 Zgoda Jakuba nie ma mocy sprawczej

`_commit_method()` (`scripts/levels/station_18.gd:278`) zapisuje brak
prognoz lub brak rozmowy z Martą jako *feedback*, po czym **i tak** ustawia
`is_method_committed = true`. Pole `available` z `_build_forecasts()` nie jest
w tym miejscu w ogóle czytane.

Skutek: gracz, któremu Jakub odmówił, odczytuje na tablicy „Wymuszenie domu:
brak. Odmowa zamyka metody na jego relacji — luka: brak zgody Jakuba",
podchodzi do słupka i wymuszenie domu wykonuje, dostając pełny finał 42A.
Finały dodatkowo maskują brak: `station_42a.gd:236` przy pustej zgodzie
podstawia `limited`, a `station_42c.gd:268` — `granted`.

To unieważnia całą stację 17, czyli scenę zbudowaną wokół tezy, że nie wolno
używać człowieka bez jego zgody.

### 6.3 Powrót prawdopodobnie zakleszcza grę na 09–18

**Wymaga potwierdzenia w runtime.** Żadna ze stacji 09–18 nie ma metody
`unlock_exit_for_return` (mają ją tylko 01–08, wywołuje ją
`GameStateManager._apply_spawn_side_deferred()`). Wyjście w tych scenach
otwiera lokalne `_unlock_exit()`, wywoływane przez czasownik sceny — a te
czasowniki są jednorazowe względem stanu globalnego, np.
`Station10.accept_marta_boundary()` przerywa na `if _decision_bool(P9_BOUNDARY)`.
Po powrocie z 11 do 10 fakt jest już zapisany, funkcja zwraca `false`,
`is_exit_unlocked` zostaje `false`, a `ThresholdBinder.install()` nie otwiera
progu. Restart sceny nie pomoże, bo fakty żyją w `GameStateManager`.
Żaden test w `tests/` nie pokrywa tej ścieżki.

---

## 7. Rytm — problem, którego nie widać w żadnym pojedynczym pliku

Osiemnaście razy z rzędu: wejdź z lewej, użyj trzech przedmiotów
w wymuszonej kolejności, wyjdź prawą. Jedyne odstępstwo to 14 (jeden przedmiot
plus mechanika mostu). Dialogi są różne, forma jest identyczna.

Trzy pierwsze rozbieżności są dodatkowo tego samego typu — dokument kontra
pamięć (rozkład w 06, numer mieszkania w 07, relacja sąsiadki w 08). Pierwsza
rozbieżność, która **nie** jest dokumentem, pojawia się dopiero w 09.

---

## 8. Rozjazd dokumentacji z runtime (dla modeli wykonawczych)

Poniższe nie są defektami dla gracza, ale są pułapkami dla każdego, kto
będzie to naprawiał na podstawie lektury plików.

1. **Nagłówki skryptów 09–13 opisują inne sceny, niż te pliki dziś
   uruchamiają.** `station_11.gd` ma nagłówek o komodzie w przedpokoju
   i prywatnych śladach, a scena to lada UCP z Wierzbicką.
   `station_10.gd` opisuje zamek i klucz, a scena to pokój z Martą.
2. **Nazwy węzłów są zdezaktualizowane, a podpisy widoczne dla gracza —
   nie.** W `station_11.tscn`: `WorkBoots` → „Karta służbowa",
   `CommodePhotograph` → „Fizyczny rejestr 186 dni", `FieldReaderDock` →
   „Okienko raportu". W `station_13.tscn`: `PhoneToMarta` → „Czytnik przy
   wspólnym stole".
3. **`FULL_STORY.md` i `CONTINUITY_TRACKER.md` używają starej numeracji
   01–43** (rozpoznanie jako „21") obok nowej w nagłówku (rozpoznanie jako
   13). `PKG_0190_CINEMATIC_PLACEMENT.md` §0 nazywa ten rozjazd wprost, ale
   go nie usuwa.
4. **Martwy kod P7** żyje obok aktywnego P9 w 09–13
   (`inspect_private_photograph`, `push_sideboard`, `open_drawer`,
   `test_key_without_claiming_home`), wraz z rekwizytami, których żaden
   punkt interakcji nie używa (`HallwaySideboard`, `DeskDrawer`,
   `LegacyDomesticWitnessA/B`).

---

## 9. Lista defektów według wagi

| ID | Defekt | Waga | Dowód |
|---|---|---|---|
| S-01 | 13 → 14 bez żadnego ogniwa przyczynowego; cały akt II połączony kolejnością, nie przyczyną | krytyczna | `station_14.gd:111-116`, `station_15/16/17` opening cues |
| S-02 | Zgoda Jakuba nie blokuje metody; 17 jest unieważniona | krytyczna | `station_18.gd:278-300`, `station_42a.gd:236` |
| S-03 | Finał wybierany pozycją gracza, bez nazwania i potwierdzenia | krytyczna | `station_18.gd:241-256` |
| S-04 | Powrót `ReturnZone` zakleszcza 09–18 (do potwierdzenia w runtime) | krytyczna | brak `unlock_exit_for_return` w 09–18 |
| S-05 | Trzy fabularne powroty (13, 17, 18) wykonane gestem postępu w prawo | wysoka | `threshold_binder.gd:145`, `CAMPAIGN_MAP.md` §2 |
| S-06 | Zawias Marty 10 → 13 nie istnieje | wysoka | `creative_scene_lines.gd` `marta_boundary` vs `synthesize` |
| S-07 | Wierzbicka, Jakub i Marta mówią w scenach, w których nie mają ciał (17, 18, 42A) | wysoka | brak `CharacterVisualRig` w 17/18/42A |
| S-08 | Deklarowany pion (winda 14→15, drabina 15→16) nie istnieje w trasie | wysoka | `ServiceLift` tylko w 25 i 34 |
| S-09 | Epilog domyślny 43 przeczy kanonowi Linii 4 | średnia | `station_43.gd:75` |
| S-10 | Brak jakiegokolwiek nośnika przejścia między lokacjami | średnia | `threshold_zone.gd`, brak kart lokacji |
| S-11 | Niezmienny rytm 3 przedmiotów × 18 scen | średnia | wszystkie `.tscn` trasy |
| S-12 | Czynna instytucja w nocy bez uzasadnienia w kadrze | niska | `CONTINUITY_TRACKER.md` §1 vs 11/17 |
| S-13 | Nagłówki, nazwy węzłów i numeracja dokumentów rozjechane z runtime | niska (wysoka dla wykonawców) | §8 |

---

## 10. Odpowiedź na pytanie „czy to miałoby sens jako film"

- **Minuty 0–35 (01–08):** tak. Ekspozycja przez działanie, narastanie bez
  ujawnień, pierwsza scena z drugim człowiekiem (kiosk) niesie zwrot.
- **Minuty 35–55 (09–13):** tak, z jedną raną — partnerka bohaterki
  rozpoznaje podmianę o trzy sceny wcześniej niż widz i nikt tego nie
  komentuje.
- **Minuty 55–90 (14–18):** nie. Bohaterka deklaruje cel („odnaleźć ją"),
  po czym wykonuje cztery czynności techniczne w czterech miejscach, do
  których nikt jej nie wysłał, po drodze rozmawiając z pustymi pomieszczeniami.
- **Finał:** wybór zakończenia zapada bez wypowiedzianej decyzji, a warunek,
  który film budował przez akt III (zgoda Jakuba), nie ma wpływu na to, co
  wolno zrobić.

Plan naprawy: `docs/narrative/STORY_SENSE_REPAIR_PLAN_2026-09-14.md`.
