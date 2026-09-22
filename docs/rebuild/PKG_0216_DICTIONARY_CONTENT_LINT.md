# PKG-0216 — Słownik metody + lint treści + palimpsest Tak/Jadę (N1+N3+N6-część)

Data: 2026-09-12. Dyspozycja: `docs/NEXT_SESSION_PROMPT.md` po PKG-0215
(faza R2 planu PKG-0213 §8, findings N1+N3+N6-część). Decyzja D-229.
Nie jest PRODUCT GO. GATE-REL, release i nowe `.exe` pozostają BLOCKED BY D-168.

## Co zmieniono (tekst prezentowany + bramki, zero mechaniki)

1. Słownik (N1): `Utrzymanie → Zakotwiczenie` jako nazwa metody —
   - `scripts/levels/creative_scene_lines.gd:31` (`relay_logbook_named`),
   - `scripts/levels/station_14.gd:116` (beat `s14_method_named`, PL + EN
     `Holding → Anchoring and yielding`, ten sam dryf poza plikiem zlecenia,
     naprawiony w tym pakiecie zamiast zostawienia rozjazdu),
   - `docs/narrative/FULL_STORY.md:20-21`,
   - `docs/rebuild/PKG_0194_CREATIVE_SCENES_B.md:16` (raport historyczny,
     korekta jawna jedną frazą; archiwum snapshotu nie przepisuje).
   - Zachowane celowo: `Utrzymanie ruchu` w nagłówku `station_17.gd:5`
     (ekipa obiektu — inne znaczenie, nie nazwa metody). Nowa bramka
     pinuje oba fakty: zakaz frazy w kontekście metody + obecność
     znaczenia technicznego.
2. Lint treści (N3): nowa bramka `tests/pkg_0216_dictionary_content_pin_test.gd`
   pilnuje TREŚCI prezentowanej, nie pliku stacji — domyka furtkę D-211
   opisaną w PKG-0194:69-79:
   - sześć ID z `KNOWLEDGE_GATE_IDS` bez `world_recognized` serwuje fallback
     (`Najpierw muszę nazwać…`) bez przedwczesnych terminów (rówień /
     miejscowa lena / inny świat / anchor-yield, te same co `pkg_0165`);
   - dowód fail-closed: wstrzyknięty termin w liniach = FAIL
     (syntetyczna kontrola negatywna w teście).
   - Furtka D-211 nie jest trzymana na stałe: stary lint `pkg_0165` stoi
     nietknięty (PASS), nowy lint obejmuje `creative_scene_lines.gd`.
3. Palimpsest Tak/Jadę (N6-część, K7): ekran 42B pokazuje
   `Jadę nad częściowo startym Tak` we wszystkich trzech wariantach
   `household_b_full/partial/withheld` (ta sama liczba par, ten sam klucz
   `EKRAN CZYTNIKA` — bez nowego adresu, rodziny ani interakcji) oraz
   `FULL_STORY.md` §42B jako palimpsest zamiast samego `Tak`.
   Rozstrzyga sprzeczność N6 bez retconu: wczesne `Jadę` (03 / łącze)
   i późny ekran tracący adres współistnieją jako ślad utraty adresu.
4. Kontrolowana aktualizacja cudzej asercji (ten sam pakiet, nie po cichu):
   `tests/pkg_0194_creative_scene_b_test.gd:286` wymagał starego brzmienia
   (`Utrzymanie i uległość`) — wykryte jako realny FAIL sąsiada po edycji
   linii, zaktualizowane do `Zakotwiczenie i uległość` (wzór D-216/D-218:
   rozjazd naprawia ten sam pakiet).

## Weryfikacja

- Baseline: `tools/verify_docs.ps1` PASS (52 pliki) przed edycjami.
- Nowa bramka `pkg_0216` PASS (słownik 4 pliki + znaczenie techniczne,
  fallback 6 ID, fail-closed, palimpsest 3 warianty + blok 42B).
- Sąsiedzi PASS: `pkg_0165` (lint stacji nietknięty), `pkg_0194` (po jawnym
  update asercji), `pkg_0195` (finały + skale), `pkg_0168` (42B),
  `pkg_0207` (pin 110/109/108 po aktualizacji).
- Zakresowa `tools/verify_scoped.ps1` PASS (docs + 0216 + 0165 + 0194 +
  0195 + 0168 + 0207 + 0208) — exit 0. Blast: linie dialogowe + testy +
  rejestracja bramki; zero shared-touch (żaden z plików D-217 nie tknięty:
  memory_resonance_point, mrp_legacy_renderer, game_state_manager,
  procedural_audio, world_pixel_compositor, autoloady), zero enum/serialize/
  routing/progów/InputMap. Licznik D-217: 1. zakresowa po pełnej PKG-0215.
- Kadry: 18 PNG 640×360 (`reports/pkg_0216/visual/`, stacje 13/18/42b ×
  skale 85/100/115 × full/notext, normalny sterownik Windows, Iris Xe,
  OpenGL) + `frames.tsv`. Inspekcja ręczna: brak ucięć i kolizji etykiet
  z aktorami w full; warstwa diegetyczna gaśnie wprost w notext; przy
  115% kompozycja trzyma (HOLD obrazu, zero napraw). Bazą „przed" są
  archiwa 0193/0194/0195 (nie nadpisane).

## Granice dowodu

Zielone bramki dowodzą kontraktów mierzalnych (słownik, fallback,
palimpsest), nie zabawy, emocji, zrozumienia ani odbioru (D-012, ADR-003).
N3-reszta (synteza 13 trzeci głos, prognozy `brak danych`, dyferencjacja
urządzeń — N2+N5) czeka w PKG-0217. Ekstrakcja tabel MRP (krok 2) nadal
wymaga oddzielnej dyspozycji (shared-touch → pełna verify).
