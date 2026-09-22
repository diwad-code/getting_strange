class_name ReturnZone
extends Area2D

## ReturnZone — lewy prog powrotu stacji 02–43 (D-124, D-234).
## Drugi ThresholdZone w sensie kontraktu: powrot wymaga czasownika interact
## przy progu (NIGDY progresji z body_entered), niesie aperture_rect i rodzine
## jak prog wprost (THRESHOLD §7.1), a celem jest stacja poprzednia
## (target_station wg GameStateManager). Przod/tyl sa spojne: oba konce trasy
## wchodza wylacznie intencja.
## Statycznych wezlow Threshold nie doklejamy (D-227: ThresholdBinder jedynym
## wlascicielem progow runtime); kontrakt powrotu zyje w tej strefie.

signal return_requested()

@export var zone_width: float = 28.0
@export var zone_height: float = 220.0
@export var zone_x: float = 18.0
@export var zone_y: float = 186.0
@export var target_station: StringName = &""
@export var aperture_rect: Rect2 = Rect2(-27.0, -57.0, 54.0, 114.0)

# Rodzina jak prog wprost: 0 = DOOR, 1 = VEHICLE, 2 = HATCH
# (ThresholdZone.Family; int zamiast typu enum dla stabilnego exportu).
var entry_family: int = 0
var is_open := true
var is_player_in_range := false


func _ready() -> void:
	name = "ReturnZone"
	collision_layer = 1
	collision_mask = 1
	position = Vector2(zone_x, zone_y)
	_ensure_shape()
	_resolve_contract()
	monitoring = true
	monitorable = true
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)


func _ensure_shape() -> void:
	var shape_node := get_node_or_null("CollisionShape2D") as CollisionShape2D
	if shape_node == null:
		shape_node = CollisionShape2D.new()
		shape_node.name = "CollisionShape2D"
		var rect := RectangleShape2D.new()
		rect.size = Vector2(zone_width, zone_height)
		shape_node.shape = rect
		shape_node.position = Vector2.ZERO
		add_child(shape_node)
	else:
		var rect := RectangleShape2D.new()
		rect.size = Vector2(zone_width, zone_height)
		shape_node.shape = rect
		shape_node.position = Vector2.ZERO


## Rodzina/apertura jak prog wprost (specyfikacja Bindera jedynym zrodlem),
## cel jak routing GSM (jedyna prawda o poprzedniku). Fallback DOOR 54x114
## dla stacji spoza ROUTE Bindera i dla stref bez rodzica.
func _resolve_contract() -> void:
	var station := _find_station_root()
	var station_id := StringName("")
	if station != null:
		station_id = _station_id_from(String(station.name))
	var spec: Dictionary = {}
	if station_id != StringName(""):
		spec = ThresholdBinder.spec_for(String(station_id))
	if not spec.is_empty():
		entry_family = int(spec.get("family", 0))
		var w: float = float(spec.get("width", 54.0))
		var h: float = float(spec.get("height", 114.0))
		aperture_rect = Rect2(-w * 0.5, -h * 0.5, w, h)
	else:
		entry_family = 0
		aperture_rect = Rect2(-27.0, -57.0, 54.0, 114.0)
	is_open = true
	if station_id != StringName(""):
		var gsm := get_node_or_null("/root/GameStateManager")
		if gsm != null and gsm.has_method("get_previous_campaign_station"):
			var prev: Variant = gsm.call("get_previous_campaign_station", station_id)
			if prev is StringName and prev != StringName(""):
				target_station = prev


## Overlap jedynie rejestruje zasieg dla interactu. Zero progresji (M3).
func _on_body_entered(body: Node2D) -> void:
	if not (body is PrototypePlayer or body.name == "Player"):
		return
	is_player_in_range = true


func _on_body_exited(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		is_player_in_range = false


func _unhandled_input(event: InputEvent) -> void:
	if not is_player_in_range or not is_open:
		return
	if not event.is_action_pressed(&"interact"):
		return
	# PKG-0221 (D-234, priorytet jak D-228): prog wraca, ale NIE konsumuje
	# czasownika — propsy MRP i prog wprost maja pierwszenstwo przy tym samym E.
	trigger_return()


func is_ready_for_entry() -> bool:
	return is_player_in_range and is_open


## Jedyna droga powrotu: interact w zasiegu (instant dla bramek/testow).
func trigger_return(_player: Node2D = null, instant: bool = false) -> bool:
	if not is_open:
		return false
	if not instant and not is_player_in_range:
		return false
	# (player jest wylacznie informacyjny dla wywolan testowych; obecnosc
	# gracza poswiadcza juz flaga zasiegu ustawiana wylacznie jego overlapem.)
	# PKG-0140 (D-148). Prog powrotu konczy sie zaladowaniem poprzedniej stacji,
	# ale stacja moze tez obsluzyc powrot na miejscu. W obu przypadkach kadr ma
	# zastac Lene juz wysrodkowana, wiec zadanie centrowania idzie przed emisja.
	_request_camera_recenter()
	return_requested.emit()
	var station := _find_station_root()
	if station != null and station.has_signal(&"previous_level_requested"):
		station.emit_signal(&"previous_level_requested")
	return true


## Znajduje `CinematicCamera` stacji i zada natychmiastowego wysrodkowania.
func _request_camera_recenter() -> void:
	var station := _find_station_root()
	if station == null:
		return
	for child in station.get_children():
		if child is CinematicCamera:
			(child as CinematicCamera).request_recenter()
			return


func _find_station_root() -> Node:
	var node: Node = self
	while node != null:
		if node.has_signal(&"previous_level_requested"):
			return node
		node = node.get_parent()
	return null


func _station_id_from(node_name: String) -> StringName:
	var suffix := node_name.trim_prefix("Station").to_lower()
	if suffix.is_valid_int():
		return StringName("station_%02d" % suffix.to_int())
	if suffix in ["42a", "42b", "42c", "43"]:
		return StringName("station_" + suffix)
	return StringName("")
