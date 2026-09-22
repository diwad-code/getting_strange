# PKG-0187 — pełny audyt i naprawa obrazu

Status: **TECHNICAL / EVIDENCE PASS — nie jest PRODUCT GO**  
Data: 2026-09-04  
Zakres: shell, 20 adresów trasy `01–18 → 42A/B/C → 43`, obsada, CRT,
myśl, progi i kadry monochromatyczne. 42A/B/C to jeden adres kampanii z trzema
wariantami, dlatego tabela rejestruje 22 powierzchnie renderowane i 20 adresów
produktu.

## 1. Metoda i granice dowodu

`tools/capture_pkg_0187.gd` wykonał **106** PNG po poprawce narzędzia, na
normalnym sterowniku **Windows / Intel Iris Xe / OpenGL 3.3**, w logical
`640×360`. Każda powierzchnia ma: `opening_panel`, `normal`, `threshold` i
beztekstowy, prawdziwie monochromatyczny `mono`; obsada ma także wymagane
zbliżenia. Macierz z MD5 i luminancją: `reports/pkg_0187/visual_matrix.tsv`.

Inspekcja rozstrzyga tylko fakty w kadrze: obecność bryły, rodziny, położenie
stóp względem planu gry, relację progu do rysunku, brak tekstu w `mono`, brak
głowy-kółka oraz zgodność języka assetu z Leną 4.1. Nie dowodzi urody,
czytelności dla człowieka, emocji ani `PRODUCT GO` (D-012, D-168).

Skala jest kontrolowana trzema istniejącymi kontraktami, ponownie sprawdzonymi
w `threshold` / `npc_frame`: Lena i stojące rigi mają płótno `64×104`, wzrost
widoczny `84–92 px`; progi pozostają w jedynym źródle
`ThresholdZone.aperture_rect`; progi katalogowe `45×109`, `54×114`, `58×105`
i `64×64` są nadal egzekwowane przez GATE-THRESH. PKG-0187 nie zmienia
collidera, `AirlockZone`, `ReturnZone`, drzwi ani fizyki.

## 2. Tabela adresów

| Adres | Rodzina i funkcja miejsca bez Leny | Kadr | Mono / skala / grunt | Werdykt faktu obrazu |
|---|---|---|---|---|
| station_01 | techniczna; stanowisko diagnostyki drgań Linii 4 | `station_01` normal + threshold | `station_01__mono.png`; Lena na planie gry, bęben i pulpit są bryłami roboczymi | PASS — trzy poziomy: Lena, bęben/odczyt, śluza |
| station_02 | miejska; nocne obejście przy nasypie i roboczym przejściu | `station_02` normal + threshold | `station_02__mono.png`; niebo, fasady, nasyp i krawężnik pozostają rozłączne | PASS — trzy plany i brak sufitu |
| station_03 | tranzytowa; peron Linii 4 z rozkładem i wagonem | `station_03` normal + threshold | `station_03__mono.png`; stała bryła wagonu widoczna w spokojnym kadrze po F-0187-001 | PASS po naprawie — peron, wiata i wagon czytelne bez etykiety |
| station_04 | tranzytowa; wnętrze wagonu z miejscami i drzwiami | `station_04` normal + threshold | `station_04__mono.png`; rytm okien i poziomy toru | PASS — częściowe zadaszenie / korytarz wagonu |
| station_05 | miejska; ulica Sadowa z fasadą, latarnią i przejściem | `station_05` normal + threshold | `station_05__mono.png`; niebo i rytm okien zostają po odjęciu tekstu | PASS — zewnętrzna rodzina |
| station_06 | miejska; kiosk z prasą, rozkładem i oknem sprzedaży | `station_06` normal + `station_06__npc_frame.png` | `station_06__mono.png`; sprzedawca jest rigiem, nie kołem | PASS — kiosk zasłania relację pracy, stopy obu figur na tym samym planie |
| station_07 | miejska; fasada kamienicy i domofon przy wejściu | `station_07` normal + threshold | `station_07__mono.png`; fasada, chodnik i wejście pozostają trzema planami | PASS — próg jest w narysowanym otworze |
| station_08 | mieszkalna; klatka schodowa dwóch mieszkań | `station_08` normal + `station_08__npc_frame.png` | `station_08__mono.png`; niski sufit, schody i sąsiadka-rig | PASS — stopnie i nogi mają wspólną linię podłogi |
| station_09 | mieszkalna; salon dwóch osób z sofą, stołem i ceramiką | `station_09` normal + threshold | `station_09__mono.png`; niski sufit i dwa zestawy rzeczy domowych | PASS — rodzina odróżnialna strukturą |
| station_10 | mieszkalna; mieszkanie Marty: okno, sofa, wspólny stół, półka | `station_10` normal + `station_10__npc_frame.png` | `station_10__mono.png`; Marta-rig, blat na 46 px, lampa i podłoga | PASS po F-0187-002 — obiekt relacji zastąpił pustą planszę |
| station_11 | instytucjonalna; biuro ewidencji z ladą kontroli i zatokami akt | `station_11` normal + `station_11__npc_frame.png` | `station_11__mono.png`; moduł 64 px, lada, Wierzbicka seated-rig | PASS po F-0187-003 — linia kontroli i oś w głąb są widoczne |
| station_12 | techniczna; warsztat utrzymania z rejestratorem, imadłem i szyną narzędzi | `station_12` normal + `station_12__npc_frame.png` | `station_12__mono.png`; Jakub-rig przy stanowisku, maszyna zajmuje lewą trzecią część | PASS po F-0187-004 — dwie szpule są częścią rejestratora, nie głową |
| station_13 | mieszkalna; stół dokumentów, ścienne nisze i domowy zapis | `station_13` normal + threshold | `station_13__mono.png`; dwa plany i niskie źródła światła | PASS — nie używa instytucjonalnej osi kontroli |
| station_14 | techniczna; rozdzielnia i montaż sekcji Linii 4 | `station_14` normal + threshold | `station_14__mono.png`; maszyna, rury i podest są czytelne | PASS — infrastruktura wykonuje pracę, nie jest platformą |
| station_15 | graniczna; pętla pomiarowa z jednym rozbieżnym odbiornikiem | `station_15` normal + threshold | `station_15__mono.png`; techniczna topologia z jedną niezgodnością | PASS — bez globalnego glitchu |
| station_16 | graniczna; bezpieczny analizator i echo domu | `station_16` normal + threshold | `station_16__mono.png`; drabina, analizator, jedno źródło rozbieżności | PASS — otoczenie wyjaśnia pracę urządzenia |
| station_17 | instytucjonalna; rejestr par kosztów i stanowisko odmowy | `station_17` normal + threshold | `station_17__mono.png`; moduł, lada i długa oś | PASS — brak domowego ciepła jako skrótu |
| station_18 | miejska; witryna i ulica decyzji metody | `station_18` normal + threshold | `station_18__mono.png`; niebo, fasada, witryna i latarnia | PASS — powrót rodziny miejskiej jest strukturalny |
| station_42a | finałowa (wariant A); ten sam dom o świcie, puste krzesło | `station_42a` normal + threshold | `station_42a__mono.png`; znajoma bryła, jedna zmiana osobowa | PASS — brak moralnego kodowania kolorem |
| station_42b | finałowa (wariant B); dom o świcie, Marta przy odzyskanym progu | `station_42b` normal + `station_42b__npc_frame.png` | `station_42b__mono.png`; Marta-rig i matowa sylwetka tylko za progiem | PASS po F-0187-005 — brak człowieka z koła i kreski |
| station_42c | finałowa (wariant C); dom o świcie, dwa odbiorniki pamięci | `station_42c` normal + `station_42c__npc_frame.png` | `station_42c__mono.png`; Marta-rig, dwa nieczytelne odbicia w szybach | PASS po F-0187-005 — sylwetki są wyjątkiem matowej szyby, nie NPC |
| station_43 | finałowa; wiata / tor i administracyjne domknięcie świtu | `station_43` normal + threshold | `station_43__mono.png`; znana tranzytowa bryła i jeden zmieniony fakt | PASS — credits są ostre poza światem |

## 3. Shell, CRT i powierzchnie przekrojowe

| Powierzchnia | Dowód | Sprawdzony fakt |
|---|---|---|
| tytuł | `shell_title__pl.png` | shell jest osobną ostrą warstwą, nie światem po filtrze |
| ustawienia | `settings__pl.png` | tekst systemowy zachowuje raster natywny |
| zimne otwarcie | `cold_open__initial.png` | obraz ma niezerową luminancję po ustabilizowaniu |
| pauza | `pause__campaign.png` | selektor nie wchodzi do świata kampanii |
| CRT portrety | `panel_portrait__lena.png`, `panel_portrait__marta.png`, `panel_portrait__jakub.png`, `panel_portrait__wierzbicka.png`, `panel_portrait__szymon.png` | pięć tożsamości CRT pozostaje na własnej, ostrej warstwie |
| dialog Marta + Lena | `panel_dialogue__marta_then_lena.png` | panel CRT, Marta-rig i Lena mieszczą się w kadrze dialogowym |
| myśl Leny | `panel_thought__lena.png` | `InnerThoughtSurface` pozostaje poza warstwą świata |
| progi i pion | 22 pliki `station_*__threshold.png`; drabiny 02/15/16 widoczne także w `mono` | każde przejście jest kadrowane przy narysowanym otworze; drabiny są osadzone w konstrukcji |

## 4. Findings i naprawy

| ID | Dowód początkowy | Naruszony kontrakt | Naprawa | Retest |
|---|---|---|---|---|
| F-0187-001 | poprzedni spokojny kadr 03 pokazywał tylko skraj wagonu | rodzina tranzytowa ma pokazać peron **i** pojazd przed tekstem | `station_03.gd`: wagon ma stabilne x=394 z małym ruchem własnego rozkładu | `station_03__normal.png`, `station_03__mono.png` |
| F-0187-002 | 10: jeden stół na pustej ścianie | mieszkalna rodzina: niski sufit, dwa zestawy codziennych rzeczy, max dwa plany | `station_10.gd`: okno, sofa, wspólny stół, lampa, półka; Marta pozostaje rigiem | `station_10__normal.png`, `station_10__npc_frame.png` |
| F-0187-003 | 11: jasna, anonimowa ściana bez punktu kontroli | instytucja: linia kontroli, oś w głąb i moduł 64 px | `station_11.gd`: lada, zatoki akt, drzwi bezpieczeństwa, szyna kolejki | `station_11__normal.png`, `station_11__mono.png` |
| F-0187-004 | 12: izolowane koło mogło czytać się jak głowa | techniczna maszyna ma widoczną funkcję; człowiek jest rigiem | `station_12.gd`: rejestrator z dwiema szpulami, panel, szyna kabli, imadło i stół Jakuba | `station_12__normal.png`, `station_12__npc_frame.png` |
| F-0187-005 | 42B/42C: lokalne Leny jako koło + pionowa kreska | `CAST_AND_NPC_BIBLE.md` §1, D-202 | zastąpione nieczytelnymi, matowymi sylwetkami **wewnątrz** progu; Marta w świecie zostaje `CharacterVisualRig` | `station_42b__normal.png`, `station_42c__normal.png`; lint `pkg_0187` |
| F-0187-006 | pierwszy przebieg capture’u zgłaszał typ `CanvasLayer` w `Array[CanvasItem]` | capture ma być wolny od błędów logu | lista została poprawiona do `Array[Node]` z przywracaniem obu typów warstw; wykonano pełny recapture | `visual_matrix.tsv`, wyjście `PKG-0187 VISUAL CAPTURE PASS` |

## 5. Wynik techniczny i ograniczenia

- 22/22 powierzchni aktywnej trasy: `normal`, `opening_panel`, `threshold`,
  `mono`; 7/7 wymaganych zbliżeń NPC; 5/5 portretów CRT; shell, pauza, dialog
  i myśl obecne. Łącznie 106 kadrów Windows.
- `mono` usuwa tekst i UI przed konwersją do szarości; różne sylwetki rodzin są
  dowodem struktury obrazu, nie odbioru człowieka.
- `pkg_0187_visual_audit_test.gd` kontroluje obecność evidence, 640×360,
  sterownik Windows, ostre warstwy tekstu, rigi obsady i zakaz finałowych
  głów-kółek. `pkg_0186_cast_style_test.gd` nadal jest regresją assetów.
- Nie twierdzimy, że obraz „wygląda dobrze”, że miejsce jest zrozumiałe dla
  gracza ani że gra dostała `PRODUCT GO`. D-168 nadal blokuje release i `.exe`.
