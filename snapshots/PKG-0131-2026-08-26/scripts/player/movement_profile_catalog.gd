class_name MovementProfileCatalog
extends RefCounted

const DEFAULT_PROFILE_ID := &"A"
const PROFILE_A: MovementProfile = preload("res://resources/movement/profile_a.tres")
const PROFILE_B: MovementProfile = preload("res://resources/movement/profile_b.tres")
const PROFILE_C: MovementProfile = preload("res://resources/movement/profile_c.tres")
const PROFILES := {
	&"A": PROFILE_A,
	&"B": PROFILE_B,
	&"C": PROFILE_C,
}


static func normalize_profile_id(raw_profile_id: String) -> StringName:
	return StringName(raw_profile_id.strip_edges().to_upper())


static func get_profile(profile_id: StringName) -> MovementProfile:
	return PROFILES.get(profile_id) as MovementProfile


static func valid_profile_ids() -> Array[StringName]:
	return [&"A", &"B", &"C"]
