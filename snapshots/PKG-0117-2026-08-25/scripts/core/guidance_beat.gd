class_name GuidanceBeat
extends Resource

## GuidanceBeat — rekord danych prowadzenia narracyjnego (2.0)
## Zgodny ze specyfikacją docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md

enum Tier {
	L0_COMPOSITION = 0,
	L1_REACTION = 1,
	L2_CONTEXTUAL_THOUGHT = 2,
	L3_DIRECTIONAL_THOUGHT = 3,
	L4_RESCUE_HINT = 4
}

@export var beat_id: StringName = &""
@export var scene_id: StringName = &""
@export var tier: Tier = Tier.L2_CONTEXTUAL_THOUGHT
@export var thought_kind: StringName = &"observation" # &"observation", &"interpretation", &"intention"
@export var text_key: String = ""
@export var text_pl: String = ""
@export var text_en: String = ""
@export var cooldown_s: float = 8.0
@export var once_per_state: bool = true
@export var supersedes: StringName = &""
@export var truth_scope: StringName = &"factual" # &"factual", &"fallible", &"procedural"
@export var trigger_delay_s: float = 0.0


func get_localized_text(locale: String = "") -> String:
	if not text_key.is_empty():
		var localized := LocalizationManager.tr_key(text_key)
		if not localized.is_empty() and localized != text_key:
			return localized
	
	if locale.begins_with("en"):
		return text_en if not text_en.is_empty() else text_pl
	return text_pl if not text_pl.is_empty() else text_en
