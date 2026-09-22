# PKG-0231 — plan naprawy sensu fabularnego

Źródło: `docs/rebuild/PKG_0231_FRESH_STORY_SENSE_AUDIT.md`  
Status: **PLAN DLA KOLEJNYCH MODELI — bez implementacji w PKG-0231**  
Cel: zachować rdzeń historii i naprawić przyczynowość, geografię, wiedzę oraz
wypłatę finałów.

## 1. Zasada nadrzędna

Każdy adres musi spełnić inwariant:

`stan wejścia → obserwowalne działanie → nowa wiedza/decyzja → uzasadniony próg → stan wejścia następnej sceny`.

Jeśli projekt zachowuje otwarte wyjścia, pominięcie jest legalną decyzją i
następna scena musi dostać wariant wejścia „brak danych”. Jeżeli następna scena
nie ma takiego wariantu, poprzedni fakt musi być obowiązkowy przed przejściem.

Nie wolno zaliczać naprawy samą obecnością flagi lub zielonym testem. Test ma
przejść co najmniej ścieżkę pełną, skróconą, z cofnięciem i każdy finał.

## 2. Pakiet A — inwariant przejść i wiedzy (P0)

### A1. Ustanowić politykę progu per fakt

Dla każdej stacji 01–18 i 42/43 przypisać fakty do jednej z klas:

- `REQUIRED_FOR_NEXT_SCENE` — bez faktu nie ma przejścia;
- `OPTIONAL_WITH_GAP` — wolno pominąć, ale następne sceny czytają lukę;
- `LOCAL_FLAVOUR` — nie wpływa na późniejszą wiedzę.

Nie usuwać mechanizmu luk w całości. Usunąć globalne założenie, że każdy próg
ma być otwarty bez względu na wiedzę. `ensure_exit_open()` może pozostać dla
stacji, których następne otwarcie ma pełny fallback; nie może otwierać
nieodwracalnej decyzji i finału.

### A2. Dodać macierz wejść zależnych od stanu

Minimalny zakres:

- 14 nie może twierdzić, że znana jest zewnętrzna korekta 20:40. Otwarcie ma
  mówić tylko o wyciągu: próba równoległa, obcy numer czytnika, wskazana sekcja.
- 15 dopiero po odczycie logu ustanawia zewnętrzne przerwanie.
- 17 bez echa domu mówi „nie potwierdziłam, czy nastąpiła zamiana”; rejestr
  pozostaje niedostępny albo jawnie niepełny.
- 18 bez zakresu zgody pokazuje trzy prognozy jako niepoliczone i nie pozwala
  przejść do finału.

### A3. Testy kontraktu

1. Przejście bez interakcji 01→18 nie może wygenerować żadnego faktu wiedzy.
2. Każde otwarcie musi być prawdziwe dla zasianego stanu wejścia.
3. Każdy wymagany fakt ma dokładnie jednego materialnego writera.
4. Każdy `OPTIONAL_WITH_GAP` ma konkretną linię lub obraz braku w późniejszej
   scenie.

## 3. Pakiet B — chronologia i rekwizyty (P0/P1)

### B1. Naprawić UCP w 10

Zastąpić sens myśli wyjściowej:

> „Marta twierdzi, że pracuję w UCP. Sprawdzę zapis pracy, zanim uznam to za
> moje.”

Nie zmieniać sceny 11 ani biometryki; to ona ma potwierdzić lokalny profil.

### B2. Nadać pochodzenie zaświadczeniu m. 12

Najmniejsza naprawa:

- w 01 torba zawiera dokument zlecenia/zaświadczenie z adresem Sadowa 7 m. 12;
- gracz widzi go przy pakowaniu sprzętu niezależnie od wyboru próbki;
- 07 wyjmuje ten sam dokument, a 13 kładzie go na stole.

Nie tworzyć nowej stacji ani pobocznego questu.

### B3. Rozstrzygnąć opiekę nad czytnikiem w 11

Wybrać jeden wariant i utrzymać go dalej:

- Wierzbicka wydaje warunkowe pokwitowanie i pozwala Lenie zabrać czytnik;
- albo Lena świadomie odmawia oddania, a 12/13 pamiętają naruszenie procedury.

Preferowany wariant: pokwitowanie minimalnego zakresu, ponieważ utrzymuje UCP
jako racjonalną instytucję zamiast tworzyć przypadkową kradzież.

### B4. Wzmocnić syntezę 13 bez wykładu

Nie dodawać monologu o multiwersum. Dodać jeden fizyczny korelat wykluczający
sam błąd pamięci, np. równoczesny zapis dwóch urządzeń z różnymi numerami i tą
samą niemożliwą luką. Dopiero potem zapisać `world_recognized`.

Alternatywnie złagodzić zdanie do rozpoznania odmiennej ciągłości, nie
ontologicznego „świata”.

## 4. Pakiet C — geografia i filmowe styki (P1)

### C1. 13→14

- Wyciąg z 11 wskazuje sekcję/rozdzielnię.
- Ostatnia czynność 13: Lena wybiera drogę do wejścia serwisowego.
- Próg lub krótka winieta pokazuje wyjście z mieszkania i zejście włazem.
- Pierwsza linia 14 nie zdradza odkrycia 15.

Bez nowego adresu i bez arcade przeszkody.

### C2. 18→42

Zatwierdzenie metody musi uruchomić widoczną czynność, nie tylko ustawić flagę.
Krótki most ma pokazać:

1. rękę/urządzenie wykonujące wybraną metodę;
2. konkretny koszt lub brak zgody;
3. przejście nocy w świt;
4. miejsce i tożsamość sterowanej Leny po operacji.

### C3. Fokalizacja 42B

Preferowana decyzja: gracz pozostaje przy przybyłej Lenie na wiacie, a
mieszkanie miejscowej ogląda przez ustalony nośnik/okno. Jeśli scena ma
przełączyć kontrolę na miejscową Lenę, musi jawnie nazwać zmianę perspektywy i
nie używać tego samego nieoznaczonego `Player` jako ciągłości protagonisty.

### C4. Cofanie

Oddzielić „stacja już rozliczyła fakty” od „próg może ponownie nawigować”.
`_handled_completions` może chronić zapis przed duplikacją, ale nie może blokować
ponownego przejścia naprzód po powrocie.

Test obowiązkowy dla każdej krawędzi:

`N → N+1 → ReturnZone do N → prawy próg → N+1`.

## 5. Pakiet D — atomowy finał i epilog (P0/P1)

### D1. Usunąć domyślne 42A

`station_18` bez `method_committed` nie przechodzi do żadnego wariantu 42.
Nie zapisywać `campaign_finale` z wartości domyślnej. Selektor testowy może
siać jawny stan, lecz normalna kampania nie.

### D2. Zamrozić migawkę decyzji przy commicie

Przy zatwierdzeniu metody zapisać atomową migawkę:

- metoda;
- prawda wobec Marty;
- zakres zgody Jakuba;
- mały koszt;
- dostępne/brakujące dowody;
- wybrany wariant 42.

Zmiana metody po powrocie musi albo atomowo zastąpić całą migawkę i wyczyścić
skutki starego wariantu, albo być niemożliwa po rozpoczęciu wykonania.

### D3. Wymusić kolejność wewnątrz 42

Każdy wariant:

1. wykonaj metodę;
2. odczytaj stan drugiej Leny/przecieku;
3. odczytaj skutek gospodarstwa;
4. dopiero wtedy otwórz próg 43.

Nie wystarczy ułożyć punkty lewo→prawo; funkcje muszą sprawdzać poprzedni krok.

### D4. Domknąć 43

Wymagana kolejność:

1. tablica miejska;
2. konsekwencja relacyjna;
3. napisy;
4. osobista ostatnia czynność Leny;
5. blackout/menu.

Blackout musi odrzucać próbę przed spełnieniem poprzednich kroków. Wszystkie
pięć linii gałęzi musi być osiągalne w normalnym przebiegu.

### D5. Wypłacić wcześniejsze decyzje

W każdym wariancie finału i epilogu użyć:

- jednej linii/zmiany obrazu dla `marta_truth_state`;
- jednej dla zgody Jakuba lub jawnej luki;
- jednej dla wybranego małego kosztu z 16.

Nie mnożyć pełnych zakończeń. Zbudować bazę rodziny + trzy małe, ortogonalne
moduły konsekwencji.

## 6. Kolejność wdrażania

| Kolejność | Pakiet | Blokuje |
|---|---|---|
| 1 | A — inwariant przejść/wiedzy | wszystkie dalsze oceny sensu |
| 2 | D1/D3/D4 — decyzja, wykonanie, epilog | PRODUCT GO / GATE-FIN |
| 3 | B — chronologia i rekwizyty | spójność 07–15 |
| 4 | C — geografia i fokalizacja | filmowa ciągłość |
| 5 | D2/D5 — trwałość i wypłata stanów | jakość wariantów |

Pakiety 1–2 powinny być jednym mega-pakietem systemowym, bo oba dotykają
`GameStateManager`, `GapLedger`, progi i finały. Pakiety 3–5 mogą być drugim
mega-pakietem content/staging. Nie rozdrabniać na pojedyncze repliki.

## 7. Kryteria akceptacji

### Przyczynowość

- zero otwarć twierdzących fakt bez writera w rzeczywistym wcześniejszym
  przebiegu;
- brak metody oznacza brak finału;
- skutek 42 nie może powstać przed wykonaniem metody;
- kampania nie kończy się przed ostatnią czynnością 43.

### Geografia

- wszystkie krawędzie 01–18/42/43 mają nazwane `from`, `to`, portal i stronę
  wejścia;
- test przód→powrót→przód przechodzi dla każdej krawędzi;
- 13→14 i 18→42 mają widoczny most czasu/miejsca;
- 42B ma jednoznaczną kontrolowaną postać i przestrzeń.

### Wiedza i dialog

- Lena nie mówi „wiem”, kiedy ma tylko twierdzenie innej osoby;
- rekwizyt zaświadczenia ma źródło przed pierwszym użyciem;
- status czytnika po UCP jest jawny;
- Marta i Jakub odpowiadają na zakres, a nie na niewidoczną flagę.

### Konsekwencje

- trzy rodziny 42 pozostają różne;
- prawda Marty, zgoda Jakuba i mały koszt są widoczne w końcu;
- nie ma punktów dobra, moralnego koloru ani autorskiego werdyktu.

## 8. Wymagana weryfikacja implementacji

1. Pełne `pwsh -NoProfile -File .\tools\verify.ps1`.
2. Nowa bramka przyczynowa testująca ścieżki: pełna, zero odczytów, częściowa,
   cofnięcie, odmowa Jakuba, każdy finał i bezpośredni blackout.
3. Dry-run od `Nowa gra` wyłącznie czasownikami gracza.
4. Świeże kadry normalnym sterownikiem Windows dla 13→14, 18→42, 42B i 43.
5. Raport ograniczeń: automat dowodzi stanu i kolejności, nie emocji ani
   zrozumienia.

## 9. Zakazy dla wykonawców

- Nie przywracać stacji 19–41 do aktywnej kampanii.
- Nie dodawać strony WWW ani powierzchni webowej.
- Nie rozwiązywać luk etykietą, quest logiem lub monologiem.
- Nie osłabiać zgody Jakuba i nie wybierać za niego po cichu.
- Nie usuwać obu zachowań Anchor/Yield z 14.
- Nie dodawać platformingu, wrogów ani zręcznościowych przeszkód.
- Nie uznawać zielonego testu za dowód sensu odbiorczego.
- Nie przepisywać całej fabuły; zachować mocny rdzeń wskazany w raporcie §3.