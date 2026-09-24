# AKTUALNY HANDOFF — PKG-0242 / 2026-09-24

Pracuj na galezi `claude/vigilant-brahmagupta-eq594t` (albo na jej PR, jesli wlasciciel go otworzy).
Najpierw odczytaj HEAD i diff wobec `ea61916`, potem `docs/audits/PKG_0242_REPORT.md`,
`docs/CURRENT_STATE.md` (blok PKG-0242) i decyzje D-252..D-254.
Nie powtarzaj R1/R2: stare bramki sa przepiete (tabela §4 raportu), 129/129 PASS w izolacji.

CEL SESJI (mega-pakiet, nie mikrozadania):
1. Profil Windows wlasciciela: `pwsh -NoProfile -File .\tools\verify.ps1` (WASAPI) i porownanie
   z wynikiem Linux/Dummy z SESSION_LOG PKG-0242; kazda roznica = reprodukcja i przyczyna.
2. R3 ciaglosc grafiki (kostium Leny, detale winiet, Lena zaslonieta skrzydlem drzwi — R-061),
   z kadrami `tools/capture_pkg_0241.gd` i `tools/capture_pkg_0242.gd` przed/po.
3. R4 sprzet: fizyczny pad, audio, DPI, pomiar klatki na docelowym PC (R-060).
4. Decyzje wlasciciela do przygotowania (nie podejmowac za niego): tlumaczenie dialogow EN
   (R-058), porzadki repo `.godot/`, `reports/`, binaria 4.6.3 (R-059), PRODUCT GO.

SRODOWISKO I BASELINE: Godot 4.7.x, 640x360, fizyka 60 Hz, semantyczny InputMap.
Baseline: `tools/verify.ps1` — 131 wywolan / 130 skryptow / 129 testow; helpery 0212: 4.
Linux: `pwsh -NoProfile -File tools/verify.ps1 -AudioDriver Dummy` (Dummy nie certyfikuje dzwieku).
Seed stanu dla bramek po 16: `tests/support/campaign_chain.gd` — nie pisz recznych faktow zgody.

KRYTERIA AKCEPTACJI: `pkg_0242` i `pkg_0241` zielone; M1 `pkg_0177` przechodzi A, B i C wejsciem;
zadna asercja nie znika bez kontraktu o tym samym celu (D-252); tresc PKG-0239 nietknieta bez
dyspozycji wlasciciela; zero nowych przeszkod zrecznosciowych (D-099); zero prac webowych (D-098).

KONIEC PAKIETU JEST OBOWIAZKOWY: testy i dowody, CURRENT_STATE, SESSION_LOG, NEXT_SESSION_PROMPT,
DECISION_LOG/RISKS przy zmianie, snapshot `tools/snapshot.ps1 -Package PKG-NNNN`, commit i push
na galaz sesji. Bez PRODUCT GO, eksportu i `.exe` (D-168) bez jawnej dyspozycji wlasciciela.

---
Nizej zachowany poprzedni handoff PKG-0241 (historia).

# HANDOFF PKG-0241 / 2026-09-22 (historia)

Pracuj na `fix/art-ux-audit-0241`, najpierw odczytaj jej aktualny HEAD i diff wobec main.
Przeczytaj `docs/audits/PKG_0241_REPORT.md` i `PKG_0241_IMPLEMENTATION_PLAN.md`.
Nie powtarzaj odzyskiwania vendor ani poprzedniej galezi przygotowawczej 0240.
W1–W4 sa wdrozone; nowa bramka 51/51, Linux 83/128 (baza 61/127), brak nowego FAIL
wsrod wspolnych testow. To nie jest zielona bramka calej gry. Szczegolowy wynik Windows jest w raporcie.

CEL SESJI: wykonaj R1/R2 z planu. Na izolowanym zapisie odtworz pierwszy blad smoke:
zakres zgody w 17, prognozy i metoda w 18, wykonanie A/B/C oraz 43. Zapisz decyzje i interakcje
przed/po. Rozstrzygnij blad wykonania kontra test sprzed PKG-0239. Nie dawaj zgody automatycznie,
nie usuwaj odmowy ani nie oslabiaj testow. Osobno rozlicz brak archiwalnych reports/export_presets
w lokalnym pakiecie oraz historyczny test wymagajacy braku Git — wlasciciel zlecil prace na GitHubie.

KRYTERIA AKCEPTACJI: nowy test 0241 pozostaje zielony; stare bledy maja reprodukcje i uzasadnione
naprawy; pelna weryfikacja Windows jest jawna, nie zastapiona kodem 0 bez kontroli logu.
Przed wydaniem wymagany rzeczywisty pad/audio/DPI i pomiar klatki. Zachowaj 640x360, 60 Hz,
kanon fabuly, Zakotwiczenie i brak nowych przeszkod zrecznosciowych.
KONIEC PAKIETU: testy, dowody, aktualny handoff i osobny PR. Bez automatycznego PRODUCT GO/release.

---
Nizej zachowana historia poprzedniego promptu. Biezaca kolejka powyzej ma pierwszenstwo.

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
