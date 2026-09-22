# Aktualny stan projektu

Stan na: 2026-08-24 po PKG-0116  
Katalog: `C:\getting_strange`  
Silnik: `Godot 4.7.stable.official.5b4e0cb0f`  
Wersjonowanie: brak; pliki na dysku są jedynym stanem (D-016)

## Aktywna faza

**P4: kontrolowana przebudowa kreatywna gry Godot 4.7** (ADR-006, D-113).

PKG-0116 anulował dawny plan R2 content lock. Projekt nie jest odbudowywany od
zera: zachowujemy zweryfikowany kręgosłup techniczny, ale istniejącą treść
Station 01–43, proceduralną sylwetkę Leny, sposób prowadzenia i gładką
powierzchnię Vector-Stage traktujemy jako materiał legacy do ponownego autorstwa.

Aktywny plan: `docs/CREATIVE_REBUILD_PLAN.md`.  
Aktywny kanon wizualny: `VISUAL_DESIGN.md` — Rówień Pixel-Stage.  
Aktywny kanon fabuły: `docs/narrative/NARRATIVE_BIBLE.md` 0.2 i
`docs/narrative/FULL_STORY.md` 0.2.

### Najważniejsza zmiana narracyjna

- Station 01–05: normalność i kompetencja, bez jawnej anomalii.
- Station 06–09: niepokój, każda różnica ma codzienne wyjaśnienie.
- Station 10–13: zmieszanie i obca biografia, bez diagnozy.
- Station 14–17: lęk, Marta, rejestr pracy i niezrozumiały ślad UCP.
- Station 18–20: upiorność, głos i żywy Jakub.
- Station 21: dopiero tutaj trzy rodziny dowodów pozwalają Lenie powiedzieć
  „To nie jest mój świat”.
- Station 22: pierwsze świadome działanie i nazwanie Anchor/Yield.
- Station 42A–42C + 43: trzy rodziny konsekwencji i stan stabilności epilogu.

Przed ukończeniem Station 21 cel, myśli Leny i dialog nie mogą zdradzać innego
świata, lokalnej Leny ani świadomego Anchor/Yield.

### Nowe kontrakty produkcyjne

- `docs/LENA_CHARACTER_AND_ANIMATION.md` — `LenaVisualRig`, ludzka sylwetka,
  ciężar, start/stop/obrót/interakcja oraz emocjonalne reakcje; obecny `_draw()`
  pozostaje placeholderem do zastąpienia w PKG-0117.
- `docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md` — pokaż → naprowadź → pomyśl,
  drabina L0–L4, cooldown i rozdzielenie prawdziwej obserwacji od omylnej
  interpretacji.
- `docs/PIXEL_PRESENTATION_ARCHITECTURE.md` — świat domyślnie próbkowany do
  efektywnego `320x180`, a `CrispDiegeticText`, `CrispGameplayUI` i
  `CrispSystemUI` renderowane później i ostro.

## Co jest technicznie zachowane

- Produkcyjny shell `scenes/shell/title_screen.tscn` jest punktem wejścia.
- Trasa legacy działa: Station 01..41 → dokładnie wybrane 42A/42B/42C → 43 →
  tytuł.
- `GameStateManager` zachowuje `SAVE_SCHEMA_VERSION = 1`; ustawienia mają
  `SETTINGS_SCHEMA_VERSION = 1`.
- Działają Nowa gra, Kontynuuj, pauza, ustawienia, Master, tempo/skala tekstu,
  fullscreen, PL/EN shellu/UI i kontrolowany remap pięciu akcji.
- `PrototypePlayer` używa `CharacterBody2D`, semantycznego InputMap, coyote
  time, jump buffering, zmiennego skoku i fizyki 60 Hz.
- Movement Lab, Anchor Lab, proceduralne audio, CRT dialogue surface i testy
  pozostają infrastrukturą.
- Wszystkie 43 sceny legacy instancjonują się w głównym smoke.
- Traversal lint nie znajduje arcade'owej geometrii zabronionej przez D-099.

Te fakty potwierdzają działanie infrastruktury, nie zgodność starej treści z
kanonem 0.2. Station 01–43 nie są content lockiem.

## Co zmienił PKG-0116

Pakiet był rebaseline'em dokumentacyjno-produkcyjnym; nie zmienił runtime ani
assetów gry.

- dodano ADR-006 i D-113;
- zastąpiono bible narracyjne, przebieg 43 scen, tracker ciągłości i matrycę
  dialogów wersją 0.2;
- zastąpiono Product Brief, Project Bible, Visual Design, Roadmapę, rejestr
  ryzyk i routing dokumentacji;
- dodano plan kontrolowanej przebudowy oraz specyfikacje Leny, guidance i
  kompozytora Pixel-Stage;
- zaktualizowano research i granice inspiracji `Another World`;
- oznaczono audyty PKG-0113/Vector-Stage jako historyczne źródła dowodu;
- rozszerzono `tools/verify_docs.ps1` z 28 do 34 wymaganych plików i o kontrakty
  ADR-006, D-113, planu, Leny, guidance oraz ostrych warstw tekstu;
- przygotowano samowystarczalny handoff PKG-0117 dla Foundation Slice 01–07.

Nie wykonano nowego renderu, ponieważ pakiet nie zmieniał obrazu runtime.
Istniejące kadry PKG-0113 zostały obejrzane jako dowód diagnozy placeholderowej
Leny, ale nie są dowodem nowego kierunku ani jego jakości.

## Ostatnia swieza weryfikacja

Data: 2026-08-24, po synchronizacji kanonu i planu.

```powershell
pwsh -NoProfile -File .\tools\verify_docs.ps1 -ProjectRoot (Get-Location)
```

Wynik: `DOCS PASS: 34 required files and handoff contracts`, kod `0`.

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Wynik: `Verification passed.`, kod `0`.

Pełna bramka potwierdziła:

- dokumentację i import Godota;
- Movement Lab, Anchor Lab i instancjonowanie Station 01–43;
- semantyczne wejścia oraz fizykę gracza;
- traversal lint;
- historyczne bramki PKG-0095..0115, w tym shell, pełną topologię, zapis,
  ustawienia, remap, fokus i PL/EN UI.

Pozostały znane ostrzeżenia `ObjectDB instances were leaked at exit` w części
historycznych gate'ów oraz oczekiwane ostrzeżenia testów fallbacku uszkodzonego
zapisu i nieobsługiwanego schema ustawień. Nie zmieniły kodu końcowego `0`.

## Czego jeszcze nie potwierdzono

- Nowy `LenaVisualRig` nie istnieje jeszcze w runtime.
- `WorldPixelCompositor` i ostre warstwy tekstów świata nie są wdrożone.
- `NarrativeGuidanceService`, `GuidanceBeat` i `LENA // MYŚL` nie są wdrożone.
- Station 01–43 nadal wykonują treść legacy; kanon 0.2 jest planem migracji.
- Nie ma runtimeowego lintu zakazanych ujawnień przed Station 21.
- Nie wykonano migracji czytelnych `draw_string()` z poziomów.
- Nie zmierzono kosztu Pixel-Stage ani czytelności nowej Leny po kompozycji.
- Buildy Windows/Linux, `export_presets.cfg`, czysta instalacja, pełna
  lokalizacja narracji, credits, licencje i clearance tytułu pozostają poza
  aktualnym etapem.
- Brak dowodu odbiorczego: testy nie potwierdzają napięcia, emocji, funu,
  zrozumienia, ludzkiej wiarygodności myśli ani atrakcyjności obrazu.

## Nastepny pakiet

**PKG-0117 — Foundation Slice 01–07.**

Jeden pionowy wycinek ma równocześnie dostarczyć:

1. produkcyjny `LenaVisualRig` i podstawową pętlę aktorskiego ruchu;
2. `WorldPixelCompositor` z ostrymi tekstami/UI;
3. system GuidanceBeat oraz powierzchnię `LENA // MYŚL`;
4. ponowne autorstwo Station 01–07 od pełnej normalności do pierwszej rysy;
5. smoke test, lint treści, pomiar kompozytora i świeże capture'y normalnym
   driverem.

Samowystarczalny zakres i kryteria:
`docs/NEXT_SESSION_PROMPT.md`.

Po PKG-0117 kolejka prowadzi przez 08–14, 15–21, 22–30, 31–41 i dopiero
42A–43 / content lock 2.0. Buildy są zablokowane do PKG-0122.

## Handoff i zamrozenie

- Wpis pakietu: `docs/SESSION_LOG.md`, `## PKG-0116:`.
- Handoff: `docs/NEXT_SESSION_PROMPT.md`.
- Snapshot: `snapshots/PKG-0116-2026-08-24/`.
- Snapshot jest zamrożoną kopią i nie jest źródłem bieżącej prawdy.
