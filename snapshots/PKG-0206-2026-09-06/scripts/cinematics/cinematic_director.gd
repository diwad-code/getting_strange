extends Node

## PKG-0190 — CinematicDirector (autoload).
##
## Mały, data-driven reżyser: nasłuchuje `SceneTree.node_added`, rozpoznaje
## instancję jednej z siedmiu stacji z `CinematicCatalog` po typie węzła
## (`node is Station08` itd. — globalny `class_name`, nie nazwa węzła), i
## podpina się pod jej **istniejący** sygnał wyzwalający jednorazowym
## połączeniem (`CONNECT_ONE_SHOT`). Nie dodaje kolizji, interakcji ani
## bloków wyjścia — stacje pozostają nietknięte poza jednym wyjątkiem
## (`station_13.gd`, nowy sygnał `world_difference_synthesized`
## udokumentowany w `PKG_0190_CINEMATIC_PLACEMENT.md` §5.2).
##
## Jeżeli winieta była już obejrzana (`GameStateManager.is_cinematic_seen`),
## trigger nie pokazuje jej ponownie — flaga fabularna i tak jest już
## zapisana przez samą stację niezależnie od tej warstwy, więc powtórne
## wejście na tę samą stację (backtrack, reload) nie odtwarza sekwencji
## drugi raz.
##
## Celowo bez `await`: reakcja na trigger jest w pełni synchroniczna, chyba
## że w tym samym momencie prezentuje się `CRTDialogueBox` — wtedy reżyser
## czeka na jej `dialogue_finished` przez prawdziwe połączenie sygnałowe
## zamiast pollingu klatek, więc zachowanie jest deterministyczne i
## natychmiastowe w typowym (bez-dialogowym) przypadku, który dotyczy
## wszystkich siedmiu triggerów w tym pakiecie.

const CinematicCatalogScript := preload("res://scripts/cinematics/cinematic_catalog.gd")
const CinematicVignetteScript := preload("res://scripts/cinematics/cinematic_vignette.gd")


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().node_added.connect(_on_node_added)


func _on_node_added(node: Node) -> void:
	if not is_instance_valid(node) or node.has_meta(&"pkg0190_cinematic_bound"):
		return
	var vignette_id := _match_station(node)
	if vignette_id.is_empty():
		return
	node.set_meta(&"pkg0190_cinematic_bound", true)
	_bind(node, vignette_id)


func _match_station(node: Node) -> StringName:
	if node is Station08:
		return CinematicCatalogScript.ID_THRESHOLD
	if node is Station13:
		return CinematicCatalogScript.ID_SYNTHESIS
	if node is Station15:
		return CinematicCatalogScript.ID_SIGNAL
	if node is Station18:
		return CinematicCatalogScript.ID_COMMIT
	if node is Station42A:
		return CinematicCatalogScript.ID_FINALE_A
	if node is Station42B:
		return CinematicCatalogScript.ID_FINALE_B
	if node is Station42C:
		return CinematicCatalogScript.ID_FINALE_C
	return &""


func _bind(station: Node, vignette_id: StringName) -> void:
	var signal_name := CinematicCatalogScript.trigger_signal_of(vignette_id)
	if signal_name.is_empty() or not station.has_signal(signal_name):
		push_warning("CinematicDirector: %s missing trigger signal %s" % [vignette_id, signal_name])
		return
	if CinematicCatalogScript.is_one_arg_trigger(signal_name):
		station.connect(signal_name, _on_trigger_1arg.bind(station, vignette_id), CONNECT_ONE_SHOT)
	else:
		station.connect(signal_name, _on_trigger_0arg.bind(station, vignette_id), CONNECT_ONE_SHOT)


func _on_trigger_0arg(station: Node, vignette_id: StringName) -> void:
	_maybe_play(station, vignette_id)


func _on_trigger_1arg(_arg: Variant, station: Node, vignette_id: StringName) -> void:
	_maybe_play(station, vignette_id)


func _maybe_play(station: Node, vignette_id: StringName) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null and state.has_method("is_cinematic_seen") and bool(state.is_cinematic_seen(vignette_id)):
		return
	if not is_instance_valid(station) or not station.is_inside_tree():
		return
	# Kontrakt PKG-0190: nigdy nie startuj na ekranie dialogu. Jeżeli akurat
	# trwa prezentacja, odłóż start do prawdziwego sygnału `dialogue_finished`
	# zamiast pollować klatki — w typowym przypadku (żaden z siedmiu
	# triggerów nie występuje w trakcie dialogu) ta gałąź w ogóle się nie
	# wykonuje i `_play()` startuje w tej samej klatce, w której padł sygnał.
	var dialogue := _find_dialogue(station)
	if dialogue != null and is_instance_valid(dialogue) and dialogue.is_presenting():
		if dialogue.has_signal(&"dialogue_finished") and not dialogue.dialogue_finished.is_connected(_on_dialogue_cleared):
			dialogue.dialogue_finished.connect(_on_dialogue_cleared.bind(station, vignette_id), CONNECT_ONE_SHOT)
		return
	_play(station, vignette_id)


func _on_dialogue_cleared(station: Node, vignette_id: StringName) -> void:
	_maybe_play(station, vignette_id)


func _find_dialogue(node: Node) -> CRTDialogueBox:
	if node is CRTDialogueBox:
		return node as CRTDialogueBox
	for child in node.get_children():
		var found := _find_dialogue(child)
		if found != null:
			return found
	return null


func _play(station: Node, vignette_id: StringName) -> void:
	var entry := CinematicCatalogScript.entry(vignette_id)
	if entry.is_empty():
		return
	var player := station.get_node_or_null("Player")
	var vignette := CinematicVignetteScript.new()
	vignette.name = "CinematicVignette_" + String(vignette_id)
	vignette.setup(vignette_id, entry, player)
	station.add_child(vignette)
