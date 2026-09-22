class_name MemoryResonancePoint
extends Area2D

## Memory Resonance Point for Getting Strange.
## Represents narrative and procedural props in the game world that respond
## to Lena's presence and action without intrusive floating HUD text.
## Conforms to VISUAL_DESIGN.md (muted amber #D39A62, grey sage #A8B2AC, cyan #75C7C3).

enum PropType {
	PHOTOGRAPH = 0,
	CIRCUIT_BREAKER = 1,
	VACUUM_GAUGE = 2,
	CHAMBER_CONSOLE = 3,
	DOCUMENT_CLIPBOARD = 4,
	DOOR_CARD_READER = 5,
	TWIN_CUPS = 6,
	DESK_TELEPHONE = 7,
	DUTY_ROSTER = 8,
	SECURITY_MONITOR = 9,
	UCP_NOTICE = 10,
	GUARD_INTERACTION = 11,
	ANACHRONISTIC_BILLBOARD = 12,
	MISSING_FLOOR_FACADE = 13,
	CROSSWALK_SIGNAL = 14,
	TRANSIT_SHELTER = 15,
	BUS_SPEAKER = 16,
	ELDERLY_PASSENGER = 17,
	GOLD_RING = 18,
	BUS_ROUTE_MAP = 19,
	TENANT_DIRECTORY = 20,
	MAILBOXES = 21,
	BLIND_STAIRS = 22,
	MARTA_INTERACTION = 23,
	STAIR_TIMER_SWITCH = 24,
	HALLWAY_COAT_RACK = 25,
	REFLECTED_PHOTOGRAPH = 26,
	BEAKER_PLANTER = 27,
	JAKUB_MEMENTO_TOOL = 28,
	CIPHER_DESK = 29,
	TEA_KETTLE = 30,
	BATHROOM_SINK = 31,
	BATHROOM_MIRROR = 32,
	SCRATCHED_INSCRIPTION = 33,
	APOTHECARY_CABINET = 34,
	MARTA_BATHROOM_GUIDE = 35,
	BAKELITE_PHONE = 36,
	REEL_TAPE_RECORDER = 37,
	TOPOGRAPHY_BOARD = 38,
	JAKUB_DESK_LAMP = 39,
	TECH_STORAGE_AIRLOCK = 40,
	OBSERVATION_WINDOW = 41,
	ERASED_DOORWAY_TRACE = 42,
	UCP_INTERVENTION_TEAM = 43,
	ELDERLY_RESIDENT_GUIDE = 44,
	MARTA_OBSERVATION_DIALOGUE = 45,
	COURTYARD_EXIT_AIRLOCK = 46,
	UCP_INFO_TERMINAL = 47,
	SHOWCASE_VITRINE = 48,
	INSTRUCTION_POSTER = 49,
	SUBWAY_TILE_PILLAR = 50,
	UNDERPASS_EXIT_GATE = 51,
	DRAFTING_TABLE = 52,
	TOPOGRAPHY_INDEX_CABINET = 53,
	JAKUB_PHOTOGRAPH_FRAME = 54,
	RESONANCE_CIRCUIT_NODE = 55,
	TECH_PASSAGE_AIRLOCK = 56,
	METAL_SCRATCH_BEAM = 57,
	TAPE_PLAYBACK_DECK = 58,
	MAINTENANCE_RACK = 59,
	SEAM_STABILIZER_LEVER = 60,
	SUBSTRUCTURE_CONDUIT_SHAFT = 61,
	HYGIENE_INSTRUCTION_BOARD = 62,
	HANDWRITTEN_CORRELATION_FORMULA = 63,
	REFLECTIVE_PUDDLE = 64,
	PRESSURE_RELIEF_VALVE = 65,
	TRANSIT_SERVICE_GATE = 66,
	CRACKED_TEA_CUP = 67,
	CORRELATION_DOSSIER = 68,
	KITCHEN_CLOCK = 69,
	WEDDING_RING_STAND = 70,
	BALCONY_EXIT_DOOR = 71,
	QUEUING_TICKET_DISPENSER = 72,
	COMPLIANCE_WAITING_BENCH = 73,
	PNEUMATIC_DOSSIER_STATION = 74,
	DIAGNOSTIC_MEMORY_PRINTER = 75,
	CONSULTATION_OFFICE_DOOR = 76,
	WIERZBICKA_DESK = 77,
	SENSORY_MEMORY_MAP = 78,
	CORRECTION_GALVANOMETER = 79,
	ACOUSTIC_WEIGHT_CONDUIT = 80,
	MODEL_ROOM_AIRLOCK = 81,
	MODEL_DISPLAY_TABLE = 82,
	STAIRCASE_MAP_LEFT = 83,
	STAIRCASE_MAP_RIGHT = 84,
	ELEVEN_PERSONS_LEDGER = 85,
	MODEL_ROOM_EXIT = 86,
	SZYMON_BERA = 87,
	WELL_DRAWING = 88,
	HYDROLOGY_REPORT = 89,
	ERASED_SIGNATURE_MAGNIFIER = 90,
	SZYMON_ROOM_EXIT = 91,
	SZYMON_POST_CORRECTION = 92,
	ANESTHESIA_TERMINAL = 93,
	FILTERED_DOSSIER_SLOT = 94,
	DRAWING_DISPOSITION_PEDESTAL = 95,
	STATION_21_EXIT = 96,
	BIOMETRIC_IDENTITY_GATE = 97,
	COMPLIANCE_CONTACT_REGISTER = 98,
	RING_FITTING_SCANNER = 99,
	PAINT_RESIN_RESONANCE_SLAB = 100,
	STATION_22_EXIT = 101,
	DESIGNER_TERMINAL = 102,
	SUBSTRUCTURE_ARCHITECTURAL_MODEL = 103,
	BURDENED_PERSONS_LEDGER = 104,
	SHADOW_INTERACTIVE_CONSOLE = 105,
	STATION_23_EXIT = 106,
	CCTV_SURVEILLANCE_ARRAY = 107,
	CORRECTION_ACCUMULATION_GAUGE = 108,
	WIERZBICKA_TRANSMISSION_TERMINAL = 109,
	LENA_DISPOSITION_SELECTOR = 110,
	STATION_24_EXIT = 111,
	JAKUB_OPERATOR_UCP = 112,
	TRANSIT_MAINTENANCE_CART = 113,
	SCAR_DIAGNOSTIC_CHART = 114,
	JAKUB_HAND_GESTURE_SENSOR = 115,
	STATION_25_EXIT = 116,
	ISOLATION_ZONE_CONSOLE = 117,
	DYNAMIC_ROOM_DESIGNATOR = 118,
	MOTIVATION_ANCHOR_RECORD = 119,
	WIERZBICKA_PA_SPEAKER = 120,
	STATION_26_EXIT = 121,
	JAKUB_SERVICE_OPERATOR = 122,
	SAVED_WORKER_BADGE = 123,
	SURFACE_STABILITY_MONITOR = 124,
	TECHNICAL_JUNCTION_CONSOLE = 125,
	STATION_27_EXIT = 126,
	TRAM_DRIVER_CONSOLE = 127,
	PANORAMIC_TRANSIT_WINDOW = 128,
	TRIPLE_ACCIDENT_PARADOX_VIEW = 129,
	WIERZBICKA_CLOSING_INTERCOM = 130,
	STATION_28_EXIT = 131,
	ABANDONED_PLATFORM_TRACKS = 132,
	FLICKERING_NEON_SIGN = 133,
	DEEP_SUBSTRUCTURE_WELL = 134,
	JAKUB_TORCH_BEACON = 135,
	STATION_29_EXIT = 136,
	MAIN_POWER_DISTRIBUTION_BOARD = 137,
	HIGH_VOLTAGE_TRANSFORMER_BANK = 138,
	SECTION_BREAKER_LEVER = 139,
	GRID_SCHEMATIC_DISPLAY = 140,
	STATION_30_EXIT = 141,
	ELEVEN_CHAIRS_ARCHIVE_ROW = 142,
	WIERZBICKA_REMOTE_HOLOTERMINAL = 143,
	JAKUB_TWELFTH_CHAIR = 144,
	VARIANT_CHOICE_LEDGER = 145,
	STATION_31_EXIT = 146,
	STEAMED_GLASS_PANE_A = 147,
	CRACKED_GLASS_PANE_B = 148,
	POLISHED_GLASS_PANE_C = 149,
	CONDENSATION_TRACE_ETCHER = 150,
	STATION_32_EXIT = 151,
	VERTICAL_LADDER_ARRAY = 152,
	DEPTH_PRESSURE_GAUGE = 153,
	MEMORY_BUS_CABLE_TRUNK = 154,
	SHAFT_WORK_LIGHT_BEACON = 155,
	STATION_33_EXIT = 156,
	MAIN_EXCHANGE_CORE_REACTOR = 157,
	BIOGRAPHY_ALLOCATION_DESK = 158,
	THERMAL_OVERLOAD_INDICATOR = 159,
	JAKUB_CORE_DIAGNOSTIC_PORT = 160,
	STATION_34_EXIT = 161,
	SEDATION_BASIN_POOL = 162,
	SLUDGE_DRAIN_VALVE_WHEEL = 163,
	CHEMICAL_SEDATION_SAMPLER = 164,
	JAKUB_SEDATION_MONITOR = 165,
	STATION_35_EXIT = 166,
	STORM_DRAIN_WEIR = 167,
	SEDATIVE_SLUDGE_CURRENT = 168,
	ACID_RESISTANT_CATWALK_LADDER = 169,
	CONTAMINATION_SAMPLING_TAP = 170,
	STATION_36_EXIT = 171,
	SIGNAL_TRANSMISSION_ANTENNA = 172,
	TRANSMISSION_CROSS_PATCHBAY = 173,
	FREQUENCY_OSCILLOSCOPE_CRT = 174,
	MEMORY_INJECTION_PULPIT = 175,
	STATION_37_EXIT = 176,
	ACCIDENT_SIMULATION_FIELD = 177,
	DESTABILIZING_JAKUB_SHADOW = 178,
	RESCUE_TETHER_ANCHOR = 179,
	RETURN_COORDINATE_CALCULATOR = 180,
	STATION_38_EXIT = 181,
	CENTRAL_REFERENCE_CORE_MONOLITH = 182,
	BRANCH_CONFIG_RETURN_A = 183,
	BRANCH_CONFIG_RECONCILIATION_B = 184,
	BRANCH_CONFIG_TESTIMONY_C = 185,
	STATION_39_EXIT = 186,
	WIERZBICKA_PERSONAL_TERMINAL = 187,
	MARTA_WITNESS_STATION = 188,
	SZYMON_TRANSMISSION_MONITOR = 189,
	OPERATION_COST_DOSSIER_MATRIX = 190,
	STATION_40_EXIT = 191,
	OP_CONSOLE_RETURN_A = 192,
	OP_CONSOLE_RECONCILIATION_B = 193,
	OP_CONSOLE_TESTIMONY_C = 194,
	OP_CONTINUITY_TOPOGRAPHY_DISPLAY = 195,
	STATION_41_EXIT = 196,
	EPILOGUE_RETURN_CUPS = 197,
	EPILOGUE_MARTA_DOORSTEP = 198,
	EPILOGUE_TRAM_DUAL_TRACKS = 199,
	EPILOGUE_ADMIN_NOTICE_BOARD = 200,
	EPILOGUE_CREDITS_ROLL = 201,
	EPILOGUE_FINAL_BLACKOUT = 202,
}


signal resonance_triggered(id: String, prop_type: int)
signal state_changed(is_active: bool)

const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.22)
const COLOR_INFRASTRUCTURE := Color("a8b2ac")
const COLOR_DARK_STEEL := Color("263943")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")
const COLOR_BACKGROUND := Color("182126")

@export var resonance_id: String = "prop_01"
@export var prop_type: PropType = PropType.PHOTOGRAPH
@export var prop_title: String = "Fotografia"
@export var prop_subtitle: String = "Sterownia IKP"
@export var interaction_radius: float = 38.0
@export var is_activated: bool = false:
	set(value):
		if is_activated != value:
			is_activated = value
			state_changed.emit(is_activated)
			queue_redraw()

@export var is_one_shot: bool = false
@export var shadow_progress: float = 0.0:
	set(value):
		if shadow_progress != value:
			shadow_progress = value
			queue_redraw()

var _is_player_in_range: bool = false
var is_player_in_range: bool:
	get:
		return _is_player_in_range
	set(value):
		if _is_player_in_range == value:
			return
		_is_player_in_range = value
		queue_redraw()

var _pulse_phase: float = 0.0
var _resonance_flash: float = 0.0
var _audio_player: AudioStreamPlayer2D
var _memory_sound: AudioStreamWAV
var _switch_sound: AudioStreamWAV
var _phone_sound: AudioStreamWAV
var _card_reader_sound: AudioStreamWAV
var _crosswalk_sound: AudioStreamWAV
var _bus_announcement_sound: AudioStreamWAV
var _ring_sound: AudioStreamWAV
var _timer_switch_sound: AudioStreamWAV
var _marta_blip_sound: AudioStreamWAV
var _door_sound: AudioStreamWAV
var _drawer_unlatch_sound: AudioStreamWAV
var _paper_rustle_sound: AudioStreamWAV
var _kettle_whistle_sound: AudioStreamWAV
var _tile_sound: AudioStreamWAV
var _pipe_sound: AudioStreamWAV
var _glass_scratch_sound: AudioStreamWAV
var _mirror_shimmer_sound: AudioStreamWAV
var _bakelite_bell_sound: AudioStreamWAV
var _handset_pickup_sound: AudioStreamWAV
var _tape_hum_sound: AudioStreamWAV
var _jakub_blip_sound: AudioStreamWAV
var _morning_ambience_sound: AudioStreamWAV
var _ucp_stabilizer_sound: AudioStreamWAV
var _masonry_smooth_sound: AudioStreamWAV
var _elderly_woman_sound: AudioStreamWAV
var _subway_hum_sound: AudioStreamWAV
var _neon_sound: AudioStreamWAV
var _terminal_key_sound: AudioStreamWAV
var _pa_chime_sound: AudioStreamWAV
var _drafting_lamp_sound: AudioStreamWAV
var _photo_slide_sound: AudioStreamWAV
var _shadow_whisper_sound: AudioStreamWAV
var _relay_click_sound: AudioStreamWAV
var _metal_scratch_sound: AudioStreamWAV
var _tape_degradation_sound: AudioStreamWAV
var _seam_clamp_sound: AudioStreamWAV
var _conduit_wind_sound: AudioStreamWAV
var _catwalk_footstep_sound: AudioStreamWAV
var _water_drip_sound: AudioStreamWAV
var _pressure_valve_sound: AudioStreamWAV
var _resonance_pulse_sound: AudioStreamWAV
var _cup_clink_sound: AudioStreamWAV
var _tea_pour_sound: AudioStreamWAV
var _clock_tick_sound: AudioStreamWAV
var _dossier_paper_sound: AudioStreamWAV
var _dispenser_ticket_sound: AudioStreamWAV
var _clinic_intercom_sound: AudioStreamWAV
var _pneumatic_tube_sound: AudioStreamWAV
var _wierzbicka_printer_sound: AudioStreamWAV
var _galvanometer_tick_sound: AudioStreamWAV
var _substructure_strain_sound: AudioStreamWAV
var _map_node_pulse_sound: AudioStreamWAV
var _wierzbicka_stamp_sound: AudioStreamWAV
var _model_table_sound: AudioStreamWAV
var _map_rustle_sound: AudioStreamWAV
var _ledger_page_sound: AudioStreamWAV
var _model_door_release_sound: AudioStreamWAV
var _crayon_rustle_sound: AudioStreamWAV
var _well_drip_sound: AudioStreamWAV
var _szymon_blip_sound: AudioStreamWAV
var _door_shift_sound: AudioStreamWAV
var _anesthetic_hum_sound: AudioStreamWAV
var _sedation_monitor_sound: AudioStreamWAV
var _erased_glitch_sound: AudioStreamWAV
var _airlock_21_sound: AudioStreamWAV
var _biometric_gate_sound: AudioStreamWAV
var _ring_resonance_sound: AudioStreamWAV
var _paint_recall_sound: AudioStreamWAV
var _biographical_erasure_sound: AudioStreamWAV
var _door_release_22_sound: AudioStreamWAV
var _designer_terminal_sound: AudioStreamWAV
var _cursor_shift_sound: AudioStreamWAV
var _burden_ledger_sound: AudioStreamWAV
var _designer_note_sound: AudioStreamWAV
var _door_release_23_sound: AudioStreamWAV
var _cctv_hum_sound: AudioStreamWAV
var _correction_siren_sound: AudioStreamWAV
var _intercom_wierzbicka_sound: AudioStreamWAV
var _decision_latch_sound: AudioStreamWAV
var _door_release_24_sound: AudioStreamWAV
var _transit_rail_sound: AudioStreamWAV
var _jakub_uniform_sound: AudioStreamWAV
var _scar_revelation_sound: AudioStreamWAV
var _finger_scrape_sound: AudioStreamWAV
var _door_release_25_sound: AudioStreamWAV
var _isolation_hum_sound: AudioStreamWAV
var _reconfiguration_sound: AudioStreamWAV
var _wierzbicka_calming_sound: AudioStreamWAV
var _motivation_scratch_sound: AudioStreamWAV
var _door_release_26_sound: AudioStreamWAV
var _service_tunnel_sound: AudioStreamWAV
var _jakub_keycard_sound: AudioStreamWAV
var _gratitude_confession_sound: AudioStreamWAV
var _surface_danger_sound: AudioStreamWAV
var _door_release_27_sound: AudioStreamWAV
var _tram_motor_sound: AudioStreamWAV
var _track_switch_sound: AudioStreamWAV
var _wierzbicka_closing_sound: AudioStreamWAV
var _paradox_shimmer_sound: AudioStreamWAV
var _door_release_28_sound: AudioStreamWAV
var _platform13_drip_sound: AudioStreamWAV
var _flickering_neon_sound: AudioStreamWAV
var _deep_well_sound: AudioStreamWAV
var _jakub_torch_sound: AudioStreamWAV
var _door_release_29_sound: AudioStreamWAV
var _transformer_oil_sound: AudioStreamWAV
var _knife_switch_sound: AudioStreamWAV
var _high_voltage_spark_sound: AudioStreamWAV
var _power_grid_relay_sound: AudioStreamWAV
var _door_release_30_sound: AudioStreamWAV
var _eleven_chairs_sound: AudioStreamWAV
var _wierzbicka_recitation_sound: AudioStreamWAV
var _twelfth_chair_sound: AudioStreamWAV
var _variant_ledger_sound: AudioStreamWAV
var _door_release_31_sound: AudioStreamWAV
var _steamed_glass_sound: AudioStreamWAV
var _cracked_glass_sound: AudioStreamWAV
var _polished_glass_sound: AudioStreamWAV
var _trace_etcher_sound: AudioStreamWAV
var _door_release_32_sound: AudioStreamWAV
var _ladder_climb_sound: AudioStreamWAV
var _depth_creak_sound: AudioStreamWAV
var _cable_trunk_sound: AudioStreamWAV
var _work_light_sound: AudioStreamWAV
var _door_release_33_sound: AudioStreamWAV
var _core_pulse_sound: AudioStreamWAV
var _slider_drag_sound: AudioStreamWAV
var _thermal_alarm_sound: AudioStreamWAV
var _jakub_probe_sound: AudioStreamWAV
var _door_release_34_sound: AudioStreamWAV
var _sedation_slosh_sound: AudioStreamWAV
var _sludge_valve_sound: AudioStreamWAV
var _chemical_bubbler_sound: AudioStreamWAV
var _sedation_alarm_sound: AudioStreamWAV
var _door_release_35_sound: AudioStreamWAV
var _storm_drain_torrent_sound: AudioStreamWAV
var _drain_weir_creak_sound: AudioStreamWAV
var _acid_ladder_clank_sound: AudioStreamWAV
var _groundwater_leak_alarm_sound: AudioStreamWAV
var _door_release_36_sound: AudioStreamWAV
var _signal_antenna_sound: AudioStreamWAV
var _cross_patchbay_sound: AudioStreamWAV
var _crt_sweep_sound: AudioStreamWAV
var _memory_lever_sound: AudioStreamWAV
var _door_release_37_sound: AudioStreamWAV
var _accident_field_sound: AudioStreamWAV
var _jakub_destabilize_sound: AudioStreamWAV
var _rescue_tether_sound: AudioStreamWAV
var _coordinate_calc_sound: AudioStreamWAV
var _door_release_38_sound: AudioStreamWAV
var _reference_core_sound: AudioStreamWAV
var _config_a_sound: AudioStreamWAV
var _config_b_sound: AudioStreamWAV
var _config_c_sound: AudioStreamWAV
var _act4_gateway_sound: AudioStreamWAV
var _wierzbicka_terminal_sound: AudioStreamWAV
var _marta_witness_sound: AudioStreamWAV
var _szymon_transmission_sound: AudioStreamWAV
var _cost_matrix_sound: AudioStreamWAV
var _gate_40_sound: AudioStreamWAV
var _op_return_sound: AudioStreamWAV
var _op_reconciliation_sound: AudioStreamWAV
var _op_testimony_sound: AudioStreamWAV
var _op_console_sound: AudioStreamWAV
var _gate_41_sound: AudioStreamWAV
var _epilogue_radio_sound: AudioStreamWAV
var _epilogue_cups_sound: AudioStreamWAV
var _epilogue_switch_latch_sound: AudioStreamWAV
var _epilogue_credits_sound: AudioStreamWAV
var _epilogue_blackout_sound: AudioStreamWAV
var _particles: CPUParticles2D
var _collision_shape: CollisionShape2D
var _circle_shape: CircleShape2D

## PKG-0140 haptyka interakcji (D-147).
## Punkt pamieci mowil dotad wylacznie glosem swojego rekwizytu: telefon
## dzwonil, przelacznik klikal, a samo dotkniecie przedmiotu nie brzmialo
## niczym. Warstwa haptyczna gra rownolegle, na osobnym i cichszym glosie
## **wspoldzielonym przez cala stacje** (D-149): stacja 01 ma dziewiec punktow
## pamieci, a budzet klatki dopuszcza 20 odtwarzaczy na scene (D-120).
var _contact_tap_sound: AudioStreamWAV
var _probe_brush_sound: AudioStreamWAV
var _detent_sound: AudioStreamWAV
## 0..1 — jak dlugo Lena jest przy rekwizycie. Narasta po wejsciu w zasieg i
## opada po wyjsciu, wiec kontakt jest ciagly, nie migawkowy.
var _contact_progress: float = 0.0
## 0..1 — swiezosc ostatniego dotkniecia; zasila kontaktowy odczyt wizualny.
var _touch_flash: float = 0.0
## Karencja po wejsciu w scene. Lena, ktora startuje juz przy rekwizycie, nie
## dotknela go — stuk kontaktu w pierwszej klatce stacji bylby falszem i
## zjadalby glos w budzecie 4 grajacych kanalow (D-120, D-149).
var _spawn_grace: float = 0.0
const SPAWN_GRACE_SECONDS := 0.45

## Rekwizyty obslugiwane jak przelacznik dostaja zapadke zamiast samego stuku.
const SWITCH_LIKE_PROPS: Array[int] = [
	PropType.CIRCUIT_BREAKER,
	PropType.JAKUB_DESK_LAMP,
	PropType.STAIR_TIMER_SWITCH,
	PropType.SEAM_STABILIZER_LEVER,
	PropType.PRESSURE_RELIEF_VALVE,
	PropType.DOOR_CARD_READER,
]


func _ready() -> void:
	_setup_collision()
	_setup_audio()
	_setup_particles()
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	queue_redraw()


func _setup_collision() -> void:
	_collision_shape = get_node_or_null("CollisionShape2D") as CollisionShape2D
	if _collision_shape == null:
		_collision_shape = CollisionShape2D.new()
		_collision_shape.name = "CollisionShape2D"
		add_child(_collision_shape)
	
	if _collision_shape.shape is CircleShape2D:
		_circle_shape = _collision_shape.shape as CircleShape2D
	else:
		_circle_shape = CircleShape2D.new()
		_collision_shape.shape = _circle_shape
	
	_circle_shape.radius = interaction_radius


func _setup_audio() -> void:
	_setup_haptic_layer()
	match prop_type:
		PropType.CIRCUIT_BREAKER, PropType.JAKUB_DESK_LAMP:
			_switch_sound = ProceduralAudio.create_switch_toggle_sound()
		PropType.DESK_TELEPHONE:
			_phone_sound = ProceduralAudio.create_phone_ring_pulse_sound()
		PropType.DOOR_CARD_READER:
			_card_reader_sound = ProceduralAudio.create_card_reader_beep_sound()
		PropType.CROSSWALK_SIGNAL:
			_crosswalk_sound = ProceduralAudio.create_crosswalk_signal_sound(true)
		PropType.BUS_SPEAKER:
			_bus_announcement_sound = ProceduralAudio.create_bus_announcement_sound()
		PropType.GOLD_RING, PropType.WEDDING_RING_STAND:
			_ring_sound = ProceduralAudio.create_ring_chime_sound()
		PropType.STAIR_TIMER_SWITCH:
			_timer_switch_sound = ProceduralAudio.create_stair_timer_switch_sound()
		PropType.MARTA_INTERACTION, PropType.MARTA_BATHROOM_GUIDE, PropType.MARTA_OBSERVATION_DIALOGUE:
			_marta_blip_sound = ProceduralAudio.create_dialogue_marta_blip_sound()
		PropType.TECH_STORAGE_AIRLOCK, PropType.COURTYARD_EXIT_AIRLOCK, PropType.UNDERPASS_EXIT_GATE, PropType.TECH_PASSAGE_AIRLOCK, PropType.BALCONY_EXIT_DOOR, PropType.CONSULTATION_OFFICE_DOOR, PropType.MODEL_ROOM_AIRLOCK:
			_door_sound = ProceduralAudio.create_apartment_door_sound()
		PropType.CIPHER_DESK, PropType.APOTHECARY_CABINET, PropType.TOPOGRAPHY_INDEX_CABINET, PropType.MAINTENANCE_RACK:
			_drawer_unlatch_sound = ProceduralAudio.create_drawer_lock_unlatch_sound()
		PropType.JAKUB_MEMENTO_TOOL, PropType.TOPOGRAPHY_BOARD, PropType.SHOWCASE_VITRINE, PropType.HYGIENE_INSTRUCTION_BOARD:
			_paper_rustle_sound = ProceduralAudio.create_paper_rustle_sound()
		PropType.TEA_KETTLE:
			_kettle_whistle_sound = ProceduralAudio.create_kettle_whistle_sound()
		PropType.BATHROOM_SINK:
			_pipe_sound = ProceduralAudio.create_water_pipe_hiss_sound()
		PropType.BATHROOM_MIRROR:
			_mirror_shimmer_sound = ProceduralAudio.create_mirror_shimmer_sound()
		PropType.SCRATCHED_INSCRIPTION:
			_glass_scratch_sound = ProceduralAudio.create_glass_scratch_sound()
		PropType.BAKELITE_PHONE:
			_handset_pickup_sound = ProceduralAudio.create_handset_pickup_sound()
		PropType.REEL_TAPE_RECORDER:
			_tape_hum_sound = ProceduralAudio.create_tape_motor_hum_sound()
		PropType.OBSERVATION_WINDOW:
			_morning_ambience_sound = ProceduralAudio.create_morning_ambience_sound()
		PropType.ERASED_DOORWAY_TRACE:
			_masonry_smooth_sound = ProceduralAudio.create_masonry_smooth_sound()
		PropType.UCP_INTERVENTION_TEAM:
			_ucp_stabilizer_sound = ProceduralAudio.create_ucp_stabilizer_beam_sound()
		PropType.ELDERLY_RESIDENT_GUIDE:
			_elderly_woman_sound = ProceduralAudio.create_dialogue_elderly_woman_sound()
		PropType.UCP_INFO_TERMINAL:
			_terminal_key_sound = ProceduralAudio.create_terminal_keypress_sound()
		PropType.INSTRUCTION_POSTER:
			_pa_chime_sound = ProceduralAudio.create_pa_chime_sound()
		PropType.SUBWAY_TILE_PILLAR:
			_tile_sound = ProceduralAudio.create_tile_footstep_sound()
		PropType.DRAFTING_TABLE:
			_drafting_lamp_sound = ProceduralAudio.create_drafting_lamp_hum_sound()
		PropType.JAKUB_PHOTOGRAPH_FRAME:
			_photo_slide_sound = ProceduralAudio.create_photo_slide_sound()
		PropType.RESONANCE_CIRCUIT_NODE:
			_relay_click_sound = ProceduralAudio.create_relay_alignment_click_sound()
		PropType.METAL_SCRATCH_BEAM:
			_metal_scratch_sound = ProceduralAudio.create_metal_scratch_chime_sound()
		PropType.TAPE_PLAYBACK_DECK:
			_tape_degradation_sound = ProceduralAudio.create_tape_degradation_filter_sound()
		PropType.SEAM_STABILIZER_LEVER, PropType.TRANSIT_SERVICE_GATE:
			_seam_clamp_sound = ProceduralAudio.create_seam_clamp_sound()
		PropType.SUBSTRUCTURE_CONDUIT_SHAFT:
			_conduit_wind_sound = ProceduralAudio.create_conduit_shaft_wind_sound()
		PropType.HANDWRITTEN_CORRELATION_FORMULA:
			_resonance_pulse_sound = ProceduralAudio.create_resonance_pulse_sound()
		PropType.REFLECTIVE_PUDDLE:
			_water_drip_sound = ProceduralAudio.create_water_drip_puddle_sound()
		PropType.PRESSURE_RELIEF_VALVE:
			_pressure_valve_sound = ProceduralAudio.create_pressure_valve_release_sound()
		PropType.CRACKED_TEA_CUP:
			_cup_clink_sound = ProceduralAudio.create_ceramic_cup_clink_sound()
		PropType.CORRELATION_DOSSIER:
			_dossier_paper_sound = ProceduralAudio.create_dossier_paper_turn_sound()
		PropType.KITCHEN_CLOCK:
			_clock_tick_sound = ProceduralAudio.create_kitchen_clock_tick_sound()
		PropType.QUEUING_TICKET_DISPENSER:
			_dispenser_ticket_sound = ProceduralAudio.create_dispenser_ticket_sound()
		PropType.COMPLIANCE_WAITING_BENCH:
			_clinic_intercom_sound = ProceduralAudio.create_clinic_intercom_chime_sound()
		PropType.PNEUMATIC_DOSSIER_STATION:
			_pneumatic_tube_sound = ProceduralAudio.create_pneumatic_tube_whoosh_sound()
		PropType.DIAGNOSTIC_MEMORY_PRINTER:
			_wierzbicka_printer_sound = ProceduralAudio.create_wierzbicka_printer_sound()
		PropType.WIERZBICKA_DESK:
			_wierzbicka_stamp_sound = ProceduralAudio.create_wierzbicka_stamp_sound()
		PropType.SENSORY_MEMORY_MAP:
			_map_node_pulse_sound = ProceduralAudio.create_map_node_pulse_sound()
		PropType.CORRECTION_GALVANOMETER:
			_galvanometer_tick_sound = ProceduralAudio.create_sensory_galvanometer_tick_sound()
		PropType.ACOUSTIC_WEIGHT_CONDUIT:
			_substructure_strain_sound = ProceduralAudio.create_substructure_strain_groan_sound()
		PropType.MODEL_DISPLAY_TABLE:
			_model_table_sound = ProceduralAudio.create_model_table_resonance_sound()
		PropType.STAIRCASE_MAP_LEFT, PropType.STAIRCASE_MAP_RIGHT:
			_map_rustle_sound = ProceduralAudio.create_paper_map_rustle_sound()
		PropType.ELEVEN_PERSONS_LEDGER:
			_ledger_page_sound = ProceduralAudio.create_ledger_page_turn_sound()
		PropType.MODEL_ROOM_EXIT:
			_model_door_release_sound = ProceduralAudio.create_model_room_door_release_sound()
		PropType.SZYMON_BERA:
			_szymon_blip_sound = ProceduralAudio.create_szymon_dialogue_blip_sound()
		PropType.WELL_DRAWING:
			_crayon_rustle_sound = ProceduralAudio.create_crayon_drawing_rustle_sound()
		PropType.HYDROLOGY_REPORT:
			_dossier_paper_sound = ProceduralAudio.create_dossier_paper_turn_sound()
		PropType.ERASED_SIGNATURE_MAGNIFIER:
			_well_drip_sound = ProceduralAudio.create_well_water_drip_sound()
		PropType.SZYMON_ROOM_EXIT:
			_door_shift_sound = ProceduralAudio.create_door_creak_shift_sound()
		PropType.SZYMON_POST_CORRECTION:
			_erased_glitch_sound = ProceduralAudio.create_erased_name_glitch_sound()
			_szymon_blip_sound = ProceduralAudio.create_szymon_dialogue_blip_sound()
		PropType.ANESTHESIA_TERMINAL:
			_sedation_monitor_sound = ProceduralAudio.create_sedation_monitor_blip_sound()
			_anesthetic_hum_sound = ProceduralAudio.create_anesthetic_hum_sound()
		PropType.FILTERED_DOSSIER_SLOT:
			_dossier_paper_sound = ProceduralAudio.create_dossier_paper_turn_sound()
		PropType.DRAWING_DISPOSITION_PEDESTAL:
			_crayon_rustle_sound = ProceduralAudio.create_crayon_drawing_rustle_sound()
		PropType.STATION_21_EXIT:
			_airlock_21_sound = ProceduralAudio.create_station21_airlock_sound()
		PropType.BIOMETRIC_IDENTITY_GATE:
			_biometric_gate_sound = ProceduralAudio.create_biometric_gate_scan_sound()
		PropType.COMPLIANCE_CONTACT_REGISTER:
			_terminal_key_sound = ProceduralAudio.create_terminal_keypress_sound()
		PropType.RING_FITTING_SCANNER:
			_ring_resonance_sound = ProceduralAudio.create_ring_resonance_hum_sound()
		PropType.PAINT_RESIN_RESONANCE_SLAB:
			_paint_recall_sound = ProceduralAudio.create_paint_memory_recall_sound()
			_biographical_erasure_sound = ProceduralAudio.create_biographical_erasure_glitch_sound()
		PropType.STATION_22_EXIT:
			_door_release_22_sound = ProceduralAudio.create_station22_door_release_sound()
		PropType.DESIGNER_TERMINAL:
			_designer_terminal_sound = ProceduralAudio.create_designer_terminal_hum_sound()
		PropType.SUBSTRUCTURE_ARCHITECTURAL_MODEL:
			_designer_note_sound = ProceduralAudio.create_designer_note_chime_sound()
		PropType.BURDENED_PERSONS_LEDGER:
			_burden_ledger_sound = ProceduralAudio.create_burden_ledger_scan_sound()
		PropType.SHADOW_INTERACTIVE_CONSOLE:
			_cursor_shift_sound = ProceduralAudio.create_cursor_shift_glitch_sound()
		PropType.STATION_23_EXIT:
			_door_release_23_sound = ProceduralAudio.create_station23_exit_unlatch_sound()
		PropType.CCTV_SURVEILLANCE_ARRAY:
			_cctv_hum_sound = ProceduralAudio.create_cctv_static_hum_sound()
		PropType.CORRECTION_ACCUMULATION_GAUGE:
			_correction_siren_sound = ProceduralAudio.create_correction_stress_siren_sound()
		PropType.WIERZBICKA_TRANSMISSION_TERMINAL:
			_intercom_wierzbicka_sound = ProceduralAudio.create_intercom_wierzbicka_tone_sound()
		PropType.LENA_DISPOSITION_SELECTOR:
			_decision_latch_sound = ProceduralAudio.create_decision_button_latch_sound()
		PropType.STATION_24_EXIT:
			_door_release_24_sound = ProceduralAudio.create_station24_door_release_sound()
		PropType.JAKUB_OPERATOR_UCP:
			_jakub_uniform_sound = ProceduralAudio.create_jakub_uniform_rustle_sound()
			_jakub_blip_sound = ProceduralAudio.create_dialogue_jakub_blip_sound()
		PropType.TRANSIT_MAINTENANCE_CART:
			_transit_rail_sound = ProceduralAudio.create_transit_rail_hum_sound()
		PropType.SCAR_DIAGNOSTIC_CHART:
			_scar_revelation_sound = ProceduralAudio.create_scar_revelation_chime_sound()
		PropType.JAKUB_HAND_GESTURE_SENSOR:
			_finger_scrape_sound = ProceduralAudio.create_finger_edge_scrape_sound()
		PropType.STATION_25_EXIT:
			_door_release_25_sound = ProceduralAudio.create_station25_door_release_sound()
		PropType.ISOLATION_ZONE_CONSOLE:
			_isolation_hum_sound = ProceduralAudio.create_isolation_hum_sound()
		PropType.DYNAMIC_ROOM_DESIGNATOR:
			_reconfiguration_sound = ProceduralAudio.create_reconfiguration_chime_sound()
		PropType.MOTIVATION_ANCHOR_RECORD:
			_motivation_scratch_sound = ProceduralAudio.create_motivation_scratch_sound()
		PropType.WIERZBICKA_PA_SPEAKER:
			_wierzbicka_calming_sound = ProceduralAudio.create_wierzbicka_calming_tone_sound()
		PropType.STATION_26_EXIT:
			_door_release_26_sound = ProceduralAudio.create_station26_door_release_sound()
		PropType.JAKUB_SERVICE_OPERATOR:
			_jakub_keycard_sound = ProceduralAudio.create_jakub_keycard_latch_sound()
		PropType.SAVED_WORKER_BADGE:
			_gratitude_confession_sound = ProceduralAudio.create_gratitude_confession_tone_sound()
		PropType.SURFACE_STABILITY_MONITOR:
			_surface_danger_sound = ProceduralAudio.create_surface_danger_siren_sound()
		PropType.TECHNICAL_JUNCTION_CONSOLE:
			_service_tunnel_sound = ProceduralAudio.create_service_tunnel_hum_sound()
		PropType.STATION_27_EXIT:
			_door_release_27_sound = ProceduralAudio.create_station27_door_release_sound()
		PropType.TRAM_DRIVER_CONSOLE:
			_tram_motor_sound = ProceduralAudio.create_moving_tram_motor_sound()
		PropType.PANORAMIC_TRANSIT_WINDOW:
			_track_switch_sound = ProceduralAudio.create_track_switch_clack_sound()
		PropType.TRIPLE_ACCIDENT_PARADOX_VIEW:
			_paradox_shimmer_sound = ProceduralAudio.create_paradox_peron_shimmer_sound()
		PropType.WIERZBICKA_CLOSING_INTERCOM:
			_wierzbicka_closing_sound = ProceduralAudio.create_wierzbicka_closing_intercom_sound()
		PropType.STATION_28_EXIT:
			_door_release_28_sound = ProceduralAudio.create_station28_pneumatic_brake_sound()
		PropType.ABANDONED_PLATFORM_TRACKS:
			_platform13_drip_sound = ProceduralAudio.create_platform13_drip_echo_sound()
		PropType.FLICKERING_NEON_SIGN:
			_flickering_neon_sound = ProceduralAudio.create_flickering_neon_buzz_sound()
		PropType.DEEP_SUBSTRUCTURE_WELL:
			_deep_well_sound = ProceduralAudio.create_deep_well_drone_sound()
		PropType.JAKUB_TORCH_BEACON:
			_jakub_torch_sound = ProceduralAudio.create_jakub_torch_click_sound()
		PropType.STATION_29_EXIT:
			_door_release_29_sound = ProceduralAudio.create_station29_grate_creak_sound()
		PropType.MAIN_POWER_DISTRIBUTION_BOARD:
			_power_grid_relay_sound = ProceduralAudio.create_power_grid_relay_sound()
		PropType.HIGH_VOLTAGE_TRANSFORMER_BANK:
			_transformer_oil_sound = ProceduralAudio.create_transformer_oil_hum_sound()
		PropType.SECTION_BREAKER_LEVER:
			_knife_switch_sound = ProceduralAudio.create_knife_switch_throw_sound()
		PropType.GRID_SCHEMATIC_DISPLAY:
			_high_voltage_spark_sound = ProceduralAudio.create_high_voltage_spark_sound()
		PropType.STATION_30_EXIT:
			_door_release_30_sound = ProceduralAudio.create_station30_door_release_sound()
		PropType.ELEVEN_CHAIRS_ARCHIVE_ROW:
			_eleven_chairs_sound = ProceduralAudio.create_eleven_chairs_whisper_sound()
		PropType.WIERZBICKA_REMOTE_HOLOTERMINAL:
			_wierzbicka_recitation_sound = ProceduralAudio.create_wierzbicka_recitation_chime_sound()
		PropType.JAKUB_TWELFTH_CHAIR:
			_twelfth_chair_sound = ProceduralAudio.create_twelfth_chair_resonance_sound()
		PropType.VARIANT_CHOICE_LEDGER:
			_variant_ledger_sound = ProceduralAudio.create_variant_ledger_page_sound()
		PropType.STATION_31_EXIT:
			_door_release_31_sound = ProceduralAudio.create_station31_pressure_hiss_sound()
		PropType.STEAMED_GLASS_PANE_A:
			_steamed_glass_sound = ProceduralAudio.create_glass_condensation_wipe_sound()
		PropType.CRACKED_GLASS_PANE_B:
			_cracked_glass_sound = ProceduralAudio.create_fire_memory_rumble_sound()
		PropType.POLISHED_GLASS_PANE_C:
			_polished_glass_sound = ProceduralAudio.create_consensus_stamp_reverberation_sound()
		PropType.CONDENSATION_TRACE_ETCHER:
			_trace_etcher_sound = ProceduralAudio.create_glass_stress_ring_sound()
		PropType.STATION_32_EXIT:
			_door_release_32_sound = ProceduralAudio.create_station32_hatch_unseal_sound()
		PropType.VERTICAL_LADDER_ARRAY:
			_ladder_climb_sound = ProceduralAudio.create_ladder_rung_climb_sound()
		PropType.DEPTH_PRESSURE_GAUGE:
			_depth_creak_sound = ProceduralAudio.create_depth_pressure_creak_sound()
		PropType.MEMORY_BUS_CABLE_TRUNK:
			_cable_trunk_sound = ProceduralAudio.create_cable_trunk_pulse_sound()
		PropType.SHAFT_WORK_LIGHT_BEACON:
			_work_light_sound = ProceduralAudio.create_shaft_work_light_hum_sound()
		PropType.STATION_33_EXIT:
			_door_release_33_sound = ProceduralAudio.create_station33_lower_hatch_sound()
		PropType.MAIN_EXCHANGE_CORE_REACTOR:
			_core_pulse_sound = ProceduralAudio.create_core_reactor_pulse_sound()
		PropType.BIOGRAPHY_ALLOCATION_DESK:
			_slider_drag_sound = ProceduralAudio.create_biography_slider_drag_sound()
		PropType.THERMAL_OVERLOAD_INDICATOR:
			_thermal_alarm_sound = ProceduralAudio.create_core_thermal_alarm_sound()
		PropType.JAKUB_CORE_DIAGNOSTIC_PORT:
			_jakub_probe_sound = ProceduralAudio.create_jakub_diagnostic_probe_sound()
		PropType.STATION_34_EXIT:
			_door_release_34_sound = ProceduralAudio.create_station34_filtration_gate_sound()
		PropType.SEDATION_BASIN_POOL:
			_sedation_slosh_sound = ProceduralAudio.create_sedation_liquid_slosh_sound()
		PropType.SLUDGE_DRAIN_VALVE_WHEEL:
			_sludge_valve_sound = ProceduralAudio.create_sludge_valve_creak_sound()
		PropType.CHEMICAL_SEDATION_SAMPLER:
			_chemical_bubbler_sound = ProceduralAudio.create_chemical_bubbler_sound()
		PropType.JAKUB_SEDATION_MONITOR:
			_sedation_alarm_sound = ProceduralAudio.create_sedation_saturation_alarm_sound()
		PropType.STATION_35_EXIT:
			_door_release_35_sound = ProceduralAudio.create_station35_drain_sluice_sound()
		PropType.STORM_DRAIN_WEIR:
			_drain_weir_creak_sound = ProceduralAudio.create_drain_weir_creak_sound()
		PropType.SEDATIVE_SLUDGE_CURRENT:
			_storm_drain_torrent_sound = ProceduralAudio.create_storm_drain_torrent_sound()
		PropType.ACID_RESISTANT_CATWALK_LADDER:
			_acid_ladder_clank_sound = ProceduralAudio.create_acid_ladder_clank_sound()
		PropType.CONTAMINATION_SAMPLING_TAP:
			_groundwater_leak_alarm_sound = ProceduralAudio.create_groundwater_leak_alarm_sound()
		PropType.STATION_36_EXIT:
			_door_release_36_sound = ProceduralAudio.create_station36_storm_gate_sound()
		PropType.SIGNAL_TRANSMISSION_ANTENNA:
			_signal_antenna_sound = ProceduralAudio.create_signal_antenna_carrier_sound()
		PropType.TRANSMISSION_CROSS_PATCHBAY:
			_cross_patchbay_sound = ProceduralAudio.create_cross_patchbay_plug_sound()
		PropType.FREQUENCY_OSCILLOSCOPE_CRT:
			_crt_sweep_sound = ProceduralAudio.create_crt_sweep_interference_sound()
		PropType.MEMORY_INJECTION_PULPIT:
			_memory_lever_sound = ProceduralAudio.create_memory_injection_lever_sound()
		PropType.STATION_37_EXIT:
			_door_release_37_sound = ProceduralAudio.create_station37_broadcast_gate_sound()
		PropType.ACCIDENT_SIMULATION_FIELD:
			_accident_field_sound = ProceduralAudio.create_accident_field_distortion_sound()
		PropType.DESTABILIZING_JAKUB_SHADOW:
			_jakub_destabilize_sound = ProceduralAudio.create_jakub_destabilization_hum_sound()
		PropType.RESCUE_TETHER_ANCHOR:
			_rescue_tether_sound = ProceduralAudio.create_rescue_tether_chime_sound()
		PropType.RETURN_COORDINATE_CALCULATOR:
			_coordinate_calc_sound = ProceduralAudio.create_coordinate_calculator_click_sound()
		PropType.STATION_38_EXIT:
			_door_release_38_sound = ProceduralAudio.create_station38_reference_vault_door_sound()
		PropType.CENTRAL_REFERENCE_CORE_MONOLITH:
			_reference_core_sound = ProceduralAudio.create_reference_core_harmonics_sound()
		PropType.BRANCH_CONFIG_RETURN_A:
			_config_a_sound = ProceduralAudio.create_branch_configuration_a_sound()
		PropType.BRANCH_CONFIG_RECONCILIATION_B:
			_config_b_sound = ProceduralAudio.create_branch_configuration_b_sound()
		PropType.BRANCH_CONFIG_TESTIMONY_C:
			_config_c_sound = ProceduralAudio.create_branch_configuration_c_sound()
		PropType.STATION_39_EXIT:
			_act4_gateway_sound = ProceduralAudio.create_station39_act4_gateway_sound()
		PropType.WIERZBICKA_PERSONAL_TERMINAL:
			_wierzbicka_terminal_sound = ProceduralAudio.create_wierzbicka_personal_terminal_sound()
		PropType.MARTA_WITNESS_STATION:
			_marta_witness_sound = ProceduralAudio.create_marta_witness_presence_sound()
		PropType.SZYMON_TRANSMISSION_MONITOR:
			_szymon_transmission_sound = ProceduralAudio.create_szymon_transmission_feed_sound()
		PropType.OPERATION_COST_DOSSIER_MATRIX:
			_cost_matrix_sound = ProceduralAudio.create_cost_dossier_matrix_sound()
		PropType.STATION_40_EXIT:
			_gate_40_sound = ProceduralAudio.create_station40_final_chamber_gate_sound()
		PropType.OP_CONSOLE_RETURN_A:
			_op_return_sound = ProceduralAudio.create_operation_return_execution_sound()
		PropType.OP_CONSOLE_RECONCILIATION_B:
			_op_reconciliation_sound = ProceduralAudio.create_operation_reconciliation_execution_sound()
		PropType.OP_CONSOLE_TESTIMONY_C:
			_op_testimony_sound = ProceduralAudio.create_operation_testimony_execution_sound()
		PropType.OP_CONTINUITY_TOPOGRAPHY_DISPLAY:
			_op_console_sound = ProceduralAudio.create_operation_console_engage_sound()
		PropType.STATION_41_EXIT:
			_gate_41_sound = ProceduralAudio.create_station41_act4_resolution_gate_sound()
		PropType.EPILOGUE_RETURN_CUPS:
			_epilogue_cups_sound = ProceduralAudio.create_epilogue_cup_clink_sound()
		PropType.EPILOGUE_MARTA_DOORSTEP:
			_marta_witness_sound = ProceduralAudio.create_marta_witness_presence_sound()
		PropType.EPILOGUE_TRAM_DUAL_TRACKS:
			_epilogue_switch_latch_sound = ProceduralAudio.create_epilogue_tram_switch_latch_sound()
		PropType.EPILOGUE_ADMIN_NOTICE_BOARD:
			_epilogue_radio_sound = ProceduralAudio.create_epilogue_radio_announcement_sound()
		PropType.EPILOGUE_CREDITS_ROLL:
			_epilogue_credits_sound = ProceduralAudio.create_epilogue_credits_drone_sound()
		PropType.EPILOGUE_FINAL_BLACKOUT:
			_epilogue_blackout_sound = ProceduralAudio.create_epilogue_final_carrier_sound()
		_:
			_memory_sound = ProceduralAudio.create_memory_resonance_sound()
	
	_audio_player = get_node_or_null("AudioPlayer2D") as AudioStreamPlayer2D
	if _audio_player == null:
		_audio_player = AudioStreamPlayer2D.new()
		_audio_player.name = "AudioPlayer2D"
		_audio_player.max_distance = 500.0
		_audio_player.bus = &"Master"
		add_child(_audio_player)


## PKG-0140 (D-147). Trzy bufory haptyczne sa wspolne dla wszystkich 45 stacji,
## wiec ida przez cache PCM procesu — dolozenie warstwy dotyku nie kosztuje ani
## jednej dodatkowej syntezy na zmiane sceny.
func _setup_haptic_layer() -> void:
	_contact_tap_sound = ProceduralAudio.get_cached_sound(
		&"contact_tap", ProceduralAudio.create_contact_tap_sound
	)
	_probe_brush_sound = ProceduralAudio.get_cached_sound(
		&"probe_brush", ProceduralAudio.create_probe_brush_sound
	)
	_detent_sound = ProceduralAudio.get_cached_sound(
		&"switch_detent", ProceduralAudio.create_switch_detent_sound
	)

	_spawn_grace = SPAWN_GRACE_SECONDS


func _play_haptic(stream: AudioStreamWAV, pitch_low: float = 0.94, pitch_high: float = 1.06) -> void:
	if stream == null:
		return
	StationAudioVoices.play_at(
		self,
		StationAudioVoices.HAPTIC,
		stream,
		260.0,
		-11.0,
		randf_range(pitch_low, pitch_high)
	)


## Postep kontaktu, wystawiony dla bramki PKG-0140.
func get_contact_progress() -> float:
	return _contact_progress


## Swiezosc ostatniego dotkniecia, wystawiona dla bramki PKG-0140.
func get_touch_flash() -> float:
	return _touch_flash


func _setup_particles() -> void:
	_particles = get_node_or_null("ResonanceParticles") as CPUParticles2D
	if _particles == null:
		_particles = CPUParticles2D.new()
		_particles.name = "ResonanceParticles"
		_particles.emitting = false
		_particles.one_shot = true
		_particles.amount = 14
		_particles.lifetime = 0.65
		_particles.explosiveness = 0.7
		_particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
		_particles.emission_rect_extents = Vector2(16.0, 16.0)
		_particles.direction = Vector2(0.0, -1.0)
		_particles.spread = 45.0
		_particles.gravity = Vector2(0.0, -25.0)
		_particles.initial_velocity_min = 20.0
		_particles.initial_velocity_max = 45.0
		_particles.scale_amount_min = 1.5
		_particles.scale_amount_max = 3.0
		_particles.color = COLOR_AMBER
		ParticleBudget.apply_frame_budget(_particles)
		add_child(_particles)


func _physics_process(_delta: float) -> void:
	if not is_player_in_range and has_overlapping_bodies():
		for b in get_overlapping_bodies():
			if b is PrototypePlayer or b.name == "Player":
				is_player_in_range = true
				break

func _process(delta: float) -> void:
	_pulse_phase += delta * 2.8
	# PKG-0140 (D-147). Kontakt narasta i opada; rekwizyt nie zapala sie ani nie
	# gasnie w jednej klatce, wiec zblizenie sie do niego czyta sie jak dotyk.
	if _spawn_grace > 0.0:
		_spawn_grace = maxf(0.0, _spawn_grace - delta)
	var contact_target := 1.0 if is_player_in_range else 0.0
	var contact_rate := 5.5 if is_player_in_range else 3.2
	var previous_contact := _contact_progress
	_contact_progress = move_toward(_contact_progress, contact_target, contact_rate * delta)
	if _touch_flash > 0.0:
		_touch_flash = maxf(0.0, _touch_flash - delta * 2.4)
	if _resonance_flash > 0.0:
		_resonance_flash = maxf(0.0, _resonance_flash - delta * 2.2)
		queue_redraw()
	elif not is_equal_approx(previous_contact, _contact_progress):
		queue_redraw()
	elif is_player_in_range and not is_activated:
		queue_redraw()


func _on_body_entered(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		var was_in_range := is_player_in_range
		is_player_in_range = true
		if not was_in_range and _spawn_grace <= 0.0:
			_play_haptic(_contact_tap_sound, 0.88, 1.12)


func _on_body_exited(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		is_player_in_range = false


func _unhandled_input(event: InputEvent) -> void:
	if not is_player_in_range:
		return
	if event.is_action_pressed(&"interact"):
		trigger_interaction()
		get_viewport().set_input_as_handled()


func trigger_interaction() -> void:
	if is_one_shot and is_activated:
		return
	# Warstwa haptyczna idzie pierwsza i zawsze: badanie punktu pamieci ma
	# brzmiec pod palcem, zanim odezwie sie sam rekwizyt (D-147).
	_touch_flash = 1.0
	if prop_type in SWITCH_LIKE_PROPS:
		_play_haptic(_detent_sound, 0.96, 1.05)
	else:
		_play_haptic(_probe_brush_sound)
	queue_redraw()
	var game_state := get_node_or_null("/root/GameStateManager")
	if game_state:
		game_state.collect_clue(StringName(resonance_id))
	
	if prop_type == PropType.CIRCUIT_BREAKER:
		is_activated = not is_activated
		if _audio_player and _switch_sound:
			_audio_player.stream = _switch_sound
			_audio_player.pitch_scale = 1.1 if is_activated else 0.9
			_audio_player.play()
	elif prop_type == PropType.DESK_TELEPHONE:
		is_activated = true
		if _audio_player and _phone_sound:
			_audio_player.stream = _phone_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.DOOR_CARD_READER:
		is_activated = true
		if _audio_player and _card_reader_sound:
			_audio_player.stream = _card_reader_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.CROSSWALK_SIGNAL:
		is_activated = true
		if _audio_player and _crosswalk_sound:
			_audio_player.stream = _crosswalk_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.BUS_SPEAKER:
		is_activated = true
		if _audio_player and _bus_announcement_sound:
			_audio_player.stream = _bus_announcement_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.GOLD_RING:
		is_activated = true
		if _audio_player and _ring_sound:
			_audio_player.stream = _ring_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STAIR_TIMER_SWITCH:
		is_activated = true
		if _audio_player and _timer_switch_sound:
			_audio_player.stream = _timer_switch_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.MARTA_INTERACTION:
		is_activated = true
		if _audio_player and _marta_blip_sound:
			_audio_player.stream = _marta_blip_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.CIPHER_DESK:
		is_activated = true
		if _audio_player and _drawer_unlatch_sound:
			_audio_player.stream = _drawer_unlatch_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.TEA_KETTLE:
		is_activated = true
		if _audio_player and _kettle_whistle_sound:
			_audio_player.stream = _kettle_whistle_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.JAKUB_MEMENTO_TOOL:
		is_activated = true
		if _audio_player and _paper_rustle_sound:
			_audio_player.stream = _paper_rustle_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.BATHROOM_SINK:
		is_activated = true
		if _audio_player and _pipe_sound:
			_audio_player.stream = _pipe_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.BATHROOM_MIRROR:
		is_activated = true
		if _audio_player and _mirror_shimmer_sound:
			_audio_player.stream = _mirror_shimmer_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SCRATCHED_INSCRIPTION:
		is_activated = true
		if _audio_player and _glass_scratch_sound:
			_audio_player.stream = _glass_scratch_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.APOTHECARY_CABINET:
		is_activated = true
		if _audio_player and _drawer_unlatch_sound:
			_audio_player.stream = _drawer_unlatch_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.MARTA_BATHROOM_GUIDE:
		is_activated = true
		if _audio_player and _marta_blip_sound:
			_audio_player.stream = _marta_blip_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.BAKELITE_PHONE:
		is_activated = true
		if _audio_player and _handset_pickup_sound:
			_audio_player.stream = _handset_pickup_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.REEL_TAPE_RECORDER:
		is_activated = true
		if _audio_player and _tape_hum_sound:
			_audio_player.stream = _tape_hum_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.TOPOGRAPHY_BOARD:
		is_activated = true
		if _audio_player and _paper_rustle_sound:
			_audio_player.stream = _paper_rustle_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.JAKUB_DESK_LAMP:
		is_activated = true
		if _audio_player and _switch_sound:
			_audio_player.stream = _switch_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.TECH_STORAGE_AIRLOCK:
		is_activated = true
		if _audio_player and _door_sound:
			_audio_player.stream = _door_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.OBSERVATION_WINDOW:
		is_activated = true
		if _audio_player and _morning_ambience_sound:
			_audio_player.stream = _morning_ambience_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.ERASED_DOORWAY_TRACE:
		is_activated = true
		if _audio_player and _masonry_smooth_sound:
			_audio_player.stream = _masonry_smooth_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.UCP_INTERVENTION_TEAM:
		is_activated = true
		if _audio_player and _ucp_stabilizer_sound:
			_audio_player.stream = _ucp_stabilizer_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.ELDERLY_RESIDENT_GUIDE:
		is_activated = true
		if _audio_player and _elderly_woman_sound:
			_audio_player.stream = _elderly_woman_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.MARTA_OBSERVATION_DIALOGUE:
		is_activated = true
		if _audio_player and _marta_blip_sound:
			_audio_player.stream = _marta_blip_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.COURTYARD_EXIT_AIRLOCK:
		is_activated = true
		if _audio_player and _door_sound:
			_audio_player.stream = _door_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.UCP_INFO_TERMINAL:
		is_activated = true
		if _audio_player and _terminal_key_sound:
			_audio_player.stream = _terminal_key_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SHOWCASE_VITRINE:
		is_activated = true
		if _audio_player and _paper_rustle_sound:
			_audio_player.stream = _paper_rustle_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.INSTRUCTION_POSTER:
		is_activated = true
		if _audio_player and _pa_chime_sound:
			_audio_player.stream = _pa_chime_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SUBWAY_TILE_PILLAR:
		is_activated = true
		if _audio_player and _tile_sound:
			_audio_player.stream = _tile_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.UNDERPASS_EXIT_GATE:
		is_activated = true
		if _audio_player and _door_sound:
			_audio_player.stream = _door_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.DRAFTING_TABLE:
		is_activated = true
		if _audio_player and _drafting_lamp_sound:
			_audio_player.stream = _drafting_lamp_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.TOPOGRAPHY_INDEX_CABINET:
		is_activated = true
		if _audio_player and _drawer_unlatch_sound:
			_audio_player.stream = _drawer_unlatch_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.JAKUB_PHOTOGRAPH_FRAME:
		is_activated = true
		if _audio_player and _photo_slide_sound:
			_audio_player.stream = _photo_slide_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.RESONANCE_CIRCUIT_NODE:
		is_activated = true
		if _audio_player and _relay_click_sound:
			_audio_player.stream = _relay_click_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.TECH_PASSAGE_AIRLOCK:
		is_activated = true
		if _audio_player and _door_sound:
			_audio_player.stream = _door_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.METAL_SCRATCH_BEAM:
		is_activated = true
		if _audio_player and _metal_scratch_sound:
			_audio_player.stream = _metal_scratch_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.TAPE_PLAYBACK_DECK:
		is_activated = true
		if _audio_player and _tape_degradation_sound:
			_audio_player.stream = _tape_degradation_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.MAINTENANCE_RACK:
		is_activated = true
		if _audio_player and _drawer_unlatch_sound:
			_audio_player.stream = _drawer_unlatch_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SEAM_STABILIZER_LEVER:
		is_activated = not is_activated
		if _audio_player and _seam_clamp_sound:
			_audio_player.stream = _seam_clamp_sound
			_audio_player.pitch_scale = 1.05 if is_activated else 0.95
			_audio_player.play()
	elif prop_type == PropType.SUBSTRUCTURE_CONDUIT_SHAFT:
		is_activated = true
		if _audio_player and _conduit_wind_sound:
			_audio_player.stream = _conduit_wind_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.HYGIENE_INSTRUCTION_BOARD:
		is_activated = true
		if _audio_player and _paper_rustle_sound:
			_audio_player.stream = _paper_rustle_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.HANDWRITTEN_CORRELATION_FORMULA:
		is_activated = true
		if _audio_player and _resonance_pulse_sound:
			_audio_player.stream = _resonance_pulse_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.REFLECTIVE_PUDDLE:
		is_activated = not is_activated
		if _audio_player and _water_drip_sound:
			_audio_player.stream = _water_drip_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.PRESSURE_RELIEF_VALVE:
		is_activated = not is_activated
		if _audio_player and _pressure_valve_sound:
			_audio_player.stream = _pressure_valve_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.TRANSIT_SERVICE_GATE:
		is_activated = true
		if _audio_player and _seam_clamp_sound:
			_audio_player.stream = _seam_clamp_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.CRACKED_TEA_CUP:
		is_activated = true
		if _audio_player and _cup_clink_sound:
			_audio_player.stream = _cup_clink_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.CORRELATION_DOSSIER:
		is_activated = true
		if _audio_player and _dossier_paper_sound:
			_audio_player.stream = _dossier_paper_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.KITCHEN_CLOCK:
		is_activated = true
		if _audio_player and _clock_tick_sound:
			_audio_player.stream = _clock_tick_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.WEDDING_RING_STAND:
		is_activated = true
		if _audio_player and _ring_sound:
			_audio_player.stream = _ring_sound
			_audio_player.pitch_scale = 1.05
			_audio_player.play()
	elif prop_type == PropType.BALCONY_EXIT_DOOR:
		is_activated = true
		if _audio_player and _door_sound:
			_audio_player.stream = _door_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.QUEUING_TICKET_DISPENSER:
		is_activated = true
		if _audio_player and _dispenser_ticket_sound:
			_audio_player.stream = _dispenser_ticket_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.COMPLIANCE_WAITING_BENCH:
		is_activated = true
		if _audio_player and _clinic_intercom_sound:
			_audio_player.stream = _clinic_intercom_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.PNEUMATIC_DOSSIER_STATION:
		is_activated = true
		if _audio_player and _pneumatic_tube_sound:
			_audio_player.stream = _pneumatic_tube_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.DIAGNOSTIC_MEMORY_PRINTER:
		is_activated = true
		if _audio_player and _wierzbicka_printer_sound:
			_audio_player.stream = _wierzbicka_printer_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.CONSULTATION_OFFICE_DOOR:
		is_activated = true
		if _audio_player and _door_sound:
			_audio_player.stream = _door_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.WIERZBICKA_DESK:
		is_activated = true
		if _audio_player and _wierzbicka_stamp_sound:
			_audio_player.stream = _wierzbicka_stamp_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SENSORY_MEMORY_MAP:
		is_activated = true
		if _audio_player and _map_node_pulse_sound:
			_audio_player.stream = _map_node_pulse_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.CORRECTION_GALVANOMETER:
		is_activated = true
		if _audio_player and _galvanometer_tick_sound:
			_audio_player.stream = _galvanometer_tick_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.ACOUSTIC_WEIGHT_CONDUIT:
		is_activated = true
		if _audio_player and _substructure_strain_sound:
			_audio_player.stream = _substructure_strain_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.MODEL_ROOM_AIRLOCK:
		is_activated = true
		if _audio_player and _door_sound:
			_audio_player.stream = _door_sound
			_audio_player.pitch_scale = 1.05
			_audio_player.play()
	elif prop_type == PropType.MODEL_DISPLAY_TABLE:
		is_activated = true
		if _audio_player and _model_table_sound:
			_audio_player.stream = _model_table_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STAIRCASE_MAP_LEFT or prop_type == PropType.STAIRCASE_MAP_RIGHT:
		is_activated = true
		if _audio_player and _map_rustle_sound:
			_audio_player.stream = _map_rustle_sound
			_audio_player.pitch_scale = 1.05 if prop_type == PropType.STAIRCASE_MAP_LEFT else 0.95
			_audio_player.play()
	elif prop_type == PropType.ELEVEN_PERSONS_LEDGER:
		is_activated = true
		if _audio_player and _ledger_page_sound:
			_audio_player.stream = _ledger_page_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.MODEL_ROOM_EXIT:
		is_activated = true
		if _audio_player and _model_door_release_sound:
			_audio_player.stream = _model_door_release_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SZYMON_BERA:
		is_activated = true
		if _audio_player and _szymon_blip_sound:
			_audio_player.stream = _szymon_blip_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.WELL_DRAWING:
		is_activated = true
		if _audio_player and _crayon_rustle_sound:
			_audio_player.stream = _crayon_rustle_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.HYDROLOGY_REPORT:
		is_activated = true
		if _audio_player and _dossier_paper_sound:
			_audio_player.stream = _dossier_paper_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.ERASED_SIGNATURE_MAGNIFIER:
		is_activated = true
		if _audio_player and _well_drip_sound:
			_audio_player.stream = _well_drip_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SZYMON_ROOM_EXIT:
		is_activated = true
		if _audio_player and _door_shift_sound:
			_audio_player.stream = _door_shift_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SZYMON_POST_CORRECTION:
		is_activated = true
		if _audio_player and _erased_glitch_sound:
			_audio_player.stream = _erased_glitch_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.ANESTHESIA_TERMINAL:
		is_activated = true
		if _audio_player and _sedation_monitor_sound:
			_audio_player.stream = _sedation_monitor_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.FILTERED_DOSSIER_SLOT:
		is_activated = true
		if _audio_player and _dossier_paper_sound:
			_audio_player.stream = _dossier_paper_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.DRAWING_DISPOSITION_PEDESTAL:
		is_activated = true
		if _audio_player and _crayon_rustle_sound:
			_audio_player.stream = _crayon_rustle_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_21_EXIT:
		is_activated = true
		if _audio_player and _airlock_21_sound:
			_audio_player.stream = _airlock_21_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.BIOMETRIC_IDENTITY_GATE:
		is_activated = true
		if _audio_player and _biometric_gate_sound:
			_audio_player.stream = _biometric_gate_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.COMPLIANCE_CONTACT_REGISTER:
		is_activated = true
		if _audio_player and _terminal_key_sound:
			_audio_player.stream = _terminal_key_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.RING_FITTING_SCANNER:
		is_activated = true
		if _audio_player and _ring_resonance_sound:
			_audio_player.stream = _ring_resonance_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.PAINT_RESIN_RESONANCE_SLAB:
		is_activated = true
		if _audio_player and _paint_recall_sound:
			_audio_player.stream = _paint_recall_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_22_EXIT:
		is_activated = true
		if _audio_player and _door_release_22_sound:
			_audio_player.stream = _door_release_22_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.DESIGNER_TERMINAL:
		is_activated = true
		if _audio_player and _designer_terminal_sound:
			_audio_player.stream = _designer_terminal_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SUBSTRUCTURE_ARCHITECTURAL_MODEL:
		is_activated = true
		if _audio_player and _designer_note_sound:
			_audio_player.stream = _designer_note_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.BURDENED_PERSONS_LEDGER:
		is_activated = true
		if _audio_player and _burden_ledger_sound:
			_audio_player.stream = _burden_ledger_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SHADOW_INTERACTIVE_CONSOLE:
		is_activated = true
		if _audio_player and _cursor_shift_sound:
			_audio_player.stream = _cursor_shift_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_23_EXIT:
		is_activated = true
		if _audio_player and _door_release_23_sound:
			_audio_player.stream = _door_release_23_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.CCTV_SURVEILLANCE_ARRAY:
		is_activated = true
		if _audio_player and _cctv_hum_sound:
			_audio_player.stream = _cctv_hum_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.CORRECTION_ACCUMULATION_GAUGE:
		is_activated = true
		if _audio_player and _correction_siren_sound:
			_audio_player.stream = _correction_siren_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.WIERZBICKA_TRANSMISSION_TERMINAL:
		is_activated = true
		if _audio_player and _intercom_wierzbicka_sound:
			_audio_player.stream = _intercom_wierzbicka_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.LENA_DISPOSITION_SELECTOR:
		is_activated = true
		if _audio_player and _decision_latch_sound:
			_audio_player.stream = _decision_latch_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_24_EXIT:
		is_activated = true
		if _audio_player and _door_release_24_sound:
			_audio_player.stream = _door_release_24_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.JAKUB_OPERATOR_UCP:
		is_activated = true
		if _audio_player and _jakub_uniform_sound:
			_audio_player.stream = _jakub_uniform_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.TRANSIT_MAINTENANCE_CART:
		is_activated = true
		if _audio_player and _transit_rail_sound:
			_audio_player.stream = _transit_rail_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SCAR_DIAGNOSTIC_CHART:
		is_activated = true
		if _audio_player and _scar_revelation_sound:
			_audio_player.stream = _scar_revelation_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.JAKUB_HAND_GESTURE_SENSOR:
		is_activated = true
		if _audio_player and _finger_scrape_sound:
			_audio_player.stream = _finger_scrape_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_25_EXIT:
		is_activated = true
		if _audio_player and _door_release_25_sound:
			_audio_player.stream = _door_release_25_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.ISOLATION_ZONE_CONSOLE:
		is_activated = true
		if _audio_player and _isolation_hum_sound:
			_audio_player.stream = _isolation_hum_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.DYNAMIC_ROOM_DESIGNATOR:
		is_activated = true
		if _audio_player and _reconfiguration_sound:
			_audio_player.stream = _reconfiguration_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.MOTIVATION_ANCHOR_RECORD:
		is_activated = true
		if _audio_player and _motivation_scratch_sound:
			_audio_player.stream = _motivation_scratch_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.WIERZBICKA_PA_SPEAKER:
		is_activated = true
		if _audio_player and _wierzbicka_calming_sound:
			_audio_player.stream = _wierzbicka_calming_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_26_EXIT:
		is_activated = true
		if _audio_player and _door_release_26_sound:
			_audio_player.stream = _door_release_26_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.JAKUB_SERVICE_OPERATOR:
		is_activated = true
		if _audio_player and _jakub_keycard_sound:
			_audio_player.stream = _jakub_keycard_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SAVED_WORKER_BADGE:
		is_activated = true
		if _audio_player and _gratitude_confession_sound:
			_audio_player.stream = _gratitude_confession_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SURFACE_STABILITY_MONITOR:
		is_activated = true
		if _audio_player and _surface_danger_sound:
			_audio_player.stream = _surface_danger_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.TECHNICAL_JUNCTION_CONSOLE:
		is_activated = true
		if _audio_player and _service_tunnel_sound:
			_audio_player.stream = _service_tunnel_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_27_EXIT:
		is_activated = true
		if _audio_player and _door_release_27_sound:
			_audio_player.stream = _door_release_27_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.TRAM_DRIVER_CONSOLE:
		is_activated = true
		if _audio_player and _tram_motor_sound:
			_audio_player.stream = _tram_motor_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.PANORAMIC_TRANSIT_WINDOW:
		is_activated = true
		if _audio_player and _track_switch_sound:
			_audio_player.stream = _track_switch_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.TRIPLE_ACCIDENT_PARADOX_VIEW:
		is_activated = true
		if _audio_player and _paradox_shimmer_sound:
			_audio_player.stream = _paradox_shimmer_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.WIERZBICKA_CLOSING_INTERCOM:
		is_activated = true
		if _audio_player and _wierzbicka_closing_sound:
			_audio_player.stream = _wierzbicka_closing_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_28_EXIT:
		is_activated = true
		if _audio_player and _door_release_28_sound:
			_audio_player.stream = _door_release_28_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.ABANDONED_PLATFORM_TRACKS:
		is_activated = true
		if _audio_player and _platform13_drip_sound:
			_audio_player.stream = _platform13_drip_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.FLICKERING_NEON_SIGN:
		is_activated = true
		if _audio_player and _flickering_neon_sound:
			_audio_player.stream = _flickering_neon_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.DEEP_SUBSTRUCTURE_WELL:
		is_activated = true
		if _audio_player and _deep_well_sound:
			_audio_player.stream = _deep_well_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.JAKUB_TORCH_BEACON:
		is_activated = true
		if _audio_player and _jakub_torch_sound:
			_audio_player.stream = _jakub_torch_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_29_EXIT:
		is_activated = true
		if _audio_player and _door_release_29_sound:
			_audio_player.stream = _door_release_29_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.MAIN_POWER_DISTRIBUTION_BOARD:
		is_activated = true
		if _audio_player and _power_grid_relay_sound:
			_audio_player.stream = _power_grid_relay_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.HIGH_VOLTAGE_TRANSFORMER_BANK:
		is_activated = true
		if _audio_player and _transformer_oil_sound:
			_audio_player.stream = _transformer_oil_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SECTION_BREAKER_LEVER:
		is_activated = true
		if _audio_player and _knife_switch_sound:
			_audio_player.stream = _knife_switch_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.GRID_SCHEMATIC_DISPLAY:
		is_activated = true
		if _audio_player and _high_voltage_spark_sound:
			_audio_player.stream = _high_voltage_spark_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_30_EXIT:
		is_activated = true
		if _audio_player and _door_release_30_sound:
			_audio_player.stream = _door_release_30_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.ELEVEN_CHAIRS_ARCHIVE_ROW:
		is_activated = true
		if _audio_player and _eleven_chairs_sound:
			_audio_player.stream = _eleven_chairs_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.WIERZBICKA_REMOTE_HOLOTERMINAL:
		is_activated = true
		if _audio_player and _wierzbicka_recitation_sound:
			_audio_player.stream = _wierzbicka_recitation_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.JAKUB_TWELFTH_CHAIR:
		is_activated = true
		if _audio_player and _twelfth_chair_sound:
			_audio_player.stream = _twelfth_chair_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.VARIANT_CHOICE_LEDGER:
		is_activated = true
		if _audio_player and _variant_ledger_sound:
			_audio_player.stream = _variant_ledger_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_31_EXIT:
		is_activated = true
		if _audio_player and _door_release_31_sound:
			_audio_player.stream = _door_release_31_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STEAMED_GLASS_PANE_A:
		is_activated = true
		if _audio_player and _steamed_glass_sound:
			_audio_player.stream = _steamed_glass_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.CRACKED_GLASS_PANE_B:
		is_activated = true
		if _audio_player and _cracked_glass_sound:
			_audio_player.stream = _cracked_glass_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.POLISHED_GLASS_PANE_C:
		is_activated = true
		if _audio_player and _polished_glass_sound:
			_audio_player.stream = _polished_glass_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.CONDENSATION_TRACE_ETCHER:
		is_activated = true
		if _audio_player and _trace_etcher_sound:
			_audio_player.stream = _trace_etcher_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_32_EXIT:
		is_activated = true
		if _audio_player and _door_release_32_sound:
			_audio_player.stream = _door_release_32_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.VERTICAL_LADDER_ARRAY:
		is_activated = true
		if _audio_player and _ladder_climb_sound:
			_audio_player.stream = _ladder_climb_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.DEPTH_PRESSURE_GAUGE:
		is_activated = true
		if _audio_player and _depth_creak_sound:
			_audio_player.stream = _depth_creak_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.MEMORY_BUS_CABLE_TRUNK:
		is_activated = true
		if _audio_player and _cable_trunk_sound:
			_audio_player.stream = _cable_trunk_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SHAFT_WORK_LIGHT_BEACON:
		is_activated = true
		if _audio_player and _work_light_sound:
			_audio_player.stream = _work_light_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_33_EXIT:
		is_activated = true
		if _audio_player and _door_release_33_sound:
			_audio_player.stream = _door_release_33_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.MAIN_EXCHANGE_CORE_REACTOR:
		is_activated = true
		if _audio_player and _core_pulse_sound:
			_audio_player.stream = _core_pulse_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.BIOGRAPHY_ALLOCATION_DESK:
		is_activated = true
		if _audio_player and _slider_drag_sound:
			_audio_player.stream = _slider_drag_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.THERMAL_OVERLOAD_INDICATOR:
		is_activated = true
		if _audio_player and _thermal_alarm_sound:
			_audio_player.stream = _thermal_alarm_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.JAKUB_CORE_DIAGNOSTIC_PORT:
		is_activated = true
		if _audio_player and _jakub_probe_sound:
			_audio_player.stream = _jakub_probe_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_34_EXIT:
		is_activated = true
		if _audio_player and _door_release_34_sound:
			_audio_player.stream = _door_release_34_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SEDATION_BASIN_POOL:
		is_activated = true
		if _audio_player and _sedation_slosh_sound:
			_audio_player.stream = _sedation_slosh_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SLUDGE_DRAIN_VALVE_WHEEL:
		is_activated = true
		if _audio_player and _sludge_valve_sound:
			_audio_player.stream = _sludge_valve_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.CHEMICAL_SEDATION_SAMPLER:
		is_activated = true
		if _audio_player and _chemical_bubbler_sound:
			_audio_player.stream = _chemical_bubbler_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.JAKUB_SEDATION_MONITOR:
		is_activated = true
		if _audio_player and _sedation_alarm_sound:
			_audio_player.stream = _sedation_alarm_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_35_EXIT:
		is_activated = true
		if _audio_player and _door_release_35_sound:
			_audio_player.stream = _door_release_35_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STORM_DRAIN_WEIR:
		is_activated = true
		if _audio_player and _drain_weir_creak_sound:
			_audio_player.stream = _drain_weir_creak_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SEDATIVE_SLUDGE_CURRENT:
		is_activated = true
		if _audio_player and _storm_drain_torrent_sound:
			_audio_player.stream = _storm_drain_torrent_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.ACID_RESISTANT_CATWALK_LADDER:
		is_activated = true
		if _audio_player and _acid_ladder_clank_sound:
			_audio_player.stream = _acid_ladder_clank_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.CONTAMINATION_SAMPLING_TAP:
		is_activated = true
		if _audio_player and _groundwater_leak_alarm_sound:
			_audio_player.stream = _groundwater_leak_alarm_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_36_EXIT:
		is_activated = true
		if _audio_player and _door_release_36_sound:
			_audio_player.stream = _door_release_36_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SIGNAL_TRANSMISSION_ANTENNA:
		is_activated = true
		if _audio_player and _signal_antenna_sound:
			_audio_player.stream = _signal_antenna_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.TRANSMISSION_CROSS_PATCHBAY:
		is_activated = true
		if _audio_player and _cross_patchbay_sound:
			_audio_player.stream = _cross_patchbay_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.FREQUENCY_OSCILLOSCOPE_CRT:
		is_activated = true
		if _audio_player and _crt_sweep_sound:
			_audio_player.stream = _crt_sweep_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.MEMORY_INJECTION_PULPIT:
		is_activated = true
		if _audio_player and _memory_lever_sound:
			_audio_player.stream = _memory_lever_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_37_EXIT:
		is_activated = true
		if _audio_player and _door_release_37_sound:
			_audio_player.stream = _door_release_37_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.ACCIDENT_SIMULATION_FIELD:
		is_activated = true
		if _audio_player and _accident_field_sound:
			_audio_player.stream = _accident_field_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.DESTABILIZING_JAKUB_SHADOW:
		is_activated = true
		if _audio_player and _jakub_destabilize_sound:
			_audio_player.stream = _jakub_destabilize_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.RESCUE_TETHER_ANCHOR:
		is_activated = true
		if _audio_player and _rescue_tether_sound:
			_audio_player.stream = _rescue_tether_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.RETURN_COORDINATE_CALCULATOR:
		is_activated = true
		if _audio_player and _coordinate_calc_sound:
			_audio_player.stream = _coordinate_calc_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_38_EXIT:
		is_activated = true
		if _audio_player and _door_release_38_sound:
			_audio_player.stream = _door_release_38_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.CENTRAL_REFERENCE_CORE_MONOLITH:
		is_activated = true
		if _audio_player and _reference_core_sound:
			_audio_player.stream = _reference_core_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.BRANCH_CONFIG_RETURN_A:
		is_activated = true
		if _audio_player and _config_a_sound:
			_audio_player.stream = _config_a_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.BRANCH_CONFIG_RECONCILIATION_B:
		is_activated = true
		if _audio_player and _config_b_sound:
			_audio_player.stream = _config_b_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.BRANCH_CONFIG_TESTIMONY_C:
		is_activated = true
		if _audio_player and _config_c_sound:
			_audio_player.stream = _config_c_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_39_EXIT:
		is_activated = true
		if _audio_player and _act4_gateway_sound:
			_audio_player.stream = _act4_gateway_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.WIERZBICKA_PERSONAL_TERMINAL:
		is_activated = true
		if _audio_player and _wierzbicka_terminal_sound:
			_audio_player.stream = _wierzbicka_terminal_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.MARTA_WITNESS_STATION:
		is_activated = true
		if _audio_player and _marta_witness_sound:
			_audio_player.stream = _marta_witness_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SZYMON_TRANSMISSION_MONITOR:
		is_activated = true
		if _audio_player and _szymon_transmission_sound:
			_audio_player.stream = _szymon_transmission_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.OPERATION_COST_DOSSIER_MATRIX:
		is_activated = true
		if _audio_player and _cost_matrix_sound:
			_audio_player.stream = _cost_matrix_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_40_EXIT:
		is_activated = true
		if _audio_player and _gate_40_sound:
			_audio_player.stream = _gate_40_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.OP_CONSOLE_RETURN_A:
		is_activated = true
		if _audio_player and _op_return_sound:
			_audio_player.stream = _op_return_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.OP_CONSOLE_RECONCILIATION_B:
		is_activated = true
		if _audio_player and _op_reconciliation_sound:
			_audio_player.stream = _op_reconciliation_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.OP_CONSOLE_TESTIMONY_C:
		is_activated = true
		if _audio_player and _op_testimony_sound:
			_audio_player.stream = _op_testimony_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.OP_CONTINUITY_TOPOGRAPHY_DISPLAY:
		is_activated = true
		if _audio_player and _op_console_sound:
			_audio_player.stream = _op_console_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STATION_41_EXIT:
		is_activated = true
		if _audio_player and _gate_41_sound:
			_audio_player.stream = _gate_41_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.EPILOGUE_RETURN_CUPS:
		is_activated = true
		if _audio_player and _epilogue_cups_sound:
			_audio_player.stream = _epilogue_cups_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.EPILOGUE_MARTA_DOORSTEP:
		is_activated = true
		if _audio_player and _marta_witness_sound:
			_audio_player.stream = _marta_witness_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.EPILOGUE_TRAM_DUAL_TRACKS:
		is_activated = true
		if _audio_player and _epilogue_switch_latch_sound:
			_audio_player.stream = _epilogue_switch_latch_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.EPILOGUE_ADMIN_NOTICE_BOARD:
		is_activated = true
		if _audio_player and _epilogue_radio_sound:
			_audio_player.stream = _epilogue_radio_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.EPILOGUE_CREDITS_ROLL:
		is_activated = true
		if _audio_player and _epilogue_credits_sound:
			_audio_player.stream = _epilogue_credits_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.EPILOGUE_FINAL_BLACKOUT:
		is_activated = true
		if _audio_player and _epilogue_blackout_sound:
			_audio_player.stream = _epilogue_blackout_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	else:
		is_activated = true
		if _audio_player and _memory_sound:
			_audio_player.stream = _memory_sound
			_audio_player.pitch_scale = 1.0 + randf_range(-0.02, 0.02)
			_audio_player.play()
	
	resonance_triggered.emit(resonance_id, int(prop_type))
	if is_activated:
		_resonance_flash = 1.0
		if _particles:
			_particles.restart()
			_particles.emitting = true
	queue_redraw()


func _draw() -> void:
	_draw_contact_read()
	match prop_type:
		PropType.PHOTOGRAPH:
			_draw_photograph()
		PropType.CIRCUIT_BREAKER:
			_draw_circuit_breaker()
		PropType.VACUUM_GAUGE:
			_draw_vacuum_gauge()
		PropType.CHAMBER_CONSOLE:
			_draw_chamber_console()
		PropType.DOCUMENT_CLIPBOARD:
			_draw_document_clipboard()
		PropType.DOOR_CARD_READER:
			_draw_door_card_reader()
		PropType.TWIN_CUPS:
			_draw_twin_cups()
		PropType.DESK_TELEPHONE:
			_draw_desk_telephone()
		PropType.DUTY_ROSTER:
			_draw_duty_roster()
		PropType.SECURITY_MONITOR:
			_draw_security_monitor()
		PropType.UCP_NOTICE:
			_draw_ucp_notice()
		PropType.GUARD_INTERACTION:
			_draw_guard_interaction()
		PropType.ANACHRONISTIC_BILLBOARD:
			_draw_anachronistic_billboard()
		PropType.MISSING_FLOOR_FACADE:
			_draw_missing_floor_facade()
		PropType.CROSSWALK_SIGNAL:
			_draw_crosswalk_signal()
		PropType.TRANSIT_SHELTER:
			_draw_transit_shelter()
		PropType.BUS_SPEAKER:
			_draw_bus_speaker()
		PropType.ELDERLY_PASSENGER:
			_draw_elderly_passenger()
		PropType.GOLD_RING:
			_draw_gold_ring()
		PropType.BUS_ROUTE_MAP:
			_draw_bus_route_map()
		PropType.TENANT_DIRECTORY:
			_draw_tenant_directory()
		PropType.MAILBOXES:
			_draw_mailboxes()
		PropType.BLIND_STAIRS:
			_draw_blind_stairs()
		PropType.MARTA_INTERACTION:
			_draw_marta_interaction()
		PropType.STAIR_TIMER_SWITCH:
			_draw_stair_timer_switch()
		PropType.HALLWAY_COAT_RACK:
			_draw_hallway_coat_rack()
		PropType.REFLECTED_PHOTOGRAPH:
			_draw_reflected_photograph()
		PropType.BEAKER_PLANTER:
			_draw_beaker_planter()
		PropType.JAKUB_MEMENTO_TOOL:
			_draw_jakub_memento_tool()
		PropType.CIPHER_DESK:
			_draw_cipher_desk()
		PropType.TEA_KETTLE:
			_draw_tea_kettle()
		PropType.BATHROOM_SINK:
			_draw_bathroom_sink()
		PropType.BATHROOM_MIRROR:
			_draw_bathroom_mirror()
		PropType.SCRATCHED_INSCRIPTION:
			_draw_scratched_inscription()
		PropType.APOTHECARY_CABINET:
			_draw_apothecary_cabinet()
		PropType.MARTA_BATHROOM_GUIDE:
			_draw_marta_bathroom_guide()
		PropType.BAKELITE_PHONE:
			_draw_bakelite_phone()
		PropType.REEL_TAPE_RECORDER:
			_draw_reel_tape_recorder()
		PropType.TOPOGRAPHY_BOARD:
			_draw_topography_board()
		PropType.JAKUB_DESK_LAMP:
			_draw_jakub_desk_lamp()
		PropType.TECH_STORAGE_AIRLOCK:
			_draw_tech_storage_airlock()
		PropType.OBSERVATION_WINDOW:
			_draw_observation_window()
		PropType.ERASED_DOORWAY_TRACE:
			_draw_erased_doorway_trace()
		PropType.UCP_INTERVENTION_TEAM:
			_draw_ucp_intervention_team()
		PropType.ELDERLY_RESIDENT_GUIDE:
			_draw_elderly_resident_guide()
		PropType.MARTA_OBSERVATION_DIALOGUE:
			_draw_marta_observation_dialogue()
		PropType.COURTYARD_EXIT_AIRLOCK:
			_draw_courtyard_exit_airlock()
		PropType.UCP_INFO_TERMINAL:
			_draw_ucp_info_terminal()
		PropType.SHOWCASE_VITRINE:
			_draw_showcase_vitrine()
		PropType.INSTRUCTION_POSTER:
			_draw_instruction_poster()
		PropType.SUBWAY_TILE_PILLAR:
			_draw_subway_tile_pillar()
		PropType.UNDERPASS_EXIT_GATE:
			_draw_underpass_exit_gate()
		PropType.DRAFTING_TABLE:
			_draw_drafting_table()
		PropType.TOPOGRAPHY_INDEX_CABINET:
			_draw_topography_index_cabinet()
		PropType.JAKUB_PHOTOGRAPH_FRAME:
			_draw_jakub_photograph_frame()
		PropType.RESONANCE_CIRCUIT_NODE:
			_draw_resonance_circuit_node()
		PropType.TECH_PASSAGE_AIRLOCK:
			_draw_tech_passage_airlock()
		PropType.METAL_SCRATCH_BEAM:
			_draw_metal_scratch_beam()
		PropType.TAPE_PLAYBACK_DECK:
			_draw_tape_playback_deck()
		PropType.MAINTENANCE_RACK:
			_draw_maintenance_rack()
		PropType.SEAM_STABILIZER_LEVER:
			_draw_seam_stabilizer_lever()
		PropType.SUBSTRUCTURE_CONDUIT_SHAFT:
			_draw_substructure_conduit_shaft()
		PropType.HYGIENE_INSTRUCTION_BOARD:
			_draw_hygiene_instruction_board()
		PropType.HANDWRITTEN_CORRELATION_FORMULA:
			_draw_handwritten_correlation_formula()
		PropType.REFLECTIVE_PUDDLE:
			_draw_reflective_puddle()
		PropType.PRESSURE_RELIEF_VALVE:
			_draw_pressure_relief_valve()
		PropType.TRANSIT_SERVICE_GATE:
			_draw_transit_service_gate()
		PropType.CRACKED_TEA_CUP:
			_draw_cracked_tea_cup()
		PropType.CORRELATION_DOSSIER:
			_draw_correlation_dossier()
		PropType.KITCHEN_CLOCK:
			_draw_kitchen_clock()
		PropType.WEDDING_RING_STAND:
			_draw_wedding_ring_stand()
		PropType.BALCONY_EXIT_DOOR:
			_draw_balcony_exit_door()
		PropType.QUEUING_TICKET_DISPENSER:
			_draw_queuing_ticket_dispenser()
		PropType.COMPLIANCE_WAITING_BENCH:
			_draw_compliance_waiting_bench()
		PropType.PNEUMATIC_DOSSIER_STATION:
			_draw_pneumatic_dossier_station()
		PropType.DIAGNOSTIC_MEMORY_PRINTER:
			_draw_diagnostic_memory_printer()
		PropType.CONSULTATION_OFFICE_DOOR:
			_draw_consultation_office_door()
		PropType.WIERZBICKA_DESK:
			_draw_wierzbicka_desk()
		PropType.SENSORY_MEMORY_MAP:
			_draw_sensory_memory_map()
		PropType.CORRECTION_GALVANOMETER:
			_draw_correction_galvanometer()
		PropType.ACOUSTIC_WEIGHT_CONDUIT:
			_draw_acoustic_weight_conduit()
		PropType.MODEL_ROOM_AIRLOCK:
			_draw_model_room_airlock()
		PropType.MODEL_DISPLAY_TABLE:
			_draw_model_display_table()
		PropType.STAIRCASE_MAP_LEFT:
			_draw_staircase_map_left()
		PropType.STAIRCASE_MAP_RIGHT:
			_draw_staircase_map_right()
		PropType.ELEVEN_PERSONS_LEDGER:
			_draw_eleven_persons_ledger()
		PropType.MODEL_ROOM_EXIT:
			_draw_model_room_exit()
		PropType.SZYMON_BERA:
			_draw_szymon_bera()
		PropType.WELL_DRAWING:
			_draw_well_drawing()
		PropType.HYDROLOGY_REPORT:
			_draw_hydrology_report()
		PropType.ERASED_SIGNATURE_MAGNIFIER:
			_draw_erased_signature_magnifier()
		PropType.SZYMON_ROOM_EXIT:
			_draw_szymon_room_exit()
		PropType.SZYMON_POST_CORRECTION:
			_draw_szymon_post_correction()
		PropType.ANESTHESIA_TERMINAL:
			_draw_anesthesia_terminal()
		PropType.FILTERED_DOSSIER_SLOT:
			_draw_filtered_dossier_slot()
		PropType.DRAWING_DISPOSITION_PEDESTAL:
			_draw_drawing_disposition_pedestal()
		PropType.STATION_21_EXIT:
			_draw_station_21_exit()
		PropType.BIOMETRIC_IDENTITY_GATE:
			_draw_biometric_identity_gate()
		PropType.COMPLIANCE_CONTACT_REGISTER:
			_draw_compliance_contact_register()
		PropType.RING_FITTING_SCANNER:
			_draw_ring_fitting_scanner()
		PropType.PAINT_RESIN_RESONANCE_SLAB:
			_draw_paint_resin_resonance_slab()
		PropType.STATION_22_EXIT:
			_draw_station_22_exit()
		PropType.DESIGNER_TERMINAL:
			_draw_designer_terminal()
		PropType.SUBSTRUCTURE_ARCHITECTURAL_MODEL:
			_draw_substructure_architectural_model()
		PropType.BURDENED_PERSONS_LEDGER:
			_draw_burdened_persons_ledger()
		PropType.SHADOW_INTERACTIVE_CONSOLE:
			_draw_shadow_interactive_console()
		PropType.STATION_23_EXIT:
			_draw_station_23_exit()
		PropType.CCTV_SURVEILLANCE_ARRAY:
			_draw_cctv_surveillance_array()
		PropType.CORRECTION_ACCUMULATION_GAUGE:
			_draw_correction_accumulation_gauge()
		PropType.WIERZBICKA_TRANSMISSION_TERMINAL:
			_draw_wierzbicka_transmission_terminal()
		PropType.LENA_DISPOSITION_SELECTOR:
			_draw_lena_disposition_selector()
		PropType.STATION_24_EXIT:
			_draw_station_24_exit()
		PropType.JAKUB_OPERATOR_UCP:
			_draw_jakub_operator_ucp()
		PropType.TRANSIT_MAINTENANCE_CART:
			_draw_transit_maintenance_cart()
		PropType.SCAR_DIAGNOSTIC_CHART:
			_draw_scar_diagnostic_chart()
		PropType.JAKUB_HAND_GESTURE_SENSOR:
			_draw_jakub_hand_gesture_sensor()
		PropType.STATION_25_EXIT:
			_draw_station_25_exit()
		PropType.ISOLATION_ZONE_CONSOLE:
			_draw_isolation_zone_console()
		PropType.DYNAMIC_ROOM_DESIGNATOR:
			_draw_dynamic_room_designator()
		PropType.MOTIVATION_ANCHOR_RECORD:
			_draw_motivation_anchor_record()
		PropType.WIERZBICKA_PA_SPEAKER:
			_draw_wierzbicka_pa_speaker()
		PropType.STATION_26_EXIT:
			_draw_station_26_exit()
		PropType.JAKUB_SERVICE_OPERATOR:
			_draw_jakub_service_operator()
		PropType.SAVED_WORKER_BADGE:
			_draw_saved_worker_badge()
		PropType.SURFACE_STABILITY_MONITOR:
			_draw_surface_stability_monitor()
		PropType.TECHNICAL_JUNCTION_CONSOLE:
			_draw_technical_junction_console()
		PropType.STATION_27_EXIT:
			_draw_station_27_exit()
		PropType.TRAM_DRIVER_CONSOLE:
			_draw_tram_driver_console()
		PropType.PANORAMIC_TRANSIT_WINDOW:
			_draw_panoramic_transit_window()
		PropType.TRIPLE_ACCIDENT_PARADOX_VIEW:
			_draw_triple_accident_paradox_view()
		PropType.WIERZBICKA_CLOSING_INTERCOM:
			_draw_wierzbicka_closing_intercom()
		PropType.STATION_28_EXIT:
			_draw_station_28_exit()
		PropType.ABANDONED_PLATFORM_TRACKS:
			_draw_abandoned_platform_tracks()
		PropType.FLICKERING_NEON_SIGN:
			_draw_flickering_neon_sign()
		PropType.DEEP_SUBSTRUCTURE_WELL:
			_draw_deep_substructure_well()
		PropType.JAKUB_TORCH_BEACON:
			_draw_jakub_torch_beacon()
		PropType.STATION_29_EXIT:
			_draw_station_29_exit()
		PropType.MAIN_POWER_DISTRIBUTION_BOARD:
			_draw_main_power_distribution_board()
		PropType.HIGH_VOLTAGE_TRANSFORMER_BANK:
			_draw_high_voltage_transformer_bank()
		PropType.SECTION_BREAKER_LEVER:
			_draw_section_breaker_lever()
		PropType.GRID_SCHEMATIC_DISPLAY:
			_draw_grid_schematic_display()
		PropType.STATION_30_EXIT:
			_draw_station_30_exit()
		PropType.ELEVEN_CHAIRS_ARCHIVE_ROW:
			_draw_eleven_chairs_archive_row()
		PropType.WIERZBICKA_REMOTE_HOLOTERMINAL:
			_draw_wierzbicka_remote_holoterminal()
		PropType.JAKUB_TWELFTH_CHAIR:
			_draw_jakub_twelfth_chair()
		PropType.VARIANT_CHOICE_LEDGER:
			_draw_variant_choice_ledger()
		PropType.STATION_31_EXIT:
			_draw_station_31_exit()
		PropType.STEAMED_GLASS_PANE_A:
			_draw_steamed_glass_pane_a()
		PropType.CRACKED_GLASS_PANE_B:
			_draw_cracked_glass_pane_b()
		PropType.POLISHED_GLASS_PANE_C:
			_draw_polished_glass_pane_c()
		PropType.CONDENSATION_TRACE_ETCHER:
			_draw_condensation_trace_etcher()
		PropType.STATION_32_EXIT:
			_draw_station_32_exit()
		PropType.VERTICAL_LADDER_ARRAY:
			_draw_vertical_ladder_array()
		PropType.DEPTH_PRESSURE_GAUGE:
			_draw_depth_pressure_gauge()
		PropType.MEMORY_BUS_CABLE_TRUNK:
			_draw_memory_bus_cable_trunk()
		PropType.SHAFT_WORK_LIGHT_BEACON:
			_draw_shaft_work_light_beacon()
		PropType.STATION_33_EXIT:
			_draw_station_33_exit()
		PropType.MAIN_EXCHANGE_CORE_REACTOR:
			_draw_main_exchange_core_reactor()
		PropType.BIOGRAPHY_ALLOCATION_DESK:
			_draw_biography_allocation_desk()
		PropType.THERMAL_OVERLOAD_INDICATOR:
			_draw_thermal_overload_indicator()
		PropType.JAKUB_CORE_DIAGNOSTIC_PORT:
			_draw_jakub_core_diagnostic_port()
		PropType.STATION_34_EXIT:
			_draw_station_34_exit()
		PropType.SEDATION_BASIN_POOL:
			_draw_sedation_basin_pool()
		PropType.SLUDGE_DRAIN_VALVE_WHEEL:
			_draw_sludge_drain_valve_wheel()
		PropType.CHEMICAL_SEDATION_SAMPLER:
			_draw_chemical_sedation_sampler()
		PropType.JAKUB_SEDATION_MONITOR:
			_draw_jakub_sedation_monitor()
		PropType.STATION_35_EXIT:
			_draw_station_35_exit()
		PropType.STORM_DRAIN_WEIR:
			_draw_storm_drain_weir()
		PropType.SEDATIVE_SLUDGE_CURRENT:
			_draw_sedative_sludge_current()
		PropType.ACID_RESISTANT_CATWALK_LADDER:
			_draw_acid_resistant_catwalk_ladder()
		PropType.CONTAMINATION_SAMPLING_TAP:
			_draw_contamination_sampling_tap()
		PropType.STATION_36_EXIT:
			_draw_station_36_exit()
		PropType.SIGNAL_TRANSMISSION_ANTENNA:
			_draw_signal_transmission_antenna()
		PropType.TRANSMISSION_CROSS_PATCHBAY:
			_draw_transmission_cross_patchbay()
		PropType.FREQUENCY_OSCILLOSCOPE_CRT:
			_draw_frequency_oscilloscope_crt()
		PropType.MEMORY_INJECTION_PULPIT:
			_draw_memory_injection_pulpit()
		PropType.STATION_37_EXIT:
			_draw_station_37_exit()
		PropType.ACCIDENT_SIMULATION_FIELD:
			_draw_accident_simulation_field()
		PropType.DESTABILIZING_JAKUB_SHADOW:
			_draw_destabilizing_jakub_shadow()
		PropType.RESCUE_TETHER_ANCHOR:
			_draw_rescue_tether_anchor()
		PropType.RETURN_COORDINATE_CALCULATOR:
			_draw_return_coordinate_calculator()
		PropType.STATION_38_EXIT:
			_draw_station_38_exit()
		PropType.CENTRAL_REFERENCE_CORE_MONOLITH:
			_draw_central_reference_core_monolith()
		PropType.BRANCH_CONFIG_RETURN_A:
			_draw_branch_config_return_a()
		PropType.BRANCH_CONFIG_RECONCILIATION_B:
			_draw_branch_config_reconciliation_b()
		PropType.BRANCH_CONFIG_TESTIMONY_C:
			_draw_branch_config_testimony_c()
		PropType.STATION_39_EXIT:
			_draw_station_39_exit()
		PropType.WIERZBICKA_PERSONAL_TERMINAL:
			_draw_wierzbicka_personal_terminal()
		PropType.MARTA_WITNESS_STATION:
			_draw_marta_witness_station()
		PropType.SZYMON_TRANSMISSION_MONITOR:
			_draw_szymon_transmission_monitor()
		PropType.OPERATION_COST_DOSSIER_MATRIX:
			_draw_operation_cost_dossier_matrix()
		PropType.STATION_40_EXIT:
			_draw_station_40_exit()
		PropType.OP_CONSOLE_RETURN_A:
			_draw_op_console_return_a()
		PropType.OP_CONSOLE_RECONCILIATION_B:
			_draw_op_console_reconciliation_b()
		PropType.OP_CONSOLE_TESTIMONY_C:
			_draw_op_console_testimony_c()
		PropType.OP_CONTINUITY_TOPOGRAPHY_DISPLAY:
			_draw_op_continuity_topography_display()
		PropType.STATION_41_EXIT:
			_draw_station_41_exit()
		PropType.EPILOGUE_RETURN_CUPS:
			_draw_epilogue_return_cups()
		PropType.EPILOGUE_MARTA_DOORSTEP:
			_draw_epilogue_marta_doorstep()
		PropType.EPILOGUE_TRAM_DUAL_TRACKS:
			_draw_epilogue_tram_dual_tracks()
		PropType.EPILOGUE_ADMIN_NOTICE_BOARD:
			_draw_epilogue_admin_notice_board()
		PropType.EPILOGUE_CREDITS_ROLL:
			_draw_epilogue_credits_roll()
		PropType.EPILOGUE_FINAL_BLACKOUT:
			_draw_epilogue_final_blackout()
	
	if is_activated:
		_draw_resolved_mark()
	elif is_player_in_range or _resonance_flash > 0.0:
		_draw_in_world_reticule()




func _draw_photograph() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 0).
	MrpLegacyRenderer.draw_photograph(self, is_activated)


func _draw_circuit_breaker() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 1).
	MrpLegacyRenderer.draw_circuit_breaker(self, is_activated)


func _draw_vacuum_gauge() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 2).
	MrpLegacyRenderer.draw_vacuum_gauge(self, is_activated)


func _draw_chamber_console() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 3).
	MrpLegacyRenderer.draw_chamber_console(self, is_activated)


func _draw_document_clipboard() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 4).
	MrpLegacyRenderer.draw_document_clipboard(self, is_activated)


func _draw_door_card_reader() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 5).
	MrpLegacyRenderer.draw_door_card_reader(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_twin_cups() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 6).
	MrpLegacyRenderer.draw_twin_cups(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_desk_telephone() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 7).
	MrpLegacyRenderer.draw_desk_telephone(self, _pulse_phase)


func _draw_duty_roster() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 8).
	MrpLegacyRenderer.draw_duty_roster(self)


func _draw_security_monitor() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 9).
	MrpLegacyRenderer.draw_security_monitor(self, _pulse_phase)


func _draw_ucp_notice() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 10).
	MrpLegacyRenderer.draw_ucp_notice(self)


func _draw_guard_interaction() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 11).
	MrpLegacyRenderer.draw_guard_interaction(self, is_activated)


func _draw_anachronistic_billboard() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 12).
	MrpLegacyRenderer.draw_anachronistic_billboard(self, is_activated)


func _draw_missing_floor_facade() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 13).
	MrpLegacyRenderer.draw_missing_floor_facade(self, is_activated)


func _draw_crosswalk_signal() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 14).
	MrpLegacyRenderer.draw_crosswalk_signal(self, is_activated)


func _draw_transit_shelter() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 15).
	MrpLegacyRenderer.draw_transit_shelter(self, is_activated)


func _draw_bus_speaker() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 16).
	MrpLegacyRenderer.draw_bus_speaker(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_elderly_passenger() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 17).
	MrpLegacyRenderer.draw_elderly_passenger(self)


func _draw_gold_ring() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 18).
	MrpLegacyRenderer.draw_gold_ring(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_bus_route_map() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 19).
	MrpLegacyRenderer.draw_bus_route_map(self, _pulse_phase)


func _draw_tenant_directory() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 20).
	MrpLegacyRenderer.draw_tenant_directory(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_mailboxes() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 21).
	MrpLegacyRenderer.draw_mailboxes(self, _pulse_phase)


func _draw_blind_stairs() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 22).
	MrpLegacyRenderer.draw_blind_stairs(self, is_activated, _pulse_phase)


func _draw_marta_interaction() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 23).
	MrpLegacyRenderer.draw_marta_interaction(self, _pulse_phase)


func _draw_stair_timer_switch() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 24).
	MrpLegacyRenderer.draw_stair_timer_switch(self, _pulse_phase)


func _draw_hallway_coat_rack() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 25).
	MrpLegacyRenderer.draw_hallway_coat_rack(self)


func _draw_reflected_photograph() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 26).
	MrpLegacyRenderer.draw_reflected_photograph(self)


func _draw_beaker_planter() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 27).
	MrpLegacyRenderer.draw_beaker_planter(self)


func _draw_jakub_memento_tool() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 28).
	MrpLegacyRenderer.draw_jakub_memento_tool(self)


func _draw_cipher_desk() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 29).
	MrpLegacyRenderer.draw_cipher_desk(self, is_activated, _pulse_phase)


func _draw_tea_kettle() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 30).
	MrpLegacyRenderer.draw_tea_kettle(self, _pulse_phase)


func _draw_bathroom_sink() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 31).
	MrpLegacyRenderer.draw_bathroom_sink(self, _pulse_phase)


func _draw_bathroom_mirror() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 32).
	MrpLegacyRenderer.draw_bathroom_mirror(self, _pulse_phase)


func _draw_scratched_inscription() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 33).
	MrpLegacyRenderer.draw_scratched_inscription(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_apothecary_cabinet() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 34).
	MrpLegacyRenderer.draw_apothecary_cabinet(self)


func _draw_marta_bathroom_guide() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 35).
	MrpLegacyRenderer.draw_marta_bathroom_guide(self, _pulse_phase)


func _draw_bakelite_phone() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 36).
	MrpLegacyRenderer.draw_bakelite_phone(self, is_activated, _pulse_phase)


func _draw_reel_tape_recorder() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 37).
	MrpLegacyRenderer.draw_reel_tape_recorder(self, is_activated, _pulse_phase)


func _draw_topography_board() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 38).
	MrpLegacyRenderer.draw_topography_board(self)


func _draw_jakub_desk_lamp() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 39).
	MrpLegacyRenderer.draw_jakub_desk_lamp(self, is_activated, _pulse_phase)


func _draw_tech_storage_airlock() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 40).
	MrpLegacyRenderer.draw_tech_storage_airlock(self, is_activated, _pulse_phase)


func _draw_observation_window() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 41).
	MrpLegacyRenderer.draw_observation_window(self)


func _draw_erased_doorway_trace() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 42).
	MrpLegacyRenderer.draw_erased_doorway_trace(self, is_activated, _pulse_phase)


func _draw_ucp_intervention_team() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 43).
	MrpLegacyRenderer.draw_ucp_intervention_team(self, is_activated, _pulse_phase)


func _draw_elderly_resident_guide() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 44).
	MrpLegacyRenderer.draw_elderly_resident_guide(self)


func _draw_marta_observation_dialogue() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 45).
	MrpLegacyRenderer.draw_marta_observation_dialogue(self)


func _draw_courtyard_exit_airlock() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 46).
	MrpLegacyRenderer.draw_courtyard_exit_airlock(self, is_activated, _pulse_phase)


func _draw_ucp_info_terminal() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 47).
	MrpLegacyRenderer.draw_ucp_info_terminal(self, is_activated, _pulse_phase)


func _draw_showcase_vitrine() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 48).
	MrpLegacyRenderer.draw_showcase_vitrine(self)


func _draw_instruction_poster() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 49).
	MrpLegacyRenderer.draw_instruction_poster(self)


func _draw_subway_tile_pillar() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 50).
	MrpLegacyRenderer.draw_subway_tile_pillar(self)


func _draw_underpass_exit_gate() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 51).
	MrpLegacyRenderer.draw_underpass_exit_gate(self, is_activated, _pulse_phase)


func _draw_drafting_table() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 52).
	MrpLegacyRenderer.draw_drafting_table(self, _pulse_phase)


func _draw_topography_index_cabinet() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 53).
	MrpLegacyRenderer.draw_topography_index_cabinet(self)


func _draw_jakub_photograph_frame() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 54).
	MrpLegacyRenderer.draw_jakub_photograph_frame(self, is_activated, _pulse_phase, shadow_progress)


func _draw_resonance_circuit_node() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 55).
	MrpLegacyRenderer.draw_resonance_circuit_node(self, is_activated, _pulse_phase)


func _draw_tech_passage_airlock() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 56).
	MrpLegacyRenderer.draw_tech_passage_airlock(self, is_activated, _pulse_phase)


func _draw_metal_scratch_beam() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 57).
	MrpLegacyRenderer.draw_metal_scratch_beam(self, is_activated, shadow_progress)


func _draw_tape_playback_deck() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 58).
	MrpLegacyRenderer.draw_tape_playback_deck(self, is_activated, _pulse_phase)


func _draw_maintenance_rack() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 59).
	MrpLegacyRenderer.draw_maintenance_rack(self)


func _draw_seam_stabilizer_lever() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 60).
	MrpLegacyRenderer.draw_seam_stabilizer_lever(self, is_activated, _pulse_phase)


func _draw_substructure_conduit_shaft() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 61).
	MrpLegacyRenderer.draw_substructure_conduit_shaft(self, is_activated, _pulse_phase)


func _draw_hygiene_instruction_board() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 62).
	MrpLegacyRenderer.draw_hygiene_instruction_board(self)


func _draw_handwritten_correlation_formula() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 63).
	MrpLegacyRenderer.draw_handwritten_correlation_formula(self, is_activated, _resonance_flash)


func _draw_reflective_puddle() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 64).
	MrpLegacyRenderer.draw_reflective_puddle(self, is_activated, _pulse_phase)


func _draw_pressure_relief_valve() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 65).
	MrpLegacyRenderer.draw_pressure_relief_valve(self, is_activated, _pulse_phase)


func _draw_transit_service_gate() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 66).
	MrpLegacyRenderer.draw_transit_service_gate(self, is_activated, _pulse_phase)


func _draw_in_world_reticule() -> void:
	var pulse := sin(_pulse_phase) * 0.5 + 0.5
	var alpha := clampf((0.35 + pulse * 0.4) if is_player_in_range else 0.0 + _resonance_flash * 0.6, 0.0, 1.0)
	var glow_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, alpha * 0.35)
	var ring_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, alpha * 0.85)
	
	# Soft warm filament glow disc
	draw_circle(Vector2.ZERO, 16.0 + pulse * 3.0, glow_col)
	
	# Corner reticule brackets indicating focus / measurement point
	var s: float = 14.0 + pulse * 1.5
	var l: float = 3.5
	# Top-Left
	draw_line(Vector2(-s, -s), Vector2(-s + l, -s), ring_col, 1.0)
	draw_line(Vector2(-s, -s), Vector2(-s, -s + l), ring_col, 1.0)
	# Top-Right
	draw_line(Vector2(s, -s), Vector2(s - l, -s), ring_col, 1.0)
	draw_line(Vector2(s, -s), Vector2(s, -s + l), ring_col, 1.0)
	# Bottom-Left
	draw_line(Vector2(-s, s), Vector2(-s + l, s), ring_col, 1.0)
	draw_line(Vector2(-s, s), Vector2(-s, s - l), ring_col, 1.0)
	# Bottom-Right
	draw_line(Vector2(s, s), Vector2(s - l, s), ring_col, 1.0)
	draw_line(Vector2(s, s), Vector2(s, s - l), ring_col, 1.0)
	
	# Minimal filament indicator dot above prop when in range
	if is_player_in_range:
		var dot_y := -s - 5.0 - pulse * 1.5
		draw_circle(Vector2(0.0, dot_y), 1.6, COLOR_AMBER)


func _draw_resolved_mark() -> void:
	var col := Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.95)
	draw_line(Vector2(-4.0, 2.0), Vector2(-1.0, 5.0), col, 1.5)
	draw_line(Vector2(-1.0, 5.0), Vector2(6.0, -4.0), col, 1.5)


func _draw_cracked_tea_cup() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 67).
	MrpLegacyRenderer.draw_cracked_tea_cup(self, _pulse_phase)


func _draw_correlation_dossier() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 68).
	MrpLegacyRenderer.draw_correlation_dossier(self, is_activated)


func _draw_kitchen_clock() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 69).
	MrpLegacyRenderer.draw_kitchen_clock(self, _pulse_phase)


func _draw_wedding_ring_stand() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 70).
	MrpLegacyRenderer.draw_wedding_ring_stand(self, _pulse_phase)


func _draw_balcony_exit_door() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 71).
	MrpLegacyRenderer.draw_balcony_exit_door(self, is_activated, _pulse_phase)


func _draw_queuing_ticket_dispenser() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 72).
	MrpLegacyRenderer.draw_queuing_ticket_dispenser(self, is_activated)


func _draw_compliance_waiting_bench() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 73).
	MrpLegacyRenderer.draw_compliance_waiting_bench(self, is_activated)


func _draw_pneumatic_dossier_station() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 74).
	MrpLegacyRenderer.draw_pneumatic_dossier_station(self, is_activated, _pulse_phase)


func _draw_diagnostic_memory_printer() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 75).
	MrpLegacyRenderer.draw_diagnostic_memory_printer(self, is_activated, _pulse_phase)


func _draw_consultation_office_door() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 76).
	MrpLegacyRenderer.draw_consultation_office_door(self, is_activated)


func _draw_wierzbicka_desk() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 77).
	MrpLegacyRenderer.draw_wierzbicka_desk(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_sensory_memory_map() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 78).
	MrpLegacyRenderer.draw_sensory_memory_map(self, is_activated, _pulse_phase)


func _draw_correction_galvanometer() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 79).
	MrpLegacyRenderer.draw_correction_galvanometer(self, is_activated, _pulse_phase)


func _draw_acoustic_weight_conduit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 80).
	MrpLegacyRenderer.draw_acoustic_weight_conduit(self, is_activated, _pulse_phase)


func _draw_model_room_airlock() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 81).
	MrpLegacyRenderer.draw_model_room_airlock(self, is_activated, _pulse_phase)


func _draw_model_display_table() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 82).
	MrpLegacyRenderer.draw_model_display_table(self, is_activated, _pulse_phase)


func _draw_staircase_map_left() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 83).
	MrpLegacyRenderer.draw_staircase_map_left(self, is_activated, _pulse_phase)


func _draw_staircase_map_right() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 84).
	MrpLegacyRenderer.draw_staircase_map_right(self, is_activated, _pulse_phase)


func _draw_eleven_persons_ledger() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 85).
	MrpLegacyRenderer.draw_eleven_persons_ledger(self, is_activated, _pulse_phase)


func _draw_model_room_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 86).
	MrpLegacyRenderer.draw_model_room_exit(self, is_activated, _pulse_phase)


func _draw_szymon_bera() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 87).
	MrpLegacyRenderer.draw_szymon_bera(self, is_activated, _pulse_phase)


func _draw_well_drawing() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 88).
	MrpLegacyRenderer.draw_well_drawing(self, is_activated, _pulse_phase)


func _draw_hydrology_report() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 89).
	MrpLegacyRenderer.draw_hydrology_report(self, is_activated, _pulse_phase)


func _draw_erased_signature_magnifier() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 90).
	MrpLegacyRenderer.draw_erased_signature_magnifier(self, is_activated, _pulse_phase)


func _draw_szymon_room_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 91).
	MrpLegacyRenderer.draw_szymon_room_exit(self, is_activated, _pulse_phase)


func _draw_szymon_post_correction() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 92).
	MrpLegacyRenderer.draw_szymon_post_correction(self, is_activated, _pulse_phase)


func _draw_anesthesia_terminal() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 93).
	MrpLegacyRenderer.draw_anesthesia_terminal(self, is_activated, _pulse_phase)


func _draw_filtered_dossier_slot() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 94).
	MrpLegacyRenderer.draw_filtered_dossier_slot(self, is_activated, _pulse_phase)


func _draw_drawing_disposition_pedestal() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 95).
	MrpLegacyRenderer.draw_drawing_disposition_pedestal(self, is_activated, _pulse_phase)


func _draw_station_21_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 96).
	MrpLegacyRenderer.draw_station_21_exit(self, is_activated, _pulse_phase)


func _draw_biometric_identity_gate() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 97).
	MrpLegacyRenderer.draw_biometric_identity_gate(self, is_activated, _pulse_phase)


func _draw_compliance_contact_register() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 98).
	MrpLegacyRenderer.draw_compliance_contact_register(self, is_activated, _pulse_phase)


func _draw_ring_fitting_scanner() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 99).
	MrpLegacyRenderer.draw_ring_fitting_scanner(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_paint_resin_resonance_slab() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 100).
	MrpLegacyRenderer.draw_paint_resin_resonance_slab(self, is_activated, _pulse_phase)


func _draw_station_22_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 101).
	MrpLegacyRenderer.draw_station_22_exit(self, is_activated, _pulse_phase)


func _draw_designer_terminal() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 102).
	MrpLegacyRenderer.draw_designer_terminal(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_substructure_architectural_model() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 103).
	MrpLegacyRenderer.draw_substructure_architectural_model(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_burdened_persons_ledger() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 104).
	MrpLegacyRenderer.draw_burdened_persons_ledger(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_shadow_interactive_console() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 105).
	MrpLegacyRenderer.draw_shadow_interactive_console(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_station_23_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 106).
	MrpLegacyRenderer.draw_station_23_exit(self, is_activated, _pulse_phase)


func _draw_cctv_surveillance_array() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 107).
	MrpLegacyRenderer.draw_cctv_surveillance_array(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_correction_accumulation_gauge() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 108).
	MrpLegacyRenderer.draw_correction_accumulation_gauge(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_wierzbicka_transmission_terminal() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 109).
	MrpLegacyRenderer.draw_wierzbicka_transmission_terminal(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_lena_disposition_selector() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 110).
	MrpLegacyRenderer.draw_lena_disposition_selector(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_station_24_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 111).
	MrpLegacyRenderer.draw_station_24_exit(self, is_activated, _pulse_phase)


func _draw_jakub_operator_ucp() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 112).
	MrpLegacyRenderer.draw_jakub_operator_ucp(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_transit_maintenance_cart() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 113).
	MrpLegacyRenderer.draw_transit_maintenance_cart(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_scar_diagnostic_chart() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 114).
	MrpLegacyRenderer.draw_scar_diagnostic_chart(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_jakub_hand_gesture_sensor() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 115).
	MrpLegacyRenderer.draw_jakub_hand_gesture_sensor(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_station_25_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 116).
	MrpLegacyRenderer.draw_station_25_exit(self, is_activated, _pulse_phase)


func _draw_isolation_zone_console() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 117).
	MrpLegacyRenderer.draw_isolation_zone_console(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_dynamic_room_designator() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 118).
	MrpLegacyRenderer.draw_dynamic_room_designator(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_motivation_anchor_record() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 119).
	MrpLegacyRenderer.draw_motivation_anchor_record(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_wierzbicka_pa_speaker() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 120).
	MrpLegacyRenderer.draw_wierzbicka_pa_speaker(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_station_26_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 121).
	MrpLegacyRenderer.draw_station_26_exit(self, is_activated, _pulse_phase)


func _draw_jakub_service_operator() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 122).
	MrpLegacyRenderer.draw_jakub_service_operator(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_saved_worker_badge() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 123).
	MrpLegacyRenderer.draw_saved_worker_badge(self, is_activated, _pulse_phase)


func _draw_surface_stability_monitor() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 124).
	MrpLegacyRenderer.draw_surface_stability_monitor(self, is_activated, _pulse_phase)


func _draw_technical_junction_console() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 125).
	MrpLegacyRenderer.draw_technical_junction_console(self, is_activated, _pulse_phase)


func _draw_station_27_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 126).
	MrpLegacyRenderer.draw_station_27_exit(self, is_activated, _pulse_phase)


func _draw_tram_driver_console() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 127).
	MrpLegacyRenderer.draw_tram_driver_console(self, is_activated, _pulse_phase)


func _draw_panoramic_transit_window() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 128).
	MrpLegacyRenderer.draw_panoramic_transit_window(self, _pulse_phase)


func _draw_triple_accident_paradox_view() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 129).
	MrpLegacyRenderer.draw_triple_accident_paradox_view(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_wierzbicka_closing_intercom() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 130).
	MrpLegacyRenderer.draw_wierzbicka_closing_intercom(self, is_activated, _pulse_phase)


func _draw_station_28_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 131).
	MrpLegacyRenderer.draw_station_28_exit(self, is_activated, _pulse_phase)


func _draw_abandoned_platform_tracks() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 132).
	MrpLegacyRenderer.draw_abandoned_platform_tracks(self, is_activated, _pulse_phase)


func _draw_flickering_neon_sign() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 133).
	MrpLegacyRenderer.draw_flickering_neon_sign(self, is_activated, _pulse_phase)


func _draw_deep_substructure_well() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 134).
	MrpLegacyRenderer.draw_deep_substructure_well(self, _pulse_phase)


func _draw_jakub_torch_beacon() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 135).
	MrpLegacyRenderer.draw_jakub_torch_beacon(self, is_activated, _pulse_phase)


func _draw_station_29_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 136).
	MrpLegacyRenderer.draw_station_29_exit(self, is_activated, _pulse_phase)


func _draw_main_power_distribution_board() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 137).
	MrpLegacyRenderer.draw_main_power_distribution_board(self, is_activated, _pulse_phase)


func _draw_high_voltage_transformer_bank() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 138).
	MrpLegacyRenderer.draw_high_voltage_transformer_bank(self, is_activated, _pulse_phase)


func _draw_section_breaker_lever() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 139).
	MrpLegacyRenderer.draw_section_breaker_lever(self, is_activated, _pulse_phase)


func _draw_grid_schematic_display() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 140).
	MrpLegacyRenderer.draw_grid_schematic_display(self, is_activated, _pulse_phase)


func _draw_station_30_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 141).
	MrpLegacyRenderer.draw_station_30_exit(self, is_activated, _pulse_phase)


func _draw_eleven_chairs_archive_row() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 142).
	MrpLegacyRenderer.draw_eleven_chairs_archive_row(self, is_activated, _pulse_phase)


func _draw_wierzbicka_remote_holoterminal() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 143).
	MrpLegacyRenderer.draw_wierzbicka_remote_holoterminal(self, is_activated, _pulse_phase)


func _draw_jakub_twelfth_chair() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 144).
	MrpLegacyRenderer.draw_jakub_twelfth_chair(self, is_activated, _pulse_phase)


func _draw_variant_choice_ledger() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 145).
	MrpLegacyRenderer.draw_variant_choice_ledger(self, _pulse_phase)


func _draw_station_31_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 146).
	MrpLegacyRenderer.draw_station_31_exit(self, is_activated, _pulse_phase)


func _draw_steamed_glass_pane_a() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 147).
	MrpLegacyRenderer.draw_steamed_glass_pane_a(self, is_activated, _pulse_phase)


func _draw_cracked_glass_pane_b() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 148).
	MrpLegacyRenderer.draw_cracked_glass_pane_b(self, is_activated, _pulse_phase)


func _draw_polished_glass_pane_c() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 149).
	MrpLegacyRenderer.draw_polished_glass_pane_c(self, is_activated, _pulse_phase)


func _draw_condensation_trace_etcher() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 150).
	MrpLegacyRenderer.draw_condensation_trace_etcher(self, is_activated, _pulse_phase)


func _draw_station_32_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 151).
	MrpLegacyRenderer.draw_station_32_exit(self, is_activated, _pulse_phase)


func _draw_vertical_ladder_array() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 152).
	MrpLegacyRenderer.draw_vertical_ladder_array(self, is_activated)


func _draw_depth_pressure_gauge() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 153).
	MrpLegacyRenderer.draw_depth_pressure_gauge(self, is_activated, _pulse_phase)


func _draw_memory_bus_cable_trunk() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 154).
	MrpLegacyRenderer.draw_memory_bus_cable_trunk(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_shaft_work_light_beacon() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 155).
	MrpLegacyRenderer.draw_shaft_work_light_beacon(self, is_activated, _pulse_phase, is_player_in_range)


func _draw_station_33_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 156).
	MrpLegacyRenderer.draw_station_33_exit(self, is_activated, _pulse_phase)


func _draw_main_exchange_core_reactor() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 157).
	MrpLegacyRenderer.draw_main_exchange_core_reactor(self, is_activated, _pulse_phase)


func _draw_biography_allocation_desk() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 158).
	MrpLegacyRenderer.draw_biography_allocation_desk(self, is_activated)


func _draw_thermal_overload_indicator() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 159).
	MrpLegacyRenderer.draw_thermal_overload_indicator(self, is_activated, _pulse_phase)


func _draw_jakub_core_diagnostic_port() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 160).
	MrpLegacyRenderer.draw_jakub_core_diagnostic_port(self, is_activated, _pulse_phase)


func _draw_station_34_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 161).
	MrpLegacyRenderer.draw_station_34_exit(self, is_activated, _pulse_phase)


func _draw_sedation_basin_pool() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 162).
	MrpLegacyRenderer.draw_sedation_basin_pool(self, is_activated, _pulse_phase)


func _draw_sludge_drain_valve_wheel() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 163).
	MrpLegacyRenderer.draw_sludge_drain_valve_wheel(self, is_activated, _pulse_phase)


func _draw_chemical_sedation_sampler() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 164).
	MrpLegacyRenderer.draw_chemical_sedation_sampler(self, is_activated, _pulse_phase)


func _draw_jakub_sedation_monitor() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 165).
	MrpLegacyRenderer.draw_jakub_sedation_monitor(self, is_activated, _pulse_phase)


func _draw_station_35_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 166).
	MrpLegacyRenderer.draw_station_35_exit(self, is_activated, _pulse_phase)


func _draw_storm_drain_weir() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 167).
	MrpLegacyRenderer.draw_storm_drain_weir(self, is_activated, _pulse_phase)


func _draw_sedative_sludge_current() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 168).
	MrpLegacyRenderer.draw_sedative_sludge_current(self, is_activated, _pulse_phase)


func _draw_acid_resistant_catwalk_ladder() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 169).
	MrpLegacyRenderer.draw_acid_resistant_catwalk_ladder(self, is_activated, _pulse_phase)


func _draw_contamination_sampling_tap() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 170).
	MrpLegacyRenderer.draw_contamination_sampling_tap(self, is_activated, _pulse_phase)


func _draw_station_36_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 171).
	MrpLegacyRenderer.draw_station_36_exit(self, is_activated, _pulse_phase)


func _draw_signal_transmission_antenna() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 172).
	MrpLegacyRenderer.draw_signal_transmission_antenna(self, is_activated, _pulse_phase)


func _draw_transmission_cross_patchbay() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 173).
	MrpLegacyRenderer.draw_transmission_cross_patchbay(self, is_activated, _pulse_phase)


func _draw_frequency_oscilloscope_crt() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 174).
	MrpLegacyRenderer.draw_frequency_oscilloscope_crt(self, is_activated, _pulse_phase)


func _draw_memory_injection_pulpit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 175).
	MrpLegacyRenderer.draw_memory_injection_pulpit(self, is_activated, _pulse_phase)


func _draw_station_37_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 176).
	MrpLegacyRenderer.draw_station_37_exit(self, is_activated, _pulse_phase)


func _draw_accident_simulation_field() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 177).
	MrpLegacyRenderer.draw_accident_simulation_field(self, is_activated, _pulse_phase)


func _draw_destabilizing_jakub_shadow() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 178).
	MrpLegacyRenderer.draw_destabilizing_jakub_shadow(self, is_activated, _pulse_phase)


func _draw_rescue_tether_anchor() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 179).
	MrpLegacyRenderer.draw_rescue_tether_anchor(self, is_activated, _pulse_phase)


func _draw_return_coordinate_calculator() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 180).
	MrpLegacyRenderer.draw_return_coordinate_calculator(self, is_activated, _pulse_phase)


func _draw_station_38_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 181).
	MrpLegacyRenderer.draw_station_38_exit(self, is_activated, _pulse_phase)


func _draw_central_reference_core_monolith() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 182).
	MrpLegacyRenderer.draw_central_reference_core_monolith(self, is_activated, _pulse_phase)


func _draw_branch_config_return_a() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 183).
	MrpLegacyRenderer.draw_branch_config_return_a(self, is_activated, _pulse_phase)


func _draw_branch_config_reconciliation_b() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 184).
	MrpLegacyRenderer.draw_branch_config_reconciliation_b(self, is_activated, _pulse_phase)


func _draw_branch_config_testimony_c() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 185).
	MrpLegacyRenderer.draw_branch_config_testimony_c(self, is_activated, _pulse_phase)


func _draw_station_39_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 186).
	MrpLegacyRenderer.draw_station_39_exit(self, is_activated, _pulse_phase)


func _draw_wierzbicka_personal_terminal() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 187).
	MrpLegacyRenderer.draw_wierzbicka_personal_terminal(self, is_activated, _pulse_phase)


func _draw_marta_witness_station() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 188).
	MrpLegacyRenderer.draw_marta_witness_station(self, is_activated, _pulse_phase)


func _draw_szymon_transmission_monitor() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 189).
	MrpLegacyRenderer.draw_szymon_transmission_monitor(self, is_activated, _pulse_phase)


func _draw_operation_cost_dossier_matrix() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 190).
	MrpLegacyRenderer.draw_operation_cost_dossier_matrix(self, is_activated, _pulse_phase)


func _draw_station_40_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 191).
	MrpLegacyRenderer.draw_station_40_exit(self, is_activated, _pulse_phase)


func _draw_op_console_return_a() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 192).
	MrpLegacyRenderer.draw_op_console_return_a(self, is_activated, _pulse_phase)


func _draw_op_console_reconciliation_b() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 193).
	MrpLegacyRenderer.draw_op_console_reconciliation_b(self, is_activated, _pulse_phase)


func _draw_op_console_testimony_c() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 194).
	MrpLegacyRenderer.draw_op_console_testimony_c(self, is_activated, _pulse_phase)


func _draw_op_continuity_topography_display() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 195).
	MrpLegacyRenderer.draw_op_continuity_topography_display(self, is_activated, _pulse_phase)


func _draw_station_41_exit() -> void:
	# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType 196).
	MrpLegacyRenderer.draw_station_41_exit(self, is_activated, _pulse_phase)


func _draw_epilogue_return_cups() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 197).
	MrpLegacyRenderer.draw_epilogue_return_cups(self, is_activated, _pulse_phase)


func _draw_epilogue_marta_doorstep() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 198).
	MrpLegacyRenderer.draw_epilogue_marta_doorstep(self, is_activated, _pulse_phase)


func _draw_epilogue_tram_dual_tracks() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 199).
	MrpLegacyRenderer.draw_epilogue_tram_dual_tracks(self, is_activated, _pulse_phase)


func _draw_epilogue_admin_notice_board() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 200).
	MrpLegacyRenderer.draw_epilogue_admin_notice_board(self, is_activated, _pulse_phase)


func _draw_epilogue_credits_roll() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 201).
	MrpLegacyRenderer.draw_epilogue_credits_roll(self, is_activated, _pulse_phase)


func _draw_epilogue_final_blackout() -> void:
	# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType 202).
	MrpLegacyRenderer.draw_epilogue_final_blackout(self, is_activated, _pulse_phase)


func _draw_contact_read() -> void:
	if _contact_progress <= 0.01 and _touch_flash <= 0.01:
		return
	var breath: float = 0.62 + 0.38 * sin(_pulse_phase * 0.8)
	var radius: float = interaction_radius * (0.42 + 0.10 * _contact_progress)
	var arc_alpha: float = 0.16 * _contact_progress * breath + 0.22 * _touch_flash
	if arc_alpha > 0.01:
		draw_arc(
			Vector2(0.0, 2.0),
			radius,
			deg_to_rad(196.0),
			deg_to_rad(344.0),
			18,
			Color(COLOR_AMBER, clampf(arc_alpha, 0.0, 1.0)),
			1.0,
			true
		)
	var dot_alpha: float = 0.30 * _contact_progress + 0.45 * _touch_flash
	if dot_alpha > 0.01:
		var dot_color: Color = COLOR_CYAN if is_activated else COLOR_AMBER
		draw_circle(
			Vector2(0.0, radius * 0.42),
			1.0 + 0.8 * _touch_flash,
			Color(dot_color, clampf(dot_alpha, 0.0, 1.0))
		)
