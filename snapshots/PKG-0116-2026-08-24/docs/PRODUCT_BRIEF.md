# Product Brief: Getting Strange

Status: **AKTYWNY KIERUNEK PRODUKTU 2.0**  
Data: 2026-08-24  
Decyzja nadrzędna: ADR-006

## Jedno zdanie

Filmowa, narracyjna gra 2D, w której Lena wraca z rutynowego pomiaru, stopniowo
odkrywa, że spójny świat pamięta inne życie, a dopiero po uczciwym rozpoznaniu
próbuje wrócić bez potraktowania cudzej rzeczywistości jak błędu do skasowania.

## Obietnica dla gracza

Tytuł `Getting Strange` opisuje czasownik i tempo: **robi się dziwnie**. Gracz
ma przejść razem z Leną od pewności do niepokoju, zmieszania, lęku,
dezorientacji i upiorności. Rozwiązanie nie może zostać podane na początku.

Gra:

- pokazuje stan przestrzeni i konsekwencje przed komentarzem;
- delikatnie prowadzi kompozycją, reakcją ciała i kontekstową myślą;
- pozwala Lenie mylić się w interpretacji, lecz nigdy w instrukcji mechanicznej;
- po rozpoznaniu zamienia obserwację w świadome działanie i odpowiedzialność;
- przedstawia Lenę jako aktorkę sceny, nie prosty znacznik kolizji;
- pikselizuje świat, pozostawiając każdy tekst ostry.

## Odbiorca i format

- Odbiorcy 16+ lubiący kameralne science-fiction, thriller psychologiczny,
  eksplorację i zagadki środowiskowe.
- Samodzielna gra Godot 4.7 na Windows i Linux; żadnej powierzchni webowej.
- Kampania 2–3 godziny, 43 krótkie przestrzenie po ponownym autorstwie.
- Klawiatura i pad, napisy, regulacja tekstu i podstawowe opcje dostępności.
- Brak walki jako podstawowego czasownika i brak arcade'owych torów przeszkód.

## Cztery filary

### 1. Dziwność narasta

Normalność musi trwać wystarczająco długo, by późniejsze różnice miały punkt
odniesienia. Station 01–05 są zwyczajne, 06–20 eskalują bez nazwania prawdy,
Station 21 jest rozpoznaniem, a Station 22 pierwszym świadomym działaniem.

### 2. Ciało opowiada

Lena ma rzeczywistą sylwetkę, ciężar, start, krok, hamowanie, zawahanie,
spojrzenie i kontakt z przedmiotem. Filmowość bierze się z czytelnej pozy i
krótkiej interpunkcji ruchowej, nie z odbierania sterowania.

### 3. Pokaż → naprowadź → pomyśl

Najpierw obraz i dźwięk komunikują zdarzenie. Gdy gracz nie wykonuje postępu,
reakcja Leny zwraca uwagę. Dopiero potem pojawia się krótka myśl lub cel
awaryjny. Podpowiedź nie rozwiązuje zagadki i nie zdradza przyszłej fabuły.

### 4. Działanie ma koszt

Po Station 21 Lena może używać Zakotwiczenia i Uległości, by wpływać na
sprzężenie światów. Nie są to przyciski dobro/zło. Każde działanie zmienia
konkretny stan miejsca, relacji lub pamięci, a finał wynika ze wzoru decyzji.

## Łuki rozgrywki

### Pierwsze 10 minut

Rutynowy pomiar, responsywny ruch, czytelna interakcja, powrót przez zwykłe
miejsce. Jedna techniczna niezgodność ma zwyczajne wyjaśnienie. Gracz poznaje
Lenę, zanim potrzebuje rozwiązywać jej sytuację.

### Jedna przestrzeń

Ustanowienie miejsca → zauważalny stan → bezpieczna obserwacja lub próba →
decyzja / działanie → widoczna konsekwencja → krótka reakcja Leny.

### Cała gra

Rutyna → wzór sprzeczności → niezależne dowody → rozpoznanie → badanie metody →
działanie z kosztami → konsekwencja.

## Kierunek audiowizualny

Fraza: **spójny świat, do którego nie pasuje jedyna osoba w kadrze**.

- Rówień Pixel-Stage: celowy raster 2D, ograniczone palety i duże czytelne masy.
- Domyślny świat: efektywne `320x180` w logicznym widoku `640x360`, nearest.
- Dialogi, myśli, szyldy do odczytania, cele i menu: natywnie ostre ponad
  kompozytorem świata.
- Dziwność wynika z precyzyjnej różnicy w stabilnym obrazie, nie stałego filtra
  glitch.
- Dźwięk materiałów, infrastruktury, oddechu i kroków prowadzi uwagę; muzyka
  pozostaje oszczędna.

## Główna mechanika

Anchor/Yield pozostaje centralnym systemem kampanii, ale jego **świadome** użycie
jest zablokowane do Station 22.

- **Zakotwiczenie:** utrzymanie wybranego związku lub stanu mimo zakłócenia.
- **Uległość:** pozwolenie układowi przejść w sąsiedni stan bez wymuszenia.

Każde zastosowanie musi być wyjaśnialne jako działanie na materialnym świecie.
Nie projektujemy skokowych aren, kolców, patrolujących wrogów ani przeszkód,
których jedynym sensem jest timing.

## Antyfilary

- brak ujawnienia alternatywnego świata w pierwszych ekranach;
- brak ekspozycyjnego przewodnika, który tłumaczy Lenie sytuację;
- brak stale gadającego wewnętrznego głosu;
- brak fałszywych podpowiedzi mechanicznych;
- brak „gryzmołu” jako docelowej postaci;
- brak pikselizacji tekstu i UI;
- brak globalnego efektu udającego pixel-art bez ręcznej kompozycji;
- brak lootowania, craftingu, drzewka umiejętności i otwartego świata;
- brak kopiowania postaci, klatek, palety, lokacji lub scen `Another World`;
- brak strony, PWA, browser showcase albo innej dystrybucji webowej.

## Zakres kontrolowanej przebudowy

Zachowujemy sprawny szkielet techniczny: Godot 4.7, sterowanie, fizykę, zapis,
kampanijny routing, menu/pauzę/ustawienia, audio i infrastrukturę testową.

Ponownie tworzymy: treść Station 01–43, inscenizację, Lenę i jej animację,
system myśli/podpowiedzi, kompozytor Pixel-Stage oraz wszystkie czytelne teksty
świata. Kolejność pakietów definiuje `docs/CREATIVE_REBUILD_PLAN.md`.

## Kryteria techniczne Foundation Slice

- Station 01–07 przechodzą od normalności do pierwszego racjonalizowalnego
  niepokoju bez jawnego ujawnienia.
- Lena ma produkcyjny rig i czytelne stany ruchu określone w specyfikacji.
- Świat jest pikselizowany, a tekst pozostaje ostry na zrzucie i w ruchu.
- Cel bieżący da się odczytać z obrazu, a system zastoju uruchamia co najmniej
  dwa stopnie pomocy bez spamowania.
- Zapis/restart i przejście 01→07 zachowują spójny stan.
- Weryfikacja działa na docelowym 60 Hz i przechodzi bez błędów kontraktu.

## Hipotezy, nie fakty

- Czy tempo 01–21 daje narastający niepokój bez nudy i bez przedwczesnego
  odgadnięcia rozwiązania.
- Czy myśli Leny pogłębiają bliskość, a nie odbierają sprawczości.
- Czy pomyłki interpretacyjne są odbierane jako ludzkie, nie arbitralne.
- Czy nowa skala Leny jest czytelna w ruchu i po kompozycji pixel-art.
- Czy Zakotwiczenie/Uległość utrzymają drugą połowę kampanii bez powtarzalności.
- Czy wszystkie trzy rodziny zakończeń są osiągalne i dramatycznie uczciwe.

Projekt nie ma zewnętrznych playtestów jako bramy. Automatyczne testy, rendery i
inspekcja mogą potwierdzić stan techniczny oraz zgodność z kontraktami, ale nie
udowadniają emocji, zabawy, zrozumienia ani odbioru przez gracza.
