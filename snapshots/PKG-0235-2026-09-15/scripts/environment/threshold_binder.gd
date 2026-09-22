class_name ThresholdBinder
extends RefCounted

## Installs ThresholdZone on P9 campaign addresses and keeps AirlockZone as closure only.

const ROUTE: Array[StringName] = [
	&"station_01", &"station_02", &"station_03", &"station_04", &"station_05",
	&"station_06", &"station_07", &"station_08", &"station_09", &"station_10",
	&"station_11", &"station_12", &"station_13", &"station_14", &"station_15",
	&"station_16", &"station_17", &"station_18",
	&"station_42a", &"station_42b", &"station_42c", &"station_43",
]


static func is_route_station(station_id: StringName) -> bool:
	return station_id in ROUTE


static func install(station: Node) -> void:
	if station == null or not is_instance_valid(station):
		return
	if station.get_node_or_null("Threshold") != null:
		_rewire(station)
		return
	var spec := spec_for(String(station.name).to_lower())
	if spec.is_empty():
		var sid := _station_id(station)
		spec = spec_for(String(sid))
	if spec.is_empty():
		return
	var zone := ThresholdZone.new()
	zone.name = "Threshold"
	zone.entry_family = spec["family"]
	var width: float = spec["width"]
	var height: float = spec["height"]
	zone.aperture_rect = Rect2(-width * 0.5, -height * 0.5, width, height)
	zone.entry_anchor = Vector2(-36.0, height * 0.5 - 27.0)
	zone.facing = 1.0
	zone.blocking_body_path = NodePath(String(spec.get("door", "")))
	station.add_child(zone)
	_place_on_floor(station, zone, width, height)
	_rewire(station)
	if station.get("is_exit_unlocked") == true:
		zone.is_open = true


static func spec_for(station_id: String) -> Dictionary:
	var raw := station_id.to_lower().replace(" ", "")
	var digits := raw.replace("station_", "").replace("station", "")
	var id := "station_" + digits
	match id:
		"station_03", "station_04":
			return {"family": ThresholdZone.Family.VEHICLE, "width": 58.0, "height": 105.0, "door": "TransitDoor" if id == "station_03" else "ExitDoors"}
		"station_14", "station_15":
			return {"family": ThresholdZone.Family.HATCH, "width": 64.0, "height": 64.0, "door": ""}
		"station_07", "station_08", "station_09", "station_10", "station_13":
			var door := "BuildingEntranceDoor" if id == "station_07" else ""
			if id == "station_08" or id == "station_10":
				door = "ApartmentDoor14" if id == "station_08" else "Geometry/ApartmentDoor14"
			return {"family": ThresholdZone.Family.DOOR, "width": 45.0, "height": 109.0, "door": door}
		"station_12":
			return {"family": ThresholdZone.Family.DOOR, "width": 48.0, "height": 112.0, "door": ""}
		"station_01", "station_02":
			return {"family": ThresholdZone.Family.DOOR, "width": 54.0, "height": 114.0, "door": "ChamberDoor"}
		"station_05", "station_06", "station_11", "station_16", "station_17", "station_18", "station_42a", "station_42b", "station_42c", "station_43":
			return {"family": ThresholdZone.Family.DOOR, "width": 54.0, "height": 114.0, "door": ""}
	return {}


static func complete_from_test(station: Node, player: Node2D = null) -> bool:
	if station == null:
		return false
	install(station)
	var zone := station.get_node_or_null("Threshold")
	if zone == null:
		if station.has_method("_trigger_level_completion"):
			station.call("_trigger_level_completion")
			return station.get("is_level_completed") == true
		return false
	zone.set("is_open", true)
	if player == null:
		player = station.get_node_or_null("Player") as Node2D
	if player == null:
		if zone.has_signal("crossed"):
			zone.emit_signal("crossed")
		return true
	return bool(zone.call("trigger_entry", player, true))


static func _rewire(station: Node) -> void:
	var airlock := station.get_node_or_null("AirlockZone") as Area2D
	if airlock != null:
		for conn in airlock.body_entered.get_connections():
			var cb: Callable = conn["callable"]
			if airlock.body_entered.is_connected(cb):
				airlock.body_entered.disconnect(cb)
	var zone := station.get_node_or_null("Threshold") as ThresholdZone
	if zone == null:
		return
	for conn in zone.crossed.get_connections():
		var cb: Callable = conn["callable"]
		if zone.crossed.is_connected(cb):
			zone.crossed.disconnect(cb)
	var target_cb := Callable(ThresholdBinder, &"_on_threshold_crossed").bind(station)
	zone.crossed.connect(target_cb)


static func _on_threshold_crossed(station: Node) -> void:
	_complete(station)


func _exit_tree() -> void:
	pass


static func disconnect_station(station: Node) -> void:
	if station == null or not is_instance_valid(station):
		return
	var zone := station.get_node_or_null("Threshold") as ThresholdZone
	if zone != null and is_instance_valid(zone):
		for conn in zone.crossed.get_connections():
			var cb: Callable = conn["callable"]
			if zone.crossed.is_connected(cb):
				zone.crossed.disconnect(cb)


static func _complete(station: Node) -> void:
	if station == null or not is_instance_valid(station):
		return
	if bool(station.get("is_level_completed")):
		return
	preload("res://scripts/campaign/gap_ledger.gd").record_on_depart(station)
	if station.has_method("board_line_four"):
		station.call("board_line_four")
		return
	if station.has_method("_trigger_level_completion"):
		station.call("_trigger_level_completion")
		return
	if station.has_method("_complete_campaign"):
		station.call("_complete_campaign")
		return
	if station.has_signal(&"level_completed"):
		station.emit_signal(&"level_completed")


static func _place_on_floor(station: Node, zone: ThresholdZone, width: float, height: float) -> void:
	var floor_top := 296.0
	var floor_node := station.get_node_or_null("Geometry/Floor") as Node2D
	if floor_node != null:
		var shape := floor_node.get_node_or_null("CollisionShape2D") as CollisionShape2D
		if shape != null and shape.shape is RectangleShape2D:
			var rect := shape.shape as RectangleShape2D
			floor_top = floor_node.global_position.y - rect.size.y * 0.5
	var right_margin := 24.0
	var center_x := 640.0 - right_margin - width * 0.5
	var center_y := floor_top - height * 0.5
	zone.position = Vector2(center_x, center_y)


static func _station_id(station: Node) -> StringName:
	var n := String(station.name).to_lower()
	if n.begins_with("station"):
		var digits := n.trim_prefix("station")
		if digits.begins_with("_"):
			return StringName("station" + digits)
		if digits.length() > 0:
			return StringName("station_%s" % digits)
	return StringName(n)
