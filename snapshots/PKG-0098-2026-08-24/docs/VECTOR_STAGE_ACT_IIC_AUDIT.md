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
