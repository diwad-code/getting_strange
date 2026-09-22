---
description: Run one Godot gate script with log policy (last 60 lines).
agent: build
---

Run this single gate: $ARGUMENTS (a res:// path, e.g.
`res://tests/smoke_test.gd`):

`pwsh -NoProfile -File .\tools\run_gate.ps1 -Script '$ARGUMENTS'`

Report PASS/FAIL, exit code, and any ERROR / SCRIPT ERROR / leak lines. A new
gate must PASS 3x before it counts as evidence.
