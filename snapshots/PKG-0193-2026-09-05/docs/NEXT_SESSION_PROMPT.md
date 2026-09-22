# NEXT_SESSION_PROMPT — CR-B: odpowiedź, koszt i cudza zgoda

## CEL SESJI

Wykonaj CR-B z `docs/rebuild/CREATIVE_REVIEW_AND_EXPANSION_PLAN.md` §8:
cztery powiązane warstwy 14–18 — świadomy test sygnału, konkretny koszt/echo
domu, oferta UCP i cudza zgoda, ujawnienie prawdy oraz prognozy metod.
Rola: Lead Programmer & Art Director. Decyzje rutynowe podejmuj autonomicznie.
To następna sesja po CR-A / PKG-0193, nie refaktor MRP ani release.
Nadaj kolejny wolny numer z SESSION_LOG (spodziewany PKG-0194).

## SRODOWISKO I BASELINE

C:\getting_strange; Godot 4.7.2; Windows; 640×360; fizyka 60 Hz; no Git.
Aktualny stan i wyniki zamknięcia: `docs/CURRENT_STATE.md`.
Raport CR-A: `docs/rebuild/PKG_0193_CREATIVE_SCENES.md`.
Potwierdzone zamknięcie CR-A: pełny verify.ps1 exit 0, 97 bramek,
`Verification passed.`, docs PASS (52), 267 świeżych PNG Windows z indeksem.
Dwa historyczne kontrakty tekstowe 0158/0184 zostały jawnie zaktualizowane
do Sadowej 7 i rzeczywistych punktów P9; ich kontrole pozostają aktywne.
Nie nadpisuj dowodów `reports/pkg_0182*`…`pkg_0193*`.
Przed edycjami: `pwsh -NoProfile -File .\tools\verify.ps1`.

## Obowiązkowa lektura

1. AGENTS.md, docs/INDEX.md, CURRENT_STATE.md, ten prompt, WORKFLOW.md.
2. Cały CREATIVE_REVIEW_AND_EXPANSION_PLAN.md, zwłaszcza §4, §7 i CR-B.
3. PLAYER_CONTRACT, CAMPAIGN_MAP, LOCATION_FAMILY_BIBLE, ACCEPTANCE_MATRIX;
   odpowiednie fragmenty czterech dokumentów docs/narrative.
4. scripts/levels/station_14.gd…station_18.gd oraz odpowiadające sceny w całości.
5. creative_scene_lines.gd, creative_scene_presentation.gd, CRTDialogueBox,
   CharacterVisualRig, CinematicDirector/catalog/vignette; aktualny GameStateManager
   w zakresie kosztów, zgód, prognoz i save.
6. tests/pkg_0162…0166_smoke_test.gd, pkg_0175/0177_smoke_test.gd,
   pkg_0190_cinematics_test.gd, pkg_0193_creative_scene_test.gd i tools/verify.ps1.
   Jeśli rzeczywiste nazwy plików się różnią, ustal je na dysku.

## Implementacja

- 14: zachowaj oba zachowania martwego obwodu.
- 15: przygotowanie celowo błędnego trzeciego impulsu jest jawną czynnością
  w tym samym nadajniku. Log rozdziela zamiar miejscowej Leny i późniejszą
  interwencję UCP; notatka podaje abort po braku odpowiedzi i brak uprzedniej zgody.
- Przed napisaniem logu ustal przyczynę przejścia przy leave_on_time zgodnie
  z CR-D §2: pierwszy obowiązkowy odczyt ustanawia kontakt; powtórka zabezpiecza
  próbkę i opóźnia powrót. Zsynchronizuj kanon; nie fabrykuj flag.
- 16: pokaż alternatywy przed wyborem, potem jeden konkretny ubytek.
  CR-A ustanowił kurtkę na kaloryferze w pamięci miejscowej Marty. Przybyła
  pamięta parking i rozstanie. Nie myl ciągłości, nie usuwaj całej relacji.
  Gałąź bez surowej próbki nie może mówić o zachowanym pełnym nośniku.
  Echo domu dostarcza wiadomość domowej Marty i przesłankę przeciw prostemu swapowi.
- 17: trzy akty w trzech punktach: para zdarzeń Linii 4, oferta Wierzbickiej,
  prośba Leny i odpowiedź Jakuba. Jego cel codzienny z 12: oddać napęd przed
  końcem zmiany. Każdy zakres refused/limited/granted ma własną wypowiedź.
- 18: stany pełnej/częściowej/wstrzymanej prawdy mają konkretną treść oraz
  granicę Marty. Prognoza pokazuje chronioną wartość, znaną stratę,
  niepewność i faktyczne braki. Ruch Leny wybiera jej prośbę, nie wolę Jakuba.
- Użyj małych lokalnych komponentów i aktualnego CRT; jeden właściciel kolejki.
  Własności prezentacji nie są dowodem przeczytania. Zachowaj semantic skip,
  reduced motion, swobodne wyjścia i szybki restart.

## KRYTERIA AKCEPTACJI

Rzeczywiste interakcje dostarczają treść, nie tylko flagi lub niepodpięte tablice.
Test obejmuje dwie gałęzie początku/kosztu, trzy zgody, trzy stany prawdy,
braki źródeł, powrót i save/reload przed/po zatwierdzeniu.
Dotychczasowy wybór 18→42A/B/C i wszystkie kontrakty save pozostają.
Nie dodawaj stacji, colliderów, autoloadów ani nowych typów MRP; ≤3 istotne
interakcje na adres. Nie rozszerzaj monolitów MRP/VectorStageEnvironment.
Nie usuwaj linta 0165: jego stare zakazy pojęć w całym station_17 mogą
kolidować z rozpoznaniem w 13. Nazwij konflikt i zastąp go równoważną lub
silniejszą kontrolą faktycznie prezentowanego tekstu i stanu wiedzy.
Zachowaj wszystkie istniejące bramki; po spójnej zmianie pełny verifier.
Normalny driver Windows: świeże kadry kosztu, odpowiedzi i prognoz, z inspekcją.
Werdykty odbioru pozostają hipotezami. PRODUCT GO i GATE-REL bez zmian.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Zsynchronizuj CURRENT_STATE, SESSION_LOG (append-only), INDEX, specyfikację,
roadmapę, decyzje/ryzyka i odpowiedni kanon. NEXT_SESSION_PROMPT ma opisywać
CR-C po rzeczywistym wyniku CR-B. Potem:
`pwsh -NoProfile -File .\tools\verify_docs.ps1`,
`pwsh -NoProfile -File .\tools\verify.ps1`,
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-NNNN`.
Sprawdź zakres snapshot.ps1: obecna wersja kopiuje tylko scenes/scripts/tests;
przy zamknięciu dołącz dokumentację i narzędzia do tej samej nowej zamrożonej
kopii, bez odczytywania starych snapshotów jako stanu bieżącego.
Raport końcowy: numer pakietu, wdrożenie, testy, kadry, ograniczenia, handoff.
