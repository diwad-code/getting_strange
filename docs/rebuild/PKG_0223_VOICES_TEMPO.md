# PKG-0223 — Glosy i tempo (N4+N7-reszta+N9+N10+N8/K4, faza R6)

Data: 2026-09-13. Dyspozycja: `docs/NEXT_SESSION_PROMPT.md` po PKG-0222
(faza R6 planu PKG-0213 §8, findings N4/N7/N9/N10 + N8 margines K4). Decyzja D-236.
Nie jest PRODUCT GO. GATE-REL, release i nowe `.exe` pozostaja BLOCKED BY D-168.

## Co zmieniono (linie + stacje lokalne 15/17 — zero monolitow D-217)

1. Tempo N4 — `loop_logbook` 15 z 4 par do 2 (tekst), reszta w obraz/dzialanie:
   - Para 1 (DZIENNIK PETLI): kontakt przy pierwszym odczycie + kotwica 20:40.
   - Para 2 (Lena): powtorka z pelna probka + wyjscie na czas sam czytnik +
     przyczyna z zewnatrz (bez niejasnego `ja` — to tez N10).
   - Pokaz w obrazie: dwa tiki na dzienniku w `_draw_station_props` (kontakt
     i powtorka, wylacznie po `is_log_reconstructed`; domyslna ramka
     nietknieta) + istniejace cewki-bliźniaki. Lancuch MRP 15
     (log/kontrole/uzbrojenie/korekta/notatka) NIETKNIETY — pinuje go 0194.
2. Glosy N7-reszta — audyt calej trasy zakresu: urzadzenia poza prognozami 18
   juz rozroznialne trescia (REJESTR numery/daty 186/20:40/warsztat, ANALIZATOR
   wykres os/pik, NOTATKA odreczny margines — pin 0217 stoi); Wierzbicka
   bezosobowa wszedzie w zakresie (3 wpisy w liniach + audit read-only
   station_40: zero fraz recepcyjnych, negocjacje na adresie/ryzyku).
   Bramka 0223 pinuje ten stan (slepy test listy bez etykiet).
3. Tempo N9 — 09 scalone wokol fotografii: haczyk `two_lives` wskazuje wprost
   zdjecie na komodzie (hub tryptyku two_lives -> photo -> boundary, lancuch
   kolejnosci w station_09 nietkniety; budzet M5 ≤3 nietkniety). 17 odciazone:
   oferta jako projekcja-gest w przestrzeni (cienka linia terminal -> biurko
   zgody 370 -> 424, dopoki wisi; po odrzuceniu znika, zostaje przekreslenie);
   4 pary tekstu nietkniete (pin 0217).
4. Polszczyzna N10 — 4 potkniecia naprawione (grep 0 w LINES):
   - niejasne `ja` (gd:35) -> `Próbe` (kontrolowana aktualizacja asercji 0194);
   - sensacyjne `ona go zabila` -> `powiazany koszt` (marker `Ktos utrzymuje
     zapis` nietkniety, pin 0194);
   - mantra `Moja prosba, moj ruch` x3 -> 3 warianty czynnosci (slupek / klucz
     / most; markery `Oddaje jej miejsce` i `Otwieram, nie zabieram`
     nietkniete; kontrolowana aktualizacja asercji 0194);
   - golny kryptonim `Para 04/17` -> rejestr z obrazem (`dwa konce pary ...
     Wpisane jedna reka`; `04/17` nietkniete, pin 0217).
   `Utrzymanie` (D-229) nieruszone.
5. Margines N8/K4 — dopisek olowkiem miejscowej Leny na wydruku 15: beat L1
   `s15_local_margin` (obserwacja faktu, zero hipotezy, bez monologu-ducha) +
   olowkowy slad w `_draw` (3 kreski na marginesie dziennika, stara warstwa,
   zawsze widoczna).

## Weryfikacja

- Baseline: `tools/verify_docs.ps1` PASS (52 pliki) przed edycjami.
- Nowa bramka `tests/pkg_0223_voices_tempo_pin_test.gd` PASS (3x z rzedu):
  loop 2 pary + fit CRT, rejestr z obrazem, 3 konkrety + grep-0 mantry,
  urzadzenia-reszta, Wierzbicka bezosobowa (linie + audit 40), hub 09,
  beat K4 + tiki + projekcja, M5 09/15/17 ≤3 MRP, fail-closed.
- Czulosc: bramka asercjonuje NOWE brzmienia — na starym kodzie FAIL
  (rozmiar loop_logbook, mantra, `Para 04/17`).
- Kontrolowana aktualizacja `pkg_0194` (wzor D-216/D-218, wykryta realnym
  FAIL-em w tym samym pakiecie): `Ktos przerwal ja z zewnatrz` ->
  `Probe ktos przerwal z zewnatrz`; `Moja prosba, moj ruch` ->
  `Staje przy slupku sama` (required + ordered). Po updacie 0194 PASS.
- Pin `pkg_0207`: 117/116/115 po aktualizacji (regula D-222); 124. sekcja
  w `tools/verify.ps1`.
- Sasiedzi PASS bez obnizania progow: 0193 (tekst 09), 0217 (rejestry),
  0216, 0120/0163/0147 (lancuch 15), 0195, 0114, 0215, traversal_lint.
- Kadry 15/17/18 6 PNG s100 full/notext + klatka logu 15 (tiki) +
  klatka rejected 17 (projekcja zgasla, X) (`reports/pkg_0223/visual/`,
  Iris Xe, OpenGL); inspekcja HOLD — kompozycje w duchu archiwow,
  projekcja czytelna w rejected-porownaniu, zero napraw.
- Zakresowa `verify_scoped.ps1` PASS (docs + 13 bramek; licznik D-217:
  2. zakresowa po pelnej PKG-0221). Blast: plik linii + 2 skrypty stacji
  lokalnych + testy + pin + 124. sekcja; monolity D-217 (MRP/GSM/audio/
  kompozytor/autoloady), enum, serialize, routing, progi, InputMap
  NIETKNIETE. Pułapka tablicy `@(...)` przez `pwsh -File` ponownie
  potwierdzona — zakresowa poszla runnerem w temp z operatorem `&`.

## Granice dowodu

Zielone bramki dowodza kontraktow mierzalnych (dlugosci, markery, grep-0,
obecnosc nosnikow obrazu, budzety), nie czytelnosci tempa ani
rozroznialnosci glosow przez gracza (D-012, ADR-003). Slepy audytor w bramce
to test listy bez etykiet, nie czlowiek. Stacje legacy poza 09/15/17
nieprzepisywane (audit 40 read-only). Checkpoint przed proba (§5.1 nawias)
nadal otwarty (poza kryteriami, fakt PKG-0222).
