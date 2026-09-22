# Aktualny stan projektu

Stan na: 2026-08-15

## Katalog i srodowisko

- Katalog: `C:\getting_strange`
- Godot: `4.7.stable.official.5b4e0cb0f`
- Platforma robocza: Windows, PowerShell 7
- **Wersjonowanie: brak (D-016).** Pliki na dysku sa jedynym stanem projektu.
  Nie ma repozytorium, galezi, commita ani historii. Nie uruchamiamy `git`.
- Ostatni zamkniety pakiet: `PKG-0008`, 2026-08-15
- Kronika pakietow: `SESSION_LOG.md` - jedyna historia, append-only
- Zamrozenia: `snapshots/PKG-NNNN-DATA/` przez `tools/snapshot.ps1` (D-017);
  ostatnie: `snapshots/PKG-0008-2026-08-15`

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

- `docs/narrative/FULL_STORY.md` — 43 przestrzenie w pieciu aktach (układ
  7/10/11/11/4 po N0.2-C);
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

### Kanon kreatywny 0.2

- Protagonistka to Lena Wolska, inzynierka aparatury korelacji prozniowej.
- Akcja rozgrywa sie przez jedna noc i poranek w Rowni, ktora pamieta lokalna
  wersje Leny zaginiona siedemnascie dni wczesniej.
- Rdzen relacyjny tworza Marta Kurek, zywy Jakub Wolski, dr Helena Wierzbicka,
  lokalna Lena jako Slad i Szymon Bera.
- UCP naprawde chroni wspolna historie i realnie ratuje ludzi, ale przenosi
  koszt sprzecznosci na slabo poswiadczone osoby i miejsca.
- Nie istnieje potwierdzona pierwotna galaz. Takze swiat Leny nosi slad korekty.
- Pelna historia ma 43 przestrzenie: Pomiar, Bledy zgodnosci, Korekta,
  Podstruktura i Sygnal powrotu. Akt II jest krotszy o dwie przestrzenie,
  a dowod dobra UCP trafia do Aktu I przed wezwaniem do Punktu 6.
- Trzy pelne rodziny zakonczen to Powrot, Uzgodnienie i Swiadectwo. Zadne nie
  zostalo oznaczone jako dobre, zle ani kanonicznie zwycieskie.
- Tracker wymaga co najmniej trzech poszlak przed kazdym duzym zwrotem i
  pilnuje wiedzy postaci, rekwizytow oraz warunkow finalow. Od `PKG-0007`
  obowiazuje regula pokrycia: wiersz bez cytatu z `FULL_STORY.md` jest zadaniem
  do napisania, nie zapisem stanu.
- Biblia dialogowa odroznia glosy i zawiera 18 scen niosacych glowne zwroty
  emocjonalne, w tym D-16, D-17 i D-18 dla przestrzeni 23, 34 i 39. W pliku
  jest 20 blokow, bo final D-15 ma trzy warianty A/B/C. Nie jest to jeszcze
  pelna lista linii implementacyjnych.
- Zdarzenie na Linii 4 ma jeden rachunek kanoniczny (D-020): dwanascie nazwisk
  na tablicy odrzuconego wariantu, jedenascioro przeniesionych, jedno utrzymane
  ocalenie. Wierzbicka nie wie, dlaczego utrzymal sie akurat Jakub.
- Przejscie przenosi adres, nie materie (D-021). Cialo i rzeczy Leny sa jej
  wlasne; zmienilo sie to, co swiat o niej twierdzi.
- Gra ma porazke wykonawcza i nie ma porazki narracyjnej (D-019). Uleglosc
  zatwierdza sie wylacznie na granicy sceny.
- Wierzbicka nie umiera w zadnym zakonczeniu (D-022).
- `VISUAL_DESIGN.md` definiuje materialna, informacyjna korekte zamiast
  dekoracyjnego glitchu, palete, sylwetki, kluczowe kadry i test pionowego
  wycinka.

### Wyniki audytu kanonu 0.2 (2026-08-15)

Audyt wykonala sesja bez udzialu w tworzeniu materialu. To jest teraz jedyny
mechanizm kontroli jakosci narracyjnej (R-016).

Rozstrzygniete pomiarem, nie opinia:

- **H-010a: MEASURED po `PKG-0008`.** Ponowny pomiar po przenumerowaniu wykazuje
  trzy zapowiedzi spelniajace wszystkie cztery warunki (sceny 01, 14, 22)
  oraz dwie wspierajace (02, 10). Granica: warunek sciezki obowiazkowej jest
  proxy dla „dostrzegalne", nie dowodem zauwazenia. Zauwazenie to H-010b,
  trwale bez dowodu.
- **H-011a: MEASURED po `PKG-0008`.** Ponowny audyt policzyl cztery sygnaly
  porownawcze i wykazal **0 sygnalow przewagi strukturalnej** dla A, B i C:
  Swiadectwo jest zawsze dostepne, A, B i C maja domkniecia relacji
  Jakub-Wierzbicka, D-14 konczy sie cisza po pytaniu, a trzy epilogi maja ten
  sam obojetny rejestr administracyjny. Regula zlamanego fioletu pozostaje
  swiadomie wizualna i nie wchodzi do licznika. To pomiar kontraktu, nie odbioru.

Naprawione w `PKG-0007` - siedem sprzecznosci twardych:

- los Wierzbickiej w finale C (D-022: nie umiera nigdzie);
- rachunek Linii 4 (D-020: 12 nazwisk, 11 przeniesionych, 1 ocalenie);
- wiek Jakuba: 33 lata, smierc w wieku 20 lat trzynascie lat wczesniej;
- wariant instrumentalny finalu B: obowiazuje D-15B, Marta zostaje i odmawia;
- ostatni obraz finalu A: telefon do Marty Kurek;
- ostatni obraz finalu C: tramwaj, dwa tory, zapisany wybor;
- zegar: usunieto „mniej niz pol sekundy", prolog trwa do 22:30.

Dodatkowo zapisano regule 11 w `NARRATIVE_BIBLE` 7 (D-021) i rozstrzygnieto
stan przegranej (D-019).

Naprawione w `PKG-0008`:

- Swiadectwo jest zawsze dostepne; brakujace polaczenia obnizaja stabilnosc
  sieci i sa widoczne w epilogu, bez punktacji dobra;
- koszt finalu C przeniesiono na Slad: jego obecność rozprasza sie
  nieodwracalnie po wezłach zamiast pozostac osobnym glosem;
- domknieto relacje Jakub-Wierzbicka w A i B, usunieto dwie repliki D-14 i
  zostawiono cisze po pytaniu Wierzbickiej;
- ujednolicono rejestr trzech epilogow i wykonano jednorazowe przenumerowanie
  43 przestrzeni wedlug D-023: akt I 10, akt II 11, akt III 11, akt IV 4;
- H-010a zmierzono ponownie jako MEASURED (01, 14, 22), a H-011a jako
  MEASURED z wynikiem 0 sygnalow przewagi strukturalnej.

Otwarte, przypisane do kolejnych pakietow:

- mechanika sygnaturowa ma jawne zastosowanie w okolo pieciu z 43 przestrzeni
  (H-002a) - `N0.2-D`;
- `RESEARCH_FOUNDATIONS.md` nie zawiera zadnego zrodla o pamieci, zalobie,
  anomii ani psychologii instytucji - czyli o temacie gry;
- `INSPIRATION_BOUNDARIES.md` zabezpiecza wylacznie przed Another World i nie
  wspomina o Severance ani Control;
- D-014: bramka kanonu w `tools/verify.ps1` - przyjeta, niezaimplementowana.

Pelna lista znalezisk z lokalizacjami i priorytetami P0/P1/P2 jest w raporcie
audytu; pakiety N0.2-C i dalsze realizuja ja po kolei.

## Ostatnia swieza weryfikacja

Komenda:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Potwierdzony wynik finalnej weryfikacji PKG-0008 po synchronizacji dokumentacji:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Kontrakt dokumentacji obejmuje teraz `ADR-003` oraz aktualny naglowek epilogu
`### 43. Napisy i epilog systemowy`. Bramka nadal sprawdza istnienie plikow i
zachowanie grayboxu; **nie sprawdza spojnosci kanonu narracyjnego**. Zadnej z
siedmiu sprzecznosci naprawionych w `PKG-0007` ani sygnalow H-011a nie wykryla i
nie wykrywalaby ich ponownie. D-014 jest przyjete i czeka na osobny pakiet
techniczny.

Pakiet zmienia wylacznie dokumenty narracyjne, rejestry i kontrakt tekstowy
bramki; nie zmienia scen Godota, grafiki ani runtime, wiec nie tworzy nowego
renderu gry. Ostatni render bazowego Movement Lab pozostaje technicznym
dowodem 01B, nie wizualizacja nowego kierunku artystycznego.

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
- H-011a jest zmierzone po `N0.2-C`; H-010a zmierzone ponownie po
  przenumerowaniu. Nadal otwarte sa H-002a, H-009a i H-012.

### Nadal niewykonane

- Nie wybrano profilu ruchu i nie otwarto Prototype 02.
- Zakotwiczenie i Uleglosc nadal nie istnieja w kodzie.
- 43 przestrzenie i 2-3 godziny nie maja budzetu produkcyjnego; liczba 43 nadal
  miesza pomieszczenia z beatami i nie zostala rozdzielona.
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
- H-011a ma wynik `MEASURED: 0` po PKG-0008. To audyt kontraktu, nie dowod
  odbioru; H-011b, podobnie jak pozostale hipotezy odbiorcze, nadal nie ma
  dowodu, bo slepy test nie odbedzie sie (D-012).
- Alias `godot.exe` nie zawsze przekazuje PowerShellowi kod wyjscia;
  `tools/verify.ps1` odnajduje wariant konsolowy i sprawdza tekst bledow.

## Nastepny pakiet

`N0.2-D: Audyt zastosowan mechaniki sygnaturowej`

Cel: zmierzyc H-002a przez policzenie 43 przestrzeni z jawnym, roznym
zastosowaniem Zakotwiczenia i Uleglosci. Audyt ma rozdzielic zastosowanie
dramaturgiczne od konkretnego, potencjalnie prototypowalnego zastosowania; nie
wolno udawac, ze opis sceny jest dowodem dzialania mechaniki.

Pakiet nie dotyka runtime, nie otwiera Prototype 02, nie tworzy assetow i nie
prowadzi testu odbiorczego. Wynik ma miec metode, liste scen, liczbe oraz
status H-002a `MEASURED` albo `REFUTED`, bez `SUPPORTED`.

Pelny zakres i warunki sa w `NEXT_SESSION_PROMPT.md`.

Rownolegle otwarte, niezalezne:

- decyzja o profilu ruchu i bramka P1;
- implementacja D-014, czyli bramki spojnosci kanonu w `tools/verify.ps1`;
- braki researchu: pamiec i zaloba w `RESEARCH_FOUNDATIONS.md`, Severance i
  Control w `INSPIRATION_BOUNDARIES.md`;
- kopia projektu poza dysk roboczy.

## Punkt przekazania

Nowa sesja zaczyna od swiezej weryfikacji, czyta `AGENTS.md`, `INDEX.md`, ten
plik i `NEXT_SESSION_PROMPT.md`, a nastepnie cztery dokumenty narracyjne.

Nie prowadzi czytania stolikowego ani playtestu - te nie odbeda sie i nie wolno
ich symulowac. Nie oznacza zadnej hipotezy jako `SUPPORTED`. Hipoteze MIERZALNA
wolno zamknac wylacznie statusem `MEASURED` albo `REFUTED`, z podana metoda i
liczba.
