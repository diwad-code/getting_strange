---
description: End-of-package checklist (tests, handoff docs, snapshot, report).
agent: build
---

A package is DONE only when all of these hold:

1. Code/data: goal met, out-of-scope range untouched.
2. Verification: fresh full `/verify` or `/verify-scoped` per D-217, exit 0.
3. Inspection: visual change has fresh `/capture` frames; gameplay change has
   runtime/playtest evidence fitting the claim.
4. State: `docs/CURRENT_STATE.md` replaced with the actual result incl.
   limitations and undone items.
5. Plan: `docs/ROADMAP.md` and the active spec updated if gate status changed.
6. Knowledge: decisions, risks, hypotheses, research updated on new evidence.
7. History: one `PKG-NNNN` entry appended to `docs/SESSION_LOG.md` (the only
   history — must suffice without this conversation).
8. Handoff: `docs/NEXT_SESSION_PROMPT.md` replaced with a prompt derived from
   the actual state, plus `docs/INDEX.md` header if the package says so.
9. Disk: everything saved immediately; freeze with `/snapshot PKG-NNNN`.
10. Report: result, tests run, limitations, package id, handoff path. State
    what the tests prove (contracts) and what stays OPEN-NO-EVIDENCE.
