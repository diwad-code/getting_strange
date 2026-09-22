extends Node

## CR-A local owner of action conversations. Station verbs retain all writes.
## Queues behind the opening and synthesis vignette; reload permits rereading
## resolved points without replaying the vignette or granting additional facts.
const Lines := preload("res://scripts/levels/creative_scene_lines.gd")
var _station: Node
var _dialogue: CRTDialogueBox
var _guidance: NarrativeGuidanceService
var _pending: Array[Dictionary] = []
var _active_id := ""
var _rigs: Array[CharacterVisualRig] = []

func _ready() -> void:
	_station = get_parent()
	_dialogue = _station.get_node("CRTDialogueBox")
	_guidance = _station.get_node("NarrativeGuidanceService")
	_station.clue_inspected.connect(_on_action)
	_dialogue.line_started.connect(_on_line)
	_dialogue.dialogue_finished.connect(_on_finished)
	_collect_rigs(_station)

func _collect_rigs(node: Node) -> void:
	for child in node.get_children():
		if child is CharacterVisualRig:
			_rigs.append(child)
		_collect_rigs(child)

func _on_action(id: String, _prop_type: int) -> void:
	if _active_id == id:
		return
	for entry in _pending:
		if entry.id == id:
			return
	var state := get_node("/root/GameStateManager")
	var lines: Array
	if _station.call("_is_resolved", id):
		lines = Lines.lines_for(id, state.decisions)
		var closed := {"relation_photo": &"renumbering", "marta_day": &"intruder", "record_186_days": &"lost_relationship", "jakub_meeting": &"staging", "synthesize": &"different_dates"}
		if closed.has(id):
			_guidance.close_hypothesis(closed[id])
	else:
		lines = [{"speaker": "Lena", "text": "Brakuje mi wcześniejszego źródła. Mogę wrócić i je sprawdzić."}]
	_pending.append({"id": id, "lines": lines})
	_guidance.report_progress()

func _process(_delta: float) -> void:
	if get_tree().paused:
		return
	var cinematic := _station.get_node_or_null("CinematicVignette_vig_synthesis")
	var cinematic_active := cinematic != null and not cinematic.is_queued_for_deletion()
	_guidance.set_dialogue_active(_dialogue.is_presenting() or cinematic_active or not _pending.is_empty())
	if cinematic_active or _dialogue.is_presenting() or _pending.is_empty():
		return
	var entry: Dictionary = _pending.pop_front()
	_active_id = entry.id
	var player := _station.get_node("Player") as PrototypePlayer
	player.play_visual_cue(&"examine" if _active_id == "relation_photo" else &"interact", 0.6)
	_dialogue.present(entry.lines)

func _input(event: InputEvent) -> void:
	# Consume before any MRP's _unhandled_input: an advance cannot also inspect.
	if get_tree().paused or not _dialogue.is_presenting():
		return
	if event.is_action_pressed(&"interact") or event.is_action_pressed(&"ui_accept"):
		get_viewport().set_input_as_handled()
		_dialogue.advance_dialogue()

func _on_line(speaker: StringName, _text: String) -> void:
	if _active_id.is_empty():
		return # Opening cue must not turn the working Jakub into a listener.
	if _active_id == "private_boundary" and _text.begins_with("Nie."):
		(_station.get_node("Player") as PrototypePlayer).play_visual_cue(&"stop", 0.6)
	for rig in _rigs:
		if rig.character_id == &"wierzbicka":
			continue # Preserve seated support; standing talk would lift her off the chair.
		if rig.character_id == &"jakub" and _active_id == "jakub_questions":
			rig.set_state(&"work")
		else:
			rig.set_state(&"talk" if String(speaker).to_lower() == String(rig.character_id) else &"listen")
			var player := _station.get_node("Player") as Node2D
			rig.set_facing(player.global_position.x - rig.global_position.x)

func _on_finished() -> void:
	if _active_id.is_empty():
		return
	for rig in _rigs:
		if rig.character_id == &"jakub":
			rig.set_state(&"work" if _active_id in ["jakub_questions", "jakub_refusal"] else &"listen")
		elif rig.character_id == &"marta":
			rig.set_state(&"turn_away" if _active_id == "marta_boundary" else &"idle")
	_active_id = ""

func is_busy() -> bool:
	return not _pending.is_empty() or not _active_id.is_empty() or _dialogue.is_presenting()
