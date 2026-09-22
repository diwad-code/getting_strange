#!/usr/bin/env python3
"""PKG-0199 helper: audit + extract MRP pilot renderers 67..196.
Usage:
  python3 tools/extract_mrp_pilot.py --audit        # report only
  python3 tools/extract_mrp_pilot.py --extract      # write helper + patch facade
Reads scripts/interactables/memory_resonance_point.gd
"""
import re, sys, pathlib

MRP = pathlib.Path("scripts/interactables/memory_resonance_point.gd")
HELPER = pathlib.Path("scripts/interactables/mrp_legacy_renderer.gd")

def parse_enum(text):
    m = re.search(r"enum PropType \{(.*?)\n\}", text, re.S)
    assert m, "enum not found"
    body = m.group(1)
    pairs = re.findall(r"(\w+)\s*=\s*(\d+)", body)
    return [(n, int(v)) for n, v in pairs]

def func_block(text, func_name):
    # find "func _draw_x(" at line start
    pat = re.compile(r"(?m)^func " + re.escape(func_name) + r"\(.*?\).*?:\n")
    mm = pat.search(text)
    if not mm:
        return None, None, None
    start = mm.start()
    # next top-level func
    nxt = re.search(r"(?m)^func ", text[mm.end():])
    end = mm.end() + nxt.start() if nxt else len(text)
    return text[start:end], start, end

def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "--audit"
    text = MRP.read_text(encoding="utf-8")
    enum_pairs = parse_enum(text)
    pilot = [(n, v) for n, v in enum_pairs if 67 <= v <= 196]
    print(f"enum total={len(enum_pairs)} pilot67_196={len(pilot)}")
    assert len(pilot) == 130, f"expected 130 pilot types, got {len(pilot)}"
    # check each has func
    missing = []
    blocks = {}
    for name, val in pilot:
        fname = "_draw_" + name.lower()
        blk, s, e = func_block(text, fname)
        if blk is None:
            missing.append((name, fname))
        else:
            blocks[name] = (fname, blk)
    print(f"pilot funcs found={len(blocks)} missing={len(missing)}")
    for m in missing[:20]:
        print("MISSING", m)
    # audit problematic patterns inside pilot bodies
    probs = []
    pat_bad = re.compile(r"self\.|queue_redraw|emit\s*\(|GameState|GameStateManager|AudioStream|AudioServer|CPUParticles|add_child|create_|collect_clue|trigger_interaction|_resonance_flash|_contact_progress|_touch_flash|_spawn_grace|interaction_radius|resonance_id|prop_title|prop_subtitle|is_one_shot|shadow_progress")
    pat_inner_draw = re.compile(r"(?<![\w.])_draw_[a-z_]+prüng")
    for name, (fname, blk) in blocks.items():
        # strip first line (signature)
        body = blk.split("\n", 1)[1] if "\n" in blk else ""
        for bad in ["self.", "queue_redraw", ".emit(", "GameState", "AudioStream", "CPUParticles", "add_child", "collect_clue", "trigger_interaction", "_resonance_flash", "_contact_progress", "_touch_flash", "_spawn_grace", "interaction_radius", "resonance_id", "prop_title", "prop_subtitle", "is_one_shot", "shadow_progress"]:
            if bad in body:
                probs.append((name, fname, bad))
        # inner _draw_ calls (exclude dispatch file-level _draw which is not in body)
        for mm in re.finditer(r"(?<![\w.])_draw_[a-z_]+\(\)", body):
            # allow nothing? report
            probs.append((name, fname, "inner:" + mm.group(0)))
    print(f"problem hits={len(probs)}")
    for p in probs[:60]:
        print("PROB", p)
    # state usage summary
    for tok in ["is_activated", "_pulse_phase", "is_player_in_range", "COLOR_AMBER", "COLOR_CYAN", "COLOR_INFRASTRUCTURE", "COLOR_DARK_STEEL", "COLOR_CORRECTION", "COLOR_BACKGROUND"]:
        c = sum(blk.count(tok) for _, blk in blocks.values())
        print(f"{tok}: {c}")
    # draw_ call kinds
    kinds = {}
    for _, blk in blocks.values():
        for mm in re.finditer(r"(?<![\w.])draw_[a-z_]+", blk):
            kinds[mm.group(0)] = kinds.get(mm.group(0), 0) + 1
    print("draw kinds:", kinds)
    if mode == "--audit":
        return
    # ---- extract ----
    # Build helper file
    header = '''class_name MrpLegacyRenderer
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

'''
    parts = [header]
    sig_map: dict = {}
    for name, val in pilot:
        fname = "_draw_" + name.lower()
        blk = blocks[name][1]
        lines = blk.split("\n")
        short = fname[len("_draw_"):]
        body_src = "\n".join(lines[1:])
        need_act = "is_activated" in body_src
        need_pulse = "_pulse_phase" in body_src
        need_range = "is_player_in_range" in body_src
        params = ["ci: CanvasItem"]
        args = ["self"]
        if need_act:
            params.append("p_is_activated: bool")
            args.append("is_activated")
        if need_pulse:
            params.append("p_pulse: float")
            args.append("_pulse_phase")
        if need_range:
            params.append("p_in_range: bool")
            args.append("is_player_in_range")
        sig_map[name] = (params, args)
        new_sig = f"static func draw_{short}({', '.join(params)}) -> void:"
        body_lines = lines[1:]
        out = []
        for ln in body_lines:
            nl = ln.replace("is_player_in_range", "p_in_range")
            nl = nl.replace("is_activated", "p_is_activated")
            nl = nl.replace("_pulse_phase", "p_pulse")
            nl = re.sub(r"(?<![\w.])draw_", "ci.draw_", nl)
            out.append(nl)
        while out and out[-1].strip() == "":
            out.pop()
        parts.append(new_sig + "\n" + "\n".join(out) + "\n\n\n")
    HELPER.write_text("".join(parts), encoding="utf-8")
    print(f"wrote {HELPER} bytes={HELPER.stat().st_size}")
    # Patch facade: replace each pilot func block with delegating wrapper
    new_text = text
    # do replacements from end to start to keep offsets valid
    # recompute blocks on current new_text progressively? simpler: replace by func name search each time
    for name, val in pilot:
        fname = "_draw_" + name.lower()
        short = fname[len("_draw_"):]
        blk, s, e = func_block(new_text, fname)
        assert blk is not None, fname
        _params, args = sig_map[name]
        wrapper = f"func {fname}() -> void:\n\t# PKG-0199 pilot: logic lives in MrpLegacyRenderer (F-0184-010, PropType {val}).\n\tMrpLegacyRenderer.draw_{short}({', '.join(args)})\n\n\n"
        new_text = new_text[:s] + wrapper + new_text[e:]
    MRP.write_text(new_text, encoding="utf-8")
    print(f"patched {MRP}")
    # quick counts
    import subprocess
    print("MRP func _draw_ count:", new_text.count("func _draw_"))
    print("MRP func count:", new_text.count("func "))

if __name__ == "__main__":
    main()
