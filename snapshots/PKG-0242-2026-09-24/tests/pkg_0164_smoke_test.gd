extends SceneTree

## PKG-0164 gate — P9 BUNDLE-23, Station 16 safe analyzer and small cost.
## Technical proof only: three performed interactions, two explicit cost paths,
## informational failed attempts, home echo confirmation, save facts, topology,
## vocabulary and semantic input. It does not prove comprehension or product GO.

const AnchorableObject := preload("res://scripts/interactables/anchorable_object.gd")
const LadderZone := preload("res://scripts/environment/ladder_zone.gd")
const MemoryResonancePoint := preload("res://scripts/interactables/memory_resonance_point.gd")
const PrototypePlayer := preload("res://scripts/player/prototype_player.gd")
const _ThresholdBinder := preload("res://scripts/environment/threshold_binder.gd")

const ENTRY_FACT := &"p7.work_history_and_record.own_record_requested"
const RESPONSE_FACT := &"p9.mechanics.safe_analyzer.response_transferred"
const COST_FACT := &"p9.mechanics.small_cost.manifested"
const COST_CHOICE_FACT := &"p9.mechanics.small_cost.choice"
const ECHO_FACT := &"p9.mechanics.small_cost.home_echo_verified"
const TRACE_FACT := &"p9.mechanics.small_cost.trace"
const FEEDBACK_FACT := &"p9.mechanics.small_cost.safe_trial_feedback"
const MECHANIC_COST_FACT := &"mechanic_cost_observed"
const SMALL_COST_FACT := &"small_cost_manifested"
const HOME_ECHO_FACT := &"home_echo_verified"
const COST_MARTA := "marta_first_meeting_detail_blurred"
const COST_SAMPLE := "sample_exact_second_lost"

const FORBIDDEN_TERMS: Array[String] = [
	"inny świat",
	"miejscowa lena",
	"anchor/yield",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0164 FAILURE: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager musi istnieć")
	if state == null:
		_finish()
		return
	state.campaign_auto_transition_enabled = false
	await _test_scene_contract(state)
	await _test_safe_rejections(state)
	await _test_marta_cost_path(state)
	await _test_sample_cost_path(state)
	_test_vocabulary_and_input()
	state.campaign_auto_transition_enabled = true
	state.reset_campaign(true)
	_finish()


func _open_station(state: Node) -> Station16:
	state.reset_campaign(true)
	state.record_decision(ENTRY_FACT, true)
	var packed := load("res://scenes/levels/station_16.tscn") as PackedScene
	_expect(packed != null, "Scena station_16 musi się ładować")
	if packed == null:
		return null
	var station := packed.instantiate() as Station16
	_expect(station != null, "Scena station_16 musi instantować jako Station16")
	if station == null:
		return null
	root.add_child(station)
	await process_frame
	await physics_frame
	return station


func _close_station(station: Node) -> void:
	if station == null:
		return
	if station.get_parent() == root:
		root.remove_child(station)
	station.free()
	await process_frame


func _test_scene_contract(state: Node) -> void:
	var station := await _open_station(state)
	if station == null:
		return
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "Station 16 musi mieć WorldPixelCompositor")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "Station 16 musi mieć NarrativeGuidanceService")
	_expect(station.get_node_or_null("ReturnZone") != null, "Station 16 musi zachować ReturnZone")
	_expect(station.get_node_or_null("AirlockZone") != null, "Station 16 musi zachować AirlockZone")
	_expect(station.has_signal(&"previous_level_requested"), "Station 16 musi emitować previous_level_requested")
	_expect(station.has_signal(&"level_completed"), "Station 16 musi emitować level_completed")
	_expect(station.get_node_or_null("Props/ServiceLadder") is LadderZone, "Wejście Station 16 musi być drabiną")
	var relay := station.get_node_or_null("Machine/SafeAnalyzerRelay") as AnchorableObject
	_expect(relay != null, "Bezpieczny analizator musi używać donora AnchorableObject")
	if relay != null:
		_expect(relay.state_a_position != relay.state_b_position, "Analizator musi mieć dwie obserwowalne wersje")
		_expect(not relay.state_a_solid and not relay.state_b_solid, "Wersje analizatora nie mogą tworzyć przeszkody ruchowej")
	var props := station.get_node_or_null("Props")
	var interaction_count := 0
	if props != null:
		for child in props.get_children():
			if child is MemoryResonancePoint:
				interaction_count += 1
	_expect(interaction_count == 3, "Station 16 musi mieć dokładnie trzy istotne interakcje")
	_expect(station.get_node_or_null("Props/SafeAnalyzer") != null, "Punkt analizatora musi istnieć")
	_expect(station.get_node_or_null("Props/CostSelector") != null, "Punkt wyboru kosztu musi istnieć")
	_expect(station.get_node_or_null("Props/HomeEchoReceiver") != null, "Punkt echa domu musi istnieć")
	var geometry := station.get_node_or_null("Geometry")
	if geometry != null:
		for child in geometry.get_children():
			_expect(String(child.name) in ["FloorMain", "WallLeft", "WallRight", "Ceiling"], "Station 16 nie może dodawać przeszkody platformowej")
	_expect(not station.is_level_completed, "Station 16 nie może kończyć się przy wejściu")
	await _close_station(station)


func _test_safe_rejections(state: Node) -> void:
	var station := await _open_station(state)
	if station == null:
		return
	_expect(not station.confirm_home_echo(), "Echo bez wyboru kosztu musi zostać odrzucone")
	_expect(state.decisions.get(FEEDBACK_FACT, "") == "cost_choice_required", "Odrzucone echo musi zostawić informację o brakującym wyborze")
	_expect(not station.choose_marta_memory_cost(), "Koszt bez przekazanej odpowiedzi musi zostać odrzucony")
	_expect(state.decisions.get(FEEDBACK_FACT, "") == "response_transfer_required", "Odrzucony koszt musi wskazać brak odpowiedzi")
	_expect(not state.decisions.has(SMALL_COST_FACT), "Odrzucony koszt nie może nadać kosztu")
	_expect(not state.decisions.has(MECHANIC_COST_FACT), "Odrzucony koszt nie może nadać kosztu metody")
	_expect(station.transfer_response_to_safe_analyzer(), "Przekazanie odpowiedzi musi być wykonalne po donorze wejścia")
	_expect(state.decisions.get(RESPONSE_FACT, "") == "living_response_loaded", "Przekazanie musi zostawić namespaced fakt")
	_expect(not station.confirm_home_echo(), "Echo przed wyborem kosztu nadal musi być bezpiecznie odrzucone")
	_expect(state.decisions.get(FEEDBACK_FACT, "") == "cost_choice_required", "Niepełna próba echa musi zostać zapisana")
	_expect(not state.decisions.has(HOME_ECHO_FACT), "Niepełna próba nie może potwierdzić echa")
	_expect(station.choose_marta_memory_cost(), "Poprawny wybór po przekazaniu musi być wykonalny")
	_expect(state.decisions.get(COST_FACT, "") == COST_MARTA, "Wybór Marty musi mieć jawny koszt")
	_expect(state.decisions.has(MECHANIC_COST_FACT), "Koszt metody musi powstać dopiero po wykonanej próbie")
	_expect(station.is_exit_unlocked, "Wyjście pozostaje otwarte niezależnie od wyboru kosztu")
	_expect(station.confirm_home_echo(), "Echo musi dać się potwierdzić po wyborze")
	_expect(station.is_exit_unlocked, "Echo domu musi odblokować wyjście")
	_expect(state.decisions.get(TRACE_FACT, "") == "cost_choice_and_home_echo_verified", "Pełna próba musi zostawić trace")
	await _close_station(station)


func _test_marta_cost_path(state: Node) -> void:
	var station := await _open_station(state)
	if station == null:
		return
	var analyzer := station.get_node_or_null("Props/SafeAnalyzer") as MemoryResonancePoint
	var selector := station.get_node_or_null("Props/CostSelector") as MemoryResonancePoint
	var echo := station.get_node_or_null("Props/HomeEchoReceiver") as MemoryResonancePoint
	_expect(analyzer != null and selector != null and echo != null, "Trzy punkty Station 16 muszą być dostępne jako interakcje")
	if analyzer != null and selector != null and echo != null:
		analyzer.is_player_in_range = true
		analyzer.trigger_interaction()
		_expect(station.is_response_transferred, "Interakcja analizatora musi przekazać odpowiedź")
		var player := station.get_node_or_null("Player") as PrototypePlayer
		if player != null:
			player.global_position = Vector2(selector.global_position.x - 24.0, selector.global_position.y)
		selector.is_player_in_range = true
		selector.trigger_interaction()
		_expect(station.selected_cost == StringName(COST_MARTA), "Wejście z lewej musi wybrać pamięć spotkania")
		echo.is_player_in_range = true
		echo.trigger_interaction()
		_expect(station.is_home_echo_confirmed, "Interakcja odbiornika musi potwierdzić echo domu")
	_expect(state.decisions.get(SMALL_COST_FACT, "") == COST_MARTA, "Kanoniczny small_cost_manifested musi przechować wybraną cenę")
	_expect(state.decisions.get(HOME_ECHO_FACT, false) == true, "Kanoniczny home_echo_verified musi powstać po echa")
	_expect(station.is_exit_unlocked, "Pełna ścieżka Marty musi odblokować wyjście")
	_expect(not station.is_level_completed, "Odblokowanie wyjścia nie może samo kończyć sceny")
	var player := station.get_node_or_null("Player") as PrototypePlayer
	if player != null:
		_ThresholdBinder.install(station)
		_ThresholdBinder.complete_from_test(station, player)
		await physics_frame
		await physics_frame
	_expect(station.is_level_completed, "Ścieżka Marty musi kończyć się w AirlockZone")
	await _close_station(station)


func _test_sample_cost_path(state: Node) -> void:
	var station := await _open_station(state)
	if station == null:
		return
	_expect(station.transfer_response_to_safe_analyzer(), "Druga ścieżka musi przenieść odpowiedź")
	_expect(station.choose_sample_second_cost(), "Wybór dokładnej sekundy musi być wykonalny")
	_expect(state.decisions.get(COST_CHOICE_FACT, "") == "sample_second", "Druga ścieżka musi mieć osobny wybór")
	_expect(state.decisions.get(COST_FACT, "") == COST_SAMPLE, "Druga ścieżka musi zapisać utratę dokładnej sekundy")
	_expect(station.confirm_home_echo(), "Echo musi być dostępne po obu wyborach")
	_expect(state.decisions.get(ECHO_FACT, false) == true, "Namespaced echo musi być prawdziwe")
	_expect(station.is_exit_unlocked, "Druga ścieżka musi odblokować wyjście")
	_expect(not station.choose_marta_memory_cost(), "Po wyborze nie wolno nadpisać ceny")
	await _close_station(station)


func _test_vocabulary_and_input() -> void:
	var source := FileAccess.get_file_as_string("res://scripts/levels/station_16.gd").to_lower()
	for term in FORBIDDEN_TERMS:
		_expect(not source.contains(term), "station_16.gd nie może zawierać przedwczesnego terminu: %s" % term)
	_expect(source.contains("mechanic_cost_observed"), "Station 16 musi zapisywać koszt metody po wykonanej próbie")
	_expect(source.contains("small_cost_manifested"), "Station 16 musi zapisywać kanoniczny mały koszt")
	_expect(source.contains("home_echo_verified"), "Station 16 musi zapisywać kanoniczne echo domu")
	_expect(source.contains("func _complete_if_player_already_in_airlock"), "Station 16 musi domykać scenę dla gracza już w śluzie")
	_expect(source.contains("func _draw_state_layer() -> void:"), "Station 16 musi mieć lokalny przebieg stanu")
	_expect(source.find("VectorStageStyle.draw_play_plane") < source.find("_draw_analyzer_room"), "Lokalny rysunek musi wywołać play plane przed stanem stacji")
	_expect(not source.contains("draw_string("), "Nowa treść nie może być rysowana jako tekst w Layer 0")
	_expect(not source.contains("KEY_"), "Station 16 nie może hardkodować klawisza")
	_expect(InputMap.has_action(&"interact"), "Projekt musi udostępniać semantyczną akcję interact")
	_expect(InputMap.has_action(&"move_up") and InputMap.has_action(&"move_down"), "Drabina musi korzystać z semantycznych osi ruchu")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0164 PASS: P9 BUNDLE-23 Station 16 analyzer, cost and home echo contracts")
		quit(0)
		return
	printerr("PKG-0164 FAIL: %d failure(s)" % _failures.size())
	quit(1)
