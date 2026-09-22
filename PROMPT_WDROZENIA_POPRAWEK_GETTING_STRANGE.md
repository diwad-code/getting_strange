# GETTING STRANGE — PROMPT WDROŻENIA POPRAWEK FABULARNYCH

**Przeznaczenie:** przekazanie dowolnemu modelowi kodującemu razem z projektem albo archiwum `getting_strange_audyt_fabularny.zip` oraz raportem `Audyt_fabularny_Getting_Strange.md`.

**Polecenie:** wykonaj zmiany w dostępnych plikach. Nie kończ na ponownym audycie, propozycjach ani planie. Poniższe przykłady nowych kwestii są propozycjami redakcyjnymi do wdrożenia, nie cytatami z obecnej gry.

---

## 1. Twoje zadanie i wymagany rezultat

Pracujesz jako wykonawca poprawek narracyjnych w istniejącym projekcie gry **Getting Strange**. Masz doprowadzić opowieść, dialogi, kolejność ujawniania wiedzy, czytelność zadań oraz następstwa decyzji do zgodności z załączonym audytem i twardymi zasadami projektu.

Masz **edytować rzeczywiste źródła treści i — wyłącznie tam, gdzie jest to niezbędne — warunki uruchamiania czynności, rozmów i konsekwencji fabularnych**. Samo przepisanie dokumentacji lub głównego słownika dialogów nie jest wykonaniem zadania.

Nie oceniaj ani nie przebudowuj jakości kodu, architektury, wydajności, grafiki, geometrii, sterowania, zapisu gry ani testów. Nie wykonuj refaktoryzacji przy okazji. Nie twórz nowego systemu dialogowego. Pracuj w istniejących mechanizmach. Odbiór opisany na końcu jest kontrolą narracyjną źródeł, nie zleceniem audytu technicznego lub budowy testów.

Wynikiem mają być:

1. Faktycznie poprawione, dostępne pliki projektu — nie tylko opis proponowanych zmian.
2. Zaktualizowane aktywne fragmenty dokumentacji narracyjnej.
3. Raport `docs/narrative/NARRATIVE_FIX_IMPLEMENTATION.md` z mapą zmian i dowodami odbioru. To **nowy plik wynikowy zlecony tym promptem**, nie rzekomo istniejący dokument projektu.
4. Zestawienie pozostałych braków z jawnym statusem. Nie oznaczaj zadania jako wykonanego, jeżeli przygotowałeś tylko jego opis.

Jeżeli masz pełne repozytorium, pracuj w nim i zachowaj cudze istniejące zmiany. Jeżeli masz wyłącznie ZIP, pracuj na jego rozpakowanej kopii i oddaj zmienione pliki z zachowaniem ścieżek oraz patch, o ile narzędzia pozwalają go przygotować. Nie udawaj, że archiwum jest kompletnym, uruchamialnym projektem. Jeżeli środowisko nie pozwala zapisywać plików, podaj konkretne patche i wyraźnie napisz, że nie zostały zastosowane.

Pisz po polsku, z pełną diakrytyką. Raportuj rzeczowo, bez zapewnień, że gra „na pewno działa”, „na pewno wzrusza” lub ma określony czas przejścia, jeżeli tego nie zaobserwowałeś.

---

## 2. Zacznij od materiałów i hierarchii źródeł

Pierwsza odpowiedź ma krótko potwierdzić: jakie pliki rzeczywiście masz, czy masz pełne repozytorium czy wycinek, jaki audyt odczytałeś oraz czego brakuje. Potem przejdź do pracy. Nie pytaj ponownie o informacje zawarte w materiałach.

### Kolejność lektury

Odczytaj:

- `_CZYTAJ_NAJPIERW.md`;
- `Audyt_fabularny_Getting_Strange.md` — cały raport, nie tylko jego podsumowanie;
- `docs/rebuild/CAMPAIGN_MAP.md` i `docs/rebuild/PLAYER_CONTRACT.md`;
- `docs/narrative/FULL_STORY.md`, szczególnie wstęp o aktywnej adaptacji;
- `docs/narrative/NARRATIVE_BIBLE.md`;
- `docs/narrative/DIALOGUE_SCRIPT.md`;
- `docs/narrative/CONTINUITY_TRACKER.md`;
- następnie źródła scen wskazane w kolejnych krokach.

Jeżeli widzisz także starszy raport `AUDYT_FABULARNY_GETTING_STRANGE.md`, nie sklejaj obu wersji bez rozróżnienia. Punktem wyjścia tego zlecenia jest raport `Audyt_fabularny_Getting_Strange.md`, odpowiadający przedstawionemu użytkownikowi audytowi. Odnotuj ewentualne różnice.

### Jak rozstrzygać rozbieżności

**Reguły i tożsamość opowieści:** pierwszeństwo mają twarde ograniczenia oraz aktywna adaptacja opisana w dokumentach. Starsze fragmenty dawców nie przywracają dawnej numeracji.

**Co faktycznie znajduje się w grze:** dowodem są odczytane teksty, przypisania, wywołania i warunki w dostępnych źródłach. Dokument określający zamiar nie dowodzi, że gracz zobaczył ten zamiar.

**Co należy poprawić:** audyt określa problemy; niniejszy prompt wybiera kierunek ich naprawy. Nie realizuj propozycji z audytu przez złamanie twardej zasady. Każdą sprzeczność zapisz, rozstrzygnij na podstawie źródła i zastosuj najmniejszą uzasadnioną zmianę.

Numery wierszy w audycie są orientacyjne i po edycji się zmienią. Lokalizuj także po ścieżce, kluczu, nazwie czynności i cytacie. Nie wykonuj ślepych globalnych podmian.

W przekazanym wycinku nie było m.in. `docs/rebuild/PKG_0193_CREATIVE_SCENES.md`, `docs/rebuild/PKG_0194_CREATIVE_SCENES_B.md`, `docs/decisions/ADR-008-hybrid-product-rebuild.md` ani `docs/PROJECT_REBUILD_EXECUTION_PLAN.md`. Sprawdź, czy są w twoim środowisku. Jeżeli nie, zapisz **„brak danych”** i nie rekonstruuj ich rzekomej treści. Nie twórz pod tymi nazwami dokumentów mających udawać brakujące oryginały.

**Każde twierdzenie o istniejącej grze ma mieć ścieżkę i lokalizator lub cytat. Każdy nowy fakt dopisany w ramach poprawki oznacz jako nową propozycję/zmianę i sprawdź jego zgodność z kanonem.**

---

## 3. Twarde ograniczenia — nie negocjuj ich podczas implementacji

### Trasa i zakres ingerencji

Zachowaj trasę:

`COLD OPEN → 01–18 → jeden wariant 42A / 42B / 42C → 43`.

Nie dodawaj adresów, postaci, nowych urządzeń rozwiązujących zagadkę, czwartej rodziny finału ani dodatkowej kampanii. Nie przywracaj scen 19–41. Nie zmieniaj istniejących kierunków przejść, powrotów 12→13 i 17→18 ani ustanowionego włazu 14→15. Nie „poprawiaj” topologii według uogólnienia sprzecznego ze szczegółową mapą.

**Źródła:** `_CZYTAJ_NAJPIERW.md`, sekcja „Aktywny przebieg”; `docs/rebuild/CAMPAIGN_MAP.md`, aktywna trasa i wejścia/wyjścia; `docs/narrative/FULL_STORY.md`, wstęp.

### Wiedza i eskalacja

Sceny 01–05 pozostają zwyczajne: bez jawnej anomalii, sobowtóra i paranormalnego zapowiednika. W 06–12 rozbieżności mają być sprawdzane, a nie natychmiast rozstrzygane językiem innego świata. Pierwsze jawne rozpoznanie następuje dopiero przy syntezie w 13. Nie ujawniaj wcześniej miejscowej Leny jako wyjaśnionej tożsamości. Nie nazywaj Zakotwiczenia/Uległości przed wykonaniem obu zachowań na martwym obwodzie w 14.

Nie przywracaj dawnych progów 21/22 jako aktywnych adresów. Nie dopisuj w finale zasady, której nie ustanowiono wcześniej.

**Źródła:** aktywne wstępy `FULL_STORY.md` i `NARRATIVE_BIBLE.md`; `PLAYER_CONTRACT.md`, zakazy; `creative_scene_lines.gd`, `KNOWLEDGE_GATE_IDS` i selekcja po `world_recognized`.

### Tożsamości i fakty niepodlegające zmianie

Przybyła Lena i miejscowa Lena to dwie osoby z różnymi biografiami. Domowa Marta jest najbliższą przyjaciółką przybyłej; miejscowa Marta jest partnerką miejscowej. Nie mieszaj tych relacji. Żyjący miejscowy Jakub nie jest wskrzeszonym bratem z domu przybyłej.

Sadowa 7: lokal 12 w dokumencie przybyłej, 14 miejscowo. Kaloryfer należy do wspomnienia miejscowej Marty; parking i rozstanie — do biografii przybyłej. Nie zmieniaj tego, żeby uprościć scenę małego kosztu.

Pierwszy obowiązkowy odczyt nawiązuje kontakt w obu gałęziach otwarcia. Dopiero opcjonalna powtórka zabezpiecza pełną surową próbkę i powoduje dodatkowe opóźnienie. Czytnik, dokument, bufor i surowa próbka nie są zamienne.

**Źródła:** `NARRATIVE_BIBLE.md`, aktywny wstęp i rozdziały postaci; `FULL_STORY.md`, akapit „Przyczynowość leave_on_time”; `CONTINUITY_TRACKER.md`, aktywna adaptacja.

### Podmiotowość i koszty

Odczyt numeru urządzenia nie jest zgodą Jakuba na badanie ciała. Zgoda na jedną czynność nie oznacza zgody na dowolną metodę. Odmowa ma skutek, ale nie służy zawstydzaniu odmawiającej osoby.

Ratunek miejscowej, współpraca Marty przy procedurze, synchronizacja, intymność i przebaczenie to odrębne rzeczy. Nie zamieniaj pełnej prawdy w moralny kupon na szczęśliwe zakończenie.

Nie wymagaj zgody każdej osoby dotkniętej konsekwencją jako warunku istnienia wszystkich finałów: wymazałoby to przemoc wariantu A. Rozróżniaj **zgodę na świadomy udział w czynności** od **ponoszenia jej skutków przez kogoś, kogo Lena krzywdzi**. Nie dopisuj pokrzywdzonej osobie zgody, aby usprawiedliwić A.

Zachowaj ceny trzech finałów: A — powrót przybyłej i pozostawienie miejscowej między adresami; B — odzyskanie miejscowej i nieindeksowana ciągłość przybyłej; C — powroty obu i trwały, niekontrolowany do końca przeciek. Nie wskrzeszaj domowego Jakuba, nie uśmiercaj miejscowego jako „spłaty”, nie rozstrzygaj pierwszego/prawdziwszego świata.

**Źródła:** `NARRATIVE_BIBLE.md`, granice Jakuba i Marty oraz rodziny zakończeń; `CONTINUITY_TRACKER.md`, „Matryca obowiązkowych stanów finału”.

### Sposób opowiadania

Nie dodawaj narratora tłumaczącego finał, dziennika zadań, moralnego licznika ani markera zastępującego zrozumiały cel. Nie zamieniaj braku faktu w kwestię Leny stwierdzającą, że fakt już istnieje. Didaskalia pozostają wskazówką realizacyjną — nie wkładaj ich do ust postaci.

**Źródła:** `PLAYER_CONTRACT.md`, podział nośników i zakazy; `DIALOGUE_SCRIPT.md`, reguły dialogu; `CAMPAIGN_MAP.md`, scena 43.

---

## 4. Mapa źródeł, które musisz objąć poprawkami

Nie zakładaj, że wystarczy zmienić jeden plik.

| Obszar | Miejsca do odczytania i ewentualnej edycji |
|---|---|
| Otwarcie i obietnica | `scripts/campaign/cold_open_facts.gd`, `scripts/ui/cold_open.gd`, `scripts/levels/station_01.gd`, `station_03.gd` i aktywne teksty ich scen |
| Wczesne czynności i kiosk | `scripts/levels/station_04.gd`, `station_05.gd`, `station_06.gd` |
| Główne rozmowy 09–18 i finałów | `scripts/levels/creative_scene_lines.gd`, w tym selektory wariantów |
| Kolejność rozmowy i czynności | `scripts/levels/creative_scene_presentation.gd` oraz wywołania w odpowiednich stacjach — bez przebudowy prezentera |
| Koszt, odpowiedź, zgody i wybór | `scripts/levels/station_15.gd`, `station_16.gd`, `station_17.gd`, `station_18.gd` |
| Wykonanie A/B/C | `scripts/levels/station_42a.gd`, `station_42b.gd`, `station_42c.gd` oraz odpowiadające `.tscn` |
| Epilog | `scripts/levels/station_43.gd`, `scenes/levels/station_43.tscn` |
| Powracające stare komunikaty | lokalne `DIALOGUE_LINES`, `_setup_guidance()`, `scripts/campaign/gap_ledger.gd`, aktywnie używane zasoby `resources/gameplay/*.tres` |
| Fakty i przejścia | `scripts/core/game_state_manager.gd` — tylko odczyt istotnych zależności i minimalna korekta konieczna dla narracji |
| Dokumentacja | aktywne fragmenty sześciu dokumentów narracji/kontraktu wskazanych w sekcji 2 |

Zanim zmienisz `.tres` lub starszy fragment dokumentu, ustal, czy jest aktywnym źródłem, czy dawcą. Nie poprawiaj zamrożonego materiału 19–41 tylko dlatego, że wyszukiwarka znalazła w nim podobne zdanie.

Istniejące identyfikatory warte prześledzenia to między innymi `world_recognized`, `home_sample_preserved`, `p9.opening.choice`, `p9.mechanics.small_cost.choice`, `jakub_consent_state`, `p9.consent_and_cost.jakub_consent_scope`, `marta_truth_state`, `p9.method_commitment.marta_truth_state`, `method_committed`, `p9.method_commitment.snapshot` i znaczniki `p9.finale.*.executed`. Ich użycia są w wymienionych skryptach; **sprawdź autorów zapisów i odczyty, nie zakładaj znaczenia wyłącznie po nazwie**.

Nie przemianowuj hurtowo starych identyfikatorów. Jeżeli do przedstawienia nowego, rzeczywiście wykonanego zdarzenia konieczny jest dodatkowy stan, dodaj najmniejszy możliwy. Nie dopisuj jego pozytywnej wartości do wcześniejszych zapisów gry jako domyślnej zgody lub zdobytej wiedzy. Opisz jego znaczenie, zdarzenie zapisujące i odbiorców. Nowa flaga nie może udawać zdobytego dowodu, zgody ani wiedzy.

---

# 5. Wykonanie krok po kroku

Wykonuj poniższą kolejność. W obrębie kroku najpierw odczytaj powiązania, następnie zmień treść i niezbędne warunki, a dopiero potem zaktualizuj opis. Nie zostawiaj samej poprawki w dokumencie zamiast w źródłach gry.

## KROK 00 — Inwentaryzacja i mapa zależności

**Zrób:** potwierdź materiały zgodnie z sekcją 2, ustal korzeń projektu i aktywne źródła. W nowym raporcie wynikowym zapisz stan wejściowy.

Przygotuj krótkie, robocze zestawienia:

1. Mapa `fakt → kto go zna → z jakiego źródła → od której sceny`.
2. Mapa `wybór → zakres zgody / koszt → czynność wykonująca → konsekwencja`.
3. Mapa `problem audytu → pliki → kroki niniejszego promptu`.

Przy faktach odróżniaj: „kanon”, „odczytany tekst gry”, „wniosek audytu”, „nowa poprawka”. Zapisz także zależności, których nie możesz potwierdzić. Nie rozbudowuj tej fazy w osobny wielostronicowy audyt i nie zatrzymuj na niej pracy.

**Odbiór:** wiesz, gdzie gracz faktycznie otrzymuje daną informację oraz które źródła mogłyby po poprawce nadal wypowiedzieć starą wersję.

## KROK 01 — Uporządkuj 18 → 42 → 43

**Problem:** P0.1 audytu. **Źródła:** otwarcia `station_42a/b/c.tscn`, wykonania i odczyty w `station_42a/b/c.gd`, klucze `forced_return_latch`, `flow_closure`, `mutual_passage` w `creative_scene_lines.gd`.

Ustanów trzy odrębne fazy:

- **18: zamiar** — porównanie, zgody, jawny wybór i zatwierdzenie metody;
- **42: wykonanie** — rzeczywisty czyn, a następnie sprawdzenie jego skutku;
- **43: następstwa** — codzienność po zdarzeniu, bez ponownego wykonywania finału.

Zachowaj nieodwracalność zatwierdzenia. Zapis zamiaru w 18 nie może udawać wykonania, ale też nie pozwalaj po nim wymieniać metody i migawki decyzji bez jawnego uzasadnienia. Negocjacje i uzupełnienia zgód z kolejnych kroków muszą zakończyć się **przed** zamrożeniem tej migawki.

Usuń z otwarć 42 zdania przedstawiające rezultat jako dokonany przed czynnością. Szczególnie wyszukaj „Przepływ zamknięty”, „W nocy przy słupku zamknęłam przepływ”, „otworzyłam przejście” i „O świcie steruję przybyłą Leną”. Nie rozwiązuj tego przez kosmetyczną zmianę czasu gramatycznego, jeżeli inne kwestie i dostępne inspekcje nadal zdradzają skutek.

W każdym wariancie rozdziel: co Lena zamierza zrobić, co robi, co potwierdza już po zrobieniu. Użyj istniejących scen jako kontenerów tych faz. Nie dodawaj retrospekcji, dodatkowej lokacji lub osobnego finału.

W B uszanuj warunek „Dopiero po jej powrocie zamknę kanał”. Wykonanie może obejmować uporządkowaną sekwencję odzyskania miejscowej i zamknięcia; późniejszy odczyt ma **potwierdzać** powrót, nie dopiero go powodować po zamknięciu. Sprawdź `execute_close_flow()` i `read_local_lena_recovered()`.

Jeżeli wizualnego przedstawienia faz nie ma w dostępnych plikach albo jego zmiana wychodzi poza zakres, zapisz to jako brak do realizacji. Nie twierdź, że przerobiony nagłówek rozwiązał niezweryfikowane wykonanie sceny.

**Odbiór:** skutek nie jest wypowiedziany ani rozpoznany jako fakt przed jego zdarzeniem. Każdą gałąź da się opisać jednym chronologicznym łańcuchem. Ponowne wejście nie rozpoczyna wykonanej kulminacji od początku ani nie przywraca starych otwarć.

## KROK 02 — Napraw właściciela pamięci i ciągłość małego kosztu

**Problem:** P0.4 oraz finał C. **Źródła:** `NARRATIVE_BIBLE.md`, aktywny wstęp; `creative_scene_lines.gd`, `cost_selector_preview`, `cost_selector_marta`, `cost_selector_sample_full`, `cost_selector_sample_buffer`, `memory_leak`; `station_16.gd`; odczyty kosztu w 42/43.

Wybór pamięci w 16 oznacza utratę **własnej pamięci przybyłej Leny o dzisiejszej rozmowie z miejscową Martą o kurtce**. Nie oznacza utraty wspomnienia miejscowej Marty ani uzyskania przez przybyłą cudzej biografii.

Przed wyborem jasno nazwij obie alternatywy. Po wyborze pamięci Marta pamięta i kończy zdanie, a Lena nie umie odtworzyć usłyszanego wcześniej szczegółu.

Wzorzec nowej wymiany:

> Marta: „Powiedziałam: na kaloryferze”.  
> Lena: „Wiem, że mi mówiłaś. Nie umiem sobie tego przypomnieć”.

W gałęzi kosztu zapisu zastąp „Pamięć Marty zostaje cała” jednoznacznym odniesieniem do własnej pamięci rozmowy Leny. Rozróżniaj sekundę zabezpieczonej surowej próbki i sekundę bufora. Zachowaj istniejący szczegół `20:40:07`.

Nie przywracaj utraconego szczegółu w późniejszej kwestii, opisie, podpowiedzi lub epilogu. Nie przypisuj utraty sekundy z 16 graczowi, który wybrał pamięć; odrębny przeciek w C jest skutkiem finału, nie zmianą wcześniejszego wyboru.

Popraw „To mój pogrzeb w twojej głowie. Nie twój” na sens:

> „To moje wspomnienie pogrzebu brata. Nie twoje przeżycie”.

Nie zmieniaj historii na pogrzeb Leny.

**Odbiór:** dla każdego ubytku wiadomo, kto jest właścicielem wspomnienia lub zapisu, kiedy go posiadał, co stracił i jaki ślad pozostaje. Nazwa starego identyfikatora `marta_memory` nie upoważnia do uszkadzania pamięci Marty.

## KROK 03 — Uzgodnij obietnicę, czas i dwie gałęzie otwarcia

**Problem:** P1.1. **Źródła:** `cold_open_facts.gd`, `TEXT_MARTA_MESSAGE`; `station_01.gd`, rozmowy po wyborze; `station_03.gd`; `FULL_STORY.md`, przyczynowość `leave_on_time`; `creative_scene_lines.gd`, `loop_logbook`.

Zachowaj fabularne 20:40 i kontakt przy obowiązkowym odczycie. Nie przesuwaj zdarzenia tylko po to, żeby dopasować spóźnienie do starej wiadomości.

Zmień treść obietnicy na **wyjście po jednym odczycie**, a nie przybycie na 20:30, które już nie daje spójnej różnicy między gałęziami. Zsynchronizuj wiadomość otwierającą, odpowiedzi po decyzji i późniejsze odwołania.

Przykładowy sens nowych kwestii:

> Marta: „Jeden odczyt i wychodzisz. Tak mówiłaś”.  
> Po rezygnacji z powtórki Lena: „Skończone. Pakuję się”.  
> Po powtórce Lena: „Zostałam na drugi. Wyjdę później”.

Dostosuj brzmienie do momentu sceny; nie zapowiadaj pakowania, które już zostało wykonane. Zachowaj osobno koszt wybranej powtórki i niezależny objazd.

Nie nazywaj archiwalnego znacznika 20:14 teraźniejszym zegarem. Nie przypisuj powtórki Lenie, która jej nie wykonała. W `loop_logbook` prezentuj fakty odpowiednie do gałęzi, zamiast opowiadać obu alternatyw jak listy opcji gracza.

**Odbiór:** przy braku powtórki Lena dotrzymuje konkretnej obietnicy dotyczącej pracy, choć może ją opóźnić droga. Przy powtórce sama ją łamie. Kontakt występuje w obu, surowa próbka tylko po zabezpieczeniu.

## KROK 04 — Wzmocnij osobistą stratę w 04, bez prologu

**Problem:** P1.4. **Źródła:** `station_04.gd`, zdanie „Pomnik Linii 4. Nie patrzę na niego od dziewięciu lat”; `creative_scene_lines.gd`, `record_186_days`; `NARRATIVE_BIBLE.md`, katastrofa i Jakub.

Najpierw sprawdź, czy dostępny, aktywny materiał już wiąże ślad katastrofy z bratem. Nie dubluj skutecznie ustanowionej informacji tylko dlatego, że audyt nie miał winiety.

Jeżeli tego nośnika nie ma, dodaj **jeden** krótki osobisty konkret przy istniejącym spojrzeniu na ślad katastrofy: wskazanie brata, jego imienia lub pamięci pożegnania. Nowa kwestia może mieć sens „Jakub. Dziewięć lat, a ja dalej patrzę w czytnik”. Nie dodawaj sceny pogrzebu, listy ofiar do stworzenia graficznie ani wykładu o katastrofie.

Nie zapowiadaj, że Jakub gdziekolwiek żyje. Ten moment ustanawia utratę, aby 11–12 mogły ją podważyć.

**Odbiór:** przed ujawnieniem rejestrów w 11 odbiorca ma podstawę rozumieć, że Linia 4 wiąże się z osobistą stratą brata, nie wyłącznie z zainteresowaniem zawodowym.

## KROK 05 — Usuń zbędny obowiązek kontroli torby w 05

**Problem:** P1.2. **Źródła:** `station_05.gd`, `check_street_route()`, `check_sample_case()`, `cross_street_towards_home()`; `CAMPAIGN_MAP.md`, cel 05.

Zachowaj ulicę, możliwość jej rozpoznania i zamiar zakupu wody. Uczyń kontrolę torby dobrowolną. Przejście do domu nie może wymagać ponownego sprawdzenia jej zawartości po 04.

Zmień wyłącznie konieczne zależności czynności i komunikaty narracyjne. **Nie rozwiązuj blokady przez automatyczne zaznaczenie, że gracz sprawdził torbę.** Fakt wykonania inspekcji ma powstać tylko po inspekcji. Zwyczajne przejście ulicy jest odrębnym faktem.

Jeśli torba zostaje obejrzana, jej opis nadal zależy od zabezpieczenia próbki. Podpowiedź nie może po zmianie nakazywać opcjonalnej kontroli jako obowiązkowego zadania.

**Odbiór:** można przejść zwyczajną ulicę bez redundantnego przystanku. Nie dodano anomalii, nowej przeszkody ani fikcyjnego faktu sprawdzenia.

## KROK 06 — Niech kiosk odpowie na pytanie o trasę

**Problem:** P1.3. **Źródła:** `station_06.gd`, zauważona rozbieżność i „Długo dziś jeszcze otwarte?”; `PLAYER_CONTRACT.md`, niezależne źródła; `CAMPAIGN_MAP.md`, 06.

Zachowaj zakup, zwyczajny ton i pracę sprzedawcy. Zastąp pytanie o godziny zamknięcia pytaniem kontrolnym o konkretny odcinek trasy, którego dotyczy zauważona różnica.

Najpierw odczytaj istniejące nazwy i informacje rozkładu. Użyj ich, nie wymyślaj nowych dzielnic, ulic i przystanków. Jeżeli brak konkretnej nazwy, zastosuj odniesienie przestrzenne z istniejącej sceny, np. „Ta linia nadal jedzie tamtędy?” — ale tylko gdy „tamtędy” ma czytelny, ustanowiony desygnat.

Muszą dać się porównać trzy elementy: pamięć Leny, treść druku, niezależna odpowiedź sprzedawcy. Pamięć może być błędna; dokument i rozmowa nie mogą udawać rozstrzygnięcia metafizycznego.

Nie przenoś do kiosku ujawnienia wspólnego zamieszkiwania ani wykładu o miejscowej Lenie. Zakup Marty rano nie jest sam w sobie dowodem sprzeczności.

**Odbiór:** Lena uzyskuje informację dotyczącą powodu zatrzymania, a gracz wie, dlaczego potem sprawdza adres i dom.

## KROK 07 — Chroń mocne sceny 09–14; popraw tylko ich słabe zakończenia

**Źródła:** `creative_scene_lines.gd`, `two_lives`, `home_task`, `marta_day`, `marta_boundary`, `jakub_meeting`, `jakub_refusal`, `synthesize`, `relay_logbook`, `relay_logbook_named`; `DIALOGUE_SCRIPT.md`.

Nie przepisuj na nowo konfliktu kubków, kurtki, odmowy blizny ani „Byłam na twoim pogrzebie” / „Ja jutro mam tu wrócić”. Zachowaj przejście dom → zapis pracy → warsztat → wspólna synteza.

W 13 utrzymaj kolejność: źródła → „To nie jest mój świat” → „Więc gdzie jest ona?” → „Nie wiem”. Zastąp automatyczne „Sprawdzę ją” przyjęciem konkretnego zobowiązania bez gwarancji wyniku.

Wzorzec nowego zakończenia:

> Marta: „Poszukasz?”  
> Lena: „Tak. Nie obiecam ci, że znajdę”.

Zachowaj użyteczną informację o numerze od Jakuba przez łącze; nie sprowadzaj go fizycznie do mieszkania. Nie ustawiaj rozpoznania bez wymaganych źródeł. Zachowaj również zrozumiałość przejścia po pominięciu winiety; jej pominięcie nie może stworzyć niezdobytego dowodu ani usunąć kluczowej rozmowy po prawidłowo wykonanej syntezie.

W 14 usuń „Sekcja pokazała różnicę, zanim dostała nazwę” i analogiczne komentarze o konstrukcji sceny. Nie usuwaj demonstracji ani bramki nazwania obu metod. Zwykłe nazwanie po wykonaniu wystarczy.

**Odbiór:** niewiedza Leny nie jest natychmiast anulowana obietnicą wszechmocy. Obie metody są doświadczone przed nazwą. Silne sceny nie zostały zagadane.

## KROK 08 — Odbuduj łańcuch przyczynowy drugiej zagadki

**Problemy:** P0.5 i P0.6. **Źródła:** `NARRATIVE_BIBLE.md`, miejscowa Lena, Wierzbicka, zdarzenie Linii 4; `FULL_STORY.md`, aktywne 14–18; `creative_scene_lines.gd`, `loop_logbook`, `signal_sender_*`, `abort_note`, `home_echo_receiver`, `cost_ledger_console`; skrypty 15–17.

### 15: zamiar i późniejsza ingerencja

W istniejącym dzienniku/notatce ustanów, że miejscowa chciała uzyskać niezależny od UCP odczyt eksportu kosztów. Oddziel jej rozpoczęcie próby od późniejszego polecenia Wierzbickiej/UCP. Nie zacieraj autorstwa zdaniem „ktoś przerwał”, jeżeli odczytany materiał pozwala już przypisać polecenie.

Nie dopisuj, że miejscowa wybrała konkretnie przybyłą Lenę albo planowała zamianę. Zabezpieczenie zgody było niewystarczające; notatka o przerwaniu nie uniewinnia rozpoczęcia próby.

### 15: odpowiedź zamiast samego echa

Zachowaj dwa identyczne impulsy kontrolne, jawne przygotowanie błędnej trzeciej próby w tym samym nadajniku oraz selektywną korektę. Usuń „To moja świadoma decyzja”. Nazwij konkretną zmianę i znane ryzyko, a potem pozwól zadziałać czynności.

Nie przechodź od korekty jednego błędu bezpośrednio do pewności o osobie i jej położeniu. Powiąż odpowiedź z istniejącym podpisanym zapisem i warunkiem przerwania. W razie potrzeby dodaj krótki krok sprawdzenia przy **tym samym** nośniku; nie twórz nowego urządzenia ani zdolności Podstruktury.

Rozdziel wnioski: odpowiedź powstaje teraz; istnieje podstawa wiązania jej z miejscową; dalszy dowód dopiero podważy prostą zamianę. Nie przedstawiaj naciśnięcia „kontynuuj” jako samodzielnej, świadomej zgody miejscowej na każdą przyszłą metodę.

### 16: echo domu

Dopiero echo domu wnosi informację przeciw prostemu zajęciu miejsca przybyłej przez miejscową. Treść echa musi rzeczywiście wspierać taki wniosek. Samo „zgłosiłam zaginięcie” nie ma służyć jako wszechwiedzące przeszukanie świata. Doprecyzuj znany zakres nieobecności w relacji/domowym miejscu; oprzyj dalszy wniosek również na wcześniejszym sygnale.

### 17: wiedza instytucji, nie dopisany zamiar zabójstwa

Zastąp zdanie „Korelacja to nie dowód powiązanego kosztu” rozróżnieniem: rejestr dowodzi wiedzy UCP o powiązanym koszcie, ale nie dowodzi sam z siebie zamiaru zabicia konkretnego Jakuba przez konkretną osobę.

Nie usuwaj związku kosztów, nie ogłaszaj „morderczyni brata”, nie rozstrzygaj, który świat był pierwszy. Pozwól Wierzbickiej odpowiedzieć za utrzymywany wynik.

**Odbiór:** po 17 można wskazać: cel miejscowej, jej własne ryzyko, moment i autora późniejszej ingerencji, podstawę poszukiwania żywego sygnału, znaczenie echa domu oraz to, co naprawdę udowadnia rejestr kosztów. Każdy wniosek ma źródło poprzedzające wypowiedzenie go jako faktu.

## KROK 09 — Przebuduj zgodę Jakuba bez obchodzenia odmowy

**Problem:** P0.2. **Źródła:** `creative_scene_lines.gd`, `consent_scope_desk_*`, `forecast_comparator_*`; `station_17.gd`, `_commit_consent()` i wybór zakresu; `station_18.gd`, porównanie prognoz, `_build_forecasts()`, `_commit_method()`, `s18_consent_refused_blocks`; `NARRATIVE_BIBLE.md`, granica Jakuba.

To nie jest tylko korekta trzech zdań. Napraw całą kolejność uzyskiwania informacji i odpowiedzi.

### 9A. Rozdziel możliwość poznania prognozy od prawa wykonania metody

Gracz ma móc przeczytać znane skutki wszystkich trzech metod także wtedy, gdy dana metoda jest niedostępna. „Nie możesz wykonać bez zgody” nie oznacza „nie wolno ci poznać ryzyka, o którym masz powiedzieć zainteresowanemu”. Nie ustawiaj `available=true`, aby udostępnić sam opis.

Każda prognoza ma wskazywać chronioną wartość, znaną cenę, niewiadomą i wymagany rodzaj udziału. Unikaj listy samych braków bez informacji, którą można zanieść Jakubowi.

### 9B. Zgoda dotyczy roli po przedstawieniu ryzyka

W 17 Jakub ustala granice i dostępny zakres pomocy. Każdy zakres musi mieć własną prośbę Leny oraz odpowiedź Jakuba. Pełna zgoda nie jest nieograniczonym blankietem.

Jeżeli ostateczne informacje pojawiają się dopiero w 18, wcześniejszą zgodę traktuj jako ustalenie zakresu, nie automatyczne zezwolenie na dowolny finał. Przed zatwierdzeniem konkretnej metody pokaż potwierdzenie po przekazaniu jej ryzyka. Użyj istniejącego łącza lub uzasadnionego powrotu; nie teleportuj Jakuba do kadru.

### 9C. Nowa propozycja po odmowie

Usuń „Wrócę do hali i zapytam jeszcze raz” jako samodzielne rozwiązanie. Po odmowie nie odtwarzaj tej samej prośby z możliwością kliknięcia innej odpowiedzi.

Dopuszczalny powrót ma nowy przedmiot: np. wyłącznie odczyt wskazań przy metodzie B, bez używania ciała/relacji Jakuba jako podłączanego narzędzia. Lena najpierw opisuje zmianę i jej skutki. Dopiero potem Jakub odpowiada. Znana z materiału pomoc ograniczona nie jest zgodą domyślną.

Wzorzec nowej prośby:

> Lena: „Nie proszę już o podłączenie nadajnika do ciebie. Zostaje odczyt”.  
> Jakub: „Pokaż, co z tego wynika”.

Dokończ rozmowę konkretną informacją o wybranej metodzie. Zachowaj możliwość odmowy także nowej propozycji. Nie karz jej dodatkową katastrofą ani nie zmuszaj do zaakceptowania po określonej liczbie prób.

Odczyt rozmowy, powrót do 17, reset lokalnej sceny lub zmiana pozycji gracza nie mogą same nadpisać `refused` stanem `limited` albo `granted`. Dopiero przedstawiona i zakończona nowa rozmowa może zmienić zakres.

### 9D. Zachowaj ustanowione ograniczenia metod

W dostarczonym `station_18.gd` A i C wymagają `granted`, B dopuszcza `granted` lub `limited`. Zachowaj ten podział jako minimum, uzupełniając go o potwierdzenie konkretnej propozycji. Nie otwieraj finału przy `refused` ani przy nieustalonym zakresie.

Przy utrzymanej odmowie wolno poznawać materiał i wrócić do innych rozmów, ale nie udawać wykonania niedozwolonej metody. Nie dodawaj czwartego zakończenia. Nie obiecuj, że każdy zestaw zgód musi pozwalać wykonać dowolny finał.

Uzgodnij wszystkie odczyty stanu zakresu. Brak lub rozbieżność dwóch istniejących zapisów nie może zostać wygodnie zinterpretowana jako pełna zgoda. Nie zmieniaj domyślnych tekstów tak, żeby wypowiadały niewydaną zgodę.

**Odbiór:** wiadomo kto, na co, po jakiej informacji i z jakim prawem przerwania się zgodził. Powtórna rozmowa ma nowe warunki. Odmowa zachowuje moc. Potwierdzenie następuje przed migawką decyzji w 18, a nie po uruchomieniu finału.

## KROK 10 — Nadaj granicy Marty realną moc

**Problem:** P0.3. **Źródła:** `creative_scene_lines.gd`, `marta_truth_table_full/partial/withheld`, `method_commit_post_*`, `household_c_*`; `station_18.gd`, `_commit_marta_truth()`, `_commit_method()`; `station_42c.gd`, `execute_mutual_passage()`.

Przyjmij następujące rozstrzygnięcie redakcyjne: **warunek klucza synchronizacji jest realnym warunkiem udziału Marty w procedurze, która go wymaga**. Nie rozwiązuj problemu przez usunięcie jej granicy albo ogłoszenie, że klucz nic nie znaczy.

W 18 pokaż, co Lena przedstawia: cel próby, ryzyko dla nieznanej osoby, brak wystarczającej zgody, warunek przerwania. Rozróżnij wiedzę, zgodę na ratunek i udział w synchronizacji. Wyjaśnij, czyj brak zgody dotyczył pierwotnej próby; nie traktuj zgody Marty jako zgody w imieniu miejscowej lub nieznanej osoby.

Przy `partial` Marta może zgodzić się na ratunek, ale wstrzymuje udział wymagający pełnego zapisu. Przy `withheld` nie dopisuj żadnej pomocy, której nie wypowiedziała. Przy `full` nie ustawiaj automatycznie przebaczenia ani zgody na każdy użytek z relacji.

Dla C wymagaj przedstawienia pełnego zapisu i jawnej odpowiedzi dotyczącej synchronizacji przed zatwierdzeniem. Gdy informacji brakuje, daj możliwość dostarczenia jej w istniejącej rozmowie, **przed** zamrożeniem wyboru. Obecne zamknięcie jednorazowego wyboru prawdy nie może uniemożliwiać uzasadnionego uzupełnienia.

Samo `marta_truth_state=full` oznacza zakres przekazanej prawdy, nie automatycznie wydanie klucza. Wykorzystaj istniejący zapis zgody, jeżeli go znajdziesz; inaczej minimalnie zapisz dopiero rzeczywistą odpowiedź z tej rozmowy.

Nie pozostawiaj jako osiągalnego wariantu C opartego na nigdy nierozstrzygniętej odmowie klucza. Wcześniejsze zatajenie może nadal wpływać na relację po późniejszym ujawnieniu, ale nie może udawać aktualnego braku wiedzy, gdy Marta już dostała cały zapis. Nie naprawiaj wariantów C przez przypisanie pełnej prawdy po fakcie.

Dla A i B nie dodawaj arbitralnie identycznego wymogu klucza, jeżeli dana czynność go nie używa. B może odróżniać „pomogę odzyskać partnerkę” od „zgadzam się na synchronizację”. Ujednolić trzeba także to, kto i na jaki klucz czeka w poszczególnych kwestiach.

**Odbiór:** wypowiedziane warunki mają konsekwencje w działaniach. Ratunek nie wymusza przebaczenia. C nie rusza przed wymaganą zgodą, a jej brak nie zostaje zamaskowany chłodniejszym dialogiem po finale.

## KROK 11 — Rozdziel wiedzę dwóch Mart i dostępność kanałów

**Problem:** sekcja audytu „Dwie Marty”. **Źródła:** `creative_scene_lines.gd`, `home_echo_receiver`, `marta_truth_table_*`, `household_a/b/c_*`, `_finale_truth()`; skrypty 42/43; `CONTINUITY_TRACKER.md`, relacje i finały.

Dla każdej wiadomości lub kwestii obu Mart zapisz: osobę, świat, moment, źródło wiedzy oraz kanał. Przejrzyj także teksty dokumentów w finałach.

Nie używaj zakresu prawdy przekazanej miejscowej Marcie w 18 jako automatycznej wiedzy domowej Marty. W A domowa może dowiedzieć się czegoś z rozmowy z powracającą Leną — przedstaw ten przekaz przed jej reakcją. W B nie dodawaj szczegółów próby domowej Marcie, jeśli nic ich jej nie przekazało. W C przeciek nie jest dowolnym dostępem do całego scenariusza.

Dla nieuzasadnionych kwestii wybierz jedną z dwóch napraw:

- ogranicz wypowiedź do wiedzy, którą osoba ma;
- pokaż konkretny przekaz przez kanał już istniejący i działający w tym momencie.

Nie twórz nowego kanału po zamknięciu mostu. Dokument ukazany odbiorcy w wyraźnie oddzielonej lokalnej perspektywie nie musi być wiadomością dostarczoną Lenie — ale ustanów to rozdzielenie. Niech bohaterka nie reaguje wiedzą na dokument, którego nie widziała.

Nie uzależniaj jakości fizycznego zapisu w torbie od tego, ile Lena komuś powiedziała. Zakres ujawnienia i integralność materiału to osobne fakty.

**Odbiór:** żadna osoba nie wie czegoś dlatego, że tę informację dostała jej odpowiedniczka. Żadna wiadomość nie przekracza zamkniętego kanału bez źródła.

## KROK 12 — Wzmocnij Wierzbicką i odpowiedzialność miejscowej

**Problemy:** P1.6 i P0.6. **Źródła:** `NARRATIVE_BIBLE.md`, rozdziały 7–8; `DIALOGUE_SCRIPT.md`, głosy; `creative_scene_lines.gd`, `identity_card`, `minimal_report`, `adaptation_offer_terminal`, `local_lena_recovered`; materiały 15–17.

### Wierzbicka

W 11 użyj istniejącego sporu o czytnik i zakres wyciągu do realnego konfliktu interesów. Nie ujawniaj kosmologii przed 13 i nie twórz dodatkowego obowiązku oddania jedynego narzędzia, który łamałby dalszy przebieg.

W 15 uczyń zrozumiałą jej późniejszą ingerencję. W 17 daj jej obronić wynik: utrzymanie lokalnego tunelu i ludzi, których stabilizowała, przy odsunięciu kosztu poza własny zakres. Nie zamieniaj jej w karykaturę ani w neutralny automat recytujący „stan”.

Wzorzec nowej wymiany:

> Lena: „Wiedzieliście o drugiej stronie”.  
> Wierzbicka: „Utrzymaliśmy tunel”.  
> Lena: „Tutaj”.  
> Wierzbicka: „Tak. Tutaj”.

Oferta adaptacji ma na chwilę dotknąć prawdziwego pragnienia Leny. Dodaj krótkie pytanie, próbę sprawdzenia ceny lub zawahanie przy istniejącej czynności. Nie twórz nowego zakończenia polegającego na przyjęciu oferty. Odrzucenie ma wynikać z kosztu zastępstwa, nie z automatycznego wypowiedzenia tezy.

### Miejscowa Lena

W B i C miejscowa odpowiada za rozpoczęcie próby przy niewystarczającej zgodzie. „UCP dopisało resztę” nie może wyczerpywać odpowiedzi. Zachowaj odpowiedzialność instytucji i oddziel od niej własną decyzję miejscowej.

Wzorzec nowej wymiany:

> Marta: „Wiedziałaś, że możesz kogoś w to wciągnąć?”  
> Miejscowa Lena: „Tak”.  
> Marta: „A zaczęłaś, zanim odpowiedział”.  
> Miejscowa Lena: „Tak”.

Dostosuj zaimki do wskazanej osoby; nie twórz mylnej pewności, kogo wcześniej znała. Ratunek otwiera tę rozmowę, nie zapewnia natychmiastowego pojednania. Nie dopisuj w A żywej odpowiedzi miejscowej zza zamkniętego mostu.

**Odbiór:** przeciwniczka broni konkretnego działania, miejscowa uznaje własną część odpowiedzialności, a Lena nie odzyskuje bliskości jako automatycznej nagrody za wykonanie procedury.

## KROK 13 — Uzasadnij powrót na ulicę w 18

**Problem:** P1.7. **Źródła:** `station_17.gd`, wyjście; `station_18.gd`, nagłówek sceny, prognozy i rozmowy; `CAMPAIGN_MAP.md`, 05 i 18.

Przed opuszczeniem 17 ustanów prosty cel: przynieść lub udostępnić Marcie zapis i porównać konsekwencje na posiadanym nośniku. Użyj rzeczy istniejących: wyciągu/rejestru, czytnika, prognoz i działającego kontaktu. Nie wprowadzaj tajemniczego nowego wyposażenia ulicy.

W 18 wyjaśnij działaniem, krótką kwestią albo podpisanym materiałem, skąd pochodzą informacje i kto je udostępnił. Nie wystarcza opis autora „trzy trasy rozchodzą się z tej samej ulicy”. Nie twierdź, że ktoś rozłożył dokumenty, jeżeli nie ustanowiłeś jego obecności lub przekazania materiału.

Zachowaj ulicę z 05 i kierunek powrotu. Nie przenoś finałowej decyzji do nowego laboratorium. Nie dopisuj długiej ekspozycji — wystarczy przyczyna ruchu i źródło używanych informacji.

**Odbiór:** przed wyjściem z 17 gracz wie, dlaczego wraca, do kogo lub do czego idzie i co zamierza tam zrobić.

## KROK 14 — Doprowadź trzy finały do odrębnych, konkretnych cen

**Źródła:** `NARRATIVE_BIBLE.md`, rodziny zakończeń; `CONTINUITY_TRACKER.md`, matryca finałów; skrypty i sceny 42A/B/C; `creative_scene_lines.gd`, odpowiednie klucze finałów. Kolejność faz wynika już z kroku 01.

### 42A — własny powrót, cudza nieobecność

Zachowaj powrót przybyłej, zamknięcie miejscowej między adresami, dalsze poszukiwania miejscowej Marty, życie Jakuba i utrzymaną kontrolę UCP. Nie dodawaj nowej kary ani usprawiedliwiającej zgody miejscowej.

Przepisz „Najpierw posłuchaj próbki”, „Słyszałam próbkę całą” i podobne zdania według **istniejącego** materiału oraz jego **aktualnej jakości**. Sprawdź co najmniej: była/nie była zabezpieczona surowa próbka; wybrano pamięć/sekundę; późniejsze ustanowione uszkodzenia. „Cały dostępny zapis” nie jest cudownie odtworzoną próbką.

Etykieta „BŁĄD CZUJNIKA” może pozostać jako pokusa wygodnego wyjaśnienia. Pokaż stosunek Leny do niej konkretną czynnością lub świadomym pozostawieniem rubryki, nie pochwalnym komentarzem.

### 42B — odzyskanie miejscowej i utrata własnej drogi

Rozdziel powrót miejscowej do Marty od losu przybyłej. Brak adresu przybyłej oznacza nieindeksowaną ciągłość i brak gwarantowanej drogi do własnego domu, nie tylko nieczynny telefon lub brak meldunku.

Zachowaj istniejący próg oraz odrębny moment obcego przystanku w epilogu. Nie dodawaj nowej lokacji. Nie pozostawiaj wrażenia, że obie Leny po zamknięciu po prostu zostają razem w mieszkaniu 14.

Zachowaj „Jadę” bez adresata. Nie zmieniaj tego w potwierdzone doręczenie. Miejscowa Marta odzyskuje partnerkę, ale nie ma obowiązku jej od razu wybaczyć. UCP traci eksport kosztów z tego węzła, nie automatycznie całą władzę.

### 42C — powrót obu bez odzyskania izolacji

Pozostaw przeciek jako konkretny problem. Po epizodzie przy imadle Jakub przerywa czynność z własnej decyzji, zamiast natychmiast uspokajać „To mija”. Nie dopisuj wypadku, urazu ani nowej ofiary. Zastosuj poprawione przypisanie wspomnienia z kroku 02.

Nie używaj „obustronnej zgody” jako ogólnego usprawiedliwienia wszystkiego. Zgody z 18 dotyczą uzgodnionych czynności i ryzyka; nie gwarantują kontroli nad późniejszym przeciekiem.

Zachowaj obcy detal kubka/półki i dalszy brak izolacji. Przejście obu osób nie rozwiązuje automatycznie konfliktów relacyjnych. Nie obiecuj zatrzymania procesu ani pełnego szczęśliwego zakończenia bez strat.

**Odbiór:** każdy wariant ma inną cenę i zachowuje stany siedmiu podmiotów z kanonu. Koszt z 16 nadal jest ten sam. Żadna metoda nie dopisuje brakującego materiału, przebaczenia lub wszechwiedzy.

## KROK 15 — Zdejmij język dokumentacji z ust bohaterów

**Problem:** P1.5. **Źródła:** `DIALOGUE_SCRIPT.md`; `creative_scene_lines.gd`; `DIALOGUE_LINES`, otwarcia i guidance w aktywnych stacjach; `gap_ledger.gd`.

Usuń lub zasadniczo przepisz wystąpienia:

- „To moja świadoma decyzja”; „Braki zostają nazwane”; „Nieustalone pokazuję jako nieustalone”;
- „To wstrzymanie, nie kłamstwo z litości”; „Sekcja pokazała różnicę, zanim dostała nazwę”;
- „O świcie steruję przybyłą Leną”; myśli o odczytywaniu napisów końcowych i „zamykaniu podróży”.

Nie zastępuj ich innymi deklaracjami poprawności etycznej lub konstrukcyjnej. Zastępuj je: pytaniem, prośbą, odmową, nazwaniem konkretnego ryzyka, przyjęciem niekorzystnej odpowiedzi albo ciszą.

Przy każdej zmienianej rozmowie ustal: czego chce Lena, czego chce druga osoba, gdzie ich cele się rozchodzą i co po rozmowie staje się inne. Usuń zdanie, które jedynie powtarza tezę już wyrażoną przez działanie.

Zachowaj głosy: Lena — pomiar i trudność przyznania niewiedzy; Marta — dom i granice; Jakub — praca i zakres pomocy; Wierzbicka — selektywna odpowiedzialność; miejscowa — warunki, pytania, własna odpowiedzialność. Nie dodawaj błyskotliwych sentencji, których żadna z tych osób nie potrzebuje w danym momencie.

Nie rozciągaj scen w wykłady. Stosuj limit krótkich wymian określony w `DIALOGUE_SCRIPT.md`; większą ilość informacji rozdziel czynnościami, nie większym monologiem.

Instrukcje dotyczące sterowania i napisów końcowych pozostają komunikatami systemowymi, nie myślami postaci. Nie zmieniaj przy tym wyglądu interfejsu. Istniejące podpowiedzi po realnym zastoju mają mówić, co można sprawdzić — nie jak należy się czuć.

Sprawdź również alternatywne i awaryjne ścieżki tekstu. Jeśli zmieniona polska podpowiedź ma aktywny odpowiednik EN w tej samej definicji, zachowaj zgodność znaczenia w dotkniętej parze; nie rozpoczynaj pełnej lokalizacji gry.

Gest lub ciszę realizuj istniejącym mechanizmem. Nie wstawiaj do wypowiedzi zdania „Lena milczy” i nie wpisuj w raporcie „gest wdrożony”, gdy dopisałeś tylko komentarz z didaskaliami.

**Odbiór:** słuchając tekstu bez nazw postaci, można odróżnić ich agendy. Żadna kwestia Leny nie opisuje grania Leną ani zgodności sceny z dokumentacją.

## KROK 16 — Przepisz epilog na działania i ograniczone źródła

**Problem:** sekcja audytu „Epilog”. **Źródła:** `station_43.gd`, `_setup_dialogue_for_branch()`, `_payoff_line_into_branch()`, `_truth_clause()`, `_consent_clause()`, `_cost_clause()`, `_setup_guidance()`; `CAMPAIGN_MAP.md`, 43; `CONTINUITY_TRACKER.md`, matryca siedmiu podmiotów.

Usuń wszechwiedzące tezy o mieście noszącym bliznę, której nikt nie ukrywa, oraz o dwóch Lenach połączonych „cienką nicią”. Nie wystarczy zmienić etykiety „ŚWIADECTWO” na „ZAPIS”. Ogranicz każde źródło do tego, co może wiedzieć i pokazać.

Nie prezentuj epilogu jako rozliczenia wszystkich flag jednym syntetycznym głosem. Informacja o zgodzie ma wybrzmieć w zakresie działania Jakuba, o prawdzie — w relacji właściwej Marty, a o małym koszcie — w jego konkretnym śladzie. Nie każdemu faktowi potrzebny jest osobny wygłoszony komunikat.

Zachowaj końcowe konkrety: A — nieuzupełniona rubryka przy dostępnym zapisie; B — czytnik w torbie i „Jadę” bez adresata; C — kubek, półka i obcy szczegół. Jeżeli czynności nie są realizowane w dostępnym materiale, nie podszywaj pod nie samego opisu narratora: wykorzystaj istniejącą interakcję lub odnotuj brak realizacji poza zakresem.

Zachowaj czytelność losów siedmiu podmiotów: przybyła Lena, miejscowa Lena, Marta domowa, Marta miejscowa, Jakub, Wierzbicka/UCP, relacja światów. Nie usuwaj koniecznego następstwa tylko po to, żeby epilog był krótszy. Nie trzeba jednak ponownie odczytywać tego, co finał już jednoznacznie pokazał.

Rozdziel wiedzę odbiorcy od wiedzy Leny przy ewentualnym pokazaniu lokalnego dokumentu z innego świata. Nie przedstawiaj go jako otrzymanej wiadomości po zamknięciu kanału.

**Odbiór:** ostatnie słowo należy do konkretnego działania lub identyfikowalnego źródła, nie do interpretatora świata. Epilog nie powtarza wykonania finału, nie zmienia jego rodziny i nie dodaje nowej zagadki.

## KROK 17 — Uzgodnij dokumentację i wszystkie aktywne powtórzenia

Zaktualizuj aktywne fragmenty `FULL_STORY.md`, `NARRATIVE_BIBLE.md`, `DIALOGUE_SCRIPT.md`, `CONTINUITY_TRACKER.md`, `CAMPAIGN_MAP.md` i `PLAYER_CONTRACT.md` tam, gdzie poprawka zmienia opis przebiegu lub doprecyzowuje warunek. Nie przepisuj całego kanonu i nie zacieraj statusu materiału legacy.

W dokumentacji mają być jasno zapisane: obietnica jednego odczytu, własność pamięci z 16, rozdzielenie zamiaru i wykonania finału, warunki nowej prośby Jakuba, znaczenie klucza Marty, rozdzielenie wiedzy obu Mart oraz rzeczywiste koszty trzech zakończeń.

Przeszukaj aktywne źródła po starych problematycznych frazach i ich znaczeniu, nie tylko po identycznym ciągu. Usuń sprzeczne warianty z głównych kwestii, lokalnych stałych, podpowiedzi, otwarć i używanych zasobów danych.

Nie traktuj historycznego komentarza o pinie/testach jako nadrzędnej zasady fabularnej. Nie zostawiaj błędnego zdania tylko dlatego, że komentarz mówi o jego zamrożeniu. Jednocześnie nie modyfikuj testów w tym zleceniu i nie ukrywaj znalezionego konfliktu: odnotuj konkretną zależność w raporcie jako poza zakresem.

**Odbiór:** dokumentacja opisuje to, co rzeczywiście zmieniłeś; żadna nieedytowana, aktywna ścieżka nie przywraca starej sprzeczności. Jeżeli nie możesz potwierdzić któregoś wywołania, zaznacz brak danych zamiast deklarować pełne pokrycie.

---

# 6. Odbiór narracyjny — wykonaj go przed raportem końcowym

To jest lektura tekstów, warunków i następstw, nie zadanie pisania/oceny testów automatycznych. Nie podawaj wyników rozgrywki, której nie uruchomiłeś, ani czasu reakcji odbiorcy.

Dla każdego punktu nadaj status: **potwierdzone w źródłach**, **niespełnione**, **brak danych** lub **nieosiągalne zgodnie z warunkami**. Dodaj plik i lokalizator. Status „potwierdzone w źródłach” nie oznacza zweryfikowanego wykonania audiowizualnego.

## 6A. Chronologia i wiedza

1. Kontakt występuje po obowiązkowym odczycie w obu gałęziach; powtórka ma inną funkcję.
2. Obietnica i wiadomości są spójne bez przesuwania 20:40.
3. Sceny 01–05 nie ujawniają anomalii; 06 nie rozwiązuje zagadki świata.
4. Przed 13 nie pada diagnoza ani słownictwo, na które Lena nie ma jeszcze podstaw.
5. Synteza 13 korzysta tylko z faktycznie dostępnych źródeł.
6. Nazwy obu metod następują po wykonaniu obu zachowań w 14.
7. Wniosek z sygnału w 15 nie wyprzedza dowodów tożsamości i echa domu w 16.
8. Rejestr 17 potwierdza powiązany koszt bez dopisanego zamiaru zabójstwa.
9. W 18 powstaje zamiar; w 42 czyn; w 43 następstwa. Ponowne wejście nie cofa tej kolejności.

## 6B. Próbka, pamięć i stany wariantów

10. Brak zabezpieczonej próbki nie usuwa własnego czytnika, dokumentu i istniejącego bufora.
11. Zabezpieczenie próbki i jej późniejsza integralność są rozróżniane.
12. Pamięć kaloryfera nie zostaje przypisana biografii przybyłej.
13. Po koszcie pamięci Marta nadal pamięta; przybyła nie odtwarza swobodnie utraconego szczegółu.
14. Po koszcie sekundy traci się sekundę właściwego nośnika, nie dowolny materiał.
15. Finały nie odtwarzają próbki, nie mylą fizycznego zapisu z zakresem prawdy i nie zmieniają wcześniejszego małego kosztu.

W szczególności prześledź cztery przekroje: próbka+pamięć, próbka+sekunda, bufor+pamięć, bufor+sekunda. Dla każdego sprawdź wypowiedzi w 16, przegląd w 18 oraz osiągalne zakończenia. Nie udawaj, że nieosiągalna kombinacja wystąpiła w prawidłowym przejściu.

## 6C. Zgody i konsekwencje

16. Każda zgoda Jakuba ma prośbę, zakres, informację o ryzyku i jego odpowiedź.
17. Ograniczony zakres nie otwiera A/C, a odmowa nie otwiera żadnej metody wymagającej jego udziału.
18. Po odmowie dostępny opis ryzyka nie jest mylony z dostępnością wykonania.
19. Ponowna prośba ma zmieniony zakres; samo powtórzenie interakcji nie nadpisuje odmowy.
20. Brak lub sprzeczny zapis zgody nie staje się domyślnym `granted`.
21. Pełna prawda dla Marty nie jest automatycznym przebaczeniem ani dowolną zgodą.
22. C nie jest zatwierdzane bez rozwiązania warunku synchronizacji; uzupełnienie informacji odbywa się przed migawką.
23. Wiedza miejscowej Marty nie przechodzi automatycznie na domową.
24. Miejscowa Lena uznaje własną odpowiedzialność w dostępnych rozmowach B/C.
25. Po zamknięciu kanału nie przychodzi niewyjaśniona nowa odpowiedź z drugiej strony.

Uwzględnij `granted`, `limited`, `refused` i brak danych; `full`, `partial`, `withheld` oraz ewentualne późniejsze jawne uzupełnienie. Oddziel aktualną wiedzę od historii uniku. Nie zmieniaj warunków tylko po to, żeby wszystkie kombinacje stały się osiągalne.

## 6D. Dramaturgia i zakończenia

26. W 05 nie trzeba ponownie sprawdzać torby, a pominięcie nie fabrykuje inspekcji.
27. Kiosk rzeczywiście sprawdza zauważoną różnicę trasy.
28. Przejścia 10→11, 11→12, 12→13 i 17→18 mają powód wynikający ze zdarzenia, nie z etykiety następnego etapu.
29. Mocne sceny domu i Jakuba nie zostały zastąpione wykładem.
30. Wierzbicka ma argument i nacisk, nie sam proceduralny żargon.
31. A zachowuje cenę miejscowej nieobecności; B — utratę własnej drogi; C — trwały przeciek.
32. Jakub w C nie zostaje sprowadzony do kojącego objaśnienia kosztu.
33. Losy siedmiu podmiotów są zgodne z wybraną rodziną zakończenia.
34. Nie ma wypowiedzi postaci o sterowaniu nią, czytaniu napisów końcowych ani zgodności sceny z dokumentacją.
35. Epilog nie ma wszechwiedzącego podsumowania ani zbiorczej oceny moralnej.
36. Nie dodano nowego adresu, urządzenia, postaci, czwartego finału, metafizycznego wyjaśnienia ani anomalii ratującej tempo początku.

Gdy znajdziesz rozbieżność między poprawionymi kwestiami a warunkami ich uruchomienia, wróć do odpowiedniego kroku. Nie zaliczaj poprawki na podstawie samego istnienia nowego tekstu w pliku.

---

# 7. Format raportu końcowego i uczciwe zakończenie pracy

W `docs/narrative/NARRATIVE_FIX_IMPLEMENTATION.md` umieść:

## A. Materiały i zakres

Co odczytałeś, czego brakowało, na jakiej wersji pracowałeś. Oddziel poprawkę tekstową, zmianę zależności fabularnej i element wymagający nieudostępnionej realizacji.

## B. Rejestr zmian

Tabela:

`Krok / problem audytu | plik i lokalizator | przed | po | dlaczego | dalsze konsekwencje | status`.

Używaj krótkich cytatów, nazw kluczy albo funkcji. Nie wpisuj ogólnie „poprawiono dialogi”. Dla zmian w zgodzie, pamięci i wykonaniu finału wskaż również miejsce zapisania i odczytania odpowiedniego faktu.

## C. Pokrycie audytu

Przypisz wszystkie P0.1–P0.6, P1.1–P1.7 oraz uwagi o A/B/C, dwóch Martach i epilogu do konkretnych zmian. Każdy problem ma być wykonany, częściowy albo nierozwiązany z przyczyną. „Nie dotyczy” wymaga dowodu, że problem nie występuje w otrzymanej wersji.

## D. Stan odbioru narracyjnego

Zestaw punkty sekcji 6 i cztery przekroje nośnika/kosztu. Przy blokowanych metodach wyjaśnij warunek; nie przedstawiaj ich niedostępności jako awarii lub ukończonego finału.

## E. Rzeczy pozostawione bez zmian

Wskaż zachowane sceny i ograniczenia, istotne do oceny zakresu. Nie zamieszczaj oceny kodu, grafiki, wydajności ani testów.

## F. Pozostałe braki

Lista konkretnych niezamkniętych elementów: brak pliku, nieodczytana winieta, niezweryfikowany nośnik lub konflikt niemożliwy do rozwiązania w zakresie. Podaj, co mimo tego poprawiono. Nie przedstawiaj didaskaliów, planu ani patcha niezastosowanego jako działającej realizacji.

W odpowiedzi końcowej podaj: zmienione pliki, najważniejsze skutki poprawek, drogę do raportu oraz pozostałe braki. Jeśli pracowałeś na ZIP-ie i możesz zwrócić pliki, dołącz je w zachowanej strukturze. Nie zastępuj rezultatu samą obietnicą wykonania.

**Wykonaj teraz kroki 00–17. Nie zatrzymuj się po planie. Jeżeli brakuje fragmentu materiałów, wykonaj wszystkie niezależne poprawki, oznacz ograniczony fragment i nie dopisuj nieistniejących faktów.**
