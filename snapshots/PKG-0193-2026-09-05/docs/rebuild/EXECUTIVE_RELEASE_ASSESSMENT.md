# Raport gotowości wydania (Executive Release Assessment) — Stan po PHASE-08 i CHECKPOINT-06

Data: 2026-09-03  
Pakiet: **PKG-0178 / Handoff & Release Assessment**  
Rola: Lead Programmer & Art Director  
Status produktu: **PRODUCT GO CANDIDATE (CHECKPOINT-06 GO)**  
Status wydania: **GATE-REL BLOCKED (D-168)**  

---

## 1. Podsumowanie dla Właściciela Projektu (Executive Summary)

Dnia 2026-09-02 właściciel projektu przeprowadził sesję diagnostyczną na ówczesnym stanie runtime, identyfikując **dziewięć kluczowych defektów prezentacji, skali i czytelności** (DEF-1..DEF-9). Dotychczasowe próby zaliczania bramek opierały się na zbyt wąskich testach jednostkowych lub symulacji tekstowej, co maskowało realne wady odbiorcze gry.

W odpowiedzi uruchomiono **PHASE-08: Presentation & Comprehension Repair** (`docs/rebuild/PRESENTATION_REPAIR_PLAN.md`), obejmującą pakiety **PKG-0171 do PKG-0177**.

### Kluczowe osiągnięcia fazy:
1. **100% zamknięcie techniczne wszystkich 9 defektów właściciela** (szczegóły w rozdziale 2).
2. **Ciągły przebieg trasy 20 adresów (M1)**: Pełna kampania od ekranu tytułowego, przez dwuwarstwowe zimne otwarcie, stacje 01–18, finał 42A po epilog 43 została pokonana w **187,8 s** wyłącznie za pomocą semantycznych czasowników gracza (`move_right`, `move_up`, `interact`, `ui_accept`), bez ingerencji w stan gry czy wywołań metod pomocniczych.
3. **Zaliczenie wszystkich 14 bramek produktu**: Wszystkie bramki z `ACCEPTANCE_MATRIX.md` (8 pierwotnych + 6 nowych bramek prezentacji) mają status `TECHNICAL PASS`, w tym **GATE-01** została recertyfikowana jako **`PASS (RECERTIFIED)`** na nowym otwarciu (M5 = 28,05 s przy budżecie 90 s).
4. **CHECKPOINT-06: `GO`**: Spełniono wszystkie kryteria formalne szóstego checkpointu planu odbudowy. Zero regresji we wcześniejszych systemach.
5. **Dyscyplina D-168**: Zero nowych binariów `.exe` w drzewie projektu. Blokada release pozostaje nienaruszona do bezpośredniej dyspozycji właściciela.

---

## 2. Zestawienie naprawy 9 defektów z 2026-09-02

| ID | Zgłoszony defekt | Rozwiązanie techniczne i artystyczne | Kluczowy dowód |
|---|---|---|---|
| **DEF-1** | Brak intra; gracz nie wie, kim jest ani czym są drgania | Wdrożono **zimne otwarcie w 2 warstwach** (PKG-0176):<br>• **Warstwa A** (`scenes/shell/cold_open.tscn`): 3 ujęcia kinowe (nocne torowisko Linii 4, sylwetka Leny, zapis drgań z 3-sekundową płaską luką archiwalną).<br>• **Warstwa B** (`Station01`): wymuszony pomiar wstępny na aparaturze roboczej przed rozwidleniem.<br>5 faktów tożsamości i celu podane w diegezie bez promptów UI. | `tests/pkg_0176_smoke_test.gd`, M5 = 28,05 s, GATE-INTRO TECHNICAL PASS, GATE-01 RECERTIFIED. |
| **DEF-2** | Portret Marty to przemalowany portret Leny | Wdrożono **unikalny portret 1024×1024** (`assets/characters/portraits/marta.png`) o odmiennej konstrukcji anatomicznej, fryzurze (długie różowe włosy) i biżuterii (septum), całkowicie odrębny od Leny (PKG-0172). Skrypt modyfikujący został wycofany do `tools/retired/`. | `tests/pkg_0172_smoke_test.gd`, kadr `reports/pkg_0172/portrait_marta_display.png`. |
| **DEF-3** | NPC to kółka i trapezy 22–48 px zamiast 84–92 px | Utworzono uniwersalny komponent **`CharacterVisualRig`** (`scripts/characters/character_visual_rig.gd`) na płótnie 64×104 px z pivotem (32, 96), nearest-neighbor i 7 stanami ekspresji (PKG-0172). Zastąpiono figury geometryczne kompletnymi zestawami sprite'ów w stałej skali 1 m dla Marty, Jakuba i Wierzbickiej. | `tests/pkg_0172_smoke_test.gd`, kadry `reports/pkg_0172/station_10_marta.png`, `station_11_wierzbicka.png`, `station_12_jakub.png`. |
| **DEF-4** | Wejścia to marsz w prawo w niewidzialny `AirlockZone` | Zaimplementowano komponent **`ThresholdZone`** (`scripts/environment/threshold_zone.gd`) ze zdefiniowaną aperturą `aperture_rect` i trzema rodzinami (DOOR, VEHICLE, HATCH) (PKG-0174). Wejście wymaga świadomego klawisza `interact` i odtwarza animację przekraczania (`enter_door`, `board_vehicle`). `AirlockZone` zredukowano do strefy domknięcia. | `tests/pkg_0174_smoke_test.gd`, kadry `reports/pkg_0174/threshold_*.png`. |
| **DEF-5** | Potykanie i przysiad na każdym stopniu schodów | Opracowano procedurę **`try_curb_step()`** w kontrolerze gracza (PKG-0173). Zamiast stałego skoku o 18 px, system mierzy rzeczywistą wysokość podstopnicy i płynnie interpoluje ruch w 0,18–0,24 s. Flaga `_stepping` blokuje kompresję lądowania (squash/stretch), kurz oraz stany upadku. | `tests/pkg_0173_smoke_test.gd`, trace ruchu na stacji 08 bez efektu potknięcia. |
| **DEF-6** | Drabina narysowana 62 px obok strefy; brak widoku od tyłu | **`LadderZone` stał się jedynym źródłem grafiki i kolizji drabiny** (PKG-0173). Usunięto rozbieżne rysunki proceduralne w `station_02.gd`, `15.gd` i `16.gd`. Wprowadzono animację `climb_back` pokazującą plecy Leny. Wspinaczka wymaga zatrzymania i intencji (`interact` lub `move_up`), eliminując przypadkowe zaczepianie. | `tests/pkg_0173_smoke_test.gd`, kadr `reports/pkg_0173/station_02_service_ladder.png`. |
| **DEF-7** | Drzwi 170–180 × 18–24 px przy kanonie 109 × 42–48 px | **Ujednolicono skalę wszystkich otworów** na trasie 20 adresów per `WORLD_SCALE.md` §3 (PKG-0174): drzwi 109×45 px, pojazdy 105×58 px, włazy 64×64 px. Zsynchronizowano kształty kolizyjne `ExitDoors`, `TransitDoor`, `BuildingEntranceDoor` i `ApartmentDoor14`. | `tests/pkg_0174_smoke_test.gd`, weryfikacja colliderów na stacjach 01, 02, 03, 04, 07, 08, 12. |
| **DEF-8** | Twarde bramkowanie wyjścia w 18 stacjach | Wprowadzono architekturę **`GapLedger`** (`scripts/campaign/gap_ledger.gd`) i zasadę otwartego wyjścia od `_ready()` (PKG-0175). Gracz może opuścić stację w dowolnym momencie; pominięcie odczytów diegetycznych otwiera „lukę” w świecie, komentowaną przez głos wewnętrzny Leny, zamiast fizycznego ryglowania drzwi. | `tests/pkg_0175_smoke_test.gd`, przejście minimalne bez odczytów dochodzi do finału. |
| **DEF-9** | Brak fizycznej obsady na trasie 20 stacji | Osadzono postacie w diegetycznych rolach na trasie (PKG-0172 / D-194): Marta Kurek w Station 10 i 42B/C, dr Helena Wierzbicka (w pozycji siedzącej) w Station 11, Jakub Wolski (przy stole roboczym) w Station 12. Budżet GATE-INT ≤ 3 pozostał nienaruszony. | `tests/pkg_0172_smoke_test.gd`, obecność węzłów NPC z `CharacterVisualRig` w drzewach scen. |

---

## 3. Status 14 bramek produktu i werdykt CHECKPOINT-06

Wszystkie 14 bramek produktu zostało zweryfikowanych w jednym zintegrowanym przebiegu testowym `tests/pkg_0177_smoke_test.gd`:

1. **GATE-01 (Tożsamość i cel, 1 min)**: `PASS (RECERTIFIED)` — M5 = 28,05 s w symulacji (limit: 90 s). Wszystkie 5 faktów tożsamości i celu ustalone przed pierwszym rozwidleniem.
2. **GATE-05 (Rozpoznanie świata, 5 min)**: `PASS` — Trasa stacji 01–04 przechodzona czystymi czasownikami gracza; 3 różne rodziny lokacji; brak przemocy i platformingu arcade.
3. **GATE-30 (Zrozumienie obcości, 30 min)**: `PASS` — 4 niezależne źródła sprzeczności (rozkład, zegar, kiosk, domofon/sąsiadka) na stacjach 01–08; Lena dociera do mieszkania 14 bez skakania.
4. **GATE-FAM (7 rodzin lokacji)**: `TECHNICAL PASS (7/7)` — Odrębne profile architektoniczne, apertury i palety. 7 monochromatycznych kadrów M3 bez tekstu/UI wykazuje 7 unikalnych hashy strukturalnych.
5. **GATE-OBJ (Jawny zamiar gracza)**: `TECHNICAL PASS` — Próbkowanie co 2 minuty i na każdej stacji (21 próbek, 100% zgodności w `gate_obj_samples.tsv`). Ruch w prawo/w górę, brak otwartego menu.
6. **GATE-INT (Budżet interakcji)**: `TECHNICAL PASS (20/20)` — Wszystkie 20 stacji posiada ≤ 3 kluczowe punkty interakcji.
7. **GATE-MECH (Mechaniki Anchor/Yield)**: `TECHNICAL PASS` — Lekcja martwego obwodu (14), test sygnału (15), analizator (16), rejestr zgody (17), zatwierdzenie metody (18).
8. **GATE-FIN (Finały i domknięcie)**: `TECHNICAL PASS` — Rozgałęzienie 18 → 42A/B/C → 43 epilog. Brak moralnego wartościowania wyborów; domknięcie ewidencji nad Wisłą.
9. **GATE-INTRO (Zimne otwarcie)**: `TECHNICAL PASS` — Warstwa A kinowa + Warstwa B pomiarowa; brak spoilerów, luki archiwalnej dokładnie 3 sekundy; reduced motion zachowuje fakty.
10. **GATE-CAST (Postacie i portrety)**: `TECHNICAL PASS` — Stała skala 64×104, `CharacterVisualRig`, unikalny portret Marty, obecność w stacjach 10, 11, 12, 42.
11. **GATE-THRESH (Progi i przejścia)**: `TECHNICAL PASS` — `ThresholdZone` z aperturą; wejście wymaga `interact`; brak przekraczania colliderów przez samo potknięcie.
12. **GATE-SCALE (Jednolita skala 1 m = 54 px)**: `TECHNICAL PASS` — Apertury drzwi, wagonów i włazów zgodne z kanonem skali; jednolity rysunek drabin.
13. **GATE-FLOW (Ciągła przechodniość)**: `TECHNICAL PASS` — Wszystkie 20 wyjść otwartych od `_ready()`; mechanika `GapLedger` eliminuje softlocki.
14. **GATE-ANIM (Animacje trawersu)**: `TECHNICAL PASS` — Krawężnikowe pokonywanie stopni bez przysiadu i squash/stretch; drabina z widokiem pleców.

**Werdykt Checkpointu 06**: **`GO`**.  
Status techniczny: **`TECHNICAL PASS`**.  
Status produktowy: **`PRODUCT GO CANDIDATE`**.

---

## 4. Ograniczenia dowodowe i analiza ryzyk (D-012, ADR-003, H-048..H-050)

Zgodnie z zasadami projektu (`AGENTS.md`) automatyczne testy techniczne dowodzą poprawności działania systemów w silniku, ale **nie stanowią dowodu subiektywnych odczuć ludzkich**:

1. **Hipoteza H-048 (Odbiór fabularny przy pomijaniu treści)**:
   - *Dowiedziono*: Gracz może przejść całą grę bez badania opcjonalnych rekwizytów (20/20 wyjść jest otwartych).
   - *Pozostaje hipotezą*: Czy gracz pomijający większość treści nadal odczuwa sens i wagę finałowych wyborów?
2. **Hipoteza H-049 (Zrozumienie tożsamości i drgań w otwarciu)**:
   - *Dowiedziono*: Wszystkie 5 faktów tożsamości zostaje zaprezentowanych w pierwszych 28 sekundach bez użycia tekstu w UI.
   - *Pozostaje hipotezą*: Czy osoba grająca po raz pierwszy bez zewnętrznej wiedzy natychmiast połączy obserwowane drgania z anomalną naturą świata?
3. **Hipoteza H-050 (Czytelność nastroju 7 rodzin lokacji)**:
   - *Dowiedziono*: Analiza monochromatycznych kadrów M3 potwierdza unikalność kompozycji geometrycznych każdej z 7 rodzin.
   - *Pozostaje hipotezą*: Czy stylizacja wektorowo-pikselowa wywołuje zamierzony nastrój obcości i klaustrofobii w subiektywnym odbiorze?
4. **Brak playtestów zewnętrznych**:
   - Zgodnie z ADR-003 i D-012 projekt nie opiera się na zewnętrznych grupach fokusowych. Wszelkie twierdzenia o „frajdzie”, „emocjonalnej głębi” czy „impresji” pozostają świadomymi założeniami autorskimi.

---

## 5. Status bramki wydania (GATE-REL) i decyzja właściciela

Zgodnie z regułą **D-168**:
> *Wydanie nowego pliku wykonywalnego `.exe` oraz zmiana statusu bramki GATE-REL pozostają zablokowane do momentu uzyskania jednoznacznej, pisemnej instrukcji właściciela.*

### Rekomendacje zespołu projektowego (Lead Programmer & Art Director):

Projekt znajduje się obecnie w najwyższym stanie spójności technicznej i prezentacyjnej w swojej historii. Właściciel ma do wyboru trzy ścieżki:

* **Ścieżka A (Pełne otwarcie Release Candidate)**:
  Właściciel wydaje polecenie: `Zdejmij blokadę D-168, zbuduj GettingStrange.exe i zamknij GATE-REL`.
  *Kroki*: Wykonanie eksportu w presetach Windows x64 per `export_presets.cfg`, weryfikacja clean-install i przygotowanie archiwum dystrybucyjnego.

* **Ścieżka B (Sesja weryfikacyjna Właściciela przed wydaniem — Rekomendowana)**:
  Właściciel osobiście uruchamia projekt bezpośrednio w silniku (`tools/run.ps1` lub edytorze Godot 4.7.2), aby ocenić nowe zimne otwarcie, animacje schodów, portret Marty i działanie `ThresholdZone`. Po osobistej akceptacji wydaje dyspozycję budowy `.exe`.

* **Ścieżka C (Runda mikro-szlifu audio/wizualnego przed RC)**:
  Przeznaczenie jednego pakietu (PKG-0179) na dodatkowe wzbogacenie proceduralnego tła dźwiękowego (soundscape pass) dla stacji 14–18 przed finalnym zamrożeniem binarnego wydania.
