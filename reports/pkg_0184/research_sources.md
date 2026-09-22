# PKG-0184 research sources

Accessed 2026-09-04. Independent of PKG-0182/0183 ledgers.

| Question | Source | Date | Use | Limit |
|---|---|---|---|---|
| Godot 4.x `--headless --script` runs a SceneTree script without the main scene | Godot CLI docs: https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html | 2026-09-04 | Isolated recertification gates | Splatted PowerShell argument arrays can drop `--headless` if the console wrapper is invoked incorrectly; 0184 evidence uses explicit `--headless --path --script` |
| Default physics tick | `Engine.physics_ticks_per_second` default 60. https://docs.godotengine.org/en/stable/classes/class_engine.html | 2026-09-04 | Confirm `project.godot` pin from 0183 still holds | Pin is the contract, not the engine default |
| AudioServer retains last WAV | https://github.com/godotengine/godot/issues/76745 | 2026-09-04 | WASAPI + drain still required on Windows headless | Not a certificate of native heap |
| Rec. 709 luma | ITU-R BT.709-6 coefficients 0.2126/0.7152/0.0722. https://www.itu.int/rec/R-REC-BT.709 | 2026-09-04 | Mean luma of captured frames; cold_open 0.1024 ≠ black | Subsampled pixels, not a perceptual study |
| Colour not the only cue | XAG 103. https://learn.microsoft.com/en-us/gaming/accessibility/xbox-accessibility-guidelines/103 | 2026-09-04 | Threshold notches remain the extra channel | No external player |
| Polish orthography | RJP PAN rules effective 2026-01-01. https://rjp.pan.pl/zasady-pisowni-i-interpunkcji-polskiej-2/ | 2026-09-04 | Conservative opening-line punctuation only | No global replace |
| GDScript coroutine warning | Godot 4 emits `SCRIPT WARNING` / `WARNING: The function … is a coroutine` if `await` is missing | 2026-09-04 | 0183 tautology fix had to `await` the now-async pixel-stage test | Log policy already fail-closes SCRIPT WARNING |

Skills used (not evidence): verification-before-completion; long-running-background-tasks; godot-testing (SceneTree harness, RED-GREEN); using-godot-prompter routing; godot-debugging (0179 hung DEBUG window when `--headless` was dropped); save-load (malformed JSON allowlist); input-handling (InputMap injection, pad BLOCKED); audio-system / creating-godot-procedural-audio (PCM meters ≠ mix quality); localization (dict vs unregistered CSV).

No other games were copied. No web surface. No Git. No new `.exe`.
