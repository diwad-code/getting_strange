# Prompt nastepnej sesji: PKG-0130

Wklej cala tresc tego pliku jako prompt otwierajacy nastepna sesje.

---

```text
Jestes agentem realizujacym projekt gry "Getting Strange" w Godot 4.7.
Twoja rola: Lead Programmer i Art Director (autonomia wg ADR-004 / D-025 / D-085).
Dzialasz w trybie Mega-Pakietu (2x-5x throughput).

CEL SESJI: PKG-0130 — Optymalizacja wydajności renderowania 60 Hz pod obciążeniem cząsteczek i kompozytora, certyfikacja spójności czasu klatki (frame timing consistency) oraz finalny raport release P5

SRODOWISKO I BASELINE:
- Godot 4.7.stable.official.5b4e0cb0f pod Windows (PowerShell/pwsh).
- Brak Gita; stan wylacznie na dysku (D-016).
- Architektura Zero-Asset (czysta synteza GDScript, 0 zewnetrznych assetow audio/grafiki).
- 43 stacje kampanii (01..41, 42a, 42b, 42c, 43), w 100% drożne geometrycznie i certyfikowane w PKG-0129.
- BEZWZGLĘDNY ZAKAZ tworzenia nowych plików .exe i paczek binarnych po pakiecie (D-098 & dyspozycja użytkownika).
- Weryfikacja bazowa: pwsh -NoProfile -File .\tools\verify.ps1 (musi zwrocic exit code 0).

KRYTERIA AKCEPTACJI:
1. Profiling czasu klatki (Frame Timing & Frame Budget Certification):
   - Weryfikacja stabilnego budżetu renderowania (16.66 ms / 60 Hz) na wszystkich 45 scenach kampanii pod obciążeniem WorldPixelCompositor (CanvasLayer 5), wieloprofilowego AtmosphereRig (światła wektorowe + cząstki VentSteam i VolumetricDust) oraz warstw UI (CanvasLayers 10, 16, 20, 100, 110);
   - Zapewnienie deterministycznego usuwania wygasłych instancji cząstek i zapobieganie spadkom płynności w Stacjach 34-37 (komory maszynowe o gęstej parze) oraz Stacjach 40-42 (komory oświetleniowe finałów).
2. Pacing i kinowa płynność kamery:
   - Audyt CinematicCamera (wygładzanie śledzenia Leny przy przejściach pionowych drabin i wind bez szarpania pikseli integer-grid);
   - Potwierdzenie braku desynchronizacji między pozycją fizyczną gracza a warstwą pikselizacji kompozytora.
3. Testy automatyczne i certyfikacja:
   - Utworzenie tests/pkg_0130_smoke_test.gd weryfikującego stabilność framerate, budżety obiektów i brak dryfu pozycji kamery;
   - Podłączenie nowej bramki do tools/verify.ps1 i potwierdzenie czystego exit code 0.
4. Zamknięcie fazy P5 i finalne zamrożenie snapshotu.

KONIEC PAKIETU JEST OBOWIAZKOWY:
1. Aktualizacja CURRENT_STATE.md, ROADMAP.md, RISKS_AND_HYPOTHESES.md, SESSION_LOG.md.
2. Przygotowanie nowego promptu w NEXT_SESSION_PROMPT.md.
3. Zamrozenie snapshotu: pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0130.
```
