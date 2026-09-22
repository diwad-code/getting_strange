# PKG-0193 — CR-A: dwie biografie i spotkanie z bratem

Data: 2026-09-05. Specyfikacja: `CREATIVE_REVIEW_AND_EXPANSION_PLAN.md` §8 CR-A.
Status: CR-A ZAMKNIĘTY TECHNICZNIE — pełny verifier exit 0, 97 bramek.
Model wykonawczy: Codex; Windows, Godot 4.7.2, 640×360, 60 Hz.

## Zakres i mapa dostarczenia

| Adres | Rzeczywisty punkt MRP | Dostarczana treść | Istniejący writer / fakt |
|---|---|---|---|
| 09 | `two_lives` | dwa komplety rzeczy i sweter | `observe_two_lives` / P9_TWO_LIVES |
| 09 | `relation_photo` | uścisk, dłoń, mokre włosy na fotografii | `observe_relation_photo` / P9_RELATION_PHOTO |
| 09 | `private_boundary` | zatrzymanie przy sypialni, zamiar zapytania | `respect_private_boundary` / P9_BOUNDARY, P9_TRACE |
| 10 | `home_task` | niepasujący odruch przy białym kubku | `perform_home_task` / P9_HOME_TASK |
| 10 | `marta_day` | kurtka na kaloryferze i wspólne zamieszkanie kontra parking i rozstanie | `hear_marta_day` / marta_memories_conflict |
| 10 | `marta_boundary` | telefon u Marty, lekarz, wyjście po zapis pracy, zakaz zastępstwa | `accept_marta_boundary` / marta_boundary_accepted |
| 11 | `identity_card` | obcy numer karty, zgodna biometria, profil UCP-4 | `present_identity_card` / local_lena_ucp_profile_found |
| 11 | `record_186_days` | 186 dni Leny, osobny rejestr szpitalny i serwisowy Jakuba | `read_186_day_record` / jakub_public_history_verified |
| 11 | `minimal_report` | 20:40, próba równoległa, brak numeru czytnika | `request_minimal_report` / parallel_test_trace_found, recognition_evidence_public |
| 12 | `jakub_questions` | schowek u babci i niepasująca odpowiedź o tunelu przez łącze | `ask_jakub_control_questions` / jakub_voice_heard |
| 12 | `jakub_meeting` | przerwanie pracy, pogrzeb w pamięci Leny, własna zmiana Jakuba | `meet_jakub` / jakub_met_as_person |
| 12 | `jakub_refusal` | odmowa blizny, dobrowolne sprawdzenie numeru | `accept_jakub_refusal` / recognition_evidence_relational |
| 13 | `marta_source` | zaświadczenie i własny czytnik; surowa próbka tylko gdy zachowana | `mark_marta_source_seen` / recognition_evidence_carried |
| 13 | `institution_source` | wyciąg albo jawna informacja o jego braku | `mark_institution_source_seen` / lokalny marker |
| 13 | `synthesize` | rozpoznanie → pytanie Marty → niewiedza → zamiar szukania | `synthesize_world_difference` / world_recognized, local_lena_search_committed |

Writerzy zachowują moment zapisu w semantycznej akcji oraz negatywne warunki
PKG-0191. Stan faktu nie jest stanem przeczytania. Kolejka prezentacji jest
lokalna i nietrwała; opuszczenie sceny ją usuwa. Ponowne zbadanie rozwiązanego
punktu dostarcza rozmowę ponownie bez nadania dodatkowych faktów.

`creative_scene_presentation.gd` nasłuchuje `clue_inspected` dopiero po moście
MRP i odczytuje `_is_resolved`. Nieudana akcja nie dostarcza udanej rozmowy.
Otwarcie pozostaje w `StationDialogueCue`; właściciel czeka na jego koniec.
W 13 sekwencja to otwarcie / dotychczasowy CRT → winieta → rozmowa syntezy.
Winieta jest niema: zdanie rozpoznania pozostaje w rozmowie po niej, również
po semantic skip. Po reloadzie winieta nie wraca, rozmowę można odczytać.

## Reżyseria i zgodność

- Marta 10 stoi przy kubkach, a Jakub 12 ma podparcie na podłodze przy imadle.
  Rig reaguje na nadawcę rozmowy stanami talk/listen. Przy pytaniach przez
  łącze Jakub nadal pracuje; po odmowie wraca do pracy. Marta po granicy
  odwraca się. Siedząca Wierzbicka zachowuje pozę seated.
- W 13 Marta ma rzeczywisty `CharacterVisualRig`. Stół dostaje asymetryczne
  nośniki tylko po ich wyłożeniu; brak próbki nie jest zastępowany obrazkiem
  próbki. Sofa, zasłona, lampa i odsunięte filiżanki wracają z domu 09/10.
- Poprawiono otwarcia i napisy 11/12 oraz usunięto komentujący plakat 09.
- 07/08: Sadowa 7, lokale 12/14; Marta Kurek, lokator Kowalczyk bez zmian.
- Guidance 09–13 odnosi się do aktywnych punktów; hipoteza zostaje zamknięta
  po związanej z nią akcji. GapLedger zachowuje zapisane ID luk, ale sprawdza
  aktualne fakty P9 i opisuje aktualne braki zamiast klucza/sekretarki.

## Testy i granice dowodu

Nowy `tests/pkg_0193_creative_scene_test.gd` przechodzi MRP przez semantic
InputEventAction i CRT `line_started`. Harness wybiera docelowy punkt przez
ustawienie jego flagi zasięgu; nie jest testem dojścia ciała do każdego punktu.
Sprawdza oddzielenie advance od interakcji, obie wartości próbki, negatywną
syntezę, brak wyciągu, save/reload, ponowny odczyt bez winiety, semantic skip,
reduced motion i 85/100/115% tekstu. Tryb `--capture` zapisuje świeże kadry
normalnym driverem Windows, bez dodatkowego narzędzia nadpisującego stare PNG.

Pierwszy verifier uruchomiono przed edycjami; długi proces trwał podczas
implementacji. Nie jest izolowanym pomiarem niezmienionego stanu PKG-0192.
Za wynik zamknięcia odpowiada osobny pełny przebieg po zakończeniu edycji.

Pierwszy przebieg zakończył się RED na dwóch starych asercjach adresowych
PKG-0158. D-210 / CR-D04 zastępuje je kontrolą budynku Sadowa 7 i przypisania
lokali 12: Kowalczyk / 14: Wolska i Kurek, zachowując niezależność źródeł.
Nowy harness najpierw korzystał z zastanego cinematic-seen w ustawieniach:
poprawiono izolację i dodano wymaganie dwóch faktycznie pokazanych winiet.
Finalny capture: 267 PNG w `reports/pkg_0193/visual_final`, indeks `frames.tsv`.
Bezpośredni ogląd obejmuje `s09_100_005_line`, `s10_100_018_line`,
`s11_100_041_line`, `s12_100_065_line`, `s13_100_077_line`,
`s13_100_082_vignette`, `s13_100_085_line`, `s13_100_176_line`,
`s13_100_181_vignette`, `s10_85_211_line`, `s10_115_253_line`.
Obraz pokazuje nośnik/brak próbki oraz właściwe twarze i ostre kwestie;
nie przypisuje temu oceny odbioru. Automatyczny pomiar wysokości wszystkich
wyświetlonych tekstów potwierdził brak ucięcia w badanych skalach.

Pełny przebieg run2 przeszedł ciągły M1 i wszystkie 14 bramek, lecz wykrył
drugi historyczny konflikt w PKG-0184: wymagał w 11 porównywania śladów,
w 12 sekretarki/balkonu, a w 13 dokumentów szuflady. Były to otwarcia oparte
na dormant P7, nie rzeczywistych akcjach P9 opisanych w planie. Zachowano
całą bramkę, zmieniając tylko tę kontrolę na czytnik kart/Wierzbicką,
łącze/imadło i Martę/torbę/stół. Dodano negatywną kontrolę starych wskazówek
oraz obecność wszystkich dziewięciu rzeczywistych ID punktów tych scen.
Rzeczywiste dostarczenie kwestii nadal sprawdza dodatkowo PKG-0193.

Końcowy run3: `Verification passed.`, exit 0, wszystkie 97 bramek GREEN,
w tym 0158/0160, M1/14 bramek 0177, 0182/0183/0184, 0186/0187 i 0190–0193.
Log roboczy: `reports/pkg_0193_final_verify_run3.log`. Brak ERROR, SCRIPT ERROR
i wycieków; siedem warningów dozwolonych przez fail-closed policy pochodzi
z negatywnych prób zapisu/ustawień. `verify_docs.ps1`: DOCS PASS, 52 pliki.
Snapshot: `tools/snapshot.ps1 -Package PKG-0193`, katalog
`snapshots/PKG-0193-2026-09-05`; oprócz domyślnych scenes/scripts/tests
zamrożenie obejmuje kopię docs/tools oraz project.godot i AGENTS.md.

Opinia redakcyjna: „Oddałaś mi ją na parkingu” ma wyraźnego adresata i
kwestionuje konkretną wersję Marty; „W którym tunelu?” pozostawia rozbieżność
bez wykładu. Są to oceny warsztatowe, nie dowód emocji lub zrozumienia.
Zachowane portrety mają ograniczony repertuar ekspresji. Nie wykonano nowej
generacji assetów ani poprawy całej scenografii instytucji 11; dalsza wspólna
reżyseria 11/17 należy do CR-B/D. CR-B, CR-C i CR-D nie są wynikiem CR-A.
F-0184-010 pozostaje oddzielnym długiem. GATE-REL nadal BLOCKED BY D-168.
