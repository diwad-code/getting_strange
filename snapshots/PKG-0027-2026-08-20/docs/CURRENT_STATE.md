# Aktualny stan projektu

Stan na: 2026-08-20

## Katalog i srodowisko

- Katalog: `C:\getting_strange`
- Godot: `4.7.stable.official.5b4e0cb0f`
- Platforma robocza: Windows, PowerShell 7
- Narzędzia generatywne: Picsart AI CLI (`gen-ai`, uwierzytelniony dostęp do generacji obrazów, wideo i audio)
- **Wersjonowanie: brak (D-016).** Pliki na dysku sa jedynym stanem projektu.
  Nie ma repozytorium, galezi, commita ani historii. Nie uruchamiamy `git`. Ostatni zamkniety pakiet: `PKG-0027`, 2026-08-20
- Kronika pakietow: `SESSION_LOG.md` - jedyna historia, append-only
- Zamrozenia: `snapshots/PKG-NNNN-DATA/` przez `tools/snapshot.ps1` (D-017);
  ostatnie: `snapshots/PKG-0027-2026-08-20`

Do PKG-0005 wlacznie projekt byl wersjonowany. W `PKG-0006` usunieto `.git`,
`.gitignore` i `.gitattributes`. Ta historia nie istnieje juz w formie
odtwarzalnej; kazdy stan sprzed `PKG-0006` jest opisany wylacznie w
`SESSION_LOG.md`. Nie powoluj sie na commity - nie da sie ich sprawdzic.

## Aktywna faza

Faza **`P3 / Vertical Slice`** została **OTWARTA I JEST W TOKU** (PKG-0019, postęp: Przestrzenie 01..09 wdrożone). Faza P2 (Anchor Lab) zakończona i zaliczona.

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

- Projekt Godot 640x360 uruchamia sceny prototypowe `scenes/prototype/movement_lab.tscn`, `scenes/prototype/anchor_lab.tscn` oraz sceny Vertical Slice: pierwszą lokację `scenes/levels/station_01.tscn`, Komorę Pomiarową `scenes/levels/station_02.tscn`, Puste Laboratorium `scenes/levels/station_03.tscn`, Recepcję/Bramkę IKP `scenes/levels/station_04.tscn`, Rówień nocą `scenes/levels/station_05.tscn`, Wnętrze autobusu zastępczego `scenes/levels/station_06.tscn`, Klatkę schodową na Osiedlu Tarasowym `scenes/levels/station_07.tscn`, Wnętrze mieszkania 14 `scenes/levels/station_08.tscn` oraz Łazienkę i korytarz `scenes/levels/station_09.tscn`.
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
  - dysonansu temporalnego lustra `create_mirror_shimmer_sound()` (dwuton 880/987 Hz z mikrodryfem fazowym 0.4 Hz).
- Zaimplementowano dziewiątą lokację Vertical Slice `Station09` (`scripts/levels/station_09.gd`, `scenes/levels/station_09.tscn`) — Przestrzeń 09 z `FULL_STORY.md` („Pokój, który nie czeka” / Wnętrze łazienki i korytarz):
  - łazienka w modernistycznym mieszkaniu 14: kafelki ceramiczne w geometrycznym układzie szaro-grafitowym i szałwiowym, żeliwne i chromowane piony instalacji wodnej z manometrem i złączami kołnierzowymi, umywalka ceramiczna z baterią chromowaną i kapiącą wodą (`BathroomSink`), lustro łazienkowe w ramie ołowianej z asynchronicznym / opóźnionym odbiciem sylwetki Leny i śluzy za plecami (`BathroomMirror`, #motionviz-observed-discontinuity), szafka apteczna ze stabilizatorami korelacji i gazą (`ApothecaryCabinet`), wieszak z ręcznikiem i kosz na bieliznę;
  - odkrycie kluczowej poszlaki (Clue R-02): przy obserwacji lustra pod kątem bocznym (x=210..290) załamujące się światło odsłania wydrapaną na szkle inskrypcję `NIE SZUKAJ ORYGINAŁU` (`ScratchedInscription`) z proceduralnym audio skrobania szkła `create_glass_scratch_sound()`;
  - pełna scena dialogowa D-03 z Martą Kurek: instrukcja przejścia korytarza („Nie patrz na drzwi. Patrz na nie w lustrze. (...) Zostaw drzwi w odbiciu. Idź, nie sprawdzaj.”);
  - mechanika stabilizacji korytarza i odryglowania drzwi wyjściowych: jednostajne przejście korytarza ku prawemu krańcowi z zachowaniem zasady obserwacji stabilizuje geometrię, odryglowuje zamek drzwi i rozświetla korytarz ciepłym światłem ze strefą `AirlockZone` prowadzącą do Przestrzeni 10 (Telefon Jakuba).
- Zaimplementowano ósmą lokację Vertical Slice `Station08` (`scripts/levels/station_08.gd`, `scenes/levels/station_08.tscn`) — Przestrzeń 08 z `FULL_STORY.md` („Mieszkanie po kimś” / Wnętrze mieszkania Marty i lokalnej Leny):
  - modernistyczne mieszkanie 14 na Osiedlu Tarasowym: drewniany parkiet w jodełkę z listwami przypodłogowymi i mosiężnymi progami, wiatrołap/przedpokój z wieszakiem, aneks kuchenny ze zlewem i gotującym się czajnikiem na gazie, stół jadalno-roboczy z wiszącą lampą sufitową rzucającą ciepły stożek bursztynowego światła (#D39A62), kącik studyjny z oknem na deszczową noc Równi, żebrowany grzejnik żeliwny oraz korytarz wyjściowy prowadzący do Przestrzeni 09 (Pokój, który nie czeka);
  - wdrożenie rekwizytów o podwójnym zastosowaniu per `FULL_STORY.md` i `VISUAL_DESIGN.md`: laboratoryjna zlewka 200 ml zaadaptowana jako doniczka na sukulent (`BeakerPlanter`), pamiątka Jakuba z poziomicą mosiężną użyta jako przycisk do kalkulacji (`JakubMemento`), wieszak w przedpokoju z dwoma płaszczami i butami na deszcz sprzed 17 dni (`CoatRack`), wspólna fotografia Marty i lokalnej Leny kadrowana ściśle od tyłu w odbiciu deszczowego okna (`ReflectedPhoto`);
  - biurko robocze z mechanicznym zamkiem szyfrowym (`CipherDesk`): odruchowe obrócenie bębenków szyfru (kod 0311 — data wypadku Jakuba) odryglowuje szufladę i odsłania obce odręczne notatki z kalkulacjami siatek korelacyjnych oraz szkicami węzłów Podstruktury UCP;
  - wdrożenie pełnej sceny dialogowej z Martą Kurek w mieszkaniu: konfrontacja Leny z tożsamością zaginionej Leny (która współtworzyła Podstrukturę UCP, a nie tylko uciekała), ciepła herbata parująca na stole oraz przygotowanie do przejścia do łazienki z instrukcją obserwacji lustra (`AirlockZone` ku Przestrzeni 09).
- Zaimplementowano siódmą lokację Vertical Slice `Station07` (`scripts/levels/station_07.gd`, `scenes/levels/station_07.tscn`) — Przestrzeń 07 z `FULL_STORY.md` („Wróciłaś” / Klatka schodowa na Osiedlu Tarasowym):
  - modernistyczna klatka schodowa na 5. piętrze bloku: lastryko z mosiężnymi dylatacjami, stalowe balustrady, ciemna lamperia, sufitowe oprawy oświetleniowe, panoramiczne okno z widokiem na deszczowe miasto i odcięte piętro;
  - postać Marty Kurek stojącej w progu mieszkania 14: ubrana w roboczą kurtkę z plamami kredy, torbą narzędziową na ramieniu i calówką w kieszeni;
  - wdrożenie pełnej sceny dialogowej D-02 z `DIALOGUE_SCRIPT.md` („Wróciłaś”, „Twarz się zgadza”, gest dociskania paznokcia do szwu palca);
  - interaktywne badanie tablicy lokatorów (wyróżniony lokal 14: Wolska/Kurek), skrzynek pocztowych (awizo UCP z Działu Zgodności), włącznika czasowego oświetlenia schodowego oraz ślepego biegu schodów urywających się w litej ścianie betonowej z ostrzeżeniem o uciętej kondygnacji (#geometry-restless-grid);
  - sekwencja otwarcia drzwi mieszkania po dialogu: płynne rozświetlenie klatki ciepłym domowym światłem, odsłonięcie korytarza z parkietem i wieszakiem oraz wejście do strefy `AirlockZone` prowadzącej do Przestrzeni 08 („Mieszkanie po kimś”).
- Zaimplementowano szóstą lokację Vertical Slice `Station06` (`scripts/levels/station_06.gd`, `scenes/levels/station_06.tscn`) — Przestrzeń 06 z `FULL_STORY.md` (Linia zastępcza / Autobus Linii 4):
  - wnętrze nocnego autobusu miejskiego w ruchu z paralaksą przesuwających się za oknami świateł, deszczu, zamkniętego torowiska Linii 4 z zaporami i czerwonymi diodami ostrzegawczymi;
  - kabina kierowcy z tablicą relacji `Linia Zastępcza 4 -> Osiedle Tarasowe` oraz kasownikiem biletowym;
  - sufitowe relingi ze skórzanymi uchwytami kołyszącymi się pod wpływem bezwładności oraz lampy jarzeniowe rzucające stożki światła;
  - sufitowy głośnik z komunikatem instytucjonalnym UCP: „Prosimy nie utrwalać rozbieżności przez powtarzanie”;
  - interakcja i dialog ze starszym pasażerem, który rozpoznaje Lenę i oddaje jej zgubioną 2 tygodnie wcześniej złotą obrączkę ślubną;
  - badanie obrączki i dłoni Leny: potwierdzenie braku jakiegokolwiek śladu/odcisku po noszeniu obrączki na szwie palca per `VISUAL_DESIGN.md` (materializacja obcej lokalnej biografii zaginionej Leny, rekwizyt powracający w finale Uzgodnienia);
  - sekwencja dojazdu do przystanku Osiedle Tarasowe: płynne wyhamowanie autobusu, pojawienie się wiaty przystankowej za szybą, pneumatyczne otwarcie drzwi wyjściowych i strefa `AirlockZone` prowadząca do Przestrzeni 07 („Wróciłaś”).
- Zaimplementowano piątą lokację Vertical Slice `Station05` (`scripts/levels/station_05.gd`, `scenes/levels/station_05.tscn`) — Przestrzeń 05 z `FULL_STORY.md` (Rówień nocą):
  - dwukomorowy miejski trakt o szerokości 1280 px (Chamber 0: Wyjście z instytutu, afisz, budynek bez piętra, zmienny zaułek; Chamber 1: przejście dla pieszych, tory tramwajowe, wiata przystankowa, peron autobusu);
  - deszczowa sceneria miejska: cząsteczki deszczu `CPUParticles2D`, mokry asfalt z kałużami i odbiciami, latarnie ze snopami światła, sieć trakcyjna z masztami kratowymi;
  - mechanika nieciągłości obserwacji (#geometry-restless-grid): brama dziedzińca w Chamber 0 bezszwowo przekształca się w litą ścianę z rurą spustową i skrzynką zasilającą, gdy gracz przekracza granicę x=650 ku Chamber 1 (brak tanich jumpscare'ów i glitchy);
  - interaktywny sygnalizator przejścia przełączający światło na zielone/cyjan, uruchamiający syntezę dźwiękową beacona i szepczący imię Leny;
  - strefa przejścia `AirlockZone` przy peronie przystankowym prowadząca do Przestrzeni 06 (Linia zastępcza).
- Zaimplementowano czwartą lokację Vertical Slice `Station04` (`scripts/levels/station_04.gd`, `scenes/levels/station_04.tscn`) — Przestrzeń 04 z `FULL_STORY.md` (Bramka / Recepcja IKP):
  - punkt kontroli dostępu i stanowisko strażnika za pancernym przeszkleniem z wycięciem podawczym i otworami akustycznymi;
  - wdrożenie dialogu środowiskowego D-01: strażnik melduje powrót Leny do UCP i wspomina o niewzywaniu jej brata Jakuba do zamkniętego tunelu;
  - zdarzenie zgaśnięcia lampy nad kamerą: w momencie wypowiedzenia przez Lenę słów "Jakub nie żyje" snop światła sufitowego natychmiast gaśnie z ostrym klikiem przekaźnika, a strażnik przesuwa się, unosząc ramię i zasłaniając obiektyw kamery ("Proszę tego przy niej nie powtarzać... Przy wersji, która zapisuje");
  - mechaniczny 3-ramienny kołowrót (turnstile) odryglowujący się z mechanicznym dźwiękiem po zakończeniu dialogu ze zmianą lampki z cynobru na cyjan i otwarciem przejścia;
  - szklany wiatrołap z widokiem na deszczowe miasto Rówień (Przestrzeń 05) i przejście do kolejnej sceny.
- Zaimplementowano trzecią lokację Vertical Slice `Station03` (`scripts/levels/station_03.gd`, `scenes/levels/station_03.tscn`) — Przestrzeń 03 z `FULL_STORY.md` (Puste laboratorium IKP / Zerwanie ciągłości):
  - korytarz wejściowy i powrót do sterowni po pomiarze: nocna obsada nagle zniknęła (puste stanowiska, porzucony fartuch na krześle, ciemne okno obserwacyjne);
  - dwa kubki na blacie roboczym zamiast jednego (kubek ceramiczny Leny oraz drugi emaliowany ze śladami świeżej kawy — namacalny dowód obecności alternatywnego świadka);
  - biurkowy aparat telefoniczny z pulsującą diodą wiadomości i rejestrem: 14 nieodebranych połączeń od Marty Kurek, której Lena nie zna;
  - ścienny czytnik kart dostępu `DoorCardReader` rozpoznający identyfikator Leny (ID: 884-A), lecz wyświetlający inne zdjęcie portretowe oraz status ostrzegawczy `URLOP PRZERWANY`;
  - odryglowanie głównej śluzy korytarzowej i przejście do Przestrzeni 04 (Bramka / Recepcja IKP).
- Zaimplementowano komponent `DiscontinuousShadow` (`scripts/player/discontinuous_shadow.gd`) realizujący zasadę nieciągłości obserwowanego ruchu (#motionviz-observed-discontinuity per `VISUAL_DESIGN.md` i `FULL_STORY.md` Scena 02):
  - fizyczna projekcja cienia na posadzce laboratoryjnej z uwzględnieniem kątów źródeł światła L1 i L2;
  - w stanie anomalii korelacji: ruch cienia kończy się o pojedynczą klatkę przed ciałem Leny podczas zatrzymania/deceleracji;
  - brak sztucznych filtrów RGB/VHS — anomalia wynika bezpośrednio z optyki świata gry.
- Zaimplementowano drugą lokację Vertical Slice `Station02` (`scripts/levels/station_02.gd`, `scenes/levels/station_02.tscn`) — Przestrzeń 02 z `FULL_STORY.md` (Komora Pomiarowa IKP):
  - symetryczna rama korelacyjna z dwoma punktami światła (L1 przy x=320, L2 przy x=440), centralnym rdzeniem próżniowym i osią optyczną;
  - procedura pomiarowa z przekroczeniem progu korelacji ($\eta = 1.42$ wobec oczekiwanego $1.00$);
  - nieoczekiwane rozświetlenie i synchronizacja częstotliwości punktu L2 pomimo odłączenia obwodu;
  - fizyczny rejestrator taśmowy na biurku drukujący w świecie gry pasek papieru z werdyktem: `WYNIK ZGODNY`;
  - procedura przerwania pomiaru przez Lenę zgodnie z protokołem bezpieczeństwa, stabilizacja konsensusu i odryglowanie śluzy wyjściowej do Przestrzeni 03.
- Zaimplementowano klasę punktów rezonansu pamięci `MemoryResonancePoint` (`scripts/interactables/memory_resonance_point.gd`):
  - obsługa typów: `PHOTOGRAPH`, `CIRCUIT_BREAKER`, `VACUUM_GAUGE`, `CHAMBER_CONSOLE`, `DOCUMENT_CLIPBOARD`, `DOOR_CARD_READER`, `TWIN_CUPS`, `DESK_TELEPHONE`, `DUTY_ROSTER`, `SECURITY_MONITOR`, `UCP_NOTICE`, `GUARD_INTERACTION`, `ANACHRONISTIC_BILLBOARD`, `MISSING_FLOOR_FACADE`, `CROSSWALK_SIGNAL`, `TRANSIT_SHELTER`, `BUS_SPEAKER`, `ELDERLY_PASSENGER`, `GOLD_RING`, `BUS_ROUTE_MAP`, `COAT_RACK`, `REFLECTED_PHOTO`, `TEA_KETTLE`, `BEAKER_PLANTER`, `JAKUB_MEMENTO`, `CIPHER_DESK`, `BATHROOM_SINK`, `BATHROOM_MIRROR`, `SCRATCHED_INSCRIPTION`, `APOTHECARY_CABINET`, `MARTA_BATHROOM_GUIDE`;
  - fizyczne rysowanie w świecie gry zgodne z `VISUAL_DESIGN.md` (fotografia Leny i Jakuba, przełączniki hebelkowe, manometr, terminal CRT, dwa kubki z osadem, telefon stacjonarny z mrugającą diodą wiadomości, czytnik kart z alternatywnym portretem i dopiskiem "urlop przerwany", tablica dyżurów, monitor CCTV z rastrem kineskopowym, tablica UCP, afisz anachronistyczny UCP 1978, elewacja z wyciętym piętrem, sygnalizator przejścia, gablota rozkładu Linii Zastępczej, głośnik UCP, sylwetka starszego pasażera, złota obrączka na siedzeniu, tablica schematu trasy, wieszak z płaszczami, zlewka-doniczka, pamiątka Jakuba, biurko z mechanicznym szyfrem 0311, umywalka ceramiczna z baterią chromowaną, lustro łazienkowe z opóźnionym odbiciem, wydrapana inskrypcja `NIE SZUKAJ ORYGINAŁU`, szafka apteczna ze stabilizatorami korelacji oraz znacznik instrukcji Marty D-03);
  - subtelny bursztynowy retikuł obecności i żarzenia filamentowego (`#D39A62`) bez inwazyjnego HUD-u;
  - emiter cząsteczek ciepłego pyłu pamięci oraz synteza audio rezonansu.
- Zaimplementowano pierwszą lokację Vertical Slice `Station01` (`scripts/levels/station_01.gd`, `scenes/levels/station_01.tscn`) — Przestrzeń 01 z `FULL_STORY.md`:
  - Sterownia IKP o 21:43: szkło ołowiane, matowa stal, linoleum/lastryko, sufitowe oprawy oświetleniowe, biurko operatora z kubkiem i asymetryczną fotografią Leny z Jakubem;
  - trzy obwody zasilające (Alpha, Beta, Gamma), manometr próżniowy z podciśnieniem $10^{-7}\text{ mbar}$;
  - ścienny ekran telemetryczny w świecie gry z blokami stanu obwodów i wykresem próżni;
  - okno inspekcyjne z widokiem na ciemną komorę korelacyjną;
  - śluza elektromagnetyczna odryglowująca przejście do Komory Pomiarowej (Przestrzeń 02) po ukończeniu listy kontrolnej.
- Zaimplementowano klasę `AnchorableObject` (`scripts/interactables/anchorable_object.gd`) obsługującą stan A i stan B, opór przed falą korekty, synchronizację fizyki (`sync_to_physics`), precyzyjną kalkulację odległości do obwiedni prostokąta (`get_distance_to_point`), wizualne ramki/piny cyjanowe, przezroczyste zarysy alternatywnej rzeczywistości oraz wyspecjalizowane rysowanie opuszczanych bram żaluzjowych z prowadnicami stalowymi.
- Zaimplementowano `AnchorLab` (`scripts/prototype/anchor_lab.gd`) z zasadą pojedynczej aktywnej kotwicy, animowaną falą korekty, architekturą fundamentów i instalacji sufitowych, rozbudowaną stacją śluzy pomiarowej `Goal` z dynamiczną wiązką skanującą oraz obsługą wejść semantycznych `interact` (`E`) i `trigger_correction` (`F`).
- Wdrożono sekwencję ukończenia sektora i ryglowania śluzy w `AnchorLab`:
  - animacja zaryglowania barier laserowych i osi optycznej śluzy;
  - sygnał `sector_completed` oraz stan `is_sector_completed`;
  - telemetryczny panel instytucjonalny (`_draw_sector_transition_overlay`) z paskiem stabilizacji konsensusu i płynnym wygaszeniem (fade-out).
- Zaimplementowano `MovableAnchorableProp` (`scripts/interactables/movable_anchorable_prop.gd`) — fizycznie przemieszczana skrzynia laboratoryjna rozszerzająca `CharacterBody2D`: grawitacja (640 px/s²), pchanie przez gracza (PUSH_CONTACT_DISTANCE = 36 px, push_speed_max = 64 px/s), selektywne zakotwiczenie zamrażające prędkość, opór przed falą korekty konsensusu, deterministyczny `reset_to_spawn()`, cząsteczki i dźwięk proceduralny.
- Rysowanie `MovableAnchorableProp` wzbogacono o proceduralne laboratoryjne oznaczenia zgodne z `VISUAL_DESIGN.md`: stalowe okucia narożne z nitami (`#A8B2AC`), stencile identyfikacyjne, retikuł korelacyjny, diodę inspekcyjną konsensusu, boczne uchwyty transportowe i górne karbowanie trakcyjne.
- Scena `scenes/prototype/anchor_lab.tscn` zawiera pełny 3-komorowy kompleks o szerokości 1920 px z ciągłą, bezszczelinową geometrią traktu oraz dwie skrzynie laboratoryjne: `Chamber2Crate` (`Vector2(780, 306)`) na dolnym poziomie oraz `Chamber2CrateB` (`Vector2(1080, 186)`) na antresoli.
- Zaimplementowano `CinematicCamera` (`scripts/camera/cinematic_camera.gd`) obsługującą dyskretne kadrowanie komorowe 640x360, wygładzanie ruchu, wyprzedzenie horyzontalne oraz wygaszanie traumy wstrząsu ekranu po fali korekty.
- Wdrożono interfejs w świecie gry: konsole aparatury na ścianach komór z fizycznymi lampami obecności Leny (bursztyn), stanu konsensusu (cyjan/cynober) i blokady kotwicy (cyjan). Brak sztucznego HUD-u.
- Rozszerzono `tests/smoke_test.gd` o automatyczną weryfikację:
  - pełnego przejścia MovementLab i AnchorLab (3 komory, zagadki skrzyń, brama i śluza Goal);
  - syntezy proceduralnego audio (w tym rezonansu pamięci, korelacji, drukarki, igły galwanometru, przełączników, szumu próżni, telefonu, czytnika kart, jarzeniówek, sygnału przejścia z szeptem, deszczu na asfalcie, trakcji tramwajowej, silnika autobusu, deszczu na szybach, komunikatu PA, pneumatyki drzwi, rezonansu złotej obrączki, kroków po parkiecie/kafelkach, szumu rur, skrobania szkła i shimmru lustra);
  - punktów rezonansu pamięci `MemoryResonancePoint` i przejścia procedury startowej `Station01`;
  - pełnego cyklu pomiaru w `Station02`: kalibracji, skoku wskaźnika korelacji powyżej progu, desynchronizacji klatek cienia `DiscontinuousShadow`, wydruku paska `WYNIK ZGODNY`, procedury abortu i otwarcia śluzy wyjściowej;
  - pełnego przejścia procedury i badania śladów w `Station03`: weryfikacji dwóch kubków, telefonu z 14 wiadomościami, tablicy dyżurów, skanu czytnika kart z dopiskiem "urlop przerwany" oraz odryglowania śluzy wyjściowej;
  - pełnego przejścia procedury w `Station04`: weryfikacji dialogu D-01, odcięcia zasilania lampy kamery i zasłonięcia obiektywu na słowa "Jakub nie żyje", odryglowania kołowrotu oraz przejścia przez wiatrołap;
  - pełnego przejścia procedury w `Station05`: badania afisza z 1978 r., badania budynku z wyciętym 3. piętrem, bezszwowej transformacji geometrii zaułka poza polem widzenia kamery (#geometry-restless-grid), aktywacji sygnalizatora przejścia z szeptem imienia Leny, badania rozkładu Linii Zastępczej 4 i wejścia na peron przystankowy ku Przestrzeni 06;
  - pełnego przejścia procedury w `Station06`: badania schematu trasy, aktywacji komunikatu głośnikowego UCP, pełnego dialogu ze starszym pasażerem i badania braku śladu po obrączce na szwie palca, inspekcji złotej obrączki na siedzeniu, wyhamowania i otwarcia drzwi pneumatycznych na przystanku Osiedle Tarasowe oraz przejścia ku Przestrzeni 07;
  - pełnego przejścia procedury w `Station07`: tablicy lokatorów, skrzynek pocztowych, włącznika czasowego, ślepych schodów, dialogu D-02 z Martą, otwarcia drzwi mieszkania i przejścia do Przestrzeni 08;
  - pełnego przejścia procedury w `Station08`: wieszaka z płaszczami, fotografii w oknie, gotującego się czajnika, zlewki-doniczki, pamiątki Jakuba, dialogu z Martą Kurek, odryglowania zamka szyfrowego 0311 i badania szkiców Podstruktury;
  - pełnego przejścia procedury w `Station09`: badania umywalki ceramicznej, szafki aptecznej, lustra z opóźnionym odbiciem, odkrycia inskrypcji `NIE SZUKAJ ORYGINAŁU` pod kątem bocznym, pełnego dialogu D-03 z Martą Kurek, zbadania znacznika instrukcji, jednostajnego przejścia korytarza ze stabilizacją geometrii i otwarciem drzwi wyjściowych ku Przestrzeni 10.
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

Potwierdzony wynik finalnej weryfikacji PKG-0027:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Kontrakt dokumentacji obejmuje `ADR-001` do `ADR-005` oraz aktualne nagłówki. Bramka weryfikuje istnienie wymaganych dokumentów, brak wiszących placeholderów, poprawne ładowanie klas (`ProceduralAudio`, `AnchorableObject`, `MovableAnchorableProp`, `CinematicCamera`, `AnchorLab`, `PrototypePlayer`, `MemoryResonancePoint`, `Station01`, `Station02`, `Station03`, `Station04`, `Station05`, `Station06`, `Station07`, `Station08`, `Station09`, `DiscontinuousShadow`) oraz test automatyczny kamer, stref komorowych, syntezy dźwięków proceduralnych (w tym kroków na linoleum/metalu/lastryko/parkiecie/kafelkach, lądowań, uszczelnienia śluzy, rezonansu pamięci, korelacji, drukarki taśmowej, igły galwanometru, przełączników, szumu próżni, telefonu, czytnika kart, jarzeniówek, odcięcia przekaźnika kamery, odryglowania kołowrotu, blipów dialogowych Leny/Strażnika/Marty, sygnału przejścia z formantowym szeptem imienia Leny, deszczu na asfalcie, trakcji tramwajowej, silnika diesla autobusu, deszczu na szybach, komunikatu PA, pneumatyki drzwi, złotej obrączki, skrzypienia i rygla drzwi mieszkania, przekaźnika włącznika schodowego, zamka szyfrowego szuflady, szelestu papierów technicznych, wrzenia i gwizdka czajnika, szumu wody w rurach, skrobania szkła i shimmru lustra), węzłów audio/cząsteczek, fizyki i logiki kotwiczenia oraz pełnego przejścia procedur w `station_01.tscn` .. `station_09.tscn` (weryfikacja badania umywalki, szafki aptecznej, lustra z opóźnionym odbiciem, odkrycia inskrypcji `NIE SZUKAJ ORYGINAŁU` pod kątem bocznym, pełnego dialogu D-03 z Martą, stabilizacji korytarza i odryglowania drzwi ku Przestrzeni 10).

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

- Automatyczne testy potwierdzaja kontrakty plikow, generowanie buforów audio, zachowanie kamery kinowej, grayboxu oraz logikę kotwiczenia, pchania skrzyń, pełnego przejścia 3 komór `AnchorLab`, procedury startowej `Station01`, procedury pomiaru w `Station02`, badania śladów niezgodności w `Station03`, dialogu i mechaniki kołowrotu w `Station04`, transformacji geometrii zaułka i sygnalizatora w `Station05`, ruchu autobusu i dialogu pasażera w `Station06`, klatki schodowej i dialogu D-02 w `Station07`, wnętrza mieszkania 14 w `Station08` oraz łazienki z opóźnionym lustrem, inskrypcją `NIE SZUKAJ ORYGINAŁU`, dialogiem D-03 i stabilizacją korytarza w `Station09`, nie subiektywną satysfakcję (game feel) gracza.
- `DOCS PASS` sprawdza istnienie plikow i obecnosc naglowkow.
- Cofanie jest ograniczone do snapshotów (`tools/snapshot.ps1`).

## Nastepny pakiet

`PKG-0028: P3 Vertical Slice — Telefon Jakuba (Przestrzeń 10)`

Cel: Implementacja Przestrzeni 10 z `FULL_STORY.md` (Telefon Jakuba / Gabinet domowy i korytarz techniczny):
- Gabinet domowy w mieszkaniu 14: biurko z lampką z zielonym kloszem, czarny telefon stacjonarny bakelitowy z tarczą numerową, magnetofon szpulowy z taśmami nagraniowymi Jakuba, ścienna tablica korkowa z wycinkami z gazet i szkicami topologii Równi.
- Dzwoniący telefon: po odebraniu słuchawki odtwarzany jest głos Jakuba (lub zniekształcony szum z modulacją głosu) — konfrontacja z faktem, że Jakub żyje w tej gałęzi, lecz pamięta inne wydarzenia niż Lena.
- Odkrycie i odtworzenie taśmy szpulowej z nagraniem Jakuba z dnia wypadku: ujawnienie kluczowej poszlaki o Podstrukturze.
- Proceduralne audio w `ProceduralAudio` (dzwonek telefonu bakelitowego, klik podniesienia słuchawki, szum taśmy magnetycznej i przekaźnik magnetofonu).
- Przejście do Aktu II (Przestrzeń 11: Zaułek za osiedlem / Poranny chłód).

Pakiet jest realizowany w 100% autonomicznie przez AI.

## Punkt przekazania

Nowa sesja zaczyna od swiezej weryfikacji (`tools/verify.ps1`), czyta `AGENTS.md`, `INDEX.md`, ten
plik i `NEXT_SESSION_PROMPT.md`, a nastepnie przechodzi do realizacji PKG-0028.





