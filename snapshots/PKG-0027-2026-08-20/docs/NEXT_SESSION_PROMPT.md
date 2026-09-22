# Prompt nastepnej sesji

Aktualny pakiet: `PKG-0028: P3 Vertical Slice — Telefon Jakuba (Przestrzeń 10)`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025, D-026, ADR-004 oraz ADR-005 przejąłeś pełną odpowiedzialność za projekt.
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.

CEL SESJI
Kontynuacja fazy P3 (Vertical Slice):
1. Implementacja Przestrzeni 10 z FULL_STORY.md (Telefon Jakuba / Gabinet domowy i korytarz techniczny):
   - Gabinet domowy w modernistycznym mieszkaniu 14 na Osiedlu Tarasowym: drewniane biurko robocze z lampką z zielonym/bursztynowym kloszem, czarny telefon bakelitowy z tarczą numerową i pulsującym dzwonkiem, magnetofon szpulowy z taśmami nagraniowymi Jakuba, ścienna tablica korkowa ze szkicami topologii i schematem mieszkania jako układu kontrolnego.
   - Wdrożenie sceny i dialogu D-04 z DIALOGUE_SCRIPT.md (Telefon Jakuba): dzwoniący telefon bakelitowy; Lena podnosi słuchawkę; słyszy głos Jakuba (konfrontacja z faktem, że brat żyje w tej gałęzi, lecz pamięta inne wydarzenia: „Podaj datę wypadku. — Którego? — Na Linii 4. — Lena, ja tam pracuję. Mamy więcej niż jeden. — Trzeci listopada. Miałeś dwadzieścia lat. — [Cisza] Gdzie jesteś?”).
   - Rekwizyty pamięci w MemoryResonancePoint:
     - `BakelitePhone`: telefon stacjonarny bakelitowy z dzwonkiem i podnoszoną słuchawką,
     - `ReelTapeRecorder`: magnetofon szpulowy z taśmą z nagraniem głosu Jakuba,
     - `TopographyBoard`: tablica korkowa z wycinkami, schematem mieszkania i szkicami Podstruktury,
     - `JakubDeskLamp`: lampka biurkowa rzucająca punktowy stożek światła na telefon i notatki,
     - `TechStorageAirlock`: portal wyjściowy ku Przestrzeni 11 (Pierwsza korekta / Zaułek za osiedlem).
   - Mechanika zakończenia Aktu I: zbadanie dowodów, przeprowadzenie rozmowy telefonicznej D-04 z Jakubem, odtworzenie szpuli nagraniowej, stabilizacja pokoju i przejście przez strefę AirlockZone do Aktu II (Przestrzeń 11).
2. Wdrożenie procedur syntezy dźwięku w ProceduralAudio:
   - `create_bakelite_bell_sound()`: mechaniczny dzwonek telefonu bakelitowego (dwuton mosiężnych czasz 1020/1240 Hz z modulacją uderzeń 20 Hz);
   - `create_handset_pickup_sound()`: mechaniczny klik widełek telefonu i podniesienia słuchawki (850 Hz transient + 180 Hz body);
   - `create_tape_motor_hum_sound()`: szum przesuwu taśmy magnetycznej i obrotu szpul magnetofonu (120 Hz hum + flutter 3200 Hz);
   - `create_dialogue_jakub_blip_sound()`: męski, szorstki ton głosu Jakuba w słuchawce (370 Hz z alikwotami 185/740 Hz i filtrem pasmowym telefonu 300–3400 Hz).
3. Rozbudowa tests/smoke_test.gd oraz tools/capture_preview.gd o scenę Station 10 (`reports/station_10.png`, `reports/station_10_phone.png`).
4. Weryfikacja automatyczna i wizualna oraz zamrożenie snapshotu PKG-0028.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\ROADMAP.md
5. C:\getting_strange\docs\WORKFLOW.md
6. C:\getting_strange\docs\narrative\FULL_STORY.md (Scena 10)
7. C:\getting_strange\docs\narrative\DIALOGUE_SCRIPT.md (Scena D-04)
8. C:\getting_strange\docs\narrative\CONTINUITY_TRACKER.md (Clue R-02, Jakub, Telefon)
9. C:\getting_strange\VISUAL_DESIGN.md

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (`tools/snapshot.ps1`).
- Ostatni pakiet: PKG-0027 (Station 09 Pokój, który nie czeka: łazienka w mieszkaniu 14, lustro z opóźnionym odbiciem, inskrypcja NIE SZUKAJ ORYGINAŁU pod kątem, dialog D-03 z Martą Kurek, stabilizacja korytarza i odryglowanie wyjścia).
- Jesteś w pełni samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.
- Zachowaj konwencje nazewnictwa i folderów (`scripts/`, `scenes/`, `resources/`).

STAN BASELINE (PKG-0027):
- Faza P3 w toku: Przestrzenie 01..09 (`station_01.tscn` .. `station_09.tscn`) w pełni zaimplementowane i przetestowane.
- Wdrożone rekwizyty pamięci, dialogi D-01, D-02, D-03 i D-08, szyfr 0311, inskrypcja NIE SZUKAJ ORYGINAŁU, mechanika opóźnionego odbicia w lustrze.
- Smoke testy w `tests/smoke_test.gd`: wszystkie testy zielone (SMOKE PASS).
- Verify: DOCS PASS + SMOKE PASS.

ZADANIE:
1. Zbuduj scenę `scenes/levels/station_10.tscn` i kontroler `scripts/levels/station_10.gd` dla Przestrzeni 10 (Telefon Jakuba).
2. Zaimplementuj mechanikę odbierania telefonu bakelitowego, odtwarzania taśmy magnetofonowej, dialogu D-04 z Jakubem oraz rekwizyty pamięci.
3. Rozbuduj testy w `tests/smoke_test.gd` o przejście Przestrzeni 10.
4. Wygeneruj zrzuty ekranu przez `godot --path . --script res://tools/capture_preview.gd` (`reports/station_10.png`, `reports/station_10_phone.png`).
5. Zweryfikuj projekt komendą `pwsh -NoProfile -File .\tools\verify.ps1`.
6. Zamknij pakiet wykonując `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0028`.
7. Stwórz nowy prompt w `NEXT_SESSION_PROMPT.md` dla PKG-0029.

KRYTERIA AKCEPTACJI
- Przestrzeń 10 (Station 10: Telefon Jakuba) poprawnie realizuje scenariusz Przestrzeni 10 z FULL_STORY.md i scenę D-04 z DIALOGUE_SCRIPT.md.
- Wszystkie dźwięki są generowane proceduralnie w ProceduralAudio bez assetów zewnętrznych.
- Bramka weryfikacyjna `tools/verify.ps1` przechodzi bez błędów.
- CURRENT_STATE.md, SESSION_LOG.md i NEXT_SESSION_PROMPT.md są aktualne.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0028` aby zapisać i udokumentować stan po pracy, a następnie utwórz nowy NEXT_SESSION_PROMPT.md dla kolejnego kroku.
```
