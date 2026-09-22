# Prompt nastepnej sesji

Aktualny pakiet: `PKG-0027: P3 Vertical Slice — Pokój, który nie czeka (Przestrzeń 09)`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025, D-026, ADR-004 oraz ADR-005 przejąłeś pełną odpowiedzialność za projekt.
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.

CEL SESJI
Kontynuacja fazy P3 (Vertical Slice):
1. Implementacja Przestrzeni 09 z FULL_STORY.md (Pokój, który nie czeka / Łazienka i lustro):
   - Wnętrze łazienki w modernistycznym mieszkaniu 14 na Osiedlu Tarasowym: kafelki ceramiczne w geometrycznym układzie, żeliwna/chromowana armatura, zlew, lustro łazienkowe z opóźnionym odbiciem i skrobaniem na szkle.
   - Mechanika geometrii zależnej od kąta obserwacji (#motionviz-observed-discontinuity): korytarz łazienkowy / odległość do drzwi wyjściowych zmienia długość, gdy Lena patrzy wprost w lustro; wdrożenie praktycznej instrukcji Marty D-03 („Zostaw drzwi w odbiciu. Idź, nie sprawdzaj.” — gracz pokonuje odcinek poruszając się tyłem do lustra lub utrzymując stałą relację wzrokową).
   - Odkrycie kluczowej poszlaki (Clue R-02): na szkle lustra lokalna Lena wydrapała inskrypcję `NIE SZUKAJ ORYGINAŁU` (niewidoczną od frontu pod kątem prostym, stającą się czytelną przy bocznym załamaniu światła).
   - Rekwizyty pamięci w MemoryResonancePoint: umywalka i bateria łazienkowa, lustro ze zmienną geometrią, wydrapana inskrypcja na szkle, szafka apteczna z lekami na stabilizację korelacji.
   - Przejście (AirlockZone) ku Przestrzeni 10 (Telefon Jakuba).
2. Wdrożenie procedur syntezy dźwięku w ProceduralAudio:
   - `create_tile_footstep_sound()`: mineralne, szkliste echo kroków na mokrych płytkach ceramicznych (450/780 Hz);
   - `create_water_pipe_hiss_sound()`: szum wody pod ciśnieniem w rurach żeliwnych z metalicznym rezonansem (110/320 Hz);
   - `create_glass_scratch_sound()`: pisk skrobania igłą/ostrzem po szkle (2400/3800 Hz);
   - `create_mirror_shimmer_sound()`: dysonans fazowy lustra (A5 880 Hz + B5 987 Hz z dryfem 0.4 Hz).
3. Rozbudowa tests/smoke_test.gd oraz tools/capture_preview.gd o scenę Station 09 (`reports/station_09.png`, `reports/station_09_mirror.png`).
4. Weryfikacja automatyczna i wizualna oraz zamrożenie snapshotu PKG-0027.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\ROADMAP.md
5. C:\getting_strange\docs\WORKFLOW.md
6. C:\getting_strange\docs\narrative\FULL_STORY.md (Scena 09)
7. C:\getting_strange\docs\narrative\DIALOGUE_SCRIPT.md (Scena D-03)
8. C:\getting_strange\docs\narrative\CONTINUITY_TRACKER.md (Poszlaka R-02)
9. C:\getting_strange\VISUAL_DESIGN.md

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (`tools/snapshot.ps1`).
- Ostatni pakiet: PKG-0026 (Station 08 Mieszkanie po kimś: modernistyczne wnętrze mieszkania 14, rekwizyty podwójnego zastosowania, dialog z Martą Kurek, zamek szyfrowy 0311 szuflady z notatkami Podstruktury, zlewka-doniczka, pamiątka Jakuba, wieszak z butami sprzed 17 dni).
- Jesteś w pełni samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.
- Zachowaj konwencje nazewnictwa i folderów (`scripts/`, `scenes/`, `resources/`).

STAN BASELINE (PKG-0026):
- Faza P3 w toku: Przestrzenie 01, 02, 03, 04, 05, 06, 07 oraz 08 (`station_01.tscn` .. `station_08.tscn`) w pełni zaimplementowane i przetestowane.
- Wdrożone rekwizyty pamięci, dialogi D-01, D-02 i D-08, szyfr 0311, mechanika asynchronicznego cienia, transformacje geometryczne.
- Smoke testy w `tests/smoke_test.gd`: wszystkie testy zielone (SMOKE PASS).
- Verify: DOCS PASS + SMOKE PASS.

ZADANIE:
1. Zbuduj scenę `scenes/levels/station_09.tscn` i kontroler `scripts/levels/station_09.gd` dla Przestrzeni 09 (Pokój, który nie czeka).
2. Zaimplementuj mechanikę korytarza o zmiennej geometrii i rekwizyty pamięci (lustro z opóźnionym odbiciem, inskrypcja NIE SZUKAJ ORYGINAŁU, bateria łazienkowa).
3. Rozbuduj testy w `tests/smoke_test.gd` o przejście Przestrzeni 09.
4. Wygeneruj zrzuty ekranu przez `godot --path . --script res://tools/capture_preview.gd` (`reports/station_09.png`, `reports/station_09_mirror.png`).
5. Zweryfikuj projekt komendą `pwsh -NoProfile -File .\tools\verify.ps1`.
6. Zamknij pakiet wykonując `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0027`.
7. Stwórz nowy prompt w `NEXT_SESSION_PROMPT.md` dla PKG-0028.

KRYTERIA AKCEPTACJI
- Przestrzeń 09 (Station 09: Pokój, który nie czeka) poprawnie realizuje scenariusz Przestrzeni 09 z FULL_STORY.md i mechanikę obserwowanej nieciągłości.
- Wszystkie dźwięki są generowane proceduralnie w ProceduralAudio bez assetów zewnętrznych.
- Bramka weryfikacyjna `tools/verify.ps1` przechodzi bez błędów.
- CURRENT_STATE.md, SESSION_LOG.md i NEXT_SESSION_PROMPT.md są aktualne.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0027` aby zapisać i udokumentować stan po pracy, a następnie utwórz nowy NEXT_SESSION_PROMPT.md dla kolejnego kroku.
```
