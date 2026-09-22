# NEXT_SESSION_PROMPT — PKG-0185 (owner-gated)

> PKG-0184 / BUNDLE-34 jest zamknięty. Sekwencyjna recertyfikacja
> PKG-0182 → PKG-0183 → PKG-0184 skończyła się trzema osiami PASS.
> Ten plik jest aktywnym handoffem. **Nie jest poleceniem wydania.**
> Nie nadpisuj `reports/pkg_0182/`, `reports/pkg_0183/`, `reports/pkg_0184/`.

## CEL SESJI

Czekać na jawną dyspozycję właściciela. Domyślnie nic nie wydawać.

Dozwolone tylko jeśli właściciel to nazwie:

1. **Release execution (GATE-REL)** — wyłącznie po zdaniu „zdejmij D-168 i
   zbuduj `.exe`”. Bez tego zdania eksport jest zakazany.
2. **P3 backlog** — monolit `memory_resonance_point.gd`; przepisanie gameplayu
   Station 10–13 do `CAMPAIGN_MAP.md`; rejestracja albo usunięcie CSV locale;
   zdjęcie `clampf(raw)` z generatorów; migracja albo wycofanie `pkg_0091` /
   `pkg_0094`.

Nie wolno traktować TECHNICAL PASS ani CHECKPOINT-06 GO jako zgody na
dystrybucję. HUMAN RECEPTION pozostaje `OPEN — NO EXTERNAL PLAYER EVIDENCE`.

Getting Strange jest wyłącznie grą Godot 4.7.x. Web, PWA, Git i nowe `.exe`
bez dyspozycji są poza zakresem.

## SRODOWISKO I BASELINE

- Katalog: `C:\getting_strange`
- Silnik: Godot 4.7.2.stable.official.ed1daf0bf; viewport 640×360; 60 Hz
- Ostatni zamknięty pakiet: **PKG-0184 / BUNDLE-34** (2026-09-04)
- Raport: `docs/rebuild/PKG_0184_FINAL_CERTIFICATION_REPORT.md`
- Dowody: `reports/pkg_0184/`
- Snapshot: `snapshots/PKG-0184-2026-09-04/` (zamrożenie, nie workspace)

Przed pierwszą edycją:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Porównaj wynik z `reports/pkg_0184/final.log`. Jeśli baseline jest czerwony,
nie obniżaj bramki.

## KRYTERIA AKCEPTACJI

- D-168 obowiązuje, dopóki właściciel go nie zdejmie.
- Żadnego nowego `.exe`, webu ani repozytorium Git.
- P0/P1/P2 z PKG-0184 pozostają zamknięte; nowy P0/P1/P2 naprawiać w tym
  samym pakiecie.
- P3 tylko gdy właściciel wybierze backlog albo gdy bezpieczna zmiana nie
  rusza monolitów dawcy.
- Dokumentacja, `SESSION_LOG.md`, `CURRENT_STATE.md` i ten prompt muszą
  zgadzać się z dyskiem.
- Snapshot `tools/snapshot.ps1 -Package PKG-0185` na końcu, jeśli pakiet
  w ogóle wystartuje.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Jeśli sesja tylko odczyta stan i nie zmieni plików: zapisz to w
`SESSION_LOG.md` jako odczyt, nie numeruj fałszywego PKG i nie rób
snapshotu „na wszelki wypadek”.

Jeśli sesja zmieni kod albo kanon: testy, `verify_docs.ps1`, `verify.ps1`,
analiza surowego logu, aktualizacja stanu, logu, promptu i snapshot.

## Obowiązkowa kolejność czytania

1. `AGENTS.md`
2. `docs/INDEX.md`
3. `docs/CURRENT_STATE.md`
4. ten dokument
5. `docs/rebuild/PKG_0184_FINAL_CERTIFICATION_REPORT.md`
6. `docs/rebuild/PLAYER_CONTRACT.md`, `CAMPAIGN_MAP.md`, `ACCEPTANCE_MATRIX.md`
7. `docs/WORKFLOW.md`

Nie czytaj snapshotów jako bieżącej prawdy.
