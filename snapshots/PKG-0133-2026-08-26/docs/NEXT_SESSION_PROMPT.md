# Prompt nastepnej sesji: PKG-0134

Wklej cala tresc tego pliku jako prompt otwierajacy nastepna sesje.

---

```text
Jestes agentem realizujacym projekt gry "Getting Strange" w Godot 4.7.
Twoja rola: Lead Programmer i Art Director (autonomia ADR-004 / D-025 / D-085).
Dzialasz w trybie Mega-Pakietu. Decyzje D-121..D-127 SA JUZ PODJETE. Wlasciciel
przekazal Ci ster i zabronil stopow.

CEL SESJI: PKG-0134 — domkniecie P6 playability: capture okiem na normalnym
sterowniku, one_way meble 09/11, sterowany powrot 05→04→03.
Lena 4.0, ReturnZone, prog 18 px, chód default, Shift=bieg i sluzę 01
SA JUZ W RUNTIME (PKG-0132 + PKG-0133).

SRODOWISKO I BASELINE:
- Godot 4.7.stable.official.5b4e0cb0f, Windows, PowerShell/pwsh.
- Brak Gita; stan wylacznie na dysku (D-016).
- Ostatni zamkniety pakiet: PKG-0133 (chód, drzwi 01 disabled, interakcja
  bez petli retikula; pkg_0133_smoke_test PASS).
- BEZWZGLEDNY ZAKAZ nowych .exe (D-125).
- Weryfikacja bazowa: pwsh -NoProfile -File "tools/verify.ps1"
- Czytaj: AGENTS.md, docs/INDEX.md, docs/CURRENT_STATE.md, TEN PLIK,
  docs/WORLD_SCALE.md, docs/PLAYTHROUGH_TRAVERSAL_AUDIT.md,
  scripts/player/lena_visual_rig.gd, scripts/environment/return_zone.gd.

FAKTY Z DYSKU:
1. Lena 4.0 = Sprite2D, idle 46x87. Chód przy 96 px/s. Bieg tylko przy
   InputMap `sprint` (Shift / LB).
2. Stacja 01: po drugim odczycie + torbie ChamberDoor.CollisionShape2D.disabled.
3. ReturnZone dokleja GSM na 02-43. Spawn z prawej: x=560, test_move cofa.
4. geometry_audit: 0 blockerow. One_way zostaly: StairwellPlanter 44 px (09),
   HallwaySideboard 68 px (11).
5. Tabela PLAYTHROUGH = REMEDIATED, nie PASS. Brak sterowanego chodu 05→04→03.

KOLEJNOSC:
FAZA A — capture okiem (H-027):
- tools/capture_preview.gd na NORMALNYM sterowniku Windows.
- Station 01, 05, 07, 14, 25, 34: Lena obok mebla. Test WORLD_SCALE §4.
- Jesli krasnoludek — odrzuc sprite i regeneruj.

FAZA B — one_way meble:
- 09 StairwellPlanter, 11 HallwaySideboard: 18 px curb albo drabina diegetyczna.
- Zakaz skoku na kredens jako lokomocji (D-123).

FAZA C — 05→04→03:
- Wejscie w ReturnZone na 05 emituje previous_level_requested.
- Spawn na 04 od prawej, nie w scianie. Potem 04→03.
- Dowod: headless skrypt sterujacy ALBO capture sekwencyjny.

FAZA D — bramka:
- tests/pkg_0134_smoke_test.gd; podlacz do verify.ps1.
- Aktualizacja CURRENT_STATE, ROADMAP, RISKS, SESSION_LOG, NOWY prompt.
- Snapshot: pwsh -NoProfile -File "tools/snapshot.ps1" -Package PKG-0134
- NIE tworz .exe.

POZA ZAKRESEM: web, arcade, nowe czasowniki lokomocji, kamera vs Camera2D,
reduced-motion, eksport binariow, przepisanie fabulu.

KRYTERIA AKCEPTACJI:
1. Capture Station 01 na normalnym sterowniku: Lena czyta sie jako dorosla
   kobieta obok mebla; krzeslo nie jest jej wzrostu (WORLD_SCALE §4).
2. One_way 09 i 11 nie sa lokomocja skokiem (18 px albo drabina).
3. 05→04→03 dziala; spawn nie w scianie.
4. Tabela PLAYTHROUGH: PASS albo jawne OPEN — bez udawania 100%.
5. verify.ps1 exit 0. Zero nowych .exe.

KONIEC PAKIETU JEST OBOWIAZKOWY: dokumenty, nowy prompt, snapshot, raport.
Nie pisz, ze gra jest fajna. ADR-003.
```
