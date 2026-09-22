# Prowadzenie, hipotezy i myśli Leny

Status: **KANON SYSTEMOWY 0.3 — WDROŻENIE PIONOWYMI WYCINKAMI**  
Data: 2026-08-25

## 1. Zasada nadrzędna

Gra najpierw **pokazuje**, potem **naprowadza**, następnie pozwala Lenie
**pomyśleć**, a w scenach śledczych daje graczowi **sprawdzić hipotezę**. Tekst
nie ratuje nieczytelnego kadru i nie wykonuje wniosku za gracza.

Myśl jest częścią charakteru Leny. Może być błędna, bo Lena racjonalizuje,
broni się, projektuje żałobę i unika zależności. Nie może być błędna jako
instrukcja, stan obiektu, koszt, zgoda postaci ani reguła mechaniki.

## 2. Cztery funkcje informacji

| Warstwa | Przykład | Status |
|---|---|---|
| obserwacja | `Ta sama data. Dwie trasy.` | prawdziwy fakt widoczny w scenie |
| interpretacja | `Cache. Najprostsze.` | szczera hipoteza; może być błędna |
| zamiar | `Sprawdzę numer wersji.` | bezpieczny test albo kierunek |
| pomoc | `Porównaj identyfikator na papierze z aplikacją.` | głos systemu, nie myśl Leny |

Jedna automatyczna myśl nie łączy wszystkich funkcji. Jeśli potrzebna jest
bezpośrednia instrukcja, powierzchnia oznacza ją jako `WSKAZÓWKA` zamiast
wkładać projektantowi słowa w głowę Leny.

## 3. Drabina podpowiedzi L0..L4

### L0 — kadr i źródło

Światło, negatywna przestrzeń, ruch, materiał i dźwięk wskazują ważny element.
Lena może spojrzeć lub ustawić ciało ku źródłu. Brak tekstu.

### L1 — bezpieczna reakcja

Interakcja zmienia jeden czytelny parametr i daje feedback. Prompt pokazuje
semantyczną akcję, nie hardkodowany klawisz.

### L2 — myśl kontekstowa

Po zaobserwowaniu faktu albo 20–30 sekundach bez postępu Lena formułuje jedną
obserwację lub hipotezę. Nie podaje rozwiązania.

### L3 — test rozróżniający

Po dwóch nieudanych próbach albo 45–60 sekundach realnego zastoju Lena nazywa
konkretny test: obiekt, źródło lub kolejność, która odróżni bieżące hipotezy.

### L4 — jawna pomoc systemowa

Na żądanie lub po dłuższym utknięciu pojawia się `WSKAZÓWKA`. Mówi co zrobić i
dlaczego, ale nie wykonuje akcji, nie wybiera dialogu za gracza, nie nadaje
moralnej etykiety i nie otwiera niespełnionej gałęzi finału. L4 można wyłączyć;
L0/L1 pozostają.

## 4. Dane `GuidanceBeat`

Każdy beat posiada:

- `beat_id` — stabilny identyfikator;
- `station_id` i opcjonalny `sequence_id`;
- `world_state_required` — wymagane fakty;
- `knowledge_state_required` — co Lena już wie;
- `trigger` — wejście, obserwacja, brak postępu, nieudane próby, powrót albo
  ręczne żądanie;
- `tier` — L0..L4;
- `thought_kind` — observation, interpretation, intention albo system_hint;
- `text_key` — PL/EN poza skryptem stacji;
- `cooldown_s`, `once_per_state` i `supersedes`;
- `truth_scope` — factual, fallible, procedural albo system;
- `hypothesis_id` i `predicted_check`, gdy myśl może być błędna;
- `blocked_by` — dialog, pauza, zagrożenie, filmowa interpunkcja lub brak zgody.

Runtime:

- jedna powierzchnia tekstowa naraz;
- minimum 8 sekund między automatycznymi myślami;
- realny postęp resetuje timer, samo chodzenie w miejscu nie;
- zamknięta hipoteza dezaktywuje stare myśli;
- restart nie powtarza jednorazowego beatu fabularnego bez zmiany stanu;
- dialog, pauza i przejście sceny bezpiecznie zatrzymują timer;
- L4 nie jest zapisywane jako decyzja Leny.

## 5. Wiarygodna omylność

Błędna myśl przechodzi cztery testy:

1. wynika z faktów dostępnych Lenie;
2. pasuje do jej rany, celu albo mechanizmu obronnego;
3. przewiduje coś możliwego do sprawdzenia;
4. nowy fakt może ją uczciwie skorygować.

Dozwolone przykłady:

- `Imię zobaczył na karcie.` — obrona po Station 07; sprawdza się przez pytanie
  o wcześniejszą wizytę;
- `Marta nie zrobiłaby takiego zdjęcia.` — prawda o domowej Marcie pomylona z
  miejscową relacją;
- `Mogę wejść tylko po dane.` — samousprawiedliwienie przed procedurą adaptacji;
- `Wierzbicka zabiła Jakuba.` — gniew upraszcza świadomy systemowy wybór do
  jednej bezpośredniej przyczyny.

Zakazane:

- fałszywa nazwa akcji lub nieistniejący zasób;
- myśl kierująca do nieodwracalnej pułapki bez ostrzeżenia;
- ukrycie znanego kosztu finału;
- myśl przypisująca zgodę Marcie/Jakubowi, gdy jej nie udzielili;
- przedwczesne `inny świat`, `miejscowa Lena`, Anchor/Yield;
- sztuczny błąd tylko po to, by wydłużyć lokację;
- wszechwiedzący komentarz o intencji Wierzbickiej albo miejscowej Leny.

Fałszywa hipoteza musi prowadzić do nowej obserwacji. Nie jest karą ani
arbitralnym kłamstwem autora.

## 6. Język wewnętrzny Leny

- pierwsza osoba lub równoważny skrót myślowy, czas teraźniejszy;
- zwykle 2–12 słów, wyjątkowo do 16, jeśli inaczej ginie naturalny rytm;
- konkret przed terminem technicznym;
- urwanie, poprawka i powtórzenie są dozwolone;
- nie każda emocja zostaje zamieniona w żargon;
- brak poetyckiego narratora i zdań podsumowujących scenę;
- w silnym beacie reakcja ciała może całkowicie zastąpić myśl;
- powracające `jeszcze raz` zmienia znaczenie: metoda -> obrona -> rozpoznany
  nawyk -> świadoma odmowa powtórzenia krzywdy.

## 7. Progresja 0.3

| Scene | Fakt | Interpretacja Leny | Test / korekta |
|---|---|---|---|
| 01 | brak trzech sekund | zwykły błąd wymaga powtórki | kontrola mocowania i odczyt |
| 06 | dwie aktualne trasy | `Cache. Najprostsze.` | numer wersji; później klucz/domofon |
| 07 | sprzedawca zna Martę | imię z karty | pytanie o wcześniejszy zakup |
| 08 | nazwisko pod 14 | przełożono numerację | kod, klucz i sąsiadka |
| 11 | partnerskie zdjęcie | Marta by go nie zrobiła | realna Marta wchodzi do wspólnego domu |
| 14 | Marta zabezpiecza telefon | nie słucha Leny | wspomnienie pokazuje, że obie mówią prawdę |
| 18 | dwa źródła mają żywego Jakuba | kopiują ten sam błąd | ciało, praca i prywatna rozbieżność |
| 21 | trzy rodziny tworzą model | — | gracz wykonuje syntezę; prawda nazwana |
| 27 | odpowiedź poprawia próbę | może być echo | brak zasilania po drugiej stronie |
| 31 | adaptacja obiecuje znajome życie | wejście tylko po dane | podgląd kasowania wspomnień |
| 35 | dom trwa bez Leny | powrót wszystko naprawi | czas, gniew i zniknięcie pozostają |
| 36 | UCP łączy katastrofy | Wierzbicka bezpośrednio zabiła | rejestr pokazuje systemowy wybór ryzyka |

## 8. Prowadzenie bez tekstu

Przed napisaniem L2/L3 każda lokacja odpowiada:

1. co rusza się jako pierwsze i dlaczego;
2. gdzie jest najwyższy lokalny kontrast;
3. jakie źródło dźwięku wskazuje ważny fakt;
4. czy ciało Leny kieruje uwagę bez przejęcia sterowania;
5. jak bezpieczna błędna próba ujawnia nową informację;
6. jaki test odróżnia co najmniej dwie hipotezy;
7. czy droga i obiekt są czytelne w skali szarości;
8. czy tekst jest naprawdę potrzebny.

Brak odpowiedzi oznacza naprawę sceny, nie dopisanie myśli.

## 9. Relacje i pomoc

W scenie relacyjnej guidance nie wskazuje „właściwej” kwestii. Może:

- przypomnieć fakt, który postać już usłyszała;
- wskazać, że druga osoba przerwała działanie albo cofnęła zgodę;
- wyjaśnić mechaniczny skutek zatajenia lub ujawnienia danych przed wyborem;
- pozwolić wrócić do dokumentu, zanim gracz odpowie.

Nie może:

- ocenić postaci jako dobrej/złej;
- podpowiedzieć kłamstwa jako optymalnej ścieżki;
- ukryć, że brak informacji ograniczy późniejszą zgodę;
- zamienić relacji w quiz z jedną empatyczną odpowiedzią.

## 10. Kryteria akceptacji

- każda stacja ma L0–L4 albo jawne uzasadnienie ciszy;
- każda omylna myśl ma `hypothesis_id`, fakt źródłowy i test korekty;
- cooldown, `once_per_state`, `supersedes`, pauza i restart przechodzą test;
- zamknięta hipoteza nie wraca po nowym dowodzie;
- przed Station 21/22 obowiązują słowniki wiedzy;
- L4 jest oznaczone jako system i nie wybiera relacji/finału;
- myśl nie zakrywa dialogu, postaci, celu ani safe area;
- tekst respektuje locale, tempo, skalę i remap;
- capture może potwierdzić warstwy i overlap, nie ludzką wiarygodność myśli;
- automat może potwierdzić prawdziwość mechaniki, nie pomocność lub emocję.
