---
description: Fast docs-contract baseline before edits (52 files).
agent: build
---

Run the documentation contract baseline from the project root and record the
result before any edit:

`pwsh -NoProfile -File .\tools\verify_docs.ps1`

Expected: `DOCS PASS: 52 required files and handoff contracts`. Any failure
blocks the package until fixed.
