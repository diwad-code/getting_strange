class_name GapLedger
extends RefCounted

const GuidanceBeatScript := preload("res://scripts/core/guidance_beat.gd")

## Continuous-passability gap register (D-192 / GATE-FLOW).
## A gap opens when the player leaves an address without a consequential reading.
## It never locks the door; it blocks a later verb and names the miss in Lena's voice.

const CATALOG := {
	"s01.measurement_unrepeated": {
		"opened_from": "station_01",
		"origin_station": "station_01",
		"blocks": ["s01.secure_raw_sample"],
		"station_flag": "is_measurement_repeated",
		"close_fact": "p9.opening.measurement_repeated",
		"thought_pl": "Powinnam powtórzyć odczyt.",
		"thought_en": "I should repeat the reading.",
	},
	"s02.route_time_unread": {
		"opened_from": "station_02",
		"origin_station": "station_02",
		"blocks": ["s03.read_departure_board"],
		"station_flag": "is_detour_time_compared",
		"close_fact": "p7.sample_and_promise.route_time_confirmed",
		"thought_pl": "Nie sprawdziłam, ile to obejście naprawdę zajmuje.",
		"thought_en": "I never checked how long the detour actually takes.",
	},
	"s03.departure_unread": {
		"opened_from": "station_03",
		"origin_station": "station_03",
		"blocks": ["s03.reply_to_marta"],
		"station_flag": "is_departure_board_read",
		"close_fact": "p7.sample_and_promise.departure_time_observed",
		"thought_pl": "Nie spojrzałam na rozkład.",
		"thought_en": "I didn't look at the timetable.",
	},
	"s03.marta_unanswered": {
		"opened_from": "station_03",
		"origin_station": "station_03",
		"blocks": ["s03.board_line_four"],
		"station_flag": "is_marta_reply_sent",
		"close_fact": "p7.sample_and_promise.time_notice_sent",
		"thought_pl": "Powinnam jej odpisać.",
		"thought_en": "I should reply to her.",
	},
	"s04.reader_unread": {
		"opened_from": "station_04",
		"origin_station": "station_04",
		"blocks": ["s04.stow_reader"],
		"station_flag": "is_reader_buffer_observed",
		"close_fact": "p7.work_history_and_record.reader_buffer_seen",
		"thought_pl": "Nie sprawdziłam czytnika.",
		"thought_en": "I didn't check the reader.",
	},
	"s05.street_unread": {
		"opened_from": "station_05",
		"origin_station": "station_05",
		"blocks": ["s05.verify_sample_case"],
		"station_flag": "is_street_route_checked",
		"close_fact": "p7.return_under_control.street_route_checked",
		"thought_pl": "Nie sprawdziłam ulicy do domu.",
		"thought_en": "I didn't check the street home.",
	},
	"s06.timetable_unread": {
		"opened_from": "station_06",
		"origin_station": "station_06",
		"blocks": ["s06.ask_vendor"],
		"station_flag": "is_timetable_inspected",
		"close_fact": "p7.address_and_record.public_timetable_seen",
		"thought_pl": "Rozkład na kiosku zostawiłam nietknięty.",
		"thought_en": "I left the kiosk timetable unread.",
	},
	"s07.document_unread": {
		"opened_from": "station_07",
		"origin_station": "station_07",
		"blocks": ["s07.inspect_directory"],
		"station_flag": "is_address_document_compared",
		"close_fact": "p7.address_and_record.address_document_compared",
		"thought_pl": "Nie porównałam adresu na papierze.",
		"thought_en": "I didn't compare the address on paper.",
	},
	"s08.neighbour_unspoken": {
		"opened_from": "station_08",
		"origin_station": "station_08",
		"blocks": ["s08.unlock_apartment"],
		"station_flag": "is_neighbour_spoken_to",
		"close_fact": "p7.foreign_daily_life.neighbour_spoken",
		"thought_pl": "Nie zagadnęłam sąsiadki.",
		"thought_en": "I didn't speak to the neighbour.",
	},
	"s09.floor_record_unread": {
		"opened_from": "station_09",
		"origin_station": "station_09",
		"blocks": ["s10.try_key"],
		"station_flag": "is_floor_record_read",
		"close_fact": "p7.foreign_daily_life.floor_record_read",
		"thought_pl": "Pominęłam zapis na piętrze.",
		"thought_en": "I skipped the floor record.",
	},
	"s10.key_untried": {
		"opened_from": "station_10",
		"origin_station": "station_10",
		"blocks": ["s11.private_sources"],
		"station_flag": "is_apartment_key_tried",
		"close_fact": "p7.foreign_daily_life.key_tried",
		"thought_pl": "Nie sprawdziłam klucza w zamku.",
		"thought_en": "I didn't try the key in the lock.",
	},
	"s11.photograph_unread": {
		"opened_from": "station_11",
		"origin_station": "station_11",
		"blocks": ["s12.identity_trace"],
		"station_flag": "is_photograph_inspected",
		"close_fact": "p7.marta_threshold.photograph_seen",
		"thought_pl": "Zostawiłam zdjęcie nietknięte.",
		"thought_en": "I left the photograph untouched.",
	},
	"s12.message_unheard": {
		"opened_from": "station_12",
		"origin_station": "station_12",
		"blocks": ["s13.questions"],
		"station_flag": "is_message_heard",
		"close_fact": "p7.marta_threshold.message_heard",
		"thought_pl": "Nie odsłuchałam nagrania.",
		"thought_en": "I didn't listen to the recording.",
	},
	"s13.documents_unread": {
		"opened_from": "station_13",
		"origin_station": "station_13",
		"blocks": ["s13.seals"],
		"station_flag": "are_both_documents_read",
		"close_fact": "p7.marta_threshold.documents_read",
		"thought_pl": "Szuflady nie otworzyłam do końca.",
		"thought_en": "I didn't finish the drawer.",
	},
	"s14.lesson_unperformed": {
		"opened_from": "station_14",
		"origin_station": "station_14",
		"blocks": ["s15.signal_test"],
		"station_flag": "",
		"close_fact": "p7.marta_threshold.trace",
		"thought_pl": "Wyszłam, zanim maszyna pokazała oba stany.",
		"thought_en": "I left before the machine showed both states.",
	},
	"s15.signal_unconfirmed": {
		"opened_from": "station_15",
		"origin_station": "station_15",
		"blocks": ["s16.analyzer"],
		"station_flag": "is_local_signal_confirmed",
		"close_fact": "local_lena_signal_confirmed",
		"thought_pl": "Nie domknęłam próby sygnału.",
		"thought_en": "I didn't finish the signal trial.",
	},
	"s16.cost_unmanifested": {
		"opened_from": "station_16",
		"origin_station": "station_16",
		"blocks": ["s17.consent_scope"],
		"station_flag": "is_home_echo_confirmed",
		"close_fact": "p9.mechanics.small_cost.home_echo_verified",
		"thought_pl": "Nie potwierdziłam echa domu.",
		"thought_en": "I didn't confirm the home echo.",
	},
	"s17.consent_unscoped": {
		"opened_from": "station_17",
		"origin_station": "station_17",
		"blocks": ["s18.commit_method"],
		"station_flag": "is_consent_scope_recorded",
		"close_fact": "jakub_consent_state",
		"thought_pl": "Nie zapisałam zakresu zgody Jakuba.",
		"thought_en": "I didn't record Jakub's consent scope.",
	},
	"s18.method_uncommitted": {
		"opened_from": "station_18",
		"origin_station": "station_18",
		"blocks": ["s42.finale_method"],
		"station_flag": "is_method_committed",
		"close_fact": "method_committed",
		"thought_pl": "Wyszłam, nie zatwierdzając metody.",
		"thought_en": "I left without committing a method.",
	},
}

const FEEDBACK_TO_GAP := {
	"measurement_required": "s01.measurement_unrepeated",
	"route_time_required": "s02.route_time_unread",
	"departure_required": "s03.departure_unread",
	"marta_reply_required": "s03.marta_unanswered",
	"closure_required": "s02.route_time_unread",
	"detour_time_required": "s02.route_time_unread",
	"forecast_comparison_required": "s18.method_uncommitted",
	"marta_truth_required": "s18.method_uncommitted",
	"forecast_and_consent_inventory_required": "s17.consent_unscoped",
}


static func catalog() -> Dictionary:
	return CATALOG


static func ensure_exit_open(station: Node) -> void:
	if station == null or not is_instance_valid(station):
		return
	if station.has_method("_unlock_exit"):
		station.call("_unlock_exit")
	elif station.has_method("unlock_exit"):
		station.call("unlock_exit")
	elif station.has_method("unlock_exit_for_return"):
		station.call("unlock_exit_for_return")
	else:
		station.set("is_exit_unlocked", true)
	var zone := station.get_node_or_null("Threshold")
	if zone != null:
		zone.set("is_open", true)
	sync_closed_from_station(station)


static func record_on_depart(station: Node) -> void:
	if station == null:
		return
	var sid := _station_id(station)
	var gsm: Node = _gsm(station)
	for gap_id in CATALOG.keys():
		var spec: Dictionary = CATALOG[gap_id]
		if String(spec.get("opened_from", "")) != sid:
			continue
		if _is_satisfied(station, spec, gsm):
			_close(gsm, StringName(gap_id))
			continue
		_open(gsm, StringName(gap_id), spec, sid)


static func after_decision(decision_id: StringName, value: Variant) -> void:
	var gsm: Node = _gsm(null)
	if gsm == null:
		return
	var key := String(decision_id)
	for gap_id in CATALOG.keys():
		var spec: Dictionary = CATALOG[gap_id]
		if String(spec.get("close_fact", "")) != key:
			continue
		if _value_is_present(value):
			_close(gsm, StringName(gap_id))


static func annotate_feedback(station: Node, feedback: StringName) -> void:
	var mapped := String(FEEDBACK_TO_GAP.get(String(feedback), ""))
	if mapped.is_empty():
		return
	speak(station, StringName(mapped))


static func speak(station: Node, gap_id: StringName) -> void:
	if station == null:
		return
	var spec: Dictionary = CATALOG.get(String(gap_id), {})
	if spec.is_empty():
		return
	var text := String(spec.get("thought_pl", ""))
	if text.is_empty():
		return
	var surface := station.get_node_or_null("InnerThoughtSurface")
	if surface != null and surface.has_method("present_thought"):
		var beat = GuidanceBeatScript.new()
		beat.beat_id = gap_id
		beat.tier = 2
		beat.thought_kind = &"intention"
		beat.truth_scope = &"fallible"
		beat.text_pl = text
		surface.call("present_thought", beat, text)


static func sync_closed_from_station(station: Node) -> void:
	var gsm: Node = _gsm(station)
	if gsm == null:
		return
	var sid := _station_id(station)
	for gap_id in CATALOG.keys():
		var spec: Dictionary = CATALOG[gap_id]
		if String(spec.get("origin_station", "")) != sid and String(spec.get("opened_from", "")) != sid:
			continue
		if _is_satisfied(station, spec, gsm):
			_close(gsm, StringName(gap_id))


static func _is_satisfied(station: Node, spec: Dictionary, gsm: Node) -> bool:
	var flag := String(spec.get("station_flag", ""))
	if flag != "" and station.get(flag) != null and bool(station.get(flag)):
		return true
	var close_fact := String(spec.get("close_fact", ""))
	if close_fact != "" and gsm != null and gsm.has_method("has_decision"):
		if bool(gsm.call("has_decision", StringName(close_fact))):
			var stored: Variant = gsm.call("get_decision", StringName(close_fact)) if gsm.has_method("get_decision") else null
			return _value_is_present(stored)
	if close_fact != "" and gsm != null:
		var decisions: Variant = gsm.get("decisions")
		if decisions is Dictionary and (decisions as Dictionary).has(StringName(close_fact)):
			return _value_is_present((decisions as Dictionary)[StringName(close_fact)])
	return false


static func _value_is_present(value: Variant) -> bool:
	if value == null:
		return false
	match typeof(value):
		TYPE_BOOL:
			return bool(value)
		TYPE_STRING:
			return not String(value).is_empty()
		TYPE_INT, TYPE_FLOAT:
			return true
	return true


static func _open(gsm: Node, gap_id: StringName, spec: Dictionary, opened_at: String) -> void:
	if gsm == null or not gsm.has_method("open_gap"):
		return
	var record := {
		"gap_id": String(gap_id),
		"origin_station": String(spec.get("origin_station", "")),
		"blocks": spec.get("blocks", []),
		"thought_pl": String(spec.get("thought_pl", "")),
		"thought_en": String(spec.get("thought_en", "")),
		"opened_at_station": opened_at,
	}
	gsm.call("open_gap", gap_id, record)


static func _close(gsm: Node, gap_id: StringName) -> void:
	if gsm != null and gsm.has_method("close_gap"):
		gsm.call("close_gap", gap_id)


static func _gsm(station: Node) -> Node:
	if station != null:
		return station.get_node_or_null("/root/GameStateManager")
	var tree := Engine.get_main_loop()
	if tree == null:
		return null
	return tree.root.get_node_or_null("GameStateManager")


static func _station_id(station: Node) -> String:
	var n := String(station.name).to_lower().replace(" ", "")
	if n.begins_with("station_"):
		return n
	if n.begins_with("station"):
		return "station_" + n.trim_prefix("station")
	return n
