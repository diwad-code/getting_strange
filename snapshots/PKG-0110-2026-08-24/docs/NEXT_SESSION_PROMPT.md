# NEXT_SESSION_PROMPT — PKG-0111

## CEL SESJI

Domknąć pochodzenie formalnego budżetu H-005 bez retroaktywnego dopisywania
progu. PKG-0110 potwierdził powtarzalność strukturalnych metryk na jednym
profilu Windows/OpenGL/Intel Iris Xe, ale aktualne dokumenty nadal nie
ustanawiają liczbowego budżetu renderu, CPU/GPU, canvas metrics ani kosztu
produkcji. Sprawdzić, czy istnieje wiarygodne, uprzednie źródło takiego
kontraktu; jeśli nie, udokumentować brak i pozostawić H-005 `TECHNICAL`.
Nie zmieniaj statusu na `MEASURED` tylko dlatego, że istnieją dwa przebiegi.

## SRODOWISKO I BASELINE

Getting Strange jest wyłącznie grą Godot 4.7. Nie twórz, nie przywracaj ani
nie dokumentuj strony WWW, HTML/CSS/JS, PWA, portalu, WebView, Capacitor,
Androida, Gradle, Google Play ani żadnej powierzchni dystrybucji poza Godotem.
Projekt nie jest wersjonowany: nie uruchamiaj Git, nie inicjalizuj repozytorium
i nie traktuj braku clean tree jako problemu.

Jesteś Lead Programmerem i Art Directorem. Pracuj autonomicznie, krok po kroku,
zapisuj ukończone etapy natychmiast. Zachowaj Godot-only, logiczny viewport
`640x360`, fizykę 60 Hz, semantyczny InputMap, limit kampanii `25`,
`SAVE_SCHEMA_VERSION = 1`, traversal i wszystkie rozgałęzienia.

Zakres PKG-0111 jest read-only wobec produktu: nie zmieniaj scen, assetów,
colliderów, mechaniki, dialogów, animacji, rendererów produktu, istniejących
bramek ani progów tylko po to, by poprawić H-005. `16.667 ms` nie jest budżetem
ustanowionym przez sam wymóg 60 FPS.

## STAN PO PKG-0110

- Baseline i końcowy `pwsh -NoProfile -File .\tools\verify.ps1` z PKG-0110
  muszą być odczytane/zweryfikowane na początku nowej sesji; stan handoffu
  wskazuje PASS.
- Raport planu i powtarzalności: `docs/VECTOR_STAGE_REPEATABILITY_AUDIT_H-005.md`.
- Metoda bazowa: `docs/VECTOR_STAGE_COST_AUDIT_H-005.md`.
- Harness: `tools/audit_h005.gd`; opcjonalne argumenty katalogu/etykiety
  wyjścia rozdzielają PKG-0109 od PKG-0110, a domyślne PKG-0109 pozostaje
  zachowane.
- Dane dwóch świeżych procesów: `reports/pkg_0110/run_01/` i
  `reports/pkg_0110/run_02/`, każde z `metadata.json`, `summary.json` i TSV.
- Oba procesy: Godot 4.7 stable, Windows/OpenGL `gl_compatibility`, Intel Iris
  Xe, viewport `640x360`, fizyka 60 Hz, V-Sync wyłączony tylko w harnessie,
  `Engine.max_fps = 0`, warmup 60, próbka 120, cykl 220.
- Dziewięć wymaganych kadrów ma po 118 ważnych próbek w każdym procesie;
  `canvas_items`, `canvas_primitives` i `canvas_draw_calls` powtarzają się
  dokładnie. Cykl Station 02 ma pięć trybów po 218 próbek; czasy, zwłaszcza
  p95 GPU, są zmienne i nie zostały zamienione w próg.
- H-005 pozostaje `TECHNICAL`; H-012 pozostaje `UNTESTED`. Brak drugiego GPU,
  brak playtestów i brak dowodu odbiorczego są jawne.
- Snapshot poprzedniego pakietu: `snapshots/PKG-0110-2026-08-24/`.

## OBOWIĄZKOWA KOLEJNOŚĆ PRACY

1. W `C:\getting_strange` przeczytaj: `AGENTS.md`, `docs/INDEX.md`,
   `docs/CURRENT_STATE.md`, ten prompt, aktywną specyfikację z bieżącego
   stanu, `VISUAL_DESIGN.md`, `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`,
   `docs/TECHNICAL_DIRECTION.md`, `docs/ROADMAP.md`,
   `docs/RISKS_AND_HYPOTHESES.md`, `docs/DECISION_LOG.md` i `docs/WORKFLOW.md`.
2. Przeczytaj `docs/VECTOR_STAGE_COST_AUDIT_H-005.md`,
   `docs/VECTOR_STAGE_REPEATABILITY_AUDIT_H-005.md`,
   `reports/pkg_0110/run_01/metadata.json`,
   `reports/pkg_0110/run_01/summary.json`,
   `reports/pkg_0110/run_02/metadata.json`,
   `reports/pkg_0110/run_02/summary.json`, `tools/audit_h005.gd` oraz źródła
   i testy wskazane przez raport.
3. Przed każdą edycją uruchom i zapisz bez filtrowania:

   ```powershell
   pwsh -NoProfile -File .\tools\verify.ps1
   ```

4. Przeszukaj aktualne źródła i decyzje `rg` bez filtrowania wyniku pod kątem
   `budget`, `budżet`, `60 FPS`, `frame`, `render`, `CPU`, `GPU`, `draw call`,
   `wierzchoł`, `memory`, `production cost`, `16.667` i podobnych. Oddziel
   wymagania produktu, istniejące budżety, historyczne wpisy oraz zwykłe
   konwersje matematyczne.
5. Zbadaj pochodzenie każdego kandydata na budżet. Za kontrakt można uznać
   wyłącznie limit, który istniał przed pomiarem, ma jednoznaczne źródło,
   zakres i metodę spełnienia. Wyniku PKG-0109/0110 nie wolno użyć jako
   dowodu, że budżet istniał wcześniej.
6. Jeśli nie ma wiarygodnego źródła, zapisz brak kontraktu w raporcie i
   pozostaw H-005 `TECHNICAL`. Jeśli pojawi się źródło zewnętrzne, korzystaj
   tylko z dokumentacji/źródeł pierwotnych, zachowaj ograniczenia transferu na
   ten sprzęt i nie awansuj statusu bez bezpośredniego pomiaru względem
   uprzedniego limitu.
7. Nie dopisuj progu do `DECISION_LOG.md` tylko po to, aby H-005 przeszedł.
   Nie zmieniaj kodu gry. Ewentualne zmiany mogą dotyczyć wyłącznie raportu,
   provenance i minimalnej instrumentacji audytu; nie zmieniaj timeoutów,
   retry, workerów, thresholdów ani bramek.

## KRYTERIA AKCEPTACJI

1. Baseline i końcowy `pwsh -NoProfile -File .\tools\verify.ps1` są PASS.
2. Raport H-005 jasno rozdziela wymaganie 60 FPS/640x360/60 Hz od formalnego
   budżetu subsystemu oraz wskazuje źródło albo brak źródła.
3. Nie ma zmyślonych metryk, budżetów, generalizacji na inne GPU ani twierdzeń
   o playtestach lub odbiorze.
4. H-005 pozostaje `TECHNICAL`, jeśli nie istniał uprzedni, wiarygodny budżet
   i pomiar jego spełnienia; dwa świeże procesy same nie wystarczają.
5. Nie zmieniają się Godot-only, viewport 640x360, fizyka 60 Hz, InputMap,
   limit 25, zapis 1, traversal, mechanika i rozgałęzienia.
6. Zaktualizowane `CURRENT_STATE.md`, `RISKS_AND_HYPOTHESES.md`, ewentualnie
   `ROADMAP.md`/`DECISION_LOG.md` tylko przy rzeczywistej zmianie, jeden wpis
   `PKG-0111` w `SESSION_LOG.md`, raport oraz kolejny samodzielny prompt
   odpowiadają stanowi na dysku.
7. Po końcowym PASS wykonaj:

   ```powershell
   pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0111
   ```

   Sprawdź istnienie `snapshots/PKG-0111-2026-08-24/` i nie edytuj snapshotu.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po wykonaniu kryteriów akceptacji zamknij pakiet snapshotem, a następnie
przekaż wynik w raporcie końcowym.

## RAPORT KOŃCOWY

Wymień baseline, źródło lub brak źródła budżetu, testy, ograniczenia, status
H-005, zmienione pliki, pakiet wpisany do `SESSION_LOG.md`, ścieżkę nowego
raportu i następny prompt. Nie raportuj snapshotu jako bieżącego stanu.
