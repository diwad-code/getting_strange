# CEL SESJI
# SRODOWISKO I BASELINE
# KRYTERIA AKCEPTACJI
# KONIEC PAKIETU JEST OBOWIAZKOWY
# Historia pinow: PKG-0207 PKG-0208 PKG-0209

Data: 2026-09-16
Ostatni zamkniety pakiet: **PKG-0238** (Pakiet E — Mosty dialogowe, DONE)
Ten pakiet: **PKG-0239**
Kolejka sensu (swiezy plan 2026-09-15): **A (DONE) → C (DONE) → B (DONE) → D (DONE) → E (DONE) — PLAN UKONCZONY W CALOSCI**

Plan naprawy sensu fabularnego `docs/narrative/SENS_FABULARNY_PLAN_NAPRAWY_2026-09-15.md`
(A: PKG-0234, C: PKG-0235, B: PKG-0236, D: PKG-0237, E: PKG-0238) zostal w pelni wykonany i zapinowany.
Drzewo projektu jest review-ready. Freeze D-241 ponownie obowiazuje:
nie modyfikowac kodu, scen, dialogow ani monolitow bez wyraznej dyspozycji wlasciciela.

## CEL SESJI

Jestes Lead Programmerem i Art Directorem gry Godot 4.7 „Getting Strange”.
Celem nowej sesji jest:
1. Ocena gotowosci produktu (`PRODUCT GO review`) w oparciu o zaktualizowany i spojny runtime,
   zgodnie z `docs/rebuild/ACCEPTANCE_MATRIX.md` (14 bramek produktu: 8 technicznych + 6 produktowych);
2. Lub realizacja jawnej, odrebnej dyspozycji wlasciciela projektu co do nastepnego etapu produkcyjnego.

Bez wyraznej nowej dyspozycji wlasciciela w projekcie obowiazuje **MAINTAIN FREEZE**:
- Nie ruszac kodu gry ani scen (drzewo review-ready);
- Nie modyfikowac plikow legacy 19–41;
- Zadnych prac webowych (D-098: Getting Strange to gra w Godot 4.7, nic innego);
- Nie budowac nowego `.exe` ani wydania (release BLOCKED BY D-168 do czasu formalnego PRODUCT GO i dyspozycji wlasciciela);
- Dozwolona wylacznie praca analityczna/dokumentacyjna (sciezka D docs-only) i weryfikacja.

## SRODOWISKO I BASELINE

Projekt nie ma Gita. Pliki na dysku sa jedynym stanem. Nie uruchamiaj `git`.

Przeczytaj kolejno:

1. `AGENTS.md`
2. `docs/INDEX.md`
3. `docs/CURRENT_STATE.md`
4. ten plik
5. `docs/rebuild/ACCEPTANCE_MATRIX.md` oraz `docs/rebuild/PKG_0238_DIALOGUE_BRIDGES.md`
6. `docs/narrative/SENS_FABULARNY_PLAN_NAPRAWY_2026-09-15.md` (potwierdzenie wykonania calosci planu)

Nastepnie wykonaj swiezy baseline **przed jakakolwiek praca**:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Oczekiwany baseline po PKG-0238: PASS, exit 0, 136 sekcji;
pin PKG-0207: 129 wywolan / 128 skryptow / 127 testow na dysku / 127 referencji.
Wszelki rozjazd z handoffem wymaga odnotowania w `docs/SESSION_LOG.md` zanim cokolwiek zrobisz.

## KRYTERIA AKCEPTACJI

1. Baseline weryfikacyjny: `tools/verify.ps1` wykonuje sie ze statusem PASS i exit code 0 na 136 sekcjach.
2. Spis bramek i fundamenty (`tests/pkg_0207_gate_census_test.gd`): 129 invokes / 128 scripts / 127 test refs / 127 disk tests nienaruszone.
3. Stan review-ready: zachowane piny wszystkich zrealizowanych pakietow sensu fabularnego:
   - PKG-0234 (Pakiet A / duchy geometrii usuniete z trasy);
   - PKG-0235 (Pakiet C / luki na czasownikach P9);
   - PKG-0236 (Pakiet B / ciecia nie teleporty, HATCH 13, mysl 10 wyjscie do UCP);
   - PKG-0237 (Pakiet D / zarobione slowa: Rownia w 17, Wierzbicka 11/17, analizator 16, 42B prog, JAKUB ECHO w 42C, epilog 43 bez kradziezy tonu C);
   - PKG-0238 (Pakiet E / ciaglosc wejsc/wyjsc 09–18, 3 sekundy implicit, fallback 42A/B/C, CRT <= 115 znakow).
4. Wszystkie nadrzedne piny techniczne stoja: 0107, 0194, 0195, 0216, 0217, 0226, 0233.
5. Kazda zmiana dokumentacyjna spelnia `tools/verify_docs.ps1`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Kazdy pakiet konczy sie pelnym zestawem krokow:

1. Weryfikacja: `pwsh -NoProfile -File .\tools\verify.ps1` — status PASS, exit 0.
2. Weryfikacja dokumentacji: `pwsh -NoProfile -File .\tools\verify_docs.ps1` — status PASS.
3. Aktualizacja dokumentacji:
   - `docs/DECISION_LOG.md` (nowa decyzja lub potwierdzenie);
   - `docs/INDEX.md` (status kolejki i nowe raporty);
   - `docs/CURRENT_STATE.md` (aktualizacja stanu i wynik pakietu);
   - `docs/SESSION_LOG.md` (nowy wpis append-only ze wszystkimi sekcjami);
   - `docs/NEXT_SESSION_PROMPT.md` (samodzielny prompt dla nastepcy z obowiazkowymi 5 liniami ASCII).
4. Zamrozenie: `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-NNNN`.
