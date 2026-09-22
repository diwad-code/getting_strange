# Prowadzenie, informacja i myśli Leny

Status: **KANON SYSTEMOWY USTANOWIONY W PKG-0116; WDROŻENIE OD PKG-0117**

## 1. Zasada nadrzędna

Gra ma najpierw **pokazać**, potem lekko **naprowadzić**, a dopiero później
pozwolić Lenie **pomyśleć głośniej**. Tekst nie może ratować kadru, który nie
pokazuje istotnego obiektu lub skutku.

Myśli są częścią charakteru Leny, nie głosem projektanta. Mogą być błędne jako
interpretacja świata, ponieważ ludzkie myśli racjonalizują, unikają i zgadują.
Nie mogą być błędne jako instrukcja obsługi.

## 2. Trzy warstwy wypowiedzi

| Warstwa | Przykład | Status prawdy |
|---|---|---|
| obserwacja | „Zamek rozpoznał mój klucz.” | fakt widoczny w scenie |
| interpretacja | „Administrator pomylił mieszkania.” | hipoteza Leny; może być fałszywa |
| zamiar | „Sprawdzę nazwisko na skrzynkach.” | bezpieczny kierunek działania |

Tekst nie łączy obserwacji z interpretacją w jedno zdanie. Dzięki temu gra nie
kłamie, nawet kiedy Lena się myli.

## 3. Drabina podpowiedzi L0..L4

### L0 — kadr

Światło, negatywna przestrzeń, ruch, dźwięk i ustawienie Leny wskazują ważny
element. Brak tekstu.

### L1 — reakcja

Bezpieczna interakcja zmienia jeden czytelny parametr. Prompt pokazuje nazwę
semantycznej akcji, nie klawisz na stałe.

### L2 — myśl kontekstowa

Po obserwacji albo 20–30 sekundach bez postępu Lena nazywa brakujący związek,
ale nie rozwiązanie: „Oba przewody znikają za tą samą ścianą.”

### L3 — myśl kierunkowa

Po co najmniej dwóch nieudanych próbach lub 45–60 sekundach utknięcia Lena
wskazuje konkretną rzecz/czynność: „Najpierw sprawdzę rozdzielnię po lewej.”

### L4 — ratunek opcjonalny

Po dłuższym utknięciu gracz może wywołać bezpośrednią wskazówkę. Mówi ona, co
sprawdzić i dlaczego, ale nie wykonuje akcji. Poziom L4 można wyłączyć w
ustawieniach; L0/L1 pozostają zawsze.

## 4. Deterministyczny model triggerów

Każda stacja dostarcza rekordy `GuidanceBeat`:

- `beat_id` — stabilny identyfikator;
- `world_state_required` — warunki faktów, nie timer sam w sobie;
- `trigger` — wejście, obserwacja, brak postępu, liczba nieudanych prób,
  powrót do blokady lub ręczne żądanie;
- `tier` — L0..L4;
- `thought_kind` — observation, interpretation, intention;
- `text_key` — klucz PL/EN, bez tekstu w kodzie stacji;
- `cooldown_s` i `once_per_state`;
- `supersedes` — starszy beat, którego nie wolno już odtworzyć;
- `truth_scope` — factual, fallible lub procedural.

Zasady runtime:

- jedna myśl naraz;
- minimum 8 sekund między automatycznymi myślami;
- brak powtórki bez zmiany stanu;
- timer utknięcia resetuje się tylko po realnym postępie, nie po ruchu w miejscu;
- po zamknięciu celu stare podpowiedzi są nieaktywne;
- restart fragmentu nie spamuje ponownie myślą fabularną;
- pauza i dialog zatrzymują timery prowadzenia.

## 5. Wiarygodna omylność

Dozwolone:

- „Czytnik znowu nie zsynchronizował zdjęcia.” — Lena błędnie ufa awarii;
- „Marta znała poprzednią lokatorkę.” — obrona przed niemożliwym wnioskiem;
- „Jakub nagrał to przed wypadkiem.” — hipoteza, którą scena później obala.

Zakazane:

- fałszywe polecenie wejścia w śmiertelną lub nieodwracalną pułapkę;
- błędna nazwa akcji, przycisku albo reguły fizycznej;
- myśl sugerująca utratę zasobu, której system nie ma;
- dowolna myśl przed Station 21 mówiąca „inna gałąź”, „inny świat” lub
  „lokalna Lena”;
- celowe przedłużanie utknięcia wyłącznie po to, by pokazać charakter.

Fałszywa hipoteza musi prowadzić do nowej obserwacji. Nigdy nie jest pustą karą.

## 6. Język i forma

- pierwsza osoba, czas teraźniejszy, 3–12 słów;
- Lena myśli technicznie, ale nie zamienia każdej emocji w żargon;
- jedna myśl = jedna obserwacja, interpretacja albo intencja;
- brak poetyckiego narratora, wszechwiedzy i wykładów;
- powtórzenie może zmienić znaczenie: „Błąd synchronizacji.” → „To nie jest
  synchronizacja.” → „To nie jest mój świat.”;
- myśl pozostaje na ostrym `InnerThoughtSurface`, poza pixelizacją świata;
- forma różni się od dialogu: bez portretu rozmówcy, z dyskretnym markerem
  `LENA // MYŚL`, ale z tą samą skalą tekstu i ustawieniami dostępności.

## 7. Przykładowa progresja otwarcia

| Scena | Fakt | Pierwsza myśl | Późniejsza korekta |
|---|---|---|---|
| 06 | identyfikator ma zły wpis | „Cache nie zszedł po urlopie.” | „Nie brałam urlopu.” |
| 09 | sygnał mówi „Lena” | „Reklama zaciągnęła dane z telefonu.” | brak; nie rozwiązujemy jeszcze |
| 10 | klucz otwiera obce mieszkanie | „Zmienili zamki bez protokołu.” | „To mój klucz. Nie moje rzeczy.” |
| 14 | Marta zna Lenę | „Pomyliła mnie z poprzednią lokatorką.” | „Zna mój gest. Nie zna tego gestu.” |
| 18 | dzwoni Jakub | „Ktoś używa starego nagrania.” | „Odpowiedział na pytanie, którego nie zadałam.” |
| 21 | dowody tworzą model | „To nie jest mój świat.” | odtąd to wiedza, nie hipoteza |

## 8. Prowadzenie bez tekstu

Każda lokacja przed napisaniem myśli odpowiada:

1. co porusza się jako pierwsze;
2. gdzie pada najwyższy lokalny kontrast;
3. jaki dźwięk ma źródło w ważnym obiekcie;
4. czy Lena patrzy lub ustawia ciało ku temu obiektowi;
5. jak błędna próba pokazuje nową informację;
6. czy droga i interakcja są czytelne w skali szarości.

Jeśli odpowiedzi brak, naprawiamy scenę, nie dopisujemy podpowiedzi.

## 9. Kryteria akceptacji

- każda scena ma zapisaną drabinę L0..L4 albo jawne uzasadnienie ciszy;
- test potwierdza cooldown, brak powtórek i dezaktywację po postępie;
- myśli L2/L3 pojawiają się tylko przy właściwym stanie, nie globalnym timerze;
- żadna myśl omylna nie fałszuje sterowania ani nieodwracalnego kosztu;
- cały tekst korzysta ze skali, locale i remapu R1;
- capture pokazuje brak overlapu z dialogiem, pauzą i safe area;
- automaty nie są opisywane jako dowód, że człowiek zrozumie wskazówkę.
