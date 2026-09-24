extends RefCounted

## PKG-0242 (release): what a public build shows as credits and licences.
##
## Replaces the PKG-0152/0153 "runtime manifest" boards in Station 43
## ("LENA 4.1: 22 PNG 64x104", "KANON FABUŁY 0.3", "STEROWANIE: INPUTMAP"),
## which were developer telemetry inside the epilogue. The contract now is:
## - the epilogue credits board names the game, its authors, the engine and
##   where the licences are read;
## - the notice board is a diegetic city notice, not a manifest;
## - the title screen's Credits & Licences screen carries the Godot MIT text
##   and every third-party component the running engine reports.

const CREDITS_NODE := "CrispDiegeticText_CreditsManifest"
const NOTICE_NODE := "CrispDiegeticText_NoticeBoard"
const CREDITS_LINES: Array[String] = ["GETTING STRANGE", "GETTING STRANGE TEAM", "GODOT ENGINE", "LICENCJE"]
const FORBIDDEN_JARGON: Array[String] = ["PNG", "RUNTIME", "INPUTMAP", "KANON FABUŁY", "PIXEL-STAGE", "ZERO-ASSET", "640x360", "LEAD PROGRAMMER"]


static func station_43_failures(station: Node) -> Array[String]:
	var failures: Array[String] = []
	var credits := station.get_node_or_null(CREDITS_NODE)
	var notice := station.get_node_or_null(NOTICE_NODE)
	if credits == null:
		failures.append("Station 43 must keep an in-world credits board (%s)" % CREDITS_NODE)
	if notice == null:
		failures.append("Station 43 must keep a diegetic notice board (%s)" % NOTICE_NODE)
	for node in [credits, notice]:
		if node == null:
			continue
		var text := String(node.get("text"))
		for word in FORBIDDEN_JARGON:
			if text.contains(word):
				failures.append("Station 43 %s must not show developer jargon '%s'" % [node.name, word])
	if credits != null:
		for line in CREDITS_LINES:
			if not String(credits.get("text")).contains(line):
				failures.append("Station 43 credits board must name '%s'" % line)
	return failures


static func credits_screen_failures() -> Array[String]:
	var failures: Array[String] = []
	var text := CreditsPanel.build_text()
	if not text.contains(Engine.get_license_text().strip_edges()):
		failures.append("Credits & Licences screen must carry the Godot Engine MIT licence text")
	for component in Engine.get_copyright_info():
		var name := String(component.get("name", ""))
		if not name.is_empty() and not text.contains(name):
			failures.append("Credits & Licences screen must list third-party component '%s'" % name)
	for license_name in Engine.get_license_info().keys():
		if not text.contains(String(license_name)):
			failures.append("Credits & Licences screen must include the licence text '%s'" % license_name)
	if not text.contains("Getting Strange Team"):
		failures.append("Credits & Licences screen must credit Getting Strange Team")
	return failures
