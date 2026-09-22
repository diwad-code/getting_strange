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

var is_player_in_range: bool = false:
	set(value):
		if is_player_in_range != value:
			is_player_in_range = value
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
	# Framed photograph on desk: 24x18 px
	# Asymmetrical composition per FULL_STORY 01: Lena & Jakub on left, right third empty
	var frame_rect := Rect2(-12.0, -10.0, 24.0, 20.0)
	var photo_rect := Rect2(-10.0, -8.0, 20.0, 16.0)
	
	# Wood/dark steel frame
	draw_rect(frame_rect, Color("20262b"))
	draw_rect(frame_rect, COLOR_DARK_STEEL, false, 1.0)
	
	# Photographic paper background (aged monochrome silver gelatin)
	var photo_bg := Color("4b585e") if not is_activated else Color("5a6970")
	draw_rect(photo_rect, photo_bg)
	
	# Silhouettes of teenage Lena & Jakub on left 2/3
	# Jakub (slightly taller, 13 years earlier / age 20)
	draw_rect(Rect2(-8.0, -3.0, 5.0, 9.0), Color("182126"))
	draw_circle(Vector2(-5.5, -5.0), 2.2, Color("182126"))
	
	# Lena (left side)
	draw_rect(Rect2(-3.0, -1.0, 4.0, 7.0), Color("243038"))
	draw_circle(Vector2(-1.0, -3.5), 1.8, Color("243038"))
	
	# Empty right third (negative space #composition-negative-space per canon)
	draw_line(Vector2(2.0, -8.0), Vector2(2.0, 8.0), Color(0.1, 0.15, 0.18, 0.25), 1.0)
	
	# Subtle glass reflection
	draw_line(Vector2(-9.0, -7.0), Vector2(3.0, 6.0), Color(1.0, 1.0, 1.0, 0.18), 1.0)
	
	# Support stand behind frame
	draw_line(Vector2(0.0, 10.0), Vector2(4.0, 13.0), Color("182126"), 2.0)


func _draw_circuit_breaker() -> void:
	# Industrial DIN rail mounted toggle switch: 18x26 px
	var base_rect := Rect2(-9.0, -13.0, 18.0, 26.0)
	
	# Backplate
	draw_rect(base_rect, COLOR_DARK_STEEL)
	draw_rect(base_rect, COLOR_INFRASTRUCTURE, false, 1.0)
	
	# Screw fixings
	draw_circle(Vector2(0.0, -10.0), 1.2, COLOR_INFRASTRUCTURE)
	draw_circle(Vector2(0.0, 10.0), 1.2, COLOR_INFRASTRUCTURE)
	
	# Switch slot
	draw_rect(Rect2(-4.0, -6.0, 8.0, 12.0), Color("12191e"))
	
	# Toggle lever
	var lever_y := -4.0 if is_activated else 4.0
	var lever_col := COLOR_CYAN if is_activated else Color("788791")
	draw_rect(Rect2(-3.0, lever_y - 2.0, 6.0, 4.0), lever_col)
	draw_line(Vector2(0.0, lever_y), Vector2(0.0, 0.0), COLOR_INFRASTRUCTURE, 1.5)
	
	# Status Indicator Diode
	var diode_col := COLOR_CYAN if is_activated else Color(0.4, 0.15, 0.15, 0.7)
	draw_circle(Vector2(0.0, -2.0), 2.0, diode_col)


func _draw_vacuum_gauge() -> void:
	# Circular vacuum manometer: radius 12 px
	var center := Vector2.ZERO
	var radius := 11.0
	
	# Housing
	draw_circle(center, radius + 2.0, COLOR_DARK_STEEL)
	draw_circle(center, radius + 2.0, COLOR_INFRASTRUCTURE, false, 1.0)
	
	# Gauge face
	draw_circle(center, radius, Color("141b20"))
	
	# Calibration tick marks
	for i in range(7):
		var angle := -PI * 0.75 + float(i) * (PI * 1.5 / 6.0)
		var p1 := center + Vector2(cos(angle), sin(angle)) * (radius - 3.0)
		var p2 := center + Vector2(cos(angle), sin(angle)) * (radius - 1.0)
		var tick_col := COLOR_CYAN if i >= 4 else COLOR_INFRASTRUCTURE
		draw_line(p1, p2, tick_col, 1.0)
	
	# Needle
	var needle_angle := PI * 0.45 if is_activated else -PI * 0.65
	var needle_end := center + Vector2(cos(needle_angle), sin(needle_angle)) * (radius - 2.5)
	var needle_col := COLOR_AMBER if is_activated else COLOR_INFRASTRUCTURE
	draw_line(center, needle_end, needle_col, 1.5)
	draw_circle(center, 2.0, COLOR_DARK_STEEL)


func _draw_chamber_console() -> void:
	# Terminal console with cathode readout & keylock: 26x32 px
	var rect := Rect2(-13.0, -16.0, 26.0, 32.0)
	draw_rect(rect, COLOR_DARK_STEEL)
	draw_rect(rect, COLOR_INFRASTRUCTURE, false, 1.0)
	
	# Screen bezel & CRT phosphor display
	var screen_rect := Rect2(-10.0, -13.0, 20.0, 14.0)
	draw_rect(screen_rect, Color("0e161a"))
	draw_rect(screen_rect, COLOR_INFRASTRUCTURE * 0.6, false, 1.0)
	
	# Phosphor text lines on screen
	var scr_col := COLOR_CYAN if is_activated else COLOR_AMBER
	draw_line(Vector2(-8.0, -10.0), Vector2(4.0, -10.0), scr_col * 0.9, 1.0)
	draw_line(Vector2(-8.0, -7.0), Vector2(7.0, -7.0), scr_col * 0.7, 1.0)
	draw_line(Vector2(-8.0, -4.0), Vector2(-1.0, -4.0), scr_col * 0.8, 1.0)
	
	# Keyway & Status Lamps
	draw_rect(Rect2(-8.0, 5.0, 16.0, 6.0), Color("12191e"))
	var led1 := COLOR_CYAN if is_activated else Color(0.2, 0.4, 0.4)
	var led2 := COLOR_AMBER if is_activated else Color(0.4, 0.3, 0.1)
	draw_circle(Vector2(-4.0, 8.0), 1.5, led1)
	draw_circle(Vector2(4.0, 8.0), 1.5, led2)


func _draw_document_clipboard() -> void:
	# Checklist clipboard: 16x22 px
	var rect := Rect2(-8.0, -11.0, 16.0, 22.0)
	draw_rect(rect, Color("423223"))
	
	# Paper sheets
	var paper_rect := Rect2(-7.0, -9.0, 14.0, 19.0)
	draw_rect(paper_rect, Color("c2ba9b"))
	
	# Metal spring clamp at top
	draw_rect(Rect2(-4.0, -12.0, 8.0, 3.0), COLOR_INFRASTRUCTURE)
	
	# Checklist lines
	var line_col := Color("4b4637")
	for i in range(4):
		var y := -6.0 + float(i) * 4.0
		draw_rect(Rect2(-5.0, y - 1.0, 2.0, 2.0), COLOR_CYAN if (is_activated or i < 2) else line_col)
		draw_line(Vector2(-1.0, y), Vector2(5.0, y), line_col, 1.0)


func _draw_door_card_reader() -> void:
	# Institutional wall-mounted card terminal: 22x32 px
	var base_rect := Rect2(-11.0, -16.0, 22.0, 32.0)
	draw_rect(base_rect, COLOR_DARK_STEEL)
	draw_rect(base_rect, COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	
	# Card swipe slot on right
	draw_rect(Rect2(7.0, -14.0, 2.0, 28.0), Color("0d1317"))
	
	# Backlit LCD screen (16x14 px)
	var screen_rect := Rect2(-9.0, -14.0, 15.0, 16.0)
	var screen_bg := Color("12221b") if is_activated else Color("0e161a")
	draw_rect(screen_rect, screen_bg)
	draw_rect(screen_rect, COLOR_INFRASTRUCTURE * 0.5, false, 1.0)
	
	# Mini badge photo (Left side of LCD): Different photo/silhouette of Lena
	# Head and torso with altered neckline / haircut reflecting alternate timeline
	var photo_rect := Rect2(-8.0, -13.0, 6.0, 7.0)
	draw_rect(photo_rect, Color("2d3b3f"))
	# Alternate Lena portrait silhouette: facing slightly forward, tied hair
	draw_circle(Vector2(-5.0, -10.5), 1.6, Color("141c22"))
	draw_rect(Rect2(-7.0, -8.5, 4.0, 2.5), Color("141c22"))
	
	# Data readout lines on LCD: "WOLSKA, L." and "URLOP PRZERWANY"
	if is_activated or is_player_in_range:
		var p := sin(_pulse_phase * 3.0) * 0.3 + 0.7
		# WOLSKA, L. // ID: 884-A
		draw_line(Vector2(-1.0, -12.0), Vector2(4.0, -12.0), COLOR_INFRASTRUCTURE * 0.9, 1.0)
		draw_line(Vector2(-1.0, -9.0), Vector2(3.0, -9.0), COLOR_CYAN * 0.8, 1.0)
		
		# "URLOP PRZERWANY" (Pulsing cinnabar / amber alert banner)
		var alert_col := Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, p)
		draw_rect(Rect2(-8.0, -4.0, 13.0, 5.0), Color(0.2, 0.08, 0.08, 0.8))
		draw_line(Vector2(-7.0, -2.0), Vector2(4.0, -2.0), alert_col, 1.2)
	else:
		# Standby cursor
		draw_line(Vector2(-8.0, -2.0), Vector2(-4.0, -2.0), COLOR_INFRASTRUCTURE * 0.4, 1.0)
	
	# Status Indicator Diode (Green/Cyan authorized, Amber/Cinnabar alert)
	var led_col := COLOR_CYAN if is_activated else (COLOR_AMBER if is_player_in_range else Color("4d3826"))
	draw_circle(Vector2(-4.0, 8.0), 1.8, led_col)
	draw_circle(Vector2(4.0, 8.0), 1.5, COLOR_INFRASTRUCTURE * 0.6)


func _draw_twin_cups() -> void:
	# Operator desk surface coaster: 30x6 px
	draw_rect(Rect2(-15.0, 4.0, 30.0, 3.0), Color("1e2930"))
	draw_rect(Rect2(-15.0, 4.0, 30.0, 3.0), COLOR_INFRASTRUCTURE * 0.4, false, 1.0)
	
	# ── Cup 1 (Left): Lena's original grey ceramic mug from Scene 01 ──
	# Body: 7x9 px at x = -8
	var cup1_rect := Rect2(-11.0, -4.0, 7.0, 8.0)
	draw_rect(cup1_rect, Color("c4c0b4")) # Standard beige/grey ceramic
	draw_rect(cup1_rect, Color("8a877d"), false, 1.0)
	# Handle
	draw_rect(Rect2(-13.0, -2.0, 2.0, 5.0), Color("8a877d"))
	# Empty interior lip
	draw_line(Vector2(-11.0, -4.0), Vector2(-4.0, -4.0), Color("626058"), 1.0)
	
	# ── Cup 2 (Right): Second mug (The material anomaly - proof of an unrecorded colleague) ──
	# Body: 8x10 px at x = 5 (slightly taller, enamel dark sage with coffee residue)
	var cup2_rect := Rect2(3.0, -5.0, 8.0, 9.0)
	draw_rect(cup2_rect, Color("3d554a")) # Institutional dark sage enamel
	draw_rect(cup2_rect, Color("202c26"), false, 1.0)
	# Handle on right
	draw_rect(Rect2(11.0, -3.0, 2.0, 5.0), Color("202c26"))
	# Rim with dark coffee ring / residue
	draw_line(Vector2(3.0, -5.0), Vector2(11.0, -5.0), Color("1e140d"), 1.2)
	# Dark coffee stain running down side
	draw_line(Vector2(8.0, -4.0), Vector2(8.0, 0.0), Color("1e140d", 0.7), 1.0)
	
	# Faint steam trace above cup 2 when inspected or active (fresh coffee)
	if is_activated or is_player_in_range:
		var p := sin(_pulse_phase * 2.0) * 0.5 + 0.5
		var steam_alpha := 0.25 + p * 0.25
		draw_line(Vector2(7.0, -7.0), Vector2(8.0, -11.0), Color(1.0, 1.0, 1.0, steam_alpha), 1.0)
		draw_line(Vector2(9.0, -6.0), Vector2(10.0, -10.0), Color(1.0, 1.0, 1.0, steam_alpha * 0.7), 1.0)


func _draw_desk_telephone() -> void:
	# Heavy 90s institutional office desk phone console: 24x18 px
	var phone_rect := Rect2(-12.0, -8.0, 24.0, 16.0)
	draw_rect(phone_rect, Color("222d35")) # Dark industrial plastic
	draw_rect(phone_rect, COLOR_INFRASTRUCTURE * 0.6, false, 1.0)
	
	# Cradle and handset on top/left
	var handset_rect := Rect2(-14.0, -10.0, 10.0, 20.0)
	draw_rect(handset_rect, Color("172026"))
	draw_rect(handset_rect, COLOR_DARK_STEEL, false, 1.0)
	# Handset grip taper
	draw_rect(Rect2(-12.0, -5.0, 6.0, 10.0), Color("10161a"))
	
	# Keypad button matrix on right: 3x3 buttons
	for row in range(3):
		for col in range(3):
			var bx := -1.0 + float(col) * 3.5
			var by := -2.0 + float(row) * 3.5
			draw_rect(Rect2(bx, by, 2.5, 2.5), Color("3d4e58"))
	
	# LCD status screen on top right
	var screen_rect := Rect2(-2.0, -7.0, 12.0, 4.0)
	draw_rect(screen_rect, Color("0e161a"))
	draw_rect(screen_rect, COLOR_INFRASTRUCTURE * 0.4, false, 0.8)
	
	# Text readout on LCD: "14" unread messages
	draw_line(Vector2(-1.0, -5.0), Vector2(8.0, -5.0), COLOR_AMBER * 0.85, 1.0)
	
	# ── Message Waiting Light (Blinking Amber LED) ──
	var blink := sin(_pulse_phase * 4.0) * 0.5 + 0.5
	var led_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.3 + blink * 0.7)
	draw_circle(Vector2(9.0, -1.0), 1.8, led_col)
	draw_circle(Vector2(9.0, -1.0), 3.5, Color(led_col.r, led_col.g, led_col.b, blink * 0.3))
	
	# Coiled telephone cable at bottom
	for c in range(4):
		var cx := -11.0 + float(c) * 2.5
		var cy := 8.0 + (1.0 if c % 2 == 0 else -1.0) * 1.5
		draw_circle(Vector2(cx, cy), 1.0, Color("141c22"))


func _draw_duty_roster() -> void:
	# Wall acrylic duty notice board: 22x28 px
	var board_rect := Rect2(-11.0, -14.0, 22.0, 28.0)
	draw_rect(board_rect, Color("1e2a32"))
	draw_rect(board_rect, COLOR_INFRASTRUCTURE * 0.8, false, 1.0)
	
	# Corner mounting standoffs
	draw_circle(Vector2(-9.0, -12.0), 1.0, COLOR_INFRASTRUCTURE)
	draw_circle(Vector2(9.0, -12.0), 1.0, COLOR_INFRASTRUCTURE)
	draw_circle(Vector2(-9.0, 12.0), 1.0, COLOR_INFRASTRUCTURE)
	draw_circle(Vector2(9.0, 12.0), 1.0, COLOR_INFRASTRUCTURE)
	
	# Header banner: IKP DYŻURY NOCNE
	draw_rect(Rect2(-9.0, -11.0, 18.0, 4.0), Color("293a44"))
	draw_line(Vector2(-7.0, -9.0), Vector2(7.0, -9.0), COLOR_INFRASTRUCTURE, 1.0)
	
	# Roster schedule entries (grid lines with strikethroughs / missing staff)
	for i in range(4):
		var y := -4.0 + float(i) * 4.5
		var line_c := COLOR_AMBER if i == 0 else COLOR_INFRASTRUCTURE * 0.7
		draw_line(Vector2(-8.0, y), Vector2(3.0, y), line_c, 1.0)
		# Red/cinnabar strikethrough or absence mark for missing night staff
		if i > 0:
			draw_line(Vector2(4.0, y - 1.0), Vector2(8.0, y + 1.0), COLOR_CORRECTION * 0.8, 1.0)
			draw_line(Vector2(4.0, y + 1.0), Vector2(8.0, y - 1.0), COLOR_CORRECTION * 0.8, 1.0)


func _draw_security_monitor() -> void:
	# CRT CCTV monitor on guard desk: 26x20 px
	var mon_rect := Rect2(-13.0, -10.0, 26.0, 20.0)
	draw_rect(mon_rect, Color("1a242b"))
	draw_rect(mon_rect, COLOR_DARK_STEEL, false, 1.0)
	
	# Bezel & screen inset
	var scr_rect := Rect2(-11.0, -8.0, 22.0, 14.0)
	draw_rect(scr_rect, Color("0b1318"))
	
	# Green/graphite CCTV raster lines
	var p := sin(_pulse_phase * 3.0) * 0.5 + 0.5
	for row in range(3):
		var y := -6.0 + float(row) * 4.0
		draw_line(Vector2(-9.0, y), Vector2(9.0, y), Color(0.20, 0.45, 0.35, 0.4 + p * 0.2), 1.0)
	
	# Silhouette of gate on CCTV screen
	draw_line(Vector2(2.0, -5.0), Vector2(2.0, 4.0), Color(0.25, 0.55, 0.42, 0.7), 1.5)
	draw_line(Vector2(-3.0, 1.0), Vector2(2.0, -1.0), Color(0.25, 0.55, 0.42, 0.7), 1.0)
	
	# Camera status overlay text: "CAM 04 [REC]"
	draw_line(Vector2(-9.0, -7.0), Vector2(-4.0, -7.0), COLOR_CORRECTION * 0.8, 1.0)
	
	# Green power LED
	draw_circle(Vector2(8.0, 8.0), 1.0, Color("45c68a"))


func _draw_ucp_notice() -> void:
	# Official UCP institutional advisory bulletin on wall: 24x30 px
	var board_rect := Rect2(-12.0, -15.0, 24.0, 30.0)
	draw_rect(board_rect, Color("202d36"))
	draw_rect(board_rect, COLOR_INFRASTRUCTURE * 0.75, false, 1.0)
	
	# Blue/grey header: "UCP // PROTOKÓŁ ZGŁASZANIA"
	draw_rect(Rect2(-10.0, -13.0, 20.0, 5.0), Color("2f4552"))
	draw_line(Vector2(-8.0, -10.5), Vector2(8.0, -10.5), COLOR_INFRASTRUCTURE, 1.0)
	
	# Institutional bulletin text lines
	for i in range(5):
		var y := -5.0 + float(i) * 3.8
		var col := COLOR_INFRASTRUCTURE * 0.65
		if i == 0:
			col = COLOR_AMBER * 0.8
		elif i == 4:
			col = COLOR_CORRECTION * 0.7
		draw_line(Vector2(-9.0, y), Vector2(9.0, y), col, 1.0)
	
	# Official seal / stamp mark on bottom right
	draw_rect(Rect2(3.0, 6.0, 6.0, 6.0), Color("8f3833", 0.5))


func _draw_guard_interaction() -> void:
	# Desk counter intercom / call button
	var box_rect := Rect2(-8.0, -6.0, 16.0, 12.0)
	draw_rect(box_rect, COLOR_DARK_STEEL)
	draw_rect(box_rect, COLOR_INFRASTRUCTURE * 0.6, false, 1.0)
	
	# Intercom speaker grill perforations
	for i in range(3):
		var y := -3.0 + float(i) * 3.0
		draw_line(Vector2(-5.0, y), Vector2(1.0, y), Color("121a20"), 1.0)
	
	# Call / alert indicator button
	var btn_col := COLOR_CYAN if is_activated else COLOR_AMBER
	draw_circle(Vector2(4.0, 0.0), 2.2, btn_col)


func _draw_anachronistic_billboard() -> void:
	# Anachronistic advertising / institutional billboard (38x26 px)
	var board_rect := Rect2(-19.0, -18.0, 38.0, 26.0)
	
	# Steel support pillars extending into pavement
	draw_line(Vector2(-14.0, 8.0), Vector2(-14.0, 24.0), COLOR_DARK_STEEL, 2.0)
	draw_line(Vector2(14.0, 8.0), Vector2(14.0, 24.0), COLOR_DARK_STEEL, 2.0)
	
	# Billboard panel & enamel frame
	draw_rect(board_rect, Color("1a262e"))
	draw_rect(board_rect, COLOR_INFRASTRUCTURE * 0.8, false, 1.5)
	
	# Header banner (UCP / Era-shifted enterprise)
	draw_rect(Rect2(-17.0, -16.0, 34.0, 6.0), Color("283d4a"))
	draw_line(Vector2(-15.0, -13.0), Vector2(15.0, -13.0), COLOR_INFRASTRUCTURE, 1.0)
	
	# Slogan typography lines ("PAMIĘĆ WSPÓLNA TO SPOKÓJ")
	var line_col := COLOR_AMBER if is_activated else Color("c0ccc6")
	draw_line(Vector2(-15.0, -6.0), Vector2(12.0, -6.0), line_col, 1.2)
	draw_line(Vector2(-15.0, -2.0), Vector2(8.0, -2.0), line_col * 0.85, 1.0)
	draw_line(Vector2(-15.0, 2.0), Vector2(14.0, 2.0), COLOR_INFRASTRUCTURE * 0.6, 1.0)
	
	# Era timestamp emblem in corner ("1978")
	draw_rect(Rect2(7.0, 1.0, 9.0, 4.0), Color("344b59"))
	draw_line(Vector2(8.0, 3.0), Vector2(15.0, 3.0), COLOR_CYAN * 0.8, 1.0)
	
	# Overhead floodlight bracket
	draw_line(Vector2(0.0, -18.0), Vector2(0.0, -23.0), COLOR_DARK_STEEL, 1.5)
	var lamp_col := Color("f4eed6") if is_activated else Color("3d4b52")
	draw_circle(Vector2(0.0, -23.0), 2.0, lamp_col)


func _draw_missing_floor_facade() -> void:
	# Architectural elevation inspection marker (24x30 px)
	var plaque_rect := Rect2(-12.0, -15.0, 24.0, 30.0)
	draw_rect(plaque_rect, Color("18232a"))
	draw_rect(plaque_rect, COLOR_DARK_STEEL, false, 1.2)
	
	# Building elevation outline showing missing 3rd floor
	# 5 Floors diagram: Floor 1 (y=9..5), Floor 2 (y=4..0), Floor 3 VOID (-1..-5), Floor 4 (-6..-10), Floor 5 (-11..-15)
	# Floor 1 & 2 (Lower mass)
	draw_rect(Rect2(-8.0, 0.0, 16.0, 10.0), Color("243540"))
	draw_rect(Rect2(-8.0, 0.0, 16.0, 10.0), COLOR_INFRASTRUCTURE * 0.5, false, 1.0)
	# Floor 4 & 5 (Upper mass)
	draw_rect(Rect2(-8.0, -14.0, 16.0, 9.0), Color("243540"))
	draw_rect(Rect2(-8.0, -14.0, 16.0, 9.0), COLOR_INFRASTRUCTURE * 0.5, false, 1.0)
	
	# Floor 3 Void gap: Only 2 slender structural columns spanning the gap
	draw_line(Vector2(-6.0, -5.0), Vector2(-6.0, 0.0), COLOR_INFRASTRUCTURE * 0.9, 1.2)
	draw_line(Vector2(6.0, -5.0), Vector2(6.0, 0.0), COLOR_INFRASTRUCTURE * 0.9, 1.2)
	
	# Oxide cinnabar annotation indicator pointing to the void
	var void_col := COLOR_CORRECTION if is_activated else Color("7a3e3b")
	draw_line(Vector2(-3.0, -2.5), Vector2(3.0, -2.5), void_col, 1.2)
	draw_circle(Vector2(0.0, -2.5), 1.2, void_col)


func _draw_crosswalk_signal() -> void:
	# Pedestrian traffic beacon & acoustic signal pole (x=0, y=-30..20)
	# Steel pole
	draw_line(Vector2(0.0, -32.0), Vector2(0.0, 24.0), COLOR_DARK_STEEL, 3.0)
	draw_line(Vector2(0.0, -32.0), Vector2(0.0, 24.0), COLOR_INFRASTRUCTURE * 0.6, 1.0)
	
	# Top signal housing (14x24 px, y=-32..-8)
	var signal_box := Rect2(-7.0, -32.0, 14.0, 24.0)
	draw_rect(signal_box, Color("141d24"))
	draw_rect(signal_box, COLOR_DARK_STEEL, false, 1.2)
	
	# Sun visors over lamps
	draw_line(Vector2(-6.0, -32.0), Vector2(6.0, -32.0), Color("0d1419"), 1.8)
	draw_line(Vector2(-6.0, -20.0), Vector2(6.0, -20.0), Color("0d1419"), 1.8)
	
	# Upper Signal: Red pedestrian stop silhouette (lit when not active)
	var red_col := COLOR_CORRECTION if not is_activated else Color("331515")
	draw_circle(Vector2(0.0, -26.0), 3.5, red_col)
	if not is_activated:
		draw_circle(Vector2(0.0, -26.0), 6.0, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.25))
	
	# Lower Signal: Green / Cyan walking figure (lit when activated)
	var green_col := COLOR_CYAN if is_activated else Color("142b29")
	draw_circle(Vector2(0.0, -14.0), 3.5, green_col)
	if is_activated:
		draw_circle(Vector2(0.0, -14.0), 7.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35))
	
	# Lower Pedestrian Push-Button Box (y=0..16)
	var btn_box := Rect2(-6.0, 0.0, 12.0, 16.0)
	draw_rect(btn_box, Color("2c3b44"))
	draw_rect(btn_box, COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	
	# Tactile call button
	var btn_col := COLOR_CYAN if is_activated else COLOR_AMBER
	draw_circle(Vector2(0.0, 6.0), 2.8, btn_col)
	if is_activated:
		draw_circle(Vector2(0.0, 6.0), 5.5, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.4))
	
	# Acoustic speaker perforations
	for i in range(2):
		var sy := 11.0 + float(i) * 2.5
		draw_circle(Vector2(-2.0, sy), 0.8, Color("12191f"))
		draw_circle(Vector2(2.0, sy), 0.8, Color("12191f"))


func _draw_transit_shelter() -> void:
	# Timetable board & route schematic on shelter wall (28x36 px)
	var board_rect := Rect2(-14.0, -18.0, 28.0, 36.0)
	draw_rect(board_rect, Color("1a2730"))
	draw_rect(board_rect, COLOR_INFRASTRUCTURE * 0.7, false, 1.2)
	
	# Header strip: "LINIA 4 // ROZKŁAD"
	draw_rect(Rect2(-12.0, -16.0, 24.0, 6.0), Color("283f4f"))
	draw_line(Vector2(-10.0, -13.0), Vector2(10.0, -13.0), COLOR_INFRASTRUCTURE, 1.0)
	
	# Timetable rows
	for i in range(4):
		var y := -7.0 + float(i) * 4.0
		draw_line(Vector2(-10.0, y), Vector2(6.0, y), COLOR_INFRASTRUCTURE * 0.5, 1.0)
	
	# Red strike-through warning tape: "TRASA ZAWIESZONA / AUTOBUS ZASTĘPCZY"
	var tape_pts := PackedVector2Array([
		Vector2(-13.0, 3.0),
		Vector2(13.0, 1.0),
		Vector2(13.0, 7.0),
		Vector2(-13.0, 9.0),
	])
	draw_polygon(tape_pts, [Color("8f3833", 0.85)])
	draw_line(Vector2(-11.0, 6.0), Vector2(11.0, 4.0), Color("f0e6e6"), 1.0)
	
	# Route terminus marker dot
	draw_circle(Vector2(9.0, 13.0), 1.8, COLOR_CYAN if is_activated else COLOR_AMBER)


func _draw_bus_speaker() -> void:
	# Ceiling institutional intercom / speaker housing (24x12 px)
	var housing_rect := Rect2(-12.0, -6.0, 24.0, 12.0)
	draw_rect(housing_rect, COLOR_DARK_STEEL)
	draw_rect(housing_rect, COLOR_INFRASTRUCTURE * 0.8, false, 1.0)
	
	# Perforated circular grille
	draw_circle(Vector2.ZERO, 4.2, COLOR_BACKGROUND)
	draw_circle(Vector2.ZERO, 4.2, COLOR_INFRASTRUCTURE * 0.6, false, 0.8)
	
	# Acoustic aperture matrix (3x3 micro holes)
	for dx in [-2.0, 0.0, 2.0]:
		for dy in [-2.0, 0.0, 2.0]:
			draw_circle(Vector2(dx, dy), 0.6, Color("0a0f14"))
	
	# Institutional telemetry diode (Amber pulse on announcement)
	var diode_col := COLOR_AMBER if is_activated else COLOR_CYAN * 0.7
	draw_circle(Vector2(8.5, 0.0), 1.4, diode_col)
	
	# Sound emission arcs when active
	if is_activated or is_player_in_range:
		var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
		var arc_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.35 + pulse * 0.45)
		draw_arc(Vector2(0.0, 6.0), 6.0 + pulse * 3.0, 0.2 * PI, 0.8 * PI, 8, arc_col, 1.2)
		draw_arc(Vector2(0.0, 6.0), 10.0 + pulse * 4.0, 0.25 * PI, 0.75 * PI, 8, arc_col * 0.6, 1.0)


func _draw_elderly_passenger() -> void:
	# Elderly passenger seated in municipal bus (profile facing left towards aisle)
	# Body / Heavy coat
	var coat_col := Color("1e2c34")
	var coat_pts := PackedVector2Array([
		Vector2(12.0, 14.0),
		Vector2(-6.0, 14.0),
		Vector2(-10.0, 0.0),
		Vector2(-8.0, -10.0),
		Vector2(6.0, -12.0),
		Vector2(12.0, 0.0),
	])
	draw_polygon(coat_pts, [coat_col])
	draw_polyline(coat_pts, COLOR_INFRASTRUCTURE * 0.4, 1.0)
	
	# Lapel / Scarf
	draw_line(Vector2(-3.0, -10.0), Vector2(1.0, 2.0), COLOR_INFRASTRUCTURE * 0.7, 1.5)
	
	# Head / Wool beanie
	draw_circle(Vector2(-1.0, -17.0), 5.5, Color("141c22"))
	draw_circle(Vector2(-1.0, -17.0), 5.0, COLOR_INFRASTRUCTURE * 0.6) # Beanie cap
	draw_circle(Vector2(-3.0, -15.0), 3.5, Color("cf9b72")) # Face profile
	
	# Hands on knees holding the gold ring / gesture
	draw_circle(Vector2(-7.0, 6.0), 2.2, Color("cf9b72"))
	
	# Subtle eye / calm observant gaze
	draw_circle(Vector2(-4.5, -15.5), 0.7, Color("141c22"))


func _draw_gold_ring() -> void:
	# Gold wedding ring on bus seat fabric (warm amber/gold #E6B450)
	var pulse := sin(_pulse_phase * 2.5) * 0.5 + 0.5
	var gold_col := Color("e6b450")
	var gold_shadow := Color("7a5618")
	var gold_highlight := Color("fff2b2")
	
	# Filament warmth disc beneath ring
	var glow_rad := 7.0 + pulse * 2.5
	draw_circle(Vector2.ZERO, glow_rad, Color(gold_col.r, gold_col.g, gold_col.b, 0.22 + pulse * 0.20))
	
	# Ring geometry: outer circle & inner hollow
	draw_circle(Vector2.ZERO, 3.8, gold_col)
	draw_circle(Vector2.ZERO, 2.2, Color("1a2630")) # Seat fabric background
	draw_circle(Vector2.ZERO, 3.8, gold_shadow, false, 0.8)
	
	# Specular reflection gleam
	draw_circle(Vector2(-1.4, -1.4), 0.9, gold_highlight)
	
	# Radial micro-light beams when inspected/activated
	if is_activated or is_player_in_range:
		var beam_len := 6.0 + pulse * 2.0
		var beam_col := Color(gold_col.r, gold_col.g, gold_col.b, 0.5 + pulse * 0.3)
		for angle_deg in [0.0, 72.0, 144.0, 216.0, 288.0]:
			var rad: float = deg_to_rad(angle_deg + _pulse_phase * 20.0)
			var p1 := Vector2(cos(rad), sin(rad)) * 4.2
			var p2 := Vector2(cos(rad), sin(rad)) * (4.2 + beam_len)
			draw_line(p1, p2, beam_col, 1.0)


func _draw_bus_route_map() -> void:
	# Institutional overhead route board: "LINIA ZASTĘPCZA 4" (44x16 px)
	var board_rect := Rect2(-22.0, -8.0, 44.0, 16.0)
	draw_rect(board_rect, Color("141e26"))
	draw_rect(board_rect, COLOR_INFRASTRUCTURE * 0.75, false, 1.0)
	
	# Route strip track line
	draw_line(Vector2(-18.0, 0.0), Vector2(18.0, 0.0), COLOR_CYAN * 0.8, 1.5)
	
	# Station dots:
	# 1. IKP (origin - checked)
	draw_circle(Vector2(-16.0, 0.0), 2.2, COLOR_CYAN)
	# 2. Closed stations on Line 4 (crossed out with red cinnabar)
	draw_circle(Vector2(-6.0, 0.0), 1.8, COLOR_CORRECTION)
	draw_line(Vector2(-8.0, -2.5), Vector2(-4.0, 2.5), COLOR_CORRECTION, 1.2)
	draw_line(Vector2(-8.0, 2.5), Vector2(-4.0, -2.5), COLOR_CORRECTION, 1.2)
	
	draw_circle(Vector2(4.0, 0.0), 1.8, COLOR_CORRECTION)
	draw_line(Vector2(2.0, -2.5), Vector2(6.0, 2.5), COLOR_CORRECTION, 1.2)
	draw_line(Vector2(2.0, 2.5), Vector2(6.0, -2.5), COLOR_CORRECTION, 1.2)
	
	# 3. Osiedle Tarasowe (destination - pulsing amber)
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	draw_circle(Vector2(14.0, 0.0), 2.4, COLOR_AMBER)
	draw_circle(Vector2(14.0, 0.0), 3.6 + pulse * 1.5, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.35), false, 0.8)


func _draw_tenant_directory() -> void:
	# Modernist resident directory board on staircase landing (44x32 px)
	var board_rect := Rect2(-22.0, -16.0, 44.0, 32.0)
	draw_rect(board_rect, Color("121a20"))
	draw_rect(board_rect, COLOR_INFRASTRUCTURE * 0.8, false, 1.2)
	
	# Header strip: "BLOK 7 / OS. TARASOWE"
	draw_rect(Rect2(-20.0, -14.0, 40.0, 5.0), Color("1e2a32"))
	draw_line(Vector2(-18.0, -11.5), Vector2(-4.0, -11.5), COLOR_INFRASTRUCTURE * 0.9, 1.0)
	
	# Resident list entries (stairwell floor 4 & 5)
	# M. 11 & 12
	draw_line(Vector2(-18.0, -5.0), Vector2(6.0, -5.0), COLOR_INFRASTRUCTURE * 0.45, 1.0)
	draw_line(Vector2(-18.0, -1.0), Vector2(10.0, -1.0), COLOR_INFRASTRUCTURE * 0.45, 1.0)
	
	# M. 13 — Bera S. [V p.]
	draw_line(Vector2(-18.0, 3.0), Vector2(8.0, 3.0), COLOR_INFRASTRUCTURE * 0.55, 1.0)
	
	# M. 14 — Wolska L. / Kurek M. [V p.] (Highlighted with warm amber tag)
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	var highlight_col := COLOR_AMBER if (is_activated or is_player_in_range) else COLOR_AMBER * 0.75
	draw_rect(Rect2(-19.0, 6.0, 38.0, 6.0), Color(highlight_col.r, highlight_col.g, highlight_col.b, 0.18 + pulse * 0.15))
	draw_line(Vector2(-17.0, 9.0), Vector2(14.0, 9.0), highlight_col, 1.2)
	draw_circle(Vector2(-17.0, 9.0), 1.5, highlight_col)


func _draw_mailboxes() -> void:
	# Steel multi-compartment mailboxes module (48x28 px)
	var box_rect := Rect2(-24.0, -14.0, 48.0, 28.0)
	draw_rect(box_rect, Color("1e2b34"))
	draw_rect(box_rect, COLOR_INFRASTRUCTURE * 0.85, false, 1.2)
	
	# 4 Individual mailbox doors (2x2 grid)
	var cells := [
		Rect2(-22.0, -12.0, 20.0, 10.0), # M. 11
		Rect2(2.0, -12.0, 20.0, 10.0),   # M. 12
		Rect2(-22.0, 2.0, 20.0, 10.0),   # M. 13
		Rect2(2.0, 2.0, 20.0, 10.0),     # M. 14 (Wolska / Kurek)
	]
	
	for i in range(cells.size()):
		var cell: Rect2 = cells[i]
		draw_rect(cell, Color("17232b"))
		draw_rect(cell, COLOR_DARK_STEEL, false, 1.0)
		# Horizontal mail drop slot
		draw_line(Vector2(cell.position.x + 3.0, cell.position.y + 3.0), Vector2(cell.position.x + cell.size.x - 3.0, cell.position.y + 3.0), Color("0a1014"), 1.2)
		# Keyhole
		draw_circle(Vector2(cell.position.x + cell.size.x - 4.0, cell.position.y + 7.0), 0.8, COLOR_INFRASTRUCTURE * 0.7)
	
	# Mailbox 14 (index 3): Protruding UCP notices / uncollected official mail
	var pulse := sin(_pulse_phase * 2.2) * 0.5 + 0.5
	var paper_col := Color("e8e2d2")
	# Envelope corner sticking out of slot
	var p_pts := PackedVector2Array([
		Vector2(6.0, 4.0),
		Vector2(18.0, 1.0 - pulse * 0.8),
		Vector2(19.0, 5.0),
		Vector2(8.0, 7.0)
	])
	draw_colored_polygon(p_pts, paper_col)
	# Official red/oxide stamp mark on envelope
	draw_rect(Rect2(12.0, 2.5, 4.0, 2.5), COLOR_CORRECTION)
	draw_line(Vector2(7.0, 5.5), Vector2(17.0, 3.5), Color("20262c"), 0.8)


func _draw_blind_stairs() -> void:
	# Concrete stairs ending abruptly into a solid monolithic wall / truncated ceiling (#geometry-restless-grid)
	# Step profiles (ascending right towards solid barrier)
	var step1 := Rect2(-24.0, 8.0, 14.0, 8.0)
	var step2 := Rect2(-10.0, 0.0, 14.0, 8.0)
	var step3 := Rect2(4.0, -8.0, 14.0, 8.0)
	
	# Terrazzo treads
	draw_rect(step1, Color("4a5860"))
	draw_rect(step2, Color("53646d"))
	draw_rect(step3, Color("5c6f7a"))
	
	# Solid concrete slab / sheer wall blocking the ascending flight at x=18
	var wall_rect := Rect2(16.0, -22.0, 16.0, 38.0)
	draw_rect(wall_rect, Color("222f37"))
	draw_rect(wall_rect, COLOR_DARK_STEEL, false, 1.2)
	# Rough unplastered concrete joints
	draw_line(Vector2(16.0, -10.0), Vector2(32.0, -10.0), Color("151e24"), 1.0)
	draw_line(Vector2(16.0, 4.0), Vector2(32.0, 4.0), Color("151e24"), 1.0)
	
	# Oxide cinnabar hazard warning tape / barrier across the dead-end flight
	var pulse := sin(_pulse_phase * 1.8) * 0.5 + 0.5
	var warn_col := COLOR_CORRECTION if not is_activated else Color("d4726d")
	draw_line(Vector2(-12.0, -2.0), Vector2(16.0, -12.0), warn_col, 2.0)
	# Diagonal hazard slashes
	for d in range(5):
		var px: float = -8.0 + d * 5.0
		var py: float = -3.5 - d * 1.8
		draw_line(Vector2(px - 1.5, py + 2.0), Vector2(px + 1.5, py - 2.0), Color("12181c"), 1.0)
	
	# Stencil symbol on concrete shear wall
	draw_circle(Vector2(24.0, -4.0), 3.2, warn_col, false, 1.0)
	draw_line(Vector2(21.5, -4.0), Vector2(26.5, -4.0), warn_col, 1.2)


func _draw_marta_interaction() -> void:
	# Marta Kurek standing in the doorway of Apt 14 (18x36 px)
	# Identity markers: long pink hair and a steel septum keep her legible apart
	# from Lena in every small residential encounter.
	# Wider center of gravity, dark layered work jacket with chalk/plaster marks,
	# tool bag slung across chest, folding ruler in leg pocket, observant calm gaze.
	
	# Warm amber domestic hallway glow behind Marta
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	var glow_alpha := 0.25 + pulse * 0.15
	draw_circle(Vector2(4.0, -4.0), 22.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, glow_alpha))
	
	# 1. Legs & Heavy boots
	draw_rect(Rect2(-7.0, 8.0, 5.0, 10.0), Color("182329"))
	draw_rect(Rect2(1.0, 8.0, 5.0, 10.0), Color("182329"))
	draw_rect(Rect2(-8.0, 16.0, 6.5, 3.5), Color("10161a")) # Boot left
	draw_rect(Rect2(0.5, 16.0, 6.5, 3.5), Color("10161a"))  # Boot right
	
	# 2. Torso & Layered work jacket (sage green / muted dark canvas #2B3D36)
	var torso_rect := Rect2(-8.0, -8.0, 15.0, 17.0)
	draw_rect(torso_rect, Color("2b3d36"))
	draw_rect(torso_rect, Color("3a5148"), false, 1.0)
	
	# Chalk / plaster marks on sleeve & pocket (authentic artisan texture)
	draw_line(Vector2(-6.0, 0.0), Vector2(-3.0, 3.0), Color("8a9e96"), 0.8)
	draw_line(Vector2(-5.0, 4.0), Vector2(-2.0, 4.0), Color("8a9e96"), 0.8)
	
	# 3. Canvas tool bag strap across chest (diagonal from right shoulder to left hip)
	draw_line(Vector2(4.0, -8.0), Vector2(-7.0, 6.0), Color("6e5944"), 2.2)
	# Heavy rectangular canvas tool bag on left hip
	draw_rect(Rect2(-12.0, 0.0, 6.0, 9.0), Color("4a3c2e"))
	draw_rect(Rect2(-12.0, 0.0, 6.0, 9.0), Color("6e5944"), false, 0.8)
	
	# 4. Folded wooden folding ruler (calówka) peeking from right thigh pocket
	draw_rect(Rect2(4.0, 4.0, 2.5, 6.0), COLOR_AMBER)
	draw_line(Vector2(4.0, 6.0), Vector2(6.5, 6.0), Color("1c242a"), 0.6)
	draw_line(Vector2(4.0, 8.0), Vector2(6.5, 8.0), Color("1c242a"), 0.6)
	
	# 5. Long pink hair, face & steel septum.
	var marta_hair_shadow := Color("6d294f")
	var marta_hair_pink := Color("d45b9a")
	var marta_skin := Color("d39a62")
	draw_circle(Vector2(-0.5, -13.0), 5.2, marta_hair_shadow)
	draw_rect(Rect2(-5.2, -12.0, 3.0, 14.0), marta_hair_shadow)
	draw_rect(Rect2(2.0, -12.0, 3.0, 14.0), marta_hair_shadow)
	draw_circle(Vector2(-1.5, -12.5), 3.8, marta_skin)
	draw_line(Vector2(-4.5, -15.8), Vector2(2.6, -17.2), marta_hair_pink, 2.0)
	draw_line(Vector2(-4.8, -10.0), Vector2(-4.8, 1.0), marta_hair_pink, 1.5)
	draw_line(Vector2(2.8, -10.0), Vector2(2.8, 1.0), marta_hair_pink, 1.5)
	draw_circle(Vector2(-3.5, -13.0), 0.8, Color("141c22")) # Observant eye
	draw_arc(Vector2(0.4, -11.4), 1.15, 0.15, PI - 0.15, 6, Color("c7d3d6"), 0.8) # Septum
	
	# 6. Hand posture: one hand resting on door frame, one holding tool bag strap
	draw_circle(Vector2(-6.0, 4.0), 1.8, Color("d39a62")) # Hand on bag strap
	draw_circle(Vector2(7.0, -2.0), 1.6, Color("d39a62")) # Hand near door edge


func _draw_stair_timer_switch() -> void:
	# Classic modernist staircase timer push-button with amber neon pilot glow (16x16 px)
	var plate_rect := Rect2(-7.0, -7.0, 14.0, 14.0)
	draw_rect(plate_rect, Color("222e36"))
	draw_rect(plate_rect, COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	
	# Mounting screws
	draw_circle(Vector2(0.0, -5.0), 0.7, COLOR_INFRASTRUCTURE * 0.9)
	draw_circle(Vector2(0.0, 5.0), 0.7, COLOR_INFRASTRUCTURE * 0.9)
	
	# Center push button (circular)
	draw_circle(Vector2.ZERO, 3.6, Color("141c22"))
	draw_circle(Vector2.ZERO, 2.4, Color("354652"))
	
	# Glowing orange/amber neon pilot lamp in center
	var pulse := sin(_pulse_phase * 3.0) * 0.5 + 0.5
	var neon_alpha := 0.6 + pulse * 0.4
	var neon_col := Color("ff9e3b")
	draw_circle(Vector2.ZERO, 1.4, Color(neon_col.r, neon_col.g, neon_col.b, neon_alpha))
	draw_circle(Vector2.ZERO, 3.2 + pulse * 1.2, Color(neon_col.r, neon_col.g, neon_col.b, 0.25 * neon_alpha))


func _draw_hallway_coat_rack() -> void:
	# Modernist wooden coat rack strip with brass pegs, hanging coats and rain boots (28x36 px)
	# Wall rack strip
	var rack_bar := Rect2(-14.0, -18.0, 28.0, 4.0)
	draw_rect(rack_bar, Color("4a3525")) # Teak wood
	draw_rect(rack_bar, Color("6e4e35"), false, 0.8)
	
	# Brass hooks (left, center, right)
	draw_circle(Vector2(-8.0, -16.0), 1.5, Color("cda35d"))
	draw_circle(Vector2(0.0, -16.0), 1.5, Color("cda35d"))
	draw_circle(Vector2(8.0, -16.0), 1.5, Color("cda35d"))
	
	# Coat 1 (Left hook - Lena's long dark graphite coat)
	var coat1_rect := Rect2(-12.0, -15.0, 8.0, 22.0)
	draw_rect(coat1_rect, Color("1a242a"))
	draw_rect(coat1_rect, Color("2a3740"), false, 0.8)
	draw_line(Vector2(-8.0, -15.0), Vector2(-8.0, 5.0), Color("141c22"), 1.0) # Fold/seam
	
	# Coat 2 (Center/Right hook - Marta's work jacket with chalk/paint traces)
	var coat2_rect := Rect2(-2.0, -15.0, 9.0, 16.0)
	draw_rect(coat2_rect, Color("2b3d36"))
	draw_rect(coat2_rect, Color("3a5148"), false, 0.8)
	# Chalk marks on canvas jacket
	draw_line(Vector2(0.0, -8.0), Vector2(3.0, -5.0), Color("8a9e96"), 0.8)
	draw_line(Vector2(1.0, -3.0), Vector2(4.0, -3.0), Color("8a9e96"), 0.8)
	
	# Rain boots left on rubber mat beneath (at y=10..18)
	var mat_rect := Rect2(-13.0, 14.0, 26.0, 4.0)
	draw_rect(mat_rect, Color("141a1f"))
	draw_rect(mat_rect, Color("242d35"), false, 0.8)
	# Pair of dark rain boots left behind 17 days ago
	draw_rect(Rect2(-8.0, 6.0, 6.0, 10.0), Color("10161a"))
	draw_rect(Rect2(2.0, 6.0, 6.0, 10.0), Color("10161a"))
	draw_rect(Rect2(-9.0, 13.0, 7.0, 3.5), Color("0b0f12"))
	draw_rect(Rect2(1.0, 13.0, 7.0, 3.5), Color("0b0f12"))


func _draw_reflected_photograph() -> void:
	# Framed photograph of Marta and local Lena (24x20 px)
	# Framing per VISUAL_DESIGN.md & FULL_STORY 08: Lena is framed strictly from behind or in reflection, never direct face
	var frame_rect := Rect2(-12.0, -10.0, 24.0, 20.0)
	var photo_rect := Rect2(-10.0, -8.0, 20.0, 16.0)
	
	# Modernist wooden frame with brass corners
	draw_rect(frame_rect, Color("3d2c1e"))
	draw_rect(frame_rect, Color("cda35d"), false, 0.8)
	
	# Photo paper (monochrome warm tint)
	draw_rect(photo_rect, Color("263238"))
	
	# Rainy window reflection background
	draw_line(Vector2(-8.0, -6.0), Vector2(6.0, 6.0), Color(0.46, 0.78, 0.76, 0.15), 1.0)
	draw_line(Vector2(-4.0, -6.0), Vector2(8.0, 4.0), Color(0.46, 0.78, 0.76, 0.15), 1.0)
	
	# Silhouette 1: Marta on left, profile facing towards Lena
	draw_circle(Vector2(-5.0, -3.0), 3.0, Color("182329")) # Marta's head
	draw_rect(Rect2(-7.0, 0.0, 5.0, 8.0), Color("2b3d36")) # Marta's torso
	
	# Silhouette 2: Local Lena on right, framed strictly FROM BEHIND (looking toward rainy window)
	draw_circle(Vector2(4.0, -3.5), 3.2, Color("141c22")) # Lena's hair from behind
	draw_rect(Rect2(1.5, -0.5, 6.0, 8.5), Color("1e2a32")) # Coat back
	draw_line(Vector2(4.0, 0.0), Vector2(4.0, 7.0), Color("12181d"), 0.8) # Back center seam
	
	# Subtle glass reflection glaze
	draw_line(Vector2(-10.0, 2.0), Vector2(0.0, -8.0), Color(1.0, 1.0, 1.0, 0.12), 1.0)


func _draw_beaker_planter() -> void:
	# 200ml Laboratory beaker repurposed as a domestic succulent planter (16x20 px)
	# Dual-purpose object (#composition-negative-space): institutional equipment becomes domestic shelter
	var beaker_rect := Rect2(-6.0, -6.0, 12.0, 16.0)
	
	# Potting soil inside
	draw_rect(Rect2(-5.0, -1.0, 10.0, 10.0), Color("2b1d15"))
	
	# Translucent cyan-tinted glass beaker walls
	draw_rect(beaker_rect, Color(0.46, 0.78, 0.76, 0.18))
	draw_rect(beaker_rect, Color(0.46, 0.78, 0.76, 0.8), false, 1.0)
	
	# Spout at top left
	draw_line(Vector2(-6.0, -6.0), Vector2(-8.0, -8.0), Color(0.46, 0.78, 0.76, 0.9), 1.0)
	draw_line(Vector2(-8.0, -8.0), Vector2(-5.0, -6.0), Color(0.46, 0.78, 0.76, 0.9), 1.0)
	
	# Etched graduation lines (50, 100, 150, 200 ml)
	draw_line(Vector2(2.0, 6.0), Vector2(5.0, 6.0), Color("e0e6e4"), 0.8)
	draw_line(Vector2(2.0, 2.0), Vector2(5.0, 2.0), Color("e0e6e4"), 0.8)
	draw_line(Vector2(2.0, -2.0), Vector2(5.0, -2.0), Color("e0e6e4"), 0.8)
	
	# Succulent plant sprouting upwards (jade green leaves)
	draw_circle(Vector2(0.0, -3.0), 3.2, Color("3e6350"))
	draw_circle(Vector2(-3.0, -6.0), 2.5, Color("4f7d66"))
	draw_circle(Vector2(3.0, -6.0), 2.5, Color("4f7d66"))
	draw_circle(Vector2(0.0, -9.0), 2.2, Color("5c9176"))
	# Small amber budding flower in center
	draw_circle(Vector2(0.0, -11.0), 1.4, COLOR_AMBER)


func _draw_jakub_memento_tool() -> void:
	# Jakub's technical memento used as a drafting paperweight / spirit level (26x16 px)
	# Sheet of cyan technical blueprint on desk
	var sheet_rect := Rect2(-12.0, -4.0, 24.0, 14.0)
	draw_rect(sheet_rect, Color("203340"))
	draw_rect(sheet_rect, Color("385b73"), false, 0.8)
	# Fine orthogonal grid lines on draft paper
	draw_line(Vector2(-8.0, -4.0), Vector2(-8.0, 10.0), Color(0.46, 0.78, 0.76, 0.25), 0.6)
	draw_line(Vector2(0.0, -4.0), Vector2(0.0, 10.0), Color(0.46, 0.78, 0.76, 0.25), 0.6)
	draw_line(Vector2(8.0, -4.0), Vector2(8.0, 10.0), Color(0.46, 0.78, 0.76, 0.25), 0.6)
	draw_line(Vector2(-12.0, 2.0), Vector2(12.0, 2.0), Color(0.46, 0.78, 0.76, 0.25), 0.6)
	
	# Solid milled brass spirit level / memento resting on top
	var level_rect := Rect2(-9.0, -6.0, 18.0, 7.0)
	draw_rect(level_rect, Color("8f6f32"))
	draw_rect(level_rect, Color("cda35d"), false, 1.0)
	
	# Center glass vial with glowing cyan air bubble
	var vial_rect := Rect2(-4.0, -4.5, 8.0, 4.0)
	draw_rect(vial_rect, Color("142229"))
	draw_rect(vial_rect, Color(0.46, 0.78, 0.76, 0.5), false, 0.8)
	draw_circle(Vector2(0.5, -2.5), 1.2, Color("75c7c3")) # Center balanced bubble
	
	# Engraved initials "J.W." stencil
	draw_circle(Vector2(-6.5, -2.5), 0.7, Color("4a391a"))
	draw_circle(Vector2(6.5, -2.5), 0.7, Color("4a391a"))


func _draw_cipher_desk() -> void:
	# Heavy modernist study desk with combination lock drawer & gooseneck lamp (42x32 px)
	var desk_rect := Rect2(-20.0, -10.0, 40.0, 24.0)
	
	# Desktop surface (dark stained oak / teak)
	draw_rect(desk_rect, Color("38271a"))
	draw_rect(desk_rect, Color("543b27"), false, 1.0)
	
	# Desk legs / pedestal
	draw_rect(Rect2(-18.0, 14.0, 4.0, 12.0), Color("241910"))
	draw_rect(Rect2(14.0, 14.0, 4.0, 12.0), Color("241910"))
	
	# Gooseneck desk lamp on left
	draw_line(Vector2(-14.0, -10.0), Vector2(-14.0, -18.0), Color("cda35d"), 1.2)
	draw_line(Vector2(-14.0, -18.0), Vector2(-8.0, -16.0), Color("cda35d"), 1.2)
	draw_circle(Vector2(-7.0, -15.0), 3.0, Color("423223")) # Shade
	# Warm filament light cone onto desk
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	var lamp_alpha := 0.22 + pulse * 0.08
	var cone_points := PackedVector2Array([
		Vector2(-7.0, -15.0),
		Vector2(-18.0, -2.0),
		Vector2(4.0, -2.0)
	])
	draw_colored_polygon(cone_points, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, lamp_alpha))
	
	# Top-right drawer with mechanical combination dial
	var drawer_rect := Rect2(2.0, -6.0, 16.0, 10.0)
	if is_activated:
		# Drawer pulled out slightly, revealing foreign handwritten sheets & Substructure sketches
		drawer_rect = Rect2(2.0, -2.0, 16.0, 12.0)
		draw_rect(drawer_rect, Color("2e1f14"))
		draw_rect(drawer_rect, COLOR_CYAN * 0.8, false, 1.0)
		
		# White/yellowed technical draft sheets peeking out
		draw_rect(Rect2(4.0, -4.0, 12.0, 6.0), Color("dcd8cd"))
		draw_line(Vector2(5.0, -2.0), Vector2(14.0, -2.0), Color("2b3d36"), 0.8) # Formula lines
		draw_line(Vector2(5.0, 0.0), Vector2(12.0, 0.0), Color("2b3d36"), 0.8)
		# Cyan unlocked bolt indicator
		draw_circle(Vector2(10.0, 4.0), 1.5, COLOR_CYAN)
	else:
		# Locked drawer flush with desk
		draw_rect(drawer_rect, Color("2b1d13"))
		draw_rect(drawer_rect, Color("4a3321"), false, 0.8)
		# Brass 4-dial combination lock faceplate
		draw_rect(Rect2(7.0, -3.0, 6.0, 4.0), Color("8f6f32"))
		draw_circle(Vector2(10.0, -1.0), 1.2, Color("cda35d"))


func _draw_tea_kettle() -> void:
	# Enameled tea kettle on stovetop with steam whistle and ceramic mugs (24x22 px)
	# Stovetop burner base
	var stove_rect := Rect2(-10.0, 4.0, 20.0, 4.0)
	draw_rect(stove_rect, Color("202a30"))
	draw_rect(stove_rect, COLOR_INFRASTRUCTURE * 0.7, false, 0.8)
	
	# Gas flamelets beneath kettle (blue/cyan)
	var pulse := sin(_pulse_phase * 4.0) * 0.5 + 0.5
	var flame_alpha := 0.6 + pulse * 0.3
	draw_circle(Vector2(-5.0, 4.0), 1.5, Color(0.46, 0.78, 0.76, flame_alpha))
	draw_circle(Vector2(0.0, 4.0), 1.5, Color(0.46, 0.78, 0.76, flame_alpha))
	draw_circle(Vector2(5.0, 4.0), 1.5, Color(0.46, 0.78, 0.76, flame_alpha))
	
	# Kettle body (dark charcoal enamel #26333c with stainless lid)
	draw_circle(Vector2(0.0, -2.0), 6.5, Color("26333c"))
	draw_rect(Rect2(-4.0, -8.0, 8.0, 3.0), Color("a8b2ac")) # Polished lid
	draw_circle(Vector2(0.0, -8.5), 1.2, Color("141a1f")) # Lid knob
	
	# Arching black handle over top
	draw_arc(Vector2(0.0, -6.0), 7.0, -PI * 0.85, -PI * 0.15, 8, Color("141a1f"), 1.4)
	
	# Spout on left emitting steam plumes
	draw_line(Vector2(-5.0, -2.0), Vector2(-10.0, -6.0), Color("26333c"), 2.0)
	var steam_pulse := sin(_pulse_phase * 3.5) * 0.5 + 0.5
	draw_circle(Vector2(-12.0 - steam_pulse * 2.0, -8.0 - steam_pulse * 4.0), 2.0 + steam_pulse * 1.5, Color(1.0, 1.0, 1.0, 0.25 * (1.0 - steam_pulse * 0.5)))
	
	# Two ceramic mugs on cork coaster next to stove (x=7..13)
	draw_rect(Rect2(7.0, 2.0, 5.0, 6.0), Color("dcd8cd")) # White ceramic mug
	draw_rect(Rect2(7.0, 2.0, 5.0, 6.0), Color("8a9e96"), false, 0.8)


func _draw_bathroom_sink() -> void:
	# Modernist ceramic washbasin with chrome fixtures (28x22 px)
	# Ceramic basin body (white ceramic #dcd8cd with subtle sage rim)
	var basin_rect := Rect2(-14.0, -4.0, 28.0, 14.0)
	draw_rect(basin_rect, Color("dcd8cd"))
	draw_rect(basin_rect, Color("8a9e96"), false, 1.0)
	
	# Inner basin bowl depth contour
	draw_rect(Rect2(-10.0, -1.0, 20.0, 9.0), Color("c5c2b6"))
	# Chrome drain ring & plug hole
	draw_circle(Vector2(0.0, 3.5), 2.2, COLOR_DARK_STEEL)
	draw_circle(Vector2(0.0, 3.5), 1.2, COLOR_INFRASTRUCTURE)
	
	# Chrome gooseneck faucet above basin
	draw_line(Vector2(0.0, -4.0), Vector2(0.0, -14.0), COLOR_INFRASTRUCTURE, 2.0)
	draw_line(Vector2(0.0, -14.0), Vector2(-4.0, -12.0), COLOR_INFRASTRUCTURE, 2.0)
	draw_line(Vector2(0.0, -14.0), Vector2(-4.0, -12.0), Color("e0e8e4"), 1.0) # Chrome glint
	
	# Hot & Cold rotary valve knobs
	draw_rect(Rect2(-7.0, -7.0, 3.0, 3.0), COLOR_CORRECTION * 0.8) # Hot (cinnabar)
	draw_rect(Rect2(4.0, -7.0, 3.0, 3.0), COLOR_CYAN * 0.8) # Cold (cyan)
	
	# S-trap exposed drain pipe down into wall
	draw_line(Vector2(0.0, 10.0), Vector2(0.0, 16.0), Color("263943"), 2.0)
	draw_line(Vector2(0.0, 16.0), Vector2(6.0, 20.0), Color("263943"), 2.0)
	draw_line(Vector2(6.0, 20.0), Vector2(10.0, 16.0), Color("263943"), 2.0)
	
	# Water droplet forming / dripping from spout
	var drop_phase := fmod(_pulse_phase * 1.8, 1.0)
	var drop_y := -11.0 + drop_phase * 14.0
	var drop_alpha := clampf(1.0 - drop_phase * 0.4, 0.2, 0.9)
	draw_circle(Vector2(-4.0, drop_y), 1.2, Color(0.46, 0.78, 0.76, drop_alpha))
	
	# Ceramic soap dish with bar of soap on left rim
	draw_rect(Rect2(-12.0, -6.0, 5.0, 2.0), Color("e8e6df"))
	draw_rect(Rect2(-11.0, -8.0, 3.5, 2.0), Color("d39a62") * 0.9)


func _draw_bathroom_mirror() -> void:
	# Framed bathroom mirror with delayed / asynchronous reflection (32x44 px)
	var frame_rect := Rect2(-16.0, -22.0, 32.0, 44.0)
	var mirror_rect := Rect2(-14.0, -20.0, 28.0, 40.0)
	
	# Dark zinc / lead frame with wall brackets
	draw_rect(frame_rect, Color("1a242a"))
	draw_rect(frame_rect, COLOR_DARK_STEEL, false, 1.2)
	# Wall mounting screw studs at corners
	draw_circle(Vector2(-14.0, -20.0), 1.0, COLOR_INFRASTRUCTURE)
	draw_circle(Vector2(14.0, -20.0), 1.0, COLOR_INFRASTRUCTURE)
	draw_circle(Vector2(-14.0, 20.0), 1.0, COLOR_INFRASTRUCTURE)
	draw_circle(Vector2(14.0, 20.0), 1.0, COLOR_INFRASTRUCTURE)
	
	# Silvered mirror surface with subtle reflection gradient
	draw_rect(mirror_rect, Color("283b47"))
	draw_rect(Rect2(-14.0, -20.0, 28.0, 20.0), Color("2f4553"))
	
	# Diagonal reflection glint lines
	draw_line(Vector2(-10.0, -18.0), Vector2(10.0, 18.0), Color(0.6, 0.75, 0.8, 0.18), 1.0)
	draw_line(Vector2(-6.0, -18.0), Vector2(14.0, 14.0), Color(0.6, 0.75, 0.8, 0.12), 1.0)
	
	# Ghostly delayed reflection silhouette of Lena & distant doorway in mirror
	var ghost_pulse := sin(_pulse_phase * 1.5) * 0.5 + 0.5
	var ghost_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.28 + ghost_pulse * 0.14)
	# Reflected doorway frame in background
	draw_rect(Rect2(2.0, -14.0, 8.0, 26.0), Color(0.12, 0.18, 0.22, 0.75))
	draw_rect(Rect2(2.0, -14.0, 8.0, 26.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.3), false, 0.8)
	# Reflected silhouette of Lena
	draw_circle(Vector2(-2.0, -4.0), 4.5, ghost_col) # Head
	draw_rect(Rect2(-5.0, 0.0, 6.0, 12.0), ghost_col) # Body & coat
	# Subtle asymmetry: coat flap in reflection
	draw_line(Vector2(-5.0, 4.0), Vector2(-8.0, 10.0), ghost_col, 1.2)


func _draw_scratched_inscription() -> void:
	# Scratched inscription on mirror glass: "NIE SZUKAJ ORYGINAŁU" (Clue R-02)
	# When viewed from front or unactivated: faint subtle scratches
	# When illuminated under oblique angle / activated: crisp glowing cyan & amber lines
	var pulse := sin(_pulse_phase * 2.5) * 0.5 + 0.5
	var is_lit := is_activated or is_player_in_range
	var alpha := 0.95 if is_lit else 0.25
	var col_scratch := COLOR_CYAN if is_lit else Color("405560")
	var col_amber := COLOR_AMBER if is_lit else Color("453a2f")
	
	# Etched razor score lines across the glass pane
	# Line 1: "NIE SZUKAJ" (symbolic geometric line groups)
	# N
	draw_line(Vector2(-16.0, -6.0), Vector2(-16.0, -1.0), col_scratch, 1.0)
	draw_line(Vector2(-16.0, -6.0), Vector2(-13.0, -1.0), col_scratch, 1.0)
	draw_line(Vector2(-13.0, -6.0), Vector2(-13.0, -1.0), col_scratch, 1.0)
	# I
	draw_line(Vector2(-11.0, -6.0), Vector2(-11.0, -1.0), col_scratch, 1.0)
	# E
	draw_line(Vector2(-9.0, -6.0), Vector2(-9.0, -1.0), col_scratch, 1.0)
	draw_line(Vector2(-9.0, -6.0), Vector2(-6.0, -6.0), col_scratch, 0.8)
	draw_line(Vector2(-9.0, -3.5), Vector2(-7.0, -3.5), col_scratch, 0.8)
	draw_line(Vector2(-9.0, -1.0), Vector2(-6.0, -1.0), col_scratch, 0.8)
	
	# Space & SZUKAJ
	# S
	draw_line(Vector2(-3.0, -6.0), Vector2(-1.0, -6.0), col_scratch, 0.8)
	draw_line(Vector2(-3.0, -6.0), Vector2(-3.0, -3.5), col_scratch, 0.8)
	draw_line(Vector2(-3.0, -3.5), Vector2(-1.0, -3.5), col_scratch, 0.8)
	draw_line(Vector2(-1.0, -3.5), Vector2(-1.0, -1.0), col_scratch, 0.8)
	draw_line(Vector2(-3.0, -1.0), Vector2(-1.0, -1.0), col_scratch, 0.8)
	# Z
	draw_line(Vector2(1.0, -6.0), Vector2(3.0, -6.0), col_scratch, 0.8)
	draw_line(Vector2(3.0, -6.0), Vector2(1.0, -1.0), col_scratch, 0.8)
	draw_line(Vector2(1.0, -1.0), Vector2(3.0, -1.0), col_scratch, 0.8)
	# U
	draw_line(Vector2(5.0, -6.0), Vector2(5.0, -1.0), col_scratch, 0.8)
	draw_line(Vector2(5.0, -1.0), Vector2(7.5, -1.0), col_scratch, 0.8)
	draw_line(Vector2(7.5, -6.0), Vector2(7.5, -1.0), col_scratch, 0.8)
	# K
	draw_line(Vector2(9.5, -6.0), Vector2(9.5, -1.0), col_scratch, 0.8)
	draw_line(Vector2(12.0, -6.0), Vector2(9.5, -3.5), col_scratch, 0.8)
	draw_line(Vector2(9.5, -3.5), Vector2(12.0, -1.0), col_scratch, 0.8)
	# A
	draw_line(Vector2(14.0, -1.0), Vector2(15.5, -6.0), col_scratch, 0.8)
	draw_line(Vector2(15.5, -6.0), Vector2(17.0, -1.0), col_scratch, 0.8)
	draw_line(Vector2(14.5, -3.5), Vector2(16.5, -3.5), col_scratch, 0.8)
	
	# Line 2: "ORYGINAŁU" (with amber & cyan highlights)
	draw_line(Vector2(-18.0, 2.0), Vector2(18.0, 2.0), Color(col_amber.r, col_amber.g, col_amber.b, alpha * 0.4), 0.6)
	# O
	draw_rect(Rect2(-16.0, 3.0, 3.5, 5.0), col_amber, false, 0.8)
	# R
	draw_line(Vector2(-11.0, 3.0), Vector2(-11.0, 8.0), col_amber, 0.8)
	draw_line(Vector2(-11.0, 3.0), Vector2(-8.5, 3.0), col_amber, 0.8)
	draw_line(Vector2(-8.5, 3.0), Vector2(-8.5, 5.5), col_amber, 0.8)
	draw_line(Vector2(-8.5, 5.5), Vector2(-11.0, 5.5), col_amber, 0.8)
	draw_line(Vector2(-10.0, 5.5), Vector2(-8.5, 8.0), col_amber, 0.8)
	# Y
	draw_line(Vector2(-7.0, 3.0), Vector2(-5.5, 5.5), col_amber, 0.8)
	draw_line(Vector2(-4.0, 3.0), Vector2(-5.5, 5.5), col_amber, 0.8)
	draw_line(Vector2(-5.5, 5.5), Vector2(-5.5, 8.0), col_amber, 0.8)
	# G
	draw_line(Vector2(-0.5, 3.0), Vector2(-2.5, 3.0), col_amber, 0.8)
	draw_line(Vector2(-2.5, 3.0), Vector2(-2.5, 8.0), col_amber, 0.8)
	draw_line(Vector2(-2.5, 8.0), Vector2(-0.5, 8.0), col_amber, 0.8)
	draw_line(Vector2(-0.5, 8.0), Vector2(-0.5, 5.5), col_amber, 0.8)
	draw_line(Vector2(-0.5, 5.5), Vector2(-1.5, 5.5), col_amber, 0.8)
	# I
	draw_line(Vector2(1.5, 3.0), Vector2(1.5, 8.0), col_amber, 0.8)
	# N
	draw_line(Vector2(3.5, 3.0), Vector2(3.5, 8.0), col_amber, 0.8)
	draw_line(Vector2(3.5, 3.0), Vector2(6.0, 8.0), col_amber, 0.8)
	draw_line(Vector2(6.0, 3.0), Vector2(6.0, 8.0), col_amber, 0.8)
	# A
	draw_line(Vector2(8.0, 8.0), Vector2(9.5, 3.0), col_amber, 0.8)
	draw_line(Vector2(9.5, 3.0), Vector2(11.0, 8.0), col_amber, 0.8)
	draw_line(Vector2(8.5, 5.5), Vector2(10.5, 5.5), col_amber, 0.8)
	# Ł
	draw_line(Vector2(13.0, 3.0), Vector2(13.0, 8.0), col_amber, 0.8)
	draw_line(Vector2(13.0, 8.0), Vector2(15.5, 8.0), col_amber, 0.8)
	draw_line(Vector2(11.8, 5.0), Vector2(14.2, 4.0), col_amber, 0.8)
	# U
	draw_line(Vector2(17.0, 3.0), Vector2(17.0, 8.0), col_amber, 0.8)
	draw_line(Vector2(17.0, 8.0), Vector2(19.5, 8.0), col_amber, 0.8)
	draw_line(Vector2(19.5, 3.0), Vector2(19.5, 8.0), col_amber, 0.8)
	
	# Micro fracture glints
	if is_lit:
		draw_circle(Vector2(-14.0 + pulse * 2.0, -3.0), 1.0, COLOR_CYAN)
		draw_circle(Vector2(10.0 - pulse * 2.0, 5.0), 1.0, COLOR_AMBER)


func _draw_apothecary_cabinet() -> void:
	# Wall-mounted medical cabinet with frosted ribbed glass door (22x30 px)
	var cab_rect := Rect2(-11.0, -15.0, 22.0, 30.0)
	draw_rect(cab_rect, Color("d0d7d4"))
	draw_rect(cab_rect, Color("24333c"), false, 1.2)
	
	# Interior shelf dividing lines
	draw_line(Vector2(-10.0, -5.0), Vector2(10.0, -5.0), Color("24333c"), 1.0)
	draw_line(Vector2(-10.0, 5.0), Vector2(10.0, 5.0), Color("24333c"), 1.0)
	
	# Top shelf: 2 amber correlation stabilizer bottles
	draw_rect(Rect2(-8.0, -13.0, 4.5, 7.0), COLOR_AMBER * 0.9)
	draw_rect(Rect2(-7.0, -14.5, 2.5, 2.0), Color("141a1f")) # Cap
	draw_rect(Rect2(-2.0, -12.0, 4.0, 6.0), Color("8f5b2b"))
	draw_rect(Rect2(-1.0, -13.5, 2.0, 2.0), Color("141a1f"))
	
	# Middle shelf: White medicine box with UCP indicator & pill blister strip
	draw_rect(Rect2(-8.0, -3.0, 8.0, 6.0), Color("f0f4f2"))
	draw_line(Vector2(-5.0, -2.0), Vector2(-5.0, 1.0), COLOR_CORRECTION, 1.0) # Cinnabar cross/bar
	draw_line(Vector2(-6.5, -0.5), Vector2(-3.5, -0.5), COLOR_CORRECTION, 1.0)
	# Silver foil blister pack on right
	draw_rect(Rect2(2.0, -2.0, 7.0, 5.0), Color("a8b2ac"))
	draw_circle(Vector2(4.0, 0.0), 1.0, COLOR_CYAN)
	draw_circle(Vector2(7.0, 0.0), 1.0, COLOR_CYAN)
	
	# Bottom shelf: Sterile gauze roll & tweezers
	draw_circle(Vector2(-5.0, 10.0), 3.5, Color("e8eee8"))
	draw_line(Vector2(2.0, 12.0), Vector2(8.0, 8.0), Color("e0e8e4"), 1.0) # Tweezers
	
	# Frosted ribbed glass door overlay with vertical fluting
	for fx in range(-9, 10, 3):
		draw_line(Vector2(float(fx), -14.0), Vector2(float(fx), 14.0), Color(0.22, 0.31, 0.36, 0.25), 0.8)
	
	# Chrome latch handle on right side
	draw_rect(Rect2(8.0, -2.0, 2.5, 4.0), Color("e0e8e4"))


func _draw_marta_bathroom_guide() -> void:
	# Architectural sightline guide marker (Marta's instruction D-03: "Zostaw drzwi w odbiciu")
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	var ray_alpha := 0.35 + pulse * 0.25
	var col_amber := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, ray_alpha)
	
	# Floor threshold notch
	draw_rect(Rect2(-12.0, 4.0, 24.0, 3.0), Color("1a242c"))
	draw_rect(Rect2(-12.0, 4.0, 24.0, 3.0), COLOR_INFRASTRUCTURE * 0.6, false, 0.8)
	
	# Observation line indicator pointing toward mirror on left
	draw_line(Vector2(8.0, 0.0), Vector2(-12.0, 0.0), col_amber, 1.2)
	draw_line(Vector2(-12.0, 0.0), Vector2(-8.0, -3.0), col_amber, 1.0)
	draw_line(Vector2(-12.0, 0.0), Vector2(-8.0, 3.0), col_amber, 1.0)
	
	# Amber observation tick marker
	draw_circle(Vector2(0.0, -8.0), 2.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, ray_alpha * 0.8))


func _draw_bakelite_phone() -> void:
	# Heavy 1960s/70s Polish/European black bakelite desk telephone with rotary dial
	var pulse := sin(_pulse_phase * 3.0) * 0.5 + 0.5
	var is_ringing := not is_activated
	var shake_x: float = (sin(_pulse_phase * 24.0) * 0.8) if is_ringing else 0.0
	
	# 1. Base Housing (Heavy curved trapezoid / rounded rectangle: 24x13 px)
	var base_rect := Rect2(-12.0 + shake_x, 0.0, 24.0, 13.0)
	draw_rect(base_rect, Color("10161a")) # Deep obsidian bakelite
	draw_rect(base_rect, Color("202e38"), false, 1.0)
	# Bottom rubber foot pads
	draw_rect(Rect2(-11.0 + shake_x, 12.0, 3.0, 2.0), Color("080c0e"))
	draw_rect(Rect2(8.0 + shake_x, 12.0, 3.0, 2.0), Color("080c0e"))
	
	# 2. Chrome Cradle Forks on top
	draw_line(Vector2(-7.0 + shake_x, 0.0), Vector2(-7.0 + shake_x, -4.0), Color("c8d4ce"), 1.4)
	draw_line(Vector2(7.0 + shake_x, 0.0), Vector2(7.0 + shake_x, -4.0), Color("c8d4ce"), 1.4)
	draw_circle(Vector2(-7.0 + shake_x, -4.0), 1.2, Color("e0ece8"))
	draw_circle(Vector2(7.0 + shake_x, -4.0), 1.2, Color("e0ece8"))
	
	# 3. Rotary Dial
	var dial_center := Vector2(0.0 + shake_x, 6.5)
	draw_circle(dial_center, 5.2, Color("18232a"))
	draw_circle(dial_center, 4.2, Color("dce4e0")) # White number plate
	draw_circle(dial_center, 1.8, Color("10161a")) # Central hub
	draw_circle(dial_center, 0.9, COLOR_AMBER) # Brass center logo pin
	# Chrome finger stop bracket at bottom right (4 o'clock)
	draw_line(dial_center + Vector2(2.5, 2.5), dial_center + Vector2(4.5, 4.5), Color("b0bcba"), 1.0)
	# 10 finger holes
	for i in range(10):
		var angle := -PI * 0.75 + float(i) * (PI * 1.5 / 9.0)
		var hole_pos := dial_center + Vector2(cos(angle), sin(angle)) * 3.0
		draw_circle(hole_pos, 0.6, Color("202c34"))
	
	# 4. Handset & Cord
	if not is_activated:
		# Handset resting across cradle (with subtle vibration arcs if ringing)
		var earpiece_pos := Vector2(-9.0 + shake_x, -5.5)
		var mouthpiece_pos := Vector2(9.0 + shake_x, -5.5)
		# Earpiece cup & Mouthpiece cup
		draw_circle(earpiece_pos, 3.5, Color("10161a"))
		draw_circle(earpiece_pos, 3.5, Color("283844"), false, 0.8)
		draw_circle(mouthpiece_pos, 3.5, Color("10161a"))
		draw_circle(mouthpiece_pos, 3.5, Color("283844"), false, 0.8)
		# Connecting handle bar
		draw_line(earpiece_pos, mouthpiece_pos, Color("10161a"), 3.2)
		draw_line(earpiece_pos, mouthpiece_pos, Color("22303a"), 1.0)
		
		# Ringing acoustic vibration waves
		if is_ringing:
			var ring_alpha := 0.4 + pulse * 0.45
			draw_arc(Vector2(0.0, -9.0), 7.0, -PI * 0.8, -PI * 0.2, 8, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, ring_alpha), 1.0)
			draw_arc(Vector2(0.0, -12.0), 11.0, -PI * 0.75, -PI * 0.25, 8, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, ring_alpha * 0.6), 0.8)
	else:
		# Handset lifted and angled (conversation in progress D-04)
		var lift_offset := Vector2(2.0, -16.0)
		var ear_p := lift_offset + Vector2(-8.0, 3.0)
		var mouth_p := lift_offset + Vector2(8.0, -3.0)
		draw_circle(ear_p, 3.5, Color("10161a"))
		draw_circle(ear_p, 3.5, COLOR_AMBER * 0.8, false, 0.8)
		draw_circle(mouth_p, 3.5, Color("10161a"))
		draw_circle(mouth_p, 3.5, COLOR_AMBER * 0.8, false, 0.8)
		draw_line(ear_p, mouth_p, Color("10161a"), 3.2)
		draw_line(ear_p, mouth_p, COLOR_AMBER, 1.0)
		
		# Coiled cord stretching down to left side of base
		var cord_start := Vector2(-11.0, 9.0)
		var cord_end := ear_p
		for c in range(5):
			var t0 := float(c) / 5.0
			var t1 := float(c + 1) / 5.0
			var p0 := cord_start.lerp(cord_end, t0) + Vector2(sin(float(c) * 1.8) * 3.0, cos(float(c) * 1.5) * 2.0)
			var p1 := cord_start.lerp(cord_end, t1)
			draw_line(p0, p1, Color("182228"), 1.2)


func _draw_reel_tape_recorder() -> void:
	# Vintage reel-to-reel tape deck (32x22 px) with two spools and VU meter
	var deck_rect := Rect2(-16.0, -11.0, 32.0, 22.0)
	
	# Teak/walnut outer wooden chassis
	draw_rect(deck_rect, Color("342217"))
	draw_rect(deck_rect, Color("1e130c"), false, 1.2)
	
	# Brushed aluminum faceplate
	var face_rect := Rect2(-14.0, -9.0, 28.0, 18.0)
	draw_rect(face_rect, Color("94a29d"))
	draw_rect(face_rect, Color("5b6964"), false, 0.8)
	
	var is_playing := is_activated
	var rot_speed := _pulse_phase * 4.0 if is_playing else 0.0
	
	# Left Spool (Supply Reel) at (-7.0, -2.5)
	var left_hub := Vector2(-7.0, -2.5)
	var reel_r: float = 5.2
	draw_circle(left_hub, reel_r, Color("202a30")) # Dark tape layer
	draw_circle(left_hub, reel_r, Color("cbd8d3"), false, 1.0) # Reel outer flange
	draw_circle(left_hub, 1.8, Color("6b7975")) # Center hub
	for s in range(3):
		var ang := rot_speed + float(s) * (TAU / 3.0)
		draw_line(left_hub, left_hub + Vector2(cos(ang), sin(ang)) * reel_r, Color("dce7e3"), 0.8)
	
	# Right Spool (Takeup Reel) at (7.0, -2.5)
	var right_hub := Vector2(7.0, -2.5)
	draw_circle(right_hub, reel_r, Color("202a30"))
	draw_circle(right_hub, reel_r, Color("cbd8d3"), false, 1.0)
	draw_circle(right_hub, 1.8, Color("6b7975"))
	for s in range(3):
		var ang := rot_speed * 1.1 + float(s) * (TAU / 3.0)
		draw_line(right_hub, right_hub + Vector2(cos(ang), sin(ang)) * reel_r, Color("dce7e3"), 0.8)
	
	# Magnetic Tape Path between reels & Head Assembly
	var tape_col := Color("4e311f") # Ferric oxide brown
	draw_line(left_hub + Vector2(0.0, reel_r), Vector2(-2.5, 4.0), tape_col, 1.0)
	draw_line(Vector2(-2.5, 4.0), Vector2(2.5, 4.0), tape_col, 1.0)
	draw_line(Vector2(2.5, 4.0), right_hub + Vector2(0.0, reel_r), tape_col, 1.0)
	
	# Central Magnetic Head Block
	draw_rect(Rect2(-3.0, 2.0, 6.0, 3.5), Color("222e36"))
	draw_circle(Vector2(3.5, 3.5), 1.0, Color("c2cec9")) # Capstan pinch roller
	
	# VU Meter on bottom-left
	var vu_rect := Rect2(-13.0, 4.0, 6.5, 4.0)
	draw_rect(vu_rect, Color("28382d"))
	draw_rect(vu_rect, COLOR_AMBER * 0.4) # Warm backlit dial
	var needle_val := (sin(_pulse_phase * 6.0) * 0.5 + 0.5) if is_playing else 0.1
	var needle_tip := Vector2(-9.75, 4.5) + Vector2(lerpf(-2.0, 2.0, needle_val), 0.0)
	draw_line(Vector2(-9.75, 7.5), needle_tip, COLOR_CORRECTION if needle_val > 0.8 else COLOR_AMBER, 0.8)
	
	# Piano key controls on bottom-right (Rew, Play, Stop, Fwd, Rec)
	for k in range(4):
		var kx := 1.0 + float(k) * 2.8
		var k_col := COLOR_CYAN if (k == 1 and is_playing) else Color("36444c")
		draw_rect(Rect2(kx, 5.0, 2.2, 3.0), k_col)


func _draw_topography_board() -> void:
	# Wall-mounted corkboard (44x30 px) with pinned blueprints, clippings & connection strings
	var board_rect := Rect2(-22.0, -15.0, 44.0, 30.0)
	
	# Solid pine wood frame
	draw_rect(board_rect, Color("3c2819"))
	draw_rect(board_rect, Color("22160d"), false, 1.2)
	
	# Cork surface
	var cork_rect := Rect2(-20.0, -13.0, 40.0, 26.0)
	draw_rect(cork_rect, Color("5e442c"))
	
	# 1. Pinned Apartment 14 Blueprint on left (18x16 px)
	var bp_rect := Rect2(-18.0, -11.0, 18.0, 16.0)
	draw_rect(bp_rect, Color("1b3340")) # Blueprint cyan background
	draw_rect(bp_rect, Color("75c7c3"), false, 0.6)
	# Floorplan room partition lines
	draw_line(Vector2(-18.0, -3.0), Vector2(-4.0, -3.0), Color("75c7c3", 0.6), 0.7)
	draw_line(Vector2(-10.0, -11.0), Vector2(-10.0, 5.0), Color("75c7c3", 0.6), 0.7)
	# Room control node marker
	draw_circle(Vector2(-14.0, -7.0), 1.2, COLOR_AMBER) # Study
	draw_circle(Vector2(-6.0, 1.0), 1.2, COLOR_CYAN) # Bathroom
	
	# 2. Newspaper clipping on right (16x13 px) - Line 4 Tram Disaster
	var news_rect := Rect2(2.0, -11.0, 16.0, 13.0)
	draw_rect(news_rect, Color("d4dbd6"))
	draw_rect(Rect2(3.0, -10.0, 14.0, 2.0), Color("202a30")) # Headline bar
	# Text columns
	draw_line(Vector2(4.0, -6.5), Vector2(16.0, -6.5), Color("6b7a82"), 0.6)
	draw_line(Vector2(4.0, -4.5), Vector2(16.0, -4.5), Color("6b7a82"), 0.6)
	draw_line(Vector2(4.0, -2.5), Vector2(14.0, -2.5), Color("6b7a82"), 0.6)
	draw_line(Vector2(4.0, -0.5), Vector2(12.0, -0.5), Color("6b7a82"), 0.6)
	
	# 3. Graph Nodes & Connection Strings (Amber & Cyan yarn lines linking nodes)
	var node_study := Vector2(-14.0, -7.0)
	var node_bath := Vector2(-6.0, 1.0)
	var node_tram := Vector2(10.0, -5.0)
	var node_ikp := Vector2(8.0, 8.0)
	var node_substruct := Vector2(-8.0, 9.0)
	
	# Colored yarn connection strings
	draw_line(node_study, node_tram, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.8), 0.9)
	draw_line(node_tram, node_ikp, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.8), 0.9)
	draw_line(node_ikp, node_substruct, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.85), 0.9)
	draw_line(node_substruct, node_bath, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.85), 0.9)
	
	# Pushpins on graph nodes
	draw_circle(node_study, 1.4, COLOR_AMBER)
	draw_circle(node_tram, 1.4, COLOR_CORRECTION)
	draw_circle(node_ikp, 1.4, COLOR_INFRASTRUCTURE)
	draw_circle(node_substruct, 1.4, COLOR_CYAN)
	draw_circle(node_bath, 1.4, COLOR_CYAN)
	
	# 4. Sticky note on bottom right: "WĘZEŁ 14 - KONTROLA CIĄGŁOŚCI"
	var note_rect := Rect2(-1.0, 4.0, 18.0, 7.0)
	draw_rect(note_rect, Color("e5c678"))
	draw_line(Vector2(1.0, 6.0), Vector2(15.0, 6.0), Color("5a441e"), 0.6)
	draw_line(Vector2(1.0, 8.0), Vector2(12.0, 8.0), Color("5a441e"), 0.6)


func _draw_jakub_desk_lamp() -> void:
	# Classic Banker's desk lamp with emerald green glass shade and brass body
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	var is_lit := not is_activated # Lit by default unless toggled
	
	# Heavy circular brass base at bottom
	draw_rect(Rect2(-7.0, 5.0, 14.0, 3.0), Color("9e7e3e"))
	draw_rect(Rect2(-7.0, 5.0, 14.0, 3.0), Color("5c4820"), false, 0.8)
	
	# Curved brass gooseneck arm
	draw_line(Vector2(0.0, 5.0), Vector2(0.0, -2.0), Color("bfa058"), 1.8)
	draw_line(Vector2(0.0, -2.0), Vector2(-3.0, -7.0), Color("bfa058"), 1.8)
	
	# Banker's Emerald Green Glass Shade (18x7 px)
	var shade_rect := Rect2(-11.0, -11.0, 18.0, 7.0)
	draw_rect(shade_rect, Color("1b452e")) # Deep emerald green glass
	draw_rect(shade_rect, Color("0d2619"), false, 1.0)
	# Brass shade top bracket
	draw_rect(Rect2(-4.0, -12.5, 6.0, 2.0), Color("bfa058"))
	# White inner milk-glass lip
	draw_line(Vector2(-11.0, -4.0), Vector2(7.0, -4.0), Color("d8ece0") if is_lit else Color("7a9486"), 1.2)
	
	# Brass pull-chain switch dangling on right
	draw_line(Vector2(4.0, -4.0), Vector2(4.0, 2.0), Color("bfa058"), 0.8)
	draw_circle(Vector2(4.0, 2.5), 0.8, Color("dfc278"))
	
	# Downward illuminated light cone onto the desk surface
	if is_lit:
		var cone_alpha := 0.20 + pulse * 0.04
		var cone_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, cone_alpha)
		var cone_points: PackedVector2Array = [
			Vector2(-11.0, -4.0),
			Vector2(7.0, -4.0),
			Vector2(28.0, 18.0),
			Vector2(-32.0, 18.0)
		]
		draw_colored_polygon(cone_points, cone_col)
		# Central bright filament hot spot on desk
		draw_circle(Vector2(-2.0, 6.0), 8.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, cone_alpha * 0.6))


func _draw_tech_storage_airlock() -> void:
	# Heavy technical corridor portal / utility passage leading to Space 11
	var portal_rect := Rect2(-16.0, -28.0, 32.0, 56.0)
	
	# Reinforced structural steel frame
	draw_rect(portal_rect, COLOR_DARK_STEEL)
	draw_rect(portal_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Rivet fasteners along frame perimeter
	for ry in range(-24, 25, 12):
		draw_circle(Vector2(-13.5, float(ry)), 0.8, COLOR_INFRASTRUCTURE)
		draw_circle(Vector2(13.5, float(ry)), 0.8, COLOR_INFRASTRUCTURE)
	
	# Door panel in graphite slate
	var door_rect := Rect2(-12.0, -24.0, 24.0, 50.0)
	draw_rect(door_rect, Color("1a242c"))
	
	# Vertical structural channel beams
	draw_line(Vector2(-6.0, -24.0), Vector2(-6.0, 26.0), Color("2b3c48"), 1.2)
	draw_line(Vector2(6.0, -24.0), Vector2(6.0, 26.0), Color("2b3c48"), 1.2)
	
	# Industrial ventilation louvers in upper section
	for ly in range(-20, -10, 3):
		draw_line(Vector2(-9.0, float(ly)), Vector2(9.0, float(ly)), Color("11181d"), 1.0)
		draw_line(Vector2(-9.0, float(ly) + 0.8), Vector2(9.0, float(ly) + 0.8), Color("324754"), 0.6)
	
	# Top Hazard Warning Strip (Yellow-Amber & Black diagonal stripes)
	var hazard_rect := Rect2(-15.0, -27.0, 30.0, 3.0)
	draw_rect(hazard_rect, Color("14181a"))
	for hx in range(-14, 14, 4):
		draw_line(Vector2(float(hx), -27.0), Vector2(float(hx) + 2.5, -24.0), COLOR_AMBER * 0.9, 1.0)
	
	# Consensus Lock Status Panel on right jamb at (10.0, -2.0)
	var panel_rect := Rect2(6.0, -4.0, 5.5, 10.0)
	draw_rect(panel_rect, Color("11181e"))
	draw_rect(panel_rect, COLOR_INFRASTRUCTURE, false, 0.8)
	
	var is_unlocked := is_activated
	if is_unlocked:
		# Glowing cyan consensus lock indicator (Passage open / stabilized)
		draw_circle(Vector2(8.75, 1.0), 1.6, COLOR_CYAN)
		draw_circle(Vector2(8.75, 1.0), 3.2, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35))
	else:
		# Pulsing cinnabar security lock indicator (Secured)
		var pulse := sin(_pulse_phase * 3.0) * 0.5 + 0.5
		draw_circle(Vector2(8.75, 1.0), 1.6, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.5 + pulse * 0.5))


func _draw_observation_window() -> void:
	# Panoramic window in elevated technical corridor: 44x28 px
	var win_rect := Rect2(-22.0, -14.0, 44.0, 28.0)
	draw_rect(win_rect, Color("0f1920"))
	
	# Dawn sky gradient & courtyard view
	draw_rect(Rect2(-20.0, -12.0, 40.0, 16.0), Color("172733"))
	# Pale misty horizon glow
	draw_line(Vector2(-20.0, 0.0), Vector2(20.0, 0.0), Color(0.4, 0.55, 0.65, 0.3), 1.0)
	# Distant courtyard silhouettes (trees/fence/lamppost)
	draw_rect(Rect2(-16.0, -2.0, 4.0, 6.0), Color("0c141a"))
	draw_line(Vector2(6.0, -8.0), Vector2(6.0, 4.0), Color("0c141a"), 1.0)
	draw_circle(Vector2(6.0, -8.0), 1.5, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.4))
	
	# Window steel frame & mullions
	draw_rect(win_rect, Color("2a3b45"), false, 1.5)
	draw_line(Vector2(0.0, -14.0), Vector2(0.0, 14.0), Color("2a3b45"), 1.2)
	draw_line(Vector2(-22.0, 2.0), Vector2(22.0, 2.0), Color("2a3b45"), 1.0)
	
	# Subtle glass diagonal reflection
	draw_line(Vector2(-18.0, -10.0), Vector2(6.0, 10.0), Color(1.0, 1.0, 1.0, 0.15), 1.0)


func _draw_erased_doorway_trace() -> void:
	# Masonry wall patch with fading door outline: 30x42 px
	var wall_rect := Rect2(-15.0, -21.0, 30.0, 42.0)
	draw_rect(wall_rect, Color("34241d")) # Brickwork base
	
	# Horizontal brick courses
	for y in range(-20, 20, 6):
		draw_line(Vector2(-15.0, float(y)), Vector2(15.0, float(y)), Color("241812"), 0.8)
	
	# Vertical brick joints
	for y in range(-20, 20, 6):
		var offset := 0.0 if (y / 6) % 2 == 0 else 5.0
		for x in range(-12, 14, 10):
			draw_line(Vector2(float(x) + offset, float(y)), Vector2(float(x) + offset, float(y) + 6.0), Color("241812"), 0.8)
	
	if not is_activated:
		# Ghost outline of former doorway seam (#geometry-restless-grid)
		var p := sin(_pulse_phase * 2.5) * 0.5 + 0.5
		var seam_col := Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.35 + p * 0.35)
		# Door frame arch / lintel
		draw_line(Vector2(-10.0, 20.0), Vector2(-10.0, -12.0), seam_col, 1.2)
		draw_line(Vector2(10.0, 20.0), Vector2(10.0, -12.0), seam_col, 1.2)
		draw_line(Vector2(-10.0, -12.0), Vector2(10.0, -12.0), seam_col, 1.2)
		# Ghost keyway / handle notch
		draw_circle(Vector2(8.0, 4.0), 1.2, seam_col)
	else:
		# Completely smoothed, stabilized brick plane with subtle cyan settling alignment
		draw_rect(wall_rect, Color("36261f"), false, 0.8)
		var p_cyan := sin(_pulse_phase * 1.5) * 0.2 + 0.2
		draw_line(Vector2(-15.0, 21.0), Vector2(15.0, 21.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, p_cyan), 1.0)


func _draw_ucp_intervention_team() -> void:
	# Two UCP operators in institutional suits: 36x28 px
	# Operator 1 (Left, holding stabilization apparatus)
	# Legs
	draw_rect(Rect2(-14.0, 3.0, 3.0, 11.0), Color("1e2930"))
	draw_rect(Rect2(-9.0, 3.0, 3.0, 11.0), Color("1e2930"))
	# Torso & Institutional Coat (#A8B2AC)
	draw_rect(Rect2(-16.0, -7.0, 11.0, 11.0), Color("42555f"))
	draw_rect(Rect2(-16.0, -7.0, 11.0, 11.0), COLOR_INFRASTRUCTURE * 0.6, false, 0.8)
	# Head
	draw_circle(Vector2(-10.5, -11.0), 3.0, Color("1e2930"))
	# Field stabilizer unit in hand
	var unit_rect := Rect2(-5.0, -5.0, 7.0, 8.0)
	draw_rect(unit_rect, COLOR_DARK_STEEL)
	draw_rect(unit_rect, COLOR_INFRASTRUCTURE, false, 0.8)
	# Probe antenna
	draw_line(Vector2(2.0, -1.0), Vector2(7.0, -1.0), COLOR_INFRASTRUCTURE, 1.0)
	# Active cyan emitter diode on probe
	var pulse := sin(_pulse_phase * 4.0) * 0.5 + 0.5
	var diode_col := COLOR_CYAN if is_activated else Color(0.3, 0.6, 0.6)
	draw_circle(Vector2(7.0, -1.0), 1.5, diode_col)
	draw_circle(Vector2(7.0, -1.0), 3.0, Color(diode_col.r, diode_col.g, diode_col.b, pulse * 0.35))

	# Operator 2 (Right, escorting / open posture)
	# Legs
	draw_rect(Rect2(9.0, 3.0, 3.0, 11.0), Color("1e2930"))
	draw_rect(Rect2(14.0, 3.0, 3.0, 11.0), Color("1e2930"))
	# Torso & Coat
	draw_rect(Rect2(7.0, -7.0, 11.0, 11.0), Color("42555f"))
	draw_rect(Rect2(7.0, -7.0, 11.0, 11.0), COLOR_INFRASTRUCTURE * 0.6, false, 0.8)
	# Head
	draw_circle(Vector2(12.5, -11.0), 3.0, Color("1e2930"))
	# Guiding arm
	draw_line(Vector2(8.0, -2.0), Vector2(1.0, 2.0), Color("42555f"), 1.5)


func _draw_elderly_resident_guide() -> void:
	# Disoriented elderly resident in wool coat and headscarf: 16x26 px
	# Long brown wool coat
	var coat_rect := Rect2(-6.0, -5.0, 12.0, 16.0)
	draw_rect(coat_rect, Color("3e3128"))
	draw_rect(coat_rect, Color("261d17"), false, 0.8)
	# Boots
	draw_rect(Rect2(-5.0, 11.0, 4.0, 3.0), Color("18120d"))
	draw_rect(Rect2(1.0, 11.0, 4.0, 3.0), Color("18120d"))
	# Headscarf & head
	draw_circle(Vector2(0.0, -8.5), 3.5, Color("4a3c30"))
	draw_circle(Vector2(0.0, -8.0), 2.2, COLOR_AMBER * 0.8) # Face profile
	# Old brass apartment key in hand
	draw_circle(Vector2(6.0, 2.0), 1.0, COLOR_AMBER)
	draw_line(Vector2(6.0, 2.0), Vector2(9.0, 2.0), COLOR_AMBER, 1.0)


func _draw_marta_observation_dialogue() -> void:
	# Marta Kurek standing at gallery railing observing: 20x30 px
	# Work trousers
	draw_rect(Rect2(-6.0, 4.0, 4.0, 11.0), Color("2b3a33"))
	draw_rect(Rect2(2.0, 4.0, 4.0, 11.0), Color("2b3a33"))
	# Work jacket (Sage/Brown with chalk marks)
	var jacket_rect := Rect2(-8.0, -8.0, 16.0, 13.0)
	draw_rect(jacket_rect, Color("4a3a2d"))
	draw_rect(jacket_rect, Color("2d221a"), false, 0.8)
	# Canvas tool bag across shoulder
	draw_line(Vector2(-7.0, -8.0), Vector2(6.0, 2.0), Color("6e5944"), 2.0)
	draw_rect(Rect2(5.0, 0.0, 5.0, 6.0), Color("6e5944"))
	# Folding rule in breast pocket (Yellow line)
	draw_line(Vector2(-5.0, -6.0), Vector2(-2.0, -2.0), Color("c9a638"), 1.2)
	# Long pink hair, face and the small steel septum: Marta's durable silhouette.
	var marta_hair_shadow := Color("6d294f")
	var marta_hair_pink := Color("d45b9a")
	draw_circle(Vector2(0.0, -12.0), 4.2, marta_hair_shadow)
	draw_rect(Rect2(-4.0, -11.0, 2.5, 12.0), marta_hair_shadow)
	draw_rect(Rect2(1.5, -11.0, 2.5, 12.0), marta_hair_shadow)
	draw_circle(Vector2(0.0, -12.0), 3.0, Color("d39a62"))
	draw_line(Vector2(-3.5, -15.0), Vector2(2.6, -16.0), marta_hair_pink, 1.8)
	draw_line(Vector2(-3.0, -9.5), Vector2(-3.0, 1.0), marta_hair_pink, 1.3)
	draw_line(Vector2(2.6, -9.5), Vector2(2.6, 1.0), marta_hair_pink, 1.3)
	draw_arc(Vector2(0.8, -10.8), 0.85, 0.15, PI - 0.15, 5, Color("c7d3d6"), 0.7)
	# Hands resting on gallery railing
	draw_circle(Vector2(-4.0, 1.0), 1.5, COLOR_AMBER)
	draw_circle(Vector2(4.0, 1.0), 1.5, COLOR_AMBER)


func _draw_courtyard_exit_airlock() -> void:
	# Heavy courtyard exit portal & gate leading to Space 12: 32x54 px
	var frame_rect := Rect2(-16.0, -27.0, 32.0, 54.0)
	draw_rect(frame_rect, COLOR_DARK_STEEL)
	draw_rect(frame_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Recessed doorway aperture
	var door_rect := Rect2(-12.0, -23.0, 24.0, 50.0)
	draw_rect(door_rect, Color("0b1216"))
	
	# Steel gate slats
	for sy in range(-19, 26, 6):
		draw_line(Vector2(-11.0, float(sy)), Vector2(11.0, float(sy)), Color("22323d"), 1.5)
	
	# Hazard top stripe
	var haz_rect := Rect2(-16.0, -27.0, 32.0, 3.0)
	draw_rect(haz_rect, Color("14181a"))
	for hx in range(-15, 15, 4):
		draw_line(Vector2(float(hx), -27.0), Vector2(float(hx) + 2.5, -24.0), COLOR_AMBER * 0.9, 1.0)
	
	# Status Indicator
	var is_open := is_activated
	if is_open:
		draw_circle(Vector2(0.0, -24.5), 2.0, COLOR_CYAN)
		draw_circle(Vector2(0.0, -24.5), 4.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35))
	else:
		var pulse := sin(_pulse_phase * 3.0) * 0.5 + 0.5
		draw_circle(Vector2(0.0, -24.5), 2.0, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.6 + pulse * 0.4))


func _draw_ucp_info_terminal() -> void:
	# Industrial CRT Information & Clearance Workstation: 26x36 px
	# Heavy steel pedestal base
	var base_rect := Rect2(-11.0, 10.0, 22.0, 6.0)
	draw_rect(base_rect, Color("202c34"))
	draw_rect(base_rect, COLOR_DARK_STEEL, false, 0.8)
	
	# Pedestal column with ventilation slats
	var col_rect := Rect2(-5.0, -5.0, 10.0, 15.0)
	draw_rect(col_rect, Color("2d3d47"))
	draw_rect(col_rect, Color("1a242a"), false, 0.8)
	for vy in range(-2, 8, 3):
		draw_line(Vector2(-3.5, float(vy)), Vector2(3.5, float(vy)), Color("161f24"), 1.0)
	
	# Angled CRT terminal chassis housing
	var chassis_rect := Rect2(-13.0, -23.0, 26.0, 18.0)
	draw_rect(chassis_rect, Color("25343d"))
	draw_rect(chassis_rect, COLOR_INFRASTRUCTURE, false, 1.0)
	
	# CRT Monitor screen aperture
	var screen_rect := Rect2(-10.0, -20.0, 20.0, 12.0)
	draw_rect(screen_rect, Color("0b1318"))
	
	# Phosphor monitor glow & raster lines
	var is_open := is_activated
	if is_open:
		# Level 3 clearance validated: bright cyan phosphor scanlines
		draw_rect(screen_rect, Color(0.12, 0.32, 0.35, 0.45))
		draw_rect(Rect2(-8.0, -18.0, 16.0, 2.0), COLOR_CYAN * 0.9)
		draw_rect(Rect2(-8.0, -14.0, 12.0, 1.5), COLOR_CYAN * 0.7)
		draw_rect(Rect2(-8.0, -11.0, 14.0, 1.5), COLOR_CYAN * 0.7)
		# Clearance badge icon [L-3]
		draw_rect(Rect2(4.0, -14.0, 4.0, 4.0), COLOR_AMBER * 0.9)
	else:
		# Idle institutional status display
		var pulse := sin(_pulse_phase * 2.5) * 0.5 + 0.5
		draw_rect(Rect2(-8.0, -18.0, 16.0, 1.5), COLOR_INFRASTRUCTURE * 0.6)
		draw_rect(Rect2(-8.0, -14.0, 10.0, 1.2), COLOR_INFRASTRUCTURE * 0.4)
		draw_rect(Rect2(-8.0, -11.0, 7.0, 1.2), COLOR_INFRASTRUCTURE * 0.4)
		# Blinking cursor
		if pulse > 0.4:
			draw_rect(Rect2(0.0, -11.0, 2.0, 2.0), COLOR_AMBER)
	
	# Angled mechanical keyboard deck
	var kb_rect := Rect2(-12.0, -5.0, 24.0, 5.0)
	draw_rect(kb_rect, Color("1e2a32"))
	draw_rect(kb_rect, Color("394d5a"), false, 0.8)
	# Key rows
	for kx in range(-10, 11, 3):
		draw_line(Vector2(float(kx), -3.5), Vector2(float(kx) + 1.5, -3.5), Color("455c6b"), 1.0)
		draw_line(Vector2(float(kx), -1.5), Vector2(float(kx) + 1.5, -1.5), Color("455c6b"), 1.0)
	
	# Badge card reader slot & status LED
	draw_line(Vector2(9.0, -18.0), Vector2(9.0, -12.0), Color("121a1f"), 1.2)
	var led_col := COLOR_CYAN if is_open else (COLOR_AMBER if sin(_pulse_phase * 3.0) > 0.0 else COLOR_CORRECTION)
	draw_circle(Vector2(9.0, -20.5), 1.2, led_col)


func _draw_showcase_vitrine() -> void:
	# Backlit Institutional Compliance Vitrine: 34x46 px
	# Wall-mounted aluminium frame
	var frame_rect := Rect2(-17.0, -23.0, 34.0, 46.0)
	draw_rect(frame_rect, Color("2d3d46"))
	draw_rect(frame_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Illuminated translucent interior panel
	var panel_rect := Rect2(-14.0, -20.0, 28.0, 40.0)
	draw_rect(panel_rect, Color("c2cec8"))
	
	# Header label: "DZIAŁ ZGODNOŚCI UCP"
	draw_rect(Rect2(-12.0, -18.5, 24.0, 4.0), Color("1e2b33"))
	draw_line(Vector2(-10.0, -16.5), Vector2(10.0, -16.5), COLOR_CYAN * 0.8, 1.0)
	
	# Document 1 (Compliance Form / Wniosek): Top left
	var doc1 := Rect2(-12.0, -12.0, 11.0, 15.0)
	draw_rect(doc1, Color("edf2ee"))
	draw_rect(doc1, Color("9eada6"), false, 0.6)
	# Red official stamp in corner
	draw_rect(Rect2(-11.0, -11.0, 3.0, 3.0), COLOR_CORRECTION * 0.85)
	# Text lines
	draw_line(Vector2(-10.0, -6.0), Vector2(-3.0, -6.0), Color("4a5952"), 0.8)
	draw_line(Vector2(-10.0, -3.0), Vector2(-4.0, -3.0), Color("4a5952"), 0.8)
	draw_line(Vector2(-10.0, 0.0), Vector2(-5.0, 0.0), Color("4a5952"), 0.8)
	
	# Document 2 (Evacuation / Safety Protocol): Top right
	var doc2 := Rect2(1.0, -12.0, 11.0, 15.0)
	draw_rect(doc2, Color("edf2ee"))
	draw_rect(doc2, Color("9eada6"), false, 0.6)
	# Header diagram icon
	draw_line(Vector2(3.0, -10.0), Vector2(10.0, -10.0), COLOR_CYAN * 0.8, 1.0)
	draw_line(Vector2(3.0, -7.0), Vector2(9.0, -7.0), Color("4a5952"), 0.8)
	draw_line(Vector2(3.0, -4.0), Vector2(8.0, -4.0), Color("4a5952"), 0.8)
	draw_line(Vector2(3.0, -1.0), Vector2(10.0, -1.0), Color("4a5952"), 0.8)
	
	# Document 3 (Wide Discrepancy Registry Form): Bottom
	var doc3 := Rect2(-12.0, 6.0, 24.0, 11.0)
	draw_rect(doc3, Color("e4ebe6"))
	draw_rect(doc3, Color("9eada6"), false, 0.6)
	# Table grid
	draw_line(Vector2(-10.0, 9.5), Vector2(10.0, 9.5), Color("3d4e46"), 0.8)
	draw_line(Vector2(-10.0, 13.0), Vector2(10.0, 13.0), Color("6c7d75"), 0.8)
	draw_line(Vector2(-2.0, 7.0), Vector2(-2.0, 16.0), Color("6c7d75"), 0.8)
	draw_line(Vector2(5.0, 7.0), Vector2(5.0, 16.0), Color("6c7d75"), 0.8)
	
	# Glass reflection sheen
	draw_line(Vector2(-12.0, -18.0), Vector2(12.0, 16.0), Color(1.0, 1.0, 1.0, 0.22), 1.0)
	
	# Bottom fluorescent tube
	draw_rect(Rect2(-13.0, 18.0, 26.0, 1.5), Color(0.9, 0.95, 0.95, 0.9))


func _draw_instruction_poster() -> void:
	# Institutional Poster: "PAMIĘĆ TO NIE POMIAR" (26x36 px)
	# Poster plate
	var poster_rect := Rect2(-13.0, -18.0, 26.0, 36.0)
	draw_rect(poster_rect, Color("d5ded9"))
	draw_rect(poster_rect, COLOR_DARK_STEEL, false, 1.0)
	
	# Top Banner
	var banner_rect := Rect2(-12.0, -17.0, 24.0, 6.0)
	draw_rect(banner_rect, Color("1a252c"))
	# Banner icon: consensus divergence split
	draw_line(Vector2(-8.0, -14.0), Vector2(-3.0, -14.0), COLOR_CYAN, 1.0)
	draw_circle(Vector2(-2.0, -14.0), 1.2, COLOR_AMBER)
	draw_line(Vector2(-1.0, -14.0), Vector2(8.0, -14.0), COLOR_CYAN, 1.0)
	
	# Key Graphic Headline: "PAMIĘĆ TO NIE POMIAR"
	draw_rect(Rect2(-10.0, -8.5, 20.0, 3.0), Color("162026"))
	draw_rect(Rect2(-10.0, -4.0, 20.0, 3.0), Color("162026"))
	
	# Horizontal separator in oxide cinnabar
	draw_line(Vector2(-10.0, 1.0), Vector2(10.0, 1.0), COLOR_CORRECTION * 0.9, 1.2)
	
	# Subtext: "ZGŁOŚ ROZBIEŻNOŚĆ W PUNKCIE 6"
	draw_line(Vector2(-9.0, 4.0), Vector2(8.0, 4.0), Color("3a4c54"), 0.9)
	draw_line(Vector2(-9.0, 7.0), Vector2(9.0, 7.0), Color("3a4c54"), 0.9)
	draw_line(Vector2(-9.0, 10.0), Vector2(4.0, 10.0), Color("3a4c54"), 0.9)
	
	# Official circular verification seal
	draw_circle(Vector2(6.5, 12.5), 2.5, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.75))
	draw_circle(Vector2(6.5, 12.5), 1.5, Color("d5ded9"))


func _draw_subway_tile_pillar() -> void:
	# Subterranean Subway Ceramic Tile Pillar: 28x58 px
	var pillar_rect := Rect2(-14.0, -29.0, 28.0, 58.0)
	draw_rect(pillar_rect, Color("35464f"))
	draw_rect(pillar_rect, Color("1f2a30"), false, 1.2)
	
	# Gloss ceramic tile grid
	for ty in range(-25, 26, 7):
		draw_line(Vector2(-13.0, float(ty)), Vector2(13.0, float(ty)), Color("222f36"), 1.0)
	for ty in range(-25, 26, 14):
		draw_line(Vector2(-5.0, float(ty)), Vector2(-5.0, float(ty) + 7.0), Color("222f36"), 1.0)
		draw_line(Vector2(5.0, float(ty)), Vector2(5.0, float(ty) + 7.0), Color("222f36"), 1.0)
		draw_line(Vector2(0.0, float(ty) + 7.0), Vector2(0.0, float(ty) + 14.0), Color("222f36"), 1.0)
	
	# Enamelled Transit Route Map Plaque
	var map_rect := Rect2(-11.0, -18.0, 22.0, 30.0)
	draw_rect(map_rect, Color("11181d"))
	draw_rect(map_rect, COLOR_INFRASTRUCTURE, false, 0.8)
	
	# Header on plaque
	draw_rect(Rect2(-9.0, -16.0, 18.0, 3.0), Color("23323c"))
	draw_line(Vector2(-7.0, -14.5), Vector2(7.0, -14.5), COLOR_CYAN * 0.9, 1.0)
	
	# Transit lines on map
	# Line 4 (Tram Route - Amber)
	draw_line(Vector2(-7.0, -10.0), Vector2(3.0, -5.0), COLOR_AMBER * 0.9, 1.5)
	draw_line(Vector2(3.0, -5.0), Vector2(7.0, 2.0), COLOR_AMBER * 0.9, 1.5)
	draw_circle(Vector2(-7.0, -10.0), 1.2, COLOR_AMBER)
	draw_circle(Vector2(3.0, -5.0), 1.2, COLOR_AMBER)
	draw_circle(Vector2(7.0, 2.0), 1.2, COLOR_AMBER)
	
	# Substructure Route (Cyan - Direct path to Point 6)
	draw_line(Vector2(-7.0, 0.0), Vector2(7.0, 0.0), COLOR_CYAN, 1.5)
	draw_circle(Vector2(0.0, 0.0), 1.5, COLOR_CYAN)
	
	# Arrow: "PUNKT 6 ->"
	draw_line(Vector2(-6.0, 7.0), Vector2(4.0, 7.0), COLOR_CYAN, 1.2)
	draw_line(Vector2(2.0, 5.0), Vector2(5.0, 7.0), COLOR_CYAN, 1.2)
	draw_line(Vector2(2.0, 9.0), Vector2(5.0, 7.0), COLOR_CYAN, 1.2)
	
	# Base hazard kickplate
	var kick_rect := Rect2(-14.0, 24.0, 28.0, 4.0)
	draw_rect(kick_rect, Color("14181a"))
	for hx in range(-13, 13, 4):
		draw_line(Vector2(float(hx), 24.0), Vector2(float(hx) + 2.5, 28.0), COLOR_AMBER * 0.85, 1.0)


func _draw_underpass_exit_gate() -> void:
	# Heavy Subterranean Underpass Security Gate: 36x58 px
	var frame_rect := Rect2(-18.0, -29.0, 36.0, 58.0)
	draw_rect(frame_rect, Color("223038"))
	draw_rect(frame_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Recessed tunnel archway
	var arch_rect := Rect2(-14.0, -24.0, 28.0, 53.0)
	draw_rect(arch_rect, Color("0a1014"))
	
	# Retractable steel security lattice bars
	for sy in range(-20, 27, 5):
		draw_line(Vector2(-13.0, float(sy)), Vector2(13.0, float(sy)), Color("2a3b45"), 1.2)
	for sx in range(-10, 11, 6):
		draw_line(Vector2(float(sx), -22.0), Vector2(float(sx), 27.0), Color("324551"), 1.2)
	
	# Illuminated overhead header sign plate
	var sign_rect := Rect2(-16.0, -28.0, 32.0, 5.0)
	draw_rect(sign_rect, Color("162026"))
	draw_line(Vector2(-14.0, -25.5), Vector2(14.0, -25.5), COLOR_CYAN * 0.85, 1.0)
	
	# Status Indicator Beacon
	var is_open := is_activated
	if is_open:
		draw_circle(Vector2(0.0, -21.0), 2.2, COLOR_CYAN)
		draw_circle(Vector2(0.0, -21.0), 5.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35))
	else:
		var pulse := sin(_pulse_phase * 3.0) * 0.5 + 0.5
		draw_circle(Vector2(0.0, -21.0), 2.2, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.6 + pulse * 0.4))


func _draw_drafting_table() -> void:
	# Large backlit drafting table: 54x38 px, angled top
	# Base structural steel legs and foot pedal
	draw_line(Vector2(-20.0, 18.0), Vector2(-15.0, -4.0), COLOR_DARK_STEEL, 2.5)
	draw_line(Vector2(20.0, 18.0), Vector2(15.0, -4.0), COLOR_DARK_STEEL, 2.5)
	draw_line(Vector2(-22.0, 18.0), Vector2(22.0, 18.0), COLOR_DARK_STEEL, 2.0)
	draw_line(Vector2(-16.0, 8.0), Vector2(16.0, 8.0), Color("1a242a"), 1.5)
	
	# Main inclined drafting board chassis: 48x28 px tilted
	var board_rect := Rect2(-24.0, -18.0, 48.0, 24.0)
	draw_rect(board_rect, Color("202c34"))
	draw_rect(board_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Backlit translucent glass work area: 40x18 px
	var glass_rect := Rect2(-20.0, -15.0, 40.0, 18.0)
	var glow_alpha := 0.25 + 0.15 * sin(_pulse_phase * 1.5)
	draw_rect(glass_rect, Color(0.20, 0.35, 0.38, glow_alpha + 0.3))
	draw_rect(glass_rect, COLOR_CYAN * 0.7, false, 0.8)
	
	# Blueprint overlay: Flat 14 floorplan & circuit matrix
	# Technical room grid
	draw_rect(Rect2(-17.0, -13.0, 14.0, 14.0), Color(0.12, 0.22, 0.25, 0.6))
	draw_rect(Rect2(-17.0, -13.0, 14.0, 14.0), COLOR_CYAN * 0.9, false, 0.8)
	# Corridor and Room 2
	draw_rect(Rect2(-1.0, -13.0, 17.0, 7.0), Color(0.12, 0.22, 0.25, 0.6))
	draw_rect(Rect2(-1.0, -13.0, 17.0, 7.0), COLOR_CYAN * 0.9, false, 0.8)
	draw_rect(Rect2(-1.0, -4.0, 17.0, 5.0), Color(0.12, 0.22, 0.25, 0.6))
	draw_rect(Rect2(-1.0, -4.0, 17.0, 5.0), COLOR_CYAN * 0.9, false, 0.8)
	
	# Circuit node connection traces (linking furniture coordinates to substructure)
	draw_line(Vector2(-10.0, -6.0), Vector2(7.0, -6.0), COLOR_AMBER * 0.85, 1.0)
	draw_line(Vector2(7.0, -6.0), Vector2(7.0, -1.0), COLOR_AMBER * 0.85, 1.0)
	draw_circle(Vector2(-10.0, -6.0), 1.2, COLOR_AMBER)
	draw_circle(Vector2(7.0, -1.0), 1.2, COLOR_AMBER)
	# Missing key / photo socket indicator (dotted square)
	draw_rect(Rect2(9.0, -11.0, 5.0, 4.0), COLOR_AMBER, false, 1.0)
	
	# Parallel ruler / drafting arm across the board
	draw_line(Vector2(-23.0, -2.0), Vector2(23.0, -2.0), Color("445b68"), 2.0)
	draw_line(Vector2(-23.0, -2.0), Vector2(23.0, -2.0), Color("7e94a0"), 0.8)
	# Protractor head at top-left
	draw_circle(Vector2(-18.0, -2.0), 3.0, COLOR_DARK_STEEL)
	draw_circle(Vector2(-18.0, -2.0), 1.5, COLOR_INFRASTRUCTURE)
	
	# Clamp lamp on top right corner
	draw_line(Vector2(20.0, -18.0), Vector2(16.0, -24.0), COLOR_DARK_STEEL, 1.5)
	draw_line(Vector2(16.0, -24.0), Vector2(12.0, -22.0), COLOR_DARK_STEEL, 1.5)
	var lamp_head := Rect2(8.0, -24.0, 6.0, 4.0)
	draw_rect(lamp_head, Color("2d3d46"))
	draw_circle(Vector2(10.0, -20.0), 2.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.85))
	draw_circle(Vector2(10.0, -20.0), 6.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.25))


func _draw_topography_index_cabinet() -> void:
	# Heavy steel map & index filing cabinet: 32x54 px
	var frame_rect := Rect2(-16.0, -27.0, 32.0, 54.0)
	draw_rect(frame_rect, Color("25343d"))
	draw_rect(frame_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Top classification banner / brass plate
	var banner_rect := Rect2(-14.0, -25.0, 28.0, 5.0)
	draw_rect(banner_rect, Color("141b20"))
	draw_line(Vector2(-12.0, -22.5), Vector2(12.0, -22.5), COLOR_CYAN * 0.85, 1.0)
	
	# 4 wide drawer sections
	for dy in range(4):
		var y_top: float = -18.0 + float(dy) * 10.5
		var drawer_rect := Rect2(-14.0, y_top, 28.0, 9.0)
		draw_rect(drawer_rect, Color("1e2a31"))
		draw_rect(drawer_rect, Color("364a55"), false, 0.8)
		
		# Brass label frame and pull handle
		var label_rect := Rect2(-7.0, y_top + 2.0, 14.0, 4.0)
		draw_rect(label_rect, Color("111619"))
		draw_rect(label_rect, COLOR_AMBER * 0.7, false, 0.6)
		draw_line(Vector2(-5.0, y_top + 4.0), Vector2(5.0, y_top + 4.0), COLOR_INFRASTRUCTURE * 0.8, 0.8)
		# Pull handle below label
		draw_line(Vector2(-6.0, y_top + 7.0), Vector2(6.0, y_top + 7.0), COLOR_INFRASTRUCTURE, 1.2)
	
	# Top drawer is slightly open showing aperture/index cards
	var open_tray := Rect2(-15.0, -19.0, 30.0, 3.0)
	draw_rect(open_tray, Color("162026"))
	# Index cards peeking out
	for cx in range(-12, 12, 3):
		draw_line(Vector2(float(cx), -19.0), Vector2(float(cx), -21.0), COLOR_AMBER * 0.85, 1.0)
	
	# Base pedestal
	draw_rect(Rect2(-16.0, 24.0, 32.0, 3.0), Color("182025"))


func _draw_jakub_photograph_frame() -> void:
	# Precision optical mounting cradle: 32x26 px
	var cradle_rect := Rect2(-16.0, -13.0, 32.0, 26.0)
	draw_rect(cradle_rect, Color("1a252c"))
	draw_rect(cradle_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Corner mounting registration brackets
	var s: float = 14.0
	var l: float = 3.0
	draw_line(Vector2(-s, -11.0), Vector2(-s + l, -11.0), COLOR_AMBER, 1.0)
	draw_line(Vector2(-s, -11.0), Vector2(-s, -11.0 + l), COLOR_AMBER, 1.0)
	draw_line(Vector2(s, -11.0), Vector2(s - l, -11.0), COLOR_AMBER, 1.0)
	draw_line(Vector2(s, -11.0), Vector2(s, -11.0 + l), COLOR_AMBER, 1.0)
	draw_line(Vector2(-s, 11.0), Vector2(-s + l, 11.0), COLOR_AMBER, 1.0)
	draw_line(Vector2(-s, 11.0), Vector2(-s, 11.0 - l), COLOR_AMBER, 1.0)
	draw_line(Vector2(s, 11.0), Vector2(s - l, 11.0), COLOR_AMBER, 1.0)
	draw_line(Vector2(s, 11.0), Vector2(s, 11.0 - l), COLOR_AMBER, 1.0)
	
	var is_inserted := is_activated or shadow_progress > 0.0
	if not is_inserted:
		# Empty optical slot with guide crosshairs
		var slot_rect := Rect2(-12.0, -9.0, 24.0, 18.0)
		draw_rect(slot_rect, Color("0f1519"))
		draw_rect(slot_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.4), false, 0.8)
		# Registration crosshair
		draw_line(Vector2(-4.0, 0.0), Vector2(4.0, 0.0), COLOR_CYAN * 0.7, 0.8)
		draw_line(Vector2(0.0, -4.0), Vector2(0.0, 4.0), COLOR_CYAN * 0.7, 0.8)
		# Missing key prompt pulse
		var pulse := sin(_pulse_phase * 2.5) * 0.5 + 0.5
		draw_rect(slot_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, pulse * 0.15))
	else:
		# Mounted photographic paper (24x18 px)
		var photo_rect := Rect2(-12.0, -9.0, 24.0, 18.0)
		draw_rect(photo_rect, Color("dcd2bd")) # Warm sepia/cream base
		draw_rect(photo_rect, Color("5c5446"), false, 0.6)
		
		# Lena silhouette figure on the left (x=-7..-4, y=-6..4)
		draw_rect(Rect2(-8.0, -2.0, 4.0, 6.0), Color("2e3438")) # Body
		draw_circle(Vector2(-6.0, -4.0), 2.0, Color("353d42")) # Head
		
		# Young Jakub silhouette in center (x=-3..1, y=-6..4)
		draw_rect(Rect2(-3.0, -1.0, 4.0, 5.0), Color("3a4247")) # Body
		draw_circle(Vector2(-1.0, -3.5), 1.8, Color("434c52")) # Head
		
		# Right third of photograph: Anomalous adult shadow emerging!
		var sp := clampf(maxf(shadow_progress, 1.0 if is_activated else 0.0), 0.0, 1.0)
		if sp > 0.01:
			var shadow_alpha := clampf(sp * 0.90, 0.0, 0.95)
			var shadow_color := Color(0.06, 0.08, 0.10, shadow_alpha)
			var border_color := Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, shadow_alpha * 0.5)
			
			# Adult tall silhouette emerging behind & right of Jakub
			var adult_head := Vector2(4.0, -6.0)
			var adult_body := Rect2(2.0, -3.0, 6.0, 9.0)
			draw_rect(adult_body, shadow_color)
			draw_rect(adult_body, border_color, false, 0.6)
			draw_circle(adult_head, 2.5, shadow_color)
			draw_circle(adult_head, 2.5, border_color)
			
			# Shadow aura / vignette encroaching onto the frame
			draw_line(Vector2(2.0, 6.0), Vector2(10.0, 6.0), border_color, 1.0)


func _draw_resonance_circuit_node() -> void:
	# Heavy wall-mounted junction box: 34x44 px
	var box_rect := Rect2(-17.0, -22.0, 34.0, 44.0)
	draw_rect(box_rect, Color("202d35"))
	draw_rect(box_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Ceramic insulator standoffs top and bottom
	draw_rect(Rect2(-12.0, -25.0, 6.0, 4.0), Color("3a4d57"))
	draw_rect(Rect2(6.0, -25.0, 6.0, 4.0), Color("3a4d57"))
	draw_rect(Rect2(-12.0, 21.0, 6.0, 4.0), Color("3a4d57"))
	draw_rect(Rect2(6.0, 21.0, 6.0, 4.0), Color("3a4d57"))
	
	# Copper busbars entering top and exiting bottom/right
	draw_line(Vector2(-9.0, -27.0), Vector2(-9.0, -16.0), COLOR_AMBER, 1.8)
	draw_line(Vector2(9.0, -27.0), Vector2(9.0, -16.0), COLOR_AMBER, 1.8)
	draw_line(Vector2(9.0, 16.0), Vector2(9.0, 27.0), COLOR_AMBER, 1.8)
	draw_line(Vector2(17.0, 0.0), Vector2(23.0, 0.0), COLOR_AMBER, 2.0)
	
	# Dual Galvanometer meters
	# Meter 1: Vector / Address synchronization
	var meter1_rect := Rect2(-13.0, -16.0, 11.0, 11.0)
	draw_rect(meter1_rect, Color("0d1316"))
	draw_rect(meter1_rect, Color("394e5a"), false, 0.8)
	var needle1_angle: float = 0.85 if is_activated else (sin(_pulse_phase * 2.0) * 0.4 - 0.5)
	draw_line(Vector2(-7.5, -7.0), Vector2(-7.5 + cos(needle1_angle) * 4.0, -7.0 - sin(needle1_angle) * 4.0), COLOR_CYAN, 1.0)
	
	# Meter 2: Personal constant / Resonance load
	var meter2_rect := Rect2(2.0, -16.0, 11.0, 11.0)
	draw_rect(meter2_rect, Color("0d1316"))
	draw_rect(meter2_rect, Color("394e5a"), false, 0.8)
	var needle2_angle: float = 0.95 if is_activated else (sin(_pulse_phase * 1.5 + 1.0) * 0.3 - 0.6)
	draw_line(Vector2(7.5, -7.0), Vector2(7.5 + cos(needle2_angle) * 4.0, -7.0 - sin(needle2_angle) * 4.0), COLOR_AMBER, 1.0)
	
	# Stepping relay bank: 3 indicator lamps
	var lamp1_pos := Vector2(-8.0, 3.0)
	var lamp2_pos := Vector2(0.0, 3.0)
	var lamp3_pos := Vector2(8.0, 3.0)
	
	# Lamp 1: ADRES
	draw_circle(lamp1_pos, 2.2, COLOR_CYAN if is_activated else Color("223b3f"))
	# Lamp 2: SPRZĘŻENIE
	draw_circle(lamp2_pos, 2.2, COLOR_AMBER if is_activated else Color("3f3122"))
	# Lamp 3: BLOKADA (Red locked / Cyan unlocked)
	if is_activated:
		draw_circle(lamp3_pos, 2.2, COLOR_CYAN)
		draw_circle(lamp3_pos, 5.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.3))
	else:
		draw_circle(lamp3_pos, 2.2, COLOR_CORRECTION)
	
	# Terminal connection strip at bottom
	var strip_rect := Rect2(-13.0, 10.0, 26.0, 8.0)
	draw_rect(strip_rect, Color("141c21"))
	for tx in range(-10, 11, 5):
		draw_circle(Vector2(float(tx), 14.0), 1.2, COLOR_INFRASTRUCTURE)


func _draw_tech_passage_airlock() -> void:
	# Heavy maintenance airlock portal: 36x60 px
	var frame_rect := Rect2(-18.0, -30.0, 36.0, 60.0)
	draw_rect(frame_rect, Color("223038"))
	draw_rect(frame_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Heavy steel door panel
	var door_rect := Rect2(-14.0, -25.0, 28.0, 54.0)
	draw_rect(door_rect, Color("151e24"))
	
	# Hazard diagonal stripes on upper lintel
	var lintel_rect := Rect2(-16.0, -29.0, 32.0, 4.0)
	draw_rect(lintel_rect, Color("11171b"))
	for hx in range(-14, 14, 4):
		draw_line(Vector2(float(hx), -29.0), Vector2(float(hx) + 2.5, -25.0), COLOR_AMBER * 0.85, 1.0)
	
	# Center hydraulic locking wheel
	draw_circle(Vector2(0.0, 0.0), 7.0, Color("2d3d47"))
	draw_circle(Vector2(0.0, 0.0), 7.0, COLOR_INFRASTRUCTURE, false, 1.0)
	draw_circle(Vector2(0.0, 0.0), 2.5, COLOR_DARK_STEEL)
	# Locking spokes
	var spoke_rot := _pulse_phase if is_activated else 0.0
	for sp in range(4):
		var ang: float = spoke_rot + float(sp) * PI * 0.5
		draw_line(Vector2(cos(ang) * 2.5, sin(ang) * 2.5), Vector2(cos(ang) * 6.5, sin(ang) * 6.5), COLOR_INFRASTRUCTURE, 1.2)
	
	# Pressure relief valve and hydraulic struts
	draw_line(Vector2(-10.0, -18.0), Vector2(-10.0, 18.0), Color("2f404b"), 1.5)
	draw_line(Vector2(10.0, -18.0), Vector2(10.0, 18.0), Color("2f404b"), 1.5)
	
	# Status Indicator Beacon above door
	var is_open := is_activated
	if is_open:
		draw_circle(Vector2(0.0, -22.0), 2.2, COLOR_CYAN)
		draw_circle(Vector2(0.0, -22.0), 5.5, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.40))
		# Illuminated floor threshold guide strip
		draw_line(Vector2(-14.0, 28.0), Vector2(14.0, 28.0), COLOR_CYAN * 0.9, 1.5)
	else:
		var pulse := sin(_pulse_phase * 3.0) * 0.5 + 0.5
		draw_circle(Vector2(0.0, -22.0), 2.2, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.6 + pulse * 0.4))


func _draw_metal_scratch_beam() -> void:
	# Heavy structural I-beam column: 26x70 px
	var beam_rect := Rect2(-13.0, -35.0, 26.0, 70.0)
	draw_rect(beam_rect, Color("243138"))
	draw_rect(beam_rect, COLOR_INFRASTRUCTURE * 0.85, false, 1.2)
	
	# Recessed inner web (I-beam profile)
	var web_rect := Rect2(-7.0, -30.0, 14.0, 60.0)
	draw_rect(web_rect, Color("182228"))
	draw_line(Vector2(-7.0, -30.0), Vector2(-7.0, 30.0), Color("2f404a"), 1.0)
	draw_line(Vector2(7.0, -30.0), Vector2(7.0, 30.0), Color("2f404a"), 1.0)
	
	# Flange reinforcement plates & rivets top/bottom
	draw_rect(Rect2(-14.0, -35.0, 28.0, 5.0), Color("2f404a"))
	draw_rect(Rect2(-14.0, 30.0, 28.0, 5.0), Color("2f404a"))
	for rx in [-10.0, 10.0]:
		draw_circle(Vector2(rx, -32.5), 1.2, COLOR_INFRASTRUCTURE)
		draw_circle(Vector2(rx, 32.5), 1.2, COLOR_INFRASTRUCTURE)
		draw_circle(Vector2(rx, -15.0), 1.0, Color("3a4f5c"))
		draw_circle(Vector2(rx, 15.0), 1.0, Color("3a4f5c"))
	
	# The Observed Scratch in the Metal (Primary Anchor detail per Scene 14 & VISUAL_DESIGN 6.1)
	var is_anchored := is_activated or shadow_progress > 0.1
	if is_anchored:
		# Cyan locked edge: "cyjan zatrzymuje jedną krawędź; reszta kadru lekko ciągnie ku niej"
		var cyan_glow := Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45)
		# Scratch halo / stabilization zone
		draw_circle(Vector2(0.5, -0.5), 9.0, cyan_glow * 0.35)
		draw_line(Vector2(-8.0, -4.5), Vector2(9.0, 3.5), cyan_glow, 3.2)
		draw_line(Vector2(-8.0, -4.5), Vector2(9.0, 3.5), COLOR_CYAN, 1.6)
		
		# Micro-crystallization tick marks anchoring the edge
		draw_line(Vector2(-8.0, -7.0), Vector2(-8.0, -2.0), COLOR_CYAN, 1.0)
		draw_line(Vector2(0.5, -3.0), Vector2(0.5, 2.0), COLOR_CYAN, 1.0)
		draw_line(Vector2(9.0, 1.0), Vector2(9.0, 6.0), COLOR_CYAN, 1.0)
		
		# Subtle cyan tension lines connecting scratch to beam flanges
		draw_line(Vector2(-8.0, -4.5), Vector2(-13.0, -4.5), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.3), 0.8)
		draw_line(Vector2(9.0, 3.5), Vector2(13.0, 3.5), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.3), 0.8)
	else:
		# Unanchored scratch with slight physical wear and stress fringe
		draw_line(Vector2(-7.5, -4.0), Vector2(8.5, 3.0), Color("8a9ca4"), 1.2)
		draw_line(Vector2(-7.0, -3.5), Vector2(8.0, 3.5), Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.35), 0.8)


func _draw_tape_playback_deck() -> void:
	# Precision Reel-to-Reel Tape Player: 36x30 px
	var chassis_rect := Rect2(-18.0, -15.0, 36.0, 30.0)
	draw_rect(chassis_rect, Color("1c252b"))
	draw_rect(chassis_rect, COLOR_INFRASTRUCTURE * 0.75, false, 1.0)
	
	# Top brushed faceplate
	var face_rect := Rect2(-16.0, -13.0, 32.0, 26.0)
	draw_rect(face_rect, Color("222f37"))
	
	# Left Reel (Supply Spool) at (-9, -4)
	var reel1_pos := Vector2(-9.0, -4.0)
	draw_circle(reel1_pos, 6.5, Color("141c22"))
	draw_circle(reel1_pos, 6.5, COLOR_INFRASTRUCTURE * 0.8, false, 0.8)
	draw_circle(reel1_pos, 2.0, COLOR_AMBER * 0.9)
	# Right Reel (Takeup Spool) at (9, -4)
	var reel2_pos := Vector2(9.0, -4.0)
	draw_circle(reel2_pos, 6.5, Color("141c22"))
	draw_circle(reel2_pos, 6.5, COLOR_INFRASTRUCTURE * 0.8, false, 0.8)
	draw_circle(reel2_pos, 2.0, COLOR_AMBER * 0.9)
	
	# Rotating reel spokes when tape is playing
	var rot := (_pulse_phase * 2.5) if is_activated else 0.0
	for sp in range(3):
		var ang: float = rot + float(sp) * (TAU / 3.0)
		var dir := Vector2(cos(ang), sin(ang))
		draw_line(reel1_pos + dir * 2.0, reel1_pos + dir * 5.8, Color("3a4f5c"), 0.8)
		draw_line(reel2_pos + dir * 2.0, reel2_pos + dir * 5.8, Color("3a4f5c"), 0.8)
	
	# Magnetic tape path running from reel 1 -> guide rollers -> head -> reel 2
	draw_line(reel1_pos + Vector2(0.0, 6.0), Vector2(-4.0, 6.0), Color("584738"), 1.2) # Brown oxide tape
	draw_line(Vector2(-4.0, 6.0), Vector2(4.0, 6.0), Color("584738"), 1.2)
	draw_line(Vector2(4.0, 6.0), reel2_pos + Vector2(0.0, 6.0), Color("584738"), 1.2)
	
	# Playback Magnetic Head at center (0, 6)
	draw_rect(Rect2(-2.5, 4.5, 5.0, 4.0), Color("2f3e48"))
	draw_rect(Rect2(-2.5, 4.5, 5.0, 4.0), COLOR_INFRASTRUCTURE, false, 0.6)
	
	# VU Meter at bottom (-14..-2, y=8..12)
	var vu_rect := Rect2(-14.0, 8.0, 12.0, 4.5)
	draw_rect(vu_rect, Color("0f1519"))
	draw_rect(vu_rect, Color("334652"), false, 0.6)
	var vu_angle := 0.75 if is_activated else (sin(_pulse_phase * 3.0) * 0.3 - 0.4)
	draw_line(Vector2(-8.0, 11.5), Vector2(-8.0 + cos(vu_angle) * 3.5, 11.5 - sin(vu_angle) * 3.5), COLOR_AMBER, 0.8)
	
	# Control buttons (Play / Stop / Reverse)
	for bx in range(2, 14, 4):
		draw_rect(Rect2(float(bx), 8.5, 3.0, 3.5), Color("3a4d59"))
	
	# Degradation / Resonance indicator
	if is_activated:
		var pulse := sin(_pulse_phase * 4.0) * 0.5 + 0.5
		draw_circle(Vector2(0.0, 6.0), 4.5, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, pulse * 0.25))


func _draw_maintenance_rack() -> void:
	# Slotted industrial steel shelving: 30x52 px
	var rack_rect := Rect2(-15.0, -26.0, 30.0, 52.0)
	
	# Vertical uprights
	draw_line(Vector2(-15.0, -26.0), Vector2(-15.0, 26.0), COLOR_INFRASTRUCTURE * 0.9, 1.5)
	draw_line(Vector2(15.0, -26.0), Vector2(15.0, 26.0), COLOR_INFRASTRUCTURE * 0.9, 1.5)
	
	# Shelf levels (Top, Middle, Bottom)
	draw_line(Vector2(-15.0, -12.0), Vector2(15.0, -12.0), Color("2f404b"), 1.8)
	draw_line(Vector2(-15.0, 6.0), Vector2(15.0, 6.0), Color("2f404b"), 1.8)
	draw_line(Vector2(-15.0, 24.0), Vector2(15.0, 24.0), Color("2f404b"), 2.0)
	
	# Top shelf items: Precision continuity caliper & test probe
	draw_line(Vector2(-10.0, -14.0), Vector2(-2.0, -14.0), COLOR_AMBER, 1.2)
	draw_circle(Vector2(-10.0, -14.0), 1.5, COLOR_AMBER)
	draw_line(Vector2(2.0, -14.0), Vector2(10.0, -16.0), COLOR_INFRASTRUCTURE, 1.0)
	
	# Middle shelf items: Hydraulic gasket box & gauge
	draw_rect(Rect2(-11.0, -1.0, 10.0, 6.0), Color("24333c"))
	draw_rect(Rect2(-11.0, -1.0, 10.0, 6.0), Color("3d5461"), false, 0.8)
	draw_circle(Vector2(6.0, 2.0), 3.0, Color("1a242a"))
	draw_circle(Vector2(6.0, 2.0), 3.0, COLOR_CYAN * 0.7, false, 0.8)
	
	# Bottom shelf items: Heavy alignment wrench & metal canister
	draw_line(Vector2(-12.0, 20.0), Vector2(4.0, 20.0), Color("3d525f"), 2.0)
	draw_rect(Rect2(6.0, 15.0, 6.0, 8.0), Color("223038"))
	draw_rect(Rect2(6.0, 15.0, 6.0, 8.0), COLOR_INFRASTRUCTURE * 0.7, false, 0.8)


func _draw_seam_stabilizer_lever() -> void:
	# Heavy cast-iron base: 24x36 px
	var base_rect := Rect2(-12.0, -18.0, 24.0, 36.0)
	draw_rect(base_rect, Color("202c33"))
	draw_rect(base_rect, COLOR_INFRASTRUCTURE * 0.85, false, 1.2)
	
	# Yellow/Black hazard diagonal stripes on bottom baseplate
	var hazard_rect := Rect2(-10.0, 10.0, 20.0, 6.0)
	draw_rect(hazard_rect, Color("11171b"))
	for hx in range(-8, 8, 4):
		draw_line(Vector2(float(hx), 10.0), Vector2(float(hx) + 2.5, 16.0), COLOR_AMBER * 0.8, 1.0)
	
	# Central hydraulic piston shaft
	draw_rect(Rect2(-4.0, -10.0, 8.0, 18.0), Color("151e23"))
	draw_rect(Rect2(-3.0, -8.0, 6.0, 14.0), Color("314450"))
	
	# Mechanical lever arm with pivot at (0, 0)
	var is_locked := is_activated
	var lever_ang := 0.65 if is_locked else -0.85 # Down clamped vs upright disengaged
	var lever_len := 16.0
	var lever_end := Vector2(cos(lever_ang), sin(lever_ang)) * lever_len
	
	draw_circle(Vector2.ZERO, 3.5, Color("3a4f5c"))
	draw_circle(Vector2.ZERO, 3.5, COLOR_INFRASTRUCTURE, false, 1.0)
	draw_line(Vector2.ZERO, lever_end, Color("4a6270"), 2.5)
	draw_circle(lever_end, 2.5, COLOR_AMBER if not is_locked else COLOR_CYAN)
	
	# Pressure lock indicator light
	var lamp_pos := Vector2(0.0, -14.0)
	if is_locked:
		draw_circle(lamp_pos, 2.2, COLOR_CYAN)
		draw_circle(lamp_pos, 5.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35))
	else:
		var pulse := sin(_pulse_phase * 3.0) * 0.5 + 0.5
		draw_circle(lamp_pos, 2.2, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.6 + pulse * 0.4))


func _draw_substructure_conduit_shaft() -> void:
	# Reinforced vertical conduit hatch portal: 34x58 px
	var portal_rect := Rect2(-17.0, -29.0, 34.0, 58.0)
	draw_rect(portal_rect, Color("223038"))
	draw_rect(portal_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Inner airlock hatch panel
	var hatch_rect := Rect2(-13.0, -24.0, 26.0, 50.0)
	draw_rect(hatch_rect, Color("141c22"))
	
	# Upper ventilation louvers
	for ly in range(-21, -12, 3):
		draw_line(Vector2(-10.0, float(ly)), Vector2(10.0, float(ly)), Color("2c3d47"), 1.0)
	
	# Center hydraulic locking wheel
	draw_circle(Vector2(0.0, 2.0), 6.5, Color("2b3c46"))
	draw_circle(Vector2(0.0, 2.0), 6.5, COLOR_INFRASTRUCTURE, false, 1.0)
	draw_circle(Vector2(0.0, 2.0), 2.2, COLOR_DARK_STEEL)
	
	var rot := (_pulse_phase * 1.5) if is_activated else 0.0
	for sp in range(4):
		var ang: float = rot + float(sp) * PI * 0.5
		draw_line(Vector2(0.0, 2.0) + Vector2(cos(ang), sin(ang)) * 2.2, Vector2(0.0, 2.0) + Vector2(cos(ang), sin(ang)) * 6.0, COLOR_INFRASTRUCTURE, 1.0)
	
	# Bottom conduit penetration flange with downward feeding cables
	draw_rect(Rect2(-12.0, 18.0, 24.0, 7.0), Color("1b262d"))
	for cx in [-8.0, -3.0, 3.0, 8.0]:
		draw_line(Vector2(cx, 18.0), Vector2(cx, 28.0), Color("0f161a"), 2.0)
		draw_line(Vector2(cx, 18.0), Vector2(cx, 28.0), Color("2f404a"), 0.8)
	
	# Status Indicator Beacon above hatch
	var is_open := is_activated
	if is_open:
		draw_circle(Vector2(0.0, -25.0), 2.2, COLOR_CYAN)
		draw_circle(Vector2(0.0, -25.0), 5.5, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.40))
		# Illuminated floor threshold guide strip
		draw_line(Vector2(-13.0, 27.0), Vector2(13.0, 27.0), COLOR_CYAN * 0.9, 1.5)
	else:
		var pulse := sin(_pulse_phase * 3.0) * 0.5 + 0.5
		draw_circle(Vector2(0.0, -25.0), 2.2, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.6 + pulse * 0.4))


func _draw_hygiene_instruction_board() -> void:
	# Metal-framed wall display board: 28x38 px
	var frame_rect := Rect2(-14.0, -19.0, 28.0, 38.0)
	draw_rect(frame_rect, Color("202c33"))
	draw_rect(frame_rect, COLOR_INFRASTRUCTURE * 0.85, false, 1.2)
	
	# Board background
	var board_rect := Rect2(-12.0, -17.0, 24.0, 34.0)
	draw_rect(board_rect, Color("182329"))
	
	# Top administrative header banner (UCP Sage/Cyan)
	draw_rect(Rect2(-11.0, -16.0, 22.0, 5.0), Color("283d47"))
	draw_line(Vector2(-9.0, -13.5), Vector2(3.0, -13.5), COLOR_CYAN * 0.8, 1.0)
	
	# Official hygiene directive lines (Clean sans-serif text imitation)
	for ly in [-8, -4, 0, 4, 8]:
		var line_w := 18.0 if ly != 8 else 10.0
		draw_line(Vector2(-9.0, float(ly)), Vector2(-9.0 + line_w, float(ly)), COLOR_INFRASTRUCTURE * 0.75, 1.0)
		# Left bullet marker
		draw_circle(Vector2(-10.0, float(ly)), 0.6, COLOR_CYAN * 0.7)
	
	# Official red/amber security stamp in upper right
	draw_circle(Vector2(6.5, -7.0), 2.2, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.65))
	draw_circle(Vector2(6.5, -7.0), 2.2, COLOR_CORRECTION * 0.9, false, 0.8)
	
	# Hand-written margin annotations in bottom-right corner (Lena's pencil notes)
	draw_line(Vector2(1.0, 7.0), Vector2(9.0, 5.0), COLOR_AMBER * 0.9, 1.0)
	draw_line(Vector2(2.0, 10.0), Vector2(10.0, 8.5), COLOR_AMBER * 0.8, 0.8)
	draw_line(Vector2(0.0, 13.0), Vector2(8.0, 12.0), COLOR_AMBER * 0.85, 0.8)
	
	# Subtle glass protective layer sheen
	draw_line(Vector2(-10.0, -15.0), Vector2(5.0, 14.0), Color(1.0, 1.0, 1.0, 0.12), 1.0)


func _draw_handwritten_correlation_formula() -> void:
	# Industrial conduit pipeline segment: 38x26 px
	var pipe_rect := Rect2(-19.0, -13.0, 38.0, 26.0)
	draw_rect(pipe_rect, Color("1e2a32"))
	
	# Cylindrical gradient highlight lines
	draw_line(Vector2(-19.0, -8.0), Vector2(19.0, -8.0), Color("364b58"), 2.0)
	draw_line(Vector2(-19.0, 8.0), Vector2(19.0, 8.0), Color("121a1f"), 2.0)
	draw_rect(pipe_rect, Color("2d3f4a"), false, 1.0)
	
	# Flange collars at ends
	draw_rect(Rect2(-19.0, -14.0, 4.0, 28.0), Color("283741"))
	draw_rect(Rect2(15.0, -14.0, 4.0, 28.0), Color("283741"))
	
	# Rivet studs
	draw_circle(Vector2(-17.0, -9.0), 1.0, COLOR_INFRASTRUCTURE)
	draw_circle(Vector2(-17.0, 9.0), 1.0, COLOR_INFRASTRUCTURE)
	draw_circle(Vector2(17.0, -9.0), 1.0, COLOR_INFRASTRUCTURE)
	draw_circle(Vector2(17.0, 9.0), 1.0, COLOR_INFRASTRUCTURE)
	
	# Handwritten correlation formula in Lena's tight handwriting with open numeral 4
	var formula_col := COLOR_AMBER if not is_activated else Color("f5be87")
	
	# Integral loop sign \oint
	draw_line(Vector2(-12.0, -5.0), Vector2(-12.0, 5.0), formula_col, 1.2)
	draw_circle(Vector2(-12.0, 0.0), 1.8, formula_col, false, 0.8)
	
	# Psi symbol \Psi
	draw_line(Vector2(-6.0, -5.0), Vector2(-6.0, 5.0), formula_col, 1.2)
	draw_line(Vector2(-8.5, -2.0), Vector2(-3.5, -2.0), formula_col, 1.0)
	draw_line(Vector2(-8.5, -2.0), Vector2(-8.5, -4.0), formula_col, 1.0)
	draw_line(Vector2(-3.5, -2.0), Vector2(-3.5, -4.0), formula_col, 1.0)
	
	# Sync vector arrow \vec{A}
	draw_line(Vector2(-1.0, -2.0), Vector2(2.0, 3.0), formula_col, 1.0)
	draw_line(Vector2(2.0, 3.0), Vector2(5.0, -2.0), formula_col, 1.0)
	draw_line(Vector2(0.5, 0.5), Vector2(3.5, 0.5), formula_col, 0.8)
	draw_line(Vector2(0.0, -4.5), Vector2(4.0, -4.5), formula_col * 0.9, 0.8)
	
	# Characteristic open-top numeral 4 (per VISUAL_DESIGN.md Section 6.3)
	# Vertical left, horizontal cross, and right downstroke (open at top)
	draw_line(Vector2(8.0, -4.0), Vector2(8.0, 0.5), formula_col, 1.2)
	draw_line(Vector2(7.0, 0.5), Vector2(13.0, 0.5), formula_col, 1.2)
	draw_line(Vector2(11.5, -3.0), Vector2(11.5, 5.0), formula_col, 1.2)
	
	# Delta tau offset \Delta\tau
	draw_line(Vector2(14.0, 4.0), Vector2(16.0, 0.0), formula_col * 0.8, 0.8)
	draw_line(Vector2(16.0, 0.0), Vector2(18.0, 4.0), formula_col * 0.8, 0.8)
	draw_line(Vector2(14.0, 4.0), Vector2(18.0, 4.0), formula_col * 0.8, 0.8)
	
	# Chalk/marker glow if activated
	if is_activated or _resonance_flash > 0.0:
		draw_rect(Rect2(-15.0, -7.0, 30.0, 14.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.18 + _resonance_flash * 0.25))


func _draw_reflective_puddle() -> void:
	# Upper wall indicator sign (Direct view - points LEFT into false dead end)
	var sign_rect := Rect2(-10.0, -20.0, 20.0, 10.0)
	draw_rect(sign_rect, Color("1e2a32"))
	draw_rect(sign_rect, COLOR_INFRASTRUCTURE * 0.7, false, 0.8)
	
	# Direct arrow pointing LEFT
	var left_arrow_col := COLOR_CORRECTION * 0.85
	draw_line(Vector2(5.0, -15.0), Vector2(-4.0, -15.0), left_arrow_col, 1.5)
	draw_line(Vector2(-4.0, -15.0), Vector2(-1.0, -18.0), left_arrow_col, 1.2)
	draw_line(Vector2(-4.0, -15.0), Vector2(-1.0, -12.0), left_arrow_col, 1.2)
	
	# Puddle floor basin: ellipse at (0, 6)
	var basin_center := Vector2(0.0, 6.0)
	# Outer indentation
	draw_rect(Rect2(-24.0, 0.0, 48.0, 12.0), Color("121a20"))
	
	# Water surface elliptical layers
	draw_circle(basin_center + Vector2(-6.0, 0.0), 9.0, Color("162630"))
	draw_circle(basin_center + Vector2(6.0, 0.0), 9.0, Color("162630"))
	draw_rect(Rect2(-15.0, 2.0, 30.0, 8.0), Color("162630"))
	
	# Concentric ripples from dripping water
	var rip_radius := fmod(_pulse_phase * 6.0, 16.0)
	var rip_alpha := 1.0 - (rip_radius / 16.0)
	draw_arc(basin_center, rip_radius, 0.0, TAU, 16, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, rip_alpha * 0.4), 1.0)
	
	# ASYNCHRONOUS REFLECTED ARROW: Points RIGHT (revealed in puddle reflection!)
	var right_arrow_col := COLOR_CYAN if is_activated else Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.75)
	draw_line(basin_center + Vector2(-5.0, 0.0), basin_center + Vector2(4.0, 0.0), right_arrow_col, 1.8)
	draw_line(basin_center + Vector2(4.0, 0.0), basin_center + Vector2(1.0, -3.0), right_arrow_col, 1.4)
	draw_line(basin_center + Vector2(4.0, 0.0), basin_center + Vector2(1.0, 3.0), right_arrow_col, 1.4)
	
	# Water surface specular gleam
	draw_line(basin_center + Vector2(-12.0, -2.0), basin_center + Vector2(-4.0, -2.0), Color(1.0, 1.0, 1.0, 0.25), 1.0)


func _draw_pressure_relief_valve() -> void:
	# Heavy industrial decompression valve on pipe: 24x34 px
	var body_rect := Rect2(-11.0, -17.0, 22.0, 34.0)
	draw_rect(body_rect, Color("222f37"))
	draw_rect(body_rect, COLOR_INFRASTRUCTURE * 0.8, false, 1.0)
	
	# Upper bypass pipe connection & exhaust nozzle
	draw_rect(Rect2(-5.0, -22.0, 10.0, 6.0), Color("1a242a"))
	draw_line(Vector2(0.0, -22.0), Vector2(8.0, -26.0), COLOR_INFRASTRUCTURE, 2.0)
	
	# Analog circular manometer dial
	var gauge_center := Vector2(0.0, -6.0)
	draw_circle(gauge_center, 7.5, Color("151e24"))
	draw_circle(gauge_center, 7.5, COLOR_INFRASTRUCTURE, false, 1.0)
	draw_circle(gauge_center, 6.0, Color("2d3e48"))
	
	# Dial tick marks
	for a in range(5):
		var ang := -PI * 0.75 + float(a) * PI * 0.375
		var p1 := gauge_center + Vector2(cos(ang), sin(ang)) * 4.2
		var p2 := gauge_center + Vector2(cos(ang), sin(ang)) * 5.8
		draw_line(p1, p2, COLOR_INFRASTRUCTURE, 0.8)
	
	# Needle: High pressure (danger / cinnabar) vs Depressurized (safe / cyan)
	var is_open := is_activated
	var needle_ang := -PI * 0.65 if is_open else (PI * 0.25 + sin(_pulse_phase * 4.0) * 0.08)
	var needle_col := COLOR_CYAN if is_open else COLOR_CORRECTION
	draw_line(gauge_center, gauge_center + Vector2(cos(needle_ang), sin(needle_ang)) * 5.2, needle_col, 1.2)
	draw_circle(gauge_center, 1.5, COLOR_DARK_STEEL)
	
	# Manual bypass lever arm
	var lever_pivot := Vector2(7.0, 7.0)
	var lever_ang := 0.85 if is_open else -0.75
	var lever_len := 12.0
	var lever_end := lever_pivot + Vector2(cos(lever_ang), sin(lever_ang)) * lever_len
	
	draw_circle(lever_pivot, 2.5, Color("354955"))
	draw_line(lever_pivot, lever_end, Color("496373"), 2.0)
	draw_circle(lever_end, 2.2, COLOR_CYAN if is_open else COLOR_AMBER)
	
	# Status diode
	var diode_pos := Vector2(-6.0, 8.0)
	if is_open:
		draw_circle(diode_pos, 1.8, COLOR_CYAN)
		draw_circle(diode_pos, 4.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35))
	else:
		var pulse := sin(_pulse_phase * 3.0) * 0.5 + 0.5
		draw_circle(diode_pos, 1.8, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.6 + pulse * 0.4))


func _draw_transit_service_gate() -> void:
	# Heavy reinforced steel security portal: 36x62 px
	var portal_rect := Rect2(-18.0, -31.0, 36.0, 62.0)
	draw_rect(portal_rect, Color("202c34"))
	draw_rect(portal_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Inner gate chamber cavity
	var inner_rect := Rect2(-14.0, -25.0, 28.0, 52.0)
	draw_rect(inner_rect, Color("141d22"))
	
	var is_open := is_activated
	
	if is_open:
		# Illuminated transit corridor opening into Space 16
		draw_rect(Rect2(-12.0, -22.0, 24.0, 48.0), Color("22363f"))
		# Floor guide light beam
		draw_line(Vector2(-12.0, 25.0), Vector2(12.0, 25.0), COLOR_CYAN, 1.8)
		# Raised gate shutter panels
		draw_rect(Rect2(-13.0, -24.0, 26.0, 10.0), Color("2b3c46"))
		draw_rect(Rect2(-13.0, -24.0, 26.0, 10.0), COLOR_INFRASTRUCTURE * 0.7, false, 0.8)
	else:
		# Lowered heavy steel sliding shutter with diagonal hazard warning stripes
		draw_rect(Rect2(-13.0, -23.0, 26.0, 47.0), Color("1a242b"))
		for sy in range(-20, 22, 6):
			draw_line(Vector2(-11.0, float(sy)), Vector2(11.0, float(sy)), Color("2c3e49"), 1.0)
		# Center electromagnetic locking deadbolt bar
		draw_rect(Rect2(-3.0, -8.0, 6.0, 16.0), Color("394e5b"))
		draw_rect(Rect2(-3.0, -8.0, 6.0, 16.0), COLOR_INFRASTRUCTURE, false, 1.0)
	
	# Overhead status beacon light
	var beacon_pos := Vector2(0.0, -27.0)
	if is_open:
		draw_circle(beacon_pos, 2.5, COLOR_CYAN)
		draw_circle(beacon_pos, 6.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.40))
	else:
		var pulse := sin(_pulse_phase * 3.0) * 0.5 + 0.5
		draw_circle(beacon_pos, 2.5, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.6 + pulse * 0.4))


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
	# Scene 42A: Two cups on wooden desk, framed photograph with adult Jakub, telephone
	var desk_rect := Rect2(-24.0, 4.0, 48.0, 16.0)
	var photo_rect := Rect2(-18.0, -18.0, 16.0, 20.0)
	var pulse: float = 0.5 + 0.5 * sin(_pulse_phase * 2.5)
	
	# Wooden laboratory desk surface
	draw_rect(desk_rect, Color("2b1d14"))
	draw_rect(desk_rect, Color("5e3c28"), false, 1.2)
	
	# Cup 1 (Left porcelain cup - Lena)
	draw_rect(Rect2(-12.0, -2.0, 6.0, 7.0), Color("dcdfd8"))
	draw_line(Vector2(-12.0, 1.0), Vector2(-14.0, 1.0), Color("dcdfd8"), 1.0)
	# Cup 2 (Right porcelain cup - colleague returning with coffee)
	draw_rect(Rect2(-4.0, -2.0, 6.0, 7.0), Color("dcdfd8"))
	draw_line(Vector2(2.0, 1.0), Vector2(4.0, 1.0), Color("dcdfd8"), 1.0)
	
	# Framed photo of Jakub (adult shadow appears/fades)
	draw_rect(photo_rect, Color("141d24"))
	draw_rect(photo_rect, Color("4a6878"), false, 1.0)
	# Photo paper
	draw_rect(Rect2(-16.0, -16.0, 12.0, 16.0), Color("d4dfdc"))
	# Adult Jakub silhouette
	var adult_alpha: float = 0.40 + 0.55 * pulse if is_activated else 0.30
	draw_rect(Rect2(-14.0, -10.0, 8.0, 10.0), Color(0.12, 0.18, 0.22, adult_alpha))
	draw_circle(Vector2(-10.0, -12.0), 2.5, Color(0.12, 0.18, 0.22, adult_alpha))
	
	# Telephone handset
	draw_rect(Rect2(8.0, -4.0, 12.0, 9.0), Color("121417"))
	draw_rect(Rect2(6.0, -8.0, 16.0, 4.0), Color("1a1d21"))
	
	if is_activated:
		draw_rect(desk_rect, Color(0.83, 0.60, 0.38, 0.30 + pulse * 0.20), false, 1.2)


func _draw_epilogue_marta_doorstep() -> void:
	# Scene 42B: Marta in doorway of Flat 14, tea cup, brass key on doorstep, ring gesture
	var frame_rect := Rect2(-20.0, -28.0, 40.0, 56.0)
	var door_opening := Rect2(-16.0, -24.0, 32.0, 52.0)
	var pulse: float = 0.5 + 0.5 * sin(_pulse_phase * 3.0)
	
	# Modernist door frame
	draw_rect(frame_rect, Color("211b15"))
	draw_rect(frame_rect, Color("523e2b"), false, 1.4)
	
	# Warm interior light of flat 14. Marta herself is a CharacterVisualRig
	# sibling (PKG-0172 / GATE-CAST); this prop draws only the doorframe.
	draw_rect(door_opening, Color(0.83, 0.60, 0.38, 0.22 if is_activated else 0.10))
	
	# Small table with single tea cup
	draw_rect(Rect2(8.0, 6.0, 10.0, 18.0), Color("261d15"))
	draw_rect(Rect2(10.0, 2.0, 5.0, 5.0), Color("dcdfd8"))
	
	# Brass key on doorstep from inside
	draw_line(Vector2(-10.0, 26.0), Vector2(-4.0, 26.0), Color("d39a62" if is_activated else "523e2b"), 1.4)
	draw_circle(Vector2(-10.0, 26.0), 2.0, Color("d39a62" if is_activated else "523e2b"))
	
	if is_activated:
		draw_rect(frame_rect, Color(0.83, 0.60, 0.38, 0.40 + pulse * 0.25), false, 1.4)


func _draw_epilogue_tram_dual_tracks() -> void:
	# Scene 42C: Morning tram stopped before dual overlapping tracks, driver with logbook
	var ground_rect := Rect2(-30.0, 14.0, 60.0, 16.0)
	var tram_front := Rect2(-18.0, -22.0, 36.0, 36.0)
	var pulse: float = 0.5 + 0.5 * sin(_pulse_phase * 2.8)
	
	# Asphalt road & trackbed
	draw_rect(ground_rect, Color("12181d"))
	
	# Dual overlapping rails emerging from underneath tram
	# Left track (Track Alpha)
	draw_line(Vector2(-12.0, 14.0), Vector2(-22.0, 30.0), Color("5da398"), 1.6)
	draw_line(Vector2(-4.0, 14.0), Vector2(-14.0, 30.0), Color("5da398"), 1.6)
	# Right track (Track Beta - overlapping and distinct)
	draw_line(Vector2(4.0, 14.0), Vector2(14.0, 30.0), Color("d39a62"), 1.6)
	draw_line(Vector2(12.0, 14.0), Vector2(22.0, 30.0), Color("d39a62"), 1.6)
	
	# Red/cream classic Polish tram front (Konstal 105Na silhouette)
	draw_rect(tram_front, Color("18222b"))
	draw_rect(tram_front, Color("3d5566"), false, 1.4)
	
	# Front windscreen with motornicza silhouette and clipboard
	draw_rect(Rect2(-14.0, -18.0, 28.0, 14.0), Color("0d1720"))
	draw_rect(Rect2(-14.0, -18.0, 28.0, 14.0), Color("5da398" if is_activated else "283c47"), false, 1.0)
	# Driver silhouette
	draw_circle(Vector2(-4.0, -11.0), 3.0, Color("1a2936"))
	# Clipboard in hand
	draw_rect(Rect2(2.0, -12.0, 5.0, 7.0), Color("d39a62" if is_activated else "4a3828"))
	
	# Dual headlights
	var head_l := Color(0.95, 0.85, 0.65, 0.85 if is_activated else 0.40)
	draw_circle(Vector2(-10.0, 6.0), 2.8, head_l)
	draw_circle(Vector2(10.0, 6.0), 2.8, head_l)
	
	# Direction display "LINIA 4 / DWIE TRASY"
	draw_rect(Rect2(-12.0, -21.0, 24.0, 4.0), Color("0a1218"))
	draw_line(Vector2(-8.0, -19.0), Vector2(8.0, -19.0), Color("e2b060" if is_activated else "4a3a20"), 1.0)
	
	if is_activated:
		draw_rect(tram_front, Color(0.36, 0.64, 0.60, 0.35 + pulse * 0.20), false, 1.4)


func _draw_epilogue_admin_notice_board() -> void:
	# Scene 43: Neutral administrative message board & Municipal radio receiver
	var board_rect := Rect2(-24.0, -20.0, 48.0, 40.0)
	var radio_rect := Rect2(-18.0, 4.0, 36.0, 14.0)
	var pulse: float = 0.5 + 0.5 * sin(_pulse_phase * 2.0)
	
	# Enamelled steel notice board
	draw_rect(board_rect, Color("131a21"))
	draw_rect(board_rect, Color("354957"), false, 1.4)
	
	# Header bar "UCP / KOMUNIKAT BIEŻĄCY"
	draw_rect(Rect2(-22.0, -18.0, 44.0, 6.0), Color("1c2833"))
	draw_line(Vector2(-18.0, -15.0), Vector2(18.0, -15.0), Color("5da398"), 1.0)
	
	# 3 lines of administrative typed text
	draw_line(Vector2(-20.0, -8.0), Vector2(16.0, -8.0), Color(0.70, 0.78, 0.82, 0.65), 1.0)
	draw_line(Vector2(-20.0, -4.0), Vector2(10.0, -4.0), Color(0.70, 0.78, 0.82, 0.65), 1.0)
	draw_line(Vector2(-20.0, 0.0), Vector2(18.0, 0.0), Color(0.70, 0.78, 0.82, 0.65), 1.0)
	
	# Municipal emergency radio unit
	draw_rect(radio_rect, Color("1f1612"))
	draw_rect(radio_rect, Color("5e3c28"), false, 1.0)
	# Tuning dial and speaker grille
	draw_circle(Vector2(-10.0, 11.0), 3.0, Color("d39a62" if is_activated else "4a3525"))
	for g in range(3):
		var gx: float = 2.0 + float(g) * 4.0
		draw_line(Vector2(gx, 7.0), Vector2(gx, 15.0), Color("d39a62" if is_activated else "3d291c"), 1.0)
	
	if is_activated:
		draw_rect(board_rect, Color(0.70, 0.78, 0.82, 0.35 + pulse * 0.20), false, 1.2)


func _draw_epilogue_credits_roll() -> void:
	# Scene 43: Rolling Credits projected across architectural facade
	var facade_rect := Rect2(-30.0, -22.0, 60.0, 44.0)
	var pulse: float = 0.5 + 0.5 * sin(_pulse_phase * 2.2)
	
	# Modernist facade plate
	draw_rect(facade_rect, Color("0a1015"))
	draw_rect(facade_rect, Color("223542"), false, 1.2)
	
	# Vertical architectural pilasters
	draw_line(Vector2(-20.0, -22.0), Vector2(-20.0, 22.0), Color("17242e"), 1.0)
	draw_line(Vector2(0.0, -22.0), Vector2(0.0, 22.0), Color("17242e"), 1.0)
	draw_line(Vector2(20.0, -22.0), Vector2(20.0, 22.0), Color("17242e"), 1.0)
	
	# Rolling typographic credit bars
	var text_col := Color(0.83, 0.60, 0.38, 0.85 if is_activated else 0.45)
	draw_line(Vector2(-16.0, -14.0), Vector2(16.0, -14.0), text_col, 1.4)
	draw_line(Vector2(-12.0, -8.0), Vector2(12.0, -8.0), text_col * 0.8, 1.0)
	draw_line(Vector2(-18.0, 0.0), Vector2(18.0, 0.0), text_col, 1.4)
	draw_line(Vector2(-10.0, 6.0), Vector2(10.0, 6.0), text_col * 0.8, 1.0)
	draw_line(Vector2(-14.0, 14.0), Vector2(14.0, 14.0), text_col, 1.4)
	
	if is_activated:
		draw_rect(facade_rect, Color(0.83, 0.60, 0.38, 0.30 + pulse * 0.20), false, 1.4)


func _draw_epilogue_final_blackout() -> void:
	# Scene 43: Final Blackout & Resolution
	var frame_rect := Rect2(-24.0, -30.0, 48.0, 60.0)
	var pulse: float = 0.5 + 0.5 * sin(_pulse_phase * 1.5)
	
	# Pure midnight resolution portal
	draw_rect(frame_rect, Color("04080b"))
	draw_rect(frame_rect, Color("1a2a35"), false, 1.4)
	
	# Centered pure sine horizon line
	var line_alpha: float = 0.85 if is_activated else 0.35
	draw_line(Vector2(-18.0, 0.0), Vector2(18.0, 0.0), Color(0.46, 0.78, 0.76, line_alpha), 1.2)
	draw_circle(Vector2(0.0, 0.0), 2.2, Color(0.83, 0.60, 0.38, line_alpha))
	
	if is_activated:
		draw_rect(frame_rect, Color(0.36, 0.64, 0.60, 0.40 + pulse * 0.25), false, 1.6)






















## PKG-0140 (D-147). Kontaktowy odczyt wizualny: jeden cichy luk pod rekwizytem
## i jeden punkt styku. Rysowany pod wlasciwym rekwizytem, wiec zaden z 200+
## rysunkow nie musial byc przepisany, a stacja nie dostaje zadnego HUD-u.
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
