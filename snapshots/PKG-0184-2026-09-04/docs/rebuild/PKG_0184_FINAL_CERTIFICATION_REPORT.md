# PKG-0184 / BUNDLE-34 — Final independent recertification

**Package:** PKG-0184 / BUNDLE-34  
**Date:** 2026-09-04  
**Engine:** Godot 4.7.2.stable.official.ed1daf0bf  
**Renderer:** GL Compatibility  
**Hardware / driver:** Windows NT 10.0.26200.0; 12th Gen Intel i5-1235U; Intel(R) Iris(R) Xe Graphics; OpenGL 3.3.0 Build 32.0.101.7085 (capture)  
**Viewport / physics:** 640×360; 60 Hz (pinned in `project.godot`)

## Multi-axis verdict

| Axis | Verdict |
|---|---|
| TECHNICAL CERTIFICATION | **PASS** |
| PRODUCT CONTRACT CERTIFICATION | **PASS** (M1 20/20 × 3 finales; 7 families still on the route; residual P3 content hybrid on 10–13) |
| EVIDENCE INTEGRITY | **PASS** (fresh `reports/pkg_0184/`; 0182/0183 untouched; 0183 inventory/report chronology documented, not inherited as complete) |
| HUMAN RECEPTION | **OPEN — NO EXTERNAL PLAYER EVIDENCE** |
| RELEASE | **BLOCKED BY D-168 — OWNER INSTRUCTION REQUIRED** |

PKG-0182 and PKG-0183 PASSes were hypotheses. This package re-ran the chain, falsified leftover locale/copy/log gaps, repaired P2, and recertified on a new namespace.

The prompt file on disk is `docs/PLUS_SESSION_PROMPT_2_B.mm` (the `.md` path does not exist). `docs/NEXT_SESSION_PROMPT.md` already held the same text.

---

## 1. Sequence and environment

| Item | Value |
|---|---|
| PKG-0182 snapshot | `snapshots/PKG-0182-2026-09-03/` (550 files, 2026-09-03T22:43:59) |
| PKG-0183 snapshot | `snapshots/PKG-0183-2026-09-03/` (536 files, 2026-09-03T23:52:15) |
| 0183 report vs final.log | report 21:23Z **before** final 21:50Z (`reports/pkg_0184/chronology.tsv`) |
| Concurrent writer | none in the 2 hours before start |
| Baseline | `pwsh -NoProfile -File .\tools\verify.ps1` → exit 0 in 1038.2 s; `reports/pkg_0184/baseline.log` |
| Baseline ObjectDB / SCRIPT ERROR | 0 |
| Baseline WARNING | 5, all allowlisted GameStateManager JSON/settings fallbacks |
| Inventory | **948** files (`reports/pkg_0184/inventory.tsv`); +13 vs 0183 |

0183's own report, `pkg_0183_smoke_test.gd` and capture/performance scripts were missing from the 0183 inventory (taken too early). 0184 lists them. That is an evidence-integrity finding about 0183, not a missing product file.

Conscious exclusions unchanged: `.godot/`, `reports/`, `snapshots/`, `archive_retired_web/`, `dist/` binaries, `skills/`, `godot-mcp/`, `vibe-eyes/`, playtest panels.

---

## 2. What 0184 falsified and repaired

| ID | Pri | What | Status |
|---|---|---|---|
| F-0184-001 | P2 | Title `ReturnPromise` hardcoded Polish under EN | FIXED |
| F-0184-002 | P2 | Cold-open skip `POMIŃ ▸` hardcoded | FIXED |
| F-0184-003 | P2 | Station 13 leftover “w terenie”; 10–12 leftover P7 openings | FIXED (openings only) |
| F-0184-004 | P2 | 0179 PASS with no step log even after `await` | FIXED (prints 1–6) |
| F-0184-005 | P2 | 0183 `get_child_count() >= 0` tautology | FIXED |
| F-0184-008 | P3 | `pkg_0091`/`pkg_0094` fail if run; not in `verify.ps1` | OPEN-BACKLOG |
| F-0184-009 | P3 | Many `create_*` still `clampf(raw)` before `generate_wav` tanh | OPEN-BACKLOG |
| F-0184-010 | P3 | `memory_resonance_point.gd` monolith | OPEN-BACKLOG |
| F-0184-011 | P3 | Unregistered CSV locale donor | OPEN-BACKLOG |
| F-0184-012 | P3 | Stations 10–13 gameplay still P7 hybrid vs `CAMPAIGN_MAP` | OPEN-BACKLOG |
| F-0184-013 | BLOCKED | Physical pad | BLOCKED |
| F-0184-014 | INFO | Playtest “black after NOWA GRA” | NOT REPRODUCED (cold_open luma 0.1024) |
| F-0184-015 | INFO | Playtest menu Wczytaj/Wyjście vs build | Brief drift; build is NOWA GRA/KONTYNUUJ/USTAWIENIA/ZAKOŃCZ |

Open **P0/P1/P2 = 0**.

TDD: `pkg_0184_smoke_red.log` 10 failures, then `pkg_0184_smoke_green.log` PASS.

---

## 3. Product flow (fresh)

Player-verb M1 via `pkg_0177 -- --pkg0184-route=` (not a copy of 0182/0183 folders):

| Route | Finale | Sim s | Result |
|---|---|---|---|
| full-a | 42A → 43 | 187.93 | PASS |
| minimal-b | 42B → 43 | 171.45 | PASS |
| mixed-c | 42C → 43 | 181.27 | PASS |

20/20 addresses on each trace. Shell `Nowa gra` → cold open → Station 01 is inside that path. `pkg_0177`'s fourteen-gate **dictionary remains a rollup**, not a measurement (C-0183-09 / C-0184-07). The M1 path is the contract evidence.

---

## 4. Visual, audio, soak, text

- **98** normal-driver frames, driver `Windows`, Iris Xe. 0 `normal`/`key_object` MD5 collisions. Cold open is not a black field (mean luma 0.1024). Extra frame vs 0183: `cold_open__t0.png`.
- Performance: 22 addresses, vsync off; p50 about 1.6–2.7 ms on this workstation. **MEASURED-BASELINE**, not a 16.667 ms product budget.
- Audio: 254 no-required-arg generators, **0 clipped**, peak < 1.0. Meters are not mix quality.
- Soak: three load/free cycles of 22 scenes; `object_count_after = 2000` stable; sound cache 0.
- Text: 173 extracted UI keys + opening lines (`reports/pkg_0184/text/visible_text_extract.tsv`). No global replace. New keys: `TITLE_RETURN_PROMISE`, `COLD_OPEN_SKIP`.

---

## 5. Negative controls

- Log policy self-test rejects SCRIPT ERROR, SCRIPT WARNING, ObjectDB, RID, orphan, unreviewed WARNING (`reports/pkg_0184/log_policy_retest.log`).
- 0184 smoke RED before the locale/opening fixes.
- `pkg_0091`/`pkg_0094` run independently and **fail** — they are not silently PASSed by absence from `verify.ps1`.

---

## 6. Commands

```powershell
pwsh -NoProfile -File .\tools\audit_pkg_0184.ps1
godot --headless --path . --script res://tests/pkg_0184_smoke_test.gd --audio-driver WASAPI
godot --headless --path . --script res://tests/pkg_0177_smoke_test.gd --audio-driver WASAPI -- --pkg0184-route=full-a
godot --path . --script res://tools/capture_pkg_0184.gd --audio-driver WASAPI
pwsh -NoProfile -File .\tools\verify_docs.ps1
pwsh -NoProfile -File .\tools\verify.ps1
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0184
```

Final verifier (after last source change): `reports/pkg_0184/final.log` — `Verification passed.` in 1013.7 s, exit 0; 7 allowlisted WARNING; 0 ObjectDB/SCRIPT ERROR; PKG-0184 and PKG-0179 (steps 1–6) in the chain.

`snapshot.ps1` copies only `scenes/`, `scripts/`, `tests/`. Docs, reports and this file are extra-frozen into the snapshot directory after the tool runs.

No web surface, no Git, no new `.exe`. **RELEASE: BLOCKED BY D-168.**
