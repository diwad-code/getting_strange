# Aktualny stan projektu

Stan na: 2026-08-20

## Katalog i srodowisko

- Katalog: `C:\getting_strange`
- Godot: `4.7.stable.official.5b4e0cb0f`
- Platforma robocza: Windows, PowerShell 7
- Narzędzia generatywne: Picsart AI CLI (`gen-ai`, uwierzytelniony dostęp do generacji obrazów, wideo i audio)
- **Wersjonowanie: brak (D-016).** Pliki na dysku sa jedynym stanem projektu.
  Nie ma repozytorium, galezi, commita ani historii. Nie uruchamiamy `git`. Ostatni zamkniety pakiet: `PKG-0034`, 2026-08-20
- Kronika pakietow: `SESSION_LOG.md` - jedyna historia, append-only
- Zamrozenia: `snapshots/PKG-NNNN-DATA/` przez `tools/snapshot.ps1` (D-017);
  ostatnie: `snapshots/PKG-0034-2026-08-20`

Do PKG-0005 wlacznie projekt byl wersjonowany. W `PKG-0006` usunieto `.git`,
`.gitignore` i `.gitattributes`. Ta historia nie istnieje juz w formie
odtwarzalnej; kazdy stan sprzed `PKG-0006` jest opisany wylacznie w
`SESSION_LOG.md`. Nie powoluj sie na commity - nie da sie ich sprawdzic.

## Aktywna faza

Faza **`P3 / Vertical Slice`** została **OTWARTA I JEST W TOKU** (PKG-0019, postęp: Przestrzenie 01..16 wdrożone — Akt I w pełni domknięty, Akt II rozwijany w silniku: Scena 16 Rozmowa przy stole). Faza P2 (Anchor Lab) zakończona i zaliczona.

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

- Projekt Godot 640x360 uruchamia sceny prototypowe `scenes/prototype/movement_lab.tscn`, `scenes/prototype/anchor_lab.tscn` oraz sceny Vertical Slice: pierwszą lokację `scenes/levels/station_01.tscn`, Komorę Pomiarową `scenes/levels/station_02.tscn`, Puste Laboratorium `scenes/levels/station_03.tscn`, Recepcję/Bramkę IKP `scenes/levels/station_04.tscn`, Rówień nocą `scenes/levels/station_05.tscn`, Wnętrze autobusu zastępczego `scenes/levels/station_06.tscn`, Klatkę schodową na Osiedlu Tarasowym `scenes/levels/station_07.tscn`, Wnętrze mieszkania 14 `scenes/levels/station_08.tscn`, Łazienkę i korytarz `scenes/levels/station_09.tscn`, Telefon Jakuba / Gabinet domowy `scenes/levels/station_10.tscn`, Pierwszą korektę / Dziedziniec i interwencję UCP `scenes/levels/station_11.tscn`, Pokaz bezpieczeństwa / Przejście podziemne i punkt informacyjny UCP `scenes/levels/station_12.tscn`, Adres ciągłości / Zaplecze archiwum `scenes/levels/station_13.tscn`, Zakotwiczenie / Schowek techniczny `scenes/levels/station_14.tscn`, Korytarz serwisowy / Pismo lokalnej Leny i odwrócone odbicie `scenes/levels/station_15.tscn` oraz Rozmowa przy stole / Mieszkanie 14, pęknięta filiżanka Marty, dowody i wybór z obrączką `scenes/levels/station_16.tscn`.
- `PrototypePlayer` uzywa `CharacterBody2D`.
- Ruch ma coyote time, bufor skoku, zmienna wysokosc skoku, szybsze opadanie
  i limit predkosci spadania.
- Profile A/B/C laduja sie z `resources/movement/`, a A zachowuje bazowe liczby.
- A/B/C roznia sie tylko czterema parametrami reakcji poziomej.
- Zaimplementowano w `scripts/audio/procedural_audio.gd` generator proceduralnego audio produkujący 16-bitowe strumienie `AudioStreamWAV` dla:
  - tonów kotwiczenia (740 Hz), odkotwiczenia (660->330 Hz), fali korekty (92->44 Hz) oraz oporu/kolizji fali (587/622 Hz);
  - kroków na podłożu laboratoryjnym (linoleum/beton 180 Hz) vs metalowym (blacha stalowa 820/1640 Hz);
  - lądowania z upadku (3-fazowy impakt 95 Hz z tłumieniem);
  - ryglowania i uszczelnienia śluzy Goal (pneumatyczny syk + metalowy rygiel);
  - rezonansu pamięci `create_memory_resonance_sound()` (220 Hz z powolną modulacją i alikwotami);
  - przełączników hebelkowych `create_switch_toggle_sound()` (mechaniczny klik 1250 Hz);
  - korelacji próżniowej `create_vacuum_hum_sound()` (niski sub-bas 48 Hz z rezonansem wnękowym 96 Hz);
  - szumu korelacji optycznej `create_correlation_hum_sound()` (dwuton 440/444 Hz z dudnieniem 4 Hz);
  - drukarki taśmowej `create_printer_step_sound()` (mechaniczny krok igły 850 Hz z szelestem papieru);
  - igły galwanometru `create_needle_scratch_sound()` (dyskretny impuls 1800 Hz);
  - kroków na posadzce laboratoryjnej `create_footstep_lab_tile_sound()` (220 Hz transient z 680 Hz rezonansem);
  - aparatu telefonicznego `create_telephone_ring_sound()` (podwójny mechaniczny dzwonek 1050/1200 Hz z modulacją 25 Hz);
  - czytnika identyfikatorów `create_card_swipe_sound()` (szum optyczny 1400 Hz z potwierdzeniem 880 Hz);
  - jarzeniówek laboratoryjnych `create_fluorescent_flicker_sound()` (przydźwięk 100 Hz z jonizacją 3200 Hz);
  - zrzutu zasilania kamery `create_camera_shutter_sound()` (elektromagnes 420 Hz z uderzeniem migawki 2100 Hz);
  - kołowrotu wejściowego `create_turnstile_click_sound()` (masywna zapadka 320 Hz z kliknięciem 1600 Hz);
  - blipów dialogowych Leny Wolskiej `create_dialogue_lena_blip_sound()` (ton 440 Hz z alikwotami 880/1320 Hz);
  - blipów dialogowych Strażnika `create_dialogue_guard_blip_sound()` (basowy ton 190 Hz z szumem 380 Hz);
  - akustycznego sygnalizatora przejścia `create_crosswalk_beacon_sound()` (dwutonowy puls 880/1760 Hz z szeptem imienia Leny);
  - deszczu na mokrym asfalcie `create_rain_ambient_sound()` (różowy szum 250..4500 Hz);
  - trakcji tramwajowej i iskry pantografu `create_tram_traction_sound()` (przydźwięk 50/100 Hz z iskrzeniem 3400 Hz);
  - silnika diesla autobusu miejskiego `create_diesel_engine_sound()` (praca 4-cylindrowego silnika 28 Hz z rezonansem nadwozia);
  - deszczu na szybach autobusu `create_rain_window_sound()` (perkusyjne uderzenia kropel 1200..3800 Hz);
  - pokładowego komunikatu głośnikowego PA `create_bus_pa_chime_sound()` (dwuton C5 523 Hz -> G4 392 Hz);
  - pneumatyki drzwi autobusu `create_bus_door_pneumatic_sound()` (rozprężenie powietrza 2200 Hz ze stukiem ramy 180 Hz);
  - złotej obrączki upadającej na podłogę `create_gold_ring_chime_sound()` (krystaliczny rezonans 2349 Hz z mikro-wibracją 4698 Hz);
  - kroków na lastryku klatki schodowej `create_footstep_terrazzo_sound()` (jasny transient 340 Hz z echem 1250 Hz);
  - zawiasów drzwi mieszkania `create_door_creak_sound()` (tarcie żeliwa 280..620 Hz);
  - blipów dialogowych Marty Kurek `create_dialogue_marta_blip_sound()` (ton 520 Hz z alikwotami 1040/1560 Hz);
  - włącznika schodowego z neonówką `create_staircase_switch_sound()` (klik bimetalu 1400 Hz z zajarzeniem neonówki 85 Hz);
  - kroków na parkiecie dębowym `create_footstep_parquet_sound()` (drewniany stuk 140 Hz z rezonansem 480 Hz);
  - zamka szyfrowego szuflady biurka `create_drawer_lock_sound()` (trzybębenkowy mechanizm 750/1200 Hz z metalicznym snapem);
  - szelestu papierów i notatek `create_paper_rustle_sound()` (tarcie celulozy 800..3200 Hz);
  - gotowania i gwizdka czajnika `create_kettle_whistle_sound()` (parowy świst 1680 Hz z bąbelkowaniem 120 Hz);
  - kroków na kafelkach ceramicznych `create_footstep_ceramic_tile_sound()` (twardy impuls 380 Hz z echem 1450 Hz);
  - szumu rur i instalacji wodnej `create_pipe_water_hum_sound()` (przepływ 65/130 Hz z rezonansem żeliwa 380 Hz);
  - skrobania szkła i inskrypcji `create_glass_scratch_sound()` (wysokie tarcie 2900..5800 Hz);
  - shimmru anomalnego lustra `create_mirror_shimmer_sound()` (flanger 440 Hz ze wsteczną fazą 0.5 Hz);
  - dzwonka telefonu bakelitowego `create_bakelite_telephone_ring_sound()` (podwójny gong 920/1080 Hz z mechaniczną przerwą);
  - kliku słuchawki bakelitowej `create_handset_lift_sound()` (masywny snap 540 Hz z rozłączeniem 1600 Hz);
  - szumu silnika magnetofonu szpulowego `create_reel_motor_hum_sound()` (obrót 38 Hz z harmoniczną 76 Hz i świstem taśmy 4200 Hz);
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
  - kliku przekaźnika synchronizacji adresu `create_relay_alignment_click_sound()` (1120 Hz snap z 340 Hz echem cewki elektromagnetycznej);
  - rezonansu kotwiczenia rysy w metalu `create_metal_scratch_chime_sound()` (740 Hz F#5 z harmoniczną 1480 Hz i tarciem 2400 Hz);
  - filtru degradacji nagrania taśmowego `create_tape_degradation_filter_sound()` (pasmo wokalne 300..1800 Hz z kołysaniem 12 Hz i szmerem magnetycznym);
  - docisku stabilizatora szwu `create_seam_clamp_sound()` (ciśnienie hydrauliczne 140 Hz z uderzeniem rygla 280/840 Hz i snapem 1650 Hz);
  - szumu wiatru szybu Podstruktury `create_conduit_shaft_wind_sound()` (głęboki ciąg powietrzny 45/90 Hz z aerodynamicznym gwizdem 1600 Hz);
  - kroków na ażurowej kładce stalowej `create_catwalk_footstep_sound()` (620/1440 Hz z rezonansem kratownicy);
  - kapania wody w kałużę techniczną `create_water_drip_puddle_sound()` (1150/2300 Hz z wilgotnym echem);
  - szumu parowego zaworu dekompresyjnego `create_pressure_valve_release_sound()` (800..4200 Hz z mechanicznym snapem zapadki);
  - impulsu rezonansu magistrali przesyłowej `create_resonance_pulse_sound()` (52 Hz z dudnieniem 3 Hz);
  - stuknięcia ceramicznej filiżanki `create_ceramic_cup_clink_sound()` (rezonans porcelany 1450/2900 Hz z szybkim transientem);
  - nalewania herbaty i pary `create_tea_pour_steam_sound()` (strumień cieczy 350..1600 Hz z oddechem pary);
  - tykania zegara kuchennego `create_kitchen_clock_tick_sound()` (podwójny mechaniczny klik 820/640 Hz z obudową 210 Hz);
  - przewracania kart teczki poszlak `create_dossier_paper_turn_sound()` (tarcie tektury i papieru 700..3400 Hz z zagięciem karty).
- Zaimplementowano szesnastą lokację Vertical Slice `Station16` (`scripts/levels/station_16.gd`, `scenes/levels/station_16.tscn`) — Przestrzeń 16 z `FULL_STORY.md` (Rozmowa przy stole / Mieszkanie 14, pęknięta filiżanka Marty, katalogowanie dowodów R-01..R-06 i wybór z obrączką):
  - kompozycja kuchni mieszkania 14 nocą (x=0..640, floor y=320) z ciepłym stożkiem światła lampy wiszącej, nocnym oknem na Osiedle Tarasowe, szafkami kuchennymi, zegarem ściennym (`KitchenClock`), pękniętą i klejoną filiżanką Marty (`CrackedTeaCup`), teczką z zebranymi poszlakami R-01..R-06 (`CorrelationDossier`), podstawkiem ze złotą obrączką (`WeddingRingStand`) oraz drzwiami balkonowymi (`BalconyExitDoor`);
  - pełna implementacja sceny dialogowej D-05 z `DIALOGUE_SCRIPT.md` (13 kwestii: Lena, Marta, Świadectwo Pamięci) o wspólnej przeszłości, chronologii dat, wypływającym na ceratę kleju technicznym i statusie małżeńskim;
  - interaktywny wybór dyspozycji obrączki (`ring_disposition`): `leave` (pozostawienie na stole — domyślna linia D-05), `wear` (założenie na palec) oraz `sample` (pobranie jako próbka zerowa do kieszeni), wpływający na stan `CONTINUITY_TRACKER.md`;
  - odryglowanie wyjścia balkonowego i przejście przez `AirlockZone` ku Przestrzeni 17 (Ucieczka po gzymsie).
- Zaimplementowano piętnastą lokację Vertical Slice `Station15` (`scripts/levels/station_15.gd`, `scenes/levels/station_15.tscn`) — Przestrzeń 15 z `FULL_STORY.md` (Korytarz serwisowy / Pismo lokalnej Leny, instrukcje higieny ciągłości i odwrócona strzałka w odbiciu kałuży).
- Zaimplementowano czternastą lokację Vertical Slice `Station14` (`scripts/levels/station_14.gd`, `scenes/levels/station_14.tscn`) — Przestrzeń 14 z `FULL_STORY.md` (Zakotwiczenie / Schowek techniczny, rysa w metalu i degradacja nagrania).
- Zaimplementowano trzynastą lokację Vertical Slice `Station13` (`scripts/levels/station_13.gd`, `scenes/levels/station_13.tscn`) — Przestrzeń 13 z `FULL_STORY.md` (Adres ciągłości / Schemat mieszkania i fotografia Jakuba).
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
- Zaimplementowano klasę punktów rezonansu pamięci `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`) obsługującą 71 typów rekwizytów narracyjnych w świecie gry (w tym `CRACKED_TEA_CUP`, `CORRELATION_DOSSIER`, `KITCHEN_CLOCK`, `WEDDING_RING_STAND`, `BALCONY_EXIT_DOOR`).
- Rozszerzono `tests/smoke_test.gd` o automatyczną weryfikację wszystkich lokacji prototypowych i 16 stacji Vertical Slice.
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
  - `reports/station_14.png`
  - `reports/station_14_anchored.png`
  - `reports/station_15.png`
  - `reports/station_15_reflection.png`
  - `reports/station_16.png`
  - `reports/station_16_choice.png`

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

Potwierdzony wynik finalnej weryfikacji PKG-0033:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
FACILITATOR PROFILE A/B/C: MOVEMENT PROFILE CHECK PASS
INVALID PROFILE EXIT: 2
CAPTURE PASS: C:/getting_strange/reports/movement_lab.png
Verification passed.
```

Kontrakt dokumentacji obejmuje `ADR-001` do `ADR-005` oraz aktualne nagłówki. Bramka weryfikuje istnienie wymaganych dokumentów, brak wiszących placeholderów, poprawne ładowanie klas (`ProceduralAudio`, `AnchorableObject`, `MovableAnchorableProp`, `CinematicCamera`, `AnchorLab`, `PrototypePlayer`, `MemoryResonancePoint`, `Station01`..`Station15`, `DiscontinuousShadow`) oraz test automatyczny kamer, stref komorowych, syntezy dźwięków proceduralnych (w tym kroków na kafelkach ceramicznych, kładce stalowej, lądowań, uszczelnienia śluzy, rezonansu pamięci, korelacji, szumu próżni, telefonu, czytnika kart, jarzeniówek, odcięcia przekaźnika kamery, odryglowania kołowrotu, blipów dialogowych Leny/Strażnika/Marty/Jakuba/StarszejKobiety, sygnału przejścia z formantowym szeptem imienia Leny, deszczu, trakcji tramwajowej, silnika diesla, komunikatu PA, pneumatyki drzwi, złotej obrączki, skrzypienia drzwi mieszkania, włącznika schodowego, zamka szuflady, szelestu papierów, czajnika, szumu wody, szkła, lustra, telefonu bakelitowego, magnetofonu, porannej bryzy, stabilizatora UCP, wygładzania muru, szumu podziemi tranzytowych, przydźwięku neonów, kliku klawiszy terminala CRT, gongu PA, lampy stołu kreślarskiego, szelestu papieru fotograficznego, szumu cienia na emulsji, przekaźnika synchronizacji adresu, dzwonka metalowej rysy, filtra degradacji głosu na taśmie, docisku szwu, szumu szybu Podstruktury, kapania wody w kałużę, dekompresji zaworu parowego i pulsu rezonansu magistrali), węzłów audio/cząsteczek, fizyki i logiki kotwiczenia oraz pełnego przejścia procedur w `station_01.tscn` .. `station_15.tscn` (weryfikacja instrukcji higieny ciągłości, odręcznego wzoru korelacji Leny z otwartą cyfrą 4, asynchronicznego wektora w odbiciu kałuży, upustu ciśnienia zaworem parowym i odryglowania bramy tranzytowej ku Przestrzeni 16).

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
- `reports/station_14.png`
- `reports/station_14_anchored.png`
- `reports/station_15.png`
- `reports/station_15_reflection.png`

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

- Automatyczne testy potwierdzaja kontrakty plikow, generowanie buforów audio, zachowanie kamery kinowej, grayboxu oraz logikę kotwiczenia, pchania skrzyń, pełnego przejścia 3 komór `AnchorLab`, procedury startowej `Station01`, procedury pomiaru w `Station02`, badania śladów niezgodności w `Station03`, dialogu i mechaniki kołowrotu w `Station04`, transformacji geometrii zaułka i sygnalizatora w `Station05`, ruchu autobusu i dialogu pasażera w `Station06`, klatki schodowej i dialogu D-02 w `Station07`, wnętrza mieszkania 14 w `Station08`, łazienki z opóźnionym lustrem, inskrypcją `NIE SZUKAJ ORYGINAŁU`, dialogiem D-03 i stabilizacją korytarza w `Station09`, domowego gabinetu z dzwoniącym telefonem, dialogiem D-04 z Jakubem w `Station10`, dziedzińca z interwencją UCP w `Station11`, przejścia podziemnego z nakładającymi się schodami, ewakuacją dziecka i terminalem autoryzacji w `Station12`, zaplecza archiwum z obwodem mieszkania 14, włożeniem zdjęcia Jakuba i pojawieniem się dorosłego cienia w `Station13`, schowka technicznego z kotwiczeniem rysy, degradacją głosu na taśmie, poszlaką ciszy w 3. sekundzie i odryglowaniem szybu Podstruktury w `Station14` oraz korytarza serwisowego z instrukcją higieny, pismem Leny, odwróconym odbiciem kałuży, upustem ciśnienia i odryglowaniem bramy w `Station15`, nie subiektywną satysfakcję (game feel) gracza.
- `DOCS PASS` sprawdza istnienie plikow i obecnosc naglowkow.
- Cofanie jest ograniczone do snapshotów (`tools/snapshot.ps1`).

## Nastepny pakiet

`PKG-0034: P3 Vertical Slice — Rozmowa przy stole (Przestrzeń 16 / Powrót do mieszkania 14, pęknięta filiżanka Marty, katalogowanie dowodów i wybór z obrączką)`

Cel: Kontynuacja Aktu II fabuły per `FULL_STORY.md` i implementacja Przestrzeni 16 (Rozmowa przy stole / Mieszkanie 14 nocą, konfrontacja faktów i wybór):
- Powrót do mieszkania 14 w zmienionym stanie nocnym (stół w kuchni, zaparzona herbata w pękniętej filiżance Marty, rozłożone notatki i schematy korelacyjne).
- Kluczowa scena dialogowa D-05 per `DIALOGUE_SCRIPT.md` (Lena vs Marta Kurek: ujawnienie dowodów zebranych w przestrzeniach 08..15 — rysa w metalu, degradacja głosu Jakuba na taśmie, odwrócone wektory i pismo lokalnej Leny w węźle UCP).
- Interaktywny wybór narracyjny (decyzja Leny: założenie / zdjęcie złotej obrączki ślubnej jako deklaracja wierności pamięci Jakuba vs akceptacja nowej wersji rzeczywistości).
- Nowe syntezy dźwiękowe w `ProceduralAudio` (stuk ceramicznej pękniętej filiżanki o spodek, siorbanie/nalewanie herbaty, tykanie ściennego zegara kuchennego z nieregularnym taktem, szelest fotografii na ceracie stołu).
- Nowe typy rekwizytów w `MemoryResonancePoint` (PropType 67..71).
- Rozszerzenie testów w `smoke_test.gd` i rendering podglądów `reports/station_16.png`.

Pakiet jest realizowany w 100% autonomicznie przez AI.

## Punkt przekazania

Nowa sesja zaczyna od swiezej weryfikacji (`tools/verify.ps1`), czyta `AGENTS.md`, `INDEX.md`, ten
plik i `NEXT_SESSION_PROMPT.md`, a nastepnie przechodzi do realizacji PKG-0034.







