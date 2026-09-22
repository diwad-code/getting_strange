extends SceneTree

## PKG-0186 gate — Cast Style Unification (Lena 4.1 language).
## Constants were measured on assets/characters/lena/idle.png on 2026-09-04.
## Plan §6.2 1.8× q16 does not fail current Marta (158 vs 105); q8 unique
## colours and large-region share do. Do not weaken these to green a doll.

const LENA_IDLE := "res://assets/characters/lena/idle.png"
const MARTA_IDLE := "res://assets/characters/marta/idle.png"
const JAKUB_IDLE := "res://assets/characters/jakub/idle.png"
const WIERZBICKA_IDLE := "res://assets/characters/wierzbicka/idle.png"
const WIERZBICKA_SEATED := "res://assets/characters/wierzbicka/seated.png"
const LENA_PORTRAIT := "res://assets/characters/portraits/lena.png"

## Measured on Lena idle 64×104, a>0.4, 2026-09-04.
const LENA_Q8 := 250
const LENA_Q16 := 105
const LENA_LARGE_SHARE := 0.160
const LENA_HEAD_Q16 := 76
const LENA_PORTRAIT_SOBEL := 25245.3

const Q8_MULT := 1.35
const Q16_MULT := 1.80
const LARGE_SHARE_FLOOR := 0.06
const HEAD_Q16_MULT := 1.40
const PINK_Q16_MAX := 60
const SOBEL_FLOOR := 0.70
const ALPHA := 0.4

const STANDING := ["marta", "jakub", "wierzbicka", "vendor", "neighbour"]
const PORTRAITS := ["marta", "jakub", "wierzbicka", "szymon"]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0186: " + message)


func _run() -> void:
	_test_primitives_cut()
	_test_retired_lanczos_pipeline()
	_test_vendor_neighbour_rigs()
	_test_sprite_language()
	_test_wierzbicka_seated_is_not_shrink()
	_test_portraits()
	_test_marta_hair_not_dress()
	_finish()


func _test_primitives_cut() -> void:
	var s06 := FileAccess.get_file_as_string("res://scripts/levels/station_06.gd")
	var s08 := FileAccess.get_file_as_string("res://scripts/levels/station_08.gd")
	_expect(not s06.contains("draw_circle(Vector2(420.0, 205.0)"), "station_06.gd must not paint the vendor circle-head at (420, 205)")
	_expect(not s08.contains("draw_circle(Vector2(340.0, 205.0)"), "station_08.gd must not paint the neighbour circle-head at (340, 205)")


func _test_retired_lanczos_pipeline() -> void:
	_expect(not FileAccess.file_exists("res://tools/process_npc_sprites.py"), "tools/process_npc_sprites.py must be retired (D-202)")
	_expect(FileAccess.file_exists("res://tools/retired/process_npc_sprites.py"), "Retired NPC LANCZOS pipeline must remain under tools/retired/")


func _test_vendor_neighbour_rigs() -> void:
	_expect(_scene_has_rig("res://scenes/levels/station_06.tscn", &"vendor"), "station_06 must contain CharacterVisualRig vendor")
	_expect(_scene_has_rig("res://scenes/levels/station_08.tscn", &"neighbour"), "station_08 must contain CharacterVisualRig neighbour")
	var rig_src := FileAccess.get_file_as_string("res://scripts/characters/character_visual_rig.gd")
	_expect(rig_src.contains("&\"vendor\""), "CharacterVisualRig STANDING_HEIGHTS must list vendor")
	_expect(rig_src.contains("&\"neighbour\""), "CharacterVisualRig STANDING_HEIGHTS must list neighbour")
	for character_id in ["vendor", "neighbour"]:
		var idle := "res://assets/characters/%s/idle.png" % character_id
		_expect(FileAccess.file_exists(idle), "%s idle sprite must exist" % character_id)


func _scene_has_rig(path: String, character_id: StringName) -> bool:
	if not FileAccess.file_exists(path):
		return false
	var text := FileAccess.get_file_as_string(path)
	return text.contains("character_visual_rig.gd") and text.contains("character_id = &\"%s\"" % String(character_id))


func _test_sprite_language() -> void:
	var lena := _metrics(LENA_IDLE)
	_expect(lena.ok, "Lena idle must load as the language master")
	if not lena.ok:
		return
	_expect(lena.q8 == LENA_Q8 or absi(lena.q8 - LENA_Q8) <= 8, "Lena idle q8 drifted (got %d, baked %d)" % [lena.q8, LENA_Q8])
	for character_id in STANDING:
		var path := "res://assets/characters/%s/idle.png" % character_id
		if character_id == "wierzbicka":
			path = WIERZBICKA_IDLE
		if not FileAccess.file_exists(path):
			_expect(false, "%s idle missing" % character_id)
			continue
		var m := _metrics(path)
		_expect(m.ok, "%s idle must load" % character_id)
		if not m.ok:
			continue
		_expect(m.w == 64 and m.h == 104, "%s idle canvas must be 64x104" % character_id)
		_expect(m.vis_h >= 84 and m.vis_h <= 92, "%s standing visible height must be 84-92 (got %d)" % [character_id, m.vis_h])
		_expect(m.q8 <= int(ceil(float(LENA_Q8) * Q8_MULT)), "%s q8 unique colours %d exceed 1.35× Lena %d (painterly doll)" % [character_id, m.q8, LENA_Q8])
		_expect(m.q16 <= int(ceil(float(LENA_Q16) * Q16_MULT)), "%s q16 unique colours %d exceed 1.8× Lena %d" % [character_id, m.q16, LENA_Q16])
		_expect(m.large_share + 0.0001 >= LARGE_SHARE_FLOOR, "%s large-region share %.3f is below 0.06 (fragmented doll)" % [character_id, m.large_share])
		_expect(m.head_q16 <= int(ceil(float(LENA_HEAD_Q16) * HEAD_Q16_MULT)), "%s head q16 %d exceed 1.4× Lena %d" % [character_id, m.head_q16, LENA_HEAD_Q16])


func _test_wierzbicka_seated_is_not_shrink() -> void:
	_expect(FileAccess.file_exists(WIERZBICKA_SEATED), "Wierzbicka seated sprite must exist")
	if not FileAccess.file_exists(WIERZBICKA_SEATED) or not FileAccess.file_exists(WIERZBICKA_IDLE):
		return
	var seated := _metrics(WIERZBICKA_SEATED)
	_expect(seated.vis_h >= 56 and seated.vis_h <= 60, "Wierzbicka seated visible height must be 56-60 (got %d)" % seated.vis_h)
	var idle_img := _load_image(WIERZBICKA_IDLE)
	var seated_img := _load_image(WIERZBICKA_SEATED)
	if idle_img == null or seated_img == null:
		return
	var correlation := _shrink_correlation(idle_img, seated_img)
	_expect(correlation < 0.82, "Wierzbicka seated must not be a shrink of standing idle (correlation %.3f)" % correlation)


func _test_portraits() -> void:
	var lena := _load_image(LENA_PORTRAIT)
	_expect(lena != null, "Lena portrait must remain the CRT master")
	if lena == null:
		return
	var lena_sobel := _portrait_sobel(lena)
	for name in PORTRAITS:
		var path := "res://assets/characters/portraits/%s.png" % name
		_expect(FileAccess.file_exists(path), "portrait %s.png must exist" % name)
		if not FileAccess.file_exists(path):
			continue
		var img := _load_image(path)
		if img == null:
			_expect(false, "portrait %s failed to load" % name)
			continue
		_expect(img.get_width() == 1024 and img.get_height() == 1024, "portrait %s must be 1024x1024" % name)
		var sobel := _portrait_sobel(img)
		_expect(sobel >= LENA_PORTRAIT_SOBEL * SOBEL_FLOOR, "portrait %s CRT Sobel %.1f is below 0.70× Lena (mush)" % [name, sobel])
	var marta := _load_image("res://assets/characters/portraits/marta.png")
	if marta != null:
		var bins := _pink_q16_bins(marta)
		_expect(bins <= PINK_Q16_MAX, "Marta portrait pink must be two flat shades, not a painterly gradient (%d q16 bins)" % bins)
		_expect(bins >= 2, "Marta portrait must still carry muted-pink hair (got %d pink bins)" % bins)


func _test_marta_hair_not_dress() -> void:
	var img := _load_image(MARTA_IDLE)
	if img == null:
		return
	var vis_top := img.get_height()
	var vis_bot := 0
	for y in img.get_height():
		for x in img.get_width():
			var p := img.get_pixel(x, y)
			if p.a <= ALPHA:
				continue
			vis_top = mini(vis_top, y)
			vis_bot = maxi(vis_bot, y)
	var torso_top := vis_top + int(float(vis_bot - vis_top) * 0.38)
	var torso_bot := vis_top + int(float(vis_bot - vis_top) * 0.72)
	var pink_torso := 0
	var cream_torso := 0
	for y in range(torso_top, torso_bot + 1):
		for x in img.get_width():
			var p := img.get_pixel(x, y)
			if p.a <= ALPHA:
				continue
			var luma := p.r * 0.2126 + p.g * 0.7152 + p.b * 0.0722
			if p.r > 0.42 and p.r > p.g + 0.06 and p.r > p.b and p.g < 0.58:
				pink_torso += 1
			elif luma > 0.62 and absf(p.r - p.g) < 0.12 and absf(p.g - p.b) < 0.12:
				cream_torso += 1
	_expect(cream_torso > pink_torso, "Marta idle dress must be cream, not pink (cream %d vs pink %d in torso)" % [cream_torso, pink_torso])


func _metrics(path: String) -> Dictionary:
	var img := _load_image(path)
	if img == null:
		return {ok = false, q8 = 0, q16 = 0, vis_h = 0, large_share = 0.0, head_q16 = 0, w = 0, h = 0}
	var q8 := {}
	var q16 := {}
	var opaque := 0
	var ymin := img.get_height()
	var ymax := -1
	for y in img.get_height():
		for x in img.get_width():
			var p := img.get_pixel(x, y)
			if p.a <= ALPHA:
				continue
			opaque += 1
			var r := clampi(int(p.r * 255.0), 0, 255)
			var g := clampi(int(p.g * 255.0), 0, 255)
			var b := clampi(int(p.b * 255.0), 0, 255)
			q8[Vector3i(r / 8, g / 8, b / 8)] = true
			q16[Vector3i(r / 16, g / 16, b / 16)] = true
			ymin = mini(ymin, y)
			ymax = maxi(ymax, y)
	var vis_h := (ymax - ymin + 1) if ymax >= 0 else 0
	var head_bot := ymin + int(float(vis_h) * 0.28)
	var head_q16 := {}
	for y in range(ymin, mini(head_bot, img.get_height()) + 1):
		for x in img.get_width():
			var p := img.get_pixel(x, y)
			if p.a <= ALPHA:
				continue
			var r := clampi(int(p.r * 255.0), 0, 255)
			var g := clampi(int(p.g * 255.0), 0, 255)
			var b := clampi(int(p.b * 255.0), 0, 255)
			head_q16[Vector3i(r / 16, g / 16, b / 16)] = true
	var large := _large_region_share(img, opaque)
	return {
		ok = true,
		q8 = q8.size(),
		q16 = q16.size(),
		vis_h = vis_h,
		large_share = large,
		head_q16 = head_q16.size(),
		w = img.get_width(),
		h = img.get_height(),
	}


func _large_region_share(img: Image, opaque: int) -> float:
	if opaque <= 0:
		return 0.0
	var w := img.get_width()
	var h := img.get_height()
	var seen := PackedByteArray()
	seen.resize(w * h)
	var large_px := 0
	for y in h:
		for x in w:
			if seen[y * w + x] != 0:
				continue
			var p := img.get_pixel(x, y)
			if p.a <= ALPHA:
				seen[y * w + x] = 1
				continue
			var r := clampi(int(p.r * 255.0), 0, 255) / 16
			var g := clampi(int(p.g * 255.0), 0, 255) / 16
			var b := clampi(int(p.b * 255.0), 0, 255) / 16
			var stack: Array[Vector2i] = [Vector2i(x, y)]
			seen[y * w + x] = 1
			var n := 0
			while not stack.is_empty():
				var c: Vector2i = stack.pop_back()
				n += 1
				for d in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
					var npos: Vector2i = c + d
					if npos.x < 0 or npos.y < 0 or npos.x >= w or npos.y >= h:
						continue
					if seen[npos.y * w + npos.x] != 0:
						continue
					var np := img.get_pixel(npos.x, npos.y)
					if np.a <= ALPHA:
						seen[npos.y * w + npos.x] = 1
						continue
					var nr := clampi(int(np.r * 255.0), 0, 255) / 16
					var ng := clampi(int(np.g * 255.0), 0, 255) / 16
					var nb := clampi(int(np.b * 255.0), 0, 255) / 16
					if nr == r and ng == g and nb == b:
						seen[npos.y * w + npos.x] = 1
						stack.append(npos)
			if n >= 20:
				large_px += n
	return float(large_px) / float(opaque)


func _load_image(path: String) -> Image:
	if not FileAccess.file_exists(path):
		return null
	var tex := load(path) as Texture2D
	if tex == null:
		return null
	return tex.get_image()


func _portrait_sobel(src: Image) -> float:
	var small := Image.create(56, 62, false, Image.FORMAT_RGBA8)
	small.copy_from(src)
	small.resize(56, 62, Image.INTERPOLATE_NEAREST)
	var acc := 0.0
	var n := 0
	for y in range(1, 61):
		for x in range(1, 55):
			var gx := 0.0
			var gy := 0.0
			gx += -_luma(small, x - 1, y - 1) - 2.0 * _luma(small, x - 1, y) - _luma(small, x - 1, y + 1)
			gx += _luma(small, x + 1, y - 1) + 2.0 * _luma(small, x + 1, y) + _luma(small, x + 1, y + 1)
			gy += -_luma(small, x - 1, y - 1) - 2.0 * _luma(small, x, y - 1) - _luma(small, x + 1, y - 1)
			gy += _luma(small, x - 1, y + 1) + 2.0 * _luma(small, x, y + 1) + _luma(small, x + 1, y + 1)
			acc += gx * gx + gy * gy
			n += 1
	return acc / maxf(1.0, float(n))


func _luma(img: Image, x: int, y: int) -> float:
	var p := img.get_pixel(x, y)
	return (p.r * 0.2126 + p.g * 0.7152 + p.b * 0.0722) * 255.0


func _pink_q16_bins(img: Image) -> int:
	var bins := {}
	for y in range(0, img.get_height(), 8):
		for x in range(0, img.get_width(), 8):
			var p := img.get_pixel(x, y)
			if p.a < 0.4:
				continue
			if p.r > 0.55 and p.b > 0.28 and p.g < 0.63:
				var r := clampi(int(p.r * 255.0), 0, 255) / 16
				var g := clampi(int(p.g * 255.0), 0, 255) / 16
				var b := clampi(int(p.b * 255.0), 0, 255) / 16
				bins[Vector3i(r, g, b)] = true
	return bins.size()


func _shrink_correlation(idle: Image, seated: Image) -> float:
	var idle_crop := idle.get_region(Rect2i(0, 0, idle.get_width(), int(float(idle.get_height()) * 0.72)))
	idle_crop.resize(seated.get_width(), seated.get_height(), Image.INTERPOLATE_NEAREST)
	var n := 0
	var close := 0
	for y in range(0, seated.get_height(), 2):
		for x in range(0, seated.get_width(), 2):
			var a := idle_crop.get_pixel(x, y)
			var b := seated.get_pixel(x, y)
			if a.a <= 0.2 and b.a <= 0.2:
				continue
			n += 1
			if absf(a.r - b.r) + absf(a.g - b.g) + absf(a.b - b.b) < 0.18 and absf(a.a - b.a) < 0.2:
				close += 1
	if n == 0:
		return 0.0
	return float(close) / float(n)


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0186 CAST STYLE PASS: Lena 4.1 language, 06/08 rigs, seated not shrink.")
		quit(0)
	else:
		print("PKG-0186 CAST STYLE FAIL: %d failures" % _failures.size())
		for failure in _failures:
			print(" - %s" % failure)
		quit(1)
