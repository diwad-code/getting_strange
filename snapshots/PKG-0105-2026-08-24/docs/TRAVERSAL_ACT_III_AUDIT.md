# Audyt przeszkód Aktu III — Station 26..30 (PKG-0103)

Data: 2026-08-24. Zakres: wyłącznie Godot 4.7, Station 26..30. Audyt
wykonano przed zmianą scen, skryptów i warstwy Vector-Stage. Obowiązuje
`docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`: żadnych platform do skakania,
przeszkód zręcznościowych ani nowych czasowników ruchu.

## Decyzja zakresowa

Pakiet wdraża dokładnie dwie nowe przeszkody diegetyczne. Obie korzystają z
istniejących rodzin R5/R1 i z istniejącego modelu korekty: próba nie kończy
gry, zapisuje koszt, wraca do checkpointu i wygasza konkretny detal. Station
27, 28 i 29 zachowują świadomą ciszę; nie dodaję geometrii tylko po to, by
każda scena miała test ruchowy.

| Stacja | Decyzja | Rzecz ze świata | Istniejąca mechanika | Koszt korekty |
|---|---|---|---|---|
| 26 | R5 — przeszkoda | `Geometry/AdaptiveIsolationPartition`, akustyczna przegroda przesuwana przez cykl rekonfiguracji strefy | `RoomState`, komunikaty PA, `MotivationAnchor` | decyzja `station_26_isolation_partition_corrected`, checkpoint, wyblakła krawędź wskaźnika funkcji pokoju |
| 27 | brak — świadoma cisza | wyjście serwisowe, karta Jakuba, monitor naprężeń i jego dług wdzięczności | dialog Jakuba i odblokowanie bramy | nie dotyczy; stawką jest odpowiedzialność za ludzi na powierzchni |
| 28 | brak — świadoma cisza | techniczny tramwaj jedzie własnym cyklem, a okna pokazują trzy wersje wypadku | obserwacja okna, paradoksu i interkomu | nie dotyczy; ruch wagonu jest pracą infrastruktury, nie próbą zręcznościową |
| 29 | brak — świadoma cisza | peron trzynasty, kozioł oporowy, szyb naprężeń i krata rewizyjna | dialog, neon, latarka Jakuba i wejście do Podstruktury | nie dotyczy; scena ustanawia próg Aktu III przez obraz i rozmowę |
| 30 | R1 — przeszkoda | `Geometry/WitnessRelayBank`, węzeł rozdzielający konfiguracje świadectw | istniejący pulpit bezpiecznika i mapa sieci; `AnchorableObject` z Prototype 02 | decyzja `station_30_witness_relay_corrected`, checkpoint, wyblakły przewód na mapie świadków |

## Test trzech pytań — Station 26, R5

1. **Dlaczego to tu jest?** — Przegroda akustyczna przesuwa się po szynie, gdy
   strefa izolacji rekonfiguruje funkcję pomieszczenia na polecenie UCP.
2. **Czego wymaga od Leny?** — Odczytania komunikatu PA, obserwowania pełnego
   cyklu i przejścia dopiero wtedy, gdy przegroda wykonuje swoją pracę w
   położeniu otwartym; nie wymaga skoku ani sekwencji refleksu.
3. **Jaki jest koszt porażki?** — Niezgodna próba uruchamia korektę, zapisuje
   koszt, odsyła Lenę do checkpointu i wygasza krawędź wskaźnika funkcji pokoju.

Przegroda porusza się niezależnie od obecności Leny. Jej cykl jest czytelny
przez komunikat, pozycję i niski dźwięk infrastruktury; nie zatrzymuje się na
jej żądanie i nie jest celem skoku.

## Test trzech pytań — Station 30, R1

1. **Dlaczego to tu jest?** — Węzeł przekaźnikowy przełącza dwa układy
   świadectw, bo Podstruktura rozdziela zgodne pamięci od rejestru publicznego.
2. **Czego wymaga od Leny?** — Utrzymania jednej konkretnej konfiguracji
   świadectw, gdy Jakub odłącza automatyczny nadzór; wymaga decyzji o tym, co
   ma pozostać obserwowalne, nie skoku ani timingu.
3. **Jaki jest koszt porażki?** — Korekta przerzuca węzeł do drugiej
   konfiguracji, zapisuje utratę jednego przewodu świadectwa, odsyła Lenę do
   checkpointu i wygasza odpowiedni detal mapy.

Wariant A i B mają tę samą pozycję montażową, ale różny zakres bryły i
świadectw; węzeł nie przejeżdża przez kadr i nie tworzy ruchomej platformy.
Zakotwiczenie opiera się korekcie, zgodnie z mechaniką Prototype 02.

## Sceny bez przeszkody

- **Station 27:** Jakub nie jest kluczem do zagadki; jego żądanie dowodu, że
  prawda nie zamieni ludzi w dług, jest osią sceny. Istniejąca brama wykonuje
  pracę po decyzji i nie wymaga dodatkowej geometrii.
- **Station 28:** wagon techniczny jedzie, bo jest wagonem i realizuje tranzyt
  Linii 4. Trzy wersje peronu, różnica widzenia Jakuba i Leny oraz komunikat
  Wierzbickiej są kompletną sceną obserwacyjną.
- **Station 29:** peron trzynasty ma ustanowić materialny próg Podstruktury;
  szyby, neon, szyb naprężeń i krata są świadkami, nie torem zręcznościowym.

Automaty i rendery tego pakietu będą dowodzić kontraktów technicznych,
obecności kadru i spójności przeszkód. Nie dowodzą funu, emocji, czytelności
przez nową osobę ani zrozumienia fabuły przez człowieka.
