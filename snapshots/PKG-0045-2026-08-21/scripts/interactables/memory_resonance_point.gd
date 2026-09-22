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
var _particles: CPUParticles2D
var _collision_shape: CollisionShape2D
var _circle_shape: CircleShape2D


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
		_:
			_memory_sound = ProceduralAudio.create_memory_resonance_sound()
	
	_audio_player = get_node_or_null("AudioPlayer2D") as AudioStreamPlayer2D
	if _audio_player == null:
		_audio_player = AudioStreamPlayer2D.new()
		_audio_player.name = "AudioPlayer2D"
		_audio_player.max_distance = 500.0
		_audio_player.bus = &"Master"
		add_child(_audio_player)


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
		add_child(_particles)


func _process(delta: float) -> void:
	_pulse_phase += delta * 2.8
	if _resonance_flash > 0.0:
		_resonance_flash = maxf(0.0, _resonance_flash - delta * 2.2)
		queue_redraw()
	elif is_player_in_range or prop_type == PropType.DESK_TELEPHONE or prop_type == PropType.DOOR_CARD_READER or prop_type == PropType.GOLD_RING or prop_type == PropType.BUS_SPEAKER or prop_type == PropType.STAIR_TIMER_SWITCH or prop_type == PropType.MARTA_INTERACTION or prop_type == PropType.CIPHER_DESK or prop_type == PropType.TEA_KETTLE or prop_type == PropType.BATHROOM_MIRROR or prop_type == PropType.SCRATCHED_INSCRIPTION or prop_type == PropType.BATHROOM_SINK or prop_type == PropType.BAKELITE_PHONE or prop_type == PropType.REEL_TAPE_RECORDER or prop_type == PropType.TOPOGRAPHY_BOARD or prop_type == PropType.JAKUB_DESK_LAMP or prop_type == PropType.TECH_STORAGE_AIRLOCK or prop_type == PropType.OBSERVATION_WINDOW or prop_type == PropType.ERASED_DOORWAY_TRACE or prop_type == PropType.UCP_INTERVENTION_TEAM or prop_type == PropType.ELDERLY_RESIDENT_GUIDE or prop_type == PropType.MARTA_OBSERVATION_DIALOGUE or prop_type == PropType.COURTYARD_EXIT_AIRLOCK or prop_type == PropType.UCP_INFO_TERMINAL or prop_type == PropType.SHOWCASE_VITRINE or prop_type == PropType.INSTRUCTION_POSTER or prop_type == PropType.SUBWAY_TILE_PILLAR or prop_type == PropType.UNDERPASS_EXIT_GATE or prop_type == PropType.DRAFTING_TABLE or prop_type == PropType.TOPOGRAPHY_INDEX_CABINET or prop_type == PropType.JAKUB_PHOTOGRAPH_FRAME or prop_type == PropType.RESONANCE_CIRCUIT_NODE or prop_type == PropType.TECH_PASSAGE_AIRLOCK or prop_type == PropType.METAL_SCRATCH_BEAM or prop_type == PropType.TAPE_PLAYBACK_DECK or prop_type == PropType.MAINTENANCE_RACK or prop_type == PropType.SEAM_STABILIZER_LEVER or prop_type == PropType.SUBSTRUCTURE_CONDUIT_SHAFT or prop_type == PropType.HYGIENE_INSTRUCTION_BOARD or prop_type == PropType.HANDWRITTEN_CORRELATION_FORMULA or prop_type == PropType.REFLECTIVE_PUDDLE or prop_type == PropType.PRESSURE_RELIEF_VALVE or prop_type == PropType.TRANSIT_SERVICE_GATE or prop_type == PropType.CRACKED_TEA_CUP or prop_type == PropType.CORRELATION_DOSSIER or prop_type == PropType.KITCHEN_CLOCK or prop_type == PropType.WEDDING_RING_STAND or prop_type == PropType.BALCONY_EXIT_DOOR or prop_type == PropType.QUEUING_TICKET_DISPENSER or prop_type == PropType.COMPLIANCE_WAITING_BENCH or prop_type == PropType.PNEUMATIC_DOSSIER_STATION or prop_type == PropType.DIAGNOSTIC_MEMORY_PRINTER or prop_type == PropType.CONSULTATION_OFFICE_DOOR or prop_type == PropType.WIERZBICKA_DESK or prop_type == PropType.SENSORY_MEMORY_MAP or prop_type == PropType.CORRECTION_GALVANOMETER or prop_type == PropType.ACOUSTIC_WEIGHT_CONDUIT or prop_type == PropType.MODEL_ROOM_AIRLOCK or prop_type == PropType.MODEL_DISPLAY_TABLE or prop_type == PropType.STAIRCASE_MAP_LEFT or prop_type == PropType.STAIRCASE_MAP_RIGHT or prop_type == PropType.ELEVEN_PERSONS_LEDGER or prop_type == PropType.MODEL_ROOM_EXIT or prop_type == PropType.SZYMON_BERA or prop_type == PropType.WELL_DRAWING or prop_type == PropType.HYDROLOGY_REPORT or prop_type == PropType.ERASED_SIGNATURE_MAGNIFIER or prop_type == PropType.SZYMON_ROOM_EXIT or prop_type == PropType.SZYMON_POST_CORRECTION or prop_type == PropType.ANESTHESIA_TERMINAL or prop_type == PropType.FILTERED_DOSSIER_SLOT or prop_type == PropType.DRAWING_DISPOSITION_PEDESTAL or prop_type == PropType.STATION_21_EXIT or prop_type == PropType.BIOMETRIC_IDENTITY_GATE or prop_type == PropType.COMPLIANCE_CONTACT_REGISTER or prop_type == PropType.RING_FITTING_SCANNER or prop_type == PropType.PAINT_RESIN_RESONANCE_SLAB or prop_type == PropType.STATION_22_EXIT or prop_type == PropType.DESIGNER_TERMINAL or prop_type == PropType.SUBSTRUCTURE_ARCHITECTURAL_MODEL or prop_type == PropType.BURDENED_PERSONS_LEDGER or prop_type == PropType.SHADOW_INTERACTIVE_CONSOLE or prop_type == PropType.STATION_23_EXIT or prop_type == PropType.CCTV_SURVEILLANCE_ARRAY or prop_type == PropType.CORRECTION_ACCUMULATION_GAUGE or prop_type == PropType.WIERZBICKA_TRANSMISSION_TERMINAL or prop_type == PropType.LENA_DISPOSITION_SELECTOR or prop_type == PropType.STATION_24_EXIT or prop_type == PropType.JAKUB_OPERATOR_UCP or prop_type == PropType.TRANSIT_MAINTENANCE_CART or prop_type == PropType.SCAR_DIAGNOSTIC_CHART or prop_type == PropType.JAKUB_HAND_GESTURE_SENSOR or prop_type == PropType.STATION_25_EXIT or prop_type == PropType.ISOLATION_ZONE_CONSOLE or prop_type == PropType.DYNAMIC_ROOM_DESIGNATOR or prop_type == PropType.MOTIVATION_ANCHOR_RECORD or prop_type == PropType.WIERZBICKA_PA_SPEAKER or prop_type == PropType.STATION_26_EXIT or prop_type == PropType.JAKUB_SERVICE_OPERATOR or prop_type == PropType.SAVED_WORKER_BADGE or prop_type == PropType.SURFACE_STABILITY_MONITOR or prop_type == PropType.TECHNICAL_JUNCTION_CONSOLE or prop_type == PropType.STATION_27_EXIT:
		queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if not is_player_in_range:
		return
	if event.is_action_pressed(&"interact"):
		trigger_interaction()
		get_viewport().set_input_as_handled()


func trigger_interaction() -> void:
	if is_one_shot and is_activated:
		return
	
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
	else:
		is_activated = true
		if _audio_player and _memory_sound:
			_audio_player.stream = _memory_sound
			_audio_player.pitch_scale = 1.0 + randf_range(-0.02, 0.02)
			_audio_player.play()
	
	_resonance_flash = 1.0
	if _particles:
		_particles.restart()
		_particles.emitting = true
	
	resonance_triggered.emit(resonance_id, int(prop_type))
	queue_redraw()


func _on_body_entered(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		is_player_in_range = true


func _on_body_exited(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		is_player_in_range = false


func _draw() -> void:
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
	
	# Proximity & Interaction reticule (Subtle in-world indicator)
	if is_player_in_range or _resonance_flash > 0.0:
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
	# Silhouette and attire conforming to VISUAL_DESIGN.md:
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
	
	# 5. Head, hair & facial profile
	draw_circle(Vector2(-0.5, -13.0), 5.2, Color("1a2228")) # Dark hair tied back
	draw_circle(Vector2(-1.5, -12.5), 3.8, Color("d39a62")) # Warm skin
	draw_circle(Vector2(-3.5, -13.0), 0.8, Color("141c22")) # Observant eye
	
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
	# Head
	draw_circle(Vector2(0.0, -12.0), 3.8, Color("2d221a"))
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


func _draw_cracked_tea_cup() -> void:
	# Marta's cracked ceramic tea cup with golden repair seam (kintsugi / glue line) on saucer: 20x14 px
	# Saucer at base
	draw_ellipse(Vector2(0.0, 5.0), 10.0, 3.0, Color("322a24"))
	draw_ellipse(Vector2(0.0, 5.0), 9.0, 2.2, Color("dfdacd"))
	draw_ellipse(Vector2(0.0, 5.0), 9.0, 2.2, Color("a89e92"), false, 0.8)
	
	# Ceramic cup body
	var cup_rect := Rect2(-6.0, -3.0, 12.0, 8.0)
	draw_rect(cup_rect, Color("dedad1"))
	draw_rect(cup_rect, Color("9a9184"), false, 0.8)
	
	# Steaming tea surface
	draw_ellipse(Vector2(0.0, -3.0), 5.5, 1.8, Color("8b4a24"))
	
	# Cup handle on right side
	draw_arc(Vector2(6.5, 0.0), 3.0, -PI * 0.4, PI * 0.5, 8, Color("9a9184"), 1.0)
	
	# Golden/amber repair fracture seam across ceramic body (per Scene 16 & D-05)
	var seam_p1 := Vector2(-3.0, -3.0)
	var seam_p2 := Vector2(-1.0, 1.0)
	var seam_p3 := Vector2(2.0, 5.0)
	draw_line(seam_p1, seam_p2, COLOR_AMBER, 1.2)
	draw_line(seam_p2, seam_p3, COLOR_AMBER, 1.2)
	
	# Delicate rising steam curls
	var steam_t := _pulse_phase * 1.8
	var s_alpha := 0.25 + sin(steam_t) * 0.15
	var steam_col := Color(0.85, 0.85, 0.85, s_alpha)
	var steam_y1 := -6.0 - fmod(steam_t * 6.0, 12.0)
	var steam_x1 := sin(steam_t + steam_y1 * 0.2) * 2.0
	draw_circle(Vector2(steam_x1, steam_y1), 1.2, steam_col)
	var steam_y2 := -10.0 - fmod((steam_t + 1.2) * 5.0, 10.0)
	var steam_x2 := cos(steam_t * 0.8 + steam_y2 * 0.2) * 2.5
	draw_circle(Vector2(steam_x2, steam_y2), 1.6, steam_col * 0.8)


func _draw_correlation_dossier() -> void:
	# Manila folder dossier with documents, photo slides and correlation diagrams: 28x20 px
	var folder_rect := Rect2(-14.0, -9.0, 28.0, 18.0)
	# Heavy cardboard folder casing
	draw_rect(folder_rect, Color("2d3b37"))
	draw_rect(folder_rect, COLOR_INFRASTRUCTURE * 0.8, false, 1.0)
	
	# Stacked inner paper sheets
	var sheet_rect := Rect2(-11.0, -7.0, 22.0, 14.0)
	draw_rect(sheet_rect, Color("e5e2d8"))
	
	# Technical correlation line charts and handwritten notes (poszlaki R-01..R-06)
	draw_line(Vector2(-9.0, -3.0), Vector2(-1.0, -3.0), Color("4a5255"), 0.9)
	draw_line(Vector2(-9.0, 0.0), Vector2(5.0, 0.0), Color("4a5255"), 0.9)
	draw_line(Vector2(-9.0, 3.0), Vector2(2.0, 3.0), Color("4a5255"), 0.9)
	
	# Red/amber correlation curve graph in bottom-right corner
	draw_line(Vector2(2.0, -1.0), Vector2(5.0, -4.0), COLOR_AMBER, 1.0)
	draw_line(Vector2(5.0, -4.0), Vector2(9.0, 1.0), COLOR_AMBER, 1.0)
	
	# Pinned photographic slide (Jakub & Lena node reference)
	var slide_rect := Rect2(3.0, -6.0, 6.0, 5.0)
	draw_rect(slide_rect, Color("1a2024"))
	draw_circle(Vector2(5.0, -4.0), 0.8, COLOR_CYAN)
	
	if is_activated:
		draw_rect(folder_rect, COLOR_CYAN * 0.6, false, 1.2)


func _draw_kitchen_clock() -> void:
	# Round wooden wall clock with mechanical ticking hands: radius 13 px
	var center := Vector2(0.0, 0.0)
	# Outer dark wood casing
	draw_circle(center, 13.0, Color("35271d"))
	draw_circle(center, 13.0, Color("543f30"), false, 1.2)
	
	# Dial face
	draw_circle(center, 10.5, Color("e2ded4"))
	draw_circle(center, 10.5, Color("b2aba0"), false, 0.8)
	
	# Hour tick marks at 12, 3, 6, 9
	draw_line(Vector2(0.0, -9.5), Vector2(0.0, -7.5), Color("242220"), 1.0)
	draw_line(Vector2(9.5, 0.0), Vector2(7.5, 0.0), Color("242220"), 1.0)
	draw_line(Vector2(0.0, 9.5), Vector2(0.0, 7.5), Color("242220"), 1.0)
	draw_line(Vector2(-9.5, 0.0), Vector2(-7.5, 0.0), Color("242220"), 1.0)
	
	# Clock hands (Hour pointing to ~10:00, Minute to ~02:00)
	draw_line(center, Vector2(-4.0, -4.5), Color("1a1816"), 1.4)
	draw_line(center, Vector2(5.0, -5.0), Color("1a1816"), 1.0)
	
	# Ticking second hand with hesitation (Scene 16: asynchronia / nieregularny takt)
	var tick_angle := _pulse_phase * 1.5 + sin(_pulse_phase * 3.0) * 0.25
	var sec_vec := Vector2(sin(tick_angle), -cos(tick_angle)) * 7.5
	draw_line(center, center + sec_vec, COLOR_AMBER, 0.8)
	
	# Center brass arbor pin
	draw_circle(center, 1.2, Color("7a5e30"))


func _draw_wedding_ring_stand() -> void:
	# Small porcelain dish holding the gold wedding ring: 18x12 px
	# Dish base
	draw_ellipse(Vector2(0.0, 3.0), 9.0, 4.0, Color("282420"))
	draw_ellipse(Vector2(0.0, 3.0), 8.0, 3.2, Color("dedbd3"))
	draw_ellipse(Vector2(0.0, 3.0), 8.0, 3.2, COLOR_INFRASTRUCTURE * 0.7, false, 0.8)
	
	# Gold wedding ring standing slightly tilted in dish
	var ring_pos := Vector2(0.0, 1.0)
	# Warm amber halo disk
	var pulse := sin(_pulse_phase * 2.5) * 0.5 + 0.5
	var halo_alpha := 0.20 + pulse * 0.20
	draw_circle(ring_pos, 7.0 + pulse * 1.5, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, halo_alpha))
	
	# Outer gold torus ring
	draw_ellipse(ring_pos, 4.5, 3.0, Color("e6b432"))
	draw_ellipse(ring_pos, 4.5, 3.0, Color("ffd966"), false, 1.2)
	# Inner void
	draw_ellipse(ring_pos, 2.5, 1.5, Color("3a352d"))
	
	# Specular highlight point on upper rim
	draw_circle(ring_pos + Vector2(-2.2, -1.8), 0.9, Color("ffffff"))


func _draw_balcony_exit_door() -> void:
	# Double glass balcony door leading to apartment exterior / Space 17: 28x56 px
	var door_rect := Rect2(-14.0, -28.0, 28.0, 56.0)
	# Outer wooden frame
	draw_rect(door_rect, Color("283238"))
	draw_rect(door_rect, COLOR_INFRASTRUCTURE * 0.8, false, 1.2)
	
	# Glass panes looking out into night Osiedle Tarasowe
	var glass_left := Rect2(-12.0, -25.0, 11.0, 50.0)
	var glass_right := Rect2(1.0, -25.0, 11.0, 50.0)
	draw_rect(glass_left, Color("0e161c"))
	draw_rect(glass_right, Color("0e161c"))
	
	# Distant window lights in neighboring blocks across the night
	draw_rect(Rect2(-9.0, -15.0, 2.0, 2.0), Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.45))
	draw_rect(Rect2(-6.0, 5.0, 2.0, 2.0), Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.35))
	draw_rect(Rect2(4.0, -10.0, 2.0, 2.0), Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.50))
	draw_rect(Rect2(7.0, 12.0, 2.0, 2.0), Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.40))
	
	# Door mullion divide and brass latch
	draw_line(Vector2(0.0, -26.0), Vector2(0.0, 26.0), Color("232c32"), 1.4)
	draw_rect(Rect2(-1.5, 0.0, 3.0, 6.0), Color("7e683b"))
	
	# Translucent curtain drape on left side swaying slightly
	var curtain_sway := sin(_pulse_phase * 1.2) * 1.5
	var p1 := Vector2(-12.0, -25.0)
	var p2 := Vector2(-7.0 + curtain_sway, -5.0)
	var p3 := Vector2(-10.0 + curtain_sway, 25.0)
	draw_line(p1, p2, Color(0.85, 0.85, 0.85, 0.25), 2.0)
	draw_line(p2, p3, Color(0.85, 0.85, 0.85, 0.20), 2.5)
	
	if is_activated:
		# Unlocked exit beacon glow
		draw_rect(door_rect, COLOR_CYAN * 0.5, false, 1.4)
		draw_line(Vector2(-12.0, 27.0), Vector2(12.0, 27.0), COLOR_CYAN, 1.8)


func _draw_queuing_ticket_dispenser() -> void:
	# Modernist queuing ticket dispenser pedestal: 20x42 px
	var base_rect := Rect2(-10.0, 16.0, 20.0, 6.0)
	var column_rect := Rect2(-8.0, -18.0, 16.0, 34.0)
	var head_rect := Rect2(-10.0, -22.0, 20.0, 8.0)
	
	# Dark steel base
	draw_rect(base_rect, COLOR_DARK_STEEL)
	draw_rect(base_rect, COLOR_INFRASTRUCTURE * 0.6, false, 1.0)
	
	# Off-white enamel pedestal body
	draw_rect(column_rect, Color("e5e2da"))
	draw_rect(column_rect, COLOR_INFRASTRUCTURE, false, 1.0)
	
	# Head housing with sloped top
	draw_rect(head_rect, Color("35424a"))
	draw_rect(head_rect, COLOR_DARK_STEEL, false, 1.0)
	
	# Digital LED segment display (Amber glow "084")
	var display_rect := Rect2(-7.0, -14.0, 14.0, 7.0)
	draw_rect(display_rect, Color("141c20"))
	draw_rect(display_rect, Color("202a30"), false, 0.8)
	draw_line(Vector2(-5.0, -10.5), Vector2(5.0, -10.5), COLOR_AMBER, 1.2)
	draw_line(Vector2(-4.0, -12.0), Vector2(-1.0, -12.0), COLOR_AMBER, 1.0)
	draw_line(Vector2(1.0, -12.0), Vector2(4.0, -12.0), COLOR_AMBER, 1.0)
	draw_line(Vector2(-4.0, -9.0), Vector2(-1.0, -9.0), COLOR_AMBER, 1.0)
	draw_line(Vector2(1.0, -9.0), Vector2(4.0, -9.0), COLOR_AMBER, 1.0)
	
	# Ticket issuing horizontal slit
	draw_line(Vector2(-6.0, -3.0), Vector2(6.0, -3.0), Color("12181c"), 1.6)
	
	# Issued thermal paper ticket extending from slot
	var ticket_h := 10.0 if is_activated else 5.0
	var ticket_rect := Rect2(-5.0, -2.0, 10.0, ticket_h)
	draw_rect(ticket_rect, Color("f8f6f0"))
	draw_rect(ticket_rect, COLOR_INFRASTRUCTURE * 0.8, false, 0.6)
	# Fine printed case header lines on ticket (SPRAWA 084/17 - WŁASNE ZGŁOSZENIE)
	draw_line(Vector2(-4.0, 0.0), Vector2(4.0, 0.0), Color("2b3338"), 0.7)
	draw_line(Vector2(-4.0, 2.0), Vector2(2.0, 2.0), Color("2b3338"), 0.7)
	if is_activated:
		draw_line(Vector2(-4.0, 4.5), Vector2(3.5, 4.5), COLOR_CORRECTION * 0.9, 0.8)
		draw_line(Vector2(-4.0, 6.5), Vector2(1.0, 6.5), Color("2b3338"), 0.7)
		# Cyan perforation tear edge
		draw_line(Vector2(-5.0, -2.0 + ticket_h), Vector2(5.0, -2.0 + ticket_h), COLOR_CYAN, 1.0)


func _draw_compliance_waiting_bench() -> void:
	# Modernist waiting room bench with compliance notice placard: 46x24 px
	# Tubular steel legs
	draw_line(Vector2(-18.0, 2.0), Vector2(-18.0, 12.0), COLOR_INFRASTRUCTURE, 1.6)
	draw_line(Vector2(18.0, 2.0), Vector2(18.0, 12.0), COLOR_INFRASTRUCTURE, 1.6)
	draw_line(Vector2(-20.0, 12.0), Vector2(-16.0, 12.0), COLOR_DARK_STEEL, 1.8)
	draw_line(Vector2(16.0, 12.0), Vector2(20.0, 12.0), COLOR_DARK_STEEL, 1.8)
	
	# Horizontal support spar
	draw_line(Vector2(-20.0, 4.0), Vector2(20.0, 4.0), COLOR_DARK_STEEL, 1.4)
	
	# Molded oak plywood seat slats
	var slat1 := Rect2(-22.0, -1.0, 44.0, 3.5)
	var slat2 := Rect2(-22.0, 3.5, 44.0, 3.5)
	draw_rect(slat1, Color("7a5638"))
	draw_rect(slat1, Color("966c48"), false, 0.8)
	draw_rect(slat2, Color("68482e"))
	draw_rect(slat2, Color("865e3e"), false, 0.8)
	
	# Molded wooden backrest
	var backrest := Rect2(-22.0, -12.0, 44.0, 6.0)
	draw_rect(backrest, Color("7a5638"))
	draw_rect(backrest, Color("966c48"), false, 0.8)
	# Vertical backrest metal brackets
	draw_line(Vector2(-14.0, -6.0), Vector2(-14.0, -1.0), COLOR_DARK_STEEL, 1.4)
	draw_line(Vector2(14.0, -6.0), Vector2(14.0, -1.0), COLOR_DARK_STEEL, 1.4)
	
	# Compliance notice placard mounted above bench on the wall
	var placard_rect := Rect2(-15.0, -26.0, 30.0, 12.0)
	draw_rect(placard_rect, Color("e8e6df"))
	draw_rect(placard_rect, COLOR_INFRASTRUCTURE, false, 0.9)
	# UCP subtle header bar
	draw_rect(Rect2(-15.0, -26.0, 30.0, 3.0), Color("2d3b44"))
	# Paragraph text lines (Instrukcja Zgodności Konsultacyjnej)
	draw_line(Vector2(-12.0, -20.5), Vector2(12.0, -20.5), Color("45525a"), 0.8)
	draw_line(Vector2(-12.0, -18.0), Vector2(8.0, -18.0), Color("45525a"), 0.8)
	draw_line(Vector2(-12.0, -15.5), Vector2(10.0, -15.5), Color("45525a"), 0.8)
	
	if is_activated:
		draw_rect(placard_rect, COLOR_AMBER * 0.6, false, 1.2)


func _draw_pneumatic_dossier_station() -> void:
	# Brass and glass pneumatic dispatch station: 22x52 px
	var station_rect := Rect2(-11.0, -26.0, 22.0, 52.0)
	
	# Vertical transparent glass transport tube
	var tube_rect := Rect2(-6.0, -26.0, 12.0, 48.0)
	draw_rect(tube_rect, Color(0.12, 0.18, 0.22, 0.70))
	draw_rect(tube_rect, COLOR_CYAN * 0.5, false, 1.0)
	
	# Polished brass collar mounts (top, middle valve, bottom receiver)
	draw_rect(Rect2(-9.0, -26.0, 18.0, 6.0), Color("8a6d3b"))
	draw_rect(Rect2(-9.0, -26.0, 18.0, 6.0), Color("b89656"), false, 0.9)
	draw_rect(Rect2(-10.0, -2.0, 20.0, 7.0), Color("8a6d3b"))
	draw_rect(Rect2(-10.0, -2.0, 20.0, 7.0), Color("b89656"), false, 0.9)
	draw_rect(Rect2(-11.0, 18.0, 22.0, 8.0), Color("6e552c"))
	draw_rect(Rect2(-11.0, 18.0, 22.0, 8.0), Color("a68549"), false, 0.9)
	
	# Pressure gauge on side
	draw_circle(Vector2(8.5, -12.0), 3.5, Color("e5e0d4"))
	draw_circle(Vector2(8.5, -12.0), 3.5, Color("8a6d3b"), false, 0.8)
	draw_line(Vector2(8.5, -12.0), Vector2(10.0, -13.5), COLOR_CORRECTION, 0.8)
	
	# Cylindrical brass carrier capsule seated in lower reception bay
	var capsule_y := 6.0
	var capsule_rect := Rect2(-4.5, capsule_y, 9.0, 14.0)
	draw_rect(capsule_rect, Color("a8894e"))
	draw_rect(capsule_rect, Color("d4b06a"), false, 0.9)
	# Rubber buffer rings on capsule ends
	draw_rect(Rect2(-5.0, capsule_y, 10.0, 2.5), Color("262c30"))
	draw_rect(Rect2(-5.0, capsule_y + 11.5, 10.0, 2.5), Color("262c30"))
	# Personal dossier label strip on capsule body
	draw_line(Vector2(-3.5, capsule_y + 6.0), Vector2(3.5, capsule_y + 6.0), Color("f2eee4"), 1.2)
	draw_line(Vector2(-3.0, capsule_y + 8.0), Vector2(2.0, capsule_y + 8.0), Color("303a40"), 0.7)
	
	# Internal air suction glow animation
	var suction_pulse := sin(_pulse_phase * 3.0) * 0.5 + 0.5
	if is_activated:
		draw_line(Vector2(0.0, -24.0), Vector2(0.0, 4.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.4 + suction_pulse * 0.4), 2.0)
		draw_rect(station_rect, COLOR_CYAN * 0.5, false, 1.2)


func _draw_diagnostic_memory_printer() -> void:
	# Tabletop sensory diagnostic recording apparatus: 28x32 px
	var table_mount := Rect2(-14.0, 10.0, 28.0, 6.0)
	draw_rect(table_mount, Color("2d373e"))
	draw_rect(table_mount, COLOR_INFRASTRUCTURE * 0.7, false, 0.8)
	
	# Main chassis (olive/sage institutional metal housing)
	var chassis_rect := Rect2(-12.0, -8.0, 24.0, 18.0)
	draw_rect(chassis_rect, Color("4a5752"))
	draw_rect(chassis_rect, Color("62736c"), false, 1.0)
	
	# Paper supply roll cradle on top
	draw_ellipse(Vector2(-6.0, -10.0), 4.5, 3.0, Color("dedbd2"))
	draw_ellipse(Vector2(-6.0, -10.0), 4.5, 3.0, Color("9a968d"), false, 0.7)
	
	# Dot-matrix printhead carriage and thermal ribbon guide
	draw_rect(Rect2(-10.0, -4.0, 20.0, 4.0), Color("1e2529"))
	var carriage_x := sin(_pulse_phase * 4.0) * 6.0 if is_activated else -2.0
	draw_rect(Rect2(carriage_x - 2.0, -5.0, 4.0, 6.0), Color("a67c38"))
	
	# Emerging diagnostic paper tape trailing downward
	var paper_h := 16.0 if is_activated else 8.0
	var paper_strip := Rect2(-7.0, 0.0, 14.0, paper_h)
	draw_rect(paper_strip, Color("fcfaf4"))
	draw_rect(paper_strip, COLOR_INFRASTRUCTURE * 0.7, false, 0.6)
	
	# Printed sensory data lines: KAWA / LINOLEUM / MOKRA WEŁNA
	draw_line(Vector2(-5.5, 3.0), Vector2(5.5, 3.0), Color("20262b"), 0.8)
	draw_line(Vector2(-5.5, 5.5), Vector2(3.5, 5.5), Color("20262b"), 0.8)
	if is_activated:
		draw_line(Vector2(-5.5, 8.0), Vector2(4.5, 8.0), COLOR_CORRECTION * 0.9, 0.9)
		draw_line(Vector2(-5.5, 10.5), Vector2(5.0, 10.5), Color("20262b"), 0.8)
		draw_line(Vector2(-5.5, 13.0), Vector2(2.5, 13.0), COLOR_AMBER, 0.8)
	
	# Status indicator LED (Amber idle / Cyan diagnostic sync)
	var led_color := COLOR_CYAN if is_activated else COLOR_AMBER
	draw_circle(Vector2(8.0, -5.0), 1.5, led_color)
	draw_circle(Vector2(8.0, -5.0), 3.0, Color(led_color.r, led_color.g, led_color.b, 0.3))


func _draw_consultation_office_door() -> void:
	# Modernist consultation office door leading to Dr. Wierzbicka's office: 30x62 px
	var door_rect := Rect2(-15.0, -31.0, 30.0, 62.0)
	
	# Clean institutional door frame (Off-white / pale concrete enamel)
	draw_rect(door_rect, Color("2c3942"))
	draw_rect(door_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Large frosted ribbed glass upper panel: 24x36 px
	var glass_rect := Rect2(-12.0, -28.0, 24.0, 36.0)
	draw_rect(glass_rect, Color("d5dedb"))
	draw_rect(glass_rect, COLOR_INFRASTRUCTURE * 0.8, false, 0.9)
	
	# Fluted glass vertical texture lines
	for gx in range(-10, 11, 3):
		draw_line(Vector2(float(gx), -27.0), Vector2(float(gx), 7.0), Color(0.70, 0.76, 0.74, 0.50), 0.8)
	
	# Vague blurred dark silhouette behind the frosted glass (Dr. Helena Wierzbicka sitting at desk)
	var silhouette_head := Vector2(2.0, -18.0)
	draw_circle(silhouette_head, 3.8, Color(0.18, 0.24, 0.27, 0.65))
	var silhouette_shoulders := Rect2(-4.0, -14.0, 12.0, 14.0)
	draw_rect(silhouette_shoulders, Color(0.18, 0.24, 0.27, 0.55))
	# Warm desk lamp reflection behind frosted glass
	draw_circle(Vector2(-5.0, -10.0), 5.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.35))
	
	# Enamel door plaque: "GABINET KONSULTACYJNY 06 / DR H. WIERZBICKA"
	var plaque_rect := Rect2(-10.0, 11.0, 20.0, 7.0)
	draw_rect(plaque_rect, Color("1a2228"))
	draw_rect(plaque_rect, Color("b29456"), false, 0.8)
	draw_line(Vector2(-8.0, 13.5), Vector2(8.0, 13.5), Color("e8e4da"), 0.8)
	draw_line(Vector2(-8.0, 15.5), Vector2(4.0, 15.5), COLOR_AMBER * 0.9, 0.7)
	
	# Brass lever handle
	draw_circle(Vector2(-9.0, 22.0), 1.6, Color("c29e55"))
	draw_line(Vector2(-9.0, 22.0), Vector2(-4.0, 22.0), Color("c29e55"), 1.8)
	
	# Lower kick plate (Brushed steel)
	var kickplate_rect := Rect2(-12.0, 26.0, 24.0, 4.0)
	draw_rect(kickplate_rect, Color("3a4852"))
	draw_rect(kickplate_rect, COLOR_INFRASTRUCTURE * 0.6, false, 0.7)
	
	if is_activated:
		# Unlocked consultation room threshold cyan illumination
		draw_rect(door_rect, COLOR_CYAN * 0.6, false, 1.5)
		draw_line(Vector2(-14.0, 31.0), Vector2(14.0, 31.0), COLOR_CYAN, 2.0)


func _draw_wierzbicka_desk() -> void:
	# Dr. Helena Wierzbicka's consultation desk: 32x22 px
	# Beech wood surface with dossier of missing Lena, transcription apparatus, tea cup
	var pulse := sin(_pulse_phase * 1.8) * 0.5 + 0.5
	
	# Desk body: powder-coated steel frame, beech wood top
	var desk_body := Rect2(-16.0, -4.0, 32.0, 16.0)
	draw_rect(desk_body, Color("29373e"))
	draw_rect(desk_body, Color("383f46") * 0.8, false, 0.9)
	
	# Beech wood desktop surface
	var top_rect := Rect2(-16.0, -8.0, 32.0, 5.0)
	draw_rect(top_rect, Color("9c7e54"))
	draw_rect(top_rect, Color("b39168"), false, 0.8)
	
	# Transcription apparatus (compact, left side)
	draw_rect(Rect2(-13.0, -12.0, 8.0, 5.0), Color("202a30"))
	draw_rect(Rect2(-13.0, -12.0, 8.0, 5.0), COLOR_AMBER * 0.5, false, 0.8)
	draw_line(Vector2(-12.0, -10.0), Vector2(-6.0, -10.0), COLOR_AMBER * 0.7, 0.8)
	
	# Missing Lena dossier / teczka
	draw_rect(Rect2(-3.0, -11.0, 14.0, 4.0), Color("4a5560"))
	draw_rect(Rect2(-3.0, -11.0, 14.0, 4.0), COLOR_INFRASTRUCTURE * 0.6, false, 0.8)
	draw_line(Vector2(-1.0, -9.5), Vector2(9.0, -9.5), Color("d0d8d5"), 0.8)
	draw_line(Vector2(-1.0, -8.0), Vector2(6.0, -8.0), COLOR_AMBER * 0.65, 0.7)
	
	# Tea cup: institutional porcelain
	draw_circle(Vector2(11.0, -10.0), 2.5, Color("c8d2ce"))
	draw_circle(Vector2(11.0, -10.0), 2.5, COLOR_INFRASTRUCTURE * 0.5, false)
	
	# Amber lamp glow on desk surface when activated (stamp just approved)
	if is_activated:
		draw_circle(Vector2(-4.0, -7.0), 6.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.22 + pulse * 0.12))
		draw_rect(Rect2(-13.0, -12.0, 8.0, 5.0), COLOR_AMBER * 0.3, false, 1.2)
	
	# Interaction reticule hint: pale olive
	if is_player_in_range and not is_activated:
		draw_circle(Vector2.ZERO, 18.0, Color("8fa07a", 0.10 + pulse * 0.08))


func _draw_sensory_memory_map() -> void:
	# Wall-mounted sensory memory map of Równia with illuminated nodes (Peron 2, prosektorium, Linia 4)
	# 30x26 px panel, cool olive background with cyan node highlights
	var pulse := sin(_pulse_phase * 2.1) * 0.5 + 0.5
	
	# Map panel background
	draw_rect(Rect2(-15.0, -14.0, 30.0, 28.0), Color("1e2b28"))
	draw_rect(Rect2(-15.0, -14.0, 30.0, 28.0), Color("4a6255", 0.5), false, 0.9)
	
	# Grid lines — city blocks schematic (pale olive lines)
	for i in range(-12, 13, 6):
		draw_line(Vector2(float(i), -12.0), Vector2(float(i), 12.0), Color("4a7060", 0.35), 0.7)
	for i in range(-12, 13, 6):
		draw_line(Vector2(-13.0, float(i)), Vector2(13.0, float(i)), Color("4a7060", 0.35), 0.7)
	
	# Rail line (Linia 4): diagonal amber trace
	draw_line(Vector2(-13.0, 10.0), Vector2(13.0, -8.0), Color("b8843c", 0.70), 1.2)
	
	# Transit node: Peron 2 (upper right — active, cyan)
	var node1_glow := 0.55 + pulse * 0.35 if is_activated else 0.40
	draw_circle(Vector2(7.0, -8.0), 3.5, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, node1_glow))
	draw_circle(Vector2(7.0, -8.0), 1.8, COLOR_CYAN)
	
	# Node: Prosektorium (lower left — dim, amber)
	var node2_glow := 0.45 + pulse * 0.25 if is_activated else 0.30
	draw_circle(Vector2(-9.0, 7.0), 3.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, node2_glow))
	draw_circle(Vector2(-9.0, 7.0), 1.5, COLOR_AMBER)
	
	# Node: Linia 4 incident marker (center — correction red, pulsing)
	var node3_glow := 0.45 + pulse * 0.40 if is_activated else 0.25
	draw_circle(Vector2(1.0, 2.0), 2.8, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, node3_glow))
	draw_circle(Vector2(1.0, 2.0), 1.2, COLOR_CORRECTION)
	
	# Panel label line at top
	draw_line(Vector2(-13.0, -12.0), Vector2(13.0, -12.0), Color("8fa07a", 0.60), 0.8)
	draw_line(Vector2(-11.0, -11.0), Vector2(6.0, -11.0), Color("c8d4cc"), 0.7)
	
	# Activated: extra node link lines flash
	if is_activated:
		draw_line(Vector2(7.0, -8.0), Vector2(1.0, 2.0), COLOR_CYAN * 0.50, 1.0)
		draw_line(Vector2(-9.0, 7.0), Vector2(1.0, 2.0), COLOR_AMBER * 0.45, 1.0)


func _draw_correction_galvanometer() -> void:
	# Precision galvanometer: 22x28 px — reacts to Lena's false sensory responses
	# Needle deflects on lie; absorbs lie as official record, but strain indicator spikes
	var pulse := sin(_pulse_phase * 3.5) * 0.5 + 0.5
	
	# Instrument housing: polished beige steel
	draw_rect(Rect2(-11.0, -14.0, 22.0, 28.0), Color("2a3338"))
	draw_rect(Rect2(-11.0, -14.0, 22.0, 28.0), Color("5a6a62", 0.5), false, 0.9)
	
	# Dial face: white enamel circle
	draw_circle(Vector2.ZERO, 8.5, Color("e8eeeb"))
	draw_circle(Vector2.ZERO, 8.5, COLOR_INFRASTRUCTURE * 0.7, false)
	
	# Tick marks on dial
	for i in range(8):
		var angle := -2.2 + float(i) * (4.4 / 7.0)
		var inner := Vector2(cos(angle), sin(angle)) * 6.0
		var outer := Vector2(cos(angle), sin(angle)) * 8.0
		draw_line(inner, outer, Color("34454c"), 0.8)
	
	# Center datum line
	draw_line(Vector2(-7.0, 0.0), Vector2(7.0, 0.0), Color("9aada6", 0.5), 0.7)
	
	# Needle: rests at center; deflects right when Lena lies
	var needle_angle := -1.4 if not is_activated else (-1.4 + 1.8 * (0.6 + pulse * 0.4))
	var needle_tip := Vector2(cos(needle_angle), sin(needle_angle)) * 7.5
	draw_line(Vector2.ZERO, needle_tip, COLOR_CORRECTION, 1.5)
	draw_circle(Vector2.ZERO, 1.5, Color("c43535"))
	
	# Lie-accepted indicator light (amber when activated = lie recorded)
	draw_circle(Vector2(0.0, 11.0), 2.5, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.5 + (pulse * 0.4 if is_activated else 0.0)))
	
	# Housing bottom terminals
	draw_rect(Rect2(-5.0, 12.0, 10.0, 3.0), Color("1e2a30"))
	draw_circle(Vector2(-3.0, 13.5), 1.0, COLOR_INFRASTRUCTURE * 0.6)
	draw_circle(Vector2(3.0, 13.5), 1.0, COLOR_INFRASTRUCTURE * 0.6)


func _draw_acoustic_weight_conduit() -> void:
	# Wall-mounted Podstruktura load indicator: 20x32 px
	# Shows structural tension in Podstruktura (sub-foundation) rising as lie is accepted by system
	var pulse := sin(_pulse_phase * 0.9) * 0.5 + 0.5
	
	# Housing: dark powder-coated steel panel
	draw_rect(Rect2(-10.0, -16.0, 20.0, 32.0), Color("1a2226"))
	draw_rect(Rect2(-10.0, -16.0, 20.0, 32.0), Color("3a4f48", 0.5), false, 0.9)
	
	# Meter graduation marks (8 levels)
	for i in range(9):
		var y := -13.0 + float(i) * 3.0
		draw_line(Vector2(-7.0, y), Vector2(7.0, y), Color("4a6255", 0.40), 0.7)
	
	# Fill bar: low strain base state (cool olive)
	var fill_h := 12.0 if not is_activated else (12.0 + pulse * 12.0)
	var fill_color := Color("5a8060") if not is_activated else Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.65 + pulse * 0.25)
	draw_rect(Rect2(-7.0, 13.0 - fill_h, 14.0, fill_h), fill_color)
	
	# Label: naprężenie podstruktury
	draw_line(Vector2(-8.0, -14.0), Vector2(8.0, -14.0), Color("8fa07a", 0.60), 0.8)
	draw_line(Vector2(-6.0, -13.0), Vector2(5.0, -13.0), Color("c8d4cc"), 0.7)
	
	# Strain peak indicator top cap (lights red when lie is accepted)
	var peak_alpha := 0.3 + pulse * 0.55 if is_activated else 0.15
	draw_rect(Rect2(-7.0, -13.0, 14.0, 3.0), Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, peak_alpha))
	draw_rect(Rect2(-7.0, -13.0, 14.0, 3.0), COLOR_CORRECTION * 0.8, false, 0.9)
	
	# Sub-bass vibration lines (acoustic resonance from Podstruktura behind wall)
	if is_activated:
		for i in range(3):
			var vy := -8.0 + float(i) * 6.0
			draw_line(Vector2(-9.0, vy), Vector2(9.0, vy), Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.15 + pulse * 0.20), 0.8)


func _draw_model_room_airlock() -> void:
	# Bolted consultation room exit door to Model Room / Sala Modeli (Space 19): 24x36 px
	# Heavy powder-coated steel, rigid-bolt institutional hospital design
	var pulse := sin(_pulse_phase * 1.5) * 0.5 + 0.5
	
	# Door frame: dark steel
	var door_rect := Rect2(-12.0, -18.0, 24.0, 36.0)
	draw_rect(door_rect, Color("1a2429"))
	draw_rect(door_rect, Color("3a4f4a", 0.7), false, 1.2)
	
	# Door panel: pale institutional olive steel
	var panel_rect := Rect2(-10.0, -16.0, 20.0, 32.0)
	draw_rect(panel_rect, Color("2a3c35"))
	draw_rect(panel_rect, Color("4a6355", 0.5), false, 0.9)
	
	# Cross-rail dividers: powder-coated steel extrusion
	draw_rect(Rect2(-10.0, -3.0, 20.0, 2.0), Color("1e2f29"))
	
	# Rigid bolt / lock bar: horizontal security bolt
	draw_rect(Rect2(-8.0, 8.0, 16.0, 3.0), Color("405548"))
	draw_rect(Rect2(-8.0, 8.0, 16.0, 3.0), COLOR_INFRASTRUCTURE * 0.5, false, 0.8)
	draw_circle(Vector2(5.0, 9.5), 2.2, Color("606e68"))
	
	# "SALA MODELI" enamel label
	draw_line(Vector2(-8.0, -12.0), Vector2(8.0, -12.0), Color("8fa07a", 0.60), 0.8)
	draw_line(Vector2(-7.0, -10.5), Vector2(5.0, -10.5), Color("c8d4cc"), 0.7)
	
	# UCP safety notice (small placard)
	draw_rect(Rect2(-9.0, 14.0, 18.0, 4.0), Color("1a2226"))
	draw_rect(Rect2(-9.0, 14.0, 18.0, 4.0), COLOR_AMBER * 0.3, false, 0.7)
	draw_line(Vector2(-7.0, 16.0), Vector2(7.0, 16.0), Color("c8b87a"), 0.7)
	
	# Activated (unlocked) state: cyan threshold glow + bolt withdrawn
	if is_activated:
		draw_rect(door_rect, COLOR_CYAN * 0.45, false, 1.5)
		draw_line(Vector2(-12.0, 18.0), Vector2(12.0, 18.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.7 + pulse * 0.3), 2.0)
		# Bolt visually withdrawn (slides right)
		draw_rect(Rect2(2.0, 8.0, 8.0, 3.0), Color("3a4a44"))
	else:
		# Locked — subtle amber lock indicator
		draw_circle(Vector2(5.0, 9.5), 1.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.40 + pulse * 0.25))


func _draw_model_display_table() -> void:
	# Central model exhibition table: 54x26 px
	# Cold white acrylic bed on dark steel/beige plaster stand.
	# Contains two equivalent scale architectural models of Line 4 staircase/incident.
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	
	# Table stand / base: dark institutional steel & plaster
	var base_rect := Rect2(-27.0, -13.0, 54.0, 26.0)
	draw_rect(base_rect, Color("1e2826"))
	draw_rect(base_rect, Color("3b4e45", 0.7), false, 1.0)
	
	# Tabletop cold white acrylic bed with perimeter bezel
	var top_rect := Rect2(-25.0, -11.0, 50.0, 22.0)
	draw_rect(top_rect, Color("2a3832"))
	draw_rect(top_rect, Color("4a6255", 0.5), false, 0.8)
	
	# Center divider dividing the two models
	draw_line(Vector2(0.0, -11.0), Vector2(0.0, 11.0), Color("16221e"), 1.2)
	
	# Model 1 (Left): Staircase ending on street level (140 people egress)
	# Acrylic pedestal & wireframe staircase
	var m1_rect := Rect2(-23.0, -9.0, 21.0, 18.0)
	draw_rect(m1_rect, Color("202e28"))
	draw_rect(m1_rect, Color("344b40", 0.6), false, 0.7)
	# Steps descending to open bottom
	for i in range(4):
		var sx := -21.0 + float(i) * 4.0
		var sy := -6.0 + float(i) * 3.2
		draw_line(Vector2(sx, sy), Vector2(sx + 3.0, sy), COLOR_CYAN * 0.75, 1.0)
		draw_line(Vector2(sx + 3.0, sy), Vector2(sx + 3.0, sy + 3.2), COLOR_CYAN * 0.55, 0.8)
	# Open street threshold (cyan marker)
	draw_line(Vector2(-9.0, 6.5), Vector2(-4.0, 6.5), COLOR_CYAN, 1.4)
	
	# Model 2 (Right): Staircase ending on solid load-bearing wall (17 witnesses)
	# Acrylic pedestal & wireframe staircase
	var m2_rect := Rect2(2.0, -9.0, 21.0, 18.0)
	draw_rect(m2_rect, Color("202e28"))
	draw_rect(m2_rect, Color("344b40", 0.6), false, 0.7)
	# Steps descending toward wall
	for i in range(4):
		var sx := 4.0 + float(i) * 4.0
		var sy := -6.0 + float(i) * 3.2
		draw_line(Vector2(sx, sy), Vector2(sx + 3.0, sy), COLOR_AMBER * 0.75, 1.0)
		draw_line(Vector2(sx + 3.0, sy), Vector2(sx + 3.0, sy + 3.2), COLOR_AMBER * 0.55, 0.8)
	# Solid partition wall slab (reinforced concrete hatched marker)
	draw_rect(Rect2(19.0, -7.0, 3.0, 14.0), Color("4e3832"))
	draw_rect(Rect2(19.0, -7.0, 3.0, 14.0), COLOR_CORRECTION * 0.8, false, 0.8)
	
	# Transparent acrylic protective cases (glare lines)
	draw_line(Vector2(-23.0, -9.0), Vector2(-12.0, -9.0), Color("d8ece2", 0.40), 0.7)
	draw_line(Vector2(2.0, -9.0), Vector2(13.0, -9.0), Color("d8ece2", 0.40), 0.7)
	
	# Activated dual-resonance underglow
	if is_activated:
		draw_rect(m1_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.25 + pulse * 0.25))
		draw_rect(m2_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.25 + pulse * 0.25))
		draw_rect(top_rect, Color("eef6f2", 0.15 + pulse * 0.15))


func _draw_staircase_map_left() -> void:
	# Wall-mounted architectural schematic board: 34x44 px
	# Left version: "SCHEMAT 4-A / ULICA / 140 OSÓB"
	var pulse := sin(_pulse_phase * 1.8) * 0.5 + 0.5
	
	var board_rect := Rect2(-17.0, -22.0, 34.0, 44.0)
	draw_rect(board_rect, Color("1a2622"))
	draw_rect(board_rect, Color("3d5449", 0.75), false, 1.0)
	
	# Inner blueprint drafting sheet
	var sheet_rect := Rect2(-15.0, -20.0, 30.0, 40.0)
	draw_rect(sheet_rect, Color("14201c"))
	draw_rect(sheet_rect, Color("2d4037", 0.5), false, 0.7)
	
	# Header line: "SCHEMAT 4-A"
	draw_line(Vector2(-13.0, -17.0), Vector2(13.0, -17.0), Color("8fa89b", 0.8), 0.9)
	draw_line(Vector2(-13.0, -15.0), Vector2(6.0, -15.0), Color("c8dcd2"), 0.7)
	
	# Blueprint grid lines
	for gx in range(-12, 13, 6):
		draw_line(Vector2(float(gx), -12.0), Vector2(float(gx), 16.0), Color("1e3028", 0.4), 0.5)
	for gy in range(-10, 16, 5):
		draw_line(Vector2(-13.0, float(gy)), Vector2(13.0, float(gy)), Color("1e3028", 0.4), 0.5)
	
	# Staircase schematic profile (continuous descent to street level)
	for i in range(5):
		var sx := -11.0 + float(i) * 4.5
		var sy := -8.0 + float(i) * 4.5
		draw_line(Vector2(sx, sy), Vector2(sx + 3.5, sy), COLOR_CYAN * 0.85, 1.2)
		draw_line(Vector2(sx + 3.5, sy), Vector2(sx + 3.5, sy + 4.5), COLOR_CYAN * 0.65, 0.9)
	
	# Street level exit arrow & portal marker (clean cyan)
	draw_line(Vector2(7.0, 14.5), Vector2(12.0, 14.5), COLOR_CYAN, 1.5)
	draw_line(Vector2(10.0, 12.0), Vector2(12.0, 14.5), COLOR_CYAN, 1.0)
	draw_line(Vector2(10.0, 17.0), Vector2(12.0, 14.5), COLOR_CYAN, 1.0)
	
	# Status note: 140 OSÓB
	draw_line(Vector2(-13.0, 17.5), Vector2(3.0, 17.5), Color("76a892"), 0.8)
	
	# Inspected / activated glow
	if is_activated:
		draw_rect(board_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.15 + pulse * 0.15), false, 1.2)


func _draw_staircase_map_right() -> void:
	# Wall-mounted architectural schematic board: 34x44 px
	# Right version: "SCHEMAT 4-B / ŚCIANA NOŚNA / 17 ŚWIADKÓW"
	var pulse := sin(_pulse_phase * 1.8) * 0.5 + 0.5
	
	var board_rect := Rect2(-17.0, -22.0, 34.0, 44.0)
	draw_rect(board_rect, Color("1a2622"))
	draw_rect(board_rect, Color("3d5449", 0.75), false, 1.0)
	
	# Inner blueprint drafting sheet
	var sheet_rect := Rect2(-15.0, -20.0, 30.0, 40.0)
	draw_rect(sheet_rect, Color("14201c"))
	draw_rect(sheet_rect, Color("2d4037", 0.5), false, 0.7)
	
	# Header line: "SCHEMAT 4-B"
	draw_line(Vector2(-13.0, -17.0), Vector2(13.0, -17.0), Color("8fa89b", 0.8), 0.9)
	draw_line(Vector2(-13.0, -15.0), Vector2(6.0, -15.0), Color("c8dcd2"), 0.7)
	
	# Blueprint grid lines
	for gx in range(-12, 13, 6):
		draw_line(Vector2(float(gx), -12.0), Vector2(float(gx), 16.0), Color("1e3028", 0.4), 0.5)
	for gy in range(-10, 16, 5):
		draw_line(Vector2(-13.0, float(gy)), Vector2(13.0, float(gy)), Color("1e3028", 0.4), 0.5)
	
	# Staircase schematic profile (identical descent toward load-bearing wall)
	for i in range(5):
		var sx := -11.0 + float(i) * 4.0
		var sy := -8.0 + float(i) * 4.5
		draw_line(Vector2(sx, sy), Vector2(sx + 3.5, sy), COLOR_AMBER * 0.85, 1.2)
		draw_line(Vector2(sx + 3.5, sy), Vector2(sx + 3.5, sy + 4.5), COLOR_AMBER * 0.65, 0.9)
	
	# Load-bearing structural wall (cross-hatched vertical block)
	var wall_rect := Rect2(9.0, -6.0, 4.0, 22.0)
	draw_rect(wall_rect, Color("3e2a26"))
	draw_rect(wall_rect, COLOR_CORRECTION * 0.8, false, 0.9)
	for h in range(4):
		var hy := -4.0 + float(h) * 5.0
		draw_line(Vector2(9.0, hy), Vector2(13.0, hy + 3.0), COLOR_CORRECTION * 0.6, 0.7)
	
	# Status note: 17 ŚWIADKÓW
	draw_line(Vector2(-13.0, 17.5), Vector2(5.0, 17.5), Color("b89668"), 0.8)
	
	# Inspected / activated glow
	if is_activated:
		draw_rect(board_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.15 + pulse * 0.15), false, 1.2)


func _draw_eleven_persons_ledger() -> void:
	# Dossier binder on small side lectern/shelf: 28x22 px
	# 11 distinct row entries of persons missing from all official tables
	var pulse := sin(_pulse_phase * 2.2) * 0.5 + 0.5
	
	# Shelf support
	draw_rect(Rect2(-14.0, 8.0, 28.0, 3.0), Color("1c2622"))
	draw_line(Vector2(-12.0, 11.0), Vector2(-8.0, 16.0), Color("2e3e36"), 1.0)
	draw_line(Vector2(12.0, 11.0), Vector2(8.0, 16.0), Color("2e3e36"), 1.0)
	
	# Open ledger / dossier cover
	var book_rect := Rect2(-13.0, -10.0, 26.0, 18.0)
	draw_rect(book_rect, Color("22322a"))
	draw_rect(book_rect, Color("3e564a", 0.8), false, 0.9)
	
	# Inner paper pages (ivory sage)
	var page_rect := Rect2(-11.0, -8.0, 22.0, 14.0)
	draw_rect(page_rect, Color("dce6e0"))
	draw_line(Vector2(0.0, -8.0), Vector2(0.0, 6.0), Color("8ea096"), 0.8)
	
	# 11 lines of names/records (5 on left page, 6 on right page)
	for i in range(5):
		var ly := -6.0 + float(i) * 2.4
		draw_line(Vector2(-9.5, ly), Vector2(-1.5, ly), Color("4a5c54", 0.75), 0.8)
	for j in range(6):
		var ry := -6.5 + float(j) * 2.1
		draw_line(Vector2(1.5, ry), Vector2(9.5, ry), Color("4a5c54", 0.75), 0.8)
	
	# Red marginal note: Wierzbicka's private handwriting
	draw_line(Vector2(-10.5, -6.0), Vector2(-10.5, 4.0), Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.75), 0.9)
	
	# Metal spine clip
	draw_rect(Rect2(-1.0, -9.0, 2.0, 16.0), Color("6e8076"))
	
	if is_activated:
		draw_rect(book_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.20 + pulse * 0.20), false, 1.1)


func _draw_model_room_exit() -> void:
	# Heavy institutional exit door to Space 20 (Sala Szymona): 26x40 px
	var pulse := sin(_pulse_phase * 1.6) * 0.5 + 0.5
	
	# Frame
	var frame_rect := Rect2(-13.0, -20.0, 26.0, 40.0)
	draw_rect(frame_rect, Color("162024"))
	draw_rect(frame_rect, Color("34464c", 0.75), false, 1.2)
	
	# Door leaf: cold institutional olive steel
	var leaf_rect := Rect2(-11.0, -18.0, 22.0, 36.0)
	draw_rect(leaf_rect, Color("263630"))
	draw_rect(leaf_rect, Color("425a50", 0.5), false, 0.9)
	
	# Horizontal steel cross-dividers
	draw_rect(Rect2(-11.0, -4.0, 22.0, 2.0), Color("1c2824"))
	
	# Lock bolt housing
	draw_rect(Rect2(-9.0, 7.0, 18.0, 3.5), Color("3a4c44"))
	draw_rect(Rect2(-9.0, 7.0, 18.0, 3.5), COLOR_INFRASTRUCTURE * 0.5, false, 0.8)
	draw_circle(Vector2(6.0, 8.7), 2.0, Color("586862"))
	
	# Placard: "SALA SZYMONA / 20"
	draw_rect(Rect2(-10.0, -14.0, 20.0, 5.0), Color("16221e"))
	draw_rect(Rect2(-10.0, -14.0, 20.0, 5.0), COLOR_INFRASTRUCTURE * 0.4, false, 0.7)
	draw_line(Vector2(-8.0, -11.5), Vector2(8.0, -11.5), Color("c8d8d0"), 0.8)
	
	# Status indicator & bolt
	if is_activated:
		# Unlocked: cyan glow, bolt withdrawn
		draw_rect(frame_rect, COLOR_CYAN * 0.45, false, 1.4)
		draw_line(Vector2(-13.0, 20.0), Vector2(13.0, 20.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.75 + pulse * 0.25), 2.0)
		draw_rect(Rect2(2.0, 7.0, 9.0, 3.5), Color("2e3e36"))
	else:
		# Locked: subtle amber indicator
		draw_circle(Vector2(6.0, 8.7), 1.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.45 + pulse * 0.25))


func _draw_szymon_bera() -> void:
	# Szymon Bera sitting on edge of institutional bed in Room 20: 36x30 px
	# Conforms to VISUAL_DESIGN.md (muted grey sage, elderly weathered silhouette)
	var pulse := sin(_pulse_phase * 1.8) * 0.5 + 0.5
	var breath := sin(_pulse_phase * 1.2) * 1.0
	
	# Therapeutic bed frame (tubular aluminum & mattress)
	var bed_rect := Rect2(-18.0, 4.0, 36.0, 14.0)
	draw_rect(bed_rect, Color("1e2c26"))
	draw_rect(bed_rect, Color("3a4c44", 0.7), false, 1.0)
	
	# Mattress and folded institutional blanket
	draw_rect(Rect2(-17.0, 1.0, 34.0, 4.0), Color("d0ded8"))
	draw_rect(Rect2(-16.0, 5.0, 14.0, 12.0), Color("6c8278"))
	
	# Bed tubular legs
	draw_line(Vector2(-16.0, 18.0), Vector2(-16.0, 24.0), Color("4a5c54"), 1.5)
	draw_line(Vector2(16.0, 18.0), Vector2(16.0, 24.0), Color("4a5c54"), 1.5)
	
	# Szymon seated figure (center-right of bed)
	var sx := 4.0
	var sy := -4.0 + breath * 0.5
	
	# Legs / dark trousers
	draw_rect(Rect2(sx - 3.0, sy + 11.0, 4.0, 12.0), Color("202a24"))
	draw_rect(Rect2(sx + 2.0, sy + 11.0, 4.0, 12.0), Color("1a241e"))
	draw_rect(Rect2(sx - 3.0, sy + 22.0, 6.0, 3.0), Color("121814"))
	draw_rect(Rect2(sx + 2.0, sy + 22.0, 6.0, 3.0), Color("121814"))
	
	# Torso: grey wool sweater, slightly slouched
	var torso_rect := Rect2(sx - 5.0, sy + 1.0, 11.0, 11.0)
	draw_rect(torso_rect, Color("4a5c52"))
	draw_rect(torso_rect, Color("5c7266", 0.6), false, 0.8)
	
	# Arms resting on knees
	draw_line(Vector2(sx - 4.0, sy + 3.0), Vector2(sx - 2.0, sy + 11.0), Color("3e4e46"), 2.2)
	draw_line(Vector2(sx + 5.0, sy + 3.0), Vector2(sx + 4.0, sy + 11.0), Color("3e4e46"), 2.2)
	# Hands
	draw_circle(Vector2(sx - 2.0, sy + 11.0), 1.6, Color("c2a890"))
	draw_circle(Vector2(sx + 4.0, sy + 11.0), 1.6, Color("c2a890"))
	
	# Head & grey hair (bowed slightly forward)
	draw_circle(Vector2(sx, sy - 4.0), 3.8, Color("baa898"))
	draw_circle(Vector2(sx - 0.5, sy - 5.5), 3.2, Color("7a8a82")) # Grey hair
	
	if is_activated:
		draw_rect(Rect2(-19.0, -12.0, 38.0, 38.0), Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.18 + pulse * 0.18), false, 1.2)


func _draw_well_drawing() -> void:
	# Crayon drawing of the well on bedside wooden table: 28x22 px
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	
	# Small table top & leg
	var table_rect := Rect2(-14.0, 6.0, 28.0, 4.0)
	draw_rect(table_rect, Color("342820"))
	draw_line(Vector2(-10.0, 10.0), Vector2(-10.0, 20.0), Color("241c16"), 1.6)
	draw_line(Vector2(10.0, 10.0), Vector2(10.0, 20.0), Color("241c16"), 1.6)
	
	# Drawing paper sheet (angled slightly)
	var paper_rect := Rect2(-11.0, -9.0, 22.0, 15.0)
	draw_rect(paper_rect, Color("f2eee4"))
	draw_rect(paper_rect, Color("d0c8b8", 0.8), false, 0.8)
	
	# Crayon drawing elements:
	# 1. High stone well with crank and bucket (blue/teal wax crayon)
	var well_box := Rect2(-8.0, -7.0, 9.0, 6.0)
	draw_rect(well_box, Color("3a7082"))
	draw_line(Vector2(-8.0, -7.0), Vector2(-3.5, -9.0), Color("785438"), 1.2) # Roof left
	draw_line(Vector2(-3.5, -9.0), Vector2(1.0, -7.0), Color("785438"), 1.2) # Roof right
	draw_line(Vector2(-3.5, -7.0), Vector2(-3.5, -4.0), Color("2a4450"), 0.8) # Chain
	
	# 2. Schoolhouse drawn lower on the page (red/brick crayon)
	var school_box := Rect2(1.0, -2.0, 8.0, 6.0)
	draw_rect(school_box, Color("9e463e"))
	draw_line(Vector2(1.0, -2.0), Vector2(5.0, -4.0), Color("6e2822"), 1.0)
	draw_line(Vector2(5.0, -4.0), Vector2(9.0, -2.0), Color("6e2822"), 1.0)
	
	# 3. Erased signature in bottom-right corner (thinned, abraded paper texture)
	var erase_rect := Rect2(3.0, 2.0, 7.0, 3.5)
	draw_rect(erase_rect, Color("e4dcce"))
	for e in range(3):
		var ex := 4.0 + float(e) * 2.0
		draw_line(Vector2(ex, 3.0), Vector2(ex + 1.0, 4.5), Color("b0a696", 0.5), 0.6)
	
	if is_activated:
		draw_rect(paper_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.22 + pulse * 0.20), false, 1.2)


func _draw_hydrology_report() -> void:
	# Official UCP Hydrology Report document on side desk: 24x20 px
	var pulse := sin(_pulse_phase * 1.7) * 0.5 + 0.5
	
	# Folder backboard
	var binder_rect := Rect2(-12.0, -9.0, 24.0, 18.0)
	draw_rect(binder_rect, Color("202e28"))
	draw_rect(binder_rect, Color("3a5246", 0.7), false, 0.9)
	
	# Official paper page
	var sheet_rect := Rect2(-10.0, -7.0, 20.0, 14.0)
	draw_rect(sheet_rect, Color("e2ece6"))
	
	# Blue UCP institutional header bar
	draw_rect(Rect2(-9.0, -6.0, 18.0, 2.5), Color("3a6078"))
	
	# Report content text lines
	draw_line(Vector2(-8.0, -1.5), Vector2(6.0, -1.5), Color("4a5e54", 0.8), 0.8) # "RAPORT UJĘCIA WODY"
	draw_line(Vector2(-8.0, 1.0), Vector2(4.0, 1.0), Color("2e7a5c", 0.9), 0.8) # "STATUS: NAPRAWIONE"
	
	# Cleared / blank reporting field (highlighted empty box)
	draw_rect(Rect2(-8.0, 3.0, 14.0, 2.5), Color("cedad2"))
	draw_rect(Rect2(-8.0, 3.0, 14.0, 2.5), Color("8aa094", 0.6), false, 0.6)
	
	# Official red/amber verification stamp
	draw_circle(Vector2(6.0, 3.5), 1.8, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.75))
	
	if is_activated:
		draw_rect(binder_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.20 + pulse * 0.18), false, 1.1)


func _draw_erased_signature_magnifier() -> void:
	# Articulating inspection lamp & magnifying glass: 24x26 px
	var pulse := sin(_pulse_phase * 2.1) * 0.5 + 0.5
	
	# Weighted base
	draw_rect(Rect2(-8.0, 8.0, 16.0, 3.0), Color("222c28"))
	
	# Articulated arm
	draw_line(Vector2(-4.0, 8.0), Vector2(-1.0, -2.0), Color("586a62"), 1.5)
	draw_line(Vector2(-1.0, -2.0), Vector2(5.0, -8.0), Color("72867c"), 1.2)
	draw_circle(Vector2(-1.0, -2.0), 1.5, Color("34423c"))
	
	# Magnifying glass rim & lens
	var lens_center := Vector2(7.0, -8.0)
	draw_circle(lens_center, 6.5, Color("485c54")) # Metal rim
	draw_circle(lens_center, 5.0, Color("d0e4dc", 0.75)) # Glass lens
	
	# Magnified micro-traces of graphite: faint "I g a"
	draw_line(lens_center + Vector2(-3.0, -2.0), lens_center + Vector2(-3.0, 2.0), Color("6c7a72", 0.8), 0.9) # 'I'
	draw_circle(lens_center + Vector2(-0.5, 0.5), 1.2, Color("6c7a72", 0.75)) # 'g'
	draw_circle(lens_center + Vector2(2.5, 0.5), 1.1, Color("6c7a72", 0.75)) # 'a'
	
	# Glass glint
	draw_line(lens_center + Vector2(-3.5, -3.5), lens_center + Vector2(1.0, -3.5), Color(1.0, 1.0, 1.0, 0.6), 0.8)
	
	if is_activated:
		draw_circle(lens_center, 7.5, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.25 + pulse * 0.25))


func _draw_szymon_room_exit() -> void:
	# Heavy institutional isolation room sliding door to Space 21: 26x40 px
	# Noticeable structural shift of frame (shifted 3-4 cm laterally)
	var pulse := sin(_pulse_phase * 1.6) * 0.5 + 0.5
	
	# Outer frame (showing slight mechanical displacement)
	var frame_rect := Rect2(-13.0, -20.0, 26.0, 40.0)
	draw_rect(frame_rect, Color("182420"))
	draw_rect(frame_rect, Color("32443c", 0.75), false, 1.2)
	
	# Shift displacement seam lines on wall
	draw_line(Vector2(-15.0, -18.0), Vector2(-15.0, 18.0), Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.5), 0.8)
	draw_line(Vector2(15.0, -18.0), Vector2(15.0, 18.0), Color("283830"), 0.8)
	
	# Door leaf: cold institutional white-grey
	var leaf_rect := Rect2(-10.0, -18.0, 20.0, 36.0)
	draw_rect(leaf_rect, Color("283832"))
	draw_rect(leaf_rect, Color("445c50", 0.5), false, 0.9)
	
	# Vertical observation glass slit
	var slit_rect := Rect2(-2.0, -12.0, 4.0, 12.0)
	draw_rect(slit_rect, Color("141e1a"))
	draw_rect(slit_rect, Color("75c7c3", 0.4))
	
	# Lock bolt & status indicator
	draw_rect(Rect2(-8.0, 6.0, 16.0, 4.0), Color("364a40"))
	
	# Placard: "SALA SZYMONA / 20"
	draw_rect(Rect2(-9.0, -15.0, 18.0, 3.0), Color("1c2a24"))
	draw_line(Vector2(-7.0, -13.5), Vector2(7.0, -13.5), Color("c4d4cc"), 0.7)
	
	if is_activated:
		# Unlocked / open: cyan glow, frame seam illuminated
		draw_rect(frame_rect, COLOR_CYAN * 0.45, false, 1.4)
		draw_line(Vector2(-13.0, 20.0), Vector2(13.0, 20.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.75 + pulse * 0.25), 2.0)
		draw_rect(Rect2(-2.0, 6.0, 8.0, 4.0), Color("2e3e36"))
	else:
		# Locked
		draw_circle(Vector2(4.0, 8.0), 1.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.45 + pulse * 0.25))


func _draw_szymon_post_correction() -> void:
	# Szymon Bera resting in clinical adaptive sedation recliner chair: 32x36 px
	# Calm, pacified posture post-procedure
	var pulse := sin(_pulse_phase * 1.5) * 0.5 + 0.5
	
	# Clinical recliner chair base & backrest
	var base_rect := Rect2(-14.0, 10.0, 28.0, 6.0)
	draw_rect(base_rect, Color("1a2622"))
	draw_line(Vector2(-12.0, 16.0), Vector2(-12.0, 20.0), Color("121c18"), 2.0)
	draw_line(Vector2(12.0, 16.0), Vector2(12.0, 20.0), Color("121c18"), 2.0)
	
	# Angled padded recliner back (45 deg tilt)
	draw_rect(Rect2(-12.0, -8.0, 24.0, 18.0), Color("263832"))
	draw_rect(Rect2(-12.0, -8.0, 24.0, 18.0), Color("385046", 0.6), false, 0.9)
	draw_rect(Rect2(-10.0, -14.0, 20.0, 8.0), Color("20302a")) # Headrest
	
	# Reclined human figure (Szymon Bera)
	# Torso in clinical hospital smock (soft muted grey-green)
	draw_rect(Rect2(-8.0, -4.0, 16.0, 14.0), Color("6c8078"))
	draw_rect(Rect2(-8.0, -4.0, 16.0, 14.0), Color("869e94", 0.4), false, 0.8)
	
	# Folded calm arms resting on armrests
	draw_line(Vector2(-9.0, 2.0), Vector2(-4.0, 6.0), Color("566860"), 1.8)
	draw_line(Vector2(9.0, 2.0), Vector2(4.0, 6.0), Color("566860"), 1.8)
	draw_circle(Vector2(0.0, 6.0), 2.2, Color("a89886")) # Hands resting peacefully
	
	# Head resting back
	draw_circle(Vector2(0.0, -9.0), 4.5, Color("b4a492")) # Head / face
	draw_circle(Vector2(0.0, -11.0), 4.2, Color("706e68")) # Thin grey hair
	draw_line(Vector2(-2.0, -9.0), Vector2(2.0, -9.0), Color("443c34"), 0.8) # Closed/calm eyes
	
	# Neuro-sedation sensor cannula on right temple (soft cyan glow lead)
	draw_circle(Vector2(3.5, -9.5), 1.2, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.75 + pulse * 0.25))
	draw_line(Vector2(4.5, -9.5), Vector2(12.0, -12.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.4 + pulse * 0.3), 0.7)
	
	if is_activated:
		draw_rect(Rect2(-15.0, -16.0, 30.0, 34.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.18 + pulse * 0.18), false, 1.2)


func _draw_anesthesia_terminal() -> void:
	# UCP Sedation & Neuro-Adaptation Console: 26x34 px
	var pulse := sin(_pulse_phase * 2.2) * 0.5 + 0.5
	
	# Main rack column (dark clinical steel)
	var rack_rect := Rect2(-12.0, -16.0, 24.0, 32.0)
	draw_rect(rack_rect, Color("142022"))
	draw_rect(rack_rect, Color("2a3e40", 0.8), false, 1.0)
	
	# CRT Vitals & Sedation Waveform Display
	var crt_rect := Rect2(-9.0, -13.0, 18.0, 12.0)
	draw_rect(crt_rect, Color("0a1214"))
	draw_rect(crt_rect, Color("204448", 0.6), false, 0.8)
	
	# Flatlined panic trace -> smooth gentle sine rhythm
	var wave_color := Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.85)
	for i in range(16):
		var x1 := -8.0 + float(i)
		var x2 := -8.0 + float(i + 1)
		var y1 := -7.0 + sin((float(i) + _pulse_phase * 4.0) * 0.6) * 2.0
		var y2 := -7.0 + sin((float(i + 1) + _pulse_phase * 4.0) * 0.6) * 2.0
		draw_line(Vector2(x1, y1), Vector2(x2, y2), wave_color, 0.9)
	
	# Status readout LED matrix
	draw_rect(Rect2(-9.0, 1.0, 18.0, 3.0), Color("122426"))
	draw_line(Vector2(-7.0, 2.5), Vector2(5.0, 2.5), Color("75c7c3", 0.7), 0.7) # "STABILNOŚĆ: 99.8%"
	
	# Control switches and status lamps
	draw_circle(Vector2(-6.0, 7.0), 1.5, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.85)) # Active green/cyan lamp
	draw_circle(Vector2(0.0, 7.0), 1.5, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.60)) # Sedation ready
	draw_circle(Vector2(6.0, 7.0), 1.5, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.25)) # Panic suppressed
	
	# Conduit cable feeding to recliner
	draw_line(Vector2(8.0, 12.0), Vector2(14.0, 14.0), Color("34484c"), 1.4)
	
	if is_activated:
		draw_rect(rack_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.20 + pulse * 0.20), false, 1.2)


func _draw_filtered_dossier_slot() -> void:
	# Recessed pneumatic wall cassette with official sanitized entry: 22x26 px
	# ("SKORZYSTANO Z RAPORTU HYDROLOGICZNEGO / AUTOR: ANONIMOWY")
	var pulse := sin(_pulse_phase * 1.8) * 0.5 + 0.5
	
	# Recessed wall box
	var box_rect := Rect2(-11.0, -13.0, 22.0, 26.0)
	draw_rect(box_rect, Color("1c2824"))
	draw_rect(box_rect, Color("344840", 0.8), false, 1.0)
	
	# Transparent plexiglass document slot
	var slot_rect := Rect2(-8.0, -10.0, 16.0, 20.0)
	draw_rect(slot_rect, Color("263832", 0.9))
	draw_rect(slot_rect, Color("48665a", 0.6), false, 0.8)
	
	# Document sheet
	var doc_rect := Rect2(-6.0, -8.0, 12.0, 16.0)
	draw_rect(doc_rect, Color("e4eae6"))
	
	# UCP blue header
	draw_rect(Rect2(-5.0, -7.0, 10.0, 2.0), Color("3a5e78"))
	
	# Sanitized report lines
	draw_line(Vector2(-5.0, -3.5), Vector2(3.0, -3.5), Color("42564c", 0.8), 0.7) # Text
	draw_line(Vector2(-5.0, -1.5), Vector2(4.0, -1.5), Color("2e7a5c", 0.9), 0.7) # "STATUS: SPÓJNY"
	
	# Erased author field (grayed out blank box)
	draw_rect(Rect2(-5.0, 1.0, 10.0, 2.0), Color("c4d0c8"))
	
	# Red/amber UCP archive stamp
	draw_circle(Vector2(2.5, 4.5), 1.6, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.8))
	
	if is_activated:
		draw_rect(box_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.22 + pulse * 0.20), false, 1.2)


func _draw_drawing_disposition_pedestal() -> void:
	# Metal evidence display stand holding drawing or blank disposition: 24x28 px
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	
	# Pedestal column and weighted foot
	draw_rect(Rect2(-8.0, 10.0, 16.0, 4.0), Color("22302a"))
	draw_line(Vector2(0.0, 10.0), Vector2(0.0, -4.0), Color("384e44"), 2.2)
	
	# Angled display table plate
	draw_line(Vector2(-11.0, -4.0), Vector2(11.0, -8.0), Color("4c685c"), 1.8)
	
	# Drawing paper sheet resting on top
	var sheet_center := Vector2(0.0, -8.0)
	var paper_rect := Rect2(-9.0, -14.0, 18.0, 10.0)
	draw_rect(paper_rect, Color("f0ece2"))
	draw_rect(paper_rect, Color("d0c8b6", 0.8), false, 0.7)
	
	# Crayon drawing micro-traces (Well & School)
	draw_rect(Rect2(-7.0, -12.5, 6.0, 4.0), Color("3a7082")) # Blue well
	draw_rect(Rect2(1.0, -10.0, 6.0, 4.0), Color("9e463e")) # Red school
	
	# Thinned blank signature spot glowing with loss
	draw_rect(Rect2(2.0, -6.5, 5.0, 2.5), Color("e2dac8"))
	draw_circle(Vector2(4.5, -5.2), 1.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.4 + pulse * 0.35))
	
	if is_activated:
		draw_rect(paper_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.25 + pulse * 0.25), false, 1.2)


func _draw_station_21_exit() -> void:
	# Heavy automated pressurized sliding airlock gate to Space 22 (Uległość): 28x44 px
	var pulse := sin(_pulse_phase * 1.6) * 0.5 + 0.5
	
	# Outer frame
	var frame_rect := Rect2(-14.0, -22.0, 28.0, 44.0)
	draw_rect(frame_rect, Color("16201e"))
	draw_rect(frame_rect, Color("2e423a", 0.8), false, 1.2)
	
	# Twin sliding door leaves
	var leaf_left := Rect2(-11.0, -19.0, 10.0, 38.0)
	var leaf_right := Rect2(1.0, -19.0, 10.0, 38.0)
	draw_rect(leaf_left, Color("22322c"))
	draw_rect(leaf_right, Color("22322c"))
	draw_rect(leaf_left, Color("3a5046", 0.5), false, 0.8)
	draw_rect(leaf_right, Color("3a5046", 0.5), false, 0.8)
	
	# Center compression seam
	draw_line(Vector2(0.0, -19.0), Vector2(0.0, 19.0), Color("141e1a"), 1.5)
	
	# Top illuminated indicator bar: "STREFA TRANZYTOWA / 22"
	draw_rect(Rect2(-10.0, -17.0, 20.0, 3.5), Color("182620"))
	draw_line(Vector2(-8.0, -15.2), Vector2(8.0, -15.2), Color("a0b8ac"), 0.7)
	
	# Observation glass slit
	draw_rect(Rect2(-2.0, -11.0, 4.0, 10.0), Color("0e1614"))
	draw_rect(Rect2(-2.0, -11.0, 4.0, 10.0), Color("75c7c3", 0.4))
	
	if is_activated:
		# Unlocked / cycling open
		draw_rect(frame_rect, COLOR_CYAN * 0.5, false, 1.4)
		draw_line(Vector2(-14.0, 22.0), Vector2(14.0, 22.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.8 + pulse * 0.2), 2.0)
		draw_line(Vector2(-1.0, -19.0), Vector2(-1.0, 19.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.6), 1.0)
	else:
		# Locked
		draw_circle(Vector2(0.0, 6.0), 1.5, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.45 + pulse * 0.25))


func _draw_biometric_identity_gate() -> void:
	# Massive biometric transit portal in Compliance Point 6: 32x52 px
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	
	# Portal pillar frames (left and right columns)
	var col_left := Rect2(-16.0, -26.0, 6.0, 52.0)
	var col_right := Rect2(10.0, -26.0, 6.0, 52.0)
	draw_rect(col_left, Color("141e20"))
	draw_rect(col_right, Color("141e20"))
	draw_rect(col_left, Color("2a3c3e", 0.8), false, 1.0)
	draw_rect(col_right, Color("2a3c3e", 0.8), false, 1.0)
	
	# Top lintel with identification readout
	var lintel := Rect2(-16.0, -26.0, 32.0, 8.0)
	draw_rect(lintel, Color("1a2628"))
	draw_rect(lintel, Color("344c50", 0.7), false, 1.0)
	# Readout text / glow line: "LENA W. / 17-D"
	draw_line(Vector2(-12.0, -22.0), Vector2(12.0, -22.0), Color("d4a359", 0.75), 1.0)
	
	# Central optical scanning field / palm contour platen
	var platen_rect := Rect2(-9.0, -8.0, 18.0, 24.0)
	draw_rect(platen_rect, Color("0e1618"))
	draw_rect(platen_rect, Color("22363a", 0.9), false, 0.8)
	
	# Palm contour graphic (etched silhouette)
	var palm_color := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.35 + pulse * 0.35)
	if is_activated:
		palm_color = Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.85 + pulse * 0.15)
	
	# Palm base
	draw_circle(Vector2(0.0, 5.0), 4.5, palm_color * 0.7)
	# 5 fingers contour lines
	draw_line(Vector2(-4.0, 2.0), Vector2(-6.0, -4.0), palm_color, 1.0) # Thumb
	draw_line(Vector2(-2.5, 1.0), Vector2(-3.0, -6.5), palm_color, 1.0) # Index
	draw_line(Vector2(0.0, 1.0), Vector2(0.0, -7.5), palm_color, 1.0)   # Middle
	draw_line(Vector2(2.5, 1.0), Vector2(3.0, -6.5), palm_color, 1.0)   # Ring
	draw_line(Vector2(4.5, 2.0), Vector2(5.5, -4.0), palm_color, 1.0)   # Little
	
	# Scanning laser horizontal line sweeping vertically
	var scan_y := -7.0 + sin(_pulse_phase * 3.5) * 10.0
	var laser_color := Color("75c7c3", 0.7) if is_activated else Color("d4a359", 0.6)
	draw_line(Vector2(-8.0, scan_y), Vector2(8.0, scan_y), laser_color, 1.2)
	
	# Floor mounting plate
	draw_line(Vector2(-18.0, 26.0), Vector2(18.0, 26.0), Color("3a4e52"), 2.0)
	
	if is_activated:
		# Authorization active bloom
		draw_rect(Rect2(-16.0, -26.0, 32.0, 52.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.15 + pulse * 0.20), false, 1.5)


func _draw_compliance_contact_register() -> void:
	# Compliance Point 6 emergency contact authorization terminal: 28x32 px
	# ("KONTAKT ALARMOWY: MARTA KUREK / STATUS: ZWERYFIKOWANA WIĘŹ")
	var pulse := sin(_pulse_phase * 2.2) * 0.5 + 0.5
	
	# Pedestal stand
	draw_rect(Rect2(-6.0, 10.0, 12.0, 6.0), Color("182426"))
	draw_line(Vector2(0.0, 10.0), Vector2(0.0, 0.0), Color("2e4246"), 2.4)
	
	# Angled CRT housing
	var housing_rect := Rect2(-14.0, -16.0, 28.0, 20.0)
	draw_rect(housing_rect, Color("142022"))
	draw_rect(housing_rect, Color("2d4044", 0.8), false, 1.0)
	
	# CRT Screen (Warm amber institutional phosphor)
	var screen_rect := Rect2(-11.0, -13.0, 22.0, 12.0)
	draw_rect(screen_rect, Color("121410"))
	draw_rect(screen_rect, Color("3a3820", 0.8), false, 0.8)
	
	# Screen text scanlines (Simulating "MARTA KUREK / KONTAKT")
	var line_color := Color("d4a359", 0.85)
	draw_line(Vector2(-9.0, -10.0), Vector2(7.0, -10.0), line_color, 0.8) # "KONTAKT: MARTA K."
	draw_line(Vector2(-9.0, -7.0), Vector2(3.0, -7.0), Color("a8b2ac", 0.7), 0.7)  # "STATUS: ZGŁOSZENIE"
	draw_line(Vector2(-9.0, -4.0), Vector2(8.0, -4.0), Color("75c7c3", 0.8), 0.8)  # "AUTORYZACJA: ZGODNA"
	
	# Blinking cursor
	if int(_pulse_phase * 3.0) % 2 == 0:
		draw_rect(Rect2(5.0, -8.0, 2.0, 2.5), Color("d4a359"))
	
	# Keyboard tray
	var kbd_rect := Rect2(-12.0, 4.0, 24.0, 5.0)
	draw_rect(kbd_rect, Color("1c282a"))
	draw_line(Vector2(-10.0, 6.5), Vector2(10.0, 6.5), Color("3e565a"), 1.0)
	
	# Status verification LED
	var led_color := Color("6db3a8") if is_activated else Color("d4a359", 0.6 + pulse * 0.4)
	draw_circle(Vector2(9.0, 6.5), 1.4, led_color)
	
	if is_activated:
		draw_rect(housing_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.22 + pulse * 0.22), false, 1.2)


func _draw_ring_fitting_scanner() -> void:
	# Gold wedding ring relational verification scanner: 26x30 px
	var pulse := sin(_pulse_phase * 2.4) * 0.5 + 0.5
	
	# Console body
	var console_rect := Rect2(-12.0, -14.0, 24.0, 26.0)
	draw_rect(console_rect, Color("162224"))
	draw_rect(console_rect, Color("2d4044", 0.8), false, 1.0)
	
	# Circular inductive scanner basin (Copper / gold ring socket)
	var basin_center := Vector2(0.0, -3.0)
	draw_circle(basin_center, 8.0, Color("0f181a"))
	draw_circle(basin_center, 8.0, Color("344e52", 0.7), false, 0.8)
	
	# Concentric inductive loops
	draw_circle(basin_center, 5.5, Color("4a3c20", 0.8), false, 0.8)
	
	# Golden ring representation in socket
	var ring_color := Color("d4a359", 0.7 + pulse * 0.3)
	if is_activated:
		ring_color = Color("e8c07a", 0.95)
	draw_circle(basin_center, 3.8, ring_color, false, 1.4)
	
	# Relational micro-resonance emission rays
	if is_activated or is_player_in_range:
		for r in range(6):
			var angle := float(r) * (TAU / 6.0) + _pulse_phase * 1.5
			var r_start := basin_center + Vector2(cos(angle), sin(angle)) * 4.5
			var r_end := basin_center + Vector2(cos(angle), sin(angle)) * (7.0 + pulse * 2.5)
			draw_line(r_start, r_end, Color("d4a359", 0.4 + pulse * 0.4), 0.9)
	
	# Lower status readout
	draw_rect(Rect2(-8.0, 6.0, 16.0, 3.5), Color("101a1c"))
	draw_line(Vector2(-6.0, 7.7), Vector2(6.0, 7.7), Color("e8c07a", 0.8), 0.8)
	
	if is_activated:
		draw_rect(console_rect, Color("d4a359", 0.25 + pulse * 0.25), false, 1.2)


func _draw_paint_resin_resonance_slab() -> void:
	# Sensory memory recall slab: Emulsion paint smell & biographical erasure: 28x34 px
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	
	# Base mounting slab (institutional wall panel)
	var slab_rect := Rect2(-14.0, -16.0, 28.0, 32.0)
	draw_rect(slab_rect, Color("1a2426"))
	draw_rect(slab_rect, Color("304448", 0.8), false, 1.0)
	
	# Upper section: Fresh emulsion paint swatch (Apartment 14 memory)
	var paint_swatch := Rect2(-11.0, -13.0, 22.0, 13.0)
	draw_rect(paint_swatch, Color("dcd8cc")) # Warm matte emulsion paint
	draw_rect(paint_swatch, Color("b8b2a2", 0.8), false, 0.7)
	
	# Texture of roller stroke across the paint
	draw_line(Vector2(-9.0, -9.0), Vector2(7.0, -9.0), Color("ece8dc", 0.9), 1.5)
	draw_line(Vector2(-7.0, -6.0), Vector2(9.0, -6.0), Color("c8c2b0", 0.8), 1.2)
	
	# Micro-particles / solvent vapor bloom rising from paint
	var vapor_alpha := 0.25 + pulse * 0.35
	for v in range(3):
		var vy := -15.0 - float(v) * 3.0 - sin(_pulse_phase * 2.0 + float(v)) * 2.0
		var vx := -5.0 + float(v) * 5.0 + cos(_pulse_phase * 1.5 + float(v)) * 2.0
		draw_circle(Vector2(vx, vy), 1.2, Color("d4a359", vapor_alpha))
	
	# Lower section: Biographical erasure slot (Silhouette of nurse's cap with erased face)
	var photo_rect := Rect2(-11.0, 2.0, 22.0, 12.0)
	draw_rect(photo_rect, Color("12181a"))
	draw_rect(photo_rect, Color("223034", 0.8), false, 0.7)
	
	# Nurse's white medical cap outline
	draw_line(Vector2(-5.0, 5.0), Vector2(5.0, 5.0), Color("c8d4d0", 0.7), 1.0)
	draw_line(Vector2(-5.0, 5.0), Vector2(0.0, 3.5), Color("c8d4d0", 0.7), 1.0)
	draw_line(Vector2(5.0, 5.0), Vector2(0.0, 3.5), Color("c8d4d0", 0.7), 1.0)
	
	# Erased face: White/gray empty glowing blank void
	var void_color := Color("5a6b68", 0.7 + pulse * 0.3)
	if is_activated:
		void_color = Color("94a6a2", 0.9)
	draw_circle(Vector2(0.0, 8.5), 3.0, void_color)
	draw_circle(Vector2(0.0, 8.5), 1.8, Color("dcebe6", 0.6))
	
	if is_activated:
		draw_rect(slab_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.25 + pulse * 0.25), false, 1.2)


func _draw_station_22_exit() -> void:
	# Heavy transit portal leading to Space 23 (Pokój projektantki): 30x48 px
	var pulse := sin(_pulse_phase * 1.8) * 0.5 + 0.5
	
	# Main portal frame
	var frame_rect := Rect2(-15.0, -24.0, 30.0, 48.0)
	draw_rect(frame_rect, Color("141e20"))
	draw_rect(frame_rect, Color("2c3e42", 0.85), false, 1.2)
	
	# Heavy copper & steel door leaves
	var door_left := Rect2(-12.0, -21.0, 11.0, 42.0)
	var door_right := Rect2(1.0, -21.0, 11.0, 42.0)
	draw_rect(door_left, Color("1c2a2c"))
	draw_rect(door_right, Color("1c2a2c"))
	draw_rect(door_left, Color("344a4e", 0.6), false, 0.8)
	draw_rect(door_right, Color("344a4e", 0.6), false, 0.8)
	
	# Vertical locking seam
	draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("101618"), 1.5)
	
	# Top archive placard: "23 / PROJEKTANTKA — ARCHIWUM"
	draw_rect(Rect2(-11.0, -19.0, 22.0, 4.0), Color("121a1c"))
	draw_line(Vector2(-9.0, -17.0), Vector2(9.0, -17.0), Color("d4a359", 0.75), 0.8)
	
	# Observation viewport window (showing warm amber monitors in Room 23)
	var view_rect := Rect2(-3.0, -12.0, 6.0, 12.0)
	draw_rect(view_rect, Color("0a1012"))
	draw_rect(view_rect, Color("d4a359", 0.35 if not is_activated else 0.75))
	
	if is_activated:
		# Unlocked & cycling open
		draw_rect(frame_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45 + pulse * 0.25), false, 1.5)
		draw_line(Vector2(-15.0, 24.0), Vector2(15.0, 24.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.9), 2.0)
		draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("6db3a8", 0.8), 1.0)
	else:
		# Locked / magnetic clamp active
		draw_circle(Vector2(0.0, 8.0), 1.6, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.5 + pulse * 0.3))


func _draw_designer_terminal() -> void:
	# Local Lena's workstation CRT terminal & pattern overwrite station: 34x32 px
	var pulse := sin(_pulse_phase * 2.2) * 0.5 + 0.5
	
	# Heavy drafting desk & terminal chassis
	var desk_rect := Rect2(-17.0, -10.0, 34.0, 24.0)
	draw_rect(desk_rect, Color("141d1f"))
	draw_rect(desk_rect, Color("2a3c3e", 0.85), false, 1.0)
	
	# Copper cooling ribs / heat sinks on side
	for r in range(4):
		var rx := -15.0 + float(r) * 2.5
		draw_line(Vector2(rx, 4.0), Vector2(rx, 12.0), Color("a67238", 0.7), 0.8)
	
	# Main CRT Monitor housing
	var crt_housing := Rect2(-14.0, -16.0, 28.0, 18.0)
	draw_rect(crt_housing, Color("182326"))
	draw_rect(crt_housing, Color("344c50", 0.9), false, 1.0)
	
	# Curved CRT screen (amber / sage phosphor)
	var screen_rect := Rect2(-12.0, -14.0, 24.0, 14.0)
	var screen_bg := Color("0d1517")
	draw_rect(screen_rect, screen_bg)
	
	# CRT phosphor raster scanlines
	var crt_glow := Color("d9a05b", 0.65 + pulse * 0.35) if is_activated else Color("68b8a5", 0.55 + pulse * 0.25)
	for y in range(4):
		var sy := -12.0 + float(y) * 3.0
		draw_line(Vector2(-10.0, sy), Vector2(10.0, sy), Color(crt_glow.r, crt_glow.g, crt_glow.b, 0.3), 0.6)
	
	# District pattern failure map / grid traces
	draw_line(Vector2(-8.0, -11.0), Vector2(-2.0, -11.0), crt_glow, 1.0)
	draw_line(Vector2(-2.0, -11.0), Vector2(2.0, -7.0), crt_glow, 1.0)
	draw_line(Vector2(2.0, -7.0), Vector2(8.0, -7.0), crt_glow, 1.0)
	draw_circle(Vector2(2.0, -7.0), 1.4, Color("c65d58", 0.8 + pulse * 0.2)) # Failure hotspot
	
	# Active status indicator LED
	draw_circle(Vector2(11.0, 10.0), 1.2, Color("e8c07a", 0.8 + pulse * 0.2) if is_activated else Color("5a7a72", 0.6))
	
	if is_activated or is_player_in_range:
		draw_rect(crt_housing, Color("d9a05b", 0.35 + pulse * 0.25), false, 1.2)


func _draw_substructure_architectural_model() -> void:
	# 3D Wireframe physical model of Podstruktura skeleton with handwritten note: 32x34 px
	var pulse := sin(_pulse_phase * 1.9) * 0.5 + 0.5
	
	# Heavy circular acrylic & cast iron base pedestal
	var base_rect := Rect2(-16.0, 4.0, 32.0, 12.0)
	draw_rect(base_rect, Color("162022"))
	draw_rect(base_rect, Color("2d4044", 0.85), false, 1.0)
	
	# Acrylic transparent dome / column
	var dome_rect := Rect2(-13.0, -16.0, 26.0, 20.0)
	draw_rect(dome_rect, Color("101a1c", 0.6))
	draw_rect(dome_rect, Color("3a5458", 0.5), false, 0.8)
	
	# Multi-tier Podstruktura conduit skeleton (Copper wire lattice)
	var copper_wire := Color("d9a05b", 0.85 + pulse * 0.15)
	# Upper platform
	draw_line(Vector2(-8.0, -13.0), Vector2(8.0, -13.0), copper_wire, 1.2)
	# Intermediate transit ring
	draw_line(Vector2(-10.0, -7.0), Vector2(10.0, -7.0), copper_wire, 1.0)
	# Lower foundation hub
	draw_line(Vector2(-7.0, -1.0), Vector2(7.0, -1.0), copper_wire, 1.2)
	
	# Vertical interconnecting conduits
	draw_line(Vector2(-6.0, -13.0), Vector2(-8.0, -7.0), copper_wire, 0.9)
	draw_line(Vector2(6.0, -13.0), Vector2(8.0, -7.0), copper_wire, 0.9)
	draw_line(Vector2(-8.0, -7.0), Vector2(-5.0, -1.0), copper_wire, 0.9)
	draw_line(Vector2(8.0, -7.0), Vector2(5.0, -1.0), copper_wire, 0.9)
	draw_line(Vector2(0.0, -13.0), Vector2(0.0, -1.0), Color("75c7c3", 0.75), 0.9) # Central correlation axis
	
	# Handwritten paper note on stand: "JEŚLI TO CZYTASZ, ZGODZIŁAM SIĘ NA TWOJE RYZYKO"
	var note_rect := Rect2(-11.0, 6.0, 22.0, 8.0)
	draw_rect(note_rect, Color("ded9cb")) # Aged archival paper
	draw_rect(note_rect, Color("9e9582", 0.8), false, 0.7)
	# Inscribed text lines
	draw_line(Vector2(-9.0, 8.5), Vector2(7.0, 8.5), Color("24221d", 0.85), 0.9)
	draw_line(Vector2(-8.0, 11.5), Vector2(9.0, 11.5), Color("a67238", 0.9), 0.9)
	
	if is_activated or is_player_in_range:
		draw_rect(dome_rect, Color("e8c07a", 0.35 + pulse * 0.35), false, 1.2)
		draw_circle(Vector2(0.0, -7.0), 2.0, Color("75c7c3", 0.9))


func _draw_burdened_persons_ledger() -> void:
	# Archive rack of burdened citizens ledger / contradiction debt index: 26x36 px
	var pulse := sin(_pulse_phase * 2.5) * 0.5 + 0.5
	
	# Steel archive cabinet chassis
	var cab_rect := Rect2(-13.0, -18.0, 26.0, 36.0)
	draw_rect(cab_rect, Color("141c1e"))
	draw_rect(cab_rect, Color("28393d", 0.85), false, 1.0)
	
	# Vertical index dossier trays (4 slots)
	for s in range(4):
		var sy := -14.0 + float(s) * 8.0
		var slot_rect := Rect2(-10.0, sy, 20.0, 6.0)
		draw_rect(slot_rect, Color("1b2628"))
		draw_rect(slot_rect, Color("384e52", 0.7), false, 0.8)
		
		# Dossier tab indicator
		var tab_color := Color("d9a05b", 0.75) if s == 2 else Color("5a7572", 0.6)
		draw_rect(Rect2(-8.0, sy + 1.5, 4.0, 3.0), tab_color)
		draw_line(Vector2(-2.0, sy + 3.0), Vector2(7.0, sy + 3.0), Color("a8b2ac", 0.5), 0.8)
	
	# Upper digital status readout: "OSOBY OBCIĄŻONE: 11 / W TOKU"
	draw_rect(Rect2(-9.0, -16.5, 18.0, 3.0), Color("0d1314"))
	draw_line(Vector2(-7.0, -15.0), Vector2(7.0, -15.0), Color("75c7c3", 0.75 + pulse * 0.25), 0.8)
	
	if is_activated or is_player_in_range:
		draw_rect(cab_rect, Color("75c7c3", 0.3 + pulse * 0.3), false, 1.2)


func _draw_shadow_interactive_console() -> void:
	# Shadow interactive console with displaced cursor mechanic (D-16): 30x32 px
	var pulse := sin(_pulse_phase * 3.0) * 0.5 + 0.5
	
	# Console housing
	var housing_rect := Rect2(-15.0, -16.0, 30.0, 32.0)
	draw_rect(housing_rect, Color("121a1c"))
	draw_rect(housing_rect, Color("2d4044", 0.9), false, 1.0)
	
	# CRT Screen displaying command interface
	var screen_rect := Rect2(-12.0, -13.0, 24.0, 18.0)
	draw_rect(screen_rect, Color("0a1214"))
	draw_rect(screen_rect, Color("203336", 0.8), false, 0.8)
	
	# Top Header: "POLECENIE: NADPISZ WZORZEC"
	draw_line(Vector2(-10.0, -10.0), Vector2(6.0, -10.0), Color("68b8a5", 0.75), 0.9)
	
	# Middle Section: "OSOBY OBCIĄŻONE" list item
	draw_line(Vector2(-10.0, -5.0), Vector2(8.0, -5.0), Color("d9a05b", 0.85), 0.9)
	
	# Empty slot line (Line without name):
	draw_line(Vector2(-10.0, 0.0), Vector2(-2.0, 0.0), Color("c65d58", 0.65), 0.8)
	
	# Displaced Shadow Cursor (Cyan blinking square jumping away from command)
	var cursor_pos := Vector2(4.0, 0.0) if is_activated else Vector2(8.0, -10.0)
	var cursor_color := Color("75c7c3", 0.85 + pulse * 0.15)
	draw_rect(Rect2(cursor_pos.x - 1.5, cursor_pos.y - 1.5, 3.0, 3.0), cursor_color)
	
	# Ghost cursor displacement trail / interference rings
	if is_activated or is_player_in_range:
		draw_circle(cursor_pos, 3.5 + pulse * 2.0, Color("75c7c3", 0.35 - pulse * 0.2), false, 0.8)
		# Ghost vector arrow from command to empty slot
		draw_line(Vector2(6.0, -8.0), Vector2(4.0, -2.0), Color("d9a05b", 0.5 + pulse * 0.3), 0.8)
	
	# Lower mechanical key switches
	draw_rect(Rect2(-12.0, 8.0, 24.0, 5.0), Color("182326"))
	for k in range(5):
		var kx := -9.0 + float(k) * 4.5
		draw_rect(Rect2(kx, 9.0, 3.0, 3.0), Color("344c50"))
	
	if is_activated:
		draw_rect(housing_rect, Color("d9a05b", 0.35 + pulse * 0.35), false, 1.2)


func _draw_station_23_exit() -> void:
	# Heavy transit airlock portal leading to Space 24 (Marta under observation): 30x48 px
	var pulse := sin(_pulse_phase * 1.8) * 0.5 + 0.5
	
	# Main portal frame
	var frame_rect := Rect2(-15.0, -24.0, 30.0, 48.0)
	draw_rect(frame_rect, Color("141e20"))
	draw_rect(frame_rect, Color("2c3e42", 0.85), false, 1.2)
	
	# Heavy copper & steel door leaves
	var door_left := Rect2(-12.0, -21.0, 11.0, 42.0)
	var door_right := Rect2(1.0, -21.0, 11.0, 42.0)
	draw_rect(door_left, Color("1c2a2c"))
	draw_rect(door_right, Color("1c2a2c"))
	draw_rect(door_left, Color("344a4e", 0.6), false, 0.8)
	draw_rect(door_right, Color("344a4e", 0.6), false, 0.8)
	
	# Vertical locking seam
	draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("101618"), 1.5)
	
	# Top archive placard: "24 / OBSERWACJA — MARTA"
	draw_rect(Rect2(-11.0, -19.0, 22.0, 4.0), Color("121a1c"))
	draw_line(Vector2(-9.0, -17.0), Vector2(9.0, -17.0), Color("d4a359", 0.75), 0.8)
	
	# Observation viewport window showing surveillance CRT amber glow
	var view_rect := Rect2(-3.0, -12.0, 6.0, 12.0)
	draw_rect(view_rect, Color("0a1012"))
	draw_rect(view_rect, Color("d4a359", 0.35 if not is_activated else 0.85))
	
	if is_activated:
		# Unlocked & cycling open
		draw_rect(frame_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45 + pulse * 0.25), false, 1.5)
		draw_line(Vector2(-15.0, 24.0), Vector2(15.0, 24.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.9), 2.0)
		draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("6db3a8", 0.8), 1.0)
	else:
		# Locked / magnetic clamp active
		draw_circle(Vector2(0.0, 8.0), 1.6, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.5 + pulse * 0.3))


func _draw_cctv_surveillance_array() -> void:
	# Multi-screen CCTV surveillance video wall displaying direct feed from Apartment 14 (38x42 px)
	var pulse := sin(_pulse_phase * 2.6) * 0.5 + 0.5
	
	# Metal surveillance rack frame
	var rack_rect := Rect2(-19.0, -21.0, 38.0, 42.0)
	draw_rect(rack_rect, Color("10171a"))
	draw_rect(rack_rect, Color("22363e", 0.9), false, 1.2)
	
	# Top main surveillance monitor (Apartment 14 living room: 32x22 px)
	var main_monitor := Rect2(-16.0, -18.0, 32.0, 22.0)
	draw_rect(main_monitor, Color("081114"))
	draw_rect(main_monitor, Color("36535e", 0.85), false, 1.0)
	
	# CRT Scanlines & green-cyan phosphor raster glow
	var crt_color := Color("4f8f8b", 0.45 + pulse * 0.25)
	for y in range(5):
		var sy := -16.0 + float(y) * 4.0
		draw_line(Vector2(-14.0, sy), Vector2(14.0, sy), Color(crt_color.r, crt_color.g, crt_color.b, 0.25), 0.6)
	
	# Silhouette of Marta packing her toolbag on the table (at x=-2, y=-8)
	draw_rect(Rect2(-7.0, -10.0, 5.0, 7.0), Color("d39a62", 0.75)) # Marta's torso & amber coat
	draw_circle(Vector2(-4.5, -12.0), 2.0, Color("d39a62", 0.85)) # Marta's head
	draw_rect(Rect2(-1.0, -9.0, 4.0, 5.0), Color("8a6642", 0.85)) # Toolbag
	draw_line(Vector2(-11.0, -4.0), Vector2(8.0, -4.0), Color("56767e", 0.8), 1.2) # Table surface
	
	# Background trembling furniture / cinnabar distortion wave in Apt 14
	var stress_jitter := sin(_pulse_phase * 12.0) * 1.2
	draw_line(Vector2(4.0 + stress_jitter, -16.0), Vector2(12.0 + stress_jitter, -16.0), Color("d96b52", 0.65 + pulse * 0.35), 0.9)
	draw_line(Vector2(12.0 + stress_jitter, -16.0), Vector2(12.0, -4.0), Color("d96b52", 0.65 + pulse * 0.35), 0.9)
	
	# Timestamp & Camera ID: "CAM-14: MIESZKANIE 14 / LIVE"
	draw_rect(Rect2(-14.0, -17.0, 10.0, 2.0), Color("d96b52", 0.85 + pulse * 0.15))
	
	# Two lower auxiliary telemetry monitors (Left: Signal strength, Right: Spatial variance)
	var aux_left := Rect2(-16.0, 6.0, 15.0, 12.0)
	var aux_right := Rect2(1.0, 6.0, 15.0, 12.0)
	draw_rect(aux_left, Color("081114"))
	draw_rect(aux_right, Color("081114"))
	draw_rect(aux_left, Color("2d4650", 0.7), false, 0.8)
	draw_rect(aux_right, Color("2d4650", 0.7), false, 0.8)
	
	# Aux waveforms
	draw_line(Vector2(-14.0, 12.0), Vector2(-10.0, 9.0), Color("4f8f8b", 0.7), 0.8)
	draw_line(Vector2(-10.0, 9.0), Vector2(-6.0, 15.0), Color("4f8f8b", 0.7), 0.8)
	draw_line(Vector2(-6.0, 15.0), Vector2(-3.0, 12.0), Color("4f8f8b", 0.7), 0.8)
	
	# Cinnabar variance spike
	draw_line(Vector2(3.0, 14.0), Vector2(7.0, 8.0), Color("d96b52", 0.8), 1.0)
	draw_line(Vector2(7.0, 8.0), Vector2(11.0, 15.0), Color("d96b52", 0.8), 1.0)
	draw_line(Vector2(11.0, 15.0), Vector2(14.0, 11.0), Color("d96b52", 0.8), 1.0)
	
	if is_activated or is_player_in_range:
		draw_rect(rack_rect, Color("4f8f8b", 0.4 + pulse * 0.3), false, 1.2)


func _draw_correction_accumulation_gauge() -> void:
	# Telemetric gauge indicating accumulation of correction stress around Marta (26x32 px)
	var pulse := sin(_pulse_phase * 3.5) * 0.5 + 0.5
	
	# Cast iron gauge console body
	var body_rect := Rect2(-13.0, -16.0, 26.0, 32.0)
	draw_rect(body_rect, Color("141e24"))
	draw_rect(body_rect, Color("2a3e47", 0.9), false, 1.0)
	
	# Circular dial window (Radius = 9 px at center y=-4)
	var dial_center := Vector2(0.0, -4.0)
	draw_circle(dial_center, 9.5, Color("0b1316"))
	draw_circle(dial_center, 9.5, Color("344f5a"), false, 1.0)
	
	# Green/Amber safe sector (left) and Cinnabar critical sector (right)
	draw_arc(dial_center, 7.5, PI * 0.8, PI * 1.5, 8, Color("4f8f8b", 0.7), 1.2)
	draw_arc(dial_center, 7.5, PI * 1.5, PI * 2.2, 8, Color("d96b52", 0.85 + pulse * 0.15), 1.5)
	
	# Gauge Needle: Deflected into critical cinnabar sector (Angle ~ PI * 1.85)
	var needle_angle := PI * 1.80 + sin(_pulse_phase * 5.0) * 0.12
	var needle_tip := dial_center + Vector2(cos(needle_angle), sin(needle_angle)) * 7.5
	draw_line(dial_center, needle_tip, Color("d96b52" if is_activated else "e2b060"), 1.2)
	draw_circle(dial_center, 2.0, Color("e2b060"))
	
	# Lower status indicator LED & placard: "KOREKTA M14 / 84% NAPRĘŻENIE"
	draw_rect(Rect2(-10.0, 8.0, 20.0, 4.0), Color("091012"))
	draw_circle(Vector2(-6.0, 10.0), 1.5, Color("d96b52", 0.9 + pulse * 0.1))
	draw_line(Vector2(-2.0, 10.0), Vector2(8.0, 10.0), Color("d96b52", 0.75), 0.8)
	
	if is_activated or is_player_in_range:
		draw_rect(body_rect, Color("d96b52", 0.35 + pulse * 0.35), false, 1.2)


func _draw_wierzbicka_transmission_terminal() -> void:
	# Interactive video/audio transmission terminal with Dr Helena Wierzbicka (32x36 px)
	var pulse := sin(_pulse_phase * 2.2) * 0.5 + 0.5
	
	# Workstation casing
	var housing_rect := Rect2(-16.0, -18.0, 32.0, 36.0)
	draw_rect(housing_rect, Color("11191d"))
	draw_rect(housing_rect, Color("263a43", 0.9), false, 1.0)
	
	# Video screen with Wierzbicka's silhouette & transmission overlay (26x18 px)
	var screen_rect := Rect2(-13.0, -15.0, 26.0, 18.0)
	draw_rect(screen_rect, Color("081014"))
	draw_rect(screen_rect, Color("35505b", 0.8), false, 0.8)
	
	# Dr Wierzbicka profile silhouette in transmission feed (x=0, y=-6)
	var profile_color := Color("4f8f8b", 0.85) if not is_activated else Color("75c7c3", 0.95)
	draw_circle(Vector2(0.0, -9.0), 3.0, profile_color) # Head
	draw_rect(Rect2(-4.5, -6.0, 9.0, 6.0), profile_color) # Shoulders & collar
	
	# Horizontal transmission scanlines & audio waveform overlay
	for y in range(4):
		var wy := -14.0 + float(y) * 4.5
		draw_line(Vector2(-12.0, wy), Vector2(12.0, wy), Color(profile_color.r, profile_color.g, profile_color.b, 0.2), 0.6)
	
	# Audio VU meter bar (bottom of screen)
	draw_line(Vector2(-11.0, 1.0), Vector2(6.0, 1.0), Color("e2b060", 0.75 + pulse * 0.25), 1.0)
	draw_circle(Vector2(9.0, 1.0), 1.2, Color("d96b52", 0.8)) # Peak overload LED
	
	# Lower audio intercom grill & microphone slot
	var grill_rect := Rect2(-12.0, 6.0, 24.0, 8.0)
	draw_rect(grill_rect, Color("18252a"))
	for g in range(4):
		var gx := -9.0 + float(g) * 6.0
		draw_line(Vector2(gx, 8.0), Vector2(gx, 12.0), Color("0b1214"), 1.2)
	
	# Transmit indicator lamp: "UCP-P6 / WIERZBICKA_H"
	draw_circle(Vector2(11.0, -15.0), 1.4, Color("e2b060", 0.9 + pulse * 0.1))
	
	if is_activated or is_player_in_range:
		draw_rect(housing_rect, Color("75c7c3", 0.35 + pulse * 0.35), false, 1.2)


func _draw_lena_disposition_selector() -> void:
	# 3-Choice disposition console for Lena (ZGODA / POZORNA / ODMOWA): 34x32 px
	var pulse := sin(_pulse_phase * 2.8) * 0.5 + 0.5
	
	# Slanted steel control console
	var console_rect := Rect2(-17.0, -16.0, 34.0, 32.0)
	draw_rect(console_rect, Color("131c21"))
	draw_rect(console_rect, Color("2b414a", 0.9), false, 1.0)
	
	# Console title banner: "DYSPOZYCJA WZORCA: LENA WOLSKA"
	draw_rect(Rect2(-14.0, -14.0, 28.0, 4.0), Color("0a1215"))
	draw_line(Vector2(-12.0, -12.0), Vector2(12.0, -12.0), Color("e2b060", 0.75), 0.8)
	
	# 3 Illuminated Mechanical Push-Buttons:
	# 1: ZGODA JAWNA (Left: Amber/Green)
	var btn_1 := Rect2(-13.0, -6.0, 7.0, 10.0)
	draw_rect(btn_1, Color("1a292e"))
	draw_rect(btn_1, Color("4f8f8b", 0.8), false, 0.8)
	draw_circle(Vector2(-9.5, -1.0), 1.8, Color("4f8f8b", 0.9))
	
	# 2: POZORNA WSPÓŁPRACA (Center: Amber/Cyan)
	var btn_2 := Rect2(-3.5, -6.0, 7.0, 10.0)
	draw_rect(btn_2, Color("1a292e"))
	draw_rect(btn_2, Color("e2b060", 0.8), false, 0.8)
	draw_circle(Vector2(0.0, -1.0), 1.8, Color("e2b060", 0.9))
	
	# 3: JAWNA ODMOWA (Right: Cinnabar)
	var btn_3 := Rect2(6.0, -6.0, 7.0, 10.0)
	draw_rect(btn_3, Color("1a292e"))
	draw_rect(btn_3, Color("d96b52", 0.8), false, 0.8)
	draw_circle(Vector2(9.5, -1.0), 1.8, Color("d96b52", 0.9))
	
	# Lower status bar: Decision register latch readout
	draw_rect(Rect2(-13.0, 7.0, 26.0, 5.0), Color("0a1215"))
	var active_color := Color("75c7c3", 0.85 + pulse * 0.15) if is_activated else Color("56767e", 0.6)
	draw_line(Vector2(-10.0, 9.5), Vector2(10.0, 9.5), active_color, 1.0)
	
	if is_activated or is_player_in_range:
		draw_rect(console_rect, Color("e2b060", 0.35 + pulse * 0.35), false, 1.2)


func _draw_station_24_exit() -> void:
	# Heavy transit airlock portal leading to Space 25 (Wejście Jakuba): 30x48 px
	var pulse := sin(_pulse_phase * 1.8) * 0.5 + 0.5
	
	# Main portal frame
	var frame_rect := Rect2(-15.0, -24.0, 30.0, 48.0)
	draw_rect(frame_rect, Color("12191d"))
	draw_rect(frame_rect, Color("283b43", 0.85), false, 1.2)
	
	# Heavy steel door leaves
	var door_left := Rect2(-12.0, -21.0, 11.0, 42.0)
	var door_right := Rect2(1.0, -21.0, 11.0, 42.0)
	draw_rect(door_left, Color("182428"))
	draw_rect(door_right, Color("182428"))
	draw_rect(door_left, Color("30464f", 0.6), false, 0.8)
	draw_rect(door_right, Color("30464f", 0.6), false, 0.8)
	
	# Vertical locking seam
	draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("0d1417"), 1.5)
	
	# Top archive placard: "25 / TRANZYT — WEJŚCIE JAKUBA"
	draw_rect(Rect2(-12.0, -19.0, 24.0, 4.0), Color("10161a"))
	draw_line(Vector2(-10.0, -17.0), Vector2(10.0, -17.0), Color("e2b060", 0.75), 0.8)
	
	# Observation viewport window
	var view_rect := Rect2(-3.0, -12.0, 6.0, 12.0)
	draw_rect(view_rect, Color("081013"))
	draw_rect(view_rect, Color("4f8f8b", 0.35 if not is_activated else 0.9))
	
	if is_activated:
		# Unlocked & cycling open
		draw_rect(frame_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45 + pulse * 0.25), false, 1.5)
		draw_line(Vector2(-15.0, 24.0), Vector2(15.0, 24.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.9), 2.0)
		draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("75c7c3", 0.8), 1.0)
	else:
		# Locked / magnetic clamp active
		draw_circle(Vector2(0.0, 8.0), 1.6, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.5 + pulse * 0.3))


func _draw_jakub_operator_ucp() -> void:
	# Jakub Wolski in UCP Line 4 technician / operator jumpsuit (32x48 px)
	var pulse := sin(_pulse_phase * 2.2) * 0.5 + 0.5
	var breath := sin(_pulse_phase * 1.6) * 1.0
	
	if is_activated:
		# Jakub sitting on the floor per D-09 didascalia ("Jakub siada na podłodze. Nie patrzy na Lenę.")
		# Body sitting (x=0, y=0..12)
		draw_rect(Rect2(-10.0, -2.0, 20.0, 14.0), Color("17242c")) # Sitting torso & legs
		draw_rect(Rect2(-10.0, -2.0, 20.0, 14.0), Color("2b3e48"), false, 1.0)
		
		# Torso & technician jacket with safety harness
		draw_rect(Rect2(-7.0, -12.0 + breath * 0.5, 14.0, 11.0), Color("1c2b34"))
		draw_line(Vector2(-3.0, -12.0 + breath * 0.5), Vector2(-3.0, -1.0 + breath * 0.5), Color("d39a62", 0.8), 1.2)
		draw_line(Vector2(3.0, -12.0 + breath * 0.5), Vector2(3.0, -1.0 + breath * 0.5), Color("d39a62", 0.8), 1.2)
		
		# Head tilted downward / looking away (per D-09)
		draw_circle(Vector2(0.0, -17.0 + breath * 0.5), 4.5, Color("d4a373"))
		draw_arc(Vector2(0.0, -18.0 + breath * 0.5), 4.6, PI * 0.9, PI * 2.1, 8, Color("1a2024"), 2.2) # Hair
		
		# Operator ID badge & radio on harness
		draw_rect(Rect2(-6.0, -8.0 + breath * 0.5, 4.0, 3.0), Color("e2b060"))
		draw_rect(Rect2(3.0, -10.0 + breath * 0.5, 3.0, 5.0), Color("0d1417"))
	else:
		# Standing Jakub operator posturing defensively
		# Work boots
		draw_rect(Rect2(-6.0, 16.0, 5.0, 4.0), Color("111619"))
		draw_rect(Rect2(1.0, 16.0, 5.0, 4.0), Color("111619"))
		
		# Heavy technician trousers
		draw_rect(Rect2(-6.0, 2.0, 5.0, 14.0), Color("17242c"))
		draw_rect(Rect2(1.0, 2.0, 5.0, 14.0), Color("17242c"))
		
		# Torso & heavy canvas jacket
		var torso_rect := Rect2(-8.0, -14.0 + breath * 0.5, 16.0, 16.0)
		draw_rect(torso_rect, Color("1c2b34"))
		draw_rect(torso_rect, Color("2d414c"), false, 1.0)
		
		# Yellow/Amber UCP transit harness straps
		draw_line(Vector2(-4.0, -14.0 + breath * 0.5), Vector2(-4.0, 2.0 + breath * 0.5), Color("d39a62", 0.85), 1.5)
		draw_line(Vector2(4.0, -14.0 + breath * 0.5), Vector2(4.0, 2.0 + breath * 0.5), Color("d39a62", 0.85), 1.5)
		draw_line(Vector2(-8.0, -6.0 + breath * 0.5), Vector2(8.0, -6.0 + breath * 0.5), Color("d39a62", 0.75), 1.2)
		
		# Operator ID badge on chest
		draw_rect(Rect2(-6.5, -11.0 + breath * 0.5, 5.0, 3.0), Color("e2b060"))
		
		# Head and facial profile
		draw_circle(Vector2(0.0, -19.0 + breath * 0.5), 5.0, Color("d4a373"))
		draw_arc(Vector2(0.0, -20.5 + breath * 0.5), 5.2, PI * 0.85, PI * 2.15, 8, Color("1a2024"), 2.5) # Hair
		
		# Flashlight holster on hip
		draw_rect(Rect2(8.0, -2.0, 3.0, 8.0), Color("0e161a"))
		draw_circle(Vector2(9.5, -2.0), 1.2, Color("75c7c3", 0.8))
	
	if is_player_in_range or is_activated:
		draw_circle(Vector2(0.0, -28.0), 2.5, Color("e2b060", 0.8 + pulse * 0.2))


func _draw_transit_maintenance_cart() -> void:
	# Heavy Line 4 maintenance cart on steel rails (40x26 px)
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	
	# Steel platform chassis
	var platform := Rect2(-20.0, -4.0, 40.0, 10.0)
	draw_rect(platform, Color("1e2c34"))
	draw_rect(platform, Color("344b58"), false, 1.0)
	
	# Warning chevron stripes along bumper
	for c in range(6):
		var cx := -18.0 + float(c) * 6.5
		draw_line(Vector2(cx, -3.0), Vector2(cx + 4.0, 5.0), Color("d39a62", 0.8), 1.2)
	
	# 4 Flanged steel railway wheels resting on rail profile
	draw_circle(Vector2(-14.0, 9.0), 4.5, Color("121b20"))
	draw_circle(Vector2(-14.0, 9.0), 4.5, Color("4a6d7c"), false, 1.0)
	draw_circle(Vector2(14.0, 9.0), 4.5, Color("121b20"))
	draw_circle(Vector2(14.0, 9.0), 4.5, Color("4a6d7c"), false, 1.0)
	
	# Tool crate and cable spool on cart
	var crate_rect := Rect2(-17.0, -14.0, 14.0, 10.0)
	draw_rect(crate_rect, Color("141e24"))
	draw_rect(crate_rect, Color("a8b2ac", 0.6), false, 0.8)
	
	# Cable spool with copper/amber wiring
	draw_circle(Vector2(7.0, -9.0), 6.0, Color("10181d"))
	draw_circle(Vector2(7.0, -9.0), 4.5, Color("d39a62", 0.85))
	draw_circle(Vector2(7.0, -9.0), 2.0, Color("10181d"))
	
	# Rail maintenance lantern (glows amber)
	draw_rect(Rect2(-2.0, -18.0, 5.0, 8.0), Color("0d1418"))
	draw_rect(Rect2(-1.5, -16.0, 4.0, 4.0), Color("e2b060", 0.9 + pulse * 0.1))
	
	if is_player_in_range or is_activated:
		draw_rect(platform, Color("75c7c3", 0.35 + pulse * 0.35), false, 1.2)


func _draw_scar_diagnostic_chart() -> void:
	# Illuminated diagnostic clipboard showing Line 4 accident & glass shard scar beneath left rib (26x34 px)
	var pulse := sin(_pulse_phase * 2.5) * 0.5 + 0.5
	
	# Backing board
	var board_rect := Rect2(-13.0, -17.0, 26.0, 34.0)
	draw_rect(board_rect, Color("11181d"))
	draw_rect(board_rect, Color("2d434e"), false, 1.0)
	
	# Paper sheet
	var paper_rect := Rect2(-11.0, -14.0, 22.0, 28.0)
	draw_rect(paper_rect, Color("202d36"))
	
	# Anatomical torso silhouette outline
	draw_arc(Vector2(0.0, -8.0), 4.0, 0.0, TAU, 8, Color("4a6d7c", 0.7), 1.0) # Chest outline
	draw_rect(Rect2(-5.0, -4.0, 10.0, 12.0), Color("17232b"))
	draw_rect(Rect2(-5.0, -4.0, 10.0, 12.0), Color("4a6d7c", 0.6), false, 0.8)
	
	# Scar location marker under left rib (cinnabar #c65d58 cross & callout line)
	var scar_pos := Vector2(3.0, 1.0)
	draw_line(scar_pos + Vector2(-2.5, -1.0), scar_pos + Vector2(2.5, 1.0), Color("c65d58", 0.95), 1.5)
	draw_circle(scar_pos, 1.5, Color("d96b52", 0.9 + pulse * 0.1))
	
	# Callout measurement line to margin: "SZKŁO / LINIA 4 / ŻEBRO LEWE"
	draw_line(scar_pos, Vector2(9.0, 1.0), Color("c65d58", 0.8), 0.8)
	draw_line(Vector2(9.0, 1.0), Vector2(9.0, 6.0), Color("c65d58", 0.8), 0.8)
	
	# Header clamp & text lines
	draw_rect(Rect2(-6.0, -17.0, 12.0, 3.0), Color("d39a62"))
	draw_line(Vector2(-9.0, -11.0), Vector2(9.0, -11.0), Color("e2b060", 0.7), 0.8)
	
	if is_player_in_range or is_activated:
		draw_rect(board_rect, Color("c65d58", 0.35 + pulse * 0.35), false, 1.2)


func _draw_jakub_hand_gesture_sensor() -> void:
	# Hand movement pattern analysis terminal (turning ring vs cutting finger on edge): 30x28 px
	var pulse := sin(_pulse_phase * 2.6) * 0.5 + 0.5
	
	# Terminal housing
	var housing_rect := Rect2(-15.0, -14.0, 30.0, 28.0)
	draw_rect(housing_rect, Color("121a20"))
	draw_rect(housing_rect, Color("2d434e"), false, 1.0)
	
	# Header placard: "ANALIZA GESTU DŁONI"
	draw_rect(Rect2(-12.0, -12.0, 24.0, 4.0), Color("091013"))
	draw_line(Vector2(-10.0, -10.0), Vector2(10.0, -10.0), Color("e2b060", 0.75), 0.8)
	
	# Left Sensor Panel: Ring Rotation (local Lena pattern)
	var left_panel := Rect2(-12.0, -6.0, 10.0, 12.0)
	draw_rect(left_panel, Color("17232b"))
	draw_rect(left_panel, Color("4a6d7c", 0.6), false, 0.8)
	draw_arc(Vector2(-7.0, 0.0), 3.0, 0.0, TAU, 8, Color("e2b060", 0.8), 1.0)
	
	# Right Sensor Panel: Sharp Edge & Finger Cut (protagonist Lena pattern)
	var right_panel := Rect2(2.0, -6.0, 10.0, 12.0)
	draw_rect(right_panel, Color("17232b"))
	draw_rect(right_panel, Color("4a6d7c", 0.6), false, 0.8)
	draw_line(Vector2(4.0, -4.0), Vector2(10.0, 4.0), Color("a8b2ac"), 1.2) # Sharp blade edge
	draw_line(Vector2(5.0, 1.0), Vector2(9.0, -3.0), Color("c65d58", 0.9 + pulse * 0.1), 1.5) # Cut trace
	
	# Bottom comparator indicator
	draw_rect(Rect2(-12.0, 8.0, 24.0, 4.0), Color("091013"))
	var indicator_pos := Vector2(7.0 if is_activated else -7.0, 10.0)
	draw_circle(indicator_pos, 1.5, Color("d96b52" if is_activated else "e2b060"))
	
	if is_player_in_range or is_activated:
		draw_rect(housing_rect, Color("e2b060", 0.35 + pulse * 0.35), false, 1.2)


func _draw_station_25_exit() -> void:
	# Heavy transit service portal leading to Space 26 (Próba zamknięcia / strefa izolacji): 32x48 px
	var pulse := sin(_pulse_phase * 1.8) * 0.5 + 0.5
	
	# Frame
	var frame_rect := Rect2(-16.0, -24.0, 32.0, 48.0)
	draw_rect(frame_rect, Color("121a20"))
	draw_rect(frame_rect, Color("2d434e", 0.85), false, 1.2)
	
	# Sliding door panels
	var door_left := Rect2(-13.0, -21.0, 12.0, 42.0)
	var door_right := Rect2(1.0, -21.0, 12.0, 42.0)
	draw_rect(door_left, Color("19252c"))
	draw_rect(door_right, Color("19252c"))
	draw_rect(door_left, Color("344f5b", 0.6), false, 0.8)
	draw_rect(door_right, Color("344f5b", 0.6), false, 0.8)
	
	# Center locking seam & rubber seal
	draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("091014"), 1.5)
	
	# Top archive placard: "26 / STREFA IZOLACJI — PRÓBA ZAMKNIĘCIA"
	draw_rect(Rect2(-13.0, -19.0, 26.0, 4.0), Color("0d1519"))
	draw_line(Vector2(-11.0, -17.0), Vector2(11.0, -17.0), Color("e2b060", 0.75), 0.8)
	
	# Viewport window with amber/cyan transit lumination
	var view_rect := Rect2(-4.0, -12.0, 8.0, 12.0)
	draw_rect(view_rect, Color("081014"))
	draw_rect(view_rect, Color("4a6d7c", 0.35 if not is_activated else 0.95))
	
	if is_activated:
		# Unlocked & cycling open
		draw_rect(frame_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45 + pulse * 0.25), false, 1.5)
		draw_line(Vector2(-16.0, 24.0), Vector2(16.0, 24.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.9), 2.0)
		draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("75c7c3", 0.8), 1.0)
	else:
		# Locked / magnetic clamp active
		draw_circle(Vector2(0.0, 8.0), 1.6, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.5 + pulse * 0.3))


func _draw_isolation_zone_console() -> void:
	# Diagnostic console monitoring gentle isolation status in Podstructure (32x28 px)
	var pulse := sin(_pulse_phase * 2.2) * 0.5 + 0.5
	
	# Terminal housing
	var housing_rect := Rect2(-16.0, -14.0, 32.0, 28.0)
	draw_rect(housing_rect, Color("10171a"))
	draw_rect(housing_rect, Color("2b3e48"), false, 1.0)
	
	# CRT scope monitor (24x14 px)
	var crt_rect := Rect2(-12.0, -11.0, 24.0, 14.0)
	draw_rect(crt_rect, Color("122024"))
	draw_rect(crt_rect, Color("3d5a65", 0.7), false, 0.8)
	
	# Spatial pressure & damping waveform
	for x in range(20):
		var fx := -10.0 + float(x)
		var wy := sin((fx + _pulse_phase * 4.0) * 0.5) * 3.5
		draw_line(Vector2(fx, -4.0 + wy), Vector2(fx + 1.0, -4.0 + wy), Color("5da398", 0.85), 1.2)
	
	# Status indicator badge: "IZOLACJA ADAPTACYJNA"
	draw_rect(Rect2(-12.0, 5.0, 24.0, 5.0), Color("091013"))
	draw_line(Vector2(-10.0, 7.5), Vector2(10.0, 7.5), Color("c8a370", 0.8), 0.8)
	
	# Status LED (blinks cyan / amber)
	var led_color := Color("5da398", 0.9 + pulse * 0.1) if is_activated else Color("d39a62", 0.8)
	draw_circle(Vector2(10.0, -8.0), 1.5, led_color)
	
	if is_player_in_range or is_activated:
		draw_rect(housing_rect, Color("5da398", 0.35 + pulse * 0.35), false, 1.2)


func _draw_dynamic_room_designator() -> void:
	# Modular room function indicator panel: MIESZKALNY -> ARCHIWUM -> SEDACJA (28x32 px)
	var pulse := sin(_pulse_phase * 2.4) * 0.5 + 0.5
	
	# Backing plate & mounting bracket
	var plate_rect := Rect2(-14.0, -16.0, 28.0, 32.0)
	draw_rect(plate_rect, Color("131c21"))
	draw_rect(plate_rect, Color("2e424c"), false, 1.0)
	
	# Function readout placard
	var placard_rect := Rect2(-11.0, -13.0, 22.0, 18.0)
	draw_rect(placard_rect, Color("0b1215"))
	draw_rect(placard_rect, Color("3d5a65", 0.6), false, 0.8)
	
	# Split-flap indicator lines / dynamic state designation
	var line_color := Color("c8a370") if not is_activated else Color("5da398")
	draw_line(Vector2(-9.0, -8.0), Vector2(9.0, -8.0), line_color, 1.0)
	draw_line(Vector2(-9.0, -3.0), Vector2(9.0, -3.0), line_color * 0.8, 0.8)
	draw_line(Vector2(-9.0, 2.0), Vector2(6.0, 2.0), line_color * 0.6, 0.8)
	
	# Reconfiguration mode indicator lamps
	var lamp_y := 9.0
	draw_circle(Vector2(-7.0, lamp_y), 1.8, Color("5da398", 0.9 if is_activated else 0.3)) # Mode 1
	draw_circle(Vector2(0.0, lamp_y), 1.8, Color("c8a370", 0.9 if not is_activated else 0.3)) # Mode 2
	draw_circle(Vector2(7.0, lamp_y), 1.8, Color("c65d58", 0.4 + pulse * 0.3)) # Reconfig alert
	
	if is_player_in_range or is_activated:
		draw_rect(plate_rect, Color("c8a370", 0.35 + pulse * 0.35), false, 1.2)


func _draw_motivation_anchor_record() -> void:
	# Reinforced wall slab with Lena's handwritten anchor inscription (36x24 px)
	var pulse := sin(_pulse_phase * 2.8) * 0.5 + 0.5
	
	# Wall slab base
	var slab_rect := Rect2(-18.0, -12.0, 36.0, 24.0)
	draw_rect(slab_rect, Color("151e23"))
	draw_rect(slab_rect, Color("344b56"), false, 1.0)
	
	# Deep carved anchor inscription traces ("PAMIĘTAM DLACZEGO PRZYSZŁAM")
	var cinnabar := Color("c65d58", 0.9 + pulse * 0.1)
	var amber_glow := Color("e2b060", 0.85)
	
	draw_line(Vector2(-14.0, -7.0), Vector2(14.0, -7.0), amber_glow, 1.2) # Line 1: PAMIĘTAM
	draw_line(Vector2(-14.0, -2.0), Vector2(12.0, -2.0), cinnabar, 1.4)   # Line 2: DLACZEGO PRZYSZŁAM
	draw_line(Vector2(-14.0, 3.0), Vector2(10.0, 3.0), amber_glow, 1.2)   # Line 3: NIE JESTEM ADAPTACJĄ
	
	# Chisel score mark & stylus point stuck in composite joint
	draw_line(Vector2(11.0, 2.0), Vector2(15.0, 8.0), Color("a8b2ac"), 1.8) # Steel stylus
	draw_circle(Vector2(15.0, 8.0), 1.5, Color("d39a62")) # Brass handle
	
	# Resistance anchor glow perimeter
	if is_activated or is_player_in_range:
		draw_rect(slab_rect, Color("c65d58", 0.40 + pulse * 0.30), false, 1.5)
		draw_circle(Vector2(0.0, -16.0), 2.2, Color("e2b060", 0.9))


func _draw_wierzbicka_pa_speaker() -> void:
	# Institutional PA wall intercom horn / speaker grille (24x28 px)
	var pulse := sin(_pulse_phase * 3.0) * 0.5 + 0.5
	
	# Speaker enclosure
	var enc_rect := Rect2(-12.0, -14.0, 24.0, 28.0)
	draw_rect(enc_rect, Color("141d22"))
	draw_rect(enc_rect, Color("2d414c"), false, 1.0)
	
	# Slotted circular speaker mesh
	draw_circle(Vector2(0.0, -2.0), 8.0, Color("0b1215"))
	draw_circle(Vector2(0.0, -2.0), 8.0, Color("3d5a65", 0.7), false, 0.8)
	
	# Grille louvres
	for l in range(4):
		var ly := -6.0 + float(l) * 2.8
		draw_line(Vector2(-5.0, ly), Vector2(5.0, ly), Color("2e434f"), 1.0)
	
	# Top broadcasting LED indicator
	var led_col := Color("e2b060", 0.95) if is_activated else Color("3d5a65", 0.5)
	draw_circle(Vector2(0.0, -10.5), 1.8, led_col)
	
	# Radiating acoustic broadcast waves (when speaking/activated)
	if is_activated or is_player_in_range:
		var wave_alpha := 0.35 + pulse * 0.35
		draw_arc(Vector2(0.0, -2.0), 12.0 + pulse * 3.0, -PI * 0.35, PI * 0.35, 6, Color("5da398", wave_alpha), 1.0)
		draw_arc(Vector2(0.0, -2.0), 16.0 + pulse * 4.0, -PI * 0.30, PI * 0.30, 6, Color("5da398", wave_alpha * 0.6), 0.8)


func _draw_station_26_exit() -> void:
	# Reinforced isolation transit portal leading to Space 27 (Dług wdzięczności): 32x48 px
	var pulse := sin(_pulse_phase * 1.8) * 0.5 + 0.5
	
	# Heavy outer frame
	var frame_rect := Rect2(-16.0, -24.0, 32.0, 48.0)
	draw_rect(frame_rect, Color("11191d"))
	draw_rect(frame_rect, Color("2d434e", 0.85), false, 1.2)
	
	# Sliding door panels
	var door_left := Rect2(-13.0, -21.0, 12.0, 42.0)
	var door_right := Rect2(1.0, -21.0, 12.0, 42.0)
	draw_rect(door_left, Color("18232a"))
	draw_rect(door_right, Color("18232a"))
	draw_rect(door_left, Color("36505c", 0.6), false, 0.8)
	draw_rect(door_right, Color("36505c", 0.6), false, 0.8)
	
	# Center sealing seam
	draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("091014"), 1.5)
	
	# Top archive placard: "27 / PRZEJŚCIE SERWISOWE — DŁUG WDZIĘCZNOŚCI"
	draw_rect(Rect2(-13.0, -19.0, 26.0, 4.0), Color("0d1519"))
	draw_line(Vector2(-11.0, -17.0), Vector2(11.0, -17.0), Color("c8a370", 0.75), 0.8)
	
	# Viewport window
	var view_rect := Rect2(-4.0, -12.0, 8.0, 12.0)
	draw_rect(view_rect, Color("081014"))
	draw_rect(view_rect, Color("5da398", 0.35 if not is_activated else 0.95))
	
	if is_activated:
		# Unlocked & cycling open toward Space 27
		draw_rect(frame_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45 + pulse * 0.25), false, 1.5)
		draw_line(Vector2(-16.0, 24.0), Vector2(16.0, 24.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.9), 2.0)
		draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("5da398", 0.8), 1.0)
	else:
		# Locked / magnetic clamp active
		draw_circle(Vector2(0.0, 8.0), 1.6, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.5 + pulse * 0.3))


func _draw_jakub_service_operator() -> void:
	# Jakub Wolski as UCP service operator: 20x36 px silhouette holding keycard
	var pulse := sin(_pulse_phase * 2.2) * 0.5 + 0.5
	
	# Head with dark hair
	draw_circle(Vector2(0.0, -14.0), 4.5, Color("352e28"))
	draw_circle(Vector2(0.0, -13.0), 3.8, Color("d0b296"))
	
	# Dark grey UCP technician jacket / work overalls with orange reflective harness
	var torso_rect := Rect2(-5.5, -9.0, 11.0, 15.0)
	draw_rect(torso_rect, Color("202a30"))
	draw_rect(torso_rect, Color("32434d"), false, 0.8)
	
	# Reflective high-visibility harness straps (amber-orange)
	draw_line(Vector2(-4.0, -9.0), Vector2(-1.5, 4.0), Color("e29b42", 0.9), 1.2)
	draw_line(Vector2(4.0, -9.0), Vector2(1.5, 4.0), Color("e29b42", 0.9), 1.2)
	draw_line(Vector2(-4.5, -2.0), Vector2(4.5, -2.0), Color("e29b42", 0.9), 1.2)
	
	# Legs and heavy work boots
	var leg_left := Rect2(-5.0, 6.0, 4.0, 12.0)
	var leg_right := Rect2(1.0, 6.0, 4.0, 12.0)
	draw_rect(leg_left, Color("171f24"))
	draw_rect(leg_right, Color("171f24"))
	draw_rect(Rect2(-5.5, 16.0, 4.5, 3.0), Color("0d1215"))
	draw_rect(Rect2(0.5, 16.0, 4.5, 3.0), Color("0d1215"))
	
	# Right arm extended with magnetic keycard
	draw_line(Vector2(5.0, -6.0), Vector2(10.0, -1.0), Color("d0b296"), 1.8)
	var card_rect := Rect2(9.0, -4.0, 5.0, 7.0)
	draw_rect(card_rect, Color("dbe4e8"))
	draw_line(Vector2(10.0, -1.0), Vector2(13.0, -1.0), Color("202a30"), 1.0)
	
	# Glow on keycard when activated
	if is_activated or is_player_in_range:
		draw_circle(Vector2(11.5, -0.5), 3.0 + pulse * 1.5, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.4 + pulse * 0.3))


func _draw_saved_worker_badge() -> void:
	# UCP Identification & Saved Worker Badge: 18x24 px
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	var badge_rect := Rect2(-9.0, -12.0, 18.0, 24.0)
	
	# Laminated plastic casing
	draw_rect(badge_rect, Color("141e24"))
	draw_rect(badge_rect, Color("3d5a65", 0.8), false, 1.0)
	
	# Lanyard clip at top
	draw_rect(Rect2(-2.5, -15.0, 5.0, 3.0), Color("4a6270"))
	draw_circle(Vector2(0.0, -13.5), 1.2, Color("0e161a"))
	
	# ID Photo box (miniature face portrait)
	var photo_box := Rect2(-7.0, -10.0, 8.0, 9.0)
	draw_rect(photo_box, Color("263740"))
	draw_circle(Vector2(-3.0, -6.0), 2.2, Color("d0b296"))
	
	# Text lines & barcode
	draw_line(Vector2(3.0, -9.0), Vector2(7.0, -9.0), Color("e2b060", 0.8), 0.8)
	draw_line(Vector2(3.0, -6.0), Vector2(7.0, -6.0), Color("c8a370", 0.6), 0.8)
	draw_line(Vector2(-7.0, 1.0), Vector2(7.0, 1.0), Color("5da398", 0.75), 0.8)
	
	# Red badge status stamp: "STATUS: OCALONY / 12 LAT"
	draw_rect(Rect2(-7.0, 3.5, 14.0, 6.0), Color("3d1c1a", 0.7))
	draw_line(Vector2(-6.0, 6.5), Vector2(6.0, 6.5), Color("c65d58", 0.9), 1.0)
	
	if is_activated:
		draw_rect(badge_rect, Color("e2b060", 0.35 + pulse * 0.25), false, 1.2)


func _draw_surface_stability_monitor() -> void:
	# Surface Stability CRT Scope: 26x20 px
	var pulse := sin(_pulse_phase * 3.0) * 0.5 + 0.5
	var mon_rect := Rect2(-13.0, -10.0, 26.0, 20.0)
	
	# Industrial steel housing
	draw_rect(mon_rect, Color("12191d"))
	draw_rect(mon_rect, Color("344953"), false, 1.0)
	
	# Dark CRT screen
	var screen_rect := Rect2(-11.0, -8.0, 22.0, 14.0)
	draw_rect(screen_rect, Color("091216"))
	
	# Dual oscillating surface strain waveforms (contradictory histories causing surface stress)
	var col_wave := Color("c65d58", 0.85) if is_activated else Color("d39a62", 0.65)
	for i in range(5):
		var x1 := -9.0 + float(i) * 3.5
		var x2 := x1 + 3.5
		var y1 := -1.0 + sin((_pulse_phase + float(i)) * 1.5) * 4.0
		var y2 := -1.0 + sin((_pulse_phase + float(i + 1)) * 1.5) * 4.0
		draw_line(Vector2(x1, y1), Vector2(x2, y2), col_wave, 1.0)
	
	# Warning LED bank at bottom
	var led_warn := Color("c65d58", 0.9 if pulse > 0.4 else 0.2)
	draw_circle(Vector2(-7.0, 8.0), 1.2, led_warn)
	draw_circle(Vector2(-3.0, 8.0), 1.2, Color("e2b060", 0.8))
	draw_circle(Vector2(1.0, 8.0), 1.2, Color("5da398", 0.8))
	draw_circle(Vector2(5.0, 8.0), 1.2, Color("5da398", 0.8))


func _draw_technical_junction_console() -> void:
	# Junction Track Switchboard Console: 28x22 px
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	var console_rect := Rect2(-14.0, -11.0, 28.0, 22.0)
	
	draw_rect(console_rect, Color("151e22"))
	draw_rect(console_rect, Color("3e5864"), false, 1.0)
	
	# Track route schematic lines
	draw_line(Vector2(-10.0, -5.0), Vector2(0.0, -5.0), Color("4a6b79"), 1.2)
	draw_line(Vector2(0.0, -5.0), Vector2(10.0, -9.0), Color("5da398" if is_activated else "3d5059"), 1.2)
	draw_line(Vector2(0.0, -5.0), Vector2(10.0, -1.0), Color("c65d58" if not is_activated else "3d5059"), 1.2)
	
	# Track switch indicator lamps
	var active_col := Color("5da398", 0.9) if is_activated else Color("d39a62", 0.7)
	draw_circle(Vector2(0.0, -5.0), 1.8, active_col)
	
	# Mechanical throw switch lever (tilted right when activated)
	var lever_tip := Vector2(4.0, 4.0) if is_activated else Vector2(-4.0, 4.0)
	draw_line(Vector2(0.0, 8.0), lever_tip, Color("dbe4e8"), 1.8)
	draw_circle(lever_tip, 2.0, Color("c8a370"))
	
	# Pneumatic gauge
	draw_circle(Vector2(-8.0, 6.0), 3.2, Color("0d1417"))
	draw_circle(Vector2(-8.0, 6.0), 3.2, Color("4a6b79"), false, 0.8)
	draw_line(Vector2(-8.0, 6.0), Vector2(-8.0 + sin(pulse * 2.0) * 2.0, 6.0 - cos(pulse * 2.0) * 2.0), Color("e2b060"), 0.8)


func _draw_station_27_exit() -> void:
	# Heavy industrial roll-up portal to Technical Track (Przestrzeń 28): 34x50 px
	var pulse := sin(_pulse_phase * 1.8) * 0.5 + 0.5
	var frame_rect := Rect2(-17.0, -25.0, 34.0, 50.0)
	
	# Heavy reinforced steel portal frame
	draw_rect(frame_rect, Color("0f1518"))
	draw_rect(frame_rect, Color("354e5a", 0.9), false, 1.2)
	
	# Overhead rollup spool housing
	var spool_rect := Rect2(-15.0, -23.0, 30.0, 8.0)
	draw_rect(spool_rect, Color("1a252c"))
	draw_rect(spool_rect, Color("42606e", 0.7), false, 0.8)
	draw_line(Vector2(-12.0, -19.0), Vector2(12.0, -19.0), Color("d39a62", 0.85), 1.0)
	
	# Steel shutter slats
	var num_slats := 7
	for s in range(num_slats):
		var sy := -13.0 + float(s) * 5.0
		var slat_rect := Rect2(-14.0, sy, 28.0, 4.0)
		draw_rect(slat_rect, Color("141c21") if s % 2 == 0 else Color("182329"))
		draw_rect(slat_rect, Color("2d404b", 0.5), false, 0.6)
	
	# Hazard warning stripes at bottom threshold
	for h in range(4):
		var hx := -12.0 + float(h) * 6.0
		draw_line(Vector2(hx, 22.0), Vector2(hx + 3.0, 25.0), Color("e29b42", 0.85), 1.2)
	
	# Top archive placard: "28 / SKŁAD TECHNICZNY — TRAMWAJ BEZ PASAŻERÓW"
	draw_rect(Rect2(-14.0, -13.0, 28.0, 3.5), Color("0b1013"))
	draw_line(Vector2(-12.0, -11.5), Vector2(12.0, -11.5), Color("5da398", 0.8), 0.8)
	
	if is_activated:
		# Unlocked & rolling up
		draw_rect(frame_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45 + pulse * 0.25), false, 1.5)
		draw_line(Vector2(-17.0, 25.0), Vector2(17.0, 25.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.9), 2.0)
		draw_rect(Rect2(-12.0, 5.0, 24.0, 18.0), Color("060a0c"))
		draw_line(Vector2(0.0, 8.0), Vector2(0.0, 22.0), Color("5da398", 0.75), 1.2)
	else:
		# Locked indicator
		draw_circle(Vector2(0.0, 5.0), 1.8, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.6 + pulse * 0.3))








