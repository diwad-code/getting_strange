# Getting Strange: Licencje i manifest źródeł

Wersja: **1.0.0 (Release Candidate 1)**  
Data: 2026-08-25  
Silnik: Godot Engine 4.7.stable.official.5b4e0cb0f  

---

## 1. Prawa autorskie i licencja gry

**Getting Strange**  
Copyright © 2026 Getting Strange Team. Wszelkie prawa zastrzeżone / All Rights Reserved.

Kod źródłowy gry, sceny, projekt poziomów, narracja, scenariusz dialogów, systemy mechanik (Anchor/Yield), systemy prowadzenia gracza (`NarrativeGuidanceService`), kompozytory obrazu (`WorldPixelCompositor`, `CrispDiegeticText`, `InnerThoughtSurface`), architektura stanu (`GameStateManager`) oraz oprawa artystyczna Rówień Pixel-Stage stanowią autorską własność twórców projektu.

---

## 2. Architektura bezassetowa (Zero-Asset Architecture) i brak zewnętrznych zasobów binarnych

Projekt *Getting Strange* został zaprojektowany i wykonany w oparciu o zasady czystej syntezy wektorowej i proceduralnej:

- **Proceduralny dźwięk (Zero-Asset SFX)**:  
  Wszystkie 70+ efektów dźwiękowych, szumów tła, rezonansów pamięci, trzasków aparatów bakelitowych, nośnych 740 Hz, syren, interkomów i dronów epilogu jest syntezowanych w locie w GDScript (`scripts/audio/procedural_audio.gd`) poprzez bezpośrednią kalkulację buforów PCM (`AudioStreamWAV`). W projekcie nie wykorzystano żadnych zewnętrznych sampli, nagrań ani bibliotek audio osób trzecich.

- **Proceduralny i wektorowy obraz (Pixel-Stage Vector Synthesis)**:  
  Wszystkie elementy świata, geometrie, postać Leny (`LenaVisualRig`), rekwizyty rezonansowe, oświetlenie lamp diegetycznych i kompozycje stacji 01–43 są renderowane w czasie rzeczywistym za pomocą wektorowych prymitywów 2D (`VectorStageStyle`) i rzutowane na siatkę kompozytora 320x180 (`WorldPixelCompositor`). W projekcie nie wykorzystano zewnętrznych tekstur, atlasów bitmapowych ani generowanych przez AI zewnętrznych obrazów (zgodnie z `VISUAL_DESIGN.md`).

---

## 3. Silnik Godot Engine i komponenty zależne

Gra została zbudowana przy użyciu silnika **Godot Engine** (wersja 4.7).

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
- **Architektura technologiczna i rendering**: Godot 4.7 GL Compatibility, Rówień Pixel-Stage 640x360 / 60 Hz
- **Synteza audio**: Procedural Waveform & Harmonic Synthesizer (GDScript)
- **Dostępność i lokalizacja**: Bilingual Shell & Subtitles (Polski / English)
