# Prompt dla następnej sesji: PKG-0100 (Akt I grywalny, Station 01..10)

> **Przeczytaj ten dokument w całości, zanim dotkniesz jakiegokolwiek pliku.**
> Kroki są ponumerowane. Wykonuj je po kolei. Nie wymyślaj własnej kolejności.

---

## 0. Czym jest ta gra (przeczytaj, nawet jeśli myślisz, że wiesz)

Getting Strange to **gra w silniku Godot 4.7**. Nic innego. Nie strona, nie
portal, nie aplikacja webowa. Jeżeli cokolwiek sugeruje inaczej — to pomyłka,
powiedz o tym wprost i pracuj nad grą (D-098).

To jest **filmowa gra narracyjna z elementami zręcznościowymi**, a nie
platformówka zręcznościowa. Kanon przeszkód
(`docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`) jest nadrzędny wobec każdej sceny
i **obowiązkowy do przeczytania w kroku 1**.

## 1. CEL SESJI

PKG-0099 udowodnił wzorzec na jednym ciągu: Station 11..15 mają widoczną warstwę
Vector-Stage, dwie prawdziwe przeszkody diegetyczne i pierwsze użycie
Zakotwiczenia w kampanii. Ten pakiet **rozszerza dokładnie ten sam wzorzec na
Akt I: Station 01..10**, i nic więcej.

Nie konwertujemy kolejnych aktów wizualnie. Nie podnosimy
`CAMPAIGN_TRANSITION_LIMIT`. Nie wymyślamy nowej mechaniki.

## 2. STAN WYJŚCIOWY (co już istnieje i czego NIE piszesz od nowa)

| Rzecz | Gdzie | Status |
|---|---|---|
| Wzorzec warstwy stanu | `scripts/levels/station_14.gd`, `station_21.gd` | **skopiuj to** |
| Droga przejezdna z colliderów | `VectorStageStyle.draw_play_plane()` | działa, **użyj tego** |
| Zakotwiczenie w kampanii | `scenes/levels/station_14.tscn`, węzeł `ScoredMetalPanel` | **wzorzec referencyjny** |
| Przeszkoda R1+R3 | `scripts/levels/station_12.gd` | **wzorzec referencyjny** |
| Bramka kontraktowa | `tests/pkg_0099_smoke_test.gd` | **wzorzec do skopiowania** |
| Rendery kontrolne | `tools/capture_pkg_0099.gd` | **wzorzec do skopiowania** |
| Audyt przeszkód | `docs/TRAVERSAL_ACT_II_AUDIT.md` | **wzorzec do skopiowania** |

Środowisko: Godot 4.7.stable na Windows, PowerShell 7, **brak gita** (D-016).
Stan projektu to wyłącznie pliki na dysku. Nie uruchamiaj `git`.

## 3. KROK PO KROKU

### Krok 1 — czytanie obowiązkowe

1. `AGENTS.md` (sekcje „Current phase” i „Obstacle rule”)
2. `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` — **cały dokument**
3. `docs/TRAVERSAL_ACT_II_AUDIT.md` — co dokładnie zrobił poprzedni pakiet
4. `VISUAL_DESIGN.md` rozdziały 2, 4 i 11
5. `scripts/levels/station_12.gd` i `station_14.gd` — działające przeszkody
6. `docs/narrative/FULL_STORY.md`, sceny 01–10

### Krok 2 — świeży baseline

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Musi przejść **zanim** zaczniesz zmiany. Pełny bieg trwa dłużej niż jeden limit
wywołania terminala — uruchom go jako proces monitorowany i odczytaj końcowy
exit code oraz log. Jeżeli baseline nie przechodzi, napraw to najpierw i opisz.

### Krok 3 — widoczność kadru w Station 01..10 (dług D-096)

Dla każdej z 01..10:

1. Otwórz `scripts/levels/station_NN.gd`.
2. W `_draw()` **usuń** rysowanie tła, ścian, kafli podłogi i szwów paneli.
3. Zostaw wyłącznie `_draw_state_layer()` oraz wywołanie HUD dialogowego.
4. Jako pierwszą rzecz w `_draw_state_layer()` wywołaj
   `VectorStageStyle.draw_play_plane(self, geometry)`. Bez tego droga
   przejezdna zniknie z kadru — to był realny błąd w PKG-0099.
5. Kolory bierz **wyłącznie** z `VectorStageStyle`. Akcenty stanu (cyjan,
   cynober) są **punktowe**, przyciemniane przez `VectorStageStyle.shade()`.
6. Wzór do skopiowania: `scripts/levels/station_14.gd`.

Sprawdź przy okazji profile 1..10 w `scripts/visual/vector_stage_environment.gd`.
Jeżeli któryś maluje cyjan lub cynober jako płaszczyznę na całą wysokość kadru
— zredukuj go do akcentu punktowego, tak jak zrobiono dla 11..15.

Nie zmieniaj przy tym żadnego collidera ani zasięgu interakcji.

### Krok 4 — po jednej przeszkodzie w Station 06..10

Station 01..05 to prolog pomiaru; mogą zostać bez próby fizycznej (kanon §6).
Station 06..10 mają dostać **po jednej** przeszkodzie z zamkniętego katalogu
R1..R7. Sugestie wyprowadzone z `FULL_STORY.md`, ale decyzja należy do Ciebie:

- **06 Linia zastępcza** — R5 (infrastruktura w cyklu): autobus zastępczy
  odjeżdża według rozkładu, nie według gotowości gracza.
- **07 „Wróciłaś”** — R7 (realna architektura pionowa): klatka schodowa.
- **08 Mieszkanie po kimś** — R4 (ciężar): przesunięcie mebla; użyj
  istniejącego `MovableAnchorableProp`, nie pisz nowego.
- **09 Pokój, który nie czeka** — R1 (niezgodność wersji) na lustrze.
- **10 Telefon Jakuba** — R2 (próg administracyjny) albo cisza; jeżeli scena
  jest rozmową, ma prawo nie mieć próby fizycznej.

Dla każdej przeszkody obowiązuje:

1. Węzeł nazywa się rzeczą ze świata. Nazwy z `tests/traversal_lint_test.gd`
   są zakazane, w tym każda zawierająca fragment „platform”.
2. Jeżeli używasz `AnchorableObject`, **obie wersje muszą być wiarygodne
   w fikcji**, a bryła nie może przejeżdżać przez kadr jako cel skoku na czas.
   Jeżeli Twoje rozwiązanie sprowadza się do „poczekaj aż przyjedzie i skocz” —
   jest błędne, przeprojektuj je.
3. Porażka to **korekta**, nie śmierć: zapis kosztu przez
   `GameStateManager.record_decision(...)`, powrót do punktu kontrolnego,
   trwały zanik jednego detalu sceny.
4. Zagrożenie musi być czytelne **zanim** stanie się groźne.

### Krok 5 — nagłówki „testu trzech pytań”

W każdym skrypcie stacji, do której dodałeś przeszkodę, dopisz w nagłówku:

```gdscript
## PRZESZKODA — dlaczego to tu jest: <zdanie o świecie, bez słowa "gracz">
## PRZESZKODA — czego wymaga od Leny: <czynność człowieka, nie sekwencja skoków>
## PRZESZKODA — koszt porażki: <co traci świat lub inna osoba>
```

To jest wymóg, nie sugestia. Bramka PKG-0100 ma to sprawdzać tak samo, jak
robi to `tests/pkg_0099_smoke_test.gd`.

### Krok 6 — redukcja rysunku `AnchorableObject`

`scripts/interactables/anchorable_object.gd` rysuje nity, kratownice i wsporniki
odziedziczone po prototypie. To jest gęstsze niż reszta Rówień Vector-Stage
(hipoteza H-0099-C). Zredukuj rysunek do 2–4 celowych płaszczyzn w kolorach
`VectorStageStyle`, zachowując czytelność stanu: trzymane / nietrzymane /
w zasięgu. **Nie zmieniaj logiki, colliderów ani API klasy** — prototyp
`anchor_lab` musi dalej przechodzić smoke test.

### Krok 7 — test kontraktowy

Utwórz `tests/pkg_0100_smoke_test.gd` na wzór `tests/pkg_0099_smoke_test.gd`.
Ma sprawdzać:

- Station 01..10 ładują się, mają `VectorStageEnvironment` z właściwym
  `station_number` i metodę `_draw_state_layer()`;
- collidery, `AirlockZone`, `Props` i zasięgi interakcji są nienaruszone
  (uwaga: nie każda scena ma `FloorMain` — zapisz faktyczne nazwy jako kontrakt,
  nie zmieniaj scen pod test);
- każda dodana przeszkoda istnieje jako węzeł i realnie zmienia stan;
- każdy skrypt stacji z przeszkodą ma trzy linie nagłówka i nie ma słowa
  „gracz” w zdaniu o świecie;
- łańcuch ukończeń 01→10 działa i **nie przekracza limitu 25**.

Wepnij bramkę do `tools/verify.ps1` obok pozostałych.

### Krok 8 — rendery kontrolne

Utwórz `tools/capture_pkg_0100.gd` na wzór `tools/capture_pkg_0099.gd`
i wygeneruj `reports/pkg_0100/station_01.png`..`station_10.png` na normalnym
sterowniku Windows (bez `--headless`).

**Obejrzyj te rendery.** Sprawdź na obrazie, a nie w kodzie:

- czy warstwa Vector-Stage jest faktycznie widoczna;
- czy droga przejezdna ma najwyższy kontrast w kadrze;
- czy nic nie wisi w powietrzu bez konstrukcji nośnej;
- czy akcenty (cyjan, cynober) są punktowe, a nie świecącymi płaszczyznami.

Jeżeli render łamie `VISUAL_DESIGN.md` — popraw i wyrenderuj ponownie
**przed** zamknięciem pakietu. W PKG-0099 pierwsza wersja renderów łamała §4
i wymagała trzech iteracji. Zaplanuj na to czas.

### Krok 9 — dokumentacja i zamrożenie

1. Dopisz audyt `docs/TRAVERSAL_ACT_I_AUDIT.md` (dla każdej przeszkody:
   rodzina R, odpowiedzi na trzy pytania, model porażki).
2. Zaktualizuj `docs/CURRENT_STATE.md` i `docs/SESSION_LOG.md`.
3. Dopisz decyzje do `docs/DECISION_LOG.md`.
4. Zarejestruj nowy audyt w `docs/INDEX.md`.
5. Napisz `docs/NEXT_SESSION_PROMPT.md` dla PKG-0101.
6. Uruchom pełny `tools\verify.ps1` i dopiero po wyniku PASS zamroź pakiet.

## 4. CZEGO NIE WOLNO ZROBIĆ

- **Nie dodawaj ruchomych platform, po których się skacze.** To jest zakaz
  numer jeden w tym projekcie. Nie ma od niego wyjątku.
- Nie dodawaj kolców, lawy, wrogów, pasków zdrowia ani punktów.
- Nie dodawaj nowych czasowników ruchu (dash, podwójny skok, wall-jump).
- Nie zmieniaj fizyki gracza, rozdzielczości 640×360 ani 60 Hz.
- Nie zmieniaj istniejących colliderów, `AirlockZone` ani zasięgów `Area2D`.
- Nie podnoś `CAMPAIGN_TRANSITION_LIMIT` — ten pakiet go nie dotyczy.
- Nie konwertuj wizualnie stacji spoza 01..10.
- Nie zmieniaj logiki ani API `AnchorableObject` — tylko jego `_draw()`.
- Nie pisz, że test dowiódł przyjemności grania. Testy dowodzą kontraktów
  technicznych i niczego więcej (D-012, ADR-003).

## 5. KRYTERIA AKCEPTACJI

1. Świeży pełny verify jako baseline przeszedł przed zmianami.
2. Station 01..10 mają widoczną warstwę Rówień Vector-Stage, potwierdzoną renderem.
3. Droga przejezdna ma w każdym z dziesięciu kadrów najwyższy kontrast.
4. Station 06..10 mają po jednej przeszkodzie z katalogu R, z modelem porażki
   przez korektę.
5. Każda przeszkoda ma w nagłówku odpowiedzi na trzy pytania.
6. Rysunek `AnchorableObject` mieści się w 2–4 płaszczyznach, a `anchor_lab`
   nadal przechodzi smoke test.
7. `tests/pkg_0100_smoke_test.gd`, `tests/pkg_0099_smoke_test.gd`
   i `tests/traversal_lint_test.gd` przechodzą.
8. Rendery obejrzane i zgodne z biblią wizualną.
9. Dokumentacja zaktualizowana, pakiet zamrożony.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016).
- Rola AI: pełna autonomia jako **Lead Programmer** oraz **Art Director**
  (D-025, D-085, D-089, ADR-004).
- Baseline po PKG-0099: Station 01..25 mają warstwę `VectorStageEnvironment`;
  faktycznie widoczną mają 11..15 oraz 21..25. Zakotwiczenie działa w kampanii
  w Station 14, przeszkoda R1+R3 w Station 12. Łańcuch `level_completed` działa
  dla Station 01..25 z limitem 25. `tools/verify.ps1` uruchamia kontrakt
  dokumentacji, import Godota, smoke, lint przeszkód oraz bramki
  PKG-0095/0096/0097/0099.
- Weryfikacja obowiązkowa: `pwsh -NoProfile -File .\tools\verify.ps1`.

## KRYTERIA AKCEPTACJI

Patrz rozdział 5 powyżej.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0100 musi zostać zweryfikowany przez `tools/verify.ps1`, opisany
w dokumentacji projektu i zamrożony poleceniem:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0100`.
