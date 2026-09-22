# PKG-0218 — Fartuch + paleta + linie 09 (V1+V2+V5, faza R3)

Data: 2026-09-12. Dyspozycja: `docs/NEXT_SESSION_PROMPT.md` po PKG-0217
(faza R3 planu PKG-0213 S8, findings V1+V2+V5). Decyzja D-231.
Nie jest PRODUCT GO. GATE-REL, release i nowe `.exe` pozostaja BLOCKED BY D-168.

## Co zmieniono (obraz scen lokalnych + stala stylu, zero mechaniki)

1. Fartuch (V1): audyt wszystkich custom `_draw()` trasy 01-18 + finalow
   42a/b/c + epilogu 43 wykazal 11 scen bez `draw_stage_apron()` (09, 13, 14,
   15, 16, 17, 18, 42a, 42b, 42c, 43) — prompt Sesji zakladal tylko 09, dysk
   pokazal wiecej; rozjazd naprawia ten sam pakiet. Dopisano wywolanie jako
   pierwsza linie malowania w kazdej z 11 scen (wzor `01.gd:466`; w scenach
   delegujacych `_draw() -> _draw_state_layer()` fartuch stoi przed delegacja,
   wiec kompozycje maluja nad nim bez zmian, zgodnie z D-136). Scenografia:
   zero colliderow, zero logiki, zero trawersalu. Stan po: 22/22 scen
   01-18/42/43 z fartuchem (pinowane bramka).
2. Paleta (V2): `_draw()` 09 przepisany w calosci na `VectorStageStyle` —
   zero literalnych `Color("...")` (bylo ~36 unikalnych hexow: mauve, braz,
   szarosci ad-hoc). Uklad 1:1 zachowany (niski sufit, listwa, rail, 2 szwy,
   podloga + 3 deski, dywan, sofa + 2 rozne poduszki + narzuta, stol dwoch
   osob + 2 nakrycia, drzwi 109 px, kredens + fotografia + garnek + roslina,
   okno + krzyz + 2 zaslony + parapet, regalik + 2 polki + ksiazki, lampa +
   spill, cien 0.48). Bazy: INK / DEEP / MID / LIGHT + AMBER + CYAN (6) plus
   pochodne shade() — cieplo mieszkalne niosa akcenty bursztynu i praktyczne
   plamy swiatla, jak w 08. Decyzja D-231: `MAX_PALETTE_COLORS` 7 -> 8
   (kanon VISUAL_DESIGN S4: 8-16; 7 lamalo dolna granice; najciasniejsza
   wartosc zgodna). `STAGE_APRON` 40 i offset dialogowy 36 nietkniete.
3. Linie (V5): wszystkie stroke 1.0 w 09 podniesione do 2.0 logicznego
   (2 szwy scian, 3 deski podlogi; przy kompozytorze 320x180 nearest 1.0 to
   0.5 px finalnego — lamie PIXEL_ARCH S5). Reszta rysunku juz >= 2.0
   (nogi 3.0, stolik 4.0). Sasiedzi zaudytowani read-only: 08 x1.0=1 (detal
   skrzynek, 40 px, nie konstrukcja), 10 x1.0=4 (w tym pelnoszerokosciowa
   krawedz sufitu — konstrukcja, ale to terytorium V4/sufit, planowo
   PKG-0219), 13 x1.0=0. Bramka pinuje twardo 09 (przepisana scena), nie
   preemptuje PKG-0219.

## Weryfikacja

- Baseline: `tools/verify_docs.ps1` PASS (52 pliki) przed edycjami.
- Nowa bramka `tests/pkg_0218_apron_palette_line_pin_test.gd` PASS (fartuch
  22/22 + kolejnosc fartuch-przed-play-plane w 09; 09 zero hex + bazy <= 16
  + brak akcentu oxide bez kosztu; 09 zero stroke 1.0 (liczone tylko
  stroke draw_*, nigdy clampf/Vector2 — wniosek z pierwszego FAIL-a wlasnej
  bramki); audyt 08/10/13; dowody fail-closed). Wlasna bramka raz FAIL
  (naiwny licznik `, 1.0)` lapal logike clampf w 13) — naprawiona precyzyjnym
  licznikiem w tym samym pakiecie, potem PASS.
- Pin `pkg_0207`: 112/111/110 po aktualizacji (regula D-222); 119. sekcja
  w `tools/verify.ps1`. Sasiad `pkg_0137` (kontrakt fartuch-budzet D-136)
  PASS bez dotykania; `pkg_0217/0216/0165/0193/0194/0195/0168/0208` PASS.
- Zakresowa `tools/verify_scoped.ps1` PASS (docs + smoke 01-43 + 11 bramek;
  exit 0). Blast: 11 skryptow stacji (lokalne) + stala stylu + testy +
  rejestracja bramki; zero shared-touch (zaden z plikow D-217 nie tkniety:
  memory_resonance_point, mrp_legacy_renderer, game_state_manager,
  procedural_audio, world_pixel_compositor, autoloady), zero enum/serialize/
  routing/progow/InputMap, zero nowych adresow/rodzin/interakcji/faktow/
  postaci. Liczby D-221 nietkniete. Licznik D-217: 3. zakresowa po pelnej
  PKG-0215 (limit: pelna najpozniej w PKG-0220).
- Kadry: 13 PNG 640x360 (`reports/pkg_0218/visual/`, normalny sterownik
  Windows, Iris Xe, OpenGL) + `frames.tsv`: 09 x skale 85/100/115 x
  full/notext/mono (9) + spot 13/18 s100 full/notext (4). Inspekcja reczna:
  uklad 09 1:1 z archiwum 0198 (sufit, rail, szwy, podloga, dywan, sofa,
  stol + 2 nakrycia, drzwi, kredens, okno, regal, lampa, cien); etykieta
  diegetyczna bez kolizji w full; warstwa gasnie wprost w notext; skale
  trzymaja kompozycje; mono czytelne ksztaltem (bursztyn ~0.66 i cyjan
  ~0.68 maja bliska lume — rozroznienie niosa ksztalt i pozycja, nie barwa;
  odnotowane jako wklad do decyzji V10 w PKG-0219). Spots 13/18 HOLD
  (fartuch maluje 360..400, poza standardowym kadrem — dowod braku regresji,
  nie nowej farby). HOLD obrazu, zero napraw. Baza "przed" to archiwa
  0187/0198/0203 (nie nadpisane).

## Granice dowodu

Zielone bramki dowodza kontraktow mierzalnych (fartuch 22/22, zero hexow
w 09, MAX 8, zero 1.0 w 09), nie zabawy, emocji, zrozumienia ani odbioru
(D-012, ADR-003). Sciemnienie 09 (mauve -> DEEP) to zamierzona unifikacja
V2, nie defekt — dowod slusznosci estetycznej nie istnieje. Pomiar dolnych
40 wierszy w dialogu (wzór PKG-0137) nie zostal powtorzony pikselowo:
polowe mechanizmu (budzet kamery) pinuje nietkniety `pkg_0137`, polowe
farby (wywolanie + kolejnosc) pinuje nowa bramka; pelny harness
dialog-framing pozostaje do odtworzenia przy recertyfikacji. Ekstrakcja
tabel MRP (krok 2) nadal wymaga oddzielnej dyspozycji (shared-touch ->
pelna verify).
