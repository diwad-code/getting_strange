# Prompt dla następnej sesji: PKG-0094 (Rówień Vector-Stage Akt I i Pętla Kampanii)

## CEL SESJI

Zgodnie z decyzjami **D-091 i D-092** — 100% prac na grze Godot 4.7 (`Getting Strange`), bez prac webowych. PKG-0093 ustanowił kanoniczny styl **Rówień Vector-Stage**: własne, płaskie wielokąty, ograniczoną paletę, asymetryczne sylwetki i sceniczne kadrowanie; historyczne *Another World / Out of This World* jest wyłącznie bezpiecznym odniesieniem do ogólnej techniki, nie wzorem do kopiowania.

1. **Pętla kampanii**: trwały zapis `user://`, schema version, bezpieczne odtworzenie, checkpoint restart i test reset/reload w `GameStateManager`.
2. **Menu gry**: CanvasLayer dla pauzy i wyboru 43 poziomów; tryb testowy dostępny, zwykła kampania respektuje odblokowanie.
3. **Rówień Vector-Stage, Akt I**: ręcznie skonwertować Station 06..10 według `VISUAL_DESIGN.md`; dla każdej sceny zapisać oś, negatywną przestrzeń, plan gry, 4–6 kolorów, akcent i rekwizyt-świadka. Nie używać cudzej palety, scen ani ikonografii.
4. **Integracja poziomów**: powiązać `MemoryResonancePoint`, D-019/D-020 i kluczowe CRT cues z API GameStateManager.
5. **Weryfikacja**: rozszerzyć testy o kontrakt Vector-Stage, uruchomić capture dla Act I i `pwsh -NoProfile -File .\tools\verify.ps1`; udokumentować oraz zamrozić PKG-0094.

Dozwolone i zalecane: aktywnie korzystać z uwierzytelnionego Picsart CLI `gen-ai`
oraz dostępnych kredytów do tworzenia wielu własnych wariantów kompozycji,
rekwizytów, referencji poz i materiałów dla Station 06..10. Zapisuj prompt,
model, datę i plik źródłowy; przeprowadzaj ręczną adaptację do Rówień
Vector-Stage i nie proś modelu o odtwarzanie *Another World* ani innej cudzej
chronionej ekspresji.

## SRODOWISKO I BASELINE

- Środowisko: Godot 4.7.stable na Windows, PowerShell 7, brak gita (D-016), stan wyłącznie na dysku.
- Rola AI: Pełna autonomia jako **Lead Programmer** oraz **Art Director** (D-025, D-085, D-089, D-091, ADR-004) — praca wyłącznie nad silnikiem gry Godot, bez prac webowych.
- Baseline: 43 przestrzenie istnieją; Station 01 ma pełny referencyjny kadr Rówień Vector-Stage, Station 01..05 mają warstwę `VectorStageEnvironment`, a `tests/pkg_0091_smoke_test.gd` sprawdza kontrakt.
- Weryfikacja obowiązkowa: `pwsh -NoProfile -File .\tools\verify.ps1`; pełny test trwa znacząco dłużej niż pojedynczy limit wywołania terminala, więc należy użyć procesu monitorowanego i odczytać jego końcowy exit code oraz log.

## KRYTERIA AKCEPTACJI

1. Wykonać świeży pełny verify i dedykowany smoke jako baseline.
2. Wdrożyć oraz przetestować trwały zapis, restart checkpointu, pauzę i level select.
3. Skonwertować Station 06..10 do Rówień Vector-Stage wraz z renderami i audytem kryteriów biblii.
4. Zintegrować stan, poszlaki i dialog CRT z istniejącymi stacjami.
5. Zaktualizować dokumentację i zamrozić PKG-0094.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Pakiet PKG-0094 musi zostać zweryfikowany przez `tools/verify.ps1`, opisany w dokumentacji projektu i zamrożony poleceniem:
`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0094`.
