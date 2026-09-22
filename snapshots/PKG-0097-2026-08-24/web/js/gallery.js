/**
 * GETTING STRANGE — Gallery Module (Bilingual PL/EN)
 * Full database of 43 Narrative Spaces rendered directly from Godot Engine 4.7.
 */

const STATIONS_DATA = [
  // PROLOG: POMIAR (01..02)
  {
    id: "station_01",
    act: "prolog",
    actTitle: "Prolog — Pomiar",
    actTitleEn: "Prologue — Measurement",
    number: "01",
    title: "Sterownia IKP / Początek zmiany",
    titleEn: "IKP Control Room / Shift Start",
    image: "assets/reports/station_01.png",
    activeImage: "assets/reports/station_01_active.png",
    brief: "Pomiary fali nośnej, stół laboratoryjny i kalibracja oscyloskopu o 21:45.",
    briefEn: "Carrier wave measurements, lab bench, and oscilloscope calibration at 21:45.",
    props: "Pulpit sterowniczy IKP, lampa wyładowcza, oscyloskop próżniowy",
    propsEn: "IKP control desk, gas-discharge lamp, vacuum oscilloscope",
    color: "cyan"
  },
  {
    id: "station_02",
    act: "prolog",
    actTitle: "Prolog — Pomiar",
    actTitleEn: "Prologue — Measurement",
    number: "02",
    title: "Komora Pomiarowa / Nieciągłość cienia",
    titleEn: "Measurement Chamber / Discontinuous Shadow",
    image: "assets/reports/station_02.png",
    activeImage: "assets/reports/station_02_correlation.png",
    brief: "Pierwsza mikroniezgodność: cień Leny załamuje się o 12 stopni niezgodnie ze źródłem światła.",
    briefEn: "First micro-discrepancy: Lena's shadow refracts by 12 degrees out of light alignment.",
    props: "Kamera pomiarowa, fotokomórka, nieciągły cień, linia bazowa",
    propsEn: "Measurement camera, photocell, discontinuous shadow, baseline",
    color: "cyan"
  },

  // AKT I: PĘKNIĘCIE (03..10)
  {
    id: "station_03",
    act: "akt1",
    actTitle: "Akt I — Pęknięcie",
    actTitleEn: "Act I — Fracture",
    number: "03",
    title: "Puste Laboratorium / Dwa kubki",
    titleEn: "Empty Laboratory / Two Cups",
    image: "assets/reports/station_03.png",
    activeImage: "assets/reports/station_03_desk.png",
    brief: "Dwa ciepłe kubki na stole, 14 nieodebranych wiadomości i czytnik 'URLOP PRZERWANY'.",
    briefEn: "Two warm cups on the desk, 14 missed calls, and card reader showing 'LEAVE INTERRUPTED'.",
    props: "Dwa kubki laboratoryjne, telefon bakelitowy, czytnik kart zakładowych",
    propsEn: "Two lab mugs, bakelite telephone, employee badge reader",
    color: "amber"
  },
  {
    id: "station_04",
    act: "akt1",
    actTitle: "Akt I — Pęknięcie",
    actTitleEn: "Act I — Fracture",
    number: "04",
    title: "Bramka IKP / Rozmowa ze strażnikiem",
    titleEn: "IKP Gate / Dialogue with Guard",
    image: "assets/reports/station_04.png",
    activeImage: "assets/reports/station_04_bramka.png",
    brief: "Dialog D-01: 'Jakub nie żyje' — lampa kamery gaśnie natychmiast, strażnik zasłania obiektyw.",
    briefEn: "Dialogue D-01: 'Jakub is dead' — camera tally light dies instantly, guard blocks the lens.",
    props: "Kołowrót ze stali nierdzewnej, kamera przemysłowa, tablica UCP",
    propsEn: "Stainless steel turnstile, surveillance camera, UCP board",
    color: "amber"
  },
  {
    id: "station_05",
    act: "akt1",
    actTitle: "Akt I — Pęknięcie",
    actTitleEn: "Act I — Fracture",
    number: "05",
    title: "Rówień nocą / Afisz i znikające piętro",
    titleEn: "Rówień by Night / Poster & Vanished Floor",
    image: "assets/reports/station_05.png",
    activeImage: "assets/reports/station_05_crosswalk.png",
    brief: "Pasy z nazwiskiem Leny, afisz z 1978 roku i blok z wymazanym trzecim piętrem.",
    briefEn: "Crosswalk with Lena's name, 1978 event poster, and residential block with erased 3rd floor.",
    props: "Słup afiszowy, sygnalizator przejścia, modernistyczna fasada",
    propsEn: "Advertising column, crosswalk acoustic beacon, modernist facade",
    color: "cyan"
  },
  {
    id: "station_06",
    act: "akt1",
    actTitle: "Akt I — Pęknięcie",
    actTitleEn: "Act I — Fracture",
    number: "06",
    title: "Linia Zastępcza / Nocny autobus",
    titleEn: "Replacement Line / Night Bus",
    image: "assets/reports/station_06.png",
    activeImage: "assets/reports/station_06_arrival.png",
    brief: "Jazda nocnym autobusem, bilet z alternatywną trasą i znalezienie złotej obrączki w kieszeni.",
    briefEn: "Night bus ride, punch ticket with alternate route, and finding the gold ring in coat pocket.",
    props: "Poręcze autobusu, kasownik mechaniczny, złota obrączka",
    propsEn: "Bus handrails, mechanical punch validator, gold ring",
    color: "amber"
  },
  {
    id: "station_07",
    act: "akt1",
    actTitle: "Akt I — Pęknięcie",
    actTitleEn: "Act I — Fracture",
    number: "07",
    title: "Klatka schodowa / Ślepe schody",
    titleEn: "Stairwell / Blind Staircase",
    image: "assets/reports/station_07.png",
    activeImage: "assets/reports/station_07_door.png",
    brief: "Dialog D-02 z Martą Kurek, badanie skrzynek pocztowych i schody prowadzące w betonowy sufit.",
    briefEn: "Dialogue D-02 with Marta Kurek, checking mailboxes, and stairs heading into solid concrete.",
    props: "Skrzynki pocztowe, ślepy bieg schodów, drzwi Mieszkania 14",
    propsEn: "Mailboxes, dead-end stairs, Flat 14 door",
    color: "amber"
  },
  {
    id: "station_08",
    act: "akt1",
    actTitle: "Akt I — Pęknięcie",
    actTitleEn: "Act I — Fracture",
    number: "08",
    title: "Mieszkanie po kimś / Szyfr 0311",
    titleEn: "Flat Left Behind / Code 0311",
    image: "assets/reports/station_08.png",
    activeImage: "assets/reports/station_08_desk.png",
    brief: "Rekwizyty podwójnego zastosowania, czajnik na gazie i szyfr 0311 w szufladzie biurka.",
    briefEn: "Dual-purpose belongings, boiling kettle, and combination lock 0311 in desk drawer.",
    props: "Wieszak na płaszcze, parujący czajnik, biurko z szufladą szyfrową",
    propsEn: "Coat rack, steaming kettle, desk with combination drawer",
    color: "amber"
  },
  {
    id: "station_09",
    act: "akt1",
    actTitle: "Akt I — Pęknięcie",
    actTitleEn: "Act I — Fracture",
    number: "09",
    title: "Pokój, który nie czeka / Lustro i napis",
    titleEn: "Unwaiting Room / Mirror & Inscription",
    image: "assets/reports/station_09.png",
    activeImage: "assets/reports/station_09_mirror.png",
    brief: "Opóźnione odbicie i inskrypcja pod kątem: 'NIE SZUKAJ ORYGINAŁU' (Poszlaka R-02).",
    briefEn: "Lagging reflection and etched angle inscription: 'DO NOT SEEK ORIGINAL' (Clue R-02).",
    props: "Lustro łazienkowe, apteczka, wyryty napis pod kątem",
    propsEn: "Bathroom mirror, medicine cabinet, angled etched inscription",
    color: "crimson"
  },
  {
    id: "station_10",
    act: "akt1",
    actTitle: "Akt I — Pęknięcie",
    actTitleEn: "Act I — Fracture",
    number: "10",
    title: "Telefon Jakuba / Rozmowa zza zasłony",
    titleEn: "Jakub's Telephone / Behind the Curtain",
    image: "assets/reports/station_10.png",
    activeImage: "assets/reports/station_10_phone.png",
    brief: "Telefon od zmarłego brata (D-04): 'Nie odkładaj. Jeśli odłożysz, ten pokój znowu będzie pusty'.",
    briefEn: "Call from deceased brother (D-04): 'Don't hang up. If you hang up, this room is empty again.'",
    props: "Bakelitowy aparat telefoniczny, magnetofon szpulowy, okno z zasłoną",
    propsEn: "Bakelite telephone, reel-to-reel recorder, curtained window",
    color: "amber"
  },

  // AKT II: KOREKTA (11..28)
  {
    id: "station_11",
    act: "akt2",
    actTitle: "Akt II — Korekta",
    actTitleEn: "Act II — Correction",
    number: "11",
    title: "Pierwsza korekta / Dziedziniec UCP",
    titleEn: "First Correction / UCP Courtyard",
    image: "assets/reports/station_11.png",
    activeImage: "assets/reports/station_11_intervention.png",
    brief: "Interwencja brygady UCP na dwupoziomowym dziedzińcu: ratunek kobiety przed wygładzeniem szwu.",
    briefEn: "UCP field squad intervention on multi-tier courtyard: rescuing woman before seam smoothing.",
    props: "Stempel korekcyjny UCP, pęknięty mur dziedzińca, opaska bezpieczeństwa",
    propsEn: "UCP correction stamp, cracked brickwork, security cordoning",
    color: "cyan"
  },
  {
    id: "station_12",
    act: "akt2",
    actTitle: "Akt II — Korekta",
    actTitleEn: "Act II — Correction",
    number: "12",
    title: "Pokaz bezpieczeństwa / Przejście podziemne",
    titleEn: "Safety Demonstration / Underpass",
    image: "assets/reports/station_12.png",
    activeImage: "assets/reports/station_12_terminal.png",
    brief: "Podziemny pasaż handlowy, instrukcja UCP i terminal z dwoma sprzecznymi rozkładami jazdy.",
    briefEn: "Subterranean concourse, UCP safety signage, and terminal showing dual conflicting timetables.",
    props: "Terminal informacyjny CRT, gablota UCP, schody ruchome",
    propsEn: "CRT information terminal, UCP notice board, escalators",
    color: "cyan"
  },
  {
    id: "station_13",
    act: "akt2",
    actTitle: "Akt II — Korekta",
    actTitleEn: "Act II — Correction",
    number: "13",
    title: "Adres ciągłości / Pracownia fotograficzna",
    titleEn: "Continuity Address / Darkroom",
    image: "assets/reports/station_13.png",
    activeImage: "assets/reports/station_13_photo.png",
    brief: "Stół montażowy i analiza dwóch fotografii tego samego peronu z różnymi cieniami.",
    briefEn: "Light table and analysis of two identical platform photos showing divergent shadows.",
    props: "Stół podświetlany, powiększalnik fotograficzny, suszarka odbitek",
    propsEn: "Drafting light table, photo enlarger, print drying rack",
    color: "amber"
  },
  {
    id: "station_14",
    act: "akt2",
    actTitle: "Akt II — Korekta",
    actTitleEn: "Act II — Correction",
    number: "14",
    title: "Zakotwiczenie / Maszynownia wentylatorów",
    titleEn: "Anchoring / Ventilation Machine Room",
    image: "assets/reports/station_14.png",
    activeImage: "assets/reports/station_14_anchored.png",
    brief: "Pierwsze użycie mechaniki kotwiczenia w świecie zewnętrznym w celu zatrzymania fali korekty.",
    briefEn: "First real-world execution of Anchor mechanic to halt advancing UCP correction wave.",
    props: "Wentylator przemysłowy, suwnica pomiarowa, kotwiczona skrzynia",
    propsEn: "Industrial exhaust fan, measurement crane, anchored crate",
    color: "cyan"
  },
  {
    id: "station_15",
    act: "akt2",
    actTitle: "Akt II — Korekta",
    actTitleEn: "Act II — Correction",
    number: "15",
    title: "Korytarz serwisowy / Kałuża z odwróconym cieniem",
    titleEn: "Service Corridor / Inverted Shadow Puddle",
    image: "assets/reports/station_15.png",
    activeImage: "assets/reports/station_15_reflection.png",
    brief: "Przejście technicznym traktem i odbicie w kałuży, które nie naśladuje bieżącego ruchu Leny.",
    briefEn: "Traversing technical conduit; reflection in water puddle refuses to track Lena's motion.",
    props: "Zawory ciśnieniowe, kałuża techniczna, kładka stalowa",
    propsEn: "Pressure relief valves, technical puddle, steel catwalk",
    color: "cyan"
  },
  {
    id: "station_16",
    act: "akt2",
    actTitle: "Akt II — Korekta",
    actTitleEn: "Act II — Correction",
    number: "16",
    title: "Rozmowa przy stole / Herbata i ciastka",
    titleEn: "Table Conversation / Tea & Biscuits",
    image: "assets/reports/station_16.png",
    activeImage: "assets/reports/station_16_choice.png",
    brief: "Dialog D-05 z Martą Kurek w kuchni: konfrontacja o rezygnacji z poszukiwania jedynej prawdy.",
    briefEn: "Dialogue D-05 with Marta Kurek in kitchen: confrontation over relinquishing singular truth.",
    props: "Stół kuchenny, imbryk ceramiczny, teczka z dokumentami",
    propsEn: "Kitchen table, ceramic teapot, document portfolio",
    color: "amber"
  },
  {
    id: "station_17",
    act: "akt2",
    actTitle: "Akt II — Korekta",
    actTitleEn: "Act II — Correction",
    number: "17",
    title: "Punkt Zgodności 6 / Sala obsługi UCP",
    titleEn: "Consistency Point 6 / UCP Hall",
    image: "assets/reports/station_17.png",
    activeImage: "assets/reports/station_17_interview.png",
    brief: "Kolejka petentów oddających sprzeczne pamiątki i pobranie numerka do dr Heleny Wierzbickiej.",
    briefEn: "Queue of citizens surrendering conflicting relics and drawing ticket for Dr Helena Wierzbicka.",
    props: "Dozownik biletów, ławki poczekalni, okienko podawcze",
    propsEn: "Ticket dispenser, waiting benches, pneumatic intake booth",
    color: "amber"
  },
  {
    id: "station_18",
    act: "akt2",
    actTitle: "Akt II — Korekta",
    actTitleEn: "Act II — Correction",
    number: "18",
    title: "Wywiad zgodności / Gabinet dr Wierzbickiej",
    titleEn: "Consistency Interview / Dr Wierzbicka's Office",
    image: "assets/reports/station_18.png",
    activeImage: "assets/reports/station_18_interview.png",
    brief: "Dialog D-06 z dr Wierzbicką: obrona polityki wygładzania i pomiar galwanometrem sensorycznym.",
    briefEn: "Dialogue D-06 with Dr Wierzbicka: defense of smoothing policy & galvanometer testing.",
    props: "Biurko orzechowe, galwanometr sensoryczny, stempel UCP",
    propsEn: "Walnut executive desk, sensory galvanometer, UCP seal",
    color: "cyan"
  },
  {
    id: "station_19",
    act: "akt2",
    actTitle: "Akt II — Korekta",
    actTitleEn: "Act II — Correction",
    number: "19",
    title: "Model bez oryginału / Sala archiwum makiet",
    titleEn: "Model Without Original / Scale Archive Room",
    image: "assets/reports/station_19.png",
    activeImage: "assets/reports/station_19_models.png",
    brief: "Trójwymiarowe miniatury budynków Równi, gdzie układ ścian nie odpowiada żadnemu planowi.",
    briefEn: "3D architectural models of Rówień where room layouts match no registered blueprint.",
    props: "Stół makietowy, gablota z planami, rejestr 11 nazwisk",
    propsEn: "Model exhibition table, architectural case, 11-name ledger",
    color: "cyan"
  },
  {
    id: "station_20",
    act: "akt2",
    actTitle: "Akt II — Korekta",
    actTitleEn: "Act II — Correction",
    number: "20",
    title: "Sala Szymona / Pokój z rysunkami woskowymi",
    titleEn: "Szymon's Room / Crayon Drawing Chamber",
    image: "assets/reports/station_20.png",
    activeImage: "assets/reports/station_20_szymon.png",
    brief: "Dialog D-07 z Szymonem Berą: świadek, który pamięta trzy wersje mostu i rysuje je warstwami.",
    briefEn: "Dialogue D-07 with Szymon Bera: witness remembering three bridge versions drawing in wax layers.",
    props: "Rysunki woskowe na ścianie, łóżko szpitalne, stół kreślarski",
    propsEn: "Wax wall drawings, clinical cot, drafting table",
    color: "amber"
  },
  {
    id: "station_21",
    act: "akt2",
    actTitle: "Akt II — Korekta",
    actTitleEn: "Act II — Correction",
    number: "21",
    title: "Cena ulgi / Gabinet sedacji sensorycznej",
    titleEn: "Cost of Relief / Sensory Sedation Ward",
    image: "assets/reports/station_21.png",
    activeImage: "assets/reports/station_21_szymon.png",
    brief: "Aparatura farmakologiczna UCP podająca roztwór wygaszający wspomnienia alternatywne.",
    briefEn: "UCP pharmacological apparatus administering sedative that extinguishes divergent memories.",
    props: "Fotel zabiegowy, infuzor kroplowy, tablica wskaźników EEG",
    propsEn: "Treatment recliner, drip infuser, EEG monitor array",
    color: "amber"
  },
  {
    id: "station_22",
    act: "akt2",
    actTitle: "Akt II — Korekta",
    actTitleEn: "Act II — Correction",
    number: "22",
    title: "Uległość / Bramka tożsamości",
    titleEn: "Yielding / Identity Barrier",
    image: "assets/reports/station_22.png",
    activeImage: "assets/reports/station_22_yield.png",
    brief: "Konfrontacja z mechaniką Uległości (Yield): rezygnacja z oporu w zamian za stabilizację.",
    briefEn: "Confrontation with Yield mechanic: relinquishing resistance in exchange for systemic stability.",
    props: "Bramka tożsamości, czytnik biometryczny, lampa weryfikacji",
    propsEn: "Identity turnstile, biometric scanner, verification beam",
    color: "crimson"
  },
  {
    id: "station_23",
    act: "akt2",
    actTitle: "Akt II — Korekta",
    actTitleEn: "Act II — Correction",
    number: "23",
    title: "Pokój projektantki / Stacja projektowa CAD-78",
    titleEn: "Designer's Room / CAD-78 Station",
    image: "assets/reports/station_23.png",
    activeImage: "assets/reports/station_23_terminal.png",
    brief: "Terminal z projektem Podstruktury i odręczną notatką: 'Zostawiliśmy szew, żeby wiedzieć gdzie uciekać'.",
    briefEn: "Terminal with Substructure schematics and handwritten note: 'We left a seam to know where to flee.'",
    props: "Terminal wektorowy CRT, stół kalibracyjny, dyskietka magnetyczna",
    propsEn: "Vector CRT terminal, calibration board, 8-inch magnetic disk",
    color: "cyan"
  },
  {
    id: "station_24",
    act: "akt2",
    actTitle: "Akt II — Korekta",
    actTitleEn: "Act II — Correction",
    number: "24",
    title: "Marta pod obserwacją / Monitoring Mieszkania 14",
    titleEn: "Marta Under Surveillance / Flat 14 CCTV",
    image: "assets/reports/station_24.png",
    activeImage: "assets/reports/station_24_cctv.png",
    brief: "Ekrany monitoringu pokazujące Martę pijącą samotną herbatę i transmisja dr Wierzbickiej.",
    briefEn: "CCTV monitors showing Marta drinking tea alone, intercut with Dr Wierzbicka's transmission.",
    props: "Ściana monitorów CCTV, pulpit selektora kamer, interkom",
    propsEn: "CCTV monitor bank, camera selector console, intercom",
    color: "crimson"
  },
  {
    id: "station_25",
    act: "akt2",
    actTitle: "Akt II — Korekta",
    actTitleEn: "Act II — Correction",
    number: "25",
    title: "Wejście Jakuba / Tranzyt Linii 4",
    titleEn: "Jakub's Entry / Line 4 Transit",
    image: "assets/reports/station_25.png",
    activeImage: "assets/reports/station_25_jakub.png",
    brief: "Dialog D-09 z Jakubem Wolskim w roboczym uniformie UCP: blizna pod lewym żebrem i wybór.",
    briefEn: "Dialogue D-09 with Jakub Wolski in UCP overalls: ribcage scar revelation and mutual boundary.",
    props: "Wózek techniczny torowiska, wykres blizny, postać Jakuba",
    propsEn: "Track maintenance trolley, scar anatomy chart, Jakub figure",
    color: "amber"
  },
  {
    id: "station_26",
    act: "akt2",
    actTitle: "Akt II — Korekta",
    actTitleEn: "Act II — Correction",
    number: "26",
    title: "Próba zamknięcia / Śluza dekompresyjna",
    titleEn: "Closure Attempt / Decompression Airlock",
    image: "assets/reports/station_26.png",
    activeImage: "assets/reports/station_26.png",
    brief: "Masywna śluza ciśnieniowa izolująca strefę administracyjną od głębokiej Podstruktury.",
    briefEn: "Massive pressure airlock isolating administrative sector from deep Substructure.",
    props: "Rygiel hydrauliczny, manometr różnicowy, zawór upustowy",
    propsEn: "Hydraulic lock bolt, differential manometer, relief valve",
    color: "cyan"
  },
  {
    id: "station_27",
    act: "akt2",
    actTitle: "Akt II — Korekta",
    actTitleEn: "Act II — Correction",
    number: "27",
    title: "Wygładzanie muru / Korytarz zerowy",
    titleEn: "Wall Smoothing / Zero Corridor",
    image: "assets/reports/station_27.png",
    activeImage: "assets/reports/station_27.png",
    brief: "Ściany tracące fakturę i spoiny pod wpływem ciągłego pola stabilizacyjnego UCP.",
    briefEn: "Concrete walls losing texture and joints under continuous UCP field stabilization.",
    props: "Emiter polowy UCP, wygładzona ściana, czujnik naprężeń",
    propsEn: "UCP field emitter, smoothed surface, stress gauge",
    color: "cyan"
  },
  {
    id: "station_28",
    act: "akt2",
    actTitle: "Akt II — Korekta",
    actTitleEn: "Act II — Correction",
    number: "28",
    title: "Zejście do Podstruktury / Szyb windowy -20 m",
    titleEn: "Descent to Substructure / Lift Shaft -20 m",
    image: "assets/reports/station_28.png",
    activeImage: "assets/reports/station_28.png",
    brief: "Klatka schodowa i zardzewiała winda towarowa zjeżdżająca poniżej poziomu fundamentów miasta.",
    briefEn: "Industrial stairwell and rusted freight hoist descending below city foundations.",
    props: "Winda towarowa, wciągarka linowa, tablica ostrzegawcza",
    propsEn: "Freight hoist, cable winch, high-risk warning plate",
    color: "amber"
  },

  // AKT III: PODSTRUKTURA (29..39)
  {
    id: "station_29",
    act: "akt3",
    actTitle: "Akt III — Podstruktura",
    actTitleEn: "Act III — Substructure",
    number: "29",
    title: "Sufit bez piętra / Poziom -25 m",
    titleEn: "Ceiling Without Floor / Level -25 m",
    image: "assets/reports/station_29.png",
    activeImage: "assets/reports/station_29.png",
    brief: "Konstrukcje nośne podtrzymujące pustkę po wymazanych kondygnacjach mieszkalnych.",
    briefEn: "Structural pillars bearing loads for void left by erased residential levels.",
    props: "Stalowe filary nośne, napinacze cięgnowe, szalunki",
    propsEn: "Steel load pillars, tension cables, industrial formwork",
    color: "amber"
  },
  {
    id: "station_30",
    act: "akt3",
    actTitle: "Akt III — Podstruktura",
    actTitleEn: "Act III — Substructure",
    number: "30",
    title: "Zbiornik kondensatu / Chłodzenie rdzenia",
    titleEn: "Condensate Tank / Core Cooling",
    image: "assets/reports/station_30.png",
    activeImage: "assets/reports/station_30.png",
    brief: "Basen technologiczny z ciepłą wodą kondensacyjną odbijającą nieistniejące jarzeniówki.",
    briefEn: "Cooling pond of warm condensate mirroring phantom fluorescent lamps overhead.",
    props: "Pompa obiegowa, pomost kratowy, rurociąg chłodniczy",
    propsEn: "Circulation pump, steel grating walkway, coolant pipes",
    color: "cyan"
  },
  {
    id: "station_31",
    act: "akt3",
    actTitle: "Akt III — Podstruktura",
    actTitleEn: "Act III — Substructure",
    number: "31",
    title: "Podwójna zwrotnica / Tory Linii 4 pod ziemią",
    titleEn: "Dual Switch / Underground Line 4 Tracks",
    image: "assets/reports/station_31.png",
    activeImage: "assets/reports/station_31.png",
    brief: "Miejsce fizycznego rozwidlenia torowiska, gdzie oba warianty biegną równolegle przez 60 metrów.",
    briefEn: "Physical rail fork where both track variants run parallel in concrete sleeve for 60 meters.",
    props: "Iglica zwrotnicy, dźwignia ręczna, sygnalizator świetlny",
    propsEn: "Track point blade, manual throw lever, signal head",
    color: "amber"
  },
  {
    id: "station_32",
    act: "akt3",
    actTitle: "Akt III — Podstruktura",
    actTitleEn: "Act III — Substructure",
    number: "32",
    title: "Rejestr jedenastu / Tablica imienna",
    titleEn: "Ledger of Eleven / Name Roster",
    image: "assets/reports/station_32.png",
    activeImage: "assets/reports/station_32.png",
    brief: "Odręcznie sporządzona tablica z nazwiskami 11 osób wygaszonych podczas pierwszej korekty.",
    briefEn: "Hand-scribed board bearing names of 11 persons smoothed away during First Correction.",
    props: "Emaliowana tablica, notatnik służbowy, lampa naftowa",
    propsEn: "Enamel roster plate, field logbook, storm lantern",
    color: "crimson"
  },
  {
    id: "station_33",
    act: "akt3",
    actTitle: "Akt III — Podstruktura",
    actTitleEn: "Act III — Substructure",
    number: "33",
    title: "Komora korelacji / Stół z nośną 740 Hz",
    titleEn: "Correlation Chamber / 740 Hz Bench",
    image: "assets/reports/station_33.png",
    activeImage: "assets/reports/station_33.png",
    brief: "Duplikat aparatury laboratoryjnej Leny zmontowany w podziemiach przez nieznaną grupę.",
    briefEn: "Duplicate of Lena's lab apparatus assembled in undercroft by unknown personnel.",
    props: "Stół oscyloskopowy, generator funkcyjny, cewki korelacji",
    propsEn: "Oscilloscope bench, function generator, correlation coils",
    color: "cyan"
  },
  {
    id: "station_34",
    act: "akt3",
    actTitle: "Akt III — Podstruktura",
    actTitleEn: "Act III — Substructure",
    number: "34",
    title: "Maszynownia Główna / Rekonstrukcja pamięci",
    titleEn: "Main Engine Room / Memory Reconstruction",
    image: "assets/reports/station_34.png",
    activeImage: "assets/reports/station_34.png",
    brief: "Dialog D-17 z Jakubem: Lena uświadamia sobie, że jej własny świat powstał w wyniku wcześniejszej korekty.",
    briefEn: "Dialogue D-17 with Jakub: Lena realizes her native timeline was born from an earlier correction.",
    props: "Turbogenerator parowy, rejestrator taśmowy, szafa przekaźników",
    propsEn: "Steam turbo-generator, magnetic tape deck, relay cabinet",
    color: "amber"
  },
  {
    id: "station_35",
    act: "akt3",
    actTitle: "Akt III — Podstruktura",
    actTitleEn: "Act III — Substructure",
    number: "35",
    title: "Węzeł przekaźnikowy / Sieć świadków",
    titleEn: "Relay Node / Witness Network",
    image: "assets/reports/station_35.png",
    activeImage: "assets/reports/station_35.png",
    brief: "Stacja dystrybucji sygnału radiowego łącząca aparaty telefoniczne 37 mieszkań w Równi.",
    briefEn: "Radio relay exchange wiring telephone lines across 37 residences in Rówień.",
    props: "Krosownica telefoniczna, wzmacniacz lampowy, mikrofon",
    propsEn: "Telephone switchboard, valve amplifier, carbon microphone",
    color: "cyan"
  },
  {
    id: "station_36",
    act: "akt3",
    actTitle: "Akt III — Podstruktura",
    actTitleEn: "Act III — Substructure",
    number: "36",
    title: "Szyb kablowy / Wiązka zerowa",
    titleEn: "Cable Conduit / Zero Bundle",
    image: "assets/reports/station_36.png",
    activeImage: "assets/reports/station_36.png",
    brief: "Pionowy szyb kablowy z ołowianymi pancerzami przewodzącymi prąd nośny do Rdzenia.",
    briefEn: "Vertical shaft carrying lead-sheathed conduits channeling carrier current to Core.",
    props: "Korytka kablowe, drabina ze stali nierdzewnej, puszkownik",
    propsEn: "Cable trays, stainless ladder, junction boxes",
    color: "cyan"
  },
  {
    id: "station_37",
    act: "akt3",
    actTitle: "Akt III — Podstruktura",
    actTitleEn: "Act III — Substructure",
    number: "37",
    title: "Przedpole Rdzenia / Brama ekranująca",
    titleEn: "Core Forecourt / Shielding Portal",
    image: "assets/reports/station_37.png",
    activeImage: "assets/reports/station_37.png",
    brief: "Masywna ołowiana brama chroniąca personel przed bezpośrednim promieniowaniem kwantowym.",
    briefEn: "Massive lead portal protecting personnel from raw quantum resonance radiation.",
    props: "Wrota ołowiane, przeciwwagi żeliwne, zamek ryglujący",
    propsEn: "Lead-lined gate, cast-iron counterweights, interlock",
    color: "crimson"
  },
  {
    id: "station_38",
    act: "akt3",
    actTitle: "Akt III — Podstruktura",
    actTitleEn: "Act III — Substructure",
    number: "38",
    title: "Pomost techniczny / Nad próżnią",
    titleEn: "Technical Catwalk / Over the Void",
    image: "assets/reports/station_38.png",
    activeImage: "assets/reports/station_38.png",
    brief: "Ażurowy pomost zawieszony 30 metrów nad komorą rezonansową Rdzenia.",
    briefEn: "Open grating bridge suspended 30 meters above Core resonance vault.",
    props: "Krata pomostowa, barierka asekuracyjna, reflektor roboczy",
    propsEn: "Catwalk grating, safety harness line, halogen floodlight",
    color: "cyan"
  },
  {
    id: "station_39",
    act: "akt3",
    actTitle: "Akt III — Podstruktura",
    actTitleEn: "Act III — Substructure",
    number: "39",
    title: "Monolit Rdzenia / Spotkanie ze Śladem",
    titleEn: "Core Monolith / Encounter with Trace",
    image: "assets/reports/station_39.png",
    activeImage: "assets/reports/station_39.png",
    brief: "Dialog D-18 ze Śladem (odpowiedniczką Leny): decyzja o losie szwu wymiarowego Równi.",
    briefEn: "Dialogue D-18 with Trace (Lena's counterpart): resolution of Rówień's dimensional seam.",
    props: "Monolit Rdzenia, kryształ próżniowy, postać Śladu",
    propsEn: "Core Monolith, vacuum crystal chamber, Trace entity",
    color: "cyan"
  },

  // AKT IV: SYGNAŁ POWROTU (40..43)
  {
    id: "station_40",
    act: "akt4",
    actTitle: "Akt IV — Sygnał powrotu",
    actTitleEn: "Act IV — Return Signal",
    number: "40",
    title: "Pulpit wyboru / Rozwidlenie sygnału",
    titleEn: "Choice Console / Signal Fork",
    image: "assets/reports/station_40.png",
    activeImage: "assets/reports/station_40.png",
    brief: "Główny pulpit nastawczy: ustawienie przełącznika hebelkowego na A (Powrót), B (Uzgodnienie) lub C (Świadectwo).",
    briefEn: "Master dispatch console: setting toggle switches to A (Return), B (Reconciliation), or C (Testimony).",
    props: "Przełączniki hebelkowe, woltomierz analogowy, stacyjka kluczykowa",
    propsEn: "Toggle switch array, moving-coil voltmeter, keyed ignition",
    color: "amber"
  },
  {
    id: "station_41",
    act: "akt4",
    actTitle: "Akt IV — Sygnał powrotu",
    actTitleEn: "Act IV — Return Signal",
    number: "41",
    title: "Tunel tranzytowy / Bieg ku światłu",
    titleEn: "Transit Tunnel / Run Toward Light",
    image: "assets/reports/station_41.png",
    activeImage: "assets/reports/station_41.png",
    brief: "Bieg przez zalany tunel kolejowy w stronę wybranego wariantu rzeczywistości.",
    briefEn: "Running through flooded rail gallery toward the chosen reality variant.",
    props: "Szyny tramwajowe, woda gruntowa, daleki portal świetlny",
    propsEn: "Tramway rails, groundwater pool, distant light portal",
    color: "cyan"
  },
  {
    id: "station_42a",
    act: "akt4",
    actTitle: "Akt IV — Sygnał powrotu",
    actTitleEn: "Act IV — Return Signal",
    number: "42A",
    title: "Finał A: Powrót / Własny pokój o 21:45",
    titleEn: "Ending A: Return / Own Lab at 21:45",
    image: "assets/reports/station_42a.png",
    activeImage: "assets/reports/station_42a.png",
    brief: "Powrót do laboratorium IKP. Ciepła kawa, fotografia Jakuba i telefon od Marty Kurek o 22:30.",
    briefEn: "Return to IKP laboratory. Warm mug, portrait of adult Jakub, and phone ringing from Marta at 22:30.",
    props: "Stół laboratoryjny, fotografia brata, dzwoniący telefon",
    propsEn: "Lab table, framed brother photograph, ringing phone",
    color: "cyan"
  },
  {
    id: "station_42b",
    act: "akt4",
    actTitle: "Akt IV — Sygnał powrotu",
    actTitleEn: "Act IV — Return Signal",
    number: "42B",
    title: "Finał B: Uzgodnienie / Miejsce po niej",
    titleEn: "Ending B: Reconciliation / Her Place",
    image: "assets/reports/station_42b.png",
    activeImage: "assets/reports/station_42b.png",
    brief: "Powrót do Mieszkania 14. Marta czeka w progu, a szew w futrynie staje się wspólną prawdą.",
    briefEn: "Return to Flat 14. Marta waits in hallway; the doorframe seam stands as mutual acknowledged truth.",
    props: "Drzwi Mieszkania 14, czajnik na gazie, widoczny szew",
    propsEn: "Flat 14 entrance, whistling kettle, visible frame seam",
    color: "amber"
  },
  {
    id: "station_42c",
    act: "akt4",
    actTitle: "Akt IV — Sygnał powrotu",
    actTitleEn: "Act IV — Return Signal",
    number: "42C",
    title: "Finał C: Świadectwo / Dwie prawdy naraz",
    titleEn: "Ending C: Testimony / Two Truths at Once",
    image: "assets/reports/station_42c.png",
    activeImage: "assets/reports/station_42c.png",
    brief: "Poranny tramwaj staje przed dwoma torami naraz. Motornicza zapisuje wybór i rusza naprzód.",
    briefEn: "Morning tram stops before dual branching tracks. The driver records the choice and presses onward.",
    props: "Pulpit motorniczego, dwa rozbieżne tory, dziennik pokładowy",
    propsEn: "Tram control cab, dual diverging tracks, driver logbook",
    color: "crimson"
  },
  {
    id: "station_43",
    act: "akt4",
    actTitle: "Akt IV — Sygnał powrotu",
    actTitleEn: "Act IV — Return Signal",
    number: "43",
    title: "Epilog / Napisy systemowe UCP",
    titleEn: "Epilogue / UCP System Credits",
    image: "assets/reports/station_43.png",
    activeImage: "assets/reports/station_43.png",
    brief: "Napisy końcowe na fasadach budynków, komunikaty radiowe o Linii 4 i ostateczne wygaszenie.",
    briefEn: "End credits projected on building facades, Line 4 radio dispatches, and final resonance fade.",
    props: "Tablica administracyjna UCP, napisy na fasadzie, portal wygaszenia",
    propsEn: "UCP administrative board, facade projection, fade portal",
    color: "amber"
  }
];

class GettingStrangeGallery {
  constructor(containerId) {
    this.container = document.getElementById(containerId);
    this.activeFilter = "all";
    this.searchQuery = "";
    this.currentModalIndex = 0;
    this.init();
  }

  init() {
    this.render();
    this.bindEvents();
    if (window.i18n) {
      window.i18n.addListener(() => this.render());
    }
  }

  bindEvents() {
    const filterBtns = document.querySelectorAll(".filter-btn");
    filterBtns.forEach(btn => {
      btn.addEventListener("click", () => {
        filterBtns.forEach(b => b.classList.remove("active"));
        btn.classList.add("active");
        this.activeFilter = btn.dataset.filter;
        this.render();
        if (window.proceduralAudio) window.proceduralAudio.playSwitchSound();
      });
    });

    const searchInput = document.getElementById("gallerySearchInput");
    if (searchInput) {
      searchInput.addEventListener("input", (e) => {
        this.searchQuery = e.target.value.toLowerCase().trim();
        this.render();
      });
    }
  }

  setSearchQuery(q) {
    this.searchQuery = (q || "").toLowerCase().trim();
    const searchInput = document.getElementById("gallerySearchInput");
    if (searchInput) searchInput.value = q || "";
    this.render();
  }

  render() {
    if (!this.container) return;

    const lang = window.i18n ? window.i18n.currentLang : "pl";
    const filtered = STATIONS_DATA.filter(item => {
      // Act Filter
      const matchesAct = (this.activeFilter === "all" || item.act === this.activeFilter);
      if (!matchesAct) return false;

      // Search Query
      if (!this.searchQuery) return true;
      const title = (item.title || "").toLowerCase();
      const titleEn = (item.titleEn || "").toLowerCase();
      const brief = (item.brief || "").toLowerCase();
      const briefEn = (item.briefEn || "").toLowerCase();
      const props = (item.props || "").toLowerCase();
      const propsEn = (item.propsEn || "").toLowerCase();
      const number = (item.number || "").toLowerCase();

      return title.includes(this.searchQuery) ||
             titleEn.includes(this.searchQuery) ||
             brief.includes(this.searchQuery) ||
             briefEn.includes(this.searchQuery) ||
             props.includes(this.searchQuery) ||
             propsEn.includes(this.searchQuery) ||
             number.includes(this.searchQuery);
    });

    // Update Counter Element if present
    const countEl = document.getElementById("gallerySearchCount");
    if (countEl) {
      const template = lang === "en" 
        ? "Displaying: {count} / 43 spaces"
        : "Wyświetlono: {count} / 43 przestrzeni";
      countEl.innerText = template.replace("{count}", filtered.length);
    }

    if (filtered.length === 0) {
      const noResultsMsg = lang === "en"
        ? "No narrative spaces match your search criteria."
        : "Brak przestrzeni odpowiadających podanemu filtrowi.";
      this.container.innerHTML = `
        <div style="grid-column: 1 / -1; padding: 48px; text-align: center; background: var(--bg-panel); border: 1px solid var(--border-subtle);">
          <p class="mono" style="color: var(--accent-amber-bright); font-size: 13px;">${noResultsMsg}</p>
        </div>
      `;
      return;
    }

    this.container.innerHTML = filtered.map((item) => {
      const title = lang === "en" ? (item.titleEn || item.title) : item.title;
      const brief = lang === "en" ? (item.briefEn || item.brief) : item.brief;
      const props = lang === "en" ? (item.propsEn || item.props) : item.props;
      const propsLabel = lang === "en" ? "PROPS:" : "REKWIZYTY:";

      return `
        <div class="gallery-card" data-id="${item.id}" onclick="gallery.openModal('${item.id}')">
          <div class="gallery-thumb-wrap">
            <img src="${item.activeImage || item.image}" alt="${title}" loading="lazy" />
            <div class="gallery-badge mono">${item.number} / ${item.act.toUpperCase()}</div>
          </div>
          <div class="gallery-info">
            <div class="gallery-title">${title}</div>
            <div class="gallery-desc">${brief}</div>
            <div class="gallery-meta mono">
              <span>${propsLabel} ${props}</span>
            </div>
          </div>
        </div>
      `;
    }).join("");
  }

  openModal(stationId) {
    const item = STATIONS_DATA.find(s => s.id === stationId);
    if (!item) return;

    const lang = window.i18n ? window.i18n.currentLang : "pl";
    const title = lang === "en" ? (item.titleEn || item.title) : item.title;
    const actTitle = lang === "en" ? (item.actTitleEn || item.actTitle) : item.actTitle;
    const brief = lang === "en" ? (item.briefEn || item.brief) : item.brief;
    const props = lang === "en" ? (item.propsEn || item.props) : item.props;
    const propsPrefix = lang === "en" ? "Continuity props:" : "Rekwizyty ciągłości:";

    const modal = document.getElementById("galleryModal");
    const modalImg = document.getElementById("modalImg");
    const modalTitle = document.getElementById("modalTitle");
    const modalDesc = document.getElementById("modalDesc");
    const modalProps = document.getElementById("modalProps");

    if (modal && modalImg && modalTitle) {
      modalImg.src = item.activeImage || item.image;
      modalTitle.innerText = `[${item.number}] ${title} — ${actTitle}`;
      if (modalDesc) modalDesc.innerText = brief;
      if (modalProps) modalProps.innerText = `${propsPrefix} ${props}`;
      modal.classList.add("active");

      if (window.proceduralAudio) window.proceduralAudio.playSwitchSound();
    }
  }

  closeModal() {
    const modal = document.getElementById("galleryModal");
    if (modal) {
      modal.classList.remove("active");
      if (window.proceduralAudio) window.proceduralAudio.playSwitchSound();
    }
  }
}

window.GettingStrangeGallery = GettingStrangeGallery;
window.STATIONS_DATA = STATIONS_DATA;
