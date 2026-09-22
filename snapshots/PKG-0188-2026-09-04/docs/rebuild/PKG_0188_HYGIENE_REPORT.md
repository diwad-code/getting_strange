# PKG-0188 — P3 verifier/audio/locale hygiene

**Package:** PKG-0188  
**Date:** 2026-09-04  
**Scope:** only F-0184-008, F-0184-009 and F-0184-011 from
`PKG_0184_FINAL_CERTIFICATION_REPORT.md`.

## Findings and disposition

| Finding | RED evidence | Repair | GREEN evidence | Status |
|---|---|---|---|---|
| F-0184-008 | `pkg_0091` required Vector-Stage on Station 05. `pkg_0094` discarded its save with `reset_campaign(false)` and required Vector-Stage on 06–08. | The smoke tests retain concrete campaign-state and P9 scene contracts: a proper save/reload cycle plus `WorldPixelCompositor`, CRT cue surface, atmosphere, player/floor where applicable. Both are live gates in `verify.ps1`. | Independent Windows/WASAPI: `PKG-0091 SMOKE PASS`; `PKG-0094 SMOKE PASS`. | **FIXED** |
| F-0184-009 | `ProceduralAudio` had 236 factory `clampf(raw, -1, 1)` returns and seven duplicate exact `tanh(raw) * 0.94` returns before export. | Removed those export-boundary clamps. `generate_wav()` alone applies `clampf(tanh(raw) * 0.94, -1, 1)` immediately before `encode_s16`. Other local nonlinear timbre shaping remains authored sound design, not PCM limiting. | The hygiene test sends raw `4.0`; decoded PCM is about `0.94`, not pre-clamped `tanh(1) * 0.94` ≈ `0.716`. | **FIXED** |
| F-0184-011 | The active inventory finds one CSV: `resources/localization/getting_strange_locales.csv`, plus import/PL/EN artefacts. It still says `[C / SHIFT]`; project and runtime do not route to it. | **RETIRED**, not registered. The file and importer outputs stay on disk as auditable donor evidence; runtime localization remains the PL/EN `LocalizationManager` dictionary. | Hygiene test verifies artefacts, stale binding, absent routing, and live `MENU_NEW_GAME` values in PL/EN. | **RETIRED (auditable)** |

## Guardrail and scope

`godot_log_policy.ps1` remains fail-closed. No warning was allowlisted, assertion
removed, or test skipped. `verify.ps1` adds only green gates: `pkg_0091`,
`pkg_0094`, and `pkg_0188_hygiene`.

Untouched: `memory_resonance_point.gd` (F-0184-010), Station 10–13 hybrid
content (F-0184-012), visual assets, colliders, thresholds, InputMap, viewport,
physics, release/export, web, and Git. This is technical evidence only, not
audio quality, comprehension, emotion, PRODUCT GO, or release readiness.