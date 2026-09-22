# Prompt dla następnej sesji: PKG-0098 (Widoczność Rówień w Station 01..20 i Akt IId 26..30)

## CEL SESJI

Zgodnie z decyzjami **D-091..D-097** — 100% prac na grze Godot 4.7 (`Getting Strange`),
bez prac webowych. PKG-0097 dostarczył ręczny Rówień Vector-Stage dla Station 21..25,
łańcuch ukończeń Station 01..25 oraz naprawę widoczności warstwy Vector-Stage (D-096).
Historyczne *Another World / Out of This World* jest wyłącznie bezpiecznym odniesieniem
do ogólnej techniki, nie wzorem do kopiowania.

1. **Naprawa długu D-096**: przenieść wzorzec z Station 21..25 na Station 01..20 —
   `_draw()` stacji przestaje malować nieprzezroczyste tło pełnoekranowe i rysuje
   wyłącznie `_draw_state_layer()` w palecie `VectorStageStyle`. Kadr należy do
   `VectorStageEnvironment`. Nie zmieniać colliderów, `Geometry`, `AirlockZone` ani
   zasięgów interakcji.
2. **Wzmocnienie testów**: rozszerzyć smoke PKG-0094/0095/0096 tak, aby sprawdzały
   widoczność kadru (np. brak nieprzezroczystego rysowania tła przez skrypt stacji),
   a nie tylko obecność węzła. Odnowić rendery Aktów I/II/IIb.
3. **Rówień Vector-Stage, Akt IId**: ręcznie skonwertować Station 26..30 według
   `VISUAL_DESIGN.md`; dla każdej sceny zapisać oś, negatywną przestrzeń, plan gry,
   4–6 kolorów, akcent i rekwizyt-świadka. Nie używać cudzej palety, scen ani ikonografii.
4. **Łańcuch kampanii**: podnieść `CAMPAIGN_TRANSITION_LIMIT` z 25 na 30 **dopiero
   razem z testem** 25→30; nie omijać normalnego unlocku, tryb testowy zostawić osobno.
5. **Weryfikacja**: dodać bramkę PKG-0098 do `tools/verify.ps1`, uruchomić capture
   Aktu IId na normalnym sterowniku Windows, `pwsh -NoProfile -File .\tools\verify.ps1`,
   dokumentację i snapshot.

Dozwolone i zalecane: aktywnie korzystać z uwierzytelnionego Picsart CLI `gen-ai`
oraz dostępnych kredytów do tworzenia wielu własnych wariantów kompozycji,
rekwizytów, referencji poz i materiałów dla Station 26..30. Zapisuj prompt,
model, datę i plik źródłowy; przeprowadzaj ręczną adaptację do Rówień
Vector-Stage i nie proś modelu o odtwarzanie *Another World* ani innej cudzej
chronionej ekspresji.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, D-089, D-091, ADR-004) — praca wyłącznie nad silnikiem gry Godot, bez prac webowych.
- Baseline: Station 01..25 mają warstwę `VectorStageEnvironment`; Station 16..25 mają
  własne profile, rig atmosfery, CRT i checkpoint cue. **Tylko Station 21..25 mają
  Rówień faktycznie widoczny** — 01..20 są zasłonięte tłem rysowanym przez skrypt
  stacji (dług D-096). `GameStateManager` ma schema 1 save, pause CanvasLayer, zwykłe
  unlocki i test mode; realny łańcuch `level_completed` działa dla Station 01..25 i
  kończy się jawnym limitem 25. `tools/verify.ps1` uruchamia bramki PKG-0095/0096/0097.
  Dowody PKG-0097: `tests/pkg_0097_smoke_test.gd`, `docs/VECTOR_STAGE_ACT_IIC_AUDIT.md`,
  `reports/pkg_0097_act2c/`.
- Weryfikacja obowiązkowa: `pwsh -NoProfile -File .\tools\verify.ps1`; pełny test trwa znacząco dłużej niż pojedynczy limit wywołania terminala, więc należy użyć procesu monitorowanego i odczytać jego końcowy exit code oraz log.

## KRYTERIA AKCEPTACJI

1. Wykonać świeży pełny verify jako baseline.
2. Rówień Vector-Stage jest realnie widoczny w Station 01..20, potwierdzony nowymi renderami.
3. Skonwertować Station 26..30 do Rówień Vector-Stage wraz z renderami i audytem kryteriów biblii.
4. Wdrożyć i przetestować przejścia/odblokowania kampanii między Station 25..30.
5. Zaktualizować dokumentację i zamrozić PKG-0098.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0098 musi zostać zweryfikowany przez `tools/verify.ps1`, opisany w dokumentacji projektu i zamrożony poleceniem:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0098`.
