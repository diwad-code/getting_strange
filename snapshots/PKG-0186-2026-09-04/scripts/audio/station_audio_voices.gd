class_name StationAudioVoices
extends RefCounted

## PKG-0140 wspoldzielone glosy stacji (D-149).
##
## Kontrakt budzetu klatki z PKG-0130 (D-120) dopuszcza 20 odtwarzaczy audio i
## 4 grajace glosy na stacje. Stacja 01 ma dziewiec punktow pamieci, wiec wlasny
## `AudioStreamPlayer2D` przy kazdym rekwizycie natychmiast wyprowadzil budzet
## na 27 wezlow. Warstwa dotyku i ton kotwicy nie potrzebuja jednak wlasnego
## wezla przy kazdym rekwizycie: Lena ma jedna reke i trzyma jedna rzecz naraz.
##
## Kazda stacja dostaje wiec **po jednym** glosie na rodzaj: dotyk, ton kotwicy
## i tarcie przesuwania. Rekwizyt przed zagraniem przestawia glos na swoja
## pozycje swiata, wiec dzwiek dalej jest przestrzenny i dalej dochodzi z
## przedmiotu, a nie z powietrza. Glosy powstaja leniwie — stacja bez rekwizytow
## zakotwiczalnych nie placi za nie ani jednego wezla.

const HAPTIC := &"StationHapticVoice"
const ANCHOR_SUSTAIN := &"StationAnchorSustainVoice"
const ANCHOR_DRAG := &"StationAnchorDragVoice"


## Korzen stacji: najwyzszy przodek lezacy jeszcze pod korzeniem drzewa sceny.
## W testach jednostkowych rekwizyt bywa dzieckiem korzenia drzewa — wtedy sam
## jest swoim korzeniem stacji i glos ladzie przy nim.
static func station_root(node: Node) -> Node:
	if node == null or not node.is_inside_tree():
		return node
	var tree_root := node.get_tree().root
	var current := node
	while current.get_parent() != null and current.get_parent() != tree_root:
		current = current.get_parent()
	return current


## Zwraca wspoldzielony glos stacji, tworzac go przy pierwszym uzyciu.
static func acquire(
	node: Node,
	voice_name: StringName,
	max_distance: float,
	volume_db: float
) -> AudioStreamPlayer2D:
	var host := station_root(node)
	if host == null:
		return null
	var existing := host.get_node_or_null(NodePath(String(voice_name)))
	if existing is AudioStreamPlayer2D:
		return existing as AudioStreamPlayer2D
	var voice := AudioStreamPlayer2D.new()
	voice.name = String(voice_name)
	voice.max_distance = max_distance
	voice.volume_db = volume_db
	voice.bus = &"Master"
	host.add_child(voice)
	return voice


## Zdarzenie jednorazowe na wspoldzielonym glosie: glos idzie tam, gdzie stoi
## rekwizyt, i dopiero wtedy gra.
static func play_at(
	emitter: Node2D,
	voice_name: StringName,
	stream: AudioStreamWAV,
	max_distance: float,
	volume_db: float,
	pitch: float = 1.0
) -> AudioStreamPlayer2D:
	if emitter == null or stream == null:
		return null
	var voice := acquire(emitter, voice_name, max_distance, volume_db)
	if voice == null:
		return null
	voice.global_position = emitter.global_position
	voice.volume_db = volume_db
	voice.stream = stream
	voice.pitch_scale = pitch
	voice.play()
	return voice


## Czy dany rekwizyt trzyma w tej chwili wskazany glos ciagly. Stacja ma jeden
## ton kotwicy; wlascicielstwo pilnuje, zeby drugi rekwizyt nie wyciszyl
## cudzego tonu w polowie wybrzmienia.
static func owns(voice: AudioStreamPlayer2D, claimant: Object) -> bool:
	if voice == null or claimant == null:
		return false
	if not voice.has_meta(&"voice_owner"):
		return false
	return int(voice.get_meta(&"voice_owner")) == claimant.get_instance_id()


static func claim(voice: AudioStreamPlayer2D, claimant: Object) -> void:
	if voice == null or claimant == null:
		return
	voice.set_meta(&"voice_owner", claimant.get_instance_id())


static func release(voice: AudioStreamPlayer2D, claimant: Object) -> void:
	if not owns(voice, claimant):
		return
	voice.remove_meta(&"voice_owner")
