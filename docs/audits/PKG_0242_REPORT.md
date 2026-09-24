# PKG-0242 — gotowość do premiery: ukończalność, interakcja, powłoka wydania i rozliczenie bramek

Data: 2026-09-24. Gałąź: `claude/vigilant-brahmagupta-eq594t` (od `ea61916`, merge PKG-0241).
Zlecenie właściciela: jako Lead Programmer i Art Director doprowadzić grę do stanu
gotowości do publicznej premiery, tak by „wszystko się zgadzało”.
Zakres (AGENTS.md, D-251): tylko gra Godot 4.7; bez stron WWW (D-098), bez wydania
i nowych `.exe` (D-168), bez usuwania dowodów historycznych i bez osłabiania testów
dla uzyskania PASS. Treść fabularna PKG-0239 (PROMPT_WDROZENIA_POPRAWEK) jest
nadrzędna wobec starych pinów tekstu.

To jest raport techniczny. Automatyczne bramki dowodzą kontraktów, nie odbioru,
zabawy ani zrozumienia (D-012, ADR-003). PRODUCT GO pozostaje decyzją właściciela.

## 1. Wynik w skrócie

- Kampania jest **ukończalna wyłącznie wejściem gracza** na wszystkich trzech
  zakończeniach (A: wymuszenie domu, B: odzyskanie i zamknięcie, C: przejście
  wzajemne): bramka M1 `pkg_0177` przechodzi 01 → 18 → 17 → 18 → 42A/B/C → 43
  semantycznymi akcjami InputMap, bez wywoływania czasowników stacji.
- Wszystkie 22 adresy trasy są **fizycznie przechodnie** spawn → wyjście → powrót
  (nowa bramka `pkg_0242`).
- 39 historycznych bramek przepięto na łańcuch zgody PKG-0239 i tekst właściciela
  z zachowaniem intencji każdej asercji (sekcja 4); żadnej asercji nie usunięto
  bez zastąpienia kontraktem o tym samym celu.
- Pełna `tools/verify.ps1 -AudioDriver Dummy` (Linux, Godot 4.7.2): wynik w sekcji 6.

## 2. Naprawy gry

### 2.1 Ukończalność i trasa (commit `f1d9490`)

| Obszar | Defekt | Naprawa |
| --- | --- | --- |
| 14 | Obudowa maszyny 60 px między Leną a wyjściem, skok ~44 px (D-123) | cokół 260×18 pod maszyną (`station_14.tscn`), zasięg mostu 72 px |
| Kilka stacji | Dwa punkty odczytu w zasięgu: naciśnięcie trafiało do węzła ostatniego w drzewie (10: rozmowa z Martą nieosiągalna z naturalnego miejsca) | `InteractionFocus`: naciśnięcie trafia do najbliższego punktu w zasięgu; tylko on pokazuje sygnał kontaktu |
| 01 i dialogi | `interact` przewijał dialog i jednocześnie uruchamiał punkt | przewijanie CRT w `_input`, przed punktami |
| 16–18, 42, 43 | Otwory wyjść stały na wysokości podłogi, której scena już nie ma | `ThresholdBinder.floor_top_at` — otwór na rzeczywistej podłodze pod wyjściem |
| 16 | Wybór kosztu przy środku selektora był rzutem monetą | martwa strefa ±10 px z podpowiedzią i legendą stron |
| 17/18 | Wybory stroną nie miały legendy; 18 miała uszkodzony nagłówek przeszkody | legendy (prośba do Jakuba / jego odpowiedź; dla Marty / klucz Marty), przywrócony nagłówek PRZESZKODA |
| 17/18 | Ponowne wejście otwierało zamknięte hipotezy, ponowne porównanie prognoz zapisywało fakt drugi raz | zamknięcie hipotez przy odtworzeniu, zapis dokładnie raz (D-244) |
| 42A/B/C | Otwarcia mówiły o „zatwierdzeniu” sprzed PKG-0239 | noc przy słupku = wybór, świt = wykonanie (zgodnie z łańcuchem PKG-0239) |

### 2.2 Priorytet interakcji i komunikaty w pokoju (commity `907fd6d`, `b8e3d10`)

- Otwarte drzwi (D-227) brały każde naciśnięcie w swoim zasięgu, więc strona
  „przejście wzajemne” słupka w 18 była praktycznie nieużywalna (pas 12 px).
  `ThresholdZone` ustępuje punktowi odczytu, **który ma jeszcze coś do zrobienia**
  (D-228: MRP > Threshold; `is_point_actionable` / `_is_resolved`). Po
  zatwierdzeniu metody drzwi znów wygrywają; przy powrocie do 17 biurko Jakuba
  zatrzymuje naciśnięcie, dopóki Jakub nie odpowiedział.
- Każdy punkt ma własną kopię `CircleShape2D` (sceny współdzieliły zasób, więc
  zmiana promienia jednego punktu zmieniała wszystkie).
- Zasięgi: biurko 17 i stół 18 — 56 px, słupek 18 — 72 px. Każda strona wyboru
  to pas 40 px (było 12–28 px); każde wyjście zachowuje odcinek wolny od punktów.
- Drzwi, których stacja jeszcze nie może użyć (18 bez zatwierdzonej metody,
  niedokończony finał, 43 przed ostatnim zapisem czytnika), odmawiają **przed** animacją wejścia i Lena mówi, czego
  brakuje (`forward_block_line`, `GapLedger.say`). Wcześniej Lena wchodziła
  w drzwi i zostawała w progu bez słowa.
- Punkt naciśnięty przed swoim poprzednikiem w tym samym pokoju nazywa ten
  poprzednik (`CreativeSceneLines.STEP_PREREQS`), zamiast odsyłać do
  „wcześniejszego źródła” pod innym adresem. Linia CRT zastępuje myśl luki
  z tej samej klatki (myśli luk są sformułowane jako żal po wyjściu).
- Ponowne naciśnięcie słupka przy tej samej metodzie mówi tylko, czego brakuje,
  zamiast odtwarzać dziesięć linii prognozy.

### 2.3 Błędy runtime

- **16, powrót przez ReturnZone**: `_ready` porównywał zapisany tekst
  `living_response_loaded` z `true`, co w Godot 4 jest błędem skryptu; reszta
  odtwarzania stanu (koszt, echo domu, legenda, strefa wyjścia) nie wykonywała
  się. Naprawione; bramka `pkg_0242` otwiera ponownie wszystkie adresy po każdym
  z trzech ukończonych łańcuchów (błąd łapie polityka logu verify).
- **05**: ślad `p7.return_under_control.trace` mówi teraz, co Lena zrobiła:
  sprawdziła torbę przed przejściem albo po prostu przeszła (torba opcjonalna od PKG-0239).
- **43**: usunięto trzy nieużywane po PKG-0239 funkcje klauzul wypłaty; taśma
  zamknięcia linii (gałąź A) przeniesiona z lewego słupa, przy którym Lena
  zaczyna scenę i który przecinał jej głowę, na prawy słup wiaty.

### 2.4 Powłoka wydania

- Menu pauzy: WZNÓW, RESTART SCENY, USTAWIENIA, MENU GŁÓWNE, RESET ZAPISU.
  Tryb testowy tylko w powłoce deweloperskiej (`GameStateManager.is_developer_shell()`:
  build debug bez `GS_RELEASE_SHELL=1`), w osobnym wierszu. Status wydania:
  „ODWIEDZONE ADRESY: n/20”; stopka z faktycznie przypisanymi klawiszami.
- Menu główne: **TWÓRCY I LICENCJE** — panel z prawami autorskimi gry, licencją
  MIT Godota, listą komponentów stron trzecich i pełnymi tekstami licencji
  czytanymi z działającego silnika (`Engine.get_license_text`,
  `get_copyright_info`, `get_license_info`), więc zawsze zgodnymi z silnikiem eksportu.
- Etykieta wersji: „WERSJA 1.0.0”; podpowiedź CRT: „DALEJ [klawisz]”
  z bieżącego przypisania `interact`; nazwy miejsc zamiast identyfikatorów.
- 43: poranny przystanek z tablicą ogłoszeń i skrótem twórców („LICENCJE: MENU
  GŁÓWNE”) zamiast technicznego manifestu licencji w świecie gry.

## 3. Czego nie zmieniono

Treść fabularna właściciela z PKG-0239 (łańcuch zgody, teksty 13–18, 42, 43) —
poza otwarciami 42A/B/C dopasowanymi do jego kolejności wybór → wykonanie
i komunikatami kroków (2.2). Stacje legacy 19–41, geometria przeszkód, 640×360,
60 Hz, InputMap, zapis gry.

## 4. Rozliczenie bramek (R1/R2)

Zasada (D-252): stary pin opisujący stan, którego gracz nie może już osiągnąć
po PKG-0239, jest przepinany na osiągalny stan i tekst właściciela; intencja
asercji zostaje. Seed ręcznie wpisanych faktów zastąpiono `tests/support/campaign_chain.gd`:
zapis stanu z prawdziwej rozgrywki 01–16 (`campaign_state_before_17.json`) +
prawdziwe sceny 17 → 18 → 17 → 18 i te same wywołania zwrotne, których używa
prezenter rozmów.

| Bramka | Co było nieaktualne | Przepięcie (intencja zachowana) |
| --- | --- | --- |
| smoke, 0147, 0165, 0166, 0120 | ręczne seedy zgody i metody; podwójny zapis prognoz | łańcuch 17/18; odrzucenie oferty i zamknięcie rozmowy jak w grze |
| 0177 (M1) | przebieg bez rozmów 17/18 | pełny łańcuch wejściem dla A, B i C (strony biurka, stołu, słupka, klucz Marty) |
| 0107, 0150, 0151, 0167–0170 | finały z nieosiągalnymi kombinacjami, stara kolejność 42B | łańcuch; 42B: start → odpowiedź miejscowej → zamknięcie; piny epilogu na tekście PKG-0239 |
| 0138 | jedno przejście przez 17 i 18 | powrót 18 → 17 odegrany przez `CampaignChain`, zakres przy biurku |
| 0175 | ręczne fakty 17 | wejścia 17 (dawca) + łańcuch na żywo; luka opcjonalna 05 nic nie blokuje |
| 0113, 0115, 0153, 0159 | stary format podpowiedzi/etykiety | „DALEJ [%s]”, wersja, powierzchnia wydania (`release_surface_contract.gd`) |
| 0146, 0196 | ślad 05, linie otwarcia sprzed PKG-0239 | ślad zależny od torby; linie właściciela |
| 0163 | zakaz słowa „Wierzbicka” w 15 | nazwisko dozwolone, bo 11 przedstawia ją wcześniej na trasie (sprawdzane) |
| 0194 | jednoprzebiegowy wybór metody | dwie wizyty, bieg D dla przejścia wzajemnego z kluczem Marty, 7 winiet |
| 0195 | seedy, kolejność 42B, „świeża kamera” | łańcuch; odtworzony finał nie odtwarza winiety (odtwarzanie stanu z PKG-0239), rozmowy wracają |
| 0217, 0223, 0225, 0226, 0237, 0238 | piny tekstu sprzed PKG-0239 | kontrakty na tekście właściciela; odwrócone przez właściciela reguły (Wierzbicka recytująca „Stan:”, „ktoś przerwał”) pilnują teraz reguły właściciela |
| 0222, 0230, 0232, 0233 | ręczne seedy, `commit_*` bez odpowiedzi Jakuba | łańcuch; odmowa nadal blokuje wszystkie metody, dwa kroki słupka, migawka D2, wypłata D5 tylko dla osiągalnych łańcuchów |
| 0180, 0182–0184 | „projekt bez gita” (D-016), wymóg istnienia `dist/` | D-251: git jest zapisem; wymagane presety eksportujące do `dist/` i `dist/` poza kontrolą wersji; liczba obiektów soak mierzona po wygaśnięciu krótkich tweenów |
| 0207, 0212 | liczniki | +1 bramka (131/130/129/129); helper `narrative_repair_rules.gd` z PKG-0239 (3 → 4) |

## 5. Nowa bramka `tests/pkg_0242_route_traversal_test.gd`

1. 22 adresy: spawn → wyjście → powrót samymi akcjami ruchu (drabiny: stop + góra/dół);
   otwór wyjścia stoi na podłodze.
2. Każde wyjście ma odcinek wolny od punktów odczytu.
3. Strony wyborów 16/17/18 to pasy ≥ 30 px.
4. W drzwiach 18 słupek bierze naciśnięcie przed zatwierdzeniem, drzwi po nim.
5. Drzwi 18 bez metody i drzwi 43 przed epilogiem odmawiają bez animacji i mówią, czego brakuje.
6. 17: oferta przed rejestrem nazywa rejestr.
7. Punkty zachowują własne promienie.
8. Ponowne otwarcie wszystkich adresów po każdym z trzech zakończeń.

Asercje 4 i 5 sprawdzono też w trybie odwrotnym (wyłączone ustępowanie drzwi → FAIL).

## 6. Weryfikacja

Środowisko: Linux, Godot 4.7.2.stable, `--headless --audio-driver Dummy`, Xvfb
(renderer programowy) dla kadrów. To nie jest profil Windows/WASAPI właściciela.

- Izolowane uruchomienia wszystkich 129 bramek z `verify.ps1` (osobne katalogi
  użytkownika, 4 równolegle): wszystkie PASS po poprawkach tego pakietu.
- Pełna `pwsh -NoProfile -File tools/verify.ps1 -AudioDriver Dummy`
  (sekwencyjnie, jeden katalog użytkownika, polityka logu): patrz `SESSION_LOG.md`, wpis PKG-0242.
- Kadry: `tools/capture_pkg_0241.gd` (88 kadrów, 81 pomiarów linii, **0 przepełnień**
  pudła CRT przy 85/100/115%) i nowy `tools/capture_pkg_0242.gd` (16 kadrów:
  tytuł PL/EN, twórcy i licencje, pauza, pokoje wyborów 16/17/18, odmowa drzwi 18,
  finały i epilogi). Kadry poza kontrolą wersji.

## 7. Czego nie potwierdzono (ograniczenia)

- Brak testów z ludźmi (D-012): nie wiadomo, czy legendy stron, komunikaty kroków
  i łańcuch 17 ↔ 18 są zrozumiałe dla nowej osoby (H-nowa w RISKS).
- Dźwięk tylko sterownikiem Dummy; brak fizycznego pada, DPI, pomiaru klatki na Windows.
- Dialogi i fabuła są wyłącznie po polsku; przełącznik EN tłumaczy powłokę
  (menu, ustawienia, pauza), co ustawienia mówią wprost („Dialogi: PL”).
- W drzwiach Lena bywa częściowo zasłonięta skrzydłem drzwi (rysunek progu nad graczem).
- Repozytorium śledzi `.godot/`, `reports/` i historyczne binaria Godot 4.6.3 dla Windows
  (poza eksportem przez `exclude_filter`); porządki wymagają decyzji właściciela.
- Brak eksportu i nowych `.exe` (D-168). PRODUCT GO nie jest przedmiotem tego raportu.

## 8. Decyzje

D-252 (zasada przepinania bramek po PKG-0239), D-253 (priorytet naciśnięcia
i odmowa drzwi), D-254 (powłoka wydania: tryb testowy tylko deweloperski,
twórcy i licencje z silnika) — `docs/DECISION_LOG.md`.
