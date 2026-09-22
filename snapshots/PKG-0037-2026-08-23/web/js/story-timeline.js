/**
 * GETTING STRANGE — Story Timeline & Interactive Dialogue Engine (Bilingual PL/EN)
 * Complete canon of 5 Acts, 43 Spaces, and 20 Dialogue Scenes from NARRATIVE_BIBLE & DIALOGUE_SCRIPT.
 */

const DIALOGUES_DATA = {
  "D-01": {
    id: "D-01",
    title: "D-01: Bramka IKP (Scena 04)",
    titleEn: "D-01: IKP Reception Gate (Scene 04)",
    location: "Przestrzeń 04 — Recepcja / Bramka IKP",
    locationEn: "Space 04 — Reception / IKP Gate",
    characters: "Lena, Strażnik",
    charactersEn: "Lena, Guard",
    lines: [
      { speaker: "STRAŻNIK", speakerEn: "GUARD", text: "Pani Wolska. Dobrze. Proszę chwilę nie wychodzić.", textEn: "Ms. Wolska. Good. Please do not leave just yet." },
      { speaker: "LENA", speakerEn: "LENA", text: "Dlaczego?", textEn: "Why?" },
      { speaker: "STRAŻNIK", speakerEn: "GUARD", text: "Mam zgłosić powrót.", textEn: "I have to report a return." },
      { speaker: "LENA", speakerEn: "LENA", text: "Komu?", textEn: "To whom?" },
      { speaker: "STRAŻNIK", speakerEn: "GUARD", text: "UCP. I pani bratu, jeśli nie odbiorą. Nie będę go drugi raz wzywał do zamkniętego tunelu.", textEn: "UCP. And your brother, if they don't answer. I won't call him to a closed tunnel a second time." },
      { speaker: "LENA", speakerEn: "LENA", text: "Jakub nie żyje.", textEn: "Jakub is dead." },
      { speaker: "STRAŻNIK", speakerEn: "GUARD", text: "(Lampa nad kamerą gaśnie. Strażnik przesuwa się, zasłaniając obiektyw) Proszę tego przy niej nie powtarzać.", textEn: "(The lamp above camera dies. Guard shifts, obscuring the lens) Please don't repeat that in front of it." },
      { speaker: "LENA", speakerEn: "LENA", text: "Przy kamerze?", textEn: "In front of the camera?" },
      { speaker: "STRAŻNIK", speakerEn: "GUARD", text: "Przy wersji, która zapisuje.", textEn: "In front of the version that records." }
    ]
  },
  "D-02": {
    id: "D-02",
    title: "D-02: Klatka schodowa (Scena 07)",
    titleEn: "D-02: Stairwell (Scene 07)",
    location: "Przestrzeń 07 — Klatka schodowa, Osiedle Tarasowe",
    locationEn: "Space 07 — Stairwell, Tarasowe Estate",
    characters: "Lena, Marta Kurek",
    charactersEn: "Lena, Marta Kurek",
    lines: [
      { speaker: "MARTA", speakerEn: "MARTA", text: "Wróciłaś.", textEn: "You came back." },
      { speaker: "LENA", speakerEn: "LENA", text: "Pomyliła mnie pani z kimś.", textEn: "You have mistaken me for someone else." },
      { speaker: "MARTA", speakerEn: "MARTA", text: "Lena Wolska.", textEn: "Lena Wolska." },
      { speaker: "LENA", speakerEn: "LENA", text: "To nie wystarczy.", textEn: "That is not enough." },
      { speaker: "MARTA", speakerEn: "MARTA", text: "Mieszkała tu. Siedemnaście dni temu wyszła. Nie wzięła butów na deszcz.", textEn: "She lived here. Seventeen days ago she left. Didn't take her rain boots." },
      { speaker: "LENA", speakerEn: "LENA", text: "Nigdy tu nie byłam.", textEn: "I have never been here." },
      { speaker: "LENA", speakerEn: "LENA", text: "(Dociska paznokieć do szwu palca. Marta patrzy na dłoń)", textEn: "(Presses nail against finger seam. Marta looks at her hand)" },
      { speaker: "MARTA", speakerEn: "MARTA", text: "Nie.", textEn: "No." },
      { speaker: "LENA", speakerEn: "LENA", text: "Więc się zgadzamy.", textEn: "So we agree." },
      { speaker: "MARTA", speakerEn: "MARTA", text: "Twarz się zgadza. Reszta dopiero weszła po schodach. W środku przynajmniej wiem, gdzie były ściany.", textEn: "The face matches. The rest just walked up the stairs. Inside at least I know where the walls used to be." }
    ]
  },
  "D-03": {
    id: "D-03",
    title: "D-03: Łazienka / Lustro (Scena 09)",
    titleEn: "D-03: Bathroom / Mirror (Scene 09)",
    location: "Przestrzeń 09 — Łazienka w Mieszkaniu 14",
    locationEn: "Space 09 — Bathroom in Flat 14",
    characters: "Lena, Marta Kurek",
    charactersEn: "Lena, Marta Kurek",
    lines: [
      { speaker: "MARTA", speakerEn: "MARTA", text: "Nie patrz na drzwi. Patrz na nie w lustrze.", textEn: "Don't look at the door. Look at it in the mirror." },
      { speaker: "LENA", speakerEn: "LENA", text: "Odbicie jest opóźnione.", textEn: "The reflection is delayed." },
      { speaker: "MARTA", speakerEn: "MARTA", text: "Wiem.", textEn: "I know." },
      { speaker: "LENA", speakerEn: "LENA", text: "Ile?", textEn: "By how much?" },
      { speaker: "MARTA", speakerEn: "MARTA", text: "Tyle, żebyś zdążyła się przestraszyć. Za mało, żebyś zdążyła to zmierzyć.", textEn: "Enough for you to get frightened. Not enough for you to measure it." },
      { speaker: "LENA", speakerEn: "LENA", text: "Zmierzę po przejściu.", textEn: "I will measure it once I cross." },
      { speaker: "MARTA", speakerEn: "MARTA", text: "Ona też tak powiedziała.", textEn: "She said that too." }
    ]
  },
  "D-04": {
    id: "D-04",
    title: "D-04: Telefon Jakuba (Scena 10)",
    titleEn: "D-04: Jakub's Telephone (Scene 10)",
    location: "Przestrzeń 10 — Pokój do pracy, telefon",
    locationEn: "Space 10 — Study Room, Telephone",
    characters: "Lena, Jakub Wolski",
    charactersEn: "Lena, Jakub Wolski",
    lines: [
      { speaker: "JAKUB", speakerEn: "JAKUB", text: "Lena. Nie odkładaj.", textEn: "Lena. Don't hang up." },
      { speaker: "LENA", speakerEn: "LENA", text: "Gdzie jesteś?", textEn: "Where are you?" },
      { speaker: "JAKUB", speakerEn: "JAKUB", text: "W maszynowni Linii 4. Od dwudziestej drugiej nie wpuszczają nikogo bez opaski.", textEn: "In the Line 4 engine room. Since 22:00 they don't let anyone in without a badge." },
      { speaker: "LENA", speakerEn: "LENA", text: "Kto?", textEn: "Who?" },
      { speaker: "JAKUB", speakerEn: "JAKUB", text: "Urząd. Mówią, że to konserwacja torowiska. Jeśli odłożysz, ten pokój znowu będzie pusty.", textEn: "The Office. They say it's track maintenance. If you hang up, this room will be empty again." },
      { speaker: "LENA", speakerEn: "LENA", text: "Pamiętam twój pogrzeb.", textEn: "I remember your funeral." },
      { speaker: "JAKUB", speakerEn: "JAKUB", text: "Ja też pamiętam twój.", textEn: "I remember yours too." }
    ]
  },
  "D-05": {
    id: "D-05",
    title: "D-05: Rozmowa przy stole (Scena 16)",
    titleEn: "D-05: Table Conversation (Scene 16)",
    location: "Przestrzeń 16 — Kuchnia w Mieszkaniu 14",
    locationEn: "Space 16 — Flat 14 Kitchen",
    characters: "Lena, Marta Kurek",
    charactersEn: "Lena, Marta Kurek",
    lines: [
      { speaker: "MARTA", speakerEn: "MARTA", text: "Herbata stygnie inaczej na każdym piętrze.", textEn: "Tea cools down differently on each floor." },
      { speaker: "LENA", speakerEn: "LENA", text: "Bo zmienili izolację pionów.", textEn: "Because they changed the vertical insulation." },
      { speaker: "MARTA", speakerEn: "MARTA", text: "Zawsze musisz mieć wzór. Ona też liczyła, zanim wstała od stołu.", textEn: "You always need a formula. She used to calculate too before leaving the table." },
      { speaker: "LENA", speakerEn: "LENA", text: "Wzór pozwala wrócić.", textEn: "A formula allows one to return." },
      { speaker: "MARTA", speakerEn: "MARTA", text: "Wzór pozwala nie patrzeć na to, co zostało.", textEn: "A formula allows one to avoid looking at what remains." }
    ]
  },
  "D-06": {
    id: "D-06",
    title: "D-06: Wywiad zgodności (Scena 18)",
    titleEn: "D-06: Consistency Interview (Scene 18)",
    location: "Przestrzeń 18 — Gabinet dr Wierzbickiej",
    locationEn: "Space 18 — Dr Wierzbicka's Office",
    characters: "Lena, dr Helena Wierzbicka",
    charactersEn: "Lena, Dr Helena Wierzbicka",
    lines: [
      { speaker: "WIERZBICKA", speakerEn: "WIERZBICKA", text: "Pani Leno. Rozumiemy pani opór. Nikt nie lubi, gdy jego wersja staje się kosztem ogólnym.", textEn: "Ms. Lena. We understand your resistance. Nobody likes when their version becomes the general cost." },
      { speaker: "LENA", speakerEn: "LENA", text: "Wymazujecie żywych ludzi.", textEn: "You are erasing living people." },
      { speaker: "WIERZBICKA", speakerEn: "WIERZBICKA", text: "Stabilizujemy miasto. Bez wygładzenia szwów Rówień rozpadłaby się w 1978 roku na siedemnaście martwych wariantów.", textEn: "We stabilize the city. Without smoothing the seams, Rówień would have fractured into 17 dead variants in 1978." },
      { speaker: "LENA", speakerEn: "LENA", text: "Kto decyduje, który wariant jest 'prawdziwy'?", textEn: "Who decides which variant is 'true'?" },
      { speaker: "WIERZBICKA", speakerEn: "WIERZBICKA", text: "Ten, który powoduje najmniej pęknięć w strukturze nośnej.", textEn: "The one that causes the fewest fractures in the load-bearing structure." }
    ]
  },
  "D-07": {
    id: "D-07",
    title: "D-07: Sala Szymona (Scena 20)",
    titleEn: "D-07: Szymon's Room (Scene 20)",
    location: "Przestrzeń 20 — Sala Szymona Bery",
    locationEn: "Space 20 — Szymon Bera's Ward",
    characters: "Lena, Szymon Bera",
    charactersEn: "Lena, Szymon Bera",
    lines: [
      { speaker: "SZYMON", speakerEn: "SZYMON", text: "Rysuję most. Który most chcesz zobaczyć? Ten z trzema przęsłami, czy ten, który runął w maju?", textEn: "I'm drawing the bridge. Which bridge do you want to see? The three-span one, or the one that collapsed in May?" },
      { speaker: "LENA", speakerEn: "LENA", text: "Most stoi. Przejeżdżałam nim dzisiaj.", textEn: "The bridge is standing. I crossed it today." },
      { speaker: "SZYMON", speakerEn: "SZYMON", text: "Stoi, bo narysowali go na nowo. Ale pod spodem wciąż słychać wodę uderzającą o żelazo.", textEn: "It stands because they redrew it. But underneath you can still hear the water hitting iron." }
    ]
  },
  "D-08": {
    id: "D-08",
    title: "D-08: Bramka tożsamości (Scena 22)",
    titleEn: "D-08: Identity Gate (Scene 22)",
    location: "Przestrzeń 22 — Bramka tranzytowa UCP",
    locationEn: "Space 22 — UCP Transit Gate",
    characters: "Lena, dr Wierzbicka (Interkom)",
    charactersEn: "Lena, Dr Wierzbicka (Intercom)",
    lines: [
      { speaker: "WIERZBICKA", speakerEn: "WIERZBICKA", text: "Wystarczy położyć dłoń na pulpicie. Uległość nie boli. To tylko zrzeczenie się sprzecznych roszczeń.", textEn: "Just place your hand on the scanner. Yielding does not hurt. It is merely renouncing conflicting claims." },
      { speaker: "LENA", speakerEn: "LENA", text: "Jeśli ustąpię, zapomnę o bracie?", textEn: "If I yield, will I forget my brother?" },
      { speaker: "WIERZBICKA", speakerEn: "WIERZBICKA", text: "Zapomni pani o jego nieobecności. Zostanie tylko spokój.", textEn: "You will forget his absence. Only peace will remain." }
    ]
  },
  "D-09": {
    id: "D-09",
    title: "D-09: Tranzyt Linii 4 (Scena 25)",
    titleEn: "D-09: Line 4 Transit (Scene 25)",
    location: "Przestrzeń 25 — Torowisko Linii 4",
    locationEn: "Space 25 — Line 4 Tracks",
    characters: "Lena, Jakub Wolski",
    charactersEn: "Lena, Jakub Wolski",
    lines: [
      { speaker: "JAKUB", speakerEn: "JAKUB", text: "Rozcinasz palec o krawędź blachy, czy obracasz obrączkę?", textEn: "Are you cutting your finger on metal edge, or turning the ring?" },
      { speaker: "LENA", speakerEn: "LENA", text: "Obrączkę znalazłam w płaszczu.", textEn: "I found the ring in my coat." },
      { speaker: "JAKUB", speakerEn: "JAKUB", text: "A blizna pod żebrem? Pamiętasz, skąd ją masz?", textEn: "And the ribcage scar? Do you remember where you got it?" },
      { speaker: "LENA", speakerEn: "LENA", text: "Z wypadku w 1978.", textEn: "From the accident in 1978." },
      { speaker: "JAKUB", speakerEn: "JAKUB", text: "Nie jestem twoim wspomnieniem. Jeśli chcesz wyjść, pomogę osobie. Nie żałobie.", textEn: "I am not your memory. If you want to leave, I'll help the person. Not the mourning." }
    ]
  },
  "D-10": {
    id: "D-10",
    title: "D-10: Szyb windowy (Scena 28)",
    titleEn: "D-10: Lift Shaft (Scene 28)",
    location: "Przestrzeń 28 — Szyb towarowy -20 m",
    locationEn: "Space 28 — Freight Shaft -20 m",
    characters: "Lena, Jakub Wolski",
    charactersEn: "Lena, Jakub Wolski",
    lines: [
      { speaker: "JAKUB", speakerEn: "JAKUB", text: "Liny trzymają. Winda jedzie niżej niż fundamenty urzędu.", textEn: "The cables hold. The hoist goes lower than the agency's foundations." },
      { speaker: "LENA", speakerEn: "LENA", text: "Co jest na samym dole?", textEn: "What is at the very bottom?" },
      { speaker: "JAKUB", speakerEn: "JAKUB", text: "Rdzeń. Miejsce, gdzie nie ma jeszcze podziału na to, co się stało, a co mogło się stać.", textEn: "The Core. The place where what happened and what could have happened are not yet split." }
    ]
  },
  "D-11": {
    id: "D-11",
    title: "D-11: Podwójna zwrotnica (Scena 31)",
    titleEn: "D-11: Dual Switch (Scene 31)",
    location: "Przestrzeń 31 — Tory podziemne",
    locationEn: "Space 31 — Subterranean Rails",
    characters: "Lena, Ślad",
    charactersEn: "Lena, Trace",
    lines: [
      { speaker: "ŚLAD", speakerEn: "TRACE", text: "DWA TORY. DWA ROZKŁADY. OBA PRAWDZIWE.", textEn: "TWO TRACKS. TWO TIMETABLES. BOTH TRUE." },
      { speaker: "LENA", speakerEn: "LENA", text: "Nie można jechać po obu naraz.", textEn: "You cannot ride both at once." },
      { speaker: "ŚLAD", speakerEn: "TRACE", text: "MOŻNA ZAPISAĆ, ŻE ISTNIEJĄ OBA.", textEn: "YOU CAN RECORD THAT BOTH EXIST." }
    ]
  },
  "D-12": {
    id: "D-12",
    title: "D-12: Maszynownia Główna (Scena 34)",
    titleEn: "D-12: Main Engine Room (Scene 34)",
    location: "Przestrzeń 34 — Maszynownia Główna",
    locationEn: "Space 34 — Main Engine Room",
    characters: "Lena, Jakub Wolski",
    charactersEn: "Lena, Jakub Wolski",
    lines: [
      { speaker: "LENA", speakerEn: "LENA", text: "Aparatura ze znakiem UCP ma datę o dziewięć lat wcześniejszą od urzędu.", textEn: "Equipment stamped UCP is dated nine years earlier than the agency itself." },
      { speaker: "JAKUB", speakerEn: "JAKUB", text: "Bo urząd powstał po to, żeby ukryć, że sami wywołaliśmy korektę.", textEn: "Because the agency was created to conceal that we triggered the correction ourselves." }
    ]
  },
  "D-13": {
    id: "D-13",
    title: "D-13: Przedpole Rdzenia (Scena 37)",
    titleEn: "D-13: Core Forecourt (Scene 37)",
    location: "Przestrzeń 37 — Ołowiana Brama",
    locationEn: "Space 37 — Lead Portal",
    characters: "Lena, dr Wierzbicka",
    charactersEn: "Lena, Dr Wierzbicka",
    lines: [
      { speaker: "WIERZBICKA", speakerEn: "WIERZBICKA", text: "Jeśli otworzy pani tę bramę, rozproszy pani nośną. Żadne z nas nie będzie miało pewności, skąd przyszło.", textEn: "If you open this gate, you disperse the carrier. None of us will know where we originated." },
      { speaker: "LENA", speakerEn: "LENA", text: "Pewność była kłamstwem.", textEn: "Certainty was a lie." }
    ]
  },
  "D-14": {
    id: "D-14",
    title: "D-14: Monolit Rdzenia (Scena 39)",
    titleEn: "D-14: Core Monolith (Scene 39)",
    location: "Przestrzeń 39 — Komora Monolitu",
    locationEn: "Space 39 — Monolith Chamber",
    characters: "Lena, Ślad, Marta Kurek",
    charactersEn: "Lena, Trace, Marta Kurek",
    lines: [
      { speaker: "ŚLAD", speakerEn: "TRACE", text: "KTO WYBIERA?", textEn: "WHO CHOOSES?" },
      { speaker: "LENA", speakerEn: "LENA", text: "Człowiek, który stoi przed szwem.", textEn: "The person standing before the seam." },
      { speaker: "MARTA", speakerEn: "MARTA", text: "Cokolwiek zrobisz — nie przepraszaj za to, co pamiętasz.", textEn: "Whatever you do — do not apologize for what you remember." }
    ]
  },
  "D-15A": {
    id: "D-15A",
    title: "D-15A: Finał A — Powrót (Scena 42A)",
    titleEn: "D-15A: Ending A — Return (Scene 42A)",
    location: "Przestrzeń 42A — Sterownia IKP o 21:45",
    locationEn: "Space 42A — IKP Control Room at 21:45",
    characters: "Lena, Marta Kurek (Telefon)",
    charactersEn: "Lena, Marta Kurek (Phone)",
    lines: [
      { speaker: "LENA", speakerEn: "LENA", text: "(Podnosi słuchawkę dzwoniącego telefonu) Słucham.", textEn: "(Picks up ringing receiver) Hello." },
      { speaker: "MARTA", speakerEn: "MARTA", text: "Lena? Dobrze, że jesteś. Deszcz ustał. Idziemy na tramwaj?", textEn: "Lena? Glad you're there. Rain stopped. Shall we head for the tram?" },
      { speaker: "LENA", speakerEn: "LENA", text: "Tak. Już gaszę aparaturę.", textEn: "Yes. I'm powering down the equipment now." }
    ]
  },
  "D-15B": {
    id: "D-15B",
    title: "D-15B: Finał B — Uzgodnienie (Scena 42B)",
    titleEn: "D-15B: Ending B — Reconciliation (Scene 42B)",
    location: "Przestrzeń 42B — Progi Mieszkania 14",
    locationEn: "Space 42B — Threshold of Flat 14",
    characters: "Lena, Marta Kurek",
    charactersEn: "Lena, Marta Kurek",
    lines: [
      { speaker: "MARTA", speakerEn: "MARTA", text: "Herbata na stole. Szew w futrynie został.", textEn: "Tea is on the table. The doorframe seam stayed." },
      { speaker: "LENA", speakerEn: "LENA", text: "Nie będziemy go zamalowywać.", textEn: "We won't paint over it." },
      { speaker: "MARTA", speakerEn: "MARTA", text: "Wiem. Zostawimy tak, jak jest.", textEn: "I know. We'll leave it as it is." }
    ]
  },
  "D-15C": {
    id: "D-15C",
    title: "D-15C: Finał C — Świadectwo (Scena 42C)",
    titleEn: "D-15C: Ending C — Testimony (Scene 42C)",
    location: "Przestrzeń 42C — Tramwaj Linii 4 o świcie",
    locationEn: "Space 42C — Line 4 Tram at Dawn",
    characters: "Motornicza, Lena",
    charactersEn: "Tram Driver, Lena",
    lines: [
      { speaker: "MOTOR倉", speakerEn: "DRIVER", text: "Przed nami dwa tory. Zwrotnica nie jest zablokowana.", textEn: "Two tracks ahead of us. Switch is not locked." },
      { speaker: "LENA", speakerEn: "LENA", text: "Który wybierasz?", textEn: "Which one do you take?" },
      { speaker: "MOTOR倉", speakerEn: "DRIVER", text: "Zapisuję oba w dzienniku pokładowym. I jadę prosto.", textEn: "I record both in the logbook. And drive straight ahead." }
    ]
  },
  "D-16": {
    id: "D-16",
    title: "D-16: Pokój projektantki (Scena 23)",
    titleEn: "D-16: Designer's Room (Scene 23)",
    location: "Przestrzeń 23 — Terminal CAD-78",
    locationEn: "Space 23 — CAD-78 Terminal",
    characters: "Lena, Notatka projektantki",
    charactersEn: "Lena, Designer's Note",
    lines: [
      { speaker: "LENA", speakerEn: "LENA", text: "(Czyta tekst na zielonym kineskopie) 'Podstruktura nie jest błędem. Jest buforem prawdy.'", textEn: "(Reads text on green phosphor CRT) 'The Substructure is not an error. It is a buffer of truth.'" },
      { speaker: "NOTATKA", speakerEn: "NOTE", text: "'Zostawiliśmy szew na Linii 4. Ktoś kiedyś zapyta, dlaczego tramwaj nie dojechał.'", textEn: "'We left a seam on Line 4. Someday someone will ask why the tram never arrived.'" }
    ]
  },
  "D-17": {
    id: "D-17",
    title: "D-17: Pamięć kostnicy (Scena 34)",
    titleEn: "D-17: Morgue Memory (Scene 34)",
    location: "Przestrzeń 34 — Maszynownia Główna / Rekonstrukcja",
    locationEn: "Space 34 — Main Engine Room / Reconstruction",
    characters: "Lena, Jakub Wolski",
    charactersEn: "Lena, Jakub Wolski",
    lines: [
      { speaker: "LENA", speakerEn: "LENA", text: "Trzeci listopada. Dwudziesta druga czterdzieści. Kawa. Linoleum. Mokra wełna.", textEn: "November third. Twenty-two forty. Coffee. Linoleum. Wet wool." },
      { speaker: "LENA", speakerEn: "LENA", text: "Aparatura ze znakiem UCP ma datę o dziewięć lat wcześniejszą od urzędu.", textEn: "Apparatus marked UCP has a timestamp nine years older than the agency itself." },
      { speaker: "JAKUB", speakerEn: "JAKUB", text: "Od czego?", textEn: "Older than what?" },
      { speaker: "LENA", speakerEn: "LENA", text: "Od urzędu. Tu nie ma nikogo.", textEn: "Than the agency. There is no one here." },
      { speaker: "JAKUB", speakerEn: "JAKUB", text: "Bo nie pamiętasz.", textEn: "Because you don't remember." },
      { speaker: "LENA", speakerEn: "LENA", text: "Nie pamiętam od trzynastu lat. Zapisałam to jako szok. Nagranie jako wadę taśmy. Zdjęcie jako zły kadr. Nie przyszłam stamtąd, gdzie nikt nie sprzątał.", textEn: "I haven't remembered for 13 years. I chalked it up to shock. The tape to defect. The photo to bad framing. I didn't come from where no one cleaned up." }
    ]
  },
  "D-18": {
    id: "D-18",
    title: "D-18: Komora Referencyjna (Scena 39)",
    titleEn: "D-18: Reference Chamber (Scene 39)",
    location: "Przestrzeń 39 — Monolit Rdzenia Kwantowego",
    locationEn: "Space 39 — Quantum Core Monolith",
    characters: "Lena, Ślad, Marta Kurek",
    charactersEn: "Lena, Trace, Marta Kurek",
    lines: [
      { speaker: "LENA", speakerEn: "LENA", text: "Możesz to zamknąć sama.", textEn: "You can close this yourself." },
      { speaker: "ŚLAD", speakerEn: "TRACE", text: "MOGĘ.", textEn: "I CAN." },
      { speaker: "LENA", speakerEn: "LENA", text: "Więc zamknij.", textEn: "Then close it." },
      { speaker: "ŚLAD", speakerEn: "TRACE", text: "POLICZYŁAM: OSOBA. NIE POLICZYŁAM: KTÓRA. JEŚLI WYBIORĘ JA — ZNOWU JESTEŚ KOSZTEM.", textEn: "I COUNTED: A PERSON. I DID NOT COUNT: WHICH ONE. IF I CHOOSE — YOU ARE ONCE AGAIN THE COST." },
      { speaker: "MARTA", speakerEn: "MARTA", text: "Nie patrzę, żeby ci pomóc. Patrzę, żeby zobaczyć, co zrobisz.", textEn: "I am not watching to help you. I am watching to see what you will do." },
      { speaker: "ŚLAD", speakerEn: "TRACE", text: "WYSTARCZY.", textEn: "ENOUGH." },
      { speaker: "LENA", speakerEn: "LENA", text: "Zostaniesz?", textEn: "Will you stay?" },
      { speaker: "ŚLAD", speakerEn: "TRACE", text: "ZOBACZYMY — PO PRZEJEŹDZIE.", textEn: "WE SHALL SEE — AFTER THE TRANSIT." }
    ]
  }
};

class GettingStrangeStoryTimeline {
  constructor(displayId) {
    this.displayId = displayId;
    this.currentDialogueKey = "D-01";
    this.currentLineIndex = 0;
    this.isAutoPlaying = false;
    this.autoPlayTimer = null;
    this.playbackSpeed = 1.0;
    this.init();
  }

  init() {
    this.renderTabs();
    this.renderDialogue();
    this.renderAutoplayControls();
    if (window.i18n) {
      window.i18n.addListener(() => {
        this.renderTabs();
        this.renderDialogue();
        this.renderAutoplayControls();
      });
    }
  }

  renderTabs() {
    const tabsContainer = document.getElementById("dialogueTabs");
    if (!tabsContainer) return;

    tabsContainer.innerHTML = Object.keys(DIALOGUES_DATA).map(key => {
      const d = DIALOGUES_DATA[key];
      return `
        <button class="dialogue-tab ${key === this.currentDialogueKey ? 'active' : ''}" onclick="storyTimeline.selectDialogue('${key}')">
          ${d.id}
        </button>
      `;
    }).join("");
  }

  selectDialogue(key) {
    this.stopAutoPlay();
    this.currentDialogueKey = key;
    this.currentLineIndex = 0;
    this.renderTabs();
    this.renderDialogue();
    this.renderAutoplayControls();
    if (window.proceduralAudio) window.proceduralAudio.playSwitchSound();
  }

  playSpeakerVoice(speaker) {
    if (!window.proceduralAudio) return;
    const s = speaker.toUpperCase();
    if (s.includes("LENA")) window.proceduralAudio.playDialogueLenaSound();
    else if (s.includes("JAKUB")) window.proceduralAudio.playDialogueJakubSound();
    else if (s.includes("WIERZBICKA")) window.proceduralAudio.playDialogueWierzbickaSound();
    else if (s.includes("MARTA")) window.proceduralAudio.playDialogueMartaSound();
    else if (s.includes("SZYMON")) window.proceduralAudio.playDialogueSzymonSound();
    else if (s.includes("ŚLAD") || s.includes("TRACE")) window.proceduralAudio.playDimensionalClashSound();
    else window.proceduralAudio.playSwitchSound();
  }

  renderDialogue() {
    const displayBox = document.getElementById("dialogueDisplay");
    if (!displayBox) return;

    const data = DIALOGUES_DATA[this.currentDialogueKey];
    if (!data) return;

    const lang = window.i18n ? window.i18n.currentLang : "pl";
    const line = data.lines[this.currentLineIndex];
    if (!line) return;

    const speaker = lang === "en" ? (line.speakerEn || line.speaker) : line.speaker;
    const text = lang === "en" ? (line.textEn || line.text) : line.text;
    const location = lang === "en" ? (data.locationEn || data.location) : data.location;
    const lineCounter = lang === "en"
      ? `Line ${this.currentLineIndex + 1} of ${data.lines.length}`
      : `Wers ${this.currentLineIndex + 1} z ${data.lines.length}`;

    let speakerClass = line.speaker.toLowerCase();
    if (speakerClass.includes("marta")) speakerClass = "marta";
    else if (speakerClass.includes("jakub")) speakerClass = "jakub";
    else if (speakerClass.includes("wierzbicka")) speakerClass = "wierzbicka";
    else if (speakerClass.includes("szymon")) speakerClass = "szymon";
    else if (speakerClass.includes("ślad") || speakerClass.includes("slad") || speakerClass.includes("trace")) speakerClass = "slad";

    displayBox.innerHTML = `
      <div style="font-size: 11px; color: var(--text-dim); margin-bottom: 8px;">
        <span class="label-tag" style="margin-right: 8px;">${data.id}</span>
        ${location} | [${lineCounter}]
      </div>
      <div class="dialogue-speaker ${speakerClass}">${speaker}</div>
      <div class="dialogue-text">${text}</div>
    `;

    this.playSpeakerVoice(line.speaker);
  }

  renderAutoplayControls() {
    let autoplayBar = document.getElementById("dialogueAutoplayBar");
    if (!autoplayBar) {
      const dialogueViewer = document.querySelector(".dialogue-viewer");
      if (!dialogueViewer) return;
      autoplayBar = document.createElement("div");
      autoplayBar.id = "dialogueAutoplayBar";
      autoplayBar.className = "dialogue-autoplay-bar mono";
      dialogueViewer.appendChild(autoplayBar);
    }

    const lang = window.i18n ? window.i18n.currentLang : "pl";
    const playText = this.isAutoPlaying 
      ? (lang === "en" ? "❚❚ Pause" : "❚❚ Wstrzymaj")
      : (lang === "en" ? "▶ Auto-Play" : "▶ Autoodtwarzanie");
    const speedLabel = lang === "en" ? "SPEED:" : "PRĘDKOŚĆ:";

    autoplayBar.innerHTML = `
      <div class="dialogue-playback-actions">
        <button class="tool-btn ${this.isAutoPlaying ? 'active' : ''}" onclick="storyTimeline.toggleAutoPlay()">${playText}</button>
      </div>
      <div class="dialogue-speed-group">
        <span class="volume-label" style="font-size: 10px; color: var(--text-muted);">${speedLabel}</span>
        <button class="speed-btn ${this.playbackSpeed === 0.75 ? 'active' : ''}" onclick="storyTimeline.setSpeed(0.75)">0.75x</button>
        <button class="speed-btn ${this.playbackSpeed === 1.0 ? 'active' : ''}" onclick="storyTimeline.setSpeed(1.0)">1.0x</button>
        <button class="speed-btn ${this.playbackSpeed === 1.5 ? 'active' : ''}" onclick="storyTimeline.setSpeed(1.5)">1.5x</button>
      </div>
    `;
  }

  toggleAutoPlay() {
    if (this.isAutoPlaying) {
      this.stopAutoPlay();
    } else {
      this.startAutoPlay();
    }
  }

  startAutoPlay() {
    this.isAutoPlaying = true;
    this.renderAutoplayControls();
    this.scheduleNextAutoLine();
  }

  stopAutoPlay() {
    this.isAutoPlaying = false;
    if (this.autoPlayTimer) {
      clearTimeout(this.autoPlayTimer);
      this.autoPlayTimer = null;
    }
    this.renderAutoplayControls();
  }

  setSpeed(speed) {
    this.playbackSpeed = speed;
    this.renderAutoplayControls();
    if (this.isAutoPlaying) {
      if (this.autoPlayTimer) clearTimeout(this.autoPlayTimer);
      this.scheduleNextAutoLine();
    }
    if (window.proceduralAudio) window.proceduralAudio.playSwitchSound();
  }

  scheduleNextAutoLine() {
    if (!this.isAutoPlaying) return;
    const baseDelay = 2600 / this.playbackSpeed;
    this.autoPlayTimer = setTimeout(() => {
      const data = DIALOGUES_DATA[this.currentDialogueKey];
      if (!data) return;

      if (this.currentLineIndex < data.lines.length - 1) {
        this.currentLineIndex++;
        this.renderDialogue();
        this.scheduleNextAutoLine();
      } else {
        // End of scene reached
        this.stopAutoPlay();
      }
    }, baseDelay);
  }

  nextLine() {
    const data = DIALOGUES_DATA[this.currentDialogueKey];
    if (!data) return;

    if (this.currentLineIndex < data.lines.length - 1) {
      this.currentLineIndex++;
      this.renderDialogue();
    }
  }

  prevLine() {
    if (this.currentLineIndex > 0) {
      this.currentLineIndex--;
      this.renderDialogue();
    }
  }
}

class GettingStrangeDecisionSimulator {
  constructor(containerId) {
    this.container = document.getElementById(containerId);
    this.choices = {
      dec1: 'B',
      dec2: 'B',
      dec3: 'B',
      dec4: 'C'
    };
    this.init();
  }

  init() {
    this.render();
    if (window.i18n) {
      window.i18n.addListener(() => this.render());
    }
  }

  setChoice(decKey, value) {
    this.choices[decKey] = value;
    this.render();
    if (window.proceduralAudio) {
      window.proceduralAudio.playSwitchSound();
    }
  }

  calculateEnding() {
    const { dec1, dec2, dec3, dec4 } = this.choices;

    let scoreA = (dec1 === 'A' ? 20 : 5) + (dec2 === 'A' ? 25 : 5) + (dec3 === 'A' ? 25 : 5) + (dec4 === 'A' ? 50 : 0);
    let scoreB = (dec1 === 'B' ? 15 : 10) + (dec2 === 'A' ? 20 : 15) + (dec3 === 'A' ? 20 : 15) + (dec4 === 'B' ? 50 : 0);
    let scoreC = (dec1 === 'B' ? 25 : 5) + (dec2 === 'B' ? 25 : 5) + (dec3 === 'B' ? 25 : 5) + (dec4 === 'C' ? 50 : 0);

    const total = scoreA + scoreB + scoreC;
    const pctA = Math.round((scoreA / total) * 100);
    const pctB = Math.round((scoreB / total) * 100);
    const pctC = Math.round((scoreC / total) * 100);

    if (dec4 === 'A') {
      return {
        id: 'A',
        title: 'POWRÓT (SCENA 42A / 21:45)',
        titleEn: 'RETURN (SCENE 42A / 21:45)',
        badge: 'cyan',
        desc: 'Lena zamyka pętlę i wraca do pierwotnego laboratorium IKP. Jakub nie zginął na torach, a Marta dzwoni o 21:45.',
        descEn: 'Lena closes the loop and returns to the baseline IKP lab. Jakub survived the accident, and Marta calls at 21:45.',
        pctA, pctB, pctC
      };
    } else if (dec4 === 'B') {
      return {
        id: 'B',
        title: 'UZGODNIENIE (SCENA 42B / MIESZKANIE 14)',
        titleEn: 'RECONCILIATION (SCENE 42B / FLAT 14)',
        badge: 'amber',
        desc: 'Lena przyjmuje tożsamość zaginionej poprzedniczki. Marta wita ją w progu Mieszkania 14 z herbatą — szew w futrynie pozostaje nienaruszony.',
        descEn: 'Lena accepts the role of her vanished counterpart. Marta welcomes her at the threshold of Flat 14 with tea — the doorframe seam remains untouched.',
        pctA, pctB, pctC
      };
    } else {
      return {
        id: 'C',
        title: 'ŚWIADECTWO (SCENA 42C / LINIA 4)',
        titleEn: 'TESTIMONY (SCENE 42C / LINE 4)',
        badge: 'crimson',
        desc: 'Rozproszenie sieci świadków na całą Rówień. Poranny tramwaj staje przed dwoma torami naraz — motornicza zapisuje oba wybory i rusza przed siebie.',
        descEn: 'Witness network dispersed across the entirety of Rówień. The morning tram stops before dual tracks — the driver registers both in the manifest and proceeds.',
        pctA, pctB, pctC
      };
    }
  }

  render() {
    if (!this.container) return;
    const lang = window.i18n ? window.i18n.currentLang : 'pl';
    const ending = this.calculateEnding();

    const title = lang === 'en' ? ending.titleEn : ending.title;
    const desc = lang === 'en' ? ending.descEn : ending.desc;
    const vectorTitle = lang === 'en' ? 'Climactic Coherence Vectors:' : 'Wektory Spójności Finału:';

    this.container.innerHTML = `
      <div class="decision-grid">
        <div class="decision-card">
          <span class="decision-step mono">AKT I :: SCENA 04</span>
          <h4>${lang === 'en' ? '1. IKP Reception Gate' : '1. Bramka IKP (Scena 04)'}</h4>
          <div class="decision-options">
            <button class="dec-btn ${this.choices.dec1 === 'A' ? 'active' : ''}" onclick="window.decisionSimulator.setChoice('dec1', 'A')">
              ${lang === 'en' ? 'Comply with procedure' : 'Zgodzić się na procedurę UCP'}
            </button>
            <button class="dec-btn ${this.choices.dec1 === 'B' ? 'active' : ''}" onclick="window.decisionSimulator.setChoice('dec1', 'B')">
              ${lang === 'en' ? 'Reject guard\'s version' : 'Odrzucić wersję strażnika'}
            </button>
          </div>
        </div>

        <div class="decision-card">
          <span class="decision-step mono">AKT II :: SCENA 18</span>
          <h4>${lang === 'en' ? '2. Dr Wierzbicka\'s Office' : '2. Gabinet dr Wierzbickiej'}</h4>
          <div class="decision-options">
            <button class="dec-btn ${this.choices.dec2 === 'A' ? 'active' : ''}" onclick="window.decisionSimulator.setChoice('dec2', 'A')">
              ${lang === 'en' ? 'Accept city stabilization' : 'Przyjąć rację stabilizacji'}
            </button>
            <button class="dec-btn ${this.choices.dec2 === 'B' ? 'active' : ''}" onclick="window.decisionSimulator.setChoice('dec2', 'B')">
              ${lang === 'en' ? 'Challenge erasure of people' : 'Zakwestionować wymazywanie'}
            </button>
          </div>
        </div>

        <div class="decision-card">
          <span class="decision-step mono">AKT II :: SCENA 24</span>
          <h4>${lang === 'en' ? '3. Flat 14 Surveillance' : '3. Monitoring Mieszkania 14'}</h4>
          <div class="decision-options">
            <button class="dec-btn ${this.choices.dec3 === 'A' ? 'active' : ''}" onclick="window.decisionSimulator.setChoice('dec3', 'A')">
              ${lang === 'en' ? 'Submit to biographical yield' : 'Zaakceptować uległość'}
            </button>
            <button class="dec-btn ${this.choices.dec3 === 'B' ? 'active' : ''}" onclick="window.decisionSimulator.setChoice('dec3', 'B')">
              ${lang === 'en' ? 'Refuse evidence destruction' : 'Odmówić zniszczenia dowodów'}
            </button>
          </div>
        </div>

        <div class="decision-card">
          <span class="decision-step mono">AKT III / IV :: SCENA 37</span>
          <h4>${lang === 'en' ? '4. Core Forecourt' : '4. Przedpole Rdzenia (Wybór Finału)'}</h4>
          <div class="decision-options">
            <button class="dec-btn ${this.choices.dec4 === 'A' ? 'active' : ''}" onclick="window.decisionSimulator.setChoice('dec4', 'A')">
              ${lang === 'en' ? 'Lock wave to 21:45 (A)' : 'Zablokuj falę i wróć (A)'}
            </button>
            <button class="dec-btn ${this.choices.dec4 === 'B' ? 'active' : ''}" onclick="window.decisionSimulator.setChoice('dec4', 'B')">
              ${lang === 'en' ? 'Reconcile seam with Marta (B)' : 'Uzgodnij szew z Martą (B)'}
            </button>
            <button class="dec-btn ${this.choices.dec4 === 'C' ? 'active' : ''}" onclick="window.decisionSimulator.setChoice('dec4', 'C')">
              ${lang === 'en' ? 'Disperse witness network (C)' : 'Rozprosz sieć świadków (C)'}
            </button>
          </div>
        </div>
      </div>

      <!-- Real-time Coherence Vector Gauges -->
      <div class="vector-meters-box">
        <span class="mono" style="font-size: 11px; color: var(--accent-cyan-bright); font-weight: bold;">${vectorTitle}</span>
        <div class="vector-meter-row">
          <div class="vector-meter-header mono">
            <span>Wektor A (Powrót / Pierwotna Prawda)</span>
            <span>${ending.pctA}%</span>
          </div>
          <div class="vector-meter-bar">
            <div class="vector-meter-fill vec-a" style="width: ${ending.pctA}%"></div>
          </div>
        </div>
        <div class="vector-meter-row">
          <div class="vector-meter-header mono">
            <span>Wektor B (Uzgodnienie / Szew Relacyjny)</span>
            <span>${ending.pctB}%</span>
          </div>
          <div class="vector-meter-bar">
            <div class="vector-meter-fill vec-b" style="width: ${ending.pctB}%"></div>
          </div>
        </div>
        <div class="vector-meter-row">
          <div class="vector-meter-header mono">
            <span>Wektor C (Świadectwo / Sieć Świadków)</span>
            <span>${ending.pctC}%</span>
          </div>
          <div class="vector-meter-bar">
            <div class="vector-meter-fill vec-c" style="width: ${ending.pctC}%"></div>
          </div>
        </div>
      </div>

      <div class="simulator-result-box ${ending.badge}">
        <div class="result-header">
          <span class="label-tag ${ending.badge}">${lang === 'en' ? 'CALCULATED OUTCOME' : 'OBLICZONY PROGNOZOWANY FINAŁ'}</span>
          <span class="mono" style="font-weight: bold; color: var(--text-bright);">${title}</span>
        </div>
        <p class="result-desc">${desc}</p>
      </div>
    `;
  }
}

window.GettingStrangeStoryTimeline = GettingStrangeStoryTimeline;
window.GettingStrangeDecisionSimulator = GettingStrangeDecisionSimulator;
window.DIALOGUES_DATA = DIALOGUES_DATA;
