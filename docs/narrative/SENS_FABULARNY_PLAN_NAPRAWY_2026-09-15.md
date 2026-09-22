# Plan naprawy sensu fabularnego

Data: 2026-09-15
Podstawa: `docs/narrative/SENS_FABULARNY_RAPORT_2026-09-15.md`
Adresat: modele wykonawcze (kod, scena, tekst). Ten dokument **nie wdraża** zmian — mówi, co ma powstać i po czym poznać, że powstało.
Trasa: 01–18 → 42A/B/C → 43. Stacje 19–41 nie ruszać.

> **Dla agenta wykonawczego:** wdrażaj pakiet po pakiecie. Nie przepisuj fabuły. Nie dodawaj adresów. Nie dodawaj przeszkód zręcznościowych. Po każdym pakiecie odczytaj znowu raport §2 (test filmu) dla ruszonego odcinka.

---

## 0. Zasady, których nie wolno złamać

1. **Nie piszemy nowej historii.** Kręgosłup z raportu §1 zostaje: luka trzech sekund, adres 12/14, Marta wie wcześniej, Jakub żyje, miejscowa zniknęła o 20:40, trzy metody, epilog czyta decyzje.
2. **Nie dodajemy stacji.** Budżet to istniejące 01–18, trzy finały i epilog. Cięcia filmowe robi się progiem, spawnem, jedną kwestią otwarcia i rodziną progu — nie nowym numerem.
3. **Nie dodajemy arcade.** Żadnych platform, kolców, wrogów, timing-jump. Jeśli coś fizycznego zostaje, musi dać się powiedzieć zdaniem o świecie bez słowa „gracz”.
4. **Nie ruszamy Aktu I (zimne otwarcie + 01–08), chyba że pakiet A znajdzie sprzeczność z 09+.** Ten odcinek już jest miastem.
5. **Dialogi, które działają, dopisujemy ogniwem, nie wymieniamy.** Warstwa `scripts/levels/creative_scene_lines.gd` i kwestie CRT 01–08 są nośnikiem, nie problemem. Problem jest w *gdzie* się je mówi i *czym* się wychodzi.
6. **Jeden writer na fakt.** Nie dublować `world_recognized`, `method_committed`, `marta_truth_state`, `jakub_consent_state`.
7. **Język polski w ustach postaci.** Bez tezy autorskiej, bez „Równi” zanim świat dostanie imię, bez HINT-ów w głosie Leny.
8. **Projekt nie ma gita.** Każdy skończony pakiet zapisuje się na dysku i opisuje w `docs/CURRENT_STATE.md` / `docs/SESSION_LOG.md` / `docs/NEXT_SESSION_PROMPT.md` według `docs/WORKFLOW.md`. Tego raportu nie nadpisywać.
9. **Jeden pakiet = jedna sesja = prompt na następną.** Sesja wdraża **dokładnie jeden** pakiet z kolejki `A → C → B → D → E`. Nie zaczyna kolejnego w tym samym przebiegu, nawet gdy zostaje kontekst. Pakiet nie jest `DONE`, dopóki sesja nie zapisze w `docs/NEXT_SESSION_PROMPT.md` samodzielnego promptu dla **nowej** sesji na **następny** pakiet z kolejki (albo jawne „kolejka sensu wyczerpana”, gdy E padnie). Prompt musi nazwać pakiet, pliki, zakazy i kryteria — nie „kontynuuj plan”.

### Hierarchia prawdy przy sporze

Runtime (to, co pada i to, co stoi w scenie) > ten plan > komentarz w nagłówku stacji > cokolwiek w `docs/rebuild/` i starych audytach.

### Definicja sukcesu całego planu

Po naprawie da się opowiedzieć przejście 01→43 jako film: każde wyjście w prawo ma zdanie o świecie („wychodzę na klatkę”, „schodzę włazem”, „wracam na Sadową”), a kadr, do którego się wchodzi, jest tym miejscem, nie następnym numerem. Historia z raportu §1 nie zmienia się. Donice klatek nie stoją w salonach.

---

## Mapa plików (wspólna)

| Plik | Rola |
|---|---|
| `scripts/core/game_state_manager.gd` | Routing, `arrival_side_for`, komplet stacji |
| `scripts/environment/threshold_binder.gd` | Rodzina progu (DOOR/VEHICLE/HATCH) i ciało blokujące |
| `scripts/environment/threshold_zone.gd` | Sam próg |
| `scripts/campaign/gap_ledger.gd` | Luki: flaga, close_fact, myśl Leny |
| `scripts/levels/creative_scene_lines.gd` | Dialogi 09–18 i 42 |
| `scripts/levels/station_XX.gd` | Czasowniki, otwarcia, `_draw`, duchy P7 |
| `scenes/levels/station_XX.tscn` | Geometria, `opening_line`, NPC, rekwizyty |
| `scripts/cinematics/cinematic_catalog.gd` | Winiety — nie ruszać klatek, chyba że podpis kłamie miejsce |

---

## Pakiet A — Duchy w pokojach (najpierw, bo kłamią kadr)

**Cel:** każde pomieszczenie zawiera tylko przedmioty tego pomieszczenia. Gracz nie pcha donicy z klatki w salonie i nie omija komody korytarzowej przy ladzie UCP.

**Po czym poznać, że skończone:** da się przejść 09, 11 i 12, nie napotykając obiektu, którego nie da się nazwać zdaniem o *tym* miejscu. Etykiety diegetyczne (`MIESZKANIE 14 // SALON` itd.) zgadzają się z bryłą.

### A1. Stacja 09 — salon bez klatki

**Pliki:** `scripts/levels/station_09.gd`, `scenes/levels/station_09.tscn`

**Stan teraz:**
- Tekst i `_draw` mówią: salon m. 14, sofa, stół, dwa nakrycia, zamknięta sypialnia.
- W drzewie: `Geometry/StairwellPlanter` na `(248, 287)`, collider, `_physics_process` pcha donicę, `PLANTER_CLEAR_X = 300`, `ask_neighbour_without_leading()` wymaga `is_passage_clear`.
- Trasa gracza: tryptyk `two_lives → relation_photo → private_boundary`, wyjście przez `respect_private_boundary()`.

**Stan docelowy:**
- Donica nie istnieje jako ciało na drodze. Albo znika ze sceny, albo zostaje jako doniczka na komodzie **bez** colliders / pchania / `PLANTER_CLEAR_X`.
- `ask_neighbour_without_leading`, `observe_floor_record`, `apply_planter_setback` mogą zostać callable dla starych testów, ale **nie są na drodze kampanii** i nie blokują progu.
- Próg 09 otwiera się wyłącznie po `private_boundary` (już tak jest) i nic fizycznego z klatki nie stoi przed nim.

**Nie robić:** nowej sąsiadki w salonie (sąsiadka żyje w 08). Nie wnosić donicy „bo była”.

### A2. Stacja 11 — lada UCP bez komody z korytarza

**Pliki:** `scripts/levels/station_11.gd`, `scenes/levels/station_11.tscn`

**Stan teraz:**
- Otwarcie: „Przy ladzie leży czytnik kart. Wierzbicka czeka, aż podejdę.”
- Tryptyk: `identity_card → record_186_days → minimal_report`.
- W drzewie: `Geometry/HallwaySideboard` na `(408, 287)`, pchanie, `SIDEBOARD_CLEAR_X = 446`. Stare czasowniki fotografii/zużycia nadal w skrypcie.

**Stan docelowy:**
- Komoda nie blokuje drogi do progu. Albo usunięta, albo przemianowana na element lady (stały, bez pchania).
- Wierzbicka zostaje osobą przy ladzie.
- Wyjście po `request_minimal_report()` (już tak jest).

### A3. Stacja 12 — warsztat bez balkonu-wyjścia

**Pliki:** `scripts/levels/station_12.gd`, `scenes/levels/station_12.tscn`, `scripts/environment/threshold_binder.gd`

**Stan teraz:**
- Otwarcie: łącze, imadło, Jakub.
- Wyjście: `ThresholdBinder.spec_for("station_12")` ustawia `door: Geometry/BalconyDoor`. `_unlock_exit` gasi collider balkonu.
- Gracz „wraca do mieszkania” wychodząc *balkonem*.

**Stan docelowy:**
- Wyjście z warsztatu to drzwi serwisowe / brama warsztatu (rodzina DOOR), nie skrzydło balkonu.
- Jeśli `BalconyDoor` ma zostać w pliku dla testów, nie jest `blocking_body_path` progu i nie leży na drodze do prawej krawędzi.
- Kwestia wyjścia zostaje: „Wracam do mieszkania, do wspólnego stołu.”

**Binder:** w `spec_for` dla `station_12` zmienić `door` na realne drzwi warsztatu albo `""`, spójnie z tym, co stoi w `.tscn`.

### A4. Stacja 13 — stół bez szuflady-progu z poprzedniej epoki

**Pliki:** `scripts/levels/station_13.gd`, `scenes/levels/station_13.tscn`

**Stan teraz:** `DeskDrawer` nadal jeździ w `_process`, stare czasowniki dokumentów są callable.

**Stan docelowy:** szuflada nie jest bramką syntezy. Synteza zostaje na `marta_source → institution_source → synthesize`. Szuflada albo znika z drogi, albo jest szufladą stołu bez colliders blokujących.

### Weryfikacja pakietu A

- Przejście 08→09→10: salon czyta się jako salon (etykieta + bryła + zero donicy-przeszkody).
- Przejście 10→11: lada, Wierzbicka, zero komody-przeszkody.
- Przejście 12: wyjście nie nazywa się balkonem w geometrii.
- Testy, które wołają stare callable (`push_planter`, `inspect_private_photograph`, …) mają albo nadal przechodzić na callable, albo zostać zwężone do P9 — decyzja wykonawcy, ale **kampania nie zależy od starych flag**.

---

## Pakiet B — Cięcia, nie teleporty (geografia na istniejącej trasie)

**Cel:** każde wyjście w prawo da się powiedzieć zdaniem o świecie. Spawn i rodzina progu zgadzają się z tym zdaniem. Bez nowych numerów.

Narzędzia, których używać (już są w silniku):

- `GameStateManager.arrival_side_for(from, to)` — dziś tylko 12→13 i 17→18 wchodzą z prawej.
- `ThresholdBinder.spec_for` — rodzina DOOR / VEHICLE / HATCH.
- `opening_line` / `opening_line_2` w `.tscn`.
- Myśl Leny przy odblokowaniu wyjścia (`sXX_exit_*`).

**Nie budować mapy metroidvanii.** Zostaje linia 01–18. Zmieniamy *oznaczenie* przejścia, nie graf.

### B1. Tabela cięć (to jest specyfikacja, nie sugestia)

| Skok | Zdanie świata | Rodzina progu **wyjścia** (stacja źródłowa) | Spawn w celu | Kwestia, która musi paść |
|---|---|---|---|---|
| 10 → 11 | Wychodzę z mieszkania na noc, do UCP | DOOR, ale jako **wyjście z domu** (kurtka / klatka w kadrze 10 albo pierwsza linia 11) | lewa = wejście od ulicy/holu UCP | 11 już ma: Wierzbicka czeka. **Dopisać w 10 przy odblokowaniu:** jedno zdanie „wychodzę do UCP”, nie „idę w prawo”. |
| 11 → 12 | Idę do warsztatu z numeru w rejestrze | DOOR serwisowe tej samej instytucji **albo** cięcie | lewa = wejście warsztatu | 12 już ma łącze/imadło. W 11 po wyciągu: „numer warsztatu jest na stronie — idę tam.” |
| 12 → 13 | Wracam do mieszkania, do stołu | DOOR wyjścia z warsztatu na zewnątrz | **prawa** (już jest) | 12 już ma `s12_exit_back_home`. 13 już ma Martę i grafik. Zostawić. |
| 13 → 14 | Schodzę włazem serwisowym za klatką | **HATCH** na wyjściu z 13 | lewa = dół rozdzielni | 14 już wita: „Zeszłam włazem serwisowym za klatką schodową.” 13 już myśli o włazie. **Zsynchronizować próg 13 z tym zdaniem.** |
| 14 → 15 | Z mostu wzdłuż obwodu do pętli | HATCH (już 14) | lewa = komora | 15 już: „Schodzę do pętli.” Zostawić. |
| 15 → 16 | Wychodzę włazem w górę, poza obwód | HATCH (już 15) | lewa = analizator jako **pomieszczenie serwisowe** | 16 już: „Niosę odpowiedź do analizatora poza obwodem.” **Nazwać miejsce** w kadrze (np. „POMIAR / ANALIZA”, nie pusty pokój). |
| 16 → 17 | Idę do hali UCP, do rejestru par | DOOR | lewa = hala, **rymująca się z 11** (ta sama instytucja) | 16 już: `s16_exit_to_ledger`. 17 już: „Idę do rejestru par w hali UCP.” |
| 17 → 18 | Wracam na Sadową | DOOR | **prawa** (już jest) | 18 już: znana ulica, Marta przy oknie. Zostawić. |
| 18 → 42 | Noc → świt, metoda wykonana | DOOR, ale otwarcie 42 **mówi o nocy przy słupku** (42A/B/C już mają `opening_line_2`) | lewa albo próg mieszkania | Nie udawać, że spacerem weszło się z chodnika do stołu. |

### B2. Kod routingu

**Plik:** `scripts/core/game_state_manager.gd` — `arrival_side_for`

Rozważyć (tylko jeśli kadr tego wymaga; nie na siłę):

- 16→17 jako powrót do znanej instytucji? Raczej **lewa**, bo to pierwsze wejście *do hali* (11 była ladą, 17 jest halą). Nie mieszać z 17→18.
- Nie dodawać prawej strony do 10→11: UCP ma być wejściem od holu, nie powrotem.

Jedyna obowiązkowa zmiana spawnu: **żadna nowa**, jeśli B1 da się zamknąć rodziną progu i kwestią. Nie mnożyć wyjątków.

### B3. Binder: stacja 13 wychodzi włazem

**Plik:** `scripts/environment/threshold_binder.gd`

Teraz `station_13` jest w grupie DOOR z 07/08/09/10. Docelowo 13 wychodzi jako **HATCH** (jak 14/15), bo zdanie świata jest „schodzę włazem”.

09 i 10 zostają DOOR (pokój → pokój w tym samym mieszkaniu: salon → stół Marty). To jedyny skok 09→10, który jest geografią, nie cięciem.

### B4. Jedno zdanie mostu w 10 i 11

**Pliki:** `scripts/levels/station_10.gd` (`s10_exit_ucp_record`), `scenes/levels/station_10.tscn` / `station_11.tscn`

Dopisać / podmienić **jedną** myśl wyjścia w 10, żeby nazywała wyjście z domu, nie następną czynność przy stole. Propozycja głosu (wolno poprawić rytm, nie sens):

- 10, po granicy: „Zostawiam jej telefon. Wychodzę. Zapis pracy jest w UCP — nie w tym mieszkaniu.”
- 11, pierwsza linia może zostać. Jeśli trzeba mostu: „Nocny dyżur. Z klatki tu jest bliżej niż do stołu.”

Nie pisać „teleportuję się”. Nie pisać „Równia”.

### Weryfikacja pakietu B

Test filmu z raportu §2 dla 10–18: każde wyjście ma zdanie i kadr celu nie przeczy temu zdaniu. 13 wychodzi włazem, 14 wita włazem. 12 nie wychodzi balkonem.

---

## Pakiet C — Luki mówią o tej grze, nie o poprzedniej

**Cel:** `GapLedger` nazywa pominięcie, które gracz naprawdę pominął na trasie P9.

**Plik główny:** `scripts/campaign/gap_ledger.gd`

### C1. Podmienić flagi i myśli na czasowniki kampanii

| Luka | Teraz (źle) | Docelowo |
|---|---|---|
| `s09.floor_record_unread` | flaga `is_floor_record_observed` | flaga albo close_fact już `p9.mystery.home.trace` — **myśl** ma mówić o dwóch życiach / fotografii / sypialni, nie o „rekordzie piętra”. Flaga stacyjna: to, co P9 naprawdę stawia (`P9_BOUNDARY` / `is_exit_unlocked` po `respect_private_boundary`). |
| `s10.key_untried` | `is_key_trial_completed` | close_fact już `p9.mystery.marta.trace`. Flaga: po `accept_marta_boundary`. Myśl zostaje przy stole Marty (już prawie dobra) — **usunąć** mapowanie feedbacków `key_wear_required` / `key_trial_required` jako jedynej drogi tej luki. |
| `s11.photograph_unread` | `is_private_photograph_inspected` | close_fact już `p9.mystery.institution.trace`. Flaga: po `request_minimal_report`. Id luki **przemianować** albo zostawić id a zmienić myśl i flagę — myśl o wyciągu już jest, flaga o fotografii kłamie. Override `station_11\|passage_required` nie może wskazywać fotografii. |
| `s15.signal_unconfirmed` | flaga `is_local_signal_confirmed` (tej zmiennej nie ma; jest `is_signal_confirmed`) | ustawić flagę na `is_signal_confirmed` **albo** polegać wyłącznie na close_fact `local_lena_signal_confirmed` (ten jest zapisywany). Nie zostawiać martwej nazwy. |

`after_decision` zamyka lukę po `close_fact` — to już działa dla P9, **jeśli** kampania zapisuje te fakty. Pakiet C ma sprawić, że **odjazd bez P9-czynności** otwiera lukę o właściwej nazwie, a odjazd po P9-czynności nie otwiera luki o kluczu.

### C2. Feedback map

W `FEEDBACK_TO_GAP` i `STATION_FEEDBACK_OVERRIDES` usunąć albo przeciążyć dosłownie:

- `key_trial_required` na 11 nie może znaczyć „brak fotografii”, gdy 11 pyta o kartę.
- `passage_required` na 11 znika razem z komodą (pakiet A). Jeśli zostanie, nie mapuje na fotografię.

### Weryfikacja pakietu C

- Wyjście z 10 po pełnym tryptyku Marty **nie** otwiera luki o kluczu.
- Wyjście z 11 po wyciągu **nie** otwiera luki o fotografii.
- Wyjście z 10 *bez* granicy Marty otwiera lukę, której myśl jest o stole, i 11 nie przyjmie karty (już wymaga `p9.mystery.marta.trace` — to zostawić).

---

## Pakiet D — Słowa, które muszą być zarobione

**Cel:** żadne imię świata, żadna tożsamość sterowania, żadne miejsce w kwestii nie wychodzi znikąd.

### D1. „Równia”

**Nie ruszać** rejestru par w 17 (`cost_ledger_console`) w sensie faktu (para: stabilność tutaj / pogrzeb Jakuba tam). Ruszyć **pierwsze pojawienie nazwy**.

Opcje (wykonać jedną, nie obie):

- **A (zalecane):** w 17 Lena słyszy „Równia” *od rejestru* i w jednej kwestii rozumie, że to tutejsze imię tego miasta / tej ciągłości. Jedno zdanie, jej głosem, bez wykładu. Przykład kierunku: „Tym słowem podpisali to miejsce. Moje nie miało nazwy na papierze.”
- **B:** nie używać „Równi” aż do 42B, a w 17 mówić „ta ciągłość” / „ten zapis” / „to miasto”. Wtedy 42B musi dostać to samo słowo z 17 albo nie dostać go wcale.

Zabronione: zostawić pierwsze „Równia” jako oczywistość.

Pliki: `scripts/levels/creative_scene_lines.gd` (`cost_ledger_console`), ewentualnie myśl `s17_ledger_contact`, etykiety 42B (`flow_closure`, winieta „zamknięcie Równi” może zostać **jeśli** 17 już nazwało).

### D2. Wierzbicka: jedna osoba, dwa tryby

W 11 jest ciałem przy ladzie. W 17 jest głosem oferty.

**Stan docelowy:** 17 nie udaje, że to inna istota. Albo terminal z jej nazwiskiem („WIERZBICKA / ZAKRES”), albo ona jest w hali. Jedno zdanie Leny albo etykieta wystarczy. Nie wprowadzać Szymona (żyje tylko w 19–41).

Pliki: `station_17.tscn` (etykieta rekwizytu), `adaptation_offer_terminal` w `creative_scene_lines.gd`.

### D3. Analizator ma adres

16 nie musi być nową lokacją na mapie. Musi mieć **nazwę na ścianie** i hałas, który nie jest salą UCP ani mieszkaniem. Kierunek: pomieszczenie pomiaru przy rozdzielni / „poza obwodem, nad pętlą”.

Pliki: `scenes/levels/station_16.tscn` (`opening_line` może zostać), `_draw` w `station_16.gd`, ewentualnie crisp text.

### D4. Finał B — jedno miejsce na kwestię

**Pliki:** `scripts/levels/creative_scene_lines.gd` (`household_b_*`, `local_lena_recovered`), `scripts/levels/station_42b.gd` (`DIALOGUE_LINES`, `_draw`), `scenes/levels/station_42b.tscn`

**Zasada:** w jednym kadrze 42B gracz jest **albo** przybyłą Leną w progu m. 14 (miejscowa za matowym szkłem — to już rysuje `_draw_local_lena_recovered`), **albo** przybyłą na wiacie linii 03. Nie oboma w tych samych czterech liniach.

Zalecenie:

- Główna scena 42B = próg m. 14, Marta i miejscowa w środku, przybyła na zewnątrz. Kwestie `local_lena_recovered` zostają.
- Wiata linii 03 = wyłącznie wypłata `household_b_*` **jeśli** kadr się zmienia (inne `_draw` po odczycie progu) **albo** przenieść wiatę do epilogu 43B (tam już jest: „Na obcym przystanku Lena chowa czytnik”). Wtedy 42B nie mówi „jestem na wiacie”.

`DIALOGUE_LINES` rezerwy w 42B **nie może** składać mieszkania i wiaty w jednym bloku. Albo wyrównać do prezentera, albo nie używać.

`opening_line_2` („O świcie jestem przybyłą Leną, stoję w progu”) jest dobry. Nie psuć.

### D5. Finał C — przeciek Jakuba nie wnosi warsztatu do salonu

`memory_leak` może zostać (imadło, prosektorium, ta sama sekunda). Dostawa: echo / ekran czytnika / krótka wstawka, nie Jakub stojący w m. 14 jako NPC warsztatu.

`household_c_*` (kubek, półka, dwie Marty) zostaje w mieszkaniu.

Rezerwa `DIALOGUE_LINES` w 42C: nie sadzać „JAKUB przy imadle” jako czwartej kwestii salonu bez oznaczenia, że to przeciek.

### D6. Kto steruje

Na wejściu 42A/B/C `opening_line_2` już nazywa ciało. **Nie zmieniać** tej zasady. Dodać ją tam, gdzie 42B potem kłamie (D4). Epilog 43 nie steruje już ciałem metody — jest tablicą miasta.

### D7. Epilog: gałąź pusta nie kradnie tonu C

**Plik:** `scripts/levels/station_43.gd` — `DEFAULT_DIALOGUE_LINES` i gałąź `_`

Domyślna (unseeded) nie może brzmieć „w tej części budynku utrzymują się dwie kolejności”. Ma brzmieć jak brak zatwierdzenia: miasto bez metody, luka, nic nie podpisane. Gałęzie A/B/C zostają jak są (już się rozgałęziają i czytają prawdę/zgodę/koszt).

---

## Pakiet E — Mosty dialogowe (ogniwa, nie przepisywanie)

**Cel:** tam, gdzie historia już wie, a kadr milczy, dopisać **jedno ogniwo**. Nie wymieniać działających kwestii.

Źródło kwestii: `scripts/levels/creative_scene_lines.gd`, myśli w `station_*.gd`, `opening_line` w `.tscn`.

### E1. Lista ogniw (maksymalnie jedno na skok)

| Miejsce | Dopisać | Nie ruszać |
|---|---|---|
| 10, po `marta_boundary` | wyjście z domu do UCP (pakiet B4) | kubek, deszcz, telefon |
| 11, po `minimal_report` | „na wyciągu jest numer warsztatu” jeśli nie pada (sprawdzić `minimal_report` — już jest „kontakt do warsztatu”; jeśli pada, nie dublować) | 186 dni, Jakub w rejestrze |
| 13 `synthesize` | zostaje „to nie jest mój świat / gdzie jest ona” | — |
| 17 `cost_ledger_console` | zarobienie „Równi” (D1) | para pogrzeb / stabilność |
| 42B | rozdzielenie progu i wiaty (D4) | oddech, klucz, „co wiedziałaś przed testem” |
| 42C | oznaczenie przecieku (D5) | kubek, półka, odpowiedzialność obu |

### E2. Trzy sekundy — nie wykładać

Nie dodawać kwestii „aha, to te same trzy sekundy co na stanowisku”. Zostawić złożenie. Wolno **nie zagłuszać**: w 15 dopisek „przepraszam M. — 3 s.” zostaje.

### E3. Rezerwy `DIALOGUE_LINES` w 42A/B/C

Albo zrównać 1:1 z prezenterem (`creative_scene_lines`), albo oznaczyć w komentarzu „nie gra na kampanii” i usunąć sprzeczne linie (wiata, imadło). Nie trzymać kłamliwego bloku „na wszelki wypadek”.

---

## Kolejność wdrożenia

```
A (duchy) → C (luki) → B (cięcia) → D (słowa) → E (ogniwa)
```

Jedna sesja = jeden pakiet. Po `DONE` sesja **pisze prompt** do `docs/NEXT_SESSION_PROMPT.md` na następną pozycję tej kolejki i kończy. Nie skleja A+C ani B+D „bo zdąży”.

A pierwsze, bo C mapuje `passage_required` na komodę, której A ma nie być na drodze.
B wymaga A (inaczej „wychodzę włazem” przez donicę).
D i E po B, żeby nie pisać mostów do złych progów.

---

## Czego nie robić — lista zakazów dla wykonawcy

- Nie otwierać `docs/narrative/STORY_SENSE_*` ani innych audytów „dla inspiracji”. Ten plan jest wystarczający.
- Nie „naprawiać” Aktu I, bo jest najspójniejszy.
- Nie wciągać stacji 19–41 do trasy, nawet jeśli mają słowo „Równia”.
- Nie dodawać Szymona, doktora, komory wyboru z 41.
- Nie zamieniać 18 w trzy osobne adresy metod.
- Nie pisać minikodów platformowych przy włazie.
- Nie tłumaczyć graczowi metafizyki w HINT.
- Nie mnożyć flag. P9-fakty już istnieją; C je *czyta*, nie *dodaje trzeciego namespace’u*.
- Nie ruszać `CAMPAIGN_ROUTE` kolejności 01–18. Cięcie ≠ nowy węzeł.

---

## Kryteria odbioru (sens, nie test jednostkowy)

Wykonawca może dodać bramki, ale odbiór sensu jest taki:

1. **Test filmu 01–08:** bez zmian, nadal miasto.
2. **Test filmu 09–13:** salon, stół, (cięcie) UCP, warsztat, (cięcie) stół. Żadnego balkonu-wyjścia, żadnej donicy-klatki, żadnej komody-korytarza na drodze.
3. **Test filmu 13–16:** właz, rozdzielnia, pętla, analizator z nazwą.
4. **Test filmu 16–18:** hala UCP, powrót na Sadową z prawej, Marta w oknie.
5. **Test filmu 18–43:** noc przy słupku, świt w *jednym* miejscu na kwestię, epilog czyta decyzje, pusta gałąź nie udaje C.
6. **Luki:** pominięcie Marty nie nazywa się kluczem; pominięcie wyciągu nie nazywa się fotografią.
7. **„Równia”:** pierwsze użycie jest zrozumiałe z kontekstu 17 albo nie pada.
8. **Tożsamość:** w 42 gracz wie, którą Leną jest i w jakim adresie stoi, bez drugiej wypowiedzi z innego miasta w tym samym kadrze.

Automat: `pwsh -NoProfile -File .\tools\verify.ps1` po każdym pakiecie. Zieleń testów **nie** znaczy, że sens został naprawiony. Znaczy, że nie zepsuto kontraktów. Sens sprawdza się odczytem kwestii i geometrii jak w raporcie — albo kadrem.

---

## Szybka ściąga dla modelu, który wdraża jeden plik

| Jeśli ruszasz | Najpierw przeczytaj |
|---|---|
| `station_09.gd` / `.tscn` | Raport §2 akt mieszkania, plan A1 |
| `station_10.gd` | Raport §4 Marta wie wcześniej, plan B4 i C1 s10 |
| `station_11.gd` / `.tscn` | Plan A2, B1 10→11, C1 s11 |
| `station_12.gd` / `.tscn` / binder | Plan A3 |
| `station_13.gd` / binder | Plan B3, A4 |
| `gap_ledger.gd` | Plan C cały |
| `creative_scene_lines.gd` | Plan D i E; nie kasować działających par |
| `station_42b.gd` / lines `household_b_*` | Plan D4 |
| `station_42c.gd` / `memory_leak` | Plan D5 |
| `station_43.gd` DEFAULT | Plan D7 |
| `game_state_manager.gd` `arrival_side_for` | Plan B2 — ruszaj tylko z powodu kadru |

---

## Metryka, której nie wolno użyć

„Gra jest spójniejsza”, „lepszy flow”, „gracz zrozumie”. To hipotezy.

Wolno napisać: „w 13 próg jest HATCH, 14 wita włazem, donica nie ma colliders, luka s11 zamyka się po `p9.mystery.institution.trace`, 42B nie zawiera kwestii wiaty w kadrze progu.”
