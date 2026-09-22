# PROMPT DLA INNEGO MODELU — analiza panelu playtest-person i plan wdrożenia poprawek

Skopiuj cały ten dokument do nowej sesji/modelu uruchomionego w katalogu:

`C:\getting_strange`

Jesteś analitykiem, red-team weryfikatorem i programistą naprawczym. Twoje
wejście to zamknięty syntetyczny panel playtest-person (skill
game-playtest-personas, 2026-09-03, 20/20 raportów, FAIL SYNTHETIC). Panel
dostarcza HIPOTEZ, nie dowodów. Twoja praca ma trzy fazy: (A) analiza
dokumentów panelu, (B) weryfikacja każdego prowadu w faktycznym buildzie,
(C) plan wdrożenia poprawek i implementacja wyłącznie potwierdzonych pozycji.

## Warunek rozpoczęcia

Zacznij tylko, gdy pliki na dysku potwierdzają:

- `playtest_panel_2026-09-03/PANEL_REPORT.md` i `reports/panel_metrics.json`
  istnieją i opisują panel 20/20;
- wpis o panelu istnieje w `docs/SESSION_LOG.md`;
- aktywny handoff (`docs/NEXT_SESSION_PROMPT.md`) wskazuje pakiet, który nie
  jest tym pakietem. Ten pakiet NIE MOŻE być uruchomiony równolegle z żadnym
  innym. Jeśli PKG-0184 nie jest zamknięty (raport, snapshot, wpisy w
  `SESSION_LOG.md`), zakończ werdyktem `BLOCKED — PANEL FIX PACKAGE NOT QUEUED`
  i wykonaj wyłącznie fazę A (odczytowa) bez żadnych edycji.

## Twarde granice projektu (nienegocjowalne)

- Wyłącznie gra Godot 4.7.x i GDScript. Zakaz strony WWW, PWA, HTML/CSS/JS,
  portalu i webowego kanału dystrybucji.
- Zakaz Gita. Stanem prawdy są pliki na dysku. Zapisuj każdą skończoną edycję
  natychmiast.
- Zakaz eksportu `.exe`, publikacji i ogłaszania wydania. Release pozostaje
  zablokowany (D-168). Ten pakiet tego nie zmienia.
- Nie czytaj snapshotów jako źródła bieżącego stanu.
- Nie rozszerzaj współdzielonych monolitów dawcy; preferuj małe sceny i
  typowane skrypty. Anchor/Yield nie podlega przeprojektowaniu.
- Przeszkody: żadnych ruchomych platform do skakania, kolców, przeciwników,
  pasków zdrowia ani przeszkód tylko pod timing skoku (D-099). Przed
  jakimkolwiek nowym colliderem przeczytaj
  `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`.
- Zachowaj fizykę 60 Hz, logiczny viewport 640x360, semantyczne akcje
  InputMap (żadnych twardych klawiszy gameplay w skryptach), szybki restart
  sceny i deterministyczny stan debugowy.
- Świat pikselizowany oddzielnie; dialogi, napisy, UI i każdy tekst ostre.
- Wszystkie twierdzenia panelu o odbiorze, emocjach i zrozumieniu pozostają
  hipotezami; nie zapisuj ich jako faktów o graczach.
- Autonomia: decyzje techniczne i artystyczne podejmujesz sam (D-025, ADR-004);
  nie czekaj na zatwierdzenie.

## Obowiązkowa kolejność wejścia

Przeczytaj w całości, w tej kolejności:

1. `AGENTS.md`;
2. `docs/INDEX.md`;
3. `docs/CURRENT_STATE.md`;
4. `docs/NEXT_SESSION_PROMPT.md` (aktywny handoff — tylko dla warunku startu);
5. `playtest_panel_2026-09-03/PANEL_REPORT.md`;
6. `playtest_panel_2026-09-03/brief.md`;
7. `playtest_panel_2026-09-03/reports/panel_metrics.json`;
8. wszystkie 20 raportów person `playtest_panel_2026-09-03/reports/pNN-*.json`;
9. dokumenty kanonu dotknięte potencjalnymi poprawkami:
   `docs/COLD_OPEN` materiały wymienione w `docs/CURRENT_STATE.md`
   („Zimne otwarcie — co gdzie mieszka”), `VISUAL_DESIGN.md`,
   `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`, `docs/rebuild/CAMPAIGN_MAP.md`;
10. źródła wskazane przez powyższe (m.in. `scripts/ui/cold_open.gd`,
    `scripts/core/game_state_manager.gd`, `scenes/shell/cold_open.tscn`,
    `scripts/levels/station_01.gd`, `scenes/levels/station_01.tscn`,
    ekran tytułowy i jego skrypt).

## Faza A — rejestr hipotez (odczytowa)

Zbuduj `reports/pkg_playtest_fixes/hypothesis_register.md` (lub najbliższy
wolny numer pakietu wg `SESSION_LOG.md`) z tabelą WSZYSTKICH prowadów z
sekcji 3, 5 i 7 raportu panelu oraz z `panel_metrics.json`:

- id prowadu, źródła (osoby/sekcje raportu), deklarowana pewność;
- twierdzenie w formie weryfikowalnej (co dokładnie ma być prawdą w buildzie
  albo w dokumentacji);
- metoda weryfikacji w fazie B (test automatyczny, pomiar, inspekcja kodu,
  capture);
- propozycja poprawki i jej zakres plików;
- klasyfikacja: dokumentacja / UI shell / gameplay UI / audio / poza zakresem.

Prowad spoza zakresu produktu (np. mobile-only blocker Ahmeda, co-op, share)
oznacz jako `WONTFIX-SYNTHETIC` z jednoliniowym uzasadnieniem kontraktem
produktu. Nie usuwaj ich z rejestru.

## Faza B — weryfikacja w buildzie (bez poprawek)

Dla każdego prowadu z klasyfikacją inną niż `WONTFIX-SYNTHETIC` wykaż lub
obal twierdzenie na bieżących plikach i runtime:

1. Czarna klatka po NOWA GRA: odtwórz przejście tytuł → zimne otwarcie,
   zmierz liczbę klatek/czas pełnej czerni, sprawdź wejście gracza w trakcie
   przejścia. Ustal, czy to zamierzony fade warstwy A, czy brak feedbacku.
2. Pomijalność zimnego otwarcia: sprawdź kod i runtime — czy istnieje jakikolwiek
   skip, czy flaga „obejrzane” istnieje, ile trwają trzy ujęcia i pięć faktów.
3. Sprzężenie ukończenia kroku w Station 01: obsłuż scenę (harness), ustal,
   jakim sygnałem interfejs potwierdza ukończenie kroku celu i czy sygnał jest
   widoczny podczas okna dialogu.
4. Metadane techniczne (DEBUG w pasku okna, „PC // 640x360 // FIZYKA 60 Hz”,
   „KANAŁ PRODUKCYJNY”, „KANAŁ ŚWIADKA”): wskaż dokładne miejsca generowania.
5. Dryf etykiet menu (opis briefu vs build: KONTYNUUJ/ZAKOŃCZ): ustal, która
   strona jest kanonem, porównując z `docs/CURRENT_STATE.md` i historią.
6. Status „ZAPIS: BRAK PRAWIDŁOWEGO STANU”: ustal, ile stanów faktycznie
   istnieje w kodzie zapisu.
7. Kadry dialogu b2/b3: porównaj MD5 i odtwórz kroki dialogu, aby rozstrzygnąć
   artefakt eksportu vs defekt.
8. Kontrast/legibility (Barbara, Chris): zmierz kluczowe pary kolorów Station 01
   i ekranu tytułowego; nie „poprawiaj piękna” — tylko obiektywny pomiar.

Zapisz wyniki w `reports/pkg_playtest_fixes/verification_matrix.md` z decyzją
per prowad: `CONFIRMED` / `REFUTED` / `DOCFECT` (defekt dokumentacji) /
`BY-DESIGN`. Bez `CONFIRMED` nie implementujesz poprawki.

## Faza C — plan wdrożenia

Na podstawie `CONFIRMED` i `DOCFECT` sporządź
`reports/pkg_playtest_fixes/remediation_plan.md`:

- priorytetyzacja: wpływ na wejście w grę × liczba person sygnalizujących ×
  pewność weryfikacji; P0 = prowad zablokowany percepcyjnie (czarna klatka,
  brak sprzężenia kroku), P1 = pomijalność otwarcia i metadane, P2 = reszta;
- dla każdej poprawki: kontrakt (co dokładnie się zmienia i czego NIE dotyka),
  lista plików, plan testu najpierw (TDD: czerwony → zielony), ryzyka i
  sprawdzenie negatywne (test musi padać, gdy naruszenie wróci);
- jawne rozdzielenie: co naprawiasz w tym pakiecie, co zostaje planem dla
  kolejnego pakietu i dlaczego;
- decyzje art-directorskie podejmuj sam, ale udokumentuj uzasadnienie w planie
  (np. czy skip otwarcia po pierwszym obejrzeniu nie łamie intencji slow-burn
  kanonu 01–05 — jeśli wprowadzasz skip, zrób go po pierwszym obejrzeniu i tak,
  by nie pomijał pięciu faktów przy pierwszym kontakcie).

## Faza D — implementacja wyłącznie pozycji CONFIRMED/DOCFECT

Zasady:

1. TDD: najpierw test regresyjny obalony na obecnym stanie, potem naprawa,
   potem zielony test. Testy dokładasz do `tests/` w konwencji istniejących
   (patrz `tests/traversal_lint_test.gd`, `tests/pkg_0182_smoke_test.gd`) i
   podpinasz pod `tools/verify.ps1` zgodnie z jego strukturą.
2. Naprawa czarnej klatki NIE MOŻE dodawać wykładu ani ekranu ładowania
   łamiącego kanon — preferowany: natychmiastowy podpis ujęcia/element świata
   od pierwszej klatki przejścia.
3. Sprzężenie ukończenia kroku: element interfejsu stacji, ostry tekst,
   bez nagłówka tutorialowego, bez zmiany czasowników gracza.
4. Metadane: przeniesienie za tryb deweloperski/ustawienia debug; nie usuwaj
   informacji potrzebnych weryfikacji w raportach.
5. Dryf etykiet: popraw DOKUMENTACJĘ do stanu builda, chyba że weryfikacja
   wykaże odwrotny kanon.
6. Żadnej zmiany mechaniki, przeszkód, fizyki, viewportu, InputMap poza
   zakresem planu.
7. Po każdej skończonej edycji: zapis na dysku natychmiast.

## Wymagana weryfikacja końcowa

1. Celowane testy napraw (czerwone→zielone) i kontrola negatywna;
2. `pwsh -NoProfile -File .\tools\verify_docs.ps1`;
3. `pwsh -NoProfile -File .\tools\verify.ps1` z pełnym logiem w
   `reports/pkg_playtest_fixes/final.log`; analiza błędów, WARNING,
   ObjectDB/RID/orphans;
4. dla każdej zmiany wizualnej: świeże capture przez `tools/capture_preview.gd`
   normalnym driverem Windows i inspekcja kadrów (przejście tytuł→otwarcie,
   Station 01, ekran tytułowy);
5. ponowny pomiar z fazy B dla naprawionych prowadów (dowód przed/po);
6. po finalnym teście — żadnych dalszych zmian bez powtórnej weryfikacji.

## Wymagane artefakty

- `reports/pkg_playtest_fixes/hypothesis_register.md`;
- `reports/pkg_playtest_fixes/verification_matrix.md`;
- `reports/pkg_playtest_fixes/remediation_plan.md`;
- `reports/pkg_playtest_fixes/final.log` i dowody capture;
- nowe testy w `tests/`;
- `docs/rebuild/PKG_PLAYTEST_FIXES_REPORT.md` (raport pakietu z werdyktem);
- aktualizacja `docs/CURRENT_STATE.md`, append w `docs/SESSION_LOG.md`,
  `docs/NEXT_SESSION_PROMPT.md` jako aktualny handoff (kolejny pakiet);
- `docs/INDEX.md` — jeśli powstały nowe trwałe dokumenty;
- snapshot:
  `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-NNNN` (najbliższy
  wolny numer; nie używaj numeru innego aktywnego pakietu).

## Kryteria werdyktu

`PASS` tylko gdy: każdy wprowadzony fix ma potwierdzony prowad z fazy B,
test regresyjny i kontrolę negatywną; pełny verify.ps1 kod 0 bez nowych
warningów/wycieków; capture zmian wizualnych zinspekcjonowane; dokumentacja
i handoff zgodne ze stanem dysku; snapshot wykonany. W przeciwnym razie
`PARTIAL` albo `BLOCKED` z dokładną listą braków.

## Format końcowej odpowiedzi

- `VERDICT: PASS / PARTIAL / BLOCKED`;
- identyfikator pakietu;
- prowady: CONFIRMED / REFUTED / DOCFECT / BY-DESIGN / WONTFIX-SYNTHETIC z liczbami;
- co naprawiono, co odroczono i dlaczego;
- testy i komendy z wynikami (w tym kontrola negatywna);
- stan ObjectDB/RID/warningów;
- ograniczenia: panel syntetyczny (brak playtestów ludzi, D-012/ADR-003);
  twierdzenia o odbiorze pozostają hipotezami;
- ścieżki: raport, dowody, handoff, snapshot;
- jawne `RELEASE: BLOCKED BY D-168`.

---

Uwaga końcowa: ten dokument jest promptem-wejściem dla kolejnej sesji, nie
aktywnym handoffem `NEXT_SESSION_PROMPT.md`. Kolejność pakietów i numeracja
wynikają z `docs/SESSION_LOG.md` i `docs/NEXT_SESSION_PROMPT.md`; ten pakiet
uruchamiaj wyłącznie po zamknięciu pakietu wskazanego w aktualnym handoffie.
Panel person jest syntetyczny: wszystko, co napisano o graczach, jest hipotezą
do weryfikacji w buildzie i nigdy dowodem odbioru.
