# PKG-0183 research sources

Accessed 2026-09-03. Independent of PKG-0182 ledger.

| Question | Source | Date | Applicability |
|---|---|---|---|
| Default physics tick rate | Godot 4.x `Engine.physics_ticks_per_second` default `60`; ProjectSettings `physics/common/physics_ticks_per_second` default 60. Docs: https://docs.godotengine.org/en/stable/classes/class_engine.html | 2026-09-03 | Current `project.godot` omits the key; runtime still 60 only because of engine default. Pin the setting. |
| Audio WAV retain at shutdown | Godot issue #76745 (AudioServer retains last AudioStreamPlaybackWAV). https://github.com/godotengine/godot/issues/76745 | 2026-09-03 | Explains headless ObjectDB leaks; drain must cover looping streams and `finished` reconnects, not only `stop()`. |
| Colour not the only cue | Xbox Accessibility Guideline 103 (colour). https://learn.microsoft.com/en-us/gaming/accessibility/xbox-accessibility-guidelines/103 | 2026-09-03 | Threshold notches are the additional channel; they must be measured in a campaign scene after compositing. |
| Polish pause copy | Rada Języka Polskiego, zasady pisowni (effective 2026-01-01). https://rjp.pan.pl/zasady-pisowni-i-interpunkcji-polskiej-2/ | 2026-09-03 | Used only for conservative inner-voice punctuation; no global replace. |
| Unawaited GDScript coroutines | Godot 4.x emits `WARNING: The function … is a coroutine` when a function containing `await` is called without `await`. | 2026-09-03 | PKG-0182 fixed 0182 smoke; 0179/0180 still call coroutines without `await`. Log policy that only matches `WARNING:` (not `SCRIPT WARNING:`) can miss the signal. |

Limitations: no external playtests (D-012, ADR-003). No physical gamepad on this workstation.
