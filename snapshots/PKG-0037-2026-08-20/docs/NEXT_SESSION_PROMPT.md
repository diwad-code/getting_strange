# Prompt nastepnej sesji

Aktualny pakiet: `PKG-0038: P3 Vertical Slice — Sala Szymona (Przestrzeń 20 / Pokój Szymona Bery, rysunek studni i skażenia wody, prywatna pamięć o córce Idze, wybór zakotwiczenia rysunku)`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025, D-026, ADR-004 oraz ADR-005 przejąłeś pełną odpowiedzialność za projekt.
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.

CEL SESJI
Kontynuacja Aktu II fabuły (Korekta) i implementacja Przestrzeni 20 z FULL_STORY.md oraz sceny dialogowej D-08 (Sala Szymona / Pokój Szymona Bery, rysunek studni, niepotwierdzona córka Iga, konfrontacja faktu publicznego z prywatną więzią):
1. Implementacja Przestrzeni 20 w scenes/levels/station_20.tscn i scripts/levels/station_20.gd:
   - Sala Szymona: izolatka adaptacyjna UCP w Punkcie Zgodności 6 — chłodna neutralna biel i szarość, surowe łóżko terapeutyczne, stolik z rysunkiem studni, lampa inspekcyjna z lupą, raport hydrologiczny UCP potwierdzający naprawę skażenia bez danych zgłaszającego, postać Szymona Bery.
   - Rekwizyty i punkty rezonansu pamięci w MemoryResonancePoint (PropType 87..91):
     - SZYMON_BERA (87): postać Szymona Bery, dialog D-08;
     - WELL_DRAWING (88): rysunek studni kredkami z cieńszym papierem po wytartym podpisie;
     - HYDROLOGY_REPORT (89): oficjalny raport UCP potwierdzający naprawę ujęcia wody przy szkole bez osoby;
     - ERASED_SIGNATURE_MAGNIFIER (90): lupa inspekcyjna ukazująca mikro-ślady ołówka litery "Iga";
     - SZYMON_ROOM_EXIT (91): drzwi sali przesuwające się przy wypowiadaniu imienia, odblokowane po D-08 i wyborze dyspozycji rysunku.
   - Kluczowa scena dialogowa D-08 "Szymon — sprawdź studnię" (10 kwestii):
     - Szymon pokazuje rysunek: "Narysowała ją za wysoko. Studnia jest niżej od szkoły. Zawsze jej to mówiłem.";
     - Lena zauważa wytarty podpis: "Wytarli. Papier jest cieńszy.";
     - Imię córki: "Iga. Nie zapisuj od razu. Najpierw powiedz." — Lena dwukrotnie wypowiada "Iga";
     - Reakcja otoczenia: drzwi sali przesuwają się o kilka centymetrów ("Widzisz? Nie lubią, kiedy są dwie osoby.");
     - Szymon: "Ona nie musi zatruć całego miasta, żeby być moją córką."
   - Wybór mechaniczny dyspozycji rysunku studni: zakotwiczenie rysunku (Anchor — zachowanie dowodu więzi) / oddanie Wierzbickiej / brak interwencji.
2. Wdrożenie procedur syntezy dźwięku w ProceduralAudio:
   - create_crayon_drawing_rustle_sound(): szelest papieru rysunkowego z kredkowym zatarciem (600..2400 Hz);
   - create_well_water_drip_sound(): stłumione echo kapania wody w głębokiej studni (160 Hz + 480 Hz echo);
   - create_szymon_dialogue_blip_sound(): drżący, starczy tembr głosu Szymona Bery (260 Hz z modulacją 3.5 Hz);
   - create_door_creak_shift_sound(): ciche mechaniczne przesunięcie ramy drzwi o kilka centymetrów (220/440 Hz + tarcie żelaza).
3. Rozbudowa tests/smoke_test.gd oraz tools/capture_preview.gd o scenę Station 20 (reports/station_20.png, reports/station_20_szymon.png).
4. Weryfikacja automatyczna i wizualna oraz zamrożenie snapshotu PKG-0038.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\ROADMAP.md
5. C:\getting_strange\docs\WORKFLOW.md
6. C:\getting_strange\docs\narrative\FULL_STORY.md (Scena 20: Sala Szymona)
7. C:\getting_strange\docs\narrative\DIALOGUE_SCRIPT.md (D-08: Szymon — „sprawdź studnię”, linie 276-306)
8. C:\getting_strange\docs\narrative\CONTINUITY_TRACKER.md (Poszlaki i stany zgodności)

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (tools/snapshot.ps1).
- Ostatni pakiet: PKG-0037 (Station 19 Sala Modeli: Model bez oryginału, dwie równorzędne mapy Linii 4 — lewa 140 ewakuowanych, prawa 17 świadków na ścianie nośnej; D-07 dialog o braku pierwotnej wersji i odpowiedzialności z terminem).
- Jesteś w pełni samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.
- Zachowaj konwencje nazewnictwa i folderów (scripts/, scenes/, resources/).

STAN BASELINE (PKG-0037):
- Faza P3 w toku: Przestrzenie 01..19 (station_01.tscn .. station_19.tscn) w pełni zaimplementowane i przetestowane.
- Wdrożone rekwizyty pamięci, dialogi, mechaniki sensoryczne, zoptymalizowana selektywna synteza audio.
- PropType enum w MemoryResonancePoint kończy się na 86 (MODEL_ROOM_EXIT). Kolejne typy: 87..91.
- Ostatnia metoda ProceduralAudio: create_model_room_door_release_sound(). Nowe metody doklejać po niej.
- Smoke testy w tests/smoke_test.gd: wszystkie testy zielone (SMOKE PASS).
- Verify: DOCS PASS + SMOKE PASS.

ZADANIE:
1. Zbuduj scenę scenes/levels/station_20.tscn i kontroler scripts/levels/station_20.gd dla Przestrzeni 20 (Sala Szymona).
2. Zaimplementuj rekwizyty pamięci PropType 87..91, sekwencję dialogową D-08 "Szymon — sprawdź studnię" oraz mechanikę dyspozycji rysunku studni.
3. Rozbuduj testy w tests/smoke_test.gd o przejście Przestrzeni 20.
4. Wygeneruj zrzuty ekranu przez capture_preview.gd (reports/station_20.png, reports/station_20_szymon.png).
5. Zweryfikuj projekt komendą pwsh -NoProfile -File .\tools\verify.ps1.
6. Zamknij pakiet wykonując pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0038.
7. Stwórz nowy prompt w NEXT_SESSION_PROMPT.md dla PKG-0039.

KRYTERIA AKCEPTACJI
- Przestrzeń 20 (Station 20: Sala Szymona) poprawnie realizuje scenariusz z FULL_STORY.md, dialog D-08 z DIALOGUE_SCRIPT.md i paletę VISUAL_DESIGN.md.
- Wszystkie dźwięki są generowane proceduralnie w ProceduralAudio bez assetów zewnętrznych.
- Bramka weryfikacyjna tools/verify.ps1 przechodzi bez błędów (DOCS PASS + SMOKE PASS).
- CURRENT_STATE.md, SESSION_LOG.md i NEXT_SESSION_PROMPT.md są aktualne.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0038 aby zapisać i udokumentować stan po pracy, a następnie utwórz nowy NEXT_SESSION_PROMPT.md dla kolejnego kroku.
```
