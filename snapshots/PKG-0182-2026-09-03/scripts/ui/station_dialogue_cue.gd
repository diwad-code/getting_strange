class_name StationDialogueCue
extends Node

## Minimal station-facing bridge. A station owns the cue text while the shared
## CRTDialogueBox owns rendering, input, timing and synthesized speech.

@export var station_id: StringName
@export_multiline var opening_line := ""
@export var speaker: StringName = &"Lena"


func _ready() -> void:
	var game_state := get_node_or_null("/root/GameStateManager")
	if not station_id.is_empty():
		if game_state:
			game_state.mark_station_reached(station_id)
		var player := get_parent().get_node_or_null("Player") as Node2D
		if player and game_state:
			game_state.set_checkpoint(station_id, player.global_position)
	if opening_line.is_empty():
		return
	var dialogue := get_parent().get_node_or_null("CRTDialogueBox") as CRTDialogueBox
	if dialogue:
		dialogue.call_deferred("present", [{"speaker": speaker, "text": opening_line}])