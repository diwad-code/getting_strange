# PLUS SESSION PROMPT 2B — PKG-0184 / BUNDLE-34

## Końcowa niezależna recertyfikacja i ostatnie naprawy

Skopiuj cały ten dokument do trzeciej, świeżej sesji/modelu uruchomionego w katalogu:

`C:\getting_strange`

To jest trzeci i ostatni etap sekwencyjnej kontroli. Uruchom go dopiero po pełnym zamknięciu PKG-0182 oraz niezależnego red-team PKG-0183. Jesteś finalnym recertyfikatorem produktu, niezależnym QA leadem, programistą naprawczym i strażnikiem integralności dowodów.

Nie masz potwierdzić, że poprzednie modele dużo zrobiły. Masz ustalić, czy aktualna gra na dysku rzeczywiście spełnia kontrakty, czy komplet dowodów jest wiarygodny i czy po dwóch wcześniejszych pakietach nie zostały luki lub regresje. Każdy wcześniejszy `PASS` pozostaje hipotezą, dopóki nie przejdzie świeżej kontroli PKG-0184.

## Warunek rozpoczęcia

Pracę mutującą rozpocznij wyłącznie, gdy bieżące dokumenty i artefakty potwierdzają:

- zamknięcie PKG-0182 oraz snapshot PKG-0182;
- zamknięcie PKG-0183 oraz snapshot PKG-0183;
- istnienie rozłącznych raportów i katalogów dowodów obu pakietów;
- brak równolegle działającego modelu zapisującego pliki projektu;
- końcowe dowody PKG-0183 są późniejsze niż jego ostatnia istotna zmiana.

Jeżeli warunki nie są spełnione, wykonaj odczytową kontrolę gotowości i zakończ `BLOCKED — SEQUENTIAL PRECONDITION FAILED`. Nie naprawiaj cudzej niedomkniętej sesji, nie przejmuj jej numeru pakietu i nie nadpisuj jej artefaktów.

## Twarde granice

- Getting Strange jest wyłącznie grą Godot 4.7.x/GDScript. Web, PWA, portal, HTML/CSS/JS i przeglądarkowe demo są permanentnie poza zakresem.
- Projekt nie używa Git. Nie uruchamiaj żadnych poleceń Git i nie inicjalizuj repozytorium.
- Bieżące pliki na dysku są źródłem prawdy. Snapshoty są zamrożonymi kopiami dowodowymi, nie workspace’em.
- Nie eksportuj ani nie publikuj `.exe`. Nawet końcowy pozytywny werdykt nie uchyla D-168 i nie jest zgodą właściciela na release.
- Zachowaj Godot 4.7.x, GDScript, 60 Hz, viewport 640×360, semantyczne InputMap, deterministyczny debug i szybki restart.
- Zachowaj aktywne kanony P9: 20 adresów, siedem rodzin lokacji, Player Contract, Rowien Vector-Stage, traversal canon i Anchor/Yield.
- Nie dodawaj arkadowych przeszkód zabronionych przez D-099. Każde wyzwanie fizyczne ma być sensowne w świecie bez odwołania do „gracza”.
- Pixelizacja dotyczy świata. Tekst, dialogi i UI mają pozostać ostre.
- Automatyka dowodzi zachowania technicznego i kontraktów, nie zabawy, emocji ani ludzkiego zrozumienia. Brak zewnętrznych playtestów pozostaje ograniczeniem.

## Obowiązkowa kolejność czytania i baseline

Przeczytaj w całości, kolejno:

1. `AGENTS.md`;
2. `.github/skills/README.md`;
3. `docs/INDEX.md`;
4. `docs/CURRENT_STATE.md`;
5. `docs/NEXT_SESSION_PROMPT.md`;
6. aktywną specyfikację z `CURRENT_STATE.md`;
7. `docs/PLUS_SESSION_PROMPT_2.md`;
8. `docs/PLUS_SESSION_PROMPT_2_A.md`;
9. ten dokument;
10. `docs/rebuild/COMPREHENSIVE_GAME_AUDIT_AND_EVOLUTION_PLAN.md`;
11. komplet raportów, manifestów, rejestrów usterek i indeksów dowodów PKG-0182 i PKG-0183;
12. `docs/rebuild/PLAYER_CONTRACT.md`;
13. `docs/rebuild/CAMPAIGN_MAP.md`;
14. `docs/rebuild/LOCATION_FAMILY_BIBLE.md`;
15. `docs/rebuild/ACCEPTANCE_MATRIX.md`;
16. `docs/PROJECT_REBUILD_EXECUTION_PLAN.md`;
17. `VISUAL_DESIGN.md`;
18. `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`;
19. `docs/WORKFLOW.md`;
20. wszystkie aktualne źródła i testy wskazane przez te dokumenty.

Potem uruchom baseline i zachowaj pełny surowy log:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Jeżeli baseline jest czerwony, nie obniżaj bramki. Zdiagnozuj przyczynę, określ pakiet pochodzenia i napraw ją w PKG-0184, jeśli jest w zakresie.

## Skille i źródła

Wykonaj routing dostępnych skilli i przeczytaj w całości instrukcje tych faktycznie użytych. Dobierz narzędzia do końcowej certyfikacji Godot, QA, debugowania, grafiki, animacji, UI/UX, accessibility, narracji PL/EN, audio, wydajności, architektury i deep research.

Skille nie są dowodem. Każdy wpływ skilla powiąż z konkretną kontrolą, zmianą lub artefaktem. Aktualne fakty zewnętrzne weryfikuj w źródłach pierwotnych — przede wszystkim dokumentacji Godot, standardach i publikacjach technicznych. Zapisz adres, datę dostępu, zastosowanie i ograniczenia. Nie kopiuj rozwiązań z innych gier; używaj ich najwyżej jako punktu odniesienia dla zasady projektowej.

## Osobny namespace PKG-0184

Nie nadpisuj raportów ani dowodów PKG-0182/PKG-0183. Użyj:

- `reports/pkg_0184/` dla wszystkich nowych logów, captures, profili i macierzy;
- `docs/rebuild/PKG_0184_FINAL_CERTIFICATION_REPORT.md` jako raportu głównego;
- prefiksu `pkg_0184` dla nowych testów i harnessów;
- `PKG-0184` w `docs/SESSION_LOG.md`;
- `BUNDLE-34` jako identyfikatora bundle’a;
- osobnego snapshotu PKG-0184.

Nie kopiuj starych dowodów do nowego katalogu i nie zmieniaj ich dat. Jeżeli wcześniejszy artefakt pozostaje pomocny, odwołaj się do niego jako materiału historycznego, ale ostateczny werdykt oprzyj na świeżym dowodzie PKG-0184.

## CEL SESJI

Wykonać końcową, niezależną recertyfikację całej aktualnej gry, sfalsyfikować kluczowe twierdzenia dwóch wcześniejszych modeli, naprawić każdy pozostający problem techniczny lub kontraktowy w zakresie oraz wydać precyzyjny werdykt bez mylenia gotowości technicznej z ludzkim odbiorem i bez uruchamiania release’u.

## Standard dowodu końcowego

Każdy krytyczny wymóg musi mieć:

1. identyfikator kontraktu lub wymagania;
2. świeżą procedurę wykonania;
3. surowy wynik i kod wyjścia;
4. ścieżkę artefaktu;
5. czas późniejszy niż ostatnia zmiana objętych plików;
6. kontrolę negatywną lub drugą niezależną metodę, jeśli jest wykonalna;
7. ograniczenie dowodu;
8. werdykt `PASS / FAIL / PARTIAL / BLOCKED`.

Nie wystarcza nazwa testu, obecność pliku, screenshot bez pochodzenia, flaga debug, bezpośrednie wywołanie metody ani raport poprzedniej sesji. Krytyczne ścieżki wymagają rzeczywistego flow od uruchomienia gry.

## Plan wykonania — małe kroki, jeden bundle

### Etap A — kontrola sekwencji i integralności

1. Potwierdź, że PKG-0182 i PKG-0183 są zamknięte i nie zachodzą na siebie chronologicznie.
2. Zapisz wersję Godot, system, display driver, datę oraz dokładne polecenia.
3. Utwórz świeży spis runtime, testów, danych i trwałej dokumentacji; wyłącz tylko `.godot/`, `reports/`, eksporty, snapshoty i martwy `archive_retired_web/`.
4. Porównaj aktualny dysk z manifestami obu modeli i wyjaśnij każdą różnicę.
5. Sprawdź unikalność namespace’ów, brak nadpisanych raportów i poprawną chronologię dowodów.
6. Zweryfikuj, czy dokumentacja nie deklaruje wyników mocniejszych niż wskazują surowe logi.
7. Utwórz macierz: wymaganie → twierdzenie PKG-0182 → wynik red-team PKG-0183 → świeży wynik PKG-0184.

### Etap B — ponowna certyfikacja bramek

8. Uruchom pełny baseline i przeanalizuj cały log, nie tylko podsumowanie.
9. Sprawdź `verify.ps1`, `verify_docs.ps1`, linter traversal, testy kontraktowe, parser warningów oraz propagację kodów wyjścia.
10. Dla najważniejszych bramek wykonaj izolowaną kontrolę negatywną, by dowieść, że potrafią zawieść.
11. Potwierdź brak pustych testów, tautologicznych asercji, debug bypassów i direct-method smoke przedstawionych jako pełna trasa.
12. Potwierdź zero nieobsłużonych błędów, parser errors, import failures, orphan nodes oraz ObjectDB/RID leaks. Ostrzeżenie o wycieku jest błędem certyfikacji, nawet jeśli proces zwraca kod 0.

### Etap C — pełny produkt od shell do zakończeń

13. Uruchom rzeczywisty flow od shell/menu i `Nowa gra`.
14. Przejdź i udokumentuj trasę minimalną, pełną, mieszaną oraz każdą z trzech końcówek.
15. Potwierdź wszystkie 20 adresów i siedem rodzin lokacji: wejścia, wyjścia, przejścia, interakcje, Anchor/Yield, kamera, kolizje, pauza i restart.
16. Sprawdź rzadkie i nieidealne kolejności: powrót, spam wejścia, przerwanie animacji, szybka zmiana scen, podwójny trigger, ładowanie w trakcie stanu przejściowego.
17. Certyfikuj campaign save, settings save, niezależne wersje schematów, migracje, dane uszkodzone, reset kampanii i trwałość po restarcie procesu.
18. Certyfikuj klawiaturę i pad, focus, remapping/semantyczne akcje, odłączenie urządzenia i nawigację bez myszy.

### Etap D — grafika, animacja i UI

19. Wykonaj świeży, reprezentatywny zestaw capture’ów normalnym sterownikiem Windows po ostatniej zmianie wizualnej.
20. Obejmij menu, HUD, dialogi, ustawienia, wszystkie rodziny lokacji, krytyczne warianty kampanii i trzy zakończenia.
21. Sprawdź zgodność z Rowien Vector-Stage: kompozycję, paletę, głębię, sylwetki, skalę, światło, pixel-stage, ostrość tekstu, seam’y, clipping i stabilność kamery.
22. Sprawdź wszystkie systemy animacji i tweeny przy rozpoczęciu, końcu, pętli, przerwaniu, pause, zmianie sceny i reduced motion.
23. Sprawdź UI w wspieranych rozmiarach/trybach okna, PL/EN, długich napisach, focusie i skrajnych stanach wartości.
24. Porównaj kreatywne zmiany PKG-0182 oraz naprawy PKG-0183 z kanonem. Szukaj regresji estetycznych i funkcjonalnych wynikłych z samych poprawek.

### Etap E — komplet tekstu, narracji i audio

25. Ponownie wyodrębnij cały tekst widoczny dla gracza w PL i EN. Nie polegaj wyłącznie na liście poprzednich modeli.
26. Sprawdź pisownię, gramatykę, naturalność, głosy postaci, terminologię, spójność kanonu, progresję dziwności i znaczenie między językami.
27. Chroń klucze, identyfikatory, placeholdery i logikę; żadnych niekontekstowych globalnych zamian.
28. Uruchom teksty w UI i sprawdź overflow, wrapping, clipping, reveal/skip, zmianę języka oraz ostrość renderingu.
29. Sprawdź proceduralne audio, routing busów, głośność, mute, pauzę, zapętlenie, zmianę scen, równoległe instancje i długą sesję.
30. Odróżnij brak błędów technicznych od hipotezy, że tekst, grafika lub audio dobrze działa emocjonalnie.

### Etap F — stability, accessibility i performance

31. Wykonaj soak z wielokrotnym `Nowa gra`, load, restart, pause, zmianą języka, mute/reduced motion oraz przejściami między rodzinami lokacji.
32. Rejestruj czas klatki, pamięć, liczbę obiektów/węzłów i trend między iteracjami. Nie przedstawiaj wymyślonego budżetu jako normy produktu.
33. Sprawdź kontrast, czytelność, migotanie, motion sensitivity, nawigację focus, alternatywy wejścia i stan bez audio.
34. Powtórz scenariusze, które wcześniej ujawniały wycieki lub niestabilność, ze świeżym pomiarem.
35. Sprawdź deterministyczność debug i brak zależności testów od kolejności wykonania.

### Etap G — ostatnie naprawy

36. Prowadź rejestr wszystkich świeżych usterek z reprodukcją, przyczyną, ciężarem `P0/P1/P2/P3`, właścicielem pakietu pochodzenia i testem regresji.
37. Napraw natychmiast wszystkie `P0`, `P1` i `P2` oraz bezpieczne `P3` mieszczące się w zakresie.
38. Nie pytaj o zgodę na rutynowe decyzje. Wybieraj rozwiązania zachowawcze, małe i zgodne z aktywnymi kontraktami.
39. Po każdej grupie zmian zapisuj na dysk, uruchamiaj celowane testy i aktualizuj rejestr.
40. Po ostatniej zmianie unieważnij starsze zależne dowody i wygeneruj je ponownie.

### Etap H — werdykt wieloosiowy

41. Wydaj osobno `TECHNICAL CERTIFICATION: PASS / PARTIAL / FAIL`.
42. Wydaj osobno `PRODUCT CONTRACT CERTIFICATION: PASS / PARTIAL / FAIL`.
43. Wydaj osobno `EVIDENCE INTEGRITY: PASS / PARTIAL / FAIL`.
44. Zapisz `HUMAN RECEPTION: OPEN — NO EXTERNAL PLAYER EVIDENCE` niezależnie od pozostałych wyników.
45. Zapisz `RELEASE: BLOCKED BY D-168 — OWNER INSTRUCTION REQUIRED` nawet przy trzech technicznych PASS-ach.

Nie używaj ogólnego „wszystko działa”, jeśli choć jedna oś jest `PARTIAL` albo `FAIL`.

## SRODOWISKO I BASELINE

Raport końcowy musi podawać:

- środowisko i wersję silnika;
- komendy, kody wyjścia oraz ścieżki pełnych logów baseline/final;
- aktualny spis i różnice wobec manifestów PKG-0182/0183;
- pochodzenie każdego wykrytego problemu, jeśli można je potwierdzić;
- stan warningów, ObjectDB/RID, importów, parsera i procesów potomnych;
- chronologię ostatniej zmiany względem każdego krytycznego dowodu;
- rozdzielenie obserwacji, wniosków, hipotez i nieweryfikowalnych twierdzeń doświadczeniowych.

## KRYTERIA AKCEPTACJI

Końcowe `PASS` na osiach technicznej, kontraktowej i integralności dowodów wymaga łącznie:

1. prawidłowej, sekwencyjnej historii PKG-0182 → PKG-0183 → PKG-0184;
2. 100% aktualnego manifestu runtime albo jawnego `PARTIAL` dla nierozwiązanego wyłączenia;
3. świeżych dowodów późniejszych niż ostatnie zmiany;
4. prawdziwego flow od `Nowa gra` dla trasy minimalnej, pełnej, mieszanej i trzech zakończeń;
5. wyników dla wszystkich 20 adresów i siedmiu rodzin lokacji;
6. pełnego zakresu grafiki, UI, animacji, tekstu PL/EN, audio, wejścia, accessibility, save/settings, lifecycle, stabilności i performance;
7. skutecznych kontroli negatywnych krytycznych bramek;
8. zera otwartych `P0`, `P1` i `P2`;
9. jawnego rejestru wszystkich `P3` z wpływem i następnym krokiem;
10. zera nieobsłużonych błędów, ObjectDB/RID leaks, orphan nodes, parser/import errors i nowych nieuzasadnionych warningów;
11. braku regresji wprowadzonych przez kreatywne zmiany PKG-0182 i remediacje PKG-0183;
12. zgodnej z dyskiem dokumentacji, raportów, indeksu dowodów, handoffu i snapshotu;
13. braku webu, Git i nowego eksportu `.exe`;
14. uczciwego pozostawienia ludzkiego odbioru jako niepotwierdzonej hipotezy.

Niespełnienie dowolnego warunku obniża odpowiednią oś do `PARTIAL` lub `FAIL`. Nie zmieniaj kryterium po zobaczeniu niekorzystnego wyniku.

## Wymagane artefakty

Utwórz lub zaktualizuj:

- `docs/rebuild/PKG_0184_FINAL_CERTIFICATION_REPORT.md`;
- `reports/pkg_0184/final_coverage_manifest.*`;
- `reports/pkg_0184/cross_package_claim_matrix.*`;
- `reports/pkg_0184/final_defect_register.*`;
- `reports/pkg_0184/final_evidence_index.*`;
- `reports/pkg_0184/research_sources.*`;
- świeże logi, captures, profile i wyniki negatywnych kontroli;
- testy/harnessy regresji dla napraw PKG-0184;
- `docs/CURRENT_STATE.md`;
- `docs/SESSION_LOG.md` z PKG-0184;
- roadmapę, decyzje, ryzyka i hipotezy, jeśli ich status się zmienił;
- `docs/NEXT_SESSION_PROMPT.md` z uczciwym następnym krokiem wynikającym z werdyktu;
- `docs/INDEX.md` dla nowych trwałych dokumentów.

Jeżeli trzy osie uzyskają `PASS`, kolejny handoff nie może samowolnie zarządzić release’u. Może wskazać, że techniczne warunki są spełnione, lecz musi zachować blokadę D-168 i brak dowodu ludzkiego odbioru.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po ostatniej naprawie wykonaj kolejno:

1. wszystkie celowane testy regresji;
2. `pwsh -NoProfile -File .\tools\verify_docs.ps1`;
3. `pwsh -NoProfile -File .\tools\verify.ps1` z pełnym zachowanym logiem;
4. analizę surowego logu pod kątem warningów, błędów, ObjectDB/RID leaks i anomalii;
5. ponowną generację każdego artefaktu unieważnionego przez ostatnią zmianę;
6. aktualizację dokumentacji dokładnie do faktycznego wyniku;
7. snapshot:

```powershell
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0184
```

8. potwierdzenie ścieżki snapshotu bez dalszego używania go jako źródła.

Jeśli narzędzie snapshotu nie obejmuje dokumentacji, wpisz to jako ograniczenie i zachowaj osobny niedestrukcyjny dowód integralności bieżących dokumentów. Nie udawaj, że snapshot zawiera pliki, których skrypt faktycznie nie kopiuje.

## Format końcowej odpowiedzi modelu

Podaj:

- `PKG-0184 / BUNDLE-34`;
- cztery werdykty: techniczny, kontraktowy, integralność dowodów i human reception;
- `RELEASE: BLOCKED BY D-168`;
- najważniejsze znalezione luki lub regresje i ich pochodzenie;
- liczbę naprawionych oraz otwartych `P0/P1/P2/P3`;
- testy, polecenia i wyniki;
- stan warningów i ObjectDB/RID;
- ograniczenia empiryczne;
- ścieżki raportu, dowodów, logu sesji, handoffu i snapshotu.

Nie kończ na audycie, jeśli potwierdzony problem da się bezpiecznie naprawić w ramach projektu. Napraw, dodaj test regresji, wygeneruj świeży dowód i dopiero wtedy wydaj końcowy werdykt.
