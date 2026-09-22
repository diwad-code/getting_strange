# Biblia projektu: Getting Strange

Status: **NADRZĘDNY KIERUNEK PRODUKCJI 2.0**  
Data: 2026-08-24  
Aktywna faza: P4 — kontrolowana przebudowa kreatywna w Godot 4.7

Ten dokument rozwija `PRODUCT_BRIEF.md`. Szczegółowy kanon narracji znajduje się
w `narrative/NARRATIVE_BIBLE.md` i `narrative/FULL_STORY.md`, ciągłość w
`narrative/CONTINUITY_TRACKER.md`, dialog w `narrative/DIALOGUE_SCRIPT.md`, obraz
w `../VISUAL_DESIGN.md`, a kolejność wdrożeń w `CREATIVE_REBUILD_PLAN.md`.

Oznaczenia:

- **DECYZJA** — obowiązuje do jawnego zastąpienia w `DECISION_LOG.md`;
- **KONTRAKT** — ma być możliwy do technicznej weryfikacji;
- **HIPOTEZA** — nie została dowiedziona przez samą implementację lub render;
- **LEGACY** — istnieje na dysku, ale wymaga migracji i nie ustanawia kierunku.

## 1. Tożsamość gry

**DECYZJA:** `Getting Strange` jest filmową narracyjną grą 2D z eksploracją,
zagadkami środowiskowymi i odpowiedzialnymi decyzjami. Nie jest arcade'owym
platformerem. Napięcie wynika z powolnego odkrywania, że spójna codzienność nie
zgadza się z pamięcią Leny.

Krótka obietnica:

> Wracasz po zwyczajnym pomiarze. Najpierw mylą się drobiazgi, potem ludzie,
> dokumenty i najbliższe relacje. Dopiero gdy możesz uczciwie powiedzieć „to nie
> jest mój świat”, zaczynasz szukać drogi powrotu — wiedząc, że ten świat też
> należy do kogoś.

## 2. Kontrolowana przebudowa

**DECYZJA:** nie kasujemy projektu i nie odbudowujemy sprawnych systemów od
zera. Zachowujemy techniczny kręgosłup, a treść kampanii traktujemy jako
substrat do ponownego autorstwa.

Zachowane:

- Godot 4.7, `640x360`, fizyka 60 Hz i semantyczny InputMap;
- ruch, kolizje i routing 43 scen jako infrastruktura;
- zapis kampanii, restart, menu, pauza, ustawienia i podstawy dostępności;
- proceduralne audio, CRT dialogue surface oraz infrastruktura testów;
- prototyp Anchor/Yield jako źródło zachowania, nie gotowa kampania.

Przebudowywane:

- treść, cele, rytm i inscenizacja Station 01–43;
- model, rig, animacja i reakcje ciała Leny;
- wskazówki, cele kontekstowe i wewnętrzny głos;
- kompozytor Pixel-Stage i migracja tekstów do ostrych warstw;
- kolejność ujawnień, rola postaci i bramy mechanik.

**LEGACY:** fakt, że scena lub dialog działa w obecnym runtime, nie oznacza, że
treść jest zaakceptowana. Stary content lock i dawny PKG-0116 są anulowane.

## 3. Łuk doświadczenia

| Etap | Station | Stan Leny | Obietnica interaktywna |
|---|---:|---|---|
| normalność | 01–05 | kompetencja i pewność | praca, ruch, zwykły powrót |
| niepokój | 06–09 | racjonalizacja | sprawdź drobną różnicę |
| zmieszanie | 10–13 | dwie sprzeczne wersje | szukaj zewnętrznego faktu |
| lęk | 14–17 | utrata zaufania | zdobądź niezależny zapis |
| upiorność | 18–20 | niemożliwa relacja | wyklucz prostsze hipotezy |
| rozpoznanie | 21 | „To nie jest mój świat” | połącz trzy rodziny dowodów |
| działanie | 22–30 | sprawczość z ryzykiem | poznaj koszt metod |
| odpowiedzialność | 31–41 | wybór bez pełnej wiedzy | wykonaj wzór decyzji |
| konsekwencja | 42–43 | życie po wyniku | zobacz konkretny skutek |

**KONTRAKT:** przed ukończeniem Station 21 Lena, cel gry i UI nie używają
języka alternatywnych światów ani świadomego Anchor/Yield.

## 4. Lena

**DECYZJA:** Lena Wolska, 29 lat, jest specjalistką od pomiarów drgań i
diagnostyki infrastruktury. Jej kompetencja wyjaśnia zarówno zdolność badania
zjawiska, jak i potrzebę szukania racjonalnej przyczyny.

Nie jest pustym awatarem. Gracz ma czytać jej stan z:

- przeniesienia ciężaru i tempa ruchu;
- kierunku głowy oraz uwagi;
- zawahania przed progiem;
- sposobu dotykania i mierzenia obiektów;
- oddechu, zatrzymania i odzyskiwania równowagi;
- krótkich, sytuacyjnych myśli.

Pełny kontrakt produkcyjny: `LENA_CHARACTER_AND_ANIMATION.md`.

## 5. Gramatyka komunikacji

**DECYZJA:** obowiązuje sekwencja **pokaż → naprowadź → pomyśl**.

1. Stan świata jest czytelny w obrazie, ruchu i dźwięku.
2. Brak postępu uruchamia dyskretną reakcję Leny lub środowiska.
3. Dłuższy zastój uruchamia myśl kontekstową.
4. Opcjonalny ratunek może nazwać kierunek lub brakujący warunek.

Myśl dzieli się na:

- obserwację — prawdziwy, zauważalny fakt;
- interpretację — ludzka hipoteza, która może być błędna;
- zamiar — uczciwy kierunek działania na podstawie bieżącej wiedzy.

**KONTRAKT:** myśl nigdy nie kłamie o sterowaniu, zasięgu, stanie mechanizmu ani
warunku potrzebnym do działania. Nie odtwarza się podczas dialogu i nie spamuje
bez nowej informacji. Pełna specyfikacja:
`PLAYER_GUIDANCE_AND_INNER_VOICE.md`.

## 6. Ruch i wyzwania

Podstawowe czasowniki:

- obserwuj i słuchaj;
- idź, biegnij, skacz lub wspinaj się kontekstowo;
- zbadaj, dotknij, uruchom, przesuń lub połącz materialny element;
- porównaj odczyt, dokument, miejsce lub relację;
- po Station 21: Zakotwicz albo Ulegnij.

**DECYZJA:** sterowanie reaguje szybko, a animacja wizualna zachowuje ciężar.
Hitbox i stan mechaniczny nie czekają na ozdobną animację.

Każda przeszkoda musi mieć jednozdaniowe wyjaśnienie świata bez słowa
„gracz”. Maszyna może się poruszać, bo wykonuje pracę. Nie może istnieć jako
ruchomy klocek do skakania. Obowiązuje
`TRAVERSAL_AND_OBSTACLE_DESIGN.md` i D-099.

Porażka preferuje utratę pozycji, czasu, informacji lub konieczność ponownego
ustawienia procesu. Śmierć i pełny restart są rzadkie oraz narracyjnie
uzasadnione.

## 7. Anchor/Yield

Anchor/Yield pozostaje centralnym systemem, lecz nie językiem pierwszej połowy.

### Zakotwiczenie

Utrzymuje wybrany związek lub stan mimo zakłócenia. Koszt może pojawić się jako
przeciążenie, przesunięcie innego zapisu albo wzmocnienie jednej wersji relacji.

### Uległość

Pozwala układowi przejść w sąsiedni stan bez wymuszania wyniku. Może dać
bezpieczną drogę, ale rozprasza ślad albo zmienia coś, co Lena chciała zachować.

**KONTRAKT:** pierwsze kampanijne nazwanie i świadome użycie następuje w
Station 22. Wcześniejszy prototyp `anchor_lab.tscn` jest narzędziem technicznym,
nie częścią diegetycznej wiedzy Leny.

**HIPOTEZA:** dwa czasowniki wystarczą do zróżnicowania drugiej połowy kampanii.
Implementacja ma próbować wykazać ograniczenia, nie deklarować sukces.

## 8. Świat i prawda

Rówień jest roboczą nazwą spójnej ciągłości, do której trafiła Lena. Świat:

- nie jest snem, symulacją ani wadliwą kopią;
- posiada niezależne relacje, rejestry i konsekwencje;
- zna miejscową Lenę, której los nie jest jeszcze przesądzony;
- zawiera żywego Jakuba, lecz nie jest on „nagrodą” ani prostym wskrzeszeniem;
- jest badany i częściowo eksploatowany przez UCP;
- reaguje na rezonans przez warstwę nazywaną Podstrukturą.

Pełna natura Podstruktury może pozostać niepewna. Operacyjne skutki muszą być
czytelne przed nieodwracalnym wyborem.

## 9. Prowadzenie fabuły

Duże ujawnienie wymaga co najmniej trzech niezależnych rodzin zapowiedzi i nie
może polegać wyłącznie na tekście. Station 21 używa:

1. żywego Jakuba i rozbieżnej relacji;
2. fizycznego nośnika niesionego przez Lenę;
3. zgodnej, publicznej ciągłości obcej biografii.

Marta i Jakub mają własny interes. UCP nie jest wyłącznie złoczyńcą; realnie
ogranicza pewne szkody, przenosząc koszt na słabiej reprezentowane ciągłości.
Nikt przed 21 nie pełni roli ekspozycyjnego przewodnika.

## 10. Kierunek wizualny

**DECYZJA:** aktywnym stylem jest Rówień Pixel-Stage.

- świat: kontrolowany pixel-art i nearest sampling;
- postać: czytelny, ludzki rig i animacja aktorska;
- tekst: natywnie ostry nad kompozytorem;
- kompozycja: duże masy, wyraźna droga i jeden główny akcent;
- dziwność: precyzyjne naruszenie stabilnego wzoru, nie stały glitch.

Poprzednia zasada wykluczająca pixel-art została częściowo zastąpiona przez
ADR-006. Zachowujemy dyscyplinę Vector-Stage jako kompozycję, nie gładką
powierzchnię renderu.

## 11. Dźwięk

- Kroki, ubranie, czytnik i oddech wiążą animację z ciałem.
- Infrastruktura komunikuje cykl i stan przed tekstem.
- Motyw rezonansu zaczyna jako wiarygodny dźwięk techniczny, a później ujawnia
  związek z Podstrukturą.
- Muzyka nie instruuje od pierwszych ekranów, że wydarzyło się coś paranormalnego.
- Dialogowe blipy nie mogą zagłuszać pauz, głosu ciała ani czytelności tekstu.

## 12. Dostępność i ostre UI

- pełne napisy i identyfikacja mówiącego;
- regulacja wielkości/tempa tekstu i możliwość pominięcia linii;
- brak informacji przekazywanej wyłącznie kolorem;
- opcjonalny poziom ratunku L4 z systemu prowadzenia;
- tekst, ikony sterowania, dokumenty i terminale zawsze ponad pikselizacją;
- pauza nie resetuje kontekstu myśli ani postępu beatu.

## 13. Architektura kampanii

Każdy Station jest małą sceną z jawnie przypisanymi:

- pasmem emocjonalnym;
- bieżącym celem;
- stanem wejściowym i wyjściowym;
- jednym dominującym zdarzeniem;
- warstwami guidance;
- tekstami ostrymi;
- wymaganymi animacjami Leny;
- flagami zapisu i testem regresji.

Migracja odbywa się pionowymi wycinkami, a nie osobnymi seriami „najpierw cała
fabuła, potem cała grafika”. Każdy pakiet dostarcza gotowy standard dla swojego
przedziału: treść + postać + prezentacja + prowadzenie + testy + kadry.

## 14. Rodziny zakończeń

1. Powrót za wszelką cenę.
2. Ochrona obcego świata.
3. Przejście kontrolowane.

Sprzeczne wymuszenia mogą zdegradować stabilność dowolnej z tych rodzin w
epilogu; nie tworzą czwartej śluzy ani osobnej moralnej opcji.

Wynik zależy od wcześniejszych działań. Finał nie jest menu z moralnymi
etykietami. Każda rodzina pokazuje konkretny skutek dla Leny, Marty, Jakuba,
miejscowej Leny i infrastruktury, jeśli pozostają w jej zakresie.

## 15. Granice produkcyjne

- Tylko Godot 4.7; brak webu i Git.
- Brak dodatkowych platform dystrybucyjnych w tym planie.
- Brak nowych globalnych managerów, gdy wystarcza mały komponent/scena.
- Brak hardkodowanych klawiszy w gameplayu.
- Brak dowodzenia emocji wynikiem automatycznego testu lub pojedynczym renderem.
- Brak przepisywania systemu zapisu, audio lub menu bez błędu blokującego
  kontrolowaną przebudowę.

## 16. Aktualna Definition of Done wycinka

Wycinek jest ukończony dopiero, gdy:

1. kanon, runtime i testy mówią to samo;
2. Lena ma wymagane stany ruchu i reakcje;
3. obraz prowadzi przed myślą;
4. tekst pozostaje ostry przy włączonej pikselizacji;
5. zapis/restart/przejście zachowują flagi;
6. świeże kadry świata, ruchu, dialogu i myśli zostały technicznie obejrzane;
7. `verify.ps1` kończy się kodem 0;
8. dokumentacja, log, handoff i snapshot opisują faktyczny stan.

## 17. Otwarte hipotezy

- tempo narastania i próg Station 21;
- czytelność nowej Leny po kompozycji;
- częstotliwość i wiarygodność myśli;
- bogactwo Anchor/Yield bez arcade'owej presji;
- jakość trzech zakończeń i ich stanów stabilności;
- wydajność kompozytora na słabym sprzęcie;
- emocjonalna skuteczność całości.

Żadna z tych hipotez nie staje się faktem tylko dlatego, że test przechodzi.
