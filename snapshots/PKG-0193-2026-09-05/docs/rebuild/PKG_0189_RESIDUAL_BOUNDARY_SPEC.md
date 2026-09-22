# PKG-0189 — P3 residual-boundary audit and execution specification

**Date:** 2026-09-04  
**Scope:** F-0184-010 (`MemoryResonancePoint`) and F-0184-012 (Station 10–13).  
**Disposition:** evidence inventory and a bounded implementation map only. This package does not edit the MRP monolith, Station 10–13 gameplay, colliders, thresholds, InputMap, campaign routing, viewport, physics, assets, release or exports.

## 1. Evidence boundary

This report distinguishes source and scene facts from future work. The PKG-0189 test is a static inventory: deleting an enumerated API, current bridge, legacy namespace, absence condition, or this specification marker turns it RED. It does **not** prove that a future refactor improves the product, fun, emotion, visual quality, player comprehension, or PRODUCT GO.

Historical baseline PASS is recorded by PKG-0188. The fresh baseline invocation in this package exceeded the session tool's 30-second process window, so it is not represented as a new PASS or FAIL observation. The required final verifier is run after the changes below.

## 2. F-0184-010 — `MemoryResonancePoint` evidence inventory

| Fact | Evidence in current source |
|---|---|
| Identity and size | `scripts/interactables/memory_resonance_point.gd` is `class_name MemoryResonancePoint`, extends `Area2D`, has **10,193** lines and **221** functions. |
| Stable serialized type space | `PropType` has **203** explicitly numbered values `0..202`; sentinels are `PHOTOGRAPH=0`, `DOOR_CARD_READER=5`, `STAIR_TIMER_SWITCH=24`, `STATION_41_EXIT=196`, `EPILOGUE_FINAL_BLACKOUT=202`. Scene values serialize the numbers, so renumbering is a compatibility break. |
| Surface and state | Eight exports: `resonance_id`, `prop_type`, `prop_title`, `prop_subtitle`, `interaction_radius`, `is_activated`, `is_one_shot`, `shadow_progress`; state includes range/contact, pulse/flash, audio, haptic and particles. `is_activated` emits `state_changed`. |
| Signals and public calls | `resonance_triggered(id, prop_type)`, `state_changed(is_active)`; externally useful methods are `get_contact_progress`, `get_touch_flash`, `trigger_interaction`. `trigger_interaction` collects `resonance_id` through `GameStateManager` before prop-specific activation. |
| Runtime footprint | 37 legacy station scenes reference the script and contain 155 `resonance_id` instances. Node groups are not part of its current contract. |
| Responsibilities | One file creates collision/audio/particles; owns range and semantic `interact`; selects/plays procedural/haptic audio; controls visual state; dispatches 203 render routes; draws **206** `_draw_*` functions plus reticule/resolution/contact overlays. |
| Existing bridge | Station controllers connect `resonance_triggered` then set `prop.is_activated` and emit their own `clue_inspected`; Station 10–13 use this exact bridge. |

### Minimal extraction boundary, not an implementation

The first MRP package must preserve the `Area2D` façade, enum numeric values, all eight exports, signal ordering, clue collection, input/range handling, haptics and overlays. Extract only a renderer family as a stateless helper receiving the façade CanvasItem and read-only visual state. The initial candidate is the contiguous legacy donor range `PropType 67..196`; the façade keeps `_draw()` dispatch and `_draw_contact_read`, `_draw_in_world_reticule`, `_draw_resolved_mark`.

Do **not** extract audio selection, activation logic, particles, serialized enum values, or the Station 10–13 bridge in that first package. A renderer helper must not become a second interaction system.

### Required migration tests

1. Preserve the static contract inventory in `pkg_0189_boundary_inventory_test.gd`, with revised counts only when a deliberate, documented renderer migration changes them.
2. Instantiate default, switch and one-shot MRP points; prove clue collection, activation semantics, `resonance_triggered` cardinality and `state_changed` transitions.
3. Preserve PKG-0140 contact/haptic checks and add renderer-dispatch coverage for one type per extracted range at inactive, in-range and active state.
4. Load Station 10–13 and trigger each actual MRP node rather than calling their station methods directly; assert each existing bridge still writes its level decision and resolves the prop.
5. Run the existing PKG-0182 instantiate/interact/free soak and the fail-closed log policy.

## 3. F-0184-012 — Station 10–13 evidence inventory

`CAMPAIGN_MAP.md` assigns Station 10 Marta's independent day and boundary, 11 an institutional biometric/public record, 12 Jakub's control questions/meeting/refusal, and 13 an explicit three-family synthesis. Stations 10 and 13 may have no physical obstacle; every address has at most three meaningful interactions.

| Station | Current P9 bridge and state | Residual P7 hybrid fact | Canonical-map gap |
|---|---|---|---|
| 10 | Three MRP nodes call `perform_home_task`, `hear_marta_day`, `accept_marta_boundary`; write `p9.mystery.marta.*` and trace `independent_day_with_boundary`. | Callable `inspect_key_wear` → `test_key_without_claiming_home` → `commit_cautious_entry` writes `p7.foreign_daily_life.*`; `pkg_0100` calls it directly. | Does not write `marta_relationship_disclosed`, `marta_memories_conflict`, `marta_boundary_accepted`. |
| 11 | Three MRP nodes call `present_identity_card`, `read_186_day_record`, `request_minimal_report`; write `p9.mystery.institution.*`. | `HallwaySideboard` and private-photo chain remain callable and write `p7.foreign_daily_life.*`. | Does not write `local_lena_ucp_profile_found`, `parallel_test_trace_found`, `jakub_public_history_verified`, `recognition_evidence_public`. |
| 12 | Three MRP nodes call `ask_jakub_control_questions`, `meet_jakub`, `accept_jakub_refusal`; write `p9.mystery.jakub.*`. | Balcony/message/caller chain remains callable and writes `p7.marta_threshold.*`. | Does not write `jakub_voice_heard`, `jakub_met_as_person`, `recognition_evidence_relational`. |
| 13 | Three MRP nodes mark two sources then call `synthesize_world_difference`; it writes `world_recognized` and `p9.mystery.synthesis.trace`. | Drawer/document/request chain remains callable and writes `p7.marta_threshold.*`. | Does not write `recognition_evidence_carried` or `local_lena_search_committed`; current synthesis requires only three P9 traces, not all source markers. |

The four scenes have deliberate `AirlockZone` callbacks that are `pass`; campaign `ThresholdZone` owns address departure. Do not rewrite those callbacks or campaign routing in the repair packages.

## 4. Minimal dependency-ordered repair map

### PKG-0190 — canonical-fact alignment for the active 10–13 route

**Scope:** `station_10.gd` through `station_13.gd`, one dedicated player-verb/persistence test, `pkg_0160_smoke_test.gd`, `pkg_0177_smoke_test.gd` only where its route assertions need canonical facts, and handoff documents. No MRP edits, scene rebuilds, colliders, thresholds or route changes.

**Contract:** retain each existing three-node MRP bridge. At the successful semantic action, write the map's canonical facts in addition to the current P9 detail keys. Station 13 must require all three prior canonical evidence families plus the two local source markers before an explicit synthesis writes `world_recognized` and `local_lena_search_committed`. `recognition_evidence_carried` must be written by the materially appropriate Station 13 source action, not fabricated on scene entry.

**Acceptance and tests:** each step first fails before its prerequisite; actual MRP `trigger_interaction()` completes the route without direct station helper calls; all 13 canonical facts have the specified owner; save/reload retains them; failed Station 13 synthesis writes neither terminal fact; the route gate remains a player-verb test. The package must not remove P7 methods or geometry.

### PKG-0191 — retire the callable P7 surface from Station 10–13

**Depends on:** PKG-0190 GREEN.

**Scope:** only the four station scripts, superseded P7 assertions/call-sites and migration tests. Decide explicitly for `HallwaySideboard`, `BalconyDoor` and `DeskDrawer`: retain as a newly justified P9 diegetic element or remove from active logic. Never leave them as unnamed P7 mechanics.

**Acceptance and tests:** no active 10–13 writer/callable path uses `p7.foreign_daily_life.*` or `p7.marta_threshold.*`; legacy save migration is idempotent and never invents P9 facts; current P9 MRP route and save/reload remain GREEN; no collider, InputMap or threshold change occurs incidentally.

### PKG-0192 — MRP renderer-family extraction pilot

**Depends on:** PKG-0190 GREEN; independent of PKG-0191 if it does not touch its scenes.

**Scope:** façade plus one renderer helper for `PropType 67..196`, migration tests listed in section 2, and no gameplay/state/API change.

**Acceptance and tests:** serialized sentinel values, all exports/signals, clue-before-activation ordering, haptics and overlays remain equivalent; every extracted type dispatches exactly once; full verifier and log policy are GREEN. No claim that the monolith is fully resolved is permitted: remaining interaction/audio and non-pilot renderer ranges stay tracked.

## 5. Risks and decision

- The highest migration risk is silent scene serialization breakage from renumbering `PropType`; preserve explicit numeric values.
- The highest route risk is substituting canonical flags by direct test setup; the player-verb test must use the actual MRP bridge.
- The highest scope risk is mixing F-010 structural extraction with F-012 narrative-state repair; packages above isolate them.
- No automatic gate proves a reception claim. F-0184-010 and F-0184-012 remain P3 technical debts until their respective implementation packages have their own evidence.

**Decision D-205:** implementation proceeds in the order PKG-0190 → PKG-0191, with PKG-0192 independent after 0190. This is a dependency decision, not PRODUCT GO or release authorization.