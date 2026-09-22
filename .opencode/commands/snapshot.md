---
description: Freeze scenes/scripts/tests into snapshots/ for a closed package.
agent: build
---

Freeze the closed package (only after tests, CURRENT_STATE.md,
SESSION_LOG.md and NEXT_SESSION_PROMPT.md reflect the actual result):

`pwsh -NoProfile -File .\tools\snapshot.ps1 -Package $ARGUMENTS`

`$ARGUMENTS` is the package id (e.g. `PKG-0224`). The snapshot is a frozen
copy of `scenes/`, `scripts/`, `tests/` only — never read it back as current
state, and it does not protect against disk loss (R-017).
