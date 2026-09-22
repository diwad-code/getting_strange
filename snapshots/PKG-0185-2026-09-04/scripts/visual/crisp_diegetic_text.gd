class_name CrispDiegeticText
extends Node2D

## CrispDiegeticText — ostre napisy diegetyczne w świecie (Godot 4.7)
## Zgodny ze specyfikacją docs/PIXEL_PRESENTATION_ARCHITECTURE.md
## Renderuje tablice, rozkłady, monitory, terminale i szyldy w warstwie Layer 10 (CrispDiegeticTextLayer),
## omijając pixelizację świata i zachowując pełną ostrość oraz skalowanie tekstu.

@export var text: String = "":
	set(val):
		text = val
		_update_text_display()

@export var text_key: String = "":
	set(val):
		text_key = val
		_update_text_display()

@export var font_size: int = 11:
	set(val):
		font_size = val
		_update_text_display()

@export var text_color: Color = Color("d7e0e3"):
	set(val):
		text_color = val
		_update_text_display()

@export var backdrop_color: Color = Color(0.07, 0.09, 0.11, 0.85):
	set(val):
		backdrop_color = val
		_update_text_display()

@export var show_border: bool = true
@export var border_color: Color = Color(0.35, 0.45, 0.50, 0.6)
@export var padding: Vector2 = Vector2(4.0, 2.0)
@export var custom_size: Vector2 = Vector2.ZERO

var _canvas_layer: CanvasLayer
var _panel: PanelContainer
var _label: Label


func _ready() -> void:
	_setup_crisp_layer()
	_update_text_display()
	
	var game_state := get_node_or_null("/root/GameStateManager")
	if game_state and game_state.has_signal(&"accessibility_changed"):
		game_state.accessibility_changed.connect(_on_accessibility_changed)


func _exit_tree() -> void:
	var game_state := get_node_or_null("/root/GameStateManager")
	if game_state and is_instance_valid(game_state) and game_state.has_signal(&"accessibility_changed"):
		if game_state.accessibility_changed.is_connected(_on_accessibility_changed):
			game_state.accessibility_changed.disconnect(_on_accessibility_changed)


func _setup_crisp_layer() -> void:
	if _canvas_layer == null:
		_canvas_layer = CanvasLayer.new()
		_canvas_layer.name = "CrispDiegeticLayer"
		_canvas_layer.layer = 10 # CrispDiegeticTextLayer
		add_child(_canvas_layer)
		
		_panel = PanelContainer.new()
		_panel.name = "TextPanel"
		_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		var style := StyleBoxFlat.new()
		style.bg_color = backdrop_color
		style.set_content_margin_all(padding.x)
		if show_border:
			style.border_color = border_color
			style.set_border_width_all(1)
		_panel.add_theme_stylebox_override(&"panel", style)
		
		_label = Label.new()
		_label.name = "Label"
		_label.add_theme_color_override(&"font_color", text_color)
		_label.add_theme_font_size_override(&"font_size", font_size)
		_mark_scalable(_label, font_size, "font_size")
		
		_panel.add_child(_label)
		_canvas_layer.add_child(_panel)


func _process(_delta: float) -> void:
	if _panel and is_inside_tree():
		# Sync panel screen position with world position
		var canvas_xform := get_canvas_transform()
		var screen_pos := canvas_xform * global_position
		_panel.position = screen_pos


func _update_text_display() -> void:
	if _label == null:
		return
	
	var displayed_text := text
	if not text_key.is_empty():
		displayed_text = LocalizationManager.tr_key(text_key)
	
	_label.text = displayed_text
	_label.add_theme_color_override(&"font_color", text_color)
	_label.add_theme_font_size_override(&"font_size", font_size)
	
	if _panel:
		var style := _panel.get_theme_stylebox(&"panel") as StyleBoxFlat
		if style:
			style.bg_color = backdrop_color
			if show_border:
				style.border_color = border_color
				style.set_border_width_all(1)
			else:
				style.set_border_width_all(0)


func _on_accessibility_changed(_text_scale: float, _locale: String) -> void:
	_update_text_display()


func _mark_scalable(control: Control, base_font_size: int, property_name: String) -> void:
	control.add_to_group("gs_scalable_text")
	control.set_meta("gs_base_font_size", base_font_size)
	control.set_meta("gs_font_property", property_name)
