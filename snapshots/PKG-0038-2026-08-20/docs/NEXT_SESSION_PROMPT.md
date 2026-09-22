# Prompt nastepnej sesji

Aktualny pakiet: `PKG-0039: P3 Vertical Slice — Cena ulgi (Przestrzeń 21 / Korekta Szymona, wymazanie imienia córki, rozdzielenie faktu publicznego od więzi osobistej)`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025, D-026, ADR-004 oraz ADR-005 przejąłeś pełną odpowiedzialność za projekt.
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.

CEL SESJI
Kontynuacja Aktu II fabuły (Korekta) i implementacja Przestrzeni 21 z FULL_STORY.md (Cena ulgi / Pokój zabiegowy i korekta Szymona Bery, wymazanie traumy i imienia córki, konsekwencja wyboru rysunku, rozdzielenie faktu publicznego od więzi prywatnej):
1. Implementacja Przestrzeni 21 w scenes/levels/station_21.tscn i scripts/levels/station_21.gd:
   - Pokój zabiegowo-adaptacyjny Punktu Zgodności 6: geometryczny kadr 640x360 z chłodnym oświetleniem pasmowym i aparaturą sedatywno-korekcyjną UCP.
   - Rekwizyty i punkty rezonansu pamięci w MemoryResonancePoint (PropType 92..96):
     - SZYMON_POST_CORRECTION (92): uspokojony Szymon Bera w fotelu adaptacyjnym po zabiegu sedacji;
     - ANESTHESIA_TERMINAL (93): konsola UCP rejestrująca wymazanie paniki i stabilizację pulsu;
     - FILTERED_DOSSIER_SLOT (94): kaseta archiwizacyjna UCP z nowym oficjalnym wpisem ("SKORZYSTANO Z RAPORTU HYDROLOGICZNEGO / AUTOR: ANONIMOWY");
     - DRAWING_DISPOSITION_PEDESTAL (95): postument z rysunkiem (w zależności od wyboru w Scenie 20: zakotwiczony rysunek z miejscem po kimś vs czysta teczka UCP);
     - STATION_21_EXIT (96): śluza wyjściowa z Punktu Zgodności 6 ku strefie tranzytowej Uległości (Przestrzeń 22).
   - Dialog środowiskowy i rezonans fabularny po korekcie per FULL_STORY.md i DIALOGUE_SCRIPT.md (linie 307-316):
     - Szymon po zabiegu: "Kto to narysował?" — Lena: "Iga." — Szymon próbuje powtórzyć, aparat sedacji emituje szum, Szymon nie potrafi wymówić imienia: "Nie zabieraj kartki. To miejsce po kimś.";
     - Jeśli rysunek zakotwiczono: Szymon pamięta brak ("kogoś brakuje"), choć nie zna imienia;
     - Jeśli oddano: UCP utrwaliło dane o skażeniu wody, a osobę usunęło bez śladu.
     - Gracz po raz pierwszy doświadcza rozdzielenia faktu publicznego od prywatnej więzi.
   - Odryglowanie wyjścia do Przestrzeni 22 (Uległość).
2. Wdrożenie procedur syntezy dźwięku w ProceduralAudio:
   - create_anesthetic_hum_sound(): niski szum fali sedacyjnej UCP (110 Hz z filtracją dolnoprzepustową i modulacją 2 Hz);
   - create_sedation_monitor_blip_sound(): miękki, stłumiony sygnał monitora funkcji życiowych (520 Hz z gładkim opadaniem);
   - create_erased_name_glitch_sound(): asynchroniczny filtr usuwający formant głosu przy próbie wymówienia imienia (szum 800..2000 Hz z wycięciem pasmowym);
   - create_station21_airlock_sound(): pneumatyczny dźwięk odryglowania śluzy wyjściowej ku strefie Uległości (320 Hz + 740 Hz release).
3. Rozbudowa tests/smoke_test.gd oraz tools/capture_preview.gd o scenę Station 21 (reports/station_21.png, reports/station_21_szymon.png).
4. Weryfikacja automatyczna i wizualna oraz zamrożenie snapshotu PKG-0039.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\ROADMAP.md
5. C:\getting_strange\docs\WORKFLOW.md
6. C:\getting_strange\docs\narrative\FULL_STORY.md (Scena 21: Cena ulgi)
7. C:\getting_strange\docs\narrative\DIALOGUE_SCRIPT.md (D-08 epilog, linie 307-316)
8. C:\getting_strange\docs\narrative\CONTINUITY_TRACKER.md (Poszlaki i stany zgodności)

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (tools/snapshot.ps1).
- Ostatni pakiet: PKG-0038 (Station 20 Sala Szymona: izolatka Szymona Bery, rysunek studni i skażenia, lupa z mikro-śladami grafitu "Iga", dialog D-08, przesunięcie ramy drzwi po wypowiedzeniu imienia Igi, wybór dyspozycji rysunku).
- Jesteś w pełni samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.
- Zachowaj konwencje nazewnictwa i folderów (scripts/, scenes/, resources/).

STAN BASELINE (PKG-0038):
- Faza P3 w toku: Przestrzenie 01..20 (station_01.tscn .. station_20.tscn) w pełni zaimplementowane i przetestowane.
- Wdrożone rekwizyty pamięci, dialogi, mechaniki sensoryczne, zoptymalizowana selektywna synteza audio.
- PropType enum w MemoryResonancePoint kończy się na 91 (SZYMON_ROOM_EXIT). Kolejne typy: 92..96.
- Ostatnia metoda ProceduralAudio: create_door_creak_shift_sound(). Nowe metody doklejać po niej.
- Narzędzie capture.ps1 w tools/capture.ps1.
- Smoke testy w tests/smoke_test.gd: wszystkie testy zielone (SMOKE PASS).
- Verify: DOCS PASS + SMOKE PASS.

ZADANIE:
1. Zbuduj scenę scenes/levels/station_21.tscn i kontroler scripts/levels/station_21.gd dla Przestrzeni 21 (Cena ulgi).
2. Zaimplementuj rekwizyty pamięci PropType 92..96, sekwencję rozmowy z uspokojonym Szymonem i niemożność wymówienia imienia Igi oraz rejestrację rozdzielenia faktu od więzi.
3. Rozbuduj testy w tests/smoke_test.gd o przejście Przestrzeni 21.
4. Wygeneruj zrzuty ekranu przez tools/capture.ps1 (reports/station_21.png).
5. Zweryfikuj projekt komendą pwsh -NoProfile -File .\tools\verify.ps1.
6. Zamknij pakiet wykonując pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0039.
7. Stwórz nowy prompt w NEXT_SESSION_PROMPT.md dla PKG-0040.

KRYTERIA AKCEPTACJI
- Przestrzeń 21 (Station 21: Cena ulgi) poprawnie realizuje scenariusz z FULL_STORY.md i paletę VISUAL_DESIGN.md.
- Wszystkie dźwięki są generowane proceduralnie w ProceduralAudio bez assetów zewnętrznych.
- Bramka weryfikacyjna tools/verify.ps1 przechodzi bez błędów (DOCS PASS + SMOKE PASS).
- CURRENT_STATE.md, SESSION_LOG.md i NEXT_SESSION_PROMPT.md są aktualne.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0039 aby zapisać i udokumentować stan po pracy, a następnie utwórz nowy NEXT_SESSION_PROMPT.md dla kolejnego kroku.
```
