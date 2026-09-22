# PKG-0113 — audyt kierunku artystycznego Rówień Vector-Stage

Data: 2026-08-24  
Zakres: Station 01, 14, 22, 38, 41, 42A, 42B, 42C, 43, dialog CRT i menu pauzy  
Status: **HISTORYCZNY DOWÓD RUNTIME; KIERUNEK ZASTĄPIONY CZĘŚCIOWO PRZEZ D-113**

## Aktualizacja po PKG-0116 / D-113

Kadry i pomiary poniżej zachowują wartość jako dowód stanu sprzed przebudowy,
między innymi jako potwierdzenie, że proceduralna Lena była zbyt małą,
placeholderową sylwetką. Nie są aktywnym briefem content locku. Rówień
Pixel-Stage, produkcyjny `LenaVisualRig` i ostre warstwy tekstu definiują teraz
`VISUAL_DESIGN.md`, `docs/LENA_CHARACTER_AND_ANIMATION.md` oraz
`docs/PIXEL_PRESENTATION_ARCHITECTURE.md`. Backlog P1 tego dokumentu nie może
wyprzedzić pionowych wycinków PKG-0117–0122.

## 1. Granica audytu

To jest kontrola art-direction wykonana na świeżych kadrach 640x360. Ustala
spójność z `VISUAL_DESIGN.md`, własność warstw, powtarzalność motywu, zakres
palety i techniczne dopasowanie UI. Nie dowodzi, że nowa osoba odczyta scenę,
polubi obraz, zrozumie fabułę albo zauważy korektę. H-012 pozostaje `UNTESTED`.

Kadry wykonano normalnym sterownikiem Godot 4.7/OpenGL na Windows, urządzenie
Intel Iris Xe. Narzędzie: `tools/capture_pkg_0113.gd`.

## 2. Zestaw dowodowy before/after

| Kontrola | Przed | Po |
|---|---|---|
| Akt I | `reports/pkg_0113/before/world/station_01.png` | `reports/pkg_0113/after/world/station_01.png` |
| środek / Anchor | `reports/pkg_0113/before/world/station_14.png` | `reports/pkg_0113/after/world/station_14.png` |
| środek / Yield | `reports/pkg_0113/before/world/station_22.png` | `reports/pkg_0113/after/world/station_22.png` |
| Akt III | `reports/pkg_0113/before/world/station_38.png` | `reports/pkg_0113/after/world/station_38.png` |
| wybór | `reports/pkg_0113/before/world/station_41.png` | `reports/pkg_0113/after/world/station_41.png` |
| finał A | `reports/pkg_0113/before/world/station_42a.png` | `reports/pkg_0113/after/world/station_42a.png` |
| finał B | `reports/pkg_0113/before/world/station_42b.png` | `reports/pkg_0113/after/world/station_42b.png` |
| finał C | `reports/pkg_0113/before/world/station_42c.png` | `reports/pkg_0113/after/world/station_42c.png` |
| epilog | `reports/pkg_0113/before/world/station_43.png` | `reports/pkg_0113/after/world/station_43.png` |
| dialog 01 | `reports/pkg_0113/before/dialogue/station_01.png` | `reports/pkg_0113/after/dialogue/station_01.png` |
| dialog 22 | `reports/pkg_0113/before/dialogue/station_22.png` | `reports/pkg_0113/after/dialogue/station_22.png` |
| dialog 43 | `reports/pkg_0113/before/dialogue/station_43.png` | `reports/pkg_0113/after/dialogue/station_43.png` |
| pauza | `reports/pkg_0113/before/pause/station_01.png` | `reports/pkg_0113/after/pause/station_01.png` |

## 3. Ustalenia przed zmianą

### P0 — menu pauzy wychodziło poza użyteczny kadr

Selektor miał sześć kolumn i osiem rzędów w panelu 544x308. Dolne pozycje były
obcięte w 640x360, więc nie istniał wiarygodny techniczny dostęp do całej listy.
To był defekt UI, nie ocena estetyczna.

### P0/P1 — prompt dialogu łamał semantyczny InputMap

Ramka pokazywała na stałe `[ E ]`, mimo że interakcja jest akcją `interact` i
ma też wejście pada. UI przedstawiało jeden klawisz jako kontrakt produktu.

### P1 — jedna matryca oświetlenia udawała 43 miejsca

`VectorStageEnvironment` rysował trzy identyczne lampy w tych samych pozycjach
nad każdą stacją. Kadry różniły się propsami, lecz nadrzędny rytm światła był
kopiowany bez związku z aktem, miejscem ani finałem. To była największa
bezpieczna do naprawy wada systemowa, ponieważ można ją usunąć w jednej
warstwie bez dotykania colliderów lub logiki.

### P1 — portret był literą

Dialog CRT przedstawiał mówcę pojedynczą inicjałą. Dokumenty mówiły o
portretach, ale runtime miał wyłącznie glif. Powierzchnia była również oparta
na zielonym neonowym obramowaniu, które nie należało do podstawowej palety
Vector-Stage.

### P1 — brak wspólnej ramy scenicznej

Duże wielokąty były obecne, lecz wiele kadrów czytało się technicznie jako
luźny zestaw prostokątów na jednym planie. Brakowało powtarzalnego kontraktu
proscenium i odrębnej rodziny praktycznego światła dla kolejnych aktów.

### P1 — Station 38 kumulowała duże plamy bursztynu

Centralny węzeł miał nałożoną szeroką bursztynową płaszczyznę środowiska,
rekwizyty i aktywną warstwę stanu. Audyt wskazał redukcję jednego największego
wypełnienia, bez usuwania śladu Jakuba ani bramki `JakubRescueBulkhead`.

## 4. Wykonana remediacja

### Wspólna scenografia

- usunięto tablicę trzech stałych lamp;
- dodano deterministyczne profile praktycznego światła: pendenty Aktu I,
  robocze listwy Aktu II, pionowe światła serwisowe Aktu III oraz osobne osie
  `return`, `reconciliation`, `testimony`, `epilogue`;
- dodano szeroką płaszczyznę głębi na akt i ograniczoną, asymetryczną ramę
  proscenium;
- zachowano paletę `VectorStageStyle`, bez szumu proceduralnego, tekstur i
  filtrów pełnoekranowych;
- Station 38 otrzymała mniejszy, przyciemniony plan świadka i linię relacji
  zamiast dużego bursztynowego bloku.

### Dialog CRT

- glif zastąpiono `CRTPortrait`, proceduralnym portretem z ograniczonej liczby
  faset;
- panel korzysta z `INK`, `DEEP_PLANE`, `LIGHT_PLANE`, bursztynu i koloru
  mówcy zamiast osobnej zielonej estetyki;
- prompt brzmi `INTERAKCJA >`, więc nazywa akcję, nie konkretny klawisz;
- dodano jawne nazwy węzłów i gate strukturalny.

### Menu pauzy

- panel 568x324 mieści się w logicznym viewport 640x360;
- siatka ma dziewięć kolumn i pięć rzędów dla 43 ustalonych pozycji selektora;
- wszystkie przyciski mają jawne stany normal/hover/pressed/disabled z palety
  Vector-Stage;
- świeży kadr `after/pause/station_01.png` pokazuje pełną listę 01..41, 42A i
  43 bez obcięcia.

## 5. Własność warstw i bezpieczeństwo runtime

- `VectorStageEnvironment` nadal ma `z_index = -5` i jest właścicielem tła,
  architektury, praktycznych świateł oraz ramy;
- skrypty Station 01..43 nadal zaczynają aktywną warstwę stanu od
  `VectorStageStyle.draw_play_plane(self, geometry)`;
- nie dodano ani nie zmieniono colliderów, `StaticBody2D`, `AnimatableBody2D`,
  `AirlockZone`, promieni interakcji, fizyki 60 Hz ani InputMap;
- `CAMPAIGN_TRANSITION_LIMIT = 25` i `SAVE_SCHEMA_VERSION = 1` pozostały bez
  zmian;
- poprawka smoke Station 32/38 wymaga prawdziwego zakotwiczenia przed
  przekroczeniem granicy korekty; nie osłabia mechaniki.

## 6. Świeża kontrola techniczna

- `tools/capture_pkg_0113.gd -- --capture-phase=before`: 13/13 PASS;
- `tools/capture_pkg_0113.gd -- --capture-phase=after`: 13/13 PASS;
- `tests/pkg_0113_smoke_test.gd`: PASS;
- `tools/audit_h012.gd`: `PKG-0108 AUDIT PASS`, 12 kadrów, 63 pomiary,
  48 kontroli skal;
- kadry `after` zostały obejrzane ręcznie w rozdzielczości źródłowej.

Te wyniki potwierdzają zapis obrazu, obecność elementów, granice viewportu i
kontrakty strukturalne. Nie potwierdzają odbioru.

## 7. Pozostały backlog art-direction

### P1 przed content lockiem

1. Wariant 42B nadal opiera środek kadru na jednej bardzo dużej bursztynowej
   płaszczyźnie. Kolejny pass powinien rozbić ją na próg, wnętrze i znak relacji,
   zachowując ciszę mechaniczną.
2. Epilog 43 używa trzech bardzo dużych paneli o podobnej masie. Należy nadać
   im różne funkcje materiałowe i hierarchię, bez sugerowania „złotego” finału.
3. Station 41 ma technicznie rozdzielone trzy operacje, ale ich terminale i
   pionowe wnęki są niemal równoważne; potrzebują odrębnych materiałów przy
   zachowaniu H-011a = 0.
4. `CRTPortrait` jest dziś jednym systemem sylwetki z wariacją kierunku i
   koloru. Content lock wymaga odrębnych, rozpoznawalnych profili co najmniej
   Leny, Marty, Jakuba, Wierzbickiej i Szymona oraz wariantu Świadectwa.
5. Postać w szerokich kadrach pozostaje mała względem architektury. To może być
   celowa skala, ale wymaga konsekwentnego kadrowania i kontroli interakcji;
   automat nie rozstrzyga czytelności.

### P2

- mikrorytm rekwizytów w scenach świadomej ciszy;
- spójność ikon terminali i typografii;
- kontrola jasności świateł praktycznych po finalnym miksie atmosfery;
- warianty portretu dla Strażnika i głosów systemowych.

## 8. Status H-005 i H-012

- H-005 pozostaje `TECHNICAL`: zmiana nie dostarcza uprzedniego budżetu ani
  wielosprzętowego dowodu kosztu;
- H-012 pozostaje `UNTESTED`: świeże pomiary i obrazy nie mają ustanowionego
  progu rozstrzygającego, a inspekcja AI nie zastępuje nowego odbiorcy.

Wykonana remediacja jest produkcyjną korektą opartą na obserwowalnym konflikcie
z kanonem i granicą viewportu, nie twierdzeniem, że oprawa jest już finalna.
