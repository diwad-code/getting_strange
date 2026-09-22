# NEXT_SESSION_PROMPT — PKG-0109

## CEL SESJI

Wykonać techniczny audyt hipotezy H-005: jaki jest rzeczywisty koszt jednego
finalnego kadru Rówień Vector-Stage, pełnego aktualnie zaimplementowanego
cyklu animacji protagonistki oraz rozszerzenia tego kosztu na wszystkie 43
przestrzenie. To jest audyt wykonalności produkcyjnej, nie optymalizacja na
ślepo i nie badanie odbioru. H-005 pozostaje `TECHNICAL`, dopóki pomiar nie
zostanie porównany z jawnym budżetem projektu.

## SRODOWISKO I BASELINE

Getting Strange jest wyłącznie grą Godot 4.7. Nie twórz, nie przywracaj ani
nie dokumentuj strony WWW, HTML/CSS/JS, PWA, portalu, WebView, Capacitor,
Androida, Gradle, Google Play ani innej powierzchni dystrybucji poza Godotem.
Projekt nie jest wersjonowany: nie uruchamiaj Git.

Jesteś Lead Programmerem i Art Directorem. Pracuj autonomicznie, krok po
kroku, zapisuj każdy ukończony etap natychmiast i nie czekaj na ręczne review.
Decyzje podejmuj na podstawie aktualnego runtime’u, dokumentacji, lokalnych
skilli oraz powtarzalnego pomiaru. Nie zmieniaj progów, timeoutów, workerów,
retry ani zakresu istniejących bramek tylko po to, aby uzyskać PASS.

## STAN PO PKG-0108

- `pwsh -NoProfile -File .\tools\verify.ps1` przechodzi, a PKG-0108 zapisał
  snapshot `snapshots/PKG-0108-2026-08-24/`.
- Audyt H-012 objął 12 świeżych kadrów, 63 pomiary rastera, 48 kontroli skal
  `1x`–`4x` i 36 wariantów transformacji. H-012 pozostało `UNTESTED`, bo
  specyfikacja nie ustanawia progu odbiorczego i pomiar nie jest playtestem.
- Finalne sceny 42A, 42B, 42C i 43 mają deterministyczne profile
  `VectorStageEnvironment`, `AtmosphereRig`, `CRTDialogueBox` i
  `OpeningDialogueCue`. Obowiązuje świadoma cisza finałów i budżet nowych
  przeszkód równy 0.
- Obowiązują: Godot 4.7, logiczny viewport `640x360`, fizyka 60 Hz, limit
  kampanii `25`, `SAVE_SCHEMA_VERSION = 1`, semantyczny InputMap i twardy zakaz
  przeszkód platformowych. Nie zmieniaj colliderów, mechaniki, flag, kosztów,
  dialogów, zapisów ani rozgałęzień.
- Znane ostrzeżenia Godota `ObjectDB`/`RID leak` przy zamykaniu procesu są
  istniejącym szumem; kod wyjścia pozostaje kryterium technicznym.

## OBOWIĄZKOWA KOLEJNOŚĆ PRACY

### 1. Lektura i baseline

W katalogu `C:\getting_strange` przeczytaj w tej kolejności:

1. `AGENTS.md`;
2. `docs/INDEX.md`;
3. `docs/CURRENT_STATE.md`;
4. ten plik `docs/NEXT_SESSION_PROMPT.md`;
5. aktywną specyfikację wskazaną w `CURRENT_STATE.md`, w szczególności
   `VISUAL_DESIGN.md` i `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`;
6. `docs/TECHNICAL_DIRECTION.md`, `docs/ROADMAP.md`,
   `docs/RISKS_AND_HYPOTHESES.md`, `docs/DECISION_LOG.md` i `docs/WORKFLOW.md`;
7. `docs/VECTOR_STAGE_READABILITY_AUDIT_H-012.md`,
   `docs/TRAVERSAL_ACT_IV_FINAL_AUDIT.md`, `tools/audit_h012.gd`,
   `tools/capture_pkg_0107.gd`;
8. `scripts/visual/vector_stage_style.gd`,
   `scripts/visual/vector_stage_environment.gd`,
   `scripts/levels/atmosphere_rig.gd`,
   `scripts/player/prototype_player.gd`,
   `scripts/player/discontinuous_shadow.gd`, sceny 01, 14, 22, 38, 41, 42A,
   42B, 42C i 43 oraz odpowiednie testy.

Przed pierwszą edycją uruchom i zapisz:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

### 2. Plan pomiaru przed narzędziem

Najpierw zapisz read-only plan audytu w raporcie PKG-0109. Plan musi jawnie
rozstrzygnąć:

- co w aktualnym runtime oznacza „finalny kadr” oraz czy pomiar obejmuje
  świat, postać, cień, `AtmosphereRig`, CRT i inne współdzielone elementy;
- co w aktualnym kodzie oznacza „pełną animację protagonistki”. Nie zakładaj
  istnienia `AnimationPlayer` ani assetu, którego nie ma. Jeśli sylwetka jest
  proceduralnym `_draw()` sterowanym przez fizykę, zdefiniuj powtarzalny cykl
  istniejących stanów i zapisz, czego nie da się zmierzyć bez nowej animacji;
- reprezentatywne kadry oraz sposób objęcia wszystkich 43 scen. Co najmniej
  uwzględnij Station 01, 14, 22, 38, 41, 42A, 42B, 42C i 43; dla pozostałych
  scen wykonaj pełny source/runtime inventory albo wyraźnie udokumentuj
  ograniczenie, bez udawania ekstrapolacji;
- metryki dostępne w Godot 4.7 na aktualnym sterowniku: czas klatki przy 60 Hz,
  draw calls/2D items/vertices lub ich rzeczywiste odpowiedniki, koszt CPU/GPU
  dostępny z API/profilera oraz narzut animacji względem tej samej sceny bez
  warstwy protagonistki. Nie wpisuj metryk, których narzędzie nie odczytało;
- liczba klatek rozgrzewki, próbka pomiarowa, reset sceny i sposób odrzucenia
  pierwszych klatek. Parametry muszą być zapisane w metadanych, aby powtórzyć
  audyt w świeżym procesie;
- źródło budżetu docelowego. Najpierw znajdź istniejący limit w dokumentacji
  lub decyzjach. Jeśli liczbowego budżetu nie ma, nie wymyślaj go: raport ma
  wtedy rozstrzygnąć pomiar techniczny, ale H-005 zostawić `TECHNICAL` z
  jawnie zapisanym brakującym kontraktem.

### 3. Wykonanie audytu

Możesz dodać `tools/audit_h005.gd` i raport
`docs/VECTOR_STAGE_COST_AUDIT_H-005.md`; wygenerowane dane umieść pod
`reports/pkg_0109/`. Narzędzie ma działać w normalnym Godot/OpenGL na
Windows/Intel Iris Xe i nie może zmieniać produktu. Dozwolona jest wyłącznie
instrumentacja narzędzia audytowego lub odwracalny harness poza scenami gry.

Wykonaj, zapisz i sprawdź:

1. koszt świeżego kadru dla reprezentatywnych scen, w tym wszystkich finałów;
2. koszt pełnego zdefiniowanego cyklu protagonistki przy 60 Hz, z rozbiciem na
   ciało, cień, pył/efekty i inne elementy, jeśli są obecne;
3. porównanie sceny bazowej i warstwy protagonistki, bez wyłączania elementu
   w sposób zmieniający logikę gry;
4. inventory wszystkich 43 przestrzeni: aktywne profile, liczba elementów
   proceduralnych, animowanych i współdzielonych oraz zakres zmierzony
   bezpośrednio;
5. wynik względem istniejącego budżetu, a przy jego braku — jawny brak
   rozstrzygnięcia zamiast arbitralnej normy.

Nie dodawaj optymalizacji, nowych assetów, animacji, colliderów ani przeszkód
tylko po to, aby poprawić tabelę. Jeśli pomiar ujawni błąd techniczny, napraw
wyłącznie minimalny, jednoznaczny problem poza logiką kampanii i wykonaj
pomiar przed/po; w przeciwnym razie pozostaw kod gry bez zmian.

### 4. Interpretacja

Raport musi rozdzielać obserwację pliku/runtime’u, wynik obliczenia, porównanie
z budżetem, decyzję produkcyjną i nierozstrzygnięte ryzyko. Metryki nie są
dowodem funu, emocji, czytelności, zrozumienia fabuły ani jakości odbioru.
Nie używaj H-012 jako zastępczego dowodu H-005. H-005 wolno zmienić na
`MEASURED` tylko wtedy, gdy aktualny kontrakt zawiera jawny budżet i pomiar
bezpośrednio pokazuje jego spełnienie; w przeciwnym wypadku zachowaj
`TECHNICAL`.

### 5. Dokumentacja i handoff

Po wykonaniu zgodnym ze stanem na dysku zaktualizuj:

- `docs/CURRENT_STATE.md`;
- `docs/SESSION_LOG.md` jednym wpisem `PKG-0109`;
- `docs/RISKS_AND_HYPOTHESES.md` o dowód H-005 bez zawyżania statusu;
- `docs/ROADMAP.md` i `docs/DECISION_LOG.md` tylko, jeśli status lub kontrakt
  rzeczywiście się zmienił;
- `docs/INDEX.md`, jeśli powstał nowy żywy audyt;
- ten plik, zastępując go następnym samodzielnym promptem po zamknięciu.

## KRYTERIA AKCEPTACJI

Pakiet jest zamknięty dopiero, gdy:

1. baseline i końcowy `pwsh -NoProfile -File .\tools\verify.ps1` są PASS;
2. istnieje raport H-005 z metodą, źródłami, metrykami, parametrami próbki,
   inventory 43 scen, budżetem lub udokumentowanym jego brakiem;
3. istnieje powtarzalne narzędzie pomiarowe, jeśli pomiar wymagał obliczeń;
4. wynik nie zawiera zmyślonych metryk ani twierdzeń o playtestach/odbiorze;
5. kod gry zachowuje Godot-only, fizykę 60 Hz, limit 25, zapis 1, InputMap,
   traversal, rozgałęzienia i wszystkie wcześniejsze bramki;
6. `CURRENT_STATE.md`, `SESSION_LOG.md`, hipotezy, indeks i następny prompt
   odpowiadają plikom na dysku;
7. po końcowym PASS wykonano snapshot jako `PKG-0109`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Na końcu uruchom:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0109
```

Sprawdź istnienie snapshotu, ale nie edytuj go i nie traktuj jego kopii jako
bieżącego stanu. Raport końcowy ma wymienić baseline, pomiar H-005, testy,
ograniczenia, status hipotezy, pakiet wpisany do `SESSION_LOG.md` i ścieżkę
handoffu. Nie kończ pracy przed aktualizacją dokumentacji i snapshotem.
## TOŻSAMOŚĆ SESJI

Jesteś Lead Programmerem i Art Directorem projektu. Pracuj autonomicznie,
krok po kroku, zapisuj każdy ukończony etap natychmiast i nie czekaj na
ręczne review. Decyzje podejmuj na podstawie aktualnego runtime’u,
dokumentacji, lokalnych skilli oraz powtarzalnego pomiaru.
