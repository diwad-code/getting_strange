class_name StationDialogueCue
extends Node

## Minimal station-facing bridge. A station owns the cue text while the shared
## CRTDialogueBox owns rendering, input, timing and synthesized speech.

@export var station_id: StringName
@export_multiline var opening_line := ""
@export var speaker: StringName = &"Lena"
# PKG-0230 (P1-2, S-06): opcjonalna druga kwestia wejscia innym glosem
# (zawias Marty w 13). Domyslnie pusta — jedna kwestia jak dotychczas.
@export_multiline var opening_line_2 := ""
@export var speaker_2: StringName = &"Marta"


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
		var lines := [{"speaker": speaker, "text": opening_line}]
		if not opening_line_2.is_empty():
			lines.append({"speaker": speaker_2, "text": opening_line_2})
		dialogue.call_deferred("present", lines)