# ADR-007: Relacyjna rewolucja fabularna na istniejącym szkielecie Godot

## Status

Accepted

## Data

2026-08-25

## Kontekst

ADR-006 poprawnie zatrzymał content lock oraz przeniósł pierwsze jawne
rozpoznanie innego świata do Station 21. Audyt kanonu 0.2 wykonany po dodaniu
lokalnych skilli pisarskich wykazał jednak, że mapa ujawnień nie jest jeszcze
pełną dramaturgią:

- Lena ma zawód i metodę myślenia, lecz brak jej osobistego pragnienia, rany i
  konfliktu obecnego od otwarcia;
- relacja Marty z Leną nie została nazwana, a jej nazwisko jest niespójne;
- przyczyna przejścia, zamiar i los miejscowej Leny nie mają kanonicznego
  rozwiązania;
- dr Wierzbicka nie ma zatwierdzonej aktywnej roli, mimo że UCP odpowiada za
  presję i koszty drugiej połowy;
- Station 22–41 są przede wszystkim planem procedur i odczytów, nie łańcuchem
  przeciwstawnych celów oraz zmian relacji;
- trzy finały są kategoriami, lecz nie definiują równoważnych, konkretnych
  konsekwencji dla wszystkich kluczowych osób.

Pełny raport i findings znajdują się w
`docs/NARRATIVE_SKILL_AUDIT_0_2.md`.

## Decyzja

Przyjmujemy **kanon 0.3: relacyjny thriller o cenie pewności**. Jest to głęboka
rewolucja fabularna przeprowadzona w istniejącym projekcie Godot, nie reset
techniczny.

### Zachowany rdzeń

- tytuł i obietnica powolnego `getting strange`;
- normalność 01–05, eskalacja 06–20, rozpoznanie w 21 i świadome działanie od
  22;
- Lena Wolska, Marta Kurek, Jakub Wolski, dr Helena Wierzbicka, UCP, Rówień i
  Podstruktura;
- trzy niezależne rodziny dowodów rozpoznania;
- Anchor/Yield jako działania o kosztach, nie przyciski dobra i zła;
- brak uprzywilejowanego „oryginału”;
- 43 adresy scen jako techniczna topologia, zgrupowane dramaturgicznie w osiem
  sekwencji;
- cały sprawny kręgosłup Godot wymieniony w ADR-006.

### Nowy osobisty rdzeń

Dziewięć lat wcześniej katastrofa Linii 4 zabiła Jakuba w ciągłości Leny.
Raport techniczny uznał trzysekundową lukę pomiarową za błąd czujnika. Lena
została diagnostyczką, ponieważ wierzy, że wystarczająco dokładny pomiar może
odebrać przypadkowi władzę. Jej siłą jest odmowa pochopnego wniosku; jej błędem
— traktowanie niepewności i żałoby jak usterek do usunięcia.

Rutynowy odczyt z Station 01 powtarza sygnaturę Linii 4. Lena zostaje dłużej,
by uzyskać czystą próbkę, choć obiecała Marcie wrócić. Ta zwyczajna decyzja
otwiera zdarzenie przejścia; pierwsze sceny nadal nie nazywają ani nie pokazują
jednoznacznie alternatywnego świata.

### Relacje

- **Marta Kurek** jest w ciągłości domowej najbliższą przyjaciółką i dawną
  partnerką terenową Leny. Ich więź osłabiła obsesja Leny na punkcie Linii 4.
- W Równi Marta jest partnerką życiową miejscowej Leny. Rozpoznaje ciało,
  głos i rytuały, ale szybko widzi brak wspólnej intymności. Jej celem jest
  odnalezienie własnej Leny, nie zaakceptowanie zastępstwa.
- **Jakub** żyje w Równi jako technik utrzymania Linii 4 i ma własne życie poza
  siostrą. Pomaga dopiero wtedy, gdy przybyła Lena przestaje mówić do niego jak
  do odzyskanej straty.
- **Miejscowa Lena** jest pełnoprawną sprawczynią. Odkryła, że stabilizacje UCP
  przenoszą niespójność na słabiej reprezentowane ciągłości. Uruchomiła
  obustronny test, by uzyskać zewnętrzny dowód. Nie planowała trwałego
  zastępstwa.
- **Dr Helena Wierzbicka** przerwała test Zakotwiczeniem Równi. Chroni ciągłość
  większości i życie uratowane na Linii 4, ale uznaje autonomię obu Len za
  dopuszczalny koszt. Jest kompetentną przeciwniczką, nie wszechwiedzącym
  złoczyńcą.

### Dwie tajemnice

1. Station 01–21: dlaczego zwyczajny świat nie zgadza się z pamięcią Leny?
   Odpowiedź: jest w obcej, spójnej ciągłości.
2. Station 22–39: co zrobiła miejscowa Lena, gdzie jest i kto zapłaci za
   przywrócenie rozdziału światów? Odpowiedź jest możliwa do wyprowadzenia z
   jej procedury, rejestru UCP, reakcji Marty/Jakuba i kosztów mechaniki.

Pełna natura Podstruktury może pozostać nieznana. Przyczyna konkretnego
przejścia, odpowiedzialność UCP oraz los miejscowej Leny nie mogą pozostać
arbitralną mgłą.

### Finały

Każda rodzina chroni inną wartość i ponosi własną stratę:

1. **Wymuszenie powrotu** chroni ciągłość i relacje Leny domowej, lecz zamyka
   miejscową Lenę po drugiej stronie sprzężenia i utrwala krzywdę UCP.
2. **Zamknięcie Równi** chroni stabilność mieszkańców oraz życie Jakuba, lecz
   przybyła Lena rezygnuje z pewnego powrotu i nie może wejść w miejsce
   partnerki Marty.
3. **Przejście wzajemne** daje obu Lenom możliwość odpowiedzi i ogranicza
   przymus, lecz pozostawia między światami trwały przeciek faktów i pamięci,
   którego nie da się zagwarantować ani kontrolować.

Szczegółowe stany mogą zależeć od wcześniejszych działań, ale żadna rodzina nie
może odzyskać domu, uratować obu Len, zachować wszystkie relacje, zamknąć UCP i
usunąć koszt sprzężenia równocześnie.

## Rozważone alternatywy

### Wdrożyć 0.2 z lokalnymi poprawkami

Odrzucone. Naprawa nazwiska i kilku kwestii nie stworzyłaby przyczyny przejścia,
aktywnej opozycji, drugiej tajemnicy ani konkretnych finałów.

### Rozpocząć pusty projekt Godot

Odrzucone. Problem leży w dramaturgii, nie w InputMap, zapisie, shellu, fizyce,
audio, testach ani topologii. Reset zwiększyłby ryzyko i nie poprawił historii.

### Relacyjna rewolucja na istniejącym szkielecie

Przyjęte. Pozwala przepisać historię bez utraty neutralnej infrastruktury i bez
bronienia dawnych scen dlatego, że już istnieją.

## Konsekwencje

- Kanon 0.2 ma status audytowanego, odrzuconego projektu pośredniego.
- Prace runtime wykonane zgodnie z 0.2 nie są automatycznie kasowane. Elementy
  techniczne oraz zgodne beaty normalności podlegają klasyfikacji
  `KEEP / ADAPT / RETIRE`.
- Nie implementujemy kolejnych stacji na podstawie 0.2. Najpierw synchronizujemy
  bible 0.3, clue ledger, relacje, cele scen, dialog i plan pakietów.
- Station 21/22 pozostają twardymi bramami wiedzy i działania.
- Testy mogą pilnować nazw, flag, kolejności i pełności stanów finału. Nie
  dowodzą emocjonalnej skuteczności relacji ani ceny decyzji.
