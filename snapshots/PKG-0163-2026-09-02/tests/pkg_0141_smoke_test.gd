extends SceneTree

## PKG-0141 Smoke Test — unifikacja kamery kinowej na 45 stacjach i tryb
## ograniczonego ruchu.
##
## Czego pilnuje ta bramka:
##
## 1. Jeden kontrakt kamery (D-150). Kazda z 45 scen kampanii deklaruje wezel
##    `Camera` ze skryptem `CinematicCamera`, zaden nie zostawia starej nazwy
##    `Camera2D`, a po zaladowaniu stacji kamera ma podpiety cel i niepusta
##    liste komor. Bramka sprawdza WSZYSTKIE 45 scen, nie probke — regresja na
##    jednej stacji jest tu tak samo czerwona jak na wszystkich.
## 2. Kadr dialogowy i budzet kadrowania (D-133, D-136) dzialaja na stacjach
##    finalowych 33–43: zejscie kadru miesci sie w namalowanym fartuchu, wiec
##    zadna stacja finalowa nie kadruje na pustke.
## 3. Sledzenie pionowe i tlumienie transportu pionowego (D-148) dziala tam,
##    gdzie stacja ma `ServiceLift` albo `LadderZone` — czyli na 25 i 34.
## 4. Tryb ograniczonego ruchu (D-151). Jeden przelacznik tlumi migotanie i
##    pulsowanie `AtmosphereRig`, wstrzas kamery, oddech `AnchorResonance`
##    i emisje dekoracyjnych mikro-czastek. Snap 2 px kompozytora (D-120)
##    zostaje nienaruszony w obu trybach, a swiatlo nie gasnie — traci tylko
##    amplitude.
## 5. Opcja jest w `SettingsOverlay`, zlokalizowana PL/EN i trwala: przezywa
##    zapis na dysk oraz zmiane sceny.
##
## Bramka nigdy nie wola `_draw()` bezposrednio — silnik zglasza wtedy `ERROR:`,
## a `verify.ps1` traktuje kazda taka linie jako awarie bramki.

const CAMPAIGN_DIR := "res://scenes/levels"

const ALL_CAMPAIGN_SCENE_IDS: Array[StringName] = [
	&"station_01", &"station_02", &"station_03", &"station_04", &"station_05",
	&"station_06", &"station_07", &"station_08", &"station_09", &"station_10",
	&"station_11", &"station_12", &"station_13", &"station_14", &"station_15",
	&"station_16", &"station_17", &"station_18", &"station_19", &"station_20",
	&"station_21", &"station_22", &"station_23", &"station_24", &"station_25",
	&"station_26", &"station_27", &"station_28", &"station_29", &"station_30",
	&"station_31", &"station_32", &"station_33", &"station_34", &"station_35",
	&"station_36", &"station_37", &"station_38", &"station_39", &"station_40",
	&"station_41", &"station_42a", &"station_42b", &"station_42c", &"station_43",
]

## Akt IV i trzy finaly — dlug potwierdzony w PKG-0140 i zamykany tutaj.
const FINALE_SCENE_IDS: Array[StringName] = [
	&"station_33", &"station_34", &"station_35", &"station_36", &"station_37",
	&"station_38", &"station_39", &"station_40", &"station_41",
	&"station_42a", &"station_42b", &"station_42c", &"station_43",
]

## Jedyne stacje kampanii z realnym transportem pionowym (`ServiceLift`).
const VERTICAL_TRANSIT_SCENE_IDS: Array[StringName] = [&"station_25", &"station_34"]

const VIEW_SIZE := Vector2(640.0, 360.0)
const STEP := 1.0 / 60.0

var _failures: Array[String] = []
var _state: Node


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		printerr("FAIL: " + message)


func _run() -> void:
	print("================================================================================")
	print("  PKG-0141 SMOKE TEST: unified cinematic camera (45 scenes) + reduced motion")
	print("================================================================================")

	_state = root.get_node_or_null("GameStateManager")
	_expect(_state != null, "GameStateManager autoload musi istniec")
	MotionAccessibility.reset()

	print("1. Kontrakt scen: nazwa wezla kamery w 45 plikach .tscn...")
	_test_scene_files()

	print("2. Kontrakt runtime: cel i komory na 45 zaladowanych stacjach...")
	await _test_camera_binding_all_stations()

	print("3. Budzet kadrowania na stacjach finalowych 33–43...")
	await _test_framing_budget_finales()

	print("4. Transport pionowy: tlumienie kadru na stacjach 25 i 34...")
	await _test_vertical_transit_stations()

	print("5. Tryb ograniczonego ruchu: kontrakt modulu...")
	_test_motion_accessibility_module()

	print("6. Tryb ograniczonego ruchu: wstrzas kamery i snap 2 px...")
	await _test_reduced_motion_camera()

	print("7. Tryb ograniczonego ruchu: oddech pola kotwiczenia...")
	_test_reduced_motion_anchor()

	print("8. Tryb ograniczonego ruchu: swiatlo i mikro-czastki AtmosphereRig...")
	await _test_reduced_motion_atmosphere()

	print("9. Tryb ograniczonego ruchu: trwalosc, ustawienia i lokalizacja...")
	await _test_reduced_motion_settings()

	print("10. Tryb ograniczonego ruchu: trwalosc miedzy scenami...")
	await _test_reduced_motion_across_scenes()

	MotionAccessibility.reset()
	if _state:
		_state.set_reduced_motion(false, true)
		_state.restore_default_settings(true)

	for i in range(6):
		await process_frame

	_finish()


# ─── 1. Kontrakt scen ─────────────────────────────────────────────────────────

## Statyczna bariera regresji. Runtime moze naprawic brakujaca kamere fabryka
## awaryjna w `StationCameraRig.bind()`; plik sceny nie moze. Ta sekcja czyta
## surowy `.tscn`, wiec zadna stacja nie przemyci sie z powrotem na `Camera2D`
## ani nie zgubi wezla kamery.
func _test_scene_files() -> void:
	var checked := 0
	for scene_id in ALL_CAMPAIGN_SCENE_IDS:
		var path := "%s/%s.tscn" % [CAMPAIGN_DIR, scene_id]
		var file := FileAccess.open(path, FileAccess.READ)
		_expect(file != null, "%s: plik sceny musi byc czytelny" % scene_id)
		if file == null:
			continue
		var text := file.get_as_text()
		file.close()
		checked += 1
		_expect(
			text.contains('[node name="Camera" type="Camera2D" parent="."'),
			"%s: scena musi deklarowac wezel kamery o kanonicznej nazwie 'Camera'" % scene_id
		)
		_expect(
			not text.contains('[node name="Camera2D"'),
			"%s: stara nazwa 'Camera2D' nie moze wrocic do kampanii" % scene_id
		)
		_expect(
			text.contains('target = NodePath("../Player")'),
			"%s: scena musi deklarowac cel kamery jako gracza" % scene_id
		)
	_expect(checked == 45, "kontrakt scen musi objac wszystkie 45 plikow (objal %d)" % checked)
	print("   45 plikow scen: jedna nazwa wezla, jeden cel.")


# ─── 2. Kontrakt runtime na 45 stacjach ──────────────────────────────────────

func _test_camera_binding_all_stations() -> void:
	var checked := 0
	for scene_id in ALL_CAMPAIGN_SCENE_IDS:
		var station := await _open_station(scene_id)
		if station == null:
			continue
		checked += 1

		_expect(
			station.get_node_or_null("Camera2D") == null,
			"%s: w drzewie nie moze zostac wezel o starej nazwie" % scene_id
		)

		var camera := StationCameraRig.resolve(station)
		_expect(camera != null, "%s: `StationCameraRig.resolve()` musi znalezc kamere" % scene_id)
		if camera == null:
			_close_station(station)
			await process_frame
			continue

		var cameras := _collect_cameras(station)
		_expect(
			cameras.size() == 1,
			"%s: stacja musi miec dokladnie jedna kamere kinowa (ma %d)" % [scene_id, cameras.size()]
		)

		var player := station.get_node_or_null("Player")
		_expect(
			camera.target == player and player != null,
			"%s: `CinematicCamera.target` musi wskazywac gracza" % scene_id
		)
		_expect(
			not camera.chamber_bounds.is_empty(),
			"%s: `setup_chambers()` musi byc wolane realnymi granicami komory" % scene_id
		)
		_expect(
			camera.get_active_chamber_rect().size == VIEW_SIZE,
			"%s: komora stacji musi obejmowac caly kadr 640x360" % scene_id
		)
		_expect(
			StationCameraRig.is_bound(station),
			"%s: stacja musi spelniac pelny kontrakt `StationCameraRig`" % scene_id
		)
		_expect(camera.view_size == VIEW_SIZE, "%s: kamera musi kadrowac 640x360" % scene_id)
		_expect(camera.pixel_snap_enabled, "%s: snap 2 px musi zostac wlaczony" % scene_id)

		# Kadr musi dojechac do gracza, a nie zostac na (320, 180) tylko dlatego,
		# ze stacja tam zaparkowala wezel.
		camera._physics_process(STEP)
		_expect(camera.is_on_pixel_grid(), "%s: kadr musi zostac na siatce 2 px" % scene_id)

		_close_station(station)
		await process_frame

	_expect(checked == 45, "kontrakt runtime musi objac wszystkie 45 stacji (objal %d)" % checked)
	print("   45 stacji: cel podpiety, komory ustawione, kadr na siatce 2 px.")


# ─── 3. Budzet kadrowania na finalach ────────────────────────────────────────

func _test_framing_budget_finales() -> void:
	for scene_id in FINALE_SCENE_IDS:
		var station := await _open_station(scene_id)
		if station == null:
			continue
		var camera := StationCameraRig.resolve(station)
		if camera == null:
			_close_station(station)
			await process_frame
			continue

		_expect(
			camera.dialogue_framing_offset > 0.0,
			"%s: kadr dialogowy musi byc aktywny (D-133)" % scene_id
		)
		_expect(
			is_equal_approx(camera.stage_apron, VectorStageStyle.STAGE_APRON),
			"%s: kamera musi liczyc budzet wzgledem namalowanego fartucha" % scene_id
		)

		for i in range(12):
			camera._physics_process(STEP)

		var focus := camera.get_vertical_focus()
		var budget := camera.get_framing_budget(focus)
		_expect(
			budget >= camera.dialogue_framing_offset,
			"%s: budzet kadrowania (%.2f) musi udzwignac zejscie kadru (%.2f) — inaczej stacja kadruje na pustke" % [
				scene_id, budget, camera.dialogue_framing_offset
			]
		)
		_expect(camera.is_on_pixel_grid(), "%s: kadr finalowy musi zostac na siatce 2 px" % scene_id)

		_close_station(station)
		await process_frame
	print("   13 stacji finalowych: kadr dialogowy miesci sie w malowanym fartuchu.")


# ─── 4. Transport pionowy ────────────────────────────────────────────────────

func _test_vertical_transit_stations() -> void:
	for scene_id in VERTICAL_TRANSIT_SCENE_IDS:
		var station := await _open_station(scene_id)
		if station == null:
			continue
		var camera := StationCameraRig.resolve(station)
		var player := station.get_node_or_null("Player")
		_expect(
			_find_service_lift(station) != null,
			"%s: stacja transportu pionowego musi miec `ServiceLift`" % scene_id
		)
		if camera == null or player == null:
			_close_station(station)
			await process_frame
			continue

		_expect(
			camera.traversal_damping_enabled,
			"%s: tlumienie transportu pionowego musi byc wlaczone (D-148)" % scene_id
		)
		_expect(camera.vertical_follow_enabled, "%s: sledzenie pionowe musi byc wlaczone" % scene_id)

		for i in range(20):
			camera._physics_process(STEP)
		_expect(
			is_zero_approx(camera.get_traversal_blend()),
			"%s: chodzaca Lena nie moze wlaczac trybu transportowego (%.3f)" % [
				scene_id, camera.get_traversal_blend()
			]
		)

		player.set(&"is_climbing", true)
		camera._physics_process(STEP)
		var first_blend: float = camera.get_traversal_blend()
		_expect(
			first_blend > 0.0 and first_blend < 1.0,
			"%s: wejscie w transport pionowy nie moze przelaczac kadru skokiem (%.3f)" % [
				scene_id, first_blend
			]
		)
		for i in range(180):
			camera._physics_process(STEP)
		_expect(
			camera.get_traversal_blend() > 0.95,
			"%s: transport pionowy musi domknac tryb tlumienia (%.3f)" % [
				scene_id, camera.get_traversal_blend()
			]
		)
		_expect(camera.is_on_pixel_grid(), "%s: tlumiony kadr musi zostac na siatce 2 px" % scene_id)

		var rect := camera.get_active_chamber_rect()
		var focus := camera.get_vertical_focus()
		_expect(
			focus >= rect.position.y and focus <= rect.end.y,
			"%s: ognisko pionowe musi zostac wewnatrz komory (%.2f)" % [scene_id, focus]
		)

		player.set(&"is_climbing", false)
		for i in range(180):
			camera._physics_process(STEP)
		_expect(
			is_zero_approx(camera.get_traversal_blend()),
			"%s: zejscie z transportu musi wygasic tlumienie" % scene_id
		)

		_close_station(station)
		await process_frame
	print("   Stacje 25 i 34: tlumienie transportu pionowego narasta i opada plynnie.")


# ─── 5. Modul trybu ograniczonego ruchu ──────────────────────────────────────

func _test_motion_accessibility_module() -> void:
	MotionAccessibility.reset()
	_expect(
		not MotionAccessibility.is_reduced_motion(),
		"kanon 3.0 jest kanonem ruchomym: tryb musi byc domyslnie wylaczony"
	)
	_expect(is_equal_approx(MotionAccessibility.motion_scale(), 1.0), "domyslna amplituda ruchu = 1")
	_expect(MotionAccessibility.allows_micro_particles(), "domyslnie mikro-czastki emituja")
	_expect(MotionAccessibility.allows_camera_shake(), "domyslnie wstrzas kamery jest dozwolony")

	MotionAccessibility.set_reduced_motion(true)
	_expect(MotionAccessibility.is_reduced_motion(), "przelacznik musi realnie wlaczac tryb")
	_expect(is_zero_approx(MotionAccessibility.motion_scale()), "tryb musi zerowac amplitude ruchu")
	_expect(not MotionAccessibility.allows_micro_particles(), "tryb musi gasic mikro-czastki")
	_expect(not MotionAccessibility.allows_camera_shake(), "tryb musi zdejmowac wstrzas kamery")

	MotionAccessibility.reset()
	_expect(not MotionAccessibility.is_reduced_motion(), "`reset()` musi wracac do stanu fabrycznego")


# ─── 6. Kamera w trybie ograniczonego ruchu ──────────────────────────────────

func _test_reduced_motion_camera() -> void:
	MotionAccessibility.reset()
	var camera := CinematicCamera.new()
	camera.name = "PKG0141Camera"
	root.add_child(camera)
	camera.setup_chambers([Rect2(Vector2.ZERO, VIEW_SIZE)] as Array[Rect2])
	await process_frame

	# Tryb normalny: wstrzas realnie rusza kadrem.
	camera.add_trauma(0.9)
	var moved := false
	for i in range(12):
		camera._physics_process(STEP)
		if camera.offset != Vector2.ZERO:
			moved = true
		if not camera.is_on_pixel_grid():
			_expect(false, "wstrzas w trybie normalnym musi zostac na siatce 2 px")
			break
	_expect(moved, "w trybie normalnym `add_trauma()` musi realnie poruszyc kadrem")

	# Tryb ograniczony: wstrzas nie ma prawa dotknac kadru.
	MotionAccessibility.set_reduced_motion(true)
	camera.add_trauma(1.0)
	for i in range(12):
		camera._physics_process(STEP)
		_expect(
			camera.offset == Vector2.ZERO,
			"tryb ograniczonego ruchu musi w calosci zdjac wstrzas kamery"
		)
		_expect(camera.is_on_pixel_grid(), "snap 2 px musi zostac nienaruszony w trybie ograniczonym")

	# Kadr dialogowy i klamp komory nie sa ruchem peryferyjnym — zostaja.
	_expect(
		camera.dialogue_framing_offset > 0.0,
		"tryb ograniczonego ruchu nie moze zabierac kadru dialogowego"
	)
	_expect(
		is_equal_approx(CinematicCamera.PIXEL_GRID, 2.0),
		"snap kompozytora musi zostac przy 2 px w obu trybach"
	)

	MotionAccessibility.reset()
	camera.queue_free()
	await process_frame


# ─── 7. Oddech pola kotwiczenia ──────────────────────────────────────────────

func _test_reduced_motion_anchor() -> void:
	MotionAccessibility.reset()
	var envelope := AnchorResonance.new()
	envelope.hold()
	for i in range(20):
		envelope.advance(STEP)
	envelope.feed_drag(1.0)

	var moving_samples: Array[float] = []
	for i in range(30):
		envelope.advance(STEP)
		envelope.feed_drag(1.0)
		moving_samples.append(envelope.sustain_envelope())
	var moving_spread: float = moving_samples.max() - moving_samples.min()
	_expect(moving_spread > 0.01, "w trybie normalnym pole kotwiczenia musi oddychac (%.4f)" % moving_spread)

	MotionAccessibility.set_reduced_motion(true)
	var still_samples: Array[float] = []
	var still_drag: Array[float] = []
	for i in range(30):
		envelope.advance(STEP)
		envelope.feed_drag(1.0)
		still_samples.append(envelope.sustain_envelope())
		still_drag.append(envelope.drag_envelope())
	var still_spread: float = still_samples.max() - still_samples.min()
	_expect(
		still_spread < 0.0001,
		"tryb ograniczonego ruchu musi zatrzymac oddech pola kotwiczenia (%.6f)" % still_spread
	)
	_expect(
		still_samples.min() > 0.0,
		"tryb tlumi ruch, nie informacje: trzymana kotwica dalej musi byc widoczna"
	)
	var drag_spread: float = still_drag.max() - still_drag.min()
	_expect(drag_spread < 0.0001, "tryb musi zatrzymac drganie przesuwania (%.6f)" % drag_spread)
	_expect(still_drag.min() > 0.0, "przesuwany rekwizyt dalej musi byc czytelny w trybie")

	_expect(envelope.field_alpha() > 0.0, "ramka pola kotwiczenia nie moze zniknac w trybie")

	MotionAccessibility.reset()


# ─── 8. Swiatlo i mikro-czastki ──────────────────────────────────────────────

func _test_reduced_motion_atmosphere() -> void:
	MotionAccessibility.reset()

	var lively := AtmosphereRig.new()
	lively.name = "PKG0141AtmosphereLively"
	lively.station_number = 20
	root.add_child(lively)
	await process_frame
	_expect(
		lively.is_emitting_micro_particles(),
		"w trybie normalnym warstwa mikro-czastek musi emitowac"
	)
	var lively_energy := _sample_light_energies(lively)
	_expect(
		lively_energy["spread"] > 0.0001,
		"w trybie normalnym swiatlo musi migotac (%.6f)" % lively_energy["spread"]
	)
	_expect(_count_emitting(lively) > 0, "w trybie normalnym co najmniej jeden emiter musi emitowac")
	lively.queue_free()
	await process_frame

	MotionAccessibility.set_reduced_motion(true)
	var calm := AtmosphereRig.new()
	calm.name = "PKG0141AtmosphereCalm"
	calm.station_number = 20
	root.add_child(calm)
	await process_frame
	var calm_energy := _sample_light_energies(calm)
	_expect(
		calm_energy["spread"] < 0.0001,
		"tryb ograniczonego ruchu musi zatrzymac migotanie i pulsowanie (%.6f)" % calm_energy["spread"]
	)
	_expect(
		calm_energy["min"] > 0.0,
		"tryb tlumi ruch, nie widocznosc: swiatlo nie moze zgasnac"
	)
	_expect(
		not calm.is_emitting_micro_particles(),
		"tryb ograniczonego ruchu musi zgasic warstwe mikro-czastek"
	)
	_expect(_count_emitting(calm) == 0, "zaden dekoracyjny emiter nie moze emitowac w trybie")
	_expect(
		calm.get_particle_node_count() > 0,
		"tryb gasi emisje, a nie usuwa emiterow — budzet klatki zostaje policzalny"
	)

	# Przelaczenie w trakcie gry dziala w obie strony, bez odbudowy sceny.
	MotionAccessibility.set_reduced_motion(false)
	calm._process(STEP)
	_expect(
		calm.is_emitting_micro_particles() and _count_emitting(calm) > 0,
		"wyjscie z trybu musi zapalic mikro-czastki z powrotem"
	)
	calm.queue_free()
	await process_frame
	MotionAccessibility.reset()


# ─── 9. Ustawienia, trwalosc i lokalizacja ───────────────────────────────────

func _test_reduced_motion_settings() -> void:
	if _state == null:
		return
	_state.set_pause_menu_visible(false)
	_state.restore_default_settings(true)
	await process_frame

	_expect(
		not bool(_state.reduced_motion),
		"po przywroceniu ustawien domyslnych tryb musi byc wylaczony"
	)
	_expect(
		not MotionAccessibility.is_reduced_motion(),
		"ustawienia domyslne musza dojsc do modulu runtime"
	)

	_state.set_reduced_motion(true)
	_expect(MotionAccessibility.is_reduced_motion(), "ustawienie musi natychmiast dojsc do runtime")

	# Trwalosc: zapis na dysk i ponowny odczyt.
	MotionAccessibility.set_reduced_motion(false)
	var reloaded: bool = _state.reload_settings_from_disk()
	_expect(reloaded, "zapisany plik ustawien musi dac sie wczytac")
	_expect(bool(_state.reduced_motion), "tryb musi przezyc zapis i odczyt ustawien")
	_expect(
		MotionAccessibility.is_reduced_motion(),
		"odczyt ustawien musi przywrocic tryb w module runtime"
	)

	# Stary plik ustawien bez klucza nie moze byc odrzucony.
	var legacy := {
		"settings_version": _state.get_settings_schema_version(),
		"master_volume": 0.8,
		"text_speed_cps": 42.0,
		"fullscreen": false,
		"text_scale": 1.0,
		"locale": "pl",
		"remap": {},
	}
	_expect(
		_state.call("_apply_loaded_settings", true, legacy),
		"plik ustawien sprzed PKG-0141 musi dalej byc akceptowany"
	)
	_expect(
		not bool(_state.reduced_motion),
		"brak klucza w starym pliku musi dac wartosc domyslna, nie odrzucenie"
	)

	# Lokalizacja opcji.
	for locale in ["pl", "en"]:
		LocalizationManager.set_locale(locale)
		var label := LocalizationManager.tr_key("SETTINGS_REDUCED_MOTION")
		var hint := LocalizationManager.tr_key("SETTINGS_REDUCED_MOTION_HINT")
		_expect(
			label != "" and label != "SETTINGS_REDUCED_MOTION",
			"opcja musi byc przetlumaczona w locale %s" % locale
		)
		_expect(
			hint != "" and hint != "SETTINGS_REDUCED_MOTION_HINT",
			"podpowiedz opcji musi byc przetlumaczona w locale %s" % locale
		)
	LocalizationManager.set_locale("pl")

	# Powierzchnia ustawien.
	var overlay := SettingsOverlay.new()
	overlay.name = "PKG0141SettingsOverlay"
	root.add_child(overlay)
	await process_frame
	var check := overlay.get_node_or_null("ReducedMotionCheckButton") as CheckButton
	_expect(check != null, "SettingsOverlay musi wystawiac przelacznik ograniczonego ruchu")
	if check != null:
		_expect(check.focus_mode == Control.FOCUS_ALL, "przelacznik musi byc dostepny z klawiatury i pada")
		_expect(check.text != "", "przelacznik musi miec zlokalizowana etykiete")
		_expect(
			check.position.y + check.size.y <= SettingsOverlay.PANEL_SIZE.y,
			"przelacznik musi miescic sie w panelu ustawien"
		)
		_expect(
			not check.button_pressed,
			"panel musi startowac zsynchronizowany z aktualnym (wylaczonym) trybem"
		)
		check.button_pressed = true
		await process_frame
		_expect(
			MotionAccessibility.is_reduced_motion(),
			"klikniecie przelacznika musi realnie wlaczyc tryb"
		)
		check.button_pressed = false
		await process_frame
		_expect(
			not MotionAccessibility.is_reduced_motion(),
			"kliknieciem przelacznika mozna tryb takze wylaczyc"
		)
	overlay.queue_free()
	await process_frame

	_state.set_reduced_motion(false, true)
	_state.restore_default_settings(true)
	await process_frame
	print("   Opcja jest w ustawieniach, zlokalizowana i trwala.")


# ─── 10. Trwalosc miedzy scenami ─────────────────────────────────────────────

func _test_reduced_motion_across_scenes() -> void:
	MotionAccessibility.set_reduced_motion(true)
	var station := await _open_station(&"station_38")
	if station == null:
		MotionAccessibility.reset()
		return

	var rig := _find_atmosphere_rig(station)
	_expect(rig != null, "station_38 musi miec `AtmosphereRig`")
	if rig != null:
		_expect(
			not rig.is_emitting_micro_particles(),
			"stacja zaladowana przy wlaczonym trybie musi wstac z wygaszonymi mikro-czastkami"
		)
		_expect(_count_emitting(rig) == 0, "zaden dekoracyjny emiter stacji nie moze emitowac")

	var camera := StationCameraRig.resolve(station)
	if camera != null:
		camera.add_trauma(1.0)
		camera._physics_process(STEP)
		_expect(camera.offset == Vector2.ZERO, "wstrzas musi byc zdjety takze po zmianie sceny")
		_expect(camera.is_on_pixel_grid(), "snap 2 px musi przetrwac zmiane sceny w trybie")

	_close_station(station)
	await process_frame
	MotionAccessibility.reset()
	print("   Tryb przezywa zmiane sceny bez zadnego okablowania w stacji.")


# ─── Narzedzia ───────────────────────────────────────────────────────────────

func _open_station(scene_id: StringName) -> Node:
	var path := "%s/%s.tscn" % [CAMPAIGN_DIR, scene_id]
	var packed := load(path) as PackedScene
	_expect(packed != null, "%s: scena musi dac sie zaladowac" % scene_id)
	if packed == null:
		return null
	var station := packed.instantiate()
	root.add_child(station)
	await process_frame
	await physics_frame
	return station


func _close_station(station: Node) -> void:
	if is_instance_valid(station):
		station.queue_free()


func _collect_cameras(node: Node) -> Array[CinematicCamera]:
	var found: Array[CinematicCamera] = []
	if node is CinematicCamera:
		found.append(node as CinematicCamera)
	for child in node.get_children():
		found.append_array(_collect_cameras(child))
	return found


func _find_service_lift(node: Node) -> ServiceLift:
	if node is ServiceLift:
		return node as ServiceLift
	for child in node.get_children():
		var found := _find_service_lift(child)
		if found != null:
			return found
	return null


func _find_atmosphere_rig(node: Node) -> AtmosphereRig:
	if node is AtmosphereRig:
		return node as AtmosphereRig
	for child in node.get_children():
		var found := _find_atmosphere_rig(child)
		if found != null:
			return found
	return null


## Rozrzut energii KAZDEGO swiatla rigu w czasie. Mierzymy per zrodlo, a nie
## po calym rigu: swietlowka i beacon maja rozne poziomy spoczynkowe, wiec
## rozrzut miedzy nimi nie jest ruchem. Ruchem jest dopiero zmiana energii
## jednego swiatla w kolejnych klatkach — i to ja tryb ma zatrzymac, zostawiajac
## poziom spoczynkowy nietkniety.
func _sample_light_energies(rig: AtmosphereRig) -> Dictionary:
	var lights := _collect_lights(rig)
	if lights.is_empty():
		return {"min": 0.0, "max": 0.0, "spread": 0.0}
	var per_light_min: Array[float] = []
	var per_light_max: Array[float] = []
	for i in range(lights.size()):
		per_light_min.append(INF)
		per_light_max.append(-INF)
	for step in range(24):
		rig._process(STEP)
		for i in range(lights.size()):
			var energy: float = lights[i].energy
			per_light_min[i] = minf(per_light_min[i], energy)
			per_light_max[i] = maxf(per_light_max[i], energy)
	var worst_spread := 0.0
	var lowest := INF
	for i in range(lights.size()):
		worst_spread = maxf(worst_spread, per_light_max[i] - per_light_min[i])
		lowest = minf(lowest, per_light_min[i])
	return {"min": lowest, "max": per_light_max.max(), "spread": worst_spread}


func _collect_lights(node: Node) -> Array[PointLight2D]:
	var found: Array[PointLight2D] = []
	if node is PointLight2D:
		found.append(node as PointLight2D)
	for child in node.get_children():
		found.append_array(_collect_lights(child))
	return found


func _count_emitting(node: Node) -> int:
	var total := 0
	if node is CPUParticles2D and (node as CPUParticles2D).emitting:
		total += 1
	for child in node.get_children():
		total += _count_emitting(child)
	return total


func _finish() -> void:
	print("--------------------------------------------------------------------------------")
	if _failures.is_empty():
		print("PKG-0141: ALL TESTS PASSED (0 FAILURES).")
		quit(0)
	else:
		printerr("PKG-0141: %d FAILURE(S)." % _failures.size())
		for failure in _failures:
			printerr("  - " + failure)
		quit(1)
