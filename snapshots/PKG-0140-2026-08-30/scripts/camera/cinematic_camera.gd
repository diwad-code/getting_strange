class_name CinematicCamera
extends Camera2D

signal chamber_changed(from_index: int, to_index: int)

@export var target: Node2D
@export var view_size := Vector2(640.0, 360.0)
@export var smooth_speed := 6.0
@export var lead_distance := 20.0
@export var lead_speed := 4.0

## PKG-0130 pixel coherence contract.
## The world is composited through a 320x180 nearest-neighbour grid inside a
## 640x360 viewport (WorldPixelCompositor), so one composited pixel is 2 native
## units. A camera parked on a fractional native coordinate makes the compositor's
## floor() sampling flip between neighbouring source rows, which reads as pixel
## crawl on vertical traversal (ladders, service lifts). Smoothing therefore stays
## in float, and only the transform handed to the renderer is snapped to the grid.
const PIXEL_GRID := 2.0

@export var pixel_snap_enabled := true
## Vertical framing follows Lena only once she leaves a generous deadzone, and
## never past the chamber edges. Chambers exactly one view tall collapse the clamp
## to their centre, so flat stations keep their existing locked framing.
@export var vertical_follow_enabled := true
@export var vertical_deadzone := 46.0
@export var vertical_follow_speed := 4.5

## PKG-0136 dialogue framing.
## The play plane sits low in the 640x360 frame and CRTDialogueBox occupies the
## bottom 102 px, so a bottom-anchored panel covers Lena from the waist down
## exactly when the scene wants her read. While a dialogue is presenting, the
## camera eases down by this many world units, which lifts the actor above the
## panel and spends the otherwise dead air over her head. Framing returns on
## close, so silent stations keep their tall-room read.
@export var dialogue_framing_offset := 36.0

## PKG-0137 framing budget (D-136).
## The offset above is a wish, not a licence. The authored stage stops at the
## chamber floor plus the painted apron; anything past that is the engine clear
## colour. The applied offset is therefore clamped to the headroom that is
## actually painted, so no station can be framed onto void.
@export var stage_apron := VectorStageStyle.STAGE_APRON

## PKG-0140 wygladzenie kadru w pionie (D-148).
## Wejscie na drabine albo na winde to jedyne momenty kampanii, w ktorych Lena
## porusza sie w pionie ciagle i wolno. Zwykla predkosc sledzenia jest wtedy za
## szybka: kadr dociaga do martwej strefy skokami, a snap 2 px zamienia je w
## widoczny chodzacy piksel. Podczas transportu pionowego sledzenie przechodzi
## wiec na wolniejsza stala czasowa, a samo przejscie miedzy stalymi jest
## wygladzone, zeby wsiadanie na drabine nie bylo kolejnym skokiem.
@export var traversal_damping_enabled := true
## Predkosc sledzenia pionu w trakcie wspinaczki / jazdy winda.
@export var traversal_follow_speed := 2.4
## Martwa strefa w trakcie transportu pionowego. Wieksza niz zwykla, bo szczeble
## drabiny same w sobie sa ruchem oscylacyjnym.
@export var traversal_deadzone := 62.0
## Tempo przechodzenia miedzy trybem zwyklym a transportowym (1/s).
@export var traversal_blend_speed := 3.0

var chamber_bounds: Array[Rect2] = []
var active_chamber_index: int = 0
var _target_center := Vector2(320.0, 180.0)
var _current_lead := Vector2.ZERO
var _shake_intensity := 0.0
var _shake_decay := 4.0
var _shake_offset := Vector2.ZERO
## Float authority for the smoothed camera focus. `global_position` is a snapped
## projection of this value and is never read back as state, so snapping cannot
## accumulate drift.
var _smooth_position := Vector2(320.0, 180.0)
var _vertical_focus := 180.0
var _dialogue_surface: CanvasLayer
var _dialogue_surface_resolved := false
## 0..1 — udzial trybu transportu pionowego w biezacym wygladzaniu.
var _traversal_blend := 0.0
## Kadr centruje sie na Lenie w pierwszej klatce fizyki po ustawieniu celu.
## Wejscie przez `ReturnZone` albo `AirlockZone` konczy sie zaladowaniem nowej
## stacji, wiec to wlasnie ta sciezka odpowiada za natychmiastowe centrowanie
## po przejsciu progu (D-148).
var _needs_recenter := true


func _ready() -> void:
	# Ensure camera settings align with the 640x360 pixel-perfect specification
	anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	enabled = true
	position_smoothing_enabled = false # We handle custom cinematic smoothing


func setup_chambers(bounds: Array[Rect2]) -> void:
	chamber_bounds = bounds
	if not chamber_bounds.is_empty():
		set_chamber(0, true)
	request_recenter()


## Zada natychmiastowego wysrodkowania kadru na celu w najblizszej klatce
## fizyki. Uzywane po przejsciu przez `ReturnZone` i `AirlockZone`, gdzie kadr
## musi zastac gracza juz ustawiony, a nie dojezdzac do niego przez pol sekundy.
func request_recenter() -> void:
	_needs_recenter = true


## Natychmiastowe wysrodkowanie. Zachowuje snap 2 px, bo do renderera i tak
## trafia rzut na siatke kompozytora.
func recenter_on_target() -> void:
	_needs_recenter = false
	if is_instance_valid(target):
		_update_chamber_from_target()
	_current_lead = Vector2.ZERO
	_traversal_blend = 1.0 if _is_target_in_vertical_transit() else 0.0
	var rect := get_active_chamber_rect()
	var half_height := view_size.y * 0.5
	var min_y := rect.position.y + half_height
	var max_y := rect.end.y - half_height
	if min_y >= max_y:
		_vertical_focus = _target_center.y
	elif is_instance_valid(target):
		_vertical_focus = clampf(target.global_position.y, min_y, max_y)
	else:
		_vertical_focus = clampf(_target_center.y, min_y, max_y)
	_smooth_position = Vector2(
		_target_center.x,
		_vertical_focus + _resolve_dialogue_framing(_vertical_focus)
	)
	global_position = _project_to_pixel_grid(_smooth_position)
	offset = Vector2.ZERO


func set_chamber(index: int, immediate: bool = false) -> void:
	if index < 0 or index >= chamber_bounds.size():
		return

	var prev_index := active_chamber_index
	active_chamber_index = index
	var rect := chamber_bounds[index]
	_target_center = rect.position + rect.size * 0.5

	if immediate:
		_vertical_focus = _target_center.y
		_smooth_position = _target_center
		global_position = _project_to_pixel_grid(_smooth_position)
		_current_lead = Vector2.ZERO
	
	if prev_index != active_chamber_index:
		chamber_changed.emit(prev_index, active_chamber_index)


func get_active_chamber_rect() -> Rect2:
	if active_chamber_index >= 0 and active_chamber_index < chamber_bounds.size():
		return chamber_bounds[active_chamber_index]
	return Rect2(Vector2.ZERO, view_size)


func add_trauma(amount: float) -> void:
	_shake_intensity = clampf(_shake_intensity + amount, 0.0, 1.0)


func _physics_process(delta: float) -> void:
	if _needs_recenter and is_instance_valid(target):
		recenter_on_target()
		return

	_update_traversal_blend(delta)

	if is_instance_valid(target):
		_update_chamber_from_target()
		_update_lead(delta)

	_update_shake(delta)

	# Smooth camera focus toward the chamber frame with lead, vertical follow and shake.
	# The vertical focus is resolved first on purpose: the dialogue framing budget
	# is measured against the frame that focus produces.
	var focus_y := _resolve_vertical_focus(delta)
	var desired_pos := Vector2(
		_target_center.x + _current_lead.x,
		focus_y + _resolve_dialogue_framing(focus_y)
	)
	var weight := 1.0 - exp(-smooth_speed * delta)
	_smooth_position = _smooth_position.lerp(desired_pos, weight)
	global_position = _project_to_pixel_grid(_smooth_position)
	# Camera2D.offset is added after position. An unsnapped shake would walk the
	# compositor off the 2 px grid and undo the snap above.
	offset = _project_to_pixel_grid(_shake_offset)


## Extra downward framing while a dialogue panel is open. Applied after the
## chamber clamp on purpose: the shift is a presentation choice, not traversal.
## The value is a target only — the existing smoothing eases in and out of it.
func _resolve_dialogue_framing(focus_y: float) -> float:
	if is_zero_approx(dialogue_framing_offset):
		return 0.0
	if not _dialogue_surface_resolved:
		_dialogue_surface_resolved = true
		_dialogue_surface = _find_dialogue_surface()
	if _dialogue_surface == null or not is_instance_valid(_dialogue_surface):
		return 0.0
	if not _dialogue_surface.has_method("is_presenting"):
		return 0.0
	if not _dialogue_surface.call("is_presenting"):
		return 0.0
	return clampf(dialogue_framing_offset, 0.0, get_framing_budget(focus_y))


## How far the frame may still travel down before it leaves painted scenery:
## chamber floor plus the stage apron, minus where the frame's bottom edge sits.
func get_framing_budget(focus_y: float) -> float:
	var rect := get_active_chamber_rect()
	var frame_bottom := focus_y + view_size.y * 0.5
	return maxf(0.0, rect.end.y + stage_apron - frame_bottom)


func _find_dialogue_surface() -> CanvasLayer:
	var station := get_parent()
	if station == null:
		return null
	for child in station.get_children():
		if child is CanvasLayer and child.has_method("is_presenting"):
			return child as CanvasLayer
	return null


## Resolve the vertical framing focus for this frame, honouring the deadzone and
## clamping the resulting frame inside the active chamber.
func _resolve_vertical_focus(delta: float) -> float:
	var rect := get_active_chamber_rect()
	var half_height := view_size.y * 0.5
	var min_y := rect.position.y + half_height
	var max_y := rect.end.y - half_height

	if min_y >= max_y:
		# Chamber is one view tall or shorter: framing is locked to its centre.
		_vertical_focus = _target_center.y
		return _vertical_focus

	if not vertical_follow_enabled or not is_instance_valid(target):
		_vertical_focus = clampf(_target_center.y, min_y, max_y)
		return _vertical_focus

	var target_y := target.global_position.y
	# PKG-0140 (D-148). Martwa strefa i stala czasowa sa interpolowane udzialem
	# trybu transportowego, wiec wsiadanie na drabine i zejscie z windy nie
	# przelaczaja kadru skokiem — zmieniaja tylko jego bezwladnosc.
	var active_deadzone := lerpf(vertical_deadzone, traversal_deadzone, _traversal_blend)
	var active_speed := lerpf(vertical_follow_speed, traversal_follow_speed, _traversal_blend)
	var offset_from_focus := target_y - _vertical_focus
	if absf(offset_from_focus) > active_deadzone:
		var edge := target_y - signf(offset_from_focus) * active_deadzone
		_vertical_focus = lerpf(_vertical_focus, edge, 1.0 - exp(-active_speed * delta))

	_vertical_focus = clampf(_vertical_focus, min_y, max_y)
	return _vertical_focus


## Czy Lena jest w trakcie transportu pionowego: na drabinie albo na platformie
## windy towarowej. Winda jest wykrywana po kolizji podlogowej, bo `ServiceLift`
## nie zglasza pasazerow — dzieki temu kamera nie potrzebuje zadnego dodatkowego
## okablowania w 45 stacjach.
func _is_target_in_vertical_transit() -> bool:
	if not traversal_damping_enabled or not is_instance_valid(target):
		return false
	if target.get(&"is_climbing") == true:
		return true
	var body := target as CharacterBody2D
	if body == null or not body.is_on_floor():
		return false
	for i in range(body.get_slide_collision_count()):
		var collision := body.get_slide_collision(i)
		if collision == null:
			continue
		if collision.get_collider() is ServiceLift:
			return true
	return false


func _update_traversal_blend(delta: float) -> void:
	var goal := 1.0 if _is_target_in_vertical_transit() else 0.0
	_traversal_blend = lerpf(_traversal_blend, goal, 1.0 - exp(-traversal_blend_speed * delta))
	if absf(_traversal_blend - goal) < 0.001:
		_traversal_blend = goal


## Udzial trybu transportu pionowego, wystawiony dla bramki PKG-0140.
func get_traversal_blend() -> float:
	return _traversal_blend


## Project a float focus onto the composited pixel grid.
func _project_to_pixel_grid(world_position: Vector2) -> Vector2:
	if not pixel_snap_enabled:
		return world_position
	return Vector2(
		snappedf(world_position.x, PIXEL_GRID),
		snappedf(world_position.y, PIXEL_GRID)
	)


## Float smoothing authority, exposed for the PKG-0130 pixel coherence gate.
func get_smooth_position() -> Vector2:
	return _smooth_position


## Current vertical framing focus, exposed for the PKG-0130 pixel coherence gate.
func get_vertical_focus() -> float:
	return _vertical_focus


func is_on_pixel_grid() -> bool:
	if not pixel_snap_enabled:
		return true
	return is_equal_approx(global_position.x, snappedf(global_position.x, PIXEL_GRID)) \
		and is_equal_approx(global_position.y, snappedf(global_position.y, PIXEL_GRID)) \
		and is_equal_approx(offset.x, snappedf(offset.x, PIXEL_GRID)) \
		and is_equal_approx(offset.y, snappedf(offset.y, PIXEL_GRID))


func _update_chamber_from_target() -> void:
	var target_pos := target.global_position
	for i in range(chamber_bounds.size()):
		var rect := chamber_bounds[i]
		# Check if target is inside this chamber horizontally
		if target_pos.x >= rect.position.x and target_pos.x < rect.end.x:
			if i != active_chamber_index:
				set_chamber(i, false)
			break


func _update_lead(delta: float) -> void:
	var target_vel := Vector2.ZERO
	if target is CharacterBody2D:
		target_vel = (target as CharacterBody2D).velocity

	var desired_lead := Vector2.ZERO
	if absf(target_vel.x) > 10.0:
		desired_lead.x = signf(target_vel.x) * lead_distance

	_current_lead = _current_lead.lerp(desired_lead, 1.0 - exp(-lead_speed * delta))

	# Clamp so camera frame never extends outside the current chamber boundary
	if active_chamber_index >= 0 and active_chamber_index < chamber_bounds.size():
		var rect := chamber_bounds[active_chamber_index]
		var half_view := view_size * 0.5
		var min_x := rect.position.x + half_view.x
		var max_x := rect.end.x - half_view.x
		var clamped_target_x := clampf(_target_center.x + _current_lead.x, min_x, max_x)
		_current_lead.x = clamped_target_x - _target_center.x


func _update_shake(delta: float) -> void:
	if _shake_intensity > 0.001:
		_shake_intensity = maxf(0.0, _shake_intensity - _shake_decay * delta)
		var shake_power := _shake_intensity * _shake_intensity
		var max_offset := 4.0 * shake_power
		_shake_offset = Vector2(
			randf_range(-max_offset, max_offset),
			randf_range(-max_offset, max_offset)
		)
	else:
		_shake_intensity = 0.0
		_shake_offset = Vector2.ZERO
