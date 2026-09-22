# Aktualny stan projektu

Stan na: 2026-08-25 po PKG-0117  
Katalog: `C:\getting_strange`  
Silnik: `Godot 4.7.stable.official.5b4e0cb0f`  
Wersjonowanie: brak; pliki na dysku są jedynym stanem (D-016)

## Aktywna faza

**P4: relacyjna rewolucja fabuły i kontrolowana przebudowa gry Godot 4.7**
(`ADR-006`, `ADR-007`, `D-114`).

Audyt skilli pisarskich odrzucił kanon 0.2 jako podstawę dalszego autorstwa.
Projektu technicznego nie resetujemy: shell, sterowanie, fizyka, zapis, trasa,
ustawienia, audio, prototyp Anchor/Yield i historyczne testy pozostają
wartościowym szkieletem. Treść kampanii, relacje, dialog, Lena i powierzchnia
obrazu są przebudowywane według kanonu 0.3.

Aktywny plan: `docs/CREATIVE_REBUILD_PLAN.md` 3.0.  
Aktywny kanon wizualny: `VISUAL_DESIGN.md` — Rówień Pixel-Stage.  
Aktywny kanon fabuły: `docs/narrative/NARRATIVE_BIBLE.md` 0.3 i
`docs/narrative/FULL_STORY.md` 0.3.  
Pełny werdykt: `docs/NARRATIVE_SKILL_AUDIT_0_2.md`.

### Rdzeń narracji 0.3

- Dziewięć lat temu trzysekundowa luka pomiarowa poprzedziła katastrofę Linii
  4, w której w świecie przybyłej Leny zginął Jakub.
- Lena uczyniła z pewności i kontroli sposób radzenia sobie z winą.
- W Równi Linia 4 została ustabilizowana, Jakub żyje, a miejscowa Lena —
  partnerka Marty i pracowniczka UCP-4 — odkryła pary eksportowanych kosztów.
- O 20:40 obie Leny wykonały odpowiadający sobie pomiar. Wierzbicka zakotwiczyła
  miejscową obecność w trakcie kontaktu, ściągając przybyłą Lenę do Równi i
  zatrzymując miejscową Lenę pomiędzy adresami.
- Station 01–20 odpowiadają na pytanie „co tu się nie zgadza?” bez nazywania
  innego świata. Station 21 jest pierwszym `To nie jest mój świat`.
- Od Station 22 główne pytanie brzmi: co zrobiła miejscowa Lena, gdzie jest i
  kto zapłaci za rozdzielenie ciągłości.
- Wierzbicka jest aktywną, racjonalną przeciwniczką: chroni mierzalną większość
  i stabilność Równi kosztem autonomii jednostek.
- Finały 42A/42B/42C mają jawny stan obu Len, Marty, Jakuba, UCP i relacji
  światów. Nie istnieje rozwiązanie odzyskujące wszystko.

## Co jest technicznie zachowane

- Punkt wejścia: `scenes/shell/title_screen.tscn`.
- Trasa techniczna: Station 01..41 → wybrane 42A/42B/42C → 43 → tytuł.
- `GameStateManager`, zapis, Nowa gra, Kontynuuj, pauza, ustawienia,
  fullscreen, PL/EN shellu/UI i remap pięciu akcji.
- `PrototypePlayer`, semantyczny InputMap, 60 Hz, coyote time, jump buffer i
  szybki restart.
- Movement Lab, Anchor Lab, proceduralne audio, CRT dialogue surface i
  historyczne bramki techniczne.
- Wszystkie 43 sceny instancjonują się; traversal lint nie wykrywa zabronionej
  geometrii arcade.

Te fakty nie oznaczają, że aktywna treść 01–43 jest zgodna z kanonem 0.3.

## Stan zastanego Foundation Slice

Przed audytem narracji na dysku pojawiła się niezamknięta implementacja 01–07:
`LenaVisualRig`, adapter animacji, kompozytor świata, ostre teksty, guidance,
powierzchnia myśli, zmienione sceny oraz `pkg_0117_smoke_test.gd`. Nie miała
wpisu w logu ani snapshotu, a dwa osierocone procesy testowe nadal działały.

PKG-0117 zachował pliki, zatrzymał wyłącznie osierocone PID-y, uruchomił testy i
sklasyfikował wynik:

### KEEP

- oddzielenie prezentacji Leny od fizyki;
- architektura warstw `WorldPixelCompositor` / `CrispDiegeticText`;
- `NarrativeGuidanceService`, `GuidanceBeat` i `InnerThoughtSurface` jako
  baza;
- węzły integracyjne tych systemów w 01–07;
- techniczne pokrycie smoke.

### ADAPT

- proceduralna anatomia, skala, klatki i aktorstwo `LenaVisualRig`;
- rzeczywista jakość pikselizacji oraz budżet kompozytora;
- rekord GuidanceBeat do modelu obserwacja → hipoteza → sprawdzenie;
- cała inscenizacja, treść i cele Station 01–07.

### RETIRE

- anomalia korelacyjna i nieciągły cień w 02;
- „alternatywna” fotografia, podwójne kubki i sztuczna pustka w 03;
- jawny żywy Jakub oraz nadzór UCP w 04;
- zmienna geometria, brakujące piętro i szept imienia w 05;
- pierścień/obca biografia w 06;
- wejście Marty do mieszkania i ślepe schody w 07.

Elementy `RETIRE` nadal istnieją w aktywnym runtime legacy i muszą zostać
usunięte przez PKG-0118. PKG-0117 nie nazywa 01–07 ukończonym wycinkiem.

## Co zmienił PKG-0117

- przeczytano i zastosowano właściwe skille audytu opowieści, tajemnicy,
  dialogu, ciągłości, emocjonalnego łuku i experience designu;
- dodano `NARRATIVE_SKILL_AUDIT_0_2.md` z findings S1/S2 oraz werdyktem
  `REJECT`;
- dodano `ADR-007` i `D-114`;
- zastąpiono biblię narracyjną, pełny przebieg 01–43, tracker ciągłości i skrypt
  dialogowy kanonem 0.3;
- zastąpiono Product Brief, Project Bible, guidance, plan przebudowy, roadmapę i
  rejestr ryzyk kierunkiem 3.0;
- rozszerzono kontrakt dokumentacji do 36 wymaganych plików;
- zrekoncyliowano zastane komponenty bez hurtowego cofania;
- zaktualizowano historyczny gate PKG-0100 do rzeczywistej ścieżki
  `Geometry/ReplacementBusExitDoor` i klatki fizyki, zachowując sprawdzenia
  typu, ruchu oraz zapisu konsekwencji.

## Ostatnia swieza weryfikacja

Data: 2026-08-25, po rewolucji kanonu i rekoncyliacji technicznej.

```powershell
pwsh -NoProfile -File .\tools\verify_docs.ps1
```

Wynik: `DOCS PASS: 36 required files and handoff contracts`, kod `0`.

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Wynik: `Verification passed.`, kod `0`.

Pełna bramka potwierdziła import, główny smoke Station 01–43, traversal lint,
historyczne gate'y PKG-0095..0115 oraz techniczną bramkę komponentów PKG-0117.
Pozostały nieblokujące ostrzeżenia `ObjectDB instances were leaked at exit`
oraz oczekiwane ostrzeżenia fixture'ów uszkodzonego zapisu i nieobsługiwanego
schema ustawień.

Normal-driver capture przez `tools/capture_preview.gd` zakończył się kodem 0.
Inspekcja `station_01.png`, `station_05.png`, `station_07.png` i
`movement_lab.png` potwierdziła:

- teksty są renderowane ostro ponad światem;
- rig ma ludzką sylwetkę, ale pozostaje małym proceduralnym manekinem;
- pikselizacja jest zbyt subtelna, by uznać kierunek za zamknięty;
- Station 07 pokazuje szyld kiosku na geometrii starej klatki schodowej.

To jest dowód stanu renderu, nie jakości odbiorczej.

## Czego jeszcze nie potwierdzono

- Żadna scena 01–43 nie ma jeszcze content locka 0.3.
- 01–07 nie realizują pełnego przebiegu z `FULL_STORY.md`; zawierają aktywne
  elementy `RETIRE`.
- Lena nie osiągnęła jakości produkcyjnej ani porównywalnego ciężaru animacji do
  ogólnych zasad obserwowanych w `Another World`.
- Sam smoke API nie dowodzi, że `WorldPixelCompositor` daje dobry pixel-art,
  że wszystkie napisy go omijają ani że spełnia budżet.
- Guidance nie ma jeszcze pełnego modelu hipotezy i sprawdzenia z kanonu 0.3.
- Nie ma runtimeowego lintu wiedzy Station 01–21 ani migracji flag fabularnych.
- Buildy Windows/Linux, pełna lokalizacja narracji, credits, licencje,
  clearance tytułu i czysta instalacja pozostają poza bieżącym etapem.
- Brak dowodu odbiorczego: automaty i audyt autora nie potwierdzają napięcia,
  emocji, zabawy, zrozumienia relacji ani jakości finałów.

## Nastepny pakiet

**PKG-0118 — Foundation Slice 01–07 według kanonu 0.3.**

Pakiet ma usunąć aktywne elementy `RETIRE`, zrealizować prawdziwy przebieg:

1. próbka Linii 4 i obietnica Marty;
2. zwykłe obejście;
3. wiadomość Marty;
4. przejazd i osobisty koszt obsesji;
5. całkowicie znana ulica z neutralnym szyldem UCP;
6. dwa aktualne rozkłady z hipotezą cache;
7. kiosk i herbata dla Marty jako pierwsza rysa społeczna.

Równocześnie rozwija Lenę, Pixel-Stage, ostre teksty i omylne guidance. Dokładny
zakres i kryteria znajdują się w `docs/NEXT_SESSION_PROMPT.md`.

Kolejka po nim: PKG-0119 (08–13), PKG-0120 (14–23), PKG-0121 (24–30),
PKG-0122 (31–38), PKG-0123 (39–43/content lock), PKG-0124+ (build/RC).

## Handoff i zamrozenie

- Wpis pakietu: `docs/SESSION_LOG.md`, `## PKG-0117:`.
- Handoff: `docs/NEXT_SESSION_PROMPT.md`.
- Snapshot: `snapshots/PKG-0117-2026-08-25/`.
- Snapshot jest zamrożoną kopią i nie jest źródłem bieżącej prawdy.
