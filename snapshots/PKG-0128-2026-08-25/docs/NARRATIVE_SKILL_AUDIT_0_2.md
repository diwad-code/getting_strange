# Audyt narracji 0.2 na podstawie skilli pisarskich

Status: **ZAMKNIĘTY AUDYT — WERDYKT REJECT / REWOLUCJA FABULARNA**  
Data: 2026-08-25  
Audytowane źródło: zamrożony kanon PKG-0116 w
`snapshots/PKG-0116-2026-08-24/`; bieżące cztery pliki narracyjne miały przed
audytem identyczne sumy SHA-256.

Requested Mode: full  
Effective Mode: solo  
Fallback: required project reviewer agents unavailable -> solo rubric review  
Rubric: adapted general story quality, mystery fair play, character agency,
dialogue, continuity, emotional staging and interactive experience loop  
Rubric Source: file

## 1. Werdykt wykonawczy

Kanon 0.2 naprawił najpilniejszy błąd wersji 0.1: nie ujawnia już innego świata
na początku. Sama drabina `normalność -> niepokój -> zmieszanie -> lęk ->
upiorność -> rozpoznanie` jest dobra i powinna zostać.

Kanon 0.2 nie jest jednak gotową historią do wdrożenia. Jest poprawną mapą
ujawnień bez równie mocnego kręgosłupa dramatycznego. Lena ma zawód i sposób
myślenia, ale nie ma osobistego pragnienia, rany ani relacji, które napędzałyby
jej wybory od pierwszej sceny. Marta nie ma ustalonej relacji z Leną. Jakub
najpierw służy jako dowód, a dopiero potem broni podmiotowości. Miejscowa Lena
uruchamia główną tajemnicę, lecz jej zamiar, sprawczość i los pozostają
nieokreślone. UCP nie ma ustalonej aktywnej reprezentantki, mimo że finał zależy
od jego winy. Trzy zakończenia są kategoriami ideowymi, nie konkretnymi
konsekwencjami ludzi.

Decyzja: **głęboka rewolucja fabularna w tym samym projekcie Godot**.
Nie rozpoczynamy pustego projektu. Zachowujemy sprawny szkielet, tytuł, Lenę,
Martę, Jakuba, Rówień, powolną bramę 21/22, Anchor/Yield i 43 techniczne
przestrzenie. Ponownie budujemy przyczynę przejścia, osobisty rdzeń, relacje,
przeciwną siłę, drugą połowę oraz zakończenia.

## 2. Jak potraktowano dodane skille

### Zastosowane

| Skill / materiał | Zastosowanie w audycie |
|---|---|
| `story` -> `story-review` | routing oraz jednolity schemat findings S1–S4 |
| `mystery-novel-conventions` | uczciwość poszlak, hipotezy konkurencyjne, brak deus ex machina i domknięcie głównego pytania |
| `natural-dialogue-techniques` | agenda rozmówcy, podtekst, odrębne głosy, przemilczenia i test usunięcia etykiet mówiących |
| `story-consistency-monitor` | nazwiska, wiedza postaci, chronologia, reguły UCP i kosztów |
| `forgotten-elements-reminder` | linie hot/warm/cold dla Marty, Jakuba, miejscowej Leny, UCP i próbki |
| `emotional-narrative` | emocja -> gest -> timing -> reakcja wtórna; cisza jako część sceny |
| `experience-design` | zgodność fikcji, mechaniki i feedbacku; pętla działanie -> reakcja -> ocena -> decyzja |
| `novel-writer-workflow-guide` | rozdzielenie konstytucji opowieści, specyfikacji, planu scen i późniejszej implementacji |
| referencje `story-review` | rubric jakości, konflikt, relacje, dialog, anty-szablonowość i kontrola ciągłości |

### Przejrzane, lecz świadomie niezastosowane jako normy

- `novel-creator`, `novel-architect`, `story-short-*`, `story-long-*`,
  `story-deslop` i `webnovel-write` są zorientowane na chińskie webnovel,
  platformowe progi retencji, nową książkę lub EPUB. Ich limity rozdziałów,
  słów, „爽点” i formatowania mobilnego nie są kryteriami gry 2D.
- `storytelling-expert` służy głównie prezentacjom i perswazji; jego ramy nie
  zastępują dramaturgii interaktywnej.
- `fiction-writer` i `narrative-conductor` są związane z innym, nazwanym
  uniwersum. `fantasy-world-building` zakłada fantastykę i system magii.
- `dialogue-systems`, `godot-dialogue-system` i
  `godot-genre-visual-novel` dotyczą architektury runtime lub visual novel.
  Wrócą przy implementacji powierzchni dialogowej tylko wtedy, gdy pasują do
  aktualnej architektury Godot.

Reguły gatunkowe zostały zaadaptowane, nie skopiowane mechanicznie. Station 21
nie musi być finałem klasycznej zagadki: ma być środkowym przeformułowaniem.
W zamian druga połowa musi uruchamiać nowe, uczciwie zapowiedziane pytanie.
Podobnie zwyczajny początek jest celowy; musi jednak zawierać konflikt ludzki
lub zawodowy, a nie paranormalny hak.

## 3. Ocena rubric

| Wymiar | Ocena | Uzasadnienie |
|---|---|---|
| rdzeń i obietnica tytułu | PASS | narastanie i brama 21/22 są czytelne |
| konflikt i przyczynowość | FAIL | po rozpoznaniu dominuje procedura, brak ustalonej przeciwsiły i przyczyny przejścia |
| krzywa emocjonalna | WARN | etykiety emocji są poprawne, ale nie wynikają jeszcze z relacji i ceny |
| otwarcie i oczekiwanie | WARN | normalność jest potrzebna, lecz pierwsze pięć scen nie ma konfliktu osobistego |
| motywacja i łuk Leny | FAIL | istnieje łuk epistemiczny, brak rany, pragnienia i trudnej potrzeby |
| dialog i podtekst | FAIL | głosy są opisane, ale próbki zbiegają się w wypolerowane tezy |
| ciągłość wiedzy i nazw | FAIL | niespójne nazwisko Marty i przedwczesna wiedza w Station 21 |
| pętla gry | FAIL | większość stacji ma fakt/temat, ale nie pełne cel -> przeszkoda -> działanie -> feedback |
| relacje | FAIL | nie zdefiniowano rodzaju więzi Marty; miejscowa Lena pozostaje funkcją zagadki |
| uczciwość głównego ujawnienia | PASS | trzy rodziny dowodów przed Station 21 są sensownym szkieletem |
| druga tajemnica i wypłata | FAIL | los miejscowej Leny oraz praprzyczyna przejścia nie mają kanonicznej odpowiedzi |
| kulminacja i zakończenia | FAIL | kategorie finałów nie mają równoważnych, konkretnych kosztów i domknięć |

Verdict: **REJECT kanonu 0.2 jako podstawy dalszego autorstwa scen**.

## 4. Findings

- severity: S1
  category: character
  location: `snapshots/PKG-0116-2026-08-24/docs/narrative/FULL_STORY.md:24`
  evidence: Station 01–05 ustanawiają wyłącznie pomiar, drogę i powrót; biblia
    opisuje u Leny zawód oraz potrzebę pewnego wyjaśnienia, ale nie źródło tej
    potrzeby ani relacyjny koszt.
  issue: Bohaterka ma kompetencję, lecz nie ma dramatycznego silnika. Po usunięciu
    zagadki nie wiadomo, czego chce tego wieczoru i dlaczego gracz ma martwić
    się właśnie o nią.
  fix: Powiązać obsesję pomiaru z katastrofą Linii 4 i śmiercią Jakuba oraz
    ustanowić od pierwszej sceny niedotrzymaną obietnicę wobec Marty.

- severity: S1
  category: structure
  location: `snapshots/PKG-0116-2026-08-24/docs/narrative/FULL_STORY.md:201`
  evidence: W Station 26 miejscowa Lena „mogła” zbliżyć się do przejścia, w 33
    pozostawia procedurę, a 42–43 zapisują rodzinę wyniku bez rozstrzygnięcia,
    gdzie jest i co zrobiła.
  issue: Główna przyczyna przybycia Leny oraz los osoby, której życie zajęła,
    pozostają nieodpowiedziane. To nie jest produktywna kosmologiczna
    niepewność, lecz niedomknięty łańcuch przyczynowy.
  fix: Ustalić przerwany, obustronny test miejscowej Leny, interwencję UCP i jej
    uwięzienie między ciągłościami; każde zakończenie musi pokazać jej los.

- severity: S1
  category: structure
  location: `snapshots/PKG-0116-2026-08-24/docs/narrative/CONTINUITY_TRACKER.md:85`
  evidence: Tracker mówi, że dr Wierzbicka „może wrócić”, a jej dokładna rola
    pozostaje zadaniem, choć Station 22–41 opierają się na ukrywanych kosztach
    i dostępie kontrolowanym przez UCP.
  issue: Druga połowa nie ma ustalonej aktywnej siły przeciwnej. Dane, węzły i
    procedury stawiają opór techniczny, ale nikt konsekwentnie nie realizuje
    kolidującego celu.
  fix: Ustanowić Wierzbicką jako odpowiedzialną za stabilizację Równi i za
    przerwanie testu. Jej celem jest zamknięcie przecieku i ochrona większości,
    nawet kosztem autonomii obu Len.

- severity: S1
  category: structure
  location: `snapshots/PKG-0116-2026-08-24/docs/narrative/NARRATIVE_BIBLE.md:153`
  evidence: „Przejście kontrolowane” ogranicza szkody, podczas gdy dwa pozostałe
    warianty jawnie wymuszają pęknięcie albo rezygnację; opis nie ustala
    porównywalnego, nieodwracalnego kosztu trzeciej drogi.
  issue: Jedna opcja czyta się jak golden ending, a finały pozostają abstrakcyjne.
    Nie wiadomo konkretnie, co dzieje się z Martą, Jakubem, miejscową Leną i
    domem bohaterki.
  fix: Nadać każdej metodzie inną chronioną wartość i nieusuwalną stratę;
    epilog ma pokazać stan każdej kluczowej osoby oraz świata.

- severity: S1
  category: consistency
  location: `snapshots/PKG-0116-2026-08-24/docs/narrative/DIALOGUE_SCRIPT.md:255`
  evidence: Marta przywołuje rejestry miejski i szpitalny, Jakub zna bazę
    czytnika, a Lena już w Station 21 wie, że powrót może „rozerwać” świat,
    mimo że koszty działania poznaje dopiero od Station 22.
  issue: Postacie dostarczają w finale diagnozy wiedzę i ocenę kosztu, których
    źródła nie zostały ustanowione. Synteza brzmi jak głos dokumentacji.
  fix: W Station 21 dowieść tylko obcej ciągłości i natychmiast otworzyć pytanie
    „gdzie jest druga Lena?”. Wiedzę o kosztach oraz dostępach przypisać
    późniejszym scenom i konkretnym kompetencjom postaci.

- severity: S2
  category: consistency
  location: `snapshots/PKG-0116-2026-08-24/docs/narrative/NARRATIVE_BIBLE.md:72`
  evidence: Biblia nazywa ją Martą Krajewską, a biblia dialogowa w linii 43 —
    Martą Kurek. Żaden dokument nie definiuje jednoznacznie rodzaju jej więzi z
    Leną, choć zna rytuały domowe i stawia warunki dotyczące całego świata.
  issue: Najważniejsza żywa relacja nie ma stabilnej tożsamości ani stawki.
  fix: Ujednolicić nazwisko `Marta Kurek`; w domu Leny jest najbliższą
    współpracownicą i przyjaciółką, a w Równi partnerką miejscowej Leny.

- severity: S2
  category: prose
  location: `snapshots/PKG-0116-2026-08-24/docs/narrative/DIALOGUE_SCRIPT.md:274`
  evidence: Próbki „Brzmi jak dwie nazwy na ryzyko”, „Nie jest pomyłką. Jest
    miejscem...”, „Zostawiła metodę, nie zgodę” i warianty Station 39 mają ten
    sam skrótowy, sentencjonalny rytm. 27 z 73 oznaczonych linii zawiera
    konstrukcję negacji.
  issue: Głosy nominalnie różnią się w opisie, lecz w scenach mówią językiem
    autora i tez tematycznych. Podtekst zostaje wypowiedziany wprost.
  fix: Nadać każdej postaci własną agendę, długość zdań, uniki i słownictwo;
    przenieść znaczenie do przerwanych czynności, uników, konkretów i ciszy.

- severity: S2
  category: structure
  location: `snapshots/PKG-0116-2026-08-24/docs/narrative/FULL_STORY.md:1`
  evidence: Spośród 43 opisów tylko Station 01 i 11 jawnie zapisują cel;
    Station 22–41 często nazywają informację lub urządzenie zamiast konfliktu,
    decyzji i zmiany relacji.
  issue: Mapa grozi „taśmociągiem poszlak”: wejście, odczyt, komentarz, wyjście.
    Fikcja nie gwarantuje jeszcze pętli działania i feedbacku.
  fix: Zgrupować 43 techniczne przestrzenie w osiem sekwencji dramatycznych i
    dla każdej stacji zapisać cel, przeszkodę, działanie, zmianę oraz nowe
    oczekiwanie; przejścia bez funkcji połączyć lub pozostawić jako ciszę.

- severity: S2
  category: character
  location: `snapshots/PKG-0116-2026-08-24/docs/narrative/DIALOGUE_SCRIPT.md:346`
  evidence: Matryca deklaruje omylność, lecz większość przykładowych myśli jest
    trafną obserwacją albo sprawną instrukcją. Rzadkie błędy są neutralnymi
    hipotezami technicznymi.
  issue: Wewnętrzny głos nie pokazuje jeszcze obrony, żalu, uprzedzeń ani
    samousprawiedliwienia. Brzmi jak system podpowiedzi przebrany za Lenę.
  fix: Każda błędna myśl ma wynikać z jej rany lub relacji, przewidywać
    sprawdzalny fakt i zostać skorygowana przez działanie, nigdy przez narratora.

## 5. Co bezwzględnie zachować

1. Tytułową krzywą narastania oraz brak diagnozy przed Station 21.
2. Station 21 jako interaktywną syntezę trzech rodzin dowodów.
3. Station 22 jako pierwsze świadome naprawianie i nazwanie Anchor/Yield.
4. Spójny obcy świat zamiast snu, symulacji lub losowych glitchy.
5. Brak uprzywilejowanego „oryginału” i prawo mieszkańców Równi do własnego
   życia.
6. Jakuba jako osobę, nie nagrodę albo klucz.
7. Sekwencję pokaż -> naprowadź -> pomyśl oraz omylność wyłącznie
   interpretacyjną.
8. Pixel-Stage świata z ostrym tekstem i ludzki rig Leny.
9. Techniczny szkielet Godot, zapis, shell, routing, audio i testy.

## 6. Kontrakt rewolucji 0.3

Nowy kanon ma być zbudowany wokół jednego zdania:

> Lena, która po śmierci Jakuba próbuje mierzyć świat tak długo, aż nie zostanie
> w nim żadna niepewność, trafia do ciągłości uratowanej kosztem cudzej straty i
> musi zdecydować, czy powrót jest jeszcze naprawą, jeśli wymaga ponownego
> potraktowania człowieka jak wyniku.

Obowiązkowe zmiany:

- katastrofa Linii 4 staje się źródłem zawodu, winy i potrzeby kontroli Leny;
- Marta Kurek otrzymuje dwie jawne, różne relacje z dwiema Lenami oraz własny
  cel: odnaleźć partnerkę, nie zaakceptować zamiennika;
- Jakub ma własne życie i wybór; jego ocalenie w Równi jest częścią kosztu UCP,
  lecz nie długiem do spłacenia śmiercią;
- miejscowa Lena uruchomiła obustronny test, UCP przerwał go Zakotwiczeniem, a
  jej los jest rozwiązywalną drugą tajemnicą;
- dr Helena Wierzbicka prowadzi aktywną, racjonalną opozycję: chroni stabilność
  większości kosztem autonomii odchyleń;
- Station 21 odpowiada „gdzie jestem?”, a od Station 22 gra pyta „co zrobiła
  druga Lena i komu wolno zapłacić za powrót?”;
- 43 adresy techniczne zostają, ale fabuła ma osiem sekwencji, nie 43 równorzędne
  „rozdziały-poszlaki”;
- każdy finał określa stan Leny domowej, Leny miejscowej, Marty, Jakuba, UCP i
  obu ciągłości; żaden nie dostaje kompletu nagród.

## 7. Ograniczenia audytu

Audyt ocenia tekst kanonu 0.2, jego spójność i potencjał wykonawczy. Nie jest
playtestem i nie dowodzi, że odbiorca poczuje napięcie, żal albo więź. Nie
ocenia też jakości obecnego legacy runtime jako przeżycia. W trakcie audytu w
katalogu pojawiły się równoległe, nieudokumentowane zmiany Foundation Slice;
nie zostały nadpisane i są osobnym stanem technicznym do uzgodnienia.
