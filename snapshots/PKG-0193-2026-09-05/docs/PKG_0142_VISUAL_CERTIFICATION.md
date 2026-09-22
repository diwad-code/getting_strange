# PKG-0142 — certyfikacja obrazu i prawa krawędź stacji 01

Data: 2026-08-30  
Status: **ZAMKNIĘTY TECHNICZNIE**  
Silnik: Godot 4.7.2, Compatibility/OpenGL, Intel Iris Xe  
Zakres: stacja 01 oraz normal-driver capture wszystkich 45 scen kampanii

## Cel i decyzja

Prawa część stacji 01 nie może być pustym czarnym klinem. Została
przepisana jako diegetyczna scenografia `airlock_bulkhead`: fasetowa obudowa
śluzy, okno inspekcyjne, panel serwisowy i szczelina drzwi. To warstwa
scenografii w `VectorStageEnvironment`; istniejące `ChamberDoor`, `AirlockZone`
i dynamiczna linia statusu nadal są właścicielami zachowania wyjścia.

Zmiana nie dodaje węzłów, colliderów, etykiet ani nowych czasowników gracza.
Skala pozostaje 640×360, kompozytor 320×180, a skala świata 1 m = 52 px.

## Dowód techniczny

Capture wykonano normalnym sterownikiem Windows/OpenGL, nie w trybie
headless, skryptem `tools/capture_pkg_0142.gd`:

- 45 kadrów świata w trybie `normal`;
- 45 kadrów świata w trybie `reduced-motion`;
- 8 kadrów dialogowych w każdym trybie: stacja 01 jako dowód §4.3 oraz
  reprezentatywne 33, 38, 41, 42A, 42B, 42C i 43;
- łącznie **106 plików PNG**, każdy 640×360;
- pary zapisane w `reports/pkg_0142/normal/` i `reports/pkg_0142/reduced/`;
- pomiar różnic 2×2 zapisany w
  `reports/pkg_0142_visual_capture_report.txt`.

Raport różnic podaje dla każdej pary liczbę próbek zmienionych powyżej progu,
średnią różnicę kanałów i maksimum. Jest to pomiar różnicy renderów, nie ocena
czytelności.

## Inspekcja ręczna

Obejrzano świeże kadry:

- `reports/pkg_0142/normal/station_01.png`;
- `reports/pkg_0142/reduced/station_01.png`;
- `reports/pkg_0142/normal/dialogue_station_01.png`;
- `reports/pkg_0142/reduced/dialogue_station_01.png`;
- pary normal/reduced dla dialogu: 33, 38, 41, 42A, 42B, 42C i 43.

W kadrach stacji 01 prawa krawędź ma teraz czytelną funkcję infrastrukturalną:
obudowa, okno i panel tworzą maszynę śluzy zamiast jednolitej pustki. Istniejący
podpis terminala pozostaje w paśmie 90–190, Lena zachowuje pełną sylwetkę nad
panelem CRT, a przejście pozostaje widoczne.

W obejrzanych parach reduced-motion zachowują scenografię, Lenę, ostre
etykiety, obiekty celu i dialog. Zmniejszenie dotyczy ruchu peryferyjnego:
modulacji świateł, dekoracyjnej emisji mikro-cząstek i wstrząsu kamery zgodnie
z D-151. Nie wyciągnięto z tego wniosku o komforcie ani o odbiorze przez ludzi.

## Bramki

- `tests/pkg_0142_smoke_test.gd`: PASS — rola stacji 01, brak nowych
  colliderów, pas etykiety oraz kontrakt `Camera`/`Player`/komora/snap 2 px na
  45 scen w obu trybach;
- `tests/traversal_lint_test.gd`: PASS — brak zakazanej geometrii arcade;
- `tools/geometry_audit.gd`: PASS w bazowej pełnej weryfikacji — próg 18 px;
- `tools/verify.ps1`: PASS przed zmianą oraz po wdrożeniu końcowym;
- `tools/snapshot.ps1 -Package PKG-0142`: wykonane po końcowej weryfikacji.

## Granice dowodu

Render dowodzi, że wskazana scenografia i warstwy są obecne w obrazie oraz że
wykonano porównanie obu trybów. Ręczna inspekcja jest inspekcją techniczną
prowadzącego projekt. Nie dowodzi czytelności dla zewnętrznego gracza, piękna,
ulgi przedsionkowej, zabawy, zrozumienia ani emocjonalnego odbioru. Te hipotezy
pozostają jawne zgodnie z ADR-003.
