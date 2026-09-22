class_name VectorStageEnvironment
extends Node2D

## Replaces decorative grids with stage-like planar depth for early stations.
## Runtime geometry and collision remain owned by the existing station scenes.

@export var stage_seed := 1
@export var world_size := Vector2(640.0, 360.0)
@export_range(1, 43) var station_number := 1


func _ready() -> void:
	z_index = -5
	queue_redraw()


func _draw() -> void:
	VectorStageStyle.draw_stage_background(self, world_size, stage_seed)
	_draw_station_composition()
	var lamp_positions := [
		Vector2(world_size.x * 0.18, 44.0),
		Vector2(world_size.x * 0.53, 56.0),
		Vector2(world_size.x * 0.82, 40.0),
	]
	for lamp_position in lamp_positions:
		VectorStageStyle.draw_faceted_lamp(self, lamp_position)


func _draw_station_composition() -> void:
	match station_number:
		1:
			# Control room: the checklist desk sits against a broad observation plane.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(18, 58), Vector2(438, 44), Vector2(468, 292), Vector2(12, 306)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(480, 68), Vector2(622, 78), Vector2(622, 292), Vector2(486, 292)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(86, 260), Vector2(198, 254), Vector2(208, 292), Vector2(78, 296)]), VectorStageStyle.HUMAN_AMBER)
			draw_colored_polygon(PackedVector2Array([Vector2(354, 126), Vector2(370, 124), Vector2(372, 198), Vector2(356, 200)]), VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.38))
		2:
			# Correlation chamber: two optical points frame a quiet measurement bay.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(28, 64), Vector2(306, 48), Vector2(318, 292), Vector2(24, 302)]), VectorStageStyle.DEEP_PLANE, 0.0)
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(330, 48), Vector2(612, 62), Vector2(616, 292), Vector2(334, 292)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(316, 102), Vector2(336, 100), Vector2(338, 214), Vector2(318, 216)]), VectorStageStyle.ANCHOR_CYAN)
			draw_colored_polygon(PackedVector2Array([Vector2(444, 108), Vector2(458, 110), Vector2(460, 214), Vector2(446, 216)]), VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.70))
		3:
			# Empty laboratory: the abandoned desk and the exit seam leave the centre open.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(20, 58), Vector2(416, 46), Vector2(438, 292), Vector2(18, 304)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(458, 54), Vector2(620, 68), Vector2(620, 292), Vector2(462, 292)]), VectorStageStyle.DEEP_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(144, 260), Vector2(270, 254), Vector2(278, 292), Vector2(136, 296)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(516, 154), Vector2(532, 152), Vector2(534, 216), Vector2(518, 218)]), VectorStageStyle.CORRECTION_OXIDE)
		4:
			# Reception: a guard counter directs the route toward the mechanical gate.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(18, 60), Vector2(376, 44), Vector2(398, 292), Vector2(14, 304)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(414, 54), Vector2(622, 68), Vector2(622, 292), Vector2(420, 292)]), VectorStageStyle.DEEP_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(88, 246), Vector2(254, 238), Vector2(272, 292), Vector2(76, 296)]), VectorStageStyle.HUMAN_AMBER)
			draw_colored_polygon(PackedVector2Array([Vector2(500, 188), Vector2(520, 186), Vector2(522, 246), Vector2(502, 248)]), VectorStageStyle.ANCHOR_CYAN)
		5:
			# Rówień at night: the road is a long stage plane with a single lit crossing.
			var horizon := 186.0
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 54), Vector2(world_size.x, 74), Vector2(world_size.x, horizon), Vector2(0, horizon)]), VectorStageStyle.DEEP_PLANE, 0.0)
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 236), Vector2(world_size.x, 224), Vector2(world_size.x, 360), Vector2(0, 360)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(410, 216), Vector2(590, 212), Vector2(608, 248), Vector2(426, 252)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(672, 202), Vector2(704, 202), Vector2(706, 248), Vector2(674, 248)]), VectorStageStyle.HUMAN_AMBER)
			draw_colored_polygon(PackedVector2Array([Vector2(1010, 184), Vector2(1028, 184), Vector2(1029, 238), Vector2(1011, 238)]), VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.46))
		6:
			# Replacement bus: long horizontal route, dark windows as negative space.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(18, 86), Vector2(622, 68), Vector2(612, 246), Vector2(24, 255)]), VectorStageStyle.MID_PLANE, 0.0)
			for x in range(44, 564, 104):
				draw_colored_polygon(PackedVector2Array([Vector2(x, 98), Vector2(x + 76, 93), Vector2(x + 65, 176), Vector2(x + 4, 182)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(418, 272), Vector2(470, 268), Vector2(484, 305), Vector2(428, 307)]), VectorStageStyle.HUMAN_AMBER)
		7:
			# Stairwell: vertical ascent cut into a mostly unoccupied cyan-grey void.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 72), Vector2(272, 40), Vector2(240, 306), Vector2(0, 330)]), VectorStageStyle.DEEP_PLANE, 0.0)
			for y in range(116, 294, 30):
				draw_colored_polygon(PackedVector2Array([Vector2(356, y), Vector2(618, y - 18), Vector2(618, y + 2), Vector2(356, y + 20)]), VectorStageStyle.MID_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(475, 162), Vector2(486, 160), Vector2(488, 252), Vector2(477, 254)]), VectorStageStyle.ANCHOR_CYAN)
		8:
			# Apartment: domestic island pushed left; open window/right field supplies unease.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(26, 96), Vector2(394, 75), Vector2(416, 303), Vector2(22, 316)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(448, 58), Vector2(620, 76), Vector2(594, 255), Vector2(462, 225)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(182, 272), Vector2(332, 263), Vector2(352, 306), Vector2(168, 311)]), VectorStageStyle.HUMAN_AMBER)
		9:
			# Bathroom mirror: a hard reflective blade dominates center; floor remains quiet.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(118, 50), Vector2(362, 42), Vector2(396, 264), Vector2(96, 282)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(151, 70), Vector2(332, 60), Vector2(360, 244), Vector2(129, 257)]), VectorStageStyle.DEEP_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(382, 148), Vector2(414, 156), Vector2(408, 218), Vector2(386, 214)]), VectorStageStyle.CORRECTION_OXIDE)
		10:
			# Study: diagonal desk and topography board focus toward the technical airlock.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(46, 82), Vector2(454, 52), Vector2(486, 286), Vector2(36, 316)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(176, 238), Vector2(454, 197), Vector2(478, 276), Vector2(204, 310)]), VectorStageStyle.HUMAN_AMBER)
			draw_colored_polygon(PackedVector2Array([Vector2(544, 78), Vector2(626, 82), Vector2(626, 304), Vector2(540, 286)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(570, 158), Vector2(584, 157), Vector2(585, 230), Vector2(572, 231)]), VectorStageStyle.ANCHOR_CYAN)
		11:
			# Courtyard: a descending diagonal transfers the gaze from witness to erased seam.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 58), Vector2(252, 42), Vector2(326, 294), Vector2(0, 318)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(322, 222), Vector2(618, 173), Vector2(632, 296), Vector2(372, 319)]), VectorStageStyle.DEEP_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(452, 182), Vector2(474, 179), Vector2(482, 288), Vector2(458, 291)]), VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.50))
		12:
			# Archive underpass: horizontal shelves cut against a deliberate central dark gap.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(24, 62), Vector2(238, 76), Vector2(230, 292), Vector2(22, 307)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(398, 58), Vector2(626, 46), Vector2(620, 289), Vector2(418, 303)]), VectorStageStyle.DEEP_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(270, 105), Vector2(352, 94), Vector2(365, 273), Vector2(275, 281)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(300, 112), Vector2(322, 109), Vector2(330, 266), Vector2(306, 269)]), VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.34))
		13:
			# Drafting archive: plan sheets converge toward the right-side seam opening.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(42, 70), Vector2(404, 48), Vector2(430, 280), Vector2(34, 303)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(114, 238), Vector2(396, 174), Vector2(426, 262), Vector2(164, 304)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(510, 68), Vector2(618, 82), Vector2(612, 291), Vector2(526, 272)]), VectorStageStyle.INK)
		14:
			# Service shaft: compressed vertical bays leave a narrow void above the playable floor.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(56, 35), Vector2(205, 42), Vector2(184, 303), Vector2(44, 311)]), VectorStageStyle.DEEP_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(275, 42), Vector2(398, 35), Vector2(417, 297), Vector2(296, 305)]), VectorStageStyle.MID_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(502, 57), Vector2(593, 50), Vector2(600, 270), Vector2(514, 277)]), VectorStageStyle.DEEP_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(538, 150), Vector2(560, 148), Vector2(564, 246), Vector2(542, 248)]), VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.46))
		15:
			# Conduit: long pressure line directs right while the lower grid stays readable.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 70), Vector2(638, 58), Vector2(640, 169), Vector2(0, 183)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(54, 228), Vector2(515, 198), Vector2(548, 282), Vector2(79, 313)]), VectorStageStyle.DEEP_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(542, 100), Vector2(620, 97), Vector2(621, 269), Vector2(550, 255)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(568, 110), Vector2(592, 108), Vector2(594, 258), Vector2(572, 252)]), VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.30))
		16:
			# Apartment 14 at night: low intimate table, exterior window blocks in darkness, warm lamp cone.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(160, 240), Vector2(480, 240), Vector2(490, 280), Vector2(150, 280)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(200, 45), Vector2(440, 45), Vector2(440, 180), Vector2(200, 180)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(320, 130), Vector2(450, 250), Vector2(190, 250)]), VectorStageStyle.HUMAN_AMBER)
			draw_colored_polygon(PackedVector2Array([Vector2(560, 210), Vector2(610, 210), Vector2(610, 280), Vector2(560, 280)]), VectorStageStyle.ANCHOR_CYAN)
		17:
			# UCP Compliance Point 6: tall institutional pillars, queuing divider, pneumatic terminal, office threshold.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 40), Vector2(640, 30), Vector2(640, 280), Vector2(0, 280)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(80, 60), Vector2(180, 55), Vector2(180, 280), Vector2(80, 280)]), VectorStageStyle.MID_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(290, 140), Vector2(400, 135), Vector2(410, 280), Vector2(290, 280)]), VectorStageStyle.DEEP_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(550, 90), Vector2(610, 85), Vector2(610, 280), Vector2(550, 280)]), VectorStageStyle.ANCHOR_CYAN)
		18:
			# Consultation chamber: clinical converging perspective, recording desk, sensory map, stress indicator.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(30, 50), Vector2(610, 40), Vector2(600, 280), Vector2(40, 280)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(220, 200), Vector2(400, 190), Vector2(420, 280), Vector2(210, 280)]), VectorStageStyle.DEEP_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(60, 80), Vector2(180, 75), Vector2(180, 180), Vector2(60, 185)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(430, 140), Vector2(470, 135), Vector2(480, 270), Vector2(440, 275)]), VectorStageStyle.CORRECTION_OXIDE)
		19:
			# Model room: dual blueprint plinths flanking the central Line 4 model table, 11-persons ledger.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 45), Vector2(640, 45), Vector2(640, 280), Vector2(0, 280)]), VectorStageStyle.DEEP_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(220, 190), Vector2(420, 190), Vector2(440, 280), Vector2(200, 280)]), VectorStageStyle.MID_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(70, 90), Vector2(180, 80), Vector2(190, 220), Vector2(70, 230)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(450, 80), Vector2(560, 90), Vector2(560, 230), Vector2(440, 220)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(280, 150), Vector2(360, 150), Vector2(365, 200), Vector2(275, 200)]), VectorStageStyle.ANCHOR_CYAN)
		20:
			# Szymon's room: sedation plinth, desk with well drawing, stark negative wall, erased signature oxide.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(20, 40), Vector2(620, 40), Vector2(620, 280), Vector2(20, 280)]), VectorStageStyle.DEEP_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(200, 210), Vector2(460, 205), Vector2(470, 280), Vector2(190, 280)]), VectorStageStyle.MID_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(290, 215), Vector2(370, 215), Vector2(380, 260), Vector2(280, 260)]), VectorStageStyle.HUMAN_AMBER)
			draw_colored_polygon(PackedVector2Array([Vector2(390, 220), Vector2(450, 218), Vector2(455, 255), Vector2(395, 257)]), VectorStageStyle.CORRECTION_OXIDE)
		21:
			# Treatment room: descending axis from the sedation console to the reclined witness;
			# the bare right wall is the negative field left by the removed drawing.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 46), Vector2(438, 62), Vector2(454, 278), Vector2(0, 278)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(470, 54), Vector2(628, 68), Vector2(628, 276), Vector2(462, 276)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(104, 112), Vector2(188, 104), Vector2(194, 202), Vector2(110, 208)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(268, 214), Vector2(308, 210), Vector2(314, 268), Vector2(262, 270)]), VectorStageStyle.HUMAN_AMBER)
			draw_colored_polygon(PackedVector2Array([Vector2(516, 236), Vector2(552, 233), Vector2(555, 266), Vector2(519, 268)]), VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.22))
		22:
			# Identity gate: two institutional pylons close a vertical threshold;
			# the open queuing floor on the left is the space the yielding body must cross.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 52), Vector2(640, 40), Vector2(640, 278), Vector2(0, 278)]), VectorStageStyle.DEEP_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(300, 44), Vector2(368, 42), Vector2(374, 276), Vector2(296, 276)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(452, 46), Vector2(520, 44), Vector2(524, 276), Vector2(448, 276)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(374, 74), Vector2(448, 72), Vector2(448, 276), Vector2(374, 276)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(374, 50), Vector2(448, 48), Vector2(448, 62), Vector2(374, 64)]), VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.24))
			draw_colored_polygon(PackedVector2Array([Vector2(150, 214), Vector2(186, 211), Vector2(192, 268), Vector2(144, 270)]), VectorStageStyle.HUMAN_AMBER)
		23:
			# Designer's studio: an oblique drafting plane crosses the room toward the model plinth;
			# the dark upper-left field holds the unsigned decision that was made without Lena.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 66), Vector2(624, 46), Vector2(624, 276), Vector2(0, 276)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(0, 40), Vector2(214, 52), Vector2(206, 178), Vector2(0, 190)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(88, 236), Vector2(408, 190), Vector2(430, 258), Vector2(112, 274)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(452, 196), Vector2(508, 190), Vector2(514, 258), Vector2(456, 262)]), VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.28))
			draw_colored_polygon(PackedVector2Array([Vector2(262, 196), Vector2(306, 190), Vector2(310, 216), Vector2(266, 222)]), VectorStageStyle.HUMAN_AMBER)
		24:
			# Monitoring chamber: a level horizontal console bank reads apartment 14;
			# the unlit floor beneath the bank is the seat no operator is willing to occupy.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 44), Vector2(640, 44), Vector2(640, 276), Vector2(0, 276)]), VectorStageStyle.DEEP_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(28, 68), Vector2(508, 60), Vector2(512, 182), Vector2(26, 190)]), VectorStageStyle.MID_PLANE)
			for screen_x in range(46, 470, 106):
				draw_colored_polygon(PackedVector2Array([Vector2(screen_x, 82), Vector2(screen_x + 82, 79), Vector2(screen_x + 80, 168), Vector2(screen_x + 2, 172)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(158, 100), Vector2(206, 97), Vector2(210, 166), Vector2(160, 168)]), VectorStageStyle.HUMAN_AMBER)
			draw_colored_polygon(PackedVector2Array([Vector2(538, 124), Vector2(560, 122), Vector2(560, 256), Vector2(536, 258)]), VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.20))
		25:
			# Line 4 concourse: the rail wedge drives the eye right into the tunnel mouth;
			# that unlit opening is the direction the living brother refuses to be followed into.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 58), Vector2(640, 92), Vector2(640, 276), Vector2(0, 276)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(430, 108), Vector2(628, 130), Vector2(628, 254), Vector2(438, 246)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(0, 214), Vector2(438, 236), Vector2(438, 268), Vector2(0, 274)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(196, 214), Vector2(236, 210), Vector2(242, 270), Vector2(190, 272)]), VectorStageStyle.HUMAN_AMBER)
			draw_colored_polygon(PackedVector2Array([Vector2(496, 78), Vector2(532, 80), Vector2(533, 108), Vector2(497, 106)]), VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.25))
		26:
			# Gentle isolation: acoustic planes narrow toward the adaptive partition;
			# the open right field is the room's function changing outside Lena's gaze.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 50), Vector2(328, 42), Vector2(344, 276), Vector2(0, 276)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(360, 42), Vector2(624, 56), Vector2(624, 276), Vector2(368, 276)]), VectorStageStyle.DEEP_PLANE)
			for x in [54.0, 122.0, 190.0, 258.0]:
				draw_colored_polygon(PackedVector2Array([Vector2(x, 78), Vector2(x + 34.0, 74), Vector2(x + 38.0, 256), Vector2(x + 4.0, 260)]), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.18))
			draw_colored_polygon(PackedVector2Array([Vector2(478, 92), Vector2(496, 90), Vector2(498, 236), Vector2(480, 238)]), VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.34))
		27:
			# Service junction: a low horizontal maintenance axis meets a tall UCP
			# pylon, keeping Jakub's body and the exit in the same visual sentence.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 48), Vector2(456, 40), Vector2(446, 276), Vector2(0, 276)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(468, 54), Vector2(624, 68), Vector2(624, 276), Vector2(458, 276)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(76, 78), Vector2(112, 76), Vector2(114, 258), Vector2(78, 260)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(228, 202), Vector2(292, 198), Vector2(306, 270), Vector2(220, 274)]), VectorStageStyle.HUMAN_AMBER)
			draw_colored_polygon(PackedVector2Array([Vector2(536, 116), Vector2(558, 118), Vector2(558, 252), Vector2(538, 250)]), VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.28))
		28:
			# Technical wagon: carriage windows are dark witnesses, while one long
			# rail line carries the eye toward the next threshold.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(18, 64), Vector2(624, 54), Vector2(616, 278), Vector2(24, 278)]), VectorStageStyle.MID_PLANE, 0.0)
			for x in [48.0, 174.0, 300.0, 426.0, 552.0]:
				draw_colored_polygon(PackedVector2Array([Vector2(x, 88), Vector2(x + 86.0, 86), Vector2(x + 78.0, 174), Vector2(x + 6.0, 176)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(0, 208), Vector2(624, 222), Vector2(624, 272), Vector2(0, 260)]), VectorStageStyle.DEEP_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(256, 196), Vector2(300, 194), Vector2(306, 266), Vector2(250, 268)]), VectorStageStyle.HUMAN_AMBER)
			draw_colored_polygon(PackedVector2Array([Vector2(492, 72), Vector2(528, 72), Vector2(530, 94), Vector2(494, 94)]), VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.24))
		29:
			# Peron trzynasty: the abandoned track wedge points into the shaft;
			# the broad unlit wall leaves room for the missing names on the plaque.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 56), Vector2(620, 48), Vector2(620, 198), Vector2(0, 212)]), VectorStageStyle.DEEP_PLANE, 0.0)
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 220), Vector2(438, 208), Vector2(624, 244), Vector2(624, 278), Vector2(0, 278)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(52, 174), Vector2(364, 164), Vector2(430, 204), Vector2(58, 216)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(452, 84), Vector2(620, 96), Vector2(620, 224), Vector2(460, 212)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(226, 78), Vector2(250, 78), Vector2(252, 112), Vector2(228, 112)]), VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.30))
		30:
			# Witness machine: vertical bus bars frame a central relay bay, with a
			# dark field reserved for the testimony map rather than decorative noise.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 46), Vector2(236, 40), Vector2(236, 278), Vector2(0, 278)]), VectorStageStyle.MID_PLANE, 0.0)
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(398, 44), Vector2(624, 54), Vector2(624, 278), Vector2(398, 278)]), VectorStageStyle.DEEP_PLANE, 0.0)
			for x in [82.0, 142.0, 202.0, 438.0, 498.0]:
				draw_colored_polygon(PackedVector2Array([Vector2(x, 66), Vector2(x + 14.0, 64), Vector2(x + 18.0, 258), Vector2(x + 4.0, 260)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(270, 92), Vector2(390, 86), Vector2(394, 252), Vector2(266, 258)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(510, 164), Vector2(532, 162), Vector2(534, 252), Vector2(512, 254)]), VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.24))
			draw_colored_polygon(PackedVector2Array([Vector2(164, 220), Vector2(208, 216), Vector2(214, 268), Vector2(158, 272)]), VectorStageStyle.HUMAN_AMBER)
		31:
			# Evidence archive: shelves recede toward a quiet row of chairs; the
			# missing people occupy the negative space more than the props do.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 48), Vector2(412, 38), Vector2(428, 278), Vector2(0, 278)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(452, 48), Vector2(624, 60), Vector2(624, 278), Vector2(448, 278)]), VectorStageStyle.INK)
			for x in [38.0, 112.0, 186.0, 260.0, 334.0]:
				draw_colored_polygon(PackedVector2Array([Vector2(x, 86), Vector2(x + 52.0, 82), Vector2(x + 48.0, 204), Vector2(x + 4.0, 208)]), VectorStageStyle.DEEP_PLANE)
				draw_line(Vector2(x + 6.0, 126.0), Vector2(x + 46.0, 123.0), VectorStageStyle.LIGHT_PLANE, 1.0)
				draw_line(Vector2(x + 6.0, 166.0), Vector2(x + 46.0, 163.0), VectorStageStyle.LIGHT_PLANE, 1.0)
			draw_colored_polygon(PackedVector2Array([Vector2(72, 230), Vector2(320, 218), Vector2(336, 264), Vector2(58, 274)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(136, 208), Vector2(158, 206), Vector2(160, 258), Vector2(136, 260)]), VectorStageStyle.HUMAN_AMBER)
			draw_colored_polygon(PackedVector2Array([Vector2(334, 176), Vector2(354, 176), Vector2(356, 242), Vector2(336, 242)]), VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.34))
		32:
			# Glass corridor: three upright panes create a broken rhythm around a
			# narrow route, while the centre remains a deliberate field of attention.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 42), Vector2(198, 54), Vector2(210, 278), Vector2(0, 278)]), VectorStageStyle.DEEP_PLANE, 0.0)
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(438, 50), Vector2(624, 40), Vector2(624, 278), Vector2(444, 278)]), VectorStageStyle.MID_PLANE, 0.0)
			for x in [82.0, 212.0, 474.0]:
				draw_colored_polygon(PackedVector2Array([Vector2(x, 64), Vector2(x + 66.0, 60), Vector2(x + 58.0, 260), Vector2(x + 6.0, 264)]), VectorStageStyle.LIGHT_PLANE)
				draw_colored_polygon(PackedVector2Array([Vector2(x + 10.0, 78), Vector2(x + 54.0, 74), Vector2(x + 48.0, 244), Vector2(x + 14.0, 248)]), VectorStageStyle.INK)
			draw_line(Vector2(318, 74), Vector2(318, 250), VectorStageStyle.ANCHOR_CYAN, 1.5)
			draw_colored_polygon(PackedVector2Array([Vector2(548, 206), Vector2(576, 204), Vector2(582, 266), Vector2(552, 268)]), VectorStageStyle.HUMAN_AMBER)
		33:
			# Service shaft: a vertical void is held by two structural planes; the
			# witness frame sits low so the route remains a working service floor.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 38), Vector2(238, 48), Vector2(222, 278), Vector2(0, 278)]), VectorStageStyle.MID_PLANE, 0.0)
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(420, 44), Vector2(624, 34), Vector2(624, 278), Vector2(430, 278)]), VectorStageStyle.DEEP_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(248, 42), Vector2(408, 42), Vector2(420, 278), Vector2(230, 278)]), VectorStageStyle.INK)
			for x in [62.0, 112.0, 480.0, 530.0]:
				draw_colored_polygon(PackedVector2Array([Vector2(x, 68), Vector2(x + 12.0, 66), Vector2(x + 16.0, 264), Vector2(x + 4.0, 266)]), VectorStageStyle.LIGHT_PLANE)
			draw_line(Vector2(270, 78), Vector2(396, 78), VectorStageStyle.ANCHOR_CYAN, 1.5)
			draw_line(Vector2(292, 92), Vector2(374, 92), VectorStageStyle.CORRECTION_OXIDE, 1.0)
			draw_colored_polygon(PackedVector2Array([Vector2(116, 220), Vector2(160, 216), Vector2(164, 268), Vector2(110, 272)]), VectorStageStyle.HUMAN_AMBER)
		34:
			# Exchange core: a single vertical axis and a dark central field keep
			# the machine legible without turning the room into a dense diagram.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 44), Vector2(228, 38), Vector2(220, 278), Vector2(0, 278)]), VectorStageStyle.DEEP_PLANE, 0.0)
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(418, 40), Vector2(624, 52), Vector2(624, 278), Vector2(424, 278)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(242, 56), Vector2(404, 56), Vector2(414, 278), Vector2(232, 278)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(282, 88), Vector2(364, 82), Vector2(376, 222), Vector2(270, 226)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(308, 106), Vector2(352, 102), Vector2(358, 210), Vector2(300, 214)]), VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.22))
			draw_colored_polygon(PackedVector2Array([Vector2(468, 216), Vector2(528, 212), Vector2(536, 268), Vector2(460, 272)]), VectorStageStyle.CORRECTION_OXIDE)
			draw_colored_polygon(PackedVector2Array([Vector2(92, 222), Vector2(138, 218), Vector2(144, 270), Vector2(86, 274)]), VectorStageStyle.HUMAN_AMBER)
		35:
			# Filtration hall: long basin planes sit below an unobstructed service
			# route, with the rejected memory sediment kept as one low accent.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 46), Vector2(624, 38), Vector2(624, 176), Vector2(0, 188)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(0, 204), Vector2(624, 196), Vector2(624, 278), Vector2(0, 278)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(48, 222), Vector2(264, 216), Vector2(270, 274), Vector2(42, 278)]), VectorStageStyle.DEEP_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(332, 218), Vector2(536, 214), Vector2(544, 274), Vector2(326, 278)]), VectorStageStyle.DEEP_PLANE)
			for x in [86.0, 188.0, 392.0, 492.0]:
				draw_colored_polygon(PackedVector2Array([Vector2(x, 78), Vector2(x + 14.0, 76), Vector2(x + 18.0, 190), Vector2(x + 4.0, 192)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(278, 154), Vector2(360, 150), Vector2(366, 188), Vector2(272, 192)]), VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.22))
			draw_colored_polygon(PackedVector2Array([Vector2(556, 216), Vector2(592, 214), Vector2(596, 268), Vector2(558, 270)]), VectorStageStyle.HUMAN_AMBER)
		36:
			# Odpływ: upper channel planes and a low water band leave the maintenance route open.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 48), Vector2(624, 42), Vector2(624, 154), Vector2(0, 166)]), VectorStageStyle.DEEP_PLANE, 0.0)
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 196), Vector2(624, 184), Vector2(624, 278), Vector2(0, 278)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(54, 214), Vector2(276, 208), Vector2(284, 270), Vector2(48, 276)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(332, 216), Vector2(546, 210), Vector2(554, 270), Vector2(326, 276)]), VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.20))
			draw_colored_polygon(PackedVector2Array([Vector2(286, 144), Vector2(362, 140), Vector2(368, 176), Vector2(280, 180)]), VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.34))
		37:
			# Węzeł nadawczy: rack planes frame a dark signal bay and a restrained relay line.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 42), Vector2(202, 50), Vector2(214, 278), Vector2(0, 278)]), VectorStageStyle.MID_PLANE, 0.0)
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(430, 48), Vector2(624, 38), Vector2(624, 278), Vector2(438, 278)]), VectorStageStyle.DEEP_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(234, 58), Vector2(410, 58), Vector2(420, 278), Vector2(224, 278)]), VectorStageStyle.INK)
			for x in [62.0, 112.0, 462.0, 512.0]:
				draw_colored_polygon(PackedVector2Array([Vector2(x, 74), Vector2(x + 24.0, 72), Vector2(x + 28.0, 246), Vector2(x + 4.0, 250)]), VectorStageStyle.LIGHT_PLANE)
			draw_line(Vector2(260, 92), Vector2(392, 92), VectorStageStyle.ANCHOR_CYAN, 1.5)
			draw_colored_polygon(PackedVector2Array([Vector2(276, 206), Vector2(324, 202), Vector2(330, 262), Vector2(270, 266)]), VectorStageStyle.HUMAN_AMBER)
			draw_colored_polygon(PackedVector2Array([Vector2(382, 122), Vector2(398, 120), Vector2(400, 168), Vector2(384, 170)]), VectorStageStyle.CORRECTION_OXIDE)
		38:
			# Rdzeń wypadku: side planes hold a dark accident field while the living witness remains legible.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 46), Vector2(184, 40), Vector2(198, 278), Vector2(0, 278)]), VectorStageStyle.DEEP_PLANE, 0.0)
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(476, 48), Vector2(624, 58), Vector2(624, 278), Vector2(480, 278)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(212, 56), Vector2(466, 56), Vector2(478, 278), Vector2(198, 278)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(236, 196), Vector2(350, 190), Vector2(360, 270), Vector2(224, 276)]), VectorStageStyle.HUMAN_AMBER)
			draw_colored_polygon(PackedVector2Array([Vector2(388, 206), Vector2(444, 202), Vector2(450, 264), Vector2(382, 268)]), VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.46))
			draw_line(Vector2(226, 116), Vector2(452, 110), VectorStageStyle.ANCHOR_CYAN, 1.0)
		39:
			# Komora referencyjna: three quiet configuration markers orbit one open central field.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 44), Vector2(196, 52), Vector2(208, 278), Vector2(0, 278)]), VectorStageStyle.MID_PLANE, 0.0)
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(432, 48), Vector2(624, 42), Vector2(624, 278), Vector2(442, 278)]), VectorStageStyle.DEEP_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(218, 58), Vector2(414, 58), Vector2(424, 278), Vector2(208, 278)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(264, 92), Vector2(334, 88), Vector2(338, 154), Vector2(260, 158)]), VectorStageStyle.ANCHOR_CYAN)
			draw_colored_polygon(PackedVector2Array([Vector2(348, 90), Vector2(418, 94), Vector2(418, 158), Vector2(350, 154)]), VectorStageStyle.HUMAN_AMBER)
			draw_colored_polygon(PackedVector2Array([Vector2(296, 180), Vector2(372, 176), Vector2(378, 238), Vector2(290, 242)]), VectorStageStyle.CORRECTION_OXIDE)
			draw_line(Vector2(248, 266), Vector2(418, 260), VectorStageStyle.LIGHT_PLANE, 1.0)
		40:
			# Sala negocjacyjna: a broad institutional plane opens toward a dawn-coloured exit field.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 42), Vector2(624, 48), Vector2(624, 174), Vector2(0, 166)]), VectorStageStyle.LIGHT_PLANE, 0.0)
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 184), Vector2(624, 192), Vector2(624, 278), Vector2(0, 278)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(50, 72), Vector2(246, 70), Vector2(246, 164), Vector2(48, 160)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(272, 72), Vector2(458, 76), Vector2(458, 168), Vector2(272, 164)]), VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.42))
			draw_colored_polygon(PackedVector2Array([Vector2(494, 70), Vector2(606, 74), Vector2(606, 168), Vector2(494, 164)]), VectorStageStyle.ANCHOR_CYAN)
			draw_colored_polygon(PackedVector2Array([Vector2(170, 216), Vector2(454, 218), Vector2(462, 270), Vector2(164, 268)]), VectorStageStyle.DEEP_PLANE)
