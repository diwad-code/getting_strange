# Audyt przeszkód Aktu IIIc — Station 36..40 (PKG-0105)

Data: 2026-08-24. Zakres: wyłącznie Godot 4.7, Station 36..40. Audyt wykonano
na istniejących scenach i skryptach przed dodaniem warstwy Vector-Stage oraz
nowej geometrii fizycznej. Obowiązuje `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`:
żadnych platform do skakania, przeszkód rytmicznych ani nowych czasowników.

## Stan read-only przed pakietem

- Każda z pięciu scen ma tylko shell `Geometry/FloorMain`, `Ceiling`,
  `WallLeft` i `WallRight`; nie ma `AnimatableBody2D` ani dodatkowego
  `StaticBody2D` w geometrii.
- Każda scena ma `AirlockZone` z prostokątem `50×70` oraz sygnał
  `level_completed` obsługiwany przez skrypt stacji.
- Zachowane zasięgi rekwizytów są częścią kontraktu: Station 36 — `52, 48,
  46, 48, 60`; Station 37 — `48, 50, 52, 48, 60`; Station 38 — `48, 52,
  50, 48, 60`; Station 39 — `48, 48, 58, 48, 60`; Station 40 — `48, 48,
  48, 48, 60`.
- `AnchorableObject` dostarcza istniejące API kotwicy, zmiany rzeczywistości,
  oporu i sygnału stanu. `MovableAnchorableProp` istnieje, lecz ten pakiet go
  nie potrzebuje. Nie zmieniamy shell colliderów, promieni, InputMap ani
  limitu kampanii.
- Wszystkie skrypty mają starą, nieprzezroczystą procedurę `_draw()`; przed
  pakietem nie ma `VectorStageEnvironment`, `AtmosphereRig`,
  `CRTDialogueBox`, `OpeningDialogueCue` ani `_draw_state_layer()`.

## Rozbieżność numeracji kanonu

Aktualny runtime, `NEXT_SESSION_PROMPT.md`, `CURRENT_STATE.md`, wpisy
`SESSION_LOG.md` dla wdrożeń Station 35..39 oraz źródła 36..40 używają ciągu:
Kanał Odpływowy → Komora Sygnałowa → Człowiek zamiast dowodu → Komora
Referencyjna → Sala Negocjacyjna. Z kolei po późniejszym scaleniu N0.2-C
`FULL_STORY.md` opisuje sceny 36..38 jako Fałszywy poranek, Rysę i Człowieka,
a `DIALOGUE_SCRIPT.md` zachowuje D-13/D-14 w innej numeracji. Hierarchia prawdy
projektu daje aktualnemu kodowi i świeżemu handoffowi pierwszeństwo przed
historycznym opisem; PKG-0105 konwertuje istniejący runtimeowy ciąg i nie
przenumerowuje ani nie przepisuje fabuły. Rozjazd pozostaje jawny do osobnego
pakietu synchronizacji kanonu.

## Decyzja zakresowa

Pakiet wdraża dokładnie jedną przeszkodę diegetyczną: Station 38 używa rodziny
R3, ponieważ scena już wymaga utrzymania Jakuba jako żywego człowieka zamiast
czystej współrzędnej powrotu. Station 36, 37, 39 i 40 zachowują świadomą
ciszę. Kanał, węzeł transmisyjny, Komora Referencyjna i Sala Negocjacyjna
wykonują pracę świata albo niosą decyzję relacyjną; sztuczne dodanie drugiej
próby naruszyłoby rytm przejścia do Aktu IV.

| Stacja | Decyzja | Rzecz ze świata | Rodzina / mechanika | Koszt korekty albo powód ciszy |
|---|---|---|---|---|
| 36 | brak — świadoma cisza | Kanał burzowy odprowadza osad sedacyjny do wód gruntowych, bo instalacja filtracyjna wykonuje zapisany zrzut. | brak nowej geometrii; jaz, nurt, drabinka i kurek są rekwizytami dowodowymi | nie dotyczy; scena ujawnia ekologiczną krzywdę UCP i nie zamienia jej w tor wykonawczy |
| 37 | brak — świadoma cisza | Węzeł transmisyjny wzmacnia sygnały sektorów, ponieważ Podstruktura przenosi nimi wyparte świadectwa. | brak nowej geometrii; oscyloskop, krosownica, antena i pulpit prowadzą dialog o publicznej pamięci | nie dotyczy; transmisja ma być decyzją o świadectwie, nie testem rytmu urządzeń |
| 38 | R3 — przeszkoda | Pole pamięci wypadku wciąga Jakuba w zapis katastrofy, a śluza bezpieczeństwa zamyka przejście, gdy jego teraźniejszość nie jest utrzymywana. | `Geometry/JakubRescueBulkhead` jako `AnchorableObject`; stan A pozostawia przejście otwarte, stan B zamyka je, a kotwica utrzymuje drogę dla Jakuba | `station_38_jakub_rescue_corrected`, reset checkpointu, wyblakły szczegół węzła ratunkowego; brak śmierci i brak trwałego zamknięcia drogi |
| 39 | brak — świadoma cisza | Rdzeń Referencyjny pokazuje trzy równoprawne konfiguracje, ponieważ Podstruktura nie ustanawia jednego oryginału. | brak nowej geometrii; trzy pulpity i oddanie interfejsu przez Ślad są punktem wyboru | nie dotyczy; decyzja ma wynikać z odpowiedzialności, nie z fizycznego zwycięstwa |
| 40 | brak — świadoma cisza | Sala Negocjacyjna istnieje, aby Wierzbicka, Marta, Jakub i Szymon mogli nazwać koszty trzech operacji przed ich wykonaniem. | brak nowej geometrii; terminal, matryca kosztów i stanowiska świadków są sceną negocjacji | nie dotyczy; otwarcie Aktu IV pozostaje rozmową i świadectwem, bez bossa ani progu zręcznościowego |

## Test trzech pytań — Station 36, świadoma cisza

1. **Dlaczego to tu jest?** — Kanał burzowy odprowadza osad sedacyjny do wód
   gruntowych, bo instalacja filtracyjna wykonuje zapisany zrzut.
2. **Czego wymaga od Leny?** — Obejrzenia jazu, nurtu, drabinki i kurka oraz
   połączenia fizycznego skażenia z decyzjami UCP.
3. **Jaki jest koszt porażki?** — Nie ma próby korekty; stawką sceny jest
   rozpoznanie szkody, więc nie dodaje ona osobnego toru ruchowego.

## Test trzech pytań — Station 37, świadoma cisza

1. **Dlaczego to tu jest?** — Węzeł transmisyjny wzmacnia sygnały sektorów,
   ponieważ Podstruktura przenosi nimi wyparte świadectwa.
2. **Czego wymaga od Leny?** — Odczytania oscyloskopu, krosownicy, anteny i
   pulpitu oraz uznania, że świadectwo ma odbiorców poza komorą.
3. **Jaki jest koszt porażki?** — Nie ma korekty fizycznej; scena buduje
   konsekwencję publicznego sygnału bez zamiany transmisji w sekwencję timingową.

## Test trzech pytań — Station 38, R3

1. **Dlaczego to tu jest?** — Pole pamięci wypadku wciąga Jakuba w zapis
   katastrofy, a śluza bezpieczeństwa zamyka przejście, gdy jego teraźniejszość
   nie jest utrzymywana.
2. **Czego wymaga od Leny?** — Podejścia do węzła ratunkowego, zakotwiczenia
   otwartej konfiguracji i przejścia z Jakubem jako osobą; nie wymaga sekwencji
   skoków ani wyczucia cyklu.
3. **Jaki jest koszt porażki?** — Niezakotwiczona próba zapisuje korektę,
   zwęża śluzę, odsyła Lenę do checkpointu i wygasza detal węzła; Jakub nie
   umiera, a kolejna próba pozostaje możliwa.

`JakubRescueBulkhead` ma tę samą pozycję w obu stanach. Wersja A jest
nieblokującą, utrzymywaną konfiguracją śluzy; wersja B jest pełną taflą
bezpieczeństwa w tej samej ramie. Obiekt nie porusza się według zegara i nie
jest celem skoku. Korekta może zostać odparta przez istniejące API kotwicy.

## Test trzech pytań — Station 39, świadoma cisza

1. **Dlaczego to tu jest?** — Rdzeń Referencyjny pokazuje trzy równoprawne
   konfiguracje, ponieważ Podstruktura nie ustanawia jednego oryginału.
2. **Czego wymaga od Leny?** — Obejrzenia trzech konfiguracji i przyjęcia
   kontroli po decyzji Śladu, bez wybierania przez wskaźnik punktów lub próg ruchu.
3. **Jaki jest koszt porażki?** — Nie ma korekty fizycznej; koszt wyboru należy
   do finałów i nie może zostać zastąpiony przez przegraną wykonawczą.

## Test trzech pytań — Station 40, świadoma cisza

1. **Dlaczego to tu jest?** — Sala Negocjacyjna istnieje, aby świadkowie mogli
   nazwać koszty trzech operacji przed ich wykonaniem.
2. **Czego wymaga od Leny?** — Wysłuchania Wierzbickiej, Marty, Jakuba i Szymona
   oraz wejścia do Komory Wyboru dopiero po rozpoznaniu znanych kosztów.
3. **Jaki jest koszt porażki?** — Nie ma korekty fizycznej; decyzja może być
   trudna i nieodwracalna fabularnie, ale przejście do Station 41 nie jest
   testem zręcznościowym.

Automaty, renderingi i test korekty dowodzą kontraktów technicznych, obecności
kadru i działania jednej przeszkody R3. Nie dowodzą funu, emocji, czytelności
przez nową osobę ani zrozumienia fabuły przez człowieka.
