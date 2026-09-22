#!/usr/bin/env python3
"""PKG-0174: neutralize airlock auto-complete on the P9 route and scale door colliders."""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(r"C:\getting_strange")
ROUTE = [
    f"station_{n:02d}" for n in range(1, 19)
] + ["station_42a", "station_42b", "station_42c", "station_43"]

DOOR_SIZES = {
    "station_01": ("Rectangle_door", "54, 114"),
    "station_02": ("Rectangle_door", "54, 114"),
    "station_03": ("Rectangle_door", "58, 105"),
    "station_04": ("Rectangle_exit_doors", "58, 105"),
    "station_07": ("Rectangle_door", "45, 109"),
    "station_08": ("Rectangle_door", "45, 109"),
    "station_12": ("Rectangle_balcony_door", "48, 112"),
}


def patch_script(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    original = text
    text = text.replace(
        'call_deferred("_complete_if_player_already_in_airlock")',
        "pass  # PKG-0174: ThresholdZone requires interact",
    )
    text = re.sub(
        r"ExitClearance\.open_body_tweened\(self,\s*([A-Za-z0-9_]+)(?:,[^\)]*)?\)",
        r"ExitClearance.disable_collision(\1)",
        text,
    )

    def silence_handler(match: re.Match) -> str:
        header = match.group(1)
        return (
            f"{header}(_body: Node2D) -> void:\n"
            "\t# PKG-0174: AirlockZone is a closure zone, not a trigger.\n"
            "\tpass\n"
        )

    text = re.sub(
        r"(func _on_airlock(?:_zone)?(?:_body)?_entered)\([^)]*\)\s*->\s*void:\n(?:\t.*\n)+?(?=\nfunc |\n\nfunc |\Z)",
        silence_handler,
        text,
        count=1,
    )
    # Oversize door drawings — leave a comment; ThresholdZone paints the aperture.
    replacements = {
        "draw_rect(Rect2(600.0, 144.0, 20.0, 118.0), VectorStageStyle.INK)": (
            "pass  # PKG-0174: aperture from ThresholdZone"
        ),
        "draw_rect(Rect2(542.0, 160.0, 56.0, 146.0), VectorStageStyle.INK)": (
            "pass  # PKG-0174: aperture from ThresholdZone"
        ),
        "draw_rect(Rect2(542.0, 160.0, 56.0, 146.0), door_indicator, false, 2.0)": "pass",
        "draw_rect(Rect2(540.0, 120.0, 60.0, 176.0), VectorStageStyle.INK)": (
            "pass  # PKG-0174: exit aperture from ThresholdZone"
        ),
        "draw_rect(Rect2(540.0, 120.0, 60.0, 176.0), door14_color, false, 2.0)": "pass",
        "draw_rect(Rect2(160.0, 140.0, 48.0, 156.0), VectorStageStyle.INK)": (
            "draw_rect(Rect2(160.0, 187.0, 45.0, 109.0), VectorStageStyle.INK)"
        ),
        "draw_rect(Rect2(160.0, 140.0, 48.0, 156.0), door12_color, false, 1.5)": (
            "draw_rect(Rect2(160.0, 187.0, 45.0, 109.0), door12_color, false, 1.5)"
        ),
        "draw_rect(Rect2(576.0, 178.0, 34.0, 82.0), VectorStageStyle.INK)": "pass  # PKG-0174: vehicle aperture",
        "draw_line(Vector2(592.0, 184.0), Vector2(592.0, 254.0), door_color, 2.0)": "pass",
    }
    for old, new in replacements.items():
        text = text.replace(old, new)
    if text != original:
        path.write_text(text, encoding="utf-8")
        print("patched", path.name)


def patch_tscn(station_id: str, shape_id: str, size: str) -> None:
    path = ROOT / "scenes" / "levels" / f"{station_id}.tscn"
    if not path.exists():
        print("missing", path)
        return
    text = path.read_text(encoding="utf-8")
    pattern = rf"(\[sub_resource type=\"RectangleShape2D\" id=\"{shape_id}\"\]\n)size = Vector2\([^\)]+\)"
    new = rf"\1size = Vector2({size})"
    updated, n = re.subn(pattern, new, text, count=1)
    if n:
        path.write_text(updated, encoding="utf-8")
        print("tscn", station_id, size)
    else:
        print("no door shape", station_id, shape_id)


def patch_smoke_test() -> None:
    path = ROOT / "tests" / "smoke_test.gd"
    text = path.read_text(encoding="utf-8")
    helper = '''
func _cross_exit(station: Node) -> void:
	var player := station.get_node_or_null("Player") as PrototypePlayer
	if station.get_node_or_null("Threshold") != null:
		ThresholdBinder.complete_from_test(station, player)
		await physics_frame
		return
	if player != null:
		var airlock := station.get_node_or_null("AirlockZone") as Area2D
		if airlock != null:
			player.global_position = airlock.global_position
		await physics_frame
		await physics_frame


'''
    if "func _cross_exit(" not in text:
        # Insert before first station test.
        text = text.replace("func _test_station_01() -> void:", helper + "func _test_station_01() -> void:")
    text = re.sub(
        r"\tvar player := station.get_node_or_null\(\"Player\"\) as PrototypePlayer\n"
        r"\tif player:\n"
        r"\t\tplayer\.global_position = Vector2\(615\.0, [0-9.]+\)\n"
        r"\t\tawait physics_frame\n"
        r"\t\tawait physics_frame\n"
        r"\t_expect\(station\.is_level_completed, \"([^\"]+)\"\)",
        r"\tawait _cross_exit(station)\n"
        r"\t_expect(station.is_level_completed, \"\1\")",
        text,
    )
    # station_03 return-zone sandwich
    text = text.replace(
        """	var player := station.get_node_or_null("Player") as PrototypePlayer
	if player:
		player.global_position = Vector2(15.0, 238.0)
		await physics_frame
		await physics_frame
	_expect(not station.is_level_completed, "station_03 must NOT complete at the ReturnZone")
	if player:
		player.global_position = Vector2(615.0, 238.0)
		await physics_frame
		await physics_frame
	_expect(station.is_level_completed, "station_03 must complete on entering the AirlockZone")""",
        """	var player := station.get_node_or_null("Player") as PrototypePlayer
	if player:
		player.global_position = Vector2(15.0, 238.0)
		await physics_frame
		await physics_frame
	_expect(not station.is_level_completed, "station_03 must NOT complete at the ReturnZone")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station_03 must complete through ThresholdZone")""",
    )
    path.write_text(text, encoding="utf-8")
    print("patched smoke_test.gd")


def patch_pkg_0138() -> None:
    path = ROOT / "tests" / "pkg_0138_smoke_test.gd"
    text = path.read_text(encoding="utf-8")
    old = """			if airlock:
				await _walk_to(player, airlock.global_position.x, 400)
				player.set_physics_process(true)
				for _i in 8:
					await physics_frame"""
    new = """			if station_id in ["station_01", "station_07", "station_10", "station_13", "station_15", "station_16", "station_17", "station_18", "station_42a", "station_43"] or st.get_node_or_null("Threshold") != null:
				ThresholdBinder.complete_from_test(st, player)
				await process_frame
			elif airlock:
				await _walk_to(player, airlock.global_position.x, 400)
				player.set_physics_process(true)
				for _i in 8:
					await physics_frame"""
    # Fix variable name: the loop uses s_id / st
    old = """			if airlock:
				await _walk_to(player, airlock.global_position.x, 400)
				player.set_physics_process(true)
				for _i in 8:
					await physics_frame"""
    new = """			if st.get_node_or_null("Threshold") != null:
				ThresholdBinder.complete_from_test(st, player)
				await process_frame
			elif airlock:
				await _walk_to(player, airlock.global_position.x, 400)
				player.set_physics_process(true)
				for _i in 8:
					await physics_frame"""
    if old not in text:
        print("pkg_0138 pattern missing")
        return
    path.write_text(text.replace(old, new), encoding="utf-8")
    print("patched pkg_0138")


def main() -> None:
    for sid in ROUTE:
        script = ROOT / "scripts" / "levels" / f"{sid}.gd"
        if script.exists():
            patch_script(script)
        else:
            print("missing script", sid)
    for sid, (shape, size) in DOOR_SIZES.items():
        patch_tscn(sid, shape, size)
    patch_smoke_test()
    patch_pkg_0138()


if __name__ == "__main__":
    main()
