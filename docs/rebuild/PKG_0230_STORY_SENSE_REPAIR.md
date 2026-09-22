# PKG-0230: Naprawa sensu fabularnego (story-sense repair)

Data: 2026-09-14.
Podstawa: `docs/narrative/STORY_SENSE_AUDIT_2026-09-14.md`,
`docs/narrative/STORY_SENSE_REPAIR_PLAN_2026-09-14.md`,
dyspozycja wlasciciela `docs/narrative/STORY_SENSE_REPAIR_PROMPT.md`
(freeze D-241 zdjety dla tego zakresu i tylko dla niego).
Decyzja: D-242. Bramka: `tests/pkg_0230_story_sense_repair_test.gd`.
GATE-REL, release i nowe `.exe` nadal BLOCKED BY D-168. Nie jest to PRODUCT GO.

## Kolejnosc wykonania (wiazaca z promptu)

P0-4 pierwszy, potem P0-3 (z potwierdzeniem defektu), P0-1, P0-2,
P1-1+P1-4, P1-3, P1-2, P2-1, P2-2/P2-3/P2-4. Plan wykonany w calosci
z jednym wykresleniem (P0-3, nizej) i trzema odroczeniami w P2-2 (nizej).

## P0-4: epilog 43 (S-09) — ZROBIONE

`scripts/levels/station_43.gd:75` (`DEFAULT_DIALOGUE_LINES[1]`, galaz
`unseeded`): zdanie o Linii 4, ktora "wedlug niej nigdy nie istniala",
zastapione faktem zgodnym z kanonem — roznica w statusie odcinka
(odbudowany po katastrofie, data odbioru obok rozkladu), nie w istnieniu.
Galezie 42A/B/C nietkniete. Testy 0170/0195 (pozycje linii 0/2/4) zielone
bez zmian.

## P0-3: powrot 09-18 (S-04) — WYKRESLONY, defekt obalony w runtime

Krok 2 promptu wymagal potwierdzenia defektu przed naprawa. Potwierdzenie
negatywne, dwa dowody:

1. Bramka `pkg_0214` (D-227, standing evidence, re-run w pakiecie PASS):
   "22/22 exits open with zero readings".
2. Kod: `GameStateManager._observe_campaign_station` (node_added) wola
   `ThresholdBinder.install` + `GapLedger.ensure_exit_open`, ktore wywoluje
   `station._unlock_exit()` — wyjscia otwieraja sie z automatu przy wejsciu
   (PROGRESSION_FLOW_CONTRACT: trasa zawsze przechodnia; werby bramuja fakty
   i luki, nie ruch). Brak `unlock_exit_for_return` w 09-18 nie zakleszcza,
   bo flaga i tak jest stawiana z automatu; sama podroz powrotna
   (ReturnZone → `previous_level_requested` → poprzednik GSM → spawn z prawej)
   dziala i jest pinowana nowa bramka 0230.

Dopisy­wanie 10 metod `unlock_exit_for_return` byloby churnem bez zmiany
zachowania — nie zrobione swiadomie. Zakres P0-3 zamkniety bez kodu.

## P0-1: moc sprawcza zgody Jakuba (S-02) — ZROBIONE

`scripts/levels/station_18.gd::_commit_method` czyta teraz
`_build_forecasts(_read_jakub_consent())` i PRZERYWA (`return false`),
gdy wybrana droga ma `available == false` — feedback `jakub_consent_missing`
(nowa pozycja w `FEEDBACK_TO_GAP` → `s17.consent_unscoped`, czyli luka mowi
powrotem do 17, nie komunikatem systemowym) + beat Leny
`s18_consent_refused_blocks` ("Bez jego reki nie zatwierdze tej drogi...").
Ten sam bezpiecznik dla braku zestawienia/prawdy (wczesniej tylko logowane,
commit i tak przechodzil). Odmowa zamyka wszystkie trzy drogi; wyjscie ze
stanu to powrot do 17 i renegocjacja na swiezej instancji (flaga jednokrotna
jest per instancja, decyzje nadpisuja sie) — wariant najbezpieczniejszy
z promptu, oznaczony jako decyzja do potwierdzenia (D-242).
`station_42a/42b/42c.gd`: usuniete domyslne podstawienia zgody
(`else SCOPE_LIMITED` / `else SCOPE_GRANTED`); pusta zgoda to luka
`consent_scope_required` + `return false` (wyjscia 42 otwieraja sie
niezaleznie w `_ready`, wiec brak softlocka). Fallbacki Marty nietkniete
(poza zakresem planu).

## P0-2: wybor finalu jako wypowiedziana decyzja (S-03) — ZROBIONE

- `choose_method_from_player_side`: pierwsze podejscie NAZYWA metode
  (`named_method` + beat `s18_name_*` + znacznik w `_draw_commit_post`),
  dopiero drugie podejscie do TEJ SAMEJ metody zatwierdza. Inna strefa
  nazywa od nowa. Bezposrednie czasowniki `commit_*` (testy) ida wprost
  do `_commit_method` — kryterium dotyczy sekwencji gracza (MRP), nie API.
- Martwa strefa srodka +-24 → +-40 px (krawedz poza sylwetka 87 px).
- Trzy oznaczenia `CrispDiegeticText` (LEWO/SRODEK/PRAWO) nad panelem
  dialogowym (pozycje po bramce 0137; pierwsza wersja na podlodze wchodzila
  na panel — zlapane pelna weryfikacja jako realna regresja).

## P1-1 + P1-4: ogniwa przyczynowe i nazwanie celu — ZROBIONE (jeden pakiet)

Zdania WEJSCIA (`OpeningDialogueCue.opening_line` w 14/15/16/17/18 —
tresci tych cue nie pinuje zaden test poza niepustoscia):
14 = trop przerwanej proby 20:40; 15 = wyciag z 11; 16 = przyrzad poza
obwodem; 17 = rejestr par w hali UCP; 18 = powrot na znana ulice + Marta.
Zdania WYJSCIA (beaty L3, triggerowane w czasowniku terminalnym):
`s10_exit_ucp_record`, `s12_exit_back_home`, `s13_exit_to_switchyard`,
`s14_exit_to_loop`, `s15_exit_to_analyzer`, `s16_exit_to_ledger`,
`s17_exit_to_street`. 10→11 mialo juz nazwanie w kwestii Marty
("W UCP. Tam pracujesz.") — beat je wzmacnia, nie zastepuje.
Slownik otwarty po 13, ryzyko wyprzedzenia wiedzy niskie; ogniwa nie
dotykaja roli UCP w katastrofie (nalezy do 17).

## P1-3: ciala dla glosow (S-07) — ZROBIONE

- 17: brak riga (rekomendacja planu) — jawny terminal lacza w `_draw`
  nad lada zgody + didaskalia `JAKUB (ŁACZE)` w 3 kluczach
  (precedens: `JAKUB (ŁACZE)` w syntezie 13 z PKG-0217; blip dzwiekowy
  dziala przez dopasowanie `in`, fallback koloru bez crashu).
  Nieobecnosc Jakuba w hali jest konsekwencja (naped przed koncem zmiany).
- 18: rig Marty przy witrynie (wzor 10: `MartaBlockout/Marta`, idle).
- 42A: rig Marty STOJACY przy stole (puste krzeslo + kurtka K1 nietkniete;
  beat pustego krzesla w mocy — ona stoi, nie siedzi).
- Prezentacja: dopasowanie mowcy `begins_with` zamiast `==`, wiec
  "Marta domowa" i "JAKUB (ŁACZE)" steruja rigami (42A i 42C tez zyskuja).

## P1-2: zawias Marty (S-06) — ZROBIONE (wariant tanszy)

`StationDialogueCue` dostal opcjonalna druga kwestie (`opening_line_2` /
`speaker_2`, domyslnie pusta = jedna kwestia jak dawniej). Tylko 13 jej
uzywa: po kwestii Leny Marta mowi, ze sprawdzila numer zmiany i nazwisko
w grafiku i sadza do stolu "nie na przesluchanie". Replika z 10
nienaruszona. Pin 0184 na pierwsza kwestie 13 nietkniety.

## P2-1: kierunek trasy i pion (S-05, S-08) — ZROBIONE

- `GameStateManager.arrival_side_for`: 12→13 i 17→18 wchodza z prawej
  ISTNIEJACYM mechanizmem (`transition_to_station_bidirectional` w lejku
  `complete_station`; prog i tak jest po prawej, D-227). Wiersz 13 w MAPie
  juz deklarowal wejscie z prawej — runtime dogonil dokument; wiersz 18
  poprawiony na "prawa (powrot na ulice z 05)".
- Pion: 15 i 16 maja `ServiceLadder`; 14 nie ma windy (ServiceLift tylko
  w wycofanych 25/34) — MAPA nie obiecuje juz windy w 14 (zejscie to HATCH
  z Bindera), wiersz ServiceLift i tabela pionu poprawione.

## P2-2: rytm — CZESCIOWO (3/5 + 2 deklaracje)

Zrealizowane tam, gdzie kod juz niosl material: (a) 14 jako scena
z jednym punktem (adnotacja RYTM w naglowku, swiadome odstepstwo);
(c) gating tresci faktem `home_sample_preserved` w 13/16 (istnial,
zadeklarowany); (e) punkt-osoba w 17 (biurko zgody = rozmowa przez
lacze po P1-3; adnotacja w naglowku).
ODROCZONE z powodow: (b) niewymuszona kolejnosc, (d) scena przejsciowa
bez punktow, (f) roznicowanie pierwszych rozbieznosci — kazde rusza
lancuchy pinowane testami (0193/0194/0166) i wymaga oceny czytelnosci,
ktorej ten sandbox nie da (brak displaya, D-241/3). Decyzja jawna, nie luka.

## P2-3: higiena (S-13) — ZROBIONE

- Naglowki 09-13 opisuja sceny, ktore pliki URUCHAMIAJA (warstwa live),
  z jawna adnotacja o nieaktywnej warstwie dawcy P7 (callable dla testow).
  Markery `ZOSTAJE jako` (0192) i bloki retirement nietkniete.
- Wezly 11/13 przemianowane na jezyk swiata (WorkBoots→IdentityCardSlot,
  CommodePhotograph→DayRecordLedger, FieldReaderDock→MinimalReportWindow,
  LegacyDomesticWitnessA/B→DonorTraceA/B, PhoneToMarta→SharedTableReader);
  zero referencji w kodzie/testach/narzedziach (pelny grep; tylko
  zamrozone snapshoty i audyt, nietkniete). Pelna weryfikacja wymagana
  przy zmianie nazw — wykonana.
- FULL_STORY z notka o numeracji (aktywna 01–18/42/43; 19+ to dawca 0.3;
  stare 21/22 = nowa 13 / era 14–18). Przepisywanie 38 KB legacy poza
  zakresem — notka usuwa pulapke wykonawcza, nie historie.
- CAMPAIGN_MAP: kierunek powrotow + pion (P2-1, wyzej).

## P2-4: nocne UCP (S-12) — ZROBIONE

Beat `s11_night_desk` przy pierwszym werbie 11 ("Nocny dyzur: okienko
czynne do rana...") — wzor warsztatu Jakuba, jedno zdanie, w grze.

## Twarde fakty sesji

1. Pelna `verify.ps1` lapala DWIE realne regresje poza zakladanym blast
   radius (lekcja D-217/D-199): (a) 0099 — nowe naglowki bez literalnego
   "koszt porażki" (moje ASCII "porazki"); (b) 0137 — legendy slupka na
   panelu dialogowym. Obie naprawione w pakiecie, pelna na koncu PASS.
2. 0194 padal przez WYSCIG HARNESSA, nie gre: completion 17 przy wlaczonym
   auto-transition ladowal w tle druga instancje 18 (change_scene), ktorej
   prezentacja zjadala pressy foregroundu (druga 18 widoczna jako
   @Node2D@44 z prezentujacym boxem; pressy 0-word; bez bledow).
   Naprawa wylacznie w tescie (auto-transition off w 0194, wzor
   0166/smoke/0222) — kod gry nietkniety. W grze wyscig niemozliwy
   (zmiana sceny podmienia).
3. Kontrolowane aktualizacje asercji po REALNYCH failach (wzor PKG-0216):
   smoke `_test_station_18`, 0166 (safe_rejections + refused path), 0194
   (run_18: dwa akty na slupku; run C: blokada → renegocjacja → commit;
   vignette_count wraca do 6, bo blocked-18 nie commituje i nie gra
   winiety). 0166 przed aktualizacja: 4 faili dokladnie w nowym kontrakcie.

## Test rozstrzygajacy (prompt § "po co to wszystko")

Po kazdej scenie jedno zdanie z tresci gry, bez dokumentacji —
"dlaczego ide tam, gdzie ide":

01 pomiar przy Linii 4, potem do Marty. 02 skrot na przystanek.
03 przystanek, Marta czeka. 04 wagon i czytnik. 05 moja ulica do domu.
06 kiosk: woda, rozklad, pytanie o Marte. 07 Sadowa 7: dokument mowi 12.
08 klatka: sasiadka, klucz 14. 09 salon: czyje to zycie (dwa komplety,
zdjecie). 10 Marta: kubki, jej dzien, granica → sprawdzic zapis pracy
w UCP. 11 lada: karta, 186 dni, wyciag 20:40 → numer warsztatu. 12 lacze
i czlowiek przy imadle → wrocic do stolu. 13 synteza → odnalezc ja;
przerwana 20:40 → sprawna maszyna w rozdzielni. 14 most trzyma → do petli
po echo ze wyciagu. 15 zywy sygnal + warunek przerwania → analizator poza
obwodem. 16 koszt + echo domu (nikt sie nie zamienil) → rejestr par
w hali UCP. 17 zakres zapisany → ulica, trzy drogi, Marta, prawda.
18 zestawienie, prawda, zatwierdzenie → final. 42 wykonanie. 43 epilog.

18/18 (bylo 13/18). Dowod kontraktowy, nie odbiorczy (D-012, ADR-003).

## Pliki dotkniete

Gra: station_10/11/12/13/14/15/16/17/18/42a/42b/42c/43 .gd,
creative_scene_lines.gd, creative_scene_presentation.gd,
station_dialogue_cue.gd, gap_ledger.gd (1 wpis), game_state_manager.gd
(arrival_side_for + lejek), sceny 11/13/14/15/16/17/18/42a .tscn.
Testy: nowy 0230; aktualizacje 0166/smoke/0194/0207; verify.ps1 (129.).
Docs: ten raport, DECISION_LOG D-242, CAMPAIGN_MAP, FULL_STORY.

## Ograniczenia

- Zero swiezych kadrów (sandbox bez displaya, D-241/3): nowe elementy
  obrazu (rigi 18/42A, terminal lacza 17, legendy slupka, znacznik
  wskazania) zweryfikowane bramkami (0137 clearance, 0172/0186/0224 rigi,
  validate scen), ale nie okiem. Inspekcja na maszynie z displayem przy
  najblizszej okazji wizualnej (otwarte w D-242).
- Brak dowodow odbiorczych z zasady (D-012, ADR-003).
- Pytanie do wlasciciela (z promptu, P0-1): odmowa zamyka 3 drogi;
  implemented: powrot do 17 i renegocjacja. Alternatywa (czwarta metoda
  o wyzszym koszcie Leny) niezaimplementowana — do decyzji.
- P2-2 (b)(d)(f) odroczone (wyzej).
