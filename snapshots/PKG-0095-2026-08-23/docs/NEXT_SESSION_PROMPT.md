# Prompt dla następnej sesji: PKG-0096 (Rówień Vector-Stage Akt IIb i łańcuch kampanii 16..20)

## CEL SESJI

Zgodnie z decyzjami **D-091..D-094** — 100% prac na grze Godot 4.7 (`Getting Strange`), bez prac webowych. PKG-0095 dostarczył ręczny Rówień Vector-Stage dla Station 11..15 oraz centralny łańcuch ukończeń Station 01..15. Historyczne *Another World / Out of This World* jest wyłącznie bezpiecznym odniesieniem do ogólnej techniki, nie wzorem do kopiowania.

1. **Rówień Vector-Stage, Akt IIb**: ręcznie skonwertować Station 16..20 według `VISUAL_DESIGN.md`; dla każdej sceny zapisać oś, negatywną przestrzeń, plan gry, 4–6 kolorów, akcent i rekwizyt-świadka. Nie używać cudzej palety, scen ani ikonografii.
2. **Łańcuch kampanii**: rozszerzyć realne ukończenia Station 01..20 przez `GameStateManager`, checkpoint i odblokowanie kolejnej stacji. Podnieść limit dopiero z testem 15→20; nie omijać normalnego unlocku, a tryb testowy pozostawić osobno.
3. **Integracja stanu**: dodać CRT/checkpoint cues i kontrakt poszlak dla Aktu IIb bez zmiany istniejących colliderów ani geometrii.
4. **Weryfikacja**: dodać/rozszerzyć smoke, uruchomić capture Aktu IIb na normalnym sterowniku Windows, `pwsh -NoProfile -File .\tools\verify.ps1`, dokumentację i snapshot.

Dozwolone i zalecane: aktywnie korzystać z uwierzytelnionego Picsart CLI `gen-ai`
oraz dostępnych kredytów do tworzenia wielu własnych wariantów kompozycji,
rekwizytów, referencji poz i materiałów dla Station 16..20. Zapisuj prompt,
model, datę i plik źródłowy; przeprowadzaj ręczną adaptację do Rówień
Vector-Stage i nie proś modelu o odtwarzanie *Another World* ani innej cudzej
chronionej ekspresji.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, D-089, D-091, ADR-004) — praca wyłącznie nad silnikiem gry Godot, bez prac webowych.
- Baseline: Station 01..15 mają warstwę `VectorStageEnvironment`; Station 11..15 mają własne profile, rig atmosfery, CRT i checkpoint cue. `GameStateManager` ma schema 1 save, pause CanvasLayer, zwykłe unlocki i test mode; realny łańcuch `level_completed` działa dla Station 01..15 i kończy się jawnym limitem 15. Dowody PKG-0095: `tests/pkg_0095_smoke_test.gd`, `docs/VECTOR_STAGE_ACT_II_AUDIT.md`, `reports/pkg_0095_act2/`.
- Weryfikacja obowiązkowa: `pwsh -NoProfile -File .\tools\verify.ps1`; pełny test trwa znacząco dłużej niż pojedynczy limit wywołania terminala, więc należy użyć procesu monitorowanego i odczytać jego końcowy exit code oraz log.

## KRYTERIA AKCEPTACJI

1. Wykonać świeży pełny verify oraz smoke PKG-0094/0095 jako baseline.
2. Skonwertować Station 16..20 do Rówień Vector-Stage wraz z renderami i audytem kryteriów biblii.
3. Wdrożyć i przetestować przejścia/odblokowania kampanii między Station 15..20.
4. Zintegrować stan, poszlaki i dialog CRT z nowymi stacjami bez regresji zapisu schema 1.
5. Zaktualizować dokumentację i zamrozić PKG-0096.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0096 musi zostać zweryfikowany przez `tools/verify.ps1`, opisany w dokumentacji projektu i zamrożony poleceniem:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0096`.
