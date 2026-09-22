# Audyt przeszkód Aktu IIIb — Station 31..35 (PKG-0104)

Data: 2026-08-24. Zakres: wyłącznie Godot 4.7, Station 31..35. Audyt
wykonano na istniejących scenach i skryptach, przed dodaniem warstwy
Vector-Stage oraz nowych węzłów mechaniki. Obowiązuje
`docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`: żadnych platform do skakania,
przeszkód zręcznościowych ani nowych czasowników ruchu.

## Decyzja zakresowa

Pakiet wdraża dokładnie dwie przeszkody diegetyczne. Station 32 używa rodziny
R6, ponieważ szkło zmienia się dopiero wtedy, gdy Lena zostawi jego ślad poza
bezpośrednią uwagą. Station 33 używa rodziny R1, ponieważ próba rozdzielenia
utrzymuje dwie konfiguracje tej samej ramy i pozwala kotwicy opierać korektę.
Station 31, 34 i 35 zachowują świadomą ciszę: ich funkcją jest odpowiednio
ujawnienie winy Wierzbickiej, osobiste rozpoznanie pamięci oraz zejście Marty,
a nie dodatkowa próba ruchowa.

| Stacja | Decyzja | Rzecz ze świata | Rodzina / mechanika | Koszt korekty albo powód ciszy |
|---|---|---|---|---|
| 31 | brak — świadoma cisza | sala przechowuje jedenaście krzeseł i przedmioty osób przesuniętych; Wierzbicka podaje ich imiona | brak nowej geometrii; dialog, świadectwo i dwunaste nazwisko | nie dotyczy; scena ma ujawnić odpowiedzialność bez zamiany Wierzbickiej w bossa lub klucz |
| 32 | R6 — przeszkoda | tafla szkła utrzymuje spokojny ślad tylko w polu uwagi; po odejściu od niej Podstruktura przywraca pełną, blokującą konfigurację | `Geometry/ObservedGlassTrace` jako `AnchorableObject`; kotwica utrzymuje przejście w wersji A | decyzja `station_32_observed_glass_corrected`, reset checkpointu, wyblakła krawędź śladu; po korekcie wersja A wraca jako kolejna próba |
| 33 | R1 — przeszkoda | rama próby rozdzielenia ma dwa równoprawne zakresy, bo Lena utrzymuje gest, a Ślad utrzymuje odbicie | `Geometry/DualWitnessFrame` jako `AnchorableObject`; ta sama pozycja montażowa, inna konfiguracja bryły | decyzja `station_33_dual_witness_corrected`, reset checkpointu, wyblakły przewód wspólnego świadectwa |
| 34 | brak — świadoma cisza | rdzeń wymiany obraca się i przetwarza osad sprzeczności; Lena rekonstruuje noc identyfikacji ciała | brak nowej przeszkody; ciężar sceny wynika z pamięci i znaku UCP sprzed instytucji | nie dotyczy; korekta nie może zastąpić osobistego rozpoznania trzynastoletniej rany |
| 35 | brak — świadoma cisza | baseny sedacyjne odprowadzają osad poznawczy, a Jakub pokazuje jego stężenie | brak nowej przeszkody; zawory i odpływ wykonują pracę infrastruktury | nie dotyczy; scena ustanawia materialny koszt UCP i drogę do Marty bez toru zręcznościowego |

## Test trzech pytań — Station 32, R6

1. **Dlaczego to tu jest?** — Tafla kompensacyjna utrzymuje spokojny ślad
   tylko wtedy, gdy obserwacja obejmuje jego krawędź; gdy uwaga odchodzi,
   Podstruktura przywraca konfigurację blokującą przejście.
2. **Czego wymaga od Leny?** — Podejścia do śladu, utrzymania go jako jednej
   konkretnej właściwości oraz przejścia dopiero po zakotwiczeniu wersji A;
   nie wymaga sekwencji skoków ani timingu.
3. **Jaki jest koszt porażki?** — Niezauważona zmiana zapisuje korektę, odsyła
   Lenę do checkpointu i wygasza krawędź śladu, ale nie odbiera drogi na zawsze.

`ObservedGlassTrace` ma tę samą pozycję w obu stanach. Wersja A jest
nieblokującym śladem w przejściu; wersja B jest wysoką taflą osadzoną w ramie,
która blokuje przejście po odejściu od obserwowanego
detalu. Obiekt nie porusza się według zegara i nie jest celem skoku.

## Test trzech pytań — Station 33, R1

1. **Dlaczego to tu jest?** — Rama testowa utrzymuje dwa równoczesne zapisy
   gestu i odbicia, ponieważ węzeł Podstruktury sprawdza, czy dwie osoby mogą
   pozostać odrębnymi świadkami.
2. **Czego wymaga od Leny?** — Utrzymania własnego gestu jako wybranej
   konfiguracji, gdy druga wersja odbicia pozostaje obok; wymaga decyzji o
   tym, co ma trwać, nie skoku ani wyczucia cyklu.
3. **Jaki jest koszt porażki?** — Korekta zmienia zakres ramy, zapisuje utratę
   jednego przewodu wspólnego świadectwa, odsyła Lenę do checkpointu i
   wygasza detal mapy rozdzielenia.

`DualWitnessFrame` nie zmienia pozycji montażowej. Stan A i B różnią się tylko
zakresem bryły oraz sygnałem świadectwa; kotwica opiera falę korekty, a
niezakotwiczona próba zostawia alternatywny stan widoczny po koszcie.

## Sceny bez przeszkody

- **Station 31:** jedenaście krzeseł jest rachunkiem osób, nie torem dla ciała.
  Wierzbicka ma pamiętać nazwiska i nie wiedzieć, dlaczego utrzymał się Jakub.
- **Station 34:** rdzeń wykonuje pracę niezależnie od Leny. Rekonstrukcja
  kostnicy ma przenieść koszt zasady na jej biografię, nie wymuszać testu
  wykonawczego.
- **Station 35:** baseny i zawory są infrastrukturą filtracji; ich ruch i
  przepływ mają źródło w świecie, a przejście do Station 36 pozostaje poza
  łańcuchem kampanii.

Automaty i rendery tego pakietu będą dowodzić kontraktów technicznych,
obecności kadru i spójności dwóch przeszkód. Nie dowodzą funu, emocji,
czytelności przez nową osobę ani zrozumienia fabuły przez człowieka.
