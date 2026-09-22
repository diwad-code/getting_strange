# Prompt następnej sesji

Aktualny pakiet: `N0.2-E: Remediacja zastosowań mechaniki sygnaturowej`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi.

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange jako head writer,
script editor i redaktor ciągłości, w pełnej roli właścicielskiej (D-018).
Decyzje kanonu, struktury i redakcji podejmujesz samodzielnie i od razu.
Poza rolą są wyłącznie: przegląd prawny, zobowiązania budżetowe i konsultacja
ekspercka przy treściach klinicznych.

CEL SESJI
Zremediuj kontrakt mechaniki sygnaturowej po wyniku H-002a `REFUTED`. Obecny
audyt policzył 5 odrębnych przestrzeni z jawnym zastosowaniem Zakotwiczenia lub
Uległości: 14, 20, 22, 33 i 41. Próg bramki wynosi 12. Pracuj w tych samych
43 przestrzeniach i doprowadź tekst do co najmniej 12 odrębnych zastosowań albo
zapisz, na podstawie konkretnego konfliktu, decyzję `STOP/PIVOT` o zmianie
kontraktu. Nie obniżaj progu po cichu.

Każde nowe zastosowanie musi mieć w tekście: konkretną czynność gracza lub
postaci, obserwowalny skutek albo koszt oraz funkcję mechaniczną odrębną od
już policzonych. Sama wzmianka tematyczna, rekwizyt, flaga relacyjna, sieć
świadków, ekspozycja albo wypłata wcześniejszej decyzji nie liczą się. Nie
udawaj, że opis sceny jest dowodem działania mechaniki w runtime.

Nie prowadzisz czytania stolikowego ani playtestu. One się nie odbędą (D-012,
ADR-003) i ich symulacja jest zakazana. Nie oznaczasz żadnej hipotezy jako
`SUPPORTED`.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOŚCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\WORKFLOW.md
5. C:\getting_strange\docs\decisions\ADR-003-evidence-model-without-external-testers.md
6. C:\getting_strange\docs\RISKS_AND_HYPOTHESES.md
7. C:\getting_strange\docs\DECISION_LOG.md
8. C:\getting_strange\docs\ROADMAP.md
9. C:\getting_strange\docs\narrative\NARRATIVE_BIBLE.md
10. C:\getting_strange\docs\narrative\FULL_STORY.md
11. C:\getting_strange\docs\narrative\MECHANICS_AUDIT_H-002A.md
12. C:\getting_strange\docs\narrative\CONTINUITY_TRACKER.md
13. C:\getting_strange\docs\narrative\DIALOGUE_SCRIPT.md
14. C:\getting_strange\VISUAL_DESIGN.md
15. C:\getting_strange\docs\SESSION_LOG.md

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Projekt NIE jest wersjonowany (D-016). Nie ma repozytorium, gałęzi, commita
  ani historii. Nie uruchamiaj `git` i nie inicjalizuj repozytorium.
- Ostatni zamknięty pakiet to `PKG-0009` z 2026-08-15. Kronika znajduje się w
  `C:\getting_strange\docs\SESSION_LOG.md`.
- H-002a jest `REFUTED` po pomiarze 5/43. D-024 blokuje Prototype 02 do
  remediacji albo jawnej decyzji STOP/PIVOT.
- Oczekiwany wynik świeżej bramki:
  `DOCS PASS: 26 required files and handoff contracts`,
  `SMOKE PASS: project, scene, input and player physics`,
  `Verification passed.`

Przed edycją pokaż i oceń pełny, nieprzefiltrowany wynik:
  pwsh -NoProfile -File .\tools\verify.ps1

Nie czytaj snapshotów jako aktualnego stanu i nie edytuj ich. Przed pracą
przeczytaj cały plik, który ma być zmieniony; zapisuj każdą skończoną zmianę
natychmiast. Na końcu wykonaj:
  pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0010

POTWIERDZONE PO PKG-0009
- Historia ma 43 przestrzenie fizyczne w pięciu aktach; `42A`, `42B` i `42C`
  są wariantami jednej przestrzeni finałowej.
- H-002a zmierzono metodą z raportu `MECHANICS_AUDIT_H-002A.md`: policzono
  sceny 14, 20, 22, 33 i 41. Sceny 21 i 37 są wypłatami, a 13, 16, 30 i 38
  nie są odrębnymi użyciami A/U.
- `anchor_detail` ma pierwsze jawne użycia w 14 i 20, a 37 jest wypłatą;
  `ring_disposition` w 06 i 16 nie jest jeszcze Uległością; scena 22 jest
  pierwszym przyjęciem lokalnej reguły; `public_witness_network` pozostaje
  osobnym kontraktem świadków.
- Finaly A, B i C są dostępne zawsze. Koszt C ponosi Ślad. Wynik H-011a to
  `MEASURED: 0` sygnałów przewagi strukturalnej po PKG-0008.
- Nie zmieniaj liczby przestrzeni, rodzin finału, kosztu Śladu, D-015, D-019,
  D-020, D-021, D-022, D-023 ani wyniku H-011a.

ZADANIE: REMEDIACJA H-002a
1. Przejdź ponownie przez raport i `FULL_STORY.md`. Wybierz istniejące sceny,
   w których można jawnie doprecyzować działanie Zakotwiczenia/Uległości bez
   wprowadzania nowej mechaniki i bez zmiany liczby przestrzeni.
2. Zapisz minimalne, spójne redakcje w źródłowych dokumentach scen. Zachowaj
   gałęzie, flagi, rekwizyty, chronologię, koszty i relacje. Jeśli potrzebujesz
   tekstu dialogowego, zsynchronizuj `DIALOGUE_SCRIPT.md`; jeśli zmieniasz
   warunek lub wypłatę, zsynchronizuj `CONTINUITY_TRACKER.md`.
3. Powtórz audyt wszystkich 43 przestrzeni tą samą metodą. Raport musi nadal
   zawierać pełną tabelę, klasyfikację każdej sceny, liczbę i granice pomiaru.
4. Jeśli tekst uczciwie nie może osiągnąć 12 bez dodania nowej mechaniki,
   zatrzymaj remediację, pozostaw `REFUTED` i zapisz jawny STOP/PIVOT zamiast
   dopisywać pozorne zastosowania.

POZA ZAKRESEM
- runtime, Godot, Prototype 02 i implementacja Zakotwiczenia/Uległości;
- zmiana liczby 43 przestrzeni lub ponowne przenumerowanie;
- zmiana rodzin finału, kosztu Śladu, D-015, D-019, D-020, D-021, D-022,
  D-023 lub wyniku H-011a;
- concept art, sprite'y, audio, voice-over, lokalizacja i budżet produkcyjny;
- implementacja D-014 w `tools/verify.ps1`;
- research pamięci, żałoby, Severance i Control;
- czytelnicy, testerzy, dane odbioru i status `SUPPORTED`.

KRYTERIA AKCEPTACJI
- każda z 43 przestrzeni ma jawną klasyfikację liczaca/nieliczaca; warianty
  42A–42C są opisane osobno w ramach jednego wiersza przestrzeni 42;
- każde policzone zastosowanie ma czynność, skutek/koszt i uzasadnienie
  odrębności możliwe do odtworzenia z tekstu;
- wynik H-002a jest zapisany jako `MEASURED` tylko wtedy, gdy próg został
  osiągnięty; w przeciwnym razie pozostaje `REFUTED`, nigdy `SUPPORTED`;
- `CONTINUITY_TRACKER.md`, `DIALOGUE_SCRIPT.md` i raport nie odwołują się do
  nieistniejącej sceny i są zgodne z `FULL_STORY.md`;
- pełna weryfikacja przechodzi;
- `CURRENT_STATE.md`, `ROADMAP.md`, `RISKS_AND_HYPOTHESES.md`,
  `DECISION_LOG.md`, `SESSION_LOG.md` i ten prompt opisują stan faktyczny;
- wykonano snapshot `PKG-0010`.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom pełną weryfikację, zapisz faktyczny wynik w dokumentacji, dopisz wpis
PKG-0010 do `docs/SESSION_LOG.md`, zastąp ten prompt promptem wynikającym ze
stanu i wykonaj snapshot `PKG-0010`.

Raportuj fakty, zmienione sceny, metodę, nową liczbę zastosowań, status H-002a,
wynik bramki, ograniczenia oraz gotowy punkt przejęcia. Nie deklaruj, że
mechanika jest interesująca, zrozumiała albo grywalna — ten pakiet tego nie
mierzy.
```
