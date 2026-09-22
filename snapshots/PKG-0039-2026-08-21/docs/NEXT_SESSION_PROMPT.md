# Prompt nastepnej sesji

Aktualny pakiet: `PKG-0040: P3 Vertical Slice — Uległość (Przestrzeń 22 / Biometryczna bramka tożsamości, przyjęcie reguły lokalnej Leny, wspomnienie malowania mieszkania i utrata twarzy pielęgniarki)`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025, D-026, ADR-004 oraz ADR-005 przejąłeś pełną odpowiedzialność za projekt.
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.

CEL SESJI
Kontynuacja Aktu II fabuły (Korekta) i implementacja Przestrzeni 22 z FULL_STORY.md (Uległość / Biometryczna bramka tożsamości, mechanika Uległości jako przyjęcie reguły lokalnej Leny, sensoryczne wspomnienie malowania mieszkania i przesunięcie autobiograficzne — utrata twarzy pielęgniarki po śmierci Jakuba):
1. Implementacja Przestrzeni 22 w scenes/levels/station_22.tscn i scripts/levels/station_22.gd:
   - Przestrzeń tranzytowo-weryfikacyjna Punktu Zgodności 6: kompozycja 640x360 w palecie chłodnego gipsu, miedzi i bursztynu relacyjnego (#141e20, #22302a, #d4a359, #6db3a8).
   - Rekwizyty i punkty rezonansu pamięci w MemoryResonancePoint (PropType 97..101):
     - BIOMETRIC_IDENTITY_GATE (97): masywna bramka tranzytowa z czytnikiem konturu dłoni, wymagająca profilu lokalnej Leny;
     - COMPLIANCE_CONTACT_REGISTER (98): terminal UCP z polem kontaktu alarmowego (Marta Kurek — autoryzacja więzi);
     - RING_FITTING_SCANNER (99): konsola sprawdzająca obecność złotej obrączki na dłoni protagonistki;
     - PAINT_RESIN_RESONANCE_SLAB (100): płyta sensoryczna wywołująca obce wspomnienie zapachu farby emulsyjnej i malowania mieszkania 14 z Martą;
     - STATION_22_EXIT (101): odryglowane wrota do Pokoju projektantki (Przestrzeń 23).
   - Mechanika Uległości (Yield / D-019, FULL_STORY.md Scena 22):
     - Gracz przyjmuje tożsamość lokalnej Leny (założenie obrączki + zatwierdzenie Marty jako kontaktu alarmowego);
     - Doświadczenie sensorycznego napływu pamięci: ciepły bursztynowy rozbłysk i odtworzenie zapachu świeżej farby emulsyjnej na ścianach przedpokoju;
     - Koszt biograficzny: wymazanie szczegółu z własnej gałęzi — twarzy pielęgniarki po śmierci Jakuba (brak paska zdrowia, czyste przesunięcie narracyjno-faktograficzne);
     - Sprawdzenie pamięci weryfikowane jak pomiar inżynierski.
   - Odryglowanie wyjścia do Przestrzeni 23 (Pokój projektantki).
2. Wdrożenie procedur syntezy dźwięku w ProceduralAudio:
   - create_biometric_gate_scan_sound(): skan biometryczny konturu dłoni (480 Hz ze wznoszącym świstem 1920 Hz i potwierdzeniem rezonansowym);
   - create_ring_resonance_hum_sound(): subtelny ciepły rezonans złota i ciała (1200 Hz z mikro-wibracją 6 Hz i bursztynowym nasyceniem);
   - create_paint_memory_recall_sound(): sensoryczny ton napływu obcej pamięci (528 Hz z modulacją szmeru wałka malarskiego i oddechem farby);
   - create_biographical_erasure_glitch_sound(): cichy, głęboki uskok pamięci autobiograficznej (sub-bas 62 Hz z mechanicznym cięciem pasma i opadającym wygaszeniem).
3. Rozbudowa tests/smoke_test.gd oraz tools/capture_preview.gd o scenę Station 22 (reports/station_22.png, reports/station_22_yield.png).
4. Weryfikacja automatyczna i wizualna oraz zamrożenie snapshotu PKG-0040.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\ROADMAP.md
5. C:\getting_strange\docs\WORKFLOW.md
6. C:\getting_strange\docs\narrative\FULL_STORY.md (Scena 22: Uległość)
7. C:\getting_strange\docs\narrative\DIALOGUE_SCRIPT.md (Scena dialogowa i kwestie pamięci)
8. C:\getting_strange\docs\narrative\CONTINUITY_TRACKER.md (Poszlaki i stany zgodności)

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (tools/snapshot.ps1).
- Ostatni pakiet: PKG-0039 (Station 21 Cena ulgi: sala zabiegowo-sedacyjna Szymona Bery, aparatura anestezji, niemożność wymówienia imienia Igi, rozdzielenie faktu publicznego od więzi prywatnej).
- Jesteś w pełni samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.
- Zachowaj konwencje nazewnictwa i folderów (scripts/, scenes/, resources/).

STAN BASELINE (PKG-0039):
- Faza P3 w toku: Przestrzenie 01..21 (station_01.tscn .. station_21.tscn) w pełni zaimplementowane i przetestowane.
- Wdrożone rekwizyty pamięci, dialogi, mechaniki sensoryczne, zoptymalizowana selektywna synteza audio.
- PropType enum w MemoryResonancePoint kończy się na 96 (STATION_21_EXIT). Kolejne typy: 97..101.
- Ostatnia metoda ProceduralAudio: create_station21_airlock_sound(). Nowe metody doklejać po niej.
- Narzędzie capture.ps1 w tools/capture.ps1.
- Smoke testy w tests/smoke_test.gd: wszystkie testy zielone (SMOKE PASS).
- Verify: DOCS PASS + SMOKE PASS.

ZADANIE:
1. Zbuduj scenę scenes/levels/station_22.tscn i kontroler scripts/levels/station_22.gd dla Przestrzeni 22 (Uległość).
2. Zaimplementuj rekwizyty pamięci PropType 97..101, procedurę przyjęcia tożsamości lokalnej Leny, napływ pamięci malowania mieszkania i przesunięcie autobiograficzne (utratę twarzy pielęgniarki).
3. Rozbuduj testy w tests/smoke_test.gd o przejście Przestrzeni 22.
4. Wygeneruj zrzuty ekranu przez tools/capture.ps1 (reports/station_22.png, reports/station_22_yield.png).
5. Zweryfikuj projekt komendą pwsh -NoProfile -File .\tools\verify.ps1.
6. Zamknij pakiet wykonując pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0040.
7. Stwórz nowy prompt w NEXT_SESSION_PROMPT.md dla PKG-0041.

KRYTERIA AKCEPTACJI
- Przestrzeń 22 (Station 22: Uległość) poprawnie realizuje scenariusz z FULL_STORY.md i paletę VISUAL_DESIGN.md.
- Wszystkie dźwięki są generowane proceduralnie w ProceduralAudio bez assetów zewnętrznych.
- Bramka weryfikacyjna tools/verify.ps1 przechodzi bez błędów (DOCS PASS + SMOKE PASS).
- CURRENT_STATE.md, SESSION_LOG.md i NEXT_SESSION_PROMPT.md są aktualne.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0040 aby zapisać i udokumentować stan po pracy, a następnie utwórz nowy NEXT_SESSION_PROMPT.md dla kolejnego kroku.
```

