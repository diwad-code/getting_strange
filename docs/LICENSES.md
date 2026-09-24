# Getting Strange: Licencje i manifest źródeł

Wersja powierzchni release: **P8 audit / PKG-0152**  
Data aktualizacji: 2026-08-31  
Silnik zweryfikowany przez `tools/verify.ps1`: Godot Engine v4.7.2.stable.official.ed1daf0bf  

---

## 1. Prawa autorskie i licencja gry

**Getting Strange**  
Copyright © 2026 Getting Strange Team. Wszelkie prawa zastrzeżone / All Rights Reserved.

Kod źródłowy gry, sceny, projekt poziomów, narracja, scenariusz dialogów, systemy mechanik (Anchor/Yield), systemy prowadzenia gracza (`NarrativeGuidanceService`), kompozytory obrazu (`WorldPixelCompositor`, `CrispDiegeticText`, `InnerThoughtSurface`), architektura stanu (`GameStateManager`) oraz oprawa artystyczna Rówień Pixel-Stage stanowią autorską własność twórców projektu.

---

## 2. Architektura bezassetowa (Zero-Asset Architecture) i manifest assetów obrazu

Fraza **Zero-Asset Architecture / Zero-Asset SFX** pozostaje prawdziwa dla warstwy dźwięku. Nie jest już prawdziwa jako opis całego obrazu runtime po PKG-0132..0151, dlatego sekcja rozdziela dźwięk, scenografię proceduralną i rasterowe assety postaci.

- **Proceduralny dźwięk (Zero-Asset SFX)**:  
  Wszystkie efekty dźwiękowe, szumy tła, rezonanse pamięci, blipy CRT, kroki i drony epilogu są syntezowane w locie w GDScript (`scripts/audio/procedural_audio.gd`) przez bezpośrednią kalkulację buforów PCM (`AudioStreamWAV`). Projekt nie wykorzystuje zewnętrznych sampli ani bibliotek audio osób trzecich.

- **Proceduralna scenografia i świat Pixel-Stage**:  
  Geometrie poziomów, oświetlenie, kompozytor świata, ostre warstwy tekstu i większość diegetycznych rekwizytów są rysowane lub składane proceduralnie w runtime (`VectorStageStyle`, `VectorStageEnvironment`, `WorldPixelCompositor`, `MemoryResonancePoint`).

- **Rasterowe assety runtime postaci i portretów**:  
  Bieżąca wersja gry używa własnych assetów PNG w `assets/characters/lena/`, `assets/characters/marta/`, `assets/characters/jakub/`, `assets/characters/wierzbicka/`, `assets/characters/vendor/`, `assets/characters/neighbour/` oraz `assets/characters/portraits/`. Obejmuje to klatki Leny 4.1 (64x104, pivot `(32, 96)`), stany prezentacyjne obsady na tym samym płótnie (`CharacterVisualRig`, PKG-0186) i 5 portretów CRT. Pipeline LANCZOS `process_npc_sprites.py` jest wycofany. Runtime ładuje je jako `Sprite2D` / `Texture2D`.

- **Pochodzenie i wyłączenia release**:  
  Materiały źródłowe procesu — m.in. `assets/characters/*/raw/`, `assets/characters/lena/_source_v40/` oraz logi robocze — nie są częścią bieżącej powierzchni release. Katalogi źródłowe są oznaczone `.gdignore`, a projekt nie deklaruje ich jako finalnych assetów dystrybucyjnych.

- **Brak cudzych sprite'ów i atlasów**:  
  Projekt nie wykorzystuje cudzych sprite sheetów, atlasów bitmapowych ani przejętych assetów z innych gier. Własne rasterowe klatki i portrety zostały przygotowane dla tego projektu i podlegają jego prawom autorskim.

---

## 3. Silnik Godot Engine i komponenty zależne

Gra została zbudowana przy użyciu silnika **Godot Engine** (zweryfikowany runtime: 4.7.2).

PKG-0242 (D-254): gra pokazuje te informacje sama — menu główne → **TWÓRCY I LICENCJE**
(`scripts/ui/credits_panel.gd`). Panel czyta licencję MIT, listę komponentów stron trzecich
i pełne teksty ich licencji z działającego silnika (`Engine.get_license_text()`,
`Engine.get_copyright_info()`, `Engine.get_license_info()`), więc build eksportowany
innym wydaniem 4.7.x pokaże teksty zgodne ze swoim silnikiem. Stacja 43 odsyła do menu
(„LICENCJE: MENU GŁÓWNE”) zamiast wyświetlać skrót licencji w świecie gry.

### Licencja Godot Engine (MIT)

```text
This software uses Godot Engine, available under the following license:

Copyright (c) 2014-present Godot Engine contributors.
Copyright (c) 2007-2014 Juan Linietsky, Ariel Manzur.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### Licencje bibliotek trzecich wkompilowanych w Godot Engine

1. **FreeType**  
   Portions of this software are copyright © 1996-2023 The FreeType Project (www.freetype.org). All rights reserved. (FreeType License / FTL).
2. **HarfBuzz**  
   Copyright © 2010-2024 Google, Inc., Behdad Esfahbod, Keith Stribley, Martin Hosken, Chris Wilson, Christian Biesinger, Soren Sandmann, Codethink Limited. (MIT License).
3. **ICU (International Components for Unicode)**  
   Copyright © 1991-2024 Unicode, Inc. All rights reserved. Distributed under terms of Unicode/ICU License.
4. **AccessKit**  
   Copyright © AccessKit contributors. Licensed under Apache 2.0 / MIT.
5. **zlib / libpng**  
   Copyright © 1995-2024 Jean-loup Gailly and Mark Adler / Glenn Randers-Pehrson.
6. **ENet / MbedTLS**  
   Copyright © 2002-2020 Lee Salzman / Arm Limited. (MIT / Apache 2.0).

---

## 4. Twórcy i napisy końcowe (Diegetic & Production Credits)

- **Reżyseria i projekt gry**: Lead Programmer & Art Director (Autonomia D-025, D-085, ADR-004, ADR-007)
- **Scenariusz i konstrukcja relacyjna**: Kanon 0.3 (`docs/narrative/NARRATIVE_BIBLE.md`, `FULL_STORY.md`, `DIALOGUE_SCRIPT.md`)
- **Architektura technologiczna i rendering**: Godot 4.7.2 GL Compatibility, Rówień Pixel-Stage 640x360 / 60 Hz
- **Warstwa postaci**: Lena 4.1 sprite runtime + rasterowe portrety CRT w `assets/characters/`
- **Synteza audio**: Procedural Waveform & Harmonic Synthesizer (GDScript)
- **Dostępność i lokalizacja**: Bilingual Shell & Subtitles (Polski / English)
- **Wymóg release**: publiczna paczka musi dołączyć ten manifest; bieżący runtime Station 43 pokazuje jego skróconą surface credits/licence, a pakiet build/rehearsal ma dopiero dowieść świeżych artefaktów poza edytorem.
