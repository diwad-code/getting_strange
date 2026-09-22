---
description: Run docs contract plus listed gates, one by one (D-217 scoped).
agent: build
---

Run scoped verification for these gate scripts: $ARGUMENTS
(each a res:// path, e.g. `res://tests/smoke_test.gd res://tests/traversal_lint_test.gd`).

1. First the docs contract: `pwsh -NoProfile -File .\tools\verify_docs.ps1`
2. Then EACH gate separately via the single-gate runner:
   `pwsh -NoProfile -File .\tools\run_gate.ps1 -Script '<gate>'`
   (one call per gate — this avoids the `@(...)` array-binding pitfall of
   calling `verify_scoped.ps1` via `pwsh -File`.)
3. If the blast radius touches shared monoliths
   (`memory_resonance_point.gd`, `mrp_legacy_renderer.gd`,
   `game_state_manager.gd`, `procedural_audio.gd`,
   `world_pixel_compositor.gd`, autoloads, base scenes/contracts), enums,
   serialize IDs, campaign routing, station thresholds or InputMap — STOP and
   run the full `/verify` instead (D-217).

Report each gate PASS/FAIL plus the one-sentence blast justification for
`SESSION_LOG.md`.
