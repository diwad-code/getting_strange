extends RefCounted

## PKG-0239: zakres, odpowiedź na metodę i wykonanie są odrębnymi zdarzeniami.
const METHODS := ["force_home", "close_equal_recover_local", "mutual_passage"]
const RESPONSE_KEY := &"p9.consent_and_cost.method_responses"
const PROPOSED_KEY := &"p9.method_commitment.proposed_method"
const SYNC_KEY := &"p9.method_commitment.marta_sync_response"

static func scope(decisions: Dictionary) -> String:
	return _agreed_value(decisions, &"p9.consent_and_cost.jakub_consent_scope",
		&"jakub_consent_state", ["granted", "limited", "refused"])

static func truth(decisions: Dictionary) -> String:
	return _agreed_value(decisions, &"p9.method_commitment.marta_truth_state",
		&"marta_truth_state", ["full", "partial", "withheld"])

static func _agreed_value(decisions: Dictionary, scoped: StringName, canonical: StringName, values: Array) -> String:
	var left := str(decisions.get(scoped, ""))
	var right := str(decisions.get(canonical, ""))
	return left if left == right and values.has(left) else ""

static func response(decisions: Dictionary, method: String) -> String:
	var replies: Variant = decisions.get(RESPONSE_KEY, {})
	if replies is Dictionary:
		return str((replies as Dictionary).get(method, ""))
	return ""

static func scope_allows(decisions: Dictionary, method: String) -> bool:
	var current := scope(decisions)
	if method == "close_equal_recover_local":
		return current in ["granted", "limited"]
	return METHODS.has(method) and current == "granted"

static func executable(decisions: Dictionary, method: String) -> bool:
	if not scope_allows(decisions, method) or response(decisions, method) != "accepted":
		return false
	if method == "mutual_passage":
		return truth(decisions) == "full" and decisions.get(SYNC_KEY, "") == "accepted"
	return true

static func locked(decisions: Dictionary) -> bool:
	var snapshot: Variant = decisions.get(&"p9.method_commitment.snapshot", {})
	if snapshot is Dictionary and not (snapshot as Dictionary).is_empty():
		return true
	for key in [&"p9.finale.forced_return.executed", &"p9.finale.close_equal.executed",
		&"p9.finale.mutual_passage.executed"]:
		if decisions.get(key, false) == true:
			return true
	return false

static func committed(decisions: Dictionary, method: String) -> bool:
	# Stary zapis bez odpowiedzi nie otrzymuje dorozumianej zgody.
	if not executable(decisions, method):
		return false
	if decisions.get(&"p9.method_commitment.method_committed", "") != method:
		return false
	if decisions.get(&"method_committed", "") != method:
		return false
	var snapshot: Variant = decisions.get(&"p9.method_commitment.snapshot", {})
	if not (snapshot is Dictionary):
		return false
	return (snapshot as Dictionary).get("method", "") == method \
		and (snapshot as Dictionary).get("jakub_method_response", "") == "accepted"

static func risk_pairs(method: String) -> Array:
	match method:
		"force_home":
			return [
				["CZYTNIK — PROGNOZA", "Wymuszenie domu: przybyła wraca. Miejscowa pozostaje między adresami."],
				["CZYTNIK — PROGNOZA", "Jakub podtrzymuje wskazanie z ręką na wyłączniku. Nie wyraża zgody za siostrę."],
				["CZYTNIK — PROGNOZA", "UCP zachowuje węzeł. Czy miejscową da się później wydobyć: brak danych."],
			]
		"close_equal_recover_local":
			return [
				["CZYTNIK — PROGNOZA", "Odzyskanie miejscowej, potem zamknięcie przepływu. Przybyła traci indeks powrotny."],
				["CZYTNIK — PROGNOZA", "Jakub sprawdza tylko wskazania. Bez podłączenia do człowieka."],
				["CZYTNIK — PROGNOZA", "Ten węzeł przestaje wyprowadzać koszt. Dokąd trafi przybyła: brak danych."],
			]
		"mutual_passage":
			return [
				["CZYTNIK — PROGNOZA", "Przejście wzajemne: obie Leny wracają, ale kanał pamięci pozostaje otwarty."],
				["CZYTNIK — PROGNOZA", "Jakub bierze udział w synchronizacji. Marta osobno potwierdza udział klucza."],
				["CZYTNIK — PROGNOZA", "Przeciek będzie wracał. Kiedy i jak mocno: brak danych. Pełnej izolacji nie ma."],
			]
	return [["Lena", "Nie wybrałam jeszcze metody. Najpierw przeczytam prognozy."]]

static func carrier_pairs(decisions: Dictionary) -> Array:
	if not decisions.has(&"home_sample_preserved") or not (decisions[&"home_sample_preserved"] is bool):
		return [["Lena", "Brak potwierdzenia, jaki nośnik zachowałam. Nie nazwę go pełną próbką."]]
	var sample: bool = decisions.get(&"home_sample_preserved", false) == true
	var lost := str(decisions.get(&"p9.mechanics.small_cost.choice", ""))
	var noun := "surowa próbka" if sample else "bufor czytnika"
	var remained := "Została" if sample else "Został"
	if lost == "sample_second":
		return [["Lena", "%s %s bez sekundy 20:40:07. Tego fragmentu już nie odtworzę." % [remained, noun]]]
	if lost == "marta_memory":
		return [
			["Lena", "%s %s. Nie odda mi pamięci dzisiejszego zdania Marty." % [remained, noun]],
			["Lena", "Wiem z jej powtórzenia, że mówiła o kaloryferze. Tego zdania nie pamiętam."],
		]
	return [["Lena", "Nie mam potwierdzenia, który koszt poniosłam."]]
