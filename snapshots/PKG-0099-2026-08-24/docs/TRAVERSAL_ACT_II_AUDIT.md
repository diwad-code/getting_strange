# Audyt przeszkód — Akt II, Station 11..15

Status: **AUDYT PAKIETU PKG-0099**
Data: 2026-08-24
Zakres: każda przeszkoda fizyczna dodana lub zastana w Station 11..15.
Nadrzędny kanon: `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`.

Ten dokument nie twierdzi, że przeszkody są przyjemne ani zrozumiałe dla nowej
osoby. Projekt nie prowadzi playtestów zewnętrznych (D-012, ADR-003). Audyt
sprawdza wyłącznie zgodność z kanonem i z kontraktami technicznymi.

---

## 1. Stan wyjściowy i co zmienił ten pakiet

Przed PKG-0099 żadna z 43 przestrzeni kampanii nie zawierała Zakotwiczenia.
Mechanika żyła wyłącznie w `scenes/prototype/anchor_lab.tscn`. Station 11..15
miały po cztery collidery pudełka pokoju plus, w 11 i 12, schody.

Po PKG-0099:

| Przestrzeń | Przeszkoda | Rodzina | Nowa geometria grywalna |
|---|---|---|---|
| 11 | brak (scena obserwacji) | — | brak |
| 12 | nakładające się zejście, dziecko na schodach | R1 + R3 | `Geometry/EvacuationStairFlight` |
| 13 | brak (scena zagadki przedmiotowej) | — | brak |
| 14 | panel serwisowy w dwóch montażach | R1 | `Geometry/ScoredMetalPanel` |
| 15 | brak (scena poszlaki) | — | brak |

Cisza jest częścią rytmu (kanon §6). Trzy z pięciu przestrzeni świadomie nie
mają próby fizycznej.

---

## 2. Station 12 — „Pokaz bezpieczeństwa”

**Rodzina:** R1 (niezgodność wersji) niosąca R3 (trasa utrzymywana dla kogoś
innego). Kanon §6 dopuszcza jedną rodzinę na przestrzeń; tutaj R3 nie jest
osobną przeszkodą, tylko stawką tej samej przeszkody R1 — droga, która się
rozstrzyga, nie jest drogą Leny. Handoff PKG-0099 wskazał ten układ wprost.

**Test trzech pytań** (nagłówek w `scripts/levels/station_12.gd`):

1. *Dlaczego to tu jest?* — dwie wersje zejścia z podestu nakładają się w tym
   przejściu i uzgodnienie po kolei kasuje jedną z nich, podczas gdy trwa
   ewakuacja.
2. *Czego wymaga od Leny?* — utrzymać jeden bieg schodów w polu widzenia
   i dłonią przy nim, dopóki dziecko nie zejdzie na dół. Lena sama tą drogą
   nie idzie i ani razu nie musi na nią wskoczyć.
3. *Co się dzieje, gdy się nie uda?* — dziecko zostaje skorygowane przez
   przestrzeń. Z posadzki przy schodach znika ślad używania, próba wraca do
   punktu kontrolnego, a koszt zostaje zapisany w stanie kampanii.

**Implementacja.** `EvacuationStairFlight` to `AnchorableObject` o **identycznej
pozycji w obu stanach** — zmienia się wyłącznie rozpiętość biegu (48 px kontra
14 px kikuta wspornika). Bryła nie przejeżdża przez kadr ani o jeden piksel;
to jest niezgodność dwóch wersji tej samej rzeczy, a nie ruchoma platforma.
Bramka `tests/pkg_0099_smoke_test.gd` egzekwuje tę tożsamość pozycji.

**Cykl świata.** Uzgodnienie przechodzi co `CORRECTION_PERIOD` = 7 s, zapowiedziane
przez `CORRECTION_WARNING` = 2.5 s widocznej i słyszalnej zapowiedzi. Cykl
biegnie niezależnie od gracza i zatrzymuje się dopiero wtedy, gdy strażnik UCP
może domknąć przejście — czyli gdy schody są puste. Test rozstrzygający z kanonu
§2.4 („czy ta rzecz robiłaby to samo, gdyby gracza tu nie było?”) wypada na tak.

**Model porażki.** Korekta (kanon §5.1), nie śmierć. Dziecko czeka przy przerwie
`CHILD_PATIENCE` = 6 s i nie skacze ani nie spada. Po upływie cierpliwości
przestrzeń rozstrzyga się przeciwko niej: `record_decision(&"station_12_child_corrected", n)`,
`return_to_checkpoint()` cofa próbę, a warstwa stanu na stałe rysuje zbyt gładką
płaszczyznę bez śladu używania w miejscu, przez które dziecko przechodziło.
Poziom nie kończy się porażką i nie odbiera sceny.

**Budżet trudności.** Jedna decyzja, jedno okno 6 s, brak precyzji klatkowej,
brak wymaganego skoku. Zasięg interakcji biegu (78 px) pozwala trzymać go
z posadzki — Lena sięga w górę, nie wspina się.

---

## 3. Station 14 — „Zakotwiczenie”

**Rodzina:** R1 (niezgodność wersji). To jest pierwsze prawdziwe użycie
Zakotwiczenia w kampanii i miejsce, w którym fabuła nazywa mechanikę
(„trzymanie szwu”, FULL_STORY.md, scena 14).

**Test trzech pytań** (nagłówek w `scripts/levels/station_14.gd`):

1. *Dlaczego to tu jest?* — schowek techniczny istnieje w dwóch wersjach montażu
   i panel serwisowy z rysą jest w jednej z nich przykręcony jako stopień pod
   wlotem szybu, a w drugiej złożony płasko na ścianie bagażnika instalacyjnego.
2. *Czego wymaga od Leny?* — zauważyć jeden konkretny szczegół powierzchni,
   utrzymać go przy sobie mimo przejścia uzgodnienia i dopiero potem wspiąć się
   do szybu.
3. *Co się dzieje, gdy się nie uda?* — głos Jakuba na archiwalnej taśmie traci
   wyrazistość na stałe. Przedmiot użyty jako kotwica oddaje część prywatnego
   znaczenia.

**Dlaczego to nie jest ruchoma platforma.** Panel ma dwa **montaże**, nie trasę:
opuszczony stopień serwisowy (56×12 przy wlocie szybu) albo złożony płat przy
ścianie (12×60). Oba są wiarygodne dla tego samego przedmiotu w tym samym
budynku. Panel nie cyklu­je. Zmienia stan wyłącznie przy przejściu uzgodnienia,
a przejście jest zapowiedziane i wywołane tym, że Lena uruchomiła nagranie —
nie zegarem poziomu. Rozwiązanie „poczekaj aż przyjedzie i skocz” tu nie
istnieje, bo nie ma na co czekać: albo panel jest trzymany, albo nie.

**Koszt.** `_apply_anchor_cost()` obniża `tape_voice_clarity` o `ANCHOR_VOICE_COST`
= 0.55, zapisuje `station_14_anchored_scored_panel` i `station_14_tape_voice_clarity`
przez `GameStateManager.record_decision(...)` i zmienia podpis rekwizytu taśmy.
Warstwa stanu rysuje bursztynową płaszczyznę nagrania z wartością zależną od
`tape_voice_clarity`, więc utrata jest widoczna, a nie tylko zapisana.

**Model porażki.** Brak porażki karzącej. Hebel `SeamStabilizerLever` to
diegetyczne cofnięcie: dociska szew i przywraca wersję serwisową
(`restore_service_version()`). Ta przestrzeń uczy reguły i nie odbiera za nią
punktów kontrolnych.

---

## 4. Czego ten pakiet nie zrobił

- Nie rozszerzył wzorca na pozostałe 38 przestrzeni. To był świadomy zakres:
  najpierw jeden ciąg ma działać naprawdę.
- Nie dodał animacji nowych czynności (sięganie, przytrzymanie). Lena wykonuje
  je bez własnej pozy; to dług animacyjny, nie projektowy.
- Nie zmienił żadnego istniejącego collidera, `AirlockZone` ani zasięgu `Area2D`
  rekwizytu. Station 11 ma podłogę rozbitą na `GalleryFloor` i `CourtyardFloor`
  zamiast `FloorMain`; bramka PKG-0099 zapisała ten faktyczny stan jako kontrakt,
  zamiast zmieniać collidery pod wygodę testu.
- Nie udowodnił, że przeszkody są czytelne dla człowieka. `tests/pkg_0099_smoke_test.gd`
  dowodzi kontraktów: że kotwica zmienia stan, że trzymana opiera się uzgodnieniu,
  że koszt trafia do zapisu i że nagłówki trzech pytań istnieją i nie zawierają
  słowa „gracz” w zdaniu o świecie.

---

## 5. Hipotezy otwarte po tym pakiecie

- **H-0099-A:** okno 6 s cierpliwości dziecka jest wystarczające dla osoby, która
  zrozumiała regułę, i za krótkie dla osoby, która jej nie zrozumiała. Niesprawdzone.
- **H-0099-B:** utrata wyrazistości głosu na taśmie jest odczytywana jako koszt,
  a nie jako usterka dźwięku. Niesprawdzone.
- **H-0099-C:** rysunek `AnchorableObject` (nity, kratownica, wsporniki) pochodzi
  z prototypu i jest gęstszy niż reszta Rówień Vector-Stage. Kandydat do redukcji
  do 2–4 płaszczyzn w kolejnym pakiecie.
