# NEXT_SESSION_PROMPT — PKG-0183 / BUNDLE-33

> PKG-0182 / BUNDLE-32 jest zamknięty. Ten plik jest aktywnym handoffem:
> niezależny red-team audyt i naprawy. Nie uruchamiać równolegle z PKG-0184.
> Snapshot PKG-0182: `snapshots/PKG-0182-2026-09-03/`. Raport:
> `docs/rebuild/PKG_0182_COMPREHENSIVE_AUDIT_REPORT.md`. Nie nadpisywać
> `reports/pkg_0182/`.
# PLUS SESSION PROMPT 2A — PKG-0183 / BUNDLE-33

## Niezależny red-team audyt i naprawa po PKG-0182

Skopiuj cały ten dokument do nowej sesji/modelu uruchomionego w katalogu:

`C:\getting_strange`

To jest drugi etap sekwencyjnej kontroli projektu. Nie wykonuj go równolegle z PKG-0182. Twoja rola to niezależny audytor, red-team reviewer, programista naprawczy i współdyrektor artystyczny. Masz sprawdzić faktyczny stan gry po zakończeniu PKG-0182, znaleźć pominięcia oraz fałszywie dodatnie wyniki, a następnie od razu naprawić potwierdzone problemy.

Nie jesteś recenzentem samego raportu. Badasz grę, kod, zasoby, teksty i zachowanie runtime od początku, używając raportów PKG-0182 jedynie jako listy twierdzeń do niezależnej weryfikacji.

## Warunek rozpoczęcia

Rozpocznij pracę wyłącznie wtedy, gdy bieżące pliki na dysku potwierdzają, że PKG-0182 został zamknięty:

- `docs/CURRENT_STATE.md` i `docs/SESSION_LOG.md` opisują faktycznie ukończony PKG-0182;
- istnieje raport i pakiet dowodów PKG-0182;
- istnieje snapshot PKG-0182;
- pełne wyniki końcowe PKG-0182 pochodzą z czasu późniejszego niż jego ostatnia zmiana źródeł.

Jeśli którykolwiek warunek nie jest spełniony, nie poprawiaj PKG-0182 w ciemno. Wykonaj tylko odczytową diagnozę, wypisz brakujące warunki i zakończ werdyktem `BLOCKED — PKG-0182 NOT CLOSED`. Nie przejmuj numeru PKG-0182 i nie zapisuj jego raportów jako własnych.

## Twarde granice projektu

- To jest wyłącznie gra w Godot 4.7.x i GDScript. Nie twórz ani nie proponuj strony WWW, PWA, HTML/CSS/JS, portalu, przeglądarkowego dema ani webowego kanału dystrybucji.
- Nie używaj Git. Projekt nie ma repozytorium, gałęzi ani commitów. Stanem prawdy są bieżące pliki na dysku.
- Nie czytaj snapshotu jako bieżącego źródła. Snapshot jest tylko zamrożonym dowodem.
- Nie eksportuj nowego `.exe`, nie publikuj i nie ogłaszaj wydania. D-168 blokuje release bez osobnej instrukcji właściciela.
- Nie rozszerzaj współdzielonych monolitów dawcy. Preferuj małe sceny, typowane skrypty i istniejące kontrakty.
- Nie dodawaj arkadowego platformingu, ruchomych platform do skakania, kolców, patrolujących przeciwników, pasków zdrowia ani przeszkód istniejących wyłącznie dla wyczucia czasu skoku. Przed jakimkolwiek colliderem innym niż podłoga i ściany przeczytaj `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`.
- Zachowaj fizykę 60 Hz, logiczny viewport 640×360, semantyczne akcje InputMap, szybki restart sceny i deterministyczny stan debugowy.
- Anchor/Yield jest centralną mechaniką kampanii. Nie wymyślaj jej od nowa i nie zastępuj innym systemem.
- Świat pixelizuj oddzielnie; dialogi, napisy, UI i wszystko zawierające tekst muszą pozostać ostre.
- Twierdzenia o zabawie, emocjach, zrozumiałości, napięciu i odbiorze przez ludzi są hipotezami. Testy automatyczne nie są playtestem. W projekcie nie ma zewnętrznych playtestów.

## Obowiązkowa kolejność wejścia

Najpierw przeczytaj w całości, w tej kolejności:

1. `AGENTS.md`;
2. `.github/skills/README.md`;
3. `docs/INDEX.md`;
4. `docs/CURRENT_STATE.md`;
5. `docs/NEXT_SESSION_PROMPT.md`;
6. aktywną specyfikację wskazaną w `CURRENT_STATE.md`;
7. `docs/PLUS_SESSION_PROMPT_2.md`;
8. `docs/rebuild/COMPREHENSIVE_GAME_AUDIT_AND_EVOLUTION_PLAN.md`;
9. raport, manifest pokrycia, rejestr usterek i indeks dowodów utworzone przez PKG-0182;
10. `docs/rebuild/PLAYER_CONTRACT.md`;
11. `docs/rebuild/CAMPAIGN_MAP.md`;
12. `docs/rebuild/LOCATION_FAMILY_BIBLE.md`;
13. `docs/rebuild/ACCEPTANCE_MATRIX.md`;
14. `docs/PROJECT_REBUILD_EXECUTION_PLAN.md`;
15. `VISUAL_DESIGN.md`;
16. `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`;
17. `docs/WORKFLOW.md`;
18. wszystkie źródła i testy wskazane przez powyższe dokumenty.

Następnie uruchom i zachowaj pełny log baseline:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Nie przechodź od razu do napraw. Najpierw ustal prawdę bieżącego dysku i rozbieżności między nią a twierdzeniami PKG-0182.

## Skille i research

Przed pracą wykonaj routing dostępnych skilli. Przeczytaj w całości instrukcje tych, których rzeczywiście użyjesz. Dobierz minimalny, ale wystarczający zestaw do:

- audytu Godot/GDScript, architektury scen i sygnałów;
- QA gry, debugowania, wydajności i wycieków;
- game design, game feel, balansu oraz UX gracza;
- grafiki 2D, pixel-artu, kompozycji, UI, animacji, kamery, shaderów i efektów;
- audio proceduralnego i miksera;
- dialogów, polskiej prozy growej, narracji i lokalizacji;
- accessibility i obsługi wejścia;
- deep research i oceny jakości źródeł.

Nie uruchamiaj skilla tylko po to, by wymienić go w raporcie. Zapisz: nazwę, konkretny cel, artefakt lub decyzję, na którą wpłynął, oraz ograniczenie jego dowodu.

Research internetowy stosuj tam, gdzie aktualna norma, praktyka Godot 4.7, accessibility, typografia, bezpieczeństwo migawki danych albo benchmark porównawczy może zmienić decyzję. Preferuj dokumentację Godot, publikacje pierwotne, standardy i wiarygodne źródła branżowe. Każde twierdzenie zewnętrzne musi mieć adres, datę dostępu i krótką ocenę zastosowalności. Inspiracji z innych gier nie kopiuj; tłumacz zasadę i oceniaj ją względem kontraktów Getting Strange.

## Zasada niezależności dowodu

Traktuj każdy `PASS`, liczbę, screenshot i wniosek PKG-0182 jako hipotezę do ponownego sprawdzenia. Nie wolno nadać ponownie `PASS` tylko dlatego, że:

- wcześniejszy raport tak twierdzi;
- istnieje test nazwany tak samo jak wymaganie;
- bezpośrednie wywołanie metody sceny zakończyło się sukcesem;
- screenshot istnieje, ale nie ma potwierdzonej chronologii i źródła;
- test sprawdza flagę debug zamiast rzeczywistego przebiegu od `Nowa gra`;
- log został przefiltrowany lub allowlista ukrywa nowe ostrzeżenie;
- artefakt powstał przed ostatnią zmianą kodu, sceny, zasobu lub danych.

Dla każdego krytycznego twierdzenia użyj co najmniej dwóch niezależnych metod, jeśli jest to wykonalne, na przykład:

- inspekcja statyczna + przebieg runtime;
- rzeczywista trasa od menu + asercje stanu kampanii;
- świeży capture + pomiar pikseli/układu;
- test migracji + odczyt zapisanego pliku;
- profil procesu + długi soak z wielokrotnym wejściem/wyjściem;
- odsłuch/analiza sygnału + kontrola ustawień mute/volume;
- pełny parser treści + ręczna kontrola próbek wysokiego ryzyka.

Jeżeli drugiej metody nie da się zastosować, zapisz dlaczego i oznacz dowód jako `PARTIAL`, nigdy jako pełny `PASS`.

## Osobny namespace PKG-0183

Nie nadpisuj żadnego artefaktu PKG-0182. Użyj co najmniej:

- `reports/pkg_0183/` dla logów, captures, profili i danych maszynowych;
- `docs/rebuild/PKG_0183_INDEPENDENT_RED_TEAM_REPORT.md` dla raportu głównego;
- nazw testów/harnessów zawierających `pkg_0183` lub równoważny jednoznaczny prefiks;
- `PKG-0183` jako identyfikatora wpisu w `docs/SESSION_LOG.md`;
- `BUNDLE-33` jako identyfikatora pakietu wykonawczego;
- snapshotu wykonanego wyłącznie jako PKG-0183.

Każdy dowód musi zawierać przynajmniej: identyfikator wymagania, czas utworzenia, polecenie lub procedurę, wynik, lokalizację artefaktu, ostatnią istotną zmianę źródeł oraz ograniczenia.

## CEL SESJI

Niezależnie ustal, czy PKG-0182 rzeczywiście zbadał i poprawił całą grę, wykryj wszystkie możliwe do potwierdzenia pominięcia lub regresje, wykonaj naprawy oraz pozostaw trzeci model z wiarygodnym, rozłącznym zestawem dowodów do końcowej certyfikacji.

Zakres oznacza absolutnie wszystkie elementy dostępne na bieżącym dysku, nie tylko aktywnie wymienione w dokumentach:

- konfigurację projektu, autoloady, InputMap, viewport, fizykę i ustawienia renderingu;
- sceny, skrypty, zasoby, dane, shadery, fonty, importy i zależności;
- shell gry, menu, `Nowa gra`, pause, restart, save/load, settings i migracje;
- całą kampanię 20 adresów, wszystkie siedem rodzin lokacji, przejścia, warianty i trzy zakończenia;
- Anchor/Yield, ruch, kolizje, kamerę, interakcje, triggery, state machine i sygnały;
- wszystkie ekrany, HUD, dialogi, ikony, focus, nawigację klawiaturą/padem i skalowanie;
- wszystkie klatki animacji, tweens, AnimationPlayer/AnimationTree, efekty, przejścia i reduced motion;
- całą polską i angielską treść widoczną dla gracza, również teksty rzadkich ścieżek, błędów, napisów, ustawień i zakończeń;
- audio proceduralne, routing busów, pętle, przejścia, głośność, mute i brak trzasków;
- stabilność, pamięć, ObjectDB/RID, wydajność, deterministyczność i zachowanie po długiej sesji;
- accessibility, czytelność, kontrast, migotanie, rozmiary tekstu i alternatywy sterowania;
- wszystkie zmiany kreatywne i pomysły wdrożone w PKG-0182.

## Plan wykonania — małe kroki, jeden bundle

Wykonuj kroki kolejno. Prowadź checklistę `PASS / FAIL / PARTIAL / BLOCKED` z linkami do dowodów.

### Etap A — rekonstrukcja prawdy

1. Zapisz wersję Godot, środowisko, datę, konfigurację display i dokładne polecenia.
2. Zbuduj świeży spis wszystkich plików należących do runtime; wyklucz `.godot/`, `reports/`, eksporty, snapshoty i `archive_retired_web/`.
3. Niezależnie policz sceny, skrypty, zasoby, teksty, adresy, rodziny lokacji, trasy i zakończenia.
4. Porównaj spis z manifestem PKG-0182; sklasyfikuj każdą różnicę jako błąd manifestu, zmianę późniejszą albo świadome wyłączenie.
5. Zweryfikuj chronologię: żadnego dowodu starszego niż kod, scena, zasób lub dane, których dotyczy.
6. Przejrzyj zmiany opisane przez PKG-0182 i znajdź pliki zmienione, ale nieudokumentowane albo udokumentowane bez odpowiadającej zmiany.
7. Zbuduj macierz krytycznych twierdzeń PKG-0182 i przypisz własną metodę falsyfikacji.

### Etap B — red-team testów i bramek

8. Uruchom pełny baseline i przeanalizuj surowy log, nie tylko kod wyjścia.
9. Sprawdź, czy testy mogą przechodzić bez wykonania rzeczywistego kontraktu: fałszywe flagi, nieosiągalne asercje, puste pętle, zbyt szerokie allowlisty, direct-method smoke zamiast flow.
10. Dodaj kontrolowane testy negatywne tam, gdzie bramka nie ma udowodnionej czułości. Test negatywny ma chwilowo lub izolowanie naruszyć warunek i potwierdzić, że bramka zawodzi; nie zostawiaj uszkodzonego stanu.
11. Sprawdź, czy `verify.ps1` uruchamia wszystkie deklarowane testy i czy nie gubi błędów w podprocesach.
12. Zweryfikuj `verify_docs.ps1`, lint traversal, parser warningów i reguły dotyczące wycieków ObjectDB/RID.
13. Potwierdź, że jawne ostrzeżenia `ObjectDB instances were leaked at exit` lub równoważne nie są ignorowane. Znajdź źródło, napraw cykl życia i dodaj bramkę regresji.

### Etap C — rzeczywisty produkt i kampania

14. Uruchom grę od shell/menu i przejdź obowiązkowe trasy: minimalną, pełną, mieszaną oraz każdą z trzech końcówek.
15. Nie teleportuj się ani nie wywołuj bezpośrednio metod, chyba że jest to dodatkowa diagnostyka obok pełnego flow.
16. Dla każdego z 20 adresów potwierdź wejście, wyjście, interakcje, Anchor/Yield, stan kampanii, kolizje, kamerę, pauzę i restart.
17. Dla siedmiu rodzin lokacji potwierdź rozpoznawalność strukturalną, różnice funkcjonalne i brak monotonnego reskinu.
18. Sprawdź kolejność zdarzeń, idempotencję triggerów, ponowne wejścia, przerwane przejścia i szybkie powtarzanie interakcji.
19. Przetestuj save/load/settings na czystym stanie, po zmianie ustawień, po restarcie, na starszym schemacie, na danych uszkodzonych i niepełnych.
20. Sprawdź semantyczne akcje klawiatury i pada, focus, odłączenie urządzenia i konflikt wejść.

### Etap D — grafika, UI i animacja

21. Wykonaj świeże captures normalnym sterownikiem Windows dla reprezentatywnych oraz wysokiego ryzyka stanów wszystkich rodzin lokacji, menu, dialogów i zakończeń.
22. Sprawdź kompozycję, hierarchię, skalę, paletę, kontrast, czytelność sylwetek, głębię, clipping, z-fighting, seam’y, filtrację i stabilność pixel-artu.
23. Potwierdź, że Pixel-Stage obejmuje świat, lecz nie rozmywa tekstu i UI.
24. Przejrzyj każdą animację pod kątem pierwszej/ostatniej klatki, przerwania, zapętlenia, końcowego stanu, zmiany sceny, pause i reduced motion.
25. Sprawdź kamerę przy granicach, restartach, przejściach, Anchor/Yield i gwałtownych zmianach kierunku.
26. Porównaj wizualne zmiany PKG-0182 z `VISUAL_DESIGN.md`, a nie z gustem audytora. Oznacz osobno błąd kontraktu, ryzyko artystyczne i hipotezę odbioru.

### Etap E — słownictwo, narracja, lokalizacja i audio

27. Wyodrębnij cały tekst widoczny dla gracza z PL i EN, w tym rzadkie gałęzie, podpisy, ustawienia, błędy i zakończenia.
28. Sprawdź gramatykę, ortografię, interpunkcję, naturalność, rejestr postaci, terminologię, spójność kanonu, reveal pacing i zgodność znaczenia między językami.
29. Nie wykonuj globalnych zamian bez kontekstu. Chroń identyfikatory, placeholdery, formatowanie, klucze i logikę.
30. Sprawdź overflow, wrapping, clipping, tempo ujawniania, pomijanie tekstu i przełączanie języka w runtime.
31. Prześledź generowanie i routing audio, pętle, głośność, mute, pauzę, przejścia scen i długą sesję. Szukaj trzasków, nakładania instancji i pozostawionych odtwarzaczy.

### Etap F — odporność, wydajność i falsyfikacja zmian kreatywnych

32. Wykonaj soak obejmujący wielokrotne `Nowa gra`, load, restart, pause, zmianę języka i przechodzenie między rodzinami lokacji.
33. Zmierz czas klatki, pamięć, liczbę węzłów/obiektów i stabilność; nie wymyślaj arbitralnych budżetów jako dowodu jakości.
34. Dla każdego kreatywnego ulepszenia PKG-0182 zapisz: jaki problem rozwiązuje, jaki kontrakt zachowuje, jak można je wyłączyć/odizolować, jaki ma dowód techniczny i jaka hipoteza doświadczenia pozostaje otwarta.
35. Spróbuj sfalsyfikować wartość każdej większej zmiany: sprawdź skrajne ustawienia, brak audio, reduced motion, małe/duże okno, powtórzenia i nietypową kolejność działań.

### Etap G — naprawa

36. Prowadź rejestr usterek z kategorią, ciężarem `P0/P1/P2/P3`, reprodukcją, przyczyną, poprawką i dowodem regresji.
37. Napraw wszystkie potwierdzone `P0`, `P1` i `P2`. Napraw również bezpieczne `P3`, jeżeli nie rozszerzają niekontrolowanie zakresu.
38. Po każdej logicznej grupie zmian natychmiast zapisz pliki, uruchom testy celowane i aktualizuj rejestr.
39. Nie pytaj o pozwolenie na rutynowe decyzje techniczne lub artystyczne. Gdy rozwiązanie jest ryzykowne, wybierz najbardziej zachowawcze zgodne z kontraktem i udokumentuj decyzję.
40. Po ostatniej zmianie ponownie wygeneruj wszystkie dowody, których chronologia została unieważniona.

## SRODOWISKO I BASELINE

Raport musi zawierać:

- dokładną wersję Godot i systemu;
- komendy baseline oraz finalne;
- kody wyjścia i ścieżki pełnych surowych logów;
- spis plików wejściowych i świadomych wyłączeń;
- różnice wobec manifestu PKG-0182;
- informację, czy wystąpiły warningi, parser errors, ObjectDB/RID leaks, orphan nodes lub błędy importu;
- jawne rozdzielenie stanu odziedziczonego od problemu wprowadzonego przez PKG-0182 albo PKG-0183.

## KRYTERIA AKCEPTACJI

PKG-0183 można uznać za `PASS` tylko wtedy, gdy jednocześnie:

1. PKG-0182 był faktycznie zamknięty przed startem PKG-0183.
2. Niezależny manifest pokrywa 100% rozpoznanego runtime i wszystkie świadome wyłączenia są uzasadnione.
3. Każde krytyczne twierdzenie ma świeży dowód, a gdzie wykonalne — dwie niezależne metody.
4. Rzeczywisty flow od `Nowa gra` pokrywa trasę minimalną, pełną, mieszaną i trzy zakończenia.
5. Wszystkie 20 adresów i siedem rodzin lokacji mają wynik i dowód.
6. Wszystkie widoczne teksty PL/EN, UI, grafika, animacje, audio, wejście, accessibility, save/settings i lifecycle zostały objęte audytem.
7. Nie pozostało żadne otwarte `P0`, `P1` ani `P2`.
8. Każde pozostawione `P3` ma reprodukcję, wpływ, powód odroczenia i następny krok.
9. Finalny surowy log nie zawiera nieobsłużonych błędów, wycieków ObjectDB/RID ani nowych nieuzasadnionych ostrzeżeń.
10. Kontrole negatywne dowodzą, że najważniejsze bramki rzeczywiście wykrywają naruszenia.
11. Dowody są późniejsze niż ostatnia istotna zmiana.
12. Raport rozdziela `TECHNICAL PASS` od hipotez fun/emotion/comprehension.
13. Nie powstał web ani nowy build `.exe`.
14. Dokumentacja, handoff i snapshot odpowiadają dokładnie stanowi dysku.

Jeśli którykolwiek punkt nie jest spełniony, werdykt nie może brzmieć `PASS`. Użyj `PARTIAL` albo `BLOCKED` i wskaż dokładnie niespełnione wymagania.

## Wymagane artefakty końcowe

Utwórz lub zaktualizuj:

- `docs/rebuild/PKG_0183_INDEPENDENT_RED_TEAM_REPORT.md`;
- `reports/pkg_0183/coverage_manifest.*`;
- `reports/pkg_0183/claim_falsification_matrix.*`;
- `reports/pkg_0183/defect_register.*`;
- `reports/pkg_0183/evidence_index.*`;
- `reports/pkg_0183/research_sources.*`;
- celowane testy i harnessy regresji;
- `docs/CURRENT_STATE.md`;
- `docs/SESSION_LOG.md` z wpisem PKG-0183;
- roadmapę, decyzje, ryzyka i hipotezy, jeśli ich status się zmienił;
- `docs/NEXT_SESSION_PROMPT.md` jako aktualny handoff do PKG-0184;
- `docs/INDEX.md`, jeśli powstały nowe trwałe dokumenty.

W `NEXT_SESSION_PROMPT.md` skieruj trzeci model do `docs/PLUS_SESSION_PROMPT_2_B.mm`, ale każ mu najpierw zweryfikować bieżący stan i zamknięcie PKG-0183.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po wszystkich poprawkach, w tej kolejności:

1. uruchom celowane testy napraw;
2. uruchom `pwsh -NoProfile -File .\tools\verify_docs.ps1`;
3. uruchom `pwsh -NoProfile -File .\tools\verify.ps1` i zachowaj pełny finalny log;
4. przeanalizuj surowy log pod kątem błędów, warningów, wycieków ObjectDB/RID i anomalii procesu;
5. po finalnym teście nie zmieniaj już kodu, scen, zasobów ani danych bez ponownego testu;
6. doprowadź dokumentację i indeks dowodów do zgodności z faktycznym wynikiem;
7. wykonaj:

```powershell
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0183
```

8. potwierdź lokalizację snapshotu i nie używaj go dalej jako źródła roboczego.

Jeżeli `snapshot.ps1` nie obejmuje dokumentacji lub innych kluczowych artefaktów, nie ukrywaj tego. Zapisz lukę narzędzia i zapewnij osobny, niedestrukcyjny dowód integralności bieżących dokumentów bez zmieniania znaczenia snapshotu.

## Format końcowej odpowiedzi modelu

Odpowiedź ma być krótka względem wykonanej pracy, ale kompletna:

- `VERDICT: PASS / PARTIAL / BLOCKED`;
- identyfikator `PKG-0183 / BUNDLE-33`;
- najważniejsze pominięcia lub fałszywe PASS-y PKG-0182;
- naprawione problemy według P0/P1/P2/P3;
- testy i komendy z wynikami;
- stan ObjectDB/RID/warningów;
- ograniczenia dowodów, zwłaszcza brak ludzkich playtestów;
- ścieżka raportu, katalogu dowodów, wpisu w logu, handoffu i snapshotu;
- jawne `RELEASE: BLOCKED BY D-168`.

Nie kończ na samych zaleceniach. Jeśli problem jest możliwy do naprawienia w zakresie projektu, napraw go, zabezpiecz testem i ponownie zweryfikuj.

