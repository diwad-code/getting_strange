class_name InnerThoughtSurface
extends CanvasLayer

## InnerThoughtSurface — powierzchnia prezentacji myśli Leny (2.0)
## Zgodna ze specyfikacją docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md oraz docs/PIXEL_PRESENTATION_ARCHITECTURE.md

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
##
## Renderuje w warstwie Layer 16 (CrispGameplayUILayer), zachowując natywną ostrość 640x360,
## nagłówek LENA // MYŚL, ciepły akcent bursztynu oraz skalowanie tekstu.

@export var guidance_service: NarrativeGuidanceService

var _panel: Panel
var _header_label: Label
var _thought_label: RichTextLabel
var _accent_line: ColorRect
var _dismiss_timer: float = 0.0
var _is_showing: bool = false


func _ready() -> void:
	layer = 16 # CrispGameplayUILayer
	process_mode = Node.PROCESS_MODE_PAUSABLE
	_build_ui()
	visible = false
	
	if guidance_service == null:
		guidance_service = get_parent().get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	
	if guidance_service:
		guidance_service.thought_requested.connect(present_thought)
		guidance_service.thought_dismissed.connect(dismiss)
	
	var game_state := get_node_or_null("/root/GameStateManager")
	if game_state and game_state.has_method("apply_text_scale_to_tree"):
		game_state.apply_text_scale_to_tree()


func _build_ui() -> void:
	_panel = Panel.new()
	_panel.name = "ThoughtPanel"
	_panel.position = Vector2(40.0, 24.0)
	_panel.size = Vector2(440.0, 56.0)
	_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var style := StyleBoxFlat.new()
	style.bg_color = Color(VectorStageStyle.INK.r, VectorStageStyle.INK.g, VectorStageStyle.INK.b, 0.92)
	style.border_color = VectorStageStyle.HUMAN_AMBER
	style.border_width_left = 3
	style.set_border_width_all(1)
	style.border_width_left = 3
	_panel.add_theme_stylebox_override(&"panel", style)
	add_child(_panel)
	
	_accent_line = ColorRect.new()
	_accent_line.name = "ThoughtAccent"
	_accent_line.position = Vector2(3.0, 1.0)
	_accent_line.size = Vector2(110.0, 2.0)
	_accent_line.color = VectorStageStyle.HUMAN_AMBER
	_accent_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_panel.add_child(_accent_line)
	
	_header_label = Label.new()
	_header_label.name = "HeaderLabel"
	_header_label.text = "LENA // MYŚL"
	_header_label.position = Vector2(12.0, 6.0)
	_header_label.modulate = VectorStageStyle.HUMAN_AMBER
	_header_label.add_theme_font_size_override(&"font_size", 10)
	_mark_scalable(_header_label, 10, "font_size")
	_panel.add_child(_header_label)
	
	_thought_label = RichTextLabel.new()
	_thought_label.name = "ThoughtText"
	_thought_label.position = Vector2(12.0, 26.0)
	_thought_label.size = Vector2(416.0, 30.0)
	_thought_label.custom_minimum_size = Vector2(416.0, 30.0)
	_thought_label.bbcode_enabled = true
	_thought_label.fit_content = true
	_thought_label.scroll_active = false
	_thought_label.add_theme_font_size_override(&"normal_font_size", 12)
	_mark_scalable(_thought_label, 12, "normal_font_size")
	_thought_label.add_theme_color_override(&"default_color", Color("d7e0e3"))
	_panel.add_child(_thought_label)
	_thought_label.resized.connect(_fit_panel_height)
	_fit_panel_height()


func _fit_panel_height() -> void:
	# At 115%, two lines require 40px instead of the old fixed 30px.
	_panel.size.y = maxf(60.0, _thought_label.position.y + _thought_label.size.y + 4.0)


func _process(delta: float) -> void:
	if get_tree().paused or not _is_showing:
		return
	
	if _dismiss_timer > 0.0:
		_dismiss_timer -= delta
		if _dismiss_timer <= 0.0:
			dismiss()


func present_thought(beat: GuidanceBeat, text: String) -> void:
	if text.is_empty():
		return
	
	if beat != null and (beat.tier == GuidanceBeat.Tier.L4_RESCUE_HINT or beat.thought_kind == &"system_hint"):
		_header_label.text = "WSKAZÓWKA // SYSTEM"
		_header_label.modulate = VectorStageStyle.ANCHOR_CYAN
		_accent_line.color = VectorStageStyle.ANCHOR_CYAN
	else:
		_header_label.text = "LENA // MYŚL"
		_header_label.modulate = VectorStageStyle.HUMAN_AMBER
		_accent_line.color = VectorStageStyle.HUMAN_AMBER
	
	_thought_label.text = "[color=#d7e0e3]%s[/color]" % text
	_thought_label.reset_size()
	_fit_panel_height()
	_dismiss_timer = clampf(float(text.length()) * 0.08 + 2.8, 3.5, 7.0)
	_is_showing = true
	visible = true


func dismiss() -> void:
	if not _is_showing:
		return
	_is_showing = false
	visible = false
	if guidance_service:
		guidance_service.dismiss_thought()


func _mark_scalable(control: Control, base_font_size: int, property_name: String) -> void:
	control.add_to_group("gs_scalable_text")
	control.set_meta("gs_base_font_size", base_font_size)
	control.set_meta("gs_font_property", property_name)
