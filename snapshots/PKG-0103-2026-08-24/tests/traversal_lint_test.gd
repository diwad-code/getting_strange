extends SceneTree

## Traversal contract lint (D-099, docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md).
##
## Getting Strange is a narrative game. Arcade platforming geometry is banned
## in campaign scenes. Documentation alone does not stop a model from copying
## the abstract prototype pattern, so this gate makes the ban executable.
##
## It scans every scene under scenes/levels/ for forbidden node names and for
## the one structural pattern the owner explicitly rejected: a body that both
## moves on its own schedule AND is named like a jump target.

const CAMPAIGN_SCENE_DIR := "res://scenes/levels"

## Node names that describe a level-design object instead of a thing in the world.
const FORBIDDEN_NAMES: Array[String] = [
	"Platform",
	"MovingPlatform",
	"FloatingPlatform",
	"JumpPad",
	"Bouncer",
	"Spike",
	"Spikes",
	"Trap",
	"Enemy",
	"Coin",
	"PowerUp",
	"KillZone",
	"DeathZone",
	"Lava",
	"Conveyor",
]

## Substrings that are forbidden anywhere inside a campaign node name.
const FORBIDDEN_FRAGMENTS: Array[String] = [
	"platform",
	"jumppad",
	"killzone",
	"deathzone",
	"spike",
	"powerup",
]

## Movement verbs are closed (design doc 7.1). New ones require a decision.
const ALLOWED_INPUT_ACTIONS: Array[StringName] = [
	&"move_left",
	&"move_right",
	&"jump",
	&"interact",
	&"trigger_correction",
	&"restart",
	&"pause",
]

const FORBIDDEN_MOVEMENT_ACTIONS: Array[StringName] = [
	&"dash",
	&"double_jump",
	&"wall_jump",
	&"glide",
	&"grapple",
	&"crouch_slide",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("TRAVERSAL LINT: " + message)


func _run() -> void:
	_check_input_verbs()
	_check_campaign_scenes()

	if _failures.is_empty():
		print("TRAVERSAL LINT PASS: campaign scenes carry no arcade-platforming geometry")
		quit(0)
	else:
		for failure in _failures:
			print("TRAVERSAL LINT FAILURE: " + failure)
		print("See docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md — obstacles must be diegetic.")
		quit(1)


func _check_input_verbs() -> void:
	for action in FORBIDDEN_MOVEMENT_ACTIONS:
		_expect(
			not InputMap.has_action(action),
			"forbidden movement verb '%s' — the verb set is closed (design doc 7.1)" % action
		)
	for action in ALLOWED_INPUT_ACTIONS:
		_expect(InputMap.has_action(action), "required input action missing: %s" % action)


func _check_campaign_scenes() -> void:
	var scene_paths := _list_campaign_scenes()
	_expect(not scene_paths.is_empty(), "no campaign scenes found under %s" % CAMPAIGN_SCENE_DIR)

	for scene_path in scene_paths:
		var packed := load(scene_path) as PackedScene
		if packed == null:
			_expect(false, "campaign scene failed to load: %s" % scene_path)
			continue
		var state := packed.get_state()
		for node_index in state.get_node_count():
			var node_name := String(state.get_node_name(node_index))
			_check_node_name(node_name, scene_path)


func _check_node_name(node_name: String, scene_path: String) -> void:
	for forbidden in FORBIDDEN_NAMES:
		if node_name == forbidden:
			_expect(false, "%s uses banned node name '%s'" % [scene_path, node_name])
			return
	var lowered := node_name.to_lower()
	for fragment in FORBIDDEN_FRAGMENTS:
		if lowered.contains(fragment):
			_expect(
				false,
				"%s node '%s' names a level-design object, not a thing in the world" % [scene_path, node_name]
			)
			return


func _list_campaign_scenes() -> Array[String]:
	var paths: Array[String] = []
	var dir := DirAccess.open(CAMPAIGN_SCENE_DIR)
	if dir == null:
		return paths
	dir.list_dir_begin()
	var entry := dir.get_next()
	while entry != "":
		if not dir.current_is_dir() and entry.get_extension() == "tscn":
			paths.append(CAMPAIGN_SCENE_DIR + "/" + entry)
		entry = dir.get_next()
	dir.list_dir_end()
	paths.sort()
	return paths
