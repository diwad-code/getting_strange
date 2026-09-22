---
description: Capture fresh frames with the normal display driver (never headless).
agent: build
---

Capture frames with the NORMAL Windows display driver (headless hangs on
`frame_post_draw`):

`godot --path . --script res://tools/capture_preview.gd $ARGUMENTS`

`$ARGUMENTS` is an optional subset flag (e.g. `--pkg0223`); omit for the full
set. Per-package scripts live at `tools/capture_pkg_*.gd`. Inspect the fresh
PNGs in `reports/` at 100% before judging, and report HOLD vs repair with
frame names. Captures prove the rendered contract only.
