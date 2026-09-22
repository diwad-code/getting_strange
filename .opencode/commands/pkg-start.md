---
description: Session start checklist for a Getting Strange work package.
agent: build
---

Start the session in this order:

1. Read `AGENTS.md`, `docs/INDEX.md`, `docs/CURRENT_STATE.md`,
   `docs/NEXT_SESSION_PROMPT.md`, then the active spec and the files the
   prompt names.
2. Baseline: `pwsh -NoProfile -File .\tools\verify_docs.ps1` — record the
   result (expected: DOCS PASS, 52 files).
3. Confirm the last `PKG-NNNN` in `docs/SESSION_LOG.md` and the D-217 counter
   (full verify due at the latest in the package the handoff names).
4. Compare handoff claims against the files on disk; log any divergence in
   `SESSION_LOG.md` BEFORE editing. Runtime and fresh gates outrank history.

If the newest user instruction conflicts with the prompt or roadmap, name the
conflict and plan the doc updates — the user instruction wins.
