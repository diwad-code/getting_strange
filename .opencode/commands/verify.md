---
description: Run the full Getting Strange verification (124 gates). Slow, authoritative.
agent: build
---

Run the full project verification from the project root:

`pwsh -NoProfile -File .\tools\verify.ps1`

It runs the docs contract plus all ~124 Godot headless gates with the log
policy (zero ERROR / SCRIPT ERROR / leaks). Mandatory for shared-monolith
touch, new contracts, checkpoints, and at least 1 in 5 packages (D-217).
Report exit code, failing gate names with their output, and the D-217
counter state. Never lower thresholds to get green.
