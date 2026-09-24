class_name CreditsPanel
extends Panel

## PKG-0242 (release): credits and the licence texts a public build must carry.
## The Godot notices are read from the running engine (get_license_text,
## get_copyright_info, get_license_info), so they always match the engine the
## game was exported with instead of a hand-copied list.

signal closed()

const PANEL_SIZE := Vector2(568.0, 300.0)

var _title: Label
var _body: RichTextLabel
var _back: Button
var _return_focus: Control


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	size = PANEL_SIZE
	mouse_filter = Control.MOUSE_FILTER_STOP
	var style := StyleBoxFlat.new()
	style.bg_color = VectorStageStyle.INK
	style.border_color = VectorStageStyle.LIGHT_PLANE
	style.set_border_width_all(1)
	style.border_width_left = 5
	add_theme_stylebox_override(&"panel", style)
	_title = Label.new()
	_title.name = "CreditsTitle"
	_title.position = Vector2(18.0, 10.0)
	_title.size = Vector2(530.0, 24.0)
	_title.add_theme_font_size_override(&"font_size", 17)
	_title.add_theme_color_override(&"font_color", VectorStageStyle.HUMAN_AMBER)
	add_child(_title)
	_body = RichTextLabel.new()
	_body.name = "CreditsBody"
	_body.position = Vector2(18.0, 40.0)
	_body.size = Vector2(532.0, 216.0)
	_body.bbcode_enabled = false
	_body.scroll_active = true
	_body.selection_enabled = false
	_body.focus_mode = Control.FOCUS_ALL
	_body.add_theme_font_size_override(&"normal_font_size", 9)
	_body.add_theme_color_override(&"default_color", VectorStageStyle.light(VectorStageStyle.LIGHT_PLANE, 0.40))
	add_child(_body)
	_back = Button.new()
	_back.name = "CreditsBackButton"
	_back.position = Vector2(18.0, 264.0)
	_back.size = Vector2(200.0, 26.0)
	_back.focus_mode = Control.FOCUS_ALL
	_back.pressed.connect(close_panel)
	add_child(_back)
	_body.focus_neighbor_bottom = _back.get_path()
	_body.focus_next = _back.get_path()
	_back.focus_neighbor_top = _body.get_path()
	_back.focus_previous = _body.get_path()
	_back.focus_next = _body.get_path()
	_body.focus_previous = _back.get_path()
	refresh()


func refresh() -> void:
	if _title == null:
		return
	_title.text = LocalizationManager.tr_key("CREDITS_TITLE")
	_back.text = LocalizationManager.tr_key("UI_BACK")
	_body.text = build_text()


func open_panel(return_focus: Control = null) -> void:
	_return_focus = return_focus
	refresh()
	visible = true
	_body.scroll_to_line(0)
	_back.grab_focus.call_deferred()


func close_panel() -> void:
	if not visible:
		return
	visible = false
	closed.emit()
	if is_instance_valid(_return_focus):
		_return_focus.grab_focus.call_deferred()


func _unhandled_input(event: InputEvent) -> void:
	if not visible or event.is_echo():
		return
	if event.is_action_pressed(&"ui_cancel") or event.is_action_pressed(&"pause"):
		get_viewport().set_input_as_handled()
		close_panel()


static func build_text() -> String:
	var polish := LocalizationManager.current_locale == "pl"
	var lines: PackedStringArray = []
	lines.append("GETTING STRANGE  —  %s %s" % ["wersja" if polish else "version", String(ProjectSettings.get_setting("application/config/version", ""))])
	lines.append("© 2026 Getting Strange Team. " + ("Wszelkie prawa zastrzeżone." if polish else "All rights reserved."))
	lines.append("")
	if polish:
		lines.append("Scenariusz, projekt, obraz i dźwięk: Getting Strange Team.")
		lines.append("Dźwięk powstaje w grze z syntezy proceduralnej; gra nie używa cudzych sampli ani cudzych grafik.")
	else:
		lines.append("Story, design, visuals and sound: Getting Strange Team.")
		lines.append("All sound is synthesised in-game; the game uses no third-party samples or artwork.")
	lines.append("")
	lines.append("Godot Engine — " + ("licencja" if polish else "licence") + " MIT")
	lines.append(Engine.get_license_text().strip_edges())
	lines.append("")
	lines.append("Godot Engine — " + ("komponenty stron trzecich" if polish else "third-party components"))
	for component in Engine.get_copyright_info():
		lines.append("")
		lines.append(String(component.get("name", "")))
		for part in component.get("parts", []):
			var holders: PackedStringArray = []
			for holder in part.get("copyright", []):
				holders.append("© " + String(holder))
			if not holders.is_empty():
				lines.append("  " + "; ".join(holders))
			lines.append("  " + ("Licencja: " if polish else "License: ") + String(part.get("license", "")))
	lines.append("")
	lines.append(("Pełne teksty licencji" if polish else "Full license texts"))
	var licenses: Dictionary = Engine.get_license_info()
	var names := licenses.keys()
	names.sort()
	for license_name in names:
		lines.append("")
		lines.append("— " + String(license_name) + " —")
		lines.append(String(licenses[license_name]).strip_edges())
	return "\n".join(lines)
