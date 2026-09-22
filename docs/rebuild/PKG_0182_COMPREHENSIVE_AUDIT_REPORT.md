# PKG-0182 / BUNDLE-32 — Comprehensive Game Audit & Evolution Report

**Package:** PKG-0182 / BUNDLE-32  
**Date:** 2026-09-03  
**Engine:** Godot 4.7.2.stable.official.ed1daf0bf  
**Renderer:** GL Compatibility  
**Hardware / driver:** Windows; OpenGL 3.3.0 Build 32.0.101.7085; Intel(R) Iris(R) Xe Graphics  
**Viewport / physics:** 640×360; 60 Hz  
**Verdict:** **TECHNICAL PASS** for the audit, repairs and recertification in this package. **PRODUCT GO** and **GATE-REL** remain blocked by D-168. Human fun, emotion, beauty and comprehension remain `OPEN-NO-EVIDENCE` (D-012, ADR-003).

This package was started in a previous Codex session that produced inventory, routes, captures, audio/performance matrices and the first repairs, then dropped before Phase H. This continuation verified those artefacts against disk, closed remaining P1/P2 gaps, recaptured frames after the last visual change, and froze the package.

---

## 1. Coverage

| Kind | Count | Notes |
|---|---|---|
| Inventory files | 898 | `rg --files` over `scripts/`, `scenes/`, `assets/`, `tests/`, `tools/`, `docs/`, plus `project.godot` and `export_presets.cfg` |
| Coverage rows | 951 | 898 files + 31 product surfaces + 22 active addresses |
| PASS | 708 | contract or measurement held |
| NOT_APPLICABLE | 242 | almost all Godot `.uid` metadata |
| BLOCKED | 1 | `physical_pad_ergonomics` — no controller attached |
| FINDING (open in coverage) | 0 | open defects live in `findings.tsv`; coverage reflects post-fix state |
| Empty status | 0 | |

Manifest: `reports/pkg_0182/coverage_manifest.tsv`.  
Inventory: `reports/pkg_0182/inventory.tsv`.

Historical PKG-0181 estimate (~190 scripts, 50 scenes, 154 tests, 221 assets, 186 tools, 82 docs) vs this inventory: 190 scripts, 50 scenes, 154 tests, 221 assets, 189 tools, 86 docs. The extra tools/docs are PKG-0182 harnesses and PHASE-10 documents, not silent product growth.

Conscious exclusions: `.godot/`, `reports/`, `snapshots/`, binary `dist/` artefacts, `archive_retired_web/` (D-098). Export presets and license files were audited without building an `.exe`.

---

## 2. Findings

| ID | Pri | Area | Class | Status |
|---|---|---|---|---|
| F-0182-001 | P1 | verifier / lifecycle | RUNTIME-MEASURED | FIXED |
| F-0182-002 | P1 | verifier / warnings | STATIC + negative mutation | FIXED |
| F-0182-003 | P3 | architecture | STATIC-INSPECTION | OPEN-BACKLOG |
| F-0182-004 | P2 | test sensitivity | CONTROLLED-MUTATION | FIXED |
| F-0182-005 | P2 | visual capture | RENDER-MEASURED | FIXED |
| F-0182-006 | P1 | verifier / coroutines | STATIC-INSPECTION | FIXED |

| Priority | Found | Fixed | Open |
|---|---|---|---|
| P0 | 0 | 0 | 0 |
| P1 | 3 | 3 | 0 |
| P2 | 2 | 2 | 0 |
| P3 | 1 | 0 | 1 |

Open P0/P1/P2 = 0.

### F-0182-001 — ObjectDB leaks ignored by a green verifier

Baseline `reports/pkg_0182/baseline.log` (1097 lines) ended `Verification passed.` while emitting **49** `ObjectDB instances were leaked at exit` lines (values 2–21 per gate; PKG-0180 reported 4). Root cause: Godot 4.7 AudioServer retains the last `AudioStreamPlaybackWAV` through CLI shutdown ([upstream #76745](https://github.com/godotengine/godot/issues/76745), accessed 2026-09-03); Dummy made it worse and the verifier ignored warnings. WASAPI alone still leaked two instances on PKG-0095. Fix: WASAPI on Windows headless, `ProceduralAudio.drain_playback`, cache clear, a 150 ms **headless-only** delay in `GameStateManager._exit_tree`, and fail-closed log policy. Isolated PKG-0095 retest: `LOG_POLICY_PASS`.

### F-0182-002 — warning policy was ERROR-only

`verify.ps1` previously treated non-zero exit and `ERROR` as the only fail conditions. `tools/godot_log_policy.ps1` now rejects `SCRIPT ERROR`, parser errors, ObjectDB/RID leaks, orphans and every `WARNING:` except two exact documented fallbacks (malformed campaign save; unsupported settings schema). Self-test: `tools/test_godot_log_policy.ps1`.

### F-0182-003 — donor monolith (backlog)

`scripts/interaction/memory_resonance_point.gd` remains a large historical donor. No unrelated behaviour was added. Extraction is P3 and would be a risky rewrite outside this package’s rollback budget.

### F-0182-004 — negative mutation of a critical gate

PKG-0180 mix-rate expectation was mutated `44100 → 99999`, produced seven errors and exit 1 (`reports/pkg_0182/negative_mutation_pkg0180.log`), then reverted exactly (`reports/pkg_0182/negative_mutation_revert_retest.log`, exit 0).

### F-0182-005 — identical `normal` / `key_object` frames

Station 01 spawn already sat at the first memory point, so both captures shared an MD5. `tools/capture_pkg_0182.gd` now places Lena at `ThresholdZone.aperture_rect`. Recapture: **22/22** active addresses have distinct `normal` vs `key_object` hashes. Example: Lena at spawn vs Lena at the Station 01 door.

### F-0182-006 — unawaited InputMap coroutine

`pkg_0182_smoke_test.gd` called `_test_inputmap_parity()` without `await`. Godot 4.7 emits `WARNING: The function … is a coroutine`, which the new policy would reject. Fixed by awaiting the coroutine and adding a JSON-safe malformed-save assertion that uses the allowlisted warning.

---

## 3. Implemented creative ideas

Ledger: `reports/pkg_0182/idea_ledger.md`. Owner pre-approval in D-198 covers every `PROPOSED_FOR_IMPLEMENTATION` mark. No accepted backlog.

| Idea | Axis | Before / after | Evidence class |
|---|---|---|---|
| Soft-headroom `tanh(…)*0.94` on eight clipping generators | Audio / sensory | 8 generators at full scale; 42C clipped 130 samples → **0 clipped samples**, peak below full scale on 256 measured generators | AUDIO-MEASURED |
| Two 2 px mechanical notches on an open, in-range threshold | UI / accessibility | Ready state used cyan edge as the strongest cue → notches remain in M3 mono and sit beside the door in interaction captures | RENDER-MEASURED + CONTRACT-PASS |

Rejected (filters 1–7): extra anomaly props; extra NPC anticipation frames; second simultaneous Anchor; early two-world exposition at 09–13; compulsory haptic patterns without hardware.

---

## 4. Runtime routes and mechanics

Player-verb traces (not direct scene method calls for the campaign path):

| Route | Finale | Sim seconds | Result | Evidence |
|---|---|---|---|---|
| Minimal (optional readings skipped) | 42B → 43 | 171.72 | PASS | `reports/pkg_0182/runtime_routes/minimal-b.tsv` |
| Full | 42A → 43 | 187.90 | PASS | `reports/pkg_0182/runtime_routes/full-a.tsv` |
| Mixed | 42C → 43 | 181.43 | PASS | `reports/pkg_0182/runtime_routes/mixed-c.tsv` |

3/3 finales A/B/C and Station 43 are covered. Shell, cold open, pause, settings, save/load, reset, PL/EN title, reduced motion (Station 14) and InputMap keyboard+pad injection are covered by capture and `tests/pkg_0182_smoke_test.gd`. Physical pad ergonomics stays `BLOCKED`.

Anchor/Yield: prototype lab captures for neutral, anchored and yield/correction. Campaign Anchor/Yield remains the existing Station 14+ contract; this package did not invent a second mechanic.

JSON-safe save: writing `{not valid json` is rejected, leaves a clean campaign, and emits the allowlisted warning only.

---

## 5. Visual, animation, text, audio, performance

**Visual.** 97 normal-driver frames (`reports/pkg_0182/capture.log`: `PKG-0182 CAPTURE PASS`). Every active address has `normal`, `key_object`, `interaction`, `m3_mono`; plus shell PL/EN, settings, pause, cold open, Station 14 reduced motion, Anchor/Yield trio. Heuristic art-direction review is labelled `HEURISTIC` in `visual_matrix.tsv` and does **not** claim human beauty.

**Animation.** 65 character rasters inventoried; strips in `reports/pkg_0182/animation/`. Rig frames remain 64×104, pivot (32, 96). Walk/run/climb marked strip-inspected; single poses `NOT_APPLICABLE` for loop seams.

**Text.** 1291 extracted candidates in `language_ledger.tsv` (741 `pl`, 472 `und` / mixed identifiers). Node-path false positives (`Geometry/Floor`) were filtered on the second pass. No global replace. Semantic edits were not required after orthography review against [RJP PAN rules effective 2026-01-01](https://rjp.pan.pl/zasady-pisowni-i-interpunkcji-polskiej-2/). Chronology: Stations 01–13 remain pre-mechanic-reveal. Human comprehension of the cold open is still `OPEN-NO-EVIDENCE` (H-049).

**Audio.** 256 `create_*` generators inventoried. 256 no-required-arg generators measured: **0 clipped samples**, peak < 1.0, DC offset gated at 0.05. Buses recorded in `audio/buses.tsv`. Technical meters are not a mix-quality claim.

**Performance.** Workstation baselines on the Intel Iris Xe / GL Compatibility path, 90 samples/station, vsync off: p50 1.62–3.23 ms, p99 2.98–6.40 ms. These are `MEASURED-BASELINE`, not a universal 16.667 ms budget. 3-cycle soak of 22 active scenes: object count after each cycle returned to 1991; sound cache 0 after clear; save/reload and pause/resume PASS. No rising trend in the three cycles.

---

## 6. Skill usage

| Skill | Path | Influence | Limitation |
|---|---|---|---|
| planning-and-task-breakdown | `skills/planning-and-task-breakdown/SKILL.md` | Phases A–H, then Phase H closeout after the Codex drop | Plan-mode “human approval” skipped under D-085 / D-198 |
| full-review | `skills/full-review/SKILL.md` | Warning policy, test integrity, architecture | Skill is multi-agent/web-oriented; applied as a review rubric only |
| godot-auditor | `skills/godot-auditor/SKILL.md` | ObjectDB/lifecycle, leak fail-closed, no monolith growth | Written for Godot 4.6 encyclopedia; 4.7 docs used as the live source |
| game-qa | `skills/game-qa/SKILL.md` | Routes, negative mutation, soak | **SKILL-ADAPTED** — Playwright/web flow forbidden by D-098 |
| design-review | `skills/design-review/SKILL.md` | Visual heuristic columns | Heuristic, not a human art jury |
| player-ux | `skills/player-ux/SKILL.md` | Non-colour threshold affordance (XAG 103 / colour-not-only) | No external playtest |
| maximizing-game-feel | `skills/maximizing-game-feel/SKILL.md` | Rejected extra juice that would fight D-099 / clutter | Feel remains `OPEN-NO-EVIDENCE` |
| godot-debugging | `skills/godot-debugging/SKILL.md` | Dummy audio leak, unawaited coroutine warning | — |
| godot-performance-optimization | `skills/godot-performance-optimization/SKILL.md` | `Performance` monitors, soak deltas, no invented frame budget | Workstation-only |
| creating-godot-procedural-audio | `skills/creating-godot-procedural-audio/SKILL.md` | PCM peak/clip/DC, local tanh headroom | Meters ≠ mix quality |
| emotional-narrative | `skills/emotional-narrative/SKILL.md` | Forbade emotion PASS from captures | Explicit `OPEN-NO-EVIDENCE` |
| polska-proza-gamedev | `skills/herald-narrative-editor-codex-skill/references/polska-proza-gamedev/SKILL.md` | Orthography / register scan of extracted PL strings | HERALD voice bible was not applied |
| natural-dialogue-techniques | — | **SKILL-BLOCKED** (not present under that name) | Used continuity tracker + DIALOGUE_SCRIPT instead |
| game-ui-ux | — | **SKILL-BLOCKED** as that exact name; `player-ux` + `design-review` used | — |
| imagegen | — | Not used; no new raster generated | Existing frames inspected as references |

`.github/skills/README.md` reports no skills installed there; project skills live under `skills/` and are `.gdignore`d from Godot.

---

## 7. Research

Ledger: `reports/pkg_0182/research_ledger.md`. Live sources accessed 2026-09-03:

- Godot 4.7 ObjectDB profiler, profiler, SpriteFrames, pixel-art filtering
- Godot issue #76745 (audio shutdown retain)
- Xbox Accessibility Guidelines 3.2 (pages updated 2026-08-14), XAG 103 / 117
- WCAG 2.2 as contrast/motion *reference only* — no desktop WCAG-compliance claim
- Rada Języka Polskiego PAN spelling rules effective 2026-01-01
- PKP PLK Iet-2 and WR-D-43-3 glossary for `sieć trakcyjna` / `torowisko`

---

## 8. Evidence classes (do not collapse)

| Class | What this package may claim |
|---|---|
| RUNTIME-MEASURED | Routes, soak object counts, InputMap injection, JSON fallback, leak counts |
| RENDER-MEASURED | 97 frames, distinct key_object hashes, notch visibility in interaction/M3 |
| AUDIO-MEASURED | 256 PCM rows, 0 clips, bus table |
| TEXT-AUDITED | 1291 ledger rows, no global replace |
| CONTRACT-PASS | Threshold ready-state, 20/20 player-verb routes, verifier policy self-test |
| RESEARCH-SUPPORTED | WASAPI + fail-closed policy; XAG additional-channel notches |
| HEURISTIC | Art-direction columns in `visual_matrix.tsv` |
| OPEN-NO-EVIDENCE | Fun, fear, beauty, mix “sounds good”, human understanding of the opening |
| BLOCKED | Physical controller ergonomics |

---

## 9. Limitations

- No external playtests (D-012, ADR-003).
- No physical gamepad on this workstation.
- Snapshot tool copies `scenes/`, `scripts/`, `tests/` only; plan, report, reports and handoff are copied into the snapshot directory as a documented extra freeze.
- `snapshot.ps1` is not a backup off the machine (R-017).
- Headless WASAPI is a verification driver override, not a claim about every player’s audio device.
- Language ledger still contains some non-player strings (identifiers with spaces); they are candidates, not a proof that a human saw them.
- Codex session transcript was not recoverable; continuation used disk artefacts as the only state.

---

## 10. Tests, logs, snapshot

| Artefact | Path |
|---|---|
| Baseline (pre-repair, 49 ObjectDB lines) | `reports/pkg_0182/baseline.log` |
| Final full verifier | `reports/pkg_0182/final.log` — `Verification passed.`, 1009,4 s, 1020 linii, 0 ObjectDB/RID leaks |
| Smoke + soak + JSON | `reports/pkg_0182/pkg_0182_smoke_probe.log` |
| Capture | `reports/pkg_0182/capture.log` |
| Negative mutation | `reports/pkg_0182/negative_mutation_pkg0180.log` / `negative_mutation_revert_retest.log` |
| Handoff | `docs/NEXT_SESSION_PROMPT.md` → PKG-0183 / `docs/PLUS_SESSION_PROMPT_2_A.md` |
| Snapshot | `snapshots/PKG-0182-2026-09-03/` |

Commands:

```powershell
pwsh -NoProfile -File .\tools\verify_docs.ps1 -ProjectRoot (Get-Location)
pwsh -NoProfile -File .\tools\verify.ps1
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0182
```

No web surface, no Git, no new `.exe`. GATE-REL remains BLOCKED (D-168).
