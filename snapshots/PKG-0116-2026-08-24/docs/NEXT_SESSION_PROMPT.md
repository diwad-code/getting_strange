# PKG-0117 — Foundation Slice 01–07

Wykonaj pakiet autonomicznie, krok po kroku, bez przystanków na aprobatę.
Podejmuj decyzje techniczne i artystyczne jako Lead Programmer i Art Director.
Nie zatrzymuj się, chyba że aktualny runtime, dokumentacja i bezpieczne testy
nie pozwalają rozstrzygnąć prawdziwego blokera.

## CEL SESJI

Zbuduj pierwszy produkcyjny pionowy wycinek kontrolowanej przebudowy:
Station 01–07 wraz z czterema fundamentami, które staną się standardem kolejnych
pakietów:

1. nową, ludzką i czytelną Leną z produkcyjnym rigem oraz animacją;
2. pikselizowanym światem Rówień Pixel-Stage i ostrymi tekstami/UI;
3. systemem prowadzenia pokaż → naprowadź → pomyśl;
4. ponownym autorstwem otwarcia: zwykły pomiar i powrót, a dopiero w Station 06–07
   pierwszy racjonalizowalny niepokój.

Nie buduj całej gry od zera. Zachowaj działający kręgosłup Godota: fizykę,
InputMap, zapis, shell, pauzę, ustawienia, routing, audio i testy. Wycinek jest
gotowy dopiero jako spójne połączenie treści, postaci, prezentacji, prowadzenia,
zapisu i dowodów technicznych.

## SRODOWISKO I BASELINE

- Katalog: `C:\getting_strange`.
- Godot `4.7.stable.official.5b4e0cb0f`, GDScript, Windows/PowerShell 7.
- Logiczny viewport `640x360`, fizyka `60 Hz`, semantyczny InputMap.
- Zakres: wyłącznie gra Godot PC. Zero webu, PWA, Androida, Capacitor i Git.
- Projekt nie ma repozytorium; pliki na dysku są jedynym stanem.
- Ostatni zamknięty pakiet: PKG-0116 — creative rebaseline.
- Aktywne decyzje: ADR-006 i D-113.
- Aktywne specyfikacje:
  - `docs/CREATIVE_REBUILD_PLAN.md`;
  - `docs/narrative/FULL_STORY.md`, sceny 01–07;
  - `docs/narrative/CONTINUITY_TRACKER.md`, okna wiedzy 01–07;
  - `docs/narrative/DIALOGUE_SCRIPT.md`, beaty 01–07;
  - `docs/LENA_CHARACTER_AND_ANIMATION.md`;
  - `docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md`;
  - `docs/PIXEL_PRESENTATION_ARCHITECTURE.md`;
  - `VISUAL_DESIGN.md`;
  - `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`.
- Istniejący `PrototypePlayer` ma sprawną fizykę, ale jego `_draw()` jest
  placeholderem wizualnym, nie bazą finalnej sylwetki.
- Istniejące Station 01–07 i ich teksty są treścią legacy. Można zachować
  użyteczne komponenty techniczne, lecz nie przedwczesne ujawnienia ani stare
  beaty.

Wymagana kolejność lektury:

1. `AGENTS.md`;
2. `docs/INDEX.md`;
3. `docs/CURRENT_STATE.md`;
4. ten prompt;
5. `docs/CREATIVE_REBUILD_PLAN.md` i ADR-006;
6. wszystkie aktywne specyfikacje powyżej;
7. `scripts/player/prototype_player.gd` i scena gracza;
8. sceny/skrypty Station 01–07, ich interakcje, teksty i testy;
9. `scripts/ui/crt_dialogue_box.gd`, shell UI, zapis i routing;
10. `tools/capture_preview.gd`, `tools/verify.ps1` i ostatnie smoke testy.

Przed pierwszą edycją uruchom i zapisz wynik:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

## ZAKRES IMPLEMENTACJI

### 1. LenaVisualRig

Oddziel fizykę od prezentacji. `PrototypePlayer`/`CharacterBody2D` nadal
wyznacza stan mechaniczny, a nowa scena wizualna reaguje przez mały, typowany
adapter.

Wymagany zakres Foundation Slice:

- model sheet Leny zapisany w `docs/art/` albo równoważnym katalogu źródłowym:
  proporcje, paleta, przód/bok, kluczowe rekwizyty i co najmniej sześć póz;
- wysokość wizualna startowo 44–52 px logiczne przed kompozytorem; skoryguj po
  audycie kamery i collidera, zapisując decyzję;
- osobne segmenty głowy/barków/tułowia/miednicy/kończyn lub równoważny rig,
  który daje ludzką sylwetkę i punkt ciężaru;
- stany minimum: `idle`, `start`, `walk`, `run`, `stop`, `turn`, `jump_rise`,
  `jump_fall`, `land`, `interact`, `examine`, `unease_reaction`;
- kierunek głowy/uwagi, czytnik pomiarowy i reakcja na próg/interakcję;
- mechaniczna odpowiedź ruchu bez oczekiwania na ozdobną klatkę;
- brak kopiowania proporcji, klatek, kostiumu lub timingu `Another World`.

Usuń lub wyłącz placeholderowe rysowanie postaci w aktywnej trasie 01–07, ale
nie niszcz fizyki ani narzędzi debug bez potrzeby. Jeśli potrzebujesz własnego
materiału referencyjnego do ruchu, zachowaj jego pochodzenie i adaptuj go do
własnego model sheetu.

### 2. WorldPixelCompositor i ostre warstwy

Wprowadź reużywalną architekturę z kolejnością:

```text
WorldRoot / LenaVisualRig / world effects
  -> WorldPixelCompositor (domyślnie efektywne 320x180, nearest)
CrispDiegeticText
CrispGameplayUI
CrispSystemUI
```

Wymagania:

- świat, Lena i efekty przestrzeni podlegają temu samemu rastrowi;
- dialog CRT, `LENA // MYŚL`, cele, ikony sterowania, menu i teksty terminali/
  szyldów przeznaczone do czytania renderują się po kompozytorze;
- żadna czytelna treść Station 01–07 nie pozostaje w `draw_string()` pod
  kompozytorem; daleki nieczytelny kształt napisu może pozostać dekoracją;
- brak bilinear filtering, subpikselowego drżenia i przypadkowego ditheringu;
- kompozytor nie zmienia colliderów, pozycji interakcji ani zapisu;
- skala tekstu 85–115%, dialog, pauza i ustawienia zachowują działanie;
- wykonaj pomiar kosztu dla co najmniej świata bez tekstu, dialogu i myśli;
  wynik jest techniczny, nie dowodzi estetyki.

Wybierz `SubViewport` lub równoważną architekturę po małym spike'u na Station 01.
Nie twórz globalnego filtra, który obejmuje UI.

### 3. NarrativeGuidanceService i wewnętrzny głos

Zaimplementuj mały, deterministyczny system oparty na danych beatów, nie
hardkodowanym timerze rozsianym po siedmiu skryptach.

Wymagane elementy:

- typowany `GuidanceBeat`/Resource lub równoważne dane: ID, scena, wymagania,
  sygnał postępu, poziomy L0–L4, cooldown i zasada jednorazowości;
- poziomy: L0 kompozycja, L1 reakcja ciała/świata, L2 myśl kontekstowa, L3 myśl
  kierunkowa, L4 opcjonalny ratunek;
- realny postęp resetuje timer; samo chodzenie w kółko go nie oszukuje;
- cooldown między myślami minimum 8 s, brak powtórki bez nowej informacji;
- dialog, pauza, zmiana sceny i restart bezpiecznie zawieszają/resetują stan;
- interpretacja Leny może być błędna narracyjnie, ale obserwacja i mechanika
  zawsze są prawdziwe;
- powierzchnia `LENA // MYŚL` jest ostra, nie zasłania Leny ani celu i respektuje
  skalę/tempo tekstu;
- L4 jest opcjonalne w ustawieniach lub przez jasno wybrany tryb pomocy, bez
  blokowania fabuły lub zakończeń.

### 4. Ponowne autorstwo Station 01–07

Zrealizuj dokładnie kanon `FULL_STORY.md` 0.2:

- **01:** rutynowy wieczorny odczyt; nauczenie ruchu, oglądania i czytnika;
- **02:** ścieżka serwisowa i wiarygodne obejście prac technicznych;
- **03:** zwykły przystanek i codzienna wiadomość Marty;
- **04:** przejazd; powtórzenie sygnału dające się wyjaśnić urządzeniem;
- **05:** znana ulica, bez jawnie niemożliwego zdarzenia;
- **06:** sprzeczne rozkłady i pierwsza racjonalizowalna rysa;
- **07:** zmieniony szyld oraz sprzedawca pewny, że zna Lenę.

Każda przestrzeń ma jawnie zapisane:

- cel bieżący i stan wyjścia;
- najwyższy dozwolony poziom dziwności;
- beat pokazany w świecie przed tekstem;
- animację/reakcję Leny;
- GuidanceBeats i warunki postępu;
- wszystkie ostre teksty;
- flagi zapisu/restartu.

Zakazane w aktywnej treści 01–07: jawny alternatywny świat, inna linia czasu,
lokalna Lena, żywy Jakub, UCP jako objaśniona instytucja, świadome
Zakotwiczenie/Uległość, portal, glitch zdradzający teleportację, obca geometria
bez codziennego wyjaśnienia. W Station 01–05 nie ma jednoznacznej anomalii.

Możesz zmienić geometrię legacy tylko wtedy, gdy wymaga tego nowa funkcja
przestrzeni i przejdzie test trzech pytań z kanonu przeszkód. Nie dodawaj
ruchomych platform, kolców, wrogów, health baru ani skoków dla samego timingu.

### 5. Audio i filmowa interpunkcja

- Zachowaj proceduralną infrastrukturę audio, ale przypisz cue do nowego beatu.
- Station 01–05 nie może używać paranormalnego stingu mówiącego odbiorcy więcej
  niż Lenie.
- Kroki, materiał ubrania, czytnik, oddech i kontakt mają wspierać ciało.
- Krótkie beaty filmowe pokazują zdarzenie → reakcję Leny → ewentualny tekst;
  nie odbierają sterowania dłużej niż wymaga czynność.

### 6. Testy i dowody

Dodaj `tests/pkg_0117_smoke_test.gd` i włącz go do `tools/verify.ps1`.

Test ma co najmniej sprawdzać:

- instancjonowanie i stany `LenaVisualRig` bez regresji fizyki;
- synchronizację mechanicznego stanu ruchu z wizualnym adapterem;
- kolejność kompozytora i trzech ostrych warstw;
- brak czytelnych tekstów świata pod pikselizacją w Station 01–07;
- cooldown, reset, jednorazowość i progresję GuidanceBeat;
- brak myśli podczas dialogu/pauzy oraz prawidłowy restart;
- ciąg 01→07, checkpointy i flagi;
- brak `world_recognized`, świadomego Anchor/Yield i zakazanych terminów;
- rozmiar viewportu, nearest sampling i skale tekstu;
- brak niedozwolonych przeszkód.

Rozszerz `tools/verify_docs.ps1` lub osobny lint tylko o stabilne kontrakty, nie
o subiektywne oceny obrazu.

Wykonaj świeże capture'y normalnym sterownikiem Windows/Godot:

- Station 01: świat bez tekstu;
- Station 01: interakcja/czytnik;
- Station 03: dialog Marty;
- Station 06: myśl L2/L3;
- Station 07: sprzedawca i reakcja Leny;
- sprite/rig sheet albo sekwencja kluczowych klatek: idle, start, chód, stop,
  obrót, interakcja, reakcja niepokoju;
- porównanie tekstu przy 85%, 100% i 115%.

Obejrzyj kadry rzeczywiście. Raportuj geometrię, warstwy, ostrość i stan
animacji; nie pisz, że render dowiódł emocji, atrakcyjności lub zrozumienia.

## POZA ZAKRESEM

- Station 08–43 poza konieczną adaptacją wspólnego komponentu;
- świadoma integracja Anchor/Yield w kampanii;
- przebudowa save schema bez wykazanej potrzeby;
- nowe finały, eksporty, buildy i store assets;
- pełna lokalizacja dialogu narracyjnego;
- strona, PWA, browser showcase i każda powierzchnia webowa;
- globalna wymiana audio lub systemu menu;
- kopiowanie cudzej animacji lub assetów.

## KRYTERIA AKCEPTACJI

Pakiet jest zaakceptowany wyłącznie, jeśli:

1. Station 01–05 są normalne, 06–07 dają pierwszy uczciwie
   racjonalizowalny niepokój i nie zdradzają diagnozy.
2. Aktywna Lena w 01–07 nie używa placeholderowego gryzmołu; ma ludzki rig,
   czytelny ciężar i wymagane stany.
3. Świat jest celowo pikselizowany, a każdy czytelny tekst/UI jest ostry.
4. System pokaż → naprowadź → pomyśl reaguje na realny zastój, nie spamuje i
   nigdy nie kłamie mechanicznie.
5. Treść, flagi, routing, restart i zapis 01→07 są zgodne z kanonem 0.2.
6. Nie dodano niedozwolonej przeszkody ani nowego globalnego managera bez
   potrzeby.
7. `pkg_0117_smoke_test.gd`, test dokumentacji i pełne `verify.ps1` kończą się
   kodem 0.
8. Świeże capture'y normalnym driverem istnieją i zostały obejrzane.
9. `CURRENT_STATE`, `SESSION_LOG`, `RISKS_AND_HYPOTHESES`, roadmapa oraz ten
   handoff zostały zsynchronizowane z faktycznym wynikiem.
10. Snapshot `PKG-0117` istnieje.

## CZEGO TEST NIE POTWIERDZA

- że ruch Leny jest przyjemny;
- że postać wygląda atrakcyjnie lub wiarygodnie dla odbiorcy;
- że tempo naprawdę wywołuje niepokój;
- że gracz zauważy cel bez podpowiedzi;
- że omylna myśl zostanie odebrana jako ludzka;
- że pixel-art ma finalną jakość artystyczną.

Te braki zapisz jawnie. Nie awansuj hipotez odbiorczych na podstawie automatu,
capture'a lub własnej oceny.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po implementacji:

1. uruchom testy celowane i świeże capture'y;
2. uruchom dokumentację:

```powershell
pwsh -NoProfile -File .\tools\verify_docs.ps1 -ProjectRoot (Get-Location)
```

3. uruchom pełną bramkę:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

4. dopisz dokładnie jeden wpis `## PKG-0117:` do `docs/SESSION_LOG.md`;
5. zastąp `docs/CURRENT_STATE.md` prawdą i `docs/NEXT_SESSION_PROMPT.md`
   pakietem PKG-0118;
6. zaktualizuj decyzje, ryzyka i hipotezy, których status faktycznie się zmienił;
7. zamroź pakiet:

```powershell
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0117
```

Nie edytuj snapshotu i nie czytaj go jako aktualnego stanu.

Raport końcowy musi wymienić: wynik, testy, capture'y, ograniczenia, identyfikator
PKG-0117, ścieżkę handoffu i ścieżkę snapshotu.
