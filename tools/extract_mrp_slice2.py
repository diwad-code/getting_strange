#!/usr/bin/env python3
"""PKG-0200 helper: audit + extract MRP slice2 renderers 0..66,197..202.
Usage:
  python tools/extract_mrp_slice2.py --audit
  python tools/extract_mrp_slice2.py --extract
Reads scripts/interactables/memory_resonance_point.gd, appends to
scripts/interactables/mrp_legacy_renderer.gd (which already holds 130 pilot
renderers 67..196 from PKG-0199), and replaces facade bodies with 1:1 wrappers.
Mechanical renames only:
  draw_* -> ci.draw_*, is_activated -> p_is_activated,
  _pulse_phase -> p_pulse, is_player_in_range -> p_in_range,
  shadow_progress -> p_shadow, _resonance_flash -> p_flash.
Minimal signatures per renderer (only read state), fixed param order:
  ci, p_is_activated, p_pulse, p_in_range, p_shadow, p_flash.
Three overlay helpers (_draw_in_world_reticule, _draw_resolved_mark,
_draw_contact_read) stay in the facade: reticule needs _resonance_flash as
flash envelope mixed with range, contact_read needs _contact_progress/
_touch_flash/interaction_radius (interaction state, not pure visual token).
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
    pat = re.compile(r"(?m)^func " + re.escape(func_name) + r"\(.*?\).*?:\n")
    mm = pat.search(text)
    if not mm:
        return None, None, None
    start = mm.start()
    nxt = re.search(r"(?m)^func ", text[mm.end():])
    end = mm.end() + nxt.start() if nxt else len(text)
    return text[start:end], start, end

def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "--audit"
    text = MRP.read_text(encoding="utf-8")
    enum_pairs = parse_enum(text)
    slice2 = [(n, v) for n, v in enum_pairs if v <= 66 or v >= 197]
    print(f"enum total={len(enum_pairs)} slice2_0_66_197_202={len(slice2)}")
    assert len(slice2) == 73, f"expected 73 slice2 types, got {len(slice2)}"
    missing = []
    blocks = {}
    for name, val in slice2:
        fname = "_draw_" + name.lower()
        blk, s, e = func_block(text, fname)
        if blk is None:
            missing.append((name, fname))
        else:
            blocks[name] = (fname, blk)
    print(f"slice2 funcs found={len(blocks)} missing={len(missing)}")
    for m_ in missing[:20]:
        print("MISSING", m_)
    # audit: forbid logic tokens; allow the 5 visual state tokens
    probs = []
    for name, (fname, blk) in blocks.items():
        body = blk.split("\n", 1)[1] if "\n" in blk else ""
        for bad in ["self.", "queue_redraw", ".emit(", "GameState", "AudioStream",
                    "CPUParticles", "add_child", "collect_clue", "trigger_interaction",
                    "_contact_progress", "_touch_flash", "_spawn_grace",
                    "interaction_radius", "resonance_id", "prop_title",
                    "prop_subtitle", "is_one_shot"]:
            if bad in body:
                probs.append((name, fname, bad))
        for mm in re.finditer(r"(?<![\w.])_draw_[a-z_]+\(\)", body):
            probs.append((name, fname, "inner:" + mm.group(0)))
    print(f"problem hits (excluding allowed visual state)={len(probs)}")
    for p in probs[:60]:
        print("PROB", p)
    # allowed visual state usage (informational)
    for tok in ["is_activated", "_pulse_phase", "is_player_in_range",
                "shadow_progress", "_resonance_flash"]:
        c = sum(blk.count(tok) for _, blk in blocks.values())
        print(f"{tok}: {c}")
    kinds = {}
    for _, blk in blocks.values():
        for mm in re.finditer(r"(?<![\w.])draw_[a-z_]+", blk):
            kinds[mm.group(0)] = kinds.get(mm.group(0), 0) + 1
    print("draw kinds:", kinds)
    if mode == "--audit":
        return
    # ---- extract ----
    helper_text = HELPER.read_text(encoding="utf-8")
    assert helper_text.count("static func draw_") == 130, \
        f"helper must hold 130 pilot renderers before slice2, got {helper_text.count('static func draw_')}"
    sig_map: dict = {}
    parts = []
    parts.append("\n## PKG-0200 slice2 — F-0184-010 MRP renderer extraction (PropType 0..66,197..202).\n")
    parts.append("## Same stateless contract as the PKG-0199 pilot, extended by two read-only\n")
    parts.append("## visual floats: shadow_progress -> p_shadow (export anim), _resonance_flash\n")
    parts.append("## -> p_flash (flash envelope). Bodies are verbatim moves from\n")
    parts.append("## MemoryResonancePoint (PKG-0199 baseline) with mechanical renames only.\n\n")
    for name, val in slice2:
        fname = "_draw_" + name.lower()
        blk = blocks[name][1]
        lines = blk.split("\n")
        short = fname[len("_draw_"):]
        body_src = "\n".join(lines[1:])
        need_act = "is_activated" in body_src
        need_pulse = "_pulse_phase" in body_src
        need_range = "is_player_in_range" in body_src
        need_shadow = "shadow_progress" in body_src
        need_flash = "_resonance_flash" in body_src
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
        if need_shadow:
            params.append("p_shadow: float")
            args.append("shadow_progress")
        if need_flash:
            params.append("p_flash: float")
            args.append("_resonance_flash")
        sig_map[name] = (params, args)
        new_sig = f"static func draw_{short}({', '.join(params)}) -> void:"
        body_lines = lines[1:]
        out = []
        for ln in body_lines:
            nl = ln.replace("is_player_in_range", "p_in_range")
            nl = nl.replace("is_activated", "p_is_activated")
            nl = nl.replace("_pulse_phase", "p_pulse")
            nl = nl.replace("shadow_progress", "p_shadow")
            nl = nl.replace("_resonance_flash", "p_flash")
            nl = re.sub(r"(?<![\w.])draw_", "ci.draw_", nl)
            out.append(nl)
        while out and out[-1].strip() == "":
            out.pop()
        parts.append(new_sig + "\n" + "\n".join(out) + "\n\n\n")
    with HELPER.open("a", encoding="utf-8") as f:
        f.write("".join(parts))
    print(f"appended 73 slice2 renderers to {HELPER}")
    # Patch facade
    new_text = text
    for name, val in slice2:
        fname = "_draw_" + name.lower()
        short = fname[len("_draw_"):]
        blk, s, e = func_block(new_text, fname)
        assert blk is not None, fname
        _params, args = sig_map[name]
        wrapper = f"func {fname}() -> void:\n\t# PKG-0200 slice2: logic lives in MrpLegacyRenderer (F-0184-010, PropType {val}).\n\tMrpLegacyRenderer.draw_{short}({', '.join(args)})\n\n\n"
        new_text = new_text[:s] + wrapper + new_text[e:]
    MRP.write_text(new_text, encoding="utf-8")
    print(f"patched {MRP}")
    print("MRP func _draw_ count:", new_text.count("func _draw_"))
    print("MRP func count:", new_text.count("func "))
    print("MRP PKG-0199 markers:", new_text.count("PKG-0199 pilot"))
    print("MRP PKG-0200 markers:", new_text.count("PKG-0200 slice2"))
    print("MRP delegations:", new_text.count("MrpLegacyRenderer.draw_"))

if __name__ == "__main__":
    main()
