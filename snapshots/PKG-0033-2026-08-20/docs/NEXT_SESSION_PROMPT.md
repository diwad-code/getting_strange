# Prompt nastepnej sesji

Aktualny pakiet: `PKG-0034: P3 Vertical Slice — Rozmowa przy stole (Przestrzeń 16 / Powrót do mieszkania 14, pęknięta filiżanka Marty, katalogowanie dowodów i wybór z obrączką)`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025, D-026, ADR-004 oraz ADR-005 przejąłeś pełną odpowiedzialność za projekt.
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.

CEL SESJI
Kontynuacja Aktu II fabuły (Korekta) i implementacja Przestrzeni 16 z FULL_STORY.md oraz sceny dialogowej D-05 z DIALOGUE_SCRIPT.md (Rozmowa przy stole / Mieszkanie 14 nocą, pęknięta filiżanka Marty, katalogowanie dowodów i kluczowy wybór z obrączką):
1. Implementacja Przestrzeni 16 w scenes/levels/station_16.tscn i scripts/levels/station_16.gd:
   - Przestrzeń / kompozycja: kuchnia i pokój dzienny mieszkania 14 w nocnym, zmienionym oświetleniu (stół kuchenny z ceratą pod ciepłym kloszem lampy bursztynowej, parująca herbata, rozłożone notatki i fotografie, widok na nocne Osiedle Tarasowe za oknem).
   - Rekwizyty i punkty rezonansu pamięci w MemoryResonancePoint (PropType 67..71):
     - `CRACKED_TEA_CUP`: pęknięta filiżanka ceramiczna Marty ze śladem klejenia i parującym naparem,
     - `CORRELATION_DOSSIER`: rozłożona na stole teczka z dowodami i schematami korelacyjnymi (katalogowanie poszlak R-01..R-06),
     - `KITCHEN_CLOCK`: mechaniczny zegar ścienny z nieregularnym, asynchronicznym taktem sekundnika,
     - `WEDDING_RING_STAND`: talerzyk ze złotą obrączką zebraną w autobusie (wybór Leny: decyzja o przyjęciu statusu żony w nowym świecie vs zachowanie tożsamości pierwotnej),
     - `BALCONY_EXIT_DOOR`: przeszklone drzwi balkonowe prowadzące ku gzymsom i przestrzeni tranzytowej (Przestrzeń 17: Ucieczka po gzymsie).
   - Kluczowa scena dialogowa D-05 per DIALOGUE_SCRIPT.md:
     - Konfrontacja Leny i Marty Kurek przy kuchennym stole na temat natury UCP, kosztu Zakotwiczenia, zniknięcia lokalnej Leny i losu Jakuba.
     - Interaktywny wybór narracyjny powiązany z obrączką ślubną wpływa na stan `is_ring_worn` i dialog końcowy sceny.
2. Wdrożenie procedur syntezy dźwięku w ProceduralAudio:
   - `create_ceramic_cup_clink_sound()`: perkusyjny stukot ceramicznej filiżanki o spodek (1450/2900 Hz z rezonansem porcelany);
   - `create_tea_pour_steam_sound()`: delikatny szum nalewania wrzątku i unoszącej się pary (350..1600 Hz z bąbelkowaniem);
   - `create_kitchen_clock_tick_sound()`: mechaniczny dwuton wychwytu zegara ściennego (820/640 Hz z drewnianą obudową);
   - `create_dossier_paper_turn_sound()`: szelest przekładanych kart dokumentacji i tektury (700..3400 Hz tarcie celulozy).
3. Rozbudowa tests/smoke_test.gd oraz tools/capture_preview.gd o scenę Station 16 (`reports/station_16.png`, `reports/station_16_choice.png`).
4. Weryfikacja automatyczna i wizualna oraz zamrożenie snapshotu PKG-0034.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\ROADMAP.md
5. C:\getting_strange\docs\WORKFLOW.md
6. C:\getting_strange\docs\narrative\FULL_STORY.md (Scena 16: Rozmowa przy stole)
7. C:\getting_strange\docs\narrative\DIALOGUE_SCRIPT.md (Scena D-05: Konfrontacja z Martą Kurek)
8. C:\getting_strange\docs\narrative\CONTINUITY_TRACKER.md (Wybór obrączki i bilans poszlak R-01..R-06)
9. C:\getting_strange\VISUAL_DESIGN.md (Sekcja 6.3 i 7: Oświetlenie domowe, przedmioty podwójnego zastosowania)

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (`tools/snapshot.ps1`).
- Ostatni pakiet: PKG-0033 (Station 15 Korytarz serwisowy: infrastruktura UCP, instrukcje higieny, pismo lokalnej Leny z otwartą cyfrą 4, odwrócone odbicie w kałuży, upust ciśnienia i brama tranzytowa).
- Jesteś w pełni samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.
- Zachowaj konwencje nazewnictwa i folderów (`scripts/`, `scenes/`, `resources/`).

STAN BASELINE (PKG-0033):
- Faza P3 w toku: Przestrzenie 01..15 (`station_01.tscn` .. `station_15.tscn`) w pełni zaimplementowane i przetestowane.
- Wdrożone rekwizyty pamięci, dialogi, mechaniki obserwacji, zsynchronizowane procedury audio.
- Smoke testy w `tests/smoke_test.gd`: wszystkie testy zielone (SMOKE PASS).
- Verify: DOCS PASS + SMOKE PASS.

ZADANIE:
1. Zbuduj scenę `scenes/levels/station_16.tscn` i kontroler `scripts/levels/station_16.gd` dla Przestrzeni 16 (Rozmowa przy stole).
2. Zaimplementuj rekwizyty pamięci (filiżankę Marty, teczkę z poszlakami, zegar ścienny, talerzyk z obrączką, wyjście balkonowe), sekwencję dialogową D-05 i wybór z obrączką.
3. Rozbuduj testy w `tests/smoke_test.gd` o przejście Przestrzeni 16.
4. Wygeneruj zrzuty ekranu przez `godot_console.exe --path . --script res://tools/capture_preview.gd` (`reports/station_16.png`, `reports/station_16_choice.png`).
5. Zweryfikuj projekt komendą `pwsh -NoProfile -File .\tools\verify.ps1`.
6. Zamknij pakiet wykonując `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0034`.
7. Stwórz nowy prompt w `NEXT_SESSION_PROMPT.md` dla PKG-0035.

KRYTERIA AKCEPTACJI
- Przestrzeń 16 (Station 16: Rozmowa przy stole) poprawnie realizuje scenariusz Przestrzeni 16 z FULL_STORY.md, dialog D-05 z DIALOGUE_SCRIPT.md oraz reguły z VISUAL_DESIGN.md.
- Wszystkie dźwięki są generowane proceduralnie w ProceduralAudio bez assetów zewnętrznych.
- Bramka weryfikacyjna `tools/verify.ps1` przechodzi bez błędów.
- CURRENT_STATE.md, SESSION_LOG.md i NEXT_SESSION_PROMPT.md są aktualne.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0034` aby zapisać i udokumentować stan po pracy, a następnie utwórz nowy NEXT_SESSION_PROMPT.md dla kolejnego kroku.
```
