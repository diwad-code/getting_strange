# PKG-0190 — Audyt i wybór miejsc dla cinematic vignettes

Status: audyt zamknięty, poprzedza implementację.
Data: 2026-09-04. Autor: Lead Programmer / Art Director (sesja PKG-0190).

## 0. Zakres i metoda

Ten dokument audytuje **całą aktywną trasę** 01–18 → 42A/B/C → 43 pod kątem
umieszczenia 3–5 krótkich, ilustrowanych sekwencji „cinematic vignette" (2–5
niemal statycznych kadrów), zgodnie z promptem właściciela. Audyt opiera się
na **świeżym odczycie kodu stacji** (`scripts/levels/station_*.gd`), nie na
tabelach z `docs/narrative/FULL_STORY.md` / `CONTINUITY_TRACKER.md` — te
dokumenty używają miejscami **starej numeracji legacy** (np. `FULL_STORY.md`
nazywa stację rozpoznania „21", podczas gdy w aktywnym kodzie i
`CAMPAIGN_MAP.md` to jest stacja **13**). Zgodnie z hierarchią prawdy
`docs/INDEX.md` (runtime/kod > dokumentacja), tam gdzie fakty się rozjeżdżają,
audyt cytuje dokładnie to, co robi kod stacji dzisiaj, i nazywa rozjazd
osobno w §4.

Cold open (`scripts/ui/cold_open.gd`, `docs/rebuild/COLD_OPEN_SPEC.md`) jest
przeczytany w całości i **wykluczony z wyboru** — to już ukończony, osobny
kontrakt (tramwaj, dłonie z czujnikiem, luka pomiaru, wiadomość Marty). Żadna
wybrana sekwencja nie duplikuje jego czterech nośników faktów.

## 1. Tabela kandydatów — cała trasa

Legenda: **W** = zmiana wiedzy, **R** = koszt/zmiana relacyjna, **S** =
istniejący sygnał GDScript gotowy do podpięcia bez nowej kolizji/interakcji.

| Stacja | Trigger (funkcja / sygnał w kodzie) | Fakt pokazany przed tekstem | W/R przed → po | Ryzyko spoilera | Dlaczego zwykły kadr gameplayu nie wystarczy | Werdykt |
|---|---|---|---|---|---|---|
| 01 | (cold open warstwa B, `Station01`) | luka pomiaru, wiadomość Marty | już pokryte cold openem | brak (poza zakresem) | pokryte | REJECT — duplikat cold open |
| 02–07 | brak silnego pojedynczego zdarzenia — trasa dojścia | normalność z narastającym niepokojem | W: baseline → pierwsze rozbieżności | niskie | istniejące CRT-dialogi już niosą fakt liniowo | REJECT — brak jednego ostrego zdarzenia |
| 08 | `unlock_apartment_fourteen()` → sygnał `apartment_fourteen_unlocked()` | własny klucz Leny otwiera drzwi 14 bez oporu; sąsiadka już potwierdziła, że Marta czeka | W: klucz pasuje fizycznie → próg obcego adresu jest przekroczalny. R: zapowiedź spotkania z Martą | niskie — nie mówi „inny świat", tylko fizyczny fakt zamka | istniejący `_draw()` to abstrakcyjne płaszczyzny wektorowe; nie ma ujęcia ręki na klamce/zamku w świetle progu | **SELECT — VIG-01 „Próg"** |
| 09 | `observe_relation_photo()` / `respect_private_boundary()` (brak dedykowanego sygnału, tylko `clue_inspected`) | fotografia Leny i Marty razem; „dwa życia" | W: materialny ślad wspólnego życia | niskie | częściowo — temat nakłada się na 11 | REJECT — patrz §2.1 |
| 10 | `test_key_without_claiming_home()` → sygnał `key_trial_completed()`; `commit_cautious_entry()` → sygnał `cautious_entry_committed()` | zużycie klucza pasuje do obcej historii; Lena zdejmuje torbę przed progiem, nie przywłaszcza mieszkania | W: `local_address_confirmed` | niskie | temat progu już mocniej i pojedynczo niesie VIG-01 na stacji 08 | REJECT — redundancja z VIG-01, patrz §2.2 |
| 11 | `compare_private_material()` → sygnał `private_material_compared()` | trzy niezależne prywatne źródła (zdjęcie, zużycie sprzętu, ustawienie czytnika) zgodnie wskazują na to samo ciało | W: „życie pasuje do ciała, nie do pamięci" | niskie | tekst guidance i trzy osobne interakcje już niosą fakt proceduralnie — mocny kandydat, ale przegrywa priorytetem do budżetu, patrz §2.1 | REJECT (audytowany poważnie) — patrz §2.1 |
| 12 | `meet_jakub()` (brak dedykowanego sygnału, tylko `clue_inspected` id=`jakub_meeting`) | żywy Jakub, odmowa pokazania blizny | W: `jakub_met_as_person`-odpowiednik. R: granica cielesna Jakuba | niskie | Jakub ma już dedykowany portret CRT (`panel_portrait__jakub.png`, PKG-0187) i mocny dialog — patrz §2.3 | REJECT — patrz §2.3 |
| 13 | `synthesize_world_difference()` (dodaję 1-liniowy sygnał `world_difference_synthesized()` w miejscu zapisu faktu — patrz §5.2) | trzy rodziny dowodu (czytnik/próbka, rejestry instytucji, Jakub) syntetyzują się w jeden wniosek | W: `world_recognized = true` — **centralny punkt zwrotny całej gry** | średnie — musi respektować zakaz ujawnień przed 13 (już spełniony, bo to JEST stacja 13) | `_draw()` stacji 13 to bardzo prosty pokój biurowy; nie ma ujęcia zbliżenia na reakcję Leny w momencie syntezy | **SELECT — VIG-02 „Synteza"** |
| 14 | `dead_circuit_trial_completed()` | Anchor/Yield nazwane dopiero po wykonaniu obu zachowań na martwym obwodzie | W: mechanika ma teraz nazwę | niskie (nazwanie następuje już po fakcie) | to lekcja mechaniki, nie relacyjny/wiedzowy beat o osobach; guidance-tekst już to niesie | REJECT — patrz §2.4 |
| 15 | `read_abort_note()` poprzedzone `_apply_response()` ustawiającym `local_lena_signal_confirmed` → sygnał `mutual_signal_test_completed()` | trzeci impuls z celowym błędem wraca skorygowany selektywnie — to nie jest nagranie, tylko żywa, celowa odpowiedź osoby po drugiej stronie | W: `local_lena_signal_confirmed`, `local_lena_intent_found` — **pierwsze potwierdzenie, że miejscowa Lena istnieje i odpowiada świadomie** | średnie — nie nazywa kim jest „ona", tylko że odpowiada świadomie (dozwolone, bo to już po 13) | ekran przyrządu w `_draw()` jest wektorowym diagramem; nie ma ujęcia napięcia/ulgi Leny w momencie odczytu korekty | **SELECT — VIG-03 „Sygnał"** |
| 16 | `_commit_cost()` → sygnał `small_cost_manifested()`; `confirm_home_echo()` → sygnał `home_echo_verified()` | wybór małego kosztu (wspomnienie Marty albo sekunda próbki) i potwierdzenie echa domu | W/R: koszt staje się faktem | niskie | realny kandydat, ale dubluje temat, który VIG-FINALE pokazuje jako właściwy skutek — patrz §2.5 | REJECT — patrz §2.5 |
| 17 | `read_cost_ledger()`, `reject_adaptation_offer()`, `_commit_consent()` → sygnał `jakub_consent_scope_recorded()` | rejestr par kosztów UCP; Jakub ustala jawny zakres zgody (pełna/ograniczona/odmowa) | W/R: `jakub_consent_state` | niskie | scena jest administracyjna (hala, lada, terminal); emocjonalny ciężar zgody Jakuba już niosą trzy odrębne, w pełni napisane linie dialogowe w kodzie (`_commit_consent()`) | REJECT — dialog już wystarcza, temat instytucjonalny nie wizualny | 
| 18 | `_commit_method()` → sygnał `method_committed(method_id)` | trzy prognozy zestawione z zakresem zgody Jakuba; prawda przekazana Marcie; fizyczne zatwierdzenie jednej z trzech metod | W: `method_committed` — **rozwidlenie determinujące finał**. R: `marta_truth_state` | niskie — nie zdradza SKUTKU metody, tylko sam akt wyboru | tablica trzech prognoz i słupek zatwierdzenia w `_draw()` są czytelne mechanicznie, ale akt wyboru — najcięższa decyzja gracza w grze — nie ma żadnego wyróżnionego ujęcia | **SELECT — VIG-04 „Zatwierdzenie"** |
| 42A | `read_household_consequence()` → sygnał `household_consequence_read()` | wymuszony powrót: puste krzesło, zapieczętowany próg, miejscowa Lena zamknięta między adresami | W/R: `ending_family=force_home`, `ending_stability` | brak — to już efekt wybranej ścieżki, gracz sam ją wybrał na 18 | `_draw()` już pokazuje symboliczne płaszczyzny (rygiel, pieczęć, stół), ale bez twarzy/reakcji — SELECT wzmacnia, nie zastępuje | **SELECT — część VIG-FINALE (wariant A)** |
| 42B | `read_household_consequence()` → sygnał `household_consequence_read()` | zamknięcie przepływu Równi; miejscowa Lena odzyskana w ciele; przybyła Lena poza rejestrem | W/R: `ending_family=close_equal_recover_local` | brak | jw. | **SELECT — część VIG-FINALE (wariant B)** |
| 42C | `read_household_consequence()` → sygnał `household_consequence_read()` | wzajemne przejście otwarte; trwały przeciek pamięci; obie Leny odpowiadają przed własnym domem | W/R: `ending_family=mutual_passage` | brak | jw. | **SELECT — część VIG-FINALE (wariant C)** |
| 43 | epilog 6 podmiotów, bez narratora | konsekwencja, nie kosmologia | brak nowej flagi | brak | epilog już jest tekstowo-dokumentalny z premedytacji (spis, nie scena) — dodanie ilustrowanej winiety zmieniłoby jego rejestr stylistyczny wbrew zamierzeniu | REJECT — epilog celowo nie jest sceną |

## 2. Uzasadnienia odrzuceń kandydatów wymienionych wprost w brief

### 2.1 „Pierwsze wiarygodne ślady cudzej biografii" (stacje 09/11) — REJECT

Stacja 11 (`compare_private_material()`) jest najsilniejszym kandydatem
tematycznym: trzy niezależne źródła (fotografia, zużycie sprzętu, ustawienie
czytnika) syntetyzują się w „życie pasuje do ciała, nie do pamięci". To
realny, dobrze udokumentowany beat. Odrzucam go z budżetu z trzech powodów:

1. **Redundancja struktury**: mechanika stacji 11 (trzy osobne interakcje →
   jedna synteza) jest strukturalnie identyczna ze stacją 13, którą już
   wybieram (VIG-02). Dwie „syntezy trzech źródeł" pod rząd (stacje 11 i 13)
   rozcieńczają uderzenie tej figury zamiast je wzmacniać.
2. **Guidance-tekst już niesie fakt** dobrze i literalnie
   (`s11_lost_relationship_hypothesis`, `s11_private_material`).
3. **Numeracja stacji 09 jest niepewna** — komentarz w kodzie (`## Klatka
   zachowuje własną tabliczkę piętra`) nie zgadza się z faktyczną zawartością
   `_draw()` (wnętrze mieszkania z sofą i stołem, nie klatka schodowa). Nie
   inwestuję assetów gen-ai w lokalizację, której tożsamość w trasie jest
   dokumentacyjnie niespójna, dopóki przyszły pakiet tego nie wyjaśni.

### 2.2 „Próg obcego adresu" — wybrany na stacji 08, nie 10 — uzasadnienie

Stacje 08 i 10 obie dotyczą fizycznego progu drzwi 14. Wybieram **08**
(`unlock_apartment_fourteen`), bo to tam pada ostatnie słowo sąsiadki („Marta
wróciła... czeka pod czternastką") **tuż przed** otwarciem drzwi kluczem —
kompletny łańcuch przyczyna→prógu w jednej stacji. Stacja 10 powtarza ten sam
temat (`test_key_without_claiming_home`, `commit_cautious_entry`) już
**wewnątrz** mieszkania — to konsekwencja przekroczenia progu, nie sam próg.
Jedna winieta na temat progu wystarcza; druga byłaby echem.

### 2.3 „Spotkania Marty/Jakuba" — REJECT obu jako osobnych sekwencji

- **Marta**: nie potrzebuje osobnej winiety — VIG-01 (próg stacji 08) *jest*
  fabularnie momentem "Marta czeka po drugiej stronie drzwi"; osobna
  sekwencja na stacji 10 duplikowałaby to samo emocjonalne uderzenie.
- **Jakub**: `meet_jakub()` na stacji 12 nie ma dedykowanego sygnału (tylko
  ogólny `clue_inspected`), ma cienki tekst guidance i **już ma** dedykowany
  capture portretu CRT z PKG-0187 (`reports/pkg_0187/visual/panel_portrait__jakub.png`)
  oraz w pełni napisaną linię odmowy w dialogu. Krańcowa wartość dodana
  ilustrowanej winiety jest tu niższa niż w wybranych czterech miejscach.
  Rekomendacja: kandydat dla przyszłego pakietu, nie tego.

### 2.4 Nazwanie Anchor/Yield (stacja 14) — REJECT

To lekcja mechaniki (dwa zachowania na martwym obwodzie), nie zmiana wiedzy o
osobie ani koszt relacyjny — prompt wymaga wzmacniania „zmiany wiedzy,
relacji lub kosztu", nie mechaniki gry. Guidance-beat `s14_method_named` już
werbalizuje moment nazwania w jednym zdaniu. Ryzykowne też z uwagi na twardy
zakaz: Anchor/Yield mogą być nazwane dopiero po wykonaniu — trzymanie się z
dala od ilustrowania tego momentu unika jakiejkolwiek pokusy pokazania
mechaniki wizualnie przed czasem.

### 2.5 Mały koszt / echo domu (stacja 16) — REJECT

`small_cost_manifested` i `home_echo_verified` to prawdziwy, wzruszający
beat (Marta traci szczegół wspomnienia ALBO próbka traci sekundę). Odrzucam
z budżetu, bo **VIG-FINALE pokazuje dokładnie ten sam temat w postaci
płatnej, ostatecznej konsekwencji** (pusty kubek, puste krzesło, przeciek
pamięci) — winieta na stacji 16 byłaby zapowiedzią czegoś, co i tak dostanie
mocniejszy, ostateczny obraz w finale. Jedno mocne uderzenie > dwa słabsze.

## 3. Wybrane sekwencje (5 slotów: 4 pojedyncze + 1 rodzina finałowa)

| ID | Stacja(e) | Trigger | Fakt wzmacniany | Nie jest jedynym nośnikiem, bo... |
|---|---|---|---|---|
| VIG-01 „Próg" | 08 | sygnał `apartment_fourteen_unlocked` | `p7.foreign_daily_life.cautious_entry_committed`, obecność Marty za progiem | CRTDialogueBox już wypowiedział słowa sąsiadki i Leny; fakt `local_address_confirmed`/`cautious_entry_committed` zapisany niezależnie od winiety |
| VIG-02 „Synteza" | 13 | nowy sygnał `world_difference_synthesized` (emitowany w `synthesize_world_difference()`) | `world_recognized` | flaga zapisana przez `_record()` w tej samej funkcji, niezależnie od tego, czy winieta się wyrenderuje; skip nie zmienia zapisu |
| VIG-03 „Sygnał" | 15 | sygnał `mutual_signal_test_completed` | `local_lena_signal_confirmed`, `local_lena_intent_found` | flagi zapisane w `_apply_response()`/`read_abort_note()` przed emisją sygnału |
| VIG-04 „Zatwierdzenie" | 18 | sygnał `method_committed` | `method_committed`, `marta_truth_state` | flagi zapisane w `_commit_method()` przed `emit()`; guidance-beat `s18_method_recorded` też niesie fakt tekstowo |
| VIG-FINALE „Poranek" (A/B/C) | 42A, 42B, 42C | wspólny sygnał `household_consequence_read` na każdej z trzech stacji | `ending_family`, `ending_stability`, `household_consequence` | `_record()` w `read_household_consequence()` zapisuje słownik konsekwencji niezależnie od winiety; istniejący `_draw()` stacji już koduje stan (pusty stołek/pieczęć/dwa czytniki) bez tekstu |

Wszystkie pięć spełnia: wynika z działania gracza (nie z samego wejścia do
sceny), pokazuje zdarzenie przed tekstem, wzmacnia istniejącą zmianę (nie
dopowiada kosmologii), jest pomijalna jednym wejściem `interact`/`ui_accept`
bez zmiany zapisanych flag, działa w reduced motion przez cięcia klatek, i
nie jest jedynym nośnikiem żadnej krytycznej flagi (patrz kolumna ostatnia).

## 4. Rozjazd dokumentacja↔kod odnotowany podczas audytu

- `docs/narrative/CONTINUITY_TRACKER.md`/`FULL_STORY.md` opisują flagi
  `marta_relationship_disclosed`, `marta_memories_conflict`,
  `marta_boundary_accepted` jako należące do „stacji 10" narracyjnie — w
  faktycznym kodzie `marta_relationship_disclosed` jest zapisywany w
  **`station_08.gd`** (`speak_with_neighbour()`), nie w `station_10.gd`.
  `station_10.gd` operuje na osobnym zestawie kluczy `p9.mystery.marta.*`.
  To nie blokuje audytu (oba miejsca istnieją i są grywalne), ale oznacza, że
  przyszłe pakiety canonical-fact (odłożony zakres dawnego „PKG-0190") muszą
  zweryfikować to rozwarstwienie przed dopisywaniem nowych writerów.
- `conflicting_documents_found` jest zapisywany w **`station_13.gd`**
  (`compare_document_versions()`), nie na stacji 09, jak sugerowałaby stara
  tabela narracyjna. Odnotowane, nie naprawiane w tym pakiecie (poza
  zakresem cinematic).

Żadna z tych rozbieżności nie wpływa na wybrane triggery VIG-01..04/FINALE —
wszystkie oparto bezpośrednio o istniejące sygnały GDScript przeczytane z
kodu, nie o nazwy stacji z dokumentacji.

## 5. Kontrakt techniczny (skrót; pełne dane w manifeście generacji i w kodzie)

### 5.1 Zasada ogólna

Mały, data-driven system pod `scenes/cinematics/` i `scripts/cinematics/`.
Jedna reużywalna scena `CinematicVignette.tscn` + skrypt `cinematic_vignette.gd`
renderuje N klatek (pełnoekranowa plansza gen-ai 640×360 przez
`draw_texture_rect`, jak `ColdOpen._draw_shot_work()`), z podpisem przez
`CrispDiegeticText` (wzorem `ColdOpen._spawn_label`), cięciami między
klatkami (bez fade), i jest sterowana z osobnego zasobu danych
`CinematicManifest` (Resource, jeden wpis na winietę: id, station_id, lista
ścieżek klatek, lista podpisów, flaga „seen").

### 5.2 Triggery — minimalna, jednoliniowa ingerencja w stacje

- Stacje 08, 15, 18 i 42A/B/C: żadnej zmiany logiki — podpinam się pod
  **istniejące** sygnały (`apartment_fourteen_unlocked`,
  `mutual_signal_test_completed`, `method_committed`,
  `household_consequence_read`) z nowego węzła `CinematicTrigger` dodanego
  jako dziecko sceny stacji (nie koliduje z żadnym colliderem/interakcją).
- Stacja 13: brak dedykowanego sygnału dla `synthesize_world_difference()`.
  Dodaję **jedną linię** — `signal world_difference_synthesized()` +
  `world_difference_synthesized.emit()` tuż po `_record(&"world_recognized", true)`
  w `station_13.gd`. To nie jest nowa interakcja, kolizja ani blokada wyjścia
  — czysto obserwacyjny sygnał na już istniejącym wywołaniu.

### 5.3 Zapis stanu „obejrzano"

Bez migracji `SAVE_SCHEMA_VERSION`. Wzorem `cold_open_seen` (settings-save,
`GameStateManager.mark_cold_open_seen()`), dodaję analogiczny, jeden wspólny
słownik `cinematics_seen: Dictionary[StringName, bool]` do
`GameStateManager` z metodami `is_cinematic_seen(id)` /
`mark_cinematic_seen(id, persist=true)` — jeden nowy pattern, pięć kluczy, nie
pięć nowych pól.

### 5.4 Skip i reduced motion

- Skip: dostępny **od pierwszego wyświetlenia** (mocniejszy kontrakt niż
  cold open, zgodnie z wymogiem promptu „zawsze pomijalna"), jeden wspólny
  input (`interact`/`ui_accept`/dowolny przycisk), analogicznie do
  `ColdOpen._unhandled_input`. Skip nie cofa ani nie zmienia żadnej flagi
  fabularnej — te są już zapisane przez stację przed emisją sygnału (§5.2).
- Reduced motion: skrócony czas trwania klatek (tabela `FRAME_SECONDS` vs
  `FRAME_SECONDS_REDUCED`, wzorem `ColdOpen.SHOT_SECONDS`), bez kamery
  shake/pan — czysta zmiana cięcia, treść klatek bez zmian.

## 6. Ograniczenia dowodowe tego audytu

- Audyt opiera się na statycznym czytaniu `scripts/levels/station_*.gd`, nie
  na pełnym świeżym przebiegu runtime całej trasy 01–43 w tej sesji (to
  nastąpi w §7 raportu implementacji, z Windows capture przed/po każdym
  triggerze).
- Rozjazd dokumentacja↔kod (§4) jest odnotowany, nie naprawiony — poza
  zakresem tego pakietu.
- Stacje 02–07, 09, 11 REJECT nie oznacza że są pozbawione wartości
  narracyjnej — oznacza tylko, że nie mieszczą się w budżecie 3–5 sekwencji
  tego pakietu przy zachowaniu jakości i braku redundancji.
