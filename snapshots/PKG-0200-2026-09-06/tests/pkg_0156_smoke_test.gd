extends SceneTree

# PKG-0156 / PHASE-01 — Product Reset Lock (BUNDLE-01..05).
# Documentation-contract gate for the P9 product rebuild documents.
# PKG-0156 does not modify runtime; this gate keeps the rebuild contracts
# machine-checked so later phases cannot silently drift.

var _failures: Array[String] = []

const REBUILD_DOCS: Array[String] = [
	"res://docs/rebuild/PLAYER_CONTRACT.md",
	"res://docs/rebuild/CAMPAIGN_MAP.md",
	"res://docs/rebuild/LOCATION_FAMILY_BIBLE.md",
	"res://docs/rebuild/ACCEPTANCE_MATRIX.md"
]

const CAMPAIGN_REQUIRED_SECTIONS: Array[String] = [
	"## 1. Słownik statusów",
	"## 3. Trasa liniowa 01–18",
	"## 4. Status materiału legacy 19–41",
	"## 5. Los materiału legacy 01–18",
	"## 6. Traceability faktów kanonicznych",
	"## 7. Budżet interakcji"
]

const FAMILIES: Array[String] = [
	"zewnętrzna / miejska",
	"przystanki / tranzyt",
	"mieszkalne",
	"instytucjonalne",
	"techniczne / przemysłowe",
	"graniczne / anomalne",
	"finałowe / epilogiczne"
]

const FAMILY_REQUIRED_HEADERS: Array[String] = [
	"## 3. Rodzina 1 — zewnętrzna / miejska",
	"## 4. Rodzina 2 — przystanki / tranzyt",
	"## 5. Rodzina 3 — mieszkalne",
	"## 6. Rodzina 4 — instytucjonalne",
	"## 7. Rodzina 5 — techniczne / przemysłowe",
	"## 8. Rodzina 6 — graniczne / anomalne",
	"## 9. Rodzina 7 — finałowe / epilogiczne"
]

const MATRIX_REQUIRED_SECTIONS: Array[String] = [
	"## 1. Dwa niezależne werdykty",
	"## 3. Bramki produktu",
	"### GATE-01 — pierwsza minuta",
	"### GATE-05 — pierwsze pięć minut",
	"### GATE-30 — pierwsze trzydzieści minut",
	"### GATE-FAM — rozpoznawalność rodzin",
	"### GATE-OBJ — cel w każdej chwili",
	"### GATE-INT — budżet interakcji",
	"### GATE-MECH — czytelność Anchor/Yield",
	"### GATE-FIN — finał opisany osobami",
	"### GATE-REL — bramka wydania",
	"## 4. Dry-run na bieżącym runtime — wynik zbiorczy",
	"## 5. Rubryka checkpointów GO / PIVOT / CUT"
]

const PLAYER_CONTRACT_SECTIONS: Array[String] = [
	"## 1. Kim jest Lena",
	"## 3. Stan wiedzy po 1 minucie",
	"## 4. Stan wiedzy po 5 minutach",
	"## 5. Stan wiedzy po 30 minutach",
	"## 7. Zakazy kontraktu",
	"## 8. Kryteria akceptacji kontraktu"
]

# Every canonical flag from CONTINUITY_TRACKER.md §13 must keep a new origin
# address in the traceability table.
const CANONICAL_FLAGS: Array[String] = [
	"home_sample_preserved", "marta_promise_broken", "ordinary_return_complete",
	"unease_pattern_started", "local_address_confirmed",
	"marta_relationship_disclosed", "conflicting_documents_found",
	"marta_memories_conflict", "marta_boundary_accepted",
	"local_lena_ucp_profile_found", "parallel_test_trace_found",
	"jakub_public_history_verified", "jakub_voice_heard",
	"jakub_met_as_person", "recognition_evidence_carried",
	"recognition_evidence_public", "recognition_evidence_relational",
	"world_recognized", "local_lena_search_committed", "anchor_yield_named",
	"mechanic_cost_observed", "ucp_intervention_reconstructed",
	"local_lena_signal_confirmed", "local_lena_intent_found",
	"small_cost_manifested", "home_echo_verified", "ucp_cost_ledger_found",
	"jakub_consent_state", "route_hypotheses_mapped", "marta_truth_state",
	"method_committed", "ending_family", "ending_stability"
]


func _initialize() -> void:
	call_deferred(&"_run_tests")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0156 FAILURE: %s" % message)


func _read(path: String) -> String:
	return FileAccess.get_file_as_string(path)


func _run_tests() -> void:
	print("=== PKG-0156 Smoke Test: PHASE-01 Product Reset Lock ===")
	_test_documents_exist()
	var campaign := _read("res://docs/rebuild/CAMPAIGN_MAP.md")
	_test_campaign_contract(campaign)
	_test_legacy_classification(campaign)
	_test_flag_traceability(campaign)
	_test_family_bible()
	_test_acceptance_matrix()
	_test_player_contract()
	_test_docs_gate_registration()
	_test_runtime_untouched()
	_finish()


func _test_documents_exist() -> void:
	for path in REBUILD_DOCS:
		_expect(not _read(path).is_empty(), "required rebuild document missing: %s" % path)


func _test_campaign_contract(campaign: String) -> void:
	for section in CAMPAIGN_REQUIRED_SECTIONS:
		_expect(campaign.contains(section), "CAMPAIGN_MAP.md must contain section '%s'" % section)
	for flag in ["MAYBE", "TBD"]:
		_expect(not campaign.contains("| %s |" % flag) and not campaign.contains("| `%s` |" % flag),
			"legacy status table must not contain %s" % flag)
	# Target route phrase from D-168.
	_expect(campaign.contains("Station 01–18 liniowo → jeden wariant 42A/B/C → Station 43"),
		"campaign map must state the D-168 target route")


func _test_legacy_classification(campaign: String) -> void:
	var start := campaign.find("## 4. Status materiału legacy 19–41")
	var end := campaign.find("### 4.1 Komponenty dawcy")
	_expect(start != -1 and end != -1, "legacy status table not found")
	if start == -1 or end == -1:
		return
	var table := campaign.substr(start, end - start)
	var seen: Dictionary = {}
	var regex := RegEx.new()
	regex.compile("^\\| ([0-9]{2}) \\| [^|]+ \\| `(KEEP|ADAPT|RETIRE)` \\|")
	for line in table.split("\n"):
		var match := regex.search(line.strip_edges())
		if match == null:
			continue
		var station_id := match.get_string(1)
		var status := match.get_string(2)
		_expect(not seen.has(station_id), "duplicate legacy status row for station %s" % station_id)
		seen[station_id] = status
	for expected in range(19, 42):
		var key := "%02d" % expected
		_expect(seen.has(key), "station %d has no KEEP/ADAPT/RETIRE status" % expected)
	_expect(seen.size() == 23, "legacy table must classify exactly 23 stations, got %d" % seen.size())
	var keep_count := 0
	for station_id in seen:
		if String(seen[station_id]) == "KEEP":
			keep_count += 1
	# KEEP would mean the address survives on the target route; the 20-address
	# route has no room for any legacy 19-41 address. Guard against silent
	# re-inflation of the old campaign.
	_expect(keep_count == 0, "no legacy station 19-41 may be KEEP on the 20-address route")


func _test_flag_traceability(campaign: String) -> void:
	var start := campaign.find("## 6. Traceability faktów kanonicznych")
	var end := campaign.find("## 7. Budżet interakcji")
	_expect(start != -1 and end != -1, "flag traceability table not found")
	if start == -1 or end == -1:
		return
	var table := campaign.substr(start, end - start)
	for flag in CANONICAL_FLAGS:
		_expect(table.contains("`%s`" % flag), "flag %s has no traceability row" % flag)


func _test_family_bible() -> void:
	var bible := _read("res://docs/rebuild/LOCATION_FAMILY_BIBLE.md")
	for header in FAMILY_REQUIRED_HEADERS:
		_expect(bible.contains(header), "LOCATION_FAMILY_BIBLE.md must contain '%s'" % header)
	for family in FAMILIES:
		_expect(bible.contains(family), "family bible must define family '%s'" % family)
	for axis in ["sylwetka", "materiał", "światło", "audio", "czasownik"]:
		_expect(bible.contains("| %s |" % axis) or bible.contains(axis), "family bible must contract the '%s' axis" % axis)


func _test_acceptance_matrix() -> void:
	var matrix := _read("res://docs/rebuild/ACCEPTANCE_MATRIX.md")
	for section in MATRIX_REQUIRED_SECTIONS:
		_expect(matrix.contains(section), "ACCEPTANCE_MATRIX.md must contain '%s'" % section)
	# Two-verdict separation is the core of D-168.
	_expect(matrix.contains("`TECHNICAL PASS` nigdy nie implikuje `PRODUCT GO`"),
		"matrix must state that TECHNICAL PASS never implies PRODUCT GO")
	# The dry-run on the current runtime must end in PRODUCT FAIL...
	_expect(matrix.contains("Werdykt produktowy bieżącego runtime: `PRODUCT FAIL`"),
		"dry-run must record PRODUCT FAIL for the current runtime")
	# ...while the technical verdict stays independently recorded.
	_expect(matrix.contains("Werdykt techniczny bieżącego runtime: `TECHNICAL PASS`"),
		"dry-run must record TECHNICAL PASS for the current runtime")
	for verdict in ["`GO`", "`PIVOT`", "`CUT`"]:
		_expect(matrix.contains(verdict), "checkpoint rubric must define %s" % verdict)


func _test_player_contract() -> void:
	var contract := _read("res://docs/rebuild/PLAYER_CONTRACT.md")
	for section in PLAYER_CONTRACT_SECTIONS:
		_expect(contract.contains(section), "PLAYER_CONTRACT.md must contain '%s'" % section)
	for identity in ["Lena Wolska", "29", "diagnostyczka drgań", "Marta", "Linii 4"]:
		_expect(contract.contains(identity), "player contract must establish '%s'" % identity)


func _test_docs_gate_registration() -> void:
	var docs_gate := _read("res://tools/verify_docs.ps1")
	_expect(not docs_gate.is_empty(), "tools/verify_docs.ps1 must exist")
	for doc in ["rebuild/PLAYER_CONTRACT.md", "rebuild/CAMPAIGN_MAP.md",
			"rebuild/LOCATION_FAMILY_BIBLE.md", "rebuild/ACCEPTANCE_MATRIX.md"]:
		_expect(docs_gate.contains(doc), "verify_docs.ps1 must require docs/%s" % doc)


func _test_runtime_untouched() -> void:
	# PKG-0157 turns the first address into the bounded first-minute contract:
	# three local actions replace the legacy resonance gallery without weakening
	# the four product documents guarded by this historical phase gate.
	var station_01 := _read("res://scenes/levels/station_01.tscn")
	_expect(station_01.count("resonance_id") == 0, "Station 01 must remove legacy resonance points")
	for action_id in ["repeat_line_four_measurement", "secure_raw_sample", "read_marta_message"]:
		_expect(station_01.contains(action_id), "Station 01 must retain opening action %s" % action_id)


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0156 SMOKE PASS: product reset lock documents are complete and consistent")
		quit(0)
		return
	for failure in _failures:
		printerr(" - %s" % failure)
	quit(1)
