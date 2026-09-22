# PKG-0182 — creative idea ledger

Every candidate responds to a measured finding or coverage gap. `PROPOSED_FOR_IMPLEMENTATION` means owner-preapproved and therefore already implemented in this package; there is no accepted backlog.

| Axis | Candidate | Finding / measurable gap | Decision | Reason, rollback and evidence |
|---|---|---|---|---|
| Audio / sensory | Soft-headroom envelope for the eight clipping cues | PCM audit found 8 generators at full scale; 42C clipped 130 samples | `PROPOSED_FOR_IMPLEMENTATION` → `IMPLEMENTED` | Eight local return expressions use bounded `tanh(...)*0.94`; rollback is eight one-line patches. `audio/audio_measurements.tsv` now reports zero clipped samples and peak below full scale. This proves signal bounds, not that the mix sounds good. |
| UI / accessibility | Double mechanical notch beside an open, in-range threshold | Ready state used a cyan edge as its strongest distinguishing cue | `PROPOSED_FOR_IMPLEMENTATION` → `IMPLEMENTED` | Two 2 px notches supplement colour and remain visible in M3 mono. Rollback is one small `_draw_ready_notches` block. Runtime state test covers closed/open/busy and visual captures cover every address. |
| Space / image | Add a new anomaly prop to every family | No measured missing-family or target-visibility defect after the 22-address capture set | `REJECTED` | Would add clutter and accelerate strangeness without a finding; violates restraint and expands art scope. |
| Animation / movement | Generate extra anticipation frames for every NPC state | Existing 64x104 strips cover all seven presentation states and no pivot/foot mismatch was measured | `REJECTED` | Broad asset regeneration would be disproportionate and could alter identity; no measurable acceptance delta justified it. |
| Anchor / Yield | Add a second simultaneous anchor | Current single-anchor exclusivity is a tested core invariant | `REJECTED` | It would change mechanics, state and teaching rather than repair a gap; conflicts with scope and cheap rollback criteria. |
| Narrative / relationships | Add explanatory dialogue at Stations 09–13 naming the two-world mechanism | Chronology audit confirms the early-reveal ban; minimal route remains state-coherent | `REJECTED` | It would reveal ontology too early and solve spatial/interaction questions with exposition. |
| Game feel / haptic | Add compulsory vibration patterns for threshold readiness | No physical controller was available, and critical readiness already has visual geometry plus semantic interact | `REJECTED` | Cannot be validated on hardware and would make haptics carry redundant noise; mapping parity remains tested, physical ergonomics stays BLOCKED. |

