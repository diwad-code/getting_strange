# Audyt kosztu Rówień Vector-Stage — H-005

Status: **TECHNICAL — pomiar wykonany, brak jawnego budżetu porównawczego**  
Data: 2026-08-24  
Pakiet: `PKG-0109`  
Zakres: wyłącznie techniczny koszt istniejącego runtime'u Godot 4.7; bez
optymalizacji, nowych assetów i zmian logiki gry.

## 1. Wniosek wykonawczy

Audyt wykonał świeży, powtarzalny pomiar normalnego runtime'u Windows/OpenGL
na Intel Iris Xe dla dziewięciu wymaganych kadrów świata, dodatkowego Station
02 do pomiaru istniejącego `DiscontinuousShadow`, dwóch wariantów świata z CRT
oraz proceduralnego cyklu protagonistki. Wszystkie 45 zasobów scen na dysku
zostało załadowanych i zinwentaryzowanych; odpowiadają 43 przestrzeniom
kampanii, ponieważ `42A`, `42B` i `42C` są trzema wariantami przestrzeni 42.

W tym środowisku bezpośrednio zmierzone średnie `render_cpu_ms` dla kadrów
świata wyniosły `0.654–1.016 ms`, a średnie `render_gpu_ms`
`0.720–1.606 ms`. Najwyższe średnie canvas metrics w próbie miał Station 41
(`125` draw calls, `2 320` primitives, `209` canvas items). Station 38 miał
najwyższy średni GPU render time (`1.606 ms`), ale jego p95 GPU wyniósł
`11.557 ms`, więc wynik pokazuje również zmienność pojedynczych próbek.

To nie jest jeszcze dowód wykonalności produkcyjnej w sensie H-005: dokumenty
projektu zawierają wymóg 60 FPS i logiczny viewport `640x360`, lecz nie zawierają
liczbowego budżetu czasu klatki/renderu, CPU, GPU, draw calls, canvas items,
wierzchołków ani kosztu ręcznej produkcji. Nie wolno uznać `16.667 ms` za nowo
ustanowiony budżet tylko dlatego, że jest okresem 60 Hz. H-005 pozostaje
`TECHNICAL` z rozstrzygniętym pomiarem bieżącego runtime'u i nierozstrzygniętym
kontraktem budżetowym.

## 2. Pytanie i granice dowodu

Audyt sprawdza koszt aktualnie zaimplementowanego kadru Vector-Stage,
proceduralnej sylwetki Leny wraz z istniejącymi efektami oraz zakres elementów
we wszystkich scenach. Nie sprawdza funu, emocji, czytelności, zrozumienia
fabuły ani żadnej reakcji odbiorczej. Automatyczny pomiar dowodzi zachowania
technicznego badanego runtime'u na jednym profilu sprzętowym; nie jest
playtestem ani dowodem jakości odbioru.

## 3. Definicja mierzonego kadru

Podstawowy **kadr świata** to świeżo wyrenderowana klatka sceny z:

- `VectorStageEnvironment` i aktywnym skryptem przestrzeni;
- istniejącą fizyczną geometrią sceny;
- protagonistką `PrototypePlayer`, jej proceduralnym `_draw()`, cieniem
  rysowanym przez protagonistkę i aktywnymi `CPUParticles2D` protagonistki;
- istniejącym `DiscontinuousShadow`, jeśli scena go posiada;
- istniejącym `AtmosphereRig` (`PointLight2D`, pył i audio), jeśli scena go
  posiada.

CRT nie jest mieszany z podstawową tabelą świata, ponieważ `CRTDialogueBox` jest
warstwą UI. Wykonano osobny pomiar `world_plus_crt` dla Station 01 i Station
42C, z tym samym światem i protagonistką. Nie wyciągano kosztu CRT z kadrów,
w których UI było ukryte.

## 4. Znaczenie pełnego cyklu animacji protagonistki

Runtime nie ma `AnimationPlayer`, `AnimatedSprite2D` ani gotowego sprite-sheetu
Leny. Animacja jest proceduralna i sterowana przez fizykę: `_draw()` odczytuje
prędkość, kierunek i `_visual_scale`. Powtarzalny cykl harnessu obejmował:

1. postój / neutralną pozę;
2. chód w prawo i przełączenie kierunku;
3. skok, fazę opadania i lądowanie;
4. istniejący squash-and-stretch po kontakcie z podłożem;
5. powrót do skali neutralnej;
6. bieg z istniejącym pyłem;
7. chód w lewo i powrót do postoju;
8. aktualizację `DiscontinuousShadow` w Station 02, gdzie ten efekt istnieje.

Harness wywoływał wyłącznie istniejące semantyczne akcje InputMap i resetował
scenę. Nie dodano nowej animacji. Inventory potwierdził w 45 scenach:
`AnimationPlayer = 0`, `AnimatedSprite2D = 0`, `PrototypePlayer = 45`, a
`DiscontinuousShadow = 1` tylko w Station 02.

## 5. Narzędzie, źródła API i metryki

Powtarzalne narzędzie to `tools/audit_h005.gd`. Uruchomiono je w normalnym
oknie Windows/OpenGL (`gl_compatibility`) na Intel Iris Xe, z logicznym
viewportem `640x360`. Harness ustawił `Engine.max_fps = 0` i wyłączył V-Sync
wyłącznie na czas pomiaru, aby interwał nie był przycięty do częstotliwości
monitora; ustawienia produktu nie zostały zmienione.

Odczytane metryki:

- interwał między próbkowanymi klatkami z `Time.get_ticks_usec()`;
- `Performance.TIME_PROCESS` i `Performance.TIME_PHYSICS_PROCESS`, zachowane
  jako monitory runtime'u, ale niewykorzystywane do przypisywania kosztu
  pojedynczej warstwie renderu;
- `Viewport.get_render_info(... TYPE_CANVAS, ... OBJECTS/PRIMITIVES/
  DRAW_CALLS)` dla rzeczywistych metryk canvas 2D;
- `RenderingServer.viewport_get_measured_render_time_cpu()` i
  `RenderingServer.viewport_get_measured_render_time_gpu()` po włączeniu
  pomiaru viewportu;
- `RenderingServer.get_frame_setup_time_cpu()`;
- liczby węzłów, skryptów, proceduralnych draw nodes, procesów, fizyki,
  cząsteczek, świateł i elementów współdzielonych z drzewa sceny.

Definicje metryk canvas i pomiaru czasu renderowania wynikają z API Godot 4.7:
[Performance](https://docs.godotengine.org/en/4.7/classes/class_performance.html),
[Viewport render info](https://docs.godotengine.org/en/4.7/classes/class_viewport.html)
i [RenderingServer render-time measurement](https://docs.godotengine.org/en/4.7/classes/class_renderingserver.html).
Wynik `0` albo brak metryki byłby zapisany jako `unavailable`; w tym przebiegu
metryki render CPU/GPU były dostępne.

## 6. Próbka i powtarzalność

- rozgrzewka: 60 klatek po załadowaniu sceny i ustawieniu pozy kontrolnej;
- próbka: 120 klatek na tryb pomiaru;
- po dwóch pierwszych klatkach RenderingServer zbierano 118 ważnych próbek
  dla każdego wiersza statycznego;
- cykl animacji miał 220 klatek, z czego zapisano 218 ważnych próbek po tym
  samym odrzuceniu;
- każda scena była tworzona po resecie, a poprzednia instancja była zwalniana;
- porównanie protagonistki wykonywano przez wizualne ukrycie warstwy przy
  zachowaniu procesów, fizyki, colliderów i drzewa sceny;
- dla Station 02 wykonano tryby `full_world`, `no_dust`,
  `no_dust_and_shadow`, `no_player_and_shadow` i `no_shadow`;
- raport zapisuje średnią, medianę, p95 i maksimum; surowe próbki cyklu są w
  `reports/pkg_0109/animation_samples.tsv`;
- wszystkie parametry powtórzenia są w
  `reports/pkg_0109/metadata.json`.

## 7. Bezpośredni pomiar reprezentatywnych kadrów

Wartości `items`, `primitives` i `draw_calls` są średnimi z próbki. Czasy są w
milisekundach; zapis `mean/p95` pokazuje średnią i 95. percentyl. Tabela
obejmuje wymagane reprezentatywne sceny oraz Station 02 jako dodatkowy przypadek
z istniejącym cieniem rozłącznym.

| scena | frame interval mean/p95 | canvas items | primitives | draw calls | render CPU mean/p95 | render GPU mean/p95 |
|---|---:|---:|---:|---:|---:|---:|
| Station 01 | 2.602 / 6.969 | 157.0 | 1636.0 | 98.0 | 0.789 / 1.089 | 0.698 / 0.737 |
| Station 02 | 2.303 / 7.836 | 102.0 | 752.0 | 72.0 | 0.683 / 0.942 | 0.875 / 1.047 |
| Station 14 | 3.258 / 7.932 | 208.0 | 2556.0 | 117.0 | 0.982 / 1.439 | 1.145 / 1.828 |
| Station 22 | 2.959 / 6.932 | 152.4 | 1558.7 | 105.0 | 0.859 / 1.213 | 0.985 / 0.917 |
| Station 38 | 3.240 / 9.107 | 163.0 | 1536.0 | 105.0 | 0.852 / 1.275 | 1.606 / 11.557 |
| Station 41 | 3.440 / 6.423 | 209.0 | 2320.0 | 125.0 | 1.016 / 1.498 | 1.181 / 9.146 |
| Station 42A | 2.590 / 7.844 | 94.0 | 540.0 | 69.0 | 0.705 / 1.051 | 1.147 / 1.123 |
| Station 42B | 2.216 / 7.334 | 93.0 | 620.0 | 69.0 | 0.654 / 0.796 | 0.720 / 0.804 |
| Station 42C | 2.155 / 7.675 | 111.0 | 839.0 | 70.0 | 0.678 / 0.930 | 0.908 / 1.153 |
| Station 43 | 2.339 / 8.570 | 123.0 | 678.0 | 73.0 | 0.668 / 0.917 | 1.207 / 10.306 |

Oddzielne pomiary świata z CRT:

| scena | canvas items | primitives | draw calls | render CPU mean/p95 | render GPU mean/p95 |
|---|---:|---:|---:|---:|---:|
| Station 01 + CRT | 181.0 | 2110.0 | 103.0 | 0.891 / 1.256 | 1.113 / 0.918 |
| Station 42C + CRT | 135.0 | 1313.0 | 75.0 | 0.766 / 1.136 | 1.088 / 0.923 |

`TIME_PROCESS` i `TIME_PHYSICS_PROCESS` zostały zachowane w TSV, ale ich
wartości monitorowe nie są podstawą przypisywania kosztu warstwie renderu.
W szczególności obserwowane wartości `TIME_PROCESS` są próbkowane przez
monitor runtime'u i nie zachowują się jak izolowany czas renderowania. Do
porównań użyto bezpośredniego interwału klatki, canvas metrics oraz pomiaru
RenderingServer CPU/GPU.

## 8. Koszt proceduralnego cyklu protagonistki

Poniżej bezpośredni wynik pięciu trybów tej samej sceny Station 02. Różnica
canvas items/primitives/draw calls jest obserwacją geometrii warstwy względem
trybu bez niej. Różnice czasu renderowania nie są traktowane jako niezależny
koszt komponentu, jeśli odejmowanie jest niemonotoniczne lub mieści się w
zmienności próby.

| tryb | canvas items mean/p95 | primitives mean/p95 | draw calls mean/p95 | render CPU mean/p95 | render GPU mean/p95 |
|---|---:|---:|---:|---:|---:|
| full_world | 107.734 / 121 | 801.211 / 932 | 73.055 / 76 | 0.671 / 0.846 | 0.810 / 0.697 |
| no_dust | 109.266 / 120 | 810.128 / 896 | 73.211 / 75 | 0.705 / 0.989 | 0.886 / 0.869 |
| no_dust_and_shadow | 105.862 / 118 | 770.899 / 868 | 70.977 / 73 | 0.769 / 1.142 | 0.857 / 0.889 |
| no_player_and_shadow | 88.835 / 98 | 666.679 / 740 | 54.472 / 56 | 0.753 / 1.112 | 1.263 / 1.118 |
| no_shadow | 108.679 / 119 | 821.431 / 904 | 72.280 / 74 | 0.723 / 1.000 | 1.235 / 1.213 |

Najbardziej stabilny wniosek z porównania to geometryczny narzut kompletnej
warstwy protagonistki względem `no_player_and_shadow`: średnio `+18.899`
canvas items, `+134.532` primitives i `+18.583` draw calls w tym cyklu.
Rozbicie zapisane w `animation_component_deltas.tsv` pokazuje odpowiednio dla
ciała z wbudowanym cieniem `+17.028 / +104.220 / +16.505`, dla
`DiscontinuousShadow` `+3.404 / +39.229 / +2.234`, a dla pyłu różnice są
niestabilne i niemonotoniczne (`full_world` względem `no_dust`: `-1.532`
items, `-8.917` primitives, `-0.156` draw calls). To ostatnie nie jest
podstawą do twierdzenia, że pył ma ujemny koszt; oznacza, że obecny harness i
dynamiczna zawartość cząsteczek nie izolują tego efektu wystarczająco, aby
przypisać mu osobny budżet czasowy.

Pełny cykl miał średni interwał `2.178 ms` i p95 `6.525 ms` w trybie
`full_world` przy nieograniczonym przez V-Sync harnessie. Jest to obserwacja
tego komputera i tej sceny, a nie kontrakt dla całej produkcji.

## 9. Inventory wszystkich przestrzeni

`reports/pkg_0109/inventory_43.tsv` zawiera 45 wierszy zasobów:

- 41 scen `station_01`–`station_41`;
- trzy warianty finału: `station_42a`, `station_42b`, `station_42c`, każdy z
  `campaign_space = 42`;
- `station_43` jako epilog, `campaign_space = 43`.

Wszystkie 45 zasobów załadowało się poprawnie jako `inventory_only`. Każdy ma
`PrototypePlayer = 1`, `VectorStageEnvironment = 1`, `AtmosphereRig = 1`,
`CRTDialogueBox = 1`, `AnimationPlayer = 0` i `AnimatedSprite2D = 0`. Dziesięć
zasobów ma bezpośredni pomiar klatki (`01`, `02`, `14`, `22`, `38`, `41`,
`42A`, `42B`, `42C`, `43`); pozostałe 35 mają inventory runtime/source, bez
udawanej ekstrapolacji kosztu.

| pole inventory | minimum | maksimum | średnia | suma |
|---|---:|---:|---:|---:|
| scripted nodes | 9 | 15 | 11.956 | 538 |
| procedural draw nodes | 5 | 11 | 7.956 | 358 |
| active process nodes | 6 | 11 | 8.889 | 400 |
| active physics nodes | 2 | 4 | 2.333 | 105 |
| animated/effect nodes | 15 | 28 | 21.178 | 953 |
| `CPUParticles2D` | 5 | 12 | 8.200 | 369 |
| `PointLight2D` | 3 | 4 | 3.022 | 136 |
| shared element nodes | 5 | 5 | 5.000 | 225 |

Inventory jest zakresem elementów i aktywności, nie bezpośrednim pomiarem
czasu dla 35 scen. Nie wolno z niego wyprowadzać średniego kosztu wszystkich
43 przestrzeni.

## 10. Budżet, decyzja produkcyjna i status H-005

Przed audytem znaleziono:

- wymóg stabilnych 60 klatek na słabym komputerze testowym;
- logiczny viewport `640x360`;
- fizykę 60 Hz.

Nie znaleziono jawnego limitu milisekund renderu, CPU, GPU, draw calls, canvas
items, wierzchołków, pamięci ani czasu ręcznej konwersji 43 kadrów. Wymóg 60 FPS
pozostaje wymaganiem produktu, lecz nie ustanawia sam przez się zaakceptowanego
budżetu per subsystem. Audyt nie dopisuje takiego progu po fakcie.

Decyzja: nie zmieniać scen, assetów, colliderów, InputMap, fizyki, logiki
kampanii, rozgałęzień ani istniejących efektów na podstawie jednego profilu
sprzętowego. H-005 pozostaje `TECHNICAL`; dowód zmniejsza niepewność o koszt
bieżącego runtime'u, ale nie rozstrzyga jeszcze wykonalności względem jawnego
budżetu produkcyjnego.

## 11. Artefakty i ograniczenia

- narzędzie: `tools/audit_h005.gd`;
- metadane: `reports/pkg_0109/metadata.json`;
- inventory: `reports/pkg_0109/inventory_43.tsv`;
- metryki kadrów: `reports/pkg_0109/frame_metrics.tsv`;
- metryki cyklu: `reports/pkg_0109/animation_metrics.tsv`;
- różnice warstw: `reports/pkg_0109/animation_component_deltas.tsv`;
- próbki cyklu: `reports/pkg_0109/animation_samples.tsv`;
- podsumowanie JSON: `reports/pkg_0109/summary.json`.

Pomiar wykonano 2026-08-24 w jednym świeżym procesie Godot 4.7-stable na
Windows, OpenGL 3.3.0, Intel Iris Xe Graphics. V-Sync był wyłączony wyłącznie
w harnessie, a `Engine.max_fps = 0`; produkt nie został zmodyfikowany. Wyniki
nie są dowodem zachowania na innym sprzęcie, nie zastępują pomiaru drugiego
profilu sprzętowego i nie ustanawiają dowodu odbiorczego. Znane ostrzeżenia
`ObjectDB`/`RID leak` przy zamykaniu Godota nie zmieniły kodu wyjścia audytu.

Plan został zapisany przed dodaniem narzędzia i przed pierwszym pomiarem. Po
wykonaniu planu nie wykryto jednoznacznego błędu w kodzie gry wymagającego
minimalnej naprawy; zmiany pakietu ograniczyły się do instrumentacji,
raportu, danych maszynowych i dokumentacji handoffu.
