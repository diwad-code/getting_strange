# Audyt przeszkód Aktu IIc — Station 21..25 (PKG-0102)

Data: 2026-08-24. Zakres: wyłącznie Godot 4.7, Station 21..25. Audyt
wykonano przed edycją geometrii i logiki. Obowiązuje kanon
`docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`: żadnego platformingu zręcznościowego,
przeszkód do skakania ani nowych czasowników ruchu.

## Zasada zakresu

W tym plasterku powstaje najwyżej jedna nowa przeszkoda. Station 21, 23, 24
i 25 zachowują świadomą ciszę: ich konflikt rozgrywa się przez obserwację,
dialog i decyzję, więc nie dokładamy fizycznego testu tylko po to, żeby
wypełnić kadr. Jedyna wdrożona przeszkoda to R2 w Station 22.

| Stacja | Decyzja | Rzecz ze świata | Istniejąca mechanika | Koszt korekty |
|---|---|---|---|---|
| 21 | brak przeszkody | konsola sedacji, Szymon po korekcie, postument rysunku | obserwacja i dialog | nie dotyczy |
| 22 | R2 — próg administracyjny | `Geometry/BiometricIdentityGate` współpracująca z `Props/BiometricIdentityGate` | przyjęcie lokalnej reguły obrączki i kontaktu Marty przez `accept_yield()` | checkpoint, zapis `station_22_biometric_gate_corrected`, wygaszenie detalu nadproża |
| 23 | brak przeszkody | model Podstruktury, rejestr osób obciążonych, terminal | dialog D-16 i kursor Śladu | nie dotyczy |
| 24 | brak przeszkody | CCTV Marty, wskaźnik naprężeń, pulpit dyspozycji | obserwacja i decyzja wobec Marty | nie dotyczy |
| 25 | brak przeszkody | wózek Linii 4, karta blizny, Jakub jako operator | dialog D-09 i granica podmiotowości Jakuba | nie dotyczy |

## Test trzech pytań — Station 22

1. **Dlaczego to tu jest?** Bramka biometryczna domyka przejście
   tranzytowe, dopóki profil lokalnej Leny nie zostanie przyjęty.
2. **Czego wymaga od Leny?** Przyjęcia lokalnej reguły: obrączki na dłoni
   i Marty wpisanej jako kontakt, bez testu refleksu.
3. **Jaki jest koszt porażki?** Korekta odsyła Lenę do checkpointu, zapisuje
   próbę i wygasza krawędź nadproża.

Bramka porusza się tylko dlatego, że wykonuje swoją pracę jako element
tranzytowej infrastruktury. Nie jest celem skoku ani testem czasu. Korekta
nie zabija Leny, nie dodaje czasownika ruchu i nie zmienia istniejących
floorów, ścian, `AirlockZone` ani promieni interakcji.

## Sceny bez przeszkody

- **Station 21:** obecność przy świadku i dialog są osią sceny Szymona;
  koszt jest już zapisany w losie postaci.
- **Station 23:** pracujący terminal i model niosą scenę D-16; fizyczna
  przeszkoda rozpraszałaby konflikt obserwacyjny.
- **Station 24:** stawką jest stanowisko wobec oferty Wierzbickiej, nie
  wykonanie ruchowe.
- **Station 25:** wejście Jakuba jest konfrontacją relacyjną; scena nie
  karze za wykonanie i nie wymaga sztucznej geometrii.

## Dowód techniczny

- `tests/pkg_0102_smoke_test.gd` sprawdza profile 21..25, kolejność
  `draw_play_plane()`, niezmienione collidery i zasięgi, dokładnie jedną
  `AnimatableBody2D` w Station 22, korektę z checkpointem i zapisami,
  sukces `accept_yield()` oraz łańcuch ukończeń bez Station 26.
- Bramka testu jest w `tools/verify.ps1`; pełny verify po zmianach
  zakończył się PASS.
- `tools/capture_pkg_0102.gd` zapisał pięć świeżych kadr
  `reports/pkg_0102/station_21.png`..`station_25.png` normalnym sterownikiem
  Windows/OpenGL Intel Iris Xe. Kadry mają 1280×720 i zostały obejrzane.

Automaty i rendery dowodzą kontraktów technicznych oraz obecności kompozycji,
nie funu, emocji, czytelności ani zrozumienia przez zewnętrzną osobę.
