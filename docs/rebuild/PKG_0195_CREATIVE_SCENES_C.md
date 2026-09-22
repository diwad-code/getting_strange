# PKG-0195 / CR-C — Raport: metoda i skutek (finały 42A/B/C + epilog 43)

Data: 2026-09-05. Pakiet wykonawczy CR-C z
`docs/rebuild/CREATIVE_REVIEW_AND_EXPANSION_PLAN.md` §7 (kolejka CR-A →
CR-B → **CR-C** → CR-D, kontrakt §8.1). Nie jest PRODUCT GO ani decyzją
wydawniczą (D-168 blokuje release i nowy `.exe`).

## Co dostarczono (rozmowy, nie fakty)

Trasa i fizyka bez zmian: 20 adresów, progi, InputMap, 60 Hz, 640×360, zero
nowych colliderów, ≤3 istotne interakcje na adres. Nowi writerzy faktów nie
powstali; wszystkie zapisy robią dotychczasowe czasowniki stacji. Treść
rozmów pochodzi z kanonu (DIALOGUE_SCRIPT §13 „Epilogi bez sentencji”,
FULL_STORY 42A/B/C, matryca CONTINUITY_TRACKER §14) — pakiet ją dostarcza
przez kolejkę CRT, nie wymyśla.

- **42A (wymuszony powrót):** wykonanie oddzielone od odczytu skutku.
  Rygiel: myśl rozpoznania z 41 (`Numer domowy. Brak drugiej odpowiedzi.`),
  Lena kładzie czytnik zamiast odpowiedzieć, ekran proponuje `BŁĄD
  CZUJNIKA`, jawne „Najpierw wykonanie. Skutek odczytam potem.” Próg:
  zamknięty kanał bez wymyślania odpowiedzi (`Nie wymyślę jej odpowiedzi`).
  Stół: domowa Marta pyta o zniknięcie w trzech wariantach prawdy
  (full/partial/withheld, lustro tabeli 18); apel Równi z nazwanego źródła
  (zgłoszenie o zaginięciu); Jakub wyłącznie we wcześniejszym zapisie
  serwisowym (koniec nieustanowionego głosu zza mostu, E13); raport UCP
  wygładza incydent. Usunięte hasło „Pamiętaj osobno. Obie.” i teza
  „To skutek, nie ocena” (CR-D07).
- **42B (zamknięcie Równi):** perspektywa przybyłej oddzielona od sceny
  Marty w Równi. Zamknięcie: myśl z 41, wygaszenie domowej sygnatury,
  kanał dopiero po powrocie miejscowej. Próg: miejscowa Lena jako
  rozpoznawalna osoba — pytanie Marty (`Co wiedziałaś przed testem?`),
  własna odpowiedź o teście, oddech i wstrzymany klucz; matowa szyba
  zostaje etapem, nie całą wypłatą. Stół: cięcie do wiaty z linii 03 jako
  miejsca bez indeksu (prezentacja wariantu w tym samym adresie, nie nowa
  scena ani rodzina); wiadomość `Jadę` bez adresata (kanon dialogowy;
  przechowywane `Tak` z FULL_STORY to odrębna, wcześniejsza wiadomość);
  drugie zgłoszenie domowej Marty (warianty wg prawdy); Jakub przy własnej
  pracy w swoim zakresie; zapis UCP zamyka eksport kosztów z węzła.
  Usunięte hasło „Obie jesteście prawdziwe” i teza „nie nagroda” (CR-D07).
- **42C (wzajemne przejście):** otwarcie (myśl z 41, dwa strojenia,
  „Otwieram, nie zabieram”). Przeciek jako konkret: epizod obcej pamięci
  śmierci przerywa zwykłą czynność Jakuba przy imadle (`Wracam do napędu.
  To mija.` — bez nowej katastrofy) oraz oba czytniki z tą samą brakującą
  sekundą po rozdzieleniu. Stół: wymiana o kubku i pustej półce (kanon
  §13, warianty wg prawdy), pytanie Równi o odpowiedzialność z odpowiedzią
  obu Len, dwa zapisy odbierające UCP wyłączność, dalszy wspólny ubytek
  czasu. C nie jest katastrofą, A nie karą, B nie obowiązkiem.
- **43 (epilog):** struktura 5 linii i индексы 0/1/3 bez zmian (bramka
  0170). Zamienione: osierocona kwestia Szymona w B na konsekwencję
  ustanowionej osoby (drugie zgłoszenie domowej Marty — CR-D01), oraz
  cztery autorskie sentencje końcowe (`Prawda nie wybiera… Koniec wycinka`)
  na konkretne gesty wg FULL_STORY („Ostatnia nuta”): oznaczenie próbki
  z pustą rubryką (A), czytnik z `Jadę` bez adresata (B), kubek na pustej
  półce (C), klucze na blat (unseeded). Guidance bez języka dokumentacji
  (`bez fałszywego happy endu` → nazwane braki). Tablice licencji/credits
  i ich teksty nietknięte (0153/0170); scena kończy własne zdarzenie
  (tablica) przed napisami; blackout wraca do tytułu zgodnie z projektem.

## Zmiany kodu

- `scripts/levels/creative_scene_lines.gd` — treść CR-C: 6 kluczy
  wykonania/odczytu + 9 wariantów `household_{a,b,c}_{full,partial,withheld}`
  (gałąź po stacji i stanie prawdy, wzór tabeli 18; domyślny `partial`
  jak słownik skutku). Bez bramki wiedzy (zatwierdzona metoda zakłada
  trasę 18; testy 0167–0169 sieją metodę wprost).
- `scripts/levels/creative_scene_presentation.gd` — BEZ ZMIAN (straż
  winiety, kolejka i izolacja advance działają dla 42 bez modyfikacji).
- `station_42a/b/c.gd` — wyłącznie: podpięcie prezentera w `_ready()`
  (3 linie, wzór CR-A), przepisane `DIALOGUE_LINES` (ten sam rozmiar 4,
  bramka 0107) na treść kanonu §13, oraz guidance bez tez autorskich.
  Writery, flagi, sygnały (w tym `household_consequence_read` dla winiet),
  fakty, progi, rysunek (`_draw_*`, DEF-9) i fizyka bez zmian.
- `station_43.gd` — wyłącznie treść 4 zamknięć + linii B[2] i guidance L2
  (powyżej). Metody, sygnały, fakty, progi, plansze i rysunek bez zmian.
- `tests/pkg_0195_creative_scene_c_test.gd` — nowa bramka + wpis w
  `tools/verify.ps1`. Realny input → writer → kolejka CRT (nie samo
  `advance_dialogue()`); trzy trasy z routingiem; save/reload przed/po;
  reread bez powtórki winiety i bez nowych faktów; 3 winiety finałowe ze
  skipem semantycznym; skale 85/100/115% z kontrolą wysokości tekstu;
  statyczne kontrole 43 (brak Szymona/tezy, zachowane indeksy 0170)
  i czystości tez w 42.
- `tools/verify.ps1` — dopisana bramka PKG-0195.

## Konflikty nazwane wprost (wzór D-210/D-211)

Żaden istniejący lint nie wymagał zmiany. Bramki 0167–0170, 0107 (rozmiar
`dialogue_lines` 4/5), 0153 (manifesty), 0175, 0186/0187 (w tym zakaz
kółko-głowy w 42B/C) i 0190 (katalog 7 winiet, sygnały, ending values)
pozostają GREEN bez modyfikacji — nowe treści pisano pod nie.
Twarde wykrycia harnessowe (nie defekty gry): (a) capture 43 pokazał
nakładkę tytułową, bo blackout wraca do tytułu w harnessie — naprawione
flagą `campaign_auto_transition_enabled=false` (wzór 0170) i ponownym
capture; (b) obejrzenie winiety auto-zapisuje settings na dysk, więc pętla
skal utrwaliła `text_scale: 1.15` i połamała dokładny rozmiar panelu pauzy
w PKG-0113 przy następnym przebiegu — bramka 0195 normalizuje settings na
wejściu i przywraca domyślne na wyjściu (0194 nie musiał, bo jego pętla
skal nie pokazuje winiet); (c) kombinacja winieta+skip,
instant-completion i ręczne free z jedną klatką gubiła syntetyczne
naciśnięcia w teście (bisekcja w SESSION_LOG) — completion pozostało
w 0167–0169, bramka 0195 czeka na realne zwolnienie instancji.
Podpisy `vig_finale_*` już są zgodne z napisanymi scenami (weryfikacja
spójności podpis↔scena zamiast dowolnej edycji); plansze PNG nietknięte
(brak generacji assetów, jak w CR-A/CR-B); portret Marty zachowuje jedną
ekspresję (dalsza inscenizacja należy do CR-D/późniejszych wycinków).

## Weryfikacja

- `tests/pkg_0195_creative_scene_c_test.gd` — **PASS** headless i normalny
  Windows OpenGL / Intel Iris Xe: trzy trasy (full+granted→42A,
  partial+limited→42B, withheld+refused→42C), kolejność wykonanie→skutek,
  cięcie perspektywy w B, konkretny przeciek w C, save/reload, reread,
  4 gałęzie 43, skale 85/100/115%.
- Capture Windows (normalny sterownik, ten sam harness): 183 PNG +
  `reports/pkg_0195/visual_final/frames.tsv`. Obejrzano: pytanie Marty
  i rig w 42B, epizod Jakuba w 42C, `Gdzie byłaś?` w 42A, planszę B[2]
  w 43, winietę finału B, warianty skal. Tekst mieści się w panelach
  (pomiar wysokości w teście).
- Baseline: zamknięcie PKG-0194 (exit 0, 98 bramek) + brak edycji na starcie
  sesji; `verify_docs.ps1` PASS; finale gates 0167/0170 PASS przed edycjami.
  Wiążący jest końcowy pełny przebieg (niżej).

## Znalezisko harnessowe (nie defekt gry)

Podczas prac wykryto wrażliwość kolejności w teście: winieta+skip,
następnie natychmiastowe `ThresholdBinder.complete_from_test` i
`queue_free` z odczekaniem jednej klatki powodowały gubienie kolejnych
syntetycznych naciśnięć w TEŚCIE (bisekcja: sam install nie szkodzi;
sama seria otwarć nie szkodzi; bezpośrednie wołania writerów, fakty
i sygnały zawsze poprawne). Zachowanie nie występuje w grze (tam
przejście to zmiana sceny, nie ręczne free) ani w bramkach 0167–0169.
Bramka 0195 nie dublowała completion (należy do 0167–0169, które po tym
pakiecie działają z podpiętym prezenterem) i czeka na realne zwolnienie
instancji przy zamykaniu stacji. Gra nie była zmieniana z tego powodu.

## Granice (czego nie dowodzi)

Jak CR-A/CR-B: brak dowodu odbioru (D-012 — zero zewnętrznych testerów,
nigdy), czasu człowieka, komfortu sterowania ani miksu. Testy dowodzą
dostarczenia treści i kontraktów, nie wzruszenia. Matowa sylwetka
miejscowej Leny pozostaje etapem (wyjątek DEF-9); pełna inscenizacja
rozpoznania należy do kolejnych wycinków.

## Następny pakiet

CR-D (rytm 01–08, przyczyna `leave_on_time`, plastyka rodzin i powrotów,
kontrola ciągłości), specyfikacja w planie §7. Numer spodziewany: PKG-0196.
