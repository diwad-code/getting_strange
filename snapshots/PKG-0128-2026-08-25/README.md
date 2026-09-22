# Getting Strange

`Getting Strange` to jednoosobowa, filmowa gra narracyjna 2D w Godot 4.7.
Lena wraca z rutynowego pomiaru do pozornie zwyczajnego miasta. Drobne różnice
narastają od niepokoju przez zmieszanie i lęk do upiornej pewności, że spójny
świat pamięta inne życie. Dopiero wtedy bohaterka próbuje wrócić bez
potraktowania cudzej rzeczywistości jak błędu do skasowania.

Projekt obejmuje wyłącznie grę Godot na PC. Nie ma aktywnego wariantu webowego,
mobilnego ani repozytorium Git.

## Aktualny kierunek

Projekt jest w fazie **P4: relacyjna rewolucja fabuły i kontrolowana
przebudowa** (ADR-006, ADR-007, D-114). Nie powstaje od zera: zachowujemy
działający szkielet techniczny —
sterowanie, fizykę, zapis, shell, pauzę, ustawienia, audio i testy — a ponownie
tworzymy:

- treść i inscenizację Station 01–43;
- model, rig i animację Leny;
- kontekstowe prowadzenie oraz wewnętrzne myśli;
- warstwę Rówień Pixel-Stage;
- czytelne teksty renderowane ostro ponad pikselizowanym światem.

Technicznie istnieją 43 sceny, trzy dawne warianty finału, epilog i pełna trasa
kampanii. Są materiałem migracyjnym, nie content lockiem ani dowodem gotowej
gry.

Kanon tempa: Station 01–05 normalność, 06–20 stopniowa eskalacja, Station 21
rozpoznanie „To nie jest mój świat”, Station 22 początek świadomego działania i
kampanijnego Anchor/Yield.

Kanon 0.3 wiąże tajemnicę z konkretnymi osobami: w świecie Leny wypadek Linii 4
zabił Jakuba; w Równi Jakub żyje, miejscowa Lena zaginęła podczas testu
wzajemnego, Marta zna ją jako swoją partnerkę, a Wierzbicka chroni stabilność
miasta kosztem autonomii obu Len. Po rozpoznaniu świata celem nie jest już samo
„wrócić”, lecz ustalić, kogo i co każde rozwiązanie pozostawi po drugiej
stronie.

## Uruchomienie

Wymagany jest Godot `4.7.x`.

```powershell
godot --editor --path C:\getting_strange
```

```powershell
godot --path C:\getting_strange
```

Punkt wejścia to `scenes/shell/title_screen.tscn`. Movement Lab i Anchor Lab są
narzędziami deweloperskimi.

Sterowanie runtime:

- `A` / `D` lub lewy analog — ruch;
- `Spacja` lub dolny przycisk pada — skok;
- `E` lub zachodni przycisk pada — interakcja;
- `F` lub północny przycisk pada — korekta w scenach, które ją obsługują;
- `R` lub Back — restart;
- `Esc` lub Start — pauza.

Ustawienia mają osobny schema i obejmują Master, tempo i skalę tekstu,
fullscreen, PL/EN dla shellu/UI oraz kontrolowany remap pięciu akcji.

## Weryfikacja

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Bramka sprawdza dokumentację, import Godot, InputMap, ruch, zakazy przeszkód i
testy pakietowe. Smoke wywołuje istniejącą trasę 01–43. Przejście testu
potwierdza kontrakty techniczne dawnego runtime i nowych wycinków; nie dowodzi
funu, emocji, czytelności przez nową osobę ani skuteczności fabuły.

## Dokumentacja

Nowa sesja zaczyna od:

1. [indeksu dokumentacji](docs/INDEX.md),
2. [aktualnego stanu](docs/CURRENT_STATE.md),
3. [promptu następnej sesji](docs/NEXT_SESSION_PROMPT.md),
4. aktywnej specyfikacji wskazanej w stanie.

Najważniejsze dokumenty kierunku:

- [plan kontrolowanej przebudowy](docs/CREATIVE_REBUILD_PLAN.md),
- [roadmapa](docs/ROADMAP.md),
- [kanon narracyjny](docs/narrative/NARRATIVE_BIBLE.md),
- [pełny przebieg 43 przestrzeni](docs/narrative/FULL_STORY.md),
- [Lena i animacja](docs/LENA_CHARACTER_AND_ANIMATION.md),
- [prowadzenie i myśli](docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md),
- [architektura pikselizacji i tekstu](docs/PIXEL_PRESENTATION_ARCHITECTURE.md),
- [kanon wizualny](VISUAL_DESIGN.md),
- [kanon przeszkód](docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md).

Projekt nie używa kontroli wersji. Zamknięte pakiety są dokumentowane w
`docs/SESSION_LOG.md` i zamrażane przez `tools/snapshot.ps1`.
