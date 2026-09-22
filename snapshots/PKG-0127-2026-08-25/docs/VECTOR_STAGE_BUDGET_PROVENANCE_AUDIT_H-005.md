# Audyt pochodzenia formalnego budżetu Rówień Vector-Stage — H-005

Status: **TECHNICAL — brak uprzedniego, liczbowego budżetu porównawczego**  
Data: 2026-08-24  
Pakiet: `PKG-0111`  
Zakres: read-only wobec produktu Godot; audyt dokumentów, decyzji, harnessu i
danych pomiarowych bez zmiany scen, assetów, runtime'u, bramek ani progów.

## 1. Wniosek

Nie znaleziono wiarygodnego, uprzedniego źródła formalnego budżetu H-005.
Aktualny projekt wymaga stabilnych 60 FPS, używa logicznego viewportu
`640x360` i symulacji fizyki `60 Hz`, ale żaden z tych zapisów nie ustanawia
liczbowego limitu czasu klatki, renderu CPU/GPU, canvas metrics, wierzchołków,
pamięci ani ręcznego kosztu produkcji.

`16.667 ms` nie jest wcześniejszym kontraktem. Jest tylko wynikiem matematycznej
konwersji `1000 / 60`; nie ma źródła akceptującego tę liczbę jako budżet
subsystemu, nie określa zakresu dowodu i nie ma przypisanej metody spełnienia.

H-005 pozostaje **`TECHNICAL`**. PKG-0109 i PKG-0110 dostarczyły pomiaru oraz
powtarzalności danych na jednym profilu sprzętowym, lecz nie mogą retroaktywnie
ustanowić budżetu, który miał istnieć przed pomiarem.

## 2. Warunek uznania kandydata za kontrakt

Kandydat mógłby być formalnym budżetem tylko wtedy, gdy przed pomiarem miał:

1. jednoznaczne źródło i datowalne pochodzenie;
2. liczbowy limit lub jawny model kosztu;
3. określony zakres (cała klatka, render CPU/GPU, canvas metrics, pamięć albo
   praca produkcyjna);
4. metodę bezpośredniego sprawdzenia oraz warunek zaliczenia.

Brak któregokolwiek elementu klasyfikuje zapis jako wymaganie produktu, parametr
wejściowy, cel jakościowy, hipotezę, historyczną obserwację albo zwykłą
konwersję — nie jako budżet H-005.

## 3. Zakres dowodu i baseline

Przed audytem uruchomiono bez zmian:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Wynik: **PASS, exit code 0, `Verification passed.`** Przeszły kontrakt
dokumentacji, import Godot, smoke projektu, traversal lint oraz bramki
`PKG-0095`–`PKG-0107`. Znane ostrzeżenia `ObjectDB`/`RID leak` przy zamykaniu
procesów nie zmieniły kodu wyjścia.

Odczytano i porównano:

- `docs/TECHNICAL_DIRECTION.md`, `docs/ROADMAP.md`,
  `docs/RISKS_AND_HYPOTHESES.md`, `docs/DECISION_LOG.md` i `docs/WORKFLOW.md`;
- `VISUAL_DESIGN.md`, `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`, aktywną
  `docs/narrative/NARRATIVE_BIBLE.md`, `docs/CURRENT_STATE.md`,
  `docs/NEXT_SESSION_PROMPT.md` i `docs/SESSION_LOG.md`;
- `docs/VECTOR_STAGE_COST_AUDIT_H-005.md`,
  `docs/VECTOR_STAGE_REPEATABILITY_AUDIT_H-005.md`,
  `tools/audit_h005.gd` oraz wyszczególnione przez nie dane;
- `reports/pkg_0110/run_01/metadata.json`, `summary.json`,
  `reports/pkg_0110/run_02/metadata.json`, `summary.json` i źródła konfiguracji
  projektu `project.godot`.

Wyszukanie wykonano bez redukowania wyniku, między innymi dla:

```powershell
rg -n -i "budget|budżet|60 FPS|frame|render|CPU|GPU|draw call|wierzchoł|memory|production cost|16\.667|milisekund|ms|klat" docs scripts scenes project.godot tests tools --glob '!reports/**' --glob '!snapshots/**'
rg -n -i "budget|budżet" docs --glob '*.md'
rg -n -i "60[ -]?FPS|60 Hz|640x360|16\.667" docs scripts scenes project.godot tests tools --glob '!reports/**' --glob '!snapshots/**'
```

## 4. Macierz provenance kandydatów

| Kandydat | Źródło na dysku | Co faktycznie ustanawia | Klasyfikacja H-005 |
|---|---|---|---|
| Stabilne 60 FPS | `docs/TECHNICAL_DIRECTION.md`, P3 w `docs/ROADMAP.md`, aktualny handoff | Cel/wymaganie produktu dla runtime'u; brak limitu subsystemu, zakresu próbki i kryterium spełnienia | wymaganie produktu, nie budżet |
| Logiczny viewport `640x360` | `docs/TECHNICAL_DIRECTION.md`, `project.godot`, `tools/audit_h005.gd` | Rozmiar logicznego wejścia i kontekst kompozycji/pomiaru | parametr wejściowy, nie budżet czasu |
| Fizyka `60 Hz` | `docs/TECHNICAL_DIRECTION.md`, metadane harnessu i konfiguracja runtime'u | Częstotliwość symulacji fizycznej | kontrakt symulacji, nie budżet renderu |
| P3: zmierzony koszt jednego kadru i animacji | `docs/ROADMAP.md` oraz `docs/RISKS_AND_HYPOTHESES.md` | Pytanie bramki i kierunek dowodu; nie podaje liczby, zakresu produkcji ani progu | cel audytowy, nie budżet |
| Budżet ręcznej konwersji 43 kadrów | `VISUAL_DESIGN.md` §12, `NARRATIVE_BIBLE.md` §15, R-002/H-005 | Jawnie wskazane nierozstrzygnięte ryzyko; brak modelu godzin, limitu lub źródła | brak kontraktu produkcyjnego |
| Budżet trudności/przeszkód | `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` | Zasady liczby decyzji i okien korekty dla traversal; nie koszt renderu ani pracy artystycznej | inny subsystem |
| Budżet nowych przeszkód `0` | D-108 i audyt finałów | Liczba nowych przeszkód w jednym pakiecie; nie budżet wydajności ani produkcji | inny zakres |
| Pomiary PKG-0109/0110 | `docs/VECTOR_STAGE_COST_AUDIT_H-005.md`, `docs/VECTOR_STAGE_REPEATABILITY_AUDIT_H-005.md`, `reports/pkg_0110/` | Obserwowany koszt i powtarzalność aktualnego runtime'u po rozpoczęciu audytu | dowód obserwacji, nie wcześniejszy budżet |
| `16.667 ms` | Brak wcześniejszego trafienia kontraktowego; liczba pojawia się wyłącznie jako odrzucona konwersja w audytach i handoffie | `1000 / 60`, bez właściciela, zakresu i testu zaliczenia | konwersja matematyczna, nie budżet |

W `DECISION_LOG.md` nie ma decyzji ustanawiającej próg H-005. Trafienia
„budżetowe” w tym pliku dotyczą innych spraw, między innymi liczby nowych
przeszkód w D-108; nie są limitem renderu ani kosztem produkcji Vector-Stage.

## 5. Co potwierdzają dane PKG-0110

Oba pliki `metadata.json` opisują ten sam profil: Godot `4.7-stable`, Windows,
`gl_compatibility`/OpenGL, Intel Iris Xe, viewport `640x360`, fizyka `60`,
V-Sync wyłączony wyłącznie w harnessie, `Engine.max_fps = 0`, warmup `60`,
próbka `120` i cykl `220`. Każdy `summary.json` zawiera 45 zasobów inventory,
22 wiersze pomiarów statycznych, 5 agregatów cyklu i 36 różnic komponentów.

To pozwala stwierdzić, że oba świeże procesy miały zgodne parametry oraz że
raportowana struktura danych jest powtarzalna na tym jednym profilu. Nie pozwala
stwierdzić spełnienia budżetu, bo żaden uprzedni budżet nie został znaleziony.
Różnice czasów między procesami pozostają obserwacją, a nie nowym progiem.

## 6. Decyzja pakietu

- Nie zmieniono scen, assetów, colliderów, mechaniki, dialogów, animacji,
  rendererów produktu, InputMap, fizyki, limitu kampanii `25`,
  `SAVE_SCHEMA_VERSION = 1`, rozgałęzień ani istniejących bramek.
- Nie zmieniono `tools/audit_h005.gd`; instrumentacja PKG-0110 i dane obu
  przebiegów pozostają nienaruszone.
- Nie dopisano progu do `DECISION_LOG.md` i nie podniesiono H-005 do
  `MEASURED`.
- Nie przyjęto zewnętrznego źródła budżetu. Linki do dokumentacji Godot 4.7 w
  raporcie PKG-0109 definiują API pomiarowe, nie ustanawiają budżetu projektu.

Wynik: H-005 pozostaje **`TECHNICAL`** do czasu pojawienia się uprzedniego,
wiarygodnego budżetu oraz bezpośredniego pomiaru spełnienia tego budżetu.

## 7. Ograniczenia

- Dane wykonano na jednym fizycznym profilu Windows/OpenGL/Intel Iris Xe; nie
  są generalizacją na inne GPU ani inne komputery.
- Inventory 45 zasobów mapujących się na 43 przestrzenie nie zastępuje
  bezpośredniego pomiaru wszystkich pozostałych kadrów.
- Nadal nie ma modelu czasu produkcji ręcznych kadrów, pose sheets ani pełnej
  animacji pięciu postaci.
- Brak zewnętrznych playtestów i dowodu odbiorczego pozostaje jawny; ten audyt
  nie dowodzi funu, emocji, czytelności przez nową osobę ani zrozumienia fabuły.

## 8. Artefakty

- ten raport: `docs/VECTOR_STAGE_BUDGET_PROVENANCE_AUDIT_H-005.md`;
- metoda pomiaru: `docs/VECTOR_STAGE_COST_AUDIT_H-005.md`;
- powtarzalność: `docs/VECTOR_STAGE_REPEATABILITY_AUDIT_H-005.md`;
- harness: `tools/audit_h005.gd`;
- dane: `reports/pkg_0110/run_01/` i `reports/pkg_0110/run_02/`;
- stan, ryzyko, roadmapa, log i prompt kontynuacji zostały zaktualizowane w
  tym samym pakiecie.
