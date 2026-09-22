class_name MrpLegacyRenderer
extends RefCounted

## PKG-0199 — F-0184-010 MRP renderer extraction pilot (PropType 67..196).
## Stateless visual helper. Each function receives the facade CanvasItem and
## read-only visual state only (is_activated / pulse / in_range). No Area2D,
## no signals, no audio, no particles, no GameState, no clue logic, no enum.
## Bodies are verbatim moves from MemoryResonancePoint (PKG-0198 baseline),
## with mechanical renames only:
##   draw_* -> ci.draw_*, is_activated -> p_is_activated,
##   _pulse_phase -> p_pulse, is_player_in_range -> p_in_range.
## Minimal signatures: each helper takes only the state tokens its body
## actually reads (ci always + subset of p_is_activated / p_pulse /
## p_in_range), so no UNUSED_PARAMETER warnings trip the log policy.
## Pixel contract: identical draw sequence for identical inputs.

const COLOR_AMBER := Color("d39a62")
const COLOR_INFRASTRUCTURE := Color("a8b2ac")
const COLOR_DARK_STEEL := Color("263943")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")
const COLOR_BACKGROUND := Color("182126")

static func draw_cracked_tea_cup(ci: CanvasItem, p_pulse: float) -> void:
	# Marta's cracked ceramic tea cup with golden repair seam (kintsugi / glue line) on saucer: 20x14 px
	# Saucer at base
	ci.draw_ellipse(Vector2(0.0, 5.0), 10.0, 3.0, Color("322a24"))
	ci.draw_ellipse(Vector2(0.0, 5.0), 9.0, 2.2, Color("dfdacd"))
	ci.draw_ellipse(Vector2(0.0, 5.0), 9.0, 2.2, Color("a89e92"), false, 0.8)
	
	# Ceramic cup body
	var cup_rect := Rect2(-6.0, -3.0, 12.0, 8.0)
	ci.draw_rect(cup_rect, Color("dedad1"))
	ci.draw_rect(cup_rect, Color("9a9184"), false, 0.8)
	
	# Steaming tea surface
	ci.draw_ellipse(Vector2(0.0, -3.0), 5.5, 1.8, Color("8b4a24"))
	
	# Cup handle on right side
	ci.draw_arc(Vector2(6.5, 0.0), 3.0, -PI * 0.4, PI * 0.5, 8, Color("9a9184"), 1.0)
	
	# Golden/amber repair fracture seam across ceramic body (per Scene 16 & D-05)
	var seam_p1 := Vector2(-3.0, -3.0)
	var seam_p2 := Vector2(-1.0, 1.0)
	var seam_p3 := Vector2(2.0, 5.0)
	ci.draw_line(seam_p1, seam_p2, COLOR_AMBER, 1.2)
	ci.draw_line(seam_p2, seam_p3, COLOR_AMBER, 1.2)
	
	# Delicate rising steam curls
	var steam_t := p_pulse * 1.8
	var s_alpha := 0.25 + sin(steam_t) * 0.15
	var steam_col := Color(0.85, 0.85, 0.85, s_alpha)
	var steam_y1 := -6.0 - fmod(steam_t * 6.0, 12.0)
	var steam_x1 := sin(steam_t + steam_y1 * 0.2) * 2.0
	ci.draw_circle(Vector2(steam_x1, steam_y1), 1.2, steam_col)
	var steam_y2 := -10.0 - fmod((steam_t + 1.2) * 5.0, 10.0)
	var steam_x2 := cos(steam_t * 0.8 + steam_y2 * 0.2) * 2.5
	ci.draw_circle(Vector2(steam_x2, steam_y2), 1.6, steam_col * 0.8)


static func draw_correlation_dossier(ci: CanvasItem, p_is_activated: bool) -> void:
	# Manila folder dossier with documents, photo slides and correlation diagrams: 28x20 px
	var folder_rect := Rect2(-14.0, -9.0, 28.0, 18.0)
	# Heavy cardboard folder casing
	ci.draw_rect(folder_rect, Color("2d3b37"))
	ci.draw_rect(folder_rect, COLOR_INFRASTRUCTURE * 0.8, false, 1.0)
	
	# Stacked inner paper sheets
	var sheet_rect := Rect2(-11.0, -7.0, 22.0, 14.0)
	ci.draw_rect(sheet_rect, Color("e5e2d8"))
	
	# Technical correlation line charts and handwritten notes (poszlaki R-01..R-06)
	ci.draw_line(Vector2(-9.0, -3.0), Vector2(-1.0, -3.0), Color("4a5255"), 0.9)
	ci.draw_line(Vector2(-9.0, 0.0), Vector2(5.0, 0.0), Color("4a5255"), 0.9)
	ci.draw_line(Vector2(-9.0, 3.0), Vector2(2.0, 3.0), Color("4a5255"), 0.9)
	
	# Red/amber correlation curve graph in bottom-right corner
	ci.draw_line(Vector2(2.0, -1.0), Vector2(5.0, -4.0), COLOR_AMBER, 1.0)
	ci.draw_line(Vector2(5.0, -4.0), Vector2(9.0, 1.0), COLOR_AMBER, 1.0)
	
	# Pinned photographic slide (Jakub & Lena node reference)
	var slide_rect := Rect2(3.0, -6.0, 6.0, 5.0)
	ci.draw_rect(slide_rect, Color("1a2024"))
	ci.draw_circle(Vector2(5.0, -4.0), 0.8, COLOR_CYAN)
	
	if p_is_activated:
		ci.draw_rect(folder_rect, COLOR_CYAN * 0.6, false, 1.2)


static func draw_kitchen_clock(ci: CanvasItem, p_pulse: float) -> void:
	# Round wooden wall clock with mechanical ticking hands: radius 13 px
	var center := Vector2(0.0, 0.0)
	# Outer dark wood casing
	ci.draw_circle(center, 13.0, Color("35271d"))
	ci.draw_circle(center, 13.0, Color("543f30"), false, 1.2)
	
	# Dial face
	ci.draw_circle(center, 10.5, Color("e2ded4"))
	ci.draw_circle(center, 10.5, Color("b2aba0"), false, 0.8)
	
	# Hour tick marks at 12, 3, 6, 9
	ci.draw_line(Vector2(0.0, -9.5), Vector2(0.0, -7.5), Color("242220"), 1.0)
	ci.draw_line(Vector2(9.5, 0.0), Vector2(7.5, 0.0), Color("242220"), 1.0)
	ci.draw_line(Vector2(0.0, 9.5), Vector2(0.0, 7.5), Color("242220"), 1.0)
	ci.draw_line(Vector2(-9.5, 0.0), Vector2(-7.5, 0.0), Color("242220"), 1.0)
	
	# Clock hands (Hour pointing to ~10:00, Minute to ~02:00)
	ci.draw_line(center, Vector2(-4.0, -4.5), Color("1a1816"), 1.4)
	ci.draw_line(center, Vector2(5.0, -5.0), Color("1a1816"), 1.0)
	
	# Ticking second hand with hesitation (Scene 16: asynchronia / nieregularny takt)
	var tick_angle := p_pulse * 1.5 + sin(p_pulse * 3.0) * 0.25
	var sec_vec := Vector2(sin(tick_angle), -cos(tick_angle)) * 7.5
	ci.draw_line(center, center + sec_vec, COLOR_AMBER, 0.8)
	
	# Center brass arbor pin
	ci.draw_circle(center, 1.2, Color("7a5e30"))


static func draw_wedding_ring_stand(ci: CanvasItem, p_pulse: float) -> void:
	# Small porcelain dish holding the gold wedding ring: 18x12 px
	# Dish base
	ci.draw_ellipse(Vector2(0.0, 3.0), 9.0, 4.0, Color("282420"))
	ci.draw_ellipse(Vector2(0.0, 3.0), 8.0, 3.2, Color("dedbd3"))
	ci.draw_ellipse(Vector2(0.0, 3.0), 8.0, 3.2, COLOR_INFRASTRUCTURE * 0.7, false, 0.8)
	
	# Gold wedding ring standing slightly tilted in dish
	var ring_pos := Vector2(0.0, 1.0)
	# Warm amber halo disk
	var pulse := sin(p_pulse * 2.5) * 0.5 + 0.5
	var halo_alpha := 0.20 + pulse * 0.20
	ci.draw_circle(ring_pos, 7.0 + pulse * 1.5, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, halo_alpha))
	
	# Outer gold torus ring
	ci.draw_ellipse(ring_pos, 4.5, 3.0, Color("e6b432"))
	ci.draw_ellipse(ring_pos, 4.5, 3.0, Color("ffd966"), false, 1.2)
	# Inner void
	ci.draw_ellipse(ring_pos, 2.5, 1.5, Color("3a352d"))
	
	# Specular highlight point on upper rim
	ci.draw_circle(ring_pos + Vector2(-2.2, -1.8), 0.9, Color("ffffff"))


static func draw_balcony_exit_door(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Double glass balcony door leading to apartment exterior / Space 17: 28x56 px
	var door_rect := Rect2(-14.0, -28.0, 28.0, 56.0)
	# Outer wooden frame
	ci.draw_rect(door_rect, Color("283238"))
	ci.draw_rect(door_rect, COLOR_INFRASTRUCTURE * 0.8, false, 1.2)
	
	# Glass panes looking out into night Osiedle Tarasowe
	var glass_left := Rect2(-12.0, -25.0, 11.0, 50.0)
	var glass_right := Rect2(1.0, -25.0, 11.0, 50.0)
	ci.draw_rect(glass_left, Color("0e161c"))
	ci.draw_rect(glass_right, Color("0e161c"))
	
	# Distant window lights in neighboring blocks across the night
	ci.draw_rect(Rect2(-9.0, -15.0, 2.0, 2.0), Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.45))
	ci.draw_rect(Rect2(-6.0, 5.0, 2.0, 2.0), Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.35))
	ci.draw_rect(Rect2(4.0, -10.0, 2.0, 2.0), Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.50))
	ci.draw_rect(Rect2(7.0, 12.0, 2.0, 2.0), Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.40))
	
	# Door mullion divide and brass latch
	ci.draw_line(Vector2(0.0, -26.0), Vector2(0.0, 26.0), Color("232c32"), 1.4)
	ci.draw_rect(Rect2(-1.5, 0.0, 3.0, 6.0), Color("7e683b"))
	
	# Translucent curtain drape on left side swaying slightly
	var curtain_sway := sin(p_pulse * 1.2) * 1.5
	var p1 := Vector2(-12.0, -25.0)
	var p2 := Vector2(-7.0 + curtain_sway, -5.0)
	var p3 := Vector2(-10.0 + curtain_sway, 25.0)
	ci.draw_line(p1, p2, Color(0.85, 0.85, 0.85, 0.25), 2.0)
	ci.draw_line(p2, p3, Color(0.85, 0.85, 0.85, 0.20), 2.5)
	
	if p_is_activated:
		# Unlocked exit beacon glow
		ci.draw_rect(door_rect, COLOR_CYAN * 0.5, false, 1.4)
		ci.draw_line(Vector2(-12.0, 27.0), Vector2(12.0, 27.0), COLOR_CYAN, 1.8)


static func draw_queuing_ticket_dispenser(ci: CanvasItem, p_is_activated: bool) -> void:
	# Modernist queuing ticket dispenser pedestal: 20x42 px
	var base_rect := Rect2(-10.0, 16.0, 20.0, 6.0)
	var column_rect := Rect2(-8.0, -18.0, 16.0, 34.0)
	var head_rect := Rect2(-10.0, -22.0, 20.0, 8.0)
	
	# Dark steel base
	ci.draw_rect(base_rect, COLOR_DARK_STEEL)
	ci.draw_rect(base_rect, COLOR_INFRASTRUCTURE * 0.6, false, 1.0)
	
	# Off-white enamel pedestal body
	ci.draw_rect(column_rect, Color("e5e2da"))
	ci.draw_rect(column_rect, COLOR_INFRASTRUCTURE, false, 1.0)
	
	# Head housing with sloped top
	ci.draw_rect(head_rect, Color("35424a"))
	ci.draw_rect(head_rect, COLOR_DARK_STEEL, false, 1.0)
	
	# Digital LED segment display (Amber glow "084")
	var display_rect := Rect2(-7.0, -14.0, 14.0, 7.0)
	ci.draw_rect(display_rect, Color("141c20"))
	ci.draw_rect(display_rect, Color("202a30"), false, 0.8)
	ci.draw_line(Vector2(-5.0, -10.5), Vector2(5.0, -10.5), COLOR_AMBER, 1.2)
	ci.draw_line(Vector2(-4.0, -12.0), Vector2(-1.0, -12.0), COLOR_AMBER, 1.0)
	ci.draw_line(Vector2(1.0, -12.0), Vector2(4.0, -12.0), COLOR_AMBER, 1.0)
	ci.draw_line(Vector2(-4.0, -9.0), Vector2(-1.0, -9.0), COLOR_AMBER, 1.0)
	ci.draw_line(Vector2(1.0, -9.0), Vector2(4.0, -9.0), COLOR_AMBER, 1.0)
	
	# Ticket issuing horizontal slit
	ci.draw_line(Vector2(-6.0, -3.0), Vector2(6.0, -3.0), Color("12181c"), 1.6)
	
	# Issued thermal paper ticket extending from slot
	var ticket_h := 10.0 if p_is_activated else 5.0
	var ticket_rect := Rect2(-5.0, -2.0, 10.0, ticket_h)
	ci.draw_rect(ticket_rect, Color("f8f6f0"))
	ci.draw_rect(ticket_rect, COLOR_INFRASTRUCTURE * 0.8, false, 0.6)
	# Fine printed case header lines on ticket (SPRAWA 084/17 - WŁASNE ZGŁOSZENIE)
	ci.draw_line(Vector2(-4.0, 0.0), Vector2(4.0, 0.0), Color("2b3338"), 0.7)
	ci.draw_line(Vector2(-4.0, 2.0), Vector2(2.0, 2.0), Color("2b3338"), 0.7)
	if p_is_activated:
		ci.draw_line(Vector2(-4.0, 4.5), Vector2(3.5, 4.5), COLOR_CORRECTION * 0.9, 0.8)
		ci.draw_line(Vector2(-4.0, 6.5), Vector2(1.0, 6.5), Color("2b3338"), 0.7)
		# Cyan perforation tear edge
		ci.draw_line(Vector2(-5.0, -2.0 + ticket_h), Vector2(5.0, -2.0 + ticket_h), COLOR_CYAN, 1.0)


static func draw_compliance_waiting_bench(ci: CanvasItem, p_is_activated: bool) -> void:
	# Modernist waiting room bench with compliance notice placard: 46x24 px
	# Tubular steel legs
	ci.draw_line(Vector2(-18.0, 2.0), Vector2(-18.0, 12.0), COLOR_INFRASTRUCTURE, 1.6)
	ci.draw_line(Vector2(18.0, 2.0), Vector2(18.0, 12.0), COLOR_INFRASTRUCTURE, 1.6)
	ci.draw_line(Vector2(-20.0, 12.0), Vector2(-16.0, 12.0), COLOR_DARK_STEEL, 1.8)
	ci.draw_line(Vector2(16.0, 12.0), Vector2(20.0, 12.0), COLOR_DARK_STEEL, 1.8)
	
	# Horizontal support spar
	ci.draw_line(Vector2(-20.0, 4.0), Vector2(20.0, 4.0), COLOR_DARK_STEEL, 1.4)
	
	# Molded oak plywood seat slats
	var slat1 := Rect2(-22.0, -1.0, 44.0, 3.5)
	var slat2 := Rect2(-22.0, 3.5, 44.0, 3.5)
	ci.draw_rect(slat1, Color("7a5638"))
	ci.draw_rect(slat1, Color("966c48"), false, 0.8)
	ci.draw_rect(slat2, Color("68482e"))
	ci.draw_rect(slat2, Color("865e3e"), false, 0.8)
	
	# Molded wooden backrest
	var backrest := Rect2(-22.0, -12.0, 44.0, 6.0)
	ci.draw_rect(backrest, Color("7a5638"))
	ci.draw_rect(backrest, Color("966c48"), false, 0.8)
	# Vertical backrest metal brackets
	ci.draw_line(Vector2(-14.0, -6.0), Vector2(-14.0, -1.0), COLOR_DARK_STEEL, 1.4)
	ci.draw_line(Vector2(14.0, -6.0), Vector2(14.0, -1.0), COLOR_DARK_STEEL, 1.4)
	
	# Compliance notice placard mounted above bench on the wall
	var placard_rect := Rect2(-15.0, -26.0, 30.0, 12.0)
	ci.draw_rect(placard_rect, Color("e8e6df"))
	ci.draw_rect(placard_rect, COLOR_INFRASTRUCTURE, false, 0.9)
	# UCP subtle header bar
	ci.draw_rect(Rect2(-15.0, -26.0, 30.0, 3.0), Color("2d3b44"))
	# Paragraph text lines (Instrukcja Zgodności Konsultacyjnej)
	ci.draw_line(Vector2(-12.0, -20.5), Vector2(12.0, -20.5), Color("45525a"), 0.8)
	ci.draw_line(Vector2(-12.0, -18.0), Vector2(8.0, -18.0), Color("45525a"), 0.8)
	ci.draw_line(Vector2(-12.0, -15.5), Vector2(10.0, -15.5), Color("45525a"), 0.8)
	
	if p_is_activated:
		ci.draw_rect(placard_rect, COLOR_AMBER * 0.6, false, 1.2)


static func draw_pneumatic_dossier_station(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Brass and glass pneumatic dispatch station: 22x52 px
	var station_rect := Rect2(-11.0, -26.0, 22.0, 52.0)
	
	# Vertical transparent glass transport tube
	var tube_rect := Rect2(-6.0, -26.0, 12.0, 48.0)
	ci.draw_rect(tube_rect, Color(0.12, 0.18, 0.22, 0.70))
	ci.draw_rect(tube_rect, COLOR_CYAN * 0.5, false, 1.0)
	
	# Polished brass collar mounts (top, middle valve, bottom receiver)
	ci.draw_rect(Rect2(-9.0, -26.0, 18.0, 6.0), Color("8a6d3b"))
	ci.draw_rect(Rect2(-9.0, -26.0, 18.0, 6.0), Color("b89656"), false, 0.9)
	ci.draw_rect(Rect2(-10.0, -2.0, 20.0, 7.0), Color("8a6d3b"))
	ci.draw_rect(Rect2(-10.0, -2.0, 20.0, 7.0), Color("b89656"), false, 0.9)
	ci.draw_rect(Rect2(-11.0, 18.0, 22.0, 8.0), Color("6e552c"))
	ci.draw_rect(Rect2(-11.0, 18.0, 22.0, 8.0), Color("a68549"), false, 0.9)
	
	# Pressure gauge on side
	ci.draw_circle(Vector2(8.5, -12.0), 3.5, Color("e5e0d4"))
	ci.draw_circle(Vector2(8.5, -12.0), 3.5, Color("8a6d3b"), false, 0.8)
	ci.draw_line(Vector2(8.5, -12.0), Vector2(10.0, -13.5), COLOR_CORRECTION, 0.8)
	
	# Cylindrical brass carrier capsule seated in lower reception bay
	var capsule_y := 6.0
	var capsule_rect := Rect2(-4.5, capsule_y, 9.0, 14.0)
	ci.draw_rect(capsule_rect, Color("a8894e"))
	ci.draw_rect(capsule_rect, Color("d4b06a"), false, 0.9)
	# Rubber buffer rings on capsule ends
	ci.draw_rect(Rect2(-5.0, capsule_y, 10.0, 2.5), Color("262c30"))
	ci.draw_rect(Rect2(-5.0, capsule_y + 11.5, 10.0, 2.5), Color("262c30"))
	# Personal dossier label strip on capsule body
	ci.draw_line(Vector2(-3.5, capsule_y + 6.0), Vector2(3.5, capsule_y + 6.0), Color("f2eee4"), 1.2)
	ci.draw_line(Vector2(-3.0, capsule_y + 8.0), Vector2(2.0, capsule_y + 8.0), Color("303a40"), 0.7)
	
	# Internal air suction glow animation
	var suction_pulse := sin(p_pulse * 3.0) * 0.5 + 0.5
	if p_is_activated:
		ci.draw_line(Vector2(0.0, -24.0), Vector2(0.0, 4.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.4 + suction_pulse * 0.4), 2.0)
		ci.draw_rect(station_rect, COLOR_CYAN * 0.5, false, 1.2)


static func draw_diagnostic_memory_printer(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Tabletop sensory diagnostic recording apparatus: 28x32 px
	var table_mount := Rect2(-14.0, 10.0, 28.0, 6.0)
	ci.draw_rect(table_mount, Color("2d373e"))
	ci.draw_rect(table_mount, COLOR_INFRASTRUCTURE * 0.7, false, 0.8)
	
	# Main chassis (olive/sage institutional metal housing)
	var chassis_rect := Rect2(-12.0, -8.0, 24.0, 18.0)
	ci.draw_rect(chassis_rect, Color("4a5752"))
	ci.draw_rect(chassis_rect, Color("62736c"), false, 1.0)
	
	# Paper supply roll cradle on top
	ci.draw_ellipse(Vector2(-6.0, -10.0), 4.5, 3.0, Color("dedbd2"))
	ci.draw_ellipse(Vector2(-6.0, -10.0), 4.5, 3.0, Color("9a968d"), false, 0.7)
	
	# Dot-matrix printhead carriage and thermal ribbon guide
	ci.draw_rect(Rect2(-10.0, -4.0, 20.0, 4.0), Color("1e2529"))
	var carriage_x := sin(p_pulse * 4.0) * 6.0 if p_is_activated else -2.0
	ci.draw_rect(Rect2(carriage_x - 2.0, -5.0, 4.0, 6.0), Color("a67c38"))
	
	# Emerging diagnostic paper tape trailing downward
	var paper_h := 16.0 if p_is_activated else 8.0
	var paper_strip := Rect2(-7.0, 0.0, 14.0, paper_h)
	ci.draw_rect(paper_strip, Color("fcfaf4"))
	ci.draw_rect(paper_strip, COLOR_INFRASTRUCTURE * 0.7, false, 0.6)
	
	# Printed sensory data lines: KAWA / LINOLEUM / MOKRA WEŁNA
	ci.draw_line(Vector2(-5.5, 3.0), Vector2(5.5, 3.0), Color("20262b"), 0.8)
	ci.draw_line(Vector2(-5.5, 5.5), Vector2(3.5, 5.5), Color("20262b"), 0.8)
	if p_is_activated:
		ci.draw_line(Vector2(-5.5, 8.0), Vector2(4.5, 8.0), COLOR_CORRECTION * 0.9, 0.9)
		ci.draw_line(Vector2(-5.5, 10.5), Vector2(5.0, 10.5), Color("20262b"), 0.8)
		ci.draw_line(Vector2(-5.5, 13.0), Vector2(2.5, 13.0), COLOR_AMBER, 0.8)
	
	# Status indicator LED (Amber idle / Cyan diagnostic sync)
	var led_color := COLOR_CYAN if p_is_activated else COLOR_AMBER
	ci.draw_circle(Vector2(8.0, -5.0), 1.5, led_color)
	ci.draw_circle(Vector2(8.0, -5.0), 3.0, Color(led_color.r, led_color.g, led_color.b, 0.3))


static func draw_consultation_office_door(ci: CanvasItem, p_is_activated: bool) -> void:
	# Modernist consultation office door leading to Dr. Wierzbicka's office: 30x62 px
	var door_rect := Rect2(-15.0, -31.0, 30.0, 62.0)
	
	# Clean institutional door frame (Off-white / pale concrete enamel)
	ci.draw_rect(door_rect, Color("2c3942"))
	ci.draw_rect(door_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Large frosted ribbed glass upper panel: 24x36 px
	var glass_rect := Rect2(-12.0, -28.0, 24.0, 36.0)
	ci.draw_rect(glass_rect, Color("d5dedb"))
	ci.draw_rect(glass_rect, COLOR_INFRASTRUCTURE * 0.8, false, 0.9)
	
	# Fluted glass vertical texture lines
	for gx in range(-10, 11, 3):
		ci.draw_line(Vector2(float(gx), -27.0), Vector2(float(gx), 7.0), Color(0.70, 0.76, 0.74, 0.50), 0.8)
	
	# Vague blurred dark silhouette behind the frosted glass (Dr. Helena Wierzbicka sitting at desk)
	var silhouette_head := Vector2(2.0, -18.0)
	ci.draw_circle(silhouette_head, 3.8, Color(0.18, 0.24, 0.27, 0.65))
	var silhouette_shoulders := Rect2(-4.0, -14.0, 12.0, 14.0)
	ci.draw_rect(silhouette_shoulders, Color(0.18, 0.24, 0.27, 0.55))
	# Warm desk lamp reflection behind frosted glass
	ci.draw_circle(Vector2(-5.0, -10.0), 5.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.35))
	
	# Enamel door plaque: "GABINET KONSULTACYJNY 06 / DR H. WIERZBICKA"
	var plaque_rect := Rect2(-10.0, 11.0, 20.0, 7.0)
	ci.draw_rect(plaque_rect, Color("1a2228"))
	ci.draw_rect(plaque_rect, Color("b29456"), false, 0.8)
	ci.draw_line(Vector2(-8.0, 13.5), Vector2(8.0, 13.5), Color("e8e4da"), 0.8)
	ci.draw_line(Vector2(-8.0, 15.5), Vector2(4.0, 15.5), COLOR_AMBER * 0.9, 0.7)
	
	# Brass lever handle
	ci.draw_circle(Vector2(-9.0, 22.0), 1.6, Color("c29e55"))
	ci.draw_line(Vector2(-9.0, 22.0), Vector2(-4.0, 22.0), Color("c29e55"), 1.8)
	
	# Lower kick plate (Brushed steel)
	var kickplate_rect := Rect2(-12.0, 26.0, 24.0, 4.0)
	ci.draw_rect(kickplate_rect, Color("3a4852"))
	ci.draw_rect(kickplate_rect, COLOR_INFRASTRUCTURE * 0.6, false, 0.7)
	
	if p_is_activated:
		# Unlocked consultation room threshold cyan illumination
		ci.draw_rect(door_rect, COLOR_CYAN * 0.6, false, 1.5)
		ci.draw_line(Vector2(-14.0, 31.0), Vector2(14.0, 31.0), COLOR_CYAN, 2.0)


static func draw_wierzbicka_desk(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Dr. Helena Wierzbicka's consultation desk: 32x22 px
	# Beech wood surface with dossier of missing Lena, transcription apparatus, tea cup
	var pulse := sin(p_pulse * 1.8) * 0.5 + 0.5
	
	# Desk body: powder-coated steel frame, beech wood top
	var desk_body := Rect2(-16.0, -4.0, 32.0, 16.0)
	ci.draw_rect(desk_body, Color("29373e"))
	ci.draw_rect(desk_body, Color("383f46") * 0.8, false, 0.9)
	
	# Beech wood desktop surface
	var top_rect := Rect2(-16.0, -8.0, 32.0, 5.0)
	ci.draw_rect(top_rect, Color("9c7e54"))
	ci.draw_rect(top_rect, Color("b39168"), false, 0.8)
	
	# Transcription apparatus (compact, left side)
	ci.draw_rect(Rect2(-13.0, -12.0, 8.0, 5.0), Color("202a30"))
	ci.draw_rect(Rect2(-13.0, -12.0, 8.0, 5.0), COLOR_AMBER * 0.5, false, 0.8)
	ci.draw_line(Vector2(-12.0, -10.0), Vector2(-6.0, -10.0), COLOR_AMBER * 0.7, 0.8)
	
	# Missing Lena dossier / teczka
	ci.draw_rect(Rect2(-3.0, -11.0, 14.0, 4.0), Color("4a5560"))
	ci.draw_rect(Rect2(-3.0, -11.0, 14.0, 4.0), COLOR_INFRASTRUCTURE * 0.6, false, 0.8)
	ci.draw_line(Vector2(-1.0, -9.5), Vector2(9.0, -9.5), Color("d0d8d5"), 0.8)
	ci.draw_line(Vector2(-1.0, -8.0), Vector2(6.0, -8.0), COLOR_AMBER * 0.65, 0.7)
	
	# Tea cup: institutional porcelain
	ci.draw_circle(Vector2(11.0, -10.0), 2.5, Color("c8d2ce"))
	ci.draw_circle(Vector2(11.0, -10.0), 2.5, COLOR_INFRASTRUCTURE * 0.5, false)
	
	# Amber lamp glow on desk surface when activated (stamp just approved)
	if p_is_activated:
		ci.draw_circle(Vector2(-4.0, -7.0), 6.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.22 + pulse * 0.12))
		ci.draw_rect(Rect2(-13.0, -12.0, 8.0, 5.0), COLOR_AMBER * 0.3, false, 1.2)
	
	# Interaction reticule hint: pale olive
	if p_in_range and not p_is_activated:
		ci.draw_circle(Vector2.ZERO, 18.0, Color("8fa07a", 0.10 + pulse * 0.08))


static func draw_sensory_memory_map(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Wall-mounted sensory memory map of Równia with illuminated nodes (Peron 2, prosektorium, Linia 4)
	# 30x26 px panel, cool olive background with cyan node highlights
	var pulse := sin(p_pulse * 2.1) * 0.5 + 0.5
	
	# Map panel background
	ci.draw_rect(Rect2(-15.0, -14.0, 30.0, 28.0), Color("1e2b28"))
	ci.draw_rect(Rect2(-15.0, -14.0, 30.0, 28.0), Color("4a6255", 0.5), false, 0.9)
	
	# Grid lines — city blocks schematic (pale olive lines)
	for i in range(-12, 13, 6):
		ci.draw_line(Vector2(float(i), -12.0), Vector2(float(i), 12.0), Color("4a7060", 0.35), 0.7)
	for i in range(-12, 13, 6):
		ci.draw_line(Vector2(-13.0, float(i)), Vector2(13.0, float(i)), Color("4a7060", 0.35), 0.7)
	
	# Rail line (Linia 4): diagonal amber trace
	ci.draw_line(Vector2(-13.0, 10.0), Vector2(13.0, -8.0), Color("b8843c", 0.70), 1.2)
	
	# Transit node: Peron 2 (upper right — active, cyan)
	var node1_glow := 0.55 + pulse * 0.35 if p_is_activated else 0.40
	ci.draw_circle(Vector2(7.0, -8.0), 3.5, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, node1_glow))
	ci.draw_circle(Vector2(7.0, -8.0), 1.8, COLOR_CYAN)
	
	# Node: Prosektorium (lower left — dim, amber)
	var node2_glow := 0.45 + pulse * 0.25 if p_is_activated else 0.30
	ci.draw_circle(Vector2(-9.0, 7.0), 3.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, node2_glow))
	ci.draw_circle(Vector2(-9.0, 7.0), 1.5, COLOR_AMBER)
	
	# Node: Linia 4 incident marker (center — correction red, pulsing)
	var node3_glow := 0.45 + pulse * 0.40 if p_is_activated else 0.25
	ci.draw_circle(Vector2(1.0, 2.0), 2.8, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, node3_glow))
	ci.draw_circle(Vector2(1.0, 2.0), 1.2, COLOR_CORRECTION)
	
	# Panel label line at top
	ci.draw_line(Vector2(-13.0, -12.0), Vector2(13.0, -12.0), Color("8fa07a", 0.60), 0.8)
	ci.draw_line(Vector2(-11.0, -11.0), Vector2(6.0, -11.0), Color("c8d4cc"), 0.7)
	
	# Activated: extra node link lines flash
	if p_is_activated:
		ci.draw_line(Vector2(7.0, -8.0), Vector2(1.0, 2.0), COLOR_CYAN * 0.50, 1.0)
		ci.draw_line(Vector2(-9.0, 7.0), Vector2(1.0, 2.0), COLOR_AMBER * 0.45, 1.0)


static func draw_correction_galvanometer(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Precision galvanometer: 22x28 px — reacts to Lena's false sensory responses
	# Needle deflects on lie; absorbs lie as official record, but strain indicator spikes
	var pulse := sin(p_pulse * 3.5) * 0.5 + 0.5
	
	# Instrument housing: polished beige steel
	ci.draw_rect(Rect2(-11.0, -14.0, 22.0, 28.0), Color("2a3338"))
	ci.draw_rect(Rect2(-11.0, -14.0, 22.0, 28.0), Color("5a6a62", 0.5), false, 0.9)
	
	# Dial face: white enamel circle
	ci.draw_circle(Vector2.ZERO, 8.5, Color("e8eeeb"))
	ci.draw_circle(Vector2.ZERO, 8.5, COLOR_INFRASTRUCTURE * 0.7, false)
	
	# Tick marks on dial
	for i in range(8):
		var angle := -2.2 + float(i) * (4.4 / 7.0)
		var inner := Vector2(cos(angle), sin(angle)) * 6.0
		var outer := Vector2(cos(angle), sin(angle)) * 8.0
		ci.draw_line(inner, outer, Color("34454c"), 0.8)
	
	# Center datum line
	ci.draw_line(Vector2(-7.0, 0.0), Vector2(7.0, 0.0), Color("9aada6", 0.5), 0.7)
	
	# Needle: rests at center; deflects right when Lena lies
	var needle_angle := -1.4 if not p_is_activated else (-1.4 + 1.8 * (0.6 + pulse * 0.4))
	var needle_tip := Vector2(cos(needle_angle), sin(needle_angle)) * 7.5
	ci.draw_line(Vector2.ZERO, needle_tip, COLOR_CORRECTION, 1.5)
	ci.draw_circle(Vector2.ZERO, 1.5, Color("c43535"))
	
	# Lie-accepted indicator light (amber when activated = lie recorded)
	ci.draw_circle(Vector2(0.0, 11.0), 2.5, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.5 + (pulse * 0.4 if p_is_activated else 0.0)))
	
	# Housing bottom terminals
	ci.draw_rect(Rect2(-5.0, 12.0, 10.0, 3.0), Color("1e2a30"))
	ci.draw_circle(Vector2(-3.0, 13.5), 1.0, COLOR_INFRASTRUCTURE * 0.6)
	ci.draw_circle(Vector2(3.0, 13.5), 1.0, COLOR_INFRASTRUCTURE * 0.6)


static func draw_acoustic_weight_conduit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Wall-mounted Podstruktura load indicator: 20x32 px
	# Shows structural tension in Podstruktura (sub-foundation) rising as lie is accepted by system
	var pulse := sin(p_pulse * 0.9) * 0.5 + 0.5
	
	# Housing: dark powder-coated steel panel
	ci.draw_rect(Rect2(-10.0, -16.0, 20.0, 32.0), Color("1a2226"))
	ci.draw_rect(Rect2(-10.0, -16.0, 20.0, 32.0), Color("3a4f48", 0.5), false, 0.9)
	
	# Meter graduation marks (8 levels)
	for i in range(9):
		var y := -13.0 + float(i) * 3.0
		ci.draw_line(Vector2(-7.0, y), Vector2(7.0, y), Color("4a6255", 0.40), 0.7)
	
	# Fill bar: low strain base state (cool olive)
	var fill_h := 12.0 if not p_is_activated else (12.0 + pulse * 12.0)
	var fill_color := Color("5a8060") if not p_is_activated else Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.65 + pulse * 0.25)
	ci.draw_rect(Rect2(-7.0, 13.0 - fill_h, 14.0, fill_h), fill_color)
	
	# Label: naprężenie podstruktury
	ci.draw_line(Vector2(-8.0, -14.0), Vector2(8.0, -14.0), Color("8fa07a", 0.60), 0.8)
	ci.draw_line(Vector2(-6.0, -13.0), Vector2(5.0, -13.0), Color("c8d4cc"), 0.7)
	
	# Strain peak indicator top cap (lights red when lie is accepted)
	var peak_alpha := 0.3 + pulse * 0.55 if p_is_activated else 0.15
	ci.draw_rect(Rect2(-7.0, -13.0, 14.0, 3.0), Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, peak_alpha))
	ci.draw_rect(Rect2(-7.0, -13.0, 14.0, 3.0), COLOR_CORRECTION * 0.8, false, 0.9)
	
	# Sub-bass vibration lines (acoustic resonance from Podstruktura behind wall)
	if p_is_activated:
		for i in range(3):
			var vy := -8.0 + float(i) * 6.0
			ci.draw_line(Vector2(-9.0, vy), Vector2(9.0, vy), Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.15 + pulse * 0.20), 0.8)


static func draw_model_room_airlock(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Bolted consultation room exit door to Model Room / Sala Modeli (Space 19): 24x36 px
	# Heavy powder-coated steel, rigid-bolt institutional hospital design
	var pulse := sin(p_pulse * 1.5) * 0.5 + 0.5
	
	# Door frame: dark steel
	var door_rect := Rect2(-12.0, -18.0, 24.0, 36.0)
	ci.draw_rect(door_rect, Color("1a2429"))
	ci.draw_rect(door_rect, Color("3a4f4a", 0.7), false, 1.2)
	
	# Door panel: pale institutional olive steel
	var panel_rect := Rect2(-10.0, -16.0, 20.0, 32.0)
	ci.draw_rect(panel_rect, Color("2a3c35"))
	ci.draw_rect(panel_rect, Color("4a6355", 0.5), false, 0.9)
	
	# Cross-rail dividers: powder-coated steel extrusion
	ci.draw_rect(Rect2(-10.0, -3.0, 20.0, 2.0), Color("1e2f29"))
	
	# Rigid bolt / lock bar: horizontal security bolt
	ci.draw_rect(Rect2(-8.0, 8.0, 16.0, 3.0), Color("405548"))
	ci.draw_rect(Rect2(-8.0, 8.0, 16.0, 3.0), COLOR_INFRASTRUCTURE * 0.5, false, 0.8)
	ci.draw_circle(Vector2(5.0, 9.5), 2.2, Color("606e68"))
	
	# "SALA MODELI" enamel label
	ci.draw_line(Vector2(-8.0, -12.0), Vector2(8.0, -12.0), Color("8fa07a", 0.60), 0.8)
	ci.draw_line(Vector2(-7.0, -10.5), Vector2(5.0, -10.5), Color("c8d4cc"), 0.7)
	
	# UCP safety notice (small placard)
	ci.draw_rect(Rect2(-9.0, 14.0, 18.0, 4.0), Color("1a2226"))
	ci.draw_rect(Rect2(-9.0, 14.0, 18.0, 4.0), COLOR_AMBER * 0.3, false, 0.7)
	ci.draw_line(Vector2(-7.0, 16.0), Vector2(7.0, 16.0), Color("c8b87a"), 0.7)
	
	# Activated (unlocked) state: cyan threshold glow + bolt withdrawn
	if p_is_activated:
		ci.draw_rect(door_rect, COLOR_CYAN * 0.45, false, 1.5)
		ci.draw_line(Vector2(-12.0, 18.0), Vector2(12.0, 18.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.7 + pulse * 0.3), 2.0)
		# Bolt visually withdrawn (slides right)
		ci.draw_rect(Rect2(2.0, 8.0, 8.0, 3.0), Color("3a4a44"))
	else:
		# Locked — subtle amber lock indicator
		ci.draw_circle(Vector2(5.0, 9.5), 1.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.40 + pulse * 0.25))


static func draw_model_display_table(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Central model exhibition table: 54x26 px
	# Cold white acrylic bed on dark steel/beige plaster stand.
	# Contains two equivalent scale architectural models of Line 4 staircase/incident.
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	
	# Table stand / base: dark institutional steel & plaster
	var base_rect := Rect2(-27.0, -13.0, 54.0, 26.0)
	ci.draw_rect(base_rect, Color("1e2826"))
	ci.draw_rect(base_rect, Color("3b4e45", 0.7), false, 1.0)
	
	# Tabletop cold white acrylic bed with perimeter bezel
	var top_rect := Rect2(-25.0, -11.0, 50.0, 22.0)
	ci.draw_rect(top_rect, Color("2a3832"))
	ci.draw_rect(top_rect, Color("4a6255", 0.5), false, 0.8)
	
	# Center divider dividing the two models
	ci.draw_line(Vector2(0.0, -11.0), Vector2(0.0, 11.0), Color("16221e"), 1.2)
	
	# Model 1 (Left): Staircase ending on street level (140 people egress)
	# Acrylic pedestal & wireframe staircase
	var m1_rect := Rect2(-23.0, -9.0, 21.0, 18.0)
	ci.draw_rect(m1_rect, Color("202e28"))
	ci.draw_rect(m1_rect, Color("344b40", 0.6), false, 0.7)
	# Steps descending to open bottom
	for i in range(4):
		var sx := -21.0 + float(i) * 4.0
		var sy := -6.0 + float(i) * 3.2
		ci.draw_line(Vector2(sx, sy), Vector2(sx + 3.0, sy), COLOR_CYAN * 0.75, 1.0)
		ci.draw_line(Vector2(sx + 3.0, sy), Vector2(sx + 3.0, sy + 3.2), COLOR_CYAN * 0.55, 0.8)
	# Open street threshold (cyan marker)
	ci.draw_line(Vector2(-9.0, 6.5), Vector2(-4.0, 6.5), COLOR_CYAN, 1.4)
	
	# Model 2 (Right): Staircase ending on solid load-bearing wall (17 witnesses)
	# Acrylic pedestal & wireframe staircase
	var m2_rect := Rect2(2.0, -9.0, 21.0, 18.0)
	ci.draw_rect(m2_rect, Color("202e28"))
	ci.draw_rect(m2_rect, Color("344b40", 0.6), false, 0.7)
	# Steps descending toward wall
	for i in range(4):
		var sx := 4.0 + float(i) * 4.0
		var sy := -6.0 + float(i) * 3.2
		ci.draw_line(Vector2(sx, sy), Vector2(sx + 3.0, sy), COLOR_AMBER * 0.75, 1.0)
		ci.draw_line(Vector2(sx + 3.0, sy), Vector2(sx + 3.0, sy + 3.2), COLOR_AMBER * 0.55, 0.8)
	# Solid partition wall slab (reinforced concrete hatched marker)
	ci.draw_rect(Rect2(19.0, -7.0, 3.0, 14.0), Color("4e3832"))
	ci.draw_rect(Rect2(19.0, -7.0, 3.0, 14.0), COLOR_CORRECTION * 0.8, false, 0.8)
	
	# Transparent acrylic protective cases (glare lines)
	ci.draw_line(Vector2(-23.0, -9.0), Vector2(-12.0, -9.0), Color("d8ece2", 0.40), 0.7)
	ci.draw_line(Vector2(2.0, -9.0), Vector2(13.0, -9.0), Color("d8ece2", 0.40), 0.7)
	
	# Activated dual-resonance underglow
	if p_is_activated:
		ci.draw_rect(m1_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.25 + pulse * 0.25))
		ci.draw_rect(m2_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.25 + pulse * 0.25))
		ci.draw_rect(top_rect, Color("eef6f2", 0.15 + pulse * 0.15))


static func draw_staircase_map_left(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Wall-mounted architectural schematic board: 34x44 px
	# Left version: "SCHEMAT 4-A / ULICA / 140 OSÓB"
	var pulse := sin(p_pulse * 1.8) * 0.5 + 0.5
	
	var board_rect := Rect2(-17.0, -22.0, 34.0, 44.0)
	ci.draw_rect(board_rect, Color("1a2622"))
	ci.draw_rect(board_rect, Color("3d5449", 0.75), false, 1.0)
	
	# Inner blueprint drafting sheet
	var sheet_rect := Rect2(-15.0, -20.0, 30.0, 40.0)
	ci.draw_rect(sheet_rect, Color("14201c"))
	ci.draw_rect(sheet_rect, Color("2d4037", 0.5), false, 0.7)
	
	# Header line: "SCHEMAT 4-A"
	ci.draw_line(Vector2(-13.0, -17.0), Vector2(13.0, -17.0), Color("8fa89b", 0.8), 0.9)
	ci.draw_line(Vector2(-13.0, -15.0), Vector2(6.0, -15.0), Color("c8dcd2"), 0.7)
	
	# Blueprint grid lines
	for gx in range(-12, 13, 6):
		ci.draw_line(Vector2(float(gx), -12.0), Vector2(float(gx), 16.0), Color("1e3028", 0.4), 0.5)
	for gy in range(-10, 16, 5):
		ci.draw_line(Vector2(-13.0, float(gy)), Vector2(13.0, float(gy)), Color("1e3028", 0.4), 0.5)
	
	# Staircase schematic profile (continuous descent to street level)
	for i in range(5):
		var sx := -11.0 + float(i) * 4.5
		var sy := -8.0 + float(i) * 4.5
		ci.draw_line(Vector2(sx, sy), Vector2(sx + 3.5, sy), COLOR_CYAN * 0.85, 1.2)
		ci.draw_line(Vector2(sx + 3.5, sy), Vector2(sx + 3.5, sy + 4.5), COLOR_CYAN * 0.65, 0.9)
	
	# Street level exit arrow & portal marker (clean cyan)
	ci.draw_line(Vector2(7.0, 14.5), Vector2(12.0, 14.5), COLOR_CYAN, 1.5)
	ci.draw_line(Vector2(10.0, 12.0), Vector2(12.0, 14.5), COLOR_CYAN, 1.0)
	ci.draw_line(Vector2(10.0, 17.0), Vector2(12.0, 14.5), COLOR_CYAN, 1.0)
	
	# Status note: 140 OSÓB
	ci.draw_line(Vector2(-13.0, 17.5), Vector2(3.0, 17.5), Color("76a892"), 0.8)
	
	# Inspected / activated glow
	if p_is_activated:
		ci.draw_rect(board_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.15 + pulse * 0.15), false, 1.2)


static func draw_staircase_map_right(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Wall-mounted architectural schematic board: 34x44 px
	# Right version: "SCHEMAT 4-B / ŚCIANA NOŚNA / 17 ŚWIADKÓW"
	var pulse := sin(p_pulse * 1.8) * 0.5 + 0.5
	
	var board_rect := Rect2(-17.0, -22.0, 34.0, 44.0)
	ci.draw_rect(board_rect, Color("1a2622"))
	ci.draw_rect(board_rect, Color("3d5449", 0.75), false, 1.0)
	
	# Inner blueprint drafting sheet
	var sheet_rect := Rect2(-15.0, -20.0, 30.0, 40.0)
	ci.draw_rect(sheet_rect, Color("14201c"))
	ci.draw_rect(sheet_rect, Color("2d4037", 0.5), false, 0.7)
	
	# Header line: "SCHEMAT 4-B"
	ci.draw_line(Vector2(-13.0, -17.0), Vector2(13.0, -17.0), Color("8fa89b", 0.8), 0.9)
	ci.draw_line(Vector2(-13.0, -15.0), Vector2(6.0, -15.0), Color("c8dcd2"), 0.7)
	
	# Blueprint grid lines
	for gx in range(-12, 13, 6):
		ci.draw_line(Vector2(float(gx), -12.0), Vector2(float(gx), 16.0), Color("1e3028", 0.4), 0.5)
	for gy in range(-10, 16, 5):
		ci.draw_line(Vector2(-13.0, float(gy)), Vector2(13.0, float(gy)), Color("1e3028", 0.4), 0.5)
	
	# Staircase schematic profile (identical descent toward load-bearing wall)
	for i in range(5):
		var sx := -11.0 + float(i) * 4.0
		var sy := -8.0 + float(i) * 4.5
		ci.draw_line(Vector2(sx, sy), Vector2(sx + 3.5, sy), COLOR_AMBER * 0.85, 1.2)
		ci.draw_line(Vector2(sx + 3.5, sy), Vector2(sx + 3.5, sy + 4.5), COLOR_AMBER * 0.65, 0.9)
	
	# Load-bearing structural wall (cross-hatched vertical block)
	var wall_rect := Rect2(9.0, -6.0, 4.0, 22.0)
	ci.draw_rect(wall_rect, Color("3e2a26"))
	ci.draw_rect(wall_rect, COLOR_CORRECTION * 0.8, false, 0.9)
	for h in range(4):
		var hy := -4.0 + float(h) * 5.0
		ci.draw_line(Vector2(9.0, hy), Vector2(13.0, hy + 3.0), COLOR_CORRECTION * 0.6, 0.7)
	
	# Status note: 17 ŚWIADKÓW
	ci.draw_line(Vector2(-13.0, 17.5), Vector2(5.0, 17.5), Color("b89668"), 0.8)
	
	# Inspected / activated glow
	if p_is_activated:
		ci.draw_rect(board_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.15 + pulse * 0.15), false, 1.2)


static func draw_eleven_persons_ledger(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Dossier binder on small side lectern/shelf: 28x22 px
	# 11 distinct row entries of persons missing from all official tables
	var pulse := sin(p_pulse * 2.2) * 0.5 + 0.5
	
	# Shelf support
	ci.draw_rect(Rect2(-14.0, 8.0, 28.0, 3.0), Color("1c2622"))
	ci.draw_line(Vector2(-12.0, 11.0), Vector2(-8.0, 16.0), Color("2e3e36"), 1.0)
	ci.draw_line(Vector2(12.0, 11.0), Vector2(8.0, 16.0), Color("2e3e36"), 1.0)
	
	# Open ledger / dossier cover
	var book_rect := Rect2(-13.0, -10.0, 26.0, 18.0)
	ci.draw_rect(book_rect, Color("22322a"))
	ci.draw_rect(book_rect, Color("3e564a", 0.8), false, 0.9)
	
	# Inner paper pages (ivory sage)
	var page_rect := Rect2(-11.0, -8.0, 22.0, 14.0)
	ci.draw_rect(page_rect, Color("dce6e0"))
	ci.draw_line(Vector2(0.0, -8.0), Vector2(0.0, 6.0), Color("8ea096"), 0.8)
	
	# 11 lines of names/records (5 on left page, 6 on right page)
	for i in range(5):
		var ly := -6.0 + float(i) * 2.4
		ci.draw_line(Vector2(-9.5, ly), Vector2(-1.5, ly), Color("4a5c54", 0.75), 0.8)
	for j in range(6):
		var ry := -6.5 + float(j) * 2.1
		ci.draw_line(Vector2(1.5, ry), Vector2(9.5, ry), Color("4a5c54", 0.75), 0.8)
	
	# Red marginal note: Wierzbicka's private handwriting
	ci.draw_line(Vector2(-10.5, -6.0), Vector2(-10.5, 4.0), Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.75), 0.9)
	
	# Metal spine clip
	ci.draw_rect(Rect2(-1.0, -9.0, 2.0, 16.0), Color("6e8076"))
	
	if p_is_activated:
		ci.draw_rect(book_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.20 + pulse * 0.20), false, 1.1)


static func draw_model_room_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy institutional exit door to Space 20 (Sala Szymona): 26x40 px
	var pulse := sin(p_pulse * 1.6) * 0.5 + 0.5
	
	# Frame
	var frame_rect := Rect2(-13.0, -20.0, 26.0, 40.0)
	ci.draw_rect(frame_rect, Color("162024"))
	ci.draw_rect(frame_rect, Color("34464c", 0.75), false, 1.2)
	
	# Door leaf: cold institutional olive steel
	var leaf_rect := Rect2(-11.0, -18.0, 22.0, 36.0)
	ci.draw_rect(leaf_rect, Color("263630"))
	ci.draw_rect(leaf_rect, Color("425a50", 0.5), false, 0.9)
	
	# Horizontal steel cross-dividers
	ci.draw_rect(Rect2(-11.0, -4.0, 22.0, 2.0), Color("1c2824"))
	
	# Lock bolt housing
	ci.draw_rect(Rect2(-9.0, 7.0, 18.0, 3.5), Color("3a4c44"))
	ci.draw_rect(Rect2(-9.0, 7.0, 18.0, 3.5), COLOR_INFRASTRUCTURE * 0.5, false, 0.8)
	ci.draw_circle(Vector2(6.0, 8.7), 2.0, Color("586862"))
	
	# Placard: "SALA SZYMONA / 20"
	ci.draw_rect(Rect2(-10.0, -14.0, 20.0, 5.0), Color("16221e"))
	ci.draw_rect(Rect2(-10.0, -14.0, 20.0, 5.0), COLOR_INFRASTRUCTURE * 0.4, false, 0.7)
	ci.draw_line(Vector2(-8.0, -11.5), Vector2(8.0, -11.5), Color("c8d8d0"), 0.8)
	
	# Status indicator & bolt
	if p_is_activated:
		# Unlocked: cyan glow, bolt withdrawn
		ci.draw_rect(frame_rect, COLOR_CYAN * 0.45, false, 1.4)
		ci.draw_line(Vector2(-13.0, 20.0), Vector2(13.0, 20.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.75 + pulse * 0.25), 2.0)
		ci.draw_rect(Rect2(2.0, 7.0, 9.0, 3.5), Color("2e3e36"))
	else:
		# Locked: subtle amber indicator
		ci.draw_circle(Vector2(6.0, 8.7), 1.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.45 + pulse * 0.25))


static func draw_szymon_bera(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Szymon Bera sitting on edge of institutional bed in Room 20: 36x30 px
	# Conforms to VISUAL_DESIGN.md (muted grey sage, elderly weathered silhouette)
	var pulse := sin(p_pulse * 1.8) * 0.5 + 0.5
	var breath := sin(p_pulse * 1.2) * 1.0
	
	# Therapeutic bed frame (tubular aluminum & mattress)
	var bed_rect := Rect2(-18.0, 4.0, 36.0, 14.0)
	ci.draw_rect(bed_rect, Color("1e2c26"))
	ci.draw_rect(bed_rect, Color("3a4c44", 0.7), false, 1.0)
	
	# Mattress and folded institutional blanket
	ci.draw_rect(Rect2(-17.0, 1.0, 34.0, 4.0), Color("d0ded8"))
	ci.draw_rect(Rect2(-16.0, 5.0, 14.0, 12.0), Color("6c8278"))
	
	# Bed tubular legs
	ci.draw_line(Vector2(-16.0, 18.0), Vector2(-16.0, 24.0), Color("4a5c54"), 1.5)
	ci.draw_line(Vector2(16.0, 18.0), Vector2(16.0, 24.0), Color("4a5c54"), 1.5)
	
	# Szymon seated figure (center-right of bed)
	var sx := 4.0
	var sy := -4.0 + breath * 0.5
	
	# Legs / dark trousers
	ci.draw_rect(Rect2(sx - 3.0, sy + 11.0, 4.0, 12.0), Color("202a24"))
	ci.draw_rect(Rect2(sx + 2.0, sy + 11.0, 4.0, 12.0), Color("1a241e"))
	ci.draw_rect(Rect2(sx - 3.0, sy + 22.0, 6.0, 3.0), Color("121814"))
	ci.draw_rect(Rect2(sx + 2.0, sy + 22.0, 6.0, 3.0), Color("121814"))
	
	# Torso: grey wool sweater, slightly slouched
	var torso_rect := Rect2(sx - 5.0, sy + 1.0, 11.0, 11.0)
	ci.draw_rect(torso_rect, Color("4a5c52"))
	ci.draw_rect(torso_rect, Color("5c7266", 0.6), false, 0.8)
	
	# Arms resting on knees
	ci.draw_line(Vector2(sx - 4.0, sy + 3.0), Vector2(sx - 2.0, sy + 11.0), Color("3e4e46"), 2.2)
	ci.draw_line(Vector2(sx + 5.0, sy + 3.0), Vector2(sx + 4.0, sy + 11.0), Color("3e4e46"), 2.2)
	# Hands
	ci.draw_circle(Vector2(sx - 2.0, sy + 11.0), 1.6, Color("c2a890"))
	ci.draw_circle(Vector2(sx + 4.0, sy + 11.0), 1.6, Color("c2a890"))
	
	# Head & grey hair (bowed slightly forward)
	ci.draw_circle(Vector2(sx, sy - 4.0), 3.8, Color("baa898"))
	ci.draw_circle(Vector2(sx - 0.5, sy - 5.5), 3.2, Color("7a8a82")) # Grey hair
	
	if p_is_activated:
		ci.draw_rect(Rect2(-19.0, -12.0, 38.0, 38.0), Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.18 + pulse * 0.18), false, 1.2)


static func draw_well_drawing(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Crayon drawing of the well on bedside wooden table: 28x22 px
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	
	# Small table top & leg
	var table_rect := Rect2(-14.0, 6.0, 28.0, 4.0)
	ci.draw_rect(table_rect, Color("342820"))
	ci.draw_line(Vector2(-10.0, 10.0), Vector2(-10.0, 20.0), Color("241c16"), 1.6)
	ci.draw_line(Vector2(10.0, 10.0), Vector2(10.0, 20.0), Color("241c16"), 1.6)
	
	# Drawing paper sheet (angled slightly)
	var paper_rect := Rect2(-11.0, -9.0, 22.0, 15.0)
	ci.draw_rect(paper_rect, Color("f2eee4"))
	ci.draw_rect(paper_rect, Color("d0c8b8", 0.8), false, 0.8)
	
	# Crayon drawing elements:
	# 1. High stone well with crank and bucket (blue/teal wax crayon)
	var well_box := Rect2(-8.0, -7.0, 9.0, 6.0)
	ci.draw_rect(well_box, Color("3a7082"))
	ci.draw_line(Vector2(-8.0, -7.0), Vector2(-3.5, -9.0), Color("785438"), 1.2) # Roof left
	ci.draw_line(Vector2(-3.5, -9.0), Vector2(1.0, -7.0), Color("785438"), 1.2) # Roof right
	ci.draw_line(Vector2(-3.5, -7.0), Vector2(-3.5, -4.0), Color("2a4450"), 0.8) # Chain
	
	# 2. Schoolhouse drawn lower on the page (red/brick crayon)
	var school_box := Rect2(1.0, -2.0, 8.0, 6.0)
	ci.draw_rect(school_box, Color("9e463e"))
	ci.draw_line(Vector2(1.0, -2.0), Vector2(5.0, -4.0), Color("6e2822"), 1.0)
	ci.draw_line(Vector2(5.0, -4.0), Vector2(9.0, -2.0), Color("6e2822"), 1.0)
	
	# 3. Erased signature in bottom-right corner (thinned, abraded paper texture)
	var erase_rect := Rect2(3.0, 2.0, 7.0, 3.5)
	ci.draw_rect(erase_rect, Color("e4dcce"))
	for e in range(3):
		var ex := 4.0 + float(e) * 2.0
		ci.draw_line(Vector2(ex, 3.0), Vector2(ex + 1.0, 4.5), Color("b0a696", 0.5), 0.6)
	
	if p_is_activated:
		ci.draw_rect(paper_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.22 + pulse * 0.20), false, 1.2)


static func draw_hydrology_report(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Official UCP Hydrology Report document on side desk: 24x20 px
	var pulse := sin(p_pulse * 1.7) * 0.5 + 0.5
	
	# Folder backboard
	var binder_rect := Rect2(-12.0, -9.0, 24.0, 18.0)
	ci.draw_rect(binder_rect, Color("202e28"))
	ci.draw_rect(binder_rect, Color("3a5246", 0.7), false, 0.9)
	
	# Official paper page
	var sheet_rect := Rect2(-10.0, -7.0, 20.0, 14.0)
	ci.draw_rect(sheet_rect, Color("e2ece6"))
	
	# Blue UCP institutional header bar
	ci.draw_rect(Rect2(-9.0, -6.0, 18.0, 2.5), Color("3a6078"))
	
	# Report content text lines
	ci.draw_line(Vector2(-8.0, -1.5), Vector2(6.0, -1.5), Color("4a5e54", 0.8), 0.8) # "RAPORT UJĘCIA WODY"
	ci.draw_line(Vector2(-8.0, 1.0), Vector2(4.0, 1.0), Color("2e7a5c", 0.9), 0.8) # "STATUS: NAPRAWIONE"
	
	# Cleared / blank reporting field (highlighted empty box)
	ci.draw_rect(Rect2(-8.0, 3.0, 14.0, 2.5), Color("cedad2"))
	ci.draw_rect(Rect2(-8.0, 3.0, 14.0, 2.5), Color("8aa094", 0.6), false, 0.6)
	
	# Official red/amber verification stamp
	ci.draw_circle(Vector2(6.0, 3.5), 1.8, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.75))
	
	if p_is_activated:
		ci.draw_rect(binder_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.20 + pulse * 0.18), false, 1.1)


static func draw_erased_signature_magnifier(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Articulating inspection lamp & magnifying glass: 24x26 px
	var pulse := sin(p_pulse * 2.1) * 0.5 + 0.5
	
	# Weighted base
	ci.draw_rect(Rect2(-8.0, 8.0, 16.0, 3.0), Color("222c28"))
	
	# Articulated arm
	ci.draw_line(Vector2(-4.0, 8.0), Vector2(-1.0, -2.0), Color("586a62"), 1.5)
	ci.draw_line(Vector2(-1.0, -2.0), Vector2(5.0, -8.0), Color("72867c"), 1.2)
	ci.draw_circle(Vector2(-1.0, -2.0), 1.5, Color("34423c"))
	
	# Magnifying glass rim & lens
	var lens_center := Vector2(7.0, -8.0)
	ci.draw_circle(lens_center, 6.5, Color("485c54")) # Metal rim
	ci.draw_circle(lens_center, 5.0, Color("d0e4dc", 0.75)) # Glass lens
	
	# Magnified micro-traces of graphite: faint "I g a"
	ci.draw_line(lens_center + Vector2(-3.0, -2.0), lens_center + Vector2(-3.0, 2.0), Color("6c7a72", 0.8), 0.9) # 'I'
	ci.draw_circle(lens_center + Vector2(-0.5, 0.5), 1.2, Color("6c7a72", 0.75)) # 'g'
	ci.draw_circle(lens_center + Vector2(2.5, 0.5), 1.1, Color("6c7a72", 0.75)) # 'a'
	
	# Glass glint
	ci.draw_line(lens_center + Vector2(-3.5, -3.5), lens_center + Vector2(1.0, -3.5), Color(1.0, 1.0, 1.0, 0.6), 0.8)
	
	if p_is_activated:
		ci.draw_circle(lens_center, 7.5, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.25 + pulse * 0.25))


static func draw_szymon_room_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy institutional isolation room sliding door to Space 21: 26x40 px
	# Noticeable structural shift of frame (shifted 3-4 cm laterally)
	var pulse := sin(p_pulse * 1.6) * 0.5 + 0.5
	
	# Outer frame (showing slight mechanical displacement)
	var frame_rect := Rect2(-13.0, -20.0, 26.0, 40.0)
	ci.draw_rect(frame_rect, Color("182420"))
	ci.draw_rect(frame_rect, Color("32443c", 0.75), false, 1.2)
	
	# Shift displacement seam lines on wall
	ci.draw_line(Vector2(-15.0, -18.0), Vector2(-15.0, 18.0), Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.5), 0.8)
	ci.draw_line(Vector2(15.0, -18.0), Vector2(15.0, 18.0), Color("283830"), 0.8)
	
	# Door leaf: cold institutional white-grey
	var leaf_rect := Rect2(-10.0, -18.0, 20.0, 36.0)
	ci.draw_rect(leaf_rect, Color("283832"))
	ci.draw_rect(leaf_rect, Color("445c50", 0.5), false, 0.9)
	
	# Vertical observation glass slit
	var slit_rect := Rect2(-2.0, -12.0, 4.0, 12.0)
	ci.draw_rect(slit_rect, Color("141e1a"))
	ci.draw_rect(slit_rect, Color("75c7c3", 0.4))
	
	# Lock bolt & status indicator
	ci.draw_rect(Rect2(-8.0, 6.0, 16.0, 4.0), Color("364a40"))
	
	# Placard: "SALA SZYMONA / 20"
	ci.draw_rect(Rect2(-9.0, -15.0, 18.0, 3.0), Color("1c2a24"))
	ci.draw_line(Vector2(-7.0, -13.5), Vector2(7.0, -13.5), Color("c4d4cc"), 0.7)
	
	if p_is_activated:
		# Unlocked / open: cyan glow, frame seam illuminated
		ci.draw_rect(frame_rect, COLOR_CYAN * 0.45, false, 1.4)
		ci.draw_line(Vector2(-13.0, 20.0), Vector2(13.0, 20.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.75 + pulse * 0.25), 2.0)
		ci.draw_rect(Rect2(-2.0, 6.0, 8.0, 4.0), Color("2e3e36"))
	else:
		# Locked
		ci.draw_circle(Vector2(4.0, 8.0), 1.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.45 + pulse * 0.25))


static func draw_szymon_post_correction(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Szymon Bera resting in clinical adaptive sedation recliner chair: 32x36 px
	# Calm, pacified posture post-procedure
	var pulse := sin(p_pulse * 1.5) * 0.5 + 0.5
	
	# Clinical recliner chair base & backrest
	var base_rect := Rect2(-14.0, 10.0, 28.0, 6.0)
	ci.draw_rect(base_rect, Color("1a2622"))
	ci.draw_line(Vector2(-12.0, 16.0), Vector2(-12.0, 20.0), Color("121c18"), 2.0)
	ci.draw_line(Vector2(12.0, 16.0), Vector2(12.0, 20.0), Color("121c18"), 2.0)
	
	# Angled padded recliner back (45 deg tilt)
	ci.draw_rect(Rect2(-12.0, -8.0, 24.0, 18.0), Color("263832"))
	ci.draw_rect(Rect2(-12.0, -8.0, 24.0, 18.0), Color("385046", 0.6), false, 0.9)
	ci.draw_rect(Rect2(-10.0, -14.0, 20.0, 8.0), Color("20302a")) # Headrest
	
	# Reclined human figure (Szymon Bera)
	# Torso in clinical hospital smock (soft muted grey-green)
	ci.draw_rect(Rect2(-8.0, -4.0, 16.0, 14.0), Color("6c8078"))
	ci.draw_rect(Rect2(-8.0, -4.0, 16.0, 14.0), Color("869e94", 0.4), false, 0.8)
	
	# Folded calm arms resting on armrests
	ci.draw_line(Vector2(-9.0, 2.0), Vector2(-4.0, 6.0), Color("566860"), 1.8)
	ci.draw_line(Vector2(9.0, 2.0), Vector2(4.0, 6.0), Color("566860"), 1.8)
	ci.draw_circle(Vector2(0.0, 6.0), 2.2, Color("a89886")) # Hands resting peacefully
	
	# Head resting back
	ci.draw_circle(Vector2(0.0, -9.0), 4.5, Color("b4a492")) # Head / face
	ci.draw_circle(Vector2(0.0, -11.0), 4.2, Color("706e68")) # Thin grey hair
	ci.draw_line(Vector2(-2.0, -9.0), Vector2(2.0, -9.0), Color("443c34"), 0.8) # Closed/calm eyes
	
	# Neuro-sedation sensor cannula on right temple (soft cyan glow lead)
	ci.draw_circle(Vector2(3.5, -9.5), 1.2, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.75 + pulse * 0.25))
	ci.draw_line(Vector2(4.5, -9.5), Vector2(12.0, -12.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.4 + pulse * 0.3), 0.7)
	
	if p_is_activated:
		ci.draw_rect(Rect2(-15.0, -16.0, 30.0, 34.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.18 + pulse * 0.18), false, 1.2)


static func draw_anesthesia_terminal(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# UCP Sedation & Neuro-Adaptation Console: 26x34 px
	var pulse := sin(p_pulse * 2.2) * 0.5 + 0.5
	
	# Main rack column (dark clinical steel)
	var rack_rect := Rect2(-12.0, -16.0, 24.0, 32.0)
	ci.draw_rect(rack_rect, Color("142022"))
	ci.draw_rect(rack_rect, Color("2a3e40", 0.8), false, 1.0)
	
	# CRT Vitals & Sedation Waveform Display
	var crt_rect := Rect2(-9.0, -13.0, 18.0, 12.0)
	ci.draw_rect(crt_rect, Color("0a1214"))
	ci.draw_rect(crt_rect, Color("204448", 0.6), false, 0.8)
	
	# Flatlined panic trace -> smooth gentle sine rhythm
	var wave_color := Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.85)
	for i in range(16):
		var x1 := -8.0 + float(i)
		var x2 := -8.0 + float(i + 1)
		var y1 := -7.0 + sin((float(i) + p_pulse * 4.0) * 0.6) * 2.0
		var y2 := -7.0 + sin((float(i + 1) + p_pulse * 4.0) * 0.6) * 2.0
		ci.draw_line(Vector2(x1, y1), Vector2(x2, y2), wave_color, 0.9)
	
	# Status readout LED matrix
	ci.draw_rect(Rect2(-9.0, 1.0, 18.0, 3.0), Color("122426"))
	ci.draw_line(Vector2(-7.0, 2.5), Vector2(5.0, 2.5), Color("75c7c3", 0.7), 0.7) # "STABILNOŚĆ: 99.8%"
	
	# Control switches and status lamps
	ci.draw_circle(Vector2(-6.0, 7.0), 1.5, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.85)) # Active green/cyan lamp
	ci.draw_circle(Vector2(0.0, 7.0), 1.5, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.60)) # Sedation ready
	ci.draw_circle(Vector2(6.0, 7.0), 1.5, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.25)) # Panic suppressed
	
	# Conduit cable feeding to recliner
	ci.draw_line(Vector2(8.0, 12.0), Vector2(14.0, 14.0), Color("34484c"), 1.4)
	
	if p_is_activated:
		ci.draw_rect(rack_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.20 + pulse * 0.20), false, 1.2)


static func draw_filtered_dossier_slot(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Recessed pneumatic wall cassette with official sanitized entry: 22x26 px
	# ("SKORZYSTANO Z RAPORTU HYDROLOGICZNEGO / AUTOR: ANONIMOWY")
	var pulse := sin(p_pulse * 1.8) * 0.5 + 0.5
	
	# Recessed wall box
	var box_rect := Rect2(-11.0, -13.0, 22.0, 26.0)
	ci.draw_rect(box_rect, Color("1c2824"))
	ci.draw_rect(box_rect, Color("344840", 0.8), false, 1.0)
	
	# Transparent plexiglass document slot
	var slot_rect := Rect2(-8.0, -10.0, 16.0, 20.0)
	ci.draw_rect(slot_rect, Color("263832", 0.9))
	ci.draw_rect(slot_rect, Color("48665a", 0.6), false, 0.8)
	
	# Document sheet
	var doc_rect := Rect2(-6.0, -8.0, 12.0, 16.0)
	ci.draw_rect(doc_rect, Color("e4eae6"))
	
	# UCP blue header
	ci.draw_rect(Rect2(-5.0, -7.0, 10.0, 2.0), Color("3a5e78"))
	
	# Sanitized report lines
	ci.draw_line(Vector2(-5.0, -3.5), Vector2(3.0, -3.5), Color("42564c", 0.8), 0.7) # Text
	ci.draw_line(Vector2(-5.0, -1.5), Vector2(4.0, -1.5), Color("2e7a5c", 0.9), 0.7) # "STATUS: SPÓJNY"
	
	# Erased author field (grayed out blank box)
	ci.draw_rect(Rect2(-5.0, 1.0, 10.0, 2.0), Color("c4d0c8"))
	
	# Red/amber UCP archive stamp
	ci.draw_circle(Vector2(2.5, 4.5), 1.6, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.8))
	
	if p_is_activated:
		ci.draw_rect(box_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.22 + pulse * 0.20), false, 1.2)


static func draw_drawing_disposition_pedestal(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Metal evidence display stand holding drawing or blank disposition: 24x28 px
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	
	# Pedestal column and weighted foot
	ci.draw_rect(Rect2(-8.0, 10.0, 16.0, 4.0), Color("22302a"))
	ci.draw_line(Vector2(0.0, 10.0), Vector2(0.0, -4.0), Color("384e44"), 2.2)
	
	# Angled display table plate
	ci.draw_line(Vector2(-11.0, -4.0), Vector2(11.0, -8.0), Color("4c685c"), 1.8)
	
	# Drawing paper sheet resting on top
	var sheet_center := Vector2(0.0, -8.0)
	var paper_rect := Rect2(-9.0, -14.0, 18.0, 10.0)
	ci.draw_rect(paper_rect, Color("f0ece2"))
	ci.draw_rect(paper_rect, Color("d0c8b6", 0.8), false, 0.7)
	
	# Crayon drawing micro-traces (Well & School)
	ci.draw_rect(Rect2(-7.0, -12.5, 6.0, 4.0), Color("3a7082")) # Blue well
	ci.draw_rect(Rect2(1.0, -10.0, 6.0, 4.0), Color("9e463e")) # Red school
	
	# Thinned blank signature spot glowing with loss
	ci.draw_rect(Rect2(2.0, -6.5, 5.0, 2.5), Color("e2dac8"))
	ci.draw_circle(Vector2(4.5, -5.2), 1.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.4 + pulse * 0.35))
	
	if p_is_activated:
		ci.draw_rect(paper_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.25 + pulse * 0.25), false, 1.2)


static func draw_station_21_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy automated pressurized sliding airlock gate to Space 22 (Uległość): 28x44 px
	var pulse := sin(p_pulse * 1.6) * 0.5 + 0.5
	
	# Outer frame
	var frame_rect := Rect2(-14.0, -22.0, 28.0, 44.0)
	ci.draw_rect(frame_rect, Color("16201e"))
	ci.draw_rect(frame_rect, Color("2e423a", 0.8), false, 1.2)
	
	# Twin sliding door leaves
	var leaf_left := Rect2(-11.0, -19.0, 10.0, 38.0)
	var leaf_right := Rect2(1.0, -19.0, 10.0, 38.0)
	ci.draw_rect(leaf_left, Color("22322c"))
	ci.draw_rect(leaf_right, Color("22322c"))
	ci.draw_rect(leaf_left, Color("3a5046", 0.5), false, 0.8)
	ci.draw_rect(leaf_right, Color("3a5046", 0.5), false, 0.8)
	
	# Center compression seam
	ci.draw_line(Vector2(0.0, -19.0), Vector2(0.0, 19.0), Color("141e1a"), 1.5)
	
	# Top illuminated indicator bar: "STREFA TRANZYTOWA / 22"
	ci.draw_rect(Rect2(-10.0, -17.0, 20.0, 3.5), Color("182620"))
	ci.draw_line(Vector2(-8.0, -15.2), Vector2(8.0, -15.2), Color("a0b8ac"), 0.7)
	
	# Observation glass slit
	ci.draw_rect(Rect2(-2.0, -11.0, 4.0, 10.0), Color("0e1614"))
	ci.draw_rect(Rect2(-2.0, -11.0, 4.0, 10.0), Color("75c7c3", 0.4))
	
	if p_is_activated:
		# Unlocked / cycling open
		ci.draw_rect(frame_rect, COLOR_CYAN * 0.5, false, 1.4)
		ci.draw_line(Vector2(-14.0, 22.0), Vector2(14.0, 22.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.8 + pulse * 0.2), 2.0)
		ci.draw_line(Vector2(-1.0, -19.0), Vector2(-1.0, 19.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.6), 1.0)
	else:
		# Locked
		ci.draw_circle(Vector2(0.0, 6.0), 1.5, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.45 + pulse * 0.25))


static func draw_biometric_identity_gate(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Massive biometric transit portal in Compliance Point 6: 32x52 px
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	
	# Portal pillar frames (left and right columns)
	var col_left := Rect2(-16.0, -26.0, 6.0, 52.0)
	var col_right := Rect2(10.0, -26.0, 6.0, 52.0)
	ci.draw_rect(col_left, Color("141e20"))
	ci.draw_rect(col_right, Color("141e20"))
	ci.draw_rect(col_left, Color("2a3c3e", 0.8), false, 1.0)
	ci.draw_rect(col_right, Color("2a3c3e", 0.8), false, 1.0)
	
	# Top lintel with identification readout
	var lintel := Rect2(-16.0, -26.0, 32.0, 8.0)
	ci.draw_rect(lintel, Color("1a2628"))
	ci.draw_rect(lintel, Color("344c50", 0.7), false, 1.0)
	# Readout text / glow line: "LENA W. / 17-D"
	ci.draw_line(Vector2(-12.0, -22.0), Vector2(12.0, -22.0), Color("d4a359", 0.75), 1.0)
	
	# Central optical scanning field / palm contour platen
	var platen_rect := Rect2(-9.0, -8.0, 18.0, 24.0)
	ci.draw_rect(platen_rect, Color("0e1618"))
	ci.draw_rect(platen_rect, Color("22363a", 0.9), false, 0.8)
	
	# Palm contour graphic (etched silhouette)
	var palm_color := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.35 + pulse * 0.35)
	if p_is_activated:
		palm_color = Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.85 + pulse * 0.15)
	
	# Palm base
	ci.draw_circle(Vector2(0.0, 5.0), 4.5, palm_color * 0.7)
	# 5 fingers contour lines
	ci.draw_line(Vector2(-4.0, 2.0), Vector2(-6.0, -4.0), palm_color, 1.0) # Thumb
	ci.draw_line(Vector2(-2.5, 1.0), Vector2(-3.0, -6.5), palm_color, 1.0) # Index
	ci.draw_line(Vector2(0.0, 1.0), Vector2(0.0, -7.5), palm_color, 1.0)   # Middle
	ci.draw_line(Vector2(2.5, 1.0), Vector2(3.0, -6.5), palm_color, 1.0)   # Ring
	ci.draw_line(Vector2(4.5, 2.0), Vector2(5.5, -4.0), palm_color, 1.0)   # Little
	
	# Scanning laser horizontal line sweeping vertically
	var scan_y := -7.0 + sin(p_pulse * 3.5) * 10.0
	var laser_color := Color("75c7c3", 0.7) if p_is_activated else Color("d4a359", 0.6)
	ci.draw_line(Vector2(-8.0, scan_y), Vector2(8.0, scan_y), laser_color, 1.2)
	
	# Floor mounting plate
	ci.draw_line(Vector2(-18.0, 26.0), Vector2(18.0, 26.0), Color("3a4e52"), 2.0)
	
	if p_is_activated:
		# Authorization active bloom
		ci.draw_rect(Rect2(-16.0, -26.0, 32.0, 52.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.15 + pulse * 0.20), false, 1.5)


static func draw_compliance_contact_register(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Compliance Point 6 emergency contact authorization terminal: 28x32 px
	# ("KONTAKT ALARMOWY: MARTA KUREK / STATUS: ZWERYFIKOWANA WIĘŹ")
	var pulse := sin(p_pulse * 2.2) * 0.5 + 0.5
	
	# Pedestal stand
	ci.draw_rect(Rect2(-6.0, 10.0, 12.0, 6.0), Color("182426"))
	ci.draw_line(Vector2(0.0, 10.0), Vector2(0.0, 0.0), Color("2e4246"), 2.4)
	
	# Angled CRT housing
	var housing_rect := Rect2(-14.0, -16.0, 28.0, 20.0)
	ci.draw_rect(housing_rect, Color("142022"))
	ci.draw_rect(housing_rect, Color("2d4044", 0.8), false, 1.0)
	
	# CRT Screen (Warm amber institutional phosphor)
	var screen_rect := Rect2(-11.0, -13.0, 22.0, 12.0)
	ci.draw_rect(screen_rect, Color("121410"))
	ci.draw_rect(screen_rect, Color("3a3820", 0.8), false, 0.8)
	
	# Screen text scanlines (Simulating "MARTA KUREK / KONTAKT")
	var line_color := Color("d4a359", 0.85)
	ci.draw_line(Vector2(-9.0, -10.0), Vector2(7.0, -10.0), line_color, 0.8) # "KONTAKT: MARTA K."
	ci.draw_line(Vector2(-9.0, -7.0), Vector2(3.0, -7.0), Color("a8b2ac", 0.7), 0.7)  # "STATUS: ZGŁOSZENIE"
	ci.draw_line(Vector2(-9.0, -4.0), Vector2(8.0, -4.0), Color("75c7c3", 0.8), 0.8)  # "AUTORYZACJA: ZGODNA"
	
	# Blinking cursor
	if int(p_pulse * 3.0) % 2 == 0:
		ci.draw_rect(Rect2(5.0, -8.0, 2.0, 2.5), Color("d4a359"))
	
	# Keyboard tray
	var kbd_rect := Rect2(-12.0, 4.0, 24.0, 5.0)
	ci.draw_rect(kbd_rect, Color("1c282a"))
	ci.draw_line(Vector2(-10.0, 6.5), Vector2(10.0, 6.5), Color("3e565a"), 1.0)
	
	# Status verification LED
	var led_color := Color("6db3a8") if p_is_activated else Color("d4a359", 0.6 + pulse * 0.4)
	ci.draw_circle(Vector2(9.0, 6.5), 1.4, led_color)
	
	if p_is_activated:
		ci.draw_rect(housing_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.22 + pulse * 0.22), false, 1.2)


static func draw_ring_fitting_scanner(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Gold wedding ring relational verification scanner: 26x30 px
	var pulse := sin(p_pulse * 2.4) * 0.5 + 0.5
	
	# Console body
	var console_rect := Rect2(-12.0, -14.0, 24.0, 26.0)
	ci.draw_rect(console_rect, Color("162224"))
	ci.draw_rect(console_rect, Color("2d4044", 0.8), false, 1.0)
	
	# Circular inductive scanner basin (Copper / gold ring socket)
	var basin_center := Vector2(0.0, -3.0)
	ci.draw_circle(basin_center, 8.0, Color("0f181a"))
	ci.draw_circle(basin_center, 8.0, Color("344e52", 0.7), false, 0.8)
	
	# Concentric inductive loops
	ci.draw_circle(basin_center, 5.5, Color("4a3c20", 0.8), false, 0.8)
	
	# Golden ring representation in socket
	var ring_color := Color("d4a359", 0.7 + pulse * 0.3)
	if p_is_activated:
		ring_color = Color("e8c07a", 0.95)
	ci.draw_circle(basin_center, 3.8, ring_color, false, 1.4)
	
	# Relational micro-resonance emission rays
	if p_is_activated or p_in_range:
		for r in range(6):
			var angle := float(r) * (TAU / 6.0) + p_pulse * 1.5
			var r_start := basin_center + Vector2(cos(angle), sin(angle)) * 4.5
			var r_end := basin_center + Vector2(cos(angle), sin(angle)) * (7.0 + pulse * 2.5)
			ci.draw_line(r_start, r_end, Color("d4a359", 0.4 + pulse * 0.4), 0.9)
	
	# Lower status readout
	ci.draw_rect(Rect2(-8.0, 6.0, 16.0, 3.5), Color("101a1c"))
	ci.draw_line(Vector2(-6.0, 7.7), Vector2(6.0, 7.7), Color("e8c07a", 0.8), 0.8)
	
	if p_is_activated:
		ci.draw_rect(console_rect, Color("d4a359", 0.25 + pulse * 0.25), false, 1.2)


static func draw_paint_resin_resonance_slab(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Sensory memory recall slab: Emulsion paint smell & biographical erasure: 28x34 px
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	
	# Base mounting slab (institutional wall panel)
	var slab_rect := Rect2(-14.0, -16.0, 28.0, 32.0)
	ci.draw_rect(slab_rect, Color("1a2426"))
	ci.draw_rect(slab_rect, Color("304448", 0.8), false, 1.0)
	
	# Upper section: Fresh emulsion paint swatch (Apartment 14 memory)
	var paint_swatch := Rect2(-11.0, -13.0, 22.0, 13.0)
	ci.draw_rect(paint_swatch, Color("dcd8cc")) # Warm matte emulsion paint
	ci.draw_rect(paint_swatch, Color("b8b2a2", 0.8), false, 0.7)
	
	# Texture of roller stroke across the paint
	ci.draw_line(Vector2(-9.0, -9.0), Vector2(7.0, -9.0), Color("ece8dc", 0.9), 1.5)
	ci.draw_line(Vector2(-7.0, -6.0), Vector2(9.0, -6.0), Color("c8c2b0", 0.8), 1.2)
	
	# Micro-particles / solvent vapor bloom rising from paint
	var vapor_alpha := 0.25 + pulse * 0.35
	for v in range(3):
		var vy := -15.0 - float(v) * 3.0 - sin(p_pulse * 2.0 + float(v)) * 2.0
		var vx := -5.0 + float(v) * 5.0 + cos(p_pulse * 1.5 + float(v)) * 2.0
		ci.draw_circle(Vector2(vx, vy), 1.2, Color("d4a359", vapor_alpha))
	
	# Lower section: Biographical erasure slot (Silhouette of nurse's cap with erased face)
	var photo_rect := Rect2(-11.0, 2.0, 22.0, 12.0)
	ci.draw_rect(photo_rect, Color("12181a"))
	ci.draw_rect(photo_rect, Color("223034", 0.8), false, 0.7)
	
	# Nurse's white medical cap outline
	ci.draw_line(Vector2(-5.0, 5.0), Vector2(5.0, 5.0), Color("c8d4d0", 0.7), 1.0)
	ci.draw_line(Vector2(-5.0, 5.0), Vector2(0.0, 3.5), Color("c8d4d0", 0.7), 1.0)
	ci.draw_line(Vector2(5.0, 5.0), Vector2(0.0, 3.5), Color("c8d4d0", 0.7), 1.0)
	
	# Erased face: White/gray empty glowing blank void
	var void_color := Color("5a6b68", 0.7 + pulse * 0.3)
	if p_is_activated:
		void_color = Color("94a6a2", 0.9)
	ci.draw_circle(Vector2(0.0, 8.5), 3.0, void_color)
	ci.draw_circle(Vector2(0.0, 8.5), 1.8, Color("dcebe6", 0.6))
	
	if p_is_activated:
		ci.draw_rect(slab_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.25 + pulse * 0.25), false, 1.2)


static func draw_station_22_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy transit portal leading to Space 23 (Pokój projektantki): 30x48 px
	var pulse := sin(p_pulse * 1.8) * 0.5 + 0.5
	
	# Main portal frame
	var frame_rect := Rect2(-15.0, -24.0, 30.0, 48.0)
	ci.draw_rect(frame_rect, Color("141e20"))
	ci.draw_rect(frame_rect, Color("2c3e42", 0.85), false, 1.2)
	
	# Heavy copper & steel door leaves
	var door_left := Rect2(-12.0, -21.0, 11.0, 42.0)
	var door_right := Rect2(1.0, -21.0, 11.0, 42.0)
	ci.draw_rect(door_left, Color("1c2a2c"))
	ci.draw_rect(door_right, Color("1c2a2c"))
	ci.draw_rect(door_left, Color("344a4e", 0.6), false, 0.8)
	ci.draw_rect(door_right, Color("344a4e", 0.6), false, 0.8)
	
	# Vertical locking seam
	ci.draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("101618"), 1.5)
	
	# Top archive placard: "23 / PROJEKTANTKA — ARCHIWUM"
	ci.draw_rect(Rect2(-11.0, -19.0, 22.0, 4.0), Color("121a1c"))
	ci.draw_line(Vector2(-9.0, -17.0), Vector2(9.0, -17.0), Color("d4a359", 0.75), 0.8)
	
	# Observation viewport window (showing warm amber monitors in Room 23)
	var view_rect := Rect2(-3.0, -12.0, 6.0, 12.0)
	ci.draw_rect(view_rect, Color("0a1012"))
	ci.draw_rect(view_rect, Color("d4a359", 0.35 if not p_is_activated else 0.75))
	
	if p_is_activated:
		# Unlocked & cycling open
		ci.draw_rect(frame_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45 + pulse * 0.25), false, 1.5)
		ci.draw_line(Vector2(-15.0, 24.0), Vector2(15.0, 24.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.9), 2.0)
		ci.draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("6db3a8", 0.8), 1.0)
	else:
		# Locked / magnetic clamp active
		ci.draw_circle(Vector2(0.0, 8.0), 1.6, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.5 + pulse * 0.3))


static func draw_designer_terminal(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Local Lena's workstation CRT terminal & pattern overwrite station: 34x32 px
	var pulse := sin(p_pulse * 2.2) * 0.5 + 0.5
	
	# Heavy drafting desk & terminal chassis
	var desk_rect := Rect2(-17.0, -10.0, 34.0, 24.0)
	ci.draw_rect(desk_rect, Color("141d1f"))
	ci.draw_rect(desk_rect, Color("2a3c3e", 0.85), false, 1.0)
	
	# Copper cooling ribs / heat sinks on side
	for r in range(4):
		var rx := -15.0 + float(r) * 2.5
		ci.draw_line(Vector2(rx, 4.0), Vector2(rx, 12.0), Color("a67238", 0.7), 0.8)
	
	# Main CRT Monitor housing
	var crt_housing := Rect2(-14.0, -16.0, 28.0, 18.0)
	ci.draw_rect(crt_housing, Color("182326"))
	ci.draw_rect(crt_housing, Color("344c50", 0.9), false, 1.0)
	
	# Curved CRT screen (amber / sage phosphor)
	var screen_rect := Rect2(-12.0, -14.0, 24.0, 14.0)
	var screen_bg := Color("0d1517")
	ci.draw_rect(screen_rect, screen_bg)
	
	# CRT phosphor raster scanlines
	var crt_glow := Color("d9a05b", 0.65 + pulse * 0.35) if p_is_activated else Color("68b8a5", 0.55 + pulse * 0.25)
	for y in range(4):
		var sy := -12.0 + float(y) * 3.0
		ci.draw_line(Vector2(-10.0, sy), Vector2(10.0, sy), Color(crt_glow.r, crt_glow.g, crt_glow.b, 0.3), 0.6)
	
	# District pattern failure map / grid traces
	ci.draw_line(Vector2(-8.0, -11.0), Vector2(-2.0, -11.0), crt_glow, 1.0)
	ci.draw_line(Vector2(-2.0, -11.0), Vector2(2.0, -7.0), crt_glow, 1.0)
	ci.draw_line(Vector2(2.0, -7.0), Vector2(8.0, -7.0), crt_glow, 1.0)
	ci.draw_circle(Vector2(2.0, -7.0), 1.4, Color("c65d58", 0.8 + pulse * 0.2)) # Failure hotspot
	
	# Active status indicator LED
	ci.draw_circle(Vector2(11.0, 10.0), 1.2, Color("e8c07a", 0.8 + pulse * 0.2) if p_is_activated else Color("5a7a72", 0.6))
	
	if p_is_activated or p_in_range:
		ci.draw_rect(crt_housing, Color("d9a05b", 0.35 + pulse * 0.25), false, 1.2)


static func draw_substructure_architectural_model(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# 3D Wireframe physical model of Podstruktura skeleton with handwritten note: 32x34 px
	var pulse := sin(p_pulse * 1.9) * 0.5 + 0.5
	
	# Heavy circular acrylic & cast iron base pedestal
	var base_rect := Rect2(-16.0, 4.0, 32.0, 12.0)
	ci.draw_rect(base_rect, Color("162022"))
	ci.draw_rect(base_rect, Color("2d4044", 0.85), false, 1.0)
	
	# Acrylic transparent dome / column
	var dome_rect := Rect2(-13.0, -16.0, 26.0, 20.0)
	ci.draw_rect(dome_rect, Color("101a1c", 0.6))
	ci.draw_rect(dome_rect, Color("3a5458", 0.5), false, 0.8)
	
	# Multi-tier Podstruktura conduit skeleton (Copper wire lattice)
	var copper_wire := Color("d9a05b", 0.85 + pulse * 0.15)
	# Upper platform
	ci.draw_line(Vector2(-8.0, -13.0), Vector2(8.0, -13.0), copper_wire, 1.2)
	# Intermediate transit ring
	ci.draw_line(Vector2(-10.0, -7.0), Vector2(10.0, -7.0), copper_wire, 1.0)
	# Lower foundation hub
	ci.draw_line(Vector2(-7.0, -1.0), Vector2(7.0, -1.0), copper_wire, 1.2)
	
	# Vertical interconnecting conduits
	ci.draw_line(Vector2(-6.0, -13.0), Vector2(-8.0, -7.0), copper_wire, 0.9)
	ci.draw_line(Vector2(6.0, -13.0), Vector2(8.0, -7.0), copper_wire, 0.9)
	ci.draw_line(Vector2(-8.0, -7.0), Vector2(-5.0, -1.0), copper_wire, 0.9)
	ci.draw_line(Vector2(8.0, -7.0), Vector2(5.0, -1.0), copper_wire, 0.9)
	ci.draw_line(Vector2(0.0, -13.0), Vector2(0.0, -1.0), Color("75c7c3", 0.75), 0.9) # Central correlation axis
	
	# Handwritten paper note on stand: "JEŚLI TO CZYTASZ, ZGODZIŁAM SIĘ NA TWOJE RYZYKO"
	var note_rect := Rect2(-11.0, 6.0, 22.0, 8.0)
	ci.draw_rect(note_rect, Color("ded9cb")) # Aged archival paper
	ci.draw_rect(note_rect, Color("9e9582", 0.8), false, 0.7)
	# Inscribed text lines
	ci.draw_line(Vector2(-9.0, 8.5), Vector2(7.0, 8.5), Color("24221d", 0.85), 0.9)
	ci.draw_line(Vector2(-8.0, 11.5), Vector2(9.0, 11.5), Color("a67238", 0.9), 0.9)
	
	if p_is_activated or p_in_range:
		ci.draw_rect(dome_rect, Color("e8c07a", 0.35 + pulse * 0.35), false, 1.2)
		ci.draw_circle(Vector2(0.0, -7.0), 2.0, Color("75c7c3", 0.9))


static func draw_burdened_persons_ledger(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Archive rack of burdened citizens ledger / contradiction debt index: 26x36 px
	var pulse := sin(p_pulse * 2.5) * 0.5 + 0.5
	
	# Steel archive cabinet chassis
	var cab_rect := Rect2(-13.0, -18.0, 26.0, 36.0)
	ci.draw_rect(cab_rect, Color("141c1e"))
	ci.draw_rect(cab_rect, Color("28393d", 0.85), false, 1.0)
	
	# Vertical index dossier trays (4 slots)
	for s in range(4):
		var sy := -14.0 + float(s) * 8.0
		var slot_rect := Rect2(-10.0, sy, 20.0, 6.0)
		ci.draw_rect(slot_rect, Color("1b2628"))
		ci.draw_rect(slot_rect, Color("384e52", 0.7), false, 0.8)
		
		# Dossier tab indicator
		var tab_color := Color("d9a05b", 0.75) if s == 2 else Color("5a7572", 0.6)
		ci.draw_rect(Rect2(-8.0, sy + 1.5, 4.0, 3.0), tab_color)
		ci.draw_line(Vector2(-2.0, sy + 3.0), Vector2(7.0, sy + 3.0), Color("a8b2ac", 0.5), 0.8)
	
	# Upper digital status readout: "OSOBY OBCIĄŻONE: 11 / W TOKU"
	ci.draw_rect(Rect2(-9.0, -16.5, 18.0, 3.0), Color("0d1314"))
	ci.draw_line(Vector2(-7.0, -15.0), Vector2(7.0, -15.0), Color("75c7c3", 0.75 + pulse * 0.25), 0.8)
	
	if p_is_activated or p_in_range:
		ci.draw_rect(cab_rect, Color("75c7c3", 0.3 + pulse * 0.3), false, 1.2)


static func draw_shadow_interactive_console(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Shadow interactive console with displaced cursor mechanic (D-16): 30x32 px
	var pulse := sin(p_pulse * 3.0) * 0.5 + 0.5
	
	# Console housing
	var housing_rect := Rect2(-15.0, -16.0, 30.0, 32.0)
	ci.draw_rect(housing_rect, Color("121a1c"))
	ci.draw_rect(housing_rect, Color("2d4044", 0.9), false, 1.0)
	
	# CRT Screen displaying command interface
	var screen_rect := Rect2(-12.0, -13.0, 24.0, 18.0)
	ci.draw_rect(screen_rect, Color("0a1214"))
	ci.draw_rect(screen_rect, Color("203336", 0.8), false, 0.8)
	
	# Top Header: "POLECENIE: NADPISZ WZORZEC"
	ci.draw_line(Vector2(-10.0, -10.0), Vector2(6.0, -10.0), Color("68b8a5", 0.75), 0.9)
	
	# Middle Section: "OSOBY OBCIĄŻONE" list item
	ci.draw_line(Vector2(-10.0, -5.0), Vector2(8.0, -5.0), Color("d9a05b", 0.85), 0.9)
	
	# Empty slot line (Line without name):
	ci.draw_line(Vector2(-10.0, 0.0), Vector2(-2.0, 0.0), Color("c65d58", 0.65), 0.8)
	
	# Displaced Shadow Cursor (Cyan blinking square jumping away from command)
	var cursor_pos := Vector2(4.0, 0.0) if p_is_activated else Vector2(8.0, -10.0)
	var cursor_color := Color("75c7c3", 0.85 + pulse * 0.15)
	ci.draw_rect(Rect2(cursor_pos.x - 1.5, cursor_pos.y - 1.5, 3.0, 3.0), cursor_color)
	
	# Ghost cursor displacement trail / interference rings
	if p_is_activated or p_in_range:
		ci.draw_circle(cursor_pos, 3.5 + pulse * 2.0, Color("75c7c3", 0.35 - pulse * 0.2), false, 0.8)
		# Ghost vector arrow from command to empty slot
		ci.draw_line(Vector2(6.0, -8.0), Vector2(4.0, -2.0), Color("d9a05b", 0.5 + pulse * 0.3), 0.8)
	
	# Lower mechanical key switches
	ci.draw_rect(Rect2(-12.0, 8.0, 24.0, 5.0), Color("182326"))
	for k in range(5):
		var kx := -9.0 + float(k) * 4.5
		ci.draw_rect(Rect2(kx, 9.0, 3.0, 3.0), Color("344c50"))
	
	if p_is_activated:
		ci.draw_rect(housing_rect, Color("d9a05b", 0.35 + pulse * 0.35), false, 1.2)


static func draw_station_23_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy transit airlock portal leading to Space 24 (Marta under observation): 30x48 px
	var pulse := sin(p_pulse * 1.8) * 0.5 + 0.5
	
	# Main portal frame
	var frame_rect := Rect2(-15.0, -24.0, 30.0, 48.0)
	ci.draw_rect(frame_rect, Color("141e20"))
	ci.draw_rect(frame_rect, Color("2c3e42", 0.85), false, 1.2)
	
	# Heavy copper & steel door leaves
	var door_left := Rect2(-12.0, -21.0, 11.0, 42.0)
	var door_right := Rect2(1.0, -21.0, 11.0, 42.0)
	ci.draw_rect(door_left, Color("1c2a2c"))
	ci.draw_rect(door_right, Color("1c2a2c"))
	ci.draw_rect(door_left, Color("344a4e", 0.6), false, 0.8)
	ci.draw_rect(door_right, Color("344a4e", 0.6), false, 0.8)
	
	# Vertical locking seam
	ci.draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("101618"), 1.5)
	
	# Top archive placard: "24 / OBSERWACJA — MARTA"
	ci.draw_rect(Rect2(-11.0, -19.0, 22.0, 4.0), Color("121a1c"))
	ci.draw_line(Vector2(-9.0, -17.0), Vector2(9.0, -17.0), Color("d4a359", 0.75), 0.8)
	
	# Observation viewport window showing surveillance CRT amber glow
	var view_rect := Rect2(-3.0, -12.0, 6.0, 12.0)
	ci.draw_rect(view_rect, Color("0a1012"))
	ci.draw_rect(view_rect, Color("d4a359", 0.35 if not p_is_activated else 0.85))
	
	if p_is_activated:
		# Unlocked & cycling open
		ci.draw_rect(frame_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45 + pulse * 0.25), false, 1.5)
		ci.draw_line(Vector2(-15.0, 24.0), Vector2(15.0, 24.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.9), 2.0)
		ci.draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("6db3a8", 0.8), 1.0)
	else:
		# Locked / magnetic clamp active
		ci.draw_circle(Vector2(0.0, 8.0), 1.6, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.5 + pulse * 0.3))


static func draw_cctv_surveillance_array(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Multi-screen CCTV surveillance video wall displaying direct feed from Apartment 14 (38x42 px)
	var pulse := sin(p_pulse * 2.6) * 0.5 + 0.5
	
	# Metal surveillance rack frame
	var rack_rect := Rect2(-19.0, -21.0, 38.0, 42.0)
	ci.draw_rect(rack_rect, Color("10171a"))
	ci.draw_rect(rack_rect, Color("22363e", 0.9), false, 1.2)
	
	# Top main surveillance monitor (Apartment 14 living room: 32x22 px)
	var main_monitor := Rect2(-16.0, -18.0, 32.0, 22.0)
	ci.draw_rect(main_monitor, Color("081114"))
	ci.draw_rect(main_monitor, Color("36535e", 0.85), false, 1.0)
	
	# CRT Scanlines & green-cyan phosphor raster glow
	var crt_color := Color("4f8f8b", 0.45 + pulse * 0.25)
	for y in range(5):
		var sy := -16.0 + float(y) * 4.0
		ci.draw_line(Vector2(-14.0, sy), Vector2(14.0, sy), Color(crt_color.r, crt_color.g, crt_color.b, 0.25), 0.6)
	
	# Silhouette of Marta packing her toolbag on the table (at x=-2, y=-8)
	ci.draw_rect(Rect2(-7.0, -10.0, 5.0, 7.0), Color("d39a62", 0.75)) # Marta's torso & amber coat
	ci.draw_circle(Vector2(-4.5, -12.0), 2.0, Color("d39a62", 0.85)) # Marta's head
	ci.draw_rect(Rect2(-1.0, -9.0, 4.0, 5.0), Color("8a6642", 0.85)) # Toolbag
	ci.draw_line(Vector2(-11.0, -4.0), Vector2(8.0, -4.0), Color("56767e", 0.8), 1.2) # Table surface
	
	# Background trembling furniture / cinnabar distortion wave in Apt 14
	var stress_jitter := sin(p_pulse * 12.0) * 1.2
	ci.draw_line(Vector2(4.0 + stress_jitter, -16.0), Vector2(12.0 + stress_jitter, -16.0), Color("d96b52", 0.65 + pulse * 0.35), 0.9)
	ci.draw_line(Vector2(12.0 + stress_jitter, -16.0), Vector2(12.0, -4.0), Color("d96b52", 0.65 + pulse * 0.35), 0.9)
	
	# Timestamp & Camera ID: "CAM-14: MIESZKANIE 14 / LIVE"
	ci.draw_rect(Rect2(-14.0, -17.0, 10.0, 2.0), Color("d96b52", 0.85 + pulse * 0.15))
	
	# Two lower auxiliary telemetry monitors (Left: Signal strength, Right: Spatial variance)
	var aux_left := Rect2(-16.0, 6.0, 15.0, 12.0)
	var aux_right := Rect2(1.0, 6.0, 15.0, 12.0)
	ci.draw_rect(aux_left, Color("081114"))
	ci.draw_rect(aux_right, Color("081114"))
	ci.draw_rect(aux_left, Color("2d4650", 0.7), false, 0.8)
	ci.draw_rect(aux_right, Color("2d4650", 0.7), false, 0.8)
	
	# Aux waveforms
	ci.draw_line(Vector2(-14.0, 12.0), Vector2(-10.0, 9.0), Color("4f8f8b", 0.7), 0.8)
	ci.draw_line(Vector2(-10.0, 9.0), Vector2(-6.0, 15.0), Color("4f8f8b", 0.7), 0.8)
	ci.draw_line(Vector2(-6.0, 15.0), Vector2(-3.0, 12.0), Color("4f8f8b", 0.7), 0.8)
	
	# Cinnabar variance spike
	ci.draw_line(Vector2(3.0, 14.0), Vector2(7.0, 8.0), Color("d96b52", 0.8), 1.0)
	ci.draw_line(Vector2(7.0, 8.0), Vector2(11.0, 15.0), Color("d96b52", 0.8), 1.0)
	ci.draw_line(Vector2(11.0, 15.0), Vector2(14.0, 11.0), Color("d96b52", 0.8), 1.0)
	
	if p_is_activated or p_in_range:
		ci.draw_rect(rack_rect, Color("4f8f8b", 0.4 + pulse * 0.3), false, 1.2)


static func draw_correction_accumulation_gauge(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Telemetric gauge indicating accumulation of correction stress around Marta (26x32 px)
	var pulse := sin(p_pulse * 3.5) * 0.5 + 0.5
	
	# Cast iron gauge console body
	var body_rect := Rect2(-13.0, -16.0, 26.0, 32.0)
	ci.draw_rect(body_rect, Color("141e24"))
	ci.draw_rect(body_rect, Color("2a3e47", 0.9), false, 1.0)
	
	# Circular dial window (Radius = 9 px at center y=-4)
	var dial_center := Vector2(0.0, -4.0)
	ci.draw_circle(dial_center, 9.5, Color("0b1316"))
	ci.draw_circle(dial_center, 9.5, Color("344f5a"), false, 1.0)
	
	# Green/Amber safe sector (left) and Cinnabar critical sector (right)
	ci.draw_arc(dial_center, 7.5, PI * 0.8, PI * 1.5, 8, Color("4f8f8b", 0.7), 1.2)
	ci.draw_arc(dial_center, 7.5, PI * 1.5, PI * 2.2, 8, Color("d96b52", 0.85 + pulse * 0.15), 1.5)
	
	# Gauge Needle: Deflected into critical cinnabar sector (Angle ~ PI * 1.85)
	var needle_angle := PI * 1.80 + sin(p_pulse * 5.0) * 0.12
	var needle_tip := dial_center + Vector2(cos(needle_angle), sin(needle_angle)) * 7.5
	ci.draw_line(dial_center, needle_tip, Color("d96b52" if p_is_activated else "e2b060"), 1.2)
	ci.draw_circle(dial_center, 2.0, Color("e2b060"))
	
	# Lower status indicator LED & placard: "KOREKTA M14 / 84% NAPRĘŻENIE"
	ci.draw_rect(Rect2(-10.0, 8.0, 20.0, 4.0), Color("091012"))
	ci.draw_circle(Vector2(-6.0, 10.0), 1.5, Color("d96b52", 0.9 + pulse * 0.1))
	ci.draw_line(Vector2(-2.0, 10.0), Vector2(8.0, 10.0), Color("d96b52", 0.75), 0.8)
	
	if p_is_activated or p_in_range:
		ci.draw_rect(body_rect, Color("d96b52", 0.35 + pulse * 0.35), false, 1.2)


static func draw_wierzbicka_transmission_terminal(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Interactive video/audio transmission terminal with Dr Helena Wierzbicka (32x36 px)
	var pulse := sin(p_pulse * 2.2) * 0.5 + 0.5
	
	# Workstation casing
	var housing_rect := Rect2(-16.0, -18.0, 32.0, 36.0)
	ci.draw_rect(housing_rect, Color("11191d"))
	ci.draw_rect(housing_rect, Color("263a43", 0.9), false, 1.0)
	
	# Video screen with Wierzbicka's silhouette & transmission overlay (26x18 px)
	var screen_rect := Rect2(-13.0, -15.0, 26.0, 18.0)
	ci.draw_rect(screen_rect, Color("081014"))
	ci.draw_rect(screen_rect, Color("35505b", 0.8), false, 0.8)
	
	# Dr Wierzbicka profile silhouette in transmission feed (x=0, y=-6)
	var profile_color := Color("4f8f8b", 0.85) if not p_is_activated else Color("75c7c3", 0.95)
	ci.draw_circle(Vector2(0.0, -9.0), 3.0, profile_color) # Head
	ci.draw_rect(Rect2(-4.5, -6.0, 9.0, 6.0), profile_color) # Shoulders & collar
	
	# Horizontal transmission scanlines & audio waveform overlay
	for y in range(4):
		var wy := -14.0 + float(y) * 4.5
		ci.draw_line(Vector2(-12.0, wy), Vector2(12.0, wy), Color(profile_color.r, profile_color.g, profile_color.b, 0.2), 0.6)
	
	# Audio VU meter bar (bottom of screen)
	ci.draw_line(Vector2(-11.0, 1.0), Vector2(6.0, 1.0), Color("e2b060", 0.75 + pulse * 0.25), 1.0)
	ci.draw_circle(Vector2(9.0, 1.0), 1.2, Color("d96b52", 0.8)) # Peak overload LED
	
	# Lower audio intercom grill & microphone slot
	var grill_rect := Rect2(-12.0, 6.0, 24.0, 8.0)
	ci.draw_rect(grill_rect, Color("18252a"))
	for g in range(4):
		var gx := -9.0 + float(g) * 6.0
		ci.draw_line(Vector2(gx, 8.0), Vector2(gx, 12.0), Color("0b1214"), 1.2)
	
	# Transmit indicator lamp: "UCP-P6 / WIERZBICKA_H"
	ci.draw_circle(Vector2(11.0, -15.0), 1.4, Color("e2b060", 0.9 + pulse * 0.1))
	
	if p_is_activated or p_in_range:
		ci.draw_rect(housing_rect, Color("75c7c3", 0.35 + pulse * 0.35), false, 1.2)


static func draw_lena_disposition_selector(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# 3-Choice disposition console for Lena (ZGODA / POZORNA / ODMOWA): 34x32 px
	var pulse := sin(p_pulse * 2.8) * 0.5 + 0.5
	
	# Slanted steel control console
	var console_rect := Rect2(-17.0, -16.0, 34.0, 32.0)
	ci.draw_rect(console_rect, Color("131c21"))
	ci.draw_rect(console_rect, Color("2b414a", 0.9), false, 1.0)
	
	# Console title banner: "DYSPOZYCJA WZORCA: LENA WOLSKA"
	ci.draw_rect(Rect2(-14.0, -14.0, 28.0, 4.0), Color("0a1215"))
	ci.draw_line(Vector2(-12.0, -12.0), Vector2(12.0, -12.0), Color("e2b060", 0.75), 0.8)
	
	# 3 Illuminated Mechanical Push-Buttons:
	# 1: ZGODA JAWNA (Left: Amber/Green)
	var btn_1 := Rect2(-13.0, -6.0, 7.0, 10.0)
	ci.draw_rect(btn_1, Color("1a292e"))
	ci.draw_rect(btn_1, Color("4f8f8b", 0.8), false, 0.8)
	ci.draw_circle(Vector2(-9.5, -1.0), 1.8, Color("4f8f8b", 0.9))
	
	# 2: POZORNA WSPÓŁPRACA (Center: Amber/Cyan)
	var btn_2 := Rect2(-3.5, -6.0, 7.0, 10.0)
	ci.draw_rect(btn_2, Color("1a292e"))
	ci.draw_rect(btn_2, Color("e2b060", 0.8), false, 0.8)
	ci.draw_circle(Vector2(0.0, -1.0), 1.8, Color("e2b060", 0.9))
	
	# 3: JAWNA ODMOWA (Right: Cinnabar)
	var btn_3 := Rect2(6.0, -6.0, 7.0, 10.0)
	ci.draw_rect(btn_3, Color("1a292e"))
	ci.draw_rect(btn_3, Color("d96b52", 0.8), false, 0.8)
	ci.draw_circle(Vector2(9.5, -1.0), 1.8, Color("d96b52", 0.9))
	
	# Lower status bar: Decision register latch readout
	ci.draw_rect(Rect2(-13.0, 7.0, 26.0, 5.0), Color("0a1215"))
	var active_color := Color("75c7c3", 0.85 + pulse * 0.15) if p_is_activated else Color("56767e", 0.6)
	ci.draw_line(Vector2(-10.0, 9.5), Vector2(10.0, 9.5), active_color, 1.0)
	
	if p_is_activated or p_in_range:
		ci.draw_rect(console_rect, Color("e2b060", 0.35 + pulse * 0.35), false, 1.2)


static func draw_station_24_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy transit airlock portal leading to Space 25 (Wejście Jakuba): 30x48 px
	var pulse := sin(p_pulse * 1.8) * 0.5 + 0.5
	
	# Main portal frame
	var frame_rect := Rect2(-15.0, -24.0, 30.0, 48.0)
	ci.draw_rect(frame_rect, Color("12191d"))
	ci.draw_rect(frame_rect, Color("283b43", 0.85), false, 1.2)
	
	# Heavy steel door leaves
	var door_left := Rect2(-12.0, -21.0, 11.0, 42.0)
	var door_right := Rect2(1.0, -21.0, 11.0, 42.0)
	ci.draw_rect(door_left, Color("182428"))
	ci.draw_rect(door_right, Color("182428"))
	ci.draw_rect(door_left, Color("30464f", 0.6), false, 0.8)
	ci.draw_rect(door_right, Color("30464f", 0.6), false, 0.8)
	
	# Vertical locking seam
	ci.draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("0d1417"), 1.5)
	
	# Top archive placard: "25 / TRANZYT — WEJŚCIE JAKUBA"
	ci.draw_rect(Rect2(-12.0, -19.0, 24.0, 4.0), Color("10161a"))
	ci.draw_line(Vector2(-10.0, -17.0), Vector2(10.0, -17.0), Color("e2b060", 0.75), 0.8)
	
	# Observation viewport window
	var view_rect := Rect2(-3.0, -12.0, 6.0, 12.0)
	ci.draw_rect(view_rect, Color("081013"))
	ci.draw_rect(view_rect, Color("4f8f8b", 0.35 if not p_is_activated else 0.9))
	
	if p_is_activated:
		# Unlocked & cycling open
		ci.draw_rect(frame_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45 + pulse * 0.25), false, 1.5)
		ci.draw_line(Vector2(-15.0, 24.0), Vector2(15.0, 24.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.9), 2.0)
		ci.draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("75c7c3", 0.8), 1.0)
	else:
		# Locked / magnetic clamp active
		ci.draw_circle(Vector2(0.0, 8.0), 1.6, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.5 + pulse * 0.3))


static func draw_jakub_operator_ucp(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Jakub Wolski in UCP Line 4 technician / operator jumpsuit (32x48 px)
	var pulse := sin(p_pulse * 2.2) * 0.5 + 0.5
	var breath := sin(p_pulse * 1.6) * 1.0
	
	if p_is_activated:
		# Jakub sitting on the floor per D-09 didascalia ("Jakub siada na podłodze. Nie patrzy na Lenę.")
		# Body sitting (x=0, y=0..12)
		ci.draw_rect(Rect2(-10.0, -2.0, 20.0, 14.0), Color("17242c")) # Sitting torso & legs
		ci.draw_rect(Rect2(-10.0, -2.0, 20.0, 14.0), Color("2b3e48"), false, 1.0)
		
		# Torso & technician jacket with safety harness
		ci.draw_rect(Rect2(-7.0, -12.0 + breath * 0.5, 14.0, 11.0), Color("1c2b34"))
		ci.draw_line(Vector2(-3.0, -12.0 + breath * 0.5), Vector2(-3.0, -1.0 + breath * 0.5), Color("d39a62", 0.8), 1.2)
		ci.draw_line(Vector2(3.0, -12.0 + breath * 0.5), Vector2(3.0, -1.0 + breath * 0.5), Color("d39a62", 0.8), 1.2)
		
		# Head tilted downward / looking away (per D-09)
		ci.draw_circle(Vector2(0.0, -17.0 + breath * 0.5), 4.5, Color("d4a373"))
		ci.draw_arc(Vector2(0.0, -18.0 + breath * 0.5), 4.6, PI * 0.9, PI * 2.1, 8, Color("1a2024"), 2.2) # Hair
		
		# Operator ID badge & radio on harness
		ci.draw_rect(Rect2(-6.0, -8.0 + breath * 0.5, 4.0, 3.0), Color("e2b060"))
		ci.draw_rect(Rect2(3.0, -10.0 + breath * 0.5, 3.0, 5.0), Color("0d1417"))
	else:
		# Standing Jakub operator posturing defensively
		# Work boots
		ci.draw_rect(Rect2(-6.0, 16.0, 5.0, 4.0), Color("111619"))
		ci.draw_rect(Rect2(1.0, 16.0, 5.0, 4.0), Color("111619"))
		
		# Heavy technician trousers
		ci.draw_rect(Rect2(-6.0, 2.0, 5.0, 14.0), Color("17242c"))
		ci.draw_rect(Rect2(1.0, 2.0, 5.0, 14.0), Color("17242c"))
		
		# Torso & heavy canvas jacket
		var torso_rect := Rect2(-8.0, -14.0 + breath * 0.5, 16.0, 16.0)
		ci.draw_rect(torso_rect, Color("1c2b34"))
		ci.draw_rect(torso_rect, Color("2d414c"), false, 1.0)
		
		# Yellow/Amber UCP transit harness straps
		ci.draw_line(Vector2(-4.0, -14.0 + breath * 0.5), Vector2(-4.0, 2.0 + breath * 0.5), Color("d39a62", 0.85), 1.5)
		ci.draw_line(Vector2(4.0, -14.0 + breath * 0.5), Vector2(4.0, 2.0 + breath * 0.5), Color("d39a62", 0.85), 1.5)
		ci.draw_line(Vector2(-8.0, -6.0 + breath * 0.5), Vector2(8.0, -6.0 + breath * 0.5), Color("d39a62", 0.75), 1.2)
		
		# Operator ID badge on chest
		ci.draw_rect(Rect2(-6.5, -11.0 + breath * 0.5, 5.0, 3.0), Color("e2b060"))
		
		# Head and facial profile
		ci.draw_circle(Vector2(0.0, -19.0 + breath * 0.5), 5.0, Color("d4a373"))
		ci.draw_arc(Vector2(0.0, -20.5 + breath * 0.5), 5.2, PI * 0.85, PI * 2.15, 8, Color("1a2024"), 2.5) # Hair
		
		# Flashlight holster on hip
		ci.draw_rect(Rect2(8.0, -2.0, 3.0, 8.0), Color("0e161a"))
		ci.draw_circle(Vector2(9.5, -2.0), 1.2, Color("75c7c3", 0.8))
	
	if p_in_range or p_is_activated:
		ci.draw_circle(Vector2(0.0, -28.0), 2.5, Color("e2b060", 0.8 + pulse * 0.2))


static func draw_transit_maintenance_cart(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Heavy Line 4 maintenance cart on steel rails (40x26 px)
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	
	# Steel platform chassis
	var platform := Rect2(-20.0, -4.0, 40.0, 10.0)
	ci.draw_rect(platform, Color("1e2c34"))
	ci.draw_rect(platform, Color("344b58"), false, 1.0)
	
	# Warning chevron stripes along bumper
	for c in range(6):
		var cx := -18.0 + float(c) * 6.5
		ci.draw_line(Vector2(cx, -3.0), Vector2(cx + 4.0, 5.0), Color("d39a62", 0.8), 1.2)
	
	# 4 Flanged steel railway wheels resting on rail profile
	ci.draw_circle(Vector2(-14.0, 9.0), 4.5, Color("121b20"))
	ci.draw_circle(Vector2(-14.0, 9.0), 4.5, Color("4a6d7c"), false, 1.0)
	ci.draw_circle(Vector2(14.0, 9.0), 4.5, Color("121b20"))
	ci.draw_circle(Vector2(14.0, 9.0), 4.5, Color("4a6d7c"), false, 1.0)
	
	# Tool crate and cable spool on cart
	var crate_rect := Rect2(-17.0, -14.0, 14.0, 10.0)
	ci.draw_rect(crate_rect, Color("141e24"))
	ci.draw_rect(crate_rect, Color("a8b2ac", 0.6), false, 0.8)
	
	# Cable spool with copper/amber wiring
	ci.draw_circle(Vector2(7.0, -9.0), 6.0, Color("10181d"))
	ci.draw_circle(Vector2(7.0, -9.0), 4.5, Color("d39a62", 0.85))
	ci.draw_circle(Vector2(7.0, -9.0), 2.0, Color("10181d"))
	
	# Rail maintenance lantern (glows amber)
	ci.draw_rect(Rect2(-2.0, -18.0, 5.0, 8.0), Color("0d1418"))
	ci.draw_rect(Rect2(-1.5, -16.0, 4.0, 4.0), Color("e2b060", 0.9 + pulse * 0.1))
	
	if p_in_range or p_is_activated:
		ci.draw_rect(platform, Color("75c7c3", 0.35 + pulse * 0.35), false, 1.2)


static func draw_scar_diagnostic_chart(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Illuminated diagnostic clipboard showing Line 4 accident & glass shard scar beneath left rib (26x34 px)
	var pulse := sin(p_pulse * 2.5) * 0.5 + 0.5
	
	# Backing board
	var board_rect := Rect2(-13.0, -17.0, 26.0, 34.0)
	ci.draw_rect(board_rect, Color("11181d"))
	ci.draw_rect(board_rect, Color("2d434e"), false, 1.0)
	
	# Paper sheet
	var paper_rect := Rect2(-11.0, -14.0, 22.0, 28.0)
	ci.draw_rect(paper_rect, Color("202d36"))
	
	# Anatomical torso silhouette outline
	ci.draw_arc(Vector2(0.0, -8.0), 4.0, 0.0, TAU, 8, Color("4a6d7c", 0.7), 1.0) # Chest outline
	ci.draw_rect(Rect2(-5.0, -4.0, 10.0, 12.0), Color("17232b"))
	ci.draw_rect(Rect2(-5.0, -4.0, 10.0, 12.0), Color("4a6d7c", 0.6), false, 0.8)
	
	# Scar location marker under left rib (cinnabar #c65d58 cross & callout line)
	var scar_pos := Vector2(3.0, 1.0)
	ci.draw_line(scar_pos + Vector2(-2.5, -1.0), scar_pos + Vector2(2.5, 1.0), Color("c65d58", 0.95), 1.5)
	ci.draw_circle(scar_pos, 1.5, Color("d96b52", 0.9 + pulse * 0.1))
	
	# Callout measurement line to margin: "SZKŁO / LINIA 4 / ŻEBRO LEWE"
	ci.draw_line(scar_pos, Vector2(9.0, 1.0), Color("c65d58", 0.8), 0.8)
	ci.draw_line(Vector2(9.0, 1.0), Vector2(9.0, 6.0), Color("c65d58", 0.8), 0.8)
	
	# Header clamp & text lines
	ci.draw_rect(Rect2(-6.0, -17.0, 12.0, 3.0), Color("d39a62"))
	ci.draw_line(Vector2(-9.0, -11.0), Vector2(9.0, -11.0), Color("e2b060", 0.7), 0.8)
	
	if p_in_range or p_is_activated:
		ci.draw_rect(board_rect, Color("c65d58", 0.35 + pulse * 0.35), false, 1.2)


static func draw_jakub_hand_gesture_sensor(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Hand movement pattern analysis terminal (turning ring vs cutting finger on edge): 30x28 px
	var pulse := sin(p_pulse * 2.6) * 0.5 + 0.5
	
	# Terminal housing
	var housing_rect := Rect2(-15.0, -14.0, 30.0, 28.0)
	ci.draw_rect(housing_rect, Color("121a20"))
	ci.draw_rect(housing_rect, Color("2d434e"), false, 1.0)
	
	# Header placard: "ANALIZA GESTU DŁONI"
	ci.draw_rect(Rect2(-12.0, -12.0, 24.0, 4.0), Color("091013"))
	ci.draw_line(Vector2(-10.0, -10.0), Vector2(10.0, -10.0), Color("e2b060", 0.75), 0.8)
	
	# Left Sensor Panel: Ring Rotation (local Lena pattern)
	var left_panel := Rect2(-12.0, -6.0, 10.0, 12.0)
	ci.draw_rect(left_panel, Color("17232b"))
	ci.draw_rect(left_panel, Color("4a6d7c", 0.6), false, 0.8)
	ci.draw_arc(Vector2(-7.0, 0.0), 3.0, 0.0, TAU, 8, Color("e2b060", 0.8), 1.0)
	
	# Right Sensor Panel: Sharp Edge & Finger Cut (protagonist Lena pattern)
	var right_panel := Rect2(2.0, -6.0, 10.0, 12.0)
	ci.draw_rect(right_panel, Color("17232b"))
	ci.draw_rect(right_panel, Color("4a6d7c", 0.6), false, 0.8)
	ci.draw_line(Vector2(4.0, -4.0), Vector2(10.0, 4.0), Color("a8b2ac"), 1.2) # Sharp blade edge
	ci.draw_line(Vector2(5.0, 1.0), Vector2(9.0, -3.0), Color("c65d58", 0.9 + pulse * 0.1), 1.5) # Cut trace
	
	# Bottom comparator indicator
	ci.draw_rect(Rect2(-12.0, 8.0, 24.0, 4.0), Color("091013"))
	var indicator_pos := Vector2(7.0 if p_is_activated else -7.0, 10.0)
	ci.draw_circle(indicator_pos, 1.5, Color("d96b52" if p_is_activated else "e2b060"))
	
	if p_in_range or p_is_activated:
		ci.draw_rect(housing_rect, Color("e2b060", 0.35 + pulse * 0.35), false, 1.2)


static func draw_station_25_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy transit service portal leading to Space 26 (Próba zamknięcia / strefa izolacji): 32x48 px
	var pulse := sin(p_pulse * 1.8) * 0.5 + 0.5
	
	# Frame
	var frame_rect := Rect2(-16.0, -24.0, 32.0, 48.0)
	ci.draw_rect(frame_rect, Color("121a20"))
	ci.draw_rect(frame_rect, Color("2d434e", 0.85), false, 1.2)
	
	# Sliding door panels
	var door_left := Rect2(-13.0, -21.0, 12.0, 42.0)
	var door_right := Rect2(1.0, -21.0, 12.0, 42.0)
	ci.draw_rect(door_left, Color("19252c"))
	ci.draw_rect(door_right, Color("19252c"))
	ci.draw_rect(door_left, Color("344f5b", 0.6), false, 0.8)
	ci.draw_rect(door_right, Color("344f5b", 0.6), false, 0.8)
	
	# Center locking seam & rubber seal
	ci.draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("091014"), 1.5)
	
	# Top archive placard: "26 / STREFA IZOLACJI — PRÓBA ZAMKNIĘCIA"
	ci.draw_rect(Rect2(-13.0, -19.0, 26.0, 4.0), Color("0d1519"))
	ci.draw_line(Vector2(-11.0, -17.0), Vector2(11.0, -17.0), Color("e2b060", 0.75), 0.8)
	
	# Viewport window with amber/cyan transit lumination
	var view_rect := Rect2(-4.0, -12.0, 8.0, 12.0)
	ci.draw_rect(view_rect, Color("081014"))
	ci.draw_rect(view_rect, Color("4a6d7c", 0.35 if not p_is_activated else 0.95))
	
	if p_is_activated:
		# Unlocked & cycling open
		ci.draw_rect(frame_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45 + pulse * 0.25), false, 1.5)
		ci.draw_line(Vector2(-16.0, 24.0), Vector2(16.0, 24.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.9), 2.0)
		ci.draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("75c7c3", 0.8), 1.0)
	else:
		# Locked / magnetic clamp active
		ci.draw_circle(Vector2(0.0, 8.0), 1.6, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.5 + pulse * 0.3))


static func draw_isolation_zone_console(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Diagnostic console monitoring gentle isolation status in Podstructure (32x28 px)
	var pulse := sin(p_pulse * 2.2) * 0.5 + 0.5
	
	# Terminal housing
	var housing_rect := Rect2(-16.0, -14.0, 32.0, 28.0)
	ci.draw_rect(housing_rect, Color("10171a"))
	ci.draw_rect(housing_rect, Color("2b3e48"), false, 1.0)
	
	# CRT scope monitor (24x14 px)
	var crt_rect := Rect2(-12.0, -11.0, 24.0, 14.0)
	ci.draw_rect(crt_rect, Color("122024"))
	ci.draw_rect(crt_rect, Color("3d5a65", 0.7), false, 0.8)
	
	# Spatial pressure & damping waveform
	for x in range(20):
		var fx := -10.0 + float(x)
		var wy := sin((fx + p_pulse * 4.0) * 0.5) * 3.5
		ci.draw_line(Vector2(fx, -4.0 + wy), Vector2(fx + 1.0, -4.0 + wy), Color("5da398", 0.85), 1.2)
	
	# Status indicator badge: "IZOLACJA ADAPTACYJNA"
	ci.draw_rect(Rect2(-12.0, 5.0, 24.0, 5.0), Color("091013"))
	ci.draw_line(Vector2(-10.0, 7.5), Vector2(10.0, 7.5), Color("c8a370", 0.8), 0.8)
	
	# Status LED (blinks cyan / amber)
	var led_color := Color("5da398", 0.9 + pulse * 0.1) if p_is_activated else Color("d39a62", 0.8)
	ci.draw_circle(Vector2(10.0, -8.0), 1.5, led_color)
	
	if p_in_range or p_is_activated:
		ci.draw_rect(housing_rect, Color("5da398", 0.35 + pulse * 0.35), false, 1.2)


static func draw_dynamic_room_designator(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Modular room function indicator panel: MIESZKALNY -> ARCHIWUM -> SEDACJA (28x32 px)
	var pulse := sin(p_pulse * 2.4) * 0.5 + 0.5
	
	# Backing plate & mounting bracket
	var plate_rect := Rect2(-14.0, -16.0, 28.0, 32.0)
	ci.draw_rect(plate_rect, Color("131c21"))
	ci.draw_rect(plate_rect, Color("2e424c"), false, 1.0)
	
	# Function readout placard
	var placard_rect := Rect2(-11.0, -13.0, 22.0, 18.0)
	ci.draw_rect(placard_rect, Color("0b1215"))
	ci.draw_rect(placard_rect, Color("3d5a65", 0.6), false, 0.8)
	
	# Split-flap indicator lines / dynamic state designation
	var line_color := Color("c8a370") if not p_is_activated else Color("5da398")
	ci.draw_line(Vector2(-9.0, -8.0), Vector2(9.0, -8.0), line_color, 1.0)
	ci.draw_line(Vector2(-9.0, -3.0), Vector2(9.0, -3.0), line_color * 0.8, 0.8)
	ci.draw_line(Vector2(-9.0, 2.0), Vector2(6.0, 2.0), line_color * 0.6, 0.8)
	
	# Reconfiguration mode indicator lamps
	var lamp_y := 9.0
	ci.draw_circle(Vector2(-7.0, lamp_y), 1.8, Color("5da398", 0.9 if p_is_activated else 0.3)) # Mode 1
	ci.draw_circle(Vector2(0.0, lamp_y), 1.8, Color("c8a370", 0.9 if not p_is_activated else 0.3)) # Mode 2
	ci.draw_circle(Vector2(7.0, lamp_y), 1.8, Color("c65d58", 0.4 + pulse * 0.3)) # Reconfig alert
	
	if p_in_range or p_is_activated:
		ci.draw_rect(plate_rect, Color("c8a370", 0.35 + pulse * 0.35), false, 1.2)


static func draw_motivation_anchor_record(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Reinforced wall slab with Lena's handwritten anchor inscription (36x24 px)
	var pulse := sin(p_pulse * 2.8) * 0.5 + 0.5
	
	# Wall slab base
	var slab_rect := Rect2(-18.0, -12.0, 36.0, 24.0)
	ci.draw_rect(slab_rect, Color("151e23"))
	ci.draw_rect(slab_rect, Color("344b56"), false, 1.0)
	
	# Deep carved anchor inscription traces ("PAMIĘTAM DLACZEGO PRZYSZŁAM")
	var cinnabar := Color("c65d58", 0.9 + pulse * 0.1)
	var amber_glow := Color("e2b060", 0.85)
	
	ci.draw_line(Vector2(-14.0, -7.0), Vector2(14.0, -7.0), amber_glow, 1.2) # Line 1: PAMIĘTAM
	ci.draw_line(Vector2(-14.0, -2.0), Vector2(12.0, -2.0), cinnabar, 1.4)   # Line 2: DLACZEGO PRZYSZŁAM
	ci.draw_line(Vector2(-14.0, 3.0), Vector2(10.0, 3.0), amber_glow, 1.2)   # Line 3: NIE JESTEM ADAPTACJĄ
	
	# Chisel score mark & stylus point stuck in composite joint
	ci.draw_line(Vector2(11.0, 2.0), Vector2(15.0, 8.0), Color("a8b2ac"), 1.8) # Steel stylus
	ci.draw_circle(Vector2(15.0, 8.0), 1.5, Color("d39a62")) # Brass handle
	
	# Resistance anchor glow perimeter
	if p_is_activated or p_in_range:
		ci.draw_rect(slab_rect, Color("c65d58", 0.40 + pulse * 0.30), false, 1.5)
		ci.draw_circle(Vector2(0.0, -16.0), 2.2, Color("e2b060", 0.9))


static func draw_wierzbicka_pa_speaker(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Institutional PA wall intercom horn / speaker grille (24x28 px)
	var pulse := sin(p_pulse * 3.0) * 0.5 + 0.5
	
	# Speaker enclosure
	var enc_rect := Rect2(-12.0, -14.0, 24.0, 28.0)
	ci.draw_rect(enc_rect, Color("141d22"))
	ci.draw_rect(enc_rect, Color("2d414c"), false, 1.0)
	
	# Slotted circular speaker mesh
	ci.draw_circle(Vector2(0.0, -2.0), 8.0, Color("0b1215"))
	ci.draw_circle(Vector2(0.0, -2.0), 8.0, Color("3d5a65", 0.7), false, 0.8)
	
	# Grille louvres
	for l in range(4):
		var ly := -6.0 + float(l) * 2.8
		ci.draw_line(Vector2(-5.0, ly), Vector2(5.0, ly), Color("2e434f"), 1.0)
	
	# Top broadcasting LED indicator
	var led_col := Color("e2b060", 0.95) if p_is_activated else Color("3d5a65", 0.5)
	ci.draw_circle(Vector2(0.0, -10.5), 1.8, led_col)
	
	# Radiating acoustic broadcast waves (when speaking/activated)
	if p_is_activated or p_in_range:
		var wave_alpha := 0.35 + pulse * 0.35
		ci.draw_arc(Vector2(0.0, -2.0), 12.0 + pulse * 3.0, -PI * 0.35, PI * 0.35, 6, Color("5da398", wave_alpha), 1.0)
		ci.draw_arc(Vector2(0.0, -2.0), 16.0 + pulse * 4.0, -PI * 0.30, PI * 0.30, 6, Color("5da398", wave_alpha * 0.6), 0.8)


static func draw_station_26_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Reinforced isolation transit portal leading to Space 27 (Dług wdzięczności): 32x48 px
	var pulse := sin(p_pulse * 1.8) * 0.5 + 0.5
	
	# Heavy outer frame
	var frame_rect := Rect2(-16.0, -24.0, 32.0, 48.0)
	ci.draw_rect(frame_rect, Color("11191d"))
	ci.draw_rect(frame_rect, Color("2d434e", 0.85), false, 1.2)
	
	# Sliding door panels
	var door_left := Rect2(-13.0, -21.0, 12.0, 42.0)
	var door_right := Rect2(1.0, -21.0, 12.0, 42.0)
	ci.draw_rect(door_left, Color("18232a"))
	ci.draw_rect(door_right, Color("18232a"))
	ci.draw_rect(door_left, Color("36505c", 0.6), false, 0.8)
	ci.draw_rect(door_right, Color("36505c", 0.6), false, 0.8)
	
	# Center sealing seam
	ci.draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("091014"), 1.5)
	
	# Top archive placard: "27 / PRZEJŚCIE SERWISOWE — DŁUG WDZIĘCZNOŚCI"
	ci.draw_rect(Rect2(-13.0, -19.0, 26.0, 4.0), Color("0d1519"))
	ci.draw_line(Vector2(-11.0, -17.0), Vector2(11.0, -17.0), Color("c8a370", 0.75), 0.8)
	
	# Viewport window
	var view_rect := Rect2(-4.0, -12.0, 8.0, 12.0)
	ci.draw_rect(view_rect, Color("081014"))
	ci.draw_rect(view_rect, Color("5da398", 0.35 if not p_is_activated else 0.95))
	
	if p_is_activated:
		# Unlocked & cycling open toward Space 27
		ci.draw_rect(frame_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45 + pulse * 0.25), false, 1.5)
		ci.draw_line(Vector2(-16.0, 24.0), Vector2(16.0, 24.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.9), 2.0)
		ci.draw_line(Vector2(0.0, -21.0), Vector2(0.0, 21.0), Color("5da398", 0.8), 1.0)
	else:
		# Locked / magnetic clamp active
		ci.draw_circle(Vector2(0.0, 8.0), 1.6, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.5 + pulse * 0.3))


static func draw_jakub_service_operator(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Jakub Wolski as UCP service operator: 20x36 px silhouette holding keycard
	var pulse := sin(p_pulse * 2.2) * 0.5 + 0.5
	
	# Head with dark hair
	ci.draw_circle(Vector2(0.0, -14.0), 4.5, Color("352e28"))
	ci.draw_circle(Vector2(0.0, -13.0), 3.8, Color("d0b296"))
	
	# Dark grey UCP technician jacket / work overalls with orange reflective harness
	var torso_rect := Rect2(-5.5, -9.0, 11.0, 15.0)
	ci.draw_rect(torso_rect, Color("202a30"))
	ci.draw_rect(torso_rect, Color("32434d"), false, 0.8)
	
	# Reflective high-visibility harness straps (amber-orange)
	ci.draw_line(Vector2(-4.0, -9.0), Vector2(-1.5, 4.0), Color("e29b42", 0.9), 1.2)
	ci.draw_line(Vector2(4.0, -9.0), Vector2(1.5, 4.0), Color("e29b42", 0.9), 1.2)
	ci.draw_line(Vector2(-4.5, -2.0), Vector2(4.5, -2.0), Color("e29b42", 0.9), 1.2)
	
	# Legs and heavy work boots
	var leg_left := Rect2(-5.0, 6.0, 4.0, 12.0)
	var leg_right := Rect2(1.0, 6.0, 4.0, 12.0)
	ci.draw_rect(leg_left, Color("171f24"))
	ci.draw_rect(leg_right, Color("171f24"))
	ci.draw_rect(Rect2(-5.5, 16.0, 4.5, 3.0), Color("0d1215"))
	ci.draw_rect(Rect2(0.5, 16.0, 4.5, 3.0), Color("0d1215"))
	
	# Right arm extended with magnetic keycard
	ci.draw_line(Vector2(5.0, -6.0), Vector2(10.0, -1.0), Color("d0b296"), 1.8)
	var card_rect := Rect2(9.0, -4.0, 5.0, 7.0)
	ci.draw_rect(card_rect, Color("dbe4e8"))
	ci.draw_line(Vector2(10.0, -1.0), Vector2(13.0, -1.0), Color("202a30"), 1.0)
	
	# Glow on keycard when activated
	if p_is_activated or p_in_range:
		ci.draw_circle(Vector2(11.5, -0.5), 3.0 + pulse * 1.5, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.4 + pulse * 0.3))


static func draw_saved_worker_badge(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# UCP Identification & Saved Worker Badge: 18x24 px
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	var badge_rect := Rect2(-9.0, -12.0, 18.0, 24.0)
	
	# Laminated plastic casing
	ci.draw_rect(badge_rect, Color("141e24"))
	ci.draw_rect(badge_rect, Color("3d5a65", 0.8), false, 1.0)
	
	# Lanyard clip at top
	ci.draw_rect(Rect2(-2.5, -15.0, 5.0, 3.0), Color("4a6270"))
	ci.draw_circle(Vector2(0.0, -13.5), 1.2, Color("0e161a"))
	
	# ID Photo box (miniature face portrait)
	var photo_box := Rect2(-7.0, -10.0, 8.0, 9.0)
	ci.draw_rect(photo_box, Color("263740"))
	ci.draw_circle(Vector2(-3.0, -6.0), 2.2, Color("d0b296"))
	
	# Text lines & barcode
	ci.draw_line(Vector2(3.0, -9.0), Vector2(7.0, -9.0), Color("e2b060", 0.8), 0.8)
	ci.draw_line(Vector2(3.0, -6.0), Vector2(7.0, -6.0), Color("c8a370", 0.6), 0.8)
	ci.draw_line(Vector2(-7.0, 1.0), Vector2(7.0, 1.0), Color("5da398", 0.75), 0.8)
	
	# Red badge status stamp: "STATUS: OCALONY / 12 LAT"
	ci.draw_rect(Rect2(-7.0, 3.5, 14.0, 6.0), Color("3d1c1a", 0.7))
	ci.draw_line(Vector2(-6.0, 6.5), Vector2(6.0, 6.5), Color("c65d58", 0.9), 1.0)
	
	if p_is_activated:
		ci.draw_rect(badge_rect, Color("e2b060", 0.35 + pulse * 0.25), false, 1.2)


static func draw_surface_stability_monitor(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Surface Stability CRT Scope: 26x20 px
	var pulse := sin(p_pulse * 3.0) * 0.5 + 0.5
	var mon_rect := Rect2(-13.0, -10.0, 26.0, 20.0)
	
	# Industrial steel housing
	ci.draw_rect(mon_rect, Color("12191d"))
	ci.draw_rect(mon_rect, Color("344953"), false, 1.0)
	
	# Dark CRT screen
	var screen_rect := Rect2(-11.0, -8.0, 22.0, 14.0)
	ci.draw_rect(screen_rect, Color("091216"))
	
	# Dual oscillating surface strain waveforms (contradictory histories causing surface stress)
	var col_wave := Color("c65d58", 0.85) if p_is_activated else Color("d39a62", 0.65)
	for i in range(5):
		var x1 := -9.0 + float(i) * 3.5
		var x2 := x1 + 3.5
		var y1 := -1.0 + sin((p_pulse + float(i)) * 1.5) * 4.0
		var y2 := -1.0 + sin((p_pulse + float(i + 1)) * 1.5) * 4.0
		ci.draw_line(Vector2(x1, y1), Vector2(x2, y2), col_wave, 1.0)
	
	# Warning LED bank at bottom
	var led_warn := Color("c65d58", 0.9 if pulse > 0.4 else 0.2)
	ci.draw_circle(Vector2(-7.0, 8.0), 1.2, led_warn)
	ci.draw_circle(Vector2(-3.0, 8.0), 1.2, Color("e2b060", 0.8))
	ci.draw_circle(Vector2(1.0, 8.0), 1.2, Color("5da398", 0.8))
	ci.draw_circle(Vector2(5.0, 8.0), 1.2, Color("5da398", 0.8))


static func draw_technical_junction_console(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Junction Track Switchboard Console: 28x22 px
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	var console_rect := Rect2(-14.0, -11.0, 28.0, 22.0)
	
	ci.draw_rect(console_rect, Color("151e22"))
	ci.draw_rect(console_rect, Color("3e5864"), false, 1.0)
	
	# Track route schematic lines
	ci.draw_line(Vector2(-10.0, -5.0), Vector2(0.0, -5.0), Color("4a6b79"), 1.2)
	ci.draw_line(Vector2(0.0, -5.0), Vector2(10.0, -9.0), Color("5da398" if p_is_activated else "3d5059"), 1.2)
	ci.draw_line(Vector2(0.0, -5.0), Vector2(10.0, -1.0), Color("c65d58" if not p_is_activated else "3d5059"), 1.2)
	
	# Track switch indicator lamps
	var active_col := Color("5da398", 0.9) if p_is_activated else Color("d39a62", 0.7)
	ci.draw_circle(Vector2(0.0, -5.0), 1.8, active_col)
	
	# Mechanical throw switch lever (tilted right when activated)
	var lever_tip := Vector2(4.0, 4.0) if p_is_activated else Vector2(-4.0, 4.0)
	ci.draw_line(Vector2(0.0, 8.0), lever_tip, Color("dbe4e8"), 1.8)
	ci.draw_circle(lever_tip, 2.0, Color("c8a370"))
	
	# Pneumatic gauge
	ci.draw_circle(Vector2(-8.0, 6.0), 3.2, Color("0d1417"))
	ci.draw_circle(Vector2(-8.0, 6.0), 3.2, Color("4a6b79"), false, 0.8)
	ci.draw_line(Vector2(-8.0, 6.0), Vector2(-8.0 + sin(pulse * 2.0) * 2.0, 6.0 - cos(pulse * 2.0) * 2.0), Color("e2b060"), 0.8)


static func draw_station_27_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy industrial roll-up portal to Technical Track (Przestrzeń 28): 34x50 px
	var pulse := sin(p_pulse * 1.8) * 0.5 + 0.5
	var frame_rect := Rect2(-17.0, -25.0, 34.0, 50.0)
	
	# Heavy reinforced steel portal frame
	ci.draw_rect(frame_rect, Color("0f1518"))
	ci.draw_rect(frame_rect, Color("354e5a", 0.9), false, 1.2)
	
	# Overhead rollup spool housing
	var spool_rect := Rect2(-15.0, -23.0, 30.0, 8.0)
	ci.draw_rect(spool_rect, Color("1a252c"))
	ci.draw_rect(spool_rect, Color("42606e", 0.7), false, 0.8)
	ci.draw_line(Vector2(-12.0, -19.0), Vector2(12.0, -19.0), Color("d39a62", 0.85), 1.0)
	
	# Steel shutter slats
	var num_slats := 7
	for s in range(num_slats):
		var sy := -13.0 + float(s) * 5.0
		var slat_rect := Rect2(-14.0, sy, 28.0, 4.0)
		ci.draw_rect(slat_rect, Color("141c21") if s % 2 == 0 else Color("182329"))
		ci.draw_rect(slat_rect, Color("2d404b", 0.5), false, 0.6)
	
	# Hazard warning stripes at bottom threshold
	for h in range(4):
		var hx := -12.0 + float(h) * 6.0
		ci.draw_line(Vector2(hx, 22.0), Vector2(hx + 3.0, 25.0), Color("e29b42", 0.85), 1.2)
	
	# Top archive placard: "28 / SKŁAD TECHNICZNY — TRAMWAJ BEZ PASAŻERÓW"
	ci.draw_rect(Rect2(-14.0, -13.0, 28.0, 3.5), Color("0b1013"))
	ci.draw_line(Vector2(-12.0, -11.5), Vector2(12.0, -11.5), Color("5da398", 0.8), 0.8)
	
	if p_is_activated:
		# Unlocked & rolling up
		ci.draw_rect(frame_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45 + pulse * 0.25), false, 1.5)
		ci.draw_line(Vector2(-17.0, 25.0), Vector2(17.0, 25.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.9), 2.0)
		ci.draw_rect(Rect2(-12.0, 5.0, 24.0, 18.0), Color("060a0c"))
		ci.draw_line(Vector2(0.0, 8.0), Vector2(0.0, 22.0), Color("5da398", 0.75), 1.2)
	else:
		# Locked indicator
		ci.draw_circle(Vector2(0.0, 5.0), 1.8, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.6 + pulse * 0.3))


static func draw_tram_driver_console(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Tram Driver Console & Throttle Dashboard: 32x24 px
	var pulse := sin(p_pulse * 2.5) * 0.5 + 0.5
	var dash_rect := Rect2(-16.0, -12.0, 32.0, 24.0)
	
	# Dark cast-iron and brushed steel dashboard console
	ci.draw_rect(dash_rect, Color("141c20"))
	ci.draw_rect(dash_rect, Color("354e5a"), false, 1.0)
	
	# Upper speed & voltage CRT display
	var crt_rect := Rect2(-13.0, -10.0, 26.0, 8.0)
	ci.draw_rect(crt_rect, Color("081014"))
	ci.draw_line(Vector2(-11.0, -6.0), Vector2(11.0, -6.0), Color("5da398", 0.8), 0.8)
	
	# Velocity dial (needle vibrates with carriage speed)
	ci.draw_circle(Vector2(-7.0, 4.0), 4.2, Color("0a1216"))
	ci.draw_circle(Vector2(-7.0, 4.0), 4.2, Color("4a6875"), false, 0.8)
	var needle_angle := -0.5 + pulse * 1.2
	ci.draw_line(Vector2(-7.0, 4.0), Vector2(-7.0 + cos(needle_angle) * 3.2, 4.0 + sin(needle_angle) * 3.2), Color("e2b060"), 1.0)
	
	# Master throttle control lever (forward when activated)
	var lever_top := Vector2(7.0, -1.0) if p_is_activated else Vector2(7.0, 5.0)
	ci.draw_line(Vector2(7.0, 8.0), lever_top, Color("dbe4e8"), 2.0)
	ci.draw_circle(lever_top, 2.2, Color("d39a62"))
	
	# Illuminated route placard: "LINIA 4 / TRANZYT"
	ci.draw_rect(Rect2(-13.0, -1.0, 12.0, 3.0), Color("0d1519"))
	ci.draw_line(Vector2(-12.0, 0.5), Vector2(-2.0, 0.5), Color("5da398", 0.9 if p_is_activated else 0.5), 0.8)


static func draw_panoramic_transit_window(ci: CanvasItem, p_pulse: float) -> void:
	# Panoramic Transit Observation Window: 48x32 px
	var pulse := sin(p_pulse * 3.2) * 0.5 + 0.5
	var win_rect := Rect2(-24.0, -16.0, 48.0, 32.0)
	
	# Heavy carriage window structural steel frame
	ci.draw_rect(win_rect, Color("11181c"))
	ci.draw_rect(win_rect, Color("3d5865", 0.9), false, 1.2)
	
	# Dark tunnel exterior view
	var glass_rect := Rect2(-22.0, -14.0, 44.0, 28.0)
	ci.draw_rect(glass_rect, Color("080d10"))
	
	# Passing tunnel cable lines & structural ribs (moving parallax effect)
	for i in range(4):
		var phase_offset := fmod(p_pulse * 22.0 + float(i) * 12.0, 44.0) - 22.0
		ci.draw_line(Vector2(phase_offset, -14.0), Vector2(phase_offset - 6.0, 14.0), Color("1b262d", 0.8), 1.5)
	
	# High voltage cable along tunnel ceiling
	ci.draw_line(Vector2(-22.0, -9.0), Vector2(22.0, -9.0), Color("3d5562", 0.6), 1.0)
	
	# Subtle glass reflection of Lena's silhouette inside carriage
	ci.draw_line(Vector2(-6.0, -4.0), Vector2(-6.0, 8.0), Color("5da398", 0.2 + pulse * 0.15), 1.2)
	ci.draw_circle(Vector2(-6.0, -7.0), 2.5, Color("5da398", 0.15 + pulse * 0.10))


static func draw_triple_accident_paradox_view(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Triple Paradox Platform Viewport: 54x36 px showing 3 split versions of accident
	var pulse := sin(p_pulse * 2.8) * 0.5 + 0.5
	var port_rect := Rect2(-27.0, -18.0, 54.0, 36.0)
	
	# Viewport brass-steel casing
	ci.draw_rect(port_rect, Color("162025"))
	ci.draw_rect(port_rect, Color("4a6875"), false, 1.2)
	
	# 3 Divided Observation Panels: Left (Empty), Center (Crowded), Right (Consensus Glow)
	var slit_w := 15.0
	
	# 1. Left Slit (Version A: Pusty peron / cisza powypadkowa)
	var left_rect := Rect2(-24.0, -15.0, slit_w, 30.0)
	ci.draw_rect(left_rect, Color("0b1216"))
	ci.draw_line(Vector2(-24.0 + slit_w, -15.0), Vector2(-24.0 + slit_w, 15.0), Color("24333b"), 1.0)
	# Empty platform bench & flickering cyan lamp
	ci.draw_line(Vector2(-22.0, 6.0), Vector2(-12.0, 6.0), Color("354e5b"), 1.2)
	ci.draw_circle(Vector2(-17.0, -10.0), 1.5, Color("5da398", 0.45 + pulse * 0.2))
	
	# 2. Center Slit (Version B: Zatłoczony peron / akcja ratunkowa)
	var mid_rect := Rect2(-7.5, -15.0, slit_w, 30.0)
	ci.draw_rect(mid_rect, Color("14100c"))
	ci.draw_line(Vector2(-7.5 + slit_w, -15.0), Vector2(-7.5 + slit_w, 15.0), Color("24333b"), 1.0)
	# Amber hazard lights & silhouetted figures
	ci.draw_circle(Vector2(0.0, -10.0), 1.8, Color("e29b42", 0.85 + pulse * 0.15))
	ci.draw_circle(Vector2(-3.0, 2.0), 1.8, Color("302219"))
	ci.draw_circle(Vector2(3.0, 2.0), 1.8, Color("302219"))
	ci.draw_line(Vector2(-4.0, 7.0), Vector2(4.0, 7.0), Color("d39a62", 0.7), 1.0)
	
	# 3. Right Slit (Version C: Konsensus UCP / zalany błękitnym światłem)
	var right_rect := Rect2(9.0, -15.0, slit_w, 30.0)
	ci.draw_rect(right_rect, Color("081418"))
	# Saturated cyan/teal field of consensus stabilizing beam
	ci.draw_rect(right_rect, Color("5da398", 0.35 + pulse * 0.30))
	ci.draw_line(Vector2(11.0, -10.0), Vector2(22.0, 10.0), Color("c8e6e2", 0.75), 1.2)
	
	# The Trace arranging letters: "Ś W I A D E K" across passing station placards
	if p_is_activated or p_in_range:
		ci.draw_rect(Rect2(-24.0, 11.0, 48.0, 5.0), Color("060a0c", 0.9))
		ci.draw_line(Vector2(-22.0, 13.5), Vector2(22.0, 13.5), Color("75c7c3", 0.9), 1.0)


static func draw_wierzbicka_closing_intercom(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Tram Intercom & Radio Speaker: 20x20 px
	var pulse := sin(p_pulse * 3.5) * 0.5 + 0.5
	var spk_rect := Rect2(-10.0, -10.0, 20.0, 20.0)
	
	# Bakelite speaker body
	ci.draw_rect(spk_rect, Color("161f24"))
	ci.draw_rect(spk_rect, Color("3d5865"), false, 1.0)
	
	# Circular acoustic grille
	ci.draw_circle(Vector2.ZERO, 6.5, Color("0c1417"))
	ci.draw_circle(Vector2.ZERO, 6.5, Color("2d434d"), false, 0.8)
	for r in range(3):
		var rad := 2.0 + float(r) * 1.8
		ci.draw_circle(Vector2.ZERO, rad, Color("4a6875", 0.5), false, 0.6)
	
	# Transmission status LED (cinnabar/red when Wierzbicka closes the path)
	var led_col := Color("c65d58", 0.9 if p_is_activated else 0.4 + pulse * 0.3)
	ci.draw_circle(Vector2(6.0, -6.0), 1.4, led_col)
	
	# Radio wave dispersion arcs
	if p_is_activated:
		ci.draw_arc(Vector2(0.0, -12.0), 4.0, -PI * 0.75, -PI * 0.25, 6, Color("c65d58", 0.8), 1.0)
		ci.draw_arc(Vector2(0.0, -14.0), 7.0, -PI * 0.75, -PI * 0.25, 6, Color("c65d58", 0.5), 1.0)


static func draw_station_28_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Carriage End Vestibule Door to Space 29 (Peron trzynasty / Podstruktura): 32x50 px
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	var door_rect := Rect2(-16.0, -25.0, 32.0, 50.0)
	
	# Heavy carriage interconnect vestibule frame
	ci.draw_rect(door_rect, Color("10161a"))
	ci.draw_rect(door_rect, Color("3b5663", 0.9), false, 1.2)
	
	# Double rubber seal bellows
	ci.draw_rect(Rect2(-14.0, -23.0, 28.0, 46.0), Color("172228"))
	ci.draw_line(Vector2(0.0, -23.0), Vector2(0.0, 23.0), Color("091013"), 1.5)
	
	# Viewport into the 13th Platform
	var view_rect := Rect2(-8.0, -16.0, 16.0, 14.0)
	ci.draw_rect(view_rect, Color("070c0f"))
	ci.draw_rect(view_rect, Color("5da398", 0.35 if not p_is_activated else 0.95))
	
	# Destination sign: "29 / PERON TRZYNASTY — PODSTRUKTURA"
	ci.draw_rect(Rect2(-13.0, -21.0, 26.0, 3.5), Color("090e11"))
	ci.draw_line(Vector2(-11.0, -19.5), Vector2(11.0, -19.5), Color("c8a370", 0.85), 0.8)
	
	if p_is_activated:
		# Unlocked & carriage door sliding open
		ci.draw_rect(door_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45 + pulse * 0.25), false, 1.5)
		ci.draw_line(Vector2(-16.0, 25.0), Vector2(16.0, 25.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.9), 2.0)
		ci.draw_rect(Rect2(-10.0, 0.0, 20.0, 23.0), Color("05080a"))
		ci.draw_line(Vector2(0.0, 2.0), Vector2(0.0, 22.0), Color("5da398", 0.8), 1.2)
	else:
		# Pneumatic clamp locked
		ci.draw_circle(Vector2(0.0, 10.0), 1.6, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.6 + pulse * 0.3))


static func draw_abandoned_platform_tracks(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Abandoned Rail Buffer Stop & Tracks: 48x24 px
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	var track_rect := Rect2(-24.0, -12.0, 48.0, 24.0)
	
	# Dark gravel ballast base
	ci.draw_rect(track_rect, Color("0e1417"))
	
	# Wooden sleepers (dark rotted timber)
	for s in range(5):
		var sx := -20.0 + float(s) * 9.0
		ci.draw_rect(Rect2(sx, -8.0, 6.0, 16.0), Color("171d21"))
		ci.draw_rect(Rect2(sx, -8.0, 6.0, 16.0), Color("28343b", 0.5), false, 0.6)
	
	# Rusted steel rails with orange oxide spots
	ci.draw_line(Vector2(-24.0, -4.0), Vector2(16.0, -4.0), Color("5a4838"), 1.8)
	ci.draw_line(Vector2(-24.0, 4.0), Vector2(16.0, 4.0), Color("5a4838"), 1.8)
	ci.draw_line(Vector2(-24.0, -4.0), Vector2(16.0, -4.0), Color("a66d42", 0.7), 0.8)
	
	# Concrete & steel buffer stop / bumper at end of line (x=12..22)
	var bumper_rect := Rect2(12.0, -10.0, 10.0, 20.0)
	ci.draw_rect(bumper_rect, Color("1e282f"))
	ci.draw_rect(bumper_rect, Color("4a6270"), false, 1.0)
	
	# Buffer red reflector target
	ci.draw_circle(Vector2(17.0, -2.0), 2.2, Color("c65d58", 0.9 if p_is_activated else 0.5 + pulse * 0.2))
	
	# Reflective oily puddle between rails
	ci.draw_line(Vector2(-12.0, 8.0), Vector2(4.0, 8.0), Color("5da398", 0.35 + pulse * 0.2), 1.0)


static func draw_flickering_neon_sign(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Flickering 1970s Neon Station Sign "PERON 13": 50x18 px
	var pulse := sin(p_pulse * 6.5) * 0.5 + 0.5
	var flicker := 0.9 if (pulse > 0.25 or p_is_activated) else 0.2
	var sign_rect := Rect2(-25.0, -9.0, 50.0, 18.0)
	
	# Dark enameled metal backing plate with rounded corners
	ci.draw_rect(sign_rect, Color("0a1014"))
	ci.draw_rect(sign_rect, Color("2d404b"), false, 1.0)
	
	# High voltage power cable feeding sign from ceiling
	ci.draw_line(Vector2(-18.0, -16.0), Vector2(-18.0, -9.0), Color("3d5562"), 1.2)
	ci.draw_circle(Vector2(-18.0, -9.0), 1.5, Color("d39a62"))
	
	# Turquoise / Cyan glowing neon tube lettering: "P E R O N   1 3"
	var neon_col := Color("75c7c3", flicker)
	var neon_glow := Color("5da398", flicker * 0.4)
	
	# Outer glow border
	ci.draw_rect(Rect2(-23.0, -7.0, 46.0, 14.0), neon_glow, false, 2.0)
	
	# Neon tube segment strokes
	# P
	ci.draw_line(Vector2(-20.0, -5.0), Vector2(-20.0, 5.0), neon_col, 1.2)
	ci.draw_line(Vector2(-20.0, -5.0), Vector2(-16.0, -5.0), neon_col, 1.2)
	ci.draw_line(Vector2(-16.0, -5.0), Vector2(-16.0, 0.0), neon_col, 1.2)
	ci.draw_line(Vector2(-20.0, 0.0), Vector2(-16.0, 0.0), neon_col, 1.2)
	# E
	ci.draw_line(Vector2(-13.0, -5.0), Vector2(-13.0, 5.0), neon_col, 1.2)
	ci.draw_line(Vector2(-13.0, -5.0), Vector2(-9.0, -5.0), neon_col, 1.2)
	ci.draw_line(Vector2(-13.0, 0.0), Vector2(-10.0, 0.0), neon_col, 1.2)
	ci.draw_line(Vector2(-13.0, 5.0), Vector2(-9.0, 5.0), neon_col, 1.2)
	# R
	ci.draw_line(Vector2(-6.0, -5.0), Vector2(-6.0, 5.0), neon_col, 1.2)
	ci.draw_line(Vector2(-6.0, -5.0), Vector2(-2.0, -5.0), neon_col, 1.2)
	ci.draw_line(Vector2(-2.0, -5.0), Vector2(-2.0, 0.0), neon_col, 1.2)
	ci.draw_line(Vector2(-6.0, 0.0), Vector2(-2.0, 0.0), neon_col, 1.2)
	ci.draw_line(Vector2(-4.0, 0.0), Vector2(-2.0, 5.0), neon_col, 1.2)
	# O
	ci.draw_rect(Rect2(1.0, -5.0, 5.0, 10.0), neon_col, false, 1.2)
	# N
	ci.draw_line(Vector2(9.0, -5.0), Vector2(9.0, 5.0), neon_col, 1.2)
	ci.draw_line(Vector2(9.0, -5.0), Vector2(14.0, 5.0), neon_col, 1.2)
	ci.draw_line(Vector2(14.0, -5.0), Vector2(14.0, 5.0), neon_col, 1.2)
	# 13
	ci.draw_line(Vector2(18.0, -5.0), Vector2(18.0, 5.0), Color("e2b060", flicker), 1.2)
	ci.draw_line(Vector2(21.0, -5.0), Vector2(24.0, -5.0), Color("e2b060", flicker), 1.2)
	ci.draw_line(Vector2(24.0, -5.0), Vector2(22.0, 0.0), Color("e2b060", flicker), 1.2)
	ci.draw_line(Vector2(22.0, 0.0), Vector2(24.0, 5.0), Color("e2b060", flicker), 1.2)
	ci.draw_line(Vector2(21.0, 5.0), Vector2(24.0, 5.0), Color("e2b060", flicker), 1.2)


static func draw_deep_substructure_well(ci: CanvasItem, p_pulse: float) -> void:
	# Deep Ventilation & Maintenance Shaft into Substructure: 40x32 px
	var pulse := sin(p_pulse * 1.8) * 0.5 + 0.5
	var well_rect := Rect2(-20.0, -16.0, 40.0, 32.0)
	
	# Massive concrete shaft frame with cast-iron rim
	ci.draw_rect(well_rect, Color("121a1f"))
	ci.draw_rect(well_rect, Color("394f5c"), false, 1.2)
	
	# Dark vertical shaft abyss
	var hole_rect := Rect2(-16.0, -12.0, 32.0, 24.0)
	ci.draw_rect(hole_rect, Color("040709"))
	
	# Deep depth gradient rings
	ci.draw_rect(Rect2(-12.0, -8.0, 24.0, 16.0), Color("081014"))
	ci.draw_rect(Rect2(-8.0, -4.0, 16.0, 8.0), Color("030507"))
	
	# Rotating exhaust turbine blades in the deep (silhouette)
	var blade_angle := p_pulse * 1.5
	for b in range(4):
		var angle := blade_angle + float(b) * (PI * 0.5)
		ci.draw_line(Vector2.ZERO, Vector2(cos(angle) * 7.0, sin(angle) * 7.0), Color("1e2a33", 0.7), 1.5)
	
	# Yellow hazard warning chevrons along edge
	for h in range(4):
		var hx := -15.0 + float(h) * 8.0
		ci.draw_line(Vector2(hx, 13.0), Vector2(hx + 3.0, 15.0), Color("e29b42", 0.8), 1.0)
	
	# Condensate drainage pipe with active drop
	ci.draw_line(Vector2(-14.0, -16.0), Vector2(-14.0, -6.0), Color("4a6878"), 1.5)
	ci.draw_circle(Vector2(-14.0, -4.0 + pulse * 6.0), 1.2, Color("5da398", 0.85))


static func draw_jakub_torch_beacon(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Jakub Wolski holding industrial flashlight beacon: 28x40 px
	var pulse := sin(p_pulse * 2.2) * 0.5 + 0.5
	
	# Jakub silhouette in worker coat and utility harness
	# Body / Coat
	ci.draw_rect(Rect2(-7.0, -8.0, 14.0, 22.0), Color("172228"))
	ci.draw_rect(Rect2(-7.0, -8.0, 14.0, 22.0), Color("3d5562", 0.7), false, 1.0)
	
	# Head
	ci.draw_circle(Vector2(0.0, -14.0), 4.5, Color("c8a370"))
	# Service cap
	ci.draw_rect(Rect2(-5.0, -18.0, 10.0, 3.5), Color("121a1f"))
	ci.draw_line(Vector2(-5.0, -14.5), Vector2(6.0, -14.5), Color("3d5562"), 1.0)
	
	# Utility harness straps (orange/amber)
	ci.draw_line(Vector2(-5.0, -7.0), Vector2(4.0, 6.0), Color("d39a62", 0.85), 1.2)
	ci.draw_line(Vector2(5.0, -7.0), Vector2(-4.0, 6.0), Color("d39a62", 0.85), 1.2)
	
	# Legs
	ci.draw_rect(Rect2(-6.0, 14.0, 4.0, 8.0), Color("11171c"))
	ci.draw_rect(Rect2(2.0, 14.0, 4.0, 8.0), Color("11171c"))
	
	# Heavy flashlight housing in right hand (pointing forward right)
	var torch_pos := Vector2(8.0, 0.0)
	ci.draw_rect(Rect2(torch_pos.x, torch_pos.y - 2.5, 9.0, 5.0), Color("2b3c46"))
	ci.draw_circle(Vector2(torch_pos.x + 9.0, torch_pos.y), 2.8, Color("e2b060"))
	
	# Conical light beam illuminating the way to the right
	var beam_points := PackedVector2Array([
		Vector2(torch_pos.x + 10.0, torch_pos.y - 1.5),
		Vector2(torch_pos.x + 36.0, torch_pos.y - 14.0),
		Vector2(torch_pos.x + 36.0, torch_pos.y + 14.0),
		Vector2(torch_pos.x + 10.0, torch_pos.y + 1.5)
	])
	var beam_alpha := 0.35 + pulse * 0.15 if p_is_activated else 0.20
	ci.draw_colored_polygon(beam_points, Color(0.92, 0.82, 0.55, beam_alpha))


static func draw_station_29_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy Rusted Security Mesh Grate to Space 30 (Sektor Zasilania): 34x52 px
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	var gate_rect := Rect2(-17.0, -26.0, 34.0, 52.0)
	
	# Rusted iron door frame
	ci.draw_rect(gate_rect, Color("141b20"))
	ci.draw_rect(gate_rect, Color("4a3c30", 0.9), false, 1.5)
	
	# Diamond steel mesh pattern inside gate
	var mesh_rect := Rect2(-14.0, -23.0, 28.0, 46.0)
	ci.draw_rect(mesh_rect, Color("080d10"))
	for m in range(6):
		var my := -20.0 + float(m) * 7.5
		ci.draw_line(Vector2(-14.0, my), Vector2(14.0, my + 6.0), Color("3d4b54", 0.6), 0.8)
		ci.draw_line(Vector2(-14.0, my + 6.0), Vector2(14.0, my), Color("3d4b54", 0.6), 0.8)
	
	# Archive & Sector placard: "30 / SEKTOR ZASILANIA — ROZDZIELNIA GŁÓWNA"
	ci.draw_rect(Rect2(-15.0, -24.0, 30.0, 3.5), Color("0a1013"))
	ci.draw_line(Vector2(-13.0, -22.5), Vector2(13.0, -22.5), Color("e2b060", 0.85), 0.8)
	
	if p_is_activated:
		# Grate unlatched and swinging open
		ci.draw_rect(gate_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45 + pulse * 0.25), false, 1.5)
		ci.draw_line(Vector2(-17.0, 26.0), Vector2(17.0, 26.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.9), 2.0)
		ci.draw_rect(Rect2(-12.0, 0.0, 24.0, 24.0), Color("040709"))
		ci.draw_line(Vector2(0.0, 2.0), Vector2(0.0, 24.0), Color("5da398", 0.8), 1.2)
	else:
		# Padlock locked with rusted chain
		ci.draw_circle(Vector2(0.0, 5.0), 2.2, Color("a66d42"))
		ci.draw_circle(Vector2(0.0, 5.0), 1.2, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.7 + pulse * 0.3))


static func draw_main_power_distribution_board(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Main Power Distribution Board: 46x40 px industrial electrical cabinet
	var pulse := sin(p_pulse * 2.8) * 0.5 + 0.5
	var cabinet_rect := Rect2(-23.0, -20.0, 46.0, 40.0)
	
	# Dark enameled steel housing
	ci.draw_rect(cabinet_rect, Color("151e24"))
	ci.draw_rect(cabinet_rect, Color("2d3c47"), false, 1.2)
	
	# Horizontal copper busbars (3 phases: L1, L2, L3)
	for b in range(3):
		var by := -14.0 + float(b) * 6.5
		ci.draw_line(Vector2(-20.0, by), Vector2(20.0, by), Color("b87333"), 1.8)
		# Busbar insulator mountings
		ci.draw_rect(Rect2(-18.0, by - 1.5, 3.0, 3.0), Color("8a4a22"))
		ci.draw_rect(Rect2(15.0, by - 1.5, 3.0, 3.0), Color("8a4a22"))
	
	# Analog Voltmeter & Ammeter round gauges
	ci.draw_circle(Vector2(-10.0, 10.0), 5.5, Color("0a1014"))
	ci.draw_circle(Vector2(-10.0, 10.0), 5.5, Color("425c6d"), false, 1.0)
	var needle_angle_v := -0.6 + (0.8 if p_is_activated else 0.3) + pulse * 0.1
	ci.draw_line(Vector2(-10.0, 10.0), Vector2(-10.0 + cos(needle_angle_v) * 4.0, 10.0 + sin(needle_angle_v) * 4.0), Color("e2b060"), 1.0)
	
	ci.draw_circle(Vector2(10.0, 10.0), 5.5, Color("0a1014"))
	ci.draw_circle(Vector2(10.0, 10.0), 5.5, Color("425c6d"), false, 1.0)
	var needle_angle_a := -0.4 + (1.1 if p_is_activated else 0.5)
	ci.draw_line(Vector2(10.0, 10.0), Vector2(10.0 + cos(needle_angle_a) * 4.0, 10.0 + sin(needle_angle_a) * 4.0), Color("c65d58"), 1.0)
	
	# Section indicator pilot lamps (4 sections: 1..4)
	for s in range(4):
		var sx := -15.0 + float(s) * 10.0
		var lamp_col := Color("5da398") if (p_is_activated or s < 3) else Color("c65d58")
		ci.draw_circle(Vector2(sx, -2.0), 1.8, lamp_col)
		ci.draw_circle(Vector2(sx, -2.0), 0.9, Color.WHITE)


static func draw_high_voltage_transformer_bank(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy Oil-Cooled Step-Down Transformer: 38x44 px
	var pulse := sin(p_pulse * 3.2) * 0.5 + 0.5
	var tank_rect := Rect2(-19.0, -14.0, 38.0, 34.0)
	
	# Heavy transformer tank body
	ci.draw_rect(tank_rect, Color("161e24"))
	ci.draw_rect(tank_rect, Color("344855"), false, 1.2)
	
	# Cooling radiator fins on tank sides
	for f in range(6):
		var fx := -16.0 + float(f) * 6.4
		ci.draw_line(Vector2(fx, -12.0), Vector2(fx, 18.0), Color("212d35"), 1.5)
	
	# High voltage ceramic ribbed insulators / bushings on top
	for b in range(3):
		var bx := -12.0 + float(b) * 12.0
		# Ceramic insulator discs
		ci.draw_rect(Rect2(bx - 3.0, -22.0, 6.0, 8.0), Color("3d4b54"))
		ci.draw_line(Vector2(bx - 4.0, -20.0), Vector2(bx + 4.0, -20.0), Color("8a9ba8"), 1.0)
		ci.draw_line(Vector2(bx - 4.0, -17.0), Vector2(bx + 4.0, -17.0), Color("8a9ba8"), 1.0)
		# Terminal cap
		ci.draw_circle(Vector2(bx, -22.0), 1.8, Color("b87333"))
		# Corona spark emission if active
		if p_is_activated or pulse > 0.65:
			ci.draw_line(Vector2(bx, -22.0), Vector2(bx + sin(pulse * 10.0 + float(b)) * 4.0, -26.0), Color(0.4, 0.85, 1.0, 0.75), 0.8)
	
	# Oil level glass sight gauge
	ci.draw_rect(Rect2(14.0, -6.0, 3.0, 16.0), Color("0a1014"))
	ci.draw_rect(Rect2(14.5, -2.0, 2.0, 11.0), Color("d39a62", 0.75))


static func draw_section_breaker_lever(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# 3-Phase Industrial Knife Switch Breaker: 28x36 px
	var pulse := sin(p_pulse * 2.5) * 0.5 + 0.5
	var base_rect := Rect2(-14.0, -18.0, 28.0, 36.0)
	
	# Slate mounting board
	ci.draw_rect(base_rect, Color("131a1f"))
	ci.draw_rect(base_rect, Color("2d3b45"), false, 1.0)
	
	# Copper stationary jaw contacts
	for j in range(3):
		var jx := -9.0 + float(j) * 9.0
		ci.draw_rect(Rect2(jx - 2.0, -14.0, 4.0, 6.0), Color("b87333"))
		ci.draw_rect(Rect2(jx - 2.0, 8.0, 4.0, 6.0), Color("b87333"))
	
	# Heavy knife blade bar & insulated operating handle
	var blade_color := Color("d39a62") if p_is_activated else Color("8a542a")
	if p_is_activated:
		# Breaker thrown OPEN / DISENGAGED (angled upwards at 45 deg)
		for j in range(3):
			var jx := -9.0 + float(j) * 9.0
			ci.draw_line(Vector2(jx, 8.0), Vector2(jx + 6.0, -8.0), blade_color, 1.8)
		# Crossbar & red operating handle
		ci.draw_line(Vector2(-9.0 + 6.0, -8.0), Vector2(9.0 + 6.0, -8.0), Color("4a221a"), 2.0)
		ci.draw_circle(Vector2(9.0 + 9.0, -10.0), 3.0, Color("c65d58"))
		# Arc spark extinction trace
		ci.draw_line(Vector2(0.0, 0.0), Vector2(4.0, -4.0), Color(0.5, 0.9, 1.0, 0.5 + pulse * 0.4), 1.0)
	else:
		# Breaker ENGAGED / CLOSED (straight vertical into upper contacts)
		for j in range(3):
			var jx := -9.0 + float(j) * 9.0
			ci.draw_line(Vector2(jx, 8.0), Vector2(jx, -12.0), blade_color, 1.8)
		# Crossbar & red handle
		ci.draw_line(Vector2(-9.0, -12.0), Vector2(9.0, -12.0), Color("4a221a"), 2.0)
		ci.draw_circle(Vector2(12.0, -12.0), 3.0, Color("e2b060"))


static func draw_grid_schematic_display(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Backlit Memory Grid Schematic Board: 44x32 px
	var pulse := sin(p_pulse * 2.2) * 0.5 + 0.5
	var board_rect := Rect2(-22.0, -16.0, 44.0, 32.0)
	
	# Dark cyan grid matrix background
	ci.draw_rect(board_rect, Color("081014"))
	ci.draw_rect(board_rect, Color("3e5866"), false, 1.2)
	
	# Grid trace lines
	ci.draw_line(Vector2(-18.0, 0.0), Vector2(18.0, 0.0), Color("1a2e38"), 1.0)
	ci.draw_line(Vector2(-8.0, -12.0), Vector2(-8.0, 12.0), Color("1a2e38"), 1.0)
	ci.draw_line(Vector2(8.0, -12.0), Vector2(8.0, 12.0), Color("1a2e38"), 1.0)
	
	# Node 1: Marta Kurek (amber pulsing anomaly node)
	var marta_alpha := 0.85 + pulse * 0.15
	ci.draw_circle(Vector2(-14.0, -6.0), 3.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, marta_alpha))
	ci.draw_circle(Vector2(-14.0, -6.0), 1.2, Color.WHITE)
	
	# Node 2: Jakub Wolski (cyan technician line)
	ci.draw_circle(Vector2(0.0, 4.0), 2.5, Color("5da398"))
	ci.draw_circle(Vector2(0.0, 4.0), 1.0, Color.WHITE)
	
	# Node 3: Szymon Bera (hydrology / sedated node)
	ci.draw_circle(Vector2(12.0, -6.0), 2.2, Color("4a6878"))
	
	# Node 4: Substructure Central Register (target terminus)
	ci.draw_rect(Rect2(6.0, 6.0, 8.0, 6.0), Color("1d2c36"))
	ci.draw_rect(Rect2(6.0, 6.0, 8.0, 6.0), Color("e2b060" if p_is_activated else "5da398"), false, 1.0)
	
	# Active schematic power path
	var path_color := Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.8 if p_is_activated else 0.4)
	ci.draw_line(Vector2(-14.0, -6.0), Vector2(0.0, 4.0), path_color, 1.2)
	ci.draw_line(Vector2(0.0, 4.0), Vector2(10.0, 9.0), path_color, 1.2)


static func draw_station_30_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Magnetically Shielded Vault Gate to Space 31 (Magazyn Dowodów / Jedenaście Krzeseł): 34x52 px
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	var gate_rect := Rect2(-17.0, -26.0, 34.0, 52.0)
	
	# Heavy lead-shielded steel gate body
	ci.draw_rect(gate_rect, Color("12191e"))
	ci.draw_rect(gate_rect, Color("3d5260"), false, 1.5)
	
	# Interlocking magnetic seal seams
	ci.draw_line(Vector2(0.0, -24.0), Vector2(0.0, 24.0), Color("212d35"), 1.8)
	ci.draw_line(Vector2(-14.0, 0.0), Vector2(14.0, 0.0), Color("212d35"), 1.2)
	
	# Circular leaded glass observation portal
	ci.draw_circle(Vector2(0.0, -10.0), 5.5, Color("080d10"))
	ci.draw_circle(Vector2(0.0, -10.0), 5.5, Color("5da398" if p_is_activated else "c65d58"), false, 1.0)
	ci.draw_circle(Vector2(0.0, -10.0), 2.0, Color("5da398" if p_is_activated else "c65d58", 0.6))
	
	# Archive & Sector placard: "31 / MAGAZYN DOWODÓW — JEDENAŚCIE KRZESEŁ"
	ci.draw_rect(Rect2(-15.0, -24.0, 30.0, 3.5), Color("0a1013"))
	ci.draw_line(Vector2(-13.0, -22.5), Vector2(13.0, -22.5), Color("e2b060", 0.85), 0.8)
	
	# Heavy electromagnetic coil housings on sides
	ci.draw_rect(Rect2(-19.0, -6.0, 4.0, 12.0), Color("24333d"))
	ci.draw_rect(Rect2(15.0, -6.0, 4.0, 12.0), Color("24333d"))
	
	if p_is_activated:
		# Deionized magnetic lock, door split apart
		ci.draw_rect(gate_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45 + pulse * 0.25), false, 1.5)
		ci.draw_line(Vector2(-17.0, 26.0), Vector2(17.0, 26.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.9), 2.0)
		ci.draw_rect(Rect2(-10.0, 6.0, 20.0, 18.0), Color("030608"))
		ci.draw_line(Vector2(0.0, 6.0), Vector2(0.0, 24.0), Color("5da398", 0.8), 1.2)
	else:
		# Magnetic lock active with warning diode
		ci.draw_circle(Vector2(0.0, 12.0), 2.2, Color("c65d58"))
		ci.draw_circle(Vector2(0.0, 12.0), 1.0, Color(1.0, 0.5, 0.4, 0.8 + pulse * 0.2))


static func draw_eleven_chairs_archive_row(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Row of 11 Wooden Archive Chairs with Personal Artefacts: 72x28 px
	var pulse := sin(p_pulse * 2.2) * 0.5 + 0.5
	var chair_base_y := 8.0
	
	# Draw miniature row of chairs
	for c in range(5):
		var cx := -28.0 + float(c) * 14.0
		# Wooden chair backrest & seat
		ci.draw_line(Vector2(cx - 3.0, chair_base_y - 14.0), Vector2(cx - 3.0, chair_base_y + 4.0), Color("4a3322"), 1.2)
		ci.draw_line(Vector2(cx + 3.0, chair_base_y - 14.0), Vector2(cx + 3.0, chair_base_y + 4.0), Color("4a3322"), 1.2)
		ci.draw_line(Vector2(cx - 4.0, chair_base_y - 12.0), Vector2(cx + 4.0, chair_base_y - 12.0), Color("6e4d34"), 1.5)
		ci.draw_line(Vector2(cx - 4.0, chair_base_y - 2.0), Vector2(cx + 4.0, chair_base_y - 2.0), Color("8a5e3c"), 1.8)
		# Chair legs
		ci.draw_line(Vector2(cx - 3.0, chair_base_y - 2.0), Vector2(cx - 3.0, chair_base_y + 8.0), Color("382417"), 1.0)
		ci.draw_line(Vector2(cx + 3.0, chair_base_y - 2.0), Vector2(cx + 3.0, chair_base_y + 8.0), Color("382417"), 1.0)
		
		# Individual personal items on seats
		match c:
			0: # Railway coat with tickets
				ci.draw_rect(Rect2(cx - 3.5, chair_base_y - 5.0, 7.0, 4.0), Color("1e2c38"))
				ci.draw_line(Vector2(cx - 1.0, chair_base_y - 4.0), Vector2(cx + 2.0, chair_base_y - 4.0), Color("d39a62"), 0.8)
			1: # Leather briefcase with sheet music
				ci.draw_rect(Rect2(cx - 3.0, chair_base_y - 6.0, 6.0, 5.0), Color("5c3a21"))
				ci.draw_line(Vector2(cx - 1.5, chair_base_y - 3.5), Vector2(cx + 1.5, chair_base_y - 3.5), Color("e2b060"), 0.8)
			2: # Lady's handbag
				ci.draw_circle(Vector2(cx, chair_base_y - 4.0), 2.5, Color("422838"))
				ci.draw_circle(Vector2(cx, chair_base_y - 4.0), 1.0, Color("c65d58"))
			3: # Child's glove
				ci.draw_rect(Rect2(cx - 2.0, chair_base_y - 4.0, 4.0, 3.0), Color("c65d58"))
			4: # Watch with cracked crystal
				ci.draw_circle(Vector2(cx, chair_base_y - 4.0), 2.0, Color("a8b2ac"))
				ci.draw_circle(Vector2(cx, chair_base_y - 4.0), 1.0, Color.WHITE)
	
	# Reverberant memory whisper glow if active
	if p_is_activated or pulse > 0.6:
		for c in range(5):
			var cx := -28.0 + float(c) * 14.0
			ci.draw_circle(Vector2(cx, chair_base_y - 8.0), 3.5, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.15 + pulse * 0.15))


static func draw_wierzbicka_remote_holoterminal(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Holographic Terminal projecting Dr. Helena Wierzbicka: 32x42 px
	var pulse := sin(p_pulse * 3.0) * 0.5 + 0.5
	var terminal_rect := Rect2(-16.0, -18.0, 32.0, 36.0)
	
	# Wall terminal bracket
	ci.draw_rect(terminal_rect, Color("141d24"))
	ci.draw_rect(terminal_rect, Color("3e5866"), false, 1.0)
	
	# Holographic projector emitter dish
	ci.draw_circle(Vector2(0.0, 10.0), 5.0, Color("081014"))
	ci.draw_circle(Vector2(0.0, 10.0), 5.0, Color("5da398"), false, 1.0)
	ci.draw_circle(Vector2(0.0, 10.0), 2.0, Color(0.4, 0.9, 1.0, 0.85))
	
	# Holographic projection beam & bust of Dr. Helena Wierzbicka
	var holo_alpha := 0.70 + pulse * 0.20 if p_is_activated else 0.40
	var holo_col := Color(0.35, 0.85, 0.95, holo_alpha)
	
	# Holo beam cone
	var beam := PackedVector2Array([
		Vector2(-4.0, 10.0),
		Vector2(-12.0, -12.0),
		Vector2(12.0, -12.0),
		Vector2(4.0, 10.0)
	])
	ci.draw_colored_polygon(beam, Color(0.2, 0.7, 0.9, 0.12 + pulse * 0.08))
	
	# Wierzbicka holographic silhouette head & shoulders
	ci.draw_circle(Vector2(0.0, -8.0), 3.5, holo_col)
	ci.draw_rect(Rect2(-5.0, -4.0, 10.0, 6.0), holo_col)
	
	# Scanlines across hologram
	for s in range(4):
		var sy := -12.0 + float(s) * 4.0 + sin(pulse * 6.0) * 1.5
		ci.draw_line(Vector2(-10.0, sy), Vector2(10.0, sy), Color(1.0, 1.0, 1.0, 0.4), 0.8)


static func draw_jakub_twelfth_chair(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# The Twelfth Chair (Jakub's Chair): 24x32 px
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	var chair_base_y := 6.0
	
	# Large detailed wooden armchair
	ci.draw_line(Vector2(-7.0, chair_base_y - 18.0), Vector2(-7.0, chair_base_y + 8.0), Color("4a3322"), 1.8)
	ci.draw_line(Vector2(7.0, chair_base_y - 18.0), Vector2(7.0, chair_base_y + 8.0), Color("4a3322"), 1.8)
	ci.draw_line(Vector2(-8.0, chair_base_y - 16.0), Vector2(8.0, chair_base_y - 16.0), Color("6e4d34"), 2.0)
	ci.draw_line(Vector2(-8.0, chair_base_y - 8.0), Vector2(8.0, chair_base_y - 8.0), Color("6e4d34"), 1.5)
	ci.draw_line(Vector2(-9.0, chair_base_y - 1.0), Vector2(9.0, chair_base_y - 1.0), Color("8a5e3c"), 2.2)
	
	# Chair front legs
	ci.draw_line(Vector2(-7.0, chair_base_y - 1.0), Vector2(-7.0, chair_base_y + 12.0), Color("382417"), 1.5)
	ci.draw_line(Vector2(7.0, chair_base_y - 1.0), Vector2(7.0, chair_base_y + 12.0), Color("382417"), 1.5)
	
	# Jakub's Brass Technician Badge & Tram Service Book on seat
	ci.draw_rect(Rect2(-4.0, chair_base_y - 5.0, 8.0, 4.0), Color("1b2a34"))
	ci.draw_circle(Vector2(0.0, chair_base_y - 3.0), 1.8, Color("e2b060"))
	ci.draw_circle(Vector2(0.0, chair_base_y - 3.0), 0.8, Color.WHITE)
	
	if p_is_activated:
		# Melancholy amber resonance halo
		ci.draw_circle(Vector2(0.0, chair_base_y - 6.0), 10.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.18 + pulse * 0.12))


static func draw_variant_choice_ledger(ci: CanvasItem, p_pulse: float) -> void:
	# Open UCP Variant Decision Ledger on Cast-Iron Lectern: 36x28 px
	var pulse := sin(p_pulse * 2.4) * 0.5 + 0.5
	var lectern_rect := Rect2(-18.0, -10.0, 36.0, 20.0)
	
	# Cast-iron pedestal
	ci.draw_line(Vector2(0.0, 10.0), Vector2(0.0, 20.0), Color("1c262e"), 3.0)
	ci.draw_line(Vector2(-8.0, 20.0), Vector2(8.0, 20.0), Color("2c3c47"), 2.0)
	
	# Slanted book rest
	ci.draw_rect(lectern_rect, Color("141c22"))
	ci.draw_rect(lectern_rect, Color("3b4e5b"), false, 1.0)
	
	# Open two-page ledger (parchment white / archive gray)
	var left_page := Rect2(-15.0, -8.0, 14.0, 15.0)
	var right_page := Rect2(1.0, -8.0, 14.0, 15.0)
	ci.draw_rect(left_page, Color("2a353d"))
	ci.draw_rect(right_page, Color("2a353d"))
	
	# Text lines on left page (list of 11 crossed out names)
	for l in range(4):
		var ly := -6.0 + float(l) * 3.2
		ci.draw_line(Vector2(-13.0, ly), Vector2(-3.0, ly), Color("8a9ba8", 0.7), 0.8)
		ci.draw_line(Vector2(-13.0, ly), Vector2(-3.0, ly), Color("c65d58", 0.8), 0.6)
	
	# Right page red handwritten inscription: "WYBRANO WARIANT, NIE CZŁOWIEKA"
	ci.draw_rect(Rect2(3.0, -6.0, 10.0, 2.5), Color("c65d58", 0.9))
	ci.draw_line(Vector2(3.0, -1.0), Vector2(11.0, -1.0), Color("d39a62", 0.85), 0.8)
	
	# Official UCP embossed red wax seal
	ci.draw_circle(Vector2(7.0, 3.0), 2.2, Color("a63832"))
	ci.draw_circle(Vector2(7.0, 3.0), 1.0, Color("e2b060"))


static func draw_station_31_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy Glass Pressure-Sealed Airlock Gate to Space 32 (Ślad w szkle / Korytarz Luster): 34x52 px
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	var gate_rect := Rect2(-17.0, -26.0, 34.0, 52.0)
	
	# Structural steel airlock portal frame
	ci.draw_rect(gate_rect, Color("10161b"))
	ci.draw_rect(gate_rect, Color("344955"), false, 1.5)
	
	# Heavy double-layer tempered observation glass
	var glass_rect := Rect2(-12.0, -20.0, 24.0, 40.0)
	ci.draw_rect(glass_rect, Color("070d11"))
	ci.draw_rect(glass_rect, Color(0.3, 0.6, 0.7, 0.4), false, 1.0)
	
	# Glass reflection sheen streaks
	ci.draw_line(Vector2(-8.0, -18.0), Vector2(6.0, 16.0), Color(1.0, 1.0, 1.0, 0.15), 1.5)
	ci.draw_line(Vector2(-4.0, -18.0), Vector2(10.0, 16.0), Color(1.0, 1.0, 1.0, 0.08), 1.0)
	
	# Archive & Sector placard: "32 / ŚLAD W SZKLE — KORYTARZ LUSTER"
	ci.draw_rect(Rect2(-15.0, -24.0, 30.0, 3.5), Color("0a1013"))
	ci.draw_line(Vector2(-13.0, -22.5), Vector2(13.0, -22.5), Color("e2b060", 0.85), 0.8)
	
	if p_is_activated:
		# Pressure decompressed, glass door retracting sideways
		ci.draw_rect(gate_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45 + pulse * 0.25), false, 1.5)
		ci.draw_line(Vector2(-17.0, 26.0), Vector2(17.0, 26.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.9), 2.0)
		ci.draw_rect(Rect2(-10.0, 0.0, 20.0, 24.0), Color("030608"))
		ci.draw_line(Vector2(0.0, 2.0), Vector2(0.0, 24.0), Color("5da398", 0.8), 1.2)
	else:
		# Pressure lock sealed with yellow clamp bolts
		ci.draw_circle(Vector2(-10.0, 0.0), 1.8, Color("e2b060"))
		ci.draw_circle(Vector2(10.0, 0.0), 1.8, Color("e2b060"))
		ci.draw_circle(Vector2(0.0, 14.0), 2.0, Color("c65d58"))


static func draw_steamed_glass_pane_a(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Steamed glass compensation pane (28x56 px): Calm consensus memory of empty morning street
	var pulse := sin(p_pulse * 1.8) * 0.5 + 0.5
	var frame_rect := Rect2(-14.0, -28.0, 28.0, 56.0)
	
	# Dark steel mounting struts & clamps
	ci.draw_rect(frame_rect, Color("101820"))
	ci.draw_rect(frame_rect, Color("2a3c4a"), false, 1.2)
	ci.draw_rect(Rect2(-12.0, -26.0, 24.0, 52.0), Color("0d141a"))
	
	# Steamed surface layer with diffuse mist texture
	var mist_col := Color(0.65, 0.78, 0.85, 0.35 + pulse * 0.12) if p_is_activated else Color(0.45, 0.55, 0.62, 0.28)
	ci.draw_rect(Rect2(-10.0, -24.0, 20.0, 48.0), mist_col)
	
	# Ghostly silhouette of empty tram tracks and streetlamp in reflection
	ci.draw_line(Vector2(-6.0, 18.0), Vector2(0.0, -8.0), Color("5da398", 0.45), 1.0)
	ci.draw_line(Vector2(6.0, 18.0), Vector2(3.0, -8.0), Color("5da398", 0.45), 1.0)
	ci.draw_circle(Vector2(-2.0, -14.0), 2.5, Color("e2b060", 0.40))
	
	# Condensation droplets running down
	ci.draw_line(Vector2(-4.0, -10.0), Vector2(-4.0, -2.0), Color(0.8, 0.9, 1.0, 0.5), 0.8)
	ci.draw_line(Vector2(4.0, -4.0), Vector2(4.0, 8.0), Color(0.8, 0.9, 1.0, 0.5), 0.8)
	
	# Sensor bracket & status bead
	var bead_col := Color("5da398") if p_is_activated else Color("d39a62")
	ci.draw_circle(Vector2(0.0, -26.0), 1.8, bead_col)


static func draw_cracked_glass_pane_b(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Cracked glass compensation pane (28x56 px): Muffled trauma of fire, impact and emergency sirens
	var pulse := sin(p_pulse * 2.4) * 0.5 + 0.5
	var frame_rect := Rect2(-14.0, -28.0, 28.0, 56.0)
	
	# Reinforced steel cage holding shattered glass together
	ci.draw_rect(frame_rect, Color("14181c"))
	ci.draw_rect(frame_rect, Color("3e4850"), false, 1.2)
	ci.draw_rect(Rect2(-12.0, -26.0, 24.0, 52.0), Color("0f1215"))
	
	# Deep spiderweb stress fracture network across the glass
	var crack_col := Color("c65d58", 0.75 + pulse * 0.25) if p_is_activated else Color("8a423e", 0.60)
	# Central impact point at (x=2, y=-4)
	ci.draw_circle(Vector2(2.0, -4.0), 2.2, Color("e2b060", 0.8))
	ci.draw_line(Vector2(2.0, -4.0), Vector2(-10.0, -20.0), crack_col, 1.2)
	ci.draw_line(Vector2(2.0, -4.0), Vector2(10.0, -16.0), crack_col, 1.2)
	ci.draw_line(Vector2(2.0, -4.0), Vector2(-8.0, 14.0), crack_col, 1.2)
	ci.draw_line(Vector2(2.0, -4.0), Vector2(8.0, 20.0), crack_col, 1.2)
	ci.draw_line(Vector2(2.0, -4.0), Vector2(-11.0, -2.0), crack_col, 1.0)
	ci.draw_line(Vector2(2.0, -4.0), Vector2(11.0, 2.0), crack_col, 1.0)
	
	# Secondary fracture rings
	ci.draw_arc(Vector2(2.0, -4.0), 7.0, 0.0, TAU, 12, crack_col, 0.8)
	ci.draw_arc(Vector2(2.0, -4.0), 14.0, 0.0, TAU, 16, Color(crack_col.r, crack_col.g, crack_col.b, 0.4), 0.8)
	
	# Fire smoke soot stain at top corner
	ci.draw_rect(Rect2(-10.0, -24.0, 10.0, 12.0), Color(0.08, 0.04, 0.04, 0.65))
	
	# Red hazard indicator lamp
	var lamp_col := Color("c65d58") if p_is_activated else Color("5a2020")
	ci.draw_circle(Vector2(0.0, -26.0), 2.0, lamp_col)


static func draw_polished_glass_pane_c(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Polished clinical glass pane (28x56 px): Sterile UCP consensus stamp and spotless reflection
	var pulse := sin(p_pulse * 1.5) * 0.5 + 0.5
	var frame_rect := Rect2(-14.0, -28.0, 28.0, 56.0)
	
	# Sterile aluminum frame & clear glass
	ci.draw_rect(frame_rect, Color("0e161c"))
	ci.draw_rect(frame_rect, Color("456070"), false, 1.2)
	ci.draw_rect(Rect2(-12.0, -26.0, 24.0, 52.0), Color("081016"))
	
	# Diagonal high-gloss polished reflection lines
	ci.draw_line(Vector2(-10.0, -18.0), Vector2(10.0, 18.0), Color(1.0, 1.0, 1.0, 0.25 + pulse * 0.15), 1.5)
	ci.draw_line(Vector2(-6.0, -22.0), Vector2(10.0, 8.0), Color(1.0, 1.0, 1.0, 0.12), 1.0)
	
	# Etched official UCP consensus symbol & registration stamp: "UCP-KONSENSUS-1988"
	ci.draw_rect(Rect2(-8.0, -6.0, 16.0, 12.0), Color("16242e"))
	ci.draw_rect(Rect2(-8.0, -6.0, 16.0, 12.0), Color("5da398", 0.7), false, 1.0)
	ci.draw_line(Vector2(-6.0, 0.0), Vector2(6.0, 0.0), Color("5da398", 0.8), 1.0)
	ci.draw_circle(Vector2(0.0, 0.0), 2.5, Color("5da398", 0.6))
	
	# Clinical blue compliance badge
	var seal_col := Color("5da398") if p_is_activated else Color("325058")
	ci.draw_circle(Vector2(0.0, -26.0), 1.8, seal_col)


static func draw_condensation_trace_etcher(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Central Condensation Trace Etcher (32x48 px): Interactive glass plate where Lena draws the Trace
	var pulse := sin(p_pulse * 2.2) * 0.5 + 0.5
	var stand_rect := Rect2(-16.0, -24.0, 32.0, 48.0)
	
	# Heavy laboratory pedestal & glass mounting stanchions
	ci.draw_line(Vector2(0.0, 20.0), Vector2(0.0, 26.0), Color("202a32"), 4.0)
	ci.draw_rect(Rect2(-12.0, 24.0, 24.0, 4.0), Color("161f26"))
	
	# Main glass plate
	ci.draw_rect(stand_rect, Color("0d151c"))
	ci.draw_rect(stand_rect, Color("3d5566"), false, 1.5)
	
	# Steamed surface background
	ci.draw_rect(Rect2(-13.0, -21.0, 26.0, 42.0), Color(0.55, 0.70, 0.80, 0.30))
	
	# Drawn Trace lines (finger wipe path revealing clear glowing cyan glass underneath)
	var trace_col := Color("5da398", 0.90 + pulse * 0.10) if p_is_activated else Color("d39a62", 0.75)
	# Geometric double-loop resonance trace
	ci.draw_line(Vector2(-8.0, 12.0), Vector2(-8.0, -8.0), trace_col, 2.0)
	ci.draw_line(Vector2(-8.0, -8.0), Vector2(0.0, -16.0), trace_col, 2.0)
	ci.draw_line(Vector2(0.0, -16.0), Vector2(8.0, -8.0), trace_col, 2.0)
	ci.draw_line(Vector2(8.0, -8.0), Vector2(8.0, 12.0), trace_col, 2.0)
	ci.draw_line(Vector2(8.0, 12.0), Vector2(0.0, 4.0), trace_col, 2.0)
	ci.draw_line(Vector2(0.0, 4.0), Vector2(-8.0, 12.0), trace_col, 2.0)
	
	# Core resonance node in center of trace
	ci.draw_circle(Vector2(0.0, -6.0), 3.0, Color("e2b060", 0.9))
	if p_is_activated:
		ci.draw_circle(Vector2(0.0, -6.0), 6.0 + pulse * 2.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35))
	
	# Inscribed text on glass bottom: "ŚLAD PAMIĘTA KSZTAŁT"
	ci.draw_line(Vector2(-10.0, 18.0), Vector2(10.0, 18.0), Color("e2b060", 0.8), 0.8)


static func draw_station_32_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy Steel Technical Shaft Hatch to Space 33 (Szyb Techniczny / Maszynownia): 36x50 px
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	var portal_rect := Rect2(-18.0, -25.0, 36.0, 50.0)
	
	# Reinforced tunnel portal frame with rivets
	ci.draw_rect(portal_rect, Color("121920"))
	ci.draw_rect(portal_rect, Color("344855"), false, 1.5)
	for i in range(4):
		ci.draw_circle(Vector2(-15.0, -20.0 + i * 13.0), 1.2, Color("526e7d"))
		ci.draw_circle(Vector2(15.0, -20.0 + i * 13.0), 1.2, Color("526e7d"))
	
	# Vertical service ladder shaft opening
	var shaft_rect := Rect2(-12.0, -18.0, 24.0, 38.0)
	ci.draw_rect(shaft_rect, Color("05090c"))
	
	# Steel ladder rungs descending into dark shaft
	for r in range(5):
		var ry: float = -14.0 + r * 8.0
		ci.draw_line(Vector2(-8.0, ry), Vector2(8.0, ry), Color("2c3e4a"), 1.5)
	
	# Placard: "33 / SZYB TECHNICZNY — MASZYNOWNIA GŁÓWNA"
	ci.draw_rect(Rect2(-16.0, -23.0, 32.0, 3.5), Color("090e12"))
	ci.draw_line(Vector2(-14.0, -21.5), Vector2(14.0, -21.5), Color("e2b060", 0.85), 0.8)
	
	if p_is_activated:
		# Hatch unsealed, work light illuminates ladder descending down
		ci.draw_rect(portal_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45 + pulse * 0.25), false, 1.5)
		ci.draw_line(Vector2(-18.0, 25.0), Vector2(18.0, 25.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.9), 2.0)
		for r in range(5):
			var ry: float = -14.0 + r * 8.0
			ci.draw_line(Vector2(-8.0, ry), Vector2(8.0, ry), Color("5da398", 0.9), 1.5)
		ci.draw_circle(Vector2(0.0, -14.0), 3.0, Color("e2b060", 0.85))
	else:
		# Hatch locked with four heavy clamp bolts & red indicator
		ci.draw_circle(Vector2(-8.0, 0.0), 2.0, Color("e2b060"))
		ci.draw_circle(Vector2(8.0, 0.0), 2.0, Color("e2b060"))
		ci.draw_circle(Vector2(0.0, 10.0), 2.2, Color("c65d58"))


static func draw_vertical_ladder_array(ci: CanvasItem, p_is_activated: bool) -> void:
	# Vertical service ladder with safety cage in technical shaft: 28x64 px
	var ladder_rect := Rect2(-14.0, -32.0, 28.0, 64.0)
	
	# Background shaft wall recess
	ci.draw_rect(ladder_rect, Color("0b1014"))
	ci.draw_rect(ladder_rect, Color("1f2a32"), false, 1.0)
	
	# Twin vertical steel stringers
	ci.draw_line(Vector2(-8.0, -32.0), Vector2(-8.0, 32.0), Color("4a6270"), 2.0)
	ci.draw_line(Vector2(8.0, -32.0), Vector2(8.0, 32.0), Color("4a6270"), 2.0)
	
	# Rungs with grip ridges
	for r in range(9):
		var ry: float = -28.0 + float(r) * 7.0
		var rung_col := Color("5da398") if p_is_activated else Color("32434d")
		ci.draw_line(Vector2(-8.0, ry), Vector2(8.0, ry), rung_col, 1.5)
		# Step wear / highlight
		ci.draw_line(Vector2(-5.0, ry - 0.5), Vector2(5.0, ry - 0.5), Color("7e9aa8", 0.6), 0.8)
	
	# Curved safety cage hoops (outer basket)
	for h in range(4):
		var hy: float = -24.0 + float(h) * 16.0
		ci.draw_arc(Vector2(0.0, hy), 12.0, -PI * 0.85, PI * 0.85, 8, Color("27353f"), 1.2)
		ci.draw_line(Vector2(-12.0, hy), Vector2(-8.0, hy), Color("3a4e5c"), 1.0)
		ci.draw_line(Vector2(12.0, hy), Vector2(8.0, hy), Color("3a4e5c"), 1.0)
	
	# Safety stripes at platform boundary
	for s in range(3):
		var sx: float = -12.0 + float(s) * 8.0
		ci.draw_line(Vector2(sx, 28.0), Vector2(sx + 4.0, 32.0), Color("e2b060", 0.75), 1.2)


static func draw_depth_pressure_gauge(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy industrial depth and contradiction pressure manometer: diameter 30 px
	var center := Vector2(0.0, 0.0)
	var radius := 15.0
	
	# Solid brass & steel bezel
	ci.draw_circle(center, radius + 3.0, Color("1d272e"))
	ci.draw_circle(center, radius + 2.0, Color("d39a62" if p_is_activated else "4b3826"))
	ci.draw_circle(center, radius + 2.0, Color("182026"), false, 1.5)
	
	# Dial face (vintage industrial enamel)
	ci.draw_circle(center, radius, Color("0f1519"))
	
	# Arc tick marks
	for i in range(11):
		var ang: float = -PI * 0.8 + float(i) * (PI * 1.6 / 10.0)
		var inner := center + Vector2(cos(ang), sin(ang)) * (radius - 4.0)
		var outer := center + Vector2(cos(ang), sin(ang)) * (radius - 1.5)
		var tick_col := Color("c65d58") if i >= 8 else Color("8aa4b3")
		ci.draw_line(inner, outer, tick_col, 1.0 if i % 2 == 0 else 0.6)
	
	# Red critical pressure threshold zone
	ci.draw_arc(center, radius - 2.5, PI * 0.35, PI * 0.8, 8, Color("c65d58", 0.7), 2.0)
	
	# Text markings: "-40m" and "4.2 BAR"
	ci.draw_line(Vector2(-7.0, -5.0), Vector2(7.0, -5.0), Color("5da398", 0.7), 0.8)
	ci.draw_line(Vector2(-5.0, 6.0), Vector2(5.0, 6.0), Color("e2b060", 0.8), 0.8)
	
	# Needle with pivot hub
	var pulse := sin(p_pulse * 4.0) * 0.05
	var needle_ang: float = (PI * 0.55 + pulse) if p_is_activated else (-PI * 0.3)
	var needle_tip := center + Vector2(cos(needle_ang), sin(needle_ang)) * (radius - 3.0)
	var needle_tail := center - Vector2(cos(needle_ang), sin(needle_ang)) * 3.5
	var needle_col := Color("c65d58") if p_is_activated else Color("e2b060")
	ci.draw_line(needle_tail, needle_tip, needle_col, 1.5)
	ci.draw_circle(center, 2.8, Color("d39a62"))
	ci.draw_circle(center, 1.2, Color("141b20"))


static func draw_memory_bus_cable_trunk(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# High-bandwidth memory bus cable trunk with signal indicators: 32x56 px
	var trunk_rect := Rect2(-16.0, -28.0, 32.0, 56.0)
	
	# Heavy galvanised cable ladder rack
	ci.draw_rect(trunk_rect, Color("0d1318"))
	ci.draw_rect(trunk_rect, Color("2a3b45"), false, 1.0)
	
	# Cable bundle lines (heavy conduits)
	var cable_colors := [
		Color("1b252c"),
		Color("223038"),
		Color("182228"),
		Color("263742")
	]
	for c in range(4):
		var cx: float = -11.0 + float(c) * 7.0
		ci.draw_line(Vector2(cx, -28.0), Vector2(cx, 28.0), cable_colors[c], 3.0)
	
	# Steel clamp brackets with fasteners
	for b in range(4):
		var by: float = -20.0 + float(b) * 13.0
		ci.draw_rect(Rect2(-15.0, by - 2.0, 30.0, 4.0), Color("3d5462"))
		ci.draw_circle(Vector2(-13.0, by), 1.0, Color("8aa4b3"))
		ci.draw_circle(Vector2(13.0, by), 1.0, Color("8aa4b3"))
	
	# Pulsing memory transmission packet LEDs along conduits
	var pulse := sin(p_pulse * 3.5) * 0.5 + 0.5
	if p_is_activated or p_in_range:
		for p in range(5):
			var py: float = -22.0 + float(p) * 11.0 + sin(p_pulse * 3.0 + p) * 2.0
			var pcol := Color("5da398") if p % 2 == 0 else Color("e2b060")
			ci.draw_circle(Vector2(-4.0 + (p % 3) * 4.0, py), 1.8, Color(pcol.r, pcol.g, pcol.b, 0.6 + pulse * 0.4))
	
	# Grounding copper braid on side
	ci.draw_line(Vector2(-14.5, -28.0), Vector2(-14.5, 28.0), Color("b87333", 0.8), 1.2)


static func draw_shaft_work_light_beacon(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Industrial caged work light fixture illuminating deep shaft: 24x44 px
	var fixture_rect := Rect2(-12.0, -22.0, 24.0, 44.0)
	
	# Top conduit connection box
	ci.draw_rect(Rect2(-8.0, -22.0, 16.0, 8.0), Color("26353e"))
	ci.draw_rect(Rect2(-8.0, -22.0, 16.0, 8.0), Color("455e6e"), false, 1.0)
	
	# Glass dome housing
	var glass_rect := Rect2(-7.0, -14.0, 14.0, 22.0)
	var glow_pulse := sin(p_pulse * 2.2) * 0.3 + 0.7
	var glass_bg := Color(0.88, 0.69, 0.38, 0.4 * glow_pulse) if p_is_activated else Color("141d24")
	ci.draw_rect(glass_rect, glass_bg)
	
	# Protective wire cage mesh
	ci.draw_rect(glass_rect, Color("4a6270"), false, 1.2)
	ci.draw_line(Vector2(-7.0, -6.0), Vector2(7.0, -6.0), Color("4a6270"), 1.0)
	ci.draw_line(Vector2(-7.0, 2.0), Vector2(7.0, 2.0), Color("4a6270"), 1.0)
	ci.draw_line(Vector2(0.0, -14.0), Vector2(0.0, 8.0), Color("4a6270"), 1.0)
	
	# Heavy cast reflector bowl & wire ring at bottom
	ci.draw_rect(Rect2(-9.0, 8.0, 18.0, 4.0), Color("222f37"))
	ci.draw_arc(Vector2(0.0, 12.0), 6.0, 0.0, PI, 6, Color("344855"), 1.5)
	
	# Light cone beam projecting down into shaft
	if p_is_activated or p_in_range:
		var beam_col := Color("e2b060", 0.08 * glow_pulse)
		var pts: PackedVector2Array = [
			Vector2(-6.0, 12.0),
			Vector2(6.0, 12.0),
			Vector2(14.0, 26.0),
			Vector2(-14.0, 26.0)
		]
		ci.draw_colored_polygon(pts, beam_col)
		# Filament hot core
		ci.draw_circle(Vector2(0.0, -4.0), 2.5, Color("fff2cf", 0.95 * glow_pulse))


static func draw_station_33_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Massive Lower Decompression Hatch to Space 34 (Maszynownia Główna / Rdzeń Wymiany): 40x52 px
	var pulse := sin(p_pulse * 2.4) * 0.5 + 0.5
	var portal_rect := Rect2(-20.0, -26.0, 40.0, 52.0)
	
	# Massive cast steel pressure bulkhead
	ci.draw_rect(portal_rect, Color("10161d"))
	ci.draw_rect(portal_rect, Color("2d3e4a"), false, 1.8)
	
	# Perimeter clamping studs & hydraulic rams
	for s in range(5):
		var sy: float = -21.0 + float(s) * 10.5
		ci.draw_circle(Vector2(-17.0, sy), 1.5, Color("4f6c7f"))
		ci.draw_circle(Vector2(17.0, sy), 1.5, Color("4f6c7f"))
	
	# Inner airlock hatch door
	var hatch_rect := Rect2(-13.0, -18.0, 26.0, 36.0)
	ci.draw_rect(hatch_rect, Color("152028"))
	ci.draw_rect(hatch_rect, Color("3b505f"), false, 1.2)
	
	# Central circular pressure wheel / locking dogs
	ci.draw_circle(Vector2(0.0, 0.0), 6.5, Color("24333d"))
	ci.draw_circle(Vector2(0.0, 0.0), 6.5, Color("526f82"), false, 1.2)
	ci.draw_line(Vector2(-5.0, 0.0), Vector2(5.0, 0.0), Color("d39a62"), 1.5)
	ci.draw_line(Vector2(0.0, -5.0), Vector2(0.0, 5.0), Color("d39a62"), 1.5)
	
	# Placard: "34 / MASZYNOWNIA GŁÓWNA — RDZEŃ WYMIANY"
	ci.draw_rect(Rect2(-18.0, -24.0, 36.0, 4.0), Color("090e12"))
	ci.draw_line(Vector2(-16.0, -22.0), Vector2(16.0, -22.0), Color("e2b060", 0.9), 0.9)
	
	if p_is_activated:
		# Unsealed: massive hydraulic pressure drop, cyan glow emanating from Core Engine Room
		ci.draw_rect(portal_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.5 + pulse * 0.3), false, 2.0)
		ci.draw_rect(hatch_rect, Color(0.1, 0.25, 0.28, 0.8))
		ci.draw_line(Vector2(-20.0, 26.0), Vector2(20.0, 26.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.95), 2.2)
		ci.draw_circle(Vector2(0.0, 0.0), 4.0, Color("5da398", 0.9))
		# Status indicator green/cyan
		ci.draw_circle(Vector2(0.0, -14.0), 2.5, Color("5da398"))
	else:
		# Locked: red sealed indicator & hydraulic dogs engaged
		ci.draw_circle(Vector2(0.0, -14.0), 2.5, Color("c65d58"))
		ci.draw_line(Vector2(-10.0, -9.0), Vector2(-4.0, -9.0), Color("c65d58", 0.8), 1.2)
		ci.draw_line(Vector2(4.0, -9.0), Vector2(10.0, -9.0), Color("c65d58", 0.8), 1.2)


static func draw_main_exchange_core_reactor(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Monumental Main Exchange Core Reactor in Space 34: 48x58 px
	var core_pulse := sin(p_pulse * 3.2) * 0.5 + 0.5
	var reactor_rect := Rect2(-24.0, -29.0, 48.0, 58.0)
	
	# Massive steel outer frame with mounting columns
	ci.draw_rect(reactor_rect, Color("0e151c"))
	ci.draw_rect(reactor_rect, Color("2d4150"), false, 1.8)
	
	# Upper and lower hydraulic cylinder struts
	ci.draw_rect(Rect2(-20.0, -27.0, 8.0, 10.0), Color("1a2733"))
	ci.draw_rect(Rect2(12.0, -27.0, 8.0, 10.0), Color("1a2733"))
	ci.draw_rect(Rect2(-20.0, 17.0, 8.0, 10.0), Color("1a2733"))
	ci.draw_rect(Rect2(12.0, 17.0, 8.0, 10.0), Color("1a2733"))
	
	# Central cylindrical rotor vessel
	var rotor_rect := Rect2(-14.0, -16.0, 28.0, 32.0)
	ci.draw_rect(rotor_rect, Color("141e26"))
	ci.draw_rect(rotor_rect, Color("3e596d"), false, 1.2)
	
	# Rotating bronze armature slip-rings
	for r in range(4):
		var ry: float = -11.0 + float(r) * 7.0
		ci.draw_line(Vector2(-13.0, ry), Vector2(13.0, ry), Color("d39a62", 0.75), 1.5)
	
	# Central core reaction chamber with pulsing contradiction glow
	var chamber_col := Color("5da398", 0.6 + core_pulse * 0.4) if p_is_activated else Color("32504c", 0.5)
	ci.draw_circle(Vector2(0.0, 0.0), 7.5, chamber_col)
	ci.draw_circle(Vector2(0.0, 0.0), 9.0, Color("5da398", 0.4 * core_pulse), false, 1.2)
	
	# Internal spinning magnetic discs
	var angle: float = p_pulse * 2.0
	var dx: float = cos(angle) * 5.0
	var dy: float = sin(angle) * 5.0
	ci.draw_line(Vector2(-dx, -dy), Vector2(dx, dy), Color("fff2cf", 0.9), 1.5)
	
	# Top indicator banner "RDZEŃ WYMIANY UCP"
	ci.draw_rect(Rect2(-18.0, -26.0, 36.0, 4.0), Color("090d12"))
	ci.draw_line(Vector2(-16.0, -24.0), Vector2(16.0, -24.0), Color("e2b060"), 1.0)
	
	# Warning beacon on top
	ci.draw_circle(Vector2(0.0, -28.0), 2.2, Color("c65d58" if p_is_activated else "e2b060"))


static func draw_biography_allocation_desk(ci: CanvasItem, p_is_activated: bool) -> void:
	# Mechanical Biography Allocation Console: 38x26 px
	var desk_rect := Rect2(-19.0, -13.0, 38.0, 26.0)
	
	# Console housing with cast iron base
	ci.draw_rect(desk_rect, Color("111820"))
	ci.draw_rect(desk_rect, Color("344b5c"), false, 1.4)
	
	# Slanted control panel
	var panel_rect := Rect2(-16.0, -10.0, 32.0, 20.0)
	ci.draw_rect(panel_rect, Color("18222b"))
	ci.draw_rect(panel_rect, Color("2a3c4a"), false, 1.0)
	
	# 3 Brass slider channels (KOWALSKA, SIKORA, WOLSKI)
	var slider_x: Array[float] = [-10.0, 0.0, 10.0]
	for i in range(3):
		var sx: float = slider_x[i]
		# Vertical slot channel
		ci.draw_line(Vector2(sx, -7.0), Vector2(sx, 7.0), Color("0b0f14"), 2.0)
		ci.draw_line(Vector2(sx, -7.0), Vector2(sx, 7.0), Color("4a6273"), 1.0)
		
		# Slider knob position: zeroed down at y=5.0
		var knob_y: float = 4.0 if not p_is_activated else -2.0
		ci.draw_rect(Rect2(sx - 3.0, knob_y - 2.0, 6.0, 4.0), Color("d39a62"))
		ci.draw_rect(Rect2(sx - 3.0, knob_y - 2.0, 6.0, 4.0), Color("fff2cf"), false, 0.8)
		
		# Channel status LED
		var led_col := Color("5da398") if p_is_activated else Color("c65d58")
		ci.draw_circle(Vector2(sx, -8.5), 1.2, led_col)
	
	# Name label markings on top
	ci.draw_line(Vector2(-14.0, 8.5), Vector2(14.0, 8.5), Color("a8b2ac", 0.6), 0.8)


static func draw_thermal_overload_indicator(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Column-mounted thermal and contradiction pressure manometer: 26x34 px
	var column_rect := Rect2(-4.0, 4.0, 8.0, 13.0)
	ci.draw_rect(column_rect, Color("1a252f"))
	ci.draw_rect(column_rect, Color("374d5e"), false, 1.0)
	
	# Circular dial gauge housing (center at y=-3.0, radius 10.0)
	var center := Vector2(0.0, -3.0)
	ci.draw_circle(center, 10.5, Color("10161d"))
	ci.draw_circle(center, 10.5, Color("4b667a"), false, 1.4)
	
	# White-aged dial face
	ci.draw_circle(center, 8.5, Color("e5ece9"))
	
	# Red critical zone (right side from 0 to PI/2)
	for a in range(8):
		var ang: float = -0.3 + float(a) * 0.22
		var p1 := center + Vector2(cos(ang), sin(ang)) * 5.0
		var p2 := center + Vector2(cos(ang), sin(ang)) * 7.5
		ci.draw_line(p1, p2, Color("c65d58"), 1.2)
	
	# Normal zone tick marks
	for a in range(6):
		var ang: float = PI * 0.75 + float(a) * 0.25
		var p1 := center + Vector2(cos(ang), sin(ang)) * 6.0
		var p2 := center + Vector2(cos(ang), sin(ang)) * 7.5
		ci.draw_line(p1, p2, Color("202830"), 1.0)
	
	# Gauge needle pointing to 8.9 bar (critical red zone)
	var needle_ang: float = 0.55 if not p_is_activated else 0.85
	var needle_end := center + Vector2(cos(needle_ang), sin(needle_ang)) * 7.2
	ci.draw_line(center, needle_end, Color("c65d58"), 1.5)
	ci.draw_circle(center, 1.8, Color("151c22"))
	
	# Overload alarm beacon on top
	var blink := sin(p_pulse * 6.0) * 0.5 + 0.5
	ci.draw_circle(Vector2(0.0, -15.0), 2.5, Color("c65d58", 0.7 + blink * 0.3 if p_is_activated else 0.4))


static func draw_jakub_core_diagnostic_port(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Jakub's portable diagnostic oscilloscope clamped to data bus: 30x24 px
	var osc_rect := Rect2(-15.0, -12.0, 30.0, 24.0)
	
	# Ruggedized portable metal case
	ci.draw_rect(osc_rect, Color("162029"))
	ci.draw_rect(osc_rect, Color("3f596d"), false, 1.4)
	
	# Green phosphor CRT screen (16x14 px)
	var crt_rect := Rect2(-12.0, -9.0, 16.0, 14.0)
	ci.draw_rect(crt_rect, Color("05120c"))
	ci.draw_rect(crt_rect, Color("1e4a30"), false, 1.0)
	
	# Phosphor grid lines
	ci.draw_line(Vector2(-12.0, -2.0), Vector2(4.0, -2.0), Color("0d2d1d", 0.7), 0.8)
	ci.draw_line(Vector2(-4.0, -9.0), Vector2(-4.0, 5.0), Color("0d2d1d", 0.7), 0.8)
	
	# Contradiction waveform trace on CRT
	var t_off: float = p_pulse * 3.0
	for px in range(14):
		var x1: float = -11.0 + float(px)
		var x2: float = x1 + 1.0
		var y1: float = -2.0 + sin(float(px) * 0.8 + t_off) * (4.0 if p_is_activated else 1.8)
		var y2: float = -2.0 + sin(float(px + 1) * 0.8 + t_off) * (4.0 if p_is_activated else 1.8)
		ci.draw_line(Vector2(x1, y1), Vector2(x2, y2), Color("5da398" if p_is_activated else "3b735c"), 1.2)
	
	# Right control knobs and BNC probe jacks
	ci.draw_circle(Vector2(8.0, -6.0), 2.0, Color("d39a62"))
	ci.draw_circle(Vector2(8.0, 0.0), 2.0, Color("d39a62"))
	ci.draw_circle(Vector2(8.0, 6.0), 1.5, Color("a8b2ac"))
	
	# Probe cable snaking to data bus
	ci.draw_line(Vector2(8.0, 6.0), Vector2(16.0, 10.0), Color("c65d58"), 1.2)
	ci.draw_line(Vector2(16.0, 10.0), Vector2(18.0, 15.0), Color("c65d58"), 1.2)


static func draw_station_34_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy Pneumatic Filtration Gate to Space 35 (Sektor Filtracji / Baseny Sedacyjne): 42x54 px
	var pulse := sin(p_pulse * 2.6) * 0.5 + 0.5
	var portal_rect := Rect2(-21.0, -27.0, 42.0, 54.0)
	
	# Cast iron blast frame
	ci.draw_rect(portal_rect, Color("0f151c"))
	ci.draw_rect(portal_rect, Color("2d404e"), false, 1.8)
	
	# Overhead filtration vapor duct
	ci.draw_rect(Rect2(-18.0, -26.0, 36.0, 5.0), Color("17222c"))
	ci.draw_line(Vector2(-16.0, -23.5), Vector2(16.0, -23.5), Color("e2b060", 0.9), 1.0)
	
	# Dual-segmented blast door panels
	var door_rect := Rect2(-14.0, -19.0, 28.0, 40.0)
	ci.draw_rect(door_rect, Color("141e26"))
	ci.draw_rect(door_rect, Color("3a5161"), false, 1.2)
	
	# Central vertical seal seam
	ci.draw_line(Vector2(0.0, -19.0), Vector2(0.0, 21.0), Color("090d12"), 2.0)
	
	# Diagonal yellow/black hazmat warning stripes on lower threshold
	for h in range(5):
		var hx: float = -12.0 + float(h) * 6.0
		ci.draw_line(Vector2(hx, 15.0), Vector2(hx + 3.0, 20.0), Color("d39a62", 0.7), 1.2)
	
	if p_is_activated:
		# Gate unsealed: pressurized vapor glow and open interlocks
		ci.draw_rect(portal_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.55 + pulse * 0.35), false, 2.2)
		ci.draw_rect(door_rect, Color(0.12, 0.28, 0.32, 0.85))
		ci.draw_line(Vector2(-21.0, 27.0), Vector2(21.0, 27.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.95), 2.2)
		ci.draw_circle(Vector2(0.0, -12.0), 3.0, Color("5da398"))
		ci.draw_circle(Vector2(0.0, 0.0), 3.0, Color("5da398"))
	else:
		# Sealed: red locking status indicators
		ci.draw_circle(Vector2(0.0, -12.0), 2.5, Color("c65d58"))
		ci.draw_circle(Vector2(0.0, 0.0), 2.5, Color("c65d58"))
		ci.draw_line(Vector2(-10.0, -6.0), Vector2(-2.0, -6.0), Color("c65d58", 0.8), 1.2)
		ci.draw_line(Vector2(2.0, -6.0), Vector2(10.0, -6.0), Color("c65d58", 0.8), 1.2)


static func draw_sedation_basin_pool(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Concrete sedation pool: 56x36 px with phosphorescent murky liquid & floating memory ghosts
	var basin_rect := Rect2(-28.0, -18.0, 56.0, 36.0)
	var pool_inner := Rect2(-25.0, -14.0, 50.0, 30.0)
	
	# Outer concrete rim & sediment base
	ci.draw_rect(basin_rect, Color("0d171c"))
	ci.draw_rect(basin_rect, Color("172a30"), false, 1.8)
	
	# Liquid fill with eerie glowing murky cyan/teal
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 2.8)
	var liquid_col := Color("133238") if not p_is_activated else Color("1a454d")
	ci.draw_rect(pool_inner, liquid_col)
	
	# Wavy liquid meniscus surface line
	var surface_y: float = -12.0
	for i in range(7):
		var x1: float = -24.0 + float(i) * 7.0
		var x2: float = x1 + 7.0
		var y_off: float = sin(p_pulse * 3.0 + float(i) * 0.9) * 1.5
		ci.draw_line(Vector2(x1, surface_y + y_off), Vector2(x2, surface_y - y_off), Color("5da398", 0.7 + pulse * 0.3), 1.2)
	
	# Submerged floating ghosts of erased items (Tram 4 plate, child shoe, dossier outline)
	# 1. Tram line 4 destination plate
	ci.draw_rect(Rect2(-18.0, -4.0, 10.0, 6.0), Color("2d4f59", 0.65))
	ci.draw_line(Vector2(-14.0, -3.0), Vector2(-14.0, 0.0), Color("d39a62", 0.8), 1.0)
	ci.draw_line(Vector2(-16.0, -1.0), Vector2(-12.0, -1.0), Color("d39a62", 0.8), 1.0)
	
	# 2. Child's shoe / glove phantom
	ci.draw_circle(Vector2(2.0, 3.0), 3.0, Color("3e5866", 0.6))
	ci.draw_rect(Rect2(0.0, 4.0, 5.0, 3.0), Color("3e5866", 0.6))
	
	# 3. Dossier folder with red ribbon string
	ci.draw_rect(Rect2(12.0, -2.0, 9.0, 11.0), Color("253840", 0.75))
	ci.draw_line(Vector2(12.0, 3.0), Vector2(21.0, 3.0), Color("c65d58", 0.85), 1.0)
	
	# Rising chemical gas bubbles
	for b in range(4):
		var bx: float = -20.0 + float(b) * 12.0 + sin(p_pulse * 2.0 + float(b)) * 2.0
		var by: float = 10.0 - fmod(p_pulse * 14.0 + float(b) * 8.0, 22.0)
		ci.draw_circle(Vector2(bx, by), 1.2, Color("5da398", 0.75))
	
	if p_is_activated:
		ci.draw_rect(basin_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35 + pulse * 0.25), false, 1.5)


static func draw_sludge_drain_valve_wheel(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy cast-iron sludge valve assembly: 28x40 px
	var pipe_rect := Rect2(-7.0, -20.0, 14.0, 40.0)
	var flange_top := Rect2(-11.0, -19.0, 22.0, 5.0)
	var flange_bot := Rect2(-11.0, 14.0, 22.0, 5.0)
	
	# Iron discharge pipe
	ci.draw_rect(pipe_rect, Color("141c22"))
	ci.draw_rect(flange_top, Color("22303a"))
	ci.draw_rect(flange_bot, Color("22303a"))
	ci.draw_rect(pipe_rect, Color("2d3f4c"), false, 1.0)
	
	# Central valve bonnet and gland packing
	var bonnet_rect := Rect2(-8.0, -8.0, 16.0, 16.0)
	ci.draw_rect(bonnet_rect, Color("1a2630"))
	ci.draw_rect(bonnet_rect, Color("3e5466"), false, 1.2)
	
	# Heavy spoked handwheel (radius 10 px)
	var wheel_center := Vector2(0.0, -1.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 3.0)
	var wheel_col := Color("d39a62") if p_is_activated else Color("8a5e3d")
	
	ci.draw_circle(wheel_center, 9.5, Color("0f151a"))
	ci.draw_arc(wheel_center, 9.5, 0.0, TAU, 16, wheel_col, 2.0)
	
	# 4 wheel spokes
	var angle_offset: float = p_pulse * (2.5 if p_is_activated else 0.0)
	for s in range(4):
		var a: float = angle_offset + float(s) * (PI * 0.5)
		var spoke_vec := Vector2(cos(a), sin(a)) * 9.0
		ci.draw_line(wheel_center, wheel_center + spoke_vec, wheel_col, 1.4)
	
	ci.draw_circle(wheel_center, 3.0, Color("e2b060"))
	
	# Sludge drip marks under lower flange
	ci.draw_line(Vector2(-3.0, 19.0), Vector2(-3.0, 23.0), Color("133238"), 1.2)
	ci.draw_line(Vector2(3.0, 19.0), Vector2(3.0, 22.0), Color("133238"), 1.2)
	
	if p_is_activated:
		ci.draw_circle(wheel_center, 12.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35 + pulse * 0.25), false, 1.2)


static func draw_chemical_sedation_sampler(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Chemical testing station with illuminated glass tubes: 24x32 px
	var stand_rect := Rect2(-12.0, -16.0, 24.0, 32.0)
	ci.draw_rect(stand_rect, Color("101820"))
	ci.draw_rect(stand_rect, Color("1f2d38"), false, 1.0)
	
	# Backlight panel behind tubes
	var back_rect := Rect2(-9.0, -13.0, 18.0, 22.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 3.5)
	ci.draw_rect(back_rect, Color("0a1a20"))
	
	# Left glass cylinder with swirling reagent
	var tube_l := Rect2(-8.0, -12.0, 6.0, 19.0)
	ci.draw_rect(tube_l, Color("081014"))
	ci.draw_rect(Rect2(-7.0, -6.0, 4.0, 12.0), Color("2d6e6a", 0.85))
	ci.draw_rect(tube_l, Color("5da398"), false, 1.0)
	
	# Right glass cylinder with bubbling sedative liquid
	var tube_r := Rect2(2.0, -12.0, 6.0, 19.0)
	ci.draw_rect(tube_r, Color("081014"))
	ci.draw_rect(Rect2(3.0, -9.0, 4.0, 15.0), Color("3ea89d", 0.9))
	ci.draw_rect(tube_r, Color("5da398"), false, 1.0)
	
	# Graduation measurement tick marks on cylinders
	for g in range(4):
		var gy: float = -10.0 + float(g) * 4.0
		ci.draw_line(Vector2(-8.0, gy), Vector2(-6.0, gy), Color("e2b060", 0.7), 0.8)
		ci.draw_line(Vector2(6.0, gy), Vector2(8.0, gy), Color("e2b060", 0.7), 0.8)
	
	# Top rubber titration bulbs and connecting capillary tube
	ci.draw_line(Vector2(-5.0, -14.0), Vector2(5.0, -14.0), Color("d39a62"), 1.2)
	ci.draw_circle(Vector2(-5.0, -14.0), 2.0, Color("c65d58"))
	ci.draw_circle(Vector2(5.0, -14.0), 2.0, Color("c65d58"))
	
	if p_is_activated:
		ci.draw_circle(Vector2(0.0, -2.0), 14.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.3 + pulse * 0.3), false, 1.0)


static func draw_jakub_sedation_monitor(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Jakub's portable sedation spectrometer / monitor: 26x32 px
	var chassis_rect := Rect2(-13.0, -16.0, 26.0, 24.0)
	ci.draw_rect(chassis_rect, Color("141e26"))
	ci.draw_rect(chassis_rect, Color("3b4f5e"), false, 1.2)
	
	# CRT Spectrometer Display (18x13 px)
	var crt_rect := Rect2(-9.0, -13.0, 18.0, 13.0)
	ci.draw_rect(crt_rect, Color("091217"))
	ci.draw_rect(crt_rect, Color("5da398", 0.6), false, 1.0)
	
	# Saturation curve waveform (showing critical spike 312%)
	var pts: Array[Vector2] = []
	for p in range(16):
		var px: float = -8.0 + float(p) * 1.05
		var py: float = -4.0 - sin(float(p) * 0.45 + p_pulse * 4.0) * 3.5 - (2.5 if p > 8 else 0.0)
		pts.append(Vector2(px, clampf(py, -12.0, -2.0)))
	if pts.size() > 1:
		for j in range(pts.size() - 1):
			ci.draw_line(pts[j], pts[j + 1], Color("e2b060") if p_is_activated else Color("5da398"), 1.2)
	
	# Critical threshold line (red dashed indicator across screen)
	ci.draw_line(Vector2(-8.0, -7.0), Vector2(8.0, -7.0), Color("c65d58", 0.8), 0.8)
	
	# Control knobs and indicator LEDs below CRT
	ci.draw_circle(Vector2(-7.0, 4.0), 2.2, Color("344959"))
	ci.draw_circle(Vector2(-1.0, 4.0), 2.2, Color("344959"))
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 6.0)
	ci.draw_circle(Vector2(6.0, 4.0), 2.0, Color("c65d58", 0.9 if p_is_activated else 0.4 + pulse * 0.4))
	
	# Tripod legs
	ci.draw_line(Vector2(-10.0, 8.0), Vector2(-13.0, 16.0), Color("22303c"), 1.4)
	ci.draw_line(Vector2(0.0, 8.0), Vector2(0.0, 16.0), Color("22303c"), 1.4)
	ci.draw_line(Vector2(10.0, 8.0), Vector2(13.0, 16.0), Color("22303c"), 1.4)
	
	# Probe cable running into basin
	ci.draw_line(Vector2(-13.0, 2.0), Vector2(-22.0, 8.0), Color("c65d58"), 1.2)


static func draw_station_35_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy drain sluice gate leading to Space 36 (Cold Drain): 42x54 px
	var portal_rect := Rect2(-21.0, -27.0, 42.0, 54.0)
	var door_rect := Rect2(-17.0, -23.0, 34.0, 46.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 2.6)
	
	# Concrete sluice portal casing with drain gutter
	ci.draw_rect(portal_rect, Color("0d171c"))
	ci.draw_rect(portal_rect, Color("20333d"), false, 2.0)
	
	# Sluice guide channels with rack-and-pinion teeth
	for g in range(8):
		var gy: float = -20.0 + float(g) * 5.0
		ci.draw_line(Vector2(-20.0, gy), Vector2(-17.0, gy), Color("3b4f5e"), 1.0)
		ci.draw_line(Vector2(17.0, gy), Vector2(20.0, gy), Color("3b4f5e"), 1.0)
	
	# Cast steel slide gate
	var slide_offset: float = -18.0 if p_is_activated else 0.0
	var slide_rect := Rect2(-16.0, -22.0 + slide_offset, 32.0, 44.0)
	ci.draw_rect(slide_rect, Color("182630"))
	ci.draw_rect(slide_rect, Color("344d5c"), false, 1.2)
	
	# Hazard warning stripes on bottom weir threshold
	for w in range(5):
		var wx: float = -12.0 + float(w) * 6.0
		ci.draw_line(Vector2(wx, 16.0), Vector2(wx + 3.0, 21.0), Color("d39a62", 0.75), 1.2)
	
	if p_is_activated:
		# Gate opened: dark cold drain tunnel aperture with swirling cyan mist
		ci.draw_rect(portal_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.55 + pulse * 0.35), false, 2.2)
		ci.draw_rect(Rect2(-16.0, 2.0, 32.0, 20.0), Color("061014"))
		ci.draw_line(Vector2(-21.0, 27.0), Vector2(21.0, 27.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.95), 2.2)
		ci.draw_circle(Vector2(0.0, -10.0), 3.0, Color("5da398"))
		ci.draw_circle(Vector2(0.0, 2.0), 3.0, Color("5da398"))
	else:
		# Gate sealed: locking rylges and red status indicators
		ci.draw_circle(Vector2(0.0, -10.0), 2.5, Color("c65d58"))
		ci.draw_circle(Vector2(0.0, 2.0), 2.5, Color("c65d58"))
		ci.draw_line(Vector2(-10.0, -4.0), Vector2(-2.0, -4.0), Color("c65d58", 0.8), 1.2)
		ci.draw_line(Vector2(2.0, -4.0), Vector2(10.0, -4.0), Color("c65d58", 0.8), 1.2)


static func draw_storm_drain_weir(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy cast-iron storm drain weir: 40x48 px with rusty vertical bars & trapped debris
	var weir_frame := Rect2(-20.0, -24.0, 40.0, 48.0)
	var cascade_inner := Rect2(-17.0, -18.0, 34.0, 40.0)
	
	# Massive concrete bulkhead frame
	ci.draw_rect(weir_frame, Color("0d1519"))
	ci.draw_rect(weir_frame, Color("1f2f38"), false, 1.8)
	
	# Dark turbulent wastewater cascade in weir channel
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 3.2)
	ci.draw_rect(cascade_inner, Color("081014"))
	
	# Wavy water flow lines
	for l in range(4):
		var ly: float = -14.0 + float(l) * 10.0 + sin(p_pulse * 4.0 + float(l)) * 2.0
		ci.draw_line(Vector2(-16.0, ly), Vector2(16.0, ly), Color("173840", 0.8), 1.2)
	
	# Heavy vertical iron weir bars
	for b in range(7):
		var bx: float = -15.0 + float(b) * 5.0
		ci.draw_line(Vector2(bx, -22.0), Vector2(bx, 22.0), Color("3f3328"), 1.8)
		ci.draw_line(Vector2(bx, -22.0), Vector2(bx, 22.0), Color("7a5638"), 0.8)
	
	# Horizontal reinforcing ribs
	ci.draw_line(Vector2(-18.0, -10.0), Vector2(18.0, -10.0), Color("2d241d"), 2.0)
	ci.draw_line(Vector2(-18.0, 8.0), Vector2(18.0, 8.0), Color("2d241d"), 2.0)
	
	# Trapped memory artifacts on weir grating:
	# 1. Tram handrail bracket (brass/amber)
	ci.draw_line(Vector2(-12.0, -4.0), Vector2(-4.0, -1.0), Color("d39a62"), 1.6)
	ci.draw_circle(Vector2(-4.0, -1.0), 2.0, Color("e2b060"))
	
	# 2. Ticket stub from 3 Nov 1988 (off-white/cyan with red mark)
	ci.draw_rect(Rect2(2.0, 2.0, 8.0, 5.0), Color("cbd9d5", 0.85))
	ci.draw_line(Vector2(4.0, 3.0), Vector2(8.0, 3.0), Color("c65d58"), 1.0)
	
	# 3. Shredded graph scrap
	ci.draw_line(Vector2(-8.0, 10.0), Vector2(-2.0, 14.0), Color("5da398", 0.75), 1.2)
	
	if p_is_activated:
		ci.draw_rect(weir_frame, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35 + pulse * 0.25), false, 1.5)


static func draw_sedative_sludge_current(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Rapid wastewater current with glowing sedative sludge streak: 56x28 px
	var stream_rect := Rect2(-28.0, -14.0, 56.0, 28.0)
	
	# Sewer channel stone bed
	ci.draw_rect(stream_rect, Color("080e12"))
	ci.draw_rect(stream_rect, Color("152229"), false, 1.4)
	
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 2.5)
	
	# Phosphorescent cyan sedative sludge ribbon swirling in center
	var pts: Array[Vector2] = []
	for p in range(15):
		var px: float = -26.0 + float(p) * 3.7
		var py: float = sin(float(p) * 0.7 + p_pulse * 3.8) * 5.0
		pts.append(Vector2(px, py))
	
	if pts.size() > 1:
		for j in range(pts.size() - 1):
			var col := Color("5da398", 0.65 + pulse * 0.30) if p_is_activated else Color("2c5f59", 0.50)
			ci.draw_line(pts[j], pts[j + 1], col, 3.2)
			ci.draw_line(pts[j] + Vector2(0.0, 2.0), pts[j + 1] + Vector2(0.0, 2.0), Color("17403c", 0.40), 1.8)
	
	# Effervescent chemical gas bubbles bursting on surface
	for b in range(5):
		var bx: float = -22.0 + float(b) * 10.0 + sin(p_pulse * 3.0 + float(b)) * 3.0
		var by: float = sin(float(b) * 1.5 + p_pulse * 4.0) * 8.0
		ci.draw_circle(Vector2(bx, by), 1.4, Color("75c7c3", 0.8))
	
	# Flow arrow vector ripples
	for a in range(3):
		var ax: float = -14.0 + float(a) * 16.0
		ci.draw_line(Vector2(ax, -9.0), Vector2(ax + 5.0, -9.0), Color("d39a62", 0.5), 1.0)
		ci.draw_line(Vector2(ax + 3.0, -11.0), Vector2(ax + 5.0, -9.0), Color("d39a62", 0.5), 1.0)


static func draw_acid_resistant_catwalk_ladder(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Acid-resistant galvanized steel catwalk platform & ladder: 26x44 px
	var platform_rect := Rect2(-13.0, 4.0, 26.0, 16.0)
	
	# Galvanized steel tread grating
	ci.draw_rect(platform_rect, Color("162026"))
	ci.draw_rect(platform_rect, Color("4a6270"), false, 1.2)
	
	# Grid cross-hatching on tread
	for gx in range(5):
		var x: float = -10.0 + float(gx) * 5.0
		ci.draw_line(Vector2(x, 5.0), Vector2(x, 19.0), Color("2e434f"), 0.8)
	for gy in range(3):
		var y: float = 8.0 + float(gy) * 4.0
		ci.draw_line(Vector2(-12.0, y), Vector2(12.0, y), Color("2e434f"), 0.8)
	
	# Safety handrail along catwalk
	ci.draw_line(Vector2(-13.0, -6.0), Vector2(13.0, -6.0), Color("e2b060"), 1.6)
	ci.draw_line(Vector2(-11.0, -6.0), Vector2(-11.0, 4.0), Color("d39a62"), 1.4)
	ci.draw_line(Vector2(11.0, -6.0), Vector2(11.0, 4.0), Color("d39a62"), 1.4)
	
	# Wall rungs climbing upwards to sewer ceiling
	for r in range(4):
		var ry: float = -20.0 + float(r) * 5.0
		ci.draw_line(Vector2(-8.0, ry), Vector2(8.0, ry), Color("a8b2ac"), 1.8)
		ci.draw_circle(Vector2(-8.0, ry), 1.5, Color("344959"))
		ci.draw_circle(Vector2(8.0, ry), 1.5, Color("344959"))
	
	if p_is_activated:
		var pulse: float = 0.5 + 0.5 * sin(p_pulse * 3.0)
		ci.draw_rect(platform_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35 + pulse * 0.25), false, 1.2)


static func draw_contamination_sampling_tap(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Aquifer groundwater contamination sampling station: 24x34 px
	var back_panel := Rect2(-12.0, -17.0, 24.0, 34.0)
	ci.draw_rect(back_panel, Color("111a21"))
	ci.draw_rect(back_panel, Color("2b3e4d"), false, 1.2)
	
	# Brass piping & sampling spigot tap
	ci.draw_line(Vector2(-8.0, -12.0), Vector2(4.0, -12.0), Color("d39a62"), 2.0)
	ci.draw_line(Vector2(4.0, -12.0), Vector2(4.0, -4.0), Color("d39a62"), 2.0)
	ci.draw_line(Vector2(0.0, -14.0), Vector2(8.0, -14.0), Color("c65d58"), 2.2) # Tap valve cross handle
	
	# Graduated glass test flask catching dripping sample
	var flask_rect := Rect2(1.0, -2.0, 8.0, 14.0)
	ci.draw_rect(flask_rect, Color("081216"))
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 4.0)
	ci.draw_rect(Rect2(2.0, 3.0, 6.0, 8.0), Color("5da398", 0.85 if p_is_activated else 0.45))
	ci.draw_rect(flask_rect, Color("75c7c3"), false, 1.0)
	
	# Contamination analog gauge (circular meter on left: radius 6 px)
	var gauge_center := Vector2(-5.0, 2.0)
	ci.draw_circle(gauge_center, 6.0, Color("0a1117"))
	ci.draw_arc(gauge_center, 6.0, 0.0, TAU, 16, Color("3e5866"), 1.0)
	
	# Red warning sector on dial & needle pointing into red zone
	ci.draw_arc(gauge_center, 4.5, -PI * 0.25, PI * 0.5, 8, Color("c65d58"), 1.4)
	var needle_angle: float = PI * 0.35 + sin(p_pulse * 5.0) * 0.15
	var needle_vec := Vector2(cos(needle_angle), sin(needle_angle)) * 4.5
	ci.draw_line(gauge_center, gauge_center + needle_vec, Color("e2b060"), 1.2)
	
	# Glowing LED indicator (red warning or cyan active)
	var led_col := Color("c65d58") if not p_is_activated else Color("5da398")
	ci.draw_circle(Vector2(-5.0, 11.0), 2.0, led_col)
	
	if p_is_activated:
		ci.draw_circle(Vector2(0.0, 0.0), 15.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.3 + pulse * 0.3), false, 1.0)


static func draw_station_36_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy hydraulic storm blast door to Space 37 (Komora Sygnałowa): 44x56 px
	var portal_rect := Rect2(-22.0, -28.0, 44.0, 56.0)
	var door_rect := Rect2(-18.0, -24.0, 36.0, 48.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 2.8)
	
	# Reinforced concrete arch blast casing
	ci.draw_rect(portal_rect, Color("0b1217"))
	ci.draw_rect(portal_rect, Color("253945"), false, 2.2)
	
	# Heavy rubberized storm seal gasket around door perimeter
	ci.draw_rect(door_rect, Color("141c22"))
	ci.draw_rect(door_rect, Color("3d5464"), false, 1.4)
	
	# Dual horizontal hydraulic locking rams
	var ram_offset: float = -12.0 if p_is_activated else 0.0
	ci.draw_rect(Rect2(-16.0 + ram_offset, -12.0, 14.0, 6.0), Color("d39a62"))
	ci.draw_rect(Rect2(2.0 - ram_offset, -12.0, 14.0, 6.0), Color("d39a62"))
	ci.draw_rect(Rect2(-16.0 + ram_offset, 6.0, 14.0, 6.0), Color("d39a62"))
	ci.draw_rect(Rect2(2.0 - ram_offset, 6.0, 14.0, 6.0), Color("d39a62"))
	
	# Reinforced diagonal cross-braces on steel plate
	ci.draw_line(Vector2(-14.0, -20.0), Vector2(14.0, 20.0), Color("22323d"), 1.6)
	ci.draw_line(Vector2(14.0, -20.0), Vector2(-14.0, 20.0), Color("22323d"), 1.6)
	
	if p_is_activated:
		# Door unsealed and retracted: warm amber signal chamber corridor glow
		ci.draw_rect(portal_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.55 + pulse * 0.35), false, 2.2)
		ci.draw_rect(Rect2(-17.0, -23.0, 34.0, 46.0), Color("08141b"))
		ci.draw_line(Vector2(-22.0, 28.0), Vector2(22.0, 28.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.95), 2.2)
		ci.draw_circle(Vector2(0.0, -20.0), 3.0, Color("5da398"))
		ci.draw_line(Vector2(-10.0, -20.0), Vector2(10.0, -20.0), Color("5da398", 0.8), 1.2)
	else:
		# Door sealed: red alert indicator
		ci.draw_circle(Vector2(0.0, -20.0), 2.5, Color("c65d58"))


static func draw_signal_transmission_antenna(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Vertical spire antenna with toroidal resonance rings: 28x56 px
	var base_rect := Rect2(-10.0, 16.0, 20.0, 12.0)
	
	# Ceramic stepped base insulator
	ci.draw_rect(base_rect, Color("141d24"))
	ci.draw_rect(base_rect, Color("2d404d"), false, 1.4)
	ci.draw_rect(Rect2(-7.0, 12.0, 14.0, 4.0), Color("3d5464"))
	
	# Central brass antenna mast / needle
	ci.draw_line(Vector2(0.0, 12.0), Vector2(0.0, -26.0), Color("d39a62"), 2.2)
	ci.draw_line(Vector2(0.0, -26.0), Vector2(0.0, -28.0), Color("e2b060"), 1.4) # needle tip
	
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 3.5)
	
	# 3 Toroidal resonance coils on mast with cyan glow
	for r in range(3):
		var ry: float = -18.0 + float(r) * 10.0
		var ring_w: float = 8.0 - float(r) * 1.5
		var col := Color("5da398", 0.85 if p_is_activated else 0.45)
		ci.draw_line(Vector2(-ring_w, ry), Vector2(ring_w, ry), col, 2.0)
		ci.draw_circle(Vector2(-ring_w, ry), 1.6, Color("75c7c3"))
		ci.draw_circle(Vector2(ring_w, ry), 1.6, Color("75c7c3"))
	
	# Radiating electromagnetic pulse arcs from top spire
	if p_is_activated:
		ci.draw_arc(Vector2(0.0, -26.0), 12.0, -PI * 0.75, -PI * 0.25, 8, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.4 + pulse * 0.35), 1.2)
		ci.draw_arc(Vector2(0.0, -26.0), 20.0, -PI * 0.75, -PI * 0.25, 8, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.2 + pulse * 0.25), 1.0)


static func draw_transmission_cross_patchbay(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Signal cross patchbay matrix with dangling cords: 44x38 px
	var bay_rect := Rect2(-22.0, -19.0, 44.0, 38.0)
	
	# Rack enclosure
	ci.draw_rect(bay_rect, Color("0e161c"))
	ci.draw_rect(bay_rect, Color("293c4a"), false, 1.4)
	
	# Grid of 4x3 patch jacks
	for row in range(3):
		for col in range(4):
			var jx: float = -15.0 + float(col) * 10.0
			var jy: float = -12.0 + float(row) * 10.0
			ci.draw_circle(Vector2(jx, jy), 2.2, Color("05090c"))
			ci.draw_circle(Vector2(jx, jy), 1.2, Color("a8b2ac"))
	
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 2.8)
	
	# Hanging patch cords:
	# Cord 1 (Cinnabar / red): Sector 1 -> Sector 4
	ci.draw_line(Vector2(-15.0, -12.0), Vector2(-5.0, 4.0), Color("c65d58", 0.9), 1.4)
	# Cord 2 (Cyan): Sector 2 -> Sector 3
	ci.draw_line(Vector2(-5.0, -12.0), Vector2(15.0, -2.0), Color("5da398", 0.9 if p_is_activated else 0.5), 1.4)
	
	# Status indicator LEDs on top row
	for l in range(4):
		var lx: float = -15.0 + float(l) * 10.0
		var lcol := Color("5da398") if (p_is_activated or l % 2 == 0) else Color("d39a62")
		ci.draw_circle(Vector2(lx, 13.0), 1.2, lcol)
	
	if p_is_activated:
		ci.draw_rect(bay_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35 + pulse * 0.25), false, 1.2)


static func draw_frequency_oscilloscope_crt(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Waveform oscilloscope with circular green/cyan display: 36x34 px
	var case_rect := Rect2(-18.0, -17.0, 36.0, 34.0)
	ci.draw_rect(case_rect, Color("111a21"))
	ci.draw_rect(case_rect, Color("2d4252"), false, 1.4)
	
	# Round CRT tube bezel
	var crt_center := Vector2(0.0, -3.0)
	var crt_radius := 11.0
	ci.draw_circle(crt_center, crt_radius, Color("041014"))
	ci.draw_arc(crt_center, crt_radius, 0.0, TAU, 20, Color("395161"), 1.2)
	
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 4.2)
	
	# Phosphor trace: Lissajous pattern / overlapping dual sine waves (Lena + Ślad)
	var pts_a: Array[Vector2] = []
	var pts_b: Array[Vector2] = []
	for s in range(12):
		var sx: float = -8.0 + float(s) * 1.45
		var sy1: float = -3.0 + sin(float(s) * 0.8 + p_pulse * 4.0) * 4.5
		var sy2: float = -3.0 + sin(float(s) * 0.8 + p_pulse * 4.0 + PI * 0.4) * 4.5
		pts_a.append(Vector2(sx, sy1))
		pts_b.append(Vector2(sx, sy2))
	
	if pts_a.size() > 1:
		for i in range(pts_a.size() - 1):
			ci.draw_line(pts_a[i], pts_a[i + 1], Color("5da398", 0.85), 1.2)
			ci.draw_line(pts_b[i], pts_b[i + 1], Color("d39a62", 0.85 if p_is_activated else 0.4), 1.0)
	
	# Control knobs below CRT
	ci.draw_circle(Vector2(-9.0, 11.0), 2.2, Color("475d6d"))
	ci.draw_circle(Vector2(0.0, 11.0), 2.2, Color("475d6d"))
	ci.draw_circle(Vector2(9.0, 11.0), 2.2, Color("475d6d"))
	
	if p_is_activated:
		ci.draw_circle(crt_center, crt_radius + 4.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.25 + pulse * 0.25), false, 1.0)


static func draw_memory_injection_pulpit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Memory injection control console with toggle levers: 40x32 px
	var desk_poly: PackedVector2Array = [
		Vector2(-20.0, 14.0),
		Vector2(20.0, 14.0),
		Vector2(16.0, -14.0),
		Vector2(-16.0, -14.0)
	]
	
	# Sloped console body
	ci.draw_colored_polygon(desk_poly, Color("141c22"))
	ci.draw_polyline(desk_poly, Color("3a4f5e"), 1.4)
	ci.draw_line(desk_poly[3], desk_poly[0], Color("3a4f5e"), 1.4)
	
	# 4 Industrial toggle switches with colored indicators
	for t in range(4):
		var tx: float = -12.0 + float(t) * 8.0
		var lever_col := Color("e2b060") if p_is_activated else Color("7a6146")
		# Switch base
		ci.draw_rect(Rect2(tx - 2.0, 2.0, 4.0, 6.0), Color("090d10"))
		# Lever arm (up if active, down if inactive)
		var l_tip := Vector2(tx, -4.0 if p_is_activated else 4.0)
		ci.draw_line(Vector2(tx, 4.0), l_tip, lever_col, 1.6)
		ci.draw_circle(l_tip, 1.5, Color("d39a62"))
	
	# Dual VU level meters on top slope
	ci.draw_rect(Rect2(-12.0, -11.0, 10.0, 5.0), Color("081014"))
	ci.draw_rect(Rect2(2.0, -11.0, 10.0, 5.0), Color("081014"))
	var vu_val := 0.85 if p_is_activated else 0.35
	ci.draw_line(Vector2(-11.0, -8.0), Vector2(-11.0 + vu_val * 8.0, -8.0), Color("5da398"), 1.2)
	ci.draw_line(Vector2(3.0, -8.0), Vector2(3.0 + vu_val * 8.0, -8.0), Color("c65d58"), 1.2)
	
	if p_is_activated:
		var pulse: float = 0.5 + 0.5 * sin(p_pulse * 3.2)
		ci.draw_circle(Vector2(0.0, 0.0), 16.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.25 + pulse * 0.25), false, 1.0)


static func draw_station_37_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Broadcast chamber airlock gate to Space 38: 42x54 px
	var portal_rect := Rect2(-21.0, -27.0, 42.0, 54.0)
	var door_rect := Rect2(-17.0, -23.0, 34.0, 46.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 2.8)
	
	# Vault portal frame
	ci.draw_rect(portal_rect, Color("0a1216"))
	ci.draw_rect(portal_rect, Color("223642"), false, 2.0)
	
	# Steel door leaf
	ci.draw_rect(door_rect, Color("131e26"))
	ci.draw_rect(door_rect, Color("354e5e"), false, 1.4)
	
	# Fiber-optic channel indicator strip along center
	ci.draw_line(Vector2(0.0, -20.0), Vector2(0.0, 20.0), Color("5da398" if p_is_activated else "284540"), 2.0)
	
	# Locking lugs
	var lug_offset: float = -10.0 if p_is_activated else 0.0
	ci.draw_rect(Rect2(-16.0 + lug_offset, -8.0, 10.0, 5.0), Color("d39a62"))
	ci.draw_rect(Rect2(6.0 - lug_offset, -8.0, 10.0, 5.0), Color("d39a62"))
	ci.draw_rect(Rect2(-16.0 + lug_offset, 8.0, 10.0, 5.0), Color("d39a62"))
	ci.draw_rect(Rect2(6.0 - lug_offset, 8.0, 10.0, 5.0), Color("d39a62"))
	
	if p_is_activated:
		ci.draw_rect(portal_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.55 + pulse * 0.35), false, 2.2)
		ci.draw_rect(Rect2(-16.0, -22.0, 32.0, 44.0), Color("061117"))
		ci.draw_line(Vector2(-21.0, 27.0), Vector2(21.0, 27.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.95), 2.2)
		ci.draw_circle(Vector2(0.0, -18.0), 3.0, Color("5da398"))
	else:
		ci.draw_circle(Vector2(0.0, -18.0), 2.5, Color("c65d58"))


static func draw_accident_simulation_field(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# 3D levitating wireframe phantom of derailed Line 4 tram: 48x44 px
	var sim_rect := Rect2(-24.0, -22.0, 48.0, 44.0)
	
	# Field perimeter distortion boundary
	ci.draw_rect(sim_rect, Color("0a1015", 0.8))
	ci.draw_rect(sim_rect, Color("223645"), false, 1.2)
	
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 3.5)
	
	# Levitating tram chassis wireframe in oxide-cinnabar / cyan
	var tram_poly: PackedVector2Array = [
		Vector2(-18.0, 6.0),
		Vector2(18.0, 2.0),
		Vector2(14.0, -14.0),
		Vector2(-14.0, -10.0)
	]
	var tram_col := Color("c65d58", 0.85 if not p_is_activated else 0.45)
	ci.draw_colored_polygon(tram_poly, Color(0.15, 0.05, 0.05, 0.6))
	ci.draw_polyline(tram_poly, tram_col, 1.6)
	ci.draw_line(tram_poly[3], tram_poly[0], tram_col, 1.6)
	
	# Twisted wheel bogie / derailment shear lines
	ci.draw_line(Vector2(-12.0, 6.0), Vector2(-8.0, 14.0), Color("d39a62"), 1.8)
	ci.draw_line(Vector2(8.0, 4.0), Vector2(14.0, 12.0), Color("d39a62"), 1.8)
	ci.draw_circle(Vector2(-8.0, 14.0), 2.2, Color("3d5464"))
	ci.draw_circle(Vector2(14.0, 12.0), 2.2, Color("3d5464"))
	
	# Tram windows with flickering trauma silhouettes
	for w in range(3):
		var wx: float = -10.0 + float(w) * 8.0
		ci.draw_rect(Rect2(wx, -8.0, 5.0, 6.0), Color(0.78, 0.36, 0.35, 0.5 + pulse * 0.3))
	
	# Electromagnetic anomaly distortion rings around derailed car
	ci.draw_arc(Vector2(0.0, -2.0), 18.0, 0.0, TAU, 16, Color(0.78, 0.36, 0.35, 0.35 + pulse * 0.3), 1.2)
	if p_is_activated:
		ci.draw_arc(Vector2(0.0, -2.0), 24.0, 0.0, TAU, 20, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45 + pulse * 0.25), 1.0)


static func draw_destabilizing_jakub_shadow(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Jakub's silhouette losing material stability into carrier wave: 26x42 px
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 6.0)
	
	# Base pedestal
	ci.draw_line(Vector2(-10.0, 18.0), Vector2(10.0, 18.0), Color("1a2733"), 2.0)
	
	# Decomposing figure slices (horizontal scanline drift)
	var slice_count := 8
	for s in range(slice_count):
		var sy: float = -16.0 + float(s) * 4.2
		var drift: float = sin(float(s) * 1.5 + p_pulse * 5.0) * (3.5 if not p_is_activated else 1.0)
		var sw: float = 6.0 if s < 2 else (10.0 if s < 6 else 8.0)
		var scol := Color("c65d58" if not p_is_activated else "d39a62", 0.75 + pulse * 0.2)
		ci.draw_line(Vector2(-sw + drift, sy), Vector2(sw + drift, sy), scol, 2.2)
	
	# Head / shoulders outline
	var head_center := Vector2(sin(p_pulse * 4.0) * 1.5, -16.0)
	ci.draw_circle(head_center, 3.5, Color("d39a62", 0.9 if p_is_activated else 0.5))
	
	# UCP technician tool belt / badge flicker
	ci.draw_rect(Rect2(-4.0, 2.0, 8.0, 3.0), Color("e2b060", 0.8))
	
	if p_is_activated:
		# Stabilized halo around brother
		ci.draw_arc(Vector2(0.0, 0.0), 16.0, 0.0, TAU, 16, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.5 + pulse * 0.3), 1.2)


static func draw_rescue_tether_anchor(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Relational tether / clasping hands stabilizing human life: 32x34 px
	var base_rect := Rect2(-16.0, -17.0, 32.0, 34.0)
	ci.draw_rect(base_rect, Color("0b1318"))
	ci.draw_rect(base_rect, Color("223947"), false, 1.2)
	
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 3.8)
	
	# Lena's reaching hand (left, cyan)
	ci.draw_line(Vector2(-12.0, 2.0), Vector2(-2.0, -2.0), Color("5da398"), 2.2)
	ci.draw_circle(Vector2(-2.0, -2.0), 2.2, Color("75c7c3"))
	
	# Jakub's grasping hand (right, amber)
	ci.draw_line(Vector2(12.0, -2.0), Vector2(2.0, 2.0), Color("d39a62"), 2.2)
	ci.draw_circle(Vector2(2.0, 2.0), 2.2, Color("e2b060"))
	
	# Clasping clasp intersection
	ci.draw_line(Vector2(-2.0, -2.0), Vector2(2.0, 2.0), Color("e5ece9"), 2.4)
	
	# Radiant stabilizing bond arcs
	if p_is_activated:
		ci.draw_circle(Vector2(0.0, 0.0), 10.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.4 + pulse * 0.35), false, 1.4)
		ci.draw_circle(Vector2(0.0, 0.0), 15.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.25 + pulse * 0.25), false, 1.0)
	else:
		ci.draw_circle(Vector2(0.0, 0.0), 6.0, Color("c65d58", 0.6), false, 1.0)


static func draw_return_coordinate_calculator(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# UCP analytical return coordinate pulpit: 38x32 px
	var body_rect := Rect2(-19.0, -16.0, 38.0, 32.0)
	ci.draw_rect(body_rect, Color("111a21"))
	ci.draw_rect(body_rect, Color("2f4657"), false, 1.4)
	
	# CRT Screen showing vector calculations
	var scr_rect := Rect2(-15.0, -12.0, 30.0, 16.0)
	ci.draw_rect(scr_rect, Color("050c10"))
	ci.draw_rect(scr_rect, Color("3a5568"), false, 1.0)
	
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 4.0)
	
	# Calculation vectors / text lines on screen
	ci.draw_line(Vector2(-12.0, -8.0), Vector2(6.0, -8.0), Color("c65d58" if not p_is_activated else "5da398"), 1.2) # POWRÓT 99.8%
	ci.draw_line(Vector2(-12.0, -4.0), Vector2(10.0, -4.0), Color("c65d58" if not p_is_activated else "5da398"), 1.2) # KOSZT BRAT
	ci.draw_line(Vector2(-12.0, 0.0), Vector2(-2.0, 0.0), Color("d39a62"), 1.0)
	
	# Reset / abort button below screen
	ci.draw_circle(Vector2(-8.0, 8.0), 2.2, Color("c65d58"))
	ci.draw_circle(Vector2(0.0, 8.0), 2.2, Color("d39a62"))
	ci.draw_circle(Vector2(8.0, 8.0), 2.2, Color("5da398" if p_is_activated else "284540"))
	
	if p_is_activated:
		ci.draw_rect(body_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35 + pulse * 0.25), false, 1.2)


static func draw_station_38_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy rotational vault portal to Space 39: 44x56 px
	var portal_rect := Rect2(-22.0, -28.0, 44.0, 56.0)
	var door_rect := Rect2(-18.0, -24.0, 36.0, 48.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 2.8)
	
	# Vault portal frame
	ci.draw_rect(portal_rect, Color("0b1318"))
	ci.draw_rect(portal_rect, Color("283d4c"), false, 2.2)
	
	# Steel door leaf
	ci.draw_rect(door_rect, Color("141e26"))
	ci.draw_rect(door_rect, Color("3d586a"), false, 1.4)
	
	# Rotating three-spoke locking wheel
	var wheel_center := Vector2(0.0, 0.0)
	var wheel_radius := 10.0
	ci.draw_circle(wheel_center, wheel_radius, Color("091015"))
	ci.draw_arc(wheel_center, wheel_radius, 0.0, TAU, 16, Color("d39a62"), 1.6)
	
	var rot_angle: float = (p_pulse * 2.0 if p_is_activated else 0.0)
	for sp in range(3):
		var ang: float = rot_angle + float(sp) * (TAU / 3.0)
		var sp_vec := Vector2(cos(ang), sin(ang)) * wheel_radius
		ci.draw_line(wheel_center, wheel_center + sp_vec, Color("e2b060"), 1.8)
	
	# Top channel synchronization indicators (3 LEDs)
	for l in range(3):
		var lx: float = -8.0 + float(l) * 8.0
		var lcol := Color("5da398") if p_is_activated else (Color("d39a62") if l == 0 else Color("c65d58"))
		ci.draw_circle(Vector2(lx, -18.0), 1.8, lcol)
	
		ci.draw_rect(portal_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.55 + pulse * 0.35), false, 2.2)
		ci.draw_rect(Rect2(-17.0, -23.0, 34.0, 46.0), Color("061117"))
		ci.draw_line(Vector2(-22.0, 28.0), Vector2(22.0, 28.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.95), 2.2)


static func draw_central_reference_core_monolith(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Central reference core of Substructure: 54x58 px
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 2.5)
	
	# Pedestal base
	var base_poly: PackedVector2Array = [
		Vector2(-24.0, 26.0),
		Vector2(24.0, 26.0),
		Vector2(18.0, 18.0),
		Vector2(-18.0, 18.0)
	]
	ci.draw_colored_polygon(base_poly, Color("0a1218"))
	ci.draw_polyline(base_poly, Color("2d4352"), 1.4)
	ci.draw_line(base_poly[3], base_poly[0], Color("2d4352"), 1.4)
	
	# Monolithic crystalline polyhedron (diamond / hexagonal core)
	var core_poly: PackedVector2Array = [
		Vector2(0.0, -26.0),
		Vector2(18.0, -6.0),
		Vector2(14.0, 16.0),
		Vector2(-14.0, 16.0),
		Vector2(-18.0, -6.0)
	]
	var core_col := Color("101d26", 0.9)
	var border_col := Color("5da398" if p_is_activated else "3b5463")
	ci.draw_colored_polygon(core_poly, core_col)
	ci.draw_polyline(core_poly, border_col, 1.8)
	ci.draw_line(core_poly[4], core_poly[0], border_col, 1.8)
	
	# Internal crystal facets
	ci.draw_line(Vector2(0.0, -26.0), Vector2(0.0, 16.0), Color("75c7c3", 0.6), 1.2)
	ci.draw_line(Vector2(-18.0, -6.0), Vector2(0.0, 0.0), Color("75c7c3", 0.6), 1.0)
	ci.draw_line(Vector2(18.0, -6.0), Vector2(0.0, 0.0), Color("75c7c3", 0.6), 1.0)
	
	# Triple orbiting quantum harmonic resonance rings (Cyan, Amber, Cinnabar)
	var ring_r: float = 24.0 + pulse * 3.0
	ci.draw_arc(Vector2(0.0, -2.0), ring_r, p_pulse * 1.5, p_pulse * 1.5 + PI * 1.5, 20, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.65), 1.4)
	ci.draw_arc(Vector2(0.0, -2.0), ring_r - 4.0, -p_pulse * 1.2, -p_pulse * 1.2 + PI * 1.5, 18, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.65), 1.4)
	ci.draw_arc(Vector2(0.0, -2.0), ring_r + 4.0, p_pulse * 0.9 + 1.0, p_pulse * 0.9 + 1.0 + PI * 1.5, 22, Color(0.78, 0.36, 0.35, 0.55), 1.2)
	
	# Radiant core glow
	if p_is_activated:
		ci.draw_circle(Vector2(0.0, 0.0), 8.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.4 + pulse * 0.35))
		ci.draw_circle(Vector2(0.0, 0.0), 3.5, Color("ffffff"))


static func draw_branch_config_return_a(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Branch Configuration A: Powrót / Własny Pokój (36x34 px)
	var body_rect := Rect2(-18.0, -17.0, 36.0, 34.0)
	ci.draw_rect(body_rect, Color("0b1318"))
	ci.draw_rect(body_rect, Color("2d4657"), false, 1.4)
	
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 3.2)
	
	# Crystal cyan emitter beacon
	var beacon_center := Vector2(0.0, -8.0)
	ci.draw_circle(beacon_center, 6.0, Color("061118"))
	ci.draw_circle(beacon_center, 4.0, Color("5da398" if p_is_activated else "284540"))
	
	# Oscilloscope line: single pure sine wave (clean return vector)
	var pts: PackedVector2Array = []
	for i in range(16):
		var px: float = -12.0 + float(i) * 1.6
		var py: float = 6.0 + sin(float(i) * 0.8 + p_pulse * 3.0) * 3.5
		pts.append(Vector2(px, py))
	if pts.size() > 1:
		for i in range(pts.size() - 1):
			ci.draw_line(pts[i], pts[i + 1], Color("5da398" if p_is_activated else "355752"), 1.2)
	
	# Status indicator LED
	ci.draw_circle(Vector2(12.0, -11.0), 2.0, Color("5da398" if p_is_activated else "284540"))
	
	if p_is_activated:
		ci.draw_rect(body_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35 + pulse * 0.25), false, 1.2)


static func draw_branch_config_reconciliation_b(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Branch Configuration B: Uzgodnienie / Miejsce po niej (36x34 px)
	var body_rect := Rect2(-18.0, -17.0, 36.0, 34.0)
	ci.draw_rect(body_rect, Color("14120f"))
	ci.draw_rect(body_rect, Color("4a3c2c"), false, 1.4)
	
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 3.0)
	
	# Dual gold wedding band cradle icon
	ci.draw_arc(Vector2(-4.0, -7.0), 4.5, 0.0, TAU, 14, Color("d39a62" if p_is_activated else "7a6146"), 1.6)
	ci.draw_arc(Vector2(4.0, -7.0), 4.5, 0.0, TAU, 14, Color("e2b060" if p_is_activated else "8c704f"), 1.6)
	
	# Joint overlapping waveform trace
	var pts: PackedVector2Array = []
	for i in range(16):
		var px: float = -12.0 + float(i) * 1.6
		var py: float = 6.0 + (sin(float(i) * 0.6 + p_pulse * 2.5) + cos(float(i) * 0.6)) * 2.2
		pts.append(Vector2(px, py))
	if pts.size() > 1:
		for i in range(pts.size() - 1):
			ci.draw_line(pts[i], pts[i + 1], Color("d39a62" if p_is_activated else "5e4933"), 1.2)
	
	# Status indicator LED
	ci.draw_circle(Vector2(12.0, -11.0), 2.0, Color("d39a62" if p_is_activated else "5e4933"))
	
	if p_is_activated:
		ci.draw_rect(body_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.35 + pulse * 0.25), false, 1.2)


static func draw_branch_config_testimony_c(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Branch Configuration C: Świadectwo / Dwie Prawdy (36x34 px)
	var body_rect := Rect2(-18.0, -17.0, 36.0, 34.0)
	ci.draw_rect(body_rect, Color("140e10"))
	ci.draw_rect(body_rect, Color("4a2b30"), false, 1.4)
	
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 3.4)
	
	# 4 Distributed witness nodes (Marta, Jakub, Szymon, Public)
	var node_pos: Array[Vector2] = [
		Vector2(-7.0, -10.0),
		Vector2(7.0, -10.0),
		Vector2(-7.0, -3.0),
		Vector2(7.0, -3.0)
	]
	var node_cols: Array[Color] = [
		Color("5da398"), # Marta
		Color("d39a62"), # Jakub
		Color("c65d58"), # Szymon
		Color("e5ece9")  # Public
	]
	for idx in range(4):
		var n_col: Color = node_cols[idx] if p_is_activated else Color("3d2c30")
		ci.draw_circle(node_pos[idx], 2.2, n_col)
	
	# Multi-frequency polyphonic grid trace
	for g in range(3):
		var gy: float = 4.0 + float(g) * 3.5
		var col := Color("c65d58" if p_is_activated else "4a2b30", 0.75)
		ci.draw_line(Vector2(-12.0, gy), Vector2(12.0, gy), col, 1.0)
	
	# Status indicator LED
	ci.draw_circle(Vector2(12.0, -11.0), 2.0, Color("c65d58" if p_is_activated else "4a2b30"))
	
	if p_is_activated:
		ci.draw_rect(body_rect, Color(0.78, 0.36, 0.35, 0.35 + pulse * 0.25), false, 1.2)


static func draw_station_39_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Central Substructure Ascent Gateway to Act IV: 46x58 px
	var portal_rect := Rect2(-23.0, -29.0, 46.0, 58.0)
	var door_rect := Rect2(-19.0, -25.0, 38.0, 50.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 2.6)
	
	# Portal arch frame
	ci.draw_rect(portal_rect, Color("081014"))
	ci.draw_rect(portal_rect, Color("284352"), false, 2.2)
	
	# Ascending gate leaf
	ci.draw_rect(door_rect, Color("111a21"))
	ci.draw_rect(door_rect, Color("355466"), false, 1.4)
	
	# Central vertical light shaft to Level 0
	var beam_col := Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.85 if p_is_activated else 0.25)
	ci.draw_line(Vector2(0.0, -22.0), Vector2(0.0, 22.0), beam_col, 2.4)
	
	# Triangular crown aperture
	var crown_poly: PackedVector2Array = [
		Vector2(-14.0, -18.0),
		Vector2(14.0, -18.0),
		Vector2(0.0, -26.0)
	]
	ci.draw_colored_polygon(crown_poly, Color("172630"))
	ci.draw_polyline(crown_poly, Color("5da398" if p_is_activated else "355466"), 1.4)
	ci.draw_line(crown_poly[2], crown_poly[0], Color("5da398" if p_is_activated else "355466"), 1.4)
	
	if p_is_activated:
		ci.draw_rect(portal_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.55 + pulse * 0.35), false, 2.2)
		ci.draw_rect(Rect2(-18.0, -24.0, 36.0, 48.0), Color("051016"))
		ci.draw_line(Vector2(-23.0, 29.0), Vector2(23.0, 29.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.95), 2.2)


static func draw_wierzbicka_personal_terminal(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Dr Helena Wierzbicka Personal Executive Terminal & Presence (32x42 px)
	var podium_rect := Rect2(-16.0, -10.0, 32.0, 30.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 2.5)
	
	# Minimalist executive console base
	ci.draw_rect(podium_rect, Color("141e26"))
	ci.draw_rect(podium_rect, Color("2d4352"), false, 1.4)
	
	# Console screen with UCP directorate diagnostic graph
	var screen_rect := Rect2(-12.0, -8.0, 24.0, 14.0)
	ci.draw_rect(screen_rect, Color("081116"))
	ci.draw_rect(screen_rect, Color("5da398" if p_is_activated else "223440"), false, 1.0)
	
	# Status lines on screen (Institutional stability index)
	var scr_col := Color("5da398" if p_is_activated else "395666")
	ci.draw_line(Vector2(-9.0, -4.0), Vector2(9.0, -4.0), scr_col, 1.0)
	ci.draw_line(Vector2(-9.0, -1.0), Vector2(4.0, -1.0), scr_col * 0.8, 1.0)
	ci.draw_line(Vector2(-9.0, 2.0), Vector2(7.0, 2.0), scr_col * 0.9, 1.0)
	
	# Wierzbicka standing silhouette behind console (Level 0, no escort)
	# Head / Hair
	ci.draw_circle(Vector2(0.0, -26.0), 4.2, Color("1e2a33"))
	ci.draw_circle(Vector2(0.0, -26.0), 4.2, Color("5da398" if p_is_activated else "344a59"), false, 1.0)
	# Torso & Director Coat
	var coat_poly: PackedVector2Array = [
		Vector2(-6.0, -21.0),
		Vector2(6.0, -21.0),
		Vector2(8.0, -10.0),
		Vector2(-8.0, -10.0)
	]
	ci.draw_colored_polygon(coat_poly, Color("18232c"))
	ci.draw_polyline(coat_poly, Color("3b5363"), 1.2)
	# Lapel / Director Collar
	ci.draw_line(Vector2(-2.0, -21.0), Vector2(0.0, -14.0), Color("5da398"), 1.2)
	ci.draw_line(Vector2(2.0, -21.0), Vector2(0.0, -14.0), Color("5da398"), 1.2)
	
	# Director authorization keycard slot & LED
	ci.draw_rect(Rect2(-8.0, 10.0, 16.0, 4.0), Color("0d151c"))
	ci.draw_circle(Vector2(10.0, 12.0), 1.8, Color("5da398" if p_is_activated else "223440"))
	
	if p_is_activated:
		ci.draw_rect(podium_rect, Color(0.36, 0.64, 0.60, 0.40 + pulse * 0.25), false, 1.2)


static func draw_marta_witness_station(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Marta Kurek Witness Station: resolute presence refusing proxy choice (28x40 px)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 2.8)
	
	# Floor marker / station position
	ci.draw_rect(Rect2(-12.0, 16.0, 24.0, 4.0), Color("171c20"))
	ci.draw_rect(Rect2(-12.0, 16.0, 24.0, 4.0), Color("543b2b"), false, 1.0)
	
	# Tool bag on floor (Marta's practical anchor)
	var bag_rect := Rect2(8.0, 8.0, 10.0, 10.0)
	ci.draw_rect(bag_rect, Color("2b1d14"))
	ci.draw_rect(bag_rect, Color("7e5233"), false, 1.2)
	ci.draw_line(Vector2(10.0, 8.0), Vector2(16.0, 8.0), Color("d39a62"), 1.2) # Handle
	
	# Marta silhouette: long pink hair and septum remain visible in the final witness role.
	var marta_hair_shadow := Color("6d294f")
	var marta_hair_pink := Color("d45b9a")
	var marta_skin := Color("d39a62" if p_is_activated else "5e3e2b")
	ci.draw_circle(Vector2(0.0, -22.0), 4.4, marta_hair_shadow)
	ci.draw_rect(Rect2(-4.2, -21.0, 2.8, 12.0), marta_hair_shadow)
	ci.draw_rect(Rect2(1.4, -21.0, 2.8, 12.0), marta_hair_shadow)
	ci.draw_circle(Vector2(0.0, -22.0), 3.4, marta_skin)
	ci.draw_line(Vector2(-3.7, -25.0), Vector2(2.8, -26.0), marta_hair_pink, 1.8)
	ci.draw_line(Vector2(-3.2, -19.2), Vector2(-3.2, -9.0), marta_hair_pink, 1.3)
	ci.draw_line(Vector2(2.8, -19.2), Vector2(2.8, -9.0), marta_hair_pink, 1.3)
	ci.draw_arc(Vector2(0.9, -20.8), 0.9, 0.15, PI - 0.15, 5, Color("c7d3d6"), 0.7)
	
	# Jacket & Torso
	var jacket_poly: PackedVector2Array = [
		Vector2(-7.0, -17.0),
		Vector2(7.0, -17.0),
		Vector2(8.5, 2.0),
		Vector2(-8.5, 2.0)
	]
	ci.draw_colored_polygon(jacket_poly, Color("241b16"))
	ci.draw_polyline(jacket_poly, Color("7e5233"), 1.2)
	
	# Legs / Trousers
	ci.draw_line(Vector2(-4.0, 2.0), Vector2(-4.0, 16.0), Color("1c1511"), 2.4)
	ci.draw_line(Vector2(4.0, 2.0), Vector2(4.0, 16.0), Color("1c1511"), 2.4)
	
	# Amber relational aura indicator
	if p_is_activated:
		ci.draw_circle(Vector2(0.0, -10.0), 18.0, Color(0.83, 0.60, 0.38, 0.15 + pulse * 0.15))
		ci.draw_rect(Rect2(-10.0, -28.0, 20.0, 48.0), Color(0.83, 0.60, 0.38, 0.35 + pulse * 0.25), false, 1.0)


static func draw_szymon_transmission_monitor(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Szymon Bera Transmission Monitor & Crayon Drawing Broadcast (32x36 px)
	var mon_rect := Rect2(-16.0, -18.0, 32.0, 36.0)
	var screen_rect := Rect2(-12.0, -14.0, 24.0, 22.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 3.2)
	
	# Industrial communication display housing
	ci.draw_rect(mon_rect, Color("121920"))
	ci.draw_rect(mon_rect, Color("2b3e4d"), false, 1.4)
	
	# CRT screen with analog transmission raster
	ci.draw_rect(screen_rect, Color("081017"))
	ci.draw_rect(screen_rect, Color("3d5a6c"), false, 1.0)
	
	# Broadcast raster scanlines
	for s in range(5):
		var sy: float = -11.0 + float(s) * 4.2
		ci.draw_line(Vector2(-10.0, sy), Vector2(10.0, sy), Color(0.24, 0.38, 0.48, 0.35), 0.8)
	
	# Szymon's crayon drawing outline on screen (Well & Water stream)
	var crayon_col := Color("e2b060" if p_is_activated else "6e5630")
	# Well rim
	ci.draw_rect(Rect2(-6.0, -4.0, 12.0, 7.0), Color("0d1720"))
	ci.draw_rect(Rect2(-6.0, -4.0, 12.0, 7.0), crayon_col, false, 1.2)
	# Water stream descending
	ci.draw_line(Vector2(0.0, 3.0), Vector2(0.0, 6.0), Color("75c7c3"), 1.2)
	
	# Transmission feed indicator LED & Antenna
	ci.draw_line(Vector2(-10.0, -18.0), Vector2(-14.0, -25.0), Color("3d5a6c"), 1.2)
	ci.draw_circle(Vector2(-14.0, -25.0), 1.4, Color("c65d58" if p_is_activated else "3d5a6c"))
	ci.draw_circle(Vector2(10.0, 12.0), 1.8, Color("c65d58" if p_is_activated else "2b3e4d"))
	
	if p_is_activated:
		ci.draw_rect(mon_rect, Color(0.78, 0.36, 0.35, 0.35 + pulse * 0.25), false, 1.2)


static func draw_operation_cost_dossier_matrix(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Operation Cost Dossier Matrix: Comparative balance of 3 operations (46x36 px)
	var matrix_rect := Rect2(-23.0, -18.0, 46.0, 36.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 3.0)
	
	# Metal housing
	ci.draw_rect(matrix_rect, Color("0e161c"))
	ci.draw_rect(matrix_rect, Color("293c4a"), false, 1.4)
	
	# Three comparative columns: A (Return / Cyan), B (Reconciliation / Amber), C (Testimony / Cinnabar)
	var col_width := 11.0
	var col_xs: Array[float] = [-15.0, 0.0, 15.0]
	var col_colors: Array[Color] = [
		Color("5da398"), # A: Powrót
		Color("d39a62"), # B: Uzgodnienie
		Color("c65d58")  # C: Świadectwo
	]
	
	for idx in range(3):
		var cx: float = col_xs[idx]
		var base_col: Color = col_colors[idx]
		var active_col: Color = base_col if p_is_activated else base_col * 0.45
		
		var col_rect := Rect2(cx - col_width * 0.5, -13.0, col_width, 24.0)
		ci.draw_rect(col_rect, Color("080d12"))
		ci.draw_rect(col_rect, active_col * 0.6, false, 1.0)
		
		# Balance bar / capacity meter in column
		var meter_h: float = 6.0 + float(idx) * 4.0
		ci.draw_rect(Rect2(cx - 3.5, 9.0 - meter_h, 7.0, meter_h), active_col * 0.85)
		
		# Letter tag A / B / C marker
		ci.draw_circle(Vector2(cx, -8.0), 1.8, active_col)
	
	# Header & Footer dividing rails
	ci.draw_line(Vector2(-21.0, -15.0), Vector2(21.0, -15.0), Color("3d5464"), 1.0)
	ci.draw_line(Vector2(-21.0, 14.0), Vector2(21.0, 14.0), Color("3d5464"), 1.0)
	
	if p_is_activated:
		ci.draw_rect(matrix_rect, Color(0.36, 0.64, 0.60, 0.40 + pulse * 0.25), false, 1.2)


static func draw_station_40_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Modernist Vaulted Portal leading to Space 41 (Chamber of Operational Choice): 48x62 px
	var portal_rect := Rect2(-24.0, -31.0, 48.0, 62.0)
	var door_rect := Rect2(-20.0, -27.0, 40.0, 54.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 2.6)
	
	# Solid polished steel arch frame
	ci.draw_rect(portal_rect, Color("0b1318"))
	ci.draw_rect(portal_rect, Color("2d4657"), false, 2.2)
	
	# Sliding chamber gate leaf
	ci.draw_rect(door_rect, Color("142028"))
	ci.draw_rect(door_rect, Color("3b5a6e"), false, 1.4)
	
	# Triple vertical alignment light beams (Cyan, Amber, Cinnabar)
	var beam_a := Color(0.36, 0.64, 0.60, 0.85 if p_is_activated else 0.25)
	var beam_b := Color(0.83, 0.60, 0.38, 0.85 if p_is_activated else 0.25)
	var beam_c := Color(0.78, 0.36, 0.35, 0.85 if p_is_activated else 0.25)
	
	ci.draw_line(Vector2(-6.0, -24.0), Vector2(-6.0, 24.0), beam_a, 1.6)
	ci.draw_line(Vector2(0.0, -24.0), Vector2(0.0, 24.0), beam_b, 1.6)
	ci.draw_line(Vector2(6.0, -24.0), Vector2(6.0, 24.0), beam_c, 1.6)
	
	# Modernist lintel header
	ci.draw_rect(Rect2(-20.0, -29.0, 40.0, 4.0), Color("1a2933"))
	ci.draw_rect(Rect2(-20.0, -29.0, 40.0, 4.0), Color("5da398" if p_is_activated else "3b5a6e"), false, 1.0)
	
	if p_is_activated:
		ci.draw_rect(portal_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.55 + pulse * 0.35), false, 2.2)
		ci.draw_rect(Rect2(-19.0, -26.0, 38.0, 52.0), Color("061219"))
		ci.draw_line(Vector2(-24.0, 31.0), Vector2(24.0, 31.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.95), 2.2)


static func draw_op_console_return_a(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Operation A Terminal: Return / Powrót — Własny pokój (34x42 px)
	var casing_rect := Rect2(-17.0, -21.0, 34.0, 42.0)
	var screen_rect := Rect2(-13.0, -17.0, 26.0, 22.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 3.4)
	var cyan_col := Color("75c7c3" if p_is_activated else "3a6462")
	
	# Angled modernist console casing
	ci.draw_rect(casing_rect, Color("0d161d"))
	ci.draw_rect(casing_rect, Color("27404e"), false, 1.4)
	
	# CRT Screen with 21:45 vacuum correlation vector
	ci.draw_rect(screen_rect, Color("071017"))
	ci.draw_rect(screen_rect, cyan_col * 0.7, false, 1.0)
	
	# Vector waveform trace (correlation pulse 21:45)
	ci.draw_line(Vector2(-10.0, -6.0), Vector2(-4.0, -6.0), cyan_col, 1.0)
	ci.draw_line(Vector2(-4.0, -6.0), Vector2(-1.0, -13.0), cyan_col, 1.2)
	ci.draw_line(Vector2(-1.0, -13.0), Vector2(2.0, 1.0), cyan_col, 1.2)
	ci.draw_line(Vector2(2.0, 1.0), Vector2(5.0, -6.0), cyan_col, 1.2)
	ci.draw_line(Vector2(5.0, -6.0), Vector2(10.0, -6.0), cyan_col, 1.0)
	
	# Single isolated world coordinate anchor dot (21:45)
	ci.draw_circle(Vector2(-1.0, -13.0), 1.8, Color("75c7c3" if p_is_activated else "45706e"))
	
	# Control desk lower shelf with execution lever & badge A
	ci.draw_rect(Rect2(-14.0, 7.0, 28.0, 10.0), Color("121f29"))
	ci.draw_rect(Rect2(-14.0, 7.0, 28.0, 10.0), Color("345060"), false, 1.0)
	# Lever arm
	var lever_x: float = -5.0 if not p_is_activated else 5.0
	ci.draw_line(Vector2(0.0, 15.0), Vector2(lever_x, 9.0), Color("75c7c3"), 1.8)
	ci.draw_circle(Vector2(lever_x, 9.0), 2.2, Color("75c7c3"))
	
	# Letter 'A' status tag
	ci.draw_circle(Vector2(9.0, 12.0), 2.2, Color("75c7c3" if p_is_activated else "27404e"))
	
	if p_is_activated:
		ci.draw_rect(casing_rect, Color(0.46, 0.78, 0.76, 0.45 + pulse * 0.30), false, 1.6)
		ci.draw_circle(Vector2(0.0, -6.0), 16.0, Color(0.46, 0.78, 0.76, 0.12 + pulse * 0.12))


static func draw_op_console_reconciliation_b(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Operation B Terminal: Reconciliation / Uzgodnienie — Miejsce po niej (34x42 px)
	var casing_rect := Rect2(-17.0, -21.0, 34.0, 42.0)
	var screen_rect := Rect2(-13.0, -17.0, 26.0, 22.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 3.2)
	var amber_col := Color("d39a62" if p_is_activated else "6b4d31")
	
	# Angled modernist console casing
	ci.draw_rect(casing_rect, Color("17130f"))
	ci.draw_rect(casing_rect, Color("453426"), false, 1.4)
	
	# CRT Screen with Flat 14 floorplan & gold ring slot
	ci.draw_rect(screen_rect, Color("100d0a"))
	ci.draw_rect(screen_rect, amber_col * 0.7, false, 1.0)
	
	# Interlocking twin circles (Relational bridge / Flat 14 table & gold ring)
	ci.draw_arc(Vector2(-3.0, -6.0), 5.5, 0.0, TAU, 16, amber_col, 1.2)
	ci.draw_arc(Vector2(3.0, -6.0), 5.5, 0.0, TAU, 16, amber_col, 1.2)
	ci.draw_circle(Vector2(0.0, -6.0), 1.8, Color("e2b060" if p_is_activated else "5a4128"))
	
	# Control desk lower shelf with UCP bridge latch bar & badge B
	ci.draw_rect(Rect2(-14.0, 7.0, 28.0, 10.0), Color("241d16"))
	ci.draw_rect(Rect2(-14.0, 7.0, 28.0, 10.0), Color("5e4530"), false, 1.0)
	# Sliding horizontal latch bar
	var bar_w: float = 16.0 if p_is_activated else 8.0
	ci.draw_line(Vector2(-bar_w * 0.5, 12.0), Vector2(bar_w * 0.5, 12.0), Color("d39a62"), 2.0)
	ci.draw_circle(Vector2(-6.0, 12.0), 1.8, Color("d39a62"))
	ci.draw_circle(Vector2(6.0, 12.0), 1.8, Color("d39a62"))
	
	# Letter 'B' status tag
	ci.draw_circle(Vector2(9.0, 12.0), 2.2, Color("d39a62" if p_is_activated else "3b2a1e"))
	
	if p_is_activated:
		ci.draw_rect(casing_rect, Color(0.83, 0.60, 0.38, 0.45 + pulse * 0.30), false, 1.6)
		ci.draw_circle(Vector2(0.0, -6.0), 16.0, Color(0.83, 0.60, 0.38, 0.12 + pulse * 0.12))


static func draw_op_console_testimony_c(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Operation C Terminal: Testimony / Świadectwo — Dwie prawdy (34x42 px)
	var casing_rect := Rect2(-17.0, -21.0, 34.0, 42.0)
	var screen_rect := Rect2(-13.0, -17.0, 26.0, 22.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 3.6)
	var cinnabar_col := Color("c65d58" if p_is_activated else "5a2b28")
	
	# Angled modernist console casing
	ci.draw_rect(casing_rect, Color("180f10"))
	ci.draw_rect(casing_rect, Color("4d2a2d"), false, 1.4)
	
	# CRT Screen with distributed 4-witness mesh
	ci.draw_rect(screen_rect, Color("12090b"))
	ci.draw_rect(screen_rect, cinnabar_col * 0.7, false, 1.0)
	
	# 4 distributed observation nodes (Marta, Jakub, Szymon, Public Grid)
	var node_marta := Vector2(-7.0, -11.0)
	var node_jakub := Vector2(7.0, -11.0)
	var node_szymon := Vector2(-7.0, -1.0)
	var node_grid := Vector2(7.0, -1.0)
	
	# Interconnecting poly-mesh lines
	ci.draw_line(node_marta, node_jakub, Color(0.78, 0.36, 0.35, 0.85 if p_is_activated else 0.35), 1.0)
	ci.draw_line(node_marta, node_szymon, Color(0.78, 0.36, 0.35, 0.85 if p_is_activated else 0.35), 1.0)
	ci.draw_line(node_jakub, node_grid, Color(0.78, 0.36, 0.35, 0.85 if p_is_activated else 0.35), 1.0)
	ci.draw_line(node_szymon, node_grid, Color(0.78, 0.36, 0.35, 0.85 if p_is_activated else 0.35), 1.0)
	ci.draw_line(node_marta, node_grid, Color(0.46, 0.78, 0.76, 0.75 if p_is_activated else 0.25), 0.8)
	ci.draw_line(node_szymon, node_jakub, Color(0.83, 0.60, 0.38, 0.75 if p_is_activated else 0.25), 0.8)
	
	# Node dots
	ci.draw_circle(node_marta, 1.6, Color("d39a62" if p_is_activated else "5a4128"))
	ci.draw_circle(node_jakub, 1.6, Color("75c7c3" if p_is_activated else "355856"))
	ci.draw_circle(node_szymon, 1.6, Color("e2b060" if p_is_activated else "5a4525"))
	ci.draw_circle(node_grid, 1.6, Color("c65d58" if p_is_activated else "5a2b28"))
	
	# Dispersal antenna masts at top
	ci.draw_line(Vector2(-8.0, -21.0), Vector2(-12.0, -28.0), Color("4d2a2d"), 1.2)
	ci.draw_line(Vector2(8.0, -21.0), Vector2(12.0, -28.0), Color("4d2a2d"), 1.2)
	ci.draw_circle(Vector2(-12.0, -28.0), 1.4, Color("c65d58" if p_is_activated else "3a1e20"))
	ci.draw_circle(Vector2(12.0, -28.0), 1.4, Color("c65d58" if p_is_activated else "3a1e20"))
	
	# Control desk lower shelf with polyphonic push array & badge C
	ci.draw_rect(Rect2(-14.0, 7.0, 28.0, 10.0), Color("261719"))
	ci.draw_rect(Rect2(-14.0, 7.0, 28.0, 10.0), Color("5e3438"), false, 1.0)
	for b in range(3):
		var bx: float = -8.0 + float(b) * 8.0
		ci.draw_circle(Vector2(bx, 12.0), 1.8, Color("c65d58" if p_is_activated else "3d2023"))
	
	if p_is_activated:
		ci.draw_rect(casing_rect, Color(0.78, 0.36, 0.35, 0.45 + pulse * 0.30), false, 1.6)
		ci.draw_circle(Vector2(0.0, -6.0), 16.0, Color(0.78, 0.36, 0.35, 0.12 + pulse * 0.12))


static func draw_op_continuity_topography_display(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Continuity Topography & Witness Node Reach Display (52x40 px)
	var housing_rect := Rect2(-26.0, -20.0, 52.0, 40.0)
	var screen_rect := Rect2(-22.0, -16.0, 44.0, 28.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 2.8)
	
	# Heavy steel console panel
	ci.draw_rect(housing_rect, Color("0c141a"))
	ci.draw_rect(housing_rect, Color("283d4c"), false, 1.4)
	
	# Topography screen
	ci.draw_rect(screen_rect, Color("060d12"))
	ci.draw_rect(screen_rect, Color("3b5668"), false, 1.0)
	
	# Rówień district grid lines
	for gx in range(4):
		var xpos: float = -16.0 + float(gx) * 11.0
		ci.draw_line(Vector2(xpos, -14.0), Vector2(xpos, 10.0), Color(0.18, 0.28, 0.36, 0.35), 0.8)
	for gy in range(3):
		var ypos: float = -10.0 + float(gy) * 8.0
		ci.draw_line(Vector2(-20.0, ypos), Vector2(20.0, ypos), Color(0.18, 0.28, 0.36, 0.35), 0.8)
	
	# Key 5 district nodes: IKP (-14, -8), Flat14 (-4, -6), Point6 (6, -7), Line4 (-10, 4), Substructure (8, 5)
	var p_ikp := Vector2(-14.0, -8.0)
	var p_flat := Vector2(-4.0, -6.0)
	var p_point6 := Vector2(6.0, -7.0)
	var p_line4 := Vector2(-10.0, 4.0)
	var p_subs := Vector2(8.0, 5.0)
	
	# Network transit tracks
	ci.draw_line(p_ikp, p_flat, Color("5da398" if p_is_activated else "24403d"), 1.0)
	ci.draw_line(p_flat, p_point6, Color("d39a62" if p_is_activated else "4d3723"), 1.0)
	ci.draw_line(p_point6, p_subs, Color("c65d58" if p_is_activated else "45201e"), 1.0)
	ci.draw_line(p_line4, p_subs, Color("5da398" if p_is_activated else "24403d"), 1.0)
	ci.draw_line(p_ikp, p_line4, Color("d39a62" if p_is_activated else "4d3723"), 1.0)
	
	# Node points
	ci.draw_circle(p_ikp, 1.8, Color("5da398"))
	ci.draw_circle(p_flat, 1.8, Color("d39a62"))
	ci.draw_circle(p_point6, 1.8, Color("c65d58"))
	ci.draw_circle(p_line4, 1.8, Color("5da398"))
	ci.draw_circle(p_subs, 1.8, Color("c65d58"))
	
	# Lower status indicator bar (reach balance without points/judgment)
	ci.draw_rect(Rect2(-20.0, 14.0, 40.0, 4.0), Color("121f29"))
	ci.draw_rect(Rect2(-20.0, 14.0, 13.0, 4.0), Color("5da398" if p_is_activated else "24403d"))
	ci.draw_rect(Rect2(-6.0, 14.0, 13.0, 4.0), Color("d39a62" if p_is_activated else "4d3723"))
	ci.draw_rect(Rect2(8.0, 14.0, 12.0, 4.0), Color("c65d58" if p_is_activated else "45201e"))
	
	if p_is_activated:
		ci.draw_rect(housing_rect, Color(0.36, 0.64, 0.60, 0.35 + pulse * 0.25), false, 1.2)


static func draw_station_41_exit(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Modernist Triple-Lock Resolution Portal leading to Scenes 42A..C (50x64 px)
	var portal_rect := Rect2(-25.0, -32.0, 50.0, 64.0)
	var door_rect := Rect2(-21.0, -28.0, 42.0, 56.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 2.8)
	
	# Heavy structural frame
	ci.draw_rect(portal_rect, Color("0b1318"))
	ci.draw_rect(portal_rect, Color("2d4657"), false, 2.2)
	
	# Sliding resolution gate leaf
	ci.draw_rect(door_rect, Color("142028"))
	ci.draw_rect(door_rect, Color("3b5a6e"), false, 1.4)
	
	# Triple vertical resolution light conduits (Cyan A, Amber B, Cinnabar C)
	var beam_a := Color(0.36, 0.64, 0.60, 0.90 if p_is_activated else 0.30)
	var beam_b := Color(0.83, 0.60, 0.38, 0.90 if p_is_activated else 0.30)
	var beam_c := Color(0.78, 0.36, 0.35, 0.90 if p_is_activated else 0.30)
	
	ci.draw_line(Vector2(-8.0, -25.0), Vector2(-8.0, 25.0), beam_a, 1.8)
	ci.draw_line(Vector2(0.0, -25.0), Vector2(0.0, 25.0), beam_b, 1.8)
	ci.draw_line(Vector2(8.0, -25.0), Vector2(8.0, 25.0), beam_c, 1.8)
	
	# Header casing
	ci.draw_rect(Rect2(-21.0, -30.0, 42.0, 4.0), Color("1a2933"))
	ci.draw_rect(Rect2(-21.0, -30.0, 42.0, 4.0), Color("5da398" if p_is_activated else "3b5a6e"), false, 1.0)
	
	if p_is_activated:
		ci.draw_rect(portal_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.60 + pulse * 0.35), false, 2.4)
		ci.draw_rect(Rect2(-20.0, -27.0, 40.0, 54.0), Color("061219"))
		ci.draw_line(Vector2(-25.0, 32.0), Vector2(25.0, 32.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.95), 2.4)



## PKG-0200 slice2 — F-0184-010 MRP renderer extraction (PropType 0..66,197..202).
## Same stateless contract as the PKG-0199 pilot, extended by two read-only
## visual floats: shadow_progress -> p_shadow (export anim), _resonance_flash
## -> p_flash (flash envelope). Bodies are verbatim moves from
## MemoryResonancePoint (PKG-0199 baseline) with mechanical renames only.

static func draw_photograph(ci: CanvasItem, p_is_activated: bool) -> void:
	# Framed photograph on desk: 24x18 px
	# Asymmetrical composition per FULL_STORY 01: Lena & Jakub on left, right third empty
	var frame_rect := Rect2(-12.0, -10.0, 24.0, 20.0)
	var photo_rect := Rect2(-10.0, -8.0, 20.0, 16.0)
	
	# Wood/dark steel frame
	ci.draw_rect(frame_rect, Color("20262b"))
	ci.draw_rect(frame_rect, COLOR_DARK_STEEL, false, 1.0)
	
	# Photographic paper background (aged monochrome silver gelatin)
	var photo_bg := Color("4b585e") if not p_is_activated else Color("5a6970")
	ci.draw_rect(photo_rect, photo_bg)
	
	# Silhouettes of teenage Lena & Jakub on left 2/3
	# Jakub (slightly taller, 13 years earlier / age 20)
	ci.draw_rect(Rect2(-8.0, -3.0, 5.0, 9.0), Color("182126"))
	ci.draw_circle(Vector2(-5.5, -5.0), 2.2, Color("182126"))
	
	# Lena (left side)
	ci.draw_rect(Rect2(-3.0, -1.0, 4.0, 7.0), Color("243038"))
	ci.draw_circle(Vector2(-1.0, -3.5), 1.8, Color("243038"))
	
	# Empty right third (negative space #composition-negative-space per canon)
	ci.draw_line(Vector2(2.0, -8.0), Vector2(2.0, 8.0), Color(0.1, 0.15, 0.18, 0.25), 1.0)
	
	# Subtle glass reflection
	ci.draw_line(Vector2(-9.0, -7.0), Vector2(3.0, 6.0), Color(1.0, 1.0, 1.0, 0.18), 1.0)
	
	# Support stand behind frame
	ci.draw_line(Vector2(0.0, 10.0), Vector2(4.0, 13.0), Color("182126"), 2.0)


static func draw_circuit_breaker(ci: CanvasItem, p_is_activated: bool) -> void:
	# Industrial DIN rail mounted toggle switch: 18x26 px
	var base_rect := Rect2(-9.0, -13.0, 18.0, 26.0)
	
	# Backplate
	ci.draw_rect(base_rect, COLOR_DARK_STEEL)
	ci.draw_rect(base_rect, COLOR_INFRASTRUCTURE, false, 1.0)
	
	# Screw fixings
	ci.draw_circle(Vector2(0.0, -10.0), 1.2, COLOR_INFRASTRUCTURE)
	ci.draw_circle(Vector2(0.0, 10.0), 1.2, COLOR_INFRASTRUCTURE)
	
	# Switch slot
	ci.draw_rect(Rect2(-4.0, -6.0, 8.0, 12.0), Color("12191e"))
	
	# Toggle lever
	var lever_y := -4.0 if p_is_activated else 4.0
	var lever_col := COLOR_CYAN if p_is_activated else Color("788791")
	ci.draw_rect(Rect2(-3.0, lever_y - 2.0, 6.0, 4.0), lever_col)
	ci.draw_line(Vector2(0.0, lever_y), Vector2(0.0, 0.0), COLOR_INFRASTRUCTURE, 1.5)
	
	# Status Indicator Diode
	var diode_col := COLOR_CYAN if p_is_activated else Color(0.4, 0.15, 0.15, 0.7)
	ci.draw_circle(Vector2(0.0, -2.0), 2.0, diode_col)


static func draw_vacuum_gauge(ci: CanvasItem, p_is_activated: bool) -> void:
	# Circular vacuum manometer: radius 12 px
	var center := Vector2.ZERO
	var radius := 11.0
	
	# Housing
	ci.draw_circle(center, radius + 2.0, COLOR_DARK_STEEL)
	ci.draw_circle(center, radius + 2.0, COLOR_INFRASTRUCTURE, false, 1.0)
	
	# Gauge face
	ci.draw_circle(center, radius, Color("141b20"))
	
	# Calibration tick marks
	for i in range(7):
		var angle := -PI * 0.75 + float(i) * (PI * 1.5 / 6.0)
		var p1 := center + Vector2(cos(angle), sin(angle)) * (radius - 3.0)
		var p2 := center + Vector2(cos(angle), sin(angle)) * (radius - 1.0)
		var tick_col := COLOR_CYAN if i >= 4 else COLOR_INFRASTRUCTURE
		ci.draw_line(p1, p2, tick_col, 1.0)
	
	# Needle
	var needle_angle := PI * 0.45 if p_is_activated else -PI * 0.65
	var needle_end := center + Vector2(cos(needle_angle), sin(needle_angle)) * (radius - 2.5)
	var needle_col := COLOR_AMBER if p_is_activated else COLOR_INFRASTRUCTURE
	ci.draw_line(center, needle_end, needle_col, 1.5)
	ci.draw_circle(center, 2.0, COLOR_DARK_STEEL)


static func draw_chamber_console(ci: CanvasItem, p_is_activated: bool) -> void:
	# Terminal console with cathode readout & keylock: 26x32 px
	var rect := Rect2(-13.0, -16.0, 26.0, 32.0)
	ci.draw_rect(rect, COLOR_DARK_STEEL)
	ci.draw_rect(rect, COLOR_INFRASTRUCTURE, false, 1.0)
	
	# Screen bezel & CRT phosphor display
	var screen_rect := Rect2(-10.0, -13.0, 20.0, 14.0)
	ci.draw_rect(screen_rect, Color("0e161a"))
	ci.draw_rect(screen_rect, COLOR_INFRASTRUCTURE * 0.6, false, 1.0)
	
	# Phosphor text lines on screen
	var scr_col := COLOR_CYAN if p_is_activated else COLOR_AMBER
	ci.draw_line(Vector2(-8.0, -10.0), Vector2(4.0, -10.0), scr_col * 0.9, 1.0)
	ci.draw_line(Vector2(-8.0, -7.0), Vector2(7.0, -7.0), scr_col * 0.7, 1.0)
	ci.draw_line(Vector2(-8.0, -4.0), Vector2(-1.0, -4.0), scr_col * 0.8, 1.0)
	
	# Keyway & Status Lamps
	ci.draw_rect(Rect2(-8.0, 5.0, 16.0, 6.0), Color("12191e"))
	var led1 := COLOR_CYAN if p_is_activated else Color(0.2, 0.4, 0.4)
	var led2 := COLOR_AMBER if p_is_activated else Color(0.4, 0.3, 0.1)
	ci.draw_circle(Vector2(-4.0, 8.0), 1.5, led1)
	ci.draw_circle(Vector2(4.0, 8.0), 1.5, led2)


static func draw_document_clipboard(ci: CanvasItem, p_is_activated: bool) -> void:
	# Checklist clipboard: 16x22 px
	var rect := Rect2(-8.0, -11.0, 16.0, 22.0)
	ci.draw_rect(rect, Color("423223"))
	
	# Paper sheets
	var paper_rect := Rect2(-7.0, -9.0, 14.0, 19.0)
	ci.draw_rect(paper_rect, Color("c2ba9b"))
	
	# Metal spring clamp at top
	ci.draw_rect(Rect2(-4.0, -12.0, 8.0, 3.0), COLOR_INFRASTRUCTURE)
	
	# Checklist lines
	var line_col := Color("4b4637")
	for i in range(4):
		var y := -6.0 + float(i) * 4.0
		ci.draw_rect(Rect2(-5.0, y - 1.0, 2.0, 2.0), COLOR_CYAN if (p_is_activated or i < 2) else line_col)
		ci.draw_line(Vector2(-1.0, y), Vector2(5.0, y), line_col, 1.0)


static func draw_door_card_reader(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Institutional wall-mounted card terminal: 22x32 px
	var base_rect := Rect2(-11.0, -16.0, 22.0, 32.0)
	ci.draw_rect(base_rect, COLOR_DARK_STEEL)
	ci.draw_rect(base_rect, COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	
	# Card swipe slot on right
	ci.draw_rect(Rect2(7.0, -14.0, 2.0, 28.0), Color("0d1317"))
	
	# Backlit LCD screen (16x14 px)
	var screen_rect := Rect2(-9.0, -14.0, 15.0, 16.0)
	var screen_bg := Color("12221b") if p_is_activated else Color("0e161a")
	ci.draw_rect(screen_rect, screen_bg)
	ci.draw_rect(screen_rect, COLOR_INFRASTRUCTURE * 0.5, false, 1.0)
	
	# Mini badge photo (Left side of LCD): Different photo/silhouette of Lena
	# Head and torso with altered neckline / haircut reflecting alternate timeline
	var photo_rect := Rect2(-8.0, -13.0, 6.0, 7.0)
	ci.draw_rect(photo_rect, Color("2d3b3f"))
	# Alternate Lena portrait silhouette: facing slightly forward, tied hair
	ci.draw_circle(Vector2(-5.0, -10.5), 1.6, Color("141c22"))
	ci.draw_rect(Rect2(-7.0, -8.5, 4.0, 2.5), Color("141c22"))
	
	# Data readout lines on LCD: "WOLSKA, L." and "URLOP PRZERWANY"
	if p_is_activated or p_in_range:
		var p := sin(p_pulse * 3.0) * 0.3 + 0.7
		# WOLSKA, L. // ID: 884-A
		ci.draw_line(Vector2(-1.0, -12.0), Vector2(4.0, -12.0), COLOR_INFRASTRUCTURE * 0.9, 1.0)
		ci.draw_line(Vector2(-1.0, -9.0), Vector2(3.0, -9.0), COLOR_CYAN * 0.8, 1.0)
		
		# "URLOP PRZERWANY" (Pulsing cinnabar / amber alert banner)
		var alert_col := Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, p)
		ci.draw_rect(Rect2(-8.0, -4.0, 13.0, 5.0), Color(0.2, 0.08, 0.08, 0.8))
		ci.draw_line(Vector2(-7.0, -2.0), Vector2(4.0, -2.0), alert_col, 1.2)
	else:
		# Standby cursor
		ci.draw_line(Vector2(-8.0, -2.0), Vector2(-4.0, -2.0), COLOR_INFRASTRUCTURE * 0.4, 1.0)
	
	# Status Indicator Diode (Green/Cyan authorized, Amber/Cinnabar alert)
	var led_col := COLOR_CYAN if p_is_activated else (COLOR_AMBER if p_in_range else Color("4d3826"))
	ci.draw_circle(Vector2(-4.0, 8.0), 1.8, led_col)
	ci.draw_circle(Vector2(4.0, 8.0), 1.5, COLOR_INFRASTRUCTURE * 0.6)


static func draw_twin_cups(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Operator desk surface coaster: 30x6 px
	ci.draw_rect(Rect2(-15.0, 4.0, 30.0, 3.0), Color("1e2930"))
	ci.draw_rect(Rect2(-15.0, 4.0, 30.0, 3.0), COLOR_INFRASTRUCTURE * 0.4, false, 1.0)
	
	# ── Cup 1 (Left): Lena's original grey ceramic mug from Scene 01 ──
	# Body: 7x9 px at x = -8
	var cup1_rect := Rect2(-11.0, -4.0, 7.0, 8.0)
	ci.draw_rect(cup1_rect, Color("c4c0b4")) # Standard beige/grey ceramic
	ci.draw_rect(cup1_rect, Color("8a877d"), false, 1.0)
	# Handle
	ci.draw_rect(Rect2(-13.0, -2.0, 2.0, 5.0), Color("8a877d"))
	# Empty interior lip
	ci.draw_line(Vector2(-11.0, -4.0), Vector2(-4.0, -4.0), Color("626058"), 1.0)
	
	# ── Cup 2 (Right): Second mug (The material anomaly - proof of an unrecorded colleague) ──
	# Body: 8x10 px at x = 5 (slightly taller, enamel dark sage with coffee residue)
	var cup2_rect := Rect2(3.0, -5.0, 8.0, 9.0)
	ci.draw_rect(cup2_rect, Color("3d554a")) # Institutional dark sage enamel
	ci.draw_rect(cup2_rect, Color("202c26"), false, 1.0)
	# Handle on right
	ci.draw_rect(Rect2(11.0, -3.0, 2.0, 5.0), Color("202c26"))
	# Rim with dark coffee ring / residue
	ci.draw_line(Vector2(3.0, -5.0), Vector2(11.0, -5.0), Color("1e140d"), 1.2)
	# Dark coffee stain running down side
	ci.draw_line(Vector2(8.0, -4.0), Vector2(8.0, 0.0), Color("1e140d", 0.7), 1.0)
	
	# Faint steam trace above cup 2 when inspected or active (fresh coffee)
	if p_is_activated or p_in_range:
		var p := sin(p_pulse * 2.0) * 0.5 + 0.5
		var steam_alpha := 0.25 + p * 0.25
		ci.draw_line(Vector2(7.0, -7.0), Vector2(8.0, -11.0), Color(1.0, 1.0, 1.0, steam_alpha), 1.0)
		ci.draw_line(Vector2(9.0, -6.0), Vector2(10.0, -10.0), Color(1.0, 1.0, 1.0, steam_alpha * 0.7), 1.0)


static func draw_desk_telephone(ci: CanvasItem, p_pulse: float) -> void:
	# Heavy 90s institutional office desk phone console: 24x18 px
	var phone_rect := Rect2(-12.0, -8.0, 24.0, 16.0)
	ci.draw_rect(phone_rect, Color("222d35")) # Dark industrial plastic
	ci.draw_rect(phone_rect, COLOR_INFRASTRUCTURE * 0.6, false, 1.0)
	
	# Cradle and handset on top/left
	var handset_rect := Rect2(-14.0, -10.0, 10.0, 20.0)
	ci.draw_rect(handset_rect, Color("172026"))
	ci.draw_rect(handset_rect, COLOR_DARK_STEEL, false, 1.0)
	# Handset grip taper
	ci.draw_rect(Rect2(-12.0, -5.0, 6.0, 10.0), Color("10161a"))
	
	# Keypad button matrix on right: 3x3 buttons
	for row in range(3):
		for col in range(3):
			var bx := -1.0 + float(col) * 3.5
			var by := -2.0 + float(row) * 3.5
			ci.draw_rect(Rect2(bx, by, 2.5, 2.5), Color("3d4e58"))
	
	# LCD status screen on top right
	var screen_rect := Rect2(-2.0, -7.0, 12.0, 4.0)
	ci.draw_rect(screen_rect, Color("0e161a"))
	ci.draw_rect(screen_rect, COLOR_INFRASTRUCTURE * 0.4, false, 0.8)
	
	# Text readout on LCD: "14" unread messages
	ci.draw_line(Vector2(-1.0, -5.0), Vector2(8.0, -5.0), COLOR_AMBER * 0.85, 1.0)
	
	# ── Message Waiting Light (Blinking Amber LED) ──
	var blink := sin(p_pulse * 4.0) * 0.5 + 0.5
	var led_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.3 + blink * 0.7)
	ci.draw_circle(Vector2(9.0, -1.0), 1.8, led_col)
	ci.draw_circle(Vector2(9.0, -1.0), 3.5, Color(led_col.r, led_col.g, led_col.b, blink * 0.3))
	
	# Coiled telephone cable at bottom
	for c in range(4):
		var cx := -11.0 + float(c) * 2.5
		var cy := 8.0 + (1.0 if c % 2 == 0 else -1.0) * 1.5
		ci.draw_circle(Vector2(cx, cy), 1.0, Color("141c22"))


static func draw_duty_roster(ci: CanvasItem) -> void:
	# Wall acrylic duty notice board: 22x28 px
	var board_rect := Rect2(-11.0, -14.0, 22.0, 28.0)
	ci.draw_rect(board_rect, Color("1e2a32"))
	ci.draw_rect(board_rect, COLOR_INFRASTRUCTURE * 0.8, false, 1.0)
	
	# Corner mounting standoffs
	ci.draw_circle(Vector2(-9.0, -12.0), 1.0, COLOR_INFRASTRUCTURE)
	ci.draw_circle(Vector2(9.0, -12.0), 1.0, COLOR_INFRASTRUCTURE)
	ci.draw_circle(Vector2(-9.0, 12.0), 1.0, COLOR_INFRASTRUCTURE)
	ci.draw_circle(Vector2(9.0, 12.0), 1.0, COLOR_INFRASTRUCTURE)
	
	# Header banner: IKP DYŻURY NOCNE
	ci.draw_rect(Rect2(-9.0, -11.0, 18.0, 4.0), Color("293a44"))
	ci.draw_line(Vector2(-7.0, -9.0), Vector2(7.0, -9.0), COLOR_INFRASTRUCTURE, 1.0)
	
	# Roster schedule entries (grid lines with strikethroughs / missing staff)
	for i in range(4):
		var y := -4.0 + float(i) * 4.5
		var line_c := COLOR_AMBER if i == 0 else COLOR_INFRASTRUCTURE * 0.7
		ci.draw_line(Vector2(-8.0, y), Vector2(3.0, y), line_c, 1.0)
		# Red/cinnabar strikethrough or absence mark for missing night staff
		if i > 0:
			ci.draw_line(Vector2(4.0, y - 1.0), Vector2(8.0, y + 1.0), COLOR_CORRECTION * 0.8, 1.0)
			ci.draw_line(Vector2(4.0, y + 1.0), Vector2(8.0, y - 1.0), COLOR_CORRECTION * 0.8, 1.0)


static func draw_security_monitor(ci: CanvasItem, p_pulse: float) -> void:
	# CRT CCTV monitor on guard desk: 26x20 px
	var mon_rect := Rect2(-13.0, -10.0, 26.0, 20.0)
	ci.draw_rect(mon_rect, Color("1a242b"))
	ci.draw_rect(mon_rect, COLOR_DARK_STEEL, false, 1.0)
	
	# Bezel & screen inset
	var scr_rect := Rect2(-11.0, -8.0, 22.0, 14.0)
	ci.draw_rect(scr_rect, Color("0b1318"))
	
	# Green/graphite CCTV raster lines
	var p := sin(p_pulse * 3.0) * 0.5 + 0.5
	for row in range(3):
		var y := -6.0 + float(row) * 4.0
		ci.draw_line(Vector2(-9.0, y), Vector2(9.0, y), Color(0.20, 0.45, 0.35, 0.4 + p * 0.2), 1.0)
	
	# Silhouette of gate on CCTV screen
	ci.draw_line(Vector2(2.0, -5.0), Vector2(2.0, 4.0), Color(0.25, 0.55, 0.42, 0.7), 1.5)
	ci.draw_line(Vector2(-3.0, 1.0), Vector2(2.0, -1.0), Color(0.25, 0.55, 0.42, 0.7), 1.0)
	
	# Camera status overlay text: "CAM 04 [REC]"
	ci.draw_line(Vector2(-9.0, -7.0), Vector2(-4.0, -7.0), COLOR_CORRECTION * 0.8, 1.0)
	
	# Green power LED
	ci.draw_circle(Vector2(8.0, 8.0), 1.0, Color("45c68a"))


static func draw_ucp_notice(ci: CanvasItem) -> void:
	# Official UCP institutional advisory bulletin on wall: 24x30 px
	var board_rect := Rect2(-12.0, -15.0, 24.0, 30.0)
	ci.draw_rect(board_rect, Color("202d36"))
	ci.draw_rect(board_rect, COLOR_INFRASTRUCTURE * 0.75, false, 1.0)
	
	# Blue/grey header: "UCP // PROTOKÓŁ ZGŁASZANIA"
	ci.draw_rect(Rect2(-10.0, -13.0, 20.0, 5.0), Color("2f4552"))
	ci.draw_line(Vector2(-8.0, -10.5), Vector2(8.0, -10.5), COLOR_INFRASTRUCTURE, 1.0)
	
	# Institutional bulletin text lines
	for i in range(5):
		var y := -5.0 + float(i) * 3.8
		var col := COLOR_INFRASTRUCTURE * 0.65
		if i == 0:
			col = COLOR_AMBER * 0.8
		elif i == 4:
			col = COLOR_CORRECTION * 0.7
		ci.draw_line(Vector2(-9.0, y), Vector2(9.0, y), col, 1.0)
	
	# Official seal / stamp mark on bottom right
	ci.draw_rect(Rect2(3.0, 6.0, 6.0, 6.0), Color("8f3833", 0.5))


static func draw_guard_interaction(ci: CanvasItem, p_is_activated: bool) -> void:
	# Desk counter intercom / call button
	var box_rect := Rect2(-8.0, -6.0, 16.0, 12.0)
	ci.draw_rect(box_rect, COLOR_DARK_STEEL)
	ci.draw_rect(box_rect, COLOR_INFRASTRUCTURE * 0.6, false, 1.0)
	
	# Intercom speaker grill perforations
	for i in range(3):
		var y := -3.0 + float(i) * 3.0
		ci.draw_line(Vector2(-5.0, y), Vector2(1.0, y), Color("121a20"), 1.0)
	
	# Call / alert indicator button
	var btn_col := COLOR_CYAN if p_is_activated else COLOR_AMBER
	ci.draw_circle(Vector2(4.0, 0.0), 2.2, btn_col)


static func draw_anachronistic_billboard(ci: CanvasItem, p_is_activated: bool) -> void:
	# Anachronistic advertising / institutional billboard (38x26 px)
	var board_rect := Rect2(-19.0, -18.0, 38.0, 26.0)
	
	# Steel support pillars extending into pavement
	ci.draw_line(Vector2(-14.0, 8.0), Vector2(-14.0, 24.0), COLOR_DARK_STEEL, 2.0)
	ci.draw_line(Vector2(14.0, 8.0), Vector2(14.0, 24.0), COLOR_DARK_STEEL, 2.0)
	
	# Billboard panel & enamel frame
	ci.draw_rect(board_rect, Color("1a262e"))
	ci.draw_rect(board_rect, COLOR_INFRASTRUCTURE * 0.8, false, 1.5)
	
	# Header banner (UCP / Era-shifted enterprise)
	ci.draw_rect(Rect2(-17.0, -16.0, 34.0, 6.0), Color("283d4a"))
	ci.draw_line(Vector2(-15.0, -13.0), Vector2(15.0, -13.0), COLOR_INFRASTRUCTURE, 1.0)
	
	# Slogan typography lines ("PAMIĘĆ WSPÓLNA TO SPOKÓJ")
	var line_col := COLOR_AMBER if p_is_activated else Color("c0ccc6")
	ci.draw_line(Vector2(-15.0, -6.0), Vector2(12.0, -6.0), line_col, 1.2)
	ci.draw_line(Vector2(-15.0, -2.0), Vector2(8.0, -2.0), line_col * 0.85, 1.0)
	ci.draw_line(Vector2(-15.0, 2.0), Vector2(14.0, 2.0), COLOR_INFRASTRUCTURE * 0.6, 1.0)
	
	# Era timestamp emblem in corner ("1978")
	ci.draw_rect(Rect2(7.0, 1.0, 9.0, 4.0), Color("344b59"))
	ci.draw_line(Vector2(8.0, 3.0), Vector2(15.0, 3.0), COLOR_CYAN * 0.8, 1.0)
	
	# Overhead floodlight bracket
	ci.draw_line(Vector2(0.0, -18.0), Vector2(0.0, -23.0), COLOR_DARK_STEEL, 1.5)
	var lamp_col := Color("f4eed6") if p_is_activated else Color("3d4b52")
	ci.draw_circle(Vector2(0.0, -23.0), 2.0, lamp_col)


static func draw_missing_floor_facade(ci: CanvasItem, p_is_activated: bool) -> void:
	# Architectural elevation inspection marker (24x30 px)
	var plaque_rect := Rect2(-12.0, -15.0, 24.0, 30.0)
	ci.draw_rect(plaque_rect, Color("18232a"))
	ci.draw_rect(plaque_rect, COLOR_DARK_STEEL, false, 1.2)
	
	# Building elevation outline showing missing 3rd floor
	# 5 Floors diagram: Floor 1 (y=9..5), Floor 2 (y=4..0), Floor 3 VOID (-1..-5), Floor 4 (-6..-10), Floor 5 (-11..-15)
	# Floor 1 & 2 (Lower mass)
	ci.draw_rect(Rect2(-8.0, 0.0, 16.0, 10.0), Color("243540"))
	ci.draw_rect(Rect2(-8.0, 0.0, 16.0, 10.0), COLOR_INFRASTRUCTURE * 0.5, false, 1.0)
	# Floor 4 & 5 (Upper mass)
	ci.draw_rect(Rect2(-8.0, -14.0, 16.0, 9.0), Color("243540"))
	ci.draw_rect(Rect2(-8.0, -14.0, 16.0, 9.0), COLOR_INFRASTRUCTURE * 0.5, false, 1.0)
	
	# Floor 3 Void gap: Only 2 slender structural columns spanning the gap
	ci.draw_line(Vector2(-6.0, -5.0), Vector2(-6.0, 0.0), COLOR_INFRASTRUCTURE * 0.9, 1.2)
	ci.draw_line(Vector2(6.0, -5.0), Vector2(6.0, 0.0), COLOR_INFRASTRUCTURE * 0.9, 1.2)
	
	# Oxide cinnabar annotation indicator pointing to the void
	var void_col := COLOR_CORRECTION if p_is_activated else Color("7a3e3b")
	ci.draw_line(Vector2(-3.0, -2.5), Vector2(3.0, -2.5), void_col, 1.2)
	ci.draw_circle(Vector2(0.0, -2.5), 1.2, void_col)


static func draw_crosswalk_signal(ci: CanvasItem, p_is_activated: bool) -> void:
	# Pedestrian traffic beacon & acoustic signal pole (x=0, y=-30..20)
	# Steel pole
	ci.draw_line(Vector2(0.0, -32.0), Vector2(0.0, 24.0), COLOR_DARK_STEEL, 3.0)
	ci.draw_line(Vector2(0.0, -32.0), Vector2(0.0, 24.0), COLOR_INFRASTRUCTURE * 0.6, 1.0)
	
	# Top signal housing (14x24 px, y=-32..-8)
	var signal_box := Rect2(-7.0, -32.0, 14.0, 24.0)
	ci.draw_rect(signal_box, Color("141d24"))
	ci.draw_rect(signal_box, COLOR_DARK_STEEL, false, 1.2)
	
	# Sun visors over lamps
	ci.draw_line(Vector2(-6.0, -32.0), Vector2(6.0, -32.0), Color("0d1419"), 1.8)
	ci.draw_line(Vector2(-6.0, -20.0), Vector2(6.0, -20.0), Color("0d1419"), 1.8)
	
	# Upper Signal: Red pedestrian stop silhouette (lit when not active)
	var red_col := COLOR_CORRECTION if not p_is_activated else Color("331515")
	ci.draw_circle(Vector2(0.0, -26.0), 3.5, red_col)
	if not p_is_activated:
		ci.draw_circle(Vector2(0.0, -26.0), 6.0, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.25))
	
	# Lower Signal: Green / Cyan walking figure (lit when activated)
	var green_col := COLOR_CYAN if p_is_activated else Color("142b29")
	ci.draw_circle(Vector2(0.0, -14.0), 3.5, green_col)
	if p_is_activated:
		ci.draw_circle(Vector2(0.0, -14.0), 7.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35))
	
	# Lower Pedestrian Push-Button Box (y=0..16)
	var btn_box := Rect2(-6.0, 0.0, 12.0, 16.0)
	ci.draw_rect(btn_box, Color("2c3b44"))
	ci.draw_rect(btn_box, COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	
	# Tactile call button
	var btn_col := COLOR_CYAN if p_is_activated else COLOR_AMBER
	ci.draw_circle(Vector2(0.0, 6.0), 2.8, btn_col)
	if p_is_activated:
		ci.draw_circle(Vector2(0.0, 6.0), 5.5, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.4))
	
	# Acoustic speaker perforations
	for i in range(2):
		var sy := 11.0 + float(i) * 2.5
		ci.draw_circle(Vector2(-2.0, sy), 0.8, Color("12191f"))
		ci.draw_circle(Vector2(2.0, sy), 0.8, Color("12191f"))


static func draw_transit_shelter(ci: CanvasItem, p_is_activated: bool) -> void:
	# Timetable board & route schematic on shelter wall (28x36 px)
	var board_rect := Rect2(-14.0, -18.0, 28.0, 36.0)
	ci.draw_rect(board_rect, Color("1a2730"))
	ci.draw_rect(board_rect, COLOR_INFRASTRUCTURE * 0.7, false, 1.2)
	
	# Header strip: "LINIA 4 // ROZKŁAD"
	ci.draw_rect(Rect2(-12.0, -16.0, 24.0, 6.0), Color("283f4f"))
	ci.draw_line(Vector2(-10.0, -13.0), Vector2(10.0, -13.0), COLOR_INFRASTRUCTURE, 1.0)
	
	# Timetable rows
	for i in range(4):
		var y := -7.0 + float(i) * 4.0
		ci.draw_line(Vector2(-10.0, y), Vector2(6.0, y), COLOR_INFRASTRUCTURE * 0.5, 1.0)
	
	# Red strike-through warning tape: "TRASA ZAWIESZONA / AUTOBUS ZASTĘPCZY"
	var tape_pts := PackedVector2Array([
		Vector2(-13.0, 3.0),
		Vector2(13.0, 1.0),
		Vector2(13.0, 7.0),
		Vector2(-13.0, 9.0),
	])
	ci.draw_polygon(tape_pts, [Color("8f3833", 0.85)])
	ci.draw_line(Vector2(-11.0, 6.0), Vector2(11.0, 4.0), Color("f0e6e6"), 1.0)
	
	# Route terminus marker dot
	ci.draw_circle(Vector2(9.0, 13.0), 1.8, COLOR_CYAN if p_is_activated else COLOR_AMBER)


static func draw_bus_speaker(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Ceiling institutional intercom / speaker housing (24x12 px)
	var housing_rect := Rect2(-12.0, -6.0, 24.0, 12.0)
	ci.draw_rect(housing_rect, COLOR_DARK_STEEL)
	ci.draw_rect(housing_rect, COLOR_INFRASTRUCTURE * 0.8, false, 1.0)
	
	# Perforated circular grille
	ci.draw_circle(Vector2.ZERO, 4.2, COLOR_BACKGROUND)
	ci.draw_circle(Vector2.ZERO, 4.2, COLOR_INFRASTRUCTURE * 0.6, false, 0.8)
	
	# Acoustic aperture matrix (3x3 micro holes)
	for dx in [-2.0, 0.0, 2.0]:
		for dy in [-2.0, 0.0, 2.0]:
			ci.draw_circle(Vector2(dx, dy), 0.6, Color("0a0f14"))
	
	# Institutional telemetry diode (Amber pulse on announcement)
	var diode_col := COLOR_AMBER if p_is_activated else COLOR_CYAN * 0.7
	ci.draw_circle(Vector2(8.5, 0.0), 1.4, diode_col)
	
	# Sound emission arcs when active
	if p_is_activated or p_in_range:
		var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
		var arc_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.35 + pulse * 0.45)
		ci.draw_arc(Vector2(0.0, 6.0), 6.0 + pulse * 3.0, 0.2 * PI, 0.8 * PI, 8, arc_col, 1.2)
		ci.draw_arc(Vector2(0.0, 6.0), 10.0 + pulse * 4.0, 0.25 * PI, 0.75 * PI, 8, arc_col * 0.6, 1.0)


static func draw_elderly_passenger(ci: CanvasItem) -> void:
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
	ci.draw_polygon(coat_pts, [coat_col])
	ci.draw_polyline(coat_pts, COLOR_INFRASTRUCTURE * 0.4, 1.0)
	
	# Lapel / Scarf
	ci.draw_line(Vector2(-3.0, -10.0), Vector2(1.0, 2.0), COLOR_INFRASTRUCTURE * 0.7, 1.5)
	
	# Head / Wool beanie
	ci.draw_circle(Vector2(-1.0, -17.0), 5.5, Color("141c22"))
	ci.draw_circle(Vector2(-1.0, -17.0), 5.0, COLOR_INFRASTRUCTURE * 0.6) # Beanie cap
	ci.draw_circle(Vector2(-3.0, -15.0), 3.5, Color("cf9b72")) # Face profile
	
	# Hands on knees holding the gold ring / gesture
	ci.draw_circle(Vector2(-7.0, 6.0), 2.2, Color("cf9b72"))
	
	# Subtle eye / calm observant gaze
	ci.draw_circle(Vector2(-4.5, -15.5), 0.7, Color("141c22"))


static func draw_gold_ring(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Gold wedding ring on bus seat fabric (warm amber/gold #E6B450)
	var pulse := sin(p_pulse * 2.5) * 0.5 + 0.5
	var gold_col := Color("e6b450")
	var gold_shadow := Color("7a5618")
	var gold_highlight := Color("fff2b2")
	
	# Filament warmth disc beneath ring
	var glow_rad := 7.0 + pulse * 2.5
	ci.draw_circle(Vector2.ZERO, glow_rad, Color(gold_col.r, gold_col.g, gold_col.b, 0.22 + pulse * 0.20))
	
	# Ring geometry: outer circle & inner hollow
	ci.draw_circle(Vector2.ZERO, 3.8, gold_col)
	ci.draw_circle(Vector2.ZERO, 2.2, Color("1a2630")) # Seat fabric background
	ci.draw_circle(Vector2.ZERO, 3.8, gold_shadow, false, 0.8)
	
	# Specular reflection gleam
	ci.draw_circle(Vector2(-1.4, -1.4), 0.9, gold_highlight)
	
	# Radial micro-light beams when inspected/activated
	if p_is_activated or p_in_range:
		var beam_len := 6.0 + pulse * 2.0
		var beam_col := Color(gold_col.r, gold_col.g, gold_col.b, 0.5 + pulse * 0.3)
		for angle_deg in [0.0, 72.0, 144.0, 216.0, 288.0]:
			var rad: float = deg_to_rad(angle_deg + p_pulse * 20.0)
			var p1 := Vector2(cos(rad), sin(rad)) * 4.2
			var p2 := Vector2(cos(rad), sin(rad)) * (4.2 + beam_len)
			ci.draw_line(p1, p2, beam_col, 1.0)


static func draw_bus_route_map(ci: CanvasItem, p_pulse: float) -> void:
	# Institutional overhead route board: "LINIA ZASTĘPCZA 4" (44x16 px)
	var board_rect := Rect2(-22.0, -8.0, 44.0, 16.0)
	ci.draw_rect(board_rect, Color("141e26"))
	ci.draw_rect(board_rect, COLOR_INFRASTRUCTURE * 0.75, false, 1.0)
	
	# Route strip track line
	ci.draw_line(Vector2(-18.0, 0.0), Vector2(18.0, 0.0), COLOR_CYAN * 0.8, 1.5)
	
	# Station dots:
	# 1. IKP (origin - checked)
	ci.draw_circle(Vector2(-16.0, 0.0), 2.2, COLOR_CYAN)
	# 2. Closed stations on Line 4 (crossed out with red cinnabar)
	ci.draw_circle(Vector2(-6.0, 0.0), 1.8, COLOR_CORRECTION)
	ci.draw_line(Vector2(-8.0, -2.5), Vector2(-4.0, 2.5), COLOR_CORRECTION, 1.2)
	ci.draw_line(Vector2(-8.0, 2.5), Vector2(-4.0, -2.5), COLOR_CORRECTION, 1.2)
	
	ci.draw_circle(Vector2(4.0, 0.0), 1.8, COLOR_CORRECTION)
	ci.draw_line(Vector2(2.0, -2.5), Vector2(6.0, 2.5), COLOR_CORRECTION, 1.2)
	ci.draw_line(Vector2(2.0, 2.5), Vector2(6.0, -2.5), COLOR_CORRECTION, 1.2)
	
	# 3. Osiedle Tarasowe (destination - pulsing amber)
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	ci.draw_circle(Vector2(14.0, 0.0), 2.4, COLOR_AMBER)
	ci.draw_circle(Vector2(14.0, 0.0), 3.6 + pulse * 1.5, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.35), false, 0.8)


static func draw_tenant_directory(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Modernist resident directory board on staircase landing (44x32 px)
	var board_rect := Rect2(-22.0, -16.0, 44.0, 32.0)
	ci.draw_rect(board_rect, Color("121a20"))
	ci.draw_rect(board_rect, COLOR_INFRASTRUCTURE * 0.8, false, 1.2)
	
	# Header strip: "BLOK 7 / OS. TARASOWE"
	ci.draw_rect(Rect2(-20.0, -14.0, 40.0, 5.0), Color("1e2a32"))
	ci.draw_line(Vector2(-18.0, -11.5), Vector2(-4.0, -11.5), COLOR_INFRASTRUCTURE * 0.9, 1.0)
	
	# Resident list entries (stairwell floor 4 & 5)
	# M. 11 & 12
	ci.draw_line(Vector2(-18.0, -5.0), Vector2(6.0, -5.0), COLOR_INFRASTRUCTURE * 0.45, 1.0)
	ci.draw_line(Vector2(-18.0, -1.0), Vector2(10.0, -1.0), COLOR_INFRASTRUCTURE * 0.45, 1.0)
	
	# M. 13 — Bera S. [V p.]
	ci.draw_line(Vector2(-18.0, 3.0), Vector2(8.0, 3.0), COLOR_INFRASTRUCTURE * 0.55, 1.0)
	
	# M. 14 — Wolska L. / Kurek M. [V p.] (Highlighted with warm amber tag)
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	var highlight_col := COLOR_AMBER if (p_is_activated or p_in_range) else COLOR_AMBER * 0.75
	ci.draw_rect(Rect2(-19.0, 6.0, 38.0, 6.0), Color(highlight_col.r, highlight_col.g, highlight_col.b, 0.18 + pulse * 0.15))
	ci.draw_line(Vector2(-17.0, 9.0), Vector2(14.0, 9.0), highlight_col, 1.2)
	ci.draw_circle(Vector2(-17.0, 9.0), 1.5, highlight_col)


static func draw_mailboxes(ci: CanvasItem, p_pulse: float) -> void:
	# Steel multi-compartment mailboxes module (48x28 px)
	var box_rect := Rect2(-24.0, -14.0, 48.0, 28.0)
	ci.draw_rect(box_rect, Color("1e2b34"))
	ci.draw_rect(box_rect, COLOR_INFRASTRUCTURE * 0.85, false, 1.2)
	
	# 4 Individual mailbox doors (2x2 grid)
	var cells := [
		Rect2(-22.0, -12.0, 20.0, 10.0), # M. 11
		Rect2(2.0, -12.0, 20.0, 10.0),   # M. 12
		Rect2(-22.0, 2.0, 20.0, 10.0),   # M. 13
		Rect2(2.0, 2.0, 20.0, 10.0),     # M. 14 (Wolska / Kurek)
	]
	
	for i in range(cells.size()):
		var cell: Rect2 = cells[i]
		ci.draw_rect(cell, Color("17232b"))
		ci.draw_rect(cell, COLOR_DARK_STEEL, false, 1.0)
		# Horizontal mail drop slot
		ci.draw_line(Vector2(cell.position.x + 3.0, cell.position.y + 3.0), Vector2(cell.position.x + cell.size.x - 3.0, cell.position.y + 3.0), Color("0a1014"), 1.2)
		# Keyhole
		ci.draw_circle(Vector2(cell.position.x + cell.size.x - 4.0, cell.position.y + 7.0), 0.8, COLOR_INFRASTRUCTURE * 0.7)
	
	# Mailbox 14 (index 3): Protruding UCP notices / uncollected official mail
	var pulse := sin(p_pulse * 2.2) * 0.5 + 0.5
	var paper_col := Color("e8e2d2")
	# Envelope corner sticking out of slot
	var p_pts := PackedVector2Array([
		Vector2(6.0, 4.0),
		Vector2(18.0, 1.0 - pulse * 0.8),
		Vector2(19.0, 5.0),
		Vector2(8.0, 7.0)
	])
	ci.draw_colored_polygon(p_pts, paper_col)
	# Official red/oxide stamp mark on envelope
	ci.draw_rect(Rect2(12.0, 2.5, 4.0, 2.5), COLOR_CORRECTION)
	ci.draw_line(Vector2(7.0, 5.5), Vector2(17.0, 3.5), Color("20262c"), 0.8)


static func draw_blind_stairs(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Concrete stairs ending abruptly into a solid monolithic wall / truncated ceiling (#geometry-restless-grid)
	# Step profiles (ascending right towards solid barrier)
	var step1 := Rect2(-24.0, 8.0, 14.0, 8.0)
	var step2 := Rect2(-10.0, 0.0, 14.0, 8.0)
	var step3 := Rect2(4.0, -8.0, 14.0, 8.0)
	
	# Terrazzo treads
	ci.draw_rect(step1, Color("4a5860"))
	ci.draw_rect(step2, Color("53646d"))
	ci.draw_rect(step3, Color("5c6f7a"))
	
	# Solid concrete slab / sheer wall blocking the ascending flight at x=18
	var wall_rect := Rect2(16.0, -22.0, 16.0, 38.0)
	ci.draw_rect(wall_rect, Color("222f37"))
	ci.draw_rect(wall_rect, COLOR_DARK_STEEL, false, 1.2)
	# Rough unplastered concrete joints
	ci.draw_line(Vector2(16.0, -10.0), Vector2(32.0, -10.0), Color("151e24"), 1.0)
	ci.draw_line(Vector2(16.0, 4.0), Vector2(32.0, 4.0), Color("151e24"), 1.0)
	
	# Oxide cinnabar hazard warning tape / barrier across the dead-end flight
	var pulse := sin(p_pulse * 1.8) * 0.5 + 0.5
	var warn_col := COLOR_CORRECTION if not p_is_activated else Color("d4726d")
	ci.draw_line(Vector2(-12.0, -2.0), Vector2(16.0, -12.0), warn_col, 2.0)
	# Diagonal hazard slashes
	for d in range(5):
		var px: float = -8.0 + d * 5.0
		var py: float = -3.5 - d * 1.8
		ci.draw_line(Vector2(px - 1.5, py + 2.0), Vector2(px + 1.5, py - 2.0), Color("12181c"), 1.0)
	
	# Stencil symbol on concrete shear wall
	ci.draw_circle(Vector2(24.0, -4.0), 3.2, warn_col, false, 1.0)
	ci.draw_line(Vector2(21.5, -4.0), Vector2(26.5, -4.0), warn_col, 1.2)


static func draw_marta_interaction(ci: CanvasItem, p_pulse: float) -> void:
	# Marta Kurek standing in the doorway of Apt 14 (18x36 px)
	# Identity markers: long pink hair and a steel septum keep her legible apart
	# from Lena in every small residential encounter.
	# Wider center of gravity, dark layered work jacket with chalk/plaster marks,
	# tool bag slung across chest, folding ruler in leg pocket, observant calm gaze.
	
	# Warm amber domestic hallway glow behind Marta
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	var glow_alpha := 0.25 + pulse * 0.15
	ci.draw_circle(Vector2(4.0, -4.0), 22.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, glow_alpha))
	
	# 1. Legs & Heavy boots
	ci.draw_rect(Rect2(-7.0, 8.0, 5.0, 10.0), Color("182329"))
	ci.draw_rect(Rect2(1.0, 8.0, 5.0, 10.0), Color("182329"))
	ci.draw_rect(Rect2(-8.0, 16.0, 6.5, 3.5), Color("10161a")) # Boot left
	ci.draw_rect(Rect2(0.5, 16.0, 6.5, 3.5), Color("10161a"))  # Boot right
	
	# 2. Torso & Layered work jacket (sage green / muted dark canvas #2B3D36)
	var torso_rect := Rect2(-8.0, -8.0, 15.0, 17.0)
	ci.draw_rect(torso_rect, Color("2b3d36"))
	ci.draw_rect(torso_rect, Color("3a5148"), false, 1.0)
	
	# Chalk / plaster marks on sleeve & pocket (authentic artisan texture)
	ci.draw_line(Vector2(-6.0, 0.0), Vector2(-3.0, 3.0), Color("8a9e96"), 0.8)
	ci.draw_line(Vector2(-5.0, 4.0), Vector2(-2.0, 4.0), Color("8a9e96"), 0.8)
	
	# 3. Canvas tool bag strap across chest (diagonal from right shoulder to left hip)
	ci.draw_line(Vector2(4.0, -8.0), Vector2(-7.0, 6.0), Color("6e5944"), 2.2)
	# Heavy rectangular canvas tool bag on left hip
	ci.draw_rect(Rect2(-12.0, 0.0, 6.0, 9.0), Color("4a3c2e"))
	ci.draw_rect(Rect2(-12.0, 0.0, 6.0, 9.0), Color("6e5944"), false, 0.8)
	
	# 4. Folded wooden folding ruler (calówka) peeking from right thigh pocket
	ci.draw_rect(Rect2(4.0, 4.0, 2.5, 6.0), COLOR_AMBER)
	ci.draw_line(Vector2(4.0, 6.0), Vector2(6.5, 6.0), Color("1c242a"), 0.6)
	ci.draw_line(Vector2(4.0, 8.0), Vector2(6.5, 8.0), Color("1c242a"), 0.6)
	
	# 5. Long pink hair, face & steel septum.
	var marta_hair_shadow := Color("6d294f")
	var marta_hair_pink := Color("d45b9a")
	var marta_skin := Color("d39a62")
	ci.draw_circle(Vector2(-0.5, -13.0), 5.2, marta_hair_shadow)
	ci.draw_rect(Rect2(-5.2, -12.0, 3.0, 14.0), marta_hair_shadow)
	ci.draw_rect(Rect2(2.0, -12.0, 3.0, 14.0), marta_hair_shadow)
	ci.draw_circle(Vector2(-1.5, -12.5), 3.8, marta_skin)
	ci.draw_line(Vector2(-4.5, -15.8), Vector2(2.6, -17.2), marta_hair_pink, 2.0)
	ci.draw_line(Vector2(-4.8, -10.0), Vector2(-4.8, 1.0), marta_hair_pink, 1.5)
	ci.draw_line(Vector2(2.8, -10.0), Vector2(2.8, 1.0), marta_hair_pink, 1.5)
	ci.draw_circle(Vector2(-3.5, -13.0), 0.8, Color("141c22")) # Observant eye
	ci.draw_arc(Vector2(0.4, -11.4), 1.15, 0.15, PI - 0.15, 6, Color("c7d3d6"), 0.8) # Septum
	
	# 6. Hand posture: one hand resting on door frame, one holding tool bag strap
	ci.draw_circle(Vector2(-6.0, 4.0), 1.8, Color("d39a62")) # Hand on bag strap
	ci.draw_circle(Vector2(7.0, -2.0), 1.6, Color("d39a62")) # Hand near door edge


static func draw_stair_timer_switch(ci: CanvasItem, p_pulse: float) -> void:
	# Classic modernist staircase timer push-button with amber neon pilot glow (16x16 px)
	var plate_rect := Rect2(-7.0, -7.0, 14.0, 14.0)
	ci.draw_rect(plate_rect, Color("222e36"))
	ci.draw_rect(plate_rect, COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	
	# Mounting screws
	ci.draw_circle(Vector2(0.0, -5.0), 0.7, COLOR_INFRASTRUCTURE * 0.9)
	ci.draw_circle(Vector2(0.0, 5.0), 0.7, COLOR_INFRASTRUCTURE * 0.9)
	
	# Center push button (circular)
	ci.draw_circle(Vector2.ZERO, 3.6, Color("141c22"))
	ci.draw_circle(Vector2.ZERO, 2.4, Color("354652"))
	
	# Glowing orange/amber neon pilot lamp in center
	var pulse := sin(p_pulse * 3.0) * 0.5 + 0.5
	var neon_alpha := 0.6 + pulse * 0.4
	var neon_col := Color("ff9e3b")
	ci.draw_circle(Vector2.ZERO, 1.4, Color(neon_col.r, neon_col.g, neon_col.b, neon_alpha))
	ci.draw_circle(Vector2.ZERO, 3.2 + pulse * 1.2, Color(neon_col.r, neon_col.g, neon_col.b, 0.25 * neon_alpha))


static func draw_hallway_coat_rack(ci: CanvasItem) -> void:
	# Modernist wooden coat rack strip with brass pegs, hanging coats and rain boots (28x36 px)
	# Wall rack strip
	var rack_bar := Rect2(-14.0, -18.0, 28.0, 4.0)
	ci.draw_rect(rack_bar, Color("4a3525")) # Teak wood
	ci.draw_rect(rack_bar, Color("6e4e35"), false, 0.8)
	
	# Brass hooks (left, center, right)
	ci.draw_circle(Vector2(-8.0, -16.0), 1.5, Color("cda35d"))
	ci.draw_circle(Vector2(0.0, -16.0), 1.5, Color("cda35d"))
	ci.draw_circle(Vector2(8.0, -16.0), 1.5, Color("cda35d"))
	
	# Coat 1 (Left hook - Lena's long dark graphite coat)
	var coat1_rect := Rect2(-12.0, -15.0, 8.0, 22.0)
	ci.draw_rect(coat1_rect, Color("1a242a"))
	ci.draw_rect(coat1_rect, Color("2a3740"), false, 0.8)
	ci.draw_line(Vector2(-8.0, -15.0), Vector2(-8.0, 5.0), Color("141c22"), 1.0) # Fold/seam
	
	# Coat 2 (Center/Right hook - Marta's work jacket with chalk/paint traces)
	var coat2_rect := Rect2(-2.0, -15.0, 9.0, 16.0)
	ci.draw_rect(coat2_rect, Color("2b3d36"))
	ci.draw_rect(coat2_rect, Color("3a5148"), false, 0.8)
	# Chalk marks on canvas jacket
	ci.draw_line(Vector2(0.0, -8.0), Vector2(3.0, -5.0), Color("8a9e96"), 0.8)
	ci.draw_line(Vector2(1.0, -3.0), Vector2(4.0, -3.0), Color("8a9e96"), 0.8)
	
	# Rain boots left on rubber mat beneath (at y=10..18)
	var mat_rect := Rect2(-13.0, 14.0, 26.0, 4.0)
	ci.draw_rect(mat_rect, Color("141a1f"))
	ci.draw_rect(mat_rect, Color("242d35"), false, 0.8)
	# Pair of dark rain boots left behind 17 days ago
	ci.draw_rect(Rect2(-8.0, 6.0, 6.0, 10.0), Color("10161a"))
	ci.draw_rect(Rect2(2.0, 6.0, 6.0, 10.0), Color("10161a"))
	ci.draw_rect(Rect2(-9.0, 13.0, 7.0, 3.5), Color("0b0f12"))
	ci.draw_rect(Rect2(1.0, 13.0, 7.0, 3.5), Color("0b0f12"))


static func draw_reflected_photograph(ci: CanvasItem) -> void:
	# Framed photograph of Marta and local Lena (24x20 px)
	# Framing per VISUAL_DESIGN.md & FULL_STORY 08: Lena is framed strictly from behind or in reflection, never direct face
	var frame_rect := Rect2(-12.0, -10.0, 24.0, 20.0)
	var photo_rect := Rect2(-10.0, -8.0, 20.0, 16.0)
	
	# Modernist wooden frame with brass corners
	ci.draw_rect(frame_rect, Color("3d2c1e"))
	ci.draw_rect(frame_rect, Color("cda35d"), false, 0.8)
	
	# Photo paper (monochrome warm tint)
	ci.draw_rect(photo_rect, Color("263238"))
	
	# Rainy window reflection background
	ci.draw_line(Vector2(-8.0, -6.0), Vector2(6.0, 6.0), Color(0.46, 0.78, 0.76, 0.15), 1.0)
	ci.draw_line(Vector2(-4.0, -6.0), Vector2(8.0, 4.0), Color(0.46, 0.78, 0.76, 0.15), 1.0)
	
	# Silhouette 1: Marta on left, profile facing towards Lena
	ci.draw_circle(Vector2(-5.0, -3.0), 3.0, Color("182329")) # Marta's head
	ci.draw_rect(Rect2(-7.0, 0.0, 5.0, 8.0), Color("2b3d36")) # Marta's torso
	
	# Silhouette 2: Local Lena on right, framed strictly FROM BEHIND (looking toward rainy window)
	ci.draw_circle(Vector2(4.0, -3.5), 3.2, Color("141c22")) # Lena's hair from behind
	ci.draw_rect(Rect2(1.5, -0.5, 6.0, 8.5), Color("1e2a32")) # Coat back
	ci.draw_line(Vector2(4.0, 0.0), Vector2(4.0, 7.0), Color("12181d"), 0.8) # Back center seam
	
	# Subtle glass reflection glaze
	ci.draw_line(Vector2(-10.0, 2.0), Vector2(0.0, -8.0), Color(1.0, 1.0, 1.0, 0.12), 1.0)


static func draw_beaker_planter(ci: CanvasItem) -> void:
	# 200ml Laboratory beaker repurposed as a domestic succulent planter (16x20 px)
	# Dual-purpose object (#composition-negative-space): institutional equipment becomes domestic shelter
	var beaker_rect := Rect2(-6.0, -6.0, 12.0, 16.0)
	
	# Potting soil inside
	ci.draw_rect(Rect2(-5.0, -1.0, 10.0, 10.0), Color("2b1d15"))
	
	# Translucent cyan-tinted glass beaker walls
	ci.draw_rect(beaker_rect, Color(0.46, 0.78, 0.76, 0.18))
	ci.draw_rect(beaker_rect, Color(0.46, 0.78, 0.76, 0.8), false, 1.0)
	
	# Spout at top left
	ci.draw_line(Vector2(-6.0, -6.0), Vector2(-8.0, -8.0), Color(0.46, 0.78, 0.76, 0.9), 1.0)
	ci.draw_line(Vector2(-8.0, -8.0), Vector2(-5.0, -6.0), Color(0.46, 0.78, 0.76, 0.9), 1.0)
	
	# Etched graduation lines (50, 100, 150, 200 ml)
	ci.draw_line(Vector2(2.0, 6.0), Vector2(5.0, 6.0), Color("e0e6e4"), 0.8)
	ci.draw_line(Vector2(2.0, 2.0), Vector2(5.0, 2.0), Color("e0e6e4"), 0.8)
	ci.draw_line(Vector2(2.0, -2.0), Vector2(5.0, -2.0), Color("e0e6e4"), 0.8)
	
	# Succulent plant sprouting upwards (jade green leaves)
	ci.draw_circle(Vector2(0.0, -3.0), 3.2, Color("3e6350"))
	ci.draw_circle(Vector2(-3.0, -6.0), 2.5, Color("4f7d66"))
	ci.draw_circle(Vector2(3.0, -6.0), 2.5, Color("4f7d66"))
	ci.draw_circle(Vector2(0.0, -9.0), 2.2, Color("5c9176"))
	# Small amber budding flower in center
	ci.draw_circle(Vector2(0.0, -11.0), 1.4, COLOR_AMBER)


static func draw_jakub_memento_tool(ci: CanvasItem) -> void:
	# Jakub's technical memento used as a drafting paperweight / spirit level (26x16 px)
	# Sheet of cyan technical blueprint on desk
	var sheet_rect := Rect2(-12.0, -4.0, 24.0, 14.0)
	ci.draw_rect(sheet_rect, Color("203340"))
	ci.draw_rect(sheet_rect, Color("385b73"), false, 0.8)
	# Fine orthogonal grid lines on draft paper
	ci.draw_line(Vector2(-8.0, -4.0), Vector2(-8.0, 10.0), Color(0.46, 0.78, 0.76, 0.25), 0.6)
	ci.draw_line(Vector2(0.0, -4.0), Vector2(0.0, 10.0), Color(0.46, 0.78, 0.76, 0.25), 0.6)
	ci.draw_line(Vector2(8.0, -4.0), Vector2(8.0, 10.0), Color(0.46, 0.78, 0.76, 0.25), 0.6)
	ci.draw_line(Vector2(-12.0, 2.0), Vector2(12.0, 2.0), Color(0.46, 0.78, 0.76, 0.25), 0.6)
	
	# Solid milled brass spirit level / memento resting on top
	var level_rect := Rect2(-9.0, -6.0, 18.0, 7.0)
	ci.draw_rect(level_rect, Color("8f6f32"))
	ci.draw_rect(level_rect, Color("cda35d"), false, 1.0)
	
	# Center glass vial with glowing cyan air bubble
	var vial_rect := Rect2(-4.0, -4.5, 8.0, 4.0)
	ci.draw_rect(vial_rect, Color("142229"))
	ci.draw_rect(vial_rect, Color(0.46, 0.78, 0.76, 0.5), false, 0.8)
	ci.draw_circle(Vector2(0.5, -2.5), 1.2, Color("75c7c3")) # Center balanced bubble
	
	# Engraved initials "J.W." stencil
	ci.draw_circle(Vector2(-6.5, -2.5), 0.7, Color("4a391a"))
	ci.draw_circle(Vector2(6.5, -2.5), 0.7, Color("4a391a"))


static func draw_cipher_desk(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy modernist study desk with combination lock drawer & gooseneck lamp (42x32 px)
	var desk_rect := Rect2(-20.0, -10.0, 40.0, 24.0)
	
	# Desktop surface (dark stained oak / teak)
	ci.draw_rect(desk_rect, Color("38271a"))
	ci.draw_rect(desk_rect, Color("543b27"), false, 1.0)
	
	# Desk legs / pedestal
	ci.draw_rect(Rect2(-18.0, 14.0, 4.0, 12.0), Color("241910"))
	ci.draw_rect(Rect2(14.0, 14.0, 4.0, 12.0), Color("241910"))
	
	# Gooseneck desk lamp on left
	ci.draw_line(Vector2(-14.0, -10.0), Vector2(-14.0, -18.0), Color("cda35d"), 1.2)
	ci.draw_line(Vector2(-14.0, -18.0), Vector2(-8.0, -16.0), Color("cda35d"), 1.2)
	ci.draw_circle(Vector2(-7.0, -15.0), 3.0, Color("423223")) # Shade
	# Warm filament light cone onto desk
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	var lamp_alpha := 0.22 + pulse * 0.08
	var cone_points := PackedVector2Array([
		Vector2(-7.0, -15.0),
		Vector2(-18.0, -2.0),
		Vector2(4.0, -2.0)
	])
	ci.draw_colored_polygon(cone_points, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, lamp_alpha))
	
	# Top-right drawer with mechanical combination dial
	var drawer_rect := Rect2(2.0, -6.0, 16.0, 10.0)
	if p_is_activated:
		# Drawer pulled out slightly, revealing foreign handwritten sheets & Substructure sketches
		drawer_rect = Rect2(2.0, -2.0, 16.0, 12.0)
		ci.draw_rect(drawer_rect, Color("2e1f14"))
		ci.draw_rect(drawer_rect, COLOR_CYAN * 0.8, false, 1.0)
		
		# White/yellowed technical draft sheets peeking out
		ci.draw_rect(Rect2(4.0, -4.0, 12.0, 6.0), Color("dcd8cd"))
		ci.draw_line(Vector2(5.0, -2.0), Vector2(14.0, -2.0), Color("2b3d36"), 0.8) # Formula lines
		ci.draw_line(Vector2(5.0, 0.0), Vector2(12.0, 0.0), Color("2b3d36"), 0.8)
		# Cyan unlocked bolt indicator
		ci.draw_circle(Vector2(10.0, 4.0), 1.5, COLOR_CYAN)
	else:
		# Locked drawer flush with desk
		ci.draw_rect(drawer_rect, Color("2b1d13"))
		ci.draw_rect(drawer_rect, Color("4a3321"), false, 0.8)
		# Brass 4-dial combination lock faceplate
		ci.draw_rect(Rect2(7.0, -3.0, 6.0, 4.0), Color("8f6f32"))
		ci.draw_circle(Vector2(10.0, -1.0), 1.2, Color("cda35d"))


static func draw_tea_kettle(ci: CanvasItem, p_pulse: float) -> void:
	# Enameled tea kettle on stovetop with steam whistle and ceramic mugs (24x22 px)
	# Stovetop burner base
	var stove_rect := Rect2(-10.0, 4.0, 20.0, 4.0)
	ci.draw_rect(stove_rect, Color("202a30"))
	ci.draw_rect(stove_rect, COLOR_INFRASTRUCTURE * 0.7, false, 0.8)
	
	# Gas flamelets beneath kettle (blue/cyan)
	var pulse := sin(p_pulse * 4.0) * 0.5 + 0.5
	var flame_alpha := 0.6 + pulse * 0.3
	ci.draw_circle(Vector2(-5.0, 4.0), 1.5, Color(0.46, 0.78, 0.76, flame_alpha))
	ci.draw_circle(Vector2(0.0, 4.0), 1.5, Color(0.46, 0.78, 0.76, flame_alpha))
	ci.draw_circle(Vector2(5.0, 4.0), 1.5, Color(0.46, 0.78, 0.76, flame_alpha))
	
	# Kettle body (dark charcoal enamel #26333c with stainless lid)
	ci.draw_circle(Vector2(0.0, -2.0), 6.5, Color("26333c"))
	ci.draw_rect(Rect2(-4.0, -8.0, 8.0, 3.0), Color("a8b2ac")) # Polished lid
	ci.draw_circle(Vector2(0.0, -8.5), 1.2, Color("141a1f")) # Lid knob
	
	# Arching black handle over top
	ci.draw_arc(Vector2(0.0, -6.0), 7.0, -PI * 0.85, -PI * 0.15, 8, Color("141a1f"), 1.4)
	
	# Spout on left emitting steam plumes
	ci.draw_line(Vector2(-5.0, -2.0), Vector2(-10.0, -6.0), Color("26333c"), 2.0)
	var steam_pulse := sin(p_pulse * 3.5) * 0.5 + 0.5
	ci.draw_circle(Vector2(-12.0 - steam_pulse * 2.0, -8.0 - steam_pulse * 4.0), 2.0 + steam_pulse * 1.5, Color(1.0, 1.0, 1.0, 0.25 * (1.0 - steam_pulse * 0.5)))
	
	# Two ceramic mugs on cork coaster next to stove (x=7..13)
	ci.draw_rect(Rect2(7.0, 2.0, 5.0, 6.0), Color("dcd8cd")) # White ceramic mug
	ci.draw_rect(Rect2(7.0, 2.0, 5.0, 6.0), Color("8a9e96"), false, 0.8)


static func draw_bathroom_sink(ci: CanvasItem, p_pulse: float) -> void:
	# Modernist ceramic washbasin with chrome fixtures (28x22 px)
	# Ceramic basin body (white ceramic #dcd8cd with subtle sage rim)
	var basin_rect := Rect2(-14.0, -4.0, 28.0, 14.0)
	ci.draw_rect(basin_rect, Color("dcd8cd"))
	ci.draw_rect(basin_rect, Color("8a9e96"), false, 1.0)
	
	# Inner basin bowl depth contour
	ci.draw_rect(Rect2(-10.0, -1.0, 20.0, 9.0), Color("c5c2b6"))
	# Chrome drain ring & plug hole
	ci.draw_circle(Vector2(0.0, 3.5), 2.2, COLOR_DARK_STEEL)
	ci.draw_circle(Vector2(0.0, 3.5), 1.2, COLOR_INFRASTRUCTURE)
	
	# Chrome gooseneck faucet above basin
	ci.draw_line(Vector2(0.0, -4.0), Vector2(0.0, -14.0), COLOR_INFRASTRUCTURE, 2.0)
	ci.draw_line(Vector2(0.0, -14.0), Vector2(-4.0, -12.0), COLOR_INFRASTRUCTURE, 2.0)
	ci.draw_line(Vector2(0.0, -14.0), Vector2(-4.0, -12.0), Color("e0e8e4"), 1.0) # Chrome glint
	
	# Hot & Cold rotary valve knobs
	ci.draw_rect(Rect2(-7.0, -7.0, 3.0, 3.0), COLOR_CORRECTION * 0.8) # Hot (cinnabar)
	ci.draw_rect(Rect2(4.0, -7.0, 3.0, 3.0), COLOR_CYAN * 0.8) # Cold (cyan)
	
	# S-trap exposed drain pipe down into wall
	ci.draw_line(Vector2(0.0, 10.0), Vector2(0.0, 16.0), Color("263943"), 2.0)
	ci.draw_line(Vector2(0.0, 16.0), Vector2(6.0, 20.0), Color("263943"), 2.0)
	ci.draw_line(Vector2(6.0, 20.0), Vector2(10.0, 16.0), Color("263943"), 2.0)
	
	# Water droplet forming / dripping from spout
	var drop_phase := fmod(p_pulse * 1.8, 1.0)
	var drop_y := -11.0 + drop_phase * 14.0
	var drop_alpha := clampf(1.0 - drop_phase * 0.4, 0.2, 0.9)
	ci.draw_circle(Vector2(-4.0, drop_y), 1.2, Color(0.46, 0.78, 0.76, drop_alpha))
	
	# Ceramic soap dish with bar of soap on left rim
	ci.draw_rect(Rect2(-12.0, -6.0, 5.0, 2.0), Color("e8e6df"))
	ci.draw_rect(Rect2(-11.0, -8.0, 3.5, 2.0), Color("d39a62") * 0.9)


static func draw_bathroom_mirror(ci: CanvasItem, p_pulse: float) -> void:
	# Framed bathroom mirror with delayed / asynchronous reflection (32x44 px)
	var frame_rect := Rect2(-16.0, -22.0, 32.0, 44.0)
	var mirror_rect := Rect2(-14.0, -20.0, 28.0, 40.0)
	
	# Dark zinc / lead frame with wall brackets
	ci.draw_rect(frame_rect, Color("1a242a"))
	ci.draw_rect(frame_rect, COLOR_DARK_STEEL, false, 1.2)
	# Wall mounting screw studs at corners
	ci.draw_circle(Vector2(-14.0, -20.0), 1.0, COLOR_INFRASTRUCTURE)
	ci.draw_circle(Vector2(14.0, -20.0), 1.0, COLOR_INFRASTRUCTURE)
	ci.draw_circle(Vector2(-14.0, 20.0), 1.0, COLOR_INFRASTRUCTURE)
	ci.draw_circle(Vector2(14.0, 20.0), 1.0, COLOR_INFRASTRUCTURE)
	
	# Silvered mirror surface with subtle reflection gradient
	ci.draw_rect(mirror_rect, Color("283b47"))
	ci.draw_rect(Rect2(-14.0, -20.0, 28.0, 20.0), Color("2f4553"))
	
	# Diagonal reflection glint lines
	ci.draw_line(Vector2(-10.0, -18.0), Vector2(10.0, 18.0), Color(0.6, 0.75, 0.8, 0.18), 1.0)
	ci.draw_line(Vector2(-6.0, -18.0), Vector2(14.0, 14.0), Color(0.6, 0.75, 0.8, 0.12), 1.0)
	
	# Ghostly delayed reflection silhouette of Lena & distant doorway in mirror
	var ghost_pulse := sin(p_pulse * 1.5) * 0.5 + 0.5
	var ghost_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.28 + ghost_pulse * 0.14)
	# Reflected doorway frame in background
	ci.draw_rect(Rect2(2.0, -14.0, 8.0, 26.0), Color(0.12, 0.18, 0.22, 0.75))
	ci.draw_rect(Rect2(2.0, -14.0, 8.0, 26.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.3), false, 0.8)
	# Reflected silhouette of Lena
	ci.draw_circle(Vector2(-2.0, -4.0), 4.5, ghost_col) # Head
	ci.draw_rect(Rect2(-5.0, 0.0, 6.0, 12.0), ghost_col) # Body & coat
	# Subtle asymmetry: coat flap in reflection
	ci.draw_line(Vector2(-5.0, 4.0), Vector2(-8.0, 10.0), ghost_col, 1.2)


static func draw_scratched_inscription(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_in_range: bool) -> void:
	# Scratched inscription on mirror glass: "NIE SZUKAJ ORYGINAŁU" (Clue R-02)
	# When viewed from front or unactivated: faint subtle scratches
	# When illuminated under oblique angle / activated: crisp glowing cyan & amber lines
	var pulse := sin(p_pulse * 2.5) * 0.5 + 0.5
	var is_lit := p_is_activated or p_in_range
	var alpha := 0.95 if is_lit else 0.25
	var col_scratch := COLOR_CYAN if is_lit else Color("405560")
	var col_amber := COLOR_AMBER if is_lit else Color("453a2f")
	
	# Etched razor score lines across the glass pane
	# Line 1: "NIE SZUKAJ" (symbolic geometric line groups)
	# N
	ci.draw_line(Vector2(-16.0, -6.0), Vector2(-16.0, -1.0), col_scratch, 1.0)
	ci.draw_line(Vector2(-16.0, -6.0), Vector2(-13.0, -1.0), col_scratch, 1.0)
	ci.draw_line(Vector2(-13.0, -6.0), Vector2(-13.0, -1.0), col_scratch, 1.0)
	# I
	ci.draw_line(Vector2(-11.0, -6.0), Vector2(-11.0, -1.0), col_scratch, 1.0)
	# E
	ci.draw_line(Vector2(-9.0, -6.0), Vector2(-9.0, -1.0), col_scratch, 1.0)
	ci.draw_line(Vector2(-9.0, -6.0), Vector2(-6.0, -6.0), col_scratch, 0.8)
	ci.draw_line(Vector2(-9.0, -3.5), Vector2(-7.0, -3.5), col_scratch, 0.8)
	ci.draw_line(Vector2(-9.0, -1.0), Vector2(-6.0, -1.0), col_scratch, 0.8)
	
	# Space & SZUKAJ
	# S
	ci.draw_line(Vector2(-3.0, -6.0), Vector2(-1.0, -6.0), col_scratch, 0.8)
	ci.draw_line(Vector2(-3.0, -6.0), Vector2(-3.0, -3.5), col_scratch, 0.8)
	ci.draw_line(Vector2(-3.0, -3.5), Vector2(-1.0, -3.5), col_scratch, 0.8)
	ci.draw_line(Vector2(-1.0, -3.5), Vector2(-1.0, -1.0), col_scratch, 0.8)
	ci.draw_line(Vector2(-3.0, -1.0), Vector2(-1.0, -1.0), col_scratch, 0.8)
	# Z
	ci.draw_line(Vector2(1.0, -6.0), Vector2(3.0, -6.0), col_scratch, 0.8)
	ci.draw_line(Vector2(3.0, -6.0), Vector2(1.0, -1.0), col_scratch, 0.8)
	ci.draw_line(Vector2(1.0, -1.0), Vector2(3.0, -1.0), col_scratch, 0.8)
	# U
	ci.draw_line(Vector2(5.0, -6.0), Vector2(5.0, -1.0), col_scratch, 0.8)
	ci.draw_line(Vector2(5.0, -1.0), Vector2(7.5, -1.0), col_scratch, 0.8)
	ci.draw_line(Vector2(7.5, -6.0), Vector2(7.5, -1.0), col_scratch, 0.8)
	# K
	ci.draw_line(Vector2(9.5, -6.0), Vector2(9.5, -1.0), col_scratch, 0.8)
	ci.draw_line(Vector2(12.0, -6.0), Vector2(9.5, -3.5), col_scratch, 0.8)
	ci.draw_line(Vector2(9.5, -3.5), Vector2(12.0, -1.0), col_scratch, 0.8)
	# A
	ci.draw_line(Vector2(14.0, -1.0), Vector2(15.5, -6.0), col_scratch, 0.8)
	ci.draw_line(Vector2(15.5, -6.0), Vector2(17.0, -1.0), col_scratch, 0.8)
	ci.draw_line(Vector2(14.5, -3.5), Vector2(16.5, -3.5), col_scratch, 0.8)
	
	# Line 2: "ORYGINAŁU" (with amber & cyan highlights)
	ci.draw_line(Vector2(-18.0, 2.0), Vector2(18.0, 2.0), Color(col_amber.r, col_amber.g, col_amber.b, alpha * 0.4), 0.6)
	# O
	ci.draw_rect(Rect2(-16.0, 3.0, 3.5, 5.0), col_amber, false, 0.8)
	# R
	ci.draw_line(Vector2(-11.0, 3.0), Vector2(-11.0, 8.0), col_amber, 0.8)
	ci.draw_line(Vector2(-11.0, 3.0), Vector2(-8.5, 3.0), col_amber, 0.8)
	ci.draw_line(Vector2(-8.5, 3.0), Vector2(-8.5, 5.5), col_amber, 0.8)
	ci.draw_line(Vector2(-8.5, 5.5), Vector2(-11.0, 5.5), col_amber, 0.8)
	ci.draw_line(Vector2(-10.0, 5.5), Vector2(-8.5, 8.0), col_amber, 0.8)
	# Y
	ci.draw_line(Vector2(-7.0, 3.0), Vector2(-5.5, 5.5), col_amber, 0.8)
	ci.draw_line(Vector2(-4.0, 3.0), Vector2(-5.5, 5.5), col_amber, 0.8)
	ci.draw_line(Vector2(-5.5, 5.5), Vector2(-5.5, 8.0), col_amber, 0.8)
	# G
	ci.draw_line(Vector2(-0.5, 3.0), Vector2(-2.5, 3.0), col_amber, 0.8)
	ci.draw_line(Vector2(-2.5, 3.0), Vector2(-2.5, 8.0), col_amber, 0.8)
	ci.draw_line(Vector2(-2.5, 8.0), Vector2(-0.5, 8.0), col_amber, 0.8)
	ci.draw_line(Vector2(-0.5, 8.0), Vector2(-0.5, 5.5), col_amber, 0.8)
	ci.draw_line(Vector2(-0.5, 5.5), Vector2(-1.5, 5.5), col_amber, 0.8)
	# I
	ci.draw_line(Vector2(1.5, 3.0), Vector2(1.5, 8.0), col_amber, 0.8)
	# N
	ci.draw_line(Vector2(3.5, 3.0), Vector2(3.5, 8.0), col_amber, 0.8)
	ci.draw_line(Vector2(3.5, 3.0), Vector2(6.0, 8.0), col_amber, 0.8)
	ci.draw_line(Vector2(6.0, 3.0), Vector2(6.0, 8.0), col_amber, 0.8)
	# A
	ci.draw_line(Vector2(8.0, 8.0), Vector2(9.5, 3.0), col_amber, 0.8)
	ci.draw_line(Vector2(9.5, 3.0), Vector2(11.0, 8.0), col_amber, 0.8)
	ci.draw_line(Vector2(8.5, 5.5), Vector2(10.5, 5.5), col_amber, 0.8)
	# Ł
	ci.draw_line(Vector2(13.0, 3.0), Vector2(13.0, 8.0), col_amber, 0.8)
	ci.draw_line(Vector2(13.0, 8.0), Vector2(15.5, 8.0), col_amber, 0.8)
	ci.draw_line(Vector2(11.8, 5.0), Vector2(14.2, 4.0), col_amber, 0.8)
	# U
	ci.draw_line(Vector2(17.0, 3.0), Vector2(17.0, 8.0), col_amber, 0.8)
	ci.draw_line(Vector2(17.0, 8.0), Vector2(19.5, 8.0), col_amber, 0.8)
	ci.draw_line(Vector2(19.5, 3.0), Vector2(19.5, 8.0), col_amber, 0.8)
	
	# Micro fracture glints
	if is_lit:
		ci.draw_circle(Vector2(-14.0 + pulse * 2.0, -3.0), 1.0, COLOR_CYAN)
		ci.draw_circle(Vector2(10.0 - pulse * 2.0, 5.0), 1.0, COLOR_AMBER)


static func draw_apothecary_cabinet(ci: CanvasItem) -> void:
	# Wall-mounted medical cabinet with frosted ribbed glass door (22x30 px)
	var cab_rect := Rect2(-11.0, -15.0, 22.0, 30.0)
	ci.draw_rect(cab_rect, Color("d0d7d4"))
	ci.draw_rect(cab_rect, Color("24333c"), false, 1.2)
	
	# Interior shelf dividing lines
	ci.draw_line(Vector2(-10.0, -5.0), Vector2(10.0, -5.0), Color("24333c"), 1.0)
	ci.draw_line(Vector2(-10.0, 5.0), Vector2(10.0, 5.0), Color("24333c"), 1.0)
	
	# Top shelf: 2 amber correlation stabilizer bottles
	ci.draw_rect(Rect2(-8.0, -13.0, 4.5, 7.0), COLOR_AMBER * 0.9)
	ci.draw_rect(Rect2(-7.0, -14.5, 2.5, 2.0), Color("141a1f")) # Cap
	ci.draw_rect(Rect2(-2.0, -12.0, 4.0, 6.0), Color("8f5b2b"))
	ci.draw_rect(Rect2(-1.0, -13.5, 2.0, 2.0), Color("141a1f"))
	
	# Middle shelf: White medicine box with UCP indicator & pill blister strip
	ci.draw_rect(Rect2(-8.0, -3.0, 8.0, 6.0), Color("f0f4f2"))
	ci.draw_line(Vector2(-5.0, -2.0), Vector2(-5.0, 1.0), COLOR_CORRECTION, 1.0) # Cinnabar cross/bar
	ci.draw_line(Vector2(-6.5, -0.5), Vector2(-3.5, -0.5), COLOR_CORRECTION, 1.0)
	# Silver foil blister pack on right
	ci.draw_rect(Rect2(2.0, -2.0, 7.0, 5.0), Color("a8b2ac"))
	ci.draw_circle(Vector2(4.0, 0.0), 1.0, COLOR_CYAN)
	ci.draw_circle(Vector2(7.0, 0.0), 1.0, COLOR_CYAN)
	
	# Bottom shelf: Sterile gauze roll & tweezers
	ci.draw_circle(Vector2(-5.0, 10.0), 3.5, Color("e8eee8"))
	ci.draw_line(Vector2(2.0, 12.0), Vector2(8.0, 8.0), Color("e0e8e4"), 1.0) # Tweezers
	
	# Frosted ribbed glass door overlay with vertical fluting
	for fx in range(-9, 10, 3):
		ci.draw_line(Vector2(float(fx), -14.0), Vector2(float(fx), 14.0), Color(0.22, 0.31, 0.36, 0.25), 0.8)
	
	# Chrome latch handle on right side
	ci.draw_rect(Rect2(8.0, -2.0, 2.5, 4.0), Color("e0e8e4"))


static func draw_marta_bathroom_guide(ci: CanvasItem, p_pulse: float) -> void:
	# Architectural sightline guide marker (Marta's instruction D-03: "Zostaw drzwi w odbiciu")
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	var ray_alpha := 0.35 + pulse * 0.25
	var col_amber := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, ray_alpha)
	
	# Floor threshold notch
	ci.draw_rect(Rect2(-12.0, 4.0, 24.0, 3.0), Color("1a242c"))
	ci.draw_rect(Rect2(-12.0, 4.0, 24.0, 3.0), COLOR_INFRASTRUCTURE * 0.6, false, 0.8)
	
	# Observation line indicator pointing toward mirror on left
	ci.draw_line(Vector2(8.0, 0.0), Vector2(-12.0, 0.0), col_amber, 1.2)
	ci.draw_line(Vector2(-12.0, 0.0), Vector2(-8.0, -3.0), col_amber, 1.0)
	ci.draw_line(Vector2(-12.0, 0.0), Vector2(-8.0, 3.0), col_amber, 1.0)
	
	# Amber observation tick marker
	ci.draw_circle(Vector2(0.0, -8.0), 2.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, ray_alpha * 0.8))


static func draw_bakelite_phone(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy 1960s/70s Polish/European black bakelite desk telephone with rotary dial
	var pulse := sin(p_pulse * 3.0) * 0.5 + 0.5
	var is_ringing := not p_is_activated
	var shake_x: float = (sin(p_pulse * 24.0) * 0.8) if is_ringing else 0.0
	
	# 1. Base Housing (Heavy curved trapezoid / rounded rectangle: 24x13 px)
	var base_rect := Rect2(-12.0 + shake_x, 0.0, 24.0, 13.0)
	ci.draw_rect(base_rect, Color("10161a")) # Deep obsidian bakelite
	ci.draw_rect(base_rect, Color("202e38"), false, 1.0)
	# Bottom rubber foot pads
	ci.draw_rect(Rect2(-11.0 + shake_x, 12.0, 3.0, 2.0), Color("080c0e"))
	ci.draw_rect(Rect2(8.0 + shake_x, 12.0, 3.0, 2.0), Color("080c0e"))
	
	# 2. Chrome Cradle Forks on top
	ci.draw_line(Vector2(-7.0 + shake_x, 0.0), Vector2(-7.0 + shake_x, -4.0), Color("c8d4ce"), 1.4)
	ci.draw_line(Vector2(7.0 + shake_x, 0.0), Vector2(7.0 + shake_x, -4.0), Color("c8d4ce"), 1.4)
	ci.draw_circle(Vector2(-7.0 + shake_x, -4.0), 1.2, Color("e0ece8"))
	ci.draw_circle(Vector2(7.0 + shake_x, -4.0), 1.2, Color("e0ece8"))
	
	# 3. Rotary Dial
	var dial_center := Vector2(0.0 + shake_x, 6.5)
	ci.draw_circle(dial_center, 5.2, Color("18232a"))
	ci.draw_circle(dial_center, 4.2, Color("dce4e0")) # White number plate
	ci.draw_circle(dial_center, 1.8, Color("10161a")) # Central hub
	ci.draw_circle(dial_center, 0.9, COLOR_AMBER) # Brass center logo pin
	# Chrome finger stop bracket at bottom right (4 o'clock)
	ci.draw_line(dial_center + Vector2(2.5, 2.5), dial_center + Vector2(4.5, 4.5), Color("b0bcba"), 1.0)
	# 10 finger holes
	for i in range(10):
		var angle := -PI * 0.75 + float(i) * (PI * 1.5 / 9.0)
		var hole_pos := dial_center + Vector2(cos(angle), sin(angle)) * 3.0
		ci.draw_circle(hole_pos, 0.6, Color("202c34"))
	
	# 4. Handset & Cord
	if not p_is_activated:
		# Handset resting across cradle (with subtle vibration arcs if ringing)
		var earpiece_pos := Vector2(-9.0 + shake_x, -5.5)
		var mouthpiece_pos := Vector2(9.0 + shake_x, -5.5)
		# Earpiece cup & Mouthpiece cup
		ci.draw_circle(earpiece_pos, 3.5, Color("10161a"))
		ci.draw_circle(earpiece_pos, 3.5, Color("283844"), false, 0.8)
		ci.draw_circle(mouthpiece_pos, 3.5, Color("10161a"))
		ci.draw_circle(mouthpiece_pos, 3.5, Color("283844"), false, 0.8)
		# Connecting handle bar
		ci.draw_line(earpiece_pos, mouthpiece_pos, Color("10161a"), 3.2)
		ci.draw_line(earpiece_pos, mouthpiece_pos, Color("22303a"), 1.0)
		
		# Ringing acoustic vibration waves
		if is_ringing:
			var ring_alpha := 0.4 + pulse * 0.45
			ci.draw_arc(Vector2(0.0, -9.0), 7.0, -PI * 0.8, -PI * 0.2, 8, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, ring_alpha), 1.0)
			ci.draw_arc(Vector2(0.0, -12.0), 11.0, -PI * 0.75, -PI * 0.25, 8, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, ring_alpha * 0.6), 0.8)
	else:
		# Handset lifted and angled (conversation in progress D-04)
		var lift_offset := Vector2(2.0, -16.0)
		var ear_p := lift_offset + Vector2(-8.0, 3.0)
		var mouth_p := lift_offset + Vector2(8.0, -3.0)
		ci.draw_circle(ear_p, 3.5, Color("10161a"))
		ci.draw_circle(ear_p, 3.5, COLOR_AMBER * 0.8, false, 0.8)
		ci.draw_circle(mouth_p, 3.5, Color("10161a"))
		ci.draw_circle(mouth_p, 3.5, COLOR_AMBER * 0.8, false, 0.8)
		ci.draw_line(ear_p, mouth_p, Color("10161a"), 3.2)
		ci.draw_line(ear_p, mouth_p, COLOR_AMBER, 1.0)
		
		# Coiled cord stretching down to left side of base
		var cord_start := Vector2(-11.0, 9.0)
		var cord_end := ear_p
		for c in range(5):
			var t0 := float(c) / 5.0
			var t1 := float(c + 1) / 5.0
			var p0 := cord_start.lerp(cord_end, t0) + Vector2(sin(float(c) * 1.8) * 3.0, cos(float(c) * 1.5) * 2.0)
			var p1 := cord_start.lerp(cord_end, t1)
			ci.draw_line(p0, p1, Color("182228"), 1.2)


static func draw_reel_tape_recorder(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Vintage reel-to-reel tape deck (32x22 px) with two spools and VU meter
	var deck_rect := Rect2(-16.0, -11.0, 32.0, 22.0)
	
	# Teak/walnut outer wooden chassis
	ci.draw_rect(deck_rect, Color("342217"))
	ci.draw_rect(deck_rect, Color("1e130c"), false, 1.2)
	
	# Brushed aluminum faceplate
	var face_rect := Rect2(-14.0, -9.0, 28.0, 18.0)
	ci.draw_rect(face_rect, Color("94a29d"))
	ci.draw_rect(face_rect, Color("5b6964"), false, 0.8)
	
	var is_playing := p_is_activated
	var rot_speed := p_pulse * 4.0 if is_playing else 0.0
	
	# Left Spool (Supply Reel) at (-7.0, -2.5)
	var left_hub := Vector2(-7.0, -2.5)
	var reel_r: float = 5.2
	ci.draw_circle(left_hub, reel_r, Color("202a30")) # Dark tape layer
	ci.draw_circle(left_hub, reel_r, Color("cbd8d3"), false, 1.0) # Reel outer flange
	ci.draw_circle(left_hub, 1.8, Color("6b7975")) # Center hub
	for s in range(3):
		var ang := rot_speed + float(s) * (TAU / 3.0)
		ci.draw_line(left_hub, left_hub + Vector2(cos(ang), sin(ang)) * reel_r, Color("dce7e3"), 0.8)
	
	# Right Spool (Takeup Reel) at (7.0, -2.5)
	var right_hub := Vector2(7.0, -2.5)
	ci.draw_circle(right_hub, reel_r, Color("202a30"))
	ci.draw_circle(right_hub, reel_r, Color("cbd8d3"), false, 1.0)
	ci.draw_circle(right_hub, 1.8, Color("6b7975"))
	for s in range(3):
		var ang := rot_speed * 1.1 + float(s) * (TAU / 3.0)
		ci.draw_line(right_hub, right_hub + Vector2(cos(ang), sin(ang)) * reel_r, Color("dce7e3"), 0.8)
	
	# Magnetic Tape Path between reels & Head Assembly
	var tape_col := Color("4e311f") # Ferric oxide brown
	ci.draw_line(left_hub + Vector2(0.0, reel_r), Vector2(-2.5, 4.0), tape_col, 1.0)
	ci.draw_line(Vector2(-2.5, 4.0), Vector2(2.5, 4.0), tape_col, 1.0)
	ci.draw_line(Vector2(2.5, 4.0), right_hub + Vector2(0.0, reel_r), tape_col, 1.0)
	
	# Central Magnetic Head Block
	ci.draw_rect(Rect2(-3.0, 2.0, 6.0, 3.5), Color("222e36"))
	ci.draw_circle(Vector2(3.5, 3.5), 1.0, Color("c2cec9")) # Capstan pinch roller
	
	# VU Meter on bottom-left
	var vu_rect := Rect2(-13.0, 4.0, 6.5, 4.0)
	ci.draw_rect(vu_rect, Color("28382d"))
	ci.draw_rect(vu_rect, COLOR_AMBER * 0.4) # Warm backlit dial
	var needle_val := (sin(p_pulse * 6.0) * 0.5 + 0.5) if is_playing else 0.1
	var needle_tip := Vector2(-9.75, 4.5) + Vector2(lerpf(-2.0, 2.0, needle_val), 0.0)
	ci.draw_line(Vector2(-9.75, 7.5), needle_tip, COLOR_CORRECTION if needle_val > 0.8 else COLOR_AMBER, 0.8)
	
	# Piano key controls on bottom-right (Rew, Play, Stop, Fwd, Rec)
	for k in range(4):
		var kx := 1.0 + float(k) * 2.8
		var k_col := COLOR_CYAN if (k == 1 and is_playing) else Color("36444c")
		ci.draw_rect(Rect2(kx, 5.0, 2.2, 3.0), k_col)


static func draw_topography_board(ci: CanvasItem) -> void:
	# Wall-mounted corkboard (44x30 px) with pinned blueprints, clippings & connection strings
	var board_rect := Rect2(-22.0, -15.0, 44.0, 30.0)
	
	# Solid pine wood frame
	ci.draw_rect(board_rect, Color("3c2819"))
	ci.draw_rect(board_rect, Color("22160d"), false, 1.2)
	
	# Cork surface
	var cork_rect := Rect2(-20.0, -13.0, 40.0, 26.0)
	ci.draw_rect(cork_rect, Color("5e442c"))
	
	# 1. Pinned Apartment 14 Blueprint on left (18x16 px)
	var bp_rect := Rect2(-18.0, -11.0, 18.0, 16.0)
	ci.draw_rect(bp_rect, Color("1b3340")) # Blueprint cyan background
	ci.draw_rect(bp_rect, Color("75c7c3"), false, 0.6)
	# Floorplan room partition lines
	ci.draw_line(Vector2(-18.0, -3.0), Vector2(-4.0, -3.0), Color("75c7c3", 0.6), 0.7)
	ci.draw_line(Vector2(-10.0, -11.0), Vector2(-10.0, 5.0), Color("75c7c3", 0.6), 0.7)
	# Room control node marker
	ci.draw_circle(Vector2(-14.0, -7.0), 1.2, COLOR_AMBER) # Study
	ci.draw_circle(Vector2(-6.0, 1.0), 1.2, COLOR_CYAN) # Bathroom
	
	# 2. Newspaper clipping on right (16x13 px) - Line 4 Tram Disaster
	var news_rect := Rect2(2.0, -11.0, 16.0, 13.0)
	ci.draw_rect(news_rect, Color("d4dbd6"))
	ci.draw_rect(Rect2(3.0, -10.0, 14.0, 2.0), Color("202a30")) # Headline bar
	# Text columns
	ci.draw_line(Vector2(4.0, -6.5), Vector2(16.0, -6.5), Color("6b7a82"), 0.6)
	ci.draw_line(Vector2(4.0, -4.5), Vector2(16.0, -4.5), Color("6b7a82"), 0.6)
	ci.draw_line(Vector2(4.0, -2.5), Vector2(14.0, -2.5), Color("6b7a82"), 0.6)
	ci.draw_line(Vector2(4.0, -0.5), Vector2(12.0, -0.5), Color("6b7a82"), 0.6)
	
	# 3. Graph Nodes & Connection Strings (Amber & Cyan yarn lines linking nodes)
	var node_study := Vector2(-14.0, -7.0)
	var node_bath := Vector2(-6.0, 1.0)
	var node_tram := Vector2(10.0, -5.0)
	var node_ikp := Vector2(8.0, 8.0)
	var node_substruct := Vector2(-8.0, 9.0)
	
	# Colored yarn connection strings
	ci.draw_line(node_study, node_tram, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.8), 0.9)
	ci.draw_line(node_tram, node_ikp, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.8), 0.9)
	ci.draw_line(node_ikp, node_substruct, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.85), 0.9)
	ci.draw_line(node_substruct, node_bath, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.85), 0.9)
	
	# Pushpins on graph nodes
	ci.draw_circle(node_study, 1.4, COLOR_AMBER)
	ci.draw_circle(node_tram, 1.4, COLOR_CORRECTION)
	ci.draw_circle(node_ikp, 1.4, COLOR_INFRASTRUCTURE)
	ci.draw_circle(node_substruct, 1.4, COLOR_CYAN)
	ci.draw_circle(node_bath, 1.4, COLOR_CYAN)
	
	# 4. Sticky note on bottom right: "WĘZEŁ 14 - KONTROLA CIĄGŁOŚCI"
	var note_rect := Rect2(-1.0, 4.0, 18.0, 7.0)
	ci.draw_rect(note_rect, Color("e5c678"))
	ci.draw_line(Vector2(1.0, 6.0), Vector2(15.0, 6.0), Color("5a441e"), 0.6)
	ci.draw_line(Vector2(1.0, 8.0), Vector2(12.0, 8.0), Color("5a441e"), 0.6)


static func draw_jakub_desk_lamp(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Classic Banker's desk lamp with emerald green glass shade and brass body
	var pulse := sin(p_pulse * 2.0) * 0.5 + 0.5
	var is_lit := not p_is_activated # Lit by default unless toggled
	
	# Heavy circular brass base at bottom
	ci.draw_rect(Rect2(-7.0, 5.0, 14.0, 3.0), Color("9e7e3e"))
	ci.draw_rect(Rect2(-7.0, 5.0, 14.0, 3.0), Color("5c4820"), false, 0.8)
	
	# Curved brass gooseneck arm
	ci.draw_line(Vector2(0.0, 5.0), Vector2(0.0, -2.0), Color("bfa058"), 1.8)
	ci.draw_line(Vector2(0.0, -2.0), Vector2(-3.0, -7.0), Color("bfa058"), 1.8)
	
	# Banker's Emerald Green Glass Shade (18x7 px)
	var shade_rect := Rect2(-11.0, -11.0, 18.0, 7.0)
	ci.draw_rect(shade_rect, Color("1b452e")) # Deep emerald green glass
	ci.draw_rect(shade_rect, Color("0d2619"), false, 1.0)
	# Brass shade top bracket
	ci.draw_rect(Rect2(-4.0, -12.5, 6.0, 2.0), Color("bfa058"))
	# White inner milk-glass lip
	ci.draw_line(Vector2(-11.0, -4.0), Vector2(7.0, -4.0), Color("d8ece0") if is_lit else Color("7a9486"), 1.2)
	
	# Brass pull-chain switch dangling on right
	ci.draw_line(Vector2(4.0, -4.0), Vector2(4.0, 2.0), Color("bfa058"), 0.8)
	ci.draw_circle(Vector2(4.0, 2.5), 0.8, Color("dfc278"))
	
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
		ci.draw_colored_polygon(cone_points, cone_col)
		# Central bright filament hot spot on desk
		ci.draw_circle(Vector2(-2.0, 6.0), 8.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, cone_alpha * 0.6))


static func draw_tech_storage_airlock(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy technical corridor portal / utility passage leading to Space 11
	var portal_rect := Rect2(-16.0, -28.0, 32.0, 56.0)
	
	# Reinforced structural steel frame
	ci.draw_rect(portal_rect, COLOR_DARK_STEEL)
	ci.draw_rect(portal_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Rivet fasteners along frame perimeter
	for ry in range(-24, 25, 12):
		ci.draw_circle(Vector2(-13.5, float(ry)), 0.8, COLOR_INFRASTRUCTURE)
		ci.draw_circle(Vector2(13.5, float(ry)), 0.8, COLOR_INFRASTRUCTURE)
	
	# Door panel in graphite slate
	var door_rect := Rect2(-12.0, -24.0, 24.0, 50.0)
	ci.draw_rect(door_rect, Color("1a242c"))
	
	# Vertical structural channel beams
	ci.draw_line(Vector2(-6.0, -24.0), Vector2(-6.0, 26.0), Color("2b3c48"), 1.2)
	ci.draw_line(Vector2(6.0, -24.0), Vector2(6.0, 26.0), Color("2b3c48"), 1.2)
	
	# Industrial ventilation louvers in upper section
	for ly in range(-20, -10, 3):
		ci.draw_line(Vector2(-9.0, float(ly)), Vector2(9.0, float(ly)), Color("11181d"), 1.0)
		ci.draw_line(Vector2(-9.0, float(ly) + 0.8), Vector2(9.0, float(ly) + 0.8), Color("324754"), 0.6)
	
	# Top Hazard Warning Strip (Yellow-Amber & Black diagonal stripes)
	var hazard_rect := Rect2(-15.0, -27.0, 30.0, 3.0)
	ci.draw_rect(hazard_rect, Color("14181a"))
	for hx in range(-14, 14, 4):
		ci.draw_line(Vector2(float(hx), -27.0), Vector2(float(hx) + 2.5, -24.0), COLOR_AMBER * 0.9, 1.0)
	
	# Consensus Lock Status Panel on right jamb at (10.0, -2.0)
	var panel_rect := Rect2(6.0, -4.0, 5.5, 10.0)
	ci.draw_rect(panel_rect, Color("11181e"))
	ci.draw_rect(panel_rect, COLOR_INFRASTRUCTURE, false, 0.8)
	
	var is_unlocked := p_is_activated
	if is_unlocked:
		# Glowing cyan consensus lock indicator (Passage open / stabilized)
		ci.draw_circle(Vector2(8.75, 1.0), 1.6, COLOR_CYAN)
		ci.draw_circle(Vector2(8.75, 1.0), 3.2, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35))
	else:
		# Pulsing cinnabar security lock indicator (Secured)
		var pulse := sin(p_pulse * 3.0) * 0.5 + 0.5
		ci.draw_circle(Vector2(8.75, 1.0), 1.6, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.5 + pulse * 0.5))


static func draw_observation_window(ci: CanvasItem) -> void:
	# Panoramic window in elevated technical corridor: 44x28 px
	var win_rect := Rect2(-22.0, -14.0, 44.0, 28.0)
	ci.draw_rect(win_rect, Color("0f1920"))
	
	# Dawn sky gradient & courtyard view
	ci.draw_rect(Rect2(-20.0, -12.0, 40.0, 16.0), Color("172733"))
	# Pale misty horizon glow
	ci.draw_line(Vector2(-20.0, 0.0), Vector2(20.0, 0.0), Color(0.4, 0.55, 0.65, 0.3), 1.0)
	# Distant courtyard silhouettes (trees/fence/lamppost)
	ci.draw_rect(Rect2(-16.0, -2.0, 4.0, 6.0), Color("0c141a"))
	ci.draw_line(Vector2(6.0, -8.0), Vector2(6.0, 4.0), Color("0c141a"), 1.0)
	ci.draw_circle(Vector2(6.0, -8.0), 1.5, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.4))
	
	# Window steel frame & mullions
	ci.draw_rect(win_rect, Color("2a3b45"), false, 1.5)
	ci.draw_line(Vector2(0.0, -14.0), Vector2(0.0, 14.0), Color("2a3b45"), 1.2)
	ci.draw_line(Vector2(-22.0, 2.0), Vector2(22.0, 2.0), Color("2a3b45"), 1.0)
	
	# Subtle glass diagonal reflection
	ci.draw_line(Vector2(-18.0, -10.0), Vector2(6.0, 10.0), Color(1.0, 1.0, 1.0, 0.15), 1.0)


static func draw_erased_doorway_trace(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Masonry wall patch with fading door outline: 30x42 px
	var wall_rect := Rect2(-15.0, -21.0, 30.0, 42.0)
	ci.draw_rect(wall_rect, Color("34241d")) # Brickwork base
	
	# Horizontal brick courses
	for y in range(-20, 20, 6):
		ci.draw_line(Vector2(-15.0, float(y)), Vector2(15.0, float(y)), Color("241812"), 0.8)
	
	# Vertical brick joints
	for y in range(-20, 20, 6):
		var offset := 0.0 if (y / 6) % 2 == 0 else 5.0
		for x in range(-12, 14, 10):
			ci.draw_line(Vector2(float(x) + offset, float(y)), Vector2(float(x) + offset, float(y) + 6.0), Color("241812"), 0.8)
	
	if not p_is_activated:
		# Ghost outline of former doorway seam (#geometry-restless-grid)
		var p := sin(p_pulse * 2.5) * 0.5 + 0.5
		var seam_col := Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.35 + p * 0.35)
		# Door frame arch / lintel
		ci.draw_line(Vector2(-10.0, 20.0), Vector2(-10.0, -12.0), seam_col, 1.2)
		ci.draw_line(Vector2(10.0, 20.0), Vector2(10.0, -12.0), seam_col, 1.2)
		ci.draw_line(Vector2(-10.0, -12.0), Vector2(10.0, -12.0), seam_col, 1.2)
		# Ghost keyway / handle notch
		ci.draw_circle(Vector2(8.0, 4.0), 1.2, seam_col)
	else:
		# Completely smoothed, stabilized brick plane with subtle cyan settling alignment
		ci.draw_rect(wall_rect, Color("36261f"), false, 0.8)
		var p_cyan := sin(p_pulse * 1.5) * 0.2 + 0.2
		ci.draw_line(Vector2(-15.0, 21.0), Vector2(15.0, 21.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, p_cyan), 1.0)


static func draw_ucp_intervention_team(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Two UCP operators in institutional suits: 36x28 px
	# Operator 1 (Left, holding stabilization apparatus)
	# Legs
	ci.draw_rect(Rect2(-14.0, 3.0, 3.0, 11.0), Color("1e2930"))
	ci.draw_rect(Rect2(-9.0, 3.0, 3.0, 11.0), Color("1e2930"))
	# Torso & Institutional Coat (#A8B2AC)
	ci.draw_rect(Rect2(-16.0, -7.0, 11.0, 11.0), Color("42555f"))
	ci.draw_rect(Rect2(-16.0, -7.0, 11.0, 11.0), COLOR_INFRASTRUCTURE * 0.6, false, 0.8)
	# Head
	ci.draw_circle(Vector2(-10.5, -11.0), 3.0, Color("1e2930"))
	# Field stabilizer unit in hand
	var unit_rect := Rect2(-5.0, -5.0, 7.0, 8.0)
	ci.draw_rect(unit_rect, COLOR_DARK_STEEL)
	ci.draw_rect(unit_rect, COLOR_INFRASTRUCTURE, false, 0.8)
	# Probe antenna
	ci.draw_line(Vector2(2.0, -1.0), Vector2(7.0, -1.0), COLOR_INFRASTRUCTURE, 1.0)
	# Active cyan emitter diode on probe
	var pulse := sin(p_pulse * 4.0) * 0.5 + 0.5
	var diode_col := COLOR_CYAN if p_is_activated else Color(0.3, 0.6, 0.6)
	ci.draw_circle(Vector2(7.0, -1.0), 1.5, diode_col)
	ci.draw_circle(Vector2(7.0, -1.0), 3.0, Color(diode_col.r, diode_col.g, diode_col.b, pulse * 0.35))

	# Operator 2 (Right, escorting / open posture)
	# Legs
	ci.draw_rect(Rect2(9.0, 3.0, 3.0, 11.0), Color("1e2930"))
	ci.draw_rect(Rect2(14.0, 3.0, 3.0, 11.0), Color("1e2930"))
	# Torso & Coat
	ci.draw_rect(Rect2(7.0, -7.0, 11.0, 11.0), Color("42555f"))
	ci.draw_rect(Rect2(7.0, -7.0, 11.0, 11.0), COLOR_INFRASTRUCTURE * 0.6, false, 0.8)
	# Head
	ci.draw_circle(Vector2(12.5, -11.0), 3.0, Color("1e2930"))
	# Guiding arm
	ci.draw_line(Vector2(8.0, -2.0), Vector2(1.0, 2.0), Color("42555f"), 1.5)


static func draw_elderly_resident_guide(ci: CanvasItem) -> void:
	# Disoriented elderly resident in wool coat and headscarf: 16x26 px
	# Long brown wool coat
	var coat_rect := Rect2(-6.0, -5.0, 12.0, 16.0)
	ci.draw_rect(coat_rect, Color("3e3128"))
	ci.draw_rect(coat_rect, Color("261d17"), false, 0.8)
	# Boots
	ci.draw_rect(Rect2(-5.0, 11.0, 4.0, 3.0), Color("18120d"))
	ci.draw_rect(Rect2(1.0, 11.0, 4.0, 3.0), Color("18120d"))
	# Headscarf & head
	ci.draw_circle(Vector2(0.0, -8.5), 3.5, Color("4a3c30"))
	ci.draw_circle(Vector2(0.0, -8.0), 2.2, COLOR_AMBER * 0.8) # Face profile
	# Old brass apartment key in hand
	ci.draw_circle(Vector2(6.0, 2.0), 1.0, COLOR_AMBER)
	ci.draw_line(Vector2(6.0, 2.0), Vector2(9.0, 2.0), COLOR_AMBER, 1.0)


static func draw_marta_observation_dialogue(ci: CanvasItem) -> void:
	# Marta Kurek standing at gallery railing observing: 20x30 px
	# Work trousers
	ci.draw_rect(Rect2(-6.0, 4.0, 4.0, 11.0), Color("2b3a33"))
	ci.draw_rect(Rect2(2.0, 4.0, 4.0, 11.0), Color("2b3a33"))
	# Work jacket (Sage/Brown with chalk marks)
	var jacket_rect := Rect2(-8.0, -8.0, 16.0, 13.0)
	ci.draw_rect(jacket_rect, Color("4a3a2d"))
	ci.draw_rect(jacket_rect, Color("2d221a"), false, 0.8)
	# Canvas tool bag across shoulder
	ci.draw_line(Vector2(-7.0, -8.0), Vector2(6.0, 2.0), Color("6e5944"), 2.0)
	ci.draw_rect(Rect2(5.0, 0.0, 5.0, 6.0), Color("6e5944"))
	# Folding rule in breast pocket (Yellow line)
	ci.draw_line(Vector2(-5.0, -6.0), Vector2(-2.0, -2.0), Color("c9a638"), 1.2)
	# Long pink hair, face and the small steel septum: Marta's durable silhouette.
	var marta_hair_shadow := Color("6d294f")
	var marta_hair_pink := Color("d45b9a")
	ci.draw_circle(Vector2(0.0, -12.0), 4.2, marta_hair_shadow)
	ci.draw_rect(Rect2(-4.0, -11.0, 2.5, 12.0), marta_hair_shadow)
	ci.draw_rect(Rect2(1.5, -11.0, 2.5, 12.0), marta_hair_shadow)
	ci.draw_circle(Vector2(0.0, -12.0), 3.0, Color("d39a62"))
	ci.draw_line(Vector2(-3.5, -15.0), Vector2(2.6, -16.0), marta_hair_pink, 1.8)
	ci.draw_line(Vector2(-3.0, -9.5), Vector2(-3.0, 1.0), marta_hair_pink, 1.3)
	ci.draw_line(Vector2(2.6, -9.5), Vector2(2.6, 1.0), marta_hair_pink, 1.3)
	ci.draw_arc(Vector2(0.8, -10.8), 0.85, 0.15, PI - 0.15, 5, Color("c7d3d6"), 0.7)
	# Hands resting on gallery railing
	ci.draw_circle(Vector2(-4.0, 1.0), 1.5, COLOR_AMBER)
	ci.draw_circle(Vector2(4.0, 1.0), 1.5, COLOR_AMBER)


static func draw_courtyard_exit_airlock(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy courtyard exit portal & gate leading to Space 12: 32x54 px
	var frame_rect := Rect2(-16.0, -27.0, 32.0, 54.0)
	ci.draw_rect(frame_rect, COLOR_DARK_STEEL)
	ci.draw_rect(frame_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Recessed doorway aperture
	var door_rect := Rect2(-12.0, -23.0, 24.0, 50.0)
	ci.draw_rect(door_rect, Color("0b1216"))
	
	# Steel gate slats
	for sy in range(-19, 26, 6):
		ci.draw_line(Vector2(-11.0, float(sy)), Vector2(11.0, float(sy)), Color("22323d"), 1.5)
	
	# Hazard top stripe
	var haz_rect := Rect2(-16.0, -27.0, 32.0, 3.0)
	ci.draw_rect(haz_rect, Color("14181a"))
	for hx in range(-15, 15, 4):
		ci.draw_line(Vector2(float(hx), -27.0), Vector2(float(hx) + 2.5, -24.0), COLOR_AMBER * 0.9, 1.0)
	
	# Status Indicator
	var is_open := p_is_activated
	if is_open:
		ci.draw_circle(Vector2(0.0, -24.5), 2.0, COLOR_CYAN)
		ci.draw_circle(Vector2(0.0, -24.5), 4.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35))
	else:
		var pulse := sin(p_pulse * 3.0) * 0.5 + 0.5
		ci.draw_circle(Vector2(0.0, -24.5), 2.0, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.6 + pulse * 0.4))


static func draw_ucp_info_terminal(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Industrial CRT Information & Clearance Workstation: 26x36 px
	# Heavy steel pedestal base
	var base_rect := Rect2(-11.0, 10.0, 22.0, 6.0)
	ci.draw_rect(base_rect, Color("202c34"))
	ci.draw_rect(base_rect, COLOR_DARK_STEEL, false, 0.8)
	
	# Pedestal column with ventilation slats
	var col_rect := Rect2(-5.0, -5.0, 10.0, 15.0)
	ci.draw_rect(col_rect, Color("2d3d47"))
	ci.draw_rect(col_rect, Color("1a242a"), false, 0.8)
	for vy in range(-2, 8, 3):
		ci.draw_line(Vector2(-3.5, float(vy)), Vector2(3.5, float(vy)), Color("161f24"), 1.0)
	
	# Angled CRT terminal chassis housing
	var chassis_rect := Rect2(-13.0, -23.0, 26.0, 18.0)
	ci.draw_rect(chassis_rect, Color("25343d"))
	ci.draw_rect(chassis_rect, COLOR_INFRASTRUCTURE, false, 1.0)
	
	# CRT Monitor screen aperture
	var screen_rect := Rect2(-10.0, -20.0, 20.0, 12.0)
	ci.draw_rect(screen_rect, Color("0b1318"))
	
	# Phosphor monitor glow & raster lines
	var is_open := p_is_activated
	if is_open:
		# Level 3 clearance validated: bright cyan phosphor scanlines
		ci.draw_rect(screen_rect, Color(0.12, 0.32, 0.35, 0.45))
		ci.draw_rect(Rect2(-8.0, -18.0, 16.0, 2.0), COLOR_CYAN * 0.9)
		ci.draw_rect(Rect2(-8.0, -14.0, 12.0, 1.5), COLOR_CYAN * 0.7)
		ci.draw_rect(Rect2(-8.0, -11.0, 14.0, 1.5), COLOR_CYAN * 0.7)
		# Clearance badge icon [L-3]
		ci.draw_rect(Rect2(4.0, -14.0, 4.0, 4.0), COLOR_AMBER * 0.9)
	else:
		# Idle institutional status display
		var pulse := sin(p_pulse * 2.5) * 0.5 + 0.5
		ci.draw_rect(Rect2(-8.0, -18.0, 16.0, 1.5), COLOR_INFRASTRUCTURE * 0.6)
		ci.draw_rect(Rect2(-8.0, -14.0, 10.0, 1.2), COLOR_INFRASTRUCTURE * 0.4)
		ci.draw_rect(Rect2(-8.0, -11.0, 7.0, 1.2), COLOR_INFRASTRUCTURE * 0.4)
		# Blinking cursor
		if pulse > 0.4:
			ci.draw_rect(Rect2(0.0, -11.0, 2.0, 2.0), COLOR_AMBER)
	
	# Angled mechanical keyboard deck
	var kb_rect := Rect2(-12.0, -5.0, 24.0, 5.0)
	ci.draw_rect(kb_rect, Color("1e2a32"))
	ci.draw_rect(kb_rect, Color("394d5a"), false, 0.8)
	# Key rows
	for kx in range(-10, 11, 3):
		ci.draw_line(Vector2(float(kx), -3.5), Vector2(float(kx) + 1.5, -3.5), Color("455c6b"), 1.0)
		ci.draw_line(Vector2(float(kx), -1.5), Vector2(float(kx) + 1.5, -1.5), Color("455c6b"), 1.0)
	
	# Badge card reader slot & status LED
	ci.draw_line(Vector2(9.0, -18.0), Vector2(9.0, -12.0), Color("121a1f"), 1.2)
	var led_col := COLOR_CYAN if is_open else (COLOR_AMBER if sin(p_pulse * 3.0) > 0.0 else COLOR_CORRECTION)
	ci.draw_circle(Vector2(9.0, -20.5), 1.2, led_col)


static func draw_showcase_vitrine(ci: CanvasItem) -> void:
	# Backlit Institutional Compliance Vitrine: 34x46 px
	# Wall-mounted aluminium frame
	var frame_rect := Rect2(-17.0, -23.0, 34.0, 46.0)
	ci.draw_rect(frame_rect, Color("2d3d46"))
	ci.draw_rect(frame_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Illuminated translucent interior panel
	var panel_rect := Rect2(-14.0, -20.0, 28.0, 40.0)
	ci.draw_rect(panel_rect, Color("c2cec8"))
	
	# Header label: "DZIAŁ ZGODNOŚCI UCP"
	ci.draw_rect(Rect2(-12.0, -18.5, 24.0, 4.0), Color("1e2b33"))
	ci.draw_line(Vector2(-10.0, -16.5), Vector2(10.0, -16.5), COLOR_CYAN * 0.8, 1.0)
	
	# Document 1 (Compliance Form / Wniosek): Top left
	var doc1 := Rect2(-12.0, -12.0, 11.0, 15.0)
	ci.draw_rect(doc1, Color("edf2ee"))
	ci.draw_rect(doc1, Color("9eada6"), false, 0.6)
	# Red official stamp in corner
	ci.draw_rect(Rect2(-11.0, -11.0, 3.0, 3.0), COLOR_CORRECTION * 0.85)
	# Text lines
	ci.draw_line(Vector2(-10.0, -6.0), Vector2(-3.0, -6.0), Color("4a5952"), 0.8)
	ci.draw_line(Vector2(-10.0, -3.0), Vector2(-4.0, -3.0), Color("4a5952"), 0.8)
	ci.draw_line(Vector2(-10.0, 0.0), Vector2(-5.0, 0.0), Color("4a5952"), 0.8)
	
	# Document 2 (Evacuation / Safety Protocol): Top right
	var doc2 := Rect2(1.0, -12.0, 11.0, 15.0)
	ci.draw_rect(doc2, Color("edf2ee"))
	ci.draw_rect(doc2, Color("9eada6"), false, 0.6)
	# Header diagram icon
	ci.draw_line(Vector2(3.0, -10.0), Vector2(10.0, -10.0), COLOR_CYAN * 0.8, 1.0)
	ci.draw_line(Vector2(3.0, -7.0), Vector2(9.0, -7.0), Color("4a5952"), 0.8)
	ci.draw_line(Vector2(3.0, -4.0), Vector2(8.0, -4.0), Color("4a5952"), 0.8)
	ci.draw_line(Vector2(3.0, -1.0), Vector2(10.0, -1.0), Color("4a5952"), 0.8)
	
	# Document 3 (Wide Discrepancy Registry Form): Bottom
	var doc3 := Rect2(-12.0, 6.0, 24.0, 11.0)
	ci.draw_rect(doc3, Color("e4ebe6"))
	ci.draw_rect(doc3, Color("9eada6"), false, 0.6)
	# Table grid
	ci.draw_line(Vector2(-10.0, 9.5), Vector2(10.0, 9.5), Color("3d4e46"), 0.8)
	ci.draw_line(Vector2(-10.0, 13.0), Vector2(10.0, 13.0), Color("6c7d75"), 0.8)
	ci.draw_line(Vector2(-2.0, 7.0), Vector2(-2.0, 16.0), Color("6c7d75"), 0.8)
	ci.draw_line(Vector2(5.0, 7.0), Vector2(5.0, 16.0), Color("6c7d75"), 0.8)
	
	# Glass reflection sheen
	ci.draw_line(Vector2(-12.0, -18.0), Vector2(12.0, 16.0), Color(1.0, 1.0, 1.0, 0.22), 1.0)
	
	# Bottom fluorescent tube
	ci.draw_rect(Rect2(-13.0, 18.0, 26.0, 1.5), Color(0.9, 0.95, 0.95, 0.9))


static func draw_instruction_poster(ci: CanvasItem) -> void:
	# Institutional Poster: "PAMIĘĆ TO NIE POMIAR" (26x36 px)
	# Poster plate
	var poster_rect := Rect2(-13.0, -18.0, 26.0, 36.0)
	ci.draw_rect(poster_rect, Color("d5ded9"))
	ci.draw_rect(poster_rect, COLOR_DARK_STEEL, false, 1.0)
	
	# Top Banner
	var banner_rect := Rect2(-12.0, -17.0, 24.0, 6.0)
	ci.draw_rect(banner_rect, Color("1a252c"))
	# Banner icon: consensus divergence split
	ci.draw_line(Vector2(-8.0, -14.0), Vector2(-3.0, -14.0), COLOR_CYAN, 1.0)
	ci.draw_circle(Vector2(-2.0, -14.0), 1.2, COLOR_AMBER)
	ci.draw_line(Vector2(-1.0, -14.0), Vector2(8.0, -14.0), COLOR_CYAN, 1.0)
	
	# Key Graphic Headline: "PAMIĘĆ TO NIE POMIAR"
	ci.draw_rect(Rect2(-10.0, -8.5, 20.0, 3.0), Color("162026"))
	ci.draw_rect(Rect2(-10.0, -4.0, 20.0, 3.0), Color("162026"))
	
	# Horizontal separator in oxide cinnabar
	ci.draw_line(Vector2(-10.0, 1.0), Vector2(10.0, 1.0), COLOR_CORRECTION * 0.9, 1.2)
	
	# Subtext: "ZGŁOŚ ROZBIEŻNOŚĆ W PUNKCIE 6"
	ci.draw_line(Vector2(-9.0, 4.0), Vector2(8.0, 4.0), Color("3a4c54"), 0.9)
	ci.draw_line(Vector2(-9.0, 7.0), Vector2(9.0, 7.0), Color("3a4c54"), 0.9)
	ci.draw_line(Vector2(-9.0, 10.0), Vector2(4.0, 10.0), Color("3a4c54"), 0.9)
	
	# Official circular verification seal
	ci.draw_circle(Vector2(6.5, 12.5), 2.5, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.75))
	ci.draw_circle(Vector2(6.5, 12.5), 1.5, Color("d5ded9"))


static func draw_subway_tile_pillar(ci: CanvasItem) -> void:
	# Subterranean Subway Ceramic Tile Pillar: 28x58 px
	var pillar_rect := Rect2(-14.0, -29.0, 28.0, 58.0)
	ci.draw_rect(pillar_rect, Color("35464f"))
	ci.draw_rect(pillar_rect, Color("1f2a30"), false, 1.2)
	
	# Gloss ceramic tile grid
	for ty in range(-25, 26, 7):
		ci.draw_line(Vector2(-13.0, float(ty)), Vector2(13.0, float(ty)), Color("222f36"), 1.0)
	for ty in range(-25, 26, 14):
		ci.draw_line(Vector2(-5.0, float(ty)), Vector2(-5.0, float(ty) + 7.0), Color("222f36"), 1.0)
		ci.draw_line(Vector2(5.0, float(ty)), Vector2(5.0, float(ty) + 7.0), Color("222f36"), 1.0)
		ci.draw_line(Vector2(0.0, float(ty) + 7.0), Vector2(0.0, float(ty) + 14.0), Color("222f36"), 1.0)
	
	# Enamelled Transit Route Map Plaque
	var map_rect := Rect2(-11.0, -18.0, 22.0, 30.0)
	ci.draw_rect(map_rect, Color("11181d"))
	ci.draw_rect(map_rect, COLOR_INFRASTRUCTURE, false, 0.8)
	
	# Header on plaque
	ci.draw_rect(Rect2(-9.0, -16.0, 18.0, 3.0), Color("23323c"))
	ci.draw_line(Vector2(-7.0, -14.5), Vector2(7.0, -14.5), COLOR_CYAN * 0.9, 1.0)
	
	# Transit lines on map
	# Line 4 (Tram Route - Amber)
	ci.draw_line(Vector2(-7.0, -10.0), Vector2(3.0, -5.0), COLOR_AMBER * 0.9, 1.5)
	ci.draw_line(Vector2(3.0, -5.0), Vector2(7.0, 2.0), COLOR_AMBER * 0.9, 1.5)
	ci.draw_circle(Vector2(-7.0, -10.0), 1.2, COLOR_AMBER)
	ci.draw_circle(Vector2(3.0, -5.0), 1.2, COLOR_AMBER)
	ci.draw_circle(Vector2(7.0, 2.0), 1.2, COLOR_AMBER)
	
	# Substructure Route (Cyan - Direct path to Point 6)
	ci.draw_line(Vector2(-7.0, 0.0), Vector2(7.0, 0.0), COLOR_CYAN, 1.5)
	ci.draw_circle(Vector2(0.0, 0.0), 1.5, COLOR_CYAN)
	
	# Arrow: "PUNKT 6 ->"
	ci.draw_line(Vector2(-6.0, 7.0), Vector2(4.0, 7.0), COLOR_CYAN, 1.2)
	ci.draw_line(Vector2(2.0, 5.0), Vector2(5.0, 7.0), COLOR_CYAN, 1.2)
	ci.draw_line(Vector2(2.0, 9.0), Vector2(5.0, 7.0), COLOR_CYAN, 1.2)
	
	# Base hazard kickplate
	var kick_rect := Rect2(-14.0, 24.0, 28.0, 4.0)
	ci.draw_rect(kick_rect, Color("14181a"))
	for hx in range(-13, 13, 4):
		ci.draw_line(Vector2(float(hx), 24.0), Vector2(float(hx) + 2.5, 28.0), COLOR_AMBER * 0.85, 1.0)


static func draw_underpass_exit_gate(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy Subterranean Underpass Security Gate: 36x58 px
	var frame_rect := Rect2(-18.0, -29.0, 36.0, 58.0)
	ci.draw_rect(frame_rect, Color("223038"))
	ci.draw_rect(frame_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Recessed tunnel archway
	var arch_rect := Rect2(-14.0, -24.0, 28.0, 53.0)
	ci.draw_rect(arch_rect, Color("0a1014"))
	
	# Retractable steel security lattice bars
	for sy in range(-20, 27, 5):
		ci.draw_line(Vector2(-13.0, float(sy)), Vector2(13.0, float(sy)), Color("2a3b45"), 1.2)
	for sx in range(-10, 11, 6):
		ci.draw_line(Vector2(float(sx), -22.0), Vector2(float(sx), 27.0), Color("324551"), 1.2)
	
	# Illuminated overhead header sign plate
	var sign_rect := Rect2(-16.0, -28.0, 32.0, 5.0)
	ci.draw_rect(sign_rect, Color("162026"))
	ci.draw_line(Vector2(-14.0, -25.5), Vector2(14.0, -25.5), COLOR_CYAN * 0.85, 1.0)
	
	# Status Indicator Beacon
	var is_open := p_is_activated
	if is_open:
		ci.draw_circle(Vector2(0.0, -21.0), 2.2, COLOR_CYAN)
		ci.draw_circle(Vector2(0.0, -21.0), 5.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35))
	else:
		var pulse := sin(p_pulse * 3.0) * 0.5 + 0.5
		ci.draw_circle(Vector2(0.0, -21.0), 2.2, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.6 + pulse * 0.4))


static func draw_drafting_table(ci: CanvasItem, p_pulse: float) -> void:
	# Large backlit drafting table: 54x38 px, angled top
	# Base structural steel legs and foot pedal
	ci.draw_line(Vector2(-20.0, 18.0), Vector2(-15.0, -4.0), COLOR_DARK_STEEL, 2.5)
	ci.draw_line(Vector2(20.0, 18.0), Vector2(15.0, -4.0), COLOR_DARK_STEEL, 2.5)
	ci.draw_line(Vector2(-22.0, 18.0), Vector2(22.0, 18.0), COLOR_DARK_STEEL, 2.0)
	ci.draw_line(Vector2(-16.0, 8.0), Vector2(16.0, 8.0), Color("1a242a"), 1.5)
	
	# Main inclined drafting board chassis: 48x28 px tilted
	var board_rect := Rect2(-24.0, -18.0, 48.0, 24.0)
	ci.draw_rect(board_rect, Color("202c34"))
	ci.draw_rect(board_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Backlit translucent glass work area: 40x18 px
	var glass_rect := Rect2(-20.0, -15.0, 40.0, 18.0)
	var glow_alpha := 0.25 + 0.15 * sin(p_pulse * 1.5)
	ci.draw_rect(glass_rect, Color(0.20, 0.35, 0.38, glow_alpha + 0.3))
	ci.draw_rect(glass_rect, COLOR_CYAN * 0.7, false, 0.8)
	
	# Blueprint overlay: Flat 14 floorplan & circuit matrix
	# Technical room grid
	ci.draw_rect(Rect2(-17.0, -13.0, 14.0, 14.0), Color(0.12, 0.22, 0.25, 0.6))
	ci.draw_rect(Rect2(-17.0, -13.0, 14.0, 14.0), COLOR_CYAN * 0.9, false, 0.8)
	# Corridor and Room 2
	ci.draw_rect(Rect2(-1.0, -13.0, 17.0, 7.0), Color(0.12, 0.22, 0.25, 0.6))
	ci.draw_rect(Rect2(-1.0, -13.0, 17.0, 7.0), COLOR_CYAN * 0.9, false, 0.8)
	ci.draw_rect(Rect2(-1.0, -4.0, 17.0, 5.0), Color(0.12, 0.22, 0.25, 0.6))
	ci.draw_rect(Rect2(-1.0, -4.0, 17.0, 5.0), COLOR_CYAN * 0.9, false, 0.8)
	
	# Circuit node connection traces (linking furniture coordinates to substructure)
	ci.draw_line(Vector2(-10.0, -6.0), Vector2(7.0, -6.0), COLOR_AMBER * 0.85, 1.0)
	ci.draw_line(Vector2(7.0, -6.0), Vector2(7.0, -1.0), COLOR_AMBER * 0.85, 1.0)
	ci.draw_circle(Vector2(-10.0, -6.0), 1.2, COLOR_AMBER)
	ci.draw_circle(Vector2(7.0, -1.0), 1.2, COLOR_AMBER)
	# Missing key / photo socket indicator (dotted square)
	ci.draw_rect(Rect2(9.0, -11.0, 5.0, 4.0), COLOR_AMBER, false, 1.0)
	
	# Parallel ruler / drafting arm across the board
	ci.draw_line(Vector2(-23.0, -2.0), Vector2(23.0, -2.0), Color("445b68"), 2.0)
	ci.draw_line(Vector2(-23.0, -2.0), Vector2(23.0, -2.0), Color("7e94a0"), 0.8)
	# Protractor head at top-left
	ci.draw_circle(Vector2(-18.0, -2.0), 3.0, COLOR_DARK_STEEL)
	ci.draw_circle(Vector2(-18.0, -2.0), 1.5, COLOR_INFRASTRUCTURE)
	
	# Clamp lamp on top right corner
	ci.draw_line(Vector2(20.0, -18.0), Vector2(16.0, -24.0), COLOR_DARK_STEEL, 1.5)
	ci.draw_line(Vector2(16.0, -24.0), Vector2(12.0, -22.0), COLOR_DARK_STEEL, 1.5)
	var lamp_head := Rect2(8.0, -24.0, 6.0, 4.0)
	ci.draw_rect(lamp_head, Color("2d3d46"))
	ci.draw_circle(Vector2(10.0, -20.0), 2.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.85))
	ci.draw_circle(Vector2(10.0, -20.0), 6.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.25))


static func draw_topography_index_cabinet(ci: CanvasItem) -> void:
	# Heavy steel map & index filing cabinet: 32x54 px
	var frame_rect := Rect2(-16.0, -27.0, 32.0, 54.0)
	ci.draw_rect(frame_rect, Color("25343d"))
	ci.draw_rect(frame_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Top classification banner / brass plate
	var banner_rect := Rect2(-14.0, -25.0, 28.0, 5.0)
	ci.draw_rect(banner_rect, Color("141b20"))
	ci.draw_line(Vector2(-12.0, -22.5), Vector2(12.0, -22.5), COLOR_CYAN * 0.85, 1.0)
	
	# 4 wide drawer sections
	for dy in range(4):
		var y_top: float = -18.0 + float(dy) * 10.5
		var drawer_rect := Rect2(-14.0, y_top, 28.0, 9.0)
		ci.draw_rect(drawer_rect, Color("1e2a31"))
		ci.draw_rect(drawer_rect, Color("364a55"), false, 0.8)
		
		# Brass label frame and pull handle
		var label_rect := Rect2(-7.0, y_top + 2.0, 14.0, 4.0)
		ci.draw_rect(label_rect, Color("111619"))
		ci.draw_rect(label_rect, COLOR_AMBER * 0.7, false, 0.6)
		ci.draw_line(Vector2(-5.0, y_top + 4.0), Vector2(5.0, y_top + 4.0), COLOR_INFRASTRUCTURE * 0.8, 0.8)
		# Pull handle below label
		ci.draw_line(Vector2(-6.0, y_top + 7.0), Vector2(6.0, y_top + 7.0), COLOR_INFRASTRUCTURE, 1.2)
	
	# Top drawer is slightly open showing aperture/index cards
	var open_tray := Rect2(-15.0, -19.0, 30.0, 3.0)
	ci.draw_rect(open_tray, Color("162026"))
	# Index cards peeking out
	for cx in range(-12, 12, 3):
		ci.draw_line(Vector2(float(cx), -19.0), Vector2(float(cx), -21.0), COLOR_AMBER * 0.85, 1.0)
	
	# Base pedestal
	ci.draw_rect(Rect2(-16.0, 24.0, 32.0, 3.0), Color("182025"))


static func draw_jakub_photograph_frame(ci: CanvasItem, p_is_activated: bool, p_pulse: float, p_shadow: float) -> void:
	# Precision optical mounting cradle: 32x26 px
	var cradle_rect := Rect2(-16.0, -13.0, 32.0, 26.0)
	ci.draw_rect(cradle_rect, Color("1a252c"))
	ci.draw_rect(cradle_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Corner mounting registration brackets
	var s: float = 14.0
	var l: float = 3.0
	ci.draw_line(Vector2(-s, -11.0), Vector2(-s + l, -11.0), COLOR_AMBER, 1.0)
	ci.draw_line(Vector2(-s, -11.0), Vector2(-s, -11.0 + l), COLOR_AMBER, 1.0)
	ci.draw_line(Vector2(s, -11.0), Vector2(s - l, -11.0), COLOR_AMBER, 1.0)
	ci.draw_line(Vector2(s, -11.0), Vector2(s, -11.0 + l), COLOR_AMBER, 1.0)
	ci.draw_line(Vector2(-s, 11.0), Vector2(-s + l, 11.0), COLOR_AMBER, 1.0)
	ci.draw_line(Vector2(-s, 11.0), Vector2(-s, 11.0 - l), COLOR_AMBER, 1.0)
	ci.draw_line(Vector2(s, 11.0), Vector2(s - l, 11.0), COLOR_AMBER, 1.0)
	ci.draw_line(Vector2(s, 11.0), Vector2(s, 11.0 - l), COLOR_AMBER, 1.0)
	
	var is_inserted := p_is_activated or p_shadow > 0.0
	if not is_inserted:
		# Empty optical slot with guide crosshairs
		var slot_rect := Rect2(-12.0, -9.0, 24.0, 18.0)
		ci.draw_rect(slot_rect, Color("0f1519"))
		ci.draw_rect(slot_rect, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.4), false, 0.8)
		# Registration crosshair
		ci.draw_line(Vector2(-4.0, 0.0), Vector2(4.0, 0.0), COLOR_CYAN * 0.7, 0.8)
		ci.draw_line(Vector2(0.0, -4.0), Vector2(0.0, 4.0), COLOR_CYAN * 0.7, 0.8)
		# Missing key prompt pulse
		var pulse := sin(p_pulse * 2.5) * 0.5 + 0.5
		ci.draw_rect(slot_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, pulse * 0.15))
	else:
		# Mounted photographic paper (24x18 px)
		var photo_rect := Rect2(-12.0, -9.0, 24.0, 18.0)
		ci.draw_rect(photo_rect, Color("dcd2bd")) # Warm sepia/cream base
		ci.draw_rect(photo_rect, Color("5c5446"), false, 0.6)
		
		# Lena silhouette figure on the left (x=-7..-4, y=-6..4)
		ci.draw_rect(Rect2(-8.0, -2.0, 4.0, 6.0), Color("2e3438")) # Body
		ci.draw_circle(Vector2(-6.0, -4.0), 2.0, Color("353d42")) # Head
		
		# Young Jakub silhouette in center (x=-3..1, y=-6..4)
		ci.draw_rect(Rect2(-3.0, -1.0, 4.0, 5.0), Color("3a4247")) # Body
		ci.draw_circle(Vector2(-1.0, -3.5), 1.8, Color("434c52")) # Head
		
		# Right third of photograph: Anomalous adult shadow emerging!
		var sp := clampf(maxf(p_shadow, 1.0 if p_is_activated else 0.0), 0.0, 1.0)
		if sp > 0.01:
			var shadow_alpha := clampf(sp * 0.90, 0.0, 0.95)
			var shadow_color := Color(0.06, 0.08, 0.10, shadow_alpha)
			var border_color := Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, shadow_alpha * 0.5)
			
			# Adult tall silhouette emerging behind & right of Jakub
			var adult_head := Vector2(4.0, -6.0)
			var adult_body := Rect2(2.0, -3.0, 6.0, 9.0)
			ci.draw_rect(adult_body, shadow_color)
			ci.draw_rect(adult_body, border_color, false, 0.6)
			ci.draw_circle(adult_head, 2.5, shadow_color)
			ci.draw_circle(adult_head, 2.5, border_color)
			
			# Shadow aura / vignette encroaching onto the frame
			ci.draw_line(Vector2(2.0, 6.0), Vector2(10.0, 6.0), border_color, 1.0)


static func draw_resonance_circuit_node(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy wall-mounted junction box: 34x44 px
	var box_rect := Rect2(-17.0, -22.0, 34.0, 44.0)
	ci.draw_rect(box_rect, Color("202d35"))
	ci.draw_rect(box_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Ceramic insulator standoffs top and bottom
	ci.draw_rect(Rect2(-12.0, -25.0, 6.0, 4.0), Color("3a4d57"))
	ci.draw_rect(Rect2(6.0, -25.0, 6.0, 4.0), Color("3a4d57"))
	ci.draw_rect(Rect2(-12.0, 21.0, 6.0, 4.0), Color("3a4d57"))
	ci.draw_rect(Rect2(6.0, 21.0, 6.0, 4.0), Color("3a4d57"))
	
	# Copper busbars entering top and exiting bottom/right
	ci.draw_line(Vector2(-9.0, -27.0), Vector2(-9.0, -16.0), COLOR_AMBER, 1.8)
	ci.draw_line(Vector2(9.0, -27.0), Vector2(9.0, -16.0), COLOR_AMBER, 1.8)
	ci.draw_line(Vector2(9.0, 16.0), Vector2(9.0, 27.0), COLOR_AMBER, 1.8)
	ci.draw_line(Vector2(17.0, 0.0), Vector2(23.0, 0.0), COLOR_AMBER, 2.0)
	
	# Dual Galvanometer meters
	# Meter 1: Vector / Address synchronization
	var meter1_rect := Rect2(-13.0, -16.0, 11.0, 11.0)
	ci.draw_rect(meter1_rect, Color("0d1316"))
	ci.draw_rect(meter1_rect, Color("394e5a"), false, 0.8)
	var needle1_angle: float = 0.85 if p_is_activated else (sin(p_pulse * 2.0) * 0.4 - 0.5)
	ci.draw_line(Vector2(-7.5, -7.0), Vector2(-7.5 + cos(needle1_angle) * 4.0, -7.0 - sin(needle1_angle) * 4.0), COLOR_CYAN, 1.0)
	
	# Meter 2: Personal constant / Resonance load
	var meter2_rect := Rect2(2.0, -16.0, 11.0, 11.0)
	ci.draw_rect(meter2_rect, Color("0d1316"))
	ci.draw_rect(meter2_rect, Color("394e5a"), false, 0.8)
	var needle2_angle: float = 0.95 if p_is_activated else (sin(p_pulse * 1.5 + 1.0) * 0.3 - 0.6)
	ci.draw_line(Vector2(7.5, -7.0), Vector2(7.5 + cos(needle2_angle) * 4.0, -7.0 - sin(needle2_angle) * 4.0), COLOR_AMBER, 1.0)
	
	# Stepping relay bank: 3 indicator lamps
	var lamp1_pos := Vector2(-8.0, 3.0)
	var lamp2_pos := Vector2(0.0, 3.0)
	var lamp3_pos := Vector2(8.0, 3.0)
	
	# Lamp 1: ADRES
	ci.draw_circle(lamp1_pos, 2.2, COLOR_CYAN if p_is_activated else Color("223b3f"))
	# Lamp 2: SPRZĘŻENIE
	ci.draw_circle(lamp2_pos, 2.2, COLOR_AMBER if p_is_activated else Color("3f3122"))
	# Lamp 3: BLOKADA (Red locked / Cyan unlocked)
	if p_is_activated:
		ci.draw_circle(lamp3_pos, 2.2, COLOR_CYAN)
		ci.draw_circle(lamp3_pos, 5.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.3))
	else:
		ci.draw_circle(lamp3_pos, 2.2, COLOR_CORRECTION)
	
	# Terminal connection strip at bottom
	var strip_rect := Rect2(-13.0, 10.0, 26.0, 8.0)
	ci.draw_rect(strip_rect, Color("141c21"))
	for tx in range(-10, 11, 5):
		ci.draw_circle(Vector2(float(tx), 14.0), 1.2, COLOR_INFRASTRUCTURE)


static func draw_tech_passage_airlock(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy maintenance airlock portal: 36x60 px
	var frame_rect := Rect2(-18.0, -30.0, 36.0, 60.0)
	ci.draw_rect(frame_rect, Color("223038"))
	ci.draw_rect(frame_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Heavy steel door panel
	var door_rect := Rect2(-14.0, -25.0, 28.0, 54.0)
	ci.draw_rect(door_rect, Color("151e24"))
	
	# Hazard diagonal stripes on upper lintel
	var lintel_rect := Rect2(-16.0, -29.0, 32.0, 4.0)
	ci.draw_rect(lintel_rect, Color("11171b"))
	for hx in range(-14, 14, 4):
		ci.draw_line(Vector2(float(hx), -29.0), Vector2(float(hx) + 2.5, -25.0), COLOR_AMBER * 0.85, 1.0)
	
	# Center hydraulic locking wheel
	ci.draw_circle(Vector2(0.0, 0.0), 7.0, Color("2d3d47"))
	ci.draw_circle(Vector2(0.0, 0.0), 7.0, COLOR_INFRASTRUCTURE, false, 1.0)
	ci.draw_circle(Vector2(0.0, 0.0), 2.5, COLOR_DARK_STEEL)
	# Locking spokes
	var spoke_rot := p_pulse if p_is_activated else 0.0
	for sp in range(4):
		var ang: float = spoke_rot + float(sp) * PI * 0.5
		ci.draw_line(Vector2(cos(ang) * 2.5, sin(ang) * 2.5), Vector2(cos(ang) * 6.5, sin(ang) * 6.5), COLOR_INFRASTRUCTURE, 1.2)
	
	# Pressure relief valve and hydraulic struts
	ci.draw_line(Vector2(-10.0, -18.0), Vector2(-10.0, 18.0), Color("2f404b"), 1.5)
	ci.draw_line(Vector2(10.0, -18.0), Vector2(10.0, 18.0), Color("2f404b"), 1.5)
	
	# Status Indicator Beacon above door
	var is_open := p_is_activated
	if is_open:
		ci.draw_circle(Vector2(0.0, -22.0), 2.2, COLOR_CYAN)
		ci.draw_circle(Vector2(0.0, -22.0), 5.5, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.40))
		# Illuminated floor threshold guide strip
		ci.draw_line(Vector2(-14.0, 28.0), Vector2(14.0, 28.0), COLOR_CYAN * 0.9, 1.5)
	else:
		var pulse := sin(p_pulse * 3.0) * 0.5 + 0.5
		ci.draw_circle(Vector2(0.0, -22.0), 2.2, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.6 + pulse * 0.4))


static func draw_metal_scratch_beam(ci: CanvasItem, p_is_activated: bool, p_shadow: float) -> void:
	# Heavy structural I-beam column: 26x70 px
	var beam_rect := Rect2(-13.0, -35.0, 26.0, 70.0)
	ci.draw_rect(beam_rect, Color("243138"))
	ci.draw_rect(beam_rect, COLOR_INFRASTRUCTURE * 0.85, false, 1.2)
	
	# Recessed inner web (I-beam profile)
	var web_rect := Rect2(-7.0, -30.0, 14.0, 60.0)
	ci.draw_rect(web_rect, Color("182228"))
	ci.draw_line(Vector2(-7.0, -30.0), Vector2(-7.0, 30.0), Color("2f404a"), 1.0)
	ci.draw_line(Vector2(7.0, -30.0), Vector2(7.0, 30.0), Color("2f404a"), 1.0)
	
	# Flange reinforcement plates & rivets top/bottom
	ci.draw_rect(Rect2(-14.0, -35.0, 28.0, 5.0), Color("2f404a"))
	ci.draw_rect(Rect2(-14.0, 30.0, 28.0, 5.0), Color("2f404a"))
	for rx in [-10.0, 10.0]:
		ci.draw_circle(Vector2(rx, -32.5), 1.2, COLOR_INFRASTRUCTURE)
		ci.draw_circle(Vector2(rx, 32.5), 1.2, COLOR_INFRASTRUCTURE)
		ci.draw_circle(Vector2(rx, -15.0), 1.0, Color("3a4f5c"))
		ci.draw_circle(Vector2(rx, 15.0), 1.0, Color("3a4f5c"))
	
	# The Observed Scratch in the Metal (Primary Anchor detail per Scene 14 & VISUAL_DESIGN 6.1)
	var is_anchored := p_is_activated or p_shadow > 0.1
	if is_anchored:
		# Cyan locked edge: "cyjan zatrzymuje jedną krawędź; reszta kadru lekko ciągnie ku niej"
		var cyan_glow := Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.45)
		# Scratch halo / stabilization zone
		ci.draw_circle(Vector2(0.5, -0.5), 9.0, cyan_glow * 0.35)
		ci.draw_line(Vector2(-8.0, -4.5), Vector2(9.0, 3.5), cyan_glow, 3.2)
		ci.draw_line(Vector2(-8.0, -4.5), Vector2(9.0, 3.5), COLOR_CYAN, 1.6)
		
		# Micro-crystallization tick marks anchoring the edge
		ci.draw_line(Vector2(-8.0, -7.0), Vector2(-8.0, -2.0), COLOR_CYAN, 1.0)
		ci.draw_line(Vector2(0.5, -3.0), Vector2(0.5, 2.0), COLOR_CYAN, 1.0)
		ci.draw_line(Vector2(9.0, 1.0), Vector2(9.0, 6.0), COLOR_CYAN, 1.0)
		
		# Subtle cyan tension lines connecting scratch to beam flanges
		ci.draw_line(Vector2(-8.0, -4.5), Vector2(-13.0, -4.5), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.3), 0.8)
		ci.draw_line(Vector2(9.0, 3.5), Vector2(13.0, 3.5), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.3), 0.8)
	else:
		# Unanchored scratch with slight physical wear and stress fringe
		ci.draw_line(Vector2(-7.5, -4.0), Vector2(8.5, 3.0), Color("8a9ca4"), 1.2)
		ci.draw_line(Vector2(-7.0, -3.5), Vector2(8.0, 3.5), Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.35), 0.8)


static func draw_tape_playback_deck(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Precision Reel-to-Reel Tape Player: 36x30 px
	var chassis_rect := Rect2(-18.0, -15.0, 36.0, 30.0)
	ci.draw_rect(chassis_rect, Color("1c252b"))
	ci.draw_rect(chassis_rect, COLOR_INFRASTRUCTURE * 0.75, false, 1.0)
	
	# Top brushed faceplate
	var face_rect := Rect2(-16.0, -13.0, 32.0, 26.0)
	ci.draw_rect(face_rect, Color("222f37"))
	
	# Left Reel (Supply Spool) at (-9, -4)
	var reel1_pos := Vector2(-9.0, -4.0)
	ci.draw_circle(reel1_pos, 6.5, Color("141c22"))
	ci.draw_circle(reel1_pos, 6.5, COLOR_INFRASTRUCTURE * 0.8, false, 0.8)
	ci.draw_circle(reel1_pos, 2.0, COLOR_AMBER * 0.9)
	# Right Reel (Takeup Spool) at (9, -4)
	var reel2_pos := Vector2(9.0, -4.0)
	ci.draw_circle(reel2_pos, 6.5, Color("141c22"))
	ci.draw_circle(reel2_pos, 6.5, COLOR_INFRASTRUCTURE * 0.8, false, 0.8)
	ci.draw_circle(reel2_pos, 2.0, COLOR_AMBER * 0.9)
	
	# Rotating reel spokes when tape is playing
	var rot := (p_pulse * 2.5) if p_is_activated else 0.0
	for sp in range(3):
		var ang: float = rot + float(sp) * (TAU / 3.0)
		var dir := Vector2(cos(ang), sin(ang))
		ci.draw_line(reel1_pos + dir * 2.0, reel1_pos + dir * 5.8, Color("3a4f5c"), 0.8)
		ci.draw_line(reel2_pos + dir * 2.0, reel2_pos + dir * 5.8, Color("3a4f5c"), 0.8)
	
	# Magnetic tape path running from reel 1 -> guide rollers -> head -> reel 2
	ci.draw_line(reel1_pos + Vector2(0.0, 6.0), Vector2(-4.0, 6.0), Color("584738"), 1.2) # Brown oxide tape
	ci.draw_line(Vector2(-4.0, 6.0), Vector2(4.0, 6.0), Color("584738"), 1.2)
	ci.draw_line(Vector2(4.0, 6.0), reel2_pos + Vector2(0.0, 6.0), Color("584738"), 1.2)
	
	# Playback Magnetic Head at center (0, 6)
	ci.draw_rect(Rect2(-2.5, 4.5, 5.0, 4.0), Color("2f3e48"))
	ci.draw_rect(Rect2(-2.5, 4.5, 5.0, 4.0), COLOR_INFRASTRUCTURE, false, 0.6)
	
	# VU Meter at bottom (-14..-2, y=8..12)
	var vu_rect := Rect2(-14.0, 8.0, 12.0, 4.5)
	ci.draw_rect(vu_rect, Color("0f1519"))
	ci.draw_rect(vu_rect, Color("334652"), false, 0.6)
	var vu_angle := 0.75 if p_is_activated else (sin(p_pulse * 3.0) * 0.3 - 0.4)
	ci.draw_line(Vector2(-8.0, 11.5), Vector2(-8.0 + cos(vu_angle) * 3.5, 11.5 - sin(vu_angle) * 3.5), COLOR_AMBER, 0.8)
	
	# Control buttons (Play / Stop / Reverse)
	for bx in range(2, 14, 4):
		ci.draw_rect(Rect2(float(bx), 8.5, 3.0, 3.5), Color("3a4d59"))
	
	# Degradation / Resonance indicator
	if p_is_activated:
		var pulse := sin(p_pulse * 4.0) * 0.5 + 0.5
		ci.draw_circle(Vector2(0.0, 6.0), 4.5, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, pulse * 0.25))


static func draw_maintenance_rack(ci: CanvasItem) -> void:
	# Slotted industrial steel shelving: 30x52 px
	var rack_rect := Rect2(-15.0, -26.0, 30.0, 52.0)
	
	# Vertical uprights
	ci.draw_line(Vector2(-15.0, -26.0), Vector2(-15.0, 26.0), COLOR_INFRASTRUCTURE * 0.9, 1.5)
	ci.draw_line(Vector2(15.0, -26.0), Vector2(15.0, 26.0), COLOR_INFRASTRUCTURE * 0.9, 1.5)
	
	# Shelf levels (Top, Middle, Bottom)
	ci.draw_line(Vector2(-15.0, -12.0), Vector2(15.0, -12.0), Color("2f404b"), 1.8)
	ci.draw_line(Vector2(-15.0, 6.0), Vector2(15.0, 6.0), Color("2f404b"), 1.8)
	ci.draw_line(Vector2(-15.0, 24.0), Vector2(15.0, 24.0), Color("2f404b"), 2.0)
	
	# Top shelf items: Precision continuity caliper & test probe
	ci.draw_line(Vector2(-10.0, -14.0), Vector2(-2.0, -14.0), COLOR_AMBER, 1.2)
	ci.draw_circle(Vector2(-10.0, -14.0), 1.5, COLOR_AMBER)
	ci.draw_line(Vector2(2.0, -14.0), Vector2(10.0, -16.0), COLOR_INFRASTRUCTURE, 1.0)
	
	# Middle shelf items: Hydraulic gasket box & gauge
	ci.draw_rect(Rect2(-11.0, -1.0, 10.0, 6.0), Color("24333c"))
	ci.draw_rect(Rect2(-11.0, -1.0, 10.0, 6.0), Color("3d5461"), false, 0.8)
	ci.draw_circle(Vector2(6.0, 2.0), 3.0, Color("1a242a"))
	ci.draw_circle(Vector2(6.0, 2.0), 3.0, COLOR_CYAN * 0.7, false, 0.8)
	
	# Bottom shelf items: Heavy alignment wrench & metal canister
	ci.draw_line(Vector2(-12.0, 20.0), Vector2(4.0, 20.0), Color("3d525f"), 2.0)
	ci.draw_rect(Rect2(6.0, 15.0, 6.0, 8.0), Color("223038"))
	ci.draw_rect(Rect2(6.0, 15.0, 6.0, 8.0), COLOR_INFRASTRUCTURE * 0.7, false, 0.8)


static func draw_seam_stabilizer_lever(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy cast-iron base: 24x36 px
	var base_rect := Rect2(-12.0, -18.0, 24.0, 36.0)
	ci.draw_rect(base_rect, Color("202c33"))
	ci.draw_rect(base_rect, COLOR_INFRASTRUCTURE * 0.85, false, 1.2)
	
	# Yellow/Black hazard diagonal stripes on bottom baseplate
	var hazard_rect := Rect2(-10.0, 10.0, 20.0, 6.0)
	ci.draw_rect(hazard_rect, Color("11171b"))
	for hx in range(-8, 8, 4):
		ci.draw_line(Vector2(float(hx), 10.0), Vector2(float(hx) + 2.5, 16.0), COLOR_AMBER * 0.8, 1.0)
	
	# Central hydraulic piston shaft
	ci.draw_rect(Rect2(-4.0, -10.0, 8.0, 18.0), Color("151e23"))
	ci.draw_rect(Rect2(-3.0, -8.0, 6.0, 14.0), Color("314450"))
	
	# Mechanical lever arm with pivot at (0, 0)
	var is_locked := p_is_activated
	var lever_ang := 0.65 if is_locked else -0.85 # Down clamped vs upright disengaged
	var lever_len := 16.0
	var lever_end := Vector2(cos(lever_ang), sin(lever_ang)) * lever_len
	
	ci.draw_circle(Vector2.ZERO, 3.5, Color("3a4f5c"))
	ci.draw_circle(Vector2.ZERO, 3.5, COLOR_INFRASTRUCTURE, false, 1.0)
	ci.draw_line(Vector2.ZERO, lever_end, Color("4a6270"), 2.5)
	ci.draw_circle(lever_end, 2.5, COLOR_AMBER if not is_locked else COLOR_CYAN)
	
	# Pressure lock indicator light
	var lamp_pos := Vector2(0.0, -14.0)
	if is_locked:
		ci.draw_circle(lamp_pos, 2.2, COLOR_CYAN)
		ci.draw_circle(lamp_pos, 5.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35))
	else:
		var pulse := sin(p_pulse * 3.0) * 0.5 + 0.5
		ci.draw_circle(lamp_pos, 2.2, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.6 + pulse * 0.4))


static func draw_substructure_conduit_shaft(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Reinforced vertical conduit hatch portal: 34x58 px
	var portal_rect := Rect2(-17.0, -29.0, 34.0, 58.0)
	ci.draw_rect(portal_rect, Color("223038"))
	ci.draw_rect(portal_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Inner airlock hatch panel
	var hatch_rect := Rect2(-13.0, -24.0, 26.0, 50.0)
	ci.draw_rect(hatch_rect, Color("141c22"))
	
	# Upper ventilation louvers
	for ly in range(-21, -12, 3):
		ci.draw_line(Vector2(-10.0, float(ly)), Vector2(10.0, float(ly)), Color("2c3d47"), 1.0)
	
	# Center hydraulic locking wheel
	ci.draw_circle(Vector2(0.0, 2.0), 6.5, Color("2b3c46"))
	ci.draw_circle(Vector2(0.0, 2.0), 6.5, COLOR_INFRASTRUCTURE, false, 1.0)
	ci.draw_circle(Vector2(0.0, 2.0), 2.2, COLOR_DARK_STEEL)
	
	var rot := (p_pulse * 1.5) if p_is_activated else 0.0
	for sp in range(4):
		var ang: float = rot + float(sp) * PI * 0.5
		ci.draw_line(Vector2(0.0, 2.0) + Vector2(cos(ang), sin(ang)) * 2.2, Vector2(0.0, 2.0) + Vector2(cos(ang), sin(ang)) * 6.0, COLOR_INFRASTRUCTURE, 1.0)
	
	# Bottom conduit penetration flange with downward feeding cables
	ci.draw_rect(Rect2(-12.0, 18.0, 24.0, 7.0), Color("1b262d"))
	for cx in [-8.0, -3.0, 3.0, 8.0]:
		ci.draw_line(Vector2(cx, 18.0), Vector2(cx, 28.0), Color("0f161a"), 2.0)
		ci.draw_line(Vector2(cx, 18.0), Vector2(cx, 28.0), Color("2f404a"), 0.8)
	
	# Status Indicator Beacon above hatch
	var is_open := p_is_activated
	if is_open:
		ci.draw_circle(Vector2(0.0, -25.0), 2.2, COLOR_CYAN)
		ci.draw_circle(Vector2(0.0, -25.0), 5.5, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.40))
		# Illuminated floor threshold guide strip
		ci.draw_line(Vector2(-13.0, 27.0), Vector2(13.0, 27.0), COLOR_CYAN * 0.9, 1.5)
	else:
		var pulse := sin(p_pulse * 3.0) * 0.5 + 0.5
		ci.draw_circle(Vector2(0.0, -25.0), 2.2, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.6 + pulse * 0.4))


static func draw_hygiene_instruction_board(ci: CanvasItem) -> void:
	# Metal-framed wall display board: 28x38 px
	var frame_rect := Rect2(-14.0, -19.0, 28.0, 38.0)
	ci.draw_rect(frame_rect, Color("202c33"))
	ci.draw_rect(frame_rect, COLOR_INFRASTRUCTURE * 0.85, false, 1.2)
	
	# Board background
	var board_rect := Rect2(-12.0, -17.0, 24.0, 34.0)
	ci.draw_rect(board_rect, Color("182329"))
	
	# Top administrative header banner (UCP Sage/Cyan)
	ci.draw_rect(Rect2(-11.0, -16.0, 22.0, 5.0), Color("283d47"))
	ci.draw_line(Vector2(-9.0, -13.5), Vector2(3.0, -13.5), COLOR_CYAN * 0.8, 1.0)
	
	# Official hygiene directive lines (Clean sans-serif text imitation)
	for ly in [-8, -4, 0, 4, 8]:
		var line_w := 18.0 if ly != 8 else 10.0
		ci.draw_line(Vector2(-9.0, float(ly)), Vector2(-9.0 + line_w, float(ly)), COLOR_INFRASTRUCTURE * 0.75, 1.0)
		# Left bullet marker
		ci.draw_circle(Vector2(-10.0, float(ly)), 0.6, COLOR_CYAN * 0.7)
	
	# Official red/amber security stamp in upper right
	ci.draw_circle(Vector2(6.5, -7.0), 2.2, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.65))
	ci.draw_circle(Vector2(6.5, -7.0), 2.2, COLOR_CORRECTION * 0.9, false, 0.8)
	
	# Hand-written margin annotations in bottom-right corner (Lena's pencil notes)
	ci.draw_line(Vector2(1.0, 7.0), Vector2(9.0, 5.0), COLOR_AMBER * 0.9, 1.0)
	ci.draw_line(Vector2(2.0, 10.0), Vector2(10.0, 8.5), COLOR_AMBER * 0.8, 0.8)
	ci.draw_line(Vector2(0.0, 13.0), Vector2(8.0, 12.0), COLOR_AMBER * 0.85, 0.8)
	
	# Subtle glass protective layer sheen
	ci.draw_line(Vector2(-10.0, -15.0), Vector2(5.0, 14.0), Color(1.0, 1.0, 1.0, 0.12), 1.0)


static func draw_handwritten_correlation_formula(ci: CanvasItem, p_is_activated: bool, p_flash: float) -> void:
	# Industrial conduit pipeline segment: 38x26 px
	var pipe_rect := Rect2(-19.0, -13.0, 38.0, 26.0)
	ci.draw_rect(pipe_rect, Color("1e2a32"))
	
	# Cylindrical gradient highlight lines
	ci.draw_line(Vector2(-19.0, -8.0), Vector2(19.0, -8.0), Color("364b58"), 2.0)
	ci.draw_line(Vector2(-19.0, 8.0), Vector2(19.0, 8.0), Color("121a1f"), 2.0)
	ci.draw_rect(pipe_rect, Color("2d3f4a"), false, 1.0)
	
	# Flange collars at ends
	ci.draw_rect(Rect2(-19.0, -14.0, 4.0, 28.0), Color("283741"))
	ci.draw_rect(Rect2(15.0, -14.0, 4.0, 28.0), Color("283741"))
	
	# Rivet studs
	ci.draw_circle(Vector2(-17.0, -9.0), 1.0, COLOR_INFRASTRUCTURE)
	ci.draw_circle(Vector2(-17.0, 9.0), 1.0, COLOR_INFRASTRUCTURE)
	ci.draw_circle(Vector2(17.0, -9.0), 1.0, COLOR_INFRASTRUCTURE)
	ci.draw_circle(Vector2(17.0, 9.0), 1.0, COLOR_INFRASTRUCTURE)
	
	# Handwritten correlation formula in Lena's tight handwriting with open numeral 4
	var formula_col := COLOR_AMBER if not p_is_activated else Color("f5be87")
	
	# Integral loop sign \oint
	ci.draw_line(Vector2(-12.0, -5.0), Vector2(-12.0, 5.0), formula_col, 1.2)
	ci.draw_circle(Vector2(-12.0, 0.0), 1.8, formula_col, false, 0.8)
	
	# Psi symbol \Psi
	ci.draw_line(Vector2(-6.0, -5.0), Vector2(-6.0, 5.0), formula_col, 1.2)
	ci.draw_line(Vector2(-8.5, -2.0), Vector2(-3.5, -2.0), formula_col, 1.0)
	ci.draw_line(Vector2(-8.5, -2.0), Vector2(-8.5, -4.0), formula_col, 1.0)
	ci.draw_line(Vector2(-3.5, -2.0), Vector2(-3.5, -4.0), formula_col, 1.0)
	
	# Sync vector arrow \vec{A}
	ci.draw_line(Vector2(-1.0, -2.0), Vector2(2.0, 3.0), formula_col, 1.0)
	ci.draw_line(Vector2(2.0, 3.0), Vector2(5.0, -2.0), formula_col, 1.0)
	ci.draw_line(Vector2(0.5, 0.5), Vector2(3.5, 0.5), formula_col, 0.8)
	ci.draw_line(Vector2(0.0, -4.5), Vector2(4.0, -4.5), formula_col * 0.9, 0.8)
	
	# Characteristic open-top numeral 4 (per VISUAL_DESIGN.md Section 6.3)
	# Vertical left, horizontal cross, and right downstroke (open at top)
	ci.draw_line(Vector2(8.0, -4.0), Vector2(8.0, 0.5), formula_col, 1.2)
	ci.draw_line(Vector2(7.0, 0.5), Vector2(13.0, 0.5), formula_col, 1.2)
	ci.draw_line(Vector2(11.5, -3.0), Vector2(11.5, 5.0), formula_col, 1.2)
	
	# Delta tau offset \Delta\tau
	ci.draw_line(Vector2(14.0, 4.0), Vector2(16.0, 0.0), formula_col * 0.8, 0.8)
	ci.draw_line(Vector2(16.0, 0.0), Vector2(18.0, 4.0), formula_col * 0.8, 0.8)
	ci.draw_line(Vector2(14.0, 4.0), Vector2(18.0, 4.0), formula_col * 0.8, 0.8)
	
	# Chalk/marker glow if activated
	if p_is_activated or p_flash > 0.0:
		ci.draw_rect(Rect2(-15.0, -7.0, 30.0, 14.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.18 + p_flash * 0.25))


static func draw_reflective_puddle(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Upper wall indicator sign (Direct view - points LEFT into false dead end)
	var sign_rect := Rect2(-10.0, -20.0, 20.0, 10.0)
	ci.draw_rect(sign_rect, Color("1e2a32"))
	ci.draw_rect(sign_rect, COLOR_INFRASTRUCTURE * 0.7, false, 0.8)
	
	# Direct arrow pointing LEFT
	var left_arrow_col := COLOR_CORRECTION * 0.85
	ci.draw_line(Vector2(5.0, -15.0), Vector2(-4.0, -15.0), left_arrow_col, 1.5)
	ci.draw_line(Vector2(-4.0, -15.0), Vector2(-1.0, -18.0), left_arrow_col, 1.2)
	ci.draw_line(Vector2(-4.0, -15.0), Vector2(-1.0, -12.0), left_arrow_col, 1.2)
	
	# Puddle floor basin: ellipse at (0, 6)
	var basin_center := Vector2(0.0, 6.0)
	# Outer indentation
	ci.draw_rect(Rect2(-24.0, 0.0, 48.0, 12.0), Color("121a20"))
	
	# Water surface elliptical layers
	ci.draw_circle(basin_center + Vector2(-6.0, 0.0), 9.0, Color("162630"))
	ci.draw_circle(basin_center + Vector2(6.0, 0.0), 9.0, Color("162630"))
	ci.draw_rect(Rect2(-15.0, 2.0, 30.0, 8.0), Color("162630"))
	
	# Concentric ripples from dripping water
	var rip_radius := fmod(p_pulse * 6.0, 16.0)
	var rip_alpha := 1.0 - (rip_radius / 16.0)
	ci.draw_arc(basin_center, rip_radius, 0.0, TAU, 16, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, rip_alpha * 0.4), 1.0)
	
	# ASYNCHRONOUS REFLECTED ARROW: Points RIGHT (revealed in puddle reflection!)
	var right_arrow_col := COLOR_CYAN if p_is_activated else Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.75)
	ci.draw_line(basin_center + Vector2(-5.0, 0.0), basin_center + Vector2(4.0, 0.0), right_arrow_col, 1.8)
	ci.draw_line(basin_center + Vector2(4.0, 0.0), basin_center + Vector2(1.0, -3.0), right_arrow_col, 1.4)
	ci.draw_line(basin_center + Vector2(4.0, 0.0), basin_center + Vector2(1.0, 3.0), right_arrow_col, 1.4)
	
	# Water surface specular gleam
	ci.draw_line(basin_center + Vector2(-12.0, -2.0), basin_center + Vector2(-4.0, -2.0), Color(1.0, 1.0, 1.0, 0.25), 1.0)


static func draw_pressure_relief_valve(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy industrial decompression valve on pipe: 24x34 px
	var body_rect := Rect2(-11.0, -17.0, 22.0, 34.0)
	ci.draw_rect(body_rect, Color("222f37"))
	ci.draw_rect(body_rect, COLOR_INFRASTRUCTURE * 0.8, false, 1.0)
	
	# Upper bypass pipe connection & exhaust nozzle
	ci.draw_rect(Rect2(-5.0, -22.0, 10.0, 6.0), Color("1a242a"))
	ci.draw_line(Vector2(0.0, -22.0), Vector2(8.0, -26.0), COLOR_INFRASTRUCTURE, 2.0)
	
	# Analog circular manometer dial
	var gauge_center := Vector2(0.0, -6.0)
	ci.draw_circle(gauge_center, 7.5, Color("151e24"))
	ci.draw_circle(gauge_center, 7.5, COLOR_INFRASTRUCTURE, false, 1.0)
	ci.draw_circle(gauge_center, 6.0, Color("2d3e48"))
	
	# Dial tick marks
	for a in range(5):
		var ang := -PI * 0.75 + float(a) * PI * 0.375
		var p1 := gauge_center + Vector2(cos(ang), sin(ang)) * 4.2
		var p2 := gauge_center + Vector2(cos(ang), sin(ang)) * 5.8
		ci.draw_line(p1, p2, COLOR_INFRASTRUCTURE, 0.8)
	
	# Needle: High pressure (danger / cinnabar) vs Depressurized (safe / cyan)
	var is_open := p_is_activated
	var needle_ang := -PI * 0.65 if is_open else (PI * 0.25 + sin(p_pulse * 4.0) * 0.08)
	var needle_col := COLOR_CYAN if is_open else COLOR_CORRECTION
	ci.draw_line(gauge_center, gauge_center + Vector2(cos(needle_ang), sin(needle_ang)) * 5.2, needle_col, 1.2)
	ci.draw_circle(gauge_center, 1.5, COLOR_DARK_STEEL)
	
	# Manual bypass lever arm
	var lever_pivot := Vector2(7.0, 7.0)
	var lever_ang := 0.85 if is_open else -0.75
	var lever_len := 12.0
	var lever_end := lever_pivot + Vector2(cos(lever_ang), sin(lever_ang)) * lever_len
	
	ci.draw_circle(lever_pivot, 2.5, Color("354955"))
	ci.draw_line(lever_pivot, lever_end, Color("496373"), 2.0)
	ci.draw_circle(lever_end, 2.2, COLOR_CYAN if is_open else COLOR_AMBER)
	
	# Status diode
	var diode_pos := Vector2(-6.0, 8.0)
	if is_open:
		ci.draw_circle(diode_pos, 1.8, COLOR_CYAN)
		ci.draw_circle(diode_pos, 4.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35))
	else:
		var pulse := sin(p_pulse * 3.0) * 0.5 + 0.5
		ci.draw_circle(diode_pos, 1.8, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.6 + pulse * 0.4))


static func draw_transit_service_gate(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Heavy reinforced steel security portal: 36x62 px
	var portal_rect := Rect2(-18.0, -31.0, 36.0, 62.0)
	ci.draw_rect(portal_rect, Color("202c34"))
	ci.draw_rect(portal_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Inner gate chamber cavity
	var inner_rect := Rect2(-14.0, -25.0, 28.0, 52.0)
	ci.draw_rect(inner_rect, Color("141d22"))
	
	var is_open := p_is_activated
	
	if is_open:
		# Illuminated transit corridor opening into Space 16
		ci.draw_rect(Rect2(-12.0, -22.0, 24.0, 48.0), Color("22363f"))
		# Floor guide light beam
		ci.draw_line(Vector2(-12.0, 25.0), Vector2(12.0, 25.0), COLOR_CYAN, 1.8)
		# Raised gate shutter panels
		ci.draw_rect(Rect2(-13.0, -24.0, 26.0, 10.0), Color("2b3c46"))
		ci.draw_rect(Rect2(-13.0, -24.0, 26.0, 10.0), COLOR_INFRASTRUCTURE * 0.7, false, 0.8)
	else:
		# Lowered heavy steel sliding shutter with diagonal hazard warning stripes
		ci.draw_rect(Rect2(-13.0, -23.0, 26.0, 47.0), Color("1a242b"))
		for sy in range(-20, 22, 6):
			ci.draw_line(Vector2(-11.0, float(sy)), Vector2(11.0, float(sy)), Color("2c3e49"), 1.0)
		# Center electromagnetic locking deadbolt bar
		ci.draw_rect(Rect2(-3.0, -8.0, 6.0, 16.0), Color("394e5b"))
		ci.draw_rect(Rect2(-3.0, -8.0, 6.0, 16.0), COLOR_INFRASTRUCTURE, false, 1.0)
	
	# Overhead status beacon light
	var beacon_pos := Vector2(0.0, -27.0)
	if is_open:
		ci.draw_circle(beacon_pos, 2.5, COLOR_CYAN)
		ci.draw_circle(beacon_pos, 6.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.40))
	else:
		var pulse := sin(p_pulse * 3.0) * 0.5 + 0.5
		ci.draw_circle(beacon_pos, 2.5, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.6 + pulse * 0.4))


static func draw_epilogue_return_cups(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Scene 42A: Two cups on wooden desk, framed photograph with adult Jakub, telephone
	var desk_rect := Rect2(-24.0, 4.0, 48.0, 16.0)
	var photo_rect := Rect2(-18.0, -18.0, 16.0, 20.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 2.5)
	
	# Wooden laboratory desk surface
	ci.draw_rect(desk_rect, Color("2b1d14"))
	ci.draw_rect(desk_rect, Color("5e3c28"), false, 1.2)
	
	# Cup 1 (Left porcelain cup - Lena)
	ci.draw_rect(Rect2(-12.0, -2.0, 6.0, 7.0), Color("dcdfd8"))
	ci.draw_line(Vector2(-12.0, 1.0), Vector2(-14.0, 1.0), Color("dcdfd8"), 1.0)
	# Cup 2 (Right porcelain cup - colleague returning with coffee)
	ci.draw_rect(Rect2(-4.0, -2.0, 6.0, 7.0), Color("dcdfd8"))
	ci.draw_line(Vector2(2.0, 1.0), Vector2(4.0, 1.0), Color("dcdfd8"), 1.0)
	
	# Framed photo of Jakub (adult shadow appears/fades)
	ci.draw_rect(photo_rect, Color("141d24"))
	ci.draw_rect(photo_rect, Color("4a6878"), false, 1.0)
	# Photo paper
	ci.draw_rect(Rect2(-16.0, -16.0, 12.0, 16.0), Color("d4dfdc"))
	# Adult Jakub silhouette
	var adult_alpha: float = 0.40 + 0.55 * pulse if p_is_activated else 0.30
	ci.draw_rect(Rect2(-14.0, -10.0, 8.0, 10.0), Color(0.12, 0.18, 0.22, adult_alpha))
	ci.draw_circle(Vector2(-10.0, -12.0), 2.5, Color(0.12, 0.18, 0.22, adult_alpha))
	
	# Telephone handset
	ci.draw_rect(Rect2(8.0, -4.0, 12.0, 9.0), Color("121417"))
	ci.draw_rect(Rect2(6.0, -8.0, 16.0, 4.0), Color("1a1d21"))
	
	if p_is_activated:
		ci.draw_rect(desk_rect, Color(0.83, 0.60, 0.38, 0.30 + pulse * 0.20), false, 1.2)


static func draw_epilogue_marta_doorstep(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Scene 42B: Marta in doorway of Flat 14, tea cup, brass key on doorstep, ring gesture
	var frame_rect := Rect2(-20.0, -28.0, 40.0, 56.0)
	var door_opening := Rect2(-16.0, -24.0, 32.0, 52.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 3.0)
	
	# Modernist door frame
	ci.draw_rect(frame_rect, Color("211b15"))
	ci.draw_rect(frame_rect, Color("523e2b"), false, 1.4)
	
	# Warm interior light of flat 14. Marta herself is a CharacterVisualRig
	# sibling (PKG-0172 / GATE-CAST); this prop draws only the doorframe.
	ci.draw_rect(door_opening, Color(0.83, 0.60, 0.38, 0.22 if p_is_activated else 0.10))
	
	# Small table with single tea cup
	ci.draw_rect(Rect2(8.0, 6.0, 10.0, 18.0), Color("261d15"))
	ci.draw_rect(Rect2(10.0, 2.0, 5.0, 5.0), Color("dcdfd8"))
	
	# Brass key on doorstep from inside
	ci.draw_line(Vector2(-10.0, 26.0), Vector2(-4.0, 26.0), Color("d39a62" if p_is_activated else "523e2b"), 1.4)
	ci.draw_circle(Vector2(-10.0, 26.0), 2.0, Color("d39a62" if p_is_activated else "523e2b"))
	
	if p_is_activated:
		ci.draw_rect(frame_rect, Color(0.83, 0.60, 0.38, 0.40 + pulse * 0.25), false, 1.4)


static func draw_epilogue_tram_dual_tracks(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Scene 42C: Morning tram stopped before dual overlapping tracks, driver with logbook
	var ground_rect := Rect2(-30.0, 14.0, 60.0, 16.0)
	var tram_front := Rect2(-18.0, -22.0, 36.0, 36.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 2.8)
	
	# Asphalt road & trackbed
	ci.draw_rect(ground_rect, Color("12181d"))
	
	# Dual overlapping rails emerging from underneath tram
	# Left track (Track Alpha)
	ci.draw_line(Vector2(-12.0, 14.0), Vector2(-22.0, 30.0), Color("5da398"), 1.6)
	ci.draw_line(Vector2(-4.0, 14.0), Vector2(-14.0, 30.0), Color("5da398"), 1.6)
	# Right track (Track Beta - overlapping and distinct)
	ci.draw_line(Vector2(4.0, 14.0), Vector2(14.0, 30.0), Color("d39a62"), 1.6)
	ci.draw_line(Vector2(12.0, 14.0), Vector2(22.0, 30.0), Color("d39a62"), 1.6)
	
	# Red/cream classic Polish tram front (Konstal 105Na silhouette)
	ci.draw_rect(tram_front, Color("18222b"))
	ci.draw_rect(tram_front, Color("3d5566"), false, 1.4)
	
	# Front windscreen with motornicza silhouette and clipboard
	ci.draw_rect(Rect2(-14.0, -18.0, 28.0, 14.0), Color("0d1720"))
	ci.draw_rect(Rect2(-14.0, -18.0, 28.0, 14.0), Color("5da398" if p_is_activated else "283c47"), false, 1.0)
	# Driver silhouette
	ci.draw_circle(Vector2(-4.0, -11.0), 3.0, Color("1a2936"))
	# Clipboard in hand
	ci.draw_rect(Rect2(2.0, -12.0, 5.0, 7.0), Color("d39a62" if p_is_activated else "4a3828"))
	
	# Dual headlights
	var head_l := Color(0.95, 0.85, 0.65, 0.85 if p_is_activated else 0.40)
	ci.draw_circle(Vector2(-10.0, 6.0), 2.8, head_l)
	ci.draw_circle(Vector2(10.0, 6.0), 2.8, head_l)
	
	# Direction display "LINIA 4 / DWIE TRASY"
	ci.draw_rect(Rect2(-12.0, -21.0, 24.0, 4.0), Color("0a1218"))
	ci.draw_line(Vector2(-8.0, -19.0), Vector2(8.0, -19.0), Color("e2b060" if p_is_activated else "4a3a20"), 1.0)
	
	if p_is_activated:
		ci.draw_rect(tram_front, Color(0.36, 0.64, 0.60, 0.35 + pulse * 0.20), false, 1.4)


static func draw_epilogue_admin_notice_board(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Scene 43: Neutral administrative message board & Municipal radio receiver
	var board_rect := Rect2(-24.0, -20.0, 48.0, 40.0)
	var radio_rect := Rect2(-18.0, 4.0, 36.0, 14.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 2.0)
	
	# Enamelled steel notice board
	ci.draw_rect(board_rect, Color("131a21"))
	ci.draw_rect(board_rect, Color("354957"), false, 1.4)
	
	# Header bar "UCP / KOMUNIKAT BIEŻĄCY"
	ci.draw_rect(Rect2(-22.0, -18.0, 44.0, 6.0), Color("1c2833"))
	ci.draw_line(Vector2(-18.0, -15.0), Vector2(18.0, -15.0), Color("5da398"), 1.0)
	
	# 3 lines of administrative typed text
	ci.draw_line(Vector2(-20.0, -8.0), Vector2(16.0, -8.0), Color(0.70, 0.78, 0.82, 0.65), 1.0)
	ci.draw_line(Vector2(-20.0, -4.0), Vector2(10.0, -4.0), Color(0.70, 0.78, 0.82, 0.65), 1.0)
	ci.draw_line(Vector2(-20.0, 0.0), Vector2(18.0, 0.0), Color(0.70, 0.78, 0.82, 0.65), 1.0)
	
	# Municipal emergency radio unit
	ci.draw_rect(radio_rect, Color("1f1612"))
	ci.draw_rect(radio_rect, Color("5e3c28"), false, 1.0)
	# Tuning dial and speaker grille
	ci.draw_circle(Vector2(-10.0, 11.0), 3.0, Color("d39a62" if p_is_activated else "4a3525"))
	for g in range(3):
		var gx: float = 2.0 + float(g) * 4.0
		ci.draw_line(Vector2(gx, 7.0), Vector2(gx, 15.0), Color("d39a62" if p_is_activated else "3d291c"), 1.0)
	
	if p_is_activated:
		ci.draw_rect(board_rect, Color(0.70, 0.78, 0.82, 0.35 + pulse * 0.20), false, 1.2)


static func draw_epilogue_credits_roll(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Scene 43: Rolling Credits projected across architectural facade
	var facade_rect := Rect2(-30.0, -22.0, 60.0, 44.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 2.2)
	
	# Modernist facade plate
	ci.draw_rect(facade_rect, Color("0a1015"))
	ci.draw_rect(facade_rect, Color("223542"), false, 1.2)
	
	# Vertical architectural pilasters
	ci.draw_line(Vector2(-20.0, -22.0), Vector2(-20.0, 22.0), Color("17242e"), 1.0)
	ci.draw_line(Vector2(0.0, -22.0), Vector2(0.0, 22.0), Color("17242e"), 1.0)
	ci.draw_line(Vector2(20.0, -22.0), Vector2(20.0, 22.0), Color("17242e"), 1.0)
	
	# Rolling typographic credit bars
	var text_col := Color(0.83, 0.60, 0.38, 0.85 if p_is_activated else 0.45)
	ci.draw_line(Vector2(-16.0, -14.0), Vector2(16.0, -14.0), text_col, 1.4)
	ci.draw_line(Vector2(-12.0, -8.0), Vector2(12.0, -8.0), text_col * 0.8, 1.0)
	ci.draw_line(Vector2(-18.0, 0.0), Vector2(18.0, 0.0), text_col, 1.4)
	ci.draw_line(Vector2(-10.0, 6.0), Vector2(10.0, 6.0), text_col * 0.8, 1.0)
	ci.draw_line(Vector2(-14.0, 14.0), Vector2(14.0, 14.0), text_col, 1.4)
	
	if p_is_activated:
		ci.draw_rect(facade_rect, Color(0.83, 0.60, 0.38, 0.30 + pulse * 0.20), false, 1.4)


static func draw_epilogue_final_blackout(ci: CanvasItem, p_is_activated: bool, p_pulse: float) -> void:
	# Scene 43: Final Blackout & Resolution
	var frame_rect := Rect2(-24.0, -30.0, 48.0, 60.0)
	var pulse: float = 0.5 + 0.5 * sin(p_pulse * 1.5)
	
	# Pure midnight resolution portal
	ci.draw_rect(frame_rect, Color("04080b"))
	ci.draw_rect(frame_rect, Color("1a2a35"), false, 1.4)
	
	# Centered pure sine horizon line
	var line_alpha: float = 0.85 if p_is_activated else 0.35
	ci.draw_line(Vector2(-18.0, 0.0), Vector2(18.0, 0.0), Color(0.46, 0.78, 0.76, line_alpha), 1.2)
	ci.draw_circle(Vector2(0.0, 0.0), 2.2, Color(0.83, 0.60, 0.38, line_alpha))
	
	if p_is_activated:
		ci.draw_rect(frame_rect, Color(0.36, 0.64, 0.60, 0.40 + pulse * 0.25), false, 1.6)






















## PKG-0140 (D-147). Kontaktowy odczyt wizualny: jeden cichy luk pod rekwizytem
## i jeden punkt styku. Rysowany pod wlasciwym rekwizytem, wiec zaden z 200+
## rysunkow nie musial byc przepisany, a stacja nie dostaje zadnego HUD-u.


