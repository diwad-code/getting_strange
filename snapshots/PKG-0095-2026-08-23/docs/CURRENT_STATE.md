# Aktualny stan projektu

Stan na: 2026-08-23

## Katalog i srodowisko

- Katalog: `C:\getting_strange`
- Godot: `4.7.stable.official.5b4e0cb0f`
- Platforma robocza: Windows, PowerShell 7
- Narzędzia generatywne: Picsart AI CLI (`gen-ai`, uwierzytelniony dostęp do
  obrazów, wideo i audio); właściciel zatwierdził aktywne użycie dużego budżetu
  kredytowego do produkcji i eksploracji assetów zgodnie z D-092 oraz regułami
  autorstwa/IP w `TECHNICAL_DIRECTION.md` i `VISUAL_DESIGN.md`.
- **Wersjonowanie: brak (D-016).** Pliki na dysku sa jedynym stanem projektu.
-   Nie ma repozytorium, galezi, commita ani historii. Nie uruchamiamy `git`. Ostatni zamkniety pakiet: `PKG-0095`, 2026-08-23
- Kronika pakietow: `SESSION_LOG.md` - jedyna historia, append-only
- Zamrozenia: `snapshots/PKG-NNNN-DATA/` przez `tools/snapshot.ps1` (D-017);
-   ostatnie: `snapshots/PKG-0095-2026-08-23`

Do PKG-0005 wlacznie projekt byl wersjonowany. W `PKG-0006` usunieto `.git`,
`.gitignore` i `.gitattributes`. Ta historia nie istnieje juz w formie
odtwarzalnej; kazdy stan sprzed `PKG-0006` jest opisany wylacznie w
`SESSION_LOG.md`. Nie powoluj sie na commity - nie da sie ich sprawdzic.

## Aktywna faza

Faza **`P4: Produkcja i Szlif Gry w Silniku Godot 4.7 (Pure Godot Game Focus, D-089, D-091)`**.
**Jedynym torem produkcyjnym jest gra Godot 4.7.** Decyzja D-090 (priorytet portalu web) została **uchylona jako błąd interpretacji** (D-090 = RETIRED); polecenie „proszę tworzyć stronę" dotyczyło ukończenia **gry**, nie portalu. Portal Web (`web/`) jest zamrożony i nie rozwijany — D-091 zamyka tor webowy i kieruje 100% mocy na ukończenie gry. Pakiety PKG-0089/0090 pozostają na dysku jako artefakt historyczny. Szlif gry w silniku Godot 4.7 obejmuje:
- Szlif sterowania, fizyki i odczucia ruchu (`PrototypePlayer`, coyote time, jump buffering, squash-and-stretch, cząsteczki kurzu i lądowań);
- Oprawa wizualna i oświetlenie 2D 43 poziomów fabularnych (`Station01`..`Station43`, `PointLight2D`, cienie, mgła wolumetryczna, styl 1978 PRL/IKP);
- Interfejs dialogowy i narracyjny w grze (ramki CRT/Teletype, portrety postaci, maszyna do pisania, synteza głosu);
- Mechaniki zagadek środowiskowych (dwustanowe kotwice, przesuwanie skrzyń, rekwizyty pamięci);
- Pełna pętla gry (Menu Główne, ekran pauzy, system punktów kontrolnych/zapisu i płynne przejście do 3 finałów oraz epilogu).

Od PKG-0093 obowiązuje D-092: własny **Rówień Vector-Stage** zastępuje wszystkie
pozostałe deklaracje pixel artu. Technika wykorzystuje płaskie płaszczyzny,
ograniczoną paletę i sceniczne kadrowanie; odniesienie do *Another World / Out
of This World* dotyczy wyłącznie ogólnej dyscypliny wielokątów i rytmu ruchu,
nigdy kopii chronionej ekspresji.


Model dowodu calego projektu zmienil sie 2026-08-15. Zewnetrzne playtesty i
czytania stolikowe nie odbeda sie (D-012, ADR-003). Bramki P1, P2, P3 i N1
zostaly przepisane na pomiar obiektywny i audyt kontraktu. Kazda z nich
wymienia jawnie, czego nie sprawdza.

Prowadzenie kanonu, kierunku wizualnego i dokumentow zarzadczych zostalo w pelni przekazane sztucznej inteligencji (AI - Antigravity) jako Lead Programmer i Art Director (D-025, D-085, ADR-004), znoszac koniecznosc eskalacji, co nadpisuje D-018. Runtime, Prototype 02, Vertical Slice, Portal Web oraz tryb Wysokoprzepustowych Mega-Pakietów (2x–5x Batch Size) znajduja sie pod wylaczna jurysdykcja AI.


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

- Projekt Godot 640x360 uruchamia sceny prototypowe `scenes/prototype/movement_lab.tscn`, `scenes/prototype/anchor_lab.tscn` oraz wszystkie 43 lokacje Vertical Slice: Station 01..41, `scenes/levels/station_42a.tscn` (Powrót — Własny pokój), `scenes/levels/station_42b.tscn` (Uzgodnienie — Miejsce po niej), `scenes/levels/station_42c.tscn` (Świadectwo — Dwie prawdy) oraz `scenes/levels/station_43.tscn` (Napisy i epilog systemowy).
- `PrototypePlayer` uzywa `CharacterBody2D`.
- Ruch ma coyote time, bufor skoku, zmienna wysokosc skoku, szybsze opadanie
  i limit predkosci spadania.
- Profile A/B/C laduja sie z `resources/movement/`, a A zachowuje bazowe liczby.
- A/B/C roznia sie tylko czterema parametrami reakcji poziomej.
- Zaimplementowano w `scripts/audio/procedural_audio.gd` generator proceduralnego audio produkujący 16-bitowe strumienie `AudioStreamWAV` dla wszystkich dźwięków otoczenia, interakcji, maszyn i epilogu (ponad 80 unikalnych generatorów syntezy modularnej).
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
  - przewracania kart teczki poszlak `create_dossier_paper_turn_sound()` (tarcie tektury i papieru 700..3400 Hz z zagięciem karty);
  - pobrania biletu kolejkowego `create_dispenser_ticket_sound()` (silnik krokowy podajnika 360/720 Hz ze ścięciem gilotyny i naderwaniem perforacji);
  - gongu wywoławczego gabinetu UCP `create_clinic_intercom_chime_sound()` (trzytonowy dzwonek F5 698.46 Hz -> A5 880.0 Hz -> C6 1046.5 Hz z ceramicznym echem);
  - ssania tuby pneumatycznej `create_pneumatic_tube_whoosh_sound()` (aerodynamiczny świst 120/2800 Hz ze stukiem mosiężnej kapsuły);
  - drukarki diagnostycznej dr Wierzbickiej `create_wierzbicka_printer_sound()` (głowica igłowa 720/1440 Hz o kadencji 18 kroków/s);
  - galwanometru sensorycznego `create_sensory_galvanometer_tick_sound()` (1650 Hz tick + 380 Hz spring-mass damping, Scene 18);
  - naprężeń Podstruktury `create_substructure_strain_groan_sound()` (34/68 Hz sub-bas + 220 Hz żeliwo + 560 Hz creak, Scene 18);
  - węzła mapy sensorycznej `create_map_node_pulse_sound()` (880 Hz A5 + cyan shimmer 2.8 Hz, Scene 18);
  - pieczęci zatwierdzenia dr Wierzbickiej `create_wierzbicka_stamp_sound()` (420 Hz rubber + 1200 Hz snap + 90 Hz thud, Scene 18);
  - rezonansu stołu modeli `create_model_table_resonance_sound()` (528 Hz C5 ze zdublowanym biciem 4 Hz i cyan shimmerem, Scene 19);
  - szelestu schematów architektonicznych `create_paper_map_rustle_sound()` (900..3600 Hz tarcie celulozy ze snapem, Scene 19);
  - przewracania kart rejestru 11 osób `create_ledger_page_turn_sound()` (700..2800 Hz tarcie z 440 Hz zagięciem karty, Scene 19);
  - odryglowania wyjścia do Sali Szymona `create_model_room_door_release_sound()` (680 Hz suw rygla + 1340 Hz snap zapadki, Scene 19);
  - szelestu papieru rysunkowego z kredkowym zatarciem `create_crayon_drawing_rustle_sound()` (600..2400 Hz tarcie wosku i celulozy, Scene 20);
  - stłumionego echa kapania wody w głębokiej studni `create_well_water_drip_sound()` (160 Hz sub-bas + 480 Hz komorowy pogłos, Scene 20);
  - drżącego głosu Szymona Bery `create_szymon_dialogue_blip_sound()` (260 Hz ton podstawowy z modulacją 3.5 Hz i alikwotami 520/780 Hz, Scene 20);
  - mechanicznego przesunięcia ramy drzwi `create_door_creak_shift_sound()` (220/440 Hz tarcie żelaza z 180 Hz strukturalnym stukiem, Scene 20);
  - skanu biometrycznego bramki tożsamości `create_biometric_gate_scan_sound()` (480->1920 Hz sweep z ziarnem optycznym i dzwonkiem potwierdzenia 880 Hz, Scene 22);
  - humu kineskopów i szumu rastra CCTV `create_cctv_static_hum_sound()` (60/120 Hz przydźwięk sieciowy + 15.6 kHz flyback + szmer rastra 820..4400 Hz, Scene 24);
  - syreny narastających naprężeń korekty `create_correction_stress_siren_sound()` (modulowany sweep 880->1760 Hz z pulsem 8 Hz i trzaskami cynobru, Scene 24);
  - interkomu transmisyjnego dr Wierzbickiej `create_intercom_wierzbicka_tone_sound()` (dwuton 440/1100 Hz z saturacją mikrofonu węglowego, Scene 24);
  - zapadki wyboru dyspozycji Leny `create_decision_button_latch_sound()` (320 Hz zapadka bębenkowa + 1400 Hz mosiężny snap i trzask przekaźnika, Scene 24);
  - odryglowania śluzy tranzytowej do Przestrzeni 25 `create_station24_door_release_sound()` (340/680 Hz suw rygli elektromagnetycznych z sykiem dekompresji i dzwonkiem 1020 Hz, Scene 24);
  - szumu szyn i przetwornicy trakcyjnej Linii 4 `create_transit_rail_hum_sound()` (50 Hz + 150 Hz rezonans szynowy + 3100 Hz whistle, Scene 25);
  - szelestu uniformu operatora UCP `create_jakub_uniform_rustle_sound()` (750..2800 Hz płótno robocze, Scene 25);
  - krystalicznego dysonansu pamięci identyfikacji ciała `create_scar_revelation_chime_sound()` (740 Hz / 784 Hz z tremolo 1.8 Hz, Scene 25);
  - mikro-tarcia ostrej krawędzi blachy `create_finger_edge_scrape_sound()` (1850 Hz micro-friction, Scene 25);
  - odryglowania śluzy ku Przestrzeni 26 `create_station25_door_release_sound()` (360/720 Hz release pneumatyczny, Scene 25);
  - buczenia rezonansowego złotej obrączki `create_ring_resonance_hum_sound()` (1200 Hz z mikro-tremolo 6 Hz i ciepłymi alikwotami miedzi, Scene 22);
  - napływu obcego wspomnienia malowania mieszkania `create_paint_memory_recall_sound()` (528 Hz ton relacyjny z szelestem wałka emulsyjnego 1200..3200 Hz i oparami rozpuszczalnika 132 Hz, Scene 22);
  - zakłócenia wymazania biograficznego `create_biographical_erasure_glitch_sound()` (62/31 Hz sub-bas z wycięciem filtru 1450 Hz i szumem pustki, Scene 22);
  - odryglowania portalu tranzytowego `create_station22_door_release_sound()` (380/190 Hz rygiel elektromagnetyczny ze świstem uszczelnienia pneumatycznego i gongiem 1100 Hz, Scene 22);
  - szumu stacji projektantki `create_designer_terminal_hum_sound()` (75/150 Hz szum transformatora z jonizacją luminoforu CRT 3400 Hz, Scene 23);
  - zakłócenia przesunięcia kursora `create_cursor_shift_glitch_sound()` (1420 Hz piezo-klik ze skokiem fazy 380 Hz przy ucieczce kursora, Scene 23);
  - skanu rejestru osób obciążonych `create_burden_ledger_scan_sound()` (880 Hz silnik krokowy z szelestem bufora indeksu, Scene 23);
  - rezonansu notatki projektantki `create_designer_note_chime_sound()` (660 Hz E5 z alikwotami 1320/1980 Hz i bursztynowym tremolo, Scene 23);
  - odryglowania śluzy ku Przestrzeni 24 `create_station23_exit_unlatch_sound()` (290/580 Hz solenoid ze zwolnieniem pneumatyki, Scene 23).
- Zaimplementowano dwudziestą piątą lokację Vertical Slice `Station25` (`scripts/levels/station_25.gd`, `scenes/levels/station_25.tscn`) — Przestrzeń 25 z `FULL_STORY.md` (Wejście Jakuba / Tranzyt Linii 4, Jakub jako operator UCP, blizna pod lewym żebrem, gest dłoni i dialog D-09):
  - węzeł tranzytowy i serwisowy Linii 4 w Punkcie Zgodności 6 (640x360, podłoga y=320, torowisko y=280..360, sklepienie y=40) w palecie grafitu, ciemnej stali, bursztynu i cyjanu torowiska (`#10171a`, `#162227`, `#4a6d7c`, `#d39a62`, `#e2b060`), stalowe szyny z tłuczniem i podkładami, napowietrzna sieć trakcyjna Linii 4, wózek techniczny torowiska (`MaintenanceCart`), dokumentacja wypadku z zaznaczoną blizną od szkła pod lewym żebrem (`ScarChart`), postać Jakuba Wolskiego w roboczym uniformie operatora UCP (`JakubOperator`), punkt analizy gestu dłoni (`GestureSensor`) oraz śluza wyjściowa ku strefie izolacji Przestrzeni 26 (`Station25Exit`);
  - pełna implementacja sceny dialogowej D-09 z `DIALOGUE_SCRIPT.md` (13 kwestii: Jakub Wolski, Lena Wolska, Świadectwo):
    - Jakub bada gest dłoni Leny (rozcinanie palca o ostrą krawędź vs obracanie obrączki) i odrzuca pozory;
    - Lena ujawnia prawdę o pamięci identyfikacji ciała i bliźnie pod lewym żebrem;
    - Jakub siada na podłodze i stawia twardą granicę podmiotowości: »Nie jestem twoim wspomnieniem. Jeśli chcesz wyjść, pomogę osobie. Nie żałobie.«;
    - odryglowanie wyjścia do Przestrzeni 26 (Próba zamknięcia / strefa izolacji) i przejście przez `AirlockZone` przy x=610.
- Zaimplementowano dwudziestą czwartą lokację Vertical Slice `Station24` (`scripts/levels/station_24.gd`, `scenes/levels/station_24.tscn`) — Przestrzeń 24 z `FULL_STORY.md` (Marta pod obserwacją / Monitoring mieszkania 14, transmisja Wierzbickiej i wybór Leny).
- Zaimplementowano dwudziestą trzecią lokację Vertical Slice `Station23` (`scripts/levels/station_23.gd`, `scenes/levels/station_23.tscn`) — Przestrzeń 23 z `FULL_STORY.md` (Pokój projektantki / Model Podstruktury, lista osób obciążonych i uciekający kursor).
- Zaimplementowano dwudziestą drugą lokację Vertical Slice `Station22` (`scripts/levels/station_22.gd`, `scenes/levels/station_22.tscn`) — Przestrzeń 22 z `FULL_STORY.md` (Uległość / Biometryczna bramka tożsamości w tranzycie UCP).
- Zaimplementowano dwudziestą pierwszą lokację Vertical Slice `Station21` (`scripts/levels/station_21.gd`, `scenes/levels/station_21.tscn`) — Przestrzeń 21 z `FULL_STORY.md` (Cena ulgi / Pokój zabiegowo-sedacyjny Szymona Bery w Punkcie Zgodności 6).
- Zaimplementowano dwudziestą lokację Vertical Slice `Station20` (`scripts/levels/station_20.gd`, `scenes/levels/station_20.tscn`) — Przestrzeń 20 z `FULL_STORY.md` (Sala Szymona / Pokój Szymona Bery w Punkcie Zgodności 6).
- Zaimplementowano dziewiętnastą lokację Vertical Slice `Station19` (`scripts/levels/station_19.gd`, `scenes/levels/station_19.tscn`) — Przestrzeń 19 z `FULL_STORY.md` (Model bez oryginału / Sala Modeli).
- Zaimplementowano osiemnastą lokację Vertical Slice `Station18` (`scripts/levels/station_18.gd`, `scenes/levels/station_18.tscn`) — Przestrzeń 18 z `FULL_STORY.md` (Wywiad zgodności / Gabinet konsultacyjny dr Heleny Wierzbickiej).
- Zaimplementowano siedemnastą lokację Vertical Slice `Station17` (`scripts/levels/station_17.gd`, `scenes/levels/station_17.tscn`) — Przestrzeń 17 z `FULL_STORY.md` (Punkt Zgodności 6 / Urząd UCP).
- Zaimplementowano szesnastą lokację Vertical Slice `Station16` (`scripts/levels/station_16.gd`, `scenes/levels/station_16.tscn`) — Przestrzeń 16 z `FULL_STORY.md` (Rozmowa przy stole).
- Zaimplementowano piętnastą lokację Vertical Slice `Station15` (`scripts/levels/station_15.gd`, `scenes/levels/station_15.tscn`) — Przestrzeń 15 z `FULL_STORY.md` (Korytarz serwisowy).
- Zaimplementowano czternastą lokację Vertical Slice `Station14` (`scripts/levels/station_14.gd`, `scenes/levels/station_14.tscn`) — Przestrzeń 14 z `FULL_STORY.md` (Zakotwiczenie).
- Zaimplementowano trzynastą lokację Vertical Slice `Station13` (`scripts/levels/station_13.gd`, `scenes/levels/station_13.tscn`) — Przestrzeń 13 z `FULL_STORY.md` (Adres ciągłości).
- Zaimplementowano dwunastą lokację Vertical Slice `Station12` (`scripts/levels/station_12.gd`, `scenes/levels/station_12.tscn`) — Przestrzeń 12 z `FULL_STORY.md` (Pokaz bezpieczeństwa).
- Zaimplementowano jedenastą lokację Vertical Slice `Station11` (`scripts/levels/station_11.gd`, `scenes/levels/station_11.tscn`) — Przestrzeń 11 z `FULL_STORY.md` (Pierwsza korekta).
- Zaimplementowano dziesiątą lokację Vertical Slice `Station10` (`scripts/levels/station_10.gd`, `scenes/levels/station_10.tscn`) — Przestrzeń 10 z `FULL_STORY.md` (Telefon Jakuba).
- Zaimplementowano dziewiątą lokację Vertical Slice `Station09` (`scripts/levels/station_09.gd`, `scenes/levels/station_09.tscn`) — Przestrzeń 09 z `FULL_STORY.md` („Pokój, który nie czeka”).
- Zaimplementowano ósmą lokację Vertical Slice `Station08` (`scripts/levels/station_08.gd`, `scenes/levels/station_08.tscn`) — Przestrzeń 08 z `FULL_STORY.md` („Mieszkanie po kimś”).
- Zaimplementowano siódmą lokację Vertical Slice `Station07` (`scripts/levels/station_07.gd`, `scenes/levels/station_07.tscn`) — Przestrzeń 07 z `FULL_STORY.md` („Wróciłaś”).
- Zaimplementowano szóstą lokację Vertical Slice `Station06` (`scripts/levels/station_06.gd`, `scenes/levels/station_06.tscn`) — Przestrzeń 06 z `FULL_STORY.md` (Linia zastępcza).
- Zaimplementowano piątą lokację Vertical Slice `Station05` (`scripts/levels/station_05.gd`, `scenes/levels/station_05.tscn`) — Przestrzeń 05 z `FULL_STORY.md` (Rówień nocą).
- Zaimplementowano czwartą lokację Vertical Slice `Station04` (`scripts/levels/station_04.gd`, `scenes/levels/station_04.tscn`) — Przestrzeń 04 z `FULL_STORY.md` (Bramka / Recepcja IKP).
- Zaimplementowano trzecią lokację Vertical Slice `Station03` (`scripts/levels/station_03.gd`, `scenes/levels/station_03.tscn`) — Przestrzeń 03 z `FULL_STORY.md` (Puste laboratorium IKP).
- Zaimplementowano drugą lokację Vertical Slice `Station02` (`scripts/levels/station_02.gd`, `scenes/levels/station_02.tscn`) — Przestrzeń 02 z `FULL_STORY.md` (Komora Pomiarowa IKP).
- Zaimplementowano pierwszą lokację Vertical Slice `Station01` (`scripts/levels/station_01.gd`, `scenes/levels/station_01.tscn`) — Przestrzeń 01 z `FULL_STORY.md` (Sterownia IKP).
- Zaimplementowano klasę punktów rezonansu pamięci `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`) obsługującą 117 typów rekwizytów narracyjnych w świecie gry (PropType 0..116, w tym `JAKUB_OPERATOR_UCP`, `TRANSIT_MAINTENANCE_CART`, `SCAR_DIAGNOSTIC_CHART`, `JAKUB_HAND_GESTURE_SENSOR`, `STATION_25_EXIT`).
- Rozszerzono `tests/smoke_test.gd` o automatyczną weryfikację wszystkich lokacji prototypowych i 25 stacji Vertical Slice.
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
  - `reports/station_17.png`
  - `reports/station_17_interview.png`
  - `reports/station_18.png`
  - `reports/station_18_interview.png`
  - `reports/station_19.png`
  - `reports/station_19_models.png`
  - `reports/station_20.png`
  - `reports/station_20_szymon.png`
  - `reports/station_21.png`
  - `reports/station_21_szymon.png`
  - `reports/station_22.png`
  - `reports/station_22_yield.png`
  - `reports/station_23.png`
  - `reports/station_23_terminal.png`
  - `reports/station_24.png`
  - `reports/station_24_cctv.png`
  - `reports/station_25.png`
  - `reports/station_25_jakub.png`

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

Finalna weryfikacja PKG-0093 zakończyła się 2026-08-23 wynikiem PASS: kontrakt dokumentacji, statyczny/runtimeowy kontrakt istniejącego zamrożonego showcase'u, import Godot 4.7 oraz pełny smoke test Station 01..43. Dodatkowy kontrakt `tests/pkg_0091_smoke_test.gd` przechodzi dla systemów game feel, CRT, atmosfery i Rówień Vector-Stage.

```text
== Documentation contract ==
DOCS PASS: 26 required files and handoff contracts
== Web Showcase validation ==
== Web Showcase Static & Contract Validation ==
WEB RUNTIME SMOKE: PASS (all bundles evaluate, 49 globals, 100 dossiers)
WEB PASS: All HTML, CSS, JS, Locales, PWA Manifest, and Assets validated successfully.
== Godot headless import ==
Godot Engine v4.7.stable.official.5b4e0cb0f - https://godotengine.org
[ DONE ] first_scan_filesystem
[ DONE ] loading_editor_layout
== Getting Strange smoke test ==
MOVEMENT PROFILE: A
TEST: movement_lab completed
TEST: anchor_lab completed
TEST: station_01..station_41 (41 przestrzeni fabularnych) completed
TEST: station_42a completed
TEST: station_42b completed
TEST: station_42c completed
TEST: station_43 completed
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Dodatkowy kontrakt pakietu:

```text
PKG-0091 SMOKE PASS: player feel, atmosphere, CRT dialogue and game state
```

Świeży capture przez zwykły sterownik Compatibility przeszedł dla wszystkich
referencyjnych kadrów, w tym Station 01..05 po zmianie palety i warstw
Vector-Stage: `Capture preview finished successfully.`

Kontrakt dokumentacji obejmuje `ADR-001` do `ADR-005` oraz aktualne nagłówki. Bramka weryfikuje istnienie wymaganych dokumentów, brak wiszących placeholderów, poprawne ładowanie klas (`ProceduralAudio`, `AnchorableObject`, `MovableAnchorableProp`, `CinematicCamera`, `AnchorLab`, `PrototypePlayer`, `MemoryResonancePoint`, `Station01`..`Station43`, `DiscontinuousShadow`, `LocalizationManager`), walidację 100 odtajnionych akt archiwalnych, symulatora tensora naprężeń próżni kwantowej Casimira, oraz test automatyczny kamer, stref komorowych, syntezy dźwięków proceduralnych (ponad 88 modułów syntezy), fizyki i logiki kotwiczenia oraz pełnego przejścia procedur w `station_01.tscn` .. `station_43.tscn`.

Rendery kontrolne zaktualizowane:
- `reports/movement_lab.png`
- `reports/anchor_lab.png`
- `reports/anchor_lab_ch2.png`
- `reports/anchor_lab_ch3.png`
- `reports/anchor_lab_ch3_solved.png`
- `reports/anchor_lab_ch3_locked.png`
- `reports/station_01.png` .. `reports/station_43.png` (92 kadry referencyjne)

### Dostarczone w PKG-0092

- `PrototypePlayer` zachowuje dotychczasowy profil A/B/C, coyote time, jump buffer i jump cut, a dodatkowo ma proceduralny squash-and-stretch przy skoku i lądowaniu, płynny lean/facing oraz lokalne emitery `RunDust` i `LandingDust`. Deformacja dotyczy wyłącznie `_draw()`, więc nie zmienia kolizji.
- Dodano współdzielony `AtmosphereRig`: gradientowe tekstury dla `PointLight2D`, dwa światła jarzeniowe z mikrofluktuacją 100 Hz, proceduralny loop `create_fluorescent_hum_sound()` oraz niskobudżetowe `VolumetricDust` `CPUParticles2D`.
- Stacje `station_01` do `station_05` instancjonują `AtmosphereRig`, `CRTDialogueBox` i lokalny `StationDialogueCue`. Ramka CRT ma luminoforową paletę, inicjał-portret, typewriter i proceduralne blipy dla Leny, Marty, Jakuba, dr Wierzbickiej oraz Szymona.
- Dodano autoload `GameStateManager` w `project.godot`: osiągnięte stacje, poszlaki, decyzje, checkpoint, lista 43 przestrzeni dla selektora oraz przejście sceny z fade-to-black.
- Dodano `tests/pkg_0091_smoke_test.gd`; test ładuje gracza i pięć pierwszych stacji, sprawdza emitery, światła gradientowe, pył, CRT, cue dialogowy oraz kontrakt game-state.

### Dostarczone w PKG-0093: zmiana kierunku artystycznego

- Zastąpiono kanon `VISUAL_DESIGN.md` biblią `Rówień Vector-Stage`; zmiana jest
  spójna z `PRODUCT_BRIEF`, `PROJECT_BIBLE`, `TECHNICAL_DIRECTION`, roadmapą,
  ryzykami, researchem i granicami IP.
- Dodano `VectorStageStyle` oraz `VectorStageEnvironment` do proceduralnego
  obrazu Godot. Station 01 dostała przerysowaną architekturę wielopłaszczyznową,
  a Station 01..05 mają obowiązkową warstwę scenicznego tła.
- Przerysowano proceduralną sylwetkę Leny do własnej geometrii z płaszczyzn,
  torbą narzędziową i asymetrią; fizyka i collidery pozostały bez zmian.
- Smoke test PKG-0091 sprawdza obecność `VectorStageEnvironment` dla pięciu
  pierwszych stacji. Konwersja Station 06..43 pozostaje jawnie zaplanowaną
  pracą ręczną — nie jest fałszywie oznaczona jako ukończona.

### Dostarczone w PKG-0094: Akt I Vector-Stage i pętla kampanii

- `GameStateManager` ma wersjonowany (`schema_version = 1`) zapis JSON w
  `user://getting_strange_campaign_v1.json`, bezpieczne ignorowanie uszkodzonego
  lub niezgodnego schematem pliku, jawne API zapisu/reload/reset, checkpointu,
  poszlak oraz decyzji. `MemoryResonancePoint` kolekcjonuje poszlakę przez to
  API przy interakcji.
- `CampaignPauseMenu` to runtimeowy `CanvasLayer`: zatrzymuje drzewo gry,
  pozwala wznowić, wrócić do checkpointu, zresetować zapis i wybrać przestrzeń.
  Zwykła kampania pokazuje Station 01 oraz osiągnięte stacje, a jawny tryb
  testowy otwiera komplet 43 pozycji.
- Station 06..10 mają własne profile `VectorStageEnvironment`, `AtmosphereRig`,
  `CRTDialogueBox` i `OpeningDialogueCue`. Warstwy wizualne nie dotknęły
  `Geometry` ani colliderów. Audyt osi, negatywnej przestrzeni, palet, akcentów
  i rekwizytów-świadków: `docs/VECTOR_STAGE_ACT_I_AUDIT.md`.
- Dodano i uruchomiono `tests/pkg_0094_smoke_test.gd`; naprawiono błąd zakresu
  zmiennej w `tests/pkg_0091_smoke_test.gd`. Capture Actu I wykonał
  `tools/capture_act1_vector_stage.gd` na sterowniku Windows Intel Iris Xe i
  zapisał pięć kadrów `reports/pkg_0094_act1/station_06.png`..`station_10.png`.

## Ostatnia swieza weryfikacja

PKG-0094, 2026-08-23: import Godot, `tests/pkg_0091_smoke_test.gd`,
`tests/pkg_0094_smoke_test.gd`, capture Actu I oraz pełne `tools/verify.ps1`
przechodzą. W bazowym stanie wykryto uszkodzony zakres `player` w smoke PKG-0091;
został naprawiony w tym samym pakiecie, bez osłabiania kontraktu.

PKG-0095, 2026-08-23: import Godot, smoke PKG-0094 i PKG-0095, capture Aktu II
oraz pełne `tools/verify.ps1` przechodzą. Capture wykonał się na normalnym
sterowniku Windows OpenGL / Intel Iris Xe; pięć kadrów ma 1280×720.

### Dostarczone w PKG-0095: Akt II i łańcuch kampanii 01..15

- Station 11..15 otrzymały własne profile `VectorStageEnvironment`,
  `AtmosphereRig`, `CRTDialogueBox` i `OpeningDialogueCue`; żaden istniejący
  collider, `Geometry` ani zasięg `Area2D` nie został zmieniony.
- `GameStateManager` centralnie wiąże `level_completed` dla Station 01..15 z
  zapisaniem ukończenia, odblokowaniem kolejnej przestrzeni i przejściem fade.
  Jawny limit 15 zapobiega fałszywemu odblokowaniu Station 16 przed jej
  dostarczeniem. Tryb testowy i schema 1 zapisu pozostały bez zmian.
- Dodano `tests/pkg_0095_smoke_test.gd`, który sprawdza profile Aktu II, CRT,
  cue checkpointu, geometrię, odblokowania 10→15 oraz faktyczną emisję
  `level_completed` Station 11 odblokowującą Station 12.
- Dodano `tools/capture_act2_vector_stage.gd`, rendery
  `reports/pkg_0095_act2/station_11.png`..`station_15.png` oraz audyt
  `docs/VECTOR_STAGE_ACT_II_AUDIT.md`.

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

- Automatyczne testy potwierdzaja kontrakty plikow, generowanie buforów audio, zachowanie kamery kinowej, grayboxu oraz logikę kotwiczenia, pchania skrzyń, pełnego przejścia 3 komór `AnchorLab`, procedury startowej `Station01`..`Station43`, nie subiektywną satysfakcję (game feel) gracza.
- `DOCS PASS` sprawdza istnienie plikow i obecnosc naglowkow.
- Cofanie jest ograniczone do snapshotów (`tools/snapshot.ps1`).

## Nastepny pakiet

`PKG-0096: Rówień Vector-Stage Akt IIb i łańcuch kampanii 16..20`

Cel: kontynuacja wyłącznie gry Godot (D-091..D-094) w następnym spójnym batchu:
1. ręcznie skonwertować Station 16..20 do Rówień Vector-Stage wraz z auditami,
   renderami i kontraktem testowym;
2. rozszerzyć limit łańcucha ukończeń do Station 20 oraz sprawdzić przejścia,
   checkpointy, unlocki i utrzymanie trybu testowego;
3. dodać CRT/checkpoint cue Aktu IIb bez zmiany colliderów lub geometrii;
4. uruchomić pełną weryfikację, udokumentować oraz zamrozić `PKG-0096`.

Pakiet jest realizowany w 100% autonomicznie w silniku Godot w trybie Wysokoprzepustowych Mega-Pakietów (2x–5x Batch Size, D-085, D-091).

## Punkt przekazania

Nowa sesja zaczyna od swiezej weryfikacji (`tools/verify.ps1`), czyta `AGENTS.md`, `INDEX.md`, ten
plik i `NEXT_SESSION_PROMPT.md`, a następnie przechodzi do realizacji PKG-0096 w silniku Godot 4.7.













