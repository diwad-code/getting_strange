class_name SafeActionDialog
extends CanvasLayer

## Modal confirmation for destructive menu actions. Does not own save/scene state.
## Cancel is the initial focus; closing or repeated input can never execute twice.
signal confirmed()
signal cancelled()
var _resolved := false
var _return_focus: Control
var _title: Label
var _body: Label
var _confirm: Button
var _cancel: Button

func _ready() -> void:
	name = "SafeActionDialog"
	layer = 120
	process_mode = Node.PROCESS_MODE_ALWAYS
	var shade := ColorRect.new()
	shade.color = Color(VectorStageStyle.INK, 0.96)
	shade.size = Vector2(640.0, 360.0)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(shade)
	var panel := Panel.new()
	panel.position = Vector2(94.0, 92.0)
	panel.size = Vector2(452.0, 176.0)
	var style := StyleBoxFlat.new()
	style.bg_color = VectorStageStyle.INK
	style.border_color = VectorStageStyle.HUMAN_AMBER
	style.set_border_width_all(1)
	style.border_width_left = 4
	panel.add_theme_stylebox_override("panel", style)
	shade.add_child(panel)
	_title = _label(panel, Vector2(18.0, 14.0), Vector2(416.0, 28.0), 16)
	_title.modulate = VectorStageStyle.HUMAN_AMBER
	_body = _label(panel, Vector2(18.0, 50.0), Vector2(416.0, 62.0), 12)
	_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_cancel = _button(panel, Vector2(18.0, 126.0))
	_confirm = _button(panel, Vector2(234.0, 126.0))
	_cancel.text = LocalizationManager.tr_key("CONFIRM_CANCEL")
	_cancel.pressed.connect(cancel)
	_confirm.pressed.connect(accept)
	for button in [_cancel, _confirm]:
		var other: Button = _confirm if button == _cancel else _cancel
		button.focus_next = other.get_path()
		button.focus_previous = other.get_path()
		button.focus_neighbor_left = other.get_path()
		button.focus_neighbor_right = other.get_path()
		button.focus_neighbor_top = button.get_path()
		button.focus_neighbor_bottom = button.get_path()

func _label(parent: Node, at: Vector2, dimensions: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.position = at
	label.size = dimensions
	label.add_theme_font_size_override("font_size", font_size)
	_mark_scalable(label, font_size)
	label.add_theme_color_override("font_color", VectorStageStyle.LIGHT_PLANE)
	parent.add_child(label)
	return label

func _button(parent: Node, at: Vector2) -> Button:
	var button := Button.new()
	button.position = at
	button.size = Vector2(200.0, 32.0)
	button.add_theme_font_size_override("font_size", 12)
	_mark_scalable(button, 12)
	parent.add_child(button)
	return button

func _mark_scalable(control: Control, font_size: int) -> void:
	control.add_to_group("gs_scalable_text")
	control.set_meta("gs_base_font_size", font_size)
	control.set_meta("gs_font_property", "font_size")

func present(title: String, body: String, action: String, return_focus: Control) -> void:
	_title.text = title
	_body.text = body
	_confirm.text = action
	_return_focus = return_focus
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.apply_text_scale_to_tree()
	_cancel.grab_focus.call_deferred()

func _input(event: InputEvent) -> void:
	if _resolved:
		return
	if not event.is_echo() and (event.is_action_pressed(&"ui_cancel") or event.is_action_pressed(&"pause")):
		get_viewport().set_input_as_handled()
		cancel()

func _unhandled_input(_event: InputEvent) -> void:
	# No world interaction/restart/selector behind this modal.
	if not _resolved:
		get_viewport().set_input_as_handled()

func accept() -> void:
	if _resolved:
		return
	_resolved = true
	visible = false
	confirmed.emit()
	queue_free()

func cancel() -> void:
	if _resolved:
		return
	_resolved = true
	visible = false
	if is_instance_valid(_return_focus) and _return_focus.is_visible_in_tree():
		_return_focus.grab_focus.call_deferred()
	cancelled.emit()
	queue_free()
