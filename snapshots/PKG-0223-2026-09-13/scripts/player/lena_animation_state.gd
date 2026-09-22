class_name LenaAnimationState
extends Node

## LenaAnimationState — adapter łączący fizykę PrototypePlayer z LenaVisualRig.
## Odpowiada za mapowanie mechanicznych zdarzeń ruchu na stany wizualne bez
## zanieczyszczania skryptu fizyki logiką rysowania.

const PrototypePlayer := preload("res://scripts/player/prototype_player.gd")
const LenaVisualRig := preload("res://scripts/player/lena_visual_rig.gd")

@export var player: CharacterBody2D
@export var visual_rig: Node2D


func _ready() -> void:
	if visual_rig == null and player != null:
		visual_rig = player.get_node_or_null("LenaVisualRig") as LenaVisualRig


func _physics_process(_delta: float) -> void:
	if player == null or visual_rig == null:
		return
	
	var is_climbing: bool = bool(player.get("is_climbing")) if "is_climbing" in player else false
	var is_sprinting: bool = bool(player.get("is_sprinting")) if "is_sprinting" in player else false
	var stepping: StringName = &""
	if player.has_method("get_stepping_pose"):
		stepping = player.call("get_stepping_pose")
	var grounded := player.is_on_floor()
	if player.has_method("is_stepping") and bool(player.call("is_stepping")):
		grounded = true
	visual_rig.set_mechanical_state(player.velocity, grounded, is_climbing, is_sprinting, stepping)


func notify_jump() -> void:
	if visual_rig:
		visual_rig.set_state(&"jump_rise")


func notify_land(_fall_speed: float) -> void:
	if visual_rig:
		visual_rig.set_state(&"land")


func notify_cue(cue_name: StringName, duration: float = 0.6) -> void:
	if visual_rig:
		visual_rig.play_cue(cue_name, duration)
