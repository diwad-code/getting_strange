# Prompt nastepnej sesji

Aktualny pakiet: `PKG-0037: P3 Vertical Slice — Model bez oryginału (Przestrzeń 19 / Sala Modeli, dwie równoprawne mapy Linii 4, konfrontacja z brakiem potwierdzonej pierwszej wersji i rozstrzygnięcie sporu o adres)`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025, D-026, ADR-004 oraz ADR-005 przejąłeś pełną odpowiedzialność za projekt.
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.

CEL SESJI
Kontynuacja Aktu II fabuły (Korekta) i implementacja Przestrzeni 19 z FULL_STORY.md oraz sceny dialogowej D-07 (Model bez oryginału / Sala Modeli, dwie równoprawne mapy Linii 4, rozstrzygnięcie sporu o adres):
1. Implementacja Przestrzeni 19 w scenes/levels/station_19.tscn i scripts/levels/station_19.gd:
   - Sala Modeli: neutralna, naukowa, pozbawiona temperatury — szarobeżowy gips, zimna biel (stół modeli), matowy aluminium, niebieskawa stal. Centralny stół z dwoma równoprawnymi modelami schematu Linii 4, ścienna mapa z dwiema klatkami schodowymi (lewa: ulica; prawa: ściana nośna), rejestr jedenastu osób, których nie ma w żadnej tabeli, wyjście ku Przestrzeni 20 (Sala Szymona).
   - Rekwizyty i punkty rezonansu pamięci w MemoryResonancePoint (PropType 82..86):
     - MODEL_DISPLAY_TABLE (82): stół z dwoma równoprawnymi modelami schematu Linii 4;
     - STAIRCASE_MAP_LEFT (83): lewy schemat — klatka kończy się na ulicy (wersja stabilizowana);
     - STAIRCASE_MAP_RIGHT (84): prawy schemat — klatka kończy się na ścianie nośnej (wersja 17 osób);
     - ELEVEN_PERSONS_LEDGER (85): teczka z listą 11 osób, których nie ma w żadnej tabeli;
     - MODEL_ROOM_EXIT (86): wyjście ku Przestrzeni 20 (Sala Szymona), odblokowane po D-07.
   - Kluczowa scena dialogowa D-07 "Wierzbicka pokazuje schody" (8 kwestii):
     - Wierzbicka pokazuje dwie równoprawne mapy — nie twierdzi, że jedna jest fałszywa;
     - Lena pyta która jest prawdziwa; Wierzbicka odpowiada "Ta, po której za dwie minuty zejdzie 140 osób";
     - Spór zamknięty jako wspólne ujawnienie braku potwierdzonej pierwszej wersji;
     - Clue: "Nikt nie zginął. Proszę tego nie pomniejszać..."; "A kogo przesunęliście?"; "Tego właśnie jeszcze nie wiemy."
2. Wdrożenie procedur syntezy dźwięku w ProceduralAudio:
   - create_model_table_resonance_sound(): 528 Hz krystaliczny rezonans modeli (harmonia dwóch wersji);
   - create_paper_map_rustle_sound(): szmer papierowej mapy schematu (900..3600 Hz tarcie kartonu);
   - create_ledger_page_turn_sound(): obrót strony rejestru jedenastu (700..2800 Hz tarcie + zagięcie 440 Hz);
   - create_model_room_door_release_sound(): zwolnienie mechanizmu ryglującego Sali Modeli (680 Hz zasuwka + 1340 Hz).
3. Rozbudowa tests/smoke_test.gd oraz tools/capture_preview.gd o scenę Station 19 (reports/station_19.png, reports/station_19_models.png).
4. Weryfikacja automatyczna i wizualna oraz zamrożenie snapshotu PKG-0037.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\ROADMAP.md
5. C:\getting_strange\docs\WORKFLOW.md
6. C:\getting_strange\docs\narrative\FULL_STORY.md (Scena 19: Model bez oryginału)
7. C:\getting_strange\docs\narrative\DIALOGUE_SCRIPT.md (D-07: Wierzbicka pokazuje schody, linie 252-274)
8. C:\getting_strange\docs\narrative\CONTINUITY_TRACKER.md (Poszlaki i stany zgodności)

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (tools/snapshot.ps1).
- Ostatni pakiet: PKG-0036 (Station 18 Wywiad zgodności: gabinet dr Wierzbickiej, sensoryczny wywiad — Lena kłamie, galwanometr przyjmuje kłamstwo jako wersję oficjalną, naprężenia Podstruktury narastają, Sala Modeli odblokowana).
- Jesteś w pełni samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.
- Zachowaj konwencje nazewnictwa i folderów (scripts/, scenes/, resources/).

STAN BASELINE (PKG-0036):
- Faza P3 w toku: Przestrzenie 01..18 (station_01.tscn .. station_18.tscn) w pełni zaimplementowane i przetestowane.
- Wdrożone rekwizyty pamięci, dialogi, mechaniki sensoryczne, zsynchronizowane procedury audio.
- PropType enum w MemoryResonancePoint kończy się na 81 (MODEL_ROOM_AIRLOCK). Kolejne typy: 82..86.
- Ostatnia metoda ProceduralAudio: create_wierzbicka_stamp_sound(). Nowe metody doklejać po niej.
- Smoke testy w tests/smoke_test.gd: wszystkie testy zielone (SMOKE PASS).
- Verify: DOCS PASS + SMOKE PASS.

ZADANIE:
1. Zbuduj scenę scenes/levels/station_19.tscn i kontroler scripts/levels/station_19.gd dla Przestrzeni 19 (Sala Modeli).
2. Zaimplementuj rekwizyty pamięci PropType 82..86, sekwencję dialogową D-07 "Wierzbicka pokazuje schody" z konfrontacją dwóch równoprawnych map i rozstrzygnięciem sporu.
3. Rozbuduj testy w tests/smoke_test.gd o przejście Przestrzeni 19.
4. Wygeneruj zrzuty ekranu przez capture_preview.gd (reports/station_19.png, reports/station_19_models.png).
5. Zweryfikuj projekt komendą pwsh -NoProfile -File .\tools\verify.ps1.
6. Zamknij pakiet wykonując pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0037.
7. Stwórz nowy prompt w NEXT_SESSION_PROMPT.md dla PKG-0038.

KRYTERIA AKCEPTACJI
- Przestrzeń 19 (Station 19: Model bez oryginału) poprawnie realizuje scenariusz z FULL_STORY.md, dialog D-07 z DIALOGUE_SCRIPT.md i paletę VISUAL_DESIGN.md (neutralna Sala Modeli).
- Obie mapy schodów (lewa/prawa) są wizualnie odróżnialne, żadna nie jest oznaczona jako fałszywa.
- Wszystkie dźwięki są generowane proceduralnie w ProceduralAudio bez assetów zewnętrznych.
- Bramka weryfikacyjna tools/verify.ps1 przechodzi bez błędów (DOCS PASS + SMOKE PASS).
- CURRENT_STATE.md, SESSION_LOG.md i NEXT_SESSION_PROMPT.md są aktualne.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0037 aby zapisać i udokumentować stan po pracy, a następnie utwórz nowy NEXT_SESSION_PROMPT.md dla kolejnego kroku.
```
