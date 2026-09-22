# Rówień Vector-Stage — audyt Aktu IIb (PKG-0096)

Data: 2026-08-23. Autorstwo: własne płaskie płaszczyzny rysowane proceduralnie
w `VectorStageEnvironment`; nie użyto modelu generatywnego, zewnętrznej palety,
sceny, ikony ani materiału referencyjnego wymagającego atrybucji.

Kontrakt: kompozycje zachowują istniejące `Geometry`, `CollisionShape2D`,
`Area2D` oraz zasięgi interakcji. Potwierdzają go `tests/pkg_0096_smoke_test.gd`
i rendery `reports/pkg_0096_act2b/`. Paleta pochodzi wyłącznie z
`VectorStageStyle`: atrament, grafit, stal, jasna płaszczyzna, bursztyn, cyjan
i tlenek korekty stosowany wyłącznie jako sygnał konfliktu stanu lub naprężenia.

| Stacja | Oś / funkcja fabularna | Negatywna przestrzeń i plan gry | Paleta (max 6) | Akcent stanu | Rekwizyt-świadek |
|---|---|---|---|---|---|
| 16 — Rozmowa przy stole | Pozioma intymna oś stołu pod bursztynową lampą | Nocny mrok za oknem i wolna przestrzeń nad stołem skupiają uwagę na relacji | atrament, grafit, stal, jasna płaszczyzna, bursztyn, cyjan | bursztynowa lampa i cyjanowy próg balkonu | `CrackedTeaCup`, pęknięta filiżanka ze śladem klejenia |
| 17 — Punkt Zgodności 6 | Surowy pion instytucjonalny recepcji UCP | Czyste, wysokie panele ścienne nad ławką oddają sterylny porządek urzędu | atrament, grafit, stal, jasna płaszczyzna, cyjan | cyjanowy portal gabinetu konsultacyjnego | `QueuingTicketDispenser`, bilet sprawy sprzed 17 dni |
| 18 — Wywiad zgodności | Zbieżna perspektywa gabinetu lekarsko-administracyjnego | Przestrzeń wokół biurka i aparatury izoluje badaną protagonistkę | atrament, grafit, stal, jasna płaszczyzna, bursztyn, tlenek | tlenkowa igła galwanometru i naprężenie magistrali | `CorrectionGalvanometer`, rejestrator odpowiedzi |
| 19 — Model bez oryginału | Horyzontalny podział z dwoma schematami 4-A i 4-B | Ciemna centralna wnęka reprezentuje brakujący, niepotwierdzony oryginał | atrament, grafit, stal, jasna płaszczyzna, cyjan | cyjanowe podświetlenie rejestru 11 osób | `ModelDisplayTable`, stół wariantów klatki |
| 20 — Sala Szymona | Opadająca oś ku siedzącej sylwetce Szymona | Pusta, surowa ściana sali sedacyjnej wzmacnia osamotnienie świadka | atrament, grafit, stal, jasna płaszczyzna, bursztyn, tlenek | bursztynowy rysunek studni i tlenek wymazania | `WellDrawing`, kredkowy rysunek ze skażeniem |

## Wynik audytu

- Station 16..20 mają odrębne profile `station_number = 16..20`, `AtmosphereRig`,
  `CRTDialogueBox` i checkpoint cue (`OpeningDialogueCue`); warstwy rysują się za zawartością poziomu.
- Aktywne kadry stosują 4–6 kolorów. Tlenek występuje w Station 18 i 20, gdzie
  oznacza naprężenie Podstruktury przy kłamstwie oraz wymazanie osoby z rejestru hydrologicznego.
- `GameStateManager` centralnie nasłuchuje istniejącego `level_completed` dla
  Station 01..20: odblokowuje kolejną stację, zapisuje kampanię i przechodzi
  przez fade. Station 20 jest nowym krańcem dostarczonego łańcucha (`CAMPAIGN_TRANSITION_LIMIT = 20`) i nie
  odblokowuje jeszcze Station 21.
- Render oraz smoke potwierdzają techniczny kontrakt. Nie dowodzą odbioru
  filmowości, zrozumienia fabuły, komfortu sterowania ani dostępności kontrastu
  dla człowieka widzącego materiał po raz pierwszy.
