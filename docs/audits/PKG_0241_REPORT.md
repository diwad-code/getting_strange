# Getting Strange — audyt grafiki, animacji i UX
## PKG-0241 · 22 września 2026

**Werdykt: wdrożono pakiet napraw potwierdzonych usterek. Nie przyznano PRODUCT GO.** Gra ma rozpoznawalny język obrazu, ale stan zastany zawierał problemy, które przeszkadzały w jego odbiorze: niewidoczną postać, niezgodność podłogi i stóp, fragmenty scenografii przyklejone do klatek Leny oraz nakładające się menu. Do tego dochodziły rzeczywiste błędy obsługi dialogu, pauzy i sterowania. Nie były to wyłącznie kwestie gustu.

Zapis kodu i siedmiu PNG został potwierdzony sumami kontrolnymi na GitHubie; stan po usunięciu jednorazowych narzędzi publikacji: `d9f5fb91a3ed6ff2669043d29f1c1115683aac62`.

Baza audytu: `71d937329385368e718b947b43f84fed00324d57`, czyli main po połączeniu narracyjnego PKG-0239. Zmiany art/UX: `fix/art-ux-audit-0241`. Wcześniejsza gałąź `fix/visual-animation-ux-2026-09-22` zawierała narzędzia przygotowawcze, nie poprawki gry; nie została nadpisana. Dokumenty z 16 września opisujące PKG-0238 i brak repozytorium były historyczne, nie stanowiły dowodu obecnej sprawności.

### Co rzeczywiście zbadano

Uruchomiono Godota `4.7.2.stable.official.ed1daf0bf`. Kadry powstały normalnym sterownikiem X11/OpenGL Compatibility na Linux/Mesa llvmpipe, pod Xvfb, nie atrapą renderu ani przez odrysowanie ekranów. Audyt objął 22 aktywne sceny, 88 kadrów przed zmianami i 88 po zmianach, menu polskie i angielskie przy skalach 85/100/115%, 36 źródłowych klatek Leny i 14 plansz winiet. Obejrzano plansze zbiorcze oraz powiększenia znalezionych usterek. Dodatkowy pomiar tekstu objął 247 literalnych par osoba/kwestia (220 różnych tekstów) z aktywnych źródeł, w trzech skalach: 741 pomiarów.

Render bazowy wymagał jednej jawnej poprawki rozruchowej: dopisania typu `bool` w `narrative_repair_rules.gd`. Poza nią środowisko porównawcze zachowało oryginalne źródła. Oryginalny import zapisał błąd kompilacji mimo kodu wyjścia 0 — dlatego sam exit code nie jest wystarczającym dowodem.

Materiał dowodowy: `before/` i `after/` wraz z manifestami, `baseline_import.log`, `regression_final.json`, `text_corpus_layout.json`, logi zestawów `baseline_suite/` i `release_suite/` (pośredni `final_suite/` zachowano jako dowód kontroli podeszwy), `thought_before.png`, `thought_after.png`, `sprite_cleanup_after.png`. Są w dołączonym archiwum dowodów; duże obrazy i logi pozostają artefaktami, nie częścią źródeł gry. Narzędzia odtworzenia: `tools/capture_pkg_0241.gd`, `tests/pkg_0241_visual_ux_test.gd` i polecenia w planie wdrożenia.

## 1. Usterki i wprowadzone zmiany

### A-01 · P0 · Świeży import nie kompilował reguł narracyjnych

**Dowód:** `scripts/levels/narrative_repair_rules.gd`, `carrier_pairs`, w bazie linia 90: wnioskowanie typu z porównania wartości Dictionary/Variant. Błąd znalazł się w rzeczywistym logu importu. **Zmiana:** jawne `var sample: bool = ...`. Nie zmieniono warunku ani decyzji fabularnej. **Odbiór:** ponowny import i uruchomienie scen; brak tego błędu. Naprawa jest warunkiem przeprowadzenia audytu, nie nową redakcją opowieści.

### A-02 · P1 · Sprzedawca znikał w kiosku

**Dowód:** brak czterech PNG pod `assets/characters/vendor/`, ostrzeżenia CharacterVisualRig i puste miejsce postaci w kadrze stacji 06. W repozytorium zachowały się jednak odpowiadające im importy `.ctex`. **Zmiana:** odzyskano oryginalne idle/listen/talk_0/talk_1 bez tworzenia zastępczej postaci. W trakcie publikacji potwierdzono przyczynę utraty źródeł: `.gitignore` wykluczał zarówno ogólne `vendor/`, jak i konkretnie `assets/characters/vendor/`. Dodano końcowy wyjątek dla tego katalogu i PNG, zamiast polegać na wymuszonym dodawaniu plików. Pochodzenie zapisano w `PKG_0241_ASSET_PROVENANCE.json`, z SHA oryginalnych blobów i wynikowych PNG. **Odbiór:** cztery zasoby istnieją, mają 64×104; sprzedawca jest obecny w nowym kadrze 06. Oryginalne talk_0 i talk_1 są identyczne — odzyskanie zasobów nie jest dowodem poprawnej animacji ust; ten dług pozostaje jawny.

### A-03 · P1 · Finały miały podłogę 18 pikseli nad rysunkiem

**Dowód:** `scenes/levels/station_42a.tscn`, `station_42b.tscn`, `station_42c.tscn`, FloorMain i rozmiar jego kształtu; rysowana linia posadzki w skryptach finałów na Y=306. W bazie powierzchnia kolizji wypadała na Y=288. Lena stała nad widoczną podłogą; Marta w B/C była ustawiona za nisko. **Zmiana:** przesunięto istniejącą podłogę z centrum Y=328 do 346, bez zmiany rozmiaru i bez dodawania przeszkód. Martę w B/C podniesiono z Y=296 do 277. **Odbiór:** trzy pomiary podłogi, trzy pomiary stóp gracza po fizycznym osadzeniu i trzy pomiary stóp Marty, a także kadry porównawcze. Pozostała dwupikselowa szczelina przy cieniu Marty nie jest osiemnastopikselowym lewitowaniem.

### A-04 · P1 · Postać niosła fragmenty scenografii

**Dowód:** `board_vehicle_0.png` zawierał poręcz, `board_vehicle_1.png` także fragment stopnia, a `climb_back_0.png` drabinę i szczeble wpisane w samą klatkę. Przy zmianie pozycji postaci te elementy poruszałyby się wraz z nią, niezależnie od świata. **Zmiana:** usunięto wyłącznie odpowiednie piksele/alfę w trzech PNG. Zachowano rozmiar 64×104, pivot, dłonie, twarz i skórzane elementy. Nie podmieniono bohaterki ani całej palety. **Odbiór:** inspekcja powiększeń, kontrola rozmiarów, próbki przezroczystości w miejscach usuniętej scenografii oraz manifest operacji i sum kontrolnych. Nie twierdzimy, że tym samym ujednolicono wszystkie pozostałe pozy.

### U-01 · P1 · Dialog postępował za menu pauzy

**Dowód:** `scripts/ui/crt_dialogue_box.gd` miał `PROCESS_MODE_ALWAYS`; rzeczywisty test wykazał zmianę liczby odsłoniętych znaków w pauzie. Wprost wywołana kontynuacja również nie miała strażnika pauzy. **Zmiana:** PAUSABLE, ochrona procesowania i wejścia oraz ignorowanie powtarzanych zdarzeń klawisza. **Odbiór:** zegar pisania i postęp dialogu nie zmieniają się podczas pauzy; gra może obsługiwać menu bez konsumowania tekstu w tle.

### U-02 · P1 · Odsłonięcie kwestii omijało zakończenie animacji mowy

**Dowód:** pominięcie pisania ustawiało tekst, lecz omijało wspólną ścieżkę zakończenia, w tym `line_finished` i pokazanie podpowiedzi kontynuacji. **Zmiana:** wspólne `_finish_typing()` dla naturalnego końca i odsłonięcia, jeden sygnał z kanoniczną nazwą osoby, zatrzymanie blipu i prawidłowy dwell. Ukrycie nieaktywnego panelu nie emituje kolejnego pozornego zakończenia rozmowy. **Odbiór:** licznik sygnału, stan promptu, zatrzymanie audio i regresje panelu. Test logiczny zatrzymania nie zastępuje odsłuchu na fizycznym urządzeniu.

### U-03 · P1 · Tekst zmieniał układ w trakcie pisania

**Dowód:** panel składał nową zawartość RichTextLabel z podciągu przy każdym znaku; szerokość słowa rosła podczas wyznaczania wierszy. **Zmiana:** pełny tekst jest układany od początku, widoczność reguluje `visible_characters` po kształtowaniu. BBCode wyłączono dla zwykłych kwestii, aby nawiasy nie stawały się niezamierzonym formatowaniem. **Odbiór:** panel zawiera całą kwestię od pierwszej klatki, ujawniając tylko jej część; 741 pomiarów literalnego korpusu nie wykazało przekroczeń wysokości. To nie jest pomiar wszystkich dynamicznie tworzonych tekstów.

### U-04 · P1 · Myśl Leny była ucięta przy 115%

**Dowód:** `scripts/ui/inner_thought_surface.gd`; rzeczywisty tekst „Na oparciu kurtka odwrócona na lewą stronę. Marta nic nie mówi.” miał 40 px wysokości treści przy polu 30 px. Drugi wiersz był widoczny tylko fragmentem. **Zmiana:** panel dopasowuje wysokość do treści, z kontrolowanym minimum; poprawiono odstęp od nagłówka. Nie zmniejszono czcionki ani wybranego przez gracza skalowania. **Odbiór:** trzy skale tekstu i kadry `thought_before/after`; po poprawce 40 px treści mieści się w 40 px pola. Krótsza następna myśl może ponownie zmniejszyć panel.

### U-05 · P1 · Myśli i winiety nie respektowały pauzy

**Dowód:** tryby procesowania `inner_thought_surface.gd`, `cinematic_vignette.gd` i `cold_open.gd`. **Zmiana:** zatrzymanie ich zegarów i obsługi przewijania w pauzie. Klawisz pauzy nie jest jednocześnie poleceniem pominięcia powtórzonego cold open. **Odbiór:** osobne testy zegara myśli, winiety i otwarcia; brak pominięcia winiety w pauzie. Reguła pierwszego, niepomijalnego otwarcia nie została usunięta.

### U-06 · P1 · Remap nie łapał klawiszy przechwytywanych przez Button

**Dowód:** `scripts/ui/settings_overlay.gd`; przycisk z fokusem konsumował Enter przed `_unhandled_input`. Odtworzono to zdarzeniem `Input.parse_input_event`, nie tylko lekturą kodu. **Zmiana:** aktywne przechwytywanie przypisania działa w `_input`, przed GUI; anulowanie działa na najwyższej warstwie menu. **Odbiór:** Enter trafia do przypisania, a nie ponownie do przycisku uruchamiającego remap. Kod obsługuje także zdarzenie przycisku pada; fizyczny kontroler nie został podłączony do środowiska audytu.

### U-07 · P1 · Tab przenosił fokus za otwarte ustawienia

**Dowód:** niepełny łańcuch fokusu obejmował kierunki góra/dół, ale nie jawne next/previous; pod remapem pozostawały widoczne podstawowe kontrolki. **Zmiana:** zamknięte łańcuchy Tab/Shift-Tab, schowanie niewłaściwej warstwy i powrót do przycisku, który otworzył ustawienia. **Odbiór:** syntetyczny Tab pozostaje w remapie; zamknięcie ustawień pauzy przywraca fokus przyciskowi ustawień, nie przypadkowo Resume. Kierunki siatki wyboru stacji zachowano.

### U-08 · P1 · Menu nakładały się wizualnie

**Dowód:** zrzuty settings/remap z menu tytułowego: tytuł i opis widoczne fragmentami spod panelu; w pauzie ustawienia leżały nad aktywnym selektorem. **Zmiana:** ustawienia w menu tytułowym są wyśrodkowane, a panel tytułu ukrywany na czas ich użycia. W pauzie ukrywany jest panel selektora. **Odbiór:** PL/EN × 85/100/115% w nowych kadrach; prawidłowe przywrócenie menu. Escape na ekranie tytułowym nie wywołuje już kampanijnego menu pauzy.

### U-09 · P1 · Nowa gra i reset mogły zniszczyć zapis jednym naciśnięciem

**Dowód:** bezpośrednie podłączenie przycisków do startu/resetu w `title_screen.gd` i `game_state_manager.gd`. **Zmiana:** nowy mały `SafeActionDialog` ma zlokalizowany opis skutku, dwa przyciski, domyślny fokus na anulowaniu i ochronę przed podwójnym wykonaniem. Nowa gra pyta tylko przy istniejącym zapisie. Potwierdzony reset wraca do tytułu, zamiast pozostawiać stary świat z wyczyszczonym stanem. **Odbiór:** anulowanie zachowuje flagę zapisu i znacznik decyzji; Escape anuluje, akceptacja emituje sygnał raz, modal przechwytuje interakcję. Nie uruchamiano destrukcyjnego testu na zapisie właściciela.

### U-10 · P2 · Komunikat przywrócenia sterowania znikał

**Dowód:** `_restore_defaults` ustawiał opis, po czym odświeżenie listy go nadpisywało. **Zmiana:** odświeżenie przed komunikatem i wyczyszczenie oczekującego przypisania. **Odbiór:** test stanu komunikatu po zakończeniu operacji.

### U-11 · P2 · Stopka ustawień zachodziła pod przycisk

**Dowód:** końcowy ogląd PL/115% ujawnił jeszcze jedną kolizję: Label wymagał 29 px, a przycisk zaczynał się 24 px poniżej jego początku. **Zmiana:** skrócono komunikaty PL/EN bez utraty informacji o autozapisie ustawień i języku dialogów. **Odbiór:** sześć kombinacji język/skala w nowej bramce, jeden wiersz i brak przecięcia z przyciskiem; ponowny kadr menu.

### M-01 · P1 · Powtarzany stan zerował fazę NPC

**Dowód:** `scripts/characters/character_visual_rig.gd`, `set_state`, zerowanie zegara również przy tej samej wartości. **Zmiana:** ponowne ustawienie identycznego stanu jest idempotentne; zmiana na inny nadal działa. **Odbiór:** test zachowania fazy. Nie nadpisano całego systemu aktorskiego ani mapy gestów.

### M-02 · P1 · Reduced motion nie obejmował oddechu postaci

**Dowód:** dekoracyjne przesunięcia idle/listen omijały istniejące ustawienie ograniczenia ruchu w rigach NPC i Leny. **Zmiana:** oddech otrzymał tę samą bramkę MotionAccessibility. **Odbiór:** zerowy dekoracyjny offset obu rigów przy włączonej opcji. Chód, fizyka i działanie potrzebne do rozgrywki pozostały aktywne.

### T-01 · P1 dla CI · Weryfikator wymuszał urządzenie WASAPI

**Dowód:** wcześniejszy rzeczywisty Windows run `35747091744` zatrzymał się przed testami na `WASAPI: init_output_device error`. To był brak urządzenia na serwerze, a nie potwierdzony błąd scen. **Zmiana:** jawny parametr `tools/verify.ps1 -AudioDriver Dummy`; domyślny profil nadal WASAPI. Polityka błędów i ostrzeżeń pozostaje rygorystyczna. Dodano bramkę PKG-0241 i jawnie zwiększono census: 130 wywołań / 129 skryptów / 128 odwołań do testów / 128 testów na dysku. **Odbiór:** nowa bramka działa; ocena pełnego zestawu poniżej. Zastosowanie Dummy nie upoważnia do deklaracji jakości dźwięku.

## 2. Ocena artystyczna całej aktywnej trasy

**Zachować rdzeń stylistyczny.** Stonowane granatowo-szare wnętrza, jaśniejsze postaci i nieliczne akcenty urządzeń dają spójniejszy kierunek niż przypadkowe dodanie bloom, większej liczby kolorów czy nowych efektów. Problemem pierwszego rzędu były rozjazdy warstw i stanów, nie brak ozdobników. Obraz świata jest celowo bardziej oszczędny niż ilustracyjne zbliżenia winiet. Ta różnica może działać jak zmiana planu filmowego; nie została uznana automatycznie za usterkę wymagającą wymiany wszystkich grafik.

| Sceny | Zakres oglądu i decyzja |
|---|---|
| 01–03 | Otwarcie, sylwetka, duże maszyny/architektura i kontrast panelu. Zachowane kompozycje; poprawki wspólnego dialogu, pauzy i ustawień obejmują te sceny. |
| 04–05 | Różnica przestrzeni i kierunek przejścia. Brak podstaw do przebudowy kadrów wyłącznie dla nowości; wspólne błędy wejścia/usługi dialogowej naprawione. |
| 06 | Kiosk: potwierdzony brak sprzedawcy. Odzyskane zasoby, nowy kadr kontrolny. |
| 07–08 | Czytelność postaci względem zabudowy i wyposażenia. Zachować separację sylwetki; brak nowego, udowodnionego lokalnego blokera obrazu. |
| 09–10 | Domowe wnętrza, prześwity i akcent Marty. Nie cofano wcześniejszych korekt palety/geometrii. Naprawa podłoża finałów nie dotyka tych wnętrz. |
| 11–13 | Lada/łącze/stół: rozróżnienie funkcji kadrów i paneli. Nie przerabiano rekwizytów tylko na podstawie podobieństwa barw. |
| 14–16 | Maszyny i urządzenia; sylwetka oraz gęstość informacji. Kwestie mierzone w skalach tekstu; brak dowodu na potrzebę zmniejszenia czcionki CRT. |
| 17–18 | Kadry i lokalne otwarcia zbadane. Dostępność wszystkich metod i konsekwencji w ciągłej kampanii pozostaje osobną bramką integracyjną; nie została udowodniona screenshotem. |
| 42A/B/C | Udowodniona niezgodność podłogi i stóp naprawiona. Nie zmieniono rozkładu finałów ani znaczenia przedstawianych osób. |
| 43 | Obejrzano wejście i warstwy obrazu. Nie utożsamiać wejścia testowego bez pełnego stanu z zaliczonym epilogiem wszystkich ścieżek. |

Pełna lista pojedynczych scen znajduje się w manifestach kadrów. Stwierdzenie „brak nowego lokalnego blokera” oznacza wynik tego oglądu, nie certyfikat wszystkich możliwych kamer, kombinacji decyzji i interakcji.

### Dług artystyczny, którego nie maskujemy

**D-ART-01:** oryginalne dwie klatki mowy sprzedawcy są identyczne. Docelowo potrzebna jest odrębna, bardzo oszczędna klatka ust, zgodna z pozostałymi NPC — nie skalowanie całej głowy. **D-ART-02:** wybrane pozy Leny różnią się detalem butów/ubioru; usunięcie scenografii tego nie rozwiązało. **D-ART-03:** plansze winiet różnią się detalami naszywki, sposobem pokazania torby i rysunkiem twarzy. To materiał do osobnego, kontrolowanego arkusza ciągłości, nie argument za losową regeneracją obrazów. Dla tych punktów plan określa kryteria przed dalszą zmianą; w tym pakiecie nie podmieniono niezweryfikowanych zasobów na przypadkowe nowe.

## 3. Wyniki testów i granice wniosku

**Nowa bramka PKG-0241: 51/51 sprawdzeń PASS.** Obejmuje zachowanie dialogu, układ tekstu, trzy skale myśli, pauzę, remap, fokus, potwierdzenia operacji, rig, zasoby oraz podparcie postaci we wszystkich finałach. Parametry i dane zapisu są izolowane; test dodatkowo zachowuje i odtwarza istniejące pliki ustawień/zapisu.

**Kadry: 88 przed i 88 po, bez błędów zapisu obrazów.** Każda aktywna scena otrzymała otwarcie, świat i próbę 115%. Pozostałe obrazy obejmują UI. **Tekst: 741 pomiarów literalnych kwestii, zero przepełnień CRT.** Oddzielny błąd pola myśli został odtworzony i naprawiony, co pokazuje, dlaczego jeden pomiar globalny nie wystarcza.

Podczas kontroli poprawki trzyklatkowej test PKG-0173 wykrył zbyt daleko przyciętą podeszwę climb_back_0 (ostatni widoczny wiersz 89 zamiast minimum 90). Przywrócono siedem oryginalnych pikseli podeszew; nie dodawano sztucznego piksela ani nie osłabiano asercji. Ponowiona bramka PKG-0173 przeszła, a wynik potwierdził końcowy przebieg całego zestawu.

**Pełna lista testów — wynik diagnostyczny Linux/Dummy:** **83/128 PASS, 45 niepowodzeń. W 127 wspólnych testach nie ma przejścia PASS → FAIL; 21 wcześniejszych niepowodzeń przeszło na PASS, a nowy test jest zielony**. Baza porównawcza (main + jawny bool) miała **61/127 PASS**. Wynik nie jest równoważny wykonaniu całego PowerShell `verify.ps1`: skrypty uruchamiano osobno z limitem 90 sekund, kontrolując także treść logów. Źródłowy pakiet bazowy nie zawiera historycznego katalogu `reports`, więc testy żądające dawnych zrzutów prawidłowo zgłaszają ich brak. Ten sam pakiet nie zawiera `export_presets.cfg`; test 0180 zgłasza ten brak. Test 0184 wymaga starego stanu bez repozytorium, sprzecznego z obecnym zleceniem właściciela. Te wyniki trzeba rozliczyć oddzielnie od działania gry. Są też rzeczywiste niezgodności oczekiwań testów/narracji oraz timeouty — nie wszystkie niepowodzenia wolno przypisać brakującym obrazom.

Najważniejszy otwarty temat techniczny: istniejące testy integracyjne 17/18 i finałów nie dają zielonego wyniku po PKG-0239. Nie zastąpiono ich słabszymi asercjami ani nie usunięto z weryfikatora. Obserwacja porażki testu nie rozstrzyga jeszcze, czy wadliwa jest gra, przygotowanie danych testowych, czy oba elementy. Plan kontynuacji wymaga odtworzenia sekwencji użytkownika i aktualizacji testu dopiero po wykazaniu nieaktualnego oczekiwania.

**Windows:** run [35760642977](https://github.com/diwad-code/getting_strange/actions/runs/35760642977), na commicie `d9f5fb91a3ed6ff2669043d29f1c1115683aac62`: import PASS, nowa bramka **51/51 PASS**, dokumentacja **52 wymagane pliki i kontrakty PASS**, snapshot wykonany. Pełny `verify.ps1 -AudioDriver Dummy` kończy się **FAIL w smoke: 25 niezaliczonych sprawdzeń**, dotyczących zgód/prognoz/metod i finałów. Nie uruchomił dalszych etapów weryfikatora po tym zatrzymaniu. W logach importu i nowej bramki nie znaleziono błędów polityki. Artefakt `windows-art-ux-0241`, ID `10709604072`, zawiera surowe logi; jego kopia znajduje się w archiwum dowodów pod `windows/`. Poprzedni run 0240 nie przeszedł importu z powodu braku WASAPI; tego wyniku nie przedstawiamy jako dowodu awarii gry. Bez zielonej pełnej weryfikacji i inspekcji docelowego profilu wydanie pozostaje zablokowane.

Nie wykonano ludzkiego playtestu, pomiaru rozumienia fabuły, fizycznego testu kontrolera, odsłuchu na urządzeniu Windows ani ciągłego przejścia wszystkich kombinacji nośnika, kosztu, zgód i zakończeń. Render programowy nie daje podstaw do obietnicy 60 FPS na komputerze gracza. 60 Hz jest zachowanym ustawieniem fizyki, nie wynikiem benchmarku.

## 4. Decyzja wdrożeniowa

Zmiany nadają się do przeglądu jako oddzielny pakiet naprawczy, z kompletem dowodów i możliwością wycofania. Nie należy scalać go jako „pełna gra sprawdzona i gotowa do wydania”. Nowe sprawdzenia są zielone, ale stary zestaw integracyjny wymaga rozliczenia. Nie wykonano merge do main, nie włączono auto-merge i nie przygotowano nowego `.exe`.

Priorytet następnego pakietu: rozstrzygnąć błędy starego zestawu na ciągłej trasie, potem odbiór natywnego profilu Windows i dopiero po nim dalsze ujednolicanie klatek/ilustracji. Nie rozpoczynać nowej warstwy ozdobników przed zamknięciem tej bramki.

Dokumenty powiązane: [plan audytu](PKG_0241_AUDIT_PLAN.md), [plan wdrożenia](PKG_0241_IMPLEMENTATION_PLAN.md), [pochodzenie grafik](PKG_0241_ASSET_PROVENANCE.json), `../CURRENT_STATE.md`, `../NEXT_SESSION_PROMPT.md`.

## Źródła techniczne

Kod, sceny i logi własnego projektu są źródłem ustaleń o grze. Rozwiązania obsługi wejścia i fokusu sprawdzono z dokumentacją Godota: [InputEvent i kolejność wejścia](https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html), [nawigacja GUI](https://docs.godotengine.org/en/stable/tutorials/ui/gui_navigation.html), [skalowanie rozdzielczości](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html). Wcześniejsze działania repozytorium: przygotowanie źródeł `35745168283`, odzyskanie zasobów `35746812030`, nieudana weryfikacja Windows `35747091744`. Żaden historyczny nagłówek PASS nie zastępuje świeżego wyniku tego audytu.
