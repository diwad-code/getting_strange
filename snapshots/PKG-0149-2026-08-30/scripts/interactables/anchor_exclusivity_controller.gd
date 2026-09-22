class_name AnchorExclusivityController
extends Node

## Scene-local ownership for the one-anchor rule. It owns neither campaign
## progress nor an inventory: it only arbitrates AnchorableObject instances in
## its parent station and releases the old anchor before accepting a new one.

signal active_anchor_changed(active_anchor: AnchorableObject)

var _registered: Array[AnchorableObject] = []
var _active_anchor: AnchorableObject


func register_anchor(anchor: AnchorableObject) -> void:
	if anchor == null or _registered.has(anchor):
		return
	_registered.append(anchor)
	if not anchor.anchor_state_changed.is_connected(_on_anchor_state_changed.bind(anchor)):
		anchor.anchor_state_changed.connect(_on_anchor_state_changed.bind(anchor))
	if anchor.is_anchored:
		set_active_anchor(anchor)


func set_active_anchor(anchor: AnchorableObject) -> bool:
	if anchor == _active_anchor:
		return false
	if anchor != null and not _registered.has(anchor):
		register_anchor(anchor)
	if is_instance_valid(_active_anchor) and _active_anchor != anchor:
		_active_anchor.set_anchored(false)
	_active_anchor = anchor
	if is_instance_valid(_active_anchor):
		_active_anchor.set_anchored(true)
	active_anchor_changed.emit(_active_anchor)
	return true


func clear_active_anchor() -> bool:
	return set_active_anchor(null)


func get_active_anchor() -> AnchorableObject:
	return _active_anchor if is_instance_valid(_active_anchor) else null


func _on_anchor_state_changed(is_anchored: bool, anchor: AnchorableObject) -> void:
	if is_anchored:
		if anchor != _active_anchor:
			set_active_anchor(anchor)
		return
	if anchor == _active_anchor:
		_active_anchor = null
		active_anchor_changed.emit(null)
