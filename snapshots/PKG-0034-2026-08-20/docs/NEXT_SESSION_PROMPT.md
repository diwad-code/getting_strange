# Prompt nastepnej sesji

Aktualny pakiet: `PKG-0035: P3 Vertical Slice — Punkt Zgodności 6 (Przestrzeń 17 / Urząd UCP, wezwanie, numer sprawy sprzed 17 dni i powitanie dr Wierzbickiej)`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025, D-026, ADR-004 oraz ADR-005 przejąłeś pełną odpowiedzialność za projekt.
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.

CEL SESJI
Kontynuacja Aktu II fabuły (Korekta) i implementacja Przestrzeni 17 z FULL_STORY.md oraz sceny dialogowej D-06 z DIALOGUE_SCRIPT.md (Punkt Zgodności 6 / Urząd UCP, wezwanie, numer sprawy sprzed 17 dni i powitanie dr Wierzbickiej):
1. Implementacja Przestrzeni 17 w scenes/levels/station_17.tscn i scripts/levels/station_17.gd:
   - Przestrzeń / kompozycja: jasna, modernistyczna poczekalnia i recepcja Punktu Zgodności 6 UCP o estetyce dworcowo-przychodnianej bez krat i uzbrojenia (geometryczne kafelki ceramiczne w kolorze złamanej bieli, drewniane ławki poczekalni, automaty kolejkowe, stacja tuby pneumatycznej, gabinet konsultacyjny dr Wierzbickiej za matową szybą).
   - Rekwizyty i punkty rezonansu pamięci w MemoryResonancePoint (PropType 72..76):
     - `QUEUING_TICKET_DISPENSER`: automat biletowy wydający numer sprawy Leny istniejący w systemie od 17 dni,
     - `COMPLIANCE_WAITING_BENCH`: drewniana ławka poczekalni z wezwaniem urzędowym i afiszem procedur zgodności,
     - `PNEUMATIC_DOSSIER_STATION`: szklano-mosiężna stacja tuby pneumatycznej z przesyłaną kapsułą akt osobowych,
     - `DIAGNOSTIC_MEMORY_PRINTER`: aparat diagnostyczny rejestrujący odpowiedzi sensoryczne Leny (drukujący: KAWA / LINOLEUM / MOKRA WEŁNA),
     - `CONSULTATION_OFFICE_DOOR`: przeszklone drzwi gabinetu dr Wierzbickiej odryglowujące przejście ku Przestrzeni 18 (Wywiad zgodności).
   - Kluczowa scena dialogowa D-06 per DIALOGUE_SCRIPT.md:
     - Powitanie przez dr Wierzbicką: „Dobrze, że przyszła pani jako osoba, nie jako zjawisko.”
     - Przebieg badania sensorycznego: kłamstwo Leny na temat zapachu szpitala (chlor vs kawa/linoleum/mokra wełna).
2. Wdrożenie procedur syntezy dźwięku w ProceduralAudio:
   - `create_dispenser_ticket_sound()`: mechaniczny wysuw i odcięcie biletu z numerem sprawy (960/1920 Hz z perforacją);
   - `create_clinic_intercom_chime_sound()`: trójtonowy gong wywołania poczekalni (F5 698 Hz -> A5 880 Hz -> C6 1046 Hz);
   - `create_pneumatic_tube_whoosh_sound()`: aerodynamiczny świst tuby pneumatycznej (280..1800 Hz z klikiem kapsuły);
   - `create_wierzbicka_printer_sound()`: igłowy aparat diagnostyczny korelacji (720/1440 Hz transient z taktem 18 kroków/s).
3. Rozbudowa tests/smoke_test.gd oraz tools/capture_preview.gd o scenę Station 17 (`reports/station_17.png`, `reports/station_17_interview.png`).
4. Weryfikacja automatyczna i wizualna oraz zamrożenie snapshotu PKG-0035.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\ROADMAP.md
5. C:\getting_strange\docs\WORKFLOW.md
6. C:\getting_strange\docs\narrative\FULL_STORY.md (Scena 17: Punkt Zgodności 6)
7. C:\getting_strange\docs\narrative\DIALOGUE_SCRIPT.md (Scena D-06: Wywiad Wierzbickiej)
8. C:\getting_strange\docs\narrative\CONTINUITY_TRACKER.md (Wiedza Wierzbickiej i bilans poszlak R-01..R-06)
9. C:\getting_strange\VISUAL_DESIGN.md (Sekcja 6.3 i 7: Architektura instytucjonalna UCP, paleta jasna)

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (`tools/snapshot.ps1`).
- Ostatni pakiet: PKG-0034 (Station 16 Rozmowa przy stole: kuchnia mieszkania 14 nocą, klejona filiżanka Marty, teczka poszlak R-01..R-06, interaktywny wybór obrączki i odryglowanie wyjścia balkonowego).
- Jesteś w pełni samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.
- Zachowaj konwencje nazewnictwa i folderów (`scripts/`, `scenes/`, `resources/`).

STAN BASELINE (PKG-0034):
- Faza P3 w toku: Przestrzenie 01..16 (`station_01.tscn` .. `station_16.tscn`) w pełni zaimplementowane i przetestowane.
- Wdrożone rekwizyty pamięci, dialogi, mechaniki obserwacji, zsynchronizowane procedury audio.
- Smoke testy w `tests/smoke_test.gd`: wszystkie testy zielone (SMOKE PASS).
- Verify: DOCS PASS + SMOKE PASS.

ZADANIE:
1. Zbuduj scenę `scenes/levels/station_17.tscn` i kontroler `scripts/levels/station_17.gd` dla Przestrzeni 17 (Punkt Zgodności 6).
2. Zaimplementuj rekwizyty pamięci (automat biletowy, ławkę poczekalni, stację pneumatyczną, drukarkę diagnostyczną, drzwi gabinetu), sekwencję dialogową D-06 i powitanie dr Wierzbickiej.
3. Rozbuduj testy w `tests/smoke_test.gd` o przejście Przestrzeni 17.
4. Wygeneruj zrzuty ekranu przez `godot_console.exe --path . --script res://tools/capture_preview.gd` (`reports/station_17.png`, `reports/station_17_interview.png`).
5. Zweryfikuj projekt komendą `pwsh -NoProfile -File .\tools\verify.ps1`.
6. Zamknij pakiet wykonując `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0035`.
7. Stwórz nowy prompt w `NEXT_SESSION_PROMPT.md` dla PKG-0036.

KRYTERIA AKCEPTACJI
- Przestrzeń 17 (Station 17: Punkt Zgodności 6) poprawnie realizuje scenariusz Przestrzeni 17 z FULL_STORY.md, dialog D-06 z DIALOGUE_SCRIPT.md oraz reguły z VISUAL_DESIGN.md.
- Wszystkie dźwięki są generowane proceduralnie w ProceduralAudio bez assetów zewnętrznych.
- Bramka weryfikacyjna `tools/verify.ps1` przechodzi bez błędów.
- CURRENT_STATE.md, SESSION_LOG.md i NEXT_SESSION_PROMPT.md są aktualne.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0035` aby zapisać i udokumentować stan po pracy, a następnie utwórz nowy NEXT_SESSION_PROMPT.md dla kolejnego kroku.
```
