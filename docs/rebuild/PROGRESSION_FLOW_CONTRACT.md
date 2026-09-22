# Kontrakt ciągłej przechodniości trasy

Status: **WDROŻONY KONTRAKT POSTĘPU — D-192 (PKG-0175 / GATE-FLOW TECHNICAL PASS)**
Data: 2026-09-02
Nadrzędne: `docs/rebuild/PRESENTATION_REPAIR_PLAN.md` (DEF-8)
Powiązane: `docs/rebuild/PLAYER_CONTRACT.md`, `docs/rebuild/CAMPAIGN_MAP.md` §2,
`docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md`, `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` §7.6

---

## 1. Zasada nadrzędna

> **Droga dalej jest zawsze otwarta. Zamyka się dopiero to, co próbujesz
> zrobić bez tego, czego nie sprawdziłaś.**

Decyzja właściciela z 2026-09-02:

> „Przejście do następnej lokacji zawsze powinno być możliwe — po prostu
> niewykonanie odczytów miejsc interaktywnych zablokuje jakąś czynność w
> przyszłości i gracz będzie musiał się wrócić.”

To nie jest ułatwienie. To **przeniesienie kosztu z drzwi na konsekwencję**.
Gracz zawsze idzie dalej; płaci później, świadomie i w miejscu, gdzie widzi za co.

---

## 2. Dlaczego to jest zgodne z resztą projektu, a nie wbrew niej

Trzy niezależne argumenty, żeby następny model nie próbował tego „poprawić”:

1. **Dwukierunkowość jest już kontraktem gracza.** D-124 wymaga `ReturnZone`
   w każdym adresie 02–43 i wszystkie ją mają. Ten kontrakt wreszcie daje
   powrotowi powód istnienia — dziś nie ma po co wracać, bo nie da się wyjść
   bez kompletu.
2. **To jest łuk Leny.** `PLAYER_CONTRACT.md` §1: *„Czego potrzebuje (nie wie
   o tym) — działać uczciwie przy niepełnej wiedzy”*. Gra, która nie pozwala
   ruszyć się bez kompletu danych, uczy czegoś dokładnie odwrotnego.
3. **Precedens jest w runtime.** `station_43.gd` ma pełną ścieżkę `unseeded`
   (linie 50–51, 133, 139): epilog działa i czyta się sensownie, gdy metoda nie
   została wybrana. Ten sam wzorzec skaluje się na całą trasę.

---

## 3. Taksonomia zdarzeń w adresie

Każda rzecz, którą gracz może zrobić, należy do dokładnie jednej kategorii.

| Kategoria | Definicja | Czy blokuje wyjście |
|---|---|---|
| **Odczyt** (`reading`) | interakcja, która zapisuje fakt: rozkład, dziennik, wiadomość, ledger, panel | **Nigdy** |
| **Wymiana** (`exchange`) | rozmowa z osobą, która zmienia relację albo zgodę | **Nigdy** |
| **Czynność progowa** (`threshold`) | samo wejście / wyjście z adresu (`ThresholdZone`) | jest wyjściem, więc zawsze dostępna |
| **Rozstrzygnięcie** (`commitment`) | wybór, który *jest* drogą — rozwidlenie trasy | dostępne zawsze; wybór to kierunek, nie nagroda |

**Reguła twarda:** na trasie 20 adresów istnieje dokładnie **jedno**
rozstrzygnięcie — Station 18 (`method_committed` → 42A/B/C). Wszystko inne w
01–17 to odczyty i wymiany, więc nic w 01–17 nie może blokować drzwi.

Station 18 nie łamie zasady, bo tam wybór **jest** czynnością progową: Lena
zatwierdza metodę i tym samym wychodzi. Może to zrobić z lukami w wiedzy —
i to jest dokładnie temat gry.

---

## 4. Luka (`gap`) — model danych

### 4.1 Definicja

Luka powstaje w chwili, gdy gracz **opuszcza adres** bez wykonania odczytu,
który ma zdefiniowaną konsekwencję później.

Nie powstaje dla odczytów czysto barwiących świat. Jeśli odczyt nie ma
konsekwencji, nie jest luką — jest tłem i nie zasługuje na komentarz.

### 4.2 Rekord

Rejestr żyje w `GameStateManager` obok `decisions`, np. `open_gaps: Dictionary`.

| Pole | Typ | Treść |
|---|---|---|
| `gap_id` | StringName | np. `&"s03.departure_unread"` |
| `origin_station` | StringName | gdzie da się ją zamknąć |
| `blocks` | Array[StringName] | identyfikatory czynności, które bez niej nie ruszą |
| `thought_pl` / `thought_en` | String | jedna linia głosu wewnętrznego |
| `opened_at_station` | StringName | gdzie gracz ją otworzył (do telemetrii testów) |

Luka zamyka się w momencie wykonania brakującego odczytu — także po powrocie.
Zamknięcie jest ciche: bez fanfary, bez „Zadanie ukończone”.

### 4.3 Skąd wziąć listę luk — nie wymyślaj jej

Graf zależności **już istnieje w kodzie** jako wartości
`safe_trial_feedback`. Każde `_record_feedback(&"...")` w
`scripts/levels/station_*.gd` jest zapisaną odpowiedzią na pytanie „czego
brakuje”. Przykłady z runtime:

| Adres | Feedback w kodzie | Luka |
|---|---|---|
| station_03 | `route_time_required` | `s02.route_time_unread` |
| station_03 | `departure_required` | `s03.departure_unread` |
| station_03 | `marta_reply_required` | `s03.marta_unanswered` |
| station_01 | `measurement_required` | `s01.measurement_unrepeated` |
| station_01 | `choice_already_committed` | nie jest luką — to domknięty wybór |

Wykonaj przegląd wszystkich `_record_feedback` na trasie i przepisz je jeden do
jednego na luki. To jest praca mechaniczna, nie projektowa.

---

## 5. Zachowanie czynności zablokowanej przez lukę

Czynność zablokowana **nigdy nie milczy i nigdy nie kończy przebiegu**.

| Musi | Nie wolno |
|---|---|
| Nazwać, czego brakuje, słowami Leny | Pokazać kodu błędu ani nazwy flagi |
| Wskazać miejsce, nie współrzędne („na przystanku”, nie „Station 03”) | Otworzyć dziennika zadań ani mapy |
| Zostawić czynność dostępną do ponowienia | Zużyć czynność bezpowrotnie |
| Pozwolić grze toczyć się dalej | Softlockować, cofać, resetować |

Jeśli zablokowana czynność jest jedyną drogą dalej — **projekt jest zły**.
Poprawka nie polega na dodaniu obejścia, tylko na przeniesieniu tej czynności
z kategorii `reading` do `threshold` albo na usunięciu zależności.

---

## 6. Głos wewnętrzny — jak Lena o tym mówi

### 6.1 Użyj istniejącego systemu

`NarrativeGuidanceService` + `GuidanceBeat` + `InnerThoughtSurface` są w
runtime i mają już wszystko, czego to wymaga:

- pięć poziomów `L0_COMPOSITION` … `L4_RESCUE_HINT`;
- cooldown minimum 8 s, jedna myśl naraz;
- postęp w scenie resetuje licznik zastoju;
- aktywny dialog CRT wstrzymuje głos wewnętrzny (myśl i dialog nigdy nie dzielą
  kadru).

**Nie buduj drugiego systemu podpowiedzi.**

### 6.2 Kiedy Lena mówi o luce

| Moment | Poziom | Przykład |
|---|---|---|
| Przy wyjściu z adresu z otwartą luką | `L1_REACTION` | „Powinnam jej odpisać.” |
| Przy próbie czynności zablokowanej luką | `L2_CONTEXTUAL_THOUGHT` | „Nie sprawdziłam, o której to odjeżdża. Bez tego nie wiem, co jej napisać.” |
| Po zastoju z otwartą luką blokującą | `L3_DIRECTIONAL_THOUGHT` | „Muszę wrócić na przystanek.” |
| Nigdy | `L4_RESCUE_HINT` | poziom systemowy zostaje dla awarii, nie dla luk |

### 6.3 Ton

`PLAYER_GUIDANCE_AND_INNER_VOICE.md` obowiązuje bez zmian. Dodatkowo:

- myśl o luce jest **obserwacją albo zamiarem**, nigdy instrukcją dla gracza
  („Naciśnij E” jest zakazane);
- Lena może się mylić co do tego, co przeoczyła — `truth_scope = "fallible"`
  jest dozwolony i pożądany;
- jedna luka = **jedna linia**. Nie zestaw. Nie lista.
- gdy luk jest kilka, mówi o tej, która blokuje najbliższą czynność.

Przykłady zgodne z sugestią właściciela: „Powinnam odpisać.”, „Chyba o czymś
zapomniałam?”, „Nie powinnam była tego zostawiać.”, „Wrócę tam, jak zdążę.”

---

## 7. Zmiany techniczne, których to wymaga

1. **`_unlock_exit()` znika jako brama.** 18 adresów liniowych woła je dziś
   warunkowo (01–13 po trzy wywołania, 14–18 po dwa). Wyjście jest odblokowane
   od `_ready()`.
2. **`TransitDoor` / `ChamberDoor` przestają być zamkiem.** Zostają jako
   fizyczne skrzydło otwierane animacją wejścia (`THRESHOLD_AND_ENTRY_CONTRACT.md` §3.1),
   a nie jako bryła podnoszona o 140 px przez `ExitClearance.open_body()`.
3. **`OpeningActionPoint.set_available(false)`** przestaje ukrywać czynność.
   Czynność jest widoczna i wykonywalna; jeśli brakuje przesłanki, zwraca
   komunikat Leny wg §5.
4. **Nowy rejestr luk** w `GameStateManager` + migracja zapisu. Save z
   poprzedniej wersji musi się wczytać (istnieje już mechanizm migracji).
5. **Ścieżki wariantowe finałów.** 42A/B/C wymagają dziś konkretnego
   `method_committed` na wejściu. To zostaje — Station 18 zawsze coś zatwierdza
   (§3). Sprawdzić i udokumentować, co się dzieje, jeśli save z luką trafi do
   finału bez metody: musi zadziałać ścieżka `unseeded` jak w Station 43.

---

## 8. Bramka GATE-FLOW — jak to udowodnić

| Test | Metoda | Próg |
|---|---|---|
| Przebieg minimalny: `Nowa gra` → Station 43 **bez wykonania ani jednego odczytu opcjonalnego**, wyłącznie ruch, czynności progowe i rozstrzygnięcie 18 | M1 | kończy się epilogiem, zero softlocków |
| Przebieg pełny: wszystkie odczyty | M1 | kończy się epilogiem, zero luk otwartych |
| Przebieg mieszany: pominąć trzy odczyty, wrócić i zamknąć dwa | M1 | obie luki zamykają się po powrocie, trzecia daje udokumentowaną konsekwencję |
| Statyczny audyt wyjść | M4 | 20 z 20 adresów ma wyjście odblokowane od `_ready()` |
| Audyt luk | M4 | każda luka ma `thought_pl`, `blocks` i osiągalny `origin_station` |

Bramka **nie** dowodzi, że gracz zrozumie, po co ma wracać. To jest hipoteza
odbiorcza i pozostaje bez dowodu (D-012, ADR-003).

---

## 9. Ryzyko, które trzeba trzymać na oku

| Ryzyko | Odpowiedź |
|---|---|
| Gracz przechodzi całą grę, nie czytając niczego, i nie rozumie fabuły | To jest jego wybór, ale narracja główna musi nieść się na czynnościach progowych i rozstrzygnięciu, nie na odczytach. Sprawdzić przy przebiegu minimalnym, czy historia jeszcze się klei. |
| Luki mnożą się i głos wewnętrzny gada bez przerwy | Cooldown 8 s, jedna myśl naraz, mówi tylko o luce blokującej najbliższą czynność |
| Powrót przez `ReturnZone` jest nudny | Adres po powrocie może mieć zmieniony jeden fakt (rodzina „znane miejsce po zmianie” jest już w kanonie) |
| Ktoś przywróci twarde bramkowanie „bo tak jest bezpieczniej” | Ten dokument i D-192 są odpowiedzią. Zmiana wymaga nowej decyzji właściciela. |
