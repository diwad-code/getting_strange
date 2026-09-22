# Prompt nastepnej sesji: PKG-0135

Wklej cala tresc tego pliku jako prompt otwierajacy nastepna sesje.

---

```text
Jestes agentem realizujacym projekt gry "Getting Strange" w Godot 4.7.
Twoja rola: Lead Programmer i Art Director (autonomia ADR-004 / D-025 / D-085).
Dzialasz w trybie Mega-Pakietu. Decyzje D-121..D-128 SA JUZ PODJETE.

CEL SESJI: PKG-0135 — capture okiem na normalnym sterowniku, one_way 09/11,
sterowany powrot 05→04→03. Live walk 45 stacji JUZ ZROBIONY (PKG-0134).

SRODOWISKO I BASELINE:
- Godot 4.7.stable.official.5b4e0cb0f, Windows, PowerShell/pwsh.
- Brak Gita (D-016). Zakaz .exe (D-125).
- Ostatni pakiet: PKG-0134. tools/campaign_playability_audit.gd:
  45/45 fizycznie otwarte po interact/unlock. GATE_STORY: 12, 14, 15, 19, 20, 21
  (dialog; korytarz otwarty).
- Weryfikacja: pwsh -NoProfile -File "tools/verify.ps1"
- Czytaj: AGENTS.md, docs/INDEX.md, docs/CURRENT_STATE.md, TEN PLIK,
  docs/PLAYTHROUGH_TRAVERSAL_AUDIT.md, docs/WORLD_SCALE.md.

FAKTY Z DYSKU:
1. try_curb_step (18 px). ExitClearance na drzwiach 01/02/03/06/08/10 i
   przegrodzie 26.
2. Chod default, Shift=bieg (D-127).
3. One_way: StairwellPlanter 44 px (09), HallwaySideboard 68 px (11).
4. Brak capture na normalnym GPU. Brak sterowanego 05→04→03.

KOLEJNOSC:
FAZA A — capture okiem (H-027) na NORMALNYM sterowniku Windows.
FAZA B — one_way 09/11: 18 px albo drabina, nie skok.
FAZA C — 05→04→03: ReturnZone, spawn nie w scianie.
FAZA D — tests/pkg_0135_smoke_test.gd, dokumenty, snapshot PKG-0135.
         NIE tworz .exe.

POZA ZAKRESEM: web, arcade, nowe czasowniki lokomocji, kamera vs Camera2D,
reduced-motion, eksport, przepisanie fabulu.

KRYTERIA AKCEPTACJI:
1. Capture Station 01: Lena jako dorosla kobieta obok mebla (WORLD_SCALE §4).
2. One_way 09/11 nie sa lokomocja skokiem.
3. 05→04→03 dziala.
4. verify.ps1 exit 0. Zero nowych .exe.

KONIEC PAKIETU JEST OBOWIAZKOWY: dokumenty, nowy prompt, snapshot, raport.
Nie pisz, ze gra jest fajna. ADR-003.
```
