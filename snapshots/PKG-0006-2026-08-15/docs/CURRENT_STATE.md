# Aktualny stan projektu

Stan na: 2026-08-15

## Katalog i srodowisko

- Katalog: `C:\getting_strange`
- Godot: `4.7.stable.official.5b4e0cb0f`
- Platforma robocza: Windows, PowerShell 7
- **Wersjonowanie: brak (D-016).** Pliki na dysku sa jedynym stanem projektu.
  Nie ma repozytorium, galezi, commita ani historii. Nie uruchamiamy `git`.
- Ostatni zamkniety pakiet: `PKG-0006`, 2026-08-15
- Kronika pakietow: `SESSION_LOG.md` - jedyna historia, append-only
- Zamrozenia: `snapshots/PKG-NNNN-DATA/` przez `tools/snapshot.ps1` (D-017);
  ostatnie: `snapshots/PKG-0006-2026-08-15` (48 plikow, 0,23 MB)

Do PKG-0005 wlacznie projekt byl wersjonowany. W `PKG-0006` usunieto `.git`,
`.gitignore` i `.gitattributes`. Ta historia nie istnieje juz w formie
odtwarzalnej; kazdy stan sprzed `PKG-0006` jest opisany wylacznie w
`SESSION_LOG.md`. Nie powoluj sie na commity - nie da sie ich sprawdzic.

## Aktywna faza

Runtime pozostaje w `P1 / Prototype 01: Movement Lab` i **nie jest obecnie
prowadzony**. Aktywny tor kreatywny to `N0.2 / Narrative and Visual Canon 0.2`.

Model dowodu calego projektu zmienil sie 2026-08-15. Zewnetrzne playtesty i
czytania stolikowe nie odbeda sie (D-012, ADR-003). Bramki P1, P2, P3 i N1
zostaly przepisane na pomiar obiektywny i audyt kontraktu. Kazda z nich
wymienia jawnie, czego nie sprawdza.

Prowadzenie kanonu, kierunku wizualnego i dokumentow zarzadczych jest w rekach
roli wlascicielskiej z eskalacja (D-013). Runtime, Prototype 02 i bramka P1
pozostaja poza tym zakresem.

Aktywna specyfikacja kreatywna:
`docs/narrative/NARRATIVE_BIBLE.md`

Specyfikacja aktywnego prototypu runtime:
`docs/PROTOTYPE_01_MOVEMENT_LAB.md`

Dokumenty wykonawcze N1:

- `docs/narrative/FULL_STORY.md` — 45 przestrzeni w pieciu aktach;
- `docs/narrative/CONTINUITY_TRACKER.md` — poszlaki, stany i warunki finalow;
- `docs/narrative/DIALOGUE_SCRIPT.md` — glosy i 15 kluczowych scen dialogowych;
- `VISUAL_DESIGN.md` — rezyseria wizualna oraz handoff artystyczny.

## Potwierdzone jako istniejace

### Runtime

- Projekt Godot 640x360 uruchamia scene
  `scenes/prototype/movement_lab.tscn`.
- `PrototypePlayer` uzywa `CharacterBody2D`.
- Ruch ma coyote time, bufor skoku, zmienna wysokosc skoku, szybsze opadanie
  i limit predkosci spadania.
- Graybox ma deterministyczny smoke test calej trasy, szybki restart i cel.
- Profile A/B/C laduja sie z `resources/movement/`, a A zachowuje bazowe liczby.
- A/B/C roznia sie tylko czterema parametrami reakcji poziomej.
- Facylitator uruchamia wybrany profil przez
  `tools/run_movement_profile.ps1 -Profile A|B|C`; zly kod jest odrzucany.

### Kanon kreatywny 0.1

- Protagonistka to Lena Wolska, inzynierka aparatury korelacji prozniowej.
- Akcja rozgrywa sie przez jedna noc i poranek w Rowni, ktora pamieta lokalna
  wersje Leny zaginiona siedemnascie dni wczesniej.
- Rdzen relacyjny tworza Marta Kurek, zywy Jakub Wolski, dr Helena Wierzbicka,
  lokalna Lena jako Slad i Szymon Bera.
- UCP naprawde chroni wspolna historie i realnie ratuje ludzi, ale przenosi
  koszt sprzecznosci na slabo poswiadczone osoby i miejsca.
- Nie istnieje potwierdzona pierwotna galaz. Takze swiat Leny nosi slad korekty.
- Pelna historia ma 45 przestrzeni: Pomiar, Bledy zgodnosci, Korekta,
  Podstruktura i Sygnal powrotu.
- Trzy pelne rodziny zakonczen to Powrot, Uzgodnienie i Swiadectwo. Zadne nie
  zostalo oznaczone jako dobre, zle ani kanonicznie zwycieskie.
- Tracker wymaga co najmniej trzech poszlak przed kazdym duzym zwrotem i
  pilnuje wiedzy postaci, rekwizytow oraz warunkow finalow.
- Biblia dialogowa odroznia glosy i zawiera wszystkie rozmowy niosace glowne
  zwroty emocjonalne; nie jest jeszcze pelna lista linii implementacyjnych.
- `VISUAL_DESIGN.md` definiuje materialna, informacyjna korekte zamiast
  dekoracyjnego glitchu, palete, sylwetki, kluczowe kadry i test pionowego
  wycinka.

### Wyniki audytu kanonu 0.1 (2026-08-15)

Audyt wykonala sesja bez udzialu w tworzeniu materialu. To jest teraz jedyny
mechanizm kontroli jakosci narracyjnej (R-016).

Rozstrzygniete pomiarem, nie opinia:

- **H-010a: REFUTED.** Tracker deklaruje szesc poszlak zwrotu o skorygowanej
  galezi Leny. Dwie nie istnieja w `FULL_STORY.md`, jedna nie prowadzi do
  wniosku. Realnie sa dwie.
- **H-011a: REFUTED.** Swiadectwo ma piec strukturalnych sygnalow przewagi nad
  Powrotem i Uzgodnieniem: jedyny warunkowy, jedyny domykajacy wszystkie szesc
  postaci, jedyny z triumfalna wymiana argumentacyjna, najbardziej afirmatywny
  epilog, wlasna regula palety.

Zidentyfikowane sprzecznosci twarde, jeszcze nienaprawione:

- los Wierzbickiej w finale C: biblia mowi "ginie", `FULL_STORY.md` mowi
  "przegrana politycznie";
- rachunek Linii 4: trzy dokumenty daja trzy odczyty tego, kim jest jedenascie
  osob i czy Jakub jest wsrod nich;
- wiek Jakuba: 31 lat minus 13 lat nie daje deklarowanych dwudziestu;
- trzy niezgodne wersje wariantu instrumentalnego finalu B;
- dwa rozne "ostatnie obrazy" finalow A i C;
- "mniej niz pol sekundy" w IKP wobec zegara 21:43-21:45;
- zegar prologu: siedem przestrzeni w pietnascie minut.

Braki, ktore podwazaja deklaracje samych dokumentow:

- `DIALOGUE_SCRIPT.md` deklaruje komplet scen ze zwrotami i nie zawiera scen
  dla przestrzeni 24, 35 i 41 - w tym najwiekszego zwrotu gry;
- `FULL_STORY.md` nie zawiera zadnego stanu przegranej, a `PROJECT_BIBLE.md`,
  `ROADMAP.md` i `NARRATIVE_BIBLE.md` 7.9 zakladaja, ze istnieje;
- mechanika sygnaturowa ma jawne zastosowanie w okolo pieciu z 45 przestrzeni;
- `RESEARCH_FOUNDATIONS.md` nie zawiera zadnego zrodla o pamieci, zalobie,
  anomii ani psychologii instytucji - czyli o temacie gry;
- `INSPIRATION_BOUNDARIES.md` zabezpiecza wylacznie przed Another World i nie
  wspomina o Severance ani Control.

Pelna lista znalezisk z lokalizacjami i priorytetami P0/P1/P2 jest w raporcie
audytu; pakiety N0.2-B i dalsze realizuja ja po kolei.

## Ostatnia swieza weryfikacja

Komenda:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Potwierdzony wynik po synchronizacji dokumentacji:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Kontrakt dokumentacji obejmuje teraz `ADR-003`. Bramka nadal sprawdza istnienie
plikow i zachowanie grayboxu; **nie sprawdza spojnosci kanonu narracyjnego** -
to jest tresc propozycji D-014.

Pakiet nie zmienia scen, grafiki ani runtime, wiec nie tworzy nowego renderu
gry. Ostatni render bazowego Movement Lab pozostaje technicznym dowodem 01B,
nie wizualizacja nowego kierunku artystycznego.

## Czego jeszcze nie potwierdzono

### Nie zostanie potwierdzone nigdy w tym projekcie

Zapisane jawnie, bo to sa twierdzenia, do ktorych projekt **nie ma prawa** i
nie wolno ich uzywac w zadnym dokumencie ani materiale bez etykiety braku
dowodu (D-012, ADR-003, R-015):

- czy ruch jest przyjemny i czy nowa osoba zaczyna bez instrukcji (H-001);
- czy gracz odczyta niezgodnosc swiata z akcji, bez ekspozycji (H-003);
- czy rzadkie zagrozenia utrzymaja napiecie przez 2-3 godziny (H-004);
- czy Uleglosc bedzie kuszaca, a nie odbierana jak zla opcja (H-006);
- czy brak HUD-u nie pogorszy czytelnosci stanu (H-007);
- czy Marta i Jakub uniosa rdzen emocjonalny - najdrozsze przyjete ryzyko
  projektu (H-008);
- czy UCP bedzie odbierane jednoczesnie jako skuteczne i krzywdzace (H-009b);
- czy zwrot zaskakuje (H-010b);
- czy kazdy final ma obroncow i rozpoznany koszt (H-011b).

### Mozliwe do potwierdzenia i jeszcze niezrobione

- czytelnosc kluczowych elementow w 640x360 na realnym renderze (H-012);
- liczba przestrzeni z jawnym, roznym zastosowaniem mechaniki (H-002a);
- rownowaga dowodow na skutecznosc i krzywde UCP w tekscie (H-009a);
- zmierzony koszt jednego finalnego kadru i animacji protagonisty (H-005) -
  jedyne kryterium rozstrzygajace o wykonalnosci calego projektu;
- ponowny pomiar H-010a i H-011a po poprawkach P0-4, P0-5 i P1-1.

### Nadal niewykonane

- Nie wybrano profilu ruchu i nie otwarto Prototype 02.
- Zakotwiczenie i Uleglosc nadal nie istnieja w kodzie.
- 45 przestrzeni i 2-3 godziny nie maja budzetu produkcyjnego; liczba 45 miesza
  pomieszczenia z beatami i nie zostala rozdzielona.
- Nie ma finalnych dialogow implementacyjnych, voice-overu ani lokalizacji.
- Kierunek wizualny nie ma concept artu, testu 640x360 ani finalnych assetow,
  animacji, audio i UI.
- Nie sprawdzono tytulu handlowego ani praw przed publikacja.
- Nie ma konsultacji eksperckiej dla opisow pamieci, zaloby i korekty; to jest
  jedyny obszar, w ktorym brak wiedzy zewnetrznej moze skrzywdzic odbiorce, a
  nie tylko projekt.

## Znane ograniczenia techniczne i produkcyjne

- Automatyczne testy potwierdzaja kontrakty plikow i zachowanie grayboxu, nie
  jakosc fabuly, emocje, fun ani czytelnosc obrazu.
- `DOCS PASS` sprawdza istnienie plikow i obecnosc naglowkow. Nie wykryl zadnej
  z siedmiu sprzecznosci kanonu ani dwoch falsyfikacji z audytu. Zielona bramka
  nie jest dowodem spojnosci tresci.
- Krytyka zewnetrzna zniknela z procesu. Rola recenzenta musi byc odtwarzana
  swiadomie przez sesje bez dostepu do rozmowy tworzacej material (D-008,
  R-016). To nie jest higiena kontekstu, tylko jedyne zabezpieczenie jakosci.
- Cofanie jest ograniczone do jednego pakietu wstecz (D-016, D-017, R-017).
  `tools/snapshot.ps1` zamraza tresc projektu na koniec pakietu, ale snapshoty
  leza w katalogu projektu, wiec nie chronia przed jego utrata. Niewykrywalne
  pozostaja cudze edycje; assety binarne nie maja czytelnego porownania.
  Reszta zabezpieczenia to dyscyplina: czytaj caly plik przed zastapieniem,
  zapisuj natychmiast, nigdy nie odtwarzaj tresci z pamieci.
- Kopia poza dysk projektu nie istnieje i jest otwarta decyzja wlasciciela.
- Opis Zakotwiczenia i Uleglosci w scenach jest celem dramaturgicznym, nie
  obietnica, ze obecna forma mechaniki przejdzie prototyp.
- Final Swiadectwa jest szczegolnie narazony na odczytanie jako ukryty golden
  ending; wymaga slepego testu obok Powrotu i Uzgodnienia.
- Alias `godot.exe` nie zawsze przekazuje PowerShellowi kod wyjscia;
  `tools/verify.ps1` odnajduje wariant konsolowy i sprawdza tekst bledow.

## Nastepny pakiet

`N0.2-B: Kanon 0.2 - sprzecznosci, poszlaki i brakujace sceny zwrotow`

Cel: usunac siedem twardych sprzecznosci miedzy dokumentami kanonu, dopisac do
`FULL_STORY.md` brakujace zapowiedzi zwrotu o skorygowanej galezi Leny i
napisac trzy brakujace sceny dialogowe dla przestrzeni 24, 35 i 41. Pakiet
konczy sie ponownym pomiarem H-010a.

Pakiet **nie** dotyka runtime, nie otwiera Prototype 02, nie wybiera
kanonicznego finalu i nie tworzy assetow.

Pelny zakres i warunki sa w `NEXT_SESSION_PROMPT.md`.

Rownolegle otwarte, niezalezne:

- decyzja o profilu ruchu i bramka P1 - poza rola wlascicielska D-013;
- potwierdzenie propozycji D-014 i D-015;
- decyzja kierunkowa o istnieniu stanu przegranej w grze.

## Punkt przekazania

Nowa sesja zaczyna od swiezej weryfikacji, czyta `AGENTS.md`, `INDEX.md`, ten
plik i `NEXT_SESSION_PROMPT.md`, a nastepnie cztery dokumenty narracyjne.

Nie prowadzi czytania stolikowego ani playtestu - te nie odbeda sie i nie wolno
ich symulowac. Nie oznacza zadnej hipotezy jako `SUPPORTED`. Hipoteze MIERZALNA
wolno zamknac wylacznie statusem `MEASURED` albo `REFUTED`, z podana metoda i
liczba.
