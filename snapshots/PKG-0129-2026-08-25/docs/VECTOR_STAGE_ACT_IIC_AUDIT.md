# Rówień Vector-Stage — audyt Aktu IIc (PKG-0097)

Data: 2026-08-24. Autorstwo: własne płaskie płaszczyzny rysowane proceduralnie
w `VectorStageEnvironment` oraz w warstwie stanu każdej stacji. Nie użyto modelu
generatywnego, zewnętrznej palety, sceny, ikony ani materiału referencyjnego
wymagającego atrybucji. *Another World / Out of This World* pozostaje wyłącznie
odniesieniem do ogólnej techniki płaskich wielokątów, nie wzorem kompozycji.

Kontrakt: kompozycje zachowują istniejące `Geometry`, `CollisionShape2D`,
`Area2D`, `AirlockZone` oraz zasięgi interakcji. Potwierdzają go
`tests/pkg_0097_smoke_test.gd` i rendery `reports/pkg_0097_act2c/`. Paleta
pochodzi wyłącznie z `VectorStageStyle`.

## Zmiana wykonawcza względem Aktu I/II/IIb

W Station 01..20 warstwa `VectorStageEnvironment` była obecna, lecz każdy skrypt
stacji rysował własne, nieprzezroczyste tło pełnoekranowe na `z_index = 0`, więc
Rówień pozostawał całkowicie zasłonięty. Smoke to przechodził, bo sprawdzał
obecność węzła, a nie widoczność kadru.

W Akcie IIc `_draw()` stacji 21..25 nie maluje już tła, ścian, kafli podłogi ani
szwów paneli. Skrypt stacji rysuje wyłącznie **warstwę stanu**: jedną lub dwie
relacje płaszczyzn, które zmieniają się razem ze stanem sceny (`_draw_state_layer()`).
Kadr należy do `VectorStageEnvironment`. Dopiero to sprawia, że Rówień jest
naprawdę widoczny, co potwierdzają rendery kontrolne.

## Kadry

| Stacja | Oś / funkcja fabularna | Negatywna przestrzeń i plan gry | Paleta (max 6) | Akcent stanu | Rekwizyt-świadek |
|---|---|---|---|---|---|
| 21 — Cena ulgi | Opadająca oś od konsoli sedacji ku siedzącej sylwetce Szymona | Surowe, ciemne pole prawej ściany to miejsce po zabranym rysunku; pas gry y=210..280 wolny | atrament, grafit, stal, jasna płaszczyzna, bursztyn, tlenek | punktowy tlenek postumentu dyspozycji | `DrawingDispositionPedestal`, postument „miejsce po kimś” |
| 22 — Uległość | Pion instytucjonalny: dwa pylony zamykają próg bramki | Otwarta posadzka kolejki po lewej jest drogą, którą trzeba przejść, aby ustąpić | atrament, grafit, stal, jasna płaszczyzna, bursztyn, tlenek | tlenkowy nadproże progu tożsamości | `PaintResinResonanceSlab`, ślad emulsji z mieszkania 14 |
| 23 — Pokój projektantki | Skos niepewności: pochylona płaszczyzna kreślarska ku postumentowi modelu | Ciemne pole górnego lewego rogu trzyma decyzję podjętą bez Leny | atrament, grafit, stal, jasna płaszczyzna, bursztyn, cyjan | cyjanowy postument modelu Podstruktury | `SubstructureModel`, model z odręczną kartką |
| 24 — Marta pod obserwacją | Poziom procedury: równa ława konsol czyta mieszkanie 14 | Nieoświetlona posadzka pod ławą to fotel, którego nikt nie chce zająć | atrament, grafit, stal, jasna płaszczyzna, bursztyn, tlenek | tlenkowa kolumna narastającej korekty | `CCTVArray`, podgląd pakującej się Marty |
| 25 — Wejście Jakuba | Poziom tunelu: klin peronu prowadzi wzrok w prawo, w wylot Linii 4 | Nieoświetlony wylot tunelu to kierunek, w który żywy brat nie da się poprowadzić | atrament, grafit, stal, jasna płaszczyzna, bursztyn, cyjan | cyjanowy sygnał serwisowy (utrzymany parametr Jakuba) | `ScarChart`, karta blizny pod lewym żebrem |

## Zgodność z biblią wizualną

- Każdy kadr używa 4–6 kolorów bazowych i najwyżej jednego akcentu stanu poza
  bursztynem człowieka.
- Bursztyn wrócił do roli „życie/Lena”: jest facetem w skali postaci, nie
  płaszczyzną podłogi. Pierwsza wersja renderu łamała tę regułę i została
  poprawiona przed zamrożeniem pakietu.
- Cynober i cyjan są punktowe i przyciemnione (`VectorStageStyle.shade`), zgodnie
  z zakazem pełnoekranowej poświaty i automatycznego sygnału zła.
- Stan aktywny zmienia 1–2 relacje płaszczyzn (`_draw_state_layer()`), nie całą
  paletę ani layout. Wyjścia otwierają się jako jasna płaszczyzna, nie jako błysk.
- Brak RGB split, śniegu VHS, datamoshu, mikrotekstur i cząstek bez funkcji.

## Łańcuch kampanii

- `CAMPAIGN_TRANSITION_LIMIT` podniesiono z 20 na 25 dopiero razem z testem
  `tests/pkg_0097_smoke_test.gd`, który przechodzi realny łańcuch 20→21→…→25
  i sprawdza, że Station 25 **nie** odblokowuje nieskonwertowanej Station 26.
- Odblokowanie idzie przez normalny sygnał `level_completed` i `GameStateManager`.
  Tryb testowy pozostaje osobnym przełącznikiem w menu pauzy.
- `SAVE_SCHEMA_VERSION` pozostaje na 1; test tego pilnuje.
- Asercja limitu w `tests/pkg_0096_smoke_test.gd` została zaktualizowana z „20 nie
  odblokowuje 21” na „20 odblokowuje 21”, bo dostarczony łańcuch faktycznie się wydłużył.

## Czego ten pakiet NIE dowodzi

- Nie dowodzi odbioru filmowości, czytelności ani zrozumienia fabuły przez
  człowieka widzącego materiał po raz pierwszy.
- Nie dowodzi dostępności kontrastu ani komfortu sterowania.
- Nie naprawia zasłoniętego Równia w Station 01..20 — to pozostaje długiem
  technicznym opisanym w `docs/CURRENT_STATE.md`.
- Nie konwertuje Station 26..43.

---

## Audyt przeszkód Aktu IIc — PKG-0102

Data: 2026-08-24. Zakres pozostaje ograniczony do Station 21..25. Baseline
`pwsh -NoProfile -File .\\tools\\verify.ps1` przeszedł przed zmianami.
Weryfikacja runtime'u potwierdziła wspólne floor/shell collidery, `AirlockZone`,
`Player`, sygnał `level_completed` i dodatnie promienie interakcji. Skrypty
stacji nie malują pełnego legacy tła, ale przed tym pakietem nie wywoływały
`VectorStageStyle.draw_play_plane()` w pierwszym kroku warstwy stanu; jest to
kontrakt widoczności domykany poniżej.

Prompt wskazywał ścieżkę `scripts/state/game_state_manager.gd`, której nie ma
na dysku. Faktyczny autoload runtime'u znajduje się w
`scripts/core/game_state_manager.gd`; nie zmieniam tej istniejącej granicy.

### Mapa decyzji

| Stacja | Rodzina R / decyzja | Rzecz ze świata | Istniejąca mechanika | Koszt korekty |
|---|---|---|---|---|
| 21 | brak — świadoma cisza | konsola sedacji, Szymon po korekcie, postument rysunku | dialog i obserwacja rozdzielenia faktu publicznego od więzi | nie dotyczy; scena zachowuje rytm po korekcie |
| 22 | R2 — próg administracyjny | `Geometry/BiometricIdentityGate` współpracująca z `Props/BiometricIdentityGate` | `accept_yield()` przyjmuje obrączkę i kontakt Marty; bramka fizyczna pozostaje zamknięta do końca rozmowy | korekta odsyła Lenę do checkpointu, zapisuje próbę i wygasza detal nadproża |
| 23 | brak — świadoma cisza | model Podstruktury, rejestr osób obciążonych, pracujący terminal | dialog D-16 i kursor Śladu; konflikt pozostaje obserwacyjny | nie dotyczy; nie dokładamy mechaniki do pokoju projektantki |
| 24 | brak — świadoma cisza | CCTV Marty, wskaźnik naprężeń, pulpit dyspozycji | obserwacja transmisji i wybór jawnej/pozornej/odmownej zgody | nie dotyczy; stawką jest decyzja wobec Marty, nie przeszkoda fizyczna |
| 25 | brak — świadoma cisza | wózek Linii 4, karta blizny, Jakub jako operator | dialog D-09 i granica podmiotowości Jakuba | nie dotyczy; konfrontacja pozostaje sceną rozmowy |

W pakiecie powstaje najwyżej jedna przeszkoda i tylko w Station 22.

### Test trzech pytań — Station 22, R2

1. **Dlaczego to tu jest?** — Bramka biometryczna domyka przejście
   tranzytowe, dopóki profil lokalnej Leny nie zostanie przyjęty.
2. **Czego wymaga od Leny?** — Przyjęcia lokalnej reguły: obrączki na dłoni
   i Marty wpisanej jako kontakt, bez testu refleksu.
3. **Koszt porażki** — Korekta odsyła Lenę do checkpointu, zapisuje
   `station_22_biometric_gate_corrected`, a krawędź nadproża traci wyrazistość.

Stan sukcesu jest konkretny: `is_yield_accepted` i `is_gate_open` są prawdziwe,
fizyczna bramka podnosi się z własnego miejsca, a przejście do
`AirlockZone` pozostaje dostępne dopiero po tym stanie. Próba wywołana
`trigger_correction` przed przyjęciem profilu nie zabija Leny, nie dodaje
czasownika i nie zmienia żadnego istniejącego collidera.

### Trzy pytania — sceny bez przeszkody

- **Station 21:** „dlaczego” — nie dotyczy, bo pokój po korekcie Szymona ma
  być obserwacją; „czego wymaga” — obecności przy świadku i dialogu; „koszt” —
  nie dotyczy, bo koszt sceny jest już zapisany w losie Szymona.
- **Station 23:** „dlaczego” — nie dotyczy, bo pracujący terminal i model
  niosą scenę D-16; „czego wymaga” — śledzenia czynności Śladu; „koszt” —
  nie dotyczy, bo pokój nie rozstrzyga fizycznej próby.
- **Station 24:** „dlaczego” — nie dotyczy, bo obserwacja Marty jest osią
  procedury; „czego wymaga” — zajęcia stanowiska wobec oferty Wierzbickiej;
  „koszt” — nie dotyczy, bo koszt wynika z dyspozycji, nie z ruchu.
- **Station 25:** „dlaczego” — nie dotyczy, bo wejście Jakuba jest
  konfrontacją relacyjną; „czego wymaga” — uznania żywego człowieka przed
  przejściem; „koszt” — nie dotyczy, bo scena nie karze za wykonanie.

Te decyzje są zgodne z `FULL_STORY.md`, `CONTINUITY_TRACKER.md` i zakazem
platformingu. Testy i capture'y poniżej dowodzą kontraktów technicznych oraz
obecności kompozycji, nie funu, emocji ani zrozumienia przez zewnętrzną osobę.

## Kontrola widoczności i bramki PKG-0102

W Station 21..25 pierwszy krok `_draw_state_layer()` wywołuje
`VectorStageStyle.draw_play_plane()`, więc droga przejezdna wynika z realnych
colliderów zamiast z drugiego, nieprzezroczystego tła. Station 22 ma jedyną
nową przeszkodę tego pakietu: pracującą bramkę R2
`Geometry/BiometricIdentityGate`; Station 21, 23, 24 i 25 pozostają bez
sztucznej przeszkody. Szczegółowy audyt trzech pytań znajduje się w
`docs/TRAVERSAL_ACT_IIC_AUDIT.md`.

Test `tests/pkg_0102_smoke_test.gd` i pełny `tools/verify.ps1` potwierdzają
te kontrakty. `tools/capture_pkg_0102.gd` wygenerował pięć kadrów
`reports/pkg_0102/station_21.png`..`station_25.png` na normalnym sterowniku
Windows/OpenGL Intel Iris Xe; wszystkie kadry obejrzano. Rówień Vector-Stage,
droga i punktowe akcenty są widoczne; pozostaje to dowodem technicznym, nie
dowodem ludzkiego zrozumienia ani przyjemności.
