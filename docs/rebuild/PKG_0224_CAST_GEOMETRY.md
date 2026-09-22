# PKG-0224 — Rigi vendor/neighbour + profile Geometry (V7+V3, faza R7)

Data: 2026-09-13. Dyspozycja: `docs/NEXT_SESSION_PROMPT.md` po PKG-0223
(faza R7 planu PKG-0213 §8, findings V7/V3). Decyzja D-237.
Nie jest PRODUCT GO. GATE-REL, release i nowe `.exe` pozostaja BLOCKED BY D-168.

## Co zmieniono (asset + narzedzie + testy — zero stacji/scen/monolitow)

1. V7-naprawa — `assets/characters/jakub/seated.png`: na dysku lezal stojacy
   dubel (visible 89 px, jak idle) jako klatka siedzaca. Przebudowany
   pipeline'em CAST (`tools/process_cast_sprites.py`: flood tła, NEAREST,
   plotno 64x104, pivot 32,96, seated_h 58) ze zrodla
   `raw/pkg_0172_backup/seated.png` (prawdziwa poza siedzaca, stolek).
   Po naprawie: canvas 64x104, visible 58 px (pasmo 56-60), uziemiony y=96,
   ten sam mundur/szelki co idle. Kadry 06/08 HOLD (seated Jakuba nie
   wystepuje w 06/08; zmiana niewidoczna na trasie 06/08).
2. V7-pipeline — `tools/process_cast_sprites.py`: `seated` dopisany do CHARS
   jakuba z adnotacja o zrodle backup (brak raw 0186 dla tego stanu).
   Pelny re-run main niepotrzebny (pozostale klatki deterministyczne,
   nietkniete bajtowo poza seated).
3. V7-wyjatki (jawne, per postac — brak surowcow raw 0186, brak generacji
   w pakiecie, zakazany LANCZOS): vendor bez turn_away/seated/work/gesture
   (4/9 klatek: idle/talk_0/talk_1/listen); neighbour bez
   turn_away/seated/work (5/9: +gesture). Uzasadnienie rola: sprzedawca za
   lada okienna zawsze frontem do klienta (nigdy plecami, nigdy siedzac,
   praca = talk/gesture przy oknie); sasiadka na spoczniku — krotkie
   spotkanie, siedzenie/praca nie wystepuja. Rig dla brakujacych stanow
   renderuje piksele idle (kontrakt bible §4.1: nie crash, nie pusty
   sprite); station_06/08 wywoluja wylacznie talk/listen/idle.
4. V3-profile — 06 (miejska) vs 08 (mieszkalna), mierzone na `.tscn`:
   sufit (brak/jest), schody Stair* (brak/sa), drzwi ApartmentDoor14
   (brak/sa), masy kiosku KioskBlockout/TimetableStand/KioskCounter
   (sa/brak), OpenSkyWitness (jest/brak) = 6 roznic przy progu >= 4.
   Baza grywalna wspolna (podloga 640x64, sciany) — roznica rodzin w masach
   i przekroju, nie w kolizji bazowej.
5. V3-apertura — progi wylacznie z `ThresholdZone.aperture_rect`: rysunek
   czyta `var rect := aperture_rect` (jedno zrodlo rysunku i kolizji);
   Binder 06 = DOOR 54x114 bez masy drzwi (06 nie rysuje drugiej geometrii
   progu); Binder 08 = DOOR 45x109 z ApartmentDoor14, a rysowane drzwi 08
   to dokladnie 45x109.

## Weryfikacja

- Baseline: `tools/verify_docs.ps1` PASS (52 pliki) przed edycjami.
- Nowa bramka `tests/pkg_0224_cast_geometry_pin_test.gd` PASS (3x z rzedu):
  plotna 64x104, standing face-forward 84-92, seated 56-60 + nie-dubel idle,
  turn_away uziemiony + rozny od idle, wyjatki (pliki nieobecne + stacje ich
  nie wywoluja), fallback pikselowy runtime, nieidentycznosc 06/08 = 6/4,
  apertury Bindera + zgodnosc drzwi 08 + jedno zrodlo rysunku.
- Czulosc: na starym dysku FAIL (jakub seated 89 + dubel bajtow) — naprawa
  w tym samym pakiecie; fallback nazwany→pikselowy tez zlapany FAIL-em
  i poprawiony w bramce (twardy fakt D-237).
- Twardy fakt narzedziowy: po wymianie PNG bramka nadal mierzyla 89 —
  cache `.godot/imported` trzymal stara teksture; `godot --headless
  --import`, `project.godot` nietkniety (diff pusty, fakt PKG-0221
  nie powtorzyl sie).
- Pin `pkg_0207`: 118/117/116 po aktualizacji (regula D-222); 125. sekcja
  w `tools/verify.ps1`.
- Sasiedzi PASS bez obnizania progow: 0207, 0186 (jezyk Lena 4.1 + seated
  nie-shrink), 0172 (kontrakt riga), 0212 (45↔45, 3 helpery),
  0197 (sterowniki NPC), 0214 (wlasnosc Bindera), traversal_lint.
- Kadry 06/08 8 PNG s100 full/notext pre+post (Iris Xe, OpenGL,
  `reports/pkg_0224/visual/`); inspekcja HOLD — kompozycje identyczne,
  delty bajtowe to faza CRT/maszynerii (fakt PKG-0221/0222), zero napraw.
- Zakresowa `verify_scoped.ps1` PASS (docs + 8 bramek; licznik D-217:
  3. zakresowa po pelnej PKG-0221; pelna obowiazkowo najpozniej w PKG-0226).
  Blast: 1 PNG + 1 skrypt narzedzia + testy + pin + 125. sekcja + capture;
  stacje/sceny/monolity D-217, enumy, serialize, routing, progi, InputMap
  NIETKNIETE.

## Granice dowodu

Zielone bramki dowodza kontraktow mierzalnych (wymiary, obecnosci, fallback
pikseli, inwentarz), nie tego, ze siedzacy Jakub "wyglada dobrze" ani ze
gracz odroznia rodziny (D-012, ADR-003). Palety 10/13 nadal surowe hexy
(regula D-232 wiaze ich przepisanie, nie dzisiejszy wyglad). Sufit 10
near-miss 51 px nadal otwarty (osobny pakiet). Generacja brakujacych stanow
vendor/neighbour wymaga dyspozycji + pipeline CAST (kredyty/model).
