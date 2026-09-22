# NEXT_SESSION_PROMPT — PKG-0112

## CEL SESJI

Wykonać kontrolowane przyjęcie ewentualnego uprzedniego źródła formalnego
budżetu H-005. PKG-0111 wykazał, że aktualne dokumenty, decyzje, konfiguracja,
harness i dane PKG-0110 nie zawierają liczbowego budżetu z jednoznacznym
pochodzeniem, zakresem i metodą spełnienia. Sprawdzić wyłącznie, czy na dysku
pojawił się nowy, wiarygodny artefakt istniejący przed pomiarem; jeśli nie,
udokumentować utrzymanie luki i pozostawić H-005 `TECHNICAL`.

Nie dopisuj progu retroaktywnie. Nie używaj `16.667 ms` jako budżetu. Dwa
przebiegi na tym samym GPU nie są samodzielnym powodem do awansu statusu.

## SRODOWISKO I BASELINE

Getting Strange jest wyłącznie grą Godot 4.7. Nie twórz, nie przywracaj ani
nie dokumentuj strony WWW, HTML/CSS/JS, PWA, portalu, WebView, Capacitor,
Androida, Gradle, Google Play ani żadnej powierzchni dystrybucji poza Godotem.
Projekt nie jest wersjonowany: nie uruchamiaj Git, nie inicjalizuj repozytorium
i nie traktuj braku clean tree jako problemu.

Jesteś Lead Programmerem i Art Directorem. Pracuj autonomicznie, krok po kroku,
zapisuj etapy natychmiast. Zachowaj Godot-only, viewport `640x360`, fizykę
`60 Hz`, semantyczny InputMap, limit kampanii `25`, `SAVE_SCHEMA_VERSION = 1`,
traversal i wszystkie rozgałęzienia.

Zakres PKG-0112 jest read-only wobec produktu. Nie zmieniaj scen, assetów,
colliderów, mechaniki, dialogów, animacji, rendererów produktu, istniejących
bramek ani progów. `16.667 ms` jest tylko `1000 / 60`.

Oczekiwany ostatni pakiet: `PKG-0111`, snapshot
`snapshots/PKG-0111-2026-08-24/`.

## STAN PO PKG-0111

- Raport provenance: `docs/VECTOR_STAGE_BUDGET_PROVENANCE_AUDIT_H-005.md`.
- Metoda kosztu: `docs/VECTOR_STAGE_COST_AUDIT_H-005.md`.
- Powtarzalność: `docs/VECTOR_STAGE_REPEATABILITY_AUDIT_H-005.md`.
- Harness: `tools/audit_h005.gd`; domyślne wyjście PKG-0109 i instrumentacja
  parametrów PKG-0110 pozostają bez zmian.
- Dane: `reports/pkg_0110/run_01/` i `reports/pkg_0110/run_02/`, każde z
  `metadata.json`, `summary.json` i tabelami TSV.
- Oba przebiegi mają Godot 4.7 stable, Windows/OpenGL `gl_compatibility`, Intel
  Iris Xe, viewport `640x360`, fizykę `60 Hz`, V-Sync wyłączony wyłącznie w
  harnessie, `Engine.max_fps = 0`, warmup `60`, próbkę `120` i cykl `220`.
- Każdy przebieg ma 45 zasobów inventory, 22 wiersze statyczne i 5 agregatów
  cyklu; statyczne canvas metrics powtórzyły się dokładnie, ale czasy wykazały
  zmienność.
- H-005 pozostaje `TECHNICAL`; H-012 pozostaje `UNTESTED`. Brak drugiego GPU,
  brak modelu kosztu ręcznej produkcji i brak dowodu odbiorczego są jawne.
- PKG-0111 nie zmienił kodu gry, scen, assetów, harnessu, danych, decyzji
  produktu ani bramek.

## OBOWIĄZKOWA KOLEJNOŚĆ PRACY

1. W `C:\getting_strange` przeczytaj `AGENTS.md`, `docs/INDEX.md`,
   `docs/CURRENT_STATE.md`, ten prompt, aktywną specyfikację z bieżącego stanu,
   `VISUAL_DESIGN.md`, `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`,
   `docs/TECHNICAL_DIRECTION.md`, `docs/ROADMAP.md`,
   `docs/RISKS_AND_HYPOTHESES.md`, `docs/DECISION_LOG.md` i `docs/WORKFLOW.md`.
2. Przeczytaj `docs/VECTOR_STAGE_BUDGET_PROVENANCE_AUDIT_H-005.md`,
   `docs/VECTOR_STAGE_COST_AUDIT_H-005.md`,
   `docs/VECTOR_STAGE_REPEATABILITY_AUDIT_H-005.md`, cztery JSON-y z
   `reports/pkg_0110/run_01/` i `run_02/`, `tools/audit_h005.gd` oraz źródła i
   testy wskazane przez te raporty.
3. Przed każdą edycją uruchom i zapisz bez filtrowania:

   ```powershell
   pwsh -NoProfile -File .\tools\verify.ps1
   ```

4. Przeszukaj aktualne źródła i decyzje `rg` pod kątem `budget`, `budżet`,
   `60 FPS`, `frame`, `render`, `CPU`, `GPU`, `draw call`, `wierzchoł`,
   `memory`, `production cost`, `16.667`, `milisekund` i podobnych. Oddziel
   dokument utworzony przed pomiarem od raportu opisującego pomiar.
5. Dla każdego nowego kandydata sprawdź: źródło, datę/provenance, limit lub
   model, zakres subsystemu i metodę bezpośredniej weryfikacji. Sam cel 60 FPS,
   viewport, fizyka, historyczna sugestia, wynik pomiaru lub konwersja nie są
   budżetem.
6. Jeśli istnieje uprzedni artefakt spełniający wszystkie warunki, opisz go,
   zachowaj ograniczenia transferu na badany sprzęt i nie awansuj H-005 bez
   bezpośredniego pomiaru względem jego limitu. Jeśli artefaktu nie ma, zapisz
   wynik braku i pozostaw `TECHNICAL`.
7. Nie zmieniaj kodu gry ani `DECISION_LOG.md` tylko po to, aby uzyskać zielony
   status. Nie zmieniaj timeoutów, retry, workerów, progów ani bramek. Nie
   czytaj snapshotu jako bieżącego stanu i nie edytuj go.

## KRYTERIA AKCEPTACJI

1. Baseline i końcowy `pwsh -NoProfile -File .\tools\verify.ps1` są PASS.
2. Audyt rozdziela wymaganie 60 FPS/640x360/60 Hz od formalnego budżetu i
   wskazuje źródło albo brak źródła.
3. Nie ma zmyślonych metryk, progów, generalizacji na inne GPU ani twierdzeń
   o playtestach, funie, emocjach, czytelności lub odbiorze.
4. H-005 pozostaje `TECHNICAL`, jeśli nie ma uprzedniego wiarygodnego budżetu
   i bezpośredniego pomiaru jego spełnienia.
5. Nie zmieniają się Godot-only, viewport 640x360, fizyka 60 Hz, InputMap,
   limit 25, zapis 1, traversal, mechanika ani rozgałęzienia.
6. Zaktualizowane `CURRENT_STATE.md`, `RISKS_AND_HYPOTHESES.md`, ewentualnie
   `ROADMAP.md`/`DECISION_LOG.md` tylko przy rzeczywistej zmianie, jeden wpis
   PKG-0112 w `SESSION_LOG.md`, raport i kolejny samodzielny prompt odpowiadają
   stanowi na dysku.
7. Po końcowym PASS wykonaj:

   ```powershell
   pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0112
   ```

   Sprawdź istnienie `snapshots/PKG-0112-2026-08-24/` i nie edytuj snapshotu.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po wykonaniu kryteriów zamknij pakiet snapshotem, a następnie przekaż wynik w
raporcie końcowym. Nie raportuj snapshotu jako bieżącego stanu.

## RAPORT KOŃCOWY

Wymień baseline, każde źródło lub brak źródła budżetu, testy, ograniczenia,
status H-005, zmienione pliki, pakiet wpisany do `SESSION_LOG.md`, ścieżkę
raportu i następny prompt. Zawsze zaznacz, że automaty dowodzą kontraktów
technicznych, a nie odbioru przez nową osobę.
