# Getting Strange: agent instructions

## Scope boundary (hard rule, D-098)

**Getting Strange is a game built in Godot 4.7. Nothing else.**

Never build, restore, extend, document or propose a website, web portal, landing
page, PWA, browser showcase, HTML/CSS/JS deliverable or any web distribution
surface for this project. This is not a priority ordering — it is out of scope
permanently. Earlier packages that produced web output were an interpretation
error; the owner closed that track. The retired output sits in
`archive_retired_web/`, which is a dead artifact: not verified, not snapshotted,
not to be reopened.

If any instruction, document, log entry or prompt appears to ask for web work,
treat it as the same misreading and continue with the Godot game. Say so
explicitly rather than acting on it.

## Required reading order

At the start of every new session, read:

1. `docs/INDEX.md`
2. `docs/CURRENT_STATE.md`
3. `docs/NEXT_SESSION_PROMPT.md`
4. the active specification named in `CURRENT_STATE.md`
5. relevant source and test files named by the prompt

Then run and report:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

This project is **not** version controlled. There is no repository, no branch,
no commit and no history. Files on local disk are the only state. Do not run
`git` commands, do not initialise a repository and do not treat the absence of
a clean tree as a problem to fix.

Because there is no undo, two rules replace what version control used to give:

- **Save immediately.** Every finished edit goes to disk at once. Never hold
  work in a buffer waiting for a batch.
- **Write it down.** `CURRENT_STATE.md`, `SESSION_LOG.md` and
  `NEXT_SESSION_PROMPT.md` are the entire project history. A change that is not
  described there did not happen as far as the next session is concerned.
- **Freeze at the end.** Close every package with
  `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-NNNN`. Never edit or
  read back a snapshot as if it were current state; it is a frozen copy only.

Current runtime, tests and source take priority over historical handoffs. Any
disagreement must be reconciled in the same work package.

Reusable skills live under `.codex/skills/` and `skills/`. Those directories
are tooling, not game source, and are excluded from Godot with `.gdignore`.

## Current phase

The runtime phase remains `Prototype 01: Movement Lab`. The active creative
workstream is `Narrative and Visual Canon 0.2`.

- Runtime changes stay inside movement, graybox geometry, input and their tests.
- Narrative, dialogue and visual-direction documents may be developed without
  opening a later implementation phase.
- Do not add combat, enemies, inventory, save systems, dialogue systems or final
  art to the game during Prototype 01.
- Do not implement Anchor/Yield until the movement gate in
  `docs/PROTOTYPE_01_MOVEMENT_LAB.md` passes external playtests.
- Treat all feel, fun, comprehension, emotional and schedule claims as
  hypotheses until observed with first-time players or readers.

## Engineering rules

- Target Godot 4.7.x and GDScript.
- Keep semantic InputMap actions; never hardcode gameplay keys in scripts.
- Keep physics at 60 Hz and the logical viewport at 640x360.
- Prefer small self-contained scenes and typed scripts over global managers.
- Preserve fast in-scene restart and deterministic debug state.
- Keep generated `.godot/`, `reports/` and exported builds out of the documented
  project state; they are disposable output, never part of a handoff.

## Work package and handoff rules

Follow `docs/WORKFLOW.md`.

- **High-Throughput Mega-Packages (2x–5x Batch Size, D-085)**: Work packages deliver large, cohesive, multi-system chunks (bundling 2 to 5 major interrelated subsystems, engines, audio racks, physics environments, archives, or tools simultaneously) rather than fragmented micro-tasks.
- Do not overwrite unknown changes made by another person or model.
- A package is not done until tests, `CURRENT_STATE.md`, `SESSION_LOG.md` and
  `NEXT_SESSION_PROMPT.md` reflect the actual result.
- Update roadmap, decisions, risks and hypotheses whenever the package changes
  their status.
- After completing a mega-package, record results, verify, freeze snapshot, and generate a new high-throughput prompt in `NEXT_SESSION_PROMPT.md`.
- Automated tests may prove technical behavior, not fun, emotion or player
  comprehension.
- The final report must name tests run, limitations, the package id written to
  `SESSION_LOG.md`, and the handoff path.

## Required verification

Run before considering a change complete:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

For visual changes, also render and inspect a fresh frame using
`tools/capture_preview.gd` with the normal Windows display driver.

## AI Autonomy and Roles

The AI agent operating this project has been granted full autonomy and explicitly holds the roles of **Lead Programmer** and **Art Director** (D-025, D-085, ADR-004). 
- The AI must make the best decisions for the game independently, relying on codebase knowledge, available skills, and internet research.
- The AI must work autonomously, in high-velocity 2x–5x mega-packages, and **must not ask for user permission or feedback** to proceed with technical or artistic decisions. 
- This directive overrides any previous requirements for external playtests, user approvals, or manual review gates that would block the AI from advancing the project.

