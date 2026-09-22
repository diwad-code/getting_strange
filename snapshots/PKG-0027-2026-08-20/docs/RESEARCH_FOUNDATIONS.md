# Fundamenty researchu

Status: zrodla i wnioski z fazy koncepcyjnej, 2026-08-15

Ten dokument zachowuje najwazniejsze dowody, aby kolejna sesja nie musiala
powtarzac szerokiego researchu. Zrodla moga sie zestarzec; dane o wersjach,
cenach, prawie i platformach trzeba odswiezyc przed decyzja publikacyjna.

## Another World

### Zrodla

- [GDC Vault: Classic Game Postmortem](https://www.gdcvault.com/play/1014630/classic-game-postmortem-out-of)
- [Game Developer: relacja z postmortem](https://www.gamedeveloper.com/game-platforms/gdc-2011-eric-chahi-s-retro-postmortem-i-another-world-i-)
- [Wywiad z Erikiem Chahim](https://cheesetalks.net/ericchahi.php)

### Wnioski

- Oryginal korzystal z plaskich wielokatow i rotoskopii, nie z typowego
  kafelkowego pixel artu.
- Najtrwalsza wartoscia sa rytm, atmosfera, narracyjna interpunkcja i znaczenie
  prostych dzialan w kontekscie, nie konkretne sterowanie ani bron.
- Tlo, akcja i krotkie filmowe momenty tworza jedna ciagla inscenizacje.
- Historyczna frustracja wynikala miedzy innymi z utkniecia i nieczytelnych
  rozwiazan. Getting Strange musi zachowac tajemnice, ale usunac bezuzyteczne
  tarcie.
- Ograniczenia produkcyjne wymusily redukcje i ponowne uzycie klockow. To
  argument za jedna mechanika sygnaturowa i waskim zakresem.

## Horror i narracja srodowiskowa

### Zrodla

- [GDC: Environmental Storytelling](https://www.gdcvault.com/play/1012696/What-Happened-Here-Environmental)
- [Frictional Games: 9 lessons on horror](https://frictionalgames.com/2019-10-9-years-9-lessons-on-horror/)
- [Frictional Games: rozmowa z pisarzem Ianem Thomasem](https://frictionalgames.com/2018-02-qa-with-frictional-writer-ian-thomas/)

### Wnioski

- Gracz tworzy silniejszy horror, gdy posiada role, sprawczosc i niepelny, ale
  spojny model swiata.
- Kontrolowana luka pobudza wyobraznie; przypadkowa sprzecznosc niszczy zaufanie.
- Rekwizyt, swiatlo, kompozycja i reakcja swiata moga przekazac historie bez
  dziennikow tekstowych.
- Okrucienstwo jest bardziej niepokojace, gdy wynika z normalnej procedury i
  ma funkcje w lokalnym porzadku.

## Zagadki i playtest

### Zrodla

- [GDC: LIMBO, balancing fun and frustration](https://www.gdcvault.com/play/1013665/Limbo-Balancing-Fun-and-Frustration)
- [Playdead: intensywne testy LIMBO](https://www.gamedeveloper.com/business/playdead-s-intense-i-limbo-i-playtesting)
- [Cocoon: projektowanie mentalnych schodow](https://www.gamedeveloper.com/design/mental-staircases-and-paradoxical-suitcases-crafting-the-world-hopping-puzzles-of-cocoon)

### Wnioski

- Pierwszy tester powinien byc obserwowany bez prowadzenia.
- Bledna proba musi dostarczyc nowej informacji, a nie tylko karac.
- Gdy gracze omijaja krok rozumowania, nalezy dodac brakujacy bezpieczny
  przyklad zamiast tekstowej instrukcji.
- Opinie tworcow i znajomych nie zastapia zachowania nowych graczy.

## Silnik i obraz

### Zrodla

- [Godot: dedykowane narzedzia 2D](https://docs.godotengine.org/en/stable/tutorials/2d/index.html)
- [Godot: wiele rozdzielczosci](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html)
- [Godot: licencja MIT](https://godotengine.org/license/)
- [Godot: archiwum wydan](https://godotengine.org/download/archive/)

### Wnioski

- Godot ma dedykowany renderer i fizyke 2D, a licencja nie naklada oplat od
  przychodu gry.
- 640x360, tryb `viewport`, nearest filtering i skalowanie calkowite tworza
  dobra baze dla obrazu pixel-artowego 16:9.
- Uzywamy wersji stabilnej 4.7.x, nie wydania developerskiego.

## Dostepnosc

### Zrodla

- [Xbox Accessibility Guidelines](https://learn.microsoft.com/en-us/xbox/accessibility/guidelines)
- [XAG: input](https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/107)
- [XAG: difficulty](https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/108)

### Wnioski

- Semantyczne akcje i pozniejsze mapowanie sterowania sa wymaganiem
  architektonicznym, nie poprawka na koncu.
- Warto rozdzielic ulatwienia czasu poscigu, wskazowek i wejscia zamiast
  oferowac jeden niejasny poziom trudnosci.
- Redukcja migania, drgan kamery i wymogu przytrzymania nie moze blokowac
  tresci ani zakonczen.

## Prawo i oryginalnosc

### Zrodla

- [European IP Helpdesk: copyright](https://intellectual-property-helpdesk.ec.europa.eu/ip-management-and-resources/copyright_en)
- [WIPO: video games](https://www.wipo.int/en/web/copyright/activities/video_games)

### Wnioski

- Abstrakcyjny pomysl nie jest tym samym co chroniona konkretna ekspresja.
- Naukowiec, akcelerator, blysk i natychmiastowa teleportacja odtwarzalyby
  zbyt wiele elementow konkretnego otwarcia inspiracji. Dlatego eksperyment
  wyglada na udany, a zmiana objawia sie dopiero w codziennosci.
- Nie kopiujemy postaci, ukladu scen, broni, sylwetek, palety, smierci ani
  zagadek Another World.
- Przed publicznym ujawnieniem potrzebne sa profesjonalny przeglad IP oraz
  sprawdzenie tytulu. `Getting Strange` pozostaje kryptonimem.

## Dystrybucja

### Zrodla

- [Steam Direct](https://partner.steamgames.com/steamdirect)
- [Steam release process](https://partner.steamgames.com/doc/store/releasing?l=english)
- [Steam demos](https://partner.steamgames.com/doc/store/application/demos?l=english)
- [itch.io revenue sharing](https://itch.io/docs/creators/payments)

### Wnioski

- Najpierw PC, Windows i Linux. Konsole oraz urzadzenia mobilne nie naleza do
  pierwszej fazy.
- Demo powinno wynikac z udowodnionego vertical slice, nie z niedojrzalego
  prototypu ruchu.
- Wymagania, ceny i terminy sklepow trzeba sprawdzic ponownie przed publikacja.

## Jak uzywac tego dokumentu

- Nie cytowac wnioskow jako aktualnych danych rynkowych bez odswiezenia.
- Nowy research dopisywac wraz z data, linkiem i wplywem na konkretna decyzje.
- Oddzielac fakt zrodla od naszej interpretacji oraz od hipotezy designu.
