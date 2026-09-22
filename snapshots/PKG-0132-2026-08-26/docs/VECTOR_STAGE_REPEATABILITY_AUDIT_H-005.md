# Audyt powtarzalności Rówień Vector-Stage — H-005

Status: **PLAN I AUDYT W TOKU — PKG-0110**  
Data: 2026-08-24  
Zakres: wyłącznie techniczny pomiar istniejącego runtime'u Godot 4.7; bez
zmiany scen, assetów, colliderów, mechaniki, dialogów, rozgałęzień, InputMap,
fizyki 60 Hz, limitu kampanii 25 ani `SAVE_SCHEMA_VERSION = 1`.

## 1. Cel i granica dowodu

Pakiet sprawdzi dwa niezależne świeże procesy narzędzia
`tools/audit_h005.gd` na tym samym profilu Windows/OpenGL/Intel Iris Xe oraz
rozstrzygnie, czy aktualna dokumentacja zawiera jawny liczbowy kontrakt kosztu.
Pomiar powtarzalności jest dowodem zachowania tego harnessu i tego komputera;
nie jest testem wielosprzętowym, playtestem ani dowodem funu, emocji,
czytelności lub zrozumienia fabuły.

Nie wolno ustanawiać budżetu po fakcie. W szczególności `16.667 ms` jest tylko
matematycznym okresem 60 Hz, a nie zaakceptowanym budżetem renderu lub
subsystemu.

## 2. Baseline przed zmianą

Uruchomiono bez zmian:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Wynik: **PASS, exit code 0, `Verification passed.`** Przeszły kontrakt
dokumentacji, import Godot, smoke projektu, traversal lint oraz bramki
`PKG-0095`–`PKG-0107`. Ostrzeżenia `ObjectDB`/`RID leak` przy zamykaniu
procesów pozostały znanym nieblokującym szumem; nie zmieniły kodu wyjścia.

## 3. Audyt istniejącego kontraktu budżetowego

Wykonano pełne wyszukanie w aktualnych dokumentach poleceniem:

```powershell
rg -n "budget|budżet|60 FPS|frame|render|CPU|GPU|draw call|wierzchoł|production cost" .\docs --glob "*.md"
```

Wynik zostanie rozdzielony według rodzaju dowodu:

| Pytanie | Wynik lektury aktualnych źródeł | Klasyfikacja |
|---|---|---|
| Stabilne 60 FPS | Wymóg produktu w `TECHNICAL_DIRECTION.md`, `ROADMAP.md` i handoffach | wymaganie produktu, nie budżet subsystemu |
| Logiczny viewport `640x360` | Jawny kontrakt techniczny | rozmiar wejścia pomiaru, nie budżet czasu |
| Fizyka 60 Hz | Jawny kontrakt techniczny | częstotliwość symulacji, nie budżet renderu |
| Budżet czasu całej klatki | Nie znaleziono jawnego zaakceptowanego limitu | brak kontraktu |
| Budżet render CPU | Nie znaleziono | brak kontraktu |
| Budżet render GPU | Nie znaleziono | brak kontraktu |
| Budżet canvas items/primitives/draw calls/wierzchołków | Nie znaleziono | brak kontraktu |
| Budżet pamięci lub kosztu produkcji ręcznych kadrów/animacji | Nie znaleziono | brak kontraktu |
| `16.667 ms` jako limit | Nie ustanowiono; nie będzie wyprowadzane z 60 Hz | konwersja matematyczna, nie dowód |

Historyczne wpisy pakietów w `SESSION_LOG.md` opisują wcześniejsze pomiary i
braki kontraktu, ale nie są nową decyzją budżetową. `DECISION_LOG.md` nie
dostanie progu dopisanego wyłącznie po to, aby awansować H-005.

## 4. Protokół pomiaru

1. Zachować `tools/audit_h005.gd` jako jedyne źródło logiki pomiaru. Zmiana,
   jeśli potrzebna wyłącznie do rozdzielenia wyjścia PKG-0110 od
   `reports/pkg_0109`, może dotyczyć tylko parametrów harnessu; domyślne
   wyjście PKG-0109 pozostaje niezmienione.
2. Uruchomić dwa razy w niezależnych świeżych procesach normalnego Godot 4.7
   na Windows/OpenGL/Intel Iris Xe, bez `--headless` i bez zmian produktu.
3. Zapisać osobne katalogi `reports/pkg_0110/run_01/` i
   `reports/pkg_0110/run_02/`, każde z `metadata.json`, `summary.json` oraz
   pełnymi tabelami TSV. Nie nadpisywać `reports/pkg_0109/`.
4. Dla dziewięciu wymaganych kadrów porównać `frame_interval_ms`,
   `render_cpu_ms`, `render_gpu_ms`, `frame_setup_cpu_ms`, canvas items,
   primitives i draw calls. Zachować mean, median, p95 oraz liczność próby.
5. Porównać pełny cykl Station 02, w tym `full_world` i
   `no_player_and_shadow`, oraz wszystkie tryby komponentów już obecne w
   harnessie.
6. Sprawdzić zgodność metadanych: liczba próbek, warmup, odrzucone klatki,
   renderer, sterownik, viewport, V-Sync i `Engine.max_fps`.
7. Nie zmieniać timeoutów, retry, workerów, progów ani bramek projektu.
   Jeśli metryka okaże się niedostępna lub nielogiczna, najpierw zweryfikować
   jej źródło w Godot 4.7, a dopiero potem wykonać minimalną zmianę harnessu i
   powtórzyć przebieg przed/po. Dotychczasowy PKG-0109 raportuje dostępne,
   logiczne metryki, więc planem domyślnym jest brak zmian w kodzie pomiaru.

## 5. Plan interpretacji

Stabilność pomiaru zostanie opisana jako własność danych: identyczna
konfiguracja procesu i sprzętu, pełna liczność próbek, dostępność metryk oraz
powtarzalne wartości dyskretnych canvas metrics. Dla czasów zostaną pokazane
mean/median/p95 i różnice między przebiegami; nie zostanie wprowadzony
arbitralny próg jakości produktu tylko na potrzeby tego audytu.

Raport końcowy rozdzieli:

- istniejące wymaganie produktu od formalnego budżetu subsystemu;
- budżet okresu klatki od CPU/GPU, canvas metrics i kosztu pracy artystycznej;
- dowód z aktualnego pliku od historycznej sugestii i konwersji 60 Hz;
- powtarzalność na jednym profilu od generalizacji na inne GPU.

H-005 pozostanie `TECHNICAL`, jeśli po porównaniu nadal nie będzie jawnego
budżetu istniejącego przed pomiarem. Status `MEASURED` jest dopuszczalny tylko
przy uprzednio ustanowionym budżecie i bezpośrednim dowodzie jego spełnienia;
dwa świeże procesy same w sobie nie wystarczą.

## 6. Ograniczenia i artefakty planowane

- jeden profil sprzętowy: Windows/OpenGL, Intel Iris Xe; brak drugiego GPU;
- brak zewnętrznych playtestów i brak dowodu odbiorczego;
- inventory 45 zasobów mapujących się na 43 przestrzenie nie zastępuje
  bezpośredniego pomiaru pozostałych kadrów;
- brak formalnego budżetu pozostanie wynikiem, jeśli dokumentacja nadal go nie
  zawiera;
- planowane artefakty: `reports/pkg_0110/run_01/`,
  `reports/pkg_0110/run_02/` oraz końcowa tabela różnic w tym raporcie.

## 7. Wykonanie pomiaru

Żadna metryka nie była niedostępna ani nielogiczna, więc nie zmieniano źródła
pomiaru, próbki, timeoutów, retry, workerów, progów ani bramek. W harnessie
dodano wyłącznie opcjonalne argumenty rozdzielające katalog i etykietę pakietu;
bez argumentów zachowuje on domyślne `res://reports/pkg_0109` i `PKG-0109`.
To jest zmiana instrumentacji wyjścia, nie produktu.

Uruchomienia wykonano w dwóch niezależnych świeżych procesach:

```powershell
godot_console.exe --path C:\getting_strange --script res://tools/audit_h005.gd -- --audit-output-root=res://reports/pkg_0110/run_01 --audit-package=PKG-0110-RUN-01
godot_console.exe --path C:\getting_strange --script res://tools/audit_h005.gd -- --audit-output-root=res://reports/pkg_0110/run_02 --audit-package=PKG-0110-RUN-02
```

| przebieg | wynik procesu | zasoby inventory | wiersze statyczne | agregaty cyklu | katalog |
|---|---|---:|---:|---:|---|
| `run_01` | `PKG-0110-RUN-01 AUDIT PASS` | 45 | 22 | 5 | `reports/pkg_0110/run_01/` |
| `run_02` | `PKG-0110-RUN-02 AUDIT PASS` | 45 | 22 | 5 | `reports/pkg_0110/run_02/` |

Metadane obu procesów są zgodne: Godot `4.7-stable (official)`, Windows,
`gl_compatibility`, `opengl3`, Intel Iris Xe Graphics, API `3.3.0 - Build
32.0.101.7085`, viewport `640x360`, fizyka `60`, V-Sync `disabled by harness
only`, `Engine.max_fps = 0`, warmup `60`, próbka statyczna `120`, cykl `220`,
pomiar `RenderingServer.viewport_set_measure_render_time`. Po odrzuceniu dwóch
pierwszych klatek RenderingServer każdy wiersz statyczny ma 118 ważnych próbek,
a każdy tryb cyklu ma 218 ważnych próbek.

Wszystkie wymagane metryki `frame_interval_ms`, `render_cpu_ms`,
`render_gpu_ms`, `frame_setup_cpu_ms`, `canvas_items`, `canvas_primitives` i
`canvas_draw_calls` mają status `available` w obu przebiegach.

## 8. Porównanie dziewięciu wymaganych kadrów świata

Wartości czasowe są w milisekundach. W kolumnach `run` podano kolejno
`mean / mediana / p95`; `delta` oznacza `run_02 - run_01`. Metryki canvas są
liczbami na klatkę. Tabela obejmuje `full_world`; Station 02 jako dodatkowy
przypadek z `DiscontinuousShadow` jest porównany w następnym rozdziale.

| scena | metryka | run_01 mean / mediana / p95 | run_02 mean / mediana / p95 | delta mean / mediana / p95 | count 01 / 02 |
|---|---|---:|---:|---:|---:|
| station_01 | frame_interval_ms | 2.594 / 2.020 / 6.219 | 1.912 / 1.576 / 2.995 | -0.682 / -0.444 / -3.224 | 118 / 118 |
| station_01 | render_cpu_ms | 0.780 / 0.789 / 1.138 | 0.646 / 0.600 / 0.915 | -0.134 / -0.189 / -0.223 | 118 / 118 |
| station_01 | render_gpu_ms | 0.989 / 0.655 / 1.599 | 0.672 / 0.640 / 1.099 | -0.318 / -0.015 / -0.500 | 118 / 118 |
| station_01 | frame_setup_cpu_ms | 0.008 / 0.007 / 0.013 | 0.006 / 0.005 / 0.010 | -0.002 / -0.002 / -0.003 | 118 / 118 |
| station_01 | canvas_items | 157.000 / 157.000 / 157.000 | 157.000 / 157.000 / 157.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_01 | canvas_primitives | 1636.000 / 1636.000 / 1636.000 | 1636.000 / 1636.000 / 1636.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_01 | canvas_draw_calls | 98.000 / 98.000 / 98.000 | 98.000 / 98.000 / 98.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_14 | frame_interval_ms | 3.089 / 2.489 / 6.308 | 2.583 / 2.187 / 6.480 | -0.506 / -0.302 / 0.172 | 118 / 118 |
| station_14 | render_cpu_ms | 0.864 / 0.824 / 1.392 | 0.748 / 0.711 / 1.080 | -0.116 / -0.113 / -0.312 | 118 / 118 |
| station_14 | render_gpu_ms | 1.410 / 0.692 / 8.997 | 0.955 / 0.676 / 1.696 | -0.455 / -0.016 / -7.301 | 118 / 118 |
| station_14 | frame_setup_cpu_ms | 0.009 / 0.008 / 0.017 | 0.008 / 0.007 / 0.020 | -0.001 / -0.001 / 0.003 | 118 / 118 |
| station_14 | canvas_items | 208.000 / 208.000 / 208.000 | 208.000 / 208.000 / 208.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_14 | canvas_primitives | 2556.000 / 2556.000 / 2556.000 | 2556.000 / 2556.000 / 2556.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_14 | canvas_draw_calls | 117.000 / 117.000 / 117.000 | 117.000 / 117.000 / 117.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_22 | frame_interval_ms | 2.655 / 2.236 / 5.223 | 2.679 / 1.979 / 7.801 | 0.025 / -0.257 / 2.578 | 118 / 118 |
| station_22 | render_cpu_ms | 0.778 / 0.750 / 1.210 | 0.706 / 0.634 / 1.100 | -0.072 / -0.116 / -0.110 | 118 / 118 |
| station_22 | render_gpu_ms | 0.897 / 0.695 / 1.458 | 1.229 / 0.718 / 8.531 | 0.332 / 0.023 / 7.073 | 118 / 118 |
| station_22 | frame_setup_cpu_ms | 0.008 / 0.007 / 0.015 | 0.008 / 0.007 / 0.020 | 0.000 / 0.000 / 0.005 | 118 / 118 |
| station_22 | canvas_items | 152.508 / 153.000 / 153.000 | 152.508 / 153.000 / 153.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_22 | canvas_primitives | 1559.017 / 1560.000 / 1560.000 | 1559.017 / 1560.000 / 1560.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_22 | canvas_draw_calls | 105.000 / 105.000 / 105.000 | 105.000 / 105.000 / 105.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_38 | frame_interval_ms | 2.354 / 2.006 / 4.183 | 2.513 / 1.938 / 7.637 | 0.159 / -0.068 / 3.454 | 118 / 118 |
| station_38 | render_cpu_ms | 0.706 / 0.667 / 1.116 | 0.690 / 0.655 / 0.988 | -0.016 / -0.012 / -0.128 | 118 / 118 |
| station_38 | render_gpu_ms | 1.074 / 0.719 / 2.300 | 1.152 / 0.703 / 2.897 | 0.078 / -0.016 / 0.597 | 118 / 118 |
| station_38 | frame_setup_cpu_ms | 0.008 / 0.007 / 0.013 | 0.008 / 0.006 / 0.012 | 0.000 / -0.001 / -0.001 | 118 / 118 |
| station_38 | canvas_items | 163.000 / 163.000 / 163.000 | 163.000 / 163.000 / 163.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_38 | canvas_primitives | 1536.000 / 1536.000 / 1536.000 | 1536.000 / 1536.000 / 1536.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_38 | canvas_draw_calls | 105.000 / 105.000 / 105.000 | 105.000 / 105.000 / 105.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_41 | frame_interval_ms | 2.911 / 2.482 / 5.290 | 3.094 / 2.500 / 7.451 | 0.183 / 0.018 / 2.161 | 118 / 118 |
| station_41 | render_cpu_ms | 0.797 / 0.720 / 1.354 | 0.833 / 0.782 / 1.225 | 0.036 / 0.062 / -0.129 | 118 / 118 |
| station_41 | render_gpu_ms | 1.338 / 0.892 / 2.125 | 1.282 / 0.724 / 9.664 | -0.056 / -0.168 / 7.539 | 118 / 118 |
| station_41 | frame_setup_cpu_ms | 0.008 / 0.007 / 0.016 | 0.009 / 0.008 / 0.017 | 0.001 / 0.001 / 0.001 | 118 / 118 |
| station_41 | canvas_items | 209.000 / 209.000 / 209.000 | 209.000 / 209.000 / 209.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_41 | canvas_primitives | 2320.000 / 2320.000 / 2320.000 | 2320.000 / 2320.000 / 2320.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_41 | canvas_draw_calls | 125.000 / 125.000 / 125.000 | 125.000 / 125.000 / 125.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_42a | frame_interval_ms | 2.103 / 1.685 / 6.256 | 1.659 / 1.422 / 2.979 | -0.444 / -0.263 / -3.277 | 118 / 118 |
| station_42a | render_cpu_ms | 0.627 / 0.577 / 0.962 | 0.559 / 0.518 / 0.819 | -0.069 / -0.059 / -0.143 | 118 / 118 |
| station_42a | render_gpu_ms | 0.783 / 0.577 / 1.782 | 0.748 / 0.592 / 1.132 | -0.036 / 0.015 / -0.650 | 118 / 118 |
| station_42a | frame_setup_cpu_ms | 0.008 / 0.006 / 0.014 | 0.007 / 0.006 / 0.011 | -0.001 / 0.000 / -0.003 | 118 / 118 |
| station_42a | canvas_items | 94.000 / 94.000 / 94.000 | 94.000 / 94.000 / 94.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_42a | canvas_primitives | 540.000 / 540.000 / 540.000 | 540.000 / 540.000 / 540.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_42a | canvas_draw_calls | 69.000 / 69.000 / 69.000 | 69.000 / 69.000 / 69.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_42b | frame_interval_ms | 1.695 / 1.598 / 2.492 | 1.664 / 1.376 / 3.037 | -0.031 / -0.222 / 0.545 | 118 / 118 |
| station_42b | render_cpu_ms | 0.578 / 0.539 / 0.967 | 0.548 / 0.525 / 0.769 | -0.030 / -0.014 / -0.198 | 118 / 118 |
| station_42b | render_gpu_ms | 0.867 / 0.683 / 1.801 | 0.763 / 0.582 / 0.992 | -0.104 / -0.101 / -0.809 | 118 / 118 |
| station_42b | frame_setup_cpu_ms | 0.007 / 0.006 / 0.012 | 0.007 / 0.006 / 0.012 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_42b | canvas_items | 93.000 / 93.000 / 93.000 | 93.000 / 93.000 / 93.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_42b | canvas_primitives | 620.000 / 620.000 / 620.000 | 620.000 / 620.000 / 620.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_42b | canvas_draw_calls | 69.000 / 69.000 / 69.000 | 69.000 / 69.000 / 69.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_42c | frame_interval_ms | 2.118 / 1.729 / 4.542 | 2.087 / 1.560 / 7.140 | -0.031 / -0.169 / 2.598 | 118 / 118 |
| station_42c | render_cpu_ms | 0.671 / 0.649 / 1.015 | 0.588 / 0.547 / 0.855 | -0.083 / -0.102 / -0.160 | 118 / 118 |
| station_42c | render_gpu_ms | 0.852 / 0.588 / 1.627 | 1.005 / 0.582 / 1.490 | 0.152 / -0.006 / -0.137 | 118 / 118 |
| station_42c | frame_setup_cpu_ms | 0.008 / 0.007 / 0.014 | 0.008 / 0.006 / 0.020 | 0.001 / -0.001 / 0.006 | 118 / 118 |
| station_42c | canvas_items | 111.000 / 111.000 / 111.000 | 111.000 / 111.000 / 111.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_42c | canvas_primitives | 839.000 / 839.000 / 839.000 | 839.000 / 839.000 / 839.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_42c | canvas_draw_calls | 70.000 / 70.000 / 70.000 | 70.000 / 70.000 / 70.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_43 | frame_interval_ms | 2.026 / 1.697 / 4.707 | 2.247 / 1.660 / 7.049 | 0.221 / -0.037 / 2.342 | 118 / 118 |
| station_43 | render_cpu_ms | 0.619 / 0.595 / 1.024 | 0.581 / 0.544 / 0.827 | -0.038 / -0.051 / -0.197 | 118 / 118 |
| station_43 | render_gpu_ms | 0.952 / 0.632 / 1.948 | 0.838 / 0.630 / 1.859 | -0.113 / -0.002 / -0.089 | 118 / 118 |
| station_43 | frame_setup_cpu_ms | 0.008 / 0.007 / 0.017 | 0.007 / 0.007 / 0.013 | -0.000 / 0.000 / -0.004 | 118 / 118 |
| station_43 | canvas_items | 123.000 / 123.000 / 123.000 | 123.000 / 123.000 / 123.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_43 | canvas_primitives | 678.000 / 678.000 / 678.000 | 678.000 / 678.000 / 678.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |
| station_43 | canvas_draw_calls | 73.000 / 73.000 / 73.000 | 73.000 / 73.000 / 73.000 | 0.000 / 0.000 / 0.000 | 118 / 118 |

## 9. Porównanie pełnego cyklu Station 02

Cykl ma 220 kroków sterowanych istniejącym `InputMap`; po odrzuceniu dwóch
pierwszych klatek RenderingServer pozostaje 218 próbek w każdym trybie i obu
przebiegach. Tak samo jak wyżej, `delta = run_02 - run_01`, a czasy są w
milisekundach.

| tryb Station 02 | metryka | run_01 mean / mediana / p95 | run_02 mean / mediana / p95 | delta mean / mediana / p95 | count 01 / 02 |
|---|---|---:|---:|---:|---:|
| full_world | frame_interval_ms | 2.152 / 1.719 / 4.490 | 2.073 / 1.558 / 6.545 | -0.078 / -0.161 / 2.055 | 218 / 218 |
| full_world | render_cpu_ms | 0.631 / 0.612 / 0.934 | 0.592 / 0.543 / 0.933 | -0.039 / -0.069 / -0.001 | 218 / 218 |
| full_world | render_gpu_ms | 0.854 / 0.594 / 1.593 | 0.800 / 0.555 / 1.663 | -0.054 / -0.039 / 0.070 | 218 / 218 |
| full_world | frame_setup_cpu_ms | 0.008 / 0.006 / 0.015 | 0.007 / 0.006 / 0.011 | -0.002 / 0.000 / -0.004 | 218 / 218 |
| full_world | canvas_items | 109.619 / 102.000 / 121.000 | 107.991 / 102.000 / 121.000 | -1.628 / 0.000 / 0.000 | 218 / 218 |
| full_world | canvas_primitives | 815.908 / 752.000 / 932.000 | 803.523 / 752.000 / 932.000 | -12.385 / 0.000 / 0.000 | 218 / 218 |
| full_world | canvas_draw_calls | 73.358 / 72.000 / 76.000 | 73.106 / 72.000 / 76.000 | -0.252 / 0.000 / 0.000 | 218 / 218 |
| no_dust | frame_interval_ms | 2.166 / 1.815 / 5.105 | 2.140 / 1.642 / 7.166 | -0.026 / -0.173 / 2.061 | 218 / 218 |
| no_dust | render_cpu_ms | 0.672 / 0.655 / 1.000 | 0.599 / 0.557 / 0.925 | -0.073 / -0.098 / -0.075 | 218 / 218 |
| no_dust | render_gpu_ms | 0.791 / 0.563 / 1.320 | 0.800 / 0.554 / 1.210 | 0.009 / -0.009 / -0.110 | 218 / 218 |
| no_dust | frame_setup_cpu_ms | 0.007 / 0.006 / 0.013 | 0.007 / 0.006 / 0.011 | -0.001 / 0.000 / -0.002 | 218 / 218 |
| no_dust | canvas_items | 108.936 / 102.000 / 120.000 | 108.440 / 102.000 / 120.000 | -0.495 / 0.000 / 0.000 | 218 / 218 |
| no_dust | canvas_primitives | 807.486 / 752.000 / 896.000 | 803.523 / 752.000 / 896.000 | -3.963 / 0.000 / 0.000 | 218 / 218 |
| no_dust | canvas_draw_calls | 73.156 / 72.000 / 75.000 | 73.073 / 72.000 / 75.000 | -0.083 / 0.000 / 0.000 | 218 / 218 |
| no_dust_and_shadow | frame_interval_ms | 2.062 / 1.655 / 5.098 | 2.080 / 1.530 / 7.575 | 0.018 / -0.125 / 2.477 | 218 / 218 |
| no_dust_and_shadow | render_cpu_ms | 0.636 / 0.602 / 1.064 | 0.598 / 0.558 / 0.865 | -0.038 / -0.044 / -0.199 | 218 / 218 |
| no_dust_and_shadow | render_gpu_ms | 0.874 / 0.569 / 1.700 | 0.904 / 0.585 / 1.831 | 0.031 / 0.016 / 0.131 | 218 / 218 |
| no_dust_and_shadow | frame_setup_cpu_ms | 0.007 / 0.006 / 0.013 | 0.007 / 0.006 / 0.012 | 0.001 / 0.000 / -0.001 | 218 / 218 |
| no_dust_and_shadow | canvas_items | 107.349 / 100.000 / 118.000 | 106.193 / 100.000 / 118.000 | -1.156 / 0.000 / 0.000 | 218 / 218 |
| no_dust_and_shadow | canvas_primitives | 782.789 / 724.000 / 868.000 | 773.541 / 724.000 / 868.000 | -9.248 / 0.000 / 0.000 | 218 / 218 |
| no_dust_and_shadow | canvas_draw_calls | 71.225 / 70.000 / 73.000 | 71.032 / 70.000 / 73.000 | -0.193 / 0.000 / 0.000 | 218 / 218 |
| no_player_and_shadow | frame_interval_ms | 1.607 / 1.248 / 2.202 | 1.741 / 1.225 / 6.872 | 0.134 / -0.023 / 4.670 | 218 / 218 |
| no_player_and_shadow | render_cpu_ms | 0.533 / 0.502 / 0.784 | 0.535 / 0.485 / 0.831 | 0.003 / -0.017 / 0.047 | 218 / 218 |
| no_player_and_shadow | render_gpu_ms | 0.795 / 0.531 / 1.220 | 0.896 / 0.527 / 1.545 | 0.101 / -0.004 / 0.325 | 218 / 218 |
| no_player_and_shadow | frame_setup_cpu_ms | 0.006 / 0.006 / 0.012 | 0.007 / 0.006 / 0.013 | 0.000 / 0.000 / 0.001 | 218 / 218 |
| no_player_and_shadow | canvas_items | 83.138 / 80.000 / 98.000 | 83.633 / 80.000 / 98.000 | 0.495 / 0.000 / 0.000 | 218 / 218 |
| no_player_and_shadow | canvas_primitives | 621.101 / 596.000 / 740.000 | 625.064 / 596.000 / 740.000 | 3.963 / 0.000 / 0.000 | 218 / 218 |
| no_player_and_shadow | canvas_draw_calls | 53.523 / 53.000 / 56.000 | 53.606 / 53.000 / 56.000 | 0.083 / 0.000 / 0.000 | 218 / 218 |
| no_shadow | frame_interval_ms | 1.928 / 1.615 / 5.495 | 1.751 / 1.490 / 2.548 | -0.177 / -0.125 / -2.947 | 218 / 218 |
| no_shadow | render_cpu_ms | 0.635 / 0.595 / 0.938 | 0.581 / 0.557 / 0.771 | -0.054 / -0.038 / -0.167 | 218 / 218 |
| no_shadow | render_gpu_ms | 0.734 / 0.517 / 1.250 | 0.721 / 0.563 / 0.960 | -0.013 / 0.046 / -0.290 | 218 / 218 |
| no_shadow | frame_setup_cpu_ms | 0.008 / 0.006 / 0.016 | 0.008 / 0.006 / 0.013 | -0.000 / 0.000 / -0.003 | 218 / 218 |
| no_shadow | canvas_items | 106.615 / 101.000 / 119.000 | 105.459 / 101.000 / 119.000 | -1.156 / 0.000 / 0.000 | 218 / 218 |
| no_shadow | canvas_primitives | 804.917 / 760.000 / 904.000 | 795.670 / 760.000 / 904.000 | -9.248 / 0.000 / 0.000 | 218 / 218 |
| no_shadow | canvas_draw_calls | 71.936 / 71.000 / 74.000 | 71.743 / 71.000 / 74.000 | -0.193 / 0.000 / 0.000 | 218 / 218 |

## 10. Interpretacja powtarzalności

Powtarzalność ma dwa różne wyniki, których nie należy mieszać:

- **Kontrakt strukturalny jest powtarzalny.** Wszystkie 9 wymaganych kadrów
  mają po 118 próbek w obu procesach, a `canvas_items`, `canvas_primitives` i
  `canvas_draw_calls` są identyczne w mean, medianie i p95. W pełnym cyklu
  wszystkie 5 trybów mają po 218 próbek; ich mediany i p95 canvas metrics są
  zgodne, a różnice średnich wynikają z rozkładu faz cyklu i efektów
  proceduralnych.
- **Czasy nie są identyczne między świeżymi procesami.** W dziewięciu kadrach
  największe bezwzględne różnice średnich wyniosły: `frame_interval_ms`
  `-0.682 ms` (Station 01), `render_cpu_ms` `-0.134 ms` (Station 01),
  `render_gpu_ms` `-0.455 ms` (Station 14) i `frame_setup_cpu_ms` `-0.002 ms`
  (Station 01). Największe bezwzględne różnice p95 wyniosły odpowiednio
  `+3.454 ms` dla interwału klatki (Station 38), `-0.312 ms` dla CPU (Station
  14), `+7.539 ms` dla GPU (Station 41) i `+0.006 ms` dla frame setup (Station
  42C). To jest obserwowana zmienność próby, a nie dowód regresji ani budżet.

Kryterium stabilności użyte w tym raporcie jest własnością danych, nie
arbitralnym progiem produktu: oba procesy mają ten sam renderer, sterownik,
sprzęt, viewport i parametry próbkowania; wszystkie wymagane wiersze i metryki
są dostępne; liczby canvas opisujące statyczną geometrię powtarzają się
dokładnie; czasy są raportowane w całości wraz z mean/medianą/p95, także gdy
różnią się między procesami. Nie uznano żadnej różnicy czasowej za „wystarczająco
małą” na podstawie nowego, niezatwierdzonego limitu.

## 11. Decyzja H-005

H-005 pozostaje **`TECHNICAL`**.

PKG-0110 potwierdził powtarzalność strukturalnych metryk oraz dostarczył drugi
świeży pomiar czasów na tym samym profilu Windows/OpenGL/Intel Iris Xe, ale nie
stworzył formalnego budżetu, którego można by dowieść. Aktualne źródła nadal
mają wymaganie 60 FPS, viewport `640x360` i fizykę 60 Hz, lecz nie mają
zaakceptowanego limitu czasu klatki, render CPU/GPU, canvas metrics,
wierzchołków, pamięci ani czasu produkcji. Nie zmieniono statusu na
`MEASURED`, nie dopisano progu do `DECISION_LOG.md` i nie wyprowadzono
`16.667 ms` z 60 Hz jako budżetu.

## 12. Ograniczenia i artefakty końcowe

- pomiar obejmuje jeden fizyczny profil: Windows/OpenGL, Intel Iris Xe;
  powtarzalność nie jest testem drugiego GPU ani generalizacją sprzętową;
- automaty nie dowodzą odbioru, czytelności przez nową osobę, funu, emocji ani
  zrozumienia fabuły; brak playtestu pozostaje jawny;
- inventory obejmuje 45 zasobów mapujących się na 43 przestrzenie, ale nie jest
  bezpośrednim pomiarem czasu pozostałych 35 zasobów;
- brak formalnego budżetu kosztu produkcji ręcznych kadrów i animacji pozostaje
  nierozstrzygnięty;
- nie zmieniono kodu gry, scen, assetów, colliderów, mechaniki, dialogów,
  rozgałęzień, InputMap, fizyki 60 Hz, limitu kampanii 25 ani zapisu 1;
- dowody PKG-0109 w `reports/pkg_0109/` pozostały nietknięte;
- nowe dane: `reports/pkg_0110/run_01/` i `reports/pkg_0110/run_02/`;
- metadane obu przebiegów są w odpowiednich `metadata.json`, a pełne surowe
  próbki i agregaty w `summary.json` oraz tabelach TSV;
- zmiana harnessu jest ograniczona do parametrów katalogu/etykiety wyjścia;
  domyślna ścieżka PKG-0109 zachowuje dotychczasową wartość.

## 13. Weryfikacja końcowa

Po zapisaniu raportu, stanu, ryzyka, indeksu, roadmapy i nowego promptu
uruchomiono:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Wynik: **PASS, exit code 0, `Verification passed.`** `DOCS PASS` potwierdził
27 wymaganych plików i kontraktów handoffu; import Godot, smoke projektu,
traversal lint i bramki `PKG-0095`–`PKG-0107` również przeszły. Ostrzeżenia
`ObjectDB`/`RID leak` przy zamykaniu procesów pozostały znanym szumem i nie
zmieniły kodu wyjścia.
