# Prompt dla następnej sesji: PKG-0095 (Rówień Vector-Stage Akt II i łańcuch przejść kampanii)

## CEL SESJI

Zgodnie z decyzjami **D-091, D-092 i D-093** — 100% prac na grze Godot 4.7 (`Getting Strange`), bez prac webowych. PKG-0094 dostarczył wersjonowany zapis kampanii, menu pauzy/selekcji oraz ręczny Rówień Vector-Stage dla Station 06..10. Historyczne *Another World / Out of This World* jest wyłącznie bezpiecznym odniesieniem do ogólnej techniki, nie wzorem do kopiowania.

1. **Rówień Vector-Stage, Akt II**: ręcznie skonwertować Station 11..15 według `VISUAL_DESIGN.md`; dla każdej sceny zapisać oś, negatywną przestrzeń, plan gry, 4–6 kolorów, akcent i rekwizyt-świadka. Nie używać cudzej palety, scen ani ikonografii.
2. **Łańcuch kampanii**: połączyć rzeczywiste stany ukończenia Station 01..15 z `GameStateManager.transition_to_station()`, checkpointem i odblokowaniem kolejnej stacji. Nie omijać normalnego unlocku; tryb testowy pozostaje osobnym przełącznikiem.
3. **Integracja stanu**: rozszerzyć kontrakt poszlak i CRT cues o Akt II oraz dodać deterministyczny test przejść bez zmiany istniejących colliderów i geometrii.
4. **Weryfikacja**: dodać/rozszerzyć smoke, uruchomić capture Aktu II na normalnym sterowniku Windows, `pwsh -NoProfile -File .\tools\verify.ps1`, dokumentację i snapshot.

Dozwolone i zalecane: aktywnie korzystać z uwierzytelnionego Picsart CLI `gen-ai`
oraz dostępnych kredytów do tworzenia wielu własnych wariantów kompozycji,
rekwizytów, referencji poz i materiałów dla Station 06..10. Zapisuj prompt,
model, datę i plik źródłowy; przeprowadzaj ręczną adaptację do Rówień
Vector-Stage i nie proś modelu o odtwarzanie *Another World* ani innej cudzej
chronionej ekspresji.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, D-089, D-091, ADR-004) — praca wyłącznie nad silnikiem gry Godot, bez prac webowych.
- Baseline: Station 01..10 mają warstwę `VectorStageEnvironment`; Station 06..10 mają własne profile, rig atmosfery, CRT i checkpoint cue. `GameStateManager` ma schema 1 save, pause CanvasLayer, zwykłe unlocki oraz test mode. Dowody PKG-0094: `tests/pkg_0094_smoke_test.gd`, `docs/VECTOR_STAGE_ACT_I_AUDIT.md`, `reports/pkg_0094_act1/`.
- Weryfikacja obowiązkowa: `pwsh -NoProfile -File .\tools\verify.ps1`; pełny test trwa znacząco dłużej niż pojedynczy limit wywołania terminala, więc należy użyć procesu monitorowanego i odczytać jego końcowy exit code oraz log.

## KRYTERIA AKCEPTACJI

1. Wykonać świeży pełny verify oraz smoke PKG-0091/0094 jako baseline.
2. Skonwertować Station 11..15 do Rówień Vector-Stage wraz z renderami i audytem kryteriów biblii.
3. Wdrożyć i przetestować przejścia/odblokowania kampanii między Station 01..15.
4. Zintegrować stan, poszlaki i dialog CRT z nowymi stacjami bez regresji zapisu schema 1.
5. Zaktualizować dokumentację i zamrozić PKG-0095.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0095 musi zostać zweryfikowany przez `tools/verify.ps1`, opisany w dokumentacji projektu i zamrożony poleceniem:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0095`.
