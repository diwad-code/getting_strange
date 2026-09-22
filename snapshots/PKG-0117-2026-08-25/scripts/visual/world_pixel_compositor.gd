class_name WorldPixelCompositor
extends CanvasLayer

## WorldPixelCompositor — Rówień Pixel-Stage kompozytor świata (Godot 4.7)
## Zgodny ze specyfikacją docs/PIXEL_PRESENTATION_ARCHITECTURE.md oraz VISUAL_DESIGN.md
##
## Kolejność renderowania:
## 1. WorldRoot (Geometry, Props, Lena, NPC, World VFX) - Layer 0
## 2. WorldPixelCompositor (próbkowanie siatki 2x2 / 320x180, nearest-neighbor) - Layer 5
## 3. CrispDiegeticTextLayer (tablice, monitory, terminale w świecie) - Layer 10
## 4. CrispGameplayUILayer (prompt [E], InnerThoughtSurface, CRTDialogueBox) - Layer 16..20
## 5. CrispSystemUILayer (pauza, ustawienia, accessibility) - Layer 30+

const EFFECTIVE_WIDTH: float = 320.0
const EFFECTIVE_HEIGHT: float = 180.0
const NATIVE_WIDTH: float = 640.0
const NATIVE_HEIGHT: float = 360.0

@export var pixel_scale: float = 2.0 # 2.0 = 320x180 w oknie 640x360
@export var compositor_enabled: bool = true

var _color_rect: ColorRect
var _material: ShaderMaterial

const PIXEL_SHADER_CODE: String = """
shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform vec2 pixel_size = vec2(320.0, 180.0);
uniform bool enabled = true;

void fragment() {
	if (!enabled) {
		COLOR = texture(screen_texture, SCREEN_UV);
	} else {
		vec2 grid_uv = floor(SCREEN_UV * pixel_size) / pixel_size + (0.5 / pixel_size);
		COLOR = texture(screen_texture, grid_uv);
	}
}
"""


func _ready() -> void:
	layer = 5 # Below CrispDiegeticTextLayer (10), CrispGameplayUI (16-20), CrispSystemUI (30+)
	_setup_compositor_rect()


func _setup_compositor_rect() -> void:
	if _color_rect == null:
		_color_rect = ColorRect.new()
		_color_rect.name = "PixelCompositorRect"
		_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_color_rect.position = Vector2.ZERO
		_color_rect.size = Vector2(NATIVE_WIDTH, NATIVE_HEIGHT)
		
		var shader := Shader.new()
		shader.code = PIXEL_SHADER_CODE
		
		_material = ShaderMaterial.new()
		_material.shader = shader
		_material.set_shader_parameter("pixel_size", Vector2(EFFECTIVE_WIDTH, EFFECTIVE_HEIGHT))
		_material.set_shader_parameter("enabled", compositor_enabled)
		
		_color_rect.material = _material
		add_child(_color_rect)


func set_compositor_enabled(enable: bool) -> void:
	compositor_enabled = enable
	if _material:
		_material.set_shader_parameter("enabled", enable)


func set_pixel_grid(width: float, height: float) -> void:
	if _material:
		_material.set_shader_parameter("pixel_size", Vector2(width, height))


func get_effective_resolution() -> Vector2:
	return Vector2(EFFECTIVE_WIDTH, EFFECTIVE_HEIGHT)
