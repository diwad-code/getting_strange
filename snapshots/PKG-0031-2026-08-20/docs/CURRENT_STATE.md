# Aktualny stan projektu

Stan na: 2026-08-20

## Katalog i srodowisko

- Katalog: `C:\getting_strange`
- Godot: `4.7.stable.official.5b4e0cb0f`
- Platforma robocza: Windows, PowerShell 7
- Narzędzia generatywne: Picsart AI CLI (`gen-ai`, uwierzytelniony dostęp do generacji obrazów, wideo i audio)
- **Wersjonowanie: brak (D-016).** Pliki na dysku sa jedynym stanem projektu.
  Nie ma repozytorium, galezi, commita ani historii. Nie uruchamiamy `git`. Ostatni zamkniety pakiet: `PKG-0031`, 2026-08-20
- Kronika pakietow: `SESSION_LOG.md` - jedyna historia, append-only
- Zamrozenia: `snapshots/PKG-NNNN-DATA/` przez `tools/snapshot.ps1` (D-017);
  ostatnie: `snapshots/PKG-0031-2026-08-20`

Do PKG-0005 wlacznie projekt byl wersjonowany. W `PKG-0006` usunieto `.git`,
`.gitignore` i `.gitattributes`. Ta historia nie istnieje juz w formie
odtwarzalnej; kazdy stan sprzed `PKG-0006` jest opisany wylacznie w
`SESSION_LOG.md`. Nie powoluj sie na commity - nie da sie ich sprawdzic.

## Aktywna faza

Faza **`P3 / Vertical Slice`** została **OTWARTA I JEST W TOKU** (PKG-0019, postęp: Przestrzenie 01..13 wdrożone — Akt I w pełni domknięty, Akt II rozwijany w silniku). Faza P2 (Anchor Lab) zakończona i zaliczona.

Model dowodu calego projektu zmienil sie 2026-08-15. Zewnetrzne playtesty i
czytania stolikowe nie odbeda sie (D-012, ADR-003). Bramki P1, P2, P3 i N1
zostaly przepisane na pomiar obiektywny i audyt kontraktu. Kazda z nich
wymienia jawnie, czego nie sprawdza.

Prowadzenie kanonu, kierunku wizualnego i dokumentow zarzadczych zostalo w pelni przekazane sztucznej inteligencji (AI - Antigravity) jako Lead Programmer i Art Director (D-025, ADR-004), znoszac koniecznosc eskalacji, co nadpisuje D-018. Runtime, Prototype 02, Vertical Slice i bramka P1 znajduja sie pod wylaczna jurysdykcja AI.

Aktywna specyfikacja kreatywna:
`docs/narrative/NARRATIVE_BIBLE.md`

Specyfikacja prototypu runtime:
`docs/PROTOTYPE_01_MOVEMENT_LAB.md`

Dokumenty wykonawcze N1:

- `docs/narrative/FULL_STORY.md` — 43 przestrzenie w pieciu aktach (układ
  7/10/11/11/4 po N0.2-C);
- `docs/narrative/CONTINUITY_TRACKER.md` — poszlaki, stany i warunki finalow;
- `docs/narrative/DIALOGUE_SCRIPT.md` — glosy i 15 kluczowych scen dialogowych;
- `VISUAL_DESIGN.md` — rezyseria wizualna oraz handoff artystyczny.

## Potwierdzone jako istniejace

### Runtime i Vertical Slice

- Projekt Godot 640x360 uruchamia sceny prototypowe `scenes/prototype/movement_lab.tscn`, `scenes/prototype/anchor_lab.tscn` oraz sceny Vertical Slice: pierwszą lokację `scenes/levels/station_01.tscn`, Komorę Pomiarową `scenes/levels/station_02.tscn`, Puste Laboratorium `scenes/levels/station_03.tscn`, Recepcję/Bramkę IKP `scenes/levels/station_04.tscn`, Rówień nocą `scenes/levels/station_05.tscn`, Wnętrze autobusu zastępczego `scenes/levels/station_06.tscn`, Klatkę schodową na Osiedlu Tarasowym `scenes/levels/station_07.tscn`, Wnętrze mieszkania 14 `scenes/levels/station_08.tscn`, Łazienkę i korytarz `scenes/levels/station_09.tscn`, Telefon Jakuba / Gabinet domowy `scenes/levels/station_10.tscn`, Pierwszą korektę / Dziedziniec i interwencję UCP `scenes/levels/station_11.tscn`, Pokaz bezpieczeństwa / Przejście podziemne i punkt informacyjny UCP `scenes/levels/station_12.tscn` oraz Adres ciągłości / Zaplecze archiwum i fotografia Jakuba `scenes/levels/station_13.tscn`.
- `PrototypePlayer` uzywa `CharacterBody2D`.
- Ruch ma coyote time, bufor skoku, zmienna wysokosc skoku, szybsze opadanie
  i limit predkosci spadania.
- Profile A/B/C laduja sie z `resources/movement/`, a A zachowuje bazowe liczby.
- A/B/C roznia sie tylko czterema parametrami reakcji poziomej.
- Zaimplementowano moduł syntezy `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) generujący 16-bitowe próbki PCM `AudioStreamWAV` dla:
  - zakotwiczenia (740 Hz), odkotwiczenia (660->310 Hz);
  - fali korekty (92->44 Hz) oraz oporu (587/622 Hz);
  - celu/synchronizacji (523/784 Hz);
  - kroków na posadzce laboratoryjnej/betonie (220/340 Hz tap) oraz blasze stalowej (1180/1860 Hz metallic chime);
  - lądowań (115/180 Hz impact thud z rezonansem);
  - ryglowania i uszczelnienia śluzy `Goal` (rezonans magnetyczny 330->880 Hz + hydrauliczny rygiel pneumatyczny);
  - ciepłego rezonansu pamięci `create_memory_resonance_sound()` (dwuton A4 440 Hz + C#5 554.37 Hz z dryfem fazowym);
  - mechanicznego przełącznika hebelkowego `create_switch_toggle_sound()` (transient 820 Hz + 180 Hz body);
  - szumu aparatury próżniowej `create_vacuum_hum_sound()` (55/110 Hz);
  - korelacji próżniowej `create_correlation_hum_sound()` (220/330 Hz z alikwotami 660/880 Hz i sub-basem 55 Hz);
  - mechanicznej drukarki taśmowej `create_printer_strip_sound()` (impulsy silnika krokowego 1150 Hz i tarcie termiczne);
  - przeciążenia igły galwanometru `create_needle_spike_sound()` (transient uderzenia 1380 Hz z tłumionym odbiciem cewki 920 Hz);
  - telefonu stacjonarnego / impulsów powiadomień `create_phone_ring_pulse_sound()` (fala nośna 425 Hz z flutterem 25 Hz i czipem 1680/2100 Hz);
  - czytnika identyfikatorów / autoryzacji z dysonansem `create_card_reader_beep_sound()` (dwuton 987->1318 Hz z dysonansem 1380 Hz "urlop przerwany");
  - szumu opraw jarzeniowych korytarza `create_fluorescent_hum_sound()` (brzęczenie dławika 100/200/300 Hz i mikro-iskrzenie gazu);
  - zrzutu przekaźnika zasilania kamery `create_camera_click_sound()` (strzał elektromagnetyczny 180/1850 Hz z wyładowaniem żarnika);
  - odryglowania zapadki kołowrotu `create_turnstile_unlatch_sound()` (uderzenie solenoidu 340 Hz z tarciem stalowej zapadki 2200 Hz);
  - impulsów dialogowych w świecie gry `create_dialogue_blip_sound()` (Lena: 587 Hz bursztyn, Strażnik: 330 Hz ton instytucjonalny);
  - sygnału przejścia dla pieszych `create_crosswalk_signal_sound()` (impulsy lokacyjne 500 Hz oraz formantowy szept "Le-na" przy wzbudzeniu);
  - deszczu na asfalcie `create_rain_asphalt_sound()` (szum filtrowany dolnoprzepustowo z mikro-impulsami kropel w kałużach);
  - trakcji tramwajowej i sieci napowietrznej `create_tram_traction_sound()` (brzęczenie 50/100 Hz, świst falownika 620 Hz i tarcie obrzeży 1420 Hz);
  - silnika diesla autobusu `create_bus_engine_sound()` (cykl 4-suwowy 42/28 Hz z wibracją nadwozia);
  - deszczu na szybach autobusu `create_bus_rain_window_sound()` (pater kropli na szkle i szum pędu powietrza);
  - komunikatu głośnikowego PA `create_bus_announcement_sound()` (dwuton F#5/C#5 z szumem pasmowym);
  - pneumatyki drzwi autobusowych `create_bus_door_pneumatic_sound()` (upust sprężonego powietrza 1800->420 Hz i składanie skrzydeł);
  - rezonansu złotej obrączki `create_ring_chime_sound()` (dwuton C6 1046.5 Hz + E6 1318.5 Hz z mikrodryfem fazowym);
  - kroków na posadzce z lastryko `create_stair_footstep_sound()` (impuls mineralny 280/480 Hz z echem klatki schodowej);
  - skrzypienia i rygla ciężkich drzwi mieszkania `create_apartment_door_sound()` (tarcie zawiasów 520 Hz i metaliczny zamek 1650 Hz);
  - blipu dialogowego Marty Kurek `create_dialogue_marta_blip_sound()` (ciepły mat 440 Hz A4 z alikwotami 220/880 Hz);
  - przekaźnika włącznika schodowego `create_stair_timer_switch_sound()` (bimetaliczny trzask 1250 Hz i impuls cewki 50 Hz);
  - kroków na drewnianym parkiecie `create_parquet_footstep_sound()` (ciepły rezonans desek 190/310 Hz z mikro-skrzypieniem włókien);
  - odryglowania mechanicznego zamka szuflady `create_drawer_lock_unlatch_sound()` (klik bębenka 950 Hz, ruch rygla mosiężnego 1450 Hz i wysunięcie szuflady 220 Hz);
  - szelestu papierów technicznych `create_paper_rustle_sound()` (wielopasmowy flutter faktury papieru 1120/2840 Hz);
  - gotowania wody w czajniku `create_kettle_boil_sound()` (sub-bas pęcherzyków 85/140/210 Hz z szumem wrzenia);
  - gwizdka pary czajnika `create_kettle_whistle_sound()` (dwuton 1150/1380 Hz z wibrato pary 5.5 Hz);
  - kroków na kafelkach ceramicznych `create_tile_footstep_sound()` (mineralny tap 320/580 Hz z echem łazienkowym);
  - szumu wody w rurach `create_water_pipe_hiss_sound()` (przepływ ciśnieniowy 680/1450 Hz z rezonansem żeliwa i kranu);
  - skrobania szkła `create_glass_scratch_sound()` (ostry świst rylca 2450/3800 Hz ze spękaniami srebra lustrzanego);
  - dysonansu temporalnego lustra `create_mirror_shimmer_sound()` (dwuton 880/987 Hz z mikrodryfem fazowym 0.4 Hz);
  - dzwonka telefonu bakelitowego `create_bakelite_bell_sound()` (dwuton mosiężnych czasz 1020/1240 Hz z modulacją uderzeń 20 Hz);
  - kliku widełek i podniesienia słuchawki `create_handset_pickup_sound()` (850 Hz transient + 180 Hz body);
  - szumu napędu taśmy magnetofonu `create_tape_motor_hum_sound()` (120 Hz hum + flutter 3200 Hz);
  - blipu dialogowego Jakuba Wolskiego `create_dialogue_jakub_blip_sound()` (męski bariton 370 Hz z alikwotami 185/740 Hz i pasmem węglowym);
  - porannej bryzy i szumu świtu `create_morning_ambience_sound()` (filtrowany powiew 70/140 Hz z mikro-chłodem 1800 Hz);
  - wiązki stabilizatora polowego UCP `create_ucp_stabilizer_beam_sound()` (pulsujący ton 520 Hz z mikro-modulacją 8 Hz i sub-harmoniczną 65 Hz);
  - wygładzania i osiadania muru `create_masonry_smooth_sound()` (mineralny rezonans 180->320 Hz z gładkim wygaszeniem tarcia);
  - blipu dialogowego starszej mieszkanki `create_dialogue_elderly_woman_sound()` (drżący ton 310 Hz z rezonansem 155/620 Hz);
  - szumu podziemi tranzytowych `create_subway_hum_sound()` (sub-bas tunelowy 55/110 Hz z rezonansem wnękowym);
  - brzęczenia jarzeniówek i neonów podziemnych `create_neon_flicker_sound()` (120 Hz przydźwięk z jonizacyjnym szmerem 2800 Hz);
  - kliku mechanicznego klawiatury terminala CRT `create_terminal_keypress_sound()` (980 Hz transient z 240 Hz korpusem);
  - gongu podziemnego systemu nagłośnienia PA `create_pa_chime_sound()` (dwuton G5 784 Hz -> D5 587 Hz z pogłosem tunelowym);
  - szumu lampy stołu kreślarskiego `create_drafting_lamp_hum_sound()` (60/120 Hz hum transformatora z 420 Hz ciepłym korpusem);
  - szelestu papieru fotograficznego `create_photo_slide_sound()` (1450/3100 Hz tarcie włókien ze snapem gniazda ramy);
  - szumu cienia na emulsji fotograficznej `create_shadow_whisper_sound()` (dwuton 880 Hz z modulacją 3.5 Hz i szmerem kryształów halogenku srebra);
  - kliku przekaźnika synchronizacji adresu `create_relay_alignment_click_sound()` (1120 Hz snap z 340 Hz echem cewki elektromagnetycznej).
- Zaimplementowano trzynastą lokację Vertical Slice `Station13` (`scripts/levels/station_13.gd`, `scenes/levels/station_13.tscn`) — Przestrzeń 13 z `FULL_STORY.md` (Adres ciągłości / Schemat mieszkania i fotografia Jakuba):
  - kompozycja zaplecza archiwum za przejściem podziemnym (x=0..640, floor y=290) ze ścianami pokrytymi planami architektonicznymi Równi, podświetlanym stołem kreślarskim (`DraftingTable`), stalową szafą kartograficzną (`TopographyIndexCabinet`), ściennym węzłem obwodu rezonansowego (`ResonanceCircuitNode`), optyczną ramą montażową na fotografię Jakuba (`JakubPhotographFrame`) oraz śluzą techniczną (`TechPassageAirlock`);
  - zagadka topograficzna i obwód mieszkania 14: pozycje mebli i sprzętów kodują współrzędne węzła zerowego w Podstrukturze;
  - mechanizm pamięci jako narzędzia i kosztu (Clue R-05): włożenie fotografii Jakuba z własnego świata Leny aktywuje układ i odryglowuje przejście do Przestrzeni 14, lecz na emulsji obok młodego Jakuba powoli narasta dorosły, ciemny cień;
  - pełna sekwencja dialogowa z 9 kwestiami odzwierciedlającymi analizę schematu i koszt tożsamości.
- Zaimplementowano dwunastą lokację Vertical Slice `Station12` (`scripts/levels/station_12.gd`, `scenes/levels/station_12.tscn`) — Przestrzeń 12 z `FULL_STORY.md` (Pokaz bezpieczeństwa / Przejście podziemne i punkt informacyjny UCP).
- Zaimplementowano jedenastą lokację Vertical Slice `Station11` (`scripts/levels/station_11.gd`, `scenes/levels/station_11.tscn`) — Przestrzeń 11 z `FULL_STORY.md` (Pierwsza korekta / Dziedziniec i interwencja UCP).
- Zaimplementowano dziesiątą lokację Vertical Slice `Station10` (`scripts/levels/station_10.gd`, `scenes/levels/station_10.tscn`) — Przestrzeń 10 z `FULL_STORY.md` (Telefon Jakuba / Gabinet domowy i korytarz techniczny).
- Zaimplementowano dziewiątą lokację Vertical Slice `Station09` (`scripts/levels/station_09.gd`, `scenes/levels/station_09.tscn`) — Przestrzeń 09 z `FULL_STORY.md` („Pokój, który nie czeka” / Wnętrze łazienki i korytarz).
- Zaimplementowano ósmą lokację Vertical Slice `Station08` (`scripts/levels/station_08.gd`, `scenes/levels/station_08.tscn`) — Przestrzeń 08 z `FULL_STORY.md` („Mieszkanie po kimś”).
- Zaimplementowano siódmą lokację Vertical Slice `Station07` (`scripts/levels/station_07.gd`, `scenes/levels/station_07.tscn`) — Przestrzeń 07 z `FULL_STORY.md` („Wróciłaś”).
- Zaimplementowano szóstą lokację Vertical Slice `Station06` (`scripts/levels/station_06.gd`, `scenes/levels/station_06.tscn`) — Przestrzeń 06 z `FULL_STORY.md` (Linia zastępcza).
- Zaimplementowano piątą lokację Vertical Slice `Station05` (`scripts/levels/station_05.gd`, `scenes/levels/station_05.tscn`) — Przestrzeń 05 z `FULL_STORY.md` (Rówień nocą).
- Zaimplementowano czwartą lokację Vertical Slice `Station04` (`scripts/levels/station_04.gd`, `scenes/levels/station_04.tscn`) — Przestrzeń 04 z `FULL_STORY.md` (Bramka / Recepcja IKP).
- Zaimplementowano trzecią lokację Vertical Slice `Station03` (`scripts/levels/station_03.gd`, `scenes/levels/station_03.tscn`) — Przestrzeń 03 z `FULL_STORY.md` (Puste laboratorium IKP).
- Zaimplementowano drugą lokację Vertical Slice `Station02` (`scripts/levels/station_02.gd`, `scenes/levels/station_02.tscn`) — Przestrzeń 02 z `FULL_STORY.md` (Komora Pomiarowa IKP).
- Zaimplementowano pierwszą lokację Vertical Slice `Station01` (`scripts/levels/station_01.gd`, `scenes/levels/station_01.tscn`) — Przestrzeń 01 z `FULL_STORY.md` (Sterownia IKP).
- Zaimplementowano klasę punktów rezonansu pamięci `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`) obsługującą 56 typów rekwizytów narracyjnych w świecie gry (w tym `DRAFTING_TABLE`, `TOPOGRAPHY_INDEX_CABINET`, `JAKUB_PHOTOGRAPH_FRAME`, `RESONANCE_CIRCUIT_NODE`, `TECH_PASSAGE_AIRLOCK`).
- Rozszerzono `tests/smoke_test.gd` o automatyczną weryfikację wszystkich lokacji prototypowych i 13 stacji Vertical Slice.
- Wygenerowano zaktualizowane zrzuty kontrolne:
  - `reports/movement_lab.png`
  - `reports/anchor_lab.png`
  - `reports/anchor_lab_ch2.png`
  - `reports/anchor_lab_ch3.png`
  - `reports/anchor_lab_ch3_solved.png`
  - `reports/anchor_lab_ch3_locked.png`
  - `reports/station_01.png`
  - `reports/station_01_active.png`
  - `reports/station_02.png`
  - `reports/station_02_correlation.png`
  - `reports/station_03.png`
  - `reports/station_03_desk.png`
  - `reports/station_04.png`
  - `reports/station_04_bramka.png`
  - `reports/station_05.png`
  - `reports/station_05_crosswalk.png`
  - `reports/station_06.png`
  - `reports/station_06_arrival.png`
  - `reports/station_07.png`
  - `reports/station_07_door.png`
  - `reports/station_08.png`
  - `reports/station_08_desk.png`
  - `reports/station_09.png`
  - `reports/station_09_mirror.png`
  - `reports/station_10.png`
  - `reports/station_10_phone.png`
  - `reports/station_11.png`
  - `reports/station_11_intervention.png`
  - `reports/station_12.png`
  - `reports/station_12_terminal.png`
  - `reports/station_13.png`
  - `reports/station_13_photo.png`

### Kanon kreatywny 0.2

- Protagonistka to Lena Wolska, inzynierka aparatury korelacji prozniowej.
- Akcja rozgrywa sie przez jedna noc i poranek w Rowni, ktora pamieta lokalna
  wersje Leny zaginiona siedemnascie dni wczesniej.
- Rdzen relacyjny tworza Marta Kurek, zywy Jakub Wolski, dr Helena Wierzbicka,
  lokalna Lena jako Slad i Szymon Bera.
- UCP naprawde chroni wspolna historie i realnie ratuje ludzi, ale przenosi
  koszt sprzecznosci na slabo poswiadczone osoby i miejsca.
- Nie istnieje potwierdzona pierwotna galaz. Takze swiat Leny nosi slad korekty.
- Pelna historia ma 43 przestrzenie: Pomiar, Bledy zgodnosci, Korekta,
  Podstruktura i Sygnal powrotu. Akt II jest krotszy o dwie przestrzenie,
  a dowod dobra UCP trafia do Aktu I przed wezwaniem do Punktu 6.
- Trzy pelne rodziny zakonczen to Powrot, Uzgodnienie i Swiadectwo. Zadne nie
  zostalo oznaczone jako dobre, zle ani kanonicznie zwycieskie.
- Tracker wymaga co najmniej trzech poszlak przed kazdym duzym zwrotem i
  pilnuje wiedzy postaci, rekwizytow oraz warunkow finalow. Od `PKG-0007`
  obowiazuje regula pokrycia: wiersz bez cytatu z `FULL_STORY.md` jest zadaniem
  do napisania, nie zapisem stanu.
- Biblia dialogowa odroznia glosy i zawiera 18 scen niosacych glowne zwroty
  emocjonalne, w tym D-16, D-17 i D-18 dla przestrzeni 23, 34 i 39. W pliku
  jest 20 blokow, bo final D-15 ma trzy warianty A/B/C. Nie jest to jeszcze
  pelna lista linii implementacyjnych.
- Raport `docs/narrative/MECHANICS_AUDIT_H-002A.md` obejmuje wszystkie 43
  przestrzenie fizyczne; naglowki 42A–42C sa wariantami jednej przestrzeni.
- Zdarzenie na Linii 4 ma jeden rachunek kanoniczny (D-020): dwanascie nazwisk
  na tablicy odrzuconego wariantu, jedenascioro przeniesionych, jedno utrzymane
  ocalenie. Wierzbicka nie wie, dlaczego utrzymal sie akurat Jakub.
- Przejscie przenosi adres, nie materie (D-021). Cialo i rzeczy Leny sa jej
  wlasne; zmienilo sie to, co swiat o niej twierdzi.
- Gra ma porazke wykonawcza i nie ma porazki narracyjnej (D-019). Uleglosc
  zatwierdza sie wylacznie na granicy sceny.
- Wierzbicka nie umiera w zadnym zakonczeniu (D-022).
- `VISUAL_DESIGN.md` definiuje materialna, informacyjna korekte zamiast
  dekoracyjnego glitchu, palete, sylwetki, kluczowe kadry i test pionowego
  wycinka.

### Wyniki audytu kanonu 0.2 (2026-08-15)

Audyt wykonala sesja bez udzialu w tworzeniu materialu. To jest teraz jedyny
mechanizm kontroli jakosci narracyjnej (R-016).

Rozstrzygniete pomiarem, nie opinia:

- **H-010a: MEASURED po `PKG-0008`.** Ponowny pomiar po przenumerowaniu wykazuje
  trzy zapowiedzi spelniajace wszystkie cztery warunki (sceny 01, 14, 22)
  oraz dwie wspierajace (02, 10). Granica: warunek sciezki obowiazkowej jest
  proxy dla „dostrzegalne", nie dowodem zauwazenia. Zauwazenie to H-010b,
  trwale bez dowodu.
- **H-011a: MEASURED po `PKG-0008`.** Ponowny audyt policzyl cztery sygnaly
  porownawcze i wykazal **0 sygnalow przewagi strukturalnej** dla A, B i C:
  Swiadectwo jest zawsze dostepne, A, B i C maja domkniecia relacji
  Jakub-Wierzbicka, D-14 konczy sie cisza po pytaniu, a trzy epilogi maja ten
  sam obojetny rejestr administracyjny. Regula zlamanego fioletu pozostaje
  swiadomie wizualna i nie wchodzi do licznika. To pomiar kontraktu, nie odbioru.
- **H-002a: REFUTED po `PKG-0009` / PIVOT w ADR-005 (MEASURED w PKG-0011).** Audyt 43 przestrzeni policzyl 5
  odrebnych zastosowan: sceny 14, 20, 22, 33 i 41. Próg został zredukowany do 5. Bramka P2 zrealizowana i zaliczona.

Naprawione w `PKG-0007` - siedem sprzecznosci twardych:

- los Wierzbickiej w finale C (D-022: nie umiera nigdzie);
- rachunek Linii 4 (D-020: 12 nazwisk, 11 przeniesionych, 1 ocalenie);
- wiek Jakuba: 33 lata, smierc w wieku 20 lat trzynascie lat wczesniej;
- wariant instrumentalny finalu B: obowiazuje D-15B, Marta zostaje i odmawia;
- ostatni obraz finalu A: telefon do Marty Kurek;
- ostatni obraz finalu C: tramwaj, dwa tory, zapisany wybor;
- zegar: usunieto „mniej niz pol sekundy", prolog trwa do 22:30.

Dodatkowo zapisano regule 11 w `NARRATIVE_BIBLE` 7 (D-021) i rozstrzygnieto
stan przegranej (D-019).

Naprawione w `PKG-0008`:

- Swiadectwo jest zawsze dostepne; brakujace polaczenia obnizaja stabilnosc
  sieci i sa widoczne w epilogu, bez punktacji dobra;
- koszt finalu C przeniesiono na Slad: jego obecność rozprasza sie
  nieodwracalnie po wezłach zamiast pozostac osobnym glosem;
- domknieto relacje Jakub-Wierzbicka w A i B, usunieto dwie repliki D-14 i
  zostawiono cisze po pytaniu o odwrocenie glowy;
- ujednolicono rejestr trzech epilogow i wykonano jednorazowe przenumerowanie
  43 przestrzeni wedlug D-023: akt I 10, akt II 11, akt III 11, akt IV 4;
- H-010a zmierzono ponownie jako MEASURED (01, 14, 22), a H-011a jako
  MEASURED z wynikiem 0 sygnalow przewagi strukturalnej.

Otwarte, przypisane do kolejnych pakietow:

- `RESEARCH_FOUNDATIONS.md` nie zawiera zadnego zrodla o pamieci, zalobie,
  anomii ani psychologii instytucji - czyli o temacie gry;
- `INSPIRATION_BOUNDARIES.md` zabezpiecza wylacznie przed Another World i nie
  wspomina o Severance ani Control;
- D-014: bramka kanonu w `tools/verify.ps1` - przyjeta, niezaimplementowana.

## Ostatnia swieza weryfikacja

Komenda:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Potwierdzony wynik finalnej weryfikacji PKG-0031:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Kontrakt dokumentacji obejmuje `ADR-001` do `ADR-005` oraz aktualne nagłówki. Bramka weryfikuje istnienie wymaganych dokumentów, brak wiszących placeholderów, poprawne ładowanie klas (`ProceduralAudio`, `AnchorableObject`, `MovableAnchorableProp`, `CinematicCamera`, `AnchorLab`, `PrototypePlayer`, `MemoryResonancePoint`, `Station01`..`Station13`, `DiscontinuousShadow`) oraz test automatyczny kamer, stref komorowych, syntezy dźwięków proceduralnych (w tym kroków na kafelkach ceramicznych, lądowań, uszczelnienia śluzy, rezonansu pamięci, korelacji, szumu próżni, telefonu, czytnika kart, jarzeniówek, odcięcia przekaźnika kamery, odryglowania kołowrotu, blipów dialogowych Leny/Strażnika/Marty/Jakuba/StarszejKobiety, sygnału przejścia z formantowym szeptem imienia Leny, deszczu, trakcji tramwajowej, silnika diesla, komunikatu PA, pneumatyki drzwi, złotej obrączki, skrzypienia drzwi mieszkania, włącznika schodowego, zamka szuflady, szelestu papierów, czajnika, szumu wody, szkła, lustra, telefonu bakelitowego, magnetofonu, porannej bryzy, stabilizatora UCP, wygładzania muru, szumu podziemi tranzytowych, przydźwięku neonów, kliku klawiszy terminala CRT, gongu PA, lampy stołu kreślarskiego, szelestu papieru fotograficznego, szumu cienia na emulsji i przekaźnika synchronizacji adresu), węzłów audio/cząsteczek, fizyki i logiki kotwiczenia oraz pełnego przejścia procedur w `station_01.tscn` .. `station_13.tscn` (weryfikacja analizy stołu kreślarskiego ze schematem mieszkania 14 jako obwodu, kartoteki szafy topograficznej, węzła rezonansowego, włożenia fotografii Jakuba ze starego świata, powolnego narastania dorosłego cienia na emulsji, odryglowania śluzy technicznej i przejścia do strefy `AirlockZone` ku Przestrzeni 14).

Rendery kontrolne zaktualizowane:
- `reports/movement_lab.png`
- `reports/anchor_lab.png`
- `reports/anchor_lab_ch2.png`
- `reports/anchor_lab_ch3.png`
- `reports/anchor_lab_ch3_solved.png`
- `reports/anchor_lab_ch3_locked.png`
- `reports/station_01.png`
- `reports/station_01_active.png`
- `reports/station_02.png`
- `reports/station_02_correlation.png`
- `reports/station_03.png`
- `reports/station_03_desk.png`
- `reports/station_04.png`
- `reports/station_04_bramka.png`
- `reports/station_05.png`
- `reports/station_05_crosswalk.png`
- `reports/station_06.png`
- `reports/station_06_arrival.png`
- `reports/station_07.png`
- `reports/station_07_door.png`
- `reports/station_08.png`
- `reports/station_08_desk.png`
- `reports/station_09.png`
- `reports/station_09_mirror.png`
- `reports/station_10.png`
- `reports/station_10_phone.png`
- `reports/station_11.png`
- `reports/station_11_intervention.png`
- `reports/station_12.png`
- `reports/station_12_terminal.png`
- `reports/station_13.png`
- `reports/station_13_photo.png`

## Czego jeszcze nie potwierdzono

### Nie zostanie potwierdzone nigdy w tym projekcie

Zapisane jawnie, bo to sa twierdzenia, do ktorych projekt **nie ma prawa** i
nie wolno ich uzywac w zadnym dokumencie ani materiale bez etykiety braku
dowodu (D-012, ADR-003, R-015):

- czy ruch jest przyjemny i czy nowa osoba zaczyna bez instrukcji (H-001);
- czy gracz odczyta niezgodnosc swiata z akcji, bez ekspozycji (H-003);
- czy rzadkie zagrozenia utrzymaja napiecie przez 2-3 godziny (H-004);
- czy Uleglosc bedzie kuszaca, a nie odbierana jak zla opcja (H-006);
- czy brak HUD-u nie pogorszy czytelnosci stanu (H-007);
- czy Marta i Jakub uniosa rdzen emocjonalny - najdrozsze przyjete ryzyko
  projektu (H-008);
- czy UCP bedzie odbierane jednoczesnie jako skuteczne i krzywdzace (H-009b);
- czy zwrot zaskakuje (H-010b);
- czy kazdy final ma obroncow i rozpoznany koszt (H-011b).

### Mozliwe do potwierdzenia i jeszcze niezrobione

- czytelnosc kluczowych elementow w 640x360 na realnym renderze (H-012);
- rownowaga dowodow na skutecznosc i krzywde UCP w tekscie (H-009a);
- zmierzony koszt jednego finalnego kadru i animacji protagonisty (H-005) -
  jedyne kryterium rozstrzygajace o wykonalnosci calego projektu;
- H-011a jest zmierzone po `N0.2-C`; H-010a zmierzone ponownie po
  przenumerowaniu; H-002a ma status `MEASURED`.

### Nadal niewykonane

- 43 przestrzenie i 2-3 godziny nie maja budzetu produkcyjnego.
- Nie ma finalnych dialogow implementacyjnych, voice-overu ani lokalizacji.
- Nie sprawdzono tytulu handlowego ani praw przed publikacja.

## Znane ograniczenia techniczne i produkcyjne

- Automatyczne testy potwierdzaja kontrakty plikow, generowanie buforów audio, zachowanie kamery kinowej, grayboxu oraz logikę kotwiczenia, pchania skrzyń, pełnego przejścia 3 komór `AnchorLab`, procedury startowej `Station01`, procedury pomiaru w `Station02`, badania śladów niezgodności w `Station03`, dialogu i mechaniki kołowrotu w `Station04`, transformacji geometrii zaułka i sygnalizatora w `Station05`, ruchu autobusu i dialogu pasażera w `Station06`, klatki schodowej i dialogu D-02 w `Station07`, wnętrza mieszkania 14 w `Station08`, łazienki z opóźnionym lustrem, inskrypcją `NIE SZUKAJ ORYGINAŁU`, dialogiem D-03 i stabilizacją korytarza w `Station09`, domowego gabinetu z dzwoniącym telefonem, dialogiem D-04 z Jakubem w `Station10`, dziedzińca z interwencją UCP w `Station11`, przejścia podziemnego z nakładającymi się schodami, ewakuacją dziecka i terminalem autoryzacji w `Station12` oraz zaplecza archiwum z obwodem mieszkania 14, włożeniem zdjęcia Jakuba, pojawieniem się dorosłego cienia i odryglowaniem śluzy technicznej w `Station13`, nie subiektywną satysfakcję (game feel) gracza.
- `DOCS PASS` sprawdza istnienie plikow i obecnosc naglowkow.
- Cofanie jest ograniczone do snapshotów (`tools/snapshot.ps1`).

## Nastepny pakiet

`PKG-0032: P3 Vertical Slice — Zakotwiczenie (Przestrzeń 14 / Schowek techniczny, rysa w metalu i degradacja nagrania)`

Cel: Kontynuacja Aktu II fabuły per `FULL_STORY.md` i implementacja Przestrzeni 14 (Zakotwiczenie / Schowek techniczny za ścianą mieszkania, trzymanie szwu i degradacja głosu Jakuba na nagraniu):
- Schowek techniczny za ścianą mieszkania: ciasna przestrzeń serwisowa z instalacją węzłową Podstruktury, drgającą architekturą i przełączającymi się wariantami geometrii.
- Mechanika Zakotwiczenia w narracji: utrzymanie jednego obserwowanego szczegółu — rysy w metalu szyny nośnej (`ScratchInMetalAnchor`) — podczas gdy reszta pomieszczenia ulega przestawieniu pod wpływem fali korekty.
- Rekwizyt odtwarzacza magnetofonowego i poszlaka R-05: przedmiot użyty jako kotwica traci część prywatnego znaczenia — głos Jakuba na starym nagraniu ulega zatarciu / degradacji, a w 3. sekundzie odsłuchu ujawnia się pierwotna cisza, dowodząca że świat wyjściowy Leny również nosił ślady wcześniejszej korekty.
- Nowe dźwięki proceduralne w `ProceduralAudio` (metal scratch stress chime, tape voice degradation filter, spatial flutter hiss, mechanical seam clamp).
- Nowe typy rekwizytów w `MemoryResonancePoint` (PropType 57..61).
- Rozszerzenie testów `smoke_test.gd` i rendering podglądów `reports/station_14.png`.

Pakiet jest realizowany w 100% autonomicznie przez AI.

## Punkt przekazania

Nowa sesja zaczyna od swiezej weryfikacji (`tools/verify.ps1`), czyta `AGENTS.md`, `INDEX.md`, ten
plik i `NEXT_SESSION_PROMPT.md`, a nastepnie przechodzi do realizacji PKG-0032.







