# Fundamenty researchu

Status: **ŹRÓDŁA I OGRANICZONE WNIOSKI, AKTUALIZACJA 2026-08-24**

Dokument zachowuje źródła potrzebne do decyzji produkcyjnych. Fakt ze źródła,
nasz wniosek i hipoteza projektowa muszą pozostać rozdzielone. Dane o wersjach,
cenach, prawie i platformach wymagają odświeżenia przed publikacją.

## Another World — ruch i inscenizacja

### Źródła bezpośrednie

- [GDC Vault: Classic Game Postmortem — Out of This World/Another World](https://www.gdcvault.com/play/1014630/classic-game-postmortem-out-of)
- [Nintendo World Report: Interview with Eric Chahi on Another World](https://www.nintendoworldreport.com/interview/47746/interview-with-eric-chahi-on-another-world-for-nintendo-switch)
- [CNC: Éric Chahi — rytm filmowy Another World](https://www.cnc.fr/jeu-video/actualites/eric-chahi---javais-envie-de-creer-un-rythme-cinematographique-pour-another-world_932601)

### Fakty ze źródeł

- Chahi opisuje wykorzystanie dwuwymiarowej animacji wielokątowej oraz ruchu
  budowanego jako część filmowego rytmu.
- W rozmowie NWR wskazuje, że wielokąty pozwalały pomieścić wiele animacji i
  krótkie filmowe cięcia, a sugestia oraz wyobraźnia odbiorcy zastępowały pełny
  detal.
- Twórca opisuje przeplatanie gameplayu z bardzo krótką filmową interpunkcją,
  zamiast oddzielania gry i długich przerywników.
- W rozmowie CNC wiąże rytm z ruchem, okresami ulgi i przyspieszenia oraz zmianą
  kadru.

### Wniosek dla Getting Strange

To **nie** prowadzi do kopiowania klatek lub rotoskopii. Produkcyjnie przyjmujemy
trzy ogólne zasady:

1. ruch Leny jest obserwowany jak ruch ciała: przygotowanie, ciężar, kontakt i
   wyhamowanie;
2. silna, uproszczona poza jest ważniejsza niż nadmiar detalu;
3. filmowa interpunkcja jest krótka i wyrasta z akcji gracza.

Własna implementacja musi mieć odrębny model sheet, proporcje, kostium, klatki,
timing, paletę, scenografię i narrację. Szczegóły:
`LENA_CHARACTER_AND_ANIMATION.md` i `INSPIRATION_BOUNDARIES.md`.

### Czego źródła nie dowodzą

- że historyczne tempo sterowania będzie odpowiednie dla tej gry;
- że sama rotoskopia lub wielokąty tworzą dobrą animację;
- że podobna sylwetka, paleta albo sekwencja jest bezpieczna prawnie;
- że nasz nowy rig będzie czytelny lub emocjonalny po wdrożeniu.

## Powolna groza i narracja środowiskowa

### Źródła

- [GDC Vault: What Happened Here? Environmental Storytelling](https://www.gdcvault.com/play/1012696/What-Happened-Here-Environmental)
- [Frictional Games: 9 years, 9 lessons on horror](https://frictionalgames.com/2019-10-9-years-9-lessons-on-horror/)
- [Frictional Games: Q&A with writer Ian Thomas](https://frictionalgames.com/2018-02-qa-with-frictional-writer-ian-thomas/)

### Wnioski produkcyjne

- Kontrolowana luka może uruchomić wyobraźnię; przypadkowa sprzeczność niszczy
  zaufanie do zasad.
- Rekwizyt, światło, dźwięk, droga i reakcja ciała powinny nieść wydarzenie
  zanim tekst je skomentuje.
- Zwyczajna procedura może być bardziej niepokojąca niż dekoracyjny efekt,
  jeśli ma zrozumiałą funkcję i koszt.
- Normalność musi zostać ustanowiona, by rozbieżność miała miarę. To jest
  wniosek projektowy, nie dowód, że progi 01–21 wywołają zakładane emocje.

## Prowadzenie i zagadki

### Źródła

- [GDC Vault: LIMBO — Balancing Fun and Frustration](https://www.gdcvault.com/play/1013665/Limbo-Balancing-Fun-and-Frustration)
- [Playdead: LIMBO playtesting](https://www.gamedeveloper.com/business/playdead-s-intense-i-limbo-i-playtesting)
- [Cocoon: mental staircases and puzzle construction](https://www.gamedeveloper.com/design/mental-staircases-and-paradoxical-suitcases-crafting-the-world-hopping-puzzles-of-cocoon)

### Wnioski produkcyjne

- Błędna próba powinna dać nową informację zamiast wyłącznie karać.
- Brakujący krok rozumowania najlepiej pokazać bezpiecznym przykładem, a tekst
  wykorzystać jako późniejszy stopień ratunku.
- W `Getting Strange` przekładamy to na pokaż → naprowadź → pomyśl oraz
  mierzalne progi zastoju.
- Projekt nie prowadzi zewnętrznych playtestów (D-012, ADR-003), więc nie wolno
  przenosić wyników tych praktyk jako dowodu naszego odbioru. Audyt afordancji,
  flag i cooldownów jest tylko technicznym proxy.

## P7 — wieloetapowe zagadki diagnostyczne

### Źródła odczytane 2026-08-30

- [Outer Wilds: knowledge, Curiosities and distributed clues — GamesRadar+, 2020](https://www.gamesradar.com/the-making-of-outer-wilds/)
- [Return of the Obra Dinn: discrete mysteries and the book tool — Game Developer, 2019](https://www.gamedeveloper.com/business/road-to-the-igf-lucas-pope-s-i-return-of-the-obra-dinn-i-)
- [The Case of the Golden Idol: deduction, partial feedback and information density — Game Developer, 2022](https://www.gamedeveloper.com/design/case-of-the-golden-idol)
- [Chants of Sennaar: functional worlds and redundant contexts — Game Developer, 2024](https://www.gamedeveloper.com/design/immersing-players-in-the-culture-of-a-people-with-language-puzzler-chants-of-sennaar)
- [Puzzle Writing: Best Practices — GDC Vault, 2010](https://gdcvault.com/play/1013851/Puzzle-Writing-Best)
- [Open-Ended Puzzle Design at Zachtronics — GDC Vault, 2019](https://gdcvault.com/play/1025715/Open-Ended-Puzzle-Design-at)
- [Pusey, Wong, Rappa: Puzzle Challenge Analysis Tool — CHI PLAY, 2021](https://dl.acm.org/doi/10.1145/3474703)

### Fakty i ograniczone wnioski

- Twórcy `Outer Wilds` najpierw określili ukryte cele wiedzy, potem
  rozmieścili między lokacjami wskazówki do nich prowadzące. Dla projektu:
  wiedza ma otwierać działania, lecz nie kopiujemy pętli czasu ani struktury
  układu słonecznego.
- Lucas Pope dzielił złożoną historię na lokalnie zrozumiałe katastrofy i
  dołożył księgę, gdy pamięć robocza przestała wystarczać. Dla projektu:
  sekwencja 2–4 stacji musi mieć własne pytanie i zewnętrzny zapis faktów,
  który nie rozwiązuje jej za gracza.
- `Golden Idol` pokazuje ryzyko nadmiaru informacji oraz binarnej walidacji;
  ogranicza materiał do dowodów lub świadomych mylnych tropów i daje sygnał
  postępu bez ujawniania odpowiedzi. Dla projektu: nie tworzymy magazynu
  „lore pickupów” ani zgadywanki z jednym przyciskiem.
- Rundisc wymagał co najmniej dwóch różnych kontekstów dla nieznanego elementu
  i zakotwiczał zagadki w funkcjonującym świecie. Dla projektu: każdy wymagany
  wniosek dostaje redundantny, sprawdzalny dowód; infrastruktura istnieje też
  bez Leny.
- GDC opisuje zagadkę jako kontrakt z pełną informacją do rozwiązania i
  integracją z fabułą. Otwarta przestrzeń rozwiązań jest właściwa dla
  zobowiązań i zgód, nie dla faktów, które gracz musi uczciwie ustalić.
- Badanie CHI PLAY podkreśla, że samo przejście lub wynik punktowy nie mierzy
  wyzwania zagadki. Testy projektu mogą weryfikować strukturę informacji,
  konsekwencję stanu i brak softlocka, ale nie satysfakcję odbiorcy.

### Czego źródła nie dowodzą

- że 12–15 sekwencji lub pięć rodzin wyzwań da oczekiwane napięcie w tej
  kampanii;
- że gracz rozpozna koszty Anchor/Yield bez pomocy L3/L4;
- że decyzja o zgodzie będzie odczytana jako sprawczość, a nie blokada;
- że planowane zagadki zachowają budżet wydajności lub zmieszczą się w
  istniejącym stanie zapisu.

### PKG-0144 — dane sekwencji i zapis P7

Źródła odczytane 2026-08-30:

- [Godot 4.7: Resources](https://docs.godotengine.org/en/4.7/tutorials/scripting/resources.html)
- [Godot 4.7: Saving games](https://docs.godotengine.org/en/4.7/tutorials/io/saving_games.html)

Fakty źródłowe: `Resource` jest kontenerem danych, może mieć eksportowane
właściwości oraz serializowane subresources. JSON jest właściwy dla prostego,
czytelnego stanu, ale nie reprezentuje bezpośrednio wszystkich typów Godot;
zapis ma zachowywać tylko dane potrzebne do odtworzenia stanu, nie Nodes.

Wniosek dla projektu: authored statyczne kontrakty P7 mogą żyć w małych
`Resource`, a istniejący JSON `GameStateManager.decisions` pozostaje miejscem
trwałych prymitywów wykonania. To rozdziela dane projektowe od konkretnego
przebiegu bez drugiego save systemu lub globalnego menedżera zagadek.

Źródła nie dowodzą, że migracja istniejących checkpointów, jedna kotwica albo
wybrana struktura danych uniknie softlocków w tym projekcie. Dowodem będą
wyłącznie testy migracji, stanów i przejść wykonane w PKG-0145.

## Godot i prezentacja 2D

### Źródła

- [Godot: dedykowane narzędzia 2D](https://docs.godotengine.org/en/stable/tutorials/2d/index.html)
- [Godot: wiele rozdzielczości](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html)
- [Godot: SubViewport](https://docs.godotengine.org/en/stable/classes/class_subviewport.html)
- [Godot: licencja MIT](https://godotengine.org/license/)

### Wnioski produkcyjne

- Godot 4.7 pozostaje właściwym silnikiem 2D projektu.
- Logiczny widok `640x360`, nearest filtering i całkowite skalowanie są
  kompatybilne z celowym ras­trem świata.
- `SubViewport` lub równoważna separacja renderowania pozwala przetworzyć świat
  przed narysowaniem natywnie ostrych warstw tekstu.
- PKG-0117 potwierdził wyłącznie API zastanego shadera i warstwę crisp text.
  Faktyczna jakość rastra i koszt kompozytora muszą zostać zmierzone w
  PKG-0118; dokumentacja silnika nie dowodzi ich za nas.

## Dostępność

### Źródła

- [Xbox Accessibility Guidelines](https://learn.microsoft.com/en-us/xbox/accessibility/guidelines)
- [XAG 107: Input](https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/107)
- [XAG 108: Difficulty options](https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/108)

### Wnioski produkcyjne

- Semantyczne akcje i remap są wymaganiem architektonicznym.
- Wskazówki powinny mieć niezależny, opcjonalny poziom ratunku, zamiast jednego
  niejasnego trybu trudności.
- Redukcja migania, drgań i wymogu przytrzymania nie może blokować treści.
- Pikselizacja nie może obejmować tekstu, ikon sterowania ani menu.

## Prawo i oryginalność

### Źródła

- [European IP Helpdesk: copyright](https://intellectual-property-helpdesk.ec.europa.eu/ip-management-and-resources/copyright_en)
- [WIPO: video games and copyright](https://www.wipo.int/en/web/copyright/activities/video_games)

### Wnioski produkcyjne

- Ogólna idea lub technika nie jest tym samym co konkretna, chroniona ekspresja.
- Nie kopiujemy postaci, proporcji, klatek, palety, lokacji, broni, kadrów,
  zagadek ani sekwencji `Another World`.
- Otwierająca scena nie może odtwarzać samotnego naukowca, akceleratora,
  uderzenia i natychmiastowej teleportacji. Tutaj rutynowy pomiar wygląda na
  zwyczajny, a różnice pojawiają się dopiero w codzienności.
- Przed publicznym ujawnieniem potrzebny jest profesjonalny przegląd IP i
  clearance tytułu. `Getting Strange` pozostaje nazwą roboczą do tego czasu.

## Dystrybucja

### Źródła

- [Steam Direct](https://partner.steamgames.com/steamdirect)
- [Steam release process](https://partner.steamgames.com/doc/store/releasing?l=english)
- [itch.io payments](https://itch.io/docs/creators/payments)

### Wnioski produkcyjne

- Pierwszy zakres to Windows i Linux.
- Eksport jest zablokowany do content locku 2.0 po PKG-0122.
- Ceny, wymagania i terminy platform trzeba odświeżyć bezpośrednio przed
  pakietem wydawniczym.
- Projekt nie tworzy strony, PWA ani browser showcase'u.

## Jak używać dokumentu

- Nie przedstawiać interpretacji jako cytatu lub faktu źródłowego.
- Nowy research dopisywać z datą, linkiem i wpływem na konkretną decyzję.
- Źródła o narzędziach, prawie, platformach i wersjach odświeżać przed użyciem.
- Jeśli wniosek jest inferencją dla projektu, jawnie go tak oznaczyć.
