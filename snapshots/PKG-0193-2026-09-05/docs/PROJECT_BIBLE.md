# Biblia projektu: Getting Strange

Status: **MATERIAŁ ŹRÓDŁOWY P9 — TECHNOLOGIA I RDZEŃ NARRACYJNY ZACHOWANE; FORMA PODLEGA D-168**  
Data: 2026-08-31  
Aktywna faza: P9 — Product Rescue & Hybrid Rebuild

Dokument rozwija `PRODUCT_BRIEF.md`. Kanon znajduje się w
`narrative/NARRATIVE_BIBLE.md`, przebieg w `narrative/FULL_STORY.md`, wiedza i
flagi w `narrative/CONTINUITY_TRACKER.md`, a głosy w
`narrative/DIALOGUE_SCRIPT.md`. Audyt 0.2 i decyzję o rewolucji zapisują
`NARRATIVE_SKILL_AUDIT_0_2.md` oraz ADR-007.

Oznaczenia:

- **DECYZJA** — obowiązuje do jawnego zastąpienia;
- **KONTRAKT** — powinien mieć test, lint, pomiar albo jednoznaczną inspekcję;
- **HIPOTEZA** — doświadczenie odbiorcy, którego implementacja sama nie dowodzi;
- **LEGACY** — działa na dysku, lecz nie ustanawia aktywnej treści.

## 1. Tożsamość gry

**DECYZJA:** `Getting Strange` jest filmową, narracyjną grą 2D z eksploracją,
środowiskowym śledztwem i decyzjami relacyjnymi. Nie jest platformerem arcade,
visual novel ani chodzącym dokumentem lore.

Krótka obietnica:

> Powtarzasz trzysekundowy odczyt przy Linii 4 i wracasz do znanej dzielnicy.
> Najpierw myli się rozkład, potem klucz, relacja, praca i żywy brat. Gdy wreszcie
> wiesz, że to nie twój świat, odkrywasz, że druga ty próbowała udowodnić cenę
> jego ocalenia — i utknęła tam, gdzie instytucja przestała liczyć ludzi.

## 2. Decyzja produkcyjna

**DECYZJA:** zachowujemy sprawny techniczny szkielet, ale autorujemy narrację
0.3 od rdzenia relacji. Nie rozpoczynamy pustego projektu.

Zachowane:

- Godot 4.7, `640x360`, fizyka 60 Hz i semantyczny InputMap;
- shell, pauza, ustawienia, zapis, restart i routing kampanii;
- 43 odwiedzane adresy oraz trzy techniczne warianty Station 42;
- proceduralne audio, CRT i infrastruktura testów;
- prototyp Anchor/Yield jako źródło zachowania;
- komponenty Foundation Slice, jeśli przejdą klasyfikację i testy.

Ponownie autorowane lub adaptowane:

- cele, przeszkody, działania i zmiany Station 01–43;
- przyczyna przejścia, relacje i druga tajemnica;
- dialog, wewnętrzny głos i stan wiedzy;
- aktorska postać Leny, Pixel-Stage i ostre teksty;
- flagi, zgody, końcowe matryce osób oraz plan pakietów.

**LEGACY:** wcześniejsza scena może pozostać technicznie sprawna, ale jej tekst,
rekwizyt i beat nie są produkcyjne tylko dlatego, że smoke je zna.

## 3. Dwie tajemnice i osiem sekwencji

| Sekwencja | Station | Pytanie | Zmiana |
|---|---:|---|---|
| próbka | 01–05 | czy odczyt jest czysty i czy Lena wróci do Marty? | zachowuje próbkę, łamie obietnicę; świat normalny |
| rysa | 06–09 | czy zmieniła się trasa/adres? | lokalne źródła są zgodne przeciw pamięci |
| cudzy dom | 10–13 | czy ktoś ukradł tożsamość lub pamięć? | obce życie ma dokumenty i intymność |
| Marta i zapis | 14–17 | czy relacja albo UCP manipuluje Leną? | biografia instytucjonalna trwa od miesięcy |
| niemożliwy brat | 18–21 | czy Jakub jest oszustwem? | trzy dowody -> `To nie jest mój świat` |
| test wzajemny | 22–30 | gdzie jest miejscowa Lena? | test był dwustronny, UCP zmienił wynik |
| rachunek Linii 4 | 31–38 | kto już płaci za stabilność? | jawna para kosztów i zgody osób |
| metoda i skutek | 39–43 | którą wartość chronić? | wykonanie i konkretne życie po nim |

**KONTRAKT:** Station 21 odpowiada wyłącznie na pierwszą tajemnicę. Station 22
uruchamia działanie i drugą tajemnicę. Nie wolno zamieniać drugiej połowy w
serię abstrakcyjnych terminali po już zakończonym zwrocie.

## 4. Lena i rdzeń emocjonalny

Lena Wolska, 29 lat, jest diagnostyczką drgań. Dziewięć lat wcześniej
katastrofa Linii 4 zabiła jej brata Jakuba, a trzysekundową lukę w danych
uznano za błąd czujnika. Nie była winna wypadkowi, lecz zbudowała życie wokół
przekonania, że dokładniejszy pomiar mógłby odebrać przypadkowi władzę.

**Pragnienie:** wrócić do domu i odzyskać pewny porządek przyczyn.  
**Fałszywe przekonanie:** decyzję można odłożyć, aż wszystkie dane będą czyste.  
**Potrzeba:** działać uczciwie przy niepełnej wiedzy i pytać o zgodę osób
używanych przez metodę.

Gracz czyta ją z ciała: długości zatrzymania, ustawienia ciężaru, kierunku
głowy, odłożenia czytnika, cofniętej ręki, oddechu i sposobu wejścia w próg.
Myśl dopowiada tylko to, czego nie da się uczciwie pokazać.

## 5. Relacje jako system przyczyn

### Marta Kurek

- dom: najbliższa przyjaciółka i dawna partnerka terenowa Leny;
- Rówień: partnerka życiowa miejscowej Leny;
- cel: odnaleźć własną Lenę, nie przyjąć zamiennika;
- prawo systemowe: daje, ogranicza albo odmawia dostępu do procedury i sygnału
  na podstawie pełności informacji, nie punktów sympatii.

### Jakub Wolski

- dom: zmarł w katastrofie Linii 4;
- Rówień: 34-letni technik utrzymania, żyjący dziewięć dalszych lat;
- cel: odnaleźć siostrę i nie pozwolić zredukować życia do dowodu/długu;
- prawo systemowe: zgoda na własny nadajnik ma zakres i może zostać cofnięta.

### Miejscowa Lena

- partnerka Marty, siostra Jakuba i pracowniczka UCP-4;
- odkryła eksport kosztów stabilizacji i uruchomiła test wzajemny;
- źle oszacowała zgodę osoby po drugiej stronie;
- jest uwięziona między adresami po interwencji Wierzbickiej;
- jej los ma jawny stan w każdej rodzinie zakończenia.

### Dr Helena Wierzbicka

- kieruje stabilizacją UCP;
- chroni Rówień i większość kosztem autonomii słabiej mierzonych osób;
- przed 21 jest podpisem/procedurą, po 22 aktywną przeciwniczką;
- może mówić prawdę selektywnie i współpracować lokalnie, ale nie dostarcza
  bezkosztowego rozwiązania.

## 6. Pętla sceny

**KONTRAKT:** każda stacja zapisuje i wdraża:

1. cel postaci;
2. przeszkodę z przyczyną diegetyczną;
3. działanie gracza;
4. reakcję świata i ciała;
5. ocenę faktu;
6. decyzję albo nowe oczekiwanie.

Stacja może być celowo cicha, ale nie może istnieć wyłącznie po to, by gracz
podszedł do jednego tekstu. Jeśli dwie sąsiednie przestrzenie mają ten sam cel,
przeszkodę i zmianę, traktuje się je jako jedną sekwencję z oddechem, nie dwa
sztuczne rozdziały.

## 7. Podstawowe czasowniki

Przed rozpoznaniem:

- obserwuj i słuchaj;
- idź, biegnij, skacz lub wspinaj się kontekstowo;
- zbadaj, dotknij, uruchom albo obejdź materialny element;
- porównaj dwa źródła;
- sformułuj hipotezę przez wybór testu, nie menu myśli;
- ochronić próbkę, granicę lub sprawczość.

Po Station 22:

- Zakotwicz wybraną relację/parametr;
- Ulegnij odpowiedzi sąsiedniego stanu;
- poproś o zgodę albo działaj bez niedostępnej relacji;
- zachowaj/ujawnij rejestr;
- zatwierdź nieodwracalny wzór działania.

Każda przeszkoda musi przejść test D-099. Maszyna porusza się, ponieważ wykonuje
pracę; nie jest skokowym klockiem. Brak wrogów patrolujących, kolców, health
baru i aren timingu.

## 8. Anchor/Yield

### Zakotwiczenie

Utrzymuje wybrany związek lub wynik mimo zakłócenia. Koszt pojawia się w
nieutrzymanym parametrze: pamięci Marty, dokładności drugiego sygnału, zapisie
godziny albo stabilności sąsiedniego węzła.

### Uległość

Dopuszcza odpowiedź sąsiedniego stanu bez wymuszenia. Kosztem jest utrata
dokładnego adresu, czasu, nośnika albo gwarancji powrotu.

### Twarde granice

- pierwsze świadome nazwanie: Station 22;
- pierwszy bezpieczny test: martwy obwód 23;
- pierwszy koszt dotyczący relacji/nośnika: 28;
- człowiek nigdy nie jest pojedynczym suwakiem;
- zgoda Jakuba i Marty otwiera ich rzeczywiste działania, nie bonusy;
- finał używa wyłącznie zachowań nauczonych do Station 38.

## 9. Pokaż -> naprowadź -> pomyśl -> sprawdź

L0–L4 z `PLAYER_GUIDANCE_AND_INNER_VOICE.md` pozostaje obowiązujące, z nowym
akcentem na sprawdzalną hipotezę:

- L0 pokazuje różnicę kompozycją, ruchem i dźwiękiem;
- L1 pozwala wykonać bezpieczną próbę;
- L2 nazywa fakt albo obronną interpretację Leny;
- L3 wskazuje test, który rozróżni hipotezy;
- L4 jako głos systemu wskazuje działanie, nie „poprawną” emocję lub dialog.

**KONTRAKT:** omylna myśl nigdy nie fałszuje sterowania, stanu obiektu,
nieodwracalnego kosztu ani zgody postaci. Po korekcie nie odtwarza się stara
hipoteza.

## 10. Wiedza i fair play

Pierwsze rozpoznanie wymaga:

1. obcej, spójnej biografii prywatnej i publicznej;
2. nośnika przybyłej Leny spoza lokalnego rejestru;
3. żywego Jakuba z odmienną relacją oraz pełnym lokalnym życiem.

Druga tajemnica wymaga:

1. równoległego grafiku i wspólnego czasu testów;
2. komendy Wierzbickiej wydanej po kontakcie;
3. sprawczej odpowiedzi miejscowej Leny;
4. procedury z warunkiem abortu i brakiem pełnej zgody;
5. echa domu wykluczającego prosty swap;
6. rejestru par kosztów Linii 4.

**KONTRAKT:** żadna nowa zdolność, reguła ani urządzenie rozwiązujące finał nie
pojawia się po Station 38.

## 11. Świat i prawda

Rówień jest pełnoprawną ciągłością. UCP nie stworzył światów, ale nauczył się
stabilizować lokalne wyniki i eksportować niezgodność poza własny zakres.
Podstruktura jest warstwą relacji, nie mówiącą istotą.

Gra rozstrzyga konkretną przyczynę przejścia: dwie zgodne próby o 20:40 i
Zakotwiczenie lokalnej obecności przez Wierzbicką. Może pozostawić nieznane:
liczbę światów, istnienie oryginału i długoterminową naturę przecieku.

## 12. Finał i stan osób

Rodziny:

1. wymuszenie domu;
2. zamknięcie Równi z powrotem miejscowej Leny;
3. wzajemna odpowiedź obu Len z trwałym przeciekiem.

**KONTRAKT:** Station 43 pokazuje stan:

- Leny przybyłej;
- Leny miejscowej;
- Marty domowej;
- Marty Równi;
- Jakuba;
- Wierzbickiej/UCP;
- relacji światów.

Brak osoby jest także stanem i musi mieć widoczną konsekwencję. Wariant
stabilności nie może po cichu tworzyć czwartego finału, który zachowuje
wszystko.

## 13. Kierunek wizualny

**DECYZJA:** Rówień Pixel-Stage.

- świat, Lena i efekty: wspólny raster efektywny `320x180`;
- UI, dialog, myśli, czytelne napisy i terminale: ostre `640x360` później;
- postać: ludzki rig i animacja aktorska, nie proceduralny znacznik;
- kompozycja: jeden główny akcent, czytelna droga, stabilne materiały;
- dziwność: zmienia znaczenie konkretnego detalu, nie zasypuje ekranu glitchem;
- kamera: krótkie ujawnienie i reakcja ciała, bez długiego odbierania sterowania.

Pełne kontrakty: `VISUAL_DESIGN.md`, `LENA_CHARACTER_AND_ANIMATION.md` i
`PIXEL_PRESENTATION_ARCHITECTURE.md`.

## 14. Dźwięk

- kroki, ubranie, czytnik i oddech budują ciało;
- źródło ważnego dźwięku istnieje w kadrze;
- sygnatura trzech sekund zaczyna jako techniczna usterka;
- Station 01–05 nie używa paranormalnego stingu;
- cisza po Jakubie/Station 21/wyborze jest intencjonalnym beatem;
- proceduralna infrastruktura pozostaje, ale cue podlega funkcji sceny.

## 15. Dostępność i tekst

- pełne napisy i nazwa źródła;
- regulacja 85–115% i tempo;
- pomijanie linii bez blokowania flag;
- brak informacji wyłącznie kolorem;
- L4 opcjonalne, wyraźnie systemowe;
- dialog, myśl, dokument i terminal nad kompozytorem;
- pauza zatrzymuje timer guidance i nie zmienia stanu rozmowy.

## 16. Stan kampanii

System zapisu utrzymuje fakty, nie punkty moralności:

- integralność próbki domowej;
- integralność sygnału miejscowej Leny;
- pełność prawdy przekazanej Marcie;
- zakres zgody Jakuba;
- zachowanie rejestru UCP;
- wzór Anchor/Yield;
- rodzinę i stabilność zakończenia.

Dokładne flagi definiuje `CONTINUITY_TRACKER.md`. Save schema może pozostać 1,
jeżeli migrator jawnie mapuje legacy; sama zgodność numeru schema nie może
ustawić `world_recognized` ani nowej zgody.

## 17. Migracja pionowego wycinka

Każdy zakres przechodzi:

1. odczyt aktualnego runtime i snapshotu poprzedniego pakietu;
2. klasyfikację `KEEP / ADAPT / RETIRE` dla scen, rekwizytów i tekstów;
3. zapis celu, przeszkody, działania, zmiany i wiedzy przed kodem;
4. wdrożenie postaci, obrazu, guidance, treści i stanu razem;
5. test słownika/wiedzy/flag oraz pakietowy smoke;
6. normal-driver capture dla zmian wizualnych;
7. aktualizację bible tylko wtedy, gdy wykonanie ujawni realną sprzeczność;
8. stan, log, handoff, pełne verify i snapshot.

Równolegle istniejące nieudokumentowane zmiany nie są nadpisywane. Najpierw
ustala się ich zakres i wynik testu.

## 18. Definition of Done wycinka

Wycinek jest ukończony, gdy:

1. runtime, kanon i testy mówią to samo;
2. każda stacja ma pełną pętlę działania albo jawny oddech sekwencji;
3. wiedza postaci pochodzi z ustanowionego źródła;
4. Lena ma wymagane stany ruchu i reakcje;
5. obraz prowadzi przed tekstem;
6. tekst pozostaje ostry;
7. restart/zapis zachowują flagi i zgody;
8. testy kończą się kodem 0;
9. kadry wizualne są obejrzane technicznie;
10. stan, log, handoff i snapshot opisują faktyczny rezultat.

## 19. Aktywne hipotezy

- zwyczajny początek z konfliktem pomiar/obietnica utrzyma uwagę;
- różnica dwóch relacji Marty będzie czytelna, nie dezorientująca;
- Jakub zabrzmi jak żywa osoba, nie filozoficzny dowód;
- druga tajemnica utrzyma napięcie po rozpoznaniu w 21;
- UCP pozostanie skuteczne i krzywdzące jednocześnie;
- myśli obronne będą ludzkie, nie arbitralne;
- Anchor/Yield uniesie 22–40 bez powtarzalności;
- trzy finały nie zakodują ukrytego golden ending;
- 2,5–3,5 godziny zapewni oddech między szczytami;
- nowa Lena i tekst pozostaną czytelne po Pixel-Stage.

Automaty, dokumenty i własna inspekcja nie zmieniają tych hipotez odbiorczych w
fakty o emocji, funie, zrozumieniu lub chemii postaci.
