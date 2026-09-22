# Plan naprawy sensu fabularnego

Data: 2026-09-14
Podstawa: `docs/narrative/STORY_SENSE_AUDIT_2026-09-14.md`
Adresat: modele wykonawcze (Lead Programmer / Art Director wg D-025, D-085)
Zakres: trasa 01–18 → 42A/B/C → 43. Sceny legacy 19–41 poza zakresem.

## 0. Zasady tego planu

1. **Nie przepisujemy dialogów, które działają.** Warstwa tekstowa
   `creative_scene_lines.gd` jest najmocniejszym zasobem projektu. Dopisujemy
   ogniwa, nie wymieniamy kwestii.
2. **Nie dodajemy nowych adresów.** Budżet 20 odwiedzanych adresów stoi
   (D-168). Wszystkie naprawy mieszczą się w istniejących 22 zasobach.
3. **Nie dodajemy przeszkód zręcznościowych** (D-099). Każdy nowy element
   fizyczny musi dać się wytłumaczyć jednym zdaniem o świecie, bez słowa
   „gracz".
4. **Jeden pakiet = jedna warstwa problemu.** Nie łączyć naprawy kauzalności
   z przebudową geometrii.
5. **Kolejność jest wiążąca.** P0 to rzeczy, które unieważniają decyzje gracza
   albo blokują przejście gry. Bez nich reszta jest kosmetyką.

---

# P0 — bez tego gra nie jest ukończalna albo jej decyzje są fikcyjne

## P0-1 · Przywrócić moc sprawczą zgody Jakuba

**Defekt:** S-02. `_commit_method()` commituje metodę nawet wtedy, gdy
prognoza tej metody ma `available = false`, a finały maskują pustą zgodę
domyślną wartością.

**Pliki:** `scripts/levels/station_18.gd`, `scripts/levels/station_42a.gd`,
`scripts/levels/station_42b.gd`, `scripts/levels/station_42c.gd`.

**Do zrobienia:**
1. W `_commit_method()` odczytać `_build_forecasts(_read_consent())` i
   **przerwać** commit, gdy wybrana droga ma `available = false`. Zwrócić
   `false`, zapisać istniejący feedback (`jakub_consent_missing`) i otworzyć
   lukę w `GapLedger`, wzorem `s17.consent_unscoped`.
2. Ten sam warunek zastosować do braku `are_forecasts_compared`
   i `is_marta_truth_disclosed` — dziś są tylko logowane.
3. Usunąć domyślne podstawienia zgody w finałach
   (`station_42a.gd:236` → `SCOPE_LIMITED`, `station_42c.gd:268` →
   `SCOPE_GRANTED`). Pusta zgoda ma być nazwana jako luka, nie wypełniona.
4. Dopisać do słupka reakcję na odmowę: jedną kwestię Leny w stylu
   istniejącego `forecast_comparator_refused` („Bez jego ręki nie zatwierdzę
   tej drogi"). Nie pisać nowego głosu Jakuba — on już powiedział wszystko
   w 17.

**Kryterium akceptacji:** przy `jakub_consent_state = refused` nie da się
zatwierdzić żadnej z trzech metod; gra kieruje gracza z powrotem do 17 przez
istniejącą lukę `GapLedger`, a nie przez komunikat systemowy.

**Uwaga projektowa:** jeżeli odmowa Jakuba ma zamykać **wszystkie** trzy
drogi, to gra musi mieć wyjście z tego stanu — albo powrót do 17 i ponowna
negocjacja, albo czwarta metoda o wyższym koszcie własnym Leny. Decyzja
należy do właściciela; **nie wolno** zostawić stanu, w którym gracz ma
zablokowane wszystkie metody bez ścieżki naprzód.

## P0-2 · Wybór metody jako wypowiedziana decyzja

**Defekt:** S-03. Finał rozstrzyga `player.global_position.x` względem słupka,
bez oznaczeń i potwierdzenia.

**Pliki:** `scripts/levels/station_18.gd`, `scenes/levels/station_18.tscn`.

**Do zrobienia:**
1. Rozdzielić „wskazanie" od „zatwierdzenia": pierwsze `interact` przy słupku
   **nazywa** metodę, którą gracz właśnie wskazuje, i pokazuje jej znane
   koszty oraz luki (dane już są w `_build_forecasts()` i
   `_commit_review_table()`). Dopiero drugie `interact` na tej samej metodzie
   zatwierdza.
2. Dodać trzy diegetyczne oznaczenia przy słupku (`CrispDiegeticText`,
   wzorem `CrispDiegeticText_Forecasts`), po jednym dla każdej strefy, tak by
   strefa była widoczna zanim gracz naciśnie cokolwiek.
3. Zwiększyć martwą strefę środka albo wprowadzić snap — dzisiejsze ±24 px
   przy szerokości sylwetki Leny 87 px oznacza, że krawędź decyzji leży
   wewnątrz ciała postaci.

**Kryterium akceptacji:** nie istnieje sekwencja wejść, w której gracz
zatwierdza finał bez wcześniejszego zobaczenia jego nazwy i kosztu.

## P0-3 · Odblokować powrót na stacjach 09–18

**Defekt:** S-04 (potwierdzić w runtime przed naprawą).

**Weryfikacja przed zmianą:** wejść do 10, domknąć trzy punkty, przejść do 11,
wrócić `ReturnZone`, spróbować wyjść w prawo. Jeśli próg nie otwiera się —
defekt potwierdzony.

**Pliki:** `scripts/levels/station_09.gd` … `station_18.gd`.

**Do zrobienia:** dodać w każdej z tych stacji metodę `unlock_exit_for_return()`
(wzorzec z `station_01.gd:385`), a dodatkowo w `_ready()` odtworzyć
`is_exit_unlocked` z faktów w `GameStateManager` — ten sam warunek, który
domyka scenę za pierwszym razem. Drugie rozwiązanie jest lepsze, bo naprawia
również powrót z zapisu, nie tylko przez `ReturnZone`.

**Kryterium akceptacji:** nowy test w `tests/` przechodzi trasę 08 → 18
i wraca każdą parą sąsiadów w obie strony bez zakleszczenia.

## P0-4 · Usunąć sprzeczność Linii 4 w epilogu domyślnym

**Defekt:** S-09. **Plik:** `scripts/levels/station_43.gd:75`.

Zdanie „W mieście Leny ta linia według niej nigdy nie istniała" jest wprost
sprzeczne z 01/03/04 i z kanonem (katastrofa Linii 4 zabiła Jakuba w świecie
Leny). Zastąpić faktem zgodnym z kanonem — różnicą w **przebiegu albo
statusie** linii, nie w jej istnieniu. Przykład kierunku, nie gotowa kwestia:
radio podaje zamknięcie odcinka, który w jej mieście został odbudowany po
katastrofie.

**Kryterium akceptacji:** żadna linia epilogu — w tym gałąź `unseeded`
osiągalna z selektora — nie zaprzecza faktom z aktu I.

---

# P1 — bez tego historia nie wynika sama z siebie

## P1-1 · Pięć ogniw przyczynowych w akcie II i III

**Defekt:** S-01. To jest najważniejsza naprawa fabularna w całym planie.

**Zasada:** każda scena 13–17 dostaje **zdanie wyjścia** (czego Lena szuka
i dokąd idzie), a każda scena 14–18 **zdanie wejścia** (dlaczego jest właśnie
tu). Dwa zdania na przejście, cztery przejścia. Bez nowych scen, bez nowych
faktów, bez nowych flag — wyłącznie warstwa prezentacji
(`creative_scene_lines.gd` + `OpeningDialogueCue` w `.tscn`).

**Wymagania treściowe dla każdego ogniwa:**

| Przejście | Czego brakuje | Co musi nieść ogniwo |
|---|---|---|
| 13 → 14 | powodu, dla którego Lena idzie do rozdzielni | trop musi wyjść z **istniejącego** materiału 13/15: próba z 20:40 została przerwana korektą spoza pętli. Lena idzie obejrzeć, jak ta korekta wygląda na sprawnej maszynie, zanim wejdzie tam, gdzie przerwała się cudza próba. Rozdzielnia przestaje być lekcją, a staje się rozpoznaniem narzędzia. |
| 14 → 15 | skąd Lena wie o pętli | odwołać się wprost do wyciągu z 11 („próba równoległa, numer czytnika terenowego: brak w rejestrze") i do tego, czego właśnie nauczyła się na moście |
| 15 → 16 | czyj jest analizator i gdzie stoi | żywy sygnał nie może być czytany na sprzęcie, który sam jest częścią pętli; potrzebny jest przyrząd poza obwodem |
| 16 → 17 | skąd wiadomo o rejestrze par | echo domu potwierdziło, że nikt się nie zamienił — więc ktoś to policzył wcześniej; ślad prowadzi tam, gdzie prowadzi się rejestry |

**Zakaz:** ogniwa nie mogą ujawniać niczego, czego Lena nie może jeszcze
wiedzieć (`CONTINUITY_TRACKER.md` §2). Po 13 słownik jest otwarty, więc
ryzyko jest niskie — ale nie wolno wyprzedzać wiedzy o roli UCP w katastrofie
(to należy do 17).

**Kryterium akceptacji:** dla każdej stacji 14–18 da się odpowiedzieć jednym
zdaniem z **treści gry** (nie z dokumentacji) na pytanie „kto ją tu wysłał
i po co". Recenzent, który nie czytał `CAMPAIGN_MAP.md`, musi umieć to
powtórzyć po jednym przejściu.

## P1-2 · Zawias Marty między 10 a 13

**Defekt:** S-06.

Dziś Marta w 10 odsuwa się („nie dotykaj mnie tak, jak ona"), a w 13 bez
przejścia współpracuje przy wspólnym stole.

**Do zrobienia — wariant rekomendowany (tańszy):** wydarzenie dziejące się
poza kadrem i nazwane w 13. Marta przez te dwie godziny zrobiła coś
konkretnego — sprawdziła to, co Lena mówiła w 10 (numer, pracę, zmarłego
brata) — i wróciła z własnym wynikiem. Jedna para kwestii na wejściu do 13,
przed pierwszym punktem interakcji, w której **Marta**, nie Lena, mówi, co
zrobiła i dlaczego usiadła do stołu. To jednocześnie domyka jej autonomię
jako postaci (ma własny cel, nie jest dekoracją).

**Wariant droższy:** krótka wymiana w 12, gdy Lena wraca z warsztatu —
wymaga riga Marty w 12, odrzucić, jeśli budżet napięty.

**Zakaz:** nie osłabiać repliki z 10. Granica Marty jest jedną z najlepszych
rzeczy w grze i ma zostać nienaruszona.

## P1-3 · Ciała dla głosów w 17, 18 i 42A

**Defekt:** S-07.

1. **17:** dodać rig Jakuba albo przepisać jego kwestie na jawne łącze.
   Rekomendacja: **jawne łącze**, bo Jakub w 12 powiedział, że musi oddać
   napęd przed końcem zmiany — jego nieobecność w hali UCP jest wtedy
   konsekwencją, a nie brakiem. Wymaga dopisania jednego nośnika w kadrze
   (terminal łącza przy `ConsentScopeDesk`) i minimalnej korekty didaskaliów.
   Wierzbicka mówi stroną bezosobową przez terminal — to już działa i nie
   wymaga riga, ale nośnik musi być widoczny.
2. **18:** Marta musi być w kadrze. Rozmowa o tym, ile prawdy jej powiedzieć,
   prowadzona z witryną sklepową, jest najcięższą stratą dramatyczną w całej
   grze. Dodać rig Marty przy `MartaTruthTable` (rig istnieje, używany w 10,
   13, 42B, 42C).
3. **42A:** „Marta domowa" mówi przy pustym stole. Dodać rig albo — jeśli
   pustka jest zamierzona — zmienić atrybucję głosu tak, by pustka była
   czytelna jako pustka, a nie jako brak.

## P1-4 · Nazwać miejsce, do którego się wchodzi

**Defekt:** S-10.

Nie chodzi o etykiety na progach (to łamie kanon „kompozycja, nie napis").
Chodzi o to, żeby **ostatnia kwestia sceny wyjściowej nazywała cel**, a
pierwsze ujęcie sceny wejściowej ten cel potwierdzało czymś widocznym. To
naturalnie łączy się z P1-1 i powinno być wykonane w tym samym pakiecie.

Minimalny zestaw dla przejść, które dziś teleportują bez ostrzeżenia:
10 → 11, 12 → 13, 16 → 17, 17 → 18.

---

# P2 — bez tego świat pozostaje listą, ale gra jest spójna

## P2-1 · Nadać trasie kierunek zgodny z fikcją

**Defekt:** S-05, S-08.

Trzy fabularne powroty (do mieszkania w 13, do UCP w 17, na ulicę z 05 w 18)
są dziś wykonywane gestem postępu. `CAMPAIGN_MAP.md` §2 sam ustala regułę,
której runtime nie realizuje.

**Opcja A (odrzucona):** pełna dwuwymiarowa mapa świata z zachowanymi
pozycjami. Koszt nieproporcjonalny do 20 adresów.

**Opcja B (rekomendowana):** kierunek wejścia zgodny z fikcją, realizowany
istniejącym mechanizmem. `GameStateManager.transition_to_station_bidirectional()`
i `_apply_spawn_side_deferred()` **już potrafią** wstawić gracza po prawej
stronie sceny. Wystarczy, by przejścia oznaczone jako powrót korzystały z tej
ścieżki, a scena docelowa otwierała próg po stronie, z której gracz przyszedł.
Zakres: 12 → 13 i 17 → 18 wchodzą z prawej; wyjście z 13 i 18 prowadzi dalej
lewą stroną albo progiem innego rodzaju.
**Warunek:** nie robić tego przed P0-3, bo obie zmiany dotykają tego samego
mechanizmu otwierania progu.

**Opcja C (minimum, gdy B odpadnie):** zostawić kierunek, ale odebrać mu
znaczenie — zrezygnować z deklaracji w `CAMPAIGN_MAP.md` §2, że prawo znaczy
postęp, a lewo powrót, i uczciwie opisać trasę jako sekwencję ujęć. Gorsze,
ale spójne.

**Pion (14 → 15 → 16):** albo wprowadzić `ServiceLift` do 14 i wykorzystać
istniejącą `ServiceLadder` w 15/16 jako faktyczne progi, albo skreślić pion
z `CAMPAIGN_MAP.md`. Dziś dokument obiecuje ruch, którego nie ma.

## P2-2 · Złamać rytm trzech przedmiotów

**Defekt:** S-11.

Nie przebudowywać wszystkich osiemnastu scen. Wystarczy pięć odstępstw
rozłożonych po trasie, tak by forma przestała być przewidywalna:

- jedna scena z **jednym** punktem i długim oddechem (14 już taka jest —
  wykorzystać to świadomie, nie dokładać jej punktów);
- jedna scena, w której kolejność punktów **nie** jest wymuszona;
- jedna scena, w której trzeci punkt jest dostępny tylko przy określonym
  stanie faktu z wcześniejszej sceny (materiał jest: `home_sample_preserved`
  już różnicuje treść w 13 i 16);
- jedna scena przejściowa bez punktów interakcji — czyste przejście
  z myślą wewnętrzną (kandydat: 05, który i tak jest baseline'em);
- jedna scena, w której punkt jest **osobą**, a nie przedmiotem (06 i 08 to
  mają — rozszerzyć na akt II, np. w 17 po naprawie P1-3).

Zróżnicować też typ pierwszych rozbieżności: dziś 06, 07 i 08 to trzy razy
„dokument kontra pamięć". Jedna z nich powinna być rozbieżnością cielesną
albo dźwiękową.

## P2-3 · Higiena: doprowadzić pliki do zgodności z runtime

**Defekt:** S-13. Zadanie dla modeli, nie dla gracza — ale bez niego każda
kolejna sesja będzie naprawiać nieistniejące sceny.

1. Przepisać nagłówki `station_09.gd` … `station_13.gd` tak, by opisywały
   sceny, które te pliki dziś uruchamiają.
2. Zmienić nazwy węzłów rozjechane z podpisami widocznymi dla gracza
   (`WorkBoots`, `CommodePhotograph`, `FieldReaderDock`, `PhoneToMarta`,
   `LegacyDomesticWitnessA/B`). **Uwaga:** to dotyka ścieżek `NodePath`
   i testów — wykonać jednym pakietem z pełną `verify.ps1`.
3. Usunąć martwy kod P7 z 09–13 albo przenieść go do jawnie oznaczonej
   sekcji „donor, nieaktywne".
4. Ujednolicić numerację w `FULL_STORY.md` i `CONTINUITY_TRACKER.md` —
   jedna numeracja, 01–18/42/43, ze starą wyłącznie w tabeli mapowania.
5. Usunąć z `CAMPAIGN_MAP.md` wszystko, czego runtime nie realizuje (winda,
   kierunki powrotu), albo zaimplementować — ale nie zostawiać rozjazdu.

## P2-4 · Uzasadnić czynną instytucję w nocy

**Defekt:** S-12. Jedno zdanie na wejściu do 11 wystarczy: nocny dyżur,
zmiana kontrolna, okienko czynne do rana. Warsztat Jakuba ma to zrobione
wzorowo — powtórzyć wzorzec, nie wymyślać nowego.

---

# Kolejność wykonania i zależności

```
P0-4  (niezależny, najtańszy — zrobić pierwszy)
P0-3  →  P2-1   (oba dotykają otwierania progu; P2-1 nigdy przed P0-3)
P0-1  →  P0-2   (P0-2 pokazuje koszty i luki, które P0-1 czyni wiążącymi)
P1-1  +  P1-4   (jeden pakiet: ogniwa i nazwanie celu to ta sama warstwa)
P1-3  →  P1-2   (zawias Marty łatwiej napisać, gdy ma ciało w 18)
P2-2, P2-3, P2-4 — niezależne, po P1
```

# Czego nie robić

- Nie dopisywać nowych adresów ani nie przywracać scen 19–41.
- Nie przepisywać istniejących kwestii dialogowych „przy okazji". Każda
  zmiana w `creative_scene_lines.gd` poza zakresem pakietu to regresja.
- Nie zastępować brakującej motywacji komunikatem systemowym ani
  wskazówką L4. Ogniwo przyczynowe ma być wypowiedziane przez postać albo
  pokazane w kadrze.
- Nie dodawać przeszkód, których jedynym powodem istnienia jest wydłużenie
  sceny (D-099).
- Nie traktować żadnej z tych napraw jako dowodu, że gra „działa" emocjonalnie.
  Testy potwierdzają kontrakty, nie odbiór (D-012, ADR-003).

# Jak sprawdzić, że plan zadziałał

Jeden test, którego nie da się zautomatyzować, ale który rozstrzyga:
**przejść trasę i po każdej scenie zapisać jedno zdanie odpowiadające na
pytanie „dlaczego idę tam, gdzie idę".** Jeżeli po naprawie da się to zrobić
dla wszystkich osiemnastu adresów bez zaglądania do dokumentacji — sens
fabularny jest odbudowany. Dziś da się to zrobić dla trzynastu.
