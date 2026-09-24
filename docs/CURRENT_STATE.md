# Aktualny stan projektu

## Aktualizacja nadrzedna — 2026-09-24 / PKG-0242

Stan po pakiecie gotowosci do premiery na galezi `claude/vigilant-brahmagupta-eq594t`
(baza `ea61916`, merge PKG-0241). Raport: [PKG_0242_REPORT](audits/PKG_0242_REPORT.md).

- Kampania ukonczalna **wylacznie wejsciem gracza** na zakonczeniach A, B i C
  (M1 `pkg_0177`: 01 → 18 → 17 → 18 → 42A/B/C → 43); 22 adresy fizycznie przechodnie
  (nowa bramka `pkg_0242`).
- Naprawy: cokol 14, arbitraz naciśnięcia (`InteractionFocus`), przewijanie CRT w `_input`,
  otwory wyjsc na podlodze, legendy wyborow 16/17/18, pasy wyboru 40 px, drzwi ustepuja
  punktom z niedokonczonym dzialaniem, zamkniete drzwi 18/42 mowia czego brakuje, kroki
  w pokoju nazywaja poprzednika, blad skryptu 16 przy powrocie, slad 05.
- Powloka wydania: pauza bez trybu testowego poza buildem deweloperskim, TWÓRCY I LICENCJE
  z tekstami licencji z silnika, wersja 1.0.0, podpowiedz CRT z przypisanym klawiszem, 43 bez
  manifestu licencji w swiecie.
- 39 bramek przepietych na lancuch zgody PKG-0239 i tekst wlasciciela z zachowaniem intencji
  (D-252); licznik 0207: 131/130/129/129; helper 0212: 4.
- Weryfikacja: izolowane uruchomienia 129/129 bramek PASS; pelna `verify.ps1 -AudioDriver Dummy`
  (Linux) — wynik w `SESSION_LOG.md`, wpis PKG-0242. Nie jest to profil Windows/WASAPI.
- Nadal: brak PRODUCT GO, D-168 blokuje eksport i `.exe`; dialogi tylko PL (R-058);
  brak testow z ludzmi, fizycznego pada, audio i DPI (R-060).

**Ponizszy zapis PKG-0241 to historia.**

## Aktualizacja nadrzedna — 2026-09-22 / PKG-0241

Stan po audycie grafiki, animacji i UX na bazie main `71d937329385368e718b947b43f84fed00324d57`.
Kod/PNG opublikowano na `fix/art-ux-audit-0241`; stan po usunieciu jednorazowych narzedzi publikacji:
`d9f5fb91a3ed6ff2669043d29f1c1115683aac62`. Raport i dalsze commity dokumentacji nie zmieniaja wyniku kodu.
Nowa bramka: **51/51 PASS**. Diagnostyczny zestaw Linux/Dummy: **83/128 PASS**,
wobec **61/127 PASS** bazy + jawny bool. W 127 wspolnych testach: 21 FAIL→PASS,
zero PASS→FAIL. To nie jest pelny wynik PowerShell verify.ps1 ani PRODUCT GO.

Dowody: 22 aktywne sceny, 88 kadrów przed i 88 po, 741 pomiarów literalnego tekstu;
[raport](audits/PKG_0241_REPORT.md) zawiera wynik Windows, ograniczenia i otwarte bledy.
[Plan](audits/PKG_0241_IMPLEMENTATION_PLAN.md): W1–W4 wdrozone, W5 z otwarta bramka calosciowa.
Nastepny pakiet: R1/R2 — rozliczyc stare smoke/narracje 17/18/A/B/C/43 i historyczne dowody,
bez wycinania asercji. Pozniej R3 ciaglosc grafiki i R4 fizyczny pad/DPI/audio/benchmark Windows.
Nie wykonano merge do main, auto-merge, wydania ani eksportu EXE. D-168 nadal blokuje release.

**Ponizszy zapis PKG-0238 to historia. Nie zastepuje swiezych wynikow PKG-0241.**


Stan na: 2026-09-16, PKG-0238 / mosty dialogowe (Pakiet E planu 2026-09-15, DOMKNIĘCIE PLANU).
WDROZONY KODOWO: Pakiet E ze świeżego planu
`docs/narrative/SENS_FABULARNY_PLAN_NAPRAWY_2026-09-15.md` (decyzja D-250).
Raport: `docs/rebuild/PKG_0238_DIALOGUE_BRIDGES.md`. Zmiany: E1 (zaudytowana i zabezpieczona
ciągłość przyczynowa wejść i wyjść na całym odcinku 09–18, 9 par zapowiedź-potwierdzenie;
wszystkie linie dialogowe w `creative_scene_lines.gd` <= 115 znaków CRT), E2 (trzy sekundy:
dopisek ołówkiem na marginesie stacji 15 nienaruszony, tajemnica nie wykładana dydaktycznie w kwestiach),
E3 (rezerwy `DIALOGUE_LINES` w 42A/B/C zaudytowane i opisane jako edytorski fallback, pin 0107,
brak anachronizmu wiaty w 42B, `JAKUB (ECHO)` w 42C), rozwiązana dyskrepancja bazowa w stacji 43
(połączenie kontraktów PKG-0230 i PKG-0237 D7). Nowa bramka
`tests/pkg_0238_dialogue_bridges_test.gd` PASS; pin PKG-0207: 129 invokes /
128 scripts / 127 test refs / 127 disk tests; 136. sekcja w `tools/verify.ps1`.

Werdykt: **PLAN NAPRAWY SENSU FABULARNEGO 2026-09-15 (PAKIETY A, C, B, D, E) ZOSTAŁ W PEŁNI UKOŃCZONY**.
Domknięte:
- Pakiet A (PKG-0234): duchy geometrii 09/11/12/13 usunięte z trasy kampanii;
- Pakiet C (PKG-0235): luki P9 oparte na czasownikach P9;
- Pakiet B (PKG-0236): cięcia nie teleporty, wyjście 13 jako HATCH, myśl 10 do UCP;
- Pakiet D (PKG-0237): słowa zarobione (Równia, Wierzbicka dwa tryby, analizator 16, 42B w progu, JAKUB ECHO w 42C, epilog 43 bez kradzieży tonu C);
- Pakiet E (PKG-0238): mosty dialogowe, ciągłość 09–18, 3 sekundy implicit, fallback 42A/B/C.
Otwarte: claim-side liniowy 17/18 (R-053 częściowo), inspekcja obrazu na displayu,
oraz nadrzędna decyzja właściciela (ocena PRODUCT GO).
R-054/R-055/R-056/R-057 ZAMKNIĘTE.

PELNA `tools/verify.ps1`: PASS, exit 0, 136 sekcji; licznik D-217 ZRESETOWANY
(ostatnia pełna PKG-0238). Kontrakty D-168 i D-220..D-250 zachowane; release i nowe
`.exe` nadal BLOCKED BY D-168.

## Aktywna faza

P9: Product Rescue & Hybrid Rebuild. Kolejka CR-A → CR-B → CR-C → CR-D
zamknięta technicznie w całości (PKG-0193/0194/0195/0196); zero rewizja
artystyczna zamknięta wycinkiem 2 (PKG-0198) plus domknięta ocznie
(PKG-0201: 19/19 HOLD, zero napraw); pilot ekstrakcji rendererów MRP
zamknięty (PKG-0199); drugi wycinek ekstrakcji (slice2) zamknięty
(PKG-0200, rendery 203/203); skale tekstu dobadane ocznie w pełnej
rozdzielczości dla całego zestawu 0198 (PKG-0202: 08/11/14/43, 4/4 HOLD;
PKG-0203: pozostałe 16 adresów, 16/16 HOLD, zero napraw); checkpoint pełnej
weryfikacji PKG-0204 potwierdził 107/107 GREEN bez modyfikacji kodu;
decyzja prop_type station_18 zamknięta HOLD (PKG-0205, D-220);
inwentaryzacja interakcji/audio MRP zamknięta HOLD logiki (PKG-0206, D-221);
spis bramek i pin fundamentów zamknięty (PKG-0207, D-222); pin selektora
kampanii i defaultów prezentacji zamknięty (PKG-0208, D-223); pełna
recertyfikacja po czterech pakietach zakresowych zamknięta (PKG-0209,
ścieżka D, bez nowej decyzji); wdrożenie planu naprawczego audytu architektonicznego
Aurelius zamknięte (PKG-0210, D-224); spis i pin silnika ProceduralAudio
zamknięte (PKG-0211, D-225); spis stacji na dysku skrypty ↔ sceny 1:1
zamknięty (PKG-0212, D-226); kompleksowy audyt 360 i plan wdrożenia
zamknięty (PKG-0213, ścieżka D, bez nowej decyzji); pin własności progów
i otwartych wyjść M1+M2 zamknięty (PKG-0214, D-227); luki 1:1 z głosem
i priorytet interact M6+M4 zamknięte (PKG-0215, D-228, pełna verify);
słownik metody + lint treści + palimpsest Tak/Jadę N1+N3+N6-część zamknięte
(PKG-0216, D-229, zakresowa); synteza 13 z trzecim głosem + prognozy
`brak danych` + dyferencjacja urządzeń + bezosobowa Wierzbicka N2+N5+N7-część
zamknięte (PKG-0217, D-230, zakresowa); fartuch 22/22 + paleta 09 na
VectorStageStyle + linie 09 ≥ 2 px z MAX 8 (V1+V2+V5) zamknięte
(PKG-0218, D-231, zakresowa); sufit 09 z prześwitem 37 px + światło
robocze/wypełnienie/cień 01 + reguła akcentu Marty (V4+V6+V10) zamknięte
(PKG-0219, D-232, zakresowa); petle, duck, busy i drain zamkniete
(PKG-0220, D-233, pelna verify); drabina z intencja w strefie, koniec
jump-off, Return jako drugi Threshold i skale 02/15/16 zamkniete
 (PKG-0221, D-234, pelna verify); korekta z kosztem + budżety 15/18 ≤3
 + select bez auto-domykania + oznaczenia 01/18 zamknięte
  (PKG-0222, D-235, zakresowa); głosy, tempo, polszczyzna i margines K4
   zamknięte (PKG-0223, D-236, zakresowa); rigi vendor/neighbour + jakub
   seated + profile Geometry 06/08 + lint apertur zamknięte
   (PKG-0224, D-237, zakresowa); winiety VIG-01..04 + FINALE (placement,
   skip, zero podpisów, stany 43) + nośniki finałowe K1/K2/K3/K5/K6
   zamknięte (PKG-0225, D-238, zakresowa).
Nie jest to PRODUCT GO. GATE-REL, release i nowe .exe pozostają
BLOCKED BY D-168. Godot 4.7.2 / Windows, 640×360, 60 Hz; projekt bez
Gita, wyłącznie gra Godot.

Plan naprawy sensu fabularnego (A, C, B, D, E) ze świeżego planu
`docs/narrative/SENS_FABULARNY_PLAN_NAPRAWY_2026-09-15.md` został w pełni ukończony:
A (PKG-0234, DONE) → C (PKG-0235, DONE) → B (PKG-0236, DONE) → D (PKG-0237, DONE) → E (PKG-0238, DONE).
Kolejna sesja: ocena PRODUCT GO / dyspozycja właściciela (drzewo review-ready, freeze D-241 ponownie obowiązuje).
Nie rozszerzać zakresu na web, legacy 19–41, MRP extraction, release ani nowe `.exe`.
Fakt `station_18 MartaTruthTable prop_type` jest ZAMKNIĘTY decyzją D-220 (HOLD na PHOTOGRAPH);
rewizja tylko nowym pakietem z kadrami przed/po. Ogląd skal 85/115 dla
wycinka 2 jest domknięty i nie wymaga kontynuacji; granice 0.85/1.15 są
ZAPINOWANE (D-223). Rejestr bramek jest ZAPINOWANY (PKG-0207/0210/0211/0212/0214/0215/0216/0217/0218/0219/0220/0221/0222/0223/0224/0225/0226/0227/0230/0232/0233/0234/0235/0236/0237/0238:
127 testów, 129 wywołań; fundamenty 640×360, 60 Hz, 10 akcji). Selektor
kampanii jest ZAPINOWANY (PKG-0208: ROUTE 18 / LEGACY 23 / FINALES 3 /
SELECTOR 20 / OPMAP A-B-C). Dług F-0184-010 jest ZAPINOWANY (rendery
203/203 + inwentaryzacja 182+else / 183+20 + SWITCH_LIKE 6 + runtime
0/1/48). Silnik ProceduralAudio jest ZAPINOWANY (PKG-0211, D-225:
265 funkcji statycznych, 256 create_*, 16-bit PCM 44.1kHz mono, pętle, cache, drain).
Spis stacji jest ZAPINOWANY (PKG-0212, D-226: 45 skryptów ↔ 45 scen 1:1,
3 helpery, pokrycie trasa 18 / legacy 23 / finały 3 / epilog 43).
Słownik metody jest ZAPINOWANY (PKG-0216, D-229: `Zakotwiczenie` jedyną nazwą
metody; `Utrzymanie ruchu` zachowane jako ekipa obiektu; lint treści
prezentowanej z dowodem fail-closed; palimpsest 42B `Jadę/Tak`).
Synteza, prognozy i głos Wierzbickiej są ZAPINOWANE (PKG-0217, D-230:
trzeci głos Jakuba przez łącze bez sugestii próby; granted 3× `brak danych`;
rejestry urządzeń rejestr/analizator/notatka; strona bezosobowa).
Fartuch, paleta 09 i linie 09 są ZAPINOWANE (PKG-0218, D-231: fartuch
22/22 scen 01–18/42/43; 09 zero hexów na VectorStageStyle; MAX 8;
zero stroke 1.0 w 09; sąsiedzi 08 ×1 detal / 10 ×4 / 13 ×0).
Sufit 09, światło 01 i reguła różu są ZAPINOWANE (PKG-0219, D-232: podbitka
09 ze spodem 172, prześwit 37 px; 01 work light + cold fill + cień bębna
0.48 w prawo; audyt 12/14 stoi; Marta w kadrze → 1 akcent → reszta
w shade(MID_PLANE); mono 09 vs 01/11/12/15 na 3 osiach).
Pętle, duck, busy i drain są ZAPINOWANE (PKG-0220, D-233: 7 ambientów
na generate_looping_wav z crossfade 80 ms; duck hum/sub/unease;
busy Ambient/Dialogue; back-buffer stopped-spare; drain helperem).
Drabina, powrót i skale są ZAPINOWANE (PKG-0221, D-234: intencja
w strefie + koniec jump-off; Return jako drugi Threshold z targetem
poprzednika; GATE-SCALE 0 naruszeń na 02/15/16; zero podpięć
return-body_entered w 45 skryptach; strefy nie konsumują interactu).
Pełny samodzielny handoff: `docs/NEXT_SESSION_PROMPT.md`.

### Wynik PKG-0238

- Mosty dialogowe / Pakiet E (decyzja D-250, raport `docs/rebuild/PKG_0238_DIALOGUE_BRIDGES.md`):
  - E1: Zaudytowana i zabezpieczona ciągłość przyczynowa wejść i wyjść na całym odcinku 09–18 (9 par zapowiedź-potwierdzenie):
    * 09->10: „Zapytam Martę” -> Marta wyciera blat;
    * 10->11: „zapis sprawdzę w UCP” -> lada UCP i Wierzbicka;
    * 11->12: „kontakt do warsztatu” -> łącze warsztatowe;
    * 12->13: „Wracam do mieszkania, do wspólnego stołu” -> stół i Marta odsuwająca filiżanki;
    * 13->14: „Wyciąg wskazuje sekcję rozdzielni — zejdę włazem serwisowym” -> właz za klatką w 14;
    * 14->15: „Z mostu do pętli — wyciąg mówi, gdzie szukać echa” -> zejście do pętli w 15;
    * 15->16: „Niosę odpowiedź do analizatora poza obwodem” -> wejście do analizatora w 16;
    * 16->17: „sprawdzę rejestr par w hali UCP” -> wejście do rejestru par w 17;
    * 17->18: „Wracam na ulicę — trzy drogi, Marta” -> wejście na znaną ulicę w 18.
  - Wszystkie linie kwestii w `creative_scene_lines.gd` sprawdzone pod kątem limitu CRT (długość <= 115 znaków).
  - E2: Trzy sekundy — dopisek w stacji 15 „przepraszam M. — 3 s.” nienaruszony, dialogi nie wykładają tożsamości dydaktycznie.
  - E3: Rezerwy `DIALOGUE_LINES` w 42A, 42B, 42C udokumentowane w komentarzach jako edytorski fallback (pin 0107), wyczyszczone anachronizmy wiaty w 42B, potwierdzone echo Jakuba w 42C.
  - Rozwiązana dyskrepancja bazowa w Station 43: połączenie kontraktu PKG-0230 (słowa „Linia 4” i „odbudowano”) oraz PKG-0237 D7 (brak „dwie kolejności”, długość <= 115 znaków).
  - Nowa bramka `tests/pkg_0238_dialogue_bridges_test.gd` PASS (136. sekcja w `tools/verify.ps1`).
  - Pin PKG-0207 zaktualizowany: 129 invokes / 128 scripts / 127 test refs / 127 disk tests.

### Wynik PKG-0237

- Słowa, które muszą być zarobione / Pakiet D (decyzja D-249, raport
  `docs/rebuild/PKG_0237_EARNED_WORDS.md`):
  - D1: Słowo „Równia” zarobione w stacji 17 w `cost_ledger_console`
    („Równia. Tym słowem podpisali to miejsce. Moje nie miało nazwy na papierze.”).
  - D2: Wierzbicka w dwóch trybach: urzędniczka za ladą w 11, terminal ofert
    adaptacji w 17 („WIERZBICKA / ZAKRES // OFERTA ADAPTACJI”) z rozpoznaniem
    głosu przez Lenę („Głos z lady. Bez kosztu? Bez cudzej pamięci w mojej głowie?”).
  - D3: Analizator w stacji 16 nazwany w świecie szyldem diegetycznym
    („POMIESZCZENIE POMIARU / POZA OBWODEM // ANALIZATOR”) i adresem w nagłówku.
  - D4: Finał B w progu mieszkania 14 z czytnikiem w torbie; usunięty
    anachronizm wiaty ze stacji 42B i wariantów `household_b_*`.
  - D5: Przeciek Jakuba w 42C i memory_leak to echo / czytnik: „JAKUB (ECHO)”.
  - D6: W 42A/B/C gracz steruje przybyłą Leną w progu/przy stole; ciało w kadrze.
  - D7: Epilog 43 w gałęzi domyślnej unseeded bez kradzieży tonu C („dwie kolejności”);
    jawny stan bez metody i otwarta luka („Brak metody. Odcinki nie zostały powiązane.”);
    tag = „Brak metody. ”.
  - Nowa bramka `tests/pkg_0237_earned_words_test.gd` PASS (7 kryteriów).
  - Pin 0207: 127/126/125/125 → 128/127/126/126; 135. sekcja w `verify.ps1`.
  - Wszystkie piny nadrzędne zachowane: 0107, 0216, 0217, 0226, 0233, 0234, 0235, 0236.
  - PELNA `verify.ps1` PASS (exit 0, 135 sekcji); licznik D-217 ZRESETOWANY.
  - Otwarte: Pakiet E (mosty dialogowe); PRODUCT GO.

### Wynik PKG-0236


- Ciecia, nie teleporty / Pakiet B (decyzja D-248, raport
  `docs/rebuild/PKG_0236_CUTS_NOT_TELEPORTS.md`; to NIE jest Pakiet B z
  wyczerpanego planu PKG-0231):
  - B1: Kazde wyjscie w prawo na odcinku 10–18 da sie powiedziec zdaniem o
    swiecie. Spawn i rodzina progu zgadzaja sie z tym zdaniem.
  - B2: Kod routingu: `arrival_side_for` w `GameStateManager`: 12->13
    (powrot do domu) i 17->18 (powrot na ulice) z prawej; reszta odcinka
    10-18 z lewej. Brak zbednych wyjatkow.
  - B3: Binder: `ThresholdBinder.spec_for("station_13")` jako
    `ThresholdZone.Family.HATCH` (64x64, door="") jak 14/15 („schodze wlazem”).
    09 i 10 zostaja DOOR (pokoj -> pokoj). Kontrolowana aktualizacja bramki
    0214.
  - B4: Zdanie mostu w 10: `s10_exit_ucp_record` podmienione na: „Marta twierdzi,
    ze pracuje w UCP. Zostawiam jej telefon i wychodze — zapis sprawdze w UCP,
    zanim uznam to za moje.” Nazywa wyjscie z domu i zostawienie telefonu;
    hipoteza 0233 zachowana.
  - Nowa bramka `tests/pkg_0236_cuts_not_teleports_test.gd` PASS (7 kryteriow).
  - Sasiedzi: 0214, 0221, 0234, 0235, 0207.
  - Pin 0207: 126/125/124/124 → 127/126/125/125; 134. sekcja w `verify.ps1`.
  - PELNA `verify.ps1` PASS (exit 0, 134 sekcje; dowod
    `reports/pkg_0236_verify_full.log`); licznik D-217 ZRESETOWANY.
  - Otwarte: Pakiet D (slowa), E; claim-side 17/18; PRODUCT GO.

### Wynik PKG-0235

- Luki P9 / Pakiet C (decyzja D-247, raport
  `docs/rebuild/PKG_0235_GAP_VERBS.md`; to NIE jest Pakiet C z
  wyczerpanego planu PKG-0231):
  - C1: flagi `is_private_boundary_respected` (09, po
    `respect_private_boundary`), `is_marta_boundary_accepted` (10, po
    `accept_marta_boundary`), `is_minimal_report_requested` (11, po
    `request_minimal_report`), `is_signal_confirmed` (15, zmienna juz
    istniala). Mysl 09 o dwoch zyciach / fotografii / sypialni.
    close_fact P9 nietkniety.
  - C2: override `station_11|passage_required` usuniety;
    `key_wear_required` / `key_trial_required` w NON_GAP (nie jedyna
    droga s10). Piny 0233 NON_GAP stoja.
  - Twardy fakt: P7-proba klucza zamykala luke stolu — naprawione.
    `is_exit_unlocked` nie moze byc flaga luki (D-227).
  - Nowa bramka `tests/pkg_0235_gap_verbs_test.gd` PASS (7 kryteriow,
    TDD RED→GREEN).
  - Sasiedzi: 0215, 0233, 0234, 0207.
  - Pin 0207: 125/124/123 → 126/125/124/124; 133. sekcja w `verify.ps1`.
  - PELNA `verify.ps1` PASS (exit 0, 133 sekcji; dowod
    `reports/pkg_0235_verify_full.log`); licznik D-217 ZRESETOWANY.
  - Otwarte: Pakiet B (ciecia), D, E; claim-side 17/18; PRODUCT GO.

### Wynik PKG-0234

- Duchy w pokojach / Pakiet A (decyzja D-246, raport
  `docs/rebuild/PKG_0234_GHOST_PROPS.md`; to NIE jest Pakiet A z
  wyczerpanego planu PKG-0231):
  - A1: `Geometry/StairwellPlanter` na (430, 287), layer 0 / mask 1,
    `object_name = "Doniczka na komodzie"`; `StairFlight` polygon
    disabled (cialo klatki 52 px w salonie, wezel pinuje 0219);
    auto-push zdjety; próg po `respect_private_boundary()`.
  - A2: `Geometry/HallwaySideboard` na (500, 287), layer 0 / mask 1;
    komentarz 0192 `ZOSTAJE jako` zachowany; Wierzbicka zostaje;
    wyjscie po `request_minimal_report()`.
  - A3: binder `spec_for("station_12")` `door: ""`, rodzina DOOR 48×112;
    `BalconyDoor` na (72, 140), collider disabled, animacja 72→156 dla
    0099; drzwi serwisowe w `_draw` (536, 184, 54×112).
  - A4: `DeskDrawer` collider zawsze disabled; synteza bez
    `is_drawer_open` (`marta_source → institution_source → synthesize`).
  - Preferencja A: wezly zostaja, zdejmowane z trasy. Kampania nie zalezy
    od `is_passage_clear` ani balkonu-progu.
  - Nowa bramka `tests/pkg_0234_ghost_props_test.gd` PASS (7 kryteriow,
    w tym chód do x>=540).
  - Sasiedzi: 0192, 0099, 0100, 0119, 0135, 0146, 0214, 0218, 0219, 0221,
    0233, 0207.
  - Pin 0207: 124/123/122 → 125/124/123/123; 132. sekcja w `verify.ps1`.
  - Kadry 09/11/12/13: 8 PNG s100 full/notext,
    `reports/pkg_0234/visual/`; inspekcja HOLD obrazu.
  - PELNA `verify.ps1` PASS (exit 0, 132 sekcji; dowod
    `reports/pkg_0234_verify_full.log`); licznik D-217 ZRESETOWANY.
  - Baseline sprzed kodu: docs FAIL (prompt 0234 bez ASCII
    `SRODOWISKO I BASELINE` i `KONIEC PAKIETU JEST OBOWIAZKOWY`) —
    odnotowany przed edycjami, aliasy ASCII w tym pakiecie. Pierwszy
    pelny przebieg FAIL w 0208 (brak literalu `PKG-0209` w promptcie);
    drugi pelny PASS.
  - Twarde fakty: `draw_play_plane` maluje tylko StaticBody2D
    RectangleShape2D; wylaczenie collidera na MovableAnchorableProp bez
    zmiany warstwy spada przez podloge (grawitacja) — layer 0 + mask 1.
  - Otwarte: Pakiet C (luki), B (ciecia), D, E; claim-side 17/18;
    PRODUCT GO.

### Wynik PKG-0233

- Mosty sensu (decyzja D-245, raport
  `docs/rebuild/PKG_0233_SENSE_BRIDGES.md`):
  - B1: mysl 10 hipoteza (beat s10_exit_ucp_record, id nietkniete, pin 0230).
  - B2: zaswiadczenie m. 12 ze zrodlem w torbie 01 (obie drogi, nowy
    FACT_CERTIFICATE w 01 + beat + rysunek); ciaglosc 07→13 istniejaca.
  - B3: warunkowe pokwitowanie czytnika w 11 (FACT_CUSTODY w akcie wyciagu,
    beat + kwit na ladzie); pamiec w 12 (beat + stół) i w 13 (kwit).
  - B4: korelat dwoch urzadzen w 13 (beat przy drugim zrodle + identyczne
    wyciecia w `_draw`); linia kanoniczna nietknieta (pin 0217).
  - C1: beat wyjscia 13 (mieszkanie + sekcja + wlaz, bez wiedzy z 15);
    cue_2 14 o wlazie (20:40 nietkniete, pin 0230; arrival left).
  - C2/C3: cue_2 42A/B/C (noc przy slupku → swit + przybyla Lena;
    42B w progu); DIALOGUE_LINES 4/4/4 nietkniete (pin 0107).
  - D2: atomowy snapshot (6 kluczy + evidence[4], 1 zapis, literal inline —
    pin 0226 stoi) + locki snapshot/execution (NON_GAP — pin 0215 stoi).
  - D5: `cost` w slowniku skutku 42 + znaczki zgody/kosztu na blacie;
    linia wyplaty 43[2] (tag rodziny + prawda + zgoda + koszt, ≤115)
    + znaczki na slupkach (indeksy 0/1/3 nietkniete — pin 0170).
  - Nowa bramka `tests/pkg_0233_story_sense_bridges_test.gd` PASS (10
    kryteriow: macierz 54 lancuchow 42 + 144 linie epilogu + pin-compat).
  - Kontrolowane: realny FAIL 0195 (linia 43B[2] → znacznik rodziny
    „Marta: drugie zgłoszenie."); blad String==bool w `_draw` 13
    (pokwitowanie Stringiem → `_has`) naprawiony przed zielenia.
  - Pin 0207: 124/123/122/122; 131. sekcja w `verify.ps1`.
  - PELNA `verify.ps1` PASS (exit 0; dowod
    `reports/pkg_0233_verify_full.log`); licznik D-217 ZRESETOWANY.
  - Twardy fakt: `_decision_bool` nie znosi wartosci String (Godot 4.7
    rzuca SCRIPT ERROR na String == bool) — fakty Stringowe czytac `_has`.
  - Otwarte: claim-side 17/18 (R-053 czesciowo), kadry displayem, PRODUCT GO.
  - R-057 ZAMKNIETE.

### Wynik PKG-0232

- Lancuch przyczynowy (decyzja D-244, raport
  `docs/rebuild/PKG_0232_CAUSAL_CHAIN.md`):
  - A: polityka REQUIRED/OPTIONAL/LOCAL; `_repeat_navigate` (S-07);
    restore stanu w `_ready` 18/42A/B/C/43; progi liniowe otwarte (D-227).
  - D1: 18 bez metody nie commituje progu (jawne wejscia testowe/selektora
    bez zmian); refused blokuje 3 drogi (D-242 stoi).
  - D3: 42A/B/C odrzucaja stan przed wykonaniem i skutek przed stanem
    (nazwane luki); prog 43 dopiero po pelnym lancuchu (lokalnie lub
    w decyzjach); prezentacja gra na swiezej instancji bez ponownego
    zapisu (winieta 0195 raz, bez replayu).
  - D4: 43 wymaga tablicy + napisow + 5 linii (`dialogue_index >= 4`);
    blackout i `_complete_campaign` odmawiaja bez zapisu przed wymaganiami.
  - S-02 twarda: otwarcie 14 bez zewnetrznego przerwania (20:40 zachowane
    dla pinu 0230); beat 13 i most 13→14 odroczone.
  - Nowa bramka `tests/pkg_0232_causal_chain_test.gd` PASS (8 kryteriow
    promptu, w tym macierz przod→powrot→przod na prawdziwych tranzycjach).
  - Kontrolowane aktualizacje po realnych FAIL-ach: 0166 (odmowa nie
    domyka), 0167/0168/0169 (niepelna proba nie domyka), 0137 (warunek 43),
    0175 (bieg minimalny REQUIRED-verbs), 0177 (M1: nogi 14–17 czasownikami,
    commit dwustopniowy, lancuchy 42/43). Kod 42 bez zmian w testach 0195
    (prezentacja-vs-fakty).
  - Pin 0207: 123/122/121/121; 130. sekcja w `verify.ps1`.
  - PELNA `verify.ps1` PASS (exit 0; dowod
    `reports/pkg_0232_verify_full.log`); licznik D-217 ZRESETOWANY.
  - Twarde fakty: fizyczny sweep M1 nie wykonywal mechanik 14–17; commit
    wymaga snapa ±40 px; pressy gina w kontencji z prezentacja (flush);
    przybycie 17→18 z prawej; `String(null)` abortuje noge.
  - Otwarte: claim-side 17/18, most 13→14, UCP-10, zaswiadczenie, czytnik,
    fokalizacja 42B, D2/D5 (R-053/R-057 czesciowo).
  - Rozjazd baseline: pelna sprzed pakietu FAILowala wylacznie w 0208
    (NEXT bez literalu PKG-0209 — dryf PKG-0231, nie regresja); odnotowany
    przed edycjami, naprawiony handoffem.

### Wynik PKG-0231

- Swiezy audyt sensu fabularnego (decyzja D-243, docs-only):
  raport `docs/rebuild/PKG_0231_FRESH_STORY_SENSE_AUDIT.md` + plan
  `docs/rebuild/PKG_0231_STORY_SENSE_REPAIR_PLAN.md`; werdykt STORY-SENSE
  CONCERNS; ryzyka R-053..R-057. Kod/sceny nietkniete w tamtym pakiecie.

### Wynik PKG-0230

- Naprawa sensu fabularnego (dyspozycja wlasciciela, decyzja D-242,
  raport `docs/rebuild/PKG_0230_STORY_SENSE_REPAIR.md`):
  - P0-4: epilog unseeded bez sprzecznosci Linii 4 (status, nie istnienie).
  - P0-3 WYKRESLONY: S-04 obalony bramka 0214 (22/22 wyjsc przy zero
    odczytach; otwieracz GSM→ensure_exit_open, D-227).
  - P0-1: zgoda blokuje metode (odmowa = 3 drogi zamkniete, luka s17,
    renegocjacja w 17); fallbacki 42A/B/C usuniete.
  - P0-2: wskazanie vs zatwierdzenie, strefa +-40, oznaczenia nad panelem.
  - P1-1+P1-4: zdania wejscia 14-18 + zdania wyjscia (beaty L3).
  - P1-3: rigi 18/42A, lacze 17 + JAKUB (LACZE), begins_with w prezentacji.
  - P1-2: druga kwestia cue w 13. P2-1: arrival_side_for + HATCH (MAPA).
  - P2-2: (a)(c)(e) tak, (b)(d)(f) odroczone. P2-3: naglowki live,
    renames 11/13, notka FULL_STORY. P2-4: beat s11_night_desk.
  - Test rozstrzygajacy: 18/18 adresow z tresci gry (raport, nie odbior).
  - PELNA `verify.ps1` PASS (exit 0, 129 sekcji; dowod
    `reports/pkg_0230_verify_full.log`); licznik D-217 ZRESETOWANY.
  - Twarde fakty: pelna lapala 0099 (koszt porażki) i 0137 (legendy na
    panelu) jako realne regresje; 0194 padal wyscigiem harnessa
    (auto-transition off, wzor 0166); kontrolowane aktualizacje
    0166/smoke/0194 po realnych FAIL-ach. 0151 PASS bez warningu.
  - Pin 0207: 122/121/120; brak nowej decyzji poza D-242.
  - Otwarte: inspekcja obrazu na displayu; renegocjacja vs 4. metoda (P0-1).

### Wynik PKG-0229

- Pakiet oceny PRODUCT GO (dyspozycja wlasciciela "GO review", sciezka D,
  docs-only, bez nowej decyzji):
  - Raport `docs/rebuild/PKG_0229_GO_REVIEW_EVIDENCE.md`: 14/14 bramek
    TECHNICAL PASS ze swiezymi dowodami z pelnej 0228 (FIN i CAST wzmocnione
    pakietami R8/R7 wzgledem CHECKPOINT-06); pola [ ] GO / CONCERNS / FAIL
    per bramka + calosciowe PRODUCT GO do wypelnienia przez wlasciciela.
  - Otwarte punkty do swiadomej akceptacji: 440/480, flake-watch 0151,
    kadry recertow bez displaya, brak dowodow odbiorczych z zasady.
  - GATE-REL nadal BLOCKED BY D-168; pin 0207 bez zmian (121/120/119).
  - Zakresowa `verify_scoped.ps1` PASS (exit 0; docs-only, blast poza
    monolitami); licznik D-217: 1. zakresowa po pelnej PKG-0228.

### Wynik PKG-0228

- Pelna recertyfikacja R10 (decyzja D-241, sciezka D, zero zmian tresci):
  - PELNA `tools/verify.ps1` PASS (exit 0, 128 sekcji: DOCS PASS 52 + smoke
    01-43 + wszystkie bramki 0001-0227; log bez FAIL/ERROR/wyciekow; dowod
    `reports/pkg_0228_verify_full.log`); licznik D-217 ZRESETOWANY
    (ostatnia pelna PKG-0228).
  - Twardy fakt sesji: pierwszy przebieg pelnej oblal bramke 0151 wylacznie
    ostrzezeniem teardown "2 ObjectDB leaked at exit" PO jej wlasnym 100%
    PASS; 3 izolowane re-runy 0151 czyste, drugi pelny przebieg PASS,
    log PKG-0226 zero wyciekow. Flake teardown, nie regresja (blast 0227
    nie zawiera przyczyny). Zero zmian kodu i progow; regula flake-watch
    w D-241 (ten sam warning w 2 pelnych z rzedu = pakiet diagnostyczny).
  - Raport luk: pokrycie luk recertyfikowane bramka 0215 w przebiegu
    (54 mapowania FEEDBACK_TO_GAP + override + 9 tla + flagi s09-s14).
  - Kadry: brak swiezych (sandbox bez displaya: proba capture normalnym
    sterownikiem — 300 s hang bez outputu, reports/ nietkniete 139 PNG;
    klaryfikacja D-241: recert bez zmian wizualnych cytuje stojace dowody
    oczne 0187/0190/0201-0203 + bramki kamer 0130/0141/0142 z przebiegu).
  - Plan PKG-0213 R0-R10 WYCZERPANY. MAINTAIN FREEZE (D-241): ekstrakcja
    MRP w kolejce za dyspozycja; kolizja 440/480 OTWARTA z gotowa specyfika
    (elderly -> 392 G4); K8-K15 tylko na zlecenie; release BLOCKED BY D-168.
  - Pin 0207 bez zmian (121/120/119); brak nowej bramki (sciezka D).

### Wynik PKG-0227

- Higiena i narzedzia R9 (decyzja D-240, narzedzia + testy + pin, zakresowa):
  - T3: dopiska o backticku w `verify.ps1` (definicja nie jest wywolaniem;
    komentarz nie zawiera liczonego wzorca).
  - T4: lint reentrancji setterow fail-closed (5 plikow D-224 + skan
    `scripts/`; baseline zero naruszen; dowod wstrzyknieciem + 1x FAIL
    na brakujace wpisy INDEX przed ich dopisaniem).
  - T5: centralny pin `scripts/environment/physics_layers.gd` (1/2/3/4;
    THRESHOLD/LADDER/RETURN/OPENING 0/1, 0/1, 1/1, 0/1); 4 strefy przepiete
    z literalow na consty (wartosci identyczne, zero zmiany zachowania).
  - V9: kamery = CinematicCamera + StationCameraRig (2 skrypty, NODE_NAME
    Camera, jedno extends Camera2D) + zero draw_string w levels/*.gd;
    VSE ZOSTAJE (spis: 01-08 brak, 09-16 inert, 17-43 zywy).
  - V11: capture_act1/act2/act2b/act2c do `tools/retired/` + lista prawd
    w `docs/INDEX.md` (preview + 0187 + 0190 + capture_pkg_02*).
  - A5/K26/K28: dev-raport 5 osi audio (statyczny; kolizja Marta 440 vs
    elderly 480 otwarta) + Audio-Browser tylko `--allow-audio-browser`
    (256 generatorow = spis D-225; izolacja pinowana).
  - Nowa bramka `tests/pkg_0227_hygiene_tools_pin_test.gd` PASS (3x);
    pin 0207: 121/120/119; 128. sekcja w `tools/verify.ps1`.
  - Import `--headless --editor --quit`: `project.godot` IDENTYCZNY.
  - Zakresowa `verify_scoped.ps1` PASS (exit 0; docs + smoke + 7 bramek:
    0227/0207/0210/0214/0221/traversal_lint/smoke);
    licznik D-217: 1. zakresowa po pelnej PKG-0226 (limit: pelna
    najpozniej w PKG-0231).
  - Raport: `docs/rebuild/PKG_0227_HYGIENE_TOOLS.md`; decyzja D-240
    w `docs/DECISION_LOG.md`.
  - Kadry: brak (zero zmian wizualnych).

### Wynik PKG-0226

- Truth-payoff + stół 6 rzeczy (decyzja D-239, dane prezentacyjne + stacje
  lokalne 18/42a/42b/42c, pełna):
  - 9 otwarć household (3 rodziny × 3 truth_state) o parami różnych hashach;
    9 dopisanych par wypłaty (42A drugie zgłoszenie, 42B czytnik w torbie,
    42C półka); tailsy świata i otwarcia nietknięte (pinują je 0194/0195).
  - Stół 6 rzeczy w method_commit_post (FULL_STORY §39): 2 pary aktu + 6 par
    przeglądu z istniejących decyzji (brak to luka); const LINES niemutowany.
  - Obraz: 6 kresek stołu w 18 + pierścienie prawdy na blatach 42A/B/C
    (r8/w2.5: pełny/połowa/przerwa); zero nowych faktów/flag/assetów.
  - Twarde fakty: sąsiedzi PASS bez churnu (append-only); łuk r5/w1.5 ginie
    w kompozytorze 2x2 (też łuk haka K1); kadr (570,262) na geometrii drzwi
    → blat (490,262).
  - Nowa bramka `tests/pkg_0226_truth_payoff_table_pin_test.gd` PASS (3×);
    pin 0207: 120/119/118; 127. sekcja w `tools/verify.ps1`.
  - Kadry 18/42a/42b/42c 24 PNG s100 full/notext/read pre+post
    (`reports/pkg_0226/visual/`); inspekcja HOLD + czytelne znaczniki.
  - Raport: `docs/rebuild/PKG_0226_TRUTH_PAYOFF_TABLE.md`; decyzja D-239
    w `docs/DECISION_LOG.md`.
  - PEŁNA `verify.ps1` PASS (exit 0, dowód
    `reports/pkg_0226_verify_full.log`); licznik D-217 ZRESETOWANY
    (ostatnia pełna PKG-0226).

### Wynik PKG-0225

- Winiety i finały (decyzja D-238, stacje lokalne 05/18/42a/42b/42c, zakresowa):
  - V-rozszerzenie pinu 0190: katalog dokładnie 7 (08/13/15/18/42a/42b/42c;
    brak winiety dla mechaniki 14, brak duplikacji cold openu); zero podpisów
    7/7 (D-214); skip interact/ui_accept od startu + runtime skip vig_commit;
    stany 43 (3 gałęzie × 5 linii, konkretna czynność, brak narratora/tez).
  - N-nośniki bez nowych assetów/faktów/sygnałów: K1 kurtka (42A odwrócona,
    42B pusty hak, 42C + mydło); K2 kubek 18 per truth_state; K3 hełm w 42C
    (37-legacy nietknięta); K5 koszula w 42B/42C; K6 płyta UCP 28×14
    z odpryskiem w 05/18 + cykl 18 −1 klatka; 7 beatów L1-factual bez tez.
  - Twardy fakt: bramka złapała brak znacznika K5 realnym FAIL-em.
  - Nowa bramka `tests/pkg_0225_vignettes_finales_pin_test.gd` PASS (3×);
    pin 0207: 119/118/117; 126. sekcja w `tools/verify.ps1`.
  - Kadry 05/18/42a/42b/42c 10 PNG s100 full/notext pre+post
    (`reports/pkg_0225/visual/`); inspekcja HOLD obrazu, zero napraw.
  - Raport: `docs/rebuild/PKG_0225_VIGNETTES_FINALES.md`; decyzja D-238
    w `docs/DECISION_LOG.md`.
  - Zakresowa `verify_scoped.ps1` PASS (exit 0; docs + smoke + 8 bramek:
    0225/0207/0190/0195/0107/0158/0215/traversal_lint);
    licznik D-217: 4. zakresowa po pełnej PKG-0221 (PEŁNA obowiązkowo
    w PKG-0226).

### Wynik PKG-0224

- Rigi i geometria (decyzja D-237, asset + narzędzie + testy, zakresowa):
  - V7-naprawa: `jakub/seated.png` przebudowany pipeline'em CAST (NEAREST,
    64x104, seated_h 58) ze źródła `raw/pkg_0172_backup/seated.png`; był
    stojący dubel 89 px, jest 58 px (pasmo 56-60); `seated` dopisany do
    CHARS jakuba w `tools/process_cast_sprites.py` z adnotacją o źródle.
  - V7-wyjątki jawne: vendor bez turn_away/seated/work/gesture, neighbour
    bez turn_away/seated/work (brak surowców raw 0186, brak generacji;
    rig renderuje piksele idle; station_06/08 wołają tylko talk/listen/idle).
  - V3-profile: 06 miejska vs 08 mieszkalna nieidentyczne na 6 pozycjach
    (sufit/schody/drzwi-14/kiosk/open-sky/timetable, próg >= 4).
  - V3-apertura: rysunek ThresholdZone z `aperture_rect` (jedno źródło);
    Binder 06 = DOOR 54x114 bez masy drzwi; 08 = DOOR 45x109, drzwi
    rysowane 45x109; 06 bez drugiej geometrii progu.
  - Twarde fakty: cache `.godot/imported` trzymał stare seated 89 po wymianie
    PNG — reimport `--import`, `project.godot` nietknięty; fallback riga to
    piksele nie nazwa (bramka poprawiona w pakiecie).
  - Nowa bramka `tests/pkg_0224_cast_geometry_pin_test.gd` PASS (3×);
    pin 0207: 118/117/116; 125. sekcja w `tools/verify.ps1`.
  - Kadry 06/08 8 PNG s100 full/notext pre+post (`reports/pkg_0224/visual/`);
    inspekcja HOLD obrazu, zero napraw.
  - Raport: `docs/rebuild/PKG_0224_CAST_GEOMETRY.md`; decyzja D-237
    w `docs/DECISION_LOG.md`.
  - Zakresowa `verify_scoped.ps1` PASS (exit 0; docs + 8 bramek:
    0224/0207/0186/0172/0212/0197/0214/traversal_lint);
    licznik D-217: 3. zakresowa po pełnej PKG-0221 (pełna obowiązkowo
    najpóźniej w PKG-0226).

### Wynik PKG-0223

- Głosy i tempo (decyzja D-236, linie + stacje lokalne 15/17, zakresowa):
  - Tempo N4: `loop_logbook` 15 z 4 par do 2 (kontakt/powtórka/wyjście/
    przyczyna + kotwica 20:40) + pokaz w obrazie (tiki na dzienniku po
    odczycie; łańcuch MRP log/kontrole/uzbrojenie/korekta/notatka nietknięty,
    pin `pkg_0194`).
  - Głosy N7-reszta: urządzenia poza prognozami 18 rozróżnialne treścią bez
    etykiet (pin `pkg_0217` stoi); Wierzbicka bezosobowa w całym zakresie
    (linie + audit read-only `station_40`, zero fraz recepcyjnych).
  - Tempo N9: 09 scalone wokół fotografii (haczyk wskazuje zdjęcie; łańcuch
    two_lives → photo → boundary i budżet M5 nietknięte); 17 odciążone
    projekcją-gestem oferty w stronę biurka (4 pary tekstu nietknięte).
  - Polszczyzna N10: 4 potknięcia naprawione (grep 0 w LINES: `ją` → próbę,
    sensacja → powiązany koszt, mantra ×3 → słupek/klucz/most, goły
    `Para 04/17` → rejestr z obrazem jednej ręki); `Utrzymanie` (D-229)
    nieruszone.
  - Margines N8/K4: beat L1 `s15_local_margin` + ołówkowy ślad w `_draw`
    (bez monologu-ducha).
  - Twardy fakt: zmiana brzmień wyłożyła `pkg_0194` realnym FAIL-em na
    2 asercjach — kontrolowana aktualizacja w tym samym pakiecie (wzór
    PKG-0216), 0194 PASS.
  - Nowa bramka `tests/pkg_0223_voices_tempo_pin_test.gd` PASS (3×);
    pin 0207: 117/116/115; 124. sekcja w `tools/verify.ps1`.
  - Kadry 15/17/18 6 PNG s100 full/notext + klatka logu 15 (tiki) + klatka
    rejected 17 (projekcja zgasła, X) (`reports/pkg_0223/visual/`);
    inspekcja HOLD obrazu, zero napraw.
  - Raport: `docs/rebuild/PKG_0223_VOICES_TEMPO.md`; decyzja D-236
    w `docs/DECISION_LOG.md`.
  - Zakresowa `verify_scoped.ps1` PASS (exit 0; docs + 13 bramek:
    0223/0207/0194/0193/0120/0163/0147/0195/0114/0215/0217/0216/
    traversal_lint); licznik D-217: 2. zakresowa po pełnej PKG-0221.

### Wynik PKG-0222

- Korekta z kosztem + budżety (decyzja D-235, stacje lokalne 14/15/18/01, zakresowa):
  - Korekta M7: 14 puszczony most A→B wypowiada istniejącą linię L2
    `s14_cost_hypothesis` (force) obok istniejącego zapisu/stanu/zaniku;
    15 próba korekty bez protokołu zostawia `has_cost_mark` + nowy
    `FACT_COST` (`yield_cost_observed`) + L2 `s15_living_response` (force) +
    warunkowy welon w `_draw` (przygaszenie 0.18 + czerwony szew); koszt nie
    potwierdza sygnału i nie zamyka drogi.
  - Budżety M5: distinct MRP ≤3 na adres (15 re-pin, 18 nowy pin == 3) +
    ścieżka krytyczna ≤3 czasowniki (15: potwierdzenie doręcza notatkę tym
    samym zapisem, jawny odczyt idempotentny; 18: donor out); łańcuch MRP 15
    (4 fazy) nietknięty (pin `pkg_0194`).
  - Rodziny M10: `select_operation` 18 wyłącznie routingiem GSM (D-223 intact);
    brak inwentarza → istniejący feedback `forecast_and_consent_inventory_required`
    (mapa `s18.method_uncommitted`, GapLedger nietknięty); 01/18 z constem
    `IS_PHYSICAL_OBSTACLE_FREE`; KillZone 0 w kampanii.
  - Twardy fakt sesji: GSM `node_added → GapLedger.ensure_exit_open` otwiera
    wyjścia z automatu (D-227) — `is_exit_unlocked` nie jest sygnałem bramek;
    stąd pozorne odwrócone komunikaty w `pkg_0163:111/132/158` przy asercjach
    na prawdę. Checkpoint przed próbą poza kryteriami (otwarty).
  - Nowa bramka `tests/pkg_0222_correction_cost_budget_test.gd` PASS (3×);
    pin 0207: 116/115/114; 123. sekcja w `tools/verify.ps1`.
  - Kadry 14/15/18 6 PNG s100 full/notext + klatka kosztu 15
    (`reports/pkg_0222/visual/`); inspekcja HOLD obrazu, zero napraw.
  - Raport: `docs/rebuild/PKG_0222_CORRECTION_COST_BUDGET.md`; decyzja D-235
    w `docs/DECISION_LOG.md`.
  - Zakresowa `verify_scoped.ps1` PASS (exit 0; docs + smoke + 12 bramek:
    0222/0207/0120/0163/0147/0194/0193/0195/0114/0215/0217/traversal_lint);
    licznik D-217: 1. zakresowa po pełnej PKG-0221.

### Wynik PKG-0221

- Drabina + Return + skale (decyzja D-234, strefy lokalne + 5 skryptów stacji, pełna):
  - Drabina (M9): intencja w `LadderZone` (`try_mount`: interact albo
    stop+góra; overlap to kandydatura); koniec `jump-off` w graczu
    (nowe `begin_climb()` wołane wyłącznie przez strefę).
  - Return (M3): `ReturnZone` jako drugi `ThresholdZone` (overlap milczy,
    powrót wyłącznie `trigger_return`/interact; `target_station` = poprzednik
    GSM; apertura/rodzina jak próg wprost); podpięcia `body_entered`
    w stacjach 05/06/07/08/43 usunięte (handlery jako `pass`); strefy nie
    konsumują `interact` (priorytet MRP jak D-228).
  - Skale (M1-część): 02/height 76 (wystawanie 12), 15/height 150
    (wystawanie 12 nad sill), 16/y 288 (dół na podłodze); GATE-SCALE
    0 naruszeń; drabin nie doklejono; apertury Bindera i D-227 stoją.
  - Twarde fakty: konsumpcja `interact` przez strefy wyłożyła `pkg_0194`
    lawinowym FAIL-em (głodzenie MRP) — naprawiona brakiem konsumpcji
    w tym samym pakiecie; próg 80 z `pkg_0157` był starszy niż kanon §9.3
    (kontrolowanie do >= 72, most zachowany); wpis ticków 60 zniknął
    z `project.godot` między pakietami (przywrócony, runtime cały czas 60).
  - Nowa bramka `tests/pkg_0221_ladder_return_scale_test.gd` PASS (3×);
    pin 0207: 115/114/113; 122. sekcja w `tools/verify.ps1`.
  - Kadry 02/15/16 6 PNG (`reports/pkg_0221/visual/`); inspekcja HOLD
    obrazu, zero napraw.
  - Raport: `docs/rebuild/PKG_0221_LADDER_RETURN_SCALE.md`; decyzja D-234
    w `docs/DECISION_LOG.md`.
  - PEŁNA `verify.ps1` PASS (exit 0, dowód
    `reports/pkg_0221_verify_full.log`); licznik D-217 ZRESETOWANY
    (ostatnia pełna PKG-0221).

### Wynik PKG-0220

- Pętle ambientu + duck (decyzja D-233, shared-touch audio + rig, pełna):
  - Pętle (A1): 7 ambientów PKG-0180 na `generate_looping_wav` z obwiednią
    loop-safe (f0/wewnętrzne AM/długości nietknięte) + wypiekany crossfade
    80 ms w helperze (sygnatura i spis 265 nietknięte; sustain/drag stoją).
  - Duck (A2): hum −24 / sub −28 / unease −22 (nowy const), −7 dB, lerp 6.0.
  - Busy (A3): `Ambient`/`Dialogue` idempotentnie (duck jako sidechain,
    kompresor opcjonalny); ambient celowo niepozycjonowany (komentarz).
  - Double-buffer: `_ambient_back` mirroruje pętlę (hot spare, −80 dB,
    stopped — budżet 0130 liczy tylko playing); retrigger usunięty.
  - Drain (A4): `_exit_tree` przez `ProceduralAudio.drain_playback`.
  - Twardy fakt: pierwszy wariant z grającym spare wyłożył `pkg_0130`
    realnym FAIL-em (5 głosów > 4 na 8 stacjach 31–41); naprawiony
    stopped-spare w tym samym pakiecie, 0130 PASS.
  - Nowa bramka `tests/pkg_0220_ambient_loop_duck_test.gd` PASS; pin 0207:
    114/113/112; 121. sekcja w `tools/verify.ps1`.
  - Raport: `docs/rebuild/PKG_0220_AMBIENT_LOOP_DUCK.md`; decyzja D-233
    w `docs/DECISION_LOG.md`.
  - PEŁNA `verify.ps1` PASS (exit 0, dowód
    `reports/pkg_0220_verify_full.log`); licznik D-217 ZRESETOWANY
    (ostatnia pełna PKG-0220).

### Wynik PKG-0219

- Sufit + światło + reguła różu (decyzja D-232, sceny lokalne 01/09 + decyzja, zakresowa):
  - Sufit 09 (V4): opuszczona podbitka x 0..300 ze spodem y=172 (const RESIDENTIAL_CEILING_BOTTOM przy LENA_HEAD_Y 209) domyka prześwit do 37 px (kontrakt 20–45); 2 plany; drzwi 109 px i collidery (sufit 0..30) nietknięte; lampa wisi pod podbitką (230,184) ze stożkiem na stół; etykieta MIESZKANIE 14 na ścianie (322,100) w pasie 90–190; sąsiedzi 08/10/13 tylko zaaudytowani (10 near-miss 51 px do osobnego pakietu).
  - Światło 01 (V6): 1 nazwane źródło robocze na bęben (WORK_LIGHT_POS 247,188 + stożek 0.12) + zimne wypełnienie z góry (pas 44..70, 0.06) + jawny cień kontaktowy pod bębnem/pulpitem w prawo 0.48 (zasięg x=312 poza obudowę 298); zero nowych baz koloru; audyt 12/14 (cienie 0.48 w prawo stoją).
  - Róż (V10): reguła Marta-w-kadrze (character_id &"marta": dziś 10 i 13) → 1 akcent → reszta w shade(MID_PLANE); róż tylko na spricie; 09 bez Marty trzyma AMBER+CYAN bez oxide; mono 09 vs 01/11/12/15 na 3 osiach (markery strukturalne, nie percepcja).
  - Nowa bramka `tests/pkg_0219_ceiling_light_rose_pin_test.gd` PASS za pierwszym podejściem; pin 0207: 113/112/111.
  - Kadry 01+09 18 PNG (85/100/115 × full/notext/mono) + mono 11/12/15 s100 (3 PNG, `reports/pkg_0219/visual/`); inspekcja HOLD obrazu, zero napraw.
  - Raport: `docs/rebuild/PKG_0219_CEILING_LIGHT_ROSE.md`; decyzja D-232 w `docs/DECISION_LOG.md`.
  - Rejestracja 120. sekcji w `tools/verify.ps1`; zakresowa `verify_scoped.ps1` PASS (licznik D-217: 4. zakresowa po pełnej PKG-0215; pełna obowiązkowo w PKG-0220).

### Wynik PKG-0218

- Fartuch + paleta + linie 09 (decyzja D-231, sceny lokalne + stała stylu, zakresowa):
  - Fartuch 22/22: audyt wykazał 11 scen bez `draw_stage_apron()` (prompt zakładał tylko 09); dopisany jako pierwsza linia malowania w 09/13/14/15/16/17/18/42a/42b/42c/43 (wzór `01.gd:466`, D-136); w 09 dodatkowo kolejność fartuch-przed-play-plane pinowana bramką.
  - Paleta 09 na VectorStageStyle (zero `Color("…")`, było ~36 hexów; układ 1:1; bazy INK/DEEP/MID/LIGHT + AMBER + CYAN + shade); `MAX_PALETTE_COLORS` 7 → 8 (kanon 8–16, D-231); STAGE_APRON 40 i offset 36 nietknięte.
  - Linie 09 ≥ 2 px (zero stroke 1.0; licznik tylko stroke, nie logika — wniosek z własnego FAIL-a bramki na clampf w 13); sąsiedzi 08/10/13 zaudytowani (10-sufit do PKG-0219 V4 — załatwiony audytem, naprawa sufitu 10 w osobnym pakiecie).
  - Nowa bramka `tests/pkg_0218_apron_palette_line_pin_test.gd` PASS (nadal PASS po kompozycji 0219); pin 0207: 112/111/110.
  - Kadry 09 9 PNG (85/100/115 × full/notext/mono) + spot 13/18 4 PNG (`reports/pkg_0218/visual/`); inspekcja HOLD obrazu, zero napraw.
  - Raport: `docs/rebuild/PKG_0218_APRON_PALETTE_LINES.md`; decyzja D-231 w `docs/DECISION_LOG.md`.
  - Rejestracja 119. sekcji w `tools/verify.ps1`; zakresowa `verify_scoped.ps1` PASS (licznik D-217: 3. zakresowa po pełnej PKG-0215).

### Wynik PKG-0217

- Synteza + prognozy + urządzenia (decyzja D-230, linie + kanon 1 linia + testy, zakresowa):
  - Synteza 13 z trzecim głosem: usunięta sugestia świadomego testu, dodany `JAKUB (ŁĄCZE)` z odczytem sprawdzenia numeru (6 par; logika 3 śladów + 3 rodzin + 2 markerów nietknięta, pinowana read-only); FULL_STORY 13 zsynchronizowany.
  - Prognozy granted z jawnymi polami `brak danych` (3/3 linie) i dyferencjacją urządzeń treścią (REJESTR 20:40 / ANALIZATOR oś-pik / NOTATKA na marginesie); `limited/refused/missing` nietknięte.
  - Urządzenia poza prognozami: ANALIZATOR z wykresem (`safe_analyzer`, 2× `cost_selector`), NOTATKA odręcznie (`abort_note`), REJESTR z numerami (bez zmian); ta sama liczba par.
  - Wierzbicka bezosobowa z kwalifikatorami (`stan/zakres/stabilność/dopuszczalne/procedura`; 4/4/4 pary; recepcja wycofana; odmowa Leny nietknięta).
  - Twardy fakt: pierwsze dopiski (~130 znaków) wyłożyły sąsiada `pkg_0194` realnym FAIL-em fit-at-100 (pudło CRT 488×52); naprawione skróceniem do ~104–111 znaków w tym samym pakiecie.
  - Nowa bramka `tests/pkg_0217_synthesis_forecast_pin_test.gd` PASS; pin 0207: 111/110/109.
  - Kadry 13/18 12 PNG (`reports/pkg_0217/visual/`); inspekcja HOLD obrazu, zero napraw.
  - Raport: `docs/rebuild/PKG_0217_SYNTHESIS_FORECAST_DEVICES.md`; decyzja D-230 w `docs/DECISION_LOG.md`.
  - Rejestracja 118. sekcji w `tools/verify.ps1`; zakresowa `verify_scoped.ps1` PASS (licznik D-217: 2. zakresowa po pełnej PKG-0215).

### Wynik PKG-0216

- Słownik + lint treści + palimpsest (decyzja D-229, linie + testy, zakresowa):
  - `Zakotwiczenie` jedyną nazwą metody (linie gd:31, station_14 PL/EN, FULL_STORY 20-21, raport 0194); `Utrzymanie ruchu` zachowane.
  - Lint treści prezentowanej: 6 ID bramki wiedzy → fallback bez przedwczesnych terminów; dowód fail-closed; furtka D-211 nie na stałe (0165 stoi).
  - Palimpsest 42B: `Jadę nad częściowo startym Tak` w 3 wariantach household_b + blok FULL_STORY 42B (ta sama liczba par).
  - Nowa bramka `tests/pkg_0216_dictionary_content_pin_test.gd` PASS; pin 0207: 110/109/108.
  - Kontrolowany update asercji `pkg_0194:286` (wykryty realnym FAIL-em sąsiada).
  - Kadry 13/18/42b 18 PNG (`reports/pkg_0216/visual/`); inspekcja HOLD obrazu, zero napraw.
  - Raport: `docs/rebuild/PKG_0216_DICTIONARY_CONTENT_LINT.md`; decyzja D-229 w `docs/DECISION_LOG.md`.
  - Rejestracja 117. sekcji w `tools/verify.ps1`; zakresowa `verify_scoped.ps1` PASS (licznik D-217: 1. zakresowa po pełnej PKG-0215).

### Zachowane wcześniejsze wyniki

PKG-0215 (D-228 luki 1:1 z głosem i priorytet interact) bez zmian.
PKG-0214 (D-227 własność progów i otwarte wyjścia) bez zmian.
PKG-0213 (ścieżka D, audyt 360 + plan R0–R10) bez zmian, jest SPECYFIKACJĄ.
PKG-0212 (D-226 spis stacji 45↔45) bez zmian.
PKG-0211 (D-225 ProceduralAudio census) bez zmian. PKG-0210 (D-224 Aurelius audit remediation) bez zmian. PKG-0208 (D-223 HOLD logiki) bez zmian.
PKG-0207 (D-222 HOLD logiki) bez zmian. PKG-0206 (D-221 HOLD logiki) bez zmian.
PKG-0220 (D-233 pętle/duck) bez zmian. PKG-0221 (D-234 drabina/powrót/skale) bez zmian.
PKG-0222 (D-235 korekta/koszty/budżety) bez zmian.
PKG-0223 (D-236 głosy/tempo/margines) bez zmian.
PKG-0224 (D-237 rigi/geometria) bez zmian.
PKG-0225 (D-238 winiety/nośniki) bez zmian.
PKG-0205 (D-220 HOLD 0) bez zmian. PKG-0203 (16/16 HOLD) i PKG-0202 (4/4 HOLD) bez zmian.
PKG-0200 (slice2 73, łącznie 203) i PKG-0199 (pilot 130) bez zmian.
PKG-0191/0194: erasure kanonicznych faktów zamknięta (D-208/D-211); PKG-0192: callable P7 wycofane.
F-0184-010: rendery zamknięte (203/203); interakcje/audio ZAPINOWANE (PKG-0206).

## Ostatnia swieza weryfikacja

- PELNA `tools/verify.ps1` (D-217, shared-touch: stacje 42A/B/C + 43 + testy):
  PASS, exit 0 (136 sekcji: DOCS + import + smoke 01-43 + wszystkie bramki 0001-0238);
  dowod: `reports/pkg_0238_verify_full.log`.
- Baseline sprzed kodu: w pelnej wykryto i natychmiast naprawiono dyskrepancje w `station_43.gd`
  (kwestia 1 DEFAULT_DIALOGUE_LINES przywrócona do zgodności z PKG-0230 i PKG-0237 D7).
- Bramka 0238 PASS (5 kryteriów: E1 ogniwa dialogowe, E1 ciągłość 09–18, E2 trzy sekundy implicit,
  E3 rezerwy 42A/B/C fallback, CRT <= 115 znaków).
- Sasiedzi izolowane: 0107, 0194, 0195, 0216, 0217, 0226, 0233, 0234, 0235, 0236, 0237, 0207 PASS.
- Licznik D-217: ZRESETOWANY (pelna PKG-0238).
- Finalne `tools/verify_docs.ps1`: PASS po handoffie.

Zamrożenie bieżącego pakietu: `snapshots/PKG-0238-2026-09-16`, przez wymagany
`tools/snapshot.ps1 -Package PKG-0238`. Reports i .godot pozostają wyjściem
roboczym, a snapshot nie jest źródłem bieżącego stanu.

## Czego jeszcze nie potwierdzono

- Fun, emocja, uroda, zrozumienie: OPEN-NO-EVIDENCE. Zero zewnętrznych testerów.
- F-0184-010: rendery zamknięte (203/203); interakcje/audio ZAPINOWANE
  i OPISANE (PKG-0206, D-221); ekstrakcja tabel czeka (dotyka logiki,
  wymaga dyspozycji, shared-touch → pełna verify).
- Rewizja D-220 (prop_type station_18) tylko nowym pakietem z kadrami
  przed/po normalnym sterownikiem i bramką mierzalną.
- Rewizja D-221 (inwentaryzacja) tylko nowym pakietem przy zmianie liczb
  gałęzi/dźwięków (ekstrakcja lub nowa gałąź w fasadzie).
- Rewizja D-222 (spis) tylko nowym pakietem przy zmianie liczby bramek
  (nowa bramka aktualizuje pin razem z tym testem, wzór D-216/D-218/D-224/D-225/D-226/D-229/D-230).
- Rewizja D-223 (selektor/defaulty) tylko nowym pakietem przy zmianie
  składu selektora, mapy operacja→finał albo defaultów prezentacji.
- Rewizja D-224 (Aurelius audit remediation) chroni przed reentrancją setterów
  oraz kruchością drzewa węzłów.
- Rewizja D-225 (ProceduralAudio census) pinuje parametry syntezy dźwiękowej i cyklu życia cache.
- Rewizja D-226 (spis stacji) pinuje kompletność plików stacji 45↔45 i 3 helpery.
- Rewizja D-229 (słownik + lint + palimpsest) pinuje nazwę metody, fallback
  treści 17/18 i obie inskrypcje 42B.
- Rewizja D-230 (synteza + prognozy + urządzenia) pinuje trzeci głos Jakuba,
  pola `brak danych` w granted, rejestry urządzeń i stronę bezosobową
  Wierzbickiej; nie pinuje wysokości pudła CRT (to pinuje `pkg_0194`).
- Rewizja D-231 (fartuch + paleta + linie) pinuje fartuch 22/22 scen
  01–18/42/43, zero hexów w 09, MAX 8 i zero stroke 1.0 w 09; nie pinuje
  palet 08/10/13 ani sufitów 08/10/13 (sufit 09 to PKG-0219 V4; reszta otwarta).
- Rewizja D-232 (sufit + światło + róż) pinuje podbitkę 09 (spód 172,
  prześwit 37 px), światło 01 (work + fill + cień w prawo 0.48), audyt
  12/14 oraz regułę 1-akcentu Marty z mono na 3 osiach; nie pinuje palet
  10/13 (osobny pakiet) ani osi audio.
- Rewizja D-233 (pętle + duck) pinuje 7 ambientów na generate_looping_wav,
  duck ×3, busy i drain; D-234 (drabina + powrót + skale) pinuje intencję
  w strefie, powrót interact-only i skale 02/15/16; D-235 (korekta + koszty
  + budżety) pinuje koszt 14/15, budżety ≤3, select-routing i markery 01/18;
  D-236 (głosy + tempo) pinuje loop 2 pary + tiki, urządzenia-resztę, hub 09,
  projekcję 17, N10 grep-0 i margines K4; D-237 (rigi + geometria) pinuje
  seated Jakuba 56-60, wyjątki vendor/neighbour, profile 06/08 i apertury.
- Rewizja D-248 (cięcia i HATCH 13) pinuje wyjście HATCH w 13, DOOR w 09/10/12,
  zdanie wyjścia do UCP w 10 i routing powrotów z prawej.
- Rewizja D-249 (słowa zarobione) pinuje słowo Równia w 17, dwa tryby Wierzbickiej,
  szyld analizatora w 16, 42B w progu bez wiaty, JAKUB ECHO w 42C i gałąź unseeded epilogu 43.
- Rewizja D-250 (mosty dialogowe) pinuje ciągłość przyczynową wejść i wyjść 09–18,
  3 sekundy nie wykładane wprost oraz rezerwy 42A/B/C jako fallback edytorski.
- Nowe harnessy dowodzą ładowania i braku błędów, nie samodzielnego
  dojścia gracza. Nie mierzono czasu gracza.
- AMD/NVIDIA/Steam Deck i natywny Linux poza WSL bez nowych dowodów.

## Nastepny pakiet

Plan naprawy sensu fabularnego 2026-09-15 został w pełni zrealizowany:
A (PKG-0234, DONE) → C (PKG-0235, DONE) → B (PKG-0236, DONE) → D (PKG-0237, DONE) → E (PKG-0238, DONE).
Wszystkie 5 pakietów naprawczych są wdrożone, przetestowane i zapinowane.

Stan projektu: drzewo jest review-ready. Freeze D-241 ponownie obowiązuje:
nie ruszać kodu, scen, dialogów ani monolitycznych struktur bez wyraźnej dyspozycji właściciela.
Kolejna sesja oczekuje na decyzję właściciela projektu:
1. Ocena `PRODUCT GO` na zaktualizowanym runtime według `docs/rebuild/ACCEPTANCE_MATRIX.md`;
2. Lub zlecenie kolejnej fazy produkcyjnej / pakietu recertyfikacyjnego.

Nie ruszać legacy 19–41, webu, release, `.exe`, ekstrakcji MRP, enumów ani
serializowanych ID. Piny D-220..D-250 pozostają; kontrolowana
aktualizacja testów jest wymagana, gdy nowe inwarianty świadomie
zmieniają stary kontrakt (wzór PKG-0238). Release i GATE-REL nadal
BLOCKED BY D-168. Pełny samodzielny handoff:
`docs/NEXT_SESSION_PROMPT.md`.
