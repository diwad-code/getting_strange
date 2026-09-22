# NEXT_SESSION_PROMPT — PKG-0110

## CEL SESJI

Domknąć techniczny łańcuch H-005: sprawdzić, czy w aktualnej dokumentacji
istnieje jawny liczbowy budżet renderu/CPU/GPU/canvas albo kosztu produkcji,
a następnie sprawdzić powtarzalność pomiaru `PKG-0109` w niezależnych świeżych
procesach. Nie wolno wymyślać budżetu po fakcie. Jeśli kontraktu nadal nie ma,
udokumentować brak jako wynik i pozostawić H-005 `TECHNICAL`; nie kończyć sesji
przez sztuczne podniesienie statusu.

## SRODOWISKO I BASELINE

Getting Strange jest wyłącznie grą Godot 4.7. Nie twórz, nie przywracaj ani
nie dokumentuj strony WWW, HTML/CSS/JS, PWA, portalu, WebView, Capacitor,
Androida, Gradle, Google Play ani innej powierzchni dystrybucji poza Godotem.
Projekt nie jest wersjonowany: nie uruchamiaj Git, nie inicjalizuj repozytorium
i nie traktuj braku clean tree jako problemu.

Jesteś Lead Programmerem i Art Directorem. Pracuj autonomicznie, krok po kroku,
zapisuj ukończone etapy natychmiast i nie czekaj na ręczne review. Zachowaj
Godot-only, logiczny viewport `640x360`, fizykę 60 Hz, semantyczny InputMap,
limit kampanii `25`, `SAVE_SCHEMA_VERSION = 1`, traversal i wszystkie
rozgałęzienia. Nie zmieniaj kodu gry, assetów, colliderów, mechaniki, dialogów
ani istniejących bramek tylko po to, aby poprawić wynik pomiaru.

## STAN PO PKG-0109

- Końcowy `pwsh -NoProfile -File .\tools\verify.ps1` przeszedł, a pakiet
  zamrożono w `snapshots/PKG-0109-2026-08-24/`.
- `docs/VECTOR_STAGE_COST_AUDIT_H-005.md` zawiera metodę i wynik świeżego
  pomiaru Windows/OpenGL na Intel Iris Xe. Narzędzie to
  `tools/audit_h005.gd`, a dane są w `reports/pkg_0109/`.
- Zmierzono 9 wymaganych kadrów świata, dodatkowy Station 02 z
  `DiscontinuousShadow`, 2 kadry świata z CRT i proceduralny cykl protagonistki.
  Inventory objął 45 zasobów scen odpowiadających 43 przestrzeniom: `01..41`,
  `42A..42C`, `43`.
- Statyczny pomiar ma 60 klatek rozgrzewki, 120 klatek próbki i 118 ważnych
  próbek po odrzuceniu 2 pierwszych klatek RenderingServer. Cykl animacji ma
  220 klatek i 218 zapisanych próbek.
- Średni `render_cpu_ms` bezpośrednich kadrów świata wyniósł `0.654–1.016 ms`,
  średni `render_gpu_ms` `0.720–1.606 ms`. Najwyższy średni canvas count ma
  Station 41: `125` draw calls, `2 320` primitives, `209` canvas items.
- H-005 pozostaje `TECHNICAL`, ponieważ dokumenty mają wymóg 60 FPS, ale nie
  mają jawnego budżetu liczbowego renderu, CPU, GPU, canvas ani produkcji.
  `16.667 ms` nie jest ustanowionym budżetem tylko dlatego, że wynika z 60 Hz.
- H-012 pozostaje `UNTESTED`. Znane ostrzeżenia `ObjectDB`/`RID leak` przy
  zamykaniu Godota są szumem nieblokującym, jeśli kod wyjścia pozostaje 0.

## OBOWIĄZKOWA KOLEJNOŚĆ PRACY

### 1. Lektura i baseline

W `C:\getting_strange` przeczytaj w tej kolejności:

1. `AGENTS.md`;
2. `docs/INDEX.md`;
3. `docs/CURRENT_STATE.md`;
4. ten plik `docs/NEXT_SESSION_PROMPT.md`;
5. aktywną specyfikację z `CURRENT_STATE.md`, w szczególności
   `VISUAL_DESIGN.md` i `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`;
6. `docs/TECHNICAL_DIRECTION.md`, `docs/ROADMAP.md`,
   `docs/RISKS_AND_HYPOTHESES.md`, `docs/DECISION_LOG.md` i `docs/WORKFLOW.md`;
7. `docs/VECTOR_STAGE_COST_AUDIT_H-005.md`,
   `docs/VECTOR_STAGE_READABILITY_AUDIT_H-012.md`,
   `tools/audit_h005.gd` oraz pliki `reports/pkg_0109/metadata.json` i
   `reports/pkg_0109/summary.json`;
8. źródła wskazane w raporcie H-005 i odpowiednie testy.

Przed każdą edycją uruchom i zapisz:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

### 2. Plan i audyt kontraktu

Najpierw zapisz read-only plan w nowym raporcie
`docs/VECTOR_STAGE_REPEATABILITY_AUDIT_H-005.md`. Plan musi rozdzielić:

- istniejący wymóg produktu (`60 FPS`, `640x360`, fizyka `60 Hz`) od jawnego
  budżetu subsystemu;
- budżet czasu klatki od budżetu render CPU/GPU, canvas metrics i kosztu pracy
  artystycznej;
- dowód znaleziony w aktualnych plikach od historycznej sugestii lub
  matematycznej konwersji 60 Hz na milisekundy;
- powtarzalność pomiaru na tym samym sprzęcie od generalizacji na inne GPU.

Przeszukaj aktualne dokumenty i decyzje (`rg`, bez filtrowania wyniku) pod kątem
`budget`, `budżet`, `60 FPS`, `frame`, `render`, `CPU`, `GPU`, `draw call`,
`wierzchoł`, `production cost` i podobnych. Jeśli niczego nie ma, zapisz to
jako jawny brak kontraktu. Nie dopisuj progu w `DECISION_LOG.md` tylko po to,
aby H-005 mógł przejść.

### 3. Powtarzalność pomiaru

Użyj istniejącego `tools/audit_h005.gd` bez zmian produktu i wykonaj co najmniej
dwa niezależne uruchomienia w świeżym procesie normalnego Godot/OpenGL na tym
samym Windows/Intel Iris Xe. Zachowaj osobne metadane i nie nadpisuj dowodów
PKG-0109; dane PKG-0110 umieść w `reports/pkg_0110/`.

Porównaj między uruchomieniami co najmniej:

- `frame_interval_ms`, `render_cpu_ms`, `render_gpu_ms` i
  `frame_setup_cpu_ms` dla 9 wymaganych kadrów;
- canvas items, primitives i draw calls;
- pełny cykl Station 02, w tym tryby `full_world` i
  `no_player_and_shadow`;
- liczbę ważnych próbek, warmup, odrzucone klatki, renderer, sterownik,
  viewport, V-Sync i `Engine.max_fps`.

Jeśli narzędzie raportuje metrykę niedostępną albo nielogiczną, najpierw
sprawdź źródło w Godot 4.7 i minimalnie popraw wyłącznie harness audytowy.
Powtórz przebieg przed/po. Nie zmieniaj timeoutów, retry, workerów,
thresholdów ani bramek projektu. Jeśli różnice są zmienne, zachowaj je jako
wynik i nie wybieraj korzystniejszego przebiegu.

Bez drugiego fizycznego GPU nie udawaj testu wielosprzętowego. Zapisz profil
sprzętowy i ograniczenie, a przyszły pomiar na innym sprzęcie pozostaw jako
otwarte ryzyko.

### 4. Interpretacja

Raport ma zawierać:

1. tabelę znalezionych i nieznalezionych kontraktów budżetowych;
2. tabelę obu świeżych przebiegów i różnicę mean/median/p95;
3. kryterium stabilności pomiaru opisane jako własność danych, nie jako
   arbitralny próg jakości produktu;
4. decyzję, czy H-005 ma nadal status `TECHNICAL`;
5. ograniczenia: jeden profil GPU, brak dowodu odbioru/playtestu, brak
   ekstrapolacji z inventory oraz brak formalnego budżetu, jeśli nadal go nie ma.

H-005 można zmienić na `MEASURED` wyłącznie wtedy, gdy jawny budżet istniał w
aktualnym kontrakcie przed porównaniem i wszystkie wymagane bezpośrednie
metryki pokazują jego spełnienie. Sam pomiar dwóch procesów nie wystarcza.

### 5. Dokumentacja i handoff

Po wykonaniu zgodnym ze stanem na dysku zaktualizuj:

- `docs/CURRENT_STATE.md`;
- `docs/SESSION_LOG.md` jednym wpisem `PKG-0110`;
- `docs/RISKS_AND_HYPOTHESES.md` o wynik powtarzalności bez zawyżenia statusu;
- `docs/INDEX.md` dla nowego raportu, jeśli pozostaje żywym audytem;
- `docs/ROADMAP.md` tylko przy rzeczywistej zmianie postępu lub kontraktu;
- `docs/DECISION_LOG.md` tylko przy rzeczywistej decyzji, nie jako sposób na
  dopisanie budżetu;
- ten plik, zastępując go następnym samodzielnym promptem po zamknięciu.

Nie edytuj snapshotu i nie traktuj go jako bieżącego stanu.

## KRYTERIA AKCEPTACJI

Pakiet jest zamknięty dopiero, gdy:

1. baseline i końcowy `pwsh -NoProfile -File .\tools\verify.ps1` są PASS;
2. istnieje raport planu, kontraktu i powtarzalności H-005;
3. istnieją co najmniej dwa świeże przebiegi oraz metadane ich środowiska;
4. nie ma zmyślonych metryk, budżetów ani twierdzeń o playtestach;
5. kod gry zachowuje Godot-only, fizykę 60 Hz, limit 25, zapis 1, InputMap,
   traversal, rozgałęzienia i wszystkie wcześniejsze bramki;
6. `CURRENT_STATE.md`, `SESSION_LOG.md`, hipotezy, indeks i następny prompt
   odpowiadają plikom na dysku;
7. po końcowym PASS wykonano snapshot jako `PKG-0110`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Na końcu uruchom:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0110
```

Sprawdź istnienie snapshotu, ale nie edytuj go. Raport końcowy ma wymienić
baseline, przebiegi powtarzalności, testy, ograniczenia, status H-005, pakiet
wpisany do `SESSION_LOG.md` i ścieżkę handoffu.
