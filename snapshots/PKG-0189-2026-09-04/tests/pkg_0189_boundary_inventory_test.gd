extends SceneTree

## PKG-0189 — static inventory for the two residual P3 boundaries.
##
## This gate protects audited facts only. It does not extract MemoryResonancePoint,
## repair Station 10–13, or make a claim about player experience or PRODUCT GO.

const MRP_PATH := "res://scripts/interactables/memory_resonance_point.gd"
const REPORT_PATH := "res://docs/rebuild/PKG_0189_RESIDUAL_BOUNDARY_SPEC.md"
const STATION_PATHS: Array[String] = [
	"res://scripts/levels/station_10.gd",
	"res://scripts/levels/station_11.gd",
	"res://scripts/levels/station_12.gd",
	"res://scripts/levels/station_13.gd",
]

const MRP_SENTINELS := [
	"PHOTOGRAPH = 0",
	"DOOR_CARD_READER = 5",
	"STAIR_TIMER_SWITCH = 24",
	"STATION_41_EXIT = 196",
	"EPILOGUE_FINAL_BLACKOUT = 202",
]
const MRP_EXPORTS := [
	"@export var resonance_id: String",
	"@export var prop_type: PropType",
	"@export var prop_title: String",
	"@export var prop_subtitle: String",
	"@export var interaction_radius: float",
	"@export var is_activated: bool",
	"@export var is_one_shot: bool",
	"@export var shadow_progress: float",
]
const CURRENT_P9_FACTS := [
	"p9.mystery.marta.home_task_complete",
	"p9.mystery.institution.card_presented",
	"p9.mystery.jakub.control_questions_asked",
	"p9.mystery.synthesis.marta_source_seen",
]
const LEGACY_P7_NAMESPACES := [
	"p7.foreign_daily_life",
	"p7.marta_threshold",
]
const MISSING_CANONICAL_FACTS := [
	"marta_relationship_disclosed",
	"marta_memories_conflict",
	"marta_boundary_accepted",
	"local_lena_ucp_profile_found",
	"parallel_test_trace_found",
	"jakub_public_history_verified",
	"jakub_voice_heard",
	"jakub_met_as_person",
	"recognition_evidence_public",
	"recognition_evidence_relational",
	"recognition_evidence_carried",
	"local_lena_search_committed",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("PKG-0189: " + message)


func _read(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "inventory file must be readable: %s" % path)
	if file == null:
		return ""
	var source := file.get_as_text()
	file.close()
	return source


func _run() -> void:
	_check_mrp_contract()
	_check_station_hybrid_inventory()
	_check_report_inventory()
	if _failures.is_empty():
		print("PKG-0189 INVENTORY PASS: MRP and Station 10–13 residual boundaries recorded")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0189 FAILURE: " + failure)
		quit(1)


func _check_mrp_contract() -> void:
	var source := _read(MRP_PATH)
	_expect(source.contains("class_name MemoryResonancePoint"), "MRP class identity must remain inventory-visible")
	_expect(source.contains("extends Area2D"), "MRP Area2D boundary must remain inventory-visible")
	_expect(source.count("func _draw_") == 206, "MRP draw-function inventory must remain 206")
	_expect(source.count("func ") == 221, "MRP function inventory must remain 221")
	for sentinel in MRP_SENTINELS:
		_expect(source.contains(sentinel), "MRP enum sentinel missing: %s" % sentinel)
	for export_name in MRP_EXPORTS:
		_expect(source.contains(export_name), "MRP exported contract missing: %s" % export_name)
	for signal_name in ["signal resonance_triggered(id: String, prop_type: int)", "signal state_changed(is_active: bool)"]:
		_expect(source.contains(signal_name), "MRP signal contract missing: %s" % signal_name)
	for method_name in ["func get_contact_progress()", "func get_touch_flash()", "func trigger_interaction()"]:
		_expect(source.contains(method_name), "MRP public method missing: %s" % method_name)
	_expect(source.contains("game_state.collect_clue(StringName(resonance_id))"), "MRP clue-collection bridge missing")
	_expect(source.contains("const SWITCH_LIKE_PROPS"), "MRP switch-like prop grouping missing")
	_expect(not source.contains("add_to_group("), "MRP inventory must not silently replace its contract with Node groups")


func _check_station_hybrid_inventory() -> void:
	var combined := ""
	for path in STATION_PATHS:
		var source := _read(path)
		combined += source
		_expect(source.contains("func _on_prop_resonance_triggered"), "station prop bridge missing: %s" % path)
		_expect(source.contains("resonance_triggered.connect"), "station MRP signal connection missing: %s" % path)
		_expect(source.contains("clue_inspected.emit"), "station clue signal emission missing: %s" % path)
	for fact in CURRENT_P9_FACTS:
		_expect(combined.contains(fact), "current P9 writer fact missing: %s" % fact)
	for namespace_name in LEGACY_P7_NAMESPACES:
		_expect(combined.contains(namespace_name), "legacy P7 namespace unexpectedly absent: %s" % namespace_name)
	for fact in MISSING_CANONICAL_FACTS:
		_expect(not combined.contains(fact), "PKG-0189 inventory expects this canonical writer to remain absent before migration: %s" % fact)
	_expect(combined.contains("world_recognized"), "Station 13 synthesis fact must remain inventory-visible")
	_expect(not combined.contains("local_lena_search_committed"), "Station 13 must still expose the audited missing search commitment before migration")


func _check_report_inventory() -> void:
	var report := _read(REPORT_PATH)
	for marker in [
		"F-0184-010",
		"F-0184-012",
		"10,193",
		"203",
		"206",
		"PKG-0190",
		"local_lena_search_committed",
		"not PRODUCT GO",
	]:
		_expect(report.contains(marker), "boundary specification marker missing: %s" % marker)